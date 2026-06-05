# goods-pouch 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/goods-pouch.md` ⑤의 R1~R6을 FK 순서 적재 설계 + 적재용 CSV로 변환(digital-print 파일럿과 동일 메서드).
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/goods-pouch-l1.csv`) = 상품별 진실(특히 size는 **재단치수 셀** 권위, plate 복제 금지) ·
> ref 마스터(`00_schema/ref-*.csv`, stale 2026-06-04 주의). 추정 0 — 모든 적재행은 L1 셀/ref 라인에 추적(`_provenance`).
> **컨펌 권위:** `_confirmations.md` **C-1·C-4·C-6·C-8** binding 적용.

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_addons.csv` | t_prd_product_addons | R4 말랑/잉크 addon (active) | **1** |
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R3 에폭시/부착 공정 (active) | **0** |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R6 qty_unit 일괄(C-4 EA) | **98** |
| `load/t_prd_product_sizes_BLOCKED.reference.csv` | (NO-LOAD) | R2 size 차단 근거(비치수 47상품) | 124(참고) |
| `_deferred/t_prd_product_processes_deferred.csv` | (보류) | use_yn=N 에폭시(미니우치와키링) | 1 |
| `_deferred/t_prd_product_addons_deferred.csv` | (보류) | use_yn=N 아크릴스탠드(쉐이커) | 1 |
| `_deferred/phonecase_inactive_record.csv` | (기록만) | 폰케이스 5상품 미출시(C-1) — **신규행 0** | 5 |

생성기 `gen_load.py`·`gen_size_analysis.py`(재현 가능) · 검증 `verify_expected.py`(게이트 PASS, exit 0).

---

## 1. CRITICAL — size(재단치수) BLOCKER 검증 결과 (R2, plate=size 착각 구조)

**과업 지시:** size 77상품 미적재 = BLOCKER. **plate=size 착각** — 작업사이즈(plate_size)만 적재, 재단치수(size)가 누락.
재단치수 size를 적재하라. **사각손거울 = size/plate 짝 레퍼런스**(올바른 1쌍). plate에서 size 직접 복제 금지.

**검증 절차·결과(L1 재단치수 셀 권위, 추정 0):**

1. **레퍼런스 패턴 확인(사각손거울 186):** L1 `사이즈(필수) = S (75x130 mm)` →
   마스터 `SIZ_000384 = S(75x130mm)`(cut 75×130). plate `작업사이즈 = 85 x 140` → `SIZ_000385 = 85x140`(cut 공란).
   **size와 plate는 서로 다른 siz_cd**(재단치수는 cut 보유, 작업사이즈는 bleed 가산·cut 공란). → **plate siz_cd 복제 금지 입증**.
2. **L1 사이즈 보유 상품 = 65상품(matched)**, 사이즈 행값 224(전수).
3. **WxH 재단치수 보유 상품 = 단 8개**(사각손거울·블랙사각손거울·미니매트·피크닉매트·키캡키링·클립보드·만년스탬프·레더라벨제작).
   → **이 8상품은 전부 이미 size 적재됨**(사각손거울 3/3 등, `ref-product-sizes.csv` 라이브 정합). **신규 적재 불요(skip)**.
4. **나머지 47 active 상품 = 비치수(NONDIM)**: `무광 75mm`·`원형 90mm`·`11온스`·`350ml`·`단면/양면`·`M/L/XL`·`정사각M`·`11인치`.
   엑셀 `사이즈(필수)`칸이 **WxH 치수가 아닌 형상/규격/용량 라벨**이다(audit `size-mismatches.csv` = `EXCEL-only(비치수)` 정합).

**판정 — BLOCKED(마스터 siz_cd 부재):**
- 47 active 상품의 비치수 라벨에 **대응하는 마스터 `t_siz_sizes.siz_cd`가 존재하지 않는다**(cut-dims·명칭 전수 매칭 0).
- `t_prd_product_sizes`는 `siz_cd` FK가 필수 → **마스터 siz_cd 없이는 적재 불가**.
- **마스터 신규 siz_cd 생성 = master 테이블 변경 = 본 범위 밖 + 추정 위험(비치수→치수 발명)**. → **추정으로 siz_cd 발명 절대 금지(HARD)**.

