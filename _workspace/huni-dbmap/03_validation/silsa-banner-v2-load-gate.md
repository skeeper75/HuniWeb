# round-5 적재 실행 게이트 — 일반현수막(PRD_000138) v2 자재+공정 BUNDLE | 판정: **GO (조건부 흠 1건)**

> 검증 2026-06-08 · `dbm-validator` 독립 게이트(R6 생성·검증 분리 — 본 검증자는 패키지 비빌더) · 권위 `docs/goal-2026-06-06-02.md` + `dbm-load-execution` 스킬 §3.
> 검증 대상: `09_load/_exec_silsa_banner/`(SQL 00~09·_blocked·apply.sql/sh·dryrun-log·ddl-proposals·blocked-and-gaps) · v2 설계 `10_configurator/silsa-option-layer-v2.md`+`load_silsa_v2/*.csv`.
> 검증 방식: **라이브 read-only SELECT + 본 검증자가 직접 재현한 롤백전용 DRY-RUN**(빌더 로그 미신뢰·자가 재현). **COMMIT 0 — 영구 적재 없음**(최종 라이브 확인 전건 0행).

---

## 1. G1~G9 carry-forward (round-4/round-5 권위 재확인)

본 v2는 round-5 옵션부 갱신이므로 G1~G9는 carry-forward·재확인.

| Gate | 의미 | 재확인 | 근거 |
|------|------|:--:|------|
| G1 t_* 화이트리스트 | 적재/제안 전부 t_* | PASS | 적재 대상 t_prc_*·t_prd_product_*·t_mat_*·t_proc_*·t_siz_*. Django/비-t_ 0건 |
| G2 매핑 권위 불변 | round-6 v2 매핑 권위 | PASS | 적재는 재매핑 없이 v2 설계 CSV verbatim |
| G3 FK 위상정렬 | 의존순 적재 | PASS | apply.sql 00→05(가격)→06→07→08→09. B04 자재 seq가 06/07 선행 필요함을 빌더 자체발견·해소 |
| G4 코드행 선적재 | 마커 분리 | PASS | 00_preload_markers = 인간승인 마커(INSERT 0) — 단 §4 F-3 stale 흠 |
| G5 매니페스트 | 행수·충돌키 | PASS | load-manifest·README 집계 = 실 SQL grep 정합(58 INSERTABLE) |
| G6(→R5) 롤백 DRY-RUN | 제약위반 0 | PASS(R5에서 실행) | 본 검증자 직접 재현 — 아래 R5 |
| G7 침묵 drop 0 | BLOCKED 분리 | PASS | 자재 seq/siz/열재단 = `*_BLOCKED.csv`/`_blocked/` 격리. back-fill 0 |
| G8 재현성 | 스크립트 생성 | PASS | gen_load_sql.py 생성·손편집 금지 주석 |
| G9 독립 검증 | builder≠validator | PASS | 본 게이트 = 독립 검증자(R6) |

---

## 2. R1~R6 게이트 (전건 본 검증자 자가 재현)

| Gate | PASS/FAIL | 근거(라이브 직접 재현) | 라우팅 |
|------|:--:|------|------|
| **R1 멱등성** | **PASS** | 옵션부 2-pass: BASELINE 0/0/0 → PASS1 2/11/9 → PASS2 **delta 0/0/0**(전 INSERT `0 0`). 가격 comp_prices 변형 C 2-pass **delta=0**(NULL flat 멱등). 자재 BUNDLE(링크+seq) 2-pass delta 0 | — |
| **R2 원자성** | **PASS** | apply.sql 실 COMMIT 문 **0개**(전부 주석)·BEGIN 1·`\set ON_ERROR_STOP on`. mid-load 강제실패 주입 → 실패 **전** INSERT(formulas/groups)도 전체 롤백(0/0) = half-load 없음 | — |
| **R3 실행성** | **PASS** | 전 .sql 파싱·실행 exit 0. 전체 apply.sql 라이브 DRY-RUN 58행 적재 0 syntax error. 컬럼셋=라이브 컬럼 정합(del_yn 생략 가능=DEFAULT 'N') | — |
| **R4 DDL/mint 정합** | **PASS** | search-before-mint 라이브 재증명(§3). 끈 070·양면테입 069 EXISTS 확인 / 큐방·각목·봉제사 absent 확인 / 우드봉 MAT_000225=MAT_TYPE.10 별물 차용배제 타당 / MAX(mat_cd)=MAT_000336 정확. mint 4=master-data INSERT(테이블 신설 0). 열재단 PROC_000084 부재 확인 | — |
| **R5 라이브 DRY-RUN** | **PASS** | 제약위반 **0**. 공정 seq 9 트리거 통과. 자재 seq(.03) 링크 없이 → 트리거 `line 17 RAISE` REJECT(BLOCKED 실재 입증) → 링크 선적재 후 BUNDLE 13행 성립. POST-ROLLBACK 라이브 0행(COMMIT 0) | — |
| **R6 독립 검증** | **PASS** | 빌더 dryrun-log 미신뢰·전 게이트 자가 재현. **실결함 F-3(00 마커 stale)·흠 F-2(blocked 로더 래퍼 부재) 독립 적발** | builder |

