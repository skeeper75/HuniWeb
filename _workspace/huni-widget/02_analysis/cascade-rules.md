# 옵션 캐스케이드 규칙 (구현 가능 형태)

> 파이프라인 ② 산출물. 옵션 간 의존성·제약 적용 알고리즘. 후니 위젯이 그대로 구현 가능하도록 정규화.
> 근거: `[라이브 관찰]` 본 세션 스토어 캐스케이드 / `[정적+라이브]` Phase 1 + cascade_captures 정규화 추출 / `[정적 분석]` deob 소스.
> 데이터 원본: Phase 1 `product_*.json` + `raw/widget_monitor/cascade_captures/*_constraints.json` (정규화된 제약 추출, PRBKORD 31 disable rule 등).

---

## 0. 제약(constraint) 타입 6종 [정적+라이브]

cascade_captures 정규화 추출(`extract-constraints-from-existing.cjs`)로 확인된 제약 타입:

| # | 타입 | 원천 데이터셋 | 트리거 | 효과 |
|---|------|--------------|--------|------|
| 1 | **material→pcs disable** | `pdt_disable_pcs_info` (disablePcsRules) | 자재(MTRL_CD) 선택 | 특정 후가공(PCS_CD) 비활성 |
| 2 | **quantity 제약** | `pdt_base_info`/quantityConstraints | 수량·페이지 입력 | MIN/FIR/INC/STEP·페이지 MIN/MAX 강제 |
| 3 | **dosu↔bnc 매핑** | `pdt_dosu_bnc_info` (dosuBncMapping) | 도수(색상수) 선택 | 제본그룹(BNC) 결정, 내지/표지 색도 분기 |
| 4 | **size 제약** | `pdt_size_info` (sizeConstraints) | 규격 선택 | CUT/WRK 치수 세팅·비표준 허용여부 |
| 5 | **pcs essential/hidden** | `pdt_pcs_info` (pcsConstraints, ESN_YN/VIEW_YN) | 상품 로드 | 필수 자동적용·숨김 후가공 결정 |
| 6 | **base 제약** | `pdt_base_info` (baseConstraints) | 상품 로드 | 단위·재단마진·최소/최대 치수·set수량 |

> Phase 1은 #1(material→pcs)만 다뤘으나, 라이브 cascade_captures 정규화로 **6종 전체 확정**. 후니 구현은 6종 모두 룰엔진으로 처리.

---

## 1. material → pcs disable (캐스케이드 핵심) [정적+라이브]

### 데이터 형태 (`pdt_disable_pcs_info`)
```json
{ "MTRL_CD": "RXOMO080", "PCS_CD": "COT_DFT", "PCS_DTL_CD": null }
```

### PRBKYPR 실데이터 — 24건 (자재별 그룹) [라이브 관찰]
```
RXOMO080 (모조80g)  → 비활성: COT_DFT(코팅), FLD_DFT(접지), MIS_DFT(미싱), PRT_MAG(자석),
                              SCO_DFT/SCO_GLD/SCO_SLV(스코딕스)              [7건]
RXOMO100 (모조100g) → 위 7 + LAM_DFT(라미네이팅), OSI_DFT(오시)              [9건]
RXPLM080/RXPLM100/RXPLW080/RXPLW100 (플러스/백색 80·100g)
                    → COT_DFT, MIS_DFT                                       [각 2건]
```
> 규칙: 저평량(모조·플러스지)·비코팅용지 선택 시 코팅·후가공 계열 일괄 비활성. PRBKORD(트윈링)는 31건.

### 적용 알고리즘 (구현)
```
on materialChange(side, MTRL_CD):           # side ∈ {default(표지), inner(내지)}
  disabledPcs = disable_pcs_info.filter(r => r.MTRL_CD === MTRL_CD)
  for rule in disabledPcs:
    if rule.PCS_DTL_CD == null:
      pcsUI.disableGroup(rule.PCS_CD)        # PCS 그룹 전체 비활성
    else:
      pcsUI.disableDetail(rule.PCS_CD, rule.PCS_DTL_CD)   # 특정 상세만
    if orderData.pcsInfo.has(rule.PCS_CD selected):
      orderData.pcsInfo.deselect(rule.PCS_CD)  # 선택돼 있었으면 해제(연쇄)
  triggerPriceRecalc()                       # 해제로 가격 변동 → 재계산
```
> **적용 순서 중요**: 자재변경 → disable 룩업 → UI disable → 선택해제 → 가격재계산. 선택해제가 가격에 영향을 주므로 재계산은 disable 처리 후. [정적+라이브]

## 2. quantity 제약 [라이브 관찰]

### 데이터 (quantityConstraints, PRBKORD 실측)
```json
{ "firstCount":1, "incrementCount":10, "incrementStep":10, "minPrintCount":1,
  "defaultPrintCount":10,
  "minInnerPage":2, "maxInnerPage":130, "stepInnerPage":1,
  "maxThickness":1000, "innerMaxWeight":1000, "coverMinWeight":200 }
```
(PRBKYPR: FIR=1, INC=10, STEP=10, MIN_PRN=30, 내지페이지 MIN=10 MAX=300 — Phase 1)

### 적용 알고리즘
```
validateQuantity(prnCnt):                    # 주문수량(권)
  if prnCnt < minPrintCount: clamp to minPrintCount
  # FIR/INC/STEP: firstCount부터 incrementStep 단위로만 허용
  allowed = firstCount + k*incrementStep  (k=0,1,2...)
  snap prnCnt to nearest allowed (반올림)
validateInnerPage(pageCnt):
  clamp [minInnerPage, maxInnerPage], step=stepInnerPage
  # 두께/무게 제약: pageCnt * 내지평량 ≤ maxThickness/innerMaxWeight (정적)
```
- 수량/페이지 변경 → orderData.quantityInfo {ordCnt, prnCnt} 갱신 → 가격 재계산 트리거. [라이브 관찰: quantityInfo 스토어 필드]

