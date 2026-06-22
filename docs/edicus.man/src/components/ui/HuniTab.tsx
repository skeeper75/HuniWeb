'use client';

// @MX:NOTE: [AUTO] 후니프린팅 탭 컴포넌트 - 활성 탭은 huni-primary 색상 + 2px 하단 보더
// @MX:SPEC: SPEC-DESIGN-001
import * as React from 'react';
import { cn } from '@/lib/utils';

export interface HuniTabItem {
  value: string;
  label: string;
}

export interface HuniTabProps {
  tabs: HuniTabItem[];
  activeTab?: string;
  onTabChange?: (value: string) => void;
  className?: string;
}

/** 후니프린팅 탭 컴포넌트 */
const HuniTab = React.forwardRef<HTMLDivElement, HuniTabProps>(
  ({ tabs, activeTab, onTabChange, className }, ref) => {
    return (
      <div
        ref={ref}
        role="tablist"
        className={cn('flex border-b border-border-default', className)}
      >
        {tabs.map((tab) => {
          const isActive = tab.value === activeTab;
          return (
            <button
              key={tab.value}
              role="tab"
              aria-selected={isActive}
              onClick={() => onTabChange?.(tab.value)}
              className={cn(
                'px-4 py-2 text-sm font-medium transition-colors',
                'border-b-2 -mb-px',
                isActive
                  ? 'border-huni-primary text-huni-primary'
                  : 'border-transparent text-text-muted hover:text-text-medium hover:border-border-default'
              )}
            >
              {tab.label}
            </button>
          );
        })}
      </div>
    );
  }
);

HuniTab.displayName = 'HuniTab';

export { HuniTab };
