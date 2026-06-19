# M-gate Verdict — PO (포맥스·폼보드·등신대·피켓) 카테고리

> 후니 RP-Meta 하네스 Phase 6 산출 (rpm-validator). PO = 13번째 카테고리 종단.
> 생성자(reverse/architect/gap) 주장 **비신뢰** — 라이브 information_schema 읽기전용 SELECT 직접 재실측 + 산출물 file:line 교차 대조.
> 라이브 재실측 = 2026-06-20 read-only psql (`.env.local RAILWAY_DB_*`·SELECT/information_schema only·파괴적 쓰기 0).
> **종합 = M1~M6 전건 GO. distinct 0 비준·제작방식=#12/자립 부결 확인·거치대 독립SKU 그릇 실재·deepcheck 무단채택 0.**

---

## 게이트별 판정 요약

| 게이트 | 판정 | 핵심 근거 |
|--------|------|-----------|
| **M1 추출 충실성** | **GO** | PO reverse 원자 전부 `[live:SSR-legacy]` 출처 명시·날조 0. 7상품 카탈로그·코팅 PROC 라이브 정합 |
| **M2 메타모델 정합** | **GO** | PO-1~4 17축 무오버피팅 귀속·관계 무모순(NC/PH/AC/ST 부결 선례 일관) |
| **M3 distinct 타당성** | **GO** | 제작방식=#12 부결·자립=형상#17+부속물#8 부결 양방향 HARD 기준 정당. distinct 0 비준 |
| **M4 갭 판정 정확** | **GO** | PASS 2·WEAK/분산 2 라이브 재실측 5건 전건 일치(addons.tmpl_cd·PRD_000016 5SKU·nonspec_*·코팅 PROC·print_method 0건) |
| **M5 vessel 건전성** | **GO** | PO 신규 그릇 0·V-11/V-12 불변·deepcheck 14후보(signs.com) 무단채택 0 |
| **M6 생성-검증 독립성** | **GO** | self-approve 0·핵심 주장 재유도·dodge-hunt 4건 전부 방어됨 |

---

## M1 — 추출 충실성 (GO)

**검증:** PO reverse(`categories/PO/reverse.md`)의 원자가 출처와 일치하고 날조 0인가.

- **출처 표기 규율 준수** — reverse:11 `[live:SSR-legacy]` = 2026-06-20 라이브 GET `https://www.redprinting.co.kr/ko/product/item/PO/{code}`. 7상품 전부 레거시 jQuery SSR 렌더(`real_item`/`real_price`). 캡처 파일=`/tmp/po_{code}.html`(휘발·재현 가능)로 정직 표기. SSR 완전노출이라 unobserved 거의 없음 명시(reverse:14).
- **핵심 원자 라이브 정합** — reverse:62-63 타일링 `TIL_NON/HGH/WDT`, reverse:54 모양재단 `CUT_ZUN_ZDFRM`, reverse:55-56 거치대 `CDL_DFT`·와이어 `WIR_DFT/MTR`. 합지 코팅 가용성 캐스케이드(reverse:77 `COT_DFT` HAP=True/PRT=False)는 라이브 `PROC_000013 코팅/014 유광/015 무광` 실재로 후가공 행 정합 확인(M4-e 재실측).
- **캐스케이드/토글 SSR 노출 실측** — reverse:58 `opt_use_yn('CDL_DFT')` 선택형 부자재 토글·`sub_opt2_tr`·700/1200/1500mm select. reverse:60 등신대거치대 별 상품(`GS/GSSBMTL/detail/54`) 카탈로그 존재. 피켓 거치대/와이어 부재(reverse:59 `cdl거치대=False·와이어=False`)도 명시 실측.
- **미관측 정직 표기** — reverse:183 real_price 가격엔진 실제 계산(number4 배수 의미·면적단가)=huni-widget 가격역공학 영역·이번 미확보로 `unobserved` 표기. PO-3가 이를 그대로 회부(reverse:171-173).

