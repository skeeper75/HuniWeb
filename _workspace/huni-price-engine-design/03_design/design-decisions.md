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

---

# 문구 절 — 설계 결정·흡수·trade-off·컨펌큐 (고정가형+수량구간할인 / 매트릭스형 종단·4번째)

> 입력: `formula-map-stationery.md`·`absorption-candidates-stationery.md`(C-ST1~C-ST8·신규 가격축 0)·`set-pricing-patterns.md` P-6·라이브 읽기전용 SELECT 2026-06-20·pricing.py 코드 검증. 권위[HARD] 상품마스터260610·가격표260527 절대.
> ★스코프: 문구 시트 11상품(본체 9 + 떡메모 1 + 준비중 PRD_000180 제외). 책자(반제품 세트·부품 합산)는 스코프 밖(다음 종단 큐 DT-BIND).

## DT-1. 본체 9 = t_prd_product_prices 직접 고정가 (명함식 공식 신설 부결) `확신도: 높음`

**결정**: 본체 문구 9상품 고정가를 **PRODUCT_PRICE 경로**(`t_prd_product_prices.unit_price × qty`)로 설계. 명함/포토카드(PRF_NAMECARD_FIXED·완제품 통합단가 comp) 식 고정가형 공식 신설은 **부결**.

**근거(실측·코드)**: pricing.py 가격 소스 우선순위(:296-326) = TEMPLATE→**PRODUCT_PRICE**→FORMULA. 본체 문구는 **단일 고정가**(만년다이어리 소프트=9000 단 1가·소재/사이즈 차원 분기 없음). product_prices 구조(prd_cd·apply_ymd PK·unit_price·차원 없음·라이브 0행)가 단일가를 무손실 표현. 명함/포토카드는 소재(mat_cd)·사이즈(siz_cd)·세트(bdl_qty) 차원으로 단가가 갈려 comp 매트릭스가 정당하나, 본체 문구엔 그릇 자체가 과설계.

**흡수**: 디지털 D-4("고정가형=comp 1배선 합산형")는 명함엔 맞으나 본체 문구엔 product_prices가 더 단순·무손실. frm_typ 미참조 계약(C7) 일관(공식 안 쓰는 PRODUCT_PRICE 경로도 엔진 단일).

**trade-off**: product_prices 9행 INSERT(AC열 verbatim) vs 공식 9개. product_prices가 최소(공식/comp/배선/바인딩 0). 단 **메모패드(5,000/6,000 2사이즈)는 단일가 한계** → 사이즈 차원 공식 후보(DT-3).

## DT-2. ★떡메모 ×qty 폭발 위험 없음 — cartographer 가설 반증 (디지털 정반대·아크릴/실사 동형) `확신도: 높음`

**결정**: 떡메모 COMP_TTEOKME `.01` 단가형 `subtotal = unit_price × qty`. **÷min_qty 교정안 A 적용 부결**(불요). unit_price=권당 단가·min_qty=주문권수 TIER(÷ 미발생).

**근거(라이브 반증불가)**:
- **단가 사다리(라이브 SELECT)**: 90x90 100장1권 min_qty 6=3,200 → 600=1,050(단조 하락). **min_qty↑→unit↓ = 권당 단가의 볼륨디스카운트**. 묶음총액이면 600권에서 1,050으로 떨어질 수 없음 → **unit=권당 단가** 확정.
- **prc_typ=.01 단가형**: component_subtotal(:191-192) 단가형 분기 = `unit×qty`(÷ 미발생). min_qty는 TIER('이상' 하한·:42·:144) 단가행 선택용·÷에 안 쓰임. NULL min_qty 0건(ValueError 위험 0).
- **디지털 명함 결함과 단가 의미 정반대**: 명함 3,500=100매 묶음총액(÷100 필요·D-10)·떡메모 3,200=권당가(÷ 불요). **단가 의미가 정반대라 동형 결함 아님**. 아크릴 COROTTO(.01·개당가)·실사 면적(.01·1장가)과 동류(DS-2 정합).

**trade-off**: cartographer formula-map §7·gap-board G-ST-3의 "×qty 폭발 위험 존재·교정안 A 후보"를 **라이브 단가 의미 확정으로 해소**(반증). 교정 불요·바인딩만 하면 정상. 골든 GC-ST10/12로 입증.

## DT-3. 메모패드 2사이즈 2가격 = 사이즈 차원 공식 후보 (product_prices 단일가 한계) `확신도: 중`

**결정**: 메모패드(PRD_000179) 144x206=5,000·182x257=6,000은 t_prd_product_prices 단일가 그릇으로 못 담음 → **사이즈 차원 공식**(comp use_dims=[siz_cd]·단가행 2) 후보. 나머지 8상품은 product_prices 직접가.

**근거**: product_prices는 차원 없는 prd_cd당 1가(라이브 실측). 메모패드는 사이즈가 가격축(5,000≠6,000). 떡메모/명함식 comp+siz_cd 차원으로 2행 표현.

**trade-off**: 메모패드만 FORMULA 경로(나머지는 PRODUCT_PRICE). 일관성 약간 깨지나 사이즈 가격축 무손실. 별 prd_cd면 product_prices 2행도 가능 → **컨펌큐 Q-ST-MEMO1**(사이즈가 주문 선택축인지·별 상품인지 라이브/상품마스터 재확인·확신도 중).

## DT-4. ★수량구간할인 = t_prd_product_discount_tables 링크 (3+1 누락 보완·돈크리티컬) `확신도: 높음`

**결정**: 본체·떡메모 모든 문구에 **DSC_STAT_QTY 링크**(t_prd_product_discount_tables: prd_cd→dsc_tbl_cd). 라이브 누락 4 보완: 만년다이어리 하드/레더(PRD_000173/174/175) + 떡메모(PRD_000097).

**근거(라이브 코드·실측)**:
- `_quantity_discount(prd_cd)`(:478-504) → `t_prd_product_discount_tables.filter(prd_cd)`로 dsc_tbl_cd 링크 조회(:482) → DSC_STAT_QTY 헤더·디테일. **링크 없으면 할인 0=정가 과청구**(돈크리티컬).
- DSC_STAT_QTY 라이브: "문구상품 수량별 구간할인"·use_yn=Y·DSC_TYPE.01(정률)·5구간(1~49=0%·50~99=5%·100~499=10%·500~999=15%·1000~=20%).
- 링크 실상: 172/176/177/178/179/181 ✅실재(2026-06-01) / **173·174·175·097 ❌누락**.

**흡수**: benchmark C-ST8(부수=수량구간·디자인수≠가격축). 할인은 별 단계(t_dsc)·아크릴 B04 동형. 권위=상품마스터 "구간할인적용테이블" 컬럼([[dbmap-discount-authority]]·상품명 추측 금지).

**trade-off**: 링크 4 INSERT(prd_cd→DSC_STAT_QTY·apply_bgn_ymd 2026-06-01·dbmap round-1 GO 트랙). 미보완 시 4상품 과청구. 단가값 결함 아님(링크 결손).

## DT-5. 반제품 세트 = 가격축 아님 (디지털 엽서북과 결정적 차이·이중계상 가드) `확신도: 높음`

**결정**: 만년다이어리 하드/레더(173/174=표지 sub_prd·면지 sets)·먼슬리·스프링노트 등의 반제품 구조(`t_prd_product_sets`)는 **생산 BOM(MES)**이고 **가격은 단일 고정가 1건**. 디지털 엽서북식 내지단가+표지단가 합산 세트 레이어 **불요**.

**근거**: 본체 문구 가격 소스=AC열 단일 고정가(product_prices). sets/면지 색상은 가격 비기여(생산 UI). 디지털 엽서북(D-5)은 내지/표지 별 SKU 분리단가 합산이나 문구는 단일가.

**이중계상 가드[HARD]**: 내지·표지·면지를 별 comp/sets로 합산 금지(완제품 단가가 이미 포함). set-product-design.md 문구 절에 명시. benchmark P-6 "세트 구성(template/sets)≠세트 가격(합산)" 분리 원칙의 문구 적용(문구는 합산조차 불요).

## DT-6. 흡수 적용 (absorption-candidates-stationery — 신규 가격축/테이블 0건) `확신도: 높음`

| 흡수후보 | 적용 | naming 가드 |
|----------|------|------------|
| C-ST1 제본물 부품 합성 | **이번 스코프 밖**(책자 종단·DT-BIND 큐). 문구 본체=단일 고정가(부품 합산 아님) | book2025_price/MTRL_CD 유입 금지 |
| C-ST2 페이지수 계층 | 먼슬리 page_rule 28~28(라이브)·떡메모 3~3=입력 차원(가격 비기여·고정가) | INN_PAGE 유입 금지 |
| C-ST3 표지/내지 자재 분리 | sets 생산 BOM(DT-5·가격축 아님)·책자 종단에서 가격 합성 | COV/INN_WGT 유입 금지 |
| C-ST4 제본방식 분기 | 제본 comp 11종(책자 종단)·문구 본체=가격 비기여(고정가) | BIND_DIRECTION 유입 금지 |
| C-ST5 책등 seneca | 앱 계산 파생(책자 종단·DB 미저장) | seneca 유입 금지 |
| C-ST6 jobqty→jobcost 2단 | **부결**(과분화·후니 단일 evaluate_price) | jobqty0/jobcost0 유입 금지 |
| C-ST7 떡메 풀제본 묶음 | 떡메모=COMP_TTEOKME 단일 완제품가(권당 묶음 단가·실재·바인딩만)·풀제본비 별 comp 불요(완제품 통합단가) | TPBLMEO 유입 금지 |
| C-ST8 이중수량(디자인수×부수) | 부수=수량(qty)·디자인수=주문라인(가격축 아님·가드) | ORD_CNT/PRN_CNT 유입 금지 |

★ **신규 테이블/가격축 신설 = 0건**(rpmeta TP distinct 부결 정합·search-before-mint 통과). WowPress 떡메모=미관측(보강 불가·정직 기록).

## DT-7. search-before-mint 결과 — 신규 mint 0건 (디지털/아크릴보다 우월) `확신도: 높음`

| 후보 | 라이브 실재? | 판정 |
|------|------------|------|
| 본체 9상품 고정가 그릇 | **product_prices 테이블 실재(0행)** | INSERT만(공식/comp 신설 0) |
| 떡메모 PRF_TTEOKME_FIXED·COMP_TTEOKME·단가행 112 | **전부 실재(use_yn=Y·upd_dt 2026-06-13)** | 바인딩만(신규 mint 0) |
| DSC_STAT_QTY 할인테이블·구간 | **실재(use_yn=Y·5구간)** | 링크 INSERT만 |

★ **신규 comp/공식/테이블 = 0건**. 디지털(대형박 1)·아크릴(미러 공식·카라비너 comp/공식)과 달리 문구는 **전부 기존 그릇 INSERT/바인딩/링크**. search-before-mint 가장 강하게 충족.

## 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-ST-MEMO1** | 메모패드(179) 2사이즈 2가격(5,000/6,000) — 사이즈=주문 선택축(사이즈 차원 공식)인가 별 prd_cd인가 | 실무·상품마스터 | 메모패드 그릇(DT-3·확신도 중) |
| **Q-ST-DSC-DOUBLE** | ★떡메모 unit_price 사다리(권수별 권당가 하락=내장 볼륨할인) 위에 DSC_STAT_QTY 곱이 의도된 추가할인인지·이중할인인지 | 실무·dbm-price-arbiter | 이중할인 방지·돈크리티컬 |
| **Q-ST-DSC-LINK** | ★본체 173/174/175 + 떡메모 097 DSC_STAT_QTY 링크 누락 = 과청구. 권위 상품마스터 "구간할인적용테이블" 컬럼 재대조 | dbmap round-1·상품마스터 | 할인 적용·돈크리티컬 |
| **Q-ST-OPT1** | 떡메모 사이즈/권당장수 옵션→차원 자동주입(option_items 0행 미연결·디지털 G-7 동형)·미연결 시 디폴트 siz_cd/bdl_qty | round-6 dbm-option-mapper | 떡메모 매칭(0원 침묵 회피) |
| **DT-BIND(다음 종단)** | ★책자(중철/무선/PUR/하드커버무선·엽서북) = 부품 합산형(표지+내지+제본 Σ)·D-BIND-SCOPE(제본비 단일 vs 부품 합산)·제본비 COMP_BIND_* prc_typ(.01 min_qty 1/4/10 구간=.02 합가형 성격? 부수당×수량 vs 묶음총액) | dbm-price-arbiter·사용자 | 책자 가격사슬(이번 스코프 밖·다음 종단) |

★ 본 설계는 **상품군/구조 레벨 확신도 높음**(라이브 SELECT 실측 + AC열 verbatim + calc-draft + pricing.py 코드 검증). 컨펌큐는 상품 레벨 정밀화(메모패드/이중할인/링크)·경계 확정. 실 적용(product_prices INSERT·떡메모 바인딩·DSC 링크 INSERT)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-axis-staged-load·dbm-price-arbiter·webadmin 코드 직접수정 금지).

---

## ★다음 종단 큐 — 책자(반제품 세트·부품 합산형) [이번 스코프 밖·기록만]

> 문구 종단에서 책자를 분리한 이유와 다음 종단을 위한 입력 기록. **이번에 설계하지 않음.**

- **DT-BIND-SCOPE [HARD·인간 결정]**: "책자=제본비 단일 합산"(라이브 현황·PRF_BIND_SUM broken·제본비 단일항만 배선) vs "표지+내지+인쇄+제본 부품 합산"(경쟁사 동형·세트 그릇 보유). **권위 가격표 260527 제본물 시트가 부품별 단가를 주면 부품 합산이 정답**(benchmark C-ST1·set-pricing P-6a). designer/arbiter 판정 입력.
- **제본비 prc_typ 결정 [HARD·돈크리티컬]**: `COMP_BIND_*` 11종 prc_typ=`.01`(단가형)이나 단가행 min_qty 1/4/10 구간 = **.02 합가형 성격 가능**. "부수당×수량 vs 묶음 총액" 엔진 evaluate_price 계약으로 확정(디지털 ×qty·아크릴 .02 종단 동일 클래스·추측 적재 금지). benchmark §2 시사점 1.
- **세트 그릇 이미 보유(사실만 명시·이번 스코프 밖)**: `t_prd_product_sets`(28행·하드커버책자 PRD_000072→표지 073+면지 074/075/076 sub_prd)·`t_prd_product_page_rules`(11행·트윈링 8~100·무선 24~300·STEP2)·제본 comp 11종(`COMP_BIND_*`·중철/무선/PUR/트윈링/싸바리/하드커버무선·트윈링+캘린더 4). 신규 테이블 mint 0(set-pricing P-6 정합).
- **흡수 핵심**: 책자는 "그릇 보유·가격 합산 배선 미완"(vessel-gap 아닌 data/배선-gap). 부품 comp 단가행 확보(가격표 제본물 시트) + 상품별 공식 1:1 배선(dbmap round-21 BOOKLET-BIND-WIRE·D-WIRE broken 해소). 페이지수=입력 차원·내지단가=앱 계산(SKU 폭발 금지·C-ST2). 책등=앱 계산 파생(C-ST5).
- **세트 vs 가격 분리[HARD]**: 세트 "구성"(t_prd_product_sets) ≠ 세트 "가격"(부품 합산 공식). 책자는 구성 그릇 보유·가격 합산 미배선 → 다음 종단 designer가 구성 그릇→합산 공식 배선 설계(set-pricing P-6 §가드).

