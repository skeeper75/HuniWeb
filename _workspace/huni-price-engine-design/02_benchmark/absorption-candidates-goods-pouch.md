# 후니 흡수 후보 — 굿즈/파우치 가격계산 (완제 SKU·본체 소재·variant 종단)

> `hpe-benchmark-analyst` 산출 — 디지털인쇄(파일럿)·아크릴(면적매트릭스)·실사현수막(면적+거치)·문구제본(다부품 합성)·책자에 이어 **굿즈/파우치 종단**(파우치·키링·텀블러·머그·에코백·노트·코스터·마스크끈·장패드 등·후니 최대·최복잡 결함영역 103+상품).
> **목적[HARD]**: 와우프레스·레드프린팅이 굿즈/파우치류의 가격을 *어떻게 계산하는가*(① 완제 SKU 개당단가 vs 부품 조합 ② 본체 소재/색/형상/구수/용량의 가격 영향 ③ 옵션 캐스케이드)를 역공학해 후니 굿즈/세트상품 설계에 흡수할 메커니즘을 추출.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수, naming/codes(`tmpl_price`·`tiered_price`·`DIR_MTR`·`WRK_MTR`·`PCS_COD`·`paperinfo`·`papergroup`·`THO_CUT`·`PDT_WRK` 등) 후니 유입 금지, 권위 엑셀(상품마스터260610·가격표260527) 덮어쓰기 금지. 후니가 이미 담으면 흡수 불요(overfit 경계).
> **5종단 누적 결론 일관성 검증[HARD]**: 신규 가격축 0·배선-gap·후니 그릇 우월/동형이 5종단 결론. 굿즈가 진짜 신규 축을 요구하는지 독립 판단 — **결론: 굿즈도 신규 가격축 0이나, "완제 SKU 개당단가형(고정가형)"이 가격공식 클래스로 추가 강조되고, 후니 굿즈 가격사슬은 거의 전무(설계 신규 대상)다.**

## 출처 표기

- `[red:GS]` = `_workspace/huni-rpmeta/categories/GS/reverse.md`(2026-06-17 rpm 역공학 — GS 136상품 중 대표 12 + 코스터 6소재군·`tmpl_price`/`vTmpl_price`/`tiered_price` 3엔진·`DIR_MTR`/`WRK_MTR` 본체=공정성 항목·variant 3채널·자재 usage 다중슬롯). reqBody/result = huni-widget s3 캡처 `s3_rp_GS*.json` priceCalls 실측.
- `[red:GSTGMIC]` = `raw/widget_monitor/red_captures/v2_GSTGMIC_capture.json`(마이크 네임택·**유일 `tiered_price` 샘플**·S=6000/L=7000·인쇄가 주체·자재단가 필드·THO_CUT 칼틀 4종·완칼 S/L). + `cascade_captures/GSTGMIC_{cascade,constraints}.json`.
- `[wow:goods]` = `_workspace/huni-dbmap/10_configurator/wowpress-option-model.md`(WowPress `docs/wowpress/` 326상품·굿즈/다꾸 카테고리·`raw.prod_info` 7축 권위·40146/40185/40479/40072/40274/40483 인용). + `raw/widget_monitor/wow_capture/fresh_goods_capture.json`(40520 라이브 timeout=옵션 미캡처).
- `[huni:goods-map]` = `_workspace/huni-dbmap/10_configurator/huni-goods-option-mapping.md`(WowPress 6축↔후니 라이브 테이블 매핑·오염 재분류·compose/split 입도·GAP-SHAPE/COUNT/OPT).
- `[huni:mat]` = `_workspace/huni-dbmap/32_axis-staged-load/04_live-remeasure-260616.md`·`_corrected_xlsx/goods-pouch-material-bom-check.md`(④자재 .09 파우치 74행 오염 CONFIRMED·본체 소재 컬럼 부재·소재가 상품명에만·레더23/캔버스9/린넨5/메쉬4 명확분 COMMIT·타이벡/신규소재 BLOCKED).
- `[huni:live]` = 라이브 `t_*` 실측(2026-06-20·읽기전용) — **굿즈/파우치 30상품 전수 `t_prd_product_price_formulas` 바인딩 0**(아크릴키링 1건 제외)·`t_prd_product_materials` 행은 존재하나 오염·가격사슬 전무.
- `unobserved` = 미관측(날조 금지).

---

## 0. 경쟁사 굿즈/파우치 가격화 방식 — 한눈 요약