---

## 3. R4 — search-before-mint 정직성 (라이브 직접 조회 = 권위)

빌더 주장을 본 검증자가 라이브 read-only SELECT로 전건 재검증:

| 자재 | 빌더 주장 | 라이브 재조회 결과 | 판정 |
|------|-----------|---------------------|:--:|
| 끈 MAT_000070 | EXISTS(링크만) | `MAT_000070\|끈\|MAT_TYPE.07` 실재 | ✅ 정직 |
| 양면테입 MAT_000069 | EXISTS(링크만) | `MAT_000069\|양면테입\|MAT_TYPE.07` 실재 | ✅ 정직 |
| 각목(LE/GT) | absent → mint | 각목/각재/사각목/원목 검색 **0행** | ✅ 정직(mint 정당) |
| 큐방 | absent → mint | 큐방/하토메/그로밋/아일렛 검색 **0행** | ✅ 정직(mint 정당) |
| 봉제사(실) | absent → mint | 봉제사/봉사/미싱사/실/재봉 검색 **0행** | ✅ 정직(mint 정당) |
| 우드봉 차용 배제 | 각목≠우드봉 | MAT_000225 우드봉=MAT_TYPE.10(악세사리)·"각목" 명칭 부재 | ✅ 차용배제 타당 |

- **이미 존재하는데 mint 제안한 위반: 0건.** **발명(invented) 코드: 0건**(mint 4 전부 `[CONFIRM-CHANNEL]` placeholder·주석 격리, mat_cd 미채번이라 실행 SQL 아님).
- 열재단 PROC_000084 = 라이브 부재 확인 → 신규 공정 제안 정당(완칼 PROC_053 차용 폐기).
- NULLS DISTINCT 발견(자연키 UNIQUE)은 신규 결함 아닌 재확인 — 변형 C로 정상 작동. DDL 불요 권고 타당.

---

## 4. 사용자 HARD 모델 정합 (옵션 = 자재.03 + 공정.04 BUNDLE)

### 3대 도메인 결정 — 전건 올바로 적용

| 결정 | 요구 | 적재 산출물 실측 | 판정 |
|------|------|------------------|:--:|
| ① 타공(4/6/8)=process-only | bare-hole·아일렛 자재 seq 완전 제거 | INSERTABLE = `.04 PROC_000079` item_seq=1 만. 아일렛/eyelet 자재 .03 데이터 **0건**(매치는 전부 "철회" note 텍스트) | ✅ |
| ② 봉미싱=실 자재(.03 mint)+봉제(.04) | BUNDLE | BLOCKED `.03 [CONFIRM-MAT 봉제사]`(seq1) + INSERTABLE `.04 PROC_000080`(seq2) | ✅ |
| ③ 각목=material(.03) mint, NOT set/우드봉 | material | BLOCKED `.03 [CONFIRM-MAT 각목900이하/초과]`. set(.07)/MAT_000225 차용 데이터 **0건** | ✅ |

### BUNDLE 무결성

- 각목+끈(LE900): seq1=각목(.03 mint) + seq2=끈(.03 MAT_000070) + seq3=부착(.04 PROC_000081) = **3 seq**(자재2+공정1). 라이브 DRY-RUN으로 끈 seq2+부착 seq3 성립 확인(각목 seq1=mint 대기). item_seq 충돌 0.
- 끈/양면테입: 자재 seq1 + 공정 seq2 = BUNDLE 2행. 라이브 링크 선적재 후 13행(mat 4 + proc 9) 성립 실증.
- R-GAKMOK constraint **var = `mat_cd`**(v1 sub_prd_cd → 변경) JSONLogic `{"var":"mat_cd"}` 확인·`and` 2-arm·json.loads PASS. (추가검증 4 PASS)

### BLOCKED 정직성 (over/under-block 0)

- **INSERTABLE 9** = 공정 seq, 라이브 PRD_000138 링크 079/080/081에 실제 resolve(라이브 DRY-RUN A 통과). over-block 없음.
- **BLOCKED 9**(자재 .03 8 + 열재단 .04 1) = 트리거가 실제 REJECT(B1 `line 17 RAISE` 라이브 실증). under-block·silent back-fill 0.
- B-4(LINK only) 4 + B-5(MINT+LINK) 4 + 열재단 1 = 9, items_BLOCKED.csv 9행 정합.

### 가격 트랙 불변 (추가검증 5)

- 가격 SQL 01~05 = formula 1·comp 10·wiring 11·comp_prices 13·binding 1 = 36 INSERTABLE. siz BLOCKED 77 area-cell(B01/B02) 불변. 열재단 PROC 제안 불변. v2 갱신은 옵션부(06~09)만 — 가격 트랙 손대지 않음 확인.

---

