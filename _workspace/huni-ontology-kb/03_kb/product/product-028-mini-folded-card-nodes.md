<!-- companion nodes for product-028 미니접지카드 — 공유 축 노드(axis/*)·형제 상품 노드에 없는 상품 전용 마스터 노드. -->
<!-- ★공유 파일(axis/*·formula/*·rule/*) 수정 금지 규칙에 따라, 그 파일에 없는 것만 여기 신설(자기 네임스페이스). -->
<!-- ★신설 마스터 노드(size-SIZ_*·material-MAT_*)는 향후 공유 축(axis/*)으로 이관 가치 있음 → needed_shared_nodes로 보고(통합 단계 일괄 mint). -->
<!-- ★수치(치수·사양)는 전사 스크립트 transcribe_product_028.py 출력만(transcribed-by 마커). LLM 손전사 금지. -->

# product-028 전용 노드 (미니접지카드 — 상품 전용 마스터 축 + GAP)

[[product-028-mini-folded-card]]가 연결하는 축 중, 파일럿 공유 축 노드(axis/*)·형제 상품 노드에
아직 없는 것만 신설한다. 공유/형제에 있는 것(자재 10종·공정 13종·PROC_000004 base·국전 판형·
POPT_000002 양면·PRF_DGP_E·SIZ_000008/133/499)은 재사용하고 여기 중복 신설하지 않는다(L-3).

**신설 대상:** 사이즈 2종(SIZ_000132·SIZ_000135) + 자재 4종(MAT_000114·115·116·125) + GAP 2종.

---

## 사이즈 (size) — 미니접지카드 전용 신규 2종 (공유 008/133·형제 재사용 제외)

디지털 사이즈 = 이산 사이즈 행(면적매트릭스 아님·팩 §3.2). 미니접지카드는 명함 크기(재단 90×50·
86×52)의 가로형(008/133)과 세로형(132/135) 쌍이다. 판걸이수(UP수)는 사이즈 컬럼이 아니라 파생
(`fn_calc_pansu`·[[rule/rules#RULE_pansu_db_function]]).

<!-- transcribed-by: _meta/scripts/transcribe_product_028.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes prd_cd=PRD_000028 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | seq | 노드 |
|---|---|---|---|---|---|---|
| SIZ_000008 | 90x50mm | 92x52 | 90x50 | Y | 1 | 재사용 |
| SIZ_000132 | 50x90 | 52x92 | 50x90 | Y | 1 | 신규mint |
| SIZ_000133 | 86x52mm | 88x54 | 86x52 | Y | 1 | 재사용 |
| SIZ_000135 | 52x86 | 52x86 | 52x86 | Y | 1 | 신규mint |

### [size-SIZ_000132] 50x90 (세로형·명함) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000132
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000132", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000132", note: "세로형 50x90(작업 52x92·재단 50x90)·SIZ_000008 90x50의 세로 쌍"}

### [size-SIZ_000135] 52x86 (세로형·명함) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000135
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000135", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000135", note: "세로형 52x86(작업=재단 52x86·전사 그대로 블리드 미가산)·SIZ_000133 86x52의 세로 쌍"}

---

## 자재 (material) — 미니접지카드 전용 신규 4종 (공유 7·형제 재사용 3 제외)

자재 모델 = parent + usage_cd 단일 슬롯(USAGE.07·팩 §3.5). ★[HARD] 실무진이 IMPORT 시트로 등록한
자재는 "배선 안 됐다"고 삭제 금지(팩 §3.5·메모리 `formula-components-wiring-subtrack-260701`).
★이 4종(리사이클러스/매쉬멜로우/린넨커버/한지)은 형제 027이 쓰는 동명 자재(MAT_000348/349/350/356)와
**코드가 다르다**(같은 표시명·다른 코드) — 표시중복 정리는 §17 소관, KB는 라이브 실재(028=114계열)를
그대로 기록한다.

<!-- transcribed-by: _meta/scripts/transcribe_product_028.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials prd_cd=PRD_000028 (신규 4종) @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | usage |
|---|---|---|---|---|---|
| MAT_000114 | 리사이클러스 | MAT_TYPE.01 | 316x467 | 240 | USAGE.07 |
| MAT_000115 | 매쉬멜로우 | MAT_TYPE.01 | 316x467 | 233 | USAGE.07 |
| MAT_000116 | 린넨커버 | MAT_TYPE.01 | 316x467 | 216 | USAGE.07 |
| MAT_000125 | 한지 | MAT_TYPE.01 | 316x467 | 170 | USAGE.07 |

### [material-MAT_000114] 리사이클러스 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000114
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000114", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000114", note: "규격 316x467·평량 240g. 형제 027=MAT_000348(동명·다른코드·§17)"}

### [material-MAT_000115] 매쉬멜로우 233g {verified}
- type: material
- anchor: t_mat_materials/MAT_000115
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000115", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000115", note: "규격 316x467·평량 233g. 형제 027=MAT_000349(동명·다른코드·§17)"}

### [material-MAT_000116] 린넨커버 216g {verified}
- type: material
- anchor: t_mat_materials/MAT_000116
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000116", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000116", note: "규격 316x467·평량 216g. 형제 027=MAT_000350(동명·다른코드·§17)"}

### [material-MAT_000125] 한지 170g {verified}
- type: material
- anchor: t_mat_materials/MAT_000125
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000125", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000125", note: "규격 316x467·평량 170g. 형제 027=MAT_000356(동명·다른코드·§17)"}

---

## GAP — 박 가격 경로 미배선

### [gap-028-foil-price-path] 박 8종 공정 붙었으나 박 분기 공식·옵션그룹 부재 {unknown}
- type: gap
- anchor: none  # 사유: 라이브 상품에 박 공정은 붙었으나 그 가격/선택 경로를 이을 엔티티가 없음(원천 부재 아닌 "미완 배선")
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "prd_cd:PRD_000028 proc_cd:PROC_000037~044(박 8종·mand=N)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "prd_cd:PRD_000028 = PRF_DGP_E 1행뿐(PRF_DGP_E_FOIL 미바인딩)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "prd_cd:PRD_000028 = 0행(박칼라 옵션그룹 부재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "미니접지카드에 박 8종 공정(PROC_000037~044)이 상품에 붙어 있으나 (a) 박 분기 공식 PRF_DGP_E_FOIL에 미바인딩(바인딩=PRF_DGP_E 1개뿐) (b) 박칼라 옵션그룹(027의 OPT_000033 대응) 부재 → 손님이 박을 고를 수단도, 박비를 태울 공식도 없어 박 선택 시 가격 경로가 끊긴다"
- gap_fill_from: "형제 027 동형 전파(PRF_DGP_E_FOIL 바인딩 + 박칼라 옵션그룹 + option_refs→PROC_000037~044) — 단 028은 use_yn=N 미출시라 출시 결정과 함께 인간 승인 후 CPQ/§18 트랙에서 구축. 박 미제공이 의도라면 상품 레벨 박 공정 정리(제거) 여부도 실무진 확인"
- gap_owner: 설계
- rel: {rel: references, target: formula-PRF_DGP_E}
- rel: {rel: references, target: process-PROC_000037}
- rel: {rel: references, target: product-027-bifold-card}

---

## GAP — 미니 상품 수량축 컨펌 (팩 §3.4)

### [gap-028-qty-confirm] 미니접지카드 수량 규칙(min30/incr30) 실무진 컨펌 대기 {unknown}
- type: gap
- anchor: none  # 사유: 상품 스칼라 수량(min30/incr30)의 권위 확정(가격표 구간 vs 상품/사이즈 규칙)이 실무진 컨펌 대기
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000028 min_qty=30 qty_incr=30 (bundle_qtys 0행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-digital-print.md", source_locator: "§3.4 GAP(미니 028류 수량축 컨펌 대기)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-dp}
- gap_what: "미니접지카드 수량축(min30/max10000/incr30·QTY_UNIT.02 매)이 상품 스칼라로만 존재(bundle_qtys 0행). 팩 §3.4가 미니 2상품 수량축을 실무진 컨펌 대기로 남김 — 명함 크기 multi-up 판걸이수와 정합하는 최소수량인지 확정 필요"
- gap_fill_from: "실무진 컨펌(수량 UI 권위=상품/사이즈 수량규칙·제안 min=max(권위,가격표구간)·메모리 qty-system-audit-260702). 미출시 상태라 출시 결정과 함께 확정"
- gap_owner: staff
- rel: {rel: references, target: product-028-mini-folded-card}
