// Wave C 의류 clothes2025 경로 — apparel_info → 정규화 OptionGroup (어댑터 책임, 위젯은 결과만).
//  Red Apparel 메인(deob_07:830~1148)은 조건부 렌더트리: 각 자식 = data.apparel_info?.X ? render.
//  sizeSelectionMode(deob_07:937): PRINT_GBN==='N'→single / COD==='PTP_SLK'→multi+팬톤 / else single.
//  근거: major_apparel_CLSTSHS.json apparel_info 6블록, red-code-map-07 §1-A/§4-C.
//  [HARD] 위젯 무계산 — 어댑터가 PRINT_TYPE 분기·visibilityRules·KOI영역키를 OptionGroup 으로 평면화.
import type { OptionGroup, OptionValue, VisibilityRule } from '@/contract';

// apparel_info 블록 shape (Red 원시 — 이 파일 + red-types 안에만).
export interface ApparelInfo {
  print_type?: Array<{ COD: string; COD_NME: string; USE_YN?: string; order?: number }>;
  print_area?: Array<{ COD: string; COD_NME: string; ORD?: number; KOI_NME?: string }>;
  apparel_color?: Array<{ COD: string; COD_NME: string; HEX?: string; DEFAULT?: string; HIDE_YN?: string }>;
  size_info?: Array<{ COD: string; COD_NME: string; ORD?: number; GBN?: string }>;
  size_color_info?: Array<{
    COD: string; COD_NME: string; HEX?: string; GBN?: string;
    CLR_COD?: string; CLR_COD_NME?: string; HIDE_YN?: string; QUICK_ORD_YN?: string; MTRL_COD?: string;
  }>;
  pantone_color?: Array<{ pantone_name: string; rgb_R?: string; rgb_G?: string; rgb_B?: string; hex_cod?: string }>;
}

const SILK_PRINT_TYPE = 'PTP_SLK'; // 실크/날염 — multi-size + 팬톤 전용 모드(deob_07:937)
// 의류 OptionGroup id 규칙(안정 키). __ 접두로 PCS_/GRP_ 와 구분.
export const APPAREL_GROUP = {
  printType: 'APP_PRINT_TYPE',
  printArea: 'APP_PRINT_AREA',
  color: 'APP_COLOR',
  size: 'APP_SIZE',
  multiSize: 'APP_MULTI_SIZE',
  pantone: 'APP_PANTONE',
} as const;

export function isApparelItemGroup(itemGroup?: string): boolean {
  return itemGroup != null && itemGroup.startsWith('clothes2025');
}

function pantoneHex(p: { hex_cod?: string }): string | undefined {
  return p.hex_cod || undefined;
}

