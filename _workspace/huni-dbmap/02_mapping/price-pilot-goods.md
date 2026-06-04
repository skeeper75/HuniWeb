# 가격 매핑 파일럿 — 굿즈파우치 고정가형 (round-2)

첫 통합 매핑 파일럿. 고정가형 `굿즈파우치(가격포함)` 3상품으로 **단일가 경로 + 사이즈 variant 경로**를 end-to-end 검증. **DB 무접촉**(읽기전용 참조 CSV + 적재용 CSV만 생성, 실제 적재 미수행). 식별자/컬럼/코드는 영어.

## 파일럿 범위 (3상품, 결정 ③ 검증)

| 상품 | prd_cd | 유형 | 경로 |
|------|--------|------|------|
| 레더코스터 (원형90mm, 3300) | PRD_000188 | 단일가 | `t_prd_product_prices` |
| 사각손거울 (S/M/L = 5000/5500/6000) | PRD_000186 | 사이즈 variant | `t_prc_component_prices` (siz_cd 차원) |
| 머그컵 (화이트/반투명/투명 = 6500/7500/7500) | PRD_000193 | 색상 variant | **GAP** — mat_cd 미존재 |

## 매핑 설계 (확정규칙 적용)

### 경로 A — 단일가 → `t_prd_product_prices`
레더코스터처럼 variant 없는 상품은 상품단가 테이블 직접 적재.
- `(PRD_000188, apply_ymd, unit_price=3300)`. 1행.

### 경로 B — 사이즈 variant → 공식엔진 + `component_prices` siz_cd
손거울처럼 사이즈별 가격이 다른 상품은 결정③대로 component_prices의 siz_cd 차원으로. FRM_TYPE.02 단순형 공식 1개 + 완제품가 component 1개:
- `t_prc_price_formulas`: `PRF_GDS_SQMIRROR` (frm_typ_cd=FRM_TYPE.02)
- `t_prc_price_components`: `COMP_GDS_SQMIRROR` (comp_typ_cd=**NULL** — 아래 발견3)
- `t_prc_formula_components`: PRF↔COMP (disp_seq=1, addtn_yn=Y)
- `t_prc_component_prices`: 3행, siz_cd=SIZ_000384/386/388, unit_price=5000/5500/6000, 그 외 차원 NULL
- `t_prd_product_price_formulas`: PRD_000186 → PRF_GDS_SQMIRROR

siz_cd 해소(파일 기반): 엑셀 "S(75x130mm)/M(95x166mm)/L(120x218mm)" = `t_siz_sizes` SIZ_000384/386/388 정확 일치 + `t_prd_product_sizes` 링크 존재.

## 검증 결과 — 15/15 PASS (파일 기반)

- **recompute**(시트값=CSV값): 레더코스터 3300, 손거울 5000/5500/6000 전부 일치 ✓
- **FK 존재**(참조 CSV): prd_cd·siz_cd·frm_typ_cd 전부 부모 존재 ✓
- **제약**: 자연키 UNIQUE8 무중복, apply_ymd NOT NULL, use_yn/addtn_yn∈Y/N, PK 유니크 ✓
- 적재순서(formulas+components→formula_components+component_prices→product_price_formulas; product_prices 독립) 준수.

## 파일럿 발견 (결정 검증 + 신규)

1. **결정③ siz_cd 경로 입증** — 사이즈 variant는 component_prices.siz_cd로 무결하게 적재 가능. 스키마 변경 0. SIZ 코드·product_sizes 링크 기존재.
2. **결정③ mat_cd 경로 GAP(신규)** — 색상 variant(머그 화이트/반투명/투명)는 `t_mat_materials`에 해당 자재 부재(화이트면지·아크릴화이트 등 타용도만). **해소: 머그 색상 자재 선등록(MAT 신규) 후 mat_cd 차원 적재**, 또는 색상=옵션 별도 처리. → 컨버전 게이트 항목.
3. **comp_typ_cd NULL 처리(신규)** — 굿즈 완제품가는 PRC_COMPONENT_TYPE 5종(인쇄/코팅/용지/후가공/박형압) 어디에도 안 맞음. comp_typ_cd nullable이라 NULL 적재 가능하나, "완제품가/상품가" 유형 신설 여부는 후니 확인 대상.
4. **apply_ymd placeholder** — `2026-07-01` 임시값. go-live 확정 시 일괄 변경(결정⑦).

## 산출물

- `02_mapping/load_price_pilot/` — 적재용 CSV 6종(t_prd_product_prices·t_prc_price_formulas·price_components·formula_components·component_prices·t_prd_product_price_formulas)
- `00_schema/ref-{products,sizes,materials,product-processes,product-sizes}.csv` — 읽기전용 1회 추출 참조(파일 기반 작업용)

## 다음 단계

- 머그 색상 GAP(발견2) 해소 방식 결정 → 색상 variant 파일럿 보강
- 동일 패턴으로 고정가형 확대(상품액세서리 등) → 이후 원자합산형(엽서) 파일럿
- comp_typ_cd 완제품가 유형 신설 여부 후니 확인
