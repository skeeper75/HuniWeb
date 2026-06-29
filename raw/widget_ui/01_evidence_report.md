# Widget UI 컴포넌트 패턴 -- 증거 분석 보고서

> 생성일: 2026-04-01
> 분석 대상: RedPrinting (PRBKORD, GSTGMIC) / WowPress (fresh_namecard, wow_booklet)
> 근거: 실사이트 캡처 JSON + comparison_report + huni_feature_gaps

---

## 1. 옵션 레이어별 컴포넌트 매핑

### 1.1 RedPrinting 데이터 구조 (API 기반 구조화 데이터)

| optionType | RedPrinting 데이터 구조 | WowPress 데이터 구조 | 컴포넌트 타입 추론 |
|---|---|---|---|
| **용지 (paper)** | `pdt_mtrl_info[]` 배열. 필드: `CLR_CD`/`PTT_CD`/`WGT_CD` -> `MTRL_CD` 합성코드. 표지(`pdt_mtrl_info`)와 내지(`inner_pdt_mtrl_info`) 분리 (책자만). `HIDE_YN`, `BSN_YN` 플래그 | `sPaper0` name의 `<select>` 3단 분리: `spdata_00_paperno3`(종류), `spdata_00_paperno4`(평량), `spdata_00_paperno5`(두께). 각각 독립 select | **Cascading Select Group**: Red는 단일 리스트에서 CLR->PTT->WGT 3단 필터, Wow는 물리적으로 3개 select 분리 |
| **규격 (size)** | `pdt_size_info[]` 배열. 필드: `DIV_NM`, `CUT_WDT`/`CUT_HGH`, `WRK_WDT`/`WRK_HGH`, `DFT_YN`(기본값), `DIV_SEQ`(정렬), `HIDE_YN` | `SizeNo` name의 `<select>` (`pdata_00_sizeno`). WowPress는 추가로 `SelfCNoSize` select (UI용 크기 프리셋) 존재 | **Single Select (Dropdown)**: 두 플랫폼 모두 단일 선택. Red는 작업/재단 사이즈 자동 산출 |
| **도수 (color)** | `pdt_dosu_info[]` + `pdt_bnc_info[]` + `pdt_dosu_bnc_info[]` 3개 배열 조합. `COD`(SID_S/SID_D), `PRN_CLR_CNT`, `BNC_GB` | `ColorNo` name의 `<select>` (`pdata_00_colorno`). 추가도수용 별도 select (`pdata_00_colorno_add`) 존재 | **Single Select + Optional Add-on Select**: Red는 도수-색도 매트릭스, Wow는 기본도수 + 추가도수 2단 |
| **수량 (quantity)** | `pdt_prn_cnt_info[]` + `pdt_base_info.FIR_CNT`/`INC`/`INC_STEP`. 수량을 서버에서 계산 규칙으로 제공 (min/max/step) | `spdata_00_ordqty` select (고정 수량 브래킷) + `pdata_00_ordcnt` select (디자인 건수) | **Number Input vs Bracket Select**: Red는 규칙 기반 동적 생성, Wow는 사전 정의 브래킷 |
| **후가공 (PCS)** | `pdt_pcs_info[]` 배열. `PCS_CD`/`PCS_DTL_CD` 2단 코드. `VIEW_YN`(UI 노출), `ESN_YN`(필수), `HIDE_YN`, `NOTICE[]`, `SUB_MTRL_YN`, `QTY_INPUT_YN` | `sJob0` name의 `<select>` 다수. ID 패턴: `spdata_00_awk{5자리코드}{1-2자리}`. 각 후가공 항목별 독립 select | **Multi-section with per-item Select**: Red는 구조화 배열, Wow는 flat select 나열 |
| **제본방향 (binding)** | `BIND_DIRECTION` PCS 코드로 후가공 내 포함. `PCS_DTL_CD`: BPLFT(좌철), BPTOP(상철) | 캡처 미확인 (PP홀더에는 해당 없음) | **Radio Group**: 배타적 단일 선택 |
| **링색상 (ring color)** | `pdt_add_info[1][]` 배열. `ATTB_CD`(RIN_BLK 등), `ATTB_NM`, `PCS_CD`로 후가공과 연결 | 캡처 미확인 | **Color Swatch / Radio**: 속성 부가 선택 |

### 1.2 핵심 차이: 데이터 전달 방식

