import { defineConfig } from 'file:///Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build/node_modules/vitest/dist/config.js';
import { resolve } from 'node:path';

// V-PRICE 차등 하네스 전용 vitest 설정.
// `@/` alias 를 §6 04_build/src 로 고정(재구성 어댑터를 검증 대상으로 import).
const BUILD = '/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build';

export default defineConfig({
  resolve: {
    alias: { '@': resolve(BUILD, 'src') },
  },
  test: {
    environment: 'node',
    include: ['/Users/innojini/Dev/HuniWeb/_workspace/huni-re-verify/03_price/scripts/vprice-differential.test.ts'],
  },
});
