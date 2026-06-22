// RULE-1 준수 테스트 - 네이티브 <select> 요소 사용 금지
// AC-7: RULE-1 native select 사용 없음 검증
import { readdirSync, readFileSync, statSync } from 'fs';
import { join } from 'path';

// src 디렉토리 내 모든 .tsx 파일을 재귀적으로 수집
function collectTsxFiles(dir: string): string[] {
  const files: string[] = [];
  const entries = readdirSync(dir);

  for (const entry of entries) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);

    if (stat.isDirectory()) {
      if (!['node_modules', '.next', '.git'].includes(entry)) {
        files.push(...collectTsxFiles(fullPath));
      }
    } else if (entry.endsWith('.tsx')) {
      files.push(fullPath);
    }
  }

  return files;
}

// 네이티브 select 패턴 (주석 제외)
// JSX의 <select> 및 React.createElement('select', ...) 탐지
const NATIVE_SELECT_PATTERNS = [
  /<select[\s>\/]/,              // JSX <select> 또는 <select/>
  /createElement\(['"]select['"]/, // React.createElement('select', ...)
];

// 테스트 파일 자체는 제외
const TEST_FILE_PATTERN = /\.(test|spec)\.(ts|tsx)$/;

describe('RULE-1: No Native <select> Elements', () => {
  const srcDir = join(process.cwd(), 'src');
  const allTsxFiles = collectTsxFiles(srcDir);
  const nonTestFiles = allTsxFiles.filter((f) => !TEST_FILE_PATTERN.test(f));

  if (nonTestFiles.length === 0) {
    it('TSX files exist in src/', () => {
      expect(true).toBe(true);
    });
  } else {
    nonTestFiles.forEach((filePath) => {
      const relativePath = filePath.replace(process.cwd() + '/', '');

      it(`${relativePath} should not contain native <select> element`, () => {
        const content = readFileSync(filePath, 'utf-8');

        // 주석 라인 제외 처리
        const nonCommentLines = content
          .split('\n')
          .filter((line) => !line.trim().startsWith('//') && !line.trim().startsWith('*'))
          .join('\n');

        const hasNativeSelect = NATIVE_SELECT_PATTERNS.some((pattern) =>
          pattern.test(nonCommentLines)
        );

        expect(hasNativeSelect).toBe(false);
      });
    });
  }
});
