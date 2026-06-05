# photobook 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/photobook.md` ⑤의 R1~R5(결함 G-PB-1~6)을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> **메서드:** digital-print 파일럿(`09_load/digital-print/`)과 동일 — load-spec + load CSV + 재실행 self-check.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/photobook-l1.csv`, 17행·64컬럼) = 상품 진실 · ref 마스터(`00_schema/ref-*.csv`,
> stale 2026-06-04 주의) = 라이브 기적재 상태 · 도메인 KB(`07_domain/`) = 결함 분류 렌즈. 추정 0 — 모든 행은
> L1 셀 또는 ref 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1/C-4/C-8/C-9/C-10 binding 적용.

---

## 0. 머리말 — photobook는 "거의 완비" 시트 (digital-print와 정반대 성격)

digital-print 파일럿은 *대량 누락 행 추가*(material 180·process 26)였다. **photobook는 라이브가 거의 완비**다.
라이브 추출본 기준 PRD_000100(parent)은:

| 속성 | 라이브 기적재 | 판정 |
|------|:-------------:|------|
| process | PROC_000020 PUR 1행 | **PUR 권위 정합**(C-10·process-recipe §3-3) — no-op |
| material | 7행 (내지1·표지5·면지1, usage_cd 분해) | **B 셋트 정상**(parent-carries-all) — no-op |
| page_rule | 24/150/2 | **정상** — no-op |
| excl_group | GRP-BOOK-제본 (trigger=PUR) | **정상** — no-op |
| sets | 7행 (내지1·표지5·면지1) | **정상** — no-op |
| qty_unit | NULL | **R5 부여 필요** ← 유일한 active 적재 |

따라서 본 설계의 **active 적재 = R5 qty_unit UPDATE 1행뿐**이고, 나머지 결함은 **no-op(이미 정합) 또는
CONFIRM-게이트 재구조화 제안**(_deferred)이다. "추가 적재 없음"을 *불변식으로 적극 입증*하는 것이 본 게이트의 핵심.

---

## 1. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 | 분류 |
|------|------------|------|:----:|------|
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R5 qty_unit 부여(권) | **1** | active |
| `_deferred/t_prd_product_materials_gpb3_split_proposal.csv` | t_prd_product_materials | G-PB-3 복합표기 자재축 분해 제안 | 1 | CONFIRM-게이트 제안 |
| `_deferred/t_prd_product_processes_gpb3_split_proposal.csv` | t_prd_product_processes | G-PB-3 복합표기 공정축(무광코팅) 제안 | 1 | CONFIRM-게이트 제안 |
| `_deferred/gpb4_chaekdeung_param_spec.csv` | (스키마 슬롯 부재) | G-PB-4 책등 param 명세 | 2 | 구조 갭(defer) |
| `verify_expected.py` | — | 재실행 self-check 게이트 | — | PASS(exit 0) |
| `expected-vs-load.md` | — | 게이트 결과·원리·stale 주의 | — | — |

- **active 적재 = qty_unit 1행.** process/material INSERT **0**(라이브 기적재 재적재 금지).
- 생성기(`gen_load.py`) 미사용 — active 1행은 직접 작성, 재현은 self-check가 독립 산출로 보증.

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`)·sub_prd 빈껍데기·sets 모두 건전 → **연결 테이블 최소 보정**만.

```
① qty_unit UPDATE (t_prd_products)   — R5. 컬럼 업데이트, FK 무관, 독립. ★유일 active
② material                            — no-op (라이브 7행 정상, 재적재 금지). G-PB-3 분해는 CONFIRM-게이트 제안만
③ process (제본 PUR + 책등 param)      — no-op (PUR 기적재 정상). G-PB-3 무광·G-PB-4 책등은 제안/구조갭
   excl_group                         — no-op (GRP-BOOK-제본 기적재 정상)
