# S2 스티커(02) Red 라이브 캡처 + 어댑터 매핑 분석

> 파이프라인 ① hw-reverse-engineer 산출. S1(디지털인쇄) 비교 QA GO 직후 S2 스티커 확대 1단계.
> 캡처일: 2026-06-02 22:45~22:51 KST (Red 에디터 토큰 유효 exp=1780410076).
> 근거표기: `[라이브 검증]` 실제 localhost:3001 프록시 응답 / `[정적 분석]` fixture·어댑터 코드 / `[추정]`.

---

## 0. 요약 (TL;DR)

| 항목 | 결과 | 근거 |
|------|------|------|
| 캡처 productCode | **STTHCIC, STCUXXX, STPADPN** (+탐색 36종 전수) | [라이브 검증] |
| 가격모델 2종 커버 | PriceTable3D(digital_price) + **FixedUnit(vTmpl_price)** 둘 다 | [라이브 검증] |
| 가격 API 계약 | S1과 **동일 envelope**(ORD_INFO+PCS_INFO→result/result_sum). 델타 0 | [라이브 검증] |
| **위젯 코어 0변경** | **확정** — 3종 전부 기존 14 중 4종(option-button/select-box/finish-button/counter-input)으로 100% 커버. 신규 componentType 0 | [라이브 검증]+[정적 분석] vitest 5 pass |
| fixture 추가 | product 3 + price 2 = 5개. 어댑터 라우팅 등록 완료 | [정적 분석] |
| 테스트 | `red-adapter-sticker.test.ts` 5 pass / S1 7 pass 무회귀(12/12) | [정적 분석] |

---

## 1. 캡처한 productCode (스티커 카테고리 = Red `ST`)

스티커는 catalog.json(AC/GS/PR 3카테고리)에 **없음** → Red 메인페이지(`/rp-api/ko`, 233KB) 정독으로
`/product/item/ST/{code}` 링크 **36종 전수** 수집. [라이브 검증]

### 1.1 캡처 대표 3종 (가격모델 2종 커버)

| productCode | 상품명 | item_gbn | **price_gbn** | unit | fir/inc/step | 가격모델 | 캡처 |
|-------------|--------|----------|---------------|------|--------------|----------|------|
| **STTHCIC** | 원형 스티커 | digital_item | `digital_price` | 개 | 100/100/10 | **PriceTable3D**(규격 11종 + 모양커팅) | ✅ |
| **STCUXXX** | 사각반칼 스티커 | digital_item | `digital_price` | 개 | 100/100/10 | **PriceTable3D**(사이즈직접입력) | ✅ |
| **STPADPN** | DTF 열전사 판스티커 | **vDigital_item** | **`vTmpl_price`** | **장** | **1/1/10** | **FixedUnit**(시트단위) | ✅ |

### 1.2 ST 36종 전수 목록 (탐색 결과, 미캡처분은 후속 확대용)

```
STASDFT 가맹점     STBKDFT 오토바이    STBPDFT 후지인쇄   STCUNXT 내일출발사각반칼
STCUUSR 조각       STCUXXX 사각반칼✅   STDCFBR 패브릭데코  STDRCAD 카드스티커
STEMDFT 금은동형압  STEWDFT 메탈        STFBDFT 천         STFODFT 박/형압
STGMDFT 그문드라벨  STKPDFT 한지        STLTDFT 저온       STMADFT 통자석
STMDDFT 수정       STOTDFT 옥외용      STPADDY DTF자유형   STPADIY 자유형정가
STPADNM DTF네임     STPADPN DTF판✅      STPAUDY UV자유형    STPAUNM UV네임
STPAUPN UV판       STRMDFT 리무버블    STRMSHP 모양무지    STSHDFT 다양한모양
STSKDFT 스크래치   STTBDFT 띠부        STTHCIC 원형✅       STTHELP 타원형
STTHSQU 사각라운드  STTHUSR 자유형      STTPBND 일회용밴드  STTPMSK 마스킹테이프
```

