// 클래스 병합 유틸 (tailwind-merge 미도입 — 단순 clsx 만, 과의존 금지).
import { clsx, type ClassValue } from 'clsx';

export function cn(...inputs: ClassValue[]): string {
  return clsx(inputs);
}
