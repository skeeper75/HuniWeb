# RP 옵션 원자 추출 — AC(아크릴·키링·코롯토·명찰·등신대) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting AC 카테고리(20상품) 대표 3상품 원자추출 + 17상품 그룹 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **두께(3T/5T/8T)·아크릴 소재 variant(투명/유색/글리터/거울/자개/렌티큘러/홀로그램)·입체/스탠드(3D)·완칼(자유형 레이저)·부착물(고리/마그넷/받침/뱃지핀)** 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★AC 카테고리의 본질 = 아크릴 본체(두께×소재variant) × 자유형 레이저(완칼) × 부착물(고리/받침/마그넷) × 인쇄면(앞뒤같음/다름) × 화이트언더베이스.** ★최대 관전 = **두께(3T/5T)·입체/스탠드가 distinct #19인가, 자재#1·형태가공#14·ST형상#17의 facet인가** — 1차 판정 §0·§5·Ambiguous A-1/A-3.

## 출처 표기 규칙 (BN/GS/TP/PR/ST/CL 계승)
- `[reuse:productInfo]` = huni-widget 캡처(`_workspace/huni-widget/01_reverse/captures/product_*.json` · `05_qa/captures/major_*.json`)의 infoCall/widgetDump 풀 응답(`product_option.option` + `product_data` 전체 = `pdt_base_info`/`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_prn_cnt_info`/`pdt_pcs_info`/`pdt_disable_pcs_info`/`option_info`). ACNTHAP(product_ACNTHAP.json)·ACTHDKY(major_radius_ACTHDKY.json)·ACPDSTD(major_acc_ACPDSTD.json) 풀 보유.
- `[reuse:qtysweep]` = `05_qa/captures/qtysweep_ACNTHAP.json` 수량 가격 sweep(있으면).
- `[live:SSR-negative]` = 2026-06-17 라이브 읽기전용 GET `/ko/product/item/AC/{code}` = HTTP 200·~354KB이나 **신규 Vue client-render** — 옵션 select 미노출(전역 km1_size 샘플 2 select만, 두께/거울/글리터/입체/스탠드/코롯토 텍스트는 정적 마케팅 카피). ACTHFCO 확인(거울12·글리터4·두께6·받침3·스탠드35·입체22·코롯토37·투명20 키워드 = 전부 정적 카피).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL·category (2026-06-17 확인, AC 20상품 전부 category=AC·URL=/item/AC/).
- `[huni-ref]` = `_workspace/huni-dbmap/31_acrylic-price-link/{acrylic-chain-design,confirms-and-gaps}.md` — 후니 아크릴 두께/소재/후가공 모델(갭 단계 대조용·여기선 RP 추출에 집중, 참고 표기만).
- `unobserved` = 미관측(날조 금지).

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. AC 카테고리 핵심 발견 — 두께·소재variant가 자재축에 인코딩, 부착물·입체는 부자재/공정

AC 상품은 BN·GS·TP·PR·ST와 동일한 서버 base-data 스키마(`pdt_mtrl_info`/`pdt_size_info`/`pdt_dosu_info`/`pdt_pcs_info`)를 그대로 쓴다. **AC 고유는 ① `pdt_mtrl_info` MTRL_CD에 두께(D01=3T/D02=5T)·소재(AAT 투명/홀로그램)가 인코딩(WGT_CD가 두께 역할) ② `GRP_OPTION_CD`(MTG_DFT 일반 / MTG_LAM 라미)가 가공방식(production_method) 슬롯으로 자재를 묶음 ③ 부착물(고리/받침/마그넷)이 `SUB_MTR`(추가부자재) PCS로 인코딩(부자재 BUNDLE) ④ `option_info.print_data`(앞뒤같음/다름)가 인쇄면 슬롯 ⑤ 자유형 레이저(`LAS_DFT`/FRXXX)가 완칼(아크릴 절단) 공정 ⑥ 3개 다른 item_gbn/price_gbn(vTmpl/acrylic2025/tmpl)이 한 카테고리에 공존**.

### 0.1 ★두께(thickness) = 자재 MTRL_CD에 인코딩 (WGT_CD 슬롯·directive 최대 관전)
ACTHDKY(아크릴 키링)는 두께를 **자재행(MTRL_CD)의 WGT_CD 슬롯**에 인코딩(`[reuse:productInfo]` major_radius_ACTHDKY 6 mtrl 실측):

> 열 표기: `PTT_CD/PTT_NM`·`WGT_CD`·`GRP_OPTION_CD`는 캡처 **리터럴 필드**(major_radius_ACTHDKY rawProductData.pdt_mtrl_info 실재). `MTRL_NM`도 리터럴. (대조: 캡처에 PTT 리터럴이 있는 건 ACTHDKY뿐 — ACNTHAP의 PTT_CD는 IGC, ACPDSTD는 ACR. §2/§4의 "AAT 소재계열" 일반화는 MTRL_CD 접두 PXAAT에서 유도한 계열 약어임을 별도 표기.)

| MTRL_CD | MTRL_NM | PTT_CD/PTT_NM(리터럴) | WGT_CD(리터럴·두께/가공 슬롯) | GRP_OPTION_CD(리터럴) |
|---------|---------|----------------------|------------------------------|----------------------|
| **PXAATD01** | 아크릴_**3T** 투명 | AAT / 투명 아크릴 | **D01**(3T) | MTG_DFT(일반) |
| **PXAATD02** | 아크릴_**5T** 투명 | AAT / 투명 아크릴 | **D02**(5T) | MTG_DFT(일반) |
| PXAATL01 | 아크릴_3T 투명 라미(2T+1T) | AAT / 투명 아크릴 | L01 | MTG_LAM(라미) |
| PXAATL02 | 아크릴_5T 투명 라미(4T+1T) | AAT / 투명 아크릴 | L02 | MTG_LAM(라미) |
| PXAATL03 | 홀로그램아크릴_3T 깨진유리 라미(1T+2T) | AAT / 투명 아크릴 | L03 | MTG_LAM(라미) |
| PXAATL04 | 홀로그램아크릴_3T 격자 라미(1T+2T) | AAT / 투명 아크릴 | L04 | MTG_LAM(라미) |

★두께(3T/5T)는 **별도 옵션 슬롯이 아니라 자재 MTRL_CD(WGT_CD)에 인코딩** — widget select `material` 옵션에 "아크릴_3T 투명/아크릴_5T 투명"으로 노출(`[reuse:productInfo]` widgetDump.selects[material].opts). 즉 RedPrinting은 두께를 **자재의 한 축(WGT_CD=평량 슬롯 재활용)** 으로 본다. base_data_tag = 자재(두께 = WGT 차원). **★directive 최대 관전 1차 판정: 두께 = 자재#1의 facet(WGT 슬롯 재활용·별 축 아님). 단 후니 [huni-ref]는 mat_cd 차원으로 두께 통합(투명3T/1.5T를 1 comp의 mat_cd 분기)·동형 — 두께 distinct #19 아님, 자재 WGT/mat 차원.** (A-1 등재)

### 0.2 ★아크릴 소재 variant(투명/홀로그램/유색/글리터/거울/자개/렌티큘러) = 자재 PTT + 상품 분기
소재 variant가 ① 자재행 PTT/라미 인코딩(ACTHDKY 홀로그램 깨진유리·격자) ② **소재 특화 별 pdtCode**(글리터 ACTHGKY·거울 ACTHMKY·자개 ACTHPKY·유색 ACTHCKY·렌티큘러 ACTHLKY/ACTHLCO·파스텔 ACTHPAM/ACTHPAA) 양면 인코딩(`[reuse:productInfo]`+`[live:catalog]`):

