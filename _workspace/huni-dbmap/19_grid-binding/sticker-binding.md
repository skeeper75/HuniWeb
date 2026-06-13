# 스티커 — 생산형태 × 그릇 × 선택→견적 binding (round-15 확대 #1)

> **작성** 2026-06-13 · round-15 · **보정 2026-06-13(독립검증 NO-GO 반영).** 굿즈파우치 파일럿(`goods-pouch-binding.md`) A~E 구조 동형 적용 — 스티커 시트.
> **목적:** 각 컬럼이 ① 어떤 생산형태 상품의 ② 어떤 그릇에 담겨 ③ 고객 선택→견적까지 어떻게 이어지는지 + ④ 경쟁사 + ⑤ 현재 고려/GAP을 한 판에.
> **입력 권위(재유도 0·인용):** `15_domain-spec/sticker/`(product-bom·column-dictionary·domain-research-notes) · `16_mapping-research/sticker/mapping-final.md`(C1~C32) · `17_correctness/sticker/correction-manifest.md`(C-ST-01~17·코팅 8상품 MIS-LOADED) · `00_schema/schema-design-intent-map.md`(③ 삼중바인딩·§397 코팅=공정·§416 합판도무송 형상·Q7/Q9★) · `production-form-grid-matrix.md`(§1.0 도메인≠라이브 prd_typ·§1.0-b 쉬운 라벨·§1.2 사슬 진단·§2 원칙·완제품 열) · `accessory-option-research.md`(2축·경쟁사 6그릇) · `12_coverage/gap-board.md`.
> **가격 소스 = 인쇄상품 가격표 엑셀(스티커·합판도무송스티커 시트)** — 굿즈파우치(상품마스터 가격포함)와 다름.
> **DB 미적재 — 조망/목표매핑 전용.**

---

## A. 상품군 성격 (생산형태 + 정체)

> **[보정·HARD] 도메인 생산형태와 라이브 `prd_typ_cd` 실측을 분리 기재**(`grid-matrix §1.0`). 둘의 불일치 = 오모델(라이브가 생산형태를 일관 적재 안 함).

| 항목 | 내용 |
|------|------|
| **도메인 생산형태** | **완제품** — 낱장 점착물. C 완제품/단일(내지/표지 분해 없음·sets=0, `product-bom §0`·`grid-matrix §1.1`·§2 완제품 열). prd_cd 단위 도메인 판정. |
| **라이브 `prd_typ_cd` 실측** | **`.04 디자인상품` × 16(전부)**(스티커 16상품 라이브 read-only 실측). **도메인=완제품인데 라이브=`.04` = 불일치 = 오모델**(editor 표시값을 생산형태 칸에 적재). **라이브 `.01 완제품` 아님**(전역 `.01`은 단 3건=프리미엄엽서/명함/상품권, `grid-matrix §1.0`). |
| **정체** | **16 distinct 상품**(PRD_000052~067). 커팅(반칼/완칼)이 상품 정체의 핵심(상품명에 인코딩). |
| **인쇄방식 5분기** | 디지털인쇄·실사출력·화이트인쇄·합판인쇄·전사인쇄 — **C13 폴더가 상품별 라우팅 권위**(`product-bom §0`). 공정 백본을 인쇄방식이 게이팅. |
| **직교 속성** | 에디터(`editor_yn`)·업로드(`file_upload_yn`) — 생산형태 아님(C14·C15). **라이브 `.04`는 바로 이 editor 여부를 prd_typ 칸에 잘못 넣은 것**(직교 속성↔생산형태 혼동). |
| **MES** | 16상품 L1에 002-0001~0016 실값 보유하나 **라이브 전량 NULL**(load_master 의도·중복 회피, C-ST-08). |
| **가격 소스** | **인쇄상품 가격표 엑셀**(스티커 7블록 + 합판도무송스티커 시트) — 형상×사이즈 격자·코팅별 단가. round-2 부분 적재(④ 상품군 공식 바인딩 4/16). |

> ⚠️ 생산형태는 prd_cd 단위. 16상품 전부 도메인 완제품이나 **인쇄방식이 5갈래** = 그릇은 같아도 공정 root가 갈린다(굿즈파우치 7인쇄방식과 동형 패턴).

### A.1 실무진 표시용 쉬운 라벨 (`grid-matrix §1.0-b`)