> **★[2026-06-20] 위 "다음 종단 큐"는 본 책자 종단으로 SUPERSEDED — 아래 책자 절이 실제 설계 결정.**

---

# 책자 절 — 설계 결정·DT-BIND-SCOPE 결판·흡수·trade-off·컨펌큐 (반제품 세트·다부품 합산형 종단·5번째·§18 directive "반제품 세트" 첫 본격)

> 입력: `formula-map-booklet.md`·`absorption-candidates-booklet.md`(C-BK1~6·신규 가격축 0)·`set-pricing-patterns.md` P-6·`competitor-pricing-models.md` §7·**라이브 읽기전용 SELECT 실측 2026-06-20**·pricing.py 코드 검증. 권위[HARD] 상품마스터260610·가격표260527 절대.
> ★스코프: 책자 시트 (A) 단일 prd 4(중철/무선/PUR/트윈링 068~071) + (B) 세트 부모 5(하드커버 072·레더HC 077·HC링 082·레더링바인더 088·포토북 100). 엽서북(094)·떡메모(097)는 디지털/문구 종단에서 완료.

## DB-1. ★두 갈래 구조 — (A) 단일 prd 제본비형 + (B) 세트 부모 부품 합산형 (한 공식 강제 금지) `확신도: 높음`

**결정**: 책자를 **하나의 가격 클래스로 강제 금지**. (A) 단일 prd(068~071·표지/내지 시트 컬럼·sets 분해 없음)와 (B) 세트 부모(072~100·표지/면지 별 prd_cd `t_prd_product_sets`)를 구조 분기. **둘 다 다부품 합산형**(제본비 + 표지/내지 인쇄·용지비)이며 차이는 **세트 그릇 사용 여부**(B만 sets 분해).

**근거(실측)**: 라이브 t_prd_product_sets에서 072/077/082/088/100만 표지·면지 별 prd_cd 분해(068~071은 분해 0). 상품마스터 시트는 068~071의 표지/내지를 같은 행 컬럼(옵션 축)으로, 072~100은 sub_prd로 둠. 메모리 `dbmap-print-domain-recipe-philosophy`(상품군마다 다른 도메인 현실)·benchmark §0.

**trade-off**: (A)/(B) 별 처리 vs 단일. 단일 강제는 (A) 시트 컬럼과 (B) sets 분해를 한 그릇에 욱여넣어 오모델. 단 가격 합산 메커니즘(공식+comp Σ)은 동형이라 **공식은 공유 가능**(proc_cd 분기).

## DB-2. ★DT-BIND-SCOPE 결판 = 부품 합산 (제본비 단일항은 미완) `확신도: 중`

**결정**: 책자 가격 = **다부품 합산형**(제본비 + 표지 인쇄·용지비 + 내지 인쇄·용지비[×페이지] + Σ후가공). 현 라이브 "제본비 단일항"은 **완성가가 아닌 미완**(표지/내지/인쇄 미합산).

**근거(증거 종합·formula-map §4·engine-design §3.1)**: 결판 기준[HARD·benchmark]="권위 가격표가 부품별 단가를 주면 부품 합산이 정답". 부품별 단가가 권위에 흩어져 존재 — 제본비=가격표 제본 시트 B01/B02(실재·verbatim)·표지/내지 용지·인쇄=디지털인쇄 종이비/인쇄비 시트(E-2 B02 메모 "표지비용 따로 계산"·E-3 상품마스터 표지/내지 사양 보유). 라이브 표지/내지 comp **0행**(E-4·실측 확정) = 미완.

**trade-off**: 부품 합산 방향은 명확(권위·경쟁사 입증). 단 **표지/내지 단가 소스 시트 매핑은 가격표 재대조 필요**(디지털 종이비 시트가 책자 표지/내지 절가 포함하는지·Q-BK-COVER). 그래서 `확신도: 중`(방향 확정·단가 소스 미확정).

## DB-3. ★제본비 .01 단가형 = 부당(권당) 단가가 옳다 — 교정 불요 (디지털 .01→.02 무비판 전이 금지) `확신도: 높음`

**결정**: 제본비 COMP_BIND_* `.01` 단가형 `subtotal = unit_price × qty`. **디지털 명함 `.01→.02` 교정안 적용 부결**(불요). unit_price=부당(권당) 제본비·min_qty=부수 TIER.

**근거(라이브 반증불가·실측)**:
- **단가 사다리(라이브 SELECT)**: PUR(PROC_000020) 1=5000 → 50=3000 → 1000=1500(단조 하락). **min_qty↑ → unit↓ = 부당 단가의 볼륨디스카운트**. 묶음총액이면 1000부에서 1,500으로 떨어질 수 없음 → **unit=부당가** 확정(GC-BK3 입증).
- **가격표 헤더** `제본/수량`(중철 4부=2,000원/부=부당가). **prc_typ=.01** → component_subtotal(:191-192) `unit×qty`(÷min_qty 미발생).
- **디지털 명함과 단가 의미 정반대**: 명함 3,500=100매 묶음총액(÷100 필요·D-10)·제본비 2,000=부당가(÷ 불요). **같은 `.01`이라도 단가 의미가 정반대라 동형 결함 아님**. 아크릴 COROTTO(개당가)·실사 면적(1장가)·문구 떡메모(권당가)와 동류(DS-2·DT-2 정합).

**trade-off**: cartographer/benchmark가 경계한 "×qty 위험·`.02` 합가형 성격 가능"을 **라이브 단가 의미 확정으로 해소**(반증). 교정 불요·재배선만 하면 정상. **★[HARD] 같은 `.01`이라도 단가 추이로 판별**(하향=부당/권당가 정당·일정/상향 의심=묶음총액 오적재). 디지털 결함을 책자에 무비판 전이 금지.

## DB-4. ★G-BK-2 PRF_BIND_SUM stale 배선 교정 (W1·돈크리티컬) `확신도: 높음`

**결정**: PRF_BIND_SUM formula_components를 **삭제된 COMP_BIND_JUNGCHEOL(del_yn='Y') → 활성 COMP_BIND_TWINRING(del_yn='N'·4 proc_cd)** 재배선. 4상품(068~071) 공유·proc_cd 자동분기.

**발견(라이브 실측 확정)**: PRF_BIND_SUM(use_yn=Y)이 formula_components로 COMP_BIND_JUNGCHEOL **1개뿐**·그 comp **del_yn='Y'**(통합 후 배선 갱신 누락). 활성 통합 COMP_BIND_TWINRING(중철 018/무선 019/PUR 020/트윈링 021·use_dims=[proc_cd,min_qty,proc_grp:PROC_000017]) 미배선.

**근거(공유 + proc_cd 분기 결정·AD-BK1)**: 명함 variant 전용 PRF(D-1)와 **다른 결정** — 제본비는 4 proc_cd 전부 동일 use_dims라 proc_cd가 판별차원으로 안전 분기(`_combo_key` 충돌 없음·NON_QTY_DIMS 정확매칭). 통합 comp 패턴([[dbmap-price-component-grouping]])이 정확히 이 용도. 공식 1개로 4상품 커버(과설계 회피).

**trade-off**: 재배선(formula_components 1행 UPDATE·신규 mint 0) vs 상품별 4 공식. ★**proc_cd 주입 선결**(미주입 시 4 proc_cd 다중매칭 silent 합산·중철 선택해도 무선/PUR/트윈링 행 합산) — CPQ option→proc_cd 주입(Q-BK-PROC). 디지털 G-7·실사 PUNCH 동형 가드.

> **[검증 인계]** del_yn='Y' comp가 `_evaluate_formula` 순회에서 필터되는지 pricing.py 재확인(검증가 E4). 필터 적용=comp 0개=0원·미적용=JUNGCHEOL(중철값) misfire. 어느 쪽이든 4상품 정상 가격 불가 결론 불변 → 재배선 필수.

## DB-5. ★G-BK-1 중철 단가행 오염 교정 (W2·돈크리티컬) `확신도: 높음`

**결정**: COMP_BIND_TWINRING의 중철(PROC_000018) 8행을 **가격표 B01 중철값(삭제된 COMP_BIND_JUNGCHEOL verbatim)** 으로 교정.

**발견(라이브 실측 확정)**: COMP_BIND_TWINRING/PROC_000018 = **1=4000·4=3000·10=2000…**(트윈링 PROC_000021과 byte-동일=통합 시 오복사). 정답 = COMP_BIND_JUNGCHEOL/PROC_000018 = **1=3000·4=2000·10=1500·30=1000·50=1000·70=700·100=700·1000=500**(가격표 B01 중철 verbatim). 무선/PUR/트윈링(019/020/021)은 정상.

**근거**: 가격표 B01 중철 = 부당 제본비(중철 4부=2,000원/부). 삭제 JUNGCHEOL이 정답 보유. 교정 전 중철 4부=3,000(트윈링값)·교정 후=2,000(정답) → 과청구 50%(GC-BK1 입증·돈크리티컬).

**trade-off**: 단가행 8행 UPDATE(verbatim·값 출처=JUNGCHEOL/B01). 멱등·백업·undo(round-23 패턴). dbm-price-arbiter 심의 + 인간 승인 후 dbmap 위임. **단가값=가격표 verbatim·날조 0**.

## DB-6. ★표지/내지 comp = COMP_PAPER·COMP_PRINT 재사용 우선 (search-before-mint·충돌 가드) `확신도: 중`

**결정**: 표지/내지 용지·인쇄비를 **디지털인쇄 COMP_PAPER(56행 실재)·COMP_PRINT_DIGITAL_S1(212행 실재) 재사용 우선**. 신규 표지/내지 전용 comp mint는 **무손실 표현 불가 입증 후**.

**근거(search-before-mint)**: 표지 용지=COMP_PAPER use_dims=[siz_cd,mat_cd]로 표지종이(mat_cd)·완제 사이즈(siz_cd) 룩업·표지 인쇄=COMP_PRINT_DIGITAL_S1. 신규 mint 회피.

**★충돌 가드 [HARD·AD-BK3]**: 표지(disp_seq 2)·내지(disp_seq 4) 둘 다 COMP_PAPER면 **같은 comp_cd 2회 배선 → `_combo_key` 충돌·silent 이중합산/ERR_AMBIGUOUS**(디지털 S1/S2 동형). mat_cd 차원이 표지종이≠내지종이로 분기되어야 각자 1행 매칭. **표지=내지 동일 종이 선택 시 충돌** → 이 경우 **표지/내지 별 comp 분리 정당**(COMP_BOOKLET_COVER_PAPER/INNER_PAPER 신설·채번 MAX+1·`_`·무손실 위해).

**trade-off**: 재사용(신규 0)이 최소이나 충돌 위험. **안전 설계 = 표지/내지 전용 comp 분리**가 유력하나 가격표 단가 소스 재대조 후 확정(Q-BK-COVER). 검증가 E4(comb_key 충돌 재현)로 판정. 그래서 `확신도: 중`.

## DB-7. ★G-BK-4 세트 부모 바인딩 — B02 SSABARI·표지 따로 (W4) `확신도: 중`

**결정**: 하드커버 family(072/077/082/100) 세트 부모에 **제본방식별 공식 바인딩**(하드커버무선=PROC_000023·하드커버트윈링=PROC_000024·B02 SSABARI 통합 comp). 공유 PRF_BIND_SUM + proc_cd 분기 우선·comp 집합 상이 시 전용 공식.

**근거(실측)**: 072/077/082/088/100 라이브 미바인딩(가격계산 불가·source=NONE). B02 SSABARI 통합 comp(PROC_000023 30000~6000·024·098) 실재. B02 메모 "표지비용 따로 계산"=표지 별 comp 합산.

**trade-off**: 공유 공식(신규 0)이 우선이나 (B)는 표지 "따로"+면지+인쇄면지로 (A)와 comp 집합 다를 수 있음 → 상이 시 전용 공식(PRF_HC_MUSEON_SUM 등) 신설(무손실 불가 입증 후). 검증가 E5.

## DB-8. ★레더 링바인더(088) BLOCKED·포토북(100) 컨펌 `확신도: 높음(BLOCKED)`

**결정**: PRD_000088 = **바인딩 보류(BLOCKED)** — 상품마스터 "(보류중)"·제본방식 공란·page_rule 부재(라이브 088 없음 실측). PRD_000100 포토북 = 표지 6 variant 택1·제본방식 컨펌(Q-BK-PHOTO).

**근거(실측)**: page_rules에 088 미존재(068/069/070/071/072/077/082/094/097/100/176만). 100=24/150/2 page_rule 실재·7 sub(내지 101+표지 6+면지 104). 제본방식 미정이면 제본비 comp 결정 불가.

## DB-9. ★세트=BOM·이중수량 가드 (W5·W6) `확신도: 높음`

**결정**: ① 세트 sub_prd(면지 화이트/블랙/그레이)는 **택1 색상 옵션·가격 비기여**(4행 합산 금지=이중계상). ② 제본비=부수 차원만·내지비=부수×페이지(앱 2중 곱)·책등=앱 파생(DB 미저장).

**근거**: sub_prd_qty=1·min/max_cnt NULL(택1)·라이브 면지 comp 0행. page_rules=입력 차원(SKU 폭발 금지·[[dbmap-compute-in-app-db-stores-lookup]]). benchmark P-1b·문구 DT-5·C-BK2/3 정합.

**가드 [HARD]**: 면지 4행 부품 합산 금지(이중계상)·제본비에 페이지 곱하면 오모델(두 수량 축 혼동)·WowPress jobqty 2단 부결(과분화·DB 파생값 저장 금지).

## DB-10. 흡수 적용 (absorption-candidates-booklet — 신규 가격축 0건) `확신도: 높음`

| 흡수후보 | 적용 | 흡수 판정 | naming 가드 |
|----------|------|----------|------------|
| C-BK1 제본방식별 부품 합산 분기 | 제본 comp 11종 + addtn_yn Σ + 세트 부모(DB-1/4/7) | 흡수 불요(동형)·배선-gap | book2025/jobqty 유입 금지 |
| C-BK2 페이지수 입력+곱 런타임 | page_rules 11행(입력)+내지비×페이지 앱(DB-9) | 흡수 불요(정합) | INN_PAGE 유입 금지 |
| C-BK3 책등(seneca) 파생 | 앱 런타임·DB 미저장(DB-9) | 흡수 불요(정합) | seneca 유입 금지 |
| C-BK4 이중수량(부수×디자인수) | bdl_qty+수량 차원/디자인수=주문 곱 | 흡수 불요(그릇 보유) | ORD_CNT/PRN_CNT 유입 금지 |
| C-BK5 WowPress 작업량 2단 | 후니 단일 evaluate_price+앱 환산 | **흡수 부결(과분화)** | jobqty0/jobcost0 유입 금지·단 환산규칙=앱 단서 |
| C-BK6 제본비 prc_typ=부당 단가 | COMP_BIND_* .01·min_qty 하향=부당 정당(DB-3) | 흡수 불요(라이브 결판) | ★.01≠묶음총액(디지털 전이 금지) |

