// Edicus 템플릿 목록 API 라우트
// GET /api/edicus/templates?partner={partner}&category={category}&page={page}&limit={limit}
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createResourceApiClient } from '@/lib/edicus/resource-api';

// 쿼리 파라미터 스키마
const TemplatesQuerySchema = z.object({
  partner: z.string().min(1, 'partner 파라미터는 필수입니다'),
  category: z.string().optional(),
  page: z.coerce.number().int().positive().optional(),
  limit: z.coerce.number().int().positive().max(100).optional(),
});

// GET /api/edicus/templates - 파트너의 템플릿 목록 조회
export async function GET(request: NextRequest): Promise<NextResponse> {
  try {
    const { searchParams } = request.nextUrl;
    const query = {
      partner: searchParams.get('partner') ?? '',
      category: searchParams.get('category') ?? undefined,
      page: searchParams.get('page') ?? undefined,
      limit: searchParams.get('limit') ?? undefined,
    };

    const parsed = TemplatesQuerySchema.safeParse(query);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { partner, ...options } = parsed.data;
    const client = createResourceApiClient();
    const templates = await client.queryTemplates(partner, options);

    return NextResponse.json(templates);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