> [HARD] DB 적재 시 실무진(비개발자)이 직접 보는 `note`/`tags`/admin 라벨에는 코드가 아니라 평이한 한국어를 푼다.

| 개발 코드/식별자 | 실무진용 비고/라벨 |
|---|---|
| `prd_typ_cd=.04`(라이브 현행) | 디자인상품(고객이 에디터로 직접 디자인) — **생산형태는 완제품, 단지 에디터로 디자인** |
| `PROC_000013` | 코팅 |
| `MAT_TYPE.11` | 점착지(스티커) |
| `PROC_000008` | 별색(화이트 underbase) |
| `PROC_000054`(반칼/완칼 계열) | 커팅(도무송) |
| `usage_cd=.07` | 출력 소재용(점착지) |
| **BATCH-3 확정**(스티커 코팅=출력소재 자재 유지) | **코팅 = 인쇄된 출력물 자체에 입히는 표면처리** — 가격은 비코팅/무광/유광 3단가로 가름 |

---

## B. 실무진이 준비한 그릇 (스키마 인벤토리)

`grid-matrix §2 완제품 열` 기준, 스티커에 실제 쓰이는 그릇:

| 그릇 (t_*) | 스티커에서 담는 것 | 엑셀 컬럼 | 비고 |
|-----------|------------------|----------|------|
| `t_prd_products` | 상품정체·수량범위(min/max/incr)·MES·editor/upload | C4·C3·C26~28·C14·C15 | 멱등키=prd_nm |
| `t_siz_sizes`+`t_prd_product_sizes` | **재단/작업치수** + **합판도무송 형상=칼틀 1:1(siz_nm에 형상+치수+EA)** | C5·C8·C9 | Q7★ 형상=size 유지 |
| `t_prd_product_plate_sizes` | **출력판형/전지**(330x470 등) | C10 | output_paper_typ_cd·output_file_typ |
| `t_mat_materials`+`t_prd_product_materials` | **점착지**(유포/비코팅/미색/투명/홀로그램+코팅 variant) | C16 | MAT_TYPE.11·usage=USAGE.07 공통 |
| `t_prd_product_print_options` | 인쇄면 도수(단면·앞4도/뒤0도) | C17 | print_side |
| `t_proc_processes`+`t_prd_product_processes` | **커팅(반칼/완칼/스티커완칼)·화이트별색·코팅·인쇄방식 root** | C24·C18·C23·C13 | 스티커 핵심 공정 |
| `t_prd_product_bundle_qtys` | **조각수**(판당 개수·EA) | C25 | Q8★ 묶음수+조각수 둘 다 |
| `t_prd_product_prices`(가격) | 형상×사이즈 격자·코팅별 단가 | (가격표 엑셀) | round-2 면적/고정가형 |
| `t_dsc_*`(할인) | 수량구간 할인 | — | round-1 공통 |
| `t_prd_product_constraints` | 커팅 캐스케이드·코팅×자재 택일 | (도출) | gap-board §108 |

→ **그릇은 다 갖춰져 있음.** 문제는 ③선택(CPQ)·④가격이 스티커 상품군에 미적재 + **공정 param(조각수·형상) 저장처 GAP**(OM-7).

---

## C. 선택 → 견적 end-to-end 목표 매핑 (★핵심)

고객이 견적 화면에서 **고르는 순서**대로, 각 선택이 어느 그릇→가격으로 이어지는지:

| 단계 | 고객 선택 | 담기는 그릇 | UI(componentType) | 가격 기여 |
|:--:|----------|-----------|------------------|----------|
| 1 | **상품(반칼/완칼·인쇄방식)** | products+categories(+인쇄방식=공정 root) | (카탈로그) | 가격표 블록 결정 |
| 2 | **사이즈/형상** (규격 치수 or 도무송 칼틀) | 치수형→`sizes` / 합판형상→`sizes`(siz_nm 칼틀) | `option-button`/`select-box` | **격자 단가 키(형상×사이즈)** |
| 3 | **자재(점착지)** | `materials`(MAT_TYPE.11, usage=.07) | `image-chip`/`color-chip` | 자재별 단가 |
| 4 | **코팅** (무광/유광/비코팅) | `processes`(PROC_000013) ‖ 라이브=자재 | `finish-button` | **코팅별 단가**(가격표 3컬럼) |
| 5 | **별색** (화이트 underbase·투명/홀로그램) | `processes`(PROC_000008) | `finish-button` | 별색 공정가 |
| 6 | **조각수** (판당 개수) | `bundle_qtys`(EA) + 공정 param | `counter-input`/`select-box` | 조각수 종속 단가 |
| 7 | **수량** | products(min/max/incr) | `counter-input` | × 수량, − 구간할인 |
| → | **견적 = 가격표[형상×사이즈] 격자 단가(코팅·자재·조각수 종속) × 수량 − 구간할인** | `t_prd_product_prices` + `t_dsc_*` | `summary` | ④ 가격 사슬 |

