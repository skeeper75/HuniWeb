# 아크릴 — 데이터 매핑 정보 (round-11 통합 산출)

> **작성** 2026-06-10 · round-11. **컬럼 도메인 사전 × 상품 BOM × 적재명세**를 한 표로 통합 — "무엇을(엑셀) → 어디에(t_*) → 어떻게(적재방법)"를 확정. `schema-design-intent-map.md`와 실제 매핑의 직접 입력.
>
> **입력:** `column-dictionary.md`(의미) + `product-bom.md`(자재/공정·가공) + `_loadspec-delta.md`(적재방법·아크릴 delta) + `08_remediation/acrylic.md`(round-3 라이브 권위 G-AC-1~9).
> **권위:** 후니 PDF > 07_domain KB > 표준. 추정 0.
> **DB 적재 없음** — 매핑 정보 정리 전용. 실 적재는 round-4/5/6 + 인간 승인.
> **⚠️ [작업 지시] 가격 3컬럼(H/V/X) 값 매핑 분석 제외** — 도메인 의미·목표 t_*만 정의, 값 매핑=아크릴 가격표(round-2).

---

## 1. 핵심 매핑 원칙 (round-9 교훈 — 기계적 매핑 금지)

1. **삼중 바인딩으로 귀속 결정** — ① UI 컴포넌트 ② 생산 자재/공정 BOM·MES ③ 가격엔진 정합 t_*.
2. **아크릴 고유 축 인식** — **UV 단일 인쇄방식**(PROC_000002)·**두께=자재**(G-AC-3)·**UV변형≠print_side**(G-AC-5)·**가공=부속자재+부착공정 2축**(G-AC-3/4)·**조각수=묶음+공정param**(G-AC-2)·**완칼 묵시 필수**(G-AC-1).
3. **의미축 분리** — 인쇄사양(C18)=UV변형 공정(도수 아님)·두께(C17)=별 mat_cd(192 일괄 금지)·가공(C20)=자재+공정 양분·형상부기(C5)=완칼 모양.
4. **완칼 over-reach 방지** — 판아크릴(161)·입체코롯토(168)·입체블럭(169)은 단순 판/입체라 **완칼 자동 적용 금지**(round-3 보정 이력). 형상 굿즈에만 완칼.
5. **생산방식** — C 완제품/단일(낱장 굿즈, +조합형 조각수 variant). 자재 권위=parent 본체 usage. 인쇄방식=UV(폴더 UV인쇄/루아샵 둘 다 UV).
6. **마스터는 건전, 연결만 결손** — round-3 라이브: t_mat(두께 042/043/044·부속 045~057)·t_proc(완칼 053·부착 081·UV 002) 마스터 전부 존재. **상품 연결 테이블만 적재/교정**(FK 안전).
7. **적재 순서 = 마스터(A) → 상품(A) → 상품하위(B) → 옵션/제약(round-6) → 가격(round-2)** — FK 위상정렬.

---

## 2. 컬럼 → t_* 매핑 표 (39 데이터 컬럼 전수, 가격 3컬럼 도메인만)

