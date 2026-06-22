// 디자인 토큰 검증 테스트 - tailwind.config.ts에 필요한 색상 토큰 존재 여부 확인
import tailwindConfig from '../../../../tailwind.config';

describe('Design Tokens - tailwind.config.ts', () => {
  const colors = (tailwindConfig.theme?.extend as { colors?: Record<string, unknown> })?.colors;

  it('tailwind config has theme.extend.colors defined', () => {
    expect(colors).toBeDefined();
  });

  describe('huni color tokens', () => {
    let huniColors: Record<string, unknown>;

    beforeEach(() => {
      huniColors = colors?.['huni'] as Record<string, unknown> ?? {};
    });

    it('has huni.primary color token', () => {
      expect(huniColors).toHaveProperty('primary');
      expect(huniColors['primary']).toBe('#5538B6');
    });

    it('has huni.primary-dark color token', () => {
      expect(huniColors).toHaveProperty('primary-dark');
      expect(huniColors['primary-dark']).toBe('#351D87');
    });

    it('has huni.primary-secondary color token', () => {
      expect(huniColors).toHaveProperty('primary-secondary');
      expect(huniColors['primary-secondary']).toBe('#9480D8');
    });

    it('has huni.primary-light-1 color token', () => {
      expect(huniColors).toHaveProperty('primary-light-1');
    });

    it('has huni.primary-light-2 color token', () => {
      expect(huniColors).toHaveProperty('primary-light-2');
    });

    it('has huni.primary-light-3 color token', () => {
      expect(huniColors).toHaveProperty('primary-light-3');
    });
  });

  describe('text color tokens', () => {
    it('has text-dark color token', () => {
      expect(colors).toHaveProperty('text-dark');
    });

    it('has text-medium color token', () => {
      expect(colors).toHaveProperty('text-medium');
    });

    it('has text-muted color token', () => {
      expect(colors).toHaveProperty('text-muted');
    });
  });

  describe('other color tokens', () => {
    it('has border-default color token', () => {
      expect(colors).toHaveProperty('border-default');
    });

    it('has bg-light color token', () => {
      expect(colors).toHaveProperty('bg-light');
    });

    it('has bg-section color token', () => {
      expect(colors).toHaveProperty('bg-section');
    });

    it('has accent-gold color token', () => {
      expect(colors).toHaveProperty('accent-gold');
    });

    it('has accent-teal color token', () => {
      expect(colors).toHaveProperty('accent-teal');
    });
  });
});
