# 아크릴 시트 — 적재 무결성 독립 검증 게이트 verdict (I1~I7)

**검증 구도:** hpti-integrity-gate(독립 게이트·Claude) — inspector(`02_load`)·codex(`03_codex`) 주장 **비신뢰**, 라이브 읽기전용 SELECT로 직접 재실측 + 엔진 `match_component`(pricing.py) 충실 재현으로 최종 판정.
**권위 = 인쇄상품가격표 260527 "아크릴" 시트(433 정답셀·절대). 라이브 = 감사대상.**
**라이브 실측 일시:** 2026-06-27 · 읽기전용 SELECT만 · DB 미적재 · 날조 0(전 판정 근거 SQL/CSV).

---

## 0. 종합 GO/NO-GO

| 게이트 | 판정 | 핵심 근거 |
|---|---|---|
| I1 격자 완전성 | **GO** | 권위 격자 433셀 = area 394 + qty 9 + addon 26 + fixed 4. 엑셀 verbatim 재확인 |
| I2 미적재 실재(정확좌표) | **NO-GO(결함 실재)** | 면적 미적재 **156셀**(B01 83·B02 29·B03 29·B05 15) 라이브 SELECT 부재 확정 |
| I3 차원누락 실재 | **NO-GO(결함 실재)** | 카라비너 PRD_000166 공식/옵션 0 + 미러·코롯토·자유형 등 **12/13 상품 공식 0바인딩** |
| I4 정합불일치 실재 | **GO(불일치 0)** | 적재된 238 면적셀 + 비대칭쌍 적재분 전부 권위 verbatim(오적재 0) |
| I5 돈영향 정확 | **GO(분류 정확)** | match_component 재현 = 미적재셀 `no_tier_row`→`_FATAL`→strict 차단(견적불가)·lenient 저청구. 할인 /100 정상 |
| I6 codex 수렴 | **GO** | codex 신규발견 3건(NEW-1/2/3) 전부 라이브 실측 확정. 6 돈크리티컬 CONFIRM·과적발 0 |
| I7 생성검증 독립성 | **GO** | 게이트가 라이브 238행 전수 덤프·diff·엔진 재현 독립 실행(inspector 복붙 아님) |

### 종합 판정: **NO-GO (시트 적재 무결성 결함 — 설계 신뢰 기반 미충족)**

아크릴 시트는 **설계(§18)·검증(§13/15)의 신뢰 기반이 될 수 없다.** I2(156셀 미적재)·I3(12/13 상품 견적불가)가 HARD FAIL. 단, **결함 좌표·교정 정답값이 정확히 확정**됐으므로(아래) 교정 적재 후 재게이트하면 GO 가능. 정직 판정: 적재된 251셀은 전부 정확(I4 GO)이라 "오적재로 되돌릴 것 없음" — **순수 미적재·미연결 결함**.

---

## I 게이트 상세 판정

### I1 격자 완전성 — GO
권위 433셀을 블록별 재확인: B01 196(14×14) · B02 81(9×9) · B03 81(9×9, =B01×2 파생) · B05 36(6×6) · B04a 6 · B07 3 · B04b 26 · B06 4 = **433**. extractor 격자가 엑셀 차원을 빠짐없이 펼침. 면적 area 합계 394 = 196+81+81+36. **GO.**

### I2 미적재 실재 — NO-GO (정확 좌표 확정)
**라이브 면적셀 전수 덤프(238행) ↔ 권위 격자 (w,h) 키 diff:**

| 블록 | comp_cd | mat_cd | 권위 | 라이브 | **미적재** | 잉여 | 불일치 |
|---|---|---|---|---|---|---|---|
| B01 투명3T | COMP_ACRYL_CLEAR3T | MAT_000043 | 196 | 113 | **83** | 0 | 0 |
| B02 투명1.5T | COMP_ACRYL_CLEAR3T | MAT_000042 | 81 | 52 | **29** | 0 | 0 |
| B03 미러3T | COMP_ACRYL_MIRROR3T | (없음) | 81 | 52 | **29** | 0 | 0 |
| B05 코롯토 | COMP_ACRYL_COROTTO | (없음) | 36 | 21 | **15** | 0 | 0 |
| **면적 합계** | | | **394** | **238** | **156** | **0** | **0** |

- **★좌표 신뢰도 = 高.** 게이트가 라이브 (siz_width,siz_height) 전수 덤프 후 권위와 정확 키 diff. 미적재 156셀 좌표 = `acrylic-missing-cells-confirmed.csv`(comp_cd,mat_cd,siz_width,siz_height,authority_price).
- **★축 방향 검증(비대칭쌍):** 권위 (50,30)=3800이 라이브 `siz_width=50,siz_height=30`에 3800으로 정확 적재 = **col=가로(width)/row=세로(height) 매핑 정확**. 오매핑 없음 → 전 진단 유효.
- **★inspector "전부 하삼각(w>h)" 기술 오류 확정(codex NEW-1 채택):** 권위 w>h 셀 = B01 91·B02 36·B03 36인데 미적재는 83/29/29 → "전부 하삼각" 산술 불가. **실측: 라이브는 상삼각/하삼각이 뒤섞여 sparse 적재**(라이브에 w60h20·w50h30 등 w>h 다수 존재, w20h60·w30h20 등 w≤h 누락 다수). **누락 패턴은 단순 대칭규칙 아님 → "대칭 전개" 교정은 틀림.** 좌표 verbatim INSERT만 정확.
- 숫자(83/29/29/15)는 inspector·codex·게이트 3자 일치(우연히 미적재 개수는 맞음). **틀린 건 원인 기술이지 셀 수가 아님.**

