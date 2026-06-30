# codex 독립 2차 교차검증 — 화이트인쇄명함 PRD_000040 별색 flat 모델 교정 (Phase 5.5)

생성 2026-07-01 · codex gpt-5.5(read-only·effort high·session 019f19e9)·hpe-validator 판정 비노출(독립성)·DB 미적재
검증대상: `design-whitenamecard-flat-260701.md` + `design-whitenamecard-flat-dryrun.sql` (배경 `diag-whitenamecard-belsaek-260701.md`)
★codex 주장 = **가설**(라이브/권위 검증 전 사실 아님). 아래 reconcile에서 checkable 항목은 Claude가 라이브 스냅샷 latest로 직접 재측정.

---

## 0. codex 가용성

- **가용** — gpt-5.5, `-s read-only`, reasoning effort high. codex가 스냅샷 CSV + dryrun SQL 직접 정적 검증.
- 폴백 불요(미가용 아님). codex 전체판정 = **CONDITIONAL**.

---

## 1. codex 2nd opinion 원문 요지 (질문 1~8)

| Q | 항목 | codex 판정 | 한줄 근거 | codex가 든 위험 |
|---|---|---|---|---|
| 1 | 재바인딩 | **동의** | PRD_000040×PRF_DGP_A만 DELETE+PRF_NAMECARD_WHITE INSERT 정확. apply_end/del_yn 없으니 hard DELETE 맞음 | 커밋 직전 `count=1 && frm=PRF_DGP_A` preflight abort 필요(live drift) |
| 2 | 골든 재현 | **동의** | 3343~3346 q100=14500/16000/16000/19000, PRICE_TYPE.02 ÷100×100 정수일치 | qty≠100 tier 미적재→q100 한정 |
| 3 | disjoint 2×2 | **동의** | print_opt×opt_cd 충전 후 4조합 서로소·주문당 1행 | opt_cd가 selection에 안 들어오면 4행 NO_MATCH→0원 |
| 4 | mat 와일드 | **동의(워딩 정정)** | NULL이 MAT_000362~365 다 받음·색무관 동일가 정합 | **"MAT_000137 미등록"은 부정확 — master엔 존재, 040 연결에만 없음** |
| 5 | 채번 | **동의** | OPT_000080/OPV_488은 037 점유·081/489/490 미존재→충돌0 | 하이픈코드(OPT-…) 혼재→커밋전 numeric MAX 재조회 |
| 6 | opt_grp vs 공정 | **동의** | proc_cd=NULL NOCL행은 "없음"이 아니라 와일드→클리어있음과 동시매칭 위험. opt_grp 택1이 맞음 | PROC_000009 UI 잔존시 UX 이중선택 혼란 |
| 7 | 위젯 계약 | **조건부** | dflt_yn=Y는 화면기본값으론 타당하나 엔진 selection 실주입 보장 별도검증 | 어댑터가 기본값을 selection으로 materialize 안하면 클리어 미선택시 0원 |
| 8 | 모순/코팅 | **조건부** | 설계↔dryrun 핵심로직 모순 없음·opt명명 코팅 부활 없음 | comp_nm "코팅" 라벨 잔존·dryrun 검증SELECT가 count만(abort/assert 없음) |

**codex 신규 이슈(설계가 놓친 것):**
- N1. PRF_DGP_A 제거로 COMP_PP_CORNER_RIGHT 등 **후가공 component 동반 드롭**. 040 PROC_000027/028(직각/둥근)이 유료축이면 별도 add-on 설계 필요.
- N2. 040 활성자재 MAT_000362~365가 **모두 dflt_yn=Y**(다중 기본 자재). 가격 와일드라 안전하나 UI 기본 다중.
- N3. dryrun에 preflight/abort 부족 — PRF_DGP_A 단독바인딩·PRF_NAMECARD_WHITE 미존재·opt 미존재·3343~3346 현재값 일치를 검증 후 적용해야.
- N4. **evaluate_price 4골든 실호출 미수행** — ROLLBACK dryrun 안에서 4케이스 실호출해 14500/16000/16000/19000 확인해야 최종 GO.

**codex 전체판정: CONDITIONAL** (q100 flat 모델 자체는 맞음. COMMIT 전 조건 = dflt 실주입 확인·후가공 가격영향 판정·트랜잭션내 4골든 실호출.)

---

## 2. reconcile (codex ↔ Claude 라이브 재측정)

### 합의 = 고신뢰 (데이터 설계 핵심)

