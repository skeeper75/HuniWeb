#!/usr/bin/env python
"""상품군별 인쇄소 배정 검토표 (09_vendor-sourcing-policy.md 실현·v1).

지니 정책: 소비자는 벤더 비교 안 봄 → 이 표는 **지니의 내부 소싱 결정 도구**.
상품군마다 [능력 · 후니 원가 · 와우 원가 · 표준납기]를 나란히, 후니 기본 + 전환 신호 표시.
★원가 = 부가세 전 공급가(후니 evaluate_price·와우 ordcost_sup) → 공정 비교(A-1 basis 정합).
★배정 3층: 1층 능력(못 만들면 탈락)·2층 납기(v1 표준·미수집)·3층 경제성(후니 기본·균형).
값=엔진(지어내기 0). 스펙 미대표(auto-pick 극단) 후니가는 ⚠ 표시(스펙 정규화 후속).

실행: raw/.venv/bin/python _workspace/printly/data/_scripts/sourcing_table.py
"""
import os, sys, json, glob

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from crossbrand_query import (  # 후니 견적·basis·게이트 판정 재사용
    huni_price, family_verdict, WOW_DIR, DATA)

CAFE_FAMILIES = {"명함", "스티커", "엽서·카드", "전단", "사인·실사", "매장용품/탁상POP", "쿠폰·상품권"}
OUT = os.path.join(DATA, "sourcing", "cafe-sourcing-table-260705.md")

# 후니 auto-pick 극단사이즈(비대표) 판정: 와우 공급가 대비 N배↑ = 스펙 정규화 필요 신호
ARTIFACT_RATIO = 8


def wow_supply(recipe):
    """와우 대표 샘플 부가세 전 공급가(ordcost_sup). 없으면 청구가/1.1 도출(flag)."""
    lp = recipe["recipe"]["가격구성요소"].get("live_price_samples", {})
    samp = lp.get("samples", [])
    if not samp:
        return None, None, None, ""
    s = samp[0]
    sup = s.get("ordcost_sup")
    derived = False
    if sup is None and s.get("ordcost_bill"):
        sup = round(s["ordcost_bill"] / 1.1)  # 부가세 10% 정의관계로 도출
        derived = True
    return sup, s.get("qty", 1), lp.get("spec", ""), ("↩도출" if derived else "")


def assign(fam, huni_can, huni_sup, huni_artifact, wow_sup, verdict_kind):
    """배정 추천(3층). 반환 (배정, 사유). 최종 선택=지니(신호만 제공)."""
    if not huni_can:
        return "와우", "후니 미대응(1층 능력) → 연결 벤더 중 와우 강제"
    if verdict_kind == "NO_GO":
        return "후니(기본)", "★와우 데이터 불신(same_family 앵커 결함·재앵커 필요) → 후니 유지"
    if huni_sup is None:
        return "후니(기본)·⚠", "후니 견적 불가(대표사양 미확정) → 스펙 정규화 후 재판정"
    if huni_artifact:
        return "후니(기본)·⚠", "후니가=auto-pick 극단사이즈(비대표) → 스펙 정규화 후 재판정"
    # 둘 다 신뢰 가능 → 후니 기본, 와우 원가 유의미 저가면 검토 신호
    if wow_sup and wow_sup < huni_sup * 0.7:
        gap = round((1 - wow_sup / huni_sup) * 100)
        return "후니(기본)+와우 검토", f"와우 원가 {gap}% 저(방향 신호·스펙 정합 확인 전) → 마진 관점 와우 검토(최종 지니)"
    return "후니(기본)", "후니 공동사업 기본·원가차 유의미하지 않음(스펙 정합 확인 전)"