| 소재 계열 | 대표 자재(MTRL_CD/MTRL_NM) | 특성 | 상품 분기 |
|----------|--------------------------|------|----------|
| 투명 | PXAATD01/D02 아크릴_3T/5T 투명 · PXACR016 | 기본 투명 | ACTHDKY 본체·ACPDSTD·ACNTHAP아님 |
| 홀로그램 | PXAATL03 깨진유리·PXAATL04 격자(라미) | 무지개 반사 | (ACTHDKY 자재 variant) |
| 글리터 | unobserved(글리터 라미 추정) | 반짝이 봉입 | **ACTHGKY(글리터 키링)** |
| 거울 | unobserved(미러 아크릴·[huni-ref] MIRROR3T) | 거울 반사 | **ACTHMKY(거울 키링)** |
| 자개 | unobserved | 자개 무늬 | **ACTHPKY(자개 키링)** |
| 유색 | unobserved(컬러 아크릴) | 단색 컬러 | **ACTHCKY(유색 키링)** |
| 렌티큘러 | unobserved(렌티큘러 시트 합지) | 보는각도 변화 | **ACTHLKY(키링)·ACTHLCO(코롯토)** |
| 파스텔 | unobserved | 뮤트/아스텔 파스텔 | **ACTHPAM·ACTHPAA** |

→ 소재 variant는 ① 한 상품 내 자재 enum(ACTHDKY 6소재에 투명/라미/홀로그램 공존) ② 소재 특화 상품(글리터/거울/자개/유색/렌티큘러/파스텔) 양면 인코딩. base_data_tag = 자재(소재 PTT/표면 variant) + (특화 시) 카테고리(소재특화 상품). **★ST 점착소재 spectrum(§0.4)과 동형 — 자재 variant가 상품을 가른다. 글리터/거울/자개는 표면효과 = 자재의 surface-finish 차원.** (A-2 등재)

### 0.3 ★입체/스탠드(3D) = 받침 부착물(SUB_MTR) + 코롯토 상품군 (directive 최대 관전 2)
입체/스탠드 구조가 ① **받침대 부착물**(ACPDSTD 등신대 받침 12종 SUB_MTR) ② **코롯토 상품군**(ACTHDCO 두꺼운·ACTHBCO 양면·ACTHFCO 입체·ACTHLCO 렌티큘러)으로 인코딩(`[reuse:productInfo]` ACPDSTD + `[live:catalog]`):

- **등신대(ACPDSTD)**: 본체 = 평면 아크릴(PXACR016 3T투명·자유사이즈 최대 300×250) + **받침대 SUB_MTR 12종**(원형/타원/사각/육각 × S/M/L) — 받침은 별 자재코드(SXAPR005~016)·SUB_MTRL_YN=Y·ESN_YN=Y(필수)·QTY_INPUT_YN=Y(수량입력). 즉 등신대 = 평면본체 + **세워주는 받침 부자재**(평면을 입체로 세움).
- **코롯토(ACTH*CO)**: ACTHDCO(두꺼운·스탠드)·ACTHBCO(양면·스탠드)·ACTHFCO(입체·스탠드)·ACTHLCO(렌티큘러). 코롯토 = "두꺼운 아크릴 블록 입체"([huni-ref] B06 코롯토 6×6 면적매트릭스·30~80mm). 입체성 = ① 양면(BCO)·② 두께블록(DCO·8T급)·③ 입체조형(FCO) variant.

→ 입체/스탠드는 **별 "3D 축"이 아니라 ① 받침 부자재(SUB_MTR — 평면을 세움) ② 코롯토 상품군(두께/양면/입체 variant)** 으로 분산 인코딩. base_data_tag = 부자재(받침 BUNDLE) + 카테고리(코롯토 상품) + 자재(두꺼운 블록). **★directive 최대 관전 2차 판정: 입체/스탠드 = distinct #19 아님 — 받침=부자재#(SUB_MTR BUNDLE, ST/GS와 동형)·코롯토 두께블록=자재 두께 facet·양면=인쇄면(print_data) facet. 단 "받침이 평면을 입체로 변환"하는 의미는 부자재 이상의 형태변환 — Ambiguous A-3 등재.** (A-3)

### 0.4 ★부착물(고리/마그넷/받침/뱃지핀) = SUB_MTR/WRK_MTR 부자재 BUNDLE (ST 동형·정점)
부착물이 두 PCS 그룹으로 인코딩(`[reuse:productInfo]` ACTHDKY·ACNTHAP·ACPDSTD):

| 부착물 유형 | PCS_CD / PCS_GRP | 대표 항목(WEB_PCS_DTL_GRP) | 상품 | base_data_tag |
|------------|------------------|---------------------------|------|---------------|
| **키링 고리** | SUB_MTR 추가부자재 | 열쇠고리(KR001~040 자물쇠/하트/별/달/고양이…40+)·카라비너(BN001)·민자링/기본링 | ACTHDKY | 부자재(고리 enum) + 공정(부착) |
| **구슬줄/와이어링** | SUB_MTR 추가부자재 | 컬러구슬줄(CN009~030)·컬러와이어링(CR015~029) — 색 variant·QTY_INPUT_YN=Y | ACTHDKY | 부자재(끈 색 enum) + 공정(조립) |
| **등신대 받침** | SUB_MTR 추가부자재 | 등신대받침대(AB005~016 원형/타원/사각/육각×S/M/L) | ACPDSTD | 부자재(받침 SKU) + 공정(거치) |
| **명찰 뒷면자재** | WRK_MTR 부자재작업 | 뒷면자재(옷핀집게 SXANB001·마그넷 SXANB002) | ACNTHAP | 부자재(부착물) + 공정(부착) |
| **마그넷(통자석)** | (상품분기) | ACPDAMG 통자석·ACPDMGN 마그넷 | ACPD* | 자재(자석) + 공정 |
| **뱃지 핀** | (상품분기) | ACPDPIN 뱃지(핀 부착) | ACPDPIN | 부자재(핀) + 공정 |

★부착물 핵심: ① 고리/구슬줄/받침 = `SUB_MTR`(추가부자재·MTRL_CD 동반 또는 빈값) ② 명찰 뒷면 = `WRK_MTR`(부자재작업·MTRL_CD=SXANB001 자재코드 동반) — **두 PCS 그룹 모두 부자재+부착공정 BUNDLE**(메모리 "옵션=자재+공정 BUNDLE" 동형). 고리는 **수십종 enum**(KR040+CN+CR — ST SUB_MTR_KR/CN/CR과 동일 코드체계 공유!). base_data_tag = 부자재(고리/받침 enum) + 공정(부착/조립). **★ST 키링 SUB_MTR(§0.4 동형)과 코드 공유 — 굿즈/스티커/아크릴 횡단 "부자재 카탈로그" 공유.** (A-4)

### 0.5 ★인쇄면(print_data 앞뒤같음/다름) + 화이트언더베이스(PRT_WHT) = 투명소재 종속
투명 아크릴 인쇄 특화 2축(`[reuse:productInfo]` ACTHDKY·ACPDSTD):
- **인쇄면(`option_info.print_data`)**: [O 앞뒤 인쇄 같음 / X 앞뒤 인쇄 다름] — ACTHDKY widgetDump buttons "앞뒤 인쇄 같음/앞뒤 인쇄 다름" 실측. 투명 아크릴은 양면 시야 → 앞뒤 인쇄 데이터 동일/상이 선택. base_data_tag = 옵션(인쇄면) or 기초코드(인쇄면 enum).
- **화이트인쇄(`PRT_WHT`)**: ACTHDKY·ACPDSTD에 화이트인쇄 PCS(VIEW_YN=Y·ESN_YN=N) — 투명/유색 아크릴 위 색 표현을 위한 화이트 언더베이스. NOTICE="PDF: 화이트레이어 자동적용 / 에디터: 이미지맞춤". base_data_tag = 공정(화이트언더베이스). ★ST DTF 화이트강제(§0.5)·PR/AC 동형 — 투명소재→화이트 캐스케이드.