### I3 차원누락 실재 — NO-GO (★범위가 inspector보다 넓음)
**게이트 신규 발견 — inspector·codex 둘 다 D-03b(미러만) 보고했으나 실측은 광범위:**

| 상품 | prd_cd | 공식 바인딩 | 본체 견적 |
|---|---|---|---|
| 아크릴키링 | PRD_000146 | **1** (PRF→CLEAR3T) | 가능(유일) |
| 아크릴자유형스탠드 | PRD_000160 | **0** | 견적불가 |
| 판아크릴 | PRD_000161 | **0** | 견적불가 |
| 아크릴포카스탠드 | PRD_000162 | **0** | 견적불가 |
| 아크릴미니파츠 | PRD_000163 | **0** | 견적불가 |
| 아크릴코롯토 | PRD_000164 | **0** | 견적불가 |
| 포카코롯토 | PRD_000165 | **0** | 견적불가 |
| **아크릴카라비너** | PRD_000166 | **0**(옵션그룹0·comp부재) | 견적불가(완전) |
| 아크릴입체코롯토 | PRD_000168 | **0** | 견적불가 |
| 아크릴입체블럭 | PRD_000169 | **0** | 견적불가 |
| 아크릴쉐이커 | PRD_000170 | **0** | 견적불가 |
| 지비츠 | PRD_000171 | **0** | 견적불가 |
| LED투명키캡키링 | PRD_000203 | **0** | 견적불가 |

- **13개 아크릴 상품 중 12개 공식 0바인딩 = 본체 견적불가.** 단가표(comp)는 적재됐어도 상품→공식→comp 사슬이 끊김.
- **COMP_ACRYL_MIRROR3T:** formula_components 0(고아 comp) — D-03b CONFIRM.
- **COMP_ACRYL_COROTTO:** formula(PRF_COROTTO_ACRYL) 바인딩 1 있으나 그 공식이 **어느 상품에도 안 붙음**(NO_PRD) = 고아 formula. 코롯토 단가표 82셀 다 있어도 무의미.
- **PRD_000166 카라비너:** 옵션그룹 0·공식 0·본체단가 comp(CARA/CARABIN) 0 — **완전 미적재**(D-05 최우선 CONFIRM). B07 할인(DSC_ACRCARA_QTY)은 PRD_000166에 정상 링크됐으나 곱할 본체 0 → 무의미.

### I4 정합불일치 실재 — GO (불일치 0·의미축 가드)
- **적재 238 면적셀 전부 권위 verbatim**(diff mismatch=0·surplus=0). 적재된 값은 정확.
- **비대칭쌍 3건 오적재 검사:** 라이브 적재분(B01 w50h30=3800·B02 w50h30=3040·B03 w50h30=7600) 전부 권위 일치 [OK]. 반대쪽(w30h50) 전부 MISSING(오적재 아님·미적재). **"정합불일치 0" 재확정.**
- **★교정 가드:** 누락 w30h50을 "대칭 추정"으로 메우면 권위 3700 대신 3800(w50h30값) 들어가 **오가격**(B01 100원·B02 80원·B03 200원 과청구). 교정은 **권위 CSV verbatim 필수**(대칭 전개 금지).
- false-positive 가드 전부 정상 확인: 도수 print_opt_cd/clr_cd 0(통용 단일가)·siz_cd 0/238(면적 순정·siz_cd 코드버그 아님)·카라비너 색상9종 0원(의미축)·원형/사각 동일가.

### I5 돈영향 정확 — GO (엔진 재현)
match_component(pricing.py L133) 충실 재현으로 미적재셀 결과 실증:
- **미적재 w30h50 입력 → `no_tier_row`** 반환(L182). `_evaluate_formula` L605-608이 `error=ERR_NO_TIER_ROW`로 승격 → ∈ `_FATAL_ERRORS`(L66) → `_is_fatal`(L72) → strict 차단. **돈영향 = 견적불가(strict)/저청구(lenient·0원 합산).**
- **no-swap 재확인:** w30h50이 w50h30 행으로 라우팅 안 됨(siz_width/siz_height 독립 tier·L159-177). 손님이 가로<세로로 입력한 셀의 절반이 견적불가/저청구. codex REFUTE(우회 없음) CONFIRM.
- 적재셀 정확: w50h30=3800·w20h20=2500 verbatim 매칭.
- **할인 /100 정상:** dsc_rate 퍼센트스케일(10.00=10%)·`apply_discount` L241 `rate/100`. DSC_ACR_QTY 6구간·DSC_ACRCARA_QTY 3구간 분리. **B04a/B07 GO 재확정.**
- 후가공 저청구(D-06): 키링 OPV-000026(1100)·OPV-000027(1200) 2개만 적재, 고리없음(0)·은색구슬줄(300) 누락·머리끈 단가0 → 옵션 선택 시 미가산 저청구 CONFIRM.

