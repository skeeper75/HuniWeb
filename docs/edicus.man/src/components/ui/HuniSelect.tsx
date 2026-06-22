// 후니프린팅 디자인 시스템 커스텀 셀렉트 컴포넌트
// @MX:WARN: [AUTO] RULE-1: 절대 <select> 네이티브 요소 사용 금지
// @MX:REASON: SPEC-DESIGN-001 RULE-1 - 네이티브 select는 디자인 시스템 정책 위반
'use client';

import { forwardRef, useState, useRef, useEffect } from 'react';
import { cn } from '@/lib/utils';

export interface SelectOption {
  value: string;
  label: string;
}

export interface HuniSelectProps {
  options: SelectOption[];
  value?: string;
  onChange?: (value: string) => void;
  placeholder?: string;
  disabled?: boolean;
  className?: string;
}

// @MX:NOTE: [AUTO] 커스텀 드롭다운 구현 - ▼ 텍스트 캐럿 사용
const HuniSelect = forwardRef<HTMLDivElement, HuniSelectProps>(
  ({ options, value, onChange, placeholder = '선택하세요', disabled, className }, ref) => {
    const [isOpen, setIsOpen] = useState(false);
    const containerRef = useRef<HTMLDivElement>(null);

    const selectedOption = options.find((opt) => opt.value === value);

    useEffect(() => {
      const handleClickOutside = (e: MouseEvent) => {
        if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
          setIsOpen(false);
        }
      };
      document.addEventListener('mousedown', handleClickOutside);
      return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    return (
      <div ref={ref} className={cn('relative w-full', className)}>
        <div ref={containerRef}>
          <button
            type="button"
            disabled={disabled}
            onClick={() => !disabled && setIsOpen(!isOpen)}
            className={cn(
              'h-11 w-full rounded-md border border-border-default bg-white px-3 py-2 text-sm text-left',
              'flex items-center justify-between',
              'focus:outline-none focus:ring-2 focus:ring-huni-primary',
              'disabled:cursor-not-allowed disabled:opacity-50'
            )}
            aria-haspopup="listbox"
            aria-expanded={isOpen}
          >
            <span>{selectedOption ? selectedOption.label : placeholder}</span>
            <span className="ml-2">&#9660;</span>
          </button>
          {isOpen && (
            <ul
              role="listbox"
              className="absolute z-50 w-full mt-1 rounded-md border border-border-default bg-white shadow-md"
            >
              {options.map((opt) => (
                <li
                  key={opt.value}
                  role="option"
                  aria-selected={opt.value === value}
                  onClick={() => {
                    onChange?.(opt.value);
                    setIsOpen(false);
                  }}
                  className={cn(
                    'px-3 py-2 text-sm cursor-pointer hover:bg-huni-primary-light-3',
                    opt.value === value && 'bg-huni-primary-light-2 text-huni-primary'
                  )}
                >
                  {opt.label}
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    );
  }
);
HuniSelect.displayName = 'HuniSelect';

export { HuniSelect };
