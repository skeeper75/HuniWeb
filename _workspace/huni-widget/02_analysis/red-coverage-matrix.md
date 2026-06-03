# red-coverage-matrix.md — RedPrinting 전수 커버리지 매트릭스 (재사용 레퍼런스)

> 파이프라인 ②/③ 교차 산출물. Red 전 카탈로그 **479/479 상품 → 46 옵션구조 시그니처** 스캔을
> 재사용 가능한 레퍼런스 매트릭스로 정리하고, 위젯측(구현된 dispatcher) **완전성 판정**을 수행한다.
> 그 위에 후니 상품마스터/가격을 **무손실로 끼워 맞추기 위한 매칭 슬롯·간과 체크리스트**를 제시한다.
> [HARD] 본 문서는 분석만. `src/` 무수정. 위젯 코드 0줄 변경.
> 근거: [SCAN-A]=red-coverage-scan.json(479→46) / [SCAN-B]=red-coverage-phaseB.json(46 가격모델) /
> [DC]=data-contract.md+`src/contract/` / [DA]=data-adapter.md / [SRC]=`src/adapters/red/`+`src/widget/` /
> [DBMAP]=huni-db-mapping.md / [EXP]=expansion-strategy.md / [API]=api-contract.md / [DS]=huni-design-system v4.1.0.

---

## 0. 시그니처 문법 디코드 (먼저 — 매트릭스 읽는 법)

[SCAN-A] 시그니처 형식: `<정렬된 옵션키 CSV>|n<N>|<WH?>|r<N>`. 각 토큰의 의미:

| 토큰 | 의미 | componentType 함의 |
|------|------|--------------------|
| `paper` | 용지(표지) 데이터셋 (`pdt_mtrl_info`) | `select-box` (값 多, RULE-1) |
| `material` | 자재 데이터셋 (`pdt_mtrl_info` 자재류) | `select-box` (또는 이미지有 → image-chip) |
| `weight` | 평량/두께 선택 (용지 종속) | `select-box`/`option-button` |
| `dosu` | 인쇄 도수 (`pdt_dosu_info`) | `option-button` (+`priceColorCount` 평면화 [DA §2.2]) |
| `dosu-color` | 흑백 도수 색상 변형 (책자 흑백) | `option-button` (dosu 한 값일 뿐) |
| `sizes` | 규격 (`pdt_size_info`) | `option-button` (또는 0×0 sentinel+real_price → `dimension-matrix-input` NC-1) |
| `set-color` | 세트 색상 선택 (레디백) | `option-button`/`select-box` |
| `thickness` | 두께 선택 (레더 코스터) | `option-button`/`select-box` |
| `material-filter` | 자재 하위필터(글라스 범퍼) | `select-box` |
| `starting-month`·`starting-year` | 캘린더 시작 월/년 | `select-box` (enum) |
| `CLD_STD` | 옵셋 캘린더 규격 표준 플래그 | `select-box` enum (폐쇄 래더) |
| `INNER_QTY` | 책자 내지 부수 | `counter-input`/`page-counter-input` |
| `QTY` | 책자 주문 부수 | `counter-input` |
| `INN_DFT` | 내지 기본(노트류 내지 자동) | hidden essential → `required+visible:false` 평면화 |
| `CVR_INN` | 표지/내지 분리 구조 | `ProductSide=[default,inner]` 분기 |
| `SUM_MTR/<자재명>` | **자재합산형 add-on** (목걸이/조이톡/슬리퍼/에코백…) | **`finish-button`** (selectedFinishes echo, NC-2 흡수 확정) |
| `PRN_CNT` | 인쇄수량 차원 존재 | (입력 아님 — 가격축. quantity/printCount 분리) |
| `n<N>` | number-input 개수 (n0=없음) | counter/page-counter 입력 수 |
| `WH` | work-size(작업치수) W/H 공식 존재 | sizeRules workW/workH (재단마진 가산) |
| `r<N>` | radio 후가공 그룹 수 (r0~r3) | `finish-button` 그룹 N개 (PCS_CD 그룹화) |

> **핵심 통찰:** 46 시그니처의 옵션키는 전부 위 16개 토큰 조합이다. 신규 토큰은 없다 →
> 위젯 dispatcher가 보는 **componentType 종류**도 닫혀 있다(아래 §2에서 증명). `SUM_MTR/*`와
> `r1/r2/r3`이 long-tail의 다양성을 거의 전부 만든다 — 둘 다 기존 `finish-button`으로 흡수된다.

---

## 1. 커버리지 매트릭스 (46 구조 — 패밀리 그룹)

가격모델(price_gbn)은 위젯에 **불투명 echo**(INV-1, [SRC red-adapter.ts:409]) — 아래 표는 landscape 기록용.
componentType decomposition은 **구현된 dispatcher**([SRC OptionControl.tsx], 16 case) 기준 실제 라우팅.

