/**
 * extract-constraints-from-existing.cjs
 *
 * RedPrinting API 응답에서 제약조건 데이터를 추출하는 스크립트.
 *
 * 데이터 소스:
 *   1) cascade_captures/*_cascade.json (Playwright 라이브 캡처)
 *   2) v2_*_capture.json (기존 모니터링 캡처)
 *
 * 추출 대상 제약조건 유형:
 *   - pdt_disable_pcs_info: 소재(MTRL)→후가공(PCS) 비활성 규칙
 *   - HIDE_YN/HIDE_RSN: 소재/규격/후가공 숨김 플래그
 *   - pdt_prn_cnt_info: 수량/페이지/두께 제약
 *   - pdt_dosu_bnc_info: 도수→제본 매핑 제약
 *   - pdt_size_info: 규격별 작업/재단 치수 + 숨김 여부
 *   - pdt_pcs_info: 후가공별 소재 제한(MTRL_CD), 필수 여부(ESN_YN)
 *
 * 결과: cascade_captures/{pdtCode}_constraints.json + _all_constraints.json
 */

const fs = require('fs');
const path = require('path');

const MONITOR_DIR = __dirname;
const CASCADE_DIR = path.join(MONITOR_DIR, 'cascade_captures');

if (!fs.existsSync(CASCADE_DIR)) fs.mkdirSync(CASCADE_DIR, { recursive: true });

/**
 * API 응답의 result에서 product_data를 찾아 반환
 */
function findProductData(jsonData) {
  // cascade_captures 형식: allApiCalls[0].response.result.product_data
  if (jsonData.allApiCalls) {
    for (const call of jsonData.allApiCalls) {
      const pd = call?.response?.result?.product_data;
      if (pd) return { productData: pd, productOption: call?.response?.result?.product_option };
    }
  }
  // v2_capture 형식: networkLog[0].response.result.product_data
  if (jsonData.networkLog) {
    for (const entry of jsonData.networkLog) {
      const resp = entry?.response;
      if (typeof resp === 'object' && resp?.result?.product_data) {
        return { productData: resp.result.product_data, productOption: resp.result.product_option };
      }
    }
  }
  return null;
}

/**
 * product_data에서 제약조건을 추출
 */
