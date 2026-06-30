#!/usr/bin/env python3
# golden_recalc.py — 소형 박 골든 재계산 (evaluate_price 순수함수 추적·라이브 미적재 검증)
#
# 무엇을 하나: gen_foil_pilot.py 가 펼친 flatten 단가행에 대해, pricing.py 의 match_component
#   알고리즘(TIER ceiling=siz_width/height '이하' 최소임계 + min_qty band='이상' 최대임계 +
#   .03 FLAT=곱셈 0)을 순수함수로 재현해, 골든 케이스 4종(+off-band)을 재계산한다.
#   라이브 시뮬레이터 실호출은 post-COMMIT 으로 연기(아직 행 미적재) — 본 재계산이 그 대행.
#
# 권위 기댓값: golden-cases-foil.md (소형) — G-F4=69000·G-F5=19300·G-F8=37500·G-F9(off-band)=57800.
import sys
sys.path.insert(0, ".")
import gen_foil_pilot as G

ROWS = G.build_all()


def tier_match(comp_cd, proc_cd, w, h, qty):
    """pricing.py match_component 재현: siz_width/height ceiling + min_qty band + FLAT.
       반환: (unit_price, matched_row) 또는 (None, err)."""
    cand = [r for r in ROWS if r["comp_cd"] == comp_cd and r["proc_cd"] == proc_cd]
    if not cand:
        return None, "no_proc_match (박 미선택/미등록 색상 → 0 기여)"
    # SETUP: siz/min_qty NULL → 전수량·전면적 단일행
    if comp_cd == "COMP_FOIL_SETUP_SMALL":
        return cand[0]["unit_price"], cand[0]
    # 박가공비: 3축 티어
    # siz_width ceiling ('이하' 상한 → 주문값 이상 임계 중 최소)
    wt = sorted({r["siz_width"] for r in cand})
    elig_w = [t for t in wt if t >= w]
    if not elig_w: return None, "ERR_ABOVE_MAX(width)"
    sw = min(elig_w)
    ht = sorted({r["siz_height"] for r in cand})
    elig_h = [t for t in ht if t >= h]
    if not elig_h: return None, "ERR_ABOVE_MAX(height)"
    sh = min(elig_h)
    # min_qty band ('이상' 하한 → 주문수량 이하 임계 중 최대)
    mq = sorted({r["min_qty"] for r in cand if r["siz_width"] == sw and r["siz_height"] == sh})
    elig_q = [t for t in mq if t <= qty]
    if not elig_q: return None, "ERR_BELOW_MIN(qty)"
    sq = max(elig_q)
    row = next(r for r in cand if r["siz_width"] == sw and r["siz_height"] == sh and r["min_qty"] == sq)
    # .03 FLAT: 매칭 구간 금액 그대로 (×qty 0)
    return row["unit_price"], row


# 소형 박색상→{STD|SPECIAL} comp 라우팅 (PRD_000031 등록색상)
def proc_comp(proc_cd):
    if proc_cd in G.STD_COLORS:     return "COMP_FOIL_PROC_SMALL_STD"
    if proc_cd in G.SPECIAL_COLORS: return "COMP_FOIL_PROC_SMALL_SPECIAL"
    return None


def foil_total(proc_cd, w, h, qty):
    """박_총액 = 동판비(.03) + 박가공비(.03 flat). proc_cd 미선택이면 0."""
    setup, _ = tier_match("COMP_FOIL_SETUP_SMALL", proc_cd, w, h, qty)
    pc = proc_comp(proc_cd)
    proc, prow = (tier_match(pc, proc_cd, w, h, qty) if pc else (None, "unregistered"))
    return setup, proc, prow


CASES = [
    # id,        proc_cd,       color,   w,  h,   qty,  expected
    ("G-F4", "PROC_000038", "금유광(STD)",  40, 80, 1000, 69000),
    ("G-F5", "PROC_000044", "트윙클(SPECIAL)",10,10, 200,  19300),
    ("G-F8", "PROC_000040", "먹유광(STD)",  40, 40, 500,  37500),
    ("G-F9", "PROC_000038", "금유광(STD·off-band q850)", 40, 80, 850, 57800),
    # 추가 회귀: off-band 더 큰 수량으로 .03 flat 재확인 (×qty 폭발 0 입증)
    ("OFF-X", "PROC_000038", "금유광(STD·q899 in band800)", 40, 80, 899, 57800),
    # 박 미선택(미등록 색상) → 0 기여 가드
    ("GATE0", "PROC_000045", "펄박(미등록)→0", 40, 80, 1000, None),
]


def run():
    print(f"{'case':7} {'color':28} {'w×h×qty':14} {'setup':>7} {'proc':>9} {'total':>9} {'expect':>8}  verdict")
    allpass = True
    for cid, proc, color, w, h, qty, exp in CASES:
        setup, proc_p, prow = foil_total(proc, w, h, qty)
        if cid == "GATE0":
            # 미등록 색상: setup/proc 둘 다 no_match → 박 0 기여
            ok = (setup is None and proc_p is None)
            tot = "0(no-match)"
            verdict = "PASS" if ok else "FAIL"
            print(f"{cid:7} {color:28} {f'{w}x{h}x{qty}':14} {'—':>7} {'—':>9} {tot:>9} {'박0':>8}  {verdict}")
            allpass &= ok; continue
        tot = (setup or 0) + (proc_p or 0)
        grade = prow["note"].split("등급")[1][0] if prow and "등급" in prow.get("note","") else "?"
        ok = (tot == exp)
        verdict = "PASS" if ok else "FAIL"
        print(f"{cid:7} {color:28} {f'{w}x{h}x{qty}':14} {setup:>7} {proc_p:>9} {tot:>9} {exp:>8}  {verdict} (등급{grade})")
        allpass &= ok
    print("\n=== off-band ×qty 폭발 가드 ===")
    # G-F9 vs band 경계 G-F4: 같은 면적·다른 수량(800밴드 내) → 동일 박가공비 = .03 FLAT 입증
    _, p850, _ = foil_total("PROC_000038", 40, 80, 850)
    _, p899, _ = foil_total("PROC_000038", 40, 80, 899)
    _, p800, _ = foil_total("PROC_000038", 40, 80, 800)
    print(f"  q800={p800}·q850={p850}·q899={p899} (전부 52800=E@800 band·.02였다면 56100/59334 과청구) → {'PASS' if p800==p850==p899==52800 else 'FAIL'}")
    print(f"\n{'★ ALL GOLDEN PASS' if allpass else '✗ SOME FAIL'}")
    return allpass


if __name__ == "__main__":
    sys.exit(0 if run() else 1)
