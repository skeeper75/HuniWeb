# design-decisions.md — 디지털인쇄 가격엔진 설계 결정·흡수·trade-off·컨펌큐

> **핵심 설계가(hpe-engine-designer) 산출 3/4.** 설계 결정의 근거·흡수 적용·search-before-mint·trade-off·컨펌큐.
> 검증가(hpe-validator E1~E7)·codex(Phase 5.5)가 이 결정들을 독립으로 깐다.
> 권위[HARD]: 상품마스터260610·가격표260527 절대. 라이브 실측 2026-06-20. 각 결정에 출처+확신도.

---

## D-1. 명함 variant = 전용 PRF (1 variant:1 PRF) `확신도: 높음`

**결정**: 명함 7 variant(코팅·펄·화이트·모양·미니모양·투명·오리지널박)를 각자 전용 PRF에 바인딩(PRF_NAMECARD_COAT/PEARL/WHITE/SHAPE/MINISHAPE/CLEAR/FOIL 신설). 하나의 NAMECARD_FIXED에 다 묶지 않음.

**근거(실측)**: variant comp는 use_dims가 제각각 — STD/COAT/PEARL=`[mat_cd,min_qty]`·PREMIUM/CLEAR=`[min_qty]`·SHAPE/MINISHAPE=`[siz_cd,min_qty]`. PREMIUM_MGA·MGB는 둘 다 mat_cd 없이 min_qty=100 → 한 공식에 묶으면 `_combo_key` 동일 → **ERR_AMBIGUOUS**(engine-contract P3-8). variant마다 판별차원이 달라 자동매칭 분기 불가.

**흡수**: RedPrinting `price_gbn` 라우팅(absorption C-1) — 같은 상품군이라도 variant는 다른 공식. 단 naming 유입 금지(후니 `PRF_NAMECARD_<variant>` 한글의미 컨벤션).

**trade-off**: 공식 수 증가(8개) vs 단일 공식. 단일 공식은 ERR_AMBIGUOUS·misfire 불가피 → variant별 전용이 유일 안전해. dbmap-naming-standardization 권위순서 준수.

---

## D-2. ★라이브 PRF_NAMECARD_FIXED 실재 결함 2건 (dbm-price-arbiter 라우팅) `확신도: 높음`

> **[보정 R-2 — 2026-06-20]** D-2b를 "ERR_AMBIGUOUS(견적 깨짐)"로 진단했던 것을 **silent 이중합산**으로 정정.
> 검증가 라이브 재실측(recompute §3)이 반증: S1/S2는 **서로 다른 comp_cd**라 `match_component` 내부에서 만나지 않으므로 ERR_AMBIGUOUS(한 comp의 단가행들 사이에서만 발생)는 **일어나지 않는다**. 진짜 결함은 인쇄면 차원 부재로 인한 S1+S2 silent 합산이다.

**발견(실측)**:
- **D-2a misfire**: 코팅명함(PRD_000032)·프리미엄명함(PRD_000031)이 PRF_NAMECARD_FIXED 바인딩인데 그 공식엔 STD comp만 배선 → **코팅/프리미엄 견적 시 STD 단가(3500) misfire**(COAT 5500·PREMIUM 4500 무시). (변동 없음)
- **D-2b 인쇄면 silent 이중합산 (V-DGP-1·재서술)**: STD_S1·STD_S2가 PRF_NAMECARD_FIXED에 둘 다 disp_seq로 배선됐고, **두 comp의 단가행 `print_opt_cd` 컬럼이 NULL**이다. `_row_matches`(pricing.py:78-90)에서 NULL=와일드카드 → 인쇄면 선택과 무관하게 **둘 다 통과** → `_evaluate_formula`가 disp_seq 순으로 **둘 다 합산**(단면 350,000 + 양면 450,000 = **800,000원**). 경고 없이 과청구되어 **ERR_AMBIGUOUS보다 더 위험**(견적이 "깨지는" 게 아니라 "틀린 값으로 성립"). 명함 전 variant·엽서북 PCB(S1_20P/S2_20P)도 동형.

**결정**: D-1(전용 PRF)로 misfire 해소 + 인쇄면=print_opt_cd 차원 통합/충전(D-3)으로 **이중합산** 차단. **돈크리티컬** — dbm-price-arbiter 심의·실 교정 인간 승인.

---

## D-3. 인쇄면 S1/S2 = print_opt_cd 차원 충전 (별 공식 분리 아님) `확신도: 중`

> **[보정 R-5 + D-2 보강 — 2026-06-20]** 사유 정정: print_opt_cd 충전이 푸는 것은 **이중합산(R-2/V-DGP-1)**이지 ERR_AMBIGUOUS가 아니다(별 comp는 ambiguous 안 됨). 충전 자체는 타당(POPT_000001/002 실재). + codex D-2 가설을 라이브 코드로 검증해 **컬럼 충전 + use_dims 등재 양쪽 필요**로 보강(아래 ★).

**결정**: S1(단면)·S2(양면) comp를 한 공식에 배선하되 (a) 단가행 `print_opt_cd` 컬럼에 단면/양면 코드 충전 + (b) 두 comp의 `use_dims` 배열에 `print_opt_cd` 등재 → 손님 인쇄면 선택이 정확히 1개 comp만 매칭(silent 이중합산 차단).

**근거**: 명함 옵션그룹에 "인쇄"(OPT_000048) 실재. 인쇄면 코드 POPT_000001(단면)/POPT_000002(양면)이 `t_prd_product_print_options`에 실재(검증가 E4 재대조). 별 공식 분리(안②)는 상품수 2배·과설계.

