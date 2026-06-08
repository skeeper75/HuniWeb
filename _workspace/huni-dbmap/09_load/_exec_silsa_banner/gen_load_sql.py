#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# =====================================================================
# gen_load_sql.py — 일반현수막(PRD_000138) round-5 적재 실행본 생성기
#   입력 = round-4/round-6 GO 매핑 CSV (silsa-price-engine + load_silsa)
#   출력 = 멱등 INSERT … (ON CONFLICT / WHERE NOT EXISTS) SQL + provenance CSV
#   재현성(R3·G8): CSV 위에서 스크립트로 생성. 손편집 금지. 동일 입력→동일 출력.
# [HARD] DB COMMIT·DDL적용·코드행등록은 인간 승인. 본 산출은 실행본 + DRY-RUN 까지만.
#
# [라이브 제약 — read-only 직접 확인, 2026-06-08]
#   · t_prc_component_prices: surrogate IDENTITY PK(comp_price_id) + 자연키
#       UNIQUE 인덱스 ux_t_prc_comp_prices_nat_key(8컬럼, **NULLS DISTINCT**,
#       indnullsnotdistinct=f). 옵션 flat 행(siz/clr/mat/coat/bdl/min 전부 NULL)
#       은 NULL 끼리 distinct 취급 → ON CONFLICT 가 2회차에 미발화 → 중복.
#       ∴ 변형 C(INSERT…SELECT…WHERE NOT EXISTS, IS NOT DISTINCT FROM)로 NULL-safe 멱등.
#   · 그 외 전 테이블: 자연키 PK 존재 → ON CONFLICT(pk) DO NOTHING.
#   · option_items: BEFORE INSERT 트리거 fn_chk_opt_item_ref → 차원행 EXISTS 강제.
#
# [INSERTABLE vs BLOCKED 분리]
#   · 주 트랜잭션(apply.sql)에는 **INSERTABLE 행만** 적재한다.
#   · BLOCKED(77 area-cell price + 77 siz register + 열재단 item + 자재 seq[각목/큐방/봉제사/끈/양면테입])는
#       human-approved 선행(siz 등록·DDL 적용·코드행 등록) 의존 → 주 트랜잭션 미포함.
#       siz 등록 후 활성화용 _blocked/ SQL 을 **별도** 생성(기본 apply 경로 밖).
# =====================================================================
import csv
import os

BASE = os.path.dirname(os.path.abspath(__file__))
LOAD = os.path.join(BASE, "load")
BLK = os.path.join(BASE, "_blocked")
PRD = "PRD_000138"


def lit(v):
    """문자열/숫자/NULL → SQL 리터럴. 빈 문자열·None → NULL(작은따옴표 이스케이프)."""
    if v is None:
        return "NULL"
    s = str(v).strip()
    if s == "":
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def num(v):
    """숫자 컬럼. 빈값→NULL, 아니면 숫자 리터럴 그대로."""
    if v is None or str(v).strip() == "":
        return "NULL"
    return str(v).strip()


