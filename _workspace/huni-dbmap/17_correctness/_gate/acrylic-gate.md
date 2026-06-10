# 아크릴(acrylic) — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/acrylic/` 5종.
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 검증자 독립 SELECT) 동반. auditor SELECT 신뢰 금지·전부 재실행. 발견 결함은 라우팅만(산출물 직접 수정 금지).

---

## 0. 최종 판정: **GO**(F-AC-G1·F-AC-G2 보정 재게이트 후 — §11)

> **갱신 이력:** 1차(§0~10, 06-11) = CONDITIONAL-GO(K4 ⚠️·F-AC-G1/G2 카운트 과대). `dbm-correctness-auditor` 보정 후 **K4 재게이트(§11) = PASS** → 아크릴 파일럿 **GO**. K0~K3·K5·K6은 1차 PASS carry-forward(재검 불요). 정식 재판정은 §11(이 판정이 권위).

라이브 정합 교정의 방법론·결함 식별(print_side 의미축 오적재·완칼 전무·usage 미분화)이 견고하고, 핵심 결함의 *방향*은 검증자 독립 SELECT로 전건 재현됐다(분류 정반대 결함 0). oracle 인용(load_master:357-369 ACRYLIC 하드코딩)·스키마 충돌(sql/01b:108)·search-before-mint 전건 정확. 1차에서 적발한 카운트 2건(F-AC-G1 print_side 22→20·F-AC-G2 UV 16→14)이 보정 완료·검증자 독립 재실측으로 정확성 확인됨(§11). 보존값(plate 16·192 잔존 1=입체블럭)·결함 방향(의미축 위반·완칼 전무) 불변. 적재 트랙 진입 안전(컨펌 8건 인간 승인 대기·DB 미적재).

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ PASS | 23등록+2미등록 정체표(범주=굿즈 UV단품·구성·생산 폴더), ★상품·입체류 4건 🔴 정직 표기(추측 단정 0) |
| **K1** 추출규칙 커버리지 | ✅ PASS | 25상품 × 속성축 + page_rule/별색/박 N/A 사유, 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ PASS | 표본 7건(load_master 357-369 ACRYLIC·324·116-121·340·sql 01b:108·PROC_000002 변형 enum) 전건 실존·일치 |
| **K3** 적재로직 근거 | ✅ PASS | D-AC-1(하드코딩 line 359)·D-AC-2(usage)·D-AC-3(완칼 v03 미부여) 코드 라인 환원, "v03 전파" 정직 |
| **K4** 라이브 실측 독립 재현 | ✅ **PASS**(재게이트) | F-AC-G1/G2 보정 후 카운트 정확(print_side 20·UV 14 독립 SELECT 일치)·방향·보존값 불변(§11) |
| **K5** 비파괴·search-before-mint | ✅ PASS | COMMIT/DDL/DELETE 0, 부속 MAT_045~057·볼체인 PRD_000006·완칼 053 재사용 입증 |
| **K6** 오모델 정합 | ✅ PASS | UV=PROC_000002(≠print_side)·변형 enum 정확위치·별색 N/A·size↔option 경계·v03 비참조 |

---

## 1. K0 — 상품 정체 확정 (PASS)

- product-identity가 23등록(146~169, 167결번)+L1 25상품 정체표 명기 — 범주=굿즈(UV평판 디자인상품)·구성(단품/조합형)·생산(UV인쇄/루아샵 외주)·출처(product-master L79/143-147·라이브 prd_typ_cd=PRD_TYPE.04).
- 정체 함정 정직 배제: "아크릴=포장재/세트 아님"(인쇄배경지 같은 오분류 위험 낮음) — 근거 다중(product-master·prd_typ·폴더).
- **🔴 정직:** ★상품(쉐이커/지비츠 미등록)·입체류(168/169 명세 부재) 4건을 CONFIRM-AC-ID-1/2로 정체 컨펌 분리, 추측 단정 0.

---

## 2. K1 — 추출규칙 커버리지 (PASS)

