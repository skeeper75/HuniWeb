# manifest-green2 — ✅격상 추가 카테고리 junction 적재본

round-24 2단계 · `dbm-category-mapper` · **DB 미적재**(적재본 생성까지·실 COMMIT은 검증 GO 후 별도 실행자).
입력 권위: `_reclassify/upgraded-green.csv`(출시상태 재분류 v2 격상분) + `product-cat.csv`(2단계 귀속 명세).
이미 적재됨(중복 금지): `08_load-green/product-cat-green.csv`(✅36).

## 0. ★카운트 정정 (착수 발견)

| 항목 | 값 | 근거 |
|------|---:|------|
| upgraded-green.csv 데이터 행 | **186** | 사용자 배경의 "186 격상"(라인 기준) |
| 그중 distinct prd_cd | **183** | PRD_000108·PRD_000110·PRD_000111 3건이 중복 등재(각 2행) |
| 본체 junction(main='Y') | **183** | distinct prd_cd당 1행(상품마스터 1상품=1본체) |
| 별칭 junction(main='N',ALIAS) | **17** | 183 상품 중 다중분류 노출분 |
| **총 junction 행** | **200** | 183 본체 + 17 별칭 |

> "186"은 재분류 라인 수, **실제 추가 적재 상품 = 183건**. 중복 3건은 동일 prd_cd라 junction PK(prd_cd,cat_cd)에서 자동 합쳐짐(과적재 없음).

## 1. 적재 행수

- **본체(main='Y') 183** + **별칭(main='N') 17** = **200 junction 행**.
- 08_load-green 36과 **중복 0**(빌더 검증 PASS, `upg_set ∩ g1_set = ∅`).

### 본체 타깃 cat_cd 분포(상위)
| cat_cd | cat_nm | 본체 수 |
|--------|--------|--------:|
| CAT_000011 | 에코백 | 49 |
| CAT_000010 | 라이프 | 34 |
| CAT_000008 | 문구 | 18 |
| CAT_000009 | 아크릴 | 15 |
| CAT_000002 | 스티커 | 12 |
| CAT_000012 | 포장 | 10 |
| CAT_000003 | 인쇄홍보물 | 9 |
| CAT_000004 | 포스터 | 9 |
| CAT_000001 | 엽서/카드 | 7 |
| CAT_000005 | 사인 | 5 |
| CAT_000006 | 책자 | 1 |
| (가변깊이 L2/L3 14노드) | — | 각 1 |

### 별칭(다중분류) 17행 — 본체는 별도 cat에 main='Y', 여기선 추가 노출(main='N')
07 캘린더 3(캘린더봉투·우드거치대·우드행거) · 10 라이프 7(아크릴 액세서리류) ·
03 인쇄홍보물 2(아크릴명찰·만년스탬프) · 08 문구 2(아크릴집게·아크릴볼펜) ·
12 포장 2(반칼원형·반칼띠지 스티커) · 01 엽서 1(말랑포카홀더). 전부 본체 prd_cd 재사용(중복상품 생성 0).

## 2. 가변계층(deeper) 귀속 — 14건 · 신규 노드 필요 0

| prd_cd | 상품명 | 타깃 cat_cd | 노드명 | 깊이 |
|--------|--------|-------------|--------|------|
| PRD_000072 | 하드커버책자 | CAT_000105 | 하드커버책자 | L3 |
| PRD_000077 | 레더하드커버책자 | CAT_000106 | 레더하드커버책자 | L3 |
| PRD_000082 | 하드커버링책자 | CAT_000107 | 하드커버링책자 | L3 |
| PRD_000108 | 탁상형캘린더 | CAT_000112 | 탁상형캘린더 | L2 |
| PRD_000109 | 미니탁상형캘린더 | CAT_000113 | 미니탁상형캘린더 | L2 |
| PRD_000110 | 엽서캘린더 | CAT_000114 | 엽서캘린더 | L2 |
| PRD_000111 | 벽걸이캘린더 | CAT_000115 | 벽걸이캘린더 | L2 |
| PRD_000112 | 와이드벽걸이캘린더 | CAT_000116 | 와이드벽걸이캘린더 | L3 |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | CAT_000273 | 동명 | L2 |
| PRD_000044 | 인쇄배경지(투명케이스타입) | CAT_000274 | 동명 | L2 |
| PRD_000045 | 인쇄헤더택 | CAT_000275 | 동명 | L2 |
| PRD_000046 | 라벨/택 | CAT_000284 | 동명 | L3 |
| PRD_000276 | 타이벡 에코백 | CAT_000263 | 타이벡에코백 | L2 |
| PRD_000279 | 메쉬 에코백 | CAT_000269 | 메쉬에코백 | L2 |

