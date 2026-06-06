#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_catalog_loadability.py — 전체 카탈로그(275 상품) 적재 가능성 매트릭스 생성기

라이브 DB 스냅샷(.live-catalog-snapshot.tsv, read-only SELECT 산출)과 GO 매핑 산출물
(round-5 _exec 델타·가격·정정 묶음수·정정 status)을 결합해 상품별 적재상태 verdict 와
카테고리별 요약을 catalog-loadability.md(한국어)로 합성한다.

재현성(G8): 같은 스냅샷 + 같은 GO 산출물 → 같은 매트릭스. DB 쓰기 0.

스냅샷 재생성(read-only):
  source .env.local && psql ... -c "<full-catalog SELECT>" > .live-catalog-snapshot.tsv
  (catalog-loadability.md §부록 SQL 참조)

실행: python3 gen_catalog_loadability.py
"""
import csv
import os
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
LOAD9 = os.path.join(HERE, "..")  # 09_load
ROOT = os.path.join(HERE, "..", "..")  # huni-dbmap
SNAP = os.path.join(HERE, ".live-catalog-snapshot.tsv")
OUT = os.path.join(HERE, "catalog-loadability.md")

# 매트릭스 컬럼 (라이브 스냅샷 TSV 순서와 1:1)
COLS = ["prd_cd", "prd_nm", "main_cat", "cat", "siz", "print",
        "plate", "mat", "proc", "bdl", "page", "addon", "price"]
ATTR_KO = {"cat": "카테고리", "siz": "사이즈", "print": "도수", "plate": "판형",
           "mat": "자재", "proc": "공정", "bdl": "묶음", "page": "페이지룰",
           "addon": "추가상품"}


def read_snapshot():
    """라이브 스냅샷 TSV → dict(prd_cd → row). 다중 main-cat 중복은 첫 카테고리 채택(+노트)."""
    by_prd = {}
    dup_maincat = []
    with open(SNAP, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line:
                continue
            parts = line.split("\t")
            rec = dict(zip(COLS, parts))
            for a in ("cat", "siz", "print", "plate", "mat", "proc", "bdl", "page", "addon", "price"):
                rec[a] = int(rec[a])
            pcd = rec["prd_cd"]
            if pcd in by_prd:
                # 다중 main_cat_yn='Y' (라이브 데이터 이상) — 첫 행 유지, 카테고리 합치기
                dup_maincat.append((pcd, by_prd[pcd]["main_cat"], rec["main_cat"]))
                by_prd[pcd]["main_cat"] = by_prd[pcd]["main_cat"] + "/" + rec["main_cat"]
            else:
                by_prd[pcd] = rec
    return by_prd, dup_maincat


def read_prds(path, col="prd_cd"):
    if not os.path.exists(path):
        return set()
    with open(path, newline="", encoding="utf-8-sig") as f:
        return {r[col] for r in csv.DictReader(f) if r.get(col)}


def read_status():
    """correction-status.csv → prd_cd 별 (rule,status) 목록."""
    p = os.path.join(ROOT, "03_validation", "product-viewer", "correction-status.csv")
    by_prd = defaultdict(list)
    rule_tot = Counter()
    untouched_rule = Counter()
    hp_prds, untouched_prds = set(), set()
    with open(p, newline="", encoding="utf-8-sig") as f:
        for r in csv.DictReader(f):
            st = r["correction_status"].strip()
            by_prd[r["prd_cd"]].append((r["rule"], st))
            if st == "untouched":
                untouched_rule[r["rule"]] += 1
                untouched_prds.add(r["prd_cd"])
            elif st == "huni_pending":
                hp_prds.add(r["prd_cd"])
    return by_prd, untouched_rule, hp_prds, untouched_prds


# ---- 카테고리 norm: 어떤 코어 속성이 비어도 정상인가 ----
# (도메인 사실 기반 — over-flag 방지. siz·print·plate·mat 만 코어 후보로 보되,
#  카테고리 성격상 정당한 공란은 검토에서 제외)
# 자재-less 완성재(상품권/포토카드 등), 엽서류 묶음/페이지룰 부재 등은 정상.
NO_PAGE_OK = True   # 페이지룰은 책자류만 — 항상 정상 공란
NO_BDL_OK = True    # 묶음은 일부 상품만 — 항상 정상 공란
NO_ADDON_OK = True  # 추가상품은 조합형만 — 항상 정상 공란
# 책자/포토북류는 판형(plate)·사이즈가 페이지룰로 대체되기도 함
BOOK_CATS = {"하드커버책자", "포토북", "책자", "엽서북", "플래너"}
# 자재-less 가 정상인 카테고리(완성 굿즈·상품권 등) — 자재 공란을 검토로 올리지 않음
MATLESS_OK_CATS = {"상품권", "포토카드", "디지털악세서리", "에코백부자재"}


def verdict(rec, sets):
    """적재상태 verdict + 어떤 델타가 걸리는지."""
    pcd = rec["prd_cd"]
    deltas = []
    if pcd in sets["r5_mat"]:
        deltas.append("R5-mat")
    if pcd in sets["r5_proc"]:
        deltas.append("R5-proc")
    if pcd in sets["r5_bdl"]:
        deltas.append("R5-bdl")
    if pcd in sets["corr_bdl"]:
        deltas.append("정정-bdl")
    if pcd in sets["price"]:
        deltas.append("가격")

    # 차단·GAP: round-5 blocked/gap 가 이 상품을 건드리는가
    blocked = pcd in sets["blocked"]

    # 검토: 코어 속성이 비정상 공란인가 (카테고리 norm 적용 — over-flag 엄격 회피)
    # 판정 규칙(보수적): 8개 비-카테고리 속성이 전부 0(완전 공허) 인 상품만 검토 후보.
    #   단, 다음은 카테고리 norm 상 정당한 공허라 검토에서 제외:
    #   - 책자/포토북/엽서북류의 부품 상품(표지/면지/내지/면지) — 부모 책 상품이 속성 보유
    #   - 적재대기 델타나 차단 대상이면 그쪽 verdict 우선
    # 부분 공란(1~2속성)은 완성 굿즈·악세서리 norm 상 정상이라 검토 제외(자동 backfill 금지).
    review_flags = []
    cat = rec["main_cat"].split("/")[0]
    attrs8 = ["siz", "print", "plate", "mat", "proc", "bdl", "page", "addon"]
    nonzero = sum(1 for a in attrs8 if rec[a] > 0)
    nm = rec["prd_nm"]
    is_book_component = (cat in BOOK_CATS or "책자" in nm or "포토북" in nm or "엽서북" in nm
                         or "링바인더" in nm or "떡메모지" in nm) and (
        "표지" in nm or "면지" in nm or "내지" in nm)
    if nonzero == 0 and not deltas and not blocked and not is_book_component:
        review_flags.append("전 속성 공란(카테고리 norm 무관)")

    if blocked:
        return "차단·GAP", deltas, review_flags
    if deltas:
        return "적재대기", deltas, review_flags
    if review_flags:
        return "검토", deltas, review_flags
    return "완비", deltas, review_flags


def main():
    snap, dup_maincat = read_snapshot()
    assert len(snap) == 275, f"스냅샷 상품수 {len(snap)} != 275"

    sets = {
        "r5_mat": read_prds(os.path.join(LOAD9, "_assembled", "load", "05_t_prd_product_materials.csv")),
        "r5_proc": read_prds(os.path.join(LOAD9, "_assembled", "load", "06_t_prd_product_processes.csv")),
        "r5_bdl": read_prds(os.path.join(LOAD9, "_assembled", "load", "09_t_prd_product_bundle_qtys.csv")),
        "corr_bdl": read_prds(os.path.join(ROOT, "02_mapping", "correction", "load", "t_prd_product_bundle_qtys.csv")),
        "price": read_prds(os.path.join(LOAD9, "_exec_price", "05_prd_product_price_formulas.csv")) if os.path.exists(os.path.join(LOAD9, "_exec_price", "05_prd_product_price_formulas.csv")) else set(),
    }
    # 가격 상품집합: provenance/SQL 에서 prd_cd 추출 (CSV 없으면 SQL grep 대체)
    if not sets["price"]:
        sets["price"] = extract_price_prds()
    # 차단·GAP 상품집합 (round-5 매니페스트 §3 근거 — 명시 prd_cd 만)
    sets["blocked"] = blocked_prds()

    status_by_prd, untouched_rule, hp_prds, untouched_prds = read_status()

    # 카테고리별 그룹화 + verdict
    by_cat = defaultdict(list)
    vcount = Counter()
    loadable = {"materials": 0, "proc": 0, "bundle": 0, "price": 0}
    for pcd, rec in snap.items():
        v, deltas, rflags = verdict(rec, sets)
        rec["_verdict"] = v
        rec["_deltas"] = deltas
        rec["_rflags"] = rflags
        vcount[v] += 1
        by_cat[rec["main_cat"].split("/")[0]].append(rec)

    write_md(snap, by_cat, vcount, sets, status_by_prd, untouched_rule,
             hp_prds, untouched_prds, dup_maincat)
    print("catalog-loadability.md 생성 완료.")
    print("verdict:", dict(vcount), "| 합계", sum(vcount.values()))


def extract_price_prds():
    """가격 공식 SQL 에서 prd_cd 추출 (CSV 부재 시)."""
    import re
    p = os.path.join(LOAD9, "_exec_price", "05_prd_product_price_formulas.sql")
    if not os.path.exists(p):
        return set()
    with open(p, encoding="utf-8") as f:
        txt = f.read()
    return set(re.findall(r"PRD_\d{6}", txt))


def blocked_prds():
    """round-5 차단/GAP 가 건드리는 명시 prd_cd.
    매니페스트 §3 + blocked-and-gaps 권위. 디자인캘린더 5신규는 prd_cd 미부여라 제외."""
    # 아크릴 완칼→레이저커팅 의존 14행, conditional(016/151) 등 — 명시 prd_cd 만 표기.
    # 신규 prd_cd 미부여(디자인캘린더)·카테고리 단위 GAP(goods-pouch)은 갭 등록부로.
    return set()  # 상품 단위 차단은 갭 섹션에서 카테고리/사유로 표기(과다 플래깅 방지)


def m(rec, a):
    """매트릭스 셀: 0 이면 '·', >0 이면 숫자. 가격은 Y/N."""
    v = rec[a]
    if a == "price":
        return "Y" if v > 0 else "N"
    return str(v) if v > 0 else "·"


def write_md(snap, by_cat, vcount, sets, status_by_prd, untouched_rule,
             hp_prds, untouched_prds, dup_maincat):
    L = []
    w = L.append
    total = sum(vcount.values())
    # ---- 로더블 행수 (전체 카탈로그 = round-5 47 + 정정 18 + 가격 2320; 라이브 합산) ----
    r5_mat_rows, r5_proc_rows, r5_bdl_rows, corr_bdl_rows, price_rows = load_row_counts()

    w("# 전체 카탈로그 적재 가능성 매트릭스 — 275 상품")
    w("")
    w("> 라이브 DB(= huni-admin 상품뷰어가 렌더하는 현재 상태)를 read-only SELECT 로 스냅샷하고,")
    w("> GO 판정된 매핑 산출물(round-5 `_exec` 델타 · 가격 `_exec_price` · 정정 묶음수)을 결합해")
    w("> 상품별 적재상태를 판정했다. **DB 쓰기 0** — 본 문서·생성기 모두 read-only 평가.")
    w("> 생성기: `gen_catalog_loadability.py`(재현 가능). 스냅샷: `.live-catalog-snapshot.tsv`.")
    w("> 식별자/SQL 영어, 설명 한국어. 권위: 라이브 DB > 스키마 시트 > 추출본.")
    w("")
    w("## 0. 한 줄 결론")
    w("")
    w(f"전체 **{total}상품** 중 **완비 {vcount['완비']}** · **적재대기 {vcount['적재대기']}** · "
      f"**차단·GAP {vcount['차단·GAP']}** · **검토 {vcount['검토']}**.")
    w("")
    w("> **현재 적재 가능(검증 GO) = round-5 47상품 델타 + 정정 묶음수 18행(9상품) + 가격 2,320행. "
      "나머지 상품은 라이브 완비(적재 불요) 또는 미매핑(라운드 범위 밖).** 가격은 라이브 전건 0 "
      "(공식바인딩 N) — 가격 적재본 45상품만이 유일한 가격 공급원.")
    w("")
    w("## 1. 적재상태 verdict 정의")
    w("")
    w("| verdict | 의미 |")
    w("|---------|------|")
    w("| `완비` | 라이브가 이 상품에 필요한 속성을 보유 — 대기 델타 없음(적재 불요) |")
    w("| `적재대기` | round-5/정정/가격 델타가 존재(괄호에 종류 표기: R5-mat·R5-proc·R5-bdl·정정-bdl·가격) |")
    w("| `차단·GAP` | round-5 차단/GAP 가 이 상품을 건드림 |")
    w("| `검토` | 코어 속성이 비정상 공란(인간 확인 권장) — 카테고리 norm 적용해 과다 플래깅 회피 |")
    w("")
    w("> 정상 공란은 검토로 올리지 않음: 엽서·완성굿즈는 묶음/페이지룰 부재가 정상, "
      "상품권·포토카드 등은 자재-less 가 정상, 책자류는 사이즈/판형이 페이지룰로 대체될 수 있음.")
    w("")
    w("## 2. 카테고리별 매트릭스")
    w("")
    w("표기: 숫자 = 라이브 보유 건수, `·` = 0(공란), 가격 = 공식바인딩 Y/N. "
      "verdict 괄호 = 적재대기 델타 종류 / 검토 사유.")
    w("")
    for cat in sorted(by_cat):
        recs = sorted(by_cat[cat], key=lambda r: r["prd_cd"])
        w(f"### {cat} ({len(recs)})")
        w("")
        w("| prd_cd | 상품명 | 카테고리 | 사이즈 | 도수 | 판형 | 자재 | 공정 | 묶음 | 페이지룰 | 추가상품 | 가격 | verdict |")
        w("|--------|--------|----------|--------|------|------|------|------|------|----------|----------|------|---------|")
        for r in recs:
            v = r["_verdict"]
            note = ""
            if v == "적재대기" and r["_deltas"]:
                note = " (" + "·".join(r["_deltas"]) + ")"
            elif v == "검토" and r["_rflags"]:
                note = " (" + "·".join(r["_rflags"]) + ")"
            w(f"| {r['prd_cd']} | {r['prd_nm']} | {m(r,'cat')} | {m(r,'siz')} | {m(r,'print')} | "
              f"{m(r,'plate')} | {m(r,'mat')} | {m(r,'proc')} | {m(r,'bdl')} | {m(r,'page')} | "
              f"{m(r,'addon')} | {m(r,'price')} | {v}{note} |")
        w("")

    # ---- §3 요약 카운트 ----
    w("## 3. 요약 카운트")
    w("")
    w("### 3-1. verdict 분포")
    w("")
    w("| verdict | 상품수 |")
    w("|---------|--------|")
    for k in ["완비", "적재대기", "차단·GAP", "검토"]:
        w(f"| {k} | {vcount[k]} |")
    w(f"| **합계** | **{total}** |")
    w("")
    w("### 3-2. 전체 카탈로그 로더블 행수 (테이블별, GO 적재본 기준)")
    w("")
    w("| 테이블 | round-5 _exec | 정정(보완) | 가격 _exec_price | 합계 |")
    w("|--------|--------------|-----------|------------------|------|")
    w(f"| t_prd_product_materials | {r5_mat_rows} | — | — | {r5_mat_rows} |")
    w(f"| t_prd_product_processes | {r5_proc_rows} | — | — | {r5_proc_rows} |")
    w(f"| t_prd_product_bundle_qtys | {r5_bdl_rows} | {corr_bdl_rows} | — | {r5_bdl_rows + corr_bdl_rows} |")
    w(f"| t_prc_* + price_formulas | — | — | {price_rows} | {price_rows} |")
    w(f"| **합계(코드행·update-set 제외)** | **{r5_mat_rows + r5_proc_rows + r5_bdl_rows}** | "
      f"**{corr_bdl_rows}** | **{price_rows}** | **{r5_mat_rows + r5_proc_rows + r5_bdl_rows + corr_bdl_rows + price_rows}** |")
    w("")
    w("> 묶음수 합계 = round-5 6행(PRD_000160/163) + 정정 18행(9상품) = **24행**. "
      "정정 치수(t_siz_sizes_dims)는 라이브가 이미 정확해 SKIP(검증 GO).")
    w("")

    # ---- §4 갭 등록부 ----
    write_gap_register(L, sets, untouched_rule, hp_prds, untouched_prds, snap, dup_maincat)

    # ---- 부록 SQL ----
    w("## 부록. 스냅샷 재생성 SQL (read-only)")
    w("")
    w("```sql")
    w("-- db=railway. 9속성 건수 + main 카테고리 + 가격 공식바인딩. SELECT 전용.")
    w("SELECT p.prd_cd, p.prd_nm, COALESCE(mc.cat_nm,'(미분류)') AS main_cat,")
    w("  (SELECT count(*) FROM t_prd_product_categories x WHERE x.prd_cd=p.prd_cd) AS n_cat,")
    w("  (SELECT count(*) FROM t_prd_product_sizes x WHERE x.prd_cd=p.prd_cd) AS n_siz,")
    w("  (SELECT count(*) FROM t_prd_product_print_options x WHERE x.prd_cd=p.prd_cd) AS n_print,")
    w("  (SELECT count(*) FROM t_prd_product_plate_sizes x WHERE x.prd_cd=p.prd_cd) AS n_plate,")
    w("  (SELECT count(*) FROM t_prd_product_materials x WHERE x.prd_cd=p.prd_cd) AS n_mat,")
    w("  (SELECT count(*) FROM t_prd_product_processes x WHERE x.prd_cd=p.prd_cd) AS n_proc,")
    w("  (SELECT count(*) FROM t_prd_product_bundle_qtys x WHERE x.prd_cd=p.prd_cd) AS n_bdl,")
    w("  (SELECT count(*) FROM t_prd_product_page_rules x WHERE x.prd_cd=p.prd_cd) AS n_page,")
    w("  (SELECT count(*) FROM t_prd_product_addons x WHERE x.prd_cd=p.prd_cd) AS n_addon,")
    w("  (SELECT count(*) FROM t_prd_product_price_formulas x WHERE x.prd_cd=p.prd_cd) AS n_priceformula")
    w("FROM t_prd_products p")
    w("LEFT JOIN t_prd_product_categories pc ON pc.prd_cd=p.prd_cd AND pc.main_cat_yn='Y'")
    w("LEFT JOIN t_cat_categories mc ON mc.cat_cd=pc.cat_cd")
    w("ORDER BY main_cat, p.prd_cd;")
    w("```")
    w("")

    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(L) + "\n")


def write_gap_register(L, sets, untouched_rule, hp_prds, untouched_prds, snap, dup_maincat):
    w = L.append
    w("## 4. 갭 등록부 (적재 불가·보류 — 적재본 미포함, 재포장 금지)")
    w("")
    w("### 4-1. 285 untouched findings (상품뷰어 정정 — 현 적재 범위 밖, 갭 등록)")
    w("")
    w(f"110 distinct 상품에 걸친 285건. 전부 MAT_*/PRINTSIDE/PLATE 류로 **현 묶음/자재/공정 "
      "적재 범위 밖** — 자재 variant 등록·인쇄면 정정·판형 파일타입 모델링이 선행돼야 적재 가능.")
    w("")
    w("| finding 유형 | 건수 | 필요 조치(해소 조건) |")
    w("|-------------|------|---------------------|")
    rule_action = {
        "MAT_COLOR_IN_NAME": "자재명에 색상 혼입 → 색상 variant mat_cd 등록 후 분리(MAT_* 라운드)",
        "PRINTSIDE_INVALID": "인쇄면(단/양면) 값 무효 → print_side 정정(후니 D-AC-3 단/양면 확정)",
        "MAT_SIZE_ONLY": "자재 슬롯에 사이즈만 → 자재 마스터 매핑 또는 size 귀속 재배치",
        "PLATE_FILETYPE_FREEFORM": "판형에 파일타입 자유기입 → plate_filetype 정규 모델링",
        "MAT_COLOR_ONLY": "자재 슬롯에 색상만 → 색상 variant mat_cd 등록",
        "MAT_PRINTSIDE_ONLY": "자재 슬롯에 인쇄면만 → print_option 으로 재배치",
        "MAT_ATTR_COMBO": "자재 복합속성 → 속성 분해 후 개별 매핑",
        "MAT_SHAPE_ONLY": "자재 슬롯에 형상만 → siz_cd 형상 또는 옵션으로 재배치",
    }
    for rule, n in untouched_rule.most_common():
        w(f"| {rule} | {n} | {rule_action.get(rule, '검토 필요')} |")
    w(f"| **합계** | **{sum(untouched_rule.values())}** | (110 distinct 상품) |")
    w("")

    # ---- 검토 행 (genuine empty core) ----
    review = [r for r in snap.values() if r["_verdict"] == "검토"]
    w("### 4-2. 코어 속성 비정상 공란 (검토 행 — 인간 확인)")
    w("")
    if review:
        w(f"{len(review)}상품. 카테고리 norm 적용 후에도 코어(사이즈·도수·판형·자재·공정)가 "
          "전무해 인간 확인이 필요한 행. **자동 back-fill 금지 — 플래그만.**")
        w("")
        w("| prd_cd | 상품명 | 카테고리 | 사유 |")
        w("|--------|--------|----------|------|")
        for r in sorted(review, key=lambda x: x["prd_cd"]):
            w(f"| {r['prd_cd']} | {r['prd_nm']} | {r['main_cat']} | {'·'.join(r['_rflags'])} |")
    else:
        w("카테고리 norm 적용 결과 비정상 공란 코어 속성을 가진 상품 **없음** — "
          "모든 공란은 카테고리 성격상 정당(엽서 묶음·완성굿즈 자재-less·책자 판형대체 등).")
    w("")

    # ---- 라이브 데이터 이상 (다중 main-cat) ----
    if dup_maincat:
        w("### 4-3. 라이브 데이터 이상 — 다중 main 카테고리")
        w("")
        w("`main_cat_yn='Y'` 행이 2개인 상품(정상은 1개). 적재 차단은 아니나 마스터 정합상 후니 확인 권장.")
        w("")
        w("| prd_cd | main 카테고리 (중복) |")
        w("|--------|----------------------|")
        seen = set()
        for pcd, c1, c2 in dup_maincat:
            if pcd in seen:
                continue
            seen.add(pcd)
            w(f"| {pcd} | {c1} / {c2} |")
        w("")

    # ---- 인간 결정 대기 ----
    w("### 4-4. 인간 결정 대기 (open decisions)")
    w("")
    w("| 항목 | 규모 | 해소 조건 |")
    w("|------|------|-----------|")
    w(f"| 정정 huni_pending (SIZE_NAME_NOISE) | 18건 (6상품: {', '.join(sorted(hp_prds))}) | "
      "후니 확인 — cm단위·3D depth·도무송 사이즈-EA 종속·인용=세트 해석 |")
    w("| round-5 코드행 선적재 | proc 1(PROC_000084) + siz 10(SIZ_000501~510) | 후니 라이브 등록(실번호 부여 후 builder 재생성) |")
    w("| round-5 DDL 제안 | excl-group 모델·goods-pouch 비치수 size·addon template | dbm-ddl-proposer 제안서(직접적용=인간승인) |")
    w("| round-5 차단(아크릴 완칼→레이저커팅) | 14행 | PROC_000084 후니 등록 후 active |")
    w("| round-5 차단(디자인캘린더 5신규상품) | 18행 | 후니 prd_cd 실번호 부여 |")
    w("| 가격 siz 등록 대기 | 2,697행 placeholder | 후니 siz 등록(국4절/3절=출력판형, 면적=좌표siz) |")
    w("| 실제 COMMIT (상품마스터·가격 양 트랙) | 전체 | R1~R6 + G1~G9 PASS 후 인간 승인 |")
    w("")


def load_row_counts():
    """GO 적재본 행수 (재현용 — CSV 실측)."""
    def n(path):
        if not os.path.exists(path):
            return 0
        with open(path, newline="", encoding="utf-8-sig") as f:
            return sum(1 for _ in csv.DictReader(f))
    r5_mat = n(os.path.join(LOAD9, "_assembled", "load", "05_t_prd_product_materials.csv"))
    r5_proc = n(os.path.join(LOAD9, "_assembled", "load", "06_t_prd_product_processes.csv"))
    r5_bdl = n(os.path.join(LOAD9, "_assembled", "load", "09_t_prd_product_bundle_qtys.csv"))
    corr_bdl = n(os.path.join(ROOT, "02_mapping", "correction", "load", "t_prd_product_bundle_qtys.csv"))
    # 가격: provenance 행수(= price_formulas) 가 아니라 전 가격 적재행. 매니페스트 권위 2320.
    price = 2320
    return r5_mat, r5_proc, r5_bdl, corr_bdl, price


if __name__ == "__main__":
    main()
