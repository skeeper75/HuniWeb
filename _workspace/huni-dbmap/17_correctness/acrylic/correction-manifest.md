# 아크릴 — 교정 매니페스트 (round-13 · C4)

> **작성** 2026-06-11 · round-13. 각 diff를 CORRECT / MIS-LOADED / MISSING / EXTRA / AMBIGUOUS로 분류하고 why(oracle 근거 + 적재로직 원인) + how(비파괴 교정 제안) + 심각도 + 라우팅 기록.
>
> **비파괴 [HARD]:** COMMIT/DDL/DELETE 0. 교정은 *제안*. EXTRA/REMOVED=논리삭제/재연결 제안(hard-delete 금지). search-before-mint. 실 적재는 round-5/인간 승인.
> **빈칸 0.**

---

## 0. 분류 분포

| 분류 | 건수 | 핵심 |
|------|:----:|------|
| **CORRECT** | 8 | 두께·부속·UV14·bundle·nonspec·qty_unit·형상siz·size차원 (round-3 이후 RESOLVED) |
| **MIS-LOADED** | 3 | print_side UV변형(20상품)·usage 미분화·상품별 변형 무시 |
| **MISSING** | 6 | 완칼 전무·부착 부분·UV 누락3·카라비너 고리·네임택 와이어링·완칼 조각수 param |
| **REMOVED** | 1 | 볼체인 addon 소실 |
| **AMBIGUOUS** | 4 | 입체블럭 라미·입체코롯토 전무·볼펜색 variant·★상품 정체 |
| **합계 finding** | **14** | (CORRECT 8 + 결함 6류 = 14 ID) |

---

## 1. CORRECT (라이브 정답 일치 — round-3 이후 교정됨, 유지)

| ID | 상품/속성 | 라이브 현재값 | 정답 일치 근거 |
|----|-----------|---------------|----------------|
| AC-C1 | 자재 두께(미니파츠1.5/코롯토8/나머지3mm) | 042·044·043 | L1 두께 ↔ master 042/043/044 일치. round-3 G-AC-3(192 일괄) RESOLVED |
| AC-C2 | 부속 자재 다행(키링 고리·뱃지 핀/자석·집게·바디·명찰·머리끈) | 045~057 부속 | L1 가공 ↔ master 부속 일치. round-3 부속 미연결 RESOLVED |
| AC-C3 | UV 공정(14상품) | PROC_000002 | L1 폴더=UV ↔ PROC_000002. round-3(1상품→14) RESOLVED. 적재 14 = PRD_000146~152·155·157·158·160~163 |
| AC-C4 | 조각수 bundle(자유형2~6·미니파츠10) | bundle_qty | L1 조각수 ↔ bundle. round-3 G-AC-2 bundle RESOLVED |
| AC-C5 | nonspec 범위(12상품) | min/max 적재 | L1 사용자입력 ↔ nonspec. round-3 G-AC-6 부분 RESOLVED |
| AC-C6 | qty_unit | QTY_UNIT.01 | round-3 G-AC-9(전 NULL) RESOLVED(backfill) |
| AC-C7 | 형상부기 siz 보존(코스터·카라비너) | siz_nm 형상 | L1 형상 ↔ siz_nm. OM-7 정합(형상=siz 흡수) |
| AC-C8 | size 차원(작업>재단·골드실버195/196) | work>cut | L1 작업/재단 ↔ 라이브 차원 |

> **유지** — 교정 불요. round-13의 의의: 라이브가 round-3 이후 v03 시트 수정으로 상당 부분 자가교정됨을 확인.

---

## 2. MIS-LOADED (의미축 오적재 — 교정 필요)

