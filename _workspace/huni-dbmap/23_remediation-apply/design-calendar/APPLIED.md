# 디자인캘린더 라이브 정정 — 적용 상태 기록 (APPLIED)

> **작성 2026-06-14** · round-13 라이브 정정 트랙. 권위 = 원본 엑셀 L1 최신 `24_master-extract-260610/design-calendar-l1.csv` (E1~E5 GO).
> **상태: 즉시적용 2건 DRY-RUN(롤백전용) 검증 완료 · 실제 COMMIT은 인간 승인 대기.**
> (디지털인쇄 트랙은 사용자 승인 후 COMMIT됨. 본 시트는 검증까지 산출하고 COMMIT은 인간 승인 대상.)

## 적용 후보 범위 — 즉시적용 2건 (단순 컬럼 UPDATE)

| ID | 상품 | 정정 전 | 정정 후 | 비고 |
|----|------|---------|---------|------|
| D-01 editor_yn | 탁상형(108)·미니(109)·벽걸이(111)·와이드(112) | editor_yn=N | editor_yn=Y | 디자인=에디터 surface. 엽서(110)는 엑셀 ● 없어 제외 |
| D-02 MES_ITEM_CD | 5상품 전부 | NULL | 007-0001 / 0002 / 0003 / 0004 / 0005 | 엑셀 명시·1:1·UNIQUE 충돌 0 |

## DRY-RUN 검증 로그 (롤백전용 BEGIN…ROLLBACK)

- 1회차 적용: `UPDATE 4`(editor_yn — 108/109/111/112, 엽서 110 제외 정확) + `UPDATE 1`×5(MES 007-0001~5)
- 변경 후 상태 확인: 108/109/111/112 editor_yn=Y·110=N(엽서 제외)·5상품 MES 채워짐
- ROLLBACK 후 라이브 불변 확인(editor_yn=N·MES=NULL)
- 제약위반 0. PK(prd_cd)만·MES UNIQUE 제약 없음(채움 안전 입증)
- **멱등 2회차: `UPDATE 0` + `UPDATE 0`(완전 무동작)** — WHERE `IS DISTINCT FROM` 가드(디지털 MINOR 개선 반영)로 재실행 0행

## 타임스탬프 추적 (사용자 6번)

- UPDATE: `upd_dt=now()` (변경 시각) → 이번 정정으로 바뀐 행 식별 가능
- t_prd_products에 note 컬럼 없음 → 변경이력은 upd_dt + 본 APPLIED 기록으로 추적(editor_yn·MES는 값 자체가 변경 증거)
- 신규 INSERT분(컨펌 후)은 reg_dt=now()로 식별

## 백업·되돌리기

- 백업: `backup-before-commit.txt` (5상품 정정 전 — editor_yn=N·MES=NULL·reg_dt=2026-06-03)
- `rollback.sql` 실행 시 정정 전 원문 복원(editor_yn N·MES NULL). 무손실.

## 미적용 (COMMIT 대기 + 컨펌 대기)

- **즉시적용 2건(D-01/D-02)**: DRY-RUN GO·**실제 COMMIT은 인간 승인 대기**.
- **신규적재 4건**(D-03 고정가·D-04 우드거치대·D-05 삼각대 공정·D-06 페이지/가공 옵션): 그릇 결정·공정 mint 선행 → Q-DC-A/B 후
- **컨펌대기 5건**(D-07 탁상링 제거·D-08 벽걸이링→공정·D-09 미니 카테고리·D-10 와이드 카테고리·D-11 종이 권위): Q-DC-C/D/E 인간 결정 후
- 설계는 `apply.sql` 주석 블록 + `cpq-plan.md` 보존

## MINOR / 다음 시트 개선 반영분

- 본 시트는 디지털인쇄 APPLIED의 MINOR(`WHERE 값 다를 때만` 가드)를 **이미 반영** — `editor_yn IS DISTINCT FROM 'Y'`·`"MES_ITEM_CD" IS DISTINCT FROM '007-000X'`로 완전 무동작 멱등 입증(2회차 0행).
- 디지털과 달리 본 시트 즉시적용분은 **카테고리 재연결이 아니라 컬럼 UPDATE** — 디자인캘린더는 카테고리 고아 0(디지털 "배경지=포장 고아"와 다른 구조). 카테고리 정정(D-09/10)은 전용노드 vs 엑셀구분 충돌이라 컨펌대기로 분류(즉시적용 아님).