> price_gbn 패턴 [라이브 검증]: 대부분 `digital_price`(PriceTable3D). `STPADxx`/`STPAUxx`(DTF/UV 판·네임)
> 계열이 `vTmpl_price`(FixedUnit). `STPADIY`(자유형정가)는 `tmpl_price`(별도 정가표).
> 기획 §S2의 "타투스티커·스티커팩"은 현 Red ST에 **동명 SKU 없음** — 가장 가까운 FixedUnit 대표로
> `STPADPN`(판스티커=세트/시트) 채택. (미캡처 flag §6)

---

## 2. 옵션 트리 (get_digital_product_info) [라이브 검증]

### 2.1 PriceTable3D (STTHCIC 원형 — 가장 풍부)

| 차원 | Red 필드 | 값 | 비고 |
|------|----------|-----|------|
| 소재 | `pdt_mtrl_info` (19종) | RXATL090 아트지라벨, RXYUP080 유포, RXTPT050 투명PET, RXSPT050 은무PET … | 유포/코팅/투명 모두 포함 |
| 규격 | `pdt_size_info` (11종) | 사이즈직접입력 + 10X10~50X50 프리셋 (CUT_WDT/HGH) | DFT_YN 으로 기본값 |
| **모양커팅** | `pdt_pcs_info` PCS_CD=`THO_DFT` (17종) | 원형 10X10(CL001)~50X50, 자유원형(CLFRE) … | **판수/모양 차원** = 후가공 PCS |
| 도수 | `pdt_dosu_info` | SID_S 단면(PRN_CLR_CNT=4) | 단면만(스티커 특성) |
| 후가공 | PCS: CUT_DFT 재단(묶음/개별), COT_DFT 코팅(무광/유광), NUM_DFT 넘버링, SCO_*/MIS_* | | |
| 수량 | `pdt_prn_cnt_info` | FIR=100, INC=100, STEP=10 | 수량밴드 |
| **모양 옵션** | `option_info.shape_info` | `[{COD:CL, COD_NME:원형}]` | 모양 그룹 선택축 |

### 2.2 FixedUnit (STPADPN DTF 판 — 시트단위)

| 차원 | 값 | 비고 |
|------|-----|------|
| 소재 | `PXPUF003` DTF 전용 필름 (1종) | 단일 소재 |
| 규격 | `140X200`(기본), `A4` (2종) | 시트 크기 |
| 후가공 | CUT_DFT 재단, **PRT_WHT 화이트인쇄**, **PAK_POL 폴리백 개별포장** | |
| 수량 | **FIR=1, INC=1, STEP=10** | **장 단위**(시트 카운트) |
| disable | `pdt_disable_pcs_info` **0행** | 캐스케이드 없음(단순) |

---

## 3. 가격 API 실측 계약 [라이브 검증]

**엔드포인트:** `POST /rp-api/ko/product_price/get_ajax_price_vTmpl` — S1·책자와 **동일 단일 엔드포인트**.

### 3.1 요청 (S1과 100% 동일 envelope, price_gbn 만 다름)

```jsonc
{ "dataJson": {
  "ORD_INFO": [{ "PDT_CD":"STTHCIC", "MTRL_CD":"RXATL090",
    "CUT_WDT":50, "CUT_HGH":50, "WRK_WDT":54, "WRK_HGH":54,
    "PRN_CNT":100, "ORD_CNT":1, "DOSU_COD":"SID_S", "PRN_CLR_CNT":4 }],
  "PCS_INFO": [
    { "PCS_COD":"THO_DFT", "PCS_DTL_COD":"CL005", "ATTB":"" },   // ← 모양커팅(스티커 고유 PCS)
    { "PCS_COD":"CUT_DFT", "PCS_DTL_COD":"DFXXX", "ATTB":"" }],
  "price_gbn":"digital_price",   // FixedUnit 은 "vTmpl_price"
  "mb_cust_cod":"10000000" } }
```

> **델타 vs S1**: ORD_INFO/PCS_INFO/price_gbn/mb_cust_cod 구조 **완전 동일**. 스티커 고유성은
> `PCS_INFO[].PCS_COD=THO_DFT`(모양커팅) 한 줄뿐 — 위젯은 PCS를 불투명 echo 하므로 **무관**. [라이브 검증]

