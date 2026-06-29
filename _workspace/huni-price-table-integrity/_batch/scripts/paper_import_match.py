#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
출력소재(IMPORT) 시트 용지 절가 → 라이브 COMP_PAPER 단가행 적재본 빌더.

결정론 파이프라인:
  권위 L1 (import-paper-l1.csv)  ── parse_authority()
        │  (종이명, 평량, 국4절가, 3절가)
        ▼
  search-before-mint  ── match_material()  vs t_mat_materials.csv
        │  (mat_cd 기존 매칭 / 신규 mint 후보 / 매핑미상)
        ▼
  기적재 대조  ── vs 라이브 COMP_PAPER (snapshot)
        │  (이미 적재 / 미적재)
        ▼
  적재본 생성  ── 권위 verbatim UPSERT (국4절+3절·멱등)
                  + mapping.csv

[HARD] 권위 절가 verbatim(반올림·계산 금지). 기적재행 미터치(ON CONFLICT DO NOTHING).
        기초마스터 코드 삭제·이름변경 금지(추가만).
"""
import csv, os, sys, re

ROOT = "/Users/innojini/Dev/HuniWeb"
L1 = f"{ROOT}/_workspace/huni-dbmap/06_extract/import-paper-l1.csv"
SNAP = f"{ROOT}/_workspace/_foundation/live-snapshot/latest"
MAT = f"{SNAP}/t_mat_materials.csv"
CP = f"{SNAP}/t_prc_component_prices.csv"
OUT = f"{ROOT}/_workspace/huni-price-table-integrity/_batch"

PLT_G4 = "SIZ_000499"   # 국4절
PLT_G3 = "SIZ_000077"   # 3절

# 종이가 아닌 행(자재/스티커/실사/아크릴/봉투 등)은 COMP_PAPER 절가 대상이 아니므로 제외.
# 권위 가격(국4절/3절)이 숫자인 행만 용지 절가 적재 대상.
def is_number(s):
    if not s: return False
    try:
        float(s); return True
    except ValueError:
        return False


def parse_authority():
    rows = list(csv.DictReader(open(L1, encoding="utf-8-sig")))
    papers = []
    g4col = None; g3col = None
    for k in rows[0].keys():
        if k and "국4절" in k: g4col = k
        if k and "3절" in k and "국" not in k: g3col = k
    for r in rows:
        name = (r.get("종이명") or "").strip()
        if not name:
            continue
        pyung = (r.get("평량") or "").strip()
        g4 = (r.get(g4col) or "").strip() if g4col else ""
        g3 = (r.get(g3col) or "").strip() if g3col else ""
        papers.append({
            "name": name, "pyung": pyung,
            "g4": g4 if is_number(g4) else "",
            "g3": g3 if is_number(g3) else "",
            "g4_raw": g4, "g3_raw": g3,
        })
    return papers


def load_materials():
    rows = list(csv.DictReader(open(MAT, encoding="utf-8-sig")))
    # mat_nm -> [mat_cd...]  (del_yn 무관하게 후보 — 단 del_yn=N 우선)
    by_nm = {}
    for r in rows:
        by_nm.setdefault(r["mat_nm"].strip(), []).append(r)
    return rows, by_nm


def existing_codes(rows):
    return set(r["mat_cd"] for r in rows)


def load_live_comp_paper(mat_rows):
    """
    라이브 COMP_PAPER 인덱스 두 개:
      live[(mat_cd, plt_siz_cd)] = row   (적재여부 키)
      live_paper_name[정규화 종이명] = mat_cd
        ── note 의 '용지비 <종이명> 국4절…' 패턴 + note 빈 행은 mat_nm 으로 종이 정체 식별.
    ★라이브가 이미 쓰는 mat_cd 가 권위 바인딩 — 이름이 같다고 다른(중복의미) mat_cd 로 새 행 만들지 않는다.
    """
    mat_nm = {r["mat_cd"]: r["mat_nm"].strip() for r in mat_rows}
    rows = [r for r in csv.DictReader(open(CP, encoding="utf-8-sig"))
            if r["comp_cd"] == "COMP_PAPER"]
    live = {}
    live_paper_name = {}   # 정규화 종이명 -> mat_cd (라이브 권위 바인딩)
    for r in rows:
        live[(r["mat_cd"], r["plt_siz_cd"])] = r
        note = r["note"]
        pname = None
        m = re.search(r"용지비\s+(.+?)\s+국4절", note)
        if m:
            pname = m.group(1).strip()
        else:
            # note 빈 행 → 라이브 mat_nm 으로 종이 정체
            pname = mat_nm.get(r["mat_cd"], "")
        if pname:
            live_paper_name[norm(pname)] = r["mat_cd"]
    return live, live_paper_name, rows


def norm(s):
    """비교용 정규화: 공백 제거, (3절) 같은 접미 분리 전 단계."""
    return re.sub(r"\s+", "", s)


def base_name_for_3jeol(name):
    """'아트지 150g (3절)' -> '아트지 150g' (3절 종이를 평량 기준으로 국4절 자재와 매칭)."""
    return re.sub(r"\s*\(3절\)\s*", "", name).strip()


def match_material(paper, by_nm, mat_rows):
    """
    search-before-mint:
      1) mat_nm 정확 일치(공백 무시) — del_yn=N 우선
      2) 3절 종이는 (3절) 전용 자재(예 '아트지 150g (3절)') 또는 base 평량 자재
    반환: (mat_cd|None, match_kind, note)
    """
    name = paper["name"]
    cands = by_nm.get(name) or []
    # 공백 무시 매칭 보강
    if not cands:
        nn = norm(name)
        for r in mat_rows:
            if norm(r["mat_nm"]) == nn:
                cands.append(r)
    if cands:
        # del_yn=N 우선
        active = [c for c in cands if c.get("del_yn") == "N"]
        chosen = active[0] if active else cands[0]
        return chosen["mat_cd"], "reuse", chosen["mat_nm"]
    return None, "mint_candidate", ""


def main():
    papers = parse_authority()
    mat_rows, by_nm = load_materials()
    live, live_paper_name, _ = load_live_comp_paper(mat_rows)
    existing = existing_codes(mat_rows)

    # 용지 절가 적재 대상 = 가격(국4절 또는 3절)이 숫자인 행만
    targets = [p for p in papers if p["g4"] or p["g3"]]
    nonprice = [p for p in papers if not (p["g4"] or p["g3"])]

    mapping = []        # mapping.csv 행
    new_mats = []       # 신규 mint mat_cd
    cp_inserts_g4 = []  # 국4절 신규 단가행
    cp_inserts_g3 = []  # 3절 신규 단가행
    unknown = []        # 매핑미상

    # 신규 채번 시작점
    maxnum = max(int(c.split("_")[1]) for c in existing)
    next_num = maxnum + 1

    minted = {}  # name -> mat_cd (이번 실행 내 mint 캐시)

    is_3jeol_paper = lambda nm: bool(re.search(r"\(3절\)", nm))

    for p in targets:
        if is_3jeol_paper(p["name"]):
            # 3절 종이 = 전용 '(3절)' 자재(예 '아트지 150g (3절)'=MAT_000083) 우선.
            #   라이브 3절 선례 0 → plt_siz_cd=SIZ_000077(3절·300x625) 추론 + confirm 플래그.
            ded = match_material(p, by_nm, mat_rows)  # 전용 (3절) 자재 정확 매칭
            if ded[0] is not None:
                mat_cd, kind, matnm = ded[0], "reuse(3절-dedicated)", ded[2]
            else:
                # 전용 자재 없음 → base 평량 자재 (사람 확인 필요)
                base = base_name_for_3jeol(p["name"])
                bcd = match_material({"name": base}, by_nm, mat_rows)
                if bcd[0] is not None:
                    mat_cd, kind, matnm = bcd[0], "confirm(3절→base자재)", bcd[2]
                else:
                    mat_cd, kind, matnm = None, "mint_candidate", ""
        else:
            # 0순위) 라이브 COMP_PAPER 가 이미 이 종이를 쓰는 mat_cd (권위 바인딩) 우선
            live_cd = live_paper_name.get(norm(p["name"]))
            if live_cd:
                mat_cd, kind, matnm = live_cd, "reuse(live-bound)", \
                    next((r["mat_nm"] for r in mat_rows if r["mat_cd"] == live_cd), "")
            else:
                # 1순위) t_mat_materials 이름 매칭 (search-before-mint)
                mat_cd, kind, matnm = match_material(p, by_nm, mat_rows)

        if mat_cd is None:
            # 3절 종이는 base 평량 자재로 재매칭 시도
            base = base_name_for_3jeol(p["name"])
            if base != p["name"]:
                mat_cd, kind, matnm = match_material({"name": base}, by_nm, mat_rows)

        if mat_cd is None:
            # 평량 접미 제거 매칭 (예 '리무벌아트지 90g' → 자재 '리무벌아트지').
            #   단, 같은 base 의 자재가 정확히 1개일 때만 (다수면 어느 평량인지 모호 → 매핑미상).
            stripped = re.sub(r"\s*\d+\s*g\s*$", "", p["name"]).strip()
            if stripped and stripped != p["name"]:
                cands = [r for r in mat_rows
                         if norm(r["mat_nm"]) == norm(stripped) and r.get("del_yn") == "N"]
                if len(cands) == 1:
                    mat_cd, kind, matnm = cands[0]["mat_cd"], "reuse(평량접미제거)", cands[0]["mat_nm"]

        if mat_cd is None:
            # 진짜 신규 자재 — mint 후보
            if p["name"] in minted:
                mat_cd = minted[p["name"]]
                kind = "mint(reuse-this-run)"
            else:
                mat_cd = f"MAT_{next_num:06d}"
                minted[p["name"]] = mat_cd
                next_num += 1
                new_mats.append({"mat_cd": mat_cd, "mat_nm": p["name"], "pyung": p["pyung"]})
                kind = "mint"

        # 매칭 자재 del_yn 확인 — 논리삭제 자재에 단가행 적재 금지(BOM/가격 차단됨 → 죽은 데이터)
        del_yn = next((r.get("del_yn") for r in mat_rows if r["mat_cd"] == mat_cd), "N")
        is_deleted_mat = (del_yn == "Y")

        # 적재여부 판정 (국4절 / 3절 각각)
        status_g4 = status_g3 = ""
        if p["g4"]:
            if (mat_cd, PLT_G4) in live:
                status_g4 = "already_loaded"
            elif is_deleted_mat:
                status_g4 = "매핑미상(자재 del_yn=Y·사람 확인)"
                unknown.append({"name": p["name"], "mat_cd": mat_cd, "plt": "국4절",
                                "price": p["g4"], "reason": "매칭 자재 논리삭제(del_yn=Y)"})
            else:
                status_g4 = "to_insert"
                cp_inserts_g4.append({"mat_cd": mat_cd, "name": p["name"],
                                       "pyung": p["pyung"], "price": p["g4"]})
        if p["g3"]:
            if (mat_cd, PLT_G3) in live:
                status_g3 = "already_loaded"
            else:
                # 3절 선례 0 → confirm 플래그(사람이 plt_siz_cd=SIZ_000077 / 자재 선택 확인 후 COMMIT)
                status_g3 = "to_insert(confirm-3절)"
                cp_inserts_g3.append({"mat_cd": mat_cd, "name": p["name"],
                                       "pyung": p["pyung"], "price": p["g3"],
                                       "confirm": True})

        mapping.append({
            "paper_name": p["name"], "pyung": p["pyung"],
            "mat_cd": mat_cd, "mat_match_kind": kind, "matched_mat_nm": matnm,
            "price_g4": p["g4"], "price_g3": p["g3"],
            "status_g4": status_g4, "status_g3": status_g3,
        })

    # 비-용지 행(자재/실사/아크릴 등)은 mapping 에 'not_paper_price' 로 기록(투명성)
    for p in nonprice:
        mapping.append({
            "paper_name": p["name"], "pyung": p["pyung"],
            "mat_cd": "", "mat_match_kind": "not_paper_price",
            "matched_mat_nm": "", "price_g4": "", "price_g3": "",
            "status_g4": "skip(no절가)", "status_g3": "",
        })

    # ---- mapping.csv 출력 ----
    with open(f"{OUT}/paper-import-mapping.csv", "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=[
            "paper_name", "pyung", "mat_cd", "mat_match_kind", "matched_mat_nm",
            "price_g4", "price_g3", "status_g4", "status_g3"])
        w.writeheader()
        for m in mapping:
            w.writerow(m)

    # ---- 리포트 요약 ----
    reuse = sum(1 for m in mapping if m["mat_match_kind"] == "reuse")
    mint = len(new_mats)
    print("=== PAPER IMPORT MATCH 요약 ===")
    print(f"권위 용지(절가 보유) 총수      : {len(targets)}")
    print(f"비-용지(절가 없음·skip)        : {len(nonprice)}")
    print(f"mat_cd 재사용(reuse)           : {reuse}")
    print(f"mat_cd 신규 mint               : {mint}")
    for nm in new_mats:
        print(f"   MINT {nm['mat_cd']} = {nm['mat_nm']} ({nm['pyung']})")
    print(f"국4절 신규 INSERT 대상행        : {len(cp_inserts_g4)}")
    print(f"3절   신규 INSERT 대상행        : {len(cp_inserts_g3)}")
    already_g4 = sum(1 for m in mapping if m["status_g4"] == "already_loaded")
    already_g3 = sum(1 for m in mapping if m["status_g3"] == "already_loaded")
    print(f"국4절 이미 적재(미터치)         : {already_g4}")
    print(f"3절   이미 적재(미터치)         : {already_g3}")
    print(f"매핑미상(사람 확인)             : {len(unknown)}")
    for u in unknown:
        print(f"   UNKNOWN {u['name']} ({u['plt']}) → {u['mat_cd']} : {u['reason']} (절가 {u['price']})")

    return {"new_mats": new_mats, "cp_g4": cp_inserts_g4, "cp_g3": cp_inserts_g3,
            "mapping": mapping, "unknown": unknown}


if __name__ == "__main__":
    res = main()
    # SQL 생성은 paper_import_sql.py 가 담당 (이 모듈은 import 가능하게)
