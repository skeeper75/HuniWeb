<!-- product-local sub-nodes: E3 size·E4 material·E11 option_group·gap for PRD_000046 라벨/택. -->
<!-- ★이 파일의 size(SIZ_000047/011/048)·material(MAT_000109)은 라이브 마스터 원자라 본래 공유 축 -->
<!--   (axis/sizes.md·axis/materials.md) 소속이나, 공유 축 파일 수정 금지 규칙 때문에 여기 임시 거처. -->
<!--   축 소유자가 승격 시 canonical id 그대로 이관(삭제) — index_entries로 반환. 승격 전까지 broken link 방지용. -->
<!-- ★수치(치수·평량·수량)는 아래 전사표(transcribed-by·transcribe_046.py)에만. props에 raw 미기입(D-9·L-12). -->

# product-046 하위 노드 (라벨/택 전용 축 원자)

라벨/택(PRD_000046)이 쓰는 사이즈 3행·전용 자재·커팅모양 옵션그룹·미검증 GAP.
상품→축 연결(has_size·uses_material·has_option_group)은 [[product-046-label-tag]]가 건다.

## 치수·자재·수량 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_046.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes PRD_000046 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 비고(라이브 note) |
|---|---|---|---|---|
| SIZ_000047 | 40x80 | 50x90 | 40x80 | 판걸이=24.0 / 전지=316x467 / 적용=라벨택 |
| SIZ_000011 | 50x50 | 60x60 | 50x50 | 판걸이=35.0 / 전지=316x467 / 적용=미니모양명함, 라벨택 |
| SIZ_000048 | 25x110 | 35x120 | 25x110 | 판걸이=24.0 / 전지=316x467 / 적용=라벨택 |

<!-- transcribed-by: _meta/scripts/transcribe_046.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials MAT_000109 @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 상위자재 | 규격(mm) | 평량(g) |
|---|---|---|---|---|---|
| MAT_000109 | 몽블랑 240g | MAT_TYPE.01 | MAT_000103 | 316x467 | 240 |

<!-- transcribed-by: _meta/scripts/transcribe_046.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000046 @ 2026-07-03 -->
| min_qty | max_qty | qty_incr | 단위 |
|---|---|---|---|
| 20 | 1000 | 20 | QTY_UNIT.02 |

## 사이즈 노드 (product-local — 축 승격 대기)

### [size-SIZ_000047] 40x80 (라벨택 완칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000047
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000047", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000047", note: "판걸이수 24는 사이즈 파생값(fn_calc_pansu)"}
- 본문: 라벨/택 재단 사이즈. 작업 50x90/재단 40x80(전사표). [[product-046-label-tag]] has_size 대상.

### [size-SIZ_000048] 25x110 (라벨택 완칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000048
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000048", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000048"}

## 자재 노드 (축 승격 260703)

> ★2026-07-03 축 승격: 몽블랑 240g(MAT_000109)은 027 접지카드와 공유라 공유 `axis/materials.md`로 이관.
> 046 본문의 `uses_material` relation이 축 노드 [[material-MAT_000109]]로 resolve(중복 정의 제거·L-3 해소).
> ★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).

## 옵션그룹 노드 (CPQ)

### [optgroup-046-cutting-shape] 커팅모양 (나뭇잎/별타공/리니니) {verified}
- type: option_group
- anchor: t_prd_product_option_groups/PRD_000046
- src: {source_file: "live-snapshot/latest/t_prd_product_option_groups.csv", source_locator: "테이블:t_prd_product_option_groups 키:PRD_000046 opt_grp_cd:OPT-000010", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_options.csv", source_locator: "키:PRD_000046 opt_grp_cd:OPT-000010 (OPV-000021 나뭇잎/OPV-000022 별타공/OPV-000023 리니니)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {opt_grp_cd: "OPT-000010", sel_typ_cd: "SEL_TYPE.01", mand_yn: "N", 옵션값: "나뭇잎/별타공/리니니(3택)", ref_dim: "없음(option_items 0행·다형참조 무·가격 비영향)"}
- 본문: 완칼 커팅 모양 선택 옵션. `t_prd_product_option_items`에 046 행이 없어 자재/사이즈를 가리키는 `ref_dim_cd`(R11 option_refs)가 없다 → 생산·시각 선택일 뿐 가격 사슬에 미참여. option_item 노드 승격은 파일럿 실측 후 재검토(스키마 F-3).

## GAP 노드

### [gap-046-diecut-golden] 라벨택 완칼 골든 절대값 미검증 {unknown}
- type: gap
- anchor: none  # 사유: 완칼 .01→.03 교정 후 예전사이트 골든 절대값을 매핑할 pcode가 미상(pack §4-B/§4-E)
- src: {source_file: "_workspace/huni-price-table-integrity/HANDOFF.md", source_locator: "라인 47·73 — 완칼 골든 절대값 pcode 미상 대기", captured_at: "2026-07-03", badge: unknown, src_id: SR-26-diecut}
- gap_what: "완칼 die-cut 단가 .03 고정 교정(046 1,350,000→50,000) 후, 예전사이트 정답 골든 절대값이 맞는지 미검증(pcode 매핑 부재)"
- gap_fill_from: "개발팀 — pcode 매핑 확보 후 예전사이트 골든과 대조(§4-B)"
- gap_owner: dev
- rel: {rel: references, target: formula-PRF_DGP_B, note: "이 공식의 완칼 구성요소 골든이 대상"}
- 본문: 완칼 단가 구조(.01→.03)는 확정([[rule/decisions#DEC_diecut_260701]])이나 절대값 골든은 대기. 지어내지 않고 GAP으로 등재.
