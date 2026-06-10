# 상품악세사리 — 도메인 리서치 노트 (round-11 확대 #9 · 11시트 완성)

> **작성** 2026-06-10 · round-11. **신규 리서치·발견 충돌·🔴/🟡 컨펌만** 기록. round-9 OTC 인벤토리·07_domain이 이미 닫은 것은 재기술하지 않는다(재유도 0).
>
> **권위:** 후니 PDF > round-9 OTC 인벤토리 > 07_domain KB > 국내외 표준. 표준 충돌 시 후니 권위.

---

## 0. round-9 OTC 인벤토리 재사용 — 신규 리서치 불요 (재유도 0)

상품악세사리의 의미는 **round-9 OTC 인벤토리(`10_configurator/all-sheets-otc-extract.md`)가 이미 권위로 확정** → 본 round-11은 인용만:

| 주제 | round-9/07_domain 권위 | round-11 적용 |
|------|------------------------|---------------|
| 봉투류 TEMPLATE | OTC §"봉투=별도 생산·포장·배송 독립 상품 → TEMPLATE"(base PRD_000001/002/281~283 라이브 실재) | C4 봉투 |
| 볼체인/리필잉크 TEMPLATE | OTC C-1(볼체인=키링 addon·리필잉크=PRD_000015 독립·WowPress 부자재 별도 SKU) | C4 볼체인/리필잉크 |
| 우드거치대 분기 | OTC C-4(가공컬럼 OPTION vs 추가상품컬럼 TEMPLATE·WowPress 40210/40211) | C4 우드거치대 |
| OPTION vs TEMPLATE 판별 | `option-vs-template-guide.md`("별도 생산·포장·배송 독립 상품인가? 예=TEMPLATE") | 전 부자재 |
| `★사이즈선택` 동적 template | round-9 GAP-B(본체 size 연동 동적 template) | 엽서/캘린더 봉투 |
| addon=tmpl_cd 전환 | loadspec(models.py addon→tmpl_cd) | C4 addon 참조 |

→ **상품악세사리는 round-9 OTC가 거의 완전 커버**(봉투/볼체인/리필잉크/우드 전부 OTC 표제). 신규 WebSearch 불요. 신규 리서치는 아래 컨펌(3축 분해·이중등록·MES 공유)에 국한.

---

## 1. 발견한 충돌 — 사이즈 3축 복합 + 이중 등록 (상품악세사리 고유 2건)

엑셀 실측 × round-9 OTC 대조.

### 1-1. 사이즈 셀 3축 복합 (PA-2)
- 상품악세사리 사이즈 셀 = **치수 + 묶음수 + 색상이 한 셀에 합성**(`70x200mm (50장)`·`오렌지 (3개1팩)`·`청보라 (5cc)`·`270mm + 면끈`).
- 다른 시트는 사이즈=치수만(또는 비규격 범위). 상품악세사리는 부자재라 묶음수(N장/팩/세트/개입)와 색상이 사이즈 셀에 함께.
- **3분해 필요:** 치수→`t_siz_sizes` / 묶음수→`t_prd_product_bundle_qtys`(QTY_UNIT) / 색상→variant(옵션 vs 별 SKU). → **CONFIRM-PA-2/PA-3.**

### 1-2. 부자재 이중 등록 (PA-1)
- 상품악세사리 15상품은 **자체 prd_cd 독립 판매**(라이브 PRD_000001/002 봉투·006 볼체인·015 리필잉크·281~283 카드봉투) + **다른 상품 addon으로 tmpl_cd 참조**.
- round-9 OTC: 봉투=엽서/카드 addon·볼체인=키링 addon·우드=캘린더/족자/행잉 addon·리필잉크=만년스탬프 addon.
- **이중 역할 적재:** `t_prd_products`(독립) + `t_prd_templates`(addon SKU). → **CONFIRM-PA-1.**

**검증된 정합(round-9 OTC ↔ 엑셀 실측 일치):**
- 봉투류 TEMPLATE(별도 생산·배송) ✅
- 볼체인 9색→8색 variant(C-1) ✅
- 우드거치대 C-4 분기 ✅
- 리필잉크 PRD_000015 독립 ✅

> **타 시트 같은 오모델(포토북 G-PB-2·스티커 G-SK-2·실사 사이즈) 없음.** 상품악세사리 고유 미확정=사이즈 3축 분해(PA-2)·색상 variant 귀속(PA-3)·이중 등록(PA-1).

---

## 2. 🔴/🟡 컨펌 질문 (인간 결정 대기)

### CONFIRM-PA-1 [🟡] 부자재 이중 등록 — prd_cd 독립 + tmpl_cd addon?
- **상황:** 15 부자재가 자체 판매(prd_cd)도, 다른 상품 addon(tmpl_cd)도 가능. 라이브 일부 독립 적재(PRD_000001/002/006/015/281~283).
- **가설:** 둘 다(독립 판매 + addon 참조). round-9 OTC TEMPLATE 권위.
- **질문:** 15 부자재를 독립 상품(prd_cd)으로도 등록하고 동시에 addon template(tmpl_cd)으로도 둘까요? 어느 부자재가 독립 판매 활성인가요?

