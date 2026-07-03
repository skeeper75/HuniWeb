<!-- namespace file: sticker-spec-band-nodes (반칼띠지스티커 PRD_000061 전용) — 스티커 파일럿 규격형 family(058~061). -->
<!-- ★블록-노드 파일(frontmatter 아님) — L-1 파일명↔id 검사 예외(is_file_node=False). 축/formula 파일과 동형. -->
<!-- ★공유 파일(index/axis/*/formula/*/rule/*) 미수정. ★[HARD 재사용] 스티커 공유 원자(category-CAT_000002/037· -->
<!--   size-SIZ_000520/170·material-MAT_000153/084/242/155/156·process-PROC_000055/013·printopt-POPT_000001· -->
<!--   formula-PRF_STK_FIXED·component-COMP_STK_PRINT)는 이미 등재된 노드(sticker-spec-rectangle-nodes.md· -->
<!--   047·공유 axis/*)를 재사용·여기 재민팅하지 않는다(L-3 중복 회피·nodes.jsonl 실재 count=1 확인). -->
<!--   061 전용(plate-061·qty-061·gap-061-*)만 여기 신설. 공유축 승격 후보는 needed_shared_nodes로 반환. -->
<!-- ★수치(치수·사양·배선·격자행수)는 전사 스크립트 transcribe_product_061.py 출력만(transcribed-by 마커). LLM 손전사 금지(D-9). -->

# product-061 전용 노드 (반칼띠지스티커 — 상품 전용 마스터 축 + GAP)

[[sticker-spec-band]]([[product-061-band-sticker]])가 연결하는 축 중 **061에 고유한 것만** 여기 신설한다.
스티커 규격형 family(058~061)가 공유하는 축(카테고리·규격 사이즈 SIZ_000520·점착지 5소재·스티커완칼
PROC_000055·완제품가 공식 PRF_STK_FIXED·구성요소 COMP_STK_PRINT)은 **이미 등재된 노드를 재사용**하고
여기 중복 민팅하지 않는다(L-3 회피·search-before-mint). 061 라이브 형상은 형제 060(반칼직사각)과 **동일 shape**
(같은 카테고리·규격 사이즈·5소재·1공정·1판형·완제품가 격자 10조합)임을 전사표가 실증한다.

---

## 전사표 (권위 = 라이브 스냅샷·스크립트 전사)

> 아래 표는 모두 `_meta/scripts/transcribe_product_061.py`가 live-snapshot에서 결정론 전사한 것이다
> (LLM 손전사 금지·D-9). 캐시=`_meta/scripts/cache/transcribed-061-260703.json`.

### 상품 정체·수량 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_products PRD_000061 @ 2026-07-03 -->
| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |
|---|---|---|---|---|---|---|---|---|
| PRD_TYPE.01 | 4 | 10000 | 4 | QTY_UNIT.02 | Y | Y | Y | N |

### 카테고리 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_categories+t_cat_categories @ 2026-07-03 -->
| cat_cd | 이름 | 상위 | main_cat_yn |
|---|---|---|---|
| CAT_000002 | 스티커 |  | Y |
| CAT_000037 | 규격스티커 | CAT_000002 | N |

### 사이즈 치수 (전사·형상=size)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes (linked+plate)·del_yn 포함 @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | del_yn | tags | note |
|---|---|---|---|---|---|---|
| SIZ_000007 | 148x210 | 150x212 | 148x210 | N | ["엽서"] | 판걸이=4.0 / 전지=316x467 / 적용=엽서 |
| SIZ_000050 | A4 (210X297) | 216x303 | 210x297 | N |  | 판걸이=2.0 / 전지=316x467 / 적용=전단지 / 책자내지 |
| SIZ_000170 | A5(148x210mm) | 148x210 | 148x210 | Y |  |  |
| SIZ_000520 | A4(210x297mm) 반칼 | ?x? | ?x? | N |  | 판걸이=2.0 / 적용=반칼스티커(058~061) / B02 낱장 SIZ_172와 분리(반칼 전용가) |
| SIZ_000521 | 330x470 | 330x470 | 320x460 | N | ["46전지"] | 전지(46계열)·반칼 스티커 표준전지 / 출처: 상품마스터260610·출력소재IMPORT |

> ★SIZ_000007·SIZ_000050은 061의 **판형(삭제됨)** 링크에서 유입된 행(주문 사이즈 아님). 주문 사이즈
> (t_prd_product_sizes)=SIZ_000520·SIZ_000170. 활성 판형=SIZ_000521. SIZ_000520(A4 반칼)은 작업/재단
> 컬럼 공백(라벨·판걸이 note로만 정의). SIZ_000170(A5)은 **마스터 del_yn=Y**(관찰·[[gap-061-a5-size-master-deleted]]).
> SIZ_000520 note "적용=반칼스티커(058~061)"에 061 포함(family 공유 규격·라이브 실측 확증).

### 자재 (전사·코팅 155/156=BATCH-3 CONFLICT)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_materials+t_mat_materials·note 포함 @ 2026-07-03 -->
| mat_cd | 이름 | mat_typ | usage_cd | dflt | mat note |
|---|---|---|---|---|---|
| MAT_000153 | 유포스티커 | MAT_TYPE.11 | USAGE.07 | Y |  |
| MAT_000084 | 비코팅스티커 | MAT_TYPE.13 | USAGE.07 | Y | \| 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000242 | 미색스티커 | MAT_TYPE.11 | USAGE.07 | Y | \| 정정 2026-06-14: 자재유형 종이(.01)→스티커(.11) 점착지 |
| MAT_000155 | 무광코팅스티커 | MAT_TYPE.11 | USAGE.07 | Y |  |
| MAT_000156 | 유광코팅스티커 | MAT_TYPE.11 | USAGE.07 | Y |  |

### 인쇄옵션 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_print_options+t_clr_color_counts @ 2026-07-03 -->
| print_opt_cd | 면 | 앞도수 | 뒷도수 |
|---|---|---|---|
| POPT_000001 | 단면 | CMYK 4도 | 인쇄 안 함 |

### 공정 (전사)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_processes+t_proc_processes·note 포함 @ 2026-07-03 -->
| proc_cd | 공정명 | mand | proc note |
|---|---|---|---|
| PROC_000055 | 스티커완칼 | N | Die Cut + 조각수 |

### 판형 (전사·활성+삭제)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_plate_sizes·del_yn 포함 @ 2026-07-03 -->
| siz_cd | output_paper_typ | output_file | dflt | del_yn | note |
|---|---|---|---|---|---|
| SIZ_000007 | OUTPUT_PAPER_TYPE.03 | PDF | Y | Y | 파일사양 |
| SIZ_000050 | OUTPUT_PAPER_TYPE.03 | PDF | Y | Y | 파일사양 |
| SIZ_000521 | OUTPUT_PAPER_TYPE.02 |  | Y | N |  |

### 미보유 축 (전사·0행 실측)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_bundle_qtys/addons/constraints/option_groups/sets @ 2026-07-03 -->
| 축 | 행수 |
|---|---|
| bundle_qtys(묶음수) | 0 |
| addons(추가상품) | 0 |
| constraints(제약규칙) | 0 |
| option_groups(CPQ 옵션) | 0 |
| sets(셋트 부모) | 0 |

### 가격 배선 PRF_STK_FIXED (전사·완제품가 룩업)

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components @ 2026-07-03 -->
| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |
|---|---|---|---|---|---|
| 1 | COMP_STK_PRINT | Y | PRICE_TYPE.01 | 스티커 완제품가(소재·규격) | `["siz_cd", "mat_cd", "min_qty"]` |

### 단가행 격자 커버리지 (전사·행수 집계·값 아님·D-22 접기) {#price-grid}

<!-- transcribed-by: _meta/scripts/transcribe_product_061.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices COMP_STK_PRINT (siz,mat) 조합별 행수 @ 2026-07-03 -->
| siz_cd | mat_cd | 단가행 수 |
|---|---|---|
| SIZ_000170 | MAT_000084 | 36 |
| SIZ_000170 | MAT_000153 | 36 |
| SIZ_000170 | MAT_000155 | 36 |
| SIZ_000170 | MAT_000156 | 36 |
| SIZ_000170 | MAT_000242 | 36 |
| SIZ_000520 | MAT_000084 | 36 |
| SIZ_000520 | MAT_000153 | 36 |
| SIZ_000520 | MAT_000155 | 36 |
| SIZ_000520 | MAT_000156 | 36 |
| SIZ_000520 | MAT_000242 | 36 |

> 10개 (siz,mat) 조합 전부 단가행 실재(각 36 수량구간행·총 360행). 완제품가 격자 완비 — 값 절대치는
> `evaluate_price` 권위(D-18·값 전사 아님·행수만). 이 격자가 형상×치수×코팅(비코팅/무광/유광 자재축) 완제품가.

---

## 재사용 공유 원자 (여기 재민팅 안 함 — L-3 회피) {#reused}

061이 연결하는 아래 축 노드는 **이미 KB에 1개씩 등재**되어 있어 재사용한다(nodes.jsonl 실재 count=1 확인·
`build_graph.py` 링크 해소). 스티커 규격형 family가 공유하므로 **공유 axis/formula 승격 후보**(needed_shared_nodes).

| 재사용 노드 id | 정의 위치(현재) | 승격 후보 대상 |
|---|---|---|
| category-CAT_000002 / category-CAT_000037 | sticker-spec-rectangle-nodes.md 등 | axis/categories.md |
| size-SIZ_000520 (A4 반칼) | sticker-spec-rectangle-nodes.md | axis/sizes.md |
| size-SIZ_000170 (A5) | product-047-small-flyer.md | axis/sizes.md |
| material-MAT_000153/084/242/155/156 (점착지 5종) | sticker-spec-rectangle-nodes.md | axis/materials.md |
| printopt-POPT_000001 (단면) | axis/print-options.md(공유) | (이미 공유) |
| process-PROC_000055 (스티커완칼) | sticker-spec-rectangle-nodes.md | axis/processes.md |
| process-PROC_000013 (코팅=공정 뷰) | axis/processes.md(공유) | (이미 공유) |
| formula-PRF_STK_FIXED (완제품가 룩업) | product-052-…-nodes.md / rectangle-nodes.md | formula/sticker-formulas.md(신규) |
| component-COMP_STK_PRINT (완제품가 구성요소) | product-052-…-nodes.md / rectangle-nodes.md | formula/sticker-components.md(신규) |

> ★현재 이 공유 원자들이 052/058/060 companion에 각기 재민팅되어 **L-3 중복 id가 이미 존재**한다(빌드 리포트
> 실측). 061은 그 문제를 **키우지 않기 위해** 재민팅하지 않고 참조만 한다. 근본 해소(공유 axis/formula로 승격·
> 중복 제거)는 공유 파일 소관=architect(needed_shared_nodes). 061 노드는 그 승격 전까지도 링크가 해소된다.

---

## 판형 (plate size) — 반칼띠지 전용 활성 1행 {#plate}

종이류(점착지)라 판형 유효([[rule/rules#RULE_plate_paper_only]])·고객 미선택(`fn_best_plate` 자동선택).
판형 junction 앵커=부모 prd_cd(스키마 §1.0 규약)라 **상품 전용 노드**로 신설(형제 060 `plate-060-SIZ_000521`와
별 노드·중복 아님).

### [plate-061-SIZ_000521] 46전지 330x470 (반칼 스티커 표준전지) {verified}
- type: plate_size
- anchor: t_prd_product_plate_sizes/PRD_000061
- src: {source_file: "live-snapshot/latest/t_prd_product_plate_sizes.csv", source_locator: "테이블:t_prd_product_plate_sizes 키:(PRD_000061,SIZ_000521) output_paper_typ_cd=OUTPUT_PAPER_TYPE.02·dflt_plt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000521 (330x470·tags 46전지·note 반칼 스티커 표준전지·출처 상품마스터260610 출력소재IMPORT·260702 무변경=전지 규격 diff 비대상)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_cd: "SIZ_000521", output_paper_typ_cd: "OUTPUT_PAPER_TYPE.02", note: "46전지 계열 반칼 스티커 표준 출력용지. dflt Y→fn_best_plate 자동선택. 판걸이수=파생(fn_calc_pansu·RULE_pansu_db_function). ★삭제 판형 2행(SIZ_000007/050·OUTPUT_PAPER_TYPE.03·6-30 del_yn=Y·output_file=PDF)은 유효 판형 아님(전사표 기록만). 형제 060/059와 동일 판형 shape"}
- 본문: 반칼띠지스티커의 활성 판형은 SIZ_000521(46전지) 단일. 종이류(점착지)라 판형 대상이며 고객이 고르지 않고 fn_best_plate가 판수>0으로 자동선택한다. 삭제된 국전/A4 파일사양 2행은 유효 판형이 아니다.

---

## 수량규칙 (product-local) {#qty}

### [qty-061] 반칼띠지스티커 수량규칙 {verified}
- type: bundle_qty
- anchor: t_prd_products/PRD_000061
- src: {source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "테이블:t_prd_products 키:PRD_000061 (min_qty 4·max_qty 10000·qty_incr 4·qty_unit_typ_cd QTY_UNIT.02)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/_foundation/batch/qty_rule_audit_260702.py", source_locator: "수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리)", captured_at: "2026-07-03", badge: verified, src_id: SR-27-qtyaudit}
- props: {min_max_incr_ref: "전사표(min 4·max 10000·incr 4)", bdl_unit_typ_cd: "QTY_UNIT.02", bundle_qtys_rows: 0, note: "상품레벨 수량규칙만·t_prd_product_bundle_qtys 0행(정상). 수량 UI 권위=상품/사이즈 규칙(가격구간과 역할 분리·pack §3.4·DEC_qty_audit_260702). min_qty는 가격 차원(COMP_STK_PRINT use_dims)에도 등장(수량구간). 형제 060과 동일 규칙"}
- 본문: 제품 레벨 수량규칙만 존재하고 묶음수(bundle_qtys) 행은 없다. 수량 UI의 권위는 상품/사이즈 수량규칙이며 가격구간(min_qty 차원)과 역할이 분리된다.

---

## GAP·관찰 노드 (원천 부재·CONFLICT — 지어내지 않고 정직 선언) {#gap}

### [gap-061-coating-conflict] 코팅=자재 vs 코팅=공정 미해소 CONFLICT (BATCH-3·GAP-ST-1) {unknown}
- type: gap
- anchor: none  # 사유: 세 권위가 충돌 — 라이브(코팅=자재 MAT_000155/156)·Q9(코팅=공정 PROC_000013)·가격표(코팅=가격축 3컬럼). 어느 것도 단정 불가(pack T-4)
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000061,MAT_000155/156) usage_cd=USAGE.07 (코팅이 자재 슬롯으로 적재)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.9 코팅 CONFLICT·§0-3·T-4(CONFLICT 미해소·양면만·단정 금지)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "061의 무광/유광 코팅이 라이브에 자재(MAT_000155/156·MAT_TYPE.11)로 적재됐으나 Q9 권위는 코팅=공정(PROC_000013). round-11 §44=자재 variant 정당·가격표=비코팅/무광/유광 3컬럼(코팅=가격축). 세 뷰가 양립 곤란·미해소 — 코팅을 자재/공정/가격축 중 무엇으로 정규화할지 미정"
- gap_fill_from: "실무진 Q-ST-A 답변 + 인간 승인(pack §5·§3.9 GAP-ST-1). 해소 전까지 단정 금지·양면(자재 뷰/공정 뷰) 병기"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000155, note: "코팅=자재 뷰(현재 라이브)"}
- rel: {rel: references, target: material-MAT_000156, note: "코팅=자재 뷰(현재 라이브)"}
- rel: {rel: references, target: process-PROC_000013, note: "코팅=공정 뷰(Q9 권위·공유 축)"}
- 본문: 061에 코팅 CONFLICT가 형제 059/060과 동일하게 살아있다(pack §0-3). 자재 뷰(MAT_000155/156)와 공정 뷰(PROC_000013)를 둘 다 기록하고 어느 쪽도 삭제·단정하지 않는다(pack T-4). 가격표가 코팅을 가격축(3컬럼)으로 쓰므로 소재축(COMP_STK_PRINT use_dims의 mat_cd)이 코팅 가격을 흡수하는 현 구조와 얽혀 있다. 정규화 판정은 실무진+§31 제약/§7 적재 소관.

### [gap-061-halfcut-process] 상품명 '반칼' vs 등록 공정 '스티커완칼(PROC_000055)' 불일치 {unknown}
- type: gap
- anchor: none  # 사유: 상품 정체(반칼=Kiss Cut PROC_000054)와 라이브 등록 공정(스티커완칼 Die Cut PROC_000055)이 어긋나나 어느 쪽이 정답인지 권위 부재
- src: {source_file: "live-snapshot/latest/t_prd_product_processes.csv", source_locator: "테이블:t_prd_product_processes 키:(PRD_000061,PROC_000055) mand_proc_yn=N (등록 공정=스티커완칼)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.6 커팅 공정(반칼 Kiss Cut PROC_000054·디지털=반칼)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "상품명 '반칼띠지스티커'는 반칼(Kiss Cut·PROC_000054·종이만)을 함의하나, 라이브 등록 공정은 스티커완칼(PROC_000055·Die Cut+조각수·mand=N). pack §3.6 '디지털=반칼(PROC_000054)'과 어긋남. 단 규격 family 058~061 전부 PROC_000055라 family 관례일 수 있어 오등록인지 정당한지 미확정"
- gap_fill_from: "실무진 확인(커팅 방식 정답) + §21 정합 검증(공정 축)·§26. 그 전까지 단정·자동교정 금지"
- gap_owner: staff
- rel: {rel: references, target: process-PROC_000055, note: "라이브 등록 공정(스티커완칼)"}
- 본문: 커팅 공정이 상품 정체와 어긋나는 관찰(형제 059/060 동일). mand_proc_yn=N이라 가격/견적에 강제되지 않으나 생산 라우팅 메타로는 부정확 가능. 가격은 완제품가 룩업(COMP_STK_PRINT)이 커팅비를 통째 포함하므로 이 공정행이 가격 사슬을 끊지는 않는다(가격 성립).

### [gap-061-a5-size-master-deleted] A5 사이즈 마스터 논리삭제 vs 링크 활성 불일치 {unknown}
- type: gap
- anchor: none  # 사유: t_siz_sizes SIZ_000170 del_yn=Y(삭제)인데 t_prd_product_sizes 061 링크 del_yn=N(활성) — 상태 불일치, 정답 미상
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000170 del_yn=Y (6-17 논리삭제)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000061,SIZ_000170) del_yn=N (링크 활성)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "061이 주문 사이즈로 SIZ_000170(A5)을 활성 링크(del_yn=N)하나, 사이즈 마스터 t_siz_sizes SIZ_000170은 del_yn=Y(논리삭제). 삭제된 마스터를 활성 상품이 참조 — A5를 유지할지 링크를 정리할지 미정(단가행 36행은 실재해 가격은 성립)"
- gap_fill_from: "실무진/§21 정합(사이즈 축)·del_yn 권위(논리삭제=del_yn·[[dbmap-del-yn-soft-delete-authority]]) 재판정. 물리삭제 금지·단정 금지"
- gap_owner: staff
- rel: {rel: references, target: size-SIZ_000170, note: "마스터 삭제·링크 활성 불일치 대상"}
- 본문: 마스터-링크 상태 불일치 관찰(형제 059/060 동일). SIZ_000520(A4 반칼)은 정상. A5가 실제 판매 규격인지 확인 필요.

### [gap-061-mat084-typ] MAT_000084 자재유형 .13 vs note .11 불일치 {unknown}
- type: gap
- anchor: none  # 사유: live mat_typ_cd=MAT_TYPE.13인데 note는 '→스티커(.11)' 정정 주장 — note-값 불일치, 권위(260702) 명시 부재로 정답 미상
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000084 (mat_typ_cd=MAT_TYPE.13·note='정정 2026-06-14: 종이(.01)→스티커(.11) 점착지')", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§3.5 정답 자재유형=MAT_TYPE.11(스티커)", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "비코팅스티커 MAT_000084의 자재유형이 live=MAT_TYPE.13인데, 같은 행 note는 종이(.01)→스티커(.11) 정정을 주장(note가 가리키는 값과 실제 값 불일치). pack §3.5 정답 자재유형=MAT_TYPE.11 대비 어긋나나 260702 권위에 MAT_000084 자재유형 명시가 없어 .11/.13 중 정답 미상"
- gap_fill_from: "권위(260702) 자재유형 확인 or 실무진(§12 basecode 자재 거버넌스). 그 전까지 단정 금지(양면 defect 아님 — authority 값 부재)"
- gap_owner: staff
- rel: {rel: references, target: material-MAT_000084, note: "자재유형 note-값 불일치 대상"}
- 본문: note가 정정 대상(.11)을 말하는데 실제 값은 .13 — note 미반영이거나 .13이 별도 정당 스티커 서브유형일 수 있다. 정답 자재유형 원천이 없어 defect 양면(current≠authority) 대신 GAP(unknown)으로 정직 표기(공유 재사용 노드 material-MAT_000084가 이미 candidate로 관찰 보유).

### [gap-061-yeondangga-scope] 연당가 재적재 워크리스트 — 061 소재 미해당 (honest N/A) {unknown}
- type: gap
- anchor: none  # 사유: pack §4 연당가 급변 소재(투명/홀로/크라프트/투명후지)를 061이 쓰지 않아 061에는 연당가 양면(defect) 노드가 없음을 명시(false-defect 방지)
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "061 자재(유포153/비코팅084/미색242/무광155/유광156) = N2 라벨 변경만(가격 무영향)·연당가 급변행 없음", captured_at: "2026-07-03", badge: unknown, src_id: SR-26-diff}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "문서:§4-A 연당가 변경 소재=투명(162/371)·홀로(163/590)·크라프트(164/591)·투명후지(372)·§4-D dual 판정", captured_at: "2026-07-03", badge: unknown, src_id: SR-pack-stk}
- gap_what: "pack §4 연당가/국4절가 급변(재적재 워크리스트)은 투명스티커·홀로그램·크라프트·투명후지 소재(MAT_000162/163/164/371/372) 몫이다. 061 반칼띠지는 유포/비코팅/미색/무광·유광코팅만 써서 그 소재를 쓰지 않으므로 061에는 연당가 양면(defect) 노드가 없다. 061 소재는 260702 diff에서 N2 라벨 변경만(가격 무영향). 단, 스티커 완제품가↔소재 원가 정합(원가 급락이 완제품 시트가격으로 전파돼야 하는지)은 상품군 전체의 열린 질문(pack §4-D 후속)"
- gap_fill_from: "연당가 재적재 대상은 063 반칼팬시투명 등 투명/홀로/크라프트 소재 상품 노드에서 양면 defect로 표기(pack §4-D). 061은 해당 없음(정직 선언). 완제품가 전파 여부는 실무진+§26/§27"
- gap_owner: staff
- 본문: 태스크의 연당가 양면노드 지침을 061에 적용한 결과 = **해당 없음**(061 소재가 연당가 급변 소재군에 없음). 지어내지 않고 왜 없는지를 근거와 함께 남긴다(dual_nodes=[]의 근거).

### [gap-061-golden] 스티커 완제품가 절대값 골든 미검증 {unknown}
- type: gap
- anchor: none  # 사유: COMP_STK_PRINT 격자(360행) 구조·커버리지는 확정이나 예전사이트 견적 절대값(골든) 대조는 pcode 미상으로 미수행
- src: {source_file: "live-snapshot/latest/t_prc_component_prices.csv", source_locator: "테이블:t_prc_component_prices comp_cd=COMP_STK_PRINT 061 격자 360행 실재(값=evaluate_price 권위·절대값 골든 대조 미수행)", captured_at: "live 20260702_1119", badge: unknown, src_id: SR-5-livesnap}
- gap_what: "061 완제품가 격자는 10 (siz,mat) 조합×36 수량구간행 완비(구조 GO)이나, 각 셀 단가의 예전사이트 견적 절대값 골든 대조가 pcode 미상으로 미검증. 값 정확성(권위 260702 가격표 verbatim 여부·§26 무결성)은 별도 트랙"
- gap_fill_from: "pcode 매핑 후 예전사이트/시뮬레이터 골든 대조(§26 무결성·§15 검증). KB는 격자 커버리지·차원 배선까지, 값 판정은 엔진/무결성 소관(D-18)"
- gap_owner: dev
- rel: {rel: references, target: component-COMP_STK_PRINT, note: "완제품가 절대값 골든 미검증"}
- 본문: 격자 커버리지(존재)는 확인, 값 정확성(정답 대조)은 미검증 — 지어내지 않고 정직 선언. 스티커 완제품가 무변경(260702 가격표=260527 동일·pack §4-B N2 라벨만)이라 retail 격자는 권위 일치 추정이나 절대값 골든은 대기.
