#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""실무진 최근 편집(2026-06-28~07-01) 22개 상품 전수 무결성 스캔 — 폼보드형 미완성 편집 결함 검출.

폼보드(PRD_000129) 사고 재현 패턴 3종을 22개 상품 전체에 결정론으로 검사한다:
  A) sel_typ_cd 공백 — 옵션그룹에 선택방식(SEL_TYPE.01/.02)이 없으면 시뮬레이터/위젯에 노출 안 됨(sim-meta opt_groups 빈 배열).
  B) 참조 무단가 — 옵션아이템이 ref_dim_cd=.03(자재)/.04(공정)로 참조하는 mat_cd/proc_cd에
     그 상품이 물린 공식(formula)의 컴포넌트 단가행이 하나도 없으면(component_prices 0건) 선택해도 0원/미매칭.
  C) 배선 결손 — 그 상품 공식(formula_components)에 새 자재/공정 축을 판별하는 컴포넌트 자체가 없음
     (예: 자재별 차등가인데 comp의 use_dims에 mat_cd가 없어 전부 같은 값으로 뭉개짐).

v2(2026-07-02) — 5클러스터 실사 결과 드러난 두 false-positive 원인을 반영해 B/C 판정을 보강했다:
  ① 공정 부모/자식 계층(t_proc_processes.upr_proc_cd) — 옵션이 참조하는 proc_cd가 손님 메뉴용
     "부모" 노드(예: 오시=PROC_000029)이고 실제 단가행은 그 "자식"(예: PROC_000090)에 적재된
     경우가 있다(엔진이 proc_child_options로 부모→자식 해소). 자식 proc_cd 단가행도 매칭 후보로 인정.
  ② opt_cd 경로 배선 — 옵션이 ref_dim_cd=.03/.04(자재/공정)를 참조하더라도, 실제 가격 컴포넌트는
     mat_cd/proc_cd가 아니라 그 옵션 자신의 opt_cd로 매칭되도록 설계된 경우가 있다(예: 린넨 마감).
     이 경우 component_prices.opt_cd = 그 옵션의 opt_cd 인 행이 있으면 가격경로 존재로 인정.
  이 두 경로 중 하나라도 있으면 B/C 에서 결함으로 잡지 않는다(결함 은닉 아님 — 진짜 결함만 남김).