**★ D-2 use_dims 가설 라이브 검증 결과(2026-06-20·읽기전용)** — codex 가설 "print_opt_cd가 use_dims 배열에도 포함돼야 효과" = **부분 참(이유는 다름)**:
- **라이브 실측**: `t_prc_price_components.use_dims`에서 STD_S1=STD_S2=`["mat_cd","min_qty"]` (print_opt_cd **미등재**).
- **매칭 메커니즘(pricing.py)**: `_row_matches`(:78-90)·`_combo_key`(:93-95)는 **고정 상수 `NON_QTY_DIMS`**(=siz_cd·plt_siz_cd·**print_opt_cd**·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty, :38-39)를 순회한다 — **`use_dims` 배열은 매칭에 쓰이지 않는다**. print_opt_cd는 이미 NON_QTY_DIMS 멤버이므로, **단가행 컬럼에 값만 충전하면(NULL→코드)** `_row_matches`가 즉시 차원으로 작동해 단면 행은 단면 선택에서만 통과 → **(a) 컬럼 충전만으로 매칭(=이중합산 차단)은 성립**.
- **그러나 use_dims 등재가 여전히 필요한 이유 2가지**: ① `_match_entry`(:412-415)가 `use_dims`로 "판별차원 없음 — 항상 매칭" 경고/note를 산출 → use_dims에 print_opt_cd 없으면 컬럼을 충전해도 **잘못된 "항상 매칭" note**가 남음. ② 옵션→차원 자동주입 레이어(option_items→selections)가 use_dims를 읽어 "어떤 차원을 손님에게 받을지" 결정한다면, use_dims에 print_opt_cd 없으면 인쇄면 선택값이 selections에 안 실려 → 충전된 행(non-NULL)과 NULL 선택값 불일치 → **이중합산이 아니라 0원 침묵(no_match)** 으로 뒤집힘.
- **∴ 결론**: codex의 "둘 다 필요"는 결과적으로 옳다. 단 codex가 제시한 사유("매칭이 use_dims 기준")는 **틀렸다** — 매칭은 행 컬럼(NON_QTY_DIMS) 기준이고, use_dims는 경고/주입 레이어용. 무손실 해법 = **컬럼 충전 + use_dims 등재 동시**(둘 중 하나만 하면 각각 "오경고" 또는 "0원 침묵" 부작용).

**trade-off**: 차원 충전(단가행 UPDATE·값 불변) + use_dims UPDATE(배열에 print_opt_cd 1개 추가)가 최소 변경. **인쇄 옵션값↔POPT 코드 매핑 확인 필요**(컨펌 G-7) — option_items 매핑 0행이라 옵션→차원 자동주입 경로가 **현재 미연결**(주입 레이어 부재 시 충전 단독으로도 매칭은 되나 손님 선택이 전달돼야 함). 미확인이라 `확신도: 중`. 미확정 시 안②(별 공식) 폴백.

---

## D-4. 고정가형 = 합산형 특수형 (frm_typ 분기 없음) `확신도: 높음`

**결정**: 명함·포토카드·엽서북 "고정가형"을 별 엔진 분기로 두지 않고 **단가형 comp 1개(완제품 통합단가)만 배선된 합산형**으로 표현.

**근거**: engine-contract C7 — 엔진은 `frm_typ_cd` 미참조(`_evaluate_formula`에 분기 없음). 라이브 `t_prc_price_formulas`에 frm_typ_cd 컬럼 **부재**(실측). 공식=항상 구성요소 합산.

**함의**: 설계는 원자합산·고정가를 똑같이 formula_components 배선으로 표현. "고정가"는 comp 1개 합산일 뿐.

---

## D-5. 엽서북 = 고정가형 (세트조합 아님·gap-board G-5 재정의) `확신도: 높음`

**결정**: 엽서북을 "내지+표지 합산 세트"가 아니라 "페이지수(20p/30p)×면(S1/S2)×사이즈 완제품 고정단가"로 설계(PRF_PCB_FIXED 유지).

**근거(실측)**: 본체 PRD_000094=PRF_PCB_FIXED 바인딩 실재. comp=COMP_PCB_S1/S2×20P/30P(완제품 통합단가). 내지/표지 별 comp **부재**. 상품마스터 내지/표지 행=webadmin BOM(자재·MES)일 뿐, 가격은 완제품 통합.

**이중계상 가드[HARD]**: 내지·표지를 별 comp로 합산 금지(완제품 단가가 이미 포함). benchmark P-1b — template(구성)을 가격에 끌어들이지 말 것.

---

## D-6. 포토카드 SET/BULK 두 모드 (bdl_qty 판별) `확신도: 중`

**결정**: PRF_PHOTOCARD_FIXED에 SET(2)+BULK(1) 배선. SET=bdl_qty 차원·BULK=min_qty만 → combo_key 다름 → ambiguous 회피.

**근거(실측)**: COMP_PHOTOCARD_BULK 50행 실재·orphan. SET(SIZ_000012·bdl 20·6000)·BULK(100매·9500).

**trade-off**: BULK 바인딩으로 대량주문 견적 가능. 단 **세트수 미선택 시 SET combo 충돌 위험** — 주문 UX가 세트/대량 택1이면 안전. 미확인 `확신도: 중`(컨펌 S-2). 택1 아니면 CPQ 제약 필요.

---

## D-7. 흡수 적용 — 제약 2건만 (C-2/C-4·신규 그릇 0) `확신도: 높음`

