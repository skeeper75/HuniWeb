# _pricing_pure.py — pricing.py 순수함수 격리 추출(라인 33~37 import + 64~196 헬퍼). 검증 전용·verbatim.
from __future__ import annotations
import json
from decimal import Decimal, ROUND_HALF_UP, InvalidOperation

NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "coat_side_cnt", "bdl_qty")

# 구간(티어) 차원 — 정확매칭 아님. NON_QTY_DIMS 와 배타. 방향이 둘로 갈린다:
#  - min_qty(수량): '이상' 하한. 행 적용조건 qty ≥ min_qty, 적용행 중 '최대' 임계(높은 구간). NULL=0.
#  - siz_width/siz_height(사이즈 mm): '이하' 상한. 행 적용조건 값 ≤ 임계, 적용행 중 '최소' 임계
#    (그 값을 담는 가장 작은 구간). 값이 구간 넘으면 다음(더 큰) 구간. NULL=∞(상한없음=catch-all).
TIER_DIMS = ("siz_width", "siz_height", "min_qty")
TIER_UPPER = ("siz_width", "siz_height")   # '이하' 상한 방향. 그 외(min_qty)는 '이상' 하한.

PRC_TYPE_UNIT = "PRICE_TYPE.01"   # 단가형 = 장당가
PRC_TYPE_TOTAL = "PRICE_TYPE.02"  # 합가형 = 구간 총액
DSC_TYPE_RATE = "DSC_TYPE.01"     # 정률
DSC_TYPE_AMT = "DSC_TYPE.02"      # 정액

# match_component 오류 코드
ERR_AMBIGUOUS = "ambiguous_combo"   # 비수량 차원조합 2개 이상 동시 매칭(데이터 오류)
ERR_DUPLICATE = "duplicate_rows"    # 동일 (조합·구간·적용일) 행 중복(데이터 오류)
ERR_BELOW_MIN = "below_min_qty"     # 주문수량 < 최소 구간(계산불가)
ERR_ABOVE_MAX = "above_max_size"    # 주문 사이즈 > 최대 구간(상한 초과, 다음 구간 미정의)


# ---------------------------------------------------------------------------
# 순수 헬퍼 (ORM 비의존 — 테스트 직접 호출)
# ---------------------------------------------------------------------------
def round_won(value) -> int:
    """원 단위 반올림(ROUND_HALF_UP)."""
    return int(Decimal(value).quantize(Decimal("1"), rounding=ROUND_HALF_UP))


def _norm(v):
    """차원 값 비교용 정규화 — 코드/정수 혼재를 문자열로 통일. NULL→None."""
    return None if v is None else str(v)


def _dv_key(row):
    """행 dim_vals(공정 상세 파라미터)의 정규화 키 — None/{} 는 '{}'."""
    return json.dumps(row.get("dim_vals") or {}, sort_keys=True, ensure_ascii=False)


def _row_matches(row, selections) -> bool:
    """행의 모든 비수량 차원이 선택값과 매칭되면 True. 행 차원이 NULL이면 와일드카드.
    행 dim_vals(공정 상세 파라미터)가 있으면 그 키들도 선택값과 일치해야 한다(파라미터는 와일드카드 없음)."""
    for d in NON_QTY_DIMS:
        rv = row.get(d)
        if rv is None:
            continue  # 와일드카드 — 어떤 선택값이든 통과
        if _norm(selections.get(d)) != _norm(rv):
            return False
    for k, v in (row.get("dim_vals") or {}).items():
        if _norm(selections.get(k)) != _norm(v):
            return False
    return True


def _combo_key(row):
    """비수량 차원조합 키(동시매칭 판정용) — dim_vals 포함(공정 상세별 별개 조합)."""
    return tuple(_norm(row.get(d)) for d in NON_QTY_DIMS) + (_dv_key(row),)


def _tier_val(v, upper=False):
    """행의 구간 임계값 → Decimal. NULL/'' → 상한차원은 ∞(상한없음 catch-all), 하한차원은 0."""
    if v in (None, ""):
        return Decimal("Infinity") if upper else Decimal(0)
    return Decimal(str(v))


def _tier_order_val(dim, selections, qty):
    """구간 차원의 주문값(Decimal). min_qty=수량, 그 외=선택값(소수). 미제공/파싱불가 → None."""
    if dim == "min_qty":
        return Decimal(qty)
    v = selections.get(dim)
    if v in (None, ""):
        return None
    try:
        return Decimal(str(v))
    except (InvalidOperation, ValueError):
        return None


