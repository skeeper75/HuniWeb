// 업로드 플로우 테스트 — uploadPdf: presigned → S3 직접 PUT → file-meta → artifacts[side].
// [HARD] 위젯은 BFF 정규화 계약만 사용. S3 PUT 은 주입된 putToS3 로(테스트는 stub).
import { describe, it, expect, vi } from 'vitest';
import { createWidgetStore } from '@/widget/stores/widget-store';
import type { BffClient } from '@/bff/client';
import { StubBffClient } from '@/bff/stub';

// 기본 stub BFF 에 presigned/file-meta 만 결정값으로 덮어쓴 BffClient.
function makeBff(): BffClient {
  const base = new StubBffClient();
  return {
    getProduct: (c) => base.getProduct(c),
    price: (r) => base.price(r),
    presigned: async (req) => {
      expect(req.contentType).toBe('application/pdf');
      return { uploadUrl: 'https://s3.example/up?sig=x', storedFileName: 'uuid-1.pdf', expiresInSec: 3600 };
    },
    fileMeta: async () => ({ pageCount: 8, sizeBytes: 1234 }),
    editorConfig: (c, s) => base.editorConfig(c, s),
    isReadyToOrder: (p) => base.isReadyToOrder(p),
    cartHandoff: (p) => base.cartHandoff(p),
  };
}

async function tick() {
  await new Promise((r) => setTimeout(r, 0));
}

describe('uploadPdf 플로우', () => {
  it('presigned → S3 PUT → file-meta → artifacts[inner]=pdf', async () => {
    const bff = makeBff();
    // putToS3 시그니처(url, file)를 명시 — mock.calls[0][0] 타입(presigned URL) 확보.
    const put = vi.fn(async (_url: string, _file: File) => {});
    const store = createWidgetStore({
      bff,
      productCode: 'PRBKYPR',
      debounceMs: 0,
      putToS3: put,
    });
    await tick(); // loadProduct 완료 대기

    const file = { name: 'doc.pdf', type: 'application/pdf' } as File;
    await store.getState().uploadPdf('inner', file);

    expect(put).toHaveBeenCalledOnce();
    expect(put.mock.calls[0][0]).toBe('https://s3.example/up?sig=x'); // presigned URL 로 PUT
    const art = store.getState().artifacts.inner;
    expect(art?.kind).toBe('pdf');
    expect(art?.storedFileName).toBe('uuid-1.pdf');
    expect(art?.originalFileName).toBe('doc.pdf');
    expect(art?.totalPageCount).toBe(8);
    expect(store.getState().uploadingSide).toBeNull();
  });

  it('application/pdf 아닌 파일은 거부(presigned 미발급)', async () => {
    const bff = makeBff();
    // putToS3 시그니처(url, file)를 명시 — mock.calls[0][0] 타입(presigned URL) 확보.
    const put = vi.fn(async (_url: string, _file: File) => {});
    const store = createWidgetStore({ bff, productCode: 'PRBKYPR', debounceMs: 0, putToS3: put });
    await tick();

    const bad = { name: 'img.png', type: 'image/png' } as File;
    await store.getState().uploadPdf('inner', bad);

    expect(put).not.toHaveBeenCalled();
    expect(store.getState().artifacts.inner).toBeUndefined();
    expect(store.getState().errors.length).toBeGreaterThan(0);
  });
});

describe('applyEditorResult — goto-cart 정규화 결과 반영', () => {
  it('editor 면 artifacts[default]=editor + projectId', async () => {
    const bff = makeBff();
    const store = createWidgetStore({ bff, productCode: 'PRBKYPR', debounceMs: 0 });
    await tick();

    store.getState().applyEditorResult({
      side: 'default',
      projectId: 'PID-1',
      thumbnailUrls: ['t.png'],
      totalPageCount: 4,
    });
    const art = store.getState().artifacts.default;
    expect(art?.kind).toBe('editor');
    expect(art?.projectId).toBe('PID-1');
    expect(store.getState().editorConfig).toBeNull();
    expect(store.getState().editorSide).toBeNull();
  });
});
