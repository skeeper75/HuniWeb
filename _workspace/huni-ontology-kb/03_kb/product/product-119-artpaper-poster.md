---
id: product-119-artpaper-poster
type: product
anchor: t_prd_products/PRD_000119
badge: verified
sources:
  - {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000119(prd_typ_cd/nonspec_yn/min_qty/max_qty/qty_incr/use_yn)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
  - {source_file: "_workspace/huni-ontology-kb/01_curation/pack-silsa.md", source_locator: "§1(정답소스)·§3.1 정체·§3.2 사이즈·§3.10 면적매트릭스 B02 아트페이퍼119·§3.11 COMP_POSTER_*·§5 인계", captured_at: "2026-07-03", badge: verified, src_id: SR-pack-silsa}
  - {source_file: "_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md", source_locator: "§1.1 면적13/고정15·§1.2 B02 아트페이퍼119↔COMP_POSTER_ARTPAPER(면적매트릭스·off-grid ceiling)", captured_at: "2026-07-03", badge: verified, src_id: SR-13-silsa-mapping}
relations:
  - {rel: in_category, target: category-CAT_000004, note: "포스터(main_cat_yn=Y·주 카테고리·lvl1 root)"}
  - {rel: in_category, target: category-CAT_000314, note: "아트포스터(main_cat_yn=N·부·lvl2 leaf·CAT_000004 자식·06-19 신규 노드)"}
  - {rel: has_size, target: size-SIZ_000174, note: "A3(297x420)·이산 규격(재단)·dflt"}
  - {rel: has_size, target: size-SIZ_000197, note: "A2(420x594)·이산 규격(재단)"}
  - {rel: has_size, target: size-SIZ_000293, note: "A1(594x841)·이산 규격(재단)·★마스터 t_siz_sizes del_yn=Y(정합 미상→gap-119-a1-master-deleted)"}
  - {rel: uses_material, target: material-MAT_000177, note: "매트지(MAT_TYPE.08 실사소재)·아트페이퍼=매트지 소재·USAGE.07 단일 슬롯·dflt Y"}
  - {rel: has_plate_size, target: plate-119-SIZ_000052, note: "★파일사양(output_file_typ=JPG·output_paper_typ_cd 공백)·종이류 절수 판형 아님(실사=대형 롤·T-7)"}
  - {rel: has_plate_size, target: plate-119-SIZ_000198, note: "★파일사양(JPG)·A2 output·절수판형/판걸이수 미적용(pack §3.8)"}
  - {rel: has_plate_size, target: plate-119-SIZ_000294, note: "★파일사양(JPG)·A1 output·절수판형 아님"}
  - {rel: has_qty_rule, target: qty-119, note: "상품레벨 min1·max1000·incr1·QTY_UNIT.01(bundle_qtys 0행)·★면적매트릭스 가격은 수량 무관(셀=완제품 통가격)"}
  - {rel: priced_by, target: formula-PRF_POSTER_ARTPAPER, note: "실사 면적매트릭스형 완제품가(포스터사인 [가로×세로] 셀단가·off-grid=한단계 큰 규격 ceiling)"}
props:
  prd_typ_cd: PRD_TYPE.01   # 완제품 단일(t_prd_product_sets 부모/구성원 0/0)
  archetype: "면적매트릭스형(PRF_POSTER_ARTPAPER→COMP_POSTER_ARTPAPER_MATTE·use_dims=[siz_width,siz_height]·39셀)"
  min_qty: 1                # 단일 스칼라 허용(file-format-spec §2.4)·전사표 권위
  nonspec_yn: "Y"           # 비규격 연속범위 입력(가로200~900·세로200~3000·incr200)·★가격격자 아님(pack §3.2)
  file_upload_yn: "Y"       # 파일 업로드 지원(에디터 미지원)
  editor_yn: "N"
  use_yn: "Y"               # ★출시 상태(라이브 현재값)
standards: {schema_org: Product, xjdf: "Product(아트페이퍼포스터·실사 대형출력)", config_ont: "component type"}
tags: [실사, 포스터, 아트페이퍼, 면적매트릭스, 대형출력]
updated: 2026-07-03
---

# product-119-artpaper-poster — 아트페이퍼포스터 (PRD_000119)

실사(대형 출력물) **완제품 단일**(prd_typ_cd=`PRD_TYPE.01` · `t_prd_product_sets`에 부모/구성원
등록 없음 — [[product-type-classification-sot]] 준수). 매트지(아트페이퍼)에 대형 잉크젯으로
포스터를 출력하는 상품. 주 카테고리는 **포스터**(CAT_000004·main_cat_yn=Y), 부(leaf)가
**아트포스터**(CAT_000314·2026-06-19 신규 노드). 이 상품은 **실사 파일럿의 대표 아키타입 =
면적매트릭스형**이다 — 가격이 [가로×세로] 셀단가로 결정된다(pack §3.10 B02).

- **★가격 = 면적매트릭스(area-matrix)[HARD·HARNESS-DOMAIN-RULES]:** `PRF_POSTER_ARTPAPER`가
  `COMP_POSTER_ARTPAPER_MATTE`(use_dims=`[siz_width, siz_height]`·39셀) 하나를 통해 포스터사인
  [가로(col)×세로(row)] 셀단가를 룩업한다. 각 (가로,세로) 순서쌍이 고유 셀·고유 단가(매트릭스
  비대칭). **off-grid**(격자에 없는 치수)는 **가로·세로 각 한 단계 큰 규격으로 ceiling**해 셀을
  고른다(앱 계산·DB는 룩업행만). 원자합산형(디지털 PRF_DGP_*)·고정룩업(스티커 PRF_STK_FIXED)과
  다른 3번째 아키타입([[formula/digital-formulas]]·[[formula/sticker-formulas]]와 별개).
- **★비규격(nonspec) 연속범위 ≠ 가격격자(pack §3.2):** 라이브 `nonspec_yn=Y`로 가로 200~900·
  세로 200~3000(각 incr 200) 자유 입력을 받으나, 이는 **입력 UX 한계일 뿐 유효 가격 권위가
  아니다.** 유효 가격 = 면적매트릭스 셀([[gap-119-offgrid-golden]] 참조·off-grid ceiling).
- **★도수·인쇄방식 축이 얕다(pack §3.3/§3.7):** 실사는 **도수(칼라/흑백) 컬럼 자체가 없다**(대형
  잉크젯 풀컬러). 라이브 `t_prd_product_print_options`=0행·`t_prd_product_processes`=0행이 **정당**
  하다(없는 것을 지어내지 않는다). 인쇄방식 공정(실사 잉크젯 `PROC_000006`) 행도 부재.
- **★판형(plate)이 아니라 파일사양[HARD·T-7]:** 라이브에 `t_prd_product_plate_sizes` 3행이 있으나
  이는 **`output_file_typ=JPG` 파일 출력규격**이지 **종이류 절수 전지 판형이 아니다.**
  `output_paper_typ_cd`는 **공백**(실사=대형 롤 → 절수 임포지션 무의미·pack §3.8). 소재가 종이
  (매트지)라도 실사 워크플로는 대형 출력이라 `fn_best_plate` 절수 자동선택·`fn_calc_pansu` 판걸이수
  로직을 **적용하지 않는다**([[rule/rules#RULE_plate_paper_only]]·스티커/디지털 판형 로직 이식 금지).
- **A1 사이즈 마스터 삭제 정합(양면 신호):** 상품 사이즈 `SIZ_000293`(A1)은 `t_prd_product_sizes`
  에서 활성(del_yn=N)이나 마스터 `t_siz_sizes.SIZ_000293`은 **del_yn=Y**(2026-06-17 삭제)이고,
  출력측엔 별도 `SIZ_000294`(A1 파일사양)가 활성이다. 정답 상태(A1 유지/제거/재키잉)를 단정할 권위
  원천이 없어 [[gap-119-a1-master-deleted]]로 정직 선언(지어내지 않음).
- CPQ 옵션그룹·추가상품·제약규칙·묶음수(bundle_qtys)는 라이브 0행(전사 실측). 119는 실사 constraints
  발현 7상품(118/120/121/122/124/125/139) 목록 밖이다(pack §1.1). 손님 구성축 없는 단순 완제품.

## 상품 요소 전사 (권위 = 라이브 마스터·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_119.py`가 live-snapshot에서 뽑은 값이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-119-260703.json`. `python3
> transcribe_product_119.py` 재실행 시 동일 출력(멱등).

### 상품 정체·수량·비규격범위 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000119 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | nonspec_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 1 | 1000 | 1 | QTY_UNIT.01 | Y | N | Y | Y |

> 비규격(nonspec) 연속범위 — ★입력 UX 한계일 뿐 가격격자 아님(pack §3.2·가격 권위=면적매트릭스 셀):

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000119 nonspec_width/height @ 2026-07-03 -->
| 축 | min(mm) | max(mm) | incr(mm) |
|---|---|---|---|
| 가로(width) | 200 | 900 | 200 |
| 세로(height) | 200 | 3000 | 200 |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | lvl | 상위 | main_cat_yn |
|---|---|---|---|---|
| CAT_000314 | 아트포스터 | 2 | CAT_000004 | N |
| CAT_000004 | 포스터 | 1 | (root) | Y |

> 주 카테고리(main_cat_yn=Y)=포스터(CAT_000004·lvl1)·부(leaf)=아트포스터(CAT_000314·lvl2). round-13
> "실사 전부 CAT_000298 고아"는 **해소됨**(CAT_000298 del_yn=Y·정상 노드 재연결·pack §1.1·T-1). 두
> 카테고리는 공유 축(axis/categories.md) 미등재라 이 파일이 임시 선언(실사 첫 상품·승격 대기 → needed_shared).

### 사이즈 — 이산 규격(재단) (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_sizes+t_siz_sizes PRD_000119 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |
|---|---|---|---|---|---|---|
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | Y | 1 | N |
| SIZ_000197 | A2(420x594mm) | 420x594 | 420x594 | Y | 1 | N |
| SIZ_000293 | A1(594x841mm) | 594x841 | 594x841 | Y | 1 | Y |

> 사이즈 = 이산 규격 SIZ(A3/A2/A1) — 면적매트릭스는 이산 규격 + 비규격 연속범위 입력(pack §3.2).
> ★SIZ_000293(A1) 마스터 `del_yn=Y`(2026-06-17 삭제)인데 상품 사이즈 junction은 활성 → 정합 미상
> ([[gap-119-a1-master-deleted]]). 판걸이수는 사이즈 컬럼 아님(실사는 판걸이수 자체가 무의미·§3.8).

### 자재 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt |
|---|---|---|---|---|
| MAT_000177 | 매트지 | MAT_TYPE.08 | USAGE.07 | Y |

> 실사 자재 = 소재별 본체 자재 단일(낱장 완제품·내지/표지 없음·parent+usage_cd·USAGE.07·pack §3.5).
> 아트페이퍼포스터의 소재 = 매트지(comp_cd도 `..._MATTE`). `MAT_TYPE.08`(실사소재)은 현재값이며
> 매트지는 자재유형 교정 대상 목록(레더/린넨/캔버스/타이벡→.05)에 없어 `.08` 유지가 정합이다(pack
> §3.5·T-2 라벨 함정 주의). MAT_000177은 공유 축 미등재라 이 파일이 임시 선언(승격 대기).

### 판형(파일사양) (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes PRD_000119 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | note |
|---|---|---|---|---|
| SIZ_000052 | (공백) | JPG | Y | 파일사양 |
| SIZ_000198 | (공백) | JPG | Y | 파일사양 |
| SIZ_000294 | (공백) | JPG | Y | 파일사양 |

> ★이 3행은 **파일 출력규격(output_file_typ=JPG)**이지 종이류 절수 전지 판형이 아니다
> (`output_paper_typ_cd` 공백·pack §3.8·T-7). 실사=대형 롤이라 `fn_best_plate` 절수 자동선택·
> `fn_calc_pansu` 판걸이수 로직 **미적용**([[rule/rules#RULE_plate_paper_only]]). 스티커/디지털 판형
> SOT를 실사에 이식 금지.

### 얕은/미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options/processes/bundle_qtys/addons/constraints/option_groups @ 2026-07-03 -->
| 축 | 행수 | 실사 정당성 |
|---|---|---|
| print_options(도수/인쇄방식) | 0 | 실사=도수 컬럼 없음·대형 잉크젯 풀컬러 단일(pack §3.3/§3.7) |
| processes(공정) | 0 | 아트페이퍼=순수 출력물(봉제/타공/족자 후가공 없음) |
| bundle_qtys(묶음수) | 0 | 면적매트릭스는 수량축 없음(셀=완제품 통가격·pack §3.4) |
| addons(추가상품) | 0 | 부속붙는 8상품 아님(단품) |
| constraints(제약규칙) | 0 | 119는 constraints 7상품 목록 밖(118/120/121/122/124/125/139만·pack §1.1) |
| option_groups(CPQ) | 0 | 손님 구성축 없음(소재/규격 고정·일반현수막138만 옵션 레이어) |

> 없는 축을 지어내지 않는다(정직 표기). 도수·공정·CPQ·제약·묶음수 미보유가 실사 면적매트릭스형의 정상 형태다.

## 가격 경로 (priced_by → 공식 → 구성요소 → 차원)

`product-119-artpaper-poster` --priced_by--> [[formula-PRF_POSTER_ARTPAPER]]
--has_component--> [[component-COMP_POSTER_ARTPAPER_MATTE]](use_dims=`[siz_width, siz_height]`).
**끊긴 가격 사슬 아님**(priced_by 1개)·**고아 공식 아님**(has_component 1개). 구성요소의 use_dims가
이 상품 가격이 어떤 축(가로·세로)으로 달라지는지 선언하고, 실제 셀단가·off-grid ceiling **값 계산은
`evaluate_price` 권위**([[rule/rules#RULE_price_value_boundary]]·D-18 경계).

### 가격 배선 PRF_POSTER_ARTPAPER (전사·골든 스냅샷 20260702_1119)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| frm_cd | disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|---|
| PRF_POSTER_ARTPAPER | 1 | COMP_POSTER_ARTPAPER_MATTE | Y | PRICE_TYPE.01 | 실사 완제품가 (아트페이퍼포스터) | `["siz_width", "siz_height"]` |

### 단가행 접기 — 면적매트릭스 셀 요약 (D-22·값 나열 아님) (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_119.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices (comp_cd별 셀 행수+가로세로 순서쌍 범위·값 미나열) @ 2026-07-03 -->
| comp_cd | 단가행수 | (가로,세로) 순서쌍 수 | 가로 범위(mm) | 세로 범위(mm) |
|---|---|---|---|---|
| COMP_POSTER_ARTPAPER_MATTE | 39 | 39 | 600~900 | 600~3000 |

> 단가행(39셀)은 노드로 펼치지 않고 구성요소 노드 속성/행수로 접는다(D-22·값=evaluate_price). 39개
> (가로,세로) 순서쌍이 각각 고유 셀(매트릭스 비대칭 — (600×1000) 셀 ≠ (1000×600) 셀)·off-grid=한
> 단계 큰 규격 ceiling(앱). 절대 셀단가·off-grid 결과의 골든은 미검증([[gap-119-offgrid-golden]]).

---

## 이 상품 전용 하위 노드

> 실사(silsa)는 이 KB의 3번째 상품군 파일럿(디지털·스티커 다음)이라, 공유 축(axis/*·formula/*)에
> **실사 노드가 아직 없다.** 아트페이퍼포스터가 유일·최초 소비자인 실사 축(카테고리 포스터/아트포스터·
> 매트지 자재·면적매트릭스 공식/구성요소·A3/A2/A1 사이즈·파일사양 출력규격)은 이 companion 파일에
> **상품-local로 선언**하고 `needed_shared_nodes`로 반환(향후 실사 상품군 확장 시 공유 축 승격 후보·
> 052 스티커 첫 상품 선례). ★공유 파일 수정 금지 원칙 준수.

전용 하위 노드 정본 = [[product-119-artpaper-poster-nodes]].
