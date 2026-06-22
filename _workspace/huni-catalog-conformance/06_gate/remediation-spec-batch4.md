# remediation-spec-batch4.md — 굿즈파우치 교정 명세 (인간 승인 큐·dbmap 라우팅)

> hcc-conformance-gate · 2026-06-23 · §21 배치4. 확정 결함 → 실행 가능 교정 명세.
> [HARD] 직접 COMMIT 금지·search-before-mint·단가 verbatim 불변. 실 적재는 인간 승인 후 dbmap 트랙 위임.
> ★기초코드 마스터(t_mat/t_siz/t_prc 공유) 수정 금지(§21 교정범위 제약·[[catalog-conformance-remediation-scope]]). 교정은 상품별 구성요소(t_prd_product_*)만.

## 1. 클래스 A (즉시 가능·단가 verbatim·할인 정합)

| ID | 결함 | 권위 정답 | 교정 방법 | 대상 t_* | FK 위상 | 돈영향 | dbmap 트랙 | 인간 승인 |
|----|------|----------|----------|----------|--------|--------|-----------|:---:|
| **R-GP4-1** | GP-1 ~52상품 base 미적재(source=NONE) | 상품마스터 C열 단가 verbatim×qty | product_prices INSERT(C열 단가) | t_prd_product_prices | prd 선행(존재 O) | 차단 해소(견적 0→정상) | dbm-load-execution | ✅ 필요 |
| **R-GP4-2** | PRD_000203 할인타입 DSC_ACR_QTY 오귀속 | 굿즈=GOODSA/B/FABRIC/SQUISHY 중 1(권위 가격표 구간 대조) | dsc_tbl_cd 재바인딩(ACR→정확 굿즈타입) | t_prd_product_discount_tables | dsc 마스터 존재 O | 잠재 오청구 차단 | dbm-axis-staged-load | ✅ 필요 |
| **R-GP4-3** | 판형 85 EXTRA(작업/재단 사이즈가 plate에) | 굿즈=전지 없음·plate 0행 | plate_sizes 행 삭제(del_yn=Y) 또는 sizes 이관 | t_prd_product_plate_sizes / t_prd_product_sizes | siz 마스터 존재 | 적재 시 차원환원 오류 예방 | dbm-axis-staged-load | ✅ 필요 |
| **R-GP4-4** | 자재 76 MISMATCH(옵션값 67행 혼입) | 본체소재만 USAGE.07 잔류·옵션값→해당 축 | **행 단위** 정규화(2구/3구/4구→bundle·단/양면→print_opt·S/M/L→siz·색→print_opt) | t_prd_product_materials(제거)+bundle_qtys/print_options/sizes(이관) | 각 축 마스터 | 적재 시 silent 합산 예방 | dbm-axis-staged-load | ✅ 필요 |

★ R-GP4-4 [HARD]: 게이트 재실측이 PRD_000230=`레더\|L\|M` 적발 → **전수 100% 삭제 금지**. 본체소재(레더/캔버스/린넨/메쉬/타이벡) 행은 USAGE.07 잔류, 옵션값 행만 이관. 진원=상류 v03 분해 규칙(load_master 무변환 전파)·교정정답=교정 엑셀 재적재(경로 Y).

## 2. 클래스 B (선행 컨펌·심의 후 적재)

| ID | 결함 | 선행 | 대상 t_* | dbmap 트랙 | 인간 승인 |
|----|------|------|----------|-----------|:---:|
| **R-GP4-5** | GP-2 9상품 variant FORMULA 미바인딩(이중 단절) | use_dims=[siz_cd/opt_cd] 판별차원 충전·CPQ 옵션레이어 동반 | t_prd_product_price_formulas + t_prc_* + option_groups/options/items | dbm-cpq-option-mapping + dbm-load-execution | ✅ |
| **R-GP4-6** | C-GP-4 가공 가산 개당 vs 1회 정액(Q-GP-FIN1) | arbiter 심의(라벨/맥세이프/에폭시) | t_prd_product_processes·comp use_dims | dbm-price-arbiter | ✅ |
| **R-GP4-7** | C-GP-5 구수 가격축 여부(타공 비례?) | 묶음수→bundle_qtys 이관·가격축 판정 | t_prd_product_bundle_qtys | dbm-ddl-proposer + dbm-axis-staged-load | ✅ |
| **R-GP4-8** | CPQ 77 MISSING(옵션그룹67·addon5·템플릿5) | option_items ref_dim_cd 100% 해소(fn_chk_opt_item_ref) | option_groups/options/items + addons + templates/selections | dbm-cpq-option-mapping | ✅ |

## 3. 적재 후 과대청구 가드 (codex 합의 + 신규 유일성 체크 — 적재 명세 강제)

| 가드 ID | 체크 | 근거 |
|---------|------|------|
| **G-GP-3** 평탄화 금지 | GP-2 variant 단가행 use_dims=[siz_cd/opt_cd] NULL 금지(와일드카드=silent 오선택) | golden GC-GP7/8/9 S/M/L 정확매칭 |
| **G-GP-5** PRODUCT_PRICE 선점 금지 | GP-2 prd에 product_prices INSERT 금지(1행이라도 들어가면 FORMULA 영영 우회) | §18 처방·라이브 EXTRA 0 확인 |
| **G-GP-6** 단가행 유일성(codex 신규) | 동일 discriminator(siz_cd/opt_cd)당 component_prices 1행만(중복=중복 합산) | codex 가설→적재 명세 검증 큐 |
| **G-GP-7** discount FK 무결성 | 굿즈 discount는 GOODSA/B/FABRIC/SQUISHY만(ACR 금지)·use_yn=Y·정률 | 게이트 K4 재실측(ACR 1건 적발) |

## 4. NO_AUTHORITY (적재 불가·인간 확정)

| prd | 쟁점 | 라우팅 |
|-----|------|--------|
| 투명부채·미니CD앨범·극세사타월·타이벡북커버·말랑증사홀더 | 가격·선택가격 둘다 empty(권위 부재) | 가격표260527 별도 존재 여부 / 신규준비중 인간 확정(C-GP-2) |

## 5. 인간 승인 큐 종합 (배치4)

1. **R-GP4-1**(GP-1 base 적재 ~52상품·즉시·견적 0 해소) — 1순위·돈크리티컬 차단.
2. **R-GP4-2**(PRD_000203 할인 재바인딩) — 잠재 오청구.
3. **R-GP4-3·4**(판형 정리·자재 정규화) — 적재 전 진원(상류 v03) 교정 선행 권장.
4. **R-GP4-5~8**(GP-2 FORMULA·가공·구수·CPQ) — 심의/컨펌 후.
5. **C-GP-2 NO_AUTHORITY 5** — 가격 권위 인간 확정.

모든 R/G는 search-before-mint·기초코드 마스터 불변·단가 verbatim·DB 미적재(실 COMMIT 인간 승인 후 dbmap 위임).
