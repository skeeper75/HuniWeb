# 가격테이블 시트별 효율 적재 플레이북 (2026-06-29 정립)

> 다음 세션이 **각 시트의 가격테이블을 빠르고 정확하게 라이브 적재**하기 위한 표준 절차 + 재사용 쿼리.
> 이번 세션 학습(출력소재 적재 종단)에서 도출. ★권위=2엑셀 verbatim·생성≠검증·DB 미적재 기본(실 COMMIT은 인간 승인).

---

## 0. 핵심 원리 (반드시 먼저 — 이걸 어기면 가짜결함·오적재)

### 원리1. 출력소재/자재 = 다카테고리 → component 라우팅 [HARD]
시트(특히 출력소재)는 여러 소재 카테고리의 카탈로그. **자재유형(mat_typ_cd)별로 가격 그릇이 다름**:
| mat_typ_cd | 카테고리 | 가격 그릇 |
|---|---|---|
| .01 / .18 | 디지털인쇄용지(종이+디지털PET) | **COMP_PAPER (절가)** |
| .11 / .13 | 스티커용지 / 합판스티커 | **COMP_STK_PRINT / COMP_GANGPAN_PRINT (완제품가)** |
| .08 | 실사소재 | 실사/포스터사인 (**면적가격** — mat_cd 아님) |
| .20 | 아크릴 | 아크릴 (**면적가격**) |
→ 시트 통째로 한 component에 넣지 말 것. 면적가격(.08/.20) 소재는 mat_cd 단가행이 0인 게 정상(false positive 주의).

### 원리2. 가짜 결함 가드 [HARD]
"상품이 자재 참조 + 미적재"만으로 결함 아님. **그 상품의 공식이 실제로 그 component(예 COMP_PAPER)를 바인딩하는지** 확인 필수. 안 쓰면 자재 참조는 BOM(생산정보)일 뿐 → 적재 불요.
- 실증: 아트250+무광코팅(8상품·공식에 용지비 없음)·3절용지(와이드벽걸이캘린더·용지비 없음) = 가짜결함. (이번 세션 3절 3행 오적재→제거)

### 원리3. 상위/하위 적재 레벨 [HARD]
자재는 계층(`upr_mat_cd` 상위/하위). 가격은 **상품 옵션(t_prd_product_option_items.ref_key1·ref_dim_cd=OPT_REF_DIM.03=자재)이 참조하는 레벨**에 넣는다.
- 기성용지: 옵션이 하위(아트지250g) 참조 → 하위 적재.
- 특수용지: 옵션이 하위(색상/평량) 참조 → 하위 적재. **부모=기본/대표 변형 가격**(예 큐리어스스킨 부모 880=화이트색·하위 다른색 1242.5).
- ★**색상마다 절가 다를 수 있음**(스타드림 다이아407.5/로즈524/골드435/실버425) → 부모복사 금지·각 하위=자기 권위값 verbatim.

### 원리4. 검증 프로토콜 [HARD]
생성≠검증. 적재 전 dryrun(BEGIN…ROLLBACK)·시퀀스 건강성(last_value>max)·적재 후 재조회 verbatim 대조·undo SQL 보유. 단가 절대 verbatim(계산·배수·blind swap 금지).

---

## 1. 시트 적재 표준 절차 (반복 루프)

```
A. 배치 빌더 diff (있으면)  → scripts/run_all.py (권위CSV↔스냅샷 결정론·토큰0)
B. 진짜 결함 필터          → "상품이 그 component 공식을 바인딩하는가" (원리2 쿼리)
C. 적재 레벨 결정          → option_items ref 레벨 (원리3 쿼리)
D. 권위 verbatim 적재본    → load.sql + dryrun(BEGIN…ROLLBACK)
E. dryrun → 사람 승인 → COMMIT → 사후 재조회 → undo 작성
```

스냅샷 신선도: 라이브 COMMIT 후 `_foundation/live-snapshot/snapshot.sh` 재생성(돈크리티컬 전).

---

## 2. 재사용 쿼리 (복붙)

### Q1. 진짜 결함 감사 (component 바인딩 필터 — 가짜결함 제거)
```sql
-- <COMP>=COMP_PAPER 등, <TYPES>=('MAT_TYPE.01','MAT_TYPE.18')
WITH gap AS (
  SELECT DISTINCT m.mat_cd, m.mat_nm, pm.prd_cd
  FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd
  WHERE m.mat_typ_cd IN <TYPES> AND m.del_yn='N'
    AND (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.comp_cd='<COMP>' AND cp.mat_cd=m.mat_cd)=0)
SELECT g.mat_cd, g.mat_nm, count(DISTINCT g.prd_cd) AS 바인딩상품수
FROM gap g
WHERE EXISTS (SELECT 1 FROM t_prd_product_price_formulas pf
  JOIN t_prc_formula_components fc ON fc.frm_cd=pf.frm_cd
  WHERE pf.prd_cd=g.prd_cd AND fc.comp_cd='<COMP>')  -- ★가짜결함 가드
GROUP BY g.mat_cd, g.mat_nm;
```

### Q2. 적재 레벨 확인 (옵션이 하위/부모 어느 코드 참조)
```sql
SELECT ref_dim_cd, ref_key1 FROM t_prd_product_option_items WHERE ref_key1='<MAT_CD>';
-- OPT_REF_DIM.03 = 자재 차원. ref_key1=참조 mat_cd. 그 레벨에 가격 넣는다.
```

### Q3. 상위/하위 + 부모가격 동시 보기
```sql
SELECT m.mat_cd 하위, m.mat_nm, m.upr_mat_cd 부모,
  (SELECT unit_price FROM t_prc_component_prices cp WHERE cp.comp_cd='COMP_PAPER' AND cp.mat_cd=m.upr_mat_cd LIMIT 1) 부모가격,
  (SELECT count(*) FROM t_prc_component_prices cp WHERE cp.comp_cd='COMP_PAPER' AND cp.mat_cd=m.mat_cd) 하위가격행
FROM t_mat_materials m WHERE m.mat_cd='<MAT_CD>';
```

### 적재본/dryrun/undo 템플릿
- load.sql: `BEGIN; INSERT … ON CONFLICT DO NOTHING; COMMIT;` (verbatim)
- dryrun: 위에서 `COMMIT` → `SELECT 검증; ROLLBACK;`
- undo: 적재 전 `max(comp_price_id)` 캡처 → `DELETE … WHERE comp_price_id>PRE_MAX`
- 판형코드: 국4절=SIZ_000499(316x467) · 3절=SIZ_000077(300x625)
- 절가 note 패턴: `용지비 <자재명> <판형>(<size>) 절가 — 실제 청구는 출력매수만큼 자동 계산`

---

## 3. 자격증명 / 환경
- 라이브: `.env.local RAILWAY_DB_*` (읽기전용 SELECT·dryrun BEGIN…ROLLBACK). Bash 실행 시 `dangerouslyDisableSandbox=true`.
- 시뮬레이터(엔진 실측): `_foundation/batch/lib_huni.py HuniSim`(인증 POST `/admin/price-viewer/<prd>/simulate/`). `.env.local HUNI_ADMIN_*`.
- 권위 추출 CSV: `huni-dbmap/06_extract/price-*-l1.csv`(가격표 19시트)·`import-paper-l1.csv`(출력소재).
- 배치 빌더: `_batch/scripts/{matrix_parse,grid_diff,build_load,run_all}.py`.
