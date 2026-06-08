#!/usr/bin/env python3
"""
build_matrix.py — round-7 입체 커버리지: 매트릭스 조립

excel-requirements.csv (필요여부, 엑셀 권위) + db-coverage-raw.csv (실측 행수, 라이브) 를 합쳐
(family × entity) 셀마다 상태(LOADED/PARTIAL/MISSING/N/A)를 판정하고
coverage-cells.csv + coverage-matrix.md 를 생성한다.

상태 판정(skill §5):
  required=N                      -> N/A (➖)
  required=Y & total_rows==0      -> MISSING (❌)
  required=Y & prds_with_rows==n  -> LOADED (✅)   (그 상품군 전 상품이 행 보유)
  required=Y & 0<prds_with_rows<n -> PARTIAL (🟡)

재현: python3 build_matrix.py  (extract_excel_requirements.py, probe_db_coverage.sh 선행)
"""
import csv, os
from collections import defaultdict

HERE=os.path.dirname(__file__)
COV=os.path.join(HERE,'..')
REQ_F=os.path.join(COV,'excel-requirements.csv')
DB_F=os.path.join(COV,'db-coverage-raw.csv')
CELLS_F=os.path.join(COV,'coverage-cells.csv')
MATRIX_F=os.path.join(COV,'coverage-matrix.md')

FAMS=['digital-print','sticker','booklet','photobook','calendar','design-calendar',
      'silsa','acrylic','stationery','goods-pouch','product-accessory']
FAM_KO={'digital-print':'디지털인쇄','sticker':'스티커','booklet':'책자','photobook':'포토북',
 'calendar':'캘린더','design-calendar':'디자인캘린더','silsa':'실사','acrylic':'아크릴',
 'stationery':'문구','goods-pouch':'굿즈파우치','product-accessory':'상품악세사리'}

# Entity display order + short labels for the matrix header
ENTITIES=[
 ('t_prd_products','products'),
 ('t_prd_product_categories','categories'),
 ('t_prd_product_sizes','sizes'),
 ('t_prd_product_materials','materials'),
 ('t_prd_product_print_options','print_opts'),
 ('t_prd_product_processes','processes'),
 ('t_prd_product_plate_sizes','plate_sizes'),
 ('t_prd_product_bundle_qtys','bundle_qtys'),
 ('t_prd_product_page_rules','page_rules'),
 ('t_prd_product_sets','sets'),
 ('t_prd_product_addons','addons'),
 ('t_prd_product_option_groups','opt_groups'),
 ('t_prd_product_options','options'),
 ('t_prd_product_option_items','opt_items'),
 ('t_prd_templates','templates'),
 ('t_prd_product_constraints','constraints'),
 ('t_prd_product_price_formulas','price_frm'),
 ('t_prc_component_prices','comp_prices'),
 ('t_prd_product_discount_tables','discounts'),
]

def _flat(s):
    """임베드 개행/캐리지리턴 제거 — CSV 소비자 견고성."""
    return (s or '').replace('\r',' ').replace('\n',' ').strip()

def load_req():
    req={}; ev={}
    with open(REQ_F,encoding='utf-8') as f:
        for r in csv.DictReader(f):
            req[(r['family'],r['entity'])]=r['required']
            ev[(r['family'],r['entity'])]=_flat(r['evidence_columns'])
    return req,ev

def load_db():
    db={}
    with open(DB_F,encoding='utf-8') as f:
        for r in csv.DictReader(f):
            db[(r['family'],r['entity'])]=(int(r['prds_in_family']),int(r['prds_with_rows']),int(r['total_rows']))
    return db

ICON={'LOADED':'✅','PARTIAL':'🟡','MISSING':'❌','N/A':'➖','DB-ONLY':'◆'}

def state_of(required, db_tuple):
    n,wr,tr = db_tuple if db_tuple else (0,0,0)
    if required!='Y':
        # 엑셀 master 미요구지만 DB에 행이 있으면 DB-ONLY(외부 권위 적재/과적재 후보) — 은폐 금지
        if tr>0:
            return 'DB-ONLY',n,wr,tr
        return 'N/A',n,wr,tr
    if tr==0:
        return 'MISSING',n,wr,tr
    if wr>=n and n>0:
        return 'LOADED',n,wr,tr
    return 'PARTIAL',n,wr,tr

