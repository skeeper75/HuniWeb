# ddl-proposal-method — 신규 엔티티 DDL 제안 방법론 (dbm-ddl-proposer)

> round-4가 GAP/BLOCKED로 분리한 항목을, 라이브 `t_*` 컨벤션 정합의 **최소 신규 엔티티 DDL 제안서**로
> 닫는 방법. 권위: `docs/goal-2026-06-06-02.md` §5(제안 경계)·§8·R4. **제안까지만 — 적용은 인간 승인.**
> 식별자·DDL·SQL 영어, 설명 한국어.

## 목차 (ToC)

1. 제안의 4단계 (search → design → impact → propose)
2. search-before-mint — 기존 구조 우선 탐색 (HARD)
3. 라이브 `t_*` 컨벤션 카탈로그
4. 설계 선택지 사다리 (코드행 < 컬럼 < JSONB키 < 테이블)
5. 정규화 원칙
6. GAP별 제안 가이드 (박·비치수 size·형상 enum·책등·addon template)
7. 영향분석 (기존 행·FK·백필·적용순서)
8. 제안서 템플릿 (`.sql` + `.md`)
9. 안티패턴

---

## 1. 제안의 4단계

각 GAP에 대해 순서대로: **① search**(기존 구조로 해결되는가?) → **② design**(안 되면 최소 신규 엔티티) →
**③ impact**(기존에 미치는 영향) → **④ propose**(DDL + 근거 산출). ①에서 해결되면 ②~④ 없이 "no DDL — use X"로 종결.

## 2. search-before-mint — 기존 구조 우선 탐색 (HARD)

신규 엔티티를 만들기 전, **반드시** 다음을 라이브에서 탐색하고 문서화한다(R4 통과 조건):
- 기존 테이블/컬럼이 이 데이터를 담을 수 있는가? (예: 비치수 size를 `nonspec_*` 컬럼·`siz_cd` 재사용으로)
- 기존 코드 그룹(`t_cod_base_codes`)에 자식 코드 추가로 해결되는가? (그러면 DDL 아닌 코드행 — round-4 영역)
- 기존 JSONB 슬롯(`constraint_json`, `ref_param_json` 등)이 이 가변 구조를 담는가?
- 기존 polymorphic 참조(`ref_dim_cd` 8종 등)로 표현되는가?

round-4 `SIZ_000506` 사건(원형35mm를 신규 mint했으나 라이브 `SIZ_000422` 이미 존재)이 이 게이트의 존재 이유.
탐색 없이 mint하면 R4 FAIL.

## 3. 라이브 `t_*` 컨벤션 카탈로그

신규 엔티티는 기존 패턴을 그대로 따른다(이질적 설계 금지). 제안 전 라이브에서 실제 패턴을 재확인한다.
- **테이블명:** `t_<domain>_<plural>` (예: `t_prd_product_sizes`, `t_prc_component_prices`).
- **PK:** 도메인 코드 `<dom>_cd CHAR/VARCHAR` (예: `prd_cd`, `mat_cd`, `siz_cd`) — `<PREFIX>_NNNNNN` 형식.
- **코드값:** `t_cod_base_codes`(group_cd + code_cd + code_nm) 패턴. 새 enum 축은 우선 코드 그룹으로.
- **FK:** 자식 테이블이 `<parent>_cd`로 부모 참조. `ON DELETE`/`ON UPDATE`는 기존 테이블의 정책 따름.
- **플래그/감사 컬럼:** `use_yn CHAR(1) CHECK (use_yn IN ('Y','N'))`, `reg_dt`/`mod_dt` 등 기존 관용.
- **가변 구조:** 기존이 JSONB(`constraint_json` jsonb 등)를 쓰면 그 방식을 재사용.
- 길이: `comp_cd` 등은 varchar(50) — round-4 55자 overflow 사건. 길이 제약 미리 확인.

## 4. 설계 선택지 사다리 (가벼운 것 우선)

GAP을 닫는 최소 수단을 아래 사다리의 **위에서부터** 시도한다. 아래로 갈수록 변경 영향이 크다.
1. **코드행 추가** (`t_cod_base_codes` 자식) — DDL 아님, round-4 코드행 선적재. enum 값 1~N개면 여기서 끝.
2. **기존 테이블에 컬럼 추가** (`ALTER TABLE … ADD COLUMN … NULL`) — 단일 속성·NULL 허용으로 기존 행 무영향.
3. **기존 JSONB 컬럼에 키 추가** — 스키마 변경 없이 가변 param(책등 두께 등) 수용. 검증은 앱/CHECK로.
4. **신규 테이블** — 다대다·반복 그룹·독립 수명주기일 때만. 1:N 중간 룩업(박 2단)·새 축(형상)·새 마스터(비치수 size).

> 한 GAP에 테이블 신설과 컬럼 추가가 모두 가능하면 **컬럼/JSONB을 우선**한다. 테이블은 정규화상 정당할 때만.

## 5. 정규화 원칙

- **무손실:** 제안 구조가 GAP 데이터를 손실 없이 표현(round-4가 GAP으로 분리한 이유를 정확히 해소).
- **무중복:** 같은 사실을 두 곳에 저장하지 않음. 기존 컬럼과 의미 중복 0.
- **함수종속 정합:** 부분종속·이행종속 신설 금지. 박 2단 룩업이면 (면적구간→분류)·(분류→가격)을 올바른 키로 분해.
- **참조무결성:** 신규 FK는 부모 실재를 보장. 신규 코드 축은 `t_cod_base_codes` 또는 전용 코드 테이블로.

