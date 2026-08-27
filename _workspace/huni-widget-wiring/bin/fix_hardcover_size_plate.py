"""하드커버 계열 — 상품사이즈·판형 연결 + 하드커버링책자-표지 공식 바인딩.

지니 지시(2026-08-27): 「하드커버링책자 판형을 확인해서 "가격테스트"라는 이름으로 판형을
등록해줘 … 먼저 하드커버링 책자가 무엇인지부터 확인한 후에」 → 범위 확정: 「하드커버 계열 전체」
지니 확정: 「면지는 제본에 포함되어서 가격에 반영 안됨」 「제본에 들어가는 MDF + 면지는 가격이 없다」

── 무엇을 고치는가 ─────────────────────────────────────────────────────
사이즈 마스터는 이미 만들어져 있는데 **상품에 연결되지 않았다**.
t_siz_sizes 에 하드커버 전용 사이즈 6종이 살아 있으나 t_prd_product_sizes 연결 0건:
  SIZ_000634 하드커버무선책자 표지A5 390x268   SIZ_000635 하드커버무선책자 표지A4 532x355
  SIZ_000636 하드커버링책자 표지A5   191x253   SIZ_000638 하드커버링책자 표지A4   253x340
  SIZ_000637 하드커버링책자 면지A5   151x213   SIZ_000639 하드커버링책자 면지A4   213x300
치수는 권위 판걸이수 B64~B69 와 정확히 일치한다.

── 판형 근거 (권위 판걸이수 G열=국4절 316x467 · H열=3절 330x660) ────────
  A64 하드커버무선책자 A5  390x268  G64 = 316x467  → SIZ_000499
  A65 하드커버무선책자 A4  532x355  H65 = 330x660  → SIZ_000475  ★ 판형이 다르다
  A66 하드커버링책자 표지A5 191x253  G66 = 316x467  → SIZ_000499
  A67 하드커버링책자 면지A5 151x213  G67 = 316x467  → SIZ_000499
  A68 하드커버링책자 표지A4 253x340  G68 = 316x467  → SIZ_000499
  A69 하드커버링책자 면지A4 213x300  G69 = 316x467  → SIZ_000499
판걸이(F열)는 권위에서도 비어 있으나, 판걸이수는 계산공식집초안 B84
「총내지매수 = 부수 x (페이지수 / 판걸이수)」로 **내지에만** 쓰인다. 표지는 B85·B86
「제작수량 X 단가 X 2」라 판걸이수를 쓰지 않는다.

── 공식 바인딩은 하드커버링책자-표지 1건뿐 ────────────────────────────
권위 상품마스터 「책자」:
  38행 하드커버책자      표지 = 전용지 + 무광코팅(단면) + 디지털인쇄
  42행 레더 하드커버책자  표지 = 레더(화이트) + **특수인쇄** + 코팅 없음
  46행 하드커버 링책자    표지 = 전용지 + 무광코팅(단면) + 디지털인쇄
하드커버무선 계열(38·42행)의 표지는 부모 공식 COMP_HC_MUSEON_COVERBIND
「표지+제본 합산(권당)」이 이미 청구한다 → 공식 바인딩은 이중청구가 된다. 사이즈만 연결한다.
하드커버트윈링(46행)은 부모가 COMP_BIND_HC_TWINRING 「제본비」뿐이고
권위 가격표 「제본」 E14 「표지비용 따로 계산」이 명시되므로 표지 공식이 필요하다.

참조 모델: PRD_000290 무선책자-표지 — 전용 사이즈 2 + 판형 2(item_siz_cd 로 사이즈↔판형 연결) + PRF_BOOK_COVER.

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_hardcover_size_plate.py
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
NOTE = "가격테스트"
APPLY_YMD = "2026-06-01"

PLATE_K4 = "SIZ_000499"    # 316x467 국4절
PLATE_3J = "SIZ_000475"    # 330x660 3절

# (prd_cd, 이름, [(상품사이즈, 판형)], 바인딩할 공식 or None, 근거)
PLAN = [
    ("PRD_000083", "하드커버링책자-표지",
     [("SIZ_000636", PLATE_K4), ("SIZ_000638", PLATE_K4)],
     "PRF_BOOK_COVER",
     "권위 46행 전용지+무광코팅(단면)+디지털인쇄 · 판걸이수 B66/B68·G66/G68 · "
     "제본 E14 「표지비용 따로 계산」"),
    ("PRD_000084", "하드커버링책자-면지",
     [("SIZ_000637", PLATE_K4), ("SIZ_000639", PLATE_K4)],
     None,
     "판걸이수 B67/B69·G67/G69. 지니 확정: MDF+면지는 제본비 포함 → 공식 바인딩 없음"),
    ("PRD_000073", "하드커버책자-표지",
     [("SIZ_000634", PLATE_K4), ("SIZ_000635", PLATE_3J)],
     None,
     "권위 38행 · 판걸이수 B64/G64(국4절)·B65/H65(3절) · "
     "부모 COMP_HC_MUSEON_COVERBIND 가 표지비 합산 → 공식 바인딩 없음"),
    ("PRD_000078", "레더하드커버책자-표지",
     [("SIZ_000634", PLATE_K4), ("SIZ_000635", PLATE_3J)],
     None,
     "권위 42행 레더(화이트)+특수인쇄+코팅없음 → PRF_BOOK_COVER 부적합. "
     "부모가 표지비 합산 → 공식 바인딩 없음"),
]

HELD = [
    ("PRD_000074", "하드커버책자-면지",
     "권위 판걸이수에 하드커버무선 계열의 면지 사이즈가 없다(A64/A65 는 표지만). "
     "SIZ_000637/639 는 링책자 전용이라 유용할 수 없다"),
    ("PRD_000087", "하드커버링책자-인쇄면지",
     "use_yn='N' + 차원 전무. 면지 계열이라 지니 확정에 따라 가격 불요"),
]


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    mode = "COMMIT(라이브 반영)" if COMMIT else "DRY-RUN(강제 롤백 — DB 안 바뀜)"
    print("=" * 78)
    print(f"하드커버 계열 사이즈·판형 연결   모드: {mode}")
    print("=" * 78)

    print("\n[보류]")
    for cd, nm, why in HELD:
        print(f"  · {cd:14} {nm:22} {why}")

    guard, undo = [], []
    with transaction.atomic():
        for prd, nm, pairs, frm, why in PLAN:
            if not q("SELECT 1 FROM t_prd_products WHERE prd_cd=%s", [prd]):
                guard.append(f"{prd} 상품 실재하지 않음")
                continue
            print(f"\n▸ {prd} {nm}")
            print(f"    근거: {why}")
            before = P.evaluate_price({"prd_cd": prd}, {}, 100, mode="lenient")
            print(f"    교정 전 source={(before.get('base') or {}).get('source')}")

            for seq, (siz, plate) in enumerate(pairs, start=1):
                s = q("""SELECT siz_cd,siz_nm,cut_width,cut_height,COALESCE(del_yn,'N') d
                         FROM t_siz_sizes WHERE siz_cd=%s""", [siz])
                pl = q("""SELECT siz_cd,siz_nm,impos_yn,COALESCE(del_yn,'N') d
                          FROM t_siz_sizes WHERE siz_cd=%s""", [plate])
                if not s or s[0]["d"] == "Y":
                    guard.append(f"{prd}: 상품사이즈 {siz} 없음/삭제")
                    continue
                if not pl or pl[0]["impos_yn"] != "Y" or pl[0]["d"] == "Y":
                    guard.append(f"{prd}: 판형 {plate} 없음/비조판/삭제")
                    continue
                if q("""SELECT 1 FROM t_prd_product_sizes
                        WHERE prd_cd=%s AND siz_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [prd, siz]):
                    print(f"    · 사이즈 {siz} 이미 연결됨 — 건너뜀")
                else:
                    # 참조군(PRD_000290) 형태: 첫 사이즈 dflt_yn='Y' disp_seq=1, 다음 'N' seq=2
                    connection.cursor().execute(
                        """INSERT INTO t_prd_product_sizes
                           (prd_cd,siz_cd,dflt_yn,disp_seq,del_yn)
                           VALUES (%s,%s,%s,%s,'N')""",
                        [prd, siz, "Y" if seq == 1 else "N", seq])
                    undo.append(("t_prd_product_sizes", prd, siz))
                    print(f"    ✓ 사이즈  {siz} {s[0]['siz_nm']} "
                          f"({s[0]['cut_width']}x{s[0]['cut_height']}) "
                          f"dflt={'Y' if seq == 1 else 'N'} seq={seq}")
                # 판형 — 같은 판형이 이미 있으면 재사용, 없으면 등록
                if q("""SELECT 1 FROM t_prd_product_plate_sizes
                        WHERE prd_cd=%s AND siz_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [prd, plate]):
                    print(f"      판형 {plate} 이미 연결됨 — 건너뜀")
                else:
                    dflt = "Y" if plate == PLATE_K4 else "N"
                    item = "" if plate == PLATE_K4 else siz
                    connection.cursor().execute(
                        """INSERT INTO t_prd_product_plate_sizes
                           (prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,item_siz_cd,note,del_yn)
                           VALUES (%s,%s,%s,'OUTPUT_PAPER_TYPE.01',%s,%s,'N')""",
                        [prd, plate, dflt, item, NOTE])
                    undo.append(("t_prd_product_plate_sizes", prd, plate))
                    print(f"    ✓ 판형    {plate} {pl[0]['siz_nm']} "
                          f"dflt={dflt} item_siz_cd='{item}'")

            if frm:
                if q("SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd=%s", [prd]):
                    guard.append(f"{prd}: 이미 공식 바인딩됨")
                elif q("SELECT 1 FROM t_prd_product_prices WHERE prd_cd=%s", [prd]):
                    guard.append(f"{prd}: 이미 상품 직접단가 보유 — 이중청구 위험")
                else:
                    connection.cursor().execute(
                        """INSERT INTO t_prd_product_price_formulas
                           (prd_cd,frm_cd,apply_bgn_ymd) VALUES (%s,%s,%s)""",
                        [prd, frm, APPLY_YMD])
                    undo.append(("t_prd_product_price_formulas", prd, frm))
                    print(f"    ✓ 공식    {frm} (적용일 {APPLY_YMD})")
            else:
                print("    · 공식 바인딩 없음 — 부모가 청구하거나 제본에 포함")

            after = P.evaluate_price({"prd_cd": prd}, {}, 100, mode="lenient")
            print(f"    교정 후 source={(after.get('base') or {}).get('source')}")

        if guard:
            print("\n[중단] 안전장치 발동 — 전체 롤백한다")
            for g in guard:
                print(f"  ✗ {g}")
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
        orphan_siz = q("""SELECT COUNT(*) n FROM t_siz_sizes s
            WHERE s.siz_cd IN ('SIZ_000634','SIZ_000635','SIZ_000636',
                               'SIZ_000637','SIZ_000638','SIZ_000639')
              AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes ps
                              WHERE ps.siz_cd=s.siz_cd AND COALESCE(ps.del_yn,'N')<>'Y')""")[0]["n"]
        print(f"\n[사후 실측] 「가격없음」 배지 = {none_cnt} · 미연결 하드커버 사이즈 = {orphan_siz}/6")

        print("\n[되돌리기 SQL]")
        for tbl, prd, cd in undo:
            col = "frm_cd" if tbl.endswith("formulas") else "siz_cd"
            print(f"  DELETE FROM {tbl} WHERE prd_cd='{prd}' AND {col}='{cd}';")

        if not COMMIT:
            transaction.set_rollback(True)
            print(f"\n결과: DRY-RUN 성공 — {len(undo)}행 적재 가능. 강제 롤백했다.")
        else:
            print(f"\n결과: COMMIT — {len(undo)}행 반영.")


if __name__ == "__main__":
    main()
