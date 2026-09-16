// M1.5-② 안전 프로브 — [HARD] 3항 준수
//  1) 다이얼로그 자동수락 금지: 뜨면 dismiss + 해당 화면 미실측(사유)
//  2) 선행 클릭은 안전한 자식으로 좁힌다
//  3) 클릭 전 쓰기 컨트롤(.del/.edit/[onclick*=del|save]) 자식 검사
// 결과는 화면 1개 끝날 때마다 즉시 JSONL 로 append (증거 유실 방지)
export const WRITE_CTRL = '.del, .edit, [onclick*="del"], [onclick*="save"], [onclick*="Del"], [onclick*="Save"]';

export async function probeScreen(page, fs, outPath, cfg) {
  const rec = { name: cfg.name, path: cfg.path, url: null, at: null, steps: [], elements: [], blocked: null };
  const stamp = () => new Date(Date.now() + 9*3600*1000).toISOString().replace('T', ' ').slice(0, 19) + ' KST';
  try {
    if (cfg.path) {
      try { await page.goto(cfg.path, { waitUntil: cfg.waitUntil || 'load', timeout: cfg.timeout || 30000 }); }
      catch (e) { rec.steps.push(`goto ${String(e.message || e).slice(0, 60)}`); }
    }
    await page.waitForTimeout(cfg.settle ?? 900);

    for (const st of (cfg.steps || [])) {
      if (st.action === 'wait') { await page.waitForTimeout(st.ms); rec.steps.push(`wait ${st.ms}`); continue; }
      if (st.action === 'wait_for') {
        try { await page.waitForSelector(st.selector, { state: 'visible', timeout: st.ms || 8000 }); rec.steps.push(`wait_for ${st.selector} OK`); }
        catch { rec.steps.push(`wait_for ${st.selector} TIMEOUT`); }
        continue;
      }
      if (st.action === 'eval') {
        // 읽기 전용 뷰 전환만 허용 (setTab/panelOpen 등) — 저장·삭제 호출은 거부
        if (/save|del|publish|remove|post/i.test(st.js)) { rec.steps.push(`eval ${st.js} REFUSED(write)`); continue; }
        try { await page.evaluate(st.js); rec.steps.push(`eval ${st.js} OK`); }
        catch (e) { rec.steps.push(`eval ${st.js} ERR ${String(e.message || e).slice(0, 60)}`); }
        continue;
      }
      if (st.action !== 'click') { rec.steps.push(`skip ${st.action}`); continue; }

      // [HARD] 3 — 쓰기 컨트롤 자식 검사 + [HARD] 2 — 안전 자식으로 좁히기
      const pick = await page.evaluate(({ sel, wc, safe }) => {
        const el = document.querySelector(sel);
        if (!el) return { ok: false, why: 'not-found' };
        const hasW = !!el.querySelector(wc);
        if (!hasW) return { ok: true, target: sel, narrowed: false };
        for (const s of safe) {
          const kid = el.querySelector(s);
          if (kid && !kid.querySelector(wc) && !kid.matches(wc)) return { ok: true, target: `${sel} ${s}`, narrowed: true };
        }
        return { ok: false, why: 'write-control-child' };
      }, { sel: st.selector, wc: WRITE_CTRL, safe: ['.nm', '.name', '.tit', '.title', '.label', 'td:first-child'] });

      if (!pick.ok) {
        rec.steps.push(`click ${st.selector} SKIPPED(${pick.why})`);
        rec.blocked = pick.why === 'write-control-child'
          ? '선행조작이 쓰기 컨트롤 자식을 품음 — [HARD]3 에 따라 클릭 안 함'
          : `선행조작 대상 없음(${st.selector})`;
        continue;
      }
      const r = await page.click(`${pick.target} >> nth=0`, { label: 'manual step (read-only)' });
      rec.steps.push(`click ${pick.target}${pick.narrowed ? ' [narrowed]' : ''} OK`);
      // [HARD] 1 — 다이얼로그가 뜨면 수락하지 않고 취소
      const info = await page.info();
      if (r?.dialog || info?.dialog) {
        try { await page.dismissDialog(); } catch {}
        rec.steps.push('DIALOG → dismissed');
        rec.blocked = '선행조작에서 확인창 발생 — 수락하지 않고 취소';
        break;
      }
      await page.waitForTimeout(st.after ?? 1200);
    }

    rec.url = await page.url();
    rec.at = stamp();

    // 콜아웃 selector 존재/가시성 확인 (읽기 전용 · 클릭 없음)
    rec.elements = await page.evaluate(({ sels }) => {
      const vis = (el) => { const r = el.getBoundingClientRect(); const s = getComputedStyle(el);
        return r.width > 0 && r.height > 0 && s.visibility !== 'hidden' && s.display !== 'none'; };
      // 리프 노드만 — 상위 컨테이너가 자식 텍스트를 품어 거짓양성을 내는 것을 막는다
      const byText = (t) => [...document.querySelectorAll('button,a,span,label,div,th,td,li,h1,h2,h3,option')]
        .filter((e) => e.children.length === 0 && (e.textContent || '').replace(/\s+/g, ' ').trim().includes(t));
      return sels.map((sel) => {
        let nodes = [];
        try {
          if (sel.startsWith('text=')) nodes = byText(sel.slice(5));
          else nodes = [...document.querySelectorAll(sel)];
        } catch (e) { return { sel, error: String(e.message || e) }; }
        return { sel, count: nodes.length, visible: nodes.filter(vis).length,
                 sample: nodes[0] ? (nodes[0].textContent || '').replace(/\s+/g, ' ').trim().slice(0, 40) : null };
      });
    }, { sels: cfg.selectors });
  } catch (e) {
    rec.blocked = `예외: ${String(e.message || e).slice(0, 160)}`;
    rec.at = stamp();
    try { rec.url = await page.url(); } catch {}
  }
  await fs.appendFile(outPath, JSON.stringify(rec) + '\n', 'utf8');  // 화면마다 즉시 기록
  return rec;
}
