// 파트너 커스텀 CSS 프리셋 모듈
// 편집기에 전달할 partner_css 값을 관리합니다

/**
 * CSS 프리셋 타입 정의
 */
export interface CssPreset {
  name: string;
  partner: string;
  css: string;
  description: string;
}

/**
 * 후니프린팅 디자인 시스템 v6.0 기반 편집기 CSS
 *
 * @MX:ANCHOR: [AUTO] 편집기 CSS 프리셋 정의 - 모든 편집기 인스턴스의 테마 기반
 * @MX:REASON: fan_in=ALL, EdicusEditor + MobileEditor + Admin Settings에서 참조
 * @MX:SPEC: SPEC-CSS-001
 */
const HUNI_CSS = [
  '/* 후니프린팅 디자인 시스템 v6.0 - Edicus Custom CSS */',
  '/* @MX:SPEC: SPEC-CSS-001 + SPEC-DESIGN-001 */',
  '',
  '@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600&display=swap");',
  '',
  ':root {',
  '  /* 테마 컬러 (후니 디자인 토큰) */',
  '  --theme-color: #5538B6;',
  '  --btn-primary-bg: #5538B6;',
  '  --btn-primary-hover: #351D87;',
  '  --accent-color: #9480D8;',
  '',
  '  /* 배경 */',
  '  --bg-color: #F6F6F6;',
  '  --panel-bg: #FFFFFF;',
  '',
  '  /* 텍스트 */',
  '  --text-color: #424242;',
  '',
  '  /* 보더 */',
  '  --border-color: #CACACA;',
  '',
  '  /* 추가 후니 토큰 */',
  '  --huni-primary: #5538B6;',
  '  --huni-primary-dark: #351D87;',
  '  --huni-primary-secondary: #9480D8;',
  '  --huni-primary-light-1: #C9C2DF;',
  '  --huni-primary-light-2: #DED7F4;',
  '  --huni-primary-light-3: #EDEAF8;',
  '  --huni-accent-gold: #E6B93F;',
  '  --huni-accent-teal: #7AC8C4;',
  '}',
  '',
  '/* 폰트 오버라이드 */',
  'body, .panel, .toolbar, button, input, select, textarea {',
  '  font-family: "Noto Sans KR", -apple-system, BlinkMacSystemFont, sans-serif !important;',
  '  letter-spacing: -0.05em;',
  '}',
  '',
  '/* 버튼 스타일 */',
  'button[class*="primary"], .btn-primary, [class*="btn-primary"] {',
  '  background-color: var(--btn-primary-bg) !important;',
  '  border-color: var(--btn-primary-bg) !important;',
  '}',
  '',
  'button[class*="primary"]:hover, .btn-primary:hover, [class*="btn-primary"]:hover {',
  '  background-color: var(--btn-primary-hover) !important;',
  '  border-color: var(--btn-primary-hover) !important;',
  '}',
  '',
  '/* 패널/툴바 배경 */',
  '.panel, [class*="panel"] {',
  '  background-color: var(--panel-bg);',
  '  border-color: var(--border-color);',
  '}',
  '',
  '/* 선택/활성 상태 강조 */',
  '[class*="active"], [class*="selected"], .active, .selected {',
  '  border-color: var(--huni-primary) !important;',
  '}',
  '',
  '/* 링크/강조 텍스트 */',
  'a, [class*="link"] {',
  '  color: var(--huni-primary);',
  '}',
].join('\n');

/**
 * 파트너별 CSS 프리셋 목록
 *
 * @MX:NOTE: [AUTO] private_css는 편집기 iframe 내부에서 적용됩니다
 * @MX:SPEC: SPEC-CSS-001
 */
export const CSS_PRESETS: Record<string, CssPreset> = {
  default: {
    name: '후니프린팅',
    partner: 'hunip',
    css: HUNI_CSS,
    description: '후니프린팅 디자인 시스템 v6.0 (#5538B6 Purple)',
  },
  dark: {
    name: '다크모드',
    partner: 'hunip',
    css: [
      ':root {',
      '  --bg-color: #1a1a2e;',
      '  --text-color: #e0e0e0;',
      '  --panel-bg: #16213e;',
      '  --border-color: #0f3460;',
      '  --accent-color: #e94560;',
      '}',
      'body { background: var(--bg-color); color: var(--text-color); }',
      '.panel { background: var(--panel-bg); border-color: var(--border-color); }',
    ].join('\n'),
    description: '다크 테마',
  },
  redprinting: {
    name: '레드프린팅',
    partner: 'red',
    css: ':root { --theme-color: #fe2f48; --btn-primary-bg: #fe2f48; --btn-primary-hover: #d91e35; }',
    description: '레드프린팅 스타일',
  },
};

/**
 * 파트너 코드에 해당하는 CSS 문자열을 반환합니다.
 * 파트너에 맞는 첫 번째 프리셋의 CSS를 반환하며,
 * 없으면 빈 문자열을 반환합니다.
 */
export function getCssForPartner(partner: string): string {
  const preset = Object.values(CSS_PRESETS).find((p) => p.partner === partner);
  return preset?.css ?? '';
}

/**
 * 모든 CSS 프리셋 목록을 반환합니다.
 */
export function getAllPresets(): CssPreset[] {
  return Object.values(CSS_PRESETS);
}
