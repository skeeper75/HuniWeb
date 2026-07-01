# 배선 연결 서브트랙 (formula_components) HANDOFF — 2026-07-01

§27 가격 종단 마스터의 **배선 연결 서브트랙** — "가격에 영향 주는 가격구성요소를 가격공식에 배선"하는 수렴 루프.
종료 척도[HARD·사용자]: **배선 결함 0 + PRICE≠0**. 명세까지(실 COMMIT 인간 승인). 상세 메모리=[[formula-components-wiring-subtrack-260701]].

## 현재 상태 (2026-07-01 round14 기준)
- **배선 결함 17 → 13** (엽서북30p COMMIT 고아2 17→15 + 미러3T LEGIT_UNUSED 재분류 15→14 + 지비츠156 COMMIT·placeholder정리 dead1 14→13). legit_unused=7.
- 남은 **13 = 진짜고아 6 + dead 6(신상아크릴 *_TBD) + deleted 1(082 트윈링)**.
- 스캐너: `wiring_scan.py`가 `orphan-classification.json` LEGIT_UNUSED를 별도 카운트(결함 은닉 아님).

## ★다음 시작점 (fresh 세션 여기부터)
자율 진행 가능 배선 결함은 **전부 소진**. 남은 13은 모두 사장님 CONFIRM·무권위·타트랙 의존.
1. **먼저 재스캔으로 현재값 확인**: `cd _workspace/_foundation/batch && bash ../live-snapshot/snapshot.sh && python3 wiring_scan.py --round N --note "..."` (기대 13·라이브 무변동 시).
2. **사장님 CONFIRM 촉진** = 남은 고아 6 해소의 유일 경로 → `CONFIRM-QUEUE-260701.md` v2 5항목을 사장님 쉬운말로 정리·질의(AskUserQuestion). CONFIRM 받으면 해당 항목 §18/§7 설계·COMMIT.
3. CONFIRM 없이 가능한 잔여 자율분 = **없음**(엽서북·미러·지비츠·코롯토 이번 세션 완결). dead 6은 무권위(실무진 단가), 082는 §23.
4. ★[HARD·신규 directive] **라이브 COMMIT 전 webadmin 실화면 확인 필수** (별도 §26 세션이 CLAUDE.md §1에 추가·SOT=`HARNESS-DOMAIN-RULES-260701.md`). 가격시뮬레이터 실화면 or `price_simulate(_set)` 뷰 실호출로 PRICE≠0·골든 확인 후 COMMIT.

### 이번 세션(round11~14) 처리분
- **★엽서북30p PRD_000094 라이브 COMMIT 완료** — 30P 고아 2 comp 배선+opt_cd 페이지판별(OPT_000082·OPV_491/492)·골든6/6 PASS(30p 저청구 해소·20p 회귀0). 백엔드 3계층 검증(pricing.py:920·price_views.py:1921·1333-1368). undo=`pcb30p-undo.sql`·리포트=`commit-report-pcb30p-260701.md`.
- **미러아크릴3T LEGIT_UNUSED 재분류** — COMP_ACRYL_MIRROR3T 소비 상품 0건(순수 고아·통용단가 대기). 강제 배선시 오적재(§18 실측). 라이브 무변동.
- **코롯토(164)=이미 배선완료** 확인(재-mint 방지) — 활성화만 §7.
- **★지비츠(156)=신규출시 상품 §18 재설계 COMMIT 완료** — 가공(투명200/스핀600) opt_cd 모델 + DSC_ACR_QTY 재사용·골든8/8 PASS·use_yn=N 유지(손님 미노출·런칭 시 §7 활성화). 고아 placeholder(ZIBITZ_TBD) 정리로 dead 탈출. 리포트=`commit-report-jibbitz156-260701.md`·undo=`jibbitz156-undo.sql`. 권위정정(규격5+비규격·사이즈 무관)=`jibbitz-authority-correction-260701.md`.
- **186/187 거울 굿즈 고정가**=READY(설계 有·`design-mirror-acryl3t-260701.md`)·COMMIT 보류(사장님 CONFIRM). 183~185=§7 사이즈 등록 BLOCKED.

