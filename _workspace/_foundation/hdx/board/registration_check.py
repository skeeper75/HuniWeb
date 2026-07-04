# -*- coding: utf-8 -*-
"""상품 등록 매핑 점검표 — 엑셀 의도↔DB 등록 대조 (전 시트 일반화).

★목적(지니 260704): 실무진이 만든 권위 엑셀(상품마스터 260610)을 '의도'로, 라이브 DB 를
'실제 등록'으로 보고 **상품별 유료 옵션이 DB에 등록·가격연결됐나** 대조. 내부 정합만으론 못 잡는
갭(예: 아크릴키링 고리 저청구 = 엑셀 유료인데 DB 0원)을 엑셀 대조로 전 상품 포착.

파일럿(아크릴)의 일반화 — 시트마다 (옵션,가격) 컬럼이 달라 **시트별 config** 로 매핑.
이번 판 커버 = 인라인 유료 추가옵션이 있는 5시트(아크릴·캘린더·디자인캘린더·실사·굿즈파우치).
형식가격(디지털·스티커·책자·문구·포토북) = §26 가격격자 대조 소관 + 부자재 addon(상품악세사리
정가표)은 후속 축(TODO accessory 크로스레퍼런스).

[HARD] 라이브 읽기전용 스냅샷·엑셀=권위(날조 0). 출력 = 실무진 검토용 **후보 보드**(자동결론 아님).
재실행: python3 _workspace/_foundation/hdx/board/registration_check.py
"""
from __future__ import annotations
import csv, re, sys, pathlib
import openpyxl

ROOT = pathlib.Path("/Users/innojini/Dev/HuniWeb")
SNAP = ROOT / "_workspace/_foundation/live-snapshot/latest"
XLSX = ROOT / "docs/huni/후니프린팅_상품마스터_260610.xlsx"
OUT = ROOT / "_workspace/_foundation/hdx/board/registration-check.csv"

# ── 시트별 config ───────────────────────────────────────────────────────
#   pid/nm = 상품블록 식별 컬럼. opt_price = 유료 옵션(옵션명 col, 가격 col) 쌍 목록.
#   가격 col 이 None = 인라인 가격 없음(부자재 정가표 소관·이번 판 스킵).
SHEETS = {
    "아크릴":                 dict(pid=1, nm=3, opt_price=[(20, 21), (22, 23)]),
    "캘린더":                 dict(pid=1, nm=3, opt_price=[(25, 26)]),          # 추가상품+추가가격
    "디자인캘린더(가격포함)":  dict(pid=1, nm=3, opt_price=[(24, 25)]),          # 추가상품+추가가격
    "실사":                   dict(pid=1, nm=3, opt_price=[(24, 25)]),          # 추가+추가옵션가격
    "굿즈파우치(가격포함)":    dict(pid=1, nm=3, opt_price=[(17, 18), (22, 23)]),  # 가공+가격, 추가상품+추가가격
}

_NUM = re.compile(r"[0-9][0-9,]*\.?[0-9]*")


def price_kind(raw: str):
    """가격셀 → ('paid'|'free'|'uncertain'|'none', 표시값). 엑셀 원문 존중(날조 0)."""
    s = (raw or "").strip()
    if not s:
        return "none", ""
    if "가격표참고" in s:
        return "paid", s               # 격자로 유료
    m = _NUM.search(s)
    if m:
        val = float(m.group(0).replace(",", ""))
        if "?" in s:
            return "uncertain", s       # 엑셀 저자 불확실 표기(예 '4000?')
        return ("paid" if val > 0 else "free"), s
    if "?" in s:
        return "uncertain", s           # '???' = 값 미정
    return "none", s


def is_addon_name(nm: str) -> bool:
    """옵션명이 유료 판정 대상 후보인가(명백한 '없음/선택안함/출력만' 제외)."""
    n = nm.strip()
    return bool(n) and not any(w in n for w in ("없음", "선택안함", "출력만", "추가없음"))


# ── 엑셀 의도 파서(시트 일반) ────────────────────────────────────────────
def parse_sheet(ws, cfg):
    """시트 → {상품명: {paid_opts:[(옵션명,표시가,kind)], all_opts:int}}. nm 변경=새 상품블록."""
    pid_c, nm_c = cfg["pid"], cfg["nm"]
    products, cur = {}, None
    for r in list(ws.iter_rows(values_only=True))[2:]:
        g = lambda i: (str(r[i]).strip() if i < len(r) and r[i] is not None and str(r[i]).strip() else "")
        nm = g(nm_c)
        if nm and nm != cur:                    # 새 상품블록
            cur = nm
            products.setdefault(cur, {"paid": [], "n_opt": 0})
        if cur is None:
            continue
        p = products[cur]
        for (oc, pc) in cfg["opt_price"]:
            onm = g(oc)
            if not is_addon_name(onm):
                continue
            p["n_opt"] += 1
            kind, disp = price_kind(g(pc) if pc is not None else "")
            if kind in ("paid", "uncertain"):
                p["paid"].append((onm, disp, kind))
    return products