### 3.2 응답 (result lines + result_sum, S1과 동일 shape)

| 케이스 | result lines | result_sum.PRICE | 의미 |
|--------|-------------|------------------|------|
| STTHCIC digital_price (비로그인) | 2 (THO_DFT, CUT_DFT) | **0** | 고객가 비공개 → 0. shape만 검증 |
| STCUXXX digital_price (비로그인) | — | 0 | 동일 |
| **STPADPN vTmpl_price 140×200** | 3 (CUT_DFT, PRT_WHT, PAK_POL) | **4000** (VAT 400) | **공개 시트가 — 실가 캡처** |
| **STPADPN vTmpl_price A4** | 3 | **8000** (VAT 800) | 규격 커질수록 ↑ |

> **중요 [라이브 검증]**: FixedUnit(`vTmpl_price`)는 **비로그인에도 실 시트가 반환**(공개가). 140×200=4000원,
> A4=8000원. → FixedUnit 역산 단서 확보(시트가는 규격에 비례, 고객할인 무관). digital_price 는 S1과
> 마찬가지로 고객가라 비로그인 0. 두 모델 모두 `result_sum.PRICE/PRICE_VAT` shape 동일.
> `query` 필드에 `dbo.WSP_ACPT_ORDER_TMPL_PCS_PRICE` 프로시저 호출 XML(PARAMS/DETAIL/PCS) 노출 — S1과 동일.

---

## 4. 어댑터 매핑 설계 [라이브 검증 + 정적 분석]

**기존 red-adapter(`mapProduct`/`mapPriceResponse`) 무수정**으로 매핑됨을 vitest 로 실증.

| Red 입력 | 정규화 그룹 → componentType | 검증 |
|----------|----------------------------|------|
| `pdt_size_info` (규격/직접입력) | `GRP_SIZE` → **option-button** | ✅ |
| `pdt_mtrl_info` (소재 19종) | `GRP_MTRL_COVER` → **select-box** | ✅ |
| `pdt_dosu_info` (단면) | `GRP_DOSU_COVER` → **option-button** | ✅ |
| **`THO_DFT` 모양커팅 (11값)** | `PCS_THO_DFT` → **finish-button** | ✅ **신규 불요** |
| CUT_DFT/COT_DFT/NUM_DFT/PAK_POL/PRT_WHT | `PCS_*` → **finish-button** | ✅ |
| `pdt_prn_cnt_info` (수량밴드) | `GRP_QUANTITY` → **counter-input** | ✅ |
| `pdt_disable_pcs_info` (151행, 소재→PCS disable) | `constraints.disableRules` (group+value 레벨) | ✅ S1과 동일 평면화 |

### 4.1 기획 §S2 매핑설계 항목별 확정

- **(a) 판수→option-button**: Red 실데이터에선 "판수"가 별도 차원이 아니라 **`THO_DFT` 모양커팅 PCS**(원형/사각 + 크기). 기획의 "판수=size류 option-button" 가설보다 정확히는 **모양커팅=finish-button**으로 흡수됨. 위젯 코어 무관(둘 다 14 안). [라이브 검증 정정]
- **(b) 소재→select-box**: 19~23종 소재 → select-box. ✅ 일치.
- **(c) 타투 step→InputSpec.step**: 해당 SKU 부재. FixedUnit 대표 STPADPN 는 `pdt_prn_cnt_info.INC_STEP=10`, `FIR_CNT=1` → **counter-input 의 InputSpec(min=1, step)** 으로 흡수. ✅ 구조 동일.
- **(d) FixedUnit→priceSchemeKey echo**: `priceSchemeKey="vTmpl_price"` 가 `mapProduct` 출력에 불투명 echo 됨(vitest 확인). 위젯은 가격모델 모름(INV-1). ✅
- **(e) S1 대비 델타**: §5.

---

## 5. S1 대비 델타

