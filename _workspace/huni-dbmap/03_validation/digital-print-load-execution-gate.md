# round-5 적재 실행본 게이트 — 3트랙 라이브 실행 가능성·멱등성 (R1~R6)

> 검증자: dbm-validator (빌더와 분리 — R6 자기승인 금지). 작성 2026-06-07.
> 권위: `docs/goal-2026-06-06-02.md` §8·R1~R6 + dbm-load-execution 스킬 §3 Gate.
> 방법: 라이브 read-only + **롤백전용 DRY-RUN(BEGIN…ROLLBACK)만**. COMMIT·DDL·영구쓰기 0.
> 검증 대상: ① 디지털인쇄 `_exec_dgp/` 147행 ② ENV봉투 `_exec_env/` 40행 ③ GP원형 `_migrate_gp_circle/` 121행.

---

## 종합 판정: **GO** (3트랙 모두 R1~R6 전건 PASS)

3개 트랙 모두 라이브 롤백전용 DRY-RUN 2-pass 멱등 실증 통과 — 1회차 예상행수 정확 삽입, 2회차 델타 0,
제약위반 0, FK 고아 0, 영구변경 0. 1차 DRY-RUN에서 적발됐던 결함(IDENTITY 시퀀스 stale·명시 ID under-load)이
빌더 수정(setval 재동기화 + auto-IDENTITY + 자연키 NOT EXISTS 가드)으로 **라이브에서 실제로 해소됨**을 독립 재확증.

**COMMIT 권고 순서 (인간 승인 시):** ENV(최단·무리스크) → GP원형 → 디지털인쇄. 근거는 §종합 하단.

---

## 트랙별 R1~R6 표

| Gate | 디지털인쇄(_exec_dgp) | ENV봉투(_exec_env) | GP원형(_migrate_gp_circle) |
|------|----------------------|--------------------|----------------------------|
| **R1 멱등성** | PASS — 2-pass 델타 0 (147→0) | PASS — 2-pass 델타 0 (40→0) | PASS — 2-pass 델타 0 (121→0) |
| **R2 트랜잭션 원자성** | PASS — 단일 BEGIN…COMMIT, ON_ERROR_STOP, 중간 COMMIT 0 | PASS — 동일 + guard0/어서션 | PASS — 동일, 주입실패 시 전체 abort 실증 |
| **R3 실행가능성** | PASS — 00~05 무중단 완주, 문법오류 0 | PASS — migrate 완주 | PASS — 00~03 완주 |
| **R4 DDL 정합** | PASS — DDL 0건, mint=t_* INSERT(PRF_DGP 6·COMP_PAPER 1) | PASS — DDL 0·mint 0 | PASS — DDL 0, mint=t_* INSERT(siz 10) |
| **R5 라이브 DRY-RUN** | PASS — 제약위반 0·FK고아 0 | PASS — 제약위반 0·FK고아 0 | PASS — 제약위반 0·FK고아 0 |
| **R6 생성·검증 분리** | PASS — 검증자≠빌더, 실결함 재확증 | PASS | PASS |

---

## R1 멱등성 — 라이브 2-pass 실측 (핵심)

같은 롤백 트랜잭션 안에서 적재 본문을 2회 연속 실행 후 ROLLBACK. **2회차 삽입 0 = 멱등.**

### 디지털인쇄 (`_exec_dgp/`, 기대 147행)
| 테이블 | base | pass1 | pass2 | ins_pass1 | ins_pass2 |
|--------|------|-------|-------|-----------|-----------|
| t_prc_price_formulas (frm) | 0 | 6 | 6 | **6** | **0** |
| t_prc_price_components (comp) | 0 | 1 | 1 | **1** | **0** |
| t_prc_formula_components (fc) | 0 | 72 | 72 | **72** | **0** |
| t_prc_component_prices (cp) | 0 | 49 | 49 | **49** | **0** |
| t_prd_product_price_formulas (ppf) | 0 | 19 | 19 | **19** | **0** |
| **합계** | 0 | **147** | 147 | **147** | **0** |

- 멱등 가드: 01/02/03/05 = `ON CONFLICT (PK) DO NOTHING`; 04 = `INSERT … SELECT … WHERE NOT EXISTS` 자연키 8컬럼 `IS NOT DISTINCT FROM`(49행 전건 8컬럼 비교 정적확인).
- NULL 자연키(clr/coat/bdl/min=NULL) 멱등 차단: 라이브 자연키 UNIQUE 인덱스 `ux_t_prc_comp_prices_nat_key.indnullsnotdistinct=f`(NULLS DISTINCT) → ON CONFLICT 무력 → `IS NOT DISTINCT FROM` 가드 필수, 2회차 0행으로 실증.

