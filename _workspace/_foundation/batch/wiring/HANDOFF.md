# 배선 연결 서브트랙 (formula_components) HANDOFF — 2026-07-01

§27 가격 종단 마스터의 **배선 연결 서브트랙** — "가격에 영향 주는 가격구성요소를 가격공식에 배선"하는 수렴 루프.
종료 척도[HARD·사용자]: **배선 결함 0 + PRICE≠0**. 명세까지(실 COMMIT 인간 승인). 상세 메모리=[[formula-components-wiring-subtrack-260701]].

## 현재 상태 (2026-07-01 round10 기준)
- **배선 결함 23 → 19 → 17** (round9 LEGIT_UNUSED 4 분리 + round10 완칼타공1H6/2H6 addon 판정 격리).
  스캐너가 `orphan-classification.json` LEGIT_UNUSED를 읽어 별도 카운트(결함 은닉 아님·no silent caps). legit_unused=6.
- 남은 **17 = 진짜고아 9 + dead 7(신상아크릴 *_TBD) + deleted 1(082 트윈링)**.
- **CONFIRM-QUEUE v2(7→5항목)** — 가격표(260527) 재확인으로 호스트 식별분 제외, 진짜 사장님 필요분만: 폼보드 7,000vs6,000·접지 이중과금·캘린더 공식부재·신상아크릴 미수록3종·포토카드 배타성.
- 남은 9 고아 라우팅: 미러3T(§18 거울류 공식신설·골든) · 캘린더1(CONFIRM) · 접지2(CONFIRM) · 엽서북30p 2(§6) · 포토카드대량(§18·배타성 CONFIRM) · 폼보드/포맥스2(§7+가격CONFIRM).

## ★가격표 재확인(R10) — CONFIRM 큐 대폭 축소 (사용자 지적)
v1 큐가 인쇄상품 가격표(260527)를 충분히 안 보고 "호스트 모름"을 남발. 가격표 재확인 결과 다수가 풀림:
- **완칼타공1·2구** → 커팅타공 41행 "헤더택/벽걸이캘린더"(합가 1구2,000·2구4,000) → §13 상품구조 분석
- **미러아크릴3T** → 아크릴 34행 "직접입력형 전면5도 통용단가"(면적) → §13 호스트 매핑
- **포토카드대량** → 명함포토카드 81행 "포토카드(대랑제작)"(호스트=포토카드) → §18
- **PET배너거치대** → 포스터사인 228행 "추가옵션(거치대) 추가가격" → addon 확증(미배선 정답)
- **폼보드/포맥스 A1** → 포스터사인 187-196 A1 전부 존재(§7 등록만)
- **신상아크릴 코롯토·지비츠** → 아크릴 72·89-96 단가 존재(§18 설계)
**진짜 사장님 필요분 = 5개로 축소** (CONFIRM-QUEUE v2): ①폼보드 7,000vs6,000(권위충돌) ②접지 이중과금 ③캘린더 가격방식 ④신상아크릴 미수록3종(입체블럭·쉐이커·포카코롯토) ⑤포토카드 세트/대량 배타성.
[HARD 교훈] CONFIRM 올리기 전 가격표 전 시트(특히 커팅타공·아크릴후가공·명함포토카드 = 횡단옵션/통용단가)를 먼저 봐라.

## 다음 시작점 (fresh 세션이 바로 할 일)
1. **★CONFIRM 큐 v2 사장님 전달** — `CONFIRM-QUEUE-260701.md`(v2·5항목)를 사장님께 전달.
2. **가격표 근거 자율 설계분 진행** (사장님 답 불요):
   - 완칼타공 → §13 호스트(헤더택/벽걸이캘린더) 상품구조 분석: 합가형=손님선택 addon인지(PET거치대 동형 미배선 정답) vs 완제품가 포함인지 판정
   - 미러아크릴3T → §13 미러소재 아크릴 prd 호스트 매핑(통용단가 참조처)
   - 코롯토·지비츠 → §18 면적/단가 설계
   - 폼보드/포맥스 → §7 product_sizes 315/317 + A1 등록(가격은 7,000vs6,000 CONFIRM 후)
3. **엽서북30p**(고아2) → ★라이브 재진단으로 재라우팅: 094=셋트(내지095)·page_rule 메커니즘. 기존 opt_cd 설계 **폐기(SUPERSEDED)**. 진짜 결함=셋트 내지 가격공식(§18/§23·포토북100 동형)+pansu(§26·fn_calc_pansu). 사장님 결정=셋트 운영 vs 단품 운영 분기. 상세 `diag-pcb30p-set-live-260701.md`.
4. **082 트윈링**(deleted1) → §23 셋트.
4. **재스캔** — `python3 wiring_scan.py --round N --note "..."`.

