# acrylic(아크릴) 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/acrylic.md` ⑤의 R1~R8을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> digital-print 파일럿(`09_load/digital-print/`)의 구조·메서드를 템플릿으로 복제.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + update-set + 자기검증뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/acrylic-l1.csv`) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`, **stale 2026-06-04 주의**).
> 추정 0 — 모든 행은 L1 셀 또는 ref 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` **C-1(★/회색=미출시 비활성)·C-4(굿즈→EA)·C-6(부속 맥락별)·C-7(완칼=공정+조각수=bundle_qty)·C-8(variant 분해=관리용이성 균형, 과세분화 금지)** binding 적용.

---

## 0. 산출물 맵

> **[보정 이력 2026-06-05 — Wave B2 검증 후속]** dbm-validator CONDITIONAL GO(1 BLOCKER+1 MAJOR) 해소.
> ① **[BLOCKER] 151 PROC_000081 부착** = 라이브 기적재(중복PK) → active에서 `t_prd_product_processes_conditional.csv`로 이동(적재 직전 라이브 재확인). ② **[MAJOR] 완칼 over-reach 161·168·169** = product-level 근거 부재 → active에서 `_deferred/`로 이동(완칼 active 17→14). ③ **[코드 note]** 아크릴 모양컷 도메인공정=레이저커팅(마스터 proc_cd 부재)이라 053 차용 — §3 R1·§5 D-AC-8 명시. ④ **[순환검증 보정]** `verify_expected.py` 완칼 검증을 생성기 규칙 비참조 per-product GROUNDED 14 prd_cd 리스트 대조로 전환(과적용 독립 검출). 상세 = §보정 이력.

| 파일 | 대상 테이블 | 결함 | 성격 | 행수 |
|------|------------|------|------|:----:|
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R1·R2·R4 완칼·UV·부착 (active) | INSERT | **28**(완칼14+UV14+부착1) |
| `t_prd_product_processes_conditional.csv` | (보류·조건부) | 151 PROC_000081 부착 (라이브 기적재 중복PK) | INSERT-조건부 | **1** |
| `load/t_prd_product_materials.csv` | t_prd_product_materials | R3 부속자재 MAT_TYPE.07 (active) | INSERT | **10** |
| `load/t_prd_product_bundle_qtys.csv` | t_prd_product_bundle_qtys | R2 조각수 (active) | INSERT | **6** |
| `load/t_prd_product_materials_thickness_update.csv` | t_prd_product_materials (UPDATE) | R3 두께정정 192→042/043/044 | UPDATE | **20** |
| `load/t_prd_product_print_options_uv_update.csv` | t_prd_product_print_options (UPDATE) | R5 UV변형 오적재 정정 | UPDATE | **20** |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R8 qty_unit→EA | UPDATE | **23** |
| `load/t_prd_products_nonspec_update.csv` | t_prd_products (UPDATE) | R6 nonspec 범위 | UPDATE | **12** |
| `_deferred/t_prd_product_processes_deferred.csv` | (보류) | use_yn=N 6상품 완칼·UV(12) + 완칼 over-reach 161·168·169(3) | INSERT-보류 | 15 |
| `_deferred/t_prd_product_materials_deferred.csv` | (보류) | use_yn=N 부속자재 | INSERT-보류 | 4 |
| `_deferred/t_prd_product_bundle_qtys_deferred.csv` | (보류) | use_yn=N 조각수 | INSERT-보류 | 0 |

생성기 `gen_load.py`(재현 가능) · 검증 `verify_expected.py`(게이트 **PASS — 누락0·날조0, exit 0**, §expected-vs-load).

- **active INSERT 합계: process 28(완칼14+UV14+부착1) + material 부속 10 + bundle_qty 6 = 44행.** (보정 전 49 → 151부착 −1·완칼 over-reach −3·∴ process −5 = −5 → 44)
- **active UPDATE 합계: 두께정정 20 + UV정정 20 + qty_unit 23 + nonspec 12 = 75행.** (UPDATE는 보정 무관)
- **conditional 합계: process 1(151 PROC_000081 부착, 적재 직전 라이브 재확인).**
- **deferred 합계: process 15(비활성 6상품 12 + over-reach 161·168·169 3) + material 4 + bundle 0 = 19행.**

---

## 1. CRITICAL — 모집단 확정 (적재 선행)

**라이브 등록 23상품**(PRD_000146~169) 중 적재 모집단 분류:

| 분류 | 상품(prd_cd) | 적재 처리 |
|------|------------|-----------|
| **active (use_yn=Y, L1 앵커 보유)** 17 | 146·147·148·149·150·151·152·154·155·157·158·160·161·162·163·168·169 | `load/` active |
| **inactive (use_yn=N, C-1 비활성)** 6 | 153 명찰골드실버·156 지비츠(단품)·159 코스터·164 코롯토·165 포카코롯토·166 카라비너 | `_deferred/` 보류 |
| **stale 중복 후보** 1 | **167 아크릴코롯토(중복, file_upload_yn=N·고유 L1 앵커 부재)** | **분리·flag(D-AC-6)** |
| **★미등록 (L1 hidden, prd_cd 부재)** 2 | 아크릴쉐이커★·지비츠★(조합형) | 모집단 외(미등록, C-1) |

- **167 처리(추정 0 원칙):** ref-products는 167을 등록·use_yn=Y로 보이나, L1에 167 고유 앵커(상품행)가 없다(아크릴코롯토는 164에 1:1, 입체코롯토는 168). 167에 L1 옵션을 매핑하면 **날조** → 적재 모집단에서 분리하고 `D-AC-6`로 라이브 재확인 컨펌. remediation 문서는 "167 결번"이라 했으나 **stale ref는 167 등록**으로 갈려 **단정 불가**(권위 충돌). **라이브 SELECT 1회로 즉시 해소**.
- **★ 2상품(쉐이커·지비츠★):** L1 전행 숨김+★ = 미출시 비활성(C-1). prd_cd 자체 부재 → 적재 불가, MISSING 아님.

> **주의 — 동명이상품 2종:** L1에 `아크릴지비츠`(단품형, hidden=false, **PRD_000156 use_yn=N**)와 `지비츠★`(조합형, hidden=true, **미등록**)가 별개로 존재. 156은 deferred(비활성), 지비츠★는 모집단 외(미등록). 혼동 금지.

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`)는 건전(두께 042/043/044·부속 045~057·완칼 053·부착 081·UV 002 전부 실재) → **상품 연결 테이블만** 적재.