→ 인쇄면·화이트는 **투명 아크릴 종속 축**(불투명 명찰 ACNTHAP은 print_data 전부 null·화이트 없음). base_data_tag = 옵션/공정 + 제약(투명소재→화이트 가용). (A-5)

### 0.6 ★3개 가격엔진(item_gbn/price_gbn) = 한 카테고리 3모델 공존
AC 한 카테고리에 **3개 다른 item_gbn/price_gbn**이 공존(`[reuse:productInfo]` 3 캡처 헤더 실측):

| 상품 | item_gbn | price_gbn | 의미 | 형태 |
|------|----------|-----------|------|------|
| **ACNTHAP** 명찰 | `vDigital_item` | `vTmpl_price` | 프리셋사이즈 템플릿가 | 라벨형(아크릴합지) |
| **ACTHDKY** 키링 | `acrylic2025_item` | `acrylic2025_price` | ★아크릴 전용 엔진(면적·두께·소재 산정) | die-cut 자유사이즈 |
| **ACPDSTD** 등신대 | `edicus_item` | `tmpl_price` | 에디터+완제템플릿가 | 평면+받침 |

★`acrylic2025_price`는 **아크릴 전용 가격엔진**([huni-ref] PRF_CLR_ACRYL 투명아크릴 공식·면적매트릭스·두께 mat_cd 분기와 정합). 명찰(vTmpl_price)·등신대(tmpl_price)는 다른 엔진. base_data_tag = (가격)엔진분기. **★ST 판/die-cut/정가 3엔진(§0.6)·GS tmpl·CL clothes2025_price와 합류 — RedPrinting 카테고리별 전용 가격엔진(2025 세대) 패턴.** (A-6)

---

## 1. ACNTHAP — 아크릴 명찰 (★라벨형·뒷면부착물·프리셋사이즈 대표) `[reuse:productInfo]` 풀
source: `_workspace/huni-widget/01_reverse/captures/product_ACNTHAP.json` 풀 infoCall.

```
product: ACNTHAP 아크릴 명찰 (AC)   item_gbn: vDigital_item   price_gbn: vTmpl_price   PDT_UNIT: pcs
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=N · usePDFordCnt=Y · useTemplateDownload=N · cut_guide_yn=N · price_table_yn=Y
axes:
  - axis: 자재(소재)        # pdt_mtrl_info 단일 실측
    choices: [RXIGC075 고투명 PET 리무버블 75g]   MTRL_TYPE=R · PTT=IGC(고투명PET리무버블) · WGT=075
    base_data_tag: 자재(PET 리무버블·단일)
    note: ★명찰은 "아크릴" 명이나 본체 자재=고투명 PET 리무버블(R-type 라벨) + 아크릴합지(BON_PAP) 공정으로 아크릴 효과.
          즉 본체=PET 라벨, 아크릴감=합지 공정. (불투명 PET → print_data/화이트 없음·§0.5 대조)
  - axis: 사이즈 (size)        # ★pdt_size_info 프리셋 2종
    choices: [소 70X25(WRK 72X27·기본 DFT_YN=Y), 중 75X25(WRK 77X27)]
    base_data_tag: 사이즈(프리셋) + 기초코드(규격 enum)
    note: ★자유사이즈 아님 — 프리셋 명찰 규격(MIN_CUT 70X25~MAX_CUT 148X210). DIV_NM "소/중" 라벨.
  - axis: 도수 (dosu)        # pdt_dosu_info — 숨김(dosuSelect view_yn=N)
    choices: [SID_S 단면 4색]   base_data_tag: 기초코드(도수·고정)
  - axis: 아크릴합지 (BON_PAP)        # ★pdt_pcs_info 접착 그룹
    choices: [ACXXS 아크릴합지]   ESN_YN=Y(필수) · VIEW_YN=N   base_data_tag: 공정(합지) + 자재(아크릴 시트)
    note: ★PET 인쇄물에 아크릴 시트 합지 = 하드커버 효과(NOTICE "두꺼운 표지 합지 프리미엄"). 명찰의 "아크릴" 정체.
  - axis: 레이저 재단 (LAS_DFT)        # pdt_pcs_info
    choices: [DFXXX 레이저]   ESN_YN=Y · VIEW_YN=N   base_data_tag: 공정(레이저 재단)
    note: NOTICE "A3 1미터 이하 커팅 기준 자동견적·파일 업로드 후 최종견적".
  - axis: ★뒷면 부착물 (WRK_MTR 부자재작업)        # ★pdt_pcs_info 2종·VIEW_YN=Y
    choices: [NBPIN 옷핀 집게(MTRL_CD=SXANB001), NBMGN 마그넷(MTRL_CD=SXANB002)]
    WEB_PCS_DTL_GRP_NM="뒷면자재" · SUB_MTRL_YN=Y · ESN_YN=Y(부착 필수·택1 추정)
    base_data_tag: 부자재(부착물 옷핀/마그넷) + 공정(부착)
    note: ★명찰을 옷/표면에 다는 부착물. 자재코드(SXANB001/002) 동반 = 자재+공정 BUNDLE(§0.4·메모리 동형).
캐스케이드 제약 (★pdt_disable_pcs_info 3건 실측):
  - {MTRL_CD=RXIGC075, PCS_CD=COT_DFT(코팅)} · {MTRL_CD=RXIGC075, PCS_CD=MIS_DFT(미싱)} · {MTRL_CD=RXIGC075, PCS_CD=SCO_DFT(부분UV)}
  base_data_tag: 제약(자재→후가공 disable)
  note: ★고투명PET리무버블 선택 시 코팅/미싱/부분UV 비활성(ST disable 동형·소재→후가공 호환).
수량: skinInfo quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"} · prn_cnt FIR 1·INC 1·INC_STEP 10
  base_data_tag: 옵션(이중수량 — 디자인수×수량)
가격 모델 (vTmpl_price): 프리셋 명찰 규격 템플릿가(price_table_yn=Y). [reuse:qtysweep] qtysweep_ACNTHAP.json 참조(수량 가격).
```
**메타모델 시사점:** 아크릴 명찰 = **PET 라벨 본체 + 아크릴합지(BON_PAP 공정으로 아크릴화) + 프리셋사이즈(소/중) + 뒷면 부착물(옷핀/마그넷 WRK_MTR BUNDLE) + 레이저재단 + disable 3건**. ★"아크릴 명찰"이 실제로는 PET+합지 = **상품명의 소재≠본체 자재**(GS 코스터·CL 의류 동형). 부착물=WRK_MTR 부자재+공정 BUNDLE. `_ambiguous-fragments.md` A-4(부착물)·A-7(상품명 소재 vs 본체자재) 등재.

---

## 2. ACTHDKY — 아크릴 키링 (★두께·소재variant·완칼·고리 정점·전용 가격엔진 대표) `[reuse:productInfo]` 풀
source: `_workspace/huni-widget/05_qa/captures/major_radius_ACTHDKY.json` 풀 rawProductData + widgetDump.

