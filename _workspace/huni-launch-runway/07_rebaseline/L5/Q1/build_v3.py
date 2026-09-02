# -*- coding: utf-8 -*-
"""Q1 원장 v3 생성기 — 무통장 선검증 표기 + lead 결정 반영 + partial 「안 되는 부분」.

입력  L5/P1/unified-ledger-v2.csv (504행)
출력  L5/Q1/unified-ledger-v3.csv · .json
재실행 python3 L5/Q1/build_v3.py

원칙
  - 열 구성은 v2 와 동일(16열). 새 열을 만들지 않는다 — L6 생성기가 v2 열을 읽는다.
  - 「오픈차단여부」 값은 4종(작업 항목·차단(외부)·오픈 무관·미판정) 그대로 유지한다.
  - 근거 없는 문장을 만들지 않는다. 뽑을 것이 없으면 「미확인」으로 적는다.
"""
import csv, json, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
RB = os.path.dirname(os.path.dirname(HERE))              # 07_rebaseline
SRC = os.path.join(RB, "L5", "P1", "unified-ledger-v2.csv")
OUT_CSV = os.path.join(HERE, "unified-ledger-v3.csv")
OUT_JSON = os.path.join(HERE, "unified-ledger-v3.json")

BANNED = ["검토한다", "정리한다", "준비한다", "보완한다", "정상 동작", "완료한다"]

# ══════════════════════════════════════════════════════════════════════
# 1. 무통장 선검증 재판정 — 차단 8행
#    「무통장 실주문 1건(입금대기 → 운영자 입금확인 → 결제완료)」으로 이 행의
#    검증을 PG 승인 전에 앞당길 수 있는가. 근거는 전부 문서 줄이다.
#    표기는 세 값 중 하나로 시작한다: 가능 / 불가 / 미확인
# ══════════════════════════════════════════════════════════════════════
BANK_PRECHECK = {
    "STD-PAY-001": ("불가",
        "카드 결제창은 MID 발급 산출물이고(payment-approval-flow.md §1-1 [3]~[7]), "
        "무통장 주문은 결제창을 거치지 않고 바로 입금대기로 간다"
        "(shopby-order-state-machine.md T2) · checkout-form.tsx:8-9 「PG 연동은 후속 — 현재는 무통장만 동작」"),
    "STD-PAY-008": ("불가",
        "복합결제는 PG 결제 구간 위에 얹힌다 · 무통장 경로에는 그 구간 자체가 없다"
        "(shopby-order-state-machine.md T2·T4)"),
    "STD-PAY-011": ("불가",
        "무통장은 운영자가 [입금확인 처리]를 눌러 결제완료가 되고"
        "(shopby-order-state-machine.md T4), PG 자동 입금확인은 가상계좌·에스크로 전용(T5) — "
        "무통장 주문은 PG 리다이렉트·콜백을 한 번도 타지 않는다. "
        "다만 결제완료 이후 사슬(웹훅 수신·상태 반영)은 무통장으로 관측되며 그건 gates-v2 G2 ④에서 닫는다"),
    "STD-SYS-004": ("불가",
        "상점ID(MID) 값 자체가 승인 산출물이라 무통장 주문을 아무리 돌려도 값이 생기지 않는다"
        "(payment-approval-flow.md §1-1 [5])"),
    "STD-MYP-007": ("미확인",
        "충전 경로 코드가 no-op 스텁이라(point-section.tsx:11-14 → legacy-data/hooks.ts:423-432) "
        "결제수단과 무관하게 관측 대상이 없다 · 무통장으로 적립금 충전이 되는지에 대한 문서 근거 0건"),
    "STD-FIN-008": ("가능(부분)",
        "정산 권위 실증 X-SETTLE-AUTH-01(정산이 라인 salePrice/addPrice 를 권위로 쓰는가)은 "
        "무통장 주문이 결제완료에 도달하면 관측 대상이 생긴다(shopby-order-state-machine.md T4) · "
        "단 ① 정산 화면 접근이 셀러어드민 종속(open-questions.md A) ② 우리 몰 정산 주기·수식·"
        "PG 수수료 항은 미확인(open-questions.md B-2a·B-2c) ③ PG 수수료 항 자체가 무통장 주문에 없어 "
        "「PG 정산 대사」 전체는 PG 승인 후에만 닫힌다"),
    "STD-MEM-020": ("불가",
        "차단 사유가 구 DB 접근(X-OLDDB-ACCESS-01)이라 결제수단과 무관하다 — 무통장이 열려도 그대로 남는다"),
    "STD-MYP-009": ("불가",
        "차단 사유가 구 DB 접근이라 결제수단과 무관하다(STD-MEM-020 동형)"),
}

