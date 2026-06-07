# 국4절 32상품 plate 적재 실행본 — R-게이트 + 라이브 롤백전용 DRY-RUN

> **라운드**: 국4절(316x467) 32상품 plate 적재 실행본 (round-5, 사용자 확정 2026-06-07)
> **검증 대상**: `09_load/_migrate_plate_load_guk4/` (builder 산출 — 적대적 검증, 조용히 고치지 않음)
> **권위 입력**: `08_remediation/csv/plate-load-products.csv`(매핑 권위) · `03_validation/plate-load-from-master-gate.md`(선행 V1~V6·G-1~G-6) · 라이브 `railway` DB read-only + 롤백전용 DRY-RUN(2026-06-07).
> **[HARD]** 라이브 DRY-RUN = lead 승인됨(`BEGIN … ROLLBACK` 쓰기 1회). **COMMIT 0 · 영구변경 0 · ROLLBACK 종료**. 비밀번호 stdout 미출력. 자가 git 커밋 없음.

---

## 종합 판정: **GO** (라이브 DRY-RUN 실증 완료 — 실제 COMMIT은 인간 승인 대기)

라이브 롤백전용 DRY-RUN으로 멱등성(2-pass 델타 0)·제약위반 0·FK 고아 0·비교정 제품 보존·영구변경 0을 실측 입증. R1~R6 전건 PASS. 실제 `--commit`은 인간 승인 사항.

---

## R1~R6 종합

| 게이트 | 판정 | 근거(파일·라인·실측) | 라우팅 |
|--------|------|----------------------|--------|
| **R1 멱등** | **PASS** | 2-pass 라이브: 2회차 DELETE 0/INSERT 0/UPDATE 0. 델타 plate_total Δ0·siz_active Δ0. `ON CONFLICT (prd_cd,siz_cd) DO NOTHING`(01.sql:54)·`siz_cd<>'499' AND del_yn='N'` DELETE 가드(01:15-16)·`del_yn='N'` soft-delete 가드(02:27) | — |
| **R2 원자성** | **PASS** | `apply.sql` 단일 `BEGIN`(9)…`COMMIT`(12), `\set ON_ERROR_STOP on`(8). 01/02 내부 트랜잭션 키워드 0(grep 확인). 부분적용 경로 없음 | — |
| **R3 실행가능성** | **PASS** | 01/02 라이브 psql 실행 오류 0(DRY-RUN 정상 완료). `apply.sh`가 `.env.local` source·`PGPASSWORD` 환경변수만 전달(stdout 미출력)·CWD 상대 `\i` 정상 로드 | — |
| **R4 DDL 제안** | **N/A** | 본 실행본 신규 siz·DDL·코드행 0(316x467=SIZ_000499 라이브 재사용). DDL 제안 부재가 정당(search-before-mint = 기존 siz 충분) | — |
| **R5 라이브 DRY-RUN** | **PASS** | `BEGIN…ROLLBACK` 라이브 실행: 제약위반 0(FK 고아 0·PK 중복 0·NOT NULL 0). 롤백 후 plate 102·siz 53 원복(영구변경 0) | — |
| **R6 독립성** | **PASS** | builder(산출)≠validator(게이트) 분리. 능동 적발 3건(아래 §능동 적발) | — |

---

## 라이브 DRY-RUN 실측표 (lead 승인·2026-06-07)

### BASELINE (DRY-RUN 전)
| 지표 | 실측 | builder 주장 | 정합 |
|------|------|--------------|------|
| 32상품 plate active | **102** | 102 | ✓ |
| 31교정상품 작업사이즈 plate(siz<>499, active) | **101** | 101 | ✓ |
| 31교정상품 기존 SIZ_000499 plate 보유 | **0** (전부 fresh INSERT) | 0 | ✓ |
| PRD_000016 plate(KEEP) | SIZ_000499·dflt_plt_yn='N'·1행 | KEEP 1행 | ✓ |
| 53 ORPHAN siz active | **53** | 53 | ✓ |
| SIZ_000499 라이브 | work 316x467·cut 306x457·impos=Y·use=Y·del=N | REUSE 존재 | ✓ |
| FK plate→siz 삭제규칙 | **RESTRICT** | RESTRICT(순서강제 근거) | ✓ |
| OUTPUT_PAPER_TYPE.01 | t_cod_base_codes 존재="국전계열" | .01 부여 | ✓ |
| 31 prd_cd 라이브 존재 | **31** | 31 | ✓ |

