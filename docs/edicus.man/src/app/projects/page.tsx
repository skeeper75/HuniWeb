import type { Metadata } from 'next';
import Link from 'next/link';
import { OrderStatusBadge } from '@/components/orders/OrderStatusBadge';
import type { EdicusProject, ProjectStatus } from '@/types/edicus';

export const metadata: Metadata = {
  title: '내 프로젝트',
};

// @MX:ANCHOR: [AUTO] 프로젝트 목록 서버 데이터 페치 함수 (RSC 전용)
// @MX:REASON: ProductGrid, ProjectsPage 등 여러 RSC에서 참조하는 서버 데이터 접근 경계
async function fetchProjects(): Promise<EdicusProject[]> {
  const baseUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'http://localhost:3000';
  const response = await fetch(`${baseUrl}/api/edicus/projects`, {
    next: { revalidate: 0 }, // 항상 최신 데이터
  });
  if (!response.ok) return [];
  const data = (await response.json()) as { projects?: EdicusProject[] };
  return data.projects ?? [];
}

/** 프로젝트 상태별 한국어 레이블 */
const STATUS_LABEL: Record<ProjectStatus, string> = {
  editing: '편집 중',
  ordering: '잠정주문',
  ordered: '확정주문',
};

/** 날짜 포맷 */
function formatDate(iso: string): string {
  return new Date(iso).toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
}

/**
 * 내 프로젝트 페이지
 *
 * 사용자의 모든 프로젝트 목록을 표시합니다.
 * 각 프로젝트에서 편집 재개, 주문하기 액션을 제공합니다.
 */
export default async function ProjectsPage() {
  const projects = await fetchProjects();

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* 페이지 헤더 */}
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">내 프로젝트</h1>
          <p className="mt-1 text-sm text-gray-500">
            저장된 디자인 프로젝트를 관리합니다.
          </p>
        </div>
        <Link
          href="/"
          className="rounded-lg bg-huni-primary px-4 py-2 text-sm font-semibold text-white hover:bg-huni-primary-dark"
        >
          새 프로젝트
        </Link>
      </div>

      {/* 프로젝트 목록 */}
      {projects.length === 0 ? (
        <EmptyState />
      ) : (
        <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  프로젝트 ID
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  상태
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  생성일
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-gray-500">
                  수정일
                </th>
                <th className="px-6 py-3 text-right text-xs font-medium uppercase tracking-wider text-gray-500">
                  액션
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {projects.map((project) => (
                <ProjectRow key={project.project_id} project={project} />
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

/** 프로젝트 테이블 행 */
function ProjectRow({ project }: { project: EdicusProject }) {
  const isEditable = project.status === 'editing';
  const isOrderable = project.status === 'editing';

  return (
    <tr className="hover:bg-gray-50">
      <td className="px-6 py-4">
        <span className="font-mono text-xs text-gray-700">{project.project_id}</span>
      </td>
      <td className="px-6 py-4">
        <OrderStatusBadge status={project.status} />
        <span className="ml-2 text-xs text-gray-500">{STATUS_LABEL[project.status]}</span>
      </td>
      <td className="px-6 py-4 text-sm text-gray-500">{formatDate(project.created_at)}</td>
      <td className="px-6 py-4 text-sm text-gray-500">{formatDate(project.updated_at)}</td>
      <td className="px-6 py-4 text-right">
        <div className="flex items-center justify-end gap-2">
          {isEditable && (
            <Link
              href={`/editor/resume?projectId=${project.project_id}`}
              className="rounded-lg bg-huni-primary px-3 py-1.5 text-xs font-semibold text-white hover:bg-huni-primary-dark"
            >
              편집 재개
            </Link>
          )}
          {isOrderable && (
            <Link
              href={`/orders/new?projectId=${project.project_id}`}
              className="rounded-lg border border-gray-300 px-3 py-1.5 text-xs font-semibold text-gray-700 hover:bg-gray-50"
            >
              주문하기
            </Link>
          )}
          {!isEditable && !isOrderable && (
            <span className="text-xs text-gray-400">—</span>
          )}
        </div>
      </td>
    </tr>
  );
}

/** 프로젝트 없음 빈 상태 */
function EmptyState() {
  return (
    <div className="rounded-xl border border-dashed border-gray-300 bg-white py-16 text-center">
      <svg
        className="mx-auto h-12 w-12 text-gray-300"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        aria-hidden="true"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          strokeWidth={1.5}
          d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"
        />
      </svg>
      <h2 className="mt-4 text-base font-semibold text-gray-900">프로젝트가 없습니다</h2>
      <p className="mt-2 text-sm text-gray-500">
        홈에서 템플릿을 선택하여 첫 번째 프로젝트를 시작하세요.
      </p>
      <Link
        href="/"
        className="mt-6 inline-block rounded-lg bg-huni-primary px-5 py-2.5 text-sm font-semibold text-white hover:bg-huni-primary-dark"
      >
        템플릿 둘러보기
      </Link>
    </div>
  );
}
