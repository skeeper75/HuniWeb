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
}

export interface NormalizedPriceRequest {
  productCode: string;
  priceSchemeKey: string; // 불투명 echo
  customerTier?: string; // 불투명 (기본 어댑터가 채움)
  dimensions: PriceDimension[]; // side별
  colorCounts: Partial<Record<SideKey, number>>;
  materials: Partial<Record<SideKey, string>>; // 불투명 자재 id
  quantity: number;
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
}
