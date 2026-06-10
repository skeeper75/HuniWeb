# 실사 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·후가공) + `_loadspec/loadspec.md`(적재방법·실사 delta).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.
> **⚠️ [HARD·사용자] 가격 5컬럼(R/S/V/X/Z) 분석 제외** — 가격=인쇄상품 가격표(포스터사인 면적매트릭스) 별도 처리([[dbmap-silsa-price-via-poster-sign]]).

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **실사 고유 축 인식** — **면적형 사이즈**(규격+비규격+자유)·**소재=상품정체**·**실사 후가공**(봉제/타공/족자/부착/열재단)·**화이트 별색**(G-SL-2).
3. **사이즈 입력UX ≠ 가격격자** — 비규격 범위(C6/C7)=입력 한계, 가격·유효성=포스터사인 면적매트릭스 셀([[dbmap-l2-requires-l1-price-table]]). round-9 일반현수막 비치수 연속범위 오판 금지.
4. **의미축 분리** — 화이트별색(C18)=별색공정(도수 아님)·코팅(C19)=공정(자재 아님 Q9)·폴더(C14)=생산라우팅(인쇄방식 도출).
5. **생산방식** — C 완제품/단일(낱장). 자재 권위=parent 본체 usage. 인쇄방식=실사(아크릴스티커=UV).
6. **적재 순서 = 마스터(A) → 상품(A) → 상품하위(B) → 옵션/제약(round-6) → 가격(round-2 포스터사인)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (25 의미 컬럼 전수, 가격 5컬럼 분석 제외)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | 실사=구분 희소(소재 분기) | 🟡 |
| 2 | ID | 외부키 | (보조키) | — | prd_cd 아님 | 🟡 |
| 3 | MES_ITEM_CD | MES | `t_prd_products.mes_item_cd` | A | 004-*(실사출력)·005-*(사인) | ✅ |
| 4 | 상품명 | **상품정체(소재 기반)** | `t_prd_products.prd_nm` | A | 멱등 키. 소재=정체 | ✅ |
| 5 | 사이즈(필수) | 재단치수+입력모드 | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | A→B | **혼합 UX**(규격+고정+자유). 가격격자≠입력 | ✅ |
| 6 | 비규격 가로 | 비규격 가로범위 | (가격 가로축=포스터사인) / size 입력제약 | (round-2) | **연속범위=입력한계.** 가격=매트릭스 셀 | 🟡 |
| 7 | 비규격 세로 | 비규격 세로범위 | (가격 세로축=포스터사인) / size 입력제약 | (round-2) | 가로×세로=면적. 포스터사인 권위 | 🟡 |
| 8 | 파일사양 블리드 | 재단여유 | `t_siz_sizes.margin_*` | A | 유효0 보존(0mm). 도출 | 🟡 |
| 9 | 파일사양 작업사이즈 | 작업치수 | `t_siz_sizes.work_*` | A | **공백=미정의**(포맥스 A1 정당 미적재) | ✅ |
| 10 | 파일사양 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*` | A | C5 정합 | ✅ |
| 11 | 파일사양 출력용지규격 | 출력판형(숨김·희소) | `t_prd_product_plate_sizes.output_paper_typ_cd` | B | **실사=대형 롤·전지 무의미**(값 희소) | 🟡 |
| 12 | 파일사양 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖(SL-6) | 🔴 |
| 13 | 파일사양 출력파일 | 파일포맷 | `output_file_typ` | B | **JPG 주력**·커팅=PDF+AI | 🟡 |
| 14 | 파일사양 폴더 | **인쇄방식/라우팅** | (GAP); 공정 root 도출 | — | 실사출력/특수인쇄=실사·레이저커팅=UV | 🟡 |
| 15 | 주문방법 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | **실사=업로드 주력** | ✅ |
| 16 | 주문방법 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | **액자/행잉/족자=에디터** | ✅ |
| 17 | 소재(필수) | **자재(실사소재=정체)** | `t_mat_materials` + `t_prd_product_materials`(usage_cd=본체) | A→B | **소재=상품정체.** MAT_TYPE.08/.05/.06. usage CONFIRM-SL-5 | ✅ |
| 18 | 화이트별색(옵션) | **별색공정(화이트 underbase)** | `t_prd_product_processes`(PROC_000008 화이트) | B | **투명/홀로그램 베이스=필수**(G-SL-2). clr_cd=NULL | ✅ |
| 19 | 코팅(옵션) | **공정(코팅)** | `t_proc_processes`(코팅) + `t_prd_product_processes` | A→B | **코팅=공정**(자재 아님·Q9 확정). 무광코팅 | ✅ |
| 20 | 가공(옵션) 가공 | **실사 후가공 공정** | `t_proc_processes` + `t_prd_product_processes` + prcs_dtl_opt | A→B | 봉제(080)·타공(079)·족자(082)·열재단(084)·보드. **택일그룹 미적재 G-SL-3** | ✅ |
| 21 | 추가(옵션) 추가 | **추가상품**(addon) | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates` | B | **거치대·우드봉·액자.** "출력만"=addon 미선택 | 🟡 |
| 22 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1 | ✅ |
| 23 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 1000(종이)·10000(원단/배너) | ✅ |
| 24 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1 | ✅ |
| 25 | COMMENT | 실무메타 | (GAP/note) | — | 스레드댓글 9건 셀메타 보존 | 🟡 |
| R | price | (가격) | **분석 제외** | — | 포스터사인 면적매트릭스 | ⛔ |
| S | price(vat) | (가격) | **분석 제외** | — | R 파생(×1.1) | ⛔ |
| V | price(V) | (가공가) | **분석 제외** | — | 가격표 권위 | ⛔ |
| X | 가공_가격 | (가공 추가가) | **분석 제외** | — | round-6/가격표 | ⛔ |
| Z | 추가_추가옵션가격 | (추가상품가) | **분석 제외** | — | template/가격표 | ⛔ |

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(MAT_TYPE.08 실사소재/.05 원단/.06 가죽·PROC_000008 화이트·PRC_000006 실사 인쇄방식·USAGE 본체)
   → t_siz_sizes(규격 A3/A2/A1·고정 600x1800·인치규격 5x5 등 재단·작업)
   → t_mat_materials(인화지·매트지·PET·PVC·투명·그래픽천·린넨·캔버스·레더·타이벡·메쉬·현수막천·홀로그램·골드)
   → t_proc_processes(실사출력·코팅·화이트별색·봉제·타공·부착·족자제작·열재단·보드마운팅·레이저커팅)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 29 상품 (액자/행잉/족자=editor_yn=Y)
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes(규격+비규격 입력제약) → _materials(본체 usage, 소재=정체)
   → _print_options(단/양면·화이트별색) → _plate_sizes(출력판형·실사 희소)
   → _processes(코팅·후가공: 봉제/타공/족자/부착/열재단/보드) → _addons(거치대/우드봉 tmpl_cd) → _categories