- **RedPrinting**: 단일 API (`get_digital_product_info`)로 16개 데이터셋 일괄 로드 -> 클라이언트에서 Vue reactive로 조합
- **WowPress**: 서버 렌더링된 HTML `<select>` 요소로 전달. 옵션 변경 시 AJAX POST (`/ord/calc/jobqty0`)로 가격 재계산

---

## 2. 컴포넌트 타입 결정 로직

### 2.1 RedPrinting: skinInfo 기반 섹션 가시성 제어

`skinInfo` 객체가 각 옵션 섹션의 노출 여부를 제어한다.

```json
// PRBKORD (책자) skinInfo
{
  "pageDirection": { "view_yn": "N", "title": "주문서 작성" },
  "paperSelect":   { "view_yn": "Y", "title": "용지" },
  "sizeSelect":    { "view_yn": "Y", "title": "규격 (mm)" },
  "dosuSelect":    { "view_yn": "Y", "title": "인쇄 도수" },
  "subjectGroup":  { "view_yn": "Y", "title": "주문 제목" },
  "quantityGroup": { "view_yn": "Y", "title": { "orderCnt": "수량", "printCnt": "내지장수" } }
}
```

```json
// GSTGMIC (굿즈) skinInfo - quantityGroup 라벨 차이
{
  "quantityGroup": { "view_yn": "Y", "title": { "orderCnt": "디자인 수 (건수)", "printCnt": "수량" } }
}
```

**발견 사항**: `skinInfo`는 UI 섹션의 표시/숨김과 라벨만 제어한다. 컴포넌트 타입(select/radio/input) 자체를 지정하는 필드는 캡처에서 발견되지 않았다. 컴포넌트 타입은 `item_gbn`에 의해 결정되는 것으로 추론된다.

### 2.2 RedPrinting: item_gbn 기반 제품 유형 분기

| item_gbn 값 | 제품 예시 | price_gbn | 특수 데이터셋 |
|---|---|---|---|
| `vDigital_item` | GSTGMIC (마이크 네임택) | `tiered_price` | 단일 자재/도수 구조 |
| `book2025_item` | PRBKORD (트윈링 책자) | `book2025_price` | `inner_pdt_mtrl_info`, `inner_pdt_dosu_info`, `inner_pdt_bnc_info`, `inner_pdt_dosu_bnc_info` 추가 |

`book2025_item`은 표지(cover)와 내지(inner) 이중 구조를 가지며, 각각 별도 자재/도수/색도 선택이 필요하다.

### 2.3 RedPrinting: PCS VIEW_YN 기반 후가공 노출 제어

```json
// PRBKORD 후가공 항목별 VIEW_YN
{ "PCS_CD": "CUT_DFT",         "VIEW_YN": "N", "ESN_YN": "Y" }  // 재단 - 숨김, 필수
{ "PCS_CD": "RIN_DFT",         "VIEW_YN": "Y", "ESN_YN": "Y" }  // 링제본 - 노출, 필수
{ "PCS_CD": "ADC_PVC",         "VIEW_YN": "Y", "ESN_YN": "Y" }  // PVC커버 - 노출, 필수
{ "PCS_CD": "CVR_UNT",         "VIEW_YN": "N", "ESN_YN": "Y" }  // 낱장커버 - 숨김, 필수
{ "PCS_CD": "BIND_DIRECTION",  "VIEW_YN": "Y", "ESN_YN": "Y" }  // 제본방향 - 노출, 필수
```

**컴포넌트 결정 규칙 추론**:
- `VIEW_YN: "N"` + `ESN_YN: "Y"` -> 숨겨진 필수값 (Hidden Input, 기본값 자동 선택)
- `VIEW_YN: "Y"` + `ESN_YN: "Y"` -> 사용자 선택 필수 (Select/Radio)
- `VIEW_YN: "Y"` + `ESN_YN: "N"` -> 선택적 옵션 (Checkbox + Select)

### 2.4 WowPress: HTML select 기반 정적 구조

WowPress는 서버에서 렌더링한 `<select>` 요소의 `name`과 `id` 패턴으로 컴포넌트를 식별한다:

