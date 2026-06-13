---
name: dbm-price-formula-audit
description: 후니프린팅 라이브 webadmin admin "가격관리 > 가격공식"에 적재된 가격공식(t_prc_price_formulas)이 제대로 정리됐는지 검증하고 실무진용 정리표·개선안을 산출하는 round-17 방법론 스킬. 한 공식을 ① 라이브 DB(information_schema 실측) ② webadmin 소스(price_views.py·가격허브/뷰어 mockup) ③ admin 실제 화면(gstack) 3중 대조해, 4축(정리 상태·실무진 가독성·가격구성요소 배선 사용가능성·가격뷰어 노출)으로 판정한다. 공식명(frm_nm)/비고(note)가 비개발자 실무진이 즉시 알아볼 수 있는지(쉬운 한국어 라벨), 가격공식이 formula_components에 배선되어 가격구성요소에서 쓰이고 가격뷰어에서 확인되는지를 핵심 검사한다. 산출 = 실무진 가격공식 정리표 + 가독성/배선/뷰어 결함 보드 + 공식명/비고 개선안. round-16 가격공식 그릇(16시트)·가격사슬 단절 진단을 입력 재사용. DB 직접 쓰기는 하지 않는다. '가격공식 정리 검증', '가격공식 정리 확인', '공식명 비고 정리', '실무진 가격공식 정리표', '가격공식 가독성', '가격공식 사용가능성', '가격뷰어 확인', '가격공식 배선 검증', '가격관리 가격공식 점검', 'round-17', '가격공식 검증 다시', '가격공식 개선안' 작업 시 반드시 이 스킬을 사용. 가격표→그릇 분해(round-16)는 dbm-price-import-prep, 가격 공식 엔진 fit-gap(round-2)은 dbm-price-formula가 담당하므로 그 작업에는 트리거하지 않는다.
---

# dbm-price-formula-audit — 가격공식 정리 검증 (round-17)

라이브 webadmin "가격관리 > 가격공식"의 가격공식이 **실무진 운영 품질**을 갖췄는지 검증하고, 실무진용 정리표·개선안을 산출하는 방법론이다. "DB에 행이 있다"가 아니라 "공식이 화면에서 실무진에게 올바르게 보이고 가격구성요소·가격뷰어에서 쓸 수 있다"가 합격 기준이다.

## 왜 3중 대조인가

가격공식은 세 곳에서 동시에 존재해야 일관적이다 — ① 라이브 DB(`t_prc_price_formulas` 행) ② webadmin 소스가 그 행을 읽어 화면에 그리는 쿼리(`price_views.py`) ③ 실무진이 보는 admin 화면(가격허브·가격뷰어). 한 곳만 보면 거짓 정합에 속는다: DB에 공식이 있어도 배선이 없으면 가격구성요소에서 안 쓰이고, 화면 쿼리가 그 공식을 안 집으면 뷰어에서 안 보인다. round-16이 "가격사슬 단절"(단가행 적재됐으나 배선 0)을 광범위하게 발견한 이유가 이것이다.

## 권위 순서 (HARD)

1. **라이브 information_schema** — `t_prc_price_formulas`의 실제 컬럼이 무엇인지. round-16 빌더들은 "frm_typ_cd 라이브 부재"를 전제로 삼았으나 `price_views.py:234`는 `frm_cd__frm_typ_cd == "FRM_TYPE.01"`을 실제 사용한다. **이 모순을 라이브 실측으로 먼저 결판낸다**(검증 1순위). 컬럼 실재는 라이브가 권위.
2. **webadmin 소스** — `price_views.py`(공식→구성요소→단가 쿼리·`price_comp_usage` 사용처)·`11-price-engine-simulator/`(11-CONTEXT·mockup-a-price-viewer·mockup-b-price-hub)가 "화면이 공식을 어떻게 노출하도록 설계됐는가"의 권위.
3. **admin 실제 화면** — gstack로 라이브 가격허브/가격뷰어를 떠서 실제 노출을 확인(읽기만·저장/삭제 금지).
4. **round-16 산출** — `20_price-import/` 16시트의 공식·구성요소·가격사슬 진단(재유도 금지·인용).

## 4축 품질 판정

각 가격공식(frm_cd)에 대해 4축을 판정한다. 축마다 ✅PASS / 🟡개선 / 🔴결함 등급.

| 축 | 검사 | PASS 기준 | 결함 신호 |
|----|------|----------|----------|
| **A. 정리 상태** | frm_cd·frm_nm·frm_typ_cd(있으면)·note·use_yn 채움/일관 | 필수 필드 채워짐·use_yn 일관·중복 frm_cd 0 | 빈 frm_nm·빈 note·use_yn 불일치·중복 |
| **B. 가독성** | 공식명/비고를 비개발자 실무진이 코드 없이 즉시 이해 | 쉬운 한국어 라벨(무슨 상품·무슨 계산)·유형이 "합산형/단순형" 등 평이어로 | `PRF_DGP_E`만·약어·영문코드·빈 비고 |
| **C. 사용가능성(배선)** | `t_prc_formula_components`에 배선되어 가격구성요소에서 실제 쓰임 | 배선 ≥1·연결 상품(`t_prd_product_price_formulas`) ≥1 | 미배선 고아 공식·상품 바인딩 0(round-16 가격사슬 단절) |
| **D. 뷰어 노출** | 가격뷰어(`price_product_detail`·`price_grid`·`price_comp_usage`)에서 조회·노출 | 뷰어 쿼리가 이 공식을 집고 화면에 표시 | 쿼리 경로 단절·화면 미표시 |

