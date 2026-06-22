/**
 * 편집기 페이지 로딩 UI
 */
export default function EditorLoading() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-900">
      <div className="text-center text-white">
        <svg className="mx-auto h-10 w-10 animate-spin" fill="none" viewBox="0 0 24 24" aria-hidden="true">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
        </svg>
        <p className="mt-3 text-sm">편집기를 불러오는 중...</p>
      </div>
    </div>
  );
}
