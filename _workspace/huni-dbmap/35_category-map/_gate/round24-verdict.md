# round-24 카테고리 맵 검증 — 독립 게이트 verdict (dbm-validator)

**검증자**: dbm-validator (생성자≠검증자). **방식**: 라이브 read-only 직접 재실측(SELECT only, NEVER COMMIT).
**일시**: 2026-06-18. **대상**: `_workspace/huni-dbmap/35_category-map/` 1단계+2단계 전 산출.

## 종합 판정: **NO-GO (CONDITIONAL — 보정 후 재게이트)**

핵심: 데이터 골격(노드 1:1·prd_cd 실재·신규 mint 0)은 건전하나, **적재본 product-cat.csv에 load-bearing 결함 2종**(V3 del='Y' 노드 귀속 1건·V4 junction PK 충돌 8쌍)이 존재해 현 상태로는 적재 불가. 추가로 생성자 카운트 3건이 라이브 재실측과 불일치(V6). 결함이 모두 보정 가능하고 생성자가 일부를 정직하게 컨펌 큐로 노출했으므로 NO-GO이되 보정 후 GO 가능.

| 게이트 | 판정 | 한줄 근거 |
|--------|------|-----------|
| V1 매칭 실재성 | **PASS** | csv 225 prd_cd 전건 라이브 실재·날조 0·명명변형 5건 실측 확인 |
| V2 출시상태 정확성 | **CONDITIONAL** | ✅35/🟡197/❌12 카운트·핵심 36/76/36 일치·샘플 정합. 단 ❌ 12 중 5는 실존 false-negative(생성자 정직 노출) |
| V3 노드 매핑 정합 | **FAIL** | L1 12 1:1 OK·포토북 L3 OK. 그러나 **CAT_000066(봉투제작)=del='Y'를 활성 target으로 사용**(PRD_000050) |
| V4 다중분류·main_cat_yn 무결성 | **FAIL** | **junction PK (prd_cd,cat_cd) 충돌 8쌍**(중복행). prd_cd 재사용·중복채번 0은 OK |
| V5 search-before-mint | **PASS** | 신규 노드 0·DDL/mint 제안 파일 0·전 target 노드 라이브 실재 |
| V6 생성-검증 독립성 | **CONDITIONAL** | 결함 ≥3 발굴. 단 생성자 카운트 3건 과대/과소(212·274·67) 라이브 재실측 불일치 |

---

## V1 매칭 실재성 — PASS

- product-cat.csv 비어있지 않은 prd_cd **225 distinct → 라이브 t_prd_products 225 전건 실재**(comm 차집합 0, 날조 0).
- 명명변형 5건 직접 SELECT 재확인(전부 del_yn='N' 실존):
  - PRD_000042 `프리미엄 쿠폰/상품권` · PRD_000131 `프레임리스우드액자` · PRD_000144 `미니보드스탠딩` · PRD_000191 `린넨패브릭코스터` · PRD_000196 `레더여권케이스`.
- 생성자 명명변형 컬럼(어순/우드삽입/오타) 주장 = 라이브 실명과 일치.

## V2 출시상태 정확성 — CONDITIONAL

- 라이브 재집계: option_items>0 **36** · priced 사슬 **76** · 둘다 **36**. → 생성자 §02 §03 수치 **정확히 일치**.
- release-status.csv 상태 분포: ✅35 · 🟡197 · ❌12 (생성자 주장과 일치).
- 샘플 10건 재판정 모두 분류 로직과 정합:
  - ✅: PRD_000016(opt41/priced)·031(opt30/priced)·136(opt4/priced)·052(opt7/priced) 정확.
  - 🟡: PRD_000146(opt0/priced=Y)·131(opt0/priced=Y)·144(opt0/priced=Y)·191(opt0/priced=0)·196(opt0/priced=0) 정확.