# ── DB 등록 상태 ────────────────────────────────────────────────────────
def load(t):
    p = SNAP / f"{t}.csv"
    return list(csv.DictReader(open(p, encoding="utf-8"))) if p.exists() else []


def db_state():
    prods = load("t_prd_products")
    nm2cd = {r["prd_nm"]: r["prd_cd"] for r in prods if r.get("prd_nm")}
    popts = [r for r in load("t_prd_product_options") if r.get("del_yn", "N") != "Y"]
    cp = load("t_prc_component_prices")
    # 단가행이 실제 매칭하는 전 차원값(opt_cd 뿐 아니라 자재·공정·인쇄옵션·사이즈) — 도달성 판정용.
    priced_vals = set()
    for r in cp:
        for d in ("opt_cd", "mat_cd", "proc_cd", "print_opt_cd", "siz_cd", "clr_cd"):
            v = r.get(d)
            if v:
                priced_vals.add(v)
    # option_items: 상품 옵션 → 차원환원 참조키(ref_key1) 목록 {(prd_cd,opt_cd):[ref_key1,...]}.
    oi = {}
    for r in load("t_prd_product_option_items"):
        if r.get("del_yn", "N") == "Y":
            continue
        rk = r.get("ref_key1")
        if rk:
            oi.setdefault((r["prd_cd"], r["opt_cd"]), []).append(rk)
    return nm2cd, popts, priced_vals, oi


def option_priced(prd, opt_row, priced_vals, oi):
    """이 DB 옵션이 가격에 도달하나 — (a)opt_cd 직접 단가행 OR (b)option_items 차원환원이
    단가행 차원값에 도달. 둘 다 없으면 저청구(끊김)."""
    ocd = opt_row.get("opt_cd")
    if ocd and ocd in priced_vals:        # (a) opt_cd 직접(키링류)
        return True
    for rk in oi.get((prd, ocd), []):      # (b) option_items ref_key1 → 단가행 차원값(PET배너류)
        if rk in priced_vals:
            return True
    return False


def addon_state():
    """상품별 부자재 addon 템플릿 상태 — {prd_cd: {'active':[(nm,price)], 'deleted':[nm]}}.
    부자재(볼체인·봉투·거치대·고리)는 옵션이 아니라 addon 템플릿(t_prd_product_addons →
    t_prd_templates → t_prd_template_prices)으로 등록·가격됨. 옵션 경로와 별개."""
    tmpls = {r["tmpl_cd"]: r for r in load("t_prd_templates")}
    tp = {}
    for r in load("t_prd_template_prices"):
        try:
            tp.setdefault(r["tmpl_cd"], []).append(float(r.get("unit_price") or 0))
        except ValueError:
            pass
    out = {}
    for a in load("t_prd_product_addons"):
        t = tmpls.get(a["tmpl_cd"])
        if not t:
            continue
        prd = a["prd_cd"]
        out.setdefault(prd, {"active": [], "deleted": []})
        nm = t.get("tmpl_nm", "")
        maxp = max(tp.get(a["tmpl_cd"], [0]) or [0])
        if t.get("del_yn", "N") == "Y":
            out[prd]["deleted"].append(nm)
        elif maxp > 0:
            out[prd]["active"].append((nm, maxp))
    return out


def addon_covers(prd, opt_name, addons):
    """부자재 옵션이 활성 addon 템플릿으로 등록·가격됐나. 반환 ('active'|'deleted'|'none')."""
    st = addons.get(prd)
    if not st:
        return "none"
    kw = _kw(opt_name)
    if kw:
        if any((kw in nm or _kw(nm) == kw) for nm, _ in st["active"]):
            return "active"
        if any((kw in nm or _kw(nm) == kw) for nm in st["deleted"]):
            return "deleted"
    return "none"


def _kw(s: str):
    """이름 매칭 키워드 — 괄호/공백/치수 제거 후 앞 글자."""
    core = re.sub(r"[\(（].*?[\)）]", "", s)
    core = re.sub(r"[0-9xX×mm\s\.\*★:]+", "", core).strip()
    return core[:2] if len(core) >= 2 else core


