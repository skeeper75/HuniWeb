// D3 — SPEC-LAUNCHPLAN-001 오픈 계획서 검증 (AC-LP-001 ~ AC-LP-014)
//
// 사용: node verify_plan.mjs <D1 HTML> <원장 CSV 절대경로> <매뉴얼 요소 대조 CSV> "<분모 산출 명령>"
// 출력: 검사별 PASS/FAIL 한 줄 + 소조건 단위 위반 목록 + 검사마다 읽은 대상 수. FAIL 1건 이상 → 종료 코드 1.
//
// [HARD] 문서가 적어 준 명령 문자열을 실행하지 않는다 — 4번째 인자(호출자가 준 명령)와 문자열이 같은지만 비교하고,
//        실행하는 것은 인자 쪽이다(AC-LP-014(e)(i)). 분모를 이 파일에 상수로 적지 않는다.
// [HARD] 검사 대상 행이 0 이면 FAIL(빈 문서는 통과가 아니다 · 리드 판정 R-α).
// 체크리스트 행의 추가 속성(data-row-id · data-api-path · data-api-evidence)은 허용한다(리드 판정 260917).
import { execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { JSDOM } from "jsdom";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const [htmlPath, ledgerPath, matrixPath, denomCmd] = process.argv.slice(2);
if (!htmlPath || !ledgerPath || !matrixPath || !denomCmd) {
  console.error('usage: node verify_plan.mjs <D1.html> <ledger.csv> <matrix.csv> "<denominator command>"');
  process.exit(2);
}

// ───────────── 공통 도구 ─────────────
const NAMES = ["김동학", "서희항", "최숙진", "김용기", "신우진", "지니", "채훈희"];
const STEPS = new Set([
  ...["A1", "A2", "A3", "A4", "A5"], ...["B1", "B2", "B3", "B4", "B5", "B6", "B7"],
  ...["C1", "C2", "C3", "C4", "C5", "C6", "C7"], ...["D1", "D2", "D3", "D4", "D5"],
  ...["E1", "E2", "E3", "E4"], ...["F1", "F2", "F3", "F4"],
]);
const HOSTS = ["huniprinting.co.kr", "printly.co.kr", "shopby.co.kr"];
const DATE_LIT = /\d{4}-\d{2}-\d{2}|\d+월 \d+일/;
const OPEN_DATE = /10\/6|10월 6일|2026-10-06/;
const PRED = /가능|불가|어렵|무리|힘들|충분|맞출 수/;

function parseCsv(text) {
  const rows = []; let row = []; let f = ""; let q = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (q) {
      if (c === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += c;
    } else if (c === '"') q = true;
    else if (c === ",") { row.push(f); f = ""; }
    else if (c === "\n" || c === "\r") {
      if (c === "\r" && text[i + 1] === "\n") i++;
      row.push(f); rows.push(row); row = []; f = "";
    } else f += c;
  }
  if (f.length || row.length) { row.push(f); rows.push(row); }
  const [head, ...body] = rows.filter((r) => r.length > 1 || r[0] !== "");
  return body.map((r) => Object.fromEntries(head.map((h, i) => [h, r[i] ?? ""])));
}

const html = fs.readFileSync(htmlPath, "utf-8");
const dom = new JSDOM(html);
const doc = dom.window.document;
const $ = (sel, root = doc) => root.querySelector(sel);
const $$ = (sel, root = doc) => [...root.querySelectorAll(sel)];
const txt = (el) => (el?.textContent ?? "").replace(/\s+/g, " ").trim();
const ledger = parseCsv(fs.readFileSync(ledgerPath, "utf-8"));
const ledgerIds = new Set(ledger.map((r) => Object.values(r)[0]));
const matrix = parseCsv(fs.readFileSync(matrixPath, "utf-8"));

// 증거 경로 해소 루트: D1 의 저장소 루트(docs/huni 두 칸 위) + 원장 CSV 가 사는 저장소 루트
const ROOTS = [
  path.resolve(path.dirname(htmlPath), "..", ".."),
  ledgerPath.split("/_workspace/")[0],
];

const results = [];
function check(id, title, subs) {
  // subs: [{ name, read, violations: [] }]
  const fails = subs.filter((s) => s.violations.length || s.read === 0);
  results.push({ id, ok: fails.length === 0 });
  console.log(`[${fails.length ? "FAIL" : "PASS"}] ${id} ${title}`);
  for (const s of subs) {
    const zero = s.read === 0 ? " · 대상 0 → FAIL" : "";
    console.log(`    (${s.name}) 읽은 대상 ${s.read}${zero}${s.violations.length ? ` · 위반 ${s.violations.length}` : ""}`);
    for (const v of s.violations.slice(0, 12)) console.log(`        - ${v}`);
    if (s.violations.length > 12) console.log(`        … 외 ${s.violations.length - 12}`);
  }
}
const sub = (name, read, violations) => ({ name, read, violations });

// 체크리스트 행
const allRows = $$("tr[data-role]");
const topRows = allRows.filter((r) => r.dataset.role === "top");
const cellOf = (tr, cls) => txt(tr.querySelector(`td.${cls}`));

// ───────────── AC-LP-001 자기완결 + 라이트 테마 ─────────────
{
  const ext = [];
  const allowStyle = /^https:\/\/(cdn\.jsdelivr\.net\/gh\/orioncactus\/pretendard\/|cdn\.jsdelivr\.net\/gh\/orioncactus\/pretendard@|fonts\.googleapis\.com\/)/;
  $$("script[src]").forEach((s) => ext.push(`script src=${s.getAttribute("src")}`));
  $$('link[rel="stylesheet"][href]').forEach((l) => { if (!allowStyle.test(l.getAttribute("href"))) ext.push(`stylesheet ${l.getAttribute("href")}`); });
  $$('img[src^="http"]').forEach((i) => ext.push(`img ${i.getAttribute("src")}`));
  // 인라인 모듈 import 는 mermaid CDN 만 허용
  $$("script:not([src])").forEach((s) => {
    for (const m of s.textContent.matchAll(/from\s+["'](https?:[^"']+)["']/g)) {
      if (!/^https:\/\/cdn\.jsdelivr\.net\/npm\/mermaid@/.test(m[1])) ext.push(`import ${m[1]}`);
    }
  });
  const pcs = (html.match(/prefers-color-scheme/g) || []).length;
  const styleText = $$("style").map((s) => s.textContent).join("\n");
  const darkSel = (styleText.match(/\[class~="dark"\]|\[data-theme/g) || []).length;
  const toggleRx = /theme-toggle|themeToggle|toggleTheme|data-theme/;
  let toggles = 0;
  for (const el of $$("*")) {
    for (const a of el.attributes) if ((a.name === "id" || a.name === "class" || a.name.startsWith("data-")) && (toggleRx.test(a.value) || toggleRx.test(a.name))) toggles++;
  }
  $$("script").forEach((s) => { if (toggleRx.test(s.textContent)) toggles++; });
  check("AC-LP-001", "자기완결 + 라이트 테마 전용", [
    sub("① 허용 밖 외부 참조 0", $$("script, link[rel=stylesheet], img").length, ext),
    sub("② prefers-color-scheme 0", 1, pcs ? [`출현 ${pcs}`] : []),
    sub("③ 다크 선택자 0", 1, darkSel ? [`출현 ${darkSel}`] : []),
    sub("④ 테마 토글 0", 1, toggles ? [`출현 ${toggles}`] : []),
  ]);
}

// ───────────── 산문 노드 추출(AC-LP-002 제외 목록 ①~⑤) ─────────────
function proseNodes(root = doc.body) {
  const out = [];
  const walker = doc.createTreeWalker(root, dom.window.NodeFilter.SHOW_TEXT);
  for (let n = walker.nextNode(); n; n = walker.nextNode()) {
    let excluded = false;
    for (let p = n.parentElement; p; p = p.parentElement) {
      if (p.matches("script, style, td.evidence, .source, #appendix")) { excluded = true; break; }
    }
    if (!excluded && n.textContent.trim()) out.push(n);
  }
  return out;
}
const prose = proseNodes();
const proseText = (nodes) => nodes.map((n) => n.textContent).join("\n");

// ───────────── AC-LP-002 Out of Scope 통합 ─────────────
{
  const all = proseText(prose)
    .replace(/위험 R\d+/g, "")                                   // ③
    .replace(/\b(?:[A-E][1-7]|F[1-4]|T[1-7]|D-P[1-9])\b/g, "")   // ④ 구간·트랙·결정 번호
    .replace(/STD-[A-Z]+-\d+/g, "");
  const codeRx = /\bS[1-5]\b|\bR[1-5][a-e]?\b|CARDS-|라운드 [A-Z0-9]+|round-\d+|manager-|-orchestrator|plan-auditor/g;
  const codes = [...all.matchAll(codeRx)].map((m) => `「${m[0]}」 …${all.slice(Math.max(0, m.index - 20), m.index + 20).replace(/\n/g, " ")}…`);
  const rej = [];
  for (const t of ["565일", "348행"]) { const n = all.split(t).length - 1; if (n) rej.push(`${t} ${n}회`); }
  const outside = prose.filter((n) => !n.parentElement.closest("#critical-path, #decisions"));
  const sentences = proseText(outside).split(/(?<=[.!?。])\s+|\n/);
  const judge = sentences.filter((s) => OPEN_DATE.test(s) && PRED.test(s)).map((s) => s.trim().slice(0, 80));
  const imp = (all.match(/조판|imposition/g) || []).length;
  check("AC-LP-002", "Out of Scope 금지 4종", [
    sub("(a) 내부 코드명 0", prose.length, codes),
    sub("(b) 반려 수치 0", prose.length, rej),
    sub("(c) 오픈일 판정 문장 0(critical-path·decisions 밖)", sentences.length, judge),
    sub("(d) 조판 ≤ 1", prose.length, imp > 1 ? [`출현 ${imp}회`] : []),
  ]);
}

// ───────────── AC-LP-003 13섹션 + 범위 두 표 ─────────────
{
  const ids = $$("[id^=sec-]").map((e) => e.id).filter((i) => /^sec-\d{2}$/.test(i));
  const v = [];
  const want = Array.from({ length: 13 }, (_, i) => `sec-${String(i + 1).padStart(2, "0")}`);
  if (JSON.stringify(ids) !== JSON.stringify(want)) v.push(`앵커 순서/중복 ${ids.join(",")}`);
  const s2 = $("#sec-02");
  const tables = s2 ? $$("table", s2) : [];
  const vb = [];
  if (tables.length < 2) vb.push(`표 ${tables.length}개`);
  const lab = tables.map((t) => txt(t.querySelector("caption")) || txt(t.previousElementSibling));
  const hasOpen = lab.some((l) => l.includes("오픈 필수") && !l.includes("오픈 후"));
  const hasAfter = lab.some((l) => l.includes("오픈 후") && !l.includes("오픈 필수"));
  if (!hasOpen) vb.push("「오픈 필수」 단독 라벨 표 없음");
  if (!hasAfter) vb.push("「오픈 후」 단독 라벨 표 없음");
  if (!s2 || !/범위 동결/.test(txt(s2))) vb.push("범위 동결 규칙 문단 없음");
  check("AC-LP-003", "13섹션 골격 + 범위 두 표", [sub("(a) sec-01~13 순서", ids.length, v), sub("(b) 범위 두 표·동결 규칙", tables.length, vb)]);
}

// ───────────── mermaid 파싱(jsdom 전역 준비 후 동적 import) ─────────────
globalThis.window = new JSDOM("<!doctype html><body></body>", { pretendToBeVisual: true }).window;
globalThis.document = globalThis.window.document;
const { default: mermaid } = await import(path.join(HERE, "node_modules/mermaid/dist/mermaid.core.mjs"));
mermaid.initialize({ startOnLoad: false, securityLevel: "strict" });
async function parseMermaid(el) {
  const src = el?.querySelector("pre.mermaid")?.textContent;
  if (!src) return { ok: false, err: "mermaid 소스 없음", src: "" };
  try { await mermaid.parse(src); return { ok: true, src }; } catch (e) { return { ok: false, err: String(e.message).split("\n")[0], src }; }
}
const OWN2 = /NHN 제공|후니 개발/g;

// ───────────── AC-LP-004 스윔레인 + CTO 10구간 ─────────────
{
  const sw = await parseMermaid($("#diag-swimlane"));
  const va = [];
  if (!sw.ok) va.push(`파싱 실패: ${sw.err}`);
  const lanes = [...sw.src.matchAll(/^\s*subgraph\s+\w+\s*\["([^"]*)"\]/gm)].map((m) => m[1]);
  if (lanes.length < 3 || lanes.length > 7) va.push(`레인 ${lanes.length}개`);
  for (const l of lanes) {
    const own = l.match(OWN2) || [];
    if (own.length !== 1) va.push(`레인 소유 라벨 ${own.length}개: ${l}`);
  }
  const items = $$("#map-cto10 > li");
  const vb = []; const vc = [];
  if (items.length !== 10) vb.push(`상위 항목 ${items.length}개`);
  items.forEach((li, i) => {
    if (!/\b[A-E][1-7]\b/.test(li.dataset.steps || txt(li))) vb.push(`${i + 1}번 구간 참조 없음`);
    const imp = txt(li.querySelector(".impact"));
    if (!(imp.length >= 15 && /[.。]$/.test(imp))) vc.push(`${i + 1}번 영향 문장 부적격: ${imp}`);
  });
  check("AC-LP-004", "스윔레인 3~7 + CTO 10구간 매핑", [
    sub("(a) 파싱·레인 수·소유 라벨", lanes.length, va), sub("(b) 상위 10 · 구간 참조", items.length, vb), sub("(c) 영향 문장", items.length, vc),
  ]);
}

// ───────────── AC-LP-005 요약·마일스톤·배치도 ─────────────
{
  const s1 = $("#sec-01");
  const va = [];
  for (const k of ["what-why", "rag", "risks", "next-milestone", "rollup", "legend"]) if (!s1?.querySelector(`[data-el="${k}"]`)) va.push(`요소 없음 ${k}`);
  const risks = $$('[data-el="risks"] li', s1 || doc).length;
  if (risks < 3 || risks > 4) va.push(`상위 리스크 ${risks}개`);
  const proseLen = s1 ? $$("p", s1).map(txt).join(" ").length : 0;
  if (proseLen > 700) va.push(`요약 산문 ${proseLen}자`);
  $$('[data-el="legend"] li', s1 || doc).forEach((li) => { if (!/\d/.test(txt(li))) va.push(`범례 숫자 기준 없음: ${txt(li)}`); });
  const ms = $$("#diag-milestone > li");
  const vb = [];
  if (ms.length < 4 || ms.length > 6) vb.push(`마일스톤 ${ms.length}개`);
  ms.forEach((li, i) => {
    if (!NAMES.includes(txt(li.querySelector(".ms-owner")))) vb.push(`${i + 1}번 오너 실명 아님`);
    if (!txt(li.querySelector(".ms-status"))) vb.push(`${i + 1}번 상태 없음`);
  });
  if (ms[0]?.dataset.track !== "T1") vb.push("첫 마일스톤이 T1 아님");
  const tp = await parseMermaid($("#diag-topology"));
  const vc = [];
  if (!tp.ok) vc.push(`파싱 실패: ${tp.err}`);
  const nodes = [...tp.src.matchAll(/^\s*(\w+)\["([^"]*)"\]/gm)].map((m) => m[2]);
  if (nodes.length > 12) vc.push(`노드 ${nodes.length}개`);
  for (const n of nodes) {
    if (!NAMES.some((x) => n.includes(x))) vc.push(`실명 없음: ${n}`);
    const own = n.match(OWN2) || [];
    if (own.length !== 1) vc.push(`소유 라벨 ${own.length}개: ${n}`);
  }
  check("AC-LP-005", "요약·마일스톤·배치도", [sub("(a) 요약 6요소·700자·범례", 6, va), sub("(b) 마일스톤 4~6·오너·상태·T1 첫째", ms.length, vb), sub("(c) 배치도 ≤12·실명·소유 라벨", nodes.length, vc)]);
}

// ───────────── AC-LP-006 체크리스트 7블록 ─────────────
{
  const va = []; const vb = []; const vc = []; const vd = []; const ve = [];
  for (let t = 1; t <= 7; t++) {
    const blk = $(`#track-T${t}`);
    if (!blk) { va.push(`track-T${t} 없음`); continue; }
    const n = $$('tr[data-role="top"]', blk).length;
    if (n < 3 || n > 5) va.push(`T${t} 최상위 ${n}행`);
  }
  for (const tr of topRows) {
    const id = tr.dataset.rowId;
    for (const c of ["owner", "duedate", "evidence", "check", "prereq", "status"]) if (!cellOf(tr, c)) vb.push(`${id} 빈 칸 ${c}`);
    const o = cellOf(tr, "owner");
    if (!(NAMES.includes(o) || /^외부\(.+\)$/.test(o))) vc.push(`${id} 담당 「${o}」`);
    const ck = cellOf(tr, "check");
    if (!(/열|누르|접속|조회|실행/.test(ck) && /화면|메뉴|페이지|콘솔|목록/.test(ck) && ck.length >= 15)) vd.push(`${id} 체크 방법 「${ck}」`);
  }
  for (const tr of allRows) {
    const { owner, work, rowId } = tr.dataset;
    if (!["nhn", "huni", "ext"].includes(owner)) ve.push(`${rowId} data-owner=${owner}`);
    if (!["config", "dev", "wait"].includes(work)) ve.push(`${rowId} data-work=${work}`);
    if ((owner === "nhn" || owner === "ext") && work === "dev") ve.push(`${rowId} ${owner}×dev`);
    if (work === "wait" && owner !== "ext") ve.push(`${rowId} wait×${owner}`);
  }
  check("AC-LP-006", "체크리스트 7블록·3~5·6칸·체크 방법·소유 분류", [
    sub("(a) 7블록·최상위 3~5", 7, va), sub("(b) 6칸 빈칸 0", topRows.length, vb), sub("(c) 담당 실명", topRows.length, vc),
    sub("(d) 체크 방법 실질", topRows.length, vd), sub("(e) 소유·분류 제약(전 행)", allRows.length, ve),
  ]);
}

// ───────────── AC-LP-007 증거 규칙 ─────────────
function resolveFile(p) {
  for (const r of ROOTS) { const f = path.join(r, p); if (fs.existsSync(f) && fs.statSync(f).isFile()) return f; }
  return null;
}
const URL_EV = /^(https?:\/\/([^/\s@]+)[^\s@]*)@(\d{4}-\d{2}-\d{2})(?: \d{2}:\d{2})?$/;
const hostOk = (h) => HOSTS.some((x) => h === x || h.endsWith(`.${x}`));
{
  const va = []; const vb = []; const vc = []; const vd = [];
  let fileEv = 0; let urlEv = 0; let newN = 0;
  for (const tr of topRows) {
    const id = tr.dataset.rowId; const ev = cellOf(tr, "evidence");
    const u = ev.match(URL_EV);
    if (u) { urlEv++; if (!hostOk(u[2])) vb.push(`${id} 호스트 ${u[2]}`); continue; }
    const f = ev.match(/^(.+):(\d+)$/);
    if (f) {
      fileEv++;
      const p = resolveFile(f[1]);
      if (!p) { va.push(`${id} 경로 없음 ${f[1]}`); continue; }
      const lines = fs.readFileSync(p, "utf-8").split("\n").length;
      if (+f[2] < 1 || +f[2] > lines) va.push(`${id} 줄 ${f[2]} > 총 ${lines}`);
    } else vb.push(`${id} 증거 형식 불명 「${ev}」`);
  }
  for (const tr of topRows) {
    const id = tr.dataset.rowId; const std = tr.getAttribute("data-std");
    if (std === null) { vc.push(`${id} data-std 누락`); continue; }
    for (const s of std.split(";")) {
      if (s === "NEW") { newN++; if (!/NEW 사유/.test(txt(tr.querySelector(".new-reason")))) vc.push(`${id} NEW 사유 문장 없음`); } else if (!ledgerIds.has(s)) vc.push(`${id} 원장에 없음 ${s}`);
    }
  }
  if (newN > topRows.length * 0.3) vc.push(`NEW 최상위 ${newN}/${topRows.length} > 30%`);
  const working = allRows.filter((tr) => cellOf(tr, "status") === "작동");
  for (const tr of working) {
    const ev = cellOf(tr, "evidence"); const u = ev.match(URL_EV);
    if (!u) vd.push(`${tr.dataset.rowId} URL@일시 아님 「${ev.slice(0, 60)}」`);
    else if (!hostOk(u[2])) vd.push(`${tr.dataset.rowId} 호스트 ${u[2]}`);
    else if (u[3] < "2026-09-16") vd.push(`${tr.dataset.rowId} 일시 ${u[3]}`);
  }
  check("AC-LP-007", "증거 실재 + 작동 판정 규율", [
    sub(`(a) 파일:줄 실재(최상위 · 파일 증거 ${fileEv})`, topRows.length, va), sub(`(b) URL@일시 형식·호스트(최상위 · URL 증거 ${urlEv})`, topRows.length, vb),
    sub(`(c) data-std 원장 실재 · NEW ${newN} ≤ 30%`, topRows.length, vc), sub("(d) 작동 행 전부 URL@일시 ≥ 2026-09-16(전 행)", working.length, vd),
  ]);
}

// ───────────── AC-LP-008 구간 귀속 + 역할 진입점 ─────────────
{
  const va = allRows.filter((tr) => !STEPS.has(tr.dataset.step)).map((tr) => `${tr.dataset.rowId} data-step=${tr.dataset.step}`);
  const vb = [];
  for (const r of ["role-shopdev", "role-printdev", "role-ops", "role-pm", "role-exec"]) {
    const n = $$(`#${r} li`).length; if (!n) vb.push(`${r} 항목 ${n}`);
  }
  check("AC-LP-008", "구간 귀속 + 역할별 진입점", [sub("data-step 허용 집합", allRows.length, va), sub("역할 앵커 5·각 1건 이상", 5, vb)]);
}

// ───────────── AC-LP-009 T1 ─────────────
{
  const blk = $("#track-T1"); const t = txt(blk);
  const va = ["F1", "F2", "F3", "F4"].filter((f) => !new RegExp(`\\b${f}\\b`).test(t)).map((f) => `${f} 라벨 없음`);
  const entry = $$("#t1-entry > li", blk || doc).length;
  const vb = entry === 9 ? [] : [`진입 조건 ${entry}항`];
  const vc = [];
  for (const s of ["F3-11", "F4-8"]) {
    const holders = $$("*", blk || doc).filter((e) => txt(e).includes(s) && txt(e).includes("오픈 테스트 통과 전 금지") && e.children.length < 12);
    if (!holders.length) vc.push(`${s} 금지 표기 없음`);
  }
  const rd = $("#t1-redirect-reverify", blk || doc);
  const vd = rd && /로그인 리다이렉트/.test(txt(rd)) && /재검증/.test(txt(rd)) ? [] : ["리다이렉트 재검증 행 없음"];
  check("AC-LP-009", "T1 인프라", [sub("(a) F1~F4", 4, va), sub("(b) 진입 조건 정확히 9", entry, vb), sub("(c) F3-11·F4-8 금지 표기", 2, vc), sub("(d) 리다이렉트 재검증", 1, vd)]);
}

// ───────────── AC-LP-010 T4 ─────────────
{
  const blk = $("#track-T4"); const t = txt(blk);
  const pos = ["설계 결정", "구현", "종단 테스트"].map((w) => t.indexOf(w));
  const va = pos.every((p, i) => p >= 0 && (i === 0 || p > pos[i - 1])) ? [] : [`단계 순서 ${pos}`];
  const vb = [];
  for (let i = 1; i <= 9; i++) {
    const tr = $$("#t4-decisions tr", blk || doc).find((r) => txt(r).startsWith(`D-P${i}`));
    if (!tr) { vb.push(`D-P${i} 없음`); continue; }
    if (!NAMES.some((n) => txt(tr.querySelector(".decider")).includes(n))) vb.push(`D-P${i} 결정자 실명 없음`);
  }
  const want = { C1: "구현-미검증", C2: "구현-미검증", "C3 수신": "구현-미검증", "C3 해석": "없음", C4: "없음", C5: "없음", C6: "없음", C7: "없음" };
  const vc = [];
  for (const [k, v] of Object.entries(want)) {
    const tr = $(`#t4-status tr[data-seg="${k}"]`, blk || doc);
    const got = txt(tr?.querySelector(".status"));
    if (got !== v) vc.push(`${k} 기대 ${v} · 실제 「${got}」`);
  }
  check("AC-LP-010", "T4 3단 + D-P1~9 + C1~C7 값 대조", [sub("(a) 3단계 순서", 3, va), sub("(b) D-P1~9 결정자", 9, vb), sub("(c) 상태 값 대조", Object.keys(want).length, vc)]);
}

// ───────────── AC-LP-011 T3·T6 이관 ─────────────
{
  const va = []; const vb = []; const vc = []; const vd = [];
  const expect = { T3: ["Shopby 회원 생성 경로", "구 DB 접속 권한"], T6: ["구 DB 접속 권한", "잔액 스냅샷 원천"] };
  const names6 = ["구 DB 접근 확보", "스키마 분석", "매핑 설계", "이관 스크립트", "샘플 검증", "컷오버 delta"];
  for (const t of ["T3", "T6"]) {
    const blk = $(`#track-${t}`);
    const steps = $$(".mig6 > li", blk || doc);
    if (steps.length !== 6) va.push(`${t} 단계 ${steps.length}`);
    steps.forEach((li, i) => { if (!txt(li).includes(names6[i])) va.push(`${t} ${i + 1}단계 「${txt(li)}」`); });
    const deps = $$(".mig6 .ext-dep", blk || doc).map(txt);
    if (deps.length !== 2) vb.push(`${t} 6단계 하위 외부 의존 ${deps.length}건`);
    for (const d of expect[t]) if (!deps.some((x) => x.includes(d))) vb.push(`${t} 외부 의존 「${d}」 없음`);
    if (!/미확정/.test(txt(blk?.querySelector(".mig-owner")))) vd.push(`${t} 담당 미확정 표기 없음`);
    if (!/구 ASP/.test(txt(blk?.querySelector(".p6")))) vd.push(`${t} P-6 덮어쓰기 문장 없음`);
  }
  const t6w = txt($("#track-T6 #t6-outside-waits"));
  if (!/토스페이먼츠/.test(t6w)) vc.push("T6 밖 토스 계약 대기 없음");
  if (!/엔터프라이즈/.test(t6w) || !/외부포인트/.test(t6w)) vc.push("T6 밖 엔터프라이즈·외부포인트 대기 없음");
  check("AC-LP-011", "T3·T6 이관 6단계 + 외부 의존 계층", [sub("(a) 6단계 순서", 2, va), sub("(b) 하위 외부 의존 정확히 2", 2, vb), sub("(c) T6 밖 대기 2종", 1, vc), sub("(d) 미확정·P-6", 2, vd)]);
}

// ───────────── AC-LP-012 임계경로 + 3레버 ─────────────
{
  const cp = $("#critical-path");
  const heads = $$("h3", cp || doc).map(txt);
  const order = ["필요 항목", "의존·외부 대기", "임계경로", "도출된 오픈일"].map((w) => heads.findIndex((h) => h.includes(w)));
  const va = order.every((p, i) => p >= 0 && (i === 0 || p > order[i - 1])) ? [] : [`순서 ${order} · ${heads.join(" / ")}`];
  if (!/^\d{4}-\d{2}-\d{2}$/.test(txt($("#derived-open-date", cp || doc)))) va.push("도출된 오픈일 날짜 없음");
  const vb = [];
  const waitLis = $$("#wait-items > li", cp || doc);
  for (const li of waitLis) {
    const t = txt(li.querySelector(".wait-target"));
    if (!(NAMES.includes(t) || (/^외부\(.+\)$/.test(t) && !/확인 필요|미정/.test(t)))) vb.push(`회신 요청 대상 부적격 「${t}」: ${txt(li).slice(0, 50)}`);
  }
  const waitSet = new Set(waitLis.map((li) => li.dataset.row));
  const rowSet = new Set(allRows.filter((tr) => tr.dataset.owner === "ext" && tr.dataset.work === "wait").map((tr) => tr.dataset.rowId));
  const onlyList = [...waitSet].filter((x) => !rowSet.has(x)); const onlyRows = [...rowSet].filter((x) => !waitSet.has(x));
  if (onlyList.length || onlyRows.length) vb.push(`외부 대기 목록 ≠ ext×wait 행 집합 · 목록만 ${onlyList.length} · 행만 ${onlyRows.length}`);
  const dev = $$("#devenv-prereq > li", cp || doc).length;
  if (!dev) vb.push("쓰기경로-dev환경필요 선행 항목 없음");
  if (!$$('a[href="#t1-entry"]', cp || doc).length) vb.push("T1 진입 조건 상호 참조 없음");
  const vc = [];
  for (const k of ["date", "people", "scope"]) {
    const tr = $(`#decisions tr[data-lever="${k}"]`);
    if (!tr || !NAMES.some((n) => txt(tr.querySelector(".decider")).includes(n))) vc.push(`레버 ${k} 결정자 실명 없음`);
  }
  check("AC-LP-012", "임계경로 전진 구축 + 3레버", [sub("(a) 순서·도출 날짜", heads.length, va), sub(`(b) 외부 대기 ${waitLis.length} · dev 선행 ${dev}`, waitLis.length, vb), sub("(c) 3레버 결정자", 3, vc)]);
}

// ───────────── AC-LP-013 운영 섹션 ─────────────
{
  const g = $("#go-no-go"); const gt = txt(g);
  const va = [];
  for (const s of ["Green", "Yellow", "Red", "Unknown"]) if (!gt.includes(s)) va.push(`${s} 없음`);
  const unk = $$("li", g || doc).find((li) => txt(li).startsWith("Unknown"));
  if (!unk || !/차단/.test(txt(unk))) va.push("Unknown = 차단 정의 없음");
  const deciders = new Set(NAMES.filter((n) => gt.includes(n)));
  if (deciders.size !== 1) va.push(`결정권자 실명 ${deciders.size}명`);
  if (!/\d{4}-\d{2}-\d{2}/.test(txt($(".meeting-date", g || doc)))) va.push("회의 일자 없음");
  const cutRows = $$("#cutover-table tbody tr");
  const vb = [];
  cutRows.forEach((tr, i) => { const tds = $$("td", tr).map(txt); if (tds.length !== 5 || tds.some((x) => !x)) vb.push(`${i + 1}행 칸 ${tds.length}·빈칸`); if (!NAMES.some((n) => tds[1]?.includes(n))) vb.push(`${i + 1}행 담당 실명 없음`); });
  const rb = txt($("#rollback-trigger"));
  if (!(/\d/.test(rb) && NAMES.some((n) => rb.includes(n)) && /시간|분/.test(rb))) vb.push("롤백 트리거 수치·결정자·시한 미비");
  const hc = $$("#hypercare-exit > li");
  const vc = hc.filter((li) => { const t = txt(li); return !(/\d/.test(t) && /이하|이상|미만|%|건|원|시간|일/.test(t)) || DATE_LIT.test(t); }).map((li) => txt(li));
  const vd = [];
  const raciRows = $$("#raci-table tbody tr");
  raciRows.forEach((tr) => { const a = $$("td", tr).filter((td) => txt(td) === "A").length; if (a !== 1) vd.push(`「${txt(tr.cells[0])}」 A ${a}개`); });
  const cm = $("#comms");
  const heads = $$("thead th", cm || doc).map(txt);
  for (const h of ["대상", "메시지 수준", "주기", "채널", "담당자"]) if (!heads.includes(h)) vd.push(`의사소통 요소 없음 ${h}`);
  $$("tbody tr", cm || doc).forEach((tr, i) => { if ($$("td", tr).some((td) => !txt(td))) vd.push(`의사소통 ${i + 1}행 빈칸`); });
  check("AC-LP-013", "Go/No-Go · 컷오버 · 하이퍼케어 · RACI", [
    sub("(a) 4상태·결정권자 1인·회의일", 4, va), sub("(b) 컷오버 5칸·롤백 트리거", cutRows.length, vb),
    sub("(c) 하이퍼케어 지표·날짜 없음", hc.length, vc), sub("(d) RACI A 1개·소통 5요소", raciRows.length, vd),
  ]);
}

// ───────────── AC-LP-014 판매 준비 프로세스 ─────────────
{
  const s6 = $("#sec-06");
  const menu = $("#map-webadmin-menu"); const menuRows = $$("tbody tr", menu || doc);
  const va = [];
  if (!s6?.contains(menu) || !s6?.contains($("#diag-option-price")) || !s6?.contains($("#map-manual-elements"))) va.push("sec-06 안 3블록 부재");
  if (menuRows.length !== 37) va.push(`메뉴 ${menuRows.length}개`);
  const bd = txt(menu).match(/사이드바 (\d+) \+ 비사이드바 (\d+)/);
  if (!bd || +bd[1] + +bd[2] !== menuRows.length) va.push("내역(사이드바 + 비사이드바) 한 줄 없음·합 불일치");
  const vb = [];
  menuRows.forEach((tr, i) => { if (!tr.querySelector("td.gap")) vb.push(`${i + 1}행 갭 열 없음`); });
  const gaps = menuRows.filter((tr) => tr.dataset.gap === "Y").length;
  if (!gaps) vb.push("갭 1건 이상 아님");
  const vc = [];
  const gc = txt($(".gap-count", menu || doc)).match(/(\d+)/);
  if (!gc || +gc[1] !== gaps) vc.push(`갭 숫자 ${gc?.[1]} ≠ 갭 표기 행 ${gaps}`);
  if (!/판정 기준/.test(txt(menu))) vc.push("갭 판정 기준 없음");
  if (!$(".source", menu || doc)) vc.push("원천 경로 없음");
  const stages = $$("#diag-option-price > li");
  const names = ["상품 구성요소", "가격공식", "위젯 cfg", "고객 화면", "/api/w/v1/price"];
  const vd = [];
  if (stages.length !== 5) vd.push(`단계 ${stages.length}`);
  stages.forEach((li, i) => { if (!txt(li).includes(names[i])) vd.push(`${i + 1}단계 「${txt(li)}」`); if (!txt(li.querySelector(".fix-screen"))) vd.push(`${i + 1}단계 고치는 화면 라벨 없음`); });

  // (e) 매뉴얼 요소 대조
  const ve = [];
  const declared = $("#denominator-command")?.textContent ?? "";
  let denom = null;
  if (declared.trim() !== denomCmd.trim()) ve.push("(i) D1 선언 명령 ≠ 4번째 인자");
  else {
    try { denom = Number(execSync(denomCmd, { cwd: ROOTS[1], shell: "/bin/bash", encoding: "utf-8" }).trim()); } catch (e) { ve.push(`(i) 인자 명령 실행 실패 ${String(e.message).slice(0, 80)}`); }
  }
  const appendixRows = $$("#manual-element-matrix tbody tr").length;
  const summarySum = $$("#manual-screen-counts tbody tr td.n").reduce((a, td) => a + Number(txt(td)), 0);
  if (denom !== null && !(denom === matrix.length && matrix.length === appendixRows && appendixRows === summarySum)) {
    ve.push(`(i) 사슬 불일치 원고 분모 ${denom} · CSV ${matrix.length} · 부록 ${appendixRows} · 요약 합 ${summarySum}`);
  }
  const kind = (v) => v.split("(")[0];
  const KINDS = ["동작확인", "불일치", "쓰기경로-dev환경필요", "미실측"];
  const res = matrix.map((r) => r["실측 결과"]);
  res.filter((v) => kind(v) === "동작확인").forEach((v, i) => {
    const m = v.match(/@(\d{4}-\d{2}-\d{2})/);
    if (!m || m[1] < "2026-09-17") ve.push(`(ii) 동작확인 ${i + 1} 일시 「${v}」`);
  });
  res.filter((v) => !KINDS.includes(kind(v))).forEach((v) => ve.push(`(iii) 4종 밖 값 「${v}」`));
  res.filter((v) => kind(v) === "미실측" && !/\(.+\)/.test(v)).forEach((v) => ve.push(`(iv) 미실측 사유 빈칸 「${v}」`));
  for (const id of ["manual-mismatch", "manual-writepath"]) { const el = $(`#${id}`); if (!el || el.closest("details")) ve.push(`(iv) ${id} 가 접힘 밖에 없음`); }
  if (!$('#manual-t1-link a[href="#t1-entry"]')) ve.push("(iv) 쓰기경로 목록의 T1 진입 조건 연결 문장 없음");
  // (v) 화면 축 하한 — 메뉴 행 중 매뉴얼 화면 섹션(SCREENS/MODEL_ADMIN)을 가진 행 = 읽기 경로 대조 대상.
  //     자체 문서·별도 문서·섹션 없음·「—」 행은 대조할 콜아웃이 없어 대상에서 뺀다(판정 해석 — progress.md 기록).
  const norm = (s) => (s || "").replace(/\(.*?\)|（.*?）/g, "").replace(/[\s·/]/g, "");
  const normPath = (p) => (p || "").split("?")[0].replace(/\{[^}]+\}/g, "{}").replace(/[A-Z]+_\d+/g, "{}");
  const mPaths = new Set(matrix.map((r) => normPath(r["경로"])).filter(Boolean));
  const mSegs = matrix.map((r) => norm((r["화면"].split(" › ")[1] || "")));
  const targets = menuRows.filter((tr) => /^(deep|표준화면|light)/.test(tr.dataset.manual || ""));
  for (const tr of targets) {
    const cells = $$("td", tr).map(txt); const name = norm(cells[1]); const p = normPath(cells[2]);
    const byPath = mPaths.has(p);
    const byName = mSegs.some((s) => s && (s.includes(name) || name.includes(s)));
    if (!byPath && !byName) ve.push(`(v) 매트릭스가 덮지 않는 화면 「${cells[1]}」 ${cells[2]}`);
  }
  const unmeasured = res.filter((v) => kind(v) === "미실측").length;
  if (unmeasured > matrix.length * 0.3) ve.push(`(vi) 미실측 ${unmeasured}/${matrix.length} > 30%`);
  if (!matrix.length) ve.push("(e) 매트릭스 행 0");
  check("AC-LP-014", "판매 준비 프로세스 3블록", [
    sub("(a) 메뉴 37·내역", menuRows.length, va), sub(`(b) 갭 열·갭 ${gaps}건`, menuRows.length, vb), sub("(c) 갭 수·기준·원천", 1, vc),
    sub("(d) 옵션↔가격 5단계·고치는 화면", stages.length, vd),
    sub(`(e) 매트릭스 사슬·값·하한(원고 분모 ${denom} · 부록 ${appendixRows} · 요약 합 ${summarySum} · 화면 대상 ${targets.length} · 미실측 ${unmeasured})`, matrix.length, ve),
  ]);
}

const failed = results.filter((r) => !r.ok);
console.log(`\n== D3 RESULT: ${results.length - failed.length}/${results.length} PASS${failed.length ? ` · FAIL ${failed.map((r) => r.id).join(", ")}` : ""} ==`);
process.exit(failed.length ? 1 : 0);