```
① qty_unit UPDATE (t_prd_products)        — 컬럼 업데이트, FK 무관, 독립
② nonspec UPDATE (t_prd_products)         — 컬럼 업데이트, FK 무관, 독립
③ size                                     — n/a (21/23 기적재, 본 범위 외)
④ material 두께정정 UPDATE (192→042/043/044) — 기존행 mat_cd 교체. FK: target mat_cd→t_mat
⑤ material 부속 INSERT (MAT_TYPE.07)       — FK: prd_cd→t_prd_products, mat_cd→t_mat(045~057)
⑥ process INSERT (완칼053·UV002·부착081)    — FK: prd_cd→t_prd_products, proc_cd→t_proc
   + print_side 정정 UPDATE (R5)            — UV변형을 process로 이동, print_side 기존행 정정
⑦ bundle_qty INSERT (조각수)               — FK: prd_cd→t_prd_products, bdl_unit_typ_cd→QTY_UNIT
   excl_group                              — n/a (택일그룹 전무=정상)
   addon                                   — n/a (볼체인 기적재, §3 R7 flag)
   page_rule                               — n/a (낱장굿즈→정상 전무)
```

**no-op 단계와 사유:**
- **excl_group 전무 = 정상**: 아크릴은 공정 택일그룹 부재(택일은 책자·캘린더 도메인).
- **page_rule 전무 = 정상**: 낱장 굿즈엔 페이지 규칙 무의미.
- **size 본 범위 외**: 21/23 기적재(입체코롯토만 0=사용자입력). 본 패스는 R1~R8 결함에 집중.
- **addon 신규 0**: 볼체인 6색은 라이브 기적재 1행(PRD_000006)/상품 — 추정 금지로 **변경 없음**(§3 R7 flag).

