# 제안: 박(foil) 2단 룩업 — 면적→분류등급→가격

- **닫는 GAP:** `09_load/_assembled_price/blocked-and-gaps.md §B-1` (BLOCKED-LEGIT) · `price-load-validation-final.md §A-3` · `schema-fitgap-price.md §4-3`
- **승격 행수:** foil-small 박 가공비 ≈90 가격셀 + 13 면적→등급 룩업 / foil-large 동형(현재 **0행 산출** → 적재가능)
- **판정:** DDL-NEEDED · **사다리:** 4단계(신규 룩업 테이블) + 2단계(component_prices에 nullable 컬럼 1개)
- **권위:** goal-2026-06-06-02 §5·R4 · `ddl-proposal-method.md` §6(박 2단)
- **적용:** propose ≠ apply — **인간 승인 필요**

---

## 1. GAP 본질 (왜 6차원에 못 담는가)

원천(`06_extract/price-foil-small-l1.csv`) 구조가 **환원 불가능한 2단 룩업**이다:

| 단계 | 블록 | 키 → 값 | 예시 |
|------|------|---------|------|
| 룩업1 (면적→등급) | B02 | 가로(mm) × 세로(mm) → **분류문자(A~E)** | 40mm×40mm → "D" |
| 룩업2 (등급×수량→가격) | B03 | 분류(A~E) × 수량구간(200,300,…) → 가격 | A×200매 → 12,200원 |

핵심: **여러 면적 셀이 같은 등급으로 압축**되고(13면적→5등급), 가격그리드는 등급+수량만으로
키잉된다(90셀). `t_prc_component_prices`의 6차원(siz/clr/mat/coat/bdl/min)에는
**중간키 분류등급을 둘 슬롯이 없다.** 이것이 round-2가 GAP으로 남긴 이유.

## 2. search-before-mint (HARD)

| 후보(직접 평면화) | 결과 | 근거 |
|------------------|------|------|
| **옵션A — mat_cd 차용** | ❌ 의미 오용 | A~E를 자재축(mat_cd)에 넣으면 자재 의미 오염. 게다가 **면적→등급 매핑(룩업1) 둘 자리 자체가 없음** (`schema-fitgap-price.md §4-3 A`) |
| **옵션B — 면적 직접 siz_cd** | ❌ 셀 폭증·압축의도 소실 | 면적 13종×수량 18=234셀(원본 90의 2.6배), 중복. "같은 등급=같은 가격" 압축의도 상실 (`§4-3 B`) |
| **옵션C — 2테이블 분리** | △ 무손실이나 룩업1 정착지 없었음 | round-2 당시 "스키마 변경 금지"라 룩업1 둘 곳이 없어 보류. **round-5가 이 제약을 DDL 제안으로 해제** → 본 제안이 옵션C의 정규 구현 (`§4-3 C`) |

→ 6차원 직접 표현 무손실 불가가 **입증**됨(round-2 검증 GO 원칙). 무손실엔 (1) 룩업1 전용 테이블 + (2) 가격그리드의 등급 차원이 둘 다 필요.

## 3. 설계 (최소 무손실 = 옵션C의 정규화)

1. **코드그룹 `FOIL_GRADE`** (사다리 1, 코드행) — A~E(소형)/A~I(대형) 등급 enum. ※ 코드행이라 DDL 아님.
2. **`t_prc_foil_area_grades`** (사다리 4, 신규 룩업1) — (comp_cd, 가로구간, 세로구간) → grade_cd. 면적→등급 압축의 정규 정착지. PK (comp_cd, width_from, height_from), 범위 CHECK, comp/grade FK.
3. **`t_prc_component_prices.grade_cd`** (사다리 2, nullable 컬럼 1개) — 기존 6차원은 그대로, 등급 7번째 키만 추가. 박 가격그리드 = (comp_cd=박종, grade_cd=A~E, min_qty=수량) → unit_price. 기존 행 전부 grade_cd=NULL(차원 무관).

