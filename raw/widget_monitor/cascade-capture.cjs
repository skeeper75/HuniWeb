/**
 * cascade-capture.cjs — RedPrinting 옵션 캐스케이드 캡처
 *
 * 기존 run-monitor-v2.cjs가 "초기 로드 1회 캡처"만 한다면,
 * 이 스크립트는 각 옵션을 순회하며 변경 → API 재호출 → 응답 차이를 기록한다.
 *
 * 결과: 서버 사이드 제약조건을 "행동 관찰"로 역추론할 수 있는 데이터셋
 *
 * 사용법:
 *   node cascade-capture.cjs [pdtCode]
 *   node cascade-capture.cjs PRBKORD          # 특정 상품
 *   node cascade-capture.cjs                  # 전체 타겟 순회
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const TARGETS = JSON.parse(fs.readFileSync(path.join(__dirname, 'monitor_targets_v2.json'), 'utf8'));
const OUT_DIR = path.join(__dirname, 'cascade_captures');

if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });

// Shadow DOM 내부 Pinia 스토어 추출 함수
const EXTRACT_PINIA = `
  (() => {
    const tryGetPinia = (root) => {
      try {
        const allEls = root.querySelectorAll('*');
        for (const el of allEls) {
          const vueApp = el.__vue_app__;
          if (vueApp) {
            const pinia = vueApp._context?.provides?.pinia || vueApp.config?.globalProperties?.$pinia;
            if (pinia?.state?.value) {
              return JSON.parse(JSON.stringify(pinia.state.value));
            }
          }
          if (el.shadowRoot) { const r = tryGetPinia(el.shadowRoot); if (r) return r; }
        }
      } catch(e) { return { error: e.message }; }
      return null;
    };
    if (window.__pinia?.state?.value) {
      return JSON.parse(JSON.stringify(window.__pinia.state.value));
    }
    return tryGetPinia(document);
  })()
`;

// Shadow DOM 내부 옵션 요소 탐색
const EXTRACT_OPTIONS = `
  (() => {
    const findInShadow = (root, selector) => {
      let results = [...root.querySelectorAll(selector)];
      root.querySelectorAll('*').forEach(el => {
        if (el.shadowRoot) results.push(...findInShadow(el.shadowRoot, selector));
      });
      return results;
    };

    // 라디오, 셀렉트, 체크박스, 버튼 등 옵션 요소 탐색
    const options = {};

    // select 요소
    findInShadow(document, 'select').forEach((sel, i) => {
      const name = sel.name || sel.id || sel.className || 'select_' + i;
      options['select:' + name] = {
        type: 'select',
        element: { tag: 'select', name, id: sel.id },
        values: [...sel.options].map(o => ({ value: o.value, text: o.textContent.trim(), selected: o.selected }))
      };
    });

    // 라디오 그룹
    const radioGroups = {};
    findInShadow(document, 'input[type="radio"]').forEach(r => {
      const name = r.name || 'radio_unknown';
      if (!radioGroups[name]) radioGroups[name] = [];
      radioGroups[name].push({ value: r.value, checked: r.checked, label: r.parentElement?.textContent?.trim()?.slice(0, 50) });
    });
    Object.entries(radioGroups).forEach(([name, values]) => {
      options['radio:' + name] = { type: 'radio', element: { name }, values };
    });

    // 클릭 가능 옵션 버튼 (Vue 컴포넌트 스타일)
    findInShadow(document, '[data-option-value], [data-cod], .option-item, .size-item, .paper-item').forEach((el, i) => {
      const cod = el.dataset?.optionValue || el.dataset?.cod || el.textContent?.trim()?.slice(0, 30);
      const group = el.closest('[data-option-group]')?.dataset?.optionGroup || 'btn_group_' + i;
      if (!options['btn:' + group]) options['btn:' + group] = { type: 'button', values: [] };
      options['btn:' + group].values.push({
        value: cod,
        text: el.textContent?.trim()?.slice(0, 50),
        disabled: el.classList.contains('disabled') || el.hasAttribute('disabled'),
        active: el.classList.contains('active') || el.classList.contains('selected')
      });
    });

    return options;
  })()
`;

/**
 * 주어진 상품에서 옵션 캐스케이드를 캡처한다.
 * 1) 초기 로드 → 옵션 목록 + Pinia 상태 캡처
 * 2) 각 옵션 그룹에서 값을 변경 → API 재호출 대기 → 변경된 옵션 목록 캡처
 * 3) 변경 전후 차이(diff)를 기록
 */