★ **신규 테이블/가격축 신설 = 0건**(rpmeta TP/BN distinct #18 부결 정합·search-before-mint 통과). 신규 comp 가능성 = 표지/내지 전용 comp 1~2건(COMP_PAPER 충돌 시·DB-6·무손실 위해·가격축 아닌 그릇). WowPress 책자=jobqty 2단(부결)·RedPrinting book2025=흡수 대상 아님(후니 동등/우월).

## DB-11. search-before-mint 결과 — 재배선/바인딩 중심·신규 comp 최소 `확신도: 높음`

| 후보 | 라이브 실재? | 판정 |
|------|------------|------|
| 제본비 COMP_BIND_TWINRING(4 proc_cd)·SSABARI(3)·단가행 | **실재(활성)** | 재배선만(W1·신규 0) |
| 중철 단가행 정답값 | **COMP_BIND_JUNGCHEOL(del='Y') verbatim 보유** | 교정 UPDATE(W2·신규 0) |
| 표지/내지 용지비 COMP_PAPER·인쇄비 COMP_PRINT_DIGITAL_S1 | **실재(디지털 종단)** | 재사용 우선(DB-6)·충돌 시 전용 comp 1~2 신설 |
| 세트 그릇 t_prd_product_sets·page_rules | **실재(28행·11행)** | 구성 그릇 보유(가격축 아님·DB-9) |

★ **신규 mint = 최소**(표지/내지 COMP_PAPER 충돌 시 1~2건·Q-BK-COVER 후). 디지털 대형박·아크릴 미러/카라비너보다 막힘 적음(제본 comp·세트 그릇 다 보유). search-before-mint 강 충족.

## 책자 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-BK-COVER** | ★표지/내지 용지·인쇄 단가 소스 — 디지털인쇄 종이비/인쇄비 시트가 책자 표지/내지 절가 포함인가(COMP_PAPER 재사용 가능) vs 책자 전용 단가표(전용 comp 신설). 포함 시 표지=내지 동일 mat_cd 충돌 처리(전용 comp 분리?) | 가격표·dbm-price-arbiter | DB-6 표지/내지 comp 설계·DT-BIND-SCOPE 단가·돈크리티컬 |
| **Q-BK-PROC** | ★제본방식→proc_cd 주입 레이어 — 상품→proc_cd 고정값(중철책자=PROC_000018) 어떻게 selections에 주입(CPQ option vs 상품 메타)·미주입 시 4 proc_cd 다중매칭 silent 합산 | round-6 dbm-option-mapper | W1 재배선 선결·silent 합산 차단·돈크리티컬 |
| **Q-BK-PHOTO** | 포토북(100) 제본방식·표지 6 variant별 단가 소스·면지 104 가격기여 여부 | 실무·가격표 | 포토북 바인딩·표지 comp 차원 |
| **Q-BK-BINDER** | 레더 링바인더(088) "(보류중)" 정체 확정·제본방식 결정 후 바인딩 | 실무·상품마스터 | 088 바인딩(현 BLOCKED) |
| **Q-BK-MYUNJI** | 면지 색상(화이트/블랙/그레이) 단가 동일(가격 비기여·택1 UI)인가 색별 단가차(면지 comp mat_cd 차원) | 실무·가격표 | 면지 가격기여·이중계상 가드 |
| **Q-BK-DSC** | 책자 수량구간할인 t_prd_product_discount_tables 링크 유효성(문구 DSC_STAT_QTY 동형·미점검) | dbmap round-1 | 할인 적용 |
| **CV-BK-FRESH** | 제본 comp 단가행 upd_dt 2026-06-17(cartographer §3.3 "전건 NULL" 부분 stale)·단가값은 B01/B02 verbatim 재현 — freshness 갱신만·결론 불변 | 검증가 E1 | freshness·날조 0 재확인 |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 가격표 verbatim + pricing.py 코드 검증·돈크리티컬 .01 해소·G-BK-1/2 실측 확정). **다부품 합산 단가 소스(표지/내지)는 확신도 중**(Q-BK-COVER 가격표 재대조 후 확정). 실 적용(재배선·단가행 교정·comp 신설·세트 바인딩)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·dbm-price-arbiter·webadmin 코드 직접수정 금지).

---

## 굿즈/파우치 절 — 설계 결정·흡수 적용·search-before-mint 근거·컨펌큐 (2026-06-20 라이브 실측·6번째 종단)

> `engine-design-goods-pouch.md`·`golden-cases-goods-pouch.md` 종단 결정 요약. 굿즈/파우치 = 계산방식은 5종단 중 가장 단순(전 86상품 단일 고정가형), 라이브 가격본체 완성도는 최저(product_prices 0행). 핵심 = **GP-2 변형고정가 그릇 결정(b)formula** + **평탄화 가드(돈크리티컬)**.

### GP-A. 핵심 설계 결정

| ID | 결정 | 확신도 | 근거 |
|----|------|--------|------|
| **GP-DEC-1** | GP-1 단일고정가 55상품 = `t_prd_product_prices` 직접 고정가(PRODUCT_PRICE 경로)·**문구 본체(A)·DT-1 완전 동형**. 명함식 통합 comp 공식 **부결**(과설계·단일가 무손실) | 높음 | calc-draft row 122~123·문구 DT-1 선례·라이브 product_prices 차원 없음 |
| **GP-DEC-2** | ★GP-2 변형고정가 31상품 = **(b)variant-매트릭스 formula 채택**(공식 2 PRF_GOODS_SIZED/VARIANT + comp 2 COMP_GOODS_SIZED/VARIANT·use_dims=[siz_cd]/[opt_cd]·`.01` 단가형 개당가) | 높음 | 라이브 `COMP_POSTEROPT_LINEN_FINISH` use_dims=["opt_cd","min_qty"] 선례 실재(round-23 린넨 COMMIT)·아크릴 면적매트릭스 1축 축소판·엔진 변경 0 |
| **GP-DEC-3** | ★G-GP-3 평탄화 가드[HARD·돈크리티컬] — GP-2를 GP-1처럼 단일 unit_price로 평탄 적재 금지(M 주문에 S가격 오청구). variant 행별 단가를 component_prices use_dims 판별차원으로 충전 | 높음 | round-10 size→option 가격 함정·디지털 인쇄면 silent 합산·실사 면적 동류 |
| **GP-DEC-4** | 수량구간할인 = **4타입 택1**(GOODSA/B·FABRIC·SQUISHY)·문구 단일 DSC_STAT_QTY와 결정적 차이·바인딩 82 실재·base 0 적재 후 곱 | 높음 | calc-draft "수량별구간할인 **타입**"·라이브 t_dsc 4종 verbatim·구간 디테일 실측 |
| **GP-DEC-5** | 세트조합 레이어 **불요**(완제 굿즈=개당단가·부품 합산 아님·set-pricing P-7a)·아크릴·실사·문구 본체 동형 | 높음 | calc-draft 단일 고정가형·라이브 세트 0·RedPrinting tmpl_price 동형 |

### GP-B. ★(b)formula 결판 = search-before-mint (cartographer Q-GP-1 3선택지 해소) [HARD]

라이브 실측이 (b)formula를 결판했다 — GP-2 변형단가는 **신규 가격축이 아니다**:
- 후니 `t_prc_component_prices`는 이미 `opt_cd`·`siz_cd` 차원 컬럼 보유·`t_prc_price_components`는 `use_dims`로 등재 가능.
- ★**라이브에 `use_dims=["opt_cd","min_qty"]` 그릇이 실제 작동 중**(`COMP_POSTEROPT_LINEN_FINISH`·dbmap round-23 린넨 COMMIT) → 무손실 표현 가능 = **vessel-gap 해소**(신규 = 공식 2+comp 2 그릇 뿐·신규 테이블/가격축 0).
- (a)별 prd_cd = 상품 폭증·옵션 UX 분리·round-10 의도 역행 부결. (c)add_price 신규 컬럼 = DDL·과설계 부결.
- ∴ 아크릴 면적 2축을 굿즈 variant 1축으로 축소한 것일 뿐·동일 엔진 경로(:78-192).

### GP-C. 흡수 적용 (absorption-candidates-goods-pouch C-GP1~C-GP9 — 신규 가격축 0건)

| 흡수 후보 | 적용 | 가격엔진 vs dbmap |
|-----------|------|-------------------|
| C-GP1 완제 개당단가(고정가형) | ✅ GP-1/GP-2 = 개당가(부품 합산 아님)·min_qty=1×qty·×qty 폭발 부재 | 가격엔진(본 설계) |
| C-GP9 tiered=수량구간 | ✅ 4타입 DSC_* 택1로 흡수(후니 더 명시적·엔진 3분기 답습 금지) | 가격엔진 |
| C-GP2 본체소재·C-GP3 본체색·C-GP4 형상·C-GP7 구수 | ➡️ **dbmap 위임**(자재축 오염 정리·가격축 아님·상품 inline 고정가 baked-in) | dbm-axis-staged-load ④자재·ddl-proposer |
| C-GP5 variant 3채널·C-GP6 조립 BUNDLE·C-GP8 포장 | ➡️ variant=가격엔진(opt_cd/siz_cd)·조립/포장 BUNDLE=dbmap | 혼합 |

★ **naming 유입 가드 준수[HARD]**: `tmpl_price`·`vTmpl_price`·`tiered_price`·`DIR_MTR`·`WRK_MTR`·`PCS_COD`·`paperinfo`·`THO_CUT` 후니 유입 0. 후니 `frm_cd`/`comp_cd`/`use_dims`/`min_qty`/`t_dsc` 컨벤션 번역.

### GP-D. 신규 mint = 공식 2 + comp 2 (search-before-mint·신규 테이블/가격축 0)

| 신규 | 항목 | 근거 |
|------|------|------|
| 공식 2 | PRF_GOODS_SIZED·PRF_GOODS_VARIANT | GP-2 31상품 전체가 이 2공식에 바인딩(상품별 공식 폭발 금지·맛간장 철학) |
| comp 2 | COMP_GOODS_SIZED(use_dims=[siz_cd])·COMP_GOODS_VARIANT(use_dims=[opt_cd]) | `.01` 단가형 개당가·LINEN_FINISH opt_cd 그릇 선례 재사용 |
| 단가행 | GP-1=product_prices(55상품)·GP-2=component_prices(variant별·평탄화 금지) | 전부 상품마스터 C열 verbatim(designer 창작 0) |
| 할인 | 링크만(t_prd_product_discount_tables)·할인테이블 4종 재사용 | 라이브 실재(82바인딩·구간 디테일) |

GP-1 55상품은 신규 mint **0**(product_prices INSERT만·공식/comp 불요). GP-2만 공식/comp 신설·그것도 2개 그릇 공유.

### GP-E. 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅·미지를 정답으로 위장 안 함)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-GP-1** | ★GP-2 그릇 (b)formula 확정 — variant축이 siz_cd(사이즈등급)인지 opt_cd(용량/면/기종)인지 상품별 판정·option_items 미적재 시 주입 레이어(round-6) | round-6 dbm-option-mapper·실무 | GP-2 31상품 가격 표현·G-GP-3 평탄화 가드 |
| **Q-GP-FIN1** | ★가공 가산 = 개당 1회 vs ×수량[돈크리티컬] — 라벨부착(+300)·맥세이프(+6500)가 개당가산(.01·min_qty=1)인지 1회정액(use_dims=[]·qty=1) | 가격표·실무·dbm-price-arbiter | 후가공 comp prc_typ·디지털/아크릴 동일 클래스 |
| **Q-GP-OPT1** | CPQ option_items 주입 — GP-2 variant(siz_cd/opt_cd) 선택값이 selections에 실리는 레이어·미연결 시 디폴트 variant(0원 침묵 회피) | round-6 dbm-option-mapper | GP-2 변형단가 룩업 작동 |
| **Q-GP-DSC-TYPE** | 상품별 할인타입 바인딩(GOODSA/B·FABRIC·SQUISHY 택1) 권위 = 상품마스터 "구간할인적용테이블" 컬럼 재대조·FABRIC 카테고리단위 신규 파우치 누락 점검 | dbmap round-1·[[dbmap-discount-authority]] | 4타입 구간 곱·과청구 |
| **Q-GP-MATERIAL** | 본체 소재/색/형상/구수 오염 정리(C-GP2~7·.09 74행)는 가격축 아님 → dbmap 위임 확인(가격엔진 스코프 밖) | dbm-axis-staged-load·ddl-proposer | 경계 명확·이중 작업 금지 |
| **Q-GP-PHONE** | 폰케이스 기종(슬림하드/블랙젤리/임팩트/에어팟/버즈·Sheet-only·라이브 미등록) 상품 등록 선행 후 GP-2 PRF_GOODS_VARIANT 바인딩 | round-24·실무 | G-GP-7 상품 등록(가격 적재 선행) |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 상품마스터 C열 verbatim + LINEN_FINISH opt_cd 그릇 선례 + pricing.py 코드 검증·돈크리티컬 평탄화 가드 확정). **GP-2 variant축 의미(siz_cd vs opt_cd)·가공 가산 의미는 확신도 중**(Q-GP-1·Q-GP-FIN1 실무 재대조 후 확정). 실 적용(product_prices INSERT·GP-2 공식/comp/단가행·바인딩·할인 링크)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-axis-staged-load·dbm-ddl-proposer·dbm-price-arbiter·webadmin 코드 직접수정 금지). 본체 소재/색/형상/구수 오염 정리는 **dbmap 자재축 트랙 위임**(가격엔진 스코프 밖·라우팅만).

---

# 스티커 절 — 설계 결정·흡수 적용·search-before-mint 근거·컨펌큐 (이산 siz_cd 단가형+세트 합가형·바인딩 정합 교정 종단·7번째·2026-06-20 라이브 실측)

> `engine-design-sticker.md`·`golden-cases-sticker.md` 종단 결정 요약. 스티커 = **6종단 중 라이브 완성도 최고**(dbmap round-23 적재 완주·공식 4·comp 4·단가행 3,066·바인딩 16/16). 핵심 = **단가행 적재 아닌 "바인딩 siz/mat ↔ 단가행 siz/mat 키 정합 교정"**(WIRE형 결함 4종·G-STK-1~4). 신규 mint 0(전부 재바인딩·이미 실재 코드).

## STK-1. ★스티커 = "구조 완성·정합 미완" — 정합 교정 종단 (단가행 적재 아님) `확신도: 높음`

라이브 실측(2026-06-20)이 cartographer 지도를 전건 확인. 공식·comp·단가행(3,066·가격표 verbatim·값결함 0)·바인딩(16/16 전건) 4계층 모두 실재. 디지털(미배선)·아크릴(미바인딩)·문구/굿즈(고정가 0행)·책자(다부품 미합산)와 결정적으로 다른 **정합 교정 종단** — 결함은 전부 **바인딩 siz/mat이 단가행 siz/mat과 어긋나 evaluate_price no_match/오청구**(formula-map-sticker §6). designer 작업 = 재바인딩/유효성 처리이지 단가 충전 아님.

## STK-2. ★B06 팩 prc_typ 결판 — .02 확정(cartographer 정확·benchmark stale) `확신도: 높음(라이브 실측)`