④ page_rule (interval 24/150/2)       — no-op (기적재 정상)
   sets / sub_prd variant             — no-op (표지타입 5 sub_prd·내지·면지 기적재 정상)
```

**과업 지시 FK순(qty_unit UPDATE → material(parent usage_cd) → process(제본 PUR+책등) → page_rule)** 을 그대로 따르되,
photobook는 ②③④가 **전부 라이브 기적재 완비 = no-op**이라 active 적재는 ①뿐이다.

**no-op 단계와 사유(전부 적극 입증):**
- **material no-op**: 라이브 7행(내지 MAT_000105 몽블랑130g USAGE.01 / 표지 5종 USAGE.02 = MAT_000005 하드커버·
  006 레더하드커버·007 소프트커버·186 레더(화이트)·250 아트250+무광코팅 / 면지 MAT_000251 그레이 USAGE.03).
  **C-9 B 셋트 = 자재 권위는 parent + usage_cd**(sub_prd 아님). sub_prd 101~107 9속성 0행 = **빈 껍데기 정상**.
  → **재적재 금지**(G-PB-5 머리말). 중복 PK 회피.
- **process no-op(제본 PUR)**: 라이브 PROC_000020(PUR) 단독 기적재. C-10·process-recipe §3-3 = PUR이 후니 운영
  사실. **레이플랫(PROC_000025)은 적재 0(미운영) — 적재 금지**. excl_group GRP-BOOK-제본(trigger=PUR) 기적재.
- **page_rule no-op**: 24/150/2 기적재. B-rules "MISSING" 예측은 false(라이브 반전).
- **sets/sub_prd no-op**: 표지타입 variant 5종(102 하드커버·103 아트250+무광·105 레더하드·106 레더·107 소프트) +
  내지(101)·면지(104) sub_prd 빈껍데기 + sets 7행 기적재. **재적재 금지**.

---

## 3. 결함별 적재 설계 (G-PB-1~6)

### G-PB-1 (CONFIRM·High) — 제본 PUR vs 레이플랫 [process: no-op, 컨펌 1순위]

- **3중 권위 일치(PUR):** 라이브 PRD_000100=PROC_000020(PUR) 단독 · 엑셀 photobook 전 행 `제본사양_제본=PUR` ·
  process-recipe §3-3 "후니 권위(PDF/DB/엑셀)가 PUR이면 PUR이 사실(HARD: 표준 충돌 시 후니 권위)".
- **레이플랫(PROC_000025)**: note="포토북 전용"이나 **전 상품 적재 0건 = 미운영 마스터**.
- **처리:** PUR(PROC_000020)은 **이미 적재 = no-op**. **레이플랫 적재 절대 금지(미운영)**. G-PB-1 충돌은 PUR로 처리.
- **컨펌(D-PB-LP, 1순위):** 레이플랫 사실(표준상 포토북 이상형)을 **컨펌 1순위로 flag** — "후니 포토북 제본은 PUR인가
  레이플랫인가? 레이플랫(025)은 미운영 마스터로 정리하는가?" 표준은 레이플랫 우위를 알려주나 **후니 운영 사실(PUR)을
  뒤집지 못함**(단정 금지 — 도메인 충돌). 본 패스는 PUR 유지·레이플랫 미적재로 처리.

> **provenance(no-op 사유):** `라이브 PRD_000100 proc=PROC_000020(PUR) 기적재 + 엑셀 PUR + recipe §3-3 후니권위 PUR → 적재 변경 없음. 레이플랫 적재 금지(미운영)`

### G-PB-2 (CONFIRM) — 표지타입↔종이 평면 혼재 [sets/material: no-op, 컨펌]

- **엑셀 2축:** `표지타입(필수)`(하드/레더하드/소프트 = 3 타입)과 `표지종이사양`(아트250+무광코팅/레더 = 종이)은 별개.
- **라이브 평면:** 표지 sub_prd 5종(타입+종이 혼재) + parent USAGE.02 5행. 하드커버(타입)와 아트250+무광(그 표지지)이
  별 항목으로 평면화. 위젯에서 표지타입 선택 시 종이 종속 위계 상실.
- **표지타입 variant 처리방식 = 반제품 sub_prd(통합 아님):** entity-semantic §2 확정 — `표지타입 variant → 반제품 표지 sub_prd
  + USAGE.02`. C-9 B 셋트 = 표지가 별도 공정 반제품. 라이브는 **이미 표지 sub_prd 5종 + parent usage_cd 5행으로 적재** =
  반제품 모델 정합. **재구조화(평면 5 → 타입3→종이 2계층) 안 함** — C-8(과세분화 금지·관리용이성) 균형상 현 평면 유지가
  현장 관리 유리할 수 있음. **무단 재구조화 금지 — CONFIRM.**
- **처리:** **no-op**(표지 sub_prd·usage_cd 기적재 유지). 2계층 재구조화 여부는 컨펌(D-PB-3).

### G-PB-3 (Medium·CONFIRM-게이트) — 복합표기 `아트250+무광코팅` 미분해 [제안만, _deferred]

- **도메인 근거(R-MAT-3):** `아트250+무광코팅` = 자재(`아트250`=아트지 250g MAT_000081) + 공정(`무광코팅`=무광
  PROC_000015, 코팅 PROC_000013 자식 leaf). R-MAT-3은 2축 분해 요구.
- **라이브:** `아트250+무광코팅`을 **단일 mat_nm MAT_000250으로 통째 적재**(USAGE.02). 무광이 process 분리 안 됨.
- **복합 분해 처리방식:**
  - 자재축 → MAT_000081(아트지 250g) USAGE.02 (제안: `_deferred/t_prd_product_materials_gpb3_split_proposal.csv`)
  - 공정축 → PROC_000015(무광) (제안: `_deferred/t_prd_product_processes_gpb3_split_proposal.csv`, disp_seq=2 PUR 다음)
  - 적재 시 기존 MAT_000250 1행을 **자재+공정 2행으로 교체**.
- **CONFIRM-게이트 사유(C-8):** "의미대로 완전 정규화"가 아니라 "현장 관리 용이성" 균형(C-8 HARD). 분해(자재+공정,
  검색·가격 정밀) vs 통합(MAT_000250 단일, 현장 관리 단순) 저울질을 **실무진이 선택**해야. **무단 적재 금지** →
  제안 CSV만 `_deferred`에 두고 active 미포함. 컨펌(D-PB-1) 후 적재.

> **provenance:** `L1:photobook 표지종이사양 "아트250+무광코팅" → 자재 "아트250"=MAT_000081 + 공정 "무광코팅"=PROC_000015 2축 분해 (G-PB-3 R-MAT-3). CONFIRM-게이트(C-8 관리용이성)`

### G-PB-4 (Medium·구조 갭) — 책등(mm) param 미적재 [구조 갭, defer]

- **엑셀:** `제본사양_책등` = 하드/레더 `10 / 12 / 14 /16` · 소프트 `4 / 6 / 8 / 10 / 12 / 14` (표지타입별 상이).
- **마스터 보유:** PROC_000017 제본 `prcs_dtl_opt`에 `책등(number, mm)` param **존재**. 즉 책등은 **마스터 레벨에서
  param 형상 보유**.
- **구조 갭(HARD):** `t_prd_product_processes` 스키마 = `prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt`
  — **상품별 param 슬롯이 없다**. 책등 *상품별 선택지*(하드 10/12/14/16 vs 소프트 4/6/8/10/12/14, 표지타입 종속)를
  적재할 슬롯이 현 스키마에 **부재**. PROC_000020(PUR)은 prcs_dtl_opt도 비어 있음(자식이라 부모 PROC_000017이 형상 보유).
- **처리:** 책등 명세를 `_deferred/gpb4_chaekdeung_param_spec.csv`에 **표지타입별 2행**으로 기록(적재 슬롯 부재).
  적재 위치 컨펌(D-PB-2): ① process param JSON 확장(부모 PROC_000017→상품별 오버라이드 슬롯 신설, DDL) vs
  ② size variant(책등별 작업사이즈 — L1 row15 `*책등에따라다름` 단서) vs ③ constraint_json. **무단 적재 금지.**

### G-PB-5 (정상) — sub_prd 빈껍데기·page_rule·sizes·sets [no-op, 재적재 금지]

- 내지(몽블랑130 USAGE.01)·면지(그레이 USAGE.03)·page_rule(24/150/2)·sizes(4: 8x8·10x10·A5·A4)·sets(7)·
  표지타입 variant 5 sub_prd는 **parent 적재 정상**(C-9 B 셋트, parent-carries-all). sub_prd 9속성 0행 = **빈 껍데기 정상**.
- **처리:** **재적재 절대 금지**(중복 PK). self-check no-op 불변식으로 기적재 적극 입증.

### G-PB-6 (글로벌 갭) — qty_unit_typ_cd NULL [active UPDATE 1행]

- **C-4 binding:** "상품군별 기본 일괄 부여". photobook = **책자형 1권 단위 → 권(QTY_UNIT.03)**.
- **UPDATE-class:** `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  `load/t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.03), use_yn, _provenance`.
- **대상:** PRD_000100 1상품(parent). sub_prd 101~107은 빈 껍데기·판매단위 무관 → **제외**(parent만).
- **권 vs 세트(D-PB-5):** photobook.md ⑥은 "권/세트"를 컨펌으로 둠. 본 패스는 **권(QTY_UNIT.03)** 권고
  (1 photobook = 1권, 책자형). 세트(QTY_UNIT.04)는 묶음 판매 시 — 컨펌으로 flag.
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품(글로벌). 본 set은 photobook 1건만. 전사 정책은 상품군별 매핑표
  (낱장=매·책자/포토북=권·굿즈=EA·세트=세트)로 별도 일괄(C-4) — 본 시트 범위는 PRD_000100 1행.