| 항목 | 레드프린팅(RedPrinting) | 와우프레스(WowPress) | 후니 `t_prc_*`/`t_prd_*` 대응 |
|------|------------------------|----------------------|---------------------|
| 가격엔진 | **3종 공존**: `tmpl_price`(완제 SKU 개당단가)·`vTmpl_price`(variant SKU)·`tiered_price`(수량구간 단가·자재단가 필드) `[red:GS §0.1]` | **정적표 없음** — 옵션코드 묶음 → `/std/prod/jobcost` 동적 견적(비선형·합판효율) `[wow:goods Q5]` | `t_prc_price_formulas`(`frm_typ_cd`)·완제 굿즈 = **고정가형/개당단가형** + 합산형 |
| ★본체(완제품) 표현 | **본체 = PCS_INFO의 첫 항목**(`DIR_MTR` 직접인쇄 부자재 / `WRK_MTR` 부자재작업)·소재/색/용량이 `PCS_DTL_NME`(완제 SKU 라벨)에 융합·이게 PRICE 주체 `[red:GS §0.2]` | **본체 블랭크 = `paperinfo`(재질)** — "물리적 블랭크(소재+색+질감)" 합성 SKU `[wow:goods Q2]` | 본체 소재 = `t_prd_product_materials`(`mat_cd`)·★**후니 본체 소재 컬럼 부재·소재가 상품명에만**(`[huni:mat]` GPM 진단·경쟁사와 동형 결함) |
| ★본체색 | DTL 코드 = 색 variant(GSMLSLC `MLS01`→"핑크"·소재는 MTRL_CD) `[red:GS §3]` | **`paperinfo.papername`(재질행 합성)** — 본체색=재질, 별 축 아님(40479 캔버스 색6·40072 NCR 색별) `[wow:goods Q2]` | **재질행 합성**(파우치 블랙/투명 = MAT 합성행·이미 정답 패턴) `[huni:goods-map §2.6]` |
| ★형상 | 완칼도무송 DTL = 칼틀 형상(GSNTSTA `NT001`하트/`NT002`여권·THO_CUT)·형상↔사이즈 1:1 캐스케이드 `[red:GS §5]` | **`sizeinfo.sizename`(규격 융합)** — 형상+치수 한 행(40185 `원형32`/`하트57x51`) `[wow:goods Q2]` | **규격축 융합**(siz_nm에 형상·★비치수=GAP-SHAPE) `[huni:goods-map §2.1]` |
| ★사이즈/방향 | CUT_WDT/HGH 프리셋 variant(GSNTSPR 182×257/132×182·같은 MTRL)·기종×방향 복합(GSPUFBC 13인치 가로/세로) `[red:GS §0.3③·§7]` | **`sizeinfo`(규격 1행 합성)** — 사이즈+방향(40479 에코백 S/M/L) `[wow:goods Q2]` | **규격행 합성**(가로형 L 1 siz) `[huni:goods-map §2.5]` |
| ★구수/개수 | ATTB 파라미터(GSNTSPR `ROU_DFT ATTB=4` 귀돌이 반경·위치별 4슬롯) `[red:GS §0.3②·§4]` | **`awkjobinfo.namestep2`**(2단계 개수형: "10개"~"20개") `[wow:goods Q2]` | 개수형 공정·★**개수 N 보존처 부재=GAP-COUNT**(ref_param_json 미구현) `[huni:goods-map §5]` |
| ★용량 | DTL 융합(GSPDLNG "장패드 4T"·GSTBMWM "20oz") `[red:GS §1·3]` | 머그 미취급(구조상 규격 후보) `[wow:goods Q2]` | 비치수 siz=GAP-SHAPE(11온스·350ml) `[huni:goods-map §2.3]` |
| 자재 usage 다중슬롯 | **한 굿즈에 본체+내지+링+스펀지 동시**(GSNTSPR `MTRL_CD`표지+`INN_DFT`내지+`RIN_DFT`링) `[red:GS §0.4]` | `coverinfo` cover-스코프(굿즈는 통합 1개) `[wow:goods §0]` | `t_prd_product_materials` + `usage_cd`(USAGE) — 동형 보유 `[huni:goods-map §1]` |
| 본체 조립/봉제 | **`PDT_WRK`(제품가공)** — 평면 인쇄물→입체 파우치 봉제/조립(GSPUFBC `PUBOK`·GSTGMIC `PKT01`)·지퍼=부자재+공정 BUNDLE(`FLX_ZIP`) `[red:GS §7·8]` | `optioninfo`(포장/가공 flat) | 조립 공정 = `t_prd_product_processes`·지퍼/끈=자재+공정 BUNDLE(`usage_cd`) `[huni:goods-map]` |
| 인쇄 가격기여 | 굿즈 대부분 PRT_DFT=0(개당단가에 포함)·★대형(GSPDLNG 장패드 인쇄 5000)·tiered(GSTGMIC 인쇄가 주체) `[red:GS §3·8]` | 동적 견적(인쇄방식 prsjobinfo) | 인쇄비 comp(합산형) or 개당단가 baked-in |
| 포장 | `PAK_ETC`/`PAK_POL`(폴리백) — GSTBMWM 패키징 0·GSPDLNG 개별포장 1000(유료) `[red:GS §1·3·8]` | **`optioninfo`(포장 optlist·쉬링크/수축)** `[wow:goods Q1.7]` | ★**GAP-OPT**(포장/자유 옵션 그릇 부재·OPT_REF_DIM 7종에 없음) `[huni:goods-map §1]` |
| 수량 | 이중수량 ORD_CNT(디자인수)×PRN_CNT(인쇄수량)·개당단가×수량 `[red:GS §1·GSTGMIC]` | `ordqty`(택1/구간) + `ordcnt`(건수)·비선형 `[wow:goods Q1.1·Q5]` | 부수=수량구간(min_qty)·디자인수=주문라인·tiered=구간할인 t_dsc |

**한 줄 결론**: 두 경쟁사 모두 굿즈를 평면 인쇄물의 "본품+가산 합산형"과 **다른 패러다임 = "완제 SKU 개당단가(고정가형)"** 으로 계산한다. RedPrinting은 본체 굿즈를 **자재가 아니라 공정성 항목**(`DIR_MTR`/`WRK_MTR`)으로 모델링하고 소재/색/용량을 완제 SKU 라벨에 융합(개당단가가 PRICE 주체), WowPress는 본체 블랭크를 **`paperinfo`(재질 합성행)** 로 두고 동적 견적한다. ★**굿즈 가격 골격(완제 개당단가 + Σ유료옵션[인쇄/포장] + 조립공정 + 수량)은 후니 4단 엔진[고정가형/합산형 + 수량구간]이 표현력상 담을 수 있으나, 후니 굿즈는 가격사슬이 거의 전무**(`[huni:live]` 30상품 바인딩 0·아크릴키링 1건 제외). 즉 **vessel-gap 아닌 (a) 가격사슬 미설계 + (b) 본체 소재/색/형상/구수의 자재축 오염 정리**가 흡수 실질이다. 신규 가격축/테이블 신설 = 0건(rpmeta GS distinct 부결·WowPress "새 축 만들지 말고 6축 흡수" 규칙과 정합).

---

## 1. 흡수 후보 요약 보드 (C-GP1~C-GP9)

