// @MX:ANCHOR: [AUTO] 후니프린팅 디자인 토큰 정의 - 전체 UI 기반 설정
// @MX:REASON: fan_in=ALL, 모든 컴포넌트와 페이지가 이 토큰을 참조
// @MX:SPEC: SPEC-DESIGN-001
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        huni: {
          primary: '#5538B6',
          'primary-dark': '#351D87',
          'primary-secondary': '#9480D8',
          'primary-light-1': '#C9C2DF',
          'primary-light-2': '#DED7F4',
          'primary-light-3': '#EDEAF8',
        },
        'text-dark': '#424242',
        'text-medium': '#565656',
        'text-muted': '#979797',
        'border-default': '#CACACA',
        'bg-light': '#E9E9E9',
        'bg-section': '#F6F6F6',
        'accent-gold': '#E6B93F',
        'accent-teal': '#7AC8C4',
      },
      fontFamily: {
        sans: ['var(--font-noto-sans)', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
export default config;
