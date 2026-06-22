'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { FileText, Search, Eye, EyeOff, ExternalLink } from 'lucide-react';

// @MX:NOTE: 템플릿 목록 페이지, /api/edicus/resource/query 엔드포인트에서 데이터를 가져옴

interface Template {
  id: string;
  title: string;
  psCodes?: string[];
  visibility?: string;
  resUri?: string;
  metadata?: Record<string, unknown>;
}

/** 로딩 스켈레톤 컴포넌트 */
function TemplateSkeleton() {
  return (
    <tr className="animate-pulse">
      {[...Array(5)].map((_, i) => (
        <td key={i} className="px-4 py-3">
          <div className="h-4 bg-gray-200 rounded w-full" />
        </td>
      ))}
    </tr>
  );
}

export default function TemplatesPage() {
  const [templates, setTemplates] = useState<Template[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    const fetchTemplates = async () => {
      try {
        setLoading(true);
        const response = await fetch('/api/edicus/resource/query', {
          cache: 'no-store',
        });
        if (!response.ok) {
          throw new Error(`데이터를 불러오는데 실패했습니다. (${response.status})`);
        }
        const data: Template[] = await response.json();
        setTemplates(Array.isArray(data) ? data : []);
      } catch (err) {
        setError(err instanceof Error ? err.message : '알 수 없는 오류가 발생했습니다.');
      } finally {
        setLoading(false);
      }
    };

    void fetchTemplates();
  }, []);

  const filteredTemplates = templates.filter((t) => {
    const q = searchQuery.toLowerCase();
    return (
      t.title?.toLowerCase().includes(q) ||
      t.id?.toLowerCase().includes(q) ||
      t.psCodes?.some((code) => code.toLowerCase().includes(q))
    );
  });

  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">템플릿 관리</h1>
          <p className="mt-1 text-sm text-gray-500">인쇄 템플릿을 조회하고 관리합니다.</p>
        </div>
      </div>

      {/* 검색 입력 */}
      <div className="mb-5 relative">
        <Search
          className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400"
          aria-hidden="true"
        />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="템플릿 검색 (제목, ID, PS 코드)"
          className="w-full rounded-lg border border-gray-300 pl-9 pr-4 py-2 text-sm text-gray-900 placeholder-gray-400 focus:border-huni-primary focus:outline-none focus:ring-1 focus:ring-huni-primary max-w-md"
          aria-label="템플릿 검색"
        />
      </div>

      {/* 오류 메시지 */}
      {error && (
        <div
          role="alert"
          className="mb-5 rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700"
        >
          {error}
        </div>
      )}

      {/* 테이블 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  ID
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  제목
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  PS 코드
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  공개 여부
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  액션
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {loading ? (
                <>
                  <TemplateSkeleton />
                  <TemplateSkeleton />
                  <TemplateSkeleton />
                </>
              ) : filteredTemplates.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-4 py-12 text-center">
                    <FileText className="mx-auto h-10 w-10 text-gray-300 mb-3" aria-hidden="true" />
                    <p className="text-sm text-gray-400">
                      {searchQuery ? '검색 결과가 없습니다.' : '템플릿이 없습니다.'}
                    </p>
                  </td>
                </tr>
              ) : (
                filteredTemplates.map((template) => (
                  <tr key={template.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-mono text-xs text-gray-500 max-w-[120px] truncate">
                      {template.id}
                    </td>
                    <td className="px-4 py-3 font-medium text-gray-900">
                      {template.title || '—'}
                    </td>
                    <td className="px-4 py-3 text-gray-500">
                      {template.psCodes?.length ? (
                        <div className="flex flex-wrap gap-1">
                          {template.psCodes.map((code) => (
                            <span
                              key={code}
                              className="inline-flex items-center rounded px-1.5 py-0.5 text-xs bg-gray-100 text-gray-700"
                            >
                              {code}
                            </span>
                          ))}
                        </div>
                      ) : (
                        '—'
                      )}
                    </td>
                    <td className="px-4 py-3">
                      <span
                        className={`inline-flex items-center gap-1 text-xs font-medium ${
                          template.visibility === 'public'
                            ? 'text-green-700'
                            : 'text-gray-400'
                        }`}
                      >
                        {template.visibility === 'public' ? (
                          <Eye className="h-3.5 w-3.5" aria-hidden="true" />
                        ) : (
                          <EyeOff className="h-3.5 w-3.5" aria-hidden="true" />
                        )}
                        {template.visibility === 'public' ? '공개' : '비공개'}
                      </span>
                    </td>
                    <td className="px-4 py-3">
                      <Link
                        href={`/admin/templates/${template.id}`}
                        className="inline-flex items-center gap-1 text-xs font-medium text-huni-primary hover:text-huni-primary-dark"
                      >
                        <ExternalLink className="h-3.5 w-3.5" aria-hidden="true" />
                        상세
                      </Link>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* 결과 수 */}
      {!loading && !error && (
        <p className="mt-3 text-xs text-gray-400">
          총 {filteredTemplates.length}개 템플릿
        </p>
      )}
    </div>
  );
}