### CONFIRM-PA-2 [🟡] 사이즈 3축 분해 — 치수/묶음수/색상?
- **상황:** 사이즈 셀=`70x200mm (50장)`·`오렌지 (3개1팩)`·`청보라 (5cc)` 복합.
- **가설:** 치수→siz·묶음수(50장/3개1팩/2개1세트/20개입)→bundle_qty(QTY_UNIT)·색상→variant.
- **질문:** 묶음수를 bundle_qty로 분리할까요, siz 명에 인코딩 유지할까요? (book/굿즈 묶음수 처리와 정합)

### CONFIRM-PA-3 [🟡] 색상 variant 귀속 — 옵션 vs 별 SKU?
- **상황:** 볼체인 8색·리필잉크 7색·와이어링 3색·카드봉투 화이트/블랙·행택끈 3종.
- **가설:** 색상=옵션(option_items) 또는 별 SKU(별 prd_cd/siz). round-9 굿즈 화이트M/L=한덩어리(C-6) 정합.
- **질문:** 부자재 색상을 색상 옵션으로 둘까요, 색상별 별 SKU로 둘까요?

### CONFIRM-PA-4 [🟡] 우드거치대/봉/행거 — OPTION vs TEMPLATE 분기?
- **상황:** 우드거치대=캘린더/엽서 거치·우드봉=족자·우드행거=행잉 addon.
- **가설:** round-9 C-4(본체가공 OPTION vs 별매 TEMPLATE). 캘린더 CL-2·실사 SL-4와 동류.
- **질문:** 우드 부속을 본체가공 옵션으로, 별매 추가상품(TEMPLATE)으로, 둘 다(분기)로 둘까요?

### CONFIRM-PA-5 [🟡] MES 공유 처리?
- **상황:** 012-0004(OPP접착=비접착)·012-0012(우드거치대=우드봉)·012-0013(우드행거=리필잉크)·012-0016(와이어링=천정고리) = 같은 MES, 다른 prd_nm.
- **가설:** 같은 생산/매입 품목 라인, 다른 판매 상품. 별 prd_cd로 분리(멱등 키=prd_nm).
- **질문:** MES 공유 부자재를 각각 별 prd_cd로 둘까요? (멱등 키=prd_nm, MES는 보조)

---

## 3. 디지털인쇄~굿즈파우치 컨펌과의 관계 (일괄 결정 후보)

| 컨펌 | 캘린더 | 실사 | 굿즈파우치 | 상품악세사리 | 일괄 결정 |
|------|--------|------|-----------|--------------|----------|
| 부속 자재 vs 공정 vs addon | CL-5 | SL-4 | GP-4 | PA-4(우드) | ✅ 통합(부속 귀속) |
| 색상 variant 귀속 | — | — | GP-2(본체색) | PA-3(부자재 색상) | ✅ 통합(색상 옵션 vs SKU) |
| addon/template 모델 | CL-2(우드거치대) | — | GP(볼체인) | PA-1(이중등록) | ✅ 통합(OTC TEMPLATE 모델·round-9 권위) |

상품악세사리 **고유 신규 컨펌**: PA-2(사이즈 3축 분해)·PA-5(MES 공유) = 부자재 카탈로그 특화.

---

## 4. 다음 단계 (round-11 11시트 완성)

1. **컨펌 5건 해소** — PA-1~5. PA-4(우드)·PA-3(색상)=타 시트 일괄. PA-1/PA-2/PA-5=부자재 고유.
2. **round-11 11 상품시트 완성** — 디지털·스티커·책자·포토북·캘린더·실사·아크릴·문구·굿즈파우치·상품악세사리(+디자인캘린더 통합). **MAP=카테고리 맵(상품 아님) 제외.**
3. **schema-design-intent-map 입력** — 상품악세사리 OTC TEMPLATE 카탈로그(부자재 이중등록·addon tmpl_cd)를 HANDOFF #1과 결합. round-9 OTC 인벤토리가 이미 권위 → schema-intent에서 재사용.

---

## Sources
- **후니 권위(1순위):** 상품마스터 `260610.xlsx` 상품악세사리(가격포함) 시트(L1 `06_extract/product-accessory-l1.csv`, 15상품·67행·9컬럼).
- **round-9 OTC 인벤토리(권위):** `10_configurator/all-sheets-otc-extract.md`(봉투/볼체인/우드/리필잉크 TEMPLATE·C-1/C-4)·`option-vs-template-guide.md`(OPTION vs TEMPLATE 판별)·`cpq-confirm-research-c1-c4.md`(C-1/C-4 확정).
- **07_domain KB(2순위):** `entity-semantic-model.md §3 #9`(추가상품=거치대/우드봉/볼체인). 라이브 적재 이력=PRD_000001/002/006/015/281~283.
- (신규 WebSearch 미수행 — 상품악세사리는 round-9 OTC 커버리지 충분.)
