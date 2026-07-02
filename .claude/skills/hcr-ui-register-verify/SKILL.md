---
name: hcr-ui-register-verify
description: 후니 제약규칙 하네스의 승인 후 안전 등록 + UI 실화면 검증 절차. 게이트 GO+인간 승인분만 t_prd_product_constraints에 COMMIT(백업→DRY-RUN→COMMIT→사후검증·undo 보유)하고, ★[HARD] webadmin 폼빌더 실화면(gstack)에서 역파싱·표시·조정가능·validate 막힘/통과 4항을 스크린샷 증거로 확인한다(§1 라이브 적재 전 실화면 규칙). '제약 등록 실행', '제약 COMMIT', 'UI 실화면 검증', '폼빌더 역파싱 확인', 'validate 미리보기 검증', '등록 다시' 작업 시 반드시 사용.
---

# 안전 등록 + UI 실화면 검증 절차

## 완료 정의
DB에 행이 들어간 것이 아니라, **비전문가 실무진이 UI에서 규칙과 차원을 읽고 조정할 수 있는 상태**가 완료다(사용자 directive: JSON은 사람에게 불편한 포맷).

## 절차 (wave 단위)
1. **선행 게이트** — `05_gate/gate-report.md` verdict=GO(또는 CONDITIONAL-GO 사유 수용) + 인간 승인 명시 확인. 미충족 시 NO-OP 보고.
2. **백업** — 대상 prd_cd의 기존 제약 행 전량 dump: `04_register/<wave>/backup-<ts>.sql`.
3. **DRY-RUN** — `apply-dryrun.sql`(BEGIN…ROLLBACK)로 멱등·제약위반 0 실증. 실패=중단·designer 반송.
4. **COMMIT** — `apply-fix.sql` 실행(`.env.local RAILWAY_DB_*`). t_prd_product_constraints 외 쓰기 금지.
5. **UI 실화면 4항 검증 [HARD]** — gstack browse + `HUNI_ADMIN_*`(읽기 탐색·저장/삭제 클릭 금지), `/admin/product-viewer/<prd>/constraints/`:
   | # | 확인 | FAIL 시 |
   |---|------|---------|
   | ① 역파싱 | 규칙이 빌더 편집 폼으로 열림(raw JSON 폴백 아님) | 즉시 undo→designer 반송 |
   | ② 표시 | 규칙명·차원(var)·조건·err_msg가 읽히는 형태 | 〃 |
   | ③ 조정가능 | 조건 값 변경이 UI에서 가능함을 확인 후 저장 없이 이탈 | 〃 |
   | ④ 동작 | `/validate/` 미리보기로 rule-spec의 막힘/통과 케이스 재현 | 〃 |
   스크린샷을 `screenshots/`에 저장(비밀값 비노출).
6. **사후검증** — 재SELECT로 행수·logic 일치, 전체 활성 규칙 병합 평가가 500 없이 도는지(validate 1회) 확인 → `postverify.md`.
7. **기록** — `register-log.md`에 백업·DRY-RUN·COMMIT·undo 경로. 다음 wave는 현 wave 실화면 통과 후에만.

## 부분 실패 처리
wave 내 일부 상품만 FAIL이면 해당 상품 행만 undo(규칙 단위 undo 분리 권장), 성공/롤백 목록을 분리 보고. 전체 재실행 금지(멱등이라도 불필요 COMMIT 회피).
