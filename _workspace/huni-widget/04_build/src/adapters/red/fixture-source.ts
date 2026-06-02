// Fixture 기반 RedDataSource — 라이브 캡처(fixtures/*.json)로 위젯을 검증.
// 데이터소스 토글(fixture↔실 BFF)은 주입으로 분리(이 클래스 vs 실 HTTP 소스).
import type {
  NormalizedPriceRequest,
  NormalizedPresignedRequest,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
  SideKey,
} from '@/contract';
import type { RedDataSource } from './red-adapter';
import type {
  RedDigitalProductResponse,
  RedPriceResponse,
  RedPresignedResponse,
} from './red-types';

// Vite 가 JSON 을 모듈로 import (resolveJsonModule).
import productPRBKYPR from '../../../fixtures/product_PRBKYPR.json';
import productGSTGMIC from '../../../fixtures/product_GSTGMIC.json';
import productACNTHAP from '../../../fixtures/product_ACNTHAP.json';
import priceQ30 from '../../../fixtures/price_q30_p10.json';
import priceQ300 from '../../../fixtures/price_q300_p10.json';
import presignedSample from '../../../fixtures/presigned_response_sample.json';

const PRODUCTS: Record<string, unknown> = {
  PRBKYPR: productPRBKYPR,
  GSTGMIC: productGSTGMIC,
  ACNTHAP: productACNTHAP,
};

export class FixtureRedDataSource implements RedDataSource {
  async fetchProduct(code: string): Promise<RedDigitalProductResponse> {
    const p = PRODUCTS[code] ?? productPRBKYPR;
    return p as RedDigitalProductResponse;
  }

  async fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse> {
    // fixture 는 수량별 2종만 보유 → quantity 로 근사 선택(검증 목적).
    const r = req.quantity >= 120 ? priceQ300 : priceQ30;
    return r as RedPriceResponse;
  }

  async fetchPresigned(_req: NormalizedPresignedRequest): Promise<RedPresignedResponse> {
    return presignedSample as RedPresignedResponse;
  }

  async fetchFileMeta(_storedFileName: string): Promise<{ pageCount?: number; sizeBytes?: number }> {
    // @MX:NOTE s3GetObjectJson 라이브 미캡처(O5) — fixture 는 메타 샘플 부재. 보수값 반환.
    return { pageCount: 1, sizeBytes: 0 };
  }

  async fetchEditorConfig(code: string, side: SideKey): Promise<NormalizedEditorConfig> {
    // @MX:WARN editor-config 토큰체인(makers /token,/editor,/template/hit)은 BFF/어댑터 책임(O3).
    // fixture 단계는 정적 config stub. 실 토큰 발급은 후니 BFF 에서. token 은 메모리만(노출 금지).
    return {
      side,
      psCode: `EDICUS_STUB@${code}`,
      templateUrl: 'gcs://huni-widget-fixture/template.json',
      resourceId: 0,
      token: 'FIXTURE_STUB_TOKEN',
      pluginCustomData: { source: 'fixture' },
    };
  }

  async postCartHandoff(
    _payload: NormalizedCartHandoff,
  ): Promise<{ ok: boolean; redirectUrl?: string }> {
    // [UNDECIDED 커머스] fixture stub. 정규화 경계에서 종료.
    return { ok: true };
  }
}
