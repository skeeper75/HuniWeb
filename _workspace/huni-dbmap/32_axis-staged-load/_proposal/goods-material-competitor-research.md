# 굿즈 자재 모델링 권위 리서치 — 레드프린팅·와우프레스 오라클

> **목적:** 후니 굿즈(완제품 굿즈 + 소재가공 굿즈) 자재/품목/옵션/본체물성 정리의 **권위 오라클**로,
> 경쟁사 RedPrinting(사용자 본인 설계 시스템)·WowPress가 동일 상품군을 **데이터·UI 구조로 어떻게 다루는지** 실측·인용한다.
> **게이트 원칙(HARD):** 경쟁사 = 구조 오라클(정답 아님)·답습 금지. 후니 권위 = 상품마스터·가격표 엑셀. 읽기전용(주문/폼/장바구니 미진입).
> **작성:** dbm-competitor-benchmark (round-22 자재축 토대 지원). 식별자/코드 영어, 설명 한국어.

---

## 0. 출처 인벤토리 (모두 read-only)

| 출처 | 자산 | 신선도 | 활용 |
|------|------|--------|------|
| `[RP-cap]` | `_workspace/huni-widget/01_reverse/s3_raw_captures/s3_rp_GS*.json` (굿즈 8종 실 가격 API 캡처, `result_sum.PRICE`·`reqBody`·`query` XML) | 2026-06-02/03 (신선) | **주력** — RP 굿즈 본체 자재코드·PCS 구성 실측 |
| `[WP-cat]` | `docs/wowpress/catalog/products/*.json` (328상품, `raw.prod_info` 원본) — 거울버튼 40170·텀블러 40532·에코백 40479·헤더택 40579 | 2025-10-14 (catalog 스냅샷) | **주력** — WP 굿즈 본체 재질/규격 표현 실측 |
| `[WP-doc]` | `docs/wowpress/wowpress-api-document.txt` §7.3 재질(paperinfo)·§7.5 부자재(prodaddinfo) | API 문서 | 재질·부자재 슬롯 의미 |
| `[huni]` | `32_axis-staged-load/01_axis-authority-rules.md` §④자재 · `10_configurator/huni-goods-option-mapping.md` · `07_domain/benchmark-competitors.md` §6/§7/§9 | 라이브 규명 | **흡수 판정 기준 (후니 권위)** |

라이브 신규 트래픽 없음(저트래픽) — RP 캡처(신선)·WP catalog(오프라인 자산)로 충분. RP 본인 계정 jobcost 라이브 재획득 불요(캡처 PRICE 실측값 정상).

---

## 1. RedPrinting — 굿즈 자재/품목/옵션 데이터 구조 실측 `[RP-cap]`

RP는 모든 견적을 `dbo.WSP_ACPT_ORDER_TMPL_PCS_PRICE` 프로시저로 계산한다. 요청 구조 = `ORD_INFO`(주문축) + `PCS_INFO`(공정/구성요소 배열). **본체는 `MTRL_CD`(주문축 자재코드) + `DIR_MTR`/`WRK_MTR` PCS 두 곳에 동시 표현**된다.

### 1.1 완제품 굿즈 실측표

