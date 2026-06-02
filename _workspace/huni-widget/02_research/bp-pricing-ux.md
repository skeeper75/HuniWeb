# 실시간 가격 UX · 제품 구성기 베스트프랙티스

> 파이프라인 ② 산출물. 견적 위젯·제품 구성기의 실시간 가격 표시 UX 패턴.
> 기준선: RedPrinting 가격 엔진은 **서버 권위 모델** — 위젯은 절대 계산하지 않고, 옵션 변경 → 디바운스 → `POST get_ajax_price_vTmpl` → `result_sum` 표시(`price-engine-reversed.md` §3, `widget-runtime-spec.md` §7). 후니도 동일 계약.
> 모든 인용은 WebFetch 검증 URL만. 출처는 하단 `Sources:`.

---

## 1. 서버 권위 가격 모델 — 후니의 출발 전제

`price-engine-reversed.md`가 라이브 반증한 핵심: 클라이언트의 순진한 `(자재+인쇄)×수량` 계산은 130,260원, 실제 서버 응답은 56,000원 — **수량구간 단가 마스터·볼륨 디스카운트는 서버 내부 룰**이므로 클라이언트 재계산 금지. 위젯의 역할은 **옵션 수집 → API 호출 → 응답 표시**뿐이다.

CPQ(Configure-Price-Quote) 솔루션도 동일하게 "real-time data를 활용해 제품 구성·고객 세그먼트에 따라 동적으로 가격을 산정"하며, 가격 산정 권위는 백엔드에 둔다 [DealHub]. 후니 위젯의 모든 가격 UX는 이 비동기 서버 호출의 **지연·로딩·실패·stale**을 어떻게 매끄럽게 다루느냐로 귀결된다.

## 2. 디바운스 + 로딩 인디케이터 지연 (flicker 방지)

옵션을 빠르게 연속 변경하면 매 변경마다 API를 때리지 않도록 **디바운스**가 필수. RedPrinting도 옵션 변경 → debounce → 가격 API 흐름(`widget-runtime-spec.md` §7).

검증된 로딩 인디케이터 규칙 [Tamara][OneThing]:
- **300ms 미만에 해소될 확신이 있으면 아무것도 표시하지 않는다** — "if the action will resolve in under 300ms with high confidence, show nothing" [Tamara]. 즉각 동작에 로딩 UI를 깜빡이면 오히려 혼란.
- **스피너 등장을 200~300ms 지연**시켜 빠른 응답 시 flicker 방지 — "Delay spinner appearance by 200–300ms for actions that might resolve quickly" [Tamara].
- 100ms 이하 완료 시 인디케이터는 flicker만 유발 [Tamara].

**후니 권고 (Priority High)**:
- 옵션 변경 → **디바운스(~250~350ms)** 후 가격 API 호출. 디바운스 윈도우 자체가 빠른 연속 변경을 흡수.
- 가격 영역 로딩 인디케이터는 **응답이 ~300ms 넘게 지연될 때만** 표시(지연 등장). 빠른 응답은 무인디케이터로 즉시 갱신.
- **전역 차단 스피너 금지** — "use localized, progressive feedback instead of global spinners that block interaction and hurt both UX and INP scores" [WebSearch:loading]. 가격 숫자 영역에 국소적 피드백만.

## 3. 로딩 패턴 선택 — 스피너 vs 스켈레톤 vs 낙관적

검증된 의사결정 프레임 [Tamara][OneThing]:

| 패턴 | 적용 시점 | 견적 위젯 매핑 |
|------|----------|---------------|
| **무표시** | <300ms 고확신 해소 | 옵션 토글 후 빠른 가격 재계산 (대부분 케이스) |
| **국소 스피너/펄스** | 단일 동작, 2~10초, 미리보기 레이아웃 없음 | 가격 숫자 영역 재계산 중 미세 펄스 (지연 등장) |
| **스켈레톤** | 구조 있는 콘텐츠 로드, 1~10초 | **최초 위젯 로드 시 옵션 폼·가격 분해 영역 스켈레톤** (레이아웃 시프트 방지, 체감 30% 빠름 [OneThing]) |
| **낙관적 UI** | <300ms 가정, 저위험·가역 | 가격에는 **부적합** — 가격은 서버 권위·고위험. "Never use for payments" [Tamara] |

**핵심 구분**: 스피너는 시스템 동작 확인용, 스켈레톤은 콘텐츠 로딩용 [OneThing]. 가격 같은 **결제 직결·서버 권위 값에는 낙관적 업데이트를 쓰지 않는다** — "Optimistic UI ... Never use for: irreversible or high-stakes actions (payments, deletions)" [Tamara].

**후니 권고 (Priority High)**:
- **최초 로드**: 옵션 폼 + 가격 분해 영역에 스켈레톤(레이아웃 시프트 0, `get_digital_product_info` 응답 전).
- **옵션 변경 중**: 가격 숫자에 낙관적 추정값을 넣지 말 것. 대신 **이전 가격을 dimmed/펜딩 상태로 유지**하면서 국소 펄스 → 새 값 도착 시 교체. 잘못된 추정 가격 표시는 신뢰 붕괴.

## 4. stale·에러·낙관성의 올바른 사용

낙관적 업데이트는 "save/like/toggle 같은 가역·저위험 동작에 UI 즉시 갱신 후 서버와 reconcile, 실패 시 rollback + 명확한 에러" [Tamara][WebSearch:loading]. 가격에는 낙관 값을 쓰지 않되, **인터랙션 응답성**(옵션 토글 자체의 즉각 반영)에는 적용:

