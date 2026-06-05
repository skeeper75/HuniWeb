# booklet 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/booklet.md` ⑤의 R1~R6을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> **메서드:** digital-print 파일럿(`09_load/digital-print/`) 구조·자기검증 게이트를 booklet에 동일 적용.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/booklet-l1.csv`) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`,
> stale 2026-06-04 주의) · IMPORT 매트릭스(`06_extract/import-paper-matrix-long.csv` +
> `seoljeong-import-map.csv` + `04_audit/import-resolution-resolved.csv`). 추정 0 — 모든 행은
> L1 셀 또는 ref/IMPORT 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1(use_yn=N/미출시=비활성)·C-3(IMPORT ●=실자재)·C-4(qty_unit 책자→권)·
> C-6(부속 맥락별)·C-7·C-8(variant 관리용이성) binding 적용.

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_materials.csv` | t_prd_product_materials | R1 내지/표지 IMPORT 종이 (active) | **83** |
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R2 형압 양각/음각 자식 (active) | **4** |
| `t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R6 qty_unit=권 일괄 | **11** |
| `_deferred/t_prd_product_materials_deferred.csv` | (보류) | PUR/하드커버/바인더 내지 미해소 (B1 잔여) | 6 |
| `page-rule-noise-flag.csv` | (flag) | R4 떡메모지 page_rule 잡음 — 삭제 단정 금지 | 1 |

생성기 `gen_load.py`(재현 가능) · 검증 `verify_expected.py`(게이트 PASS, exit 0).

---

## 1. booklet 도메인 토대 — 생산방식 A통합/B셋트 (자재 권위 = parent + usage_cd)

booklet 11 parent는 두 생산구조로 갈린다(`07_domain/entity-semantic-model.md` §4·`process-recipe-tree.md` §4):

- **A 통합상품**(068 중철·069 무선·070 PUR·071 트윈링): 내지/표지가 반제품 분해 안 됨 →
  **parent 한 상품에 `usage_cd`(.01 내지/.02 표지)로 슬롯 구분 직접 적재**. sets=0행이 **정상**(G-BK-6, false MISSING 철회).
- **B 셋트상품**(072·077·082·088·094·100): 표지/면지가 반제품 sub_prd로 분해(빈 껍데기, sets로 연결). 단
  **자재 권위는 여전히 parent + usage_cd**(sub_prd 9속성 0행은 정상, parent usage_cd 0행이 결함).

> **HARD:** sub_prd(073~107)에서 자재를 찾으면 전량 MISSING 오판. 자재 권위 위치 = **parent + usage_cd** (라이브 권위반전).
> digital-print는 낱장 단일슬롯 USAGE.07이었으나, **booklet은 내지(.01)/표지(.02)를 반드시 구분**한다.

**use_yn:** booklet 11 parent **전부 use_yn=Y**(ref-products.csv 교차확인 완료). → **use_yn=N 비활성 분리 대상 없음**.
`_deferred/`는 비활성이 아니라 **자재소스 미확정(B1 잔여)** 사유의 보류다(C-1 비활성 분리와 구분).

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`)·sets는 건전(라이브) → **상품 연결 테이블만** 적재.

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 독립(선/후 무관)
② size                                — n/a (booklet 사이즈 기적재=정상, 본 범위 외)
③ material (R1)                       — IMPORT 내지/표지 usage_cd 선행. FK: prd_cd→t_prd_products, mat_cd→t_mat
④ process (R2)                        — 형압 자식. FK: prd_cd→t_prd_products, proc_cd→t_proc(051·052 upr=050)
   excl_group                         — n/a (제본 GRP-BOOK-제본 기적재=정상, 재적재 금지)
⑤ page_rule (R4)                      — booklet은 유효하나 097은 잡음 flag만(삭제 단정 금지). 신규 적재 0
⑥ addon                               — n/a (booklet addon 전무=정상, L1 추가상품 신호 없음)
```

