# remediation-spec-booklet-museon-pur-069-070.md — 069/070 교정 명세 + 적재 큐

> 검증자: hsp-set-gate 2026-07-01 · 라이브 읽기전용 재실측 · DB 미적재(실 COMMIT 인간 승인 후 load-executor/dbmap).
> 게이트 판정: 069·070 둘 다 ✅ GO. 결함 0 — 본 명세는 **적재 큐 + 선택/이월 항목**(068보다 단순·t_prd_* 단일 트랙).

---

## 1. 적재 GO 큐 (→ hsp-load-executor·인간 승인 후 COMMIT)

신규 공식 0·신규 comp 0 → **t_prd_* 단일 트랙**(t_prc_* 신규 COMMIT 불요).

| # | 셋트 | 적재본 | 대상 t_* | 위상 | 골든 | 인간 승인 |
|---|------|--------|----------|------|:----:|:--------:|
| 1 | **069 무선** | `booklet-museon-069-load.sql` | products(289/290)·sizes·print_options·materials·plate_sizes·processes·price_formulas(289→INNER·290→COVER·069→BIND_MUSEON NO-OP)·sets(2행) | 1~8 | 138,688 | 필요 |
| 2 | **070 PUR** | `booklet-pur-070-load.sql` | products(291/292)·차원 동형·price_formulas(291→INNER·292→COVER·070→BIND_PUR NO-OP)·sets(2행) | 1~8 | 288,688 | 필요 |

- **PART A (PRF_BOOK_COVER + formula_components)** = ON CONFLICT 멱등 NO-OP(라이브 실재) — COMMIT 무영향·실행해도 delta 0(DRY-RUN 실증).
- **적재 순서**: 069·070 독립(070 채번 291/292는 069의 290 후행 전제 → 단일 트랜잭션이면 069→070 순). 둘 다 같은 트랜잭션 또는 069 COMMIT 후 070.
- **사후 재실측(load-executor)**: 셋트행 069=2/070=2·반제품 289-292 FK 고아 0·evaluate_set_price 069=138,688/070=288,688 무손상.

---

## 2. 결함 명세 — 없음 (GO·결함 0)

068 게이트가 적발한 결함(표지공식 미적재 BLOCKED ②트랙)이 069/070에는 **없음** — PRF_BOOK_COVER가 068 COMMIT으로 이미 라이브. 069/070은 그 전파분이라 신규 결함 0.

검사한 잠재 결함 항목(전부 부재 확인):
- S8 공유공식 오염(PRF_BOOK_COVER silent 적용) → **없음**(각 표지 member 전용).
- S8 제본 혼선(현황판 B-4·중철 comp가 무선/PUR에 샘) → **없음**(MUSEON 019·PUR 020 각 단일 proc_cd·고유 comp).
- 판형 저청구(pansu≠1) → **없음**(fn_calc_pansu(499,174)=1).
- 이중합산 → **없음**(비목 단일귀속).
- 진성 가격공식 부재 → **없음**(4 공식 전부 라이브 실재·계산공식집 booklet seq63 정합).

---

## 3. 선택/이월 항목 (적재 GO와 별개·BLOCKED 아님)

| ID | 대상 | 결함 정도 | 권위 정답 | 교정 방법 | 대상 t_* | 돈 영향 | 라우팅 | 인간 승인 |
|----|------|----------|-----------|-----------|----------|---------|--------|:--------:|
| **BLOCKED-MAT070-LINK** | 070 완제품(PRD_000070) 자재 link 0행 | Low(견적 미관여) | 069는 완제품 USAGE.01 표지7+USAGE.02 내지6 보유·070 0행 | member(291/292)에 069 권위 verbatim 충전 완료(견적 정확). 완제품 link 보강은 운영자 노출용 | t_prd_product_materials(PRD_000070) | 없음(member 자재로 88,688/내지 정확) | dbmap(선택·견적 무영향) | 선택 |
| **C-TRACK-ENGINE-DBLPANSU** | 내지289/291 이중÷pansu | Med(내지비 과소) | price_views.py:1707 1회 정상 | 엔진 코드 1회 교정(전 책자 공통 068/069/070/072/077/082 동시 해소) | (webadmin 코드) | 내지비 환산 오차·표지/제본 무영향 | 개발팀 C트랙 | 개발팀 |
| **NA-FOIL-VARIANT** | PRF_BIND_MUSEON_FOIL·PRF_BIND_PUR_FOIL | NA | 박 후가공 옵션(별 공식·박 미선택 기본가) | 건드리지 않음(박 comp가 기본 PRF_BIND_MUSEON/PUR에 silent 합산 0 확인) | — | 없음(본체 골든 무영향) | 박류 §18 별 트랙 | NA |
| **NA-COVERMULT-X2** | 069/070 cover_mult ×2 | NA | 둘 다 책등 있음=펼침 cover_mult=1 | 해당없음(×배수 자체 없음·×1 정확) | — | 없음 | — | NA |

★ **C-TRACK-ENGINE-DBLPANSU·NA-FOIL-VARIANT는 068 게이트에서 이미 이월된 항목** — 069/070에 동형 재확인(신규 아님).

---

## 4. 종합

- **069 무선 = GO** (138,688 도달·오차 0).
- **070 PUR = GO** (288,688 도달·오차 0).
- 실 COMMIT 가능분 = **t_prd_* 단일 트랙**(셋트행+반제품+차원·신규 공식 0).
- BLOCKED분 = 없음. 선택(070 완제품 link)·이월(DBLPANSU C트랙)만.
- 인간 승인 → hsp-load-executor 적재(069·070).