### F1 — 종이류 (PriceTable3D / 디지털·명함·엽서·접지) — 합계 ≈ 198

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `PRN_CNT,dosu,paper,sizes,weight\|n5\|WH\|r0` | **153** | BCSPDFT | BC | 일반 명함 | digital_price | sizes→option-button · paper→select-box · weight→select-box · dosu→option-button · 수량→counter-input |
| `PRN_CNT,dosu,paper,sizes,weight\|n5\|WH\|r1` | 36 | PRPOSTK | PR | 고투명 점착 포스터 | digital_price | F1 기본 + 후가공 1그룹→finish-button |
| `PRN_CNT,dosu,paper,sizes,weight\|n5\|WH\|r2` | 3 | BCSPSCO | BC | 엠보싱<스코딕스>명함 | digital_price | F1 기본 + 후가공 2그룹→finish-button×2 |
| `dosu,paper,sizes,weight\|n4\|WH\|r0` | 5 | STDRCAD | ST | 카드스티커 | tmpl_price | F1에서 PRN_CNT 차원만 빠짐(수량 counter 유지) |
| `PRN_CNT,dosu,paper,sizes,weight\|n4\|WH\|r0` | 1 | STTBDFT | ST | 띠부스티커 | tmpl_price | F1 기본 (n4=입력 1개 차) |
| `PRN_CNT,dosu,paper,sizes,weight\|n4\|WH\|r1` | 1 | TPCAPTW | TP | 포토카드-화이트 | tmpl_price | F1 + 후가공 1그룹 |
| `PRN_CNT,paper,sizes,weight\|n5\|WH\|r0` | 1 | GSCDPOP | GS | 팝업카드 | vTmpl_price | dosu 없음(고정 풀컬러) — paper/sizes/weight/수량 |

### F2 — 자재류 (FixedUnit/vTmpl — 굿즈 무지·아크릴·펜·코스터) — 합계 ≈ 51

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `PRN_CNT,dosu,material,sizes\|n5\|WH\|r0` | **150** | GSSKSHH | GS | 구두주걱 | vTmpl_price | sizes→option-button · material→select-box · dosu→option-button · 수량→counter-input |
| `PRN_CNT,dosu,material,sizes\|n5\|WH\|r1` | 28 | GSTTACR | GS | 아크릴 코스터(모양) | vTmpl_price | F2 기본 + 후가공 1그룹→finish-button |
| `PRN_CNT,dosu,material,sizes\|n5\|WH\|r2` | 5 | ACTHPEN | AC | 아크릴 젤펜 | vTmpl_calc_price | F2 + 후가공 2그룹 |
| `dosu,material,sizes\|n5\|WH\|r0` | 1 | GSPNJLY | GS | 커스텀 젤펜2 | vTmpl_price | F2에서 PRN_CNT만 빠짐 |
| `dosu,material,sizes\|n6\|WH\|r0` | 2 | GSPNBAL | GS | 커스텀 펜 | vTmpl_price | F2 (n6=입력 차) |
| `PRN_CNT,dosu,material,sizes\|n7\|WH\|r0` | 1 | GSCBSTK | GS | 커스텀 큐브 | vTmpl_price | F2 (n7=입력 차) |
| `PRN_CNT,dosu,material,material-filter,sizes\|n5\|WH\|r0` | 6 | GSCAGBM | GS | 글라스 범퍼케이스 | vTmpl_price | F2 + material-filter→select-box(자재 하위필터) |
| `PRN_CNT,dosu,material,sizes,thickness\|n5\|WH\|r0` | 1 | GSTTREZ | GS | 레더 코스터 | vTmpl_price | F2 + thickness→select-box |
| `PRN_CNT,dosu,paper,set-color,sizes,weight\|n5\|WH\|r0` | 1 | GSBGRDY | GS | 레디백 | tiered_price | F1 + set-color→option-button |

### F3 — 책자 (book2025_price — 표지/내지 분리) — 합계 = 18

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `INNER_QTY,QTY,dosu,dosu,paper,paper,sizes,weight,weight\|n0\|r1` | 4 | PRBKYPR | PR | [윤전]무선책자(컬러) | book2025_price | **표지** paper/dosu/weight + **내지** paper/dosu/weight(side=inner) · sizes→option-button · QTY→counter · INNER_QTY→page-counter · r1→finish-button(제본) |
| `INNER_QTY,QTY,dosu,dosu,paper,paper,sizes,weight,weight\|n0\|r0` | 3 | PRBKYSL | PR | [윤전]실제본책자(컬러) | book2025_price | F3 기본, 후가공 0 |
| `INNER_QTY,QTY,dosu,dosu,dosu-color,paper,paper,sizes,weight,weight\|n0\|r1` | 6 | PRBKYPB | PR | [윤전]무선책자(흑백) | book2025_price | F3 + dosu-color(내지 흑백)→option-button |
| `INNER_QTY,QTY,dosu,dosu,dosu-color,paper,paper,sizes,weight,weight\|n0\|r0` | 5 | PRBKOCO | PR | [토너]스프링책자(컬러) | book2025_price | F3 + dosu-color, 후가공 0 |

