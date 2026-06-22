// Edicus 인증 API 라우트
// POST /api/edicus/auth - 사용자 토큰 발급
// @MX:ANCHOR: 사용자 토큰 발급 API - EdicusEditor, useAuth 등에서 호출
// @MX:REASON: 모든 인증 요청의 진입점으로 다수의 클라이언트에서 호출됨
// @MX:NOTE: EDICUS_API_KEY는 서버 사이드에서만 처리되며 응답에 절대 포함되지 않습니다
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { createServerApiClient } from '@/lib/edicus/server-api';

// 요청 바디 스키마
const AuthRequestSchema = z.object({
  uid: z.string().min(1, 'uid는 필수입니다'),
});

// POST /api/edicus/auth - uid로 사용자 토큰 발급
export async function POST(request: NextRequest): Promise<NextResponse> {
  try {
    const body: unknown = await request.json();
    const parsed = AuthRequestSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: '잘못된 요청입니다', details: parsed.error.flatten() },
        { status: 400 },
      );
    }

    const { uid } = parsed.data;
    const client = createServerApiClient();
    const tokenResponse = await client.getToken(uid);

    return NextResponse.json(tokenResponse);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
