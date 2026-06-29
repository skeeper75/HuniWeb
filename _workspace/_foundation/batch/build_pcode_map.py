#!/usr/bin/env python3
"""
build_pcode_map — 라이브 prd_cd ↔ 예전사이트 pcode 매핑표 생성기.

목적: 배치 PR(가격재현) 채점이 "어느 예전사이트 폼(goods.asp?pcode=N)으로
그 상품의 정답가를 뽑을지" 알도록 prd_cd → pcode 매핑 CSV(prd-pcode-map.csv)를
산출한다.

★핵심 발견(설계 제약):
  예전사이트 pcode 는 **카테고리 단위 폼**이다(예 pcode 33 "엽서" 폼 하나가
  프리미엄/코팅/스탠다드/투명엽서를 폼 안 용지·옵션 선택으로 모두 커버).
  라이브 prd_nm 은 **상품 단위**(프리미엄엽서·코팅엽서…). 따라서 매핑은
  N(prd_cd) : 1(pcode) 다대일이며, 같은 pcode 폼 안에서 prd 별 정답 구성은
  golden_fetch 가 용지/옵션으로 좁힌다.

매칭 방법(결정론·확실한 것만):
  1) breadcrumb 끝 토큰(카테고리명)을 정규화 키워드로.
  2) prd_nm 을 그 키워드에 규칙 매칭(아래 RULES). 확실하면 confidence=high.
  3) 애매·미발견은 pcode='' confidence='미상' (누락 은폐 금지 — 사람이 보강).

[HARD] 라이브 읽기전용. pcode 인덱스(_huni_live_pcode-index.csv)와 라이브 DB
prd 목록만 읽는다. 값 날조 0 — 추측 매칭은 confidence 로 정직 표기.

사용:  python3 build_pcode_map.py        # prd-pcode-map.csv 재생성
"""
import os
import csv
import re

HERE = os.path.dirname(os.path.abspath(__file__))
REMED = os.path.abspath(os.path.join(HERE, "..", "remediation"))
PCODE_INDEX = os.path.join(REMED, "_huni_live_pcode-index.csv")
OUT = os.path.join(HERE, "prd-pcode-map.csv")

import lib_huni as H


# ─────────────────────────────────────────────────────────────────────
# 매핑 규칙: (정규식 패턴 on prd_nm) → 후보 pcode breadcrumb 끝 카테고리 키워드
#   prd_nm 이 패턴에 맞으면 그 카테고리 키워드를 가진 pcode 로 매핑.
#   confidence high = 규칙이 명확 / mid = 카테고리는 맞으나 폼 내 구성 좁힘 필요.
#   ★규칙은 "확실한 것만". 모호하면 비워두고 미상으로 떨어뜨린다.
# ─────────────────────────────────────────────────────────────────────
# 카테고리 키워드(breadcrumb 끝) → 그 폼이 커버하는 prd_nm 규칙(정규식)
# 하나의 카테고리 폼이 여러 prd 를 커버하므로 다대일.
CATEGORY_RULES = [
    # (breadcrumb 키워드 substring, prd_nm 정규식, confidence)
    # ── 디지털인쇄: 엽서/명함/카드 군 ──
    ("엽서", r"(프리미엄|코팅|스탠다드)엽서$", "high"),
    ("투명엽서", r"투명엽서$", "high"),
    ("코팅엽서", r"코팅엽서$", "high"),
    ("지그재그엽서", r"지그재그엽서$", "high"),
    ("모양명함", r"모양명함$|미니모양명함$", "high"),
    ("박명함", r"박명함$", "mid"),
    ("명함(디지털)", r"(프리미엄|코팅|스탠다드|펄)명함$", "high"),
    ("카드명함", r"카드명함$", "mid"),
    ("카드·초대장", r"(2단접지|3단접지|미니접지)카드$", "mid"),
    ("엽서북", r"엽서북", "high"),
    ("떡메모지", r"떡메모지", "high"),
    # ── 스티커 ──
    ("반칼스티커", r"반칼.*스티커|스티커", "mid"),
    ("사각라운딩 스티커", r"(사각|라운딩).*스티커", "mid"),
    ("원형·타원 스티커", r"(원형|타원).*스티커", "mid"),
    # ── 굿즈/아크릴 ──
    ("투명아크릴키링", r"아크릴.*키링|투명아크릴키링", "high"),
    ("아크릴뱃지", r"아크릴.*뱃지", "high"),
    ("아크릴마그넷", r"아크릴.*마그넷|아크릴.*자석", "mid"),
    ("아크릴집게", r"아크릴.*집게", "high"),
    ("아크릴자석명찰", r"아크릴.*명찰", "high"),
    ("아크릴볼펜", r"아크릴.*볼펜", "high"),
    ("아크릴 자유형 스탠드", r"아크릴.*스탠드", "mid"),
    ("아크릴 미니파츠", r"아크릴.*(미니파츠|파츠)", "high"),
    ("판아크릴", r"판아크릴", "high"),
    ("아크릴 포카 스탠드", r"아크릴.*포카.*스탠드", "high"),
    ("아크릴 네임택(포카키링)", r"아크릴.*(네임택|포카키링)", "high"),
    ("모양스마트톡", r"스마트톡", "high"),
    ("포토카드", r"포토카드$", "high"),
    # ── 책자 ──
    ("무선제본", r"무선제본|무선책자", "mid"),
    ("중철제본", r"중철", "mid"),
    ("트윈링제본", r"트윈링|링제본", "mid"),
    ("하드커버무선", r"하드커버.*무선", "mid"),
    # ── 실사출력 ──
    ("현수막", r"현수막", "high"),
    ("족자", r"족자", "high"),
    ("실내용배너", r"실내.*배너|미니배너", "mid"),
    ("실외용배너", r"실외.*배너", "mid"),
    ("캔버스천", r"캔버스(천)?$", "mid"),
    ("그래픽천", r"그래픽천", "high"),
]


