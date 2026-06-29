#!/usr/bin/env python3
"""
공식집(계산공식집초안) 블록 → 전 라이브 상품 귀속 매핑.
공식집이 각 블록에 명시한 '대상 상품'(verbatim) 키워드로 라이브 상품을 블록에 1:1 배정.
출력: 상품 | 블록 | 유형 | 라이브 바인딩 공식 | 상태(정합/미바인딩/미매칭).

[HARD] 권위=공식집. 라이브 읽기전용. 미매칭은 숨기지 않고 드러낸다(정직).
"""
import csv
import os
import lib_huni as H

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "formula-block-map-260629.csv")

# (block_id, 유형, 대상 상품 키워드[verbatim], 세트?) — 공식집 행 근거
BLOCKS = [
    ("B03_엽서류", "원자합산", ["프리미엄엽서", "코팅엽서", "스탠다드엽서", "스텐다드엽서",
     "투명엽서", "화이트인쇄엽서", "핑크별색엽서", "금은별색엽서", "종이슬로건",
     "상품권", "쿠폰"], False),
    ("B14_모양", "원자합산", ["모양엽서", "미니모양엽서", "라벨텍", "라벨택", "라벨/택"], False),
    ("B18_배경지", "원자합산", ["인쇄배경지", "헤더택", "헤더태그"], False),
    ("B24_전단", "원자합산", ["소량전단", "전단지"], False),
    ("B28_접지", "원자합산", ["접지리플렛", "와이드접지", "미니접지카드", "2단접지카드",
     "3단접지카드", "지그재그엽서"], False),
    ("B48_썬캡", "원자합산", ["썬캡"], False),
    ("B63_책자무선", "원자합산세트", ["중철책자", "무선책자", "PUR책자", "하드커버책자",
     "레더 하드커버책자", "하드커버무선"], True),
    ("B72_트윈링", "원자합산세트", ["트윈링책자", "링책자"], True),
    ("B81_하드커버링", "원자합산세트", ["하드커버 링책자", "하드커버링책자", "레더 링바인더",
     "링바인더"], True),
    ("B94_캘린더", "원자합산", ["캘린더"], False),
    ("B32_명함", "고정가", ["스탠다드명함", "스텐다드명함", "프리미엄명함", "코팅명함",
     "펄명함", "투명명함", "화이트인쇄명함", "모양명함", "미니모양명함",
     "형압명함", "명함"], False),
    ("B37_박명함", "고정가", ["오리지널박명함"], False),
    ("B42_포토카드", "고정가", ["포토카드", "투명포토카드"], False),
    ("B45_봉투", "고정가", ["봉투제작", "봉투"], False),
    ("B51_스티커", "고정가", ["반칼", "낱장", "자유형", "대형 자유형", "소량자유형",
     "소량 자유형", "띠지스티커", "팬시스티커", "원형스티커", "정사각스티커",
     "직사각스티커"], False),
    ("B54_타투", "고정가", ["타투스티커"], False),
    ("B57_스티커팩", "고정가", ["스티커팩"], False),
    ("B60_합판", "고정가", ["합판도무송"], False),
    ("B91_엽서북떡메", "고정가세트", ["엽서북", "떡메모지"], True),
    ("B_포토북", "원자합산세트", ["포토북"], True),
    ("B103_보드배너", "고정가", ["폼보드", "포맥스", "프레임리스액자", "레더아트액자",
     "캔버스행잉", "린넨우드봉", "족자포스터", "PET배너", "메쉬배너", "시트커팅",
     "아크릴스티커", "미니스탠딩보드", "미니배너"], False),
    ("B113_아크릴외주", "고정가", ["아크릴코롯토", "아크릴카라비너"], False),
    ("B119_문구", "고정가", ["다이어리", "플래너", "노트", "만년", "메모패드", "문구"], False),
    ("B122_굿즈", "고정가", ["굿즈", "파우치"], False),
    ("B125_액세서리", "고정가", ["상품액세서리", "상품악세"], False),
    ("B100_실사", "면적매트릭스", ["실사", "현수막", "배너", "포스터"], False),
    ("B106_아크릴", "면적매트릭스", ["아크릴"], False),
]


def assign(nm):
    """상품명 → 블록(가장 구체적 매칭 우선: 긴 키워드 우선)."""
    hits = []
    for bid, typ, kws, isset in BLOCKS:
        for kw in kws:
            if kw in nm:
                hits.append((len(kw), bid, typ, isset))
    if not hits:
        return None
    hits.sort(reverse=True)  # 가장 긴(구체) 키워드 우선
    _, bid, typ, isset = hits[0]
    return bid, typ, isset


def latest_frm(prd):
    r = H.db(f"SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='{prd}' "
             f"ORDER BY apply_bgn_ymd DESC NULLS LAST LIMIT 1")
    return r[0][0] if r else None


def main():
    H.load_env()
    prods = H.db("SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products "
                 "WHERE COALESCE(del_yn,'N')<>'Y' ORDER BY prd_cd")
    rows = []
    for prd, nm, typ in prods:
        frm = latest_frm(prd)
        # .03 기성상품 = 제조 없음 → 추가상품/고정가(공식 무관). 별도 분류.
        if typ == "PRD_TYPE.03":
            rows.append((prd, nm, typ, "기성(.03)", "추가상품/고정가", frm or "", "기성-공식무관"))
            continue
        a = assign(nm)
        if a is None:
            rows.append((prd, nm, typ, "", "", frm or "", "미매칭(블록없음)"))
            continue
        bid, ftyp, isset = a
        status = "바인딩있음" if frm else "미바인딩"
        rows.append((prd, nm, typ, bid, ftyp, frm or "", status))

    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["prd_cd", "prd_nm", "prd_typ_cd", "block", "block_type", "live_frm", "status"])
        w.writerows(rows)

    # 요약
    from collections import Counter
    by_block = Counter(r[3] or "미매칭" for r in rows)
    by_status = Counter(r[6] for r in rows)
    print(f"전 상품 {len(rows)}  →  {OUT}")
    print("\n[블록별 상품수]")
    for b, n in sorted(by_block.items()):
        print(f"  {b:18} {n}")
    print("\n[상태]")
    for s, n in by_status.most_common():
        print(f"  {s:18} {n}")
    print("\n[미매칭 상품(블록 키워드 미해당) — 공식집 보강 대상]")
    for r in rows:
        if r[6].startswith("미매칭"):
            print(f"  {r[0]} {r[1]}  (typ {r[2]})")


if __name__ == "__main__":
    main()
