# 아크릴 가격사슬 — BLOCKED 분리 (추측 적재 금지·HARD)

> 미해소 컨펌·신규 단가행은 SQL에 넣지 않음(`apply.sql` 미동봉). 컨펌/GAP 해소 후 별 트랙으로 적재.
> 입력 = `confirms-and-gaps.md` Q-ACR-1~10. 실 적용 = 인간 승인.

---

## 1. SQL에서 제외한 항목 (미발화)

| BLOCKED-ID | 항목 | 미동봉 이유 | 어디까지 했나 | 언블록 조건 |
|-----------|------|-----------|-------------|-----------|
| **B-CLR-META (Q-ACR-7)** | `PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T` 배선 메타 보정(disp_seq NULL→1·addtn_yn NULL→N) | 엔진 evaluate_price가 prc_typ **.02(합가형)** 를 수량 곱하는지 총액인지 미확정. 보정값(addtn_yn=N) 자체는 안전하나, .02 정합 미확인 상태 메타 확정은 돈-크리티컬 추측 | `03_prc_formula_components.sql`에 DO UPDATE 문 **주석으로** 작성(즉시 활성화 가능) | Q-ACR-7 엔진 계약 확정(.02 계산법) → 주석 해제·재게이트 |
| **B-MIRROR-BIND (Q-ACR-9)** | `PRF_MIRROR_ACRYL` 상품 바인딩 | 미러3T 단가행(37행) 실재하나 **어느 상품이 미러 본체인지 불명**(골드실버명찰153? 미사용?). 바인딩 대상 추측 금지 | 공식정의(01)·배선(03·MIRROR3T 재사용)까지 적재. 바인딩(04) **0행** | Q-ACR-9 미러 본체 상품 식별 → product_price_formulas 바인딩 추가 |
| **B-Q8-BIND (Q-ACR-8)** | 입체블럭169·코스터159·아크릴명찰골드실버153 바인딩 | 본체 소재·가격공식 불명(투명3T 매트릭스? 미러? 별 가격?). 설계 §5도 "컨펌"으로 표기 | 바인딩 표에서 제외(투명 명백분만 18 바인딩) | Q-ACR-8 상품 정체→소재→공식 확정(라이브/사이트) → 바인딩 추가 |

> **주의**: B-CLR-META의 보정값 `disp_seq=1·addtn_yn=N`은 GAP-WIRE-META(엔진 합산순서 읽힘) 해소에 필요. 단 .02 prc_typ 자체가 의심(round-16 .01과 충돌)이라, 메타만 보정하고 .02를 그대로 두면 거짓 정합 위험. Q-ACR-7로 .02/.01 먼저 확정 후 메타 보정이 안전.

## 2. 신규 단가행 GAP (별 트랙·단가행 적재는 본 빌드 범위 밖)

| GAP-ID | comp | 미적재 단가행 | 본 빌드 처리 | 적재 트랙 |
|--------|------|:--:|------|------|
| **GAP-COROTTO-PRICE** | `COMP_ACRYL_COROTTO` | B06 6×6 = 21조합 | comp 정의(.01/.01)·배선만. **단가행 0** | siz 좌표 채번 후 component_prices 21행 적재(round-5 별 트랙) |
| **GAP-CARABINER-PRICE** | `COMP_ACRYL_CARABINER` | B07 4형상 고정가(자물쇠5,800/하트A5,800/하트B6,300/원형6,900) | comp 정의(.06/.01)·배선만. **단가행 0** | opt_cd 형상키 확정(Q-ACR-2) 후 component_prices 4행 적재 |

> **단가행 없이 공식·comp·배선·바인딩만**: 코롯토·카라비너는 사슬 골격(공식→comp→배선→상품바인딩)을 닫되, 가격값(component_prices)은 미적재. 엔진이 단가행 룩업 시 0건 → 그 상품 가격조회는 GAP 노출(거짓 0 아님). 단가행 적재는 좌표 채번·opt_cd 확정 후.

## 3. 미동봉 — 별 트랙(본 빌드 범위 명시 제외)

| 항목 | 트랙 | 비고 |
|------|------|------|
| 후가공 `COMP_ACRYL_FINISH`(은색고리/자석/바디 추가단가) | round-16/round-6 | Q-ACR-1(CPQ opt_cd→component 연결 키) 미해소. addon-attachment-proposal §4 |
| 아크릴 CPQ 옵션레이어(groups/options/items) | round-6 `dbm-option-mapper` | `cpq.sql` 미동봉(GAP-CPQ-ZERO) |
| 매트릭스 미적재 좌표(CLEAR3T ~58·미러 ~8) | siz 채번 후 round-5 | Q-ACR-5 영구격자 vs 부분 결정 |
| 8mm(MAT_000044) 단가 | 제외 | 가격표 단가 부재(Q-ACR-10) — 적재 불가 |
| 수량구간 할인(B04/B08) | round-1 t_dsc | 가격그릇 밖 |

## 4. 폐루프 (이 BLOCKED가 닫히는 조건)

- [ ] B-CLR-META: Q-ACR-7 → .02 계산법 확정 → 03 주석 해제 → C1(키링 30x30 100개=311,000) 재계산 일치.
- [ ] B-MIRROR-BIND: Q-ACR-9 → 미러 본체 상품 식별 → 04에 미러 바인딩 추가.
- [ ] B-Q8-BIND: Q-ACR-8 → 169/159/153 정체 확정 → 04에 바인딩 추가.
- [ ] GAP-COROTTO/CARABINER-PRICE: 좌표·opt_cd 확정 → 단가행 적재.
- 충족 시 아크릴 = 견적가능 GO(공식 4 + 배선 + 23상품 바인딩 + 단가행 완결).
