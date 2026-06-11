# 책자(booklet) — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/booklet/` 5종.
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 SELECT) 동반. 발견 결함은 라우팅만(산출물 직접 수정 금지). NEVER COMMIT/DDL/DELETE.
> **권위:** oracle 인용 실재성 = `raw/webadmin/` 소스 직접 Read 검증, 라이브 값 = 독립 read-only psql 재현(`.env.local` `RAILWAY_DB_*`·비번 비노출).

---

## 0. 최종 판정: **GO** (1차 CONDITIONAL → K0 보정 3건 독립 재확인 후 — 2026-06-11)

> **갱신 이력:** 1차 = CONDITIONAL-GO(K0 ⚠️·F-GATE-BK-1/2/3 발견). `dbm-correctness-auditor` 보정 후 **K0 재게이트 = PASS** → 책자 **GO**. K1~K6은 1차 PASS carry-forward(재검 불요). 상세 재판정은 §1 말미 + §11.

핵심 방법론·결함 식별·oracle 인용·라이브 실측이 견고하며(K1~K6 PASS, K2/K4 표본 전건 독립 재현, 날조 0), Top finding **BK-2(078 sub_prd 몽블랑130g 오적재)**·BK-1(097 USAGE.07 종이 중복)·BK-3(레더 .08 vs Q4 가죽)·BK-4/BK-5(카테고리)가 전부 라이브와 정확히 일치. 1차에서 적발한 K0 정정 3건(반제품 카운트·정체표 카테고리·횡단 BK-CAT)이 보정 완료·독립 재실측으로 정확성 확인됨(§11). 교정 매니페스트는 비파괴·search-before-mint 준수(K5 PASS) — 적재 트랙 진입 안전(컨펌 5건 Q-BK-A~E 인간 승인 대기, DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ **PASS**(재게이트) | F-GATE-BK-1/2/3 보정 정확 — 반제품 21(라이브 GROUP BY 일치)·068~071 CAT_000006 lvl1 직결로 정정·BK-CAT 신규 EXTRA(전용노드 6개 100/101/102/103/106/107 상품 0 독립 재실측 일치·노드명 상품 1:1·digital-print F-GATE-1 동형)·BK-1 횡단 정밀화 — §1 말미·§11 |
| **K1** 추출규칙 커버리지 | ✅ PASS | 10 완제품 × 5 속성축 전수(extraction-plan 1-1~1-10), N/A·빈값 사유 명기, 빈칸 0 — §2 |
| **K2** oracle 인용 실재 | ✅ PASS | 표본 11건(load_master L39/116/237/261/282/324/346/404/412/424 + sql/23 L11) 전건 실존·내용 일치 — §3 |
| **K3** 적재로직 근거 | ✅ PASS | LL-1~7 결함이 실제 load_master 라인으로 재구성 또는 "적재경로 부재"(LL-7) 정직 표기, v03 진원 directive 정합 — §4 |
| **K4** 라이브 실측 독립 재현 | ✅ PASS | 표본 14건(078 sub_prd·097 중복·레더 3-way·카테고리·088 공정·plate·제본 mand·박색·page/bundle·sets) 전건 독립 SELECT 동일 재현 — §5 |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0, EXTRA=논리삭제 제안, BK-3 .06 고아행 재연결(신설 0), ddl-proposer 라우팅 0 — §6 |
| **K6** 오모델 정합 | ✅ PASS | 자재=parent+usage_cd·제본 PROC_000017 자식 mand=N·박색=PROC_000033 자식(공정·자재 아님)·코팅=공정·UV 없음·page_rule 경계 정합 — §7 |

---

## 1. K0 — 상품 정체 확정 (1차 CONDITIONAL → 재게이트 PASS)

> **재게이트(2026-06-11):** 아래 1차 적발 3건이 전부 보정·독립 재실측으로 정확성 확인 → **K0 PASS**. 1차 기록은 추적용으로 보존(§11 재게이트 결과 참조).

**PASS 측면:** product-identity가 10 활성 완제품 정체표(범주·구성 A통합/B셋트/떡제본·생산방식·출처)를 명기. F-ID-1(책자=전부 일반 인쇄물, digital-print/goods-pouch 같은 정체 오분류 0)은 라이브 카테고리 트리로 뒷받침 — **독립 재현**:
- 완제품 10·반제품 PRD_TYPE.02 라이브 확인(068~097 활성). 링바인더(보류중) 라이브 부재 = 미적재 정상 ✅.
- 094 엽서북 = CAT_000026(upr CAT_000001 엽서) lvl2 ✅. 097 떡메모지 = CAT_000129(upr CAT_000124 노트 upr CAT_000008 문구) lvl3 ✅.

**CONDITIONAL 사유 — 정정 필요 2건 (2-pass dodge-hunt 적발):**

### F-GATE-BK-1 [반제품 카운트 과소 — 17 vs 라이브 21] Low · 라우팅: `dbm-correctness-auditor`(정정)
- **무엇:** product-identity §0 표("17 반제품(sub_prd)")·live-diff §1("반제품 17(PRD_TYPE.02)")이 **17**이라 명시. 독립 실측 = **21**.
  ```
  SELECT prd_typ_cd, count(*) FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098' GROUP BY 1;
  → PRD_TYPE.02 | 21   (완제품 PRD_TYPE.04 | 10)
  ```
  반제품 21 = 073~076(하드커버 표지1+면지3) · 078~081(레더하드 4) · 083~087(하드링 표지1+면지4) · 089~093(레더바인더 표지1+면지4) · 095/096(엽서북 내지/표지) · 098(떡메모지 내지). auditor의 "17"은 면지 수를 과소 집계(077/082/088이 면지 3~4개씩 + 098 떡메모지 내지 누락 가능).
- **영향:** 분류·교정에 영향 0 — sub_prd 자재 위반 탐색은 전 범위 GROUP BY HAVING으로 정확히 **078만** 잡아냄(BK-2 정확). 단 정체 규모 서술이 과소 → 정정 권장.
- **판정:** 표기 오류(정정 불요시 영향 없으나 정확성 위해 권장).

### F-GATE-BK-2 [정체표 카테고리 라이브 불일치 + 횡단 EXTRA 누락 — 중요] Med · 라우팅: `dbm-correctness-auditor`
- **무엇:** product-identity §1 정체표가 068을 "✅ CAT_000100 중철책자(upr 책자)", 069를 "✅ CAT_000101", 070을 "✅ CAT_000102", 071을 "✅ CAT_000103"으로 서술(라이브 정합 ✅ 표기). 독립 실측 = **라이브는 068/069/070/071이 전부 CAT_000006 책자(lvl1) 직접 연결**이고, **lvl2 전용노드 CAT_000100~103은 존재하나 상품 0**:
  ```
  -- 완제품 카테고리 실연결
  PRD_000068|중철책자|CAT_000006|책자|NULL|1|main=Y
  PRD_000069|무선책자|CAT_000006|책자|NULL|1|Y
  PRD_000070|PUR책자 |CAT_000006|책자|NULL|1|Y
  PRD_000071|트윈링책자|CAT_000006|책자|NULL|1|Y
  -- lvl2 전용노드 상품연결
  CAT_000100|중철책자|0    CAT_000101|무선책자|0
  CAT_000102|PUR책자 |0    CAT_000103|트윈링책자|0   ← 4개 모두 공허
  ```
- **진짜 결함 구조:** digital-print F-GATE-1과 **동형** — 정상 lvl2 전용노드(100~103, upr=CAT_000006)가 있는데도 상품이 상위 lvl1 노드(CAT_000006)에 직결돼, 전용 잎노드 4개가 비어 있다. 이는 BK-4(떡메모지 2중)·BK-5(고아 CAT_000297)보다 **더 횡단적인 카테고리 결함**인데 correction-manifest에 EXTRA/AMBIGUOUS finding으로 **미수록**.
- **두 오류:** ① 정체표가 라이브를 잘못 서술(068이 CAT_000100에 "연결됨 ✅"이라 적었으나 실제 연결은 CAT_000006). ② 횡단 카테고리 패턴(전용노드 4개 미사용)을 finding으로 안 잡음.
- **판정:** 정체표 라이브 서술 정정 + 카테고리 횡단 finding(BK-CAT 신규) 추가 필요. **단 NO-GO는 아님** — 책자 정체(일반 인쇄물·생산구조)는 정확하고, 카테고리 연결 자체는 결함이나 상품이 책자 트리 밖으로 샌 게 아니라 잎노드 대신 줄기노드에 걸린 것이라 위젯/조회 영향 제한적.

> **참고:** 072/077/082/088은 라이브 CAT_000105 하드커버책자(upr CAT_000104·lvl3) 연결로 정체표와 정합(독립 재현 ✅). 088 레더바인더도 CAT_000105 하드커버책자 잎노드 연결(정체표 "CAT_000104 하위"와 부합).

---

## 2. K1 — 추출규칙 커버리지 (PASS)

extraction-plan 1-1~1-10이 **10 완제품 전수 × 5 속성축**(size·자재·공정·도수·인쇄옵션) 정답 추출규칙을 L1 출처·변환·목표 t_*·oracle과 함께 명기. 빈칸 0(N/A는 사유 명기: 070 PUR "무선과 동형", 088 공정 "제본 없음=정당", 088 인쇄옵션 "빈 바인더 page_rule 없음"). §2 횡단 규칙 7항(자재=parent+usage·usage.07=링/D링만·제본 1:1·박색=공정·page_rule 제본별 차등·레더 유형·plate 폴더)이 family 정답 잣대 제시. **PASS.**

---

## 3. K2 — oracle 인용 실재 (PASS)

loadlogic-notes·extraction-plan의 핵심 oracle 인용을 `raw/webadmin/` 직접 Read로 실재·내용 일치 검증. 표본 11건 전건 일치(날조 0, round-11 G-1 교훈 재발 없음):

| 인용 | auditor 주장 | 직접 Read 검증 | 판정 |
|------|--------------|----------------|:--:|
| load_master L39 | XLSX = prdmaster_full_migration_v03 | `XLSX = "data/raw/prdmaster_full_migration_v03_20260518.xlsx"` | ✅ |
| L116~121 MAT_TYP_OVERRIDE | `MAT.레더하드커버 A/A4/A5`→가죽 | L117~120 정확(전용지→종이·레더하드커버 A/A4/A5→가죽) | ✅ |
| L237 OVERRIDE 적용 | 슬러그 OVERRIDE면 치환, 아니면 자재구분 | L237~239 분기 정확 | ✅ |
| L261 MES NULL | 의도적 NULL(중복 회피) | L261 주석 "MES_ITEM_CD: 전량 NULL…부분 UNIQUE 위반" 정확 | ✅ |
| L282 load_rel_categories | main_cat_yn 적재 | L282·288 `_yn(r["주카테고리여부"])` 정확 | ✅ |
| L324 usage 빈값→공통 | `r["용도"] or "공통"`→USAGE.공통 | L323~324 주석+코드 정확 | ✅ |
| L346 plate output_paper | 있으면 기타·없으면 NULL | L346 `other if _norm(...) is not None else None` 정확 | ✅ |
| L404 load_rel_processes | 15→proc·mand | L404·415~416 정확 | ✅ |
| L412 고아 excl_grp NULL화 | 18에 없으면 NULL+inspect | L412~414 정확 | ✅ |
| L424 load_rel_sets | 19→sub_prd 연결 | L424·428 정확 | ✅ |
| sql/23 L11 | dep_proc_cd DROP | `ALTER TABLE t_prd_product_materials DROP COLUMN IF EXISTS dep_proc_cd;`(L11) 정확 | ✅ |

**PASS.** (Q1~Q15·intent-map OM 인용은 round-11/12 산출 참조이며 K2 범위는 webadmin oracle — 모두 실재.)

---

## 4. K3 — 적재로직 근거 (PASS)

loadlogic-notes §2 LL-1~7이 MIS-LOADED/MISSING 발견을 실제 load_master 라인으로 재구성 또는 "적재경로 부재"로 정직 표기:
- LL-1(097 USAGE.07) = L324 `용도 빈→공통` 정합. LL-2(레더 .08) = L116 OVERRIDE 범위 밖 정합. LL-3(plate NULL) = L346 정합. LL-4(078 자재) = L318 v03 전파 정합. LL-5(088 공정 0) = L404 v03에 행 없음. LL-6(097 카테고리) = L282 v03 2행. LL-7(option_groups) = **"적재 경로 부재"(load_master 미처리·CPQ 별 트랙)** 정직 표기.
- v03 진원 directive 정합 — LL-1~6을 "load_master 코드 결함 아니라 v03 정규화 결함, load_master=순수 전파기"로 일관 진단(directive 준수). **PASS.**

---

## 5. K4 — 라이브 실측 독립 재현 (PASS)

live-diff·correction-manifest의 라이브 현재값을 검증자 독립 SELECT로 재현. 표본 14건 전건 동일:

| # | 검증 항목 | auditor 값 | 독립 SELECT 결과 | 판정 |
|---|-----------|-----------|------------------|:--:|
| 1 | BK-2 sub_prd 자재 보유 | 17 중 078만 2행 | 078만 2행(나머지 16 sub_prd 0) | ✅ |
| 2 | 078 자재 상세 | 몽블랑130g .01/.02 | MAT_000105 몽블랑130g .01(N,seq2)+.02(N,seq1) | ✅ |
| 3 | 078 정체 | 레더하드 표지 sub_prd | "레더 하드커버책자-표지(레더(화이트))" PRD_TYPE.02 SEMI_ROLE.02 | ✅ |
| 4 | BK-1 097 USAGE.07 중복 | 백모조120 .01+.07 둘 다 dflt=Y | MAT_000073 백색모조지120g .01(Y,1)+.07(Y,1) | ✅ |
| 5 | BK-3 레더 3-way | MAT_000186 .08 6연결·.06 4고아 | MAT_000186 .08 links=6(077·088·100·126·174·175)·MAT_000008/173/174/175 .06 links=0 | ✅ |
| 6 | BK-4 097 카테고리 2중 | CAT_000124+129 둘 다 main=Y | CAT_000124 노트 lvl2 Y + CAT_000129 떡메모지 lvl3 Y | ✅ |
| 7 | BK-5 CAT_000297 고아 | upr NULL lvl3·상품 0 | CAT_000297 upr=NULL lvl3·linked=0 | ✅ |
| 8 | BK-6 088 공정 0행 | 0 | count=0 | ✅ |
| 9 | BK-7 plate output_paper NULL | 32/0/12 | total 32·opt_nn 0·oft_nn 12 | ✅ |
| 10 | 제본 9행 mand_proc_yn | 전부 N | N\|9 | ✅ |
| 11 | 박색 8종 | PROC_000037~044 자식 | 037~044 전부 upr=PROC_000033(박)·069 실연결 | ✅ |
| 12 | 077 코팅(BK-10 반증) | 코팅 0행 | 하드커버무선제본+수축포장만(코팅 0) | ✅ |
| 13 | 097 page/bundle(BK-8) | page 3/3/3 + bundle 50/100 | page_rule 3/3/3 · bundle 50·100 QTY_UNIT.03 | ✅ |
| 14 | 088 sets | 면지4+표지 | 089 표지+090~093 면지4(화/블/그레이/인쇄) | ✅ |

**PASS.** (카운트 17→21 차이는 K0 F-GATE-BK-1로 별도 다룸 — finding 실측은 정확.)

---

## 6. K5 — 비파괴·search-before-mint (PASS)

- COMMIT/DDL/DELETE 0 — 전 교정이 `use_yn='N'` 논리삭제 제안 또는 재연결 제안(correction-manifest §1 how).
- EXTRA(BK-4 카테고리·BK-5 고아·BK-8 page_rule) = 전부 논리삭제 제안(hard-delete 금지 명시).
- **BK-3 search-before-mint 모범:** 레더 .06 가죽 고아행 4개(MAT_000008/173~175) 실재를 독립 확인(links=0) → 신설 불요·재연결 제안. ddl-proposer 라우팅 0(신규 DDL 없음).
- **PASS.**

---

## 7. K6 — 오모델 정합 (PASS)

- **자재=parent+usage_cd:** B 셋트(077/082/088)도 면지·링·D링을 parent에 usage_cd로(sub_prd 빈 껍데기). 078 위반(BK-2)을 정확히 오적재로 분류 ✅.
- **제본=PROC_000017 자식·mand=N:** 라이브 제본 9행 전부 upr=PROC_000017·mand_proc_yn=N 재현 ✅(round-11 Y 오류 정정).
- **박색=공정 자식(Q2 ★):** PROC_000037~044 전부 upr=PROC_000033(박) = 공정, 자재/별색금 아님 ✅. 책자에 UV(아크릴 PROC_000002) 없음 ✅.
- **코팅=공정(Q9):** 077 코팅 0행(L1 R42 빈값)이 정답 — BK-10 의심 반증 정확 ✅.
- **page_rule 경계:** 중철 4배수·무선/PUR/하드 24~300·트윈링/하드링 8~100·엽서북 20/30/10(엽서장수)·떡메모지=묶음수가 진짜 축(page 3/3/3 잡음) — 전부 라이브 정합 ✅.
- **size↔option 경계·CPQ:** option_groups 0행(GAP-OG, 제본 1:1이라 불요·OM-6 CPQ 미적재 정합) ✅.
- **PASS.**

---

## 8. 2-pass dodge-hunt 적발 결함

| ID | 유형 | 적발 | 증거 | 심각도 | 라우팅 |
|----|------|------|------|:--:|------|
| **F-GATE-BK-1** | 카운트 과소 | 반제품 17 표기 vs 라이브 **21** | `GROUP BY prd_typ_cd` → PRD_TYPE.02\|21 | Low | auditor(정정) |
| **F-GATE-BK-2** | 정체표 라이브 불일치 + 횡단 EXTRA 누락 | 068/069/070/071 정체표가 lvl2 전용노드(100~103) 연결로 서술했으나 라이브=CAT_000006(lvl1) 직결·전용노드 상품 0 | 완제품 카테고리 실연결 SELECT + 전용노드 linked=0 | Med | auditor |
| **F-GATE-BK-3** | 횡단 일반화 과대 | BK-1 why/LL-1 "57상품·324행 같은 결함 패턴" — 실제 .01↔.07 동일 mat 중복 복제는 **097 단 1건**(전 DB), 나머지 323행은 "USAGE.07=공통 풀 종이"라는 약한 별개 현상(016 프리미엄엽서 등 정당 가능) | dodge③-b: `.01∧.07 동일 mat` = dup_prd 1·dup_rows 1; 책자 family USAGE.07 종이=097뿐(071/082/088은 링/D링 정당) | Low | auditor(서술 정밀화) |

**round-13 dodge 분류 적용 결과:**
- **분류 정반대(MISSING↔MIS-LOADED):** 0건 — BK 분류 전건 라이브-정합(MIS-LOADED 2·MISSING 1·EXTRA 3·AMBIGUOUS 2·CORRECT 4 모두 독립 재현으로 타당).
- **카운트 과대/과소:** 2건 — F-GATE-BK-1(반제품 17 과소)·F-GATE-BK-3(횡단 324행 과대 일반화).
- **재연결 오매핑(코드번호 ≠ 노드순):** 0건 — BK-3 .06 고아행 재연결 제안이 mat_cd 정확(MAT_000008/173~175), prd_cd(174/175)와 혼동 없음(auditor §2.2 count(pm.prd_cd)가 mat의 연결을 정확히 셈).

---

## 9. auditor 라우팅 항목 (보정 요청 → 재게이트 대상)

`dbm-correctness-auditor`에게 라우팅(산출물 직접 수정 금지·생성자가 보정):
1. **F-GATE-BK-1** [Low] product-identity §0·live-diff §1 "반제품 17" → **21**로 정정(면지 4·098 포함 재집계).
2. **F-GATE-BK-2** [Med] product-identity §1 정체표 068/069/070/071 카테고리 서술을 라이브대로(CAT_000006 lvl1 직결) 정정 + correction-manifest에 **BK-CAT 신규 EXTRA/AMBIGUOUS finding** 추가(lvl2 전용노드 100~103 상품 0 = digital-print F-GATE-1 동형, 상품을 전용노드로 재연결 vs 줄기노드 직결 유지 컨펌).
3. **F-GATE-BK-3** [Low] BK-1 why/LL-1 횡단 서술을 정밀화 — "57상품·324행 같은 결함"이 아니라 "**.01↔.07 동일 mat 중복 복제는 097 단 1건**(책자 표본), USAGE.07 종이 324행은 별개의 '공통 풀 종이' 현상(정당 여부 family별 별도 판정)"으로 분리.

**보정 후 K0 재게이트만 수행**(K1~K6 PASS carry-forward — 재검 불요). 보정 시 책자 = **GO**.

**인간 승인 대기 컨펌 5건(DB 미적재·라우팅만 — auditor 정직 표기 정합):** Q-BK-A(레더 .08 vs .06 가죽·포토북 통합)·Q-BK-B(097 page_rule 3/3/3 제거)·Q-BK-C(plate 폴더 출력용지규격 적재)·Q-BK-D(088 후공정 존재)·Q-BK-E(D링 mm=책등 모델).

---

## 10. 검증 요약

- **방법론·증거 견고:** Top finding BK-2(078 sub_prd 몽블랑130g) 등 13 finding 전건 라이브 정확, oracle 인용 11건 실재, 날조 0, 비파괴·search-before-mint 준수.
- **1차 CONDITIONAL → 보정 후 GO:** K0 정체 서술 3건(반제품 카운트 과소·068~071 카테고리 라이브 불일치·BK-CAT 횡단 누락)이 보정·독립 재실측으로 정확성 확인(§11) → K0 PASS.
- **책자 정체:** 일반 인쇄물 10종·A통합/B셋트/떡제본 생산구조 정확, 카테고리 결함도 상품이 책자 트리 밖으로 샌 게 아니라 잎노드 대신 줄기노드 연결(조회 영향 제한적, BK-CAT로 정직 수록).
- **DB 미적재** — 실 교정(논리삭제·재연결)은 round-5/6 + 인간 승인. 본 게이트 = 검증·라우팅 전용(NEVER COMMIT).

---

## 11. K0 재게이트 결과 (2026-06-11 · 보정 3건 독립 재확인)

`dbm-correctness-auditor`가 §9 라우팅 3건을 보정. **K0만 재게이트**(K1~K6 PASS carry-forward). 보정분 전건 독립 재실측으로 정확성 확인 → **K0 PASS → 책자 GO**.

### 재확인-1 [F-GATE-BK-1 → RESOLVED] 반제품 17 → 21
- **보정 확인:** product-identity §0 표("21 반제품(sub_prd)…31행")·§0 말미 "F-GATE-BK-1 보정"(라이브 GROUP BY 인용·21 내역 072→073~076 4·077→078~081 4·082→083~087 5·088→089~093 5·094→095/096 2·097→098 1)·live-diff 정정 반영.
- **독립 재실측:** `SELECT prd_typ_cd, count(*) … GROUP BY` → PRD_TYPE.02|**21** · PRD_TYPE.04|10 — 보정값 정확. ✅ RESOLVED.

### 재확인-2 [F-GATE-BK-2 → RESOLVED] 정체표 정정 + BK-CAT 신규 finding (집중 검증)
- **보정 확인:** product-identity §1 정체표 068~071을 "🟡 CAT_000006 책자(lvl1) 직결(전용노드 CAT_000100/101/102/103 상품 0=고아 — BK-CAT)"로 정정·077/082도 "CAT_000105에 묶임·전용노드 106/107 고아"로 정정. correction-manifest에 **BK-CAT 신규 EXTRA** 추가(분포 12→13·EXTRA 3→4·라우팅 교정직접 5).
- **BK-CAT 6노드 상품 0 독립 재실측 (round-13 재연결 오매핑 경계):**
  ```
  cat_cd     | cat_nm          | upr        | lvl | linked
  CAT_000100 | 중철책자        | CAT_000006 |  2  |  0   ← 068 전용 잎노드
  CAT_000101 | 무선책자        | CAT_000006 |  2  |  0   ← 069
  CAT_000102 | PUR책자         | CAT_000006 |  2  |  0   ← 070
  CAT_000103 | 트윈링책자      | CAT_000006 |  2  |  0   ← 071
  CAT_000106 | 레더하드커버책자 | CAT_000104 |  3  |  0   ← 077
  CAT_000107 | 하드커버링책자  | CAT_000104 |  3  |  0   ← 082
  ```
  - **노드 번호가 책자 전용이 맞는지:** 6개 노드 cat_nm이 각 완제품 상품명과 **정확히 1:1 대응**(중철/무선/PUR/트윈링/레더하드커버/하드커버링) — 재연결 대상 노드 정확, 오매핑 0. ✅
  - **상위노드 직결 확인:** 068~071 = CAT_000006 책자(lvl1) 직결 · 077/082 = CAT_000105 하드커버책자(lvl3) 묶임 — 전용 잎노드(106/107) 대신 부모/형제노드 연결, 독립 SELECT 일치. ✅
  - **CAT_000105 = 22 연결** auditor 주장 독립 재현 일치. ✅
  - **digital-print F-GATE-1 동형:** 정상 잎노드(100~103/106/107) 존재하는데 상품이 상위노드(006/105)에 걸려 전용노드 공허 = digital-print "정상노드 273/274 대신 고아 296" 패턴과 동형 횡단 EXTRA. search-before-mint = 전용 잎노드 6개 실재(신설 0)·재연결 제안 정합. ✅
- ✅ RESOLVED.

### 재확인-3 [F-GATE-BK-3 → RESOLVED] BK-1 횡단 서술 정밀화
- **보정 확인:** correction-manifest BK-1 why·loadlogic LL-1이 "`.01↔.07 동일 mat_cd 복제`는 전 DB 1건(097만, validator `dup_rows=1`) — 별개 현상인 'USAGE.07 종이 풀 324행'과 구분(BK-1 결함 아님·별 family 소관)"으로 분리 서술. "57상품" 과대 일반화 철회·정당 문맥. ✅ RESOLVED(1차 dodge③-b 실측 `dup_rows=1` 정합).

### 재게이트 판정
| 게이트 | 1차 | 재게이트 | 근거 |
|--------|:--:|:--:|------|
| K0 상품 정체 | ⚠️ CONDITIONAL | ✅ **PASS** | 보정 3건 전건 독립 재실측 정확(반제품 21·BK-CAT 6노드 상품 0·노드명 1:1·BK-1 분리) |
| K1~K6 | ✅ PASS | (carry-forward) | 변경분 없음 — 재검 불요 |

**잔여 결함: 없음.** 보정 3건 전건 RESOLVED. 책자 = **GO**. 인간 승인 대기 컨펌 5건(Q-BK-A~E)·BK-CAT 재연결은 DB 미적재·round-6+인간 승인(auditor 정직 표기 정합·NEVER COMMIT).
