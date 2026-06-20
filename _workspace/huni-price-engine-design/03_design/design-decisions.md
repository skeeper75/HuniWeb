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
