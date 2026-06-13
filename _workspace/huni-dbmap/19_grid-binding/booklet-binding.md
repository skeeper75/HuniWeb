# 책자 — 생산형태 × 그릇 × 선택→견적 binding (round-15 확대 #2)

> **작성** 2026-06-13 · round-15 확대(굿즈파우치 파일럿 A~E 구조 계승). **생산형태=반제품(`PRD_TYPE.02`) 핵심 시트.**
> **목적:** 시트의 각 컬럼이 ① 어떤 생산형태 상품의 ② 어떤 그릇에 담겨 ③ 고객 선택→견적까지 어떻게 이어지는지 + ④ 경쟁사 대조 + ⑤ 현재 고려/GAP을 한 판에.
> **입력 권위(재유도 0·인용):** `15_domain-spec/booklet/`(column-dictionary·product-bom·mapping-info·domain-research-notes) · `16_mapping-research/booklet/mapping-final.md`(43컬럼 라이브 확정·★1~9·CONFLICT/GAP) · `17_correctness/booklet/`(product-identity·correction-manifest BK-1~12) · `00_schema/schema-design-intent-map.md`(③ 삼중바인딩·§2.3 셋트·OM-6) · `production-form-grid-matrix.md`(§1.1 책자=반제품·§2 매트릭스 반제품 열) · `17_correctness/_crosscut/`(BATCH-1/4/7/9/10/11·레더.06) · 가격 소스=인쇄상품 가격표 엑셀(제본 시트).
> **DB 미적재 — 조망/목표매핑 전용.**

---

## A. 상품군 성격 (생산형태 + 정체)

> **[보정 2026-06-13 — 독립검증 NO-GO 반영] 도메인 생산형태와 라이브 `prd_typ_cd`를 분리 기재**(`production-form-grid-matrix.md §1.0` HARD 발견: 라이브 `prd_typ_cd`는 생산형태가 아닌 editor 여부·매입성 혼합 기준 = 오모델). 책자 시트는 **도메인 반제품 ↔ 라이브 .02 대체로 일치(정합도 높은 시트)** — 단 일부 `.04 디자인` 혼재.

| 항목 | 내용 |
|------|------|
| **도메인 생산형태** | **반제품** — 표지+내지(+면지/링/D링)를 **결합·제본**해 완성(prd_cd 단위 도메인 판정). |
| **라이브 `prd_typ_cd` 실측** | **`.02 반제품` × 7**(책자 카테고리 활성 완제품) **+ 하드커버 `.02` × 18**(하드커버류 sub_prd 포함) **+ `.04 디자인` × 5/4**(디자인포토북류 혼재분). **전역 `.02`는 28행**(포토북 반제품 포함 — 책자 단독 아님). 기존 binding의 `PRD_TYPE.02|21` 단언은 라이브 불일치 → 정정. |
| **정합도** | **도메인 반제품 ↔ 라이브 `.02` 대체로 일치**(이 시트는 다른 시트 대비 정합도 높음 — digital-print가 라이브에서 `.04`로 흩어진 것과 대조). 단 일부 `.04 디자인`(디자인포토북) 혼재 = 오모델 흔적. |
| **정체** | **10 활성 완제품**(L1 distinct prd_nm, PRD_000068~097) + **21 반제품 sub_prd** = 라이브 31행. round-11 "11상품"은 보류중 링바인더 포함 수(F-ID-0 정정). 정체 오분류 0(digital-print/goods-pouch와 다름 — 전형적 일반 인쇄물 책자). |
| **생산방식 3구조**(정체 핵심) | **A 통합**(중철/무선/PUR/트윈링 — 내지.01+표지.02 parent, sets=0) · **B 셋트**(하드커버/레더하드/하드링/레더바인더 — +면지.03·표지 sub_prd+sets) · **떡제본**(엽서북=page 활성·떡메모지=묶음수·page 무의미). |
| **표지 sub_prd = 빈 껍데기** | B 셋트 표지(sub_prd)는 self-ref 결합점일 뿐 **9속성 0행이 정상**(자재 권위=parent+usage_cd). 단 PRD_000078만 예외로 자재 오적재(BK-2, 가장 위험 finding). |
| **직교 속성** | 디자인포토북류 editor는 책자 시트엔 없음(디자인=포토북 family). 책자는 `editor_yn=Y`(C41)지만 생산형태 분류축 아님. |
| **MES** | 전 완제품 `MES_ITEM_CD` NULL(BK-11 = load_master L261 의도적 NULL, 원천 006-0001~0008 중복 회피). by-design. |
| **가격 소스** | **인쇄상품 가격표 엑셀(제본 시트)** — 굿즈파우치(상품마스터 가격포함)와 다름. **반제품가/완제품가**(표지반제품 + 내지 + 제본 결합)를 포함. round-2 가격사슬 6/10 부분 적재. |