**no-op 단계와 사유:**
- **excl_group 재적재 금지**: 제본 택일그룹(GRP-BOOK-제본 10 parent)은 **라이브 정상 적재 확인**(booklet.md 머리말 4). 결함 아님.
- **size 본 범위 외**: booklet size 기적재(068=2·071=4 등, ref 확인). 본 패스는 R1/R2/R4/R6에 집중.
- **page_rule 신규 적재 0**: booklet page_rule은 10 parent 전부 기적재(068=4/28/4 등). 미적재 결함 **없음**(booklet.md 머리말 3).
  R4는 097 잡음 **제거 검토**일 뿐 — **삭제 단정 금지**(flag만, §3-R4).
- **addon 전무 = 정상**: L1 booklet 추가상품 신호 없음(digital-print 봉투류와 달리 책자 addon 부재).

material을 process보다 먼저 둔다(FK 독립이나, 내지/표지 자재가 옵션 캐스케이드의 1차 데이터원).

---

## 3. R-카테고리별 적재 설계

### R1 (High) — 내지/표지종이 IMPORT 자재 [material 83행]

**도메인 근거(R-MAT-2/4, C-3 binding, G-BK-1/2):** 엑셀 내지종이·표지종이 `*별도설정`은 빈값이 아니라
가격표 `출력소재(IMPORT)`에 종이가 별도 정의됨의 포인터. 원적재가 이를 제외해 **8상품 내지종이 + 4상품 표지종이 전량 누락**.

**변환 로직 (IMPORT → DB):**
| 단계 | 입력 | 출력 |
|------|------|------|
| 1 | IMPORT 매트릭스 `product_col`+`mark=●` | 상품·슬롯별 ●종이 리스트 |
| 2 | `paper_name`("백색모조지 120g") → `t_mat.mat_nm` 정확매치 | `mat_cd`(MAT_000073) |
| 3 | `seoljeong-import-map` 슬롯(내지/표지) → `usage_cd`(USAGE.01/.02) | usage 슬롯 |
| 4 | (prd_cd, mat_cd, usage_cd, dflt_yn, disp_seq) | t_prd_product_materials 행 |

- `usage_cd` — **내지=USAGE.01 / 표지=USAGE.02**(digital-print는 .07 공통이었으나 booklet은 슬롯 분리 HARD).
  근거: `seoljeong-import-map.csv` slot 컬럼(`내지종이(필수)`/`표지종이(필수)`) + 기존 정상 적재(094 엽서북 USAGE.01내지/.02표지) 컨벤션 정합.
- `dflt_yn = Y`(각 (prd_cd,usage_cd) 슬롯의 disp_seq 1), 나머지 N. `disp_seq` 슬롯별 1부터 증가.
- `dep_proc_cd` 공란(종이 자재는 공정 의존 없음 — 094/097/100 기존 적재 동일 컨벤션).

**IMPORT 커버리지 (booklet 11상품, 내지/표지 자재 슬롯):**
| prd_cd | 상품 | 내지(.01) IMPORT | 표지(.02) IMPORT | active 행 | 해소 |
|--------|------|------------------|------------------|:---------:|:----:|
| 068 중철책자 | 통합상품 | 중철내지 13 | 중철표지 13 | **26** | ✅ |
| 069 무선책자 | 통합상품 | 무선내지 7 | 무선표지 6 | **13** | ✅ |
| 071 트윈링책자 | 통합상품 | 트윈링내지 16 | 트윈링표지 28 | **44** | ✅ |
| **070 PUR책자** | 통합상품 | **IMPORT 컬럼 부재** | **IMPORT 컬럼 부재** | 0 | ❌ **미해소(B1)** |
| **072 하드커버** | 셋트 | **IMPORT 컬럼 부재** | 전용지 **기적재** | 0 | ❌ **내지 미해소(B1)** |
| **077 레더하드** | 셋트 | **IMPORT 컬럼 부재** | 레더 **기적재** | 0 | ❌ **내지 미해소(B1)** |
| **082 하드링** | 셋트 | **IMPORT 컬럼 부재** | 전용지 **기적재** | 0 | ❌ **내지 미해소(B1)** |
| **088 레더바인더** | 셋트 | **L1 빈값 + IMPORT 부재** | 레더 **기적재** | 0 | ❌ **내지 미해소(B1·G-BK-4)** |
| 094 엽서북 | 셋트 | 몽블랑240 **기적재** | 스노우300 **기적재** | 0 | (정상, 적재 불요) |
| 097 떡메모지 | 떡제본 | 백모조120 **기적재** | (표지 없음) | 0 | (정상) |
| 100 포토북 | 셋트 | 몽블랑130 **기적재** | 5종 **기적재** | 0 | (정상) |

