# 디지털인쇄 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — 매핑(L1/L2)·적재가 차질 없도록 "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. 이 문서가 `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정) + `_loadspec/loadspec.md`(적재방법).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 적용 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — 각 엑셀 값은 ① UI(어떤 옵션 컴포넌트) ② 생산(자재/공정 BOM·MES) ③ 가격(가격엔진)의 세 의미가 정합하는 t_*로 간다. 한 값을 잘못된 t_*에 넣지 않는다.
2. **의미축 분리 우선** — 한 컬럼이 두 축이면(별색≠도수, 박색≠별색금, 출력판형≠재단치수) 두 t_*로 분리.
3. **앱 계산 vs DB 룩업 구분** — 판수(C6)·박 면적등급(C36)은 DB 미저장(앱 런타임). 매핑 대상 아님.
4. **자재 권위 = parent + usage_cd** — 낱장은 본체(USAGE.01/공통). sub_prd 분해 없음.
5. **적재 순서 = 마스터(surface A) → 상품(A) → 상품하위(surface B)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (44컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | 적재 surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories`(cat_cd) | B | 시트 그룹 → 카테고리(판매분류와 별개) | 🟡 |
| 2 | ID | 외부키 | (매핑 보조키) | — | prd_cd 아님. 출처 추적용 | 🟡 |
| 3 | MES_ITEM_CD | MES코드 | `t_prd_products.mes_item_cd` | A | 원형 대문자 보존(D-05) | ✅ |
| 4 | 상품명 | 상품정체 | `t_prd_products.prd_nm` | A | 멱등 키 | ✅ |
| 5 | 사이즈(필수) | 재단치수 | `t_siz_sizes.cut_width/height` + `t_prd_product_sizes` | A→B | "73 x 98 mm"→파싱(w,h). siz_cd 채번/멱등 | ✅ |
| 6 | 판수 | 판걸이수 | **미저장(앱 계산)** | — | 가격공식 분모. t_* 매핑 금지 | ✅ |
| 7 | 블리드 | 재단여유 | `t_siz_sizes.margin_*`(도출) | A | work−cut=2×블리드. 별 컬럼 부재 | 🟡 |
| 8 | 작업사이즈 | 작업치수 | `t_siz_sizes.work_width/height` | A | "75 x 100"→(w,h). 같은 siz_cd 행 | ✅ |
| 9 | 재단사이즈 | 재단치수 | `t_siz_sizes.cut_width/height` | A | C5와 동일 → 한 siz_cd 통합 | ✅ |
| 10 | 출력용지규격 | 출력판형 | `t_prd_product_plate_sizes.output_paper_typ_cd` + `t_siz_sizes`(impos_yn=Y) | A→B | "316x467"→OUTPUT_PAPER_TYPE 코드 | ✅ |
| 11 | 파일명약어 | 생산메타 | **GAP**(note/견적밖) | — | t_* 컬럼 부재. ddl-proposer 검토 | 🔴 |
| 12 | 출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ` | B | PDF/AI 자유텍스트. PDF(+W)=화이트별색 교차 | 🟡 |
| 13 | 폴더 | 생산라우팅 | **GAP**(견적밖 가능) | — | 생산 워크플로우. 견적 DB 밖 | 🔴 |
| 14 | 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | Y/N | ✅ |
| 15 | 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | Y/N(빈값=N) | ✅ |
| 16 | 종이(필수) | 자재 | `t_mat_materials`(MAT_TYPE) + `t_prd_product_materials`(usage=본체) | A→B | `*별도설정`=공통풀 IMPORT(빈값 아님). 평량=mat_nm 일부 | ✅ |
| 17 | 인쇄 | 도수 | `t_prd_product_print_options.print_side` + front/back_colrcnt_cd | B | 단면→back=0도. 별색 제외 | ✅ |
| 18 | 별색>화이트 | 공정(별색) | `t_proc_processes`(PROC_000008) + `t_prd_product_processes` + prcs_dtl_opt(면) | A→B | print_side 아님. (단/양면)=param | ✅ |
| 19~22 | 별색>클리어/핑크/금/은 | 공정(별색) | `t_proc_processes`(PROC_000009~012) + product_processes | A→B | 금/은=잉크(≠박). 다중 선택 | 🟡 |
| 23 | 코팅 | 공정(코팅) | `t_proc_processes`(코팅) + product_processes + prcs_dtl_opt(광택/면) | A→B | ★180g조건→constraint_json | ✅ |
| 24 | 커팅 | 공정+형상 | `t_proc_processes`(완칼) + prcs_dtl_opt(형상 enum) | A→B | 형상 25종=param. size축 아님 | 🟡 |
| 25 | 접지 | 공정+단수 | `t_proc_processes`(접지/PROC_000073) + prcs_dtl_opt(단수/방향) | A→B | 6단오시접지=복합 leaf. ★사이즈종속 | ✅ |
| 26 | 건수(옵션) | 수량단위 | `t_prd_products.qty_unit_typ_cd`(QTY_UNIT) | A | Y=건수 단위 | 🟡 |
| 27 | 최소 | 수량하한 | `t_prd_products.min_qty` | A | 사이즈종속 가능→대표값 | ✅ |
| 28 | 최대 | 수량상한 | `t_prd_products.max_qty` | A | — | ✅ |
| 29 | 증가 | 수량step | `t_prd_products.qty_incr` | A | 판걸이수 배수 | ✅ |
| 30 | 모서리 | 공정(귀돌이) | `t_proc_processes`(귀돌이) + product_processes | A→B | 직각=기본/둥근=공정 | 🟡 |
| 31 | 오시 | 공정+줄수 | `t_proc_processes`(오시) + prcs_dtl_opt(줄수0~3) | A→B | 오시→접지 선행 | ✅ |
| 32 | 미싱 | 공정+줄수 | `t_proc_processes`(미싱) + prcs_dtl_opt(줄수) | A→B | 절취선 | ✅ |
| 33 | 가변(텍스트) | 공정(VDP) | `t_proc_processes`(가변) + prcs_dtl_opt(개수·텍스트) | A→B | 넘버링/개인화 | 🟡 |
| 34 | 가변(이미지) | 공정(VDP) | `t_proc_processes`(가변) + prcs_dtl_opt(개수·이미지) | A→B | 〃 | 🟡 |
| 35 | 박/형압 가공 | 공정(박/형압) | `t_proc_processes`(박/형압) + product_processes + prcs_dtl_opt(음각/양각) | A→B | 박≠별색금 | ✅ |
| 36 | 박 크기 | 공정 param | prcs_dtl_opt(min/max) — **면적→등급 앱계산** | B | 크기범위=입력UX, 가격=면적 ceiling | 🟡 |
| 37 | 박칼라 | 박 색상 | prcs_dtl_opt(박색) **또는** 자재(포일) | B | **귀속 컨펌**(공정param vs 자재) | 🟡 |
| 38 | 추가상품 | 추가상품 | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates` | B | addon=tmpl_cd 전환. 봉투=SKU. ★사이즈선택 캐스케이드 | 🟡 |
| 39 | 추가가격 | 가격 | (빈값 — template/가격 트랙) | — | 디지털인쇄 시트 미기재 | 🔴 |
| 40 | 가격공식 | 가격공식 | `t_prc_price_formulas` + `t_prd_product_price_formulas` | A→B | **round-2 영역**. 원자합산형 PRF_DGP | 🟡 |
| 41~44 | 가격공식(파일명/잔여) | 혼재 | (C41=파일명 규칙·별 축 / C42~44 대부분 빈값) | — | 가격≠파일명 혼재 분리 | 🟡 |

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(코드그룹 14) → t_siz_sizes → t_mat_materials → t_proc_processes
   → t_clr_color_counts → t_prc_price_components/formulas → t_prd_templates
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm)
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes → _plate_sizes → _materials(usage_cd) → _print_options
   → _processes(별색/코팅/커팅/접지/박/형압/오시/미싱/가변) → _bundle_qtys
   → _categories → _addons(tmpl_cd) → _price_formulas
```

**채번/멱등:** PK는 자동채번(PREFIX+max+1), 멱등 키 = 이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 코드전략 D1~D5). 감사컬럼(reg_dt/upd_dt) 비입력.