## 6. GAP별 제안 가이드 (round-4 blocked-and-gaps 기준)

각 항목은 **먼저 §2 search**를 거친다. 아래는 search 실패(기존 구조로 불가) 시의 설계 방향 예시 — 실제 설계는
라이브 재확인 후 확정한다(추측 금지).

- **박 2단 룩업(면적→분류→가격):** 중간 분류키 부재가 핵심. 후보 = (a) `t_prc_*`에 면적구간→분류 룩업
  테이블 신설(분류 코드는 `t_cod_base_codes`), (b) 분류를 `siz_cd`/`mat_cd` 차원으로 환원 가능한지 search.
  억지 평면화(component_prices 6차원에 끼워넣기) 금지 — round-2가 GAP으로 남긴 이유.
- **goods-pouch 비치수 size(47상품):** 재단치수 원천 부재(L1 전 공란). 후보 = (a) 비치수 size 마스터
  모델(`t_siz_sizes`에 `spec_yn='N'` 컬럼 추가 + 명목 라벨), (b) `nonspec_*` 인코딩이 기존에 있는지 search.
  siz_cd 발명 금지(round-4 거부 정당) — 모델 결정이 본질.
- **sticker 형상 enum 축(원형 등):** 형상이 size 보조인가 독립 축인가. 후보 = (a) `t_cod_base_codes` 형상
  코드 그룹(가벼움, 사다리 1), (b) process param, (c) 신규 축 테이블. 우선 코드 그룹 search.
- **책등(spine) param 슬롯:** photobook 책등 두께 param. 후보 = 기존 process param JSONB 키 추가(사다리 3)
  우선 search → 없으면 `ALTER ADD COLUMN`(사다리 2).
- **addon template 부재(4행):** addon이 참조할 template 행 없음. 후보 = 기존 `t_prd_templates` 모델로 등록
  가능한지(코드행/데이터) search → 구조적으로 불가할 때만 DDL.

## 7. 영향분석 (제안서 필수 섹션)

각 제안은 적용이 기존에 무엇을 바꾸는지 명시한다:
- **기존 행 영향:** `ADD COLUMN … NULL`이면 기존 행 무영향. `NOT NULL`/제약 추가면 백필·검증 필요 → 백필 SQL 동봉.
- **FK 영향:** 신규 FK가 기존 데이터의 참조무결성을 깨지 않는지(고아 0). 신규 부모 테이블이면 선적재 순서.
- **적용 순서:** DDL → 코드행 → 적재행. round-5 `apply.sql`의 어느 step 이전에 적용돼야 하는지.
- **롤백 가능성:** 제안 DDL의 역(`DROP`/`ALTER … DROP COLUMN`)을 함께 기재(되돌리기).
- **닫히는 GAP:** 이 제안 적용 후 round-4 어떤 blocked/GAP 행이 적재가능으로 승격되는지(행수).

## 8. 제안서 템플릿

**`11_ddl_proposals/ddl-proposal-<gap>.sql`:**
```sql
-- DDL PROPOSAL: <gap-name>  (PROPOSAL ONLY — DO NOT APPLY without human approval)
-- Closes round-4 GAP: <blocked-and-gaps.md 참조>  | rows unblocked: <N>
-- search-before-mint: <기존 구조로 불가함을 입증한 요약>

-- forward
CREATE TABLE IF NOT EXISTS t_prc_box_area_classes (
  box_class_cd VARCHAR(50) PRIMARY KEY,
  area_from    NUMERIC(10,2) NOT NULL,
  area_to      NUMERIC(10,2) NOT NULL,
  use_yn       CHAR(1) NOT NULL DEFAULT 'Y' CHECK (use_yn IN ('Y','N')),
  CONSTRAINT uq_box_area_range UNIQUE (area_from, area_to)
);
-- ALTER 예: ALTER TABLE t_siz_sizes ADD COLUMN IF NOT EXISTS spec_yn CHAR(1) DEFAULT 'Y' CHECK (spec_yn IN ('Y','N'));

-- rollback (되돌리기)
-- DROP TABLE IF EXISTS t_prc_box_area_classes;
-- ALTER TABLE t_siz_sizes DROP COLUMN IF EXISTS spec_yn;
```

**`11_ddl_proposals/ddl-proposal-<gap>.md`:**
```
## 제안: <gap-name>
- 닫는 GAP: <round-4 항목> · 승격 행수: <N>
- search-before-mint: 탐색한 기존 구조 + 왜 불가한지 (라이브 근거)
- 설계: 사다리 단계(코드행/컬럼/JSONB/테이블) + 컨벤션 정합 근거
- 정규화: 무손실·무중복·함수종속 정합 입증
- 영향: 기존 행 / FK / 적용순서 / 백필 / 롤백
- 적용 게이트: 인간 승인 필요(propose ≠ apply)
```

## 9. 안티패턴

- ❌ search 없이 mint (R4 FAIL의 1번 원인). 기존 구조 탐색·문서화 생략 금지.
- ❌ 한 GAP에 과한 설계(테이블 여러 개) — 사다리 위쪽 최소안 우선.
- ❌ 라이브 컨벤션 무시한 이질적 설계(다른 PK 형식·다른 코드 패턴).
- ❌ "있으면 편할" 추측 엔티티 — 실제 round-4 GAP에 묶이지 않은 제안.
- ❌ DDL 직접 적용 — 본 트랙은 제안서까지. `CREATE`/`ALTER` 라이브 실행 금지.
- ❌ 영향분석·롤백 누락 — 제안서는 적용 결정을 위한 문서. 영향 없으면 미완성.
