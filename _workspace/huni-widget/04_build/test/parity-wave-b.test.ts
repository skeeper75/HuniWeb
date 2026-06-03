// S3 MAJOR Wave B 회귀 가드 — L-3b(ROU 반경 ATTB)/L-1(속성칩 2 shape)/C-A(합성 disable 미스매치).
//  CRITERION: 책임/로직/분기 재현 동등(라인 답습 아님).
//  AUTHORITY:
//   - L-3b: mod_05:1670 roundingConfigMap(Yr={GSCDPOP:{factor:size,value:{1:3,2:6}}}) + mod_07:3300~3344(반경→ATTB)
//   - L-1: major-capture-note §1 (FOI 선택그리드 shape a / RIN_DFT ATTB_CD echo shape b)
//   - C-A: wave-a-verification §6 (L-2 합성분해로 disable 룰 group-id 미스매치)
import { describe, it, expect } from 'vitest';
import { mapProduct, serializeRedPriceRequest } from '@/adapters/red/red-adapter';
import { roundingRadius, ROUNDING_CONFIG_MAP, ROUNDING_DEFAULT_RADIUS } from '@/adapters/red/component-type-map';
import { buildPriceRequest } from '@/widget/stores/price';
import { applyCascade } from '@/widget/stores/cascade';
import type { RedDigitalProductResponse } from '@/adapters/red/red-types';
import type { WidgetState, SelectionValue } from '@/widget/stores/widget-store';
import type { NormalizedProduct } from '@/contract';
import productBCFOXXX from '../fixtures/product_BCFOXXX.json';
import productHLCLWAL from '../fixtures/product_HLCLWAL.json';
import productPRBKYPR from '../fixtures/product_PRBKYPR.json';

function stateOf(product: NormalizedProduct, overrides: Partial<WidgetState>): WidgetState {
  return { product, member: {}, selections: {}, dimensionInputs: {}, quantity: 1, ...overrides } as WidgetState;
}

