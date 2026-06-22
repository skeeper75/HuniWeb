// Edicus 리소스 상세 조회 API 라우트 (프록시)
// GET /api/edicus/resource/[id]
// Resource API의 /resapi/resource/:id 엔드포인트로 요청을 프록시합니다
// @MX:NOTE: 리소스 ID를 경로 파라미터로 받아 Resource API에 전달합니다
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

// 경로 파라미터 스키마
const RouteParamsSchema = z.object({
  id: z.string().min(1, '리소스 ID는 필수입니다'),
});

// 환경 변수 스키마
const ResourceEnvSchema = z.object({
  EDICUS_RESOURCE_HOST: z.string().url('EDICUS_RESOURCE_HOST는 유효한 URL이어야 합니다'),
  EDICUS_API_KEY: z.string().min(1, 'EDICUS_API_KEY는 필수입니다'),
});

// GET /api/edicus/resource/[id] - 템플릿 상세 조회
export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> },
): Promise<NextResponse> {
  // 환경 변수 유효성 검증
  const envResult = ResourceEnvSchema.safeParse(process.env);
  if (!envResult.success) {
    return NextResponse.json(
      { error: '서버 설정 오류: 리소스 API 환경 변수가 설정되지 않았습니다' },
      { status: 500 },
    );
  }

  const { EDICUS_RESOURCE_HOST, EDICUS_API_KEY } = envResult.data;

  // Next.js 15 App Router에서 params는 Promise 타입
  const resolvedParams = await params;
  const paramsResult = RouteParamsSchema.safeParse(resolvedParams);

  if (!paramsResult.success) {
    return NextResponse.json(
      { error: '잘못된 요청입니다: 리소스 ID가 필요합니다' },
      { status: 400 },
    );
  }

  const { id } = paramsResult.data;

  try {
    // Resource API로 프록시
    const response = await fetch(`${EDICUS_RESOURCE_HOST}/resapi/resource/${id}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'edicus-api-key': EDICUS_API_KEY,
      },
    });

    if (!response.ok) {
      if (response.status === 404) {
        return NextResponse.json(
          { error: `리소스를 찾을 수 없습니다: ${id}` },
          { status: 404 },
        );
      }
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      return NextResponse.json(
        { error: errorBody.error ?? `리소스 조회 실패: HTTP ${response.status}` },
        { status: response.status },
      );
    }

    const data: unknown = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
