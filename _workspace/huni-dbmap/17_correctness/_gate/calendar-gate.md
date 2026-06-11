# 캘린더 + 디자인캘린더 — round-13 라이브 정합 교정 게이트 (K0~K6)

> **검증** 2026-06-11 · `dbm-validator` 독립 게이트(생성자 ≠ 검증자). 검증 대상 = `dbm-correctness-auditor`가 만든 `17_correctness/calendar/` 5종(product-identity·loadlogic-notes·extraction-plan·live-diff·correction-manifest).
> **판정 원칙[HARD]:** 추정 0. 모든 PASS/FAIL은 증거(파일:라인 / 독립 read-only SELECT) 동반. 발견 결함은 **라우팅만**(산출물 직접 수정 금지·NEVER COMMIT/DDL/DELETE).
> **권위:** oracle 인용 실재성 = `raw/webadmin/` 직접 Read 검증, 라이브 값 = 독립 read-only psql 재현(`.env.local` `RAILWAY_DB_*`·비번 비노출).

---

## 0. 최종 판정: **GO** (보정 권고 1건 — F-GATE-CAL-1, 비차단)

라이브 정합 교정의 핵심 방법론·증거·결함 식별이 견고하다. K2(oracle 인용)·K4(라이브 실측)가 **표본 전건 독립 재현 일치**했고(상품헤더 5·하위카운트 45셀·자재 6행·plate 5+전역분포·공정 6+마스터검색0·카테고리 5+노드4·addon/template·가격 0+0 등), C-CAL-04 plate 핵심 진단(load_master L338,346 코드 .03 vs 라이브 .01 충돌)이 코드 직접 Read로 정확함이 확인됐다. **D-1 오탐 반증(엽서 SIZ_000007=엑셀 row16 실재)도 엑셀 L1 직접 확인으로 통과.** 교정 매니페스트는 비파괴·search-before-mint 준수(K5 PASS).

2-pass dodge-hunt에서 **근거 서술 부정확 1건(F-GATE-CAL-1: F-4의 "option 로더 부재" 단언이 RELATIONS L476 `rel_excl_groups` 실재와 충돌)**을 적발했으나, F-4의 **결론**(장수·캘린더가공 택일 적재경로 부재 = MISSING)은 옳다 — 근거 서술만 정밀화 필요(비차단). 분류 정반대·카운트 과대·재연결 오매핑은 적발 0.

