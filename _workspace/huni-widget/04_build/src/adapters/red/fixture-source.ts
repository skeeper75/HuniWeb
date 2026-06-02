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
// S1 디지털인쇄(명함·엽서) fixture — 단일면, 내지 분리 없음, 별색 finish 그룹 포함.
import productBCSPDFT from '../../../fixtures/product_BCSPDFT.json';
import productBCSPWHT from '../../../fixtures/product_BCSPWHT.json';
import productPRPOXXX from '../../../fixtures/product_PRPOXXX.json';
import priceQ30 from '../../../fixtures/price_q30_p10.json';
import priceQ300 from '../../../fixtures/price_q300_p10.json';
import priceDigital from '../../../fixtures/price_BCSPDFT_sample.json';
import presignedSample from '../../../fixtures/presigned_response_sample.json';

const PRODUCTS: Record<string, unknown> = {
  PRBKYPR: productPRBKYPR,
  GSTGMIC: productGSTGMIC,
  ACNTHAP: productACNTHAP,
  // S1 디지털인쇄
  BCSPDFT: productBCSPDFT, // 일반 명함 (단/양면)
  BCSPWHT: productBCSPWHT, // 화이트인쇄(별색) 컬러명함
  PRPOXXX: productPRPOXXX, // 종이 포스터/엽서류
};

// 디지털인쇄 단일면 상품 prefix(BC=명함, PR=엽서/포스터/카드). fixture 가격 근사 선택용.
const DIGITAL_PRINT_PREFIX = /^(BC|PR|NC)/;

export class FixtureRedDataSource implements RedDataSource {
  async fetchProduct(code: string): Promise<RedDigitalProductResponse> {
    const p = PRODUCTS[code] ?? productPRBKYPR;
    return p as RedDigitalProductResponse;
  }

  async fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse> {
    // 디지털인쇄(명함·엽서)는 digital_price 응답 shape fixture 로 — 책자 워터폴과 응답 형태 구분.
    // @MX:NOTE 디지털인쇄 price fixture 는 비로그인 캡처라 PRICE=0(shape 검증용). 실 단가는 BFF 권위.
    if (DIGITAL_PRINT_PREFIX.test(req.productCode)) {
      return priceDigital as RedPriceResponse;
    }
    // 책자 fixture 는 수량별 2종 → quantity 로 근사 선택(검증 목적).
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
