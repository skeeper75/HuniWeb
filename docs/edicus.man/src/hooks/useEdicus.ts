'use client';

/**
 * useEdicus 훅
 *
 * EdicusClient의 생명주기를 React 컴포넌트와 통합합니다.
 * SDK 초기화, 정리, 프로젝트 생성/열기 메서드를 제공합니다.
 */

import { useCallback, useEffect, useRef, useState } from 'react';
import { EdicusClient, type EdicusClientConfig } from '@/lib/edicus/client';
import type { EdicusCallback, EdicusCallbackData } from '@/types/edicus';

/** useEdicus 반환 타입 */
export interface UseEdicusReturn {
  /** SDK가 준비된 상태인지 여부 */
  isReady: boolean;
  /** 초기화 오류 */
  error: Error | null;
  /** EdicusClient 인스턴스 (null이면 미초기화) */
  client: EdicusClient | null;
  /**
   * 새 프로젝트를 생성하고 편집기를 엽니다.
   * containerRef.current를 parent_element로 사용합니다.
   */
  createProject: (
    token: string,
    psCode: string,
    title: string,
    extraParams?: Record<string, unknown>,
  ) => void;
  /**
   * 기존 프로젝트를 열어 편집기에 로드합니다.
   * containerRef.current를 parent_element로 사용합니다.
   */
  openProject: (token: string, prjid: string, extraParams?: Record<string, unknown>) => void;
  /**
   * 편집기를 닫습니다.
   */
  closeEditor: () => void;
  /**
   * postMessage를 편집기에 전송합니다.
   */
  postToEditor: (action: string, info: unknown) => void;
}

/**
 * Edicus SDK 생명주기를 관리하는 훅
 *
 * @MX:NOTE: SDK 초기화, 정리, 콜백 처리를 React 생명주기와 통합
 *
 * @param containerRef - 편집기를 마운트할 DOM 컨테이너 ref
 * @param config - EdicusClient 설정
 * @param onEvent - SDK 이벤트 콜백 (request-user-token, close, goto-cart 등)
 *
 * @example
 * ```tsx
 * const containerRef = useRef<HTMLDivElement>(null);
 * const { isReady, createProject } = useEdicus(containerRef, {
 *   baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL!,
 *   partner: process.env.NEXT_PUBLIC_EDICUS_PARTNER!,
 * });
 * ```
 */
export function useEdicus(
  containerRef: React.RefObject<HTMLElement | null>,
  config: EdicusClientConfig,
  onEvent?: EdicusCallback,
): UseEdicusReturn {
  const [isReady, setIsReady] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const clientRef = useRef<EdicusClient | null>(null);

  // 설정 변경 시 클라이언트 재생성을 막기 위해 ref로 관리
  const configRef = useRef(config);
  const onEventRef = useRef(onEvent);
  useEffect(() => {
    configRef.current = config;
    onEventRef.current = onEvent;
  });

  useEffect(() => {
    // SSR 환경에서는 실행하지 않음
    if (typeof window === 'undefined') return;

    const client = new EdicusClient(configRef.current);
    clientRef.current = client;

    client
      .init()
      .then(() => {
        setIsReady(true);
        setError(null);
      })
      .catch((err: unknown) => {
        const e = err instanceof Error ? err : new Error(String(err));
        setError(e);
        setIsReady(false);
      });

    return () => {
      // 컴포넌트 언마운트 시 편집기 정리
      if (clientRef.current?.isReady() && containerRef.current) {
        try {
          clientRef.current.destroy(containerRef.current);
        } catch {
          // 이미 제거된 경우 무시
        }
      }
      clientRef.current = null;
      setIsReady(false);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // @MX:NOTE: SDK 콜백은 편집기 이벤트(request-user-token, close, goto-cart)를 처리합니다
  const createProject = useCallback(
    (
      token: string,
      psCode: string,
      title: string,
      extraParams?: Record<string, unknown>,
    ) => {
      if (!clientRef.current || !containerRef.current) return;

      const callback: EdicusCallback = (err, data: EdicusCallbackData) => {
        onEventRef.current?.(err, data);
      };

      clientRef.current.createProject(
        {
          token,
          ps_code: psCode,
          title,
          parent_element: containerRef.current,
          ...(extraParams as Record<string, unknown>),
        } as Parameters<EdicusClient['createProject']>[0],
        callback,
      );
    },
    [containerRef],
  );

  const openProject = useCallback(
    (token: string, prjid: string, extraParams?: Record<string, unknown>) => {
      if (!clientRef.current || !containerRef.current) return;

      const callback: EdicusCallback = (err, data: EdicusCallbackData) => {
        onEventRef.current?.(err, data);
      };

      clientRef.current.openProject(
        {
          token,
          prjid,
          parent_element: containerRef.current,
          ...(extraParams as Record<string, unknown>),
        } as Parameters<EdicusClient['openProject']>[0],
        callback,
      );
    },
    [containerRef],
  );

  const closeEditor = useCallback(() => {
    if (!clientRef.current || !containerRef.current) return;
    clientRef.current.close(containerRef.current);
  }, [containerRef]);

  const postToEditor = useCallback((action: string, info: unknown) => {
    if (!clientRef.current) return;
    clientRef.current.postToEditor(action, info);
  }, []);

  return {
    isReady,
    error,
    client: clientRef.current,
    createProject,
    openProject,
    closeEditor,
    postToEditor,
  };
}
