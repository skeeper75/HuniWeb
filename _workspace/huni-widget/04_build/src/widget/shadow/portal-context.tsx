// [CRITICAL — bp-react-shadow-dom §5 "최대 함정"] shadcn/Radix Dialog/Select/Popover/Tooltip 는
// React Portal 로 document.body 에 렌더 → Shadow 밖이라 adopted Tailwind 미적용(스타일 붕괴).
// 따라서 Portal container 를 Shadow Root 내부 노드로 지정해야 한다. 이 Context 가 그 노드를 운반한다.
import { createContext, useContext, type ReactNode } from 'react';

const PortalContext = createContext<HTMLElement | null>(null);

export function PortalContainerProvider({
  container,
  children,
}: {
  container: HTMLElement | null;
  children: ReactNode;
}) {
  return <PortalContext.Provider value={container}>{children}</PortalContext.Provider>;
}

// Radix Portal container prop 에 주입할 노드. null 이면 Radix 기본(document.body)로 폴백되나,
// Shadow DOM 에서는 반드시 non-null 이어야 스타일이 적용된다.
export function usePortalContainer(): HTMLElement | undefined {
  return useContext(PortalContext) ?? undefined;
}
