# round-5 적재 실행 게이트 — 일반현수막(PRD_000138) CPQ 옵션레이어 v2 + 마스터 mint

> 대상 패키지: `09_load/_exec_silsa_cpq/` (dbm-load-builder 빌드) · 게이트: dbm-validator(독립·R6)
> 권위: `10_configurator/silsa-option-layer-v2.md`(옵션 STRUCTURE) · `00_schema/code-identifier-strategy.md`(코드 규약, 2026-06-09 사용자 비준 D1~D5) · `docs/goal-2026-06-06-02.md`(round-5)
> 검증 기준: 라이브 read-only 실측 + 라이브 트리거 소스 직접 덤프(2026-06-09). **NEVER COMMIT** — 본 게이트는 쓰기 0(읽기전용 SELECT + 트리거/스키마 덤프만).
> **이 패키지는 라이브 운영 DB 최초의 실 CPQ 옵션레이어 적재**(option_items 전역 0행) + 마스터 5행 mint → 적재부담 게이트.

## 종합 판정: **GO (조건부)** — 로컬+읽기전용 라이브 전건 PASS. 라이브 롤백전용 DRY-RUN(R5 실행)만 리드 승인 대기.

43행(mint 5 + 링크 7 + 그룹 2 + 옵션 11 + 아이템 18) COMMIT-ready. 결함 1건은 MINOR(문서 카운트 오기)로 적재 무영향. 차단 1건(R-GAKMOK constraint)·CONFIRM 2건은 정직 분리 확인.

---

## G1~G9 carry-forward (round-4/round-5 권위 재확인)

| Gate | 의미 | 재확인 | 근거 |
|------|------|:--:|------|
| G1 화이트리스트 | 전 대상 t_* | PASS | 7개 대상 전부 `t_mat_materials`·`t_proc_processes`·`t_prd_product_*`. Django/non-t_ 0. |
| G2~G5 타입/NOTNULL/CHECK/FK | 로컬+라이브 정합 | PASS | R3/R5에서 재실증(아래). |
| G6 DRY-RUN | 롤백전용 | DEFER→R5 | 리드 승인 시 실행. |
| G7 PK 유일성 | CSV 내 중복 0 | PASS | 43행 PK(자연키) 유일 — R3 INSERT 카운트 4+1+6+1+2+11+18=43 일치. |
| G8 적재순서 | FK 위상 | PASS | R2/순서 검증(아래). |
| G9 독립검증 | builder≠validator | PASS | 본 게이트가 builder 자가로그 미신뢰·전건 재현(R6). |

---

## R1~R6 (round-5)

