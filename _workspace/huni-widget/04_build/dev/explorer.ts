// 카테고리→상품 탐색 dev 하네스. 위젯 코어 불변 — widget-loader의 공개 init API만 호출.
// 사이드바 UI/CSS는 raw/widget_monitor/local/index.html 구조를 차용(프로젝트 소유).
import { init } from '../src/widget-loader/index';
import catalog from './redprinting_catalog.json';

interface CatalogProduct {
  category: string;
  pdtCode: string;
  name: string;
  url: string;
}

// fixture-source.ts 가 Vite JSON import 하는 14종만 실제 렌더 가능(보유 판정).
const SUPPORTED: readonly string[] = [
  'PRBKYPR', 'PRPOXXX', 'BCSPDFT', 'BCSPWHT', 'BNBNFBL', 'BNPTPET',
  'GSPUFBC', 'GSTGMIC', 'HLCLSTD', 'HLCLWAL', 'ACNTHAP', 'STTHCIC',
  'STCUXXX', 'STPADPN',
];

// 카탈로그 26 카테고리 라벨(reference 부분 맵을 전 카테고리로 확장).
const CAT_LABELS: Record<string, string> = {
  AC: 'Acrylic',
  AH: 'AH',
  AI: 'AI',
  BC: 'Card',
  BN: 'Banner',
  BT: 'BT',
  CL: 'Clock',
  EN: 'Envelope',
  ET: 'ET',
  FB: 'Fabric',
  FS: 'FS',
  GS: 'Goods',
  HL: 'Holder',
  LF: 'Leaflet',
  ME: 'Memo',
  NC: 'NCR',
  OT: 'Other',
  PD: 'Pad',
  PH: 'Photo',
  PM: 'Promo',
  PO: 'Poster',
  PR: 'Book',
  PV: 'PV',
  SK: 'Sticker',
  ST: 'Stamp',
  TP: 'Tape',
};

const products = (catalog as { products: CatalogProduct[] }).products;
const supportedSet = new Set(SUPPORTED);

let activeCat = 'ALL';
let activePdt: string | null = null;
let query = '';

const $ = <T extends HTMLElement>(id: string): T => document.getElementById(id) as T;

function catLabel(cat: string): string {
  return CAT_LABELS[cat] ?? cat;
}

function visibleProducts(): CatalogProduct[] {
  const q = query.trim().toLowerCase();
  return products.filter((p) => {
    if (activeCat !== 'ALL' && p.category !== activeCat) return false;
    if (q && !(p.name.toLowerCase().includes(q) || p.pdtCode.toLowerCase().includes(q))) return false;
    return true;
  });
}

function renderCatTabs(): void {
  const counts = new Map<string, number>();
  for (const p of products) counts.set(p.category, (counts.get(p.category) ?? 0) + 1);
  const cats = [...counts.keys()].sort();
  const tabsEl = $('catTabs');
  const make = (key: string, label: string, count: number) => {
    const b = document.createElement('button');
    b.className = 'cat-tab' + (key === activeCat ? ' active' : '');
    b.innerHTML = `${label} <span style="opacity:.6">${count}</span>`;
    b.onclick = () => {
      activeCat = key;
      renderCatTabs();
      renderProductList();
    };
    return b;
  };
  tabsEl.replaceChildren(
    make('ALL', 'All', products.length),
    ...cats.map((c) => make(c, catLabel(c), counts.get(c) ?? 0)),
  );
}

function renderProductList(): void {
  const listEl = $('productList');
  const items = visibleProducts();
  listEl.replaceChildren(
    ...items.map((p) => {
      const held = supportedSet.has(p.pdtCode);
      const el = document.createElement('div');
      el.className = 'product-item' + (p.pdtCode === activePdt ? ' active' : '');
      el.innerHTML =
        `<div class="pdt-row">` +
        `<span class="pdt-code">${p.pdtCode}</span>` +
        `<span class="badge ${held ? 'badge-fixture' : 'badge-none'}">${held ? 'fixture' : '미보유'}</span>` +
        `</div>` +
        `<div class="pdt-name">${p.name}</div>` +
        `<div class="cat-badge">${catLabel(p.category)} · ${p.category}</div>`;
      el.onclick = () => selectProduct(p);
      return el;
    }),
  );
  $('filteredCount').textContent = `${items.length} / ${products.length} products`;
}

// 위젯은 init(host)에서 host에 attachShadow 한다(shadowRoot가 host에 부착).
// shadowRoot는 replaceChildren으로 제거되지 않으므로, 제품마다 새 mount div를 만들어
// #widget-host의 자식으로 넣고, 재선택 시 그 div를 통째로 교체해 이전 shadow root를 폐기한다.
function freshMountPoint(): HTMLElement {
  const host = $('widget-host');
  const mount = document.createElement('div');
  host.replaceChildren(mount);
  return mount;
}

function selectProduct(p: CatalogProduct): void {
  activePdt = p.pdtCode;
  $('activePdtLabel').textContent = `${p.pdtCode} — ${p.name}`;
  renderProductList();

  const held = supportedSet.has(p.pdtCode);
  const placeholder = $('placeholder');
  placeholder.style.display = 'none';

  if (held) {
    // fixture 보유 → 후니 위젯 마운트(공개 init API만 사용). 새 mount div = 새 shadow root.
    void init(freshMountPoint(), { productCode: p.pdtCode });
  } else {
    // 미보유 → 원본 RedPrinting 페이지 새 탭 + host 영역 안내.
    window.open(p.url, '_blank', 'noopener');
    const host = freshMountPoint();
    const note = document.createElement('div');
    note.className = 'no-fixture';
    note.innerHTML =
      `<strong>fixture 없음 · 캡처 필요</strong>` +
      `<p>${p.pdtCode} — ${p.name}</p>` +
      `<p>이 상품은 fixture(14종)에 없어 위젯 렌더 불가입니다. 원본 페이지를 새 탭으로 열었습니다.</p>` +
      `<a href="${p.url}" target="_blank" rel="noopener">${p.url}</a>`;
    host.replaceChildren(note);
  }
}

function boot(): void {
  $('searchInput').addEventListener('input', (e) => {
    query = (e.target as HTMLInputElement).value;
    renderProductList();
  });
  renderCatTabs();
  renderProductList();
}

boot();