| ID | 흡수 후보 | 출처 | 후니 그릇 | 사다리 | 우선순위 | overfit 위험 | 답습 리스크 |
|----|----------|------|----------|--------|---------|------------|------------|
| **C-GP1** | 완제 굿즈 = 개당단가(고정가형) — 부품 합산 아님 | 레드 `tmpl_price` 개당단가(텀블러45000)·와우 동적견적 | `frm_typ_cd` 고정가형(`.06 완제품비` 동류)·use_dims=[opt_cd or siz_cd] | 공식 신설(가격사슬 전무) | **High** | 낮음(고정가형 기존) | 낮음 |
| **C-GP2** | 본체 소재 = 별 자재행(소재가 상품정체)·소재별 SKU 분리 | 레드 코스터 6소재=6 pdtCode·와우 paperinfo 합성 | `t_prd_product_materials`(`mat_cd`·★소재 컬럼 부재) | 데이터(오염 정리·본체소재 등록) | **High** | 낮음 | 낮음 |
| **C-GP3** | 본체색 = 재질행 합성 (split 금지) | 레드 DTL 색 variant·와우 papergroup 색6 | `t_prd_product_materials` 합성 mat_cd(파우치 이미 정답) | 데이터(합성행) | **High** | **낮음(과분할 금지)** | 낮음 |
| **C-GP4** | 형상 = 규격축 융합 (별 형상축 신설 금지) | 레드 THO_CUT 칼틀·와우 sizename 원형/하트 | `t_prd_product_sizes`(siz_nm 형상·★비치수=GAP-SHAPE) | 데이터/GAP | **High** | 낮음 | 낮음 |
| **C-GP5** | variant 3채널 (SKU코드 / ATTB파라미터 / 사이즈프리셋) | 레드 §0.3 3방식·GSTGMIC S/L 합일 variant | `siz_cd`(SKU) / option ATTB / siz 프리셋 — polymorphic ref | 배선/설계 | **Medium** | 중(채널 혼동 경계) | 중(naming 가드) |
| **C-GP6** | 본체 조립/봉제 = 별 공정(`PDT_WRK`)·지퍼/끈=자재+공정 BUNDLE | 레드 PUBOK/PKT01 조립·FLX_ZIP 지퍼 | `t_prd_product_processes` + usage_cd BUNDLE | 데이터/배선 | **Medium** | 낮음 | 중(naming 가드) |
| **C-GP7** | 구수/개수 = 개수형 공정 + 개수 N 파라미터 | 레드 ATTB=N·와우 namestep2 개수 | 개수형 공정 + ★개수 N 보존처 부재(GAP-COUNT) | GAP(ref_param_json) | **Medium** | 낮음 | 낮음 |
| **C-GP8** | 포장/각인/잉크색팩 = 자유 옵션 그릇 | 레드 PAK_ETC/PAK_POL·와우 optioninfo | ★대응 없음(GAP-OPT)·or bundle_qtys(N개팩) | GAP(ddl-proposer) | Medium | 중(발명 금지) | 낮음 |
| **C-GP9** | tiered_price = 수량구간 단가 (자재단가 동반) | 레드 GSTGMIC tiered(S6000/L7000) | `min_qty` 수량구간 + 구간할인 t_dsc | 데이터(이미 보유) | Low | 낮음 | 낮음 |

**신규 테이블(vessel) 신설 = 0건.** 후니가 자재(`materials`)·규격(`sizes`)·도수(`print_options`)·공정(`processes`)·묶음수(`bundle_qtys`)·세트(`sets`)·고정가형/합산형 공식·polymorphic 옵션레이어를 **이미 보유**. ★실질 흡수 = ① **굿즈 가격사슬 신규 설계**(완제 개당단가형 공식·`[huni:live]` 바인딩 0) + ② **본체 소재/색/형상/구수의 자재축 오염을 올바른 축으로 재분류**(`[huni:goods-map]`·`[huni:mat]`). 3 GAP(SHAPE 비치수·COUNT 개수보존·OPT 포장그릇)은 **vessel 신설 아니라 컬럼/코드행 사다리**(ddl-proposer·발명 금지). WowPress "새 축 만들지 말고 6 의미축 흡수" 규칙과 정합.

---

## C-GP1. 완제 굿즈 = 개당단가(고정가형) — 부품 합산 아님 ★ (우선순위 High·흡수 강·가격사슬 전무)

### 흡수 메커니즘
- **레드프린팅 `tmpl_price`** `[red:GS §0.1·1]`: 완제 굿즈는 `DIR_MTR`(부자재직접인쇄) 항목 하나가 PRICE 주체 — 텀블러 개당 45000·장패드 10000·마스크끈 2800. **소재/색/용량이 완제 SKU 라벨**("미르 와이드마우스 보틀 화이트 20oz")에 융합되고, 가격은 그 완제품의 **개당단가**다. 부품을 합산하지 않는다(책자=부품 합산과 결정적 차이).
- **와우프레스** `[wow:goods Q5]`: 정적표 없이 옵션코드 묶음을 동적 견적엔진에 던져 받는다(비선형·합판효율). 완제 굿즈 블랭크(`paperinfo`)가 본품가의 기반.

### 합성식 (관측)
```
완제 굿즈 가격 = 본체 개당단가(완제 SKU)            # 고정가형 — 면적·부품 합산 아님
            + (유료 인쇄비)                        # 대부분 0·대형/tiered만 가산
            + (유료 포장)                          # 선택·개당
            + (조립/봉제 공정)                       # PDT_WRK·일부 baked-in
            × 수량(부수)                            # 개당단가 × PRN_CNT
```

### 후니 매핑 (가격사슬 전무 — 설계 신규)
후니는 **고정가형 공식 그릇 보유**(아크릴 카라비너 `PRF_CARABINER_ACRYL`·`.06 완제품비`·use_dims=[opt_cd]·absorption-acrylic B07 동형). 굿즈 완제품 개당단가 = 고정가형 comp 1행(완제 SKU 또는 형상/사이즈별). **그러나 라이브 굿즈/파우치 30상품 `t_prd_product_price_formulas` 바인딩 0**(`[huni:live]`·아크릴키링 1건 제외) — **가격사슬 자체가 미설계**. 흡수 = 완제 개당단가형 공식 신규 설계(권위 가격표 260527 굿즈 시트 → 완제 단가 추출·`frm_cd`/`comp`/바인딩).

