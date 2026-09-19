#!/usr/bin/env python3
"""t61 — 김동학(쇼핑개발) 몫 남은 일을 5축으로 배정해 axis-rows.csv 를 만든다.

입력  = t56/rejudge.csv (a83dc44b · 735행) 중 owner_proposed 에 「김동학」이 들어가고
        remaining=Y 인 행 전수.
출력  = t61/axis-rows.csv
규칙  = 기본은 row_id 접두(prefix)로 축을 정하고, 접두만으로 틀리는 행은 OVERRIDE 로
        하나씩 옮긴다(옮긴 이유를 why 열에 남긴다). 리드 5축 초안과 다르게 간 자리는
        why 가 그 근거다. 원장(t56)은 고치지 않는다 — 읽기만 한다.
"""
import csv
import collections
import os

BASE = os.path.dirname(os.path.abspath(__file__))
SS = os.path.dirname(BASE)
SRC = os.path.join(SS, "t56", "rejudge.csv")
OUT = os.path.join(BASE, "axis-rows.csv")

AXIS = {
    "1": "1.탐색·상세+위젯임베드",
    "2": "2.장바구니·주문·결제",
    "3": "3.회원·마이페이지·클레임",
    "4": "4.페이지빌더·정보화면 도구",
    "5": "5.Lightsail 이전·시스템배선",
}

# 접두 → 기본 축
PREFIX = {
    "STD-CAT": "1", "STD-OPT": "1",
    "STD-ORD": "2", "STD-PAY": "2", "STD-B2B": "2", "STD-ART": "2", "STD-PRM": "2",
    "STD-MYP": "3", "STD-CLM": "3", "STD-MEM": "3", "STD-SHP": "3",
    "STD-INF": "4", "STD-ADC": "4", "STD-ADP": "4",
    "STD-SYS": "5", "F4": "5", "T1": "5", "BLK-S4": "5",
    "T3": "3", "T4": "2", "T5": "4",
}

# row_id → (축, 접두 기본을 벗어난 이유)
OVERRIDE = {
    # ── ① 로 올린다 : 위젯↔몰 계약(값 수신 호출부)은 상세 화면의 일부다
    "STD-SYS-023": ("1", "담기 전달값 서명·비노출 = 위젯 handoff 계약(t57 ② 「베끼면 안 되는 것」) — 인프라가 아니라 위젯 임베드 몫"),
    "STD-SYS-041": ("1", "huni_token 텍스트옵션 라벨 = 담기 전달 계약(widget-order.ts:15-18 optionInputs 파싱) — 위젯 임베드 몫"),
    "STD-SYS-045": ("1", "X-Huni-Server-Key 헤더 배선 = 위젯 API 호출부 전제(widget_api.py:195·203-213) — 위젯 임베드 몫"),
    # ── ④ 로 내린다 : 도구·콘텐츠 그릇은 화면이 아니라 페이지빌더 축
    "STD-CAT-019": ("4", "인쇄 가이드 11종 = 가이드북 콘텐츠 그릇(t56 분할: 원고=최숙진/화면·스텁=김동학) — t59 ①과 짝"),
    "STD-CAT-034": ("4", "상세탭 6종 자동 등록 = 탭 그릇 만드는 도구(t56 3분할) — t59 ②와 짝"),
    "STD-SYS-021": ("4", "페이지빌더(운영자 화면 편집) = ④의 본체. ⑤ 인프라 행이 아니다"),
    "STD-SYS-049": ("4", "vc_v_product_detail_tabs 직접 SELECT = 발행본 읽는 배선(publications.ts:85) — 상세탭 도구축"),
    # ── ③ 로 내린다 : 회원·주문 이후 화면
    "STD-SYS-012": ("3", "본인인증 서비스 연동 = 가입·회원정보 경로(STD-MEM-003 과 같은 자리)"),
    "STD-SYS-014": ("3", "택배사 배송추적 연동 = STD-SHP-014 고객 배송조회의 뒷면"),
    # ── ② 로 올린다 : T3 기본값(③)이 틀리는 두 행
    "T3-1": ("2", "회원 장바구니 인증 결함(서버 프록시 토큰) = 담기 경로 본체 — 회원 축이 아니다"),
    "T3-3": ("2", "주문서·결제 결제수단 분기·주문 성립 종단 = ②의 본체"),
    # ── ② 유지하되 근거를 남긴다
    "STD-PRM-007": ("2", "쿠폰 적용은 주문서 금액 확정 경로(order-server /orders/coupons/calculate 신설과 맞물림)"),
    # ── ④ 로 올린다 : 프로모션 중 「콘텐츠·운영 도구」 성격
    "STD-PRM-010": ("4", "기획전/할인 이벤트 페이지 = 페이지빌더로 만드는 콘텐츠 면(STD-ADC-013 배너 관리와 짝)"),
    "STD-PRM-011": ("4", "체험단 모집·신청·당첨·후기 = STD-ADC-016 운영 도구와 한 벌"),
    "STD-PRM-016": ("4", "이용후기 메인(전체 리뷰 모아보기) = 콘텐츠 면"),
    "STD-PRM-017": ("4", "[구IA#71] 체험단관리 = STD-ADC-016 과 같은 안건(중복 가능 · 미실측)"),
}