| 측면 | S1 (명함·엽서) | S2 (스티커) | 위젯 영향 |
|------|---------------|-------------|----------|
| price_gbn | digital_price | digital_price **+ vTmpl_price(FixedUnit)** | **0** (불투명 echo) |
| 면 구조 | 단일면 | 단일면 | 동일 |
| 고유 PCS | 별색(PRT_WHT) | **모양커팅(THO_DFT)** + PRT_WHT | finish-button 흡수, 0 |
| unit | 장 | 개 / **장**(시트) | InputSpec 라벨만 |
| 비로그인 가격 | 0 (전부) | digital=0, **FixedUnit=실가** | 검증 강화(역산 단서) |
| disable 규모 | 중 | **151행**(소재↔코팅/스코어링 다수) | disableRules 평면화 동일 |
| 신규 componentType | 0 | **0** | 동일 |

---

## 6. 미캡처 / 리스크 flag

| flag | 내용 | 영향 | 후속 |
|------|------|------|------|
| **F1 [미검증]** | 기획 §S2 "타투스티커·스티커팩" 동명 SKU 가 Red ST 36종에 **부재** | FixedUnit 대표를 STPADPN(판/시트)로 대체 | 후니 상품마스터의 타투/팩이 어느 Red price_gbn 인지 D-매핑 시 확인. 구조는 STPADPN 로 충분 |
| **F2 [라이브 검증, 한계]** | digital_price 스티커(STTHCIC/STCUXXX)는 비로그인이라 `result_sum.PRICE=0` | shape만 검증, 실단가 미확보 | 가격 역산은 BFF 권위(INV-1). 로그인 캡처는 별도 인증 필요 — 현 단계 불요 |
| **F3 [미검증]** | `STPADIY`(tmpl_price=정가표) 3번째 가격모델 미캡처 | S2 범위는 digital+vTmpl 2종으로 충분 | 정가표 SKU 확대 시 캡처 |
| **F4 [라이브 검증]** | 모양커팅(THO_DFT)이 finish-button 으로 매핑됨 — UI상 "모양 선택"이 후가공처럼 보일 수 있음 | 시각 검수 권장(기능 무관) | hw-designer/디자인 시 모양 그룹 배치 확인(DESIGN.md 14종 내) |
| **F5 [추정]** | 에디터(KOI/RP) 플로우 미캡처 (옵션/가격까지만, 주문/결제 진입 금지 준수) | S2 게이트는 옵션·가격 범위 | from-edicus 라이프사이클은 S0/S1 캡처로 커버됨(상품 무관) |

---

## 7. 산출물 위치

- 캡처 원본: `_workspace/huni-widget/05_qa/captures/s2_{STTHCIC,STCUXXX,STPADPN}.json` + `.png` (3장)
- 원본 아카이브: `_workspace/huni-widget/01_reverse/s2_raw_captures/` (product+price 캡처 전문)
- fixture: `04_build/fixtures/product_{STTHCIC,STCUXXX,STPADPN}.json` + `price_{STTHCIC,STPADPN}_sample.json`
- 어댑터 등록: `04_build/src/adapters/red/fixture-source.ts` (DIGITAL_PRINT_PREFIX 에 ST 추가 + FIXED_UNIT_CODES)
- 계약 테스트: `04_build/test/red-adapter-sticker.test.ts` (5 pass) / S1 무회귀(7 pass)
- 캡처 스크립트: `raw/widget_monitor/local/s2-sticker-capture.cjs` (read-only, 옵션/가격까지만)

---

## 8. 위젯 코어 0변경 판정 — **확정 (순수 어댑터+데이터)**

EXISTING `mapProduct`/`mapPriceResponse` (1줄도 수정 안 함) 으로 3종 스티커 모두:
- 옵션그룹 9/9/7개 전부 **기존 14 componentType 안** (option-button/select-box/finish-button/counter-input 4종 사용)
- 단일면(sides=[default]), 내지 분리 없음
- 두 가격모델(digital_price/vTmpl_price) → 동일 `NormalizedPriceBreakdown` shape

→ **INV-3(위젯 코어 불변)·INV-5(14 dispatcher 고정) 위반 0.** fixture-source 라우팅(데이터)만 추가.
신규 componentType·dispatcher case·store·cascade·shadow 변경 **전부 불요**.
