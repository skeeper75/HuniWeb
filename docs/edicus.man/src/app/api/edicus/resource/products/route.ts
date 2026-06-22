// Edicus 상품 목록 조회 API 라우트 (프록시)
// GET /api/edicus/resource/products
// Resource API의 /resapi/product/list 엔드포인트로 요청을 프록시합니다
// @MX:NOTE: 상품 목록은 파트너 코드가 없어도 조회 가능하나, 필터링 목적으로 사용할 수 있습니다
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

// 쿼리 파라미터 스키마
const ProductsQuerySchema = z.object({
  partner: z.string().optional(),
});

// 환경 변수 스키마
const ResourceEnvSchema = z.object({
  EDICUS_RESOURCE_HOST: z.string().url('EDICUS_RESOURCE_HOST는 유효한 URL이어야 합니다'),
  EDICUS_API_KEY: z.string().min(1, 'EDICUS_API_KEY는 필수입니다'),
});

// GET /api/edicus/resource/products - 상품 목록 조회
export async function GET(request: NextRequest): Promise<NextResponse> {
  // 환경 변수 유효성 검증
  const envResult = ResourceEnvSchema.safeParse(process.env);
  if (!envResult.success) {
    return NextResponse.json(
      { error: '서버 설정 오류: 리소스 API 환경 변수가 설정되지 않았습니다' },
      { status: 500 },
    );
  }

  const { EDICUS_RESOURCE_HOST, EDICUS_API_KEY } = envResult.data;

  // 쿼리 파라미터 파싱
  const { searchParams } = request.nextUrl;
  const queryResult = ProductsQuerySchema.safeParse({
    partner: searchParams.get('partner') ?? undefined,
  });

  if (!queryResult.success) {
    return NextResponse.json(
      { error: '잘못된 요청입니다', details: queryResult.error.flatten() },
      { status: 400 },
    );
  }

  try {
    // Resource API URL 구성 (파트너 파라미터 포함)
    const resourceUrl = new URL(`${EDICUS_RESOURCE_HOST}/resapi/product/list`);
    if (queryResult.data.partner) {
      resourceUrl.searchParams.set('partner', queryResult.data.partner);
    }

    // Resource API로 프록시
    const response = await fetch(resourceUrl.toString(), {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'edicus-api-key': EDICUS_API_KEY,
      },
    });

    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      return NextResponse.json(
        { error: errorBody.error ?? `상품 목록 조회 실패: HTTP ${response.status}` },
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
