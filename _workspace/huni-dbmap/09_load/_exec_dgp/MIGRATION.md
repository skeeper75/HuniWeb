# 디지털인쇄 가격엔진 적재 실행본 (round-5)

> round-4/검증 GO 적재본(`02_mapping/digital-print-engine/`, gate `03_validation/digital-print-engine-gate.md` §0 **GO**, LOADABLE 147행)을
> 라이브 `t_*` 멱등 적재 SQL/로더로 실행본화한 산출물. **실제 COMMIT·DDL·siz채번 없음** — 인간 승인 하에 orchestrator 가 수행.
> 식별자/컬럼/코드/SQL 영어, 해석 한국어.

---

## 1. 적재 내용 — 테이블별 행수 · FK 위상정렬 순서

| 순서 | SQL 파일 | 대상 테이블 | 행수 | 멱등 가드 | FK 의존(이 단계를 고정하는 부모) |
|:----:|---------|-------------|:----:|-----------|--------------------------------|
| 00 | `00_resync_sequence.sql` | `t_prc_component_prices_comp_price_id_seq` | — | `setval` (idempotent) | 모든 INSERT 전 (04 충돌 방지) |
| 01 | `01_t_prc_price_formulas.sql` | `t_prc_price_formulas` | 6 | `ON CONFLICT (frm_cd) DO NOTHING` | `frm_typ_cd → t_cod_base_codes(FRM_TYPE.01)` 선존재 |
| 02 | `02_t_prc_price_components.sql` | `t_prc_price_components` | 1 | `ON CONFLICT (comp_cd) DO NOTHING` | `comp_typ_cd → t_cod_base_codes(PRC_COMPONENT_TYPE.03)` 선존재 |
| 03 | `03_t_prc_formula_components.sql` | `t_prc_formula_components` | 72 | `ON CONFLICT (frm_cd, comp_cd) DO NOTHING` | `frm_cd → 01` · `comp_cd → 02(COMP_PAPER) + 재사용 35` |
| 04 | `04_t_prc_component_prices.sql` | `t_prc_component_prices` | 49 | `INSERT … SELECT … WHERE NOT EXISTS (자연키 IS NOT DISTINCT FROM)` + **auto-IDENTITY** | `comp_cd → 02` · `siz_cd → SIZ_000499` · `mat_cd → 49 종이` 선존재 |
| 05 | `05_t_prd_product_price_formulas.sql` | `t_prd_product_price_formulas` | 19 | `ON CONFLICT (prd_cd, frm_cd) DO NOTHING` | `prd_cd → t_prd_products(19)` · `frm_cd → 01` 선존재 |
| | **합계** | | **147** | | |

**적재 순서 근거(price-engine-ddl §3 위상정렬):**
- [단계 0] comp_price_id IDENTITY 시퀀스 재동기화 (setval) — 04 auto-IDENTITY 충돌 방지. 모든 INSERT 전.
- [단계 1] 엔진 부모 헤더 01·02 (병렬 가능) — 자식보다 먼저.
- [단계 2] 엔진 자식 03·04 (단계1 후, 병렬 가능) — frm_cd/comp_cd 선존재 보장.
- [단계 3] 상품 바인딩 05 — prd_cd 선존재 + frm_cd→01.
- `apply.sql` 은 단일 `BEGIN…COMMIT` 안에서 00→05 순으로 `\i` 로드(중간 COMMIT 없음, 원자성).

> **[수정 2026-06-07 — 라이브 DRY-RUN 적발]** step 00 setval 추가. 라이브 확증: `comp_price_id`
> IDENTITY(BY DEFAULT)·시퀀스 `t_prc_component_prices_comp_price_id_seq` 가 stale(last_value=2 vs MAX=4805·count=3292).
> 04 가 comp_price_id 생략(auto-IDENTITY)이라 올바르나, 시퀀스가 1,2,…를 발급해 기존 행과 PK 충돌.
> → 모든 INSERT 전에 `setval('…',(SELECT COALESCE(MAX(comp_price_id),0) …),true)` 로 시퀀스를 MAX 로 재동기화.
> 라이브 2-pass DRY-RUN 실증: 용지비 49행이 comp_price_id **4806~4854** 발급(충돌 0), 2회차 0행(멱등), ROLLBACK 후 잔존 0.

## 2. 신규 mint vs 재사용

