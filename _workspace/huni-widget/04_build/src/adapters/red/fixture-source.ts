// Fixture 기반 RedDataSource — 라이브 캡처(fixtures/*.json)로 위젯을 검증.
// 데이터소스 토글(fixture↔실 BFF)은 주입으로 분리(이 클래스 vs 실 HTTP 소스).
import type {
  NormalizedPriceRequest,
  NormalizedPresignedRequest,
  NormalizedEditorConfig,
  NormalizedCartHandoff,
  NormalizedOrderReadiness,
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
// B1 SizeMatrix2D 대표 — 에코백(real_price, 등록규격 300X340 → PRICE=3300). 게이트 F-1.
import productAIPPCUT from '../../../fixtures/product_AIPPCUT.json';
// S1 디지털인쇄(명함·엽서) fixture — 단일면, 내지 분리 없음, 별색 finish 그룹 포함.
import productBCSPDFT from '../../../fixtures/product_BCSPDFT.json';
import productBCSPWHT from '../../../fixtures/product_BCSPWHT.json';
import productPRPOXXX from '../../../fixtures/product_PRPOXXX.json';
// S3 MAJOR L-3a — 박/형압 명함(ROU_DFT 4귀 멀티 + FOI 박 속성칩). digital_price.
import productBCFOXXX from '../../../fixtures/product_BCFOXXX.json';
// S2 스티커(02) fixture — PriceTable3D 변형(THO_DFT 모양커팅 + 소재) + FixedUnit(vTmpl_price 시트가).
import productSTTHCIC from '../../../fixtures/product_STTHCIC.json'; // 원형 스티커(규격, digital_price)
import productSTCUXXX from '../../../fixtures/product_STCUXXX.json'; // 사각반칼 스티커(사이즈직접입력, digital_price)
import productSTPADPN from '../../../fixtures/product_STPADPN.json'; // DTF 판스티커(시트, vTmpl_price/FixedUnit)
// S3 포스터·실사·사인·배너(04·05) fixture — SizeMatrix2D(가로×세로). 자유입력+규격프리셋. NC-1 근거.
import productBNBNFBL from '../../../fixtures/product_BNBNFBL.json'; // 현수막(real_price, MAX_CUT 5000, 자유입력 W/H)
import productBNPTPET from '../../../fixtures/product_BNPTPET.json'; // PET 배너(real_price, 가공옵션 COT_DFT/타공)
// S5 파우치(11번 굿즈/파우치) fixture — tmpl_price(룩업 평탄단가), 규격 5종 폐쇄 enum + 치수 자동주입.
import productGSPUFBC from '../../../fixtures/product_GSPUFBC.json'; // 노트북-태블릿 파우치(tmpl_price, NO_STD_ABL_YN=N)
// S6 옵셋 캘린더(09) fixture — offset2023_price PriceTable3D 변형(책자형). ORD_INFO 책자와 동일.
//  PRN_CNT 폐쇄 래더(FIR/INC null) → select-box enum(어댑터). CLD_STD/CUT_DFT/RIN_DFT = 기존 PCS finish-button.
import productHLCLSTD from '../../../fixtures/product_HLCLSTD.json'; // 탁상용 캘린더(규격 4종, PRN_CNT 래더 10종, CLD_STD 12종)
import productHLCLWAL from '../../../fixtures/product_HLCLWAL.json'; // 벽걸이 캘린더(규격 3종, PRN_CNT 단일행, HOL_DFT/RIN_CUT 후가공)
// Wave C 의류/ACC fixture.
import productCLSTSHS from '../../../fixtures/product_CLSTSHS.json'; // 의류(clothes2025, apparel_info 6블록 — PRINT_TYPE 3분기)
import productACPDSTD from '../../../fixtures/product_ACPDSTD.json'; // ACC 단순 add-on(SUM_MTR 12옵션 finish-button 흡수)
import productGSSBMTL from '../../../fixtures/product_GSSBMTL.json'; // ACC 다단 캐스케이드(ptt_cod=37 → accFilterConfigMap CASCADE)
import priceQ30 from '../../../fixtures/price_q30_p10.json';
import priceQ300 from '../../../fixtures/price_q300_p10.json';
import priceDigital from '../../../fixtures/price_BCSPDFT_sample.json';
import priceSticker from '../../../fixtures/price_STTHCIC_sample.json'; // 반칼/규격 스티커 digital_price (비로그인 PRICE=0)
import priceStickerFixed from '../../../fixtures/price_STPADPN_sample.json'; // FixedUnit vTmpl_price — 실 시트가 PRICE=4000(비로그인 공개가)
import priceEcobag from '../../../fixtures/price_AIPPCUT_sample.json'; // B1 SizeMatrix2D real_price — 등록규격 300X340 → PRICE=3300(공개가, 룩업 단가)
import priceBanner from '../../../fixtures/price_BNBNFBL_sample.json'; // S3 SizeMatrix2D real_price — CUT_WDT=5000/CUT_HGH=900 수치 직접전달. 비로그인 PRICE=0(shape 검증)
import pricePouch from '../../../fixtures/price_GSPUFBC_sample.json'; // S5 tmpl_price — 11in세로 ORD_CNT=100 PRN_CNT=1 → PRICE=2,850,000(로그인 실가, 평탄단가)
import priceCalendarStd from '../../../fixtures/price_HLCLSTD_sample.json'; // S6 offset2023_price — 세로형 PRN_CNT=500/ORD_CNT=1 → PRICE=778,500(로그인 실가, 책자 envelope)
import priceCalendarWal from '../../../fixtures/price_HLCLWAL_sample.json'; // S6 offset2023_price — PRN_CNT=500/ORD_CNT=1 → PRICE=2,368,500(로그인 실가)
import presignedSample from '../../../fixtures/presigned_response_sample.json';

const PRODUCTS: Record<string, unknown> = {
  PRBKYPR: productPRBKYPR,
  GSTGMIC: productGSTGMIC,
  ACNTHAP: productACNTHAP,
  // B1 SizeMatrix2D 대표 — 에코백(real_price, 0×0 sentinel→dimension-matrix, 등록규격 300X340)
  AIPPCUT: productAIPPCUT,
  // S1 디지털인쇄
  BCSPDFT: productBCSPDFT, // 일반 명함 (단/양면)
  BCSPWHT: productBCSPWHT, // 화이트인쇄(별색) 컬러명함
  PRPOXXX: productPRPOXXX, // 종이 포스터/엽서류
  BCFOXXX: productBCFOXXX, // 박/형압 명함(L-3a ROU_DFT 4귀 멀티 + FOI 박 속성칩)
  // S2 스티커(02)
  STTHCIC: productSTTHCIC, // 원형 스티커(규격: 11 size + THO_DFT 원형 모양커팅, digital_price)
  STCUXXX: productSTCUXXX, // 사각반칼 스티커(사이즈직접입력 + THO_DFT 사각, digital_price)
  STPADPN: productSTPADPN, // DTF 판스티커(시트단위 vTmpl_price = FixedUnit, fir=1)
  // S3 포스터·실사·사인·배너(04·05) — SizeMatrix2D(가로×세로 수치 직접전달)
  BNBNFBL: productBNBNFBL, // 현수막(real_price, 자유입력 W/H + 규격프리셋, MAX_CUT 5000)
  BNPTPET: productBNPTPET, // PET 배너(real_price, 가공옵션 PCS_INFO)
  // S5 굿즈/파우치(11)
  GSPUFBC: productGSPUFBC, // 노트북-태블릿 파우치(tmpl_price, 규격 5종 폐쇄 enum, 치수 자동주입)
  // S6 캘린더(09) — offset2023_price PriceTable3D 변형(책자형)
  HLCLSTD: productHLCLSTD, // 탁상용 캘린더(PRN_CNT 폐쇄 래더 10종 + CLD_STD 12종 finish)
  HLCLWAL: productHLCLWAL, // 벽걸이 캘린더(PRN_CNT 단일행 + HOL_DFT/RIN_CUT 후가공)
  // Wave C 의류/ACC
  CLSTSHS: productCLSTSHS, // 의류(clothes2025) — apparel_info 분기
  ACPDSTD: productACPDSTD, // ACC 단순 add-on(SUM_MTR)
  GSSBMTL: productGSSBMTL, // ACC 다단 캐스케이드(accFilterConfigMap CASCADE)
};

// 디지털인쇄/스티커 단일면 상품 prefix(BC=명함, PR=엽서/포스터, NC=카드, ST=스티커). fixture 가격 근사 선택용.
const DIGITAL_PRINT_PREFIX = /^(BC|PR|NC|ST)/;
// FixedUnit(vTmpl_price) 시트가 상품 — price_gbn 으로 분기. ST DTF 판/네임스티커 등.
const FIXED_UNIT_CODES = new Set(['STPADPN', 'STPADNM']);

export class FixtureRedDataSource implements RedDataSource {
  async fetchProduct(code: string): Promise<RedDigitalProductResponse> {
    // [HARD] 미보유 productCode 는 명시적 에러 — 침묵 PRBKYPR(책자) 폴백 금지(게이트 F-1).
    //  이전엔 `?? productPRBKYPR` 폴백으로 AIPPCUT 등이 책자 구조로 가장(masquerade) → 검증 공허화.
    //  fixture 미보유 상품은 "unknown product"로 표면화(어댑터/BFF 경계 책임).
    const p = PRODUCTS[code];
    if (!p) {
      throw new Error(`[fixture] unknown product "${code}" — no fixture (silent PRBKYPR fallback removed, F-1)`);
    }
    return p as RedDigitalProductResponse;
  }

  async fetchPrice(req: NormalizedPriceRequest): Promise<RedPriceResponse> {
    // FixedUnit(vTmpl_price) 시트가 — 응답 envelope 동일(ORD_INFO/PCS_INFO→result/result_sum),
    // 위젯은 price_gbn 무관·불투명 finalPrice 만 소비(INV-1). 캡처는 PRICE=4000(공개 시트가).
    // @MX:NOTE S2 FixedUnit fixture 만 비로그인에도 실가(공개가) — digital_price 와 응답 shape 동일.
    if (FIXED_UNIT_CODES.has(req.productCode)) {
      return priceStickerFixed as RedPriceResponse;
    }
    // B1 에코백(AIPPCUT) — SizeMatrix2D real_price. 등록규격 300X340 → PRICE=3300(공개 룩업단가).
    // @MX:NOTE real_price 는 등록 (규격×자재) 그리드 룩업(off-grid=0). 단가는 BFF 권위(INV-1).
    if (req.productCode === 'AIPPCUT') {
      return priceEcobag as RedPriceResponse;
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
    // S5 파우치(GSPU) — tmpl_price 룩업 평탄단가. 로그인 실가(PRICE>0) 캡처 fixture.
    // @MX:NOTE tmpl_price 단가는 (규격+PRN_CNT) 룩업으로 BFF 결정(INV-1). 위젯은 불투명 finalPrice 만.
    if (req.productCode.startsWith('GSPU')) {
      return pricePouch as RedPriceResponse;
    }
    // S6 옵셋 캘린더(HLCL) — offset2023_price PriceTable3D 변형. 책자와 동일 envelope.
    // @MX:NOTE 위젯은 price_gbn 무관·불투명 finalPrice 만(INV-1). 로그인 실가 PRICE>0 캡처(STD 778,500 / WAL 2,368,500).
    if (req.productCode.startsWith('HLCL')) {
      return (req.productCode === 'HLCLWAL' ? priceCalendarWal : priceCalendarStd) as RedPriceResponse;
    }
    // Wave C 의류(CL*)/ACC(AC*·GSSB*) — clothes2025_price/부자재 가격 미캡처(어댑터 경로 0이었음).
    // @MX:NOTE 가격 capture 후속 필요(major-capture-note §5: 의류 가격스윕 별도). 본 패스는 옵션 SHAPE 검증만 —
    //  digital_price shape fixture(비로그인 PRICE=0 → mapPriceResponse ok:false)로 라우팅(가격 날조 금지).
    if (
      req.productCode.startsWith('CL') ||
      req.productCode.startsWith('AC') ||
      req.productCode.startsWith('GSSB')
    ) {
      return priceDigital as RedPriceResponse;
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

  async fetchOrderReadiness(
    payload: NormalizedCartHandoff,
  ): Promise<NormalizedOrderReadiness> {
    // L-D3-1 stub: 실 BFF 는 서버 doc_rev/재고로 판정. fixture 는 가격 스냅샷으로 근사
    //  (finalPrice>0 이면 주문가능) — 후니 배선 시 실 isReadyToOrder 엔드포인트로 교체.
    const ok = (payload.priceSnapshot?.finalPrice ?? 0) > 0;
    return { canOrder: ok, reasons: ok ? [] : ['주문불가-가격'] };
  }

  async postCartHandoff(
    _payload: NormalizedCartHandoff,
  ): Promise<{ ok: boolean; redirectUrl?: string }> {
    // [UNDECIDED 커머스] fixture stub. 정규화 경계에서 종료.
    return { ok: true };
  }
}
