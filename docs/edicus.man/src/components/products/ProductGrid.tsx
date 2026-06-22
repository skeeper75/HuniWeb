/**
 * ProductGrid 서버 컴포넌트
 *
 * 상품 그리드를 표시합니다. /api/edicus/products에서 상품 목록을 가져옵니다.
 * 카테고리 필터를 지원합니다.
 */

import { TemplateCard } from './TemplateCard';

interface Product {
  ps_code: string;
  name: string;
  category?: string;
  thumbnail_url?: string;
  description?: string;
}

interface ProductGridProps {
  /** 필터링할 카테고리 (없으면 전체 표시) */
  category?: string;
}

/**
 * 상품 목록을 가져옵니다.
 * 서버 컴포넌트에서 직접 API를 호출합니다.
 */
async function getProducts(category?: string): Promise<Product[]> {
  try {
    const baseUrl = process.env.NEXT_PUBLIC_APP_URL ?? 'http://localhost:3000';
    const url = new URL('/api/edicus/products', baseUrl);
    if (category) url.searchParams.set('category', category);

    const response = await fetch(url.toString(), {
      // 10분마다 재검증
      next: { revalidate: 600 },
    });

    if (!response.ok) {
      console.error('상품 목록 조회 실패:', response.status);
      return [];
    }

    const data = (await response.json()) as { products?: Product[] };
    return data.products ?? [];
  } catch (error) {
    console.error('상품 목록 조회 중 오류:', error);
    return [];
  }
}

/**
 * 상품 그리드 서버 컴포넌트
 *
 * @param category - 필터링할 카테고리
 */
export async function ProductGrid({ category }: ProductGridProps) {
  const products = await getProducts(category);

  if (products.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-xl border border-dashed border-gray-300 bg-gray-50 py-16">
        <svg
          className="mb-4 h-12 w-12 text-gray-300"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth={1.5}
            d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
          />
        </svg>
        <p className="text-sm text-gray-500">
          {category ? `${category} 카테고리에 상품이 없습니다.` : '등록된 상품이 없습니다.'}
        </p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {products.map((product) => (
        <TemplateCard
          key={product.ps_code}
          psCode={product.ps_code}
          name={product.name}
          category={product.category}
          thumbnailUrl={product.thumbnail_url}
          description={product.description}
        />
      ))}
    </div>
  );
}
