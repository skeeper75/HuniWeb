# 배선 연결 서브트랙 (formula_components) HANDOFF — 2026-07-01

§27 가격 종단 마스터의 **배선 연결 서브트랙** — "가격에 영향 주는 가격구성요소를 가격공식에 배선"하는 수렴 루프.
종료 척도[HARD·사용자]: **배선 결함 0 + PRICE≠0**. 명세까지(실 COMMIT 인간 승인). 상세 메모리=[[formula-components-wiring-subtrack-260701]].

## 현재 상태 (2026-07-01 round10 기준)
- **배선 결함 23 → 17** (round9 LEGIT_UNUSED 4 분리 + round10 완칼타공 2 addon 격리). legit_unused=6.
- 남은 **17 = 진짜고아 9 + dead 7(신상아크릴 *_TBD) + deleted 1(082 트윈링)**.
- 스캐너: `wiring_scan.py`가 `orphan-classification.json` LEGIT_UNUSED를 별도 카운트(결함 은닉 아님).

## ★남은 작업 체크리스트 (다음 세션 우선순위)

### A. 자율 진행 가능 (사장님 답 불요·가격표 근거)
1. **[최우선·준비완료] 엽서북30p 데이터 COMMIT** (고아 COMP_PCB_S1/S2_30P)
   - 상태: **단품 정합 설계 GO·셋트 해제 불요 확정**(이번 세션). 셋트 완제품 공식 PRF_PCB_FIXED가 `set_selections`로 통째 단가표 계산 입증(단면 22,000·양면 23,000 = 가격표 일치).
   - 할 일: `design-pcb30p-fix` 데이터만 — ① 30P 단가행 print_opt 충전(S1=POPT_000001·S2=POPT_000002) ② 20P/30P 단가행 page 판별 opt_cd 충전(20P/30P 구분) ③ 30P 2 comp 배선.
   - 검증: `simulate_set('PRD_000094', copies, members, set_selections={siz,print_opt,opt_cd(page)})`로 골든 6/6 재현 → §7 인간 승인 COMMIT.
   - ★남은 확인 1: 시뮬레이터/위젯이 페이지(20/30)를 `set_selections.opt_cd`로 넘기는지(사이즈·print_opt는 이미 넘어감=22,000 입증). 셋트 UI 경로 확인.
2. **미러아크릴3T** (고아 COMP_ACRYL_MIRROR3T): §18 — 투명3T(COMP_ACRYL_CLEAR3T→PRF_CLR_ACRYL) 동형 공식 PRF_MIRROR_ACRYL 신설 + 거울류(틴183·컴팩트184·카드185·사각손186·블랙187) 바인딩 + 골든(예전사이트). 아크릴34 통용단가.
3. **포토카드대량** (고아 COMP_PHOTOCARD_BULK): §18 — 호스트=포토카드(명함포토카드81). 단 세트/대량 배타성은 CONFIRM 큐 ⑤.
4. **코롯토·지비츠** (dead 중): §18 — 아크릴 89-96 코롯토 면적매트릭스·72 지비츠 200원.

### B. 사장님 CONFIRM 필요 (`CONFIRM-QUEUE-260701.md` v2·5항목)
- ① 폼보드 화이트A3 **7,000 vs 6,000**(권위충돌) → 후 §7 product_sizes 315/317 + A1 등록(고아 FOAMBOARD_BLACK·FOMEXBOARD_WHITE5MM)
- ② 접지카드 3단/6크리즈 이중과금(고아 FOLD_CARD_3H·6CR)
- ③ 캘린더 가격방식(고아 BIND_CAL_WALL·공식 부재)
- ④ 신상아크릴 미수록 3종: 입체블럭·쉐이커·포카코롯토(dead 중)
- ⑤ 포토카드 세트/대량 배타성

### C. 타 트랙 위임
- **082 트윈링**(deleted 1: PRF_HC_TWINRING_SET→COMP_BIND_HC_TWINRING) → §23 셋트.

### 재스캔
- `python3 wiring_scan.py --round N --note "..."` (라이브 무변동 시 17 유지).

