// 얇은 로더 — bp-embed-widget §3: 단일 script-tag + data-* / init(), Custom Element.
// 메인 런타임은 동적 import(청크 분리). 모든 구간 try/catch (fail silently — 호스트 보호).
import type { CreateWidgetOptions } from '../widget/entry';
import type { MountedWidget } from '../widget/shadow/mount';

const instances = new WeakMap<HTMLElement, MountedWidget>();

async function loadRuntime() {
  // @MX:NOTE 빌드 시 widget.js 청크로 분리됨. 로더는 이 청크만 lazy fetch.
  return import('../widget/entry');
}

async function mount(host: HTMLElement, opts: CreateWidgetOptions) {
  try {
    const { createWidgetRoot } = await loadRuntime();
    const w = createWidgetRoot(host, opts);
    instances.set(host, w);
  } catch (e) {
    // 위젯 내부 오류가 호스트 페이지로 전파되지 않게 한다.
    console.error('[huni-widget loader] mount 실패', e);
  }
}

// Custom Element — 호스트 어디든 <huni-widget pdt="PRBKYPR"> 로 삽입.
class HuniWidgetElement extends HTMLElement {
  connectedCallback() {
    const productCode = this.getAttribute('pdt') ?? this.getAttribute('data-pdt-cod') ?? '';
    if (!productCode) {
      console.error('[huni-widget] pdt 속성 필요');
      return;
    }
    void mount(this, {
      productCode,
      locale: this.getAttribute('data-locale') ?? 'ko',
      deviceType: (this.getAttribute('data-device') as 'pc' | 'mobile') ?? 'pc',
    });
  }
  disconnectedCallback() {
    instances.get(this)?.unmount();
    instances.delete(this);
  }
}

if (typeof customElements !== 'undefined' && !customElements.get('huni-widget')) {
  customElements.define('huni-widget', HuniWidgetElement);
}

// 명시적 init() API — 호스트가 위치/콜백 제어 (data-* 자동 마운트는 폴백).
export function init(host: HTMLElement, opts: CreateWidgetOptions): Promise<void> {
  return mount(host, opts);
}

// data-* 자동 마운트: document.currentScript 의 설정으로 단순 임베드 지원.
function autoMountFromScript() {
  try {
    const script = document.currentScript as HTMLScriptElement | null;
    const rootId = script?.dataset.rootId;
    const pdt = script?.dataset.pdtCod;
    if (rootId && pdt) {
      const host = document.getElementById(rootId);
      if (host)
        void mount(host, {
          productCode: pdt,
          locale: script?.dataset.locale ?? 'ko',
        });
    }
  } catch (e) {
    console.error('[huni-widget loader] auto-mount 실패', e);
  }
}

autoMountFromScript();

export type { CreateWidgetOptions };
