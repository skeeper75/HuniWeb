// state-management §0·3 — store 인스턴스를 React Context 로 위젯 트리에 주입(전역 싱글톤 금지).
import { createContext, useContext, useRef, type ReactNode } from 'react';
import { useStore } from 'zustand';
// D3: useStore(api, selector, equalityFn) 3-인자 형태는 zustand v4 에서 deprecated.
// 동일 의미의 useStoreWithEqualityFn 으로 교체해 콘솔 경고 제거(동작 동일).
import { useStoreWithEqualityFn } from 'zustand/traditional';
import { shallow } from 'zustand/shallow';
import type { WidgetState, WidgetStore } from './widget-store';
import { selectCanOrder } from './widget-store';
import type { OptionValue } from '@/contract';

const StoreContext = createContext<WidgetStore | null>(null);

export function WidgetStoreProvider({
  store,
  children,
}: {
  store: WidgetStore;
  children: ReactNode;
}) {
  const ref = useRef(store);
  return <StoreContext.Provider value={ref.current}>{children}</StoreContext.Provider>;
}

function useWidgetStoreApi(): WidgetStore {
  const s = useContext(StoreContext);
  if (!s) throw new Error('WidgetStoreProvider 밖에서 store 훅 사용');
  return s;
}

export function useWidgetSelector<T>(selector: (s: WidgetState) => T): T {
  return useStore(useWidgetStoreApi(), selector);
}

// 셀렉터 훅 — state-management §2 (구독 최소화)
export function useStatus() {
  return useWidgetSelector((s) => s.status);
}

export function useProduct() {
  return useWidgetSelector((s) => s.product);
}

export function usePrice() {
  return useWidgetSelector((s) => s.price);
}

export function useOptionSelection(groupId: string) {
  const api = useWidgetStoreApi();
  const value = useStore(api, (s) => s.selections[groupId]);
  return {
    value,
    set: (v: string | string[]) => api.getState().selectOption(groupId, v),
  };
}

export function useGroupValues(groupId: string): OptionValue[] | undefined {
  return useStoreWithEqualityFn(
    useWidgetStoreApi(),
    (s) => s.product?.optionGroups.find((g) => g.id === groupId)?.values,
    shallow,
  );
}

export function useCanOrder() {
  return useWidgetSelector(selectCanOrder);
}

export function useQuantity() {
  const api = useWidgetStoreApi();
  return {
    quantity: useStore(api, (s) => s.quantity),
    setQuantity: (n: number) => api.getState().setQuantity(n),
  };
}

export function usePageCount() {
  const api = useWidgetStoreApi();
  return {
    pageCount: useStore(api, (s) => s.pageCount),
    setPageCount: (n: number) => api.getState().setPageCount(n),
  };
}

// 에디터 세션(오버레이 렌더용) — editor-integration §1·3.
export function useEditorSession() {
  const api = useWidgetStoreApi();
  return {
    config: useStore(api, (s) => s.editorConfig),
    side: useStore(api, (s) => s.editorSide),
    openEditor: (side: import('@/contract').SideKey) => api.getState().openEditor(side),
    applyEditorResult: (r: import('@/contract').NormalizedEditorResult) =>
      api.getState().applyEditorResult(r),
    closeEditor: () => api.getState().closeEditor(),
    // G-2: 에디터 가격연동 콜백 배선용 — 면수변경/변수변경 시 재계산, 토큰갱신.
    setPageCount: (n: number) => api.getState().setPageCount(n),
    reQuote: () => api.getState().schedulePriceQuote(),
    refreshEditorToken: (side: import('@/contract').SideKey) => api.getState().refreshEditorToken(side),
  };
}

// 면별 업로드/입력 상태 — PdfUploader / 에디터 버튼이 사용.
export function useSideInput(side: import('@/contract').SideKey) {
  const api = useWidgetStoreApi();
  return {
    artifact: useStore(api, (s) => s.artifacts[side]),
    uploading: useStore(api, (s) => s.uploadingSide === side),
    uploadPdf: (file: File) => api.getState().uploadPdf(side, file),
  };
}