def match_component(rows, selections, qty, as_of):
    """한 구성요소의 단가행 목록에서 선택값·수량에 맞는 단일 행을 고른다.

    rows: dict 목록(apply_ymd, NON_QTY_DIMS, min_qty, unit_price, comp_price_id…).
    반환: {"row": dict|None, "tier_min_qty": int, "error": None|코드, ...진단필드}.
      - error=None, row!=None → 정상 매칭
      - error=None, row=None  → 매칭 0건(미선택/해당없음)
      - error=코드 → 데이터 오류 또는 최소수량 미달
    """
    cand = [r for r in rows
            if (r.get("apply_ymd") or "") <= as_of and _row_matches(r, selections)]
    if not cand:
        return {"row": None, "tier_min_qty": None, "error": None, "reason": "no_match"}

    # 비수량 차원조합별 그룹 — 2개 이상이면 동시매칭(데이터 오류)
    combos = {}
    for r in cand:
        combos.setdefault(_combo_key(r), []).append(r)
    if len(combos) > 1:
        return {"row": None, "tier_min_qty": None, "error": ERR_AMBIGUOUS,
                "combos": list(combos.keys()), "rows": cand}

    grp = next(iter(combos.values()))
    # 구간 차원(min_qty·사이즈가로/세로): 축마다 '주문값 이하 최대 임계값(이상)' 선택.
    # NULL 임계값 = 0(하한 없음). 주문값 미제공 축은 0으로 비교(0-임계 행만 적격).
    selected = {}
    for dim in TIER_DIMS:
        upper = dim in TIER_UPPER
        ov = _tier_order_val(dim, selections, qty)
        cmp_val = ov if ov is not None else Decimal(0)
        tiers = sorted({_tier_val(r.get(dim), upper) for r in grp})
        if upper:
            # 사이즈: 값 이하 구간 = '주문값 이상' 임계 중 최소(가장 작은 구간). 넘으면 다음 구간.
            eligible = [t for t in tiers if t >= cmp_val]
            if not eligible:
                return {"row": None, "tier_min_qty": None, "error": ERR_ABOVE_MAX,
                        "max_allowed": max(tiers), "above_dim": dim, "rows": grp}
            selected[dim] = min(eligible)
        else:
            # 수량: '주문값 이하' 임계 중 최대(높은 구간).
            eligible = [t for t in tiers if t <= cmp_val]
            if not eligible:
                return {"row": None, "tier_min_qty": None, "error": ERR_BELOW_MIN,
                        "min_required": min(tiers), "below_dim": dim, "rows": grp}
            selected[dim] = max(eligible)
    tier_rows = [r for r in grp
                 if all(_tier_val(r.get(d), d in TIER_UPPER) == selected[d] for d in TIER_DIMS)]
    if not tier_rows:
        # 희소 그리드 — 선택된 티어 조합에 해당하는 행이 없음(데이터 갭). 매칭 없음.
        return {"row": None, "tier_min_qty": selected["min_qty"], "error": None,
                "reason": "no_tier_row"}
    # 시계열: 같은 (조합·구간) 내 최신 apply_ymd
    best = max(tier_rows, key=lambda r: r.get("apply_ymd") or "")
    same = [r for r in tier_rows if (r.get("apply_ymd") or "") == (best.get("apply_ymd") or "")]
    if len(same) > 1:
        return {"row": None, "tier_min_qty": selected["min_qty"], "error": ERR_DUPLICATE, "rows": same}
    return {"row": best, "tier_min_qty": selected["min_qty"], "error": None}


def component_subtotal(prc_typ, unit_price, tier_min_qty, qty):
    """구성요소 소계(Decimal) + 장당가(Decimal) 반환.

    단가형: unit_price(장당가) × 수량.
    합가형: unit_price(구간 총액) ÷ 구간 min_qty = 장당가, × 수량.
    """
    up = Decimal(unit_price)
    q = Decimal(qty)
    if prc_typ == PRC_TYPE_TOTAL:
        base = tier_min_qty or 0
        if base <= 0:
            raise ValueError("합가형 단가행에 수량구간(min_qty)이 없어 장당가 환산 불가")
        per_item = up / Decimal(base)
        return per_item * q, per_item
    # 기본 = 단가형
    return up * q, up
