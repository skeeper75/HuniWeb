'use client';

/**
 * useHuniEditor 훅
 *
 * HuniEditorSDK의 생명주기를 React 컴포넌트와 통합합니다.
 * 초기화, 정리, 편집기 명령 메서드를 제공합니다.
 */

// @MX:NOTE: [AUTO] HuniEditorSDK 생명주기 관리 훅 - cleanup 순서 중요
// @MX:SPEC: SPEC-PCPASSIVE-001 Phase C

import { useCallback, useEffect, useRef, useState } from 'react';
import { HuniEditorSDK } from '@/lib/edicus/huni-editor-sdk';

/**
 * useHuniEditor 훅 옵션
 */
export interface UseHuniEditorOptions {
  /** 편집기를 마운트할 컨테이너 요소의 ID */
  containerId: string;
  /** 상품 코드 */
  productId: string;
  /** 파트너 코드 */
  partnerId: string;
  /** passive 모드 활성화 여부 */
  passiveMode?: boolean;
  /** 사용자 정의 CSS */
  privateCss?: string;
}

/**
 * useHuniEditor 훅 반환 타입
 */
export interface UseHuniEditorReturn {
  /** HuniEditorSDK 인스턴스 (null이면 미초기화) */
  sdk: HuniEditorSDK | null;
  /** 편집기 준비 상태 */
  isReady: boolean;
  /** 초기화 진행 중 여부 */
  isLoading: boolean;
  /** 초기화 오류 */
  error: Error | null;
  /** 실행 취소 */
  undo: () => void;
  /** 다시 실행 */
  redo: () => void;
  /** 저장 */
  save: () => void;
  /** 편집기 닫기 */
  close: () => void;
}

/**
 * HuniEditorSDK 생명주기를 관리하는 React 훅
 *
 * @param options - 훅 설정 옵션
 * @returns 편집기 상태 및 명령 메서드
 */
export function useHuniEditor(options: UseHuniEditorOptions): UseHuniEditorReturn {
  const sdkRef = useRef<HuniEditorSDK | null>(null);
  const [isReady, setIsReady] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  // 옵션 변경에 따른 재초기화를 막기 위해 ref로 관리
  const optionsRef = useRef(options);
  useEffect(() => {
    optionsRef.current = options;
  });

  useEffect(() => {
    // SSR 환경에서는 실행하지 않음
    if (typeof window === 'undefined') return;

    const sdk = new HuniEditorSDK();
    sdkRef.current = sdk;

    // 준비 완료 이벤트 구독
    const handleReady = () => {
      setIsReady(true);
      setIsLoading(false);
    };

    sdk.on('ready', handleReady);

    // SDK 초기화
    sdk
      .init({
        containerId: optionsRef.current.containerId,
        productId: optionsRef.current.productId,
        partnerId: optionsRef.current.partnerId,
        passiveMode: optionsRef.current.passiveMode,
        privateCss: optionsRef.current.privateCss,
      })
      .catch((err: unknown) => {
        const e = err instanceof Error ? err : new Error(String(err));
        setError(e);
        setIsLoading(false);
      });

    return () => {
      // 언마운트 시 SDK 정리 (cleanup 순서 중요: 이벤트 리스너 → destroy)
      sdk.off('ready', handleReady);
      sdk.destroy();
      sdkRef.current = null;
      setIsReady(false);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const undo = useCallback(() => {
    sdkRef.current?.undo();
  }, []);

  const redo = useCallback(() => {
    sdkRef.current?.redo();
  }, []);

  const save = useCallback(() => {
    sdkRef.current?.save();
  }, []);

  const close = useCallback(() => {
    sdkRef.current?.close();
  }, []);

  return {
    sdk: sdkRef.current,
    isReady,
    isLoading,
    error,
    undo,
    redo,
    save,
    close,
  };
}