## 미해결 / 블로커
- 폼보드 가격 권위 충돌(7,000 vs 6,000)·A1 미적재 → 사장님 CONFIRM(돈크리티컬·날조 금지).
- 엽서북 위젯 계약(미선택→0) → §6.
- BLOCKED 7(R1 4 + 강등 3) → 사장님/goods.asp/§7.
- 교차신호: deleted_wire `PRF_HC_TWINRING_SET→COMP_BIND_HC_TWINRING`(§23 셋트 082 트윈링 산물·§23 라우팅).

## 이번 세션 결정 (relitigate 금지)
- **★LEGIT_UNUSED 4 분리** — 게이트(round8)가 "미배선이 정답"으로 판정한 comp(addon 별건·superseded)는 스캐너가 별도 카운트로 분리(결함 23→19). 종료척도(결함0)를 false-positive가 영구 차단하던 것 해소. 근거=`orphan-classification.json` LEGIT_UNUSED(결정론). 결함 은닉 아님(별도 명시).
- **배선 자율분 소진 확정** — 남은 19 전부 외부 의존(사장님16+§6 2+§23 1). 추측 배선=과대/저청구라 금지. CONFIRM 답/타 트랙 진행이 다음 게이트.
- **CONFIRM 큐 확정** — dead 7(신상아크릴 *_TBD) 추가·화이트명함 COMMIT분 "끝난 것"으로 이동·결함 추적 매핑표 부록.
- **배선 서브트랙 = §27 신설**(새 하네스 0·SOT 정합). 측도=`wiring_scan.py`(토큰0 결정론).
- **종료척도 = 배선 결함 0 + PRICE≠0**(명세까지·실 COMMIT 인간 승인 후 §7).
- **★엔진 매칭 = 행 판별컬럼 기반**(`_row_matches` NON_QTY_DIMS). use_dims는 UI/opt_grp 스코프 전용(엔진 매칭 미사용). 배선 정확성의 자 = 단가행 판별컬럼 충전.
- **★고아 적발 ≠ 단순 배선** — 판별 비수량차원 없는 단가행=와일드카드 always-match라 형제 옆 배선=과대청구. 대부분 §18 설계/상품구성/실무진(REAL_GAP 0).
- **화이트명함040 = 별색 모델**(코팅 아님·사장님 정정). PRF_DGP_A 원자합산 부적합(과대)→flat 완제품가 + 재바인딩.
- **폼보드/포맥스 = 자재축 모델**(가격표 확정·중복 siz_cd 아님).
- 도메인 교훈[HARD]: 상품마스터 옵션컬럼으로 축 먼저 확인·완제품 묶음가 vs 원자합산 구분·상품 현 공식 바인딩 먼저(신설 전 재바인딩 점검).

## 건드리지 말 것 (confirmed-good·보존)
- **박명함037 COMMIT** — 골든 3/3(38,200·55,000·24,200)·undo=`namecard037-undo.sql`.
- **화이트명함040 COMMIT** — 골든 4/4(14,500~19,000)·PRF_DGP_A 과대소멸·undo=`whitenamecard040-undo.sql`·백업 `_backup/whitenamecard040-*`.
- 하네스 파일: `wiring_scan.py`·`build_dashboard.py`(배선 보드 탭)·`orphan-classification.json`(round8)·§27 SKILL.md 배선 서브트랙.

## 산출물 인덱스 (batch/wiring/)
- 스캐너·진척: `wiring_scan.py`·`wiring-status.json`·`wiring-rounds.csv`·`orphan-classification.json`(분류+검증+COMMIT 상태)
- 분류·설계·검증: `orphan-classification-260701.md`·`design-*-260701.md`·`gate-*-260701.md`·`codex-*-260701.md`·`diag-whitenamecard-belsaek-260701.md`
- COMMIT: `namecard037-fix/undo.sql`·`whitenamecard040-fix/undo.sql`·`commit-report-*.md`·`_backup/`
- CONFIRM: `CONFIRM-QUEUE-260701.md`(사장님 쉬운말)
- 대시보드: `_workspace/huni-product-readiness/05_gate/dashboard/dashboard.html`(배선 진척 보드 탭)