## ★남은 13 결함 (전부 사장님/타트랙 의존)

### A. 사장님 CONFIRM 필요 = 고아 6 (`CONFIRM-QUEUE-260701.md` v2)
- ① 폼보드 블랙·화이트5mm **7,000 vs 6,000**(권위충돌) → 후 §7 product_sizes 315/317 + A1 등록(고아 COMP_POSTER_FOAMBOARD_BLACK·FOMEXBOARD_WHITE5MM)
- ② 접지카드 3단/6크리즈 이중과금(고아 COMP_FOLD_CARD_3H·6CR)
- ③ 벽걸이캘린더 가격방식(고아 COMP_BIND_CAL_WALL·공식 부재)
- ⑤ 포토카드대량 세트/대량 배타성(고아 COMP_PHOTOCARD_BULK·호스트=명함포토카드81)

### B. 무권위 = dead 6 (실무진 단가 CONFIRM ④)
- 신상아크릴 무권위 *_TBD 6종: 지비츠★(171)·입체블럭·입체코롯토·포카코롯토·쉐이커·쉐이커코롯토. 공유 placeholder COMP_ACRYL_PENDING_TBD(단가/구성 확인필요). 가격표 미수록 → 실무진 단가 확보 전 BLOCKED(placeholder 정당).

### C. 타 트랙 위임 = deleted 1
- **082 트윈링**(PRF_HC_TWINRING_SET→COMP_BIND_HC_TWINRING 논리삭제 참조) → §23 셋트.

### 재스캔
- `python3 wiring_scan.py --round N --note "..."` (라이브 무변동 시 13 유지).

## 미해결 / 블로커
- 남은 13 전부 사장님 CONFIRM(고아 6)·무권위 실무진 단가(dead 6)·§23(082 1)에 막힘. **자율 진행 가능분 0.**
- 폼보드 권위충돌(7,000 vs 6,000·돈크리티컬)·캘린더 공식 부재·접지 이중과금·포토카드 배타성·신상아크릴 무권위 → 사장님 CONFIRM.
- 186/187 거울 굿즈 고정가 설계 READY이나 COMMIT은 CONFIRM 대기(신규 굿즈 상품화 여부). 183~185=§7 사이즈 등록 BLOCKED.