| ID 패턴 | 역할 | 컴포넌트 |
|---|---|---|
| `category1`, `category2` | 대분류, 소분류 선택 | Cascading Select (카테고리 네비게이션) |
| `SelfCNoSize` | 사용자 친화 사이즈 프리셋 | Select (UI 전용, 내부 SizeNo와 매핑) |
| `pdata_00_sizeno` | 실제 사이즈 코드 | Select (hidden 또는 연동) |
| `pdata_00_colorno` | 기본 도수 | Select |
| `pdata_00_colorno_add` | 추가 도수 (별색 등) | Select (optional) |
| `spdata_00_paperno{3,4,5}` | 용지 3단 (종류/평량/두께) | Cascading Select Group |
| `spdata_00_ordqty` | 수량 (매) | Select (bracket) |
| `pdata_00_ordcnt` | 디자인 건수 | Select |
| `spdata_00_awk{코드}{서브}` | 후가공 항목별 | Select per item |

---

## 3. 의존성/비활성화 패턴

### 3.1 RedPrinting: pdt_disable_pcs_info (자재-후가공 비활성화 규칙)

PRBKORD(책자)에서 31개 비활성화 규칙 발견. 구조:

```json
{
  "MTRL_CD": "RXOMO080",    // 내지 자재: 미색모조 80g
  "PCS_CD": "COT_DFT",      // 비활성화 대상 후가공: 코팅
  "PCS_DTL_CD": null,        // null이면 해당 PCS 전체 비활성화
  "NOTE": null
}
```

**발견된 패턴 (PRBKORD)**:

| 자재코드 | 비활성화 후가공 목록 | 의미 |
|---|---|---|
| `RXOMO080` (미색모조80g) | COT_DFT, FLD_DFT, MIS_DFT, PRT_MAG, SCO_DFT, SCO_GLD, SCO_SLV | 얇은 모조지 -> 코팅/접지/미싱/스코딕스 불가 |
| `RXOMO100` (미색모조100g) | 위 + LAM_DFT, OSI_DFT | 100g에서 추가로 합지/오시도 불가 |
| `RXWMO080` (백색모조80g) | COT_DFT, FLD_DFT, MIS_DFT, SCO_DFT, SCO_GLD, SCO_SLV | 80g 모조지 공통 제한 |
| `RXWMO100` (백색모조100g) | 위 + LAM_DFT, OSI_DFT, PRT_MAG | 100g에서도 추가 제한 |

**비활성화 처리 방식**: `PCS_DTL_CD: null`이면 해당 `PCS_CD` 전체를 비활성화. 특정 `PCS_DTL_CD`가 있으면 해당 세부 옵션만 비활성화.

GSTGMIC(굿즈)에서는 `pdt_disable_pcs_info: []` (빈 배열) -- 비활성화 규칙 없음.

### 3.2 WowPress: 의존성 패턴

캡처에서 클라이언트 측 비활성화 로직은 직접 발견되지 않았다. 그러나 다음 간접 증거가 있다:

1. **SelfCNoSize -> SizeNo 연동**: `SelfCNoSize` (90x50, 50x90 등 UI 프리셋)가 `pdata_00_sizeno` (내부 SizeNo 코드)와 매핑되어 연동
2. **용지 3단 select 연동**: `spdata_00_paperno3` -> `paperno4` -> `paperno5`가 순차적으로 필터링되는 것으로 추정 (className에 `sPaperpdata_00_paperno` 공통 클래스)
3. **후가공 hidden 필드**: `hdata_00_awk23000_jobqtymin`, `hdata_00_awk23000_jobqtymax`, `hdata_00_awk23000_jobqtygetynint` hidden input 패턴 -- 후가공별 수량 제한을 서버에서 내려줌

### 3.3 두 플랫폼 비활성화 비교

| 측면 | RedPrinting | WowPress |
|---|---|---|
| 비활성화 데이터 위치 | 클라이언트 (JSON 배열) | 서버 (HTML 렌더링 시 적용 추정) |
| 규칙 표현 | `{MTRL_CD, PCS_CD, PCS_DTL_CD}` 튜플 | 캡처에서 미발견 |
| 규칙 수 (책자) | 31개 | N/A |
| 적용 시점 | 자재 변경 시 즉각 reactive | 페이지 리로드 또는 AJAX 후 |

---

## 4. 수량 선택 컴포넌트 패턴

### 4.1 RedPrinting: 규칙 기반 동적 수량 생성

