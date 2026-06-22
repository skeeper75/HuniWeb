# commit-log.md — §21 V1 과대청구(단/양면) 교정 라이브 COMMIT 기록

> §21 카탈로그 정합 · 2026-06-23 · **인간 승인 완료 → 라이브 운영 DB 실 COMMIT**.
> 대상: 명함 PRD_000031/032/033 (PRF_NAMECARD_FIXED) + 엽서북 PRD_000094 (PRF_PCB_FIXED).
> 프로토콜: 백업 → C-1/공유범위 SELECT → DRY-RUN(evaluate_price 실호출) → COMMIT → 사후검증 → undo 보유.

---

## 0. 실행 결과 한 줄

단면/양면 판별축(print_opt_cd)이 전 행 NULL이라 **단면+양면 단가행 둘 다 silent 합산**(과대청구)되던 결함을,
S1행=POPT_000001(단면)·S2행=POPT_000002(양면) 충전 + use_dims 토큰 등재로 **택일 1면만 매칭**.
명함 8,000→3,500 · 엽서북 22,500→단면11,000/양면11,500. **단가값 0변경(verbatim)** · COMMIT 성공 · 멱등 확인 · undo 보유.

---

## 1. C-1 (코드 실재) — ★명세 가정 정정

- 명세는 `PRINT_OPT.01/02`(t_cod_base_codes) 가정 → **실측 결과 다름**.
- `t_prc_component_prices.print_opt_cd` FK = **`t_prt_print_options`**(`fk_compprice_prtopt`).
- 실재 코드(use_yn=Y·del_yn=N·이미 사용 중 689/742행): **POPT_000001=단면 · POPT_000002=양면**.
- → mint/DDL 0 · 거버넌스 §12 불요. 본 교정은 기존 코드 참조만.

## 2. 공유범위 (클래스 B 핵심)

| comp | 배선 공식(타 0) | 바인딩 상품 | 무관 상품 공유 | 판정 |
|------|---|---|:--:|:--:|
| COMP_NAMECARD_STD_S1/S2 | PRF_NAMECARD_FIXED | 031·032·**033**(전부 명함) | **없음** | 안전 |
| COMP_PCB_S1_20P/S2_20P | PRF_PCB_FIXED | 094(전용) | **없음** | 안전 |

- ★작업지시는 031/032만 언급했으나 **033(스탠다드명함)도 같은 comp 공유** → 한 번 교정에 033 동시 해소(누락 아님·정합).
- 094 30P variant(COMP_PCB_*_30P)는 어느 공식에도 미배선(도달불가) → 본 교정 범위 밖·별건.

## 3. 안전 시퀀스 단계별 결과

| 단계 | 내용 | 결과 |
|------|------|------|
| 0. 물리 백업 | 대상행 현재값 timestamped SELECT | `backup-20260623_015051.sql` (전 행 print_opt_cd=NULL·기준선 238행/1,049,120) |
| 1. C-1 코드 실재 | print_opt_cd FK·코드 SELECT | POPT_000001/002 실재(§ shared-range.md) |
| 2. 공유범위 | 공식·바인딩·comp roster SELECT | 무관 상품 공유 0 (둘 다 안전) |
| 3. DRY-RUN | evaluate_price 실호출(트랜잭션+ROLLBACK) | 8,000→3,500·22,500→11,000/11,500·verbatim PASS |
| 4. ★COMMIT | apply.sql COMMIT 모드 | **COMMIT 성공**·G-1 verbatim PASS·G-2 FK PASS |
| 5. 사후검증 | fresh connection 영속 + evaluate_price 재호출 | 031/032/033·094 전부 택일 단일값 영속 |
| 6. 멱등 | apply.sql 재실행 | 전 UPDATE 0 (수렴) |
| 7. undo 보유 | 되돌리기 스크립트 | `undo.sql` (DRY-RUN 검증·미실행) |

## 4. COMMIT 변경 내역

| comp_cd | print_opt_cd 충전 | 단가행 | sum(불변) | use_dims |
|---------|:--:|:--:|:--:|----------|
| COMP_NAMECARD_STD_S1 | POPT_000001(단면) | 2 | 7,300.00 | `["mat_cd","min_qty","print_opt_cd"]` |
| COMP_NAMECARD_STD_S2 | POPT_000002(양면) | 2 | 9,300.00 | `["mat_cd","min_qty","print_opt_cd"]` |
| COMP_PCB_S1_20P | POPT_000001(단면) | 117 | 505,980.00 | `["siz_cd","min_qty","print_opt_cd"]` |
| COMP_PCB_S2_20P | POPT_000002(양면) | 117 | 526,540.00 | `["siz_cd","min_qty","print_opt_cd"]` |

- unit_price SET 0개 · GRAND 238행/1,049,120.00 불변 · FK 고아 0.
- 마스터(t_prt_print_options) INSERT/UPDATE 0 (참조만).

## 5. COMMIT 출력 (요약)
```
BEGIN → UPDATE 2/2/117/117(print_opt_cd) + UPDATE 1×4(use_dims)
NOTICE: VERBATIM GUARD PASSED → NOTICE: FK GUARD PASSED → COMMIT (exit 0)
```

## 6. 되돌리지 말 것 (메모리용)

- 4 comp 단가행 **print_opt_cd 충전**: S1=POPT_000001(단면)·S2=POPT_000002(양면) — 명함 STD·엽서북 PCB_20P.
- 4 comp **use_dims에 print_opt_cd 토큰** 등재.
- 이 교정으로 명함(031/032/033) 양면비 +4,500/100매·엽서북(094) 단/양면 이중합산(+11,000~11,500/장) 과대청구 해소.
- ★033(스탠다드명함)도 공유 comp라 동시 해소됨 — 정합(누락 아님).
- 단가값 전부 verbatim 불변(8,000→3,500은 택일 분리이지 단가 변경 아님).
- 되돌릴 경우만 `undo.sql`(print_opt_cd NULL 원복 + use_dims 토큰 제거). 가역.
