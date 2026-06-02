# S5-M1 라이브 검증 — RedPrinting 수량구간 할인(TieredDiscount) 곡선 실증

검증일: 2026-06-03 / 세션: token 60분, customerCode 22025916, isClient:true
방법: `POST /rp-api/ko/product_price/get_ajax_price_vTmpl` (server.js가 쿠키+red-editor-token 주입).
각 SKU의 위젯 실제 reqBody를 캡처(`s3-realprice-capture.cjs`) → `ORD_CNT`를 1/2/5/10/30/50/100/300/1000으로
스윕(`s5-tiered-sweep.cjs`)하여 `result_sum.PRICE` / `ORG_PRICE` / 개당단가 / 할인율(=1−PRICE/ORG) 추이 기록.
**할인 판정 기준: ORG_PRICE(정가)와 PRICE(실가)가 갈리면 할인 적용.**

---

## ① SKU별 수량 스윕 표 (7 SKU, 3 price_gbn)

### GSPDLNG 장패드 — price_gbn=`vTmpl_price`
| ORD_CNT | PRICE | ORG_PRICE | 개당단가 | 할인% |
|--:|--:|--:|--:|--:|
| 1 | 16,000 | 16,000 | 16,000 | 0 |
| 2 | 22,000 | 22,000 | 11,000 | 0 |
| 5 | 40,000 | 40,000 | 8,000 | 0 |
| 10 | 70,000 | 70,000 | 7,000 | 0 |
| 30 | 190,000 | 190,000 | 6,333 | 0 |
| 50 | 310,000 | 310,000 | 6,200 | 0 |
| 100 | 610,000 | 610,000 | 6,100 | 0 |
| 300 | 1,810,000 | 1,810,000 | 6,033 | 0 |
| 1000 | 6,010,000 | 6,010,000 | 6,010 | 0 |

개당단가가 16,000→6,010으로 하락(고정비 1회 + 변동비 6,000/개 형태의 base-price 공식). **그러나 ORG_PRICE가 PRICE와 항상 동일 → 할인 0%.** 이건 정가 공식 내부의 비용 체감이지 t_dsc류 할인이 아님.

### GSMLSLC 마스크 스트랩 실리콘 — `tmpl_price`
| ORD_CNT | PRICE | ORG_PRICE | 개당단가 | 할인% |
|--:|--:|--:|--:|--:|
| 1 | 3,900 | 3,900 | 3,900 | 0 |
| 2 | 5,000 | 5,000 | 2,500 | 0 |
| 5 | 8,300 | 8,300 | 1,660 | 0 |
| 10 | 13,800 | 13,800 | 1,380 | 0 |
| 30 | 35,800 | 35,800 | 1,193 | 0 |
| 50 | 57,800 | 57,800 | 1,156 | 0 |
| 100 | 112,800 | 112,800 | 1,128 | 0 |
| 300 | 332,800 | 332,800 | 1,109 | 0 |
| 1000 | 1,102,800 | 1,102,800 | 1,103 | 0 |

GSPDLNG과 동형(고정비 약 2,800 + 변동비 약 1,100/개). 개당단가 체감 있으나 ORG==PRICE → 할인 0%.

### GSTGMIC 네임택 — `tiered_price`
| ORD_CNT | PRICE | ORG_PRICE | 개당단가 | 할인% |
|--:|--:|--:|--:|--:|
| 1 | 6,000 | 6,000 | 6,000 | 0 |
| 10 | 60,000 | 60,000 | 6,000 | 0 |
| 100 | 600,000 | 600,000 | 6,000 | 0 |
| 1000 | 6,000,000 | 6,000,000 | 6,000 | 0 |

완전 선형(개당 6,000 고정). `tiered_price` 이름에도 불구 수량할인·체감 모두 없음.

### GSTBMWM 텀블러 — `tmpl_price`
| ORD_CNT | PRICE | ORG_PRICE | 개당단가 | 할인% |
|--:|--:|--:|--:|--:|
| 1 | 45,000 | 45,000 | 45,000 | 0 |
| 10 | 45,000 | 45,000 | 4,500 | 0 |
| 100 | 45,000 | 45,000 | 450 | 0 |
| 1000 | 45,000 | 45,000 | 45 | 0 |

PRICE가 ORD_CNT 무관 45,000 고정(디자인 1건 템플릿 단가형). 수량 곱셈조차 없음.

### GSNTSTA 중철노트 / GSDRSKS 스케치북 / GSNTSPR 스프링노트 — 모두 `tmpl_price`, 완전 선형
| SKU | 개당단가(고정) | 할인% (전 구간) |
|--|--:|--:|
| GSNTSTA | 3,000 | 0 |
| GSDRSKS | 4,200 | 0 |
| GSNTSPR | 6,300 | 0 |

세 SKU 모두 PRICE = 개당단가 × ORD_CNT 정확히 선형, ORG==PRICE.

---

## ② 할인곡선 실재 여부 — 결론

| SKU | price_gbn | 수량할인 곡선? | 비고 |
|--|--|:--:|--|
| GSPDLNG 장패드 | vTmpl_price | **NO** | base-price 비용체감(고정비+변동비), 할인 아님 |
| GSMLSLC 실리콘스트랩 | tmpl_price | **NO** | 동상(고정비+변동비) |
| GSTGMIC 네임택 | tiered_price | **NO** | 완전 선형 |
| GSTBMWM 텀블러 | tmpl_price | **NO** | 수량무관 고정가 |
| GSNTSTA 중철노트 | tmpl_price | **NO** | 완전 선형 |
| GSDRSKS 스케치북 | tmpl_price | **NO** | 완전 선형 |
| GSNTSPR 스프링노트 | tmpl_price | **NO** | 완전 선형 |

