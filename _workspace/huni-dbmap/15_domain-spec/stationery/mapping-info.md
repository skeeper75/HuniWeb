# 문구(가격포함) — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·제본) + `_loadspec-delta.md`(적재방법·문구 delta).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.
> **가격:** 가격포함 시트(C29)=round-2 고정가형(가격값 분석은 round-2 트랙, 매핑 경로만 명시). 떡메모지=`*가격표참고`.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **문구 = 책자類 이중블록** — 내지(USAGE.01)/표지(USAGE.02)/면지(USAGE.03)/투명커버(USAGE.05) 분리. booklet 패턴 그대로 적용.
3. **의미축 분리** — 표지사양(C25)=`아트250+무광코팅`=자재(표지지)+공정(코팅) 복합 분해·제본옵션(C27)=링컬러 vs 면지 분기·내지(옵션 C13)≠종이(C14).
4. **제본 enum→공정** — C28 제본사양 텍스트를 PROC_000017 자식으로 변환 + GRP-BOOK-제본 택일그룹. "옵션값" 오적재 금지.
5. **page_rule vs 묶음수 vs 장수 3축** — 먼슬리 page_rule(28 고정)·떡메모 page(장수3)·떡메모 묶음수(50/100장1권=bundle). 혼동 금지.
6. **생산방식** — B 셋트(하드커버)=표지 sub_prd + parent usage 권위·A 통합(먼슬리/스프링/중철)=parent·단순(소프트/먼슬리)=미싱.
7. **적재 순서 = 마스터(A) → 상품(A) → 상품하위(B) → 옵션/제약(round-6) → 가격(round-2 고정가) → 구간할인(round-1)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (37 의미 컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories` | B | 플래너/노트 2그룹. R29 범례 제외 | ✅ |
| 2 | ID | 외부키 | (보조키) | — | prd_cd 아님. 전 행 14592 동일 | 🟡 |
| 3 | MES_ITEM_CD | MES | `t_prd_products.mes_item_cd` | A | 008-*(문구 라인) | ✅ |
| 4 | 상품명 | 상품정체(커버타입 인코딩) | `t_prd_products.prd_nm` | A | 멱등 키. 만년다이어리 4 커버타입(ST2-2) | ✅ |
| 5 | 사이즈(필수) | 재단치수 | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | A→B | 고정 규격(실사 면적형 아님). 다이어리 130x190 4종 동일 | ✅ |
| 6 | 내지파일사양 MES | MES(내지) | (내지 sub_prd MES/생산메타) | B | 대부분 빈값(B 셋트 아님) | 🟡 |
| 7 | 내지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(내지) | A | 2(먼슬리/떡메모). work−cut 도출 | 🟡 |
| 8 | 내지 작업사이즈 | 작업치수(내지) | `t_siz_sizes.work_*`(내지) | A | 먼슬리150x216·떡메모94x94/74x124 | ✅ |
| 9 | 내지 재단사이즈 | 재단치수(내지) | `t_siz_sizes.cut_*`(내지) | A | C5 정합 | ✅ |
| 10 | 내지 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖(ST2-6) | 🔴 |
| 11 | 내지 출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ`(내지) | B | PDF | 🟡 |
| 12 | 내지 폴더 | **인쇄방식/라우팅** | (GAP); 공정 root 도출 | — | 디지털인쇄(먼슬리/떡메모) | 🟡 |
| 13 | 내지(옵션) | **자재/옵션(내지유형)** | `t_prd_product_materials`(내지) 또는 옵션 | B | **무지내지=무지 옵션.** C14 종이와 구분(디자인유형 vs 재질) | 🟡 |
| 14 | 종이(옵션) | **자재(내지종이)** | `t_mat_materials` + `t_prd_product_materials`(usage_cd=USAGE.01) | A→B | 백모조100/120. 회색폰트=미노출 파일사양 | ✅ |
| 15 | 내지인쇄사양 | **인쇄면 도수(내지)** | `t_prd_product_print_options.print_side`(내지) | B | 양면(먼슬리)·단면(메모/떡메모) | ✅ |
| 16 | 페이지사양 최소 | page_rule | `t_prd_product_page_rules.page_min` | B | 먼슬리28·떡메모3 | ✅ |
| 17 | 페이지사양 최대 | page_rule | `t_prd_product_page_rules.page_max` | B | 먼슬리28(min=max 고정)·떡메모3 | ✅ |
| 18 | 페이지사양 증가 | page_rule | `t_prd_product_page_rules.page_incr` | B | **먼슬리0(고정28P)·떡메모3(장수).** 무지내지=빈값(page 무의미) | ✅ |
| 19 | 표지파일사양 MES | MES(표지) | (표지 sub_prd MES) | B | 만년다이어리소프트=006-5005(별 표지라인) | 🟡 |
| 20 | 표지 블리드 | 재단여유 | `t_siz_sizes.margin_*`(표지) | A | 대부분 빈값 | 🟡 |
| 21 | 표지 작업사이즈 | 작업치수(표지) | `t_siz_sizes.work_*`(표지) | A | **하드커버=책등 펼침**(426x303). _work_size 앵커 | 🟡 |
| 22 | 표지 파일명약어 | 생산메타 | **GAP/note** | — | `_cover`. 견적밖(ST2-6) | 🔴 |
| 23 | 표지 출력파일 | 파일포맷 | `output_file_typ`(표지) | B | PDF(먼슬리) | 🟡 |
| 24 | 표지 폴더 | **인쇄방식/라우팅** | (GAP); 공정 root 도출 | — | **레더=특수인쇄**·일반=디지털인쇄 | 🟡 |
| 25 | 표지사양 | **자재+공정(표지지+코팅 복합)** | `t_mat_materials`(usage_cd=USAGE.02) + `t_proc_processes`(코팅) | A→B | **[핵심] `아트250+무광코팅` 분해 필수**(자재+코팅). 레더=MAT_TYPE.06 가죽·`하드커버(면지?)`=하드보드 | 🟡 |
| 26 | 표지인쇄사양 | 인쇄면 도수(표지) | `print_side`(표지) | B | 단면(주력) | ✅ |
| 27 | 제본옵션(옵션) | **자재/param(링컬러) + 면지** | prcs_dtl_opt(링컬러) 또는 자재(링/면지) | B | **두 의미:** 트윈링 `실버링`(링)·하드커버 `하드커버(면지?)`(면지 USAGE.03). 분기(ST2-3) | 🟡 |
| 28 | 제본사양 | **공정(제본)+택일** | `t_proc_processes`(PROC_000017 자식) + `t_prd_product_processes`(mand=Y) + `t_prd_process_excl_groups`(GRP-BOOK-제본) | A→B | **enum→공정 변환.** 트윈링제본=PROC_000021(방향 좌철/상철)·중철·떡·하드커버. 떡메모=묶음수(50/100장1권→`t_prd_product_bundle_qtys`) | ✅ |
| 29 | 가격 | **가격(고정가형)** | `t_prd_product_prices` / `t_prc_*`(round-2 고정가) | A | **가격포함=round-2 고정가형.** 떡메모=`*가격표참고`(묶음수×size 매트릭스). 가격값 분석은 round-2 | 🟡 |
| 30 | 제작수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1·3·4(수첩/중철=4) | ✅ |
| 31 | 제작수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 500(다이어리)·1000(노트류) | ✅ |
| 32 | 제작수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1·3·4 | ✅ |
| 33 | 주문방법 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | Y | ✅ |
| 34 | 주문방법 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | **노트류=에디터 Y**·다이어리/떡메모=업로드만 | ✅ |
| 35 | 개별포장(옵션) | **공정(포장)** | `t_proc_processes`(포장/수축) + `t_prd_product_processes` | A→B | 개별포장없음/수축포장. 레시피 말단 | 🟡 |
| 36 | 구간할인적용테이블 | **구간할인 연결** | `t_dsc_*`(round-1) → 상품 연결 | B | **문구 구간할인**(round-1, dbmap-discount-authority) | ✅ |
| 37 | COMMENT | 메타 | (GAP/note) | — | 오렌지=개발무시. `*합지보드`/`*PVC커버`=BOM 힌트 | 🔴 |

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(MAT_TYPE.01 종이/.06 가죽(레더)/.07 부속(실버링·합지보드·하드보드)·
                    PROC_000017 제본(트윈링021/중철/떡/하드커버)·PROC_000013 코팅(무광015)·
                    USAGE.01 내지/.02 표지/.03 면지/.05 투명커버·QTY_UNIT.03 권·SEL_TYPE.01)
   → t_siz_sizes(130x190·A5·A6·90x90·70x120 등 재단·작업, 내지/표지 슬롯)
   → t_mat_materials(백모조100/120·아트250·레더(화이트)·면지(화이트/블랙/그레이)·
                     실버링·합지보드·하드보드·PVC커버)
   → t_proc_processes(트윈링제본·중철제본·떡제본·하드커버제본·무광코팅·부착·포장)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 11 상품(노트류 editor_yn=Y)
   (메모패드내지커스텀=준비중 보류·만년다이어리 4종 커버타입 ST2-2)
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes(고정 규격) → _materials(내지 usage.01·표지 usage.02·면지 usage.03·투명커버 usage.05)
   → _print_options(단/양면, 내지/표지) → _plate_sizes(출력파일 PDF)
   → _processes(제본 PROC_000017 자식·코팅·포장) → _page_rules(먼슬리 28 고정·떡메모 3)
   → _bundle_qtys(떡메모 50/100장1권 QTY_UNIT.03) → _categories
4. 옵션/제약(round-6 L2): 제본 택일(GRP-BOOK-제본)·링컬러(실버링)·면지 캐스케이드·무지내지 옵션
5. 가격(round-2 고정가): t_prd_product_prices(C29 inline 9000·4500…)·떡메모=가격표참고 매트릭스
6. 구간할인(round-1): t_dsc_* 문구 구간할인 → 상품 연결(C36)
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.
**round-9 적재 이력:** 문구류는 구간할인(round-1 t_dsc_*)에 일부 매핑됨(메모리 dbmap-discount-authority). 본 round-11은 도메인 정리(재적재 아님).

---

## 4. 매핑 결정 요약 (문구 — booklet/silsa와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **책자類 이중블록 적용** | 내지(.01)/표지(.02)/면지(.03)/투명커버(.05) usage 분리. booklet 패턴 | entity-semantic §4·USAGE §196 |
| **가격포함(C29) = round-2 고정가** | inline 9000·4500… 고정가형. 떡메모=가격표참고(묶음×size) | 포토북/캘린더 패턴·round-2 |
| **표지사양 복합 분해** | `아트250+무광코팅`=자재(USAGE.02)+코팅 공정 | entity-semantic §23·G-PB-3 동형 |
| **제본옵션 두 의미 분기** | C27 트윈링→링컬러(실버링)·하드커버→면지(USAGE.03) | 제본방식별 의미 차이(ST2-3) |
| **page_rule/묶음수/장수 3축** | 먼슬리 page(28 고정)·떡메모 page(장수3)·떡메모 묶음수(권) | entity-semantic §28·§138 |
| 제본 enum=공정+택일 | C28→PROC_000017 자식(트윈링021)·GRP-BOOK-제본 | 07_domain §5·db-structure §219 |
| 미싱제본(빈 제본컬럼) | 만년다이어리 소프트/레더소프트·먼슬리=미싱(약결합) | COMMENT `*출력+미싱`(ST2-5) |
| 만년다이어리 커버타입 | 소프트/하드/레더하드/레더소프트=4 prd or 1+variant | C4·ST2-2(booklet 별상품 vs 포토북 variant) |
| 박/형압 없음 | booklet C28~30(박)에 해당 컬럼 부재(문구=박 미운영) | 엑셀 실측(컬럼 부재) |
| 구간할인(C36) | 문구 구간할인 round-1 연결 | dbmap-discount-authority |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-ST2-1 [🟡]** 레더(C25 표지소재) 자재유형 — MAT_TYPE.06 가죽으로 등록? 색상(화이트)=variant? (booklet BK-4·포토북 PB-3·실사 SL 일괄)
- **CONFIRM-ST2-2 [🟡·핵심]** 만년다이어리 커버타입 4종 — 소프트/하드/레더하드/레더소프트=별 prd_cd 4상품인가, 1상품+표지타입 variant(USAGE.06)인가? (booklet=별상품·포토북=variant 갈림. 130x190 동일 size·MES 008-0020~0023 별 코드=별상품 시사)
- **CONFIRM-ST2-3 [🟡]** 제본옵션(C27) 분기 — 트윈링 `실버링`(링컬러 param/자재) vs 하드커버 `하드커버(면지?)`(면지 USAGE.03). 둘 다 다른 t_* 귀속. 링=부속 자재(MAT_TYPE.07)인가 제본 param인가? (booklet BK-3 동류)
- **CONFIRM-ST2-4 [🟡]** 떡메모지 3축 — page(C16~18 = 3장)·묶음수(C28 = 50/100장1권)·가격표(가격표참고)가 어떻게 결합? page=장수 단위·묶음수=권 단위·가격=묶음×size 매트릭스 정합 확인.
- **CONFIRM-ST2-5 [🟡]** 미싱제본(제본 빈값) — 만년다이어리 소프트/레더소프트·먼슬리는 제본 컬럼 빈값(COMMENT `*출력+미싱`). 미싱제본을 PROC_000017 자식으로 신규 등록? 또는 무선/중철 변형? (제본 enum 8종에 미싱 부재)
- **CONFIRM-ST2-6 [🔴]** C10/C22 파일명약어 · C37 COMMENT — 견적 DB 귀속? (전 시트 일괄: 디지털 DP-2·스티커 ST-5·책자 BK-6·실사 SL-6)
- **CONFIRM-ST2-7 [🟡]** 떡메모지 가격(`*가격표참고`) — 별도 가격표(묶음수×size)가 round-2 어디에 적재되나? inline 고정가(다른 상품)와 다른 처리.
- **CONFIRM-ST2-8 [🟡]** 합지보드·PVC커버·하드보드 자재 등록 — COMMENT 힌트(`*합지보드`/`*PVC커버`)의 부속/표지판 소재를 MAT_TYPE.07 부속으로 등록? 표지(USAGE.02) 결합인가 별 부속인가?

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 37 의미 컬럼이 목표 t_* 또는 명시적 GAP/round-1/round-2로 귀결.