**순서 근거:** ④두께정정은 기존 192 행을 교체(INSERT 아님)이므로 부속 INSERT(⑤)와 독립. process(⑥)는 prd_cd FK만 필요(완칼 param·UV변형은 마스터 `prcs_dtl_opt` 상속). bundle_qty(⑦)는 `bdl_unit_typ_cd`가 QTY_UNIT 코드그룹을 FK로 가리킨다.

---

## 3. R-카테고리별 적재 설계

### R1 (High·BLOCKER급) — 완칼(die-cut) 공정 묵시필수 [process 053, active 17행]

**도메인 근거(G-AC-1, C-7 binding):** 아크릴 굿즈는 전부 시트에서 모양대로 잘라낸다 = **완칼 PROC_000053**(KB "Die Cut, 종이+후지 자름"). 엑셀에 명시 컬럼이 없어 원적재가 누락 → 도메인 묵시필수.

**변환 로직:** **active GROUNDED 14상품** → `(prd_cd, PROC_000053, mand_proc_yn=Y, disp_seq=12)`. 완칼 `모양` param(사용자입력형=사용자 모양)은 마스터 `prcs_dtl_opt`에 보유 — 상품 연결행은 **proc_cd FK만** 적재.

> **[코드 의미축 한계 — D-AC 컨펌, 2026-06-05 명시]** 아크릴 모양컷의 **도메인 공정은 레이저커팅**(07_domain `process-recipe-tree.md` line 97/99/116·`entity-semantic-model.md` line 75: "acrylic 전체 = UV→레이저커팅→아크릴가공")이다. 그러나 **마스터 83공정 중 레이저커팅/아크릴가공 proc_cd가 부재**(컷계열 = 완칼053·반칼054·스티커완칼055 = 전부 종이/스티커용)라, 053(종이/스티커 완칼)을 **차용**한다. RULE 레벨(C-7 "아크릴 절단=완칼-family 공정 적재")은 grounded이나 코드 의미는 정확히 일치하지 않음 — **아크릴 레이저커팅 proc_cd 신설 컨펌 필요(D-AC-8)**. provenance에 차용 사실 추적.

- **완칼 가격(재단/완칼 엑셀 2개 비교, C-7)** = **round-2 가격엔진 영역**. 9속성은 **공정 적재까지**.
- **active 14행(보정)** = GROUNDED 14상품(146·147·148·149·150·151·152·154·155·157·158·160·162·163) 각 1행. 비활성 6상품 + over-reach 3상품(161·168·169)은 deferred.
- **[보정 2026-06-05 — MAJOR over-reach 분리]** 보정 전 active 17 → **161·168·169 분리로 14**. 사유: ① **161 판아크릴** = recipe tree Case10 "UV단품→포장"으로 **컷 단계 자체 부재**(판=직사각 원판 가능성), ② **168 입체코롯토** = L1 소재/인쇄사양/조각수/가공 **전부 공백**(옵션 신호 0, 완칼 근거 셀 부재), ③ **169 입체블럭** = 라미(10T) 적층 블럭(시트컷 아닌 조립/적층 가능성). 셋 다 **product-level 근거 없는 C-7 RULE blanket 확대** → `_deferred/`로 보류·컨펌(D-AC-8). GROUNDED 14는 단품/조합 굿즈=모양대로 잘린 개별 아크릴 조각이라 UPHOLD.
- **PROC_000053 선택 근거(C-7 "PROC_000053/054"):** 053=완칼(모양 param), 054=반칼(모양+조각수). 아크릴 절단=완전절단이므로 **053(완칼)** 채택. 조각수는 별도 차원(bundle_qty, R2)이라 053+조각수=bundle 분리가 C-7("묶음수로 표현·위젯 조각수 표시") 정합.

> **provenance 예:** `도메인(아크릴 die-cut 묵시필수, G-AC-1/C-7): 아크릴키링 → 완칼 PROC_000053 (모양 param=사용자입력형)`

