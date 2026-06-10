# 책자 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·생산방식) + `_loadspec/loadspec.md`(적재방법·책자 delta).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **의미축 분리 우선** — 내지≠표지 자재(usage_cd), page_rule≠묶음수, 제본 enum=공정, 면지=자재, 박색≠별색금.
3. **생산방식 3구조 인식** — A 통합(parent usage)·B 셋트(표지 sub_prd)·떡제본(묶음). **자재 권위=parent+usage_cd 항상**.
4. **앱 계산 vs DB 룩업** — 박 면적등급(C29)은 앱 런타임.
5. **적재 순서 = 마스터(A) → 상품(A) → 상품하위(B)** — FK 위상정렬. B 셋트=sub_prd 빈 껍데기 후 sets 연결.

---

## 2. 컬럼 → t_* 매핑 표 (43컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | **R85 URL행 제외** | ✅ |
| 2 | ID | 외부키 | (매핑 보조키) | — | prd_cd 아님 | 🟡 |
| 3 | MES_ITEM_CD(상품) | MES | `t_prd_products.mes_item_cd` | A | 원형 D-05 | ✅ |
| 4 | 상품명 | 상품정체 | `t_prd_products.prd_nm` | A | 멱등 키. 제본=정체 | ✅ |
| 5 | 사이즈(필수) | 재단치수+책등 | `t_siz_sizes.cut_*` + `t_prd_product_sizes`; 두께=제본 책등 param 교차 | A→B | A4 두께A 31mm=하드커버링 책등 | 🟡 |
| 6 | 내지 MES | MES(내지) | (sub_prd MES/생산메타) | — | B 셋트 내지 식별 | 🟡 |
| 7 | 내지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(내지) | A | 도출 | 🟡 |
| 8 | 내지 작업사이즈 | 작업치수 | `t_siz_sizes.work_*`(내지) | A | — | ✅ |
| 9 | 내지 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*`(내지) | A | — | ✅ |
| 10 | 내지 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖 | 🔴 |
| 11 | 내지 출력파일 | 파일포맷 | `output_file_typ`(내지) | B | PDF | 🟡 |
| 12 | 내지 폴더 | 인쇄방식(내지) | (GAP); 공정 root 도출 | — | 책자/디지털/실사 | 🟡 |
| 13 | 내지종이(필수) | 자재(내지) | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.01 내지**) | A→B | `*별도설정`=공통풀. G-BK-1(내지 0행=결함) | ✅ |
| 14 | 내지인쇄(필수) | 도수(내지) | `t_prd_product_print_options.print_side`(내지) | B | 양면 주로 | ✅ |
| 15 | 내지페이지 최소 | page_rule | `t_prd_product_page_rules.page_min` | B | 중철4·무선24·트윈링8 | ✅ |
| 16 | 내지페이지 최대 | page_rule | `t_prd_product_page_rules.page_max` | B | 중철28·무선300·트윈링100 | ✅ |
| 17 | 내지페이지 증가 | page_rule | `t_prd_product_page_rules.page_incr` | B | **중철=4(4배수)**·기타2 | ✅ |
| 18 | 표지 MES | MES(표지) | (sub_prd MES) | — | **B 셋트 표지 반제품 식별** | 🟡 |
| 19 | 표지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(표지) | A | 도출 | 🟡 |
| 20 | 표지 작업사이즈 | 작업치수(표지) | `t_siz_sizes.work_*`(표지) | A | 책등 포함 펼침 치수 | 🟡 |
| 21 | 표지 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖 | 🔴 |
| 22 | 표지 출력파일 | 파일포맷 | `output_file_typ`(표지) | B | PDF | 🟡 |
| 23 | 표지 폴더 | 인쇄방식(표지) | (GAP); 공정 root 도출 | — | **레더=특수인쇄(내지와 별도)** | 🟡 |
| 24 | 표지종이(필수) | 자재(표지) | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.02 표지**) | A→B | 레더=가죽 반제품. 전용지=하드커버 | ✅ |
| 25 | 표지인쇄(필수) | 도수(표지) | `print_side`(표지) | B | 하드=단면 | ✅ |
| 26 | 표지코팅 | 공정(코팅·표지) | `t_proc_processes`(코팅) + product_processes(표지) + prcs_dtl_opt | A→B | 표지 전용. 내지 코팅 없음 | ✅ |
| 27 | 투명커버 | 자재+공정 | 자재(USAGE.05 투명커버) + `t_proc_processes`(부착) BUNDLE | A→B | 트윈링 전용 | 🟡 |
| 28 | 박/형압가공 | 공정(박/형압·표지) | `t_proc_processes`(박 PROC_000033/형압) + product_processes(표지) + prcs_dtl_opt(음각/양각) | A→B | 무선/PUR. 박≠별색금 | ✅ |
| 29 | 박 크기 | 공정 param | prcs_dtl_opt(min/max) — 면적→등급 앱계산 | B | 크기범위=입력UX | 🟡 |
| 30 | 박칼라 | 박 색상 | prcs_dtl_opt(박색) **또는** 포일자재 | B | **귀속 컨펌**(D-26 금유광 책자추가). 디지털 CONFIRM-DP-1 동류 | 🟡 |
| 31 | 제본(필수) | 공정+택일 | `t_proc_processes`(PROC_000017 자식) + `t_prd_product_processes`(mand=Y) + `t_prd_process_excl_groups`(GRP-BOOK-제본) | A→B | **enum→공정 변환.** 택일그룹 단일. 레더바인더=빈값 | ✅ |
| 32 | 제본방향 | 공정 param | prcs_dtl_opt.`방향`(좌철/상철) | B | PROC_000017 방향 | ✅ |
| 33 | 면지 | 자재(면지) | `t_mat_materials` + `t_prd_product_materials`(usage_cd=**USAGE.03 면지**) | A→B | D-29. ★인쇄면지=조건부 캐스케이드(constraint_json) | ✅ |
| 34 | 링컬러 | 자재/param(링) | prcs_dtl_opt(링컬러) 또는 자재(링 부속) | B | 트윈링/하드링 | 🟡 |
| 35 | 바인더링 | 자재/param(D링·책등) | 자재(D링 MAT) 또는 prcs_dtl_opt(책등 mm) | B | D링 mm=책등(C5 두께 정합). ★사이즈선택 | 🟡 |
| 36 | 제본(묶음수) | 묶음수 | `t_prd_product_bundle_qtys`(bdl_qty·bdl_unit=QTY_UNIT.03 권) | B | **떡제본 권(50/100장1권). page 아님** | ✅ |
| 37 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1~3권 | ✅ |
| 38 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | — | ✅ |
| 39 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | — | ✅ |
| 40 | 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | Y | ✅ |
| 41 | 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | Y | ✅ |
| 42 | 개별포장 | 공정(포장) | `t_proc_processes`(포장/수축) + product_processes | A→B | 수축포장 옵션 | 🟡 |
| 43 | COMMENT | 메타 | **GAP/note** | — | 견적밖 운영 메모 | 🔴 |

> **가격공식:** 책자 시트엔 가격공식 컬럼 부재 → 가격표(`05_qa`/`06_extract` 책자 가격) + round-2 트랙(별도). 포토북(가격포함) 시트와 별개.

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합, B 셋트 포함)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(USAGE .01~.05·QTY_UNIT.03 권·PRD_TYPE·MAT_TYPE)
   → t_siz_sizes(규격+책등 두께) → t_mat_materials(내지/표지/면지 종이·레더·D링)
   → t_proc_processes(PROC_000017 제본 자식 7·코팅·박·형압·부착·포장)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 11상품
   [B 셋트] 표지 sub_prd 빈 껍데기(PRD_TYPE.02 반제품) 선생성
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes → _materials(usage_cd .01내지/.02표지/.03면지/.05투명커버)
   → _print_options(내지/표지) → _page_rules(내지) → _processes(제본/코팅/박/형압/부착/포장)
   → _process_excl_groups(GRP-BOOK-제본) → _bundle_qtys(떡제본 권) → _categories
   [B 셋트] sets로 표지 sub_prd 연결
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.

---

## 4. 매핑 결정 요약 (책자 — 디지털인쇄/스티커와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| 생산방식 3구조 | A 통합/B 셋트/떡제본. 자재=parent+usage_cd 항상(sub_prd 0행 정상) | 07_domain §4 |
| 내지/표지 usage 분리 | C13→USAGE.01·C24→USAGE.02·C33→USAGE.03 | 07_domain USAGE |
| 제본→공정+택일 | C31 enum→PROC_000017 자식 + GRP-BOOK-제본 | 07_domain §5·db-structure |
| page_rule vs 묶음수 | C15~17=page_rule(제본별 차등)·C36=bundle(떡제본 권) | entity-semantic §28·§138 |
| 면지=USAGE.03 자재 | C33 화이트/블랙/그레이/인쇄면지 | decision-trail D-29 |
| 표지옵션=표지 공정 | C26~30 코팅/투명커버/박/형압 usage=표지 | 07_domain §3-2 |
| 책등=size+제본param | C5 두께A/B ↔ C35 D링 mm | 07_domain §137 |
| 레이플랫 미운영 | 제본 7종(레이플랫 PROC_000025 제외) | entity-semantic §144 |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-BK-1 [🟡]** 박칼라(C30) 귀속 — 공정 param vs 포일 자재(D-26 금유광 책자추가). 디지털 CONFIRM-DP-1·스티커와 통합.
- **CONFIRM-BK-2 [🟡]** 레더 링바인더 제본(C31 빈값) — 바인더(D링 결합)가 PROC_000017 자식인지 별 공정인지.
- **CONFIRM-BK-3 [🟡]** 투명커버(C27)·링컬러(C34)·바인더링(C35) — 자재 vs 공정 param 귀속(D링=자재 MAT인가 책등 param인가).
- **CONFIRM-BK-4 [🟡]** 레더(C24 표지종이) 자재유형 — MAT_TYPE.06 가죽 vs 종이.
- **CONFIRM-BK-5 [🟡]** B 셋트 표지 sub_prd 분해 범위 — 하드커버/레더만 sub_prd, 일반책자(A)는 parent-적재(entity-semantic §126 booklet Q2 이월).
- **CONFIRM-BK-6 [🔴]** C10/C21 파일명약어·C43 COMMENT 견적 DB 귀속(디지털 CONFIRM-DP-2와 통합).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 43컬럼이 목표 t_* 또는 명시적 GAP/미저장으로 귀결.
