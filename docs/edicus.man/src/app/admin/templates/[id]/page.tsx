import type { Metadata } from 'next';
import Link from 'next/link';
import { ArrowLeft, FileText } from 'lucide-react';

export const metadata: Metadata = {
  title: '템플릿 상세',
};

interface Template {
  id: string;
  title: string;
  psCodes?: string[];
  resUri?: string;
  visibility?: string;
  metadata?: Record<string, unknown>;
}

interface PageProps {
  params: Promise<{ id: string }>;
}

async function fetchTemplate(id: string): Promise<Template | null> {
  try {
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_APP_URL ?? 'http://localhost:3000'}/api/edicus/resource/${id}`,
      { cache: 'no-store' }
    );
    if (!response.ok) return null;
    return response.json() as Promise<Template>;
  } catch {
    return null;
  }
}

export default async function TemplateDetailPage({ params }: PageProps) {
  const { id } = await params;
  const template = await fetchTemplate(id);

  return (
    <div className="p-6 lg:p-8">
      {/* 뒤로가기 */}
      <div className="mb-6">
        <Link
          href="/admin/templates"
          className="inline-flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors"
        >
          <ArrowLeft className="h-4 w-4" aria-hidden="true" />
          템플릿 목록으로
        </Link>
      </div>

      {/* 페이지 헤더 */}
      <div className="mb-6 flex items-center gap-3">
        <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-huni-primary-light-3">
          <FileText className="h-5 w-5 text-huni-primary" aria-hidden="true" />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            {template?.title ?? '템플릿 상세'}
          </h1>
          <p className="text-xs font-mono text-gray-400 mt-0.5">{id}</p>
        </div>
      </div>

      {!template ? (
        <div className="rounded-xl bg-white border border-gray-200 p-10 text-center shadow-sm">
          <FileText className="mx-auto h-12 w-12 text-gray-300 mb-3" aria-hidden="true" />
          <p className="text-sm font-medium text-gray-500">템플릿을 찾을 수 없습니다.</p>
          <p className="text-xs text-gray-400 mt-1">ID: {id}</p>
        </div>
      ) : (
        <div className="space-y-5">
          {/* 기본 정보 */}
          <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
            <div className="px-5 py-4 border-b border-gray-100">
              <h2 className="text-sm font-semibold text-gray-900">기본 정보</h2>
            </div>
            <dl className="divide-y divide-gray-100">
              <div className="flex px-5 py-3">
                <dt className="w-32 shrink-0 text-xs font-medium text-gray-500">제목</dt>
                <dd className="text-sm text-gray-900">{template.title}</dd>
              </div>
              <div className="flex px-5 py-3">
                <dt className="w-32 shrink-0 text-xs font-medium text-gray-500">ID</dt>
                <dd className="text-sm font-mono text-gray-700">{template.id}</dd>
              </div>
              <div className="flex px-5 py-3">
                <dt className="w-32 shrink-0 text-xs font-medium text-gray-500">공개 여부</dt>
                <dd className="text-sm text-gray-900">
                  <span
                    className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${
                      template.visibility === 'public'
                        ? 'bg-green-100 text-green-700'
                        : 'bg-gray-100 text-gray-600'
                    }`}
                  >
                    {template.visibility === 'public' ? '공개' : '비공개'}
                  </span>
                </dd>
              </div>
              {template.resUri && (
                <div className="flex px-5 py-3">
                  <dt className="w-32 shrink-0 text-xs font-medium text-gray-500">리소스 URI</dt>
                  <dd className="text-sm font-mono text-gray-700 break-all">{template.resUri}</dd>
                </div>
              )}
            </dl>
          </div>

          {/* PS 코드 */}
          {template.psCodes && template.psCodes.length > 0 && (
            <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
              <div className="px-5 py-4 border-b border-gray-100">
                <h2 className="text-sm font-semibold text-gray-900">PS 코드</h2>
              </div>
              <div className="p-5">
                <div className="flex flex-wrap gap-2">
                  {template.psCodes.map((code) => (
                    <span
                      key={code}
                      className="inline-flex items-center rounded-lg border border-gray-200 bg-gray-50 px-3 py-1.5 text-sm font-mono text-gray-700"
                    >
                      {code}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* 메타데이터 */}
          {template.metadata && Object.keys(template.metadata).length > 0 && (
            <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
              <div className="px-5 py-4 border-b border-gray-100">
                <h2 className="text-sm font-semibold text-gray-900">메타데이터</h2>
              </div>
              <div className="p-5">
                <pre className="rounded-lg bg-gray-50 border border-gray-200 p-4 text-xs text-gray-700 overflow-auto">
                  {JSON.stringify(template.metadata, null, 2)}
                </pre>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