def read_csv(name, sub=LOAD):
    with open(os.path.join(sub, name), newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def header(step, table, desc):
    return (
        "-- =====================================================================\n"
        f"-- step {step} — {table}\n"
        f"-- {desc}\n"
        "-- 멱등: 재실행 시 0행 변경. 손편집 금지(gen_load_sql.py 생성).\n"
        "-- reg_dt 명시 생략→DEFAULT now() 발화(round-5 교훈: 명시 NULL 은 DEFAULT 미발화).\n"
        "-- =====================================================================\n"
    )


PROV = []  # (sql_file, sql_table, natural_key, source_csv, source_ref)


def emit_cp(comp, apply_ymd, siz, clr, mat, coat, bdl, mnq, price, note):
    """component_prices 변형 C(WHERE NOT EXISTS, NULL-safe). ux 인덱스 NULLS DISTINCT 대응."""
    cols = ("(comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, "
            "bdl_qty, min_qty, unit_price, note, reg_dt)")
    sel = (f"SELECT {lit(comp)}, {lit(apply_ymd)}, {lit(siz)}, {lit(clr)}, {lit(mat)}, "
           f"{num(coat)}, {num(bdl)}, {num(mnq)}, {num(price)}, {lit(note)}, now()")
    where = (
        "WHERE NOT EXISTS (SELECT 1 FROM t_prc_component_prices x\n"
        f"  WHERE x.comp_cd={lit(comp)} AND x.apply_ymd={lit(apply_ymd)}\n"
        f"    AND x.siz_cd IS NOT DISTINCT FROM {lit(siz)} AND x.clr_cd IS NOT DISTINCT FROM {lit(clr)}\n"
        f"    AND x.mat_cd IS NOT DISTINCT FROM {lit(mat)} AND x.coat_side_cnt IS NOT DISTINCT FROM {num(coat)}\n"
        f"    AND x.bdl_qty IS NOT DISTINCT FROM {num(bdl)} AND x.min_qty IS NOT DISTINCT FROM {num(mnq)});"
    )
    return f"INSERT INTO t_prc_component_prices {cols}\n{sel}\n{where}\n"


def write_sql(name, body, sub=BASE):
    with open(os.path.join(sub, name), "w", encoding="utf-8") as f:
        f.write(body)


# ---------------------------------------------------------------------------
# step 00 — pre-load markers (DDL/master-data = 인간 승인, INSERT 없음)
# ---------------------------------------------------------------------------
s00 = header("00", "pre-load markers (no INSERT)",
             "열재단 PROC_000084=DDL제안(미적용)·siz 77규격=master-data 신규·각목 등 자재(.03) mint=master-data (v2 BUNDLE, 전부 인간 승인)")
s00 += (
    "-- 이 단계에는 적재 INSERT 가 없다(인간 승인 대기 항목 마커).\n"
    "--  (a) [DDL] 열재단 신규 공정 PROC_000084 — 11_ddl_proposals/heat-cut-process-proposal.sql\n"
    "--      적용(t_proc_processes + t_prd_product_processes 2행) 후에만 열재단 option_item INSERTABLE 승격.\n"
    "--  (b) [master-data] siz 77규격 SIZ_000538~000618 — load/t_siz_sizes_BLOCKED.csv\n"
    "--      후니 siz 등록 후에만 77 area-cell price + R-GAKMOK constraint 적재 가능.\n"
    "--      search-before-mint: 라이브 MAX(siz_cd)=SIZ_000510, 77규격 미존재 확인(_blocked/ 별도).\n"
    "--  (c) [master-data] 각목 자재(.03) mint — 라이브 t_mat_materials '각목' 부재 확인(v2: 각목=material, 셋트.07/sub_prd_cd 폐기).\n"
    "--      각목 자재 mint(MAT_TYPE.07) + t_prd_product_materials 링크 후에만 각목 자재 seq item INSERTABLE.\n"
    "SELECT '00: pre-load markers — no INSERT in main transaction (human-approved items)' AS step_00;\n"
)
write_sql("00_preload_markers.sql", s00)

# ---------------------------------------------------------------------------
# 가격 트랙
# ---------------------------------------------------------------------------

# step 01 — t_prc_price_formulas (PK=frm_cd)
rows = read_csv("t_prc_price_formulas.csv")
body = header("01", "t_prc_price_formulas",
              "PRF_BANNER_NORMAL(FRM_TYPE.01 합산형) 1행 신설. PK=frm_cd → ON CONFLICT DO NOTHING")
for r in rows:
    body += (
        "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, frm_typ_cd, note, use_yn, reg_dt)\n"
        f"VALUES ({lit(r['frm_cd'])}, {lit(r['frm_nm'])}, {lit(r['frm_typ_cd'])}, {lit(r['note'])}, {lit(r['use_yn'])}, now())\n"
        "ON CONFLICT (frm_cd) DO NOTHING;\n"
    )
    PROV.append(("01_t_prc_price_formulas.sql", "t_prc_price_formulas", r["frm_cd"],
                 "t_prc_price_formulas.csv", r["frm_cd"]))
write_sql("01_t_prc_price_formulas.sql", body)

# step 02 — t_prc_price_components (PK=comp_cd) — 10 신설(COMP_POSTER_BANNER_NORMAL 선존재 미포함)
rows = read_csv("t_prc_price_components.csv")
body = header("02", "t_prc_price_components",
              "옵션 추가가격 component 10 신설(가공6+추가4). COMP_POSTER_BANNER_NORMAL 라이브 선존재(미포함). PK=comp_cd")
for r in rows:
    body += (
        "INSERT INTO t_prc_price_components (comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt)\n"
        f"VALUES ({lit(r['comp_cd'])}, {lit(r['comp_nm'])}, {lit(r['comp_typ_cd'])}, {lit(r['note'])}, {lit(r['use_yn'])}, now())\n"
        "ON CONFLICT (comp_cd) DO NOTHING;\n"
    )
    PROV.append(("02_t_prc_price_components.sql", "t_prc_price_components", r["comp_cd"],
                 "t_prc_price_components.csv", r["comp_cd"]))
write_sql("02_t_prc_price_components.sql", body)

# step 03 — t_prc_formula_components (PK=(frm_cd,comp_cd)) — 11 배선(면적1+옵션10)
rows = read_csv("t_prc_formula_components.csv")
body = header("03", "t_prc_formula_components",
              "PRF_BANNER_NORMAL ↔ 11 comp(면적1+옵션10) 배선. PK=(frm_cd,comp_cd) → ON CONFLICT DO NOTHING")
for r in rows:
    body += (
        "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)\n"
        f"VALUES ({lit(r['frm_cd'])}, {lit(r['comp_cd'])}, {num(r['disp_seq'])}, {lit(r['addtn_yn'])}, now())\n"
        "ON CONFLICT (frm_cd, comp_cd) DO NOTHING;\n"
    )
    PROV.append(("03_t_prc_formula_components.sql", "t_prc_formula_components",
                 f"{r['frm_cd']}|{r['comp_cd']}", "t_prc_formula_components.csv",
                 f"{r['frm_cd']}/{r['comp_cd']}"))
write_sql("03_t_prc_formula_components.sql", body)

# step 04 — t_prc_component_prices (INSERTABLE 13 = 면적3 siz선존재 + 옵션10 flat)
#   변형 C(NULL-safe). 77 BLOCKED area cell 은 siz 미등록 → 주 트랜잭션 미포함(_blocked/).
rows = read_csv("t_prc_component_prices_INSERTABLE.csv")
body = header("04", "t_prc_component_prices",
              "INSERTABLE 13(면적 siz선존재 3 + 옵션 flat 10). 자연키 UNIQUE=NULLS DISTINCT → 변형 C(WHERE NOT EXISTS)+setval")
n_area = n_opt = 0
for r in rows:
    body += emit_cp(r["comp_cd"], r["apply_ymd"], r["siz_cd"], r["clr_cd"], r["mat_cd"],
                    r["coat_side_cnt"], r["bdl_qty"], r["min_qty"], r["unit_price"], r["note"])
    kind = "area" if r["comp_cd"] == "COMP_POSTER_BANNER_NORMAL" else "opt-flat"
    if kind == "area":
        n_area += 1
    else:
        n_opt += 1
    PROV.append(("04_t_prc_component_prices.sql", "t_prc_component_prices",
                 f"{r['comp_cd']}|{r['siz_cd'] or kind}",
                 "t_prc_component_prices_INSERTABLE.csv", r.get("_provenance", "")))
body += (
    "\n-- IDENTITY 시퀀스 재동기화(메모리 lesson: comp_price_id IDENTITY stale 가드).\n"
    "-- 본 트랙은 comp_price_id 를 명시하지 않으므로 IDENTITY 자동 발번 — stale 충돌 없음.\n"
    "-- 적재 후 MAX 와 시퀀스 동기화(다음 발번 안전, 멱등).\n"
    "SELECT setval(pg_get_serial_sequence('t_prc_component_prices','comp_price_id'),\n"
    "              GREATEST((SELECT COALESCE(MAX(comp_price_id),1) FROM t_prc_component_prices),1), true);\n"
)
write_sql("04_t_prc_component_prices.sql", body)

# step 05 — t_prd_product_price_formulas (PK=(prd_cd,frm_cd))
rows = read_csv("t_prd_product_price_formulas.csv")
body = header("05", "t_prd_product_price_formulas",
              "PRD_000138 ↔ PRF_BANNER_NORMAL 바인딩. 기존 PRF_POSTER_FIXED 바인딩과 PK 다름(공존). ON CONFLICT DO NOTHING")
body += (
    "-- [D-WIRE 주의] 라이브 PRD_000138 은 현재 PRF_POSTER_FIXED 에 바인딩(sparse).\n"
    "--   본 행은 PRF_BANNER_NORMAL 신규 바인딩 추가 → 적재 후 2 공식 공존.\n"
    "--   기존 PRF_POSTER_FIXED 바인딩 정리(파괴적 DELETE/use_yn)는 본 트랙 밖·인간 승인(검증 권고).\n"
)
for r in rows:
    body += (
        "INSERT INTO t_prd_product_price_formulas (prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt)\n"
        f"VALUES ({lit(r['prd_cd'])}, {lit(r['frm_cd'])}, {lit(r['apply_bgn_ymd'])}, {lit(r['note'])}, now())\n"
        "ON CONFLICT (prd_cd, frm_cd) DO NOTHING;\n"
    )
    PROV.append(("05_t_prd_product_price_formulas.sql", "t_prd_product_price_formulas",
                 f"{r['prd_cd']}|{r['frm_cd']}", "t_prd_product_price_formulas.csv",
                 f"{r['prd_cd']}/{r['frm_cd']}"))
write_sql("05_t_prd_product_price_formulas.sql", body)

# ---------------------------------------------------------------------------
# 상품마스터 CPQ 옵션 레이어
# ---------------------------------------------------------------------------

# step 06 — t_prd_product_option_groups (PK=(prd_cd,opt_grp_cd))
rows = read_csv("t_prd_product_option_groups.csv")
body = header("06", "t_prd_product_option_groups",
              "OG-GAGONG·OG-CHUGA 2행. sel_typ=SEL_TYPE.01 단일. PK=(prd_cd,opt_grp_cd) → ON CONFLICT DO NOTHING")
for r in rows:
    body += (
        "INSERT INTO t_prd_product_option_groups\n"
        "  (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note, reg_dt)\n"
        f"VALUES ({lit(r['prd_cd'])}, {lit(r['opt_grp_cd'])}, {lit(r['opt_grp_nm'])}, {lit(r['sel_typ_cd'])}, "
        f"{num(r['min_sel_cnt'])}, {num(r['max_sel_cnt'])}, {lit(r['mand_yn'])}, {num(r['disp_seq'])}, "
        f"{lit(r['use_yn'])}, {lit(r['note'])}, now())\n"
        "ON CONFLICT (prd_cd, opt_grp_cd) DO NOTHING;\n"
    )
    PROV.append(("06_t_prd_product_option_groups.sql", "t_prd_product_option_groups",
                 f"{r['prd_cd']}|{r['opt_grp_cd']}", "t_prd_product_option_groups.csv", r["opt_grp_cd"]))
write_sql("06_t_prd_product_option_groups.sql", body)

# step 07 — t_prd_product_options (PK=(prd_cd,opt_cd))
rows = read_csv("t_prd_product_options.csv")
body = header("07", "t_prd_product_options",
              "가공6+추가5 = 11 options(헤더, 트리거 없음). PK=(prd_cd,opt_cd) → ON CONFLICT DO NOTHING")
for r in rows:
    body += (
        "INSERT INTO t_prd_product_options (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note, reg_dt)\n"
        f"VALUES ({lit(r['prd_cd'])}, {lit(r['opt_cd'])}, {lit(r['opt_grp_cd'])}, {lit(r['opt_nm'])}, "
        f"{lit(r['dflt_yn'])}, {num(r['disp_seq'])}, {lit(r['use_yn'])}, {lit(r['note'])}, now())\n"
        "ON CONFLICT (prd_cd, opt_cd) DO NOTHING;\n"
    )
    PROV.append(("07_t_prd_product_options.sql", "t_prd_product_options",
                 f"{r['prd_cd']}|{r['opt_cd']}", "t_prd_product_options.csv", r["opt_cd"]))
write_sql("07_t_prd_product_options.sql", body)

# step 08 — t_prd_product_option_items (INSERTABLE 9 = 공정 seq, PK=(prd_cd,opt_cd,item_seq))
#   [v2 자재+공정 BUNDLE] 트리거 fn_chk_opt_item_ref:
#     OPT_REF_DIM.04(공정) → t_prd_product_processes(prd_cd,proc_cd) EXISTS,
#     OPT_REF_DIM.03(자재) → t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS.
#   INSERTABLE 9 = 공정 seq(.04) 079/080/081 — 타공3(item_seq=1, bare-hole)·081계열5·봉제080×1.
#   PRD_000138 공정링크 079/080/081 선존재(라이브 확인) → 9행 통과.
#   자재 seq(.03) 8 + 열재단(.04) 1 = BLOCKED 9 → _blocked/(자재 링크·mint·공정 신설 후 활성화). note 컬럼 부재(F-1) 미포함.
rows = read_csv("t_prd_product_option_items.csv")
body = header("08", "t_prd_product_option_items",
              "[v2] INSERTABLE 9 = 공정 seq(.04) 타공3·081계열5·봉제1. 자재 seq(.03)·열재단(.04)은 BLOCKED → _blocked/")
body += (
    "-- [HARD] 트리거 trg_t_prd_product_option_items_chk_ref 가 ref_dim_cd 별 차원행 EXISTS 행단위 검사.\n"
    "--   [v2 자재+공정 BUNDLE] 9행 = 공정 seq(.04) — 타공079×3(bare-hole item_seq=1)·부착081×4·봉제080×1.\n"
    "--   PROC_000079/080/081 PRD_000138 링크 라이브 선존재 → 통과(DRY-RUN A·D1).\n"
    "--   BLOCKED 9행(자재 seq .03 8 + 열재단 .04 1)은 본 SQL 미포함 → _blocked/ + blocked-and-gaps.md.\n"
)
for r in rows:
    body += (
        "INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)\n"
        f"VALUES ({lit(r['prd_cd'])}, {lit(r['opt_cd'])}, {num(r['item_seq'])}, {lit(r['ref_dim_cd'])}, "
        f"{lit(r['ref_key1'])}, {lit(r['ref_key2'])}, {num(r['qty'])}, {lit(r['use_yn'])}, now())\n"
        "ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;\n"
    )
    PROV.append(("08_t_prd_product_option_items.sql", "t_prd_product_option_items",
                 f"{r['prd_cd']}|{r['opt_cd']}|{r['item_seq']}",
                 "t_prd_product_option_items.csv", f"{r['opt_cd']}#{r['item_seq']}→{r['ref_key1']}"))
write_sql("08_t_prd_product_option_items.sql", body)

# step 09 — t_prd_product_constraints (현 적재 0행, R-GAKMOK=GAP-DEFER)
#   [v2] R-GAKMOK var = mat_cd (v1 sub_prd_cd → 각목 material 재귀속 반영).
body = header("09", "t_prd_product_constraints",
              "[v2] R-GAKMOK-HEIGHT=GAP-DEFER(var=mat_cd 정정·각목 자재 mint+링크·siz 77·폼빌더 선행). 현 적재 0행. logic jsonb NOT NULL")
body += (
    "-- 현 시점 적재 constraint 0행.\n"
    "--  · R-SIZE-NONSPEC = 폐기(사이즈=이산 매트릭스, 유효성=가격 셀 존재).\n"
    "--  · R-BONGJE-PARAM = 불요(사이즈 필수 선택은 공통 전제).\n"
    "--  · R-GAKMOK-HEIGHT = GAP-DEFER: [v2] var = mat_cd(각목 material 재귀속, v1 sub_prd_cd 폐기).\n"
    "--      logic(jsonb) 저장 가능하나 선행 3건 미충족: ① 각목 자재 mint(t_mat_materials)+PRD_000138 자재링크,\n"
    "--      ② siz 77 등록, ③ 폼빌더 배열-멤버십 입력방식(F-1). 차원 선등록 후 별도 승인 적재.\n"
    "SELECT '09: constraints — 0 rows now (R-GAKMOK GAP-DEFER, var=mat_cd, human-approved prereqs)' AS step_09;\n"
)
write_sql("09_t_prd_product_constraints.sql", body)

# ---------------------------------------------------------------------------
# apply.sql — 단일 트랜잭션 래퍼(FK 위상정렬). COMMIT/ROLLBACK 은 로더 주입.
# ---------------------------------------------------------------------------
apply = (
    "-- =====================================================================\n"
    "-- apply.sql — 일반현수막(PRD_000138) round-5 멱등 적재 (단일 트랜잭션)\n"
    "--   기본 = DRY-RUN(끝에서 ROLLBACK; apply.sh/load.py 가 주입). --commit 시에만 COMMIT.\n"
    "--   ON_ERROR_STOP on → 임의 문 실패 시 전체 롤백(R2 원자성). 중간 COMMIT 금지.\n"
    "--   주 트랜잭션 = INSERTABLE 행만. BLOCKED(siz77·area77·열재단·자재 seq)는 _blocked/ 별도(인간 승인 선행).\n"
    "--   [v2] 옵션 = 자재+공정 BUNDLE. 주 트랜잭션 옵션아이템(08)=공정 seq(.04) 9행. 자재 seq(.03)=_blocked/.\n"
    "--   FK 위상정렬: 마커(00) → 공식(01) → comp(02) → 배선(03) → 단가(04) → 바인딩(05)\n"
    "--                → 옵션그룹(06) → 옵션(07) → 옵션아이템 공정seq(08) → 제약(09).\n"
    "-- =====================================================================\n"
    "\\set ON_ERROR_STOP on\n"
    "BEGIN;\n"
    "  \\echo '>> step 00 pre-load markers (no INSERT)'\n"
    "  \\i 00_preload_markers.sql\n"
    "  \\echo '>> [price] step 01 t_prc_price_formulas'\n"
    "  \\i 01_t_prc_price_formulas.sql\n"
    "  \\echo '>> [price] step 02 t_prc_price_components'\n"
    "  \\i 02_t_prc_price_components.sql\n"
    "  \\echo '>> [price] step 03 t_prc_formula_components'\n"
    "  \\i 03_t_prc_formula_components.sql\n"
    "  \\echo '>> [price] step 04 t_prc_component_prices (INSERTABLE 13)'\n"
    "  \\i 04_t_prc_component_prices.sql\n"
    "  \\echo '>> [price] step 05 t_prd_product_price_formulas'\n"
    "  \\i 05_t_prd_product_price_formulas.sql\n"
    "  \\echo '>> [master] step 06 t_prd_product_option_groups'\n"
    "  \\i 06_t_prd_product_option_groups.sql\n"
    "  \\echo '>> [master] step 07 t_prd_product_options'\n"
    "  \\i 07_t_prd_product_options.sql\n"
    "  \\echo '>> [master] step 08 t_prd_product_option_items (INSERTABLE 9)'\n"
    "  \\i 08_t_prd_product_option_items.sql\n"
    "  \\echo '>> [master] step 09 t_prd_product_constraints (0 rows, GAP-DEFER)'\n"
    "  \\i 09_t_prd_product_constraints.sql\n"
    "-- 기본 ROLLBACK (apply.sh/load.py 주입). 실제 적재는 --commit 인간 승인 시에만.\n"
)
write_sql("apply.sql", apply)

# ---------------------------------------------------------------------------
# _blocked/ — siz 등록 + 77 area-cell 활성화 SQL (기본 apply 경로 밖, 인간 승인 후 사용)
# ---------------------------------------------------------------------------
os.makedirs(BLK, exist_ok=True)

# B-01 siz 77규격 등록 (master-data, 인간 승인)
rows = read_csv("t_siz_sizes_BLOCKED.csv")
body = header("B-01", "t_siz_sizes (BLOCKED — 인간 승인)",
              "면적매트릭스 siz 77규격 신규 등록(SIZ_000538~000618). acrylic 선례: 기존 재사용·미등록만 mint")
body += (
    "-- [HARD·인간 승인] siz 채번 = 후니 승인. 적용 직전 라이브 MAX(siz_cd) 재확인 권고(현 MAX=SIZ_000510).\n"
    "-- [멱등] ON CONFLICT (siz_cd) DO NOTHING. impos_yn/use_yn NOT NULL → 명시.\n"
)
n_siz = 0
for r in rows:
    body += (
        "INSERT INTO t_siz_sizes (siz_cd, siz_nm, work_width, work_height, cut_width, cut_height, impos_yn, use_yn, note, reg_dt)\n"
        f"VALUES ({lit(r['proposed_siz_cd'])}, {lit(r['siz_nm'])}, {num(r['work_width'])}, {num(r['work_height'])}, "
        f"{num(r['cut_width'])}, {num(r['cut_height'])}, {lit(r['impos_yn'])}, 'Y', {lit(r['note'])}, now())\n"
        "ON CONFLICT (siz_cd) DO NOTHING;\n"
    )
    PROV.append(("_blocked/B01_t_siz_sizes.sql", "t_siz_sizes", r["proposed_siz_cd"],
                 "t_siz_sizes_BLOCKED.csv", r["proposed_siz_cd"]))
    n_siz += 1
write_sql("B01_t_siz_sizes.sql", body, sub=BLK)

# B-02 77 area-cell price 활성화 (siz 등록 후)
rows = read_csv("t_prc_component_prices_BLOCKED.csv")
body = header("B-02", "t_prc_component_prices (BLOCKED area cells — siz 등록 후)",
              "면적매트릭스 본체 77셀(siz 미등록 의존). B01 siz 등록 후에만 FK 충족·적재 가능. 변형 C 멱등")
n_blk = 0
for r in rows:
    body += emit_cp(r["comp_cd"], r["apply_ymd"], r["siz_cd"], r["clr_cd"], r["mat_cd"],
                    r["coat_side_cnt"], r["bdl_qty"], r["min_qty"], r["unit_price"], r["note"])
    PROV.append(("_blocked/B02_t_prc_component_prices.sql", "t_prc_component_prices",
                 f"{r['comp_cd']}|{r['siz_cd']}", "t_prc_component_prices_BLOCKED.csv",
                 r.get("_provenance", "")))
    n_blk += 1
write_sql("B02_t_prc_component_prices.sql", body, sub=BLK)

# _blocked/apply_blocked.sql — siz 등록 후 활성화용(별도 인간 승인 트랜잭션)
apply_blk = (
    "-- =====================================================================\n"
    "-- _blocked/apply_blocked.sql — siz 77 등록 + 77 area-cell 활성화 (인간 승인 후)\n"
    "--   [HARD] 기본 apply.sql 경로 밖. siz 등록(master-data)=인간 승인 후에만 실행.\n"
    "--   단일 트랜잭션·멱등. siz 선행(B01) → area-cell(B02).\n"
    "-- =====================================================================\n"
    "\\set ON_ERROR_STOP on\n"
    "BEGIN;\n"
    "  \\echo '>> [blocked] B01 t_siz_sizes register (77)'\n"
    "  \\i B01_t_siz_sizes.sql\n"
    "  \\echo '>> [blocked] B02 t_prc_component_prices area cells (77)'\n"
    "  \\i B02_t_prc_component_prices.sql\n"
    "-- 기본 ROLLBACK. 실제 적재는 인간 승인 --commit.\n"
)
write_sql("apply_blocked.sql", apply_blk, sub=BLK)

# ---------------------------------------------------------------------------
# _blocked/ (v2 옵션) — 자재 seq BUNDLE 활성화 SQL (기본 apply 경로 밖, 인간 승인 후)
#   [v2] option_items 자재 seq(.03)는 PRD_000138 자재 링크(t_prd_product_materials) 부재로 트리거 REJECT.
#   해소: ① 자재 mint(master 부재분: 큐방·각목LE·각목GT·봉제사 — search-before-mint, [CONFIRM-CHANNEL] mat_cd)
#         ② PRD_000138 자재 링크 선적재(MAT_000069/070 + mint분)  ③ 자재 seq option_items 활성화.
#   끈 MAT_000070·양면테입 MAT_000069 = master 실재(mint 불요, 링크만). 큐방·각목·봉제사 = mint+링크.
# ---------------------------------------------------------------------------
blk_items = read_csv("t_prd_product_option_items_BLOCKED.csv")
# 자재 seq(.03) 행만 추출(열재단 .04 는 heat-cut DDL 경로·blocked-and-gaps)
mat_items = [r for r in blk_items if r["ref_dim_cd"] == "OPT_REF_DIM.03"]

# 자재 분류: master 실재(LINK-only) vs 부재(MINT+LINK). [CONFIRM-CHANNEL] = 채번 미상.
#   라이브 직접 조회 결과(2026-06-08): MAT_000069 양면테입·MAT_000070 끈 EXISTS / 큐방·각목·봉제사 0행.
KNOWN_MAT = {"MAT_000069", "MAT_000070"}            # master 실재(mint 불요)
# mint 후보(ref_key1 이 [CONFIRM-MAT ...] placeholder) — 명명·근거 명시(발명 금지·인간 채번)
MINT_PROPOSALS = [
    # (placeholder_ref_key1, 제안 mat_nm, search-before-mint 근거)
    ("[CONFIRM-MAT 봉제사]",     "봉제사",       "봉미싱 실=자재 등록(D②). t_mat_materials 0행 재증명(실버/실사소재만). MAT_TYPE.07 부속"),
    ("[CONFIRM-MAT 큐방]",       "큐방",         "큐방 자재(D). 큐/방/하토메/고리 검색 0행(아크릴부속 고리·천정고리만). MAT_TYPE.07 부속"),
    ("[CONFIRM-MAT 각목900이하]", "각목(900이하)", "각목 신규 자재 mint(D③·우드봉 차용 배제). t_mat_materials 0행 재증명. 사각단면 목재. MAT_TYPE.07"),
    ("[CONFIRM-MAT 각목900초과]", "각목(900초과)", "각목(900초과) 신규 자재 mint(D③). 2규격 모델 D-2([CONFIRM] 별 mat_cd vs 단일+param). MAT_TYPE.07"),
]

# B03a — 자재 mint 제안 (master 부재분, [CONFIRM-CHANNEL] mat_cd = 라이브 MAX 재확인 후 후니 채번)
body = header("B-03a", "t_mat_materials (BLOCKED-MINT 제안 — 인간 승인·search-before-mint)",
              "[v2] 큐방·각목(900이하/초과)·봉제사 자재 신규 mint 제안. master 부재 라이브 재증명. mat_cd 채번=후니")
body += (
    "-- [HARD·인간 승인] 자재 mint = 후니 채번. mat_cd = [CONFIRM-CHANNEL] placeholder.\n"
    "--   적용 직전 라이브 MAX(mat_cd) 재확인 후 배정(현 MAX=MAT_000336 → MAT_000337+ 후보).\n"
    "--   search-before-mint: 끈 MAT_000070·양면테입 MAT_000069 = master 실재(mint 불요·B03b 링크만).\n"
    "--     큐방·각목·봉제사 = 라이브 t_mat_materials 0행 재증명(아래 근거) → mint 제안.\n"
    "-- [멱등] ON CONFLICT (mat_cd) DO NOTHING. mat_typ_cd=MAT_TYPE.07(부속) NOT NULL·use_yn NOT NULL.\n"
)
for ph, nm, why in MINT_PROPOSALS:
    body += (
        f"-- 제안: {nm} — {why}\n"
        "-- INSERT INTO t_mat_materials (mat_cd, mat_nm, mat_typ_cd, use_yn, note, reg_dt)\n"
        f"-- VALUES ('[CONFIRM-CHANNEL mat_cd]', {lit(nm)}, 'MAT_TYPE.07', 'Y', "
        f"{lit('자재 mint 제안(round-6 v2 BUNDLE): ' + why)}, now())\n"
        "-- ON CONFLICT (mat_cd) DO NOTHING;\n"
    )
    PROV.append(("_blocked/B03a_t_mat_materials_MINT.sql", "t_mat_materials",
                 f"[CONFIRM]{nm}", "t_prd_product_option_items_BLOCKED.csv", ph))
body += (
    "\n-- ↑ 주석 처리(commented) — mat_cd 미채번이라 실행 SQL 아님. 후니 채번 후 활성화.\n"
    "SELECT 'B03a: t_mat_materials mint — PROPOSAL ONLY (mat_cd 미채번, 인간 승인)' AS step_b03a;\n"
)
write_sql("B03a_t_mat_materials_MINT.sql", body, sub=BLK)

# B03b — PRD_000138 자재 링크 (t_prd_product_materials). 끈/양면테입=실코드(즉시), mint분=placeholder.
#   distinct (mat_cd, usage_cd) 추출. KNOWN_MAT 은 실코드 INSERT, mint 분은 주석(채번 후).
seen_links = []
for r in mat_items:
    key = (r["ref_key1"], r["ref_key2"] or "USAGE.07")
    if key not in seen_links:
        seen_links.append(key)
body = header("B-03b", "t_prd_product_materials (BLOCKED-LINK — 자재 링크 선적재)",
              "[v2] PRD_000138 자재 링크. 끈 MAT_000070·양면테입 MAT_000069=실코드 즉시. mint분(큐방·각목·봉제사)=채번 후")
body += (
    "-- [HARD] 트리거 .03 = (mat_cd, usage_cd) BOTH in t_prd_product_materials(prd_cd) 강제.\n"
    "--   자재 seq option_items(B04)의 선행. PK=(prd_cd,mat_cd,usage_cd). dflt_yn NOT NULL(옵션 부속이라 'N').\n"
    "-- [멱등] ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING.\n"
)
n_link_live = n_link_mint = 0
for mat_cd, usage_cd in seen_links:
    if mat_cd in KNOWN_MAT:
        body += (
            "INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)\n"
            f"VALUES ({lit(PRD)}, {lit(mat_cd)}, {lit(usage_cd)}, 'N', 1, now())\n"
            "ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;\n"
        )
        PROV.append(("_blocked/B03b_t_prd_product_materials_LINK.sql", "t_prd_product_materials",
                     f"{PRD}|{mat_cd}|{usage_cd}", "t_prd_product_option_items_BLOCKED.csv", mat_cd))
        n_link_live += 1
    else:
        body += (
            f"-- [mint 후 활성화] {mat_cd} (큐방/각목/봉제사 mint 후 채번된 mat_cd 로 치환):\n"
            f"-- INSERT INTO t_prd_product_materials (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq, reg_dt)\n"
            f"-- VALUES ({lit(PRD)}, '[CONFIRM-CHANNEL mat_cd]', {lit(usage_cd)}, 'N', 1, now())\n"
            "-- ON CONFLICT (prd_cd, mat_cd, usage_cd) DO NOTHING;\n"
        )
        PROV.append(("_blocked/B03b_t_prd_product_materials_LINK.sql", "t_prd_product_materials",
                     f"{PRD}|{mat_cd}|{usage_cd}", "t_prd_product_option_items_BLOCKED.csv", mat_cd))
        n_link_mint += 1
write_sql("B03b_t_prd_product_materials_LINK.sql", body, sub=BLK)

# B04 — 자재 seq option_items 활성화 (자재 링크/mint 후). 끈/양면테입 분만 실행 가능, mint 분은 주석.
body = header("B-04", "t_prd_product_option_items (BLOCKED 자재 seq .03 — 링크/mint 후 활성화)",
              "[v2] 자재 seq BUNDLE. 끈/양면테입=링크 후 즉시. 큐방/각목/봉제사=mint+링크 후. PK=(prd_cd,opt_cd,item_seq)")
body += (
    "-- [HARD] 트리거 .03 → t_prd_product_materials(prd_cd,mat_cd,usage_cd) EXISTS. B03b 선행 필수.\n"
    "--   끈 MAT_000070·양면테입 MAT_000069 = B03b 링크 후 즉시 적재(DRY-RUN B2·D2 BUNDLE 성립 실증).\n"
    "--   큐방·각목·봉제사 = mint(B03a)+링크(B03b) 후 ref_key1 실코드 치환 → 활성화. placeholder 행은 주석.\n"
    "-- [멱등] ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING.\n"
)
n_mi_live = n_mi_mint = 0
for r in mat_items:
    is_known = r["ref_key1"] in KNOWN_MAT
    stmt = (
        "INSERT INTO t_prd_product_option_items (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, reg_dt)\n"
        f"VALUES ({lit(r['prd_cd'])}, {lit(r['opt_cd'])}, {num(r['item_seq'])}, {lit(r['ref_dim_cd'])}, "
        f"{lit(r['ref_key1'])}, {lit(r['ref_key2'])}, {num(r['qty'])}, {lit(r['use_yn'])}, now())\n"
        "ON CONFLICT (prd_cd, opt_cd, item_seq) DO NOTHING;\n"
    )
    if is_known:
        body += stmt
        n_mi_live += 1
    else:
        body += f"-- [mint 후 활성화 — ref_key1 placeholder {r['ref_key1']}]\n" + "\n".join("-- " + ln for ln in stmt.splitlines()) + "\n"
        n_mi_mint += 1
    PROV.append(("_blocked/B04_t_prd_product_option_items_MAT.sql", "t_prd_product_option_items",
                 f"{r['prd_cd']}|{r['opt_cd']}|{r['item_seq']}",
                 "t_prd_product_option_items_BLOCKED.csv", f"{r['opt_cd']}#{r['item_seq']}→{r['ref_key1']}"))
write_sql("B04_t_prd_product_option_items_MAT.sql", body, sub=BLK)

# _blocked/apply_blocked_options.sql — 자재 BUNDLE 활성화 (인간 승인 후, 옵션헤더→mint→링크→item 순)
#   [의존] B04 자재 seq item 은 FK fk_prd_opt_items_opt → t_prd_product_options(prd_cd,opt_cd) 필요.
#     → 주 apply.sql 의 옵션헤더(06/07)가 선행(커밋)돼 있어야 함. 본 스크립트는 자체완결 DRY-RUN 을
#       위해 06/07(멱등 ON CONFLICT)을 선포함 — 운영 적용 시엔 주 적재 후 실행이라 06/07 은 no-op.
apply_blk_opt = (
    "-- =====================================================================\n"
    "-- _blocked/apply_blocked_options.sql — [v2] 자재 seq BUNDLE 활성화 (인간 승인 후)\n"
    "--   [HARD] 기본 apply.sql 경로 밖. 자재 mint(master-data)·자재 링크=인간 승인 후에만.\n"
    "--   [의존] B04 자재 seq item 은 옵션헤더(t_prd_product_options) FK 필요 → 주 적재(06/07) 선행.\n"
    "--     본 스크립트는 자체완결 위해 06/07(멱등) 선포함(주 적재 후 실행 시 no-op).\n"
    "--   FK 위상정렬: 옵션그룹(06)→옵션(07)→자재 mint(B03a 제안)→자재 링크(B03b)→자재 seq item(B04).\n"
    "--   끈/양면테입 = mint 불요(링크만) → B03b live분 + B04 live분이 즉시 멱등 적재.\n"
    "--   큐방/각목/봉제사 = mint 채번 후 placeholder 치환 필요(B03a/B03b/B04 주석분).\n"
    "-- =====================================================================\n"
    "\\set ON_ERROR_STOP on\n"
    "BEGIN;\n"
    "  \\echo '>> [blocked-opt] 06/07 옵션헤더 선행(멱등 — 주 적재 후 no-op)'\n"
    "  \\i ../06_t_prd_product_option_groups.sql\n"
    "  \\i ../07_t_prd_product_options.sql\n"
    "  \\echo '>> [blocked-opt] B03a t_mat_materials mint (제안·주석 — 채번 후 활성화)'\n"
    "  \\i B03a_t_mat_materials_MINT.sql\n"
    "  \\echo '>> [blocked-opt] B03b t_prd_product_materials link (끈/양면테입 live + mint분 주석)'\n"
    "  \\i B03b_t_prd_product_materials_LINK.sql\n"
    "  \\echo '>> [blocked-opt] B04 t_prd_product_option_items 자재 seq (끈/양면테입 live + mint분 주석)'\n"
    "  \\i B04_t_prd_product_option_items_MAT.sql\n"
    "-- 기본 ROLLBACK. 실제 적재는 인간 승인 --commit.\n"
)
write_sql("apply_blocked_options.sql", apply_blk_opt, sub=BLK)

# ---------------------------------------------------------------------------
# provenance CSV
# ---------------------------------------------------------------------------
with open(os.path.join(BASE, "load.provenance.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["sql_file", "sql_table", "natural_key", "source_csv", "source_ref"])
    for row in PROV:
        w.writerow(row)

n_main = sum(1 for p in PROV if not p[0].startswith("_blocked/"))
print("=== gen_load_sql.py 생성 완료 (v2 자재+공정 BUNDLE) ===")
print(f"  주 트랜잭션 INSERTABLE 행 = {n_main}")
print(f"    price: formula 1 + components 10 + wiring 11 + component_prices 13(area {n_area}+opt {n_opt}) + binding 1")
print(f"    master[v2]: groups 2 + options 11 + items 9(공정 seq) + constraints 0")
print(f"  _blocked/(인간 승인 후):")
print(f"    siz {n_siz} + area-cell {n_blk}")
print(f"    [v2 자재] mint 제안 {len(MINT_PROPOSALS)} · 자재링크 live {n_link_live}/mint {n_link_mint} · 자재 option_items live {n_mi_live}/mint {n_mi_mint}")
print(f"  provenance 총 {len(PROV)} 행 → load.provenance.csv")
