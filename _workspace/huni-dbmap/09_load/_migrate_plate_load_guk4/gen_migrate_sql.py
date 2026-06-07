#!/usr/bin/env python3
# =====================================================================
# gen_migrate_sql.py — 국4절(316x467) 32상품 plate 적재 실행본 생성기
#
#   라운드: 국4절 316x467 32상품 plate 적재 (사용자 확정 2026-06-07)
#   권위 입력(재매핑 금지):
#     - 08_remediation/csv/plate-load-products.csv  (출력용지규격→siz 매핑)
#     - 08_remediation/csv/plate-worksize-orphan-cleanup.csv (작업사이즈 정리)
#     - 03_validation/plate-load-from-master-gate.md (V/G 적발 — 본 생성기에 반영)
#   라이브 read-only 검증 확정 사실(2026-06-07, gen 시점 고정):
#     - 316x467 = SIZ_000499 (impos=Y·use_yn=Y·존재) → REUSE, 신규 siz 0
#     - 32상품 중 PRD_000016 = SIZ_000499 1행 이미 정답 → KEEP (DELETE/INSERT 대상 외)
#     - plate DELETE = 31상품 작업사이즈 plate 행 101 (siz_cd<>SIZ_000499)
#     - plate INSERT = 31상품 × SIZ_000499 1행 = 31 (dflt_plt_yn='Y'·OUTPUT_PAPER_TYPE.01)
#     - 작업사이즈 ORPHAN(32상품 범위 한정 라이브 재산정) = 53 soft-delete
#         (전체38 범위 CSV의 62 ≠ 32범위 53. 3절·투명 6상품이 여전히 참조하는 siz 제외)
#
#   [HARD] 본 생성기는 SQL을 *생성*만 한다. 라이브 INSERT/UPDATE/DELETE/COMMIT/DDL 미실행.
#   재현성(R3): 같은 입력 → byte-identical SQL. 손편집 금지 — 항상 이 생성기 경유.
# =====================================================================
import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DBMAP = os.path.abspath(os.path.join(HERE, "..", ".."))
PRODUCTS_CSV = os.path.join(DBMAP, "08_remediation", "csv", "plate-load-products.csv")

# ---------------------------------------------------------------------
# 라이브 read-only 검증으로 확정한 32상품 범위 ORPHAN 작업사이즈 목록 (2026-06-07)
#   = 31 교정상품이 참조하던 작업사이즈 중, 교정 후 plate/prodsize/price 무참조가 되는 siz.
#   전체38 CSV의 ORPHAN 62와 다름: 32범위에서는 3절·투명 6상품이 여전히 참조하는
#   siz(118/120/144 등)와 6상품 전용 siz(142/143/186/188/190/292 등)가 빠진다.
#   라이브 재산정: total_plate=plate_in_31 & prodsize_refs=0 & price_refs=0 → ORPHAN.
# ---------------------------------------------------------------------
ORPHAN_WORKSIZE_32SCOPE = [
    "SIZ_000023", "SIZ_000024", "SIZ_000112", "SIZ_000116", "SIZ_000117",
    "SIZ_000121", "SIZ_000122", "SIZ_000123", "SIZ_000125", "SIZ_000128",
    "SIZ_000130", "SIZ_000131", "SIZ_000134", "SIZ_000136", "SIZ_000138",
    "SIZ_000140", "SIZ_000141", "SIZ_000145", "SIZ_000146", "SIZ_000149",
    "SIZ_000150", "SIZ_000151", "SIZ_000152", "SIZ_000153", "SIZ_000154",
    "SIZ_000155", "SIZ_000156", "SIZ_000158", "SIZ_000159", "SIZ_000160",
    "SIZ_000161", "SIZ_000162", "SIZ_000163", "SIZ_000164", "SIZ_000165",
    "SIZ_000166", "SIZ_000167", "SIZ_000168", "SIZ_000169", "SIZ_000177",
    "SIZ_000178", "SIZ_000182", "SIZ_000184", "SIZ_000282", "SIZ_000283",
    "SIZ_000284", "SIZ_000285", "SIZ_000286", "SIZ_000287", "SIZ_000288",
    "SIZ_000289", "SIZ_000290", "SIZ_000291",
]  # 53건

TARGET_SIZ = "SIZ_000499"
OUTPUT_PAPER = "OUTPUT_PAPER_TYPE.01"


