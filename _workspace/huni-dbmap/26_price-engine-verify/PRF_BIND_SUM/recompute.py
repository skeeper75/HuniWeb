#!/usr/bin/env python3
# PRF_BIND_SUM — 검증용 재계산기 (제본 합산형 4상품)
# round-18+ S3 G-CALC. 명세 = 11-CONTEXT(단가형/합가형·수량구간·시계열) + prcx01.
#
# [HARD] 보정 하드코딩 금지: 단가는 라이브 component_prices 조회 결과만 사용.
#        옵션→comp 멤버십은 "상품별 1고정"(제본방식이 상품마다 1개)으로 데이터 사실에 근거
#        (D-2 옵션 멤버십 추론 엔진 아님 — 책자 상품은 제본방식이 상품 정체로 결정됨).
#
# 제본비 comp = 단가형(PRICE_TYPE.01), use_dims=["min_qty"].
#   계산 = 매칭 수량구간(주문 권수 이하 최대 min_qty) unit_price × 주문 권수.
#   (가격표 헤더 "합가" 없음·권당가 단조감소 → ÷min_qty 환산 없는 순수 단가형.)
#
# 주의: 본 스크립트는 "제본비 구성요소 1항"만 재계산한다. PRF_BIND_SUM은 합산형의
#       제본비 항이며, 책자 완제품가 = 인쇄비 + 용지비 + 제본비 + ... 의 합.
#       다른 항(인쇄/용지/표지/코팅)은 본 클래스 범위 밖(별 comp). 제본비 항만 검증.
#
# 사슬 상태(S1): 공식엔 COMP_BIND_JUNGCHEOL만 배선. 무선/PUR/트윈링은 사슬 단절.
#       → 무선/PUR/트윈링은 "comp 단가행 직접 조회(공식 우회)"로 골든값만 검증하되
#         CHAIN_STATUS='BROKEN(unwired)'로 표기(엔진 경로로는 계산불가).

from decimal import Decimal, ROUND_HALF_UP

# ── 라이브 component_prices 실측분 (읽기전용 SELECT 결과 그대로) ──
#    siz/clr/mat/proc/opt 전건 NULL(와일드카드), apply_ymd 단일(2026-06-01).
BIND_PRICE_ROWS = {
    "COMP_BIND_JUNGCHEOL": {1:3000, 4:2000, 10:1500, 30:1000, 50:1000, 70:700, 100:700, 1000:500},
    "COMP_BIND_MUSEON":    {1:3000, 4:2000, 10:1000, 30:700,  50:700,  70:500, 100:500, 1000:500},
    "COMP_BIND_TWINRING":  {1:4000, 4:3000, 10:2000, 30:1500, 50:1500, 70:1300,100:1300,1000:1000},
    "COMP_BIND_PUR":       {1:5000, 4:5000, 10:5000, 30:4000, 50:3000, 70:2500,100:2000,1000:1500},
}

# ── 상품 → 제본방식 comp (상품별 1고정 = 상품 정체) ──
PRODUCT_BIND_COMP = {
    "PRD_000068": ("중철책자",   "COMP_BIND_JUNGCHEOL"),
    "PRD_000069": ("무선책자",   "COMP_BIND_MUSEON"),
    "PRD_000070": ("PUR책자",    "COMP_BIND_PUR"),
    "PRD_000071": ("트윈링책자", "COMP_BIND_TWINRING"),
}

# ── 사슬 배선 상태(S1 라이브 실측) ──
WIRED_COMPS = {"COMP_BIND_JUNGCHEOL"}  # formula_components(PRF_BIND_SUM) 실측


def match_qty_band(price_rows: dict, order_qty: int):
    """수량구간 매칭: 주문수량 이하 최대 min_qty. 최소 미달=계산불가(None)."""
    bands = sorted(price_rows.keys())
    if order_qty < bands[0]:
        return None, None  # 최소 미달
    chosen = None
    for b in bands:
        if b <= order_qty:
            chosen = b
        else:
            break
    return chosen, price_rows[chosen]


def round_won(v) -> int:
    return int(Decimal(str(v)).quantize(Decimal("1"), rounding=ROUND_HALF_UP))


def recompute_binding(prd_cd: str, order_qty: int):
    """제본비 항 재계산. 반환 = 내역 dict."""
    bind_nm, comp_cd = PRODUCT_BIND_COMP[prd_cd]
    rows = BIND_PRICE_ROWS[comp_cd]
    band, unit = match_qty_band(rows, order_qty)
    chain = "WIRED(완결)" if comp_cd in WIRED_COMPS else "BROKEN(unwired·공식미배선)"
    if band is None:
        return {
            "prd_cd": prd_cd, "bind": bind_nm, "comp": comp_cd, "qty": order_qty,
            "status": "계산불가(최소수량 미달)", "chain": chain,
            "band": None, "unit": None, "bind_fee": None,
        }
    bind_fee = round_won(unit * order_qty)  # 단가형: 권당가 × 권수
    return {
        "prd_cd": prd_cd, "bind": bind_nm, "comp": comp_cd, "qty": order_qty,
        "status": "OK", "chain": chain,
        "band": band, "unit": unit, "bind_fee": bind_fee,
    }


if __name__ == "__main__":
    # 골든 케이스 — 벤치마크에서 쓸 PRBKYPR(무선책자) 옵션 구성과 정렬.
    # 4종 커버리지 규칙(design §5-2): 기본·수량구간·총액형(N/A·단가형)·비경계수량.
    CASES = [
        # (id, prd_cd, qty, note)
        ("G1", "PRD_000068", 100,  "중철·100권(사슬완결·기본)"),
        ("G2", "PRD_000069", 100,  "무선·100권(레드 PRBKYPR 대응·기본)"),
        ("G3", "PRD_000069", 500,  "무선·500권(수량구간=100구간 적용·비경계)"),
        ("G4", "PRD_000070", 100,  "PUR·100권(사슬단절·골든만)"),
        ("G5", "PRD_000071", 100,  "트윈링·100권(사슬단절·골든만)"),
        ("G6", "PRD_000069", 30,   "무선·30권(중간구간 경계)"),
        ("G7", "PRD_000069", 1,    "무선·1권(최소구간)"),
        ("G8", "PRD_000069", 1000, "무선·1000권(최대구간)"),
    ]
    print(f"{'ID':3} {'상품':10} {'권수':>5} {'comp구간':>8} {'권당가':>7} {'제본비':>9}  사슬 / 비고")
    for cid, prd, qty, note in CASES:
        r = recompute_binding(prd, qty)
        if r["status"] == "OK":
            print(f"{cid:3} {r['bind']:10} {qty:5d} {r['band']:8d} {r['unit']:7d} {r['bind_fee']:9d}  {r['chain']} | {note}")
        else:
            print(f"{cid:3} {r['bind']:10} {qty:5d} {'-':>8} {'-':>7} {'-':>9}  {r['status']} | {note}")