# 신규 제안(원장 735행에 대응 행이 없다고 판단한 일). 결정은 지니 — 여기까지가 제안이다.
# (축, id, 제목, 근거 path:line 또는 명령, 왜 신규인가)
NEW = [
    ("1", "NEW-M1", "handoff/verify 재검증 호출부 구현(몰 서버 → webadmin)",
     "/Users/innojini/Dev/huni-skin-shopby/src/components/product/huni-widget.tsx:50,78 (주석만) · 수신측 /Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:256",
     "grep -rn 'handoff' src/ → 호출 0건(주석 6건뿐). t48:192 가 plan_row_id=NEW 로 들고 있고 735행 원장에 대응 행 0"),
    ("1", "NEW-M2", "위젯 오리진·site_key 하드코딩을 env 로 승격(3곳)",
     "/Users/innojini/Dev/huni-skin-shopby/src/lib/printly/huni.ts:10,13 · src/app/api/printly/requote/route.ts:15 · src/app/layout.tsx:39-40",
     "migration-plan.md:114 R6 이 「도메인 바뀌면 하드코딩 3곳 연쇄」를 위험으로 적었으나 승격 행이 원장에 0. STD-SYS-052(환경변수 정합)는 누락 키 안건이라 다른 일"),
    ("1", "NEW-M3", "샵바이 상품옵션 신규 경로 채택 판정(option-management-code · options/{optionNo})",
     "t61/spec-latest/product-shop-public.yml(최신본 · 4월 로컬본 대비 +7경로) · huni-mall grep -rF 'option-management-code' src/ → 0건",
     "최신 명세에만 있는 경로라 4월본 기준 원장에는 안건 자체가 없다. 위젯 옵션↔샵바이 옵션 매핑 설계에 영향"),
    ("2", "NEW-M4", "결제 직전 재견적 호출 위치 확정 — 배관은 장바구니에만 있다",
     "/Users/innojini/Dev/huni-skin-shopby/src/components/cart/cart-page.tsx:126,177 (유일한 호출부) · src/app/api/printly/requote/route.ts:15 · src/lib/api/requote.ts:47",
     "STD-ORD-029 는 「미착수」 한 줄이다. 실제로는 프록시 라우트·클라이언트 헬퍼가 이미 있고 **주문서·결제 경로 호출만 0건**이다 — 남은 일의 크기가 원장 표기와 다르다(행 분할 제안)"),
    ("2", "NEW-M5", "나중배송을 샵바이 신규 API(hold-delivery)로 구현할지 판정",
     "t61/spec-latest/order-server-public.yml `/orders/hold-delivery`·`/orders/release-hold-delivery`(최신본 신규) · huni-mall grep -rF 'hold-delivery' src/ → 0건",
     "STD-ORD-015(나중배송)는 4월본에 API 가 없던 시점 판정이라 자체 구현 전제다. 최신본에 경로가 생겨 work_type 이 build→integrate 로 바뀔 수 있다"),
    ("2", "NEW-M6", "쿠폰 경로 교체 — 상품쿠폰 다운로드 2경로가 최신 명세에서 삭제됐다",
     "t61/spec-latest/promotion-shop-public.yml(삭제: /coupons/products/download · /coupons/products/issuable/coupons · 신설: /promotion-configs/coupon) · order-server 신설 /orders/coupons/available·/orders/coupons/calculate · huni-mall grep -rF 5패턴 → 전부 0건",
     "삭제 2경로는 huni-mall 이 아직 안 써서 회귀는 없다. 다만 「상품 쿠폰 받기」 UI 를 설계하기 전에 대체 경로를 확정해야 한다 — 원장 행 0"),
    ("2", "NEW-M7", "앱카드 결제(app-card) 채택 판정",
     "t61/spec-latest/order-server-public.yml `/app-card/available`·`/app-card/payment-key`(최신본 신규) · huni-mall grep -rF 'app-card' src/ → 0건",
     "STD-PAY-001(신용카드 결제)의 구현 선택지가 최신본에서 하나 늘었다. 4월본 기준 원장에는 없는 갈래"),
    ("3", "NEW-M8", "구 사이트 회원 이관 수용 경로(members/external/id) 채택 판정",
     "t61/spec-latest/member-server-public.yml `/members/external/id`(최신본 신규) · huni-mall grep -rF 'members/external/id' src/ → 0건",
     "T3-2 가 「회원 이관 경로 확정」을 안건으로만 들고 있다. 최신본에 외부 ID 조회 경로가 생겨 이관 설계의 갈래가 바뀐다"),
    ("3", "NEW-M9", "마케팅 수신동의 화면(my/marketing-privacy) 배선",
     "t61/spec-latest/member-shop-public.yml `/my/marketing-privacy`(최신본 신규) · huni-mall grep -rF 'marketing-privacy' src/ → 0건",
     "STD-MEM-002(약관 동의)의 마이페이지 쪽 짝이 원장에 0. 수신동의 철회 창구는 오픈 전 법정 요건에 걸린다"),
    ("3", "NEW-M10", "샵바이 알림(SMS·알림톡) 본문 링크 목적지 정합 확인",
     "t56/rejudge.csv STD-SHP-016(provided 판정 · 「연동·확인만 최숙진」) · huni-mall 도메인 shopby.huniprinting.co.kr(migration-plan.md:82)",
     "provided 판정은 「샵바이가 발송한다」까지다. headless 라 알림 본문의 주문조회 링크가 어느 몰을 가리키는지는 별개 — 확인·설정(config) 행이 원장에 0"),
    ("4", "NEW-M11", "상세탭 발행본 미보유 상품의 폴백 정리(핀버튼 샘플·고정 고시값)",
     "/Users/innojini/Dev/huni-skin-shopby/src/components/product/product-sections.tsx:14-46(차별점 핀버튼 카피)·:146-153(유의사항 고정값) · src/app/(main)/product/[slug]/page.tsx:49-56",
     "t59 ②가 콘텐츠(최숙진) 쪽에서 같은 자리를 지적했다. 발행본이 없을 때 **무엇을 띄울지**는 도구·화면 쪽 일이고 그 행이 원장에 0"),
    ("4", "NEW-M12", "페이지빌더 발행본 원천 DB 이전 대응(Railway → Lightsail webapp)",
     "migration-plan.md:52 F2-3(vc_ 2객체 재덤프 → webapp) · /Users/innojini/Dev/huni-skin-shopby/src/lib/printly/publications.ts:85 · _workspace/huni-page-compose/01_recon/pie-canvas-model.md:20(파트너사 Vercel icn1 호스팅)",
     "F2-3 은 **읽는 쪽**(몰)만 옮긴다. **쓰는 쪽**(페이지빌더)이 새 DB 를 계속 쓸 수 있는지 파트너사 확인 행이 원장에 0 — 여기가 끊기면 오픈 후 상세탭 발행이 멈춘다"),
    ("4", "NEW-M13", "게시판 미리보기 신규 경로(boards/{boardNo}/posts/previews) 채택 판정",
     "t61/spec-latest/manage-shop-public.yml `/boards/{boardNo}/posts/previews`(최신본 신규) · 고객 화면 짝 = STD-INF-005·006 · STD-CLM-016·017 · STD-CAT-013",
     "공지·FAQ·Q&A 의 **관리**는 셀러어드민 provided 이고 **고객 화면**은 huni-mall 몫이다. 목록 미리보기 경로가 최신본에 생겨 홈·마이페이지 요약 구현이 쉬워진다 — 4월본 기준 원장에 없는 갈래"),
    ("5", "NEW-M14", "컨테이너 헬스체크 엔드포인트 신설(/api/health)",
     "migration-plan.md:74(「헬스체크 경로(관리서버의 /healthz 같은 것) 없음」) · :79 F4-2(「경로 결정」까지만)",
     "F4-2 는 워크플로 작성 행이고 헬스체크 **구현** 행이 원장에 0. migration-plan.md:79 이 「헬스체크가 /(SSR·DB 조회)이면 DB 장애 = 롤백 루프」를 위험으로 적었다"),
    ("5", "NEW-M15", "도메인 전환 시 위젯 허용도메인(allow_domains) 갱신 요청 — 몰 쪽 행",
     "/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py:709-711(미설정=통과) · raw/webadmin/tools/issue_site_key.py:35-37(site_key 만 UPDATE)",
     "t49:215(위젯 레인)에 등록 도구 부재 행이 있으나 **몰 쪽에서 언제 무엇을 요청해야 하는가**는 원장에 0. 예외가 안 나고 Origin 검사만 조용히 꺼진다"),
    ("5", "NEW-M16", "소셜 3사 콘솔 Redirect URI 변경 요청 창구·시점 확정",
     "migration-plan.md:83 F4-6(검증) · :135(「소셜 3사 콘솔 권한자」 = 외부) · t56/rejudge.csv owner_now=「외부(소셜 3사 콘솔 권한자)」 1행",
     "F4-6 은 「검증」 행이고, 권한자가 외부라 **요청을 누가 언제 넣는가**가 없다. 이게 비면 F4-5 도메인 전환 직후 3사 로그인이 한꺼번에 막힌다"),
]