> 책자 4구조는 [SRC red-adapter.ts:166-297] `hasInner` 분기가 정확히 처리: 표지(default)/내지(inner) 양 side에
> material·dosu OptionGroup을 분리 생성, `GRP_INNER_PAGE`(page-counter-input), `GRP_QUANTITY`(counter-input).
> S0(PRBKYPR) 구현·QA 완료 [EXP S0 DONE] — F3 전체가 동일 골격(dosu-color는 dosu 값 하나일 뿐).

### F4 — 표지/내지 분리·노트류 (CVR_INN / INN_DFT) — 합계 = 9

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `INN_DFT,PRN_CNT,dosu,paper,sizes,weight\|n6\|WH\|r1` | 3 | GSNTBND | GS | 뜯어쓰는 노트 | tmpl_price | F1 + INN_DFT(내지기본=hidden essential→required+visible:false 평면화) + 후가공1 |
| `INN_DFT,PRN_CNT,dosu,paper,sizes,weight\|n6\|WH\|r0` | 2 | GSNTMIS | GS | 실 제본 노트 | vTmpl_price | F1 + INN_DFT(hidden essential) |
| `INN_DFT,PRN_CNT,dosu,material,sizes\|n6\|WH\|r0` | 2 | GSNTLTR | GS | 레더 노트 | tmpl_price | F2 + INN_DFT(hidden essential) |
| `CVR_INN,PRN_CNT,dosu,material,sizes\|n5\|WH\|r0` | 2 | GSBGGOF | GS | 골프공 케이스 | vTmpl_price | F2 + CVR_INN(표지/내지 분리)→ProductSide 분기 |

> **CVR_INN / INN_DFT 판정:** CVR_INN은 책자와 동일한 `hasInner` 표지/내지 side 분리 → [SRC] 기존 분기 흡수.
> INN_DFT는 "내지 자동기본"으로 hidden essential 패턴([DC §2-⑤], `ESN_YN=Y && VIEW_YN=N`) →
> `OptionGroup.required=true + visible=false` 평면화 [SRC red-adapter.ts:128 VIEW_YN 매핑] → UI 미렌더, 가격요청 포함.
> **신규 componentType 0.**

### F5 — 자재합산형 (SUM_MTR/* — 굿즈 add-on) — 합계 = 21

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `PRN_CNT,SUM_MTR/에코백,dosu,material,sizes\|n6\|WH\|r0` | 3 | AIPPCUT | AI | 에코백(플록) | real_price | F2 + SUM_MTR/에코백→**finish-button**(자재 add-on echo) |
| `PRN_CNT,SUM_MTR/물티슈 종류,dosu,paper,sizes,weight\|n6\|WH\|r0` | 1 | GSWTANT | GS | 항균 물티슈 | vTmpl_price | F1 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/깃대,dosu,paper,sizes,weight\|n6\|WH\|r0` | 1 | GSFGMIN | GS | 미니깃발 | tmpl_price | F1 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/뒷면자재,dosu,paper,sizes,weight\|n6\|WH\|r0` | 1 | ACNTHAP | AC | 아크릴 명찰 | vTmpl_price | F1 + SUM_MTR→finish-button (✅fixture 보유) |
| `PRN_CNT,SUM_MTR/스툴,dosu,material,sizes\|n6\|WH\|r0` | 1 | PDCHSTL | PD | 스툴 | tmpl_price | F2 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/조립도구,dosu,paper,sizes,weight\|n6\|WH\|r0` | 1 | GSCCWAL | GS | 벽시계 | tmpl_price | F1 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/똑딱이버클,dosu,material,sizes\|n6\|WH\|r0` | 1 | GSWLSNP | GS | 똑딱이 지갑 | tmpl_price | F2 + SUM_MTR→finish-button |
| `CVR_INN,PRN_CNT,SUM_MTR/목걸이,dosu,material,sizes\|n6\|WH\|r0` | 1 | GSWLNEC | GS | 목걸이 지갑 | tmpl_price | F2 + CVR_INN(side분리) + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/슬리퍼,dosu,material,sizes\|n6\|WH\|r0` | 1 | PDWRSLP | PD | 슬리퍼 | tmpl_price | F2 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/계단,dosu,material,sizes\|n6\|WH\|r0` | 1 | PDSRPPY | PD | 강아지 계단 | tmpl_price | F2 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/양면테이프,SUM_MTR/조이톡,dosu,material,sizes\|n7\|WH\|r0` | 1 | ACPDJOY | AC | 아크릴 조이톡 | tmpl_price | F2 + SUM_MTR×2→finish-button×2 |
| `PRN_CNT,SUM_MTR/조이톡,dosu,material,sizes\|n6\|WH\|r0` | 1 | GSSTHFB | GS | 반구 조이톡 | tmpl_price | F2 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/조이톡,dosu,paper,sizes,weight\|n6\|WH\|r0` | 2 | GSSTFRX | GS | 조이톡_자유형 | tmpl_calc_price | F1 + SUM_MTR→finish-button |
| `PRN_CNT,SUM_MTR/등신대 받침대,dosu,material,sizes\|n6\|WH\|r1` | 1 | ACPDSTD | AC | 아크릴 등신대 | tmpl_price | F2 + SUM_MTR→finish-button + 후가공1 |
| `PRN_CNT,SUM_MTR/마스크 목걸이줄,dosu,material,sizes\|n6\|WH\|r0` | 1 | GSMLPRT | GS | 마스크 스트랩 | tmpl_calc_price | F2 + SUM_MTR→finish-button |