| 상품(PDT_CD) | 본체 = MTRL_CD (주문축) | 본체 표현 PCS | PCS_DTL_NME (본체 실명) | 인쇄방식(DOSU_COD·PRN_CLR_CNT) | 본체 가격 위치 | price_gbn |
|---|---|---|---|---|---|---|
| 보틀/텀블러 `GSTBMWM` | `SXMIRW06` | **`DIR_MTR`** 부자재직접인쇄 | "미르 와이드마우스 보틀 화이트 20oz" | `SID_X`(인쇄없음)·`PRN_CLR_CNT=0` | DIR_MTR `PRICE=45,000` | `tmpl_price` |
| 틴거울 `GSMLSLC` | `SXSML001` | **`DIR_MTR/MLS01`** 부자재직접인쇄 | "핑크"(본체색) | `SID_S`(단면)·`PRN_CLR_CNT=4` | DIR_MTR `PRICE=2,800` | `tmpl_price` |
| 장패드 `GSPDLNG` | `SXLPD001` | **`DIR_MTR/LD001`** 부자재직접인쇄 | "장패드 4T"(소재+두께) | `SID_S`·`PRN_CLR_CNT=4` | DIR_MTR `10,000` + PRT_DFT 인쇄 `5,000` | `vTmpl_price` |
| 마이크네임택 `GSTGMIC` | `RXBVW300` | **`WRK_MTR/TG001`** 부자재작업 | "삼각 마이크텍 스펀지 S" | `SID_S`·`PRN_CLR_CNT=4` | WRK_MTR(자재단가 별도 로그) | `tiered_price` |
| 다이어리 `GSDRSKS` | `RIBVW350` | (DIR_MTR 없음 — 인쇄형) | 표지/내지/코일링 PCS 조합 | `SID_S`·`PRN_CLR_CNT=4` | 다 PCS 구성 | `tmpl_price` |

### 1.2 소재가공 굿즈(파우치) 실측

| 상품(PDT_CD) | 본체원단 = MTRL_CD | 가공 PCS들 | 의미 |
|---|---|---|---|
| 노트북파우치 `GSPUFBC` | `PXFBW010` (원단·`PX`접두) | `CUT_DFT`(재단)·`PDT_WRK/PUBOK`(노트북-태블릿 파우치가공)·`FLX_ZIP/ZPH01`(지퍼가공 세로형)·`PRT_DFT`(인쇄단면) | **본체=원단 MTRL_CD + 가공은 PCS 배열**. 사이즈(13인치 가로형 → CUT/WRK 치수)가 step1 선택 |

### 1.3 RP 구조 도출 (실측 근거)

1. **본체 = 자재(material)로 둔다.** `MTRL_CD`(SXMIRW06·SXSML001·PXFBW010 등) — 주문 핵심축에 자재코드 1개. 접두사가 소재계열 코딩: `SX*`(부자재·완제품 본체), `RIB*`(다이어리 원단), `PX*`(파우치 원단), `RXB*`(부자재 스펀지). **본체는 "품목(독립 SKU)"이 아니라 자재 슬롯**이다.
2. **본체색·본체 변형 = 자재의 PCS_DTL로 합성.** 틴거울 핑크(MLS01), 보틀 화이트(TM039)가 `DIR_MTR`의 `PCS_DTL_NME`로 — **색을 독립 옵션축으로 떼지 않고 자재 상세에 합성**.
3. **인쇄방식 = `DOSU_COD` 코드 + `PRN_CLR_CNT`(도수).** `SID_X`(인쇄없음=각인/무지), `SID_S`(단면), `SID_Y`(양면 추정). 본체 자재(DIR_MTR)와 인쇄(PRT_DFT)는 **별 PCS로 분리** — 본체값과 인쇄값을 따로 합산(장패드: 본체 10,000 + 인쇄 5,000 + 포장 1,000).
4. **굿즈 본체 가격 = `DIR_MTR`(부자재직접인쇄) 또는 `WRK_MTR`(부자재작업) PCS에 집중.** 완제품 본체값이 여기 박힌다(개당단가 룩업·`tmpl_price`). 가공 PCS(지퍼·재단·코팅)는 가공비.
5. **소재가공 = 원단 MTRL_CD + 가공 PCS 배열**(PDT_WRK 제품가공·FLX_ZIP 지퍼·CUT_DFT 재단). 소재를 카테고리/옵션이 아니라 **자재코드**로 둔다.
6. **굿즈도 인쇄상품과 같은 견적 모델**(동일 프로시저·`ORD_INFO`+`PCS_INFO`). 별도 굿즈 전용 모델 없음 — 본체를 자재로, 가공을 PCS로 흡수해 통일.