// ─────────────────────────────────────────────────────────────────────────────
// L-3b ROU_DFT radius ATTB (bundle-constant ingest)
// ─────────────────────────────────────────────────────────────────────────────
describe('L-3b ROU_DFT 반경 ATTB — roundingConfigMap 번들상수 이식 (mod_05:1670)', () => {
  it('상수맵 = Yr 실측(GSCDPOP factor=size, DIV_SEQ 1→3mm/2→6mm)', () => {
    expect(ROUNDING_CONFIG_MAP.GSCDPOP).toEqual({ factor: 'size', value: { '1': '3', '2': '6' } });
  });

  it('roundingRadius: GSCDPOP size-linked → DIV_SEQ별 반경 / 미등록상품 → 고정 default 4', () => {
    expect(roundingRadius('GSCDPOP', 1)).toBe('3'); // DIV_SEQ 1 → 3mm
    expect(roundingRadius('GSCDPOP', 2)).toBe('6'); // DIV_SEQ 2 → 6mm
    expect(roundingRadius('GSCDPOP', 99)).toBe(ROUNDING_DEFAULT_RADIUS); // off-grid → default
    // BCFOXXX/BCSPDFT 는 번들 미등록 → 고정 4mm/6mm 라디오 default '4'.
    expect(roundingRadius('BCFOXXX')).toBe('4');
    expect(roundingRadius('BCSPDFT', 1)).toBe('4'); // 미등록은 DIV_SEQ 무시
  });

  it('BCFOXXX ROU_DFT 4귀 값 attb = 반경(고정 4mm, 번들 미등록 fallback)', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const rou = p.optionGroups.find((g) => g.id === 'PCS_ROU_DFT')!;
    expect(rou.values.every((v) => v.attb === '4')).toBe(true); // slot-only → 이제 반경 채워짐
  });

  it('직렬화: ROU_DFT 선택 → PCS_INFO 각 귀 ATTB = 반경값(이전 빈 슬롯 해소)', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const sr = p.constraints.sizeRules[0];
    const state = stateOf(p, { selections: { GRP_SIZE: sr?.valueId ?? '', PCS_ROU_DFT: ['DFXLT', 'DFXRB'] } });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const rou = body.dataJson.PCS_INFO.filter((f) => f.PCS_COD === 'ROU_DFT');
    expect(rou.map((f) => f.PCS_DTL_COD).sort()).toEqual(['DFXLT', 'DFXRB']);
    // 핵심: 각 귀 ATTB 가 빈 문자열이 아니라 반경값.
    expect(rou.every((f) => f.ATTB === '4')).toBe(true);
    expect(rou.length).toBe(2);
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// L-1 attribute-chip finalize — 2 shapes
// ─────────────────────────────────────────────────────────────────────────────
describe('L-1 속성칩 마감 — 2 shape 구분(FOI 선택그리드 / RIN_DFT 가격측 ATTB echo)', () => {
  it('shape (a) FOI 박: PCS_CD 패밀리 × WEB_PCS_DTL_GRP × PCS_DTL_CD 선택그리드 (attb 없음)', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const foiGroups = p.optionGroups.filter((g) => g.id.startsWith('PCS_FOI'));
    expect(foiGroups.length).toBeGreaterThan(0); // 박 패밀리 그리드
    const gdg = p.optionGroups.find((g) => g.id === 'PCS_FOI_GDG')!;
    expect(gdg.componentType).toBe('finish-button'); // 선택그리드(color-chip 아님)
    expect(gdg.values.map((v) => v.id)).toEqual(expect.arrayContaining(['TFGGS', 'TFGGD'])); // 단/양면 detail
    // shape (a) 는 PCS_DTL_COD 자체가 선택축 → attb 없음(빈 echo 정상).
    expect(gdg.values.every((v) => v.attb === undefined)).toBe(true);
  });

  it('shape (a) FOI 직렬화: 선택 detail → PCS_INFO PCS_DTL_COD echo (ATTB 빈)', () => {
    const p = mapProduct(productBCFOXXX as unknown as RedDigitalProductResponse);
    const sr = p.constraints.sizeRules[0];
    const state = stateOf(p, { selections: { GRP_SIZE: sr?.valueId ?? '', PCS_FOI_GDG: 'TFGGS' } });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const foi = body.dataJson.PCS_INFO.find((f) => f.PCS_COD === 'FOI_GDG')!;
    expect(foi.PCS_DTL_COD).toBe('TFGGS'); // 금박유광단면 선택 echo
    expect(foi.ATTB).toBe(''); // 선택그리드는 ATTB 빈
  });

  it('shape (b) RIN_DFT: 가격측 ATTB_CD echo(RIN_SLV) → attb 슬롯 + 직렬화 ATTB', () => {
    const p = mapProduct(productHLCLWAL as unknown as RedDigitalProductResponse);
    const rin = p.optionGroups.find((g) => g.id === 'PCS_RIN_DFT')!;
    expect(rin).toBeDefined();
    // ATTB_CD=RIN_SLV 가 attb 슬롯에 적재(은색 = 가격측 속성).
    expect(rin.values[0]?.attb).toBe('RIN_SLV');
    const state = stateOf(p, { selections: { PCS_RIN_DFT: rin.values[0]!.id } });
    const body = serializeRedPriceRequest({ ...buildPriceRequest(state), printCount: 1 });
    const rinEntry = body.dataJson.PCS_INFO.find((f) => f.PCS_COD === 'RIN_DFT')!;
    expect(rinEntry.ATTB).toBe('RIN_SLV'); // 가격측 ATTB echo (이전엔 빈 → 단가 오산)
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// C-A disable-rule × composite-group mismatch
// ─────────────────────────────────────────────────────────────────────────────
describe('C-A 합성 disable 미스매치 보정 — base PCS_CD 룰이 __coating/__side 에 적용', () => {
  it('PRBKYPR: 저평량지(COT disable trigger) 선택 → PCS_COT_DFT__coating 값 disable (silent no-op 해소)', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const rule = p.constraints.disableRules.find((r) => r.disablesGroupId === 'PCS_COT_DFT')!;
    expect(rule).toBeDefined(); // 룰은 base id(PCS_COT_DFT) 를 가리킴
    const coating = p.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    expect(coating).toBeDefined(); // 그룹은 L-2 분해로 __coating

    // 트리거 자재 선택 + 코팅 선택 상태 → cascade.
    const sel: Record<string, SelectionValue> = {
      GRP_MTRL_COVER: rule.triggerValueId,
      PCS_COT_DFT__coating: coating.values[0]!.id,
    };
    const next = applyCascade(p, sel, 'GRP_MTRL_COVER');
    const coatAfter = next.product.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    // 이전(C-A 버그): group-id 미스매치 → 코팅값 disable 안 됨(silent no-op).
    // 보정 후: base 매칭으로 코팅 그룹 전 값 disable.
    expect(coatAfter.values.every((v) => v.disabled === true)).toBe(true);
    // 선택돼 있던 코팅값도 해제(불가조합 선택 방지).
    expect(next.selections.PCS_COT_DFT__coating).toBeUndefined();
  });

  it('비-트리거 자재 선택 시 코팅 그룹 정상(disable 안 됨) — 과잉 disable 회귀 0', () => {
    const p = mapProduct(productPRBKYPR as unknown as RedDigitalProductResponse);
    const coating = p.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    // disable 룰이 없는 자재값 선택(첫 자재가 트리거 아니라고 가정 — 트리거와 다른 값).
    const mtrlGroup = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')!;
    const trigger = p.constraints.disableRules.find((r) => r.disablesGroupId === 'PCS_COT_DFT')!.triggerValueId;
    const nonTrigger = mtrlGroup.values.find((v) => v.id !== trigger)!;
    const next = applyCascade(p, { GRP_MTRL_COVER: nonTrigger.id, PCS_COT_DFT__coating: coating.values[0]!.id }, 'GRP_MTRL_COVER');
    const coatAfter = next.product.optionGroups.find((g) => g.id === 'PCS_COT_DFT__coating')!;
    expect(coatAfter.values.some((v) => v.disabled !== true)).toBe(true); // 일부 활성(과잉 disable 아님)
  });
});