**가격 소스 확정:** 스티커 가격은 **인쇄상품 가격표 엑셀(스티커 7블록 + 합판도무송스티커 시트)**에 존재 — 형상×사이즈 격자 + 코팅별/자재별 단가(코팅이 가격컬럼을 가름). round-2 부분 적재(④ 상품군 공식 바인딩 PARTIAL 4/16, gap-board §66). 미적재 분은 DIM-UNLOADED.

> **2축 도출 적용(셀 내부):** "코팅" → ①BOM축: 공정(Q9★, PROC_000013) · ②판매축: 코팅별 단가=가격격자 분기 + option. "형상" → ①size(칼틀=물리, Q7★) · ②선택 option. "조각수" → ①공정 param + ②bundle_qty(둘 다, Q8★).

---

## D. 경쟁사 대조 (완제품 인쇄물 + 스티커 특화)

| 쟁점 | 경쟁사 패턴 | 후니 정합 | 출처 |
|------|-----------|----------|------|
| 표면처리(코팅·라미) | WowPress: awkjob(후가공)=공정 / Shopify: 재고무관 옵션 | ✅ 코팅=공정(Q9★·PROC_000013) | `accessory-option-research §3` |
| 형상/커팅(도무송) | WowPress: 형상=규격(sizeinfo)에 융합·새 축 안 만듦 | ✅ 칼틀 1:1=size 유지(Q7★) | 〃 §1·§3 |
| 무효조합(자재→후가공) | RedPrinting: material→pcs disable rule(저평량지→코팅 비활성) | constraints JSONLogic(enumerate 금지) | 〃 §1.1-4 |
| 조각수(판당 EA) | 묶음=수량축(Lasso 조성동일+수량=variant) | bundle_qty + 공정 param(GAP-PARAM) | 〃 §4 |
| 개인화(각인) | Shopify: line item property | 스티커 무관(업로드/에디터) | 〃 §6 GAP-1 |

→ **후니 그릇이 경쟁사 표현력 흡수.** 스티커 특화 = ①커팅(반칼/완칼/스티커완칼=별 공정) ②조각수(판당 EA)는 **공정 param GAP(OM-7)**이 유일한 구조 빈틈(각인 GAP-1은 스티커 무관).

---

## E. 현재 고려 여부 + GAP (사슬 끊긴 곳)

> **[보정] 전역 라이브 실측(`grid-matrix §1.2`)과 분리 — 아래 ③④는 *스티커 상품군*의 충족 상태이지 전역 행수 0이 아님.**
> - 전역 `option_items` **25행**(`option_groups` 7 — 프리미엄엽서 7 + 일반현수막 18) · `comp_prices` **3,481행**(스티커 STK_PRINT/COAT 등 단가행 실재) · `product_prices` 0 · `price_formulas` 63 바인딩.
> - 스티커 ③ CPQ = **스티커 상품군 옵션 미바인딩**(전역 25행에 스티커 분 없음 = 상품군 단위 0). ④ "PARTIAL 4/16" = **스티커 상품별 공식 바인딩 충족률**(전역 단가행은 광범위 적재).