| 구분 | 키 | 개수 | 비고 |
|------|----|:----:|------|
| **신규 mint** | `frm_cd` = PRF_DGP_A · B · C · D · E · F | 6 | 라이브 부재 확인(read-only). DDL 무변경 코드행 INSERT |
| **신규 mint** | `comp_cd` = COMP_PAPER | 1 | 라이브 부재 확인. 용지비 component (PRC_COMPONENT_TYPE.03) |
| 재사용(선존재) | 35 component (인쇄/별색/코팅/후가공/완칼/접지/타공) | 35 | formula_components 가 참조, 라이브 35/35 확인 |
| 재사용(선존재) | 49 mat_cd (종이) | 49 | 용지비 단가 mat_cd, 라이브 49/49 확인 |
| 재사용(선존재) | 19 prd_cd | 19 | 바인딩 prd_cd, 라이브 19/19 확인 |
| 재사용(선존재) | SIZ_000499 (국4절 316x467) | 1 | 용지비 siz_cd. **신규 siz 0** |
| 재사용(선존재) | 부모 코드행 FRM_TYPE.01 · PRC_COMPONENT_TYPE.03 | 2 | 코드행 선적재 불요(이미 존재) |

→ **신규 mint = 7개(공식 6 + component 1) 코드행뿐. 신규 siz·신규 mat·DDL·코드행 선적재 0.**

## 3. component_prices(용지비) 멱등 가드 — 왜 ON CONFLICT 가 아닌가

라이브 read-only 확인 결과:
- 자연키 UNIQUE 인덱스 `ux_t_prc_comp_prices_nat_key(comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty)` 의
  **`indnullsnotdistinct = f`** = PostgreSQL 기본 **NULLS DISTINCT**.
- 용지비 49행은 `clr_cd / coat_side_cnt / bdl_qty / min_qty` 가 모두 **NULL**.
- NULLS DISTINCT 에서는 NULL ≠ NULL 로 취급 → `ON CONFLICT (자연키 8)` 가 **NULL 포함 행에 절대 걸리지 않음** → 재실행 시 중복 INSERT(R1 멱등 FAIL).

따라서 `INSERT … SELECT … WHERE NOT EXISTS ( … 자연키 IS NOT DISTINCT FROM … )` 가드를 사용:
- `IS NOT DISTINCT FROM` 은 NULL=NULL 을 TRUE 로 매칭 → 동일 자연키 행이 이미 있으면 SELECT 가 0행 → INSERT 0행.
- 2회차 실행 시 49행 전부 NOT EXISTS=false → **0행 INSERT (멱등 보장)**.

01/02/03/05 는 PK 가 자연키(NULL 없음)라 `ON CONFLICT (PK) DO NOTHING` 으로 안전(라이브 PK 확인:
`pk_t_prc_price_formulas=frm_cd` · `pk_t_prc_price_components=comp_cd` · `t_prc_formula_components_pkey=(frm_cd,comp_cd)` · `t_prd_product_price_formulas_pkey=(prd_cd,frm_cd)`).

**04 의 comp_price_id 는 step 00 setval 에 의존**: comp_price_id 는 surrogate PK·IDENTITY(BY DEFAULT)이며
04 가 컬럼을 생략(auto-IDENTITY)하므로 시퀀스가 발급한다. 라이브 시퀀스가 stale(§1 수정 박스)이라 step 00 의
setval 로 MAX 동기화 후에야 4806~ 발급(충돌 0). 자연키 NOT EXISTS 가드는 시퀀스와 독립적으로 멱등(중복 0).

## 4. reg_dt / upd_dt 처리 (round-5 함정 회피)

라이브 확인: 5테이블 모두 `reg_dt timestamp NOT NULL DEFAULT now()` · `upd_dt timestamp NULL`.
- INSERT 컬럼 목록에서 reg_dt/upd_dt 를 **omit** → reg_dt DEFAULT now() 발화.
- (명시 `NULL` 을 넣으면 DEFAULT 미발화 → NOT NULL 위반. 그래서 컬럼 자체를 안 쓴다.)

## 5. undo (역연산) 전략