# ══════════════════════════════════════════════════════════════════════
# 2. lead 결정 반영 (LEAD-VERDICT-P.md §1·§2·§4)
# ══════════════════════════════════════════════════════════════════════
DRIFT_NOTE = ("구현 완료·미검증·계약 드리프트(huni_item 계약 vs huni_token 코드 — "
              "widget-order.ts:110-111 `?? \"\"` · cart-page.tsx:119 `if (!token) return;` · "
              "근거 L5/Q0/huni-token-label-check.md)")
LEAD_NOTES = {
    "STD-ORD-001": DRIFT_NOTE,
    "STD-ORD-003": DRIFT_NOTE,
    "STD-SYS-009": DRIFT_NOTE,   # lead 결정 「STD-SYS-009 동형」
    "STD-ADP-013": ("X-SHOPBY-HYGIENE-01 관리코드 중복 71건 = 완료(라이브 실측 09-02 · "
                    "전건 판매중지 + `-DUP-<상품번호>` 개칭 · 상품 288→297) · "
                    "잔여 1건 136009417 프리미엄엽서는 작업 항목(PM·실무진 확인) · "
                    "근거 L5/Q0/huni-token-label-check.md:150,:153"),
    "STD-SYS-008": ("X-SHOPBY-HYGIENE-01 관리코드 중복 71건 = 완료(라이브 실측 09-02) · "
                    "근거 L5/Q0/huni-token-label-check.md:150"),
}

# 근거 열 오기 정정 (lead 결정 · LEAD-VERDICT-P.md §2 끝줄)
EVIDENCE_FIX = {
    "STD-MFG-099": [("widget_api.py:3388", "widget_api.py:1226,:1252")],
}

# 원장에 행이 없어 여기서 못 고치는 것 — X 트랙 병합 때 처리한다(정직 기록).
X_TRACK_PENDING = [
    ("X-NHN-REPLY-01",
     "근거 `_workspace/huni-shopby/HANDOFF.md:12,:14,:15` → `_workspace/huni-shopby/CHANGELOG.md:13`",
     "이 원장 504행에 `X-NHN-REPLY-01` 을 매핑한 행이 0건이다(기계 확인) — "
     "값은 L3/legacy-normalized.json[323] · L3/id-preservation-map.csv:325 에 있고, "
     "lead 가 말한 「최종 원장 합침」이 아직 일어나지 않았다. 그 병합 때 정정한다."),
]