| 레이어 | 스티커 상태 | GAP/조치 |
|--------|------|---------|
| ①골격 | ✅ 적재 | 단 카테고리 root 오연결(C-ST-02)·MES NULL(C-ST-08)·**prd_typ=.04 오모델(A섹션)** |
| ②차원그릇 | 🟡 부분 | 코팅 자재 오적재(C-ST-04)·자재유형 종이↔스티커 혼재(C-ST-09)·063 화이트 누락(C-ST-07) |
| **③선택(CPQ)** | ❌ **스티커 상품군 미바인딩** | option_groups→options→option_items 적재(별색·조각수·커팅, gap-board §40) — **스티커 사슬 끊긴 핵심.** (전역 25행은 타 상품군; 스티커엔 없음) |
| **④가격** | 🟡 PARTIAL 4/16 | 가격표 스티커 7블록·합판도무송 잔여 공식 바인딩(DIM-UNLOADED, gap-board §66). comp_prices 단가행은 전역 실재. |

**잔존 컨펌(인간 결정·correction-manifest §4·mapping-final CONFIRM-ST-A~D):**
- 🔴 **Q-ST-A [HIGH·CONFLICT-1] 코팅=공정(Q9★) vs 라이브=자재(8상품)** — 가격표 비코팅/무광/유광 3컬럼(코팅별 단가). (a) PROC_000013 공정 전환+비코팅 자재 정정+코팅 공정 단가를 가격엔진 (b) 라이브 자재 유지(round-11 입장·가격모델 단순). **BATCH-3은 "스티커 코팅=출력소재 자재 유지"로 확정**되어 (b) 쪽이나, Q9★ 원칙(코팅=공정)과의 CONFLICT는 가격 반영·적재 교정 차원에서 미해소.
- 🔴 **Q-ST-B 조각수 적재 형태(Q8 미실현·OM-7)** — bundle_qty + 공정 param 둘 다. `ref_param_json` 미구현 선결 → ddl-proposer.
- 🔴 **Q-ST-C 규격형 058~062 형상 저장처(OM-7 실증)** — 형상이 size·공정·product 어디에도 없음. (a)PROC_000054 교체+param (b)siz_nm 인코딩 통일 (c)현행. **합판도무송(칼틀=size)과 규격형(자유형상)의 모델 일관성.**
- 🟡 Q-ST-D 인쇄방식 root 공정 명시 · Q-ST-E 스티커팩(065) 세트 · Q-ST-MES MES 정책 · **Q-ST-TYP prd_typ=.04 오모델 정정 정책**(생산형태 칸 vs editor_yn 분리).

> **횡단 연결 — BATCH 원칙 수렴 여부(스티커 시트 한정):**
> - **형상=칼틀 size 유지(Q7★)** = `grid-matrix §2 사이즈`·`§2.1 사이즈 3갈래`(완제품=옵션/칼틀)에서 **도출됨** ✅. round-11 "형상 size 흡수=오모델 의심(G-SK-2)"은 **반증·CORRECT 확정**(C-ST-03). → **케이스 컨펌이 원칙으로 수렴(round-15 목표 입증).**
> - **코팅=공정(Q9★)** = `grid-matrix §2 후가공`·`§397 박/코팅=공정`에서 **도출됨** ✅. 단 스티커 라이브는 코팅을 자재로 적재(BATCH-3 = "스티커 코팅=출력소재 자재 유지" 확정) = **원칙 vs 라이브 현실 CONFLICT 잔존**(원칙은 수렴, 적재 교정·가격 반영은 인간 결정).
> - **조각수=bundle+param(Q8★)** = `grid-matrix §2 수량/묶음`+공정 param. **OM-7(공정 param 미구현)이 수렴의 유일 차단** — 규격형 형상(Q-ST-C)과 함께 ddl-proposer 선결.

---

## 한 줄 현황

**확대 #1 보정 GO 대기:** 스티커를 A(성격=**도메인 완제품 / 라이브 prd_typ=.04 오모델**·인쇄방식 5분기·16상품·쉬운 라벨 열)·B(그릇 10종)·C(선택→견적 7단계·가격=인쇄상품 가격표 형상×사이즈 격자)·D(경쟁사 흡수·커팅/조각수 특화)·E(③스티커 CPQ 미바인딩·④가격 4/16·Q-ST-A~E). **형상=size(Q7)·코팅=공정(Q9)이 grid-matrix §2 원칙으로 수렴**(G-SK-2 반증), CONFLICT-1(코팅 라이브 자재=BATCH-3 확정)·OM-7(조각수/형상 param)·prd_typ 오모델만 잔존. **전역 라이브는 option_items 25·comp_prices 3,481 실재(스티커 상품군엔 미바인딩) — '라이브 0' 아님.** **DB 미적재.**
