// N3·N1 교정 회귀 가드 — §22 RE-Verify remediation-spec.md(N3 수량모델 A 래더·N1 ADD_CLR_YN) 단위검증.
//
//  N3 (HIGH·견적불가): pdt_add_option_info(떡메 TPBLMEO·PDT_VER_SIZE형 굿즈)는 모델B(pdt_prn_cnt_info
//   행기반)가 아니라 산술 래더 `MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h`(h=0..9)로 수량 enum 을 만든다.
//   재구성(4월 베이스)은 이 래더 전무 → 떡메류 수량옵션 자체를 못 만들어 견적불가. 본 테스트가 래더 생성을 봉인.
//   산술 권위(verbatim) = widget.deob.js:15438-15444. 렌더 게이트 = L19664(pdt_add_option_info?.length).
//
//  N1 (HIGH·저청구): 자재 ADD_CLR_YN="Y" + 사용자 추가색(addColor) ON 이면 PRN_CLR_CNT 가
//   SID_S→6 / SID_D→12 로 상향(가격 증가) + ORD_INFO.ADD_CLR_YN=Y emit(deob L15764·L15771-15773·L13982).
//   재구성은 ADD_CLR_YN 슬롯 부재 → 추가색 자재에서 색수 미상향 = 저청구. 본 테스트가 색수 상향·emit 을 봉인.
//   ★N1 라이브 e2e 는 발현 자재상품 미식별로 보류 — 단위테스트까지(remediation-spec.md N1 회귀가드 b).
//
//  [INV-1] Red 가격산식(6/12·MIN+ADD×h)은 어댑터에만. 위젯은 colorSide/addColorCapable 불투명 운반·단가 0.
import { describe, it, expect } from 'vitest';
import {
  mapProduct,
  serializeRedPriceRequest,
} from '@/adapters/red/red-adapter';
import { buildPriceRequest } from '@/widget/stores/price';
import type { WidgetState } from '@/widget/stores/widget-store';
import type { RedDigitalProductResponse, RedProductData } from '@/adapters/red/red-types';
import type { NormalizedProduct, NormalizedPriceRequest } from '@/contract';
import productHLCLWAL from '../fixtures/product_HLCLWAL.json';

function stateOf(product: NormalizedProduct, overrides: Partial<WidgetState>): WidgetState {
  return {
    product,
    member: {},
    selections: {},
    dimensionInputs: {},
    quantity: 1,
    ...overrides,
  } as WidgetState;
}