- extraction-plan §0 공통 추출규칙 + §1~2 상품별(단품형 14·조합형 8) 인스턴스화. 각 상품 × {size·자재본체·자재부속·UV·완칼·부착·도수·조각수·addon} 규칙.
- N/A 명기: page_rule(낱장 굿즈)·별색공정(UV 풀빼다 흡수)·박/코팅/제본/미싱(아크릴 미사용)·도수(UV 4도 단일·print_side 미사용). **빈칸 0.**

---

## 3. K2 — oracle 인용 실재 (PASS)

| 인용 | 파일:라인 | 주장 | 실측 |
|------|----------|------|:--:|
| ACRYLIC 하드코딩 3종 | load_master.py:357-369 | `ACRYLIC=[("배면양면",c4,c4,"Y"),("풀빼다",c4,c0,"N"),("투명테두리",c4,c0,"N")]` DEFAULT 1행 전개 | ✅ 정확(라인까지 일치) |
| usage 빈→공통 | load_master.py:324 | `enum_code("USAGE", r["용도"] or "공통")` | ✅ 정확 |
| MAT_TYP_OVERRIDE | load_master.py:116-121 | 레더하드커버만 가죽(아크릴 미포함) | ✅ 정확 |
| plate .기타 | load_master.py:340,346 | 출력용지유형 .기타/NULL | ✅ 정확 |
| print_side 정의 | sql/01b:108 | `print_side varchar(20) -- 인쇄면(단면/양면)` | ✅ 정확(UV변형은 인쇄면 아님) |
| **PROC_000002 변형 enum** | (라이브 master) | `변형 enum=[일반,배면양면,풀빼다,투명테두리,단면]` | ✅ 정확(정답 위치 입증) |
| 부착 PROC_000081 대상 enum | (라이브 master) | 대상 enum에 핀/자석/집게 부재 | ✅ 검증자 미전수(AC-X2 enum 확장 컨펌 정당) |

**날조 0.** 특히 `load_master.py:359` 하드코딩 ACRYLIC 배열이 코드에 정확히 실존 — D-AC-1의 핵심 증거.

---

## 4. K3 — 적재로직 근거 (PASS)

- **D-AC-1(print_side 하드코딩):** load_master:357-369 작성자가 주석에서 "도수 아님·UV 변형" 인지했으나 print_side에 무차별 하드코딩 — 코드 Read로 정확 입증. "위치 오류 + 상품별 무차별 증폭" 환원 정확.
- **D-AC-2(usage 미분화):** line 324 `용도 or 공통` → 본체/부속 전부 USAGE.07. 검증자 재현: 33행 전부 USAGE.07 ✅.
- **D-AC-3~6(완칼/UV 미연결):** "v03 시트15 미부여·load_master 충실 전파" 정직 표기. round-3 대비 진화(192→042/043/044·UV 1→다수) 정직 기록.

---

## 5. K4 — 라이브 실측 독립 재현 (CONDITIONAL — 방향 일치, 카운트 2건 과대)

### 방향 재현 전건 일치 ✅

| 측정 | 매니페스트 주장 | 검증자 독립 재현 | 일치 |
|------|----------------|------------------|:--:|
| **print_side UV변형 적재** | 배면양면·풀빼다·투명테두리 (인쇄면 아님) | `풀빼다 20·배면양면 20·투명테두리 20` | ✅ 의미축 오적재 입증 |
| **전역 의미축 위반** | 다른 family는 단/양면 | 타family: 단면 62·양면 41·(변형 누설 1건씩) | ✅ 아크릴만 변형 |
| **완칼 0** | 053/054/055 아크릴 0건 | count=0 | ✅ |
| 두께 자재 | 미니파츠163=042·코롯토164=044·기타=043 | 163→042(1.5mm)·164→044(8mm)·146/148→043(3mm) | ✅ G-AC-3 자가교정 확인 |
| usage 미분화 | 33행 USAGE.07 | `USAGE.07\|33` | ✅ |
| 입체블럭169 192 | MAT_000192 두께없음 | `MAT_000192 투명아크릴 .03` | ✅ |
| 코스터159 형상 siz | 원형/사각 siz_nm 보존 | `100x100mm사각·100x100mm원형` | ✅ |
| 볼체인 addon REMOVED | PRD_000006 건재·addon 0행 | PRD_000006 use_yn=Y·addon 0(146/158) | ✅ |
| 부속 자재 search | MAT_000045~057 실재 | 045~057 전수 MAT_TYPE.07 실재 | ✅ |

