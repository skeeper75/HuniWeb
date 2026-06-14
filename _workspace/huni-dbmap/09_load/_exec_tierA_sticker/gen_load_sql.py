#!/usr/bin/env python3
"""
gen_load_sql.py — 스티커 Tier A 4상품 CPQ 옵션레이어 적재 SQL 생성기 (참조용)

[중요] 본 패키지의 적재 SQL(05/06/07/08*.sql)은 **손저작 권위**다(silsa _exec 패턴 모방·
라이브 차원행 실측 코드 직접 인용). 본 스크립트는 그 SQL의 행 구조를 데이터로 재현해
멱등 가드 패턴을 문서화하는 참조 생성기이며, *.sql 을 덮어쓰지 않는다.

차원행 권위(라이브 실측 2026-06-14 read-only):
  PRD_000052 mat: MAT_000153/084/155/156/242 (USAGE.07) · prn opt_id 1 · proc PROC_000054(반칼)
  PRD_000053 mat: MAT_000162 · prn 1 · proc PROC_000008(화이트)·PROC_000054(반칼)
  PRD_000055 mat: MAT_000154 · prn 1 · proc PROC_000053(완칼)
  PRD_000066 mat: MAT_000153/084/155/156/170/171 · prn 1 · proc PROC_000055(완칼·묵시)

코드 채번: option_groups OPT_000006~ (라이브 MAX OPT-000005+1·'_' 통일)
           options      OPV_000017~ (라이브 MAX OPV_000016+1)

멱등 패턴: INSERT … SELECT … WHERE NOT EXISTS(자연키). 손저작 *.sql 이 이 규약을 따른다.
"""
# 데이터 정의(손저작 SQL 과 1:1 — 행 구조 감사용)
GROUPS = [
    # (prd, code, name, sel_typ, min, max, mand, disp_seq)
    ("PRD_000052","OPT_000006","종이","SEL_TYPE.01",1,1,"Y",1),
    ("PRD_000052","OPT_000007","인쇄","SEL_TYPE.01",1,1,"Y",2),
    ("PRD_000052","OPT_000008","커팅","SEL_TYPE.01",1,1,"Y",4),
    ("PRD_000053","OPT_000009","종이","SEL_TYPE.01",1,1,"Y",1),
    ("PRD_000053","OPT_000010","인쇄","SEL_TYPE.01",1,1,"Y",2),
    ("PRD_000053","OPT_000011","화이트별색","SEL_TYPE.01",0,1,"N",3),
    ("PRD_000053","OPT_000012","커팅","SEL_TYPE.01",1,1,"Y",4),
    ("PRD_000055","OPT_000013","종이","SEL_TYPE.01",1,1,"Y",1),
    ("PRD_000055","OPT_000014","인쇄","SEL_TYPE.01",1,1,"Y",2),
    ("PRD_000055","OPT_000015","커팅","SEL_TYPE.01",1,1,"Y",4),
    ("PRD_000066","OPT_000016","종이","SEL_TYPE.01",1,1,"Y",1),
    ("PRD_000066","OPT_000017","인쇄","SEL_TYPE.01",1,1,"Y",2),
]
# option_items: (prd, opt_nm, ref_dim_cd, ref_key1, ref_key2)  — 21행
ITEMS = [
    ("PRD_000052","유포스티커","OPT_REF_DIM.03","MAT_000153","USAGE.07"),
    ("PRD_000052","비코팅스티커","OPT_REF_DIM.03","MAT_000084","USAGE.07"),
    ("PRD_000052","무광코팅스티커","OPT_REF_DIM.03","MAT_000155","USAGE.07"),
    ("PRD_000052","유광코팅스티커","OPT_REF_DIM.03","MAT_000156","USAGE.07"),
    ("PRD_000052","미색스티커","OPT_REF_DIM.03","MAT_000242","USAGE.07"),
    ("PRD_000052","단면","OPT_REF_DIM.06","1",None),
    ("PRD_000052","반칼(자유형)","OPT_REF_DIM.04","PROC_000054",None),
    ("PRD_000053","투명스티커","OPT_REF_DIM.03","MAT_000162","USAGE.07"),
    ("PRD_000053","단면","OPT_REF_DIM.06","1",None),
    ("PRD_000053","화이트인쇄","OPT_REF_DIM.04","PROC_000008",None),
    ("PRD_000053","반칼(자유형)","OPT_REF_DIM.04","PROC_000054",None),
    ("PRD_000055","유포지","OPT_REF_DIM.03","MAT_000154","USAGE.07"),
    ("PRD_000055","단면","OPT_REF_DIM.06","1",None),
    ("PRD_000055","완칼(자유형)","OPT_REF_DIM.04","PROC_000053",None),
    ("PRD_000066","유포스티커","OPT_REF_DIM.03","MAT_000153","USAGE.07"),
    ("PRD_000066","비코팅스티커","OPT_REF_DIM.03","MAT_000084","USAGE.07"),
    ("PRD_000066","무광코팅스티커","OPT_REF_DIM.03","MAT_000155","USAGE.07"),
    ("PRD_000066","유광코팅스티커","OPT_REF_DIM.03","MAT_000156","USAGE.07"),
    ("PRD_000066","투명데드롱스티커","OPT_REF_DIM.03","MAT_000170","USAGE.07"),
    ("PRD_000066","은데드롱스티커","OPT_REF_DIM.03","MAT_000171","USAGE.07"),
    ("PRD_000066","단면","OPT_REF_DIM.06","1",None),
]
if __name__ == "__main__":
    print(f"groups={len(GROUPS)} items={len(ITEMS)}")
    assert len(GROUPS) == 12 and len(ITEMS) == 21, "행수 불일치 — 손저작 SQL 과 동기화 필요"
    print("OK — 손저작 *.sql 이 적재 권위. 본 스크립트는 행 구조 감사용 참조.")
