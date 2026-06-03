# major-capture-note.md — S3 MAJOR 라운드 라이브 캡처 노트 (Wave B/C 베이스라인)

> hw-runtime-analyst · 2026-06-03. 신선 로그인 세션(extract-cookies 재추출, 토큰 valid, 쿠키 14개) + fresh server.js(:3001, 쿠키 메모리 재로드, HANDOFF §6 준수).
> 캡처 = `get_digital_product_info` 옵션 페이로드 read(저비용 GET). 주문·결제 미트리거. 전체출력 JWT redact, 누출 0건 검증.
> 입력 계획: `07_parity/s3-major-round-plan.md` Wave B(L-1 속성칩·L-3b 반경) + Wave C(의류·ACC).

---

## 0. 캡처한 productCode 요약

| Wave | 타깃 | productCode | 결과 | 캡처 파일 |
|------|------|------------|------|----------|
| B / L-1 + L-3b | 속성칩 ATTB + 반경 | **BCFOXXX** (박/형압 명함) | ✅ FOI 박 속성칩 57엔트리 + ROU_DFT 4귀(DIV_SEQ=0) **한 상품에 둘 다** | `major_attbchip_BCFOXXX.json` |
| B / L-1 보조 | RIN_DFT 링색 ATTB | **HLCLWAL** (벽걸이 캘린더) | ✅ RIN_DFT 가격측 ATTB_CD/ATTB_NM shape | `major_attbchip_HLCLWAL.json` |
| B / L-3b | 반경 sourcing | **BCSPDFT** (일반 명함) | ✅ ROU_DFT 4귀 DIV_SEQ=0·ATTB 없음(반경 미저장 재확인) | `major_radius_BCSPDFT.json` |
| C / D-L2 | 의류 clothes2025 | **CLSTSHS** (5.6oz 하이퀄리티 티셔츠) | ✅ apparel_info 풀 shape(PRINT_TYPE 3·사이즈 7·색 54·팬톤 1124) | `major_apparel_CLSTSHS.json` |
| C / D-L2 보조 | 의류 변종 | **CLTMSHS** (단체티-반팔) | ✅ 동일 3 PRINT_TYPE·사이즈 9·색 6 | `major_apparel_CLTMSHS.json` |
| C / L-12 | ACC 부자재 | **ACPDSTD** (아크릴 등신대) | ✅ SUM_MTR 부자재 12옵션(받침대 모양×크기) | `major_acc_ACPDSTD.json` |

> 보조 캡처(ACTHDKY/STDRCAD)는 ROU_DFT 부재(LAS_DFT 레이저컷)로 음성 확인용. STFODFT(박 스티커)도 FOI 동형 — BCFOXXX로 대표.

---

## 1. 속성칩 ATTB (Wave B, L-1) — 실값 베이스라인

### 1.1 박(FOI) 속성칩 — BCFOXXX (selectable 속성칩의 진짜 메커니즘)

`major_attbchip_BCFOXXX.json` scan — **박 후가공은 FOI_* PCS_CD 패밀리로 표현**, 각 색·광택·면이 **별 PCS_DTL_CD**:
```
PCS_CD=FOI_GDG(금박유광) PCS_GRP_NM="박"
  PCS_DTL_CD=TFGGS 금박유광단면 / TFGGD 금박유광양면   WEB_PCS_DTL_GRP=FOI_GDG_TF
PCS_CD=FOI_GDM(금박무광): TFGMS 금박무광단면 / TFGMD 금박무광양면
... FOI_SVG/SVM(은박), FOI_RED/BLK/BLU/GRN/BRN(유색박), FOI_HOL/HLG(홀로그램), FOI_RGG(로즈골드) 등 총 57 detail
```
- **핵심:** Red의 속성칩은 별도 `ATTB` 숫자필드가 아니라 **`{PCS_CD 패밀리}×{WEB_PCS_DTL_GRP}×{PCS_DTL_CD}`로 인코딩된 선택 옵션 그리드**다. 박색(금/은/유색/홀로)=PCS_CD, 광택/면(유광·무광·단면·양면)=PCS_DTL_CD. VIEW_YN=Y, ESN_YN=Y.
- **Wave B 재현 베이스라인:** L-1 속성칩 슬롯(BLOCKER서 준비)은 이제 **FOI 패밀리 → finish-button 그리드(WEB_PCS_DTL_GRP으로 묶음)**를 채울 실데이터를 가짐. 어댑터는 `PCS_CD.startsWith('FOI')` 박 그룹을 WEB_PCS_DTL_GRP_NM 라벨로 그룹핑, 선택값을 `{PCS_COD, PCS_DTL_COD}`로 echo. 타우톨로지 아님(57개 실 detail 코드 보유).