### I6 codex 수렴 — GO
- codex 신규발견 3건 전부 라이브 실측 확정: **NEW-1**(전부하삼각 거짓·sparse 혼재 — 게이트 실측 일치) · **NEW-2**(비대칭쌍 3건 — 게이트 검증 일치·라이브는 일치쪽만 적재) · **NEW-3**(B07 PRD_000166 링크 정상·B04a 미오링크 — 게이트 SELECT 확인).
- 6 돈크리티컬 전부 CONFIRM, 과적발 0, false-positive 가드 3건 REFUTE=정상 합의.
- **게이트 추가 발견(codex·inspector 둘 다 놓침):** I3 견적불가 범위 12/13 상품(미러·카라비너 외 코롯토·자유형스탠드 등 광범위). codex 합의분 채택 + 게이트 독립 보강.

### I7 생성검증 독립성 — GO
게이트가 라이브 238 면적행 전수 덤프 → Python diff → match_component 재현 → 비대칭쌍 SELECT를 **독립 실행**. inspector 결함보드(182)를 그대로 채택하지 않고 재실측해 156(면적)으로 정정, 좌표 집합 신규 산출.

---

## ★ inspector 1차 "141 fill SQL" 정확성 판정

**판정: 부정확(틀린 좌표·틀린 개수) — 사용 금지.**
- 게이트 확정 면적 미적재 = **156셀**(141 아님). 141이라는 수는 권위/라이브 어느 집계와도 불일치(B01 83+B02 29+B03 29+B05 15=156).
- 더 결정적으로, inspector가 "전부 하삼각 대칭쌍 누락"으로 가정해 **대칭 전개(w↔h swap)로 fill**하려 했다면 좌표가 틀림 — 실측상 누락은 sparse 혼재(상/하삼각 섞임)이고, 대칭 전개는 비대칭쌍 3좌표에 오가격을 주입(I4 가드 위반).
- **정답 = `acrylic-missing-cells-confirmed.csv` 156행 verbatim INSERT** (대칭 추정·swap 금지).

---

## 교정 명세 (대상 t_*·정답값 verbatim·dbmap 라우팅·인간 승인 큐)

| # | 결함 | 대상 | 정답 | dbmap 트랙 | 우선순위 |
|---|---|---|---|---|---|
| R1 | 카라비너 완전 미적재(PRD_000166) | t_prd_product_option_groups·t_prc_price_formulas·t_prc_formula_components·t_prc_component_prices(본체 신규 comp) | B06 형태4 고정단가 5800/5800/6300/6900 + 공식 바인딩 | **dbm-price-import-prep**(그릇 설계·신규 mint) → dbm-load-execution | **1(견적불가)** |
| R2 | 12/13 상품 공식 0바인딩(미러·코롯토·자유형 등) | t_prd_product_price_formulas + t_prc_formula_components | 각 상품 → 적합 공식 바인딩(미러 PRF·코롯토 PRF_COROTTO_ACRYL 상품연결) | **dbm-correctness-audit**(공식 사슬 연결) | **1(견적불가)** |
| R3 | 면적 미적재 156셀 | t_prc_component_prices | `acrylic-missing-cells-confirmed.csv` 156행 verbatim(B01 83·B02 29·B03 29·B05 15) | **dbm-load-execution**(verbatim INSERT·swap 금지) | 2(견적불가/저청구) |
| R4 | 후가공 22/26 옵션 미적재 | t_prc_component_prices·t_prd_product_option_* | 고리없음0·은색구슬줄300·머리끈500·뱃지/마그넷/명찰/스마트톡 등 verbatim | **dbm-cpq-option-mapping** + dbm-load-execution | 3(저청구) |

**인간 승인 큐:** R1·R2(견적불가 최우선) → R3(면적 데이터) → R4(후가공). 전부 실 COMMIT/DDL은 인간 승인 후 dbmap 위임. 게이트는 읽기전용·DB 미적재.

**돈크리티컬 우선순위(Claude·codex 합의):** B06 카라비너 완전미적재 ≻ 12상품 공식 0바인딩(견적불가) ≻ 156 면적 미적재(차단/저청구) ≻ 후가공 22옵션(저청구).

---

## 산출물
- `acrylic-integrity-verdict.md` (본 문서)
- `acrylic-missing-cells-confirmed.csv` — 게이트 독립 재실측 미적재 156좌표(R3 교정 SQL 정답 입력)