### PASS 1 (1회차 적용)
| 문 | 실측 행수 | builder 주장 | 정합 |
|----|-----------|--------------|------|
| plate DELETE | **101** | 101 | ✓ |
| plate INSERT | **31** (INSERT 0 31) | 31 | ✓ |
| 적용 후 32상품 plate active | **32** (102→32 collapse) | 32 | ✓ |
| 적용 후 32상품 = SIZ_000499 | **32** (31 INSERT + PRD_000016 KEEP) | 32 | ✓ |
| siz soft-delete | **53** (UPDATE 53) | 53 | ✓ |

### PASS 2 (2회차 — 멱등 R1)
| 문 | 2회차 행수 | 멱등 |
|----|-----------|------|
| plate DELETE | **0** (작업사이즈행 이미 삭제) | ✓ |
| plate INSERT | **0** (ON CONFLICT DO NOTHING — (prd,499) 선존재) | ✓ |
| siz soft-delete | **0** (del_yn 이미 'Y') | ✓ |

| 멱등 델타 | after1 | after2 | delta |
|-----------|--------|--------|-------|
| plate_total(active 전체) | 424 | 424 | **0** |
| siz_active(전체) | 447 | 447 | **0** |

→ **R1 멱등 PASS** (2회차 0행·델타 0)

### R5 제약위반 어서션 (롤백 전, 전건 0)
| 어서션 | 실측 | 기대 | 판정 |
|--------|------|------|------|
| A1 plate FK 고아 siz_cd | **0** | 0 | PASS |
| A2 plate FK 고아 output_paper_typ_cd | **0** | 0 | PASS |
| A3 plate PK(prd_cd,siz_cd) 중복 | **0** | 0 | PASS |
| A4 NOT NULL 위반(dflt_plt_yn·reg_dt) 신규 31 | **0** | 0 | PASS |
| A6 신규 31행 reg_dt NULL(DEFAULT 발화 확인) | **0** | 0 | PASS |

**제약위반 총계 = 0** (타입/길이·NOT NULL·CHECK·FK 고아·PK 중복 전 유형).

### POST-ROLLBACK 원복 (영구변경 0)
| 지표 | DRY-RUN 전 | DRY-RUN 후 | 영구변경 |
|------|-----------|-----------|----------|
| 32상품 plate active | 102 | **102** | **0** |
| 53 ORPHAN siz active | 53 | **53** | **0** |

→ **COMMIT 0 · 영구변경 0 확인.**

---

## 능동 적발 결함 (R6 독립성 — 적대적 재검증)

builder를 무비판 승인하지 않고 라이브로 독립 재검증, 다음 3건을 능동 적발·확인:

1. **G-6 DELETE prd_cd 한정 — 실효성 라이브 실증(적발→정합 확인).** builder가 DELETE를 `prd_cd IN(31) AND siz_cd<>'499'` 양조건으로 했다 주장 → validator가 비교정(non-corr) 제품의 PRESERVE siz plate 보존을 라이브 어서션 A5로 독립 검증: SIZ_000113(5행)·114(2)·115(2)·144(1) **DELETE 후 전건 보존**. prd_cd 한정 누락 시 손실됐을 행이 보존됨을 실증 → G-6 반영 **정합 확인**. (한정 누락이었다면 이 어서션이 0을 반환해 FAIL이었을 것.)

