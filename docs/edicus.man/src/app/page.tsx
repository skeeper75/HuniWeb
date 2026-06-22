import { Suspense } from 'react';
import Link from 'next/link';
import { ProductGrid } from '@/components/products/ProductGrid';

/**
 * 홈 페이지
 *
 * 후니프린팅 서비스 소개와 상품 그리드를 표시합니다.
 * 카테고리 네비게이션과 템플릿 카드 목록을 제공합니다.
 */

/** 카테고리 목록 (searchParams로 필터링) */
const CATEGORIES = [
  { value: '', label: '전체' },
  { value: '명함', label: '명함' },
  { value: '전단지', label: '전단지' },
  { value: '포스터', label: '포스터' },
  { value: '배너', label: '배너' },
  { value: '스티커', label: '스티커' },
] as const;

interface HomePageProps {
  searchParams: Promise<{ category?: string }>;
}

export default async function HomePage({ searchParams }: HomePageProps) {
  const params = await searchParams;
  const selectedCategory = params.category ?? '';

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      {/* 히어로 섹션 */}
      <section className="mb-12 rounded-2xl bg-gradient-to-br from-huni-primary to-huni-primary-dark p-8 text-white sm:p-12">
        <div className="max-w-2xl">
          <h1 className="text-3xl font-bold sm:text-4xl">
            나만의 디자인으로
            <br />
            인쇄물을 제작하세요
          </h1>
          <p className="mt-4 text-base text-huni-primary-light-1 sm:text-lg">
            후니프린팅의 다양한 템플릿에서 원하는 디자인을 선택하고,
            <br />
            웹 편집기로 간편하게 커스터마이징하세요.
          </p>
          <div className="mt-6 flex flex-wrap gap-3">
            <Link
              href="/projects"
              className="rounded-lg bg-white px-5 py-2.5 text-sm font-semibold text-huni-primary transition-colors hover:bg-huni-primary-light-3"
            >
              내 프로젝트 보기
            </Link>
            <Link
              href="#products"
              className="rounded-lg border border-huni-primary-light-1 px-5 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-huni-primary-secondary"
            >
              템플릿 둘러보기
            </Link>
          </div>
        </div>
      </section>

      {/* 상품 섹션 */}
      <section id="products">
        <div className="mb-6 flex items-center justify-between">
          <h2 className="text-xl font-bold text-gray-900">템플릿 선택</h2>
          <p className="text-sm text-gray-500">파트너: 후니프린팅 (hunip)</p>
        </div>

        {/* 카테고리 필터 */}
        <nav aria-label="카테고리 필터" className="mb-6">
          <ul className="flex flex-wrap gap-2">
            {CATEGORIES.map(({ value, label }) => {
              const isActive = selectedCategory === value;
              const href = value ? `/?category=${encodeURIComponent(value)}` : '/';
              return (
                <li key={value}>
                  <Link
                    href={href}
                    className={`rounded-full px-4 py-1.5 text-sm font-medium transition-colors ${
                      isActive
                        ? 'bg-huni-primary text-white'
                        : 'border border-gray-300 bg-white text-gray-600 hover:border-huni-primary-light-1 hover:text-huni-primary'
                    }`}
                    aria-current={isActive ? 'true' : undefined}
                  >
                    {label}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* 상품 그리드 */}
        <Suspense
          fallback={
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              {Array.from({ length: 8 }).map((_, i) => (
                <div
                  key={i}
                  className="animate-pulse rounded-xl border border-gray-200 bg-white"
                >
                  <div className="aspect-[4/3] rounded-t-xl bg-gray-200" />
                  <div className="p-4">
                    <div className="h-4 rounded bg-gray-200" />
                    <div className="mt-2 h-3 w-2/3 rounded bg-gray-200" />
                  </div>
                </div>
              ))}
            </div>
          }
        >
          <ProductGrid category={selectedCategory || undefined} />
        </Suspense>
      </section>
    </div>
  );
}