def axis_of(rid):
    if rid in OVERRIDE:
        return OVERRIDE[rid]
    pre = rid.rsplit("-", 1)[0]
    if pre in PREFIX:
        return PREFIX[pre], ""
    head = rid.split("-")[0]
    if head in PREFIX:
        return PREFIX[head], ""
    raise SystemExit(f"축 미배정 row_id: {rid}")


def main():
    rows = list(csv.DictReader(open(SRC, encoding="utf-8")))
    kd = [r for r in rows
          if "김동학" in (r.get("owner_proposed") or "") and r.get("remaining") == "Y"]
    out = []
    for r in kd:
        a, why = axis_of(r["row_id"])
        out.append({
            "axis": AXIS[a],
            "kind": "원장",
            "row_id": r["row_id"],
            "title": r["title"],
            "kdh_part": r["owner_proposed"],
            "status": r["status"],
            "t56_verdict": r["verdict"],
            "t56_judged_by": r["judged_by"],
            "why": why,
            "evidence": r["evidence"],
        })
    for a, rid, title, ev, why in NEW:
        out.append({
            "axis": AXIS[a],
            "kind": "신규제안",
            "row_id": rid,
            "title": title,
            "kdh_part": "김동학",
            "status": "원장행 없음",
            "t56_verdict": "",
            "t56_judged_by": "t61-manual-read",
            "why": why,
            "evidence": ev,
        })
    out.sort(key=lambda x: (x["axis"], x["kind"] == "신규제안", x["row_id"]))
    with open(OUT, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)
    c = collections.Counter((x["axis"], x["kind"]) for x in out)
    print(f"입력 rejudge.csv = {len(rows)}행 / 김동학·남은일 = {len(kd)}행 / 출력 = {len(out)}행")
    for k in sorted(c):
        print(f"  {k}: {c[k]}")
    print("OVERRIDE(원장 축 이동):", len([x for x in out if x["why"] and x["kind"] == "원장"]), "행")


if __name__ == "__main__":
    main()
