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
