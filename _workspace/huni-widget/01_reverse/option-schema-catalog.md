# 옵션 스키마 카탈로그 (상품군별 + 캐스케이드 제약)

> 파이프라인 ① 산출물. 라이브 `get_digital_product_info` 응답에서 추출. 머신리더블: `option-schema-catalog.json`.
> 근거: `[라이브 검증]` 3상품(PRBKYPR/GSTGMIC/ACNTHAP) 실응답.

---

## 1. 카탈로그 개요 [라이브 검증]

- 전체 479 상품 (`redprinting_catalog.json`). 26 카테고리.
- 상위: GS(굿즈) 136, PR(인쇄/책자) 56, ST(스티커) 36, PH(포토) 30, CL(의류) 30, TP, BN, FS, AC(아크릴) 20 ...
- 신규 Vue3 위젯 대상 ~25개(책자 PRBKY*/PRBKO*, 굿즈 GS*, 아크릴 AC*), 나머지는 레거시 jQuery.
- 코드 규칙: `{카테고리2}{타입}{특성}` (예 PRBKYPR = PR+BK(book)+YPR).

## 2. 상품군별 옵션 스키마 [라이브 검증]

### 책자 (PRBKYPR — 무선책자 컬러)
- 단위: 권. price_gbn: `book2025_price`. 에디터: KOI+RP+PDF.
- 18 데이터셋 (내지 `inner_pdt_*` 4개 포함 — **표지/내지 분리 구조**).
- 규격: A4세로형 외, CUT 210x297 / WRK 220x307(도련 10mm).
- 수량 규칙: FIR=1, INC=10, STEP=10, MIN_PRN=30, 내지 페이지 MIN=10 MAX=300.
- 자재: 표지(pdt_mtrl_info, 예 RXART300 아트지300g) + 내지(inner_pdt_mtrl_info, 예 RXYWM080 윤전백색모조80g).
- 도수: SID_S(단면, 4색).
- 후가공(pdt_pcs_info) 20개: COT_DFT(코팅), CUT_DFT(재단), BIND_DIRECTION(제본방향), BON_PAP(합지) 등.
- **캐스케이드 제약 24건** (아래 §3).

### 굿즈 (GSTGMIC — 마이크 네임택)
- 단위: 개. 11 데이터셋 (내지 없음 — 단순 구조).
- 규격: 351x241(CUT). 수량 FIR=1 INC=1.
- 후가공 11개. disable_pcs 0건(제약 없음).
- 부자재 인스턴스(`AccWidgetInstance` / `useAccOrderStore`) 가능성 높은 군.

### 아크릴 (ACNTHAP)
- 6 데이터셋 + **`option_info`** 추가(아크릴 전용): `production_method`(제작방식), `shape_info`(형태), `print_data`(인쇄데이터).
- 후가공 4개: BON_PAP(아크릴합지) 등. disable_pcs 0건.

## 3. 캐스케이드 제약 (material → pcs disable) [라이브 검증]

`pdt_disable_pcs_info` = **특정 자재(MTRL_CD) 선택 시 비활성화되는 후가공(PCS_CD)** 매핑. 책자 24건 캡처.

예 (라이브):
```json
[ {"MTRL_CD":"RXOMO080","PCS_CD":"COT_DFT","PCS_DTL_CD":null},   // 모조지80g → 코팅 비활성
  {"MTRL_CD":"RXOMO080","PCS_CD":"FLD_DFT","PCS_DTL_CD":null},   // 모조지80g → 접지 비활성
  {"MTRL_CD":"RXOMO080","PCS_CD":"MIS_DFT","PCS_DTL_CD":null} ]
```

규칙 [라이브 검증]:
- `MTRL_CD` 매칭 시 해당 `PCS_CD` 후가공을 UI에서 disable.
- `PCS_DTL_CD`가 null이면 그 PCS 그룹 전체 비활성, 값이 있으면 특정 상세만 비활성.
- 후니 위젯: 자재 변경 이벤트 → disable_pcs_info 룩업 → 후가공 옵션 disable + (선택돼 있었으면)해제.

## 4. 후가공 분류 (visible/hidden/essential) [정적 분석]

`deob_06:596` classifyPostProcessOptions:
- `hidden`: ESN_YN="Y" && VIEW_YN="N" (필수이나 미표시 — 자동 적용)
- `visible`: ESN_YN="Y" && VIEW_YN="Y" 또는 선택적(ESN_YN="N")
- `essential`(sub): SUB_MTR 계열(하위 자재 관련)

PCS 항목 주요 필드: `PCS_COD`(공정), `PCS_DTL_COD`(상세), `PCS_GRP_NME`(그룹명), `ESN_YN`(필수), `VIEW_YN`(표시), `SUB_MTRL_YN`(하위자재), `QTY_INPUT_YN`(수량입력).

## 5. 가격 요청 매핑 [라이브 검증]

옵션 스키마 → 가격 ORD_INFO/PCS_INFO 매핑:
- size_info.CUT_WDT/HGH → ORD_INFO.CUT_WDT/HGH, WRK_* → WRK_*
- mtrl_info.MTRL_CD → CVR_MTRL_CD, inner_pdt_mtrl_info.MTRL_CD → INN_MTRL_CD
- dosu_info.PRN_CLR_CNT → CVR_CLR_CNT / INN_CLR_CNT
- prn_cnt → PRN_CNT, 내지페이지 → PAGE_CNT
- 선택 후가공 → PCS_INFO[{PCS_COD, PCS_DTL_COD}]

## 6. 잔존 미검증

- Vue3 위젯 적용 25개 상품 전수 스키마(3개만 라이브 캡처). [부분]
- 굿즈/아크릴의 캐스케이드 제약(현재 0건 — 제약 없는 상품만 캡처). [미검증]
- option_info(아크릴 제작방식/형태) 실값(현재 null COD만). [미검증]
