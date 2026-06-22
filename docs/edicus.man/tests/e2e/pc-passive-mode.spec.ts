/**
 * PC Passive Mode Editor E2E 스모크 테스트
 *
 * Edicus 외부 서비스 의존으로 실제 CI에서는 스킵됩니다.
 * 로컬에서 수동으로 실행하여 통합 동작을 검증합니다.
 *
 * @MX:SPEC: SPEC-PCPASSIVE-001 Phase E-5
 */

import { test, expect } from '@playwright/test';

test.describe('PC Passive Mode Editor', () => {
  test.skip('스모크 테스트 - PC passive 모드 편집기 렌더링', async ({ page }) => {
    // Edicus 외부 서비스 의존으로 CI에서 스킵
    await page.goto('/editor/test-template?passive=true');
    await expect(page.getByRole('dialog')).toBeVisible();
  });

  test.skip('스모크 테스트 - 도구바 버튼 렌더링', async ({ page }) => {
    // Edicus 외부 서비스 의존으로 CI에서 스킵
    await page.goto('/editor/test-template?passive=true');

    // 도구바 버튼들이 표시되는지 확인
    await expect(page.getByLabel('편집기 닫기')).toBeVisible();
    await expect(page.getByLabel('실행 취소')).toBeVisible();
    await expect(page.getByLabel('다시 실행')).toBeVisible();
    await expect(page.getByLabel('저장')).toBeVisible();
    await expect(page.getByLabel('편집 완료')).toBeVisible();
  });

  test.skip('스모크 테스트 - 키보드 단축키 동작', async ({ page }) => {
    // Edicus 외부 서비스 의존으로 CI에서 스킵
    await page.goto('/editor/test-template?passive=true');

    // Ctrl+S 단축키
    await page.keyboard.press('Control+s');

    // Ctrl+Z 단축키
    await page.keyboard.press('Control+z');
  });
});
