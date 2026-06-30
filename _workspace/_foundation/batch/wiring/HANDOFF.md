# 배선 연결 서브트랙 (formula_components) HANDOFF — 2026-07-01

§27 가격 종단 마스터의 **배선 연결 서브트랙** — "가격에 영향 주는 가격구성요소를 가격공식에 배선"하는 수렴 루프.
종료 척도[HARD·사용자]: **배선 결함 0 + PRICE≠0**. 명세까지(실 COMMIT 인간 승인). 상세 메모리=[[formula-components-wiring-subtrack-260701]].

## 다음 시작점 (fresh 세션이 바로 할 일)
1. **CONFIRM 큐 해소** — `CONFIRM-QUEUE-260701.md`(쉬운말)를 사장님께 전달해 답 받기. 답 오면 막힌 것들이 풀림:
   - 화이트명함: 클리어 기본값(이미 "없음" 확정·COMMIT됨)·용지 색무관(와일드로 해소)·qty≠100 tier(§26)
   - 폼보드/포맥스: ★**화이트보드 A3 가격 7,000 vs 6,000**·A1 판매 여부 → 정해지면 자재축 모델 설계→COMMIT
   - 접지/캘린더/포토카드/완칼/미러: 호스트·구성 확인
2. **폼보드/포맥스 자재축 모델** — 가격표(260527) 확정 구조 = **소재(화이트보드/블랙보드·3mm/5mm) 옵션 × 사이즈(A3/A2/A1)**. 라이브 중복 siz_cd(315/317) 인코딩이 틀림. 가격 CONFIRM 후 자재-opt 모델 설계(BLACK/5MM comp를 siz_cd 중복 대신 소재 opt_cd×real siz로 재키)→검증→COMMIT.
3. **엽서북30p** — 데이터 설계 GO·COMMIT 보류=위젯이 "페이지 필수선택+opt_cd 전송" 강제(§6) 또는 C트랙(webadmin sim-meta dflt_yn 전파). §6 위젯 트랙에서 해소.
4. **남은 고아 15** — `wiring_scan.py` 재스캔으로 추적. BLOCKED 5(접지2·캘린더1·포토카드/완칼/미러 R1 4)는 사장님/§7 의존.

## 미해결 / 블로커
- 폼보드 가격 권위 충돌(7,000 vs 6,000)·A1 미적재 → 사장님 CONFIRM(돈크리티컬·날조 금지).
- 엽서북 위젯 계약(미선택→0) → §6.
- BLOCKED 7(R1 4 + 강등 3) → 사장님/goods.asp/§7.
- 교차신호: deleted_wire `PRF_HC_TWINRING_SET→COMP_BIND_HC_TWINRING`(§23 셋트 082 트윈링 산물·§23 라우팅).

## 이번 세션 결정 (relitigate 금지)
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
