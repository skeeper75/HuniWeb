# R1 — 런타임 추출 (widget_monitor testbed) 산출

> 재역공학 강화 2단계 R1. testbed(:3001) 프레시 구동 라이브 추출. 읽기전용(주문/폼submit/에디터저장 0).
> 세션 신선도: cookies.json 14개(당일 00:26) + /refresh-token 갱신. PRICE≠0 sanity 통과.
> 캡처: `redo-260623/captures/`.

---

## 0. 세션·서버 [라이브 검증]
- 서버: `node server.js` :3001, 쿠키 14개 로드, /refresh-token OK(exp 갱신).
- 프록시 경로 실측: `/rp-api → www.redprinting.co.kr` (가격/상품정보 권위), widget-api, makers-api.
- **PRICE≠0 sanity 통과**: NCCDDFT 라이브 가격 6,350,000 (§4).

## 1. API base + 엔드포인트 런타임 확정 [라이브 검증]
R0의 `jn/is` 변수 실값 + 실제 호출 경로(deob L12292–12324):
| 변수 | 실값 |
|------|------|
| `jn` | `https://www.redprinting.co.kr` |
| `is` | `https://widget-api.redprinting.co.kr` |
- product_info: `GET {jn}/{locale}/product/get_digital_product_info?pdt_cod=X` (param=`pdt_cod`, locale=`ko`). 라이브 200 확인.
- price: `POST {jn}/{locale}/product_price/get_ajax_price_vTmpl` (body `{dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}`). 라이브 200.
- Garage presigned: `POST {is}/api/garage/presigned-url` (R2서 라이브).

## 2. 신규 상품군(item_gbn) 라이브 실측 [라이브 검증]
R0 추정(acrylic2025/clothes2025/offset2023 등)을 라이브 product_info로 확정. **R0보다 종류 더 많음**:
| pdt_cod | item_gbn | 상품명 | 비고 |
|---------|----------|--------|------|
| NCCDDFT | **offset2023_item** | [옵셋] 일반 카드 | 신규 |
| NCDFDFT | offset2023_item | [옵셋] 일반 명함 | 신규 |
| NCDFFLD | offset2023_item | [옵셋] 2단/3단 명함 | 신규 |
| PRBKYPR | book2025_item | 무선 책자 | 기존 |
| GSTRTAG | **edicus_item** | 트래블택 | R0 미식별 신규 |
| GSELGLV | **digital_item** | 홍보/응원 장갑 | R0 미식별 신규 |
| GSTGMIC | vDigital_item | 마이크 네임택 | 기존 |
| STPADPN | vDigital_item | 떡메모지 | 기존 |
→ 라이브 item_gbn = offset2023_item, book2025_item, edicus_item, digital_item, vDigital_item (+ R0 코드근거 acrylic2025_item, clothes2025_item). **R0 정정**: edicus_item/digital_item은 R0 grep에서 누락됐던 값(라이브가 권위).

## 3. Garage 활성 플래그 라이브 확정 [라이브 검증]
- 라이브 product_option.option 키 = **`isUseGarage`** (R0서 widget이 쓰는 `useGarage`는 이 값의 파생).
- NCCDDFT: `isUseGarage: "Y"`, `usePDF: "Y"`, useKoiEditor/useRPEditor: "N".
- 프로브 8상품 전부 `isUseGarage`/garage 흔적 존재 → **Garage는 전 상품 활성**(S3는 폴백).

## 4. 신규 후가공 옵션 스키마 라이브 [라이브 검증] — NCCDDFT
product_data 구조(라이브): `pdt_base_info, pdt_mtrl_info, pdt_size_info, pdt_dosu_info, pdt_prn_cnt_info, pdt_exp_prn_cnt_info, pdt_pcs_info, pdt_add_pcs_info, pdt_disable_pcs_info, pdt_add_info`.

### 4.1 후가공(pdt_pcs_info) PCS_COD 라이브
`CUT_DFT, COT_DFT, FLD_DFT, HOL_DFT, MIS_DFT, OSI_DFT, ROU_DFT` — R0의 신규 postPcs(FLD_DFT 접지·HOL_DFT 타공·ROU_DFT 귀돌이)가 실제 노출됨.

### 4.2 FLD_DFT(접지) 상세 라이브
- 예: `{PCS_CD:"FLD_DFT", PCS_GRP_NM:"접지", PCS_DTL_CD:"FO006", PCS_DTL_NM:"2단접지", WEB_PCS_DTL_GRP:"FLD_DFT_FO", VIEW_YN:"Y", ESN_YN:"N", QTY_INPUT_YN:"N", NOTICE:["3단/대문/반대문 접지 시 접지 가이드 다운로드…"]}`.
- NOTICE가 `get_fld_download`(R0 L12466) 접지 가이드 다운로드와 연동.