# ══════════════════════════════════════════════════════════════════════
# 2-b. Q2·Q3 후속 반영 (lead 지시 09-02 17:0x)
# ══════════════════════════════════════════════════════════════════════
# (가) Q2 API 실측 2건 — L5/Q2/api-check-a13-a5.md
LIVE_FACTS = {
    "STD-SYS-004": ("라이브 실측(09-02 A-5): `pgType = null` — 몰에 PG 가 연동돼 있지 않다는 직접 증거 "
                    "(L5/Q2/api-check-a13-a5.md §3 · 100번 줄). 차단(외부) 판정을 라이브 값이 뒷받침한다"),
    "STD-PAY-018": ("라이브 실측(09-02 A-5): `viewShopSpecification = false` — 거래명세서가 고객에게 "
                    "노출되지 않는다. 이 행은 「고객 노출」이 아니라 **담당자 화면** 성격이다 "
                    "(L5/Q2/api-check-a13-a5.md §3)"),
    "STD-PAY-015": ("라이브 실측(09-02 A-5): `cashReceipt = false` · `cashReceiptRequired = false` — "
                    "현금영수증 기능이 꺼져 있다. 수량 표기 형식(E-1)은 **무통장 관통으로도 안 닫힌다** "
                    "(L5/Q2/api-check-a13-a5.md §3 · :104)"),
    "STD-MYP-015": ("라이브 실측(09-02 A-5): `cashReceipt = false` — 현금영수증 기능이 꺼져 있어 "
                    "관리 화면에 실을 값 자체가 발생하지 않는다 (L5/Q2/api-check-a13-a5.md §3)"),
    "STD-MEM-014": ("라이브 실측(09-02 A-13): 상품 297건 전건 `nonmemberPurchaseYn = Y` — 판매중 226건도 "
                    "전건 게스트 구매 가능. 무통장 관통을 게스트 경로로 돌릴 수 있고 E-5·E-6 이 같이 관측된다 "
                    "(L5/Q2/api-check-a13-a5.md §2)"),
    "STD-ORD-007": ("라이브 실측(09-02 A-13): 판매중 226건 전건 게스트 구매 가능 — 비회원 장바구니가 "
                    "실제로 타는 경로다. 다만 게스트는 서버 장바구니가 없어 소유권 검증원이 없다"
                    "(open-questions.md D-6 · contract-c2-shopby.md:463)"),
    "STD-ORD-022": ("라이브 실측(09-02 A-13): 297건 전건 `nonmemberPurchaseYn = Y` — 비회원 주문이 "
                    "실제로 생길 수 있으므로 이 조회 경로가 오픈 첫날부터 쓰인다 "
                    "(L5/Q2/api-check-a13-a5.md §2)"),
}

# (나) Q3 가 찾은 원장 갭 1건 — 호출측(쇼핑개발) 행이 없다.
#     lead 검산: v2 504행 중 order/register·S2S 언급 행은 STD-MFG-001(수신측)·STD-ORD-029(재견적) 둘뿐.
#     중복 신설을 피하려고 F-062(STD-ORD-028) 를 먼저 봤고, 그 행은 「선택옵션→주문 데이터 변환」이라
#     후니로 보내는 S2S 호출과 기능이 다르다 → 신설한다.
NEW_ROW = {
    "std_id": "STD-ORD-030",
    "대분류": "장바구니·주문",
    "중분류": "주문",
    "기능": "주문 생성 직후 후니 주문등록 S2S 호출(order/register)",
    "상태": "todo",
    "오픈차단여부": "작업 항목",
    "매핑legacy_id": "",
    "매핑asis_id": "",
    "돈여부": "Y",
    "주문여부": "Y",
    "근거": ("L0/M2/interface-6.md I-4 · L0/N3/ARCHITECTURE-v2.md §10 A-15 "
             "(cart/* 미채택 · order/register 미호출) · L0/M2/contract-c2-shopby.md:396 "
             "저장소 전체 grep 결과 `order/register`·`X-Huni-Server-Key` 0건 · "
             "수신측은 raw/webadmin/webadmin/config/urls.py:267 에 이미 있다"),
    "비고": ("신설(lead 지시 09-02 · Q3 원장 갭) — 호출측 행이 v2 504행에 없었다. "
             "중복 신설 판단: F-062(STD-ORD-028 선택옵션→주문 데이터 변환)는 사양을 만드는 일이고 "
             "이 행은 만든 사양을 후니로 보내는 일이라 기능이 다르다 · "
             "STD-MFG-001 은 받는 쪽(인쇄개발) · STD-ORD-029 는 결제 직전 재견적 · "
             "상태는 lead 지시대로 `todo`(L5/Q3/DEV-REQUEST-02 §6 제안은 `new` 였다 — "
             "주문 흐름 자체는 서 있고 이 호출만 빠진 상태라 todo 를 택했다) · "
             "개발 전달 문서 L5/Q3/DEV-REQUEST-02-order-register.md · "
             "안 되는 부분: 자사몰에서 이 호출을 하는 코드가 0건이다"),
    "담당": "쇼핑개발",
    "sub_track": "web",
    "배정근거": "규칙:260616 01_역할정의 「주문/결제 플로우」 · 호출 주체가 자사몰(shopby 저장소)이다",
    "done_criteria": ("무통장 주문 1건을 넣은 뒤 후니 라이브 DB `t_ord_orders` 에 그 주문번호로 1행이 "
                      "조회되고, 그 행의 금액이 위젯 견적가와 원 단위까지 같은 것이 1건 확인된다"),
}
NEW_ROW_AFTER = "STD-ORD-029"