```json
// GSTGMIC (굿즈) pdt_prn_cnt_info
{
  "DFT_PRN_CNT": 1,      // 기본 인쇄수량
  "FIR_CNT": 1,           // 시작 수량
  "INC_CNT": 1,           // 증가 단위
  "INC_STEP": 10,         // INC_CNT 적용 횟수 후 스텝 변경
  "MIN_PRN_CNT": 1,       // 최소 인쇄수량
  "MIN_INN_PAGE": 1,      // 최소 내지 페이지
  "MAX_INN_PAGE": 1,      // 최대 내지 페이지 (굿즈는 1)
  "STEP_INN_PAGE": 1,     // 페이지 증가 단위
  "MAX_THCK": null,       // 최대 두께 제한
  "INN_MAX_WGT": null,    // 내지 최대 평량
  "COV_MIN_WGT": null     // 표지 최소 평량
}
```

```json
// PRBKORD (책자) pdt_prn_cnt_info -- 추가 필드 존재
{
  "DFT_PRN_CNT": 10,
  "FIR_CNT": 1,
  "INC_CNT": 10,
  "INC_STEP": 10,
  "MIN_PRN_CNT": 1,
  "MIN_INN_PAGE": 2,      // 최소 내지 2페이지
  "MAX_INN_PAGE": 130,    // 최대 내지 130페이지
  "STEP_INN_PAGE": 1,
  "MAX_THCK": "1000.00",  // 최대 두께 1000mm
  "INN_MAX_WGT": 1000,    // 내지 최대 평량 1000g
  "COV_MIN_WGT": 200      // 표지 최소 평량 200g
}
```

**추가**: `pdt_base_info`에도 수량 규칙 존재:
- `FIR_CNT`: 최소 주문 건수 (GSTGMIC: 1, PRBKORD: 10)
- `INC`: 건수 증가 단위 (GSTGMIC: 1, PRBKORD: 5)
- `INC_STEP`: 스텝 전환 기준 (둘 다 10)
- `ORD_CNT_YN`: 주문건수 입력 가능 여부 (둘 다 "Y")
- `PDT_UNIT`: 단위 표시 (GSTGMIC: "개", PRBKORD: "권")

**책자 특수 수량 구조**: `ordCnt`(부수)와 `prnCnt`(내지장수) 2차원 수량. skinInfo에서 라벨도 분리: `"orderCnt": "수량"`, `"printCnt": "내지장수"`.

### 4.2 WowPress: 사전 정의 브래킷 방식

```json
// fresh_namecard ordqty (일반명함, id: spdata_00_ordqty)
[
  "500매", "1000매", "2000매", "3000매", "4000매", "5000매",
  "6000매", "7000매", "8000매", "9000매", "10000매",
  "15000매", "20000매", "25000매", "30000매", "35000매",
  "40000매", "45000매", "50000매", "55000매", "60000매",
  "65000매", "70000매", "75000매", "80000매", "85000매",
  "90000매", "95000매", "100000매"
]
// 총 29개 고정 브래킷. 비선형 간격 (1000단위 -> 5000단위 -> 5000단위)
```

```json
// wow_booklet ordqty (PP홀더, id: spdata_00_ordqty)
["300매", "500매", "1000매", "2000매", "3000매", "4000매", "5000매", "10000매", "20000매"]
// 총 9개 고정 브래킷
```

**디자인 건수 (OrdCnt)**: 별도 select. 명함은 1~50건, PP홀더도 유사 범위.

### 4.3 수량 컴포넌트 추론

| 플랫폼 | 수량 타입 | 컴포넌트 | 가격 연동 |
|---|---|---|---|
| RedPrinting | 규칙 기반 (FIR/INC/STEP) | Number Stepper (+ 동적 select 가능) | 수량 변경 즉시 가격 API 호출 |
| WowPress | 고정 브래킷 | Select (Dropdown) | 수량 변경 시 AJAX POST |
| RedPrinting (책자) | 부수 + 내지장수 2차원 | Dual Number Stepper | 두 값 모두 가격에 영향 |

---

## 5. 후가공(PCS/awkjobinfo) UI 구조

### 5.1 RedPrinting: pdt_pcs_info 구조

후가공은 `PCS_CD` (공정코드) + `PCS_DTL_CD` (세부코드) 2단 계층이다.

**PRBKORD (책자) 후가공 항목**:

