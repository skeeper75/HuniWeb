import type { Metadata } from 'next';
import { EdicusEditor } from '@/components/editor/EdicusEditor';

interface EditorPageProps {
  params: Promise<{ templateId: string }>;
  searchParams: Promise<{ projectId?: string }>;
}

export async function generateMetadata({ params }: EditorPageProps): Promise<Metadata> {
  const { templateId } = await params;
  return {
    title: `편집기 - ${decodeURIComponent(templateId)}`,
  };
}

/**
 * 편집기 페이지
 *
 * 템플릿 ID를 기반으로 Edicus 편집기를 전체화면으로 표시합니다.
 * searchParams의 projectId가 있으면 기존 프로젝트를 엽니다.
 */
export default async function EditorPage({ params, searchParams }: EditorPageProps) {
  const { templateId } = await params;
  const { projectId } = await searchParams;

  return (
    <EdicusEditor
      templateId={decodeURIComponent(templateId)}
      projectId={projectId}
    />
  );
}
