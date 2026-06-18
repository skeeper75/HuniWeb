# green-verdict.md — ✅GREEN 36 카테고리 적재본 독립 검증 (round-24 2단계)

검증자: dbm-validator (생성자 dbm-category-mapper와 독립) · 2026-06-18
방식: 라이브 read-only SELECT + BEGIN…ROLLBACK DRY-RUN(2-pass) 직접 재실측 · **COMMIT 0건**
권위: 라이브 t_prd_products·t_cat_categories·t_prd_product_categories(직접 실측) + release-status.csv·product-cat-green.csv

## 종합 판정: **GO** (R1~R6 전건 PASS)

| 게이트 | 판정 | 생성자 주장 | 검증자 재실측 | 일치 |
|--------|------|-------------|---------------|------|
| R1 적재대상 정확성 | **PASS** | ✅36 = 본체36·별칭0 | green.csv 36 ↔ release ✅36 정확 bijection·🟡/❌ 혼입0·라이브 del='N' 36/36 | ✓ |
| R2 타깃 노드 활성 | **PASS** | 13 cat_cd del='N' | 13/13 del_yn='N' AND use_yn='Y'·cat_nm 일치·del='Y' 타깃0 | ✓ |
| R3 멱등성 | **PASS** | 2회 delta 0 | 2-pass: PASS2 DELETE0·UPDATE0·INSERT(UPSERT)36 신규0·main위반0 | ✓ |
| R4 재배선 영향 정합 | **PASS** | DELETE26·UPDATE4 | DELETE26(전부 del='Y' 노드)·UPDATE4(활성노드 강등) 정확 일치 | ✓ |
| R5 라이브 DRY-RUN | **PASS** | 위반0·변경0 | DELETE26·UPDATE4·INSERT36·FK고아0·main위반0·전부ROLLBACK | ✓ |
| R6 생성-검증 독립성 | **PASS** | — | 카운트 전건 독립 재실측·order-of-ops dodge-hunt 통과 | ✓ |

## R1 — 적재대상 정확성 (PASS)
- release-status.csv 상태분포 재집계: **✅36 · ❌11 · 🟡197** (생성자 주장 일치).
- green.csv 36 prd_cd ↔ ✅ 라인 36 prd_cd = **정확 bijection**(comm -23/-13 양방향 차집합 0). 🟡/❌ 혼입 0·누락 0.
- 라이브 t_prd_products: 36/36 del_yn='N' 실재. prd_nm 스팟 5건 green.csv와 일치.

## R2 — 타깃 노드 활성 (PASS)
13 target cat_cd 전부 라이브 t_cat_categories **del_yn='N' AND use_yn='Y'**:
CAT_000001 엽서/카드·000002 스티커·000003 인쇄홍보물·000004 포스터·000005 사인·000006 책자·
000021 접지카드·000058 전단지/리플랫·000062 쿠폰/상품권·000072 패브릭포스터·000076 아트프린트·
000307 엽서·000308 엽서북. del='Y' 타깃 0. cat_nm 전건 green.csv 일치. **신규 mint 0 확인.**

## R3 — 멱등성 (PASS)
- ON CONFLICT 충돌키 (prd_cd,cat_cd) = 라이브 PK (prd_cd,cat_cd) **정확 일치**(information_schema 확인).
- 단일 BEGIN…ROLLBACK 내 apply 로직 **2회 실행**:
  - PASS1: DELETE 26 · UPDATE 4 · INSERT(27 신규+9 UPSERT)
  - **PASS2: DELETE 0 · UPDATE 0 · INSERT 신규 0**(36행 전부 DO UPDATE upd_dt만) → **2nd pass 행 delta 0**.
- 사후 main='Y' 단일성 위반 0. junction 36 prd 행: 39(pre) → 40(post) = 39−26+27 정합.

## R4 — 재배선 영향 정합 (PASS) ★핵심 안전성 판정

### DELETE 26 — **안전**
- 36 prd의 현재 junction 39행 중 **26행이 del_yn='Y' 노드를 가리킴**(독립 재실측 = 26, 정확 일치).
- 삭제 대상 노드 del_yn 분포: **Y×26 (활성 N = 0)** → **활성 노드 오삭제 0건**.
- 삭제 노드 = 과거 "상품당 전용 노드"(CAT_000027 포토카드·048~050 명함·063/064 쿠폰·067 아트프린트·
  069~071 방수포스터·074/075 패브릭·085~087 족자/캔버스·088~091/099 배너·100~103 책자·026 엽서북).
  round-22 ⑥에서 논리삭제됐으나 junction 바인딩 잔존 → del_yn 권위상 조회차단 orphan → 제거가 정합.

