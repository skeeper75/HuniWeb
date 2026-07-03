#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
build_graph.py — 정본(03_kb/**/*.md) → 그래프 결정론 빌드 (graph-build-spec v1.0.1).

LLM은 이 경로에 개입하지 않는다(D-4). 파이프라인:
  ① 수집 03_kb/**/*.md (정렬)  ② 파싱(frontmatter id-노드 + ### [id] 블록-노드 + 본문 [[ ]] references)
  ③ 앵커검사(t_*/코드는 live-snapshot 실재·L-17)  ④ lint(구조/의미/소프트)
  ⑤ 역링크(backlinks 파생)  ⑥ 직렬화(키정렬 JSONL·04_graph/)  ⑦ SQLite 적재  ⑧ 리포트(05_verification/)
멱등: 같은 입력 → 바이트 동일 nodes.jsonl·edges.jsonl. 2회 실행 해시 동일(I-5).

사용: python3 build_graph.py            # 빌드 + 리포트
      python3 build_graph.py --idem     # 2회 빌드 후 해시 동일 확인(멱등 자체검사)
"""
import os, re, sys, json, glob, hashlib, sqlite3, datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
KB = os.path.join(ROOT, "03_kb")
OUT = os.path.join(ROOT, "04_graph")
VERIF = os.path.join(ROOT, "05_verification")
SNAP = os.path.abspath(os.path.join(ROOT, "../_foundation/live-snapshot/latest"))
BLOCKLIST = os.path.join(VERIF, "blocklist.md")

import yaml  # PyYAML 6.x

# ---- 스키마 사전 (ontology-schema v1.0.1) ----
NODE_TYPES = {"product", "category", "size", "material", "print_option", "process",
              "plate_size", "bundle_qty", "price_formula", "price_component",
              "option_group", "constraint", "term", "rule", "decision", "gap", "intent"}
ORPHAN_EXEMPT = {"term", "rule", "decision", "intent"}
ORPHAN_HARD = {"product", "price_formula", "price_component"}

# rel: (origin, src_types|None, dst_types|None). None = any(검사 예외)
REL = {
    "in_category": ("fk", {"product"}, {"category"}),
    "has_size": ("fk", {"product"}, {"size"}),
    "uses_material": ("fk", {"product"}, {"material"}),
    "has_print_option": ("fk", {"product"}, {"print_option"}),
    "has_process": ("fk", {"product"}, {"process"}),
    "has_plate_size": ("fk", {"product"}, {"plate_size"}),
    "has_qty_rule": ("fk", {"product"}, {"bundle_qty"}),
    "priced_by": ("fk", {"product"}, {"price_formula"}),
    "has_component": ("fk", {"price_formula"}, {"price_component"}),
    "has_option_group": ("fk", {"product"}, {"option_group"}),
    "option_refs": ("fk", {"option_group"}, {"size", "material", "process", "print_option"}),
    "constrains": ("fk", {"constraint"}, {"option_group", "product"}),
    "has_member": ("doc", {"product"}, {"product"}),
    "has_addon": ("doc", {"product"}, {"product"}),
    "decided_because": ("doc", {"decision"}, None),
    "supersedes": ("doc", {"decision"}, {"decision"}),
    "derived_from": ("derived", None, None),
    "alias_of": ("derived", None, {"term"}),   # src=투영 라벨(노드 아님·I-2 src 예외)
    "references": ("doc", None, None),          # any→any 약참조(I-3 예외)
}
# anchor table → live-snapshot csv 파일 존재 시 첫 컬럼을 키로 실재 검사(L-17)
ANCHOR_TABLE_RE = re.compile(r"^(t_[a-z_]+)/(.+)$")


class Node:
    __slots__ = ("id", "type", "anchor", "anchor_reason", "badge", "props", "standards",
                 "sources", "file_path", "extra", "rels", "refs", "is_file_node", "tables")

    def __init__(self):
        self.props = {}; self.standards = {}; self.sources = []; self.extra = {}
        self.rels = []; self.refs = []; self.anchor_reason = None; self.anchor = None
        self.is_file_node = False; self.tables = []  # tables=본문 표(마커유무) L-16용


def _yaml(v):
    try:
        return yaml.safe_load(v)
    except Exception:
        return v


def parse_block(block_id, badge, lines, file_rel):
    n = Node(); n.id = block_id; n.badge = badge; n.file_path = file_rel
    body_text = []
    for ln in lines:
        s = ln.strip()
        body_text.append(ln)
        m = re.match(r"^-\s+([A-Za-z_가-힣0-9]+):\s*(.*)$", s)
        if not m:
            continue
        key, val = m.group(1), m.group(2)
        if key == "type":
            n.type = val.strip()
        elif key == "anchor":
            # "none  # 사유: ..." → 토큰 + 사유 유무
            if "#" in val:
                tok, cmt = val.split("#", 1)
                n.anchor = tok.strip()
                n.anchor_reason = cmt.strip()
            else:
                n.anchor = val.strip()
        elif key == "src":
            n.sources.append(_yaml(val))
        elif key == "rel":
            n.rels.append(_yaml(val))
        elif key == "props":
            p = _yaml(val)
            if isinstance(p, dict):
                n.props.update(p)
        elif key == "standards":
            p = _yaml(val)
            if isinstance(p, dict):
                n.standards.update(p)
        elif key in ("prefLabel", "definition", "gap_what", "gap_fill_from",
                     "gap_owner", "current_value", "authority_value", "supersedes"):
            n.extra[key] = _yaml(val) if val.strip().startswith(("[", "{", '"')) else val.strip()
        elif key == "altLabel":
            n.extra["altLabel"] = _yaml(val)
    # 본문 [[ ]] → references. [[파일#노드id]]는 # 뒤가 노드 id(file-format-spec §3.2). [[노드id]]는 그대로.
    for ref in re.findall(r"\[\[([^\]]+)\]\]", "\n".join(body_text)):
        rid = ref.split("#")[-1].strip() if "#" in ref else ref.strip()
        if "/" in rid:  # 파일 경로만 있는 참조(노드 id 아님) → 스킵
            continue
        n.refs.append(rid)
    n.tables = body_text  # L-12/L-16 스캔용(직렬화 대상 아님)
    return n


def parse_file(path):
    rel = os.path.relpath(path, KB)
    txt = open(path, encoding="utf-8").read()
    nodes = []
    # frontmatter id-노드 (Phase 4 상품 파일 등)
    fm = re.match(r"^---\n(.*?)\n---\n(.*)$", txt, re.S)
    body = txt
    if fm:
        meta = yaml.safe_load(fm.group(1)) or {}
        body = fm.group(2)
        if isinstance(meta, dict) and "id" in meta:
            n = Node(); n.id = meta["id"]; n.type = meta.get("type")
            n.badge = meta.get("badge"); n.file_path = rel
            n.is_file_node = True  # 1파일=1노드(frontmatter) → L-1 파일명 검사 대상
            av = meta.get("anchor", "")
            if isinstance(av, str) and "#" in av and av.strip().startswith("none"):
                n.anchor, n.anchor_reason = "none", av.split("#", 1)[1].strip()
            else:
                n.anchor = av
            n.props = meta.get("props", {}) or {}
            n.standards = meta.get("standards", {}) or {}
            n.sources = meta.get("sources", []) or []
            n.rels = meta.get("relations", []) or []
            for ref in re.findall(r"\[\[([^\]]+)\]\]", body):
                rid = ref.split("#")[-1].strip() if "#" in ref else ref.strip()
                if "/" not in rid:
                    n.refs.append(rid)
            # L-12/L-16 스캔용: frontmatter 노드의 고유 본문 = 첫 ### 블록 이전(블록노드와 중복 방지)
            _fb = re.search(r"^###\s+\[[^\]]+\]\s+.*?\{\w+\}\s*$", body, re.M)
            n.tables = (body[:_fb.start()] if _fb else body).splitlines()
            nodes.append(n)
    # ### [id] label {badge} 블록-노드
    blocks = list(re.finditer(r"^###\s+\[([^\]]+)\]\s+.*?\{(\w+)\}\s*$", body, re.M))
    for i, mb in enumerate(blocks):
        bid, badge = mb.group(1).strip(), mb.group(2).strip()
        start = mb.end()
        end = blocks[i + 1].start() if i + 1 < len(blocks) else len(body)
        seg = body[start:end].splitlines()
        nodes.append(parse_block(bid, badge, seg, rel))
    return nodes


def collect_files():
    files = []
    for p in sorted(glob.glob(os.path.join(KB, "**", "*.md"), recursive=True)):
        base = os.path.basename(p)
        # _-prefix 파일은 _glossary.md만 파싱(file-format-spec §1.4)
        if base.startswith("_") and base != "_glossary.md":
            continue
        files.append(p)
    return files


def load_snapshot_keys():
    keys = {}
    if not os.path.isdir(SNAP):
        return keys
    for csvf in glob.glob(os.path.join(SNAP, "t_*.csv")):
        tbl = os.path.splitext(os.path.basename(csvf))[0]
        with open(csvf, encoding="utf-8") as f:
            header = f.readline().strip().split(",")
            if not header:
                continue
            col0 = header[0]
            import csv as _csv
            f.seek(0)
            rdr = _csv.DictReader(f)
            keys[tbl] = {r[col0] for r in rdr if r.get(col0)}
    return keys


def load_blocklist():
    """blocklist.md → 오염 차단 원천. 토큰 라인 `- <hard|advisory> <src_id|path>: <값>`만 파싱.
    파일 부재 시 present=False(빌드가 이를 하드 FAIL로 처리 — 조용한 통과 위장 금지·V1-01B)."""
    bl = {"present": False, "hard_src_ids": set(), "hard_paths": [],
          "adv_src_ids": set(), "adv_paths": []}
    if not os.path.exists(BLOCKLIST):
        return bl
    bl["present"] = True
    tok = re.compile(r"^-\s+(hard|advisory)\s+(src_id|path):\s*(.+?)\s*$")
    for ln in open(BLOCKLIST, encoding="utf-8"):
        m = tok.match(ln.rstrip("\n"))
        if not m:
            continue
        tier, kind, val = m.group(1), m.group(2), m.group(3)
        if kind == "src_id":
            (bl["hard_src_ids"] if tier == "hard" else bl["adv_src_ids"]).add(val)
        else:
            (bl["hard_paths"] if tier == "hard" else bl["adv_paths"]).append(val)
    return bl


_COMMA_NUM = re.compile(r"\d{1,3}(?:,\d{3})+")   # 1,000 27,000 …(천단위 = 손전사 가격 의심)
_WON_NUM = re.compile(r"\d+\s*원")               # 27000원 …


def scan_body_lint(nid, body_lines, soft):
    """L-12(소프트): 산문에 천단위 콤마 수·원-접미 수(손전사 가격 의심) — 표/마커/lint-allow 문맥 제외.
    L-16(소프트): 숫자 밀집 표에 transcribed-by 마커 부재(표 시작 직전 5줄 룩백 — 빈줄 삽입 견고)."""
    lines = body_lines or []
    n = len(lines)
    i = 0
    while i < n:
        s = lines[i].strip()
        if s.startswith("|"):  # 표 블록 시작
            j = i
            has_num = False
            while j < n and lines[j].strip().startswith("|"):
                if re.search(r"\d", lines[j]):
                    has_num = True
                j += 1
            # 표 시작 직전 5줄 룩백에서 마커 탐색(빈줄/설명줄 무시)
            marker = any("transcribed-by" in lines[k] for k in range(max(0, i - 5), i))
            if has_num and not marker:
                soft.append(f"L-16 수치 표 transcribed-by 마커 없음(손전사 의심): {nid}")
            i = j
            continue
        # 산문 라인: L-12 (표/마커/lint-allow 아님)
        if "transcribed-by" not in lines[i] and "lint-allow" not in lines[i]:
            if _COMMA_NUM.search(s) or _WON_NUM.search(s):
                soft.append(f"L-12 본문 raw 가격형 수치(스크립트 전사·예외태그 권장): {nid} :: {s[:60]}")
        i += 1


def build():
    files = collect_files()
    nodes, hard, soft = {}, [], []
    for p in files:
        for n in parse_file(p):
            if n.id in nodes:
                hard.append(f"L-3 중복 id: {n.id} ({n.file_path} & {nodes[n.id].file_path})")
                continue
            nodes[n.id] = n

    snap_keys = load_snapshot_keys()
    blocklist = load_blocklist()
    # O2/I-6 게이트 원천 부재 = 하드 FAIL(조용한 통과 위장 금지·V1-01B). 있으면 검사 실작동.
    if not blocklist["present"]:
        hard.append("O2/I-6 blocklist.md 부재 — 오염 차단 게이트 원천 없음(검사 무력화). "
                    "05_verification/blocklist.md 생성 필요(source-registry §8 기반).")

    # --- 노드 단위 lint ---
    prefLabels = {}
    for nid, n in nodes.items():
        # L-1(하드): 1파일=1노드(frontmatter)면 파일명(basename) == id
        if n.is_file_node:
            base = os.path.splitext(os.path.basename(n.file_path))[0]
            if base != n.id:
                hard.append(f"L-1 파일명↔id 불일치: 파일 {base}.md vs id {n.id}")
        if not n.type:
            hard.append(f"L-2 type 없음: {nid}")
        elif n.type not in NODE_TYPES:
            hard.append(f"L-4 미등재 type '{n.type}': {nid}")
        if not n.badge:
            hard.append(f"L-2 badge 없음: {nid}")
        elif n.badge not in {"verified", "candidate", "defect", "unknown"}:
            hard.append(f"L-5 badge enum 위반 '{n.badge}': {nid}")
        if not n.sources:
            hard.append(f"L-6/O1 출처 없음: {nid}")
        src_badges = []
        for s in n.sources:
            if not isinstance(s, dict) or not {"source_file", "source_locator", "captured_at", "badge", "src_id"} <= set(s):
                hard.append(f"L-6 출처 5필드 미비: {nid} -> {s}")
                continue
            src_badges.append(s.get("badge"))
            sid = s.get("src_id"); sf = str(s.get("source_file") or "")
            # O2/I-6 오염: src_id 정확일치 또는 source_file 경로 부분포함(src_id 우회 방지)
            if sid in blocklist["hard_src_ids"] or any(p in sf for p in blocklist["hard_paths"]):
                hard.append(f"O2/I-6 blocklist 오염 인용(HARD): {nid} src_id={sid} file={sf}")
            elif sid in blocklist["adv_src_ids"] or any(p in sf for p in blocklist["adv_paths"]):
                soft.append(f"O2 blocklist 주의(ADVISORY·배경서술만 허용): {nid} src_id={sid} file={sf}")
            # O3(소프트 프록시): 위키 recipes/16_/17_ 인용은 (승계·재검증) 라벨 필요 — 전체 DROP리스트 배선은 미완(가드)
            loc = str(s.get("source_locator") or "")
            if ("print-kb/wiki/" in sf and re.search(r"/(recipes|1[67]_)", sf)
                    and not re.search(r"승계|재검증", loc)):
                soft.append(f"O3 위키 인용 승계/재검증 라벨 없음(DROP 판정 수동확인 필요): {nid} file={sf}")
        # L-13(소프트): 노드 verified인데 어떤 source도 verified가 아니면 배지 불일치 경고
        if n.badge == "verified" and src_badges and "verified" not in src_badges:
            soft.append(f"L-13 배지 불일치(노드 verified·source 전부 비verified): {nid}")
        # anchor
        if n.anchor in (None, ""):
            hard.append(f"L-2 anchor 없음: {nid}")
        elif n.anchor == "none":
            if not n.anchor_reason or "사유" not in (n.anchor_reason or ""):
                hard.append(f"L-8 anchor=none 사유 주석 없음: {nid}")
        elif isinstance(n.anchor, str) and n.anchor.startswith("xlsx:"):
            pass
        else:
            am = ANCHOR_TABLE_RE.match(n.anchor)
            if am:
                tbl, code = am.group(1), am.group(2)
                if tbl in snap_keys and code not in snap_keys[tbl]:
                    hard.append(f"L-17 앵커 미실재(닫힌세계): {nid} {n.anchor}")
                elif tbl not in snap_keys:
                    soft.append(f"L-17 스냅샷 테이블 없음(검사 스킵): {nid} {tbl}")
            else:
                soft.append(f"anchor 형식 비표준(t_*/xlsx/none 아님): {nid} {n.anchor}")
        # defect 양면
        if n.badge == "defect" and not ({"current_value", "authority_value"} <= set(n.extra)):
            hard.append(f"L-9 defect 양면필드 미비: {nid}")
        # gap 3필드
        if n.type == "gap" and not ({"gap_what", "gap_fill_from", "gap_owner"} <= set(n.extra)):
            hard.append(f"L-10 gap 3필드 미비: {nid}")
        # term prefLabel 유일
        if n.type == "term":
            pl = n.extra.get("prefLabel")
            if not pl or not n.extra.get("definition"):
                hard.append(f"L-11 term prefLabel/definition 미비: {nid}")
            elif pl in prefLabels:
                hard.append(f"L-11 prefLabel 중복 '{pl}': {nid} & {prefLabels[pl]}")
            else:
                prefLabels[pl] = nid
        # L-12/L-16(소프트): 본문 수치·표 마커 스캔
        scan_body_lint(nid, n.tables, soft)

    # --- 엣지 추출 ---
    node_ids = set(nodes)
    edges = []

    def add_edge(src, rel, dst, origin, qual=None, note=None, from_node=None):
        edges.append({"src": src, "rel": rel, "dst": dst, "origin": origin,
                      "qualifier": qual, "note": note, "source_node": from_node})

    for nid, n in nodes.items():
        for r in n.rels:
            if not isinstance(r, dict) or "rel" not in r or "target" not in r:
                hard.append(f"relations 형식 오류: {nid} -> {r}")
                continue
            rel = r["rel"]; tgt = r["target"]
            if rel not in REL:
                hard.append(f"L-14 미등재 rel '{rel}': {nid}")
                continue
            origin = REL[rel][0]
            add_edge(nid, rel, tgt, origin,
                     qual=r.get("qualifier"), note=r.get("note"), from_node=nid)
        # 본문 [[ ]] references (frontmatter rel에 이미 없는 target만·미해결은 서술로 간주·소프트)
        rel_targets = {r.get("target") for r in n.rels if isinstance(r, dict)}
        for ref in n.refs:
            if ref in rel_targets or ref == nid:
                continue
            if ref not in node_ids:
                soft.append(f"본문 [[ ]] 미해결 참조(서술로 간주·엣지 미생성): {nid} -> {ref}")
                continue
            add_edge(nid, "references", ref, "doc", from_node=nid)
        # alias_of 투영 (term altLabel/hiddenLabel → 변형→prefLabel)
        if n.type == "term":
            for variant in (n.extra.get("altLabel") or []):
                add_edge(f"aliaslabel:{variant}", "alias_of", nid, "derived", note="투영 라벨", from_node=nid)

    # --- 엣지 전역 dedup (V1-03B): (src,rel,dst) 유일 — ⓑ덤프=ⓒ질의 정합·리포트 과다계상 방지 ---
    _seen_e = set(); _dedup = []
    for e in edges:
        k = (e["src"], e["rel"], e["dst"])
        if k in _seen_e:
            continue
        _seen_e.add(k); _dedup.append(e)
    edges = _dedup

    # --- 엣지 lint (끊긴링크 I-2·타입 I-3) ---
    node_ids = set(nodes)
    for e in edges:
        rel = e["rel"]
        # I-2 dst 실재
        if e["dst"] not in node_ids:
            hard.append(f"I-2 끊긴 링크(dst): {e['src']} -{rel}-> {e['dst']}")
        # I-2 src 실재 (alias_of 투영 라벨은 예외)
        if rel != "alias_of" and e["src"] not in node_ids:
            hard.append(f"I-2 끊긴 링크(src): {e['src']} -{rel}-> {e['dst']}")
        # I-3 타입
        _o, stypes, dtypes = REL[rel]
        s_node = nodes.get(e["src"]); d_node = nodes.get(e["dst"])
        if stypes is not None and s_node and s_node.type not in stypes:
            hard.append(f"I-3 rel src 타입 위반: {e['src']}({s_node.type}) -{rel}->")
        if dtypes is not None and d_node and d_node.type not in dtypes:
            hard.append(f"I-3 rel dst 타입 위반: -{rel}-> {e['dst']}({d_node.type})")

    # --- 필수 엣지 (I-4·O5·O6) ---
    out_by = {}
    deg = {nid: 0 for nid in nodes}
    for e in edges:
        out_by.setdefault(e["src"], []).append(e)
        if e["src"] in deg:
            deg[e["src"]] += 1
        if e["dst"] in deg:
            deg[e["dst"]] += 1
    for nid, n in nodes.items():
        if n.type == "product":
            has_price = any(e["rel"] in ("priced_by", "derived_from") for e in out_by.get(nid, []))
            if not has_price and n.anchor != "none":
                hard.append(f"O5 product 끊긴 가격사슬(priced_by/gap 없음): {nid}")
        if n.type == "price_formula":
            if not any(e["rel"] == "has_component" for e in out_by.get(nid, [])):
                hard.append(f"O6 고아 공식(has_component 0): {nid}")

    # --- L-18(하드·graph-build §5.4 I-4): option_refs 타깃이 같은 부모 product 차원에 실재(fn_chk_opt_item_ref) ---
    optgroup_parent = {}
    for e in edges:
        if e["rel"] == "has_option_group":
            optgroup_parent[e["dst"]] = e["src"]  # optgroup → 부모 product
    product_dim_targets = {}   # product → {uses_material·has_process·has_size·has_print_option 의 dst}
    for e in edges:
        if e["rel"] in ("uses_material", "has_process", "has_size", "has_print_option"):
            product_dim_targets.setdefault(e["src"], set()).add(e["dst"])
    for e in edges:
        if e["rel"] != "option_refs":
            continue
        og, tgt = e["src"], e["dst"]
        parent = optgroup_parent.get(og)
        if parent is None:
            soft.append(f"L-18 option_group 부모 product 미상(has_option_group 역참조 불가): {og}")
        elif tgt not in product_dim_targets.get(parent, set()):
            hard.append(f"L-18 option_refs 부모 미정합(fn_chk_opt_item_ref): "
                        f"{og} -option_refs-> {tgt} (부모 {parent} 차원에 없음)")

    # --- 고아 (I-1) ---
    orphan_warn, orphan_hard = [], []
    for nid, n in nodes.items():
        if deg.get(nid, 0) == 0:
            if n.type in ORPHAN_EXEMPT:
                continue
            if n.type in ORPHAN_HARD:
                orphan_hard.append(nid)
            else:
                orphan_warn.append(f"{nid} ({n.type})")
    for o in orphan_hard:
        hard.append(f"I-1 고아 노드(하드 유형): {o}")
    for o in orphan_warn:
        soft.append(f"I-1 고아 노드(연결 대기·Phase 4): {o}")

    # --- O4 index 등재 (노드 파일이 index.md에 링크됨) ---
    idx = ""
    idxp = os.path.join(KB, "index.md")
    if os.path.exists(idxp):
        idx = open(idxp, encoding="utf-8").read()
    for nid, n in nodes.items():
        if n.file_path.replace(os.sep, "/") not in idx and os.path.basename(n.file_path) not in idx:
            soft.append(f"O4 index 미등재 파일: {n.file_path} ({nid})")
    # --- O4b index dead-link 스캔: 마크다운 링크 target(.md) 파일 실재 검사 ---
    # (기존 O4 부분문자열 매칭은 dead-link 텍스트를 '등재됨'으로 오판=false-negative·D-STK-3.
    #  링크 target 파일 실재를 직접 검사해 존재하지 않는 index 링크를 소프트 경고로 적발.)
    if idx:
        for m in re.finditer(r"\]\(([^)]+)\)", idx):
            tgt = m.group(1).split("#")[0].strip()
            if not tgt or tgt.startswith(("http://", "https://", "mailto:")) or not tgt.endswith(".md"):
                continue
            if not os.path.exists(os.path.join(KB, tgt)):
                soft.append(f"O4b index dead-link(링크 target 파일 부재): index.md -> {tgt}")

    # --- 역링크(backlinks) 파생 ---
    backlinks = {nid: [] for nid in nodes}
    for e in edges:
        if e["dst"] in backlinks:
            backlinks[e["dst"]].append({"src": e["src"], "rel": e["rel"]})
    for nid in backlinks:
        backlinks[nid].sort(key=lambda x: (x["rel"], x["src"]))

    return nodes, edges, backlinks, hard, soft, snap_keys


def serialize(nodes, edges, backlinks):
    os.makedirs(OUT, exist_ok=True)
    nrecs = []
    for nid in sorted(nodes):
        n = nodes[nid]
        rec = {"id": n.id, "type": n.type, "anchor": n.anchor, "badge": n.badge,
               "props": n.props, "standards": n.standards, "sources": n.sources,
               "extra": n.extra, "backlinks": backlinks.get(nid, []),
               "file_path": n.file_path.replace(os.sep, "/")}
        nrecs.append(json.dumps(rec, ensure_ascii=False, sort_keys=True))
    erecs = []
    for e in sorted(edges, key=lambda x: (x["src"], x["rel"], x["dst"])):
        erecs.append(json.dumps(e, ensure_ascii=False, sort_keys=True))
    np = os.path.join(OUT, "nodes.jsonl"); ep = os.path.join(OUT, "edges.jsonl")
    with open(np, "w", encoding="utf-8") as f:
        f.write("\n".join(nrecs) + ("\n" if nrecs else ""))
    with open(ep, "w", encoding="utf-8") as f:
        f.write("\n".join(erecs) + ("\n" if erecs else ""))
    return np, ep


def load_sqlite(nodes, edges):
    db = os.path.join(OUT, "graph.db")
    if os.path.exists(db):
        os.remove(db)
    con = sqlite3.connect(db); cur = con.cursor()
    cur.executescript("""
      CREATE TABLE node(id TEXT PRIMARY KEY, type TEXT, anchor TEXT, badge TEXT,
                        props JSON, standards JSON, file_path TEXT);
      CREATE TABLE edge(src TEXT, rel TEXT, dst TEXT, origin TEXT, qualifier TEXT, note TEXT,
                        PRIMARY KEY(src, rel, dst));
      CREATE TABLE source(node_id TEXT, source_file TEXT, source_locator TEXT,
                          captured_at TEXT, badge TEXT, src_id TEXT);
      CREATE INDEX idx_edge_src ON edge(src, rel);
      CREATE INDEX idx_edge_dst ON edge(dst, rel);
      CREATE INDEX idx_node_type ON node(type);
    """)
    for nid in sorted(nodes):
        n = nodes[nid]
        cur.execute("INSERT INTO node VALUES(?,?,?,?,?,?,?)",
                    (n.id, n.type, n.anchor, n.badge,
                     json.dumps(n.props, ensure_ascii=False, sort_keys=True),
                     json.dumps(n.standards, ensure_ascii=False, sort_keys=True),
                     n.file_path.replace(os.sep, "/")))
        for s in n.sources:
            if isinstance(s, dict):
                cur.execute("INSERT INTO source VALUES(?,?,?,?,?,?)",
                            (n.id, s.get("source_file"), s.get("source_locator"),
                             s.get("captured_at"), s.get("badge"), s.get("src_id")))
    seen = set()
    for e in sorted(edges, key=lambda x: (x["src"], x["rel"], x["dst"])):
        k = (e["src"], e["rel"], e["dst"])
        if k in seen:
            continue
        seen.add(k)
        cur.execute("INSERT INTO edge VALUES(?,?,?,?,?,?)",
                    (e["src"], e["rel"], e["dst"], e["origin"],
                     json.dumps(e["qualifier"], ensure_ascii=False) if e["qualifier"] else None,
                     e["note"]))
    con.commit(); con.close()
    return db


def sha(path):
    return hashlib.sha256(open(path, "rb").read()).hexdigest()[:16]


def report(nodes, edges, hard, soft, hashes):
    os.makedirs(VERIF, exist_ok=True)
    day = datetime.date.today().isoformat()
    tcount = {}
    for n in nodes.values():
        tcount[n.type] = tcount.get(n.type, 0) + 1
    rcount = {}
    for e in edges:
        rcount[e["rel"]] = rcount.get(e["rel"], 0) + 1
    bcount = {}
    for n in nodes.values():
        bcount[n.badge] = bcount.get(n.badge, 0) + 1
    L = []
    L.append(f"# 그래프 빌드 리포트 — {day}\n")
    L.append(f"> build_graph.py · 정본 {KB} → 04_graph. 생성=빌드(검증은 별도 레인·okb-adversarial-gate).\n")
    L.append(f"- 판정: **{'FAIL' if hard else 'PASS(하드 0)'}** · 하드 위반 {len(hard)} · 소프트 경고 {len(soft)}")
    L.append(f"- 노드 {len(nodes)} · 엣지 {len(edges)}")
    L.append(f"- 멱등 해시: nodes.jsonl={hashes['nodes']} · edges.jsonl={hashes['edges']}\n")
    L.append("## 노드 수 (타입별)")
    for t in sorted(tcount):
        L.append(f"- {t}: {tcount[t]}")
    L.append("\n## 엣지 수 (rel별)")
    for r in sorted(rcount):
        L.append(f"- {r}: {rcount[r]}")
    L.append("\n## badge 분포")
    for b in sorted(bcount):
        L.append(f"- {b}: {bcount[b]}")
    L.append("\n## 무결성 6검사")
    L.append(f"- I-1 고아(하드 유형 product/formula/component): {sum(1 for h in hard if 'I-1' in h)}")
    L.append(f"- I-2 끊긴 링크: {sum(1 for h in hard if 'I-2' in h)}")
    L.append(f"- I-3 타입 위반: {sum(1 for h in hard if 'I-3' in h)}")
    L.append(f"- I-4 필수 엣지(O5/O6): {sum(1 for h in hard if h.startswith(('O5','O6')) or 'O5' in h or 'O6' in h)}")
    L.append(f"- I-5 멱등: nodes/edges 해시 재현(위 해시 — --idem로 자체검사)")
    _bl = load_blocklist()
    if _bl["present"]:
        L.append(f"- I-6 오염(blocklist): {sum(1 for h in hard if 'I-6' in h or 'O2/I-6' in h)} "
                 f"(원천 실재 — hard src_id {len(_bl['hard_src_ids'])}·path {len(_bl['hard_paths'])}"
                 f"·advisory src_id {len(_bl['adv_src_ids'])}·path {len(_bl['adv_paths'])} 로드)")
    else:
        L.append("- I-6 오염(blocklist): **게이트 원천 부재 = 하드 FAIL** "
                 "(05_verification/blocklist.md 없음 — 검사 무력화·조용한 통과 금지)")
    if hard:
        L.append("\n## ★ 하드 위반 (빌드 FAIL)")
        for h in hard:
            L.append(f"- {h}")
    L.append("\n## 소프트 경고 (빌드 계속·검토용)")
    for s in soft:
        L.append(f"- {s}")
    L.append("\n## 비고")
    L.append("- 상품 노드 8개 집필 완료(파일럿 디지털인쇄). 현행 소프트 고아는 ① 파일럿 8상품이 쓰지 않는 축 원자 항목(자재/공정/사이즈/판형/도수/카테고리 일부)과 ② 어떤 노드도 아직 링크하지 않는 floating GAP 노드다 — 'Phase 4 대기'가 아니라 현재 커버리지 경계. floating GAP의 상품 연결 여부는 연결 완전성(축5) 라운드에서 재판정(조용한 고아 gap 방지).")
    L.append("- 고아 하드 유형(product/formula/component)·끊긴 링크·타입 위반·L-18 부모정합·blocklist 오염(HARD)·blocklist 원천 부재 = 0 이어야 PASS.")
    p = os.path.join(VERIF, f"build-report-{day.replace('-', '')}.md")
    open(p, "w", encoding="utf-8").write("\n".join(L) + "\n")
    return p


def main():
    nodes, edges, backlinks, hard, soft, _ = build()
    np, ep = serialize(nodes, edges, backlinks)
    hashes = {"nodes": sha(np), "edges": sha(ep)}
    db = load_sqlite(nodes, edges)
    rp = report(nodes, edges, hard, soft, hashes)
    print(f"nodes={len(nodes)} edges={len(edges)} hard={len(hard)} soft={len(soft)}")
    print(f"hash nodes={hashes['nodes']} edges={hashes['edges']}")
    print(f"report={rp}")
    if "--idem" in sys.argv:
        serialize(nodes, edges, backlinks)
        h2 = {"nodes": sha(np), "edges": sha(ep)}
        ok = h2 == hashes
        print(f"[I-5 멱등] 2회 빌드 해시 동일: {ok}")
        if not ok:
            sys.exit(3)
    sys.exit(1 if hard else 0)


if __name__ == "__main__":
    main()