### ENV봉투 (`_exec_env/`, 기대 40행)
| 테이블 | base | pass1 | pass2 | ins_pass1 | ins_pass2 |
|--------|------|-------|-------|-----------|-----------|
| t_prc_component_prices (id 1713~1752) | 0 | 40 | 40 | **40** | **0** |

- 멱등 가드: 명시 `comp_price_id` + `ON CONFLICT (comp_price_id) DO NOTHING`. 라이브 1713~1752 free(점유 0 read-only 확인)라 ID 충돌 없음 → 1회차 40 삽입, 2회차 40 전건 skip.

### GP원형 (`_migrate_gp_circle/`, 기대 121행)
| 테이블 | base | pass1 | pass2 | ins_pass1 | ins_pass2 |
|--------|------|-------|-------|-----------|-----------|
| t_siz_sizes (siz 501~510) | 0 | 10 | 10 | **10** | **0** |
| t_prc_component_prices (GP 501~510) | 0 | 100 | 100 | **100** | **0** |
| t_prd_product_sizes (066 link) | 0 | 11 | 11 | **11** | **0** |
| **합계** | 0 | **121** | 121 | **121** | **0** |

- 멱등 가드: 01 siz=`ON CONFLICT (siz_cd) DO NOTHING`; 02 가격=auto-IDENTITY + 자연키 8컬럼 NOT EXISTS 가드(100행 전건 8컬럼); 03 link=`ON CONFLICT (prd_cd, siz_cd) DO NOTHING`.

---

## 예상행수 정확 적재 (under-load 0 검증)

| 트랙 | 기대 | 1회차 실측 | 판정 |
|------|------|-----------|------|
| 디지털인쇄 | 147 (6+1+72+49+19) | 147 | ✅ 정확 |
| ENV봉투 | 40 | 40 | ✅ 정확 |
| GP원형 | 121 (10+100+11) | 121 | ✅ 정확 |

**GP under-load 결함 해소 재확증:** 1차 DRY-RUN에서 GP 100 가격행이 명시 ID(2956~3065) 중 10개가 라이브
점유로 ON CONFLICT(comp_price_id) silently skip → 90행 under-load였던 결함을, auto-IDENTITY+setval 재동기화로
전환 후 **100행 전건 4806~4905 신규 발급, 충돌 0** 실측. 자연키 NOT EXISTS 가드로 2회차도 0행.

---

## R5 라이브 DRY-RUN — 제약 위반 목록: **위반 0** (전 트랙)

ON_ERROR_STOP=1 트랜잭션이 무중단 완주 = 타입/길이/NOT NULL/CHECK/FK/PK/UNIQUE 전건 통과. 추가 어서션(적재 후 롤백 전):

| 트랙 | FK 고아 어서션 | 결과 |
|------|---------------|------|
| 디지털인쇄 | cp.siz / cp.mat / fc.comp / ppf.prd | **전건 0** |
| ENV봉투 | cp.siz / cp.mat / cp.comp | **전건 0** |
| GP원형 | cp.siz / link.siz / cp.mat | **전건 0** |

### FK 부모 선존재 (라이브 read-only 재확인)
- **디지털인쇄:** FRM_TYPE.01=1 · PRC_COMPONENT_TYPE.03=1 · SIZ_000499=1 · 재사용 comp_cd 35종=35 · 종이 mat_cd 49종=49 · 바인딩 prd_cd 19종=19.
- **ENV:** COMP_ENV_MAKING=1 · siz SIZ_000191~194(del_yn=N)=4 · mat MAT_000159/168=2.
- **GP:** COMP_GANGPAN_PRINT=1 · mat MAT_000084/153=2 · PRD_000066=1 · SIZ_000422(재사용)=1.

### t_siz_sizes 제약 (GP siz 10 적합)
- NOT NULL 6: siz_cd, siz_nm, impos_yn, use_yn, reg_dt, del_yn — GP 01 전건 명시(reg_dt=now()·del_yn='N'·impos_yn='N'·use_yn='Y') 충족.
- CHECK 3: impos_yn/use_yn/del_yn ∈ {Y,N} — GP 01 사용값 'N'/'Y'만, 충족.

---

## R4 DDL 정합 — 본 3트랙 DDL 0건

세 트랙 모두 **DDL 없음**(전부 `t_*` INSERT). 신규 mint은 코드행/master-data INSERT(DDL 아님)임을 확인 — t_* 화이트리스트 준수:

| 신규 mint | 종류 | 라이브 부재 재확인(중복mint 아님) |
|-----------|------|----------------------------------|
| PRF_DGP_A~F (6) | t_prc_price_formulas INSERT | dgp_frm_exists=0 ✅ |
| COMP_PAPER (1) | t_prc_price_components INSERT | comp_paper_exists=0 ✅ |
| SIZ_000501~510 (10) | t_siz_sizes master-data INSERT | gp_siz_exists=0 ✅ |

