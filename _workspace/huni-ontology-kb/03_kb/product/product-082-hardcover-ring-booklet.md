---
id: product-082-hardcover-ring-booklet
type: product
anchor: t_prd_products/PRD_000082
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000082 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·하드커버 링책자)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 부모:PRD_000082 (활성 구성원 083/286/084·085/086/087 del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-082-post-verify.md", source_locator: "§1 DB 사후 재실측·§2 골든 실호출·§4 링자재 불가침 (면지 통합 재설계 2026-07-03 COMMIT)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 082·§3.5/§3.9/§3.12 축별·§4 latest-wins", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000105, note: "하드커버책자(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000107, note: "하드커버링책자(main·live)"}
  - {rel: uses_material, target: material-MAT_000013, note: "트윈링 링자재(USAGE.07·불가침·live PRD_000082)"}
  - {rel: uses_material, target: material-MAT_000014, note: "트윈링 링자재(USAGE.07·불가침·live PRD_000082)"}
  - {rel: uses_material, target: material-MAT_000015, note: "트윈링 링자재(USAGE.07·불가침·live PRD_000082)"}
  - {rel: has_process, target: process-PROC_000024, note: "하드커버트윈링제본(셋트 form 공정·live PRD_000082)"}
  - {rel: has_process, target: process-PROC_000076, note: "수축포장(옵션·live PRD_000082)"}
  - {rel: has_member, target: product-083-hardcover-ring-booklet-cover, note: "표지(SEMI_ROLE.02·전용지·1권고정)"}
  - {rel: has_member, target: product-286-hardcover-ring-booklet-inner, note: "내지(SEMI_ROLE.01·페이지 8~100/+2)"}
  - {rel: has_member, target: product-084-hardcover-ring-booklet-membrane, note: "면지 1멤버(SEMI_ROLE.03·색 4택1·기여0)"}
  - {rel: priced_by, target: formula-PRF_HC_TWINRING_SET, note: "원자합산형(COVERBIND·트윈링)·evaluate_set_price 합산"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "원자합산형(셋트조합·COVERBIND 트윈링)"
  구분: "셋트 완제품(t_prd_product_sets 부모)"
  golden_ref: "골든 전사표(1/10/100부) — set-formulas.md·082-post-verify §2"
  membrane_model: "면지 1멤버(084)·색 4택1(화/블/그/인쇄)·기여0(제본비 포함)"
standards: {schema_org: "Product", xjdf: "Product(하드커버 링책자·BindingIntent TwinLoop)", config_ont: "assembly(BOM)"}
answers_cq: ["하드커버 링책자 구성·가격(셋트)", "표지+내지+면지 조립 상품"]
tags: ["#셋트", "#하드커버", "#트윈링", "#원자합산형", "#COVERBIND"]
updated: 2026-07-03
---

# 하드커버 링책자 (product-082-hardcover-ring-booklet)

하드커버 링책자(PRD_000082)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets`
부모 등록 = 셋트 완제품의 유일 기준·CLAUDE.md §1 [HARD]). 부품 조립 = **표지(083)+내지(286)+
면지 1멤버(084)**. 가격은 단일 evaluate_price가 아니라 **evaluate_set_price**(구성원별
evaluate_price 합산 + 셋트 부모공식 + 할인·pricing.py:718)로 계산하며, 부모공식은
[[formula/set-formulas#formula-PRF_HC_TWINRING_SET]](PRF_HC_TWINRING_SET·원자합산형·COVERBIND
트윈링 통가)이다. 값 계산은 KB 밖(D-18) — 온톨로지는 has_member·priced_by·아키타입까지.

- **정체·구조**: live `t_prd_product_sets`(부모↔구성원 실재) + 082-post-verify §1(면지 통합 재설계
  2026-07-03). 은퇴 구성원(085/086/087·`del_yn=Y`)은 노드 미생성(정상 은퇴·GAP 아님·pack §1).
- **가격 경계(D-18)**: 상품→셋트공식(priced_by)·부모→구성원(has_member)·구성원 공식·아키타입까지.
  최종 값은 `evaluate_set_price`(온톨로지 밖·이중합산 방지도 엔진 소관).
- **면지 = 무가격·색 내부 택1(면지멤버 084 옵션)**: 재설계로 면지 색(화이트/블랙/그레이/인쇄)이
  부모→면지멤버(USAGE.03)로 이관·용지 드롭다운(기본 화이트). 면지 기여 0(제본비 포함) →
  [[product-082-hardcover-ring-booklet-nodes#optgroup-084-membrane]].
- **★[HARD] USAGE.07 링자재 불가침**: 082 트윈링 링자재(MAT_000013 화이트링·MAT_000014 블랙링·
  MAT_000015 링메탈링)는 USAGE.07로만 존재·전부 활성 3 불변. 면지 재설계(USAGE.03)가 링자재
  미터치·격리(082-post-verify §4). 링자재는 셋트 자재로 보존(은퇴 아님)이나 공유 axis 미민팅 →
  [[gap-082-ring-material]] + needs_axis.
- **상위 분류**: 하드커버링책자(CAT_000107·main)·하드커버책자(CAT_000105) — 공유 category 축
  미민팅 → needs_axis(in_category 배선 대기).

## 셋트 골든 (권위 = simulate_set 실호출·transcribed)

<!-- transcribed-by: pack-set-series.md §1 <- {06_load/leather-hardcover-membrane-082-post-verify.md §2 실호출·CLAUDE.md §23}. simulate_set 산출(손전사 안 함·D-22 접기). -->
| 부수 | final | 구성 | errors |
|---|---|---|---|
| 1 | 30,184 | COMP_BIND_HC_TWINRING(min_qty=1) + 내지 286 | [] |
| 10 | 151,844 | 트윈링 제본 + 내지 286 | [] |
| 100 | 818,438 | set_eval 800,000(8,000/권×100) + 내지 286 18,438 | [] |

면지 084 기여 0 · 멤버 collapse 6→3(083/286/084) 후 final 불변 = 면지 통합/은퇴가 합산에
무영향(082-post-verify §2). warns=2([083]·[084] "가격 소스 없음")=표지/면지 무공식 기여0(정상).

## 구성원 요약 (transcribed)

<!-- transcribed-by: awk t_prd_product_sets.csv 부모 PRD_000082 (활성) + 082-post-verify §1 (면지 재설계 후) @ 2026-07-03 -->
| sub_prd | 역할(SEMI_ROLE) | disp | min/max/incr | 비고 |
|---|---|---|---|---|
| PRD_000083 | .02 표지 | 1 | 1/1/- | 전용지(MAT_000246·USAGE.02)·1권고정·COVERBIND통가·기여0 |
| PRD_000286 | .01 내지 | 2 | 8/100/2 | 별도설정종이·페이지 가변(★db_comment "구성원 개수"이나 실은 페이지수·load-bearing)·PRF_DGP_INNER |
| PRD_000084 | .03 면지 | 3 | -/-/- | 면지 1멤버·색 4택1(MAT_382 화이트 dflt/383/384/385 인쇄)·기여0 |

> 은퇴: 085/086/087(면지 구멤버·`del_yn=Y`·노드 미생성·pack §1·082-post-verify §1).

---

## 구성원 반제품 노드 (member products)

### [product-083-hardcover-ring-booklet-cover] 하드커버 링책자 표지 {verified}
- type: product
- anchor: t_prd_products/PRD_000083
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000083 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·prd_nm 하드커버 링책자-표지(전용지))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000083 (MAT_000246·USAGE.02·전용지)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-082-hardcover-ring-booklet, note: "표지=COVERBIND통가에 포함·독립 공식 0(기여0)·가격은 셋트에서 파생(evaluate_set_price)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", role: "표지(전용지·1권고정)·자체 가격공식 없음(COVERBIND통가)·warns '가격 소스 없음'=정상 기여0"}
- 본문: 하드커버 링책자 표지 반제품. 전용지 자재 MAT_000246(USAGE.02·공유 axis 미민팅→[[gap-082-ring-material]] BOM). 자체 사이즈/도수/공정/판형/공식 없음 — 표지+제본이 COVERBIND 통가로 합산(082 부모공식). O5 만족=derived_from(셋트 파생). 부모=[[product-082-hardcover-ring-booklet]].

### [product-286-hardcover-ring-booklet-inner] 하드커버 링책자 내지 {verified}
- type: product
- anchor: t_prd_products/PRD_000286
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000286 (prd_typ_cd=PRD_TYPE.02·prd_nm 하드커버 링책자-내지·mint 2026-06-30)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "prd_cd:PRD_000286 (SIZ_000170/172/380)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_price_formulas.csv", source_locator: "키:(PRD_000286,PRF_DGP_INNER)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: priced_by, target: formula-PRF_DGP_INNER, note: "내지 member 공식(인쇄+용지·page 가변)"}
- rel: {rel: has_size, target: size-SIZ_000170, note: "A5(148x210)"}
- rel: {rel: has_size, target: size-SIZ_000380, note: "B5(182x257)"}
- rel: {rel: has_print_option, target: printopt-POPT_000001, note: "단면"}
- rel: {rel: has_print_option, target: printopt-POPT_000002, note: "양면"}
- rel: {rel: has_plate_size, target: plate-OUTPUT_PAPER_TYPE_01, note: "국전 출력용지(종이류·286 plate=SIZ_000499/OUTPUT_PAPER_TYPE.01)"}
- rel: {rel: has_qty_rule, target: qty-286-inner-page}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.01", role: "내지(별도설정종이)·페이지 8~100/+2·PRF_DGP_INNER"}
- 본문: 하드커버 링책자 내지 반제품(2026-06-30 mint). 사이즈 3종(A5·A4·B5) 중 A5/B5는 공유 축 배선·A4(SIZ_000172)는 축 미민팅→needs_axis(BOM 권위). 자재 9종(USAGE.07 종이·전부 공유 axis 미민팅→[[gap-082-ring-material]] BOM). 페이지 가변(8~100/+2)=수량규칙 축([[product-082-hardcover-ring-booklet-nodes#qty-286-inner-page]]·★db_comment 오등록 "구성원 개수"이나 실은 페이지수·load-bearing·pack §3.4). ★S1/S2 이중합산=코드 C트랙([[rule/gaps#gap-set-s1s2-double]]). 부모=[[product-082-hardcover-ring-booklet]].

<!-- transcribed-by: awk t_prd_product_sizes.csv+t_prd_product_materials.csv+t_prd_product_print_options.csv PRD_000286 from live-snapshot/latest @ 2026-07-03 -->
286 내지 BOM: 사이즈 SIZ_000170(A5)·SIZ_000172(A4·축 미민팅)·SIZ_000380(B5) · 자재 USAGE.07 9종(MAT_000072/073/076/077/086/087/095/104/105·전부 축 미민팅) · 인쇄 POPT 단면/양면 · 판형 국전(OUTPUT_PAPER_TYPE.01).

### [product-084-hardcover-ring-booklet-membrane] 하드커버 링책자 면지 {verified}
- type: product
- anchor: t_prd_products/PRD_000084
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000084 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.03·prd_nm 하드커버 링책자-면지·리네이밍 2026-07-03)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-082-post-verify.md", source_locator: "§1 084 면지자재 USAGE.03 활성 4(MAT_382 dflt/383/384/385)·OPT_066·옵션아이템 4", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
- rel: {rel: derived_from, target: product-082-hardcover-ring-booklet, note: "면지=무가격(제본비 포함·기여0·component_prices 0행)·색 택1만·가격은 셋트 파생"}
- rel: {rel: uses_material, target: material-MAT_000382, note: "화이트면지(dflt·USAGE.03·이관됨)"}
- rel: {rel: uses_material, target: material-MAT_000383, note: "블랙면지"}
- rel: {rel: uses_material, target: material-MAT_000384, note: "그레이면지"}
- rel: {rel: uses_material, target: material-MAT_000385, note: "인쇄면지(기여0·선택지 보존)"}
- rel: {rel: has_option_group, target: optgroup-084-membrane, note: "면지 색 4택1(용지 드롭다운)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.03", role: "면지 1멤버·색 4택1(화/블/그/인쇄)·기여0·자재 부모→멤버 이관(fn_chk_opt_item_ref 정합)"}
- 본문: 하드커버 링책자 면지 반제품(2026-07-03 통합 재설계·기존 084/085/086/087 4멤버 → 084 1멤버로 통합·나머지 은퇴). 면지 색 = 용지 드롭다운 4택1(화이트 dflt)·자재 USAGE.03 4종은 부모→멤버 이관(옵션참조 정합·[[rule/rules]] fn_chk_opt_item_ref). **무가격**(제본비 포함·기여0·`component_prices` 0행·골든 무손상 근거). O5 만족=derived_from. 부모=[[product-082-hardcover-ring-booklet]]·옵션그룹=[[product-082-hardcover-ring-booklet-nodes#optgroup-084-membrane]].

### [gap-082-ring-material] 082 링자재·표지전용지·내지종이 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: 082 링자재(MAT_013/014/015)·표지전용지(MAT_246)·내지종이 9종은 live 실재·BOM 전사 권위이나 공유 axis/materials 미민팅이라 uses_material 그래프 배선 부재(Stage A 면지 382~385만 민팅)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000082 USAGE.07(MAT_000013/014/015)·PRD_000083 USAGE.02(MAT_000246)·PRD_000286 USAGE.07(MAT_000072/073/076/077/086/087/095/104/105)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "082 계열 자재 중 ★링자재 MAT_000013/014/015(USAGE.07·불가침)·표지전용지 MAT_000246·내지종이 9종이 공유 axis/materials 미민팅 → uses_material 그래프 배선 부재. BOM 전사표가 권위이나 그래프 탐색 시 침묵 누락 방지 위해 정직 선언(면지 MAT_382~385·D링은 Stage A 민팅됨)"
- gap_fill_from: "Stage C/architect 공유 axis/materials 확장(링자재·표지전용지·내지종이 노드 mint) 후 082 부모 uses_material + 083/286 uses_material 배선. ★링자재는 USAGE.07 불가침 보존(082-post-verify §4)"
- gap_owner: 설계
- 본문: 값은 아는데(live·BOM 전사) 공유 축이 면지/D링만이라 링자재·표지·내지종이 배선이 부재한 KB 커버리지 공백. 조용한 누락 대신 정직 선언(anchor 016 GAP_016_material 동류). ★링자재(USAGE.07)는 불가침 — 채움 시에도 은퇴/이관 금지.
