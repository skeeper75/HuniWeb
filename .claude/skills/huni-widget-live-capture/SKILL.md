---
name: huni-widget-live-capture
description: >
  RedPrinting 위젯을 raw/widget_monitor/local 라이브 테스트베드로 구동하여 동작·데이터를 캡처/검증하는 스킬.
  localhost:3001 위젯을 Shadow DOM 마운트한 채 옵션 변경·가격 API 응답·Edicus postMessage·S3 업로드 플로우를 실시간 수집한다. RedPrinting은 프로젝트 소유자 본인 설계 시스템.
  '위젯 라이브 캡처', 'widget_monitor 구동', '레드프린팅 위젯 동작 캡처', '가격 API 캡처', 'Edicus 통신 캡처', 'Shadow DOM 상태 추출', '역공학 라이브 검증' 요청 시 반드시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Bash, Grep, Glob, mcp__claude-in-chrome__*
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-02"
  tags: "huni, widget, redprinting, shadow-dom, edicus, live-capture, playwright"
---

# Huni Widget — Live Capture Skill

## 목적

`raw/widget_monitor/local` 은 RedPrinting 위젯을 로컬에서 라이브로 띄우는 **동작 검증된 테스트베드**다(Shadow DOM 위젯 마운트 + Edicus 라이브 연동 + from-edicus postMessage 데이터 처리). 이 스킬은 그 테스트베드를 구동하여 후니 위젯 설계에 필요한 실데이터(옵션 스키마·가격 응답·이벤트 흐름·에디터 프로토콜)를 근거로 수집한다.

추측 대신 라이브 캡처를 근거로 삼는 것이 핵심 이유다 — 위젯 동작은 정적 코드만으로 완전히 파악되지 않으며, 실제 네트워크/스토어 스냅샷이 진실의 단일 출처다.

## 자격증명

`.env.local` 에 통합 자격증명 보유. RedPrinting 관련:
- `RP_USERNAME` / `RP_PASSWORD` (= `REDPRINTING_SITE_ID`/`PW`)
- 에디터 토큰은 `raw/widget_monitor/local/.env` 의 `RP_EDITOR_TOKEN` (55분 만료, 자동 갱신)
- 세션 쿠키는 `cookies.json` (만료 시 `node extract-cookies.cjs` 로 갱신)

RedPrinting은 프로젝트 소유자가 직접 설계·구축한 시스템이므로 분석·접속에 권한 부담이 없다. 다만 불필요한 부하는 피한다(아래 안전 모드).

## 안전 모드 (HARD)

| # | 규칙 | 사유 |
|---|------|------|
| 1 | 주문·결제·계정변경 API 호출 금지 | 읽기/견적 조회만. 부작용 방지 |
| 2 | 옵션 순회 캡처 시 요청 간 간격 부여(throttle) | 서버 부하 회피 |
| 3 | 이미 캡처된 데이터 우선 재사용 | 중복 라이브 호출 최소화 |
| 4 | 캡처 산출물은 `_workspace/huni-widget/` 하위에 저장 | 원본 widget_monitor 오염 방지 |
| 5 | 토큰·쿠키·비밀번호를 산출물/로그에 평문 기록 금지 | 자격증명 보호 |

## 워크플로우

### Step 1 — 테스트베드 기동

```bash
cd raw/widget_monitor/local
# 의존성 확인 (최초 1회)
[ -d node_modules ] || npm install
# 토큰 상태 점검 후 서버 기동 (백그라운드 권장)
node server.js
```

기동 확인: `http://localhost:3001` → `/rp-api/* /widget-api/* /makers-api/*` 프록시 로그 출력. 토큰 만료 시 `node extract-cookies.cjs` 또는 `POST /refresh-token`.

### Step 2 — 위젯 라이브 구동 + Shadow DOM 상태 추출

`http://localhost:3001?pdt={상품코드}` 접속(예: `GSTGMIC`, `PRBKORD`). Playwright/claude-in-chrome으로:

- `document.getElementById('redWidgetSdk').shadowRoot` 에서 위젯 마운트 확인
- Shadow DOM 내 Pinia 스토어 스냅샷 추출 (config/product/order/exterior/acc-order)
- 옵션 변경 → 스토어 변화 + 네트워크 호출 관찰

참고 구현: `local/e2e-editor-test.cjs` (Shadow DOM 스캔·에디터 흐름 E2E 패턴 그대로 활용)

### Step 3 — 캡처 대상별 수집

| 대상 | 수집 방법 | 산출 |
|------|----------|------|
| 옵션 스키마 | `GET /rp-api/ko/product/get_digital_product_info` 응답 | `option-schema-catalog.json` |
| 가격 규칙 | 옵션 조합 변경 → `POST .../get_ajax_price_vTmpl` 응답 (`body-log.json` 전체 보존됨) | 가격 조합 샘플 매트릭스 |
| 캐스케이드 제약 | `cascade-capture.cjs` 패턴 + `pdt_disable_pcs_info` | `cascade-rules` 입력 |
| Edicus 프로토콜 | 에디터 열기 → `window` `message` `from-edicus` 이벤트 (index.html:329 패턴) | postMessage 페이로드 로그 |
| S3 업로드 | 파일 업로드 플로우 → presigned 발급 요청/응답 | `s3-upload-flow` 근거 |

### Step 4 — 근거 표기하여 저장

수집 데이터는 `_workspace/huni-widget/01_reverse/` 또는 `02_analysis/` 에 저장하며, 각 항목에 `[라이브 검증]` 표기. 캡처 불가 항목은 미검증으로 명시(은폐 금지).

## 정적 분석 레퍼런스 (라이브 캡처 대조용)

라이브 캡처 전, `docs/reversing/RedPrinting_Widget_Analysis_Report.html` + `RedPrinting_SDK_Deep_Analysis_Report.html` 와 `_workspace/huni-widget/01_reverse/seed-redprinting-sdk-analysis.md` 를 기준선으로 삼는다. 이 리포트가 가격 API 실측 계약(ORD_INFO/PCS_INFO)·핵심 4 엔드포인트(`/ko/product/get_digital_product_info`, `/ko/product_price/get_ajax_price_vTmpl`, `/api/aws/presigned`, `/api/editor/config/`)·브릿지 17함수를 이미 문서화했으므로, 라이브 캡처는 이 기준과 실응답을 **대조**하여 검증·보강한다.

## 상품 코드 레퍼런스

`raw/widget_monitor/redprinting_catalog.json` (479개). 신규 위젯(Vue3) ~25개: 책자 윤전(PRBKY*)·토너(PRBKO*), 굿즈(GSTGMIC), 아크릴(ACNTHAP). 레거시는 jQuery 구형. 코드 규칙: `{카테고리}{타입}{특성}`.

## 트러블슈팅

| 증상 | 원인 | 해결 |
|------|------|------|
| 위젯 미마운트 | 토큰/쿠키 만료 | `node extract-cookies.cjs` 후 재기동 |
| 502 프록시 에러 | 세션 쿠키 없음 | `cookies.json` 갱신 |
| 에디터 iframe 안뜸 | RP_EDITOR_TOKEN 만료 | `POST /refresh-token` |
| 가격 응답 비어있음 | 필수 옵션 미선택 | 규격·자재·수량 선행 선택 후 재호출 |