```
product: ACTHDKY 아크릴 키링 (AC)   item_gbn: acrylic2025_item   price_gbn: acrylic2025_price   PDT_UNIT: 개
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=Y · useTemplateDownload=Y · usePDFordCnt=Y · able_paper_yn=Y · price_table_yn=Y
axes:
  - axis: ★두께×소재 (자재 material)        # ★pdt_mtrl_info 6종 + widgetDump select[material]
    choices(widget 노출 2): [PXAATD01 아크릴_3T 투명, PXAATD02 아크릴_5T 투명]
    choices(전체 6 = 두께×가공): [PXAATD01 3T투명/일반, PXAATD02 5T투명/일반,
              PXAATL01 3T투명 라미(2T+1T), PXAATL02 5T투명 라미(4T+1T),
              PXAATL03 홀로그램3T 깨진유리 라미(1T+2T), PXAATL04 홀로그램3T 격자 라미(1T+2T)]
    base_data_tag: 자재(소재 PTT_CD=AAT[리터럴] × 두께 WGT_CD=D01/D02[리터럴] × 표면 holographic[MTRL_NM 유도] × 가공 라미[GRP_OPTION_CD])
    note: ★directive 최대 관전 — 두께(3T/5T)=MTRL_CD의 WGT_CD 슬롯(D01/D02)·별 축 아님(§0.1).
          홀로그램(깨진유리/격자)=라미 표면효과 소재 variant(§0.2). GRP_OPTION_CD가 일반/라미를 묶음(production_method).
  - axis: ★가공방식 (production_method / GRP_OPTION_CD)        # ★option_info.production_method 실측
    choices: [MTG_DFT 일반, MTG_LAM 라미]   base_data_tag: 옵션(가공방식) or 공정(라미네이팅)
    note: ★자재행 GRP_OPTION_CD로 자재를 가공방식 그룹으로 묶음. widgetDump buttons "일반/라미" 실측.
          라미(MTG_LAM)=홀로그램/투명 위 라미네이션 합지(2T+1T 등 = 두께 합성). 가공방식↔자재 종속.
  - axis: ★완칼/자유형 레이저 (LAS_DFT)        # ★pdt_pcs_info 실측
    choices: [FRXXX 자유형 레이저]   ESN_YN=Y · VIEW_YN=N · STICKER_TYPE=FR   base_data_tag: 공정(완칼·자유형레이저) + 기초코드(칼선=자유)
    note: ★아크릴 키링=디자인 외곽 따라 자유형 레이저 절단(=완칼·ST THO_GRA/FRXXX 동형 코드).
          NOTICE "A3 1미터 이하 커팅 기준". 정형 칼틀(ST THO_DFT) 아닌 자유칼선.
  - axis: 사이즈 (size)        # pdt_size_info — 사이즈직접입력
    choices: [사이즈직접입력 — DFT 40×40·WRK 44×44·MIN 20×20~MAX 90×90]
    base_data_tag: 사이즈(자유입력) + 제약(MIN/MAX 범위)
    note: 자유사이즈(키링 외곽 기준). base_info CUT_MRG 4.
  - axis: 도수 (dosu)        # pdt_dosu_info — widget select[dosu]
    choices: [SID_S 단면 4색]   base_data_tag: 기초코드(도수·고정)
  - axis: ★인쇄면 (print_data)        # ★option_info.print_data 실측
    choices: [O 앞뒤 인쇄 같음, X 앞뒤 인쇄 다름]   base_data_tag: 옵션(인쇄면) or 기초코드(인쇄면 enum)
    note: ★투명 아크릴 양면 시야 → 앞뒤 데이터 동일/상이(§0.5). widgetDump buttons "앞뒤 인쇄 같음/다름" 실측.
  - axis: 화이트인쇄 (PRT_WHT)        # pdt_pcs_info
    choices: [DFXXX 화이트인쇄]   VIEW_YN=Y · ESN_YN=N   base_data_tag: 공정(화이트언더베이스)
    note: 투명 위 색 표현 화이트 베이스(§0.5).
  - axis: 폴리백 개별포장 (PAK_POL)        choices: [DFXXX 폴리백 개별포장]   base_data_tag: 공정(포장)
  - axis: ★고리 부착물 (SUB_MTR 추가부자재)        # ★pdt_pcs_info 80+ 항목 실측
    choices(WEB_PCS_DTL_GRP별): 
      [카라비너고리(BN001), 열쇠고리(KR001~040: 자물쇠/컬러자물쇠세트/해골/하트/별/달/고양이/민자링/기본링·원형카라비너),
       컬러구슬줄(CN009~030 색 variant·QTY_INPUT_YN=Y), 컬러와이어링(CR015~029 색 variant·QTY_INPUT_YN=Y)]
    SUB_MTRL_YN=Y · VIEW_YN=Y · ESN_YN=N(선택)
    base_data_tag: 부자재(고리/끈 enum) + 공정(부착/조립)
    note: ★AC 부착물 정점(80+ 항목). KR/CN/CR 코드체계 = ST SUB_MTR_KR/CN/CR 공유(§0.4·횡단 부자재 카탈로그).
          NOTICE "고리 지름 구멍 2.5mm(와이어링 3.5mm)·O링 조립" = 부착 가능 제약. 구슬줄/와이어링=수량입력.
캐스케이드 제약: pdt_disable_pcs_info=[](키링 disable 없음·ACNTHAP 3건과 대조)
수량: quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"} · PRN_CNT widget select(1~10)
  base_data_tag: 옵션(이중수량)
가격 모델 (★acrylic2025_price): ★아크릴 전용 엔진. [huni-ref] 면적매트릭스(투명3T/1.5T mat_cd 분기·PRF_CLR_ACRYL)와 정합.
  note: 두께(WGT)·소재(PTT)·인쇄면·고리가 가격 입력. 비로그인 PRICE 미캡처(세션·구조 무관).
```
**메타모델 시사점:** 아크릴 키링 = **두께×소재 자재(6종·3T/5T×일반/라미/홀로그램) + 가공방식(일반/라미 GRP_OPTION) + 완칼 자유형레이저(FRXXX) + 자유사이즈 + 인쇄면(앞뒤같음/다름) + 화이트 + 고리 80+ 부착물(KR/CN/CR ST 공유) + 전용 acrylic2025_price 엔진**. ★두께=자재 WGT 슬롯·입체성 없음(평면 키링)·소재 variant는 자재 PTT/라미. `_ambiguous-fragments.md` A-1(두께)·A-2(소재variant)·A-4(고리)·A-6(전용엔진)·A-8(가공방식 라미) 등재.

---

## 3. ACPDSTD — 아크릴 등신대 (★입체/스탠드·받침 부자재·에디터+완제템플릿 대표) `[reuse:productInfo]` 풀
source: `_workspace/huni-widget/05_qa/captures/major_acc_ACPDSTD.json` 풀 rawProductData + widgetDump.

