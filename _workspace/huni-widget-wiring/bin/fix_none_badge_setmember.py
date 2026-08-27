"""「가격없음」 교정 — 셋트 구성원 반제품에 권위 공식 바인딩.

지니 지시(2026-08-27): 「가격뷰어에서 가격없음으로 되어있는 것을 확인해서 …
연결해서 가격없음이라는 부분을 제거해줘」 → 「결함만 먼저 교정 · 명세까지, 적재는 승인 후」.

배지 로직(price_views.py:667-675): 「가격없음」 = t_prd_product_prices 도 없고
t_prd_product_price_formulas 도 없는 상품. 추가상품 템플릿 직접단가와 할인율은
배지에 영향하지 않는다.

권위(상품마스터 260822_1 「계산공식집초안」)
  B81~B89 [원자합산형: 하드커버링책자]
    판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 면지인쇄비 + 면지코팅비 + 용지비 + 제본비
  B72~B78 [원자합산형: 트윈링책자]
    판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비
  B63~B70 [원자합산형: 중철/무선/PUR/하드커버무선]
    판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비
    ★ 면지 항목이 없다 → 하드커버무선 계열의 면지는 교정 대상이 아니다.
  가격표 260822_1 「제본」 E14 = 「표지비용 따로 계산」

라이브 참조 모델(정상군 — search-before-mint: 새 공식을 만들지 않는다)
  중철/무선/PUR 책자: 내지 → PRF_DGP_INNER · 표지 → PRF_BOOK_COVER
  PRF_BOOK_COVER = 디지털인쇄비 + 무광코팅비 + 용지비 (권위 (3)(4)+용지비 대응)

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_none_badge_setmember.py
"""
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "raw", "webadmin", "webadmin"))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

from dotenv import load_dotenv  # noqa: E402
load_dotenv(os.path.join(ROOT, "raw", "webadmin", ".env"))

import django  # noqa: E402
django.setup()

from django.db import connection, transaction  # noqa: E402
from catalog import pricing as P  # noqa: E402

COMMIT = "--commit" in sys.argv
APPLY_YMD = "2026-06-01"   # 참조군(중철·무선·PUR)과 동일 적용일

# 바인딩 대상 — 차원이 이미 갖춰져 바인딩만으로 가격이 나오는 건
BIND = [
    ("PRD_000310", "트윈링책자-표지", "PRF_BOOK_COVER",
     "권위 B76·B77 표지인쇄비+표지코팅비. 참조 PRD_000288/290 과 동형"),
    ("PRD_000311", "트윈링책자-내지", "PRF_DGP_INNER",
     "권위 B74 내지인쇄비. 참조 PRD_000287/289/291 과 동형. "
     "부모 PRD_000071·PRD_000082 가 공유한다"),
]

# 차원 선행 등록이 필요해 이번 배치에서 제외 — 실무진 등록이 축의 권위([HARD] 1)
BLOCKED = [
    ("PRD_000083", "하드커버링책자-표지", "판형(plt_siz_cd) 미등록 — PRF_BOOK_COVER 3개 구성요소가 "
     "전부 plt_siz_cd 를 요구한다. 권위 판걸이수 A66/A68 도 판걸이(F열)가 비어 있다"),
    ("PRD_000084", "하드커버링책자-면지", "판형·공정·인쇄옵션 전부 미등록. 권위 판걸이수 A67/A69 동일"),
    ("PRD_000087", "하드커버링책자-인쇄면지", "차원 전무 + use_yn='N'"),
]

# 결함 아님으로 판정 — 값을 넣으면 이중청구
NOT_DEFECT = [
    ("PRD_000073", "하드커버책자-표지", "부모 공식 COMP_HC_MUSEON_COVERBIND 가 「표지+제본 합산(권당)」 — 표지 포함"),
    ("PRD_000078", "레더하드커버책자-표지", "〃"),
    ("PRD_000074", "하드커버책자-면지", "권위 B64 하드커버무선 판매가에 면지 항목이 없다"),
    ("PRD_000301/302", "스프링노트 표지·내지", "부모 COMP_STN_SPRINGNOTE 「완제품가」 4,500 — 전액 포함"),
    ("PRD_000305/306", "메모패드 표지·내지", "부모 COMP_STN_MEMOPAD 「완제품가」 5,000~6,000"),
    ("PRD_000307/308", "중철노트 표지·내지", "부모 COMP_STN_JUNGCHEOL 「완제품가」 2,500"),
    ("PRD_000095/096", "엽서북 내지·표지", "부모 COMP_PCB 「완제품가」 468행"),
]


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def probe(prd_cd):
    """바인딩 후 실제로 가격이 나오는지 엔진 실호출로 확증한다([HARD] 5)."""
    r = P.evaluate_price({"prd_cd": prd_cd}, {}, 100, mode="lenient")
    base = r.get("base") or {}
    return base.get("source"), base.get("amount"), (r.get("warnings") or [])[:1]