### 사다리 판정 (search-before-mint)
**신규 테이블 0·신규 공식/comp 설계 필요.** 고정가형(`.06 완제품비`)·합산형(`addtn_yn`)은 이미 존재. 가격사슬 부재가 data/설계 gap이지 vessel-gap 아님.

### trade-off
- 장점: 완제 굿즈를 개당단가로 정확 표현(텀블러/머그/키링 = 면적·부품 합산 아님). RedPrinting `tmpl_price`·고정가형 동형.
- 단점: **굿즈 가격사슬 전무가 진짜 병목** — 공식·comp·바인딩 전부 신규. 권위 가격표 굿즈 시트 단가 추출이 선결. ★**개당단가 × 수량의 prc_typ 정합**(개당단가가 "1개당"이면 ×수량 정당·"묶음 총액"이면 ÷min_qty 후 ×수량 — 디지털 ×qty 과청구·아크릴 .02 미확정과 동일 클래스). 추측 적재 금지.

### naming 유입 가드 [HARD]
`tmpl_price`/`vTmpl_price`/`DIR_MTR`/`PCS_COD`/`PCS_DTL_NME` 후니 유입 금지. 후니 `frm_cd`/`comp_cd`·고정가형 `.06` 컨벤션 번역.

---

## C-GP2. 본체 소재 = 별 자재행 (소재가 상품정체)·소재별 SKU 분리 ★ (우선순위 High·흡수 강·오염 정리)

### 흡수 메커니즘
- **레드프린팅 코스터 6소재군** `[red:GS §9]`: 같은 "코스터" 정체가 본체 소재별로 **6개 별도 pdtCode**(규조토 GSTTDTM·펠트 GSPLCST·코르크 GSTTCRK·종이 GSTTPAP·아크릴 GSTTACR·레더 GSTTREZ). 소재 선택 = 상품 선택 — **소재를 옵션이 아니라 별도 상품으로 분리**(소재가 본체정체·자재 관리축의 정점). 파우치도 6소재(코튼/레더/네오프렌…) `[red:GS §7]`.
- **와우프레스** `[wow:goods Q3]`: 본체 블랭크를 `paperinfo`(재질 2계층: papergroup 대표재질 → papername 항목)로 두되, 재질행이 "지종×코팅×색×포장유무" 합성 SKU(40185 핀버튼 `유포지(유광) 개별포장있음`). 머그 등은 미취급.

### 후니 매핑 (★본체 소재 컬럼 부재·소재가 상품명에만)
후니 본체 소재는 `t_prd_product_materials`(`mat_cd`·`usage_cd`)로 표현되나, ★**굿즈/파우치 본체 소재 확인 0개**(`[huni:mat]` GPM 진단 — 상품마스터에 소재 컬럼 부재·소재가 **상품명에만**·진짜 소재행 .05/.06은 실사/책자 고아). **RedPrinting 코스터 소재 융합·WowPress papername 합성과 정확히 동형 결함**. dbmap이 명확분 41상품(레더23·캔버스9·린넨5·메쉬4) 본체 자재 라이브 COMMIT·타이벡/신규소재(우드/규조토/코르크/벨벳/세라믹) BLOCKED(`[huni:mat]`).
- 흡수 = 본체 소재를 자재행으로 등록(코스터 소재별·파우치 소재별)·소재가 개당단가를 가름(코스터 소재마다 다른 단가·`tmpl_price` 추정).

### 사다리 판정 (search-before-mint)
**신규 테이블 0.** 자재 테이블+usage 보유. 흡수 = 본체 소재 데이터 등록(상품명에서 소재 추출·dbmap GPM 트랙)·신규 소재는 search-before-mint(우드/규조토 등 ddl-proposer 코드행). RedPrinting "소재=별 상품"인지 후니 "한 상품의 소재 옵션"인지는 **상품정체에 따름**(코스터=소재가 정체=별 상품 자연·파우치=한 상품 다소재 옵션도 가능·권위 상품마스터가 정답).

### trade-off
- 장점: 본체 소재가 개당단가·물리 정체를 정확히 표현(규조토 코스터 ≠ 코르크 코스터). 자재 오염(.09 색/형상/구수가 자재행) 정리.
- 단점: 본체 소재가 상품명에만 → 추출·등록 신규(dbmap GPM-4 오염 .09 link 제거 + 본체 선적재 선결). 신규 소재 채번(ddl-proposer).

### naming 유입 가드 [HARD]
`pdtCode`(GSTTDTM 등)·`paperinfo`/`papergroup`/`papername`·`MTRL_CD` 후니 유입 금지. 후니 `mat_cd`/`mat_nm`·`usage_cd` 번역.

---

## C-GP3. 본체색 = 재질행 합성 (split 금지) ★ (우선순위 High·흡수 강·과분할 금지)

### 흡수 메커니즘
- **레드프린팅** `[red:GS §0.3①·2·3]`: 본체색은 DTL 코드 variant(GSMLSLC `DIR_MTR/MLS01`→"핑크"·소재는 MTRL_CD=실리콘). 소재(MTRL_CD)와 색(DTL)이 분리 인코딩.
- **와우프레스** `[wow:goods Q2]`: ★**"색상"은 별 옵션이 아니라 `paperinfo`(재질)의 한 항목**(단, 인쇄 잉크색이 아니라 **본체 블랭크 색**) — 40479 에코백 `papergroup:캔버스` → 내추럴/블랙/핫핑크/네이비, 40072 NCR 색별. 즉 WowPress 재질 = "물리 블랭크(소재+색+질감)" 합성 SKU. **인쇄 면/방향(앞면/뒷면/단면)만 `colorinfo`(도수)**.