> ⚠️ **prd_cd 단위 생산형태:** 책자 10완제품은 전부 반제품 결합이나, 떡메모지(097)는 내지만(표지 없음·page 무의미·묶음수 권), 레더바인더(088)는 제본 family 미연결(D링 결합)이라 **한 시트 안에서도 결합 구조가 갈린다**(생산형태 횡단 원칙).

---

## B. 실무진이 준비한 그릇 (스키마 인벤토리)

`production-form-grid-matrix §2 매트릭스 반제품 열` 기준, 책자에 실제 쓰이는 그릇:

> **[보정] 실무진 표시용 쉬운 라벨 열 추가**(`§1.0-b` HARD: 적재 시 `note`/`tags`/코드 설명에 개발 코드 아닌 쉬운 한국어를 푼다).

| 그릇 (t_*) | 책자에서 담는 것 | 엑셀 컬럼 | **실무진 표시용 쉬운 라벨** | 비고 |
|-----------|----------------|----------|---------------------------|------|
| `t_prd_products` | 상품정체(=제본)·수량범위(min/max/incr)·editor_yn | C4·C37~39·C41 | `PRD_TYPE.02`→"**반제품(표지+내지 결합 제본)**" | 멱등키=prd_nm·MES NULL(BK-11) |
| `t_prd_product_sets` | **반제품 셋트**(표지 sub_prd self-ref, B 셋트) | C18(표지타입) | "표지·내지 셋트 결합" | ◆21r 적재·sub_prd 빈 껍데기 정상 |
| `t_siz_sizes`+`_sizes` | 재단치수(완성)+**책등 두께**(하드커버링 A/B) | C5·C9 | "완성 사이즈 + 책등 두께" | 두께A/B ↔ 제본 책등mm param 교차 |
| `t_prd_product_plate_sizes` | **작업사이즈(내지/표지 각각)**·표지=책등 포함 펼침 | C8·C20 | "작업 사이즈(인쇄용)" | ◆32r·output_paper_typ_cd 전량 NULL(GAP-PAPER) |
| `t_prd_product_materials`+`_materials` | **내지.01·표지.02·면지.03·투명커버.05·링/D링.07** | C13·C24·C33·C27·C34·C35 | `usage_cd.01`→"내지용 종이"·`.02`→"**표지용 종이**"·`.03`→"면지용 종이"·`MAT_TYPE.06`→"**가죽(레더)**" | **자재 권위=parent+usage_cd**(sub_prd 0행 정상) |
| `t_prd_product_print_options` | 내지/표지 면=도수(opt_id seq로 구분, usage_cd 컬럼 부재) | C14·C25 | "내지/표지 인쇄 도수(단·양면)" | 단/양면→print_side |
| `t_proc_processes`+`_processes` | **제본(PROC_000017 자식)**·코팅·박/형압·박색·투명커버부착·포장 | C26·C28·C30·C31·C42 | `PROC_000017`→"**제본**"·코팅→"코팅 가공"·박→"박(금박/은박) 가공" | mand_proc_yn=N(라이브) |
| `t_prd_product_option_groups` (CPQ) | **GRP-BOOK-제본 택일그룹**(SEL_TYPE.01 단일) | C31(택일) | "고객이 고르는 제본방식 옵션" | ❌ **option_groups 0행**(OM-6·GAP-OG) |
| `t_prd_product_page_rules` | **내지 페이지 규칙**(min/max/incr, 제본별 차등) | C15·C16·C17 | "페이지 수 입력 규칙" | 중철4배수·무선24~300·트윈링8~100 |
| `t_prd_product_bundle_qtys` | **묶음수(권)**(떡메모지 50/100장1권) | C36 | "묶음 단위(권)" | QTY_UNIT.03 권·page_rule 아님 |
| `t_prd_product_price_formulas`+`t_prc_component_prices` (가격) | 반제품가+내지가+제본가 사슬 | (가격표 제본 시트) | "가격 계산식·단가표" | 🟡 6/10 부분(상품군 충족률) |
| `t_prd_product_constraints` | 표지↔내지 결합·인쇄면지 캐스케이드 제약 | (도출) | "옵션 조합 제약 규칙" | ❌ 0행 |

