# 공정 (Processes) — 횡단 축

> huni 레이어(분석대상). 공정 구성요소를 원자 항목으로 분리해 레시피가 `uses`/`requires`로 조립한다.
> 앵커: 라이브 `t_proc_processes`(공정 마스터) · `t_prd_product_processes`(상품↔공정 연결, 배타 컬럼 `mand_proc_yn`).
> **[W3 라이브 실측] `t_prd_product_process_excl_groups`(택일 그룹) 테이블은 라이브 부존재**(`information_schema.tables LIKE '%excl%'` → 0행, 06-04 ref-csv엔 존재 → 이후 삭제 추정). "DDL 선언(과거 ref-csv) vs 라이브 미적용" — 컬럼/테이블 존재 ≠ 적용 완료. 택일 표현의 라이브 실재 경로는 `t_prd_product_processes.mand_proc_yn`(아래 [PRC-001]), 택일그룹 구조 자체는 🔴 GAP([PRC-GAP-5]).
> 권위 순서: 엑셀 L1/실무진 확정 > 공정 도메인(PDF) > 라이브 실측(교정 대상).
> 큐레이션 팩: `_curation/axis-processes.md`.

---

## 1. 공정 구조

### [PRC-001] 공정 마스터·상품 연결·배타(mand_proc_yn)  {🟡}
- 내용: 공정은 `t_proc_processes`(마스터, `proc_cd`)에 등재되고, 상품은 `t_prd_product_processes`로 연결한다. 한 상품에서 **상호배제/필수 공정** 표현의 라이브 실재 경로는 `t_prd_product_processes.mand_proc_yn`(실재 컬럼)이다. (전용 택일그룹 테이블 `t_prd_product_process_excl_groups`는 **라이브 부존재** — 헤더 [W3] 참조, 택일그룹 구조는 🔴 GAP [PRC-GAP-5].)
- 앵커: `t_proc_processes` · `t_prd_product_processes`(배타 `mand_proc_yn`)
- 출처: `00_schema/ref-processes.csv`·`ref-product-processes.csv` + 라이브 psql(`information_schema` 실측) {tier A, PARTIAL: 06-04 스냅샷·excl_groups 삭제 반영}
- 연결: [[../base/finishing#BFN-001]] (uses — 공정의 보편 상위 개념) · [[#PRC-002]] · [[#PRC-GAP-5]] (택일그룹 GAP)
- 사용처: [[recipes/digital-print#DGP-BM-002]] (uses — 디지털인쇄 공정 라우트) · [[recipes/sticker#STK-BOM-001]] (uses — 커팅 반칼/완칼/도무송)
- answers_cq: CQ-PROC-01 (공정 라우트·상품군 매핑) · CQ-PROC-02 (공정 시퀀스 전후 의존)
- tags: #공정 #구조 #mand_proc_yn

### [PRC-002] 공정택일그룹 = 인쇄방식별 레시피 (도메인 명제 — 라이브 DB 구조 부재)  {🔴 GAP}
- 내용: 다중공정 UI 택일 구조는 단순 배타가 아니라 **인쇄방식별(옵셋/실사/윤전/디지털) "레시피"** 로 해석해야 의미가 확정된다(캘린더·현수막류) — 같은 슬롯이라도 인쇄방식에 따라 허용 공정 집합이 다르다. **단 이 택일그룹을 담을 라이브 DB 구조는 부존재**(`t_prd_product_process_excl_groups` 삭제됨, 헤더 [W3]). 현 라이브 배타 표현은 `mand_proc_yn`뿐 → 인쇄방식별 레시피 구조는 미모델링 GAP([PRC-GAP-5]). 이 항목은 도메인 명제로만 보존하고 라이브 구조로 단정 금지.
- 앵커: (라이브 DB 구조 부재 — 도메인 명제) · `07_domain/process-recipe-tree.md`
- 출처: `07_domain/process-recipe-tree.md` + 메모리 `dbmap-process-select-group-domain` {tier C, FRESH(도메인)·라이브 앵커 GAP}
- 연결: [[#PRC-001]] (mand_proc_yn) · [[#PRC-GAP-5]] · [[../base/printing-methods#3-방식-선택을-가르는-변수]]
- 사용처: _(레시피 집필 시 채움)_
- answers_cq: CQ-PROC-07 (공정 택일그룹 구조·적용 상품)
- tags: #공정 #택일 #레시피 #인쇄방식 #GAP

---

## 2. 별색·순수공정 (핵심 규칙)

### [PRC-003] 별색 = 공정 (clr_cd=NULL)  {🟡}
- 내용: **별색(spot color)은 도수(色數)가 아니라 공정**으로 모델링한다(C18~22 → `t_proc_processes`). 별색 공정행은 `clr_cd=NULL`로 둔다(색 코드가 아니므로). 주의: 정리물에 별색 008~012 vs PROC_000007 **내부 불일치** 전례(round-12 교훈) — 권위는 "별색=공정·clr_cd=NULL".
- 앵커: `t_proc_processes`(별색 공정, clr_cd=NULL)
- 출처: `15_domain-spec/digital-print/domain-research-notes.md` + round-13 acrylic {tier C(round-11/13), FRESH}
- 연결: [[../base/color#BCL-003]] (uses — 별색 보편 정의) · [[price-engine#PE-005]] (priced-by — 별색=공정 → 합산형 비용)
- 사용처: [[recipes/digital-print#DGP-BM-002]] (uses — 별색=공정 합산 항목) · [[recipes/sticker#STK-BOM-002]] (uses — 화이트 underbase=공정)
- answers_cq: CQ-FIN-03 (별색인쇄 용도) · CQ-FIN-05 (박 vs 형압 vs 별색금 구별·DB 인코딩)
- tags: #공정 #별색 #spotcolor #clr_cd_null

### [PRC-004] 순수공정은 자재 없음 (열재단·타공 bare-hole)  {🟡}
- 내용: 열재단·타공(bare-hole) 등 **순수공정은 부착 자재가 없다**. 반대로 아일렛 같은 옵션은 금속링(자재) + 박는 타공(공정) **BUNDLE**이다([[cpq-options#CPQ-005]]).
- 앵커: `t_prd_product_processes`(자재 미연결 공정)
- 출처: 메모리 `dbmap-option-material-process-bundle` {FRESH}
- 연결: [[#PRC-005]] · [[materials#MAT-004]]
- 사용처: [[recipes/digital-print#DGP-BM-003]] (uses — 완칼 PROC_000053 커팅=순수공정) · [[recipes/sticker#STK-BOM-001]] (uses — 스티커 커팅=순수공정)
- tags: #공정 #순수공정 #열재단 #타공

### [PRC-005] 박·코팅·UV = 공정 (실무진 확정 Q1~Q15)  {🟡}
- 내용: 실무진 회신 확정 — **박/코팅 = 공정**(자재 아님)·우드거치대 = 자재·미싱제본 = 신규 공정·디자인 = 1상품+에디터 템플릿. UV는 `PROC_000002`. (코팅의 family별 분류 분산은 [PRC-006] 미결 참조.)
- 앵커: `t_proc_processes`(박·코팅·UV PROC_000002)
- 출처: `15_domain-spec/<family>/domain-research-notes.md`(Q1~Q15) + 메모리 `dbmap-column-domain-loadspec-round11` {tier B, FRESH}
- 연결: [[#PRC-006]] · [[../base/finishing#BFN-004]] (uses — 박 보편 정의)
- 사용처: [[recipes/digital-print#DGP-BM-004]] (uses — 박=공정) · [[recipes/digital-print#DGP-BM-002]] (uses — 박/코팅 공정) · [[recipes/sticker#STK-ST-001]] (uses — 코팅=공정 정답, CONFLICT) · [[recipes/booklet#BK-BOM-002]] (uses — 책자 제본/코팅/박색=공정)
- answers_cq: CQ-FIN-01 (후가공 공정 전체 목록) · CQ-FIN-02 (코팅 종류) · CQ-FIN-04 (UV평판인쇄 정의)
- tags: #공정 #박 #코팅 #UV #실무진확정

---

## 3. 결함 현황 (round-13 — 양면 표기)

### [PRC-006] 코팅 정책 분산 (family별 공정/자재 불일치)  {🔴 미결}
- 내용: round-13 결함축 A·Q9. **코팅이 일부 family는 공정(책자 등 50상품)·일부는 자재(스티커/포토북 16+8상품)로 분산** 적재. **통일 미결(BATCH-3 컨펌 대기)**. 위키는 family별 현재 분류를 그대로 쓰되 "통일 미결" 양면 표기한다 — 어느 쪽이 정답인지 단정 금지.
- 앵커: `t_proc_processes`(공정) vs `t_mat_materials`(자재) — 코팅 적재 타깃 충돌
- 출처: `17_correctness/<family>/correction-manifest.md` + `_crosscut/crosscut-synthesis.md` 추가-A·Q9 {tier C(round-13), FRESH}
- 연결: [[materials#MAT-005]] · [[#PRC-GAP-1]]
- 사용처: [[recipes/sticker#STK-ST-001]] (코팅 자재 오적재 8상품·CONFLICT) · [[recipes/booklet#BK-BOM-002]] (책자=코팅 공정 측 기준점)
- tags: #결함 #코팅 #CONFLICT #BATCH-3 #미결

### [PRC-007] 아크릴 print_side에 UV 오적재 (20상품)  {🔴 교정대기}
- 내용: round-13 acrylic F-AC-G2. **라이브 현재값: 20상품의 `print_side`에 UV 변형이 오적재 → 정답: UV는 공정 `PROC_000002`**. print_side(인쇄면)는 UV 공정을 담는 슬롯이 아니다. 라이브값 인용 시 correction-manifest 대조.
- 앵커: `t_prd_product_processes`(UV → PROC_000002) vs print_side 오적재
- 출처: `17_correctness/acrylic/correction-manifest.md` (F-AC-G2) {tier C(round-13), FRESH}
- 연결: [[#PRC-005]] (UV 정답) · [[materials#MAT-005]] (오적재 동형)
- 사용처: _(레시피 집필 시 채움)_
- tags: #결함 #UV #print_side #아크릴 #교정대기

### [PRC-008] 미싱제본 MISSING (문구)  {🔴 교정대기}
- 내용: round-13 stationery. **라이브 현재값: 미싱제본 공정 MISSING → 정답: 신규 공정 신설**(실무진 확정 [PRC-005]). (030/074는 제본 family가 아니므로 제외 — 정체 확인 후 신설.)
- 앵커: `t_proc_processes`(미싱제본 — 미신설)
- 출처: `17_correctness/stationery/correction-manifest.md` + 메모리 round-11(미싱제본 신규) {tier C(round-13), FRESH}
- 연결: [[#PRC-GAP-2]] · [[../base/binding#BBD-003]] (uses — 제본 방식 보편 정의)
- 사용처: _(레시피 집필 시 채움)_
- tags: #결함 #미싱제본 #MISSING #문구

---

## 4. GAP (미모델링·미결)

### [PRC-GAP-1] 코팅=공정 통일 여부 미결 (BATCH-3)  {🔴}
- 내용: [PRC-006] 통일 결정 미결.
- 출처: `_curation/axis-processes.md` GAP-PROC-1 · `_crosscut/` BATCH-3 {tier C}
- 연결: [[#PRC-006]]
- tags: #GAP #코팅 #BATCH-3

### [PRC-GAP-2] 신규 공정 신설 미결 (미싱제본·보드마운팅·삼각대거치)  {🔴}
- 내용: BATCH-13 — 신규 공정 신설 결정 미결.
- 출처: `_curation/axis-processes.md` GAP-PROC-2 · `_crosscut/` BATCH-13 {tier C}
- 연결: [[#PRC-008]]
- tags: #GAP #신규공정 #BATCH-13

### [PRC-GAP-3] 박 부모 PROC_000033 미연결 vs 박색 8자식 옵션풀  {🔴}
- 내용: digital-print C-06 AMBIGUOUS — 박(있음) 부모 PROC_000033이 박색 8자식 옵션풀과 미연결.
- 출처: `_curation/axis-processes.md` GAP-PROC-3 {tier C}
- 연결: [[#PRC-005]] · [[cpq-options#CPQ-002]]
- 사용처: [[recipes/digital-print#DGP-BM-004]] (박 부모 PROC_000033 vs 박색 8자식 — 상품권 042)
- tags: #GAP #박 #옵션풀

### [PRC-GAP-5] 공정택일그룹 라이브 DB 구조 부재 (excl_groups 삭제)  {🔴}
- 내용: [W3 라이브 실측] `t_prd_product_process_excl_groups` 테이블 **라이브 부존재**(06-04 ref-csv 존재 → 이후 삭제). 인쇄방식별 택일 레시피([PRC-002])를 담을 전용 구조 없음 — 현 라이브는 `mand_proc_yn` 스칼라뿐. 택일그룹이 정답 모델이면 신규 엔티티(ddl-proposer) 또는 `constraints.logic`(JSONLogic 배타)로 대체 표현 필요. **결정 미결**: 전용 테이블 재신설 vs constraints 흡수.
- 출처: 라이브 psql `information_schema`(0행) + `00_schema/ref-product-process-excl-groups.csv`(과거 ref, STALE) {tier A}
- 연결: [[#PRC-002]] · [[cpq-options#CPQ-007]] (constraints.logic 대체경로 후보)
- tags: #GAP #택일그룹 #excl_groups삭제 #W3

### [PRC-GAP-4] dep_proc_cd 삭제 후 자재→공정 게이팅 대체경로  {🔴}
- 내용: impact-diagnosis I-6 — `dep_proc_cd` 삭제로 자재→공정 게이팅 무효, 대체경로 미확정. **`extraction-plan.md` L56 oracle dep_proc_cd = STALE, 인용 금지.**
- 출처: `18_schema-change/impact-diagnosis.md` I-6 {tier A, FRESH}
- 연결: [[materials#MAT-GAP-3]] · [[load-path#LP-006]]
- tags: #GAP #dep_proc_cd #STALE #I-6

---

## Sources
- 큐레이션 팩: `_curation/axis-processes.md`
- 정답: `00_schema/ref-processes.csv`·`ref-product-processes.csv`; `07_domain/process-recipe-tree.md`·`pdf-domain-knowledge.md`; `15_domain-spec/<family>/product-bom.md`·`column-dictionary.md`·`domain-research-notes.md`(Q1~Q15); `15_domain-spec/digital-print/domain-research-notes.md`·`acrylic/`; `17_correctness/<family>/correction-manifest.md`·`_crosscut/crosscut-synthesis.md`.
- freshness: `18_schema-change/impact-diagnosis.md` I-6.
- 메모리: `dbmap-process-select-group-domain`·`dbmap-option-material-process-bundle`·`dbmap-column-domain-loadspec-round11`·`dbmap-correctness-audit-round13`.
- stale(인용 금지): `17_correctness/digital-print/extraction-plan.md` L56(oracle dep_proc_cd, I-6); `00_schema/ref-product-process-excl-groups.csv`(excl_groups 테이블 라이브 삭제 — W3); 별색 008~012 vs PROC_000007 정리물 내부 불일치(round-12); 라이브 공정값 직접 인용(correction-manifest 미대조 시).