**왜 가격그리드를 별도 테이블이 아니라 component_prices 컬럼 추가인가:** 룩업2(등급×수량→가격)는 component_prices가 이미 다루는 모양(comp_cd, min_qty → unit_price)과 동일하고, 시계열(apply_ymd)·comp_typ(.05 박형압) 인프라를 그대로 재사용한다. 등급 키 하나만 부족하므로 **nullable 컬럼 1개 추가가 신규 테이블보다 최소**(사다리 우선순위). 룩업1만 진짜 새 모양(면적구간→등급)이라 신규 테이블이 정당.

**컨벤션 정합:** 테이블명 `t_prc_<plural>` · comp_cd→t_prc_price_components(기존 FK 패턴) · grade_cd→t_cod_base_codes · `use_yn CHAR(1) CHECK` · `reg_dt`/`upd_dt`. grade_cd는 varchar(50)(라이브 cod_cd 길이).

## 4. 정규화 증명

- **무손실:** 룩업1(면적→등급)·룩업2(등급×수량→가격) 둘 다 스키마에 보존 → 원본 2단 구조 무손실. 압축의도(면적→등급) 유지.
- **무중복:** 등급 가격은 component_prices에 1곳. 면적→등급은 룩업 테이블에 1곳. 이중 저장 0.
- **함수종속 정합:** 룩업1 (comp_cd, 가로구간, 세로구간) → grade_cd 완전종속. 룩업2 (comp_cd, grade_cd, min_qty, apply_ymd) → unit_price. **2단을 올바른 키로 분해**(부분/이행종속 신설 0) — `ddl-proposal-method.md §5` "박 2단 룩업이면 (면적구간→분류)·(분류→가격)을 올바른 키로 분해" 준수.
- **참조무결성:** comp_cd·grade_cd FK 부모 실재.

## 5. 영향 분석

- **기존 행:** `ADD COLUMN grade_cd … (nullable)` → 기존 component_prices 적재본(즉시적재 2,108행) **무영향**(전부 grade_cd=NULL=차원 무관). 신규 룩업 테이블은 기존 무관.
- **FK:** 신규 FK 2종(area_grades.comp/grade, component_prices.grade) 부모 선존재 → 고아 0. 신규 FK가 기존 행 위반? grade_cd=NULL이면 FK 검사 면제 → 위반 0.
- **적용 순서:** FOIL_GRADE 코드행 → DDL(CREATE + ALTER) → 룩업1 행 → 박 가격그리드 행. round-5 `apply_price.sql`의 component_prices-load **이전** 또는 별도 박 step.
- **백필:** 기존 행 grade_cd=NULL 유지(박 외 행은 등급 무관) → 백필 불요.
- **롤백:** ALTER DROP CONSTRAINT/COLUMN + DROP TABLE(.sql 하단).
- **닫히는 GAP:** 적용 + 후니 박 모델링 결정 후 박 가공비(소형 ≈90셀 + 대형)가 0행 → 적재가능 승격.

## 6. 잔존 인간 결정 (자율 진행 금지)

1. **운영 입력 방식 택일** (`schema-fitgap-price.md §4-3` 에스컬레이션): 고객이 ① 사이즈(가로×세로 mm) 입력→시스템이 등급 자동 산출 vs ② A~E 등급 직접 선택. 본 제안은 ①(면적→등급 자동)을 전제로 룩업1을 둠 — ②면 룩업1 불요(등급 직접). **후니 결정 후 룩업1 적재 여부 확정.**
2. **대형 등급집합(A~I)** 정확 범위 = 후니/원천 확인(소형 A~E 확정, 대형은 A~I 추정 표기).
3. **동판비(B01)는 본 GAP 밖** — 2D(가로×세로→단가) ADEQUATE라 기존 6차원(siz_cd=면적좌표, min_qty)로 즉시 평면화 가능. 별도 처리(이 제안 불필요).
4. 적용은 후니가 라이브에 — 제안과 적용 분리.
