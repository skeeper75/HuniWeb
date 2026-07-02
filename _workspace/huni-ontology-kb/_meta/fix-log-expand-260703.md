# Fix Log — 확장 검증 결함 교정 (builder) · 2026-07-03

> 입력 결함 보드: `05_verification/defect-expand-prov-260703.md` · `defect-expand-integrity-260703.md` · `defect-expand-pricepath-260703.md`
> 역할: builder(정본 교정 + 재빌드). 검증은 별도 레인(자기승인 금지). 교정 가능분(routing≠source-confirm)만.
> 재빌드 결과: **hard=0 · soft 120→116 · 노드 466 · 엣지 1521→1526 · 멱등 해시 동일(True)**.

---

## 교정 완료 (3건)

### FX-1 [HIGH] product-048 GAP 3종 traversal 배선 (defect-pricepath D1 = defect-integrity M2)
- **파일:** `03_kb/product/product-048-folded-leaflet.md` (frontmatter relations)
- **결함:** gap-048-price-path-incomplete·gap-048-no-size·gap-048-material 이 산문/백틱으로만 참조 → product-048→gap 엣지 미생성. gap-048-no-size·gap-048-material 완전 고아(in=0 out=0)·가격 경로 불완전이 그래프 질의에 미노출.
- **교정:** priced_by 뒤에 `references` 관계 3개 추가(`gap-048-price-path-incomplete`·`gap-048-no-size`·`gap-048-material`).
- **rel 선택 근거:** 038은 O5 예외(priced_by 부재)를 위해 gap-038-no-price-path를 `derived_from`으로 배선했으나, **048은 priced_by(PRF_FOLD_SUM) 보유로 O5를 이미 충족** → gap 배선은 traversal 노출 목적뿐이라 `references`(R19·any→any)가 의미상 정확. 보드 D1 1차 권고("--references-->")와 일치.
- **검증:** `sqlite3 graph.db` → 3 gap 전부 in-edge=1(고아 해소). hard=0.
- **원천분 잔여(교정 불가·source-confirm):** 048 실제 가격경로 미완(사이즈 축·완전 공식 재바인딩)은 권위 260702+§18/§26/§7 인간 승인 필요 — GAP 노드가 정직 선언 유지. 검증가 교정 대상 아님.

### FX-2 [MEDIUM] 깨진 rule 참조 RULE_import_material_keep → RULE_import_material_no_delete (defect-integrity M1)
- **파일 3종:** `product-027-nodes.md`·`product-029-trifold-card-nodes.md`·`product-031-premium-namecard-nodes.md` (본문 `[[ ]]`)
- **결함:** `[[rule/rules#RULE_import_material_keep]]` — 대상 노드 id 부재(실제=`RULE_import_material_no_delete`). 미해결 소프트로 조용히 강등.
- **교정:** 3파일 참조 id를 `RULE_import_material_no_delete`로 정정.
- **검증:** 재빌드 리포트에 `RULE_import_material_keep` 0건(깨진 참조 소멸)·해당 노드 dst 엣지 0. hard=0.

### FX-3 [LOW] optgroup-OPT_000038 source_locator 범위 정정 (defect-prov D-1)
- **파일:** `03_kb/product/product-029-trifold-card-cpq.md` (블록 optgroup-OPT_000038 · t_prd_product_option_items.csv src)
- **결함:** items.csv src의 locator `opt_cd:OPV_000137~145`. OPV_000137(박없음)은 items 테이블 0행(센티넬)이라 범위 시작이 부정확.
- **★검증가 D-1 근거 일부 정정(직접 재실측):** 보드는 "OPV_000137이 라이브 어디에도 없음"으로 판정했으나, `t_prd_product_options.csv`에는 **OPV_000137=박없음(dflt·선택안함 센티넬)이 실재**한다. 없는 것은 `t_prd_product_option_items.csv`의 OPV_000137 행뿐(센티넬은 참조 차원 없어 item 0행). 따라서 items.csv src의 정확한 범위 = OPV_000138~145(ref_dim OPT_REF_DIM.04·PROC_000037~044 8종). props note(line 76)의 "박없음(OPV_000137·참조 차원 없음)"은 정확 → 유지.
- **교정:** items.csv src locator를 `opt_cd:OPV_000138~145 ...(OPV_000137 박없음=센티넬·item 0행이라 items.csv 범위 제외)`로 정정. options 테이블/props의 OPV_000137 서술은 불변.
- **재실측 증거:** `snap_20260702_1119/t_prd_product_options.csv` OPT_000038 그룹=OPV_000137~145(9행) · `t_prd_product_option_items.csv` PRD_000029=OPV_000138~145만 ref_dim OPT_REF_DIM.04 보유(OPV_000137 0행).

---

## 보류 (교정 미실행 · 근거)

### HOLD-1 [원천 컨펌] PRD_000042 굿즈 자재 라이브 오적재 (defect-prov D-2)
- MAT_000128/129/240/241(비종이 굿즈) 042 활성 잔존. **KB는 이미 badge=defect+GAP로 정직 표기** → KB 측 조치 없음. 라이브 정리는 실무진/인간 승인(그릇 밖·source-confirm).

### HOLD-2 [architect] 전역/메타 GAP 그래프 고립 규약 (defect-pricepath D2·D3 = defect-integrity L3)
- `GAP_roll_material_price`(D2·Medium)·`GAP_product_count`(D3·Low): rule/gaps.md 전역 GAP·특정 파일럿 상품 비귀속(in=0 out=0).
- **임의 배선 보류 근거:** 상품 비귀속 GAP에 앵커 엣지를 임의로 만들면 날조 배선. 반대로 gap을 L-19 고아 예외에 일괄 편입하면 **이번 FX-1(048 고아 gap)이 은폐됐을 결함** — 즉 "gap은 배선돼야 한다"가 옳고 예외 확대는 위험. "메타/색인 전용 GAP 고립 허용" 여부는 GAP 의미론 정책이라 **architect 스키마 판정 대상**. 임의 대체 금지 원칙에 따라 보류.

### HOLD-3 [architect/advisory] 미해결 `[[ ]]` 91건 컨벤션 드리프트 (defect-integrity L1)
- 파일포인터(`[[product-027-nodes]]`)·외부 SOT/MEMORY 인용. **잘못된 엣지 미생성(fabrication 0)**·정상 소프트 처리. 참조 문법 규약(파일#노드 형/산문 각주) 정비는 architect 결정 선행 필요 — 91건 일괄 표기 변경은 컨벤션 확정 후. 데이터 결함 아님.

### HOLD-4 [architect] L-12 수량 오탐 린트 튜닝 (defect-integrity L2)
- 소프트 19건 = "매/장/부" 수량 규칙 수치의 가격 오탐. 데이터 교정 불요·lint 규칙 튜닝(architect·선택). 정본 변경 없음.

---

## 재빌드·검증

- `python3 04_graph/build_graph.py` → `nodes=466 edges=1526 hard=0 soft=116`
- `python3 04_graph/build_graph.py --idem` → 2회 빌드 해시 동일: **True**(멱등)
- 리포트: `05_verification/build-report-20260703.md`(PASS·하드 0)
- 자기승인 아님 — 교정 산출은 okb-adversarial-gate 재검증 대상.
