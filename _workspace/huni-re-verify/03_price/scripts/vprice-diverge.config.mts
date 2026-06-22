import { defineConfig } from 'file:///Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build/node_modules/vitest/dist/config.js';
import { resolve } from 'node:path';

const BUILD = '/Users/innojini/Dev/HuniWeb/_workspace/huni-widget/04_build';

export default defineConfig({
  resolve: { alias: { '@': resolve(BUILD, 'src') } },
  test: {
    environment: 'node',
    include: ['/Users/innojini/Dev/HuniWeb/_workspace/huni-re-verify/03_price/scripts/divergence-extract.test.ts'],
  },
});
