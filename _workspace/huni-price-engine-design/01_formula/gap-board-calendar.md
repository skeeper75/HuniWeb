# gap-board-calendar.md — 캘린더 현 라이브 미설계/불완전 갭 보드 (designer 작업 큐)

> 캘린더 가격사슬의 현 라이브 미설계·불완전 지점. designer가 채울 곳. 라이브 실측 2026-06-22 · 출처 명기.

---

## 전체 진단: 캘린더 = WIRE-type 결함 (round-21 패턴)

단가값은 일부 실재(제본비 적재)하나 **공식·배선·바인딩이 전무.** 단가 결손이 아닌 조립 결함.

| 항목 | 라이브 현황 | 결함 |
|------|------------|------|
| 공식 바인딩(t_prd_product_price_formulas) | **0건** | 캘린더 5상품 어디에도 가격공식 바인딩 없음 → 견적 불가 |
| 캘린더 공식(PRF_CAL_*) | **부존재** | 인쇄+용지+제본 조립 공식 없음 |
| formula_components(제본 comp 배선) | **0행** | COMP_BIND_CAL_* 단가행 적재됐으나 어느 공식에도 wire 안 됨 |
| 인쇄비·용지비 comp 배선 | **부재** | COMP_PRINT_DIGITAL_S1·COMP_PAPER 재사용 대상이나 캘린더 공식 미존재로 미배선 |
| product_prices / option_groups / templates | **0건** | inline 고정가·옵션·SKU 전부 미적재 |

---

## GAP Top 5 (우선순위)

### GAP-1 [HIGH·차단] 캘린더 가격공식 전무 — 견적 불가
- 라이브 t_prd_product_price_formulas 캘린더 PRD 0건. PRF_CAL_* 공식 부존재.
- designer 작업: 인쇄비(COMP_PRINT_DIGITAL_S1·페이지수 곱) + 용지비(COMP_PAPER) + 제본비(COMP_BIND_CAL_*) 합산 공식 PRF_CAL_DESK220/DESK130/MINI/WALL 신설 + 5상품 바인딩.
- 출처: `SELECT * FROM t_prd_product_price_formulas WHERE prd_cd IN (PRD_000108~112)` → 0행.
- `확신도: 높음`

### GAP-2 [HIGH·돈크리티컬] 인쇄비 출력매수에 페이지수(장수) 곱 누락 위험
- calc-draft `인쇄비 = [총출력장수/판걸이수] × 인쇄비`, 총출력장수 = 주문수량 × **페이지수**.
- 캘린더 페이지수 4~16장(엽서=1장). 페이지수 곱 누락 시 인쇄비 4~16배 과소청구.
- designer 작업: 출력매수 산식에 페이지수(장수) 차원 추가 — 상품마스터 `장수(필수)` 칸 4(8P)/8(16P)/12(24P)/16(32P) 파싱. ★4(8P)=4장(양면 8페이지) — "장수"=출력 leaf 수, 곱셈 단위.
- `확신도: 높음(calc-draft 명시)`

### GAP-3 [MED·컨펌큐] 제본비 prc_typ 충돌 — 수량구간 vs ×제작수량
- calc-draft r95 `제본비 = [수량행][제본종류열]`(수량구간) ↔ r98 `캘린더가공비 = [가공비] × 제작수량`(평면).
- 라이브 COMP_BIND_CAL_* = **수량구간형**(min_qty tier)으로 적재됨 → 이게 결판 권위.
- designer 작업: 제본비(트윈링/캘린더제본) = COMP_BIND_CAL_* 수량구간 재사용 / 단순 add-on(우드거치대 4000·타공+끈 1000/1500) = 고정단가 × 제작수량 신규 comp. 두 prc_typ 분리.
- `확신도: 중(문자 충돌·라이브가 수량구간으로 결판)`

### GAP-4 [MED] 캘린더가공 add-on comp 미적재
- 우드거치대(4000)·1구타공+끈(1000)·2구타공+끈(1500) — 상품마스터 `추가가격` 칸 verbatim. 라이브 comp 부재.
- designer 작업: COMP_CALOPT_* 신규 mint(고정단가 × 제작수량) + 공식 add-on 배선. ★엽서캘린더는 우드거치대가 `캘린더가공`(4000)이자 `추가상품`(4000)으로 이중 표기 — 가공 add-on으로 단일화(이중 합산 금지).
- `확신도: 높음`

### GAP-5 [MED] 공정 proc_cd 이원화 — 트윈링제본 표현 충돌
- 상품 바인딩 PROC_000021(트윈링제본) vs 제본비 단가행 PROC_000099(벽걸이캘린더제본)/PROC_000100(탁상캘린더제본).
- 같은 제본을 두 proc_cd로 표현 → designer 정합 점검(어느 것이 가격 룩업 키인지·use_dims proc_cd 매칭 검증). COMP_BIND_CAL_* use_dims=[proc_cd,...]이므로 단가행 proc(99/100)가 룩업 키. 상품 바인딩 PROC_000021은 생산BOM용일 가능성.
- `확신도: 중(이원화 의도 미확정)`

---

## 추가 컨펌큐 (차단 아님)

- **Q-CAL-PKG**: 수축포장(PROC_000076)·개별포장 가격 영향 — `개별포장(옵션)` 추가가격 칸 공란. 무료 옵션 vs 가산 미정.
- **Q-CAL-PAGE-RANGE**: 페이지수 enumeration이 상품별 다름(엽서 12~16P·벽걸이 4~15장). 각 페이지값이 인쇄비 단가행에 매핑되는지(출력매수 = 페이지수×수량 산식 검증).
- **Q-CAL-ENVELOPE**: 캘린더봉투(PRD_000005·012-0008) = addon vs 독립상품 경계. 추가가격 2400~2500. 봉투제작 트랙 위임.
- **Q-CAL-GOLDEN**: `디자인캘린더` inline 가격(탁상220 30P=10400·미니=6500·엽서145=4000·벽걸이=9900·와이드=24000)을 §2 공식으로 재현 가능한지 — designer 골든 케이스 셋. 와이드 24000(3절·트윈링제본 2000 포함)이 큰 점프 → 3절 인쇄비·종이 절가 차이 확인.
- **Q-CAL-PLATE**: 판걸이수(판수) = 앱 임포지션 계산(DB 미저장). 출력매수 분모. 국4절 vs 3절 판형별 판걸이수 다름.

---

## designer 권고 요약

1. PRF_CAL_* 공식 4종 신설 = 인쇄비(페이지수 곱) + 용지비 + 제본비 합산. 디지털 PRF_DGP_A/E chassis 재사용.
2. comp 재사용: COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_CAL_* (mint 금지).
3. 신규 mint = add-on 가공 comp(우드거치대·타공+끈)뿐.
4. 페이지수 곱·제본비 수량구간 prc_typ = 돈크리티컬 2종.
5. 5상품 바인딩 + 골든 5건(디자인캘린더 inline) 재현 검증.
