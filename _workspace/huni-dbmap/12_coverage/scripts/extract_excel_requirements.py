#!/usr/bin/env python3
"""
extract_excel_requirements.py — round-7 입체 커버리지: 축2 필요요소 도출 (엑셀 권위)

각 상품군 L1 CSV(06_extract/<slug>-l1.csv)의 컬럼 구조 + 실제 비어있지 않은 값을 근거로
그 상품군이 요구하는 t_* 엔티티 집합을 결정적으로 산출한다. 추측 0 — 컬럼 존재 + 값 존재만 근거.

도출 규칙(skill §3) = 엑셀 컬럼 키워드 → 필요 엔티티. 출처(컬럼명)를 같이 기록.

출력: 12_coverage/excel-requirements.csv  (family, entity, required, evidence_columns)
재현: python3 extract_excel_requirements.py
"""
import csv, os, sys, json

EXTRACT = os.path.join(os.path.dirname(__file__), '..', '..', '06_extract')
OUT = os.path.join(os.path.dirname(__file__), '..', 'excel-requirements.csv')

FAMILIES = {
 'digital-print':'digital-print-l1.csv','sticker':'sticker-l1.csv','booklet':'booklet-l1.csv',
 'photobook':'photobook-l1.csv','calendar':'calendar-l1.csv','design-calendar':'design-calendar-l1.csv',
 'silsa':'silsa-l1.csv','acrylic':'acrylic-l1.csv','stationery':'stationery-l1.csv',
 'goods-pouch':'goods-pouch-l1.csv','product-accessory':'product-accessory-l1.csv',
}

# 가격 권위는 상품마스터 inline 컬럼 OR 별도 가격표 시트(price-<slug>) 양쪽에 있다
# ([[dbmap-l2-requires-l1-price-table]]). 마스터에 inline 가격 컬럼이 없어도(예: 스티커·실사·책자)
# 전용 가격표 시트가 있으면 그 상품군은 가격(price_formulas + component_prices)을 필요로 한다.
# sheet-slug-map.md 기준 — 가격표 단가시트를 보유한 상품군:
PRICE_TABLE_FAMILIES = {
 'digital-print','sticker','booklet','photobook','calendar','design-calendar',
 'silsa','acrylic','stationery','product-accessory',
 # goods-pouch: 가격표 단가시트 없음(구간할인만) → 마스터 inline 가격 컬럼으로만 판정
}

# 비-마스터 권위 시트가 요구할 수 있는 엔티티 (마스터 컬럼엔 없지만 DB에 적재됨).
# C2(추측 0) 준수를 위해 이들은 required=Y 로 자동 전환하지 않는다 — 마스터 시트 단독으로는
# "필요" 근거가 없기 때문. 대신 build_matrix 가 'DB-only'(엑셀 master 미요구·DB 행 존재)로
# 별도 표기하고 gap-board 가 외부 권위(가격표 판걸이수/round-1 구간할인/굿즈 자재)로 라우팅한다.
# 후보(증거: db-coverage-raw.csv 행수 + 권위 메모):
#  plate_sizes: booklet/photobook/silsa/acrylic/stationery/goods-pouch
#    ← 가격표 판걸이수(pangeori) 출력판형 권위 [[dbmap-platesize-is-output-paper]]
#  discount_tables: acrylic/goods-pouch/stationery ← round-1 구간할인 [[dbmap-discount-authority]]
#  materials: goods-pouch/product-accessory ← 기성/원단 본체 자재

