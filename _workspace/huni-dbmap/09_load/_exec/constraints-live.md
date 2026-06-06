# 라이브 제약 조회 결과 — ON CONFLICT 충돌키 권위 (round-5, read-only)

> 본 문서는 `_exec/`·`_exec_price/` SQL의 `ON CONFLICT` 충돌키가 **추측이 아니라 라이브 제약에서
> 읽은 것**임을 입증하는 권위 기록이다(GOAL §6.7·sql-idempotent-patterns §3). 조회는 전부
> read-only(`SELECT`/카탈로그). 2026-06-06, db=`railway`(PG 18.4). 비밀번호 노출 0.

## 1. PK / UNIQUE 제약 (적재 대상 테이블)

`pg_constraint` 조회 결과 (contype p=PK, u=UNIQUE):

| 테이블 | 제약명 | 타입 | 컬럼 | → ON CONFLICT 채택 |
|--------|--------|------|------|--------------------|
| `t_cod_base_codes` | `pk_t_cod_base_codes` | PK | `cod_cd` | `(cod_cd)` |
| `t_proc_processes` | `pk_t_proc_processes` | PK | `proc_cd` | `(proc_cd)` |
| `t_siz_sizes` | `pk_t_siz_sizes` | PK | `siz_cd` | `(siz_cd)` |
| `t_prd_product_materials` | `t_prd_product_materials_pkey` | PK | `prd_cd, mat_cd, usage_cd` | `(prd_cd, mat_cd, usage_cd)` |
| `t_prd_product_processes` | `t_prd_product_processes_pkey` | PK | `prd_cd, proc_cd` | `(prd_cd, proc_cd)` |
| `t_prd_product_bundle_qtys` | `t_prd_product_bundle_qtys_pkey` | PK | `prd_cd, bdl_qty` | `(prd_cd, bdl_qty)` |
| `t_prc_price_formulas` | `pk_t_prc_price_formulas` | PK | `frm_cd` | `(frm_cd)` |
| `t_prc_price_components` | `pk_t_prc_price_components` | PK | `comp_cd` | `(comp_cd)` |
| `t_prc_formula_components` | `t_prc_formula_components_pkey` | PK | `frm_cd, comp_cd` | `(frm_cd, comp_cd)` |
| `t_prc_component_prices` | `t_prc_component_prices_pkey` | PK | `comp_price_id` | `(comp_price_id)` ※ |
| `t_prd_product_price_formulas` | `t_prd_product_price_formulas_pkey` | PK | `prd_cd, frm_cd` | `(prd_cd, frm_cd)` |

전 테이블의 PK가 매니페스트 자연키와 일치 — 단 component_prices 만 예외(아래 ※).

## 2. component_prices 충돌키 결정 (※ — 핵심 분석)

`t_prc_component_prices` 는 PK 가 surrogate `comp_price_id`(bigint, **default 없음** = INSERT 시
명시값 필수)이고, **자연키 unique INDEX** 가 별도로 존재한다:

```
ux_t_prc_comp_prices_nat_key  UNIQUE (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
                                      coat_side_cnt, bdl_qty, min_qty)
  indnullsnotdistinct = f   ← NULLS DISTINCT (기본값, 라이브 확증)
```

**결정: 충돌키 = PK `(comp_price_id)`.** 근거:

- 자연키 인덱스가 `NULLS DISTINCT`라, 자연키 컬럼에 NULL 이 있는 행(적재본 2,108행 중 clr_cd 전건
  NULL·coat_side_cnt 전건 NULL·mat_cd 1,574행 NULL·siz_cd 795행 NULL·bdl_qty 1,993행 NULL)에서는
  `ON CONFLICT (자연키)`가 **발화하지 않는다** → 재실행 시 멱등성 깨짐(R1 위배).
- CSV 가 `comp_price_id` 결정적 명시값 제공(round-4 provenance, surrogate 1:1) + 라이브 live
  count=0 → PK 충돌키로 "같은 스크립트 2회" 멱등성을 NULL 분포와 무관하게 보장.
- 자연키 unique 인덱스는 **존속**(다른 comp_price_id·같은 차원 의미중복 2차 방어). 적재본 자연키
  intra-file 중복 0 확인 → 1차 적재 시 자연키 위반 위험 없음.

[검증자 확인 요망] 만약 후니 정책이 "같은 차원 재적재 시 PK 와 무관하게 1행 유지"라면, PK 충돌만으로는
다른 comp_price_id 로 재공급된 중복을 막지 못한다. 그 경우 자연키 unique 를 `NULLS NOT DISTINCT`로
바꾸는 ALTER 가 필요(= ddl-proposer 후보). 현 round-5 멱등성 정의("같은 스크립트 2회")에는 PK 가 정답.

## 3. FK 부모 라이브 실존 확증 (코드행·참조)

| FK 부모 코드값 | 라이브 | 용도 |
|---------------|--------|------|
| `USAGE.01`, `USAGE.02`, `USAGE.07` | 실존 | 05 materials.usage_cd |
| `QTY_UNIT.01/.02/.03` | 실존 | 09 bundle / qtyunit update-set |
| `FRM_TYPE.01`, `FRM_TYPE.02` | 실존 | 01 price_formulas.frm_typ_cd |
| `PRC_COMPONENT_TYPE.01~.05` | 실존 | 02 price_components |
| `PRC_COMPONENT_TYPE.06` | **부재(0)** | 단계00 코드행 선적재 대상(후니 등록) |
| `PROC_000084` (레이저커팅) | **부재(0)**, max live=PROC_000083 | 단계00a 코드행 선적재(후니 등록). 의존 완칼 14행=차단 |
| `SIZ_000501~510` | **부재(0)** | 단계00b 코드행 선적재(후니 등록) 신설 10 |
| `SIZ_000422` (원형35x35) | **실존** | 신설 아님 — 00_siz SQL 에서 제외(search-before-mint) |
| `MAT_000042/043/044/192` | 실존 | thickness update-set 대상/현재 |

## 4. 라이브 스키마 정합 — 조립 중 적발 (침묵 강제변환 0)

1. **`t_prd_product_processes` 에 `excl_grp_cd` 컬럼 부재.** 라이브 컬럼 = `prd_cd, proc_cd,
   mand_proc_yn, disp_seq, reg_dt, upd_dt, del_yn, del_dt`(ordinal 3 비어있음). 적재 CSV
   `06_t_prd_product_processes.csv` 헤더엔 `excl_grp_cd` 존재하나 **62행 전건 공란**(검증) →
   INSERT 에서 컬럼 제외(데이터 손실 0). 생성기에 비공란 가드 내장(비공란 시 예외→ddl-proposer).
2. **`t_prd_product_process_excl_groups` 테이블 라이브 부재**(`%excl%` 매칭 테이블 0). update-set
   `excl_groups_note`(1행)·`excl_link`(4행, target `excl_grp_cd`)는 **비실행** → blocked-and-gaps,
   ddl-proposer 라우팅(round-3 GAP-2 excl-group 모델 마이그레이션).
3. **`comp_price_id` default 없음** → INSERT 시 CSV 명시값 필수(생성기 반영).

## 5. 조회 SQL (재현용)

본 문서 수치는 아래 read-only 조회로 재현 가능:
- PK/UNIQUE: `pg_constraint` join `pg_attribute` (contype in 'p','u').
- 자연키 NULLS 플래그: `pg_index.indnullsnotdistinct`.
- FK 부모 실존: `SELECT cod_cd FROM t_cod_base_codes WHERE cod_cd IN (...)` 등.
- 컬럼: `information_schema.columns`.
