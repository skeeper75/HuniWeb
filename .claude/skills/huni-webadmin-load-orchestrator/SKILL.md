---
name: huni-webadmin-load-orchestrator
description: 후니프린팅 상품 가격을 라이브DB 직접 적재 없이 오직 webadmin UI로 등록·교정해 가격시뮬레이터에서 예측 기대값=실제 가격·제외0을 달성하는 하네스 오케스트레이터. 잘못된 차원 매핑(박=소재차원 등) 전수 적발·교정, 전 메뉴 적재 경로 누락 0. 트리거: webadmin UI 적재, UI로 등록, 가격시뮬레이터 완성, 잘못된 차원 매핑 교정, 예측 실제 대조, 상품 UI 적재, 프리미엄명함 적재, webadmin 적재 하네스 실행/재실행/보완. 단순 질문은 직접 응답.
---

# Huni-Webadmin-Load 오케스트레이터

후니 상품 하나가 **가격시뮬레이터에서 정확한 가격**이 나오게, **오직 webadmin UI**로 적재/교정하는 하네스.

## [HARD] 대원칙
- **라이브 DB 직접 적재/psql 쓰기 절대 금지.** 모든 등록·교정=webadmin UI(https://huni-admin.printly.co.kr/admin/) · gstack browse.
- **착수 전 preflight 필수**(SOT+원본 엑셀 셀·실무진 코멘트+pricing.py 격자식). 추측·재질문 금지.
- **전 메뉴 누락 0**: 상품 8섹션(사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰) + 가격공식/구성요소
  (단가표 차원편집) + 할인테이블 + 옵션그룹/옵션/아이템 + 제약 + 마스터. 경로=`WEBADMIN-LOAD-PATH-MAP.md`.
- **종료척도**: 시뮬레이터 제외0 · 가격≠0 · **예측 기대값(권위 셀)=실제 가격**.

## 실행 모드 = 에이전트 팀 (생성-검증 분리)
팀: hwl-preflight(선독 관문) → hwl-cartographer(경로) ∥ hwl-mapping-auditor(차원 오매핑 진단) →
인간 승인 → hwl-ui-loader(UI 실적재) → hwl-sim-verifier(예측vs실제) → 불일치 시 auditor 루프.
모든 Agent 호출 `model: "opus"`.

## Phase
- **P0 컨텍스트**: `_workspace/huni-webadmin-load/` 존재 확인(초기/후속/부분). preflight 실행.
- **P1 경로·현황**: cartographer가 경로맵 최신화 + 대상 상품 8섹션·가격배선 현황 실측(읽기전용).
- **P2 진단**: mapping-auditor가 잘못된 차원 매핑·누락을 전수 적발(예측vs실제 불일치 역추적) → 교정명세.
- **P3 승인·적재**: 인간 승인 후 ui-loader가 webadmin UI로 교정 적재(스크린샷 증거).
- **P4 검증**: sim-verifier가 시뮬레이터 예측=실제·제외0 확인. 미달 시 P2로.
- **파일럿**: 프리미엄명함(PRD_000031) 먼저 종단 완주 → 동형 전파.

## 데이터 전달
파일 기반(`_workspace/huni-webadmin-load/`: PATH-MAP·MAPPING-DEFECTS·LOAD-LOG·VERIFY-*) + 태스크(조율).

## 테스트 시나리오
- 정상: 프리미엄명함 preflight→진단→UI적재→시뮬레이터 예측=실제·제외0.
- 에러: 시뮬레이터 실제≠예측 → auditor가 차원/누락 원인 역추적 → 재적재.

상세: `_workspace/huni-webadmin-load/HANDOFF.md`·`WEBADMIN-LOAD-PATH-MAP.md`.
