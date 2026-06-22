---
name: hwf-flow-curation
description: 후니 위젯 구조·플로우 문서화 하네스(Huni-Widget-Flow)의 역공학 증거 큐레이션 방법론. docs/reversing 역공학 자료와 raw/widget_monitor 캡처를 읽어 위젯 3계층 구조·공통 플로우·26 상품군별 "파일 업로드 vs 에디쿠스(Edicus) 경로 분기"를 근거(파일:라인)와 함께 플로우 팩으로 정리한다. 권위=역공학 자료·미상은 "모름"으로 명시(추정 금지)·읽기전용. 트리거: 플로우 큐레이션, 위젯 구조 추출, 경로 분기 증거, 상품군 경로 매핑, 에디쿠스 업로드 분기, 큐레이션 다시. 개발자 mermaid 집필은 hwf-mermaid-authoring, 비전문가 시각화는 hwf-flow-visualize, 검증은 hwf-flow-validation이 담당.
---

# hwf-flow-curation — 역공학 증거 큐레이션 방법론

## 목적
mermaid 집필가와 codex 시각화가가 공통으로 의존할 **단일 진실 소스(플로우 팩)** 를 역공학 자료에서 추출한다. 핵심 축은 "각 상품군이 파일 업로드와 에디쿠스를 어떻게 연결하는가".

## 권위 순서
1. `docs/reversing/red_reverse_engineer/final/역공학_최종_보고서.md`, `03_deobfuscated/`(editor_sdk_method_catalog.md·deob_06_app_widget_sdk.js·deob_05_app_api.js), `05_code_pattern_transfer_analysis.md`
2. `docs/reversing/*.html` (Widget/SDK 분석 리포트)
3. `raw/widget_monitor/`: SIMULATOR_GUIDE.md·monitor_report.md·cascade_captures/*.json·*_capture.json
4. `raw/widget_monitor/redprinting_catalog.json` (26 카테고리/479상품 목록)

권위 밖 추정·외부지식으로 빈칸을 메우지 않는다.

## 알려진 핵심 사실(출발점 — 반드시 원본 재확인)
- **3계층**: `productRedWidgetSDK.js`(브릿지·fetch 0) → `widget.js`(Vue3+Pinia, Shadow DOM, 스토어 config/product/order/exterior) → `RedEditorSDK.min.js`(Edicus, iframe).
- **공통 플로우**: initProductData → sdkInit → widget.js 마운트 → `get_digital_product_info` → 옵션 변경(order 스토어) → `get_ajax_price_vTmpl` 가격 → 콜백 → `sdkCreatePot` 주문.
- **분기**: `exterior.uploadType` ∈ {"editor","pdf"}; 상품 `item_gbn`(book2025_item=업로드+에디터 둘다, vDigital_item=에디터 전용)이 가용성 결정.
- **에디쿠스 라이프사이클**: init→ready-to-listen→doc-changed→project-id-created→save-doc-report:start/end→goto-cart/close (postMessage 양방향).
- **PDF 경로**: `/api/aws/presigned` → S3 PUT → 주문 시 s3FileUrl 제출.

## 절차
1. **구조 확정** — 3계층 모듈·스토어·CDN/서버 출처·Shadow DOM 경계를 근거와 함께 `widget-architecture.md`로.
2. **경로 분기 명세** — 업로드/에디쿠스 각 경로의 API 시퀀스·postMessage·분기 결정 요인을 `path-branch-spec.md`로.
3. **상품군 매핑** — `redprinting_catalog.json`의 26 카테고리를 순회하며 각 (가능하면 상품코드)별 item_gbn/price_gbn/업로드 가능/에디쿠스 가능/근거/신뢰도를 `product-path-matrix.csv`로. 캡처에 직접 증거가 있는 상품(PRBK*=책자, GSTGMIC=굿즈, ACNTHAP=아크릴 등)은 확인, 없는 것은 카테고리 단위 추론 가능성만 표기하고 신뢰도=추정/모름.
4. **미상 보드** — 근거 부재 전수를 `unknowns-board.md`로.

## 핵심 규칙
- **미상의 정직성[HARD]**: 못 찾은 것은 `모름(근거 없음)`. presigned 유효기간·uploadType 자동/수동 규칙·BNSTDFT/STDRCAD/LFXXXXX/PRLFXXX 정의 등은 현재 미상으로 알려져 있음 — 확인되면 갱신, 아니면 모름 유지.
- **모든 사실에 `파일:라인` 근거**.
- 신뢰도 3단계: 확인(직접 증거) / 추정(카테고리·패턴 추론) / 모름(근거 없음).

## 산출 위치
`_workspace/huni-widget-flow/01_curation/`
