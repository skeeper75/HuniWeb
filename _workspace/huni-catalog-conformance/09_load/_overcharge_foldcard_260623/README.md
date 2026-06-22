# _overcharge_foldcard_260623 — 접지카드 과대청구(V2) 교정 적재 준비

> §21 카탈로그 정합 · 2026-06-23 · dbm-load-builder. **실 COMMIT 없음** — 멱등 SQL + 롤백 DRY-RUN까지.
> 대상: PRD_000027/028/029 (2단/미니/3단접지카드) · 공식 PRF_DGP_E · 4 FOLD_LEAF comp.
> 권위: `06_gate/overcharge-remediation-spec.md` V2(권고② proc_grp/proc_cd 충전) · `04_price_engine/overcharge-scan-catalog.md` OC-04/05/06.

## 결함·교정 한 줄
4 접지방식 comp가 판별축(proc_cd) 없이 use_dims=["min_qty"]만 가져 **4개 접지비(합 25,000) silent 전부 합산**
(손님 +18,000~20,000/장 과대). 교정 = proc_cd 충전 + use_dims 토큰 등재로 P8-1 택일 분리(택일 1개=6,000). **단가값 0변경.**

## 파일
| 파일 | 내용 |
|------|------|
| `fold-remediation-mapping.csv` | 4 comp 교정 매핑(proc_cd·use_dims before/after·실재 여부·BLOCKED 사유) |
| `apply.sql` | 멱등 교정 SQL(단일 트랜잭션·verbatim 가드 내장·기본 ROLLBACK). STEP 1 활성(3FOLD)·STEP 2~4 주석(BLOCKED) |
| `dryrun_p8_reproduce.sql` | P8-1 택일 분리 SQL 재현(BEFORE 25000/부분 25000/전체 6000/verbatim 불변) — 실행 검증됨 |
| `dryrun_evaluate.py` | Django evaluate_price 실호출 DRY-RUN(환경 확보 시·미실행·폴백=SQL 재현) |
| `dryrun-result.md` | C-2 판정·실측·교정 요약·DRY-RUN 결과·verbatim 통과 |
| `verbatim-guard.md` | 단가값 불변 게이트(기준선·자동 가드·되돌리기) |

## 상태 = BLOCKED (부분)
- **C-2 = 부분 BLOCKED**: 4 proc_cd 중 **3단접지(PROC_000060)만 실재**. 4단대문접지·반접지 전무, 4단병풍접지 부분매칭.
- **부분 적재 무효**: P8-1은 4개 전부 교정돼야 분리(DRY-RUN 입증·1개만 교정 시 여전히 25,000). → **전체 묶어 BLOCKED.**
- **선행 필요**: §12 기초코드 등록(4단대문접지·반접지 + 4단병풍접지 "4단" 한정 결정). 임의 채번 금지·마스터 직접수정 금지.
- **메커니즘은 검증 완료**: 전체교정 시 25,000→6,000 분리·verbatim 불변 실증. 막힌 건 코드 실재뿐.

## 인간 COMMIT 승인 시 다음 액션
1. §12(hbg) 코드 등록: 4단대문접지·반접지 신규 + 4단병풍접지 코드 확정(PROC_000071 재사용 vs 신규).
2. `fold-remediation-mapping.csv`의 `__PENDING_*__`·CONDITIONAL을 확정 proc_cd로 치환.
3. `apply.sql` STEP 2~4 주석 해제 + proc_cd 확정값 기입.
4. `apply.sql` 기본 ROLLBACK 재확인 → 인간 승인 후 COMMIT 모드로 실행(dbm-load-execution 위임).
5. `dbm-validator`/`hcc-conformance-gate`에 핸드: evaluate_price 실호출로 027/028/029 25,000→6,000 독립 비준.
6. 028은 옵션그룹 0행 → 접지방식 선택 UI 적재 별 트랙(dbm-cpq-option-mapping) 병행.