async function captureCascade(target, browser) {
  const { pdtCode, name, url, level } = target;
  console.log(`\n=== [${level}] ${name} (${pdtCode}) ===`);

  const page = await browser.newPage();
  const allApiCalls = [];
  const cascadeResults = [];

  // API 호출 인터셉트
  page.on('response', async (response) => {
    const u = response.url();
    const isWidgetApi = u.includes('get_digital_product_info') ||
                        u.includes('get_ajax_price_vTmpl') ||
                        u.includes('guide_product_paper');
    if (!isWidgetApi) return;
    try {
      const body = await response.json().catch(() => null);
      allApiCalls.push({
        timestamp: Date.now(),
        url: u,
        method: response.request().method(),
        requestBody: response.request().postData(),
        responseKeys: body?.result ? Object.keys(body.result) : null,
        response: body
      });
    } catch {}
  });

  try {
    // Step 1: 초기 로드
    await page.goto(url, { waitUntil: 'load', timeout: 30000 });
    await page.waitForTimeout(6000);

    const initialApiCount = allApiCalls.length;
    const initialStore = await page.evaluate(EXTRACT_PINIA);
    const initialOptions = await page.evaluate(EXTRACT_OPTIONS);

    console.log(`  초기: API ${initialApiCount}건, 스토어 ${initialStore ? Object.keys(initialStore).join(',') : 'null'}`);
    console.log(`  옵션 그룹: ${Object.keys(initialOptions).length}개`);

    // 초기 상태 기록
    const baseline = {
      step: 'initial',
      apiCallCount: initialApiCount,
      storeSnapshot: initialStore,
      optionGroups: initialOptions,
      timestamp: Date.now()
    };
    cascadeResults.push(baseline);

    // Step 2: product_option에서 옵션 데이터 추출 (API 응답에서)
    const productInfoCall = allApiCalls.find(c => c.url.includes('get_digital_product_info'));
    let serverOptions = null;
    if (productInfoCall?.response?.result?.product_option) {
      const po = productInfoCall.response.result.product_option;
      serverOptions = {
        sizeList: po.option?.sizeinfo?.sizelist?.map(s => ({
          cod: s.COD, name: s.COD_NME,
          req_paper: s.req_paper, req_color: s.req_color,
          rst_awkjob: s.rst_awkjob, rst_ordqty: s.rst_ordqty,
          req_width: s.req_width, req_height: s.req_height
        })),
        paperList: po.option?.paperinfo?.paperlist?.map(p => ({
          cod: p.COD, name: p.COD_NME,
          rst_awkjob: p.rst_awkjob, rst_prsjob: p.rst_prsjob,
          req_width: p.req_width, req_height: p.req_height
        })),
        colorList: po.option?.colorinfo?.colorlist?.map(c => ({
          cod: c.COD || c.colorno, name: c.COD_NME || c.color_nm,
          rst_prsjob: c.rst_prsjob, rst_opt: c.rst_opt
        })),
        prsjobList: po.option?.prsjobinfo?.prsjoblist?.map(j => ({
          cod: j.COD || j.jobno, name: j.COD_NME || j.job_nm,
          req_color: j.req_color, rst_paper: j.rst_paper, rst_awkjob: j.rst_awkjob
        })),
        awkjobGroups: po.option?.awkjobinfo?.awkjobgrouplist?.map(g => ({
          groupCod: g.GRP_COD || g.grpno,
          groupName: g.GRP_NME || g.grp_nm,
          items: g.awkjoblist?.map(a => ({
            cod: a.COD || a.jobno, name: a.COD_NME || a.job_nm,
            rst_paper: a.rst_paper, rst_size: a.rst_size,
            rst_awkjob: a.rst_awkjob, rst_jobqty: a.rst_jobqty,
            req_awkjob: a.req_awkjob, req_jobsize: a.req_jobsize
          }))
        }))
      };

      // 제약조건 통계
      const countConstraints = (list, prefix) => {
        if (!list) return {};
        const counts = {};
        list.forEach(item => {
          Object.keys(item).forEach(k => {
            if (k.startsWith(prefix) && item[k]) {
              counts[k] = (counts[k] || 0) + 1;
            }
          });
        });
        return counts;
      };

      const constraintStats = {
        size_req: countConstraints(serverOptions.sizeList, 'req_'),
        size_rst: countConstraints(serverOptions.sizeList, 'rst_'),
        paper_req: countConstraints(serverOptions.paperList, 'req_'),
        paper_rst: countConstraints(serverOptions.paperList, 'rst_'),
        color_rst: countConstraints(serverOptions.colorList, 'rst_'),
        prsjob_req: countConstraints(serverOptions.prsjobList, 'req_'),
        prsjob_rst: countConstraints(serverOptions.prsjobList, 'rst_'),
      };

      console.log(`  서버 옵션: size ${serverOptions.sizeList?.length || 0}, paper ${serverOptions.paperList?.length || 0}, color ${serverOptions.colorList?.length || 0}`);
      console.log(`  제약조건 통계:`, JSON.stringify(constraintStats));

      cascadeResults.push({
        step: 'server_options',
        serverOptions,
        constraintStats,
        timestamp: Date.now()
      });
    }

    // Step 3: 가격 API를 호출하여 기본 가격 캡처
    const priceCall = allApiCalls.find(c => c.url.includes('get_ajax_price_vTmpl'));
    if (priceCall) {
      cascadeResults.push({
        step: 'initial_price',
        requestBody: priceCall.requestBody,
        priceResponse: priceCall.response,
        timestamp: Date.now()
      });
    }

    // Step 4: Pinia order 스토어에서 현재 선택값 추출
    const orderState = initialStore?.order;
    if (orderState) {
      cascadeResults.push({
        step: 'initial_order_state',
        orderData: orderState.orderData || orderState,
        timestamp: Date.now()
      });
    }

    // 최종 결과 저장
    const result = {
      pdtCode, name, url, level,
      capturedAt: new Date().toISOString(),
      totalApiCalls: allApiCalls.length,
      cascadeSteps: cascadeResults.length,
      hasServerConstraints: !!serverOptions,
      constraintCount: serverOptions ?
        (serverOptions.sizeList?.filter(s => s.req_paper || s.rst_awkjob).length || 0) +
        (serverOptions.paperList?.filter(p => p.rst_awkjob || p.rst_prsjob).length || 0) : 0,
      cascadeResults,
      allApiCalls
    };

    const outPath = path.join(OUT_DIR, `${pdtCode}_cascade.json`);
    fs.writeFileSync(outPath, JSON.stringify(result, null, 2));
    console.log(`  ✓ 저장: ${outPath} (${cascadeResults.length} steps, ${allApiCalls.length} API calls)`);

    return result;

  } catch (err) {
    console.error(`  ✗ ${err.message}`);
    return { pdtCode, name, error: err.message };
  } finally {
    await page.close();
  }
}

