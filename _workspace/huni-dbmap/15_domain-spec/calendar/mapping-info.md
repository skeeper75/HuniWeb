# 캘린더 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·가공) + `_loadspec/loadspec.md`(적재방법·캘린더 delta).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **캘린더 고유 축 인식** — **장수(낱장)≠page_rule≠bundle**·**캘린더가공=GRP-CAL-가공 택일**(+가공별 추가가격)·**조건부 캐스케이드**(링칼라=트윈링시만).
3. **의미축 분리** — 출력판형(C9)≠재단(C8)·우드거치대 가공(C19) vs 추가상품(C26)·봉투 ★사이즈선택 종속.
4. **생산방식** — C 완제품/단일(낱장). 자재 권위=parent usage.01.
5. **2 surface** — 캘린더(업로드판)·디자인캘린더(에디터·가격포함판)=같은 5상품 두 주문 방식.
6. **적재 순서 = 마스터(A) → 상품(A) → 상품하위(B) → 옵션/제약(round-6)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (30컬럼 전수 + 디자인캘린더 차이)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | form factor 그룹 | ✅ |
| 2 | ID | 외부키 | (보조키) | — | prd_cd 아님 | 🟡 |
| 3 | MES_ITEM_CD | MES | `t_prd_products.mes_item_cd` | A | 007-0001~5(5 form factor) | ✅ |
| 4 | 상품명 | **상품정체(form factor)** | `t_prd_products.prd_nm` | A | 멱등 키. form factor=정체 | ✅ |
| 5 | 사이즈(필수) | 재단치수 variant | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | A→B | 상품별 다수(엽서 6종) | ✅ |
| 6 | 파일사양 블리드 | 재단여유 | `t_siz_sizes.margin_*` | A | 도출 | 🟡 |
| 7 | 파일사양 작업사이즈 | 작업치수 | `t_siz_sizes.work_*` | A | — | ✅ |
| 8 | 파일사양 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*` | A | C5 정합 | ✅ |
| 9 | 파일사양 출력용지규격 | **출력판형** | `t_prd_product_plate_sizes.output_paper_typ_cd`(OUTPUT_PAPER_TYPE) | B | **316x467·330x660(와이드).** 재단≠출력판형 | ✅ |
| 10 | 파일사양 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖 | 🔴 |
| 11 | 파일사양 출력파일 | 파일포맷 | `output_file_typ` | B | PDF | 🟡 |
| 12 | 파일사양 폴더 | 인쇄방식 | (GAP); 공정 root 도출 | — | 디지털인쇄 | 🟡 |
| 13 | 주문방법 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | **캘린더=Y** | ✅ |
| 14 | 주문방법 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | **디자인캘린더=Y** | ✅ |
| 15 | 종이사양(필수) | 자재 | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.01 본체**) | A→B | `*별도설정`·3절(와이드) | ✅ |
| 16 | 인쇄(필수) | 도수 | `t_prd_product_print_options.print_side` | B | 탁상양면·엽서/벽걸이단면 | ✅ |
| 17 | 장수(필수) | **장수(낱장)** | **GAP** — page_rule vs variant(미확정) | B | **4(8P)/8(16P).** 캘린더 고유. G-CL-5 | 🟡 |
| 18 | 캘린더가공 삼각대컬러 | 공정 param(삼각대) | prcs_dtl_opt(삼각대컬러) + `t_prd_product_processes` | B | 탁상 전용(그레이/블랙) | 🟡 |
| 19 | 캘린더가공 캘린더가공 | 공정+택일 | `t_proc_processes` + `t_prd_product_processes`(mand=Y) + `t_prd_process_excl_groups`(**GRP-CAL-가공**) | A→B | **택일그룹.** 우드거치대=C-4 분기 | ✅ |
| 20 | 캘린더가공 추가가격 | **옵션 추가가격** | `t_prd_product_options`/option price (round-6) | (round-6) | 가공별(우드4000·트윈링2000) | 🟡 |
| 21 | 캘린더가공 링칼라 | 공정 param(조건부) | prcs_dtl_opt(링칼라) + constraint_json | B | **★트윈링선택시만**(조건부) | 🟡 |
| 22 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1 | ✅ |
| 23 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 10000 | ✅ |
| 24 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1 | ✅ |
| 25 | 개별포장(옵션) | 공정(포장) | `t_proc_processes`(포장/수축) + product_processes | A→B | 수축포장 옵션 | 🟡 |
| 26 | 추가상품 추가상품 | **추가상품**(addon) | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates`(SKU) | B | **캘린더봉투(★사이즈선택)·우드거치대** | ✅ |
| 27 | 추가상품 추가가격 | 추가상품 가격 | template price/option | (round-6) | 봉투/거치대 추가가 | 🟡 |
| 28 | 가이드파일 | 생산메타 | (GAP/note) | — | AI/PSD | 🟡 |
| 29 | 템플릿 | 디자인 메타 | `t_prd_templates` 연계/메타 | — | 디자인보유 교차 | 🟡 |
| 30 | 디자인보유 | 디자인 제공 | `prd_typ_cd`(PRD_TYPE.04 디자인)/메타 | A | ●=디자인캘린더 연계 | 🟡 |
| §9 | (디자인캘린더) 페이지사양 | 고정 페이지 | (page 고정) + 가격 | A | 30P 등. 디자인 확정 | 🟡 |
| §9 | (디자인캘린더) 가격 | **가격 base** | `t_prd_product_prices`(고정가) | (round-2) | 4000~24000. 가격포함 | 🟡 |

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합, 택일그룹 포함)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(USAGE.01 본체·SEL_TYPE.01 택일·OUTPUT_PAPER_TYPE 316x467/330x660·PRD_TYPE.04 디자인)
   → t_siz_sizes(form factor별 재단·작업) → t_mat_materials(*별도설정·스노우지250·몽블랑190/240·삼각대·트윈링)
   → t_proc_processes(캘린더가공: 삼각대거치·트윈링제본·타공·포장)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 5 form factor (디자인캘린더=editor_yn·PRD_TYPE.04)
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes(form factor별 variant) → _materials(usage.01 본체)
   → _print_options(단/양면) → _plate_sizes(출력판형 316x467/330x660)
   → _processes(캘린더가공) → _process_excl_groups(**GRP-CAL-가공 택일**) → _addons(봉투/거치대 tmpl_cd) → _categories