- search-before-mint: GP siz는 라이브 max=SIZ_000500, 신규 501~510 부재 확인. 35mm=SIZ_000422 재사용(미포함). 면적매트릭스(511~721)와 불교차.
- **인간 승인 대상:** PRF_DGP·COMP_PAPER 코드행 등록 + SIZ_000501~510 master-data 등록은 후니 라이브 등록 결정(propose ≠ apply).

---

## R6 생성·검증 분리 + 적발/재확증 사항

검증자(본인)는 빌더(`gen_*.py` 작성자)와 분리. 라이브 SELECT/DRY-RUN으로 다음을 독립 확증·재적발:

1. **[재확증] 시퀀스 상태가 빌더 코멘트와 다름** — 빌더는 "stale(last_value=2)"라 적었으나 현 라이브
   `seq_last_value=4905`, `MAX=4805`. 그래도 setval(MAX)로 재동기화하므로 결과 동일·안전. 4806~4905
   구간 라이브 점유 0 확인 → setval이 시퀀스를 MAX로 되돌려도 04/02 auto-IDENTITY 충돌 0(무해).
2. **[재확증] GP under-load 결함 해소** — 명시 ID(2956~3065) 방식의 silent skip→90행 under-load를
   auto-IDENTITY+자연키 가드로 전환, 100행 전건 발급 실측. 1차 결함이 라이브에서 실제로 해소됨.
3. **[재확증] DGP IDENTITY 충돌 해소** — 04가 auto-IDENTITY+NOT EXISTS 가드로 49행 4806~ 발급, 2회차 0.
4. **[확증] 자연키 가드 8컬럼 완전성** — 04(49)·GP02(100) 전 가드가 8개 자연키 컬럼을 빠짐없이
   `IS NOT DISTINCT FROM`으로 비교(정적 분석). NULL 차원 멱등 차단 근거(NULLS DISTINCT 인덱스) 라이브 확인.
5. **[확증] R2 원자성 주입 테스트** — GP 01 siz 10 적재 후 의도적 실패 주입 → 전체 abort, 라이브 siz 잔존 0.
6. **[확증] 영구변경 0** — DRY-RUN 후 모든 신규키(DGP/GP/ENV) 라이브 0건 재확인.

---

## 잔존 결함: **없음 (BLOCKER/MAJOR 0)**

검증 과정에서 실결함 0건. 빌더의 1차 DRY-RUN 수정이 라이브에서 정확히 작동함을 실증. 비차단 관찰만:

- **[관찰·무해] setval 시퀀스 갭** — 현 시퀀스 4905가 MAX 4805보다 100 앞섬(이전 DRY-RUN setval 누적
  부작용). 실제 COMMIT 시 step 00 setval이 MAX로 재동기화하므로 무관. 4806~4905 구간 미점유로 충돌 0.
  (실제 COMMIT 직전 step 00 setval이 비트랜잭션 부작용이 될 수 있으나, MAX 동기화 방향이라 해롭지 않음.)

---

## 종합 GO/NO-GO + COMMIT 순서 권고

### 판정: **GO** — 3트랙 모두 COMMIT 가능(인간 승인 시)

각 트랙은 ① 예상행수 정확 적재 ② 2-pass 멱등(2회차 0행) ③ 제약위반·FK고아 0 ④ 단일 트랜잭션 원자성
⑤ 영구변경 0(롤백)을 라이브에서 실증. R1~R6 전건 PASS.

### COMMIT 순서 권고 (인간 승인 하에)
1. **ENV봉투 (최우선)** — 40행, siz/바인딩/코드행 mint 0(가격행 ONLY), 명시 ID free, 최단·무리스크.
2. **GP원형** — 121행, 신규 siz 10 master-data 등록 동반(인간 승인 필요), setval 재동기화 포함.
3. **디지털인쇄** — 147행, 신규 코드행 mint 7건(PRF_DGP 6+COMP_PAPER 1) 등록 동반(인간 승인 필요),
   가장 많은 부모/배선 의존. 가격조회 정상화 효과 최대.

### COMMIT 전 필수 (인간 승인 절차)
- 코드행/master-data 등록 승인: PRF_DGP_A~F·COMP_PAPER(DGP) + SIZ_000501~510(GP).
- `backup.sh`로 before-state 백업 후 `apply.sh --commit`(각 트랙 디렉토리에서 실행).
- 본 게이트는 **COMMIT 미수행** — 실제 적재는 orchestrator가 인간 승인 하에.
