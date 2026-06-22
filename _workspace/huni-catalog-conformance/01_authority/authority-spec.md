# authority-spec.md — 12축 + 가격엔진 정답 기준 (디지털인쇄 스코프)

> **Phase 1 — hcc-authority-curator** · 2026-06-22 · `huni-catalog-conformance` §21
> 검사·게이트가 "무엇을 무엇과 대조할지"의 **자(尺)**. 결함 판정은 하지 않는다(인스펙터·게이트 몫).
> **권위[HARD] = 두 엑셀**(상품마스터 260610 + 인쇄상품 가격표 260527). 라이브·기존 산출물은 입력/렌즈.
> 도메인 의미는 `domain-lens.md` 선행. 재사용 출처는 `reuse-map.md`.

## 0. 모집단 (디지털인쇄, 라이브 실측 확정)

- **상품수: 36**(엑셀 권위 distinct prd_nm 36 = 라이브 `t_prd_products` 36, 1:1, del_yn=N).
- **prd_cd 범위: PRD_000016 ~ PRD_000051**(연속). 상품군(구분) 7종:
  엽서(8)·포토카드(3)·접지카드(4)·명함(10)·상품권(2)·배경지(4)·인쇄홍보물(5).
- **JOIN KEY = prd_nm only**(MES_ITEM_CD 전부 NULL, [[railway-db-access]]). 엑셀↔라이브 매칭 검증 완료(미매칭 0).
- 추출 캐시: `24_master-extract-260610/digital-print-l1.csv`(헤더+212행=36상품, anchor-fill 병합셀).

## 1. 정합 판정 어휘 (인스펙터 공통)

| 판정 | 의미 |
|------|------|
| **MATCH** | 권위 엑셀 값 ↔ 라이브 t_* 값 일치 |
| **MISSING** | 권위에 있으나(needed=Y) 라이브 미적재/미바인딩 |
| **EXTRA** | 라이브에 있으나 권위에 근거 없음(오염/잔여) |
| **MISMATCH** | 양쪽 존재하나 값 불일치(오적재) |
| **N/A** | needed=N(엑셀 해당 옵션 미사용) — 인스펙터가 빠르게 닫음 |
| **CONFIRM** | 권위 엑셀끼리(상품마스터↔가격표) 충돌·모호 → 인간 확인 큐(§5) |

> [HARD] 권위 vs 라이브 충돌 시 **권위(엑셀)가 정답**. 라이브 미반영/오적재는 결함으로 기록(권위 변경 금지).

## 2. 축별 정답 기준 (12축 + 가격엔진)

| # | 축 | 권위 컬럼 (엑셀) | 대상 t_* (라이브) | 정합 규칙 요지 | owner |
|---|----|------------------|-------------------|----------------|-------|
| 1 | **사이즈코드** | 상품마스터 `사이즈(필수)` | `t_prd_product_sizes`(siz_cd)→`t_siz_sizes.cut_*` | 엑셀 완성품 치수 ↔ cut_* 매칭. siz_nm에 색/형상 인코딩=EXTRA. 항상 needed=Y | basedata |
| 2 | **도수** | 상품마스터 `인쇄(옵션)` | `t_prd_product_print_options`(front/back_colrcnt_cd→CLR) | 도수칸에 별색=MISMATCH(별색은 축3). 미사용 상품 needed=N | basedata |
| 3 | **인쇄옵션** | `별색인쇄(옵션)_*`·`코팅(옵션)`·`커팅(옵션)`·`접지(옵션)` | `t_prd_product_processes`(PROC_000007 family clr_cd=NULL·코팅·커팅·접지) | 별색=공정(clr_cd=NULL). 코팅을 자재로=MISMATCH. 미사용 needed=N | basedata |
| 4 | **판형** | 상품마스터 `파일사양_출력용지규격` | `t_prd_product_plate_sizes`(siz_cd,output_paper_typ_cd)→`t_siz_sizes.work_*` | [HARD] 가격 siz_cd=판형. 국4절=SIZ_000499. 비판형(봉투/썬캡) needed=N | basedata |
| 5 | **자재** | 상품마스터 `종이(필수)` | `t_prd_product_materials`(mat_cd,usage_cd) | 종이↔mat_cd 매칭. 코팅/박을 자재로=EXTRA. 항상 needed=Y | basedata |
| 6 | **공정** | `후가공(옵션)_*`·`박/형압(옵션)_*` | `t_prd_product_processes`(+param) | 후가공/박/형압 공정행. param(구수·줄수) 행분리=EXTRA. 미사용 needed=N | basedata |
| 7 | **묶음수** | 상품마스터 `제작수량(필수)_건수(옵션)` | `t_prd_product_bundle_qtys`(bdl_qty,QTY_UNIT.03) | 건수 표기 시만 needed=Y. 페이지와 혼동=MISMATCH | basedata |
| 8 | **추가상품** | 상품마스터 `추가상품(옵션)_추가상품`·`_추가가격` | `t_prd_product_addons`(tmpl_cd) | 추가상품 표기 시 needed=Y. ref_dim_cd 아님(템플릿 경유) | cpq-link |
| 9 | **페이지룰** | 상품마스터 `판수` | `t_prd_product_page_rules`(page_min/max/incr) | 낱장 상품 page_rule=EXTRA(잡음). 판수 표기 상품만 needed=Y | basedata |
| 10 | **옵션그룹** | 상품마스터 옵션성 컬럼(주문방법·후가공·별색·접지 택일) | `t_prd_product_option_groups`(sel_typ_cd)→options→option_items(ref_dim_cd) | [HARD] option_item=차원행 포인터(L2≠L1). 항상 needed=Y(최소 주문방법) | cpq-link |
| 11 | **제약규칙** | 별표(*) 주석·박 크기·가변 제한·`파일사양_블리드` | `t_prd_product_constraints`(logic jsonb)→`constraint_json` 캐시 | 불가조합 enumerate 금지. 제약 표기 상품만 needed=Y | cpq-link |
| 12 | **추가상품 템플릿** | 상품마스터 `추가상품(옵션)`→SKU | `t_prd_templates`(base_prd_cd)+`template_selections` | 추가상품(축8) 동반. 추가상품 있는 상품만 needed=Y | cpq-link |
| ★ | **가격엔진**(횡단) | 상품마스터 `가격공식` + 인쇄상품 가격표(260527) | `t_prd_product_price_formulas`→`t_prc_price_formulas`→`formula_components`→`price_components`→`component_prices`(siz=판형) | [HARD] 디지털 전 상품 가격 산출 대상=**항상 needed=Y**. frm_cd 미바인딩=MISSING(§4 라이브 단서) | price-engine |

