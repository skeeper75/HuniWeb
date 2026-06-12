# 자재 (Materials) — 횡단 축

> huni 레이어(분석대상). 자재 구성요소를 원자 항목으로 분리해 레시피가 `uses` 링크로 조립한다.
> 앵커: 라이브 `t_mat_materials`(자재 마스터) · `t_prd_product_materials`(상품↔자재 연결, usage_cd 포함).
> 권위 순서: 엑셀 L1/상품정체 > 정규화 설계 > 라이브 실측(교정 대상). 라이브값 인용은 family correction-manifest 대조 필수.
> 큐레이션 팩: `_curation/axis-materials.md`.

---

## 1. 자재 구조

### [MAT-001] 자재 마스터·상품 연결 구조  {🟡}
- 내용: 자재는 `t_mat_materials`(마스터 행, `mat_cd`·`mat_typ`)에 등재되고, 상품은 `t_prd_product_materials`로 자재를 참조하며 **`usage_cd`(사용축)** 로 "어디에 쓰이는가"(내지/표지·본체/부속 등)를 구분한다. 즉 한 자재행이 여러 상품·여러 용도로 재사용된다.
- 앵커: `t_mat_materials` · `t_prd_product_materials`(mat_cd + usage_cd)
- 출처: `huni-dbmap/00_schema/ref-materials.csv`·`ref-product-materials.csv` + 라이브 psql {tier A, PARTIAL: 06-04 스냅샷·round-13 오적재 미반영}
- 연결: [[../base/paper#BPP-003]] (uses — 자재의 보편 상위 개념)
- 사용처: _(레시피 집필 시 채움)_
- answers_cq: CQ-PROD-05 (상품별 옵션 축·자재) · CQ-TERM-04 (종이/소재 약어)
- tags: #자재 #구조 #usage_cd

### [MAT-002] 자재 = parent + usage_cd (낱장은 C단일)  {🟡}
- 내용: 자재 모델은 **부모 자재(parent) + 사용축(usage_cd)** 조합으로 표현한다. 낱장(디지털인쇄)처럼 단일 본문 자재만 쓰는 상품은 단일 컬럼(C 계열)으로 충분하나, 표지/내지를 가진 상품은 usage_cd로 슬롯을 나눈다.
- 앵커: `t_prd_product_materials.usage_cd`
- 출처: `15_domain-spec/digital-print/domain-research-notes.md` + 메모리 `dbmap-column-domain-loadspec-round11` {tier C, FRESH}
- 연결: [[#MAT-001]] · [[../base/binding#BBD-001]] (uses — 표지/내지=제본 단위 보편 개념)
- 사용처: _(레시피 집필 시 채움)_
- tags: #자재 #parent #usage_cd

---

## 2. 자재 유형·사용축 (코드 도메인)

### [MAT-003] 자재유형 코드(MAT_TYPE) 도메인  {🟡}
- 내용: 자재는 `MAT_TYPE` 코드로 유형 분류된다(예: .06 가죽). 단 **.07~.10 구간은 round-13에서 오염이 확인됨** — 색·형상·사이즈·구(口)수 같은 비(非)자재 속성이 자재행으로 잘못 등재(아래 [MAT-005]). **[W3] 코드 마스터 라이브 테이블 = `t_cod_base_codes`**(`t_base_codes` 아님). 컬럼 = `cod_cd`·`upr_cod_cd`(자기참조 계층) — **`cod_grp_cd` 컬럼 없음**. MAT_TYPE "그룹"은 별도 그룹 컬럼이 아니라 `upr_cod_cd`(상위코드) 계층으로 묶인다.
- 앵커: `t_mat_materials.mat_typ` ← `t_cod_base_codes`(`upr_cod_cd` 계층, `cod_grp_cd` 없음)
- 출처: 라이브 psql(`t_cod_base_codes` 컬럼 실측) + `00_schema/ref-base-codes.csv`·`code-values.md` {tier A/C, PARTIAL-STALE: impact-diagnosis I-8 코드 정정}
- 연결: [[#MAT-005]] (.07~10 오염) · [[load-path#LP-003]] (loaded-via — 코드행 선적재)
- 사용처: _(레시피 집필 시 채움)_
- answers_cq: CQ-TERM-07 (코드체계 의미 — MAT_TYPE)
- tags: #자재 #MAT_TYPE #코드도메인

### [MAT-004] 자재 정규화 5축 + 1축 GAP (과분할 금지)  {🟡}
- 내용: WowPress 6축 흡수 벤치마크 결과 후니 스키마는 **자재 정규화 5축을 보유**하고 1축이 GAP다. 핵심 원칙: **본체색=재질행 합성**(별도 색 자재로 과분할 금지 — 굿즈파우치가 정답 사례)·형상/사이즈=규격으로 융합·인쇄면/잉크색=도수로 분리. 색·형상을 독립 자재행으로 쪼개면 [MAT-005] 오염이 된다.
- 앵커: `t_mat_materials`(합성 원칙 — 행 분할 아님)
- 출처: `10_configurator/wowpress-option-model.md`·`huni-goods-option-mapping.md` + 메모리 `dbmap-material-option-normalization` {tier C/D, FRESH}
- 연결: [[cpq-options#CPQ-005]] (uses — 옵션=자재+공정 BUNDLE) · [[#MAT-005]]
- 사용처: _(레시피 집필 시 채움)_
- answers_cq: CQ-PROD-06 (variant 색/사이즈/두께 → 차원 분해)
- tags: #자재 #정규화 #과분할금지 #본체색합성

---

## 3. 결함 현황 (round-13 오적재 — 양면 표기)

### [MAT-005] MAT_TYPE .07~.10 자재 오염 (~120행)  {🔴 교정대기}
- 내용: round-13 횡단 결함축 ②. **라이브 현재값: 색/형상/사이즈/구수가 MAT_TYPE .08~.10에 자재로 오적재(~120행)** → **정답: 자재가 아닌 차원/옵션 속성**([MAT-004] 합성·규격 원칙으로 환원). 라이브 자재값 직접 인용 금지 — family correction-manifest 대조 후 "오적재(교정 대기)"로 표기.
- 앵커: `t_mat_materials`(mat_typ .07~.10 오염 행)
- 출처: `17_correctness/<family>/correction-manifest.md` + `_crosscut/crosscut-synthesis.md` 패턴축② {tier C(round-13), FRESH}
- 연결: [[#MAT-004]] (정답 원칙) · [[processes#PRC-006]] (UV 오적재 동형)
- 사용처: _(레시피 집필 시 채움)_
- tags: #결함 #자재오염 #round13 #교정대기

### [MAT-006] 레더 자재 3-way 혼재 → 정답 .06(가죽)  {🔴 교정대기}
- 내용: round-13 결함축 B. 레더(가죽) 자재가 .01(종이)/.06(가죽)/.08(실사) **3-way로 혼재 적재**. **라이브 현재값: MAT_000186 mat_typ=.08(실사) → 정답: .06(가죽)**. MAT_000186 단일 행이 photobook 6상품으로 **횡단 오염**한다(1행 오류 → 6상품 전파). 책자/포토북 레더 인용 시 반드시 .06로.
- 앵커: `t_mat_materials` MAT_000186 (mat_typ .08 → .06)
- 출처: `16_mapping-research/photobook/mapping-final.md` + `17_correctness/photobook/correction-manifest.md` (F-PB) {tier C(round-12/13), FRESH}
- 연결: [[#MAT-005]] (오염 패턴) · [[#MAT-003]]
- 사용처: _(레시피 집필 시 채움)_
- tags: #결함 #레더 #가죽 #횡단오염 #round13

---

## 4. GAP (미모델링·미결)

### [MAT-GAP-1] 본체색 합성 vs 색=자재 분리 통일  {🔴}
- 내용: 굿즈파우치는 본체색=재질행 합성(정답)이나 다른 family는 색=자재 오염(②). BATCH-2 컨펌 미결.
- 출처: `_curation/axis-materials.md` GAP-MAT-1 · `_crosscut/` BATCH-2 {tier C}
- 연결: [[#MAT-004]] · [[#MAT-005]]
- tags: #GAP #본체색

### [MAT-GAP-2] SHAPE/COUNT/OPT 3축 신설 필요 (WowPress 1축 GAP)  {🔴}
- 내용: 형상/구수/옵션 3축이 자재 정규화로 표현 불가 → ddl-proposer 신설 필요.
- 출처: `_curation/axis-materials.md` GAP-MAT-2 {tier D}
- 연결: [[#MAT-004]]
- tags: #GAP #SHAPE #COUNT

### [MAT-GAP-3] dep_proc_cd 삭제 후 자재→공정 게이팅 대체경로 미확정  {🔴}
- 내용: impact-diagnosis I-6 — `dep_proc_cd` 컬럼 삭제로 자재→코팅 게이팅(loadspec L96)이 무효. 대체경로(제약/공정)는 미확정. **`_loadspec/loadspec.md` L96 dep_proc_cd 게이팅 = STALE, 인용 금지.**
- 출처: `18_schema-change/impact-diagnosis.md` I-6 {tier A, FRESH}
- 연결: [[processes#PRC-GAP-4]] · [[load-path#LP-006]]
- tags: #GAP #dep_proc_cd #STALE #I-6

---

## Sources
- 큐레이션 팩: `_curation/axis-materials.md`
- 정답: `00_schema/ref-materials.csv`·`ref-product-materials.csv`·`ref-base-codes.csv`·`code-values.md`; `10_configurator/wowpress-option-model.md`·`huni-goods-option-mapping.md`; `15_domain-spec/<family>/product-bom.md`·`column-dictionary.md`·`digital-print/domain-research-notes.md`; `17_correctness/<family>/correction-manifest.md`·`_crosscut/crosscut-synthesis.md`; `16_mapping-research/photobook/mapping-final.md`; `07_domain/entity-semantic-model.md`.
- freshness: `18_schema-change/impact-diagnosis.md` I-6·I-8.
- 메모리: `dbmap-material-option-normalization`·`dbmap-option-material-process-bundle`·`dbmap-column-domain-loadspec-round11`·`dbmap-correctness-audit-round13`.
- stale(인용 금지): `_loadspec/loadspec.md` L96(dep_proc_cd 게이팅, I-6); 라이브 자재값 직접 인용(round-13 ② 오염, correction-manifest 미대조 시).