### ⚠️ 카운트 2건 과대 (CONDITIONAL 사유)

**검증자 독립 SELECT가 산출물 주장과 어긋난 2개 측정:**

#### F-AC-G1 [print_side 상품수 22 → 실측 20] Med · 라우팅: `dbm-correctness-auditor`
- **무엇:** live-diff §0 분포표·§1·AC-M1·AC-M3가 일관되게 "**22상품** 전부 3행 하드코딩"이라 주장. 검증자 독립 재현:
  ```sql
  SELECT count(DISTINCT prd_cd) FROM t_prd_product_print_options
    WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- = 20
  -- 변형별: 풀빼다 20·배면양면 20·투명테두리 20 (각 20건)
  ```
- **실측 = 20상품**(146~166, 단 154/167결번/168/169 제외). print_option 미보유: 154(머리끈)·168(입체코롯토)·169(입체블럭). **154/168/169 3상품이 빠져 20**.
- **자기모순:** live-diff §0 분포표 자체는 154="(UV 없음)·print=0"·168="(전무)"·169 print=0으로 **정확히 표기**했으나, 같은 문서 §1·AC-M1 본문이 "22상품"이라 카운트. 표와 본문 불일치.
- **프롬프트 지시값도 부정확:** 본 게이트 프롬프트는 "21건씩"이라 했으나 실측 20건씩 — 프롬프트·산출물 모두 실측과 다름. **검증자 실측 20이 권위.**
- **영향:** 결함 존재·교정 방향(AC-M1 print_side→PROC_000002) 무손상. 영향 상품 수 표기만 과대(22→20).

#### F-AC-G2 [UV 연결 상품수 16 → 실측 14] Med · 라우팅: `dbm-correctness-auditor`
- **무엇:** loadlogic D-AC-6·live-diff §3·AC-C3가 일관되게 "UV(PROC_000002) **16상품** 적재"라 주장. 검증자 독립 재현:
  ```sql
  SELECT count(DISTINCT prd_cd) FROM t_prd_product_processes
    WHERE proc_cd='PROC_000002' AND prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- = 14
  -- UV 보유: 146~152,155,157,158,160~163 (14상품). 부착 추가: 147·151
  ```
- **실측 = 14상품**(146~152·155·157·158·160·161·162·163). UV 미연결: 153·154·156·159·164·165·166·168·169(use_yn=N 6 + 머리끈/입체).
- **영향:** AC-X3(머리끈154·입체블럭169 UV 미연결) 결함 자체는 정확하나, "16상품 적재됨" 요약이 과대 — round-3 대비 진화 폭(1→14)도 14가 정답.

> **분류 정반대 결함은 0** — 1차 2 family 게이트가 적발한 "0행·MISSING이 실은 3행·MIS-LOADED" 류의 *분류 뒤집힘*은 아크릴엔 없다. F-AC-G1/G2는 *분류는 정확하나 영향 카운트가 과대*한 경우(품질 등급이 다름). 그러나 라이브=피고 프레임에서 "몇 상품이 결함인가"는 교정 범위 산정의 직접 입력이므로 보정 필요.

---

## 6. K5 — 비파괴·search-before-mint (PASS)

- correction-manifest: COMMIT/DDL/DELETE 0. 교정 전부 제안. REMOVED(볼체인)=재연결(hard-delete 금지)·PRD_000006 건재 입증.
- **search-before-mint:** 부속 MAT_000045~057·완칼 PROC_000053·UV PROC_000002·골드/실버 195/196 재사용 명기·검증자 재현. 신규 mint=카라비너 고리 5색·라미10T 자재·볼체인 template — 전부 "기존행 부재" 실측 후 ddl-proposer 라우팅(정당).
- print_side 3행 정정도 "논리 보류(즉시 삭제 금지)" — 비파괴.

---

## 7. K6 — 오모델 정합 (PASS)

