# 디지털인쇄 상품군 — 컬럼 readiness 매트릭스 (round-19 종단)

> 대상: 상품마스터 260702 "디지털인쇄" 시트 **36상품**(권위 L1 = `24_master-extract-260610/digital-print-l1.csv`).
> 라이브 실측: `snap_20260702_1119`(latest) + 라이브 SELECT/simulate(읽기전용).
> 권위 = 엑셀 · 라이브 = 감사 대상. 의미컬럼 = `15_domain-spec/digital-print/column-dictionary-corrected-260703.md`.
> 판정: ✅적재완료 · 🟡부분/조건부 · ❌미적재.

## 0. 상품 목록 (36개, prd_nm ↔ prd_cd · JOIN KEY=prd_nm)

전 36상품 라이브 매칭 100%. prd_cd PRD_000016~PRD_000051 연속.
엽서9 · 카드/접지6 · 명함10 · 쿠폰2 · 인쇄배경지2 · 택2 · 전단/리플렛3 · 봉투1 · 썬캡1.

출시(use_yn=Y) = **30상품** · 미출시(use_yn=N) = **6상품**
(핑크별색엽서·금은별색엽서·모양엽서·미니접지카드·형압명함·썬캡).

## 1. 대표(superset) = 프리미엄엽서 (PRD_000016) 컬럼 readiness

디지털인쇄 시트에서 옵션·구성요소·제약이 가장 완전(사이즈7·자재21·공정7·옵션그룹7·제약2). §6-1 시트 실측 대표.

| 의미컬럼(엑셀) | 목표 t_* | 라이브 실측 | 판정 |
|---|---|---|---|
| 사이즈(필수) | `t_prd_product_sizes` | 7행(73×98 등) | ✅ |
| 출력용지규격=판형 | `t_prd_product_plate_sizes`(종이류) | 2행(316×467 등) + `fn_best_plate` 자동선택 | ✅ |
| 종이(필수) | `t_prd_product_materials` | 21행 | ✅ |
| 인쇄(옵션)=CMYK 도수 | `t_prd_product_print_options`(도수) | 2행(단/양면) | ✅ |
| 별색인쇄(화이트/클리어…) | `t_proc_processes`+`t_prd_product_processes`(**공정**) | 별색인쇄비 공정 배선(코팅과 별도) | ✅ |
| 코팅(유광/무광) | 공정 PROC_000014/15 + `COMP_COAT_GLOSSY/MATTE` | 단가행 **138행씩** · coat_side_cnt 차원 | ✅ |
| 후가공(모서리/오시/미싱/가변) | `t_prc_price_components`(귀돌이/가변텍스트/가변이미지) | 배선·기여>0 | ✅ |
| 박/형압 | 후가공_박 components | 오리지널박명함 등에서 청구 확인 | ✅ |
| 커팅/접지 | 공정 + `t_prd_product_option_groups` | 옵션그룹7 | ✅ |
| 추가상품(엽서봉투) | `t_prd_product_addons`(tmpl_cd) | 5행 | ✅ |
| 제작수량 규칙 | `t_prd_product_sizes`(min/max/incr) | 충전 | ✅ |
| 가격공식 | `t_prd_product_price_formulas` | PRF_DGP_A(원자합산형) | ✅ |
| 단가행 | `t_prc_component_prices` | 전 비목 충전 | ✅ |
| 제약조건 | `t_prd_product_constraints` | 2행(코팅×두께 계열) | ✅ |

대표 골든 실측(qty=100·전 옵션): final_price=**2,048,024** · wired 10 / contributed 7 · CORE silent-0 = **0** → GO.

## 2. 상품군 전체 컬럼 축 readiness (36상품 집계)

| 축 | 목표 t_* | 적재 상태 | 판정 |
|---|---|---|---|
| 사이즈 | t_prd_product_sizes | 전 36상품 ≥1행 | ✅ |
| 판형(종이류) | t_prd_product_plate_sizes | 전 36상품 ≥1행(봉투제작 4행) | ✅ |
| 자재 | t_prd_product_materials | 34/36 보유(형압명함·모양명함류 완제품가형=자재 미보유 by-design) | ✅ |
| 인쇄 도수 | t_prd_product_print_options | 봉투제작 제외 전 상품(봉투=인쇄 없음) | ✅ |
| 별색/코팅/후가공 공정 | t_proc + t_prd_product_processes | 배선 정합 | ✅ |
| 가격공식 바인딩 | t_prd_product_price_formulas | **35/36**(형압명함 038 미바인딩·미출시) | 🟡 |
| 단가행 | t_prc_component_prices | 바인딩 상품 전부 충전 | ✅ |
| CPQ 옵션(②차원환원) | option_groups/options/**option_items.ref_dim_cd** | 전 352 option_items ref_dim_cd 해소·NULL 0 | ✅ |
| 제약조건 | t_prd_product_constraints | 4상품(016·047·048·049 코팅/접지 제약) | ✅ |

**②차원환원 무결성**: option_items.ref_dim_cd 분포 = 자재(.03)194 · 공정(.04)125 · siz(.01)4 · .06=29.
전부 실차원 해소(MES_ITEM_CD 아님) → 설계 제1원칙 [[dbmap-goal-ui-quote-mes]] 충족.

## 3. 미출시(use_yn=N) 6상품 — §8 제외 대상

| 상품 | 공식 | 가격 | 비고 |
|---|---|---|---|
| 핑크별색엽서 | PRF_DGP_A | ✅(26,213) | 데이터 완비·미런칭 |
| 금은별색엽서 | PRF_DGP_A | ✅(10,913) | 데이터 완비·미런칭 |
| 모양엽서 | PRF_DGP_B | ✅(28,913) | 데이터 완비·미런칭 |
| 미니접지카드 | PRF_DGP_E | ✅(99,353) | 데이터 완비·미런칭 |
| 썬캡 | PRF_DGP_F | ✅(262,300) | 3절 이관 완료([[pansu-authority-fn-calc-pansu-260628]])·미런칭 |
| **형압명함** | **없음** | ❌ 견적불가 | **미바인딩+자재0** — 런칭 시 공식 바인딩 필요 |

미출시 5상품은 가격 성립(런칭만 남음). 형압명함만 미완비(공식 부재).