---

## 2. WowPress — 굿즈 자재/품목/옵션 데이터 구조 실측 `[WP-cat]`

WP는 인쇄소 스키마(`sizeinfo`·`colorinfo`·`paperinfo`(재질)·`awkjobinfo`(후가공)·`prodaddinfo`(부자재))를 **굿즈에도 그대로 재사용**한다. 본체 소재는 종이 슬롯 `paperinfo`에 욱여넣는다.

### 2.1 완제품 굿즈 실측표 (`raw.prod_info`)

| 상품(productId) | meta selType·unit | 본체 표현 = `paperinfo` | papergroup (본체소재) | papername (본체색/변형) | pgram(평량) | sizeinfo |
|---|---|---|---|---|---|---|
| 거울버튼 40170 | `M`·개 | paperlist | **유포지(유광/무광)** (인쇄스티커 재질) | 개별포장 있음/없음 4종 | `null` | 원형58·원형75 |
| 텀블러 40532 | `M`·개 | paperlist | **스텐** (본체 소재) | **아이보리·블랙** (본체색!) | `null` | 220x130·45x110 |
| 에코백 40479 | `M`·개 | paperlist | **캔버스** (천 소재) | **내추럴·블랙·핫핑크·라이트블루·타코이즈·네이비** (천색 6종!) | `null` | L(480x400)·M(360x370)·S(200x200) |
| (대조) 헤더택 40579 인쇄물 | `M`·개 | paperlist | 랑데뷰·스노우지 | 랑데뷰 240g·스노우지 250g | **240·250** (평량 실값) | 100x100 등 |

### 2.2 WP 구조 도출 (실측 근거)

1. **본체 소재 = `paperinfo`(재질 슬롯)에 둔다.** 텀블러 본체="스텐"(papergroup), 에코백="캔버스" — **종이 인쇄소의 재질 슬롯을 본체 소재 슬롯으로 전용**. 별도 굿즈 전용 본체 엔티티 없음.
2. **본체색 = 같은 `paperinfo`의 `papername`으로 합성.** 텀블러 아이보리/블랙, 에코백 천색 6종이 papername. **소재(papergroup)+본체색(papername)을 한 재질행에 합성** — 색을 독립 축으로 떼지 않음.
3. **물성 구분 = `pgram`(평량) null로 표시.** 종이는 평량 실값(240/250), 굿즈 본체는 평량 무의미 → `pgram=null`. 즉 **WP는 본체물성을 종이 평량 모델에 매핑하되, 굿즈는 평량 null로 "비종이"임을 신호**한다.
4. **사이즈 = `sizeinfo`** (텀블러 220x130 = 인쇄영역 전개크기, 에코백 S/M/L). `non_standard` 플래그로 비규격(원형 등) 처리.
5. **인쇄방식 = `colorinfo.colorlist`** (단면칼라 등) + `req_prsjob`(디지털인쇄 프리셋). 각인/승화 등 굿즈 특수 인쇄는 colorlist 항목명으로 흡수.
6. **부자재/동반품 = `prodaddinfo`** (에코백→"접착식 폴리백", 헤더택→"비접착 OPP봉투"). 본체와 별 SKU(`prodno`)로 동반.
7. **굿즈도 인쇄상품과 같은 모델**(동일 `prod_info` 5슬롯·selType M·unit 개). 거치대바퀴 등 순수 부자재만 `selType: S`. **별도 굿즈 모델 없음.**

---

## 3. 완제품 vs 소재가공 처리 패턴 대조

