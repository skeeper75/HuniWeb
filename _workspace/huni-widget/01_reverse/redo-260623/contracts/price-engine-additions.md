# 가격 엔진 신규 필드 (갱신본 260623)

> R2 산출. 기존 `01_reverse/price-engine-reversed.md`(4월·기본 ORD_INFO/PCS_INFO)에 병합할 6월 신규분.
> 가격 권위 = 서버 `get_ajax_price_vTmpl`. PRICE≠0 = 정상(0=결함). result_sum.PRICE = 단일 권위.

## 1. ORD_INFO 신규 필드 [라이브 검증 + 정적]
빌더 deob L13955–13999. 라이브 엔진 수용 확인(retCode 200).
| 필드 | 출처(deob) | 의미 | 가격영향(라이브) |
|------|-----------|------|------------------|
| ADD_CLR_YN | dosuInfo.ADD_CLR_YN (L13982) | 추가색상 Y/N | 자재/도수 조건부(NCCDDFT RXSNO250선 무변화) |
| PACK_PRN_CNT | addOptionInfo.PACK_PRN_CNT (L13984, 조건부) | 개별포장 수량 | 미full검증 |
| REAM_CNT | pdt_prn_cnt_info 행 (L22611 REAM_CNT/PRN_CNT) | 연(ream) 수 | 수량모델 B |
| MAX_PRN_CNT | pdt_base_info[0] (L19733) | 수량 상한 | 검증경계 |
| PDT_SIZE_INFO | size_info (L16212) | BT*/GSSTPRT 사이즈정보 | - |
| PRINT_TYPE | clothes2025_item (L13987) | 의류 인쇄타입 | 의류 전용 |
| TMPL_IDX | GSTRTAG (L13990) | 템플릿 인덱스(large14/small11) | 트래블택 전용 |

특수: GSELGLV PRN_CNT×10 (L13978).

## 2. 수량 모델 2종 [라이브 검증]
- 모델 A (래더): PRN_CNT = MIN_ORD_PRN_CNT + ADD_ORD_PRN_CNT × h (h=0..9), INC_CNT=ADD, UNIT_PRN_CNT, DFT_YN=첫행Y. deob L15432–15445. (PDT_VER_SIZE형 굿즈)
- 모델 B (행): 서버 pdt_prn_cnt_info 행 + base FIR_CNT/INC/INC_STEP/REAM_YN. (offset2023_item 명함/카드/책자)

## 3. 메타모픽 검증 (NCCDDFT 라이브) [라이브 검증]
| 변형 | PRICE | 관계 |
|------|-------|------|
| baseline PRN500 | 6,350,000 | ≠0 ✓ |
| PRN1000 | 23,900,000 | qty↑⇒price↑ ✓ |
| +FLD_DFT(2단접지) | 14,850,000 | +후가공⇒price↑ ✓ (접지 실가격) |
| ADD_CLR_YN=Y | 6,350,000 | 무변화(자재조건부) |

## 4. PCS_INFO 신규 후가공
+20 postPcs(FLD_DFT/HOL_DFT/ROU_DFT/NUM_DFT/PRT_MAG…). PCS_INFO 항목 `{PCS_COD, PCS_DTL_COD}`. FLD_DFT는 가격 기여 확인.

## 5. 미확정
- ADD_CLR_YN/PACK_PRN_CNT 정확 가격함수(full sweep 미수행).
- 회원등급 PRICE_MALL 워터폴(기본등급 캡처만).