// apparel_info → OptionGroup[]. PTP_SLK 전용 그룹(multiSize/pantone)은 visible:false 로 생성하고
//  visibilityRules 로 PTP_SLK 선택 시 토글(P4 동적 add/remove 재사용). DTF/DIR 는 color+size 표시.
export function buildApparelGroups(ai: ApparelInfo): {
  groups: OptionGroup[];
  visibilityRules: VisibilityRule[];
} {
  const groups: OptionGroup[] = [];
  const visibilityRules: VisibilityRule[] = [];

  // ① PRINT_TYPE (option-button) — 3분기 트리거. USE_YN!=='N' 만.
  const pts = (ai.print_type ?? []).filter((p) => p.USE_YN !== 'N');
  let silkCod: string | undefined;
  if (pts.length > 0) {
    silkCod = pts.find((p) => p.COD === SILK_PRINT_TYPE)?.COD;
    groups.push({
      id: APPAREL_GROUP.printType,
      side: 'default',
      label: '인쇄 방식',
      componentType: 'option-button',
      required: true,
      visible: true,
      values: pts.map((p) => ({ id: p.COD, label: p.COD_NME, disabled: false })),
    });
  }

  // ② print_area (option-button) — KOI_NME 는 에디터 영역키(불투명 echo, 위젯 무계산).
  const areas = ai.print_area ?? [];
  if (areas.length > 0) {
    groups.push({
      id: APPAREL_GROUP.printArea,
      side: 'default',
      label: '인쇄 위치',
      componentType: 'option-button',
      required: true,
      visible: true,
      // KOI_NME 를 attb 슬롯에 실어 에디터 영역키로 운반(불투명).
      values: areas.map((a) => ({ id: a.COD, label: a.COD_NME, attb: a.KOI_NME, disabled: false })),
    });
  }

  // ③ apparel_color (color-chip, HEX) — DTF/DIR 표시. SLK 는 size_color matrix 가 색을 흡수.
  const colors = (ai.apparel_color ?? []).filter((c) => c.HIDE_YN !== 'Y');
  if (colors.length > 0) {
    groups.push({
      id: APPAREL_GROUP.color,
      side: 'default',
      label: '색상',
      componentType: 'color-chip',
      required: true,
      visible: true,
      values: colors.map((c) => ({ id: c.COD, label: c.COD_NME, colorHex: c.HEX, disabled: false })),
    });
  }

  // ④ size_info (option-button) — single-size 모드(DTF/DIR). GBN(adult/child) 라벨 echo.
  const sizes = ai.size_info ?? [];
  if (sizes.length > 0) {
    groups.push({
      id: APPAREL_GROUP.size,
      side: 'default',
      label: '사이즈',
      componentType: 'option-button',
      required: true,
      visible: true,
      values: sizes.map((s) => ({ id: s.COD, label: s.COD_NME, disabled: false })),
    });
  }

  // ⑤ size_color matrix (counter-input 멀티 — multiple) — SLK 전용. 기본 숨김 + PTP_SLK 토글.
  //   사이즈×색 조합(227)을 멀티선택 후보로(MultiCheckGroup 재사용). 수량 테이블은 후속(가격캡처 필요).
  const sc = (ai.size_color_info ?? []).filter((s) => s.HIDE_YN !== 'Y');
  if (sc.length > 0 && silkCod) {
    const values: OptionValue[] = sc.map((s) => ({
      id: `${s.CLR_COD ?? ''}_${s.COD}`,
      label: `${s.CLR_COD_NME ?? ''} ${s.COD_NME}`.trim(),
      colorHex: s.HEX ? (s.HEX.startsWith('#') ? s.HEX : `#${s.HEX}`) : undefined,
      disabled: s.QUICK_ORD_YN === 'N', // 퀵오더 불가 = 비활성(재고)
    }));
    groups.push({
      id: APPAREL_GROUP.multiSize,
      side: 'default',
      label: '사이즈·색상 (수량)',
      componentType: 'finish-button', // multiple → MultiCheckGroup 렌더(L-3a 재사용, 신규 leaf 0)
      required: false,
      visible: false, // SLK 선택 시 visibilityRules 로 표시
      multiple: true,
      values,
    });
    visibilityRules.push({ triggerValueId: silkCod, showsGroupId: APPAREL_GROUP.multiSize });
  }

  // ⑥ pantone_color (color-chip) — SLK 전용. 1124색 → color-chip(모달은 후속, 본 패스는 그리드 흡수).
  const pantone = ai.pantone_color ?? [];
  if (pantone.length > 0 && silkCod) {
    // 1124 전량 렌더는 과하므로 어댑터가 그대로 노출하되 위젯은 동적 .map(시각재현서 가상스크롤 후보).
    groups.push({
      id: APPAREL_GROUP.pantone,
      side: 'default',
      label: '팬톤 컬러',
      componentType: 'color-chip',
      required: false,
      visible: false, // SLK 선택 시 토글
      values: pantone.map((p) => ({ id: p.pantone_name, label: p.pantone_name, colorHex: pantoneHex(p), disabled: false })),
    });
    visibilityRules.push({ triggerValueId: silkCod, showsGroupId: APPAREL_GROUP.pantone });
  }

  return { groups, visibilityRules };
}
