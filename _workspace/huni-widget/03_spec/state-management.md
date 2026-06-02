# state-management.md — Zustand 스토어 설계

> 파이프라인 ③. Zustand 스토어(Red 4~5 Pinia 대응) + 상태 shape + 캐스케이드 통합 + 셀렉터.
> 근거: [역공학 §3] Red Pinia(config/product/order/exterior/acc-order) / [동작분석] cascade·state-machine / [DESIGN RULE-5] store 데이터 우선순위.

---

## 0. 결정: 단일 store + slice (5 Pinia → 1 Zustand)

[역공학] Red는 5 Pinia 스토어. [결정] 후니는 **단일 Zustand store + 논리 slice**. 이유:
- Red의 5 스토어는 Vue/Pinia 관례(인스턴스별 분리). 후니는 위젯 1 인스턴스 1 store가 자연스럽고, slice로 동일 관심사 분리 가능.
- 멀티 인스턴스는 `createWidgetStore()` 팩토리로 인스턴스별 store 생성(전역 싱글톤 금지 — bundle-strategy §5).
- 과설계 금지: 5개 독립 store + 크로스 store 동기화는 불필요한 복잡도. slice로 충분.

```
useWidgetStore = create<WidgetState>()(...)   // 인스턴스별 팩토리
  ├─ config slice    (Red useConfigStore)   : locale, deviceType, member, capability
  ├─ product slice   (Red useProductStore)  : NormalizedProduct (정규화, 불변)
  ├─ order slice     (Red useOrderStore)    : 선택 상태(selections, quantity, dimensions)
  ├─ exterior slice  (Red useExteriorStore) : 면별 업로드/에디터 결과(artifacts)
  ├─ price slice                            : 최신 NormalizedPriceBreakdown + 캐시
  └─ ui slice                               : status(state-machine), editorOpen, errors
```

> 부자재(ACC) `useAccOrderStore`는 별 슬라이스 불필요 — order slice가 `selections`로 동일 처리(부자재도 옵션 선택). [결정] Red의 인스턴스 분리(CommonWidget vs AccWidget)는 상품군 차이일 뿐 동일 정규화 계약으로 흡수.

---

## 1. 상태 shape

```ts
interface WidgetState {
  // config
  locale: string; deviceType: 'pc'|'mobile'; member: { tier?: string };
  // product (정규화, 로드 후 불변)
  product: NormalizedProduct | null;
  // order — 사용자 선택 상태 (위젯의 진짜 상태)
  selections: Record<string /*groupId*/, string | string[] /*valueId(s)*/>;
  quantity: number;
  pageCount?: number;
  // exterior — 면별 입력 결과
  artifacts: Partial<Record<SideKey, NormalizedArtifact>>;
  // price — 서버 권위 결과 (위젯은 저장만)
  price: NormalizedPriceBreakdown | null;
  priceCache: Map<string /*reqHash*/, { value: NormalizedPriceBreakdown; ts: number }>;
  // ui
  status: WidgetStatus;   // 'idle'|'loading'|'ready'|'pricing'|'designing'|'submitting'|'error'
  editorSide: SideKey | null;
  errors: string[];

  // actions
  loadProduct(code: string): Promise<void>;
  selectOption(groupId: string, valueId: string | string[]): void;  // → applyCascade → schedulePriceQuote
  setQuantity(n: number): void;
  setPageCount(n: number): void;
  applyCascade(changedGroupId: string): void;
  schedulePriceQuote(): void;            // debounce 300ms (price-engine.md)
  setArtifact(side: SideKey, a: NormalizedArtifact): void;
  openEditor(side: SideKey): Promise<void>;
  cartHandoff(): NormalizedCartHandoff;
}
```

> [DESIGN RULE-5] 라벨/구조는 `product`(정규화 계약)에서. `selections`는 valueId만 보관(라벨 중복 저장 안 함). 표시 시 `product.optionGroups[].values`와 join.

---

## 2. 셀렉터 (구독 최소화)

[결정] 컴포넌트는 필요한 slice만 셀렉터로 구독(Zustand 리렌더 최소화):

```ts
export const useOptionSelection = (groupId: string) => useWidgetStore(
  s => ({ value: s.selections[groupId], set: (v) => s.selectOption(groupId, v) }), shallow);
export const usePrice = () => useWidgetStore(s => s.price);
export const useStatus = () => useWidgetStore(s => s.status);
export const useGroupValues = (groupId: string) => useWidgetStore(  // 캐스케이드 disabled 반영
  s => s.product?.optionGroups.find(g => g.id === groupId)?.values, shallow);
export const useCanOrder = () => useWidgetStore(selectCanOrder);  // §5
```

