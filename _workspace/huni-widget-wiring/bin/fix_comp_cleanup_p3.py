"""가격구성요소 정리 P3 — 고아 구성요소 논리삭제.

지니 지시(§G''.4 큐 1번): P3 고아 정리. 「대체 comp 실효 확인 선행 필수」.
선행 확인은 audit_orphan_p3.py 가 수행했고, 그 결과 M1-1K §C 분류가 1건 반증됐다.

판정 근거([HARD] 1 — 기준점은 실무진 상품뷰어 등록):
  · [레거시] 6 — 대체 2종이 52/52 사이즈 격자를 전량 커버 + 6개 공식 1:1 대응
  · 보드류 4 — 대체 BOARD 4행이 실무진 등록 자재 4종과 값까지 완전 일치
                (고아의 A1 20,000 은 실무진 미등록 축)
  · PET거치대 3 — 대체 SEL 2행이 실무진 등록 자재 2종(실내/실외)과 일치
                  (고아의 「양면용」은 실무진 미등록 축)
  · 빈껍데기 2 — 단가행 0 · 공식 미연결
  · CEILHOOK 1 — P2 에서 공식 분리 완료. 추가상품 템플릿 TMPL-000096 으로 이전됨

제외(M1-1K §C 반증):
  · COMP_CUT_FULL_DIECUT — 「빈껍데기(단가행 0)」로 분류됐으나 실측은
    공식 2개(PRF_DGP_B 상품2 · PRF_DGP_F 상품1) 연결 + 단가행 72. 살아있다.

논리삭제 관례(라이브 실측): use_yn='N' + del_yn='Y' + del_dt=now().
되돌리기: UPDATE … SET use_yn=<원값>, del_yn='N', del_dt=NULL WHERE comp_cd=…

기본 모드는 DRY-RUN(강제 롤백). 적재는 --commit + 인간 승인.

실행: raw/webadmin/.venv/bin/python _workspace/huni-widget-wiring/bin/fix_comp_cleanup_p3.py
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

COMMIT = "--commit" in sys.argv

TARGETS = [
    ("COMP_POSTER_ADH_WATERPROOF_PVC", "[레거시]", "대체 ARTPRINT_PHOTO 52/52 커버 · PRF_POSTER_ADH_WP 연결"),
    ("COMP_POSTER_ARTFABRIC_GRAPHIC", "[레거시]", "대체 ARTPRINT_PHOTO 52/52 커버 · PRF_POSTER_ARTFABRIC 연결"),
    ("COMP_POSTER_LEATHER_ARTPRINT", "[레거시]", "대체 CANVAS_FABRIC 52/52 커버 · PRF_POSTER_LEATHER_AP 연결"),
    ("COMP_POSTER_MESH_PRINT", "[레거시]", "대체 CANVAS_FABRIC 52/52 커버 · PRF_POSTER_MESH 연결"),
    ("COMP_POSTER_TYVEK_PRINT", "[레거시]", "대체 CANVAS_FABRIC 52/52 커버 · PRF_POSTER_TYVEK 연결"),
    ("COMP_POSTER_WATERPROOF_PET", "[레거시]", "대체 ARTPRINT_PHOTO 52/52 커버 · PRF_POSTER_WATERPROOF 연결"),
    ("COMP_POSTER_FOAMBOARD_BLACK", "보드류", "대체 BOARD A3블랙8500·A2블랙14000 값 일치"),
    ("COMP_POSTER_FOAMBOARD_WHITE", "보드류", "대체 BOARD A3화이트6000·A2화이트12000 값 일치(A1 은 실무진 미등록)"),
    ("COMP_POSTER_FOMEXBOARD_WHITE3MM", "보드류", "대체 BOARD A3 3mm 8500·A2 3mm 13000 값 일치"),
    ("COMP_POSTER_FOMEXBOARD_WHITE5MM", "보드류", "대체 BOARD A3 5mm 10000·A2 5mm 16000 값 일치"),
    ("COMP_POSTEROPT_PET_BANNER_STAND_IN", "PET거치대", "대체 SEL 실내용거치대(MAT_000409) 로 승계"),
    ("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1", "PET거치대", "대체 SEL 실외용거치대(MAT_000410) 23000 값 일치"),
    ("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2", "PET거치대", "「양면용」은 실무진 미등록 축 — 구세대 잔존"),
    ("COMP_POPT_BNR_GAKMOK_STR_900_4", "빈껍데기", "단가행 0 · use_dims 없음 · 공식 미연결"),
    ("COMP_POSTEROPT_BANNER_MESH_PROC_OPT", "빈껍데기", "단가행 0 · 공식 미연결"),
    ("CUT_FULL_DIECUT", "빈껍데기", "단가행 0 · 공식 미연결. 접두사 있는 COMP_CUT_FULL_DIECUT 과 별개 코드"),
    ("COMP_POSTEROPT_JOKJA_CEILHOOK", "축이전완료", "P2 에서 공식 분리 완료 · TMPL-000096(6,500) 로 이전"),
]

# 이름이 비슷하지만 P3 대상이 아닌 것 — 접두사 한 글자 차이로 오삭제하기 쉬운 함정
EXCLUDED = {
    "COMP_CUT_FULL_DIECUT": "'커팅 완제품가 완칼(모양엽서·라벨택)' — 공식 2개(PRF_DGP_B·PRF_DGP_F) "
                            "연결 + 단가행 72. 살아있다. P3 대상은 접두사 없는 CUT_FULL_DIECUT",
}


def q(sql, params=None):
    c = connection.cursor()
    c.execute(sql, params or [])
    cols = [d[0] for d in c.description]
    return [dict(zip(cols, r)) for r in c.fetchall()]


def main():
    mode = "COMMIT(라이브 반영)" if COMMIT else "DRY-RUN(강제 롤백 — DB 안 바뀜)"
    print("=" * 78)
    print(f"정리 P3 — 고아 가격구성요소 논리삭제   모드: {mode}")
    print("=" * 78)

    for cd, why in EXCLUDED.items():
        print(f"[제외] {cd}\n        {why}")

    backup = []
    guard_fail = []

    print(f"\n[대상] {len(TARGETS)}종")
    with transaction.atomic():
        for cd, kind, reason in TARGETS:
            cur = q("""SELECT comp_cd, comp_nm, use_yn, COALESCE(del_yn,'N') del_yn
                       FROM t_prc_price_components WHERE comp_cd=%s""", [cd])
            if not cur:
                guard_fail.append((cd, "실재하지 않음"))
                continue
            r = cur[0]
            # 안전장치 — 삭제 직전 재확인: 정말 공식 미연결인가
            nfrm = q("SELECT COUNT(*) n FROM t_prc_formula_components WHERE comp_cd=%s", [cd])[0]["n"]
            if nfrm:
                guard_fail.append((cd, f"공식 {nfrm}개에 연결됨 — 삭제 중단"))
                continue
            if r["del_yn"] == "Y":
                print(f"  · {cd:44} 이미 삭제됨 — 건너뜀")
                continue
            backup.append((cd, r["use_yn"], r["del_yn"]))
            connection.cursor().execute(
                """UPDATE t_prc_price_components
                   SET use_yn='N', del_yn='Y', del_dt=now() WHERE comp_cd=%s""", [cd])
            print(f"  ✓ {cd:44} [{kind}] {r['comp_nm']}")
            print(f"      근거: {reason}")

        if guard_fail:
            print("\n[중단] 안전장치 발동 — 아래 항목 때문에 전체 롤백한다")
            for cd, why in guard_fail:
                print(f"  ✗ {cd}: {why}")
            transaction.set_rollback(True)
            print("\n결과: 롤백. DB 변경 없음.")
            return

        after = q("""SELECT COUNT(*) n FROM t_prc_price_components
                     WHERE COALESCE(del_yn,'N')='N'""")[0]["n"]
        orphan = q("""SELECT COUNT(*) n FROM t_prc_price_components c
                      WHERE COALESCE(c.del_yn,'N')='N'
                        AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components f
                                        WHERE f.comp_cd=c.comp_cd)""")[0]["n"]
        print(f"\n[사후 실측] 미삭제 구성요소 {after} · 그중 고아 {orphan}")

        print("\n[되돌리기 SQL]")
        for cd, use_yn, del_yn in backup:
            print(f"  UPDATE t_prc_price_components SET use_yn='{use_yn}', "
                  f"del_yn='{del_yn}', del_dt=NULL WHERE comp_cd='{cd}';")

        if not COMMIT:
            transaction.set_rollback(True)
            print(f"\n결과: DRY-RUN 성공 — {len(backup)}종 논리삭제 가능. 강제 롤백했다.")
        else:
            print(f"\n결과: COMMIT — {len(backup)}종 논리삭제 반영.")


if __name__ == "__main__":
    main()
