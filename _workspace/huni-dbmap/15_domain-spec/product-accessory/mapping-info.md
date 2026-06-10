# 상품악세사리 — 데이터 매핑 정보 (round-11 통합 산출 · 11시트 완성)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세** 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)". `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(부자재 BOM) + `_loadspec/loadspec.md`(적재방법·PA delta).
> **권위:** 후니 PDF > round-9 OTC 인벤토리 > 07_domain > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-2/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **부자재=OTC TEMPLATE** — 상품악세사리는 완제 부속(인쇄 아님). 자체 prd_cd 독립 판매 + 다른 상품 addon으로 tmpl_cd 참조 = **이중 등록**(round-9 OTC 권위).
2. **사이즈 셀 3축 분해** — 치수(siz)·묶음수(bundle_qty)·색상(variant). 평면화 금지.
3. **인쇄 BOM 부재** — 자재/공정/도수/판형 컬럼 없음(완제 부속). 후니 인쇄 BOM 미적용 유일 시트.
4. **가격포함=round-2 고정가** — variant별 단가.
5. **적재 순서 = 마스터 → 부자재 상품(prd_cd) → template(tmpl_cd) → 사이즈/묶음/색상 variant → 가격(round-2)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (9 의미 컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | 봉투/케이스·상품액세서리 2군 | ✅ |
| 2 | ID | 외부키 | (보조키) | — | prd_cd 아님 | 🟡 |
| 3 | MES_ITEM_CD | MES | `t_prd_products.mes_item_cd` | A | 012-0004~0018. MES 공유(PA-5) | ✅ |
| 4 | 상품명 | **부자재 정체** | `t_prd_products.prd_nm` + `t_prd_templates.tmpl_nm` | A | **이중 등록**(독립 prd_cd + addon tmpl_cd). 멱등 키 | ✅ |
| 5 | 사이즈(필수) | **치수+묶음+색상(복합)** | `t_siz_sizes.cut_*` + `t_prd_product_bundle_qtys` + 색상 variant | A→B | **3축 분해**(PA-2): 치수=siz·묶음=bundle·색상=variant/옵션 | 🟡 |
| 6 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1 | ✅ |
| 7 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 100 | ✅ |
| 8 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1 | ✅ |
| 9 | 가격 | **가격 base** | `t_prd_product_prices`(고정가) | (round-2) | 가격포함→round-2 고정가. variant별 단가 | 🟡 |

---

## 3. 적재 순서 (FK 위상정렬)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(QTY_UNIT 장/개/팩/세트·색상 코드값 — 색상 옵션 시)
   → t_siz_sizes(부자재 치수·우드 길이·잉크 용량)
2. 부자재 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 15 부자재 (라이브 일부 적재 PRD_000001/002/006/015/281~283)
   + t_prd_templates (tmpl_cd — addon 참조 SKU, 봉투/볼체인/우드/리필잉크)
3. 부자재 하위(surface B 인라인):
   t_prd_product_sizes(치수 variant) → t_prd_product_bundle_qtys(묶음수 N장/팩/세트/개입)
   → 색상 variant(option vs 별 siz·PA-3) → t_prd_product_categories
4. 옵션/제약(round-6): 색상 옵션(볼체인 8색·리필잉크 7색)·우드거치대 C-4 분기
5. 가격(round-2 고정가): t_prd_product_prices(variant별 단가)
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(round-9 D1~D5). 감사컬럼 비입력.
**라이브 적재 이력:** 봉투(PRD_000001/002/281~283)·볼체인(PRD_000006)·리필잉크(PRD_000015) 이미 라이브 적재(round-9 OTC 참조). 본 round-11은 그 위 도메인 정리(재적재 아님).

---

## 4. 매핑 결정 요약 (상품악세사리 — 타 시트와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **부자재=OTC TEMPLATE 이중 등록** | prd_cd 독립 + tmpl_cd addon 참조 | round-9 OTC 인벤토리·C-1 |
| **인쇄 BOM 부재** | 자재/공정/도수/판형 컬럼 없음(완제 부속) | 시트 구조(9컬럼) |
| **사이즈 3축 복합** | 치수=siz·묶음수=bundle·색상=variant | C5 복합 인코딩(PA-2) |
| **MES 공유** | 012-0004 OPP접착=비접착 등 동일 생산품목·다른 판매상품 | C3 실측(PA-5) |
| **우드거치대 분기** | C-4(본체가공 OPTION vs 별매 TEMPLATE) | round-9 C-4(WowPress 40210/40211) |
| **가격포함=round-2** | variant별 고정가 | (가격포함) 시트 |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-PA-1 [🟡]** 부자재 이중 등록 — prd_cd(독립 판매)와 tmpl_cd(addon 참조) 둘 다인가? round-9 리필잉크=PRD_000015 독립·봉투=PRD_000001/002/281~283. 어느 부자재가 독립 판매 활성인지 확정.
- **CONFIRM-PA-2 [🟡]** 사이즈 3축 분해 — 치수/묶음수/색상을 siz·bundle_qty·variant로 어떻게 분리 적재할지(특히 묶음수=bundle vs siz 인코딩).
- **CONFIRM-PA-3 [🟡]** 색상 variant 귀속 — 볼체인 8색·리필잉크 7색·와이어링 3색 = 색상 옵션(option_items)인가 별 SKU(별 prd_cd/siz)인가?
- **CONFIRM-PA-4 [🟡]** 우드거치대/봉/행거 = C-4 분기(본체가공 OPTION vs 별매 TEMPLATE). 캘린더 CL-2·실사 SL-4와 동류(일괄).
- **CONFIRM-PA-5 [🟡]** MES 공유 처리 — 012-0004 OPP접착=비접착 등 같은 MES, 다른 prd_nm. 별 prd_cd로 분리(멱등 키=prd_nm)?

이 외 컬럼은 매핑 경로 확정. **애매모호 0 달성** — 모든 9 의미 컬럼이 목표 t_* 또는 round-2로 귀결.