- **CONDITIONAL 사유 (false-negative)**: ❌ 12건 중 5건은 라이브 실존 상품의 명명변형으로, "데이터시트 0 AND 라이브 0"이 사실과 다름. 특히 **PRD_000042 프리미엄쿠폰/상품권은 라이브 opt=22 + priced=Y → ✅ 등록가능 등급**인데 ❌로 분류됨. 이는 substring 매칭이 어순변형을 못 잡은 결과. **생성자가 §03 §04 Q-2에서 정직하게 false-negative로 노출하고 alias 재분류 권고**했으므로 은폐 아님 → FAIL이 아닌 CONDITIONAL. 보정 시 5건 재분류(4건 🟡·PRD_000042는 ✅).

## V3 노드 매핑 정합 — FAIL

- L1: MAP 12 1차 = 라이브 L1 활성 12(CAT_000001~012) **1:1 정합**·cat_nm 일치(CAT_000001=엽서/카드 등). PASS 요소.
- 포토북 L3 CAT_000109/110/111 = 라이브 활성 실재(upr=CAT_000108·del='N')·생성자 §05 컨펌 해소 주장 정확.
- **결함**: product-cat.csv가 사용한 전 target cat_cd 31종 중 **CAT_000066 `봉투제작`이 del_yn='Y'(논리삭제)**인데 PRD_000050(봉투제작)의 matched_node로 지정됨.
  - 생성자 §07 3.2 규칙("del_yn='Y' 노드에 귀속 금지·조회 차단")을 **자기 산출이 위반**.
  - 생성자 §05가 봉투제작을 "활성 L3(11)"로 오분류 → 이 때문에 L3 활성 수를 11로 과대보고(실제 10). 근본 원인 동일.
- 다행히 L1 fallback(CAT_000003 인쇄홍보물)이 유효하므로 보정 가능(matched_node→NULL, L1직속 귀속). 하지만 as-shipped 적재 시 조회 차단 → FAIL.

## V4 다중분류·main_cat_yn 무결성 — FAIL

- 양호: 본체 244 + 별칭 19 = 263행. multi_class=Y 정확히 19. 중복 prd_cd는 전부 기존 prd_cd 재사용(중복 채번 0). prd_cd당 main='Y' 단일성은 라이브 junction에서 위반 0.
- **결함: junction PK (prd_cd, cat_cd) 충돌 8쌍**(같은 prd_cd→같은 cat_cd 2행). 적재 시 duplicate-key 실패:

| prd_cd | cat_cd | 원인 |
|--------|--------|------|
| PRD_000108 탁상형캘린더 | CAT_000007 | MAP 2셀(G3·G17) 중복·dedupe 누락 |
| PRD_000110 엽서캘린더 | CAT_000007 | 〃 |
| PRD_000111 벽걸이캘린더 | CAT_000007 | 〃 |
| PRD_000152 아크릴명찰 | CAT_000009 | **substring 과매칭**: 골드실버아크릴명찰(라이브 부재)이 아크릴명찰로 흡수 |
| PRD_000193 머그컵 | CAT_000010 | **substring 과매칭**: 아이스머그컵(부재)→머그컵 |
| PRD_000202 키캡키링 | CAT_000010 | **substring 과매칭**: LED키캡키링(부재)→키캡키링 |
| PRD_000227 미니우치와키링 | CAT_000010 | **substring 과매칭**: 우치와키링(부재)→미니우치와키링 |
| PRD_000157 아크릴네임택 | CAT_000010 | alias-dict 중복(J28·J40 둘 다 →PRD_000157·CAT_000010) |

- 라이브 실측: 골드실버아크릴명찰·아이스머그컵·LED키캡키링·우치와키링 = **t_prd_products 부재** → 이들은 ❌/Sheet-only로 가야 할 것이 partial 매칭으로 실존 상품에 잘못 병합됨(V6 dodge와 연동).

## V5 search-before-mint — PASS

- 신규 노드 mint **0건**·mint/DDL 제안 파일 부재.
- 전 target cat_cd 31종이 라이브 t_cat_categories에 실재(orphan FK 0). L1 12·L3 photobook 3 등 무손실 표현 확인.
- del='Y' 240여 노드 + 활성 66으로 모든 귀속 표현 가능 — 신규 그릇 불요 주장 정당.
  (주의: 표현은 가능하나 V3처럼 del='Y' 노드를 활성 target으로 쓰면 안 됨 — 부활 선행 필요.)

