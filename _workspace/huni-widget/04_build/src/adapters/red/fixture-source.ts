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
// S2 스티커(02) fixture — PriceTable3D 변형(THO_DFT 모양커팅 + 소재) + FixedUnit(vTmpl_price 시트가).
import productSTTHCIC from '../../../fixtures/product_STTHCIC.json'; // 원형 스티커(규격, digital_price)
import productSTCUXXX from '../../../fixtures/product_STCUXXX.json'; // 사각반칼 스티커(사이즈직접입력, digital_price)
import productSTPADPN from '../../../fixtures/product_STPADPN.json'; // DTF 판스티커(시트, vTmpl_price/FixedUnit)
// S3 포스터·실사·사인·배너(04·05) fixture — SizeMatrix2D(가로×세로). 자유입력+규격프리셋. NC-1 근거.
import productBNBNFBL from '../../../fixtures/product_BNBNFBL.json'; // 현수막(real_price, MAX_CUT 5000, 자유입력 W/H)
import productBNPTPET from '../../../fixtures/product_BNPTPET.json'; // PET 배너(real_price, 가공옵션 COT_DFT/타공)
import priceQ30 from '../../../fixtures/price_q30_p10.json';
import priceQ300 from '../../../fixtures/price_q300_p10.json';
import priceDigital from '../../../fixtures/price_BCSPDFT_sample.json';
import priceSticker from '../../../fixtures/price_STTHCIC_sample.json'; // 반칼/규격 스티커 digital_price (비로그인 PRICE=0)
import priceStickerFixed from '../../../fixtures/price_STPADPN_sample.json'; // FixedUnit vTmpl_price — 실 시트가 PRICE=4000(비로그인 공개가)
import priceBanner from '../../../fixtures/price_BNBNFBL_sample.json'; // S3 SizeMatrix2D real_price — CUT_WDT=5000/CUT_HGH=900 수치 직접전달. 비로그인 PRICE=0(shape 검증)
import presignedSample from '../../../fixtures/presigned_response_sample.json';

const PRODUCTS: Record<string, unknown> = {
  PRBKYPR: productPRBKYPR,
  GSTGMIC: productGSTGMIC,
  ACNTHAP: productACNTHAP,
  // S1 디지털인쇄
  BCSPDFT: productBCSPDFT, // 일반 명함 (단/양면)
  BCSPWHT: productBCSPWHT, // 화이트인쇄(별색) 컬러명함
  PRPOXXX: productPRPOXXX, // 종이 포스터/엽서류
  // S2 스티커(02)
  STTHCIC: productSTTHCIC, // 원형 스티커(규격: 11 size + THO_DFT 원형 모양커팅, digital_price)
  STCUXXX: productSTCUXXX, // 사각반칼 스티커(사이즈직접입력 + THO_DFT 사각, digital_price)
  STPADPN: productSTPADPN, // DTF 판스티커(시트단위 vTmpl_price = FixedUnit, fir=1)
  // S3 포스터·실사·사인·배너(04·05) — SizeMatrix2D(가로×세로 수치 직접전달)
  BNBNFBL: productBNBNFBL, // 현수막(real_price, 자유입력 W/H + 규격프리셋, MAX_CUT 5000)
  BNPTPET: productBNPTPET, // PET 배너(real_price, 가공옵션 PCS_INFO)
};

// 디지털인쇄/스티커 단일면 상품 prefix(BC=명함, PR=엽서/포스터, NC=카드, ST=스티커). fixture 가격 근사 선택용.
const DIGITAL_PRINT_PREFIX = /^(BC|PR|NC|ST)/;
// FixedUnit(vTmpl_price) 시트가 상품 — price_gbn 으로 분기. ST DTF 판/네임스티커 등.
const FIXED_UNIT_CODES = new Set(['STPADPN', 'STPADNM']);

export class FixtureRedDataSource implements RedDataSource {
  async fetchProduct(code: string): Promise<RedDigitalProductResponse> {
    const p = PRODUCTS[code] ?? productPRBKYPR;
    return p as RedDigitalProductResponse;
  }

  async fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse> {
    // FixedUnit(vTmpl_price) 시트가 — 응답 envelope 동일(ORD_INFO/PCS_INFO→result/result_sum),
    // 위젯은 price_gbn 무관·불투명 finalPrice 만 소비(INV-1). 캡처는 PRICE=4000(공개 시트가).
    // @MX:NOTE S2 FixedUnit fixture 만 비로그인에도 실가(공개가) — digital_price 와 응답 shape 동일.
    if (FIXED_UNIT_CODES.has(req.productCode)) {
      return priceStickerFixed as RedPriceResponse;
    }
    // 스티커(ST) PriceTable3D 변형 — digital_price, THO_DFT 라인 포함. 비로그인 PRICE=0(shape 검증용).
    if (req.productCode.startsWith('ST')) {
      return priceSticker as RedPriceResponse;
    }
    // S3 배너/현수막(BN) — SizeMatrix2D real_price. CUT_WDT/CUT_HGH 수치 직접전달 응답 shape.
    // @MX:NOTE SizeMatrix2D 단가는 BFF 권위(INV-1). fixture 는 비로그인 PRICE=0(shape 검증).
    if (req.productCode.startsWith('BN')) {
      return priceBanner as RedPriceResponse;
    }
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
