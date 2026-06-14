# 변경 4시트 라이브 정정 — 적용 완료 기록 (APPLIED)

> **적용 2026-06-14** · round-13 라이브 정정 트랙 · 인간(사용자) 승인 후 COMMIT.
> 권위 = 원본 엑셀 L1 최신 `24_master-extract-260610/<slug>-l1.csv` (E1~E5 GO).
> 검증 = `17_correctness/_gate/changed-4sheets-live-remediation-gate.md` (K1~K6 + 6대 기준 전건 PASS·시트별 GO).
> 디지털인쇄(`_APPLIED`=`digital-print/APPLIED.md`)와 동일 패턴(백업→DRY-RUN→COMMIT→검증→멱등).

## 적용 결과 (각 시트 apply.sql 즉시적용 블록만 COMMIT)

| 시트 | 적용 내용 | 실행 로그 | 검증 |
|------|-----------|-----------|------|
| **실사** | 카테고리 28상품(고아 CAT_000298→정상 067~099) + 원단 자재 7건(MAT_000181~188·실사소재.08→원단.05) | `INSERT 28`+`UPDATE 28`+`UPDATE 7`+COMMIT | 정상연결28·고아강등28·원단.05=7 ✓ |
| **스티커** | 점착지 3종(MAT_000084/242/243·종이.01→스티커.11) + 063 화이트인쇄공정(PROC_000008) + 066 빈옵션그룹(OPT-000004) 논리삭제 | `UPDATE 3`+`INSERT 1`+`UPDATE 1`+COMMIT | 점착지.11=3·화이트공정1·빈옵션use_yn=N ✓ |
| **아크릴** | 단품형 14상품(146~159·고아 CAT_000299→정상 140~154) | `INSERT 14`+`UPDATE 14`+COMMIT | 정상연결14·고아강등14 ✓ |
| **굿즈파우치** | 33상품 동명매칭(고아 CAT_000301~306→정상 노드) | `INSERT 33`+`UPDATE 33`+COMMIT | 고아강등33 ✓ |

## 안전망

- 백업: 각 `<slug>/backup-before-commit.txt` (COMMIT 전 영향행 현재상태)
- 롤백: 각 `<slug>/rollback.sql`
- 멱등 2회차: 자재/공정/옵션 UPDATE 0(WHERE 값가드·스티커 ON CONFLICT DO NOTHING) / 카테고리 INSERT ON CONFLICT 값동일(upd_dt만) — 데이터 안정

## 타임스탬프 추적 (사용자 6번)

- 카테고리 신규 연결 75행: `reg_dt=now()` + note "정정 2026-06-14: 고아→정상…"
- 자재/옵션 UPDATE: `upd_dt=now()` + note 변경이력 → DB 조회로 정정분 식별 가능

## 핵심 — 카테고리 고아 패턴 정상화 (디지털 포함 누적 79상품)

전역 고아 카테고리 노드(upr_cat_cd=NULL·lvl>1) 14개에 잘못 묶여 있던 상품을, 이미 비어 실재하는 정상 노드로 재연결한 횡단 정정. remediation-roadmap P1 BATCH-1(카테고리 재연결) 실현:
- 디지털인쇄 4(배경지OPP·케이스·헤더택·라벨택) + 실사 28 + 아크릴 14 + 굿즈 33 = **79상품**
- 미정정 고아 ~32상품(상품악세사리15·명함10·상품권2·플래너5) = 유효 6시트 확대 시 동일 방식 처리

## 미적용 (이번 COMMIT 제외 — 컨펌/신규적재)

- 컨펌대기: 실사6·스티커8·아크릴9·굿즈7 (size→option·코팅·봉투세트·박색·형상 적재처 등) — 인간 결정 후
- 신규적재: 봉제·후가공·조각수 등 — 형상 적재처(prcs_dtl_opt) 부재 → ddl-proposer/컨펌 후
- 설계 보존: 각 `apply.sql` 주석 블록 + `cpq-plan.md`