# ── 상품별 대조 ─────────────────────────────────────────────────────────
def check():
    wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)
    nm2cd, popts, priced_vals, oi = db_state()
    addons = addon_state()
    rows = []
    for sheet, cfg in SHEETS.items():
        intent = parse_sheet(wb[sheet], cfg)
        for nm, exp in sorted(intent.items()):
            prd = nm2cd.get(nm)
            gaps = []
            if not exp["paid"]:
                continue                         # 유료 추가옵션 없는 상품은 이 축 대상 아님
            if not prd:
                rows.append((sheet, nm, "미등록", "; ".join(f"{o}({d})" for o, d, _ in exp["paid"])))
                continue
            myopts = [r for r in popts if r["prd_cd"] == prd]
            db_names = {r.get("opt_nm", ""): r for r in myopts}
            for onm, disp, kind in exp["paid"]:
                kw = _kw(onm)
                matched = [r for k, r in db_names.items() if kw and (kw in k or _kw(k) == kw)]
                # (1) 옵션 경로 도달 확인
                if matched and any(option_priced(prd, r, priced_vals, oi) for r in matched):
                    continue
                # (2) addon 템플릿 경로 확인(부자재=볼체인/봉투/거치대 등)
                acov = addon_covers(prd, onm, addons)
                if acov == "active":
                    continue                     # addon 으로 가격 등록됨 — 갭 아님(v1 오탐 제거)
                # (3) 어느 경로도 없음 → 갭
                if acov == "deleted":
                    gaps.append(f"[addon 삭제] '{onm}'({disp}) — addon 템플릿 논리삭제(del_yn=Y) → 0원")
                elif matched:
                    gaps.append(f"[가격경로 끊김] '{onm}'({disp}) — 옵션 실재·경로 0(opt_cd·option_items·addon 도달 0) → 0원")
                else:
                    tag = "유료옵션 미등록" if kind == "paid" else "불확실옵션 미등록"
                    gaps.append(f"[{tag}] '{onm}'({disp}) — DB 옵션·addon 모두 없음")
            if gaps:
                status = "🔴 저청구/누락"
                rows.append((sheet, nm, status, " | ".join(gaps)))
    wb.close()
    return rows


def main():
    rows = check()
    # 신뢰도: 끊김=HIGH(옵션 실재·경로 0=키링류) / 미등록·미확인=REVIEW(부자재 addon·이름차이 가능).
    def conf(gaps):
        return "HIGH" if ("끊김" in gaps or "addon 삭제" in gaps) else "REVIEW"
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["시트", "상품명", "신뢰도", "상태", "갭"])
        for sheet, nm, status, gaps in rows:
            w.writerow([sheet, nm, conf(gaps), status, gaps])
    by_sheet = {}
    for sheet, nm, status, gaps in rows:
        by_sheet.setdefault(sheet, []).append((nm, status, gaps))
    n_high = sum(1 for _, _, _, g in rows if ("끊김" in g or "addon 삭제" in g))
    print("=" * 78)
    print("상품 등록 매핑 점검표 — 유료 추가옵션 대조(상품마스터 260610 ↔ DB)")
    print("=" * 78)
    for sheet, items in by_sheet.items():
        print(f"\n### {sheet} — 갭 {len(items)}상품")
        for nm, status, gaps in items:
            print(f"  [{conf(gaps)}] {status}  {nm}")
            for g in gaps.split(" | "):
                print(f"       {g}")
    print("\n" + "=" * 78)
    print(f"총 갭 {len(rows)}건(상품×시트) · HIGH(가격경로 끊김·옵션 실재)={n_high}건 · REVIEW={len(rows)-n_high}건")
    print(f"CSV → {OUT}")
    print("─" * 78)
    print("신뢰도 해설(옵션 경로 + option_items 차원환원 + addon 템플릿 3경로 종합):")
    print(" HIGH   = 옵션/addon 실재하나 가격 도달 0 → 키링류 저청구 강신호.")
    print("          (가격경로 끊김=옵션 실재·경로0 / addon 삭제=addon 템플릿 del_yn=Y)")
    print(" REVIEW = 옵션·addon 모두 없음 → ① 진짜 미연결(상품악세사리 정가표엔 있으나 이 상품에")
    print("          addon 미연결) ② 이름차이 오탐 ③ 별도상품(예 만년스탬프 리필잉크).")
    print("커버: 인라인 유료옵션 5시트(아크릴·캘린더·디자인캘린더·실사·굿즈파우치).")
    print("남은 축: 형식가격 6시트(디지털·스티커·책자·문구·포토북·상품악세사리)=§26 가격격자 대조 소관.")
    print("[HARD] 후보 보드(자동결론 아님)·엑셀=권위·라이브 읽기전용. 각 건 실무진/권위 확정 필요.")


if __name__ == "__main__":
    main()
