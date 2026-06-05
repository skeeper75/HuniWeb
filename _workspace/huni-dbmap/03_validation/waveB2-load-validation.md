# acrylic · silsa 적재 설계 독립 검증 — dbm-validator (Wave B2, round-3 remediation 전수 확장)

> **작성** 2026-06-05 · dbm-validator(독립 적대적 검증) · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **검증 대상:** `09_load/acrylic/`(대량 적재) · `09_load/silsa/`(모범 정합). 서로 다른 에이전트가 작성 — 검증자는 작성하지 않았다. 기본 입장 = 회의(결함 입증 책임은 검증자에게).
> **권위 순서(HARD):** 라이브 DB > `08_remediation/{acrylic,silsa}.md` 기록 라이브결과 > `ref-*.csv`(stale 2026-06-04). 엑셀 L1 > 정규화.
> **DB 쓰기 0** — 정적 검증(columns·ref·L1) + 게이트 재실행만. 라이브 SELECT는 미수행(stale ref + remediation 기록 라이브로 판정, 적재 직전 라이브 재확인을 HARD 조건으로 남김).
> **검증 메서드:** `03_validation/dp-load-validation.md`(digital-print 파일럿) 동형 — 게이트 재실행 → 독립 재산출 → 적재성 DRY-RUN → 쟁점 적대적 재판정.

---

## 0. 최종 판정

| 시트 | 판정 | 핵심 사유 |
|------|------|----------|
| **acrylic** | **CONDITIONAL GO (1 BLOCKER + 1 MAJOR 해소 조건)** | 적재성·FK·PK 통과, UV/두께/조각수/nonspec/qty_unit 전부 L1 grounded. 단 ① **완칼 17건 = 도메인 RULE(C-7)로는 grounded하나 product-level 무차별 적용 + 도메인 권위(레이저커팅)와 코드 불일치 = MAJOR 재판정 대상** ② **151 PROC_000081 active CSV 잔존 = 중복 PK BLOCKER**(D-AC-1 flag만 하고 행 미제거). |
| **silsa** | **GO-WITH-FINDINGS** | 모범 시트. 적재성·FK·PK·모범재적재0 전부 통과. active 43행 전부 grounded, 보류 18 전부 발명회피 정당. 잔여 = stale 의존 라이브 재확인 + qty_unit EA/매 컨펌. **재적재 0 입증(OVERTURN 없음).** |

**전사 NO-GO 블로커:** 1건 — **acrylic 151 중복 PK 행**(아래 §3-A-BLOCKER). 행 제거 또는 적재 직전 라이브 재확인으로 즉시 해소 가능.

---

## 1. 게이트 재실행 — 둘 다 PASS(byte-identical 재현, exit 0)

설계자 보고와 동일 재현. 생성기(`gen_load.py`) 미신뢰, 게이트는 L1·ref 독립 재산출 대조.

```
=== acrylic ===                         === silsa ===
R1-diecut-active   17 17 0 0 PASS       R2-white-spot       1  1 0 0 PASS
R1-uv-active       14 14 0 0 PASS       mobeum-no-reload    0  0 - 0 PASS
R1-attach-active    2  2 0 0 PASS       R4-nonspec         13 13 0 0 PASS
R3-mat-thickness   20 20 0 0 PASS       R6-qtyunit         28 28 0 0 PASS
R3-mat-accessory   10 10 0 0 PASS       R3-addon            1  1 0 0 PASS
R2-bundle-piece     6  6 0 0 PASS       FK-existence        -  - - 0 PASS
R6-qtyunit         23 23 0 0 PASS       nonspec-num(8,2)    -  - - 0 PASS
R6-nonspec         12 12 0 0 PASS       GATE: PASS (exit 0)
FK / active-no-N    -  - - 0 PASS
GATE: PASS (exit 0)
```

> **게이트 한계(HARD, dp 파일럿 공통 결함 재확인):** 게이트는 use_yn·기적재를 **stale ref**에서 읽는다. PASS = "추출본 기준 누락0·날조0"일 뿐, 라이브 미반영. **적재 직전 동일 스크립트를 라이브 export로 1회 재실행이 무위험 GO의 HARD 조건**(검증 권위 반전 원칙). 또한 완칼 게이트는 §3-A에서 보듯 **순환 구조**(생성기·검증기 둘 다 동일 하드코딩 `diecut=True` 사용 → 과적용 검출 불가).

