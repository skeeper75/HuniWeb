# remediation-spec-batch3.md — 배치3 교정 명세 (인간 승인 큐·dbmap 라우팅)

> Phase 4 — hcc-conformance-gate · 2026-06-23 · §21 배치3. 확정 결함만 교정 명세화.
> ★직접 COMMIT 금지·search-before-mint·단가 verbatim 불변. 실 적재=인간 승인 후 dbmap 트랙 위임.
> 클래스 A=즉시(공유자원 충돌 없음)·B=공유자원/모델확정 종속(보류).

## 교정 명세 (확정 결함)

| ID | 결함 | 권위 정답 | 교정 방법 | 대상 t_* | FK 위상 | 돈영향 | dbmap 트랙 | 클래스 | 인간 승인 |
|----|------|-----------|-----------|----------|---------|--------|------------|--------|-----------|
| **R-B3-PRICE** ★최위험 | 실사 118/120/121/123 A3/A2/A1 프리셋 **과대청구**(A3·A2 +5,000·A1 +8,000) — 프리셋 고정가 행 미적재 | silsa-l1 260610: A3=7,000·A2=7,000·A1=12,000·사용자입력=20,000 | 면적그리드에 **siz_cd 매칭 프리셋 행 추가**(A3/A2/A1 고정가) — `_row_matches`가 siz_cd 우선·없으면 면적 ceiling(사용자입력 전용). ★단가 verbatim(7000/7000/12000)·날조 0 | t_prc_component_prices(COMP_POSTER_ARTPRINT_PHOTO) | comp 존재→행 추가 | **과대(매당 +5~8천·4상품×3프리셋)** | dbm-price-arbiter(프리셋 vs 면적 모델 정립)→dbm-load-execution | **B**(공유 comp 4상품·모델 확정 선행) | 필요(모델+적재) |
| **R-B3-1** | 아크릴 147~166 **미바인딩 20**(가격 0·견적 불가·차단) | acrylic-l1: 20상품 `가격`(고정단가)+`가공_가격` 존재=모델 의도 있음 | Q-ACR-MISSING20 인간 확정(고정가형 PRODUCT_PRICE 순위2 vs 공식형 FORMULA) → 바인딩+필요시 고정단가 적재. orphan comp(COROTTO 21행·KEYRING 2·MIRROR3T 52) 재사용 | t_prd_product_price_formulas(+필요시 component_prices) | comp/공식 선존재→product 바인딩 | 차단(과대 아님) | dbm-price-arbiter→dbm-load-execution | **B**(모델 확정 선행) | 필요 |
| **R-B3-BUNDLE** | 아크릴 148/149/152/154 부속물 **부착공정 누락**(mat 등록·proc=UV만) | [[dbmap-option-material-process-bundle]]: 부속물=자재+공정 구분등록 | 부착공정(원형핀/투명집게/일자핀/블랙헤어끈) proc 충전 | t_prd_product_processes | proc 마스터 선존재→product proc | 없음(미바인딩이라 silent 합산 불가) | dbm-axis-staged-load | **B**(R-B3-1 가격복구 동반·Q-ACR-부속물BUNDLE) | 필요 |
| **R-B3-CPQ-MM1** | PET배너 PRD_000136 거치대 그룹 비대칭(OPV-000020 실외용 item 0=반쪽 dead link)·그룹 min/max NULL | 실내/실외 대칭 배선 | OPV-000020 option_item 생성(자재 환원)·OPT-000009 min/max 충전 | t_prd_product_option_items·option_groups | 자재행 선존재→item | 없음(자재환원 실패=견적불가) | dbm-cpq-option-mapping | **A** | 필요 |
| **R-B3-CPQ-MM2** | PRD_000146 고리 그룹 sel_typ_cd NULL·min/max NULL | 택1/택N 확정 | OPT-000012 sel_typ_cd+min/max 충전 | t_prd_product_option_groups | — | 없음 | dbm-cpq-option-mapping | **A** | 필요(택1/N 확정) |
| **R-B3-EXTRA** | TMPL-000013 테스트 잔재(base PET배너·needed=N) | 운영 불요 | use_yn=N 또는 논리삭제 | t_prd_templates | — | 없음 | dbm-cpq-option-mapping | **A** | 필요 |
| **R-B3-CPQ-MISS** | 옵션그룹 45·제약 22·추가상품 2·템플릿 7 MISSING(구조 미충전) | authority-spec §1~2.3 | 옵션레이어·제약·세트조합 설계 적재 | t_prd_product_option_*·constraints·templates·addons | FK 위상 적재순서 | 없음(구조·견적조립 불가) | dbm-option-mapper·dbm-cpq-option-mapping | **A**(MM/EXTRA와)·일부 B(템플릿=Q-ACR-MISSING20 종속) | 필요 |

## 인간 승인 큐 (우선순위)

1. **R-B3-PRICE** ★1순위(돈크리·신규·실청구 발생면) — 면적그리드 프리셋 고정가 행 미적재로 A3/A2 +5,000·**A1 +8,000** 과대청구. 4상품 공유 comp라 적재 전 영향 SELECT 필수. dbm-price-arbiter 모델정립(프리셋행 vs 면적 catch-all 분리) → load-execution. **단가 verbatim 7000/7000/12000 불변.**
2. **R-B3-1** 아크릴 20 미바인딩 — Q-ACR-MISSING20(고정가형 vs 가공가산형) 인간 확정 동반. codex 결정체크=evaluate_price에 formula 외 `가격` 직접읽기 branch 실재여부가 모델 확정의 자. 차단 해소(최대 상품수).
3. **R-B3-BUNDLE** 부속물 부착공정 4 — R-B3-1 가격복구 시점 동반 교정(2차 결함).
4. **R-B3-CPQ 클래스 A**(MM1·MM2·EXTRA) 즉시 — 공유자원 충돌 없음·돈영향 없음.
5. **R-B3-CPQ-MISS** 구조 미충전(45/22/2/7) — 옵션레이어 설계 적재(템플릿 7은 Q-ACR-MISSING20 종속=B).

## CONFIRM 인간 확정 종속 (적재값 여기 종속)
- **Q-ACR-MISSING20**: 아크릴 고정가형 vs 가공가산형 권위 모델 → R-B3-1·R-B3-BUNDLE·템플릿 7 종속.
- **Q-ACR-부속물BUNDLE**: 부속물 부착공정 mat+proc 구분등록 기준(고리없음/색상은 부착 아님).
- **Q-SILSA-투명포스터**: 라이브 미등록(checklist 행 0) — 스코프 외(등록 결정은 별 트랙).
- 실사 도수축 미등록 29·코팅/별색 공정축 귀속 8 = CONFIRM(축귀속·결함 아님·인간 정의).

## 안전
- 직접 COMMIT/DDL 0. search-before-mint(comp/proc/공식 선존재 확인 후 행 추가만). 단가 verbatim 불변·날조 0.
- 공유자원(COMP_POSTER_ARTPRINT_PHOTO 4상품 공유) 교정 전 SELECT 영향범위 필수. R-B3-PRICE는 프리셋 행 **추가**(기존 사용자입력 티어 불변)라 회귀 위험 낮으나 dbm-price-arbiter 모델 정립 선행 권고.
