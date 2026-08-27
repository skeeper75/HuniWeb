"""하드커버링책자-표지 판형 등록 + 공식 바인딩.

지니 지시(2026-08-27): 「하드커버링책자 판형을 확인해서 "가격테스트"라는 이름으로 판형을
등록해줘. 판형으로 등록했던 부분들을 찾아줘. 판걸이수, 출력소재시트를 확인해서 먼저
하드커버링 책자가 무엇인지부터 확인한 후에 진행해야할 것 같아」
지니 확정(2026-08-27): 「면지는 제본에 포함되어서 가격에 반영 안됨」
                      「제본에 들어가는 MDF + 면지는 가격이 없다」
  ⇒ 하드커버 제본비 COMP_BIND_HC_TWINRING(7,000~30,000)이 심재(MDF)와 면지를 안는다.
    표지만 「전용지 + 무광코팅」 인쇄물이라 따로 계산된다 —
    권위 가격표 260822_1 「제본」 E14 「표지비용 따로 계산」과 정합한다.

── 선행 확인 결과 ───────────────────────────────────────────────────────
하드커버 링책자가 무엇인가 — 상품마스터 260822_1 「책자」 46행(ID 14598 · MES 006-0007):
  트윈링책자(33행)의 하드커버 판. 표지 = 전용지 + 무광코팅(단면) + 단면인쇄,
  면지 = 화이트면지, 제본 = 하드커버트윈링제본.
  ★ 권위 원본에서 표지·면지의 MES ITEM_CD·블리드·작업사이즈가 비어 있다
    (트윈링책자 33행은 R33/S33/T33 이 채워져 있다) — 권위 자체가 미완성이다.

판형 근거 — 권위 판걸이수 시트 A66~A69:
  A66 하드커버링책자 표지 A5  재단 191x253  블리드 0  G66 = 316x467
  A68 하드커버링책자 표지 A4  재단 253x340  블리드 0  G68 = 316x467
  G열 = 「디지털인쇄(국4절) 316x467」 = 라이브 SIZ_000499.
  ⇒ 권위가 판형을 이미 지정하고 있다. 새 사이즈를 채번하지 않는다(search-before-mint).
  비어 있는 것은 F열(판걸이 수)뿐이며, 판걸이수는 권위 계산공식집초안 B84
  「총내지매수 = 부수 x (페이지수 / 판걸이수)」로 **내지에만** 쓰인다.
  표지는 B85·B86 「제작수량 X 단가 X 2」라 판걸이수를 쓰지 않는다.

기존 판형 등록 실태 — t_prd_product_plate_sizes 80행 / 77상품 / 사이즈 5종:
  SIZ_000499(316x467) 61상품 · SIZ_000521(330x470) 12 · SIZ_000475(330x660) 4 ·
  SIZ_000641(480x320) 2 · SIZ_000535(330x540) 1. 책자 계열은 전부 SIZ_000499.

대상의 결손은 판형 하나뿐 — 공정(PROC_000004 디지털인쇄 · PROC_000015 무광라미)과
인쇄옵션(POPT_000001 단면)은 이미 등록돼 있고, 세 구성요소의 SIZ_000499 단가행도 실재한다:
  COMP_PAPER 아트지150g 46.65 · COMP_PRINT_DIGITAL_S1 단면 4000~1700 ·
  COMP_COAT_MATTE 단면 2000~800.
  (권위 X46 「전용지」 = 출력소재 F100 「아트150」 = 라이브 MAT_000078 아트지 150g)

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_hcring_cover_plate.py
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

PRD = "PRD_000083"          # 하드커버링책자-표지
PLATE = "SIZ_000499"        # 316x467 — 권위 판걸이수 G66/G68
FRM = "PRF_BOOK_COVER"      # 디지털인쇄비 + 무광코팅비 + 용지비
APPLY_YMD = "2026-06-01"    # 참조군(중철·무선·PUR)과 동일
NOTE = "가격테스트"           # 지니 지시 — 이 등록의 표식

# 손대지 않는다 — 지니 확정 + 권위 대조 결과
UNTOUCHED = [
    ("PRD_000084", "하드커버링책자-면지",
     "지니 확정: MDF + 면지는 제본비에 포함되어 가격이 없다. 가격없음이 정상"),
    ("PRD_000087", "하드커버링책자-인쇄면지",
     "면지 계열 + use_yn='N' + 차원 전무. 지니 확정에 따라 보류"),
]


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    mode = "COMMIT(라이브 반영)" if COMMIT else "DRY-RUN(강제 롤백 — DB 안 바뀜)"
    print("=" * 78)
    print(f"하드커버링책자-표지 판형 등록 + 공식 바인딩   모드: {mode}")
    print("=" * 78)

    print("\n[손대지 않는다]")
    for cd, nm, why in UNTOUCHED:
        print(f"  · {cd:14} {nm:22} {why}")

    guard = []
    with transaction.atomic():
        # 안전장치 1 — 대상 실재
        if not q("SELECT prd_cd FROM t_prd_products WHERE prd_cd=%s", [PRD]):
            guard.append(f"상품 {PRD} 실재하지 않음")
        # 안전장치 2 — 판형 사이즈 실재 + 조판용인가
        plate = q("""SELECT siz_cd,siz_nm,work_width,work_height,impos_yn,COALESCE(del_yn,'N') d
                     FROM t_siz_sizes WHERE siz_cd=%s""", [PLATE])
        if not plate:
            guard.append(f"판형 {PLATE} 실재하지 않음")
        elif plate[0]["impos_yn"] != "Y":
            guard.append(f"판형 {PLATE} 이 조판용(impos_yn=Y)이 아님")
        elif plate[0]["d"] == "Y":
            guard.append(f"판형 {PLATE} 이 삭제 상태")
        # 안전장치 3 — 이미 등록돼 있으면 중단(중복 방지)
        if q("""SELECT 1 FROM t_prd_product_plate_sizes
                WHERE prd_cd=%s AND siz_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [PRD, PLATE]):
            guard.append("판형이 이미 등록돼 있음")
        if q("SELECT 1 FROM t_prd_product_price_formulas WHERE prd_cd=%s", [PRD]):
            guard.append("이미 공식이 바인딩돼 있음")
        if q("SELECT 1 FROM t_prd_product_prices WHERE prd_cd=%s", [PRD]):
            guard.append("이미 상품 직접단가 보유 — 이중청구 위험")

        if guard:
            print("\n[중단] 안전장치 발동 — 전체 롤백한다")
            for g in guard:
                print(f"  ✗ {g}")
            transaction.set_rollback(True)
            print("\n결과: 롤백. DB 변경 없음.")
            return

        before = P.evaluate_price({"prd_cd": PRD}, {}, 100, mode="lenient")
        print(f"\n[교정 전] source={(before.get('base') or {}).get('source')} "
              f"amount={(before.get('base') or {}).get('amount')}")

        pl = plate[0]
        print(f"\n① 판형 등록  {PRD} → {PLATE} ({pl['siz_nm']} · 작업 "
              f"{pl['work_width']}x{pl['work_height']} · 조판 {pl['impos_yn']})")
        print("     dflt_plt_yn='Y' · output_paper_typ_cd='OUTPUT_PAPER_TYPE.01' "
              "(참조 PRD_000288 중철책자-표지와 동형)")
        print(f"     note='{NOTE}'")
        connection.cursor().execute(
            """INSERT INTO t_prd_product_plate_sizes
               (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd, item_siz_cd, note, del_yn)
               VALUES (%s,%s,'Y','OUTPUT_PAPER_TYPE.01','',%s,'N')""", [PRD, PLATE, NOTE])

        print(f"\n② 공식 바인딩  {PRD} → {FRM} (적용일 {APPLY_YMD})")
        connection.cursor().execute(
            """INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd)
               VALUES (%s,%s,%s)""", [PRD, FRM, APPLY_YMD])

        after = P.evaluate_price({"prd_cd": PRD}, {}, 100, mode="lenient")
        print(f"\n[교정 후] source={(after.get('base') or {}).get('source')} "
              f"amount={(after.get('base') or {}).get('amount')}")
        print("   ※ 빈 선택값 호출이라 금액 0 은 참조군도 동일하다 — 판정 근거로 쓰지 않는다")

        # 구성요소 3종이 이 상품의 등록 차원으로 매칭되는지 — 단가행 실재 대조
        print("\n[구성요소 단가행 대조] 등록 차원 ∩ 단가행")
        for comp in ("COMP_PRINT_DIGITAL_S1", "COMP_COAT_MATTE", "COMP_PAPER"):
            rows = q("""SELECT COUNT(*) n FROM t_prc_component_prices cp
                        WHERE cp.comp_cd=%s AND cp.plt_siz_cd=%s
                          AND (cp.proc_cd IS NULL OR cp.proc_cd IN
                               (SELECT proc_cd FROM t_prd_product_processes
                                WHERE prd_cd=%s AND COALESCE(del_yn,'N')<>'Y'))
                          AND (cp.print_opt_cd IS NULL OR cp.print_opt_cd IN
                               (SELECT print_opt_cd FROM t_prd_product_print_options
                                WHERE prd_cd=%s AND COALESCE(del_yn,'N')<>'Y'))
                          AND (cp.mat_cd IS NULL OR cp.mat_cd IN
                               (SELECT mat_cd FROM t_prd_product_materials
                                WHERE prd_cd=%s AND COALESCE(del_yn,'N')<>'Y'))
                     """, [comp, PLATE, PRD, PRD, PRD])[0]["n"]
            mark = "✓" if rows else "✗"
            print(f"   {mark} {comp:24} 매칭 단가행 {rows}")

        none_cnt = q("""
            WITH prods AS (SELECT prd_cd FROM t_prd_products WHERE COALESCE(del_yn,'N')<>'Y'),
                 hp AS (SELECT DISTINCT prd_cd FROM t_prd_product_prices),
                 hf AS (SELECT DISTINCT prd_cd FROM t_prd_product_price_formulas)
            SELECT COUNT(*) n FROM prods p
            WHERE p.prd_cd NOT IN (SELECT prd_cd FROM hp)
              AND p.prd_cd NOT IN (SELECT prd_cd FROM hf)""")[0]["n"]
        print(f"\n[사후 실측] 「가격없음」 배지 = {none_cnt}")

        print("\n[되돌리기 SQL]")
        print(f"  DELETE FROM t_prd_product_price_formulas WHERE prd_cd='{PRD}' "
              f"AND apply_bgn_ymd='{APPLY_YMD}';")
        print(f"  DELETE FROM t_prd_product_plate_sizes WHERE prd_cd='{PRD}' "
              f"AND siz_cd='{PLATE}';")

        if not COMMIT:
            transaction.set_rollback(True)
            print("\n결과: DRY-RUN 성공 — 강제 롤백했다.")
        else:
            print("\n결과: COMMIT — 판형 1행 + 바인딩 1행 반영.")


if __name__ == "__main__":
    main()
