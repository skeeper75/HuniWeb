// Resource API 클라이언트 단위 테스트
// fetch를 모킹하여 각 메서드의 반환 데이터 형태를 검증합니다
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { createResourceApiClient } from '../resource-api';
import type { EdicusTemplate, EdicusProduct } from '@/types/edicus';

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

describe('ResourceApiClient', () => {
  const client = createResourceApiClient();

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

  describe('queryTemplates', () => {
    it('파트너 코드로 템플릿 목록을 조회해야 합니다', async () => {
      const expected: EdicusTemplate[] = [
        { resource_id: 'res-1', title: '명함 기본형', ps_code: 'BIZ001', template_uri: '/templates/biz001' },
      ];
      mockJsonResponse(expected);

      const result = await client.queryTemplates('hunip');

      expect(result).toEqual(expected);
      expect(mockFetch).toHaveBeenCalledOnce();

      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/resapi/query');
      expect(options.method).toBe('POST');
    });

    it('옵션과 함께 템플릿을 조회할 수 있어야 합니다', async () => {
      const expected: EdicusTemplate[] = [];
      mockJsonResponse(expected);

      await client.queryTemplates('hunip', { category: 'BUSINESS_CARD', page: 2, limit: 20 });

      const [, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      const body = JSON.parse(options.body as string) as Record<string, unknown>;
      expect(body.partner).toBe('hunip');
      expect(body.category).toBe('BUSINESS_CARD');
      expect(body.page).toBe(2);
      expect(body.limit).toBe(20);
    });
  });

  describe('getProductList', () => {
    it('파트너의 상품 목록을 반환해야 합니다', async () => {
      const expected: EdicusProduct[] = [
        { ps_code: 'BIZ001', title: '명함', category: 'BUSINESS_CARD' },
      ];
      mockJsonResponse(expected);

      const result = await client.getProductList('hunip');

      expect(result).toEqual(expected);
      const [url, options] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/resapi/product/list');
      expect(options.method).toBe('GET');
    });
  });

  describe('getResource', () => {
    it('resource_id로 템플릿 상세 정보를 반환해야 합니다', async () => {
      const expected: EdicusTemplate = {
        resource_id: 'res-1',
        title: '명함 기본형',
        ps_code: 'BIZ001',
        template_uri: '/templates/biz001',
      };
      mockJsonResponse(expected);

      const result = await client.getResource('res-1');

      expect(result).toEqual(expected);
      const [url] = mockFetch.mock.calls[0] as [string, RequestInit];
      expect(url).toContain('/resapi/resource/res-1');
    });
  });

  describe('오류 처리', () => {
    it('API가 4xx 응답을 반환하면 에러를 던져야 합니다', async () => {
      mockFetch.mockResolvedValueOnce({
        ok: false,
        status: 400,
        json: async () => ({ error: 'Bad Request' }),
      });

      await expect(client.getResource('invalid')).rejects.toThrow();
    });
  });
});