| PCS_CD | PCS_GRP_NM | 세부 옵션 (PCS_DTL_CD) | VIEW_YN | ESN_YN | 컴포넌트 추론 |
|---|---|---|---|---|---|
| CUT_DFT | 재단 | DFXXX (재단) | N | Y | Hidden (자동) |
| RIN_DFT | 링제본 | BPLFT (좌철), BPTOP (상철) | Y | Y | Radio Group (2개 선택지) |
| ADC_PVC | PVC 추가커버 | DFXXX (PVC 추가커버) | Y | Y | Checkbox (필수, 단일 옵션) |
| CVR_UNT | 커버 | DFXXX (낱장커버) | N | Y | Hidden (자동) |
| BIND_DIRECTION | 제본방향 | BPLFT (좌철), BPTOP (상철) | Y | Y | Radio Group |

**GSTGMIC (굿즈) 후가공 항목**:

| PCS_CD | PCS_GRP_NM | 세부 옵션 | VIEW_YN | ESN_YN | 컴포넌트 추론 |
|---|---|---|---|---|---|
| COT_DFT | 코팅 | TCGLS (유광코팅단면) | N | Y | Hidden (자동) |
| THO_CUT | 모양커팅 | TG001~TG004 (4종 삼각/사각 S/L) | N | Y | Hidden (규격 연동 자동 선택) |
| WRK_MTR | 부자재작업 | TG001~TG004 (스펀지 4종) | N | Y | Hidden (규격 연동, `SUB_MTRL_YN: "Y"`) |
| PDT_WRK | 제품가공 | PKT01 (마이크텍 조립) | N | Y | Hidden (자동) |
| PAK_POL | 폴리백 개별포장 | DFXXX | N | Y | Hidden (자동) |

**핵심 발견**: GSTGMIC은 모든 후가공이 `VIEW_YN: "N"`이므로 사용자에게 후가공 선택 UI가 노출되지 않는다. 규격(size) 선택 시 `DIV_SEQ`를 기준으로 모양커팅/부자재가 자동 연동된다.

### 5.2 RedPrinting: pdt_add_info (후가공 속성 추가 선택)

```json
// PRBKORD pdt_add_info[1] -- 링색상 선택
[
  { "ATTB_CD": "RIN_BLK", "ATTB_NM": "검정색", "PCS_CD": "RIN_DFT" },
  { "ATTB_CD": "RIN_WHT", "ATTB_NM": "흰색",   "PCS_CD": "RIN_DFT" },
  { "ATTB_CD": "RIN_GLD", "ATTB_NM": "금색",   "PCS_CD": "RIN_DFT" },
  { "ATTB_CD": "RIN_SLV", "ATTB_NM": "은색",   "PCS_CD": "RIN_DFT" }
]
```

`pdt_add_info`는 2차원 배열로, 각 후가공(`pdt_pcs_info` 인덱스)에 대응하는 추가 속성 배열이다. 이 데이터가 가격 API의 `ATTB` 필드로 전달된다:
```json
{ "PCS_COD": "RIN_DFT", "PCS_DTL_COD": "BPLFT", "ATTB": "RIN_BLK" }
```

**컴포넌트**: Color Swatch Radio 또는 단순 Select로 렌더링.

### 5.3 WowPress: awkjobinfo 구조 (후가공)

WowPress 후가공은 `sJob0` name + `spdata_00_awk{코드}` ID 패턴의 select 요소로 구현된다.

**fresh_namecard (일반명함) 후가공 select 목록**:

| ID | 후가공 종류 | 옵션 | 기본값 | 컴포넌트 |
|---|---|---|---|---|
| `spdata_00_awk113411` | 오시 줄수 | 1줄, 2줄, 3줄 | 1줄 (selected) | Select |
| `spdata_00_awk113412` | 오시 방향 | 가로, 가로중앙, 세로, 세로중앙 | "오시 선택하세요" (미선택) | Select (optional) |
| `spdata_00_awk113521` | 미싱 줄수 | 1줄, 2줄, 3줄 | 1줄 (selected) | Select |
| `spdata_00_awk113522` | 미싱 방향 | (오시와 유사) | "미싱 선택하세요" (미선택) | Select (optional) |
| `spdata_00_awk113531` | 타공 개수 | 1개, 2개, 3개 | 1개 (selected) | Select |
| `spdata_00_awk113532` | 타공 위치 | 6종 (좌/좌상단/중앙 등) | "타공 선택하세요" (미선택) | Select (optional) |
| `spdata_00_awk230001` | 라운딩 | 전체, 한쪽 | "라운딩 선택하세요" (미선택) | Select (optional) |
| `spdata_00_awk270002` | 넘버링 | 1개, 2개 | "넘버링 선택하세요" (미선택) | Select (optional) |