| 항목 | 합의 내용 | Claude 라이브 재측정 | 신뢰도 |
|---|---|---|---|
| 재바인딩(Q1) | hard DELETE+INSERT 정확·이중합산0 | t_prd_product_price_formulas 스키마=apply_end/del_yn 無→DELETE가 유일수단 확인·복합PK·다른상품 2바인딩 허용 확인 | **고** |
| 골든(Q2) | q100 4골든 정수재현·1.6~2.3배 과대제거 | 3343~3346 unit_price=14500/16000/16000/19000·min_qty100·PRICE_TYPE.02 확인 | **고** |
| disjoint(Q3) | print_opt×opt_cd 4조합 서로소 | 3343/3345=POPT_000001/002, opt_cd 빈값(충전 대상) 확인·2축 disjoint 논리 타당 | **고** |
| 채번(Q5) | OPT_000081/OPV_489·490 충돌0 | 언더스코어 MAX=OPT_000080·OPV_000488 확인. 하이픈 OPT-시리즈는 별 네임스페이스(충돌무관) | **고** |
| opt_grp(Q6) | 클리어=opt_grp 택1이 공정보다 정합 | proc_cd NULL=와일드라 NOCL/CL 동시매칭→disjoint 불가 논거 타당 | **고** |

→ **데이터 모델 핵심(재바인딩·골든·disjoint·채번·opt_grp) = 양 모델 합의 = 고신뢰.** divergence 0.

### 불일치/보강 = 조사·해소

| # | 항목 | codex 주장(가설) | Claude 라이브 재판정 | 해소·소유자 |
|---|---|---|---|---|
| R1 | mat 워딩(Q4) | "MAT_000137 미등록"은 부정확·master엔 존재 | **codex 맞음** — t_mat_materials에 `MAT_000137 큐리어스스킨` 존재. 040 product_materials 연결엔만 없음. 운영결론(와일드 필연)은 무손상 | 워딩 정정(설계 §1: "미등록"→"040 상품-자재 연결에 미등록·마스터엔 존재"). designer·minor |
| R2 | ★후가공 드롭(N1) | PRF_DGP_A 제거로 직각/둥근 등 가격경로 소실 | **구조관찰 valid·가격영향 ~0** — COMP_PP_CORNER_RIGHT 단가행 PROC_000027(직각)=**0.00 무료**. CREASE/PERF/VARTEXT/COAT은 040 미보유 proc→어차피 NO_MATCH. 골든(완제품가)에 후가공 미포함과 정합 | CONFIRM: 040 직각/둥근 무료가 의도인지 designer 1줄 확인. 매출영향 0이라 GO 비차단 |
| R3 | 위젯 dflt 주입(Q7) | dflt_yn=Y가 엔진 selection 실주입 보장 안됨→0원 위험 | 미검증(라이브 위젯/어댑터 경로 본 검증 범위 밖) | 위젯 계약 검증 필요·hpe-validator/§6 위젯 트랙. **실 COMMIT 전 조건** |
| R4 | preflight abort(N3) | dryrun 검증SELECT가 count만·abort 없음 | dryrun V1~V6 = SELECT count/확인만(BEGIN…ROLLBACK). 적용 멱등 가드(NOT EXISTS)는 있으나 사전 상태 assert 없음 | 개선 권고: COMMIT본에 PRF_DGP_A 단독·3343~3346 현재값 assert 추가. dbmap 적재트랙 |
| R5 | 골든 실호출(N4) | dryrun이 evaluate_price 실호출 안함 | 맞음 — dryrun은 데이터 상태만. 실호출 골든은 본 설계 범위 밖(생성측) | hpe-validator E게이트(골든 실호출 PRICE≠0)의 몫. 후속 |
| R6 | 다중 dflt 자재(N2) | MAT_000362~365 모두 dflt_yn=Y | 확인 — 4색 모두 dflt_yn=Y. mat 와일드라 가격 무해 | UI 기본자재 정리·minor·가격 무영향 |

### 충돌(auto-flip 필요) = **없음**

codex는 검증된 라이브 발견 어느 것과도 모순하지 않음. 모두 **완결성 보강**(놓친 점검축)이거나 **워딩 정정**(R1). 자동 flip 대상 0.

---

## 3. 종합 판정

- **데이터 설계 핵심 = codex·Claude 합의(고신뢰 GO 후보)**: 재바인딩(hard DELETE 정당)·flat 골든 q100 재현·disjoint 2×2·채번 무충돌·opt_grp 택1 정당. divergence 0.
- **codex CONDITIONAL = 설계의 CONDITIONAL 상태와 정합** — 본 설계도 실 COMMIT을 인간 승인·후속 게이트로 미룸. codex가 COMMIT 전 조건 3건(R3 위젯 dflt 실주입·R2 후가공 가격영향·R5 트랜잭션내 골든 실호출)을 명료화.
- **신규로 표면화된 실질 보강**: R2(후가공 드롭→재측정 결과 매출영향 0이나 CONFIRM 권고)·R4(COMMIT 전 abort assert)·R1(mat 워딩 정정). 어느 것도 골든 q100 재현을 깨지 않음.
- **라우팅**: R1·R2·R4·R6 → designer(워딩·CONFIRM·abort 가드 보강). R3 → 위젯 계약 검증. R5 → hpe-validator E게이트(골든 실호출). 실 COMMIT = 인간 승인 후 §7 dbmap.

★기록: codex 주장은 검증 전 사실 아님. R1·R2는 Claude가 라이브 스냅샷으로 재측정해 확정(codex 맞음). R3·R5는 미검증(후속 트랙). 자동 flip 0·가짜 합의 0.
