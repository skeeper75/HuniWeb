# 적용 기록 — 디지털 국4절 종이비 GAP 7행 (실제 COMMIT 완료)

> **적용** 2026-06-15 · round-19 가격 트랙 **첫 실제 라이브 적재** 완료.
> **승인 사슬**: dbm-validator 독립 검증 R1~R7 전건 PASS GO → 인간(사용자) 명시 승인("백업하고 라이브 DB에 실제 적재하면서 테스트").
> **대상 DB**: Railway `railway`(운영). 비밀값 비노출(.env.local만).

---

## 1. 적용 결과 요약

| 항목 | 값 |
|------|-----|
| 대상 테이블 | `t_prc_component_prices` (comp_cd=COMP_PAPER) |
| 적재 행수 | **7** (디지털 국4절 종이비 GAP) |
| COMP_PAPER 행수 | 49 → **56** (영속 확인) |
| apply_ymd | 2026-06-01 (기존 세대 합류·단일 세대 유지) |
| 멱등 방식 | NOT EXISTS NULL-safe 가드 |
| COMMIT | ✅ 완료 (2회 실행·2회차 delta 0) |

---

## 2. 백업 (undo 안전망)

| 백업 | 방식 | 행수 | 상태 |
|------|------|:---:|------|
| `bak_papergap8_260615` | DB 내부 `CREATE TABLE AS SELECT * FROM t_prc_component_prices` | **3,481** | ✅ COMMIT 전 생성·rows_match=t |
| `pre_comp_paper_260615.csv` | 읽기전용 `\copy`(COMP_PAPER 49행) | 49 | ✅ baseline |

- 시퀀스 정합: `comp_price_id` IDENTITY · seq last_value=5154 > MAX=4954 → 비명시 INSERT 안전·setval 불요.

---

## 3. 적재 7행 (자연키 + 단가)

그릇: comp_cd=COMP_PAPER · apply_ymd=2026-06-01 · siz_cd=SIZ_000499(316x467 국4절) · clr/proc/opt/coat_side_cnt/bdl_qty/min_qty=NULL.

| mat_cd | mat_nm | 가격표 행/열 | 권위(I) | 라이브 저장 numeric(12,2) |
|--------|--------|:---:|:---:|:---:|
| MAT_000096 | 앙상블 130g | R22/I | 71.33 | 71.33 |
| MAT_000097 | 앙상블 160g | R23/I | 87.795 | 87.80 (round-half-up·49 RU 관례) |
| MAT_000098 | 앙상블 190g | R24/I | 104.24 | 104.24 |
| MAT_000099 | 앙상블 210g | R25/I | 115.23 | 115.23 |
| MAT_000119 | 리브스디자인 250g | R40/I | 500 | 500.00 |
| MAT_000123 | 띤또레또 200g | R43/I | 245 | 245.00 |
| MAT_000124 | 띤또레또 250g | R44/I | 306 | 306.00 |

> ★ 8행→7행 정정: 클래식 크래스트 스티플 270g(MAT_000118)은 이미 RU(480.00) → GAP 아님(검증 GO에서 "8→7 정정 옳음" 확인).

---

## 4. COMMIT 후 검증 (전건 PASS)

| 검증 | 기대 | 결과 |
|------|------|------|
| COMP_PAPER 영속 행수 | 56 | **56** ✅ |
| 신규 7 mat_cd 실재 | 7행 | **7행** ✅ |
| unit_price 가격표 권위값 일치 | 전건 | price_match 전건 t ✅ |
| siz_cd | SIZ_000499 | 전건 ✅ |
| apply_ymd | 2026-06-01 단일 세대 | 56행 단일 ✅ (시계열 2세대 0) |
| FK 고아 (mat_cd·siz_cd) | 0 | mat 0 / siz 0 ✅ |
| 자연키 중복 | 0 | 7 mat_cd 전건 1행 ✅ |

---

## 5. 멱등 2회차 (재-COMMIT delta 0)

```
2회차 ./apply.sh commit:
  before 56 → INSERT 0 0 × 7 → after 56  (NOT EXISTS 가드·중복 0)
  영속 재확인: 56 유지
```
→ 멱등 실증 (재실행해도 가격 이중계상·중복 0).

---

## 6. 롤백법 (undo)

COMMIT 후 되돌릴 필요 시 — 둘 중 하나(둘 다 비파괴적·신중):

### 방법 A — 신규 7행만 DELETE (권장·국소)
```sql
-- 본 적재로 추가된 7행만 제거(기존 49 RU·타 comp 불변)
DELETE FROM t_prc_component_prices
WHERE comp_cd='COMP_PAPER' AND apply_ymd='2026-06-01' AND siz_cd='SIZ_000499'
  AND clr_cd IS NULL AND proc_cd IS NULL AND opt_cd IS NULL
  AND coat_side_cnt IS NULL AND bdl_qty IS NULL AND min_qty IS NULL
  AND mat_cd IN ('MAT_000096','MAT_000097','MAT_000098','MAT_000099','MAT_000119','MAT_000123','MAT_000124');
-- 검증: COMP_PAPER 49행 복귀
```

### 방법 B — 백업 스냅샷에서 전체 복원 (전면)
```sql
-- bak_papergap8_260615(3,481행)으로 t_prc_component_prices 전체 복원.
-- ★ 백업 시점 이후 타 트랙 변경이 있으면 그 변경도 되돌아감 — 전면 복원이라 신중.
BEGIN;
TRUNCATE t_prc_component_prices;  -- 또는 영향 범위만
INSERT INTO t_prc_component_prices SELECT * FROM bak_papergap8_260615;
COMMIT;
```
> 일반적으로 **방법 A(국소 DELETE)** 가 안전. 방법 B는 백업 시점 이후 무변경일 때만.

백업 정리: 안정화 확인 후 `DROP TABLE bak_papergap8_260615;`(인간 승인 시).

---

## 7. 가격사슬 효과

COMP_PAPER는 PRF_DGP_A~F 6개 디지털 합산형 공식에 이미 배선(formula_components) → 단가행 7개 추가로 **앙상블 130/160/190/210·리브스디자인 250·띤또레또 200/250 용지 선택 상품의 종이비 가격 조회가 즉시 성립**(배선 추가 불요·가격사슬 완결). 검증 GO에서 "PRF_DGP_A~F 배선 도달" 확인됨.

---

## 8. 한 줄 현황

round-19 첫 실제 라이브 적재 **완료** — 디지털 국4절 종이비 GAP **7행** COMMIT(COMP_PAPER 49→56·apply_ymd 2026-06-01 단일 세대). 백업 `bak_papergap8_260615`(3,481행) 보유·검증 전건 PASS(값·FK·자연키·세대)·멱등 2회차 delta 0·롤백법(국소 DELETE/백업 복원) 확보. 다음 GAP(3절·PET·특수지·스티커·하드커버)은 siz 선결·컨펌 미해소로 범위 밖.
