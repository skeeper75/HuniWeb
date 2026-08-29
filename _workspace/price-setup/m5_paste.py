"""M5 — 신뢰 등급으로 거른 뒤 붙여넣기 표를 낸다 · 읽기전용.

`SPEC-PRICEGRID-001` §5.1 ③. M1 이 만든 분모 중 **번역이 검증된 것만** 실무진에게 준다.

[HARD] 왜 거르는가 — M1 의 누락 3,385칸을 그대로 주면 안 된다.
       상당수가 「분모가 틀려서 생긴 누락」이다. 스티커 실재율 31% · 강판인쇄 0% ·
       프리미엄명함 0% 는 번역이 아직 그 구성요소를 못 읽는다는 뜻이지,
       라이브에 그만큼 빠졌다는 뜻이 아니다. 잘못된 표를 주면 실무진이
       **없어야 할 행을 등록**하게 된다.

등급 판정 — 라이브가 분모를 검증해 주는 정도로 나눈다:

    A 신뢰   잉여 0  AND  실재율 ≥ 90%
             → 분모가 라이브 행을 **전부 설명**하고(잉여 0), 분모의 90% 이상이 실재한다.
               남은 누락은 진짜 빈칸으로 볼 수 있다. **실무진에게 준다.**
    B 보류   둘 중 하나만 만족
    C 블로커 둘 다 불만족 → 번역 결함 신호. **주지 않는다.**

    [HARD] 잉여 0 이 A 의 필수 조건인 이유 — 잉여는 「라이브에 있는데 분모가 설명 못 하는 행」이다.
    그것이 있다는 것은 분모가 그 구성요소의 격자 모양을 아직 못 맞췄다는 직접 증거다.
    실재율만 높고 잉여가 크면(예: 디지털인쇄 73% · 잉여 392) 분모는 여전히 틀렸다.

[HARD] 값이 권위에 없으면 **칸을 비운다.** 0 으로 채우지 않는다(REQ-PG-006 · 무료 ≠ 0원).
[HARD] 잉여 행을 삭제 대상으로 제안하지 않는다(P-2).
[HARD] 라이브 쓰기 0건. 이 모듈은 TSV 를 쓸 뿐이다(REQ-PG-008).

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m5_paste.py
  raw/webadmin/.venv/bin/python _workspace/price-setup/m5_paste.py --tsv out-paste/
"""
import argparse
import csv
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import m1_grid          # noqa: E402  (django.setup 은 m1_grid 가 수행)
import m2_product       # noqa: E402

MIN_RATE = 90           # A 등급 실재율 문턱(%)


def grade(r):
    """구성요소 하나의 신뢰 등급. 반환 (등급, 실재율, 사유)."""
    den = len(r["merged"])
    pres, ext = len(r["present"]), len(r["extra"])
    rate = (100 * pres // den) if den else 0
    if ext == 0 and rate >= MIN_RATE:
        return "A", rate, "잉여 0 · 실재율 %d%%" % rate
    if ext == 0:
        return "B", rate, "잉여 0 이나 실재율 %d%% < %d%%" % (rate, MIN_RATE)
    if rate >= MIN_RATE:
        return "B", rate, "실재율 %d%% 이나 잉여 %d행 — 분모가 라이브를 다 설명 못 함" % (rate, ext)
    return "C", rate, "실재율 %d%% · 잉여 %d행 — 번역 결함 신호" % (rate, ext)


def main():
    ap = argparse.ArgumentParser(description="M5 — 신뢰 등급 필터 + 붙여넣기 표")
    ap.add_argument("--tsv", help="붙여넣기 TSV 를 이 디렉터리에 쓴다")
    ap.add_argument("--comp")
    a = ap.parse_args()

    results = m1_grid.run(a.comp)

    A, B, C = [], [], []
    for r in results:
        g, rate, why = grade(r)
        r["_grade"], r["_rate"], r["_why"] = g, rate, why
        (A if g == "A" else B if g == "B" else C).append(r)

    def miss(rs):
        return sum(len(x["missing"]) for x in rs)

    print("신뢰 등급 필터 — 구성요소 %d종" % len(results))
    print("=" * 96)
    print(f"  A 신뢰   {len(A):3d}종 · 누락 {miss(A):5d}칸   ← 붙여넣기 표를 낸다")
    print(f"  B 보류   {len(B):3d}종 · 누락 {miss(B):5d}칸")
    print(f"  C 블로커 {len(C):3d}종 · 누락 {miss(C):5d}칸   ← 내지 않는다")
    print("=" * 96)

    print("\n[A 신뢰 — 붙여넣을 행이 있는 구성요소]")
    total_rows = 0
    for r in sorted(A, key=lambda x: -len(x["missing"])):
        if not r["missing"]:
            continue
        g = m2_product.grid_contract(r["comp"])
        filled = sum(1 for k in r["missing"] if r["merged"][k].auth_value is not None)
        print(f"  {r['comp']:30s} {str(r['comp_nm'])[:16]:18s} 누락 {len(r['missing']):3d}칸"
              f" · 권위값 있음 {filled} · 공란 {len(r['missing'])-filled}   ({r['_why']})")
        print(f"      헤더: {' | '.join(g['header'])}")
        total_rows += len(r["missing"])

        if a.tsv:
            os.makedirs(a.tsv, exist_ok=True)
            path = os.path.join(a.tsv, f"{r['comp']}.tsv")
            with open(path, "w", encoding="utf-8-sig", newline="") as fh:
                w = csv.writer(fh, delimiter="\t")
                w.writerow(g["header"])
                for k in r["missing"]:
                    el = r["merged"][k]
                    sheet, bid, labels = el.prov[0]
                    note = "권위 %s %s %s" % (sheet, bid, el.auth_ref or "")
                    if el.auth_value is None:
                        note += " · 권위값 없음 — 실무진 확정 대기"
                    row = [""]                       # 적용일 — 실무진이 정한다
                    for c in g["cols"]:
                        row.append(el.vals.get(c["name"], "") if c["kind"] != "param" else "")
                    row.append(el.auth_value if el.auth_value is not None else "")
                    row.append(note)
                    w.writerow(row)
            print(f"      → {path}")

    print(f"\n  A 등급 붙여넣기 행 합계: {total_rows}행")

    print("\n[B 보류]")
    for r in sorted(B, key=lambda x: -len(x["missing"])):
        if r["missing"] or r["extra"]:
            print(f"  {r['comp']:30s} 누락 {len(r['missing']):4d} · 잉여 {len(r['extra']):4d}"
                  f"   {r['_why']}")

    print("\n[C 블로커 — 번역이 아직 이 구성요소를 못 읽는다. 표를 내지 않는다]")
    for r in sorted(C, key=lambda x: -len(x["missing"])):
        print(f"  {r['comp']:30s} 분모 {len(r['merged']):5d} · 실재 {len(r['present']):5d}"
              f" · 누락 {len(r['missing']):5d} · 잉여 {len(r['extra']):5d}   {r['_why']}")


if __name__ == "__main__":
    main()