| 게이트 | 판정 | 한줄 근거 |
|--------|:--:|----------|
| **K0** 상품 정체 확정 | ✅ **PASS** | 6상품(5 form factor + 디자인 surface) 범주(007 일반인쇄)·구성(단품)·생산방식(거치/제본별 form factor)·prd_typ_cd(.04) 라이브 일치. 정체 오분류 0(디지털인쇄 배경지=포장재 같은 오분류 없음·반증 입증). 정체 불명 🔴 0 |
| **K1** 추출규칙 커버리지 | ✅ **PASS** | 6상품 × 5속성축 + 고유축2(장수·가공/추가상품) 전수, N/A 사유 명기(별색=캘린더 컬럼 없음), 빈칸 0 |
| **K2** oracle 인용 실재 | ✅ **PASS** | 표본 8건(load_master L39/L261/L338/L346/L440/L476·schema-intent §3 L358/L397/L399/L327·엑셀 calendar-l1 L12) 전건 실존·내용 일치. G-1 날조 재발 0 |
| **K3** 적재로직 근거 | ⚠️ **PASS(보정권고)** | MIS-LOADED/MISSING 원인 대부분 실제 코드 라인 재구성·"적재경로 불명" 정직 표기. **단 F-4 근거 서술 1건 정밀화 필요**(§dodge-hunt F-GATE-CAL-1, 결론은 정확) |
| **K4** 라이브 실측 독립 재현 | ✅ **PASS** | 표본 14항(헤더·카운트·자재·plate·공정·카테고리·addon·template·가격·excl 컬럼 부재) 전건 독립 SELECT로 동일 재현. 불일치 0 |
| **K5** 비파괴·search-before-mint | ✅ **PASS** | COMMIT/DDL/DELETE 0, EXTRA(C-CAL-03)=논리삭제 제안, 삼각대거치 공정 mint 전 마스터 부재(SELECT 0행) 입증, 우드거치대·봉투 template 기존행 재사용 우선 |
| **K6** 오모델 정합 | ✅ **PASS** | 부속=공정(§3 #6/#7)·장수≠page_rule(§2.3 Q12)·고정가형(§3.1)·판형=출력용지규격·색≠siz 경계 위반 0 |

---

## 1. K0 — 상품 정체 확정 (PASS)

product-identity가 6상품(5 form factor + 디자인 surface)의 범주·구성·생산방식·출처를 명기. 독립 재현:

```
PRD_000108|탁상형캘린더|PRD_TYPE.04|Y|N
PRD_000109|미니탁상형캘린더|PRD_TYPE.04|Y|N
PRD_000110|엽서캘린더|PRD_TYPE.04|Y|N
PRD_000111|벽걸이캘린더|PRD_TYPE.04|Y|N
PRD_000112|와이드벽걸이캘린더|PRD_TYPE.04|Y|N
```

- 전 5상품 `prd_typ_cd=PRD_TYPE.04`(디자인상품) = 정체(디자인 제공·에디터) 정합 ✅.
- **정체 오분류 0 — 의심 반증 입증:** 디지털인쇄 시트의 "인쇄배경지=포장재 오분류" 같은 범주 오분류가 캘린더에 없음. form factor(탁상/미니/엽서/벽걸이/와이드)=정체(MES 007-0001~5 1:1)라는 정체 결정 요지가 카테고리 노드(CAT_000112~115 전부 lvl2 정상)와 정합.
- **디자인캘린더 = 같은 5상품 surface**(별 prd_cd 아님) — 라이브에 별 캘린더 prd_cd 부재로 재확인. 별 상품 mint 금지 정합.
- 정체 불명 🔴 0(우드행거만 family 시트 범위 외 무시 — 정체 단정 아님, 정당).

**비전형 상품 없음** → huniprinting.com 추가 browse 불요 판단 수용(캘린더=일반 인쇄물 전형, product-master 크롤 분석으로 충분).

---

## 2. K2 — oracle 인용 실재 (PASS, 핵심 인용 직접 Read 검증)

| 인용 | 산출물 주장 | 직접 Read 결과 | 판정 |
|------|------------|----------------|:--:|
| `load_master.py:39` | v03 순수 전파기 `XLSX=...v03...` | `XLSX = "data/raw/prdmaster_full_migration_v03_20260518.xlsx"` | ✅ 실재·일치 |
| `load_master.py:261` | MES None 하드코딩 | `None,  # MES_ITEM_CD: 전량 NULL (사용자 결정...)` | ✅ 실재·일치 |
| **`load_rel_plate_sizes:338,346`** ★ | 전부 `.기타`(.03) 적재·`.01` 분기 없음 | L338 `other = ENUM["OUTPUT_PAPER_TYPE"]["기타"]` · L346 `other if _norm(r["출력용지유형코드"]) is not None else None` · L340 주석 "전부 OUTPUT_PAPER_TYPE.기타" | ✅ **실재·일치 — C-CAL-04 진단 정확** |
| `load_rel_addons:440` | `addon_prd_cd` INSERT(현 스키마 tmpl_cd와 drift) | L440 `INSERT INTO t_prd_product_addons (prd_cd, addon_prd_cd, ...)` | ✅ 실재·일치 |
| `RELATIONS:469-481` | option 로더 부재 | L476 `("rel_excl_groups", load_rel_excl_groups)` **실재** — option_groups/options/items 로더는 없으나 excl_groups 로더는 있음 | ⚠️ **부분 불일치**(§dodge-hunt) |
| `schema-intent §3 #6` L397 | 후가공=공정 | "박/코팅=공정(Q2/Q9, 자재 아님)" | ✅ 실재·일치 |
| `schema-intent §3 #8` L399 | 우드거치대=자재(Q13) | "우드거치대=자재(Q13, 가공컬럼에 있으나 자재)" | ✅ 실재·일치 |
| `schema-intent` L358 | 캘린더 장수≠page_rule(Q12) | "캘린더 장수를 page_rule로 단정 ✗(Q12: 고객선택 옵션+공식)" | ✅ 실재·일치 |
| `schema-intent §3.1` L327/L409 | 고정가형=`t_prd_product_prices` | L327 "직접단가 경로: t_prd_product_prices" · L409 고정가형 | ✅ 실재·일치 |
| **`calendar-l1.csv:12`** ★ | 엽서 row16 작업152x214/재단148x210 | L12 `엽서캘린더,16,...,152 x 214,...,148 x 210` | ✅ **실재·일치 — D-1 오탐 반증 정확** |

날조(G-1류) 재발 0. plate 코드·D-1 반증 두 핵심 인용이 직접 Read로 정확.

---

## 3. K4 — 라이브 실측 독립 재현 (PASS, 표본 전건 일치)

검증자 독립 read-only SELECT(쓰기 0·비번 비노출):

**상품 헤더 + 하위 카운트** — live-diff §0/§1과 완전 일치:
```
PRD_000108|2|10|1|1|1|0|0|0|0   PRD_000109|2|9|1|1|1|0|0|0|0
PRD_000110|6|10|1|1|1|0|0|0|0   PRD_000111|3|23|2|1|2|0|0|0|0   PRD_000112|1|4|2|1|1|0|0|0|0
(sizes|mats|prnt|plate|proc|pgrul|ogrp|addon|price)
```
page_rules·option_groups·addons·prices 전 상품 0 = 장수·택일·봉투/우드·디자인가격 MISSING 정합 ✅.

**자재 부속 오적재(C-CAL-01/02/03)** — 일치:
```
108→MAT_000252 삼각대(그레이)|MAT_TYPE.07|USAGE.07|Y + MAT_000253 링 블랙   ← 탁상에 링 부착=EXTRA 정합
109→MAT_000253 링 블랙 + MAT_000254 삼각대(블랙)|MAT_TYPE.07|USAGE.07|Y
111→링 블랙 + 종이22(MAT_TYPE.01)   112→링 블랙 + 종이3
```
삼각대(252/254)·링(253)=MAT_TYPE.07 부속, dflt_yn=Y 정합 ✅.

**plate output_paper_typ_cd(C-CAL-04)** — 일치:
```
108/109/110/111→SIZ_000499(316x467)|.01 국전계열   112→SIZ_000292(304x629)|.03 기타
전역: .01=32 · .03=33 · NULL=359
```
값 정답(.01/.03)이나 load_master 코드는 .03만 산출 = 적재경로 불명 진단 정확 ✅.

**공정 마스터 검색(C-CAL-07 search-before-mint)** — 일치:
```
삼각대/거치 공정 검색 → 0행 (마스터 부재 입증)
108/109→PROC_000076 수축포장   110→PROC_000079 타공   111→PROC_000021+079   112→PROC_000021
```
삼각대 거치 공정 마스터 부재 = mint 필요 입증 정확 ✅.

**카테고리(고아 0)·addon·가격** — 일치:
```
108/109→CAT_000112  110→CAT_000114  111/112→CAT_000115 (전부 upr=CAT_000007/lvl2 정상)
CAT_000113 미니탁상형(전용 노드) 실재하나 109 미연결 = C-CAL-14 AMBIGUOUS 정합
addons→PRD_000016|TMPL-000005 1행만(캘린더 0)  templates→PRD_000005 기준 0
prices 전역=0 · template_prices 전역=0  · PRD_000005 캘린더봉투=012-0008|PRD_TYPE.03
```

**스키마 drift 독립 확인:** `t_prd_product_processes.excl_grp_cd` 컬럼 **부재**(Phase11 삭제) · `t_prd_product_addons` 컬럼=**tmpl_cd**(addon_prd_cd 없음) · `%excl%` 테이블 0개 — F-3 drift·재현노트 정확 ✅.

---

## 4. 2-pass dodge-hunt (표본 독립 재실측)

| dodge 유형 | 검증 | 결과 |
|------------|------|------|
| **분류 정반대**(MISSING↔MIS-LOADED) | 삼각대/링=자재(MIS-LOADED) 라이브 실재·plate값(CORRECT) vs 경로(MIS-LOADED) 구분 | 적발 0 — 분류 정확 |
| **카운트 과대**(MISSING 부풀림) | MISSING 7건(장수·택일·삼각대거치·봉투·우드·디자인가격·MES) 전건 라이브 0행 독립 확인 | 적발 0 — 과대 없음(전건 실제 0) |
| **재연결 오매핑**(코드번호 ≠ 노드) | 카테고리 108→112·110→114·111/112→115 prd_cd↔cat_cd 매핑 독립 SELECT 일치 | 적발 0 |
| **D-1 오탐 반증 검증** | SIZ_000007(148x210) 엽서 6 variant 실재 + 엑셀 calendar-l1 L12(row16 재단148x210) 실재 | **반증 정확 — 통과** |

### F-GATE-CAL-1 [근거 서술 부정확 — 비차단] Low · 라우팅: `dbm-correctness-auditor`(정밀화)
- **무엇:** loadlogic-notes F-4가 "load_master가 CPQ 옵션 레이어(option_groups/options/items)를 **전혀 적재하지 않음** — RELATIONS L469-481에 **option 로더 부재**"라 단언. 그러나 직접 Read 결과 **RELATIONS L476에 `("rel_excl_groups", load_rel_excl_groups)` 로더가 실재**한다(L390-401에 함수 정의도 존재).
- **정밀화된 진짜 구조:** ① load_master에 **CPQ option_groups/options/option_items 로더는 실제로 없다**(F-4 결론 부분 정확) ② 그러나 **excl_groups(공정 택일그룹) 로더는 있다** ③ 그 로더의 타겟 `t_prd_product_process_excl_groups`는 **라이브에서 삭제됨**(Phase11, independent SELECT: `relation does not exist`) → 현 load_master `--all` 재실행 시 excl_groups 적재 단계에서 **실패**(스키마 drift). 즉 정확한 서술은 "option 로더 부재"가 아니라 "**excl_groups 로더는 있으나 타겟 테이블 Phase11 삭제로 실행 불가 + CPQ option 로더는 부재**".
- **영향:** F-4의 **결론(장수·캘린더가공 택일 = 적재경로 부재 = MISSING)은 옳다**. 라이브 option_groups 캘린더 0행(전역 6행=PRD_000001/002/066/138만)·page_rules 0행 독립 확인. 결함 분류·교정 방향(C-CAL-05/06 = load-execution round-6 L2)은 영향 없음. **근거 서술만 정밀화 권장**(비차단).
- **독립 증거:**
  ```
  RELATIONS L476: ("rel_excl_groups", load_rel_excl_groups)  ← 실재
  SELECT * FROM information_schema.tables WHERE table_name LIKE '%excl%';  → 0행 (테이블 삭제)
  SELECT count(*) FROM t_prd_product_option_groups;  → 6 (캘린더 0, PRD_000001/002/066/138)
  ```

---

## 5. auditor 라우팅 (인간 결정 대기)

correction-manifest의 분류 분포(CORRECT7·MIS-LOADED3·MISSING7·EXTRA1·AMBIGUOUS2=20)·라우팅 전건 수용. DB 미적재(제안까지만).

| 라우팅 대상 | manifest 항목 | 비고 |
|------------|---------------|------|
| **ddl-proposer**(신규 엔티티/컬럼) | C-CAL-07(삼각대거치 공정 mint·마스터 부재 입증)·C-CAL-04(plate 코드 치수→계열 매핑)·C-CAL-08(캘린더봉투 template) | search-before-mint 입증 후 |
| **load-execution**(미적재 적재본) | C-CAL-05(장수 CPQ option·round-6 L2)·C-CAL-06(가공 택일그룹)·C-CAL-08/09(봉투/우드)·C-DC-11(디자인 고정가·`t_prd_product_prices`) | round-6 L2 / round-2 가격 |
| **교정직접**(값 UPDATE/논리삭제 제안) | C-CAL-02(링칼라 param)·C-CAL-03(탁상/미니 링 논리삭제)·C-DC-10(editor_yn=Y)·C-CAL-13(MES 채움) | hard-delete 금지 |
| **컨펌**(인간 결정) | CL-A~G 7건(삼각대 공정전환·링 param·plate 코드정합·장수 SEL_TYPE·종이 권위·미니 카테고리·MES) | 인간 승인 |
| **dbm-correctness-auditor**(정밀화) | F-GATE-CAL-1(F-4 근거 서술 — option 로더 부재 → excl_groups 로더 실재+Phase11 삭제로 실행불가로 정정) | 비차단 |

---

## 6. 재현 노트
- 전 쿼리 읽기전용 SELECT(INSERT/UPDATE/DDL/COMMIT 0). 비번 비노출(`.env.local` 환경변수).
- oracle 인용은 `raw/webadmin/tools/load_master.py`·`00_schema/schema-design-intent-map.md`·`06_extract/calendar-l1.csv` 직접 Read.
- v03 파일(`raw/webadmin/data/raw/prdmaster_full_migration_v03_*.xlsx`)은 **부재**(참조 금지 directive 정합) — F-1 마지막 고리는 load_master 코드 인용(L338,346)으로 검증, v03 내용 미참조(정합).
