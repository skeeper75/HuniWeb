# COMP_FOLD_CARD_6CR use_dims proc_grp 보강 — 6단접지 잔존오탐 제거

> 스캐너 정밀화(proc_grp 흡수)의 데이터측 보완. **가격중립 메타 교정** — 인간 승인 + webadmin 게이트 대기.

## 무엇을·왜

- **문제**: contribution scan 정밀화(260705·proc_grp 흡수) 후에도 지그재그엽서(PRD_000030)의
  6단오시접지(PROC_000073)·6단미싱접지(PROC_000074)가 `UNCOVERED_PROCESS HIGH` 잔존오탐.
- **원인**: 카드접지 COMP(`COMP_FOLD_CARD_6CR`)가 `use_dims`에 `proc_grp`를 선언 안 함.
  오시/미싱 COMP(`COMP_PP_CREASE_1L`)는 `proc_grp:PROC_000029`를 선언 → 정밀화가 흡수해 해소됐으나,
  카드접지 COMP만 누락된 **데이터 불일치**.
- **실제**: `COMP_FOLD_CARD_6CR`은 공식 `PRF_DGP_C_6CR`에 이미 배선·과금 완비
  (min_qty 구간별 단가 · note `[묶음 동일단가: 6단오시접지 / 6단미싱접지]`). 저청구 아님.

## 가격중립 근거

1. 엔진(`engine.py` = `pricing.py` verbatim)은 `proc_grp`를 **사용하지 않음**(grep 0).
2. 단가행은 `min_qty`만으로 매칭(오시/미싱접지 동일단가) → `proc_grp` 추가해도 **단가 매칭 불변**.
3. **overlay 재스캔 확증**(스냅샷 사본에 본 교정 적용): 지그재그 6단접지 오탐 2건 소멸,
   전체 `UNCOVERED HIGH` **7→5**. 남은 5 = 전부 진짜 저청구(타공2·UV평판·도장인쇄·전사인쇄).

## 실행 절차 (hdx 검증체인)

1. `01-dryrun.sql` — 라이브 ROLLBACK 드라이런(백업 생성·UPDATE·게이트 통과 확인).
2. **[HARD] webadmin 실화면** — 지그재그엽서 가격시뮬레이터에서 견적 불변 확인.
3. 인간 승인 → `02-fix.sql` COMMIT(백업 `z_bak_fold6cr_usedims` 라이브 보유).
4. 사후 재스캔(`contribution_scan.py`) — 지그재그 오탐 0·전체 HIGH 5 확인.
5. 되돌릴 시 `03-undo.sql`.

## 남은 진짜 저청구 (UNCOVERED HIGH 5 · 다음 트랙)

| 상품 | 공정 | 조치 |
|---|---|---|
| 엽서캘린더·벽걸이캘린더 | 타공(PROC_000079) | webadmin 확증 → COMP_CUT_PERF_1H6 배선(단, 걸이구멍 제본가 baked 확인) |
| 아크릴키링 | UV평판인쇄(PROC_000111) | 인쇄비 배선 §18/§7 |
| 만년스탬프 | 도장인쇄(PROC_000112) | 인쇄비 배선 §18/§7 |
| 폰스트랩 | 전사인쇄(PROC_000110) | 인쇄비 배선 §18/§7 |
