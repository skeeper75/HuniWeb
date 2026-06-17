#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_naming_sql.py — 가격구성요소 comp_nm/note 네이밍 표준화 적재 SQL 생성기 (round-34)

권위(verbatim):
  - 34_naming-standardization/component-naming-cleanup.md  (v2 — 치환안)
  - 34_naming-standardization/standard-term-dictionary.md   (v2 — 표준 용어)
  - 34_naming-standardization/naming-domain-refinement.md   (컨펌 3건 해소·후니 고유용어)

원칙(HARD):
  - comp_nm / note 만 UPDATE. component_prices·use_yn·배선 무변경. INSERT/DELETE 0.
  - 모든 UPDATE는 멱등 가드: comp_nm/note IS DISTINCT FROM 목표 → 2회차 0행.
  - 표준 용어는 cleanup v2/dictionary v2/refinement 확정 문안 verbatim. 추정 0.
  - 코드(`[COMP_xxx]`) 노출 0이 목표.
  - 손편집 금지 — 이 생성기가 apply.sql / dryrun.sql / backup_undo.sql 의 mapping 블록을 산출.

산출:
  python3 gen_naming_sql.py
    → 매핑 검증 후 stdout 에 SQL UPDATE 블록(멱등 가드)을 출력.
  생성된 블록은 apply.sql / dryrun.sql 에 그대로 임베드된다(생성기 = 단일 사실원).

NOTE: 본 생성기는 DB에 접속하지 않는다. 라이브 실측(현재값·use_yn·가격행수)은 별도 SELECT로
      dryrun.sql / backup_undo.sql 에서 수행한다. 여기서는 comp_cd → 목표값 매핑의 재현성만 보장한다.
