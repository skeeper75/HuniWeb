# 실사 — 적재 로직 진단 (loadlogic-notes · round-13 C1)

> **작성** 2026-06-11 · round-13. `tools/load_master.py`가 실사 컬럼을 t_*로 변환한 규칙을 재구성 + 발견된 적재 결함(file:line). 설명 한국어, 식별자 영어.
> **[HARD·사용자 directive] 적재원 = `data/raw/prdmaster_full_migration_v03_20260518.xlsx`(load_master.py:39).** v03은 상품마스터를 제대로 분석하지 않고 만들어져 오류가 많다 → **정답 기준 아님(피고원)**. 본 노트는 "어떻게 틀리게 적재됐나"의 진단 재구성용. 정답=상품마스터 원본 L1(`silsa-l1.csv`).
> **oracle 용도:** `sql/01a~23.sql`=스키마 구조 권위(유지) · `load_master.py`=적재 진단 · `models.py`=거울(미사용).

---

## 0. 적재 파이프라인 — **실사 원본 시트를 직접 안 읽는다 (핵심 발견)**

[HARD·근본 구조] load_master.py는 **실사 원본 시트("실사")를 읽지 않는다.** `read_sheet(wb, "10_상품정보")`·`"14_상품별자재"`·`"15_상품별공정"` 등 **번호 시트**만 읽는다(load_master.py:165·228·251·283~448). 이 번호 시트는 **v03 마이그레이션이 실사 원본을 변환해 만든 정규화 산출물**이다. 즉 적재 경로:

```
실사 원본 시트(상품마스터 260527·정답=silsa-l1.csv)
   │
   ▼  ← [v03 마이그레이션, 오류 多·사용자 directive 피고원]  ← 이 단계 코드는 우리 레포에 부재
번호 시트(10_상품정보·14_상품별자재·15_상품별공정 ... v03 산출물)
   │
   ▼  ← load_master.py (--all, surrogate 발급·FK 치환·executemany)
라이브 t_* (피고)
```

→ **실사의 도메인 컬럼(C5 사이즈·C17 소재·C19 코팅·C20 가공·C21 추가)이 라이브에 어떻게 들어갔는가 = v03 마이그레이션이 원본을 어떻게 번호 시트로 변환했는가**에 달림. load_master는 번호 시트를 충실히 옮길 뿐(그 자체는 거의 정확). **결함의 뿌리는 대부분 v03 마이그레이션(코드 부재) — load_master는 전파자.** v03 파일은 로컬에 부재(`ls` 확인) → 정당(피고원 비참조). 진단은 라이브 결과 + load_master 로직 + L1 정답 3자 대조로 재구성.

---

## 1. load_master.py 적재 규칙 재구성 (실사 관련)