### AC-M1 [MIS-LOADED · High] print_side에 UV 변형 적재 (20상품)
- **상품/속성:** 20상품(146~153·155~166, **print_option 보유 상품**) `t_prd_product_print_options.print_side`. **제외 3상품 = PRD_000154(머리끈)·168(입체코롯토)·169(입체블럭)** = print_option 0행(머리끈은 L1 인쇄사양 공백=일반·입체류는 외주 미정의). 각 변형값(배면양면/풀빼다/투명테두리) **20건씩**(검증자 독립 SELECT 재확인)
- **라이브 현재값:** `배면양면·풀빼다·투명테두리` 3행 하드코딩(도수 CLR_000005 4도/CLR_000001 0도 쌍)
- **정답값:** UV 변형 → `t_prd_product_processes`(PROC_000002) + prcs_dtl_opt `변형` param. `print_side`는 실제 단/양면(또는 비움). UV 출력은 풀컬러 4도 단일이므로 도수 슬롯 부적합.
- **why:** ① **스키마 의도 충돌** — `sql/01b_tables_relations.sql:108` print_side="인쇄면(단면/양면)". UV 변형명은 인쇄면 아님. ② **적재로직** — `load_master.py:357-369` 작성자가 주석에서 "도수 아님·UV 변형" 인지했으나 print_side에 하드코딩(D-AC-1). ③ **master 증거** — PROC_000002 prcs_dtl_opt `변형 enum=[일반,배면양면,풀빼다,투명테두리,단면]`가 정확한 적재 위치를 명시(라이브 실측).
- **how(비파괴):** ⓐ 각 상품에 `t_prd_product_processes`(PROC_000002, mand_proc_yn=Y) + prcs_dtl_opt 변형 param을 상품별 L1 실제 변형으로 적재(키링=배면양면·마그넷=단면인쇄/투명테두리/풀빼다 등). ⓑ 기존 print_side 3행은 **논리 보류**(즉시 삭제 금지) — UV process 적재·검증 후 정정/제거 제안. ⓒ UV 출력 도수는 4도 단일 1행으로 print_options 재구성 또는 print_options 미사용(굿즈는 면 개념 약함).
- **심각도:** High (위젯 "인쇄옵션"이 변형을 도수쌍으로 오표시·상품별 변형 손실)
- **라우팅:** load-execution(process 적재) + 컨펌(CONFIRM-AC-4 print_side 정정 방향) → ddl 불요(컬럼 존재)

### AC-M2 [MIS-LOADED · Medium] 본체/부속 usage 미분화 (33행 전부 USAGE.07)
- **상품/속성:** 아크릴 33 material 행 `usage_cd`
- **라이브 현재값:** 전부 `USAGE.07`(공통) — 본체 아크릴(MAT_TYPE.03)도 부속(MAT_TYPE.07)도 동일
- **정답값:** 본체=본체 usage·부속=부속 usage 분화. 단 라이브 USAGE 코드는 내지/표지/면지/간지/투명커버/표지타입/공통뿐(본체·부속 코드 부재).
- **why:** `load_master.py:324` "빈 용도 → USAGE.공통". v03 `14_상품별자재` 시트가 `용도` 빈값 전달(D-AC-2). USAGE 코드값에 "본체"·"부속" 자체가 없어 책자류(내지/표지)에 맞춰진 코드 도메인이 굿즈에 안 맞음.
- **how(비파괴):** ⓐ mat_typ_cd로 본체/부속 구분 가능(MAT_TYPE.03=본체·.07=부속)하므로 usage 미분화가 즉시 견적 결함은 아님(보류 가능). ⓑ 본체/부속 USAGE 코드 신설이 필요하면 코드 선적재 제안(`t_cod_base_codes` USAGE.본체·USAGE.부속) 후 product_materials usage 정정. **단 코드 도메인 변경은 굿즈 전 family 영향 → 컨펌.**
- **심각도:** Medium (mat_typ로 우회 식별 가능하나 정규화 위반)
- **라우팅:** 컨펌(USAGE 코드 도메인 정책) → ddl-proposer(코드 신설 시)

### AC-M3 [MIS-LOADED · High] 상품별 인쇄 변형 무시 (전 상품 동일 3종)
- **상품/속성:** print_options 상품별 변형 정확성
- **라이브 현재값:** print_option 보유 20상품 전부 동일 `배면양면·풀빼다·투명테두리` (load_master:359 ACRYLIC 하드코딩). 제외 3상품(154/168/169)은 print_option 자체 0행
- **정답값:** 상품마다 상이 — 마그넷=단면인쇄/투명테두리/풀빼다, 명찰=풀빼다만, 스마트톡=투명테두리만, 키링=배면양면만(L1 실측)
- **why:** `load_master.py:359` 하드코딩이 v03 DEFAULT 1행을 전 상품 동일 전개 → 상품별 L1 변형 진실 소실. 특히 **마그넷 단면인쇄 누락**·다수 상품 잉여 변형.
- **how:** AC-M1의 process 적재 시 **상품별 L1 인쇄사양 distinct를 변형 param 값으로** 적재(extraction-plan §1~2 상품별 표 참조). 하드코딩 대체.
- **심각도:** High (AC-M1과 한 쌍 — 위치 오류 + 상품별 무차별)
- **라우팅:** load-execution(상품별 변형 적재)

