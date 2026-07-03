# 결함 보드 — 실사 그래프 무결성 + 동형결합 comp 단일성 (2026-07-03)

> 검증가: okb-adversarial-verifier · 대상: `03_kb/`(실사 28상품 PRD_000118~145) · 그래프 976노드/3060엣지 · 스키마 v1.0.1
> 원칙: 모든 노드는 틀렸다고 가정·직접 재실측(생성자 리포트·이전 결함보드 비신뢰). 기계 대조=스크립트.
> 재현 스크립트: `05_verification/scripts/silsa_anchor_ownership_260703.py` · build: `python3 04_graph/build_graph.py --idem`

## 축별 판정

| 축 | 검사 | 판정 | 근거(재실측) |
|----|------|------|-------------|
| ① 그래프 무결성·멱등·하드0 | build_graph 2회 직접 | **PASS** | 독립 2회 clean 실행 → nodes.jsonl/edges.jsonl/sqlite-dump **바이트 동일**(0315cfad…/b0cb4ee9…). hard=0·soft=428. 976n/3060e |
| ② 동형결합 comp 단일소유권·중복 anchor 0 | 앵커 소유권 전수 스캔 | **NO-GO** | component(COMP_POSTER_* 38)·category(CAT_000004/072/314/315) **전부 단일소유**(PASS). **그러나 size 축에서 실사 13 중복노드(6 앵커) 단일소유권 위반**(D-SILSA-INT-1) |
| ③ slug product-NNN·index dead-link 0 | L-1 + O4b 재스캔 | **PASS** | 실사 frontmatter 파일노드 28/28 id==파일명. index.md .md링크 162건 **dead 0**(이전 059 dead-link 해소됨)·실사 118~145 전원 index 등재 |
| ④ jsonl↔SQLite↔정본 | 집합 대조 | **PASS** | 노드 976=976·엣지 3060=3060·차집합 0(jsonl-only/sqlite-only 모두 0)·edges.jsonl 원시행 3060=distinct 3060(파일내 중복 0) |

**종합: 축 ①③④ PASS · 축 ② NO-GO(단일 FAIL=NO-GO). 최고 심각도 Medium(가격 영향 High 0).**
이전 보드 `defect-sticker-integrity`②·`defect-expand-integrity`②의 "중복 anchor 0·로컬 재선언 0" 주장은 **현 976노드 그래프에서 더 이상 성립하지 않음**(당시 466노드·6 명명노드 국한 스캔) — 실사 확장이 앵커 중복을 유입했다.

---

## 결함 상세

### D-SILSA-INT-1 [Medium·라우팅=builder+curator] 실사 size 축 단일소유권 위반 — 정본 노드 + 상품-로컬 재선언 공존

- **노드/엣지:** 실사 로컬 중복 size 노드 13개(6 앵커):
  - `t_siz_sizes/SIZ_000174` ×5: 정본 `size-SIZ_000174`(product-047 소유·has_size 백링크 15) + `size-126-SIZ_000174`·`size-127-…`·`size-128-…`·`size-132-…`
  - `SIZ_000197` ×4(정본 + 126/127/128) · `SIZ_000293` ×4(정본 + 126/127/128) · `SIZ_000172` ×2(+132) · `SIZ_000320` ×2(+139) · `SIZ_000322` ×2(+139)
- **축:** ② 동형결합 단일소유권 (빌더 로컬 재선언 dedup 실패)
- **증거(재현):** `silsa_anchor_ownership_260703.py` → master 테이블 동일타입 중복 앵커 13건(실사 6·비실사 7). 동일 live 마스터행 `SIZ_000174`(A3 297×420)를 5개 KB 노드가 각각 소유. product-126~128·132·139는 has_size를 **자기 로컬 노드**로 걸고, product-119/120/121/122/123/125(같은 실사 포스터)는 **정본 `size-SIZ_000174`를 재사용**. 로컬 노드의 anchor는 junction이 아닌 마스터(`t_siz_sizes/SIZ_000174`)·치수는 정본과 동일·유일 차이는 상품별 note("면적매트릭스 셀축 불일치→off-grid ceiling").
- **질의 영향(연결 완전성):** "SIZ_000174를 쓰는 상품" 질의를 정본 노드 백링크로 탐색하면 15상품 반환하나 **실사 126/127/128/132를 조용히 누락**(중복 노드에 좌초). 동형결합 계약(공유 축=단일 owner) 파손.
- **심각도 근거:** Medium — 공유 축 모델 파편화·질의 누락. **가격 영향 없음**(로컬 노드도 같은 마스터 앵커로 해석→면적매트릭스 가격사슬 무손상). 실사 내부 비일관(포스터 6개는 정본 재사용·4개는 재선언)이 "의도된 규약"이 아닌 **집필 드리프트**임을 반증.
- **교정안:** (a) [curator/authoring] 실사 126/127/128/132/139의 has_size를 정본 `size-SIZ_xxx`로 재지향·로컬 preset 노드 은퇴·상품별 note는 has_size 엣지 qualifier/note로 이동. (b) [builder] `build_graph.py`에 **master 테이블 동일타입 앵커 중복 lint**(같은 `t_*/CODE`를 2노드가 소유+동일 type = soft/hard 경고) 추가 — L-3(id 중복)이 못 잡는 앵커 중복 사각지대. 현 dedup은 id 기준뿐.

