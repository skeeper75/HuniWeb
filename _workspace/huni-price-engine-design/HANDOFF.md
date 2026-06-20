# Huni-Price-Engine-Design 하네스 — HANDOFF

> CLAUDE.md §18 · 갱신 2026-06-20 · 종단 GO 4건(디지털인쇄·아크릴·실사·현수막·문구)

## 다음 시작점

**책자(반제품 세트) 종단 또는 다음 동형 전파 또는 실 적재 승인** — 4개 종단(원자합산+고정가 / 면적매트릭스 / 면적+고정가+수량구간 / 고정가+수량구간할인+매트릭스) 검증 GO 완료.

- **★책자 종단(반제품 세트·우선 후보)**: §18 directive의 "반제품 세트상품" 각도를 처음 본격 다룸. 후니 세트 그릇 이미 보유(t_prd_product_sets 28행·page_rules 11행·COMP_BIND 11종)=배선-gap. benchmark가 분석해둔 set-pricing-patterns P-6 재사용. 결정 2건=DT-BIND-SCOPE(제본비 단일항 vs 표지+내지+제본 부품 합산)·제본비 COMP_BIND prc_typ(.01 min_qty 구간=.02 합가형 성격 의심·돈크리티컬).
- **남은 동형 전파 후보**: 굿즈/파우치·스티커·상품악세사리·캘린더 → 기존 동형 클래스 분류 후 cartographer→designer→validator→codex 순.
- **실 적재 승인 대기**: 디지털 prc_typ 교정(.01→.02)·아크릴 G-A1 바인딩·실사 후가공 배선·문구(본체 product_prices INSERT·떡메모 바인딩·DSC 링크 4건) — 전부 인간 승인 후 dbm-axis-staged-load/dbm-load-execution 위임.

## 진행 현황

| 상품군 | 계산방식 | 게이트 | codex |
|--------|----------|--------|-------|
| 디지털인쇄 | 원자합산형+고정가형 | NO-GO→보정→**재게이트 GO** | NO-GO 지지(medium) |
| 아크릴 | 면적매트릭스형 | **첫 게이트 GO**(보정 0) | GO 지지(**high**) |
| 실사·현수막 | 면적+고정가+수량구간(3방식) | **E1~E7 전건 PASS·GO**(차단0·LOW2) | GO 지지(**high**·divergence 0) |
| 문구 | 고정가+수량구간할인+매트릭스 | **E1~E7 전건 PASS·GO**(차단0·보정0·mint0) | GO 지지(**high**·divergence 0) |

## 미해결 / 블로커 (전부 DB 미적재·인간 승인 후 dbmap 위임)

**실사·현수막(GO·차단 아님):**
- Q-SB-PUNCH-DIM: 배너 후가공(PUNCH_4/6/8 등 use_dims=[]·NULL) 판별차원 충전+opt_cd 채번. **미충전 배선 절대 금지**(타공 4+6+8 silent 합산 20,000 과청구 실증). 라이브 부분 백필 3건(MESH_PUNCH_6·NORMAL_QBANG_4·MESH_PROC_OPT) 포함.
- Q-SB-PROC-QTY(돈크리티컬): 후가공/거치 1건당 vs ×수량 prc_typ 확정(거치대 ×qty=250,000 과청구 가능).
- Q-SB-CH1: CANVAS_HANGING 차원 정합(validator 라이브 900×900=8,000 확정·셀 표기 분리).
- G-S1: 후가공 배선 0건(PRF_POSTER disp_seq 2~) → 위 컨펌큐 해소 후 배선.

**문구(GO·차단 아님):**
- Q-ST-DSC-LINK(돈크리티컬): DSC_STAT_QTY 링크 누락 4건(PRD_000173/174/175 만년다이어리 하드/레더+097 떡메모) INSERT → 누락 시 +150,000 과청구 실증.
- Q-ST-MEMO1: 메모패드 2사이즈 2가격 = 사이즈 차원 공식 vs 별 prd_cd.
- Q-ST-DSC-DOUBLE: 떡메모 unit 내장 볼륨할인 위 DSC_STAT_QTY 추가 = 의도된 추가할인 vs 이중할인(dbm-price-arbiter 심의).
- 본체 9 product_prices INSERT·떡메모 PRD_000097 바인딩.

**디지털인쇄:** 박 동판 정액(차선A qty=1 격리 vs B 정액 prc_typ 신설)·인쇄면 통합 단가행 병합·G-7 옵션 자동주입.
**아크릴:** CA-1 미러 합류(mat_cd 판별차원 선결·돈크리티컬)·CA-4 후가공 개당/×수량·CA-3 카라비너 신설.
**공통:** webadmin pricing.py = read-only(엔진 코드 직접 수정 금지).

## 이번 세션 결정 (relitigate 금지)

- 실사·현수막 검증 재개 → Phase4(hpe-validator E1~E7 GO)·Phase5.5(codex high·divergence 0) 완료 → **GO 확정·메모리 박제**([[huni-price-engine-design-harness]]).
- codex 부가발견 DV-SB1(GC-S7 "280,000"/"350,000" 셀 표기 모순) → 350,000 통일 정정 완료(가격결론 무영향).
- CLAUDE.md §18 변경이력에 실사·현수막 GO 추가·"하네스 초기 구성" 행은 `CHANGELOG.md`로 이동(최근 3건 유지).
- effort high 유지(이전 세션 결정·effortLevel medium→high·codex-review.sh effort 인자).

## 건드리지 말 것 (confirmed-good)

- **단가행 값 전부 verbatim 보존**(전 상품군 공통·실 교정/배선은 인간 승인 후 dbmap 위임).
- 확정 GO 산출: 디지털 `04_validation/regate-verdict-digitalprint.md`·아크릴 `gate-verdict-acrylic.md`·실사 `gate-verdict-silsa-banner.md`·codex reconcile 3종.
- 실사·현수막 본체 라이브 상태(29 PRF·28상품 1:1 바인딩·동형결합 13→7 COMMIT 완료) — 이미 정합·건드리지 말 것.
