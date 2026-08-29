"""M3-B — 구성요소 ↔ 권위 하위표 매핑 (1:N) · 읽기전용 SELECT.

SPEC-PRICEGRID-001 M3 산출 1. plan.md §B-4 의 첫 조사 대상이 「`table_diff.py` 의
열 단위 짝짓기를 역방향으로 쓸 수 있는가」였고, **답은 예다** — 이 모듈이 그 재사용이다.

[HARD] 방향만 뒤집는다. 점수 배합은 손대지 않는다.

    table_diff.py : 권위 표 → 「이 표에 대응하는 구성요소는 무엇인가」  (라이브 대조용)
    m3_map.py     : 그 결과를 뒤집어 「이 구성요소의 권위 하위표는 무엇인가」 (분모 생성용)

  점수 = 0.45·값겹침 + 0.20·Jaccard + 0.25·열라벨적합 + 0.10·이름유사
  이 배합은 `table_diff.py` 가 네 차례 튜닝해 UNLOADED 0 · GAP 20셀까지 좁힌 것이다.
  거기 주석에 실측된 실패가 적혀 있다 — 하드필터와 이름가중 0.40 은 크게 퇴행했고
  (GAP 328→528셀 · UNLOADED 0→2,063셀), 표 단위 짝짓기와 1:1 강제 배정도 악화됐다.
  **재시도 금지 이력이므로 다시 시도하지 않는다.**

[HARD] 1:N 을 막지 않는다. `COMP_ACRYL_CLEAR3T` 는 「투명아크릴3T」+「투명아크릴1.5T」
       두 하위표에 걸린다(196+81=277). 배타 배정을 넣으면 그 둘 중 하나가 잘려 나간다.

[HARD] 근사 매칭을 확정으로 승격하지 않는다(REQ-PG-011). 겹침이 MIN_OVERLAP 미만이면
       짝을 만들지 않고 미성립으로 남긴다. 목록이 비지 않은 것은 실패가 아니다.

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_map.py
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_map.py --comp COMP_ACRYL_CLEAR3T
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_map.py --csv m3-map-260829.csv
"""
import argparse
import csv
import json
import os
import re
import sys
from collections import defaultdict
from decimal import Decimal

