// React-in-Shadow-DOM 마운트 — bp-react-shadow-dom §1·2·4, shadow-dom-strategy §1·2.
import { createRoot, type Root } from 'react-dom/client';
import { createElement } from 'react';
// Vite ?inline — 컴파일된 Tailwind+:host CSS 를 문자열로 인라인.
import compiledCss from './index.css?inline';
import { WidgetRoot } from '../components/WidgetRoot';
import { createWidgetStore } from '../stores/widget-store';
import type { BffClient } from '@/bff/client';
import type { NormalizedCartHandoff } from '@/contract';

// 모듈 싱글톤 시트 — 멀티 인스턴스가 동일 constructed sheet 공유 (MDN-adopted).
let sharedSheet: CSSStyleSheet | null = null;

function injectStyles(shadow: ShadowRoot) {
  if (typeof CSSStyleSheet !== 'undefined' && 'adoptedStyleSheets' in shadow) {
    if (!sharedSheet) {
      sharedSheet = new CSSStyleSheet();
      sharedSheet.replaceSync(compiledCss);
    }
    shadow.adoptedStyleSheets = [sharedSheet];
  } else {
    // @MX:NOTE 폴백 1단계 (O9) — adoptedStyleSheets 미지원 구형 브라우저. <style> 주입.
    const style = document.createElement('style');
    style.textContent = compiledCss;
    shadow.appendChild(style);
  }
}

function ensureFont() {
  // 폰트는 본질적 전역 리소스 → document.head 에 1회 등록 (shadow-dom-strategy §3).
  if (document.getElementById('huni-noto-sans')) return;
  const link = document.createElement('link');
  link.id = 'huni-noto-sans';
  link.rel = 'stylesheet';
  link.href =
    'https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600&display=swap';
  document.head.appendChild(link);
}

export interface MountOptions {
  productCode: string;
  bff: BffClient;
  locale?: string;
  deviceType?: 'pc' | 'mobile';
  memberTier?: string;
  onCartHandoff?: (p: NormalizedCartHandoff) => void;
  onPriceChange?: (p: import('@/contract').NormalizedPriceBreakdown) => void;
}

export interface MountedWidget {
  unmount(): void;
}

export function mountWidget(host: HTMLElement, opts: MountOptions): MountedWidget {
  ensureFont();
  const shadow = host.shadowRoot ?? host.attachShadow({ mode: 'open' }); // open — Red 정합·디버깅
  injectStyles(shadow);

  const mountPoint = document.createElement('div');
  mountPoint.id = 'huni-widget-root';
  shadow.appendChild(mountPoint);

  const store = createWidgetStore({
    bff: opts.bff,
    productCode: opts.productCode,
    locale: opts.locale,
    deviceType: opts.deviceType,
    memberTier: opts.memberTier,
    onPriceChange: opts.onPriceChange,
  });

  const root: Root = createRoot(mountPoint);
  root.render(
    createElement(WidgetRoot, {
      store,
      // [CRITICAL] Radix Portal container = Shadow 내부 노드. 미지정 시 전 UI 스타일 붕괴.
      portalContainer: mountPoint,
      onCartHandoff: opts.onCartHandoff,
    }),
  );

  return {
    unmount() {
      root.unmount();
      if (mountPoint.parentNode) mountPoint.parentNode.removeChild(mountPoint);
    },
  };
}
