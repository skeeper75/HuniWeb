// data-adapter.md §3 — componentType 매핑 규칙 (어댑터 결정 로직).
// [결정] 위젯이 아니라 어댑터가 "Red 데이터셋 → componentType" 을 결정. 룩업 테이블이면 충분(과한 휴리스틱 금지).
import type { ComponentType } from '@/contract';

// Red 논리 데이터셋 키 → componentType.
// PCS 그룹은 색상 여부에 따라 color-chip 분기가 필요하므로 별도 함수에서 처리.
export const DATASET_COMPONENT_TYPE: Record<string, ComponentType> = {
  size: 'option-button', // pdt_size_info (값 ≤ ~6, 텍스트)
  material: 'select-box', // pdt_mtrl_info (값 多)
  dosu: 'option-button', // pdt_dosu_info (단면/양면)
  quantity: 'counter-input', // pdt_base_info FIR/INC
  innerPage: 'page-counter-input', // 내지 페이지수 min/max/step
};

// 후가공(PCS) 그룹의 componentType 결정: 색상값(colorHex)이 있으면 color-chip, 아니면 finish-button.
export function pcsComponentType(hasColor: boolean): ComponentType {
  return hasColor ? 'color-chip' : 'finish-button';
}

// L-4: 색상 후가공 hex 상수맵 — Red 는 색 hex 를 옵션데이터가 아니라 컴포넌트 내부 상수맵에 둔다
//  (deob_07:2511~2522). PCS_CD 별로 {PCS_DTL_CD → hex} 룩업. END_PAP(면지) 10색이 첫 엔트리.
//  [컨버전] 후니가 hex 를 옵션필드(CLR_HEX_CD)로 주면 그 경로가 우선, 본 상수맵은 Red fallback.
//  근거: D4 SPEC-L4, fixtures/product_PRBKYPR.json END_PAP 10색(CLYEL/CLMIN/...).
export const PCS_COLOR_HEX: Record<string, Record<string, string>> = {
  END_PAP: {
    CLYEL: '#fdeec5',
    CLMIN: '#d5edea',
    CLWHT: '#ffffff',
    CLPPL: '#e0def0',
    CLPIN: '#f6e6f1',
    CLAPR: '#fde7dc',
    CLGRN: '#e4f2e8',
    CLBLU: '#adccec',
    CLSKY: '#bae5fb',
    CLGRY: '#ededee',
  },
};

// PCS_CD 가 색상 후가공(hex 상수맵 보유)이면 그 맵을 반환.
export function pcsColorHexMap(pcsCd: string): Record<string, string> | undefined {
  return PCS_COLOR_HEX[pcsCd];
}

// L-3b: ROU_DFT 라운딩 반경 상수맵 — Red 는 반경(mm)을 product_info 가 아니라 Vue 번들 상수
//  roundingConfigMap(Yr) 에 둔다(mod_05:1670 권위). factor==='size' 면 사이즈(DIV_SEQ)별 반경,
//  그 외/미등록 상품은 고정 4mm/6mm 라디오(default '4'). 캡처로는 채울 수 없어 번들 상수 이식이 유일 경로
//  (major-capture-note §2 결정적 진단). 현재 번들에 등록된 상품은 GSCDPOP 1종뿐.
//  [컨버전] 후니가 반경을 옵션필드로 주면 그 경로로 대체, 본 상수맵은 Red fallback.
export interface RoundingConfig {
  factor: 'size' | string; // 'size' 면 DIV_SEQ→반경, 아니면 고정 라디오
  value: Record<string, string>; // DIV_SEQ(문자열 키) → 반경(mm 문자열)
}
export const ROUNDING_CONFIG_MAP: Record<string, RoundingConfig> = {
  // mod_05:1670 Yr 실측: GSCDPOP 만 등록(DIV_SEQ 1→3mm / 2→6mm).
  GSCDPOP: { factor: 'size', value: { '1': '3', '2': '6' } },
};

// 고정(비-size) 라운딩 기본 반경 — Red 4mm/6mm 라디오 default 첫값(mod_07:3320 default '4').
export const ROUNDING_DEFAULT_RADIUS = '4';

// 라운딩 반경 산출(mod_07:3300~3344 로직 이식):
//  factor==='size' && divSeq 보유 → value[divSeq]. 그 외 → 고정 default '4'.
//  미등록 상품(맵에 없음) → 고정 default '4'(BCFOXXX/BCSPDFT 가 여기 해당, 번들 미등록).
export function roundingRadius(pdtCode: string, divSeq?: number | string): string {
  const cfg = ROUNDING_CONFIG_MAP[pdtCode];
  if (cfg && cfg.factor === 'size' && divSeq != null) {
    return cfg.value[String(divSeq)] ?? ROUNDING_DEFAULT_RADIUS;
  }
  return ROUNDING_DEFAULT_RADIUS;
}
