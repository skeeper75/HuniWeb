# gap-board-photobook — 포토북 라이브 미설계/불완전 지점 (designer 작업 큐)

> 라이브 t_prc_* 가격사슬 부재(WIRE)·미설계·차단 지점. designer가 채울 큐. 라이브 읽기전용 실측(2026-06-22).

---

## 0. 한눈 갭 (요약)

| 갭 ID | 지점 | 상태 | 우선순위 |
|-------|------|------|---------|
| **G-PB-1** | PRF_PHOTOBOOK_SUM 공식 부재(0행) | ❌ WIRE | High |
| **G-PB-2** | 부모 100 공식 바인딩 0행 | ❌ WIRE | High |
| **G-PB-3** | 표지 아트250 용지 단가행 0행 | 🟡 부분 결손 | Medium |
| **G-PB-4** | base24 상품단가 적재 방식 미결(base comp vs 부품 Σ) | ◆ 설계결정 | High |
| **G-PB-5** | 표지 무광코팅 comp 소스 미확정 | ◆ 컨펌(Q-PB-COAT) | Medium |
| **G-PB-6** | 면지 가격기여 여부 미확정 | ◆ 컨펌(Q-PB-FACE) | Low |
| **G-PB-7** | 소프트커버 8x8(row8) 단가 공란 | ◆ 시트 결손 | Low |
| **G-PB-PAGE** | 페이지수 곱 누락 시 내지비 소실(돈크리티컬) | ⚠ 가드 | High |

---

## 1. WIRE 결함 (가격사슬 부재)

### G-PB-1 · PRF_PHOTOBOOK_SUM 공식 부재
- 라이브 `t_prc_price_formulas`에 포토북 공식 **0행**(PRF_PHOTOCARD_FIXED=다른 상품). source=NONE.
- designer: 부품합산 세트 공식 신설(책자 PRF_BIND_SUM 공유 검토 후 부품집합 상이면 신설).

### G-PB-2 · 부모 100 공식 바인딩 부재
- `t_prd_product_price_formulas WHERE prd_cd='PRD_000100'` **0행**. 세트 그릇(`t_prd_product_sets` 7행)만 실재.
- designer: 세트부모 PRD_000100에 PRF_PHOTOBOOK_SUM 바인딩. sub_prd(101~107)는 가격 비기여(BOM/MES만·이중계상 가드).

---

## 2. 부분 결손 (단가행)

### G-PB-3 · 표지 아트250 용지 단가행 0행
- COMP_PAPER 몽블랑130(내지)=SIZ_499 1행 실재(77.03). 표지 **아트250+무광코팅** 단가행 미탐(0행).
- designer: 가격표 `제본` 또는 출력소재 시트에서 아트250 단가 verbatim 적재. 추측 금지.

---

## 3. 설계 결정 (designer 판단)

### G-PB-4 · base24 상품단가 적재 방식 (High)
- 마스터 `가격_기본(24P)` = variant 고정 상품단가(15000 등·권위 verbatim).
- **선택지**: (가) base24를 공식의 base comp(고정 비목)로 적재 vs (나) base24를 부품 단가행 Σ로 분해(표지+내지12장+PUR+면지).
- **권고**: (가) base24 통째 적재(시트 권위 verbatim·정수해 부품 분해는 Q-PB-COAT/FACE 미해소로 BLOCKED). per2p는 페이지 차원 comp로 별도. **GP-2 inline 고정가 + 캘린더 제본비 .01 패턴 혼합.**
- ⚠ **돈크리티컬 가드 G-PB-PRODPRICE**: base24를 `t_prd_product_prices`에 INSERT하면 엔진(:315-330) PRODUCT_PRICE 선점으로 FORMULA(per2p 페이지 가산) 통째 우회 silent → 페이지 가산 소실. **product_prices INSERT 금지·공식 base comp로.**

---

## 4. 컨펌큐 (인간)

| ID | 내용 |
|----|------|
| **Q-PB-PHOTO** | 제본방식=PUR 확정(시트 전행 `제본사양_제본=PUR`)·해소됨. 표지 variant별 단가 소스 |
| **Q-PB-COAT** | 표지 아트250 무광코팅 가격기여·코팅 comp 소스(라이브 탐색 필요) |
| **Q-PB-FACE** | 면지 그레이 가격기여 여부(책자 선례=비기여 택1 색) |
| **Q-PB-GOLDEN** | base24 부품합산 정확 재현(15000=표지+내지+PUR+면지) — 부분 BLOCKED |
| **Q-PB-SOFT8** | 소프트커버 8x8(row8) 공란 단가 |
| **Q-PB-PAGEBASE** | 소프트 page_min=4 vs 하드 24 — base가 4P 기준인지 24P 기준인지(per2p 적용 시작점) |

---

## 5. 돈크리티컬 가드 (designer/validator 입증)

| 가드 | 결함 시나리오 | 입증 골든 |
|------|--------------|-----------|
| **G-PB-PAGE** | 페이지수 곱 누락 → 내지비 전소(24P→150P 3배 과소청구) | per2p×(N-24)/2 산식·캘린더 G-CAL-PAGE 동형 |
| **G-PB-PRODPRICE** | base24를 product_prices INSERT → FORMULA 우회 silent·페이지 가산 소실 | 상품악세사리 G-AC-3·GP-2·캘린더 G-CAL-2 동형(:311-326) |
| **G-PB-SET** | sub_prd(101~107)에 가격 부여 → 이중계상 | 책자 G-BK-5(sets=BOM·가격은 부모 공식 Σ만) |
| **G-PB-BIND01** | 제본 PUR을 .02 합가형 오적용 → ÷부수 붕괴 | COMP_BIND_PUR=.01 단가형(라이브 verbatim)·캘린더 G-CAL-BIND 동형 |
