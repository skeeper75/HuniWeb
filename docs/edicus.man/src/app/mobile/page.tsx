'use client';

// 모바일 상품 카탈로그 페이지
// 카테고리 탭 + 상품 그리드(2열) 구성
import { useState, useEffect } from 'react';
import { CategoryTabs } from '@/components/mobile/CategoryTabs';
import { ProductCard } from '@/components/mobile/ProductCard';

// 카테고리 목록
const CATEGORIES = ['전체', '스티커', '명함', '전단지', '포스터', '노트', '굿즈', '포토'];

// 상품 타입 정의
interface Product {
  ps_code: string;
  title: string;
  category: string;
  thumbnail_url?: string;
  price?: string;
  unit?: string;
  [key: string]: unknown;
}

export default function MobileCatalogPage() {
  const [activeCategory, setActiveCategory] = useState('전체');
  const [products, setProducts] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // 상품 목록 로드
  useEffect(() => {
    const partner = process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip';

    setIsLoading(true);
    setError(null);

    fetch(`/api/edicus/products?partner=${encodeURIComponent(partner)}`)
      .then(async (res) => {
        if (!res.ok) throw new Error('상품 목록을 불러올 수 없습니다');
        return res.json() as Promise<Product[]>;
      })
      .then((data) => {
        setProducts(Array.isArray(data) ? data : []);
      })
      .catch((err: unknown) => {
        setError(err instanceof Error ? err.message : '오류가 발생했습니다');
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, []);

  // 카테고리 필터링
  const filteredProducts = activeCategory === '전체'
    ? products
    : products.filter((p) => p.category === activeCategory);

  return (
    <div className="flex flex-col min-h-full">
      {/* 페이지 헤더 */}
      <header className="px-4 pt-4 pb-2 bg-white">
        <h1 className="text-xl font-bold text-gray-900">모바일 주문</h1>
      </header>

      {/* 카테고리 탭 */}
      <CategoryTabs
        categories={CATEGORIES}
        activeCategory={activeCategory}
        onSelect={setActiveCategory}
      />

      {/* 상품 목록 */}
      <div className="flex-1 p-4">
        {isLoading ? (
          // 로딩 스켈레톤
          <div className="grid grid-cols-2 gap-3">
            {Array.from({ length: 6 }).map((_, i) => (
              <div key={i} className="rounded-xl bg-gray-100 animate-pulse aspect-[3/4]" />
            ))}
          </div>
        ) : error ? (
          // 오류 상태
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <p className="text-sm text-red-500">{error}</p>
            <button
              onClick={() => window.location.reload()}
              className="mt-4 px-4 py-2 text-sm font-medium text-huni-primary border border-huni-primary rounded-lg"
            >
              다시 시도
            </button>
          </div>
        ) : filteredProducts.length === 0 ? (
          // 빈 상태
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <p className="text-sm text-gray-400">해당 카테고리의 상품이 없습니다.</p>
          </div>
        ) : (
          // 상품 그리드 (2열)
          <div className="grid grid-cols-2 gap-3">
            {filteredProducts.map((product) => (
              <ProductCard
                key={product.ps_code}
                product={{
                  productId: product.ps_code,
                  name: product.title,
                  category: product.category,
                  imageUrl: product.thumbnail_url,
                  price: product.price,
                  unit: product.unit,
                }}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
