'use client';

import { useState, useEffect } from 'react';
import { Package } from 'lucide-react';

// @MX:NOTE: 상품 관리 페이지, /api/edicus/resource/products 엔드포인트에서 데이터를 가져옴

interface Product {
  id: string;
  name: string;
  ps_code?: string;
  category?: string;
  description?: string;
}

function ProductSkeleton() {
  return (
    <tr className="animate-pulse">
      {[...Array(3)].map((_, i) => (
        <td key={i} className="px-4 py-3">
          <div className="h-4 bg-gray-200 rounded w-full" />
        </td>
      ))}
    </tr>
  );
}

export default function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setLoading(true);
        const response = await fetch('/api/edicus/resource/products', {
          cache: 'no-store',
        });
        if (!response.ok) {
          throw new Error(`데이터를 불러오는데 실패했습니다. (${response.status})`);
        }
        const data: Product[] = await response.json();
        setProducts(Array.isArray(data) ? data : []);
      } catch (err) {
        setError(err instanceof Error ? err.message : '알 수 없는 오류가 발생했습니다.');
      } finally {
        setLoading(false);
      }
    };

    void fetchProducts();
  }, []);

  const categories = ['all', ...new Set(products.map((p) => p.category ?? '기타'))];

  const filteredProducts =
    selectedCategory === 'all'
      ? products
      : products.filter((p) => (p.category ?? '기타') === selectedCategory);

  return (
    <div className="p-6 lg:p-8">
      {/* 페이지 헤더 */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">상품 관리</h1>
        <p className="mt-1 text-sm text-gray-500">인쇄 상품 카탈로그를 관리합니다.</p>
      </div>

      {/* 오류 메시지 */}
      {error && (
        <div
          role="alert"
          className="mb-5 rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700"
        >
          {error}
        </div>
      )}

      {/* 카테고리 필터 */}
      {!loading && categories.length > 1 && (
        <div className="mb-5 flex flex-wrap gap-2">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`rounded-lg px-3 py-1.5 text-sm font-medium transition-colors ${
                selectedCategory === cat
                  ? 'bg-huni-primary text-white'
                  : 'bg-white border border-gray-300 text-gray-700 hover:bg-gray-50'
              }`}
            >
              {cat === 'all' ? '전체' : cat}
            </button>
          ))}
        </div>
      )}

      {/* 테이블 */}
      <div className="rounded-xl bg-white border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 bg-gray-50">
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  상품명
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  PS 코드
                </th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                  카테고리
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {loading ? (
                <>
                  <ProductSkeleton />
                  <ProductSkeleton />
                  <ProductSkeleton />
                </>
              ) : filteredProducts.length === 0 ? (
                <tr>
                  <td colSpan={3} className="px-4 py-12 text-center">
                    <Package className="mx-auto h-10 w-10 text-gray-300 mb-3" aria-hidden="true" />
                    <p className="text-sm text-gray-400">상품이 없습니다.</p>
                  </td>
                </tr>
              ) : (
                filteredProducts.map((product) => (
                  <tr key={product.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3 font-medium text-gray-900">{product.name}</td>
                    <td className="px-4 py-3 font-mono text-xs text-gray-500">
                      {product.ps_code ?? '—'}
                    </td>
                    <td className="px-4 py-3">
                      {product.category ? (
                        <span className="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-600">
                          {product.category}
                        </span>
                      ) : (
                        <span className="text-gray-400">—</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {!loading && !error && (
        <p className="mt-3 text-xs text-gray-400">총 {filteredProducts.length}개 상품</p>
      )}
    </div>
  );
}