**판정 = GO.** SSR 캡처가 휘발이라 동일 GET 재현은 본 게이트 범위 외(라이브 GET=생성자 영역)이나, ① 출처 라벨 규율 준수 ② 핵심 원자(코팅 PROC·거치대 SKU·타일링)가 라이브 스키마/카탈로그와 정합 ③ unobserved 정직 분리. **날조/unsourced fragment·unobserved를 fact로 둔갑 0.**

---

## M2 — 메타모델 정합 (GO)

**검증:** PO-1~4가 17축에 오버피팅 0으로 귀속되고 관계 무모순인가.

- **PO-1 제작방식 = 3축 분산 귀속(오버피팅 아님)** — discovered-axes:840·_resolved-fragments PO. 제작방식(합지/직접출력)=인쇄방식레시피#12(D-7 라미 게이팅) + 자재#1 검정 variant + 공정#2 코팅 캐스케이드로 분해. 단일 상품 전용을 위한 신축 강요 0 — NC item_gbn(11군)·PR P-7·CL clothes2025 discriminator와 동형으로 일반화(명제 #19 "분기 discriminator는 축 아님").
- **PO-2 거치대 = 부속물#8 귀속** — discovered-axes:841. add-on(독립 부자재 SKU 참조). BN 아일렛(D-1)·AC 받침·PD 다리/받침 횡단 동형. 단일 카테고리 전용 슬롯 아님.
- **PO-3/PO-4 = 기존 #10/#11/#13 경계** — discovered-axes:842-843. number4=수량#10/가격#11 경계, 사이즈 직접입력=사이즈#13 면적 연속차원(BN/실사/OT 동형).
- **관계 무모순** — 제작방식이 #12(게이팅 lifecycle)·#1(자재 variant)·#2(코팅 공정)·#5(제약 캐스케이드)에 분산되되 FK/composition 충돌 없음. 거치대 add-on→template 참조(부속물#8)와 형상#17(모양재단)이 직교(자립=형상 컷 + 거치대 부속물 조합·discovered-axes:861). 모순 FK/composition 미발견.

**판정 = GO.** 각 fragment가 복수 축에 증거 기반 귀속되며 어떤 축도 PO 단일 상품을 위해 강제 신설되지 않음. 13군 누적 일관(PR·CL·AC·PD·PH·FS·NC·OT 패턴 반복).

---

## M3 — distinct 타당성 (핵심·GO)

**검증:** ★제작방식/자립 #18 부결이 옳은가. 과소강등(distinct를 facet으로 숨김) 적대.

### (가) 제작방식(합지/직접출력) #18 부결 — 정당

