// state-management §0·3 — store 인스턴스를 React Context 로 위젯 트리에 주입(전역 싱글톤 금지).
import { createContext, useContext, useRef, type ReactNode } from 'react';
import { useStore } from 'zustand';
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
  return useStore(
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