absorption-candidates 5후보 중 **실질 흡수 = 제약 레이어 2건**(가격축 신설 0):

| 흡수 | 적용 | 그릇 |
|------|------|------|
| **C-2 자재×허용수량 제약** | 명함 자재별 허용 부수(예 일부 자재 100~500만) | round-6 CPQ constraints(JSONLogic·신규 제약행) |
| **C-4 자재×후가공 비활성** | 소량전단 종이 180g 미만 코팅불가(calc-draft 제약) | round-6 CPQ constraints(JSONLogic) |

★ 둘 다 **data-gap이지 vessel-gap 아님**(rpmeta NC 정합). 신규 테이블 0. **권위 엑셀(상품마스터)에 자재별 허용수량/후가공 명시 시 그게 정답**(경쟁사=보강). C-1/C-3/C-5는 네이밍/표현력/견적UX 수준(가격엔진 차원 신설 아님·C-5 건수≠수량 가드).

---

## D-8. search-before-mint 결과 — 신규 mint = 대형박 1건 `확신도: 높음`

| 후보 | 라이브 실재? | 판정 |
|------|------------|------|
| 명함 variant comp(STD/COAT/PEARL/WHITE/PREMIUM/SHAPE/MINISHAPE/CLEAR) | **실재·단가행 충전** | mint 불요(orphan 바인딩) |
| 오리지널박명함 FOIL comp(STD/HOLO·SETUP) | **실재·9행씩** | mint 불요(공식 신설+배선) |
| 포토카드 SET/CLEAR_SET/BULK | **실재** | mint 불요(BULK orphan 바인딩) |
| 엽서북 PCB comp(S1/S2×20P/30P) | **실재** | mint 불요 |
| 접지 comp(FOLD_CARD/LEAF 7종) | **실재** | mint 불요(와이드접지 바인딩) |
| **후가공박(대형) COMP_FOIL_LARGE** | **부재**(라이브엔 명함 소형박 FOIL만) | **신설 정당** — 가격표 후가공_박 시트 출처 필수·채번 MAX+1·`_` |

★ **신규 comp 단 1건**(대형박). 채번=MAX+1·separator `_`. 합가형이면 단가행 min_qty 必(P4-3 ValueError 가드). 나머지는 전부 실재 comp 바인딩 = search-before-mint 강하게 충족.

---

## D-10. ★고정가형 prc_typ 결함 — 단가형인데 묶음/구간총액(돈크리티컬·전 고정가형 횡단) `확신도: 높음(범위 확정)·교정방향: 컨펌 대기`

> **[보정 R-1 — 2026-06-20]** 범위를 "명함 8종"에서 **전 고정가형 횡단**으로 확장. 검증가 라이브 재계산(recompute §1·4·5·6)이 엽서북·포토카드 BULK·박 SETUP까지 동형 ×qty 폭발임을 실증. **단, prc_typ 교정 방향(합가형 전환 vs qty 고정) 확정은 dbm-price-arbiter 심의 + 사용자 컨펌 대기 — 본 설계는 결함 명세까지만, 방향 확정 금지.**

**발견(실측·범위 확정)**: 모든 고정가형 comp가 `prc_typ=PRICE_TYPE.01`(단가형)인데 단가행 unit이 "묶음/구간 총액"이다. 단가형은 `subtotal=unit×qty`(component_subtotal :191-192)이므로 qty를 곱해 **10~300배 과대청구**:

| 상품군 | comp | 단가행 | qty | 단가형 산출(현 라이브) | 가격표 verbatim(옳음) | 배수 |
|--------|------|--------|-----|------------------------|------------------------|------|
| 스탠다드명함 | COMP_NAMECARD_STD_S1 | min_qty=100·unit=3500 | 100 | 350,000 | 3,500 | ×100 |
| 엽서북 | COMP_PCB_S1_20P | min_qty=2·unit=11000 | 2 | 22,000 | 11,000 | ×2 |
| 엽서북 | COMP_PCB_S1_20P | min_qty=20·unit=5200 | 20 | 104,000 | 5,200 | ×20 |
| 포토카드 BULK | COMP_PHOTOCARD_BULK | min_qty=100·unit=9500(구간총액·50행 구간) | 100 | 950,000 | 9,500 | ×100 |
| 오리지널박명함 FOIL | COMP_NAMECARD_FOIL_S1_STD | min_qty=300·unit=24800 | 300 | 7,440,000 | 24,800(박값) | ×300 |
| 박 SETUP(동판비) | COMP_NAMECARD_FOIL_SETUP_S1_STD | `use_dims=[]`·min_qty=NULL·unit=5000 | 300 | 1,500,000 | 5,000(1회 정액) | ×300 (→R-4) |

★ 포토카드 SET(min_qty=1·÷1·×1)만 우연 정합(qty=1 주문에 한해). 박 SETUP은 별 결함(use_dims=[]) → **R-4** 참조.

**교정 후보 (둘 다 명세·확정은 컨펌 대기·CV-1/CV-2)**:
- **후보 X (합가형 ÷min_qty)**: prc_typ를 PRICE_TYPE.02(합가형)로 전환 → `subtotal = unit ÷ min_qty × qty`(:185-190). 단가가 "구간 총액"이면 ÷100=장당가 35원 × 100 = 3,500 정합. **합가형은 단가행 min_qty 필수**(NULL이면 :188 ValueError) → 박 SETUP은 min_qty=1 충전 동반 필요.
- **후보 Y (qty=100 고정 + 합가형/현행)**: 명함이 "100매 1세트 고정주문"이면 주문 UX qty를 항상 묶음수로 고정. 이 경우 단가형 그대로도 1세트당 결과는 가격표값과 다름(×qty)이므로, 합가형 + qty=묶음수 정규화가 안전.