| 처리 축 | RedPrinting `[RP-cap]` | WowPress `[WP-cat]` | 두 경쟁사 합의 |
|---|---|---|---|
| **본체를 자재 vs 품목?** | **자재** (`MTRL_CD` 주문축 + DIR_MTR/WRK_MTR PCS) | **자재** (`paperinfo` 재질 슬롯) | **둘 다 자재** (독립 SKU/품목 아님) |
| **본체색 처리** | 자재 PCS_DTL에 **합성**(틴거울 핑크) | papername에 **합성**(텀블러 아이보리·에코백 천색6) | **본체색=재질행 합성** (색 분리 안 함) |
| **본체물성(유리/스텐/캔버스) 위치** | MTRL_CD 접두사·PCS_DTL_NME 텍스트 | papergroup + pgram=null | **재질행에 내포** (별 물성 엔티티 없음) |
| **인쇄방식(UV/각인/전사/승화)** | `DOSU_COD`(SID_X 무인쇄/SID_S 단면) + 별 PCS(PRT_DFT) | `colorinfo.colorlist` + req_prsjob | **인쇄=재질과 분리된 도수/인쇄 축** |
| **소재가공(파우치/에코백) 소재** | 원단 `MTRL_CD`(PXFBW010) + 가공 PCS(PDT_WRK·FLX_ZIP) | `paperinfo`(캔버스) + sizeinfo + prodaddinfo | **소재=자재코드** (카테고리/옵션 아님) |
| **본체 가격 위치** | DIR_MTR/WRK_MTR PCS 개당단가 룩업 | jobcost 위임(catalog 불투명 프리셋) | 본체값=자재/PCS에 집중 |
| **굿즈 전용 모델?** | 없음 — 인쇄상품과 동일 프로시저 | 없음 — 인쇄상품과 동일 5슬롯 | **별도 굿즈 모델 없음. 자재+가공으로 통일 흡수** |

**핵심 합의 (두 경쟁사 독립 수렴):**
> **① 굿즈 본체 = 자재(material). 독립 품목/SKU 아니다.**
> **② 본체색 = 본체소재와 한 재질행에 합성**(과분할 금지).
> **③ 인쇄방식 = 재질과 분리된 도수/인쇄 축.**
> **④ 소재가공 굿즈도 소재 = 자재코드 + 가공 = 공정.**
> **⑤ 굿즈 전용 모델 신설 안 함 — 인쇄상품 모델에 자재+가공으로 흡수.**

---

## 4. 후니 스키마 흡수 판정

후니 자재 모델 = `t_mat_materials`(MAT_TYPE 11종: 종이/필름/아크릴/금속/원단/가죽/부속/실사소재/파우치/악세사리/스티커 · `upr_mat_cd` self-ref · width/height/depth/weight/bdl_qty 물성 · `sel_typ_cd`) + `t_prd_product_materials`(mat_cd + usage_cd) + 완제품 엔티티(`t_prd_product_sets`/templates/addons) + 인쇄/도수 축 분리.

| 경쟁사 패턴 | 후니 대응 | 판정 |
|---|---|---|
| 본체 = 자재 (RP MTRL_CD / WP paperinfo) | `t_mat_materials.mat_cd` + `t_prd_product_materials` | **✅ 흡수** — 후니도 본체=자재 슬롯 |
| 본체색 = 재질행 합성 (RP PCS_DTL / WP papername) | `material-option-normalization` **"본체색은 재질행 합성"**(파우치 MAT_000062~067 색별 자식) | **✅ 흡수·이미 정답** — 후니 파우치가 정확히 이 패턴 |
| 본체물성(스텐/캔버스/유리) = 재질행 내포 | `mat_typ_cd`(금속/원단/실사소재) + self-ref upr_mat_cd | **✅ 흡수·능가** — WP는 pgram=null로 비종이 신호뿐, 후니는 **MAT_TYPE으로 물성 유형 분류** |
| 두께(장패드 4T·아크릴 1.5/3/8mm) = 자재 식별자 | MAT_000042~044 별 행 + `mat.weight/depth` | **✅ 흡수** — CIP4/JDF Media Thickness와도 정합 |
| 인쇄방식 분리(RP DOSU_COD / WP colorinfo) | `t_prd_product_print_options`·도수축(별색=공정) | **✅ 흡수** — 인쇄/도수 별 축 |
| 소재가공 = 원단자재 + 가공PCS (RP PXFBW010+PDT_WRK) | mat_cd(원단) + `t_prd_product_processes`(파우치가공·지퍼) | **✅ 흡수** — 자재+공정 분리 |
| 동반 부자재 (WP prodaddinfo / RP 거치대바퀴) | `t_prd_product_sets`(.07 sub_prd_cd) / addons / 우드거치대=자재(Q13) | **✅ 흡수** — 셋트/addon 엔티티 보유 |
| 용량(머그 11온스·350ml) = 규격 | 비치수 siz (GAP-SHAPE 동류) | **🟡 부분** — WP도 머그 직접대응 없음(공통 GAP). 비치수 siz 후보 |
| 캐스케이드 제약(자재→공정 disable) | `t_prd_product_constraints`(JSONLogic) 약함 | **🟡 보강 권고** — RP disable_pcs·WP rst_awkjob 둘 다 보유, 후니 신설 권고 |