> **SUM_MTR/* 판정 (가장 중요한 long-tail 흡수):** 자재합산형은 "본체 + 부자재(목걸이줄/조이톡/양면테이프/스툴…)를
> 합산"하는 add-on이다. 위젯 관점에서는 **선택 가능한 부자재 옵션 그룹** = 텍스트 라벨 선택 → S4 NC-2 판정과 동일하게
> **`finish-button`으로 흡수**(가격델타는 BFF, selectedFinishes echo) [EXP §S4·NC-2 확정][DA §5]. `SUM_MTR/<자재명>`의 자재명은
> OptionGroup.label(동적, RULE-5)로, 합산단가는 위젯이 모름(INV-1). **신규 componentType 0.**
> `SUM_MTR/조이톡`만 3 SKU(반구/자유형/아크릴)가 paper/material 본체 차이로 별 시그니처가 되었을 뿐 구조 동일.

### F6 — 캘린더 (offset2023/vTmpl + 시작월/년) — 합계 = 4

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `CLD_STD,PRN_CNT,dosu,paper,sizes,weight\|n5\|WH\|r0` | 1 | HLCLSTD | HL | [옵셋]탁상용캘린더 | offset2023_price | F1 + CLD_STD→**select-box enum**(폐쇄 인쇄수량 래더 [SRC red-adapter.ts:158 prnCntLadder]) |
| `PRN_CNT,dosu,paper,sizes,starting-month,starting-year,weight\|n4\|WH\|r0` | 3 | TPCLWLB | TP | 큰 달력(효도) | vTmpl_price | F1 + starting-month/year→select-box(enum) |

> **CLD_STD 판정:** 옵셋 캘린더는 인쇄수량이 자유 counter가 아니라 **폐쇄 래더(FIR/INC null + 행별 PRN_CNT 고정)** →
> [SRC red-adapter.ts:304] `prnLadder` 분기가 `GRP_PRN_CNT`를 **select-box enum**으로 렌더(임의값 PRICE=0 방지).
> 이는 **기존 select-box 재사용**(신규 타입 0, 명세 §3.3-A). starting-month/year는 단순 enum select. **신규 0.**

### F7 — 의류 (clothes2025_price — 사이즈/색상 외부, no-design) — 합계 = 29

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `PRN_CNT\|n0\|r2` | 24 | CLSTDLB | CL | 드라이 탱크탑 | clothes2025_price | 옵션키 없음(사이즈/색상은 별 UI) + r2→finish-button×2(프린팅 위치) |
| `PRN_CNT\|n0\|r3` | 4 | CLDFDRR | CL | 드라이 라운드티 | clothes2025_price | r3→finish-button×3 |
| `\|n0\|r2` | 1 | CLDFMHS | CL | 88000 맨투맨 | clothes2025_price | 옵션·수량입력 없음 + r2 |

> **의류 판정:** 의류는 옵션 데이터셋이 거의 비어 있고(`PRN_CNT`만 또는 공백) 후가공 radio 그룹(r2/r3 = 인쇄위치/방식)만
> 존재. 전부 **finish-button**으로 흡수. 사이즈/색상 매트릭스는 Red가 별도 UI(위젯 옵션그룹 밖) — 후니 확장 시
> [EXP] 미분류군이나 위젯 dispatcher 관점 신규 0(finish-button + 향후 사이즈/색상 칩은 기존 color-chip/option-button).

### F8 — 무지/미가격 (옵션 없음, hadPriceCall=false) — 합계 = 6

| sig | count | 대표코드 | cat | name | price_gbn | componentType 분해 |
|-----|------|---------|-----|------|-----------|---------------------|
| `material\|n0\|r0` | 3 | GSSBMTL | GS | 티켓북 속지 | null | material→select-box 단일 그룹 (가격호출 없음) |
| `\|n0\|r0` | 3 | STRMSHP | ST | 다양한모양스티커_무지 | null | 옵션 0 — 위젯 옵션그룹 0개(수량/업로드만). dispatcher 무관 |

> **무지 판정:** `price_gbn=null && hadPriceCall=false` = 가격 미연동(전화주문/세트구성품). 위젯은 옵션그룹이 0~1개라
> 렌더할 게 거의 없음. dispatcher 안전(빈 optionGroups → OptionPanel 빈 렌더). **신규 0.** 가격 미연동은 어댑터가
> `ok:false` 또는 비견적 처리(위젯은 가격영역 미표시), 위젯 코드 무관.

---

## 2. 완전성 판정 — 숨은 NC 리스크 (46 구조 × 구현 dispatcher)

판정 기준: 각 구조가 **구현된 16-case dispatcher**([SRC OptionControl.tsx])로 **신규 case 없이** 라우팅되는가.
구현 dispatcher의 16 case = DESIGN 14 + `dimension-matrix-input`(NC-1) + `finish-select-box`.

### 2.1 흡수 메커니즘별 분류 (전 46 구조)

| 옵션 토큰 | → componentType (구현) | 흡수 vs 신규 | 근거 |
|-----------|------------------------|--------------|------|
| `sizes` (일반) | `option-button` | ✅흡수 | [SRC red-adapter.ts:190] DATASET_COMPONENT_TYPE.size |
| `sizes` (0×0 sentinel + real_price) | `dimension-matrix-input` | ✅흡수(NC-1 **이미 구현**) | [SRC red-adapter.ts:179 isDimensionMatrix] — F2 에코백 real_price 자동 발동 |
| `paper`/`material`/`weight`/`thickness`/`material-filter`/`set-color` | `select-box` | ✅흡수 | [SRC red-adapter.ts:222] material 매핑 |
| `dosu`/`dosu-color` | `option-button` | ✅흡수 | priceColorCount 평면화 [DA §2.2] |
| `PRN_CNT` (자유 counter) | `counter-input` | ✅흡수 | [SRC red-adapter.ts:329] GRP_QUANTITY |
| `PRN_CNT`/`CLD_STD` (폐쇄 래더) | `select-box` enum | ✅흡수(재사용) | [SRC red-adapter.ts:304 prnLadder] |
| `INNER_QTY` (책자 내지) | `page-counter-input` | ✅흡수 | [SRC red-adapter.ts:285] GRP_INNER_PAGE |
| `QTY` (책자 부수) | `counter-input` | ✅흡수 | GRP_QUANTITY |
| `starting-month/year` | `select-box` enum | ✅흡수 | 어댑터 enum 그룹 |
| `r1/r2/r3` (후가공 radio) | `finish-button` ×N | ✅흡수 | [SRC red-adapter.ts:247 mapPcsGroups] PCS_CD 그룹화 |
| `SUM_MTR/<자재명>` (자재합산 add-on) | `finish-button` | ✅흡수(**NC-2 판정 적용**) | [EXP NC-2 확정][DA §5] selectedFinishes echo |
| `CVR_INN` (표지/내지 분리) | `ProductSide=[default,inner]` 분기 | ✅흡수(구조 분기, componentType 무관) | [SRC red-adapter.ts:56 hasInner] |
| `INN_DFT` (내지 자동기본) | hidden essential `required+visible:false` | ✅흡수(평면화) | [SRC red-adapter.ts:128 VIEW_YN] |
| 후가공 색상값(colorHex 有) | `color-chip` / `mini`/`large` | ✅흡수 | [SRC pcsComponentType(hasColor)] — Red 캡처엔 colorHex 부재라 현재 전부 finish-button |
| 자재 이미지(imageUrl 有) | `image-chip` | ✅흡수 | DATASET 매핑(현 Red 캡처 미발현) |

### 2.2 진짜 신규 componentType 필요한 구조 — **0건**

46 구조 전부 구현된 16-case dispatcher로 **신규 case 없이** 라우팅된다. 의심 후보 정밀 판정:

| 의심 후보 | 우려 | 판정 | 결론 |
|-----------|------|------|------|
| `SUM_MTR/*` (자재합산형, 21 SKU) | 새로운 "add-on 가격델타" 컴포넌트 필요? | 부자재는 텍스트 라벨 선택뿐(색상/이미지/델타숫자 없음). 가격합산은 BFF. | **finish-button 흡수. 신규 0** [EXP NC-2 GO] |
| `CVR_INN` (표지/내지, 3 SKU) | 새 면분리 컴포넌트? | 책자 `hasInner`와 동일 ProductSide 분기 — componentType이 아니라 구조 분기. | **기존 분기 흡수. 신규 0** |
| `INN_DFT` (내지 자동, 7 SKU) | 새 hidden 처리? | `ESN_YN=Y & VIEW_YN=N` hidden essential 평면화 — 계약·구현 이미 보유. | **신규 0** |
| `thickness`/`set-color`/`material-filter`/`dosu-color` (minor select) | 새 select 변형? | 전부 값 선택형 = select-box/option-button. 데이터셋 이름만 다름(RULE-5 동적 라벨). | **신규 0** |
| `CLD_STD` (옵셋 캘린더, 1 SKU) | 폐쇄 래더 새 입력? | prnLadder → select-box enum 재사용(임의값 0원 방지). | **신규 0(재사용)** |
| `starting-month/year` (캘린더, 3 SKU) | 월/년 피커 새 컴포넌트? | 단순 enum select-box(12개월/연도 목록). 별도 date-picker 불요. | **신규 0** |
| `material-filter` (글라스범퍼, 6 SKU) | 자재 종속필터 새 캐스케이드? | select-box 1개 추가 + 기존 disable 캐스케이드. | **신규 0** |

> **NC-1(dimension-matrix-input)은 "신규"가 아니라 "이미 구현됨"**: real_price + 0×0 sentinel 구조([SRC red-adapter.ts:179])는
> F5 에코백(AIPPCUT, real_price)에서 자동 발동하며 dispatcher case가 이미 존재([SRC OptionControl.tsx:43]).
> S3(포스터/실사) Red fixture 미캡처 상태지만 **컴포넌트·계약·dispatcher는 준비 완료** — 데이터만 대기 [EXP §6.3].
> **NC-3(image-option-selector)은 현 46 구조에서 미발현** — Red 캡처에 64×64 이미지셀렉터 요구 SKU 없음.
> S5 후니 굿즈 확장 시 image-chip variant 우선 검토(미확정) [EXP §3]. 현 스캔 범위 내 **신규 필요 0**.

**완전성 결론: 46/46 구조가 구현된 dispatcher로 신규 componentType 0건. 키스톤(계약+어댑터) 커버리지 100%.**

---

## 3. 계약/어댑터 매칭 슬롯 (후니 데이터가 채울 템플릿)

정규화 계약([SRC src/contract/])이 product+price를 받는 슬롯과, 그 슬롯을 채우는 Red 원천([SRC red-adapter.ts]).
이 표가 **후니 데이터가 동일하게 채워야 할 템플릿**이다([DBMAP §1]에 후니 테이블 대응 존재).

### 3.1 Product 슬롯 (`NormalizedProduct`)

| 계약 슬롯 | Red 원천(ORD/옵션) | 어댑터 변환 [SRC] | 후니 채움 [DBMAP] |
|-----------|---------------------|---------------------|---------------------|
| `code` | `option.pdt_cod` | 그대로(불투명) | `t_prd_products.prd_cd` |
| `name` | `option.pdt_nme` | 그대로 | `prd_nm` |
| `unit` | `pdt_base_info[0].PDT_UNIT` | 그대로 | 파생(G6: bdl_unit_nm) |
| `priceSchemeKey` | `option.price_gbn` | 불투명 echo | category prefix(미작성) |
| `sides` | `inner_pdt_*` 존재 | hasInner→[default,inner] | t_prd_product_sets(G2) |
| `optionGroups[]` | size/mtrl/dosu/pcs/prn_cnt 데이터셋 | §1 componentType 매핑 | 옵션 마스터 테이블군 |
| `optionGroups[].values[].id` | MTRL_CD/PCS_DTL_CD/SIZE_seq | 불투명 id | 후니 코드(불투명) |
| `optionGroups[].values[].priceColorCount` | `pdt_dosu_info.PRN_CLR_CNT` | dosu 평면화 | t_clr_color_counts.chnl_cnt |
| `constraints.disableRules[]` | `pdt_disable_pcs_info[]` | MTRL_CD→trigger, PCS→disables | constraint_json(G1, 미작성) |
| `constraints.quantity` | `pdt_prn_cnt_info` (FIR/INC/내지MIN/MAX) | buildQuantityRule | min/max/dflt_qty + page_rules |
| `constraints.sizeRules[]` | `pdt_size_info` (CUT/WRK) | SizeRule | t_siz_sizes.cut/work |
| `constraints.base` | `pdt_base_info` (margin/min/max/nonStd) | BaseRule | t_siz_sizes + nonspec_* |
| `editors` | useKoiEditor/useRPEditor/usePDF | EditorCapability | editor_yn/file_upload_yn |
| `cta` | DESIGN 부록A 파생 | CtaCapability | 동일 파생 |

### 3.2 Price 요청 슬롯 (`NormalizedPriceRequest` → Red ORD_INFO/PCS_INFO)

[SRC red-adapter.ts:388 serializeRedPriceRequest] — **후니 매칭 시 가장 주의할 행 shape**:

| 계약 슬롯 | → Red ORD_INFO/PCS_INFO 필드 | 비고 |
|-----------|------------------------------|------|
| `productCode` | `ORD_INFO[0].PDT_CD` | echo |
| `dimensions[0].cutW/cutH/workW/workH` | `CUT_WDT/CUT_HGH/WRK_WDT/WRK_HGH` | 단일 차원(책자도 표지 기준 1행) |
| `quantity` | `ORD_INFO[0].ORD_CNT` | **주문건수**(굿즈=디자인 수) |
| `printCount` | `ORD_INFO[0].PRN_CNT` | **인쇄수량** — 분리 [SRC:397]. 미전달 시 1(하위호환) |
| `colorCounts.default` | `PRN_CLR_CNT` | dosu 평면화값 |
| `materials.default` | `MTRL_CD` | 불투명 자재 id |
| `selectedFinishes[]{groupId,valueId}` | `PCS_INFO[]{PCS_COD,PCS_DTL_COD}` | groupId `PCS_` prefix 제거 역매핑 [SRC:405] |
| `priceSchemeKey` | `price_gbn` | 불투명 echo |
| `pageCount` | (책자) PAGE_CNT | 상품군 분기 |

### 3.3 Price 응답 슬롯 (`NormalizedPriceBreakdown` ← Red)

[SRC red-adapter.ts:429 mapPriceResponse] — 3단 워터폴은 어댑터가 finalPrice로 평면화:

| 계약 슬롯 | ← Red 원천 | 평면화 |
|-----------|-----------|--------|
| `finalPrice` | PRICE_MALL≠PRICE ? PRICE_MALL : ORG_PRICE≠PRICE ? PRICE : ORG_PRICE | 3단 워터폴 [DA §2.4] |
| `vat` | 대응 _VAT | 워터폴 동조 |
| `shipping` | `book_info.DLVR_AMT` | 책자 배송 |
| `lines[]{code,label,amount}` | `result[].{PCS_CD, PRICE}` | 공정별 분해(선택적) |
| `ok` | `retCode===200` | 가드(미견적=false) |

> **후니 매칭 시:** 후니 가격 API([DBMAP §2]는 엑셀 4모델 `QuoteResult`)는 위 슬롯을 **자기 형태로** 채운다 —
> `total→finalPrice`, `vatAmount→vat`, `deliveryFee→shipping`, `breakdown[]→lines[]`(8 axis). Red ORD_INFO 행 shape를
> 후니가 따를 필요 없음(INV-1, [DA §4.2]). **위젯은 어느 쪽도 모름.**

---

## 4. 후니 매칭 시 위젯측에서 간과하기 쉬운 것 (체크리스트)

후니 상품마스터/가격을 위젯에 끼워 맞출 때 **위젯측 관점**에서 빠뜨리기 쉬운 항목. 각 항목은 위젯 코드가 아니라
**어댑터/데이터 채움**에서 처리되지만, 누락하면 위젯이 침묵 오작동(빈 그룹/0원/잘못된 캐스케이드)한다.

### CHK-1 — price_gbn 불투명성의 역함정 (가장 중요)
- price_gbn은 위젯에 echo만 → **후니 가격모델 이름은 무관**. [SCAN-B 실측] 정확히 **10 named 모델 + null** =
  `digital_price · tmpl_price · vTmpl_price · tmpl_calc_price · vTmpl_calc_price · tiered_price · book2025_price · offset2023_price · clothes2025_price · real_price` (+ null 2구조). 문서화 4모델군보다 많으나 전부 불투명.
- **그러나 옵션→PCS_INFO/ORD_INFO 행 shape는 반드시 일치해야 한다**: [SRC s5 실측] tmpl/tiered_price는 ORD_INFO[0]에
  **ORD_CNT+PRN_CNT 둘 다** 있어야 PRICE>0(둘 다 누락 시 **침묵 0**). 후니 어댑터가 quantity/printCount 분리를
  잘못 직렬화하면 위젯은 정상인데 0원이 나온다. **어댑터 quote() 가드(`isPriceRequestQuotable` [SRC:415]) 반드시 후니에도.**

### CHK-2 — hidden-essential (INN_DFT / VIEW_YN=N) 누락
- INN_DFT(7 SKU), 재단(CUT_DFT) 등 "필수이나 미표시·자동적용" 그룹은 UI에 안 보이지만 **가격요청에 포함**되어야 한다.
- 후니는 `VIEW_YN` 컬럼이 없음([DBMAP §1.3 주2, G5]) → 어댑터가 visible을 계산하지 않으면 **자동공정이 가격에서 누락**.
- 체크: 후니 어댑터가 `required:true + visible:false` 그룹의 default value를 selected로 미리 주입했는가([DA §2.3]).

### CHK-3 — defaultSelections (첫 진입 상태)
- 위젯은 첫 값을 기본 선택([SRC] store.defaultSelections). 후니 데이터에 `dflt_yn`(기본규격/기본도수)이 없으면
  **dimension-matrix는 빈 자유입력으로 진입 → 0원**([SRC red-adapter.ts:183 정렬로 DFT_YN=Y 선두]).
- 체크: 후니 size/dosu에 기본값 플래그 매핑 + dimension-matrix/prnLadder는 기본값을 **선두 정렬**.

### CHK-4 — 캐스케이드 disable 규칙 (G1, 후니 미작성)
- 자재→후가공 disable은 후니에 **데이터 자체가 미작성**([DBMAP §3 G1/B2]). 어댑터가 비우면 위젯 캐스케이드 엔진은
  정상이나 **disable이 0개** → 사용자가 불가능 조합 선택 가능 → BFF가 0원/에러.
- 체크: 후니 `constraint_json` 또는 종속/택일 그래프→`DisableRule[]` 파생([DBMAP R1]). 오늘은 Red fixture로 엔진 검증.

### CHK-5 — W/H work-size 공식 (WH 토큰)
- 46 구조 중 종이/자재류 전부 `WH` 보유 = 작업치수(workW/H) = 재단마진 가산. [SRC] sizeRules에 cut/work 4값.
- 후니는 `t_siz_sizes.work_width/height` 직접 보유([DBMAP §1.3-④ ○직접)이나, **비규격(nonspec)은 work 산출 공식**이
  필요(cutW + 2×cutMargin 등). 어댑터가 nonspec일 때 work를 계산하지 않으면 가격 차원이 틀어진다([DBMAP §1.4 G3/G4]).
- 체크: dimension-matrix(NC-1) 자유입력 시 cutW/cutH→workW/workH 파생 경로([SRC DimensionMatrixBridge]).

### CHK-6 — SUM_MTR add-on 의 selectedFinishes echo
- 자재합산형(21 SKU)의 부자재는 finish-button echo([§1 F5]). 후니가 부자재를 **별 옵션 테이블**(t_prd_product_addons)로
  두면, 어댑터가 이를 `selectedFinishes`(PCS 그룹)로 사상해야 한다. 잘못 두면 가격합산에서 부자재가 빠진다.
- 체크: 후니 addon→OptionGroup(finish-button)+selectedFinishes 직렬화 일치([DA §5], [DBMAP G9 세트/애드온).

### CHK-7 — 폐쇄 래더 vs 자유 counter (PRN_CNT 분기)
- 옵셋 캘린더(CLD_STD)·일부 상품은 **폐쇄 수량 래더**(등록값만 단가 보유). 자유 counter로 렌더하면 임의값=PRICE 0.
- 후니에 이 분기 신호(FIR/INC null = 래더)가 어떻게 오는지([SRC prnCntLadder 판정])를 후니 데이터로 재현해야 한다.
- 체크: 후니 수량 정의가 자유범위(min/max/incr)인지 enum 목록인지 구분 → select-box enum vs counter-input 분기.

### CHK-8 — 면별 uploadType (책자/CVR_INN editor vs pdf)
- 표지=editor, 내지=pdf 분기는 Red 캡처에 명시 필드 부재([SRC red-adapter.ts:60 @MX:WARN O3 미확정).
- 후니는 `editor_yn/file_upload_yn`이 **상품 단위 2플래그**([DBMAP §1.1)라 **면별 분기 신호가 없을 수 있음**.
- 체크: 후니 책자/케이스(CVR_INN)에서 표지/내지 입력수단을 면별로 결정할 데이터가 있는가. 없으면 어댑터 규약 고정.

### CHK-9 — code 안정성 (round-trip) — 무결성 결함 흡수
- 후니 cat 010/011(굿즈/파우치, F2·F5 다수)은 **MES ITEM_CD 미부여**([DBMAP PM-MISS-01], [EXP §6.2]).
  코드 중복(PM-DUP)·미부여가 있어도 위젯은 불투명 id round-trip만 하므로 무관하나, **어댑터 키가 흔들리면**
  옵션 selected가 가격요청에서 매칭 실패.
- 체크: 후니 어댑터가 `(code [+side/variant])` 안정 복합키 발급 — **어댑터 계약 테스트로 게이트**([EXP §6.2]).

### CHK-10 — 빈 옵션/미가격 상품 (F8)
- 무지/세트구성품(F8, 6 SKU, price_gbn=null)은 옵션 0~1개 + 가격 미연동. 위젯은 빈 optionGroups를 안전 렌더하나,
  **가격영역을 어떻게 표시**할지(비견적/전화주문) 어댑터가 `ok:false` 신호를 줘야 한다(위젯이 0원 표시 방지).
- 체크: 후니 미가격 상품에 대한 BFF `ok:false` + 위젯 가격영역 미표시 경로.

---

## 5. 요약 (오케스트레이터 반환용)

| 항목 | 값 |
|------|-----|
| 전수 상품 / 구조 | 479 / **46 시그니처** (ZERO legacy, 전부 Vue3 신위젯) |
| 패밀리 | F1 종이류(7) · F2 자재류(9) · F3 책자(4) · F4 표지내지/노트(4) · F5 자재합산(15) · F6 캘린더(2) · F7 의류(3) · F8 무지(2) |
| 진짜 신규 componentType 필요 | **0건** — 46/46 구조가 구현된 16-case dispatcher로 신규 case 없이 흡수 |
| 의심 후보 판정 | SUM_MTR/CVR_INN/INN_DFT/thickness/set-color/material-filter/CLD_STD/starting-* **전부 흡수**(finish-button/select-box/ProductSide분기/hidden-essential) |
| 가격모델(price_gbn) 종류 | **10 named + null** 실측[SCAN-B](digital/tmpl/vTmpl/tmpl_calc/vTmpl_calc/tiered/book2025/offset2023/clothes2025/real + null×2) — 위젯엔 불투명 echo(INV-1), BFF 4모델로 정규화 |
| 위젯 매칭 간과 체크리스트 | 10항목(CHK-1 price 행 shape ~ CHK-10 미가격 상품) — 전부 어댑터/데이터 채움 책임, 위젯 코드 0 |
| dispatcher 실측 | 16 case = DESIGN 14 + dimension-matrix-input(NC-1 구현됨) + finish-select-box [SRC OptionControl.tsx] |

> **결론:** Red 전 카탈로그(46 구조)는 현재 구현된 위젯 dispatcher로 **신규 componentType 0건** 완전 흡수.
> long-tail 다양성(SUM_MTR 자재합산·r1~r3 후가공·CVR_INN/INN_DFT 면구조)은 전부 기존 finish-button/select-box/
> ProductSide 분기/hidden-essential 평면화로 사상된다. 후니 매칭은 §3 슬롯 템플릿을 후니 데이터로 채우고 §4 10개
> 체크리스트를 어댑터에서 보장하면 **위젯 코드 무변경**으로 완료된다(키스톤 가설 실증).
