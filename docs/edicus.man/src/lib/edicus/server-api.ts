// Edicus 서버 API 클라이언트
// 서버 사이드 전용 - EDICUS_API_KEY를 사용하며 클라이언트에 절대 노출 금지
// @MX:ANCHOR: 서버 API 클라이언트 공개 팩토리 - API Routes 및 Server Actions에서 호출
// @MX:REASON: getToken, getProjects 등이 다수의 API 라우트 핸들러에서 참조됨
import { validateEnv } from './env';
import type { EdicusProject, TokenResponse, PreviewUrlsResponse } from '@/types/edicus';
import type { Order } from '@/types/order';

// 서버 API 클라이언트 인터페이스
export interface ServerApiClient {
  getToken(uid: string): Promise<TokenResponse>;
  getStaffToken(uid: string): Promise<TokenResponse>;
  getProjects(uid: string): Promise<EdicusProject[]>;
  getProject(projectId: string): Promise<EdicusProject>;
  deleteProject(projectId: string): Promise<void>;
  cloneProject(projectId: string): Promise<EdicusProject>;
  tentativeOrder(projectId: string): Promise<Order>;
  definitiveOrder(projectId: string): Promise<Order>;
  cancelOrder(orderId: string): Promise<void>;
  getPreviewUrls(projectId: string): Promise<string[]>;
}

// API 응답 오류 클래스
class EdicusApiError extends Error {
  constructor(
    public readonly status: number,
    message: string,
  ) {
    super(message);
    this.name = 'EdicusApiError';
  }
}

// 서버 API 클라이언트 생성 팩토리 함수
export function createServerApiClient(): ServerApiClient {
  const env = validateEnv();
  const baseUrl = env.EDICUS_API_HOST;
  const apiKey = env.EDICUS_API_KEY;

  // 공통 헤더를 uid와 함께 생성하는 내부 함수
  function buildHeaders(uid?: string): Record<string, string> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      'edicus-api-key': apiKey,
    };
    if (uid) {
      headers['edicus-uid'] = uid;
    }
    return headers;
  }

  // 응답을 JSON으로 파싱하고 오류를 처리하는 내부 함수
  async function handleResponse<T>(response: Response): Promise<T> {
    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({ error: 'Unknown error' })) as { error?: string };
      throw new EdicusApiError(response.status, errorBody.error ?? `HTTP ${response.status}`);
    }
    // 204 No Content 등 본문이 없는 응답 처리
    if (response.status === 204) {
      return undefined as unknown as T;
    }
    return response.json() as Promise<T>;
  }

  return {
    // 사용자 토큰 발급 (POST /api/auth/token)
    async getToken(uid: string): Promise<TokenResponse> {
      const response = await fetch(`${baseUrl}/api/auth/token`, {
        method: 'POST',
        headers: buildHeaders(uid),
      });
      return handleResponse<TokenResponse>(response);
    },

    // 스태프 토큰 발급 (POST /api/auth/staff/token)
    async getStaffToken(uid: string): Promise<TokenResponse> {
      const response = await fetch(`${baseUrl}/api/auth/staff/token`, {
        method: 'POST',
        headers: buildHeaders(uid),
      });
      return handleResponse<TokenResponse>(response);
    },

    // 프로젝트 목록 조회 (GET /api/projects)
    async getProjects(uid: string): Promise<EdicusProject[]> {
      const response = await fetch(`${baseUrl}/api/projects`, {
        method: 'GET',
        headers: buildHeaders(uid),
      });
      return handleResponse<EdicusProject[]>(response);
    },

    // 프로젝트 상세 조회 (GET /api/projects/:id)
    async getProject(projectId: string): Promise<EdicusProject> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}`, {
        method: 'GET',
        headers: buildHeaders(),
      });
      return handleResponse<EdicusProject>(response);
    },

    // 프로젝트 삭제 (DELETE /api/projects/:id)
    async deleteProject(projectId: string): Promise<void> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}`, {
        method: 'DELETE',
        headers: buildHeaders(),
      });
      await handleResponse<void>(response);
    },

    // 프로젝트 복제 (POST /api/projects/:id/clone)
    async cloneProject(projectId: string): Promise<EdicusProject> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}/clone`, {
        method: 'POST',
        headers: buildHeaders(),
      });
      return handleResponse<EdicusProject>(response);
    },

    // 잠정 주문 생성 (POST /api/projects/:id/order/tentative)
    async tentativeOrder(projectId: string): Promise<Order> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}/order/tentative`, {
        method: 'POST',
        headers: buildHeaders(),
      });
      return handleResponse<Order>(response);
    },

    // 확정 주문 생성 (POST /api/projects/:id/order/definitive)
    async definitiveOrder(projectId: string): Promise<Order> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}/order/definitive`, {
        method: 'POST',
        headers: buildHeaders(),
      });
      return handleResponse<Order>(response);
    },

    // 주문 취소 (POST /api/orders/:id/cancel)
    async cancelOrder(orderId: string): Promise<void> {
      const response = await fetch(`${baseUrl}/api/orders/${orderId}/cancel`, {
        method: 'POST',
        headers: buildHeaders(),
      });
      await handleResponse<void>(response);
    },

    // 미리보기 URL 조회 (GET /api/projects/:id/preview_urls)
    async getPreviewUrls(projectId: string): Promise<string[]> {
      const response = await fetch(`${baseUrl}/api/projects/${projectId}/preview_urls`, {
        method: 'GET',
        headers: buildHeaders(),
      });
      const data = await handleResponse<PreviewUrlsResponse>(response);
      return data.urls;
    },
  };
}
