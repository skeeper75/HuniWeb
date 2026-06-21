# 세트/완제품 가격 패턴 — 캘린더(달력) (9번째 종단)

> `hpe-benchmark-analyst` 캘린더 종단 3/3. 캘린더가 **반제품 부품합산(책자 BOOKLET 패턴)** 으로 가는지 **inline 고정가 완제품**으로 가는지를 경쟁사 증거로 판정해 후니 세트상품 설계 입력으로 제공.
> **중복 금지**: `set-pricing-patterns.md` P-1/P-2/P-3·`set-product-design.md`·`absorption-candidates-booklet.md` §세트는 보존(재유도 0).
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수·naming/codes 유입 금지·권위 엑셀 최종.

## 출처
- `[red:cal]` = `_workspace/huni-widget/05_qa/captures/s6_cal_*.json`(가격분해 실측).
- `[huni:cal]` = `_workspace/huni-dbmap/06_extract/calendar-l1.csv`(상품마스터·세트 컬럼 없음 확인).
- `[huni:sets]` = `absorption-candidates-booklet.md` §0(라이브 `t_prd_product_sets` 28행·캘린더 PRD_000108~112 세트 미분리 실측).
- `[prior]` = `set-pricing-patterns.md` P-1(다부품 합성)·P-2(묶음수)·P-3(변형 SKU).

---

## 0. 캘린더 세트 판정 한눈 — 부품합산 ❌ / 본체단일 + 가공가산 ✅

★**핵심 판정**: 캘린더는 **책자형 다부품 세트(표지+내지+제본 별 prd_cd 합산)가 아니다.** 본체 = **단일 디지털인쇄물(장수=페이지지만 한 prd_cd의 옵션 축)** + **제본/거치대 가공 가산**. 책자 BOOKLET P-1(다부품 합성)과 **결정적으로 다름**.

| 패턴 | 책자(BOOKLET) | 캘린더 | 근거 |
|------|---------------|--------|------|
| 부품 분리(표지/내지 별 prd_cd) | ✅ 하드커버류 `t_prd_product_sets`(072+073+074~076) | ❌ **캘린더 PRD_000108~112 세트 미분리** `[huni:sets]` | 라이브 sets 28행에 캘린더 부모-자식 0 |
| 장수(페이지) 처리 | 내지 단가 × 페이지수(별 부품) | **한 prd의 옵션 축**(장수=4(8P)~16(32P)·본체 SUM 내부 변수) | `[huni:cal]` 장수 컬럼 = 같은 행 옵션 |
| 제본/거치대 | 제본비 단일항 또는 부품 | **가공 가산**(삼각대/링/타공 add-on 또는 B03 부당×수량) | `[huni:cal·bind]` |
| RedPrinting 엔진 | `book2025_price`(표지/내지 WGT 분리·INN_PAGE) | **`offset2023_price` PCS합산 / `vTmpl`/`tiered`/`tmpl`**(부품 분리 없음·인쇄+가공 Σ) | `[red:cal]` |

→ **캘린더 = "본체 단일 + 가공 가산" 합산형**이지 반제품 다부품 세트 아님. 후니 `t_prd_product_sets` 캘린더 미사용이 **정합**(부품 분리 불요).

---

## 1. RedPrinting 캘린더 세트 패턴 — 부품합산 아님·PCS 가산 `[red:cal]`

- **offset2023(HLCLSTD/WAL)**: MTRL_CD 단일행(RXRAU240·RXSNO200)·표지/내지 분리 **없음**(책자 PRBKORD는 MTRL_CD 다행·캘린더는 1행). 가격 = **인쇄(PRT) + 제본(RIN) + 거치대(CLD)/타공(HOL) PCS 합산**. 즉 **한 본체 + 후가공 Σ**(P-1 다부품 합성 아님).
- **vTmpl(TPCLWLB)**: 개당단가 × 인쇄수량 × 주문건수 — **완제 단가 1종**. starting-year/month 옵션이 가격 무영향 = 템플릿에 baked(P-3 변형 SKU와도 다름·variant 가격분기 없음).
- **tmpl(GSCLMGN)**: edicus 완제 SKU 개당단가 — **완전 완제품**(부품 0).

→ RedPrinting도 캘린더를 **부품합산 세트로 안 푼다**(책자만 부품합산). 캘린더 = 본체+가공 합산 또는 완제 단가. **후니와 동형**.

---

## 2. 후니 캘린더 세트 설계 입력 (designer 공급) `[huni:cal·sets]`

### 2.1 세트 구조 = 불요 (본체 단일 prd)
- 캘린더 6 상품(탁상/미니탁상/엽서/벽걸이/와이드벽걸이) **전부 단일 prd_cd**. 장수(페이지)는 본체 디지털 SUM 공식의 옵션 축(임포지션=앱계산·DB 미저장·`dbmap-compute-in-app` 철학)이지 별 내지 부품 아님.
- → **`t_prd_product_sets` 캘린더 미사용 유지**(부품 분리 금지·책자 패턴 오적용 금지).

### 2.2 가격 합성식 (합산형)
```
캘린더 가격 = 본체(디지털인쇄 SUM: 용지비 + 인쇄비[도수×면×수량] + 재단)
            + 캘린더가공 가산  ← AC-1(B03 부당×수량) 또는 AC-2(inline 고정가)
            [× 수량구간할인 if tiered]
```
- **본체** = 디지털인쇄 종단 SUM 공식 계열(PRF_DGP_* 동형·장수=페이지수 변수).
- **가공** = AC-1(B03 제본비 부당×수량 매트릭스) 또는 AC-2(상품마스터 inline 고정가 add-on) — **CQ-1 인간 결정**으로 상품별 그릇 확정.
- **세트 조합(t_prd_product_sets) 불요** — 이중계상 위험 없음(부품 분리 없으므로).

### 2.3 ★엽서캘린더 nuance — 우드거치대(4000원)는 완제 SKU 부속물
- 엽서캘린더 220×130 = 우드거치대 4000원 가산. 거치대 = **부속물(addon)**(rpmeta PD addons·상품악세사리 정합)이지 제본 부품 아님. → add-on comp 가산(AC-2)·세트 분해 불요.

---

## 3. 한 줄 결론 (세트 각도)

캘린더는 **반제품 다부품 세트(책자 BOOKLET P-1)가 아니라 "본체 단일 디지털인쇄물 + 제본/거치대 가공 가산"의 합산형**이다. RedPrinting(offset PCS합산·vTmpl/tiered/tmpl 완제)도 캘린더를 부품합산으로 풀지 않고 본체+가공 Σ 또는 완제 단가로 처리 — **후니 권위(캘린더 `t_prd_product_sets` 미분리·캘린더가공 가산)와 동형**. 세트 그릇 신설/사용 **불요**. 가공 가산 그릇은 AC-1(B03 부당×수량) vs AC-2(inline 고정가) **CQ-1 인간 결정**. 장수(페이지)=본체 옵션 축(앱 임포지션 계산)이지 별 내지 부품 아님(책자 패턴 오적용 금지).