def main():
    mode = "COMMIT(라이브 반영)" if COMMIT else "DRY-RUN(강제 롤백 — DB 안 바뀜)"
    print("=" * 78)
    print(f"「가격없음」 교정 — 셋트 구성원 공식 바인딩   모드: {mode}")
    print("=" * 78)

    print("\n[결함 아님 — 손대지 않는다]")
    for cd, nm, why in NOT_DEFECT:
        print(f"  · {cd:18} {nm:22} {why}")

    print("\n[차원 선행 필요 — 이번 배치 제외]")
    for cd, nm, why in BLOCKED:
        print(f"  ✗ {cd:18} {nm:22} {why}")

    print(f"\n[바인딩 대상] {len(BIND)}종")
    backup, guard_fail = [], []

    with transaction.atomic():
        for cd, nm, frm, why in BIND:
            prd = q("SELECT prd_cd,prd_nm,use_yn FROM t_prd_products WHERE prd_cd=%s", [cd])
            if not prd:
                guard_fail.append((cd, "상품 실재하지 않음"))
                continue
            if not q("SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd=%s", [frm]):
                guard_fail.append((cd, f"공식 {frm} 실재하지 않음"))
                continue
            # 안전장치 — 이미 가격소스가 있으면 건드리지 않는다(이중청구 방지)
            if q("SELECT 1 FROM t_prd_product_prices WHERE prd_cd=%s", [cd]):
                guard_fail.append((cd, "이미 상품 직접단가 보유 — 바인딩 중단"))
                continue
            cur = q("SELECT frm_cd,apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd=%s", [cd])
            if cur:
                guard_fail.append((cd, f"이미 공식 바인딩됨: {cur}"))
                continue

            before = probe(cd)
            connection.cursor().execute(
                """INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd)
                   VALUES (%s,%s,%s)""", [cd, frm, APPLY_YMD])
            after = probe(cd)
            backup.append(cd)
            print(f"\n  ✓ {cd} {nm}  →  {frm}")
            print(f"      근거: {why}")
            print(f"      교정 전: source={before[0]} amount={before[1]}")
            print(f"      교정 후: source={after[0]} amount={after[1]} {after[2]}")

        if guard_fail:
            print("\n[중단] 안전장치 발동 — 전체 롤백한다")
            for cd, why in guard_fail:
                print(f"  ✗ {cd}: {why}")
            transaction.set_rollback(True)
            print("\n결과: 롤백. DB 변경 없음.")
            return

        none_cnt = q("""
            WITH prods AS (SELECT prd_cd FROM t_prd_products WHERE COALESCE(del_yn,'N')<>'Y'),
                 hp AS (SELECT DISTINCT prd_cd FROM t_prd_product_prices),
                 hf AS (SELECT DISTINCT prd_cd FROM t_prd_product_price_formulas)
            SELECT COUNT(*) n FROM prods p
            WHERE p.prd_cd NOT IN (SELECT prd_cd FROM hp)
              AND p.prd_cd NOT IN (SELECT prd_cd FROM hf)""")[0]["n"]
        print(f"\n[사후 실측] 「가격없음」 배지 = {none_cnt} (교정 전 47)")

        print("\n[되돌리기 SQL]")
        for cd in backup:
            print(f"  DELETE FROM t_prd_product_price_formulas WHERE prd_cd='{cd}' "
                  f"AND apply_bgn_ymd='{APPLY_YMD}';")

        if not COMMIT:
            transaction.set_rollback(True)
            print(f"\n결과: DRY-RUN 성공 — {len(backup)}종 바인딩 가능. 강제 롤백했다.")
        else:
            print(f"\n결과: COMMIT — {len(backup)}종 바인딩 반영.")


if __name__ == "__main__":
    main()
