# Wave 2 실행본 매니페스트

> **하네스** hbg Phase 5 · `dbm-load-builder`(dbm-load-execution 스킬). **작성** 2026-06-18.
> **[HARD] 실 COMMIT 0.** Wave 2 = 라이브 실측 결과 **안전 축이동 실행본 0건**(전건 escalate).

---

## 0. 결론

| Wave 2 항목 | 로드맵 배치 | 실측 후 판정 | 실행본 |
|-------------|-------------|--------------|:--:|
| R8 인쇄면 14 → print_side | 라이브 직접·즉시 | 🔴 **ESCALATE** (목적지 행 0·도수 NOT NULL FK 무소스) | 없음 |
| R9 구수 5 → bundle | 라이브 직접·즉시 | 🟡 **ESCALATE** (목적지 행 0·dflt/2개1팩 무근거) | 없음 |
| R7 dtl_opt param 채움 | 라이브 직접(점진) | 🟡 **ESCALATE** (option_items 행 0·AX-5 미해소) | 없음 |

**→ 라이브 직접(경로 X) 멱등 SQL = 0건. 전건 경로 Y/선결 escalate.** 무리한 라이브 직접 INSERT 금지(task brief §★4).

---

## 1. 산출 파일

| 파일 | 역할 |
|------|------|
| `_deferred.md` | **★핵심** — Wave 2 전건 안전 판정·escalate 사유·라이브 실측 보드·Wave 재배치·인간 승인 질문 |
| `_backlog-pathY.md` | 경로 Y(개발자 v03 재적재) 백로그 — R8/R9 재인코딩·R7 AX-5 선결·위임 인터페이스 |
| `diagnose_wave2.sql` | 안전 판정 근거 재현 SELECT(READ-ONLY·쓰기 0) |
| `apply_wave2.sh` | 진단 로더(`diagnose` 모드만·commit 없음 — 안전 실행본 0이므로) |
| `manifest-wave2.md` | 본 문서 |
| `README.md` | 사용법·재현 절차 |

> **Wave 1과의 구조 차이:** Wave 1(`_exec_wave1/`)은 기존 행 in-place UPDATE/소프트삭제(가역·멱등 SQL 실재). Wave 2는 빈 목적지에 무소스 신규 INSERT라 **안전 실행본 자체가 성립 불가** → SQL 산출 0·진단/escalate 산출만.

---

## 2. 라이브 DRY-RUN 결과 (READ-ONLY 진단)

`./apply_wave2.sh diagnose` 실행(2026-06-18·BEGIN..ROLLBACK 방어·쓰기 0):

- R8: 소유 16상품 전건 `print_options` 행 **0** · NOT NULL `front/back_colrcnt_cd`(도수 FK) 무소스 확인.
- R9: 소유 3상품 전건 `bundle_qtys` 행 **0** · `dflt_yn`/2개1팩 무근거 확인.
- R7: option_items 전역 477행 중 dtl_opt 채움 6 · 대상 19상품 option_items 행 **0** · AX-5 미해소.
- 가격사슬: R8 cp 직접참조 **0** · R9 cp 직접참조 **0**(돈 크리티컬 본 wave 없음·formula 간접은 미실행이라 무접촉).
- 멱등/원자성: 축이동 SQL 0 → 적용할 변경 0 → COMMIT 0(ROLLBACK 방어).

---

## 3. hbg-validator 통지

- **Wave 2 = 라이브 직접 축이동 실행본 0건(전건 escalate).** 검증 포인트: ① 목적지 행 전무(print_options/bundle_qtys/option_items 0행 — 로드맵 "그릇 실재=즉시" 가정 반증) ② R8 `front/back_colrcnt_cd` NOT NULL FK 무소스(날조 금지 HARD) ③ R9 dflt_yn/2개1팩 무근거 ④ R7 AX-5 미해소+행 0 ⑤ 가격사슬 cp 직접 0참조(돈 크리티컬 본 wave 없음) ⑥ 경로 Y 백로그 정합(v03 재인코딩 근본).
- **자기검증 금지** — 본 산출(escalate 판정)은 hbg-validator B1~B6 독립 게이트 대상.
