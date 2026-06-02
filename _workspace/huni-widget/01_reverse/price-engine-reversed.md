# 가격 엔진 역공학 (측정 기반)

> 파이프라인 ① hw-reverse-engineer 산출물. 라이브 테스트베드(`localhost:3001` → `redprinting.co.kr` 프록시)에서 실제 가격 API를 호출하여 옵션 조합별 응답을 수집·역산.
> 캡처 raw: `01_reverse/captures/price_*.json`, 요약: `captures/price_matrix_summary.json`
> 근거 표기: `[라이브 검증]` 실응답 / `[정적 분석]` deob 소스 / `[추정]` 미검증 가설

---

## 1. 가격 API 계약 [라이브 검증]

**엔드포인트**: `POST /ko/product_price/get_ajax_price_vTmpl`
**인증**: 세션 쿠키만 (Authorization 헤더 없음). 평문 JSON.
**소스**: `deob_05_app_api.js:1129 fetchPriceCalculation()` — body는 `{ dataJson: payload.body }` 로 한 번 감싼다.

### 요청 페이로드 (책자 PRBKYPR, 라이브로 200 확인된 최소 구조)

```json
{ "dataJson": {
  "ORD_INFO": [{
    "PDT_CD": "PRBKYPR",
    "CUT_WDT": 210, "CUT_HGH": 297,     // 재단 사이즈 mm (제품 size_info의 CUT_*)
    "WRK_WDT": 220, "WRK_HGH": 307,     // 작업 사이즈 mm (도련 포함, WRK_*)
    "PRN_CNT": 30,                       // 주문 수량(권)
    "PAGE_CNT": 10,                      // 내지 페이지 수
    "CVR_CLR_CNT": 4,                    // 표지 인쇄 색상수 (4=컬러, 1=단색)
    "INN_CLR_CNT": 4,                    // 내지 인쇄 색상수
    "CVR_MTRL_CD": "RXART300",           // 표지 자재 (mtrl_info의 MTRL_CD)
    "INN_MTRL_CD": "RXYWM080"            // 내지 자재 (inner_pdt_mtrl_info의 MTRL_CD)
  }],
  "PCS_INFO": [
    {"PCS_COD": "CUT_DFT", "PCS_DTL_COD": "DFXXX"},     // 재단(기본)
    {"PCS_COD": "COT_DFT", "PCS_DTL_COD": "TCMAS"},     // 코팅(무광단면)
    {"PCS_COD": "BIND_DIRECTION", "PCS_DTL_COD": "BPLFT"} // 제본방향(좌철)
  ],
  "price_gbn": "book2025_price",         // 가격체계 키 (product_option.option.price_gbn)
  "mb_cust_cod": "10000000"              // 고객등급 코드 (member_info 기반, 기본 10000000)
}}
```

> 주의: 부자재/굿즈(GSTGMIC)·아크릴(ACNTHAP)은 `inner_*`·PAGE_CNT 없는 단순 구조.
>
> **price_gbn = 상품군별 가격체계 키 [라이브 검증]**:
> | 상품 | price_gbn | item_gbn | 체계 |
> |------|-----------|----------|------|
> | PRBKYPR(책자) | `book2025_price` | book2025_item | 표지+내지 분리, 페이지×수량 |
> | GSTGMIC(굿즈) | `tiered_price` | vDigital_item | 수량 구간 단가(tiered) |
> | ACNTHAP(아크릴) | `vTmpl_price` | vDigital_item | 템플릿(vTmpl) 기반 |
>
> 가격 API는 동일 엔드포인트지만 `price_gbn`으로 서버측 가격 룰 엔진을 분기. 후니도 상품군별 가격체계 키로 룰 분기 설계.

### 응답 (공정별 분해 + 합계 + 단가 로그) [라이브 검증]