# ══════════════════════════════════════════════════════════════════════
# 3. partial 「안 되는 부분」 추출
# ══════════════════════════════════════════════════════════════════════
# 대분류별 확인처 — build_v2.py 의 PLACE 와 같은 표(중복 정의 대신 값만 승계).
PLACE = {
    "상품·카탈로그": "라이브 스토어프론트 화면", "옵션·견적": "위젯 실화면 + 가격 시뮬레이터",
    "원고·파일": "위젯 드롭존 + t_ord_artworks", "장바구니·주문": "라이브 장바구니 화면 + 샵바이 주문 API 응답",
    "결제": "결제 화면 + 이니시스 가맹점관리자", "배송": "셀러어드민 배송 설정 화면",
    "회원·인증": "라이브 화면(테스트 계정)", "마이페이지": "라이브 화면(테스트 계정)",
    "클레임·CS": "샵바이 응답의 nextActions·cancelable/exchangeable/returnable",
    "프로모션": "셀러어드민 프로모션 화면", "B2B": "셀러어드민 B2B 화면",
    "정산·통계": "셀러어드민 정산 화면", "정보·콘텐츠": "라이브 페이지 URL",
    "운영자·상품가격": "webadmin 화면 + 라이브 DB 읽기",
    "운영자·주문운영": "셀러어드민 주문 화면 / webadmin",
    "운영자·회원CS": "셀러어드민 회원·게시판 화면", "시스템·플랫폼": "코드 + 로그 + 응답",
    "생산·공정": "webadmin 화면 + 라이브 DB + 출력물",
}

NOISE = re.compile(r"^(R\d+|L\d+|Round\s*\d+)\b")
SKIP_SEG = ("판정 승계", "lead 결정", "conflict", "L4", "R1", "대분류 이관")
NOTE_KEYS = ("미구현", "부재", "0건", "남음", "미신설", "미작성", "미협의",
             "미확정", "종속", "선행", "미착수", "보류", "미등록", "미적용")
# 근거 문장에서 결손을 가리키는 표지 — 있는 그대로만 쓴다.
EV_KEYS = ("stub", "스텁", "no-op", "mock", "absent", "준비중", "목록만", "미구현",
           "미착수", "미협의", "미확정", "미상", "미검증", "부재", "미적용", "미청구",
           "보류", "미등록", "미배선", "미반영", "0건", "만)", "수동",
           "누락", "미지원", "없음", "드롭", "단절", "저청구", "오배선", "보정 필요",
           "잠복", "못 ", "전부 0", "NULL", "BLOCKED", "차단", "불일치", "미노출",
           "미해소", "미전송", "미저장", "미연결", "미가동", "미완")
# 블로커 ID 가 붙은 조각은 그 자체가 「안 되는 부분」이다.
BLOCKER_ID = re.compile(r"\b[XP]-[A-Z0-9]+(?:-[A-Z0-9]+)*-\d+\b")


def _clean(seg, n=90):
    seg = re.sub(r"\s+", " ", seg).strip(" ·|")
    if len(seg) > n:
        seg = seg[:n].rstrip(" ·,") + "…"
    # 잘라낸 자리에서 괄호가 짝을 잃으면 닫아 준다(읽는 사람이 걸린다).
    for a, b in (("(", ")"), ("「", "」"), ("(", ")")):
        if seg.count(a) > seg.count(b):
            seg += b * (seg.count(a) - seg.count(b))
    return seg