// ── 모델 A(떡메 TPBLMEO) 최소 product fixture ──────────────────────────────────────
// pdt_add_option_info: PDT_VER_SIZE 80×80 → MIN=20, ADD=10 → 래더 [20,30,40,...,110] (h=0..9).
//  근거 산수: remediation-spec.md N3 비준(TPBLMEO 80×80 SID_S ladder qty 20/30/50). MIN_ORD_PRN_CNT/
//  ADD_ORD_PRN_CNT 는 fixture 합성값(라이브 캡처 미식별 — 산술 래더 생성 메커니즘 검증이 목적, 단가 0).
function makeTpblmeo(): RedDigitalProductResponse {
  const data: RedProductData = {
    pdt_base_info: [
      {
        PDT_CD: 'TPBLMEO',
        PDT_UNIT: '개',
        MIN_CUT_WDT: '0',
        MIN_CUT_HGH: '0',
        MAX_CUT_WDT: '0',
        MAX_CUT_HGH: '0',
        CUT_MRG: '0',
        NO_STD_ABL_YN: 'N',
        FIR_CNT: 0,
        INC: 0,
        INC_STEP: 0,
      },
    ],
    pdt_mtrl_info: [{ MTRL_CD: 'TMEO001', MTRL_NM: '떡메모지', HIDE_YN: 'N' }],
    pdt_size_info: [
      { DIV_NM: '80x80', DIV_SEQ: 1, WRK_WDT: '84', WRK_HGH: '84', CUT_WDT: '80', CUT_HGH: '80', DFT_YN: 'Y', HIDE_YN: 'N' },
    ],
    pdt_dosu_info: [{ COD: 'SID_S', COD_NME: '단면', PRN_CLR_CNT: 4 }],
    pdt_dosu_bnc_info: [],
    pdt_pcs_info: [],
    pdt_disable_pcs_info: null,
    // 모델B 행기반(공존 시 모델A 우선 — deob L19729). 래더가 이걸 무시함을 검증.
    pdt_prn_cnt_info: [
      { DFT_PRN_CNT: 1000, FIR_CNT: 100, INC_CNT: 100, INC_STEP: 100, MIN_PRN_CNT: 100, MIN_INN_PAGE: null, MAX_INN_PAGE: null, STEP_INN_PAGE: null },
    ],
    pdt_add_option_info: [
      { PDT_VER_SIZE: '80', MIN_ORD_PRN_CNT: 20, ADD_ORD_PRN_CNT: 10, PACK_PRN_CNT: 100 },
      { PDT_VER_SIZE: '100', MIN_ORD_PRN_CNT: 30, ADD_ORD_PRN_CNT: 20, PACK_PRN_CNT: 150 },
    ],
  };
  return {
    retCode: 200,
    msg: '',
    result: {
      product_option: {
        option: {
          pdt_cod: 'TPBLMEO',
          pdt_nme: '떡메모지',
          item_gbn: 'goods2025_item',
          price_gbn: 'tmpl_price',
          order_yn: 'Y',
          useKoiEditor: 'Y',
          useRPEditor: 'N',
          usePDF: 'N',
        },
      },
      product_data: data,
      member_info: { mb_cust_cod: '10000000' },
    },
  };
}

// ── N1: ADD_CLR_YN="Y" 자재 + SID_S/SID_D 도수 product fixture ─────────────────────
function makeAddClrProduct(addClrYn: 'Y' | 'N', dosuCod: 'SID_S' | 'SID_D'): RedDigitalProductResponse {
  const data: RedProductData = {
    pdt_base_info: [
      { PDT_CD: 'ADCLR01', PDT_UNIT: '개', MIN_CUT_WDT: '0', MIN_CUT_HGH: '0', MAX_CUT_WDT: '0', MAX_CUT_HGH: '0', CUT_MRG: '0', NO_STD_ABL_YN: 'N', FIR_CNT: 0, INC: 0, INC_STEP: 0 },
    ],
    pdt_mtrl_info: [{ MTRL_CD: 'MAT_ADCLR', MTRL_NM: '추가색지', HIDE_YN: 'N', ADD_CLR_YN: addClrYn }],
    pdt_size_info: [
      { DIV_NM: '90x50', DIV_SEQ: 1, WRK_WDT: '94', WRK_HGH: '54', CUT_WDT: '90', CUT_HGH: '50', DFT_YN: 'Y', HIDE_YN: 'N' },
    ],
    pdt_dosu_info: [{ COD: dosuCod, COD_NME: dosuCod === 'SID_S' ? '단면' : '양면', PRN_CLR_CNT: 4 }],
    pdt_dosu_bnc_info: [],
    pdt_pcs_info: [],
    pdt_disable_pcs_info: null,
    pdt_prn_cnt_info: [
      { DFT_PRN_CNT: 500, FIR_CNT: 500, INC_CNT: 100, INC_STEP: 100, MIN_PRN_CNT: 500, MIN_INN_PAGE: null, MAX_INN_PAGE: null, STEP_INN_PAGE: null },
    ],
  };
  return {
    retCode: 200,
    msg: '',
    result: {
      product_option: {
        option: { pdt_cod: 'ADCLR01', pdt_nme: '추가색 상품', item_gbn: 'offset2023_item', price_gbn: 'offset2023_price', order_yn: 'Y', useKoiEditor: 'N', useRPEditor: 'N', usePDF: 'Y' },
      },
      product_data: data,
      member_info: { mb_cust_cod: '10000000' },
    },
  };
}

