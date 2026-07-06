#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""작업 전 필수 preflight — 추측·재질문 대신 원본을 먼저 로딩한다.
SOT + 해당 상품 관련 시트의 실무진 코멘트 + pricing.py 격자식 포인터 + 라이브 현재 사슬(읽기전용).
사용: python3 preflight.py "<상품명 또는 키워드>"   예) python3 preflight.py 프리미엄명함
[HARD] 라이브 DB 직접 적재 금지 — 적재는 webadmin UI로만. 이 스크립트는 읽기 전용 진단.
"""
import sys, os, re
KW = sys.argv[1] if len(sys.argv) > 1 else ""
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
os.chdir(ROOT)

print("="*72); print(f"PREFLIGHT — 키워드: {KW!r}  (읽기전용·webadmin UI로만 적재)"); print("="*72)

# 1) SOT 존재 확인 + 핵심 포인터
sot = "_workspace/_foundation/PRICE-SHEET-SOT-260705.md"
print(f"\n[1] 시트 구조 정본(SOT) — 먼저 정독: {sot}")
print("    최신 권위: 가격표 260705 · 상품마스터 260703. 값=단가.01(×수량)/총액.02(그대로)/합가.")

# 2) 관련 시트의 실무진 코멘트(주황/설명형) 추출
print(f"\n[2] 원본 실무진 코멘트 (엑셀 셀) — 이걸 읽으면 이해됨:")
try:
    import openpyxl
    wb = openpyxl.load_workbook("docs/huni/후니프린팅_인쇄상품_가격표_260705.xlsx", data_only=True)
    KWRE = re.compile(r'의미|포함|합산|합가|단가|이하|이상|자동|경우|마다|별도|기준|제외|통용|직접입력|세트|구간|동판|판형|여백')
    ORANGE = {'FFFF9900','FFCE5CD','FFFEF1CC','FFFFF2CC','FFFFE599','FFFFFF00'}
    want = [ws for ws in wb.worksheets if not KW or KW in ws.title or any(KW in str(c.value or "") for r in ws.iter_rows() for c in r)]
    for ws in (want or wb.worksheets)[:4]:
        notes = []
        for row in ws.iter_rows():
            for c in row:
                v = c.value
                if v is None: continue
                s = str(v).strip()
                if len(s) >= 8 and re.search(r'[가-힣]', s) and KWRE.search(s) and not re.fullmatch(r'[\d,.\s원장개]+', s):
                    notes.append(f"      {c.coordinate}: {s[:96]}")
        if notes:
            print(f"    ─ [{ws.title}]")
            print("\n".join(notes[:10]))
except Exception as e:
    print(f"    (openpyxl 로딩 실패: {e} — extract_sheet_notes.py 참조)")

# 3) 코드 격자식 포인터
print(f"\n[3] 격자 처리 = 코드에서 확정 (묻지 말고 읽기):")
print("    raw/webadmin/webadmin/catalog/pricing.py")
print("    · 면적 이하-ceiling: match_component 157~178행 (siz_width/height '이상 임계 중 최소' 착지·21→30)")
print("    · 값의미 prc_typ: 48~54행 (.01단가×수량 / .02총액그대로 / .03 FLAT)")
print("    · siz_cd→재단치수: _reduce_siz_dims 312행 · 판수 fn_calc_pansu")

# 4) 라이브 현재 사슬(읽기전용) — 있으면
print(f"\n[4] 라이브 현재 사슬 (읽기전용 SELECT):")
try:
    sys.path.insert(0, "_workspace/_foundation/batch")
    import lib_huni as L
    L.load_env()
    rows = L.db(f"""SELECT p.prd_cd,p.prd_nm,
      (SELECT string_agg(DISTINCT f.frm_cd,',') FROM t_prd_product_price_formulas pf
         JOIN t_prc_price_formulas f ON f.frm_cd=pf.frm_cd WHERE pf.prd_cd=p.prd_cd) frm
      FROM t_prd_products p WHERE p.del_yn='N' AND p.prd_nm LIKE '%{KW}%' ORDER BY p.prd_cd LIMIT 8""")
    for r in rows:
        print(f"    {r[0]} {r[1]} ← 공식 {r[2] or '(미배선!)'}")
except Exception as e:
    print(f"    (라이브 조회 스킵: {e})")

print(f"\n[5] 적재 경로 체크리스트: _workspace/huni-webadmin-load/WEBADMIN-LOAD-PATH-MAP.md")
print("    → 위를 다 읽고 나서 webadmin UI 적재 시작. 종료척도=시뮬레이터 제외0·예측=실제.")