---

## 2. 독립 재산출 + 적재성 DRY-RUN (정적: ref 헤더·L1·base-codes·라이브 기록)

### 2-1. 카운트 독립 재산출 — 일치

- **acrylic 완칼 17** = use_yn=Y 17상품(146·147·148·149·150·151·152·154·155·157·158·160·161·162·163·168·169). 검증자 직접 재집계 일치.
- **UV 14** = 인쇄사양(UV변형) 보유 active 상품. **14상품 전부 L1 `인쇄사양` 셀 실재 확인**(키링 배면양면 … 미니파츠 배면양면). 발명 0.
- **두께 20** = 192→{042 1·043 17·044 2}. 검증자 L1 소재 대조: 3mm→043, 1.5mm(미니파츠)→042, 8mm(코롯토·포카코롯토)→044, 접합(카라비너)→043+note. **20건 전부 L1 소재 정확 매핑.**
- **조각수 6** = 자유형스탠드(160) bdl_qty∈{2,3,4,5,6} 5행 + 미니파츠(163) bdl_qty=10 1행. L1 조각수 셀(160=2~6조각, 163=10조각) 정확.
- **nonspec 12 / qty_unit 23**: 167 제외 모집단 23(active 17+비활성 6). nonspec은 L1 비규격 범위 보유 12상품.
- **silsa nonspec 13**(포스터/패브릭 11+현수막 2)·**qty_unit 28**(등록 전건)·**화이트별색 1**(접착투명포스터122)·**addon 1**(족자포스터135→천정고리). 전부 L1 신호 실재.

### 2-2. 적재성 DRY-RUN (type·NOT NULL·FK·PK)

| 테이블(행수) | type/length | NOT NULL(PK) | FK 실재 | PK-dup(in-CSV) | 판정 |
|--------------|:-----------:|:------------:|:-------:|:--------------:|:----:|
| acr `_processes`(33 INSERT) | OK(mand∈{Y,N}·disp_seq int) | OK | proc_cd→t_proc 33/33·prd_cd 실재 | 0 | OK |
| acr `_materials`(10 INSERT) | OK(usage=USAGE.07 실재·dflt∈{Y,N}) | OK(prd·mat·usage 복합키) | mat_cd→t_mat 10/10(045~057) | 0 | OK |
| acr `_bundle_qtys`(6 INSERT) | OK(bdl_qty int·QTY_UNIT.01 실재) | OK | bdl_unit_typ_cd→QTY_UNIT 실재 | 0 | OK |
| acr thickness_update(20) | OK(target_mat_cd 042/043/044 실재) | n/a(UPDATE) | 20/20 prd 실재·target mat 실재 | n/a | OK |
| acr print_options_uv_update(20) | OK(6컬럼 정상 파싱) | n/a(UPDATE) | 20/20 prd 실재 | n/a | OK※ |
| acr qtyunit_update(23)·nonspec_update(12) | OK(QTY_UNIT.01·numeric(8,2) bound 0위반) | n/a | 23/23·12/12 prd 실재 | n/a | OK |
| silsa `_processes`(1)·`_addons`(1) | OK(PROC_000008·PRD_000008 실재) | OK | 1/1·1/1 | 0 | OK |
| silsa nonspec(13)·qtyunit(28) | OK(numeric(8,2) max 5000.00 bound내·QTY_UNIT.01) | n/a | 28/28 prd 실재 | n/a | OK |

- **검증자 잠정의심 RETRACT:** `print_options_uv_update.csv` PRD_000147 `current_print_side_values`가 표시상 `풀빼다 | 투명테두리 | 단면인쇄`로 3분할돼 보여 **컬럼수 깨짐 의심**을 제기했으나, csv 파서 검증 결과 **6컬럼 정상**(다값이 quoted 단일 필드). 컬럼 깨짐 0 — **의심 철회.**
- **silsa mobeum-no-reload 독립 검증:** silsa `load/` 전 CSV 텍스트에서 PROC_000079/080/081/082/014/015/016/053/054 **단 1건도 미검출**. 모범 봉제/타공/족자/부착/코팅 재적재 0 기계 보증 확인.
- **FK 전수(검증자 독립, ref 마스터 대조):** acr proc 33·mat 10·thickness 20 / silsa proc 1·addon 1 = **FK-missing 0**. (proc master 83·mat master 336·prd master 280.)

