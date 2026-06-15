# D-1b prc_typ 정정 — 라이브 롤백전용 DRY-RUN 결과 (round-13 정정 트랙)

> 실행 2026-06-15 · `dbm-load-builder` · lead 승인 위임됨(이 작업 위임 = DRY-RUN 승인).
> 절차: `BEGIN; <체크섬 before>; PASS1; PASS2; <검증 SELECT>; ROLLBACK;` 단일 트랜잭션.
> **NEVER COMMIT** — 무조건 ROLLBACK으로 종료, 라이브 무변경 확인. 비밀번호 미출력.

## 0. 빌드 전 라이브 실측 재확인 (stale 방지 · 제안본 §3-1 재현)

| 확인 | 라이브 실측(2026-06-15) | 제안본 정합 |
|------|--------------------------|:--:|
| `t_cod_base_codes` PRICE_TYPE 그룹 | `.01`(단가형)·`.02`(합가형)만 — **`.03` 비점유** | ✅ §1-2 |
| `t_cod_base_codes` PK / reg_dt | PK=`cod_cd` · `reg_dt` NOT NULL DEFAULT now() · `upd_dt` nullable | ✅ §1-2 |
| 13 comp 실재·현 prc_typ·comp_typ | 13 전건 실재 · 전부 `PRICE_TYPE.01` · `PRC_COMPONENT_TYPE.04` | ✅ §3-1 |
| 13 comp 단가행수 | CREASE/PERF=10 · VARTEXT/VARIMG=23 · CORNER_ROUND=9 | ✅ §3-1 |
| 제외 2 comp | CORNER_RIGHT 9행 전구간 0.00 · CUT_PERF_1H6 23행 전구간 0.00 | ✅ §3-1 |
| `t_prc_price_components` PK / prc_typ | PK=`comp_cd` · `prc_typ_cd` nullable · `upd_dt` nullable | ✅ |
| 현재 `.03`인 comp | **0행** (1회차 13행 UPDATE 예상) | ✅ |

## 1. DRY-RUN 2-pass 결과 (멱등성 R1)

| 단계 | base_code INSERT | comp UPDATE | after: comp@.03 | after: base@.03 |
|------|:--:|:--:|:--:|:--:|
| **PASS 1** | `INSERT 0 1` | `UPDATE 13` | 13 | 1 |
| **PASS 2** (재실행) | `INSERT 0 0` | `UPDATE 0` | 13 | 1 |

→ **멱등 PASS**: 2회차 델타 0(INSERT 0·UPDATE 0). `ON CONFLICT DO NOTHING` + `AND prc_typ_cd <> '.03'` 가드 작동.

## 2. unit_price 불변 (byte-identical · 돈-크리티컬)

- 정정 전(`_cp_before`) vs 정정 후 component_prices(13 comp + 제외 2 = 15 comp) md5 체크섬 대조.
- 체크섬 = `comp_price_id : unit_price : siz_cd : min_qty` 정렬 집계.
- **mismatch 0행** → `unit_price` 전건 byte-identical. 단가행 단 한 행도 변경 없음. ✅

## 3. 제약위반 (R5)

| 검사 | 결과 |
|------|:--:|
| `prc_typ_cd` → `t_cod_base_codes` FK 고아 (`.03` 포함) | **0행** ✅ |

→ base_code `.03` 선적재 덕에 정정된 13 comp의 `prc_typ_cd='PRICE_TYPE.03'` 전건 참조 무결. 타 제약 위반(타입/길이/NOT NULL/CHECK) = UPDATE가 메타 1컬럼·now()만이라 해당 없음.

## 4. 롤백 후 라이브 무변경 확인

| 재확인(롤백 후·별 트랜잭션) | 결과 |
|------|:--:|
| `t_cod_base_codes` `.03` 행수 | **0** (원복) ✅ |
| `t_prc_price_components` `.03` 행수 | **0** (원복) ✅ |

→ ROLLBACK으로 라이브 완전 원복. 아무것도 커밋되지 않음.

## 5. RESOLVED 재현값 (제안본 §6 · 보정 하드코딩 0)

`.03` 규칙 = `min_qty<=qty` 중 `min_qty` 최대 행의 `unit_price` **1회**(÷min_qty 없음·×qty 없음). 라이브 단가행만 읽음(보정값 주입 0).

| 케이스 | comp | qty | 매칭구간 | 라이브 단가 | **.03 산출** | 가격표 정합 |
|--------|------|:--:|:--:|:--:|:--:|:--:|
| 엽서 C3 후가공분 | COMP_PP_CREASE_1L | 100 | min_qty=100 | 10,000 | **10,000** | ✅ → 총 104,330 |
| 상품권 C2 후가공분 | COMP_PP_PERF_1L | 100 | min_qty=100 | 10,000 | **10,000** | ✅ → 총 48,073 |
| C4 비경계 | COMP_PP_CREASE_1L | 250 | min_qty=100 | 10,000 | **10,000** | ✅ ⓒ만 단조 정합 |

**대비(C4, 250매)**: `.01`(×qty)=**2,500,000**(과대) / `.02` 명세식(÷100×250)=**25,000**(300매 15,000 초과 = 단조성 위반) / **`.03`(1회)=10,000** ← 가격표 단조 정합. → **.03만 정합** 실증.

> 한계(정직): 엔진(evaluate_price) 미구현이라 엽서 C3=104,330·상품권 C2=48,073 **전체 합산 재시뮬은 불가**(인쇄·용지·코팅 합산은 엔진 구현 후). 후가공분이 `.03`에서 10,000(1회)됨은 라이브 단가행으로 확인 — 보정값 0.

## 6. 종합

| 항목 | 결과 |
|------|:--:|
| 13행 UPDATE (1회차) | ✅ |
| 멱등 2회 델타 0 | ✅ |
| unit_price byte-identical (불변) | ✅ |
| prc_typ FK 고아 0 | ✅ |
| 롤백 후 라이브 무변경 | ✅ |
| RESOLVED 재현(C3/C2/C4) 보정값 0 | ✅ |

→ DRY-RUN 전건 통과. **R-게이트(R1~R6) 최종 판정은 `dbm-validator`(별도 에이전트)** — 본 결과는 빌더 자가실증이며 자기승인 아님.