| Gate | 판정 | 근거(라이브 실측/파일·라인) | 라우팅 |
|------|:--:|------|------|
| **R1 멱등성** | **PASS(로컬 증명)** | 전 8개 INSERT 파일이 코드 리터럴이 아닌 **이름기반 `WHERE NOT EXISTS`** 가드(`01:WHERE…mat_nm`·`05:opt_grp_nm`·`06:opt_grp_cd+opt_nm`·`03/04/07:자연키`). 부모 코드/FK는 이름→코드 서브쿼리로 *재해결*(재실행 시 새 코드 발급 0·자식 FK 무단절). PK=mat_cd 등 라이브 실측과 가드 정합. ON CONFLICT 미사용(surrogate 코드는 매 생성 변동 → D2 비준대로 이름키 채택). 라이브 2-pass 실집행은 R5에 위임. | — |
| **R2 원자성** | **PASS** | `apply.sql`: 단일 `BEGIN;`(L12)·중간 COMMIT/savepoint 0·`\set ON_ERROR_STOP on`(L11). `apply.sh`: `-v ON_ERROR_STOP=1`(L24) + `-f apply.sql -c "ROLLBACK\|COMMIT"`. `-f` 내 임의 문 실패 시 ON_ERROR_STOP로 psql 즉시 종료 → 후행 `-c COMMIT` 미실행(또는 aborted tx의 COMMIT=ROLLBACK) → **half-load 불가**. 중간 COMMIT 경로 없음(grep 확인: SQL 내 COMMIT/CREATE/ALTER = 주석 1줄뿐). | — |
| **R3 실행성** | **PASS** | 7개 대상 테이블 컬럼셋 전건 라이브 `information_schema` 대조 일치(85컬럼). **reg_dt = NOT NULL DEFAULT now()** 7테이블 전부 → 패키지가 reg_dt **컬럼 생략** → DEFAULT 발화(round-5 reg_dt 결함 교훈 반영). NOT NULL 컬럼(ref_key1·mand_proc_yn·dflt_yn·opt_grp_nm·use_yn) 전건 명시 공급. proc.use_yn(default 없음 NOT NULL)='Y' 공급. varchar 길이 적합(mat_nm 200·opt_nm 100·note 500). | — |
| **R4 mint 정직성** | **PASS** | 라이브 `MAX(mat_cd)=MAT_000336`·`MAX(proc_cd)=PROC_000083`·`MAX(opt_grp_cd)=OPT-000002`·`MAX(opt_cd)=OPV-000005` 실측 → 부여 코드 MAT_000337~340/PROC_000084/OPT_000003~004/OPV_000006~016 **충돌 0·정확**. search-before-mint: 큐방·각목(2)·봉제사·열재단 라이브 **0행(부재) 재증명** → mint 정당(발명-over-existing 0). 끈 MAT_000070·양면테입 MAT_000069 = 라이브 EXISTS(del_yn=N) → LINK only. PROC 079/080/081 EXISTS + PRD_000138 기링크 → 재적재 안 함(step04는 열재단만, 079/080/081은 NOT EXISTS delta 0). 신규 코드 separator `_` 통일(D3 비준). DDL 0(CREATE/ALTER 0). | — |
| **R5 라이브 DRY-RUN(트리거)** | **PASS(결정론적 증명)·실집행 리드승인 대기** | 라이브 트리거 `fn_chk_opt_item_ref` 소스 **직접 덤프**: `.03`=`t_prd_product_materials WHERE prd_cd AND mat_cd=ref_key1 AND usage_cd=ref_key2`·`.04`=`t_prd_product_processes WHERE prd_cd AND proc_cd=ref_key1`. 패키지 18 option_items 디스패치 정합: .03 8행 전부 ref_key2=`USAGE.07` 공급·.04 10행 전부 ref_key2=NULL(트리거가 .04는 ref_key2 무시). 같은 트랜잭션 03(자재링크 6)·04(공정링크: 079/080/081 기존+열재단 신규)가 07 선행 → 트리거 EXISTS 전건 충족. 트리거 ENABLED('O') 확인. **제약위반 예상 0**. 모든 FK 타깃 라이브 실재(MAT_TYPE.07 부속·USAGE.07 공통·SEL_TYPE.01 단일·OPT_REF_DIM.03/.04 + PRD_000138 일반현수막 use_yn=Y). 실 `BEGIN…ROLLBACK` 집행은 쓰기 트랜잭션이라 **리드 승인 후 1회**. | — |
| **R6 독립성** | **PASS** | builder(_exec_silsa_cpq 조립)≠validator(본 게이트). builder 자가 DRY-RUN 로그 미신뢰·라이브 MAX/부재/트리거소스/스키마 전건 독립 재측정. **실결함 1건 발굴**(F-1 아래). | — |

---

## 멱등성 증명(R1) — 가드 검증

- pass1: 43행 INSERT(이름 NOT EXISTS 미충족 → 신규) · pass2: 동일 스크립트 → 전 INSERT의 NOT EXISTS가 pass1 적재행을 발견 → **delta 0** (코드 재발급 0). 부모 코드는 이름 서브쿼리로 재해결되어 자식 FK 무단절.
- 라이브 2-pass 실집행 수치 확정은 R5 실행(리드 승인) 시 동봉.

## 라이브 DRY-RUN(R5) — 제약위반 목록: **예상 0** (결정론적)

타입/길이/NOT NULL/CHECK(use_yn·del_yn·mand_yn·dflt_yn IN Y/N)/FK(prd_cd·mat_cd·proc_cd·opt_grp 복합·cod FK 5종)/PK(자연키 43 유일)/트리거(fn_chk_opt_item_ref 18행) 전 경로 라이브 대조 위반 0. **0임을 명시.**

## mint 정직성(R4) — 부여표 (라이브 재확인)

| 코드 | 이름 | search(2026-06-09 live) | 판정 |
|---|---|---|---|
| MAT_000337 | 큐방 | 0행 부재 | mint 정당 |
| MAT_000338/339 | 각목(900이하/초과) | 0행 부재 | mint 정당(D-2 2 mat_cd·ref_param_json 부재 우회) |
| MAT_000340 | 봉제사 | 0행 부재 | mint 정당(D② 실=자재) |
| PROC_000084 | 열재단 | 0행 부재 | mint 정당(완칼 차용 폐기) |
| MAT_000069/070 | 양면테입/끈 | EXISTS del_yn=N | LINK only(mint 안 함) |
| PROC_000079/080/081 | 타공/봉제/부착 | EXISTS+기링크 | 재적재 안 함 |

