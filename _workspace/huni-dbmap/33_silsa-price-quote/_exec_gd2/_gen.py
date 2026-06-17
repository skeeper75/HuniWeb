# Deterministic generator for G-D2 W1-W6 idempotent SQL.
# 28 product -> formula -> body comp map (from validated U6_formula_split.sql)
MAP = [
 ("PRD_000118","PRF_POSTER_ARTPRINT","COMP_POSTER_ARTPRINT_PHOTO","아트프린트포스터"),
 ("PRD_000119","PRF_POSTER_ARTPAPER","COMP_POSTER_ARTPAPER_MATTE","아트페이퍼포스터"),
 ("PRD_000120","PRF_POSTER_WATERPROOF","COMP_POSTER_WATERPROOF_PET","방수포스터"),
 ("PRD_000121","PRF_POSTER_ADH_WP","COMP_POSTER_ADH_WATERPROOF_PVC","접착방수포스터"),
 ("PRD_000122","PRF_POSTER_ADH_CLEAR","COMP_POSTER_ADH_CLEAR_PVC","접착투명포스터"),
 ("PRD_000123","PRF_POSTER_ARTFABRIC","COMP_POSTER_ARTFABRIC_GRAPHIC","아트패브릭포스터"),
 ("PRD_000124","PRF_POSTER_LINEN","COMP_POSTER_LINEN_FABRIC","린넨패브릭포스터"),
 ("PRD_000125","PRF_POSTER_CANVAS","COMP_POSTER_CANVAS_FABRIC","캔버스패브릭포스터"),
 ("PRD_000126","PRF_POSTER_LEATHER_AP","COMP_POSTER_LEATHER_ARTPRINT","레더아트프린트"),
 ("PRD_000127","PRF_POSTER_TYVEK","COMP_POSTER_TYVEK_PRINT","타이벡프린트"),
 ("PRD_000128","PRF_POSTER_MESH","COMP_POSTER_MESH_PRINT","메쉬프린트"),
 ("PRD_000129","PRF_POSTER_FOAMBOARD","COMP_POSTER_FOAMBOARD_WHITE","폼보드"),
 ("PRD_000130","PRF_POSTER_FOMEXBOARD","COMP_POSTER_FOMEXBOARD_WHITE3MM","포맥스보드"),
 ("PRD_000131","PRF_POSTER_FRAMELESS","COMP_POSTER_FRAMELESS_WOOD","프레임리스우드액자"),
 ("PRD_000132","PRF_POSTER_LEATHER_FRAME","COMP_POSTER_LEATHER_FRAME","레더아트액자"),
 ("PRD_000133","PRF_POSTER_CANVAS_HANGING","COMP_POSTER_CANVAS_HANGING","캔버스 행잉포스터"),
 ("PRD_000134","PRF_POSTER_LINEN_WOODBONG","COMP_POSTER_LINEN_WOODBONG","린넨 우드봉 족자"),
 ("PRD_000135","PRF_POSTER_JOKJA","COMP_POSTER_JOKJA","족자포스터"),
 ("PRD_000136","PRF_POSTER_PET_BANNER","COMP_POSTER_PET_BANNER","PET배너"),
 ("PRD_000137","PRF_POSTER_MESH_BANNER","COMP_POSTER_MESH_BANNER","메쉬배너"),
 ("PRD_000138","PRF_POSTER_BANNER_N","COMP_POSTER_BANNER_NORMAL","일반현수막"),
 ("PRD_000139","PRF_POSTER_BANNER_M","COMP_POSTER_BANNER_MESH","메쉬현수막"),
 ("PRD_000140","PRF_POSTER_SHEETCUT_MATTE","COMP_POSTER_SHEETCUT_MATTE","무광시트커팅"),
 ("PRD_000141","PRF_POSTER_SHEETCUT_HOLO","COMP_POSTER_SHEETCUT_HOLO","홀로그램 시트커팅"),
 ("PRD_000142","PRF_POSTER_ACRYLSTK_GLOSS","COMP_POSTER_ACRYLSTK_GLOSS","유광아크릴스티커"),
 ("PRD_000143","PRF_POSTER_ACRYLSTK_MIRROR","COMP_POSTER_ACRYLSTK_MIRROR","미러아크릴스티커"),
 ("PRD_000144","PRF_POSTER_MINI_STANDBOARD","COMP_POSTER_MINI_STANDBOARD","미니보드스탠딩"),
 ("PRD_000145","PRF_POSTER_MINI_BANNER","COMP_POSTER_MINI_BANNER","미니배너"),
]
assert len(MAP)==28

# Post-process add-on comps (disp_seq 2-8). Perforation EXCLUDED here (W6 after W5 conversion).
ADDONS = [
 (2,"COMP_PP_CREASE_1L","오시"),
 (3,"COMP_PP_CORNER_ROUND","귀돌이(둥근)"),
 (4,"COMP_PP_CORNER_RIGHT","귀돌이(직각)"),
 (5,"COMP_PP_VARTEXT_1EA","가변텍스트"),
 (6,"COMP_PP_VARIMG_1EA","가변이미지"),
 (7,"COMP_PRINT_SPOT_WHITE_S1","별색(단면)"),
 (8,"COMP_PRINT_SPOT_WHITE_S2","별색(양면)"),
]