### R2 (High) — 조각수 공정 → bundle_qty [process(완칼 공유) + bundle_qty 6행]

**도메인 근거(G-AC-2, C-7):** L1 `조각수(옵션)` = 자유형스탠드(160) `2~6조각`·미니파츠(163) `10조각`. C-7 확정: **조각수 = bundle_qty 차원으로 DB 표현, 위젯 표시는 "조각수"**.

**변환 로직(2축):**
1. **완칼 공정**(053)은 R1에서 이미 적재(자유형스탠드·미니파츠 포함) — 조각수형도 die-cut.
2. **조각수 = `t_prd_product_bundle_qtys` 행**: 자유형스탠드 `bdl_qty ∈ {2,3,4,5,6}`(5행)·미니파츠 `bdl_qty=10`(1행) = **6행**. `bdl_unit_typ_cd=QTY_UNIT.01(EA)` — "조각" 전용코드 부재라 EA 재사용(`bdl_unit_typ_cd`는 QTY_UNIT 그룹 재사용, code-values.md). dflt_yn=Y(최소조각).

- **bundle_qty 컬럼 = `prd_cd,bdl_qty(integer),bdl_unit_typ_cd,dflt_yn,disp_seq`** — 조각수를 정수로 직재. 위젯은 이 정수를 "N조각"으로 렌더.

> **provenance 예:** `L1:아크릴자유형스탠드 조각수(옵션)=2조각 → bundle_qty 2 (C-7 조각수=묶음수차원·위젯표시 조각수). bdl_unit=EA(조각 코드부재)`

### R3 (High) — 두께 variant 분해(자재정정) + 부속자재 [두께 UPDATE 20행, 부속 INSERT 10행]

**도메인 근거(G-AC-3, C-8 binding):** 두께 = 자재 식별자. L1 `투명아크릴 3mm`·`8mm`(코롯토)·`1.5mm`(미니파츠). 마스터 MAT_000042(1.5mm)·043(3mm)·044(8mm) 실재. 원적재는 **두께없는 192 일괄** → 두께 소실. **부속**(자석/핀/고리/집게/헤어끈/바디)은 MAT_000045~057 실재하나 상품 미연결.

**① 두께정정 (UPDATE성, 20행) — C-8 과세분화 균형:**

| L1 소재 | → mat_cd | 적용 상품 | 비고 |
|---------|:--------:|----------|------|
| `투명아크릴 1.5mm` | **MAT_000042** | 미니파츠(163) | |
| `투명아크릴 3mm` | **MAT_000043** | 키링·마그넷·뱃지·집게·스마트톡·맥세이프·명찰·머리끈·볼펜·지비츠·네임택·포카키링·코스터·자유형스탠드·판아크릴·포카스탠드·카라비너 | 대부분 |
| `투명아크릴 8mm`·`(8T)` | **MAT_000044** | 코롯토(164)·포카코롯토(165) | |
| `3mm+3mm 접합`(카라비너166) | **MAT_000043** | 카라비너 | 접합=공정이나 마스터 접합공정 부재 → 3mm 정정+note만 |
| `라미(10T)`(입체블럭169) | **(정정 불가)** | 입체블럭 | **10T 두께코드 마스터 부재 → 발명금지, 192 유지 + flag(D-AC-2)** |
| `골드/실버아크릴 3mm`(명찰골드실버153) | **(정정 대상 아님)** | 명찰골드실버 | 색상자재 195/196 이미 정상 적재(C-8 통합관리) |
| `(소재칸 공란)`(입체코롯토168) | **(no-op)** | 입체코롯토 | L1 소재 없음 → 자재행 자체 미적재 |

- **C-8 적용**: 두께를 042/043/044로 분해하되, **골드/실버(색상)은 195/196 통합 유지**(과세분화 금지 — "금색 열쇠고리가 관리 유리"). 10T 발명 금지.
- **UPDATE 성격**: 192 기존 1행을 두께코드로 **교체**(INSERT 아님). 별도 `t_prd_product_materials_thickness_update.csv`에 `prd_cd, current_mat_cd(192), target_mat_cd, target_mat_nm` 기록. **active 17 + 비활성 3(코롯토164·포카코롯토165·카라비너166) = 20행**(UPDATE는 비활성 무관, 출시 시 즉시 유효).

