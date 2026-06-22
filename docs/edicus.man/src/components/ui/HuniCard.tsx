'use client';

// @MX:NOTE: [AUTO] 후니프린팅 카드 컴포넌트 - rounded-lg, shadow-sm, bg-white
// @MX:SPEC: SPEC-DESIGN-001
import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

/** 카드 변형 정의 */
const cardVariants = cva(
  'rounded-lg bg-white shadow-sm',
  {
    variants: {
      padding: {
        sm: 'p-4',
        default: 'p-6',
      },
    },
    defaultVariants: {
      padding: 'default',
    },
  }
);

export interface HuniCardProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof cardVariants> {}

/** 후니프린팅 카드 컴포넌트 */
const HuniCard = React.forwardRef<HTMLDivElement, HuniCardProps>(
  ({ className, padding, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(cardVariants({ padding, className }))}
        {...props}
      />
    );
  }
);

HuniCard.displayName = 'HuniCard';

/** 카드 헤더 */
const HuniCardHeader = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('mb-4', className)} {...props} />
  )
);
HuniCardHeader.displayName = 'HuniCardHeader';

/** 카드 콘텐츠 */
const HuniCardContent = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn('text-sm text-text-medium', className)} {...props} />
  )
);
HuniCardContent.displayName = 'HuniCardContent';

export { HuniCard, HuniCardHeader, HuniCardContent, cardVariants };
