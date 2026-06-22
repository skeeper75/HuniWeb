// 후니프린팅 디자인 시스템 입력 컴포넌트
'use client';

import { forwardRef, InputHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface HuniInputProps extends InputHTMLAttributes<HTMLInputElement> {}

// @MX:NOTE: [AUTO] h-11 (44px) 고정 높이 - SPEC FR-B1 준수
const HuniInput = forwardRef<HTMLInputElement, HuniInputProps>(
  ({ className, ...props }, ref) => {
    return (
      <input
        className={cn(
          'h-11 w-full rounded-md border border-border-default bg-white px-3 py-2 text-sm',
          'focus:outline-none focus:ring-2 focus:ring-huni-primary focus:border-huni-primary',
          'disabled:cursor-not-allowed disabled:opacity-50 disabled:bg-bg-section',
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);
HuniInput.displayName = 'HuniInput';

export { HuniInput };