---

## 3. 적대적 재판정 (라이브 권위 + 도메인 권위 대조)

### A. acrylic 완칼 17건 (G-AC-1) — **부분 OVERTURN: RULE은 grounded, BLANKET 적용은 over-reach (MAJOR)**

**핵심 사실(검증자 독립 규명):**
1. L1에 완칼 명시 컬럼 **부재**(헤더 45컬럼 전수 확인) — 설계자 주장대로 도메인 추론.
2. 생성기·검증기 **둘 다 23상품에 `diecut=True` 하드코딩** → 게이트 "완칼 17 누락0·날조0"은 **순환 검증**(독립 L1 신호 대조 불가, 과적용 검출 구조적 불가능).
3. **C-7(사용자 컨펌, binding):** "완칼도 공정이나 … 완칼(PROC_000053/054) = 공정으로 적재." → **"아크릴 절단 = 완칼-family 공정 적재"는 RULE 레벨에서 사용자 권위로 grounded.** 발명 아님.
4. **그러나 도메인 권위(07_domain)와 코드 불일치:**
   - `process-recipe-tree.md` line 97/99/116·`entity-semantic-model.md` line 75: **"acrylic 상품군 전체 = UV→레이저커팅→아크릴가공"**. 아크릴 모양 컷의 도메인 공정은 **레이저커팅**이지 완칼(053=종이+후지 자름, Case2 스티커·line42 silsa 전용)이 아니다.
   - 마스터에 레이저커팅/아크릴가공 proc_cd **부재**(83공정 중 컷계열 = 완칼053·반칼054·스티커완칼055 = 전부 종이/스티커). 설계자는 코드 부재로 053을 차용.
   - **recipe tree Case10(line 97): 판아크릴 = "UV평판출력→포장" — 컷 단계 자체 부재.**

**per-product 적대 판정(grounded 여부):**

| 등급 | 상품 | 완칼 grounding 근거 | 판정 |
|------|------|---------------------|:----:|
| **GROUNDED(rule)** 14 | 146·147·148·149·150·151·152·154·155·157·158·160·162·163 | 단품/조합 굿즈 = 모양대로 잘린 개별 아크릴 조각(키링·뱃지·스탠드·파츠). 사용자입력 사이즈+자유형상 = 컷 필요. C-7 공정화 정합 | **UPHOLD**(단 코드는 레이저커팅이 정확 — 코드정정 권고) |
| **OVER-REACH 의심** 3 | **161 판아크릴**·**168 입체코롯토**·**169 입체블럭** | 161=recipe tree Case10 "UV단품→**포장**"(컷 없음, 판=직사각 원판 가능성). 168=**L1 소재·인쇄사양·조각수·가공 전부 공백**(옵션 신호 0, 완칼 근거 셀 부재). 169=라미(10T) 적층 블럭(시트컷 아닌 조립/적층 가능성) | **OVERTURN(보류 권고)** |

→ **grounded(rule) 14 / over-reach 3.** 발명(완전 날조) 0 — C-7이 RULE을 받쳐 "전부 날조"는 아니다. 그러나 **161/168/169는 product-level 근거(L1 셀 또는 recipe 시퀀스) 없이 blanket으로 완칼 부여** = C-7 RULE의 무차별 확대 적용.

**조치(MAJOR):**
1. **161/168/169 완칼 행은 적재 보류**(active에서 분리, D-AC-1류 컨펌으로). 특히 **168은 L1 옵션 신호 전무**라 가장 ungrounded.
2. **proc_cd 정정 검토:** 도메인 권위 = 레이저커팅인데 마스터에 코드 부재. 053 차용을 유지할지(관리 단순) vs 레이저커팅 proc_cd 신설할지 = **도메인 컨펌 신규 항목**(현 설계 미반영). 적어도 provenance에 "레이저커팅 도메인공정의 053 대체 차용" 명시 필요.
3. RULE 레벨(C-7)은 UPHELD — "아크릴=컷공정 적재" 방향 자체는 정당.