```jsonc
{
  "retCode": 200, "msg": "",
  "result": [   // 공정(PCS)별 가격 분해
    {"PCS_CD":"COT_DFT","PRICE":11600,"PRICE_VAT":1160,"PRICE_MALL":11600,"ORG_PRICE":11600, ...},
    {"PCS_CD":"CUT_DFT","PRICE":0, ...},
    {"PCS_CD":"PRT_DFT","PCS_DTL_CD":"DFXXS","PRICE":44400, ...}   // 인쇄(표지+내지)
  ],
  "result_sum": {
    "PRICE":56000, "PRICE_VAT":5600,         // 할인 적용가 + 부가세
    "PRICE_MALL":56000, "PRICE_MALL_VAT":5600,// 몰(추가할인)가
    "ORG_PRICE":56000, "ORG_PRICE_VAT":5600,  // 정가
    "PCS_ETC_PRICE":11600,  // 코팅 등 부가공정 합
    "PCS_PRI_PRICE":44400   // 인쇄(표지+내지) 합
  },
  "result_log": { "list": [
    [ /* [0] 공정별 단가명세(PRICE_LOG 한글) */ ],
    [ {"PDT_WGT":"2.1","BOX_CNT":1,"DLVR_AMT":3500} ],  // [1] 배송 무게/박스/배송비
    [ {"A_DIV_NM":"210X297","F_CVR_MTRL_AMT":"103.00","G_CVR_PRINT_AMT":"819.00",
       "K_INN_MTRL_AMT":"100.00","L_INN_PRINT_AMT":"210.00","N_COT_AMT":"320.00","O_ETC_AMT":"1552.00"} ], // [2] 단가 A~O
    [ {"CVR_PRINT_AMT":819,"CVR_MTRL_AMT":103,"INN_PRINT_AMT":210,"INN_MTRL_AMT":100,
       "BIND_AMT":0,"COT_AMT":320,"SCO_AMT":0,"HAP_AMT":0,"CVR_ADD_AMT":0} ]  // [3] 단가 머신리더블
  ]},
  "seneca_info": {"seneca":"1.26","max_seneca":0,"order_able_yn":null,"seneca_show":"N"},
  "book_info": {"PDT_WGT":"2.1","BOX_CNT":1,"DLVR_AMT":3500}
}
```

소스 `deob_06_app_widget_sdk.js:1273-1284`: 최종 결제금액 산정 = 3단 워터폴
```
PRICE_MALL ≠ PRICE  → 몰가 사용:  PRICE_MALL + PRICE_MALL_VAT
ORG_PRICE ≠ PRICE   → 할인가 사용: PRICE + PRICE_VAT
그 외               → 정가 사용:  ORG_PRICE + ORG_PRICE_VAT
```
[정적 분석] 확정. (현재 라이브 응답은 세 값이 동일 = 비회원/기본등급이므로 할인 미적용)

---

## 2. 측정된 가격 규칙 (옵션 조합 매트릭스) [라이브 검증]

8개 조합 라이브 캡처. PRBKYPR, 표지 RXART300, 내지 RXYWM080, 코팅 TCMAS 고정.

| 조합 | 수량 PRN | 페이지 | 표지色 | 내지色 | PRICE | 인쇄 PCS_PRI | 부가 PCS_ETC |
|------|---------|--------|--------|--------|-------|-------------|-------------|
| q30_p10 | 30 | 10 | 4 | 4 | 56,000 | 44,400 | 11,600 |
| q60_p10 | 60 | 10 | 4 | 4 | 93,100 | 74,100 | 19,000 |
| q120_p10 | 120 | 10 | 4 | 4 | 173,900 | 141,000 | 32,900 |
| q300_p10 | 300 | 10 | 4 | 4 | 420,900 | 343,500 | 77,400 |
| q30_p20 | 30 | 20 | 4 | 4 | 67,200 | 55,600 | 11,600 |
| q30_p40 | 30 | 40 | 4 | 4 | 89,500 | 77,900 | 11,600 |
| q30_p10_i1 | 30 | 10 | 4 | 1 | 52,400 | 40,800 | 11,600 |
| q30_p10_c1 | 30 | 10 | 1 | 4 | 43,900 | 32,300 | 11,600 |

### 역산 규칙 A — 수량 볼륨 디스카운트 [라이브 검증]

평균 단가(PRICE/PRN)가 수량 증가에 따라 체감:
| 수량 | PRICE/PRN | 인쇄 PRI/PRN | 부가 ETC/PRN |
|------|-----------|-------------|-------------|
| 30 | 1,866.7 | 1,480.0 | 386.7 |
| 60 | 1,551.7 | 1,235.0 | 316.7 |
| 120 | 1,449.2 | 1,175.0 | 274.2 |
| 300 | 1,403.0 | 1,145.0 | 258.0 |