| C | 엑셀 컬럼 | 의미축 | → t_* 엔티티.컬럼 | surface | 변환/매핑 노트 | 확정 |
|---|----------|--------|-------------------|:--:|----------------|:--:|
| 1 | 구분 | 생산구조(단/조합형) | (조각수 활성 신호) / `t_prd_product_categories` | B | 조합형=조각수 활성. 단품형=1조각 | ✅ |
| 2 | ID | 외부키 | (보조키) | — | prd_cd 아님. ★/입체류 NULL | 🟡 |
| 3 | MES_ITEM_CD | MES | `t_prd_products.mes_item_cd` | A | 009-* 원형. 쉐이커/지비츠★ 미부여 | ✅ |
| 4 | 상품명 | **상품정체** | `t_prd_products.prd_nm` | A | 멱등 키(PRD_000146~169). ★=신규 | ✅ |
| 5 | 사이즈(필수) | 재단치수+형상부기+입력모드 | `t_siz_sizes.cut_*` + `t_prd_product_sizes`; **형상부기→완칼 모양** | A→B | 규격mm+사용자입력. **원형/사각/하트/자물쇠=완칼 모양 param** | 🟡 |
| 6 | 비규격 가로 | 비규격 가로범위 | `t_prd_products.nonspec_width_min/max` / size 입력제약 | A | **연속범위=입력한계.** round-3 라이브 nonspec 전무(G-AC-6) | 🟡 |
| 7 | 비규격 세로 | 비규격 세로범위 | `t_prd_products.nonspec_height_min/max` / size 입력제약 | A | 가로×세로 입력한계 | 🟡 |
| H | 가격 | (가격) | **(도메인만)** `t_prc_*` 고정가형(round-2) | (round-2) | 사이즈×수량 단가표. 값=아크릴 가격표 | ⛔ |
| 8 | 파일사양 블리드 | 재단여유 | `t_siz_sizes.margin_*` | A | 유효0 보존. 작업−재단=블리드 도출(Q14) | 🟡 |
| 9 | 파일사양 작업사이즈 | 작업치수 | `t_siz_sizes.work_*` | A | 작업>재단(커팅여유). 코롯토류 공백=외주 미정의 | ✅ |
| 10 | 파일사양 재단사이즈 | 재단치수 | `t_siz_sizes.cut_*` | A | C5 정합 | ✅ |
| 11 | 파일사양 출력용지규격 | 출력판형(숨김·빈값) | `t_prd_product_plate_sizes.output_paper_typ_cd` | B | **UV 평판=전지규격 무의미**(숨김열·빈값) | 🟡 |
| 12 | 파일사양 파일명약어 | 생산메타 | **GAP/note** | — | 견적밖(AC-9). 그레이/오렌지=개발 무시 안내 | 🔴 |
| 13 | 파일사양 출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ` | B | PDF=인쇄·*AI(칼선)=레이저커팅 라인 | 🟡 |
| 14 | 파일사양 폴더 | **인쇄방식(UV)/라우팅** | (GAP); 인쇄방식=**PROC_000002 UV 도출** | — | UV인쇄(직생)·루아샵(외주) 둘 다 UV | 🟡 |
| 15 | 주문방법 업로드 | 주문채널 | `t_prd_products.file_upload_yn` | A | Y(업로드 주력) | ✅ |
| 16 | 주문방법 편집기 | 주문채널 | `t_prd_products.editor_yn` | A | 카라비너=Y | ✅ |
| 17 | 소재(필수) | **자재(아크릴+두께)** | `t_mat_materials`(MAT_TYPE.03, 042/043/044) + `t_prd_product_materials`(usage=본체) | A→B | **[HARD] 두께=별 mat_cd.** round-3: 192 일괄=두께소실(G-AC-3). 코롯토8mm→044·미니파츠1.5mm→042 교정 | ✅ |
| 18 | 인쇄사양 | **UV변형(공정 param)** | `t_prd_product_processes`(PROC_000002 UV) + prcs_dtl_opt `변형` | A→B | **[HARD] print_side 아님.** round-3: print_side 오적재(G-AC-5). 배면양면/풀빼다/투명테두리/단면=UV 변형 | ✅ |
| 19 | 조각수(옵션) | **묶음수+완칼 조각수 param** | ① `t_prd_product_bundle_qtys`(bdl_qty) + ② prcs_dtl_opt.조각수(완칼 053/055) | A→B | **이중 귀속(Q8).** 조합형만(2~10조각). round-3: process 0행(G-AC-2) | 🟡 |
| 20 | 가공(옵션) 가공 | **부속자재(MAT_TYPE.07)+부착공정(PROC_000081) 2축** | ① `t_mat_materials`(.07 부속 045~057)+`t_prd_product_materials`(usage 부속) ② `t_proc_processes`(PROC_000081)+`t_prd_product_processes`+prcs_dtl_opt `대상` | A→B | **[HARD] 2축 동시(Q5).** round-3: 맥세이프(부착)만 1행(G-AC-3/4). 볼펜색/파츠=variant 분기 컨펌 | 🟡 |
| V | 가공 가격 | (가격) | **(도메인만)** round-6/가격표 | (round-2/6) | *가격표참고=노이즈 배제 | ⛔ |
| 21 | 추가상품 추가상품 | **추가상품**(addon) | `t_prd_product_addons`(tmpl_cd) + `t_prd_templates`; 라이브 PRD_000006 볼체인 | B | 키링/포카키링. round-3: 1행만(9색 미반영 G-AC-7) | 🟡 |
| X | 추가상품 추가가격 | (가격) | **(도메인만)** template/가격표 | (round-2/6) | 볼체인 색상별 추가가 | ⛔ |
| 22 | 수량 최소 | 수량하한 | `t_prd_products.min_qty` | A | 1 | ✅ |
| 23 | 수량 최대 | 수량상한 | `t_prd_products.max_qty` | A | 10000 | ✅ |
| 24 | 수량 증가 | 수량step | `t_prd_products.qty_incr` | A | 1 | ✅ |
| 25 | COMMENT | 실무메타 | (GAP/note) | — | 레이어창 셀메타·범례 footnote 보존 | 🟡 |

---

## 3. 적재 순서 (FK 위상정렬 — round-4 정합)

```
1. 마스터(surface A 선적재 — round-3 라이브 확인: 전부 존재, 교정만):
   t_cod_base_codes(MAT_TYPE.03 아크릴/.07 부속·PROC_000002 UV·USAGE.01 본체·SEL_TYPE)
   → t_siz_sizes(규격 mm 재단·작업·형상부기)
   → t_mat_materials(아크릴 두께 042/043/044·골드/실버 195/196·부속 045~057 — 전부 존재)
   → t_proc_processes(UV 002·완칼 053·스티커완칼 055·부착 081 — 전부 존재)
