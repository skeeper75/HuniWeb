
// 3차 — 0원이 난 위젯에서 「가격 진단」을 열어 구성요소별 매칭/미매칭 사유를 받는다.
// 화면이 제공하는 진단 도구가 판정 근거다(추측하지 않는다). 읽기 전용 · DIRTY=false 강제.
(() => {
  const LIST = [{"wgt": "WGT_000280", "prd": "PRD_000001", "nm": "OPP접착봉투"}, {"wgt": "WGT_000293", "prd": "PRD_000005", "nm": "캘린더봉투"}, {"wgt": "WGT_000401", "prd": "PRD_000009", "nm": "투명케이스"}, {"wgt": "WGT_000402", "prd": "PRD_000011", "nm": "자석고정용고무판"}, {"wgt": "WGT_000281", "prd": "PRD_000013", "nm": "우드봉"}, {"wgt": "WGT_000246", "prd": "PRD_000020", "nm": "화이트인쇄엽서"}, {"wgt": "WGT_000298", "prd": "PRD_000021", "nm": "핑크별색엽서"}, {"wgt": "WGT_000423", "prd": "PRD_000024", "nm": "포토카드"}, {"wgt": "WGT_000433", "prd": "PRD_000025", "nm": "투명포토카드"}, {"wgt": "WGT_000315", "prd": "PRD_000033", "nm": "스탠다드명함"}, {"wgt": "WGT_000316", "prd": "PRD_000034", "nm": "펄명함"}, {"wgt": "WGT_000251", "prd": "PRD_000037", "nm": "오리지널박명함"}, {"wgt": "WGT_000318", "prd": "PRD_000040", "nm": "화이트인쇄명함"}, {"wgt": "WGT_000441", "prd": "PRD_000050", "nm": "봉투제작"}, {"wgt": "WGT_000434", "prd": "PRD_000055", "nm": "낱장 자유형 스티커"}, {"wgt": "WGT_000436", "prd": "PRD_000057", "nm": "대형 자유형 스티커"}, {"wgt": "WGT_000257", "prd": "PRD_000058", "nm": "반칼원형스티커"}, {"wgt": "WGT_000308", "prd": "PRD_000059", "nm": "반칼정사각스티커"}, {"wgt": "WGT_000309", "prd": "PRD_000060", "nm": "반칼직사각스티커"}, {"wgt": "WGT_000310", "prd": "PRD_000061", "nm": "반칼띠지스티커"}, {"wgt": "WGT_000311", "prd": "PRD_000062", "nm": "반칼팬시스티커"}, {"wgt": "WGT_000428", "prd": "PRD_000071", "nm": "트윈링책자"}, {"wgt": "WGT_000287", "prd": "PRD_000094", "nm": "엽서북"}, {"wgt": "WGT_000424", "prd": "PRD_000097", "nm": "떡메모지"}, {"wgt": "WGT_000333", "prd": "PRD_000129", "nm": "폼보드"}, {"wgt": "WGT_000442", "prd": "PRD_000130", "nm": "포맥스보드"}, {"wgt": "WGT_000341", "prd": "PRD_000144", "nm": "미니보드스탠딩"}, {"wgt": "WGT_000411", "prd": "PRD_000165", "nm": "아크릴포카코롯토"}, {"wgt": "WGT_000412", "prd": "PRD_000226", "nm": "아크릴쉐이커코롯토"}];
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const S = window.__scan3 = { done: 0, total: LIST.length, results: [], running: true };
  const click = el => { for (const t of ['mousedown','mouseup','click'])
    el.dispatchEvent(new MouseEvent(t,{bubbles:true})); };
  const findBtn = re => [...document.querySelectorAll('button')].find(b => re.test(b.textContent));

  (async () => {
    for (const it of LIST) {
      try {
        DIRTY=false; await selectProduct(it.prd, it.wgt); await sleep(700); DIRTY=false;
        if (CUR_WGT !== it.wgt) { await selectWidget(it.wgt); await sleep(700); }
        DIRTY=false;
        if (typeof renderPreview === 'function') renderPreview();
        await sleep(1500);
        const d = findBtn(/가격\s*진단/);
        if (!d) { S.results.push({ ...it, diag: '진단 버튼 없음' }); S.done++; continue; }
        d.click();
        await sleep(4000);
        const m = [...document.querySelectorAll('[class*=modal],[class*=diag],dialog')]
          .filter(e => (e.offsetParent !== null || e.open) && /구성요소/.test(e.textContent));
        let txt = m.length ? m[m.length-1].textContent.replace(/\s+/g,' ') : '';
        const i = txt.indexOf('구성요소 ('), j = txt.indexOf('엔진 원본');
        const comp = i >= 0 ? txt.slice(i, j > i ? j : i + 900) : txt.slice(0, 500);
        const k = txt.indexOf('요약'), l = txt.indexOf('보낸 입력');
        const summary = k >= 0 ? txt.slice(k, l > k ? l : k + 300) : '';
        S.results.push({ ...it, summary, comp });
        const c = findBtn(/닫기/); if (c) c.click();
        await sleep(600);
      } catch (e) { S.results.push({ ...it, diag: 'ERR ' + String(e).slice(0,100) }); }
      S.done++;
    }
    S.running = false;
  })();
  return 'started ' + LIST.length;
})()