| t_* 엔티티 | load_master 함수:line | 읽는 번호 시트 | 변환 규칙 | 실사 영향 |
|-----------|----------------------|----------------|-----------|-----------|
| `t_prd_products` | `load_products` 250-275 | 10_상품정보 | prd_cd identity 보존·MES_ITEM_CD **전량 NULL**(L261)·`qty_unit_typ_cd` **None 하드코딩**(L269)·nonspec_*=비규격 컬럼 | MES NULL(정답 004-*/005-* 손실)·qty_unit NULL→후속보정 |
| `t_prd_product_categories` | `load_rel_categories` 282-291 | 11_상품별카테고리 | CAT 슬러그→surrogate 치환 | **CAT_000298 실사(고아) 연결**(v03 시트11이 실사 묶음) |
| `t_cat_categories` | `load_categories` 164-178 | 01_카테고리 | 상위코드 NULL→고아(L175 조건부 UPDATE) | CAT_000298 upr=NULL(시트01에 실사 상위 미정의) |
| `t_prd_product_sizes` | `load_rel_sizes` 307-315 | 13_상품별사이즈 | SIZ 슬러그→surrogate | 이산 규격 사이즈 정확 적재(✅) |
| `t_prd_product_materials` | `load_rel_materials` 318-333 | 14_상품별자재 | MAT 치환·용도 빈→USAGE.공통(L324) | 소재명 정확·usage=USAGE.07(정당) |
| `t_mat_materials` | `load_materials` 227-247 | 05_자재정보 | `자재구분`→MAT_TYPE enum(L239)·MAT_TYP_OVERRIDE(L116) | **실사 소재 전부 MAT_TYPE.08**(v03 시트05가 .08로 평면화) |
| `t_prd_product_processes` | `load_rel_processes` 404-421 | 15_상품별공정 | PROC 치환·excl_grp 18 검증(L412) | **코팅 유광/무광만·보드가공/봉제옵션 누락**(v03 시트15 결함) |
| `t_proc_processes` | `load_processes` 210-224 | 06_공정정보 | PROC 치환·prcs_dtl_opt jsonb | 공정 마스터 정확(봉제 param·족자 param 실재) |
| `t_prd_product_plate_sizes` | `load_rel_plate_sizes` 336-349 | 17_상품별판형사이즈 | 출력용지유형 **전부 .기타**(L340·346) | output_file_typ=JPG/AI 정확·output_paper=.기타(후속 plate교정 대상) |
| `t_prd_product_addons` | `load_rel_addons` 436-444 | 20_상품별추가상품 | PRD→addon_prd_cd | **실사 부속 0행**(v03 시트20에 실사 부속 미생성) |
| `t_prd_product_sets` | `load_rel_sets` 424-433 | 19_상품셋트정보 | PRD→sub_prd_cd | **실사 세트 0행**(v03 시트19에 실사 세트 미생성) |
| `t_prd_product_print_options` | `load_rel_print_options` 352-382 | 16_상품별인쇄옵션 | 도수 치환·아크릴 DEFAULT 전개(L359) | **실사 po=0**(실사는 도수 컬럼 없음 — 정당) |

---

## 2. 발견된 적재 결함 (file:line 근거)

### L-A [High] 자재유형 단일 .08 평면화 (v03 시트05 결함, load_master 전파)
- **증상:** 실사 28상품의 모든 소재가 라이브에서 `MAT_TYPE.08 실사소재`(SELECT: 린넨·캔버스·레더·그래픽천 전부 .08).
- **정답(도메인):** 패브릭(린넨/캔버스/그래픽천)=`MAT_TYPE.05 원단`·레더=`MAT_TYPE.06 가죽`(product-bom §0·BOM 횡단 자재표).
- **원인:** `load_materials`(L227-247)는 시트05 `자재구분` 컬럼을 `enum_code("MAT_TYPE", ...)`(L239)로 변환할 뿐. **v03 시트05가 실사 소재의 자재구분을 전부 "실사"(→ENUM_ALIAS L110 "실사소재"=.08)로 채움** → 원단/가죽 구분 손실. load_master는 시트값 충실 반영(전파). MAT_TYP_OVERRIDE(L116)는 책자 전용지/레더하드커버만 보정(실사 소재 미포함).
- **근본:** v03 마이그레이션이 실사 소재의 재질 분류(원단/가죽)를 보지 않고 시트 기반 "실사소재"로 일괄. → correction C4.