- **매칭 품질:** 13+13+7+6+16+28 = **83행, exact 매치 100%**(fuzzy 0, unmatched 0). 추정·날조 없음(자동 대조로 입증, §verify).
- **중복 PK 0:** 068·069 자재 0행(stale ref), 071 자재=링3(.07)+투명커버2(.05)뿐(.01/.02 0행). → 내지/표지 적재 시 충돌 없음.
- **PUR·하드커버·바인더(070·072·077·082·088) 내지 미해소(B1 잔여):** IMPORT 매트릭스에 해당 상품 내지컬럼 부재
  (`seoljeong-import-map` matched=0). → **추정으로 종이 리스트 발명 금지**. `_deferred/`에 6행 보류 + 컨펌(D-BK-1).
  하드커버류 표지(전용지/레더)는 이미 적재돼 표지 누락 없음.

> **provenance 예:** `IMPORT:중철내지● 백색모조지 120g→MAT_000073 (R1 G-BK-1/2 내지 usage_cd=USAGE.01, seoljeong-import-map)`

---

### R2 (Medium, 컨펌) — 형압 양각/음각 자식 공정 [process active 4행]

**도메인 근거(R-PROC-4, G-BK-3):** L1 무선책자(069)·PUR책자(070) 표지 `박/형압가공`에
**`형압(양각)`·`형압(음각)` 신호**(L1 rows 16·17·30·31). → 자식 leaf PROC_000051(양각)·052(음각) 기대.
라이브는 069·070 박색상 자식(037~044) 8종은 적재됐으나 **형압(051·052)만 누락**(MISSING 4건).

**변환 로직 (L1 → DB):**
| L1 박/형압가공 값 | 기대 proc_cd | proc_nm | upr_proc_cd |
|-------------------|:------------:|---------|:-----------:|
| `형압(양각)` | PROC_000051 | 형압(양각) | PROC_000050 |
| `형압(음각)` | PROC_000052 | 형압(음각) | PROC_000050 |

- **`크기` param(★30x30~170x170)은 마스터(`ref-processes`)가 보유** — 051·052 = `{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}`.
  `t_prd_product_processes` 스키마는 `prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt`(param 컬럼 없음).
  → 상품 연결행은 **proc_cd FK만** 적재, 크기 param은 마스터에서 자동 상속(L1 크기값 `★최소 30x30/최대 170x170`이 마스터 param과 정합).
- `mand_proc_yn = N`(선택 후가공), `excl_grp_cd` 공란(형압은 제본 택일그룹과 무관), `disp_seq` 51·52(박색상 037~044 이후 시각분리).
- **부모 050 미적재**(자식 leaf 규칙, digital-print R2 형압명함과 동일 컨벤션). 박색상 자식 037~044는 기적재(EXTRA 아님, 재적재 금지).

> **provenance 예:** `L1:무선책자 박/형압가공=형압(양각) → PROC_000051(upr=PROC_000050, 크기 param 마스터상속) (R2 G-BK-3)`

> **설계결정 D-BK-2(컨펌):** 069·070 형압(양각/음각)이 **실출시 옵션인가, 의도된 미적재인가**?
> 박색상 8종은 적재됐는데 형압만 누락 — L1 신호는 양쪽 모두 존재(박칼라+형압). 적재 전 실출시 여부 확인 권고.

---

### R4 (Medium) — 떡메모지(097) page_rule 잡음 [flag 1행, 적재 변경 없음]

**도메인 근거(G-BK-5, process-recipe-tree §3-2):** 떡제본은 **묶음수(권) 도메인**이지 페이지 도메인 아님.
떡메모지(097) bundle_qty=2행(50장1권·100장1권 QTY_UNIT.03) 기적재. 엑셀 떡메모지는 **내지페이지 컬럼 자체가 없다**.

