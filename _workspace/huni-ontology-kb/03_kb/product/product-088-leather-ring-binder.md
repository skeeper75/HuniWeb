---
id: product-088-leather-ring-binder
type: product
anchor: t_prd_products/PRD_000088
badge: verified
live_current_value: "100부 796,900 (COVERBIND·PRF_LEATHER_RINGBINDER_SET·live COMMIT 20260702_1119·088-post-verify §2 실호출·현재 정본)"
pending_authority_value: "100부 1,800,000 (088-redesign-260702·표지 9,000/부·싸바리 제본·S1~S8 GO·codex 13/13 합의·인간 승인 대기 pending·직교 워크스트림·gap-set-088-redesign-pending)"
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000088 (prd_typ_cd=PRD_TYPE.01·del_yn=N·use_yn=Y·레더 링바인더)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "live-snapshot/latest/t_prd_product_sets.csv", source_locator: "테이블:t_prd_product_sets 부모:PRD_000088 (활성 구성원 089 표지/090 면지·091/092/093 del_yn=Y·내지 없음)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-088-post-verify.md", source_locator: "§1 DB 재실측·§2 골든 796,900 실호출·§4 D링 불가침·§5 088-redesign 직교 무변경", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-set-series.md", source_locator: "§1 인벤토리 088·§1.1 양면·§4 latest-wins(현재값 796,900 vs pending 1,800,000)", captured_at: "2026-07-03", badge: defect, src_id: SR-pack-set}
relations:
  - {rel: in_category, target: category-CAT_000105, note: "하드커버책자(super·live main_cat_yn=N)"}
  - {rel: in_category, target: category-CAT_000008, note: "문구(main·live)"}
  - {rel: has_member, target: product-089-leather-ring-binder-cover, note: "표지(SEMI_ROLE.02·레더 화이트)"}
  - {rel: has_member, target: product-090-leather-ring-binder-membrane, note: "면지 1멤버(SEMI_ROLE.03·색 4택1·기여0)"}
  - {rel: priced_by, target: formula-PRF_LEATHER_RINGBINDER_SET, note: "현재값 정본·COVERBIND 통가·evaluate_set_price 합산"}
  - {rel: uses_material, target: material-MAT_000247, note: "D링(31mm)·USAGE.07·불가침(활성·dflt)"}
  - {rel: uses_material, target: material-MAT_000248, note: "D링(42mm)·USAGE.07·불가침"}
  - {rel: uses_material, target: material-MAT_000249, note: "D링·USAGE.07·불가침"}
  - {rel: references, target: gap-set-088-redesign-pending, note: "양면 authority(088-redesign pending·1,800,000·인간 승인 대기)"}
props:
  prd_typ_cd: "PRD_TYPE.01"
  archetype: "원자합산형(셋트조합·COVERBIND)"
  구분: "셋트 완제품(t_prd_product_sets 부모·내지 없음 빈 바인더)"
  membrane_model: "면지 1멤버(090)·색 4택1(화/블/그/인쇄)·기여0"
  both_sided: "현재값(796,900·COVERBIND) vs authority(1,800,000·088-redesign pending)·두 값 다 보존(직교)"
standards: {schema_org: "Product", xjdf: "Product(레더 링바인더·BindingIntent DRing)", config_ont: "assembly(BOM)"}
answers_cq: ["레더 링바인더 구성·가격(셋트)", "빈 바인더(내지 없음) 조립 상품"]
tags: ["#셋트", "#레더", "#링바인더", "#COVERBIND", "#양면표기"]
updated: 2026-07-03
---

# 레더 링바인더 (product-088-leather-ring-binder)