### 후니 매핑 (재질행 합성 — 파우치 이미 정답)
후니 ★**파우치 본체색은 이미 자재행 합성**(MAT_000061 파우치 root + 블랙/투명/멜란지/반투명/청보라/화이트 색별 자식·`[huni:goods-map §2.6]`) — **이건 오염이 아니라 정답 패턴**. 머그 본체색(투명/화이트)·에코백 천색도 이 방식 따라야(소재×색 합성 1행). "빨간 파우치"를 색축으로 분리하면 **WowPress보다 더 잘게 쪼개는 과분할**(사용자 "과분할 금지" 위배).

### 사다리 판정 (search-before-mint)
**신규 0·split 금지.** 본체색 = 재질행 합성(보유). 흡수 = "본체색은 재질·잉크색/인쇄면만 도수"를 입도 규칙으로 명시. WowPress 규칙 A·B 직접 적용.

### trade-off
- 장점: 본체색을 재질행 합성으로 관리(파우치 정답 패턴 전파). 색 독립축 폭발 회피.
- 단점: 잉크색(만년스탬프 검정/빨강)은 본체색 아니라 도수/옵션 — 혼동 금지(C-GP3과 분리). 만년스탬프 잉크색의 정확한 축(도수 vs 옵션그릇)은 도메인 확인(플래그·`[huni:goods-map §2.2]`).

### naming 유입 가드 [HARD]
`papergroup`/`papername`/`DIR_MTR DTL`(MLS01) 후니 유입 금지. 후니 `mat_cd`/`mat_nm` 번역.

---

## C-GP4. 형상 = 규격축 융합 (별 형상축 신설 금지) ★ (우선순위 High·흡수 강·비치수 GAP)

### 흡수 메커니즘
- **레드프린팅** `[red:GS §5·8]`: 완칼도무송 DTL = 칼틀 형상(GSNTSTA `THO_CUT/NT001`하트·`NT002`여권). **형상↔사이즈 1:1 캐스케이드**(NT002 여권형 → CUT 88×125). GSTGMIC THO_CUT 삼각/사각×S/L 칼틀.
- **와우프레스** `[wow:goods Q2]`: ★**형상은 독립 축이 아니라 `sizeinfo`(규격)에 치수와 융합** — 40185 핀버튼 `원형32`/`정사각37`/`하트57x51`(형상×치수 1행 = 1 sizeno·형상별 분리 행 아님).

### 후니 매핑 (규격축 융합·★비치수=GAP-SHAPE)
후니 형상 = `t_prd_product_sizes`(siz_nm에 형상라벨·`[huni:goods-map §2.1]`) — 말랑키링 원형/사각/꽃/별/하트·dbmap round-3 K컨펌(도무송 형상=size 칼틀 1:1)·스티커 반칼 형상=칼틀(가격축 아님·같은 사이즈 동일가) 정합. ★**비치수 형상**(원형/별·width/height 없음)·용량(11온스)은 **비치수 siz 등록=GAP-SHAPE**(round-5 'goods 비치수 size'로 이미 식별·발명 금지).

### 사다리 판정 (search-before-mint)
**신규 형상축 신설 금지·규격 융합.** siz_nm에 형상·width/height NULL 허용(이미 nullable) or 형상 enum 컬럼 = ddl-proposer 결정(GAP-SHAPE). WowPress 40185·후니 도무송 형상 1:1.

### trade-off
- 장점: 형상을 규격으로 융합(별 형상축 폭발 회피). 형상↔사이즈 캐스케이드(GSNTSTA)를 siz 1행으로. ★형상이 가격축인지 가드 — 스티커 반칼 형상=칼틀(가격 동일)·아크릴 형상=모양재단(가격 동일)이면 형상은 SKU 라벨일 뿐 가격 불변(돈크리티컬 — 형상별 다른 단가 적재 금물).
- 단점: 비치수 형상/용량 siz 등록처(GAP-SHAPE) 미확정. 형상이 칼틀로 가격에 영향하면(도무송 공정비) 형상=siz + 도무송 공정 동반.

### naming 유입 가드 [HARD]
`THO_CUT`/`NT001`/`sizeinfo.sizename` 후니 유입 금지. 후니 `siz_cd`/`siz_nm` 번역.

---

## C-GP5. variant 3채널 (SKU코드 / ATTB파라미터 / 사이즈프리셋) (우선순위 Medium·흡수 중·채널 혼동 경계)

### 흡수 메커니즘
RedPrinting variant 3채널 `[red:GS §0.3]`:
1. **DTL 코드 = variant 키**: GSMLSLC `MLS01`→색(핑크)·GSTGMIC `TG001/TG003`→사이즈 S/L(★동시에 칼틀·부자재·가격까지 결정 = 가장 강한 variant 합일).
2. **ATTB = variant 파라미터**: GSNTSPR `RIN_DFT ATTB="RIN_BLK"`(링색)·`ROU_DFT ATTB=4`(귀돌이 반경 4mm).
3. **CUT_WDT/HGH = 사이즈 프리셋**: 같은 MTRL_CD에 사이즈만 변동(GSNTSPR 182×257/132×182).
WowPress는 이를 sizeinfo(형상/사이즈)·paperinfo(색)·awkjobinfo namestep(개수)로 흡수(별 채널 안 만듦) `[wow:goods Q2]`.

### 후니 매핑 (polymorphic ref·채널 구분)
후니 CPQ는 셋을 구분해야(`[huni:goods-map §0.3]`·메모리 `dbmap-cpq-option-layer-mapping` polymorphic ref): ① SKU코드 variant → `siz_cd`(형상/사이즈) or 별 `mat_cd`(색) ② ATTB 파라미터 → option_items + 개수/반경 보존(GAP-COUNT) ③ 사이즈 프리셋 → siz 차원 1행. ★GSTGMIC S/L 합일 variant(사이즈·칼틀·부자재·가격 동시) = 후니 SKU variant 모델 핵심 케이스(siz_cd 1행이 캐스케이드 상위).

