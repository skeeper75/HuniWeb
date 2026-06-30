# Huni-Product-Readiness (§29) — HANDOFF (2026-06-30)

## 다음 시작점 (fresh 세션이 바로 할 것)
1. **대시보드 확인**: `_workspace/huni-product-readiness/05_gate/dashboard/dashboard.html`(1.3MB·standalone) 더블클릭 → 좌측 상품 클릭 시 구성요소 BOM·가격구성요소 BOM(항목별 예상vs실제)+Cytoscape 실항목 플로우. 재빌드=`python3 05_gate/dashboard/build_dashboard.py`(JSON만 갱신 시 레이아웃 보존).
2. **선택 후속(미착수)**: ① §26 결과를 §29 디지털 상품 price_bom에 "§26 셀단위 gap-0" 배지 반영(sparse 비율 오해 제거) ② 다른 의심 시트 §26 셀단위(명함·스티커·아크릴) ③ 돈크리티컬 교정(아래) 실행.

## 미해결 / 블로커 (실 교정은 전부 인간 승인 후 §7 dbmap·§18·§6·§23 위임)
- **★프리미엄명함(PRD_000031) 견적0 (돈크리티컬)**: 표준공식 PRF_NAMECARD_FIXED 오바인딩 — 완제품가 단가행은 표준 5종 용지만, 상품엔 프리미엄 16종만 적재 → 어느 용지 골라도 `match=0`(차원 미스매치)→견적0. 프리미엄 용지별 완제품가 단가행 적재 필요.
- **자재 price_gap 26항목/8상품**: 자재 적재됐으나 단가행 없음(봉투제작 레자크줄무늬·아크릴 부속 7=자석/핀/집게·명함 16). `02_readiness/list-bom-material-pricegap.csv`.
- **견적0 100상품** `list-bom-priced-zero.csv`: NEEDS_BASICS_FIRST 67(굿즈파우치 ~98 차원/자재 결손=최대 미적재 덩어리)·단가행/차원결손(공식바인딩됨) 10(썬캡051·아크릴*_TBD 8 실무진단가미정·프리미엄명함).
- **위젯 선행 불가 200상품**(L3 미만)·판형 재처리 0(종이류 plate_sizes 전부 존재로 재프레이밍).
- **골든 전수대조 미수행**: L3+ 83은 계산 성립(PRICE≠0)이나 예전사이트 정답가 일치는 미검증 → §26 pr_score/golden_fetch 후속.

## 이번 세션 결정 (relitigate 금지)
- §29 신설: 분모=이전사이트 상품리스트(283 실상품) / 위젯일정=등급별 묶음(W0~W6·C1~C3) / 기존 스코어링·§21·§26·§13 재사용(중복 채점 0) / 생성≠검증·codex 교차.
- 산출=인터랙티브 웹 대시보드(webadmin Django+Unfold **product_viewer UX 재사용** + **Cytoscape.js**·React Flow는 React빌드 필요 미채택) / **raw/webadmin 직접 수정 금지**(별도 드롭인 패키지 `/admin/readiness-viewer/`).
- ★항목 단위 BOM 보강(사용자 피드백 "차원요약 너무 러프"): 각 상품에 `component_bom`(자재·공정·사이즈·도수·옵션 항목별)+`price_bom`(공식→formula_components→price_components→단가행) 추가.
- 판형=종이류 출력소재에만 유효[HARD].
- ★[방법론 명확화] §29 `적재셀수/전역셀수`=**라이브 내부 coverage 비율**(전역셀수=그 comp의 라이브 전체 행수·권위 분모 아님). 판정=`glob=0 전무` / `match=0 차원미스매치` / `match>0 present`. **sparse 비율≠갭**. 권위 격자 셀 단위 완전성은 §26 트랙.

## §26 디지털인쇄비 셀단위 결과 (이번 세션 별도 실행 — GO)
- 「디지털인쇄비」 권위 954셀 ↔ 라이브 954셀 **gap-0 verbatim**(1도212·4도212·별색530 전건 일치·미적재0·불일치0·돈영향0·NO-OP).
- ★진단 스크립트 버그 교정: `grid_diff.py` side 코드맵이 신규 흑백코드 **POPT_000008(단면1도)/POPT_000009(양면1도)**를 몰라 212셀 스킵→"흑백 dim_missing" 가짜신호. 면(단/양면)을 note 1차 권위로 도출+코드맵 보강→954/954, 무회귀. digital-print-defects.csv RESOLVED.

## 건드리지 말 것 (검증된 산출)
- `00_spine`·`01_rubric`·`02_readiness`·`03_schedule`·`05_gate`(product-details-final.json enrich·dashboard) — 검증 완료 입력/산출.
- 신규 7 에이전트 hpr-*(+hpr-dashboard-builder)·7 스킬(로컬·gitignore)·CLAUDE.md §29(MoAI §30).
- `_batch/digital-print-griddiff*`·`scripts/digital_griddiff.py`·`scripts/grid_diff.py`(side 버그 교정·타 시트 무회귀).
- 앞서 완료된 §28 산출물(launch-scope·xlsx).