> **provenance:** `C-4 상품군별 일괄(photobook=권=QTY_UNIT.03). R5 G-PB-6. 라이브 NULL. 세트 대안은 D-PB-5`

---

## 4. 표지타입 variant 처리 — 반제품 vs 통합 (HARD 결정 기록)

**결정: 반제품 sub_prd (통합 아님). 이미 라이브 적재 = no-op.**

| 축 | 판정 | 근거 |
|----|------|------|
| 표지타입(하드/레더하드/소프트) variant | **반제품 표지 sub_prd + USAGE.02** | entity-semantic §2 "표지타입 variant → 반제품 표지 sub_prd"; §4 C-9 "B 셋트(표지=별도 공정 반제품)는 하드커버·포토북 국한" |
| 자재 권위 위치 | **parent + usage_cd**(sub_prd 아님) | §4 HARD "B 셋트라도 자재 권위는 parent + usage_cd. sub_prd 9속성 0행 정상" |
| 라이브 실태 | 표지 sub_prd 5(102/103/105/106/107) + parent USAGE.02 5행 + sets 5 | 반제품 모델 정합 — **재적재 금지(no-op)** |

- **통합(A)이 아닌 이유:** 통합상품(중철·무선책자)은 표지가 내지와 같은 디지털 출력물이라 단일행 캐스케이드.
  포토북 표지는 **하드보드+싸바리/레더 별도 공정 반제품**(§4-2) → B 셋트, sub_prd 분해가 맞다.