### 1.2 링(RIN_DFT) 속성칩 — HLCLWAL (가격측 ATTB shape)

`major_attbchip_HLCLWAL.json` — RIN_DFT는 박과 달리 **가격측 ATTB shape**:
```
PCS_CD=RIN_DFT  ATTB_CD=RIN_SLV  ATTB_NM=은색   (선택 옵션 리스트가 아닌 단일 ATTB echo)
PCS 동반: HOL_DFT(타공), RIN_CUT(링재단), CUT_DFT(재단)
```
- 플랜 §1 표(L-29)가 옳았음 확인: 캘린더 RIN_DFT는 **링색 옵션 색칩 리스트가 부재**, ATTB_CD/ATTB_NM만 echo. 즉 BID_SIL/FOI류(선택 그리드)와 RIN_DFT(가격 ATTB echo)는 **다른 shape** — 어댑터가 둘을 구분 처리해야 함.
- **Wave B 베이스라인:** RIN_DFT는 attb echo(ATTB_CD/ATTB_NM)로, FOI/박은 PCS_DTL 그리드로. L-1 슬롯이 두 shape를 모두 수용하는지 검증 가능.

---

## 2. 반경연동 ATTB (Wave B, L-3b) — 결정적 sourcing 진단

`major_radius_BCSPDFT.json` + `major_attbchip_BCFOXXX.json` 양쪽 ROU_DFT 실측:
```
ROU_DFT 4 엔트리 (양 상품 동일):
  DFXLT 귀돌이좌상 / DFXRT 귀돌이우상 / DFXLB 귀돌이좌하 / DFXRB 귀돌이우하
  DIV_SEQ=0, ATTB 필드 없음, WEB_PCS_DTL_GRP=ROU_DFT_DF
  보유 키: PCS_CD/PCS_DTL_CD/PCS_DTL_NM/WEB_PCS_DTL_GRP/WRK·CUT_WDT/HGH/VIEW_YN/HIDE_YN/ESN_YN/MTRL_CD/DIV_SEQ
```

### 결론: **반경은 product_info에 저장되지 않는다 — 항상 파생(derived)**
- product_info의 ROU_DFT 엔트리는 **귀 위치(4코너)만** 인코딩. **반경값(mm)도 ATTB도 DIV_SEQ≠0도 없음.**
- 반경은 코드맵(red-code-map L-64, mod_07:3300~3331) `roundingConfigMap[pdtCode]`(Vue 번들 상수 `Yr`)에서 옴:
  - `factor==='size'` → 사이즈별 반경(size watch로 `value[DIV_SEQ]` 룩업, cascade)
  - 아니면 → 고정 4mm/6mm RadioGroup
- BCSPDFT/BCFOXXX는 `factor==='size'` 아님(DIV_SEQ=0) → **4/6mm 고정 라디오 + 귀 멀티토글**. factor==='size' 상품은 479 카탈로그 probe 범위(명함/스티커/아크릴키링)에서 **product_info로는 식별 불가**(번들 상수에만 존재).
- **Wave B 재현 베이스라인:** L-3b는 **roundingConfigMap을 Vue 번들(mod_07:3301 `Yr`)에서 이식**해야 하며 product_info 캡처로는 채울 수 없음이 확정. cascade.ts의 size→반경 재계산은 이 이식 상수맵에 의존. 캡처가 준 것은 "ROU_DFT 엔트리 구조(4귀 토글) + 반경 미저장 증명" — slot-only 유지가 정당하며, 반경 실값은 번들 상수 이식이 유일 경로.

