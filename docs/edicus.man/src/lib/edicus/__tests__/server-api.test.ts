// Server API 클라이언트 단위 테스트
// fetch를 모킹하여 각 메서드의 반환 데이터 형태를 검증합니다
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { createServerApiClient } from '../server-api';
import type { EdicusProject, TokenResponse } from '@/types/edicus';
import type { Order } from '@/types/order';

// 환경 변수 모킹
vi.mock('../env', () => ({
  validateEnv: vi.fn(() => ({
    EDICUS_API_KEY: 'test-api-key',
    EDICUS_API_HOST: 'https://api.test.example.com',
    EDICUS_RESOURCE_HOST: 'https://resource.test.example.com',
    NEXT_PUBLIC_EDICUS_PARTNER: 'hunip',
    NEXT_PUBLIC_EDICUS_BASE_URL: 'https://editor.test.example.com',
  })),
}));

// 전역 fetch 모킹
const mockFetch = vi.fn();
vi.stubGlobal('fetch', mockFetch);

describe('ServerApiClient', () => {
  const client = createServerApiClient();

  beforeEach(() => {
    mockFetch.mockReset();
  });

  // 응답 헬퍼
  function mockJsonResponse(data: unknown, status = 200) {
    mockFetch.mockResolvedValueOnce({
      ok: status >= 200 && status < 300,
      status,
      json: async () => data,
    });
  }

  describe('getToken', () => {
    it('uid로 사용자 토큰을 발급해야 합니다', async () => {
      const expected: TokenResponse = { token: 'abc123', expires_at: '2026-01-01T00:00:00Z' };
      mockJsonResponse(expected);

      const result = await client.getToken('user-001');

      expect(result).toEqual(expected);
      expect(mockFetch).toHaveBeenCalledOnce();

      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/auth/token');
      expect(options.method).toBe('POST');
      // API 키가 헤더에 포함되어야 합니다
      const headers = options.headers as Record<string, string>;
      expect(headers['edicus-api-key']).toBe('test-api-key');
      expect(headers['edicus-uid']).toBe('user-001');
    });
  });

  describe('getStaffToken', () => {
    it('uid로 스태프 토큰을 발급해야 합니다', async () => {
      const expected: TokenResponse = { token: 'staff-token-xyz' };
      mockJsonResponse(expected);

      const result = await client.getStaffToken('staff-001');

      expect(result).toEqual(expected);
      const [url] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/auth/staff/token');
    });
  });

  describe('getProjects', () => {
    it('uid의 프로젝트 목록을 반환해야 합니다', async () => {
      const expected: EdicusProject[] = [
        { project_id: 'prj-1', status: 'editing', created_at: '2026-01-01T00:00:00Z', updated_at: '2026-01-01T00:00:00Z' },
      ];
      mockJsonResponse(expected);

      const result = await client.getProjects('user-001');

      expect(result).toEqual(expected);
      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects');
      expect(options.method).toBe('GET');
    });
  });

  describe('getProject', () => {
    it('projectId로 프로젝트 상세를 반환해야 합니다', async () => {
      const expected: EdicusProject = {
        project_id: 'prj-1',
        status: 'editing',
        created_at: '2026-01-01T00:00:00Z',
        updated_at: '2026-01-01T00:00:00Z',
      };
      mockJsonResponse(expected);

      const result = await client.getProject('prj-1');

      expect(result).toEqual(expected);
      const [url] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1');
    });
  });

  describe('deleteProject', () => {
    it('프로젝트를 삭제하고 void를 반환해야 합니다', async () => {
      mockJsonResponse({}, 204);

      await expect(client.deleteProject('prj-1')).resolves.toBeUndefined();

      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1');
      expect(options.method).toBe('DELETE');
    });
  });

  describe('cloneProject', () => {
    it('프로젝트를 복제하여 새 프로젝트를 반환해야 합니다', async () => {
      const expected: EdicusProject = {
        project_id: 'prj-cloned',
        status: 'editing',
        created_at: '2026-01-01T00:00:00Z',
        updated_at: '2026-01-01T00:00:00Z',
      };
      mockJsonResponse(expected);

      const result = await client.cloneProject('prj-1');

      expect(result).toEqual(expected);
      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1/clone');
      expect(options.method).toBe('POST');
    });
  });

  describe('tentativeOrder', () => {
    it('잠정 주문을 생성하고 Order를 반환해야 합니다', async () => {
      const expected: Order = {
        order_id: 'ord-1',
        project_id: 'prj-1',
        status: 'tentative',
        created_at: '2026-01-01T00:00:00Z',
        updated_at: '2026-01-01T00:00:00Z',
      };
      mockJsonResponse(expected);

      const result = await client.tentativeOrder('prj-1');

      expect(result).toEqual(expected);
      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1/order/tentative');
      expect(options.method).toBe('POST');
    });
  });

  describe('definitiveOrder', () => {
    it('확정 주문을 생성하고 Order를 반환해야 합니다', async () => {
      const expected: Order = {
        order_id: 'ord-1',
        project_id: 'prj-1',
        status: 'definitive',
        created_at: '2026-01-01T00:00:00Z',
        updated_at: '2026-01-01T00:00:00Z',
      };
      mockJsonResponse(expected);

      const result = await client.definitiveOrder('prj-1');

      expect(result).toEqual(expected);
      const [url] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1/order/definitive');
    });
  });

  describe('cancelOrder', () => {
    it('주문을 취소하고 void를 반환해야 합니다', async () => {
      mockJsonResponse({}, 200);

      await expect(client.cancelOrder('ord-1')).resolves.toBeUndefined();

      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/orders/ord-1/cancel');
      expect(options.method).toBe('POST');
    });
  });

  describe('getPreviewUrls', () => {
    it('프로젝트의 미리보기 URL 배열을 반환해야 합니다', async () => {
      const expected = { urls: ['https://preview1.example.com', 'https://preview2.example.com'] };
      mockJsonResponse(expected);

      const result = await client.getPreviewUrls('prj-1');

      expect(result).toEqual(expected.urls);
      const [url] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/api/projects/prj-1/preview_urls');
    });
  });

  describe('오류 처리', () => {
    it('API가 4xx 응답을 반환하면 에러를 던져야 합니다', async () => {
      mockFetch.mockResolvedValueOnce({
        ok: false,
        status: 404,
        json: async () => ({ error: 'Not Found' }),
      });

      await expect(client.getProject('non-existent')).rejects.toThrow();
    });
  });
});