핵심 연결: **C(배선)가 깨지면 D(뷰어 노출)도 대개 깨진다** — 미배선 공식은 `price_comp_usage`·`price_product_detail`에서 안 잡힌다. 두 축을 함께 추적한다.

## 워크플로우

### 1. 라이브 스키마 결판 (frm_typ_cd 모순)
`t_prc_price_formulas`·`t_prc_formula_components`·`t_prd_product_price_formulas`·`t_prc_price_components` information_schema를 읽기전용 실측. frm_typ_cd 컬럼 실재 여부를 확정하고 round-16 전제와 대조해 결판을 명시한다. 읽기전용 SELECT 패턴은 `dbm-schema-extract` 스킬의 psql 툴킷을 차용한다(`.env.local` `RAILWAY_DB_*`·`db railway`·비표준 포트·비밀번호 비노출).

### 2. 가격공식 전수 인벤토리
전 `t_prc_price_formulas` 행을 떠서 frm_cd·frm_nm·frm_typ_cd·note·use_yn + 배선 수(`formula_components` 조인) + 연결 상품 수(`product_price_formulas` 조인)를 한 행으로 모은다. round-16 `20_price-import/`의 공식 출처(어느 시트의 어느 공식인지)를 병기한다.

### 3. 4축 판정
각 공식에 A~D 등급. 배선/뷰어는 소스(`price_views.py` 쿼리)로 노출 경로를 확인하고, 대표 공식은 gstack로 admin 가격뷰어/가격허브 실제 화면을 떠서 3중 대조한다(`huni-admin-live-capture` 스킬 패턴·`HUNI_ADMIN_*`).

### 4. 실무진 정리표
전 공식을 한 표로: `공식코드 · 공식명 · 유형(쉬운라벨) · 비고 · 구성요소(목록) · 연결상품수 · 뷰어노출 · 정리상태(✅🟡🔴)`. 실무진이 한 눈에 "어떤 공식이 무엇이고 어디 쓰이는지" 본다. 정렬은 상품군/유형 기준.

### 5. 결함 보드 + 개선안
가독성 미달·미배선 고아·뷰어 미노출을 결함 보드로 분류(우선순위 High/Medium/Low). 개선안은:
- **공식명/비고**: 현재값 → 쉬운 한국어 제안(무슨 상품·무슨 계산을 즉시 알게). 예: `PRF_DGP_E`(비고 없음) → 비고 "디지털인쇄 합산형E — 접지카드·접지리플렛 후가공 합산".
- **배선/뷰어 교정**: 미배선 공식의 배선 INSERT 후보·뷰어 노출 경로 보강(인간 승인 대상·DB 미적재).

## 산출물 (`_workspace/huni-dbmap/21_price-formula-audit/`)

| 파일 | 내용 |
|------|------|
| `formula-inventory.md` | 전수 인벤토리 + 4축 판정 + frm_typ_cd 결판 |
| `formula-table.md` (+`.csv`) | 실무진 정리표(공식명·유형·비고·구성요소·연결상품·뷰어노출·상태) |
| `defect-board.md` | 가독성/배선/뷰어 결함 분류 + 우선순위 |
| `improvement-proposal.md` | 공식명/비고 개선안 + 배선/뷰어 교정 제안(인간 승인) |

## 검증 게이트 (dbm-validator 독립 2-pass)

생성자(auditor)≠검증자. validator가 다음을 독립 재현한다:
- **F1 스키마 결판 재현**: frm_typ_cd 실재 여부를 라이브 information_schema로 재실측해 auditor 결판과 일치하는지.
- **F2 인벤토리 무손실**: 라이브 `t_prc_price_formulas` count ↔ 정리표 행수 1:1·날조 0.
- **F3 4축 판정 일관**: 가독성 기준이 자의적이지 않고 일관 적용됐는지(같은 결함 유형에 같은 등급).
- **F4 배선/뷰어 실측**: 미배선 고아·뷰어 미노출 주장을 `formula_components`·`price_views.py` 쿼리로 직접 재확인(round-16 가격사슬 단절과 정합).
- **F5 개선안 비파괴**: 개선안이 DB 직접 쓰기를 포함하지 않고 인간 승인 대상으로 분리됐는지.

## 비파괴 원칙

DB 직접 쓰기(COMMIT/DDL/UPDATE) 없음. 라이브는 읽기전용 SELECT + admin 읽기 탐색만. 공식명/비고 UPDATE·배선 INSERT 등 실 교정은 round-5/round-10 트랙 + 인간 승인. 비밀값은 `_workspace`(git 추적)·stdout·캡처에 비노출.