---

## 발견 결함

### F-1 [MINOR · 적재 무영향 · → dbm-load-builder] option_items per-dim 카운트 오기
- **현상**: `07_t_prd_product_option_items.sql` 헤더 주석·`load-manifest.md` §1/§5가 "자재(.03) **9** + 공정(.04) **9** = 18"로 기재. 실제 SQL 실측 = **자재(.03) 8 + 공정(.04) 10 = 18**.
- **근거**: `grep -c "OPT_REF_DIM.03'"`=8(전부 USAGE.07)·`"OPT_REF_DIM.04'"`=10(전부 NULL ref_key2). 옵션별 합산 검증: 자재 = 양면1+봉제사1+큐방1+끈1+(각목+끈)2+(각목+끈)2 = 8 · 공정 = 열재단1+타공3+부착(양면/큐방/끈/각목LE/각목GT)5+봉제1 = 10.
- **영향**: **데이터 정확**(18행·총 43행 일치). 카운트 라벨만 오기 → 적재 결과 불변. builder 자가 DRY-RUN 로그도 "9·9"로 오기재(R6 독립재현이 포착한 항목).
- **수정**: 헤더 주석·manifest §1/§5 "9+9" → "자재 8 + 공정 10". 소유=dbm-load-builder. (NO-GO 아님 — 코드/데이터 수정 불요.)

---

## 차단/CONFIRM 정직 분리 검증 (침묵 드롭 0)

| 항목 | 분류 | 검증 |
|---|---|---|
| R-GAKMOK constraint(RULE_001) | **BLOCKED(정당)** | `logic` jsonb 세로변 siz_cd 멤버십이 siz 76규격 미등록(가격트랙) 의존. `_blocked/08_*.sql`로 분리·08 본문 0행. 과차단 아님(각목 mat_cd 338/339는 본 mint 충족·siz 차원만 미충족). |
| C-1 큐방 부착 enum | **CONFIRM(적재 무영향)** | PROC_000081 `{대상}` enum에 큐방 부재. 트리거는 proc_cd EXISTS만 검사(param 미저장) → 적재 무영향·note 보존. 정직. |
| C-2 양면테입→테입 enum | **CONFIRM(적재 무영향)** | 동일 — note 보존. |
| GAP-PARAM(D-1) ref_param_json | **GAP(우회·정직)** | 타공4/6/8=별 옵션 3·각목=별 mat_cd 2로 우회 표현(의미 손실 0). 근본해소=ddl-proposer 트랙. qty/날조 smear 0. |

## BUNDLE 의미 정합(v2 설계 대조)
- 자재+공정 BUNDLE 정합: 양면테입(자재069+부착)·봉미싱(자재 봉제사+봉제)·큐방/끈/각목추가(자재+부착) = 한 옵션 다중 item_seq(자재 .03 + 공정 .04). 타공=process-only(bare-hole D①·자재 없음)·열재단=process-only(M-1①). 추가없음=센티넬(item 0). **v2 설계대로**.

---

## INSERTABLE / BLOCKED / GAP 집계

- **INSERTABLE = 43** (mint 자재 4 + 공정 1 + 자재링크 6 + 공정링크 1 + 그룹 2 + 옵션 11 + 아이템 18). ← **COMMIT-ready 행 집합(조정 없음, 43 그대로)**.
- **BLOCKED = 1** (R-GAKMOK constraint — siz 76규격 의존, `_blocked/08`).
- **CONFIRM = 2** (큐방/양면테입 부착 enum 라벨 — 적재 무영향, 인간 결정 잔존).
- **GAP = 1** (ref_param_json — 우회 표현, ddl-proposer 트랙).

## 인간 결정 대기 (에스컬레이션)
1. **라이브 롤백전용 DRY-RUN(R5/R1 실집행)** — 쓰기 트랜잭션(즉시 ROLLBACK). 리드 승인 1회 → 2-pass 수치 동봉.
2. **실 COMMIT(영구 적재 43행)** — 본 트랙 범위 밖. G1~G9+R1~R6 PASS 번들로 승인 요청.
3. **enum 확장**(부착 대상에 큐방/양면테입) — 인간 결정(적재 차단 아님).
4. **siz 76규격 등록**(가격트랙) → R-GAKMOK constraint unblock.

> **NEVER COMMIT.** 본 게이트는 읽기전용 SELECT + 트리거/스키마 덤프만 수행(쓰기 0).
