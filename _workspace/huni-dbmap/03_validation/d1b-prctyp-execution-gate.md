# round-5 적재 실행 게이트 — D-1b 후가공 prc_typ 정정 | 판정: **GO**

> 검증 2026-06-15 · `dbm-validator`(독립 게이트, 생성자≠검증자) · 권위 입력 = [[../28_price-arbitration/_price-queue-closeout/phase-b-d1b-remediation.md]](제안본) + 라이브 t_* 읽기전용 실측(2026-06-15).
> 검증 대상 = [[../23_remediation-apply/d1b-prctyp/]] (빌더 산출 — 읽되 권위 아님·독립 재측정).
> **돈-크리티컬** — 단가행 불변·보정 하드코딩 적발을 라이브 단가행만으로 독립 재현. **NEVER COMMIT**(롤백전용 DRY-RUN).

---

## 0. 독립성 선언 (R6)

빌더(`dbm-load-builder`)가 `dry-run-result.md`로 자가실증했으나, 본 게이트는 **빌더 숫자를 신뢰하지 않고** 라이브에서 직접 재측정했다. 빌더의 `\i` 파일을 본 게이트가 작성한 독립 어서션과 함께 단일 롤백 트랜잭션에서 실행. 빌더 SQL을 침묵 수정하지 않음.

---

## 1. R1~R6 종합 (전건 PASS)

| Gate | 판정 | 근거(라이브 실측 쿼리·파일·라인) |
|------|:----:|---|
| **R1 멱등성** | ✅ PASS | 독립 라이브 DRY-RUN 2-pass: PASS1 = comp@.03 **13** + base@.03 **1** / PASS2(동일 재실행) = comp@.03 **13** + base@.03 **1** → 델타 0. 가드 실재: `00_*.sql:25 ON CONFLICT (cod_cd) DO NOTHING` · `01_*.sql:45 AND prc_typ_cd <> 'PRICE_TYPE.03'`. |
| **R2 트랜잭션 원자성** | ✅ PASS | `apply.sql:11 \set ON_ERROR_STOP on` + `:12 BEGIN;` 단일 트랜잭션, 파일 내 COMMIT/ROLLBACK 0(로더 주입). step 파일(00·01) 내 중첩 BEGIN/COMMIT 0. step 00→01 순서 = base_code 선행 후 prc_typ UPDATE(FK/도메인 선행). |
| **R3 실행가능성** | ✅ PASS | 두 SQL 라이브 `\i` 실행 0 에러. IN절 13 comp 전건 라이브 실재·현 prc_typ=`PRICE_TYPE.01`·comp_typ=`PRC_COMPONENT_TYPE.04`. **FK `fk_price_components_prc_typ`(prc_typ_cd→t_cod_base_codes) 실재** → step 00 선적재가 단순 권고가 아니라 **하드 FK 선결**(아래 §3 추가검사). 로더는 `.env.local` `RAILWAY_DB_*`로 접속·비밀번호 미출력. |
| **R4 단가행 불변(돈-크리티컬)** | ✅ PASS | DRY-RUN 내 `t_prc_component_prices` before/after EXCEPT 대조: **unit_price mismatch 0행**(13 target + 2 excluded = 15 comp 전건 byte-identical). 두 SQL 어디에도 `t_prc_component_prices` 향 INSERT/UPDATE/DELETE 없음·`prc_typ_cd` 메타 1컬럼+`upd_dt`만 변경. |
| **R5 라이브 DRY-RUN 제약위반 0** | ✅ PASS | 정정 후 `prc_typ_cd` FK 고아 **0행**(`.03` 포함 전건 base_code 참조 무결). 제외 2 comp(`CORNER_RIGHT`·`CUT_PERF_1H6`) `.03`으로 이동 **0행**(IN절 미포함 실증). 롤백 후 라이브 base@.03=**0**·comp@.03=**0**(완전 원복·무변경). |
| **R6 독립성** | ✅ PASS | 빌더(생성)≠본 게이트(검증). 본 게이트가 자체 어서션으로 PASS1/PASS2·EXCEPT·FK 고아·.03 규칙 손계산 전부 독립 재측정. 실결함 0이나 **잠재 위험 1건 적발**(loader `--commit` 경로 구조·아래 §4) + 미해소 컨펌 2건 정직 분리. |