## 미해결 / 블로커
- 폼보드 가격 권위 충돌(7,000 vs 6,000)·A1 → 사장님 CONFIRM(돈크리티컬).
- 캘린더 공식 부재·접지 이중과금·신상아크릴 미수록 3종·포토카드 배타성 → 사장님 CONFIRM.
- dead 7(신상아크릴 *_TBD)=실무진 단가. 단 코롯토/지비츠는 가격표 有(A4로 자율 설계 가능).

## 이번 세션 결정 (relitigate 금지)
- **★LEGIT_UNUSED 스캐너 분리** — 게이트가 "미배선이 정답"으로 판정한 comp(addon·superseded)를 별도 카운트(결함 은닉 아님). 완칼타공1H6/2H6=헤더택/벽걸이캘린더 옵션그룹0·합가 addon=PET거치대 동형→격리.
- **★[HARD] 가격표 먼저** — CONFIRM 올리기 전 인쇄상품 가격표(260527) 전 시트(커팅타공·아크릴후가공·명함포토카드=횡단옵션/통용단가) 확인. "호스트 모름" 다수가 가격표에 명시.
- **★[HARD] 엽서북 — 셋트 가격 오진단 정정 3회 끝 확정:** ① opt_cd 옵션그룹 설계(page_rule 충돌 오해→폐기했다 정정) ② "내지095 가격공식 부재가 근본결함"(오진단) ③ **최종: `evaluate_set_price`(L920)가 셋트 완제품 공식을 `set_selections`로 호출 → 통째 단가표 계산. 094 셋트 해제 불요·사장님 셋트vs단품 결정 불요·데이터만 COMMIT.** 0원은 set_selections 미전달(호출 오류)이지 데이터 결함 아님. → **배선 설계 전 라이브 sim_meta(is_set·page_rule)+evaluate_set_price 경로 먼저 확인.**
- **★엔진 매칭 = 행 판별컬럼 기반**(`_row_matches` NON_QTY_DIMS). use_dims는 UI/opt_grp 스코프 전용. 배선 정확성의 자 = 단가행 판별컬럼 충전.
- **★고아 적발 ≠ 단순 배선** — 판별 비수량차원 없는 단가행=와일드 always-match라 형제 옆 배선=과대청구. 대부분 §18 설계.
- **배선 서브트랙 = §27 신설**(새 하네스 0). 측도=`wiring_scan.py`(토큰0). 종료척도=배선 결함 0 + PRICE≠0.

## 건드리지 말 것 (confirmed-good·보존)
- **박명함037 COMMIT** — 골든 3/3(38,200·55,000·24,200)·undo=`namecard037-undo.sql`.
- **화이트명함040 COMMIT** — 골든 4/4(14,500~19,000)·undo=`whitenamecard040-undo.sql`·백업 `_backup/`.
- 이번 세션 산출: `diag-pcb30p-set-live-260701.md`(엽서북 라이브 재진단·전환방법 입증)·`design-pcb30p-fix`(단품정합 유효 재확정).
- 하네스 파일: `wiring_scan.py`(LEGIT_UNUSED 분리)·`orphan-classification.json`·`CONFIRM-QUEUE-260701.md` v2.

## 산출물 인덱스 (batch/wiring/)
- 스캐너·진척: `wiring_scan.py`·`wiring-status.json`·`wiring-rounds.csv`·`orphan-classification.json`
- 엽서북: `diag-pcb30p-set-live-260701.md`(라이브 재진단·셋트 완제품 공식 입증)·`design-pcb30p-fix-260701.md`(단품정합·유효)·`-dryrun.sql`
- 명함 COMMIT: `namecard037-fix/undo.sql`·`whitenamecard040-fix/undo.sql`·`commit-report-*.md`·`_backup/`
- CONFIRM: `CONFIRM-QUEUE-260701.md` v2(사장님 쉬운말 5항목)
- 대시보드: `_workspace/huni-product-readiness/05_gate/dashboard/dashboard.html`(배선 진척 보드 탭)