**② 부속자재 INSERT (MAT_TYPE.07, active 10행):**

| L1 가공명 → mat_cd | 상품 |
|---------------------|------|
| 은색고리 051·금색고리 052 | 키링(146) |
| 원형핀 047·1구자석 048 | 뱃지(148) |
| 투명집게 056 | 집게(149) |
| 화이트바디 054·투명바디 053 | 스마트톡(150) |
| 일자핀 046·2구자석 049 | 명찰(152) |
| 블랙헤어끈 057 | 머리끈(154) |

- **부속자재만 적재**(마스터 실재). **색상-only 가공은 부속 아님 → 미적재**: 고리없음(146)·볼펜색6(155)·지비츠 투명/스핀(156)·네임택 와이어링/스트랩(157)·카라비너 색상고리(166 화이트~핑크). 마스터 부속코드 부재 → **추정으로 발명 금지**(flag D-AC-4).
- **자석부착/맥세이프 = 부착공정(R4), 자재행 아님.** dflt_yn=N, disp_seq 11부터.
- **비활성(153 명찰골드실버 일자핀·2구자석, 166 카라비너 실버/골드고리) = deferred 4행.**

> **provenance 예:** `L1:아크릴키링 가공(옵션)=은색고리 → 부속자재 MAT_000051 아크릴부속 은색고리 (MAT_TYPE.07, G-AC-3)`

### R4 (Medium) — 부착공정 [process 081, active 2행]

**도메인 근거(G-AC-4, C-6 맥락별):** 가공 중 `자석부착`(마그넷147)·`맥세이프스마트톡`(맥세이프151) = **부착공정 PROC_000081**(대상 enum: 라벨/맥세이프/끈/테입). C-6: 부속은 맥락별 — 자석부착/맥세이프는 "부착 행위"라 공정축.

- **변환 로직:** `(prd_cd, PROC_000081, mand_proc_yn=N, disp_seq=19)`. 대상 param은 마스터 상속.
- **active 1행(보정)**(마그넷147만). **[보정 2026-06-05 — BLOCKER 해소]** 맥세이프151 PROC_000081은 **라이브 기적재(중복PK)**라 active에서 제거 → `t_prd_product_processes_conditional.csv`로 이동(적재 직전 라이브 SELECT로 151 부착 부재 확인 후에만 적재). 147 자석부착은 미적재라 신규 active. digital-print 016 conditional 처리 동형.
- **이중성 처리(C-6):** 맥세이프 부속자재(MAT_000055)는 적재하지 않고 **부착공정으로만** 모델링(라이브 맥세이프=PROC_000081만 기적재와 정합). 자석부착도 자재(050) 아닌 공정. 핀/고리류는 **자재축**(R3 부속)으로 처리 — 부착성격이나 마스터 부속코드가 자재로 존재해 자재축 채택(C-6 "열쇠고리=부자재").

> **[해소 2026-06-05]** 맥세이프(151) PROC_000081은 conditional CSV로 분리됨(active에서 제거). 적재 직전 라이브 SELECT로 151 부착 부재 시에만 active 승격, 실재 시 폐기(D-AC-1). 마그넷(147) 자석부착은 미적재라 신규 active.

### R5 (High) — UV변형 오적재 정정 [print_side UPDATE 20행]

**도메인 근거(G-AC-5, entity-semantic-model §3):** L1 `인쇄사양` = `배면양면/풀빼다/투명테두리/단면인쇄` = **UV(PROC_000002) `변형` enum**(일반/배면양면/풀빼다/투명테두리/단면). 원적재가 이를 `print_options.print_side`(인쇄면 도수)에 오적재 → 의미축 MISMATCH.