### L-B [High] 코팅·보드가공·봉제옵션 — 가공 다양성 손실 (v03 시트15 결함)
- **증상:** L1 가공(C20)은 풍부(린넨패브릭 봉제 5종·폼보드 화이트/블랙보드·포맥스 3mm/5mm·족자 사각/원형·현수막 열재단/타공4/6/8/봉미싱). 라이브는 ① 코팅=유광(PROC_000014)+무광(PROC_000015) 2행·② 봉제=PROC_000080 1행(param 없음)·③ 족자=PROC_000082 1행(param 없음)·④ **보드가공 완전 부재**(폼보드/포맥스에 유광+무광 코팅만, 보드마운팅 0).
- **정답:** 각 가공이 PROC + prcs_dtl_opt param(봉제 유형/폭·족자 모양·타공 구수·보드 두께). 공정 마스터에 봉제(PROC_000080 param 유형/폭)·족자(082 param 모양)·타공(079 param 구수)·코팅(014/015 param 면) 실재 → param만 누락.
- **원인:** `load_rel_processes`(L404-421)는 시트15 행을 PROC로 치환하되 **param(prcs_dtl_opt 인스턴스) 적재 경로 없음**(스키마상 t_prd_product_processes에 param 인스턴스 컬럼 부재 — param은 마스터 prcs_dtl_opt에만). **v03 시트15가 가공 옵션을 PROC 행으로만 만들고 옵션 variant를 누락** → 라이브에 코팅 2행/봉제 1행만, 보드가공 행 자체 없음.
- **근본:** v03 마이그레이션이 가공 옵션(봉제 5종·보드 2종·족자 2종)을 단일 PROC로 축약하거나 누락. **보드 공정 마스터 자체 부재**(t_proc_processes에 "보드"·"포맥스"·"마운팅"·"스탠딩" 공정 없음 — SELECT 확인) → 표현 불가 = ddl-proposer 후보. → correction C5·C6·C8.

### L-C [High] 카테고리 고아 오연결 (v03 시트11 + load_categories 상위 NULL)
- **증상:** 28상품 전부 CAT_000298 실사(upr_cat_cd=NULL·cat_lvl=3 부모 없음 = 고아)에 연결. 정상 상품명 노드(CAT_000067~099, 포스터=CAT_000004·사인=CAT_000005 하위) 0개 연결.
- **정답:** 각 상품을 상품명 정상 노드에 연결(아트프린트포스터→CAT_000067·PET배너→CAT_000088 등, SELECT로 전수 실재 확인).
- **원인:** `load_rel_categories`(L282-291)는 시트11의 (상품코드,카테고리코드) 그대로 치환. **v03 시트11이 실사 28상품을 잉여 "실사" 카테고리(CAT_000298)에 묶음.** `load_categories`(L164-178)는 시트01 상위코드가 NULL이면 고아 생성(L175 조건부) → CAT_000298 upr=NULL. 디지털인쇄 #1 C-09(배경지 296·상품권 295)와 동형 결함.
- **근본:** v03이 시트명/구분을 카테고리로 만들고 상품을 거기 묶음(정상 트리 067~099와 별개로). → correction C1.

### L-D [Med] 부속(addon/set) 미생성 (v03 시트19/20 결함)
- **증상:** 라이브 addon=0·set=0(일반현수막 PRD_000138만 round-9 CPQ로 옵션 적재). L1엔 우드행거/우드봉/천정형고리/배너거치대(실내/실외)/큐방/끈/각목 명시(C21).
- **원인:** `load_rel_addons`(L436)·`load_rel_sets`(L424)는 시트20/19를 읽음. **v03 시트20/19에 실사 부속 행 미생성**(자유텍스트 C21이 번호 시트로 변환 안 됨). 디지털인쇄 #1 C-04/C-08(봉투 C38 자유텍스트→load_rel_addons 파싱 범위 밖)와 동형.
- **근본:** v03이 추가(C21) 자유텍스트("우드봉+면끈 포함"·"실내용배너거치대")를 별매 상품(PRD)으로 정규화하지 못함 → 시트20에 (상품,추가상품) 행 부재. → correction C7.

### L-E [Low] MES_ITEM_CD 전량 NULL (의도적, load_master.py:261)
- **증상:** 실사 28상품 MES_ITEM_CD=NULL. L1·PM엔 004-0001~005-0010 실재.
- **원인:** `load_products`(L261) `None` 하드코딩(사용자 결정 2026-06-03 — MES 7건이 14상품 중복 부분 UNIQUE 위반 회피). **의도적 비적재** — 실사에선 004-0003을 방수포스터+투명포스터★ 2상품이 공유(L1 r13·r18 확인) = 그 중복 사례. 정당하나 정답값(004-*) 손실은 finding(향후 중복정리 후 재적재). → correction C9(CORRECT-경로불명).