---

## 4. 매핑 결정 요약 (디지털인쇄)

| 결정 | 내용 | 근거 |
|------|------|------|
| 별색→공정 | C18~22를 print_option 아닌 `t_proc_processes`(PROC_000007 family)로 | 07_domain §3-2 |
| 판수 미저장 | C6은 t_* 매핑 안 함(앱 임포지션 계산) | 메모리 compute-in-app |
| 출력판형 분리 | C10→plate_sizes, C5/C9→cut, C8→work (3축) | 07_domain §1·platesize-is-output-paper |
| 자재 usage=본체 | 낱장은 sub_prd 분해 없이 parent+USAGE.01 | 07_domain §4(C 단일) |
| addon=template | C38 봉투를 tmpl_cd로(addon_cd DROP) | models.py:218 Phase7 |
| 조건부 캐스케이드 | C23 ★180g, C25/C36/C38 ★사이즈선택 → constraint_json/JSONLogic | round-6 CPQ |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심 3건:
- **C37 박칼라 귀속** — 공정 param vs 포일 자재 (RedPrinting 역공학 대조 필요)
- **C11/C13 생산메타** — 파일명약어·폴더의 견적 DB 귀속 여부(note vs 신규컬럼 vs 견적밖)
- **C7 블리드** — work-cut 도출 vs 별 컬럼(margin 활용)

이 3건 외 41컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 컬럼이 목표 t_* 또는 명시적 GAP/미저장으로 귀결.
