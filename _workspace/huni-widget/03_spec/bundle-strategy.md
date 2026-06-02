# bundle-strategy.md — 번들·배포·멀티 인스턴스

> 파이프라인 ③. 경량 로더 + 동적 청크 + CDN 배포 + 멀티 인스턴스.
> 근거: [역공학 §1] Red 3계층(로더 33KB / 런타임 438KB / 에디터) / [결정] Vite library mode.

---

## 1. 번들 분리 (3계층 = 3 청크)

[역공학 §1] Red 분리(브릿지/런타임/에디터)를 따름:

| 청크 | 크기 목표 | 로드 시점 | 내용 |
|------|----------|----------|------|
| `huni-widget-loader.js` | ~5KB (gzip) | 호스트 `<script>` 즉시 | Shadow Host·스타일주입·동적 import·브리지. 호스트에 영구 |
| `huni-widget-runtime.[hash].js` | ~150KB target (gzip, React 포함) | mount 시 `import()` | React+Zustand+shadcn+컴포넌트+컴파일 CSS 인라인 |
| `huni-editor-bridge.[hash].js` | ~20KB | "편집하기" 시 `import()` | Edicus SDK wrapper + postMessage. 에디터 안 쓰면 미로드 |

> [결정] 로더만 호스트에 직접 박힌다(버전 고정·안정). 런타임/에디터는 해시 파일명 → 무중단 갱신. Red 438KB 대비 React 트리쉐이킹·shadcn 부분 import로 경량화 목표(달성은 빌드 후 측정 — OPEN).

---

## 2. 빌드 (Vite library mode)

```
vite.config: build.lib { entry: { loader, runtime, 'editor-bridge' }, formats:['es'] }
- React/ReactDOM: 런타임 청크에 번들(외부 의존 강요 안 함 — 호스트 React 버전 충돌 회피)
- Tailwind CSS: 컴파일 → 런타임 청크에 ?inline 문자열 (shadow-dom-strategy §2)
- shadcn: 사용 컴포넌트만 import (트리쉐이킹)
```

> [결정] React를 external로 빼지 않고 번들 내장. 이유: 호스트 페이지의 React 유무/버전에 위젯이 결합되면 안 됨(임베드 위젯의 격리 원칙). 크기 비용 < 호환성 이득.

---

## 3. 로더 API (호스트 통합)

```html
<div id="huni-widget" data-pdt-code="PRBKYPR" data-locale="ko"></div>
<script src="https://cdn.huni.../huni-widget-loader.js" async></script>
<script>
  HuniWidget.init('#huni-widget', {
    pdtCode: 'PRBKYPR', locale: 'ko', bffUrl: '...',   // .env에서 서버 주입
  }, {
    onOptionChange, onPriceChange, onOpenEditor, onCloseEditor,   // [동작분석 event-contract §1] 라이브 4
    onUploadComplete, onValidationChange, onOrder, onReady,       // 정적 5 (권장)
  });
</script>
```

> [동작분석 event-contract §1] Red은 콜백 객체 방식. 후니도 동일 + CustomEvent 병행(`huni:*`) — 호스트가 콜백 또는 이벤트 선택. 어댑터(loader 브리지)가 양변환.

---

## 4. CDN 배포

- 정적 호스팅(CDN). `loader`는 안정 URL(버전 미포함 또는 major만). `runtime`/`editor-bridge`는 해시 파일명(불변 캐시 `max-age=1y`).
- 로더가 런타임 청크 URL을 알아야 함 → 빌드시 로더에 매니페스트(런타임 해시 URL) 인라인 또는 로더가 `manifest.json` fetch. [결정] 빌드시 인라인(네트워크 1회 절감, 단순).

---

## 5. 멀티 인스턴스 (한 페이지 N 위젯)

[결정] 전역 싱글톤 금지. 인스턴스별 격리:

| 자원 | 멀티 인스턴스 처리 |
|------|-------------------|
| Zustand store | `createWidgetStore()` 인스턴스별 생성 (state-management §0) |
| Shadow Host | 각 `data-pdt-code` div마다 별 attachShadow |
| adoptedStyleSheet | 모듈 싱글톤 시트 **공유**(읽기전용 동일 CSS — 메모리 절약, shadow-dom §2) |
| postMessage 라우팅 | editor-bridge가 `e.source` 비교로 인스턴스 식별 (editor-integration §5) |
| 폰트(document.head) | 1회만 주입(중복 가드, shadow-dom §3) |

---

## 6. OPEN

- 런타임 청크 실측 크기 — 빌드 후 측정(목표 ~150KB gzip 검증).
- 로더 매니페스트 인라인 vs fetch 최종 결정 — 빌드 파이프라인 확정 시.
- React external 여부 재검토 — 호스트가 React 앱이고 공유 원하면(현재 내장 고정).
