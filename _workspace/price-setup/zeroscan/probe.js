// 위젯 미리보기 화면에서 「가격에 영향을 주는 선택지」를 추출한다.
// [HARD] 분모는 렌더된 화면에서만 얻는다(huni-webadmin-manual-first.md).
//        meta 도 cfg 도 화면을 예측하지 못한다.
(() => {
  const rows = [...document.querySelectorAll('.pv-row')];
  const out = [];
  for (const r of rows) {
    const lab = (r.querySelector('.pv-lab') || {}).textContent || '';
    const label = lab.replace(/\s+/g, ' ').trim();
    // 선택지 3형태: 스와치(색), pv-btn(버튼), 커스텀 셀렉트(.ss-opt)
    const sw = [...r.querySelectorAll('.pv-swatch')].map(e => e.textContent.trim());
    const bt = [...r.querySelectorAll('.pv-btn')].map(e => e.textContent.trim());
    const se = [...r.querySelectorAll('select option')].map(e => e.textContent.trim());
    const kinds = [];
    if (sw.length) kinds.push(['swatch', sw]);
    if (bt.length) kinds.push(['btn', bt]);
    if (se.length) kinds.push(['select', se]);
    if (!kinds.length) continue;
    out.push({ label, kinds });
  }
  const last = rows[rows.length - 1];
  return JSON.stringify({
    rows: out,
    total: last ? last.textContent.replace(/\s+/g, ' ').trim().slice(0, 160) : ''
  });
})()