---

## 3. MISSING (정답상 있어야 하나 라이브 부재)

### AC-X1 [MISSING · BLOCKER급] 완칼(PROC_000053) 전 아크릴 0건
- **상품/속성:** 형상 굿즈(키링/마그넷/뱃지/집게/스마트톡/맥세이프/명찰/머리끈/볼펜/지비츠/네임택/포카키링/코스터/자유형스탠드/포카스탠드/미니파츠/카라비너) process
- **라이브 현재값:** 완칼/반칼/스티커완칼(053/054/055) 아크릴 0건
- **정답값:** 형상 굿즈에 PROC_000053(완칼) + prcs_dtl_opt 모양 param. **판아크릴(161)·입체코롯토(168)·입체블럭(169) 제외**(round-3 over-reach 보정).
- **why:** v03 `15_상품별공정` 시트가 완칼 행 미부여(D-AC-3). 아크릴 굿즈는 도메인상 die-cut 필수(모양대로 절단)인데 엑셀 명시 컬럼 없어 묵시. master PROC_000053(`모양 string`) 건재 — 연결만 결손.
- **how(비파괴):** 형상 굿즈에 `t_prd_product_processes`(PROC_000053, mand_proc_yn=Y) + prcs_dtl_opt 모양(사용자입력/형상부기). 코스터=모양 원형/사각, 카라비너=4형상. master mint 불요(053 존재). **단 완칼 묵시 모델링은 컨펌 선행**(CONFIRM-AC-1).
- **심각도:** BLOCKER급 (위젯 "모양/완칼" 옵션 통째 부재)
- **라우팅:** 컨펌(CONFIRM-AC-1 완칼 모델링) → load-execution

### AC-X2 [MISSING · Medium] 부착공정(PROC_000081) 부분 적재
- **상품/속성:** 뱃지·명찰·집게·머리끈·네임택 부착공정
- **라이브 현재값:** 맥세이프(151)·마그넷(147)만 PROC_000081
- **정답값:** 부착성 부속 상품에 PROC_000081 + 대상 param(핀/자석/끈/집게). 자재(부속)와 2축 동시.
- **why:** v03 `15`가 나머지 부속 상품에 부착 행 미부여(D-AC-6). master PROC_000081(`대상 enum=[라벨,맥세이프,끈,테입]`) 건재 — 단 enum에 핀/자석/집게 없음(대상 enum 확장 필요할 수 있음).
- **how:** 부속 상품에 PROC_000081 + 대상 param. **대상 enum에 핀/자석/집게 부재** → 대상 enum 확장 컨펌 또는 기존 라벨/테입 매핑. 부속 자재(이미 적재)와 2축.
- **심각도:** Medium
- **라우팅:** 컨펌(CONFIRM-AC-3 부착 대상 enum) → load-execution

### AC-X3 [MISSING · High] 활성 상품 UV 미연결 (머리끈154·입체블럭169)
- **상품/속성:** 머리끈(154, use_yn=Y)·입체블럭(169, use_yn=Y) UV 공정
- **라이브 현재값:** 둘 다 PROC_000002 0행
- **정답값:** 활성 상품은 UV 필수(머리끈=변형 일반·입체블럭=UV+라미)
- **why:** v03 `15`가 이 상품에 UV 행 미부여(D-AC-6). 머리끈은 인쇄사양 공백(=일반)이라 누락된 듯하나 UV 출력 자체는 필요.
- **how:** 머리끈·입체블럭에 PROC_000002(변형=일반). 입체블럭은 라미 자재(AMBIGUOUS AC-A1)와 연동.
- **심각도:** High(활성 상품 인쇄방식 부재)
- **라우팅:** load-execution

### AC-X4 [MISSING · Medium] 카라비너 고리(7색) 미연결
- **상품/속성:** 카라비너(166) 부속 고리
- **라이브 현재값:** 본체043만, 고리 부속 0행
- **정답값:** 카라비너 고리 7색(골드/레드/블랙/실버/핑크/하늘/화이트) 부속
- **why:** **master에 카라비너 고리 전용 부속 코드 부재**(051/052는 은색/금색고리만). 기존 부속과 색이 다름.
- **how(search-before-mint):** ⓐ 기존 051(은색)·052(금색) 재사용 가능 부분(실버≈은색·골드≈금색). ⓑ 나머지 5색(레드/블랙/핑크/하늘/화이트) 부속 코드 mint 필요 → ddl/코드 선적재 제안. ⓒ 또는 고리=색 variant 옵션으로 처리(부속 1+색 옵션).
- **심각도:** Medium (use_yn=N 상품)
- **라우팅:** 컨펌(고리=부속 다행 vs 색 variant) → ddl-proposer(부속 코드 신설)

