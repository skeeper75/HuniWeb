// 후니프린팅 디자인 시스템 체크박스 컴포넌트
'use client';

import { forwardRef, InputHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface HuniCheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> {}

// @MX:NOTE: [AUTO] 20x20px (w-5 h-5) 고정 크기 - SPEC FR-B1 준수
const HuniCheckbox = forwardRef<HTMLInputElement, HuniCheckboxProps>(
  ({ className, ...props }, ref) => {
    return (
      <input
        type="checkbox"
        className={cn(
          'w-5 h-5 rounded border border-border-default',
          'checked:bg-huni-primary checked:border-huni-primary',
          'focus:ring-2 focus:ring-huni-primary focus:ring-offset-1',
          'cursor-pointer disabled:cursor-not-allowed disabled:opacity-50',
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);
HuniCheckbox.displayName = 'HuniCheckbox';

export { HuniCheckbox };
