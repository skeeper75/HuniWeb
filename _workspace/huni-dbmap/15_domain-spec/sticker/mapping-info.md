# 스티커 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정) + `_loadspec/loadspec.md`(적재방법·스티커 delta).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — 각 엑셀 값은 ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진이 정합하는 t_*로. 한 값을 잘못된 t_*에 넣지 않는다.
2. **의미축 분리 우선** — 형상≠사이즈, 코팅=자재(공정아님), 조각수=묶음+공정, 별색≠도수.
3. **앱 계산 vs DB 룩업 구분** — 판수(C6)·EA면적계산은 DB 미저장(앱 런타임).
4. **자재 권위 = parent + usage_cd** — 점착지 본체(USAGE.01).
5. **적재 순서 = 마스터(surface A) → 상품(A) → 상품하위(surface B)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (32컬럼 전수)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories`(cat_cd 스티커) | B | 시트 단일군(빈값) → 스티커 카테고리 | 🟡 |
| 2 | ID | 외부키 | (매핑 보조키) | — | prd_cd 아님. NULL 가능(변형) | 🟡 |
| 3 | MES_ITEM_CD | MES코드 | `t_prd_products.mes_item_cd` | A | 002- prefix 원형 보존(D-05) | ✅ |
| 4 | 상품명 | 상품정체 | `t_prd_products.prd_nm` | A | 멱등 키. 반칼/완칼=커팅 정체 | ✅ |
| 5 | 사이즈(필수) | 재단치수(+형상) | `t_siz_sizes.cut_*` + `t_prd_product_sizes`; **형상형은 prcs_dtl_opt로 재귀속** | A→B | 규격/자유=size. **`원형 NNmm (NEA)`=형상+EA → 공정**(합판도무송 G-SK-2) | 🟡 |
| 6 | 판수 | 판걸이수 | **미저장(앱 계산)** | — | 가격공식 분모 | ✅ |
| 7 | 블리드 | 재단여유 | `t_siz_sizes.margin_*`(도출) | A | 0mm 다수(반칼 후지) | 🟡 |
| 8 | 작업사이즈 | 작업치수 | `t_siz_sizes.work_*` | A | 같은 siz_cd 행 | ✅ |
| 9 | 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*` | A | C5 mm 본문 → 한 siz_cd | ✅ |
| 10 | 출력용지규격 | 출력판형 | `t_prd_product_plate_sizes.output_paper_typ_cd` + `t_siz_sizes`(impos=Y) | A→B | "330x470"→OUTPUT_PAPER_TYPE | ✅ |
| 11 | 파일명약어 | 생산메타 | **GAP**(note/견적밖) | — | 커팅정체 단서(반칼/완칼/규격). ddl-proposer 검토 | 🔴 |
| 12 | 출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ` | B | PDF(W)=화이트교차·AI(칼선)=커팅교차·JPG=전사 | 🟡 |
| 13 | 폴더 | 인쇄방식/라우팅 | **GAP**(생산메타); 인쇄방식은 **공정 root로 도출**(PROC_000004/006/합판/전사) | — | 5 인쇄방식 분기 → 공정 백본 게이팅 단서 | 🟡 |
| 14 | 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | Y | ✅ |
| 15 | 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | Y | ✅ |
| 16 | 종이(필수) | 자재(점착지) | `t_mat_materials`(MAT_TYPE.11) + `t_prd_product_materials`(usage=본체) | A→B | **코팅=자재 variant**(무광/유광코팅스티커). 평량/표면=mat_nm | ✅ |
| 17 | 인쇄 | 도수 | `t_prd_product_print_options.print_side`=단면 + back_colrcnt=0 | B | 스티커=단면 단일 | ✅ |
| 18 | 별색>화이트 | 공정(별색) | `t_proc_processes`(PROC_000008) + `t_prd_product_processes` + prcs_dtl_opt(면) | A→B | print_side 아님. 투명/홀로그램 **도메인 필수** | ✅ |
| 19~22 | 별색>클리어/핑크/금/은 | 공정(별색) | (스티커 미사용 — 빈값) | — | 화이트만 활성 | ✅ |
| 23 | 코팅 | (자재 흡수) | **C16 자재로 귀속**(별 공정 아님) | — | C23 빈값. 무광/유광코팅스티커=자재 | ✅ |
| 24 | 커팅 | 공정+형상+EA | `t_proc_processes`(PROC_000054 반칼·053 완칼·055 스티커완칼) + prcs_dtl_opt(모양·조각수) | A→B | **형상 enum=prcs_dtl_opt.모양 권위**(size 재배치 금지). ★사이즈선택=캐스케이드 constraint_json | 🟡 |
| 25 | 조각수 | 묶음수+공정param | ① `t_prd_product_bundle_qtys`(bdl_qty) + ② prcs_dtl_opt.조각수 | A→B | **이중 귀속**(후니 결정 benchmark §3). *최대N=상한·★최소크기=면적제약 | 🟡 |
| 26 | 최소 | 수량하한 | `t_prd_products.min_qty` | A | 사이즈/조각수 종속→대표값 | ✅ |
| 27 | 최대 | 수량상한 | `t_prd_products.max_qty` | A | 타투/소량=1000 | ✅ |
| 28 | 증가 | 수량step | `t_prd_products.qty_incr` | A | 판걸이수 배수 | ✅ |
| 29~30 | 가변(텍스트/이미지) | 공정(VDP) | (스티커 미사용 — 빈값) | — | 없음 | ✅ |
| 31~32 | 추가상품/추가가격 | 추가상품/가격 | (스티커 미사용 — 빈값) | — | 봉투 등 없음 | ✅ |

> **가격공식:** 스티커 시트엔 가격공식 컬럼 부재 → `06_extract/price-gangpan-sticker-l1.csv` + round-2 트랙(별도).

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합)

```
1. 마스터(surface A 선적재):
   t_cod_base_codes(MAT_TYPE.11·OUTPUT_PAPER_TYPE·QTY_UNIT 등)
   → t_siz_sizes(규격/자유/형상치수) → t_mat_materials(점착지 12)
   → t_proc_processes(PROC_000008 화이트·053 완칼·054 반칼·055 스티커완칼)
   → t_clr_color_counts
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 16상품
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes → _plate_sizes → _materials(usage=본체)
   → _print_options(단면) → _processes(화이트별색/반칼/완칼커팅)
   → _bundle_qtys(조각수) → _categories
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.