2. **reg_dt NOT NULL DEFAULT 함정 — 라이브 발화 실증.** round-5 메모리 교훈(명시 NULL은 DEFAULT 미발화). builder가 INSERT 컬럼 목록에서 `reg_dt` 생략 → validator가 A6로 신규 31행 reg_dt NULL=0 실측 확인. DEFAULT now() 정상 발화. round-4 로컬검사가 놓쳤던 케이스를 라이브로 닫음.

3. **PRD_000016 KEEP dflt_plt_yn 불일치 — 적재 무영향 확인 + 인간 결정 큐 격상.** 라이브 baseline 실측: PRD_000016 SIZ_000499의 `dflt_plt_yn='N'`. 신규 31행은 전부 'Y'. KEEP행만 'N'으로 일관성 결여(G-4/H-3) → builder는 KEEP 가드로 미터치(적재 NOT NULL 충족 무영향, 적절). 단 의미상 'Y' 정정 권고를 인간 결정 큐에 유지(H-3).

추가 확인: SIZ_000499 work/cut/impos 속성·OUTPUT_PAPER_TYPE.01 코드명("국전계열")·31 prd_cd FK 대상 전건 라이브 존재 — 추측 0, 라이브 권위.

---

## G1~G9 carry-forward (선행 게이트 재확인)

선행 `plate-load-from-master-gate.md`(V1~V6) 판정 = **CONDITIONAL-GO**(38상품 기준, G-1 MAJOR로 6상품 보류). 본 실행본은 그 **GO 부분집합(316x467 32상품)** 만 구현 → CONDITIONAL의 조건(G-1)이 범위 제외로 자동 충족.

| 항목 | 선행 판정 | 본 실행본 재확인 | 근거 |
|------|-----------|------------------|------|
| G-1(R-5 가격조회축) | MAJOR — 3절·투명 6상품 신규 siz 시 가격조회 깸 | **회피(범위 제외)** | 6상품(PRD_000019/025/030/039/049/112) SQL 부재 grep 확인. 316x467 32상품은 가격 SIZ_000499 정합 유지(component_prices 미터치) |
| G-6(DELETE prd_cd 한정) | builder 강제 | **반영·라이브 실증** | A5 비교정 보존 0손실 |
| F-4(dflt_plt_yn NOT NULL) | — | **반영** | 01.sql 31행 전건 'Y' 명시·A4 위반 0 |
| F-5/H-5(output_paper_typ_cd .01) | 후니 확인 | **반영** | 01.sql 전건 .01·A2 FK 고아 0·코드명 "국전계열" |
| 가격 무변경 | — | **확인** | component_prices 0 터치(SQL 부재) |

---

## 차단/에스컬레이션 — 인간 승인 대기

| ID | 분류 | 내용 | 상태 |
|----|------|------|------|
| **COMMIT** | 적재 | 실제 `./apply.sh --commit`(plate DELETE 101·INSERT 31 + siz soft-delete 53). 사전 `./backup.sh` 권장 | **인간 승인 대기** (DRY-RUN GO 입증 완료) |
| **H-3**(G-4) | KEEP 일관성 | PRD_000016 `dflt_plt_yn='N'`→'Y' 정정 포함 여부. 본 실행본 미포함(KEEP). 의미상 'Y' 권고·적재 무영향 | 후니 확인 |
| **H-5**(F-5) | 정정의도 | output_paper_typ_cd `.01` 일괄정정(기존 NULL/.03→.01). 디지털인쇄=국전계열 도메인 타당 | 후니 확인 |
| 3절·투명 6상품 | 범위 외 | 신규 siz 채번·가격 정합(G-1) = 다음 단계. 본 실행본 미적재 | 다음 라운드 |

---

## 결론

국4절 32상품 plate 적재 실행본은 **GO** — R1~R6 전건 PASS, 라이브 롤백전용 DRY-RUN에서 멱등(2-pass 델타 0)·제약위반 0·FK 고아 0·비교정 제품 보존·영구변경 0 실증. builder 산출이 G-6/F-4/F-5 반영·reg_dt 함정 회피·범위 제외(G-1)를 모두 정합 충족. 실제 COMMIT은 인간 승인 사항.
