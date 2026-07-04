#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
component_merge_scan.py — 가격구성요소(comp) 병합 후보 결정론 스캐너
=====================================================================
목적: 같은 가격테이블 차원인데 별도 comp로 쪼개진 가격구성요소를 전수 탐지해
      "병합 후보 보드" 데이터를 산출한다. 읽기전용·DB 미접속·COMMIT 없음.
      (실 병합은 하지 않음 — 이 스크립트는 진단 보드 생성 전용)

입력(모두 live-snapshot latest CSV·읽기전용):
  t_prc_price_components.csv   comp 카탈로그(use_dims·use_yn 포함)
  t_prc_formula_components.csv 공식↔comp 배선(disp_seq·addtn_yn)
  t_prc_component_prices.csv   단가행 매트릭스(차원 컬럼 + unit_price)

[HARD] 병합/분리 기준 (memory: price-component-unify-vs-split-criterion-260630)
  - 한 상품 안 손님 선택(도수·수량·판형·인쇄면·소재) → 한 comp 안 차원으로 통합(병합).
  - 종류/상품 자체가 다름(제본종류 proc_cd·별색색상 clr_cd) → 별도 comp 유지(병합 금지).
    단 가격격자 verbatim 동일이면 유형 B 동형결합 dedup 후보.

핵심 통찰: 클러스터 키 = (배선 공식집합, use_dims 시그니처)가 이미 "같은 상품군"을
  가른다(STD=PRF_NAMECARD_FIXED, COAT=PRF_NAMECARD_COAT는 다른 클러스터). 따라서
  클러스터 내부의 disjoint 축은 구조상 '손님 선택 축'이다 — 단 proc_cd/clr_cd만 예외
  (같은 클러스터라도 종류를 나타낼 수 있어 [HARD] 가드 적용).