cartographer "팩/타투 .02 교정 완료" vs benchmark "B06 .01 오적재→.02 선결(54배 왜곡)" 충돌을 **2026-06-20 라이브 직접 실측으로 결판**: COMP_STK_PACK·COMP_STK_TATTOO 모두 **`PRICE_TYPE.02`**. → cartographer 정확, benchmark는 dbmap round-23 COMMIT(2026-06-17/18 문서) 이전 stale 인용. **팩 54배 왜곡(216,000) 위험 부재**(GC-STK3: 4000÷54×54=4,000 재현). 디지털 명함 prc_typ 결판(가격표 행축 "제작수량") 패턴 동형 — 라이브가 자(尺).

## STK-3. ★가격축 3축뿐 — 형상·칼선·재단 = 옵션축(가격직교) [HARD·directive #6 가드] `확신도: 높음`

가격축 = 사이즈(이산 siz_cd) × 소재(mat_cd 7종) × 수량(min_qty)뿐. **형상(원형/정사각/팬시)·칼선·재단입자 = 가격축 아님**(058~063 라이브 실측 = 같은 siz/mat면 형상 달라도 동일 단가). component_prices에 형상 차원 baked-in = 오모델(부결). rpmeta ST 형상 #17 distinct 승격(V-12)은 *옵션 관리 그릇* vessel-gap이지 *가격* vessel-gap 아님(**option-axis ≠ price-axis**·benchmark §2). 형상별 고정사이즈 단가 예외(합판도무송 066)는 별 상품/별 comp(COMP_GANGPAN_PRINT·형상=siz_cd)이지 형상=가격축 아님.

★ **단, 재단입자가 단가 가르면 siz_cd 분리[돈크리티컬]**: 반칼 A4(SIZ_520·5000) vs 완칼 낱장 A4(SIZ_172·4000) — 같은 치수 다른 단가 → siz_cd 별 채번이 정답(dbmap round-23 SIZ_520 분리 COMMIT·G-STK-2 진원).

## STK-4. ★G-STK-1 — 055/056/057 소재 재바인딩(154→153·243→162)이 정답 [HARD·🔴최우선] `확신도: 높음(라이브 3중 증거)`

상품 055/057이 **MAT_000154(유포지·del_yn=Y 논리삭제)**·056이 **MAT_000243(투명전용지)**을 바인딩하나 COMP_STK_PRINT 단가행은 154/243 **0행** → no_match(가격 0). **정답=상품 mat 재바인딩이지 단가행 추가 아님** — 3중 증거: ① MAT_000154 del_yn=Y(이미 삭제·정본 유포=153) ② 형제 058~061·052가 정본 153 바인딩(같은 family 정답 패턴) ③ 단가행 153/162는 가격표 verbatim·옳음(154/243에 단가행 추가하면 deleted/오류 자재에 가격 = 스키마 의도 위반). 교정: 055/057 mat 154→153·056 243→162. dbmap 위임 + dbm-price-arbiter 심의(Q-STK-MAT1: 낱장 B02 단가 정합 확인).

## STK-5. ★G-STK-2 — 052/053/054 반칼 A4/A5/A6 정합 [돈크리티컬·★보정-1 분리·2026-06-22 검증 폐루프] `확신도: 높음(import xlsx 권위+라이브 재실측)`

> **[보정-1 정정]** 기존 STK-5는 "052/053/054 SIZ_172→SIZ_520 일괄 재바인딩"이었다. hpe-validator E1 CONDITIONAL + **독립 라이브 재실측(2026-06-22)이 일괄 묶음을 반증** → 052 경로와 053/054 경로를 분리한다.

**반증 2건(2026-06-22 직접 SELECT):**
1. **052(5소재)도 "정상 아님"**(검증 verdict "052 정상" 정정) — A5(170)만 5소재 36단 완전·**A4(172)는 mat153만 6단(B02 낱장 4,000 오청구)·나머지 4소재 0행(no_match)·A6(196) 전건 no_match.** 052/053/054는 동일 ISO-A 결함 골격(차이=소재 가짓수).
2. **일괄 SIZ_172→SIZ_520 교정이 053/054엔 안 먹힘** — SIZ_520(A4 반칼)엔 5소재(084/153/155/156/242) 36단만·**mat162(투명)/mat163(홀로) 단가행 부재.** 053/054(투명/홀로)를 SIZ_520으로 바꿔도 여전히 no_match. **054(홀로·active)는 바인딩 siz(170/172/196) 전건 mat163 0행 = 현재 견적 자체 불가(🔴 긴급).**

**진원 = 사이즈 정체 혼선이 아니라 import xlsx(가격표260527 분해 권위) 단가행이 라이브 적재 시 누락/충돌:** import xlsx은 mat162·mat163을 **059(A5/124x186)·060(90x190)·SIZ_172(A4)·SIZ_174(A3)에 각 36단 의도**했으나 라이브는 mat163의 172/174를 **전건 누락**·mat162의 172/174를 **6단(B02/B03 낱장)으로만** 적재. 062/063(같은 명시규격 모델·063 use_yn=N이 mat162×059/060 36단으로 가격 가능)이 정답 패턴.

**교정 경로 — 사이즈축별 분리(052/053/054 공통·DB 미적재·추측 INSERT 금지[HARD]):**
| siz | 정체 | 052(5소재) | 053/054(투명/홀로) |
|-----|------|-----------|---------------------|
| A5(170) | =059/124x186 col1 동일가(라이브 153 byte-identical) | 이미 정상(경로 불요) | **059 추가 바인딩(경로 a·062/063 precedent·mint 0)** or 170에 162/163 36단 적재(경로 b·059 verbatim) |
| A4(172) | B01 반칼 정당 사이즈이나 라이브 SIZ_172=B02/B03 낱장 점유 | 반칼 전용 siz 분리(SIZ_520 재사용·5소재 실재) | 반칼 전용 siz + **mat162/163 36단 적재(경로 b·import xlsx verbatim 6,000…)**·SIZ_172 직접 추가 금지(ERR_DUPLICATE) |
| A6(196) | B01·import xlsx 부재 | 바인딩 제거(경로 c) | 바인딩 제거(경로 c)·실판매면 단가 출처 컨펌 |

★ **search-before-mint**: A5=059 재바인딩(mint 0)·A4=SIZ_520 재사용 우선(단 mat162/163 단가행은 import xlsx verbatim INSERT)·반칼 A4 전용 siz 신규 채번은 SIZ_520 재사용 불가 시에만(MAX+1·`_`). dbm-price-arbiter 심의 + dbm-axis-staged-load(②사이즈)/dbm-load-execution. **추측 0·import xlsx verbatim·인간 승인 후.**

## STK-6. G-STK-3 — A6/100x140 단가행 0 = 바인딩 유효성(추측 INSERT 금지) `확신도: 높음(가격표 부재 실측)`

052~054 SIZ_196(A6)·062/063 SIZ_058(100x140) = 모든 comp 단가행 0행. 가격표 B01 6사이즈(A5/90x190/100x148/90x110/A4반칼/A3)에 **A6·100x140 부재** → 단가행 0은 결손이 아니라 binding-validity 위반(가격표에 없는 사이즈 바인딩). 교정 택1: (a) 바인딩 제거(권고·가격표 권위에 사이즈 없음) / (b) 단가 출처 확인 후 verbatim INSERT(현재 출처 미확인 → **추측 적용 금지[HARD·돈크리티컬]**). Q-STK-SIZ1·dbm-price-arbiter.

## STK-7. G-STK-4 — 064 잠정 단가·굿즈 siz 의미혼선 (use_yn=N·긴급도 낮음) `확신도: 높음(BLOCKED)`

064(소량자유형·use_yn=N) 7사이즈 전건 [잠정] B01 col1 규격가(6000/7000) 사이즈무관 복사(실측 미수령)·SIZ_036/043 note=인쇄배경지/인쇄해더택(굿즈 siz 재사용·스티커 의미 충돌). 사용자 "우선 적용·추후변경"(CLAUDE.md §7). 비활성이라 긴급도 낮음 — 활성화 전 실측 소형반칼 단가 + 064 전용 siz 별 채번(굿즈 siz 해소) 선결. Q-STK-064.

## STK-8. 동형결함 3종 모두 구조적 부재 (디지털/아크릴 대조) `확신도: 높음`

- **×qty 폭발 없음**: 단가형(.01)=개당/장당 단가·합가형(.02)=÷min_qty 환산(prc_typ↔단가의미 정합). 디지털 명함(단가의미=세트총액인데 .01) 결함과 정반대.
- **silent 이중합산 없음**: 각 공식 comp 1개(addtn_yn=Y·합산대상 1·라이브 formula_components 실측).
- **min_qty NULL ValueError 안전**: 타투 3·팩 54 명시. ★신규 .02 행 INSERT 시 min_qty 명시 가드 필수(NULL→ValueError·아크릴 CLEAR3T/디지털 박 SETUP 동형).

## STK-9. 세트조합 레이어 불요 (단일본체 묶음단위) `확신도: 높음`

타투(3장세트)·팩(54장세트)=단일 본체의 묶음단위(.02 ÷환산)이지 책자/엽서북 같은 다본체 조합 아님(set-pricing P-8b·문구 DT-5·굿즈 GP-DEC-5 동형). **set-product-design.md엔 "스티커=세트조합 없음(단일본체 묶음단위만)" 기록만**(designer 혼동 방지).

## STK-10. 흡수 적용 (absorption-candidates-sticker C-S1~C-S8 — 신규 가격축/테이블 0건) `확신도: 높음`

| 흡수 후보 | 처리 | 근거 |
|----------|------|------|
| C-S1 형상=가격축 아님·C-S2 재단=공정 | ✅ **가드 채택**(STK-3·가격엔진 형상 차원 부결) | option-axis≠price-axis |
| C-S3 사이즈=이산 siz_cd(면적매트릭스 아님) | ✅ **설계 원칙 못박음**(use_dims=siz_cd·wh_rows 0) | benchmark 동의·dbmap area-dim 제외 |
| C-S4 점착소재 mat_cd 7종 | ✅ 이미 라이브 전개 완료(dbmap "3 collapse" stale) | 라이브 7 mat 실측 |
| C-S5 소재→후가공 disable 227건 | ➡️ **round-6 CPQ constraints 위임**(가격축 아님·data-gap) | dbm-cpq-option-mapping |
| C-S6 형태별 frm_cd 분기 | ✅ frm_cd+prc_typ 데이터 분기(엔진 코드 분기 부결·과분화 경계) | PRF_STK_FIXED/TATTOO/PACK/GANGPAN |
| C-S7 인쇄방식(UV/DTF) | ➡️ 후니 스티커 미실재·watchlist(상품정체+mat_cd) | 권위 엑셀 확인 |
| C-S8 세트형 .02 합가형 | ✅ 이미 라이브 .02(STK-2·타투/팩) | 라이브 실측 |

신규 가격축/테이블 0건(rpmeta ST distinct #18 부결 정합·6종단 누적 결론 일관). naming 가드[HARD]: shape_info·CUT_DFT·MTRL_CD·digital_price/vTmpl_price 후니 유입 금지.

## STK-11. search-before-mint 결과 — 신규 mint 최소(보정-1 반영) `확신도: 높음`

| 결함 | 처리 | 신규 mint |
|------|------|----------|
| G-STK-1 | 상품 mat 재바인딩(153/162 이미 실재) | 0 |
| **G-STK-2 (보정-1 분리)** | ★052/053/054 사이즈별: A5=059 재바인딩(경로 a·mint 0) or 170에 162/163 적재(import xlsx verbatim)·A4=SIZ_520 재사용 + **mat162/163 36단 INSERT(import xlsx verbatim·053/054 전용·경로 b)**·A6=제거 | 0(재바인딩/재사용 우선)·단가행 INSERT는 가격표 verbatim(코드 mint 아님)·반칼 A4 전용 siz 신규 채번은 SIZ_520 재사용 불가 시에만 MAX+1 |
| G-STK-3 | 바인딩 제거 or 단가행 verbatim INSERT | 0(신규 코드 아님) |
| G-STK-4 | 잠정 교체·전용 siz 채번 검토(064 활성화 시) | 0(현재)·채번 시 MAX+1 |

신규 공식/comp/축 = 0. 단 **053/054 투명/홀로는 import xlsx 권위 단가행이 라이브 적재 시 누락**돼 단가행 INSERT(경로 b·verbatim)가 섞인다(코드 mint 아님·가격표 셀 그대로). 디지털(박 comp 신설)·아크릴(미러 공식·카라비너 comp/형상 opt_cd)·책자(표지/내지 comp)보다 우월(재바인딩 중심).

## 스티커 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅·미지를 정답으로 위장 안 함)

| ID | 컨펌 | 라우팅 | 사유 |
|----|------|--------|------|
| **CV-STK-053/054** (★보정-1·🔴 돈크리티컬·active) | 053(반칼투명)·054(반칼홀로·active)의 mat162/163 단가행이 059/060(명시규격)에만·바인딩 siz=170/172/196 → 054 전건 no_match(견적불가)·053 SIZ_172만 B03 낱장 7,000 오청구. **A5=059 추가 바인딩(경로 a) vs 170에 162/163 적재(경로 b)** 택1 / **A4 반칼 전용 siz = SIZ_520 재사용 + mat162/163 36단 적재 vs 신규 채번** 택1 / **A6(196) 바인딩 제거 확정** | dbm-price-arbiter 심의·dbmap | import xlsx verbatim·일괄 SIZ_520 교정 무효(함정)·052 경로 분리·추측 INSERT 금지 |
| **Q-STK-MAT1** | 055/057 mat 153 재바인딩 시 SIZ_172(A4)×MAT_153 단가행이 낱장 B02 4000을 반환하는지(반칼 SIZ_520 5000 아님) 확인 | dbm-price-arbiter·dbmap | 완칼 낱장 단가체계(B02) 정합 |
| **Q-STK-SIZ1** | A6(SIZ_196)·100x140(SIZ_058) 실판매 사이즈인가(바인딩 제거 vs 단가 출처) — 가격표 B01 부재 | dbm-price-arbiter | G-STK-3 추측 적용 금지 |
| **Q-STK-064** | 064 소형반칼 실측 단가 + 굿즈 siz(036/043) 재사용 해소(전용 siz 채번) — 활성화 전 | 실무·채번 트랙 | G-STK-4 의미충돌·use_yn=N |
| **Q-STK-DSC1** | 단가행 min_qty 구간(36단) + t_dsc 구간할인 이중할인 점검(같은 수량축 2번 안 깎이는지)·스티커 t_dsc 바인딩 여부 | dbmap round-1·dbm-price-arbiter | 할인 적용 순서 정합 |
| **Q-STK-TAT1** | 타투 base 2000(1~2장) 미반영(min_qty=3·qty_incr=3 정상주문 base 무발현)·1~2장 주문 허용 여부 | 실무 | G-STK-5 컨펌·정상 경로 GO |
| **Q-STK-PACK1** | 팩 수량 입력 = 장(min_qty=54·÷54)인가 세트(세트당 4000)인가 위젯 UX | 실무·dbmap | G-STK-6 컨펌·현 라이브=장 |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 가격표 verbatim + del_yn=Y/형제 precedent 3중 증거 + pricing.py 코드 검증·B06 prc_typ .02 결판·동형결함 3종 부재 확정). **G-STK-3 단가 출처·064 실측 단가는 BLOCKED**(권위 미수령·추측 적용 금지). 실 적용(소재 재바인딩·siz 재바인딩·바인딩 제거)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-price-arbiter·webadmin 코드 직접수정 금지). 형상/칼선/재단 = 가격축 밖(상품정체·proc_cd·CPQ·라우팅만).