→ **그릇은 다 갖춰져 있음**(sets 21r·page_rules 9/10·plate 32r 풍부). 문제는 ③선택(CPQ option_items)·④가격이 라이브 부분/미적재.

---

## C. 선택 → 견적 end-to-end 목표 매핑 (★핵심·가격 소스 = 인쇄상품 가격표 제본 시트)

고객이 견적 화면에서 **고르는 순서**대로, 각 선택이 어느 그릇→가격으로 이어지는지:

| 단계 | 고객 선택 | 담기는 그릇 | UI(componentType) | 가격 기여 |
|:--:|----------|-----------|------------------|----------|
| 1 | **상품(=제본 정체)** | products+categories | (카탈로그) | 완제품가 base 결정 |
| 2 | **표지타입**(일반/하드/레더/링) | **`sets`**(B 셋트 sub_prd) + products(prd 분기) | `option-button` | **반제품가**(하드/레더 표지 = 별 생산라인) |
| 3 | **사이즈** (A5/A4 + 하드링=책등두께A/B) | `sizes`(재단=완성) + 책등=siz param ↔ D링 mm(C35) | `select-box` | base 단가 키(면적/규격) |
| 4 | **내지종이/표지종이** | `materials`(내지=USAGE.01·표지=USAGE.02, `*별도설정`=공통풀 전개) | `select-box`/`image-chip` | 내지단가 × 페이지 + 표지단가 |
| 5 | **내지/표지 인쇄**(단/양면) | `print_options`(opt_id seq로 내지/표지 구분) | `option-button` | 도수 단가 |
| 6 | **표지옵션**(코팅/투명커버/박·형압) | `processes`(코팅 PROC_000014/15·박 PROC_000033 family·형압 PROC_000050) **+** 투명커버=`materials` USAGE.05 BUNDLE | `finish-button`/`color-chip`(박색) | 가공 단가(박 크기→등급=앱계산 C29) |
| 7 | **제본방식**(중철/무선/PUR/트윈링/하드/떡) | `processes`(PROC_000017 자식 1:1) + (택일=`option_groups` GRP-BOOK-제본 **미적재**) | `option-button`(택1) | 제본 공정비(완제품가 포함) |
| 8 | **제본옵션**(방향·면지·링컬러·바인더링) | 방향=proc param / 면지=`materials` USAGE.03 / 링·D링=`materials` USAGE.07 | `option-button`/`color-chip` | 면지·링 자재가 |
| 9 | **페이지수**(내지) | `page_rules`(min/max/incr 검증) | `page-counter-input` | × 페이지 단가(중철=4배수) |
| 10 | **수량**(권) / 떡메모지=묶음수 | products(min/max/incr) / `bundle_qtys`(권) | `counter-input` | × 수량 − 구간할인 |
| → | **견적 = (반제품 표지가 + 내지가×페이지 + 표지옵션·박/형압 가공가 + 제본 공정비) × 수량 − 구간할인** | `price_formulas`+`comp_prices`(제본 시트) + `t_dsc_*` | `summary` | ④ 가격 사슬 |

