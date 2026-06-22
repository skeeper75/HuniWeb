// 환경 변수 유효성 검증 (Zod 기반)
// 서버 사이드에서만 호출해야 합니다
import { z } from 'zod';

// @MX:ANCHOR: 환경 변수 스키마 - 전체 앱에서 참조하는 공개 API 경계
// @MX:REASON: validateEnv()와 getPublicConfig()는 다수의 서버/클라이언트 모듈에서 호출됨
const envSchema = z.object({
  // 서버 전용 시크릿 (클라이언트에 절대 노출 금지)
  EDICUS_API_KEY: z.string().min(1, 'EDICUS_API_KEY is required'),

  // Edicus 서버 API 호스트 (api-dot-edicusbase.appspot.com)
  EDICUS_API_HOST: z.string().url('EDICUS_API_HOST must be a valid URL'),

  // Edicus 리소스 API 호스트 (resource-dot-edicusbase.appspot.com)
  EDICUS_RESOURCE_HOST: z.string().url('EDICUS_RESOURCE_HOST must be a valid URL'),

  // 클라이언트 공개 변수 (NEXT_PUBLIC_ 접두사)
  NEXT_PUBLIC_EDICUS_PARTNER: z.string().min(1, 'NEXT_PUBLIC_EDICUS_PARTNER is required'),
  NEXT_PUBLIC_EDICUS_BASE_URL: z.string().url('NEXT_PUBLIC_EDICUS_BASE_URL must be a valid URL'),
});

// 환경 변수 타입
export type EnvConfig = z.infer<typeof envSchema>;

// 서버 사이드 전용: 전체 환경 변수 유효성 검증 후 반환
// Next.js API Routes, Server Actions, Server Components에서만 호출
export function validateEnv(): EnvConfig {
  const result = envSchema.safeParse(process.env);

  if (!result.success) {
    // 개발 환경에서 누락된 변수 목록을 명확히 표시
    const missing = result.error.issues
      .map((issue) => issue.path.join('.'))
      .join(', ');
    throw new Error(`환경 변수 검증 실패: ${missing}`);
  }

  return result.data;
}

// 클라이언트 공개 설정 반환 (NEXT_PUBLIC_ 변수만 포함)
// 클라이언트 컴포넌트에서 안전하게 사용 가능
export function getPublicConfig() {
  return {
    // 파트너 코드 (예: hunip)
    partner: process.env.NEXT_PUBLIC_EDICUS_PARTNER!,
    // 편집기 베이스 URL
    baseUrl: process.env.NEXT_PUBLIC_EDICUS_BASE_URL!,
  };
}

// 공개 설정 타입
export type PublicConfig = ReturnType<typeof getPublicConfig>;
