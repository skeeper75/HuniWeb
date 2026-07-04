"""가격엔진 매칭 — pricing.py 의 순수 매칭 함수를 verbatim 이식(드리프트 0).

승계: _foundation/remediation/_gate_harness.py 1-88줄. 원본의 아크릴 전용 하드코딩
(/tmp/*.json 로드·상품 스윕)은 제거하고 재사용 가능한 순수 함수만 남겼다.

용도: 적대적 독립 재실측(생성≠검증). 교정 전/후 단가행을 pricing.py 와 동일 로직으로
매칭·재계산해 골든 재현·silent 합산(ERR_AMBIGUOUS)·차원 커버리지를 배치가 스스로 검증한다.

★[HARD] 이 로직은 라이브 pricing.py 와 verbatim 이어야 한다. pricing.py 변경 시 재이식.
근거: pricing.py:42(NON_QTY_DIMS)·:94(_row_matches)·:110(_combo_key)·:134(match_component).
"""
import json
from decimal import Decimal

NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "clr_cd", "coat_side_cnt", "bdl_qty")
TIER_DIMS = ("siz_width", "siz_height", "min_qty")
TIER_UPPER = ("siz_width", "siz_height")
ERR_ABOVE_MAX = "above_max_size"
ERR_BELOW_MIN = "below_min_qty"
ERR_AMBIGUOUS = "ambiguous"
ERR_DUPLICATE = "duplicate"


def _norm(v):
    return None if v is None else str(v)


def _dv_key(row):
    return json.dumps(row.get("dim_vals") or {}, sort_keys=True, ensure_ascii=False)


def _row_matches(row, selections):
    """행의 모든 비수량 차원이 선택값과 매칭되면 True(행 차원 NULL=와일드카드).
    행 dim_vals(공정 상세 파라미터)가 있으면 그 키들도 일치해야 한다(와일드카드 없음)."""
    for d in NON_QTY_DIMS:
        rv = row.get(d)
        if rv is None:
            continue
        if _norm(selections.get(d)) != _norm(rv):
            return False
    for k, v in (row.get("dim_vals") or {}).items():
        if _norm(selections.get(k)) != _norm(v):
            return False
    return True


def _combo_key(row):
    return tuple(_norm(row.get(d)) for d in NON_QTY_DIMS) + (_dv_key(row),)


def _tier_val(v, upper=False):
    if v in (None, ""):
        return Decimal("Infinity") if upper else Decimal(0)
    return Decimal(str(v))


def _tier_order_val(dim, selections, qty):
    if dim == "min_qty":
        return Decimal(qty)
    v = selections.get(dim)
    if v in (None, ""):
        return None
    try:
        return Decimal(str(v))
    except Exception:
        return None


def match_component(rows, selections, qty, as_of):
    """한 구성요소의 단가행 목록에서 선택값·수량에 맞는 단일 행을 고른다.
    반환 dict: {row, error, ...}. error=ERR_AMBIGUOUS 면 동시매칭(silent 합산 위험).

    ★단가행 dict 는 값이 문자열(스냅샷 CSV)이든 원시형(DB)이든 무관하게 동작한다
    (_norm 이 문자열화). 단, NULL 은 빈 문자열이 아니라 None 이어야 와일드카드로 취급된다
    — CSV 로더는 빈칸을 '' 로 주므로 Snapshot 이 '' → None 정규화를 책임진다.
    """
    cand = [r for r in rows
            if (r.get("apply_ymd") or "") <= as_of and _row_matches(r, selections)]
    if not cand:
        return {"row": None, "error": None, "reason": "no_match"}
    combos = {}
    for r in cand:
        combos.setdefault(_combo_key(r), []).append(r)
    if len(combos) > 1:
        return {"row": None, "error": ERR_AMBIGUOUS, "combos": list(combos.keys())}
    grp = next(iter(combos.values()))
    selected = {}
    for dim in TIER_DIMS:
        upper = dim in TIER_UPPER
        ov = _tier_order_val(dim, selections, qty)
        cmp_val = ov if ov is not None else Decimal(0)
        tiers = sorted({_tier_val(r.get(dim), upper) for r in grp})
        if upper:
            eligible = [t for t in tiers if t >= cmp_val]
            if not eligible:
                return {"row": None, "error": ERR_ABOVE_MAX, "max_allowed": str(max(tiers)), "above_dim": dim}
            selected[dim] = min(eligible)
        else:
            eligible = [t for t in tiers if t <= cmp_val]
            if not eligible:
                return {"row": None, "error": ERR_BELOW_MIN, "min_required": str(min(tiers)), "below_dim": dim}
            selected[dim] = max(eligible)
    tier_rows = [r for r in grp
                 if all(_tier_val(r.get(d), d in TIER_UPPER) == selected[d] for d in TIER_DIMS)]
    if not tier_rows:
        return {"row": None, "error": None, "reason": "no_tier_row",
                "selected_w": str(selected["siz_width"]), "selected_h": str(selected["siz_height"])}
    best = max(tier_rows, key=lambda r: r.get("apply_ymd") or "")
    same = [r for r in tier_rows if (r.get("apply_ymd") or "") == (best.get("apply_ymd") or "")]
    if len(same) > 1:
        return {"row": None, "error": ERR_DUPLICATE}
    return {"row": best, "error": None}
