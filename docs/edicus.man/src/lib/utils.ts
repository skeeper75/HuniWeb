// Tailwind CSS 클래스 병합 유틸리티
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

// @MX:ANCHOR: [AUTO] cn 함수는 모든 Huni 컴포넌트에서 사용되는 공통 유틸리티
// @MX:REASON: fan_in >= 8 (8개 컴포넌트에서 직접 참조)
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