### B. acrylic UV 정정 20 (G-AC-5) — **UPHELD (over-reach 아님)**

- print_side→process(PROC_000002 변형) 이동. **20상품 print_side update + 14 active UV process INSERT**. 차이 6 = inactive(153·156·159·164·165·166) — active process는 제외하되 print_side 정정행은 유지(기존 라이브행 UPDATE). **내부 정합 일치**(검증자 set 차집합 = 정확히 6 inactive).
- 14 UV INSERT 전건 L1 `인쇄사양` 셀 실재(§2-1). target_print_side는 일괄 "미상-컨펌(D-AC-3)"으로 **추정 회피** — 정당. UPDATE이지 INSERT/삭제 아님. **over-reach 0. UPHELD.**

### C. acrylic 두께 variant 20 (G-AC-3) — **UPHELD (과세분화 0)**

- 192 단일 → 042/043/044 3코드 분해. **20건 전부 L1 소재 두께와 정확 일치**(§2-1). C-8 과세분화 금지 준수: **골드/실버(195/196) 미건드림**·**10T(라미) 발명 금지 flag(192 유지)**·접합은 043+note. target_mat_cd 20/20 마스터 실재. **UPHELD.**

### D. silsa 모범 재적재 0 (G-SL-5) — **UPHELD (재삽입 0 기계+독립 확인)**

- 봉제/타공/족자/부착/코팅(079/080/081/082/014/015/016/053/054) silsa load 전 CSV에서 **0건 검출**(검증자 독립 grep). active = 화이트별색 1 + 천정고리 addon 1 + nonspec 13 + qtyunit 28 = 43행, 전부 보정성. **우발적 재삽입 0. UPHELD.**

### E. silsa 보드자재 7 deferred — **UPHELD (under-load dodge 아님, 발명회피 정당)**

- 폼보드/포맥스(화이트/블랙보드·3/5mm) = grounded 자재 **이름**은 L1에 실재하나 **MAT master에 대응 mat_cd 부재**(MAT_TYPE.08 = 인화지/PET/PVC/천뿐). 액자 3종 = L1 소재/가공 전 공백(프레임 vs 출력소재 모호). → **mat_cd 발명 금지로 active 0행, 7행 deferred에 grounded 이름·미존재 사유 보존.** digital-print 엽서봉투 flag 패턴 동형. **정당한 보류, under-load 아님. UPHELD.**

---

## 4. 중복-PK / UPDATE-target 위험

### 🔴 BLOCKER — acrylic 151 PROC_000081 중복 PK (D-AC-1, flag만 하고 행 미제거)

- **active `_processes.csv`에 `PRD_000151, PROC_000081` 행 실재**(검증자 직접 확인). stale ref-product-processes에 **`PRD_000151 PROC_000081` 이미 기적재**. → **active 적재 시 중복 PK INSERT 실패.**
- 설계자는 D-AC-1로 "라이브 기적재 의심·적재 직전 재확인"을 flag했으나 **행을 active CSV에서 제거하지 않았다.** 게이트는 stale 기적재를 보지 않으므로 PASS를 통과시킨다.
- **조치(NO-GO until resolved):** ① 151 PROC_000081 행을 active에서 제거(맥세이프 부착은 기적재), 또는 ② 적재 직전 라이브 SELECT로 151 부착 확인 후 조건부 skip. **digital-print 016 conditional 처리와 동일 패턴을 151에 적용해야.**

### 🟡 MAJOR — acrylic 167 모집단 제외 위험 (D-AC-6)

- qty_unit/nonspec 모집단이 167 제외 23. 그러나 **stale ref: 167 아크릴코롯토 use_yn=Y(active)·164 아크릴코롯토 use_yn=N(inactive)**. 만약 167이 라이브의 실활성 아크릴코롯토면 **실제 active 상품이 qty_unit 미부여**된다(164에만 부여, 164는 dead).
- 설계자는 "167 L1 고유앵커 부재"로 분리했으나 stale은 167을 active로 본다 — **권위 충돌.** 적재 직전 라이브 SELECT 1회로 즉시 해소 필요(167 vs 164 실활성 규명).

### 그 외 UPDATE-target 실재 — OK