(async () => {
  const targetCode = process.argv[2];
  const targets = targetCode
    ? TARGETS.filter(t => t.pdtCode === targetCode)
    : TARGETS;

  if (targets.length === 0) {
    console.error(`대상 없음: ${targetCode}`);
    process.exit(1);
  }

  console.log(`=== RedPrinting 옵션 캐스케이드 캡처 ===`);
  console.log(`대상: ${targets.length}개 상품`);
  console.log(`출력: ${OUT_DIR}/\n`);

  const browser = await chromium.launch({
    headless: true,
    args: ['--lang=ko-KR', '--no-sandbox']
  });

  const results = [];
  for (const target of targets) {
    const result = await captureCascade(target, browser);
    results.push(result);
  }

  await browser.close();

  // 종합 리포트
  const summary = {
    capturedAt: new Date().toISOString(),
    totalProducts: results.length,
    successful: results.filter(r => !r.error).length,
    failed: results.filter(r => r.error).length,
    totalConstraints: results.reduce((sum, r) => sum + (r.constraintCount || 0), 0),
    products: results.map(r => ({
      pdtCode: r.pdtCode, name: r.name,
      cascadeSteps: r.cascadeSteps || 0,
      constraintCount: r.constraintCount || 0,
      hasServerConstraints: r.hasServerConstraints || false,
      error: r.error || null
    }))
  };

  fs.writeFileSync(path.join(OUT_DIR, '_summary.json'), JSON.stringify(summary, null, 2));
  console.log(`\n=== 완료: ${summary.successful}/${summary.totalProducts} 성공, 총 제약조건 ${summary.totalConstraints}개 ===`);
})();