### D-SILSA-INT-2 [Low·라우팅=architect/builder] CPQ junction 앵커 조밀도 — prd-level 앵커가 자식행을 유일 식별 못 함

- **노드:** Category C 36건 중 실사 = `optgroup-118-*`(2)·`optgroup-129/133/134/135/136/137/138/139-*`·`plate-119-*`(3)·`constraint`(비실사). 예: `t_prd_product_option_groups/PRD_000118`을 optgroup-118-coating·optgroup-118-material 2노드가 소유.
- **축:** ② 앵커 피델리티(엔티티 중복 아님 — 자식행은 실제로 상이)
- **증거:** 스냅샷 헤더 `t_prd_product_option_groups` col0=`prd_cd`(PK는 opt_grp_cd)·`t_prd_product_sizes`/`t_prd_product_plate_sizes` col0=`prd_cd`. 빌더 L-17은 col0을 키로 실재 검사 → prd_cd로 검증은 통과하나 **여러 상이 자식행이 같은 조밀 앵커를 공유**. `plate-119-SIZ_000052/198/294` 3노드가 `t_prd_product_plate_sizes/PRD_000119` 공유.
- **심각도 근거:** Low — 노드는 진짜 서로 다른 엔티티(중복 아님)·질의/가격 무영향. 다만 앵커가 행을 유일 지목 못 해 실재 검사가 조밀. 
- **교정안:** [architect] junction 노드 앵커를 자식 복합키(예 `t_prd_product_option_groups/<opt_grp_cd>` 또는 `PRD_xxx#opt_grp_cd`)로 세분하는 스키마 규약 검토. 현 상태는 무해하나 앵커 정밀도 개선 여지.

### D-SILSA-INT-3 [Low·라우팅=builder] 이전 보드 "중복 anchor 0" 주장 stale — 그래프 전역 재측정 필요

- **증거:** master 동일타입 앵커 중복 = 실사 6 + 비실사 7(스티커 `MAT_000163/371/372`·`SIZ_000057/170/520/521`). `defect-expand-integrity`②는 466노드 시점 "중복 anchor 0" PASS, `defect-sticker-integrity`②는 6 명명노드 국한. 976노드 전수 스캔에서 동일 결함 클래스가 스티커에도 존재 → **single-ownership 위반은 실사 국한 아닌 systemic**(size/material 로컬 preset 재선언 패턴).
- **심각도 근거:** Low(문서/라우팅) — 실제 결함은 D-SILSA-INT-1과 동일 클래스. 
- **교정안:** [builder] D-SILSA-INT-1(b) lint를 그래프 전역 적용해 스티커 7건 동시 적발·회귀 방지.

---

## 적대적 패널이 기각한(=결함 아님) 후보

- **product ↔ qty (bundle_qty) 동일 앵커 50건** (`t_prd_products/PRD_xxx`를 product + qty 노드가 공유): **by-design**. bundle_qty 노드는 min/max/qty_incr 규칙을 서술하고 그 값은 product 마스터행에 실재 → cross-type·목적 상이·엔티티 중복 아님. 50상품 일관.
- **decision ↔ component 1건** (`COMP_PRINT_SPOT_WHITE_S1`을 DEC_spotwhite_260630 + component 노드가 공유): **by-design**. decision 노드가 결정 대상 엔티티를 앵커. 정당.
- **COMP_POSTER_* 38·CAT_000004/072/314/315**: 전부 단일소유 확인 — 동형결합 계약 준수(PASS).

---

## 검증 범위·한계 (정직 선언 — "무결" 단정 아님)

- **전수(스크립트):** 앵커 소유권(976노드 전수)·멱등(2회 바이트)·jsonl↔SQLite 집합·index dead-link(162링크)·실사 slug(28). 오차 0 기준 결정론.
- **표본/미검(축 배정 밖):** 축 ⑤ 연결완전성(가격사슬 종단)·출처 실재성·권위 260702 diff·질의 재현은 **본 라운드 미수행**(타 검증가/라운드 배정). soft 428건 개별 미분류(멱등·하드0에 무영향이나 내용 미판정).
- **D-SILSA-INT-1 가격 무영향 판정 근거:** 로컬 노드도 동일 마스터 앵커로 해석되어 면적매트릭스 사슬이 끊기지 않음 — 그러나 **라이브 evaluate_price 실호출로 재확증하지 않음**(축 배정 밖). 가격 회귀 여부는 축⑤/가격 라운드에서 별도 실측 권장.
- codex 독립 2차: 미가용(Claude 단독 판정 명시).