def load_guk4_products():
    """plate-load-products.csv 에서 316x467(SIZ_000499 REUSE) 상품만 추출.
    3절(330x660)·투명(315x467) 6상품은 본 라운드 범위 외 → 제외."""
    keep = None       # PRD_000016 (plate_action=KEEP)
    corr = []         # DELETE_INSERT 대상 31상품
    excluded = []     # 3절·투명 (범위 외)
    with open(PRODUCTS_CSV, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            prd = row["prd_cd"].strip()
            size = row["output_paper_size"].strip()
            disp = row["siz_disposition"].strip()
            act = row["plate_action"].strip()
            if size == "316x467" and disp == "REUSE":
                if act == "KEEP":
                    keep = (prd, row["prd_nm"].strip())
                else:
                    corr.append((prd, row["prd_nm"].strip()))
            else:
                excluded.append((prd, row["prd_nm"].strip(), size))
    return keep, corr, excluded


def sql_in_list(items):
    return ",".join("'%s'" % x for x in items)


def gen_plate_correction(corr, prov):
    """01_plate_correction_guk4.sql — DELETE(작업사이즈 한정·prd_cd 한정) + INSERT 31."""
    corr_cds = [c[0] for c in corr]
    lines = []
    lines.append("-- =====================================================================")
    lines.append("-- 01_plate_correction_guk4.sql")
    lines.append("--   국4절(316x467) 31상품 plate 교정: 작업사이즈 중복행 DELETE → SIZ_000499 1행 INSERT")
    lines.append("--   PRD_000016(프리미엄엽서)=SIZ_000499 1행 이미 정답 → KEEP (작업사이즈 목록에 없어 DELETE 대상 외)")
    lines.append("--   생성: gen_migrate_sql.py (손편집 금지). 권위=plate-load-products.csv + 라이브 검증.")
    lines.append("-- =====================================================================")
    lines.append("")
    lines.append("-- [G-6 반영] DELETE = prd_cd IN(31교정) AND siz_cd IN(작업사이즈 70종) 동시 한정.")
    lines.append("--   prd_cd 한정 누락 시 비교정(non-corr) 제품의 PRESERVE siz plate 손실 위험 → 반드시 양조건.")
    lines.append("--   작업사이즈 siz 목록 = 31상품이 참조하던 SIZ_000499 외 전 siz(70 distinct, 101행).")
    lines.append("--   SIZ_000499 는 작업사이즈 목록에 없으므로 PRD_000016 KEEP 행 자동 보존.")
    lines.append("")

    # DELETE: prd_cd 한정 + siz_cd<>SIZ_000499 한정 (G-6: 양조건).
    # 작업사이즈 siz 목록은 "교정상품이 참조하는 SIZ_000499 외 전 siz"로, siz_cd<>'SIZ_000499' 술어가
    # PRESERVE/ORPHAN 무관 전부를 가린다(제품별 collapse 의도). PRD_000016 은 corr_cds 에 없어 미포함.
    lines.append("DELETE FROM t_prd_product_plate_sizes")
    lines.append("WHERE prd_cd IN (%s)" % sql_in_list(corr_cds))
    lines.append("  AND siz_cd <> '%s'   -- 작업사이즈(중복판형)행만. 출력용지규격 SIZ_000499 보존" % TARGET_SIZ)
    lines.append("  AND del_yn = 'N';")
    lines.append("")
    prov.append(("01_plate_correction_guk4.sql", "DELETE", "plate-load-products.csv(31 corr)",
                 "prd_cd IN(31) AND siz_cd<>SIZ_000499", "live 101 rows"))

    # INSERT: 31 rows, SIZ_000499, dflt_plt_yn='Y', output_paper_typ_cd='.01'
    lines.append("-- [F-4 반영] dflt_plt_yn='Y' 명시 (NOT NULL·DEFAULT 없음).")
    lines.append("-- [F-5/H-5 반영] output_paper_typ_cd='%s'(국전계열) 부여 = 기존 NULL/.03 의미 정정." % OUTPUT_PAPER)
    lines.append("--   reg_dt NOT NULL DEFAULT now() → 컬럼 생략(DEFAULT 발화). del_yn DEFAULT 'N' → 생략.")
    lines.append("INSERT INTO t_prd_product_plate_sizes (prd_cd, siz_cd, dflt_plt_yn, output_paper_typ_cd)")
    lines.append("VALUES")
    # 콤마는 튜플 *뒤·주석 앞*에 둔다 — 인라인 주석이 줄끝까지라 콤마가 주석에 먹히면 구문오류.
    n = len(corr)
    for i, (prd, nm) in enumerate(corr):
        sep = "," if i < n - 1 else ""
        lines.append("  ('%s', '%s', 'Y', '%s')%s   -- %s" % (prd, TARGET_SIZ, OUTPUT_PAPER, sep, nm))
        prov.append(("01_plate_correction_guk4.sql", "INSERT", "plate-load-products.csv:%s" % prd,
                     "%s,%s,Y,%s" % (prd, TARGET_SIZ, OUTPUT_PAPER), nm))
    lines.append("ON CONFLICT (prd_cd, siz_cd) DO NOTHING;   -- [R1] 멱등: 2회차 0행(PK NOT NULL → 정상 발화)")
    lines.append("")
    return "\n".join(lines) + "\n"


def gen_worksize_orphan_cleanup(prov):
    """02_worksize_orphan_cleanup.sql — 32상품 범위 ORPHAN soft-delete (NOT EXISTS 3중 가드)."""
    lines = []
    lines.append("-- =====================================================================")
    lines.append("-- 02_worksize_orphan_cleanup.sql")
    lines.append("--   국4절 32상품 plate 교정 후 무참조가 된 작업사이즈 siz soft-delete (del_yn='Y').")
    lines.append("--   범위 한정(32상품): 전체38 ORPHAN 62 ≠ 32범위 53.")
    lines.append("--     제외 siz = 3절·투명 6상품(PRD_000019/025/030/039/049/112)이 여전히 참조하거나")
    lines.append("--     그 6상품 전용인 siz(118/120/144/142/143/186/188/190/292 등). 본 라운드 미교정.")
    lines.append("--   [HARD] §5.2 NOT EXISTS 3중 가드가 실권위 — 후보 목록이 어긋나도 잘못 삭제될 siz 0.")
    lines.append("--   soft-delete만(del_yn 토글·물리삭제 아님) → 롤백 복원 가능, 무손실.")
    lines.append("--   반드시 01(plate DELETE) *후* 실행해야 plate_refs=0 (FK plate→siz RESTRICT).")
    lines.append("-- =====================================================================")
    lines.append("")
    lines.append("UPDATE t_siz_sizes")
    lines.append("SET del_yn = 'Y', del_dt = now()")
    lines.append("WHERE siz_cd IN (")
    siz_block = []
    # 5개씩 줄바꿈 (가독성)
    for j in range(0, len(ORPHAN_WORKSIZE_32SCOPE), 5):
        chunk = ORPHAN_WORKSIZE_32SCOPE[j:j + 5]
        siz_block.append("    " + ", ".join("'%s'" % s for s in chunk))
    lines.append(",\n".join(siz_block))
    lines.append("  )")
    lines.append("  AND del_yn = 'N'   -- [R1] 멱등: 2회차 이미 'Y' → 0행")
    lines.append("  AND NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes x WHERE x.siz_cd = t_siz_sizes.siz_cd AND x.del_yn='N')")
    lines.append("  AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes      x WHERE x.siz_cd = t_siz_sizes.siz_cd)")
    lines.append("  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices   x WHERE x.siz_cd = t_siz_sizes.siz_cd);")
    lines.append("")
    for s in ORPHAN_WORKSIZE_32SCOPE:
        prov.append(("02_worksize_orphan_cleanup.sql", "UPDATE(soft-delete)",
                     "plate-worksize-orphan-cleanup.csv(32scope ORPHAN)",
                     "%s del_yn->Y" % s, "NOT EXISTS 3-guard"))
    return "\n".join(lines) + "\n"


def gen_apply_sql():
    """apply.sql — 01→02 단일 트랜잭션 (BEGIN…COMMIT·ON_ERROR_STOP)."""
    return """-- =====================================================================
-- apply.sql — 국4절 plate 적재 단일 트랜잭션 래퍼 (FK 위상순: plate DELETE/INSERT → siz soft-delete)
--   [R2] 전체가 하나의 BEGIN…COMMIT. 임의 문 실패 시 ON_ERROR_STOP → 전체 롤백(부분적재 없음).
--   기본 실행은 apply.sh 가 끝 COMMIT 을 ROLLBACK 으로 치환(DRY-RUN). --commit 일 때만 실제 COMMIT.
--   순서 강제: 1) plate DELETE/INSERT  2) siz soft-delete (plate→siz RESTRICT 때문에 plate 교정 선행).
--   신규 siz / DDL 없음(316x467=SIZ_000499 재사용). 가격(component_prices) 미터치.
-- =====================================================================
\\set ON_ERROR_STOP on
BEGIN;
  \\i 01_plate_correction_guk4.sql
  \\i 02_worksize_orphan_cleanup.sql
COMMIT;
"""


def main():
    keep, corr, excluded = load_guk4_products()
    # 무결성 가드 — 입력이 변하면 즉시 알림 (no silent drift)
    assert keep is not None and keep[0] == "PRD_000016", "PRD_000016 KEEP 행 누락/변경"
    assert len(corr) == 31, "316x467 교정상품 31 ≠ %d" % len(corr)
    assert len(ORPHAN_WORKSIZE_32SCOPE) == 53, "ORPHAN 53 ≠ %d" % len(ORPHAN_WORKSIZE_32SCOPE)
    assert len(set(ORPHAN_WORKSIZE_32SCOPE)) == 53, "ORPHAN 중복"

    prov = []
    files = {
        "01_plate_correction_guk4.sql": gen_plate_correction(corr, prov),
        "02_worksize_orphan_cleanup.sql": gen_worksize_orphan_cleanup(prov),
        "apply.sql": gen_apply_sql(),
    }
    for fn, body in files.items():
        with open(os.path.join(HERE, fn), "w", encoding="utf-8") as f:
            f.write(body)

    with open(os.path.join(HERE, "migrate.provenance.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["sql_file", "op", "source", "target", "note"])
        w.writerows(prov)

    print("generated: 01_plate_correction_guk4.sql, 02_worksize_orphan_cleanup.sql, apply.sql, migrate.provenance.csv")
    print("KEEP=%s  corr=%d  excluded=%d  orphan_softdelete=%d" % (
        keep[0], len(corr), len(excluded), len(ORPHAN_WORKSIZE_32SCOPE)))
    print("excluded(범위 외 3절·투명): %s" % ", ".join("%s(%s)" % (e[0], e[2]) for e in excluded))


if __name__ == "__main__":
    sys.exit(main())