---

## 4. 매핑 결정 요약 (스티커 — 디지털인쇄와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| 코팅→자재 | C23 빈값. 무광/유광코팅스티커=자재 variant(공정 아님) | 엑셀 실측·07_domain MAT_TYPE.11 |
| 커팅→공정 핵심 | C24를 PROC_53/54/55 + prcs_dtl_opt(모양·조각수)로 | 07_domain·benchmark §2 |
| 형상=prcs_dtl_opt 권위 | 도형 enum은 공정 param, size 축 재배치 금지 | benchmark §2 권고1 |
| 조각수 이중 귀속 | C25=bundle_qty + prcs_dtl_opt.조각수(+위젯표시) | benchmark §3 후니 결정 |
| 화이트 별색만 | C18→PROC_000008(투명/홀로그램 필수), 19~22 미사용 | entity-semantic-model §3-2·G-SK-1 |
| 인쇄방식 5분기 | C13 폴더 → 공정 root(PROC_004/006/합판/전사) 게이팅 | process-recipe-tree §1 |
| ★사이즈선택 캐스케이드 | 규격사이즈→형상EA 종속 → constraint_json/JSONLogic | round-6 CPQ |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-ST-1 [🟡·HIGH]** 합판도무송 형상 37종의 **size vs 공정 귀속** — 라이브가 size로 적재(round-10 escalate). 형상=prcs_dtl_opt 권위 원칙과 충돌. size행 운명(유지 vs 공정 재귀속) 결정.
- **CONFIRM-ST-2 [🟡]** 조각수(C25) 이중 귀속 — bundle_qty와 prcs_dtl_opt.조각수 동시 적재 vs 택1.
- **CONFIRM-ST-3 [🟡]** 코팅 자재 흡수 확정 — 무광/유광코팅스티커를 별 mat_cd로 둘지(현 5종) 코팅 공정으로 분리할지.
- **CONFIRM-ST-4 [🟡]** 인쇄방식(C13 폴더) DB 귀속 — 견적밖 메타 vs 공정 root 명시.
- **CONFIRM-ST-5 [🔴]** C11 파일명약어 귀속(note/견적밖/신규컬럼).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 32컬럼이 목표 t_* 또는 명시적 GAP/미저장으로 귀결.
