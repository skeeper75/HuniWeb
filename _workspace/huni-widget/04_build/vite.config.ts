import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'node:path';

// Vite library mode — bundle-strategy §2.
// 3 청크 의도: loader(얇은 임베드) / widget(런타임) / editor(Edicus, 동적 import).
// 이번 패스는 loader + widget 2 entry. editor 청크는 D 단계(deferred)에서 동적 import로 분리.
export default defineConfig({
  plugins: [react()],
  // 위젯은 자기완결 번들이라 React 를 인라인 포함 → React 프로덕션 빌드로 고정(dev 빌드 957KB 방지).
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
  },
  resolve: {
    alias: { '@': resolve(__dirname, 'src') },
  },
  build: {
    lib: {
      entry: {
        loader: resolve(__dirname, 'src/widget-loader/index.ts'),
        widget: resolve(__dirname, 'src/widget/entry.tsx'),
      },
      formats: ['es'],
    },
    rollupOptions: {
      // 위젯은 자기완결 번들(호스트에 React 의존 강제 안 함) → React 인라인 포함.
      output: {
        entryFileNames: '[name].js',
        chunkFileNames: 'chunks/[name].[hash].js',
      },
    },
    target: 'es2020',
    cssCodeSplit: false,
    // library mode 는 기본 minify=esbuild 이나 명시. React+Radix 인라인 포함分.
    minify: 'esbuild',
  },
});
