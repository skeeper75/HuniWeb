# waveA1 적재 설계 독립 검증 — booklet · stationery · photobook (round-3 remediation 전수 확장)

> **작성** 2026-06-05 · dbm-validator(독립 적대적 검증) · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **검증 대상:** `09_load/{booklet,stationery,photobook}/` (load-spec.md · load/*.csv · _deferred · verify_expected.py · expected-vs-load.md).
> **검증자는 설계자가 아님** — 본 산출물을 작성하지 않았다. 기본 입장 = 회의(결함 입증 책임은 검증자에게). 과소적재(under-load) 의심 우선.
> **권위 순서(HARD):** 라이브 Railway DB(2026-06-05 본 검증 SELECT) > `08_remediation/*.md`(라이브 2026-06-05) > `ref-*.csv`(stale 2026-06-04). 엑셀 L1 > 정규화.
> **DB 쓰기 0** — 읽기전용 SELECT 1회(배치)만 수행. password 미노출(이름만 참조). 메서드는 `03_validation/dp-load-validation.md` 파일럿 재현.

---

## 0. 최종 판정 요약

| 시트 | 판정 | 게이트 | 독립 재산출 | 적재성 DRY-RUN | 라이브 중복-PK | 쟁점(UPHELD/OVERTURN) | 과소적재 dodge |
|------|------|:------:|:-----------:|:--------------:|:--------------:|:----------------------:|:--------------:|
| **booklet** | **GO-WITH-FINDINGS** | PASS(83/4/11) | 83 raw 재집계 일치 | 통과 | 0 | 4 UPHELD / 0 | 없음(형압·PUR/하드커버 defer 정당) |
| **stationery** | **GO-WITH-FINDINGS** | PASS(6/7/11) | 6+7 raw 재스캔 일치 | 통과 | 0 | 3 UPHELD / 0 | 없음(097 무비판복제 회피 입증) |
| **photobook** | **GO-WITH-FINDINGS** | PASS(1+no-op) | active=1 라이브 입증 | 통과 | 0 | 4 UPHELD / 0 | 없음(책등 구조갭 dodge 아님) |

- **UPHELD 합계 11 / OVERTURNED 0.** 과소적재 dodge **0건 발견**(설계자 보수성 전부 정당).
- **NO-GO 블로커 0건.** 세 시트 모두 적재성(type·NULL·FK·PK) 통과 + 라이브 중복충돌 0 → **기술적으로 적재 가능(GO)**.
- 잔여 **WITH-FINDINGS** 사유 = ① 게이트가 no-op·중복회피 판정을 **stale ref**에서 읽는 구조적 한계(라이브 export 재실행 1회 조건), ② 다수 미해소 컨펌(D-BK/ST/PB).

---

## 1. 게이트 재실행 + 독립 재산출 (생성기 미신뢰)

### 1-1. 게이트 byte-identical 재현 — 3시트 PASS(exit 0)

```
=== booklet ===      R1-material 83/83/0/0 · R2-process 4/4/0/0 · R6-qtyunit 11/11/0/0 · FK 0 · PK-dup 0  → PASS
=== stationery ===   R1-bind-active 6/6/0/0 · R2-coat-active 7/7/0/0 · R5-qtyunit 11/11/0/0 · FK 0 · excl-empty 0  → PASS
=== photobook ===    R5-qtyunit(active) 1/1/0/0 · G-PB-1/5 no-op 불변식 9건 · 재적재금지 process/material INSERT 0 · FK 0  → PASS
```
설계자 보고와 동일 재현. exit 0 확인.

### 1-2. booklet R1=83 독립 재집계 (gen_load.py 미신뢰, IMPORT ● raw 재집계)

`import-paper-matrix-long.csv`의 ● 마크를 검증자가 6 IMPORT 슬롯에 대해 직접 재집계:

| IMPORT slot | → (prd_cd, usage_cd) | ● 수 |
|-------------|----------------------|:----:|
| 중철내지 | 068 USAGE.01 | 13 |
| 중철표지 | 068 USAGE.02 | 13 |
| 무선내지 | 069 USAGE.01 | 7 |
| 무선표지 :: 코팅/오시 | 069 USAGE.02 | 6 |
| 트윈링내지 | 071 USAGE.01 | 16 |
| 트윈링표지 :: 코팅/오시 | 071 USAGE.02 | 28 |
| **합계** | | **83** |

→ 13+13+7+6+16+28 = **83**. load CSV와 일치. **빈 paper_name ● = 0** · **unmatched mat_nm = 0** · **load 중복키 0** · **dflt_yn 슬롯별 정확히 1**(6슬롯 전부). provenance↔mat_cd↔master 정합 **83/83**(스팟체크 7건 백색모조지120→MAT_000073·아트지250→MAT_000081·스노우지300→MAT_000092·앙상블210→MAT_000099·몽블랑240→MAT_000109·백색모조지100→MAT_000072·아트지100→MAT_000076 전부 정확). 은닉 fuzzy·drop 0.

### 1-3. stationery R1=6·R2=7 독립 재스캔 (L1 제본사양·표지사양 raw 재판독)

L1 15행에서 prd_nm별 비공란 `제본사양`/`표지사양`을 검증자가 직접 집계 후 매핑:

- **R1 제본 active=6:** 173·174(하드커버→PROC_000023) + 177·178(트윈링→PROC_000021) + 179(떡제본→PROC_000022) + 181(중철→PROC_000018). **097(떡제본)은 기적재(PROC_000022) → 중복PK 회피로 active 제외 정당** · **172·175·176 제본사양 공란 → CONFIRM 분리** · **180 use_yn=N**. miss=0 extra=0.
- **R2 코팅 active=7:** 172·173·176·177·178·179·181(표지사양에 `아트250 + 무광코팅` 명시→PROC_000015). **174·175(레더, 코팅 없음)·097(표지 공란) 제외 정확.** miss=0 extra=0.

→ 6·7 둘 다 raw L1에서 독립 재도출. 설계자 산출과 차이 0.

### 1-4. photobook active=1 진위 (라이브 입증)

라이브 SELECT(2026-06-05): PRD_000100 proc=`PROC_000020`(PUR) 단독 · material usage = .01×1/.02×5/.03×1 · page=24/150/2 · sets=7 · 레이플랫(025) 전 상품 적재 0 · qty_unit NULL. → **9속성+sets 전부 기적재 완비, active 적재는 qty_unit UPDATE 1행이 전부**임이 라이브로 입증됨(stale 추정 아님).

---

## 2. 적재성 DRY-RUN (정적, 권위=`00_schema/columns.csv`)

> **개선 확인:** 파일럿이 권고한 3개 링크 테이블 메타가 **columns.csv에 보강됨**(`t_prd_product_processes`·`_materials`·`_addons` 컬럼·type·NOT NULL·default 수록). 이번 검증은 stale 헤더 추정이 아닌 **columns.csv 실 스키마**로 DRY-RUN 수행.

스키마 사실: 두 INSERT 테이블 모두 `reg_dt timestamp NOT NULL DEFAULT now()`(CSV 공란이어도 default 충족) · `mand_proc_yn`/`dflt_yn` = `character(1) NOT NULL` · `disp_seq integer NULLABLE` · PK 컬럼(prd_cd·proc_cd / prd_cd·mat_cd·usage_cd) NOT NULL.

| 적재 파일 | 테이블 | 행 | type/length | NOT NULL(PK) | dflt_yn/mand∈{Y,N} | FK 실재 | PK-dup(in-CSV) | 판정 |
|-----------|--------|:--:|:-----------:|:------------:|:------------------:|:-------:|:--------------:|:----:|
| booklet `_materials.csv` | t_prd_product_materials | 83 | OK | OK | dflt_yn 전부 Y/N | mat 83/83·prd 83/83·usage∈{.01/.02} | 0 | **OK** |
| booklet `_processes.csv` | t_prd_product_processes | 4 | OK(disp_seq 51/52 int) | OK | mand 전부 N | proc 051/052→master·prd 069/070 | 0 | **OK** |
| stationery `_processes.csv` | t_prd_product_processes | 13 | OK(disp_seq 1/5 int) | OK | mand Y(제본6)/N(코팅7) | proc 015/018/021/022/023→master·prd 8종 | 0 | **OK** |
| qty_unit UPDATE ×3 (11/11/1) | t_prd_products(UPDATE) | 23 | OK | n/a(UPDATE) | n/a | QTY_UNIT.03=`권` t_cod 실재·전 prd_cd 실재 | n/a | **OK** |

**부가 검증:**
- material `dflt_yn=Y`가 (prd_cd,usage_cd) 슬롯별 **정확히 1회**(6슬롯 전부). default 충돌 0.
- booklet proc 051·052 = `upr=PROC_000050(형압)` 자식 leaf, use_yn=Y. stationery 015=무광(upr=013코팅)·018·021·022·023 전부 `upr=PROC_000017(제본)` use_yn=Y.
- photobook `_deferred` 제안 FK(MAT_000081·MAT_000250·PROC_000015) 전부 master 실재 — 적재 시 무결.
- booklet `_deferred` 6행·stationery confirm 3행·photobook deferred 5행은 **active 비대상**(적재성 검증 비대상, 정상).

→ **적재성 위반 0. NO-GO 블로커 없음.**

---

## 3. 적대적 재판정 — 과소적재(under-load) dodge 우선

### booklet (4 쟁점)

**쟁점 ①: 내지/표지 usage_cd USAGE.01/.02 분리 — UPHELD.**
digital-print는 .07 공통이었으나 booklet은 내지=.01/표지=.02 분리. 라이브 094 엽서북 기존행이 USAGE.01내지/.02표지 컨벤션 — 정합. load 83행 전부 슬롯 정확. 부당.

**쟁점 ②: IMPORT 83 exact-match — UPHELD.** §1-2 독립 재집계로 83/83 정확, unmatched 0, 빈●0, dup0. 은닉 fuzzy 없음.

**쟁점 ③: PUR·하드커버 5상품(070·072·077·082·088) 내지 자재 부재 flag — UPHELD(발명 회피).**
라이브 SELECT 재확인: 068/069 내지·표지 0행, 071 기존 5행은 USAGE.05/.07(링·투명커버)뿐 .01/.02 부재 → 068/069/071 내지/표지 적재 시 **중복PK 0**. PUR·하드커버 5상품은 **IMPORT 상품컬럼 부재**(seoljeong-import-map matched=0)라 자재 리스트를 만들 raw 소스 자체가 없음 → `_deferred` 6행 보류 + D-BK-1 컨펌은 **정당한 발명회피**. 마스터 부재를 날조로 메우지 않음. 과소적재 아님(소스 없는 행을 만들지 않는 것이 옳음).

**쟁점 ④(과소적재 핵심): 형압 4행만 적재(069·070), 나머지 booklet 형압 무 — UPHELD.**
검증자 L1 raw 재스캔: `형압(양각)`·`형압(음각)` 신호는 **069·070에만** 존재(다른 booklet 9상품 전무). 라이브 069/070 기존 proc에 051/052 부재(037~044 박색상만 적재) → load 4행(069×2+070×2)은 **L1 신호 ↔ 라이브 누락**에 정확 대응. 더 넓혔으면 날조였을 것. **과소적재 dodge 아님 — L1 정량 입증.** (단 실출시 여부 D-BK-2 컨펌 — 적재 자체는 정당.)

### stationery (3 쟁점)

**쟁점 ①(과소적재 핵심): 097 떡메모지 무비판복제 회피 (digital-print 016 교훈) — UPHELD.**
`ref097-validation.csv`가 097을 "깨끗한 레퍼런스"로 보지 않고 **3결함(process mand_proc_yn=N·excl_group 고아헤더·bundle 이중 dflt_yn=Y)을 finding으로 적출**하고, 좋은 부분(떡제본 단독·page 미적재 정당)만 패턴화. mand_proc_yn은 097의 N을 따르지 않고 도메인권위(PROC_000017 "필수,단일")대로 **Y 부여**(divergence 명기). 097 결함 자동수정은 안 함(EXTRA 정정 별도 인가). → digital-print 016 무비판복제 교훈을 정확히 적용. 부당.

**쟁점 ②: 제본 enum→공정 6건이 L1 신호에 실재? — UPHELD.**
검증자 L1 raw 재판독으로 6건 전부 비공란 제본사양에서 도출 입증(173/174=하드커버, 177/178=트윈링, 179=떡, 181=중철). proc_cd 마스터 실값(021/022/023/018) 정확 — recipe-tree 🟡추정(023/024/094)을 폐기하고 master 채택한 것 정당. 공란 3상품(172/175/176)은 CONFIRM 분리 — 발명 안 함. miss/extra 0.

**쟁점 ③: excl_group 불요 판정 정당? — UPHELD.**
문구 제본 상품당 1종 고정(스프링=트윈링만·중철=중철만) → 택일 아님 → process 단독, excl_grp_cd 공란 정당. 097 고아 GRP-BOOK-제본은 booklet 떡제본 spillover(D-ST-1 정정후보, 본패스 미수정). 게이트 `excl-empty(G-ST-3)` 불변식 PASS. 부당.

### photobook (4 쟁점 — 과소적재 의심 최고강도)

active=1행뿐이고 나머지를 "기적재 no-op" 또는 "defer"로 처리 → **설계자가 진짜 결함을 no-op/defer로 회피했는가**를 라이브로 적대 검증:

**G-PB-1 제본 PUR no-op — UPHELD.** 라이브 PROC_000020(PUR) 단독 기적재 확인. 레이플랫(025) 전 상품 0건. 엑셀 전행 PUR. 3중 권위 일치 → 재적재 0이 정확(중복PK 회피). 레이플랫 미적재도 정당(미운영). dodge 아님.

**G-PB-2 표지타입↔종이 평면 no-op — UPHELD.** 라이브 표지 USAGE.02 = 5행 기적재(라이브 SELECT 직접확인). 2계층 재구조화는 UPDATE성(기적재 변경)이라 본 패스 비대상 + C-8 관리용이성 균형 → CONFIRM(D-PB-3) 정당. 무단 재구조화 안 함이 옳음.

**G-PB-3 복합표기 `아트250+무광코팅` 미분해 — UPHELD.** 라이브 단일 MAT_000250 적재 확인. 분해(자재 MAT_000081+공정 PROC_000015)는 기적재 1행 교체(UPDATE) → C-8 컨펌 게이트(D-PB-1), `_deferred` 제안만(FK 실재) active 미포함 정당. 발명·무단변경 0.

**G-PB-4 책등 param defer — UPHELD(과소적재 dodge 아님, 핵심).**
적대 검증 결과: **L1에 책등 실값 11행 존재**(하드/레더=`10/12/14/16`, 소프트=`4/6/8/10/12/14`) → 엑셀에 데이터가 있는 건 사실. **그러나** 라이브 `t_prd_product_processes` 스키마(columns.csv 실측)는 `prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt` — **상품별 param 슬롯이 물리적으로 부재**. 책등 *상품별 선택지*를 적재할 컬럼이 현 스키마에 없으므로, 적재하려면 DDL(param JSON 확장) 또는 size variant/constraint_json 신설이 필요 → **구조 갭이 실재**. `_deferred/gpb4_chaekdeung_param_spec.csv`에 표지타입별 2행 명세 보존 + 적재위치 D-PB-2 컨펌은 **정당한 구조갭 처리**. "엑셀에 있는데 빠뜨린 dodge"가 **아니라** "넣을 슬롯이 없어 위치를 컨펌으로 올린 것". OVERTURN 불가.

---

## 4. 라이브 중복-PK 위험 — 3시트 0건

검증자 라이브 SELECT(읽기전용 1회 배치, 2026-06-05, password 미노출) 직접 확인:

| 시트 | 적재 키 | 라이브 현재 | 충돌 |
|------|---------|------------|:----:|
| BK | 068/069 material .01/.02 | 068=0행·069=0행 | **0** |
| BK | 071 material .01/.02 | 071=USAGE.05×2·USAGE.07×3 (.01/.02 부재) | **0** |
| BK | 069/070 process 051/052 | 069/070 기존=014/015/019/037~044/076 (051/052 부재) | **0** |
| ST | 173/177 process 015/023(021) | 173=076만·177=076만 | **0** |
| ST | 172/174/176/178/179/181 process | 전부 기존 0행 또는 097=022만 | **0** |
| ST | 097 제본 022 | 097=022 기적재 → load active 제외(skip) | **0** |
| PB | PRD_000100 qty_unit UPDATE | proc=020·mat=.01/.02×5/.03·page·sets 완비, qty NULL | **0** |
| ALL | qty_unit UPDATE 23건 | 라이브 21 distinct prd_cd 전부 NULL(nonnull=0) | **0** |

→ active 적재 INSERT(material 83+process 4+13) + UPDATE 23 전부 **라이브 중복충돌 0**. 적재성 GO.

> 참고: qty_unit 합산이 23(BK11+ST11+PB1)이나 라이브 distinct=21 — 097·100이 booklet·stationery/booklet 양 시트 set에 중복 등장(같은 prd_cd). UPDATE는 idempotent(동일 target)라 무해하나, **적재 오케스트레이션 시 097/100 qty_unit UPDATE 중복 실행 1회로 dedup 권고**(아래 §5).

---

## 5. 적재 전 필수 해소 항목 (must-resolve-before-load)

| 우선 | 시트 | 항목 | 사유 / 조치 |
|:----:|------|------|------------|
| **HARD** | 3시트 | 적재 직전 `verify_expected.py`를 **라이브 export 기반**으로 1회 재실행 | 게이트가 no-op·중복회피·use_yn 판정을 **stale ref(2026-06-04)**에서 읽음(특히 photobook no-op 불변식·stationery 097 레퍼런스). 본 검증이 라이브 SELECT로 격차를 닫았으나(2026-06-05 일치), 적재 시점 export로 재확인 필수. |
| **HARD** | cross | qty_unit UPDATE **097·100 중복 제거** | booklet·stationery set이 097/100을 양쪽 보유 → 23행 중 2행 중복. UPDATE 동일값이라 무해하나 적재 스크립트에서 prd_cd dedup(21 distinct). |
| High | BK | **D-BK-1** PUR·하드커버 5상품 내지 자재소스 | IMPORT 컬럼 부재(matched=0). 발명 금지 — 소스 컨펌(위젯 종이옵션 선결). `_deferred` 6행 보류 정당. |
| High | BK | **D-BK-2** 069·070 형압 실출시 여부 | 박색상 8종 적재·형압만 누락. L1 양 신호 존재 — 의도 미적재 vs 누락 컨펌(적재 4행 자체는 정당). |
| Med | BK | **D-BK-4** 097 page_rule 3/3/3 잡음 + 백모조120 usage 중복 | stale=부재/라이브=3/3/3 충돌. flag만(삭제 단정 금지). 라이브 재확인 후 제거 컨펌. |
| Med | ST | **D-ST-1** 097 레퍼런스 3결함 정정 | mand_proc_yn N→Y · bundle 이중 dflt_yn · 고아 GRP-BOOK-제본. finding만, EXTRA 정정 별도 인가. |
| Med | ST | **D-ST-3** 172/175/176 제본종류 | L1 공란 — 소프트/플래너 제본 미명시. CONFIRM 3행 보류 정당. |
| Med | ST | **D-ST-4** 표지 복합자재 분해 | 코팅 공정만 active, MAT_000260→081 swap은 UPDATE성 보류(C-8). |
| Med | PB | **D-PB-2** 책등 param 적재 위치(구조갭) | 스키마 param 슬롯 부재. process JSON 확장(DDL) vs size variant vs constraint_json 컨펌. |
| Med | PB | **D-PB-1** 복합표기 분해 · **D-PB-3** 표지 2계층 · **D-PB-LP** PUR/레이플랫 | 전부 라이브 SELECT 1회로 즉시 보강 가능(적재 직전 export). |
| Low | — | digital-print.md ① 029=N 오기(파일럿 잔여) | 본 waveA1 무관, 기존 라우팅 유지. |

---

## 6. 검증자 종합 의견

- **3시트 게이트 전부 재현(exit 0)** + **독립 재산출(booklet 83 raw 재집계·stationery 6+7 L1 재스캔·photobook active=1 라이브 입증)**까지 견실. 생성기 출력을 신뢰하지 않는 독립 재생성 설계는 파일럿과 동일 수준으로 모범적.
- **과소적재 dodge 의심을 최우선으로 적대 검증했으나 0건.** 특히 photobook(active 1행)은 가장 의심스러웠지만, 라이브 SELECT로 9속성+sets 완비가 사실임을 확인했고, **책등 G-PB-4는 "엑셀에 있는데 빠뜨린 dodge"가 아니라 "스키마에 슬롯이 없는 실 구조갭"**임을 columns.csv 실측으로 입증 — defer가 정당하다. booklet 형압 4행·PUR/하드커버 자재 defer, stationery 097 무비판복제 회피도 전부 L1/라이브 정량 근거로 보수성이 정당.
- **stale-vs-live가 본 wave의 핵심 리스크**였는데, 라이브 1회 배치 SELECT로 booklet 충돌(068/069/071·069/070)·stationery 충돌(173/177)·photobook no-op 불변식·qty_unit NULL 전부 라이브 확정 → 중복충돌 0·부당강등 0.
- **11쟁점 전부 UPHELD, OVERTURN 0, NO-GO 블로커 0.** 적재 직전 라이브-export 게이트 재실행 1회 + qty_unit 097/100 dedup을 조건으로 **3시트 GO-WITH-FINDINGS.**
