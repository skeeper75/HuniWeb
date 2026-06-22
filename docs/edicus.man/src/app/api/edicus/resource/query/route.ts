// Edicus 리소스 쿼리 API 라우트 (프록시)
// POST /api/edicus/resource/query
// Resource API의 /resapi/query 엔드포인트로 요청을 프록시합니다
// @MX:NOTE: EDICUS_RESOURCE_HOST는 서버 전용 환경 변수입니다
// 클라이언트에서 Resource API를 직접 호출하면 API 키가 노출됩니다
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

// 쿼리 요청 바디 스키마
// Edicus Resource API의 /resapi/query 파라미터를 검증합니다
const ResourceQuerySchema = z.object({
  option: z.object({
    type: z.string().optional(),
    visibilities: z.array(z.string()).optional(),
    order: z.string().optional(),
    limit: z.number().int().positive().max(100).optional(),
    partner: z.string().optional(),
    category: z.string().optional(),
  }).passthrough(), // 알 수 없는 필드를 허용 (Edicus API 확장성 대비)
}).passthrough();

// 환경 변수 스키마
const ResourceEnvSchema = z.object({
  EDICUS_RESOURCE_HOST: z.string().url('EDICUS_RESOURCE_HOST는 유효한 URL이어야 합니다'),
  EDICUS_API_KEY: z.string().min(1, 'EDICUS_API_KEY는 필수입니다'),
});

// POST /api/edicus/resource/query - 템플릿 쿼리
export async function POST(request: NextRequest): Promise<NextResponse> {
  // 환경 변수 유효성 검증
  const envResult = ResourceEnvSchema.safeParse(process.env);
  if (!envResult.success) {
    return NextResponse.json(
      { error: '서버 설정 오류: 리소스 API 환경 변수가 설정되지 않았습니다' },
      { status: 500 },
    );
  }

  const { EDICUS_RESOURCE_HOST, EDICUS_API_KEY } = envResult.data;

  try {
    const body: unknown = await request.json();
    const parsed = ResourceQuerySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    // Resource API로 프록시
    const response = await fetch(`${EDICUS_RESOURCE_HOST}/resapi/query`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'edicus-api-key': EDICUS_API_KEY,
      },
      body: JSON.stringify(parsed.data),
    });

    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      return NextResponse.json(
        { error: errorBody.error ?? `리소스 쿼리 실패: HTTP ${response.status}` },
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