---

## 3. 의류 clothes2025 (Wave C) — apparel_info 풀 shape

`major_apparel_CLSTSHS.json` (5.6oz 하이퀄리티 티셔츠) `apparel_info` 6블록 실측:

| 블록 | 내용 | 샘플 |
|------|------|------|
| `print_type` | **3 분기** | `PTP_DTF(DTF 열전사)·PTP_DIR(직접인쇄)·PTP_SLK(날염/실크인쇄)` 각 {COD, COD_NME, USE_YN, order} |
| `print_area` | 6 인쇄영역 | `{COD:CL011, COD_NME:좌측가슴, ORD, KOI_NME:leftchest}` — KOI_NME=에디터 영역키 |
| `apparel_color` | 54 색 | `{COD:26, COD_NME:화이트, HEX:#FFFFFF, DEFAULT:Y, HIDE_YN:N}` |
| `size_info` | 7 사이즈 | `{COD:X, COD_NME:XS, GBN:adult}` (XS~3XL, GBN adult/child) |
| `size_color_info` | **227 조합** | `{COD, COD_NME:S, HEX, GBN:adult, CLR_COD:03, CLR_COD_NME:블랙, HIDE_YN, QUICK_ORD_YN:Y, MTRL_COD:SXSRT103}` — 사이즈×색 매트릭스(재고/퀵오더) |
| `pantone_color` | **1124 팬톤** | `{pantone_name:PANTONE 100 C, rgb_R/G/B, hex_cod}` — PTP_SLK 실크모드 전용 |

위젯 DOM 버튼: `DTF 열전사 / 직접인쇄 / 날염(실크인쇄)` (PRINT_TYPE 라디오), `XS~3XL`(사이즈), `가이드 보기`, `편집하기`.

### 동작 분기(코드맵 deob_07:937 대조)
- `sizeSelectionMode`: PRINT_GBN==='N'→single, **COD==='PTP_SLK'→multi사이즈(ApparelMultiSizeQty)+팬톤(ApparelPrintColor)**, else single.
- 즉 **실크(PTP_SLK) 선택 시에만** 멀티사이즈 카운터 테이블 + 팬톤칩 모달 발현. DTF/DIR은 single 사이즈.
- CLTMSHS(단체티)도 동일 3 PRINT_TYPE, 사이즈 9·색 6 — shape 동형(변종 검증).

### Wave C 재현 베이스라인
- 어댑터 의류 경로(현재 0) 신규 구현의 **완전한 입력 데이터 확보**: print_type 3분기 / print_area(KOI 매핑) / size_color 매트릭스(227, 재고·퀵오더) / 팬톤 1124. 신규 의류 컴포넌트(ApparelPrintType/SizeQty single·multi/PrintColor 팬톤) 구현·검증 가능.
- 단 **후니 day-1 의류 판매 확정 시**에만 진행(플랜 §6 결정점). 데이터 baseline은 이제 완비.

---

## 4. ACC 부자재 (Wave C, L-12) — 부자재 옵션 트리

`major_acc_ACPDSTD.json` (아크릴 등신대) — 부자재는 **SUM_MTR PCS + 위젯 select**:
```
위젯 select 'SUM_MTR/등신대 받침대' (12옵션):
  AB005 원형-S / AB009 원형-M / AB013 원형-L
  AB006 타원형-S / AB010 타원형-M / AB014 타원형-L
  AB007 사각형-S / AB011 사각형-M / AB015 사각형-L
  AB008 육각형-S / AB012 육각형-M / AB016 육각형-L
PCS 동반: LAS_DFT(레이저컷), SUB_MTR(부자재), PRT_WHT(화이트인쇄)
```

