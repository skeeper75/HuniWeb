// component-tree §1 — WidgetRoot: Provider + 에러바운더리. 포털 컨테이너 주입(Radix-in-Shadow).
import { Component, type ErrorInfo, type ReactNode } from 'react';
import type { WidgetStore } from '../stores/widget-store';
import type { NormalizedCartHandoff } from '@/contract';
import { WidgetStoreProvider } from '../stores/context';
import { PortalContainerProvider } from '../shadow/portal-context';
import { OptionPanel } from './OptionPanel';

// 임베드 위젯 제1원칙: fail silently — 호스트 페이지를 깨뜨리지 않는다 (bp-embed-widget §1).
class ErrorBoundary extends Component<{ children: ReactNode }, { hasError: boolean }> {
  state = { hasError: false };
  static getDerivedStateFromError() {
    return { hasError: true };
  }
  componentDidCatch(error: Error, info: ErrorInfo) {
    // 호스트로 전파하지 않고 위젯 내부에서만 로깅.
    console.error('[huni-widget] 렌더 오류', error, info);
  }
  render() {
    if (this.state.hasError) {
      return (
        <div className="p-6 text-[14px] text-[#979797]">
          위젯을 표시할 수 없습니다. 잠시 후 다시 시도해 주세요.
        </div>
      );
    }
    return this.props.children;
  }
}

export interface WidgetRootProps {
  store: WidgetStore;
  portalContainer: HTMLElement | null;
  onCartHandoff?: (p: NormalizedCartHandoff) => void;
}

export function WidgetRoot({ store, portalContainer, onCartHandoff }: WidgetRootProps) {
  return (
    <ErrorBoundary>
      <WidgetStoreProvider store={store}>
        <PortalContainerProvider container={portalContainer}>
          <OptionPanel onCartHandoff={onCartHandoff} />
        </PortalContainerProvider>
      </WidgetStoreProvider>
    </ErrorBoundary>
  );
}
