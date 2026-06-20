# Huni-Price-Engine-Design 하네스 — HANDOFF

> CLAUDE.md §18 · 갱신 2026-06-20 · 디지털인쇄 파일럿 **GO 종결**

## 다음 시작점

디지털인쇄 파일럿이 재게이트 **GO(전건 PASS)**로 닫혔다. **DB 미적재** 상태. 다음 둘 중 인간 승인 필요:

1. **실 prc_typ 교정 적재** (돈크리티컬·라이브 COMMIT) — 전 고정가형(명함 25 + 엽서북 4 + 포토카드 3 + 박 FOIL) `prc_typ` `.01→.02`(단가형→합가형) UPDATE. **단가행 값 불변(verbatim)**·멱등·백업·DRY-RUN. → `dbm-axis-staged-load` / `dbm-load-execution` 위임. 권위 근거 = `03_design/pricetype-remediation-arbitration.md` §9·§10.
2. **다음 상품군 동형 전파** — 디지털인쇄 GO 설계를 토대로 아크릴·실사·굿즈 등 타 시트로 파일럿 확장(frm_cd 기준 동형 클래스).

## 미해결 / 블로커

- **박 동판비(SETUP) 정액 처리법 미확정** — 가격표 `기본가(아연판)` 별행 5000 = 정액 1회 확정(CV-4). 단 현 엔진에 정액 그릇 부재(`min_qty=NULL`→합가형 전환 시 ValueError). **차선A**(selections에서 동판 qty=1 격리·엔진 무변경·권장) vs **차선B**(정액 prc_typ 신설·개발자 백로그) — 개발자 협의 필요.
- **인쇄면/페이지/소재 comp 통합(CV-3) 단가행 병합 적재** — comp 1개 + `print_opt_cd`/page를 use_dims 판별차원으로. 단가행 병합 적재는 미실행(설계 명세까지). `hpe-engine-designer` 폐루프 잔여.
- **G-7 옵션→차원 자동주입 미연결** — `option_items` 0행이라 옵션 선택이 차원으로 자동 주입 안 됨. CPQ 레이어 트랙(dbm-cpq-option-mapping) 연계 필요.
- **designer carry-forward 큐** — 형압명함 comp·G-6b 봉투류 경계·엽서북 30P orphan 바인딩.
- **webadmin pricing.py = read-only** — 엔진 코드 직접 수정 금지(개발자 GitHub 배포). 정액 prc_typ 신설 등은 개발자 백로그.

## 이번 세션 결정 (relitigate 금지)

- **세션 끊긴 지점 = Phase 5.5 codex 교차검증**(프롬프트만 작성됨)에서 재개 → 완주.
- **Phase 5.5 codex**: NO-GO 강하게 지지·핵심 3결함 전건 합의·divergence(충돌) 0. ②인쇄면 silent 이중합산은 codex가 우리 판정 모른 채 독립 도출(echo 불가·최고신뢰).
- **결함 진원[HARD]** = 전 고정가형 ×qty 과대청구는 **라이브 prc_typ 단가형 오적재**이지 설계 골든값 오류 아님. 단가행 값(3500·11000·9500·24800)은 가격표 verbatim으로 **옳음**.
- **CV-1 = 합가형(.02) 권위 확정** — 가격표 260527 명함 행축 라벨 `소재 / 제작수량`(100). 셀 3500 = 100매 묶음총액. 단가형이면 행축이 "제작수량 100"일 수 없음(반증 불가). 전 고정가형 시트 동일 구조.
- **CV-2** 명함 UX = 수량 브래킷 택1. **CV-3** 인쇄면/페이지/소재 통합(comp 1개·use_dims). **CV-4** 박 동판 정액 1회(가격표 별행 5000).
- **D-2 정정** — codex "매칭=use_dims 기준" 사유는 **거짓**(pricing.py는 `NON_QTY_DIMS` 고정상수 순회). 단 use_dims 등재는 여전히 필요(오경고 방지·옵션 주입 레이어). designer가 라이브 소스로 반증한 게 정확(맹종 0).
- **교정안 A**(.01→.02·÷min_qty·값불변)는 신규 패턴 아님 — round-23 스티커 `COMP_STK_PACK`/`TATTOO` 동형 선례 답습.

## 건드리지 말 것 (confirmed-good)

- **단가행 값 전부 verbatim 보존** — 교정은 prc_typ 플래그만 전환·값 0줄 변경.
- 재게이트 GO 산출 `04_validation/regate-verdict-digitalprint.md`(골든 8/8 재현·E-권위 confirm).
- codex reconcile `05_codex/codex-reconcile-digitalprint.md`(독립 합의 기록).
- 권위 확정 `03_design/pricetype-remediation-arbitration.md` §9(가격표 인용 verbatim).
