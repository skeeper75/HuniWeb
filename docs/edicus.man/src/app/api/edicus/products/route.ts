// Edicus 상품 목록 API 라우트
// GET /api/edicus/products?partner={partner}
// @MX:ANCHOR: 상품 목록 조회 API
// @MX:REASON: 상품 검색 기능의 중심 엔드포인트로 ProductGrid 컴포넌트에서 호출됨
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createResourceApiClient } from '@/lib/edicus/resource-api';

// 쿼리 파라미터 스키마
const ProductsQuerySchema = z.object({
  partner: z.string().min(1, 'partner 파라미터는 필수입니다'),
});

// GET /api/edicus/products - 파트너의 상품 목록 조회
export async function GET(request: NextRequest): Promise<NextResponse> {
  try {
    const { searchParams } = request.nextUrl;
    const query = { partner: searchParams.get('partner') ?? '' };
    const parsed = ProductsQuerySchema.safeParse(query);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { partner } = parsed.data;
    const client = createResourceApiClient();
    const products = await client.getProductList(partner);

    return NextResponse.json(products);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
