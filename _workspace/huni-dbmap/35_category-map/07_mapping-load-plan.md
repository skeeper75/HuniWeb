# 07 — 적재 계획 (FK 위상 + 상태별 우선순위 + 영향분석 + 컨펌 큐)

round-24 2단계 · dbm-category-mapper · **DB 미적재**. 실 COMMIT은 인간 승인 후 `dbm-load-execution` 위임.
**[round-24 검증 보정 반영]** D-1 dedupe·D-2 del='Y' 가드·D-3/D-4 재분류·D-5 라이브 재추출 카운트 정정.

## 0. 적재 대상 구조 (★ FK 경로 실측 · 재추출본)

상품↔카테고리 연결 경로는 **단 하나**: junction `t_prd_product_categories` ([[target-keys]]·`columns.csv` 실측).

```
t_cat_categories (cat_cd PK)  ──┐
                                 ├─< t_prd_product_categories (prd_cd, cat_cd) PK
t_prd_products   (prd_cd PK)  ──┘     · main_cat_yn  char(1) NOT NULL  (대표 카테고리 1행)
                                       · disp_seq     integer (노출 순서)
                                       · 현재 281행 / 273 distinct prd_cd (라이브 재추출)
```

- `t_prd_products`에 cat_cd 컬럼 **없음** → 귀속 = junction 행 INSERT/UPDATE.
- **다중분류** = 같은 prd_cd에 junction 2+행, **main_cat_yn='Y'는 정확히 1행**(대표), 나머지 'N'(별칭 노출).
- **환경 사실(D-6)**: 현 junction 281행 중 119행이 del='Y' 노드 참조(round-22 ⑥ 미완) — 본 매핑 책임 밖.

## 1. FK 위상 적재순서

| 순서 | 대상 | 작업 | 비고 |
|-----:|------|------|------|
| 0 | `t_cat_categories` | (선행) 활성 노드 **66** 그대로 사용·신규 mint 0 | §05 — del='Y' 부활은 설계 컨펌 후 별 단계 |
| 1 | `t_prd_products` | (선행 검증만) 적재 본체 prd_cd 실재 확인 | 신규 상품 INSERT 없음(RED 11 보류) |
| 2 | `t_prd_product_categories` | 본체 귀속(main_cat_yn='Y') UPSERT | (prd_cd,cat_cd) PK 멱등·충돌 0 |
| 3 | `t_prd_product_categories` | 별칭 귀속(main_cat_yn='N') UPSERT | 다중분류 **18**행·중복 prd_cd 채번 0 |

카테고리 노드(0)가 상품 귀속(2·3)에 **선행**해야 cat_cd FK 충족.

## 2. 상태별 적재 우선순위

| 우선순위 | 대상 | 행수 | 게이트 |
|----------|------|-----:|--------|
| **P1 즉시** | ✅ GREEN 본체 귀속 | **36** | 옵션+가격 완비 — 카테고리 귀속 즉시 가능 |
| **P2 옵션보완 후** | 🟡 YELLOW 본체 귀속 | **194** | 귀속은 가능하나 출시 전 옵션(round-6)/가격(round-16·18) 보완 권고 (197 release − 캘린더 동일셀 3 dedupe) |
| **P2.5 다중분류** | ◆ 별칭(main='N') | **18** | 본체 귀속(P1/P2) 후적재 |
| **P3 보류** | ❌ RED | **11** | 노드만 예약·상품 미정의 — 적재 제외(컨펌 큐) |

→ **즉시 적재 가능 = 36(P1) + 18(별칭, 본체 실존분)**. junction 적재 행 총 **248**. 194(P2)는 귀속 자체는 안전(상품·노드 실재)하나 출시 게이트 미충족 표기. RED 11은 적재 제외.

## 3. 영향분석 (기존 귀속 · FK · 롤백)

### 3.1 기존 귀속과의 충돌
- junction 현재 **281행** 존재 — 이미 모든 라이브 상품이 ≥1 카테고리에 연결됨. 본 매핑은 대부분 **기존 귀속 재확인(UPSERT no-op)** 또는 **소수 재배선**.
- 목표 cat_cd가 현재 라이브 귀속과 다른 경우만 **재배선(이동)** — 대부분은 정합(예: 엽서 상품 → 엽서/카드). 이동 후보는 검증 단계에서 셀 단위 확정.
- **★main_cat_yn 단일성 위험**: 다중분류 추가 시 기존 main 행이 이미 있으면 새 별칭 행은 반드시 'N'. 기존 main이 목표와 다르면 이동(기존 main='N' 강등 + 신규 main='Y')은 별도 결정 — 본 단계는 명세만. (D-1: 산출 CSV 내부에서 prd_cd당 main='Y' 단일성 보장 완료.)

### 3.2 FK 무결성
- 모든 목표 cat_cd ∈ 활성 **66** 노드. prd_cd ∈ 라이브 실재. FK 고아 위험 0(노드 선적재 전제).
- **del='Y' 노드 귀속 0**(D-2 가드 적용·CAT_000066 봉투제작 → L1 fallback). 부활(del='N') 선행 없이는 논리삭제 노드 연결 = 조회 차단([[dbmap-del-yn-soft-delete-authority]]).

