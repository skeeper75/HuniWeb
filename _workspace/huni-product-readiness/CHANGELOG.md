# Huni-Product-Readiness (§29) CHANGELOG

## 2026-06-30 하네스 초기 구성 + 첫 종단 실행 GO(보정) + 웹 대시보드
- **구성**: 7 에이전트(hpr-catalog-spine∥hpr-rubric-curator → hpr-readiness-evaluator → hpr-widget-scheduler → hpr-codex-verifier → hpr-scorecard-gate → hpr-dashboard-builder) + 7 스킬(방법론6 + 오케스트레이터, codex는 hqv-codex-cross-verify 재사용). 하이브리드·전 에이전트 opus. CLAUDE.md §29 등록(MoAI→§30).
- **사용자 결정**: 분모=이전사이트 상품리스트 / 위젯 일정=등급별 묶음 / 새 하네스(기존 스코어링·§21·§26·§13 재사용·중복 채점 0) / 산출=인터랙티브 웹 대시보드(webadmin product_viewer UX 재사용 + Cytoscape.js·React Flow 미채택=React 빌드 필요) / raw/webadmin 직접 수정 금지(드롭인 패키지) / 판형은 종이류에만 [HARD].
- **첫 실행 결과**:
  - 척추 분모 = 이전사이트 285행 → 실상품 **283 전수 평가**(라이브276+미등록7). 종이류 110·비종이 173. 매칭: 완전240·라이브only36·엑셀only9.
  - 루브릭 D1~D11(가중·D5 키스톤16)·완성률 산정식·등급 L0~L4·위젯 5클래스. 재사용 ~97%(SCORING-FRAMEWORK·scoreboard·§21 checklist·§13)·라이브 직접 ~3%.
  - **등급 분포**: L0 7·L1 109+기성20·L2반제품30·L2/L2+ 3/31·L3 69·L4 14. **평균 완성률 63.5%·L3+(계산가능) 83(보정 후)·계산성립 88(31%)**.
  - 위젯 일정 W0~W6 + 제약 C1~C3. 착수가능 83→**보정 80**(위젯 누수 3건 widget_eligible=N). 선행 불가 200·판형 선결.
  - **codex(gpt-5.5 high)**: 합의6·조사5·반박1·FP2. ★"L3+ 83 전수 D5 과대평가" 가설 → 게이트가 라이브 SQL(체인 83/83 완전)+시뮬레이터 표본(13/13 PRICE>0)로 **반증**. 아크릴/문구 LIVE_UNBOUND 플래그=STALE 입증.
  - **Q1~Q7 GO(보정)**: ★판형 재처리 **0건**(종이류 plate_sizes 전부 존재 → "공식 미바인딩 검증보류"로 재프레이밍). 위젯 누수 3건(020/042/047 드롭다운 오염+다중 dflt)=widget_eligible=N. silent-merge=COMP_PAPER use_dims 손님선택이라 자동합산 아님으로 메커니즘 정정.
  - **웹 대시보드**: standalone `dashboard.html`(283상품·차원 D1~D11 예상vs실제·Cytoscape 플로우 노드11/엣지15·등급색·필터) + webadmin 드롭인 Django 패키지(`/admin/readiness-viewer/` 읽기전용·product_viewer 본떠) + 통합 README + build_dashboard.py. raw/webadmin 미수정·비밀값 CLEAN.
- **산출 루트**: `_workspace/huni-product-readiness/` (00_spine~05_gate, 최종 대시보드=`05_gate/dashboard/`).
- **미해소 리스크**: ①골든 전수대조 미수행(L3+ 83 계산은 됨/정답일치 미검증·후속 §26 pr_score) ②자재오염 3건 정리(§17→§7) ③PRICED-0 6건 교정 ④굿즈파우치 ~104개 가격공식 통째 부재(최대 미적재 덩어리). 실 교정/COMMIT은 인간 승인 후 §7/§18/§6/§23 위임.