- **UV=PROC_000002 ≠ print_side:** 핵심 오모델 정합. PROC_000002 변형 enum=[일반,배면양면,풀빼다,투명테두리,단면] 실재 재현 — 정답 위치가 print_side가 아닌 공정 param임을 입증. AC-M1 교정 방향 정합.
- **별색=공정(N/A):** 아크릴 별색 없음(UV 풀빼다=화이트 underbase 흡수) N/A 정합.
- **size↔option 경계:** 형상부기=siz_nm 흡수(코스터/카라비너 재현)·조각수=bundle_qty+완칼 param. OM-7 정합.
- **v03 비참조:** v03을 정답으로 anchor한 곳 0(grep). 정답=L1+스키마+도메인. **K6 PASS.**

---

## 8. 적발한 게이트 결함 (심각도·라우팅·상태)

| ID | 결함 | 심각도 | 라우팅 | 상태 |
|----|------|:--:|------|:--:|
| **F-AC-G1** | print_side 영향 상품수 "22" ↔ 실측 **20**(154/168/169 제외). 같은 문서 분포표는 정확·본문 카운트 과대(자기모순) | Med | `dbm-correctness-auditor`(live-diff/AC-M1/M3 "20상품"으로 정정) | ⏳ 보정 필요 |
| **F-AC-G2** | UV 연결 상품수 "16" ↔ 실측 **14**(153/154/156/159/164~166/168/169 미연결). round-3 진화폭도 1→14 | Med | `dbm-correctness-auditor`(loadlogic/live-diff/AC-C3 "14상품"으로 정정) | ⏳ 보정 필요 |

> 두 결함 모두 **결함의 존재·교정 방향은 정확**(print_side 의미축 오적재·UV 부분 미연결)하고, 영향 *카운트*만 과대. 보정은 수치 정정(산출물 직접 수정은 auditor 몫·검증자 금지).

---

## 9. 독립 재현이 어긋난 측정

1. **print_side distinct 상품수:** 산출물 22 ↔ 검증자 **20**(F-AC-G1).
2. **UV(PROC_000002) distinct 상품수:** 산출물 16 ↔ 검증자 **14**(F-AC-G2).

그 외 9개 핵심 측정(print_side 변형값·완칼0·두께·usage33·192·형상siz·볼체인·부속자재·전역의미축)은 전건 일치.

---

## 10. 결론 — GO 인계 가능 여부

**CONDITIONAL-GO.** K0~K3·K5·K6 PASS, K4 CONDITIONAL(카운트 2건 과대). 라이브 정합 교정의 핵심 결함(print_side 의미축 오적재 = UV변형을 인쇄면 슬롯에 적재·완칼 전무·usage 미분화)이 검증자 독립 SELECT로 *방향* 전건 입증됐고, 정답 위치(PROC_000002 변형 enum)도 실재 확인됐다. oracle 인용 날조 0·search-before-mint·v03 비참조 준수.

**조건:** F-AC-G1(print_side 20상품)·F-AC-G2(UV 14상품) 카운트 보정 후 GO. 두 결함은 교정 *방향* 무손상이라 적재 트랙 진입을 막는 BLOCKER는 아니나, "영향 상품 수"는 교정 범위 산정의 직접 입력이므로 정정 권장. 보정 시 검증자 재게이트는 K4(해당 2측정)만 — 나머지 carry-forward.

잔존 컨펌 8건(CONFIRM-AC-1 완칼·AC-3 부착귀속·AC-4 print_side정정·AC-6 볼체인·AC-usage·AC-A1 라미·AC-ID-1/2). **본 게이트 DB 쓰기 0**(read-only SELECT + 소스 Read만).

---

## 11. K4 재게이트 — 정식 검증자 판정 (2026-06-11, `dbm-validator` 독립)

> 1차(§0~10)는 K4 ⚠️CONDITIONAL(F-AC-G1 print_side 22·F-AC-G2 UV 16 카운트 과대). `dbm-correctness-auditor`가 두 건을 보정 → **K4만 재게이트**(K0~K3·K5·K6 1차 PASS carry-forward). 아래는 생성자와 분리된 검증자가 **라이브 독립 재실측 + 보정 산출물 Read**로 보정 정확성을 판정한 정식 판정(이 판정이 권위).

### K4 재판정: ✅ **PASS** — 보정 카운트 전건 독립 재현 일치, 보존값·방향 불변

