# -*- coding: utf-8 -*-
"""
round-4 가격(price) 적재본 조립 스크립트 (재현·G8 앵커).

입력 (검증 GO·round-2):
  02_mapping/load_price/{t_prc_price_formulas,t_prc_price_components,
    t_prc_formula_components,t_prc_component_prices,t_prd_product_price_formulas,
    t_cod_base_codes}.csv

출력 (FK 위상정렬 순서, 즉시 적재가능 행만):
  load/00_prc_component_type.csv         (code-row 선적재 제안)
  load/01_prc_price_formulas.csv
  load/02_prc_price_components.csv
  load/03_prc_formula_components.csv
  load/04_prc_component_prices.csv       (placeholder siz_cd 행 제외)
  load/05_prd_product_price_formulas.csv

조립 규칙:
  - t_* 화이트리스트만 대상 (G1).
  - component_prices: siz_cd 가 'SIZ_PENDING%' = 차단(blocked) → 적재본 제외.
    실코드 siz_cd / NULL(공란) siz_cd = 즉시 적재가능 → 적재본 포함.
  - comp_cd varchar(50) 초과 = 0건(현 CSV 최장 41자, B-FINAL-1 해소 확증) — 발견 시 중단.
  - 발명·침묵드롭 0: 차단 행수 + 적재 행수 = 원본 4805행 정확 재구성.
  - 컬럼명·값은 원본 그대로 보존(타입 변환 없음, round-2 검증 통과본).
"""
import csv, os, sys

SRC = os.path.join(os.path.dirname(__file__), "..", "..", "02_mapping", "load_price")
OUT = os.path.join(os.path.dirname(__file__), "load")
os.makedirs(OUT, exist_ok=True)

def read(name):
    with open(os.path.join(SRC, name), encoding="utf-8-sig", newline="") as f:
        r = csv.reader(f)
        rows = list(r)
    return rows[0], rows[1:]

def write(name, header, rows):
    # utf-8 (BOM 없음). DB 컬럼명 헤더 1행.
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(rows)
    return len(rows)

stats = {}

# --- step 00: code-row pre-load (PRC_COMPONENT_TYPE.06) ---
h, rows = read("t_cod_base_codes.csv")
assert len(rows) == 1 and rows[0][0] == "PRC_COMPONENT_TYPE.06", "code-row 예상과 불일치"
stats["00_prc_component_type"] = write("00_prc_component_type.csv", h, rows)

# --- step 01: price_formulas ---
h, rows = read("t_prc_price_formulas.csv")
stats["01_prc_price_formulas"] = write("01_prc_price_formulas.csv", h, rows)

# --- step 02: price_components ---
h, rows = read("t_prc_price_components.csv")
overflow = [r for r in rows if len(r[0]) > 50]
if overflow:
    sys.exit("BLOCKER: price_components comp_cd >50자: %r" % [r[0] for r in overflow])
stats["02_prc_price_components"] = write("02_prc_price_components.csv", h, rows)
valid_comps = {r[0] for r in rows}

# --- step 03: formula_components ---
h, rows = read("t_prc_formula_components.csv")
stats["03_prc_formula_components"] = write("03_prc_formula_components.csv", h, rows)

# --- step 04: component_prices (placeholder 분리) ---
h, rows = read("t_prc_component_prices.csv")
SIZ_IDX = h.index("siz_cd")
CC_IDX = h.index("comp_cd")
insertable, blocked = [], []
overflow_cp = []
for r in rows:
    if len(r[CC_IDX]) > 50:
        overflow_cp.append(r[CC_IDX])
    siz = r[SIZ_IDX].strip()
    if siz.upper().startswith("SIZ_PENDING"):
        blocked.append(r)
    else:
        # 실코드 또는 공란(NULL) — 즉시 적재가능
        insertable.append(r)
if overflow_cp:
    sys.exit("BLOCKER: component_prices comp_cd >50자: %r" % overflow_cp[:5])
# 고아 comp_cd 점검 (적재본 한정)
orphan = {r[CC_IDX] for r in insertable} - valid_comps
if orphan:
    sys.exit("BLOCKER: 적재본 component_prices 고아 comp_cd: %r" % sorted(orphan)[:5])
stats["04_prc_component_prices"] = write("04_prc_component_prices.csv", h, insertable)
cp_total = len(rows)
assert len(insertable) + len(blocked) == cp_total, "행수 불일치(침묵드롭)"

# --- step 05: product_price_formulas ---
h, rows = read("t_prd_product_price_formulas.csv")
stats["05_prd_product_price_formulas"] = write("05_prd_product_price_formulas.csv", h, rows)

# 리포트
print("=== 적재본 조립 완료 (즉시 적재가능 행만) ===")
for k in sorted(stats):
    print(f"  {k}: {stats[k]} rows")
print(f"--- component_prices: insertable={len(insertable)} / blocked(placeholder)={len(blocked)} / total={cp_total}")
# 즉시 적재가능 합계 = 전 적재 CSV 행수 합(실제 산출값에서 도출 — 매니페스트 §0/§3-1 합계와 정합)
grand_total = sum(stats.values())
print(f"--- 즉시 적재가능 합계(전 6 load CSV 행수 합) = {grand_total} (매니페스트 §0/§3-1 '즉시 적재가능' 값)")
print("--- 차단 행은 적재본에서 제외(blocked-and-gaps.md 참조)")
