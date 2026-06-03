// L-12 ACC 부자재 — accFilterConfigMap(K_) 번들상수 이식 (mod_05:2189 권위).
//  Red 는 부자재 다단 캐스케이드/멀티 config 를 product_info 가 아니라 Vue 번들 상수 K_ 에 둔다
//  (major-capture-note §4 결정적 진단: probe 6상품에 미발현, 번들 상수 의존 확정).
//  키: pdtCode → pttCode → {uiType:'CASCADE'|'MULTI', filters[]}.
//  [컨버전] 후니가 부자재 config 를 옵션데이터로 주면 그 경로로 대체, 본 상수맵은 Red fallback.
//  현재 번들 등록 상품: GSSBMTL(4 ptt CASCADE), GSSBSTP(1 CASCADE + 1 MULTI). 그 외 부자재는
//  단순 SUM_MTR add-on(finish-button 흡수, ACPDSTD 류) — 본 맵 미등록.
import type { ComponentType } from '@/contract';

export type AccGrpType = 'MTRL_GRP' | 'MTRL_SUB_GRP' | 'MTRL_MULTI_GRP';
export interface AccFilterOption {
  COD: string;
  COD_NME: string;
}
export interface AccFilter {
  GRP_TYPE: AccGrpType;
  GRP_NME: string;
  GRP_COD?: string; // MTRL_MULTI_GRP 의 자재그룹 코드
  options?: AccFilterOption[]; // 정적 옵션. 부재(MTRL_SUB_GRP 기종/패턴 등)면 상위선택 의존(동적).
}
export interface AccFilterConfig {
  uiType: 'CASCADE' | 'MULTI';
  filters: AccFilter[];
}

// mod_05:2189 K_ 실측 전수 이식(2 상품 6 config).
export const ACC_FILTER_CONFIG_MAP: Record<string, Record<string, AccFilterConfig>> = {
  GSSBMTL: {
    '37': {
      uiType: 'CASCADE',
      filters: [
        { GRP_TYPE: 'MTRL_GRP', GRP_NME: '컬러', options: [
          { COD: 'SMT_BRW', COD_NME: '브라운' }, { COD: 'SMT_BLK', COD_NME: '블랙' },
          { COD: 'SMT_BLU', COD_NME: '블루' }, { COD: 'SMT_YEL', COD_NME: '옐로우' },
          { COD: 'SMT_GRE', COD_NME: '그린' } ] },
        { GRP_TYPE: 'MTRL_SUB_GRP', GRP_NME: '불박 후가공', options: [
          { COD: '세로형', COD_NME: '세로형' }, { COD: '가로형', COD_NME: '가로형' },
          { COD: 'NONE', COD_NME: '불박 안함' } ] },
      ],
    },
    '38': {
      uiType: 'CASCADE',
      filters: [
        { GRP_TYPE: 'MTRL_GRP', GRP_NME: '컬러', options: [
          { COD: 'SMT_BLK', COD_NME: '블랙' }, { COD: 'SMT_BLU', COD_NME: '블루' },
          { COD: 'SMT_GRY', COD_NME: '그레이' }, { COD: 'SMT_RED', COD_NME: '레드' },
          { COD: 'SMT_YEL', COD_NME: '옐로우' } ] },
        { GRP_TYPE: 'MTRL_SUB_GRP', GRP_NME: '불박 후가공', options: [
          { COD: '세로형', COD_NME: '세로형' }, { COD: '가로형', COD_NME: '가로형' },
          { COD: 'NONE', COD_NME: '불박 안함' } ] },
      ],
    },
    '19': {
      uiType: 'CASCADE',
      filters: [
        { GRP_TYPE: 'MTRL_GRP', GRP_NME: '제조사', options: [
          { COD: 'SMT_001', COD_NME: '애플' }, { COD: 'SMT_002', COD_NME: '삼성' } ] },
        { GRP_TYPE: 'MTRL_SUB_GRP', GRP_NME: '기종' }, // 옵션 부재 → 상위(제조사) 의존(동적)
      ],
    },
    '61': {
      uiType: 'CASCADE',
      filters: [
        { GRP_TYPE: 'MTRL_GRP', GRP_NME: '사이즈', options: [
          { COD: 'SMT_579', COD_NME: '57x90' }, { COD: 'SMT_679', COD_NME: '67x94' } ] },
        { GRP_TYPE: 'MTRL_SUB_GRP', GRP_NME: '패턴' },
      ],
    },
  },
  GSSBSTP: {
    '3': {
      uiType: 'CASCADE',
      filters: [
        { GRP_TYPE: 'MTRL_GRP', GRP_NME: '종류', options: [
          { COD: 'SMT_SS3', COD_NME: 'S-300' }, { COD: 'SMT_SS4', COD_NME: 'S-400' } ] },
        { GRP_TYPE: 'MTRL_SUB_GRP', GRP_NME: '컬러' },
      ],
    },
    '8': {
      uiType: 'MULTI',
      filters: [
        { GRP_TYPE: 'MTRL_MULTI_GRP', GRP_NME: '잉크', GRP_COD: 'SMT_ISB' },
        { GRP_TYPE: 'MTRL_MULTI_GRP', GRP_NME: '진공패드', GRP_COD: 'SMT_VPD' },
        { GRP_TYPE: 'MTRL_MULTI_GRP', GRP_NME: '희석제', GRP_COD: 'SMT_DLU' },
      ],
    },
  },
};

// (pdtCode, pttCode) → 부자재 config. 미등록이면 undefined(단순 SUM_MTR add-on 경로).
export function accFilterConfig(pdtCode: string, pttCode?: string): AccFilterConfig | undefined {
  return ACC_FILTER_CONFIG_MAP[pdtCode]?.[pttCode ?? ''];
}

// 부자재 패널은 finish-button/select 가 아니라 다단 종속 UI(신규 leaf 'acc-panel'). componentType 매핑.
export const ACC_PANEL_COMPONENT_TYPE: ComponentType = 'acc-panel';
