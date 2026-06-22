'use client';

// 모바일 상품 상세 + 편집기 연동 페이지
// 상품 정보 표시 후 "만들기" 버튼 클릭 시 MobileEditor 전체화면 표시
import { useState, useEffect, use } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { ArrowLeft } from 'lucide-react';
import { MobileEditor } from '@/components/mobile/MobileEditor';

interface ProductDetail {
  ps_code: string;
  title: string;
  category?: string;
  thumbnail_url?: string;
  description?: string;
  price?: string;
  unit?: string;
  template_uri?: string;
  [key: string]: unknown;
}

interface PageProps {
  params: Promise<{ productId: string }>;
}

export default function MobileProductDetailPage({ params }: PageProps) {
  const router = useRouter();
  const { productId } = use(params);

  const [product, setProduct] = useState<ProductDetail | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showEditor, setShowEditor] = useState(false);

  // 상품 정보 로드
  useEffect(() => {
    const partner = process.env.NEXT_PUBLIC_EDICUS_PARTNER ?? 'hunip';

    setIsLoading(true);
    setError(null);

    // 상품 목록에서 해당 상품 검색
    fetch(`/api/edicus/products?partner=${encodeURIComponent(partner)}`)
      .then(async (res) => {
        if (!res.ok) throw new Error('상품 정보를 불러올 수 없습니다');
        return res.json() as Promise<ProductDetail[]>;
      })
      .then((data) => {
        const found = Array.isArray(data)
          ? data.find((p) => p.ps_code === productId) ?? null
          : null;

        if (!found) {
          setError('상품을 찾을 수 없습니다');
        } else {
          setProduct(found);
        }
      })
      .catch((err: unknown) => {
        setError(err instanceof Error ? err.message : '오류가 발생했습니다');
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, [productId]);

  // 장바구니 이동 처리
  const handleGotoCart = () => {
    setShowEditor(false);
    router.push('/orders');
  };

  // 전체화면 편집기 렌더링
  if (showEditor && product) {
    return (
      <MobileEditor
        templateId={product.ps_code}
        psCode={product.ps_code}
        templateUri={product.template_uri}
        onClose={() => setShowEditor(false)}
        onGotoCart={handleGotoCart}
      />
    );
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-50">
        <div className="flex flex-col items-center gap-3">
          <div className="h-8 w-8 animate-spin rounded-full border-4 border-huni-primary border-t-transparent" />
          <p className="text-sm text-gray-500">로딩 중...</p>
        </div>
      </div>
    );
  }

  if (error || !product) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-gray-50 p-6">
        <p className="text-sm text-red-500 mb-4">{error ?? '상품을 찾을 수 없습니다'}</p>
        <button
          onClick={() => router.back()}
          className="px-4 py-2 text-sm font-medium text-huni-primary border border-huni-primary rounded-lg"
        >
          돌아가기
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col min-h-screen bg-white">
      {/* 헤더 */}
      <header className="flex items-center gap-3 px-4 py-3 border-b border-gray-100">
        <button
          onClick={() => router.back()}
          className="min-w-[44px] min-h-[44px] flex items-center justify-center rounded-lg text-gray-600 active:bg-gray-100 transition-colors"
          aria-label="뒤로가기"
        >
          <ArrowLeft className="h-5 w-5" />
        </button>
        <h1 className="text-base font-semibold text-gray-900 line-clamp-1">{product.title}</h1>
      </header>

      {/* 스크롤 가능한 콘텐츠 영역 */}
      <div className="flex-1 overflow-y-auto pb-24">
        {/* 상품 이미지 */}
        <div className="relative aspect-square bg-gray-50">
          {product.thumbnail_url ? (
            <Image
              src={product.thumbnail_url}
              alt={product.title}
              fill
              className="object-contain"
              sizes="100vw"
              priority
            />
          ) : (
            <div className="absolute inset-0 flex items-center justify-center bg-gray-100">
              <span className="text-5xl text-gray-300">📄</span>
            </div>
          )}
        </div>

        {/* 상품 정보 */}
        <div className="p-5">
          {/* 카테고리 배지 */}
          {product.category && (
            <span className="inline-block px-2.5 py-1 text-xs font-medium text-huni-primary bg-huni-primary-light-3 rounded-full mb-3">
              {product.category}
            </span>
          )}

          {/* 상품명 */}
          <h2 className="text-lg font-bold text-gray-900">{product.title}</h2>

          {/* 가격 */}
          {product.price && (
            <p className="mt-2 text-xl font-bold text-huni-primary">{product.price}</p>
          )}

          {/* 단위 */}
          {product.unit && (
            <p className="mt-1 text-sm text-gray-500">{product.unit}</p>
          )}

          {/* 설명 */}
          {product.description && (
            <div className="mt-5 pt-5 border-t border-gray-100">
              <h3 className="text-sm font-semibold text-gray-900 mb-2">상품 설명</h3>
              <p className="text-sm text-gray-600 leading-relaxed">{product.description}</p>
            </div>
          )}

          {/* 상품 코드 */}
          <div className="mt-5 pt-5 border-t border-gray-100">
            <p className="text-xs text-gray-400">
              상품 코드: <span className="font-mono">{product.ps_code}</span>
            </p>
          </div>
        </div>
      </div>

      {/* 하단 고정 "만들기" 버튼 */}
      <div
        className="fixed bottom-16 left-0 right-0 px-4 py-3 bg-white border-t border-gray-100"
        style={{ paddingBottom: 'calc(env(safe-area-inset-bottom) + 12px)' }}
      >
        <button
          onClick={() => setShowEditor(true)}
          className="w-full h-12 bg-huni-primary text-white text-base font-semibold rounded-xl active:bg-huni-primary-dark transition-colors"
        >
          만들기
        </button>
      </div>
    </div>
  );
}
