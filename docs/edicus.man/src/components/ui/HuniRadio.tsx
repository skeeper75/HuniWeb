// 후니프린팅 디자인 시스템 라디오 버튼 컴포넌트
'use client';

import { forwardRef, InputHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface HuniRadioProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'type'> {}

// @MX:NOTE: [AUTO] 20x20px 타원형 - SPEC FR-B1 준수
const HuniRadio = forwardRef<HTMLInputElement, HuniRadioProps>(
  ({ className, ...props }, ref) => {
    return (
      <input
        type="radio"
        className={cn(
          'w-5 h-5 border border-border-default',
          'checked:accent-huni-primary',
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
HuniRadio.displayName = 'HuniRadio';

export { HuniRadio };
