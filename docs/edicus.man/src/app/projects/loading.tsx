/**
 * 내 프로젝트 페이지 로딩 UI
 */
export default function ProjectsLoading() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* 헤더 스켈레톤 */}
      <div className="mb-8 flex items-center justify-between">
        <div>
          <div className="h-7 w-32 animate-pulse rounded bg-gray-200" />
          <div className="mt-2 h-4 w-48 animate-pulse rounded bg-gray-200" />
        </div>
        <div className="h-9 w-24 animate-pulse rounded-lg bg-gray-200" />
      </div>

      {/* 테이블 스켈레톤 */}
      <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
        <div className="bg-gray-50 px-6 py-3">
          <div className="flex gap-16">
            {['w-24', 'w-16', 'w-20', 'w-20', 'w-16'].map((w, i) => (
              <div key={i} className={`h-3 animate-pulse rounded bg-gray-200 ${w}`} />
            ))}
          </div>
        </div>
        <div className="divide-y divide-gray-200">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="flex items-center gap-16 px-6 py-4">
              <div className="h-4 w-48 animate-pulse rounded bg-gray-200" />
              <div className="h-5 w-16 animate-pulse rounded-full bg-gray-200" />
              <div className="h-4 w-24 animate-pulse rounded bg-gray-200" />
              <div className="h-4 w-24 animate-pulse rounded bg-gray-200" />
              <div className="ml-auto h-7 w-20 animate-pulse rounded-lg bg-gray-200" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
