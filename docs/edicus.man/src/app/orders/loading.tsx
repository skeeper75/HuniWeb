/**
 * 주문 내역 페이지 로딩 UI
 */
export default function OrdersLoading() {
  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* 헤더 스켈레톤 */}
      <div className="mb-8">
        <div className="h-7 w-24 animate-pulse rounded bg-gray-200" />
        <div className="mt-2 h-4 w-56 animate-pulse rounded bg-gray-200" />
      </div>

      {/* 주문 카드 스켈레톤 */}
      <div className="space-y-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <div className="flex items-start justify-between">
              <div className="flex-1 space-y-3">
                <div className="flex items-center gap-3">
                  <div className="h-5 w-16 animate-pulse rounded-full bg-gray-200" />
                  <div className="h-4 w-20 animate-pulse rounded bg-gray-200" />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1">
                    <div className="h-3 w-16 animate-pulse rounded bg-gray-200" />
                    <div className="h-4 w-48 animate-pulse rounded bg-gray-200" />
                  </div>
                  <div className="space-y-1">
                    <div className="h-3 w-20 animate-pulse rounded bg-gray-200" />
                    <div className="h-4 w-40 animate-pulse rounded bg-gray-200" />
                  </div>
                  <div className="space-y-1">
                    <div className="h-3 w-14 animate-pulse rounded bg-gray-200" />
                    <div className="h-4 w-32 animate-pulse rounded bg-gray-200" />
                  </div>
                  <div className="space-y-1">
                    <div className="h-3 w-18 animate-pulse rounded bg-gray-200" />
                    <div className="h-4 w-32 animate-pulse rounded bg-gray-200" />
                  </div>
                </div>
              </div>
              <div className="ml-4 flex flex-col gap-2">
                <div className="h-9 w-24 animate-pulse rounded-lg bg-gray-200" />
                <div className="h-9 w-24 animate-pulse rounded-lg bg-gray-200" />
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
