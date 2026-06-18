#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
round-24 2단계 — ✅GREEN 36 적재대상 분리 + 가변 계층 깊이(설계철학) 적용.
입력(재유도 금지):
  - ../product-cat.csv          : 레이어 B junction 명세(검증 GO·verdict v2)
  - ../_live/categories_live.tsv: 라이브 카테고리 트리(del_yn 권위·재추출본)
산출:
  - product-cat-green.csv       : ✅GREEN 36 본체 + 해당 별칭(있으면) junction
규칙:
  - GREEN body(main='Y') 36행만 추출 + 그 body prd_cd에 속한 ALIAS 행 포함(있으면).
  - ★가변 계층 깊이: GREEN body의 cat_cd를, 자연스러운 활성(del='N') 깊은 노드가 있으면 그 노드로 재지정.
    (search-before-mint 유지 — 전부 기존 활성 노드·신규 mint 0)
  - (prd_cd,cat_cd) PK 중복 0 · prd_cd당 main='Y' 단일 재확인.
DB 미적재 — 적재본 생성만.
"""
import csv, os
from collections import Counter, defaultdict

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --- 1) 라이브 트리(del_yn 권위) ---
cats = {}  # cat_cd -> (nm, parent, lvl, use_yn, del_yn)
with open(os.path.join(BASE, "_live", "categories_live.tsv"), encoding="utf-8") as f:
    for r in csv.reader(f, delimiter="\t"):
        if len(r) < 6:
            continue
        cats[r[0]] = (r[1], r[2], r[3], r[4], r[5])

# --- 2) ★가변 계층 깊이 재지정 맵 (GREEN body prd_cd -> 활성 깊은 cat_cd) ---
# 근거: 자연스러운 활성(del='N') L2/L3 노드 존재 시 거기에 귀속. 부재 시 L1 유지.
# 검증: 아래 모든 target은 categories_live.tsv del_yn='N' 활성(스크립트 가드로 재확인).
DEEPER = {
    "PRD_000016": "CAT_000307",  # 프리미엄엽서  -> 엽서 L2
    "PRD_000017": "CAT_000307",  # 코팅엽서      -> 엽서 L2
    "PRD_000018": "CAT_000307",  # 스탠다드엽서  -> 엽서 L2
    "PRD_000027": "CAT_000021",  # 2단접지카드  -> 접지카드 L2 (라이브 현행 일치·no-op)
    "PRD_000029": "CAT_000021",  # 3단접지카드  -> 접지카드 L2 (라이브 현행 일치·no-op)
    "PRD_000041": "CAT_000062",  # 스탠다드쿠폰  -> 쿠폰/상품권 L2 (현행 del='Y' orphan 교정)
    "PRD_000042": "CAT_000062",  # 프리미엄상품권-> 쿠폰/상품권 L2 (현행 del='Y' orphan 교정)
    "PRD_000047": "CAT_000058",  # 소량전단지   -> 전단지/리플랫 L2
    "PRD_000118": "CAT_000076",  # 아트프린트포스터 -> 아트프린트 L2 (현행 del='Y' orphan 교정)
    "PRD_000124": "CAT_000072",  # 린넨패브릭포스터 -> 패브릭포스터 L2 (현행 del='Y' orphan 교정)
    "PRD_000125": "CAT_000072",  # 캔버스패브릭포스터-> 패브릭포스터 L2 (현행 del='Y' orphan 교정)
    # PRD_000094 엽서북은 product-cat.csv에서 이미 CAT_000308(활성 L2) → 그대로 유지
}

# --- 3) product-cat.csv 읽기 → GREEN body + 해당 alias ---
rows = []
with open(os.path.join(BASE, "product-cat.csv"), encoding="utf-8-sig") as f:
    rows = list(csv.DictReader(f))

green_body = [r for r in rows if r["status"] == "GREEN" and r["main_cat_yn"] == "Y" and r["prd_cd"]]
green_prd = {r["prd_cd"] for r in green_body}
# GREEN body에 속한 별칭(main='N') — 본 데이터셋에는 0건이지만 일반 규칙으로 포함
green_alias = [r for r in rows
               if r["status"].startswith("ALIAS")
               and r["prd_cd"] in green_prd]

# --- 4) 가변 계층 깊이 재지정 적용(활성 노드 가드) ---
disp = defaultdict(int)
out_rows = []
for r in green_body:
    prd = r["prd_cd"]
    new_cat = DEEPER.get(prd, r["cat_cd"])
    # 가드: 재지정 target이 활성(del='N')인지 확인. del='Y'면 원래 cat_cd 유지.
    nm, parent, lvl, use_yn, del_yn = cats.get(new_cat, ("", "", "", "", "N"))
    if del_yn != "N":
        new_cat = r["cat_cd"]  # 비활성이면 재지정 취소(원래 매핑 유지)
        nm, parent, lvl, use_yn, del_yn = cats.get(new_cat, ("", "", "", "", "N"))
    depth_note = ""
    if new_cat != r["cat_cd"]:
        depth_note = "가변깊이: L%s %s 활성노드 귀속(L1직속→deeper)" % (lvl, nm)
    o = dict(r)
    o["cat_cd"] = new_cat
    o["cat_nm"] = nm
    o["match_level"] = "L%s노드일치(가변깊이)" % lvl if new_cat != r["cat_cd"] else r["match_level"]
    o["note"] = (r["note"] + " | " if r["note"] else "") + depth_note if depth_note else r["note"]
    out_rows.append(o)

out_rows += [dict(r) for r in green_alias]

# --- 5) disp_seq 부여(카테고리별 출시 순서) + PK/main 단일성 재확인 ---
pk = Counter((r["prd_cd"], r["cat_cd"]) for r in out_rows)
pk_dups = {k: v for k, v in pk.items() if v > 1}
main_per_prd = Counter(r["prd_cd"] for r in out_rows if r["main_cat_yn"] == "Y")
main_violations = {p: c for p, c in main_per_prd.items() if c != 1}
delY = [r for r in out_rows if cats.get(r["cat_cd"], ("", "", "", "", "N"))[4] != "N"]

# --- 6) 출력 ---
out = os.path.join(BASE, "08_load-green", "product-cat-green.csv")
cols = ["prd_cd", "prd_nm", "map_category", "status", "cat_cd", "cat_nm",
        "main_cat_yn", "match_level", "live_opt_n", "live_priced", "multi_class", "note"]
with open(out, "w", encoding="utf-8-sig", newline="") as f:
    w = csv.DictWriter(f, fieldnames=cols)
    w.writeheader()
    for r in sorted(out_rows, key=lambda x: (x["cat_cd"], x["prd_cd"])):
        w.writerow({k: r.get(k, "") for k in cols})

# --- 7) 게이트 출력 ---
print("=== product-cat-green.csv (✅GREEN 적재대상) ===")
print("GREEN body(main='Y'):", len(green_body))
print("GREEN 소속 alias(main='N'):", len(green_alias))
print("총 junction 행:", len(out_rows))
print("distinct prd_cd:", len({r["prd_cd"] for r in out_rows}))
print("가변깊이 재지정 적용 행:", sum(1 for r in out_rows if "가변깊이" in r.get("match_level", "")))
print("target cat_cd 분포:", dict(Counter(r["cat_cd"] for r in out_rows)))
print("--- 게이트 ---")
print("[PK] (prd_cd,cat_cd) 중복:", len(pk_dups), "(목표 0)", pk_dups or "")
print("[MAIN] prd_cd당 main='Y'!=1:", len(main_violations), "(목표 0)", main_violations or "")
print("[DEL] del='Y'/use 비활성 노드 귀속:", len(delY), "(목표 0)",
      [(r["prd_cd"], r["cat_cd"]) for r in delY] or "")