**조치:**
- **신규 size 적재행 = 0**. plate 복제 금지(의미축 분리 — 작업사이즈를 재단치수로 둔갑 금지).
- 47 active 차단 상품·8 기적재 상품을 `load/t_prd_product_sizes_BLOCKED.reference.csv`에 **NO-LOAD 추적**(verdict: 기적재/BLOCKED).
- 비치수 size는 **마스터 siz_cd 신설(후니) 또는 nonspec 인코딩(`t_prd_products.nonspec_*`) 정책 확정**이 선결 → **설계결정 D-1(컨펌)**.

> **⚠️ remediation 문서 "size 77상품 적재" 낙관 정정:** remediation은 "엑셀 사이즈 → t_siz_sizes 매치 후 다행 적재"를 권고했으나,
> 라이브/마스터 교차 결과 **재단치수 WxH를 가진 8상품은 이미 적재됐고, 미적재 47상품은 비치수라 매치할 마스터 siz_cd가 없다**.
> 즉 BLOCKER의 실체는 "적재 누락"이 아니라 **"비치수 사이즈의 마스터 모델링 미정"**이다. 사각손거울처럼 짝 적재하려면
> 47상품 각각의 비치수 라벨을 후니가 마스터 siz_cd로 등록해야 하며, 이는 우리측이 추정으로 발명할 수 없다(D-1).

> **참고 — 좌표 충돌 주의(추적 reference의 한계):** `t_prd_product_sizes_BLOCKED.reference.csv`에서 미니매트(45x45cm)·
> 피크닉매트(100x70cm)가 도무송 `정사각45x45`(SIZ_219)·`90x70`(SIZ_246) 등에 cut-dims 우연 일치로 `RESOLVABLE` 표시되나,
> **이미 기적재(skip)**라 적재 영향 0. 이 우연 일치를 신규 매핑 근거로 쓰지 말 것(의미 무관, cm↔mm 충돌).

---

## 2. FK 적재 순서 (HARD)