def main():
    recipes = {}
    for f in sorted(glob.glob(os.path.join(WOW_DIR, "*.json"))):
        r = json.load(open(f, encoding="utf-8"))
        fam = r["후니_교차"]["same_family_as"]["family"].split(" (")[0]
        if fam in CAFE_FAMILIES:
            recipes[fam] = r

    rows = []
    for fam, r in recipes.items():
        sfa = r["후니_교차"]["same_family_as"]
        verdict = family_verdict(sfa["family"])
        vkind = verdict.get("verdict", "GO")
        wname = r["product"]["name"]
        wsup, wqty, wspec, wderiv = wow_supply(r)
        huni_list = sfa.get("huni_products", [])
        huni_can = bool(huni_list)
        hname = huni_list[0]["name"] if huni_can else "(대응 없음)"
        hsup = huni_price(huni_list[0]["prd_cd"], wqty) if (huni_can and wqty) else None
        hsup = hsup or None  # 0원=깨진 견적 → None(견적불가) 정규화
        artifact = bool(hsup and wsup and hsup > wsup * ARTIFACT_RATIO)
        배정, 사유 = assign(fam, huni_can, hsup, artifact, wsup, vkind)
        rows.append({
            "fam": sfa["family"], "qty": wqty, "unit": r["product"].get("unit", "매"),
            "hname": hname, "hsup": hsup, "artifact": artifact,
            "wname": wname, "wsup": wsup, "wspec": wspec, "wderiv": wderiv,
            "배정": 배정, "사유": 사유, "vkind": vkind,
        })

    # ── 콘솔 + 마크다운 동시 출력 ──
    def fmt(v, art=False):
        if v is None:
            return "견적불가"
        return f"{v:,}원" + (" ⚠" if art else "")

    md = ["# 카페 상품군 인쇄소 배정 검토표 (v1 · 2026-07-05)",
          "",
          "> 09_vendor-sourcing-policy.md 실현. **지니 내부 소싱 결정 도구**(소비자 비노출).",
          "> 원가=부가세 전 공급가(후니 evaluate_price·와우 ordcost_sup·A-1 basis 정합). 값=엔진(지어내기 0).",
          "> ⚠=후니 auto-pick 극단사이즈(비대표)·스펙 정규화 후속 필요. ↩도출=와우 청구가/1.1.",
          "> 배정=후니 공동사업 기본, 전환 신호만 제공·**최종 선택=지니**.",
          "",
          "| 상품군 | 수량 | 능력(후니/와우) | 후니 원가(공급가) | 와우 원가(공급가) | 표준납기 | 추천 배정 | 사유 |",
          "|---|---|---|---|---|---|---|---|"]
    print("=" * 100)
    print("카페 상품군 인쇄소 배정 검토표 (v1) — 지니 내부 소싱 도구 · 원가=부가세 전 공급가")
    print("=" * 100)
    for r in rows:
        huni_cap = "✓" if not r["hname"].startswith("(") else "✗"
        wow_cap = "⚠재앵커" if r["vkind"] == "NO_GO" else "✓"
        h = fmt(r["hsup"], r["artifact"])
        w = fmt(r["wsup"]) + (f' {r["wderiv"]}' if r["wderiv"] else "")
        md.append(f'| {r["fam"]} | {r["qty"]}{r["unit"]} | {huni_cap}/{wow_cap} | {h} | {w} | 수집예정 | **{r["배정"]}** | {r["사유"]} |')
        print(f'\n▶ [{r["fam"]}] {r["qty"]}{r["unit"]}  능력 후니{huni_cap}/와우{wow_cap}')
        print(f'    후니 {r["hname"]:<16} {h:>14}')
        print(f'    와우 {r["wname"]:<16} {w:>14}   [{r["wspec"]}]')
        print(f'    → 배정: {r["배정"]}  ({r["사유"]})')

    md += ["",
           "## 범례·주의",
           "- **원가 = 부가세 전 공급가**(둘 다). 소비자가 = 원가 + 지니 마진율(+부가세)는 별도 정책.",
           "- **표준납기 미수집**(후니 모델 납기 필드 없음·와우 exitday 미캡처) → v1 수집 후속. v2=API/MCP 실시간.",
           "- **⚠ 후니 원가**: auto-pick `.first()`가 극단사이즈 선택(스티커·현수막). 대표사양 고정 후 재판정 필요.",
           "- **와우 재앵커(쿠폰)**: same_family 앵커=행택(결함)·현 샘플 스펙 불신 → 40110 재앵커 후 유효.",
           "- 배정은 **후니 공동사업 기본**. '와우 검토'=원가차 30%+ 신호(마진 관점)·최종 판단 지니.",
           ""]
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write("\n".join(md))
    print(f"\n{'-'*100}\n표 저장: {os.path.relpath(OUT, DATA)}  (마크다운·지니 열람용)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