---

## 3. 호스트 격리

- [HARD] store는 Shadow DOM 내부 React 트리에만 존재. 호스트 페이지 전역(window) 노출 금지. 호스트 통신은 loader 브리지(콜백/CustomEvent)로만.
- 멀티 인스턴스: 각 위젯 = 독립 `createWidgetStore()`. 인스턴스 간 상태 공유 없음.
- [결정] 호스트가 위젯 상태를 직접 읽지 않는다 — 필요한 값은 이벤트(`huni:price-change` 등)로 push. Red도 콜백 방식 [동작분석 event-contract §1].

---

## 4. 캐스케이드 통합 (6종 룰엔진)

[동작분석 cascade §6] 적용 순서 보존이 핵심. `applyCascade`는 클라이언트 룰(서버 왕복 없음):

```ts
applyCascade(changedGroupId) {
  const g = findGroup(changedGroupId);
  // ① material→pcs disable
  if (isMaterialGroup(g)) {
    const selected = selections[changedGroupId];
    const disabled = product.constraints.disableRules.filter(r => r.triggerValueId === selected);
    // 영향 그룹/값에 disabled 마킹 (product.values[].disabled 갱신)
    markDisabled(disabled);
    // 비활성된 후가공이 선택돼 있었으면 해제 (연쇄)
    deselectDisabled(disabled);
  }
  // ④ size: 선택값 → dimensions(cut/work) 세팅
  if (isSizeGroup(g)) setDimensionsFromSizeRule(selections[changedGroupId]);
  // ③ dosu: colorCount는 OptionValue.priceColorCount로 이미 평면화 — 별도 처리 불필요
  // ②⑥ quantity/page clamp은 setQuantity/setPageCount에서 처리
  // 공통 후처리: 가격 재계산 (해제로 인한 변동 반영 — 반드시 캐스케이드 후)
  schedulePriceQuote();
}
```

> [동작분석 cascade §1 적용순서] 자재변경 → disable 룩업 → UI disable → 선택해제 → 가격재계산. 선택해제가 가격에 영향을 주므로 재계산은 항상 마지막. 위젯 코드가 이 순서를 보장.
> [결정] disabled 마킹은 `product.values[].disabled`를 immer로 갱신(정규화 계약의 런타임 필드). 어댑터 초기값 false, 클라이언트가 토글.

---

## 5. canOrder 셀렉터 (서버 왕복 없는 클라이언트 판정)

[동작분석 state-machine §4]:

```ts
export const selectCanOrder = (s: WidgetState): { ok: boolean; reasons: string[] } => {
  const r: string[] = [];
  // 필수 옵션 완결
  s.product?.optionGroups.filter(g => g.required && g.visible)
    .forEach(g => { if (!s.selections[g.id]) r.push('주문불가-옵션'); });
  // 수량/페이지
  const q = s.product?.constraints.quantity.default;
  if (q && s.quantity < q.min) r.push('주문불가-수량');
  // 면별 입력 완료 (editor=projectId / pdf=storedFileName)
  s.product?.sides.forEach(side => {
    const a = s.artifacts[side.key];
    if (side.uploadType === 'editor' && !a?.projectId) r.push('주문불가-파일');
    if (side.uploadType === 'pdf' && !a?.storedFileName) r.push('주문불가-파일');
  });
  // 파일명 중복
  if (dupOriginalNames(s.artifacts)) r.push('주문불가-파일명중복');
  // 가격 산정 성공
  if (!s.price?.ok || (s.price?.finalPrice ?? 0) <= 0) r.push('주문불가-가격');
  return { ok: r.length === 0, reasons: r };
};
```

> [동작분석 §4 사유코드] 4종 그대로. 면별 입력 이원화(표지=editor, 내지=pdf) 반영.

---

## 6. 상태머신 status 전이

[동작분석 state-machine §1] `status` 필드로 표현. 전이는 action 내부에서:
`idle → loading`(loadProduct) `→ ready`(product 적재) `→ pricing`(schedulePriceQuote 발사) `→ ready`(price 200) `→ designing`(openEditor) `→ ready`(goto-cart/close) `→ submitting`(cartHandoff).

---

## 7. OPEN

- 가격 캐시 무효화 정책 상세 → price-engine.md §3.
- 부자재(ACC) 라이브 미구동 — order slice로 흡수 가정, 후니 ACC 상품 확정 시 검증 [역공학 미검증].
