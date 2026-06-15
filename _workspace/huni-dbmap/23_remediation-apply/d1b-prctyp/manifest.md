# D-1b 후가공 prc_typ 정정 — 적재 실행본 매니페스트 (round-13 정정 트랙)

> 작성 2026-06-15 · `dbm-load-builder` · 권위 입력 = [[phase-b-d1b-remediation.md]] (GO·게이트 통과) + 라이브 실측(2026-06-15).
> 정정 방식 = **ⓒ-2**(신규 `PRICE_TYPE.03` · 라이브 충돌 0 실측). **돈-크리티컬 · 비파괴(실 COMMIT 인간 승인 너머)**.
>
> **[ⓒ-1 채택 시]** `00_preload_price_type_03.sql` 생략 + `01_update_comp_prctyp.sql`의 `SET prc_typ_cd='PRICE_TYPE.03'`을 `'PRICE_TYPE.02'`로, 멱등 가드 `<> 'PRICE_TYPE.03'`을 `<> 'PRICE_TYPE.02'`로 치환. (C-D1b = webadmin Phase11/실무진 결정)

---

## 1. 무엇을 바꾸나 (메타 1컬럼만)

| 단계 | 파일 | 대상 테이블 | 변경 | 영향 행수(실측) |
|------|------|-------------|------|:--:|
| step 00 | `00_preload_price_type_03.sql` | `t_cod_base_codes` | 신규 코드 `PRICE_TYPE.03(구간고정총액형)` 1행 INSERT | **1행** (멱등) |
| step 01 | `01_update_comp_prctyp.sql` | `t_prc_price_components` | 그룹① 13 comp의 `prc_typ_cd` `.01`→`.03` + `upd_dt=now()` | **13행** |

- **변경 컬럼 = `t_prc_price_components.prc_typ_cd` 메타 1컬럼 (+ `upd_dt`).** 그 외 어떤 컬럼·테이블도 변경 없음.
- **DDL 아님**: base_code는 행 추가(INSERT)일 뿐 — `ALTER`/`CREATE` 0. round-13 정정 트랙(경량).

## 2. 단가행 불변 보증 [HARD · 돈-크리티컬]

- **`t_prc_component_prices.unit_price`(단가행)는 단 한 행도 변경하지 않는다.** 두 SQL 파일 어디에도 `t_prc_component_prices`를 향한 `INSERT/UPDATE/DELETE`가 없다.
- 값은 가격표 엑셀과 전건 일치(round-16 216/216) — 정정은 "엔진이 이 값을 **어떻게 쓰나**"(메타)만 교정.
- DRY-RUN에서 component_prices 13+2 comp의 md5 체크섬을 정정 전/후 대조 → **mismatch 0행**(byte-identical) 실증(§dry-run-result.md).
- 보정 하드코딩 0 — 값 주입 SQL 없음.

## 3. 멱등 가드

| 단계 | 가드 | 재실행 거동 |
|------|------|------|
| step 00 | `ON CONFLICT (cod_cd) DO NOTHING` | 이미 `.03` 존재 시 no-op |
| step 01 | `AND prc_typ_cd <> 'PRICE_TYPE.03'` | 이미 `.03`인 행 제외 → 0행 |

→ DRY-RUN 2-pass: 1회차 INSERT 1·UPDATE 13 / 2회차 INSERT 0·UPDATE 0 (델타 0) 실증.

## 4. 정정 대상 13 comp (제외 2 명시)

CREASE 3 + PERF 3 + VARTEXT 3 + VARIMG 3 + CORNER_ROUND 1 = **13**.
- 전부 라이브 `prc_typ_cd='PRICE_TYPE.01'`·`comp_typ_cd='PRC_COMPONENT_TYPE.04'`·누진 총액형 단가행(실측).
- **제외**: `COMP_PP_CORNER_RIGHT`(9행 전구간 0.00)·`COMP_CUT_PERF_1H6`(23행 전구간 0.00, Phase A placeholder) → 가격 기여 0(정정 무의미).
- 그룹② `.06/.05`(박·완칼 9 comp) = `CONFIRM:D1b-06` + Phase C 박 배선 소관 → **본 실행본 미포함**(거짓 RESOLVED 금지).

## 5. FK/도메인 적재 순서

`apply.sql` = `BEGIN; \i 00 → \i 01; (로더가 ROLLBACK/COMMIT 주입)`.
- **step 00이 먼저** — `t_prc_price_components.prc_typ_cd='PRICE_TYPE.03'`이 `t_cod_base_codes`에 존재해야 도메인 유효. base_code 없이 UPDATE만 하면 prc_typ FK 고아.
- 단일 트랜잭션 · `ON_ERROR_STOP on` → 임의 문 실패 시 전체 롤백(원자성).

## 6. ⚠ 동시 배포 경고 (HARD)

**`01` prc_typ UPDATE(.03)와 엔진 `.03` 해석 규칙(webadmin Phase11 evaluate_price)은 반드시 동시 배포.**
엔진이 아직 미구현이라 현재 실청구 위험 0이나, prc_typ만 `.03`으로 바꾼 뒤 엔진이 `.03`을 모르면 **미정의 동작**(폴백 `.01`=과대청구 / `NULL`=가격 침묵 누락). 메타 정정과 엔진 규칙을 **분리 배포 금지**. (제안본 §4·§7)

## 7. 롤백 방법

- DRY-RUN(기본): `./apply_loader.sh` → `BEGIN…ROLLBACK`, 라이브 무변경.
- 실 COMMIT 후 원복이 필요하면: `UPDATE t_prc_price_components SET prc_typ_cd='PRICE_TYPE.01', upd_dt=now() WHERE comp_cd IN (<13 comp>) AND prc_typ_cd='PRICE_TYPE.03';` + (필요 시) base_code `.03` 비활성(`use_yn='N'`) 또는 DELETE(미참조 확인 후). 단, **엔진 .03 규칙과 동시 롤백**.

## 8. 인간 승인 게이트 (실 적용 전)

- 실 COMMIT(`./apply_loader.sh --commit`) = 인간 승인 너머. 본 실행본은 DRY-RUN까지.
- R-게이트(R1~R6)는 `dbm-validator`(별도 에이전트)가 수행 — 자기승인 금지.
- 미해소 컨펌: `C-D1b`(ⓒ-2 vs ⓒ-1) · `CONFIRM:D1b-06`(그룹② 박/완칼) — webadmin Phase11 엔진 명세 의존.
