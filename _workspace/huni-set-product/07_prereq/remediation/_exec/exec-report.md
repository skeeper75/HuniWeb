# W1 자재 교정 — 실행 보고 (exec-report)

실행자: dbm-load-execution 방법론 · 라이브 Railway `railway` DB · 2026-06-24
권위: w1-verdict.md(GO) + 사용자 승인("10행 전부 + 굿즈 오배선 동반") · 부1 COMMIT / 부2 CONFIRM 분리

## 종합 결과

| 구분 | 결과 |
|---|---|
| **부1 — 종이 계층 부활** | **10행 COMMIT 완료** (UPDATE 1 P2-A + UPDATE 9 P3-A) |
| **부2 — 굿즈 PET 오배선** | **CONFIRM 분리(COMMIT 0)** — 3행 대상 식별·백업 보존·미변경 |
| 사후검증 6항목 | **전부 PASS** |
| FK 고아 | **64 → 23** (41 복구) |
| 돈무손상 | 단가행 0 · 셋트 094 엽서북 구성 불변 |
| undo | 백업 복원 가역 보유 |

## 부1 — COMMIT 행수 (자재 10행 del_yn 'Y'→'N')

| 그룹 | mat_cd | 자재명 | 활성 자식 |
|---|---|---|---|
| P2-A 전용지 | MAT_000246 | 전용지 | (셋트 072·082 표지 FK 해소) |
| P3-A root | MAT_000071 | 백모조 | 3 |
| P3-A root | MAT_000075 | 아트 | 8 |
| P3-A root | MAT_000085 | 스노우 | 8 |
| P3-A root | MAT_000094 | 앙상블 | 5 |
| P3-A root | MAT_000100 | 랑데뷰 | 2 |
| P3-A root | MAT_000103 | 몽블랑 | 9 |
| P3-A root | MAT_000122 | 띤또 | 2 |
| P3-A root | MAT_000143 | 투명 | 2 |
| P3-A root | MAT_000146 | 반투명 | 2 |
| **계** | **10행** | | **41 자식 계층 복구** |

## 부2 — 굿즈 PET 처리 (CONFIRM 분리)

대상 활성 배선 3행(미변경·백업 보존):
- `PRD_000193 머그컵 · MAT_000143 투명 · USAGE.07`
- `PRD_000193 머그컵 · MAT_000146 반투명 · USAGE.07`
- `PRD_000227 미니우치와키링 · MAT_000146 반투명 · USAGE.07`

판정 = **CONFIRM 분리(P3-PET)**. 사유:
1. 권위(상품마스터 goods-pouch)는 투명/반투명을 머그컵·키링의 **정당한 `선택(옵션)_선택` 옵션값**으로 등재 → 스퓨리어스 아님(논리삭제하면 정당 옵션 소멸).
2. 올바른 굿즈 전용 투명/반투명 자재 라이브 **부재**(타 도메인=책자/아크릴/파우치/스티커만) → 재배선 대상 없음·타 도메인 자재 재배선=추측(금지).
3. 본질=권위가 투명/반투명을 **CPQ 선택 옵션값**으로 다룸(USAGE.07 종이-root 자재 BOM 아님). 올바른 정리=PET 종이-root 배선 제거+CPQ 옵션값 재표현 → **셋트/CPQ 옵션 설계 트랙** 의존. 자재 교정 범위 밖.

→ 추측 COMMIT 금지·CONFIRM 분리. (사용자 "굿즈 오배선 동반" 의도는 라이브+권위 실측 결과 안전 자동처리 불가로 판명 — 동반 정리는 CPQ 옵션 트랙에서 인간 승인.)

## 백업명 (물리 백업 테이블)
- `bak_t_mat_materials_w1_20260624_1137` — 부1 부활 10행 교정전 스냅샷(전부 del_yn='Y')
- `bak_t_prd_product_materials_w1goods_20260624_1137` — 부2 PET 배선 3행 보존(전부 wire del_yn='N')

## 안전 프로토콜 준수
- FK 선행 확인: 부활 10행 실재·del_yn='Y' 재조회 / 굿즈 3행 PK 재조회 ✅
- 물리 백업 선행(COMMIT 직전) ✅
- DRY-RUN(BEGIN…ROLLBACK): 제약위반0·멱등 delta0·예상카운트·FK고아 64→23 실증 → 별도 트랜잭션 COMMIT ✅
- 멱등: `del_yn IS DISTINCT FROM 'N'` 가드·물리 DELETE/DDL/mint 0 ✅
- 사후검증 6항목 전부 PASS ✅
- undo 보유: `_exec/undo.sql`(백업 복원 권장·폴백 재논리삭제) ✅
- 광역 쓰기 금지: 대상 한정 UPDATE만(t_mat_materials 10행), 부2 미변경 ✅

## 산출물 (_exec/)
backup.sql · dryrun.sql · apply.sql(래핑본) · undo.sql · post-verify.md · exec-report.md