## 3. 축 ↔ 인스펙터 배정

| owner | 축 | 체크리스트 셀 수 |
|-------|----|------------------|
| **basedata** | 사이즈코드·도수·인쇄옵션·판형·자재·공정·묶음수·페이지룰 (8축) | 288 |
| **cpq-link** | 옵션그룹·제약규칙·추가상품·추가상품 템플릿 (4축) + 옵션→차원 연결·템플릿→추가상품 연결 | 144 |
| **price-engine** | 가격엔진 횡단(공식·구성요소·단가행·use_dims·할인) + 종단 연결 | 36 |
| | **합계** | **468** (= 36상품 × 13축, 빈 셀 0) |

## 4. 라이브 가격공식 바인딩 단서 (인스펙터 우선 점검 — 결함 아닌 needed=Y의 미충족 후보)

> 큐레이터는 결함을 판정하지 않으나, 가격엔진 축 needed=Y의 라이브 미충족을 인스펙터가 놓치지 않도록
> 1회 실측한 frm_cd 바인딩 현황을 단서로 남긴다(판정은 price-engine 인스펙터·게이트 몫).

- **frm_cd 미바인딩(공란) 10건:** 투명엽서(19)·지그재그엽서(30)·펄명함(34)·모양명함(35)·미니모양명함(36)·
  오리지널박명함(37)·형압명함(38)·투명명함(39)·화이트인쇄명함(40)·와이드 접지리플렛(49).
  → 가격엔진 축 needed=Y이므로 인스펙터가 MISSING 후보로 검사(권위 엑셀에 가격공식 의도 존재).
- **바인딩된 공식 분포:** PRF_DGP_A(엽서/슬로건/상품권 다수)·DGP_B(모양엽서·라벨택)·DGP_C(배경지·헤더택)·
  DGP_D(소량전단지)·DGP_E(접지카드)·DGP_F(썬캡)·NAMECARD_FIXED·PHOTOCARD_FIXED·FOLD_SUM·ENV_MAKING.

## 5. CONFIRM 큐 (권위 엑셀끼리 충돌·모호 — 인간 확인, 결함 아님)

> 기존 가격엔진 하네스(`02_authority/authority-gaps.md`)가 식별한 디지털인쇄 관련 권위 모호를 재사용·계승.

| CONFIRM ID | 축 | 항목 | 상태 | 출처 |
|-----------|----|------|------|------|
| **Q-ROUND** | 가격엔진 | 합산형 최종 final_price 반올림 규칙(round/floor) 미명시(용지비 소수) | 가격표 어디에도 명시 없음 | authority-gaps Q-ROUND |
| **Q-COAT-TIER** | 가격엔진 | 코팅/인쇄비 수량행 비연속 시 구간 룩업 경계(이상/이하) 미명시 | `디지털인쇄비`·`코팅` 수량행 | authority-gaps Q-COAT-TIER |
| **Q-DGP-SPOT** | 가격엔진/인쇄옵션 | 별색엽서 인쇄비 = [단가]+[출력매수행]×[칼라열], 일반엽서와 공식 상이(3절 별색 없음) | 공식집:행7·`디지털인쇄비` F~O | authority-gaps 구조적모호 |
| **Q-DGP-PLATE** | 판형/가격엔진 | 3절 vs 국4절 출력판형 분기 — 어느 판형 적용은 `판걸이수` 시트 열로 결정(상품마스터 직접 명시 아님) | 판걸이수:G·H · `디지털인쇄비`:행1 vs 행61 | authority-gaps 구조적모호 |

> 위 CONFIRM은 **결함이 아니다.** 인스펙터가 이 항목을 만나면 임의 선택하지 말고 CONFIRM으로 보류하고
> 인간 확인을 요청한다. 게이트는 CONFIRM 미해소를 NO-GO 사유로 삼지 않되 명시적으로 추적한다.
