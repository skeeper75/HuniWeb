# exec-report — 공정축 9 thin-mirror 논리삭제 안전 적재 (COMMIT 완료)

실행: 2026-06-19 / hbd-load-executor / 사용자 승인분만 (9건 GO · BLOCKED 3건 보류 큐)
권위: 라이브 t_* executor 직접 재실측(D6) · 논리삭제 권위 [[dbmap-del-yn-soft-delete-authority]]
입력: processes/{mapping.csv·apply-plan.md·reconcile.md} (D4 PASS·Claude↔codex 14/14 합의)

## 1. 실행 전제 확인 (3조건)
- (a) 사용자 승인: ✅ 9건 전부 적재 승인
- (b) codex reconcile 합의: ✅ 14/14 액션 합의·divergence 0 (reconcile.md §5 D4 PASS)
- (c) price_dependent=N: ✅ 9건 전부 pd=N (mapping.csv) — 외부참조 0 실증으로 가격 비종속 확정

## 2. 물리 백업
- 테이블: `bak_proc_dedup_round_pilot` (고정 접미사·Date.now() 금지)
- 백업 행수: **9** (PROC_000087·088·089·091·093·094·095·096·097)
- undo 안전망 보유: `_exec/undo.sql` (9건 del_yn='N' 복원)

## 3. DRY-RUN (롤백전용·2-pass 멱등)
| 항목 | 결과 |
|---|---|
| PASS1 delta | **9** (정확히 예상 affected) |
| PASS2 delta (멱등 가드) | **0** (이미 Y → no-op) |
| 제약위반 | 0 |
| FK고아 (CASCADE) | 0 (멤버 외부참조 0) |
| 트랜잭션 | ROLLBACK (무손상) |

## 4. COMMIT
- 실행: `psql -1 -f apply.sql` (apply.sql 본문에 BEGIN/COMMIT 내장 없음 — 비인가 COMMIT 가드)
- 결과: **UPDATE 9** (실제 affected = 예상 9 일치)
- 변경: t_proc_processes 9행 del_yn='N'→'Y'·upd_dt=now(). 정본 부모 무변경·단가행 이동 0·바인딩 재배선 0·물리삭제 0.

## 5. 사후검증 V1~V5 (COMMIT 후 라이브 직접 재실측)
| 게이트 | 검증 | 결과 |
|---|---|---|
| V1 | 자식 9건 del_yn='Y' | ✅ 전부 Y |
| V2 | 정본 부모 9건 del_yn='N' 무변경 | ✅ 전부 N (UV/완칼/반칼/스티커완칼/봉제/부착/족자제작/에폭시/열재단) |
| V3 | 가격 무영향 (cp_total=7288·prdproc_total=270 불변) | ✅ 7288 / 270 (COMMIT 전후 동일) |
| V4 | FK고아 0 (9 자식 cp/prdproc/children) | ✅ 전부 0,0,0 |
| V5 | 멱등 (재-apply delta=0) | ✅ 0 |
| V-BLOCKED | 086/090/092 미실행 (del_yn=N·comp 30/50/18 보유) | ✅ 미실행 확인 |

## 6. 게이트 판정
- **D5 (적재 안전성)**: ✅ PASS — 멱등(PASS2/V5 delta 0)·BLOCKED 미실행·물리백업 9행·DRY-RUN GO·사후 delta 일치(9)·FK고아 0.
- **D6 (생성-검증 독립성)**: ✅ PASS — executor가 라이브 직접 재실측(refs=0 직접·간접 모두 독립 확인·생성자 주장 비신뢰). DRY-RUN과 COMMIT 스크립트 분리·apply 본문 BEGIN/COMMIT 내장 없음.

## 7. BLOCKED 3건 escalate 기록 (이번 세션 미실행)
| 멤버 | 정본 | comp_prices | 차단 사유 | 라우팅 |
|---|---|:---:|---|---|
| PROC_000086 미싱 | PROC_000030 | 30 (COMP_PP_PERF_1L) | 가격사슬 단절: 옵션→부모030 ref·가격→자식086 키. 삭제 시 미싱 가격 30행 전손 | dbm-price-arbiter / 경로 Y 재배선 |
| PROC_000090 오시 | PROC_000029 | 50 (COMP_PP_CREASE_1L/2L/3L) | 동일 메커니즘. 삭제 시 오시 가격 50행 전손 | dbm-price-arbiter / 경로 Y |
| PROC_000092 타공 | PROC_000079 | 18 (COMP_CUT_PERF_1H6) | 동일. 삭제 시 타공 가격 18행 전손 | dbm-price-arbiter / 경로 Y |
- pricing.py 검증(reconcile.md §2): 엔진 부모→자식 fallback 부재·proc_grp use_dim은 매칭축 제외 → 단절 실재 → 삭제 절대 금지 결론 강화.
- 추가 가드(executor 재실측): component_prices.dim_vals·option_items ref_key에 9 GO 자식 코드 임베드 0 — 9건은 간접참조도 없음(BLOCKED와 분리 정당).

## 8. KEEP (정당구분·통합 금지)
- 핑크 010/036 (별색007 vs 박033 부모 상이) · UV 002/016 (독립 vs 코팅013) · 085/031/032 가변(별개 부모)

## 9. 산출물
- backup.sql · dryrun.sql · apply.sql · verify.sql · undo.sql · exec-report.md (전부 `processes/_exec/`)
- 백업 테이블 `bak_proc_dedup_round_pilot` (라이브·undo GO 후 DROP)
