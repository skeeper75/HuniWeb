"""M6 — 소형박 단가행의 공정코드를 대형박(033) 계열 → 소형박(153) 계열로 옮기는
붙여넣기 TSV 를 만든다 · 읽기전용.

배경(2026-08-30 실측):
  2026-08-12 08:13:27 에 `PROC_000033` 이 「박」→「대형박」으로 개명되고 같은 시각
  `PROC_000153` 「소형박」이 신설됐다. 프리미엄명함·펄명함은 소형이라 소형박(154~164)에
  연결됐으나, **단가행과 use_dims 스코프는 대형박(037~049) 계열에 남았다.**
  그 결과 위젯이 보내는 `PROC_000155`(소형박 금유광)가 단가행의 `PROC_000038`
  (대형박 금유광)과 매칭되지 않아 박 비용이 통째로 0원이 된다.

  화면 실측: 프리미엄명함 금유광·20x20·수량200 → 9,000원(완제품가만).
             대조군 2단접지카드(033 계열)는 박 4줄이 정상 표시된다.

[HARD] 이 모듈은 TSV 를 쓸 뿐이다. 라이브 쓰기 0건.
[HARD] 실제 반영은 webadmin 단가편집 화면 붙여넣기로 한다(도메인룰 §7.2 — 추적성).
[HARD] 값은 현행 단가행을 그대로 옮긴다. 금액을 새로 만들지 않는다.

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m6_foilfix.py
  raw/webadmin/.venv/bin/python _workspace/price-setup/m6_foilfix.py --tsv out-foilfix/
"""
import argparse
import csv
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import m1_grid          # noqa: E402  (django.setup 은 m1_grid 가 수행)
import m2_product       # noqa: E402

# 이름이 같은 색상끼리의 1:1 대응. 대형박(033 하위) → 소형박(153 하위).
# 근거: t_proc_processes.proc_nm 동일 · upr_proc_cd 만 다름(실측 2026-08-30).
MAP = {
    "PROC_000037": "PROC_000154",   # 홀로그램박
    "PROC_000038": "PROC_000155",   # 금유광
    "PROC_000039": "PROC_000156",   # 은유광
    "PROC_000040": "PROC_000157",   # 먹유광
    "PROC_000041": "PROC_000158",   # 동박
    "PROC_000042": "PROC_000159",   # 적박
    "PROC_000043": "PROC_000160",   # 청박
    "PROC_000044": "PROC_000161",   # 트윙클박
    "PROC_000047": "PROC_000162",   # 녹박
    "PROC_000048": "PROC_000163",   # 금무광
    "PROC_000049": "PROC_000164",   # 은무광
}

TARGETS = ["COMP_FOIL_SETUP_SMALL", "COMP_FOIL_PROC_SMALL_STD",
           "COMP_FOIL_PROC_SMALL_SPECIAL"]


def rows_of(comp, dims, params):
    """현행 단가행 전건 — 그리드 컬럼 순서 그대로."""
    cols = ", ".join(dims)
    out = []
    for r in m1_grid._q(
            f"SELECT apply_ymd, {cols}, dim_vals, unit_price, note "
            f"FROM t_prc_component_prices WHERE comp_cd=%s "
            f"ORDER BY apply_ymd, {cols}", [comp]):
        ymd = r[0]
        vals = dict(zip(dims, r[1:1 + len(dims)]))
        dv = m1_grid._as_dict(r[1 + len(dims)])
        out.append({"ymd": ymd, "vals": vals, "dv": dv,
                    "price": r[-2], "note": r[-1] or ""})
    return out


def main():
    ap = argparse.ArgumentParser(description="M6 — 소형박 공정코드 이관 붙여넣기 표")
    ap.add_argument("--tsv", help="붙여넣기 TSV 를 이 디렉터리에 쓴다")
    a = ap.parse_args()

    print("소형박 공정코드 이관 — 대형박(PROC_000033) → 소형박(PROC_000153)")
    print("=" * 92)
    for comp in TARGETS:
        g = m2_product.grid_contract(comp)
        if not g:
            print(f"  {comp}: 구성요소 없음 — 건너뜀")
            continue
        dims, params = g["dims"], g["param_keys"]
        rows = rows_of(comp, dims, params)
        seen, unmapped = {}, set()
        for r in rows:
            p = r["vals"].get("proc_cd")
            if p in MAP:
                seen[p] = seen.get(p, 0) + 1
            elif p:
                unmapped.add(p)
        print(f"\n  {comp}  ({g['comp_nm']})  {len(rows)}행")
        print(f"      use_dims 스코프: {g['scopes'] or '(없음)'}")
        print(f"      헤더: {' | '.join(g['header'])}")
        for p, n in sorted(seen.items()):
            print(f"      {p} → {MAP[p]}   {n}행")
        if unmapped:
            print(f"      ⚠ 대응표에 없는 공정: {sorted(unmapped)} — 그대로 둔다")

        if a.tsv:
            os.makedirs(a.tsv, exist_ok=True)
            path = os.path.join(a.tsv, f"{comp}.tsv")
            with open(path, "w", encoding="utf-8-sig", newline="") as fh:
                w = csv.writer(fh, delimiter="\t")
                w.writerow(g["header"])
                for r in rows:
                    line = [r["ymd"]]
                    for c in g["cols"]:
                        n = c["name"]
                        if c["kind"] == "param":
                            line.append(r["dv"].get(n, ""))
                        elif n == "proc_cd":
                            v = r["vals"].get(n)
                            line.append(MAP.get(v, v) or "")
                        else:
                            v = r["vals"].get(n)
                            line.append("" if v is None else v)
                    line.append(r["price"] if r["price"] is not None else "")
                    line.append(r["note"])
                    w.writerow(line)
            print(f"      → {path}")

    print("\n" + "=" * 92)
    print("  [HARD] 이 TSV 는 붙여넣기 후보다. 라이브 반영 전 인간 승인 필요.")
    print("  [HARD] 붙여넣기 전에 use_dims 의 proc_grp:PROC_000033 → PROC_000153 을 먼저 바꾼다.")
    print("  [HARD] 단가편집 저장은 full-sync — 전체 행을 한 번에 넣는다.")


if __name__ == "__main__":
    main()
