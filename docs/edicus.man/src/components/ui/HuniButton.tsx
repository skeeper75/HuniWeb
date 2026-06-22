// 후니프린팅 디자인 시스템 버튼 컴포넌트
'use client';

import { forwardRef, ButtonHTMLAttributes } from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

// @MX:NOTE: [AUTO] cva 기반 variant 시스템 - SPEC FR-B2 준수
const buttonVariants = cva(
  'inline-flex items-center justify-center font-medium transition-colors focus-visible:outline-none disabled:pointer-events-none disabled:opacity-50',
  {
    variants: {
      variant: {
        primary: 'bg-huni-primary text-white hover:bg-huni-primary-dark',
        outline: 'border border-huni-primary text-huni-primary bg-transparent hover:bg-huni-primary-light-3',
      },
      size: {
        default: 'h-11 px-6 py-2 text-sm rounded-md',
        sm: 'h-8 px-4 py-1 text-xs rounded',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'default',
    },
  }
);

export interface HuniButtonProps
  extends ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

// @MX:ANCHOR: [AUTO] HuniButton - 공통 버튼 컴포넌트 진입점
// @MX:REASON: 다수 페이지에서 참조되는 공개 API 경계
const HuniButton = forwardRef<HTMLButtonElement, HuniButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
HuniButton.displayName = 'HuniButton';

export { HuniButton, buttonVariants };
