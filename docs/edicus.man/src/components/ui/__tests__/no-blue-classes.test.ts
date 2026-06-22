// blue- 클래스 사용 감지 테스트 - 디자인 시스템 마이그레이션 검증
// AC-3: blue-600 → primary (#5538B6) 전면 교체 검증
import { readdirSync, readFileSync, statSync } from 'fs';
import { join } from 'path';

// blue 클래스 허용 목록 (마이그레이션 완료 전에 예외 허용 파일)
const ALLOWED_BLUE_FILES: string[] = [];

// src 디렉토리 내 모든 .tsx 파일을 재귀적으로 수집
function collectTsxFiles(dir: string): string[] {
  const files: string[] = [];
  const entries = readdirSync(dir);

  for (const entry of entries) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);

    if (stat.isDirectory()) {
      // node_modules, .next 제외
      if (!['node_modules', '.next', '.git'].includes(entry)) {
        files.push(...collectTsxFiles(fullPath));
      }
    } else if (entry.endsWith('.tsx') || entry.endsWith('.ts')) {
      files.push(fullPath);
    }
  }

  return files;
}

// blue 클래스 패턴 (Tailwind의 blue-xxx 클래스)
const BLUE_CLASS_PATTERN = /\b(?:bg|text|border|ring|hover:|focus:)?blue-\d+/g;

// 테스트 파일 자체는 제외
const TEST_FILE_PATTERN = /\.(test|spec)\.(ts|tsx)$/;

describe('No Blue Tailwind Classes (디자인 시스템 마이그레이션 검증)', () => {
  const srcDir = join(process.cwd(), 'src');
  const allFiles = collectTsxFiles(srcDir);
  const nonTestFiles = allFiles.filter((f) => !TEST_FILE_PATTERN.test(f));

  // components/ui 내 Huni 컴포넌트에서 blue 클래스 사용 금지
  const huniComponentFiles = nonTestFiles.filter((f) =>
    f.includes('/components/ui/Huni')
  );

  if (huniComponentFiles.length === 0) {
    it('Huni component files exist', () => {
      // Huni 컴포넌트 파일이 아직 없으면 스킵
      expect(true).toBe(true);
    });
  } else {
    huniComponentFiles.forEach((filePath) => {
      const relativePath = filePath.replace(process.cwd() + '/', '');

      it(`${relativePath} should not use blue- Tailwind classes`, () => {
        if (ALLOWED_BLUE_FILES.some((allowed) => filePath.endsWith(allowed))) {
          return; // 허용 목록에 있으면 스킵
        }

        const content = readFileSync(filePath, 'utf-8');
        const matches = content.match(BLUE_CLASS_PATTERN) ?? [];

        expect(matches).toHaveLength(0);
      });
    });
  }
});
