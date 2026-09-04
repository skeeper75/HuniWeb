"""t42 ① 사이즈 코드 참조처 전수 실측 → refs.csv (읽기전용 SELECT 만)"""
import csv
import sys

sys.path.insert(0, '.moai/reports/t42')
from dbq import q  # noqa: E402

TARGETS = ['SIZ_000036', 'SIZ_000064', 'SIZ_000172', 'SIZ_000258', 'SIZ_000514',
           'SIZ_000515', 'SIZ_000518', 'SIZ_000519', 'SIZ_000521', 'SIZ_000538',
           'SIZ_000539', 'SIZ_000541', 'SIZ_000498', 'SIZ_000499']
IN = "'" + "','".join(TARGETS) + "'"

# (라벨, SQL) — 각 SQL 은 siz_cd, cnt, detail 3열을 낸다
# del_yn 이 있는 표면은 살아있는 행(N)과 논리삭제 행(Y)을 갈라서 센다 — 합쳐 세면
# 이미 죽은 참조가 blast radius 로 잘못 잡힌다.
PROBES = [
    ("t_prd_product_sizes.siz_cd[살아있음]",
     f"select siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_product_sizes where siz_cd in ({IN}) and del_yn='N' group by siz_cd"),
    ("t_prd_product_sizes.siz_cd[논리삭제]",
     f"select siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_product_sizes where siz_cd in ({IN}) and del_yn='Y' group by siz_cd"),
    ("t_prd_product_plate_sizes.siz_cd[살아있음]",
     f"select siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_product_plate_sizes where siz_cd in ({IN}) and del_yn='N' group by siz_cd"),
    ("t_prd_product_plate_sizes.siz_cd[논리삭제]",
     f"select siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_product_plate_sizes where siz_cd in ({IN}) and del_yn='Y' group by siz_cd"),
    ("t_prd_product_plate_sizes.item_siz_cd",
     f"select item_siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_product_plate_sizes where item_siz_cd in ({IN}) group by item_siz_cd"),
    ("t_prc_component_prices.siz_cd",
     f"select siz_cd, count(*), string_agg(distinct comp_cd,',' order by comp_cd) "
     f"from t_prc_component_prices where siz_cd in ({IN}) group by siz_cd"),
    ("t_prc_component_prices.siz_cd[고아=상품 미연결]",
     f"select p.siz_cd, count(*), string_agg(distinct p.comp_cd,',' order by p.comp_cd) "
     f"from t_prc_component_prices p where p.siz_cd in ({IN}) "
     f"and not exists (select 1 from t_prd_product_sizes ps "
     f"                where ps.siz_cd=p.siz_cd and ps.del_yn='N') group by p.siz_cd"),
    ("t_prc_component_prices.plt_siz_cd",
     f"select plt_siz_cd, count(*), string_agg(distinct comp_cd,',' order by comp_cd) "
     f"from t_prc_component_prices where plt_siz_cd in ({IN}) group by plt_siz_cd"),
    ("t_prc_component_prices.dim_vals(JSON)",
     f"select t.c, count(*), string_agg(distinct p.comp_cd,',' order by p.comp_cd) "
     f"from t_prc_component_prices p, unnest(array[{IN}]) t(c) "
     f"where p.dim_vals::text like '%'||t.c||'%' group by t.c"),
    ("t_prd_edicus_templates.siz_cd",
     f"select siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_edicus_templates where siz_cd in ({IN}) group by siz_cd"),
    ("t_prd_edicus_templates.plt_siz_cd",
     f"select plt_siz_cd, count(*), string_agg(distinct prd_cd,',' order by prd_cd) "
     f"from t_prd_edicus_templates where plt_siz_cd in ({IN}) group by plt_siz_cd"),
    ("t_prd_product_option_items.ref_key1",
     f"select ref_key1, count(*), string_agg(distinct opt_cd,',' order by opt_cd) "
     f"from t_prd_product_option_items where ref_key1 in ({IN}) group by ref_key1"),
    ("t_prd_template_selections.ref_key1",
     f"select ref_key1, count(*), string_agg(distinct tmpl_cd,',' order by tmpl_cd) "
     f"from t_prd_template_selections where ref_key1 in ({IN}) group by ref_key1"),
    ("t_wgt_widget_versions.cfg(JSON)",
     f"select t.c, count(*), string_agg(distinct w.wgt_cd,',' order by w.wgt_cd) "
     f"from t_wgt_widget_versions w, unnest(array[{IN}]) t(c) "
     f"where w.cfg::text like '%'||t.c||'%' group by t.c"),
    ("t_wgt_widget_items.ref_key",
     f"select ref_key, count(*), string_agg(distinct wgt_cd,',' order by wgt_cd) "
     f"from t_wgt_widget_items where ref_key in ({IN}) group by ref_key"),
    ("t_prd_templates.dim_sels(JSON)",
     f"select t.c, count(*), string_agg(distinct x.tmpl_cd,',' order by x.tmpl_cd) "
     f"from t_prd_templates x, unnest(array[{IN}]) t(c) "
     f"where x.dim_sels::text like '%'||t.c||'%' group by t.c"),
    ("t_prd_designs.fixed_specs(JSON)",
     f"select t.c, count(*), '' from t_prd_designs x, unnest(array[{IN}]) t(c) "
     f"where x.fixed_specs::text like '%'||t.c||'%' group by t.c"),
    ("t_prd_edicus_configs.dim_filters(JSON)",
     f"select t.c, count(*), '' from t_prd_edicus_configs x, unnest(array[{IN}]) t(c) "
     f"where x.dim_filters::text like '%'||t.c||'%' group by t.c"),
    ("t_prd_tmpl_combo_configs.dim_filters(JSON)",
     f"select t.c, count(*), '' from t_prd_tmpl_combo_configs x, unnest(array[{IN}]) t(c) "
     f"where x.dim_filters::text like '%'||t.c||'%' group by t.c"),
]

rows = []
for label, sql in PROBES:
    try:
        out = q(sql + " order by 1;", tuples=True)
    except Exception as e:
        rows.append({'surface': label, 'siz_cd': '(ERROR)', 'cnt': '',
                     'detail': str(e)[:200]})
        continue
    hits = 0
    for line in out.splitlines():
        if not line.strip():
            continue
        parts = line.split('\t')
        rows.append({'surface': label, 'siz_cd': parts[0], 'cnt': parts[1],
                     'detail': (parts[2] if len(parts) > 2 else '')[:400]})
        hits += 1
    if hits == 0:
        rows.append({'surface': label, 'siz_cd': '(none)', 'cnt': '0', 'detail': ''})

with open('.moai/reports/t42/refs.csv', 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['surface', 'siz_cd', 'cnt', 'detail'])
    w.writeheader()
    w.writerows(rows)
print(f'refs.csv rows={len(rows)}')
for r in rows:
    print(f"{r['surface']:<42} {r['siz_cd']:<12} {r['cnt']:>5}  {r['detail'][:90]}")