### 3.3 롤백
- junction UPSERT는 멱등(PK (prd_cd,cat_cd)). 롤백 = 본 매핑이 INSERT한 행만 DELETE + 재배선 UPDATE 원복(백업 선행). 단가/옵션 사슬 무관(카테고리는 가격사슬 비참여) → **돈 크리티컬 아님**.

## 4. 컨펌 큐 (인간 판단 — 신규 정의·리서치 안 함)

### Q-1. 설계 철학: L1직속 vs 상품당 노드 부활 (★최우선)
193 라이브 상품이 del='Y' 동명 노드를 보유(§05, exact). **현행 설계(상품→L1/그룹L2 직속) 유지** vs **상품당 전용 노드 부활(193 del='N')** 중 택1. 본 매핑 기본값 = **현행 유지**(L1/그룹 직속, mint 0). 부활 선택 시 별 단계 노드 복구 후 귀속 재배선. **CAT_000066 봉투제작(D-2)도 이 큐**: PRD_000050을 L1 CAT_000003 직속으로 둘지(현행) 봉투제작 노드 부활할지 인간 판단.

### Q-2. 명명변형 5건 → 재분류 [D-4 처리 완료]
프리미엄상품권쿠폰(PRD_000042)·프레임리스우드액자(PRD_000131)·미니보드스탠딩(PRD_000144)·린넨패브릭코스터(PRD_000191)·레더여권케이스(PRD_000196) = 어순/오타 변형으로 라이브 실존. **release-status.csv·matching.csv 재분류 적용 완료**: PRD_000042 opt22/priced → ✅, 나머지 4 → 🟡. alias-dict 등록 정식화는 인간 판단(현재 matching.csv에 alias 등급으로 기록됨).

### Q-3. 포토북 variant 3건 상품 바인딩
심플모던/여행/큐티키즈 포토북 = **L3 노드(CAT_000109/110/111) 예약 완료**, 동명 상품(prd_cd) 미적재(포토북 본체=`[디자인명]` placeholder). 상품 정의 여부 = 인간 판단(round-5 적재 또는 디자인 템플릿 처리).

### Q-4. 진짜 부재 4건 + D-3 부재 4건 신규 정의
- **진짜 부재(4)**: 와이드접지리플랫·유니폼키링·오마모리키링·와블러 = 상품마스터 미수록.
- **D-3 부재(4)**: 골드실버아크릴명찰·아이스머그컵·LED키캡키링·우치와키링 = MAP엔 있으나 라이브 부재(과거 partial 과매칭으로 실존 상품에 잘못 흡수됐던 것 → 철회). 유사명 실존 상품(아크릴명찰·머그컵·키캡키링·미니우치와키링)과 **별개 상품**.
- 신규 상품 정의 여부 = 인간 판단(본 단계 신규 정의·도메인 리서치 안 함).

### Q-5. Sheet-only 고객노출 누락 후보 (§04 B)
폰케이스 계열(슬림하드/블랙젤리/임팩트 젤하드)·★신규(에어팟/버즈케이스·투명포스터★) = 라이브/시트 존재하나 MAP IA 미노출. IA 등재 여부 = 인간 판단.

## 5. 검증 의뢰 (dbm-validator · 생성자≠검증자)

1. 노드 실재 — 목표 cat_cd ∈ 라이브 활성 `t_cat_categories`(del='N'). **[V3]**
2. prd_cd 실재 — 적재 본체 prd_cd ∈ 라이브 `t_prd_products`. **[V1]**
3. FK 무모순 — junction 위상 정렬·고아 0·**del='Y' 노드 귀속 0(D-2 해소)**. **[V3]**
4. 다중분류 무결성 — **18** 별칭 본체 prd_cd 재사용·중복 채번 0·**(prd_cd,cat_cd) PK 충돌 0(D-1)**·main_cat_yn 단일성(prd_cd당 main='Y' =1). **[V4]**
5. search-before-mint — 신규 노드 0 재확인(부활은 컨펌 큐, mint 아님). **[V5]**
6. 출시상태 게이팅 정합 — ✅36/🟡197/❌11 분류가 `release-status.csv`와 일치(D-3/D-4). **[V2]**
7. 매칭 가드 — partial 과매칭 4건 철회 확인(D-3·02 §매칭 가드). **[V2/V6]**

## 6. 산출 파일 (보정본)

- `02_matching-matrix.md` — partial 매칭 가드 추가(D-3). `matching.csv` — 4 phantom 철회·5 명명변형 재분류.
- `release-status.csv` — D-3/D-4 재분류(✅36/🟡197/❌11).
- `05_category-node-mapping.md` — 레이어 A(노드 재사용 **66**·신규 0·정리 라우팅 **193**·D-5 카운트 정정).
- `06_product-category-mapping.md` + `product-cat.csv` — 레이어 B(junction 248행·다중분류 18·D-1 dedupe·D-2 가드).
- `07_mapping-load-plan.md` (본 문서) — FK 위상·우선순위·영향분석·컨펌 큐.
- `scripts/build_product_cat.py` — 결정적 빌드(D-1/D-2 가드 내장·게이트 자가검사 출력).
- `_live/{categories_live,products_live}.tsv` — 라이브 재추출본(D-5).
