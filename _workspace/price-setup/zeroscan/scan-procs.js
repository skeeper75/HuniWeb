
// 위젯이 실제로 보내는 procs 를 가로채 수집한다.
// [HARD] 읽기 전용 · DIRTY=false 강제 · 옵션은 화면에서 고른다(분모=화면).
(() => {
  const LIST = [{"prd": "PRD_000016", "nm": "프리미엄엽서", "wgt": "WGT_000242", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000027", "PROC_000028", "PROC_000031", "PROC_000032"], "opt": []}, {"prd": "PRD_000017", "nm": "코팅엽서", "wgt": "WGT_000243", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000014", "PROC_000015", "PROC_000027", "PROC_000028"], "opt": ["PROC_000014", "PROC_000015"]}, {"prd": "PRD_000018", "nm": "스탠다드엽서", "wgt": "WGT_000244", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000027", "PROC_000028", "PROC_000031", "PROC_000032"], "opt": []}, {"prd": "PRD_000019", "nm": "투명엽서", "wgt": "WGT_000245", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000008", "PROC_000027", "PROC_000028"], "opt": []}, {"prd": "PRD_000020", "nm": "화이트인쇄엽서", "wgt": "WGT_000246", "mand": ["PROC_000008"], "need": ["PROC_000008", "PROC_000009"], "opt": ["PROC_000008", "PROC_000009"]}, {"prd": "PRD_000021", "nm": "핑크별색엽서", "wgt": "WGT_000298", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000010"], "opt": ["PROC_000010"]}, {"prd": "PRD_000026", "nm": "종이슬로건", "wgt": "WGT_000443", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000014", "PROC_000015"], "opt": ["PROC_000014", "PROC_000015"]}, {"prd": "PRD_000027", "nm": "2단접지카드", "wgt": "WGT_000248", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000031", "PROC_000032", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044", "PROC_000065", "PROC_000066"], "opt": []}, {"prd": "PRD_000028", "nm": "미니접지카드", "wgt": "WGT_000304", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000031", "PROC_000032", "PROC_000065", "PROC_000066"], "opt": []}, {"prd": "PRD_000029", "nm": "3단접지카드", "wgt": "WGT_000299", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000031", "PROC_000032", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044", "PROC_000067", "PROC_000068"], "opt": []}, {"prd": "PRD_000030", "nm": "지그재그엽서", "wgt": "WGT_000297", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000031", "nm": "프리미엄명함", "wgt": "WGT_000249", "mand": [], "need": ["PROC_000027", "PROC_000028", "PROC_000031", "PROC_000032", "PROC_000154", "PROC_000155", "PROC_000156", "PROC_000157", "PROC_000158", "PROC_000159", "PROC_000160", "PROC_000161"], "opt": []}, {"prd": "PRD_000034", "nm": "펄명함", "wgt": "WGT_000316", "mand": [], "need": ["PROC_000154", "PROC_000156", "PROC_000157", "PROC_000158", "PROC_000159", "PROC_000160", "PROC_000161"], "opt": []}, {"prd": "PRD_000038", "nm": "형압명함", "wgt": "WGT_000252", "mand": [], "need": ["PROC_000027", "PROC_000028", "PROC_000051", "PROC_000052"], "opt": []}, {"prd": "PRD_000040", "nm": "화이트인쇄명함", "wgt": "WGT_000318", "mand": [], "need": ["PROC_000009"], "opt": ["PROC_000009"]}, {"prd": "PRD_000041", "nm": "스탠다드 쿠폰/상품권", "wgt": "WGT_000253", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000031", "PROC_000032"], "opt": []}, {"prd": "PRD_000042", "nm": "프리미엄 쿠폰/상품권", "wgt": "WGT_000237", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000031", "PROC_000032", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044"], "opt": ["PROC_000031", "PROC_000032", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044"]}, {"prd": "PRD_000043", "nm": "인쇄배경지(일반형)", "wgt": "WGT_000254", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000044", "nm": "인쇄배경지(커팅형)", "wgt": "WGT_000255", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000045", "nm": "인쇄헤더택", "wgt": "WGT_000322", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000046", "nm": "라벨/택", "wgt": "WGT_000323", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000047", "nm": "소량전단지", "wgt": "WGT_000320", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000014", "PROC_000015", "PROC_000031", "PROC_000032"], "opt": []}, {"prd": "PRD_000048", "nm": "접지리플렛", "wgt": "WGT_000321", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000014", "PROC_000015", "PROC_000031", "PROC_000032", "PROC_000060", "PROC_000071", "PROC_000106", "PROC_000107"], "opt": []}, {"prd": "PRD_000049", "nm": "와이드 접지리플렛", "wgt": "WGT_000305", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000014", "PROC_000015", "PROC_000031", "PROC_000032", "PROC_000060", "PROC_000071", "PROC_000106"], "opt": []}, {"prd": "PRD_000068", "nm": "중철책자", "wgt": "WGT_000420", "mand": [], "need": ["PROC_000018"], "opt": []}, {"prd": "PRD_000069", "nm": "무선책자", "wgt": "WGT_000288", "mand": [], "need": ["PROC_000019", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044", "PROC_000051", "PROC_000052"], "opt": []}, {"prd": "PRD_000070", "nm": "PUR책자", "wgt": "WGT_000429", "mand": [], "need": ["PROC_000020"], "opt": []}, {"prd": "PRD_000071", "nm": "트윈링책자", "wgt": "WGT_000428", "mand": [], "need": ["PROC_000021"], "opt": ["PROC_000021"]}, {"prd": "PRD_000082", "nm": "하드커버링책자", "wgt": "WGT_000431", "mand": [], "need": ["PROC_000024"], "opt": []}, {"prd": "PRD_000108", "nm": "탁상형캘린더", "wgt": "WGT_000283", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000100"], "opt": []}, {"prd": "PRD_000109", "nm": "미니탁상형캘린더", "wgt": "WGT_000427", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000102"], "opt": []}, {"prd": "PRD_000110", "nm": "엽서캘린더", "wgt": "WGT_000284", "mand": ["PROC_000004"], "need": ["PROC_000004"], "opt": []}, {"prd": "PRD_000111", "nm": "벽걸이캘린더", "wgt": "WGT_000285", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000099"], "opt": ["PROC_000099"]}, {"prd": "PRD_000112", "nm": "와이드벽걸이캘린더", "wgt": "WGT_000286", "mand": ["PROC_000004"], "need": ["PROC_000004", "PROC_000099"], "opt": ["PROC_000099"]}];
  const sleep = ms => new Promise(r => setTimeout(r, ms));
  const S = window.__ps = { done:0, total:LIST.length, results:[], running:true };
  const click = el => { for (const t of ['mousedown','mouseup','click'])
    el.dispatchEvent(new MouseEvent(t,{bubbles:true})); };
  if (!window.__of) { window.__of = window.fetch;
    window.fetch = function(u,o){ try{ if(o&&o.body) window.__last=String(o.body); }catch(e){}
      return window.__of.apply(this,arguments); }; }

  (async () => {
    for (const it of LIST) {
      try {
        DIRTY=false; await selectProduct(it.prd, it.wgt); await sleep(700); DIRTY=false;
        if (CUR_WGT !== it.wgt) { await selectWidget(it.wgt); await sleep(700); }
        DIRTY=false;
        if (typeof renderPreview === 'function') renderPreview();
        await sleep(1500);
        // 모든 선택 행을 채운다(가격이 계산되도록)
        for (let pass=0; pass<2; pass++) {
          const rows=[...document.querySelectorAll('.pv-row')];
          let changed=false;
          for (const r of rows) {
            const lab=((r.querySelector('.pv-lab')||{}).textContent||'').trim();
            if (/추가상품|업로드|제작물/.test(lab)) continue;
            const ph=r.querySelector('.pv-ph');
            if (ph && r.querySelector('.pv-panel.folded')) { click(ph); await sleep(350); }
            const opts=[...r.querySelectorAll('.pv-btn,.pv-swatch')].filter(e=>e.offsetParent!==null);
            if (opts.length && !opts.some(o=>/\bon\b/.test(o.className))) {
              click(opts[0]); changed=true; await sleep(800);
            }
          }
          if(!changed) break;
        }
        await sleep(1200);
        let sent=[];
        try { const b=JSON.parse(window.__last||'{}'); sent=(b.procs||[]).map(p=>p.proc_cd); } catch(e){}
        const rows=[...document.querySelectorAll('.pv-row')];
        const total = rows.length ? rows[rows.length-1].textContent.replace(/\s+/g,' ').trim().slice(0,90) : '';
        S.results.push({ ...it, sent, total });
      } catch(e) { S.results.push({ ...it, err:String(e).slice(0,90) }); }
      S.done++;
    }
    S.running=false;
  })();
  return 'started '+LIST.length;
})()
