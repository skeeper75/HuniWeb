#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
가격공식(E9)·가격구성요소(E10) 노드 블록 생성기 — Huni-Ontology-KB Phase 3.

배선(formula→component)과 구성요소 메타(prc_typ·use_dims)는 라이브 스냅샷에서 뽑은
캐시(transcribed-260703.json)를 그대로 옮긴다(LLM 손전사 금지·D-9). 산출 = axis형 블록
markdown 2파일을 03_kb/formula/ 에 기록.
"""
import json, os

HERE = os.path.dirname(__file__)
CACHE = os.path.join(HERE, "cache", "transcribed-260703.json")
KB = os.path.abspath(os.path.join(HERE, "../../03_kb/formula"))
SNAP = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

FRM_META = {
    "PRF_DGP_A": ("원자합산형A 엽서·상품권·슬로건", "원자합산형", "016 프리미엄엽서·041 스탠다드 쿠폰/상품권 바인딩"),
    "PRF_DGP_B": ("원자합산형B 모양엽서·라벨택", "원자합산형", "046 라벨/택 바인딩·완칼 커팅"),
    "PRF_DGP_C": ("원자합산형C 인쇄배경지·헤더택", "원자합산형", "043 인쇄배경지(OPP봉투타입) 바인딩·접지+타공"),
    "PRF_DGP_D": ("원자합산형D 소량전단지", "원자합산형", "047 소량전단지(디지털 인접) 바인딩"),
    "PRF_DGP_E": ("원자합산형E 접지카드·접지리플렛", "원자합산형", "027 2단접지카드 바인딩(국4절/3절)"),
    "PRF_DGP_F": ("원자합산형F 썬캡(미출시)", "원자합산형", "미출시·구조 참조용"),
    "PRF_NAMECARD_COAT": ("코팅명함 고정가(용지포함)", "고정가", "032 코팅명함 바인딩·배선교정 이력"),
    "PRF_NAMECARD_FIXED": ("스탠다드명함 고정가(용지포함)", "고정가", "033 스탠다드명함 바인딩"),
    "PRF_PHOTOCARD_NORMAL": ("포토카드 고정가(세트/대량)", "고정가", "024 포토카드 바인딩"),
}
COMP_ROLE = {
    "COMP_PRINT_DIGITAL_S1": "디지털 base 인쇄비(PROC_000004 매칭·미바인딩=인쇄비0)",
    "COMP_PRINT_SPOT_WHITE_S1": "통합별색인쇄비(5별색×단면양면 통합·개별 CLEAR/GOLD use=N)",
    "COMP_PAPER": "용지비(종이별 절가·plt_siz_cd×mat_cd)",
    "COMP_CUT_FULL_DIECUT": "완칼 커팅(die-cut)·.03 고정 교정(이중적용 과대청구 해소)",
    "COMP_PP_CORNER_RIGHT": "귀돌이(모서리 라운딩)·.03 고정 교정(×수량 과대청구 해소)",
}


def load():
    with open(CACHE, encoding="utf-8") as f:
        return json.load(f)


def gen_components(d):
    # 전 공식 union 구성요소
    comps = {}
    for rows in d["wiring"].values():
        for r in rows:
            comps[r["comp_cd"]] = r
    out = [
        "<!-- axis page: E10 price_component — 디지털 파일럿 공식이 배선하는 가격구성요소(마스터 t_prc_price_components). -->",
        "<!-- ★생성=_meta/scripts/gen_formula_nodes.py(캐시 전사). use_dims=가격 차원 선언(D-18 경계)·값 계산은 evaluate_price 권위. -->",
        "",
        "# 축: 가격구성요소 (price_component)",
        "",
        "공식의 부품. use_dims = 이 구성요소 가격이 어떤 축으로 달라지는가(차원 선언)까지만 —",
        "**가격 값 계산은 evaluate_price 단일 권위**(온톨로지 밖). 단가행(t_prc_component_prices)은",
        "노드로 펼치지 않고 여기 속성으로 접는다(D-22). 공식→구성요소 배선은 R9 `has_component`.",
        "",
        f"<!-- transcribed-by: _meta/scripts/gen_formula_nodes.py from {SNAP} t_prc_price_components @ {STAMP} -->",
        "",
    ]
    for cc in sorted(comps):
        r = comps[cc]
        role = COMP_ROLE.get(cc, "")
        out.append(f"### [component-{cc}] {r['comp_nm']} {{verified}}")
        out.append(f"- type: price_component")
        out.append(f"- anchor: t_prc_price_components/{cc}")
        out.append(f'- src: {{source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:{cc}", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}}')
        prop = f'{{prc_typ_cd: "{r["prc_typ_cd"]}", use_dims: \'{r["use_dims"]}\''
        if role:
            prop += f', role: "{role}"'
        prop += "}"
        out.append(f"- props: {prop}")
        out.append("")
    return "\n".join(out)


def gen_formulas(d):
    out = [
        "<!-- axis page: E9 price_formula — 디지털 파일럿 가격공식(마스터 t_prc_price_formulas). -->",
        "<!-- ★생성=_meta/scripts/gen_formula_nodes.py. has_component 배선=t_prc_formula_components 전사(disp_seq·addtn 한정자). -->",
        "",
        "# 축: 가격공식 (price_formula)",
        "",
        "디지털 = 원자합산형(인쇄비+용지비+공정비) + 명함/포토카드 고정가. 공식→구성요소 배선(R9",
        "`has_component`)은 아래 relations. addtn(가산 여부)·disp_seq는 배선 엣지 한정자(구성요소",
        "속성 아님·F-4). **값 계산은 evaluate_price 권위**(D-18). 상품→공식(R8 `priced_by`)은 상품 노드(Phase 4).",
        "",
        f"<!-- transcribed-by: _meta/scripts/gen_formula_nodes.py from {SNAP} t_prc_formula_components @ {STAMP} -->",
        "",
    ]
    for frm in FRM_META:
        rows = d["wiring"].get(frm, [])
        nm, arche, note = FRM_META[frm]
        out.append(f"### [formula-{frm}] {nm} {{verified}}")
        out.append(f"- type: price_formula")
        out.append(f"- anchor: t_prc_price_formulas/{frm}")
        out.append(f'- src: {{source_file: "live-snapshot/latest/t_prc_formula_components.csv", source_locator: "frm_cd:{frm}", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}}')
        for r in rows:
            q = []
            if r["disp_seq"] != "":
                q.append(f'disp_seq: {r["disp_seq"]}')
            if r["addtn_yn"]:
                q.append(f'addtn: {r["addtn_yn"]}')
            ql = (", qualifier: {" + ", ".join(q) + "}") if q else ""
            out.append(f'- rel: {{rel: has_component, target: component-{r["comp_cd"]}{ql}}}')
        out.append(f'- props: {{archetype: "{arche}", note: "{note}"}}')
        out.append("")
    return "\n".join(out)


if __name__ == "__main__":
    d = load()
    os.makedirs(KB, exist_ok=True)
    with open(os.path.join(KB, "digital-components.md"), "w", encoding="utf-8") as f:
        f.write(gen_components(d) + "\n")
    with open(os.path.join(KB, "digital-formulas.md"), "w", encoding="utf-8") as f:
        f.write(gen_formulas(d) + "\n")
    print("wrote digital-components.md + digital-formulas.md")