def missing_from_note(r):
    for seg in [s.strip() for s in r["비고"].split("·")]:
        if not seg or NOISE.match(seg) or any(k in seg for k in SKIP_SEG):
            continue
        if any(k in seg for k in NOTE_KEYS):
            return _clean(seg)
    return ""


def missing_from_evidence(r):
    """근거 열에서 결손 표지가 든 조각을 그대로 인용한다. 만들어내지 않는다."""
    for seg in [s.strip() for s in re.split(r"[·|]{1,2}", r["근거"]) if s.strip()]:
        if seg.startswith("P1판정"):
            continue
        if BLOCKER_ID.search(seg) or any(k in seg for k in EV_KEYS):
            return _clean(seg)
    return ""


def missing_part(r):
    m = missing_from_note(r)
    if m:
        return m, "비고"
    m = missing_from_evidence(r)
    if m:
        return m, "근거"
    return "", ""


# ══════════════════════════════════════════════════════════════════════
def main():
    rows = list(csv.DictReader(open(SRC, encoding="utf-8")))
    assert len(rows) == 504, f"입력 원장 행수 {len(rows)} ≠ 504"
    cols = list(rows[0].keys())

    def add_note(r, text):
        if text in r["비고"]:
            return False
        r["비고"] = (r["비고"] + " · " if r["비고"].strip() else "") + text
        return True

    log = collections.Counter()

    # (1) lead 결정 비고
    for r in rows:
        if r["std_id"] in LEAD_NOTES and add_note(r, LEAD_NOTES[r["std_id"]]):
            log["lead_note"] += 1

    # (2) 근거 오기 정정
    for r in rows:
        for old, new in EVIDENCE_FIX.get(r["std_id"], []):
            if old in r["근거"]:
                r["근거"] = r["근거"].replace(old, new)
                add_note(r, f"근거 정정(lead): {old} → {new}")
                log["evidence_fix"] += 1

    # (2-b) Q2 라이브 실측 반영
    for r in rows:
        if r["std_id"] in LIVE_FACTS and add_note(r, LIVE_FACTS[r["std_id"]]):
            log["live_fact"] += 1

    # (2-c) Q3 원장 갭 — 호출측 행 신설 + 인접 행에 판단 근거
    assert not any(r["std_id"] == NEW_ROW["std_id"] for r in rows), "신설 ID 중복"
    idx = next(i for i, r in enumerate(rows) if r["std_id"] == NEW_ROW_AFTER)
    rows.insert(idx + 1, {c: NEW_ROW.get(c, "") for c in cols})
    log["new_row"] += 1
    for sid, txt in (
        ("STD-ORD-028", "호출측 S2S 는 이 행이 아니다 — 신설 STD-ORD-030 이 맡는다(lead 지시 09-02)"),
        ("STD-ORD-029", "order/register 미호출은 이 행의 근거로만 적혀 있었다 — 호출 자체는 신설 STD-ORD-030"),
        ("STD-MFG-001", "받는 쪽만 done 이다 — 보내는 쪽은 신설 STD-ORD-030(쇼핑개발·todo)"),
    ):
        for r in rows:
            if r["std_id"] == sid and add_note(r, txt):
                log["gap_note"] += 1

    # (3) 무통장 선검증 표기 — 차단 8행
    blocked = [r for r in rows if r["오픈차단여부"] == "차단(외부)"]
    assert len(blocked) == 8, f"차단 행수 {len(blocked)} ≠ 8"
    for r in blocked:
        verdict, why = BANK_PRECHECK[r["std_id"]]
        add_note(r, f"무통장 선검증: {verdict} — {why}")
        log[f"bank_{verdict[:2]}"] += 1

    # (4) partial 「안 되는 부분」
    for r in rows:
        if r["상태"] != "partial":
            continue
        part, src = missing_part(r)
        if part:
            add_note(r, f"안 되는 부분: {part} (출처 {src})")
            log[f"partial_{src}"] += 1
        else:
            add_note(r, f"안 되는 부분: 미확인 — 근거·비고 어디에도 결손 표기가 없다 · "
                        f"{PLACE.get(r['대분류'], '라이브 화면')} 1회 점검으로 닫는다")
            log["partial_미확인"] += 1
        # v2 의 done_criteria 가 「남은 부분 미기재」라고 말하던 행은 그 문장이
        # 더 이상 참이 아니다. 그 행만 문장을 고친다(다른 행은 v2 그대로).
        if r["done_criteria"].startswith("남은 부분 미기재"):
            tail = r["done_criteria"].split("그 뒤 ", 1)
            body = tail[1] if len(tail) == 2 else ""
            shown = part if part else "미확인 — 결손 표기 없음"
            r["done_criteria"] = (f"이미 되는 부분은 확인되고, 남은 부분({shown})이 "
                                 + (body or "1회 관측된다"))
            log["dc_rewrite"] += 1

    # ── 출력 ──────────────────────────────────────────────────────────
    with open(OUT_CSV, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)
    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=1)

    # ── 기계 검증 ─────────────────────────────────────────────────────
    err = []
    if len(rows) != 505:          # 504(v2) + 신설 1행(STD-ORD-030)
        err.append(f"행수 {len(rows)} ≠ 505")
    blank_note_partial = [r["std_id"] for r in rows
                          if r["상태"] == "partial" and "안 되는 부분:" not in r["비고"]]
    untagged_blocked = [r["std_id"] for r in blocked if "무통장 선검증:" not in r["비고"]]
    vals = set(r["오픈차단여부"] for r in rows)
    banned = [(r["std_id"], b) for r in rows for b in BANNED if b in r["done_criteria"]]
    blank_dc = [r["std_id"] for r in rows if not r["done_criteria"].strip()]
    dup = [k for k, v in collections.Counter(r["std_id"] for r in rows).items() if v > 1]
    if blank_note_partial: err.append(f"partial 안-되는-부분 빈칸 {len(blank_note_partial)}")
    if untagged_blocked:   err.append(f"차단행 무통장 표기 누락 {untagged_blocked}")
    if vals != {"작업 항목", "차단(외부)", "오픈 무관", "미판정"}:
        err.append(f"오픈차단여부 값 4종 이탈: {vals}")
    if banned:   err.append(f"금지어 {len(banned)}")
    if blank_dc: err.append(f"done_criteria 빈칸 {len(blank_dc)}")
    if dup:      err.append(f"std_id 중복 {dup}")

    print(f"총 {len(rows)}행 (v2 504 + 신설 {log['new_row']}) · 열 {len(cols)}개(v2 동일)")
    print("★ 행수가 504 → 505 로 늘었다 — L6 생성기·대시보드의 504 는 재실행이 필요하다")
    print("오픈차단여부:", dict(collections.Counter(r["오픈차단여부"] for r in rows)))
    print("상태:", dict(collections.Counter(r["상태"] for r in rows)))
    print("무통장 선검증(차단 8):",
          dict(collections.Counter(BANK_PRECHECK[r["std_id"]][0] for r in blocked)))
    print("partial 안 되는 부분 출처:",
          {k: v for k, v in log.items() if k.startswith("partial_")})
    print("Q2 라이브 실측 반영:", f"{log['live_fact']}행 · 갭 판단 근거 {log['gap_note']}행")
    print("lead 결정 반영:", f"비고 {log['lead_note']}건 · 근거 정정 {log['evidence_fix']}건 · "
          f"done_criteria 재작성 {log['dc_rewrite']}건")
    for lid, fix, why in X_TRACK_PENDING:
        print(f"미반영(원장에 행 없음) {lid}: {fix} — {why}")
    print("검증:", "OK" if not err else "FAIL " + " / ".join(err))
    return 1 if err else 0


if __name__ == "__main__":
    sys.exit(main())