**ID 코드 패턴 분석**: `awk{5자리그룹코드}{1-2자리서브코드}`
- `11341` = 오시 그룹, `1` = 줄수, `2` = 방향
- `11352` = 미싱 그룹, `1` = 줄수, `2` = 방향
- `11353` = 타공 그룹, `1` = 개수, `2` = 위치
- `23000` = 라운딩 (단일)
- `27000` = 넘버링 (단일)

**hidden input 연동**: 각 후가공 그룹에 `hdata_00_awk{코드}_jobqtymin`, `_jobqtymax`, `_jobqtygetynint` hidden 필드가 존재하여 수량 제한을 서버에서 제어한다.

### 5.4 후가공 UI 구조 비교

| 측면 | RedPrinting | WowPress |
|---|---|---|
| 데이터 구조 | `PCS_CD` + `PCS_DTL_CD` 2단 코드 | `awk{그룹}{서브}` 플랫 코드 |
| 그룹화 | `PCS_CD`로 그룹, `WEB_PCS_DTL_GRP`로 UI 그룹 | awk 5자리 그룹코드로 묶음 |
| 노출 제어 | `VIEW_YN` 플래그 | 서버 렌더링 시 결정 |
| 필수/선택 | `ESN_YN` 플래그 | "선택하세요" placeholder로 optional 표시 |
| 비활성화 | `pdt_disable_pcs_info` 배열 | hidden input으로 서버 제어 |
| 속성 추가 | `pdt_add_info` (ATTB 코드) | 서브 select로 분리 |

---

## 6. 가격 실시간 반영 이벤트

### 6.1 RedPrinting: 가격 재계산 트리거

가격 API `POST /ko/product_price/get_ajax_price_vTmpl`의 요청 구조를 분석하면 어떤 필드 변경이 가격에 영향을 주는지 알 수 있다.

**GSTGMIC (tiered_price) 요청 파라미터**:
```json
{
  "ORD_INFO": [{
    "PDT_CD": "GSTGMIC",
    "MTRL_CD": "RXBVW300",      // 자재 변경 -> 가격 변동
    "CUT_WDT": 351, "CUT_HGH": 241,  // 규격 변경 -> 가격 변동
    "WRK_WDT": 355, "WRK_HGH": 245,
    "PRN_CNT": 1,               // 인쇄수량 변경 -> 가격 변동
    "ORD_CNT": 1,               // 주문건수 변경 -> 가격 변동
    "DOSU_COD": "SID_S",        // 도수 변경 -> 가격 변동
    "PRN_CLR_CNT": 4
  }],
  "PCS_INFO": [/* 후가공 선택 전체 */],  // 후가공 변경 -> 가격 변동
  "price_gbn": "tiered_price",
  "mb_cust_cod": "10000000"      // 고객등급 (세션 고정)
}
```

**PRBKORD (book2025_price) 요청 파라미터** -- 추가 필드:
```json
{
  "ORD_INFO": [{
    "PAGE_CNT": 2,              // 내지 페이지수 -> 가격 변동
    "CVR_CLR_CNT": 8,           // 표지 색도 -> 가격 변동
    "INN_CLR_CNT": 8,           // 내지 색도 -> 가격 변동
    "CVR_MTRL_CD": "RXART250",  // 표지 자재 -> 가격 변동
    "INN_MTRL_CD": "RXOMO080"   // 내지 자재 -> 가격 변동
  }]
}
```

**가격 트리거 이벤트 종합**:

| 이벤트 | vDigital_item | book2025_item | 영향도 |
|---|---|---|---|
| 자재(용지) 변경 | MTRL_CD | CVR_MTRL_CD + INN_MTRL_CD | 높음 |
| 규격(사이즈) 변경 | CUT_WDT/HGH | CUT_WDT/HGH | 높음 |
| 도수 변경 | DOSU_COD, PRN_CLR_CNT | CVR_CLR_CNT + INN_CLR_CNT | 중간 |
| 수량 변경 | PRN_CNT, ORD_CNT | PRN_CNT(부수), PAGE_CNT(내지) | 높음 |
| 후가공 변경 | PCS_INFO 전체 | PCS_INFO 전체 | 변동적 |
| 링색상 변경 | N/A | ATTB (RIN_BLK 등) | 무영향~낮음 |