- **C-8 관리용이성 적용:** 표지타입↔종이 평면 혼재(G-PB-2)를 2계층으로 *재구조화하지 않음* — 현 평면 5종이 현장
  관리에 유리할 수 있어 무단 재구조화 금지(컨펌). variant 분해 = 완전정규화 아님(C-8 HARD).

---

## 5. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류/제안 | 사유 |
|---|------|------------|:----------:|:---------:|------|
| R5 | G-PB-6 qty_unit | t_prd_products(UPDATE) | **1** | — | C-4 권 부여 |
| R1 | G-PB-1 제본 PUR/레이플랫 | t_prd_product_processes | 0(no-op) | 레이플랫 사실 flag | PUR 기적재 정합·레이플랫 미운영 |
| R3 | G-PB-2 표지타입↔종이 평면 | sets/material | 0(no-op) | 재구조화 컨펌 | 표지 sub_prd 기적재·C-8 |
| R2 | G-PB-3 복합표기 미분해 | material+process | 0 | 제안 2행(_deferred) | C-8 관리용이성 CONFIRM-게이트 |
| R4 | G-PB-4 책등 param | (슬롯 부재) | 0 | 명세 2행(_deferred) | 스키마 param 슬롯 부재(구조 갭) |
| — | G-PB-5 sub_prd/page/size | — | 0(no-op) | — | B 셋트 정상·재적재 금지 |