### 진단: 단순 SUM_MTR add-on vs accFilterConfigMap CASCADE/MULTI는 **다른 층**
- ACPDSTD는 **단순 SUM_MTR add-on**(모양×크기 1단 select → finish-button 흡수, red-coverage-matrix F5와 일치). product_info에 부자재 옵션이 SUM_MTR/{자재명} select로 직접 옴.
- 플랜이 말한 **accFilterConfigMap[pdtCode] (uiType CASCADE/MULTI, GRP_TYPE MTRL_MULTI_GRP/MTRL_GRP/MTRL_SUB_GRP)** 다단 캐스케이드는 **Vue 번들 상수(deob_07:2027 `K_`)에 등록된 별도 부자재-전용 상품**의 메커니즘 — product_info 페이로드엔 config가 안 나옴(번들 상수). probe 6상품 범위에서 accFilterConfigMap 등록 상품 미발견(`accFilters=false` 전건).
- **Wave C 재현 베이스라인:**
  - **단순 add-on(SUM_MTR/모양)**: ACPDSTD 12옵션으로 즉시 재현 가능 — finish-button + selectedFinishes echo(이미 구조 보유).
  - **다단 CASCADE/MULTI 부자재**: accFilterConfigMap을 번들 상수에서 이식 + 어느 상품이 등록됐는지 식별 필요(L-3b 반경과 동일하게 "번들 상수 의존"). 이건 후니 옵션마스터 수령 후 AccPanel(D4 정당 신규leaf 2번째) 구현 시 처리. 현 캡처는 **단순 add-on 층의 baseline + "다단 config는 번들 의존"임을 확정**.

---

## 5. 캡처 못한 것 / 한계 (은폐 금지)

| 항목 | 상태 | 사유 |
|------|------|------|
| factor==='size' 반경연동 상품 | 미식별 | 반경은 product_info 미저장(번들 `roundingConfigMap`만). probe 범위 명함/스티커는 전부 4/6mm 고정. **번들 상수 이식이 유일 경로**로 확정(캡처로 해소 불가) |
| accFilterConfigMap CASCADE/MULTI 부자재 | 미발현 | 다단 부자재 config는 Vue 번들 상수(`K_`). probe 6상품에 등록상품 없음. 단순 SUM_MTR add-on은 ACPDSTD로 확보 |
| 의류 가격(clothes2025 PRICE) | 미캡처 | 본 배치는 옵션 shape(get_digital_product_info)에 집중. 의류 가격스윕은 Wave C 구현단계 별도(현재 어댑터 의류경로 0이라 우선순위 낮음) |

> **핵심:** L-3b 반경·ACC 다단 캐스케이드는 **product_info 캡처로 해소되지 않고 Vue 번들 상수 이식이 본질**임을 캡처로 결정적으로 확인. L-1 속성칩(FOI/박)·의류·ACC 단순 add-on은 실데이터 baseline 확보 완료.

---

## 6. 캡처 산출물 (전체 redact, JWT 누출 0건 검증)

| 파일 | 핵심 데이터 |
|------|------------|
| `05_qa/captures/major_attbchip_BCFOXXX.json` | FOI 박 속성칩 57 detail + ROU_DFT 4귀(반경 미저장) |
| `05_qa/captures/major_attbchip_HLCLWAL.json` | RIN_DFT 가격측 ATTB_CD/ATTB_NM shape |
| `05_qa/captures/major_radius_BCSPDFT.json` | ROU_DFT 4귀 DIV_SEQ=0 (반경 derived 증명) |
| `05_qa/captures/major_apparel_CLSTSHS.json` | apparel_info 6블록(PRINT_TYPE 3·사이즈 7·색 54·size_color 227·팬톤 1124) |
| `05_qa/captures/major_apparel_CLTMSHS.json` | 의류 변종(동일 3 PRINT_TYPE, shape 동형 검증) |
| `05_qa/captures/major_acc_ACPDSTD.json` | SUM_MTR 부자재 12옵션(모양×크기) |
