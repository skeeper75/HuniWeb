// 커스텀 CSS API 라우트
// GET /api/edicus/css?partner={partner} - 파트너 CSS 조회
// POST /api/edicus/css - 커스텀 CSS 저장 (향후 DB 연동 예정)
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getCssForPartner } from '@/lib/edicus/custom-css';

// GET 쿼리 파라미터 스키마
const GetCssQuerySchema = z.object({
  partner: z.string().min(1, 'partner 파라미터는 필수입니다'),
});

// POST 요청 바디 스키마
const SaveCssBodySchema = z.object({
  partner: z.string().min(1),
  css: z.string(),
});

/**
 * GET /api/edicus/css?partner=hunip
 * 파트너에 맞는 CSS 문자열을 반환합니다.
 */
export async function GET(request: NextRequest): Promise<NextResponse> {
  const { searchParams } = request.nextUrl;
  const query = { partner: searchParams.get('partner') ?? '' };
  const parsed = GetCssQuerySchema.safeParse(query);

  if (!parsed.success) {
    return NextResponse.json(
      { error: '잘못된 요청입니다', details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  const css = getCssForPartner(parsed.data.partner);
  return NextResponse.json({ css });
}

/**
 * POST /api/edicus/css
 * 커스텀 CSS를 저장합니다.
 *
 * @MX:TODO: 현재는 메모리 저장만 지원합니다. DB 저장 기능이 추가되어야 합니다.
 */
export async function POST(request: NextRequest): Promise<NextResponse> {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: '잘못된 요청 형식입니다' }, { status: 400 });
  }

  const parsed = SaveCssBodySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: '잘못된 요청입니다', details: parsed.error.flatten() },
      { status: 400 },
    );
  }

  // TODO: DB 저장 로직 추가 예정
  // 현재는 성공 응답만 반환
  return NextResponse.json({ css: parsed.data.css, success: true });
}