### AC-X5 [MISSING · Low] 네임택 와이어링/스트랩 미연결
- **상품/속성:** 네임택(157) 부속
- **라이브 현재값:** 본체043만
- **정답값:** 와이어링(실버/화이트/블랙)·스트랩(투명) 부속(끈류)
- **why:** v03 `14`가 네임택 부속 행 미부여. master 끈류(MAT_000070 끈·057 헤어끈) 재사용 가능성.
- **how:** 와이어링/스트랩 부속 매핑. 전용 코드 부재 시 끈류 재사용 또는 mint.
- **심각도:** Low
- **라우팅:** 컨펌(부속 코드) → load-execution

### AC-X6 [MISSING · Low] 완칼 조각수 param (조합형)
- **상품/속성:** 자유형스탠드(160)·미니파츠(163) 완칼 조각수 param
- **라이브 현재값:** bundle_qty 적재됨(2~6/10)이나 완칼 process 자체 0건이라 조각수 param 부재
- **정답값:** bundle_qty(적재됨) + 완칼/스티커완칼 조각수 param 둘 다(Q8)
- **why:** 완칼 process 미적재(AC-X1)의 종속 결함. AC-X1 해소 시 함께.
- **how:** AC-X1 완칼 적재 시 조각수 param(자유형=2~6·미니파츠=10) 동반.
- **심각도:** Low (bundle은 이미 있음)
- **라우팅:** load-execution(AC-X1 연동)

---

## 4. REMOVED (round-3 대비 소실 — 논리/재연결)

### AC-R1 [REMOVED · Medium] 볼체인 addon 소실
- **상품/속성:** 키링(146)·포카키링(158) addon
- **라이브 현재값:** addon **0행**(round-3엔 PRD_000006 볼체인 1행씩 있었음)
- **정답값:** PRD_000006(볼체인) addon + 9색 옵션
- **why:** Phase7 마이그레이션이 `t_prd_product_addons`를 `addon_prd_cd`→`tmpl_cd`로 재구조화(D-AC-5). 구 볼체인 addon 행이 새 tmpl_cd 구조로 미이관(볼체인 전용 template 부재 — t_prd_templates 9행 전부 봉투류).
- **how(search-before-mint·비파괴):** ⓐ **PRD_000006 볼체인 master 건재(use_yn=Y)** — 재연결 가능. ⓑ 새 addon 구조가 tmpl_cd 요구 → 볼체인 template 신설 제안(t_prd_templates) 후 키링/포카키링 addon 재연결. ⓒ 9색은 template 색 variant 또는 옵션. **hard-delete 아님 — 미이관 복원.**
- **심각도:** Medium
- **라우팅:** 컨펌(CONFIRM-AC-6 볼체인 9색=variant vs addon) → ddl/load-execution(template 신설 + 재연결)

---

## 5. AMBIGUOUS (정체/모델링 미확정 — 컨펌)

### AC-A1 [AMBIGUOUS] 입체블럭(169) 두께 192 vs 라미10T
- **라이브:** MAT_000192(두께없음 투명아크릴)
- **정답 후보:** L1 소재=`투명아크릴라미(10T)` — **master에 아크릴 라미 자재 부재**
- **why:** 라미 10T 전용 자재코드 없음 → v03이 192 폴백(D-AC-4). 입체 라미는 일반 아크릴과 다른 자재.
- **how:** ⓐ 아크릴 라미10T 자재 mint(MAT_TYPE.03) 후 연결, 또는 ⓑ 192 유지 + 두께/가공 속성축. ⓒ 입체블럭 정체 자체가 🔴(CONFIRM-AC-ID-2).
- **라우팅:** 컨펌(라미 자재 mint) → ddl-proposer

### AC-A2 [AMBIGUOUS] 입체코롯토(168) 전 속성 0행
- **라이브:** size/mat/proc/print 전무, use_yn=Y
- **정답:** L1 폴더/소재/인쇄사양 전부 공백(외주 미정의)
- **why:** 루아샵 외주 입체 가공품 생산 명세 부재. 정체 자체 🔴.
- **how:** 외주 명세 확보 전 속성 적재 보류. 정체 컨펌(CONFIRM-AC-ID-2) 선행.
- **라우팅:** 컨펌(CONFIRM-AC-ID-2)