4. 옵션/제약(round-6 L2): 가공 택일그룹(G-SL-3 미적재→GRP-SL-가공 제안)·화이트별색 조건부(투명소재시)·거치대 OPTION/TEMPLATE 분기
5. 가격(round-2 — 분석 제외): 포스터사인 면적매트릭스 t_prc_component_prices(siz_cd 치수조합) + ceiling
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.
**round-9 적재 이력:** 일반현수막(PRD_000138) CPQ 옵션 레이어 43행 라이브 COMMIT 완료(열재단 PROC_000084 mint·각목 방향옵션). 본 round-11은 그 위 도메인 정리(재적재 아님).

---

## 4. 매핑 결정 요약 (실사 — calendar/booklet과 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **소재 기반 29상품** | 소재가 상품 정체(아트패브릭=그래픽천·린넨패브릭=린넨) | MES 004-*/005-* + 소재 컬럼 |
| **면적형 사이즈 3층** | 규격 프리셋 + 비규격 연속범위 + 자유입력 (calendar 이산 사이즈와 다름) | C5/C6/C7 |
| **가격=포스터사인 매트릭스** | 비규격≠가격격자. 유효사이즈=매트릭스 셀·off-grid ceiling | [[dbmap-l2-requires-l1-price-table]]·[[dbmap-silsa-price-via-poster-sign]] |
| 화이트별색=별색공정 | C18=PROC_000008(투명/홀로그램 underbase). 도수 아님 | 07_domain §3 G-SL-2 |
| 코팅=공정 | C19=PROC 코팅(자재 아님) | Q9 실무진 확정 |
| 실사 후가공 다종 | C20=봉제/타공/족자/부착/열재단/보드 각 PROC+param | db-domain-structure D-24·b.9 |
| **가공 택일그룹 미적재** | 현수막/실사 excl_group 부재(GRP-BOOK/CAL만) → GRP-SL-가공 제안 | db-domain-structure §330 G-SL-3 |
| 폴더=생산라우팅 | C14=실사출력/특수인쇄=실사·레이저커팅=UV(아크릴스티커) | process-recipe §1 |
| 추가상품=tmpl_cd | C21 거치대/우드봉=`t_prd_templates` SKU | addon→tmpl 전환 |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-SL-1 [🟡]** 사이즈 모델 — 비규격 연속범위(C6/C7)를 입력제약(`t_prd_product_sizes` min/max)으로, 가격·유효사이즈는 포스터사인 매트릭스로 둘까(권위 분리)? round-9 일반현수막 오판 재발 방지 핵심.
- **CONFIRM-SL-2 [🟡]** 화이트별색(C18) 적용 범위 — 투명/홀로그램 전 상품에 PROC_000008 화이트 강제(도메인 필수)인가, 엑셀 명시(접착투명=단면)분만인가? G-SL-2 미적재 해소.
- **CONFIRM-SL-3 [🟡·핵심]** 실사 가공 택일그룹 — 현수막/실사 가공(열재단/재단만/각목 등)이 UI 택일이나 라이브 excl_group 부재. GRP-SL-가공 신규 제안(ddl-proposer)인가, 비택일 단순공정인가? (G-SL-3 미적재)
- **CONFIRM-SL-4 [🟡]** 거치/액자/우드봉 귀속 — 자재(부속) vs 공정(액자가공) vs 추가상품(거치대 SKU). booklet BK-3·calendar CL-5(부속 귀속)와 동류.
- **CONFIRM-SL-5 [🟡]** 본체 usage 슬롯 — 실사 낱장 단일 본체가 USAGE.01 본체인가, .07 공통인가, 실사 전용 슬롯인가?
- **CONFIRM-SL-6 [🔴]** C12 파일명약어 견적 DB 귀속(전 시트 일괄).
- **CONFIRM-SL-7 [🟡]** 아크릴스티커 인쇄방식 — 폴더=레이저커팅 → UV(PROC_000002)이 실사 시트에 묶임. 실사 아닌 UV 라우팅 확정(상품군 재분류 여부).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 25 의미 컬럼이 목표 t_* 또는 명시적 GAP/round-2(가격 제외)로 귀결.