def norm(s):
    return (s or "").strip()


def load_pcode_index():
    """[(pcode, breadcrumb, last_category_token)]."""
    rows = []
    with open(PCODE_INDEX, encoding="utf-8") as f:
        for r in csv.DictReader(f):
            pc = norm(r.get("live_pcode"))
            bc = norm(r.get("breadcrumb"))
            if not pc or not bc:
                continue
            # breadcrumb 끝 = 카테고리명
            last = bc.split(">")[-1].strip()
            rows.append((pc, bc, last))
    return rows


def live_products():
    H.load_env()
    rows = H.db("""SELECT prd_cd, prd_nm, prd_typ_cd FROM t_prd_products
                   WHERE del_yn='N' ORDER BY prd_cd""")
    return [(r[0], r[1], r[2]) for r in rows]


def match_pcode(prd_nm, pidx):
    """prd_nm → (pcode, breadcrumb, confidence, rule). 미발견=('','','미상','')."""
    for kw, pat, conf in CATEGORY_RULES:
        if not re.search(pat, prd_nm):
            continue
        # 그 키워드를 끝 카테고리로 가진 pcode 찾기
        for pc, bc, last in pidx:
            if kw in last or kw in bc:
                return pc, bc, conf, pat
    return "", "", "미상", ""


def main():
    pidx = load_pcode_index()
    prods = live_products()
    out_rows = []
    n_high = n_mid = n_unknown = 0
    for prd_cd, prd_nm, prd_typ in prods:
        # 기성상품(.03 부속물)·반제품(.02 내지)은 예전사이트 단독 폼이 없음 → 미상(스킵 신호)
        if prd_typ in ("PRD_TYPE.03", "PRD_TYPE.02"):
            out_rows.append({
                "prd_cd": prd_cd, "prd_nm": prd_nm, "prd_typ": prd_typ,
                "pcode": "", "breadcrumb": "", "confidence": "미상-비단품",
                "rule": "기성/반제품(예전사이트 단독 폼 없음)"})
            n_unknown += 1
            continue
        pc, bc, conf, rule = match_pcode(prd_nm, pidx)
        out_rows.append({
            "prd_cd": prd_cd, "prd_nm": prd_nm, "prd_typ": prd_typ,
            "pcode": pc, "breadcrumb": bc, "confidence": conf, "rule": rule})
        if conf == "high":
            n_high += 1
        elif conf == "mid":
            n_mid += 1
        else:
            n_unknown += 1

    cols = ["prd_cd", "prd_nm", "prd_typ", "pcode", "breadcrumb",
            "confidence", "rule"]
    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(out_rows)
    print(f"prd-pcode-map.csv → {OUT} ({len(out_rows)}행)")
    print(f"  high={n_high}  mid={n_mid}  미상={n_unknown}")
    print("  ※ high/mid 만 PR 채점 후보. 미상은 사람이 보강하거나 PR 스킵.")


if __name__ == "__main__":
    main()