### AC-A3 [AMBIGUOUS] 볼펜색(6색)·지비츠타입(스핀/투명)·스마트톡 바디 = 부속 vs variant
- **라이브:** 볼펜(155)=본체만·지비츠(156)=본체만·스마트톡(150)=바디 053/054 부속
- **정답 후보:** 볼펜대 6색=부속 색 variant·지비츠 스핀/투명=타입 variant·바디=부속 vs 본체색 variant
- **why:** Q5 운영원칙(컬럼옵션 확인 후 귀속). 가공 컬럼이 부속자재인지 색/타입 variant인지 분기.
- **how:** 컨펌(CONFIRM-AC-3) — 부착 부속(고리/자석/핀)=자재+공정 2축, 볼펜색/지비츠타입=variant.
- **라우팅:** 컨펌(CONFIRM-AC-3)

### AC-A4 [AMBIGUOUS] ★상품 정체·등록 (쉐이커·지비츠★)
- **라이브:** 미등록(prd_cd 부재)
- **why:** L1 전행 hidden·MES 미부여·정체 사이트 미확인(CONFIRM-AC-ID-1).
- **how:** 출시 의도 확정 전 등록 제안 보류(EXTRA 삭제단정 금지).
- **라우팅:** 컨펌(CONFIRM-AC-ID-1)

---

## 6. 🔴 컨펌 질문 목록 (인간 결정 대기)

| ID | 질문 | 연관 |
|----|------|------|
| **CONFIRM-AC-1** | 완칼(PROC_000053)을 형상 굿즈에 묵시 적재할까요? 판/입체류(161/168/169) 제외가 맞나요? | AC-X1 |
| **CONFIRM-AC-4** | UV 변형(배면양면/풀빼다/투명테두리)을 print_side에서 PROC_000002 변형 param으로 옮기고, print_side는 정정/비울까요? | AC-M1·M3 |
| **CONFIRM-AC-3** | 가공 부속 귀속 — 부착 부속(고리/자석/핀/집게/끈)=자재+부착공정 2축, 볼펜색/지비츠타입/바디=variant로 분기할까요? 부착 대상 enum(핀/자석/집게) 확장? | AC-X2·X4·X5·A3 |
| **CONFIRM-AC-6** | 볼체인 9색을 addon 1(PRD_000006)+색 variant로 재연결할까요? Phase7 tmpl_cd 구조에 볼체인 template 신설? | AC-R1 |
| **CONFIRM-AC-usage** | 본체/부속 USAGE 코드(현 내지/표지/공통)에 본체·부속 코드를 신설할까요, mat_typ_cd로 우회 식별할까요? (굿즈 전 family 영향) | AC-M2 |
| **CONFIRM-AC-A1** | 입체블럭(169) 라미10T 전용 자재를 mint할까요, 192 유지+속성축? | AC-A1 |
| **CONFIRM-AC-ID-1** | 쉐이커★·지비츠★ 출시 예정 등록 vs 영구 보류? | AC-A4 |
| **CONFIRM-AC-ID-2** | 입체코롯토(168)·입체블럭(169) 루아샵 외주 명세 확보 후 속성 적재? | AC-A2 |

---

## 7. 라우팅 분포

| 라우팅 | 건수 | finding |
|--------|:----:|---------|
| **load-execution(직접 적재 제안)** | 5 | AC-M1/M3(process 변형)·AC-X1(완칼·컨펌후)·AC-X3(UV)·AC-X6(조각수)·AC-X2/X5(부분) |
| **ddl-proposer(코드/엔티티 신설)** | 4 | AC-X4(고리 부속)·AC-R1(볼체인 template)·AC-A1(라미 자재)·AC-M2(usage 코드) |
| **컨펌(인간 결정 선행)** | 8 | CONFIRM-AC-1·3·4·6·usage·A1·ID-1·ID-2 |
| **유지(CORRECT)** | 8 | AC-C1~C8 |

> **DB 미적재 [HARD]:** 본 매니페스트는 교정 *제안*까지. 실 COMMIT/DDL/논리삭제는 round-5/인간 승인. EXTRA(볼체인)=재연결(hard-delete 금지). search-before-mint 적용(볼체인 PRD_000006·완칼 053·UV 002·부속 045~057 master 재사용 우선).