### UPDATE 4 — **안전 (main 단일성 보장용)**
- order-of-operations 검증: 원시 predicate(main='Y' AND cat<>target)는 30행이나, **DELETE A가 먼저
  del='Y' 26행을 제거**한 뒤 남는 활성노드 강등 대상은 정확히 **4행**:
  - PRD_000016/017/018: CAT_000001 엽서/카드(L1·활성) main='Y'→'N' (target CAT_000307 엽서 L2)
  - PRD_000047: CAT_000003 인쇄홍보물(L1·활성) main='Y'→'N' (target CAT_000058 전단지/리플랫 L2)
- 전부 가변깊이 L1→L2 대표 이동. 기존 L1 행은 main='N'으로 잔존(다중분류 노출 유지) → 트리 자연스러움.
- **활성 노드를 junction에서 삭제하지 않음**(UPDATE는 main 플래그만 변경, 행 보존).

### backup 완전성 — **PASS**
backup-green.sql WHERE = 동일 36 prd_cd → 영향 **39행 전수 캡처**(삭제 26 + 강등 4 + 잔존 포함). undo 가능.

## R5 — 라이브 DRY-RUN (PASS)
생성자 dryrun-green.sql verbatim 실행(BEGIN…ROLLBACK):
```
DELETE 26 · UPDATE 4 · INSERT 0 36
NOTICE: 적재대상행 36, 기존존재 9, 추정 INSERT 27, 추정 UPDATE 9
NOTICE: FK고아(cat) 0, FK고아(prd) 0, main단일성위반 0
ROLLBACK
```
**제약위반 0 · FK고아 0 · main_cat_yn 단일성 위반 0 · 실변경 0**(전부 롤백). 생성자 주장과 정확 일치.

## R6 — 생성-검증 독립성 (PASS)
- 생성자 카운트(DELETE26·UPDATE4·UPSERT36)를 라이브 직접 재실측으로 전건 재산출 — 전부 일치.
- **dodge-hunt 성과**: UPDATE 4의 정합은 단순 predicate(30행)로는 검증 불가 — DELETE→UPDATE
  순서 의존을 명시적으로 분해(del='Y' 26 선삭제 후 활성 4 잔존)해야 4가 도출됨을 입증. 생성자
  스크립트가 이 순서를 올바르게 구현(2A DELETE → 2B UPDATE)했음을 독립 확인.

## 재배선 DELETE 26 · UPDATE 4 안전성 종합
- **DELETE 26 = SAFE**: 전건 del_yn='Y' 논리삭제 노드 orphan 바인딩. 활성 노드 손실 0. 가격사슬 비참여(돈 크리티컬 아님). backup 전수 캡처로 가역.
- **UPDATE 4 = SAFE**: 활성 L1 노드 main='Y'→'N' 강등(행 보존)·가변깊이 L2 대표 이동의 단일성 보장. 다중분류 노출 유지.

## 잔존 위험 (LOW — GO 불방해)
1. **[운영 MINOR] backup 실행 형식**: backup-green.sql은 SELECT 형(스냅샷 테이블 CREATE는 주석 예시).
   실 COMMIT 전 실행자는 반드시 `CREATE TABLE bak_pc_green_<ts> AS SELECT …` 형으로 스냅샷을 물리
   보존해야 undo 가능(단순 SELECT는 화면 출력만). manifest §4도 이를 권장하나 강제 아님.
2. **[설계 LOW] 가변깊이 L2 대표 이동(엽서3·전단지1)**: 기존 L1 main='Y' 상품이 L2로 대표 이동.
   고객 사이트 트리/네비 노출 위치가 L1→L2로 바뀜(의도된 설계·사용자 확정1). 노출 위치 변경이
   허용됨을 COMMIT 승인 시 재확인 권장.
3. **[범위 OK] 🟡197·❌11 제외**: 본 적재 범위 외(사용자 확정2). 정합 — 적재본은 ✅36만.

## 결론
6 게이트 전건 PASS. 재배선(DELETE26·UPDATE4) 전건 안전(활성노드 손실0·가역). 멱등 실증·라이브
제약위반0. **GO** — 실 COMMIT 진행 가능(인간 최종 승인 + backup 스냅샷 물리 보존 전제).