function extractConstraints(productData, productOption, pdtCode) {
  const pd = productData;
  const constraints = {
    pdtCode,
    productName: pd.pdt_base_info?.[0]?.PDT_NM || productOption?.option?.pdt_nme || pdtCode,
    itemType: productOption?.option?.item_gbn || 'unknown',
    priceType: productOption?.option?.price_gbn || 'unknown',

    // 1) 소재→후가공 비활성 규칙 (핵심 캐스케이드 제약)
    disablePcsRules: [],

    // 2) 소재 숨김 (표지 + 내지)
    hiddenMaterials: [],

    // 3) 수량/페이지 제약
    quantityConstraints: [],

    // 4) 도수→제본 매핑
    dosuBncMapping: [],

    // 5) 규격 목록 + 숨김
    sizeConstraints: [],

    // 6) 후가공 옵션 (필수/소재제한/숨김)
    pcsConstraints: [],

    // 7) 기본 상품 정보 (재단 마진 등)
    baseConstraints: null,

    // 요약 통계
    summary: {}
  };

  // --- 1) pdt_disable_pcs_info ---
  const disableList = pd.pdt_disable_pcs_info || [];
  for (const d of disableList) {
    constraints.disablePcsRules.push({
      materialCode: d.MTRL_CD,
      pcsCode: d.PCS_CD,
      pcsDetailCode: d.PCS_DTL_CD || null,
      note: d.NOTE || null
    });
  }

  // --- 2) 소재 숨김 (표지) ---
  for (const m of (pd.pdt_mtrl_info || [])) {
    if (m.HIDE_YN === 'Y') {
      constraints.hiddenMaterials.push({
        type: 'cover',
        materialCode: m.MTRL_CD,
        materialName: m.MTRL_NM || `${m.CLR_NM}/${m.PTT_NM}/${m.WGT_CD}`,
        hideReason: m.HIDE_RSN || null,
        note: m.NOTE || null
      });
    }
  }
  // 소재 숨김 (내지)
  for (const m of (pd.inner_pdt_mtrl_info || [])) {
    if (m.HIDE_YN === 'Y') {
      constraints.hiddenMaterials.push({
        type: 'inner',
        materialCode: m.MTRL_CD,
        materialName: `${m.CLR_NM || ''}/${m.PTT_NM || ''}/${m.WGT_CD || ''}`,
        hideReason: m.HIDE_RSN || null,
        note: m.NOTE || null
      });
    }
  }

  // --- 3) 수량/페이지 제약 ---
  for (const p of (pd.pdt_prn_cnt_info || [])) {
    constraints.quantityConstraints.push({
      divCode: p.DIV_CD || null,
      minPrintCount: p.MIN_PRN_CNT != null ? Number(p.MIN_PRN_CNT) : null,
      reamCount: p.REAM_CNT || null,
      firstCount: p.FIR_CNT != null ? Number(p.FIR_CNT) : null,
      incrementCount: p.INC_CNT != null ? Number(p.INC_CNT) : null,
      incrementStep: p.INC_STEP != null ? Number(p.INC_STEP) : null,
      minInnerPage: p.MIN_INN_PAGE != null ? Number(p.MIN_INN_PAGE) : null,
      maxInnerPage: p.MAX_INN_PAGE != null ? Number(p.MAX_INN_PAGE) : null,
      stepInnerPage: p.STEP_INN_PAGE != null ? Number(p.STEP_INN_PAGE) : null,
      maxThickness: p.MAX_THCK != null ? Number(p.MAX_THCK) : null,
      defaultPrintCount: p.DFT_PRN_CNT != null ? Number(p.DFT_PRN_CNT) : null,
      innerMaxWeight: p.INN_MAX_WGT || null,
      coverMinWeight: p.COV_MIN_WGT || null
    });
  }

  // --- 4) 도수→제본 매핑 ---
  for (const db of (pd.pdt_dosu_bnc_info || [])) {
    constraints.dosuBncMapping.push({
      printColorCount: db.PRN_CLR_CNT,
      code: db.COD,
      codeName: db.COD_NME,
      bindingGroup: db.BNC_GB || null,
      note: db.NOTE || null
    });
  }
  // 내지 도수→제본
  for (const db of (pd.inner_pdt_dosu_bnc_info || [])) {
    constraints.dosuBncMapping.push({
      printColorCount: db.PRN_CLR_CNT,
      code: db.COD,
      codeName: db.COD_NME,
      bindingGroup: db.BNC_GB || null,
      note: db.NOTE || null,
      type: 'inner'
    });
  }

  // --- 5) 규격 ---
  for (const s of (pd.pdt_size_info || [])) {
    constraints.sizeConstraints.push({
      divCode: s.DIV_CD,
      divName: s.DIV_NM,
      workWidth: Number(s.WRK_WDT),
      workHeight: Number(s.WRK_HGH),
      cutWidth: Number(s.CUT_WDT),
      cutHeight: Number(s.CUT_HGH),
      isDefault: s.DFT_YN === 'Y',
      isHidden: s.HIDE_YN === 'Y',
      reamPaperCount: s.REAM_PAPER_CNT || null,
      note: s.NOTE || null
    });
  }

  // --- 6) 후가공 ---
  for (const p of (pd.pdt_pcs_info || [])) {
    constraints.pcsConstraints.push({
      pcsCode: p.PCS_CD,
      pcsDetailCode: p.PCS_DTL_CD,
      pcsDetailName: p.PCS_DTL_NM,
      pcsGroupName: p.PCS_GRP_NM || null,
      webGroup: p.WEB_PCS_DTL_GRP || null,
      webGroupName: p.WEB_PCS_DTL_GRP_NM || null,
      viewYn: p.VIEW_YN,
      hideYn: p.HIDE_YN,
      essentialYn: p.ESN_YN,
      materialCode: p.MTRL_CD || null,
      materialCod: p.MTRL_COD || null,
      workWidth: p.WRK_WDT ? Number(p.WRK_WDT) : null,
      workHeight: p.WRK_HGH ? Number(p.WRK_HGH) : null,
      notice: p.NOTICE || null,
      note: p.NOTE || null,
      subMaterialYn: p.SUB_MTRL_YN || null
    });
  }

  // --- 7) 기본 상품 정보 ---
  const base = pd.pdt_base_info?.[0];
  if (base) {
    constraints.baseConstraints = {
      productCode: base.PDT_CD,
      productName: base.PDT_NM,
      widthHeightSeparate: base.WDT_HGH_GBN_YN,
      printYn: base.PRN_YN,
      unit: base.PDT_UNIT,
      orderCountYn: base.ORD_CNT_YN,
      nonStandardAllowed: base.NO_STD_ABL_YN,
      minCutWidth: base.MIN_CUT_WDT ? Number(base.MIN_CUT_WDT) : null,
      minCutHeight: base.MIN_CUT_HGH ? Number(base.MIN_CUT_HGH) : null,
      maxCutWidth: base.MAX_CUT_WDT ? Number(base.MAX_CUT_WDT) : null,
      maxCutHeight: base.MAX_CUT_HGH ? Number(base.MAX_CUT_HGH) : null,
      defaultCutWidth: base.DFT_CUT_WDT ? Number(base.DFT_CUT_WDT) : null,
      defaultCutHeight: base.DFT_CUT_HGH ? Number(base.DFT_CUT_HGH) : null,
      cutMargin: base.CUT_MRG ? Number(base.CUT_MRG) : null,
      firstCount: base.FIR_CNT ? Number(base.FIR_CNT) : null,
      increment: base.INC ? Number(base.INC) : null,
      incrementStep: base.INC_STEP ? Number(base.INC_STEP) : null,
      reamYn: base.REAM_YN,
      setCount: base.SET_CNT ? Number(base.SET_CNT) : null
    };
  }

  // --- 요약 통계 ---
  constraints.summary = {
    totalDisableRules: constraints.disablePcsRules.length,
    totalHiddenMaterials: constraints.hiddenMaterials.length,
    totalQuantityRules: constraints.quantityConstraints.length,
    totalDosuBncMappings: constraints.dosuBncMapping.length,
    totalSizes: constraints.sizeConstraints.length,
    hiddenSizes: constraints.sizeConstraints.filter(s => s.isHidden).length,
    totalPcsOptions: constraints.pcsConstraints.length,
    hiddenPcs: constraints.pcsConstraints.filter(p => p.hideYn === 'Y').length,
    essentialPcs: constraints.pcsConstraints.filter(p => p.essentialYn === 'Y').length,
    materialBoundPcs: constraints.pcsConstraints.filter(p => p.materialCode).length,
    totalConstraintCount:
      constraints.disablePcsRules.length +
      constraints.hiddenMaterials.length +
      constraints.quantityConstraints.length +
      constraints.sizeConstraints.filter(s => s.isHidden).length +
      constraints.pcsConstraints.filter(p => p.hideYn === 'Y').length
  };

  return constraints;
}

