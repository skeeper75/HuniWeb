#!/usr/bin/env python3
# evaluate_trace.py — RC-2 일반현수막 옵션 가산 종단 재계산 (엔진 순수함수 재현·ORM 비의존)
# pricing.py의 match_component/_row_matches/component_subtotal을 라이브 단가행(설계후 충전) 입력으로
# 직접 호출해, 옵션 선택별 가산이 정확한지/미선택 0가산/ERR 0을 입증한다. 단가 verbatim.
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
import _pricing_pure as PR   # pricing.py 순수함수 verbatim 격리(Django 비의존)

AS_OF = "2026-12-31"

# ── 설계후 단가행(충전된 opt_cd/proc_cd/dim_vals) — 라이브 verbatim 단가 ─────────────
# 각 comp의 rows = match_component 입력 형태(dict 목록).
ROWS = {
    "PUNCH_4": [  # proc_cd=PROC_000105 + dim_vals 타공수 (이미 라이브 충전)
        {"apply_ymd": "2026-06-01", "proc_cd": "PROC_000105", "opt_cd": None, "siz_cd": None,
         "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None,
         "bdl_qty": None, "siz_width": None, "siz_height": None, "min_qty": 1,
         "dim_vals": {"타공수": 4}, "unit_price": 3000},
        {"apply_ymd": "2026-06-01", "proc_cd": "PROC_000105", "opt_cd": None, "siz_cd": None,
         "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None,
         "bdl_qty": None, "siz_width": None, "siz_height": None, "min_qty": 1,
         "dim_vals": {"타공수": 6}, "unit_price": 4000},
        {"apply_ymd": "2026-06-01", "proc_cd": "PROC_000105", "opt_cd": None, "siz_cd": None,
         "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None,
         "bdl_qty": None, "siz_width": None, "siz_height": None, "min_qty": 1,
         "dim_vals": {"타공수": 8}, "unit_price": 8000},
    ],
    "CUTEDGE":  [{"apply_ymd": "2026-06-01", "opt_cd": "OPV_000006", "proc_cd": None, "siz_cd": None,
        "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None, "bdl_qty": None,
        "siz_width": None, "siz_height": None, "min_qty": None, "dim_vals": None, "unit_price": 3000}],
    "DTAPE":    [{"apply_ymd": "2026-06-01", "opt_cd": "OPV_000010", "proc_cd": None, "siz_cd": None,
        "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None, "bdl_qty": None,
        "siz_width": None, "siz_height": None, "min_qty": None, "dim_vals": None, "unit_price": 3000}],
    "BONGSEW":  [{"apply_ymd": "2026-06-01", "opt_cd": "OPV_000011", "proc_cd": None, "siz_cd": None,
        "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None, "bdl_qty": None,
        "siz_width": None, "siz_height": None, "min_qty": None, "dim_vals": None, "unit_price": 4000}],
    "QBANG":    [{"apply_ymd": "2026-06-01", "opt_cd": "OPV_000013", "proc_cd": None, "siz_cd": None,
        "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None, "bdl_qty": None,
        "siz_width": None, "siz_height": None, "min_qty": None, "dim_vals": None, "unit_price": 3000}],
    "STRING":   [{"apply_ymd": "2026-06-01", "opt_cd": "OPV_000014", "proc_cd": None, "siz_cd": None,
        "plt_siz_cd": None, "print_opt_cd": None, "mat_cd": None, "coat_side_cnt": None, "bdl_qty": None,
        "siz_width": None, "siz_height": None, "min_qty": None, "dim_vals": None, "unit_price": 4000}],
}
# 비교용 — 현재(결함) 단가행: opt_cd/proc_cd 전부 NULL (always-match)
ROWS_CURRENT = {k: [dict(r, opt_cd=None, proc_cd=None, dim_vals=None) for r in v] for k, v in ROWS.items()}


def addon_subtotal(rows, selections, qty=1):
    """한 옵션 comp의 가산액. 단가형(PRICE_TYPE.01) 가정·qty=1. 미매칭=0."""
    m = PR.match_component(rows, selections, qty, AS_OF)
    if m["error"]:
        return None, m["error"]
    if m["row"] is None:
        return 0, None  # 미선택/해당없음 → 0가산
    sub, per = PR.component_subtotal(PR.PRC_TYPE_UNIT, m["row"]["unit_price"], m["tier_min_qty"], qty)
    return int(sub), None