## 이번 세션 결정 (relitigate 금지)
- **★엽서북30p 셋트 opt_cd 페이지판별 = 라이브 실증 완료**(코드+실화면). `evaluate_set_price`(pricing.py:920)가 셋트 완제품 공식을 `set_selections`로 호출 → `_row_matches`가 opt_cd 매칭. price_views.py:1921 set_selections 키 화이트리스트 없이 통과. sim_meta(1333-1368)가 formula use_dims `opt_grp:OPT_000082` 스코프 수집→셋트 UI에 페이지 드롭다운(20P/30P) 노출. price_simulate_set 실호출=30P부수2 23,000·부수4 39,600·20P 22,000(회귀0). [[formula-components-wiring-subtrack-260701]] 갱신.
- **★지비츠156=신규출시(단종 아님)·가공=opt_cd 옵션 모델**(공정코드 아님·이전 "공정 부재" 판정은 축 오해). 동형선례 COMP_ACRYL_BADGE/CLIP/KEYRING/MAGNET(`["opt_cd","min_qty","opt_grp:*"]`). 수량할인=`DSC_ACR_QTY` 재사용(권위 B04 일치·아크릴12상품 선례). 사이즈(규격5+비규격)는 가격 무관. 골든8/8·실화면(투명100=16,000·스핀100=48,000).
- **★미러아크릴3T = LEGIT_UNUSED**(강제배선하면 오적재). COMP_ACRYL_MIRROR3T=직접입력 면적격자인데 소비상품 0(순수고아). 거울류186/187은 별개 굿즈 고정가(면적격자 아님·강제배선시 ERR_ABOVE_MAX). 직접입력 미러아크릴 상품 생성 시 활성=CONFIRM.
- **★[HARD·신규 directive] 라이브 COMMIT 전 webadmin 실화면 확인 필수** — 별도 §26 세션이 CLAUDE.md §1 추가. DB dry-run만으로 COMMIT 금지. SOT=`_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙).
- **★LEGIT_UNUSED 스캐너 분리** — 게이트가 "미배선이 정답"으로 판정한 comp(addon·superseded·순수고아)를 별도 카운트(결함 은닉 아님).
- **★[HARD] 가격표 먼저·엔진 매칭=행 판별컬럼(`_row_matches` NON_QTY_DIMS)·고아 적발≠단순배선**(판별 없는 단가행=와일드 always-match→형제 배선=과대청구·대부분 §18 설계).
- **★[HARD] 가격표 먼저** — CONFIRM 올리기 전 인쇄상품 가격표(260527) 전 시트(커팅타공·아크릴후가공·명함포토카드=횡단옵션/통용단가) 확인. "호스트 모름" 다수가 가격표에 명시.
- **배선 서브트랙 = §27 신설**(새 하네스 0). 측도=`wiring_scan.py`(토큰0). 종료척도=배선 결함 0 + PRICE≠0.

## 건드리지 말 것 (confirmed-good·보존·undo 있으나 되돌리지 말 것)
- **엽서북30p PRD_000094 COMMIT** — 30P 배선+OPT_000082 페이지그룹·골든6/6·실화면 23,000/39,600/22,000. undo=`pcb30p-undo.sql`·backup=`pcb30p-usedims-backup-260701.tsv`.
- **지비츠156 PRD_000156 COMMIT** — 가공 opt_cd(OPT_000083)+DSC_ACR_QTY·골든8/8·실화면 16,000/48,000·use_yn=N 유지. undo=`jibbitz156-undo.sql`·`jibbitz-tbd-cleanup-undo.sql`·backup=`jibbitz156-backup-260701.tsv`.
- **박명함037 COMMIT** — 골든 3/3·undo=`namecard037-undo.sql`. **화이트명함040 COMMIT** — 골든 4/4·undo=`whitenamecard040-undo.sql`.
- 하네스 파일: `wiring_scan.py`(LEGIT_UNUSED 분리)·`orphan-classification.json`·`CONFIRM-QUEUE-260701.md` v2.

## 산출물 인덱스 (batch/wiring/)
- 스캐너·진척: `wiring_scan.py`·`wiring-status.json`·`wiring-rounds.csv`·`orphan-classification.json`
- 엽서북: `diag-pcb30p-set-live-260701.md`·`design-pcb30p-fix-260701.md`·`pcb30p-fix.sql`·`pcb30p-undo.sql`·`commit-report-pcb30p-260701.md`
- 지비츠: `design-jibbitz-full-260701.md`·`jibbitz-authority-correction-260701.md`·`jibbitz156-fix.sql`·`jibbitz156-undo.sql`·`jibbitz-tbd-cleanup-fix/undo.sql`·`commit-report-jibbitz156-260701.md`
- 미러/코롯토: `design-mirror-acryl3t-260701.md`(186/187 READY·COMMIT 보류)·`design-corotto-jibbitz-260701.md`(코롯토 기배선 확인)
- CONFIRM: `CONFIRM-QUEUE-260701.md` v2(사장님 쉬운말 5항목)
- 대시보드: `_workspace/huni-product-readiness/05_gate/dashboard/dashboard.html`(배선 진척 보드 탭)
- ★도메인 규칙 SOT(신규·별도 §26 세션): `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙·라이브 COMMIT 전 실화면 필수 포함)