**stale/라이브 충돌(중요):**
- **라이브 보고(booklet.md G-BK-5):** 097 page_rule = 3/3/3 (page_min/max/incr).
- **stale ref(`ref-product-page-rules.csv`, 2026-06-04):** 097 행 **부재**(존재 행은 PRD_000182=3/3/3 별개 상품).
- → 097 page_rule이 *지금 무엇으로 적재돼 있는가*는 stale=부재 / 라이브=3/3/3로 갈려 **단정 불가**.

**처리:** `page-rule-noise-flag.csv`에 **flag 1행만** 기재. **삭제 단정 금지**(과업 지시 HARD).
- verdict = "MISMATCH/잡음 의심"(떡제본 page 무의미).
- action = "라이브 097 page_rule 실재 재확인 후 제거 여부 컨펌(D-BK-4)".
- **page_rule load CSV 미생성**(신규 적재 0). 097은 page가 아닌 묶음수 도메인이라 추가할 page 행 없음.

> **추가 잡음(G-BK-5 후단):** 라이브가 097 자재 백모조120을 USAGE.01(내지)+USAGE.07(공통) 2행 중복 적재했다고 보고.
> 단 **stale ref는 097 = USAGE.01 1행만**(USAGE.07 부재). → stale/라이브 충돌. usage 단일화 여부도 **삭제 단정 금지**,
> D-BK-4에 함께 컨펌(적재 직전 라이브 재확인).

---

### R6 (Medium) — qty_unit 일괄 부여 [UPDATE 11행]

- **C-4 binding:** "상품군별 기본 일괄 부여". **책자 → QTY_UNIT.03(권)**.
- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  `t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.03), use_yn, provenance`.
- **대상:** booklet 11 parent(068~100) 전건. 라이브 현재 전건 NULL(글로벌 갭 G-BK-7).
- **떡메모지(097) 정합:** 097 bundle_qty가 이미 권(50/100장1권) 단위 → qty_unit=권(QTY_UNIT.03)이 도메인 정합.
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품 — booklet 한정 아님. 본 set은 booklet 11건만.
  전사 정책은 상품군별 매핑표(낱장=매/책자=권/굿즈=EA) 별도 일괄(C-4) — 본 패스 범위 밖.

---

### R3·R5 — false/CONFIRM (적재 변경 없음)

- **R3 (G-BK-4) 레더바인더(088) 제본/excl/page 전무**: 엑셀 제본칸 **공백**(L1 row 55) — D링 결착식이라 전통 제본공정
  부재 가능. **단순 MISSING 단정 금지**(엑셀 원천도 공백). → 제본공정·excl_group·page_rule 적재 여부 **CONFIRM(D-BK-3)**.
  내지종이 미해소는 `_deferred/`에 포함(B1).
- **R5 (G-BK-6) 통합상품 068~071 sets 0행**: **정상**(통합상품, 반제품 분해 안 함). false MISSING 철회. **적재 변경 없음.**
- **삭제 절대 금지:** 본 패스는 누락 행 추가(material 83·process 4)와 UPDATE(qty_unit 11)만 — 어떤 행도 삭제 제안하지 않음.
  097 page 잡음·백모조120 usage 중복도 flag만(EXTRA 삭제 단정 금지 HARD).

---

## 4. 캐스케이드 제약 (booklet — grounded shape 없음)

- benchmark §9 권고 = 자재/사이즈→공정 disable 캐스케이드 제약. **booklet L1 전수 점검 결과 grounded disable 신호 없음**:
  - digital-print는 코팅 셀 주석 "180g이상 코팅가능"(자재 평량→코팅 disable)이 실재했으나,
  - **booklet 표지코팅/투명커버 컬럼엔 평량 조건 주석 없음**(L1 cell_meta 점검). 박/형압·면지도 disable 신호 없음.
- → **shape도 rows도 제시 안 함**(발명 금지). booklet은 캐스케이드 제약 적재 대상 아님(no-op, 사유 명기).
  제본 택일그룹(excl_group)은 이미 기적재된 SEL_TYPE.01 단일 택일로, disable 캐스케이드와 별개 메커니즘.

---

## 5. 적재 행 요약 (active vs 보류/flag)

