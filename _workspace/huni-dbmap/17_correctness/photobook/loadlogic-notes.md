# 포토북 — 적재 로직 재구성 (loadlogic-notes, round-13 C1)

> **작성** 2026-06-11 · round-13. `raw/webadmin/tools/load_master.py` + `raw/webadmin/sql/`를 읽어, 포토북 엑셀 칼럼이 어떤 변환을 거쳐 t_*에 적재됐는지를 **재구성**. 이것이 라이브 현재 상태의 설명이자 결함의 원인.
>
> **[HARD] v03 directive 적용:** `load_master.py`는 `data/raw/prdmaster_full_migration_v03_20260518.xlsx`(line 39)를 읽는다 = **사용자가 경고한 피고원**(상품마스터 미분석 오류 多). 본 감사는 v03를 **정답으로 참조하지 않는다**(레포에 파일도 부재 확인). load_master는 **순수 전파기**로 보고, 진원은 상류 v03 정규화, 정답은 상품마스터 L1(`06_extract/photobook-l1.csv`).
>
> **[HARD] models.py 제외:** `catalog/models.py`는 inspectdb 거울(managed=False). 적재 로직 아님. 인용 안 함.

---

## 0. 적재 파이프라인 골격 (load_master.py)

`run_all()`(L492) = 단일 트랜잭션: **seed(GROUP.NN 재적재) → masters(surrogate 발급) → relations(FK 치환)**. 멱등성=대상 테이블 TRUNCATE 후 재삽입(L22). 포토북 관련 테이블 전부 이 경로.

- **마스터 surrogate 발급**(`issue` L152): 엑셀 슬러그 → `<PREFIX>_NNNNNN` 순차(엑셀 행순). 상품(PRD)만 identity=True(엑셀이 이미 PRD_NNNNNN, L252).
- **enum 해석**(`enum_code` L130): `(group, label)` → `<group>.<NN>`. seed cod_nm 기준. 미매핑 → NULL + INSPECTION 로그.
- **FK 치환**: 관계 로더가 `MAPS[key][slug]`로 surrogate 참조 치환.

---

## 1. 포토북 칼럼별 적재 규칙 재구성 (실제 코드 경로)

| 엑셀 칼럼(L1) | load_master 함수:라인 | 변환 규칙 | 목표 t_* | 결함 여부 |
|---------------|----------------------|-----------|----------|:--:|
| 구분=포토북 | `load_rel_categories` L282 | 11_상품별카테고리 시트 → cat_cd FK 치환 | `t_prd_product_categories` | ✅ |
| 상품명 | `load_products` L250 | 10_상품정보, prd_cd identity 보존, prd_typ=`enum_code(PRD_TYPE, bcd_label(상품유형코드))` | `t_prd_products.prd_nm/prd_typ_cd` | ✅ |
| MES_ITEM_CD | `load_products` L261 | **전량 NULL 강제**(주석: 원천 MES 7건이 14상품 중복→부분 UNIQUE 위반) | `MES_ITEM_CD` | ✅ 정합(견적밖) |
| qty_unit_typ_cd | `load_products` L269 | **NULL 강제**(주석: 시트10에 원천 컬럼 없음) | `t_prd_products.qty_unit_typ_cd` | ⚠ 라이브엔 QTY_UNIT.03 존재(별도 세션 backfill 추정 — 적재경로 불명) |
| 사이즈(필수) | `load_rel_sizes` L307 | 13_상품별사이즈 → siz_cd FK 치환 | `t_prd_product_sizes` | ✅ |
| 내지종이/표지종이/면지 | `load_rel_materials` L318 | 14_상품별자재 → mat_cd FK 치환, **usage=`enum_code(USAGE, 용도 or '공통')`** | `t_prd_product_materials` | ⚠ 자재유형 오염(§2) |
| 내지인쇄/표지인쇄 | `load_rel_print_options` L352 | 16_상품별인쇄옵션, opt_id=상품별 순번(L361~362), print_side 보존, 도수=CLR FK | `t_prd_product_print_options` | ✅ |
| 제본사양_제본 | `load_rel_processes` L404 | 15_상품별공정 → proc_cd FK, mand=`_yn(필수공정여부)` | `t_prd_product_processes` | ⚠ mand=N(§3) |
| 내지페이지 | `load_rel_page_rules` L447 | 21_상품별페이지룰 → min/max/incr | `t_prd_product_page_rules` | ⚠ 표지타입별 차등 미반영(§4) |
| 표지타입 sub_prd | `load_rel_sets` L424 | 19_상품셋트정보 → sub_prd_cd FK, note=용도 | `t_prd_product_sets` | ✅ |
| 가격_기본/추가 | **(없음)** | **load_master에 가격 적재 함수 없음** | `t_prd_product_prices` 등 | ❌ 적재경로 부재(§5) |
| 표지 작업사이즈(펼침) | `load_rel_sizes`는 13시트만 — 표지 펼침 siz는 별 시트/미연결 | siz 마스터엔 발급되나 상품 연결 없음 | `t_prd_product_sizes`(표지) | ⚠ 미연결(§6) |