**결정**: 결함 범위 = **전 고정가형 횡단(명함 8종 + 엽서북 PCB + 포토카드 BULK + 박 FOIL/SETUP)** 확정. **교정 방향(X vs Y)은 "고정가형 단가의 의미 = 묶음총액인가 장당가인가" 도메인 확정 필요 → dbm-price-arbiter 심의 + 사용자 컨펌 대기**(CV-1·CV-2). 본 설계는 어느 방향도 확정하지 않는다.

**trade-off**: 결함이 실재(검증가 실측으로 입증)하나 라이브 의도(고정 묶음주문)일 가능성이 남아 교정 방향만 컨펌 대기. 범위 자체는 `확신도: 높음`(재계산 실증).

---

## D-11. 박 SETUP(동판비) — use_dims=[]·단가형 ×qty 폭발 (돈크리티컬·교정방향 컨펌 대기) `확신도: 높음(결함)·방향: 컨펌 대기`

> **[보정 R-4 명세 — 2026-06-20]** 박 SETUP을 D-10에서 분리해 별 결함으로 명세. 검증가 recompute §6 실증.

**발견(실측)**: COMP_NAMECARD_FOIL_SETUP_S1_STD `use_dims=[]`(판별차원 0·라이브 재확인)·단가행 `min_qty=NULL·unit=5000`·`prc_typ=PRICE_TYPE.01`(단가형). 동판비는 **수량 무관 1회 정액**이어야 하는데 단가형 `unit×qty` → qty=300 시 **5000×300=1,500,000 폭발**. 또 use_dims=[]이라 항상 매칭(:414 "판별차원 없음" note).

**교정 후보 (둘 다 명세·확정 컨펌 대기·CV-4)**:
- **후보 합가형 min_qty=1**: prc_typ=PRICE_TYPE.02 + 단가행 min_qty=1 충전 → `5000 ÷ 1 × qty` = 여전히 ×qty(합가형도 ×qty이므로 정액 안 됨). ∴ **단순 합가형으로는 정액 해결 불가** — qty를 1로 정규화하거나 별 처리 필요.
- **후보 별도 정액 comp**: SETUP을 수량과 분리된 1회 정액 항목으로 처리(엔진이 동판비를 ×qty 안 하도록). 현 엔진 계약(단가형/합가형 모두 ×qty)에는 "수량 무관 정액" 모드가 없음 → 주문당 qty=1 고정 평가 또는 엔진 확장 필요.

**결정**: 동판비 = 수량 무관 1회 정액이 의도인지 가격표/사용자 확정 필요(CV-4). 의도면 정액 처리 명세 확정 → **dbm-price-arbiter 심의 + 사용자 컨펌 대기**. 본 설계는 결함 + 후보까지만, 방향 확정 금지.

---

## D-9. 시트 차원경계 준수 (U-7 R-4) `확신도: 높음`

**결정**: 명함·포토카드·엽서북(완제품 통합단가 상품군)에 종이 후가공 comp(오시/귀돌이/미싱/가변/별색) 배선 금지. 완제품 단가가 이미 완성단가(용지·인쇄·코팅 포함).

**근거**: validity-constraint-spec R-4·comp↔상품군 허용표 §2(G-NAMECARD/PHOTOCARD 열은 종이 후가공 전부 ✗). 박은 별 add-on(오리지널박명함=전용 FOIL comp).

---

## 컨펌큐 (사용자/도메인 — 미지를 정답으로 위장 안 함)

| # | 미해소 | 권위 출처 | 영향 |
|---|------|----------|------|
| **G-6a** | 공식 권위 이원화 — 상품마스터 `가격공식` 칸 공란/truncated은 결함인가 의도인가 | calc-draft 정본 채택(이 설계) | 공식 유형 확정 |
| **G-6b** | 봉투류(OPP·카드봉투·트레싱지·캘린더봉투) = 추가상품 vs 독립상품 | 상품마스터 추가상품 칸 | 바인딩 대상 결정 |
| **G-6c** | 오리지널박명함 = 별 공식 확정(FOIL+SETUP) | calc-draft·실측 | PRF_NAMECARD_FOIL 신설 |
| **G-7** | 인쇄 옵션값↔print_opt_cd 매핑(D-3 차원충전+use_dims 등재 후 옵션→차원 자동주입) — option_items 매핑 0행이라 현재 미연결 | option_items ref 실측 | S1/S2 silent 이중합산 해소법(주입 미연결 시 0원 침묵 위험) |
| **S-1** | 엽서북 내지/표지(PRD_000095/096) 가격 바인딩 불요 확정 | 상품마스터·BOM | 세트 모델 |
| **S-2** | 포토카드 SET/BULK 주문 UX 택1 여부 | 상품마스터·라이브 옵션 | 동시매칭 가드 |
| **S-3** | 와이드접지리플렛 접지타입→comp | 상품마스터·가격표 | 바인딩 |
| **형압명함** | 형압명함 PRD_000038 comp 부재 — FOIL 공유? 별 comp? | calc-draft·가격표 | 바인딩 |
| **D-10/CV-1** | ★고정가형 단가 의미 = 묶음/구간총액인가 장당가인가 — 묶음총액이면 단가형(.01) 전건 오적재·교정방향(합가형÷min_qty=X / qty정규화=Y) **컨펌 대기** | dbm-price-arbiter + 사용자 | 돈크리티컬·전 고정가형(명함8+엽서북+포토카드BULK+박) |
| **CV-2** | 명함 주문 UX = 100매 고정세트인가 장당 누적인가(prc_typ 교정 방향 X vs Y 결정) | 사용자 | prc_typ 교정 방향 |
| **CV-4/D-11** | 박 동판비 = 수량 무관 1회 정액 확정인가 + 정액 처리법(현 엔진은 정액 모드 부재) **컨펌 대기** | 사용자·가격표·dbm-price-arbiter | 돈크리티컬·박 SETUP |
| **C-V1** | 손지율 +5장 엔진계산 위치(pricing.py) | 코드 확인 | 용지비 정확성 |