// --- Main ---
(function main() {
  const allConstraints = [];

  // 1) cascade_captures 파일들
  const cascadeFiles = fs.readdirSync(CASCADE_DIR)
    .filter(f => f.endsWith('_cascade.json'));

  for (const file of cascadeFiles) {
    const pdtCode = file.replace('_cascade.json', '');
    const data = JSON.parse(fs.readFileSync(path.join(CASCADE_DIR, file), 'utf8'));
    const found = findProductData(data);
    if (found) {
      const c = extractConstraints(found.productData, found.productOption, pdtCode);
      allConstraints.push(c);
      fs.writeFileSync(
        path.join(CASCADE_DIR, `${pdtCode}_constraints.json`),
        JSON.stringify(c, null, 2)
      );
      console.log(`[cascade] ${pdtCode}: ${c.productName} - ${c.summary.totalConstraintCount} constraints (disable=${c.summary.totalDisableRules}, qty=${c.summary.totalQuantityRules}, pcs=${c.summary.totalPcsOptions})`);
    } else {
      console.log(`[cascade] ${pdtCode}: product_data not found`);
    }
  }

  // 2) v2_*_capture.json 파일들 (cascade에 없는 것만)
  const existingCodes = new Set(allConstraints.map(c => c.pdtCode));
  const v2Files = fs.readdirSync(MONITOR_DIR)
    .filter(f => f.startsWith('v2_') && f.endsWith('_capture.json'));

  for (const file of v2Files) {
    const pdtCode = file.replace('v2_', '').replace('_capture.json', '');
    if (existingCodes.has(pdtCode)) {
      console.log(`[v2] ${pdtCode}: already extracted from cascade`);
      continue;
    }
    const data = JSON.parse(fs.readFileSync(path.join(MONITOR_DIR, file), 'utf8'));
    const found = findProductData(data);
    if (found) {
      const c = extractConstraints(found.productData, found.productOption, pdtCode);
      allConstraints.push(c);
      fs.writeFileSync(
        path.join(CASCADE_DIR, `${pdtCode}_constraints.json`),
        JSON.stringify(c, null, 2)
      );
      console.log(`[v2] ${pdtCode}: ${c.productName} - ${c.summary.totalConstraintCount} constraints`);
    } else {
      console.log(`[v2] ${pdtCode}: product_data not found`);
    }
  }

  // 3) 종합 결과 저장
  const grandSummary = {
    extractedAt: new Date().toISOString(),
    totalProducts: allConstraints.length,
    constraintTotals: {
      disableRules: allConstraints.reduce((s, c) => s + c.summary.totalDisableRules, 0),
      hiddenMaterials: allConstraints.reduce((s, c) => s + c.summary.totalHiddenMaterials, 0),
      quantityRules: allConstraints.reduce((s, c) => s + c.summary.totalQuantityRules, 0),
      dosuBncMappings: allConstraints.reduce((s, c) => s + c.summary.totalDosuBncMappings, 0),
      sizes: allConstraints.reduce((s, c) => s + c.summary.totalSizes, 0),
      hiddenSizes: allConstraints.reduce((s, c) => s + c.summary.hiddenSizes, 0),
      pcsOptions: allConstraints.reduce((s, c) => s + c.summary.totalPcsOptions, 0),
      hiddenPcs: allConstraints.reduce((s, c) => s + c.summary.hiddenPcs, 0),
      essentialPcs: allConstraints.reduce((s, c) => s + c.summary.essentialPcs, 0),
      materialBoundPcs: allConstraints.reduce((s, c) => s + c.summary.materialBoundPcs, 0),
    },
    // 상품별 disable 규칙에서 가장 많이 등장하는 PCS 코드
    topDisabledPcsCodes: (() => {
      const counts = {};
      for (const c of allConstraints) {
        for (const r of c.disablePcsRules) {
          const key = r.pcsCode;
          counts[key] = (counts[key] || 0) + 1;
        }
      }
      return Object.entries(counts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 20)
        .map(([code, count]) => ({ pcsCode: code, count }));
    })(),
    // 상품별 disable 규칙에서 가장 많이 제약받는 소재
    topConstrainedMaterials: (() => {
      const counts = {};
      for (const c of allConstraints) {
        for (const r of c.disablePcsRules) {
          const key = r.materialCode;
          counts[key] = (counts[key] || 0) + 1;
        }
      }
      return Object.entries(counts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 20)
        .map(([code, count]) => ({ materialCode: code, count }));
    })(),
    // 상품별 요약
    perProduct: allConstraints.map(c => ({
      pdtCode: c.pdtCode,
      productName: c.productName,
      itemType: c.itemType,
      ...c.summary
    }))
  };

  fs.writeFileSync(
    path.join(CASCADE_DIR, '_all_constraints.json'),
    JSON.stringify(grandSummary, null, 2)
  );

  console.log(`\n=== 종합 결과 ===`);
  console.log(`상품 수: ${grandSummary.totalProducts}`);
  console.log(`disable 규칙 합계: ${grandSummary.constraintTotals.disableRules}`);
  console.log(`숨김 소재: ${grandSummary.constraintTotals.hiddenMaterials}`);
  console.log(`수량 제약: ${grandSummary.constraintTotals.quantityRules}`);
  console.log(`도수-제본 매핑: ${grandSummary.constraintTotals.dosuBncMappings}`);
  console.log(`후가공 옵션: ${grandSummary.constraintTotals.pcsOptions} (필수=${grandSummary.constraintTotals.essentialPcs}, 숨김=${grandSummary.constraintTotals.hiddenPcs})`);
  console.log(`저장: ${CASCADE_DIR}/_all_constraints.json`);
})();