---

## 2. 결함 ① 자재유형 오염 — 레더 3-way 혼재 (가장 위험)

### 2.1 적재 로직 원인 재구성

`load_materials`(L227)는 자재유형을 다음으로 결정한다:

```
mat_typ_cd = enum_code("MAT_TYPE", MAT_TYP_OVERRIDE[자재코드])  if 자재코드 in MAT_TYP_OVERRIDE
           else enum_code("MAT_TYPE", r["자재구분"], ref=자재코드)        # (L237~239)
```

`MAT_TYP_OVERRIDE`(L116~121)는 **4개 슬러그만** 가죽/종이로 강제:
```python
"MAT.하드커버전용지+무광코팅": "종이",
"MAT.레더하드커버 A":  "가죽",
"MAT.레더하드커버 A4": "가죽",
"MAT.레더하드커버 A5": "가죽",
```

### 2.2 라이브 실측이 드러낸 모순 (Q6 재현)

`mat_nm LIKE '%레더%'` 전수 + 연결수:

| mat_cd | mat_nm | mat_typ_cd | 연결수 | override 대상? |
|--------|--------|-----------|:--:|:--:|
| MAT_000006 | 레더하드커버 | **.01 종이** | **1 (PRD_000100)** | ✗ (override 슬러그 "레더하드커버 A/A4/A5"와 불일치 — "A" 접미 없음) |
| MAT_000008 | 레더 | .06 가죽 | 0 (고아) | ✗ |
| MAT_000173 | 레더하드커버 A | .06 가죽 | 0 (고아) | ✓ override→가죽 |
| MAT_000174 | 레더하드커버 A5 | .06 가죽 | 0 (고아) | ✓ |
| MAT_000175 | 레더하드커버 A4 | .06 가죽 | 0 (고아) | ✓ |
| MAT_000186 | 레더(화이트) | **.08 실사소재** | **6 (PRD_000100 포함)** | ✗ (자재구분 원천이 "실사" → ENUM_ALIAS "실사소재") |

**근본원인:** override는 `레더하드커버 A/A4/A5`(173/174/175)를 가죽으로 올바로 분류했으나, **포토북 14_상품별자재 시트는 그 행을 연결하지 않고** 다른 두 행을 연결한다:
- `MAT_000006 레더하드커버`(접미 "A" 없음) → override **미적용** → `자재구분` 원천값을 그대로 받아 **.01 종이**로 적재.
- `MAT_000186 레더(화이트)` → 원천 자재구분="실사" → ENUM_ALIAS(L111) "실사" → "실사소재" → **.08 실사소재**.

즉 **override가 교정한 가죽행(.06)은 고아로 남고, 상품이 실제 연결한 두 행은 .01·.08로 잘못 분류**됐다. v03 상류에서 "레더하드커버"와 "레더하드커버 A"가 **중복 슬러그**로 갈라진 것이 진원(v03 정규화 결함 — directive 정합). load_master는 그 갈라진 슬러그를 충실히 전파했을 뿐.

**[F-PB-2 보정] 교정 방향 = 연결행 mat_typ만.** 포토북이 연결한 MAT_000006(note "포토북 표지 자재")·MAT_000186은 **이미 포토북 전용 연결행**이고 틀린 건 자재유형뿐(.01·.08→.06) → `UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.06'`(prd_cd 재연결 아님). **고아 .06 행(008/173~175)은 포토북용 아님**(note "책자 표지 자재"·"IMPORT base root") — 이름만 정합으로 끌어오면 책자 자재를 잘못 가져옴(끌어오기 금지).

→ **MIS-LOADED(자재유형).** schema-design-intent line 453(Q4: 레더도 자재 등록·용도=표지) + MAT_TYPE.06 가죽 기대 위반.

---

## 3. 결함 ② PUR 제본 mand_proc_yn=N

`load_rel_processes`(L416)는 `_yn(r["필수공정여부"])`로 mand를 적재. 라이브 PRD_000100 PROC_000020 mand=N(Q8c). v03의 15_상품별공정 시트에서 포토북 PUR의 `필수공정여부`가 빈값/N으로 들어온 것 = 전파 결과.

→ 제본은 **본질적 필수 공정**(포토북은 PUR 단일·택일 불요). 정답=mand=Y. **MIS-LOADED(공정 필수성).** 단 round-12가 이미 식별(CONFLICT-PB-4).

---

## 4. 결함 ③ page_rule — 소프트/레더 엑셀 공란 (GAP) **[F-PB-1 보정]**

`load_rel_page_rules`(L447)는 21시트의 단일 행(min/max/incr)만 적재 → 라이브 24/150/2. **엑셀 L1 직접 파싱 결과: page 값은 하드커버 행(row_seq 3/6/9/12)에만 24/150/2 존재, 레더하드커버·소프트커버 행(4/5/7/8/10/11/14)은 전부 공란.** `grep "4~14"`=0건.