---

# 상품악세사리 — 설계 결정 (AC-1/AC-2 + 이중역할 SKU·7번째 종단·굿즈 GP-1/GP-2 직계 동형)

> 7번째 종단(디지털·아크릴·실사현수막·문구·책자·굿즈/파우치 다음). 굿즈/파우치 GO 설계(GP-1/GP-2·G-GP-1 variant-매트릭스·G-GP-3 평탄화·GP-2 PRODUCT_PRICE 선점 가드)를 직계 전파. 라이브 실측 2026-06-22. 각 결정 출처+확신도.

## D-AC-1. AC = inline 고정가형 단일 유형 (계산공식집초안 row 부재·시트가 권위) `확신도: 높음`

**결정**: 상품악세사리 14상품(67 variant행)을 전부 inline 고정가형으로 설계 — AC-1 단일고정가 3 + AC-2 변형고정가 11. 면적매트릭스·원자합산·세트조합·**수량구간할인 전부 0**.

**근거(실측)**: calc-formula-draft-l1.csv에 상품악세사리 전용 공식 row 부재. 상품마스터 상품악세사리(가격포함) 시트 `가격`(I열)이 가격 권위(L1 67행 inline verbatim). 부자재=인쇄 BOM(자재/공정/도수/판형) 없는 완제 부속 → 공식 합산이 아니라 variant당 고정 단가표. 라이브 product_prices/formula/template_prices 전부 0행(6종단 통틀어 가격사슬 최저).

**흡수**: benchmark C-AC1(레드 tmpl_price·와우 jobcost unit=개) — 개당 고정단가형이 가격공식 클래스로 굿즈 GP-1과 동형. naming(`tmpl_price`/`jobcost`) 유입 금지.

## D-AC-2. AC-1 = PRODUCT_PRICE 직접 고정가 (통합 comp 공식 부결·굿즈 GP-1·문구 DT-1 동형) `확신도: 높음`

**결정**: AC-1 3상품(볼체인1000/와이어링500/리필잉크2500)을 `t_prd_product_prices` unit_price 1행 INSERT(PRODUCT_PRICE 경로). 명함식 통합 comp 공식 부결(과설계).

**근거**: AC-1은 단일 고정가(색상 variant 동가·distinct 가격=1·L1 실측 볼체인 8색 전부 1000). product_prices 1행이 무손실 표현. 소재/사이즈/세트 단가 분기 없어 comp 매트릭스 불필요. 굿즈 GP-1·문구 DT-1 동형 결판.

**★굿즈와 결정적 차이[HARD]**: AC-1엔 **수량구간할인 없음**(부자재 미해당·라이브 t_prd_product_discount_tables 0행 정당). 굿즈 GP-1은 DSC_GOODSA/B 등 4타입 택1이 본질이었으나 부자재는 구간할인 미바인딩 → `_quantity_discount` no-op이 정상. **할인 링크 발명 금지.**

## D-AC-3. AC-2 = (b)variant-매트릭스 formula (G-AC-1 결판·굿즈 G-GP-1 전파·LINEN_FINISH 선례) `확신도: 높음`

**결정**: AC-2 11상품 변형단가를 variant-매트릭스 formula로 — 공식 3(PRF_ACC_SIZED/BUNDLE/VARIANT)·comp 3(COMP_ACC_SIZED/BUNDLE/VARIANT)·use_dims=[siz_cd]/[siz_cd,bdl_qty]/[opt_cd]·variant당 단가행 1행. variant별 별 prd_cd(a)·option_items add_price(c) 부결.

**근거(라이브 search-before-mint 2026-06-22)**: `t_prc_component_prices`에 siz_cd·opt_cd·bdl_qty 차원 컬럼 실재(information_schema). `COMP_POSTEROPT_LINEN_FINISH` use_dims=["opt_cd","min_qty"]·PRICE_TYPE.01 라이브 실작동(dbmap round-23 린넨 COMMIT)=GP-2 그릇 선례. 무손실 표현=vessel-gap 해소(신규 mint=공식 3+comp 3 뿐·신규 테이블/축 0). add_price 컬럼은 라이브 부재(부결).

**흡수**: benchmark C-AC1(b)·굿즈 GP-2 전파. 아크릴 면적매트릭스 1축 축소판.

**trade-off**: 공식 3 vs 상품별 공식 11. 3공식 공유(맛간장 철학)·variant 단가행만 상품별. variant축 의미(규격/묶음/색상)로만 갈라 최소 mint.

## D-AC-4. ★G-AC-2 묶음 .01 팩단가 가드 (합가형 절대 금지·돈크리티컬) `확신도: 높음`

**결정**: COMP_ACC_* prc_typ_cd=`PRICE_TYPE.01`(단가형) 강제. "(50장)"·"(20장)" 묶음수를 합가형(.02·÷min_qty)으로 처리 금지.

**근거(코드)**: inline 가격=1팩 단가(OPP 70x200 1100=50장 1팩당). 단가형(.01)이면 component_subtotal(:177-183)=unit×qty(÷ 미발생). 합가형(.02)이면 unit÷min_qty×qty(:181)로 1100원이 22원/장 환산되어 묶음수 다른 variant 가격 전손(98% 손실·golden GC-AC §2-2 양면). 봉투제작(PRD_000050 별 상품군)은 합가형이나 상품악세사리 봉투는 inline 고정가형으로 정반대.

**★bdl_qty는 식별차원이지 ÷ 분모 아님[HARD]**: 트래싱지 bdl_qty=20/40/100은 단가행 룩업 판별차원(어느 묶음팩이냐)이지 component_subtotal의 ÷min_qty 분모가 아니다(분모는 .02 tier_min_qty·:181). bdl_qty=100 단가행 28000="100장 1팩당"·×qty(팩수) 정당. 책자 제본비 .01 정당 단가·디지털 명함 .01→.02 무비판 전이 금지 교훈 동형.

## D-AC-5. ★G-AC-1 평탄화 가드 + GP-2 PRODUCT_PRICE 선점 가드 (둘 다 돈크리티컬·굿즈 codex 발견 재적용) `확신도: 높음`

**결정**: ① AC-2 variant 각 행을 component_prices 1행+use_dims 판별차원(siz_cd/opt_cd/bdl_qty) 충전(평탄화 절대 금지). ② AC-2 11상품 product_prices INSERT 금지·formula 바인딩만(AC-1 3상품만 product_prices).

**근거(코드)**: ① 평탄 적재 시 OPP 230x350 주문에 70x200 가격(66% 과소)·트래싱지 100장에 20장 가격(78% 과소·golden §2-1 양면). ② 엔진 우선순위 PRODUCT_PRICE→FORMULA(:316→324)로 AC-2에 product_prices 1건이라도 있으면 FORMULA 우회되어 variant 단가 영영 안 먹힘(평탄화보다 더 silent·경고 없음·굿즈 codex Phase5.5 독립 발견). AC-1/AC-2 INSERT 트랙 명확 분리.

## D-AC-6. ★G-AC-3 봉투 addon = TEMPLATE_PRICE 이중역할 (가격 권위 충돌 없음·부자재 고유·굿즈엔 없음) `확신도: 높음`

**결정**: 봉투(001/002/281/282/283)는 독립판매(PRODUCT_PRICE/FORMULA) + 본체 addon(TEMPLATE_PRICE) 이중역할. 양 경로 단가 일관 적재(template_prices INSERT). 동일 variant면 동일 단가 verbatim.

**근거(라이브)**: addon 5행 실재(PRD_000016 엽서→TMPL-000005/006/009/010/011)·template 5행 실재·template_prices 0행. 엔진 우선순위 TEMPLATE_PRICE(:296)→PRODUCT_PRICE(:316)라 다른 테이블·다른 경로(충돌 없음·F-PA-1). template_prices 미적재 시 fallback(:299-300 "기준 상품 가격으로 계산")→product_prices도 0이면 0원 → template 단가 적재가 addon 0원 회피 핵심.

**★template = 단일 variant 인코딩(라이브 핵심)**: 봉투 template은 tmpl_cd에 variant baked-in("OPP접착봉투 110x160mm 50장"). template_prices는 차원 없는 단일 단가(tmpl_cd+apply_ymd PK·unit_price 1) → AC-2 variant-매트릭스를 template 경로에 끌어올 불요(template 자체가 1 variant).

**★돈크리티컬 묶음수 불일치(Q-AC-TMPL·BLOCKED)**: TMPL-000010/011 라벨 "50장"인데 시트 카드봉투(004)는 "10장 1000/1500". template 50장 묶음 단가가 시트에 없음 → 추측 적재 금지·컨펌큐(addon 봉투 실제 묶음 단가 권위 필요). OPP(50장)·트레싱지(20장)는 template 묶음수가 시트 행과 일치 → verbatim 적재 가능.

## D-AC-7. ★OTC 이중등록 사실무근 정정 (cartographer 정정 비준·과업 입력 가설 폐기) `확신도: 높음`

**결정**: "거울/키링류 아크릴↔악세사리 이중등록·가격 권위 충돌" 과업 입력 가설 **폐기**. 상품악세사리 시트(PRD_000001~015 + 281~283)엔 거울/키링 **없음**(봉투/케이스 + 우드/리필 부속뿐).

**근거(라이브 2026-06-22)**: 과업 입력의 "아크릴키링 PRD_146·틴거울183·아크릴뱃지148"은 아크릴/굿즈 시트 상품이지 상품악세사리 시트 상품 아님. 굿즈 거울(183/184/185)은 굿즈 종단 스코프(별도 종단). 상품악세사리 18상품 전수 PRD_TYPE.03(기성품)·prd_nm=봉투/케이스/볼체인/와이어링/천정고리/투명케이스/행택끈/자석/우드/리필잉크. 진짜 이중등록=봉투류 "이중역할 SKU"(D-AC-6)뿐.

**★round-13 정정**: round-13 product-identity가 281/282/283을 PRD_TYPE.05(추가상품)로 기록했으나 라이브 2026-06-22 실측은 셋 다 PRD_TYPE.03(기성품). 라이브 권위 우선(round-13 이후 변화 또는 오기).

## D-AC-8. 색상/형상/용량 = dbmap 자재축 위임 (가격엔진 스코프 밖·굿즈 §5 동형) `확신도: 높음`

**결정**: 색상=자재 오염(볼체인8/리필7 MAT_TYPE.10)·형상/용량 융합 정리는 가격엔진 밖·dbmap 위임. 가격엔진은 inline 고정가 verbatim만.

**근거**: AC-1 색상 동가→가격 비기여. AC-2 카드봉투 색상은 가격축이나 opt_cd variant(자재 아님). 형상/용량(우드길이·3D케이스·5cc)은 siz_cd variant 단가행으로 충분(별 형상축 금지·과분할). ★드리프트: round-13 GATE-1이 와이어링007·행택끈010을 색상자재 오염으로 기록했으나 2026-06-22 라이브 둘 다 0행(stale·라이브 권위).

## D-AC-9. 세트조합 레이어 불요 (완제품·addon은 세트 아님·굿즈/아크릴/실사 동형) `확신도: 높음`

**결정**: 상품악세사리 세트조합 레이어 불요. 부속물(우드 등)은 독립 완제 고정가(C-AC1) + 본체 addon 귀속(A-3) 두 경로로 모델링(세트 분해 아님).

**근거**: t_prd_product_sets sub_prd_cd 0행(라이브). 봉투-엽서·우드행거-포스터 결합은 세트 부품 합산이 아니라 본체+옵션 별 라인(addon). 부속물 BUNDLE(우드+면끈+부착)은 가격이 완제 고정가에 baked-in·자재/공정 분해는 생산 BOM(dbmap·set-pricing A-4). set-product-design 악세사리 절 참조.

## 컨펌큐 (상품악세사리·인간/designer·차단 아님)

| ID | 질문 | 권위 후보 |
|----|------|-----------|
| **Q-AC-PRICE** | 동일 봉투의 독립가(product/formula) vs addon가(template)가 같아야 하나, addon은 별 마진/번들가인가? | pricing.py 경로 분리·designer 결판 |
| **Q-AC-TMPL** | ★카드봉투 template(TMPL-000010/011) "50장"과 시트 카드봉투(004) "10장 1000/1500" 묶음수 불일치. addon 50장 묶음 단가 권위? | 시트에 50장가 부재·실무 권위 필요(BLOCKED) |
| **Q-AC-OPT** | AC-2 variant 룩업 작동 위해 option_items(ref_dim_cd=siz_cd/opt_cd/bdl_qty) 적재 선결(round-6). 미연결 시 디폴트 variant? | round-6 dbm-option-mapper |
| **Q-AC-CEIL** | 천정고리(PRD_000008·use_yn=N·6500) 판매중지 의도? 가격 적재 제외? | round-13 Q-PA-3 미결·라이브 use_yn=N |
| **Q-AC-OTC-CASCADE** | 봉투 addon 단가가 본체(엽서) 사이즈와 캐스케이드(봉투 규격↔엽서 규격 매칭)? 현 캐스케이드 0. | rpmeta PO addon·designer |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 상품마스터 I열 verbatim L1 67행 + LINEN_FINISH 그릇 선례 + pricing.py 코드 검증·굿즈 GP-1/GP-2 직계 동형). **Q-AC-TMPL 카드봉투 50장 묶음 단가는 BLOCKED**(시트 부재·추측 금지). 실 적용(AC-1 product_prices·AC-2 공식/comp/단가행/바인딩·addon template_prices)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-price-arbiter·dbm-axis-staged-load·webadmin 코드 직접수정 금지). 신규 mint=공식 3+comp 3 뿐·신규 테이블/가격축/할인테이블 0. 색상/형상=가격축 밖(상품정체·자재축·라우팅만).

---

# 캘린더 종단 설계 결정 (9번째 종단 · 2026-06-22)

> 캘린더 5 완제품(탁상형·미니탁상형·엽서·벽걸이·와이드벽걸이). 계산방식=원자합산형(디지털 PRF_DGP 직계). 라이브 읽기전용 SELECT 2026-06-22. 권위=상품마스터260610+가격표260527 절대.

## D-CAL-1. 계산방식 = 원자합산형 (디지털 PRF_DGP_A/E 직계 chassis) `확신도: 높음`

**결정**: 캘린더 = 원자합산형(`판매가 = 인쇄비 + 용지비 + (제본비 or 캘린더가공비)`). 디지털 PRF_DGP_A/E chassis 재사용 — 인쇄비(COMP_PRINT_DIGITAL_S1)·용지비(COMP_PAPER) comp 100% 재사용·신규 mint 금지.

**근거**: calc-formula-draft-l1.csv r94 `[원자합산형: 캘린더]` 절대 권위 명문. 1차 가설(variant 고정가형=굿즈 GP-2)은 cartographer가 이미 반증(디자인캘린더 inline=합산 결과 스냅샷이지 매트릭스 단가표 아님). 라이브 COMP_BIND_CAL_*가 제본비를 별 비목 단가행으로 적재한 사실이 합산형 입증. 차이는 페이지수 곱 하나뿐(엽서=1장·캘린더=4~16장).

## D-CAL-2. ★제본비 prc_typ = .01 단가형 ×qty (부당가) — 라이브 결판 `확신도: 높음`