> **search-before-mint 결론: 신규 노드 0건.** 14 deeper 타깃 cat_cd 전부 product-cat.csv 2단계 명세에서
> 라이브 활성 노드(05 §5.1·§2 활성 L2/L3 66노드 내)로 이미 확정된 것. 05 §5 "상품군별 가변 계층 깊이"
> 철학 동일 적용(캘린더 variant·하드커버·인쇄배경지/헤더택/라벨택·타이벡/메쉬 에코백 동명 deeper 노드 재사용).
> 나머지 169 본체는 L1 직속(활성 깊은 노드 부재 — 자유형 스티커·만년다이어리·거울/코스터류·파우치/백류 등).
>
> ★검증 의뢰 항목: 14 deeper cat_cd 및 11 L1 cat_cd, 전 26 타깃 노드의 라이브 `del_yn='N'` 활성 여부는
> dbm-validator 독립 SELECT 재실측 대상(본 단계는 라이브 read-only 미수행·apply 가드1이 런타임 ABORT 보장).

## 3. 적재 산출물

| 파일 | 역할 |
|------|------|
| `product-cat-green2.csv` | 200 junction(본체183·별칭17) — 적재 원천 |
| `apply-green2.sql` | 멱등 UPSERT(ON CONFLICT (prd_cd,cat_cd) DO UPDATE) + 단일 트랜잭션 + del_yn='N' 가드 + main 단일성 사후가드 |
| `backup-green2.sql` | 영향 prd_cd 기존 junction 물리 백업(CREATE TABLE bak_prd_cat_green2_20260618 + undo 가이드) |
| `dryrun-green2.sql` | 롤백전용 DRY-RUN(DR-1~9: 활성/실재/before/delete/upsert/present/FK고아/main단일성) |
| `build_green2.py`·`gen_sql_green2.py` | 재현 빌더(결정적) |

## 4. FK 위상 / 적재 순서

1. **선행(레이어 A)**: t_cat_categories 노드 — 26 타깃 전부 **기존 활성 노드 재사용**(신규 mint 0) → 신규 적재 불요.
2. **본 적재(레이어 B)**: t_prd_product_categories junction (cat_cd FK·prd_cd FK 둘 다 선존재).
3. 순서: 가드1(노드 활성) → 가드2(상품 실재) → 재배선A(비활성노드 orphan 제거) → 재배선B(타 노드 main 강등) → UPSERT → main 단일성 사후가드 → COMMIT.

## 5. 멱등 가드 요약

- **PK 멱등**: `ON CONFLICT (prd_cd,cat_cd) DO UPDATE` — 2회 실행 시 신규 INSERT 0·UPDATE 200(upd_dt만 갱신).
- **가드1(노드 활성)**: 26 타깃 cat_cd 중 부재/`del_yn<>'N'` 하나라도 있으면 `RAISE EXCEPTION` → 전체 ROLLBACK.
- **가드2(상품 실재)**: 183 prd_cd 중 부재/비활성(`del_yn<>'N'`) 있으면 ABORT.
- **재배선A**: 영향 prd_cd가 비활성 노드를 가리키는 기존 junction 행 DELETE(del_yn 권위·orphan 정리).
- **재배선B**: 본체 대표 cat이 아닌 활성 노드의 기존 main='Y' 행을 main='N' 강등 → 본체 main 단일성 보장.
- **main 단일성 사후가드**: 183 본체 prd_cd 각각 main='Y' 정확히 1행이 아니면 ROLLBACK 권고.

## 6. 영향분석 / undo

- **신규 영향**: 200 junction 행 추가(또는 기존 동일 PK시 UPDATE). 183 상품이 카테고리 트리에 노출됨.
- **기존 귀속 변경**: 재배선A(비활성노드 참조행 삭제)·재배선B(main 강등)는 해당 상품의 기존 잘못된/중복 main 정리.
  실제 삭제·강등 건수는 dryrun DR-4/DR-3로 사전 계측(라이브 실측은 검증자/실행자).
- **undo**: `backup-green2.sql`의 스냅샷 테이블에서 영향 prd_cd 전 junction 복원 가능(2-step: DELETE 후 INSERT…SELECT).
- **롤백 안전**: apply는 단일 트랜잭션 — 어느 가드든 위반 시 전체 미반영.

## 7. 제외 범위 (본 적재 비대상)

- 🟦보류 11(NEEDS-DOMAIN)·❌11(미출시) — 적재 제외(release-status.csv 권위).
- RED placeholder(prd_cd 공란 10행, product-cat.csv 250~260행) — 본체 prd 미존재로 자동 제외.

## 8. 검증 의뢰 (dbm-validator)

생성자≠검증자. 경계면 교차검증 항목: ① 26 타깃 cat_cd 라이브 `del_yn='N'` 활성 실재 ② 183 prd_cd
`t_prd_products` del_yn='N' 실재 ③ 200 junction FK 무모순 ④ search-before-mint(신규 노드 0) ⑤ 본체 main 단일성
⑥ 08_load-green 36과 중복 0 ⑦ dryrun 2-pass 멱등(신규 INSERT 0).