```
product: ACPDSTD 아크릴 등신대 (AC)   item_gbn: edicus_item   price_gbn: tmpl_price   PDT_UNIT: pcs
디자인 입력 (실측 플래그): useKoiEditor=Y · useRPEditor=N · usePDF=Y · useTemplateDownload=Y · usePDFordCnt=Y · able_paper_yn=Y · price_table_yn=N
axes:
  - axis: 자재(소재)        # ★pdt_mtrl_info 단일
    choices: [PXACR016 아크릴_3T 투명]   PTT=ACR · WGT=016 · CLR=X(없음)
    base_data_tag: 자재(투명 아크릴·단일·3T)
    note: ★등신대 본체=평면 3T 투명 아크릴 단일(키링 6종 대비 단순). 두께 선택 없음(3T 고정).
  - axis: 사이즈 (size)        # pdt_size_info — 사이즈직접입력
    choices: [사이즈직접입력 — DFT 50×20·MIN 10×10~MAX 300×250]
    base_data_tag: 사이즈(자유입력·대형) + 제약(MIN/MAX)
    note: ★대형(최대 300×250mm) 자유사이즈 — 등신대=사람크기 평면. base_info INC 5·INC_STEP 11.
  - axis: 도수 (dosu)        # pdt_dosu_info — 숨김(dosuSelect view_yn=N)
    choices: [SID_S 단면 4색]   base_data_tag: 기초코드(도수·고정)
  - axis: 레이저 재단 (LAS_DFT)        # pdt_pcs_info
    choices: [DFXXX 레이저]   ESN_YN=Y · VIEW_YN=N   base_data_tag: 공정(레이저 재단·완칼)
  - axis: ★등신대 받침대 (SUB_MTR 추가부자재)        # ★pdt_pcs_info 12종·widgetDump select 실측
    choices: [AB005 원형-S, AB009 원형-M, AB013 원형-L, AB006 타원형-S, AB010 타원형-M, AB014 타원형-L,
              AB007 사각형-S, AB011 사각형-M, AB015 사각형-L, AB008 육각형-S, AB012 육각형-M, AB016 육각형-L]
    WEB_PCS_DTL_GRP_NM="등신대 받침대" · MTRL_CD=SXAPR005~016 · SUB_MTRL_YN=Y · ESN_YN=Y(필수) · QTY_INPUT_YN=Y
    base_data_tag: 부자재(받침 형상×크기 SKU enum) + 공정(거치/조립)
    note: ★등신대=평면본체를 세우는 받침이 핵심(§0.3). 받침=형상(원형/타원/사각/육각)×크기(S/M/L) 매트릭스 12 SKU.
          받침 자재코드 SXAPR005~016 동반·WRK/CUT 사이즈 보유(받침 자체 규격) = 본체와 분리된 부자재 SKU.
          ESN_YN=Y(필수) — 등신대는 받침 필수(키링 고리=선택과 대조). widget select "SUM_MTR/등신대 받침대" 12옵션 실측.
  - axis: 화이트인쇄 (PRT_WHT)        # pdt_pcs_info
    choices: [DFXXX 화이트인쇄]   VIEW_YN=Y · ESN_YN=N   base_data_tag: 공정(화이트언더베이스)
캐스케이드 제약: pdt_disable_pcs_info=[] · option_info.production_method/shape/print_data 전부 null
  note: ★등신대는 가공방식/인쇄면 슬롯 없음(단순 평면+받침). 키링(라미/인쇄면)과 구조 대조.
수량: quantityGroup={"orderCnt":"디자인 수 (건수)","printCnt":"수량"} · prn_cnt FIR 1·INC 5·INC_STEP 11
  base_data_tag: 옵션(이중수량)
가격 모델 (tmpl_price): 완제 템플릿가(price_table_yn=N). 받침 SUB_MTR 가산(QTY_INPUT_YN=Y·수량별).
```
**메타모델 시사점:** 아크릴 등신대 = **평면 3T투명 본체(단일자재) + 대형 자유사이즈(300×250) + 받침대 12 SKU(형상×크기·필수 ESN=Y·부자재BUNDLE) + 레이저완칼 + 화이트 + edicus_item/tmpl_price**. ★입체성 = 받침 부자재가 평면을 세움(§0.3 — distinct 3D축 아님, 받침=부자재). 받침은 ESN_YN=Y(필수)·QTY_INPUT_YN=Y(수량) = ACTHDKY 고리(선택)·코롯토(자체 두께블록)와 입체 인코딩 3방식 대조. `_ambiguous-fragments.md` A-3(입체/받침)·A-4(부자재) 등재.

---

## 4. AC 17상품 그룹 횡단 태깅 (키링류·코롯토스탠드·부착물·명찰등신대·템플릿 렌즈 — 답습 회피)

> 대표 3상품(§1~3)으로 추출한 축을 나머지 17상품에 렌즈 적용. catalog 모집단 = **category=AC 20상품**(전부 /item/AC/·코드접두 AC≠카테고리 누수 0). 옵션 상세는 `[reuse:productInfo]` 실측분(ACNTHAP/ACTHDKY/ACPDSTD) 외 전부 `[live:catalog]` 상품명 + 동형 추정(unobserved).

### 그룹 A — 키링류 (ACTH*KY·9상품·소재 variant 스펙트럼·§2 동형)
| pdtCode | 상품명 | 소재 variant | 두께/완칼 | base_data_tag | 출처 |
|---------|--------|-------------|----------|---------------|------|
| **ACTHDKY** | 아크릴 키링 | 투명/홀로그램(깨진유리·격자) 6종 | 3T/5T·자유형레이저 | §2 풀 | `[reuse:productInfo]` |
| ACTHCKY | 유색 아크릴 키링 | ★유색(단색 컬러 아크릴) | 추정 3T/5T·완칼 | 자재(유색) + §2 | `[live:catalog]` unobs |
| ACTHGKY | 글리터 아크릴 키링 | ★글리터(반짝이 봉입) | 추정 라미 | 자재(글리터 표면) + §2 | `[live:catalog]` unobs |
| ACTHMKY | 거울 아크릴 키링 | ★거울(미러·[huni-ref] MIRROR3T) | 추정 3T | 자재(미러) + §2 | `[live:catalog]` unobs([huni-ref] MIRROR3T comp 실재) |
| ACTHPKY | 자개 아크릴 키링 | ★자개(자개무늬) | 추정 라미 | 자재(자개 표면) + §2 | `[live:catalog]` unobs |
| ACTHLKY | 렌티큘러 아크릴 키링 | ★렌티큘러(각도 변화) | 추정 합지 | 자재(렌티큘러 시트) + §2 | `[live:catalog]` unobs |
| ACTHPAM | 파스텔 뮤트 키링 | ★파스텔 뮤트 | 추정 라미 | 자재(파스텔) + §2 | `[live:catalog]` unobs |
| ACTHPAA | 파스텔 아스텔 키링 | ★파스텔 아스텔 | 추정 라미 | 자재(파스텔) + §2 | `[live:catalog]` unobs |
| ACTHPEN | 아크릴 젤펜 | (펜 본체+아크릴 토퍼) | unobs | 자재 + 부자재(펜) + §2 | `[live:catalog]` unobs |
> ★키링류 = ACTHDKY(§2 풀)의 소재 variant 스펙트럼(유색/글리터/거울/자개/렌티큘러/파스텔)이 **별 pdtCode로 분리**(§0.2). 구조(완칼·고리·인쇄면·화이트·acrylic2025) 동형, 소재 표면효과만 차이. 젤펜(ACTHPEN)=펜 완제+아크릴 토퍼 결합(부자재형).

### 그룹 B — 코롯토/스탠드 (ACTH*CO·4상품·입체 variant·§0.3)
| pdtCode | 상품명 | 입체 인코딩 | base_data_tag | 출처 |
|---------|--------|------------|---------------|------|
| ACTHDCO | 두꺼운 아크릴 코롯토 (스탠드) | ★두께블록(8T급·자립) | 자재(두꺼운 아크릴) + 카테고리(코롯토) | `[live:catalog]` unobs([huni-ref] B06 코롯토 매트릭스) |
| ACTHBCO | 양면 아크릴 코롯토 (스탠드) | ★양면(앞뒤 인쇄·자립) | 옵션(인쇄면=양면) + 자재 | `[live:catalog]` unobs |
| ACTHFCO | 입체 아크릴 코롯토 (스탠드) | ★입체조형(다층/곡면) | 공정(입체가공) + 자재 | `[live:catalog]` unobs(★프롬프트 입체 대표·SSR-neg 확인) |
| ACTHLCO | 렌티큘러 아크릴 코롯토 | ★렌티큘러+코롯토 | 자재(렌티큘러) + 카테고리(코롯토) | `[live:catalog]` unobs |
> ★코롯토군 = 입체/자립 아크릴 블록(§0.3). 입체성이 ① 두께블록(DCO) ② 양면(BCO=print_data) ③ 입체조형(FCO) ④ 렌티큘러(LCO) variant로 분기. [huni-ref] 코롯토 6×6 면적매트릭스(30~80mm)·PRF_COROTTO_ACRYL 신규 공식. ★입체=두께 facet+공정 — distinct 3D축 아님(§0.3·A-3).