**결정**: 캘린더 제본비(COMP_BIND_CAL_*) = **PRICE_TYPE.01 단가형 ×qty**. 단가=부당(권당)·min_qty(1/4/10/50/100/1000)=tier 룩업 키이지 분모 아님. **합가형(.02) ÷min_qty 적용 절대 금지**(G-CAL-BIND·돈크리티컬).

**근거 (3원 정합·라이브 실측 2026-06-22)**:
- 라이브 COMP_BIND_CAL_DESK130/220/MINI/WALL 4 comp **전부 prc_typ_cd=PRICE_TYPE.01**(직접 SELECT).
- 가격표 B03 = "부당(권당) 단가·수량↑→단가↓ 볼륨디스카운트"(benchmark §4.2 라벨).
- RedPrinting 실측 = 삼각대/제본이 사이즈/수량 종속 단가(297,000@500부=594원/부 ≈ 개당가×수량).
- ★cartographer "수량구간형"·benchmark "부당×수량 .01" 충돌 종결 = **둘 다 같은 것**(.01 단가형 + min_qty tier). cartographer GAP-3 컨펌큐 해소.
- ★디지털 명함과 결정적 다름: 명함 STD 3,500은 "100매 묶음총액"이라 .01→.02 **교정** 필요했으나, 캘린더 제본비는 진짜 **개당가**라 .01이 정답(교정 불요). qty=4 주문 시 16,000(정답) vs 4,000(합가형 붕괴) — GC-CAL-2 입증.

## D-CAL-3. ★페이지수(장수) 곱 = 인쇄비·용지비 load-bearing 차원 `확신도: 높음`

**결정**: 출력매수 = 주문수량 × **페이지수** / 판걸이수(앱 임포지션 계산·DB 미저장). 인쇄비·용지비가 출력판형당 단가 × 총출력판수이고, 캘린더 페이지수(4~16장)가 곱해짐. 누락 시 인쇄비·용지비 4~16배 과소청구(G-CAL-PAGE·돈크리티컬).

**근거**: calc-draft r96 `인쇄비 = [총출력장수/판걸이수] × 인쇄비`·총출력장수=주문수량×페이지수. comp 자체는 페이지수 차원 미보유(디지털 엽서 chassis와 동일·페이지수=수량 배수로 앱이 출력매수에 반영). 판걸이수=앱 계산([[dbmap-compute-in-app-db-stores-lookup]]).

## D-CAL-4. 캘린더가공 add-on = LINEN_FINISH 그릇 직계 (search-before-mint) `확신도: 높음`

**결정**: 캘린더가공 add-on(우드거치대4000·1구타공+끈1000·2구타공+끈1500) = 신규 comp COMP_CALOPT_STAND 1개·use_dims=[opt_cd, min_qty]·.01 단가형 ×qty. opt_cd 차원으로 가공별 단가(평탄화 가드 G-CAL-1). 트윈링제본(2000)은 제본비(COMP_BIND_CAL_WALL)로 분기(가공 아님·제본방식).

**근거 (search-before-mint)**: 라이브 COMP_POSTEROPT_LINEN_FINISH(dbmap round-23 린넨 COMMIT) = use_dims=["opt_cd","min_qty"]·.01·min_qty NULL(×qty)·OPV opt_cd로 가공별 단가(800/1000/2000). 캘린더가공이 정확히 이 그릇 — **신규 테이블/가격축 0**. 신규 = comp 1(CALOPT_STAND)+opt_cd 채번(OPV MAX+1)뿐. 굿즈 GP-2·상품악세사리 AC-2 평탄화 가드 동형.

## D-CAL-5. ★PRODUCT_PRICE 선점 가드 = product_prices 0행 자동 충족 `확신도: 높음`

**결정**: 캘린더 본체 = formula(PRF_CAL_*) 바인딩만·product_prices INSERT 금지. 현 product_prices 0행이라 선점 위험 0이나 적재 시 박제.

**근거**: 라이브 t_prd_product_prices(108~112) 0행 실측. pricing.py 가격소스 우선순위 PRODUCT_PRICE→FORMULA. 본체를 product_prices에 1건이라도 INSERT하면 FORMULA(원자합산) 통째 우회 silent(GP-2 G-GP-3 선례·codex 독립발견). ★디자인캘린더 inline 정찰가를 product_prices에 박으려는 유혹이 위험(D-CAL-7 BLOCKED와 연결).

## D-CAL-6. 공식 분할 = 제본방식(사이즈)별 전용 PRF + proc_cd 판별 `확신도: 중`

**결정**: PRF_CAL_DESK220/DESKMINI/POSTCARD/WALL/WALLWIDE 5 공식 신설. 제본비 comp가 사이즈별 분리(DESK220/130/MINI/WALL)라 한 공식에 다 배선하면 동시매칭 → 제본방식별 전용 PRF + proc_cd(99~102) 판별차원으로 분기(디지털 명함 variant별 PRF 교훈 동형).

**근거**: 제본비 use_dims=[proc_cd, min_qty]·룩업 키=proc_cd(99~102). 상품 공정 바인딩 proc(21트윈링/79타공/76수축포장)과 **완전 별개**(GAP-5 이원화·실측). 상품 proc=생산 BOM·MES / 제본비 proc=가격 룩업. WALL comp는 4 proc 통합(42행)이라 벽걸이/와이드가 어느 제본 골라도 proc_cd 주입으로 정확 1행 매칭.

## D-CAL-7. ★디자인캘린더 inline 합산 골든 = BLOCKED (재현 불가·추측 단가 금지) `확신도: 높음`

**결정**: 디자인캘린더(가격포함) inline 가격(탁상220=10,400·미니=6,500·엽서=4,000·벽걸이=9,900·와이드=24,000)을 §2 원자합산 공식으로 재계산 → **단가행 산식과 깨끗이 재현 안 됨 → BLOCKED 정직 표기**. 추측 단가 INSERT 금지.

**근거 (역산 실측·python 재계산 2026-06-22)**: inline에서 제본비(라이브 verbatim) 빼도 인쇄+용지 잔여(미니2000·엽서4000·탁상5400·벽걸이4900·와이드19000)가 출력판형당 단가×페이지수×판걸이수 산식으로 **깨끗한 정수해를 안 줌**. inline = 에디터형 디자인 상품의 1부 정찰가 스냅샷(장수 칸 공란·소비자 표시가)으로 보임 — 단가행 합산 결과 아님(formula-map §6 정합). benchmark CQ-1(제본/가공 그릇 이중성) 정합. ★두 그릇 충돌(단가행 산식 vs inline 정찰가) → 인간 컨펌(어느 게 권위인지). 1차 설계=단가행 산식(FORMULA), inline은 BLOCKED. inline을 product_prices로 박으면 D-CAL-5 선점 우회까지 발동(이중 위험).

## D-CAL-8. del_yn 정합 — DESK 논리삭제·WALL 통합 (컨펌큐) `확신도: 중`

**결정**: COMP_BIND_CAL_DESK130/220/MINI = del_yn='Y'(논리삭제)·WALL = del_yn='N'(활성·4 proc 통합). 설계 권장 = (a) WALL 통합 comp 단독 사용(전 캘린더 제본비를 WALL 하나로·proc_cd 분기). DESK 부활 불요. 단가 양쪽 동일(verbatim)→가격 불변·배선 경로만 다름.

**근거**: 라이브 실측 del_yn. WALL이 99/100/101/102 단가행 42행 통합 보유. ★권위 미확정(WALL 통합 의도 vs DESK 분리 의도) → 인간 컨펌(Q-CAL-BIND-DELYN). dbm-price-arbiter 심의.

## 컨펌큐 (캘린더·인간/designer·차단 아님)

| ID | 질문 | 권위 후보 |
|----|------|-----------|
| **Q-CAL-GOLDEN** | ★디자인캘린더 inline 정찰가(10,400 등) vs 단가행 산식 — 어느 게 권위? inline을 product_prices(GP-1)로 갈지 단가행 산식(FORMULA)로 갈지 | 상품마스터↔가격표 교차·인간(BLOCKED) |
| **Q-CAL-BIND-DELYN** | COMP_BIND_CAL_DESK130/220/MINI(del_yn=Y) — WALL 통합 사용(부활 불요) vs DESK 부활? | dbm-price-arbiter·인간 |
| **Q-CAL-FIN** | 캘린더가공 add-on(우드4000·타공1000) 개당 가산(×수량) vs 주문당 정액? | calc-draft r98=개당 가설·상품마스터 명시 부족·인간(굿즈 Q-GP-FIN1 동일) |
| **Q-CAL-PROC-INJECT** | 사이즈→제본비 proc_cd(99~102) 자동주입 option_items 적재 선결(현 0행)·미연결 시 디폴트 제본방식? | round-6 dbm-option-mapper |
| **Q-CAL-DESK130** | 탁상형(108) 220/130 두 사이즈 — 한 공식 proc 분기 vs 별 상품/공식 분리? | designer·라이브 사이즈 구조 |
| **Q-CAL-PLATE** | 와이드 plate=SIZ_000292(304x629)인데 인쇄비 단가행 plt_siz=SIZ_000077(3절·300x625) — 와이드 인쇄비 룩업 판형 정합? | 가격표·plate↔단가행 대조 |
| **Q-CAL-PKG** | 수축포장(PROC_000076·탁상형)·개별포장 가격 영향(추가가격 칸 공란·무료 vs 가산)? | 상품마스터·인간 |
| **Q-CAL-ENVELOPE** | 캘린더봉투(PRD_000005·012-0008·2400~2500) addon vs 독립상품 경계? | 봉투제작 트랙 위임(엽서 봉투 동형) |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 제본비 prc_typ 라이브 결판 + LINEN_FINISH 그릇 선례 + 디지털 PRF_DGP 직계 동형 + product_prices 0행 선점 가드 자동 충족). **★디자인캘린더 inline 합산 골든은 BLOCKED**(역산 비정합·추측 단가 0·Q-CAL-GOLDEN). 신규 mint = **공식 5(PRF_CAL_*) + comp 1(COMP_CALOPT_STAND) + opt_cd 채번뿐**·신규 테이블/가격축/할인테이블 0·search-before-mint 9연속 통과. 실 적용(PRF_CAL_* 신설·formula_components 배선·product_price_formulas 바인딩·COMP_CALOPT 단가행)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-price-arbiter·dbm-axis-staged-load·webadmin 코드 직접수정 금지). 제본비 단가행 무변경(이미 .01·verbatim).

---

# 포토북 종단 설계 결정 (10번째 종단 · 2026-06-22)

> 포토북 = 반제품 세트(부품합산형 + 페이지 선형 증분). 책자(5번째 full 분해)와 갈리는 두 번째 본격 세트 종단. 라이브 읽기전용 SELECT 2026-06-22. 권위=상품마스터260610 `포토북(가격포함)` 시트(inline `가격_기본(24P)`+`가격_추가(2P)당`·row17 명문 `상품단가+페이지당단가적용`)+가격표260527(포토북 전용시트 부재·제본/디지털 보조) 절대.

## D-PB-1. 계산방식 = 부품합산 세트형 + 페이지 선형 (inline 고정가형 아님·캘린더 정찰가와 정반대) `확신도: 높음`

**결정**: 포토북 = `판매가 = base24[siz,표지타입] + ceil((N−base_min)/2)×per2p[siz] (× 부수)`. PRD_TYPE.04(가격포함 고정가형 디폴트)이나 **inline 단일 고정가형(굿즈/악세사리/디자인캘린더) 아님** — 페이지 차원이 가격을 선형 변동하므로 합산형 공식기반(FORMULA).

**근거(실측)**: 상품마스터 row17 명문 `상품단가+페이지당단가적용`(공식이 시트에 직접 규정·캘린더 정찰가와 결정적 차이). `가격_기본(24P)`(variant 고정)+`가격_추가(2P)당`(페이지당) 2-필드 산식. per2p가 imposition cost-driven(§D-PB-3)=진짜 비용 기반. 라이브 포토북 공식/바인딩/product_prices 전부 0행(WIRE).

**흡수**: benchmark §3 "세 경쟁사 모델(RP digital_price 면수합산·RP tmpl_price 에디터완제·WP jobqty 2단) 전부 후니 base24+페이지증분으로 무왜곡 환원·신규 가격축 0". naming(digital_price/tmpl_price/INN_PAGE/seneca) 유입 금지.

## D-PB-MODEL. ★PRD_TYPE.04 고정가형 디폴트 ↔ 합산형 공식기반 충돌 결판 = FORMULA 재분류 (product_prices 금지) `확신도: 높음`

**결정**: 포토북을 **합산형 공식(PRF_PHOTOBOOK_SUM·base24 comp + per2p comp)으로 모델링**. 고정가형 `t_prd_product_prices` 단독 **부결**(페이지 차원 부재·SKU 폭발).

**근거(코드·benchmark C-PB1)**: 고정가형 product_prices는 prd_cd당 수량×옵션 직접단가일 뿐 **페이지 차원이 없다**. 페이지수마다 다른 가격(24P=15,000·26P=15,500·…·150P=46,500)을 product_prices 행으로 전개하면 **(페이지 64단계 × 사이즈 × 표지) SKU 폭발**(책자/디지털 페이지 SKU 폭발 가드 위배). → **합산형 공식이 정답**(base24 + 앱계산 증분횟수 × per2p). `schema-design-intent-map` 고정가형 분류는 **페이지 차원 추가 전 stale**.

**★G-PB-PRODPRICE 선점 가드[HARD·돈크리티컬]**: base24를 `t_prd_product_prices`에 INSERT하면 엔진 가격소스 우선순위 PRODUCT_PRICE(:316)→FORMULA(:324)로 **FORMULA(per2p 페이지 가산) 통째 우회 silent** → 페이지 가산 영영 안 먹힘(경고 없음). 현 product_prices 0행=자동충족·적재 시 박제. 캘린더 G-CAL-2·GP-2 G-GP-3·악세사리 G-AC-3 동형(엔진 :315-330 선점).

**trade-off**: FORMULA 바인딩(공식1+comp2 신설) vs product_prices 132행(12 variant × 11 페이지) 폭발. FORMULA가 최소·무손실. 단 PRD_TYPE.04 디폴트와 시맨틱 충돌(LOW·가격 무영향·dbm-price-arbiter 시맨틱 정정 큐).

## D-PB-2. base24 = 부품 통합(internalize)·full 분해 부결 (책자 DT-BIND-SCOPE와 정반대) `확신도: 높음`

**결정**: base24(표지/내지/제본/면지 부품)를 **COMP_PHOTOBOOK_BASE 통째 단가행**으로 적재. 책자처럼 표지/내지/제본 별 comp full 분해 **부결**.

**근거(benchmark P-9a·DT-PB-SCOPE 결판)**: 결판 기준[HARD]="권위 가격표가 부품별 단가를 주면 부품 합산·완제 통합단가를 주면 통합". 포토북 권위=상품마스터 base24 완제 통합값(15,000 등)·**포토북 전용 가격표 시트 부재**(부품 단가표 없음). 책자는 가격표 제본 시트 B01/B02가 부품 단가를 줘서 full 분해였으나, 포토북은 base24 통합값만 줌 → **부품 분해 금지·base24 통째**. base24 부품 역산(PUR5000+내지6000+표지/면지4000=15,000)은 근사 확인용이지 적재 안 함(부품 정확 단가행 직매칭은 표지 무광코팅/면지 미해소 BLOCKED·Q-PB-COAT/FACE).

