# 가격 매핑 스펙 (round-2 파일럿 5시트) — t_prc_* 엔진

가격표 5 단가시트(코팅·디지털인쇄·아크릴·인쇄후가공·봉투제작)를 `t_prc_*`/`t_prd_*`/`t_cod_*`로 매핑한 적재 설계서.
[HARD] dbm-price-formula SKILL 규칙 1~10 권위 · DB 미적재 · 스키마 무변경 · 각 매핑 근거(왜) 명시.
식별자/컬럼/코드/CSV헤더 영어, 해석 한국어.

## 0. 산출물

| 파일 | 행수 | 내용 |
|------|------|------|
| `load_price/t_prc_component_prices.csv` | 1752 | 5시트 평면화 long-format(6차원 단가). 자연키8 중복 0 |
| `load_price/t_prc_price_components.csv` | 32 | comp_cd 카탈로그(부모) |
| `load_price/t_prc_price_formulas.csv` | 1 | PRF_ENV_MAKING(봉투 단순형) |
| `load_price/t_prc_formula_components.csv` | 1 | 봉투 공식↔구성요소 배선 |
| `load_price/t_prd_product_price_formulas.csv` | 1 | PRD_000050→PRF_ENV_MAKING 바인딩 |
| `load_price/t_cod_base_codes.csv` | 1 | PRC_COMPONENT_TYPE.06 완제품비 신규 코드행 |
| `scripts/transform_price_sheets.py` | — | 재현 평면화(L1 CSV→component_prices) |
| `scripts/build_engine_tables.py` | — | 부모/공식/배선/바인딩/코드 CSV 생성 |

시트별 component_prices 행수: 코팅 184 · 디지털 954 · 아크릴 358 · 후가공 216 · 봉투 40.

## 1. source → target 컬럼 매핑 (시트별)

### t_prc_component_prices 공통 컬럼
| DB 컬럼 | 타입 | 소스 | 변환 |
|---------|------|------|------|
| comp_price_id | bigint PK | (surrogate) | 1부터 자동 부여 |
| comp_cd | vc50 FK NN | band/블록 | 옵션별 comp_cd(2장 코드제안) |
| apply_ymd | vc10 NN | (고정) | `2026-06-01`(C-1·규칙⑦) |
| siz_cd | vc50 FK | 규격/면적/봉투종류 | placeholder(미등록) 또는 NULL |
| clr_cd | vc50 FK | 도수밴드 | 흑백=CLR_000002/칼라=CLR_000005/별색=**NULL** |
| mat_cd | vc50 FK | 소재밴드 | 봉투만(MAT_000159/000168) |
| coat_side_cnt | int | 단/양면 | 코팅만(단면1/양면2) |
| bdl_qty | int | — | (파일럿 미사용) NULL |
| min_qty | int | 수량행 | 출력매수/제작수량(상향개방) |
| unit_price | num(12,2) NN | 셀값 | **L1 value 그대로**(변조 금지) |
| note | vc500 | (생성) | 근거·역대조 키 |

### 시트별 차원 배치 (확정)

| 시트 | comp_cd | siz_cd | clr_cd | mat_cd | coat_side_cnt | min_qty |
|------|---------|--------|--------|--------|---------------|---------|
| 코팅 | 무광/유광 | 국4절/3절(P) | NULL | NULL | 1/2 | 출력매수 |
| 디지털 | 도수+별색×단/양면 | 국4절/3절(P) | 흑백/칼라 또는 NULL | NULL | NULL | 출력매수 |
| 아크릴 | 종류 | 면적(P 196) | NULL | NULL | NULL | NULL |
| 후가공 | 종류+옵션 | NULL | NULL | NULL | NULL | 제작수량 |
| 봉투 | MAKING | 봉투종류(P 4) | NULL | 모조/레자크 | NULL | 제작수량 |

(P)=placeholder siz_cd(후니 등록 대기). 빈칸=NULL(공란→NULL, C-9, 빈문자열 아님).

## 2. transform 규칙 + 워크드 예제

| 규칙 | 한 줄 규칙 | 워크드 예제 |
|------|-----------|-------------|
| T-1 밴드 leaf 분해 | `band_header_path`("무광코팅 > 단면")를 `>`로 split → 외밴드=comp, 내밴드=옵션 | 코팅 C4 "무광코팅 > 양면" → comp=COMP_COAT_MATTE, coat_side_cnt=2, unit_price=4000 |
| T-2 별색 clr NULL | 외밴드가 별색이면 clr_cd=NULL + 별색 comp 분리 | 디지털 F4 "별색(화이트) > 단면" → comp=COMP_PRINT_SPOT_WHITE_S1, **clr_cd=공란**, unit_price=3000 |
| T-3 단/양면 comp 분리 | 인쇄 단/양면=별도 comp(`_S1/_S2`), 양면≠단면×2 | 디지털 E4 칼라양면 q1 → COMP_PRINT_DIGITAL_S2, 6000(단면4000×2=8000 아님) |
| T-4 면적매트릭스 | 가로(row2 leaf)×세로(A열 row_key) → siz_cd, 셀=단가 | 아크릴 B01 col=B(가로20mm)×row_key=20mm → SIZ_PENDING_ACRYL_20x20=2500 |
| T-5 수식 data_only | 수식셀(=B3*2)도 data_only 계산값 그대로 적재 | 미러 20×20 → 5000(투명2500×2, 동적계산 안 함) |
| T-6 옵션 comp 흡수 | 후가공 옵션(직각/둥근, 1줄)=comp_cd 접미(차원부재 해소) | 모서리 직각→COMP_PP_CORNER_RIGHT(0), 둥근→COMP_PP_CORNER_ROUND(2000) |
| T-7 수량행→min_qty | A열 숫자 row_key=min_qty(상향개방, sentinel 그대로) | 코팅 q1000000 → min_qty=1000000(상한개방 마커) |
| T-8 머지 forward-fill | 머지셀 풀어 leaf별 band 경로 보존(L1이 이미 풀어둠) | 봉투 B2:C2 머지 "티켓봉투" → B3/C3 각 소재 leaf로 분해 |
| T-9 자연키8 dedup | (comp,apply,siz,clr,mat,coat,bdl,min) 동일조합 사전제거 | C-2: 1752행 전건 유니크(중복 0) |
| T-10 레자크 동일단가 | 한 셀 2종소재(체크/줄무늬) 동일단가 → 대표 mat 1종+note | 봉투 레자크열 → mat=MAT_000168(체크), note에 줄무늬 MAT_000169 동일 |