### 사다리 판정 (search-before-mint)
**신규 0·기존 polymorphic 옵션레이어로 닫힘.** 흡수 = variant를 의미축으로 라우팅(색→재질·형상/사이즈→규격·개수→공정+파라미터). 채널 혼동 경계 — 같은 의미를 3 채널에 흩지 말 것(WowPress 흡수 규칙).

### trade-off
- 장점: variant 인코딩 3채널을 후니 polymorphic ref로 정합 표현. 합일 variant(GSTGMIC)를 siz 1행 캐스케이드로.
- 단점: ATTB 파라미터(반경/개수) 보존처가 GAP-COUNT(ref_param_json 미구현). variant가 가격축인지 가드(S/L 가격 다르면 siz별 단가·색만 다르면 가격 동일).

### naming 유입 가드 [HARD]
`ATTB`/`DTL`/`RIN_BLK`/`TG001` 후니 유입 금지. 후니 `ref_dim_cd`/`ref_key`/`siz_cd` 번역.

---

## C-GP6. 본체 조립/봉제 = 별 공정·지퍼/끈 = 자재+공정 BUNDLE (우선순위 Medium·흡수 중)

### 흡수 메커니즘
- **레드프린팅** `[red:GS §7·8]`: `PDT_WRK`(제품가공) = 평면 인쇄물 → 입체 파우치/굿즈 봉제·조립(GSPUFBC `PUBOK` 파우치가공·GSTGMIC `PKT01` 마이크텍 조립). 지퍼=`FLX_ZIP`(지퍼 부자재+부착공정 BUNDLE·세로형/가로형 방향 variant). 제본(스프링노트 `RIN_DFT` 트윈링=링 금속부자재+꿰기 공정 bundle).

### 후니 매핑 (공정 + 자재+공정 BUNDLE)
후니 조립/봉제 = `t_prd_product_processes`(가공 공정·메모리 `dbmap-option-material-process-bundle`: 한 옵션이 자재+공정 두 의미). 지퍼/끈/링 = 자재(부자재)+공정(부착/봉제) BUNDLE·`usage_cd`(끈=부착공정·각목=셋트 정합·dbmap silsa v2 선례). 봉미싱/말아박기 = 파우치 마감가공 comp(dbmap 린넨 PRD_000124 마감가공 5택1 라이브 COMMIT 선례).

### 사다리 판정 (search-before-mint)
**신규 0·기존 공정+BUNDLE으로 닫힘.** 흡수 = 조립공정·지퍼/끈 BUNDLE 데이터 등록(권위 가격표). RedPrinting BUNDLE(자재+공정)·dbmap 봉제 정정(경로Y) 정합.

### trade-off
- 장점: 본체 조립(평면→입체)·지퍼/끈을 자재+공정 BUNDLE으로 정확 표현(주문+생산 BOM). RedPrinting `PDT_WRK`/`FLX_ZIP` 동형.
- 단점: 조립비가 개당단가에 baked-in인지 별 가산인지 검증(GSTGMIC PKT01 PRICE=0=baked-in·GSPDLNG 인쇄 5000=별 가산). 권위 가격표 대조.

### naming 유입 가드 [HARD]
`PDT_WRK`/`FLX_ZIP`/`PUBOK`/`RIN_DFT` 후니 유입 금지. 후니 `proc_cd`/`mat_cd`+`usage_cd` 번역.

---

## C-GP7. 구수/개수 = 개수형 공정 + 개수 N 파라미터 (우선순위 Medium·흡수 중·GAP-COUNT)

### 흡수 메커니즘
- **레드프린팅** `[red:GS §0.3②·4]`: ATTB = 개수/반경 파라미터(GSNTSPR `ROU_DFT ATTB=4` 귀돌이 반경 4mm·위치별 4슬롯[좌상/우상/좌하/우하]). 한 공정이 위치별 4 PCS 항목으로 분리.
- **와우프레스** `[wow:goods Q2·Q6 규칙C]`: `awkjobinfo.namestep2`(2단계 개수형: "단순"×"10개"~"20개"). ★2단계까지만 정규 축, 그 이상 다겹은 문자열 직렬화+화이트리스트(NCR 상중하지).

### 후니 매핑 (개수형 공정·★개수 N 보존처 부재=GAP-COUNT)
후니 구수(키캡키링 1구~4구·`[huni:goods-map §2.4]`) = 개수형 공정(`t_prd_product_processes` 타공/구성). ★**개수 N 보존 컬럼(ref_param_json) 라이브 미구현**(cpq-schema §4 🔴8) = GAP-COUNT. 현재는 공정행 분리 또는 option_items.qty 우회.

### 사다리 판정 (search-before-mint)
**신규 테이블 0·GAP-COUNT는 컬럼/코드행 사다리.** option_items.qty 재사용 vs ref_param_json 컬럼 추가 = ddl-proposer 결정(발명 금지). WowPress 규칙 C(2단계까지·이상은 직렬화) 흡수 — 개수 곱집합이 깊으면 화이트리스트.

### trade-off
- 장점: 구수/개수를 공정+개수 N으로 정확 표현(1구 ≠ 4구 가격). RedPrinting ATTB·WowPress namestep2 동형.
- 단점: 개수 N 보존처 미확정(GAP-COUNT). 구수가 가격축이면(타공 개수 비례) 개수 보존 필수.

### naming 유입 가드 [HARD]
`ATTB`/`namestep2`/`ROU_DFT` 후니 유입 금지. 후니 `proc_cd` + 개수 파라미터(한글 "구수") 번역.

---

## C-GP8. 포장/각인/잉크색팩 = 자유 옵션 그릇 (우선순위 Medium·흡수 중·GAP-OPT·발명 금지)

### 흡수 메커니즘
- **레드프린팅** `[red:GS §1·3·8]`: `PAK_ETC`(텀블러 패키징 0)·`PAK_POL`(폴리백·GSTGMIC 0)·개별포장(GSPDLNG 1000 유료). 포장방식별 다른 PCS_COD.
- **와우프레스** `[wow:goods Q1.7]`: ★**`optioninfo`(포장 optlist)** = 후니 "잡다한 굿즈 부가속성(각인/포장/구성)에 가장 가까운 그릇". 40274 마스킹테이프 포장(수축/쉬링크/없음 radio).