## V6 생성-검증 독립성 — CONDITIONAL

독립 재실측이 생성자 산출에서 **결함 ≥3 발굴**(V3 del='Y' target·V4 PK 충돌 8쌍·substring 과매칭 4건) → 독립성 입증. 단 생성자 카운트 3건이 라이브와 불일치:

| 생성자 주장 | 라이브 재실측 | 차이 |
|-------------|---------------|------|
| 활성 노드 67(12+44+11 L3) | **66**(12+44+**10** L3) | L3 +1 과대(봉투제작 오분류) |
| del='Y' 240 | **241** | -1 과소 |
| "212 L1직속 상품이 del='Y' 동명노드 보유" | 동명 매칭 **193** | ~19 과대 |
| junction "현재 274행 / 274 products" | **281행 / 273 distinct prd_cd** | +7 과소(스냅샷 drift) |
| 라이브 상품 275 | 275 (del='N') | 일치 |

- "212"는 재현 불가(라이브 동명 매칭 193). junction 274는 생성자 _live 스냅샷이 라이브보다 7행 적음(stale).
- 부수 확인: junction 281행 중 **119행이 del='Y' 카테고리 노드 참조**(round-22 ⑥ 미완 정리 잔재·메모리 [[del_yn]]와 정합) — 본 매핑 책임 아니나 환경 사실로 기록.

---

## 발견 결함 목록

| # | 게이트 | 심각도 | 결함 | 증거 |
|---|--------|--------|------|------|
| D-1 | V4 | BLOCKER | junction PK (prd_cd,cat_cd) 충돌 8쌍 | product-cat.csv 중복 (prd_cd,target) 8건 |
| D-2 | V3 | BLOCKER | del='Y' 노드 CAT_000066(봉투제작)을 PRD_000050 target으로 사용 | 라이브 del_yn='Y' |
| D-3 | V4/V6 | MAJOR | substring 과매칭 4건(골드실버아크릴명찰·아이스머그컵·LED키캡키링·우치와키링 = 라이브 부재인데 실존 상품에 흡수) | 라이브 t_prd_products 부재 |
| D-4 | V2 | MAJOR | ❌ 12 중 5는 실존 false-negative(PRD_000042는 ✅ 등급인데 ❌) | V1 5건 실재·PRD_000042 opt22/priced |
| D-5 | V6 | MINOR | 생성자 카운트 stale/오산(212·274·67 ≠ 193·281·66) | 라이브 재집계 |
| D-6 | 환경 | INFO | junction 119행이 del='Y' 노드 참조(round-22 ⑥ 미완) | 본 매핑 책임 외 |

## 보정 권고 (재게이트 조건)

1. **D-1**: product-cat.csv에서 (prd_cd,cat_cd) 중복 8행 dedupe. 캘린더 3쌍=동일 셀 중복 제거. alias 중복(PRD_000157)=1행만. 멱등 UPSERT라면 적재는 통과하나 **main_cat_yn 모호성** 제거 위해 소스 dedupe 필수.
2. **D-2**: PRD_000050 matched_node CAT_000066(del='Y')→ L1 CAT_000003 직속으로 변경, 또는 봉투제작 노드 부활(del='N') 컨펌 후 귀속. del='Y' 노드 귀속 0 재확인.
3. **D-3**: substring 매칭 4건 철회 → 골드실버아크릴명찰·아이스머그컵·LED키캡키링·우치와키링을 Sheet-only/❌ 또는 신규정의 큐로 이동(실존 상품 오염 제거). 매칭 규칙에 "partial 매칭은 라이브 prd_nm 1:1 검증 후만 승인" 가드 추가.
4. **D-4**: ❌ 5건 alias 재분류(4건→🟡·PRD_000042→✅). 카운트 ✅35→36·🟡197→201·❌12→7로 갱신.
5. **D-5**: 생성자 카운트(활성 66·del='Y' 241·동명 193·junction 281) 라이브값으로 정정. _live 스냅샷 재추출.

보정 후 V2/V3/V4 재실측 시 GO 가능. 데이터 날조·FK 고아·구조 파손은 없음(골격 건전).