레더 링바인더(PRD_000088)는 **셋트 완제품**(prd_typ_cd=PRD_TYPE.01·`t_prd_product_sets` 부모).
부품 조립 = **표지(089·레더)+면지 1멤버(090)·내지 없음(빈 바인더)**. 가격은 **evaluate_set_price**
(구성원 합산+부모공식+할인·pricing.py:718)로, 현재 부모공식은 [[formula/set-formulas#formula-PRF_LEATHER_RINGBINDER_SET]]
(PRF_LEATHER_RINGBINDER_SET·원자합산형·COVERBIND 통가)이다.

- **★양면 정직 표기(pack §4·badge=verified·현재값 정본+pending gap)**: 라이브 **현재값 = 100부 796,900**(COVERBIND·live COMMIT)
  이나, 별개 직교 워크스트림 **088-redesign-260702**(표지 9,000/부·싸바리 제본·S1~S8 GO·codex 13/13)
  가 **인간 승인 시 100부 1,800,000**으로 변경된다(COMMIT 미실행·pending). 두 값 다 보존 —
  authority=[[rule/gaps#gap-set-088-redesign-pending]]. 두 워크스트림 완전 직교(088-post-verify §5 실증).
- **정체·구조**: live `t_prd_product_sets`(부모↔구성원) + 088-post-verify §1(면지 통합 재설계
  2026-07-03·면지 4멤버 090~093 → 090 1멤버). 은퇴 091/092/093(`del_yn=Y`)은 노드 미생성(정상).
- **면지 = 무가격·색 내부 택1**: 재설계로 면지 색(화이트/블랙/그레이/인쇄)이 부모→면지멤버 090
  (USAGE.03)로 이관·용지 드롭다운(기본 화이트)·기여0 →
  [[product-088-leather-ring-binder-nodes#optgroup-090-membrane]].
- **★[HARD] USAGE.07 D링자재 불가침**: 088 D링자재(MAT_000247 31mm·MAT_000248 42mm·MAT_000249)는
  USAGE.07로만 존재·전부 활성 3·dflt_yn=Y 불변. 면지 재설계(USAGE.03)가 D링 미터치·격리
  (088-post-verify §4). D링 자재는 셋트 자재로 보존(uses_material 배선·은퇴 아님).
- **상위 분류**: 문구(CAT_000008·main·라이브 실값) — 공유 category 축 미민팅 → needs_axis.

## 셋트 골든 (현재값·권위 = simulate_set 실호출·transcribed)

<!-- transcribed-by: 088-post-verify §2 실호출(real pricing.py + webadmin simulate-set POST·인증세션). COVERBIND 현행 모델. 손전사 안 함. -->
| 부수 | final(현재값) | 구성 | errors |
|---|---|---|---|
| 1 | 34,100 | COMP_HC_MUSEON_COVERBIND(min_qty=1) | [] |
| 10 | 159,100 | COVERBIND 통가 | [] |
| 100 | 796,900 | COVERBIND(min_qty=100→7,969/권×100) | [] |

멤버 collapse 4→1 면지(090)+091/092/093 은퇴 후에도 final 불변 = 면지 통합/은퇴가 합산에 무영향
(각 기여0·`t_prd_product_prices` prd_cd IN(089~093)=0건·088-post-verify §2). ★authority(pending)
1,800,000은 별도 gap 노드(현재값 아님).

## 구성원 요약 (transcribed)

<!-- transcribed-by: awk t_prd_product_sets.csv 부모 PRD_000088 (활성) + 088-post-verify §1 (면지 재설계 후) @ 2026-07-03 -->
| sub_prd | 역할(SEMI_ROLE) | disp | 비고 |
|---|---|---|---|
| PRD_000089 | .02 표지 | 1 | 레더(화이트·MAT_000379·USAGE.02)·COVERBIND통가·기여0 |
| PRD_000090 | .03 면지 | 2 | 면지 1멤버·색 4택1(MAT_382 화이트 dflt/383/384/385 인쇄)·기여0 |

> 내지 없음(빈 바인더) · 은퇴: 091/092/093(면지 구멤버·`del_yn=Y`·노드 미생성).

---

## 구성원 반제품 노드 (member products)

### [product-089-leather-ring-binder-cover] 레더 링바인더 표지 {verified}
- type: product
- anchor: t_prd_products/PRD_000089
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000089 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.02·prd_nm 레더 링바인더-표지(레더(화이트)))", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000089 (MAT_000379·USAGE.02·레더 MAT_TYPE.05)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: derived_from, target: product-088-leather-ring-binder, note: "표지=COVERBIND통가에 포함·독립 공식 0(기여0·t_prd_product_prices 0건)·가격은 셋트 파생"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.02", role: "표지(레더 화이트)·자체 공식 없음(COVERBIND통가)·★088-redesign pending 시 9,000/부 mint 예정(현행 미적재·직교)"}
- 본문: 레더 링바인더 표지 반제품. 레더 자재 MAT_000379(USAGE.02·MAT_TYPE.05·공유 axis 미민팅→[[gap-088-cover-material]] BOM). 자체 공식 없음 — COVERBIND 통가로 합산(088 부모공식). ★088-redesign pending에서 089에 표지 9,000/부(636×374 소재+인쇄) mint 예정이나 현행 미적재(088-post-verify §5 직교 실증). O5 만족=derived_from. 부모=[[product-088-leather-ring-binder]].

### [product-090-leather-ring-binder-membrane] 레더 링바인더 면지 {verified}
- type: product
- anchor: t_prd_products/PRD_000090
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:PRD_000090 (prd_typ_cd=PRD_TYPE.02·semi_role_cd=SEMI_ROLE.03·prd_nm 레더 링바인더-면지·리네이밍 2026-07-03)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-set-product/06_load/leather-hardcover-membrane-088-post-verify.md", source_locator: "§1 090 면지자재 USAGE.03 활성 4(MAT_382 dflt/383/384/385)·OPT_067·옵션아이템 4(OPV_447→MAT_385)", captured_at: "2026-07-03", badge: verified, src_id: SR-23-membrane}
- rel: {rel: derived_from, target: product-088-leather-ring-binder, note: "면지=무가격(제본비 포함·기여0·component_prices 0행)·색 택1만·가격은 셋트 파생"}
- rel: {rel: uses_material, target: material-MAT_000382, note: "화이트면지(dflt·USAGE.03·이관됨)"}
- rel: {rel: uses_material, target: material-MAT_000383, note: "블랙면지"}
- rel: {rel: uses_material, target: material-MAT_000384, note: "그레이면지"}
- rel: {rel: uses_material, target: material-MAT_000385, note: "인쇄면지(기여0·선택지 보존)"}
- rel: {rel: has_option_group, target: optgroup-090-membrane, note: "면지 색 4택1(용지 드롭다운)"}
- props: {prd_typ_cd: "PRD_TYPE.02", semi_role_cd: "SEMI_ROLE.03", role: "면지 1멤버·색 4택1(화/블/그/인쇄)·기여0·자재 부모→멤버 이관(fn_chk_opt_item_ref 정합)"}
- 본문: 레더 링바인더 면지 반제품(2026-07-03 통합 재설계·기존 090/091/092/093 4멤버 → 090 1멤버로 통합·나머지 은퇴). 면지 색 = 용지 드롭다운 4택1(화이트 dflt)·자재 USAGE.03 4종은 부모→멤버 이관(옵션참조 정합). **무가격**(제본비 포함·기여0·`component_prices` 0행·골든 796,900 무손상 근거). O5 만족=derived_from. 부모=[[product-088-leather-ring-binder]]·옵션그룹=[[product-088-leather-ring-binder-nodes#optgroup-090-membrane]].

### [gap-088-cover-material] 088 표지레더·D링 표지자재 공유 축 미민팅 (그래프 커버리지) {unknown}
- type: gap
- anchor: none  # 사유: 089 표지 레더자재(MAT_379)는 live 실재·BOM 전사 권위이나 공유 axis/materials 미민팅이라 uses_material 그래프 배선 부재(Stage A는 면지 382~385·D링 247~249만 민팅)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "prd_cd:PRD_000089 USAGE.02(MAT_000379·레더 MAT_TYPE.05)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "089 표지 레더자재 MAT_000379(레더 화이트)가 공유 axis/materials 미민팅 → 089 uses_material 그래프 배선 부재. BOM 전사가 권위이나 침묵 누락 방지 위해 정직 선언(면지 MAT_382~385·D링 MAT_247~249는 Stage A 민팅됨)"
- gap_fill_from: "Stage C/architect 공유 axis/materials 확장(레더 표지자재 노드 mint) 후 089 uses_material 배선"
- gap_owner: 설계
- 본문: 값은 아는데(live·BOM) 공유 축이 면지/D링만이라 레더 표지자재 배선이 부재한 KB 커버리지 공백. 정직 선언(082 gap-082-ring-material 동류). D링(MAT_247~249)은 Stage A 민팅되어 088 부모 uses_material로 배선됨(불가침·은퇴 금지).
