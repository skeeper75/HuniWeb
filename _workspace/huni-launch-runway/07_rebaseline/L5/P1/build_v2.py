# -*- coding: utf-8 -*-
"""P1 원장 v2 생성기 — 판정 143 + done_criteria 504 + 오픈차단여부 504.

입력  L5/unified-ledger-assigned.csv (504행)
출력  L5/P1/unified-ledger-v2.csv · .json
재실행 python3 L5/P1/build_v2.py
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
RB = os.path.dirname(os.path.dirname(HERE))          # 07_rebaseline
SRC = os.path.join(RB, "L5", "unified-ledger-assigned.csv")
sys.path.insert(0, HERE)
from judgments import J

OUT_CSV = os.path.join(HERE, "unified-ledger-v2.csv")
OUT_JSON = os.path.join(HERE, "unified-ledger-v2.json")

# ── 금지어 (O2 템플릿 §5) ────────────────────────────────────────────────
BANNED = ["검토한다", "정리한다", "준비한다", "보완한다", "정상 동작", "완료한다"]

# ── 대분류별 확인처 (O2 템플릿 §2) ───────────────────────────────────────
PLACE = {
    "상품·카탈로그": "라이브 스토어프론트 화면",
    "옵션·견적": "위젯 실화면 + 가격 시뮬레이터",
    "원고·파일": "위젯 드롭존 + t_ord_artworks",
    "장바구니·주문": "라이브 장바구니 화면 + 샵바이 주문 API 응답",
    "결제": "결제 화면 + 이니시스 가맹점관리자",
    "배송": "셀러어드민 배송 설정 화면",
    "회원·인증": "라이브 화면(테스트 계정)",
    "마이페이지": "라이브 화면(테스트 계정)",
    "클레임·CS": "샵바이 응답의 nextActions·cancelable/exchangeable/returnable",
    "프로모션": "셀러어드민 프로모션 화면",
    "B2B": "셀러어드민 B2B 화면",
    "정산·통계": "셀러어드민 정산 화면",
    "정보·콘텐츠": "라이브 페이지 URL",
    "운영자·상품가격": "webadmin 화면 + 라이브 DB 읽기",
    "운영자·주문운영": "셀러어드민 주문 화면 / webadmin",
    "운영자·회원CS": "셀러어드민 회원·게시판 화면",
    "시스템·플랫폼": "코드 + 로그 + 응답",
    "생산·공정": "webadmin 화면 + 라이브 DB + 출력물",
}

FILELINE = re.compile(r"[\w./\-]+\.(?:py|ts|tsx|js|json|sql)(?::\d+(?:[,\-]\d+)*)+")


def first_fileline(*texts):
    for t in texts:
        m = FILELINE.search(t or "")
        if m:
            return m.group(0)
    return ""


def short(fn, n=34):
    fn = fn.strip()
    return fn if len(fn) <= n else fn[:n] + "…"


# ── 오픈차단여부 ─────────────────────────────────────────────────────────
# lead 차단 최종(LEAD-VERDICT-O.md §3): 「우리 손 밖 + 오픈을 못 연다」 둘 다 만족.
BLOCK_EXTERNAL = {
    "STD-PAY-001": "PG 승인 — 이니시스 MID 추가 발급 전에는 카드 결제창이 안 뜬다",
    "STD-PAY-011": "PG 승인 — 리다이렉트·콜백은 MID 발급 후에만 실물 검증 가능",
    "STD-SYS-004": "PG 승인 — 상점ID(MID) 값 자체가 승인 산출물",
    "STD-PAY-008": "PG 승인 — 복합결제는 PG 승인분 위에 얹힌다",
    "STD-FIN-008": "PG 승인 종속 + 정산 권위 실증(X-SETTLE-AUTH-01, 실주문 1건)",
    "STD-MYP-007": "PG 승인 — 충전은 PG 결제 경로를 그대로 탄다",
    "STD-MEM-020": "구 DB 접근 — 범위에 넣을 때만 차단(PM 결정 종속)",
    "STD-MYP-009": "구 DB 접근 — 범위에 넣을 때만 차단(PM 결정 종속)",
}
# 외부 승인이 걸렸으나 오픈은 못 막는 것(축소 시나리오 A) — 「작업 항목」으로 두고 비고에 남긴다.
EXT_NOTE = {
    "STD-PAY-004": "외부 승인 종속 — 네이버페이 3~4주(payment-approval-flow.md:40) · 축소 시나리오 A 대기",
    "STD-PAY-005": "외부 승인 종속 — 카카오페이 2주(payment-approval-flow.md:40) · 축소 시나리오 A 대기",
}
IRRELEVANT_MARK = "10/6 범위 「수동 대체」"


def blocking_of(r, judged_note):
    sid = r["std_id"]
    if sid in BLOCK_EXTERNAL:
        return "차단(외부)"
    if r["상태"] == "미판정":
        return "미판정"
    if IRRELEVANT_MARK in judged_note:
        return "오픈 무관"
    return "작업 항목"


# ── 한국어 조사 ──────────────────────────────────────────────────────────
def josa(word, pair="이가"):
    """받침 유무로 조사를 고른다. 괄호로 끝나면 그 앞 글자를 본다."""
    w = word.rstrip(")〉」』】 ")
    for ch in reversed(w):
        if "가" <= ch <= "힣":
            return pair[0] if (ord(ch) - 0xAC00) % 28 else pair[1]
        if ch.isdigit():
            return pair[0] if ch in "0168" else pair[1]
        if ch.isalpha():
            return pair[1]
    return pair[1]


# ── done_criteria ────────────────────────────────────────────────────────
# 돈·주문 행의 관측 문장은 두 갈래다(O2 템플릿 §3 「숫자를 넣는다」).
#  (가) 고객에게 금액이 표시되는 계열 → 표시 금액을 권위값과 원 단위까지 대조
#  (나) 운영자가 값을 넣는 계열      → 저장값이 DB 1행으로 조회되고 가격에 반영되는지 대조
SHOWN_PRICE = {"옵션·견적", "장바구니·주문", "결제", "마이페이지", "프로모션",
               "B2B", "정산·통계", "클레임·CS", "배송", "상품·카탈로그", "회원·인증"}


def money_tail(cat, fn):
    if cat in SHOWN_PRICE:
        return (f"「{short(fn)}」 결과에 표시된 금액이 권위값과 원 단위까지 같은 것이 "
                f"1건 확인된다")
    return (f"「{short(fn)}」 로 저장한 값이 라이브 DB 1행으로 조회되고, "
            f"그 값이 가격 계산 결과에 원 단위까지 반영된 것이 1건 확인된다")


def plain_tail(fn, verb="관측된다"):
    return f"「{short(fn)}」{josa(short(fn))} 1회 {verb}"


def make_criteria(r):
    sid, st, cat, fn = r["std_id"], r["상태"], r["대분류"], r["기능"]
    place = PLACE.get(cat, "라이브 화면")
    money = r["돈여부"] == "Y" or r["주문여부"] == "Y"
    note = r["비고"]
    tail = money_tail(cat, fn) if money else plain_tail(fn)

    if st == "미판정":
        why = note.split("판정 불가 사유 — ")[-1] if "판정 불가 사유" in note else "판정 근거 부재"
        return f"판정 보류 — {why}. 근거가 서면 그때 완료조건을 쓴다"

    if sid in BLOCK_EXTERNAL:
        return f"차단 — {BLOCK_EXTERNAL[sid]}. 승인·접근이 열린 뒤 {place} 에서 {tail}"

    if IRRELEVANT_MARK in note:
        return (f"{place} 에서 「{short(fn)}」{josa(short(fn))} 현행 경로(MES·수기)로 "
                f"1건 처리된 기록이 있다. 신규 시스템 이관은 10/6 범위 밖")

    if st == "done":
        fl = first_fileline(r["근거"])
        return f"{fl} 에 구현이 있고, {place} 에서 {tail}"

    if st == "partial":
        miss = missing_part(r)
        if miss:
            return f"이미 되는 부분은 {place} 에서 확인되고, 남은 부분({miss})이 {place} 에서 {tail}"
        # 남은 부분이 원장에 기록돼 있지 않다 — 그것 자체가 먼저 닫아야 할 일이다.
        return (f"남은 부분 미기재 — {place} 에서 「{short(fn)}」 전 항목을 1회 점검해 "
                f"안 되는 부분을 원장 비고에 적는다. 그 뒤 {tail}")

    if st == "new":
        made = f"「{short(fn)}」{josa(short(fn), '을를')} 담을 그릇(테이블·모듈·화면)"
        seen = tail if money else f"그 동작이 1회 관측된다"
        return f"{made}이 생기고, {place} 에서 {seen}"

    return f"{place} 에서 {tail}"


NOISE = re.compile(r"^(R\d+|L\d+|Round\s*\d+)\b")


def missing_part(r):
    """비고에서 「아직 안 되는 부분」을 뽑는다. 라운드 태그·판정 승계 문구는 정보가 아니다."""
    for seg in [s.strip() for s in r["비고"].split("·")]:
        if not seg or NOISE.match(seg):
            continue
        if any(k in seg for k in ("판정 승계", "lead 결정", "conflict", "L4", "R1")):
            continue
        if any(k in seg for k in ("미구현", "부재", "0건", "남음", "미신설", "미작성",
                                  "미협의", "미확정", "종속", "선행")):
            return short(seg, 46)
    return ""


# ── 실행 ─────────────────────────────────────────────────────────────────
def main():
    rows = list(csv.DictReader(open(SRC, encoding="utf-8")))
    assert len(rows) == 504, f"원장 행수 {len(rows)} ≠ 504"

    applied = 0
    for r in rows:
        sid = r["std_id"]
        if sid in J:
            st, ev, extra = J[sid]
            assert r["상태"] == "미판정", f"{sid} 는 미판정이 아니다({r['상태']})"
            r["상태"] = st
            r["근거"] = (r["근거"] + " || P1판정(260902): " + ev).strip(" |")
            if extra:
                r["비고"] = (r["비고"] + " · " if r["비고"] else "") + extra
            applied += 1
        if sid in EXT_NOTE:
            r["비고"] = (r["비고"] + " · " if r["비고"] else "") + EXT_NOTE[sid]

    # STD-SYS-009 — lead 결정(LEAD-VERDICT-O.md §5)
    for r in rows:
        if r["std_id"] == "STD-SYS-009":
            add = "구현 완료·미검증 — 검증은 STD-PAY-013/STD-FIN-008/X-NHN-REVIEW-01"
            if add not in r["비고"]:
                r["비고"] = (r["비고"] + " · " if r["비고"] else "") + add

    for r in rows:
        r["오픈차단여부"] = blocking_of(r, r["비고"])
        r["done_criteria"] = make_criteria(r)

    cols = list(rows[0].keys())
    if "오픈차단여부" not in cols:
        cols.append("오픈차단여부")
    # 열 순서: 상태 뒤에 오픈차단여부
    cols = [c for c in cols if c != "오픈차단여부"]
    cols.insert(cols.index("상태") + 1, "오픈차단여부")

    with open(OUT_CSV, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)
    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=1)

    # ── 기계 검증 ────────────────────────────────────────────────────────
    import collections
    err = []
    blank_dc = [r["std_id"] for r in rows if not r["done_criteria"].strip()]
    blank_bl = [r["std_id"] for r in rows if not r["오픈차단여부"].strip()]
    banned = [(r["std_id"], b) for r in rows for b in BANNED if b in r["done_criteria"]]
    done_nofl = [r["std_id"] for r in rows if r["상태"] == "done" and not first_fileline(r["근거"])]
    if blank_dc: err.append(f"done_criteria 빈칸 {len(blank_dc)}: {blank_dc[:5]}")
    if blank_bl: err.append(f"오픈차단여부 빈칸 {len(blank_bl)}: {blank_bl[:5]}")
    if banned:   err.append(f"금지어 {len(banned)}: {banned[:5]}")
    if done_nofl: err.append(f"done 인데 file:line 없음 {len(done_nofl)}: {done_nofl[:5]}")

    print(f"적용 판정 {applied}/143 · 총 {len(rows)}행")
    print("상태:", dict(collections.Counter(r["상태"] for r in rows)))
    print("오픈차단여부:", dict(collections.Counter(r["오픈차단여부"] for r in rows)))
    print("담당×상태:")
    tbl = collections.Counter((r["담당"], r["상태"]) for r in rows)
    for d in sorted({r["담당"] for r in rows}):
        line = " · ".join(f"{s} {tbl[(d,s)]}" for s in ["done","partial","todo","new","미판정"] if tbl[(d,s)])
        print(f"  {d}: {line} (계 {sum(v for k,v in tbl.items() if k[0]==d)})")
    print("검증:", "PASS — 결함 0" if not err else "FAIL\n  " + "\n  ".join(err))
    return 1 if err else 0


if __name__ == "__main__":
    sys.exit(main())