### 6.2 RedPrinting: 가격 응답 구조

**PRBKORD 가격 분해 (공급가 기준)**:
```
인쇄(PRT_DFT): 2,100원  -- PCS_PRI_PRICE
PVC커버(ADC_PVC): 1,900원
재단(CUT_DFT): 0원
낱장커버(CVR_UNT): 0원
링제본(RIN_DFT): 7,500원
----- 합계: 11,500원 (VAT 1,150원)
----- 배송비(DLVR_AMT): 3,500원 (별도)
PCS_ETC_PRICE: 9,400원 (후가공 합계)
PCS_PRI_PRICE: 2,100원 (인쇄비)
```

**GSTGMIC 가격 분해**:
```
인쇄(PRT_DFT): 6,000원 (유일한 유가 항목)
부자재작업/코팅/제품가공/폴리백/완칼: 각 0원
----- 합계: 6,000원 (VAT 600원)
```

### 6.3 WowPress: 가격 재계산 방식

```json
// fresh_namecard 가격 API 호출 (POST /ord/calc/jobqty0)
"postData": "SNo=1&CostKD=-1&ProdNo=40073&Job=PRS&JobNo=3110&CoverCD=0&PJoin=0&OrdCnt=1&OrdQty=0&SizeNo=5458&WSize=90&HSize=50&JobQty=&PressM=O&QUnit=5&PaperNo=22907&ColorNo0=255&ColorNo=255&returnType=json"
```

**가격 응답 구조**:
```json
{
  "amtreq": 3630,      // 청구금액 (VAT 포함)
  "cost_prs": 3300,    // 인쇄비 (공급가)
  "costtax": 330,      // 부가세
  "dc_awkjob": 0,      // 후가공 할인
  "dc_addjob": 0,      // 추가작업 할인
  "weight": 0.493,     // 중량 (kg)
  "boxcnt": 1,         // 박스 수
  "exitday": 1,        // 출고일
  "Jobs": [{ "CostKD": -1, "SizeNo": "5458", "Cost1": 3300, ... }]
}
```

**WowPress UI 가격 표시** (priceElements):
```
인쇄비: 3,300원
부자재비: 0원
후가공: (별도 표시)
```

---

## 7. RedPrinting vs WowPress UI 구조 차이점

| 차원 | RedPrinting | WowPress | Huni 설계 시사점 |
|---|---|---|---|
| **아키텍처** | SPA (Vue 3 reactive), Shadow DOM 격리 | MPA (jQuery), 호스트 DOM 직접 | SPA + Shadow DOM 채택 |
| **데이터 전달** | JSON API 일괄 로드 (16개 데이터셋) | 서버 렌더링 HTML + AJAX 부분 갱신 | API-first 설계 |
| **옵션 캐스케이드** | 클라이언트 상태 머신 (Pinia reactive) | 서버 의존 (select 재렌더링) | 클라이언트 캐스케이드 엔진 |
| **용지 선택** | 단일 자재코드 (CLR+PTT+WGT 합성) | 3단 select (종류/평량/두께 분리) | 3단 필터 UI + 합성코드 내부 관리 |
| **수량 모델** | 규칙 기반 (FIR/INC/STEP 동적 생성) | 사전 정의 브래킷 (고정 select) | 규칙 기반 + 브래킷 하이브리드 |
| **후가공 구조** | 2단 코드 (PCS_CD/PCS_DTL_CD) + ATTB | awk 플랫 코드 + 서브 select | 2단 코드 채택, 그룹화 UI |
| **비활성화** | `pdt_disable_pcs_info` 배열 (클라이언트) | hidden input으로 서버 제어 | 클라이언트 규칙 엔진 |
| **가격 엔진** | 3종 (tiered/vTmpl/book2025) | 단일 (추정) | 통합 가격 엔진 with price_gbn 라우팅 |
| **가격 분해** | 공정별 원가 투명 분해 (PCS별 가격 배열) | cost_prs + dc_awkjob 2단 | 공정별 분해 채택 |
| **책자 특수** | 표지/내지 이중 구조 (inner_* 데이터셋) | 캡처 미확인 | 표지/내지 분리 모델 필수 |
| **에디터 연동** | Edicus KOI passive mode | 없음 | 에디터 통합 계획 필요 |
| **배송비** | `book_info.DLVR_AMT` (가격 응답 내 포함) | 별도 페이지 (추정) | 가격 응답에 배송비 통합 |
| **고객등급 가격** | `mb_cust_cod` 파라미터 | 캡처에서 미확인 | 등급별 차등 가격 지원 |
| **제품 분기** | `item_gbn` 3종 분기 | 단일 폼 구조 | item_gbn 패턴 채택 |