**가격 소스 확정:** 책자 가격은 **인쇄상품 가격표 엑셀의 제본 시트**에서 나온다(굿즈파우치=상품마스터 내장과 대비). **반제품가(표지=하드보드/싸바리/레더 별 생산라인) + 완제품가(내지+표지+제본 결합)** 합산형. round-2 가격사슬은 책자 **6/10**(=책자 상품군 충족률) 부분 적재(가격표 제본·엽서북떡메 잔여, gap-board L67). **라이브 🟡 = 부분 적재일 뿐, 소스엔 有.**

> **[보정 — 라이브 실측 정정 `§1.2`] "라이브 0" 단언 금지:** 전역 `option_items` **25행**(`option_groups` 7 = 프리미엄엽서 7 + 일반현수막 18) · `comp_prices` **3,481행**(아크릴·스티커·별색·면적매트릭스 단가행 — **제본 단가도 실재**) · `product_prices` **0행**(직접 고정가만 미적재) · `price_formulas` **63 바인딩**. 책자 ③CPQ·④가격의 "❌/🟡 **6/10**"은 **상품군 충족률(상품 공식 바인딩 커버리지)**이지 전역 행수 0이 아니다(이전 진단 과장 정정).

> **2축 도출 적용(셀 내부):** "표지종이" → ①BOM축: 자재(내지/표지 usage 분리) · ②판매축: 종이종류=`option_items`(선택). "박/형압" → ①공정(박 PROC_000033·형압 PROC_000050) · ②택일옵션 + 박색=공정 자식(C30·★1). "제본" → ①공정(PROC_000017 자식) · ②택일그룹(GRP-BOOK-제본). 매트릭스 셀이 1차, 2축이 2차.

---

## D. 경쟁사 대조 (생산형태=반제품 책자 관점 — 하드커버/레더/소프트커버 세트)

| 쟁점 | 경쟁사 패턴 | 후니 정합 | 출처 |
|------|-----------|----------|------|
| 표지타입(반제품 세트) | RedPrinting/POD: hardcover/softcover/leather = **별 SKU 또는 표지타입 옵션**(별 생산라인) | ✅ 후니 `sets` sub_prd self-ref 동형 — 표지=반제품 결합(B 셋트) | `accessory-option-research §`(세트=`t_prd_product_sets`) |
| 표지 ≠ 내지 자재 | 경쟁사: cover/text(body) paper 별 선택축 | ✅ usage_cd 슬롯(.01내지/.02표지/.03면지)으로 분리 — 새 축 안 만듦 | intent-map §348 usage 슬롯 |
| 제본방식 택1 | 경쟁사: binding=단일 선택(saddle/perfect/spiral/case) | ✅ GRP-BOOK-제본 SEL_TYPE.01 단일(but 상품=제본 1:1이라 현 미적재 정당·BK-9) | mapping-final GAP-OG |
| 페이지 룰(제본별) | 경쟁사: saddle=4배수·perfect=min24 | ✅ page_rules 제본별 차등(중철4·무선24~300·트윈링8~100) 실측 일치 | mapping-final C15~17 |
| 레더 표지 분류 | 경쟁사: leather=별 표면재(가죽) | 🟡 후니 라이브=MAT_TYPE.08 실사소재(Q4 의도=가죽.06) — **BATCH-4 정정 대상** | crosscut BATCH-4 |

→ **후니 그릇이 경쟁사 반제품 세트 표현력 흡수**(답습 불요). 책자 특화 GAP은 없음 — 결함은 **속성축 적재**(레더 mat_typ·sub_prd 오적재·카테고리 잉여)에 집중(F-ID 결론).

---

## E. 현재 고려 여부 + GAP (사슬 끊긴 곳 + BATCH 수렴)

| 레이어 | 상태(coverage 책자 열) | GAP/조치 |
|--------|----------------------|---------|
| ①골격 | ✅ products/categories 10 | — (단 카테고리 위계 결함 BK-CAT) |
| ②차원그릇 | 🟡 materials 9/10·sizes 10·plate ◆32r·page_rules 9/10·sets ◆21r·bundle 1/10 | sub_prd 078 자재 오적재(BK-2)·떡메 usage 복제(BK-1)·레더 mat_typ(BK-3) |
| **③선택(CPQ)** | 🟡 **책자 상품군 충족률 0/10**(전역 `option_items` 25·`option_groups` 7=엽서/현수막 — 책자엔 아직 미적재) | GRP-BOOK-제본 택일그룹 책자 미적재 — 단 상품=제본 1:1이라 현재는 불요(BK-9·OM-6 round-6 시). **"전역 0" 아님 — 책자 커버리지 0** |
| **④가격** | 🟡 책자 충족률 **6/10**(전역 `comp_prices` **3,481**·`price_formulas` **63**·`product_prices` 0) | 가격표 제본 시트→나머지 4(엽서북·떡메 등) 추출·적재(round-2). **제본 단가행은 전역 실재**, 미흡은 상품 공식 바인딩 커버리지 |