# 엔티티 → (컬럼 키워드 매칭 규칙). 키워드는 컬럼 헤더에 substring 매칭.
# skill §3 규칙. 코어(products/categories)는 모든 상품군이 무조건 필요.
ENTITY_RULES = [
 ('t_prd_products',          None),   # always
 ('t_prd_product_categories',None),   # always (상품은 카테고리에 매달림)
 ('t_prd_product_sizes',     ['사이즈(필수)','사이즈']),
 ('t_prd_product_materials', ['종이','소재','내지종이','표지종이','내지(옵션)','종이사양','종이(필수)','종이(옵션)','표지종이사양','표지사양']),
 ('t_prd_product_print_options', ['인쇄(옵션)','인쇄(필수)','인쇄사양','내지인쇄','표지인쇄','별색인쇄','인쇄']),
 ('t_prd_product_processes', ['코팅','커팅','접지','후가공','박','형압','캘린더가공','캘린더사양','가공(옵션)','제본','조각수','삼각대','조각수(옵션)']),
 ('t_prd_product_plate_sizes', ['출력용지규격']),
 # bundle_qtys = 묶음/포장단위(bdl_qty). 판수(=판걸이수/임포지션)는 bundle 아님(앱 계산, DB 미저장
 # [[dbmap-compute-in-app-db-stores-lookup]]) → 제외. 개별포장만.
 ('t_prd_product_bundle_qtys', ['개별포장']),
 ('t_prd_product_page_rules', ['페이지','내지페이지','장수']),
 ('t_prd_product_sets', ['표지타입','표지사양']),
 ('t_prd_product_addons', ['추가상품']),
 # CPQ L2 옵션레이어 — 선택/가공/옵션성 컬럼이 있으면 옵션레이어 후보
 ('t_prd_product_option_groups', ['선택(옵션)','가공(옵션)','별색인쇄','캘린더가공','조각수','표지옵션','제본(옵션)','내지(옵션)','코팅(옵션)']),
 ('t_prd_product_options', ['선택(옵션)','가공(옵션)','별색인쇄','캘린더가공','조각수','표지옵션','제본(옵션)','내지(옵션)','코팅(옵션)']),
 ('t_prd_product_option_items', ['선택(옵션)','가공(옵션)','별색인쇄','캘린더가공','조각수','표지옵션','제본(옵션)','내지(옵션)','코팅(옵션)']),
 # templates: 편집기 모드 상품만 템플릿 필요. 정확 컬럼 `주문방법(필수)_편집기`=Y 일 때만.
 # (페이지(편집기) 같은 수치 컬럼·범용 '편집기' substring 오매칭 방지) → 전용 규칙으로 처리.
 ('t_prd_templates', ['__EDITOR_Y__']),
 ('t_prd_product_constraints', ['커팅(옵션)','캘린더가공','표지옵션','제본방향','별색인쇄']),  # 캐스케이드/배타 가능성
 # 가격
 ('t_prd_product_price_formulas', ['가격','가격공식','price','추가가격','가격_기본']),
 ('t_prc_component_prices', ['가격','가격공식','price','추가가격','가격_기본']),
 # 할인
 ('t_prd_product_discount_tables', ['구간할인적용테이블']),
]

def load_family(fn):
    path=os.path.join(EXTRACT,fn)
    with open(path,encoding='utf-8-sig') as f:
        r=csv.DictReader(f)
        cols=[c for c in r.fieldnames if c]
        rows=list(r)
    # which columns have at least one non-empty content value across data rows
    nonempty=set()
    for c in cols:
        for row in rows:
            v=(row.get(c) or '').strip()
            if v and v not in ('None',):
                nonempty.add(c); break
    return cols, nonempty, rows

def match_cols(keywords, cols, nonempty):
    """return list of columns whose header contains any keyword AND has non-empty values"""
    if keywords is None: return None  # always-required marker
    hits=[]
    for c in cols:
        for kw in keywords:
            if kw in c and c in nonempty:
                hits.append(c); break
    return hits


def has_dimension_values(col, rows):
    """plate-size guard: column must carry actual paper-spec dims (e.g. 316x467),
    not a free-text note. Avoids false 출력용지규격 positives (silsa = note only)."""
    import re
    pat=re.compile(r'\d{2,4}\s*[xX×]\s*\d{2,4}')
    for row in rows:
        v=(row.get(col) or '').strip()
        if v and pat.search(v):
            return True
    return False

def _flat(s):
    """컬럼 헤더에 임베드된 개행 제거 — CSV 소비자 견고성(silsa price 헤더가 멀티라인)."""
    return (s or '').replace('\r',' ').replace('\n',' ').strip()

def main():
    out=open(OUT,'w',encoding='utf-8',newline='')
    w=csv.writer(out); w.writerow(['family','entity','required','evidence_columns'])
    for fam,fn in FAMILIES.items():
        cols,nonempty,rows=load_family(fn)
        for entity,kws in ENTITY_RULES:
            if kws is None:
                w.writerow([fam,entity,'Y','always (상품 코어)'])
                continue
            # templates: 전용 규칙 — `주문방법(필수)_편집기`=Y 인 상품이 하나라도 있으면 필요.
            if kws==['__EDITOR_Y__']:
                edcol='주문방법(필수)_편집기'
                has_editor = edcol in cols and any((row.get(edcol) or '').strip().upper()=='Y' for row in rows)
                hits=[edcol] if has_editor else []
                req='Y' if hits else 'N'
                w.writerow([fam,entity,req,_flat('|'.join(hits)) if hits else ''])
                continue
            hits=match_cols(kws,cols,nonempty)
            # plate-size guard: require actual dimension values, not free-text notes
            if entity=='t_prd_product_plate_sizes' and hits:
                hits=[c for c in hits if has_dimension_values(c,rows)]
            req='Y' if hits else 'N'
            # 가격: 마스터 inline 컬럼이 없어도 전용 가격표 시트가 있으면 필요(권위=가격표)
            if entity in ('t_prd_product_price_formulas','t_prc_component_prices') \
               and req=='N' and fam in PRICE_TABLE_FAMILIES:
                req='Y'
                w.writerow([fam,entity,req,f'price-table sheet (가격표 단가시트 보유, sheet-slug-map.md)'])
                continue
            w.writerow([fam,entity,req,_flat('|'.join(hits)) if hits else ''])
    out.close()
    print(f"wrote {OUT}")

if __name__=='__main__':
    main()
