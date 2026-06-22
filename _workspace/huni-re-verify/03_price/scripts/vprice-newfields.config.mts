import { defineConfig } from 'file:///Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build/node_modules/vitest/dist/config.js';
import { resolve } from 'node:path';

// V-PRICE 신규필드(6월 드리프트) 차등 하네스 전용 vitest 설정.
const BUILD = '/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build';

export default defineConfig({
  resolve: {
    alias: { '@': resolve(BUILD, 'src') },
  },
  test: {
    environment: 'node',
    include: ['/Users/innojini/Dev/HuniWeb/_workspace/huni-re-verify/03_price/scripts/vprice-newfields.test.ts'],
  },
});