def w(fn, body):
    open(fn,"w").write(body)

# ---------- W1: formula split ----------
hdr = """-- W1_body_formula_split.sql — 본체 소재별 공식 분리 (G-D2 선행 필수)
-- ★엔진 동시매칭(ERR_AMBIGUOUS) 방지: 본체 comp use_dims=["siz_cd"]만(mat_cd NULL) →
--   단일 공식에 27 소재 comp 배선 시 siz만 맞으면 전부 _row_matches 통과 = combos>1 = 합산거부.
--   ∴ 소재별 PRF_POSTER_<MAT> 공식 1:1 분리(각 공식 본체 1개) 후에야 후가공 합산 가능.
-- 멱등: frm_cd NOT EXISTS. 단가행 재적재 0. (U6_formula_split와 동일 권위)
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT v.frm_cd, v.frm_nm, v.note, 'Y', now()
FROM (VALUES
"""
rows = ",\n".join(
 f"  ('{f}','{nm} 완제품가(면적/규격 단가)','포스터사인 {nm} 소재/사이즈/수량별 완제품 통가격')"
 for (_,f,_,nm) in MAP)
tail = """
) AS v(frm_cd, frm_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd = v.frm_cd);
"""
w("W1_body_formula_split.sql", hdr+rows+tail)

# ---------- W2: body wiring disp_seq=1 ----------
hdr = """-- W2_body_wiring.sql — 각 공식 disp_seq=1 = 자기 본체 comp 배선 (addtn_yn='Y' 메타·엔진무관)
-- 멱등: (frm_cd,comp_cd) NOT EXISTS. 단가행 재적재 0.
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, 1, 'Y', now()
FROM (VALUES
"""
rows = ",\n".join(f"  ('{f}','{c}')" for (_,f,c,_) in MAP)
tail = """
) AS v(frm_cd, comp_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd=v.comp_cd);
"""
w("W2_body_wiring.sql", hdr+rows+tail)

# ---------- W3: binding swap ----------
hdr = """-- W3_binding_swap.sql — 28상품 바인딩 PRF_POSTER_FIXED → 자기 유형별 공식
-- ★PK=(prd_cd, apply_bgn_ymd) (라이브 실측·DDL문서 stale). apply_bgn_ymd NOT NULL.
--   ∴ DELETE(FIXED 바인딩) 선행 후 INSERT(신규·동일 '2026-06-01' 재사용·이중계상 방지).
-- 멱등: DELETE 후 INSERT는 PK(prd_cd,apply_bgn_ymd) NOT EXISTS 가드 → 2pass delta 0.
DELETE FROM t_prd_product_price_formulas
 WHERE frm_cd = 'PRF_POSTER_FIXED'
   AND prd_cd BETWEEN 'PRD_000118' AND 'PRD_000145';

INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, reg_dt)
SELECT v.prd_cd, v.frm_cd, '2026-06-01', now()
FROM (VALUES
"""
rows = ",\n".join(f"  ('{p}','{f}')" for (p,f,_,_) in MAP)
tail = """
) AS v(prd_cd, frm_cd)
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas x WHERE x.prd_cd=v.prd_cd AND x.apply_bgn_ymd='2026-06-01');
-- 주의: PRF_POSTER_FIXED 공식/배선(ARTPRINT_PHOTO)은 보존(비파괴). 바인딩만 이전.
"""
w("W3_binding_swap.sql", hdr+rows+tail)

# ---------- W4: post-process wiring (7 addons x 28 formulas = 196) ----------
hdr = """-- W4_postproc_wiring.sql — 각 공식에 후가공 add-on 배선(오시·귀돌이2·가변2·별색2 = 7, disp_seq 2~8)
-- ★엔진: addtn_yn 미참조. formula_components 전건 매칭→합산·미매칭→제외(pricing.py _evaluate_formula).
--   후가공 comp는 use_dims에 proc_cd 등 보유 → selections에 해당 후가공 선택 시만 매칭(미선택=제외·무경고).
--   본체(use_dims siz_cd)와 후가공(use_dims proc_cd+...)은 차원축이 달라 동시매칭 0.
-- 미싱(PERF)은 제외 — opt_cd 모델이라 W5(proc 전환) 후 W6에서 배선.
-- 멱등: (frm_cd,comp_cd) NOT EXISTS. 단가행 재적재 0(후가공 정본 전건 실재).
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, 'Y', now()
FROM (VALUES
"""
vrows=[]
for (_,f,_,_) in MAP:
    for (seq,comp,_) in ADDONS:
        vrows.append(f"  ('{f}','{comp}',{seq})")
rows=",\n".join(vrows)
tail = """
) AS v(frm_cd, comp_cd, disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components x WHERE x.frm_cd=v.frm_cd AND x.comp_cd=v.comp_cd);
"""
w("W4_postproc_wiring.sql", hdr+rows+tail)
print("W1-W4 generated. addon wiring rows =", len(vrows))
