/** @type {import('tailwindcss').Config} */
// DESIGN.md §2 토큰을 theme.extend에 매핑. hex 직기재(bg-[#553886])도 DESIGN이 허용하므로 둘 다 동작.
// 단일 출처는 index.css 의 :host CSS 변수.
export default {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#553886',
        'primary-dark': '#3B2573',
        'text-label': '#424242',
        'text-body': '#616161',
        'text-muted': '#979797',
        'border-default': '#CACACA',
        'bg-section': '#F5F5F5',
        'badge-best': '#3B2573',
      },
      fontFamily: {
        // DESIGN [CRITICAL]: Noto Sans ONLY
        sans: ["'Noto Sans KR'", "'Noto Sans'", 'sans-serif'],
      },
      letterSpacing: {
        // DESIGN 자간 -5% 전역. 컴포넌트는 :host 의 letter-spacing 상속이 기본.
        huni: '-0.05em',
      },
    },
  },
  // preflight 는 Shadow DOM 내부로만 주입되어 호스트로 누수되지 않음 (bp-react-shadow-dom §3).
  plugins: [],
};
