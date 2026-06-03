// data-contract.md §3 — 가격 계약 (서버 권위, Red-shape 중립).
// [HARD] 위젯은 단가/공식 없음. 가격은 불투명 결과값. 계약 필드명에 Red/후니 고유명 없음.
import type { SideKey } from './product';

export interface PriceDimension {
  side: SideKey;
  cutW: number;
  cutH: number;
  workW: number;
  workH: number;
}

export interface SelectedFinish {
  groupId: string;
  valueId: string;
  // L-1 ATTB: 후가공별로 (a)속성칩 선택값 (b)수량 echo 등 다형 불투명 문자열. 위젯은 의미 무계산·운반만.
  //  OPTIONAL·additive — 미보유 후가공은 undefined(직렬화 시 ATTB:'' 하위호환). 사이즈연동 반경(ROU/L-3)은
  //  본 BLOCKER 범위 밖(attb 슬롯만 준비). attb2/attb3 = SUB_MTR 류의 ATTB_2/ATTB_3 빈슬롯(현 빈값).
  attb?: string;
  attb2?: string;
  attb3?: string;
}

export interface NormalizedPriceRequest {
  productCode: string;
  priceSchemeKey: string; // 불투명 echo
  // D-L2: itemGroup 불투명 echo — 어댑터 직렬화의 ORD_INFO 스키마 분기 권위(book2025=책자 분리필드).
  //  OPTIONAL·additive. 미전달 시 isBook 형상 휴리스틱 fallback.
  itemGroup?: string;
  customerTier?: string; // 불투명 (기본 어댑터가 채움)
  dimensions: PriceDimension[]; // side별
  colorCounts: Partial<Record<SideKey, number>>;
  materials: Partial<Record<SideKey, string>>; // 불투명 자재 id
  quantity: number; // 주문건수(굿즈=디자인 수). 어댑터가 ORD_CNT 로 직렬화.
  // S5: 인쇄수량(개당단가 정수배 인자). 굿즈/파우치(tmpl/tiered_price)에서만 의미.
  // [HARD] 중립 도메인명(Red PRN_CNT 아님). optional → S0~S4 미전달 시 undefined(하위호환, 회귀 0).
  // 위젯은 echo 도 안 함(현 stage UI 미노출) — 어댑터 직렬화가 quantity↔ORD_CNT / printCount↔PRN_CNT 분리.
  printCount?: number;
  pageCount?: number; // 책자
  selectedFinishes: SelectedFinish[];
}

export interface PriceLine {
  code: string;
  label: string; // 한글 label (백엔드/어댑터가 채움)
  amount: number;
}

export interface NormalizedPriceBreakdown {
  ok: boolean;
  finalPrice: number; // 결제금액(부가세 별산 전). 산정 방식은 백엔드/어댑터 영역.
  vat: number;
  shipping: number;
  lines: PriceLine[]; // 공정별 분해 (선택적 투명성 표시 — DESIGN Summary)
  raw?: unknown; // 디버그용 (위젯은 안 씀)
  // [HARD 도메인] RedPrinting 위젯은 PRICE=0 을 정상 반환하지 않는다 — 0 은 항상 우리측
  //  요청/세션/스펙선택 결함 신호. finalPrice=0 일 때 어댑터가 진단 사유를 채운다(정상 빈상태로 침묵 금지).
  //  OPTIONAL·additive — PRICE>0 이면 undefined. 위젯은 표시/로깅에만 사용(가격 계산 안 함).
  priceUnavailableReason?: string;
}
