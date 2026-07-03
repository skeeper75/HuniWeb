# 결함 보드 — 문구 셋트(SB-1) 축2: 그래프 무결성 + 연결 완전성

> **검증가:** okb-adversarial-verifier (Phase 4·생성≠검증) · 2026-07-03
> **범위:** 문구 셋트(SB-1) 신규 노드 — 부모 9(172~181) + 구성원 16(293~308) + 공유축(공식9·구성요소9·GAP4) + 축(category/size/plate/qty).
> **방법:** `build_graph.py` 재빌드 2회(멱등 실측)·라이브 live-snapshot awk 대조·edges.jsonl/nodes.jsonl 기계 대조. 생성자 주장 비신뢰.

## 판정 요약

| 검사 | 결과 | 증거 |
|------|------|------|
| 재빌드 멱등 | PASS | nodes.jsonl/edges.jsonl shasum 재빌드 전후 동일(`fbce2ec0…`/`492552d7…`)·내부해시 `a7e00afb…`/`ac0744b9…` 2회 동일 |
| 하드 결함 0 | PASS | `nodes=1202 edges=3706 hard=0 soft=547` |
| I-1 고아(하드유형) | PASS | build-report L54 = 0 |
| I-2 끊긴 링크 | PASS | build-report L55 = 0 |
| member_of 엣지 0 | PASS | edges rel 집계에 `member_of` 부재(has_member 방향만 사용) |
| 폐쇄 어휘 19종 밖 0 | PASS | 사용 rel 17종 전부 R-table 19종 내(has_addon/supersedes 미사용은 정상) |
| has_member 카디널리티 | PASS | 16 엣지(부모 9→구성원 16)·전부 실재 타깃 resolve |
| **O5 구성원 가격사슬** | PASS | 293~308 전 16 구성원 `derived_from`→부모, **priced_by 위조 0**·자체공식 `t_prd_product_price_formulas PRD_000xxx=0행` 라이브 재실측 명기 |
| empty-shell 정직 | PASS | 295/297 면지·302/304/306/308 무지내지 전부 `0행/empty-shell` + 무가격(기여0) 명기 |
| candidate 정합 | PASS | 부모 9 전부 `badge=candidate`·근거 sparse 실재. 179 메모패드만 2셀(live `COMP_STN_MEMOPAD`=2·나머지 8개=1) awk 대조 일치 |
| index.md 25 등재·dead-link 0 | PASS(주의) | 25 엔트리·모든 링크 실파일 존재(내부 정합). 단 아래 D-1로 4엔트리가 오슬러그 |
| 축 노드(category/size/plate/qty) 정합 | PASS | category-CAT_000321 실재(11상품)·size/plate/qty 타깃 dangling 0 |
| 177 분류 conflict 양면 | PASS | `gap-stn-177-classification` 참조·current PRD_TYPE.02/authority 셋트 완제품 정직 표기 |
| gap-stn-* 참조성 | PASS | 4 gap 노드(177-classification·member-optgroup-ui·muji-inner-minmax·sparse-grid) 전부 referenced(orphan 0) |

---

## D-1 [Medium] 구성원 4개(305/306/307/308) slug이 **부모 prd_cd**를 씀 — slug 정본[HARD] 위반

- **노드:** `product-179-memo-pad-cover`(anchor PRD_000305)·`product-179-memo-pad-inner`(anchor PRD_000306)·`product-181-jungcheol-note-cover`(anchor PRD_000307)·`product-181-jungcheol-note-inner`(anchor PRD_000308)
- **유형:** slug/id 무결성 — id-NNN(부모)이 anchor prd_cd(자기 305~308)와 불일치.
- **증거(재현):**
  - `grep -n 'anchor:' 03_kb/product/product-179-memo-pad-cover.md` → `t_prd_products/PRD_000305`인데 파일명·`# 헤딩`·node id는 `product-179-memo-pad-cover`.
  - 그래프 확인: `product-305/306/307/308` id **전무**(`NONE — defect confirmed`), 대신 부모 접두 slug 4개 존재.
  - 정본 규칙 위반: pack §1 "slug 정본 = product-NNN-kebab[HARD]·구성원 = `product-NNN-<부모>-<역할>`"에서 **NNN=구성원 자기 prd_cd**. pack §1.1 명시 slug 리스트 = `305/306=product-305/306-memo-pad-{cover,inner}`·`307/308=product-307/308-jungcheol-note-{cover,inner}`.
  - **비대칭 증거:** 동일 계열 다른 12 구성원(293~304)은 **자기 prd_cd**로 정확히 명명(예 `product-300-monthly-planner-inner` anchor PRD_000300, `product-302-spring-note-inner` anchor PRD_000302). 오직 179/181 계열 4개만 부모 prd_cd 사용.
- **영향:**
  - prd_cd→slug 주소성 파손: PRD_000305~308을 slug로 조회하면 노드 없음(305~308 부재). "179" 접두는 부모+구성원 2개가 공유(다른 셋트는 각 구성원이 고유 NNN).
  - 노드 id가 자기 prd_cd를 거짓 표기(id=179, anchor=305). 질의게이트가 구성원 상품코드를 반환할 때 부모번호로 오지시.
  - **그래프는 안 깨짐**: 파일명==id 자기정합이라 I-2 끊긴 링크 0·has_member/derived_from 엣지 정상 resolve·index 링크 실파일 존재. 그래서 High 아님(가격/그래프 무손상).
- **원인:** 구축가가 179/181 계열 구성원 slug을 부모 prd_cd 기준으로 생성(293~304 계열과 규칙 불일치). 빌드 lint에 **id-NNN == anchor prd_cd-NNN** 검사 부재(L-18은 부모정합만·L-1은 파일명==id만) → 통과.
- **교정안:**
  1. 4 파일·node id·`#` 헤딩을 정본 slug로 개명: `product-179-memo-pad-cover`→`product-305-memo-pad-cover`, `-inner`→`product-306-memo-pad-inner`, `product-181-jungcheol-note-cover`→`product-307-jungcheol-note-cover`, `-inner`→`product-308-jungcheol-note-inner`.
  2. 참조 갱신: 부모 179/181의 `has_member` 타깃, 각 구성원 `derived_from` src, index.md L181/L182 링크(총 8 참조).
  3. **lint 보강(권장):** `build_graph.py`에 "product 노드 id의 NNN == anchor prd_cd 숫자" 검사 신설(이 계열 결함이 재빌드에서 조용히 통과했으므로).
- **라우팅:** KB 구축가(okb-knowledge-builder) 재작성 — 원천 데이터 결함 아님(격리 아님). 재빌드 후 재검증.

---

## 격리(원천 결함·KB 책임 밖)

- **sparse grid**(9 공식 단가행 1~2셀)·**면지/무지내지 empty-shell**(자재·공정 0행)·**177 prd_typ .02 conflict** = 전부 라이브 원천 상태이며 KB가 `gap-stn-*`·`derived_from`·양면 badge로 **정직 표기함**(결함 아님·정직 표기 임무 달성). 실 교정은 §23/§34/실무진 트랙.