### 후니 매핑 (★대응 없음=GAP-OPT)
후니 ★**OPT_REF_DIM 7종에 "자유텍스트/포장/구성" 차원 부재**(`[huni:goods-map §1·5]`) = GAP-OPT. 만년스탬프 "리필잉크 N색팩"·파우치 "OPP포장"·"각인" 담을 정규 차원 없음. **부분 대응**: N개팩 = `t_prd_product_bundle_qtys`(QTY_UNIT·이미 보유·만년스탬프 "2개1팩"). 순수 포장/각인은 GAP-OPT.

### 사다리 판정 (search-before-mint)
**신규 OPT_REF_DIM 차원 vs optioninfo 전용 테이블 vs 묶음수 전용 = ddl-proposer 결정(발명 금지·플래그만).** 포장이 유료면 가산 comp(합산형)·무료면 옵션 표시만. WowPress optioninfo flat 흡수.

### trade-off
- 장점: 포장/각인을 자유 옵션 그릇으로(N개팩은 bundle_qtys 보유). 유료 포장=가산 comp.
- 단점: GAP-OPT 미확정(발명 금지). 포장 유료 누락 금지(돈크리티컬·GSPDLNG 1000).

### naming 유입 가드 [HARD]
`PAK_ETC`/`PAK_POL`/`optioninfo`/`optname` 후니 유입 금지. 후니 `bdl_qty`/(신규)차원 번역.

---

## C-GP9. tiered_price = 수량구간 단가 (자재단가 동반) (우선순위 Low·흡수 약·후니 보유)

### 관측 메커니즘
RedPrinting 유일 `tiered_price` 샘플 GSTGMIC `[red:GSTGMIC·GS §8]`: 인쇄(PRT_DFT)가 PRICE 주체·S=6000/L=7000·PRICE_LOG에 **자재단가** 필드 추가(tmpl엔 없음)·수량구간 할인 동반 추정. `tmpl_price`(개당단가)·`vTmpl_price`(variant)와 같은 SP(`WSP_ACPT_ORDER_TMPL_PCS_TIERED_PRICE`)·tiered만 구간.

### 후니 매핑 (수량구간 + 구간할인 — 이미 보유)
후니 `component_prices.min_qty`(수량구간 상향개방) + 구간할인 `t_dsc`(아크릴 B04·실사 B04 동형). tiered = 수량구간 단가. **흡수 불요**(후니가 이미 동형·오히려 명시적).

### 사다리 판정
**신설 0·흡수 불요.** tiered = 후니 수량구간 룩업 + 구간할인. RedPrinting 3엔진(tmpl/vTmpl/tiered)은 후니 `frm_typ_cd`(고정가형/합산형) + min_qty 구간으로 분기 — 엔진 코드 3분기 답습 금지.

### trade-off
- 장점: 수량구간 단가(볼륨디스카운트)를 min_qty + t_dsc로 표현.
- 단점: tiered "자재단가" 필드 = 본체 소재 단가가 구간가에 들어감(C-GP2 본체소재와 동반).

### naming 유입 가드 [HARD]
`tiered_price`/`tmpl_price`/`vTmpl_price`/SP명 후니 유입 금지. 후니 `frm_typ_cd`/`min_qty`/`t_dsc` 번역.

---

## 2. ×qty 과청구 맥락 — 경쟁사 굿즈 수량처리 대조 ★

> 디지털인쇄 파일럿에서 **`prc_typ .01`(단가형) × 수량 누적이 과청구**(명함 3500→350,000·박 24,800→7.44M)·아크릴 .02 미확정 결함. 굿즈는 경쟁사가 수량을 어떻게 처리하는가?

| 관점 | 레드프린팅 굿즈 | 와우프레스 굿즈 | 후니 굿즈 라이브 | 시사점 |
|------|----------------|----------------|-----------------|--------|
| 본체 단가 의미 | **개당단가**(텀블러 45000=1개당·`tmpl_price`) `[red:GS §1]` | 동적 견적(비선형·합판효율) `[wow:goods Q5]` | ★**가격사슬 전무**(바인딩 0·`[huni:live]`) | 개당단가 × 수량이 정당(완제품=개당) |
| ★개당 vs 묶음 | DIR_MTR PRICE=개당단가(PRICE_LOG "주문건수:1, 인쇄수량:1") `[red:GS §1]` | unobserved | (설계 대상) | ★개당단가 = `min_qty=1` × qty (아크릴 면적단가=개당과 동형·÷1) |
| 유료 인쇄 | 대부분 0(개당 baked-in)·대형(장패드 5000)·tiered(6000) `[red:GS §3·8]` | prsjobinfo 동적 | (설계 대상) | 유료 인쇄=가산 1회 vs ×수량 검증 |
| 유료 포장 | 개별포장 1000(GSPDLNG 수량1 적용) `[red:GS §3]` | optioninfo | GAP-OPT | ★포장 개당 과금 vs 1회 — 디지털 결함 동일 클래스 |
| 이중수량 | ORD_CNT(디자인수)×PRN_CNT(인쇄수량) `[red:GSTGMIC]` | ordqty×ordcnt `[wow:goods Q1]` | 부수=구간·디자인수=주문라인 | 디자인 건수 가격 baked-in 금지 |

