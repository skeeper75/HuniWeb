# 적재 실행 매니페스트 — round-5 상품마스터 (`_exec/`)

> round-4 GO 적재본(`09_load/_assembled/`, 즉시 384행 + 코드행 11 + update-set)을 **멱등 실행
> SQL + 로더**로 완성한 산출물. 실제 `COMMIT`·DDL은 **인간 승인** 대상 — 본 트랙은 산출 + 롤백
> DRY-RUN까지. 권위: `docs/goal-2026-06-06-02.md` · `_assembled/load-manifest.md`(GO) ·
> `03_validation/load-readiness-gate.md`(GO) · `constraints-live.md`(충돌키 권위).
> 재매핑 0 — round-4 CSV를 조립·순서화·래핑·멱등화만. 식별자/SQL 영어, 설명 한국어.

## 0. 한 줄 현황

상품마스터 즉시 적재 **384행**(materials 316·processes 62·bundle 6) + 코드행 선적재 **11행**(proc 1
신설 + siz 10 신설; SIZ_000422는 라이브 실재라 신설 제외) + update-set **289행**(qtyunit 244·nonspec
25·thickness 20)을 FK 위상정렬 단일 트랜잭션 멱등 SQL로 산출. **update-set 6종 중 3종은 비실행**으로
차단 분리(uv 20·excl_link 4·excl_groups_note 1 = 25행, 라이브 컬럼/테이블 부재 또는 미확정 placeholder).
차단 36 + GAP 2 + conditional 9는 round-4대로 미포함(재포장 금지).

## 1. 실행 순서 (FK 위상정렬) + ON CONFLICT 충돌키 — 라이브 제약 매핑

| 단계 | 파일 | 대상 테이블 | 행수 | ON CONFLICT 키 | 백킹 라이브 제약 | 이 위치를 강제하는 FK 엣지 |
|------|------|------------|------|----------------|-----------------|---------------------------|
| 00a | `00_proc_processes.sql` | `t_proc_processes` | 1 | `(proc_cd)` | PK `pk_t_proc_processes` | (완칼 14행 FK 부모 — 단 14행은 차단) |
| 00b | `00_siz_sizes.sql` | `t_siz_sizes` | 10 | `(siz_cd)` | PK `pk_t_siz_sizes` | (sticker 066 원형 size link FK 부모 — 단 link는 차단) |
| 05 | `05_t_prd_product_materials.sql` | `t_prd_product_materials` | 316 | `(prd_cd, mat_cd, usage_cd)` | PK `t_prd_product_materials_pkey` | `mat_cd→t_mat`, `usage_cd→t_cod`, `prd_cd→t_prd_products` |
| 06 | `06_t_prd_product_processes.sql` | `t_prd_product_processes` | 62 | `(prd_cd, proc_cd)` | PK `t_prd_product_processes_pkey` | `proc_cd→t_proc`, `prd_cd→t_prd_products` |
| 09 | `09_t_prd_product_bundle_qtys.sql` | `t_prd_product_bundle_qtys` | 6 | `(prd_cd, bdl_qty)` | PK `t_prd_product_bundle_qtys_pkey` | `bdl_unit_typ_cd→t_cod`, `prd_cd→t_prd_products` |
| 09b | `09b_correction_bundle_qtys.sql` | `t_prd_product_bundle_qtys` | 18 | `(prd_cd, bdl_qty)` | PK `t_prd_product_bundle_qtys_pkey` | `bdl_unit_typ_cd→t_cod`, `prd_cd→t_prd_products` (09 와 동일 FK) |
| 90 | `90_update_set.sql` | `t_prd_products`·`t_prd_product_materials` | 289 (UPDATE) | (UPDATE WHERE prd_cd[+key]) | — | INSERT 단계 이후(기존 행 갱신) |

상위 래퍼 = `apply.sql`(`BEGIN; \i 00a … \i 90`). COMMIT/ROLLBACK은 로더가 주입.

> **00b siz 신설 10행:** round-4 CSV 11행 중 `SIZ_000422`(원형35x35, `_mint=REUSE`)는 라이브
> 실재라 신설 SQL 에서 제외(search-before-mint). 신설 SIZ_000501~510 만 INSERT.
> **06 processes:** 라이브에 `excl_grp_cd` 컬럼 부재 → INSERT 컬럼에서 제외(적재 CSV 62행 전건
> 공란이라 손실 0). excl_grp 연결은 차단된 update-set 으로 분리(§3).

## 2. 멱등성·원자성·재현성

- **멱등(R1):** 5개 INSERT 파일 전건 `ON CONFLICT (PK) DO NOTHING`(충돌키=라이브 PK, `constraints-live.md`).
  90 update-set 은 `WHERE … IS DISTINCT FROM target`(qtyunit/nonspec) 및 PK 키변경 무매치(thickness)로
  2회차 0행. → 같은 스크립트 2회 실행 시 2회차 행변경 0.
- **원자성(R2):** `apply.sql` 단일 `BEGIN` + `ON_ERROR_STOP=1`. 임의 문 실패 → 전체 롤백. 테이블별
  파일에 `BEGIN/COMMIT` 없음(중첩·부분커밋 경로 0). 종결 COMMIT/ROLLBACK은 로더 단일 세션 주입.
- **재현성(R3·G8):** 전 SQL은 `gen_load_sql.py`가 CSV에서 생성(손편집 0). 행수 어서트 내장
  (코드행 1+10·적재 384·update-set 289). per-row provenance = `*.provenance.csv`.

