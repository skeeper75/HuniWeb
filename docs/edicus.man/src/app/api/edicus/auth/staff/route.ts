// Edicus 스태프 토큰 발급 API 라우트
// POST /api/edicus/auth/staff
// 서버에 저장된 스태프 자격증명으로 Edicus 스태프 토큰을 발급합니다
// @MX:NOTE: EDICUS_STAFF_EMAIL, EDICUS_STAFF_PASSWORD는 서버 전용 환경 변수입니다
// 클라이언트에 절대 노출하지 마십시오
import { NextResponse } from 'next/server';
import { z } from 'zod';

// 스태프 자격증명 환경 변수 스키마
const StaffEnvSchema = z.object({
  EDICUS_API_HOST: z.string().url('EDICUS_API_HOST는 유효한 URL이어야 합니다'),
  EDICUS_STAFF_EMAIL: z.string().email('EDICUS_STAFF_EMAIL은 유효한 이메일이어야 합니다'),
  EDICUS_STAFF_PASSWORD: z.string().min(1, 'EDICUS_STAFF_PASSWORD는 필수입니다'),
});

// POST /api/edicus/auth/staff - 스태프 토큰 발급
export async function POST(): Promise<NextResponse> {
  // 환경 변수 유효성 검증
  const envResult = StaffEnvSchema.safeParse(process.env);
  if (!envResult.success) {
    const missing = envResult.error.issues.map((i) => i.path.join('.')).join(', ');
    console.error('스태프 인증 환경 변수 누락:', missing);
    return NextResponse.json(
      { error: '서버 설정 오류: 스태프 자격증명이 설정되지 않았습니다' },
      { status: 500 },
    );
  }

  const { EDICUS_API_HOST, EDICUS_STAFF_EMAIL, EDICUS_STAFF_PASSWORD } = envResult.data;

  try {
    // Edicus 서버 API에 스태프 토큰 요청
    // 헤더: edicus-email, edicus-pwd
    const response = await fetch(`${EDICUS_API_HOST}/api/auth/staff/token`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'edicus-email': EDICUS_STAFF_EMAIL,
        'edicus-pwd': EDICUS_STAFF_PASSWORD,
      },
    });

    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      return NextResponse.json(
        { error: errorBody.error ?? `스태프 토큰 발급 실패: HTTP ${response.status}` },
        { status: response.status },
      );
    }

    const tokenData = await response.json() as { token: string };
    return NextResponse.json(tokenData);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Internal Server Error';
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
