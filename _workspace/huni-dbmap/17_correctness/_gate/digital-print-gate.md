# 디지털인쇄 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-10 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/digital-print/` 5종.
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 SELECT) 동반. 발견 결함은 라우팅만(산출물 직접 수정 금지).
> **권위:** oracle 인용 실재성은 `raw/webadmin/` 소스 Read 검증, 라이브 값은 독립 read-only psql 재현.

---

## 0. 최종 판정: **GO** (F-GATE-1·F-GATE-2 보정 재게이트 후 — 2026-06-11)

> **갱신 이력:** 1차(06-10) = CONDITIONAL-GO(K0 ⚠️·F-GATE-1/2 발견). `dbm-correctness-auditor` 보정 후 **K0 재게이트(06-11) = PASS** → 디지털인쇄 파일럿 **GO**. K1~K6은 1차 PASS carry-forward(재검 불요). 상세 재판정은 §10.

라이브 정합 교정의 핵심 방법론·증거·결함 식별이 견고하고(K2/K3/K4 전건 독립 재현, G-1 날조 재발 0), 1차에서 적발한 K0 2건(F-GATE-1 카테고리 orphan 뉘앙스·F-GATE-2 명함 수 오기)이 보정 완료·독립 재실측으로 정확성 확인됨. 교정 매니페스트는 비파괴·search-before-mint 준수(K5 PASS) — 적재 트랙 진입 안전(컨펌 4건은 인간 승인 대기, DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ **PASS**(재게이트) | F-GATE-1/2 보정 정확 — 카테고리 정상노드(273/274/275/283 upr=012) vs 잉여 고아(295/296 NULL) 구분이 독립 SELECT와 일치·교정=정상노드 재연결(search-before-mint)·명함=10·합=36 원본 일치(§10) |
| **K1** 추출규칙 커버리지 | ✅ PASS | 7 대표상품 × 5속성축 + 축⑥(포장세트) 전수, N/A 사유 명기, 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ PASS | 표본 11건(load_master 39/164/261/269/324/338/346/436·migrate_phase7 215/226·seed 258/182/190) 전건 실존·내용 일치 |
| **K3** 적재로직 근거 | ✅ PASS | MIS-LOADED/MISSING 원인이 실제 코드 라인으로 재구성 또는 "적재경로 불명" 정직 표기 |
| **K4** 라이브 실측 독립 재현 | ✅ PASS | 표본 14건(상품수·카테고리·addon·proc·size·plate·박부모) 전건 독립 SELECT로 동일 재현 |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0, EXTRA 0, 봉투 template 기존행 재사용 입증, ddl-proposer 라우팅 0 |
| **K6** 오모델 정합 | ✅ PASS | 별색=PROC_000007·판수=앱·판형=출력용지규격·자재=parent+usage_cd·size↔option 경계 정합 |

---

## 1. K0 — 상품 정체 확정 (CONDITIONAL)

**PASS 측면:** 13상품 정체표가 범주(일반인쇄/포장재)·구성(세트/단품)·생산방식·출처를 명기. 배경지(043/044/045) "포장 세트" 정체가 사이트 증거(`goods_view_102.html`)+product-master(82/172/380)+L1 MES prefix(012=포장)로 다중 뒷받침 — 비전형 상품 정체가 사이트 근거로 확정됨. 정체 불명을 추측으로 단정한 곳 없음(🔴 Q-ID-A로 봉투세트 적재모델을 컨펌으로 남김).

**CONDITIONAL 사유 — 정정 필요 발견 2건:**

### F-GATE-1 [카테고리 orphan 뉘앙스 부정확 — 중요] Med · 라우팅: `dbm-correctness-auditor`
- **무엇:** product-identity F-ID-3·loadlogic L-H가 "배경지(CAT_000296)는 upr_cat_cd=NULL 고아"로 서술하면서, **이미 `CAT_000012 포장` 하위에 정상 연결된 동명 노드 `CAT_000273 인쇄배경지(OPP봉투타입)`·`CAT_000274 인쇄배경지(투명케이스타입)`(둘 다 lvl2, upr=CAT_000012)의 존재를 언급하지 않았다.** 독립 측정:
  ```
  CAT_000012|포장|NULL|1
  CAT_000273|인쇄배경지(OPP봉투타입)|CAT_000012|2   ← 정상 부모, 그러나 상품 미연결
  CAT_000274|인쇄배경지(투명케이스타입)|CAT_000012|2  ← 정상 부모, 그러나 상품 미연결
  CAT_000295|상품권|NULL|3   ← 고아(orphan)
  CAT_000296|배경지|NULL|3   ← 고아(orphan)
  ```
- **진짜 결함 구조(정밀화):** 배경지 상품(043~046)은 **고아 노드 CAT_000296에 잘못 연결**됐고, 정작 **포장 트리에 제대로 매달린 CAT_000273/274에는 상품이 0건 연결**돼 있다. 즉 결함은 "배경지 카테고리 전체가 고아"가 아니라 "**정상 부모 노드(273/274)가 있는데도 상품이 고아 노드(296)에 연결됐다**"는 더 구체적 오적재다. 교정(C-09)은 "CAT_000296의 upr를 012로 UPDATE"가 아니라 "**상품을 273/274(이미 012 하위)로 재연결**" 또는 "296을 273/274로 병합"이 정답에 가깝다 — 신규 부모 부여보다 기존 정상 노드 재사용이 search-before-mint에 부합.
- **독립 측정 증거:**
  ```sql
  SELECT c.prd_cd, cc.cat_cd, cc.cat_nm FROM t_prd_product_categories c
    JOIN t_cat_categories cc ON c.cat_cd=cc.cat_cd WHERE c.prd_cd IN ('PRD_000043'..'046');
  -- 043/044/045/046 → 전부 CAT_000296 배경지(orphan)
  SELECT cat_cd,count(*) FROM t_prd_product_categories WHERE cat_cd IN ('CAT_000295','CAT_000296') GROUP BY cat_cd;
  -- CAT_000295|2  CAT_000296|4
  ```
- **판정:** F-ID-3/L-H 서술은 "고아"라는 사실 자체는 라이브-정합(정확)이나, **정상 부모 노드 273/274 존재를 누락해 교정 방향(C-09 "296의 upr를 012로 UPDATE")을 차선책으로 유도**했다. 정밀화 정정 필요.
- **참고(상품권 042 박):** 메인 실측(PROC_000037~044 자식 연결·부모 PROC_000033 부재)은 본 게이트 독립 재현으로 확인(`PROC_000033 연결=0`) — 이건 정확하며 C-06/Q-DP-C가 올바로 다룸.

### F-GATE-2 [상품 수 표기 — 36 확정, 38은 메인 오카운트] Low · 라우팅: 정보(정정 불요·근거 보강 권장)
- **무엇:** 파일럿은 "36 distinct"라 표기. 메인 세션은 "L1 고유 prd_nm 38"이라 스팟체크했으나, **권위 원본 직접 측정 결과 36이 정답**:
  - `docs/huni/후니프린팅_상품마스터_260610.xlsx` `디지털인쇄` 시트 상품명 col: **nonblank 36, distinct 36** (openpyxl 직접 측정).
  - L1 추출본 `digital-print-l1.csv` prd_nm: **212행, distinct 36** (구분별: 엽서8·포토카드3·접지카드4·명함10·상품권2·배경지4·인쇄홍보물5 = 36).
- **38 차이 원인:** 메인의 38은 (a) 다른 시트/범위 합산 또는 (b) 헤더/공백 포함 카운트로 추정 — 권위 원본 xlsx와 L1이 모두 일관되게 36이므로 **36이 확정**. 파일럿 표기 정확.
- **단, 파일럿 내부 불일치:** product-identity §0 표가 명함=11로 적어 합이 8+3+4+11+2+4+5=**37**이 됨(본문 "36 distinct"와 자기모순). 실측 명함=10 → 합 36. 표의 명함 행을 10으로 정정 필요(경미).

---

## 2. K1 — 추출규칙 커버리지 (PASS)

- extraction-plan §1이 **5속성축(size·자재·공정·도수·인쇄옵션) × 대표 7상품 = 35셀** 전수 추출규칙 명기. 각 셀에 엑셀 출처(C5/C8/C9·C16·C18~37·C17·C10)·변환·목표 t_*·oracle 근거 동반.
- 축⑥(포장세트+카테고리)을 정체 기반으로 추가, 일반 인쇄물은 "세트 아님" N/A 사유 명기.
- 미저장(C6 판수=앱·C11/13 생산메타·C36 박크기=앱) N/A 사유 §2 명기. **빈칸 0 확인.**

---

## 3. K2 — oracle 인용 실재 (PASS)

표본 11건 전건 Read로 실존·내용 일치 확인(🔴/MISSING/MIS-LOADED 인용 전수 포함):

| 인용 | 파일:라인 | 주장 내용 | 실측 결과 |
|------|----------|----------|:--:|
| 적재원 엑셀 v03 | load_master.py:39 | `XLSX="data/raw/prdmaster_full_migration_v03_20260518.xlsx"` | ✅ 정확 |
| load_categories 상위 NULL→UPDATE | load_master.py:164-178 | 카테고리 INSERT upr=NULL 후 별도 UPDATE | ✅ 정확(line 171 NULL·175-177 UPDATE) |
| MES None 적재 | load_master.py:261 | `None # MES_ITEM_CD: 전량 NULL` | ✅ 정확 |
| qty_unit None | load_master.py:269 | `None # qty_unit_typ_cd: 시트10에 원천 컬럼 없음` | ✅ 정확 |
| usage 빈값→공통 | load_master.py:324 | `enum_code("USAGE", r["용도"] or "공통")` | ✅ 정확 |
| plate 무조건 .기타 | load_master.py:338,340,346 | `other=기타` / 주석 / `other if ... is not None else None` | ✅ 정확(.01 생성 불가 입증됨) |
| addon = addon_prd_cd 직접 | load_master.py:436-444 | 시트20만 읽어 addon_prd_cd INSERT | ✅ 정확(C38 자유텍스트 미파싱) |
| TMPL- 하이픈 결합 | migrate_phase7.py:215,226 | `'TMPL-' \|\| addon_prd_cd` | ✅ 정확 |
| USAGE.07=공통 | sql/05_seed.sql:258 | `('USAGE.07','공통',...)` | ✅ 정확 |
| OUTPUT_PAPER_TYPE.01=국전계열 | sql/05_seed.sql:182 | `('OUTPUT_PAPER_TYPE.01','국전계열',...)` | ✅ 정확 |
| OUTPUT_PAPER_TYPE.03=기타 | sql/05_seed.sql:190 | `('OUTPUT_PAPER_TYPE.03','기타',...)` | ✅ 정확 |

**round-11 G-1 권위 날조 재발 0** — 인용한 모든 소스 라인이 실존하고 주장과 정확히 일치. 날조·미존재 인용 없음.

---

## 4. K3 — 적재로직 근거 (PASS)

- **MISSING(배경지 봉투세트·커팅):** L-G가 "C38 자유텍스트 → load_rel_addons(436)는 시트20만 파싱 → 범위 밖"으로 원인 재구성. line 436-444를 직접 Read한 결과 시트20(`20_상품별추가상품`)만 읽고 디지털인쇄 본 시트 C38은 미참조 — **재구성 정확**. migrate_phase7가 "없는 행 안 만듦"도 line 211-226(기존 addon→TMPL 전환만)으로 확인.
- **MIS-LOADED(카테고리 orphan):** L-H가 load_categories(164-178)의 상위코드 NULL 경로로 환원 — 정확(F-GATE-1의 정밀화 여지는 별개).
- **MIS-LOADED(plate .01 / qty_unit):** L-A/L-B가 "load_master가 이 값을 만들 수 없음 → webadmin 밖 후속 손작업 = 적재경로 불명"으로 **정직 표기**. line 269(None)·346(.기타 또는 NULL만)을 Read로 확인 — `.01`·`QTY_UNIT.02`는 실제로 load_master 산물이 아님이 입증됨. "적재경로 불명" 표기는 추측 단정이 아니라 코드 부재의 정직한 결론.
- **공정(L-C):** "load_master가 시트15를 변환 0으로 충실 반영 → 결함은 적재원 v03 시트" — line 404-421(시트15 그대로) 패턴과 정합.

---

## 5. K4 — 라이브 실측 독립 재현 (PASS)

검증자 독립 read-only SELECT로 14건 재현, 전건 매니페스트 값과 일치:

| 측정 | 매니페스트 주장 | 독립 재현 | 일치 |
|------|----------------|----------|:--:|
| 디지털인쇄 distinct 상품 | 36 | xlsx 36·L1 36 | ✅ |
| 엽서016 size | 7 | 7 | ✅ |
| 엽서016 자재 | 21행 USAGE.07 | 21·DISTINCT usage=USAGE.07 | ✅ |
| 엽서016 공정 | 027/028/029/030/031/032 | 동일 6행 | ✅ |
| 엽서016 plate | 1행 .01 | SIZ_000499·OUTPUT_PAPER_TYPE.01 | ✅ |
| 엽서016 addon | TMPL-000005 1행만 | TMPL-000005 (전 DB addon=PRD_000016 1행) | ✅ |
| 배경지043 size/proc/addon/sets | 6/0/0/0 | 6/0/0/0 | ✅ |
| 배경지044 size | 2 | 2 | ✅ |
| 라벨택046 size/proc | 3/0 | 3/0 | ✅ |
| 상품권042 박색 자식 | 037~044 연결·부모033 부재 | 037~044 연결·PROC_000033=0 | ✅ |
| 카테고리 043~046 연결 | CAT_000296 배경지(orphan) | 전부 CAT_000296 | ✅ |
| 카테고리 041/042 | CAT_000295 상품권(orphan) | CAT_000295 | ✅ |
| CAT_000295/296 upr | NULL·lvl3 | NULL·lvl3 | ✅ |
| CAT_000273/274 | (매니페스트 미언급) | upr=CAT_000012·lvl2 (F-GATE-1) | — |

라이브 접속 성공, 비밀값 비노출. "행 존재만 ≠ 적재됨"(D-1) 변형커버리지 검증도 배경지 size=6(행 존재)이나 정체구성(세트/커팅)=0으로 재현 — 매니페스트 진단 정확.

---

## 6. K5 — 비파괴·search-before-mint (PASS)

- correction-manifest §1~4: COMMIT/DDL/DELETE 문 0. 교정은 전부 INSERT(연결행 추가)·UPDATE(카테고리 재연결) **제안**.
- EXTRA=0(라이브 과적재 없음·논리삭제 제안 없음). 상품권 박 8색은 hard-delete가 아닌 AMBIGUOUS+컨펌(C-06).
- **search-before-mint 입증:** 봉투 세트(C-08/11)에 "TMPL-000004~009 라이브 실재 → 신규 mint 불요·재사용"을 명기, 재현 SELECT(`t_prd_templates WHERE tmpl_nm LIKE '%봉투%'`) 동반. 완칼(C-07/13)·접지(C-10)도 "마스터 실재" 재사용. ddl-proposer 라우팅 0건(스키마 부족 없음 — prcs_dtl_opt·sets·addons 전부 실재).
- **참고:** F-GATE-1 정밀화 적용 시 C-09 카테고리 교정은 "CAT_000296 upr UPDATE"보다 "기존 정상노드 273/274 재연결"이 더 강한 search-before-mint(신규 부모 부여 회피).

---

## 7. K6 — 오모델 정합 (PASS)

- **별색=공정:** extraction-plan 축④ "별색은 도수에 안 넣음(공정)"·축③ "별색 C18~22→PROC_000007 별색인쇄 root+자식". (단 표기상 PROC_000007을 "별색인쇄 root"로 사용 — 메모리 권위는 별색=PROC_000007이며 일치. round-11 QA가 PROC_000002=UV/PROC_000007=별색으로 정정한 것과 정합.)
- **판수=앱:** §2 "C6 판수=앱 임포지션 런타임·t_* 매핑 금지" 명기.
- **판형=출력용지규격:** 축⑤ "316x467→OUTPUT_PAPER_TYPE.01 국전계열" — platesize-is-output-paper 메모리 정합.
- **자재=parent+usage_cd:** 축② usage_cd 차원 명시(USAGE.07).
- **size↔option 경계:** 배경지 커팅 형상=완칼 param(size축 drop 금지·OM-7)·봉투세트=addon/sets(size 아님) — 경계 정합.

---

## 8. 발견 결함 요약 (심각도·라우팅·상태)

| ID | 결함 | 심각도 | 라우팅 | 상태 |
|----|------|:--:|------|:--:|
| **F-GATE-1** | 카테고리 orphan 서술이 정상 부모 CAT_000273/274 존재 누락 → 교정 방향(C-09) 차선 유도. 정밀화: 상품을 273/274 재연결이 정답 | Med | `dbm-correctness-auditor`(F-ID-3·L-H·C-09 정정) | ✅ **RESOLVED**(§10) |
| **F-GATE-2** | product-identity §0 표 명함=11(합 37) ↔ 본문 "36 distinct" 자기모순. 실측 명함=10·합 36 | Low | `dbm-correctness-auditor`(표 명함 행 10으로 정정) | ✅ **RESOLVED**(§10) |

> **메인 스팟체크 회신(1차):** ① 상품수 = **36 확정**(xlsx·L1 모두 36, 메인의 38은 오카운트). ② 카테고리 orphan 뉘앙스 = 파일럿 1차 **부정확**(고아 사실은 맞으나 정상부모 273/274 누락 → F-GATE-1로 정정, §10에서 RESOLVED). ③ 박 상품권 042 = 파일럿·메인 실측 **정합**(부모 033 부재 독립 재현 확인).

---

## 9. 결론

- **GO**(F-GATE-1·F-GATE-2 보정 후 재게이트). 라이브 정합 교정 방법론(라이브=피고·oracle=정답)이 입증됐고, 18건 교정 매니페스트는 비파괴·증거기반·정밀(증상 아닌 적재로직 원인까지 환원). oracle 인용 날조 0(round-11 G-1 교훈 준수), 라이브 실측 독립 재현 성공.
- **1차 조건 해소:** F-GATE-1(카테고리 정상노드 재연결로 정정)·F-GATE-2(명함 10·합 36 정정) 모두 RESOLVED(§10 독립 재실측). C-07~C-14 MISSING/MIS-LOADED 결함군은 보정 과정에서 미변경(scope 보존).
- **잔존 컨펌 4건(인간 결정 대기):** Q-ID-A(봉투세트 적재모델 sets/addon/CPQ)·Q-ID-B(배경지/상품권 카테고리 재연결)·Q-DP-C(상품권 박 8색=옵션풀 vs 부모행)·Q-DP-B(tmpl_cd separator 하이픈 vs `_`). 전건 적재/DDL/논리삭제는 인간 승인 — DB 미적재 원칙 유지.
- **DB 쓰기 0** — 본 게이트는 read-only SELECT만 수행, COMMIT/DDL 없음.

## 10. K0 재게이트 — 정식 검증자 판정 (2026-06-11, `dbm-validator` 독립)

> 1차(§0~9, 06-10)는 K0 ⚠️CONDITIONAL. `dbm-correctness-auditor`가 F-GATE-1·F-GATE-2를 보정 → **K0만 재게이트**(K1~K6 1차 PASS carry-forward). 아래는 생성자와 분리된 검증자가 **라이브 독립 재실측 + 소스 Read**로 보정 정확성을 판정한 정식 판정(이 판정이 권위).

### K0 재판정: ✅ **PASS** — 5개 재게이트 기준 전건 충족

**① 정상노드(273/274/275/283 upr=012) vs 고아(295/296 NULL) 구분 — 독립 SELECT 대조:**
```sql
SELECT cat_cd,cat_nm,COALESCE(upr_cat_cd,'NULL'),cat_lvl FROM t_cat_categories
  WHERE cat_cd IN ('CAT_000012','CAT_000273','CAT_000274','CAT_000275','CAT_000283','CAT_000295','CAT_000296');
```
| cat_cd | cat_nm | upr | lvl | 분류 |
|--------|--------|-----|:--:|------|
| CAT_000012 | 포장 | NULL | 1 | 루트 |
| CAT_000273 | 인쇄배경지(OPP봉투타입) | CAT_000012 | 2 | **정상** |
| CAT_000274 | 인쇄배경지(투명케이스타입) | CAT_000012 | 2 | **정상** |
| CAT_000275 | 인쇄헤더택 | CAT_000012 | 2 | **정상** |
| CAT_000283 | 라벨/포장스티커 | CAT_000012 | 2 | **정상** |
| CAT_000295 | 상품권 | NULL | 3 | **고아** |
| CAT_000296 | 배경지 | NULL | 3 | **고아** |

포장(012) 하위 정상노드 전수 = 273·274·275·276(봉투/케이스)·283·285(포장부자재)·287(상품액세서리) 7노드. 보정 산출의 정상/고아 구분이 라이브와 **완전 일치**. (1차에서 누락됐던 273/274/275/283 정상노드 존재가 F-ID-3·L-H·extraction-plan에 정확히 반영됨.)

**② 상품 연결(043~046→296·041/042→295) — 독립 재실측:**
```
PRD_000041→CAT_000295  PRD_000042→CAT_000295  (상품권 고아)
PRD_000043→CAT_000296  PRD_000044→CAT_000296  PRD_000045→CAT_000296  PRD_000046→CAT_000296  (배경지 고아)
고아 연결 수: CAT_000295=2 · CAT_000296=4 | 정상노드 273/274/275 연결 수: 0 (전부 비어있음)
```
보정 서술 "상품이 정상노드를 두고 잉여 고아에 묶임"이 라이브 정확. 정상노드 273/274/275에 상품 0건 = 보정의 "정상노드는 비어있고 상품은 고아에" 진단과 일치.

**③ 교정 방향 = 기존 정상노드 재연결(search-before-mint):** C-09 "043→CAT_000273·044→CAT_000274·045→CAT_000275 재연결(UPDATE)", C-14 "046→CAT_000283 재연결" — 노드명 의미 매칭(273=OPP봉투↔배경지OPP·274=투명케이스↔케이스타입·275=헤더택↔헤더택·283=라벨/포장스티커↔라벨택) 정확. "296 upr UPDATE는 차선(잉여노드 잔존)" 명기 = 신규 부여 회피·기존 정상행 재사용 = search-before-mint 원칙 정정 완료. 적재경로 인용 `load_rel_categories(load_master.py:282-291)` Read 검증 = 실존·`11_상품별카테고리`→`t_prd_product_categories` 정확.

**④ 명함=10·합=36:** `product-identity.md:18` 명함 10·`:23` 각주 "엽서8·포토카드3·접지카드4·명함10·상품권2·배경지4·인쇄홍보물5 = 36" 정정 확인. 원본 `후니프린팅_상품마스터_260610.xlsx 디지털인쇄` distinct 36·L1 distinct 36과 일치. 자기모순(11/합37) 해소.

**⑤ scope — 다른 발견 미변경:** MISSING 결함 행수 = 9건 유지(C-07~C-13). 보정은 카테고리 발견(F-ID-3·L-H·C-09·C-14·축⑥·live-diff 카테고리)만 수정, C-07~C-13 MISSING/MIS-LOADED·C-04 addon·C-06 박부모는 미변경. scope 위반 0.

### 최종 매트릭스 (K0 재게이트 후)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS(재게이트) | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |

**디지털인쇄 파일럿 최종 판정: GO.** K0~K6 전건 PASS. 잔존 컨펌 4건(Q-ID-A/B·Q-DP-C·Q-DP-B)은 인간 결정 대기. 교정 실행(재연결 UPDATE·MISSING INSERT·고아 논리정리)은 round-5/10 트랙 인간 승인 — DB 미적재 유지. **본 재게이트 DB 쓰기 0**(read-only SELECT + 소스 Read만).