### 그룹 C — 부착물/마그넷/뱃지 (ACPD*·4상품·§0.4 부자재·등신대)
| pdtCode | 상품명 | 부착/형태 | base_data_tag | 출처 |
|---------|--------|----------|---------------|------|
| **ACPDSTD** | 아크릴 등신대 | ★평면+받침대 12 SKU(자립) | §3 풀 | `[reuse:productInfo]` |
| ACPDAMG | 아크릴 마그넷(통자석) | ★통자석(자성시트 합지) | 자재(자석) + 공정(합지) | `[live:catalog]` unobs(ST STMADFT 동형) |
| ACPDMGN | 아크릴 마그넷 | ★마그넷(자석 부착) | 부자재(자석) + 공정(부착) | `[live:catalog]` unobs |
| ACPDPIN | 아크릴 뱃지 | ★핀 부착(뱃지핀) | 부자재(핀) + 공정(부착) | `[live:catalog]` unobs |
| ACPDJOY | 아크릴 조이톡 | ★스마트톡(그립톡 부속) | 부자재(조이톡 그립) + 공정(부착) | `[live:catalog]` unobs |
> ★부착물군 = 아크릴 본체 + 부착 부속(받침/자석/핀/그립톡). 마그넷 2종(통자석 ACPDAMG=자성시트 합지·일반 ACPDMGN=자석 부착) 분기. 조이톡(ACPDJOY)=스마트폰 그립톡 부속. 등신대 받침(§3)이 부착물 정점(12 SKU 필수). ★ST STMADFT(통자석)·GS 뱃지핀과 합류 — 부자재 BUNDLE 횡단.

