# price-engine.md — 가격 흐름 (서버 권위)

> 파이프라인 ③. [HARD] 위젯은 가격을 **절대 계산하지 않는다**. 옵션 상태 → 정규화 요청 → 서버 응답 표시.
> 근거: [역공학 price-engine §3] 클라이언트 재계산 금지(역산 반증) / [동작분석] 디바운스 ~360ms 라이브 입증 / [DESIGN 7.13] Summary.

---

## 0. 핵심 원칙

[역공학 price-engine §2 단가분해] result_log[3] 머신리더블 단가를 단순 곱해도 실제가와 불일치(130,260 ≫ 56,000) → 단가테이블·구간보간은 서버 내부. **위젯이 재계산하면 틀린다**. 위젯은 표시만.

```
옵션 변경 → store.selections 갱신 → applyCascade → debounce(300ms)
  → NormalizedPriceRequest 조립 → 캐시 확인 → BFF POST /price
  → NormalizedPriceBreakdown → store.price → PriceSummary 리렌더
```

---

## 1. 요청 조립 (store → 정규화 요청)

```ts
function buildPriceRequest(s: WidgetState): NormalizedPriceRequest {
  return {
    productCode: s.product!.code,
    priceSchemeKey: s.product!.priceSchemeKey,        // 불투명 echo (Red price_gbn)
    customerTier: s.member.tier,                       // 기본값은 어댑터가 채움
    dimensions: s.product!.sides.map(side => dimsFromSelection(s, side.key)),
    colorCounts: colorCountsFromSelections(s),         // priceColorCount 평면화 사용
    materials: materialsFromSelections(s),             // 불투명 자재 id
    quantity: s.quantity,
    pageCount: s.pageCount,                             // 책자만
    selectedFinishes: finishesFromSelections(s),       // {groupId, valueId}[]
  };
}
```

> 위젯은 `priceSchemeKey`·자재 id·color count를 **해석 없이 전달**. price_gbn 분기(book2025/tiered/vTmpl)는 [역공학 §1] 서버측 가격 룰 엔진이 처리. 위젯은 echo만 → 후니 어댑터가 후니 가격엔진으로 동일 분기.

---

## 2. price_gbn 분기 (서버측, 위젯 무관)

[역공학 price-engine §1]:

| 상품 | priceSchemeKey (Red price_gbn) | 체계 |
|------|-------------------------------|------|
| 책자 | `book2025_price` | 표지+내지 분리, 페이지×수량 |
| 굿즈 | `tiered_price` | 수량 구간 단가 |
| 아크릴 | `vTmpl_price` | 템플릿 기반 |

[결정] 위젯은 이 키를 요청에 echo만 하고 동일 엔드포인트(`/price`)로 호출. 분기는 BFF/어댑터/가격엔진 책임. 위젯에 분기 로직 0.

---

## 3. 디바운스 + 캐시

```ts
// debounce 300ms — [동작분석] 라이브 ~360ms(300 디바운스 + 처리) 입증
const schedulePriceQuote = debounce(() => {
  const req = buildPriceRequest(get());
  const key = hashRequest(req);                  // 결정적 직렬화 해시
  const cached = get().priceCache.get(key);
  if (cached && Date.now() - cached.ts < TTL_MS) { set({ price: cached.value }); return; }
  set({ status: 'pricing' });
  bff.price(req).then(res => {
    get().priceCache.set(key, { value: res, ts: Date.now() });
    set({ price: res, status: 'ready' });
    emit('huni:price-change', res);              // 호스트 콜백/CustomEvent
  }).catch(e => set({ status: 'error', errors: [...] }));
}, 300);
```

| 파라미터 | 값 | 근거 |
|---------|-----|------|
| debounce | **300ms** | [동작분석] 라이브 360ms = 300 디바운스 + 오버헤드. 연속변경 시 마지막만 |
| 캐시 TTL | **30s** | [동작분석 sequence §2] "동일 옵션 30s 캐시(TTL) — 정적 근거". 같은 조합 재선택 시 재호출 방지 |
| 캐시 키 | request 결정적 해시 | 옵션 조합 동일성 |
| 캐시 무효화 | TTL 만료 + 상품 변경 시 전체 clear | [결정] 가격은 서버 변동 가능 → TTL 짧게 |

> [결정] 캐시는 인스턴스 store 내 `Map`(인메모리). 영속화 안 함(과설계 금지). TTL 30s는 동일옵션 토글 왕복만 흡수하는 보수적 값.

---

## 4. 응답 표시 (PriceSummary — DESIGN 7.13)

```
NormalizedPriceBreakdown:
  lines[]    → 공정별 분해 행 (항목 12px #616161 + 금액 12px #424242) [투명성 — 후니 차별]
  divider
  finalPrice → 합계금액 24px/600 #553886
  vat        → "부가세" 12px #424242
  shipping   → 배송비 (book_info.DLVR_AMT)
```

> [역공학 §3 시사 2] 공정별 분해 표시는 후니 차별점(가격 투명성)으로 보존. [DESIGN 7.13] 합계 24px/600 보라 고정.
> 3단 워터폴(정가/할인가/몰가)은 어댑터가 `finalPrice`로 평면화([data-adapter §2.4]) — 위젯은 단일 금액만 표시.

---

## 5. 서버 가격 API 계약 (BFF)

위젯↔BFF (정규화). BFF↔데이터소스(Red/후니)는 어댑터.

```
POST {HUNI_BFF_URL}/price
Req:  NormalizedPriceRequest   (data-contract §3)
Res:  NormalizedPriceBreakdown (data-contract §3)
```

BFF 내부(어댑터): `NormalizedPriceRequest` → Red `{dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}` → `get_ajax_price_vTmpl` → 워터폴 적용 → `NormalizedPriceBreakdown`. [역공학 §1 실측 계약].

---

## 6. 초기 자동 가격

[동작분석 §1 라이브] 위젯 마운트 직후 기본 선택 옵션으로 가격 1회 자동 호출(사용자 입력 없이 표시). `loadProduct` 완료 → 기본 selections 세팅 → `schedulePriceQuote()` 즉시(디바운스 통과). status: loading→ready→pricing→ready.

---

## 7. OPEN

- 굿즈/아크릴 가격 요청 정확 필드(PAGE_CNT 생략 등) — 어댑터 분기로 흡수, 후니 데이터로 검증 [역공학 미검증: 비책자].
- 회원등급 할인 워터폴 실데이터 — 어댑터 책임, 위젯 무관 [역공학 미검증].