"""

import sys

# ---------------------------------------------------------------------------
# MAPPING — cleanup v2 치환안 verbatim. 각 엔트리:
#   comp_cd : (new_comp_nm 또는 None, new_note 또는 None, src_section)
#   new_comp_nm/new_note 가 None 이면 해당 컬럼 무변경.
# 모든 한글 문안은 cleanup v2 / dictionary v2 / refinement 에서 그대로 복사.
# ---------------------------------------------------------------------------

NAME = {}  # comp_cd -> dict(comp_nm=, note=, src=)

def m(comp_cd, comp_nm=None, note=None, src=""):
    NAME[comp_cd] = {"comp_nm": comp_nm, "note": note, "src": src}

# === A-1. 명함 완제품가 (19) — cleanup §A-1 ===
m("COMP_NAMECARD_STD_S1",  "스탠다드명함 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_STD_S2",  "스탠다드명함 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_COAT_S1", "코팅명함 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_COAT_S2", "코팅명함 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_CLEAR_S1", "투명명함 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_PEARL_S1", "펄명함(스타드림) 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_PEARL_S2", "펄명함(스타드림) 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_PREMIUM_S1_MGA", "프리미엄명함A 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_PREMIUM_S1_MGB", "프리미엄명함B 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_PREMIUM_S2_MGA", "프리미엄명함A 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_PREMIUM_S2_MGB", "프리미엄명함B 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_SHAPE_S1", "모양명함 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_SHAPE_S2", "모양명함 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_MINISHAPE_S1", "미니모양명함 완제품가 단면(용지포함)", src="A-1")
m("COMP_NAMECARD_MINISHAPE_S2", "미니모양명함 완제품가 양면(용지포함)", src="A-1")
m("COMP_NAMECARD_WHITE_S1W_CL",   "화이트인쇄명함 완제품가 단면·코팅(용지포함)", src="A-1")
m("COMP_NAMECARD_WHITE_S1W_NOCL", "화이트인쇄명함 완제품가 단면·무코팅(용지포함)", src="A-1")
m("COMP_NAMECARD_WHITE_S2W_CL",   "화이트인쇄명함 완제품가 양면·코팅(용지포함)", src="A-1")
m("COMP_NAMECARD_WHITE_S2W_NOCL", "화이트인쇄명함 완제품가 양면·무코팅(용지포함)", src="A-1")

# === A-2. 오리지널박명함 (4) — cleanup §A-2 ===
m("COMP_NAMECARD_FOIL_S1_STD",  "오리지널박명함 완제품가 단면·일반박(종이+동판+박)", src="A-2")
m("COMP_NAMECARD_FOIL_S1_HOLO", "오리지널박명함 완제품가 단면·홀로그램/트윙클(종이+동판+박)", src="A-2")
m("COMP_NAMECARD_FOIL_S2_STD",  "오리지널박명함 완제품가 양면·일반박(종이+동판+박)", src="A-2")
m("COMP_NAMECARD_FOIL_S2_HOLO", "오리지널박명함 완제품가 양면·홀로그램/트윙클(종이+동판+박)", src="A-2")

# === A-3. 박·형압 동판셋업비 (2) — cleanup §A-3 ===
m("COMP_NAMECARD_FOIL_SETUP_S1_STD", "박·형압 동판셋업비 단면", src="A-3")
m("COMP_NAMECARD_FOIL_SETUP_S2_STD", "박·형압 동판셋업비 양면", src="A-3")

# === A-4. 제본비 (8 코드노출) — cleanup §A-4 ===
m("COMP_BIND_JUNGCHEOL",   "제본비 중철", src="A-4")
m("COMP_BIND_MUSEON",      "제본비 무선", src="A-4")
m("COMP_BIND_PUR",         "제본비 PUR", src="A-4")
m("COMP_BIND_HC_MUSEON",   "제본비 하드커버무선", src="A-4")
m("COMP_BIND_HC_TWINRING", "제본비 하드커버트윈링", src="A-4")
m("COMP_BIND_CAL_DESK130", "제본비 탁상캘린더(130)", src="A-4")
m("COMP_BIND_CAL_DESK220", "제본비 탁상캘린더(220)", src="A-4")
m("COMP_BIND_CAL_DESKMINI","제본비 탁상캘린더(미니)", src="A-4")
# A-4 (이미 정리)분 — 코드노출은 아니나 cleanup이 모호/통일 정정으로 명시
m("COMP_BIND_TWINRING", "제본비 트윈링", src="A-4")
m("COMP_BIND_SSABARI",  "제본비 싸바리바인더", src="A-4")
m("COMP_BIND_CAL_WALL", "제본비 벽걸이캘린더", src="A-4")

# === A-5. 접지비 (7) — cleanup §A-5 ===
m("COMP_FOLD_CARD_2H",   "접지비 카드 2단", src="A-5")
m("COMP_FOLD_CARD_3H",   "접지비 카드 3단", src="A-5")
m("COMP_FOLD_CARD_6CR",  "접지비 카드 6크리즈", src="A-5")
m("COMP_FOLD_LEAF_HALF", "접지비 리플렛 반접지", src="A-5")
m("COMP_FOLD_LEAF_3FOLD","접지비 리플렛 3단", src="A-5")
m("COMP_FOLD_LEAF_4ACC", "접지비 리플렛 4단아코디언", src="A-5")
m("COMP_FOLD_LEAF_4GATE","접지비 리플렛 4단게이트", src="A-5")

# === A-6. 타공비 (1) — cleanup §A-6 ===
m("COMP_CUT_PERF_1H6", "타공비 1구(6mm)", src="A-6")

# === A-7. 커팅 합가 (3) — cleanup §A-7 ===
m("COMP_CUT_FULL_DIECUT",    "커팅 완제품가 완칼(모양엽서·라벨택)", src="A-7")
m("COMP_CUT_FULL_PERF_1H6",  "커팅 완제품가 완칼+타공1구", src="A-7")
m("COMP_CUT_FULL_PERF_2H6",  "커팅 완제품가 완칼+타공2구", src="A-7")

# === A-8. 엽서북 (4) — cleanup §A-8 ===
m("COMP_PCB_S1_20P", "엽서북 완제품가 단면·20p", src="A-8")
m("COMP_PCB_S1_30P", "엽서북 완제품가 단면·30p", src="A-8")
m("COMP_PCB_S2_20P", "엽서북 완제품가 양면·20p", src="A-8")
m("COMP_PCB_S2_30P", "엽서북 완제품가 양면·30p", src="A-8")

# === A-9. 포토카드 (3) — cleanup §A-9 ===
m("COMP_PHOTOCARD_SET",       "포토카드 완제품가 일반세트", src="A-9")
m("COMP_PHOTOCARD_CLEAR_SET", "포토카드 완제품가 투명세트", src="A-9")
m("COMP_PHOTOCARD_BULK",      "포토카드 완제품가 대량", src="A-9")

# === A-10. 스티커/떡메/합판/타투 (5) — cleanup §A-10, §C ===
m("COMP_STK_PRINT",      "스티커 완제품가(소재·규격)", src="A-10")
m("COMP_STK_PACK",       "스티커 완제품가 팩(54장1세트)", src="A-10")
m("COMP_STK_TATTOO",     "타투스티커 완제품가(3장세트)",
  note="타투스티커 완제품가. 3장 1세트당 합산가(합가형).", src="A-10/C")  # comp_typ_cd 별도 처리
m("COMP_TTEOKME",        "떡메모지 완제품가(권당장수)", src="A-10")
m("COMP_GANGPAN_PRINT",  "합판도무송 완제품가(형상·소재별)", src="A-10")

# === A-11. 포스터/사인 본체 완제품가 (활성 17 + 레거시 6) — cleanup §A-11 ===
m("COMP_POSTER_CANVAS_HANGING",      "캔버스 행잉포스터 완제품가", src="A-11")
m("COMP_POSTER_FOAMBOARD_WHITE",     "폼보드(화이트) 완제품가", src="A-11")
m("COMP_POSTER_FOAMBOARD_BLACK",     "폼보드(블랙) 완제품가", src="A-11")
m("COMP_POSTER_FOMEXBOARD_WHITE3MM", "포맥스보드(화이트3mm) 완제품가", src="A-11")
m("COMP_POSTER_FOMEXBOARD_WHITE5MM", "포맥스보드(화이트5mm) 완제품가", src="A-11")
m("COMP_POSTER_FRAMELESS_WOOD",      "프레임리스우드액자 완제품가", src="A-11")
m("COMP_POSTER_JOKJA",               "족자포스터 완제품가", src="A-11")
m("COMP_POSTER_LEATHER_FRAME",       "레더아트액자 완제품가", src="A-11")
m("COMP_POSTER_LINEN_WOODBONG",      "린넨 우드봉 족자 완제품가", src="A-11")
m("COMP_POSTER_MESH_BANNER",         "메쉬배너 완제품가", src="A-11")
m("COMP_POSTER_MINI_BANNER",         "미니배너 완제품가", src="A-11")
m("COMP_POSTER_MINI_STANDBOARD",     "미니보드스탠딩 완제품가", src="A-11")
m("COMP_POSTER_PET_BANNER",          "PET배너 완제품가", src="A-11")
m("COMP_POSTER_SHEETCUT_HOLO",       "홀로그램 시트커팅 완제품가", src="A-11")
m("COMP_POSTER_SHEETCUT_MATTE",      "무광시트커팅 완제품가", src="A-11")
m("COMP_POSTER_ACRYLSTK_GLOSS",      "유광아크릴스티커 완제품가", src="A-11")
m("COMP_POSTER_ACRYLSTK_MIRROR",     "미러아크릴스티커 완제품가", src="A-11")
# A-11 레거시 6 (use_yn=N) — comp_nm 에 [레거시] 표기로 코드 제거(naming만·use_yn 무변경)
m("COMP_POSTER_ADH_WATERPROOF_PVC",  "접착방수포스터 완제품가[레거시]", src="A-11-legacy")
m("COMP_POSTER_ARTFABRIC_GRAPHIC",   "아트패브릭포스터 완제품가[레거시]", src="A-11-legacy")
m("COMP_POSTER_LEATHER_ARTPRINT",    "레더아트프린트 완제품가[레거시]", src="A-11-legacy")
m("COMP_POSTER_MESH_PRINT",          "메쉬프린트 완제품가[레거시]", src="A-11-legacy")
m("COMP_POSTER_TYVEK_PRINT",         "타이벡프린트 완제품가[레거시]", src="A-11-legacy")
m("COMP_POSTER_WATERPROOF_PET",      "방수포스터 완제품가[레거시]", src="A-11-legacy")

# === A-12. 포스터/현수막 추가옵션 add-on (21 — 빈더미 2 제외) — cleanup §A-12 + refinement ===
m("COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4", "일반현수막 끈(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4",  "일반현수막 큐방(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4", "일반현수막 타공(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6", "일반현수막 타공(6개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8", "일반현수막 타공(8개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW", "일반현수막 봉미싱 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE", "일반현수막 열재단 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE",   "일반현수막 양면테잎 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4",   "메쉬현수막 끈(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4",    "메쉬현수막 큐방(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4",   "메쉬현수막 타공(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6",   "메쉬현수막 타공(6개) 추가가격", src="A-12")
m("COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8",   "메쉬현수막 타공(8개) 추가가격", src="A-12")
m("COMP_POPT_BNR_GAKMOK_STR_900_4_GT", "현수막 각목(900mm 초과)+끈(4개) 추가가격", src="A-12")
m("COMP_POPT_BNR_GAKMOK_STR_900_4_LE", "현수막 각목(900mm이하)+끈(4개) 추가가격", src="A-12")
m("COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER",  "캔버스행잉포스터 우드행거+면끈 추가가격", src="A-12")
m("COMP_POSTEROPT_JOKJA_CEILHOOK",             "족자포스터 천정형고리 추가가격", src="A-12")
m("COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG",    "린넨우드봉족자 우드봉+면끈 추가가격", src="A-12")
m("COMP_POSTEROPT_PET_BANNER_STAND_IN",        "PET배너 실내용배너거치대 추가가격", src="A-12")
m("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1",    "PET배너 실외용배너거치대(단면용) 추가가격", src="A-12")
m("COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2",    "PET배너 실외용배너거치대(양면용) 추가가격", src="A-12")

# === B. 이미 정리됨 — 소폭 보정 (코드노출 아님·cleanup §B 명시 정정만) ===
m("COMP_PRINT_DIGITAL_S1", "디지털인쇄비(단면)", src="B")              # "출력비" 중복어 제거
m("COMP_PP_CREASE_2L", "오시비 2줄", src="B")
m("COMP_PP_CREASE_3L", "오시비 3줄", src="B")
m("COMP_PP_PERF_2L", "미싱비 2줄", src="B")                            # use_yn=N (naming만)
m("COMP_PP_PERF_3L", "미싱비 3줄", src="B")                            # use_yn=N (naming만)
m("COMP_PP_CORNER_RIGHT", "귀돌이비 직각", src="B/refinement")
m("COMP_PP_CORNER_ROUND", "귀돌이비 둥근", src="B/refinement")

# === C. note 빈값 보강 (comp_nm 무변경·note만) ===
m("COMP_ACRYL_COROTTO", note="아크릴코롯토 인쇄·가공 포함가. 사이즈·수량별 단가표.", src="C")
# COMP_STK_TATTOO note 는 A-10 에서 이미 comp_nm+note 동시 설정.

# ---------------------------------------------------------------------------
# comp_typ_cd 보강 — cleanup §C: COMP_STK_TATTOO comp_typ_cd 빈값 → PRC_COMPONENT_TYPE.06
# (task §3) — comp_nm/note 외 유일하게 허용된 보강. 별도 UPDATE 블록으로 분리.
# ---------------------------------------------------------------------------
TYP_FIX = {
    "COMP_STK_TATTOO": "PRC_COMPONENT_TYPE.06",
}

# ---------------------------------------------------------------------------
# 제외 (task §4) — 빈 더미 comp 2건: 이번 적재 대상 아님 (별도 검토)
# ---------------------------------------------------------------------------
EXCLUDED = [
    ("COMP_POSTEROPT_BANNER_MESH_PROC_OPT", "가격행 0행 빈 더미 — use_yn=N 검토(별도)"),
    ("COMP_POPT_BNR_GAKMOK_STR_900_4",      "가격행 0행 base 빈 더미 — _GT/_LE만 활성(별도)"),
]


def sql_str(s):
    """PostgreSQL 문자열 리터럴 — 작은따옴표 escape."""
    return "'" + s.replace("'", "''") + "'"


def emit_updates():
    """멱등 가드 UPDATE 문 리스트(comp_nm/note) + comp_typ_cd 보강 + 통계 반환."""
    name_only = []   # comp_nm만
    note_only = []   # note만
    both = []        # comp_nm + note
    lines = []
    for comp_cd in sorted(NAME):
        e = NAME[comp_cd]
        cn, nt = e["comp_nm"], e["note"]
        sets = []
        guards = []
        if cn is not None:
            sets.append(f"comp_nm = {sql_str(cn)}")
            guards.append(f"comp_nm IS DISTINCT FROM {sql_str(cn)}")
        if nt is not None:
            sets.append(f"note = {sql_str(nt)}")
            guards.append(f"note IS DISTINCT FROM {sql_str(nt)}")
        if not sets:
            continue
        line = (
            f"UPDATE t_prc_price_components SET {', '.join(sets)} "
            f"WHERE comp_cd = {sql_str(comp_cd)} "
            f"AND ({' OR '.join(guards)});  -- {e['src']}"
        )
        lines.append(line)
        if cn is not None and nt is not None:
            both.append(comp_cd)
        elif cn is not None:
            name_only.append(comp_cd)
        else:
            note_only.append(comp_cd)

    typ_lines = []
    for comp_cd, typ in sorted(TYP_FIX.items()):
        typ_lines.append(
            f"UPDATE t_prc_price_components SET comp_typ_cd = {sql_str(typ)} "
            f"WHERE comp_cd = {sql_str(comp_cd)} "
            f"AND comp_typ_cd IS DISTINCT FROM {sql_str(typ)};  -- C: comp_typ_cd 보강"
        )

    stats = {
        "total_name_updates": len(name_only) + len(both),
        "total_note_updates": len(note_only) + len(both),
        "both": len(both),
        "name_only": len(name_only),
        "note_only": len(note_only),
        "typ_fix": len(typ_lines),
        "rows_touched": len(lines) + len(typ_lines),
    }
    return lines, typ_lines, stats


def main():
    lines, typ_lines, stats = emit_updates()
    # 기본: _naming_updates.sql 로 기록(apply.sql / dryrun.sql 가 \i include).
    # `python3 gen_naming_sql.py -` 면 stdout.
    target = "_naming_updates.sql"
    if len(sys.argv) > 1 and sys.argv[1] == "-":
        out = sys.stdout
    else:
        if len(sys.argv) > 1:
            target = sys.argv[1]
        out = open(target, "w", encoding="utf-8")
    out.write("-- ===== AUTO-GENERATED by gen_naming_sql.py — DO NOT HAND-EDIT =====\n")
    out.write("-- comp_nm/note 멱등 가드 UPDATE (cleanup v2 verbatim)\n")
    out.write(f"-- comp 대상행={len(lines)} · comp_typ_cd 보강={len(typ_lines)} · 합계 행={stats['rows_touched']}\n")
    out.write(f"-- (comp_nm UPDATE={stats['total_name_updates']} · note UPDATE={stats['total_note_updates']} · both={stats['both']})\n\n")
    out.write("-- [BLOCK:NAME_NOTE]\n")
    for ln in lines:
        out.write(ln + "\n")
    out.write("\n-- [BLOCK:TYP_FIX]\n")
    for ln in typ_lines:
        out.write(ln + "\n")
    out.write("\n-- [EXCLUDED — 적재 대상 아님 (task §4)]\n")
    for cc, reason in EXCLUDED:
        out.write(f"--   {cc} : {reason}\n")
    out.write(f"\n-- STATS: {stats}\n")
    if out is not sys.stdout:
        out.close()
        sys.stderr.write(f"[gen] wrote {target} · comp rows={len(lines)} typ_fix={len(typ_lines)} stats={stats}\n")
    else:
        sys.stderr.write(f"[gen] comp rows={len(lines)} typ_fix={len(typ_lines)} stats={stats}\n")


if __name__ == "__main__":
    main()