★ 본 설계는 **상품군/구조 레벨 확신도 높음**(라이브 실측 + calc-draft 권위). 컨펌큐는 상품 레벨 정밀화·경계 확정. 실 적용(공식 신설·차원 충전·박 신설)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer).

---

## 아크릴 절 — 설계 결정·흡수 적용·search-before-mint 근거·컨펌큐 (2026-06-20 라이브 실측)

> 입력: `formula-map-acrylic.md`·`absorption-candidates-acrylic.md`(C-A1~C-A7·신규 가격축 0)·라이브 읽기전용 SELECT. DB 미적재.

### A. 핵심 설계 결정

| ID | 결정 | 근거 | trade-off |
|----|------|------|-----------|
| **AD-1** | 본체 = 면적매트릭스 1 comp(CLEAR3T)·두께=mat_cd 직교 정확매칭(별 두께축/별 comp 금지) | 라이브 1 comp+mat_cd 분기(165행)·benchmark C-A1(두께=자재 차원·RedPrinting WGT 동형) | 공식 폭발 방지(투명 1 공식이 3T/1.5T 커버)·8T 매트릭스 단가행 부재 시 data-gap |
| **AD-2** | W=가로(앞)=siz_width·H=세로(뒤)=siz_height·가격축=siz_nm WxH·**work사이즈 절대 금물** | dbmap round-23 돈크리티컬·라이브 비대칭쌍 실측(가로50×세로30=3,800) | work 룩업 시 틀린(비싼) 단가·라이브 WH 전환 COMMIT 유지 |
| **AD-3** | off-grid=각 축 '이하' ceiling(엔진 내장·`pricing.py:158-162`)·단가행 ceiling 행 안 만듦 | [[dbmap-compute-in-app-db-stores-lookup]]·benchmark C-A2(면적함수 부결·매트릭스+ceiling) | 미적재 좌표는 ceiling 흡수 또는 가격표 좌표 채번(import 트랙) |
| **AD-4** | frm_typ 미참조·면적매트릭스/고정가 모두 comp 1배선 합산형 표현 | engine-contract C7·`pricing.py:8` | 디지털인쇄 설계 §1 동형(일관) |
| **AD-5** | G-A1 본체 17상품=**바인딩만**(공식/comp 재사용·신규 mint 0) | 라이브 PRF_CLR_ACRYL·COROTTO 실재·배선됨·바인딩 1건뿐 | 가격계산 불가 직결 1순위·search-before-mint 강 충족 |

### B. ★min_qty 엔진 계약 확정 (cartographer↔benchmark 긴장 해소) [HARD]

- **확정**: 면적단가=**개당가**·`subtotal=(unit÷min_qty)×qty`·CLEAR3T `.02`+min_qty=1이라 ÷1=개당×수량. COROTTO/MIRROR `.01`(÷ 미발생). **×qty 폭발 위험 없음**(디지털 명함 3500→350,000 결함과 단가 의미가 정반대 — 디지털=묶음총액·아크릴=개당가).
- **근거**: 라이브 SELECT(CLEAR3T min_qty distinct=1·COROTTO=1·MIRROR=NULL) + `pricing.py:185-192` 코드 검증(.02: per_item=unit÷tier_min_qty·base<=0→ValueError / .01: unit×qty).
- **★신규 면적행 INSERT 가드[HARD]**: CLEAR3T(.02) 신규 좌표/8T 행은 **전건 min_qty=1 명시 필수**(NULL→ValueError 견적 불가·디지털 박 SETUP .02+NULL 동형). dbmap B1 가드.
- **결론**: benchmark가 경계한 "×qty 동일 클래스 위험"은 **라이브 단가 의미 확정으로 해소**. cartographer "÷1=단가형 동일·안전"이 맞음 + 신규 INSERT 가드 추가.

### C. 흡수 적용 (absorption-candidates-acrylic — 신규 가격축 0건)

| 흡수후보 | 적용 | naming 가드 |
|----------|------|------------|
| C-A1 두께=mat_cd 차원 | AD-1로 채택(이미 동형·설계 원칙 못박음) | RP WGT_CD/MTRL_CD 유입 금지 |
| C-A2 면적 자유사이즈→매트릭스 ceiling | AD-3(자유입력 UX·격자 가격·면적함수 부결) | acrylic2025 토큰 유입 금지 |
| C-A3 형태별 공식 분기(frm_cd) | PRF_CLR/MIRROR/COROTTO/CARABINER=frm_cd 데이터 분기(엔진 코드 분기 아님·overfit 경계) | acrylic2025/vTmpl/tmpl 유입 금지 |
| C-A4 부자재 카탈로그 공유 | 후가공 comp + round-6 CPQ BUNDLE·횡단 마스터=basecode 거버넌스 입력 | SUB_MTR/KR/CN/CR 유입 금지 |
| C-A5 소재→후가공 disable 제약 | round-6 CPQ constraints(JSONLogic)·data-gap·가격 정합 가드 | disable_pcs/COT_DFT 유입 금지 |
| C-A6 완제 고정가형(카라비너) | §5-C 고정가 comp(.06·opt_cd)·형상≠siz_cd 가드 | 가격표 B07 권위 |
| C-A7 라미=두께 합성 | 라미 자재 별 mat_cd 권장(자재 그룹핑 슬롯 신설 부결·overfit) | production_method/GRP_OPTION 유입 금지 |