→ **AMBIGUOUS/GAP(MISSING 아님).** 라이브 24/150/2는 "load_master가 소프트 4~14를 빠뜨림"이 아니라 **엑셀에 소프트/레더 page 값 자체가 없음**(공란). 라이브는 엑셀 유일 page 행(하드)을 prd 단위 1행으로 충실 적재 — **오적재 아님**. 종전 "소프트 4~14"는 `product-bom.md` 추정을 엑셀 권위로 오인용(삭제). 소프트/레더 page 정책=엑셀 미규정 → 실무진 확인 필요. 심각도 Low.

---

## 5. 결함 ④ 가격 적재경로 부재

`load_master.py`에 **가격 적재 함수가 전혀 없다**(MASTERS L461·RELATIONS L469 목록에 가격 없음). 포토북은 "가격포함" 시트(C37 base 24P + C38 per-page 2P당)인데 load_master는 사양만 적재하고 **가격은 별도 트랙(round-2 dbm-price-formula)** 책임.

라이브 실측(Q11): `t_prd_product_prices`·`t_prd_product_price_formulas` 모두 **0행**. 디지털인쇄·실사 등은 round-6/7에서 일부 가격 적재됐으나 **포토북은 가격 적재가 한 번도 실행 안 됨**.

→ **MISSING(가격 전체).** 적재경로 = round-2 가격엔진. 단 **round-14 경고:** Phase11(sql 20~23)이 가격 스키마를 바꿈 — `t_prd_template_prices`(SKU 직접단가) 신설·`t_prc_component_prices`에 proc_cd/opt_cd 차원 추가·`PRICE_TYPE`(단가형/합가형) 신설. round-12 mapping-final이 가리킨 `t_prd_product_prices`는 **고정가형 직접단가**용으로 여전히 유효(설계의도 line 409: 포토북=고정가형 `t_prd_product_prices`). 단 SKU(템플릿)별 단가가 필요하면 `t_prd_template_prices`가 더 적합 — 적재 시 결정 필요(§correction-manifest PB-PRICE).

---

## 6. 결함 ⑤ 표지 펼침 작업사이즈 미연결

표지 작업사이즈(460x235 등, 책등 포함 펼침)는 siz 마스터에 **실재**(Q12: SIZ_000272/273/277/278/279/280/281 — work만 있고 cut 비어있음·impos_yn=N). 그러나 `t_prd_product_sizes`엔 완성품 4종만 연결(표지 펼침 siz 0행).

→ 표지 펼침 siz = **생산 작업지시용**(고객 선택 size 아님). 상품 미연결이 **정상일 수 있음**(견적 미노출). 단 sub_prd(표지 반제품)에 귀속하거나 생산메타로 명시 안 됨 = 적재경로 불명의 일종. 심각도 Low(AMBIGUOUS).

---

## 7. 정상 적재 확인 (CORRECT — 결함 아님)

- **카테고리 고아 없음**: PRD_000100→CAT_000108(상위 CAT_000006 정상). 디지털인쇄 family의 043~046 고아 같은 결함 **부재**.
- **반제품 빈 껍데기**: 101~107 전부 9속성 0행 = 설계의도 line 360 정합(자재 권위=parent+usage_cd). **결함 아님**.
- **sets 7행·note 용도 라벨**: 정합. B 셋트 구조 충실.
- **print_options 양/단면**: opt1 양면(CMYK4/CMYK4)·opt2 단면(CMYK4/인쇄안함) = 내지양면·표지단면 정합. `ACRYLIC` 전개(L357~359)는 옵션ID가 DEFAULT 아니라 **포토북엔 미적용**(아크릴 전용 — 포토북은 정상 도수 경로).
- **sizes cut=work·impos_yn=N**: 완성품 정사이즈 정합.

---

## 8. 적재 로직 결함 결산

| # | 결함 | load_master 원인 | 진원 | 분류 |
|---|------|------------------|------|------|
| 1 | 레더 자재유형 혼재(.01/.08, .06 고아) | override 슬러그 불일치(L116~121) + ENUM_ALIAS 실사(L111) | v03 중복 슬러그 정규화 | MIS-LOADED |
| 2 | PUR mand=N | `_yn(필수공정여부)` 충실 전파(L416) | v03 15시트 필수여부 빈값 | MIS-LOADED |
| 3 | 소프트/레더 page 정책 미규정 | 21시트 prd당 1행만(L447)·라이브 하드 충실 적재 | **엑셀 공란**(소프트/레더 page 값 부재·"4~14"는 추정 오인용) | **AMBIGUOUS/GAP**(F-PB-1·오적재 아님) |
| 4 | 가격 전체 미적재 | load_master에 가격 함수 부재 | round-2 미실행 | MISSING |
| 5 | 표지 펼침 siz 미연결 | 13시트 외 표지 siz 연결 경로 없음 | 설계상 생산용 | AMBIGUOUS |
| 6 | 무광코팅 자재 평면화+중복 | 자재명 그대로 전파(L236) | v03 복합표기·중복 슬러그(250/260/172) | MIS-LOADED |