import django
from dotenv import load_dotenv

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ROOT = "/Users/innojini/Dev/HuniWeb/raw/webadmin"
sys.path.insert(0, ROOT + "/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
load_dotenv(ROOT + "/.env")
django.setup()
from django.db import connection  # noqa: E402

import m3_l1  # noqa: E402

MIN_OVERLAP = 0.30      # table_diff.py 와 같은 문턱 — 미만이면 짝으로 보지 않는다

# [HARD] 동점 여백 — 1·2위 점수 차가 이 미만이면 **배정하지 않는다**(REQ-PG-011).
#   실측 근거: 코팅 시트는 유광·무광 단가가 완전히 동일하고(§7.4 은폐 요인),
#   권위 라벨(「유광코팅」)과 라이브 공정명(「유광라미네이팅」)의 어휘가 달라
#   유사도가 0.375 로 임계 미달이라 라벨 신호도 0 이다. 즉 값·이름 **어느 신호로도
#   갈리지 않는다.** 이때 1위를 고르면 동전 던지기를 확정으로 승격하는 것이 된다.
AMBIG_MARGIN = 0.02

# 도메인 규칙 (지니 확정 2026-08-29 · table_diff.py 와 동일)
#   후가공_박(백업) 은 안 하는 부분이다. 매니페스트에도 not_extracted 로 기록돼 있다.
SKIP_SHEETS = {"후가공_박(백업)"}

# 구간할인 표는 단가표가 아니다 — t_prc_component_prices 가 아니라 할인 테이블 계열이다.
# 구성요소에 짝지으려 하면 값이 백분율이라 엉뚱한 구성요소에 낮은 겹침으로 붙는다
# (실측: 「아크릴카라비너 수량별 구간할인」 → COMP_POSTEROPT_LINEN_FINISH 겹침 0.33).
DISCOUNT_TITLE = re.compile(r"구간할인|할인율|할인표")


def name_sim(a, b):
    """이름 유사도 — 공백·괄호·기호를 걷어낸 뒤 문자 집합 Jaccard."""
    def g(s):
        return set(re.sub(r"[\s()（）\[\]/·,.\-_]+", "", str(s or "")))
    A, B = g(a), g(b)
    if not A or not B:
        return 0.0
    return len(A & B) / len(A | B)


def dim_name_map():
    """차원 코드 → 사람이 읽는 이름. 열 라벨과 맞춰 보기 위한 사전."""
    out = {}
    q = [("t_proc_processes", "proc_cd", "proc_nm"),
         ("t_mat_materials", "mat_cd", "mat_nm"),
         ("t_siz_sizes", "siz_cd", "siz_nm"),
         ("t_prt_print_options", "print_opt_cd", "print_opt_nm")]
    with connection.cursor() as c:
        for tbl, cd, nm in q:
            try:
                c.execute(f"SELECT {cd}, {nm} FROM {tbl}")
                for k, v in c.fetchall():
                    if k and v:
                        out[k] = v
            except Exception:
                connection.rollback()
    return out


def live_components():
    """구성요소별 {값 집합, 차원값 이름 집합, use_dims, 행수}."""
    dn = dim_name_map()
    with connection.cursor() as c:
        c.execute("""
            SELECT p.comp_cd, c.comp_nm, p.unit_price,
                   COALESCE(p.dim_vals::text,''), COALESCE(p.proc_cd,''),
                   COALESCE(p.siz_cd,''), COALESCE(p.mat_cd,'')
              FROM t_prc_component_prices p
              JOIN t_prc_price_components c ON c.comp_cd = p.comp_cd
        """)
        rows = c.fetchall()
        c.execute("SELECT comp_cd, comp_nm, use_dims FROM t_prc_price_components")
        meta = {r[0]: (r[1], r[2]) for r in c.fetchall()}

    vals = defaultdict(set)
    dimnames = defaultdict(set)
    nrows = defaultdict(int)
    names = {}
    for comp, nm, price, dv, proc, siz, mat in rows:
        names[comp] = nm
        nrows[comp] += 1
        if price is None:
            continue
        vals[comp].add(Decimal(str(price)))
        tag = ""
        if dv and "줄수" in dv:
            tag = dv.split("줄수")[1].strip(' ":}') + "줄"
        elif dv and "개수" in dv:
            tag = dv.split("개수")[1].strip(' ":}') + "개"
        elif proc:
            tag = dn.get(proc, proc)
        for code in (proc, siz, mat):
            if code and code in dn:
                dimnames[comp].add(dn[code])
        if tag and not tag.startswith(("PROC_", "SIZ_", "MAT_")):
            dimnames[comp].add(tag)
    return vals, names, dimnames, nrows, meta


def _norm(s):
    return re.sub(r"[\s()（）\[\]/·,.\-_]+", "", str(s or ""))


def label_fit(col_labels, comp_dimnames):
    """열 라벨이 그 구성요소의 차원값 이름과 맞는 정도.

    [HARD] 정확 일치가 퍼지 일치를 언제나 이긴다 — 퍼지 점수를 0.5 로 상한한다.

      `name_sim` 은 문자 집합 Jaccard 라서 **거의 같은 한국어 이름을 못 가른다.**
      「무광코팅」 vs 「유광코팅」 은 4글자 중 3글자가 같아 0.6 이고, 종전 임계 0.5 를
      그냥 통과했다. 코팅 시트는 유광·무광 **단가가 완전히 동일**해(§7.4 은폐 요인)
      값으로도 안 갈리므로, 이 한 글자가 유일한 판별자다. 상한을 두지 않으면
      4열 전건이 COMP_COAT_MATTE 로 붙는다(실측).

      퍼지 항을 없애지는 않는다 — 「2단가로접지 / 2단세로접지」처럼 라벨과 공정명이
      표기만 다른 경우를 잡아야 하고, 그 케이스는 접지옵션에서 실측으로 확인된다.
    """
    if not comp_dimnames or not col_labels:
        return 0.0
    dn_norm = {_norm(d) for d in comp_dimnames}
    total = 0.0
    for lab in col_labels:
        flat = " ".join(lab) if isinstance(lab, (tuple, list)) else str(lab)
        parts = [x.strip() for x in re.split(r"[/·,>]", flat) if x.strip()]
        best = 0.0
        for p in parts:
            if _norm(p) in dn_norm:
                best = 1.0
                break
            for d in comp_dimnames:
                if name_sim(p, d) >= 0.5:
                    best = max(best, 0.5)
        total += best
    return total / len(col_labels)


def _q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


def scoped_discriminate(comps, col_label):
    """[HARD] 동점 판정 **앞에** 서는 스코프 판별 — 닫힌 소집합 안의 상대 비교.

    절대 임계(0.5)는 **열린 후보**용이다. 사이즈 641종·자재 707종을 상대로 이름을 맞출 때
    낮은 유사도는 신뢰할 수 없다. 그러나 스코프 토큰(`proc_grp`·`opt_grp`)이 후보를
    2~3종으로 좁힌 **닫힌 집합** 안에서는 사정이 다르다 — 최고점이 유일하고 여백이 있으면
    그것이 판별이다.

    실측 근거(코팅):
        「유광코팅」 vs 유광라미네이팅(GLOSSY 라이브 공정) = 0.375
        「유광코팅」 vs 무광라미네이팅(MATTE  라이브 공정) = 0.222
        → 여백 0.153 · 유일 최대 ⇒ GLOSSY
    두 구성요소는 값 집합이 완전히 동일해(`huni-product-lifecycle.md` §7.4 은폐 요인)
    값으로는 영원히 갈리지 않는다. 이 판별이 없으면 코팅 8열 전건이 동점 미성립이 된다.

    반환: 판별된 comp_cd, 또는 갈리지 않으면 None(추측하지 않는다).
    """
    flat = " ".join(col_label) if isinstance(col_label, (tuple, list)) else str(col_label)
    parts = [x.strip() for x in re.split(r"[/·,>]", flat) if x.strip()]
    if not parts:
        return None

    SCOPE_SRC = {"proc_grp:": ("proc_cd", "t_proc_processes", "proc_cd", "proc_nm"),
                 "opt_grp:": ("opt_cd", "t_prd_product_options", "opt_cd", "opt_nm")}
    scores = {}
    for comp in comps:
        row = _q("SELECT use_dims FROM t_prc_price_components WHERE comp_cd=%s", [comp])
        if not row:
            continue
        ud = row[0][0] or []
        if isinstance(ud, str):
            try:
                ud = json.loads(ud)
            except Exception:
                ud = []
        best = 0.0
        for tok in ud:
            if not isinstance(tok, str):
                continue
            for pref, (col, tbl, key, nmcol) in SCOPE_SRC.items():
                if not tok.startswith(pref):
                    continue
                nms = [r[0] for r in _q(
                    f"""SELECT DISTINCT m.{nmcol} FROM t_prc_component_prices p
                        JOIN {tbl} m ON m.{key} = p.{col}
                        WHERE p.comp_cd=%s AND p.{col} IS NOT NULL""", [comp]) if r[0]]
                for nm in nms:
                    for p in parts:
                        best = max(best, name_sim(p, nm))
        scores[comp] = best

    if not scores:
        return None
    ranked = sorted(scores.items(), key=lambda x: -x[1])
    if len(ranked) == 1:
        return ranked[0][0] if ranked[0][1] > 0 else None
    top, second = ranked[0], ranked[1]
    if top[1] > 0 and (top[1] - second[1]) >= 0.05:
        return top[0]
    return None


def pair_blocks(only_sheet=None):
    """블록의 각 열을 구성요소에 짝짓고, 블록 단위로 다시 합친다.

    반환:
      per_col   [(block, col_label, comp_cd|None, score, overlap, n_cells)]
      unmapped  짝이 서지 않은 (block, col_label, 사유)
    """
    blocks = [b for b in m3_l1.load_blocks(only_sheet) if b.sheet not in SKIP_SHEETS]
    lv, names, dimnames, nrows, meta = live_components()

    per_col, unmapped = [], []
    for b in blocks:
        if not b.matrix:
            unmapped.append((b, None, "수치셀 0 — 기하 %s" % b.geometry))
            continue
        if DISCOUNT_TITLE.search(b.title or ""):
            unmapped.append((b, None, "구간할인 표 — 단가표가 아니다(할인 테이블 계열). 범위 밖"))
            continue
        cells_by_col = defaultdict(list)
        for rl, cl, v, ref in b.matrix:
            cells_by_col[cl].append((rl, v, ref))

        bvals = b.values          # 블록 전체 값 집합 — Jaccard 는 이 위에서 잰다(아래 사유)
        for cl, cells in cells_by_col.items():
            tvals = {v for _, v, _ in cells}
            cand = []
            for comp, s in lv.items():
                if not s:
                    continue
                # ov  — 이 **열**의 값이 그 구성요소에 있는 비율. 열 단위 동일성을 잡는다.
                ov = len(tvals & s) / len(tvals)
                # jac — **블록** 값 집합과의 Jaccard.
                #   [실측된 실패] 열 값 집합으로 재면 억제력을 잃는다. 열 하나는 값이 9개뿐이라
                #   어떤 구성요소와도 Jaccard 가 작아 크기 편향을 누르지 못하고,
                #   COMP_STK_PRINT(라이브 5,424행)가 아크릴 B03·B05 의 열을 겹침 1.00 으로
                #   흡수했다. 블록 단위로 재면 81 vs 5,424 라 그 흡수가 즉시 꺼진다.
                #   table_diff.py 가 표 단위였을 때 이 항이 작동한 이유가 이것이다.
                jac = len(bvals & s) / len(bvals | s)
                # fit — **그 열 자신의** 라벨이 구성요소의 차원값 이름과 맞는가.
                #   [실측된 실패] 블록 전체 열 라벨로 재면 열마다 같은 값이 나와 판별력이 0 이다.
                #   코팅 B01 은 유광·무광 단가가 완전히 동일해 값으로는 갈리지 않고
                #   밴드 라벨(「유광코팅 > 단면」)만이 유일한 판별자인데, 블록 단위 fit 은
                #   그 신호를 지워 4열 전건이 COMP_COAT_MATTE 로 붙었다.
                fit = label_fit([cl], dimnames.get(comp, set()))
                nsim = name_sim(b.title, names.get(comp, ""))
                cand.append((0.45 * ov + 0.20 * jac + 0.25 * fit + 0.10 * nsim, comp))
            cand.sort(reverse=True)
            if not cand:
                unmapped.append((b, cl, "라이브 구성요소 없음"))
                continue
            score, best = cand[0]
            ovr = len(tvals & lv[best]) / len(tvals)
            if ovr < MIN_OVERLAP:
                unmapped.append((b, cl, "최고 겹침 %.2f < %.2f — 근사 매칭을 확정으로 올리지 않는다"
                                 % (ovr, MIN_OVERLAP)))
                continue
            # [HARD] 동점이면 배정하지 않는다 — 미성립을 미성립으로 남긴다(REQ-PG-011).
            #   다만 그 앞에 **스코프 판별**을 한 번 세운다. 스코프 토큰이 후보를 닫힌
            #   소집합으로 좁힌 경우에는 절대 임계 미만의 유사도도 상대 비교로 판별이 된다.
            tied = [c for s, c in cand if score - s < AMBIG_MARGIN]
            if len(tied) > 1:
                picked = scoped_discriminate(tied, cl)
                if picked:
                    per_col.append((b, cl, picked, score, ovr, len(cells)))
                    continue
                unmapped.append((b, cl, "동점 후보 %d개(여백 %.3f 미만): %s — 스코프 판별도 갈리지 않음"
                                 % (len(tied), AMBIG_MARGIN, " / ".join(tied[:4]))))
                continue
            per_col.append((b, cl, best, score, ovr, len(cells)))
    return per_col, unmapped, names, nrows, meta


def invert(per_col):
    """열 단위 짝짓기를 뒤집어 구성요소 → 하위표(1:N) 로 만든다."""
    comp2blocks = defaultdict(lambda: defaultdict(lambda: {"cells": 0, "cols": [],
                                                           "ovr": 0.0, "score": 0.0}))
    for b, cl, comp, score, ovr, n in per_col:
        slot = comp2blocks[comp][b.key()]
        slot["block"] = b
        slot["cells"] += n
        slot["cols"].append(cl)
        slot["ovr"] = max(slot["ovr"], ovr)
        slot["score"] = max(slot["score"], score)
    return comp2blocks


GOLDEN = {"COMP_ACRYL_CLEAR3T": 277, "COMP_ACRYL_MIRROR3T": 81, "COMP_ACRYL_COROTTO": 36}


def main():
    ap = argparse.ArgumentParser(description="구성요소 ↔ 권위 하위표 매핑 (1:N)")
    ap.add_argument("--sheet")
    ap.add_argument("--comp", help="한 구성요소만 자세히")
    ap.add_argument("--csv")
    ap.add_argument("--unresolved-csv", help="미성립 목록을 CSV 로 저장 (M3 산출 3)")
    a = ap.parse_args()

    per_col, unmapped, names, nrows, meta = pair_blocks(a.sheet)
    comp2blocks = invert(per_col)

    print("열 단위 짝짓기 %d건 → 구성요소 %d개 · 미성립 %d건"
          % (len(per_col), len(comp2blocks), len(unmapped)))
    print("=" * 96)

    if a.comp:
        comps = [a.comp]
    else:
        comps = sorted(comp2blocks, key=lambda c: -sum(v["cells"] for v in comp2blocks[c].values()))

    for comp in comps:
        slots = comp2blocks.get(comp)
        if not slots:
            print("  %s — 짝지어진 하위표 없음" % comp)
            continue
        tot = sum(v["cells"] for v in slots.values())
        live = nrows.get(comp, 0)
        mark = ""
        if comp in GOLDEN:
            mark = "  [골든 기준선 %d · 라이브 %d]" % (GOLDEN[comp], live)
        print("\n%s  %s" % (comp, names.get(comp, "")))
        print("  권위 셀 %d · 라이브 행 %d · use_dims=%s%s"
              % (tot, live, meta.get(comp, (None, None))[1], mark))
        for k, v in sorted(slots.items(), key=lambda x: -x[1]["cells"]):
            b = v["block"]
            print("    %-14s %-4s %-46s %4d셀 (열 %d · 겹침 %.2f · 점수 %.2f) %s"
                  % (b.sheet, b.block_id, b.title[:46], v["cells"], len(v["cols"]),
                     v["ovr"], v["score"], b.geometry))
        if a.comp:
            break

    if not a.comp:
        print("\n" + "=" * 96)
        print("[미성립] %d건 — 삭제하지 않고 남긴다 (REQ-PG-011)" % len(unmapped))
        for b, cl, why in unmapped[:40]:
            lab = " > ".join(cl) if isinstance(cl, tuple) else (cl or "(표 전체)")
            print("  %-12s %-4s %-34s %-22s %s"
                  % (b.sheet, b.block_id, b.title[:34], lab[:22], why))
        if len(unmapped) > 40:
            print("  ... 외 %d건" % (len(unmapped) - 40))

    if a.csv:
        with open(a.csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["comp_cd", "comp_nm", "use_dims", "live_rows",
                        "sheet", "block_id", "block_title", "geometry",
                        "cells", "n_cols", "overlap", "score"])
            for comp, slots in comp2blocks.items():
                for k, v in slots.items():
                    b = v["block"]
                    w.writerow([comp, names.get(comp, ""), meta.get(comp, ("", ""))[1],
                                nrows.get(comp, 0), b.sheet, b.block_id, b.title,
                                b.geometry, v["cells"], len(v["cols"]),
                                "%.3f" % v["ovr"], "%.3f" % v["score"]])
        print("\n→ %s" % a.csv)

    if a.unresolved_csv:
        # M3 산출 3 — 미성립 목록. 삭제하지 않고 사유와 함께 남긴다(REQ-PG-011).
        with open(a.unresolved_csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["sheet", "block_id", "block_title", "geometry", "col_label",
                        "n_cells", "reason_class", "reason"])
            for b, cl, why in unmapped:
                lab = " > ".join(cl) if isinstance(cl, tuple) else (cl or "")
                if why.startswith("구간할인"):
                    cls = "out-of-scope-discount"
                elif why.startswith("동점"):
                    cls = "ambiguous-tie"
                elif why.startswith("수치셀 0"):
                    cls = "geometry-unresolved"
                elif why.startswith("최고 겹침"):
                    cls = "below-overlap-threshold"
                else:
                    cls = "other"
                w.writerow([b.sheet, b.block_id, b.title, b.geometry, lab,
                            b.cell_count, cls, why])
        print("→ %s (미성립 %d건)" % (a.unresolved_csv, len(unmapped)))


if __name__ == "__main__":
    main()