마스터(`t_siz_sizes`·`t_proc_processes`·`t_mat_materials`·기성상품 prd)는 건전 → **상품 연결 테이블만** 적재.
폰케이스/use_yn=N은 active 제외.

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 독립(선/후 무관). C-4 EA
② size (재단치수, BLOCKER 선결)        — 신규 0행. 비치수 마스터 siz_cd 부재 → BLOCKED(D-1). plate 복제 금지
③ material (색상×사이즈 variant)       — 신규 0행. variant 기적재(머그4·티셔츠8) + 2차원 분리는 C-8 컨펌(D-2)
④ process (에폭시 등)                 — active 0행. 부착(081) 6캔버스 기적재 / 에폭시(083) use_yn=N → deferred
⑤ addon (말랑/잉크)                   — active 1행. FK: prd_cd→t_prd_products, addon_prd_cd→기성상품 prd
```

**no-op 단계와 사유:**
- **② size 신규 0 = BLOCKED(누락 아님)**: §1. 비치수 47상품은 마스터 siz_cd 부재 → 적재 불가(컨펌 선결). WxH 8상품 기적재.
- **③ material 신규 0 = 정상(기적재) + 컨펌**: variant 자재(머그 화이트/반투명/투명 4행·티셔츠 화이트M~블랙XXL 8행)는
  **이미 material 차원 적재**. G-GP-3 색상×사이즈 복합을 material/size 2차원 분리하는 것은 **C-8(관리 용이성·과세분화 금지)** 정책 — 자동 재적재 금지(D-2).
- **④ process active 0 = 정상**: L1 가공 신호 보유 상품은 ⓐ부착(081) 6캔버스 = **기적재** ⓑ에폭시(083) 미니우치와키링 = **use_yn=N deferred**
  ⓒ맥세이프추가 = 임팩트젤하드(폰케이스 unmatched·비활성) 제외. → **active 신규 0**(에폭시는 출시 시 deferred 1행).
- **excl_group·plate·bundle·page_rule·print_option·discount/price 전무 = 정상**: 굿즈 도메인(통판인쇄·낱장·round-1/2 기적재).

addon은 process 뒤에 둔다(`addon_prd_cd`가 기성상품 PRD_000006 볼체인·PRD_000015 리필잉크를 FK로 가리키며, 이들은 이미 등록됨).

---

## 3. R-카테고리별 적재 설계

### R6 (R6/C-4) — qty_unit 일괄 부여 [UPDATE set 98행]

- **C-4 binding:** "상품군별 기본 일괄 부여". **goods-pouch 굿즈 → QTY_UNIT.01(EA)**(낱장=매와 구별).
- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  `t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.01), use_yn, _provenance`.
- **대상:** goods-pouch matched **98상품 전건**(PRD_000183~280). 라이브 현재 전건 NULL(글로벌 갭). use_yn=N 12상품 포함(컬럼 업데이트는 비활성 무관, 출시 시 즉시 유효).
- **폰케이스 5상품(unmatched)은 prd_cd 부재 → 자동 제외**(신규행 0 가드).

### R4 (Medium) — 말랑/잉크 addon [addon active 1행, deferred 1]

**도메인 근거(C-6 binding·C-8):** 추가상품 = addon 링크행. 색상 등 variant는 **note로 통합**(C-8 과세분화 금지 — 색상축 신설 지양).

**L1 추가상품 신호 → addon_prd_cd 매칭표:**
| L1 상품 | L1 추가상품 신호 | → addon_prd_cd | 매칭근거 | 처리 |
|---------|------------------|:--------------:|----------|------|
| 만년스탬프(217) | 검정 5cc … 핑크 5cc(7색) | **PRD_000015**(만년스탬프 리필잉크) | 잉크 5cc → 리필잉크 | **적재 1행**(색상 7종=note 통합) |
| 말랑키링(221) | 볼체인(9색) | PRD_000006(볼체인) | — | **기적재(skip)** |
| 말랑포카홀더(223) | 볼체인(9색) | PRD_000006 | — | **기적재(skip)** |
| 말랑증사홀더(222) | 볼체인(9색) | PRD_000006 | — | 기적재 + **use_yn=N** |
| 아크릴쉐이커(226) | 아크릴스탠드 | PRD_000160(아크릴자유형스탠드) | — | **use_yn=N deferred** |

- **active 1행** = 만년스탬프 → 리필잉크(PRD_000015). 7색 잉크는 단일 addon_prd_cd에 통합, 색상은 `note`(C-8).
- **말랑네임택(224)·여권케이스(225)는 추가상품 신호 부재** → remediation의 "말랑네임택 등 일부 미적재"는 L1 근거 없음(추정 배제). addon 신호 보유 상품만 처리.

> **provenance 예:** `L1:만년스탬프 추가상품=검정 5cc → addon PRD_000015 (R4)` · note=`색상 variant 통합(C-8): 검정 5cc / … / 핑크 5cc`

### R3 (Medium) — 에폭시/부착 공정 [active 0행, deferred 1]

**도메인 근거:** 엑셀 `가공(옵션)_가공` 신호 → proc_cd. 에폭시=굿즈 전용(PROC_000083)·부착(PROC_000081).

**L1 가공 신호 → proc_cd 매칭표:**
| L1 상품 | L1 가공 신호 | → proc_cd | use_yn | 처리 |
|---------|--------------|:---------:|:------:|------|
| 캔버스 파우치/필통/백 6종(239·240·261·262·268·270) | 라벨부착\|라벨없음 | PROC_000081(부착) | Y | **기적재(skip)** |
| 미니우치와키링(227) | 에폭시 | PROC_000083(에폭시) | **N** | **deferred** |
| 임팩트 젤하드(폰케이스) | 맥세이프추가 | — | (비활성) | **제외**(unmatched) |

- **active 0행**: 부착 6캔버스 = 기적재 / 에폭시 1상품 = use_yn=N deferred. → 적재할 active 공정 신규 없음.
- **출시 시 적재**: 미니우치와키링(227) use_yn=Y 전환 시 deferred 에폭시 1행 적재.

> **provenance 예:** `L1:미니우치와키링 가공=에폭시 → PROC_000083 (R3)`(deferred, reason=use_yn=N 미출시 C-1)

### R2 (BLOCKER) — size 재단치수 — §1 (신규 0행, BLOCKED)

§1 참조. 신규 적재 0. plate 복제 금지. 47 active 비치수 → 마스터 siz_cd 부재(D-1 컨펌 선결).

### R5 (정책) — variant 2차원 분해 (적재 변경 없음)

- **G-GP-3 색상×사이즈 복합 variant**(티셔츠 화이트M~블랙XXL 8 material 평면화): 이상적으로는 material(색상)×size(M/L/XL/XXL) 2차원 분리이나,
  사이즈축(M/L/XL)이 **비치수 → 마스터 siz_cd 부재**(§1과 동일 차단). 분리는 **C-8(실무 관리 용이성·과세분화 금지) 정책 확정 선결**.
- **현 처리:** variant 기적재 보존(material 평면). 자동 재적재·삭제 없음. **D-2 컨펌**.

---

## 4. 폰케이스 5상품 — 비활성 처리 (C-1, 신규행 절대 0)

- **G-GP-1·C-1:** 그레이밴딩(회색 `FFD9D9D9`) = **미출시/보류** — 결함 아님, 모집단 외 비활성.
- **5상품(슬림하드 폰케이스·블랙젤리·임팩트 젤하드·에어팟케이스★·버즈케이스★)은 `t_prd_products` 미등록**(L1 unmatched).
- **처리:** **신규 t_prd_products 행/연결행 적재 절대 금지**(active 제외). `_deferred/phonecase_inactive_record.csv`에 **기록만**.
- **가드:** `verify_expected.py` `GUARD-phonecase=0` — 어떤 load CSV에도 폰케이스/미등록 prd_cd 0건 입증(PASS).

---

## 5. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류/차단 | 사유 |
|---|------|------------|:----------:|:--------:|------|
| R6 | qty_unit | t_prd_products(UPDATE) | **98** | — | C-4 EA 일괄 |
| R4 | 말랑/잉크 addon | t_prd_product_addons | **1** | 226=1(deferred) | 볼체인 기적재·아크릴스탠드 use_yn=N |
| R3 | 에폭시/부착 공정 | t_prd_product_processes | **0** | 227=1(deferred) | 부착 기적재·에폭시 use_yn=N |
| R2 | size 재단치수 | t_prd_product_sizes | **0(BLOCKED)** | 47상품 차단·8 기적재 | 비치수→마스터 siz_cd 부재(D-1) |
| R5 | variant 분해 | — | 0(정책) | 티셔츠8 등 기적재 | C-8 관리용이성 컨펌(D-2) |
| G-GP-1 | 폰케이스 5 | — | **0(신규금지)** | 5(기록만) | C-1 미출시/보류 |

- **active 적재 합계: addon 1 + process 0 + qtyunit 98(UPDATE) = 99행**(신규 INSERT는 addon 1행, 나머지는 UPDATE).
- **보류/차단: size 47 BLOCKED·deferred 2(proc·addon)·폰케이스 5 기록.**

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-1** | size 비치수 47상품 마스터 모델링 | BLOCKED(신규 0) | 무광75mm·원형90mm·M/L·11온스 등 비치수 라벨을 ⓐ마스터 `t_siz_sizes` siz_cd 신설(사각손거울 짝 적재)할지 ⓑ`t_prd_products.nonspec_*`로 인코딩할지? **우리측 추정 발명 불가** |
| **D-2** | variant 2차원 분해(색상×사이즈) | 기적재 보존(material 평면) | 티셔츠(화이트M~블랙XXL 8 material)를 material(색상)×size(사이즈) 분리할지? C-8 관리용이성 — 분리 부담 vs 통합 편의. 사이즈축은 D-1과 연동(비치수 siz_cd 선결) |
| **D-3** | 만년스탬프 잉크 addon vs 자재 | addon 1행(PRD_000015) | 리필잉크 7색 = addon(현 처리)인가, 자재 variant(material)인가? 5cc=소모품 → addon 타당하나 확인 |
| **D-4** | 에폭시(227)·아크릴스탠드(226) 출시 시점 | deferred | use_yn=N 미니우치와키링/아크릴쉐이커 출시 시 deferred 행 적재 — 지금 보류가 맞는가(C-1 미출시 분리)? |

> **D-1이 본 시트 최대 블로커.** 위젯 사이즈 선택지가 47상품에서 비는 근본 원인이며, **마스터 siz_cd 모델링은 후니 영역**(우리측 추정 금지).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 기적재 판정(size 8·material variant·addon 볼체인·process 부착)에 사용.
- **판정이 stale에 의존하는 지점** = size 기적재 8상품·material variant 기적재(머그/티셔츠)·addon 볼체인 기적재·process 부착 기적재.
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0·폰케이스신규0·size신규0**"(자기검증 PASS, `expected-vs-load.md`).
- **size BLOCKER(D-1)는 stale과 무관한 구조적 차단**(비치수→마스터 siz_cd 부재) — 라이브 재실행으로도 해소 안 됨, 마스터 모델링 컨펌 필요.