**잔존 컨펌(인간 결정) → BATCH 원칙 수렴:**

| 컨펌 ID | 내용 | 분류 | 수렴 BATCH(횡단) |
|---------|------|------|-----------------|
| **Q-BK-A**(BK-3) | 레더(화이트) MAT_000186 = .08 실사소재 vs Q4 가죽(.06). .06 고아행 4개(MAT_000008/173~175) 실재 | AMBIGUOUS | **BATCH-4 레더=가죽**(MAT_000186 1행=6상품 동시·search-before-mint 검산 완료·roadmap 최시급) |
| **Q-BK-C**(BK-7) | 내지/표지 폴더(C12/C23)=출력용지규격 plate 전량 NULL — 적재 vs 견적밖 메타 | MISSING | **BATCH-10 출력용지·생산메타**(5 family) |
| **Q-BK-B**(BK-8) | 떡메모지 page_rule 3/3/3(잡음) + 묶음수 둘 다 — 묶음수=권위 | EXTRA | **BATCH-7 page 잡음 정리**(2 family) |
| **Q-BK-D**(BK-6) | 레더바인더(088) 공정 0행 — 제본 없음 정당, 후공정(수축포장/재단) 존재 여부 | AMBIGUOUS | (책자 단발·F-ID-2) |
| **Q-BK-E** | 책등 두께(A4 두께A 31mm)=D링 mm로 표현(중복 size 불요?) | 정보성 | **BATCH-6 size↔option 경계** 인접 |
| BK-1(떡메 097) | USAGE.07 동일 mat 복제(.01↔.07, 전 DB 1건) | MIS-LOADED | **BATCH-9 usage**(책자 종이 .07→.01·낱장 .07 유지) |
| BK-2(078) | sub_prd 078 몽블랑130g 자재 오적재(레더여야·21중 078만) | MIS-LOADED | 교정 직접(논리삭제·**Top finding**) |
| BK-CAT(068~071·077·082) | 전용 잎노드 6개(CAT_000100~103·106·107) 상품 0 고아·lvl1/lvl3 직결 | EXTRA | **BATCH-1 카테고리 재연결**(9 family·113상품·digital-print F-GATE-1 동형) |
| BK-11 | MES_ITEM_CD 전량 NULL | CORRECT(by-design) | **BATCH-11 MES**(5 family) |

> **횡단 수렴 입증:** 책자 컨펌 9건 중 **7건이 횡단 BATCH로 흡수**(레더=BATCH-4·카테고리=BATCH-1·page잡음=BATCH-7·usage=BATCH-9·폴더=BATCH-10·MES=BATCH-11·책등=BATCH-6 인접). 책자 단발은 BK-2(078 sub_prd 잡음)·BK-6(088 후공정)뿐. **round-15 목표(케이스 컨펌→생산형태별 원칙+진짜 예외)가 반제품 시트에서 재입증.**

---

## 한 줄 현황

**확대 GO:** 책자를 A(성격=**반제품 PRD_TYPE.02**·표지 sub_prd 빈껍데기·생산방식 3구조)·B(그릇 12종, sets 21r·page_rules 9/10)·C(선택→견적 10단계·가격=**인쇄상품 가격표 제본 시트**·반제품가+완제품가)·D(경쟁사 하드/레더/소프트 세트 흡수)·E(③CPQ 0·④가격 6/10·컨펌 7/9가 BATCH-1/4/6/7/9/10/11로 수렴, 단발=BK-2/BK-6)로 정리. **DB 미적재.**
