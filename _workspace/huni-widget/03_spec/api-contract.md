# api-contract.md — 위젯 ↔ BFF API 계약

> 파이프라인 ③. 위젯이 호출하는 모든 BFF 엔드포인트. 정규화 계약(data-contract)을 만족하는 BFF.
> [HARD] 후니 백엔드 매핑(데이터소스/커머스)은 **어댑터** 책임. 위젯은 BFF 정규화 계약만 안다. Shopby 가정 0건.
> 근거: [역공학] 6 API 실측 / [동작분석] / 스코프 제약(커머스 UNDECIDED).

---

## 0. 공통

- 베이스: `{HUNI_BFF_URL}` (`.env.local`, 값 비노출). 위젯 init opts로 주입.
- 인증: [역공학 §5] Red은 세션쿠키 + red-editor-token JWT. 후니 BFF는 [결정] 세션/토큰 모델 미정 → BFF가 결정(위젯은 `credentials: 'include'`로 쿠키 위임, 토큰 필요 시 BFF가 발급해 응답에 포함). 위젯은 인증 메커니즘에 결합하지 않음.
- 형식: JSON. 모든 req/res는 정규화 타입(data-contract).
- 에러: `{ ok:false, code, message }` 공통 — 위젯은 status='error' + reasons 표시.

---

## 1. 엔드포인트 (5 + 1 UNDECIDED)

| # | Method · Path | Req | Res | Red 원천 [역공학] |
|---|--------------|-----|-----|------------------|
| 1 | `GET /product/{code}` | — | `NormalizedProduct` | `get_digital_product_info` |
| 2 | `POST /price` | `NormalizedPriceRequest` | `NormalizedPriceBreakdown` | `get_ajax_price_vTmpl` |
| 3 | `POST /presigned` | `NormalizedPresignedRequest` | `NormalizedPresigned` | `/api/aws/presigned-url` |
| 4 | `POST /file-meta` | `{storedFileName}` | `{pageCount, sizeBytes}` | `s3GetObjectJson` |
| 5 | `POST /editor-config` | `{productCode, side}` | `NormalizedEditorConfig` | `/api/editor/config/KOI` + makers 체인 |
| 6 | `POST /cart-handoff` | `NormalizedCartHandoff` | `{ok, redirectUrl?}` | **커머스 바인딩 UNDECIDED** |

> 업로드 PUT은 BFF 경유 안 함 — 위젯이 presigned URL로 **S3 직접 PUT**([역공학 s3-upload §2]). BFF는 발급(#3)·메타(#4)만.

---

## 2. 상세 계약

### #1 GET /product/{code}
- Res: `NormalizedProduct` (data-contract §1). 옵션그룹·componentType·캐스케이드·capability 전부 포함(초기 1회).
- BFF: 어댑터 `getProduct(code)`. Red fixture(오늘) / 후니 DB(추후).

### #2 POST /price
- [HARD] 위젯은 계산 안 함. Req echo(priceSchemeKey)만. debounce 300ms·캐시 30s는 위젯측(price-engine §3).
- BFF: 어댑터 `quote()` → 데이터소스 가격엔진 → 워터폴 적용 → `finalPrice` 평면화.

### #3 POST /presigned
- Req: `{fileName, productCode, contentType:"application/pdf", side}`.
- Res: `{uploadUrl(60분), storedFileName(UUID), expiresInSec}`.
- [역공학] 발급 직전 1회. 위젯이 받은 `uploadUrl`로 즉시 `PUT`(Content-Type:application/pdf).

### #4 POST /file-meta
- 업로드 후 페이지수/크기 검증(canOrder 입력). [역공학] s3GetObjectJson.

### #5 POST /editor-config
- Res: `NormalizedEditorConfig {psCode, templateUrl, resourceId, token, pluginCustomData}`.
- BFF: Edicus 토큰체인(makers /token, /editor, PUT /template/hit)을 서버에서 수행([동작분석 §4]). 위젯엔 최종 config만 → 토큰 노출 최소.

### #6 POST /cart-handoff [커머스 UNDECIDED]
- Req: `NormalizedCartHandoff` (옵션 스냅샷 + 가격 + artifacts).
- Res: `{ok, redirectUrl?}` — redirectUrl 있으면 위젯이 호스트에 `huni:order` 콜백으로 전달(호스트가 이동).
- [HARD 스코프] BFF 내부에서 커머스 플랫폼(장바구니 추가/주문 생성)을 호출하는 부분은 **미정**. 위젯·계약은 플랫폼 무지(無知). 어댑터 `CartAdapter.handoff()`가 추후 바인딩. Shopby 등 특정 플랫폼 가정 금지.

---

## 3. 호출 시점 (위젯 라이프사이클)

```
mount        → #1 GET /product (1회)
              → #2 POST /price (초기 자동, debounce 통과)
옵션변경      → #2 POST /price (debounce 300ms, 캐시 30s)
PDF 선택      → #3 POST /presigned → S3 PUT(직접) → #4 POST /file-meta
편집하기      → #5 POST /editor-config → Edicus iframe
편집완료/주문 → #6 POST /cart-handoff
```

---

## 4. BFF↔데이터소스 (어댑터 — 위젯 무관, 참조용)

[data-adapter.md] BFF는 어댑터로 데이터소스 호출:
- 오늘: Red fixture(`captures/*.json`) 또는 Red 프록시.
- 추후: 후니 DB(Neon `DATABASE_URL`) + Edicus(`.env.local` EDICUS_*) + 커머스(UNDECIDED).

> [결정] 위젯 스펙은 BFF 정규화 계약에서 멈춘다. BFF 내부 데이터소스 전환은 위젯/계약 무변경(컨버전 키스톤).

---

## 5. OPEN

- BFF 인증 모델(세션쿠키 vs 토큰) 확정 — 위젯은 결합 안 하나 BFF 구현 시 결정.
- `/cart-handoff` 커머스 바인딩 — DB·커머스 확정 후 [UNDECIDED].
- presigned PUT 정확 헤더(checksum) — [역공학 미검증], uploader는 Content-Type만으로 검증됨.
