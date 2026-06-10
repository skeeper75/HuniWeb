# 포토북 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·variant) + `_loadspec/loadspec.md`(적재방법·포토북 delta).
> **권위:** 후니 PDF > 07_domain KB > 경쟁사 SKU(보조) > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **variant 의미축 분리 우선** — **size variant→size 차원**·**표지타입 variant→표지 sub_prd(USAGE.02)**·page→page_rule. 디자인명=에디터 템플릿(variant 아님).
3. **의미축 분리** — 내지≠표지 자재(usage_cd), 표지종이=자재+코팅 분해(G-PB-3), 표지타입≠표지종이(G-PB-2), 책등≠size.
4. **생산방식** — 하드/레더하드=B 셋트(표지 sub_prd)·소프트=A 통합 근접. **자재 권위=parent+usage_cd 항상**.
5. **가격포함 시트** — C37 base + C38 per-page = round-2 가격엔진(별 트랙). 매핑 정보는 귀속까지.
6. **적재 순서 = 마스터(A) → 상품(A) → 표지 sub_prd(A) → 상품하위(B) → sets** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (38컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | 포토북 단일 그룹 | ✅ |
| 2 | ID | 외부키 | (매핑 보조키) | — | prd_cd 아님 | 🟡 |
| 3 | MES_ITEM_CD(상품) | MES | `t_prd_products.mes_item_cd` | A | **빈값**(미부여, 신상품 가능) | 🟡 |
| 4 | 상품명 | 상품정체 | `t_prd_products.prd_nm` | A | 멱등 키. **디자인명=에디터 템플릿 슬롯(PRD_TYPE.04)** | ✅ |
| 5 | 사이즈(필수) | **재단치수 variant** | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | A→B | 4종. variant=별도 상품 아님(entity-semantic §2) | ✅ |
| 6 | 내지 MES | MES(내지) | (sub_prd MES/생산메타) | — | 빈값 | 🟡 |
| 7 | 내지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(내지) | A | 도출 | 🟡 |
| 8 | 내지 작업사이즈 | 작업치수 | `t_siz_sizes.work_*`(내지) | A | — | ✅ |
| 9 | 내지 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*`(내지) | A | — | ✅ |
| 10 | 내지 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖. 표지타입 연동(포토북하드/레더/소프트) | 🔴 |
| 11 | 내지 출력파일 | 파일포맷 | `output_file_typ`(내지) | B | PDF | 🟡 |
| 12 | 내지 폴더 | 인쇄방식(내지) | (GAP); 공정 root 도출 | — | 디지털인쇄 | 🟡 |
| 13 | 내지종이(필수) | 자재(내지) | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.01 내지**) | A→B | 몽블랑130 단일 | ✅ |
| 14 | 내지인쇄(필수) | 도수(내지) | `t_prd_product_print_options.print_side`(내지) | B | 양면 | ✅ |
| 15 | 내지페이지 최소 | page_rule | `t_prd_product_page_rules.page_min` | B | 하드24·소프트4 | ✅ |
| 16 | 내지페이지 최대 | page_rule | `t_prd_product_page_rules.page_max` | B | 150 | ✅ |
| 17 | 내지페이지 증가 | page_rule | `t_prd_product_page_rules.page_incr` | B | **2(=가격 2P당 정합)** | ✅ |
| 18 | 표지타입(필수) | **반제품 표지 variant** | `t_prd_products`(표지 sub_prd PRD_TYPE.02) + sets; 하드/레더하드 | A | **G-PB-2 분리.** 경쟁사 hardcover/leather/softcover | ✅ |
| 19 | 표지 MES | MES(표지) | (sub_prd MES) | — | B 셋트 표지 반제품 식별 | 🟡 |
| 20 | 표지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(표지) | A | 15(싸바리 접힘) | 🟡 |
| 21 | 표지 작업사이즈 | 작업치수(표지) | `t_siz_sizes.work_*`(표지) | A | **책등 포함 펼침**(size 2배+α). 표지타입별 | 🟡 |
| 22 | 표지 재단사이즈 | 재단치수(표지) | `t_siz_sizes.cut_*`(표지) | A | 빈값(반제품) | 🟡 |
| 23 | 표지 파일명약어 | 생산메타 | **GAP/note** | — | cover. 견적밖 | 🔴 |
| 24 | 표지 출력파일 | 파일포맷 | `output_file_typ`(표지) | B | PDF | 🟡 |
| 25 | 표지 폴더 | 인쇄방식(표지) | (GAP); 공정 root 도출 | — | **레더=특수출력·하드/소프트=디지털** | 🟡 |
| 26 | 표지종이사양(필수) | **자재+공정 복합** | `t_mat_materials`(아트250/레더) + `t_prd_product_materials`(USAGE.02) + `t_proc_processes`(무광코팅) | A→B | **G-PB-3 분해.** 레더=가죽 | ✅ |
| 27 | 표지인쇄사양(필수) | 도수(표지) | `print_side`(표지) | B | 단면 | ✅ |
| 28 | 제본사양 제본 | 공정(제본) | `t_proc_processes`(PROC_000017 PUR) + `t_prd_product_processes`(mand=Y) | A→B | **PUR 단일**(excl_group 불요). 레이플랫 미운영 | ✅ |
| 29 | 제본사양 면지 | 자재(면지) | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.03 면지**) | A→B | D-29. 그레이 단일 | ✅ |
| 30 | 제본사양 책등 | 공정 param(책등) | prcs_dtl_opt(PUR 책등 mm) — 페이지수 따라 앱계산 | B | 10/12/14/16mm | 🟡 |
| 31 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1 | ✅ |
| 32 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 1000 | ✅ |
| 33 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1 | ✅ |
| 34 | 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | 희소 | 🟡 |
| 35 | 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | **Y(에디터 중심)** | ✅ |
| 36 | 가이드파일 | 생산메타 | (GAP/note) | — | AI/PSD | 🟡 |
| 37 | 가격 기본(24P) | **가격 base** | `t_prd_product_prices` 또는 `t_prc_*`(base) | (round-2) | size×표지타입 매트릭스 base | 🟡 |
| 38 | 가격 추가(2P)당 | **가격 per-page 증분** | `t_prc_*`(증분 component) | (round-2) | per-page. C17 증가2 정합 | 🟡 |

> **가격공식:** 포토북=**가격포함 시트**(C37 base + C38 per-page). 책자/스티커/디지털인쇄 시트엔 가격 컬럼 부재였으나 **포토북은 가격 내장** → round-2(`dbm-price-formula`) 고정가 base + 증분형 매핑. 본 매핑 정보는 가격 컬럼의 **t_* 귀속까지**, 공식 전개는 round-2.

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합, B 셋트 + 가격)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(USAGE .01~.03·PRD_TYPE.02 반제품/.04 디자인·MAT_TYPE 종이/.06 가죽)
   → t_siz_sizes(내지/표지 재단·작업) → t_mat_materials(몽블랑130·아트250·레더·그레이 면지)
   → t_proc_processes(PROC_000017 PUR·코팅·면지부착·포장)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm "포토북 [디자인명]") — 1상품(또는 디자인명별 다상품)
   표지 sub_prd 빈 껍데기(PRD_TYPE.02 반제품) 선생성 — 하드/레더하드
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes(4 variant) → _materials(usage .01내지/.02표지/.03면지)
   → _print_options(내지양면/표지단면) → _page_rules(내지 24~150) → _processes(PUR/코팅/면지부착/포장)
   → _categories
   [B 셋트] sets로 표지 sub_prd 연결(하드/레더하드)
4. 가격(round-2 트랙): t_prd_product_prices / t_prc_*(base 24P + per-page 2P당)
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.

---

## 4. 매핑 결정 요약 (포토북 — 책자/디지털인쇄와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **1상품 + variant** | `포토북[디자인명]` 1종 × size 4 × 표지타입 3 (별도 상품 아님) | entity-semantic §2 + 경쟁사 SKU |
| 표지타입=반제품 variant | C18 하드/레더하드=표지 sub_prd(USAGE.02)·소프트=종이표지 | entity-semantic §2/§4 |
| 제본=PUR 단일 | C28 PUR만(excl_group 불요). 레이플랫 미운영 | 07_domain §144 |
| 표지종이 복합 분해 | C26 `아트250+무광코팅`=자재+코팅 공정(G-PB-3) | entity-semantic §1-1 |
| 내지/표지/면지 usage | C13→.01·C26→.02·C29→.03 | 07_domain USAGE |
| page_rule + 가격증분 | C15~17=page_rule·증가2 ↔ C38 추가2P당 | entity-semantic §28 |
| **가격포함** | C37 base + C38 per-page → round-2 가격엔진 | 경쟁사 base+per-page 동형 |
| 디자인명=템플릿 | C4 디자인명=에디터 SKU(PRD_TYPE.04 디자인·디자인보유) | 사용자 directive |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-PB-1 [🟡]** 표지타입 sub_prd 분해 범위 — 하드/레더하드만 sub_prd(B 셋트), 소프트커버는 A 통합(종이표지)? 책자 BK-5 동류.
- **CONFIRM-PB-2 [🟡·1순위]** 레이플랫 vs PUR — 후니 포토북 제본=PUR 확정, 레이플랫(PROC_000025) 미운영? (entity-semantic §144 C-10 1순위).
- **CONFIRM-PB-3 [🟡]** 레더(C26) 자재유형 — MAT_TYPE.06 가죽 vs 종이. 표지종이 복합표기 분해 정합.
- **CONFIRM-PB-4 [🟡]** 가격 base(24P)+per-page(2P당) → round-2 매핑 — 고정가 base + 증분 component 구조.
- **CONFIRM-PB-5 [🟡]** 디자인명 SKU 모델 — `포토북[디자인명]`이 디자인별 다상품인가, 1상품+에디터 템플릿(디자인보유)인가. 경쟁사=1상품+디자인 템플릿.
- **CONFIRM-PB-6 [🔴]** C10/C23 파일명약어 견적 DB 귀속(디지털 CONFIRM-DP-2·스티커 ST-5·책자 BK-6과 통합).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 38컬럼이 목표 t_* 또는 명시적 GAP/round-2로 귀결.
