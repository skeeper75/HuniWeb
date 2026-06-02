// EditorOverlay — Edicus 에디터 iframe 을 Shadow Root 내부에 띄우는 오버레이.
// [HARD] 포털 컨테이너 = Shadow 내부 노드(portal-context) → 호스트 격리 유지(editor-integration §1·5).
// [HARD] EditorBridge 가 origin 검증(allowlist) 후에만 from-edicus 처리.
import { useEffect, useRef } from 'react';
import { createPortal } from 'react-dom';
import { usePortalContainer } from '../shadow/portal-context';
import { useEditorSession } from '../stores/context';
import { EditorBridge } from './editor-bridge';

// 운영 폴백 — 실 값은 .env.local(VITE_EDICUS_*). 코드 하드코딩 금지 원칙상 폴백만 둔다.
const EDITOR_HOST =
  import.meta.env.VITE_EDICUS_EDITOR_HOST ?? 'https://edicusbase.firebaseapp.com';
const BASE_ORIGIN = import.meta.env.VITE_EDICUS_BASE_HOST ?? 'https://edicusbase.firebaseapp.com';

export function EditorOverlay() {
  const container = usePortalContainer();
  const { config, applyEditorResult, closeEditor } = useEditorSession();
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const bridgeRef = useRef<EditorBridge | null>(null);

  useEffect(() => {
    if (!config || !iframeRef.current) return;
    // 인스턴스별 브리지 — origin 검증 + e.source 라우팅(멀티 인스턴스 안전).
    const bridge = new EditorBridge(
      config,
      {
        // request-prod-info 응답에 실어 보낼 deferred 파라미터(불투명). 자재 등은 어댑터/BFF 가 채운 config 기반.
        buildProdInfo: () => ({ ps_code: config.psCode, ...(config.pluginCustomData ?? {}) }),
        onProjectId: () => {
          // project-id-created — 중간 상태. goto-cart 에서 최종 반영하므로 본 패스는 무동작(라이프사이클 추적용).
        },
        onResult: (r) => applyEditorResult(r),
        onClose: () => closeEditor(),
      },
      { allowedOrigins: [BASE_ORIGIN, EDITOR_HOST] },
    );
    // iframe src 조립(토큰 즉시 전달, 보관 안 함) 후 마운트.
    iframeRef.current.src = bridge.buildIframeSrc(EDITOR_HOST);
    bridge.attach(iframeRef.current);
    bridgeRef.current = bridge;
    return () => {
      bridge.detach();
      bridgeRef.current = null;
    };
  }, [config, applyEditorResult, closeEditor]);

  if (!config || !container) return null;

  // Shadow 내부 컨테이너로 포털 — 호스트 body 로 escape 금지(격리).
  return createPortal(
    <div
      className="fixed inset-0 z-[1000] flex flex-col bg-black/50"
      role="dialog"
      aria-modal="true"
      aria-label="디자인 편집기"
    >
      <div className="flex items-center justify-between bg-white px-4 py-2">
        <span className="text-[14px] font-semibold text-[#424242]">디자인 편집</span>
        <button
          type="button"
          onClick={closeEditor}
          aria-label="편집기 닫기"
          className="px-3 py-1 text-[14px] text-[#553886]"
        >
          닫기
        </button>
      </div>
      <iframe
        ref={iframeRef}
        title="Edicus 편집기"
        className="h-full w-full border-0 bg-white"
        // @MX:NOTE [O3] Edicus sandbox allow-set 미확정 — 운영 위젯의 정확한 sandbox 속성 미캡처.
        // postMessage 핸드셰이크에 필요한 최소(scripts/same-origin/forms/popups)로 잠정. 빌드타임 검증 필요.
        sandbox="allow-scripts allow-same-origin allow-forms allow-popups"
      />
    </div>,
    container,
  );
}
