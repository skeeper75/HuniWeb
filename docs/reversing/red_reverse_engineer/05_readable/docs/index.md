# RedPrinting 위젯/SDK 가독 소스 — 길잡이 인덱스

> RedPrinting 주문 위젯과 에디터 SDK를 **역공학 → 가독화**한 결과물(`02_readable/*.js`)을 사람이
> 빠르게 이해·길찾기 하도록 안내하는 문서 모음. 코드는 engineer가 동작 보존을 유지한 채 읽기 쉽게
> 만들었고(AST 리네임·주석·prettier 포매팅), 이 문서들은 그 위에 **지도와 해설**을 얹는다.
>
> **근거 원칙:** 본 문서의 모든 서술은 가독 소스(`02_readable/`)·지도(`01_cartography/`)·검증
> 판정(`03_verify/*.verdict.md`)·플레이북(`_meta/technique-playbook.md`)에 있는 것만 인용한다.
> 추정은 "추정", 미상은 "미상"으로 표기한다. **파일:라인** 인용은 가독 소스(`02_readable/`) 기준이다.

---

## 0. 검증 상태 한눈에 (verdict 인용)

| 모듈 | 가독 파일 | 줄수 | 게이트 | 판정 | 문서 |
|------|-----------|------|--------|------|------|
| 앱 API/유틸 | `deob_05_app_api.js` | 1,695 | G1~G6 | **GO** | [01-app-api.md](01-app-api.md) |
| 위젯 SDK/컴포넌트/스토어 | `deob_06_app_widget_sdk.js` | 1,751 | G1~G6 | **GO** | [02-widget-sdk.md](02-widget-sdk.md) |
| Vue 주문 컴포넌트 | `deob_07_app_components.js` | 4,865 | G1~G6 | **GO**(절단 복원 입력) | [03-app-components.md](03-app-components.md) |
| 에디터 SDK | `deob_editor_sdk.js` | (658KB) | G1~G6 | **GO** | [04-editor-sdk.md](04-editor-sdk.md) |

GO 4건 전부 동등성·가독성 게이트 통과. 검증 방법·동작 보존 증명은 [05-method.md](05-method.md) 참조.
※ `deob_07`은 입력 번들이 절단(truncation)되어 **합성 복원 scaffold**(원본 아님)를 포함한다 — 03 문서에서 명시.

---

## 1. 무엇을 어디서 찾나 (주제 → 파일:라인)

### 가격 계산 (돈 흐름)
| 주제 | 위치 |
|------|------|
| 가격 계산 API 호출(`POST .../get_ajax_price_vTmpl`) | `deob_05_app_api.js:1259` `fetchPriceCalculation` |
| 가격 요청 payload 구조(`ORD_INFO`·`PCS_INFO`·`price_gbn`·`mb_cust_cod`) | `deob_05_app_api.js:1257`(JSDoc), `:1271` body |
| 가격 API 호출 빈도 제한(debounce) | `deob_05_app_api.js` `initDebounce`(comment-map) |
| 주문 요약 표시(PRICE/PRICE_MALL) | `deob_06_app_widget_sdk.js:1229` `getSummary` |

### 제품/옵션 데이터
| 주제 | 위치 |
|------|------|
| 제품 정보 조회 API(`GET .../get_digital_product_info`) | `deob_05_app_api.js:1205` `fetchProductInfo` |
| 주문 가능 용지(자재) 목록 | `deob_05_app_api.js:1347` `fetchAvailableMaterials` |
| 제품 코드별 설정 상수(수량 UI·달력 코드 등) | `deob_06_app_widget_sdk.js:872`(섹션 23) |

### 위젯 진입·렌더링
| 주제 | 위치 |
|------|------|
| SDK 진입점 클래스 | `deob_06_app_widget_sdk.js:31` `class RedWidgetSDK` |
| clientKey 검증(`red-mobile`/`red-pc`) | `deob_06_app_widget_sdk.js:41`, 상수 `:1178` |
| Shadow DOM 생성 + Vue 앱 마운트 | `deob_06_app_widget_sdk.js:74` `attachShadow` |
| Shadow DOM CSS 주입 | `deob_06_app_widget_sdk.js:1379`(섹션 26) `appendStylesheetToShadow` |
| 위젯 인스턴스(외부 호출 API) | `deob_06_app_widget_sdk.js:1203` `CommonWidgetInstance` |