- **active 적재 합계: qty_unit UPDATE 1행.** (process/material INSERT 0 — 라이브 완비.)
- **보류 합계: G-PB-3 제안 2행 + G-PB-4 명세 2행 + G-PB-1 레이플랫 flag + G-PB-2 재구조화 컨펌.**

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-PB-LP** (1순위) | 제본 PUR vs 레이플랫 | PUR no-op·레이플랫 미적재 | 후니 포토북 제본은 PUR인가 레이플랫인가? 레이플랫(PROC_000025)은 미운영 마스터로 정리하는가? (표준=레이플랫 우위, 후니 권위=PUR) |
| **D-PB-1** | G-PB-3 복합표기 분해 | 제안만(_deferred) | `아트250+무광코팅`(MAT_000250)을 자재(MAT_000081)+공정(무광 PROC_000015) 2축 분해할 것인가, 통합 유지인가? (C-8 관리용이성 균형) |
| **D-PB-2** | G-PB-4 책등 param 적재 위치 | 명세만(슬롯 부재) | 책등(하드 10/12/14/16·소프트 4/6/8/10/12/14)을 어디서 관리? process param JSON 확장(DDL) vs size variant vs constraint_json. 표지타입별 책등 분기 |
| **D-PB-3** | G-PB-2 표지 2계층 재구조화 | no-op(평면 유지) | 표지타입(3)→종이 2계층으로 재구조화할 것인가, 현 평면 5 sub_prd 유지인가? (C-8) |
| **D-PB-5** | qty_unit 권 vs 세트 | 권(QTY_UNIT.03) | 포토북 기본 단위 = 권인가 세트(QTY_UNIT.04)인가? (1포토북=1권 권고) |
| **D-PB-가격** | 가격 round-2 이연 | 범위 밖 | `가격_기본(24P)`·`가격_추가(2P)당`은 round-2 가격엔진 적재 대상(본 9속성 범위 밖) |

> **D-PB-LP·D-PB-1은 라이브 SELECT 1회로 즉시 보강 가능**(적재 직전 라이브 export로 verify 재실행 시 stale 격차 검출).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 라이브 기적재 판정에 사용.
- **판정이 stale에 의존하는 지점** = 제본 PUR 기적재(G-PB-1 no-op)·표지/내지/면지/sets 기적재(G-PB-5 no-op)·
  qty_unit NULL(R5).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
  특히 no-op 불변식(제본=PUR·레이플랫=0·표지 5·sets 7)이 라이브에서 깨지면 재적재 필요가 발생할 수 있음.
- 본 단계 판정은 "**추출본 기준 누락0·날조0·no-op 충족**"(자기검증 PASS exit 0, `expected-vs-load.md`).