★ **신규 테이블/가격축 신설 = 0건**(rpmeta AC distinct #19 부결 정합·search-before-mint 통과). WowPress 아크릴=미관측(보강 불가·정직 기록).

### D. 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-ACR-MIR1** | 미러 바인딩 대상 상품 불명(라이브 미러 본체 0개) — 별 공식(PRF_MIRROR_ACRYL) vs 소재옵션(투명/미러 택1)으로 PRF_CLR_ACRYL 합류? 합류 시 **mat_cd 판별차원 필수**(MIRROR3T mat_cd NULL→silent 이중합산 가드) | 사용자·dbm-price-arbiter | 미러 가격사슬·돈크리티컬 |
| **Q-ACR-CO1** | 코롯토 정체 — 입체코롯토(168)·포카코롯토(165)·쉐이커코롯토(226)가 모두 B06 동일 면적매트릭스인가(현 라이브 단가행 1체계뿐→동형 가정) | 실무 | 코롯토 바인딩 범위 |
| **Q-ACR-FIN1** | 후가공(고리 1,100 등) 가산 = 개당 1회 vs ×수량(개당이면 .01·min_qty=1·use_dims=[opt_cd]). 디지털 후가공 ×수량 과청구 동일 클래스 | 실무·dbm-price-arbiter | 후가공 정확성·돈크리티컬 |
| **Q-ACR-MAT1** | PRF_CLR_ACRYL 바인딩 상품 견적 시 mat_cd(두께) 선택 UI 연결(option_items→mat_cd 주입)·미선택 시 단가행 후보 0(0원 침묵) | 사용자 | 바인딩 유효성(U-7) |
| **Q-ACR-DSC1** | 본체 prd_cd↔t_dsc(B04 수량구간·B08 카라비너) 할인 연결 유효성(dbmap round-1 GO·미적재) | dbmap round-1 | 할인 적용 |
| **Q-ACR-CARA1** | 카라비너(PRD_000166 비활성) 활성화 시 comp 신설+형상 4 opt_cd 채번(MAX+1)+B07 단가행 4+공식+바인딩 일괄 | 실무·채번 트랙 | 카라비너 가격사슬·LOW |
| **Q-ACR-CTR1** | CLEAR3T prc_typ .02→.01 시맨틱 정정 여부(min_qty=1이라 가격 무영향·LOW) | 개발자 | 시맨틱·가격 무관 |

★ 본 설계는 **상품군/구조 레벨 확신도 높음**(라이브 SELECT 실측 + 가격표 verbatim + calc-draft + pricing.py 코드 검증). 컨펌큐는 상품 레벨 정밀화·경계 확정(미러/카라비너/후가공). 실 적용(바인딩 INSERT·미러 공식·카라비너 신설·후가공 comp)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·webadmin 코드 직접수정 금지).

---

# 실사·현수막 절 — 설계 결정·흡수·trade-off·컨펌큐 (면적매트릭스형 종단)

> 입력: `formula-map-silsa-banner.md`·`absorption-candidates-silsa-banner.md`·`engine-design-silsa-banner.md`·라이브 실측 2026-06-20·pricing.py 코드 검증. 권위[HARD] 상품마스터260610·가격표260527 절대.

## DS-1. 3계산방식 = comp use_dims 차이일 뿐 (frm_typ 분기 없음) `확신도: 높음`

**결정**: 면적매트릭스·고정가·수량구간 3계산방식을 별 엔진 분기로 두지 않고 본체 comp 1개의 use_dims가 `[siz_width,siz_height]`(면적)·`[siz_cd]`(규격)·`[siz_cd,min_qty]`(수량밴드)인 차이로 표현.

**근거(실측)**: engine-contract C7·pricing.py:8 frm_typ 폐기·라이브 t_prc_price_formulas frm_typ_cd 컬럼 부재. 28 PRF_POSTER 전건 comp 1개 합산형(라이브 실측). 디지털·아크릴 동형.

**흡수**: rpmeta D-6(면적/곱수/고정/단가 가격기여 역할)이 후니 계산방식을 외부검증(reverse-price-contracts §6). 신규 계산방식 도입 불요.

---

## DS-2. ★본체 면적단가 = 1장당가·prc_typ .01·×qty 폭발 없음 (디지털·아크릴과 정반대) `확신도: 높음`

**결정**: 면적 본체 `subtotal = unit × qty`(1장가×수량 누적). 디지털 ×qty 과청구·아크릴 .02 미확정 가드 둘 다 불필요.

**근거(라이브 실측 + 코드)**: 면적 본체 전건 `.01 단가형`(CANVAS/ARTPRINT/ADH_CLEAR/LINEN/ARTPAPER/BANNER_N/BANNER_M) → component_subtotal(pricing.py:191-192) 단가형 분기 `unit×qty`(÷min_qty 미발생). 단가 의미 = 가격표 셀 "그 사이즈 완제품 1장당 단가". **디지털 결함(단가=묶음총액·÷min_qty 폭발)과 단가 의미가 정반대** → ×qty 위험 0.