## 5. 발견 결함/흠 (라우팅)

| ID | 심각도 | 내용 | 근거 | 라우팅 | GO 차단? |
|----|:--:|------|------|------|:--:|
| **F-3** | **MAJOR** | `00_preload_markers.sql` line 3·13이 **v1 폐기 모델 "각목 sub_prd_cd=code-row·t_prd_product_sets 적재 후 각목 seq2 INSERTABLE"** 잔존. v2(각목=material.03·sub_prd_cd 폐기)와 정면 모순. 09 SQL·ddl-proposals·blocked-and-gaps는 정정됐으나 00 마커만 누락 갱신 | grep `각목 sub_prd_cd` → 00_preload_markers.sql:3,13 | builder | NO(주석 stale·실행/데이터 영향 0). 단 사용자 HARD 모델 모순 텍스트라 적재 전 갱신 권고 |
| **F-2** | MINOR | `_blocked/apply_blocked_options.sql`이 `BEGIN;`만 열고 종결 COMMIT/ROLLBACK 부재(주석만). README가 `-c "ROLLBACK;"` 외부 주입 안내라 안전(미주입 시 psql 종료 자동롤백)하나 apply.sh 같은 로더 래퍼 부재로 일관성↓ | apply_blocked_options.sql line 11/21 | builder | NO(데이터 안전 보장) |

> **F-3은 데이터/실행을 바꾸지 않으므로 GO를 막지 않는다**(주 트랜잭션 00 마커는 INSERT 0행). 그러나 사용자 HARD 모델(각목=material)과 정반대 텍스트가 적재 패키지에 남아 후속 혼동을 유발하므로 **실 COMMIT 전 갱신을 필수 권고**한다. F-2는 안전망 동작이라 권고만.

---

## 6. 적재 가능성 집계 (라이브 재현 검증)

| 트랙 | INSERTABLE(주 트랜잭션) | BLOCKED(인간 승인) | GAP |
|------|:--:|:--:|:--:|
| 가격(price) — 불변 | 36 | 77(area-cell, siz 의존) | 0 |
| 상품마스터(CPQ v2) | 22(groups 2·options 11·item 공정 seq 9) | 자재 seq 8 + 열재단 1 + siz 77 + 자재 mint 4 + 자재 링크(매핑상 6) | 1(R-GAKMOK var=mat_cd) |
| **합계** | **58 (라이브 DRY-RUN 전건 적재·제약위반 0)** | 186 | 1 |

- 라이브 직접 재현: 58 INSERTABLE 전건 적재 성공·제약위반 0·POST-ROLLBACK 0행.

---

## 7. 인간 승인 대기 항목 (리드 에스컬레이션 — 본 게이트 범위 밖)

| # | 항목 | 종류 |
|:--:|------|------|
| 1 | **실제 COMMIT**(가격 36 + CPQ 22 = 58 INSERTABLE) | 적재(영구) |
| 2 | siz 77규격(SIZ_000538~618) 등록 → area-cell 77 활성화 | master-data |
| 3 | **자재 mint 4**(큐방·각목LE/GT·봉제사, MAT_TYPE.07, mat_cd 후니 채번) | master-data |
| 4 | 자재 링크(끈 070·양면테입 069 즉시 + mint분) | data |
| 5 | 열재단 PROC_000084 DDL 적용 | data(공정 행) |
| 6 | ref_param_json 컬럼 ALTER(타공 구수·각목 규격 보존) | schema(GAP-PARAM) |
| 7 | 각목 2규격 모델(별 mat_cd 2개 vs 단일+param) | 설계(D-2) |
| 8 | R-GAKMOK 폼빌더 입력방식 + 큐방 부착 enum 확장 | 정책 |
| 9 | 기존 PRF_POSTER_FIXED 바인딩 정리(D-WIRE 2공식 공존) | 품질 |
| **선행** | **F-3 00 마커 stale 갱신**(각목 sub_prd_cd→material 정정) | 빌더 정정(COMMIT 전 권고) |

---

## 판정: **GO** — 58 INSERTABLE 즉시 적재 가능(인간 COMMIT 승인 시)

- R1~R6 전건 PASS(본 검증자 라이브 자가 재현). G1~G9 carry-forward PASS.
- 사용자 HARD 모델(자재+공정 BUNDLE) 3대 도메인 결정·BUNDLE 무결성·BLOCKED 정직성 전건 정합.
- search-before-mint 정직(발명 0·기존중복 mint 0)·라이브 DRY-RUN 제약위반 0·멱등 2-pass·COMMIT 0.
- **단서 1건(F-3 MAJOR, 비차단):** 00 마커 v1 stale 텍스트는 사용자 HARD 모델과 모순 → 실 COMMIT 전 builder 갱신 권고. F-2(MINOR)는 안전망 동작이라 권고만.
- 실 COMMIT·자재 mint·siz 등록·열재단 PROC·자재 링크·DDL·코드행 = **전부 인간 승인 대기**(propose ≠ apply).