**trade-off**: base24 통째(comp 1·단가행 12) vs 부품 4 comp 합산. 통째가 무손실·verbatim·안전(부품 분해 시 추측 단가·COMP_PAPER 표지/내지 2회 배선 충돌·base24 합 불일치 3중 위험). search-before-mint: 인쇄/용지/제본/코팅 comp 전부 라이브 실재(재사용)나 base24에 묶여 **직접 배선 안 함**·신규 base comp는 완제 통합값 무손실 위해 정당(기존 comp로 base24 표현하려면 부품 분해 필수인데 부품 단가 미권위).

## D-PB-3. per2p = siz_cd만 차원·표지 무관 (benchmark C-PB4·돈크리티컬 가드) `확신도: 높음`

**결정**: COMP_PHOTOBOOK_PAGE use_dims=`[siz_cd]`(표지 mat_cd 제외). base24 comp use_dims=`[siz_cd, mat_cd]`와 **차원 분리**.

**근거(상품마스터 verbatim)**: per2p가 **사이즈만 종속**(8x8=500·10x10=1,000·A5=300·A4=600), 표지타입 **무관**(같은 사이즈면 하드/레더하드/소프트 동일 per2p·CSV row3~5 전건 500). imposition cost-driven 단조(§D-PB-3 입증): A5 4-up=300 < 8x8 2-up=500 < A4 2-up=600 < 10x10 1-up=1,000(큰 사이즈일수록 페이지당 비쌈·면적 비례).

**★가드[HARD·돈크리티컬]**: **per2p에 mat_cd(표지) 차원 넣으면 단가행 중복·오청구**. 기본가 차원(siz×표지)과 페이지단가 차원(siz만)을 혼동 금지(C-PB4). 두 comp가 서로 다른 comp_cd·다른 use_dims라 silent 이중합산 없음(각자 1행 매칭).

## D-PB-G-PB-PAGE. ★페이지수 곱 = 내지비(per2p)에만 적용·전역 qty 금지 (돈크리티컬·캘린더 G-CAL-PAGE 양방향 동형) `확신도: 높음`

**결정**: 페이지 증분횟수 `ceil((N−base_min)/2)` = **per2p 항에만 곱**. base24엔 페이지 곱 금지(base24=이미 base_min P 포함 통합값). 부수(Q)는 base24·per2p 둘 다 곱. 증분횟수=앱 런타임 계산(DB는 base24·per2p 단가만 룩업).

**근거(row17 산식·코드)**: `포토북(N,Q) = base24×Q + per2p×ceil((N−base_min)/2)×Q`. 페이지 곱 누락 시 8x8 하드 24P=15,000 vs 150P=46,500(3.1배) → 150P를 15,000원에 **과소청구**(돈크리티컬). 반대 오류(증분횟수를 base24에도 곱)=base 과대청구(캘린더 CX-CAL-A 양방향). 페이지 64단계를 행 베이크 금지(SKU 폭발·benchmark P-9d·[[dbmap-compute-in-app-db-stores-lookup]]).

**★양방향 가드[HARD]**: G-PB-PAGE = ① 페이지 곱 누락(내지비 소실·저청구) ② 전역 qty에 페이지 곱(base24 과청구). base24=×부수만·per2p=×증분횟수×부수. 음수 가드(N≤base_min→증분 0·base24만·page_rule이 N<base_min 차단).

## D-PB-PAGEBASE. ★base_min = 하드 24 vs 소프트 4 (Q-PB-PAGEBASE·돈크리티컬) `확신도: 중`

**결정**: base_min은 표지타입별 page_rule 최소 — 하드커버/레더하드커버=24·소프트커버=4(CSV `4/6/8/…` 실측). 증분횟수 산식의 시작점이 base24 기준 페이지(하드 24·소프트 4)에서 출발.

**근거(CSV verbatim)**: 하드/레더하드 page `24/150/2`·소프트 page `4/—/2`(`4 / 6 / 8 / 10 / 12 / 14`). 소프트 page_min=4 → base24(소프트 12,000)가 **4P 기준** 개연(소프트는 페이지 적게 시작). per2p는 소프트도 siz 종속(8x8 소프트 500).

**★컨펌큐 Q-PB-PAGEBASE[HARD·돈크리티컬]**: 소프트커버 base가 4P 기준이면 증분 시작=4·24P 기준이면 24. 잘못하면 소프트 페이지 증분 10단계(4→24) 과소/과대청구. **base_min은 차원 아님 → page_rule(소프트 page_min=4)+앱 산식이 주입**(상품별 page_rule 권위). 인간 컨펌 후 확정·`확신도: 중`.

## D-PB-MAT. 표지타입 = mat_cd 매핑 (하드 005/레더하드 006/소프트 007·레더 갭) `확신도: 중`

**결정**: base24 mat_cd = 표지타입 3종 — 하드커버=MAT_000005·레더하드커버=MAT_000006·소프트커버=MAT_000007(라이브 실측). 8x8 base24: 하드 15,000/레더하드 23,000/소프트 12,000.

**근거(라이브 2026-06-22)**: MAT_000005=하드커버·006=레더하드커버·007=소프트커버 실재. sub_prd 102(하드)/105(레더하드)/107(소프트)·103(아트250+무광=하드 표지의 종이)·**106(레더)**=레더하드커버 표지의 소재 variant(별 base24 행 아님·레더하드=23,000에 포함).

**★컨펌큐 Q-PB-MAT**: 표지타입↔mat_cd 정확 매핑(레더 106이 레더하드커버 base24에 묶이는지·별 base24 행인지)·추측 금지·verbatim. `확신도: 중`(라이브 mat 실재·시트 표지타입 3종 vs sub_prd 6종 경계 컨펌).

## D-PB-COAT/FACE. 표지 무광코팅·면지 = base24에 묶임 (Q-PB-COAT 해소·Q-PB-FACE 추정) `확신도: 중`

**결정**: 표지 무광코팅(아트250)·면지(그레이)는 base24에 internalize(외부 미배선). 직접 합산 안 함.

**근거(라이브 2026-06-22)**: ★**COMP_COAT_MATTE(무광코팅비) 실재**(.01)·**COMP_PAPER 아트250(MAT_000081=77.75) 실재** → cartographer "코팅 comp 탐색 필요"·gap-board "아트250 0행" stale·해소(재사용·신규 mint 0). 단 base24 통째 적재라 이 부품 comp들은 base24에 묶여 직접 배선 안 함(참고용 인벤토리). 면지=택1 색·가격 비기여 추정(책자 면지 선례).

**★컨펌큐 Q-PB-COAT(코팅 단가행 충전 확인·comp 존재≠충전)·Q-PB-FACE(면지 색별 단가차 여부·동일가면 비기여)**: base24 통째 적재면 둘 다 base24에 흡수되어 영향 없음. `확신도: 중`(부품 정확 역산은 컨펌 후·base24 통째로 골든 재현).

## D-PB-4. 세트 sub_prd = BOM·이중계상 가드 (W4·G-PB-SET·책자 DB-9 동형) `확신도: 높음`

**결정**: sub_prd 7행(내지 101·표지 102/103/105/106/107·면지 104)=생산 BOM·가격 비기여. base24+per2p 공식 Σ만 가격(표지 5 variant 합산 금지=택1·면지 비기여).

**근거**: sub_prd_qty=1·min/max_cnt NULL(택1)·라이브 sub_prd 가격 0행. set-product-design §14 명시. benchmark P-9b·P-9c("이질 N장 assortment" REFUTED·한 책 부품 구성). 가드[HARD]: 표지 5 variant 부품 합산 금지(이중계상)·1권=parent 1개·페이지=면수(여러 권 발주=부수 qty 별 차원).

## D-PB-5. 흡수 적용 (absorption-candidates-photobook C-PB1~7 — 신규 가격축 0건) `확신도: 높음`

| 흡수후보 | 적용 | 흡수 판정 | naming 가드 |
|----------|------|----------|------------|
| C-PB1 페이지 증분 단가 | (a)합산형 공식(base24 comp+per2p comp×앱증분) — (b)고정가형 product_prices 페이지폭발 GAP | **흡수=설계 결정**(D-PB-MODEL·합산형) | INN_PAGE 유입 금지 |
| C-PB2 표지×사이즈 기본가 매트릭스 | base24 use_dims=[siz_cd,mat_cd] 2차원 | 흡수 불요(동형) | CVR_MTRL_CD 유입 금지 |
| C-PB3 에디터 완제 단가 | 에디터=주문채널·가격 분리(base24 공식) | 흡수 불요(동형) | tmpl_price 유입 금지 |
| C-PB4 per2p 사이즈 종속(표지 무관) | per2p use_dims=[siz_cd]만(D-PB-3) | 흡수 불요(정합·돈크리티컬 가드) | — |
| C-PB5 책등(seneca) 페이지 파생 | 앱 런타임·DB 미저장(14-3) | 흡수 불요(정합) | seneca 유입 금지 |
| C-PB6 자재↔후가공 비활성 | round-6 CPQ constraints(책자 공통·포토북 고유 아님) | 흡수후보(제약 레이어) | pdt_disable_pcs_info 유입 금지 |
| C-PB7 WowPress 작업량 2단 | 후니 단일 evaluate_price+앱 환산 | **흡수 부결(과분화)** | jobqty0/jobcost0 유입 금지 |

★ **신규 테이블/가격축 신설 = 0건**(rpmeta PH distinct #18 부결 정합·search-before-mint 통과). 신규 = 공식 1(PRF_PHOTOBOOK_SUM)+comp 2(BASE/PAGE)뿐. WowPress 포토북=미관측(보강 불가·정직 기록).

## D-PB-6. search-before-mint 결과 — 신규 = 공식 1 + comp 2 (인쇄/용지/제본/코팅 재사용) `확신도: 높음`

| 후보 | 라이브 실재? | 판정 |
|------|------------|------|
| 제본 PUR COMP_BIND_PUR(8행·.01·5000~1500/부) | **실재(재사용)** | base24에 묶임(직접 배선 0) |
| 내지/표지 용지 COMP_PAPER(몽블랑130=77.03·아트250=77.75) | **실재(재사용)** | base24에 묶임 |
| 인쇄 COMP_PRINT_DIGITAL_S1 | **실재(재사용)** | base24에 묶임 |
| 표지 무광코팅 COMP_COAT_MATTE(.01) | **실재(재사용)** | base24에 묶임·Q-PB-COAT 해소 |
| 세트 그릇 t_prd_product_sets(7행)·page_rule(24/150/2) | **실재** | 구성 그릇(가격축 아님·D-PB-4) |
| **base24 comp COMP_PHOTOBOOK_BASE** | **부재** | **신설**(완제 통합단가 무손실·채번 MAX+1·`_`) |
| **per2p comp COMP_PHOTOBOOK_PAGE** | **부재** | **신설**(페이지당단가·siz_cd) |
| **공식 PRF_PHOTOBOOK_SUM** | **부재** | **신설**(부품집합 상이로 책자 PRF_BIND_SUM 공유 부결) |

★ **신규 mint = 공식 1 + comp 2뿐**(인쇄/용지/제본/코팅 전부 재사용·base24 묶음). 캘린더(공식5)·디지털 대형박·아크릴 미러보다 막힘 적음·search-before-mint 10연속 통과.

## 포토북 컨펌큐 (인간/실무·dbm-price-arbiter 라우팅·미지를 정답으로 위장 안 함)

| ID | 컨펌 항목 | 누구 | 영향 |
|----|----------|------|------|
| **Q-PB-PAGEBASE** | ★소프트커버 base_min=4 vs 24(증분 시작점) — 소프트 base24가 4P 기준인지 24P 기준인지 | 상품마스터·실무 | 소프트 페이지 증분 정확성·돈크리티컬 |
| **Q-PB-MAT** | 표지타입↔mat_cd 매핑(하드 005/레더하드 006/소프트 007)·레더(106)가 레더하드 base24에 묶이는지 별 행인지 | 라이브·실무 | base24 mat_cd 판별 정합 |
| **Q-PB-COAT** | 표지 아트250 무광코팅 COMP_COAT_MATTE 단가행 충전 확인(comp 존재≠충전)·base24 통째면 무영향 | 가격표·실무 | base24 부품 역산(통째 적재로 우회) |
| **Q-PB-FACE** | 면지(그레이) 가격기여 — 동일가면 비기여(택1 UI)·색별 단가차면 base24 분기 | 실무·가격표 | 면지 가격기여·이중계상 가드 |
| **Q-PB-PER2P** | per2p 정확 단가 소스 — 상품마스터 `가격_추가(2P)당` verbatim(8x8 500·A4 600)이 imposition cost-driven인지 임의값인지 | 상품마스터(verbatim 권위) | per2p 단가행(이미 verbatim) |
| **Q-PB-SOFT8** | 10x10 소프트커버(row8) base24 공란 — 단가 미정(BLOCKED) | 상품마스터·실무 | 10x10 소프트 단가행(추측 금지) |
| **Q-PB-DSC** | 포토북 부수 수량구간할인 t_prd_product_discount_tables 링크 — 부자재 미해당(악세사리 D-AC-2 동형)인지 적용인지 | dbmap round-1 | 할인 적용 |
| **Q-PB-OPT** | 표지타입/사이즈 선택값→mat_cd/siz_cd 자동주입 option_items(round-6)·미연결 시 디폴트 variant(0원 침묵 회피) | round-6 dbm-option-mapper | base24 매칭 작동 |

★ 본 설계는 **구조 레벨 확신도 높음**(라이브 SELECT 실측 + 상품마스터 inline verbatim + row17 명문 산식 + per2p imposition cost-driven 입증 + 재사용 comp 실재 + product_prices 0행 선점 가드 자동 충족). **소프트 base_min·표지 mat_cd 매핑·면지 가격기여는 확신도 중**(Q-PB-PAGEBASE·Q-PB-MAT·Q-PB-FACE 컨펌 후 확정). **10x10 소프트(row8)는 BLOCKED**(시트 공란·추측 금지). 신규 mint = **공식 1(PRF_PHOTOBOOK_SUM)+comp 2(BASE/PAGE)뿐**·신규 테이블/가격축/할인테이블 0·search-before-mint 10연속. 실 적용(공식 신설·comp 신설·base24/per2p 단가행 충전·부모 100 바인딩)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-load-execution·dbm-axis-staged-load·dbm-ddl-proposer·dbm-price-arbiter·webadmin 코드 직접수정 금지).

---

# ★Q-CAL-GOLDEN 결판 — 두 "가격포함" 시트의 inline 분기 기준 (사용자 directive·메인 인간 결판 큐)

> 사용자 directive: 디자인캘린더 inline=정찰가 스냅샷 결판을 포토북 종단에서 명문화. 두 "가격포함" 시트(디자인캘린더·포토북)가 inline 가격을 어떻게 처리하는지 **분기 기준**을 못박아 메인이 인간 결판 큐에 사용.

## 분기 기준 [HARD] — inline 가격의 단가행 재현성

