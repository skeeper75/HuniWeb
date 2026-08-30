
// 2차 — 1차에서 0원/주문불가가 난 위젯만, **모든 선택 행을 끝까지 채우고** 총액을 다시 읽는다.
// [HARD] 읽기 전용 · DIRTY=false 강제.
(() => {
  const LIST = [{"wgt": "WGT_000280", "prd": "PRD_000001", "nm": "OPP접착봉투"}, {"wgt": "WGT_000293", "prd": "PRD_000005", "nm": "캘린더봉투"}, {"wgt": "WGT_000401", "prd": "PRD_000009", "nm": "투명케이스"}, {"wgt": "WGT_000402", "prd": "PRD_000011", "nm": "자석고정용고무판"}, {"wgt": "WGT_000281", "prd": "PRD_000013", "nm": "우드봉"}, {"wgt": "WGT_000246", "prd": "PRD_000020", "nm": "화이트인쇄엽서"}, {"wgt": "WGT_000298", "prd": "PRD_000021", "nm": "핑크별색엽서"}, {"wgt": "WGT_000423", "prd": "PRD_000024", "nm": "포토카드"}, {"wgt": "WGT_000433", "prd": "PRD_000025", "nm": "투명포토카드"}, {"wgt": "WGT_000315", "prd": "PRD_000033", "nm": "스탠다드명함"}, {"wgt": "WGT_000316", "prd": "PRD_000034", "nm": "펄명함"}, {"wgt": "WGT_000251", "prd": "PRD_000037", "nm": "오리지널박명함"}, {"wgt": "WGT_000318", "prd": "PRD_000040", "nm": "화이트인쇄명함"}, {"wgt": "WGT_000441", "prd": "PRD_000050", "nm": "봉투제작"}, {"wgt": "WGT_000434", "prd": "PRD_000055", "nm": "낱장 자유형 스티커"}, {"wgt": "WGT_000436", "prd": "PRD_000057", "nm": "대형 자유형 스티커"}, {"wgt": "WGT_000257", "prd": "PRD_000058", "nm": "반칼원형스티커"}, {"wgt": "WGT_000308", "prd": "PRD_000059", "nm": "반칼정사각스티커"}, {"wgt": "WGT_000309", "prd": "PRD_000060", "nm": "반칼직사각스티커"}, {"wgt": "WGT_000310", "prd": "PRD_000061", "nm": "반칼띠지스티커"}, {"wgt": "WGT_000311", "prd": "PRD_000062", "nm": "반칼팬시스티커"}, {"wgt": "WGT_000428", "prd": "PRD_000071", "nm": "트윈링책자"}, {"wgt": "WGT_000287", "prd": "PRD_000094", "nm": "엽서북"}, {"wgt": "WGT_000424", "prd": "PRD_000097", "nm": "떡메모지"}, {"wgt": "WGT_000333", "prd": "PRD_000129", "nm": "폼보드"}, {"wgt": "WGT_000442", "prd": "PRD_000130", "nm": "포맥스보드"}, {"wgt": "WGT_000341", "prd": "PRD_000144", "nm": "미니보드스탠딩"}, {"wgt": "WGT_000342", "prd": "PRD_000145", "nm": "미니배너"}, {"wgt": "WGT_000408", "prd": "PRD_000156", "nm": "아크릴지비츠"}, {"wgt": "WGT_000411", "prd": "PRD_000165", "nm": "아크릴포카코롯토"}, {"wgt": "WGT_000412", "prd": "PRD_000226", "nm": "아크릴쉐이커코롯토"}];
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const S = window.__scan2 = { done: 0, total: LIST.length, results: [], running: true };
  const money = () => { const rows=[...document.querySelectorAll('.pv-row')];
    return rows.length ? rows[rows.length-1].textContent.replace(/\s+/g,' ').trim() : null; };
  const click = el => { for (const t of ['mousedown','mouseup','click'])
    el.dispatchEvent(new MouseEvent(t,{bubbles:true})); };

  (async () => {
    for (const it of LIST) {
      try {
        DIRTY = false; await selectProduct(it.prd, it.wgt); await sleep(700); DIRTY = false;
        if (CUR_WGT !== it.wgt) { await selectWidget(it.wgt); await sleep(700); }
        DIRTY = false;
        if (typeof renderPreview === 'function') renderPreview();
        await sleep(1500);

        const picked = [];
        // 아직 아무것도 선택되지 않은 행을 반복해서 채운다(캐스케이드로 새 행이 생길 수 있어 3회전)
        for (let pass = 0; pass < 3; pass++) {
          const rows = [...document.querySelectorAll('.pv-row')];
          let changed = false;
          for (const r of rows) {
            const lab = ((r.querySelector('.pv-lab')||{}).textContent||'').trim();
            if (/추가상품|업로드|제작물/.test(lab)) continue;
            // 접힌 아코디언이면 펼친다
            const ph = r.querySelector('.pv-ph');
            if (ph && r.querySelector('.pv-panel.folded')) { click(ph); await sleep(400); }
            const opts = [...r.querySelectorAll('.pv-btn, .pv-swatch')];
            if (!opts.length) continue;
            if (opts.some(o => /\bon\b/.test(o.className))) continue;   // 이미 선택됨
            click(opts[0]);
            picked.push(lab + '=' + opts[0].textContent.trim().slice(0,16));
            changed = true;
            await sleep(1000);
          }
          // 커스텀 셀렉트(.ss-input)로 된 자재/종이 행
          const sels = [...document.querySelectorAll('.pv-row .ss-input')].filter(i => !i.value);
          for (const si of sels) {
            click(si); await sleep(500);
            const o = [...document.querySelectorAll('.ss-opt')].filter(e => e.offsetParent !== null);
            if (o.length) { click(o[0]); picked.push('select=' + o[0].textContent.trim().slice(0,16));
              changed = true; await sleep(1000); }
          }
          if (!changed) break;
        }
        await sleep(1200);
        S.results.push({ ...it, after2: money(), picked2: picked });
      } catch (e) { S.results.push({ ...it, error: String(e).slice(0,120) }); }
      S.done++;
    }
    S.running = false;
  })();
  return 'started ' + LIST.length;
})()
