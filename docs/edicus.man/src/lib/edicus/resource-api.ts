// Edicus Resource API 클라이언트
// 서버 사이드 전용 - EDICUS_RESOURCE_HOST 기반 템플릿/상품 조회
// @MX:ANCHOR: 리소스 API 클라이언트 공개 팩토리 - 상품/템플릿 관련 API Routes에서 호출
// @MX:REASON: queryTemplates, getProductList가 templates/products 라우트 핸들러에서 참조됨
import { validateEnv } from './env';
import type { EdicusTemplate, EdicusProduct, QueryOptions } from '@/types/edicus';

// 리소스 API 클라이언트 인터페이스
export interface ResourceApiClient {
  queryTemplates(partner: string, options?: QueryOptions): Promise<EdicusTemplate[]>;
  getProductList(partner: string): Promise<EdicusProduct[]>;
  getResource(resourceId: string): Promise<EdicusTemplate>;
}

// API 응답 오류 클래스
class EdicusResourceApiError extends Error {
  constructor(
    public readonly status: number,
    message: string,
  ) {
    super(message);
    this.name = 'EdicusResourceApiError';
  }
}

// 리소스 API 클라이언트 생성 팩토리 함수
export function createResourceApiClient(): ResourceApiClient {
  const env = validateEnv();
  const baseUrl = env.EDICUS_RESOURCE_HOST;

  // 공통 JSON 헤더
  const jsonHeaders: Record<string, string> = {
    'Content-Type': 'application/json',
  };

  // 응답을 JSON으로 파싱하고 오류를 처리하는 내부 함수
  async function handleResponse<T>(response: Response): Promise<T> {
    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      throw new EdicusResourceApiError(response.status, errorBody.error ?? `HTTP ${response.status}`);
    }
    return response.json() as Promise<T>;
  }

  return {
    // 템플릿 목록 조회 (POST /resapi/query)
    async queryTemplates(partner: string, options?: QueryOptions): Promise<EdicusTemplate[]> {
      const body: Record<string, unknown> = { partner, ...options };
      const response = await fetch(`${baseUrl}/resapi/query`, {
        method: 'POST',
        headers: jsonHeaders,
        body: JSON.stringify(body),
      });
      return handleResponse<EdicusTemplate[]>(response);
    },

    // 상품 목록 조회 (GET /resapi/product/list)
    async getProductList(partner: string): Promise<EdicusProduct[]> {
      const url = new URL(`${baseUrl}/resapi/product/list`);
      url.searchParams.set('partner', partner);

      const response = await fetch(url.toString(), {
        method: 'GET',
        headers: jsonHeaders,
      });
      return handleResponse<EdicusProduct[]>(response);
    },

    // 개별 리소스 상세 조회 (GET /resapi/resource/:id)
    async getResource(resourceId: string): Promise<EdicusTemplate> {
      const response = await fetch(`${baseUrl}/resapi/resource/${resourceId}`, {
        method: 'GET',
        headers: jsonHeaders,
      });
      return handleResponse<EdicusTemplate>(response);
    },
  };
}
