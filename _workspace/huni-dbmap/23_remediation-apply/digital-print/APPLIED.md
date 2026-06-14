# 디지털인쇄 라이브 정정 — 적용 완료 기록 (APPLIED)

> **적용 2026-06-14** · round-13 라이브 정정 트랙 · 인간(사용자) 승인 후 COMMIT.
> 권위 = 원본 엑셀 L1 최신 `24_master-extract-260610/digital-print-l1.csv` (E1~E5 GO).
> 검증 = `17_correctness/_gate/digital-print-live-remediation-gate.md` (K1~K6 + 6대 기준 전건 PASS·GO).

## 적용 범위 — 즉시적용 4건 (카테고리 재연결)

| 상품 | prd_cd | 정정 전 | 정정 후 | 비고 |
|------|--------|---------|---------|------|
| 인쇄배경지(OPP봉투타입) | PRD_000043 | 고아 CAT_000296(배경지·upr=NULL) main=Y | 정상 CAT_000273(인쇄배경지OPP·upr=012 포장) main=Y + 296 main=N | — |
| 인쇄배경지(투명케이스타입) | PRD_000044 | 고아 CAT_000296 main=Y | 정상 CAT_000274(투명케이스) main=Y + 296 main=N | — |
| 인쇄헤더택 | PRD_000045 | 고아 CAT_000296 main=Y | 정상 CAT_000275(인쇄헤더택) main=Y + 296 main=N | — |
| 라벨/택 | PRD_000046 | 고아 CAT_000296 main=Y | 정상 CAT_000283(라벨/포장스티커) main=Y + 296 main=N | — |

## 실행 로그

- 백업: `backup-before-commit.txt` (4상품 정정 전 상태 — CAT_000296·main=Y·note공백·reg_dt=2026-06-03)
- DRY-RUN(롤백전용): `INSERT 0 4` + `UPDATE 4` + ROLLBACK — 제약위반 0, 라이브 불변 확인
- COMMIT: `INSERT 0 4` + `UPDATE 4` + COMMIT (exit 0)
- 검증: 8행(4 정상연결 main=Y + 4 고아강등 main=N), note 변경이력·upd_dt 반영 확인
- 멱등 2회차: `INSERT 0 4`(ON CONFLICT DO UPDATE·값 동일) + `UPDATE 0`(고아강등 안정)

## 타임스탬프 추적 (사용자 6번)

- 신규 INSERT 4행: `reg_dt=now()`(적용 시각) → 이번 정정으로 들어간 행 식별 가능
- UPDATE: `upd_dt=now()` + `note` "정정 2026-06-14: …" 변경이력 → 무엇이 바뀌었는지 DB 조회 가능

## 미적용 (이번 COMMIT 제외)

- **신규적재 5건**(W-07/10/13/18·전용 커팅·접지·형상·종이 누락) — 형상값 적재처(prcs_dtl_opt) 라이브 부재 → Q-DP-D 컨펌 후
- **컨펌대기 5건**(W-05 상품권 노드·W-06 박색 8상품·W-08/11 봉투·케이스 세트·W-17 separator) — Q-ID-A/B·Q-DP-B/C 인간 결정 후
- 설계는 `apply.sql` 주석 블록 + `cpq-plan.md` 보존

## 되돌리기

`rollback.sql` 실행 시 정정 전 원문 복원(4 정상연결 삭제 + 고아296 main=Y 복귀). 단 note는 NULL 복원(원래 공백이라 무손실).

## MINOR (다음 시트 개선 반영)

1a INSERT의 `ON CONFLICT DO UPDATE`는 재실행 시 4행 upd_dt만 재갱신(값 동일·데이터 오염 0). 변경 4시트 양식에선 `WHERE 값이 실제 다를 때만` 가드를 추가해 완전 무동작 멱등으로 개선.
