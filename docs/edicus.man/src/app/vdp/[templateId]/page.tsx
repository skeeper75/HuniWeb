import type { Metadata } from 'next';
import { VdpEditor } from '@/components/editor/VdpEditor';

interface VdpPageProps {
  params: Promise<{ templateId: string }>;
}

export async function generateMetadata({ params }: VdpPageProps): Promise<Metadata> {
  const { templateId } = await params;
  return {
    title: `VDP 편집기 - ${decodeURIComponent(templateId)}`,
  };
}

/**
 * VDP 편집기 페이지
 *
 * 가변 데이터 인쇄(Variable Data Printing) 편집기를 전체화면으로 표시합니다.
 * VDP 필드는 추후 API로 동적 로드 가능합니다.
 */
export default async function VdpPage({ params }: VdpPageProps) {
  const { templateId } = await params;

  return (
    <VdpEditor
      templateId={decodeURIComponent(templateId)}
    />
  );
}