def main():
    req,ev=load_req(); db=load_db()
    cells=open(CELLS_F,'w',encoding='utf-8',newline='')
    cw=csv.writer(cells); cw.writerow(['family','entity','required','state','prds_in_family','prds_with_rows','total_rows','source_cell','note'])
    agg=defaultdict(int)
    grid={}  # (fam,entity)->(icon,state,n,wr,tr)
    for fam in FAMS:
        for ent,_ in ENTITIES:
            required=req.get((fam,ent),'N')
            state,n,wr,tr=state_of(required, db.get((fam,ent)))
            agg[state]+=1
            grid[(fam,ent)]=(ICON[state],state,n,wr,tr)
            note=''
            if state=='PARTIAL': note=f'{wr}/{n} 상품만 행 보유'
            elif state=='MISSING': note='필요한데 라이브 0행'
            elif state=='N/A': note='엑셀이 이 엔티티 요구 안 함'
            elif state=='DB-ONLY': note=f'엑셀 master 미요구이나 DB {tr}행 존재(외부 권위 적재/과적재 후보 — gap-board 참조)'
            cw.writerow([fam,ent,required,state,n,wr,tr,ev.get((fam,ent),''),note])
    cells.close()

    # Build matrix.md
    lines=[]
    lines.append('# 입체 커버리지 매트릭스 — 상품마스터 11 상품군 × 라이브 t_* 엔티티')
    lines.append('')
    lines.append('> 생성: `scripts/build_matrix.py` (= extract_excel_requirements.py + probe_db_coverage.sh).  ')
    lines.append('> 권위: 필요여부=엑셀 명시값(`06_extract/*-l1.csv`), 상태=라이브 DB 실측 행수(읽기전용 psql).  ')
    lines.append('> 셀 표기: `아이콘 wr/n` — wr=행 보유 상품수, n=그 상품군 해소 상품수. LOADED는 `✅ n` (전 상품 보유).')
    lines.append('')
    lines.append('## 범례')
    lines.append('')
    lines.append('| 아이콘 | 상태 | 의미 |')
    lines.append('|:--:|------|------|')
    lines.append('| ✅ | LOADED | 필요 + 그 상품군 전 상품이 행 보유 |')
    lines.append('| 🟡 | PARTIAL | 필요 + 일부 상품만 행 보유 |')
    lines.append('| ❌ | MISSING | 필요한데 라이브 0행 |')
    lines.append('| ◆ | DB-ONLY | 엑셀 master 미요구이나 DB에 행 존재 (외부 권위 적재 또는 과적재 후보 — gap-board) |')
    lines.append('| ➖ | N/A | 엑셀이 이 엔티티를 요구하지 않음 + DB도 0행 |')
    lines.append('')
    tot=sum(agg.values())
    lines.append(f'## 집계 (총 {tot} 셀 = 11 상품군 × {len(ENTITIES)} 엔티티)')
    lines.append('')
    lines.append(f'- ✅ LOADED: **{agg["LOADED"]}**')
    lines.append(f'- 🟡 PARTIAL: **{agg["PARTIAL"]}**')
    lines.append(f'- ❌ MISSING: **{agg["MISSING"]}**')
    lines.append(f'- ◆ DB-ONLY: **{agg.get("DB-ONLY",0)}**')
    lines.append(f'- ➖ N/A: **{agg["N/A"]}**')
    lines.append('')
    # Matrix table: rows=entity, cols=family (families are wide; entities are ~19 -> rows)
    hdr='| 엔티티 \\ 상품군 | '+' | '.join(FAM_KO[f] for f in FAMS)+' |'
    sep='|'+'---|'*(len(FAMS)+1)
    lines.append('## 매트릭스 (행=엔티티, 열=상품군)')
    lines.append('')
    lines.append(hdr); lines.append(sep)
    for ent,short in ENTITIES:
        cells_str=[]
        for fam in FAMS:
            icon,state,n,wr,tr=grid[(fam,ent)]
            if state=='LOADED': cells_str.append(f'{icon} {n}')
            elif state=='PARTIAL': cells_str.append(f'{icon} {wr}/{n}')
            elif state=='DB-ONLY': cells_str.append(f'{icon} {tr}r')
            elif state=='MISSING': cells_str.append(f'{icon}')
            else: cells_str.append(f'{icon}')
        lines.append(f'| `{short}` | '+' | '.join(cells_str)+' |')
    lines.append('')
    lines.append('> `short` ↔ 실제 테이블: products=t_prd_products, categories=t_prd_product_categories,')
    lines.append('> sizes/materials/print_opts/processes/plate_sizes/bundle_qtys/page_rules/sets/addons=t_prd_product_*,')
    lines.append('> opt_groups/options/opt_items=t_prd_product_option_*, templates=t_prd_templates,')
    lines.append('> constraints=t_prd_product_constraints, price_frm=t_prd_product_price_formulas,')
    lines.append('> comp_prices=t_prc_component_prices(공식사슬 경유), discounts=t_prd_product_discount_tables.')
    lines.append('')
    lines.append('## 3원 대조 (엑셀 ↔ DB ↔ admin product-viewer) — C4 증거')
    lines.append('')
    lines.append('라이브 admin(`/admin/product-viewer/<prd_cd>/`) 로그인 성공. 대표상품 + 미적재 의심분 3종 대조.')
    lines.append('admin 탭의 (행수) = t_* 엔티티 역할 UI ground-truth. **3종 모두 admin 탭 = DB 실측 = 정확 일치.**')
    lines.append('캡처: `admin-captures/`.')
    lines.append('')
    lines.append('| 상품 | 상품군 | admin 탭(행수) | DB 실측 | 엑셀 요구 | 일치 |')
    lines.append('|------|--------|---------------|---------|----------|:---:|')
    lines.append('| PRD_000016 프리미엄엽서 | 디지털인쇄(대표) | 사이즈7·도수2·판형1·자재21·공정6·묶음0·추가1·페이지0·옵션그룹0·제약0 | sizes7·print2·plate1·mat21·proc6·bdl0·addon1·page0·optg0·con0·frm1 | 사이즈/종이/인쇄/별색/코팅/커팅/후가공/추가 | ✅ |')
    lines.append('| PRD_000111 벽걸이캘린더 | 캘린더(미적재 의심) | 사이즈3·도수2·판형1·자재23·공정2·추가0·페이지0·옵션그룹0·제약0 | sizes3·print2·plate1·mat23·proc2·addon0·page0·optg0·frm0 | 장수(page)·캘린더가공(옵션)·추가상품 → DB 0 확증 | ✅ |')
    lines.append('| PRD_000193 머그컵 | 굿즈파우치(기성품) | 사이즈0·자재4·판형1·나머지0 | sizes0·mat4·plate1·discount1 | 사이즈(필수) 컬럼有 but DB size 0 → DOMAIN-UNDECIDED | ✅ |')
    lines.append('')
    lines.append('> admin = DB 100% 일치 → DB 실측 행수를 상태 권위로 신뢰 가능(C3·C4). 캘린더 page/옵션그룹/추가 0,')
    lines.append('> 머그컵 size 0 은 admin 으로도 재확인(미적재가 사실임을 UI 가 확증). 날조 0.')
    lines.append('')
    lines.append('## 해소 캐비엇 (matrix 행 해석 주의)')
    lines.append('')
    lines.append('1. **calendar ↔ design-calendar 동일 prd_cd 공유** — 두 상품군 모두 PRD_000108~112(탁상/미니/엽서/')
    lines.append('   벽걸이/와이드벽걸이) 5상품을 가리킨다(라이브 prd_nm 1:1 확인). 같은 물리 상품을 두 시트가 다른')
    lines.append('   속성으로 기술 → 두 행의 상태가 유사한 것은 정상(오류 아님).')
    lines.append('2. **prd_cd 해소 = prd_nm 조인**(MES_ITEM_CD 전부 NULL — 유일 가능 키). 264 (family,prd_nm) 중')
    lines.append('   250 해소·14 미해소(★신규상품·"(보류중)"·하이퍼링크·코멘트행 — DB 미등록이 정상).')
    lines.append('3. **DB-ONLY(◆) 17셀**은 엑셀 master 가 요구 안 했으나 DB 행 존재 — 외부 권위(가격표 판걸이수·')
    lines.append('   round-1 구간할인) 적재 또는 과적재 후보. C2(추측 0) 준수로 required=Y 자동전환 안 함, gap-board §6.')
    lines.append('')
    lines.append('## 셀 단위 실측은 `coverage-cells.csv`, 미적재 갭 분류는 `gap-board.md`, 관계 무결성은 `relationship-integrity.md` 참조.')
    open(MATRIX_F,'w',encoding='utf-8').write('\n'.join(lines)+'\n')
    print(f'wrote {CELLS_F}')
    print(f'wrote {MATRIX_F}')
    print('agg:',dict(agg))

if __name__=='__main__':
    main()