승격 HARD 기준 = ① 전용 슬롯 라이브 실재 + ② 후니 KB 무왜곡 흡수 불가(KB 결함 명시) **둘 다** 충족 (ST 형상#17 승격 기준).

- **① 전용 슬롯 = 불충족(라이브 재실측 확정)** — 한 상품 내 "제작방식 select" 부재(reverse:38·discovered-axes:852). POMXPRT(직접출력)·POMXHAP(합지)는 별 pdtCode 상품이고, 차이는 paper select 값(검정 variant)·코팅 옵션아이콘 활성/비활성·상품명 "파인아트"로 인코딩 = 새 스키마 축 0. **라이브 M4-d 재실측: `print_method/prod_method/construct/mount` 전용 컬럼 전역 0건** — 제작방식 전용 그릇 부재 직접 입증.
- **② KB 결함 = 불충족** — 제작방식=인쇄방식레시피#12로 이미 1급 모델링(`07_domain/process-recipe-tree.md` PROC_000002~6 최상위 레시피 축·게이팅). 합지/라미는 그 공정 멤버. "제작방식 어느 축에도 못 담음" 같은 KB 결함 명시 없음 — ST 형상 G-SK-2와 정반대.
- → **둘 다 불충족 = 부결.** NC 인쇄방식(옵셋 vs 디지털·11군) #18 부결과 동일 구조.

### (나) 자립구조(등신대 거치대/피켓) #18 부결 — 정당

- **① 전용 슬롯 = OBSERVED(충족)** — 거치대 `CDL_DFT` 전용 부자재 토글 슬롯 SSR 실측(reverse:55-56). ST 형상 shape_info처럼 전용 슬롯 존재. **단 이것만으로는 부족(ST는 ②도 충족했음).**
- **② KB 결함 = 불충족(결정적)** — 자립=형상#17(모양재단 CUT_ZUN_ZDFRM) + 부속물#8(거치대 add-on→독립 SKU 참조)으로 무왜곡 분해. 후니 KB `entity-semantic-model.md:30` addl_product "완제 부속: 거치대·우드봉·볼체인"이 거치대를 정확히 1급 모델링. **거치대 add-on→독립 template SKU 참조 그릇이 라이브 실재(M4-a/b 재실측: addons.tmpl_cd FK + PRD_000016 5 SKU 다중귀속)** = "별 자립구조 축 없으면 못 담음" 결함이 부존재함을 라이브로 확정. "형상 어느 축에도 없음"(ST) 같은 결함 명시 없음.
- → **②불충족 = 부결.** PH 거치(탁상용/벽걸이·9군) #18 부결과 동일 구조이되, **PO는 SSR 완전노출로 1회 GET 관측 기반 부결**(PH는 §0.5 client-render 재캡처 필요했음).

### dodge-hunt (과소강등 적대)

- **"거치대가 전용 슬롯 OBSERVED인데 왜 부결?"** — 전용 슬롯 존재(①충족)만으로 승격 불가가 HARD 기준의 핵심. ST 형상은 ①+② 둘 다 충족이라 승격. 거치대는 ②(KB 무왜곡 흡수 불가)가 불충족 — 부속물#8이 독립 SKU 참조까지 무손실 담음(addons.tmpl_cd 라이브 실데이터). **양방향 정직(① 충족도 ②로 부결) = 과소강등 아님.**
- **"제작방식이 코팅을 게이팅하니 governing 축 아닌가?"** — governing은 #12(인쇄방식레시피)의 lifecycle(P-7 자재풀 게이팅·NC 옵셋 게이팅 동형). 게이팅 능력이 새 축을 강제하지 않음(이미 #12에 등재된 능력의 PO 인스턴스).

**판정 = GO. distinct 0 비준.** 제작방식=#12 부결·자립=형상#17+부속물#8 부결 둘 다 양방향 HARD 기준으로 정당. 미스분류 facet 0·과소강등 0. 명백한 missed axis 증거도 없음(거치대 독립 SKU 참조까지 기존 그릇이 담음).

---

## M4 — 갭 판정 정확 (GO·라이브 재실측 5건 전건 일치)

**검증:** PASS/WEAK/GAP가 후니 라이브 information_schema와 일치하고 dbmap 정합인가. 비존재 컬럼 인용·실재 그릇 GAP 오판 적발.

| # | 산출물 주장 (file:line) | 독립 재측정 (2026-06-20 psql) | 일치 |
|---|------------------------|------------------------------|------|
| 1 | `t_prd_product_addons.tmpl_cd`(addon→독립 SKU FK)·PO-2 거치대 독립 SKU PASS (gap-matrix:846·852) | `t_prd_product_addons` 컬럼 = prd_cd·disp_seq·note·reg_dt·upd_dt·**tmpl_cd**. FK `fk_prd_product_addons_tmpl_cd FOREIGN KEY (tmpl_cd) REFERENCES t_prd_templates(tmpl_cd)` 실재. **addon_prd_cd 부재**(gap-matrix:854 "현 컬럼=tmpl_cd 단일·addon_prd_cd 부재" 정확) | ✅ |
| 2 | PRD_000016 5 SKU 다중귀속(disp_seq 1~5)·PO-2 근거 (gap-matrix:846·852) | `SELECT … WHERE prd_cd='PRD_000016'` = TMPL-000005/006/009/010/011 disp_seq 1~5 (정확히 5행). multi-attach(count≥2) 유일 prd_cd | ✅ |
| 3 | `nonspec_width/height_min/max/incr`·PO-4 면적 연속차원 (gap-matrix:838) | `t_prd_products`에 nonspec_yn·nonspec_width_min/max/incr·nonspec_height_min/max/incr 7컬럼 실재 | ✅ |
| 4 | 합지 코팅 `PROC_000013~015`·제작방식=공정#2 분산 (gap-matrix:835·845) | `PROC_000013 코팅·PROC_000014 유광·PROC_000015 무광` 실재 | ✅ |
| 5 | `print_method/pool/item_gbn` 전역 0건·제작방식=#12 게이팅 GAP·전용그릇 부재 (gap-matrix:839·845) | `print_method/prod_method/construct/mount` 컬럼 전역 검색 **0건** | ✅ |
| 보강 | `t_siz_sizes` work/cut 2치수·PO-4 보강 (gap-matrix:837) | `t_siz_sizes`에 work_width/work_height/cut_width/cut_height 실재 | ✅ |

- **양면 검증** — PASS 측(거치대 독립 SKU·면적 연속차원·코팅 공정)은 그릇 실재 확인, GAP 측(제작방식 게이팅 lifecycle #12)은 전용 컬럼 0건 확인. 비존재 컬럼 인용 0·실재 그릇을 GAP으로 오판 0.
- **dbmap 정합** — PO-4 면적 연속차원=`dbmap-area-matrix-wh-dimension`(siz_width/siz_height 구간)·거치대=`dbmap-acrylic-price-chain-link`(완제SKU=addons/templates) 인용 정합.

**판정 = GO.** PASS 2·WEAK/분산 2·신규 GAP 0 모두 라이브 재실측과 일치. PO가 신규 갭을 만들지 않고 기존 #1/#2/#8/#10/#11/#12/#13 판정을 재확인(중복 계상 안 함).

---

## M5 — vessel 건전성 (GO)

**검증:** PO 신규 그릇 0·기존 V-항목 흡수·search-before-mint·deepcheck 무단채택 0.

- **PO 신규 vessel-gap = 0** — vessel-needs:322·gap-matrix:871. PO facet 4항은 기존 V-2(제작방식=후가공 게이팅 lifecycle)·V-3(검정 variant 분해축)·V-7(real_price 면적계수)에 흡수. PASS 2건(거치대 독립 SKU·면적 연속차원)은 그릇 보유로 vessel 조치 0.
- **V-11/V-12 불변** — vessel-needs:16 "V-11·V-12 신규 mint 불변(누적 신규 테이블 mint 2건 유지)". PO가 추가 mint 0. search-before-mint 통과(기존 addons.tmpl_cd·nonspec_*·PROC가 PO 차원 흡수).
- **★deepcheck 14후보 무단채택 0(핵심)** — deepcheck DC-PO-1~14(타공/라운딩/이젤백/벽부착/기능성코팅/소재세분화/강성grade/내후성/construction_route/물류fragility/최대크기/조각금지/타공제약/등신대안정성). 출처 전부 signs.com(미국 사이니지)+Wikipedia·RP/후니 미관측(deepcheck:10·63). **vessel-needs.md·discovered-axes.md 검색 결과 DC-PO 후보가 vessel V-항목·distinct 승급에 미등장 = 무단 채택 0.** deepcheck 자체가 "어떤 후보도 채택하지 않음(가설 라우팅만)"(deepcheck:73) 명시·검증 게이트 강제. DC-PO-9(construction_route)가 최강 #18 적대였으나 codex 스스로 "고객 주문축 아님" 자인(deepcheck:42·56) → PO-1 #12 부결과 합치.

**판정 = GO.** PO 신규 그릇 0·V-11/V-12 불변·convention-fit(t_* 패턴 유지)·duplicate-mint 0·deepcheck signs.com 14후보 무단 채택 0.

---

## M6 — 생성-검증 독립성 (GO)

**검증:** self-approve 0·핵심 주장 재유도(echo 아님)·dodge-hunt.

- **재유도(echo 아님)** — 본 게이트의 M4 5건 전부 생성자 주장을 가설로 두고 psql로 독립 재측정해 일치 확인(addons 컬럼·PRD_000016 5행·nonspec 7컬럼·코팅 PROC·print_method 0건). 생성자 단언 복창 아님.
- **self-approve 0** — 생성 lane(reverse/architect/gap)과 검증 lane(validator) 분리. reverse §6·PO-1/PO-2 1차 예측 부결을 architect가 적대 비준하고, 본 validator가 라이브로 재확인(3단 독립).

**dodge-hunt — PO 최리스크 4건 깨기 시도:**

1. **"제작방식 #18 부결" 깨기** — 제작방식이 코팅을 게이팅(governing)하니 별 축 아닌가? → 게이팅은 #12 lifecycle 능력(P-7/NC 동형). 라이브 `print_method` 전용 컬럼 0건으로 전용 그릇 부재 확정 → 부결 정당. **방어됨.**
2. **"자립 부결" 깨기** — 거치대 전용 슬롯 OBSERVED인데 부결이 도피 아닌가? → ① 충족만으로는 승격 불가(HARD 기준 ②도 필요). addons.tmpl_cd + PRD_000016 5 SKU 다중귀속 라이브 실데이터로 부속물#8이 독립 SKU 참조까지 무왜곡 담음 입증(②불충족) → 부결 정당. **방어됨.**
3. **"거치대 독립SKU PASS" 깨기** — 옵션값 복제를 PASS로 오판한 것 아닌가? → addon_prd_cd 부재·tmpl_cd→t_prd_templates FK 실재로 add-on이 template SKU 참조(옵션 인라인 복제 아님) 확정. PRD_000016 5 SKU disp_seq 다중귀속 실데이터 = 정규화 PASS. **방어됨.**
4. **"distinct 0" 깨기** — missed axis 숨김 아닌가? → 가장 강한 후보(deepcheck DC-PO-9 construction_route)도 codex 독립 동의로 #18 부결. RP 라이브 SSR 완전노출에서 제작방식/자립 외 distinct 전용 슬롯 미관측. **방어됨.**

**판정 = GO.** 핵심 사실 재유도·self-approve 0·dodge-hunt 4건 전부 방어.

---

## 종합 판정

| 게이트 | 판정 |
|--------|------|
| M1 추출 충실성 | **GO** |
| M2 메타모델 정합 | **GO** |
| M3 distinct 타당성 | **GO (distinct 0 비준)** |
| M4 갭 판정 정확 | **GO (라이브 5건 전건 일치)** |
| M5 vessel 건전성 | **GO (deepcheck 무단채택 0)** |
| M6 생성-검증 독립성 | **GO** |

**PO 카테고리 = M1~M6 전건 GO. 결함 0건 → `_defects.md` 미발생.**

- **distinct 0 비준** — 13번째 카테고리 17축 재포화. 기재마운팅/자립구조 #18 부결.
- **제작방식 = #12(인쇄방식레시피) 부결 확인** — 전용 슬롯 부재(`print_method` 0건 라이브 확정) + KB 결함 부재 둘 다 불충족.
- **자립구조 = 형상#17+부속물#8 부결 확인** — 거치대 전용 슬롯 OBSERVED(①충족)이나 KB 무왜곡 흡수(②불충족)로 부결. PH/NC/OT 부결과 동일 구조.
- **거치대 독립SKU 그릇 실재** — `t_prd_product_addons.tmpl_cd` FK→t_prd_templates 실재 + PRD_000016 5 SKU 다중귀속 실데이터.
- **라이브 재실측 일치 = 6/6건** (addons.tmpl_cd·PRD_000016 5SKU·nonspec_* 7컬럼·코팅 PROC_000013~015·print_method 0건·siz work/cut 2치수).
- **deepcheck 무단채택 = 0** (signs.com 14후보 전부 가설 라우팅·vessel/distinct 미등재).

**이 판정이 Phase 6.5 codex 교차검증 reconcile 베이스라인이다(codex 비노출).**

---

*라이브 재실측 = 2026-06-20 read-only psql (`.env.local RAILWAY_DB_*`·SELECT/information_schema only). 파괴적 쓰기 0·자격증명 비노출. 생성자 주장 비신뢰·전건 독립 재측정.*
