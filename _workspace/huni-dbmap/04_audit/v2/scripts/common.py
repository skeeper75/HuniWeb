#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""공통 로더 — C 파이프라인 S0~S2 (입력 로드 + prd_nm→prd_cd 해소 + 비활성 신호).
read-only. DB 무변경. 입력 = 04_audit/excel-*.csv + 00_schema/ref-*.csv + 06_extract L1 메타."""
import csv, os, re, glob
from collections import defaultdict

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
AUDIT = os.path.join(ROOT, '04_audit')
SCHEMA = os.path.join(ROOT, '00_schema')
EXTRACT = os.path.join(ROOT, '06_extract')

def read_csv(path):
    with open(path, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

# ── S2 join-key 정규화 ──
def norm_prd(s):
    if s is None: return ''
    s = s.strip()
    s = re.sub(r'\s+', ' ', s)
    return s

def load_prd_map():
    """prd_nm(정규화) → [prd_cd...]. 동명 다건 허용."""
    m = defaultdict(list)
    info = {}
    for r in read_csv(os.path.join(SCHEMA, 'ref-products.csv')):
        nm = norm_prd(r['prd_nm'])
        m[nm].append(r['prd_cd'])
        info[r['prd_cd']] = r
    return m, info

def split_tokens(source_values):
    if not source_values: return []
    return [t.strip() for t in source_values.split('|') if t.strip()]

def load_excel(attr):
    """excel-<attr>.csv → rows. attr ∈ size,material,print-option,process,plate-size,bundle-qty,page-rule,addl-product"""
    return read_csv(os.path.join(AUDIT, f'excel-{attr}.csv'))

def load_ref(name):
    p = os.path.join(SCHEMA, f'ref-{name}.csv')
    return read_csv(p) if os.path.exists(p) else []

# ── 비활성(미출시) 신호: 그레이밴딩(품절/준비중) 상품행 ──
def load_inactive_signals():
    """L1 메타의 fill_meaning='품절/준비중'이 상품명 셀(A열 등)에 걸린 행 → 비활성 후보.
    상품명 단위로 집계. 반환: set(norm_prd_nm)에 가까운 후보 + 셀단위 카운트."""
    inactive_cells = defaultdict(int)  # (sheet) -> count, 진단용
    # 셀단위만 보존(상품행 귀속은 보수적: 미출시 단정 대신 신호 카운트)
    for fn in glob.glob(os.path.join(EXTRACT, '*-l1-meta.csv')):
        for r in read_csv(fn):
            if r.get('fill_meaning') == '품절/준비중':
                inactive_cells[r.get('sheet','')] += 1
    return inactive_cells

# ── master 룩업 ──
def proc_master():
    by_name = defaultdict(list); info={}
    for r in read_csv(os.path.join(SCHEMA, 'ref-processes.csv')):
        by_name[r['proc_nm'].strip()].append(r['proc_cd'])
        info[r['proc_cd']] = r
    return by_name, info

def size_master():
    by_nm = {}
    for r in read_csv(os.path.join(SCHEMA, 'ref-sizes.csv')):
        by_nm.setdefault(r['siz_nm'].strip(), r['siz_cd'])
    return by_nm

def mat_master():
    by_nm = defaultdict(list)
    for r in read_csv(os.path.join(SCHEMA, 'ref-materials.csv')):
        by_nm[r['mat_nm'].strip()].append(r['mat_cd'])
    return by_nm

def write_csv(path, fieldnames, rows):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r in rows: w.writerow(r)
