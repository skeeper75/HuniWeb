#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
round-4 상품마스터 적재 번들 조립기 (dbm-load-builder, G8 재현성).

입력: 09_load/<sheet>/load/*.csv (검증된 round-3 산출, INSERT-class) + conditional/blocked/deferred.
출력: 09_load/_assembled/load/<NN>_<table>.csv (즉시 적재가능만)
      + update-set/<table>_update.csv (UPDATE-class)
      + 집계(stdout) — 매니페스트·blocked-and-gaps 작성 근거.

원칙(HARD): 매핑 재도출 0(조립만). 단,
  (1) addon: 라이브 t_prd_product_addons는 addon_prd_cd 컬럼 부재 → tmpl_cd FK 모델.
      addon_prd_cd=PRD_xxxxxx → tmpl_cd=TMPL-PRD_xxxxxx 결정적 변환(컬럼 리네임).
      대상 템플릿 라이브 실재시 insertable, 부재시 blocked-pending-registration.
  (2) acrylic 완칼: K-2 결정 = 053 차용 중단·레이저커팅 proc_cd 신설.
      053 참조 14행을 신규 PROC(레이저커팅, step00 코드선적재 대상)로 재지정 → blocked-pending-registration.
  나머지는 컬럼 정규화(_provenance/_src_* 메타 보존)만.
멱등: 같은 입력 → 같은 출력.
"""
import csv, os, sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.abspath(__file__))
LOAD = os.path.dirname(ROOT)                       # 09_load
OUT_LOAD = os.path.join(ROOT, "load")
OUT_UPD  = os.path.join(ROOT, "update-set")

# 라이브 검증 결과(이 스크립트 외부에서 read-only SELECT로 확정, provenance로 박제)
# [보정 MINOR] 하드코딩 2개 전제 오류 → 라이브 t_prd_templates 전체 집합(11개)으로 교체.
#   read-only SELECT(2026-06-06): SELECT tmpl_cd FROM t_prd_templates ORDER BY tmpl_cd; → 아래 11개.
#   addon insertable 판정은 이 전수 집합 대조(향후 001/004/006/009/013/014/281/282 참조도 정상 분기).
LIVE_TEMPLATES = {
    "TMPL-PRD_000001", "TMPL-PRD_000002", "TMPL-PRD_000004", "TMPL-PRD_000005",
    "TMPL-PRD_000006", "TMPL-PRD_000009", "TMPL-PRD_000012", "TMPL-PRD_000013",
    "TMPL-PRD_000014", "TMPL-PRD_000281", "TMPL-PRD_000282",
}
# 라이브 부재 템플릿(addon blocked): PRD_000003/008/015 → TMPL 미존재(전수 집합 무매치)
NEW_LASER_PROC = "PROC_000084"   # 레이저커팅 코드선적재 제안코드(라이브 max=PROC_000083 다음)

# 대상 테이블별 정식 DB 컬럼(라이브 information_schema 기준, _provenance/_src_*는 적재 제외 메타)
DB_COLS = {
    "t_prd_products": ["prd_cd","MES_ITEM_CD","prd_nm","prd_typ_cd","semi_role_cd","nonspec_yn",
        "file_upload_yn","editor_yn","min_qty","max_qty","qty_incr","dflt_qty","constraint_json",
        "use_yn","reg_dt","upd_dt","qty_unit_typ_cd"],
    "t_prd_product_sizes": ["prd_cd","siz_cd","dflt_yn","disp_seq","reg_dt","upd_dt"],
    "t_prd_product_materials": ["prd_cd","mat_cd","usage_cd","dep_proc_cd","dflt_yn","disp_seq","reg_dt","upd_dt"],
    "t_prd_product_processes": ["prd_cd","proc_cd","excl_grp_cd","mand_proc_yn","disp_seq","reg_dt","upd_dt"],
    "t_prd_product_print_options": ["prd_cd","opt_id","print_side","front_colrcnt_cd","back_colrcnt_cd","dflt_yn","disp_seq","reg_dt","upd_dt"],
    "t_prd_product_page_rules": ["prd_cd","page_min","page_max","page_incr","note","reg_dt","upd_dt"],
    "t_prd_product_bundle_qtys": ["prd_cd","bdl_qty","bdl_unit_typ_cd","dflt_yn","disp_seq","reg_dt","upd_dt"],
    "t_prd_product_addons": ["prd_cd","tmpl_cd","disp_seq","note","reg_dt","upd_dt"],
}

# (sheet, relfile) → target table.  INSERT-class insertable inputs.
INSERT_INPUTS = [
    # design-calendar = 신규상품(blocked: placeholder prd_cd) — 별도 처리(아래)
    ("digital-print","load/t_prd_product_materials.csv","t_prd_product_materials"),
    ("digital-print","load/t_prd_product_processes.csv","t_prd_product_processes"),
    ("booklet","load/t_prd_product_materials.csv","t_prd_product_materials"),
    ("booklet","load/t_prd_product_processes.csv","t_prd_product_processes"),
    ("stationery","load/t_prd_product_processes.csv","t_prd_product_processes"),
    ("sticker","load/t_prd_product_processes.csv","t_prd_product_processes"),
    ("calendar","load/t_prd_product_materials.csv","t_prd_product_materials"),
    ("acrylic","load/t_prd_product_materials.csv","t_prd_product_materials"),
    ("acrylic","load/t_prd_product_bundle_qtys.csv","t_prd_product_bundle_qtys"),
    # acrylic processes 별도(완칼 레이저커팅 재지정 분기)
    ("silsa","load/t_prd_product_processes.csv","t_prd_product_processes"),
    ("goods-pouch","load/t_prd_product_processes.csv","t_prd_product_processes"),  # 0행
]

ADDON_INPUTS = [
    ("digital-print","load/t_prd_product_addons.csv"),
    ("silsa","load/t_prd_product_addons.csv"),
    ("goods-pouch","load/t_prd_product_addons.csv"),
]

def read_csv(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f))

def write_csv(path, cols, rows):
    with open(path, "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
        w.writerow(cols)
        for r in rows:
            w.writerow([r.get(c, "") for c in cols])

def norm_row(row, table, sheet):
    """DB 컬럼만 추출 + provenance를 _provenance 컬럼에 보존."""
    out = {c: (row.get(c, "") or "") for c in DB_COLS[table]}
    prov = row.get("_provenance", "") or ""
    out["_provenance"] = f"[{sheet}] {prov}"
    return out

# ── 수집 버킷 ──────────────────────────────────────────────────────────────
insertable = defaultdict(list)   # table -> rows (DB cols + _provenance)
blocked    = []                  # dict rows w/ reason
tally = defaultdict(lambda: defaultdict(int))   # table -> {insertable, blocked}

# 1) 일반 INSERT-class
for sheet, rel, table in INSERT_INPUTS:
    p = os.path.join(LOAD, sheet, rel)
    rows = read_csv(p)
    for r in rows:
        insertable[table].append(norm_row(r, table, sheet))
        tally[table]["insertable"] += 1

# 2) acrylic processes — 완칼(PROC_000053) → 레이저커팅(신규) 재지정 = blocked
ap = read_csv(os.path.join(LOAD,"acrylic","load","t_prd_product_processes.csv"))
for r in ap:
    if r["proc_cd"] == "PROC_000053":
        nr = norm_row(r, "t_prd_product_processes", "acrylic")
        nr["proc_cd"] = NEW_LASER_PROC
        nr["_block_reason"] = ("K-2: 아크릴 모양컷 도메인공정=레이저커팅. 053(종이/스티커 완칼) 차용 중단 결정. "
            f"신규 {NEW_LASER_PROC}(레이저커팅) 코드선적재(step00) 등록 후에만 FK 충족. 후니 등록 대기.")
        nr["_unblock"] = f"후니가 t_proc_processes에 {NEW_LASER_PROC}(레이저커팅) 등록"
        blocked.append({"table":"t_prd_product_processes","kind":"FK-blocked(레이저커팅 신설)", **nr})
        tally["t_prd_product_processes"]["blocked"] += 1
    else:
        # UV(002)·부착(081) 등 라이브 실재 코드 → insertable
        insertable["t_prd_product_processes"].append(norm_row(r,"t_prd_product_processes","acrylic"))
        tally["t_prd_product_processes"]["insertable"] += 1

# 3) addon — tmpl_cd 모델로 변환 + 템플릿 실재 분기
for sheet, rel in ADDON_INPUTS:
    p = os.path.join(LOAD, sheet, rel)
    rows = read_csv(p)
    for r in rows:
        addon_prd = r.get("addon_prd_cd","").strip()
        tmpl = "TMPL-" + addon_prd if addon_prd else ""
        base = {
            "prd_cd": r["prd_cd"], "tmpl_cd": tmpl,
            "disp_seq": r.get("disp_seq",""), "note": r.get("note",""),
            "reg_dt": r.get("reg_dt","2026-06-05 00:00:00"), "upd_dt": r.get("upd_dt",""),
            "_provenance": f"[{sheet}] addon_prd_cd={addon_prd}→tmpl_cd={tmpl} (라이브 addon=tmpl_cd 모델 변환). " + (r.get("_provenance","") or ""),
        }
        if tmpl in LIVE_TEMPLATES:
            insertable["t_prd_product_addons"].append(base)
            tally["t_prd_product_addons"]["insertable"] += 1
        else:
            base["_block_reason"] = (f"addon 대상 {addon_prd}의 라이브 template({tmpl}) 부재. "
                "라이브 t_prd_product_addons는 addon_prd_cd 컬럼 없음·tmpl_cd FK→t_prd_templates. "
                "템플릿 미등록 상품은 addon 불가.")
            base["_unblock"] = f"후니가 {addon_prd}용 template({tmpl})을 t_prd_templates에 등록"
            blocked.append({"table":"t_prd_product_addons","kind":"FK-blocked(template 부재)", **base})
            tally["t_prd_product_addons"]["blocked"] += 1

# ── 출력: insertable load/<NN>_<table>.csv (FK 위상정렬 prefix) ──────────────
# 단계번호: 03 products(n/a 신규는 blocked) / 04 sizes / 05 materials / 06 processes / 07 print_options
#           / 08 page_rules / 09 bundle_qtys / 10 addons
STEP = {
    "t_prd_product_sizes": "04",
    "t_prd_product_materials": "05",
    "t_prd_product_processes": "06",
    "t_prd_product_print_options": "07",
    "t_prd_product_page_rules": "08",
    "t_prd_product_bundle_qtys": "09",
    "t_prd_product_addons": "10",
}
for table, rows in sorted(insertable.items(), key=lambda kv: STEP[kv[0]]):
    cols = DB_COLS[table] + ["_provenance"]
    out = os.path.join(OUT_LOAD, f"{STEP[table]}_{table}.csv")
    write_csv(out, cols, rows)
    print(f"INSERTABLE {STEP[table]}_{table}.csv = {len(rows)}행")

# ── 출력: blocked 통합 ────────────────────────────────────────────────────
bcols = ["table","kind","prd_cd","proc_cd","tmpl_cd","_block_reason","_unblock","_provenance"]
os.makedirs(os.path.join(ROOT,"blocked"), exist_ok=True)
with open(os.path.join(ROOT,"blocked","relation-rows-blocked.csv"),"w",encoding="utf-8",newline="") as f:
    w = csv.writer(f); w.writerow(bcols)
    for r in blocked:
        w.writerow([r.get(c,"") for c in bcols])
print(f"\nBLOCKED rows = {len(blocked)}")

# ── 디자인캘린더 신규상품 번들 복제(차단: placeholder prd_cd) — 자기완결 번들화 ──
import shutil
dc_src = os.path.join(LOAD, "design-calendar", "load")
dc_dst = os.path.join(ROOT, "blocked", "design-calendar-newprod")
os.makedirs(dc_dst, exist_ok=True)
dc_n = 0
for fn in sorted(os.listdir(dc_src)):
    if fn.endswith(".csv"):
        shutil.copyfile(os.path.join(dc_src, fn), os.path.join(dc_dst, fn))
        dc_n += 1
print(f"BLOCKED design-calendar-newprod 복제 = {dc_n}파일 (placeholder prd_cd)")

# ── 집계 출력 ────────────────────────────────────────────────────────────
print("\n=== TALLY (table | insertable | blocked) ===")
ti = tb = 0
for t in sorted(tally):
    i = tally[t]["insertable"]; b = tally[t]["blocked"]
    ti += i; tb += b
    print(f"{t} | {i} | {b}")
print(f"TOTAL insertable={ti}  blocked(in-script)={tb}")