**benchmark 긴장 해소**: benchmark "1장당×수량 vs 수량구간 총액 미확정·돈크리티컬"을 라이브 prc_typ(.01) + 단가 의미(1장당가) 확정으로 해소(추측 적재 회피).

**trade-off**: 본체 무변경(라이브 정합). G-S3 use_dims min_qty 선언 잔류(ARTPRINT/CANVAS/CANVAS_HANGING)는 가격 무영향(단가형 ÷ 미사용)·시맨틱 정리만 LOW(Q-SB-DIM1).

---

## DS-3. ★수량구간형 = 미니류 min_qty 밴드 개당가 ('이상' 하한·t_dsc와 구분) `확신도: 높음`

**결정**: 미니배너·미니보드를 `[siz_cd,min_qty]` 수량구간형으로 표현. 단가행에 수량밴드(4/19/49/99/10000)별 개당가 baked → 엔진 min_qty TIER('이상' 하한·주문수량 이하 최대 임계) 룩업 후 `개당가 × qty`.

**근거(라이브 verbatim)**: MINI_BANNER 10행·MINI_STANDBOARD 15행·prc_typ .01. min_qty TIER 방향 = '이상' 하한(pricing.py:42·siz_width/height '이하' ceiling과 반대). 주문 30개 → min_qty=19 행(개당 4,900)×30=147,000.

**★t_dsc 이중할인 가드[HARD]**: 미니류 수량밴드는 **본체 단가행에 내장된 볼륨할인 가격**(comp_prices.min_qty)이지 t_dsc_* 별도 구간할인이 아님. 본체 + t_dsc 둘 다 연결하면 이중 볼륨할인 → 미니류 t_dsc 미연결 권장(Q-SB-MINI-DSC).

**비동형점**: 아크릴(개당가·min_qty=1)·디지털(묶음총액)과 또 다른 제3유형. 엔진 min_qty TIER가 이미 표현(신규 그릇 0).

**trade-off**: 본체 무변경(라이브 정합). 최소구간 미달(qty<4)=ERR_BELOW_MIN(정상 거부)·4개 미만 주문 정책 컨펌(Q-SB-MINI-MIN).

---

## DS-4. ★G-S1 후가공 배선 = 핵심 갭·판별차원 충전이 절대 선결 (silent 합산 가드) `확신도: 높음`

**결정**: 전 28 PRF_POSTER 공식에 후가공 add-on(공통 7 + 배너 전용 + 거치)을 disp_seq 2~ 배선. **단 배너 후가공(PUNCH/QBANG/STRING/BONGSEW/CUTEDGE/DTAPE/STAND·use_dims=[])은 판별차원(opt_cd/proc_cd) 충전 + 택1 그룹(타공 4/6/8) 통합이 배선의 절대 선결.**

**근거(라이브 실측 + 코드 확정)**:
- 엔진은 addtn_yn 미참조(pricing.py:340-349)·공식 comp 전건 매칭 합산·미선택 자연 제외 → **배선만 하면 가산**(gd2-wiring §0 정합).
- ★**silent 합산 메커니즘 확정**: PUNCH_4/6/8은 서로 다른 comp·각 use_dims=[]·단가행 전 컬럼 NULL → `_row_matches`(pricing.py:78-81) NON_QTY_DIMS 전건 NULL=와일드카드로 셋 다 통과 → 각자 1행 매칭(included=True) → **타공 4+6+8 동시 합산**(3,000+4,000+5,000=12,000 과청구). 손님이 6개만 골라도 셋 다 가산. `_match_entry`(pricing.py:415-419)는 note "판별차원 없음 — 항상 매칭"만 남기고 included=True로 합산(차단 아님). 디지털 V-DGP-1·아크릴 미러 §5-B 동형.
- 공통 후가공(오시/미싱/귀돌이/가변/별색)·거치(우드행거/우드봉/천정고리/린넨마감)는 proc_cd/opt_cd/siz_cd 판별차원 보유 → 배선 안전. 미싱(PERF_1L)도 이미 proc_grp:PROC_000030 전환 완료(G-S2 BLOCKED 해소·gd2 C-4 적용됨).

**흡수**: benchmark C-SB7(부자재 수량 종속)·rpmeta D-4(공정 파라미터)가 후가공 dim_vals(줄수/개수)를 외부검증. naming 유입 금지(RP `number_sel_ROP_DFT`→후니 dim_vals).

**search-before-mint**: 후가공 comp·단가행 전부 실재(신규 0). 작업=배선(formula_components INSERT) + 배너 후가공 판별차원 충전(use_dims/단가행 컬럼 UPDATE·신규 행 0) + 택1 타공 통합(grouping·use_yn=N).

**trade-off**: 충전 없이 배선하면 100% 과청구(돈크리티컬). 충전(use_dims+컬럼)이 최소 변경이나 배너 후가공 단가행이 전 컬럼 NULL이라 **opt_cd 채번 + 충전 필요**(MAX+1·`_`). 미충전 시 배선 보류(BLOCKED).

---

## DS-5. ★후가공/거치 가산 = 1건당 vs ×수량 (돈크리티컬·추측 적재 금지) `확신도: 중`

**결정**: 배너 후가공(타공/큐방/끈/봉미싱) + 거치(우드행거/PET거치)의 가산이 1주문건당 통가격인지 1장당(×수량)인지 라이브 단가행 의미 확정 후 prc_typ 설계.