**결론: Red 자동견적 위젯 가격 API에는 (적어도 굿즈·문구 카테고리 7 SKU·3 price_gbn 전체에서) 수량구간 할인이 부재.**
- 7개 SKU 전 수량 구간에서 `ORG_PRICE === PRICE`, 즉 할인율 일률 0%.
- 핸드오프 가정 "말랑 2개부터 즉시할인·최대 50%"는 **본 카테고리 SKU에서 재현되지 않음.** (검증한 어떤 SKU에서도 ORG/PRICE 괴리 미발생.)
- 단가 체감이 보이는 SKU(GSPDLNG·GSMLSLC)는 *정가 공식 자체*가 `고정비 + 변동비×수량` 구조라 개당단가가 떨어지는 것이며, 이는 별도 할인 레이어(`t_dsc_*`)가 아니라 base price 산식에 내재. 위젯·어댑터 관점에서 서버가 반환한 PRICE를 그대로 신뢰하면 되고, 클라이언트가 할인을 재계산할 근거(ORG≠PRICE)는 관측되지 않음.
- `price_gbn` 명칭("tiered_price")은 **수량 tier가 아니라 규격/자재 매트릭스 룩업 방식**을 가리키는 것으로 해석됨(GSTGMIC tiered_price가 완전 선형인 점이 근거).

검증 한계: 굿즈/문구 위주 7 SKU. 명함·스티커·현수막 등 타 카테고리, 또는 회원등급/프로모션 쿠폰 경로는 미검증(본 세션 isClient 단일 등급). 즉 "Red 전체에 할인 없음"이 아니라 "이 카테고리·이 등급의 자동견적 경로엔 수량구간 할인 없음".

---

## ③ 후니 t_dsc_* 매핑 시사점

- 후니 DB는 `t_dsc_*`(할인) 테이블을 보유하나, **Red 자동견적 경로에서 대응하는 할인곡선을 못 찾았으므로 Red 구조에서 이식할 소스가 없음.**
- 따라서 후니 TieredDiscount는 **Red와 무관하게 후니 어댑터 + fixture로 독립 정의**해야 함(코어 불변 원칙·Red 정합 금지 원칙 준수).
- 위젯 코어 가격엔진은 "서버 권위 PRICE를 표시"하는 현 설계 그대로 유지. 할인은 어댑터 단에서 후니 `t_dsc_*`를 해석해 (a) 서버가 ORG/PRICE 분리값을 주면 그대로 노출, (b) 클라 표기용 정가/할인가 2값 계약을 어댑터가 채우는 방식 중 후니 백엔드 응답 형태에 맞춰 결정. 현재 Red 응답은 (b)를 강제하지 않음(ORG==PRICE 단일값).
- 데이터 계약 측면: `result_sum.ORG_PRICE` ↔ `result_sum.PRICE` 2필드 구조는 **할인 표현 슬롯이 스키마에 이미 존재**하나 굿즈/문구 SKU에선 미사용(동일값). 후니 어댑터는 이 2필드 계약을 그대로 채택하되 실제 할인값은 후니 `t_dsc_*` 룩업으로 채우면 됨 → 위젯 코어 변경 0.

---

## ④ fixture 보강 권고 (코어 불변 전제)

- **S5에 Red 기반 할인곡선 fixture 추가 금지/불필요**: 관측된 할인곡선이 없으므로 Red 캡처로 만들 수 있는 할인 fixture가 존재하지 않음. 평탄/선형·비용체감 fixture는 이미 S5에서 검증됨(GSTGMIC·GSPUFBC). 추가 평탄 SKU fixture는 한계효용 낮음.
- **TieredDiscount fixture는 후니 단계로 미룸**: 후니 `t_dsc_*` 실데이터(구간 경계·할인율)가 확정되면 그때 후니 어댑터 fixture로 정의. 가짜 할인곡선(예: "2개부터 50%")을 임의로 S5 fixture에 박지 말 것 — 근거 없는 곡선이 회귀 baseline을 오염시킴.
- **권고 fixture 1종(선택)**: base-price 비용체감형(GSPDLNG: 고정비+변동비×수량) 1개를 "할인 아님·체감형" 회귀 케이스로 추가하면, 후니 어댑터가 할인(ORG≠PRICE)과 체감(ORG==PRICE 단가하락)을 혼동하지 않도록 가드레일이 됨. 코어 변경 없이 fixture+어셔션만 추가.

---

## 산출물
- 캡처/스윕 JSON: `_workspace/huni-widget/05_qa/captures/`
  - reqBody 캡처: `s3_rp_{GSPDLNG,GSMLSLC,GSTGMIC,GSTBMWM,GSNTSTA,GSDRSKS,GSNTSPR}.json`
  - 수량 스윕: `sweep_{동일 7코드}.json` (자격증명·JWT 미포함; 가격 수치만)
- 스윕 스크립트: `raw/widget_monitor/local/s5-tiered-sweep.cjs` (분석 도구, 위젯 코어/어댑터/server.js 무수정)