| R | 결함 | 대상 테이블 | active 적재 | 보류/flag | 사유 |
|---|------|------------|:----------:|:---------:|------|
| R1 | 내지/표지 IMPORT 자재 | t_prd_product_materials | **83** | 070·072·077·082·088 내지 6(deferred) | IMPORT 컬럼 부재(B1 잔여) |
| R2 | 형압 양각/음각 | t_prd_product_processes | **4** | — | (069·070 각 2, 컨펌 D-BK-2) |
| R4 | 떡메모지 page 잡음 | (flag) | 0(변경없음) | 097 page 1(flag) | stale/라이브 충돌·삭제 단정 금지 |
| R6 | qty_unit | t_prd_products(UPDATE) | **11** | — | — |
| R3 | 레더바인더 제본/룰 | — | 0(CONFIRM) | (D-BK-3) | 엑셀 원천 공백 |
| R5 | 통합상품 sets | — | 0(정정만) | — | 정상 MATCH |
| 신설 | 캐스케이드 제약 | — | 0(no-op) | — | grounded 신호 없음 |

- **active 적재 합계: material 83 + process 4 + qtyunit UPDATE 11 = 98행**(material+process INSERT 87, qty_unit UPDATE 11).
- **보류/flag 합계: deferred material 6 + page-rule flag 1 = 7.**

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-BK-1** | PUR·하드커버·바인더 내지종이 자재소스 | 미해소·`_deferred` 6행 | 070·072·077·082·088 내지는 IMPORT 상품컬럼 부재. 자재 권위 소스는?(IMPORT "하드커버전용" 대분류? 별도 종이리스트? 통합 내지세트 공유?) — **B1 잔여 최우선** |
| **D-BK-2** | 069·070 형압 실출시 | active 적재(4행) | 박색상 8종은 적재됐는데 형압(양각/음각)만 누락. 의도된 미적재인가, 실출시 옵션 누락인가? |
| **D-BK-3** | 레더바인더(088) 제본/excl/page | 미처리(CONFIRM) | D링 결착식이라 제본공정 불필요한가, 적재 누락인가?(엑셀 제본칸도 공백) |
| **D-BK-4** | 떡메모지(097) page 잡음 + 백모조120 usage 중복 | flag만(삭제 안 함) | 라이브 097 page_rule 3/3/3 실재하나? 떡제본 page 무의미 → 제거? 백모조120 .01/.07 중복 단일화? |
| **D-BK-5** | 통합상품 4종(068~071) 향후 sub_prd 분해 | parent-적재 모델(현 라이브) | 내지/표지를 parent usage_cd로 적재하는 현 모델 유지인가, 향후 반제품 sub_prd 신설 분해인가? |
| **D-BK-6** | qty_unit 책자=권 | UPDATE(11건 QTY_UNIT.03) | 책자 기본 단위 권(QTY_UNIT.03) 확정? 포토북(100)·엽서북(094)도 권인가 세트인가? |
| **D-BK-7** | 보류상품 `링바인더 (보류중)`(ID 14598) | 미등록 정상(EXTRA 아님) | 라이브 미등록 — 보류 유지인가 등록 예정인가? |

> **D-BK-1은 최우선** — PUR·하드커버 5상품 내지종이 자재소스 미확정 시 책자 위젯 종이옵션·가격 산정 불가.
> **D-BK-4·D-BK-1 일부는 라이브 SELECT로 즉시 해소 가능**(적재 직전 라이브 export로 verify 재실행 시 자동 검출).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 자재/공정 기적재 판정에 사용.
- **판정이 stale에 의존하는 지점:**
  1. **097 page_rule + 백모조120 usage 중복**(R4) — stale ref=097 page 부재 / 라이브=3/3/3 보고. **충돌** → flag만(삭제 단정 금지).
  2. **069·070 형압 미적재**(R2) — stale ref-product-processes가 069·070에 051·052 부재 표시. 라이브 다르면(이미 적재면) 중복 PK.
  3. **068·069·071 내지/표지 자재 0행**(R1 중복 PK 회피) — stale 기준 충돌 없음. 라이브가 일부 적재면 부분 중복 가능.
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0**"(자기검증 PASS, `expected-vs-load.md`).
