
// 후가공(WGT_SRC_TYPE.14) 컴포넌트를 위젯에 추가하고 게시한다.
// [HARD] 추가 전 cfg 를 백업(window.__backups)하고, 이미 있으면 건너뛴다.
(() => {
  const LIST = [{"prd": "PRD_000016", "nm": "프리미엄엽서", "wgt": "WGT_000242", "miss": ["PROC_000004"]}, {"prd": "PRD_000017", "nm": "코팅엽서", "wgt": "WGT_000243", "miss": ["PROC_000004", "PROC_000014", "PROC_000015"]}, {"prd": "PRD_000018", "nm": "스탠다드엽서", "wgt": "WGT_000244", "miss": ["PROC_000004"]}, {"prd": "PRD_000019", "nm": "투명엽서", "wgt": "WGT_000245", "miss": ["PROC_000004"]}, {"prd": "PRD_000020", "nm": "화이트인쇄엽서", "wgt": "WGT_000246", "miss": ["PROC_000008", "PROC_000009"]}, {"prd": "PRD_000021", "nm": "핑크별색엽서", "wgt": "WGT_000298", "miss": ["PROC_000004", "PROC_000010"]}, {"prd": "PRD_000030", "nm": "지그재그엽서", "wgt": "WGT_000297", "miss": ["PROC_000004"]}, {"prd": "PRD_000040", "nm": "화이트인쇄명함", "wgt": "WGT_000318", "miss": ["PROC_000009"]}, {"prd": "PRD_000041", "nm": "스탠다드 쿠폰/상품권", "wgt": "WGT_000253", "miss": ["PROC_000004"]}, {"prd": "PRD_000042", "nm": "프리미엄 쿠폰/상품권", "wgt": "WGT_000237", "miss": ["PROC_000004", "PROC_000031", "PROC_000032", "PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040", "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044"]}, {"prd": "PRD_000043", "nm": "인쇄배경지(일반형)", "wgt": "WGT_000254", "miss": ["PROC_000004"]}, {"prd": "PRD_000044", "nm": "인쇄배경지(커팅형)", "wgt": "WGT_000255", "miss": ["PROC_000004"]}, {"prd": "PRD_000046", "nm": "라벨/택", "wgt": "WGT_000323", "miss": ["PROC_000004"]}, {"prd": "PRD_000048", "nm": "접지리플렛", "wgt": "WGT_000321", "miss": ["PROC_000004"]}, {"prd": "PRD_000071", "nm": "트윈링책자", "wgt": "WGT_000428", "miss": ["PROC_000021"]}, {"prd": "PRD_000109", "nm": "미니탁상형캘린더", "wgt": "WGT_000427", "miss": ["PROC_000004"]}, {"prd": "PRD_000110", "nm": "엽서캘린더", "wgt": "WGT_000284", "miss": ["PROC_000004"]}, {"prd": "PRD_000111", "nm": "벽걸이캘린더", "wgt": "WGT_000285", "miss": ["PROC_000004", "PROC_000099"]}, {"prd": "PRD_000112", "nm": "와이드벽걸이캘린더", "wgt": "WGT_000286", "miss": ["PROC_000004", "PROC_000099"]}];
  const sleep = ms => new Promise(r=>setTimeout(r,ms));
  const S = window.__fix = { done:0, total:LIST.length, results:[], backups:{}, running:true };
  const btn = re => [...document.querySelectorAll('button')].find(b=>re.test(b.textContent.trim()));

  (async () => {
    for (const it of LIST) {
      const rec = { ...it };
      try {
        await selectProduct(it.prd, it.wgt); await sleep(900);
        if (CUR_WGT !== it.wgt) { await selectWidget(it.wgt); await sleep(900); }
        // 백업
        const before = await (await fetch(`/admin/widget-builder/w/${CUR_WGT}/load/`)).json();
        S.backups[CUR_WGT] = before;
        const had = (before.items||[]).some(i=>i.src_typ_cd==='WGT_SRC_TYPE.14');
        rec.had = had;
        if (had) { rec.skip='이미 후가공 있음'; S.results.push(rec); S.done++; continue; }
        // 구성 탭 + 드롭
        const cfg = btn(/^구성$/); if (cfg) { cfg.click(); await sleep(800); }
        const pal=[...document.querySelectorAll('.pal-item')].find(e=>/후가공/.test(e.title||''));
        const canvas=document.getElementById('wb-canvas');
        if(!pal||!canvas){ rec.err='pal/canvas 없음'; S.results.push(rec); S.done++; continue; }
        const dt=new DataTransfer();
        pal.dispatchEvent(new DragEvent('dragstart',{bubbles:true,dataTransfer:dt}));
        canvas.dispatchEvent(new DragEvent('dragover',{bubbles:true,dataTransfer:dt}));
        canvas.dispatchEvent(new DragEvent('drop',{bubbles:true,dataTransfer:dt}));
        pal.dispatchEvent(new DragEvent('dragend',{bubbles:true,dataTransfer:dt}));
        await sleep(2500);   // 자동 저장 대기
        // 게시
        const pub = btn(/^게시$/); if (pub) { pub.click(); await sleep(2500); }
        // 검증
        const after = await (await fetch(`/admin/widget-builder/w/${CUR_WGT}/load/`)).json();
        rec.before_n=(before.items||[]).length; rec.after_n=(after.items||[]).length;
        rec.ok=(after.items||[]).some(i=>i.src_typ_cd==='WGT_SRC_TYPE.14');
        rec.sts=after.header.sts_typ_cd;
        S.results.push(rec);
      } catch(e){ rec.err=String(e).slice(0,100); S.results.push(rec); }
      S.done++;
    }
    S.running=false;
  })();
  return 'started '+LIST.length;
})()