describe('N3 — 수량모델 A 래더(pdt_add_option_info) 생성 [HIGH·견적불가]', () => {
  it('떡메(TPBLMEO): 첫 PDT_VER_SIZE(MIN=20,ADD=10) → 수량 enum [20,30,40,...,110] (h=0..9, deob L15438-15444)', () => {
    const p = mapProduct(makeTpblmeo());
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT');
    expect(prn).toBeDefined();
    expect(prn!.componentType).toBe('select-box'); // 폐쇄 enum (신규 컴포넌트 0)
    expect(prn!.values.map((v) => Number(v.id))).toEqual([20, 30, 40, 50, 60, 70, 80, 90, 100, 110]);
    // 첫 단계(h=0)=20 이 선두(=DFT_YN="Y" 동형, store.defaultSelections 가 첫 값 기본선택).
    expect(prn!.values[0].id).toBe('20');
  });

  it('모델 A 우선(deob L19729): pdt_prn_cnt_info(모델B 100·100 행) 가 공존해도 GRP_QUANTITY counter 미생성', () => {
    const p = mapProduct(makeTpblmeo());
    // 모델A 래더가 GRP_PRN_CNT select 로 수량을 운반 → counter-input GRP_QUANTITY 는 없어야 함.
    expect(p.optionGroups.find((g) => g.id === 'GRP_QUANTITY')).toBeUndefined();
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT')!;
    // 모델B 행(MIN_PRN_CNT=100,INC=100,DFT=1000)이 아니라 모델A 래더(MIN=20·ADD=10)가 운반됐는지 검증.
    //  모델B 였다면 첫 값/기본이 100·1000 이고 20/30 은 없음. 모델A 면 첫 값=20, 두번째=30(20+10).
    expect(prn.values[0].id).toBe('20'); // 모델A MIN (모델B 였다면 100 또는 1000)
    expect(prn.values.map((v) => v.id)).toContain('30'); // 모델A 20+10*1 (모델B 100단위엔 부재)
    expect(prn.values.map((v) => v.id)).not.toContain('1000'); // 모델B DFT_PRN_CNT(1000) 미반영
  });

  it('모델 A 래더가 인쇄수량 축(printCount)으로 운반 — GRP_PRN_CNT 선택값 = printCount 후보(S6 동형 경로)', () => {
    const p = mapProduct(makeTpblmeo());
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT')!;
    // 차원=printCount: GRP_PRN_CNT enum id 가 정수 인쇄수량(S6 offset 캘린더와 동일 그룹·동일 printCount 경로).
    for (const v of prn.values) expect(Number.isInteger(Number(v.id))).toBe(true);
    expect(Number(prn.values[1].id)).toBe(30); // MIN(20)+ADD(10)*1
  });
});

describe('N3 회귀 — 모델 B(pdt_add_option_info 부재) 상품은 기존 동작 유지 (회귀 0)', () => {
  it('HLCLWAL(offset2023, pdt_add_option_info 없음) → 기존 GRP_PRN_CNT 폐쇄래더 enum [500] 불변', () => {
    const p = mapProduct(productHLCLWAL as unknown as RedDigitalProductResponse);
    const prn = p.optionGroups.find((g) => g.id === 'GRP_PRN_CNT')!;
    expect(prn.componentType).toBe('select-box');
    // 모델A 미트리거(pdt_add_option_info undefined) → 기존 S6 폐쇄래더 그대로(회귀 0).
    expect(prn.values.map((v) => v.id)).toEqual(['500']);
  });
});

