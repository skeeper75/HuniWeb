# 가격엔진 FK 부모 도메인 참조 데이터

round-2 가격 매핑 fit-gap·차원 매핑용. `t_prc_component_prices`의 차원 컬럼이 참조하는 부모 코드 + 공식/구성요소 유형 코드를 읽기전용으로 추출(railway pg18.4). 식별자·코드값은 영어 유지.

## 공식 유형 코드 — `t_cod_base_codes` (FRM_TYPE) — `t_prc_price_formulas.frm_typ_cd` FK 대상

| cod_cd | cod_nm |
|--------|--------|
| FRM_TYPE.01 | 합산형 (Σ components, addtn_yn='Y' 합산) |
| FRM_TYPE.02 | 단순형 (단일/고정가 추정) |

주의: **"면적매트릭스형" 코드 없음**. 면적형(실사/현수막/아크릴)은 합산형+siz_cd 차원으로 흡수 가능한지, 아니면 FRM_TYPE.03 신규 제안이 필요한지 fit-gap 판정 대상.

## 가격구성요소 유형 코드 (PRC_COMPONENT_TYPE) — `t_prc_price_components.comp_typ_cd` FK 대상

| cod_cd | cod_nm |
|--------|--------|
| PRC_COMPONENT_TYPE.01 | 인쇄비 |
| PRC_COMPONENT_TYPE.02 | 코팅비 |
| PRC_COMPONENT_TYPE.03 | 용지비 |
| PRC_COMPONENT_TYPE.04 | 후가공비 |
| PRC_COMPONENT_TYPE.05 | 박형압비 |
| PRC_COMPONENT_TYPE.06 | 완제품비 |

주의: 계산공식집초안의 구성요소(인쇄비·코팅비·용지비·후가공비·박)와 정확히 대응. **.06 완제품비** = 용지·인쇄·가공이 포함된 통가격 단가(고정가형 완제품가·커팅 합가)에 사용 — round-2 봉투(COMP_ENV_MAKING)·스티커·명함·포스터·엽서북 완제품가 component가 .06이며 `COMP_CUT_FULL_DIECUT`(완칼 합가)도 .06. **별색인쇄비**는 별도 유형 없음(인쇄비 .01 귀속 또는 별도 comp_cd 결정 대상). [정정 2026-06-07: 라이브 6종 확인 — .06 완제품비 누락 보강. dbm-validator D-3]

## 도수 코드 (clr_cd) — `t_clr_color_counts` — `t_prc_component_prices.clr_cd` FK 대상 (5행)

| clr_cd | clr_nm |
|--------|--------|
| CLR_000001 | 인쇄 안 함 |
| CLR_000002 | 1도(흑백) |
| CLR_000003 | 2도 |
| CLR_000004 | 3도 |
| CLR_000005 | CMYK 4도 |

주의: **별색(화이트/클리어/핑크)은 도수 코드에 없음**. 디지털인쇄비 시트의 별색 컬럼은 clr_cd에 자리 없음 → mat_cd(별색잉크=자재) 또는 신규 clr_cd 또는 별도 comp_cd 귀속 결정 대상. 인쇄 단/양면도 6차원에 전용 축 없음(coat_side_cnt는 코팅면수).

## 묶음 단위 코드 (QTY_UNIT) — `t_prd_product_bundle_qtys.bdl_unit_typ_cd` FK 대상

| cod_cd | cod_nm |
|--------|--------|
| QTY_UNIT.01 | EA |
| QTY_UNIT.02 | 매 |
| QTY_UNIT.03 | 권 |
| QTY_UNIT.04 | 세트 |

## 차원 컬럼 FK 요약 (`t_prc_component_prices`)

| 차원 컬럼 | 의미 | FK 부모 | nullable |
|-----------|------|---------|----------|
| comp_cd | 구성요소 | t_prc_price_components | NO |
| siz_cd | 사이즈 | t_siz_sizes (497행) | YES |
| clr_cd | 도수 | t_clr_color_counts (5행) | YES |
| mat_cd | 자재 | t_mat_materials (336행) | YES |
| coat_side_cnt | 코팅면수 | (정수, FK 없음) | YES |
| bdl_qty | 묶음수 | (정수, t_prd_product_bundle_qtys와 의미연결) | YES |
| min_qty | 수량구간하한 | (정수, max_qty 없음=상향개방) | YES |
