# 미싱 dangling 배선 정리 (D1) — Phase D 독립 검증 verdict · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립. 결함 = G-D2 W5 잔재(검증자가 별색 dedup 검증 중 발견·OBS-1).
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. COMMIT 0·비밀값 비노출.

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

DELETE 4·2-pass delta 0·가격 보존·dangling 0·물리삭제 0 전건 라이브 실측. BLOCKER 0·불일치 0.

---

## R1 멱등성 — **PASS**
단일 ROLLBACK tx 2-pass: PASS1 DELETE 4 · **PASS2 DELETE 0**. 멱등키 `comp_cd IN (PERF_2L,PERF_3L) AND use_yn='N' 배선`(재실행 부재).

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 단일 트랜잭션·배선만 DELETE(comp/단가행 무변경).

## R4 영향행수 — **PASS (보고와 일치)**
독립 실측 **DELETE 4**: PRF_DGP_A(PERF_2L disp20·PERF_3L disp21) + PRF_DGP_D(PERF_2L disp11·PERF_3L disp12). 라이브 premise 4 dangling 확인. comp/단가행 변경 0.

## R6 ★가격 보존 + dangling 0 — **PASS (핵심)**
- **정본 PERF_1L 동반 배선 실측**: use_yn=Y·30 단가행(줄수 1/2/3 × 10구간 각각·W5가 2/3줄 dim_vals 흡수)·use_dims proc_cd/proc_grp. PERF_1L이 **PRF_DGP_A·PRF_DGP_D 둘 다 배선**(제거 후에도 perf1L_wiring_dgp=2 잔존).
- → 비활성 PERF_2L/3L 배선 4건 제거 후에도 **미싱 1/2/3줄 가격 경로 = 정본 PERF_1L로 전건 보존**(가격 손실 0). 엔진은 (proc_cd=PROC_000086, dim_vals.줄수, min_qty)로 PERF_1L 매칭.
- **dangling_after = 0**(use_yn=N PERF comp 배선 잔존 0)·orphan_comp 0.
- **PERF_2L/3L 단가행 20(10+10) 전건 보존**(배선만 DELETE·물리삭제 0). use_yn=N comp에 매달려 이력 보존.

## undo / 안전성 — **충분**
물리삭제 = 배선 4행만(comp·단가행 무손상). 백업 TSV(PERF 배선 34행·PERF_1L 컨텍스트 포함)로 4 배선 재INSERT 복원 충분. apply.sh `^ROLLBACK;` 1건 sed 치환(SAFE)·비밀값 비노출.

## 생성자 주장 vs 검증자 실측
| 항목 | 생성자 | 실측 | 판정 |
|------|--------|------|:--:|
| DELETE 4·comp/단가 0 | 보고 | 동일 | 일치 |
| PERF_1L 양 공식 동반·30행·가격 보존 | 주장 | **확인(perf1L_wiring_dgp=2·줄수 1/2/3×10)** | 일치 |
| dangling 0·PERF_2L/3L 20 보존·2-pass 0 | 주장 | 확인 | 일치 |
| 불일치 | — | 없음 | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·PERF_1L 동반 배선·dangling 라이브 실측.

### 최종: **GO — 실 COMMIT 가능**. 인간 승인 시 `apply.sh --commit`. 사후검증(dangling 0·PERF_1L 양 공식 배선 잔존·미싱 가격 불변) 권고.
