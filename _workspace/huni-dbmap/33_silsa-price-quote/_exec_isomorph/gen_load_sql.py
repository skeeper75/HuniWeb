#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_load_sql.py — 실사 동형 가격구성요소 결합 SQL 생성기 (round-23)

입력(권위): silsa-isomorph-merge-design.md (dbm-price-arbiter 산출·라이브 byte-identical 재입증).
출력: apply.sql · dryrun.sql · backup_undo.sql · *.provenance.csv

결합 = comp 레벨만(UPDATE). INSERT 0 · DELETE 0 · 단가행(component_prices) 무변경.
한글 소재명 = 라이브 t_prc_price_formulas.frm_nm / t_prd_products.prd_nm 대조 확정(Q-IM1 해소).
재현성(R3·G8): SQL은 본 스크립트로만 생성. 손편집 금지.
"""
import csv
import os

OUT = os.path.dirname(os.path.abspath(__file__))

# ── 결합 정의 (설계 §3 + Q-IM1 라이브 대조 한글명) ────────────────────────────
# 정본 2 comp: 가독성 정비 comp_nm/note. 레거시 6 comp: use_yn=N. 단독 5 comp: comp_nm/note 정비만.
# 배선 재지정: 레거시 PRF의 disp_seq=1 본체 comp_cd → 정본 comp_cd (조건부 UPDATE·이미 정본이면 no-op).

CANONICAL_A = "COMP_POSTER_CANVAS_FABRIC"
CANONICAL_B = "COMP_POSTER_ARTPRINT_PHOTO"

# (정본, [(레거시 comp, 레거시 PRF, 한글명)...], 정본_한글명, 골든값)
GROUP_A = {
    "canonical": CANONICAL_A,
    "canonical_nm": "캔버스패브릭포스터",
    "golden": "600×1800=37,800원",
    "members": [  # 레거시 (comp_cd, frm_cd, 한글명·라이브 출처)
        ("COMP_POSTER_LEATHER_ARTPRINT", "PRF_POSTER_LEATHER_AP", "레더아트프린트"),
        ("COMP_POSTER_MESH_PRINT",       "PRF_POSTER_MESH",       "메쉬프린트"),
        ("COMP_POSTER_TYVEK_PRINT",      "PRF_POSTER_TYVEK",      "타이벡프린트"),
    ],
    # 결합소재 한글명 전체 목록(정본 포함·라이브 frm_nm/prd_nm 출처)
    "korean_list": ["캔버스패브릭포스터", "레더아트프린트", "메쉬프린트", "타이벡프린트"],
}
GROUP_B = {
    "canonical": CANONICAL_B,
    "canonical_nm": "아트프린트포스터",
    "golden": "600×1800=21,600원",
    "members": [
        ("COMP_POSTER_ADH_WATERPROOF_PVC", "PRF_POSTER_ADH_WP",     "접착방수포스터"),
        ("COMP_POSTER_ARTFABRIC_GRAPHIC",  "PRF_POSTER_ARTFABRIC",  "아트패브릭포스터"),
        ("COMP_POSTER_WATERPROOF_PET",     "PRF_POSTER_WATERPROOF", "방수포스터"),
    ],
    "korean_list": ["아트프린트포스터", "접착방수포스터", "아트패브릭포스터", "방수포스터"],
    "fixed_note": " · PRF_POSTER_FIXED 범용배선 보유(정본이라 무변경 보존)",
}

# 정본 2 comp의 comp_nm/note (사용자 형식)
def canonical_nm(g):
    # comp_nm: 실사 완제품가 (소재군 한글명 나열)
    return f"실사 완제품가 ({'·'.join(g['korean_list'])})"

def canonical_note(g):
    legacy_codes = "/".join(m[0].replace("COMP_POSTER_", "") for m in g["members"])
    fixed = g.get("fixed_note", "")
    return (f"[동형결합] 가격표 동일 {len(g['korean_list'])}소재 통합 · "
            f"결합소재: {', '.join(g['korean_list'])} · "
            f"가격축: 가로×세로 구간(52셀) · 골든 {g['golden']} · "
            f"정본 {g['canonical']}(레거시 {len(g['members'])}종 {legacy_codes} use_yn=N){fixed}")

# 단독 5 comp (결합 0·comp_nm/note 가독성 정비만·라이브 대조 한글명)
# 설계 §4 단독 목록의 한글명을 라이브 frm_nm/prd_nm로 정정:
#   ARTPAPER_MATTE→아트페이퍼포스터 / BANNER_MESH→메쉬현수막 / ADH_CLEAR_PVC→접착투명포스터
#   LINEN_FABRIC→린넨패브릭포스터 / BANNER_NORMAL→일반현수막
SINGLES = [
    ("COMP_POSTER_ARTPAPER_MATTE", "아트페이퍼포스터", 39, None),
    ("COMP_POSTER_BANNER_MESH",    "메쉬현수막",       46, None),
    ("COMP_POSTER_ADH_CLEAR_PVC",  "접착투명포스터",   52, "600×1800=59,400원"),
    ("COMP_POSTER_LINEN_FABRIC",   "린넨패브릭포스터", 52, "600×1800=32,400원"),
    ("COMP_POSTER_BANNER_NORMAL",  "일반현수막",       79, None),
]

def single_nm(kor):
    return f"실사 완제품가 ({kor})"

def single_note(cells, golden):
    g = f" · 골든 {golden}" if golden else ""
    return f"[단독] 동형 없음 · 가격축: 가로×세로 구간({cells}셀){g}"


def sql_lit(s):
    return "'" + s.replace("'", "''") + "'"


# ── 1) formula_components 배선 재지정 (멱등키 frm_cd, comp_cd=PK → 조건부) ──────
# PK=(frm_cd, comp_cd). 배선 변경은 comp_cd가 PK 일부 → UPDATE PK 일부 변경.
# 멱등: WHERE comp_cd=레거시 AND disp_seq=1 (이미 정본이면 매칭 0행=no-op).
# 정본행이 이미 존재하면(동일 frm_cd, comp_cd=정본) PK 충돌 가능하나, 레거시 PRF에는
# 정본 comp 행이 없으므로(1:1 배선) 충돌 없음. 안전 가드로 NOT EXISTS(정본행) 추가.
def fc_rewire(g):
    out = []
    for legacy_comp, frm, kor in g["members"]:
        out.append(
            f"-- {frm}: disp_seq=1 본체 {legacy_comp} → {g['canonical']} (소재: {kor})\n"
            f"UPDATE t_prc_formula_components fc\n"
            f"   SET comp_cd = {sql_lit(g['canonical'])}\n"
            f" WHERE fc.frm_cd = {sql_lit(frm)}\n"
            f"   AND fc.comp_cd = {sql_lit(legacy_comp)}\n"
            f"   AND fc.disp_seq = 1\n"
            f"   AND NOT EXISTS (SELECT 1 FROM t_prc_formula_components x\n"
            f"                    WHERE x.frm_cd = {sql_lit(frm)} AND x.comp_cd = {sql_lit(g['canonical'])});\n"
        )
    return out


# ── 2) price_components use_yn=N (레거시 6) ──────────────────────────────────
def pc_disable(g):
    out = []
    for legacy_comp, frm, kor in g["members"]:
        out.append(
            f"UPDATE t_prc_price_components\n"
            f"   SET use_yn = 'N'\n"
            f" WHERE comp_cd = {sql_lit(legacy_comp)} AND use_yn IS DISTINCT FROM 'N';\n"
        )
    return out


# ── 3) price_components comp_nm/note 정본 2 ──────────────────────────────────
def pc_canonical(g):
    nm, note = canonical_nm(g), canonical_note(g)
    return (
        f"UPDATE t_prc_price_components\n"
        f"   SET comp_nm = {sql_lit(nm)}, note = {sql_lit(note)}\n"
        f" WHERE comp_cd = {sql_lit(g['canonical'])}\n"
        f"   AND (comp_nm IS DISTINCT FROM {sql_lit(nm)} OR note IS DISTINCT FROM {sql_lit(note)});\n"
    )


# ── 4) price_components comp_nm/note 단독 5 ──────────────────────────────────
def pc_singles():
    out = []
    for comp, kor, cells, golden in SINGLES:
        nm, note = single_nm(kor), single_note(cells, golden)
        out.append(
            f"-- 단독: {kor}\n"
            f"UPDATE t_prc_price_components\n"
            f"   SET comp_nm = {sql_lit(nm)}, note = {sql_lit(note)}\n"
            f" WHERE comp_cd = {sql_lit(comp)}\n"
            f"   AND (comp_nm IS DISTINCT FROM {sql_lit(nm)} OR note IS DISTINCT FROM {sql_lit(note)});\n"
        )
    return out


# ── 본문 빌드 ────────────────────────────────────────────────────────────────
HEADER = """-- ============================================================================
-- 실사(포스터/사인) 동형 가격구성요소 결합 — round-23
-- 생성기: gen_load_sql.py (손편집 금지·재현성 R3/G8)
-- 권위: silsa-isomorph-merge-design.md (byte-identical 단가매트릭스 재입증)
-- 작업: UPDATE 19행 (formula_components 배선 6 · price_components use_yn=N 6 · comp_nm/note 7)
-- INSERT 0 · DELETE 0 · component_prices(단가행) 무변경
-- 한글 소재명 = 라이브 frm_nm/prd_nm 대조 확정(Q-IM1):
--   캔버스패브릭포스터/레더아트프린트/메쉬프린트/타이벡프린트 (그룹A)
--   아트프린트포스터/접착방수포스터/아트패브릭포스터/방수포스터 (그룹B)
--   단독: 아트페이퍼포스터·메쉬현수막·접착투명포스터·린넨패브릭포스터·일반현수막
--   ※ 설계 약식명(아트지무광/메쉬배너/투명점착PVC/일반배너)은 라이브 정식명으로 정정
-- 멱등: 모든 UPDATE는 목표값/조건 가드 → 2회차 0행 변경
-- ============================================================================
"""


def build_body():
    body = []
    body.append("-- STEP 1: formula_components 배선 재지정 — 그룹 A (3건)")
    body += fc_rewire(GROUP_A)
    body.append("-- STEP 2: formula_components 배선 재지정 — 그룹 B (3건)")
    body += fc_rewire(GROUP_B)
    body.append("-- STEP 3: price_components use_yn='N' — 레거시 6 comp")
    body.append("-- 그룹 A 레거시:")
    body += pc_disable(GROUP_A)
    body.append("-- 그룹 B 레거시:")
    body += pc_disable(GROUP_B)
    body.append("-- STEP 4: price_components comp_nm/note — 정본 2 comp")
    body.append(pc_canonical(GROUP_A))
    body.append(pc_canonical(GROUP_B))
    body.append("-- STEP 5: price_components comp_nm/note — 단독 5 comp (결합 0·정비만)")
    body += pc_singles()
    return "\n".join(body)


def write_apply():
    with open(os.path.join(OUT, "apply.sql"), "w", encoding="utf-8") as f:
        f.write(HEADER)
        f.write("-- apply.sql: 단일 트랜잭션. 로더(apply.sh)가 COMMIT/ROLLBACK 주입.\n")
        f.write("-- 기본 DRY-RUN(ROLLBACK). 실 COMMIT은 인간 승인(--commit)만.\n")
        f.write("\\set ON_ERROR_STOP on\n")
        f.write("BEGIN;\n\n")
        f.write(build_body())
        f.write("\n\n-- (COMMIT/ROLLBACK는 로더가 주입 — 파일 자체엔 미포함)\n")


def write_dryrun():
    """롤백전용 검증본: BEGIN…(before)…(apply)…(after/골든/멱등)…ROLLBACK"""
    A_legacy = ",".join(sql_lit(m[0]) for m in GROUP_A["members"])
    B_legacy = ",".join(sql_lit(m[0]) for m in GROUP_B["members"])
    all_legacy = ",".join(sql_lit(m[0]) for m in GROUP_A["members"] + GROUP_B["members"])
    A_prfs = ",".join(sql_lit(m[1]) for m in GROUP_A["members"])
    B_prfs = ",".join(sql_lit(m[1]) for m in GROUP_B["members"])
    all_prfs = A_prfs + "," + B_prfs
    singles = ",".join(sql_lit(s[0]) for s in SINGLES)

    s = []
    s.append("-- dryrun.sql — 롤백전용 라이브 DRY-RUN (COMMIT 0 실증)")
    s.append("-- 적용 전후 검증 ①배선 정본 ②레거시 use_yn=N ③comp_nm 갱신 ④골든 재현 ⑤고아/동시매칭 0 ⑥2-pass 멱등")
    s.append("\\set ON_ERROR_STOP on")
    s.append("\\echo '=== [BEFORE] formula_components 배선 (레거시 PRF disp_seq=1) ==='")
    s.append(f"SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ({all_prfs}) AND disp_seq=1 ORDER BY frm_cd;")
    s.append("\\echo '=== [BEFORE] 레거시 6 use_yn ==='")
    s.append(f"SELECT comp_cd, use_yn FROM t_prc_price_components WHERE comp_cd IN ({all_legacy}) ORDER BY comp_cd;")
    s.append("\\echo '=== [BEFORE] 골든: 레거시 각 소재 600x1800 단가 (결합 전 기준값) ==='")
    s.append(f"SELECT comp_cd, unit_price FROM t_prc_component_prices WHERE comp_cd IN ({all_legacy}) AND siz_width=600 AND siz_height=1800 ORDER BY comp_cd;")
    s.append("")
    s.append("BEGIN;")
    s.append("\\echo '=== [APPLY 1차] ==='")
    s.append(build_body())
    s.append("\\echo '=== [AFTER] formula_components 배선 → 정본 가리킴 확인 ==='")
    s.append(f"SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ({all_prfs}) AND disp_seq=1 ORDER BY frm_cd;")
    s.append("\\echo '=== [AFTER] 레거시 6 use_yn=N · 정본2/단독5 use_yn=Y 확인 ==='")
    s.append(f"SELECT comp_cd, use_yn FROM t_prc_price_components WHERE comp_cd IN ({all_legacy},{sql_lit(CANONICAL_A)},{sql_lit(CANONICAL_B)},{singles}) ORDER BY use_yn, comp_cd;")
    s.append("\\echo '=== [AFTER] 정본2 + 단독5 comp_nm/note 갱신 확인 ==='")
    s.append(f"SELECT comp_cd, comp_nm, note FROM t_prc_price_components WHERE comp_cd IN ({sql_lit(CANONICAL_A)},{sql_lit(CANONICAL_B)},{singles}) ORDER BY comp_cd;")
    s.append("\\echo '=== [GOLDEN] 정본 단가표 600x1800 = 결합 전 레거시 단가와 동일해야 (셀 diff 0 근거) ==='")
    s.append(f"SELECT {sql_lit(CANONICAL_A)} AS canonical, unit_price FROM t_prc_component_prices WHERE comp_cd={sql_lit(CANONICAL_A)} AND siz_width=600 AND siz_height=1800")
    s.append(f"UNION ALL SELECT {sql_lit(CANONICAL_B)}, unit_price FROM t_prc_component_prices WHERE comp_cd={sql_lit(CANONICAL_B)} AND siz_width=600 AND siz_height=1800;")
    s.append("-- 기대: CANVAS_FABRIC=37800 (레거시 LEATHER/MESH/TYVEK 동일) · ARTPRINT_PHOTO=21600 (레거시 ADH_WP/ARTFABRIC/WATERPROOF 동일)")
    s.append("\\echo '=== [고아 0] 재지정 후 모든 대상 PRF disp_seq=1 본체가 use_yn=Y comp 가리킴 ==='")
    s.append(f"SELECT fc.frm_cd, fc.comp_cd, pc.use_yn FROM t_prc_formula_components fc")
    s.append(f"  JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd")
    s.append(f"  WHERE fc.frm_cd IN ({all_prfs},{sql_lit('PRF_POSTER_CANVAS')},{sql_lit('PRF_POSTER_ARTPRINT')},{sql_lit('PRF_POSTER_FIXED')}) AND fc.disp_seq=1 AND pc.use_yn<>'Y' ;")
    s.append("-- 기대: 0행 (고아 없음)")
    s.append("\\echo '=== [중복 배선 0] 한 PRF에 disp_seq=1 본체 2건 안 생김 ==='")
    s.append(f"SELECT frm_cd, count(*) FROM t_prc_formula_components WHERE frm_cd IN ({all_prfs}) AND disp_seq=1 GROUP BY frm_cd HAVING count(*)<>1;")
    s.append("-- 기대: 0행")
    s.append("\\echo '=== [동시매칭 0] 정본 comp 단가표 한 좌표 1행 ==='")
    s.append(f"SELECT comp_cd, siz_width, siz_height, min_qty, count(*) FROM t_prc_component_prices WHERE comp_cd IN ({sql_lit(CANONICAL_A)},{sql_lit(CANONICAL_B)}) GROUP BY comp_cd,siz_width,siz_height,min_qty HAVING count(*)>1;")
    s.append("-- 기대: 0행")
    s.append("\\echo '=== [단가행 보존] component_prices 무변경 — 13 comp 행수 (변동 없어야) ==='")
    s.append(f"SELECT count(*) AS rows_13comp FROM t_prc_component_prices WHERE comp_cd IN ({all_legacy},{sql_lit(CANONICAL_A)},{sql_lit(CANONICAL_B)},{singles});")
    s.append("")
    s.append("\\echo '=== [APPLY 2차] 멱등 — delta 0이어야 (UPDATE 0 rows) ==='")
    s.append(build_body())
    s.append("-- 위 2차 UPDATE들의 출력이 모두 'UPDATE 0' 이면 멱등 PASS")
    s.append("")
    s.append("ROLLBACK;")
    s.append("\\echo '=== [POST-ROLLBACK] 라이브 원복 확인 — 배선 레거시 그대로 ==='")
    s.append(f"SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE frm_cd IN ({all_prfs}) AND disp_seq=1 ORDER BY frm_cd;")
    s.append("-- 기대: 레거시 comp_cd로 원복(COMMIT 0 실증)")
    with open(os.path.join(OUT, "dryrun.sql"), "w", encoding="utf-8") as f:
        f.write(HEADER)
        f.write("\n".join(s) + "\n")


def write_backup_undo():
    all_legacy = ",".join(sql_lit(m[0]) for m in GROUP_A["members"] + GROUP_B["members"])
    all_prfs = ",".join(sql_lit(m[1]) for m in GROUP_A["members"] + GROUP_B["members"])
    singles = ",".join(sql_lit(s[0]) for s in SINGLES)
    s = []
    s.append(HEADER)
    s.append("-- backup_undo.sql — 결합 되돌리기 (적용 후 undo용)")
    s.append("-- (1) 현재값 백업 SELECT — 적용 직전 실행해 결과를 보관")
    s.append("\\echo '--- BACKUP: formula_components 배선 (적용 직전 값) ---'")
    s.append(f"SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components WHERE frm_cd IN ({all_prfs}) AND disp_seq=1 ORDER BY frm_cd;")
    s.append("\\echo '--- BACKUP: price_components comp_nm/note/use_yn ---'")
    s.append(f"SELECT comp_cd, comp_nm, note, use_yn FROM t_prc_price_components WHERE comp_cd IN ({all_legacy},{sql_lit(CANONICAL_A)},{sql_lit(CANONICAL_B)},{singles}) ORDER BY comp_cd;")
    s.append("")
    s.append("-- (2) UNDO UPDATE — 결합을 원복 (배선 레거시 복귀 · use_yn=Y · comp_nm/note 원본 복귀)")
    s.append("-- ※ comp_nm/note 원본은 위 BACKUP 값으로 채워 실행. 아래는 배선·use_yn 원복(결정적).")
    s.append("\\set ON_ERROR_STOP on")
    s.append("BEGIN;")
    s.append("-- 배선 원복: 정본 → 레거시 (각 PRF disp_seq=1)")
    for g in (GROUP_A, GROUP_B):
        for legacy_comp, frm, kor in g["members"]:
            s.append(f"UPDATE t_prc_formula_components SET comp_cd={sql_lit(legacy_comp)} WHERE frm_cd={sql_lit(frm)} AND comp_cd={sql_lit(g['canonical'])} AND disp_seq=1;")
    s.append("-- 레거시 6 use_yn 복귀 Y")
    for g in (GROUP_A, GROUP_B):
        for legacy_comp, frm, kor in g["members"]:
            s.append(f"UPDATE t_prc_price_components SET use_yn='Y' WHERE comp_cd={sql_lit(legacy_comp)};")
    s.append("-- comp_nm/note 원본 복귀: 적용 직전 BACKUP 값으로 채워 실행 (아래 placeholder)")
    s.append("--   UPDATE t_prc_price_components SET comp_nm=<백업값>, note=<백업값> WHERE comp_cd=<comp>;")
    s.append("ROLLBACK;  -- undo도 기본 ROLLBACK. 실 원복은 COMMIT으로 (인간 승인)")
    with open(os.path.join(OUT, "backup_undo.sql"), "w", encoding="utf-8") as f:
        f.write("\n".join(s) + "\n")


def write_provenance():
    rows = []
    # formula_components 배선 6
    for g, grp in ((GROUP_A, "A"), (GROUP_B, "B")):
        for legacy_comp, frm, kor in g["members"]:
            rows.append(("apply.sql", "STEP1/2", "t_prc_formula_components",
                         "UPDATE comp_cd→정본",
                         f"{frm} disp_seq=1 {legacy_comp}→{g['canonical']}",
                         "design §3 그룹"+grp))
    # use_yn=N 6
    for g in (GROUP_A, GROUP_B):
        for legacy_comp, frm, kor in g["members"]:
            rows.append(("apply.sql", "STEP3", "t_prc_price_components",
                         "UPDATE use_yn=N", legacy_comp, "design §6 #3"))
    # canonical 2
    for g in (GROUP_A, GROUP_B):
        rows.append(("apply.sql", "STEP4", "t_prc_price_components",
                     "UPDATE comp_nm/note", g["canonical"], "design §4 정본·Q-IM1 라이브 frm_nm"))
    # singles 5
    for comp, kor, cells, golden in SINGLES:
        rows.append(("apply.sql", "STEP5", "t_prc_price_components",
                     "UPDATE comp_nm/note", comp, f"design §4 단독·Q-IM1 라이브명={kor}"))
    with open(os.path.join(OUT, "apply.provenance.csv"), "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "step", "table", "op", "target", "source"])
        w.writerows(rows)
    return len(rows)


if __name__ == "__main__":
    write_apply()
    write_dryrun()
    write_backup_undo()
    n = write_provenance()
    print(f"generated: apply.sql, dryrun.sql, backup_undo.sql, apply.provenance.csv ({n} rows)")