**변환 로직(2축 동시):**
1. **UV process INSERT**(R1과 함께 `t_prd_product_processes.csv`): L1 인쇄사양 보유 상품 → `(prd_cd, PROC_000002, mand_proc_yn=Y, disp_seq=5)` **1행/상품**(변형값 다수는 마스터 `변형` enum param이라 1 process). active **14행**.
2. **print_side 정정(UPDATE-set)**: 오적재된 `print_side=배면양면/풀빼다/투명테두리` 행을 → 실제 단/양면으로 정정 필요. **`t_prd_product_print_options_uv_update.csv`**에 `prd_cd, current_print_side_values, action, target_print_side(미상=컨펌)` 기록. **20행**(라이브 print_options 보유 20상품).

- **`target_print_side` 미상**: 실 단/양면 도수가 L1·라이브에 명시 없음 → **추정 금지, 컨펌 D-AC-3**. 인쇄방식(PROC_000002~6) 272 전상품 미연결 글로벌 갭과 연동.
- **UPDATE 성격 강조**: print_side 정정은 **기존행 변경**(삭제·INSERT 아님). UV process는 신규 INSERT. 둘을 분리 산출.

> **provenance 예:** `라이브 print_options:아크릴키링 print_side=배면양면 = UV변형(인쇄면 아님) → process 이동(G-AC-5)`

### R6 (Medium) — nonspec(사용자입력) 범위 [nonspec UPDATE 12행]

**도메인 근거(G-AC-6):** L1 11+상품이 `사용자입력` 사이즈 + 비규격 가로/세로 범위 보유. 라이브 `nonspec_width/height_min/max` = 전 23상품 NULL. `t_prd_products.nonspec_*` 컬럼 실재(numeric 8,2).

**변환 로직:** L1 `비규격(최소/최대)_가로`·`_세로`(예 `20~100`) → `nonspec_width_min/max`·`nonspec_height_min/max` + `nonspec_yn=Y`. **`t_prd_products_nonspec_update.csv`** 12행:

| 상품 | 가로 | 세로 |
|------|------|------|
| 키링(146) | 20~100 | 20~100 |
| 마그넷(147) | 20~80 | 20~80 |
| 뱃지(148) | 30~80 | 30~80 |
| 집게(149) | 30~60 | 30~60 |
| 스마트톡(150)·맥세이프(151) | 50~80 | 50~80 |
| 명찰(152)·명찰골드실버(153) | 60~80 | 20~50 |
| 머리끈(154)·볼펜(155) | 20~40 | 20~40 |
| 지비츠(156) | 15~35 | 15~35 |
| 코롯토(164) | 30~80 | 30~80 |

- **UPDATE 성격**: `nonspec_yn` N→Y + 범위 4컬럼. **active 9 + 비활성 3(153·156·164) = 12행**.
- **입체코롯토(168)**: 라이브 nonspec_yn=Y이나 width/height NULL, L1 비규격 범위 부재 → **범위 미적재**(L1 근거 없음, 발명 금지).

> **provenance 예:** `L1:아크릴키링 사용자입력+비규격 가로20~100/세로20~100 → nonspec 범위(G-AC-6)`

### R7 (Low) — 볼체인 6색 addon [적재 변경 없음, flag]

**도메인 근거(G-AC-7):** L1 키링(146)·포카키링(158) 추가상품 = 볼체인 (선택안함+8색: 오렌지/핑크/핫핑크/민트그린/블루/바이올렛/블랙/화이트). 라이브 = `PRD_000006 볼체인(선택안함)` **1행씩 기적재**.

- **판정:** 8색이 addon 1상품(볼체인 PRD_000006)의 색상 variant인지 N개 addon인지 미확정. **추정 금지 → 적재 변경 없음**(현 1행 유지). 색상축 결정 후 적재(D-AC-5).
- **C-8 정합:** 볼체인 색상을 8 addon으로 펼치면 과세분화. variant(색상축)로 묶는 게 관리 유리 — 단 위젯 표시 방식이 변수라 컨펌.

### R8 (Medium) — qty_unit 일괄 부여 [qty_unit UPDATE 23행]

**도메인 근거(G-AC-9, C-4 binding):** "상품군별 기본 일괄 부여" + **굿즈→EA**. 아크릴 굿즈 → **QTY_UNIT.01(EA)**.

- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트. **`t_prd_products_qtyunit_update.csv`** 23행(등록 23상품 전건, 167 제외 후 모집단 23 = active 17 + 비활성 6). 라이브 현재 전건 NULL.
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품 — 본 set은 acrylic 23건만. 전사 정책(낱장=매/책자=권/굿즈=EA)은 별도 일괄(C-4).

---

## 4. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | 성격 | active | 보류(deferred) | flag/no-op |
|---|------|------------|------|:------:|:----:|----------|
| R1 | 완칼 묵시필수 | t_prd_product_processes | INSERT | **14**(보정 17→14) | 6+3※ | ※161·168·169 over-reach deferred |
| R2 | 조각수 | t_prd_product_bundle_qtys | INSERT | **6** | 0 | — |
| R3-① | 두께정정 | t_prd_product_materials | UPDATE | **20**(17+3비활성) | — | 10T·골드실버 정정제외 |
| R3-② | 부속자재 | t_prd_product_materials | INSERT | **10** | 4 | 색상-only 부속 미적재 |
| R4 | 부착공정 | t_prd_product_processes | INSERT | **1**(보정 2→1) | 0 | 151 맥세이프 conditional(중복PK) |
| R5 | UV변형 정정 | print_options(UPDATE)+processes(INSERT) | UPDATE+INSERT | UV proc **14** / print_side **20** | (deferred에 UV 6) | target 단/양면 컨펌 |
| R6 | nonspec 범위 | t_prd_products | UPDATE | **12**(9+3비활성) | — | 입체코롯토 범위부재 |
| R7 | 볼체인 6색 | t_prd_product_addons | (변경없음) | 0 | — | 색상 variant flag |
| R8 | qty_unit→EA | t_prd_products | UPDATE | **23** | — | — |

- **process active 28(보정)** = 완칼 14 + UV 14 + 부착 1. **process conditional 1** = 151 부착(중복PK). **process deferred 15** = 비활성 6상품 ×(완칼1+UV1)=12 + over-reach 완칼 3(161·168·169).
- **완칼+조각수 건수: 완칼 14상품(active, 보정) + 조각수 2상품(자유형스탠드 5행·미니파츠 1행=6 bundle).**
- **두께 variant 분해: 20 UPDATE**(192→042 1·043 16·044 2 + 10T/골드실버 정정제외 명시).

---

## 5. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-AC-1** | 맥세이프(151) PROC_000081 중복 | **conditional 분리(보정)** — active에서 제거→`t_prd_product_processes_conditional.csv` | 라이브에 151 부착공정 이미 있나? 있으면 폐기(중복PK), 없으면 active 승격. 라이브 SELECT 1회 |
| **D-AC-2** | 입체블럭(169) 라미 10T 두께 | 192 유지·정정제외(flag) | 10T 두께코드 신설할지, 192 유지할지? (마스터 042/043/044만=1.5/3/8mm) |
| **D-AC-3** | UV변형 정정 후 print_side 목표값 | 미상·컨펌(정정 set만) | UV변형을 process로 옮긴 뒤 print_side 실 단/양면은? 인쇄방식 272 전상품 미연결 글로벌 갭과 함께 정책 결정 |
| **D-AC-4** | 색상-only 가공 부속 | 미적재(발명금지) | 볼펜색6·지비츠형상·네임택와이어링·카라비너 색상고리 = 부속 마스터 미존재. 신규 부속코드 등록? 색상 variant? |
| **D-AC-5** | 볼체인 6/8색 addon | 변경없음(기적재 1행) | 색상=addon 색상 variant(1상품+색옵션)인가 N개 addon인가? (C-8 과세분화 균형) |
| **D-AC-6** | 167 아크릴코롯토 중복 | 모집단 분리(flag) | ref=등록·use_yn=Y이나 L1 고유앵커 부재. 164와 별개 상품인가 stale 중복인가? 라이브 SELECT 1회 |
| **D-AC-7** | qty_unit 비활성 6상품 포함 | 포함(23건) | 미출시 상품도 지금 EA 부여? (컬럼 업데이트라 무해하나 정책 확인) |
| **D-AC-8** | 완칼 over-reach 161·168·169 + 053 코드 의미축 한계 | **3건 `_deferred/`로 보류(보정)** + 053(종이/스티커) 차용 명시 | ① 161 판아크릴(recipe상 컷 없음)·168 입체코롯토(L1 신호 전무)·169 입체블럭(라미 적층) = 완칼 적용 맞나(product-level 근거 부재)? ② 아크릴 모양컷 도메인공정=레이저커팅인데 마스터 proc_cd 부재 — 053 차용 유지 vs 레이저커팅 proc_cd 신설? |

