# round-24 카테고리 맵 보정본 재게이트 — verdict v2 (dbm-validator)

**검증자**: dbm-validator (생성자≠검증자). **방식**: 라이브 read-only 직접 재실측(SELECT only, NEVER COMMIT) + 적재본 CSV 결정적 재집계.
**일시**: 2026-06-18. **대상**: round-24 보정본(`product-cat.csv`·`release-status.csv`·06/07). **직전**: `round24-verdict.md` (NO-GO CONDITIONAL, BLOCKER 2종).

## 종합 판정: **GO**

직전 NO-GO의 BLOCKER 2종(D-1 junction PK 충돌 8쌍·D-2 del='Y' 노드 귀속 1건)과 MAJOR 2종(D-3 phantom 4건·D-4 false-negative 5건)이 **전부 보정 적용 실측 확인**. V2/V3/V4 전부 PASS로 격상. 회귀(V1/V5/V6) 0. 데이터 골격 건전 유지(날조·신규 mint·FK 고아 0). 잔존 결함 없음 — 컨펌 큐 항목은 인간 판단 대상이며 게이트 차단 아님.

| 게이트 | 직전 | 재판정 | 한줄 근거 |
|--------|------|--------|-----------|
| V1 매칭 실재성 | PASS | **PASS** | load 230 distinct prd_cd 전건 라이브 t_prd_products(del='N') 실재·차집합 0 |
| V2 출시상태 정확성 | CONDITIONAL | **PASS** | ✅36/🟡197/❌11 라이브 재집계 일치·PRD_000042 opt=22(실측)·✅ 격상 정당·phantom ❌ 확인 |
| V3 노드 매핑 정합 | **FAIL** | **PASS** | 전 27 target del_yn='N'·del='Y' target 0·CAT_000066 사용 0·PRD_000050→CAT_000003 |
| V4 다중분류·main 무결성 | **FAIL** | **PASS** | (prd_cd,cat_cd) PK 충돌 0·prd_cd당 main='Y' 정확히 1(예외 0·무 main 0)·별칭 18 |
| V5 search-before-mint | PASS | **PASS** | 신규 노드 0·CREATE/ALTER/INSERT t_cat 파일 0·전 target+reserve 노드 라이브 실재 |
| V6 생성-검증 독립성 | CONDITIONAL | **PASS** | 보정 카운트 라이브 재실측 일치·재집계 byte 재현·본 검증서 자체가 독립 재실측 |

---

## V3 재실측 — PASS (직전 FAIL 해소)

라이브 직접 SELECT(`t_cat_categories`):
- **전 27 target cat_cd del_yn='N'(활성)** — del='Y' target **0건**. 27/27 라이브 실재(MISSING 0).
- **CAT_000066(봉투제작) = del_yn='Y'** 라이브 확인 → 적재본 load 행에서 **사용 0건**(D-2 가드 적용).
- **PRD_000050(봉투제작, del='N')의 target = CAT_000003**(인쇄홍보물 L1 직속), main_cat_yn='Y'. 요구사항대로 정확.
- 포토북 L3 reserve 노드 CAT_000109/110/111 = 전부 del_yn='N' 활성(reserve 행 FK 잠재 고아 0).

→ del='Y' 귀속 0 확인. V3 FAIL 완전 해소.

## V4 재실측 — PASS (직전 FAIL 해소)

`product-cat.csv` 결정적 재집계(load 행=prd_cd 비공백 248행):
- **(prd_cd,cat_cd) PK 중복 0건** — 직전 8쌍(캘린더 3·substring 4·alias 1) 전부 dedupe 확인.
- **prd_cd당 main_cat_yn='Y' 정확히 1행** — 위반 0·main 없는 prd_cd 0.
- 별칭(main='N') **18행**·multi_class='Y' 18 일치(직전 19→18 dedupe 적용, PRD_000157 1행만).
- **phantom 4건 매핑 제거 확인**: 골드실버아크릴명찰·아이스머그컵·LED키캡키링·우치와키링 = load 행에 **0건**(전부 prd_cd 공백 RED 노드예약으로만 존재). 유사 실존상품(아크릴명찰 PRD_000152·머그컵 PRD_000193·키캡키링 PRD_000202·미니우치와키링 PRD_000227)과 별개 보존 확인 — 실존상품 오염 0.

→ PK 충돌 0·main 단일성 0위반·phantom 제거. V4 FAIL 완전 해소.

## V2 재실측 — PASS (직전 CONDITIONAL 해소)

- `release-status.csv` 라이브 재집계: ✅정상등록가능 **36**·🟡신규출시 **197**·❌미출시 **11** — 생성자 주장 정확히 일치.
- **PRD_000042**(프리미엄 쿠폰/상품권, del='N') 라이브 실측: **active option_items 22건** + priced(전역 가격엔진 사슬) → opt>0 AND priced = **✅ 등급 정당**. ❌→✅ 격상 정확.
- 전역 opt>0 distinct prd_cd = **36** ⇄ ✅ 36 정합(✅ 정의 = opt>0 AND priced).
- phantom 4건 = release-status에서 ❌미출시(라이브 부재) 확인.
- product-cat.csv body YELLOW 194 = release 197 − 캘린더 동일셀 3행 dedupe로 정합 재구성(reconcile 일치).

→ false-negative 5건 재분류 적용(PRD_000042 ✅·나머지 4 🟡). V2 CONDITIONAL 해소.

## V1/V5/V6 회귀 — PASS (신규 결함 유입 0)

- **V1**: load 230 distinct prd_cd 전건 라이브 `t_prd_products`(del='N') 실재·차집합 0·미존재 0. 날조 0.
- **V5**: 신규 노드 mint 0·DDL(CREATE/ALTER/INSERT t_cat) 파일 0·전 target+reserve 노드 라이브 실재(FK 고아 0). 보정으로 신규 그릇 유입 없음.
- **V6**: 보정 카운트(활성 66·✅36·🟡197·❌11·별칭18) 라이브/CSV 재집계 일치(직전 stale 카운트 정정 반영). 본 재게이트 자체가 생성자 자가 게이트와 독립한 라이브 직접 재실측·결정적 재집계로 수행됨.

---

## 결론

직전 verdict의 5개 보정 권고(D-1~D-5)가 **전부 실측으로 적용 확인**:
- D-1 PK dedupe → 충돌 0 (V4)
- D-2 del='Y' 가드 → CAT_000066 사용 0·PRD_000050→CAT_000003 (V3)
- D-3 phantom 4건 철회 → load 매핑 0·실존상품 오염 0 (V4)
- D-4 ❌→재분류 → PRD_000042 ✅(opt22 실측)·4건 🟡 (V2)
- D-5 카운트 정정 → 라이브 재실측 일치 (V6)

**잔존 게이트 차단 결함: 없음.** 컨펌 큐(Q-1 L1직속 vs 노드부활·Q-3 포토북 바인딩·Q-4 신규상품 정의·Q-5 IA 노출)는 인간 판단 영역이며 적재 가능성을 차단하지 않음.

**최종: GO** — junction 적재본 248행(본체 230 + 별칭 18) 적재 가능. 실 COMMIT은 인간 승인 후 `dbm-load-execution` 위임(현 트랙 DB 미적재 유지).