## 3. dosu(색상수) ↔ bnc(제본) 매핑 [정적+라이브]

### 데이터 (dosuBncMapping, PRBKORD 실측)
```json
[ {"printColorCount":8,"code":"SID_D","codeName":"양면","bindingGroup":"BNC_COL"},
  {"printColorCount":4,"code":"SID_S","codeName":"단면","bindingGroup":"BNC_COL"},
  {"printColorCount":8,"code":"SID_D","codeName":"양면","bindingGroup":"BNC_COL","type":"inner","note":"책자 내지 인쇄색도"} ]
```
### 규칙
- 도수 선택(SID_S 단면=4색 / SID_D 양면=8색) → `PRN_CLR_CNT` 결정 → 가격 ORD_INFO의 `CVR_CLR_CNT`(표지)·`INN_CLR_CNT`(내지)로 매핑.
- `type:"inner"`가 붙은 항목은 내지 색도 전용 — 표지/내지 도수 독립 선택. [라이브: store에 dosuInfo + inner_dosuInfo 분리]
- 라이브 관찰: 옵션 변경으로 INN_CLR_CNT가 4→8로 캐스케이드됨(양면 선택 효과). [라이브 관찰 — priceCalc.params]

## 4. size 제약 [정적+라이브]

### 데이터 (sizeConstraints, 책자 실측)
```json
{ "divName":"A4세로형","workWidth":220,"workHeight":307,"cutWidth":210,"cutHeight":297,
  "isDefault":true,"isHidden":false }
```
- 규격 선택 → CUT_WDT/HGH·WRK_WDT/HGH 세팅(도련=WRK-CUT, 보통 ±10mm) → orderData.sizeInfo.cutSize/workSize. [라이브 관찰: sizeInfo 스토어]
- `isHidden:true` 규격은 UI 미표시. `nonStandardAllowed:"N"`이면 자유치수 입력 불가(baseConstraints).
- baseConstraints: minCut 50x50, maxCut 500x730, cutMargin 10 (PRBKORD).

## 5. pcs essential/hidden 분류 [정적+라이브]

### 데이터 (pcsConstraints, ESN_YN/VIEW_YN)
| 상태 | ESN_YN | VIEW_YN | 동작 |
|------|--------|---------|------|
| hidden(자동) | Y | N | 필수이나 미표시 — 자동 적용(예 CUT_DFT 재단) |
| visible-essential | Y | Y | 필수 + 표시(예 RIN_DFT 링제본 좌철) |
| optional | N | Y/N | 선택적 |
- 상품 로드 시 hidden essential은 orderData.pcsInfo에 자동 포함(VIEW_YN=N으로 관찰됨 — GSTGMIC pcsInfo: WRK_MTR/COT_DFT/PDT_WRK/PAK_POL 모두 VIEW_YN:N ESN_YN:Y). [라이브 관찰]
- `SUB_MTRL_YN:"Y"`는 하위자재 연동 후가공.

## 6. 캐스케이드 전체 적용 순서 (구현 마스터) [정적+라이브]

```
상품 로드:
  1. baseConstraints/quantityConstraints/sizeConstraints 세팅
  2. pcsConstraints 분류 → hidden essential 자동 적용
  3. 기본 규격·자재·도수로 orderData 초기화
  4. 초기 가격 호출

사용자 변경 (변경 종류별):
  규격 변경  → sizeInfo(CUT/WRK) 세팅 → 가격재계산
  자재 변경  → [1]disable_pcs 룩업 → [2]후가공 UI disable → [3]선택해제 → 가격재계산
  도수 변경  → dosuBncMapping → CLR_CNT(표지/내지) → 가격재계산
  수량/페이지 변경 → quantity 제약 clamp/snap → 가격재계산
  후가공 변경 → pcsInfo 갱신(disable된 건 선택 불가) → 가격재계산

공통 후처리: orderData.priceCalc.params 재조립 → debounce(300ms) → price API
```

---

## 7. 후니 시사점

1. **6종 제약을 정규화 룰셋으로 분리** — 후니 DB는 disablePcsRules/quantityConstraints/dosuBncMapping/sizeConstraints/pcsConstraints/baseConstraints 6 테이블(또는 JSON 컬럼)로 정규화. 위젯은 이 정규화 계약만 소비(어댑터가 후니 DB→정규화 변환).
2. **자재→후가공 disable는 클라이언트 룰엔진** — 서버 왕복 없이 즉시 UI 반영(라이브 확인: 캐스케이드는 스토어 내부 처리, disable_pcs는 product_info에 동봉).
3. **선택해제 연쇄 → 가격재계산 순서 보존** — disable로 인한 자동 해제가 가격에 반영되도록 재계산은 항상 캐스케이드 처리 후.
4. cascade_captures(`PRBKOPR/PRBKORD/PRBKOST/...`)에 책자 변종별 정규화 제약이 이미 추출돼 있음 — 후니 제약 마스터 시드로 활용 가능.

## 8. 잔존 미검증
- 굿즈/아크릴 disable_pcs 0건(제약 없는 상품만 캡처) — 캐스케이드 미발생 군. [미관찰]
- 아크릴 option_info(제작방식/형태) 캐스케이드 — 실값 null. [미검증]
- 두께/무게(maxThickness/innerMaxWeight) 클라이언트 강제 여부 — 데이터만 확인, 강제 로직 미관찰. [정적]
