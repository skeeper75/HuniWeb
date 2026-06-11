# 스티커 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/sticker/` 5종(product-identity·loadlogic-notes·extraction-plan·live-diff·correction-manifest).
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 SELECT) 동반. 발견 결함은 라우팅만(산출물 직접 수정 금지). NEVER COMMIT/DDL/DELETE.
> **권위:** oracle 인용 실재성 = `raw/webadmin/` 소스 Read 검증. 라이브 값 = 독립 read-only psql 재현(`.env.local` `RAILWAY_DB_*`·비번 비노출).

---

## 0. 최종 판정: **GO**

스티커 16상품 정합 교정 산출이 견고하다. 정체(K0)는 round-11 BOM에서 이미 확정된 일반 인쇄물 스티커 단일 카테고리이고 라이브 16상품 전수 적재가 독립 재현으로 확인됐다(정체 오분류 0). oracle 인용 전건 실존·내용 일치(K2), 적재로직 원인이 v03 정규화 결함 vs load_master 코드 결정으로 정직 분리됐고(K3), 라이브 실측 13개 표본이 전건 독립 SELECT로 동일 재현됐다(K4). 교정 매니페스트는 비파괴·search-before-mint 준수(K5), 오모델 정합(별색=PROC·판수=앱·형상=size 경계·자재=parent+usage)이 마스터 스키마로 뒷받침된다(K6). **2-pass dodge-hunt 3종(분류 정반대·카운트 과대·재연결 오매핑) 전건 통과 — 실결함 미적발.** 적재 트랙 진입 안전(컨펌 5건 인간 승인 대기·DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ PASS | 16상품 전수 PRD_TYPE.04 디자인상품 라이브 재현·정체 오분류 0(전 16상품 일반 인쇄물 스티커, 비전형 0)·타투 924→L1 16상품·154행 정정 입증 |
| **K1** 추출규칙 커버리지 | ✅ PASS | 16상품 × 5속성축 + 스티커 고유축(인쇄방식5·커팅·형상·조각수·화이트·코팅) 전수, N/A 사유 명기, 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ PASS | load_master 표본 11건(39/227/236-239/261/269/282-291/294-304/307/318/336-349/352-382/404-421)·sql 3건(05_seed 190/258·01b:123)·intent-map 3건(351/442/485) 전건 실존·내용 일치 |
| **K3** 적재로직 근거 | ✅ PASS | 결함 8건 원인이 v03 정규화 5(코팅·조각수·063화이트·카테고리·자재유형/명) vs load_master 코드 1(MES NULL 의도) vs webadmin 밖 1(빈 옵션그룹) vs 경로불명 1(qty_unit)로 코드 라인 근거 분리 |
| **K4** 라이브 실측 독립 재현 | ✅ PASS | 표본 13건(상품수·코팅8·화이트3·조각수·형상부재·066-37행·카테고리·자재유형·옵션그룹·도수·정상노드·자재명·공정0) 전건 독립 SELECT로 동일 재현 |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0, EXTRA 1(빈 옵션그룹 논리삭제 제안·hard-delete 금지), 재연결 대상 030~047·PROC_000013/000054·MAT_000084 전부 라이브 실재 입증, ddl 라우팅 2(ref_param_json만) |
| **K6** 오모델 정합 | ✅ PASS | 별색/화이트=PROC(도수 아님)·판수=앱·형상=size(066 Q7) vs 형상=공정 param(규격형, PROC_000054 모양 input 보유)·자재=parent+usage.07·size↔option 경계 정합 |

---

## 1. K0 — 상품 정체 확정 (PASS)

**정체 자체가 round-11 BOM에서 이미 확정** — 스티커 16상품은 전부 일반 인쇄물(스티커 단일 카테고리)·단품(스티커팩 065만 세트). product-identity §1 정체표가 범주(스티커 반칼/완칼/규격/합판/타투)·구성·생산방식(인쇄방식5→공정)·정체출처(product-bom §1~16)·라이브 분류 정합을 16상품 전수 명기. 굿즈파우치(포장 세트)·인쇄배경지(포장재 오분류)와 달리 **스티커는 비전형 상품 0** — 정체 오분류가 아니라 속성축 적재 결함이 라이브 결함.

**독립 재현(read-only psql):**
```
PRD_000052~067 16상품 전수 적재·전부 prd_typ_cd=PRD_TYPE.04(디자인)·MES 전량 NULL·063/064 use_yn=N·065 file_upload_yn=N
```
product-identity §0 라이브 실측("PRD_000052~067 16상품·PRD_TYPE.04·063/064 use_yn=N·065만 file_upload=N")과 **완전 일치**.

**③ 집중검증 — 타투 924행→L1 16상품·154행 정정 입증:** product-identity §0 각주가 "round-11 product-bom §16은 타투=924행이라 했으나 L1 실측=16상품·154행, 924는 가격표 전개행"이라 정정. 검증자 L1 직접 측정:
```
sticker-l1.csv: 총 데이터행(prd_nm nonblank)=154 · distinct prd_nm=16 (낱장/대형/반칼6/소량/스티커팩/타투/합판도무송 = 16)
```
**정확.** 924는 별도 가격표(price-sticker-price-l1.csv)의 사이즈×수량 전개행이고, 정답=상품마스터 L1(사용자 directive)이므로 16상품·154행이 정답 기준. **카운트 과대 dodge-hunt 통과.**

---

## 2. K1 — 추출규칙 커버리지 (PASS)

- extraction-plan §1이 16상품을 4그룹(A 반칼자유형·B 완칼/실사·C 규격형·D 합판/팩/전사)으로 나눠 **5속성축(size·자재·공정·도수·인쇄옵션) + 스티커 고유축**(인쇄방식5분기·커팅공정·형상·조각수·화이트별색·코팅)을 셀별 엑셀출처(C5/C8/C9·C16·C17·C18·C24·C25)·정답변환·목표 t_*·oracle 근거·실제 vs 정답 동반.
- §2 횡단 매트릭스가 5축 × 16상품 커버리지를 라이브 상태 요약과 함께 명기.
- N/A 사유 §2 명기: 후가공 가변(VDP)·추가상품·클리어/핑크/금/은 별색 = 전 상품 빈값(L1 실측)→적재 안 함이 정답. **빈칸 0 확인.**

---

## 3. K2 — oracle 인용 실재 (PASS)

표본 전건 Read로 실존·내용 일치 확인:

| 인용 | 파일:라인 | 주장 내용 | 실측 결과 |
|------|----------|----------|:--:|
| 적재원 v03 xlsx | load_master.py:39 | `XLSX="data/raw/prdmaster_full_migration_v03_20260518.xlsx"` | ✅ 정확 |
| MES None 적재 | load_master.py:261 | `None # MES_ITEM_CD: 전량 NULL`(주석 D-05 중복 회피) | ✅ 정확 |
| qty_unit None | load_master.py:269 | `None # qty_unit_typ_cd: 시트10에 원천 컬럼 없음` | ✅ 정확 |
| load_materials(05시트) | load_master.py:227-247 | `read_sheet(wb,"05_자재정보")`·MAT_TYPE enum | ✅ 정확 |
| MAT_TYPE enum 변환 | load_master.py:237-239 | `enum_code("MAT_TYPE", r["자재구분"])`(OVERRIDE 분기) | ✅ 정확 |
| load_rel_categories(11시트) | load_master.py:282-291 | `11_상품별카테고리`→t_prd_product_categories | ✅ 정확 |
| load_rel_bundle_qtys(12시트) | load_master.py:294-304 | `12_상품별묶음수`→bundle_qtys | ✅ 정확 |
| load_rel_materials usage | load_master.py:318-324 | `enum_code("USAGE", r["용도"] or "공통")` | ✅ 정확 |
| load_rel_plate_sizes | load_master.py:336-349 | `other if ... is not None else None`(전부 .기타/NULL) | ✅ 정확 |
| load_rel_print_options 도수 | load_master.py:352-382 | front/back 도수코드 매핑 | ✅ 정확 |
| load_rel_processes mand | load_master.py:404-421 | `_yn(r["필수공정여부"])`(line 416) | ✅ 정확 |
| OUTPUT_PAPER_TYPE.03=기타 | sql/05_seed.sql:190 | `('OUTPUT_PAPER_TYPE.03','기타',...)` | ✅ 정확 |
| USAGE.07=공통 | sql/05_seed.sql:258 | `('USAGE.07','공통',...)` | ✅ 정확 |
| t_prd_product_processes 스키마 | sql/01b:120-133 | prcs_dtl_opt 컬럼 부재 | ✅ 정확(컬럼 = prd_cd·proc_cd·excl_grp_cd·mand_proc_yn·disp_seq·reg_dt·upd_dt) |
| OM-7/GAP-PARAM/ref_param_json | intent-map:351/442/485 | 공정 param 보존 부재 | ✅ 정확(3 라인 실존) |

**round-11 G-1 권위 날조 재발 0** — 인용 전건 실존·주장 정확 일치. 날조·미존재 인용 없음.

> **검증자 추가 발견(인용 보강 권장·결함 아님):** loadlogic L-ST-F가 자재유형 변환을 `load_materials:237 enum_code`로 인용했는데, line 237-239는 실제로 **`MAT_TYP_OVERRIDE` 분기**다(`if 자재코드 in MAT_TYP_OVERRIDE → 강제값 else enum_code(자재구분)`). OVERRIDE 딕트(116-121)는 "하드커버전용지+무광코팅=종이·레더하드커버=가죽" 4건만으로 **스티커 자재는 전부 OVERRIDE 대상이 아님** → 스티커 .01/.11은 `else enum_code("MAT_TYPE", r["자재구분"])`(239) 경로 = v03 자재구분 라벨 직접 전파. 따라서 L-ST-F "v03 정규화 결함" 분류는 **정합**(OVERRIDE가 스티커에 개입 안 함을 검증자가 확인). auditor가 OVERRIDE 존재를 언급 안 했으나 스티커 범위 밖이라 결함 아님 — 인용 라인을 237→239로 정밀화하면 더 정확.

---

## 4. K3 — 적재로직 근거 (PASS)

loadlogic-notes §2가 결함 8건을 file:line 근거로 v03 정규화 결함 vs load_master 코드 결정 vs webadmin 밖으로 분리:

- **L-ST-A MES NULL (load_master.py:261):** "코드 의도적 결정(D-05 중복 회피)·v03 결함 아님" — line 261 주석 Read로 정확. 정직 표기.
- **L-ST-B 코팅=자재 (227·318):** "v03 05시트가 코팅을 자재로 인코딩·load_master는 전파기" — load_materials/rel_materials 충실 전파 확인. **단 CONFLICT 미해소**(round-11 §44 자재 variant 정당 vs Q9 공정)를 컨펌으로 분리(정직).
- **L-ST-C 조각수 미전개 (load_rel_bundle_qtys:294):** "v03 12시트가 066만 전개" + "prcs_dtl_opt 상품 레벨 저장처 부재(01b:123)" — 스키마 Read로 컬럼 부재 확인.
- **L-ST-D 063 화이트 누락 (load_rel_processes:404):** "v03 15시트 063 화이트 행 부재" — 충실 전파.
- **L-ST-E 카테고리 root (load_rel_categories:282):** "v03 11시트가 root만 매핑·노드 030~047 미사용" — 코드는 정상.
- **L-ST-F 자재유형 혼재 (load_materials:237):** "v03 자재구분 라벨 충실 변환" — 검증자가 OVERRIDE 비개입 확인(§3 추가발견).
- **L-ST-G 빈 옵션그룹 (경로불명):** "load_master 소관 밖·round-9 admin/round-6 CPQ 잔재 추정" — 정직한 "경로불명".
- **L-ST-H 자재명 절단 (load_materials:236):** "v03 05시트 자재명 절단" — `_norm(r["자재명"])` 그대로 전파.

**검증자 추가 확인 — mand=N 원인 정합:** `_yn`(line 78-80) = "빈값/None → 'N'(source leaves false blank)". v03 15시트 `필수공정여부`가 빈값이면 N으로 변환됨. C-ST-11 "v03 필수성 미표기→mand=N·load_master 충실 전파" 주장이 코드 정합. **단 이는 코드 결함이 아니라 v03가 'Y'를 안 적은 것**이고 정답(커팅=스티커 정체→mand=Y)은 컨펌으로 분리(C-ST-11 Low).

---

## 5. K4 — 라이브 실측 독립 재현 (PASS)

검증자 독립 read-only SELECT로 13건 재현, 전건 매니페스트 값과 일치:

| 측정 | 매니페스트 주장 | 독립 재현 | 일치 |
|------|----------------|----------|:--:|
| 스티커 상품 범위 | PRD_000052~067 16상품·PRD_TYPE.04 | 16상품 전수·전부 .04 | ✅ |
| 코팅 자재 연결 (CONFLICT) | 052·058·059·060·061·062·064·066 (8) | MAT_000155/156 → 동일 8상품 | ✅ |
| 화이트 PROC_000008 | 053·054·056만(063 누락) | 053,054,056 (063 부재) | ✅ |
| 조각수 bundle_qtys | 066만 5행 | PRD_000066=5·나머지 0 | ✅ |
| 058 size(규격만·형상 부재) | A4/A5뿐 | A4(210x297)·A5(148x210) | ✅ |
| 058 공정 prcs_dtl_opt | PROC_000055 스티커완칼·조각수만 | PROC_000055·`{조각수 input만}`(모양 없음) | ✅ |
| 066 형상=size | 37행·siz_nm 인코딩 | 37행·`정사각30x30mm(8EA)` 등 | ✅ |
| 카테고리 위상 | 16상품 CAT_000002 lvl1 root | CAT_000002·스티커·lvl1·16건 | ✅ |
| 정상노드 030~047 실재 | 재연결 대상 | 030~047 전수 실재(030~036 lvl2·037 규격 부모·038~044 lvl3·045 특수·046 타투·047 팩) | ✅ |
| 자재유형 혼재 | .01 4종·.11 8종 | .01(084/167/242/243)·.11(153/154/155/156/162/163/170/171) | ✅ |
| 066 빈 옵션그룹 | OPT-000004 원형·items 0 | OPT-000004 원형(2026-06-10)·OPV-000006 items=0 | ✅ |
| 052 도수 | 단면·CLR_000005(4도)·CLR_000001(0도) | 단면·CLR_000005=CMYK 4도·CLR_000001=인쇄 안 함 | ✅ |
| 055/057 자재명 절단 | "유포지"(엠보 소실) | MAT_000154 유포지(둘 다) | ✅ |
| 065/067 공정 0행 | 팩/타투 커팅 없음 | PRD_000065=0·PRD_000067=0 | ✅ |

라이브 접속 성공, 비밀값 비노출. "행 존재만 ≠ 적재됨"(D-1) 변형커버리지도 066 bundle=5행(존재)이나 묶음수≠조각수 의미 혼입으로 재현 — 매니페스트 진단 정확.

---

## 6. K5 — 비파괴·search-before-mint (PASS)

- correction-manifest §1~4: COMMIT/DDL/DELETE 문 0. 교정은 INSERT(연결행)·UPDATE(재연결·mat_typ·mand) **제안**.
- **EXTRA 1**(C-ST-12 066 빈 옵션그룹) = `use_yn='N'`/`del_yn='Y'` 논리삭제 제안·**hard-delete 금지** 명기. EXTRA 삭제단정 0.
- **search-before-mint 입증(독립 재현):** 재연결 대상 카테고리 노드 030~047 전수 실재·PROC_000013 코팅 실재·PROC_000054 반칼(모양 input 보유) 실재·MAT_000084 비코팅스티커 실재 — 검증자 직접 SELECT 확인. 교정 신규 mint 0. ddl 라우팅 2건(C-ST-05/06 ref_param_json만, OM-7 알려진 미구현).

---

## 7. K6 — 오모델 정합 (PASS)

- **별색/화이트=공정(도수 아님):** extraction-plan §0.4 "화이트 별색=PROC_000008·print_side 아님". 053/054/056/063 화이트 = 공정 처리. 정합.
- **판수=앱:** §0.8 "판수(C6)·EA면적계산=앱 런타임 DB 미저장". 정합.
- **판형=출력용지규격:** loadlogic C10 "output_paper=전부 .기타/NULL(치수→.기타)". 라이브 .03은 후속 plate교정 산물로 표기(C-ST-16 AMBIGUOUS·가격엔진 트랙). 정합.
- **자재=parent+usage:** §1 "mat_cd + usage=USAGE.07". 정합.
- **형상=size vs 형상=공정 param 경계(결정적):** 066 합판도무송=형상이 칼틀 1:1·size 유지(Q7·siz_nm 인코딩) vs 규격형 058~062=형상이 자유 선택축→prcs_dtl_opt.모양 권위. **검증자 마스터 스키마 확인:** PROC_000054 반칼 = `{모양 input + 조각수 input}`·PROC_000055 스티커완칼 = `{조각수 input만}` → C-ST-06 정답("058~062를 PROC_000055→PROC_000054 교체하면 모양 param 확보")이 마스터 스키마로 정확히 뒷받침. **size↔공정 param 경계 정합.**

---

## 8. 2-pass dodge-hunt 결과 (round-13 교훈 — 표본 독립 재실측)

| dodge 유형 | 점검 대상 | 독립 재실측 | 결과 |
|-----------|----------|------------|:--:|
| **분류 정반대** (MISSING↔MIS-LOADED) | 063 화이트(MISSING)·코팅(MIS-LOADED)·조각수(MISSING) | 063 PROC_000008 부재=진짜 MISSING·코팅 MAT 8상품 연결=진짜 MIS-LOADED·bundle 066만=진짜 MISSING | ✅ 정반대 0 |
| **카운트 과대** | 코팅 8상품·화이트 3·066 37행·조각수 1상품·타투 924→16 | 코팅 정확히 8·화이트 정확히 3·066 정확히 37·bundle 066만·**L1 distinct=16(924 반증)** | ✅ 과대 0 |
| **재연결 오매핑** (prd_cd순≠노드순) | C-ST-02 16상품→030~047 매핑 | 노드명 의미 매칭 전건 정확 — **064 소량→CAT_000033**(prd_cd 053~057 구간 아닌 033, 노드명 "소량 자유형 스티커" 의미 매칭)이 결정적 증거·066→044(합판)·067→046(타투) 전부 정확 | ✅ 오매핑 0 |

**dodge-hunt 실결함 미적발.** 문구 사례(재연결 prd_cd순 오매핑)·악세 사례(분류 정반대)·아크릴 사례(카운트 과대)의 3종 함정이 스티커엔 없음. 특히 재연결 매핑이 prd_cd 순서가 아닌 cat_nm 의미로 정확히 짚어졌다(064→033이 입증).

---

## 9. 발견 사항 요약 (라우팅)

| ID | 사항 | 심각도 | 라우팅 | 상태 |
|----|------|:--:|------|:--:|
| **G-ST-V1** | loadlogic L-ST-F 인용 라인 237→239 정밀화 권장(OVERRIDE 분기 명시, 스티커는 else 경로). 결함 아님·정합 확인 | Info | `dbm-correctness-auditor`(선택적 보강) | 정보 |
| **G-ST-V2** | 066 siz_nm 인코딩이 형상별로 EA 표기 불균일(`원형10x10`=EA 없음 vs `정사각10x10mm(8EA)`=EA 있음). C-ST-03 "siz_nm에 형상+치수+EA 인코딩" 일반화는 원형류에 부분 미적용 | Low | `dbm-correctness-auditor`(C-ST-03 각주 보강 권장)·실제 데이터 정합은 가격격자 트랙 | 정보 |

> **두 사항 모두 Info/Low·교정 방향 무영향** — GO 판정 불변. G-ST-V1은 인용 정밀도(분류 정합 확인됨), G-ST-V2는 siz_nm 데이터 표기 편차(형상=size 모델 자체는 CORRECT). auditor 산출 직접 수정 없이 정보 라우팅만.

---

## 10. 잔존 컨펌 (인간 결정 대기 — auditor 식별, 검증자 동의)

- **Q-ST-A [HIGH·CONFLICT-1] 코팅 공정 전환 vs 자재 유지** — Q9 권위(공정) vs round-11 §44(자재 variant 정당)·가격표 3컬럼(비코팅/무광/유광). CONFLICT 미해소를 컨펌으로 정직 분리(단순 교정으로 닫지 않음) — **검증자 동의**(라이브 코팅 자재 8상품·PROC_000013 공정 둘 다 실재로 양립 곤란 확인).
- **Q-ST-B** 조각수 적재 형태(bundle_qty vs ref_param_json·OM-7 선결) — ddl-proposer.
- **Q-ST-C** 규격형 058~062 형상 저장처(PROC_000055→054 교체+param vs siz_nm 통일) — PROC_000054 모양 input 보유 확인됨, ref_param_json 선결.
- **Q-ST-E** 스티커팩 065 세트 구성(sets 정의 vs 단일) — 구성 데이터 필요.
- **Q-ST-MES** MES_ITEM_CD 적재 정책(중복 정리 후 재적재 vs 의도된 NULL 유지) — 정책 결정.

---

## 11. 결론

- **GO.** 라이브 정합 교정 방법론(라이브=피고·oracle=정답·정답=상품마스터 L1)이 스티커에서 입증됐다. 17건 분류표(CORRECT5·MIS-LOADED5·MISSING5·EXTRA1·AMBIGUOUS1)는 비파괴·증거기반·정밀(증상 아닌 v03 정규화 원인까지 환원). oracle 인용 날조 0(round-11 G-1 교훈 준수), 라이브 실측 13표본 독립 재현 성공, **dodge-hunt 3종 전건 통과**.
- **정체 선행의 가치 재확인:** 스티커는 정체 오분류 0(전 16상품 명백한 스티커 인쇄물)이라 결함이 정체 레벨이 아닌 속성축 레벨(코팅·형상·조각수·별색·MES·카테고리 위상)에 집중 — product-identity가 이를 선제 확정해 5속성축 감사가 정밀했다.
- **양방향 정정 확인:** ① round-11 "합판형상 size 흡수=오모델 의심"→Q7 형상=size CORRECT 재확증(66 37행 라이브 입증) ② 타투 924행→L1 16상품·154행(검증자 직접 측정 입증) ③ round-12 "front=무도수"→CLR_000005=4도 정정.
- **잔존 컨펌 5건(인간 결정 대기):** Q-ST-A(코팅 CONFLICT)·B(조각수)·C(규격형 형상)·E(스티커팩 세트)·MES. 교정 실행(재연결 UPDATE·MISSING INSERT·논리삭제·mat_typ/mand UPDATE)은 round-5/10 트랙 인간 승인 — DB 미적재 유지.
- **DB 쓰기 0** — 본 게이트 read-only SELECT + 소스 Read만. COMMIT/DDL/DELETE 없음.

### 최종 매트릭스
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |

**스티커 최종 판정: GO.** K0~K6 전건 PASS·dodge-hunt 실결함 0.
