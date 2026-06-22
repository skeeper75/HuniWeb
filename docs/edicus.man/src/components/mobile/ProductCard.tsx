// 모바일 상품 카드 컴포넌트
// 터치 피드백, 이미지, 배지, 가격 정보 포함
import Link from 'next/link';
import Image from 'next/image';

interface ProductCardProps {
  product: {
    name: string;
    price?: string;
    unit?: string;
    imageUrl?: string;
    productId: string;
    category?: string;
  };
}

export function ProductCard({ product }: ProductCardProps) {
  const { name, price, unit, imageUrl, productId } = product;

  return (
    <Link
      href={`/mobile/${productId}`}
      className={[
        'block rounded-xl overflow-hidden',
        'bg-white border border-gray-100 shadow-sm',
        'transition-transform active:scale-95',
      ].join(' ')}
      aria-label={`${name} 상품 보기`}
    >
      {/* 상품 이미지 영역 */}
      <div className="relative aspect-square bg-gray-50">
        {imageUrl ? (
          <Image
            src={imageUrl}
            alt={name}
            fill
            className="object-cover rounded-t-xl"
            sizes="(max-width: 768px) 50vw, 200px"
          />
        ) : (
          // 이미지 없을 때 플레이스홀더
          <div className="absolute inset-0 flex items-center justify-center bg-gray-100 rounded-t-xl">
            <span className="text-2xl text-gray-300">📄</span>
          </div>
        )}

        {/* 모바일 배지 (좌상단) */}
        <div
          className="absolute top-2 left-2 flex items-center justify-center w-6 h-6 rounded-full bg-huni-primary text-white text-[10px] font-bold"
          aria-label="모바일 상품"
        >
          M
        </div>
      </div>

      {/* 상품 정보 */}
      <div className="p-3">
        {/* 상품명 */}
        <p className="text-sm font-medium text-gray-900 line-clamp-2 leading-snug">
          {name}
        </p>

        {/* 가격 */}
        {price && (
          <p className="mt-1.5 text-base font-bold text-huni-primary">
            {price}
          </p>
        )}

        {/* 단위 정보 */}
        {unit && (
          <p className="mt-0.5 text-xs text-gray-500">{unit}</p>
        )}
      </div>
    </Link>
  );
}