`undo.sql` = 적재한 신규 키만 정밀 DELETE, FK 의존 역순(자식 먼저):
1. `t_prc_component_prices` WHERE comp_cd='COMP_PAPER' AND siz_cd='SIZ_000499' AND apply_ymd='2026-06-01'
2. `t_prc_formula_components` WHERE frm_cd LIKE 'PRF_DGP_%'
3. `t_prd_product_price_formulas` WHERE frm_cd LIKE 'PRF_DGP_%'
4. `t_prc_price_components` WHERE comp_cd='COMP_PAPER'  (위 1/3 삭제 후라 RESTRICT 안전)
5. `t_prc_price_formulas` WHERE frm_cd LIKE 'PRF_DGP_%'  (위 2/3 삭제 후라 RESTRICT 안전)

- 기존 라이브 행은 신규 키 한정 WHERE 로 보호. DELETE 는 본질적으로 멱등(이미 없으면 0행).
- 단일 `BEGIN…COMMIT`. `undo.sh` 기본 DRY-RUN(롤백), `--commit` 인간 승인.

## 6. DRY-RUN 사용법

```bash
cd _workspace/huni-dbmap/09_load/_exec_dgp

./backup.sh            # (권장 선행) before-state 캡처: 신규키 부재 + 5테이블 현행 행수
./apply.sh             # DRY-RUN: apply.sql 실행 후 강제 ROLLBACK. DB 무변경.
./apply.sh             # 2회차 DRY-RUN: 멱등성 실증(2회차 INSERT 0행이어야 함, R1)
./apply.sh --commit    # (인간 승인) 실제 COMMIT. 147행 라이브 적재.
./undo.sh              # DRY-RUN: 역연산 롤백 확인
./undo.sh --commit     # (인간 승인) 적재 되돌리기
```

- 기본은 항상 DRY-RUN(롤백). `--commit` 은 인간 승인 플래그.
- 자격증명 `.env.local`(RAILWAY_DB_*)만 사용, 비밀번호 stdout/파일 미노출.
- 멱등성(R1)은 `./apply.sh` 를 한 트랜잭션 내 2회 적용했을 때 2회차 0행으로 검증.

### 라이브 2-pass DRY-RUN 실증 (수정 검증, 2026-06-07)

롤백전용 단일 트랜잭션 내 2회 적재 + 강제 ROLLBACK(COMMIT 0, DB 영구 무변경):

| 점검 | PASS 1 | PASS 2 | 판정 |
|------|:------:|:------:|:----:|
| setval (시퀀스→MAX) | 4805 | 4854 | OK (재동기화 발화) |
| formulas / components / formula_components / 용지비 / bindings | 6/1/72/49/19 | 6/1/72/49/19 | **멱등 (2회차 0행)** |
| 용지비 comp_price_id 범위 | 4806~4854 | — | **충돌 0** (>MAX 4805) |
| ROLLBACK 후 잔존 | — | 0 | DB 영구 무변경 |

→ step 00 setval + 04 auto-IDENTITY + 자연키 NOT EXISTS 가드 실증 완료. **2회차 0행(멱등), 충돌 0.**

## 7. 차단/제외 (적재 대상 아님 — 정직 분리)

| 항목 | 위치 | 사유 |
|------|------|------|
| 용지비 3절5+투명4 | `*_BLOCKED_siz.csv` | 3절(330x660)·투명(315x467) siz 라이브 부재 — 채번 대기 |
| 바인딩 019/030/049 | `*_BLOCKED_siz.csv` | 출력용지규격(plate)이 작업사이즈로 적재 → 디지털인쇄비 미커버. plate 교정/인쇄비 단가 적재 후 복귀 |
| 박(foil) 6슬롯 | `*_BLOCKED_foil.csv` | foil comp 라이브 부재 |
| 048 접지리플렛 재바인딩 | (별도 마이그레이션) | PK충돌 회피 위해 DELETE PRF_FOLD_SUM+INSERT PRF_DGP_E 필요 — 별도 인간 승인 |

→ 본 실행본은 **LOADABLE 147행만**. BLOCKED 는 적재 SQL 에 포함하지 않음(repackaging 금지).

## 8. 재현성 · 손편집 금지

모든 SQL 은 `gen_load_sql.py` 가 입력 CSV 에서 생성. 입력이 같으면 byte-identical 출력.
SQL 을 손편집하지 말고, 매핑이 바뀌면 `python3 gen_load_sql.py` 재실행. provenance 는 `migrate.provenance.csv`(sql_file→source_csv:row→natural_key).