### 4.3 캐스케이드(material→pcs disable) 라이브 — R0 패턴 확정
- `pdt_disable_pcs_info` 25건. 예: `{MTRL_CD:"RXSNO300", PCS_CD:"FLD_DFT", PCS_DTL_CD:"FO001~FO004", NOTE:"자재별 불가능 공정 추가공정"}`.
- = 자재 선택 시 특정 후가공 detail 비활성(R0 L14424 캐스케이드 + L17378 사이즈<40 HOL_DFT 강제N과 정합).

## 5. 가격 신규필드 라이브 검증 + 메타모픽 [라이브 검증]
NCCDDFT 라이브 price 호출(baseline ORD_INFO: PDT_CD=NCCDDFT, MTRL_CD=RXSNO250, CUT 148×100, PRN_CNT=500, DOSU=SID_S, PRN_CLR_CNT=4, ADD_CLR_YN=N, REAM_CNT=0):
| 변형 | PRICE | 메타모픽 판정 |
|------|-------|--------------|
| baseline (PRN 500) | 6,350,000 | PRICE≠0 ✓ |
| PRN 1000 (qty↑) | 23,900,000 | **qty↑⇒price↑ ✓** |
| ADD_CLR_YN=Y | 6,350,000 | 이 자재/도수선 무영향(자재조건부) |
| +FLD_DFT FO006(2단접지) | 14,850,000 | **+후가공⇒price↑ ✓** (접지=실가격 +8.5M) |
- **신규 가격필드(REAM_CNT/ADD_CLR_YN) 라이브 엔진이 수용**(retCode 200). FLD_DFT 접지는 가격 기여 실측.
- 정정: `MIN_ORD_PRN_CNT/ADD_ORD_PRN_CNT`(R0 L15432 수량래더)는 PDT_VER_SIZE 기반 상품(예 굿즈)용. offset2023_item은 `pdt_prn_cnt_info`(DFT_PRN_CNT/REAM_CNT/UNIT_PRN_CNT 행) + base `FIR_CNT/INC/INC_STEP/REAM_YN` 사용 — 상품군별 수량모델 2종 존재.

## 6. Pinia 스토어 라이브 추출 — 부분(미확정) [정직 표기]
- testbed `getStoreSnapshot()`(index.html)로 시도. **Shadow DOM 신규 라벨(자석·걸이) 렌더 확인**(위젯 마운트·신규 옵션 렌더 입증).
- 그러나 Pinia state value 추출은 null 반환(헤드리스서 Vue app 인스턴스 비도달 — closed shadow 또는 마운트 타이밍). → **스토어 ID/state 라이브 덤프 미확정**.
- 대체 근거: product_info 라이브 = 스토어 product_data 원천(스토어는 이를 적재). 4월 스토어 5개 구조(config/product/order/exterior/acc-order)는 기존 gaps-resolved 확정분 유지. 신규 store 추가 여부는 미확정(R0 deob L18233 GarageUploader는 컴포넌트, 별도 store 아님).

## 7. RedEditorSDK sizing.type 런타임 — 미확정 [정직 표기]
- widget.deob.js에 `sizing`/`documentSizeInfo` 미참조(R0 §6) → widget 경로로는 트리거 불가.
- 에디터 iframe 실구동(createProject) 미수행(읽기전용·에디터 저장 금지 범위) → sizing.type 런타임 관측 미확정. SDK 정적 diff(1단계)로만 확정.

## 8. R1 캡처 산출물(감사 추적)
`redo-260623/captures/`:
- `new-feature-products-probe.json` — 13상품 신규기능 프로브(item_gbn·newPcs·플래그)
- `product_{NCCDDFT,NCDFDFT,PRBKYPR}.json` — 전체 product_info 라이브 200
- `price-metamorphic-NCCDDFT.json` — 가격 메타모픽 4변형
- `store-snapshot-NCCDDFT.json` — Shadow DOM 라벨(부분)

## 9. R1 미확정(R2/잔여)
- Garage presigned 실응답 + PUT 헤더 (R2).
- Pinia store state 라이브 덤프 (헤드리스 한계 — 비헤드리스/CDP 필요).
- 신규 옵션군 전수(글꼴 NUM_DFT·걸이 RIN_DFT·아크릴/의류 상품) — 대표 offset/book 커버, 나머지 코드근거.
- sizing.type 런타임.