**종합 판정:** 후니 자재 모델(MAT_TYPE 11 + usage_cd + 물성 self-ref + 본체색 합성 + 완제품 셋트/addon)은 **RP·WP의 굿즈 본체·소재 처리 패턴을 전부 흡수, 일부 능가**(WP는 본체소재를 종이 평량 모델에 욱여넣고 pgram=null로 신호 — 후니 MAT_TYPE 분류가 더 명시적). **결함은 모델 부재가 아니라 오염 적재**(색/형상/사이즈/구수가 자재로 ~120행: MAT_TYPE.09 파우치 75·.10 악세사리 43·.08 실사소재 22).

---

## 5. 권위 시사점 — 후니 굿즈 자재 정리 권고

경쟁사 두 곳이 **독립적으로 동일 결론에 수렴**(굿즈 본체=자재·본체색=합성·소재가공=자재+공정)했고, 이는 후니 `huni-goods-option-mapping`·`material-option-normalization`이 이미 권고한 방향과 정확히 일치한다. 즉 **경쟁사 오라클이 후니 기존 정리 방향을 검증한다.** 구체 권고:

1. **[권위 확정] 굿즈 본체는 자재(material)로 둔다 — 독립 품목 신설 금지.** RP·WP 둘 다 본체=자재 슬롯. 후니도 `t_mat_materials.mat_cd`(MAT_TYPE: 금속=텀블러/보틀, 원단=에코백, 파우치=파우치, 실사소재=캔버스) + `t_prd_product_materials`로. **머그/텀블러/거울을 `t_prd_product_sets`/templates 같은 완제품 SKU 엔티티로 쪼개지 말 것** — 완제품 셋트(.07)는 "동반 부속상품"(WP prodaddinfo·CD커버세트)에만 쓰고, 본체 자체는 자재.

2. **[권위 확정] 본체색 = 재질행 합성(과분할 금지).** WP 에코백 천색6=`papergroup 캔버스 + papername 색`(한 paperinfo), 텀블러 아이보리/블랙=`스텐+색`. RP 틴거울 핑크=DIR_MTR 자재상세. → 후니 머그 화이트/에코백 천색을 **"머그(화이트)"·"에코백캔버스(네이비)" 합성 mat_cd**로(파우치 MAT_000062~067가 이미 정답 패턴). **색 독립 옵션축 신설 금지.**

3. **[권위 확정] 본체물성 = MAT_TYPE + 물성컬럼에 내포.** WP는 pgram=null로 "비종이"만 신호(빈약). 후니는 MAT_TYPE(금속/원단/실사소재/파우치)로 물성 유형을 명시 분류 — **WP보다 우월하므로 그대로 유지·강화**. 두께(장패드 4T)·용량은 `mat.weight/depth` 또는 별 mat_cd.