def case(label, rows_set, selections):
    total = 0
    errs = []
    detail = []
    for name, rows in rows_set.items():
        amt, err = addon_subtotal(rows, selections)
        if err:
            errs.append(f"{name}:{err}")
        elif amt:
            detail.append(f"{name}+{amt}")
            total += amt
    estr = f" ERR[{','.join(errs)}]" if errs else " ERR0"
    print(f"  {label:42s} 가산={total:6d}  [{' '.join(detail) or '없음'}]{estr}")
    return total, errs


print("=== RC-2 일반현수막 옵션 가산 종단 재계산 (qty=1·단가형) ===\n")

print("[현재=결함] 단가행 opt_cd/proc_cd 전부 NULL → always-add:")
case("ⓐ 옵션 미선택(아무 selection 없음)", ROWS_CURRENT, {})

print("\n[설계후] 단가행 opt_cd/proc_cd 충전:")
case("ⓐ 옵션 미선택 → 가공 0가산(본체만)", ROWS, {})
case("ⓑ 타공4 선택 → +3000만", ROWS, {"proc_cd": "PROC_000105", "타공수": 4})
case("   타공6 선택 → +4000", ROWS, {"proc_cd": "PROC_000105", "타공수": 6})
case("   타공8 선택 → +8000", ROWS, {"proc_cd": "PROC_000105", "타공수": 8})
case("ⓒ 끈 선택 → +4000만", ROWS, {"opt_cd": "OPV_000014"})
case("   봉미싱 선택 → +4000만", ROWS, {"opt_cd": "OPV_000011"})
case("   큐방 선택 → +3000만", ROWS, {"opt_cd": "OPV_000013"})
case("   열재단 선택 → +3000만", ROWS, {"opt_cd": "OPV_000006"})
case("   양면테입 선택 → +3000만", ROWS, {"opt_cd": "OPV_000010"})
# ⓓ 동시 여러 옵션: 가공그룹 타공4(proc 경로) + 추가그룹 끈(opt 경로) 동시선택.
#    실엔진 _evaluate_formula는 proc 차원 comp는 proc_sels로, opt 차원 comp는 selections로 각각 매칭.
#    → 한 selections dict에 proc_cd+타공수(가공)와 opt_cd(추가)가 공존 = 서로 다른 차원키라 충돌 없음.
print("\n[ⓓ 동시선택] 가공그룹 타공4(proc) + 추가그룹 끈(opt) — 각 comp 자기 차원으로 매칭:")
case("ⓓ 타공4+끈 동시 → +3000(타공)+4000(끈)=7000", ROWS,
     {"proc_cd": "PROC_000105", "타공수": 4, "opt_cd": "OPV_000014"})
case("   봉미싱(가공)+큐방(추가) 동시 → +4000+3000=7000", ROWS,
     {"opt_cd": "OPV_000011"})  # ⚠ 한계 아래 주석
print("  ⚠ 가공·추가가 둘 다 opt_cd 경로(봉미싱+큐방)면 한 selections에 opt_cd 단일키 한계로 동시 표현 불가.")
print("     실엔진은 옵션그룹별 selection 키(예 opt_cd__가공/opt_cd__추가) 분리가 필요 → 코드 트랙 BLOCKED.")
print("     타공(proc 경로)+추가옵션(opt 경로) 조합은 차원키가 달라 동시 정확(위 ⓓ 7000 입증).")
print("\n  ※ 각목 LE/GT (현재·BLOCKED): 둘 다 차원 NULL → always-add 이중합산 재현:")
gak = {"LE": [{"apply_ymd":"2026-06-01","opt_cd":None,"proc_cd":None,"siz_cd":None,"plt_siz_cd":None,
        "print_opt_cd":None,"mat_cd":None,"coat_side_cnt":None,"bdl_qty":None,"siz_width":None,
        "siz_height":None,"min_qty":None,"dim_vals":None,"unit_price":4000}],
       "GT": [{"apply_ymd":"2026-06-01","opt_cd":None,"proc_cd":None,"siz_cd":None,"plt_siz_cd":None,
        "print_opt_cd":None,"mat_cd":None,"coat_side_cnt":None,"bdl_qty":None,"siz_width":None,
        "siz_height":None,"min_qty":None,"dim_vals":None,"unit_price":8000}]}
case("각목 현재(아무 주문) → LE4000+GT8000=12000 이중", gak, {})
