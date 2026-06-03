// S3 MAJOR Wave C 회귀 가드 — 의류 clothes2025 경로 + ACC 부자재(단순 add-on / 다단 캐스케이드·멀티).
//  CRITERION: 책임/로직/분기 재현 동등(라인 답습 아님).
//  AUTHORITY:
//   - 의류: major_apparel_CLSTSHS.json apparel_info 6블록, red-code-map-07 §1-A/§4-C(sizeSelectionMode)
//   - ACC: mod_05:2189 accFilterConfigMap(K_), red-code-map-07 §2-C(GRP_TYPE 4분기), major_acc_ACPDSTD.json
import { describe, it, expect } from 'vitest';
import { mapProduct } from '@/adapters/red/red-adapter';
import { applyCascade } from '@/widget/stores/cascade';
import { accFilterConfig, ACC_FILTER_CONFIG_MAP } from '@/adapters/red/acc-config';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import productCLSTSHS from '../fixtures/product_CLSTSHS.json';
import productACPDSTD from '../fixtures/product_ACPDSTD.json';
import productGSSBMTL from '../fixtures/product_GSSBMTL.json';

// ─────────────────────────────────────────────────────────────────────────────
// 의류 clothes2025 path
// ─────────────────────────────────────────────────────────────────────────────
describe('의류 clothes2025 — apparel_info → OptionGroup (어댑터 경로 신설)', () => {
  it('itemGroup=clothes2025 → apparel 경로(일반 GRP_SIZE/MTRL 아님)', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    expect(p.itemGroup).toBe('clothes2025_item');
    // 의류 전용 그룹 id(APP_*) — 일반 책자/굿즈 그룹(GRP_SIZE 등) 아님.
    expect(p.optionGroups.some((g) => g.id.startsWith('APP_'))).toBe(true);
    expect(p.optionGroups.some((g) => g.id === 'GRP_SIZE')).toBe(false);
  });

  it('PRINT_TYPE 3분기 option-button (PTP_DTF/PTP_DIR/PTP_SLK)', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    const pt = p.optionGroups.find((g) => g.id === 'APP_PRINT_TYPE')!;
    expect(pt.componentType).toBe('option-button');
    expect(pt.values.map((v) => v.id)).toEqual(expect.arrayContaining(['PTP_DTF', 'PTP_DIR', 'PTP_SLK']));
  });

  it('print_area = option-button + KOI_NME 를 attb(에디터 영역키)로 운반', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    const area = p.optionGroups.find((g) => g.id === 'APP_PRINT_AREA')!;
    expect(area.values.length).toBe(6);
    // KOI_NME 가 attb 로 운반(불투명 echo) — 좌측가슴=leftchest 등.
    expect(area.values.every((v) => typeof v.attb === 'string')).toBe(true);
  });

  it('apparel_color = color-chip(HEX), size_info = option-button(7)', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    const color = p.optionGroups.find((g) => g.id === 'APP_COLOR')!;
    expect(color.componentType).toBe('color-chip');
    expect(color.values[0]?.colorHex).toMatch(/^#/);
    const size = p.optionGroups.find((g) => g.id === 'APP_SIZE')!;
    expect(size.componentType).toBe('option-button');
    expect(size.values.length).toBe(7);
  });

  it('multi-size + pantone 는 PTP_SLK 전용 — 기본 hidden, PTP_SLK 선택 시 visible (sizeSelectionMode)', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    const ms = p.optionGroups.find((g) => g.id === 'APP_MULTI_SIZE')!;
    const pantone = p.optionGroups.find((g) => g.id === 'APP_PANTONE')!;
    // 기본: 숨김(DTF/DIR 모드).
    expect(ms.visible).toBe(false);
    expect(pantone.visible).toBe(false);
    expect(ms.multiple).toBe(true); // 사이즈×색 멀티(MultiCheckGroup 재사용)
    // visibilityRules: PTP_SLK → 둘 다 표시.
    const rules = p.constraints.visibilityRules ?? [];
    expect(rules.some((r) => r.triggerValueId === 'PTP_SLK' && r.showsGroupId === 'APP_MULTI_SIZE')).toBe(true);
    expect(rules.some((r) => r.triggerValueId === 'PTP_SLK' && r.showsGroupId === 'APP_PANTONE')).toBe(true);
  });

  it('cascade: PTP_SLK 선택 → multi-size/pantone visible / PTP_DTF → 유지 hidden', () => {
    const p = mapProduct(productCLSTSHS as unknown as RedDigitalProductResponse);
    const silk = applyCascade(p, { APP_PRINT_TYPE: 'PTP_SLK' }, 'APP_PRINT_TYPE');
    expect(silk.product.optionGroups.find((g) => g.id === 'APP_MULTI_SIZE')?.visible).toBe(true);
    expect(silk.product.optionGroups.find((g) => g.id === 'APP_PANTONE')?.visible).toBe(true);
    const dtf = applyCascade(p, { APP_PRINT_TYPE: 'PTP_DTF' }, 'APP_PRINT_TYPE');
    expect(dtf.product.optionGroups.find((g) => g.id === 'APP_MULTI_SIZE')?.visible).toBe(false);
    expect(dtf.product.optionGroups.find((g) => g.id === 'APP_PANTONE')?.visible).toBe(false);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// ACC 단순 add-on (SUM_MTR) — finish-button 흡수 (acc-panel 미생성)
// ─────────────────────────────────────────────────────────────────────────────
describe('ACC 단순 add-on — SUM_MTR finish-button 흡수(accFilterConfigMap 미등록)', () => {
  it('ACPDSTD: SUB_MTR 12옵션 finish-button, acc-panel 미생성', () => {
    const p = mapProduct(productACPDSTD as unknown as RedDigitalProductResponse);
    const sub = p.optionGroups.find((g) => g.id === 'PCS_SUB_MTR')!;
    expect(sub.componentType).toBe('finish-button');
    expect(sub.values.length).toBe(12); // 받침대 모양×크기
    // 단순 add-on 은 accFilterConfigMap 미등록 → acc-panel 그룹 없음.
    expect(p.optionGroups.some((g) => g.componentType === 'acc-panel')).toBe(false);
    expect(accFilterConfig('ACPDSTD')).toBeUndefined();
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// ACC 다단 캐스케이드/멀티 (accFilterConfigMap 번들상수 이식)
// ─────────────────────────────────────────────────────────────────────────────
describe('ACC 다단 — accFilterConfigMap CASCADE/MULTI (mod_05:2189 K_ 이식)', () => {
  it('상수맵 = K_ 실측(GSSBMTL 4 CASCADE ptt / GSSBSTP CASCADE+MULTI)', () => {
    expect(Object.keys(ACC_FILTER_CONFIG_MAP)).toEqual(['GSSBMTL', 'GSSBSTP']);
    // 숫자형 문자열 키는 JS 가 오름차순 정렬(19,37,38,61) — 4 ptt 보유 사실만 확인.
    expect(Object.keys(ACC_FILTER_CONFIG_MAP.GSSBMTL).sort()).toEqual(['19', '37', '38', '61']);
    expect(ACC_FILTER_CONFIG_MAP.GSSBSTP['8'].uiType).toBe('MULTI');
  });

  it('GSSBMTL(ptt=37) → acc-panel CASCADE 2단(컬러 select → 불박 후가공)', () => {
    const p = mapProduct(productGSSBMTL as unknown as RedDigitalProductResponse);
    const acc = p.optionGroups.find((g) => g.componentType === 'acc-panel')!;
    expect(acc).toBeDefined();
    expect(acc.accSpec?.uiType).toBe('CASCADE');
    expect(acc.accSpec?.groups.length).toBe(2);
    expect(acc.accSpec?.groups[0].kind).toBe('cascade-step');
    expect(acc.accSpec?.groups[0].values.length).toBe(5); // 컬러 5
    expect(acc.accSpec?.groups[1].values.length).toBe(3); // 불박 후가공 3
  });

  it('accFilterConfig(GSSBMTL,19) → SUB_GRP 옵션 부재(기종) = 상위(제조사) 의존 단계', () => {
    const cfg = accFilterConfig('GSSBMTL', '19')!;
    expect(cfg.uiType).toBe('CASCADE');
    expect(cfg.filters[0].options?.length).toBe(2); // 제조사 애플/삼성
    expect(cfg.filters[1].options).toBeUndefined(); // 기종 = 동적(상위 의존)
  });

  it('accFilterConfig(GSSBSTP,8) → MULTI 3그룹(잉크/진공패드/희석제, GRP_COD 보유)', () => {
    const cfg = accFilterConfig('GSSBSTP', '8')!;
    expect(cfg.uiType).toBe('MULTI');
    expect(cfg.filters.length).toBe(3);
    expect(cfg.filters.every((f) => f.GRP_TYPE === 'MTRL_MULTI_GRP' && typeof f.GRP_COD === 'string')).toBe(true);
  });

  it('미등록 (pdtCode, pttCode) → undefined (단순 add-on 경로)', () => {
    expect(accFilterConfig('GSSBMTL', '999')).toBeUndefined();
    expect(accFilterConfig('UNKNOWN', '37')).toBeUndefined();
    expect(accFilterConfig('GSSBMTL')).toBeUndefined(); // pttCode 없음
  });

  it('cascade dependsOn: 옵션 부재 단계는 직전 단계 id 의존 표식', () => {
    // 합성 검증: 어댑터가 SUB_GRP(옵션부재)에 dependsOn=직전 단계 부여.
    // GSSBMTL ptt=37 은 둘 다 옵션 보유 → dependsOn 없음. ptt=19(기종 부재)로 직접 config 확인.
    const cfg = accFilterConfig('GSSBMTL', '19')!;
    // 어댑터 변환은 mapProduct 경유 — ptt=19 fixture 부재라 config 레벨로 dependsOn 규칙만 단언.
    expect(cfg.filters[1].GRP_TYPE).toBe('MTRL_SUB_GRP');
    expect(cfg.filters[1].options).toBeUndefined(); // → 어댑터가 dependsOn 부여(동적)
  });
});