### 그룹 D — 명찰 + 템플릿 (3상품·라벨형·완제템플릿)
| pdtCode | 상품명 | 형태 | base_data_tag | 출처 |
|---------|--------|------|---------------|------|
| **ACNTHAP** | 아크릴 명찰 | ★PET라벨+아크릴합지·뒷면 옷핀/마그넷 | §1 풀 | `[reuse:productInfo]` |
| ACTHPEN | 아크릴 젤펜 | (그룹A 중복 — 펜+토퍼) | 자재+부자재 | `[live:catalog]` unobs |
| **ACTPKEY** | 아크릴 키링 템플릿 | ★키링 디자인 템플릿(에디터 자산) | 템플릿/SKU(디자인 자산) + (TP #16 디자인입력채널) | `[live:catalog]` unobs |
> ★ACTPKEY = "아크릴 키링 템플릿" — TP(디자인템플릿) 카테고리가 아닌 AC에 속한 **에디터 디자인 자산형** 상품(TP #16 디자인입력채널·"디자인 시안≠완제SKU" 이중의미 분리와 합류). 명찰(ACNTHAP)=PET라벨+합지 라벨형(아크릴 명이나 본체 PET).

---

## 5. base-data 축 횡단 종합 (메타모델 아키텍트 입력 — AC 추가분, BN·GS·TP·PR·ST·CL 표와 병합)

| 관리 축 | RedPrinting 표현(AC) | base_data_tag | 메타모델 흡수 단위 | 기존 카테고리 대비 신규? |
|---------|---------------------|---------------|-------------------|------------------------|
| **★두께(thickness)** | `pdt_mtrl_info` MTRL_CD의 WGT_CD 슬롯(D01=3T/D02=5T·L01~04 라미) — widget select material에 "3T/5T"로 노출 | 자재(두께 = WGT 차원) | 아크릴 두께를 자재 WGT 슬롯 재활용 | **facet(자재#1의 WGT 차원·distinct #19 아님 — A-1)** |
| **★아크릴 소재 variant** | 자재 PTT(AAT/ACR)+표면(홀로그램/글리터/거울/자개/렌티큘러/파스텔/유색) — 자재 enum + 소재특화 pdtCode 양면 | 자재(소재 PTT × surface-finish) + 카테고리(특화상품) | 소재 표면효과 차원 | **facet(자재 surface-finish·ST 점착소재 동형·A-2)** |
| **★입체/스탠드(3D)** | ① 받침 부자재(ACPDSTD 12 SKU) ② 코롯토 두께블록(ACTHDCO) ③ 양면(ACTHBCO=print_data) ④ 입체조형(ACTHFCO) | 부자재(받침 BUNDLE) + 자재(두께) + 옵션(인쇄면) + 카테고리(코롯토) | 평면→입체 변환(받침/두께/조형) | **분산 facet(받침=부자재·두께=자재·양면=인쇄면·distinct #19 아님 — A-3)** |
| **★완칼/자유형 레이저** | `LAS_DFT`/FRXXX(자유형 레이저·STICKER_TYPE=FR) | 공정(완칼·레이저절단) + 기초코드(칼선=자유) | 디자인 외곽 아크릴 절단 | (ST THO_GRA/FRXXX 동형·아크릴 절단 — 재단입자축 합류) |
| **★부착물(고리/받침/자석/핀)** | `SUB_MTR`(고리 KR/CN/CR 80+·받침 AB 12)·`WRK_MTR`(명찰 뒷면 SXANB) — 자재코드+부착공정 BUNDLE | 부자재(부착물 enum) + 공정(부착/조립) | 본체와 분리된 부속 SKU | (ST SUB_MTR_KR/CN/CR 코드공유·GS 동형·AC 정점 80+ — A-4) |
| **★가공방식(일반/라미)** | `option_info.production_method`(MTG_DFT/MTG_LAM) — GRP_OPTION_CD가 자재를 가공그룹으로 묶음 | 옵션(가공방식) or 공정(라미네이팅) | 라미네이션 합지(두께 합성) | ★신규(자재 그룹핑 슬롯 — A-8) |
| **★인쇄면(앞뒤같음/다름)** | `option_info.print_data`(O 같음/X 다름) — 투명 양면 시야 | 옵션(인쇄면) or 기초코드(인쇄면 enum) | 양면 데이터 동일/상이 | (CL print 방식·PR 양면과 경계·투명소재 종속 — A-5) |
| **화이트언더베이스** | `PRT_WHT`(투명/유색 위 화이트 베이스·불투명 명찰엔 없음) | 공정(화이트인쇄) + 제약(투명소재 종속) | 투명소재 위 색 표현 | (ST DTF·PR·AC 동형·투명소재 캐스케이드 — A-5) |
| **★3 가격엔진 공존** | vTmpl_price(명찰)·acrylic2025_price(키링)·tmpl_price(등신대) — 한 카테고리 3엔진 | (가격)엔진분기 | 형태별 전용 가격엔진 | (ST 3엔진·CL clothes2025·GS tmpl 합류·2025세대 패턴 — A-6) |
| **disable 제약(자재→후가공)** | `pdt_disable_pcs_info`(명찰 PET→코팅/미싱/부분UV disable 3건·키링/등신대 0건) | 제약(disable) | 소재→후가공 호환 | (ST 227·PR 24 동형·AC 소규모) |
| **프리셋 vs 자유 사이즈** | 명찰=프리셋(소/중)·키링/등신대=자유사이즈(MIN/MAX) | 사이즈(프리셋 enum / 자유입력+제약) | 규격 vs 자유 | (ST 판/die-cut·PR 규격/면적 합류) |
| **합지(BON_PAP)** | 명찰 `BON_PAP`/ACXXS 아크릴합지(PET에 아크릴 시트 합지=아크릴화) | 공정(합지) + 자재(아크릴 시트) | 인쇄물+소재 합지 | ★신규(GS 파우치조립·PR 합지와 경계·"상품명소재≠본체자재" — A-7) |
| **이중수량** | quantityGroup={"orderCnt":"디자인 수(건수)","printCnt":"수량"} | 옵션(이중수량) | 디자인수×수량 | (전 카테고리 공통·신규 아님) |
| **디자인 입력 채널** | useKoiEditor(명찰/키링/등신대 전부 Y)·usePDF(명찰 N·키링/등신대 Y)·ACTPKEY 템플릿 | (TP #16 디자인입력채널) | 에디터 채널 상품별 분기 | (TP #16 축 AC 적용·신규 아님) |

### 핵심 패턴 (RedPrinting의 AC 정규화 방식)
1. **★두께 = 자재 WGT 슬롯 재활용** — 3T(D01)/5T(D02)/라미(L01~04)를 MTRL_CD WGT_CD에 인코딩. 별 두께축 아님(자재 facet). 후니 [huni-ref]도 mat_cd 차원으로 동형 처리. ★directive 최대 관전 1차 판정 = distinct #19 아님.
2. **★소재 variant = 자재 surface-finish + 소재특화 pdtCode** — 투명/홀로그램/유색/글리터/거울/자개/렌티큘러/파스텔이 ① 자재 enum(ACTHDKY 6종) ② 특화 상품(ACTH*KY 9종) 양면. ST 점착소재 spectrum 동형(자재 facet).
3. **★입체/스탠드 = 분산 인코딩** — 받침(부자재 SUB_MTR·평면을 세움)·두께블록(코롯토 자립)·양면(print_data)·입체조형(코롯토 FCO). distinct 3D축 아님 — 받침=부자재·두께=자재·양면=인쇄면 facet 분산. ★directive 최대 관전 2차 판정.
4. **★완칼 = 자유형 레이저(LAS_DFT/FRXXX)** — ST THO_GRA/FRXXX와 동일 코드. 아크릴 디자인 외곽 절단 = 완칼. ST 재단입자축(반칼/완칼)에서 아크릴=완칼(자유레이저) 일원.
5. **★부착물 = SUB_MTR/WRK_MTR 부자재+공정 BUNDLE 정점** — 고리 80+(KR/CN/CR ST 공유)·받침 12(AB)·뒷면 옷핀/마그넷(SXANB)·자석/핀/그립톡. 자재코드 동반 = 메모리 "옵션=자재+공정 BUNDLE" 동형. AC가 부자재 카탈로그 정점(키링 80+).
6. **★전용 가격엔진(acrylic2025_price)** — 아크릴 키링이 카테고리 전용 가격엔진(면적·두께·소재 산정). 명찰(vTmpl)·등신대(tmpl)와 3엔진 공존. CL clothes2025_price·ST 3엔진과 합류 — "2025세대 카테고리 전용 가격엔진" 패턴.

## 라이브 접속 결과 (정직 기록)
- **ACNTHAP/ACTHDKY/ACPDSTD**: ★`[reuse:productInfo]` 풀 — huni-widget 캡처에 pdt_mtrl_info(두께×소재 6/단일)·pdt_size_info(프리셋/자유)·pdt_pcs_info(BON_PAP합지·LAS_DFT완칼·SUB_MTR 고리80+/받침12·WRK_MTR뒷면·PRT_WHT)·option_info(production_method 일반/라미·print_data 앞뒤)·disable·widgetDump select 전부 실측. item_gbn 3종(vDigital/acrylic2025/edicus)·price_gbn 3종(vTmpl/acrylic2025/tmpl) 헤더 실측.
- **ACTHFCO 라이브 GET(2026-06-17)**: HTTP 200·354KB·select 2개(전역 km1_size 샘플)·거울/글리터/두께/받침/스탠드/입체/코롯토/투명 텍스트는 **정적 마케팅 카피**(옵션 select 아님) → 신규 Vue client-render = `[live:SSR-negative]`. 입체/받침 실옵션 미노출(ACPDSTD 캡처로 받침 12 SKU 확정).
- **BFF API**: 익명 호출 불가(BN/GS/TP/PR/ST/CL 동일·세션인증 BFF 뒤·캡처 토큰 만료).
- **소재특화 키링/코롯토(ACTHGKY/MKY/PKY/CKY/LKY/PAM/PAA·ACTHDCO/BCO/FCO/LCO) 옵션**: catalog 상품명으로 소재/입체 variant축 확정, 옵션 상세는 `[live:catalog]` unobs(ACTHDKY 실측 동형 추정·거울은 [huni-ref] MIRROR3T 실재).

## 미관측(unobserved) 요약 — AC
- **소재특화 키링(ACTHGKY 글리터·ACTHMKY 거울·ACTHPKY 자개·ACTHCKY 유색·ACTHLKY 렌티큘러·ACTHPAM/PAA 파스텔) 자재코드·두께** — ACTHDKY 6소재(투명/홀로그램) 실측, 글리터/거울/자개/유색/렌티큘러/파스텔 MTRL_CD·WGT(두께)·가격 unobserved(소재 variant 동형 추정·거울은 [huni-ref] COMP_ACRYL_MIRROR3T 실재).
- **코롯토(ACTHDCO/BCO/FCO/LCO) 입체 옵션/두께/가격** — [huni-ref] 코롯토 6×6 면적매트릭스(30~80mm·PRF_COROTTO_ACRYL 신규)만 참조. 입체조형(FCO) 공정·양면(BCO) 인쇄·두께블록(DCO 8T) MTRL_CD·자립방식 unobserved.
- **마그넷/뱃지/조이톡/젤펜(ACPDAMG/MGN/PIN/JOY·ACTHPEN) 부착 공정·부자재** — 통자석 합지(ACPDAMG·ST STMADFT 동형)·자석부착(ACPDMGN)·뱃지핀(ACPDPIN)·그립톡(ACPDJOY)·펜토퍼(ACTHPEN) 부자재코드·공정 unobserved.
- **ACTPKEY 키링 템플릿** — "아크릴 키링 템플릿"=에디터 디자인 자산형 추정(TP #16), 템플릿 자산 카탈로그·VDP unobserved.
- **두께 8T(8mm) 가격** — [huni-ref] 8T 자재(MAT_000044) 마스터엔 있으나 가격표 본체 8T 단가매트릭스 부재(가격 미정 소재). RP 측 8T 상품 매핑 unobserved.
- **AC 전반 PRICE>0 실가** — 비로그인 캡처(PRICE 미캡처·세션결함·구조 무관). acrylic2025_price 산정식은 [huni-ref] 면적매트릭스(투명3T/1.5T mat_cd) 참조.

## AC 미샘플 상품 (20종 중 대표 3 원자추출·17 그룹 횡단 — 답습 회피)
키링류 8(ACTHCKY·ACTHGKY·ACTHMKY·ACTHPKY·ACTHLKY·ACTHPAM·ACTHPAA·ACTHPEN)·코롯토 4(ACTHDCO·ACTHBCO·ACTHFCO·ACTHLCO)·부착물 4(ACPDAMG·ACPDMGN·ACPDPIN·ACPDJOY)·템플릿 1(ACTPKEY) — 구조 다양성(두께×소재 6·소재 variant 7표면·입체 3방식·완칼·부착물 80+·가공방식 라미·인쇄면·화이트·3가격엔진)은 대표 3(명찰=라벨/합지·키링=두께/소재/완칼/고리·등신대=입체/받침) 풀 실측으로 커버. 메타모델 검증 시 갭(소재특화 키링 자재코드·코롯토 입체 공정·마그넷/뱃지 부착·8T 가격)은 로그인 캡처로 추가.

### 대표 3 superset 여부 + 누락 축
- **두께(§0.1)·소재variant(§0.2)·완칼(§0.4)·고리부착물(§0.4)·가공방식(§0.6)·인쇄면(§0.5)·화이트(§0.5)·전용엔진(§0.6)** = ACTHDKY(§2)가 superset.
- **입체/받침(§0.3)·대형자유사이즈·필수부자재** = ACPDSTD(§3)가 superset.
- **라벨/합지·프리셋사이즈·뒷면부착물·disable** = ACNTHAP(§1)가 superset.
- **누락 축(대표 3 미커버, 횡단 추정)**: ① 코롯토 입체조형(FCO) 공정 ② 양면 코롯토(BCO) 인쇄면 양면 ③ 통자석 합지(ACPDAMG) ④ 렌티큘러 시트 자재 ⑤ 8T 두께블록 — 전부 `[live:catalog]` unobs(소재/입체 variant 동형 추정·검증 시 로그인 캡처).

---

## Ambiguous fragments (메타모델 단계로 이관 — 아키텍트가 버킷 확정)

- **A-1 두께(3T/5T/8T)의 버킷 — ★directive 최대 관전** [§0.1·§2 실측] — 두께가 `pdt_mtrl_info` MTRL_CD의 WGT_CD 슬롯(D01/D02/L01~04)에 인코딩되어 widget select `material`에 "3T/5T"로 노출. 두께가 ① 자재#1의 WGT 차원(facet) ② distinct #19(두께 1급 축) ③ 사이즈/형태가공#14 차원 중 무엇? **1차 예측 = facet(자재 WGT 차원)** — RedPrinting이 WGT_CD(평량 슬롯)를 두께로 재활용·후니 [huni-ref]도 mat_cd 차원으로 두께 통합(투명3T/1.5T 1 comp). distinct #19 아님. 단 평량(종이 g)과 두께(아크릴 mm)가 같은 WGT 슬롯을 의미 다르게 쓰는 점은 후니 자재모델 "WGT 슬롯 다의성" 검토 필요(GS 텀블러 용량 DTL과 동류 다의 슬롯).
- **A-2 아크릴 소재 variant(투명/홀로그램/글리터/거울/자개/렌티큘러/유색/파스텔)의 인코딩 단위** [§0.2·§2·§4-A 실측] — 표면효과가 ① 자재 PTT/라미 variant(ACTHDKY 6종 enum) ② 소재특화 pdtCode(ACTH*KY 9상품) 양면 인코딩. 표면효과(글리터/거울/자개)가 ① 자재의 surface-finish 차원 컬럼 ② 별 자재계열 ③ 상품 분기 중 무엇? ST 점착/내후 소재(S-4)와 동형 — 자재모델에 "표면효과/광학효과" 차원. 거울은 [huni-ref] COMP_ACRYL_MIRROR3T(별 도수체계)로 별 공식 = 단순 variant 아닐 수 있음(가격 분기).
- **A-3 입체/스탠드(3D)의 버킷 — ★directive 최대 관전 2** [§0.3·§3·§4-B 실측] — 입체성이 ① 받침 부자재(ACPDSTD 12 SKU·평면을 세움) ② 코롯토 두께블록(자립) ③ 양면(print_data) ④ 입체조형(FCO 공정) 4방식으로 분산. "입체/스탠드"가 ① distinct #19(3D 형태 축) ② 부자재(받침)+자재(두께)+인쇄면(양면) facet 분산 중 무엇? **1차 예측 = 분산 facet(distinct #19 아님)** — 받침=부자재 SUB_MTR(ST/GS 동형)·두께블록=자재 두께·양면=print_data. 단 "받침이 평면을 입체로 변환"·"코롯토=자립 블록"은 단순 부자재/두께 이상의 **형태/생산형태(평면 vs 입체) 차원** 가능성(round-15 생산형태×그릇·BN 거치대 부속물과 합류 검토).
- **A-4 부착물(고리/받침/자석/핀)의 SUB_MTR vs WRK_MTR 2그룹** [§0.4·§1·§2·§3 실측] — 부착물이 `SUB_MTR`(추가부자재·고리 KR/CN/CR 80+·받침 AB 12)와 `WRK_MTR`(부자재작업·명찰 뒷면 SXANB)로 2 PCS 그룹. 두 그룹이 ① 같은 "부자재+부착공정 BUNDLE"의 2변종 ② 별개 공정 중 무엇? 고리 코드(KR/CN/CR)가 **ST SUB_MTR_KR/CN/CR과 동일 코드체계 공유** = 굿즈/스티커/아크릴 횡단 "부자재 카탈로그" 공유(후니 부자재 마스터 단일화 시사). 받침=필수(ESN=Y)·고리=선택(ESN=N) — 부자재 필수성 차원. 메모리 "옵션=자재+공정 BUNDLE" 정점 케이스.
- **A-5 인쇄면(print_data 앞뒤같음/다름) + 화이트의 투명소재 종속** [§0.5·§2·§3 실측] — `option_info.print_data`(O/X)·`PRT_WHT`가 투명/유색 아크릴(키링/등신대)엔 있고 불투명 명찰(ACNTHAP)엔 없음(print_data null·화이트 없음). 인쇄면이 ① 옵션(앞뒤 택1) ② 기초코드(인쇄면 enum) ③ 도수(SID_S 단면) 차원 중 무엇? 투명소재→인쇄면/화이트 가용 캐스케이드. CL print 방식·PR 양면(SID_D)과 경계 — "양면"이 도수(SID_D)·인쇄면(앞뒤다름)·코롯토(BCO 양면) 3곳에 분산. 통합 검토.
- **A-6 3 가격엔진(vTmpl/acrylic2025/tmpl)의 한 카테고리 공존** [§0.6·§1·§2·§3 실측] — AC 한 카테고리에 명찰(vTmpl_price)·키링(acrylic2025_price)·등신대(tmpl_price) 3엔진. `acrylic2025_price`가 아크릴 전용 산정엔진([huni-ref] 면적매트릭스·두께 mat_cd). 가격엔진이 ① 카테고리 종속 ② 형태(라벨/die-cut/평면) 종속 ③ 생산형태 종속 중 무엇? ST 3엔진(S-6)·CL clothes2025_price·GS tmpl과 합류 — "2025세대 카테고리/형태 전용 가격엔진" 패턴. price_gbn 분기 기준 정합 필요.
- **A-7 상품명 소재 ≠ 본체 자재(명찰=PET+아크릴합지)** [§1 실측] — "아크릴 명찰"의 본체 자재가 고투명 PET 리무버블(RXIGC075)이고 아크릴감은 BON_PAP/ACXXS 아크릴합지(공정)로 부여. 상품명의 "아크릴"이 ① 본체 자재 ② 합지 공정(소재추가) ③ 마케팅 라벨 중 무엇? GS 코스터(소재=pdtCode)·CL 의류(상품명≠본체)·round-15 본체소재 부재와 동형 — 후니 "상품명 소재 vs 본체 자재 vs 합지소재" 분리 그릇. 합지(BON_PAP)가 자재추가 공정인지 별 자재슬롯인지 검토.
- **A-8 가공방식(production_method 일반/라미)의 버킷** [§0.6·§2 실측] — `option_info.production_method`(MTG_DFT 일반/MTG_LAM 라미)가 GRP_OPTION_CD로 자재행을 가공그룹으로 묶음(라미=2T+1T 두께 합성·홀로그램 합지). 가공방식이 ① 옵션(가공 택1) ② 공정(라미네이팅) ③ 자재 그룹핑 슬롯(두께/소재 합성) 중 무엇? 라미가 두께를 바꾸고(3T→2T+1T) 소재(홀로그램)를 부여 = 자재합성 공정. GS 제본·ST 합지·PR 면지 BUNDLE과 경계. 자재를 가공방식으로 그룹핑하는 GRP_OPTION_CD 메커니즘 = 후니 미발굴 자재 그룹핑 슬롯(신규 가설).
- **A-9 ACTPKEY 키링 템플릿의 AC 소속 vs TP** [§4-D] — "아크릴 키링 템플릿"(ACTPKEY)이 AC 카테고리에 속하나 에디터 디자인 자산형(TP #16 디자인입력채널·"디자인 시안≠완제SKU"). 템플릿이 ① AC 상품 일원(키링 디자인 프리셋) ② TP 디자인 자산(에디터 종속) 중 무엇? TP T-2(템플릿 2분화: 디자인시안 vs 완제SKU)·#16 디자인입력채널과 합류. 카테고리 소속 vs 자산 유형 경계.