4. **[권위 확정] 인쇄방식(UV/각인/전사/승화) = 재질과 분리.** RP `DOSU_COD`(SID_X 무인쇄·각인류 / SID_S 단면) + 별 PCS, WP `colorinfo`. → 후니 `t_prd_product_print_options`·도수축. **각인/무지(인쇄없음)도 인쇄축의 한 값**(SID_X 동등)으로 — 자재에 섞지 말 것. 특수 인쇄(UV/승화)는 인쇄방식 enum 또는 공정.

5. **[권위 확정] 소재가공 굿즈(파우치/에코백) = 원단자재 + 가공공정.** RP `PXFBW010`(원단) + `PDT_WRK/FLX_ZIP`(가공), WP 캔버스 paperinfo + sizeinfo. → 후니 mat_cd(원단) + `t_prd_product_processes`(파우치가공·지퍼·재단). **소재를 카테고리/옵션으로 두지 말 것 — 자재코드.**

6. **[교정 대상 확인] 오염 ~120행 정리.** MAT_TYPE.08~10에 색/형상/사이즈/구수가 자재로 적재된 행(라이브 실증) — **형상→size, 사이즈variant→size, 구수→공정, 잉크색/인쇄면→도수**로 재배선하고, **진짜 본체소재+본체색 합성행만 자재에 남긴다**(파우치 MAT_TYPE.05는 이미 정답, 유지). round-22 자재축 교정 입력 엑셀의 핵심 규칙.

7. **[GAP·도메인 확인]** ① 용량(머그 온스/ml) — RP/WP 둘 다 직접대응 없음(공통 GAP) → 비치수 siz 후보, 도메인 확인. ② 잉크색(만년스탬프) — 도수 vs 옵션그릇, 도메인 확인. ③ 캐스케이드 제약(자재→공정 disable) — RP/WP 둘 다 보유, 후니 `t_prd_product_constraints` 신설 권고.

**한 줄 요약:** RP·WP 둘 다 **굿즈 본체를 자재로, 본체색을 재질행에 합성, 소재가공을 원단자재+가공공정으로** 다루며 **굿즈 전용 모델을 신설하지 않는다.** 이는 후니 기존 정리 방향(`huni-goods-option-mapping`·본체색 합성·MAT_TYPE 11)을 외부 권위로 검증한다 — 후니 모델은 두 경쟁사를 흡수·일부 능가하며, 남은 일은 **모델 신설이 아니라 오염 자재행(~120) 교정 + GAP 3건(용량·잉크색·캐스케이드 제약) 해소**다.

---

## Sources

- `[RP-cap]` `_workspace/huni-widget/01_reverse/s3_raw_captures/`: `s3_rp_GSTBMWM.json`(보틀)·`s3_rp_GSMLSLC.json`(틴거울)·`s3_rp_GSPDLNG.json`(장패드)·`s3_rp_GSTGMIC.json`(마이크네임택)·`s3_rp_GSDRSKS.json`(다이어리)·`s3_rp_GSPUFBC.json`(노트북파우치)·`s3_rp_GSNTSPR.json`(스프링노트) — 실 가격 API 캡처(reqBody·query XML·result_sum.PRICE)
- `[WP-cat]` `docs/wowpress/catalog/products/`: `40170.json`(거울버튼)·`40532.json`(텀블러)·`40479.json`(에코백)·`40579.json`(헤더택 대조) — `raw.prod_info`(paperinfo/sizeinfo/colorinfo/prodaddinfo)
- `[WP-doc]` `docs/wowpress/wowpress-api-document.txt` §7.3 재질(paperinfo)·§7.5 부자재(prodaddinfo)
- `[huni]` `32_axis-staged-load/01_axis-authority-rules.md` §④자재 · `10_configurator/huni-goods-option-mapping.md` · `04_audit/material-master-analysis.md`(MAT_TYPE.08~10 오염 실증) · `07_domain/benchmark-competitors.md` §6/§7/§9