## 3. default/derived 값 (근거)

| 값 | 출처 | 근거 |
|----|------|------|
| apply_ymd=`2026-06-01` | 파생(고정) | 규칙⑦·C-1. round-1·round-2 전건 통일 |
| use_yn=`Y` | 파생 | C-8. 신규 comp/formula 활성 |
| addtn_yn=`Y` | 파생 | C-4. 봉투 단일 component 합산 플래그 |
| comp_typ_cd | 매핑 | .01인쇄/.02코팅/.04후가공/.06완제품(코드제안 2장) |
| frm_typ_cd=`FRM_TYPE.02` | 매핑 | 봉투 단순형(C-5) |
| clr_cd=NULL(별색) | 규칙① | 별색=공정, clr 매핑=FK위반 |
| siz_cd placeholder | 미등록 표식 | 후니 등록 대기(발명 금지) |

## 4. 적재 순서 (FK 그래프)

```
[0] t_cod_base_codes(PRC_COMPONENT_TYPE.06) → 선행 (comp_typ FK 부모)
[0] siz_cd placeholder 후니 등록 → 적재 차단 해소 전제(특히 아크릴 196 = P-1 에스컬레이션)
[1] t_prc_price_formulas, t_prc_price_components       (병렬, 부모)
[2] t_prc_formula_components, t_prc_component_prices    (병렬, 자식 — comp_cd 선존재)
[3] t_prd_product_price_formulas                        (prd_cd+frm_cd 선존재)
```

FK 근거: `component_prices.comp_cd`→`price_components`(ON DELETE CASCADE), `formula_components.{frm,comp}_cd`→부모(RESTRICT), `product_price_formulas.{prd,frm}_cd`→부모(RESTRICT). `price_components.comp_typ_cd`→`base_codes`(.06 선행 필수).

## 5. FK 검증 결과 (읽기전용, 발명 0)

| 부모 | 검증 | 비고 |
|------|------|------|
| comp_typ_cd .01/.02/.04 | OK(부모존재) | ref-base-codes |
| comp_typ_cd .06 | 신규(CSV 신설) | t_cod_base_codes.csv |
| frm_typ_cd FRM_TYPE.02 | OK | |
| clr_cd CLR_000002/000005 | OK | 별색 530행=NULL(규칙①) |
| mat_cd MAT_000159/000168 | OK | 봉투제작 자재링크 기존 |
| prd_cd PRD_000050 | OK | 봉투제작 상품 |
| siz_cd | **부재 202종**(국4절/3절 2·봉투 4·아크릴 196) | 후니 등록 대기 |

## 6. 역대조 결과 (엑셀셀 ↔ CSV)

23/23 PASS(시트당 ≥5 샘플). 핵심:
- 양면≠단면×2: 디지털 칼라양면6000(≠8000)·코팅 양면260 ✓
- 별색 clr=NULL 530행(규칙①) ✓
- 미러 수식81 data_only 5000(=투명2500×2) ✓
- 후가공 옵션 충돌해소: 직각0 vs 둥근2000 별 comp ✓
- 봉투 mat_cd 정확(티켓모조q1000=96000) ✓
- 누락/중복 0(1752행 자연키 유니크).

## 7. 설계 결정 — 사용자 확인 필요 (DECISION)

| ID | 결정 | 근거 | 확인 요청 |
|----|------|------|-----------|
| **D-1 아크릴 면적 siz_cd** | 196 면적좌표를 siz_cd로 일괄등록 vs 면적함수 보간모델 | "직접입력형"(사용자 가로/세로 입력)이라 고정 196좌표보다 면적함수가 적합할 수 있음. 현 placeholder=적재차단 | **에스컬레이션**: 196 siz 등록 OK? 아니면 면적보간 별도설계? |
| **D-2 출력규격 siz 등록** | 국4절/3절을 siz_sizes에 등록 | 디지털·코팅 출력규격 차원. ref-sizes 부재 | 국4절/3절 work/cut 치수 확정 후 등록 |
| **D-3 봉투종류 siz 등록** | 티켓/소/자켓/대 봉투규격 siz 등록 | 봉투 4종 사이즈 부재 | 봉투규격 치수 확정 |
| **D-4 박 시트 GAP** | 면적→분류(A~E)→가격 2단룩업 모델 | 6차원에 분류군 슬롯 없음. 별도 매핑표 둘 곳이 스키마에 없음(무변경 원칙) | 면적→A~E 매핑표 위치 결정(주문계산 외부 vs 후니 결정) |
| D-5 .06 완제품비 등록 | PRC_COMPONENT_TYPE.06 코드 등록 | 규칙⑩·D-D 확정 | 후니 코드마스터 등록(CSV 산출됨) |

[HARD] 위 DECISION은 단정하지 않고 dbm-validator/lead 경유 사용자 확인. siz_cd placeholder 미해소 시 적재 차단(발명 금지).