→ **R1~R6 전건 PASS · 단일 FAIL 0 · 판정 = GO**(롤백전용 DRY-RUN 범위·실 COMMIT 인간 승인 너머).

---

## 2. 멱등성 증명(R1) — 독립 DRY-RUN 2-pass

| 단계 | base@.03 | comp@.03(13 target) | 비고 |
|------|:--:|:--:|---|
| PASS 1 | 1 | 13 | 1회차 INSERT 1·UPDATE 13 |
| PASS 2(재실행) | 1 | 13 | **델타 0**(ON CONFLICT no-op·가드로 UPDATE 0행) |

→ 빌더 `dry-run-result.md §1`과 일치. 본 게이트 독립 재현으로 멱등 확정.

---

## 3. R6 — RESOLVED 재현값 (라이브 단가행만 · 보정 하드코딩 적발)

`.03` 규칙 손계산: `min_qty <= qty` 중 `min_qty` 최대 행의 `unit_price`를 **1회**(÷min_qty 없음·×qty 없음). 라이브 `t_prc_component_prices`만 읽음(보정값 주입 0).

| 케이스 | comp | qty | 매칭 min_qty | 라이브 unit_price | **.03 산출(1회)** | 정합 |
|--------|------|:--:|:--:|:--:|:--:|:--:|
| 엽서 C3 후가공분 | COMP_PP_CREASE_1L | 100 | 100 | 10,000 | **10,000** | ✅ → 총 104,330 |
| 상품권 C2 후가공분 | COMP_PP_PERF_1L | 100 | 100 | 10,000 | **10,000** | ✅ → 총 48,073 |
| C4 비경계 | COMP_PP_CREASE_1L | 250 | 100 | 10,000 | **10,000** | ✅ ⓒ만 단조 정합 |

**C4 대비(라이브 단가 10,000 · 250매)**: `.01`(×qty)=2,500,000(과대) / `.02` 명세식(÷100×250)=25,000(300매=15,000 초과·단조성 위반) / **`.03`(1회)=10,000** ← 가격표 단조 정합.

> **보정 하드코딩 적발 결과 = 없음(0).** 빌더 주장 10,000/10,000/10,000은 본 게이트가 라이브 ladder(CREASE_1L·PERF_1L의 min_qty=100 → 10,000)에서 직접 룩업해 재현. `compute_corrected` 등 보정값 주입 0. 거짓 RESOLVED 아님.
> **정직 한계**: 엔진(evaluate_price) 미구현이라 엽서 C3=104,330·상품권 C2=48,073 **전체 합산**(인쇄+용지+코팅+후가공)은 재시뮬 불가 — 후가공분이 `.03`에서 10,000(1회)됨만 라이브로 확정. 빌더 `dry-run-result.md §5` 한계 명시와 일치.

---

## 추가 검사 (지시 항목)

| 검사 | 결과 |
|------|---|
| IN절 13 comp 정확성(CORNER_RIGHT·CUT_PERF_1H6 제외 = 전구간 0원·무영향) | ✅ 라이브 실측: `COMP_PP_CORNER_RIGHT` 9행 min/max unit_price = **0.00/0.00** · `COMP_CUT_PERF_1H6` 23행 = **0.00/0.00**. 제외해도 가격 기여 0(정정 무의미)이 맞음. IN절 = `COMP_PP` 13개 정확(CREASE 3·PERF 3·VARTEXT 3·VARIMG 3·CORNER_ROUND 1). |
| base_code `.03` 실제 비점유(PK 충돌 0) | ✅ 라이브 `t_cod_base_codes WHERE upr_cod_cd='PRICE_TYPE'` = `.01`/`.02`만. `.03` 부재 → `ON CONFLICT (cod_cd)` PK 충돌 0. |
| 동시 배포 경고 manifest 명시 | ✅ `manifest.md §6`·`README.md §3`·`apply_loader.sh:13,33`·제안본 §4·§7 전부 명시 — "prc_typ `.03` UPDATE와 엔진 `.03` 규칙(webadmin Phase11) **반드시 동시 배포**, 분리 시 미정의 동작(폴백 `.01`=과대청구 / NULL=가격 침묵 누락)". |
| FK `fk_price_components_prc_typ`(prc_typ_cd→base_codes) 실재 | ✅ **신규 강화 근거** — 라이브 `pg_constraint` 실측: `prc_typ_cd` → `t_cod_base_codes(cod_cd)` FK 존재. step 00 base_code 선적재는 단순 도메인 권고가 아니라 **하드 FK 선결**(base 없이 UPDATE만 하면 FK 위반 abort). apply.sql step 00→01 순서가 이 FK를 정확히 만족. |