---

## 8. 미확인 항목 (캡처에 없음)

### 8.1 RedPrinting 미확인

| 항목 | 설명 | 이유 |
|---|---|---|
| `seltype` / `display_type` / `component` 필드 | 컴포넌트 타입을 명시적으로 지정하는 필드 | 캡처된 API 응답에 해당 필드 부재. 컴포넌트 타입은 위젯 JS 내부 로직으로 결정되는 것으로 추정 |
| `req_*` / `rst_*` 패턴 | 옵션 간 활성화/리셋 트리거 | 캡처 API에서 미발견. `pdt_disable_pcs_info`만 존재 |
| `pdt_add_pcs_info` | 추가 후가공 정보 | PRBKORD, GSTGMIC 모두 `null` |
| `pdt_exp_prn_cnt_info` | 확장 인쇄수량 정보 | 두 제품 모두 `null` |
| vTmpl_price 엔진 | 세 번째 가격 엔진 | ACNTHAP 캡처 파일이 v2에 없음 |
| `price_table_yn: "Y"` 동작 | GSTGMIC에서 활성화된 가격표 기능 | UI 동작 캡처 미포함 |
| `seneca` 관련 동작 | `seneca: "0.64"`, `max_seneca: "1000.00"` | PRBKORD에서 발견되나 UI 영향 불명 |
| `DAY_PRDC_PDT_YN` / `DAY_ABLE_PRN_CNT` | 당일 생산 제품 관련 | 두 제품 모두 "N"/0 |

### 8.2 WowPress 미확인

| 항목 | 설명 | 이유 |
|---|---|---|
| 책자 주문 위젯 | 책자 카테고리의 실제 주문 옵션 구조 | `wow_booklet_capture`는 PP홀더(40004) 페이지로, 실제 책자 주문 위젯이 아님 |
| `wow_businesscard_capture` | 명함 카테고리 목록 페이지 | 카테고리 리스트 페이지만 캡처됨 (404 에러 포함). 실제 주문 위젯 데이터 없음 |
| 후가공 체크박스 UI | 후가공 항목 활성화/비활성화 토글 | 캡처된 select만으로는 체크박스 존재 여부 확인 불가 |
| 옵션 캐스케이드 AJAX | 용지 변경 시 사이즈 필터링 등 | 초기 로드 캡처만 존재. 옵션 변경 후 재로드 캡처 없음 |
| 후가공 가격 분해 | 후가공별 개별 가격 | `dc_awkjob: 0`으로 후가공 총액만 확인. 개별 항목별 가격 분해 미확인 |
| 에디터 관련 | 온라인 편집 기능 | 모든 캡처에서 `hasEditor: false` |

### 8.3 추가 캡처 필요 항목

1. **RedPrinting ACNTHAP** (아크릴 네임택 합지) -- `vTmpl_price` 엔진 패턴 확인
2. **WowPress 실제 책자 주문 페이지** -- 표지/내지 분리 UI 패턴 확인
3. **WowPress 명함 주문 상세 페이지** -- `fresh_namecard_capture`의 옵션 변경 시퀀스 캡처
4. **RedPrinting 옵션 변경 시퀀스** -- 자재 변경 후 후가공 비활성화가 적용된 상태의 가격 재호출 캡처
5. **RedPrinting 비규격 사이즈** -- `NO_STD_ABL_YN: "N"` 제품과 "Y" 제품의 UI 차이

---

*본 보고서는 v2_PRBKORD_capture.json, v2_GSTGMIC_capture.json, fresh_namecard_capture.json, wow_booklet_capture.json, wow_businesscard_capture.json, comparison_report.md, huni_feature_gaps.json 7개 파일의 실제 캡처 데이터를 근거로 작성되었습니다.*