### L-F [Low] qty_unit_typ_cd None 하드코딩 → 라이브 QTY_UNIT.01 (경로불명)
- **증상:** load_products(L269) `None` 하드코딩(시트10에 원천 컬럼 없음). 그러나 라이브는 전부 QTY_UNIT.01(EA).
- **원인:** 라이브 .01은 **load_master 밖 후속 보정 산물**(디지털인쇄 C-15와 동형). 값 자체는 실사(낱장 단위 EA)에 정합 가능. 적재 경로 비공식 = finding. → correction C10(CORRECT-경로불명).

### L-G [Low·정정] 메쉬현수막·홀로그램·유광아크릴 수량 NULL — **L1과 정합(원본 빈값)**
- **증상:** PRD_000139(메쉬현수막)·141(홀로그램)·142(유광아크릴) min_qty/max_qty/qty_incr 전부 NULL(SELECT).
- **검증 결과(정정):** **L1 원본도 이 3상품의 제작수량(C22~24)이 빈값**(메쉬현수막·홀로그램·유광아크릴 anchor 행 최소/최대/증가 전부 공백). 미러아크릴만 L1=1/10000/1 → 라이브=1/10000/1 정합. 즉 **라이브 NULL은 L1 빈값을 충실히 반영 = CORRECT**(v03 결함 아님). 단 도메인상 동류 상품(미러아크릴 1/10000/1)과 비교하면 원본 누락 가능성 → AMBIGUOUS(실무 보완 여부). → correction C11(AMBIGUOUS, 원본 빈값).

---

## 3. 적재 경로 불명 (finding)

| 항목 | 라이브 값 | load_master 경로 | 판정 |
|------|----------|------------------|------|
| qty_unit_typ_cd | QTY_UNIT.01 | None 하드코딩(L269) | 경로 불명(후속 보정) |
| output_paper_typ_cd | .기타(전부) | .기타 무조건(L340) | 정합(실사=대형 롤·전지 무의미) |
| MES_ITEM_CD | NULL | None 의도(L261) | 정당(중복 회피)·정답값 손실 |

---

## 4. 진단 요약 (실사 결함의 뿌리)

| 결함 | 근본 원인(v03/load_master) | 영향 상품 수 | 심각도 |
|------|---------------------------|-------------|--------|
| 자재유형 .08 평면화 | v03 시트05 실사 소재 자재구분 일괄 "실사" | 28(원단 5·가죽 1 오분류) | High |
| 가공 다양성 손실 | v03 시트15 옵션 축약·보드공정 마스터 부재 | ~10(패브릭/보드/족자/현수막) | High |
| 카테고리 고아 오연결 | v03 시트11 실사 묶음 + load_categories 상위 NULL | 28(전부) | High |
| 부속 addon/set 미생성 | v03 시트19/20 실사 부속 미정규화 | ~8(액자/족자/행잉/배너/현수막) | Med |
| 수량 NULL | **L1 원본 빈값(정합·결함 아님)** | 3 | Low(AMBIGUOUS) |
| MES NULL | load_products 의도(L261) | 28 | Low(정당) |

> **핵심:** 실사 결함은 **거의 전부 v03 마이그레이션 단계**에서 발생(원본 실사의 풍부한 옵션/부속/소재유형을 번호 시트로 변환하며 손실). load_master는 충실한 전파자. **사이즈만은 v03이 정확히 변환**(이산 규격 + 비규격 nonspec 분리, round-9 우려한 연속범위 오판 없음) — 라이브 사이즈 적재는 CORRECT.