---

## 4. 잠재 위험 적발 (R6 · 실결함 아님 · 인간 승인 전 확인 권고)

| 항목 | 내용 | 심각도 |
|------|------|:--:|
| loader `--commit` 경로 구조 | `apply_loader.sh:34 "${PSQL[@]}" -f apply.sql -c "COMMIT;"` — `apply.sql`이 트랜잭션을 닫지 않고 `-c "COMMIT;"`가 `-f` 뒤에 별도 실행돼 **실 COMMIT**된다. 본 게이트 범위(DRY-RUN) 밖이며 `--commit`(인간 승인) 게이트 뒤이고 기본 경로(`dryrun`→`-c "ROLLBACK;"`)는 안전하나, 실 적재 시 **엔진 `.03` 규칙 동시 배포 미확인 상태에서 실행되면 과대청구 위험**. 실 COMMIT 승인 시 ① 엔진 `.03` 배포 동시성 ② COMMIT 직전 동일 DRY-RUN 재확인을 인간이 확인할 것. | MINOR(범위 밖·게이트됨) |

> 이는 빌더 산출의 결함이 아니라 **실 COMMIT 단계의 운영 전제**다. 본 실행본은 DRY-RUN까지 안전.

---

## 5. 미해소 컨펌 (정직 분리 · 본 게이트로 닫을 수 없음)

| 컨펌ID | 무엇 | 누가 결정 |
|--------|------|----------|
| **C-D1b** | 정정 방식 ⓒ-2(신규 `.03`·채택) vs ⓒ-1(`.02` 재사용) + 엔진 합가규칙 범위 | webadmin Phase11(엔진) + 실무진. ⓒ-1 채택 시 step 00 생략·step 01 `.03`→`.02` 치환(manifest §0). |
| **CONFIRM:D1b-06** | 그룹② 박/완칼 `.06/.05`(9 comp) D-1b 오적재 여부 | webadmin Phase11 엔진 명세 + Phase C 박 배선(본 실행본 미포함 — 거짓 RESOLVED 회피, 정당). |

> 두 컨펌 모두 webadmin Phase11 엔진 명세 의존. 엔진 미구현 = 실청구 위험 0(큐 적재 유지·적용 유예 안전).

---

## 6. 차단/에스컬레이션 (인간 승인 대기)

- **실 COMMIT**(`./apply_loader.sh --commit`) — 영구 적재. 본 게이트 범위 너머. GO 실행본 제시(R1~R6 PASS)·인간 승인 + **엔진 `.03` 규칙 동시 배포** 필수.
- **엔진 `.03` 해석 규칙**(webadmin Phase11 evaluate_price) — 우리 밖·명세 제안만(제안본 §4). prc_typ UPDATE와 동시 배포 필수.
- 라이브 DRY-RUN은 lead 위임(이 게이트 작업 위임)으로 1회 실행 완료 — 추가 라이브 호출 불요.

---

## 7. 종합 판정

| 항목 | 결과 |
|------|:--:|
| R1 멱등성(독립 2-pass 델타 0) | ✅ |
| R2 원자성(단일 tx·파일 내 COMMIT 0) | ✅ |
| R3 실행가능성(13 comp 실재·FK 정합·접속) | ✅ |
| R4 단가행 불변(unit_price mismatch 0) | ✅ |
| R5 제약위반 0(FK 고아 0·롤백 후 무변경) | ✅ |
| R6 독립성·보정 하드코딩 0 | ✅ |

→ **전건 PASS · 판정 = GO**(롤백전용 DRY-RUN). 실 COMMIT·엔진 배포·컨펌 2건은 인간 승인 대기.