재실행: python3 component_merge_scan.py  (토큰0·결정론·순수 파일 읽기)
"""
import csv, json, os, sys
from collections import defaultdict

SNAP = os.environ.get(
    "HUNI_SNAP",
    "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest",
)

DIM_COLS = ["siz_cd", "clr_cd", "mat_cd", "coat_side_cnt", "bdl_qty", "min_qty",
            "proc_cd", "opt_cd", "print_opt_cd", "plt_siz_cd", "siz_width", "siz_height"]

# 손님-선택 축(클러스터 내 disjoint 시 유형 A 후보) vs 종류/상품 축([HARD] 가드)
CHOICE_AXES = {"print_opt_cd", "opt_cd", "coat_side_cnt", "siz_cd", "mat_cd",
               "plt_siz_cd", "siz_width", "siz_height", "bdl_qty"}
# 정본(canonical) 상품-선택 축: 이 중 하나가 varying 이어야 '한 상품 안 매트릭스'로 확신.
# opt_cd/bdl_qty 만 varying 이면 addon 품목 구분일 수 있어 REVIEW (예: 큐방 vs 끈).
CANONICAL_CHOICE = {"print_opt_cd", "mat_cd", "siz_cd", "coat_side_cnt", "plt_siz_cd"}
KIND_AXES = {"proc_cd", "clr_cd"}  # 종류/상품(제본종류·별색색상) — 병합 금지 가드


def load(name):
    with open(os.path.join(SNAP, name), newline="") as f:
        return list(csv.DictReader(f))


def parse_use_dims(raw):
    raw = (raw or "").strip()
    if not raw.startswith("["):
        return ()
    try:
        arr = json.loads(raw)
    except Exception:
        return ()
    # proc_grp:/opt_grp: 는 그룹-스코프 힌트 → 실 차원 컬럼만 남김
    return tuple(sorted(d for d in arr if ":" not in d))


def latest_rows(rows):
    """comp 단가행 중 최신 apply_ymd만."""
    if not rows:
        return []
    ymax = max(r["apply_ymd"] for r in rows)
    return [r for r in rows if r["apply_ymd"] == ymax]


def col_value_sets(rows):
    v = defaultdict(set)
    for r in rows:
        for c in DIM_COLS:
            if (r.get(c) or "").strip():
                v[c].add(r[c])
    return {c: frozenset(s) for c, s in v.items()}


def grid_signature(rows):
    """전체 격자 verbatim 시그니처: (차원튜플 -> unit_price) 정렬 집합."""
    sig = set()
    for r in rows:
        key = tuple((r.get(c) or "").strip() for c in DIM_COLS)
        sig.add(key + (str(r.get("unit_price") or "").strip(),))
    return frozenset(sig)


def common_prefix_group(comp_cds):
    """comp_cd 최장공통접두(_ 토큰 경계)로 sibling 여부 판정용."""
    toks = [c.split("_") for c in comp_cds]
    lcp = []
    for i in range(min(len(t) for t in toks)):
        col = {t[i] for t in toks}
        if len(col) == 1:
            lcp.append(next(iter(col)))
        else:
            break
    return "_".join(lcp)


def main():
    pc = load("t_prc_price_components.csv")
    fc = load("t_prc_formula_components.csv")
    cp = load("t_prc_component_prices.csv")

    comp = {r["comp_cd"]: r for r in pc}
    comp2frm = defaultdict(set)
    comp2addtn = defaultdict(set)
    comp2seq = defaultdict(set)
    for x in fc:
        comp2frm[x["comp_cd"]].add(x["frm_cd"])
        comp2addtn[x["comp_cd"]].add(x["addtn_yn"])
        comp2seq[x["comp_cd"]].add(x["disp_seq"])

    rows_by_comp = defaultdict(list)
    for r in cp:
        rows_by_comp[r["comp_cd"]].append(r)

    active = [c for c, r in comp.items() if r["use_yn"] == "Y"]
    retired = [c for c, r in comp.items() if r["use_yn"] != "Y"]

    # ---- 클러스터: (formula_set, use_dims_real) ----
    clusters = defaultdict(list)
    for c in active:
        key = (frozenset(comp2frm.get(c, frozenset())),
               parse_use_dims(comp[c]["use_dims"]))
        clusters[key].append(c)

    candidates = []   # 유형 A/B 후보
    legit = []        # 정당 분리(병합 금지)
    artifacts = []    # 비-sibling 조대키 아티팩트

    for (frm, udims), members in clusters.items():
        if len(members) < 2:
            continue
        members = sorted(members)

        # sibling 서브그룹핑: 축접미사 제거한 base 이름으로 묶음
        # (같은 클러스터라도 CAL_DESK vs PP_CORNER 처럼 다른 comp가 섞일 수 있음)
        # 최장공통접두가 'COMP' 또는 'COMP_PP' 등 너무 일반적이면 non-sibling.
        lcp = common_prefix_group(members)
        lcp_depth = len([t for t in lcp.split("_") if t])
        is_sibling_family = lcp_depth >= 2 and lcp not in ("COMP_PP",)

        # 각 comp 최신격자
        latest = {c: latest_rows(rows_by_comp.get(c, [])) for c in members}
        vsets = {c: col_value_sets(latest[c]) for c in members}
        gsig = {c: grid_signature(latest[c]) for c in members}

        # 축별 값집합 관계: varying(멤버간 값집합 상이) vs shared(전 멤버 동일·비어있지 않음)
        all_cols = set()
        for c in members:
            all_cols |= set(vsets[c].keys())
        varying_cols, shared_cols = set(), set()
        for col in all_cols:
            svals = [vsets[c].get(col, frozenset()) for c in members]
            nonempty = [s for s in svals if s]
            if not nonempty:
                continue
            if len(nonempty) == len(members) and all(s == nonempty[0] for s in nonempty):
                shared_cols.add(col)
            else:
                varying_cols.add(col)

        # 멤버별 split-space 좌표(varying 축값 집합의 튜플) — 고유 tiling 판정용
        combo = {c: tuple(tuple(sorted(vsets[c].get(col, frozenset())))
                          for col in sorted(varying_cols)) for c in members}
        unique_tiling = len(set(combo.values())) == len(members)
        # varying 축들이 서로 값영역 겹치지 않게 타일링하는가(멤버간 pairwise 교집합 0)
        disjoint_tiling = unique_tiling

        rec = dict(frm=sorted(frm), use_dims=list(udims), members=members,
                   lcp=lcp, split_cols=sorted(varying_cols),
                   shared_cols=sorted(shared_cols),
                   addtn=sorted({a for c in members for a in comp2addtn.get(c, set())}),
                   nrows={c: len(latest[c]) for c in members})

        # ---- 분류 ----
        # 유형 B: 전 comp 격자 verbatim 동일
        sigs = {gsig[c] for c in members}
        if len(sigs) == 1 and next(iter(sigs)):
            rec["type"] = "B"
            rec["reason"] = "전 comp 단가격자 verbatim 동일(동형결합 dedup)"
            candidates.append(rec)
            continue

        if not is_sibling_family:
            rec["type"] = "ARTIFACT"
            rec["reason"] = f"비-sibling(공통접두 '{lcp}' 과도 일반) — 조대키 아티팩트, 이질 comp 혼재"
            artifacts.append(rec)
            continue

        # [HARD] 가드: 종류/상품 축(proc_cd/clr_cd)이 varying → 병합 금지
        if varying_cols & KIND_AXES:
            rec["type"] = "LEGIT"
            rec["reason"] = (f"종류/상품 축 분리({sorted(varying_cols & KIND_AXES)}) — "
                             f"제본종류/접지종류/별색/박가공종류 등 별개, [HARD] 병합 금지")
            legit.append(rec)
            continue

        # 격자충돌 검사 + 엔진코드변경 판정(공통)
        merged, conflict = {}, False
        for c in members:
            for r in latest[c]:
                key = tuple((r.get(k) or "").strip() for k in DIM_COLS)
                up = str(r.get("unit_price") or "").strip()
                if key in merged and merged[key] != up:
                    conflict = True
                merged[key] = up
        rec["merge_conflict"] = conflict
        rec["engine_change"] = not (varying_cols <= set(udims))

        # 유형 A: varying 축이 전부 손님-선택 축 + 정본 상품축 포함 + 고유 타일링 + 충돌 없음
        if (varying_cols and varying_cols <= CHOICE_AXES
                and (varying_cols & CANONICAL_CHOICE)
                and disjoint_tiling and not conflict and not rec["engine_change"]):
            rec["type"] = "A"
            rec["reason"] = (f"손님선택 축 분리({sorted(varying_cols)})·공유축 동일·"
                             f"고유타일링·격자충돌 없음·축 use_dims 기존재")
            candidates.append(rec)
            continue

        # varying 이 opt_cd/bdl_qty 만(정본 상품축 없음): addon 품목 구분일 수 있어 판정 분기
        if varying_cols and varying_cols <= {"opt_cd", "bdl_qty"} and rec["addtn"] == ["Y"]:
            # 공유 상품격자 없음(shared ⊆ {min_qty}) → 서로 다른 addon 품목(큐방 vs 끈)
            if set(shared_cols) <= {"min_qty"}:
                rec["type"] = "LEGIT"
                rec["reason"] = ("정본 상품축 없이 opt_cd 만 분리 + 공유 상품격자 없음 "
                                 "→ 서로 다른 addon 품목(병합 금지)")
                legit.append(rec)
            else:
                rec["type"] = "REVIEW"
                rec["reason"] = ("opt_cd 만 분리(정본 상품축 없음)이나 상품격자 공유 "
                                 "→ 변이 vs addon 수동 판정")
                legit.append(rec)
            continue

        rec["type"] = "REVIEW"
        rec["reason"] = (f"varying={sorted(varying_cols)} shared={sorted(shared_cols)} "
                         f"타일링고유={unique_tiling} 충돌={conflict} — 수동 판정")
        legit.append(rec)

    # ---- 출력 ----
    def base_name(members):
        lcp = common_prefix_group(members)
        return lcp if lcp.startswith("COMP_") else "COMP_" + lcp

    print("=" * 78)
    print("가격구성요소 병합 후보 스캔 결과")
    print("=" * 78)
    print(f"전체 comp={len(comp)} | 활성(use_yn=Y)={len(active)} | 은퇴(use_yn=N)={len(retired)}")
    print(f"다중-멤버 클러스터={sum(1 for k,v in clusters.items() if len(v)>=2)}")
    typeA = [r for r in candidates if r['type'] == 'A']
    typeB = [r for r in candidates if r['type'] == 'B']
    print(f"유형 A(축 이중인코딩·병합)={len(typeA)} | 유형 B(동형결합 dedup)={len(typeB)}"
          f" | 정당분리={len(legit)} | 아티팩트={len(artifacts)}")
    print()

    print("### 유형 A 병합 후보 (손님선택 축 분리) ###")
    for r in sorted(typeA, key=lambda x: -len(x['members'])):
        print(f"\n[A] 정본명 {base_name(r['members'])}  (N={len(r['members'])}→1)")
        print(f"    배선공식: {r['frm']}")
        print(f"    use_dims: {r['use_dims']}")
        print(f"    분리축(disjoint): {r['split_cols']}  | 공유축: {r['shared_cols']}")
        print(f"    엔진코드변경: {'요' if r['engine_change'] else '불요'}"
              f"  | 격자충돌: {r.get('merge_conflict')}")
        for c in r['members']:
            print(f"      - {c}  (단가행 {r['nrows'][c]})")

    print("\n\n### 유형 B 동형결합 dedup 후보 ###")
    if not typeB:
        print("  (활성 comp 중 격자 verbatim 동일 클러스터 없음)")
    for r in typeB:
        print(f"[B] {r['members']} — {r['reason']}")

    print("\n\n### 정당 분리(병합 금지) ###")
    for r in legit:
        print(f"[{r['type']}] {base_name(r['members'])} split={r['split_cols']}"
              f" — {r['reason']}")
        print(f"      members={r['members']}")

    print("\n\n### 비-sibling 아티팩트(조대키·후보 아님) ###")
    for r in artifacts:
        print(f"[X] lcp='{r['lcp']}' n={len(r['members'])} split={r['split_cols']}"
              f" — {r['reason']}")

    print(f"\n\n### 은퇴(use_yn=N) comp {len(retired)}건 — 완료/레거시 별도집계 ###")
    for c in sorted(retired):
        print(f"    (N) {c}  | {comp[c]['comp_nm'][:40]}")


if __name__ == "__main__":
    main()
