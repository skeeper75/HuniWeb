# 포토북 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/photobook/` 5종(product-identity·loadlogic-notes·extraction-plan·live-diff·correction-manifest).
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 SELECT) 동반. 발견 결함은 라우팅만(산출물 직접 수정 금지). NEVER COMMIT/DDL/DELETE.
> **권위:** oracle 인용 실재성은 `raw/webadmin/` 직접 Read 검증, 라이브 값은 독립 read-only psql 재현(`.env.local RAILWAY_DB_*`·비번 비노출).

---

## 0. 최종 판정: **GO** (보정 후 재게이트 — 2026-06-11)

> **갱신 이력:** 1차(2026-06-11) = CONDITIONAL-GO(K2 ⚠️·F-PB-1 BLOCKER·F-PB-2 MAJOR·F-PB-3 MINOR 적발). `dbm-correctness-auditor` 보정 3건 완료 후 **K0~K2 재게이트(2026-06-11) = 전건 PASS** → 포토북 **GO**. K3~K6은 1차 PASS carry-forward(재검 불요). 상세 재판정은 §10.

> **재게이트 근거:** 1차 적발 dodge-hunt 2건(F-PB-1 oracle 날조·F-PB-2 재연결 오매핑)이 보정 완료·독립 재실측으로 정확성 확인됨. **F-PB-1**=PB-M3 정답값 "소프트 4~14" 4종 산출 전건 삭제(잔존 "4~14"는 전부 '추정 오인용·삭제' 문맥, 정답값 단언 0건) + MISSING→PB-A2(AMBIGUOUS/GAP) 재분류 + 분류 분포 MISSING 3→2·AMBIGUOUS/GAP 1→2 + 라이브 24/150/2 "엑셀 유일 page 행 충실 적재·오적재 아님" 명기. **F-PB-2**=PB-C1 how를 `UPDATE t_mat_materials SET mat_typ_cd='MAT_TYPE.06' WHERE mat_cd IN ('MAT_000006','MAT_000186')`(prd_cd 재연결 아님)로 재서술 + note 출처 모순(MAT_000008="책자 표지 자재"·MAT_000173="IMPORT base root" → 끌어오기 금지) 명기. **F-PB-3**=SDI 453 인용을 "용도=표지까지·자재유형 단정은 override+라이브 .06"으로 교체. **보정값 라이브 재확인:** MAT_000006 note="포토북 표지 자재"·MAT_000008 note="책자 표지 자재"·MAT_000173 note="IMPORT 약어/base 기준 root"·MAT_000186 6상품 카운트 — 전건 라이브 일치. 교정 매니페스트는 비파괴·search-before-mint 준수 — 적재 트랙 진입 안전(컨펌 Q1~Q5 + PB-C4 인간 승인 대기·DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체(1상품+12 variant) | ✅ **PASS** | PRD_000100 단일(폭증 없음)·반제품 7·CAT_000108→CAT_000006 정상(고아0)·editor Y — 독립 SELECT 8행 일치. 디지털인쇄 인쇄배경지 오분류 같은 사건 부재(반증 정당) |
| **K1** 커버리지(variant×5속성축·빈칸0) | ✅ **PASS** | 1논리상품×5속성축 전수, 반제품 N/A 사유 명기(parent 권위 SDI 348), 비속성축(가격·page·생산메타) 별도 귀속. 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ **PASS**(재게이트) | load_master 핵심 라인 전건 실재(§2). **F-PB-1 해소**: "소프트 4~14" 4종 산출 전건 삭제·정답값 단언 0건(추정 오인용 문맥만)·PB-A2 재분류·분포 MISSING 3→2. **F-PB-3 해소**: SDI 453 인용을 override+라이브 .06으로 교체. 잔존 인용 날조/과장 0 |
| **K3** 적재로직 근거 | ✅ **PASS** | MIS-LOADED/MISSING 원인이 실제 코드 라인(override 슬러그 불일치·`_yn` 빈값→N·가격 함수 부재)으로 재구성. 적재경로 불명(qty_unit) 정직 표기 (1차 carry-forward) |
| **K4** 라이브 실측 독립 재현 | ✅ **PASS** | 14개 표본(상품8·카테고리·materials7·레더3-way·MAT_000186 6상품·proc·size4·page·print2·sets7·가격0·코팅family·펼침siz7) 전건 독립 SELECT 동일 재현 (1차 carry-forward) |
| **K5** 비파괴·search-before-mint | ✅ **PASS** | COMMIT/DDL/DELETE 0·EXTRA 0. **F-PB-2 보정으로 PB-C1 교정=mat_typ_cd UPDATE(prd_cd 재연결 아님)·고아행 끌어오기 차단** — search-before-mint 정합 (1차 carry-forward + F-PB-2 해소) |
| **K6** 오모델 정합 | ✅ **PASS** | 자재=parent+usage_cd·복합표기 분해·코팅=공정(Q9)·별색≠도수·책등=앱계산·반제품 빈껍데기 = SDI 348/398/409 정합. 코팅 family 이탈 적발이 핵심 (1차 carry-forward) |

---

## 1. K0 — 상품 정체 (PASS)

product-identity가 포토북을 **1 논리상품(PRD_000100) + 반제품 7(내지1·표지5·면지1) B셋트**로 확정. 라이브 독립 재현:

```
PRD_000100  포토북 [디자인명]            PRD_TYPE.04  (완제품)      editor=Y  qty_unit=QTY_UNIT.03  MES=NULL
PRD_000101  …-내지(몽블랑130)            PRD_TYPE.02  SEMI_ROLE.01  N
PRD_000102~107  표지5/면지1               PRD_TYPE.02  SEMI_ROLE.02/03  N
categories: CAT_000108 포토북 → 상위 CAT_000006(06 책자), main=Y  ← 고아 없음
```

- **정체 폭증 없음:** 디자인명 3종(심플모던/여행/큐티키즈)을 3상품으로 폭증 안 함 = PRD_000100 단일 = 정합. variant(size 4 × 표지 3)는 size 차원·표지 sub_prd로 흡수.
- **카테고리 고아 0 반증 확정:** 디지털인쇄 family의 043~046→CAT_000296 고아 같은 결함이 포토북엔 **부재**(CAT_000108 정상 부모 CAT_000006). PB-OK-2 정당.
- **정체 단계 🔴 0건** — K0 PASS.

---

## 2. K2 — oracle 인용 실재 (CONDITIONAL — 날조 1·과장 1 적발)

### 2.1 실재·내용 일치 확인 (PASS 측면)

`raw/webadmin/tools/load_master.py` 직접 Read로 전건 검증:

| 산출물 인용 | 실제 코드 | 판정 |
|-------------|-----------|------|
| `MAT_TYP_OVERRIDE` 4슬러그(레더하드커버 A/A4/A5=가죽·전용지=종이) L116~121 | L116~121 byte-identical | ✅ 실재 |
| `ENUM_ALIAS ("MAT_TYPE","실사")→"실사소재"` L109~113 | L110 정확 | ✅ 실재 |
| `load_materials` mat_typ override 분기 L237~239 | L237~239 정확 | ✅ 실재 |
| `load_rel_sizes` L307(13시트) / `load_rel_materials` L318(14시트) | L307·L318 정확 | ✅ 실재 |
| `load_rel_print_options` opt_id 순번·ACRYLIC 전개 L352·L357~359 | L352·L357~359 정확(주석 라인은 L360~361, 미세 오프셋·내용 일치) | ✅ 실재 |
| `load_rel_processes` `_yn(필수공정여부)` L416 | L416 정확 | ✅ 실재 |
| `load_rel_sets` L424 / `load_rel_page_rules` L447 | L424·L447 정확 | ✅ 실재 |
| **가격 적재 함수 부재** (MASTERS L461·RELATIONS L469) | grep `price\|prc_\|template_prices` = 0건. MASTERS/RELATIONS 어디에도 가격 로더 없음 | ✅ 실재(PB-M1 근거 확정) |
| SDI 348(자재=parent+usage·복합표기 분해·코팅=공정)·398(제본 Q10 PUR)·409(고정가형·포토북·t_prd_product_prices) | line 348·398·409 실존·내용 일치 | ✅ 실재 |

### 2.2 F-PB-1 [oracle 날조 — 소프트 page 4~14가 엑셀 L1에 부재] **BLOCKER**

> **라우팅:** `dbm-correctness-auditor` (PB-M3 분류·근거 정정)

- **무엇:** loadlogic-notes §4·L132·extraction-plan §6·live-diff §3·correction-manifest PB-M3가 모두 "엑셀 L1 = 하드/레더하드 24~150·**소프트 4~14**(C15 표지타입별 차등)"을 **L1 권위로 단언**.
- **독립 검증(`06_extract/photobook-l1.csv` 전 12 데이터행 직접 파싱):**
  ```
  seq  size            표지타입       pmin pmax pincr  base
  3    8x8             하드커버       24   150  2      15000
  4    (8x8)           레더하드커버   (공란)(공란)(공란) 23000
  5    (8x8)           소프트커버     (공란)(공란)(공란) 12000   ← page 전부 빈값
  9    A5              하드커버       24   150  2      12000
  11   (A5)            소프트커버     (공란)(공란)(공란) 10000   ← page 전부 빈값
  ...(하드커버 행만 24/150/2, 레더·소프트 행은 page 전 공란)
  ```
  추가 `grep -E "4~14|4-14"` photobook-l1.csv = **0건**.
- **결론:** **"4~14"는 엑셀 L1 어디에도 없다.** 산출물이 "L1 C15 표지타입별 차등"으로 인용한 출처가 photobook-l1.csv가 아니다 — round-13 정답 oracle(엑셀 L1)에서 검증되지 않는 값을 권위로 단언한 **인용 날조**.
- **파급 — PB-M3 분류 부정확:** L1에 소프트 page 값 자체가 없으므로, 라이브의 단일 행 24/150/2는 "load_master가 소프트 4~14를 빠뜨림(MISSING)"이 아니다. 정확한 분류는 **"L1에 소프트/레더 page 미기재 → 출처 불명·확인 필요(AMBIGUOUS)"** 또는 "엑셀에 차등 정보 부재(GAP)". MISSING으로 두면 존재하지 않는 정답값(4~14)을 적재하려다 오적재 유발.
- **how(보정 제안):** PB-M3의 정답값에서 "4~14"를 삭제하고 출처(엑셀 외 어디서 왔는지)를 명기하거나, "L1 미기재 → 소프트 page_rule 정답 미확정(컨펌)"으로 재분류. 표지타입별 차등 page 자체가 L1 권위 아님을 표기.

### 2.3 F-PB-3 [인용 과장 — SDI 453 "레더=가죽" 단언] MINOR

> **라우팅:** `dbm-correctness-auditor` (근거 출처 정정·권위 보강)

- **무엇:** extraction-plan §2·correction-manifest PB-C1 why가 "레더 자재유형 = .06 가죽"의 oracle로 **SDI 453(Q4)** 를 단언.
- **독립 검증(SDI line 453):** line 453 원문 = `자재 용도(Q4) | 자재 등록 + 상품별 자재 용도 명기. 레더도 용도=표지 | t_prd_product_materials.usage_cd`. → **"용도=표지"만 명시, "자재유형=가죽(.06)"은 line 453에 없음.**
- **실제 정답 oracle(라이브 실측이 더 강함):** `MAT_TYP_OVERRIDE` L118~120("레더하드커버 A→가죽") + 가죽 고아행 4개 mat_typ=.06 라이브 실측. 즉 "레더=가죽"은 **load_master override 결정 + 라이브 .06 행**이 권위이지 SDI 453이 아니다.
- **파급:** 결론(레더=.06 가죽)은 **정확**(다른 oracle로 입증됨). 단 인용 출처만 과장 — 보정 시 SDI 453을 override+라이브 .06으로 교체하면 견고. 심각도 MINOR(결론 무영향).

---

## 3. K3 — 적재로직 근거 (PASS)

각 MIS-LOADED/MISSING의 원인이 실제 코드 경로로 재구성됨, 라이브 재현과 정합:

| 결함 | 적재로직 원인(라인) | 라이브 재현 | 판정 |
|------|---------------------|------------|------|
| 레더 .01/.08 오분류·.06 고아 | override 슬러그 "레더하드커버 A/A4/A5"만 가죽화(L116~121), 포토북이 연결한 MAT_000006("A"없음)·MAT_000186은 미적용 + ENUM_ALIAS 실사(L110) | MAT_000006 .01·MAT_000186 .08·008/173/174/175 .06 linked=0 | ✅ 정확 |
| PUR mand=N | `_yn(필수공정여부)` 빈값→N(L416·L80) | PROC_000020 PUR mand_proc_yn=N | ✅ 정확 |
| 가격 0행 | load_master 가격 함수 부재(MASTERS/RELATIONS) | product_prices·price_formulas 0행 | ✅ 정확 |
| 코팅 평면화 | 자재명 그대로 전파(L236), 코팅 분해 로직 없음 | MAT_000250 "아트250+무광코팅" .01·포토북 코팅 공정 미연결 | ✅ 정확 |
| qty_unit 적재경로 불명 | L269 NULL 강제인데 라이브 .03 존재 = 별도 backfill | qty_unit_typ_cd=QTY_UNIT.03 | ✅ 정직 표기 |

- v03 directive 준수: 모든 MIS-LOADED 진원을 상류 v03 중복 슬러그로 귀속, load_master=충실 전파기. `models.py` 미인용. **K3 PASS.**

---

## 4. K4 — 라이브 실측 독립 재현 (PASS — 전건 일치)

독립 read-only psql(2026-06-11)로 산출물 우변값 전건 재현. **추출본 의존 0.**

| 항목 | 산출물 주장 | 독립 SELECT 재현 | 판정 |
|------|------------|------------------|------|
| 상품·반제품 8행 | .04+반제품7·editor Y·MES NULL | 동일 | ✅ |
| materials 7행 mat_typ | 105/005/007/251 .01·250 .01·006 .01·186 .08 | 동일 | ✅ |
| 레더 3-way | 006(.01,linked=1)·008/173/174/175(.06,linked=0)·186(.08,linked=6) | 동일 | ✅ |
| **MAT_000186 6상품** | 077·088·100·126·174·175 | 077·088·100·126·174·175 **정확** | ✅ 카운트 과대 아님 |
| processes | PROC_000020 PUR mand=N | 동일(`excl_grp_cd` 컬럼은 라이브 부재) | ✅ |
| sizes 4 | 170/172/269/274 cut=work impos=N | 동일(완성품 cut=work 확인) | ✅ |
| page_rules | 24/150/2 단일 행 | 동일 | ✅ |
| print_options 2 | opt1 양면(CLR5/CLR5)·opt2 단면(CLR5/CLR1) | 동일 | ✅ |
| sets 7행 | 101~107 note 용도 | 동일 | ✅ |
| 가격 0행 | product_prices·price_formulas 0 | 둘 다 0·t_prd_template_prices 테이블 실재(Phase11) | ✅ |
| 코팅 family | 책자68~72·82 PROC_000015 분리·포토북 부재 | 동일(책자 전건 무광 연결·PRD_000100 코팅 목록 부재) | ✅ |
| 펼침 siz 7종 | 272/273/277~281 work만·미연결 | 동일·product_sizes 연결 0 | ✅ |

- **메모(산출물 §6.2 축약):** 만년다이어리 외 172/176/177/178/179/181도 PROC_000015 무광 연결(산출물은 173만 표기). **결론(포토북만 코팅 미연결) 무영향**이나 family 표가 일부 축약됨 — MINOR, 라우팅 불요. **K4 PASS.**

---

## 5. K5 — 비파괴·search-before-mint (PASS, 단 F-PB-2 보정 권고)

- COMMIT/DDL/DELETE 0·EXTRA 0. 교정은 전부 "제안"까지. 가죽 고아행 재사용(신규 자재 mint 0) 방향 = search-before-mint 준수.
- **단 재사용 대상 선택이 F-PB-2(아래 dodge)로 보정 필요.** 비파괴 원칙 자체는 위반 없음 → K5 PASS.

---

## 6. K6 — 오모델 정합 (PASS)

| 오모델 축 | 정답 정합 | 라이브 증거 | 판정 |
|-----------|-----------|-------------|------|
| 자재=parent+usage_cd·반제품 빈껍데기 | SDI 348/360 | 101~107 9속성 0행 | ✅ |
| 복합표기(아트250+무광) 분해·코팅=공정 | SDI 348·Q9 | 책자류 PROC_000015 분리 vs 포토북 평면화(family 이탈 적발) | ✅ 핵심 발견 |
| 별색≠도수 | CLR 도수=옵션 내 컬럼 | print_options front/back CLR | ✅ |
| 책등=앱 런타임 계산(DB 미저장) | MEM compute-in-app | prcs_dtl_opt 빈값 | ✅ |
| 고정가형=t_prd_product_prices | SDI 409 | (가격 미적재·목표 테이블 컨펌 정당) | ✅ |

**K6 PASS** — 오모델 렌즈로 코팅 family 이탈·자재유형 혼재를 정확히 포착.

---

## 7. 2-pass dodge-hunt (표본 독립 재실측)

| dodge 유형 | 검증 표본 | 결과 |
|-----------|-----------|------|
| **분류 정반대(MISSING↔MIS-LOADED)** | PB-M3 소프트 page | **F-PB-1 적발** — "MISSING(소프트 4~14)"의 정답값(4~14)이 L1 부재 → MISSING 분류 부정확(AMBIGUOUS/GAP가 맞음). §2.2 |
| **카운트 과대** | MAT_000186 6상품 횡단·아트250 중복 슬러그 | **과대 아님** — 186 linked=6(077/088/100/126/174/175 정확)·250 linked=1·260 linked=7·172 linked=0 전건 라이브 일치 |
| **재연결 오매핑(코드번호≠노드순)** | PB-C1 가죽 고아행 권장 대상 | **F-PB-2 적발** — note가 권장과 모순(아래) |

### F-PB-2 [재연결 오매핑 경계 — 가죽 고아행 권장이 note와 모순] **MAJOR**

> **라우팅:** `dbm-correctness-auditor`(권장 방향 정정) → 컨펌-Q1(인간 결정)

- **무엇:** extraction-plan §2 비고·correction-manifest PB-C1 how가 레더 .06 교정 시 **"레더하드커버→MAT_000173, 레더→MAT_000008 권장(이름 정합)"** 제안.
- **독립 검증(가죽 고아행 4개 note 전수):**
  ```
  MAT_000006  레더하드커버      .01 종이  note="포토북 표지 자재"    linked=1 (PRD_000100, 현재 오분류)
  MAT_000008  레더             .06 가죽  note="책자 표지 자재"     linked=0
  MAT_000173  레더하드커버 A    .06 가죽  note="IMPORT 약어/base 기준 root (2 자식)" linked=0
  MAT_000174  레더하드커버 A5   .06 가죽  upr=MAT_000173  linked=0
  MAT_000175  레더하드커버 A4   .06 가죽  upr=MAT_000173  linked=0
  MAT_000186  레더(화이트)      .08 실사  (note 없음)  linked=6
  ```
- **모순:** 권장된 `MAT_000008`의 note = **"책자 표지 자재"** (포토북용 아님). `MAT_000173`은 IMPORT base root(만년다이어리/책자 계열 자식 2개). 한편 **현재 포토북이 연결한 `MAT_000006`의 note는 이미 "포토북 표지 자재"** — 즉 자재행 자체는 포토북 전용이고 **틀린 건 mat_typ_cd(.01)뿐**이다.
- **더 정확한 교정(재연결 오매핑 회피):** 포토북 레더 표지는 prd_cd를 다른 family 가죽 고아행(008=책자용)으로 **바꾸지 말고**, 이미 연결된 MAT_000006(note=포토북 표지 자재)의 **mat_typ_cd를 .01→.06으로 교정**하는 편이 note·생산 BOM 정합. MAT_000186(.08·6상품 횡단)도 mat_typ 교정 또는 횡단 통합 결정.
- **why MAJOR:** 자재행 재연결은 생산 BOM 라우팅 근간 — "이름 정합(레더하드커버↔레더하드커버 A)"만 보고 family 출처(note)를 무시하면 책자용 자재를 포토북에 끌어옴. 산출물이 컨펌-Q1로 열어두긴 했으나 **권장 방향이 note와 모순됨을 명시 안 함**.
- **how(보정):** PB-C1 how를 "기존 MAT_000006(포토북 전용)·MAT_000186의 mat_typ_cd만 .06으로 교정(prd_cd 재연결 아님), 횡단 6상품 통합 결정"으로 재서술. 컨펌-Q1에 note 출처 모순 명기.

---

## 8. 라우팅 (auditor 보정 대상)

| ID | 결함 | 심각도 | 라우팅 | 보정 내용 |
|----|------|:--:|--------|-----------|
| **F-PB-1** | 소프트 page 4~14 = L1 부재(oracle 날조) | **BLOCKER** | `dbm-correctness-auditor` | PB-M3 정답값에서 4~14 삭제, MISSING→AMBIGUOUS/GAP 재분류, 출처 명기 |
| **F-PB-2** | 가죽 고아행 권장이 note와 모순(재연결 오매핑) | **MAJOR** | `dbm-correctness-auditor`→컨펌-Q1 | PB-C1 how를 "mat_typ만 .06 교정(재연결 아님)"으로 재서술, note 출처 모순 명기 |
| **F-PB-3** | SDI 453 "레더=가죽" 인용 과장 | MINOR | `dbm-correctness-auditor` | oracle을 override+라이브 .06으로 교체(결론 무영향) |
| (참고) | 코팅 family §6.2 표 축약(173만) | MINOR | (보정 불요) | 결론 무영향, 정보 보존만 |

### auditor 원본 라우팅(검증 통과·유효 carry-forward)
- **PB-C1 → 컨펌-Q1 + load-execution:** 레더 자재유형 .06 교정 — 방향 유효(단 F-PB-2로 how 보정)
- **PB-C2 → 컨펌-Q2 + ddl-proposer + load-execution:** 아트250 코팅 분해·중복 슬러그 통합 — **유효**(라이브 250/260/172 중복 재현)
- **PB-C3 → 교정 직접(단순 UPDATE):** PUR mand N→Y — 유효(단 `excl_grp_cd` 컬럼 라이브 부재라 "excl_group 불요" 서술은 무의미·무영향)
- **PB-M1 → 컨펌-Q3 + round-2 dbm-price-formula:** 가격 전체 미적재 — **유효**(0행 재현)
- **PB-M2 → 컨펌-Q2 + load-execution:** 코팅 공정 미연결 — 유효(family 이탈 재현)
- **PB-M3 → 컨펌-Q4:** 소프트 page — **F-PB-1로 정답값 자체 재검 필요**(라우팅 보류)
- **PB-A1 → 컨펌-Q5:** 표지 펼침 siz 미연결 — 유효(7종 미연결 재현)

---

## 9. 결산

- **K0/K1/K3/K4/K5/K6 PASS · K2 CONDITIONAL** → 최종 **CONDITIONAL-GO**.
- **dodge-hunt 적발 2건(F-PB-1 oracle 날조·F-PB-2 재연결 오매핑) + 인용 과장 1(F-PB-3).** 핵심 결함(레더 3-way·MAT_000186 6상품·코팅 family·가격 0행)은 라이브 전건 재현 — **방법론 견고**.
- **보정 후 재게이트:** F-PB-1/F-PB-2 보정 시 K2 PASS 승격 → GO. K0/K1/K3/K4/K5/K6은 carry-forward(재검 불요).
- **DB 미적재[HARD]:** 본 게이트는 검증·라우팅까지. 실 UPDATE/INSERT/가격 적재/논리삭제는 round-5/6 + 인간 승인. 컨펌 Q1~Q5 + PB-C4(qty_unit 경로) 인간 결정 대기.