- acr thickness 20·qtyunit 23·nonspec 12 / silsa qtyunit 28·nonspec 13 = **UPDATE 대상 prd_cd 전건 ref-products 실재**(미존재 0). UPDATE는 기존행 갱신이라 PK 충돌 무관.
- silsa 135 addon: stale ref-product-addons에 135 천정고리 **부재** → 중복 0(INSERT 안전). 단 135 addon 0행 전제가 stale → 적재 직전 재확인(D 잔여).

---

## 5. 적재 전 필수 해소 (must-resolve-before-load)

| 우선 | 시트 | 항목 | 조치 |
|:----:|------|------|------|
| **BLOCKER** | acrylic | **151 PROC_000081 중복 PK** | active에서 행 제거 or 적재 직전 라이브 조건부 skip. **미해소 시 NO-GO.** |
| **MAJOR** | acrylic | **완칼 161/168/169 over-reach** | 3건 active 분리·보류(168 L1신호 전무·161 recipe상 컷없음·169 적층). 14건은 UPHOLD. |
| **MAJOR** | acrylic | **완칼 proc_cd = 레이저커팅 도메인 불일치** | 053 차용 유지 vs 레이저커팅 신설 컨펌(신규 항목). provenance에 차용 명시. |
| **MAJOR** | acrylic | **167 vs 164 실활성**(D-AC-6) | 라이브 SELECT 1회 — 167 active면 qty_unit 모집단 재산정. |
| **HARD** | 양 시트 | **적재 직전 verify를 라이브 export로 재실행** | 게이트 stale 의존(use_yn·기적재) 격차 닫기. 완칼 순환검증도 라이브 process 0행 재확인으로 보강. |
| High | acrylic | D-AC-2 입체블럭 10T 두께코드 | 마스터 042/043/044만 = 1.5/3/8mm. 10T 신설 vs 192 유지(현 flag 정당). |
| High | acrylic | D-AC-3 UV변형後 print_side 목표값 | 일괄 미상-컨펌(추정회피 정당). 인쇄방식 272 전상품 미연결 글로벌 갭과 정책 결정. |
| Med | silsa | D-SL-1/2 보드/액자 자재 신규 mat_cd | 7 deferred 정당. 신규등록 컨펌 후 적재. |
| Med | silsa | D-SL-6 qty_unit EA vs 매 | 실사 대형=장당 EA 가정. 상품군별 정책 확정. |
| Med | silsa | D-SL-4 끈/큐방/각목 축(addon vs 부착) | C-6 맥락별 컨펌. flag 9 보류 정당. |

---

## 6. 검증자 종합 의견

- **silsa = 모범**: 적재성·FK·PK·모범재적재0·발명회피 전부 통과. 보류 18 전건이 발명회피(보드자재 master 부재·축모호 flag)로 정당. **OVERTURN 0. GO-WITH-FINDINGS.**
- **acrylic = 대량 적재의 강점과 위험 공존**:
  - **강점(UPHELD):** UV 14·두께 20·조각수 6·nonspec 12·qty_unit 23 = **전부 L1 셀 grounded·발명 0·과세분화 0**. UV→process 이동, 두께 variant 분해, 조각수→bundle 차원 모델링 = 도메인 정합. 적재성 위반 0.
  - **위험(재판정):** ① **완칼 17 = RULE(C-7)은 grounded이나 161/168/169 3건은 product-level 근거 없는 blanket 확대 → MAJOR OVERTURN** ② **완칼 코드(053)가 도메인 권위(레이저커팅)와 불일치 — 마스터 코드 부재로 차용했으나 미고지** ③ **151 중복 PK 행이 active에 잔존 = BLOCKER**(flag만으론 부족, 행 제거 필요) ④ **167/164 실활성 미규명**.
- **완칼 grounded 14 / over-reach(invented 아님, blanket 확대) 3.** 완전 날조는 0이나, 게이트의 순환 구조(생성기=검증기 동일 하드코딩)가 과적용을 은폐했다 — 이것이 본 시트의 검증 사각이다.
- **전사 판정: silsa GO-WITH-FINDINGS / acrylic CONDITIONAL GO** — 151 BLOCKER 해소 + 완칼 161/168/169 보류 + 적재 직전 라이브 재실행을 조건으로 적재 가능. DB 미적재 유지.