### 핵심 대조 시사점
1. **★굿즈 개당단가 = `min_qty=1` × qty가 정당** — 완제 굿즈는 본질적으로 "1개당 가격"(텀블러 45000=1개당·PRICE_LOG 인쇄수량:1). 아크릴 면적단가=개당가(÷1 후 ×수량)와 **동형**. 디지털 명함(.01 묶음총액을 ×수량 평면화로 3배 과청구)과 결정적 차이 — 굿즈는 개당단가가 옳으므로 ×수량 정당. ★단 권위 가격표가 "묶음(N개) 단가"면 ÷min_qty 후 ×수량(디지털 .02 교정 동형). 엔진 evaluate_price 계약으로 확정·추측 적재 금지.
2. **유료 인쇄/포장 = 가산 1회 vs ×수량** — GSPDLNG 인쇄 5000·포장 1000이 "개당"인지 "1회"인지(디지털 후가공 ×qty 결함 동일 클래스). 본체×수량 + 인쇄/포장 가산 순서를 엔진 계약에 명시.
3. **tiered_price = 수량구간 할인** — 구간별 단가 하향(min_qty + t_dsc). 개당단가×수량 후 구간할인 순서.
4. **이중수량 분리** — 디자인수(주문라인)·인쇄수량(min_qty 구간)·5종단 일관 가드.

---

## 3. 흡수 종합 판정

1. **굿즈 가격계산 골격(완제 개당단가 + Σ유료옵션 + 조립공정 + 수량)은 후니 4단 엔진[고정가형/합산형 + min_qty 구간]이 표현력상 담을 수 있다** — RedPrinting 3엔진(`tmpl`/`vTmpl`/`tiered`)·WowPress 동적견적과 표현력 동형. ★**그러나 책자/아크릴/실사와 달리 후니 굿즈는 가격사슬이 거의 전무**(`[huni:live]` 30상품 바인딩 0·아크릴키링 1건뿐). 5종단 중 **가장 미설계** 상태.
2. **★실질 흡수 = 두 작업**: ① **완제 굿즈 개당단가형 가격사슬 신규 설계**(C-GP1·고정가형 공식·comp·바인딩·권위 가격표 굿즈 시트 단가 추출) ② **본체 소재/색/형상/구수의 자재축 오염 정리**(C-GP2~C-GP4·C-GP7·`[huni:mat]` .09 파우치 74행 오염·`[huni:goods-map]` 재분류). **vessel-gap 아닌 (a) 가격사슬 미설계 + (b) 자재 오염 정리 + (c) 3 GAP(컬럼/코드행)**.
3. **★본체 소재 = 후니 최대 결함(경쟁사와 동형)** — 후니 굿즈/파우치 본체 소재 컬럼 부재·소재가 상품명에만(RedPrinting 코스터 6소재 융합·WowPress papername 합성과 정확히 동형). dbmap이 명확분 41상품 COMMIT·BLOCKED 다수. C-GP2가 가격사슬의 본체 단가 기반(소재가 개당단가를 가름).
4. **★입도(과분할 금지) 규칙 = WowPress 직접 흡수**: 본체색=재질 합성(C-GP3·split 금지)·형상=규격 융합(C-GP4)·사이즈/방향=규격 1행·잉크색/인쇄면만 도수 분리. "함께 고르는 물리속성은 한 행 합성"이 후니 관리용이성의 답. 파우치 본체색은 이미 정답 패턴(전파).
5. **약한 보강 4건(C-GP5 variant 3채널·C-GP6 조립 BUNDLE·C-GP7 구수·C-GP9 tiered)** — 전부 기존 그릇(polymorphic ref·공정+BUNDLE·min_qty)으로 닫힘. 엔진 코드 3분기·새 채널은 overfit.
6. **3 GAP(SHAPE 비치수·COUNT 개수보존·OPT 포장그릇)** — 전부 **vessel 신설 아니라 컬럼/코드행 사다리**(ddl-proposer·발명 금지·플래그만). WowPress "새 축 만들지 말고 6 의미축 흡수"·규칙 C(2단계까지·이상은 화이트리스트) 정합.
7. **신규 가격축/테이블 신설 = 0건** — rpmeta GS distinct 부결(완제 SKU·variant·본체소재 = 기존 옵션/자재/공정 facet)·WowPress 6 의미축 흡수 규칙·5종단 누적 결론(신규 축 0)과 **완전 정합**. 굿즈가 가장 복잡하나 진짜 신규 가격축을 요구하지 않는다 — 독립 판단 결론.
8. **모든 흡수는 권위 엑셀이 최종** — 경쟁사가 가격표(굿즈 시트)와 충돌하면 가격표가 이긴다.

### designer로 넘기는 핵심 입력
- **완제 굿즈 = 개당단가형 공식**(고정가형 `.06` 동류·C-GP1) — 본체 개당단가 comp + (유료 인쇄/포장 가산) + 조립공정 Σ. **★굿즈 가격사슬 전무(바인딩 0)·전 상품 공식·comp·바인딩 신규 설계**(권위 가격표 260527 굿즈 시트 단가 추출).
- **본체 소재 = 별 자재행**(소재가 상품정체·소재별 다른 개당단가·C-GP2) — 본체 소재 등록(상품명 추출·dbmap GPM 트랙)이 가격사슬 기반. 신규 소재 search-before-mint.
- **입도 규칙(WowPress 흡수)**: 본체색=재질 합성(split 금지·C-GP3)·형상=규격 융합(C-GP4)·사이즈/방향=규격 1행·잉크색/인쇄면만 도수. 파우치 본체색 = 정답 패턴 전파.
- **variant 3채널 라우팅**(SKU코드→siz/mat·ATTB→option+개수·프리셋→siz·C-GP5)·**조립/지퍼/끈 = 자재+공정 BUNDLE**(C-GP6)·**구수 = 개수형 공정+개수 N**(GAP-COUNT·C-GP7).
- **★돈-크리티컬**: 개당단가 prc_typ 정합(개당 = min_qty=1 × qty 정당·묶음단가면 ÷min_qty·아크릴 면적단가=개당 동형·디지털 .02 교정 동형). 유료 인쇄/포장 가산 1회 vs ×수량. 형상이 가격축인지(도무송 형상=칼틀=가격 동일 가드).
- **3 GAP(SHAPE/COUNT/OPT) = 컬럼/코드행 사다리**(ddl-proposer·발명 금지)·**할인순서**(개당가×수량 후 구간할인 t_dsc)·**이중수량 분리**(부수=min_qty·디자인수=주문라인)를 엔진 계약에 명시.