2. 상품(surface A):
   t_prd_products (prd_cd 채번/멱등 by prd_nm) — 25상품 (라이브 23등록·쉐이커/지비츠★ 미등록 G-AC-8)
   prd_typ_cd=.04 디자인. nonspec(사용자입력 11상품) 범위 적재(G-AC-6)
3. 상품 하위(surface B 인라인):
   t_prd_product_sizes(규격+형상부기) → _materials(본체 두께 교정 + 부속 다행)
   → _processes(UV변형 002·완칼 053·조각수 055·부착 081) → _print_options(실제 단/양면 정정)
   → _bundle_qtys(조각수 조합형) → _plate_sizes(출력판형·빈값) → _addons(볼체인 PRD_000006) → _categories
4. 옵션/제약(round-6 L2): UV변형 택1·가공(부속) 캐스케이드·조각수 조건부(조합형)·볼체인 색상 variant
5. 가격(round-2 — 값 매핑): 아크릴 가격표 t_prc_*(고정가형 사이즈×수량) + 가공/추가 추가가
```

**채번/멱등:** PK 자동채번(PREFIX+max+1), 멱등 키=이름(`prd_nm`/`mat_nm`/`proc_nm`) (round-9 D1~D5). 감사컬럼 비입력.
**round-3 적재 이력:** 아크릴 23상품 등록(PRD_000146~169)·마스터 건전. **결함=상품 연결 결손**(완칼/조각수/부속/UV변형 미연결·두께 192 일괄). 본 round-11=그 위 도메인 정리(재적재 아님, 교정 방향 명세).

---

## 4. 매핑 결정 요약 (아크릴 — 스티커/실사와 다른 점)

| 결정 | 내용 | 근거 |
|------|------|------|
| **UV 단일 인쇄방식** | 폴더 UV인쇄/루아샵 둘 다 UV(PROC_000002). 스티커 5분기와 정반대 | process-recipe §1·Case10~12 |
| **두께=자재 식별자** | 1.5/3/8/10mm = 별 mat_cd(042/043/044). 192 일괄 금지 | entity-semantic §2 두께 variant·G-AC-3 |
| **인쇄사양=UV변형(공정)** | C18=PROC_000002 `변형`(배면양면/풀빼다/투명테두리). print_side 아님 | 07_domain §3·G-AC-5 |
| **가공=부속자재+부착공정 2축** | C20=MAT_TYPE.07 부속 + PROC_000081 부착. 둘 다(Q5) | entity-semantic §4·G-AC-3/4 |
| **조각수=묶음수+공정param** | C19=bundle_qty + prcs_dtl_opt.조각수(완칼). 조합형만(Q8) | benchmark §4 후니 결정·G-AC-2 |
| **완칼 묵시 필수(형상 굿즈)** | PROC_000053 die-cut. 단 판아크릴/입체류 over-reach 금지(161/168/169) | process-recipe §116·G-AC-1·round-3 보정 |
| **형상부기=완칼 모양** | C5 원형/사각/하트/자물쇠 → 완칼 `모양` param | 스티커 G-SK-2 유사(아크릴=완칼) |
| **볼체인=addon** | C21 볼체인 9색 PRD_000006. 9색=variant vs 9 addon 컨펌 | entity-semantic §9·G-AC-7 |
| **택일그룹 없음=정상** | 아크릴 process_excl_group 0행(GRP-BOOK/CAL만). UV변형은 택1이나 별 그룹 불요 | db-structure §220·round-3 라이브 |

---

## 5. 매핑 차질 방지 — 잔존 컨펌(인간 결정 대기)

`domain-research-notes.md` 참조. 핵심:
- **CONFIRM-AC-1 [🟡·핵심]** 완칼(die-cut) 모델링 — 아크릴 절단을 PROC_000053 완칼 공정으로 적재(G-AC-1)할지, 사이즈/가격에 내포해 공정행 없이 갈지? **단 판아크릴(161)·입체코롯토(168)·입체블럭(169)은 완칼 over-reach 제외**(단순 판/입체).
- **CONFIRM-AC-2 [🟡·핵심]** 두께 자재 — 1.5/3/8mm를 별 mat_cd(042/043/044)로 교정할지, 192 단일+두께 속성축으로 둘지? 코롯토(8mm)·미니파츠(1.5mm) 현재 192 오매핑(G-AC-3).
- **CONFIRM-AC-3 [🟡·핵심]** 가공 부속 귀속 — 자석/핀/고리/집게/끈을 자재(MAT_TYPE.07 부속) vs 부착공정(PROC_000081) vs 둘 다? **Q5 운영원칙(컬럼옵션 확인 후 귀속)**. 볼펜색/바디/파츠는 본체색/디자인 variant 분기.
- **CONFIRM-AC-4 [🟡]** 인쇄사양 UV변형 적재 위치 — 현재 print_side 오적재(G-AC-5). PROC_000002 `변형` param으로 옮기고 print_side는 실제 단/양면 정정할지? 인쇄방식 272 전상품 미연결 글로벌 갭과 연동.
- **CONFIRM-AC-5 [🟡]** 조각수 이중 귀속 — bundle_qty + prcs_dtl_opt.조각수 동시 적재 vs 택1(Q8: 묶음수=권/세트 기준 + 판당개수 제한 둘 다 결정). 조합형 자유형스탠드 2~6·미니파츠 10.
- **CONFIRM-AC-6 [🟡]** 볼체인 9색 — addon 1상품(볼체인) 색상 variant인지 9 addon인지? round-3 라이브 1행만(G-AC-7).
- **CONFIRM-AC-7 [🟡]** nonspec 범위 — `사용자입력` 11상품의 비규격 가로/세로 범위(C6/C7)를 nonspec_*_min/max에 적재할지(G-AC-6 라이브 전무)? 가격(round-2 고정가/면적)과 연동.
- **CONFIRM-AC-8 [🟡]** ★신규 상품 등록 — 쉐이커★·지비츠★(라이브 미등록·MES 미부여) 출시 예정 등록인지 영구 보류인지(G-AC-8)? 입체코롯토/입체블럭(168/169)은 라이브 등록됨.
- **CONFIRM-AC-9 [🔴]** C12 파일명약어 견적 DB 귀속(전 시트 일괄 DP-2·ST-5·BK-6·PB-6·CL-6·SL-6과 동일).

이 외 컬럼은 매핑 경로 확정(✅/🟡 도출). **애매모호 0 달성** — 모든 39 데이터 컬럼이 목표 t_* 또는 명시적 GAP/round-2(가격 도메인만)로 귀결.