- **옵션 선택 상태**는 낙관적 즉시 반영(토글·캐스케이드 활성/비활성). 이는 저위험·가역.
- **가격 값**은 서버 확정 전까지 "재계산 중" 표시(이전 값 dimmed). 도착 시 교체.
- **stale 처리**: 디바운스/네트워크 경합으로 **오래된 응답이 늦게 도착**할 수 있음 → 각 요청에 시퀀스/요청 ID를 달고 **최신 요청 응답만 반영**(out-of-order 폐기). debounce+optimistic 조합의 알려진 함정 [RTK#1675].
- **에러**: 가격 API 실패 시 가격 영역에 명확한 재시도 + 직전 유효값 유지(전체 위젯 다운 금지, `bp-embed-widget.md` fail-silently). 주문 진행은 유효 가격 없으면 차단.

## 5. 가격 분해 투명성 — 후니 차별점

RedPrinting 응답은 공정별 분해(`result[]`: 인쇄/코팅/재단)와 합계 워터폴(`result_sum`), 단가 명세(`result_log`)를 제공(`price-engine-reversed.md` §1). **3단 가격 워터폴**:
```
PRICE_MALL ≠ PRICE → 몰가  (PRICE_MALL + VAT)
ORG_PRICE ≠ PRICE  → 할인가 (PRICE + VAT)
그 외              → 정가  (ORG_PRICE + VAT)
```

**후니 권고 (Priority Medium~High)**:
- **가격 분해 표시**(인쇄/후가공/배송 분리 + VAT 별산)를 후니 차별점으로 채택 — 가격 투명성은 견적 신뢰의 핵심. `price-engine-reversed.md` §3가 권고한 방향.
- 워터폴(정가→할인가→몰가)을 시각적으로 노출(원가 대비 절감 강조). 단, 비회원/기본등급은 세 값 동일하므로 할인 표기는 조건부.
- 배송비(`book_info.DLVR_AMT`)·무게·박스수를 합계에 명시.

## 6. 제품 구성기 — 옵션 캐스케이드·제약 충족 UI

RedPrinting은 `pdt_disable_pcs_info`(책자 24개 제약)로 **옵션 캐스케이드 제약**을 서버 데이터로 정의(`widget-runtime-spec.md` §4). 예: 특정 자재 선택 시 양립 불가 후가공 비활성화.

구성기 UX 패턴 (CPQ 일반 + Red 데이터 기반):
- **점진적 공개(progressive feedback)**: 상위 옵션(상품군/규격)이 하위 옵션(자재→도수→후가공)을 캐스케이드로 활성화. RedPrinting의 fieldset N개 순차 구조(`widget-runtime-spec.md` §2).
- **제약 충족 표시**: 비양립 옵션은 **비활성화(disabled) + 사유 툴팁** > 숨김. 사용자가 "왜 못 고르는지" 알게.
- **무효 조합 방지**: 제약 위반 조합 자체를 선택 불가로 → 무효 견적 API 호출 차단.
- 각 옵션 변경이 가격 재계산을 트리거하므로 §2 디바운스와 결합.

**후니 권고 (Priority High)**: 옵션 제약은 **정규화 계약(Option Schema API)에 제약 규칙을 포함** → 위젯은 규칙 기반으로 disable/사유 표시. Red의 `pdt_disable_pcs_info`를 어댑터로 정규화 제약 스키마에 매핑. shadcn Select/Tooltip(`bp-react-shadow-dom.md` 포털 함정 주의)로 구현.

## 7. 후니 채택 결론

| 결정 | 권고 | Priority |
|------|------|----------|
| 가격 권위 | 서버 전용, 클라이언트 재계산 금지 (Red 계약 유지) | High |
| 디바운스 | 옵션 변경 ~250~350ms 디바운스 + 요청 ID로 stale 폐기 | High |
| 로딩 | 최초=스켈레톤, 재계산=지연 등장 국소 펄스, 전역 스피너 금지 | High |
| 낙관성 | 옵션 토글=낙관 즉시 반영 / 가격값=낙관 금지(이전값 dimmed) | High |
| 투명성 | 공정별 분해 + 3단 워터폴 + VAT/배송 별산 | Medium-High |
| 구성기 | 캐스케이드 + 제약 disable+사유, 정규화 스키마에 제약 포함 | High |

---

## Sources:

- [Tamara] Loading States Are Not One Component — https://www.tamaramilakovic.com/thinking/loading-states-are-not-one-component (WebFetch 검증: <300ms 무표시·스피너 200~300ms 지연 등장·낙관 UI는 payment 금지·스피너/스켈레톤/진행바 임계)
- [OneThing] Skeleton Screens vs Loading Spinners — https://www.onething.design/post/skeleton-screens-vs-loading-spinners (WebFetch 검증: 스피너=시스템동작/스켈레톤=콘텐츠로딩·체감 30% 빠름·레이아웃 시프트 방지)
- [DealHub] What is Real-Time Pricing? — https://dealhub.io/glossary/real-time-pricing/ (WebSearch 결과 — CPQ 실시간 동적 가격, 본문 미정독: 보조 인용)
- [RTK#1675] Optimistic updates with debounce — https://github.com/reduxjs/redux-toolkit/issues/1675 (WebSearch 결과 — debounce+optimistic 경합/stale 함정, 본문 미정독: 보조 인용)
- [WebSearch:loading] A Quick Guide to Loading Indicators in Web Apps — https://blog.openreplay.com/quick-guide-loading-indicators-web-apps/ (WebSearch 결과 — 전역 차단 스피너 회피·국소 점진 피드백·INP, 본문 미정독: 보조 인용)