**근거**: 엔진 `.01`은 `unit×qty` → 현수막 10장 주문 시 거치 25,000×10=250,000. 거치대는 "주문 1건당 1개"가 일반적(현수막 10장에 거치 10개 아님) → ×qty 과청구 위험. 단가가 1장당이면 정합·1건당 통액이면 과청구.

**흡수**: benchmark C-SB7 "개당 1회 vs ×개수 엔진 계약으로 확정". 디지털 후가공 ×수량 과청구·아크릴 Q-ACR-FIN1 동일 클래스.

**trade-off**: 1건당이면 별 prc_typ(고정 통액) 또는 min_qty 처리 설계 필요. 미확정이라 `확신도: 중`. Q-SB-PROC-QTY·dbm-price-arbiter 심의.

---

## DS-6. 동형결합 7정본·소재별 공식 (byte-identical만·후니 우월) `확신도: 높음`

**결정**: 면적 13소재를 byte-identical 단가표 공유 2그룹으로 결합(13→7 정본·라이브 COMMIT됨). 정본A=CANVAS_FABRIC(레더/메쉬프린트/타이벡)·정본B=ARTPRINT_PHOTO(방수/접착방수/아트패브릭)·단독5(접착투명/린넨/아트페이퍼/일반현수막/메쉬현수막).

**근거(라이브 실측)**: 정본A 600×1800=37,800·정본B=21,600. 단독은 단가 상이(접착투명 59,400·린넨 32,400). **byte-identical만 결합**(행수 같아도 단가 다르면 금지·[[dbmap-price-component-grouping]]).

**흡수**: benchmark C-SB3 "소재=별 가격축 아님·소재별 공식이 동형 단가표 공유"·후니가 RedPrinting MTRL_CD별 자재행 중복보다 우월. 소재를 면적 comp mat_cd 차원으로 답습 금지(아크릴 두께와 다른 패턴).

**trade-off**: 동형 판정에 전컬럼 md5 필수(외형 동일에 속지 말 것). 라이브 이미 COMMIT(작업 불요)·검증가 재대조만.

---

## 신규 mint = 0건 (search-before-mint 강하게 통과·아크릴보다 우월)

공식 28·본체 comp 7정본/단독·후가공 comp 전부 실재·단가행 verbatim 풍부·동형결합 COMMIT·바인딩 28상품 완료. **신규 = 배너 후가공 판별차원 충전용 opt_cd 채번뿐(배선 위해·MAX+1)**. rpmeta BN distinct #18 부결(reverse-price-contracts §6) 정합·WowPress 미관측(보강 불가·정직 기록).

## 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-SB-PROC-QTY** | ★후가공/거치(타공/큐방/끈/봉미싱/우드행거/PET거치) 가산=1주문건당 통가격 vs 1장당(×수량). 거치대(25,000)는 1건당 가능성 높음→×qty 과청구 위험 | 실무·dbm-price-arbiter | 후가공/거치 정확성·돈크리티컬 |
| **Q-SB-PUNCH-DIM** | ★배너 후가공(PUNCH/QBANG/STRING/BONGSEW/CUTEDGE/DTAPE/STAND) 판별차원 충전 — 택1 타공 4/6/8 통합(1 comp+opt_cd 구멍수) + 택N(큐방/끈 등) 각 opt_cd 충전. opt_cd 채번(MAX+1) | 실무·채번 트랙 | G-S1 배선 선결·silent 합산 차단·돈크리티컬 |
| **Q-SB-MINI-DSC** | 미니류 수량밴드(본체 단가 내장 볼륨할인) + t_dsc 이중할인 금지 — 미니류 t_dsc 미연결 확인 | dbmap round-1 | 이중할인 방지 |
| **Q-SB-MINI-MIN** | 미니류 최소주문 4개 미만 주문 정책(ERR_BELOW_MIN) | 실무 | 수량 정책 |
| **Q-SB-CH1** | 캔버스행잉(G-S3b) use_dims=[siz_w,siz_h,min_qty] 선언 vs 실 3행 NULL·고정3규격 — siz_cd 매칭 정합 재확인·use_dims 정정 vs 단가행 채움 | 실무 | 가격축 정확성 |
| **Q-SB-DIM1** | ARTPRINT/CANVAS/CANVAS_HANGING use_dims min_qty 선언 잔류(단가행 NULL·.01 가격 무영향)→시맨틱 정리 [siz_width,siz_height] 통일 LOW | 개발자 | 시맨틱·가격 무관 |
| **Q-SB-NSPEC1** | 현수막 최대 구간 초과(5m 초과) 정책=ERR_ABOVE_MAX vs nonspec_max 제한 | 실무 | 자유사이즈 상한 |
| **Q-SB-DSC1** | 면적/고정가 본체 prd_cd↔t_dsc(수량구간) 할인 연결 유효성(dbmap round-1 GO·미적재) | dbmap round-1 | 할인 적용 |
| **Q-SB-FIXED-LEGACY** | 레거시 PRF_POSTER_FIXED(use_yn=Y·바인딩 0=고아) 정리(use_yn=N) 여부 | 개발자 | 정리·가격 무관 |

★ 본 설계는 **상품군/구조 레벨 확신도 높음**(라이브 SELECT 실측 + 가격표 verbatim + calc-draft + pricing.py 코드 검증). 컨펌큐는 후가공 배선 정밀화(판별차원 충전·1건당/×수량)·경계 확정. 실 적용(후가공 배선 INSERT·배너 후가공 판별차원 충전·opt_cd 채번)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·webadmin 코드 직접수정 금지).