### Pinia 스토어 (상태)
| 주제 | 위치 |
|------|------|
| 스토어 정의 섹션 | `deob_06_app_widget_sdk.js:709`(섹션 22) |
| 다국어 locale·translate | `useConfigStore`(comment-map) |
| 제품 기준정보 | `useProductStore`(comment-map) |
| **업로드 경로 분기(editor/pdf)** | `deob_06_app_widget_sdk.js:970` `useExteriorStore` |
| 주문 옵션·가격 결과 | `useOrderStore`(comment-map) |

### 파일업로드 vs 에디터(에디쿠스) 경로 분기
| 주제 | 위치 |
|------|------|
| uploadType 상태(editor\|pdf) | `deob_06_app_widget_sdk.js:971` `uploadType` reactive |
| 에디터 결과 주입(KOI/RP 분기) | `deob_06_app_widget_sdk.js:1438` `setEditorData` |
| 주문 가능 검증(업로드/가격/옵션) | `deob_06_app_widget_sdk.js:1462` `canOrder` |

### 에디터 SDK (Edicus 브릿지)
| 주제 | 위치 |
|------|------|
| 에디터 iframe 통신 관리자 | `deob_editor_sdk.js:3769` `editorBridge`(EditorBridge) |
| iframe URL base(운영/개발) | `deob_editor_sdk.js:3770`/`:3790` |
| postMessage 송신(`to-edicus*`) | `deob_editor_sdk.js:3873`, `:4044`, `:4065` |
| postMessage 수신(`from-edicus*`) | `deob_editor_sdk.js:3803`~`:3808` |
| makers API HTTP 래퍼 | `deob_editor_sdk.js:4343` `ApiClient` |
| `red-editor-token` 헤더 인증 | `deob_editor_sdk.js:4415` 외 |
| 메인 SDK 클래스(window export) | `deob_editor_sdk.js:15137` `RedEditorSDK`, export `:18944` |
| SDK 버전(6.6.48) | `deob_editor_sdk.js:8`(주석), `:147`(JSDoc) |
| **passive 모드 전환** | `deob_editor_sdk.js:15497`, `:15995` |
| 고수준 명령 → DDP 블록 변환 | `deob_editor_sdk.js:14118` `ddpBlockBuilder` |
| 커스텀 탭(옵션 UI) 데이터 가공 | `deob_editor_sdk.js:18267` `CustomTabManager` |
| sessionStorage(Base64) 관리 | `deob_editor_sdk.js:13943` `sessionStorageManager` |

### Vue 주문 컴포넌트 (상품군별 UI)
| 주제 | 위치 |
|------|------|
| 의류(Apparel) 컴포넌트군 | `deob_07_app_components.js:97`(섹션 1) `ApparelModule` 외 |
| 책자(Book) 컴포넌트군 | `deob_07_app_components.js` `BookModule`·`BookQty`·`Paper`·`CoverGuide` |
| 부자재(Acc) 컴포넌트 | `deob_07_app_components.js` `AccModule` |
| 후가공(PostProcess) 컴포넌트군 | `deob_07_app_components.js:2294`(섹션 16~28) |
| 절단 경계(원본에만 존재하는 컴포넌트 목록) | `deob_07_app_components.js:2588`(comment-map) |

---

## 2. 레지스트리 링크

- **모듈 경계·아키텍처 다이어그램** → [00-architecture.md](00-architecture.md)
- **컴포넌트/스토어 카탈로그** → [02-widget-sdk.md](02-widget-sdk.md), [03-app-components.md](03-app-components.md)
- **RedEditorSDK 메서드 카탈로그** → [04-editor-sdk.md](04-editor-sdk.md)
- **적용 기법·동작 보존 증명** → [05-method.md](05-method.md)

---

## 3. 인용 규약

- `파일:라인`은 `02_readable/<파일>` 기준(가독 소스). 예: `deob_05_app_api.js:1259`.
- 섹션 번호는 cartography `comment-map.json`의 section-banner 기준.
- 원본 식별자(난독화된 1~2자)는 cartography·verdict가 기록한 경우만 병기(예: EditorBridge=원본 `Qe`).
- 미상·미확인은 본문에서 그대로 "미상"으로 표기한다.