| 기준 | (가) 공식화 가능 → FORMULA | (나) 정찰가 스냅샷 → BLOCKED |
|------|---------------------------|------------------------------|
| **inline 재현성** | 단가행 산식으로 정수·일관 재현 | 비정수해·재현 불가 |
| **산식 명문** | 시트에 산식 명문(`상품단가+페이지당단가`) | 없음(단일 정찰가) |
| **단가 비용추세** | 비용 기반(imposition 단조 등) | 임의 표시가 |
| **처리** | base24/per2p 단가행 적재(verbatim)·공식 바인딩 | inline=권위·**추측 단가 INSERT 금지·BLOCKED 정직** |

## 두 시트 판정

| 시트 | inline 분해 | 정수해 | 산식 명문 | **판정** | 처리 |
|------|-------------|--------|-----------|----------|------|
| **디자인캘린더** | 유효판수 비정수(1.31/0.49/1.29/1.57/6.10·python 역산) | ❌ | **없음** | **(나) 정찰가 스냅샷 → BLOCKED** | inline=권위·추측 INSERT 금지·product_prices도 금지(선점 우회 이중위험)·**견적 비대상 or 인간 결판** |
| **포토북** | base24=variant 고정·per2p=cost-driven 선형 | 🟡 부분 | **있음**(row17) | **(가) 공식화 가능** | base24/per2p 단가행 적재(verbatim)·PRF_PHOTOBOOK_SUM 바인딩·단 10x10소프트 BLOCKED(공란) |

★ **결정적 차이**: 디자인캘린더는 산식 명문 부재 + 인쇄+용지 잔여가 출력판형당 단가×페이지수×판걸이수 산식으로 **깨끗한 정수해를 안 줌**(에디터형 1부 정찰가 스냅샷·소비자 표시가). 포토북은 **row17에 산식 명문** + per2p가 imposition cost-driven(A5 300<8x8 500<A4 600<10x10 1000 단조) = 진짜 공식. **둘 다 "편집기형 디자인 상품"이나 가격 모델이 정반대**(캘린더=정찰가 BLOCKED·포토북=cost-driven 공식화).

## 인간 결판 큐 (메인 사용)

| 시트 | 권위 후보 | 결판 필요 |
|------|-----------|-----------|
| **디자인캘린더** | **inline=권위**(정찰가)·산식 불가 | 추측 단가 INSERT 금지 비준·정찰가를 product_prices(GP-1 경로)로 갈지 견적 비대상으로 둘지(Q-CAL-GOLDEN) |
| **포토북** | **row17 산식=권위**(base24+per2p) | base24 통째 적재 vs 부품 분해(Q-PB-COAT/FACE 해소 후)·소프트 base_min(Q-PB-PAGEBASE) |
| 공통 | 두 시트 모두 "편집기형 디자인 상품"·편집기 baked spec은 옵션 미노출(시트 메모) | inline 재현성으로 공식화/정찰가 분기(본 기준) |

★ **★두 시트 분기 기준 명문화 완료** — 메인이 인간 결판 시 "inline이 단가행 산식으로 재현되는가"를 잣대로 캘린더(BLOCKED)·포토북(공식화)을 가른다. 추측 단가 INSERT 금지·날조 0·정직 BLOCKED 유지.

---

# 디자인캘린더(가격포함) 설계 결정 (11번째·최종 종단)

> `engine-design-design-calendar.md`·`golden-cases-design-calendar.md` 종단 결정. 라이브 실측 2026-06-22. 각 결정 출처+확신도.

## D-DCAL-1. 계산방식 = 정찰가 스냅샷 [BLOCKED·공식화 불가] (Phase 1 수렴 비준)
- **결정**: inline 7건(10400/9700/6500/6500/4000/9900/24000)을 단가행 산식으로 공식화하지 않는다(추측 단가 INSERT 금지). inline=정찰가 권위.
- **근거**: inline-authority-evidence §1.3 python 독립 역산 — 유효판수 1.313/0.486/1.285/1.574/6.104 전부 비정수·페이지수와 정수 배수 무관(미니 0.486판으로 26P 물리 불가). 일반 캘린더(원자합산형)·포토북(per2p cost-driven 선형·row17 산식 명문)과 결정적 대비.
- `확신도: 높음` · 선례: GC-AC15 카드봉투·booklet 088·calendar §3 BLOCKED 정직 동형.

## D-DCAL-2. ★G-DCAL-DUAL 결판 = 정찰가 채택(.01 단가형 min_qty=1) + 주문방법 차원 분기 (최우선·돈크리티컬)
- **결정**: 동일 prd_cd(108~112) 이중 가격을 **① 정찰가 채택**(고정가형 .01 단가형 min_qty=1·PRF_DCAL_*)으로 결판. 일반 캘린더 PRF_CAL_*(산식)과 **별 공식·주문방법 분기**(편집기→DCAL·업로드→CAL). 공식 통합(②)·별 prd 분리(③) 부결.
- ★**prc_typ 표기 [validator 라이브 재실측 2026-06-22]**: 라이브 PRICE_TYPE enum = `.01·.02`뿐(`.03` 부존재). "고정가형 정찰가"는 라이브에 .03 그릇이 없으므로 **.01 단가형 + min_qty=1 단일 단가행**(정찰가=1부 단가)로 표현·가격 결과 불변(굿즈 GP-1·악세사리 inline 동일 표현).
- **라이브 실측(결판의 토대·2026-06-22)**: ① t_prd_product_prices 108~112 = **0행**(전체 0행) ② 공식 바인딩 108~112 = **0건** ③ PRF_CAL_* 라이브 **부존재**(캘린더/달력 공식 0). → **이중 정의 충돌은 현 라이브엔 미존재**(둘 다 미배선)·충돌은 미래 적재 시점 잠재 위험 → 설계가 분기 구조 선결판.
- **근거**: ① 무손실(inline verbatim 보존·②는 비정수 산식으로 덮어써 권위 위반) ② 업계 표준(RedPrinting tmpl_price=디자인 제공 완제 개당 정찰가·benchmark DC-1) ③ 비결정 회피(상품별 PRF_DCAL_* 바인딩으로 1 prd 1 공식) ④ add-on 보존(formula 구조라 우드거치대 가산 살아있음).
- ★**라우팅 키 [codex D2 적발·교정]**: editor_yn 단독 의존 금지 — **엽서캘린더 PRD_000110=editor_yn=N**이라 editor_yn=Y 라우팅 시 엽서 누락(내부 모순). 라우팅 신호 = 가격포함 시트 등재 + 상품별 PRF_DCAL_* 바인딩(엽서 포함 5상품)·editor_yn 보조.
- ★ **적재 자체는 인간 컨펌(Q-DCAL-AUTHORITY)** — 설계는 무손실 명세만, 실 적재는 인간 승인 후 dbmap 위임.
- `확신도: 높음(라이브 둘 다 미적재 실측 + 권위/업계 정합 + 비결정 회피)`

## D-DCAL-3. ★G-PRODPRICE 가드 정합 = 본체 정찰가 formula 바인딩·product_prices 금지 (돈크리티컬)
- **결정**: 정찰가 채택해도 본체를 product_prices에 INSERT하지 않는다. **.01 단가형(min_qty=1·1부 정찰가 ×qty) comp(COMP_DCAL_FIXED)로 formula 바인딩 + add-on(우드거치대) 별 comp 가산**.
- **근거**: product_prices 1건이라도 있으면 엔진 :315-330 PRODUCT_PRICE 선점 → FORMULA 통째 우회 silent(GP-2·캘린더 G-CAL-2·악세사리·포토북 확립 가드). 엽서캘린더 우드거치대(4000) 가산이 필요하므로 formula 합산 구조 필수(정찰가형이라도 add-on 있으면 formula 유지·benchmark G-DC-2). 골든 GC-DCAL-8(8000 정답 vs product_prices 박을 시 4000 우회 오답)으로 입증.
- `확신도: 높음(product_prices 0행 실측·5종 선례 계승)`

## D-DCAL-4. search-before-mint = 신규 가격축 0·신규 mint(정찰가 채택 시) PRF_DCAL_* 5 + COMP_DCAL_FIXED 1뿐
- **결정**: 본체 시트로 인한 신규 mint 0(inline BLOCKED). 정찰가 채택 ① 경로에서만 PRF_DCAL_* 5 + COMP_DCAL_FIXED 1(.01 단가형 min_qty=1 고정가) mint·인간 컨펌 후.
- **재사용/의존 입증(validator 라이브 재실측 2026-06-22)**: 우드거치대=**캘린더 종단이 신규 mint로 명시한 COMP_CALOPT_STAND에 선행 의존**(라이브 component·단가행 0행·4000 단가 일치·"재사용" 아님·캘린더 종단 소관·G-DCAL-WOODSTAND 이중 mint 회피)·인쇄/용지/제본 comp 전부 실재(의도 비목·정찰가 채택 시 미배선)·캘린더봉투=독립 PRD_000005(012-0008 실측·봉투제작 트랙). 디자인캘린더 시트 본체 신규 mint **0**·신규 테이블/가격축 **0**(11연속 search-before-mint 통과·우드거치대 mint 카운트는 캘린더 종단 소관).
- `확신도: 높음(라이브 comp/PRD 상태 재실측·COMP_CALOPT_STAND 0행 확인)`

## D-DCAL-5. add-on 귀속 = 우드거치대(formula 합산·캘린더 종단 mint 선행 의존)·봉투(봉투제작 트랙 외부)
- **결정**: 우드거치대 4000 = COMP_CALOPT_STAND opt_cd(캘린더 종단 신규 mint 선행 의존·현 라이브 0행·엽서캘린더 formula 합산). 캘린더봉투 2500/2400 = 독립 PRD + 본체 addon 이중역할 → 봉투제작 트랙 위임(본체 가격공식 외부).
- **근거**: 우드거치대 단가(4000)=캘린더 §4 동일 add-on. 봉투를 본체에 합산 시 오과금(G-DCAL-ENVELOPE)·사이즈별 변형가(2500 vs 2400) use_dims 충전 필수(평탄화 가드 G-DC-1). 일반 캘린더 Q-CAL-ENVELOPE 연계(동일 봉투 PRD 두 시트 참조).
- `확신도: 높음`

## D-DCAL-6. ★본체 정찰가 qty 의미 = 1부 정찰가 ×qty (돈크리티컬·저청구 가드·codex D1 적발)
- **결정**: 본체 정찰가는 **qty-불변이 아니라 `.01 단가형 = 1부 정찰가 × qty`**. 견적가 = 정찰가 × qty(탁상 10부 = 104,000·10,400 고정은 93,600 저청구).
- **근거(엔진계약 정합·메인 직접 확인)**: `price-flow-map.md` EV ④ "단가형×qty"·`engine-contract.md` E0-1(단가형 unit×qty·qty=0이면 0원)·`widget-price-contract.md` W-3(`min_qty`는 티어 비교 키 `_tier_order_val(min_qty)=qty`이지 qty-불변 신호 아님). 도메인상 캘린더 정찰가=1부 단가 → ×qty가 정답. 초안의 "qty 무관·min_qty=1이라 qty 불변" 표현이 엔진계약 위반(저청구)이었음.
- **신규 가드 G-DCAL-QTY(돈크리티컬)**: 본체 정찰가 qty-불변 모델링 금지. 골든 GC-DCAL-9(qty=10·본체 40,000 정답 vs 4,000 고정 오답)으로 입증.
- ★GP-1/악세사리 "동형" 인용도 "qty 무관"이 아니라 **per-unit ×qty 동일 계약**(엔진 동일). 수량구간할인(DSC) 별 레이어 여부=Q-DCAL-DSC.
- `확신도: 높음(엔진계약 3원 직접 확인·codex D1 정당)`

## D-DCAL-7. (기록만·현 무해) COMP_DCAL_FIXED 확장 시 comp scoping 점검 (codex D3)
- **현 무해**: COMP_DCAL_FIXED siz_cd-only 단일 comp는 미래 디자인캘린더 상품 추가 시 siz_cd 충돌 가능. 현재는 상품별 PRF_DCAL_* 5개 전용 공식으로 부분 완화(공식이 상품을 가름).
- **기록**: 디자인캘린더 상품 확장 시 COMP_DCAL_FIXED를 상품/공식 scoping(전용 comp 또는 차원 추가)으로 분리 점검. **현 설계 변경 불요**.
- `확신도: 중(미래 시나리오·현 영향 0)`

## 디자인캘린더 컨펌큐 (인간 결판)

| 큐 ID | 사안 | 권고 가설 | 근거 |
|-------|------|-----------|------|
| **Q-DCAL-AUTHORITY**(최우선) | inline 정찰가 채택(① PRF_DCAL_* 적재) vs 견적 비대상 BLOCKED 유지 | **정찰가 채택**(고정가형 .01 단가형 min_qty=1) | 업계(RedPrinting tmpl_price)·권위 엑셀 정찰가 명시·무손실 |
| **Q-DCAL-ROUTE**(codex D2) | 정찰가 경로(DCAL) vs 산식(CAL) 라우팅 — ★엽서(110) editor_yn=N 라우팅 포함 | 가격포함 시트 등재+상품별 PRF_DCAL_* 바인딩(editor_yn 단독 금지) | 엽서 editor_yn=N으로 editor_yn=Y 라우팅 시 누락(내부 모순)·option_groups 0행 의존 |
| **Q-DCAL-DSC**(codex D1·돈크리티컬) | 본체 정찰가 ×qty base에 수량구간할인(DSC) 별 레이어 존재 여부 | 미확인 시 단순 ×qty(할인 0) | 견적가=정찰가×qty(±DSC)·DSC 있으면 별 레이어 |
| **Q-DCAL-FIN** | 우드거치대 4000 개당 가산(×qty) vs 주문당 정액 | **개당 가산(×qty)** | 물리 부속물 단위(캘린더 Q-CAL-FIN·굿즈 Q-GP-FIN1 동일 미해소) |
| **Q-DCAL-ENVELOPE** | 캘린더봉투 PRD_000005 본체 addon 묶음 vs 독립판매만 | 봉투제작 트랙 위임 | 독립 PRD 실측·일반 캘린더 Q-CAL-ENVELOPE 연계 |

## 라우팅 표기
- 확정 결함/개선 심의 → **dbm-price-arbiter**(G-DCAL-DUAL 정찰가 채택 비준·주문방법 분기 메커니즘).
- 신규 그릇(COMP_DCAL_FIXED·PRF_DCAL_*) → **dbm-ddl-proposer**(채번 의미코드·인간 승인 후 dbmap 적재 트랙).
- 실 적재(INSERT/COMMIT) → 인간 승인 후 **dbm-load-execution**·**dbm-axis-staged-load**. inline verbatim·날조 0·라이브 읽기전용.

★ **★디자인캘린더 = 11번째·최종 종단** — 11연속 search-before-mint 통과(신규 가격축 0)·G-DCAL-DUAL 정찰가 채택+상품별 PRF_DCAL_* 바인딩으로 이중 정의 충돌 선결판(엽서 editor_yn=N 라우팅 명문·codex D2)·G-PRODPRICE 가드 정합·G-DCAL-QTY(본체 정찰가 1부 단가 ×qty·qty-불변 저청구 금지·codex D1)·inline BLOCKED 정직(추측 단가 0). 고정가형 완제 SKU 클래스(.01 단가형 1부 정찰가 ×qty·라이브 .03 부재·굿즈 GP-1·악세사리 inline per-unit 동형) + 외부 add-on 가산(우드거치대=캘린더 종단 mint 선행 의존).