> **D-AC-1·D-AC-6은 라이브 SELECT 1회로 즉시 해소** — 적재 직전 라이브 export로 verify 재실행 시 자동 검출. **D-AC-8(over-reach 3·053 코드)은 도메인 컨펌 항목**(라이브 SELECT 무관, 사용자 판단 필요).

---

## 6. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 자재/process/addon 기적재 판정에 사용.
- **판정이 stale에 의존하는 지점** = D-AC-1(맥세이프 부착 중복)·D-AC-6(167 등록 실태)·R3 두께정정(192 기적재 전제)·R5 print_side 기적재(20상품).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0**"(자기검증 PASS, `expected-vs-load.md`).
- **EXTRA 삭제 절대 금지**: 본 패스는 누락 행 추가 + UPDATE 정정만 — 어떤 행도 삭제 제안하지 않음. UV변형 print_side 행도 삭제 아닌 정정(UPDATE).

---

## 7. 보정 이력 (Wave B2 검증 후속, 2026-06-05)

`03_validation/waveB2-load-validation.md` 판정 **CONDITIONAL GO(1 BLOCKER + 1 MAJOR)** 해소. DB 미적재 유지·추정/발명 0.

| # | 등급 | 항목 | 보정 전 | 보정 후 | 산출물 변경 |
|---|------|------|---------|---------|-------------|
| 1 | **BLOCKER** | 151 PROC_000081 부착 중복PK | active 적재(D-AC-1 flag만, 행 잔존) | active에서 **제거 → conditional 분리** | `load/t_prd_product_processes.csv` −1행 / `t_prd_product_processes_conditional.csv` 신설(1행, reason="151 맥세이프 부착 기적재, 중복PK, 적재 직전 재확인") |
| 2 | **MAJOR** | 완칼 over-reach 161·168·169 | active 17(blanket) | **active 14**(161·168·169 deferred) | `load/t_prd_product_processes.csv` 완칼 −3행 / `_deferred/...processes_deferred.csv` +3행(reason="product-level 완칼 근거 부재, 특히 168 L1 신호 전무 — 컨펌") |
| 3 | **코드 note** | 053 의미축 한계 | 무명시 차용 | **§3 R1·§5 D-AC-8에 "053=종이/스티커 완칼, 아크릴 레이저커팅 proc_cd 신설 컨펌" 명시** | load-spec.md 본문(코드 변경 없음) |
| 4 | **순환검증** | 생성기·검증기 동일 `diecut=True` | 과적용 검출 불가 | **per-product GROUNDED 14 prd_cd 리스트 대조**(생성기 비참조) + `R1-diecut-overreach` 독립 가드 | `verify_expected.py` R1-diecut·R1-attach 강화 |

**게이트 영향:** R1-diecut-active **17→14**(PASS) · R1-attach-active **2→1**(PASS) · 신규 R1-diecut-overreach **0**(PASS). 161/168/169 active 재주입 시 FABRICATED+over-reach 가드 둘 다 발화(adversarial test 확인). 161의 **UV행은 active 유지**(인쇄사양=배면양면 L1 실재, 완칼만 보류).

**해소되지 않은 컨펌(적재 차단 아님, 사용자 판단):** D-AC-8(over-reach 3건 도메인 판정 + 053 vs 레이저커팅 신설). D-AC-1/D-AC-6은 적재 직전 라이브 SELECT 1회로 자동 해소.
