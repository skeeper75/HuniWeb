# BLOCKED 위험 요소 전수 발굴 + 해소 (2026-06-29)

> 사용자 directive: "이전사이트(huniprinting.com)에서 상품마스터·인쇄상품가격표의 BLOCKED 될 수 있는
> 모든 요소를 파악해서 애매모호한 부분을 모두 정리하고 다음 단계로 진입."
> 자 = `blocked-risk-registry.csv`(146건·결정론 스캔 `blocked_scan.py`). 라이브/가격표 대조로 해소.

## 0. 결론 — "BLOCKED로 멈출 일 거의 없음"
146건 ★/별도설정 셀의 **대부분은 단가 미상이 아니라 "제약 스펙"(값이 셀에 이미 있음)**이고,
실제 단가는 **가격표(260527)·라이브 DB에 이미 존재**한다. 진짜 미적재는 좁고, score_batch CALC가
상품 단위로 자동 적발한다(예: 투명엽서 PET 용지비). → **파이프라인 재중단 리스크 해소.**

## 1. 카테고리별 해소 (146건 → 7카테고리)

| 카테고리 | 셀/상품 | 애매 정체 | 해소 | 잔여 |
|---|---|---|---|---|
| **FREEFORM_PAPER** | 24/20 | 별도설정 종이(자유선택) | 🟢 단가=COMP_PAPER 절가(56행 적재)·손님 종이 택1 | per-product 미적재만 score_batch CALC가 적발 |
| **FOIL_SIZE** | 22/9 | ★박/형압 크기 | 🟢 단가=가격표 후가공_박(소형 크기×수량·대형 면적격자·백업 동판)·라이브 COMP_*_FOIL 적재. ★크기=제약(셀에 min/max 값) | ⚠️박 prc_typ .01/.02 혼재=band-total 점검(별도 finding) |
| **ADDON_CONSTRAINT** | 23/12 | ★추가상품(봉투류) | 🟢 단가=가격표 봉투제작[9] L2·COMP_ENV_MAKING 적재. ★사이즈선택=제약(셀에 값) | addon 템플릿 mint·constraint 파싱(OC) |
| **PROCESS_OPT** | 24/14 | ★접지/코팅/커팅 | 🟢 단가=가격표 L1 블록(접지옵션·코팅·커팅타공). ★=종류 enumeration(셀에 값) | 옵션 enumeration 파싱(OC) |
| **POUCH_PRODUCT** | 43/3 | goods-pouch 상품옵션(폰모델) | 🟢 폰모델 variants(셀에 값)·가격=goods-pouch 가격표 | 모델별 사이즈 variant 파싱(OC) |
| **LINING_RING** | 5/4 | ★면지/바인더링 조건부 | 🟢 면지=무료(hc072 라이브 확인)·★...선택시만=조건규칙(값) | 규칙 파싱(OC) |
| **OTHER_STAR** | 5/5 | 아크릴 "투명테두리★" | 🟢 아크릴 인쇄옵션 enumeration | 옵션 파싱(OC) |

## 2. 핵심 재분류 (애매모호의 정체)
- **★ 마커 ≠ 단가 미상.** ★는 거의 전부 **제약/조건 스펙**(크기 min/max·사이즈선택·...선택시만·종류 enum)이며
  값이 셀에 명시돼 있다. 파싱하면 DB constraint/option 레이어로 들어간다(OC 작업·돈 아님).
- **단가는 가격표에 있다.** 박(후가공_박 3종)·봉투(봉투제작)·접지/코팅/커팅(L1)·종이(출력소재 절가)
  전부 가격표 권위 블록 + 라이브 적재 확인. 하드커버 표지 전용지("계산식")만 라이브 역산으로 별도 해소
  (`hc072-blocked-resolution-LIVE-260629.md`).

## 3. 진짜 잔여(좁음) → 다음 단계
1. **per-product 종이/단가 미적재** = score_batch CALC가 자동 적발(투명엽서 PET 등). 발견 시 §26/dbmap 적재.
2. **박 prc_typ .01/.02 혼재** = band-total 과대청구 점검(COMP_NAMECARD_FOIL_S1_HOLO=.01 vs S1_STD=.02).
   [[bandtotal-x-qty-overcharge-260628]] 패턴 — 박 단독 점검 finding.
3. **constraint/option 파싱(OC)** = ★ 스펙 → DB constraint/option 레이어. score_batch OC가 미충족 축 적발.
4. **addon 템플릿 mint** = 봉투류(엽서봉투·캘린더봉투) → t_prd_product_addons 템플릿(가격=봉투제작 재사용).

## 4. 다음 단계 진입 판단
**BLOCKED 때문에 멈추는 구조적 위험은 해소됨.** 남은 건 (a) 데이터 미적재(자동 적발·적재) (b) OC 파싱
(c) band-total 점검 — 전부 **결정론 배치(score_batch) + 알려진 패턴**으로 처리 가능. 새 미상 BLOCKER 없음.
→ score_batch 상품군 전파(sticker→문구→acrylic→…)로 진입, CALC FAIL/OC 갭을 자동 수집해 적재/파싱.

## 5. 안전
라이브 읽기전용·가격표 권위 절대·값 날조 0. 라이브 단가는 미상 항목 보강 증거(자동 DB 주입 금지·인간 승인).
산출: `blocked-risk-registry.csv`(146건 분류)·본 문서.
