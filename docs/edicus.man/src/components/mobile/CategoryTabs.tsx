'use client';

// 카테고리 탭 컴포넌트
// 수평 스크롤 가능, 스냅 지원
interface CategoryTabsProps {
  categories: string[];
  activeCategory: string;
  onSelect: (category: string) => void;
}

export function CategoryTabs({ categories, activeCategory, onSelect }: CategoryTabsProps) {
  return (
    // @MX:NOTE: overflow-x-auto + snap-x로 터치 스크롤 및 스냅 지원
    <div
      className="flex overflow-x-auto snap-x snap-mandatory gap-1 px-4 py-3 bg-white border-b border-gray-100 scrollbar-none"
      role="tablist"
      aria-label="카테고리 선택"
    >
      {categories.map((category) => {
        const isActive = category === activeCategory;

        return (
          <button
            key={category}
            role="tab"
            aria-selected={isActive}
            onClick={() => onSelect(category)}
            className={[
              'flex-shrink-0 snap-start',
              'min-h-[44px] px-4 py-2',
              'text-sm font-medium whitespace-nowrap',
              'transition-colors rounded-none',
              isActive
                ? 'text-huni-primary border-b-2 border-huni-primary'
                : 'text-gray-500 border-b-2 border-transparent',
              'active:opacity-70',
            ].join(' ')}
          >
            {category}
          </button>
        );
      })}
    </div>
  );
}
