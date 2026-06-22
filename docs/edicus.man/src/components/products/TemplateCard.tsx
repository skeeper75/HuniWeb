'use client';

/**
 * TemplateCard 컴포넌트
 *
 * 템플릿 카드를 표시합니다. 썸네일, 상품명, 카테고리를 보여주며,
 * 클릭 시 편집기 페이지로 이동합니다.
 */

import Link from 'next/link';
import Image from 'next/image';

export interface TemplateCardProps {
  /** 상품(템플릿) 코드 */
  psCode: string;
  /** 상품명 */
  name: string;
  /** 카테고리 */
  category?: string;
  /** 썸네일 URL */
  thumbnailUrl?: string;
  /** 템플릿 설명 */
  description?: string;
}

/**
 * 템플릿 선택 카드 컴포넌트
 *
 * 상품 그리드에서 개별 템플릿을 표시합니다.
 * 클릭 시 /editor/[templateId] 페이지로 이동합니다.
 */
export function TemplateCard({
  psCode,
  name,
  category,
  thumbnailUrl,
  description,
}: TemplateCardProps) {
  return (
    <Link
      href={`/editor/${encodeURIComponent(psCode)}`}
      className="group block rounded-xl border border-gray-200 bg-white shadow-sm transition-all duration-200 hover:shadow-md hover:border-huni-primary-light-1 focus:outline-none focus:ring-2 focus:ring-huni-primary focus:ring-offset-2"
      aria-label={`${name} 편집기 열기`}
    >
      {/* 썸네일 영역 */}
      <div className="relative aspect-[4/3] overflow-hidden rounded-t-xl bg-gray-100">
        {thumbnailUrl ? (
          <Image
            src={thumbnailUrl}
            alt={`${name} 미리보기`}
            fill
            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
            className="object-cover transition-transform duration-200 group-hover:scale-105"
          />
        ) : (
          <div className="flex h-full items-center justify-center">
            <svg
              className="h-12 w-12 text-gray-300"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={1.5}
                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
              />
            </svg>
          </div>
        )}

        {/* 카테고리 배지 */}
        {category && (
          <span className="absolute right-2 top-2 rounded-full bg-huni-primary px-2 py-0.5 text-xs font-medium text-white">
            {category}
          </span>
        )}
      </div>

      {/* 카드 내용 */}
      <div className="p-4">
        <h3 className="truncate text-sm font-semibold text-gray-900 group-hover:text-huni-primary">
          {name}
        </h3>
        {description && (
          <p className="mt-1 line-clamp-2 text-xs text-gray-500">{description}</p>
        )}
        <div className="mt-3 flex items-center justify-between">
          <span className="text-xs text-gray-400">{psCode}</span>
          <span className="text-xs font-medium text-huni-primary group-hover:underline">
            편집 시작 →
          </span>
        </div>
      </div>
    </Link>
  );
}