라이브 읽기전용 SELECT만. 결정론(같은 스냅샷 재실행 시 동일 결과). 실 교정 없음(검출까지).
"""
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lib_huni as L

L.load_env()

PRODUCTS = {
    "PRD_000016": "프리미엄엽서", "PRD_000017": "코팅엽서", "PRD_000018": "스탠다드엽서",
    "PRD_000019": "투명엽서", "PRD_000020": "화이트인쇄엽서", "PRD_000021": "핑크별색엽서",
    "PRD_000052": "반칼 자유형 스티커", "PRD_000053": "반칼 자유형 투명스티커",
    "PRD_000055": "낱장 자유형 스티커", "PRD_000058": "반칼원형스티커",
    "PRD_000027": "2단접지카드", "PRD_000030": "지그재그엽서",
    "PRD_000024": "포토카드", "PRD_000025": "투명포토카드", "PRD_000026": "종이슬로건",
    "PRD_000067": "타투스티커", "PRD_000031": "프리미엄명함",
    "PRD_000118": "아트프린트포스터", "PRD_000124": "린넨패브릭포스터",
    "PRD_000129": "폼보드", "PRD_000136": "PET배너", "PRD_000140": "무광시트커팅",
    "PRD_000143": "미러아크릴스티커",
}


def db_rows(sql):
    return L.db(sql, rows=True)


# 5클러스터 실사(design-*-260701.md)에서 이미 사람이 판정한 (prd_cd, ref_key1) 쌍.
# ★결함 은닉 아님 — total_defects 에서 빼되 별도 카테고리로 명시(wiring_scan.py legit_unused와 동형).
#   FREE_BY_DESIGN  : 권위(가격표260527/상품마스터260610)상 무료·완제품가 포함으로 확인됨. 조치 불필요.
#   CONFIRM_PENDING : 진짜 가격 갭이나 임의 단가 생성 금지 — 실무진 답변 대기(각 사유 note 참조).
FREE_BY_DESIGN = {
    ("PRD_000118", "MAT_000599"): "인화지 단일소재·base 가격에 이미 포함(표시만)",
    ("PRD_000118", "PROC_000115"): "코팅 priceV=0(권위 무료)",
    ("PRD_000118", "PROC_000116"): "코팅 priceV=0(권위 무료)",
    ("PRD_000129", "PROC_000116"): "완제품가[출력+코팅+가공 포함]에 코팅 포함(무료)",
    ("PRD_000129", "PROC_000135"): "완제품가 포함(실사가공 별도과금 아님, mat_cd 축이 진짜 가격축)",
    ("PRD_000136", "PROC_000135"): "완제품가 포함(4구타공 별도과금 아님)",
    ("PRD_000136", "PROC_000015"): "완제품가 포함(코팅 별도과금 아님, 거치대만 별도 addon)",
    ("PRD_000136", "PROC_000014"): "완제품가 포함(코팅 별도과금 아님, 거치대만 별도 addon)",
    ("PRD_000140", "MAT_000389"): "색상=외형(권위상 동일가·무료)",
    ("PRD_000140", "MAT_000388"): "색상=외형(권위상 동일가·무료)",
    ("PRD_000143", "MAT_000377"): "칼라(골드/실버)=외형 동일가(권위 확인)",
    ("PRD_000143", "MAT_000378"): "칼라(골드/실버)=외형 동일가(권위 확인)",
    ("PRD_000052", "PROC_000054"): "커팅방식(반칼자유형)=사이즈에 내재·비가격축(무조치)",
    ("PRD_000053", "PROC_000054"): "커팅방식(반칼자유형)=사이즈에 내재·비가격축(무조치)",
    ("PRD_000055", "PROC_000053"): "커팅방식(완칼자유형)=사이즈에 내재·비가격축(무조치)",
    ("PRD_000030", "PROC_000073"): "COMP_FOLD_CARD_6CR 이미 배선+발현(proc_cd 무판별 min_qty형)·라벨 스왑만 별건",
    ("PRD_000030", "PROC_000074"): "COMP_FOLD_CARD_6CR 이미 배선+발현(proc_cd 무판별 min_qty형)·라벨 스왑만 별건",
    # ── 260702 사장님 답변으로 무료 확정(권위 가격표 대조 완료) ──
    ("PRD_000024", "MAT_000082"): "포토카드 종이축=생산사양·권위 B10 단일고정가6000(자재차등 컬럼 자체 없음)·공식 미배선",
    ("PRD_000024", "PROC_000015"): "포토카드 코팅=무료(사장님 확인)·공식 미배선",
    ("PRD_000024", "PROC_000014"): "포토카드 코팅=무료(사장님 확인)·공식 미배선",
    ("PRD_000024", "PROC_000028"): "포토카드 모서리=생산사양·권위 단일고정가·공식 미배선",
    ("PRD_000024", "PROC_000027"): "포토카드 모서리=생산사양·권위 단일고정가·공식 미배선",
    ("PRD_000025", "MAT_000178"): "투명포토카드 종이축=생산사양·권위 B11 단일8500·공식 미배선",
    ("PRD_000025", "PROC_000028"): "투명포토카드 모서리=생산사양·공식 미배선",
    ("PRD_000025", "PROC_000027"): "투명포토카드 모서리=생산사양·공식 미배선",
    ("PRD_000053", "PROC_000008"): "화이트별색=스티커가격=시트가격(투명자재 mat그리드에 포함)·별도과금 아님",
}
# CONFIRM_PENDING: 260702 세션에 12건 전부 해소.
#   ① 포토카드/투명포토카드 8 + 화이트별색 1 = FREE_BY_DESIGN(위·권위 단일고정가/시트가격 확인)
#   ② 아트스티커611(052/058)·유포쿨코팅593(055) = 사이즈 재키잉 파손이 근본원인이었음.
#      실무진이 오늘 사이즈코드를 중복코드로 바꿔 정규코드(del_yn=Y)를 끔 → 전자재 견적0.
#      sticker-size-restore-260702-fix.sql 로 사이즈 복원 + 611/593 grp1단가(153) 클론 + A6=100x148 COMMIT.
#      webadmin 시뮬레이터 실화면 8/8 PRICE≠0 검증(052 A5 q100=520,000 골든일치·055 A4=4,000 B02일치).
CONFIRM_PENDING = {}


def classify(prd_cd, ref_key1):
    """(prd_cd, ref_key1) 이 이미 사람이 판정한 항목이면 (category, note) 반환, 아니면 None."""
    key = (prd_cd, ref_key1)
    if key in FREE_BY_DESIGN:
        return "FREE_BY_DESIGN", FREE_BY_DESIGN[key]
    if key in CONFIRM_PENDING:
        return "CONFIRM_PENDING", CONFIRM_PENDING[key]
    return None


def main():
    prd_list = "'" + "','".join(PRODUCTS.keys()) + "'"

    # A) sel_typ_cd 공백인 옵션그룹 (최근 편집 전수 — reg_dt 무관, 현재 상태 기준)
    sql_a = f"""
    SELECT prd_cd, opt_grp_cd, opt_grp_nm, mand_yn, sel_typ_cd, reg_dt
      FROM t_prd_product_option_groups
     WHERE prd_cd IN ({prd_list}) AND del_yn='N'
       AND (sel_typ_cd IS NULL OR sel_typ_cd = '')
     ORDER BY prd_cd, reg_dt
    """
    rows_a = db_rows(sql_a)

    # B) 자재/공정 참조 옵션아이템 중 그 상품 활성 공식의 컴포넌트에 매칭 단가행이 0건인 것.
    #    v2: 직접매칭 + ①자식proc_cd매칭(upr_proc_cd 1단계) + ②opt_cd경로매칭 을 모두 시도해
    #    셋 다 0일 때만 진짜 결함으로 잡는다(false-positive 가드).
    sql_b = f"""
    WITH prod_formula AS (
        SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas
        WHERE prd_cd IN ({prd_list})
    ),
    formula_comps AS (
        SELECT pf.prd_cd, fc.comp_cd
          FROM prod_formula pf
          JOIN t_prc_formula_components fc ON fc.frm_cd = pf.frm_cd
    ),
    opt_refs AS (
        SELECT oi.prd_cd, oi.opt_cd, oi.item_seq, oi.ref_dim_cd, oi.ref_key1, oi.ref_key2,
               o.opt_nm, og.opt_grp_nm
          FROM t_prd_product_option_items oi
          JOIN t_prd_product_options o ON o.prd_cd=oi.prd_cd AND o.opt_cd=oi.opt_cd
          JOIN t_prd_product_option_groups og ON og.prd_cd=oi.prd_cd AND og.opt_grp_cd=o.opt_grp_cd
         WHERE oi.prd_cd IN ({prd_list}) AND oi.del_yn='N'
           AND oi.ref_dim_cd IN ('OPT_REF_DIM.03','OPT_REF_DIM.04')
    )
    SELECT r.prd_cd, r.opt_grp_nm, r.opt_nm, r.ref_dim_cd, r.ref_key1,
           -- 직접매칭: mat_cd/proc_cd 그대로
           (SELECT count(*) FROM formula_comps fc
              JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
             WHERE fc.prd_cd = r.prd_cd
               AND ((r.ref_dim_cd='OPT_REF_DIM.03' AND cp.mat_cd = r.ref_key1)
                 OR (r.ref_dim_cd='OPT_REF_DIM.04' AND cp.proc_cd = r.ref_key1))
           )
           +
           -- ①자식 proc_cd 매칭: 참조코드가 부모(upr_proc_cd)인 자식 proc_cd 단가행
           (SELECT count(*) FROM formula_comps fc
              JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
              JOIN t_proc_processes child ON child.proc_cd = cp.proc_cd
             WHERE fc.prd_cd = r.prd_cd AND r.ref_dim_cd='OPT_REF_DIM.04'
               AND child.upr_proc_cd = r.ref_key1
           )
           +
           -- ②opt_cd 경로 매칭: 그 옵션 자신의 opt_cd로 매칭되는 단가행
           (SELECT count(*) FROM formula_comps fc
              JOIN t_prc_component_prices cp ON cp.comp_cd = fc.comp_cd
             WHERE fc.prd_cd = r.prd_cd AND cp.opt_cd = r.opt_cd
           ) AS matched_price_rows
      FROM opt_refs r
     ORDER BY r.prd_cd, r.opt_grp_nm
    """
    rows_b = db_rows(sql_b)
    rows_b_gap = [r for r in rows_b if int(r[-1]) == 0]

    # C) 상품 활성 공식에 mat_cd/proc_cd 또는 그 대체경로(opt_cd)를 use_dims 로 쓰는 컴포넌트가
    #    하나도 없는 경우(자재/공정별 차등가 옵션을 만들어놓고 엔진이 아예 그 축을 안 보는 근본 배선결손).
    #    v2: opt_cd 로 배선된 경우(린넨 마감형)는 유효한 대체경로로 인정.
    #    v2: 옵션아이템 단위로 뽑아 classify() 적용 — 그 축의 옵션이 전부 FREE_BY_DESIGN이면
    #        (가격에 영향 안 주는 게 권위상 정답) 축 자체가 없어도 결함 아님(product-level 판정 오류 가드).
    sql_c = f"""
    WITH prod_formula AS (
        SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas
        WHERE prd_cd IN ({prd_list})
    ),
    formula_dims AS (
        SELECT pf.prd_cd, pc.use_dims
          FROM prod_formula pf
          JOIN t_prc_formula_components fc ON fc.frm_cd = pf.frm_cd
          JOIN t_prc_price_components pc ON pc.comp_cd = fc.comp_cd
    ),
    dim_opts AS (
        SELECT oi.prd_cd, oi.opt_cd, oi.ref_dim_cd, oi.ref_key1,
               CASE oi.ref_dim_cd WHEN 'OPT_REF_DIM.03' THEN 'mat_cd' ELSE 'proc_cd' END AS dim_name
          FROM t_prd_product_option_items oi
         WHERE oi.prd_cd IN ({prd_list}) AND oi.del_yn='N'
           AND oi.ref_dim_cd IN ('OPT_REF_DIM.03','OPT_REF_DIM.04')
    )
    SELECT d.prd_cd, d.dim_name, d.ref_key1,
           EXISTS (SELECT 1 FROM formula_dims fd WHERE fd.prd_cd=d.prd_cd
                     AND (fd.use_dims::text LIKE '%' || d.dim_name || '%'
                       OR fd.use_dims::text LIKE '%opt_cd%')) AS has_wiring
      FROM dim_opts d
     ORDER BY d.prd_cd, d.dim_name
    """
    rows_c_raw = db_rows(sql_c)

    # C: (prd_cd, dim_name) 축 단위로 묶어 "배선 없는 옵션이 하나라도 classify() 안 된 진짜 갭인지" 판정.
    from collections import defaultdict
    c_axis = defaultdict(lambda: {"has_wiring": False, "unclassified_refs": [], "classified_refs": []})
    for prd_cd, dim_name, ref_key1, has_wiring in rows_c_raw:
        key = (prd_cd, dim_name)
        if has_wiring == "t":
            c_axis[key]["has_wiring"] = True
        cls = classify(prd_cd, ref_key1)
        if cls is None:
            c_axis[key]["unclassified_refs"].append(ref_key1)
        else:
            c_axis[key]["classified_refs"].append((ref_key1, cls[0]))
    rows_c = []
    for (prd_cd, dim_name), info in sorted(c_axis.items()):
        if info["has_wiring"]:
            continue  # 배선 있음 — C 대상 아님
        if not info["unclassified_refs"]:
            continue  # 배선은 없지만 그 축 옵션 전부 FREE_BY_DESIGN/CONFIRM_PENDING로 이미 판정됨
        rows_c.append((prd_cd, f"{dim_name} 옵션 있음, 어느 컴포넌트도 use_dims에 {dim_name}/opt_cd 없음 "
                                f"(미판정 참조: {', '.join(info['unclassified_refs'])})"))

    # B 를 진짜 결함 vs 이미 판정된(FREE_BY_DESIGN/CONFIRM_PENDING) 항목으로 분리
    b_real, b_free, b_confirm = [], [], []
    for r in rows_b_gap:
        prd_cd, opt_grp_nm, opt_nm, ref_dim_cd, ref_key1 = r[0], r[1], r[2], r[3], r[4]
        item = {"prd_cd": prd_cd, "prd_nm": PRODUCTS.get(prd_cd, prd_cd), "opt_grp_nm": opt_grp_nm,
                "opt_nm": opt_nm, "ref_dim_cd": ref_dim_cd, "ref_key1": ref_key1}
        cls = classify(prd_cd, ref_key1)
        if cls is None:
            b_real.append(item)
        elif cls[0] == "FREE_BY_DESIGN":
            b_free.append({**item, "note": cls[1]})
        else:
            b_confirm.append({**item, "note": cls[1]})

    out = {
        "scanned_products": PRODUCTS,
        "A_missing_sel_typ": [
            {"prd_cd": r[0], "prd_nm": PRODUCTS.get(r[0], r[0]), "opt_grp_cd": r[1],
             "opt_grp_nm": r[2], "mand_yn": r[3], "reg_dt": r[5]}
            for r in rows_a
        ],
        "B_unpriced_option_refs": b_real,
        "B_free_by_design": b_free,
        "B_confirm_pending": b_confirm,
        "C_missing_dim_wiring": [
            {"prd_cd": r[0], "prd_nm": PRODUCTS.get(r[0], r[0]), "issue": r[1]}
            for r in rows_c
        ],
    }
    out["summary"] = {
        "A_count": len(out["A_missing_sel_typ"]),
        "B_real_count": len(b_real),
        "B_free_count": len(b_free),
        "B_confirm_count": len(b_confirm),
        "C_count": len(out["C_missing_dim_wiring"]),
        "products_affected": len({r["prd_cd"] for r in out["A_missing_sel_typ"]}
                                  | {r["prd_cd"] for r in b_real}
                                  | {r["prd_cd"] for r in out["C_missing_dim_wiring"]}),
    }

    out_path = os.path.join(HERE, "wiring", "staff-edit-scan-260701.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=2)

    print(f"[staff_edit_scan] A(sel_typ 공백)={out['summary']['A_count']} "
          f"B_real(진짜 참조무단가)={out['summary']['B_real_count']} "
          f"B_free(무료판정·조치불요)={out['summary']['B_free_count']} "
          f"B_confirm(실무진 대기)={out['summary']['B_confirm_count']} "
          f"C(축배선결손)={out['summary']['C_count']} "
          f"영향상품(A+B_real+C 기준)={out['summary']['products_affected']}/22")
    print(f"  -> {out_path}")


if __name__ == "__main__":
    main()