describe('N1 — ADD_CLR_YN 추가색 색수 상향 + emit [HIGH·저청구]', () => {
  it('추가색 가용 자재(ADD_CLR_YN=Y) value 에 addColorCapable 주입 + 도수 value 에 colorSide echo', () => {
    const p = mapProduct(makeAddClrProduct('Y', 'SID_S'));
    const mtrl = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')!;
    expect(mtrl.values.find((v) => v.id === 'MAT_ADCLR')!.addColorCapable).toBe(true);
    const dosu = p.optionGroups.find((g) => g.id === 'GRP_DOSU_COVER')!;
    expect(dosu.values.find((v) => v.id === 'SID_S')!.colorSide).toBe('SID_S');
  });

  it('SID_S + addColor=Y + 가용자재 → PRN_CLR_CNT 6 상향 + ADD_CLR_YN="Y" emit (deob L15764)', () => {
    const p = mapProduct(makeAddClrProduct('Y', 'SID_S'));
    const sizeRule = p.constraints.sizeRules[0];
    const state = stateOf(p, {
      selections: { GRP_SIZE: sizeRule.valueId, GRP_MTRL_COVER: 'MAT_ADCLR', GRP_DOSU_COVER: 'SID_S' },
      member: { tier: '10000000' },
      addColor: true,
      quantity: 1,
    });
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 500 };
    const ord = serializeRedPriceRequest(req).dataJson.ORD_INFO[0];
    expect(ord.PRN_CLR_CNT).toBe(6); // SID_S → 6 (base 4 상향)
    expect(ord.ADD_CLR_YN).toBe('Y');
  });

  it('SID_D + addColor=Y + 가용자재 → PRN_CLR_CNT 12 상향', () => {
    const p = mapProduct(makeAddClrProduct('Y', 'SID_D'));
    const sizeRule = p.constraints.sizeRules[0];
    const state = stateOf(p, {
      selections: { GRP_SIZE: sizeRule.valueId, GRP_MTRL_COVER: 'MAT_ADCLR', GRP_DOSU_COVER: 'SID_D' },
      member: { tier: '10000000' },
      addColor: true,
      quantity: 1,
    });
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 500 };
    const ord = serializeRedPriceRequest(req).dataJson.ORD_INFO[0];
    expect(ord.PRN_CLR_CNT).toBe(12); // SID_D → 12
    expect(ord.ADD_CLR_YN).toBe('Y');
  });

  it('addColor 미토글(off) → 색수 base 유지(4) + ADD_CLR_YN="N" (가격불변)', () => {
    const p = mapProduct(makeAddClrProduct('Y', 'SID_S'));
    const sizeRule = p.constraints.sizeRules[0];
    const state = stateOf(p, {
      selections: { GRP_SIZE: sizeRule.valueId, GRP_MTRL_COVER: 'MAT_ADCLR', GRP_DOSU_COVER: 'SID_S' },
      member: { tier: '10000000' },
      quantity: 1,
    });
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 500 };
    const ord = serializeRedPriceRequest(req).dataJson.ORD_INFO[0];
    expect(ord.PRN_CLR_CNT).toBe(4); // base 유지(상향 없음)
    expect(ord.ADD_CLR_YN).toBe('N');
  });

  it('비추가색 자재(ADD_CLR_YN=N) → addColor=Y 여도 색수 미상향(4) + ADD_CLR_YN="N" (게이트 차단·가격불변)', () => {
    const p = mapProduct(makeAddClrProduct('N', 'SID_S'));
    const sizeRule = p.constraints.sizeRules[0];
    const state = stateOf(p, {
      selections: { GRP_SIZE: sizeRule.valueId, GRP_MTRL_COVER: 'MAT_ADCLR', GRP_DOSU_COVER: 'SID_S' },
      member: { tier: '10000000' },
      addColor: true, // 토글 ON 이지만 자재가 미가용 → 무시
      quantity: 1,
    });
    const req: NormalizedPriceRequest = { ...buildPriceRequest(state), printCount: 500 };
    const ord = serializeRedPriceRequest(req).dataJson.ORD_INFO[0];
    expect(ord.PRN_CLR_CNT).toBe(4); // 게이트 차단 → base 유지
    expect(ord.ADD_CLR_YN).toBe('N');
    // 자재 value 에 addColorCapable 주입 안 됨(ADD_CLR_YN=N).
    const mtrl = p.optionGroups.find((g) => g.id === 'GRP_MTRL_COVER')!;
    expect(mtrl.values.find((v) => v.id === 'MAT_ADCLR')!.addColorCapable).toBeUndefined();
  });
});