4. 옵션/제약(round-6 L2): 캘린더가공 옵션그룹(가공별 추가가격)·링칼라 조건부 constraint_json·봉투 ★사이즈선택
5. 가격(round-2): 디자인캘린더 t_prd_product_prices(고정가)
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.

---

## 4. 매핑 결정 요약 (캘린더 — 포토북/책자와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **form factor 5상품** | 탁상/미니/엽서/벽걸이/와이드=별 상품(포토북 1상품과 반대) | MES 007-0001~5 |
| **장수=캘린더 고유 축** | C17 낱장 매수(page_rule·bundle 아님). 미확정 | entity-semantic §2 G-CL-5 |
| 캘린더가공=택일+추가가격 | C19 GRP-CAL-가공(excl_group) + C20 가공별 추가가격(round-6 옵션) | 07_domain §1 #5 |
| 조건부 캐스케이드 | C21 링칼라=트윈링시만·C26 봉투=사이즈종속 → constraint_json | RedPrinting cascade |
| 우드거치대 분기 | C19 가공(OPTION) vs C26 추가상품(TEMPLATE) | C-4(WowPress 40210/40211) |
| 출력판형 분리 | C9 316x467/330x660 ≠ 재단(C8) | 07_domain plate |
| **2 surface** | 캘린더(업로드)·디자인캘린더(에디터·가격포함)=같은 5상품 | 디자인 제공 패턴 |
| 추가상품=tmpl_cd | C26 봉투/거치대=`t_prd_templates` SKU | models.py addon→tmpl 전환 |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-CL-1 [🟡]** 디자인캘린더 모델 — 캘린더(업로드)와 같은 prd_cd에 editor_yn·가격·디자인 추가인가, PRD_TYPE.04 디자인 별 상품인가.
- **CONFIRM-CL-2 [🟡]** 우드거치대 귀속 — 캘린더가공(C19 OPTION) vs 추가상품(C26 TEMPLATE). C-4 분기(WowPress 40210/40211 = 본체가공 OPTION·별매 부자재 TEMPLATE).
- **CONFIRM-CL-3 [🟡·핵심]** 장수(C17) 모델 — 낱장 매수가 page_rule인가, variant(선택옵션)인가, 가격 차원인가. 책자 page_rule·떡제본 bundle과 다른 캘린더 고유 축(G-CL-5).
- **CONFIRM-CL-4 [🟡]** 캘린더가공 추가가격(C20)·추가상품 추가가격(C27) → round-6 옵션 가격 vs round-2 가격 매핑.
- **CONFIRM-CL-5 [🟡]** 삼각대·트윈링·우드거치대 = 자재(부속) vs 공정 param vs 추가상품. (책자 CONFIRM-BK-3 링 귀속과 동류.)
- **CONFIRM-CL-6 [🔴]** C10 파일명약어 견적 DB 귀속(전 시트 일괄).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 30컬럼(+디자인캘린더)이 목표 t_* 또는 명시적 GAP/round-2·6으로 귀결.
