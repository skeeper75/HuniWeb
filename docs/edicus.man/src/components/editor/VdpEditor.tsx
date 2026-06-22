'use client';

/**
 * VdpEditor 컴포넌트
 *
 * VDP(Variable Data Printing) 편집기를 렌더링합니다.
 * 가변 데이터 입력 인터페이스와 SDK VDP 기능을 통합합니다.
 */

import { useCallback, useEffect, useRef, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useEdicus } from '@/hooks/useEdicus';
import type { EdicusCallbackData } from '@/types/edicus';

interface VdpField {
  /** 필드 키 */
  key: string;
  /** 필드 레이블 */
  label: string;
  /** 필드 타입 */
  type: 'text' | 'number' | 'date';
  /** 필수 여부 */
  required?: boolean;
  /** 기본값 */
  defaultValue?: string;
}

interface VdpEditorProps {
  /** 템플릿(상품) 코드 */
  templateId: string;
  /** VDP 필드 정의 목록 */
  fields?: VdpField[];
  /** 편집기 닫기 콜백 */
  onClose?: () => void;
}

/**
 * 토큰 발급 API 호출
 */
async function fetchUserToken(): Promise<string> {
  const response = await fetch('/api/edicus/auth', { method: 'POST' });
  if (!response.ok) throw new Error('토큰 발급 실패');
  const data = (await response.json()) as { token: string };
  return data.token;
}

/**
 * VDP 편집기 컴포넌트
 *
 * 가변 데이터(이름, 날짜, 번호 등)를 입력하고 편집기에 반영합니다.
 *
 * @example
 * ```tsx
 * <VdpEditor
 *   templateId="NAME_CARD_001"
 *   fields={[
 *     { key: 'name', label: '이름', type: 'text', required: true },
 *     { key: 'phone', label: '전화번호', type: 'text' },
 *   ]}
 * />
 * ```
 */
export function VdpEditor({ templateId, fields = [], onClose }: VdpEditorProps) {
  const router = useRouter();
  const containerRef = useRef<HTMLDivElement>(null);
  const [initToken, setInitToken] = useState<string | null>(null);
  const [tokenError, setTokenError] = useState<string | null>(null);
  const [isEditorStarted, setIsEditorStarted] = useState(false);
  const [fieldValues, setFieldValues] = useState<Record<string, string>>(() =>
    Object.fromEntries(fields.map((f) => [f.key, f.defaultValue ?? ''])),
  );
  const [isApplying, setIsApplying] = useState(false);

  useEffect(() => {
    fetchUserToken()
      .then(setInitToken)
      .catch((err: unknown) => {
        const message = err instanceof Error ? err.message : '토큰 발급 중 오류';
        setTokenError(message);
      });
  }, []);

  const handleSdkEvent = useCallback(
    (_err: null, data: EdicusCallbackData) => {
      const action = data.action ?? data.type;
      if (action === 'request-user-token') {
        fetchUserToken()
          .then((token) => postToEditor('send-user-token', { token }))
          .catch(console.error);
        return;
      }
      if (action === 'close') {
        onClose?.();
        router.back();
      }
    },
    [router, onClose],
  );

  const { isReady, error, postToEditor, createProject } = useEdicus(
    containerRef as React.RefObject<HTMLElement | null>,
    {
      baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL ?? 'https://edicusbase.firebaseapp.com',
      partner: process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip',
    },
    handleSdkEvent,
  );

  useEffect(() => {
    if (!isReady || !initToken || isEditorStarted) return;
    setIsEditorStarted(true);
    createProject(initToken, templateId, `${templateId} VDP 프로젝트`);
  }, [isReady, initToken, isEditorStarted, templateId, createProject]);

  const handleFieldChange = (key: string, value: string) => {
    setFieldValues((prev) => ({ ...prev, [key]: value }));
  };

  // @MX:NOTE: VDP 데이터를 편집기에 적용합니다 (post_to_editor 사용)
  const handleApplyData = async () => {
    setIsApplying(true);
    try {
      postToEditor('set-variable-data', { variableData: fieldValues });
    } finally {
      setIsApplying(false);
    }
  };

  if (tokenError ?? error) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="rounded-xl bg-white p-8 shadow-sm text-center max-w-md">
          <p className="text-sm text-red-600">{tokenError ?? error?.message}</p>
          <button onClick={() => router.back()} className="mt-4 rounded-lg bg-huni-primary px-6 py-2 text-sm font-semibold text-white">
            돌아가기
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex h-screen bg-gray-50">
      {/* VDP 데이터 입력 사이드바 */}
      {fields.length > 0 && (
        <aside className="w-80 shrink-0 overflow-y-auto border-r border-gray-200 bg-white p-6">
          <h2 className="text-base font-semibold text-gray-900">가변 데이터 입력</h2>
          <p className="mt-1 text-xs text-gray-500">각 항목에 개인화 데이터를 입력하세요.</p>

          <div className="mt-6 space-y-4">
            {fields.map((field) => (
              <div key={field.key}>
                <label
                  htmlFor={`vdp-${field.key}`}
                  className="block text-xs font-medium text-gray-700"
                >
                  {field.label}
                  {field.required && <span className="ml-1 text-red-500">*</span>}
                </label>
                <input
                  id={`vdp-${field.key}`}
                  type={field.type === 'date' ? 'date' : field.type === 'number' ? 'number' : 'text'}
                  value={fieldValues[field.key] ?? ''}
                  onChange={(e) => handleFieldChange(field.key, e.target.value)}
                  required={field.required}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-huni-primary focus:outline-none focus:ring-1 focus:ring-huni-primary"
                />
              </div>
            ))}
          </div>

          <button
            onClick={handleApplyData}
            disabled={isApplying || !isEditorStarted}
            className="mt-6 w-full rounded-lg bg-huni-primary px-4 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark disabled:cursor-not-allowed disabled:opacity-50"
          >
            {isApplying ? '적용 중...' : '데이터 적용'}
          </button>
        </aside>
      )}

      {/* 편집기 영역 */}
      <div className="relative flex-1">
        {(!isReady || !isEditorStarted) && (
          <div className="absolute inset-0 z-10 flex items-center justify-center bg-gray-900">
            <div className="text-center text-white">
              <svg className="mx-auto h-10 w-10 animate-spin" fill="none" viewBox="0 0 24 24" aria-hidden="true">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <p className="mt-3 text-sm">VDP 편집기 로딩 중...</p>
            </div>
          </div>
        )}
        <div
          ref={containerRef}
          className="h-full w-full bg-gray-900"
          id="edicus-vdp-editor-container"
          aria-label="VDP 편집기"
        />
      </div>
    </div>
  );
}
