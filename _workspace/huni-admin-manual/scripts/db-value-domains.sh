#!/usr/bin/env bash
# ham-db-verifier 재현 스크립트 — 라이브 Railway DB 읽기전용 실측
# [HARD] SELECT만. 비밀값은 .env.local에서만 읽고 stdout/파일에 노출하지 않음.
# 사용: bash _workspace/huni-admin-manual/scripts/db-value-domains.sh <섹션>
#   섹션: counts | codes | columns | checks | fks | pks | domains | samples | all
set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
q() { psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
# 그룹별 distinct 사용값 + 행수 (concat 표현식이 GROUP BY로 새는 것을 서브쿼리로 차단)
grpct() { q "SELECT v||' x'||c FROM (SELECT COALESCE($2::text,'(null)') v, count(*) c FROM $1 GROUP BY 1) s ORDER BY 1;"; }

sec="${1:-all}"

if [[ "$sec" == counts || "$sec" == all ]]; then
  echo "### 실제 행수 count(*) — pg_stat_user_tables는 stale이므로 count(*)가 권위"
  for t in $(q "SELECT tablename FROM pg_tables WHERE schemaname='public' AND tablename LIKE 't\_%' ORDER BY tablename;"); do
    echo "$t = $(q "SELECT count(*) FROM $t;")"
  done
fi

if [[ "$sec" == codes || "$sec" == all ]]; then
  echo "### t_cod_base_codes 코드값 사전 (그룹=upr_cod_cd)"
  q "SELECT cod_cd||' | '||cod_nm||' | upr='||COALESCE(upr_cod_cd,'(root)')||' | use='||use_yn FROM t_cod_base_codes ORDER BY COALESCE(upr_cod_cd,cod_cd), disp_seq, cod_cd;"
fi

if [[ "$sec" == columns || "$sec" == all ]]; then
  echo "### 전 t_* 컬럼 메타 (table | column | type | nullable | default | db_comment)"
  q "SELECT c.table_name||' || '||c.column_name||' || '||c.data_type||COALESCE('('||c.character_maximum_length||')','')||' || '||c.is_nullable||' || '||COALESCE(c.column_default,'')||' || '||COALESCE(pgd.description,'')
     FROM information_schema.columns c
     LEFT JOIN pg_catalog.pg_statio_all_tables st ON st.schemaname=c.table_schema AND st.relname=c.table_name
     LEFT JOIN pg_catalog.pg_description pgd ON pgd.objoid=st.relid AND pgd.objsubid=c.ordinal_position
     WHERE c.table_schema='public' AND c.table_name LIKE 't\_%'
     ORDER BY c.table_name, c.ordinal_position;"
fi

if [[ "$sec" == checks || "$sec" == all ]]; then
  echo "### CHECK 제약"
  q "SELECT conrelid::regclass||' || '||conname||' || '||pg_get_constraintdef(oid) FROM pg_constraint WHERE connamespace='public'::regnamespace AND contype='c' AND conrelid::regclass::text LIKE 't\_%' ORDER BY conrelid::regclass::text;"
fi

if [[ "$sec" == fks || "$sec" == all ]]; then
  echo "### FK 제약 (참조 마스터 선등록 의무)"
  q "SELECT conrelid::regclass||' || '||conname||' || '||pg_get_constraintdef(oid) FROM pg_constraint WHERE connamespace='public'::regnamespace AND contype='f' AND conrelid::regclass::text LIKE 't\_%' ORDER BY conrelid::regclass::text;"
fi

if [[ "$sec" == pks || "$sec" == all ]]; then
  echo "### PK / UNIQUE"
  q "SELECT conrelid::regclass||' || '||CASE contype WHEN 'p' THEN 'PK' ELSE 'UQ' END||' || '||pg_get_constraintdef(oid) FROM pg_constraint WHERE connamespace='public'::regnamespace AND contype IN ('p','u') AND conrelid::regclass::text LIKE 't\_%' ORDER BY conrelid::regclass::text, contype;"
fi

if [[ "$sec" == domains || "$sec" == all ]]; then
  echo "### 컬럼별 실제 사용 코드값 도메인 (라이브 distinct)"
  echo "-- t_prd_products.prd_typ_cd";        grpct t_prd_products prd_typ_cd
  echo "-- t_prd_products.qty_unit_typ_cd";   grpct t_prd_products qty_unit_typ_cd
  echo "-- t_prd_products.semi_role_cd";      grpct t_prd_products semi_role_cd
  echo "-- t_prd_products.nonspec_yn";        grpct t_prd_products nonspec_yn
  echo "-- t_prd_products.editor_yn";         grpct t_prd_products editor_yn
  echo "-- t_prd_products.file_upload_yn";    grpct t_prd_products file_upload_yn
  echo "-- t_mat_materials.mat_typ_cd";       grpct t_mat_materials mat_typ_cd
  echo "-- t_mat_materials.sel_typ_cd";       grpct t_mat_materials sel_typ_cd
  echo "-- t_prc_price_formulas.frm_typ_cd";  grpct t_prc_price_formulas frm_typ_cd
  echo "-- t_prc_price_components.comp_typ_cd"; grpct t_prc_price_components comp_typ_cd
  echo "-- t_prd_product_option_groups.sel_typ_cd"; grpct t_prd_product_option_groups sel_typ_cd
  echo "-- t_prd_product_option_items.ref_dim_cd"; grpct t_prd_product_option_items ref_dim_cd
  echo "-- t_prd_template_selections.ref_dim_cd"; grpct t_prd_template_selections ref_dim_cd
  echo "-- t_prd_product_plate_sizes.output_paper_typ_cd"; grpct t_prd_product_plate_sizes output_paper_typ_cd
  echo "-- t_prd_product_plate_sizes.output_file_typ (자유텍스트)"; grpct t_prd_product_plate_sizes output_file_typ
  echo "-- t_prd_product_print_options.print_side (자유텍스트)"; grpct t_prd_product_print_options print_side
  echo "-- t_prd_product_materials.usage_cd";  grpct t_prd_product_materials usage_cd
  echo "-- t_prd_product_bundle_qtys.bdl_unit_typ_cd"; grpct t_prd_product_bundle_qtys bdl_unit_typ_cd
  echo "-- t_prd_product_constraints.rule_typ_cd"; grpct t_prd_product_constraints rule_typ_cd
  echo "-- t_siz_sizes.impos_yn";             grpct t_siz_sizes impos_yn
fi

if [[ "$sec" == samples || "$sec" == all ]]; then
  echo "### 대표 예시 행"
  echo "-- products";  q "SELECT prd_cd||' | '||prd_nm||' | '||prd_typ_cd FROM t_prd_products ORDER BY prd_cd LIMIT 5;"
  echo "-- materials"; q "SELECT mat_cd||' | '||mat_nm||' | '||mat_typ_cd FROM t_mat_materials ORDER BY mat_cd LIMIT 5;"
  echo "-- sizes";     q "SELECT siz_cd||' | '||siz_nm||' | impos='||impos_yn FROM t_siz_sizes ORDER BY siz_cd LIMIT 5;"
  echo "-- formulas";  q "SELECT frm_cd||' | '||frm_nm||' | '||frm_typ_cd FROM t_prc_price_formulas ORDER BY frm_cd;"
fi