- **단순 선형 비례 아님** — 수량 구간별 단가 테이블(서버측 가격 마스터)이 적용된다. 한계단가(증분 dPRICE/dQ)가 1,237→1,347→1,372 으로 변동.
- 후니 시사점: 가격엔진은 `(수량구간 → 단가)` 룩업 테이블 + 보간 방식. 클라이언트는 계산하지 않고 **전적으로 서버 API에 의존**(위젯은 표시만).

### 역산 규칙 B — 페이지 수 선형 가산 [라이브 검증]

수량 30 고정, 페이지만 변화 → 인쇄(PRI)만 증가, 부가(ETC 코팅)는 불변(11,600):
| 페이지 | 인쇄 PRI | Δ인쇄/Δpage |
|--------|---------|-------------|
| 10 | 44,400 | - |
| 20 | 55,600 | +1,120/page |
| 40 | 77,900 | +1,115/page |

- 페이지당 약 **1,115~1,120원** 가산(수량 30 기준 = 페이지당 ~37원/권). 거의 완전 선형.
- 코팅(ETC)은 페이지 무관(표지에만 적용) — 확인.

### 역산 규칙 C — 인쇄 색상수 영향 [라이브 검증]

수량30·페이지10 기준:
- 내지 4색→1색 (`INN_CLR_CNT` 4→1): 인쇄 -3,600원 (44,400→40,800)
- 표지 4색→1색 (`CVR_CLR_CNT` 4→1): 인쇄 -12,100원 (44,400→32,300)

- 표지 색상 영향이 내지보다 큼(표지 단가 922/면 vs 내지 310/면·페이지). 색상수는 인쇄 단가 마스터의 분기 키.

### 단가 분해 (result_log[3]) [라이브 검증]

q30_p10 머신리더블 단가 블록(원/단위):
```
CVR_MTRL_AMT=103  CVR_PRINT_AMT=819   (표지 자재/인쇄 단가)
INN_MTRL_AMT=100  INN_PRINT_AMT=210   (내지 자재/인쇄 단가)
COT_AMT=320  BIND_AMT=0  SCO_AMT(스코딕스)=0  HAP_AMT(합지)=0  CVR_ADD_AMT=0
```
> 이 단가들은 **수량·구간 적용 후 정규화 표시값**으로, PRICE/PRN 와 단순 곱이 일치하지 않는다(예: 순진한 (자재+인쇄)×수량 계산은 130,260 ≫ 실제 56,000). 즉 서버가 수량구간 단가 마스터로 산정하며, result_log[3]는 **명세 표시용**이지 클라이언트 재계산용이 아님. [라이브 검증으로 반증 — 클라이언트 재계산 금지 근거]

---

## 3. 후니 가격엔진 시사점

1. **서버 권위 모델**: 위젯은 가격을 절대 계산하지 않는다. 옵션 변경 → 디바운스 → API 호출 → result_sum 표시. 후니도 동일 계약(`ORD_INFO`+`PCS_INFO` → result_sum) 유지 + 어댑터로 후니 DB 매핑.
2. **공정별 분해 표시**(result[]·result_log)는 후니 차별점으로 가져갈 수 있음(가격 투명성).
3. **3단 가격 워터폴**(정가/할인가/몰가) + 부가세 별산 + 배송비(book_info.DLVR_AMT) 합산은 후니 결제 금액 산정 계약의 기준.
4. 가격 룰 자체(수량구간 단가 테이블)는 RedPrinting 서버 내부 — 역산 불가·불필요. 후니는 후니 가격 마스터를 동일 계약 형태로 노출하면 됨.

## 4. 잔존 미검증

- 회원 등급별 할인(PRICE_MALL ≠ PRICE) 실데이터 — 현재 캡처는 기본등급이라 세 값 동일. [미검증]
- 굿즈/아크릴 가격 페이로드의 정확한 ORD_INFO 필드(PAGE_CNT 없음, option_info 매핑) — 책자만 라이브 검증. [미검증: 비책자]
- 스코딕스(SCO)·합지(HAP)·박/형압 등 고급 후가공의 가격 기여 — 0원 케이스만 캡처. [미검증]
