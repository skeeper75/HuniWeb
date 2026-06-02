// BFF stub — 어댑터를 직접 호출하는 인메모리 BFF (개발/검증용).
// 실 BFF 는 동일 BffClient 시그니처를 HTTP fetch 로 구현(데이터소스 토글은 주입으로 분리).
// 어댑터는 BFF 레이어에 산다(data-adapter §0) — 위젯 번들에 어댑터를 넣지 않는 것이 원칙이나,
// 본 패스는 실 BFF 서버 부재로 stub 을 위젯 측에 두고 fixture 로 검증한다.
// @MX:NOTE 컨버전 시 이 stub 을 실 HTTP BffClient 로 교체하면 위젯 코드 불변.
import type { BffClient } from './client';
import type { DataAdapter } from '@/adapters/types';
import { createRedAdapter } from '@/adapters/red/red-adapter';
import { FixtureRedDataSource } from '@/adapters/red/fixture-source';
import type {
  NormalizedProduct,
  NormalizedPriceRequest,
  NormalizedPriceBreakdown,
  NormalizedPresignedRequest,
  NormalizedPresigned,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
  SideKey,
} from '@/contract';

export class StubBffClient implements BffClient {
  private adapter: DataAdapter;
  constructor(adapter?: DataAdapter) {
    // 기본: Red 어댑터 + fixture 소스. 후니 컨버전 시 createHuniAdapter(...) 주입.
    this.adapter = adapter ?? createRedAdapter(new FixtureRedDataSource());
  }
  getProduct(code: string): Promise<NormalizedProduct> {
    return this.adapter.product.getProduct(code);
  }
  price(req: NormalizedPriceRequest): Promise<NormalizedPriceBreakdown> {
    return this.adapter.price.quote(req);
  }
  presigned(req: NormalizedPresignedRequest): Promise<NormalizedPresigned> {
    return this.adapter.upload.issuePresigned(req);
  }
  fileMeta(storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }> {
    return this.adapter.upload.getFileMeta(storedFileName);
  }
  editorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig> {
    return this.adapter.editor.getConfig(code, side);
  }
  cartHandoff(payload: NormalizedCartHandoff): Promise<{ ok: boolean; redirectUrl?: string }> {
    return this.adapter.cart.handoff(payload);
  }
}