**① F-AC-G1 print_side 20상품·20건 — 검증자 독립 SELECT 재현:**
```sql
SELECT count(DISTINCT prd_cd) FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- = 20
SELECT print_side, count(*) FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY print_side;
-- 배면양면 20·풀빼다 20·투명테두리 20
SELECT p.prd_cd FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_print_options po WHERE po.prd_cd=p.prd_cd);  -- PRD_000154·168·169
```
| 측정 | 보정값 | 검증자 독립 재현 | 일치 |
|------|:--:|:--:|:--:|
| print_side distinct 상품수 | 20 | **20** | ✅ |
| 변형별 건수 | 각 20 | 배면양면 20·풀빼다 20·투명테두리 20 | ✅ |
| 제외 3상품 | 154/168/169 | 미보유 = PRD_000154·168·169 (정확히 3건) | ✅ |

live-diff §0 분포표는 1차에도 정확(154=UV없음·168=전무·169 print=0)했고, 본문·§1·AC-M1·AC-M3가 "20상품·각 20건"으로 정정됨. 정정 SQL 주석(count=20·제외 3상품 명기)도 추가. **자기모순(표 vs 본문) 해소.**

**② F-AC-G2 UV 14상품 — 검증자 독립 SELECT 재현:**
```sql
SELECT count(DISTINCT prd_cd) FROM t_prd_product_processes WHERE proc_cd='PROC_000002' AND prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- = 14
```
| 측정 | 보정값 | 검증자 독립 재현 | 일치 |
|------|:--:|:--:|:--:|
| UV(PROC_000002) distinct 상품수 | 14 | **14**(146~152·155·157·158·160~163) | ✅ |

round-3 진화폭도 1→14로 정정. AC-X3(머리끈154·입체블럭169 UV 미연결) 결함 자체는 1차에도 정확(불변).

**③ 보존값 별개 사실 유지 — 검증자 독립 재현:**
```sql
SELECT count(DISTINCT prd_cd) FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- = 16
SELECT prd_cd FROM t_prd_product_materials WHERE mat_cd='MAT_000192' AND prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';  -- PRD_000169
```
| 보존값 | 주장 | 검증자 재현 | 일치 |
|--------|:--:|:--:|:--:|
| plate 보유 상품수 | 16 | **16** | ✅(UV 14·print_side 20과 별개 사실 유지) |
| MAT_000192 잔존(두께없음) | 입체블럭169 1건만 | **PRD_000169** 1건 | ✅ |

plate 16·print_side 20·UV 14가 각기 다른 숫자임이 정확히 별개 측정으로 유지(혼동 없음).

**④ 결함 방향 불변 — 보정 산출물 Read 확인:**
- **print_side 의미축 위반:** live-diff §1·AC-M1 "print_option 보유 20상품 print_side에 UV 변형 욱여넣음(sql:108 위반)·load_master:359 하드코딩 = MIS-LOADED" — 방향·분류 불변.
- **완칼 전무:** AC-X1 "완칼(053/054/055) 아크릴 0건 = MISSING BLOCKER급" — 불변(검증자 1차 재현 count=0 carry-forward).

**⑤ scope — 새 결함·scope 위반 0:** 보정은 카운트 표기(22→20·16→14)·정정 SQL 주석·분포 일관화만 수정. 분류 분포(CORRECT 8·MIS-LOADED 3·MISSING 6·REMOVED 1·AMBIGUOUS 4 = 14 finding)·교정 방향·search-before-mint·컨펌 8건 미변경. 보정이 새 결함을 만들지 않음.

### 최종 매트릭스 (K4 재게이트 후)
| K0 | K1 | K2 | K3 | K4 | K5 | K6 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS(재게이트) | ✅ PASS | ✅ PASS |

**아크릴 파일럿 최종 판정: GO.** K0~K6 전건 PASS. 잔존 컨펌 8건(CONFIRM-AC-1·3·4·6·usage·A1·ID-1·ID-2)은 인간 결정 대기. 교정 실행(print_side→PROC_000002 변형·완칼 적재·UV 보완)은 round-5/6/인간 승인 — DB 미적재 유지. **본 재게이트 DB 쓰기 0**(read-only SELECT + 보정 산출물 Read만).