## 2-bis. 정정(보완) 묶음수 통합 — 단계09b (2026-06-06 추가)

Jun-4 SIZE_NAME_NOISE 정정에서 **GO 판정됐으나 round-5 _exec 에 통합되지 않은 고아 적재본**
(`02_mapping/correction/load/t_prd_product_bundle_qtys.csv`, 18행 9상품)을 단계09b 로 보완 통합.

- **묶음수 적재 총량 = round-5 6행(PRD_000160/163) + 정정 18행(9상품: PRD_000001/002/003/004/005/
  009/011/066/198) = 24행.** 두 집합은 prd_cd 가 완전히 분리(교집합 0) — 중복 적재 없음.
- 생성기: `gen_correction_bundle_sql.py`(재현 가능, 손편집 금지). 패턴은 단계09 와 동일
  (`ON CONFLICT (prd_cd, bdl_qty) DO NOTHING`, `reg_dt` 공란→`DEFAULT`).
- FK 라이브 read-only 검증 완료: `prd_cd→t_prd_products` 9/9 실존 · `bdl_unit_typ_cd→QTY_UNIT`
  .01/.02/.04 전부 실존. **PK 충돌:** PRD_000001/50·PRD_000002/50 라이브 선존 → `DO NOTHING`
  으로 no-op(멱등성 입증). 나머지 16행 신규 INSERT.
- **정정 치수(`t_siz_sizes_dims`)는 SKIP 유지** — 라이브가 이미 정확한 work/cut 치수 보유
  (77/77 NOT NULL), cm 2건은 라이브가 옳음(검증 §3 권위). 적재 시 회귀 위험이라 미포함.
- apply.sql 자동 편입은 보류(round-4 GO 매니페스트 권위 보존) — 검증자 R1~R6 + 인간 승인 시
  09 직후에 `\i 09b_correction_bundle_qtys.sql` 추가. 본 트랙은 SQL 파일 생성·매니페스트 기록까지.

## 3. 제외 (차단/GAP/비실행 update-set — 적재 SQL 미포함, 재포장 금지)

`_assembled/blocked-and-gaps.md` + 본 트랙 추가 적발 권위.

### 3-1. round-4 차단 (그대로 미포함) — 36행 + GAP 2 + conditional 9
| 항목 | 규모 | 사유 / 해소 조건 |
|------|------|-----------------|
| 아크릴 완칼 → 레이저커팅 의존 | 14행 | 단계00a `PROC_000084` 후니 등록 후 active |
| addon template 부재 | 4행 | 후니 template 등록 |
| 디자인캘린더 5신규상품 연결 | 18행 | 후니 prd_cd 실번호 부여 |
| goods-pouch 비치수 size | GAP(47상품) | ddl-proposer 제안서(마스터 모델링) |
| conditional(016 proc·calendar mat·151 부착) | 9행 | 적재 직전 라이브 SELECT 재확인 |

### 3-2. update-set 중 비실행 3종 (round-5 적발 — builder가 SQL 화 거부) — 25행
| update-set | 행수 | 비실행 사유 | 라우팅 |
|------------|------|------------|--------|
| `t_prd_product_print_options_uv_update` | 20 | target_print_side 가 미확정 placeholder `(실 단/양면 미상 — 컨펌 D-AC-3)` — 실값 아님. UPDATE 시 데이터 오염 | 후니 D-AC-3 확정 후 builder 재생성 |
| `t_prd_product_processes_excl_link_update` | 4 | 라이브 `t_prd_product_processes`에 `excl_grp_cd` 컬럼 부재 → SET 불가 | ddl-proposer(excl-group 모델) |
| `t_prd_product_process_excl_groups_note_update` | 1 | 라이브에 해당 테이블 부재 | ddl-proposer(excl-group 모델) |

> [정직 표기] update-set 314행 중 실행가능 289행만 SQL 화. 25행은 비실행으로 차단. 침묵 강제변환·
> placeholder UPDATE·없는 컬럼 INSERT 0. round-4 update-set 총량(314) = 289(실행) + 25(차단) 정합.

## 4. 실행법 (로더)

```bash
cd 09_load/_exec
./apply.sh            # DRY-RUN(기본) — 롤백전용. 적재 시도 후 ROLLBACK. 영구변경 0.
./apply.sh commit     # 영구 적재 — 인간 승인 시에만. 본 하네스 자동 실행 금지.
python3 gen_load_sql.py   # SQL 재생성(멱등)
```

`.env.local`(chmod 600)에서 `RAILWAY_DB_*` 로드 — 비밀번호 echo·로그·`_workspace` 기록 0.

## 5. 인간 승인 체크포인트

1. **라이브 DRY-RUN 실행 직전** — lead 승인(롤백전용이라도 쓰기 트랜잭션).
2. **코드행 선적재 적용** — 후니가 `PROC_000084`·`SIZ_000501~510` 라이브 등록(실번호 다를 수 있음 →
   builder가 의존 적재행 코드값 교체 후 부분 재생성).
3. **실제 COMMIT** — R1~R6 + G1~G9 PASS 후 인간 승인.

## 6. 검증 인계 (R6 — 자기승인 금지)

본 산출물은 `dbm-validator`의 R1~R6 + 롤백전용 라이브 DRY-RUN 대상. builder는 자기 승인하지 않는다.
게이트 결과 → `03_validation/load-execution-gate.md`. 입력: 본 매니페스트 + `*.sql` + `apply.sql` +
`apply.sh` + `*.provenance.csv` + `constraints-live.md` + `gen_load_sql.py`.
