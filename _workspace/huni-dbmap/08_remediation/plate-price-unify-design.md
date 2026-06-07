# 디지털인쇄 출력용지규격(전지) 통일 설계 — plate + 가격 통일

> **라운드**: 디지털인쇄 출력용지규격(전지) 통일 설계 (사용자 확정 범위 2026-06-07 — 재론 금지)
> **권위 입력**: 사용자 확정 결정(아래 §0.1) · 가격표 `판걸이수` 시트(`06_extract/pangeori-l1.csv`, 전지 권위) · 라이브 `railway` DB 읽기전용 직접 조회(권위, 2026-06-07) · `08_remediation/csv/v2-plate-correction-per-product.csv`(3절 정합 선행본).
> **DB read-only**: railway DB(PostgreSQL 18.4) `SELECT`/`information_schema`만(2026-06-07). 라이브 INSERT/UPDATE/DELETE/DDL/COMMIT 없음. 비밀번호 stdout 미출력. 식별자/SQL 영어·해석 한국어. **자가 git 커밋 없음**.
> **범위**: 설계 + 근거 + 영향분석 + 검증까지. 실제 적용은 인간 승인 후 별도 실행본.
> **선행본 관계**: `plate-size-correction-design.md`(2026-06-07 확정 모델판)는 **plate 전수 교정**(전지 단일 316x467, 3절=미지정 UNRESOLVED)을 다뤘다. **본 설계는 그 범위를 디지털인쇄 계열로 좁히고 3절(330x660)을 미지정이 아닌 실 전지로 확정**하여 그 doc의 D-1(미지정 전지) 차단 일부를 해소한다. plate 전체 교정의 국4절 collapse 부분은 그 doc과 정합(중복 아님 — 본 설계는 가격까지 통일).
> **부속 CSV**(`08_remediation/csv/`): `unify-press-sheet-master.csv`(전지 마스터) · `unify-digitalprint-products.csv`(디지털인쇄 계열 제품 전수) · `unify-plate-correction.csv`(plate 교정 행별) · `unify-price-migrate-3jeol.csv`(3절 가격 마이그 304행 매핑) · `unify-new-siz-3jeol.csv`(신규 3절 siz 제안) · `unify-worksize-orphan-cleanup.csv`(작업사이즈 중복행 정리).

---

## 0. 요약 (orchestrator data)

### 0.1 사용자 확정 (권위 — 재론 금지)
`t_prd_product_plate_sizes`(판형) = **출력용지규격(전지)**. **디지털인쇄 계열(PRINT 인쇄·별색 + COAT 코팅 + CUT 커팅)의 plate + 가격을 출력용지규격(전지)으로 통일**한다. 범위 = 디지털인쇄 계열만(비디지털=스티커/굿즈/실사/제본/공정은 가격이 완성품·면적·공정 단위라 제외).

### 0.2 라이브 규명 확정 사실 (read-only 전수, 2026-06-07)
- **전지급 siz = 라이브 2개**: 국4절 `SIZ_000499`(work 316x467, cut 306x457, impos=Y, paper=.01) — **존재·재사용**. 3절 330x660 = **부재**(search-before-mint 0행) → 신규 제안.
- **`SIZ_000077`(work 304x629 / cut 300x625, impos=Y) ≠ 3절 전지**. 이것은 와이드캘린더 **작업사이즈**다. 참조: 가격 304행 + product_sizes 1행(PRD_000112 와이드벽걸이캘린더 완성품) + plate 0행. → siz 자체 **보존**(product_sizes RESTRICT), **가격 참조만** 신규 3절 전지로 이전.
- **디지털인쇄 가격 comp 분포**(라이브 실측):
  - `SIZ_000499`(국4절): PRINT_DIGITAL_S1/S2 각 106 + SPOT 11종×53=583 + COAT_MATTE/GLOSSY 각 46 + CUT_FULL_DIECUT 36 = **923행**. **이미 정합 — 변경 0**.
  - `SIZ_000077`(3절, 실은 작업사이즈): PRINT_DIGITAL_S1/S2 각 106 + COAT_MATTE/GLOSSY 각 46 = **304행**. → **3절 전지로 마이그(DELETE+INSERT)**.
  - CUT 타공류(`COMP_CUT_FULL_PERF_1H6`·`FULL_PERF_2H6`·`PERF_1H6`): siz NULL(9/9/23) = **전지축 아님**(타공은 시트 단위 가격 아님). 통일 제외.
- **plate 현황**: 국4절 디지털인쇄 39제품 plate 122행 중 117행이 작업사이즈 중복행(impos=N) 참조, 단 1행만 SIZ_000499(PRD_000016). 3절 3제품 plate 6행 전부 작업사이즈(impos=N) 참조.
- **`t_prc_component_prices.siz_cd → t_siz_sizes ON DELETE CASCADE`** · **`t_prd_product_plate_sizes.siz_cd → t_siz_sizes RESTRICT`**(스키마 권위). → 마이그 순서 강제(siz 선등록 → plate 재기재 → 가격 마이그 → 중복행 정리).

### 0.3 핵심 수치
| 항목 | 값 |
|------|-----|
| 디지털인쇄 계열 제품 수 | **42제품** (국4절 39 + 3절 3, 일부 중복 없음) |
| └ 국4절(SIZ_000499) 제품 | **39제품** |
| └ 3절(330x660 신규) 제품 | **3제품** (지그재그엽서 PRD_000030·와이드접지리플렛 PRD_000049·와이드벽걸이캘린더 PRD_000112) |
| plate 교정 행수 | 현재 **122행(국4절) + 6행(3절) = 128행** → 교정 후 **42행**(제품당 전지 1행 collapse) |
| └ DELETE(작업사이즈 plate 행) | 국4절 121 + 3절 6 = **127행** (PRD_000016 SIZ_000499 1행 KEEP) |
| └ INSERT(전지 plate 행) | 국4절 38 + 3절 3 = **41행** (PRD_000016 이미 정답) |
| 3절 가격 마이그 행수 | **304행** (SIZ_000077 → 신규 3절 siz, DELETE+INSERT) |
| 국4절 가격 | **923행 변경 0**(SIZ_000499 이미 정합) |
| 신규 siz 제안 | **1개** — `SIZ_PROPOSE_3JEOL`(330x660) (후니 채번) |
| 작업사이즈 중복행 정리(고아) | 디지털인쇄 plate가 참조하던 **80 distinct 작업사이즈 siz** 중 **66 = ORPHAN→soft-delete** / 4 = PRESERVE(prodsize·price 참조) / 10 = PRESERVE(비교정 제품 plate 공유) — **§6 전수표** |
| 미해결 | 🟡 3절 siz 채번(HANDOFF 번호조율) · 🟡 318x440·315x467 등 반칼/투명 전지(본 범위 밖, 별 트랙) · 🔴 미지정 전지 5제품(스티커팩/타투 등, plate-size-correction-design.md D-1) |

---

## 1. 디지털인쇄 계열 제품 전수 식별

> 부속 CSV `csv/unify-digitalprint-products.csv` = 42제품 전수(prd_cd·prd_nm·전지·가격comp).

### 1.1 판별자 = 가격 comp(PRINT/COAT/CUT) + 판걸이수 시트 등재
디지털인쇄 계열 = **(a) 가격이 `COMP_PRINT_*`/`COMP_COAT_*`/`COMP_CUT_FULL_DIECUT` comp를 쓰는 제품 + (b) 판걸이수 시트에 등재된 제품**. 이 두 조건이 곧 "디지털인쇄 절수(전지) 가격 계열". `prd_typ_cd`는 판별 불가(디자인상품에 엽서[디지털]·아크릴키링[굿즈] 혼재).

> ⚠ **권위 주의**: 라이브 `t_prd_product_price_formulas`는 이 PRINT/COAT/CUT comp를 통한 제품 바인딩이 **현재 0건**(Q17/Q18). 즉 가격 comp는 `component_prices`에 적재돼 있으나 공식→제품 바인딩 레이어는 미연결. 본 통일은 **`component_prices.siz_cd`(전지축)만** 교정하며 바인딩 레이어와 독립. 제품 식별은 **판걸이수 시트 상품명 + plate 현황**이 권위.

### 1.2 전지 분류 (판걸이수 시트 권위)
판걸이수 시트의 `디지털인쇄(국4절)`=316x467 / `디지털인쇄(3절)`=330x660 컬럼 위치가 제품×사이즈옵션별 전지를 결정한다.

| 전지 | 판걸이수 시트 상품 | 라이브 제품(prd_cd) | 전지 siz |
|------|---------------------|----------------------|----------|
| **316x467 (국4절)** | 엽서·명함·카드·포토카드·상품권·인쇄배경지·헤더택·라벨택·전단지·접지리플렛·중철/무선/PUR책자·엽서북·탁상/미니탁상/엽서/벽걸이캘린더·종이슬로건·미니접지/2단/3단접지카드·모양/미니모양명함 | 39제품(§1.3) | `SIZ_000499`(REUSE) |
| **330x660 (3절)** | 지그재그카드·와이드접지리플렛·와이드벽걸이캘린더 | PRD_000030·PRD_000049·PRD_000112 | `SIZ_PROPOSE_3JEOL`(NEW) |

> **하드커버무선책자 A4**(판걸이수 row 65, 532x355→330x660)는 판걸이수 시트엔 3절로 등재되나, 라이브에 하드커버무선 제품의 plate·가격 통일 대상이 명확치 않음 → 🟡 §6 D-3.

### 1.3 국4절 39제품 (라이브 plate 보유 확정)
PRD_000016(프리미엄엽서)·017(코팅엽서)·018(스탠다드엽서)·019(투명엽서)·020(화이트인쇄엽서)·021(핑크별색엽서)·022(금은별색엽서)·024(포토카드)·025(투명포토카드)·026(종이슬로건)·027(2단접지카드)·028(미니접지카드)·029(3단접지카드)·031(프리미엄명함)·032(코팅명함)·033(스탠다드명함)·034(펄명함)·035(모양명함)·036(미니모양명함)·037(오리지널박명함)·038(형압명함)·039(투명명함)·040(화이트인쇄명함)·041(스탠다드쿠폰/상품권)·042(프리미엄쿠폰/상품권)·043(인쇄배경지OPP)·044(인쇄배경지투명)·045(인쇄헤더택)·046(라벨/택)·047(소량전단지)·048(접지리플렛)·068(중철책자)·069(무선책자)·070(PUR책자)·094(엽서북)·108(탁상형캘린더)·109(미니탁상형캘린더)·110(엽서캘린더)·111(벽걸이캘린더).

> 투명엽서(019)·투명명함(039)·투명포토카드(025)는 판걸이수 시트상 국4절(316x467)이다. **투명원단 별도 전지(315x467) 가설은 라이브 판걸이수 권위에 근거 없음** → 본 범위에서는 국4절(SIZ_000499)로 통일. 315x467 신규 전지는 별 트랙(🟡 §6 D-4, 본 범위 제외).

---

## 2. 제품 × 사이즈옵션 → 출력용지규격 매핑

> 부속 CSV `csv/unify-digitalprint-products.csv`(제품 단위) + `csv/unify-plate-correction.csv`(행 단위).

### 2.1 매핑 단위 = 제품×사이즈옵션 (work 치수 아님)
전지는 **상품×사이즈옵션 단위**로 확정한다(work 치수 기반은 충돌·오매핑 위험 — 와이드접지 635/644/646x303이 work-fallback에서 316x467로 오매핑된 선행 사례). 본 설계는 판걸이수 시트 **상품명 컬럼**으로 직접 조인한다.

### 2.2 혼용 가능성 (제품 1개가 국4절·3절 둘 다?)
라이브 디지털인쇄 42제품 중 **혼용 없음**: 국4절 39제품은 전 사이즈옵션이 316x467, 3절 3제품(지그재그·와이드접지·와이드벽걸이)은 전 사이즈옵션이 330x660. 따라서 **제품당 distinct 전지 = 1** → 제품당 plate 1행으로 collapse 가능.

> 단 **접지리플렛(PRD_000048, 국4절)** vs **와이드접지리플렛(PRD_000049, 3절)**은 **별 제품**이다(라이브 별 prd_cd). 한 제품 안에서 A4=국4절·와이드=3절 혼용이 아니라, 와이드는 독립 상품. 혼용 우려 해소.

---

## 3. plate 교정 매핑

> 부속 CSV `csv/unify-plate-correction.csv` = plate 128행 전수 행별 교정.

### 3.1 교정 규칙
**제품별 기존 plate 행(작업사이즈 중복행 참조)을 전부 DELETE하고, 전지 1행으로 collapse(INSERT)**. 프리미엄엽서(PRD_000016) = SIZ_000499 1행 이미 정답 → **KEEP**(건드리지 말 것).

| 전지 | plate target siz | output_paper_typ_cd | INSERT 행 |
|------|------------------|---------------------|-----------|
| 국4절 | `SIZ_000499` | `OUTPUT_PAPER_TYPE.01`(국전계열) | 38행(39제품 − PRD_000016 KEEP) |
| 3절 | `SIZ_PROPOSE_3JEOL`(330x660) | `OUTPUT_PAPER_TYPE.01`(국전 3절계열) | 3행 |

DELETE 행수: 국4절 121행(122 − PRD_000016 1행) + 3절 6행 = **127행**.

### 3.2 3절 plate 교정 (라이브 현황 → 전지)
| 제품 | 현재 plate(작업사이즈, impos=N) | 교정 후 |
|------|-----------------------------------|---------|
| 지그재그엽서 PRD_000030 | SIZ_000142(604x154)·SIZ_000143(154x604) | `SIZ_PROPOSE_3JEOL` 1행 |
| 와이드 접지리플렛 PRD_000049 | SIZ_000186(635x303)·SIZ_000188(644x303)·SIZ_000190(646x303) | `SIZ_PROPOSE_3JEOL` 1행 |
| 와이드벽걸이캘린더 PRD_000112 | SIZ_000292(304x629, paper=.03) | `SIZ_PROPOSE_3JEOL` 1행 |

> PRD_000112 주의: plate는 SIZ_000292(304x629 작업), 가격은 SIZ_000077(304x629 작업, 동일 치수 다른 siz)를 참조 — plate·가격이 **서로 다른 작업사이즈 행**을 가리키는 불일치 상태. 통일하면 plate=전지(330x660)·가격=전지(330x660)로 정합.

---

## 4. 3절 가격 마이그레이션

> 부속 CSV `csv/unify-price-migrate-3jeol.csv` = 304행 전수(comp_cd·apply_ymd·자연키·기존 siz_cd→신규 siz_cd·unit_price).

### 4.1 마이그 대상 = SIZ_000077 가격 304행
| comp_cd | 행 | 자연키 변별 | unit_price 범위 |
|---------|----|-------------|------------------|
| COMP_PRINT_DIGITAL_S1 | 106 | clr_cd 2종(CLR_000002/005) × min_qty 53 | 54~4,500 |
| COMP_PRINT_DIGITAL_S2 | 106 | clr_cd 2종 × min_qty 53 | 108~7,000 |
| COMP_COAT_MATTE | 46 | coat_side_cnt 2종 × min_qty 23 | 150~6,000 |
| COMP_COAT_GLOSSY | 46 | coat_side_cnt 2종 × min_qty 23 | 150~6,000 |
| **합계** | **304** | | |

### 4.2 마이그 방식 = DELETE + INSERT (멱등 append 아님 — 메모리 교훈)
`comp_price_id`는 surrogate PK(bigint), 자연키 = (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty). siz_cd만 `SIZ_000077`→`SIZ_PROPOSE_3JEOL`로 바뀐다.

```
-- (a) 신규 3절 siz 선등록(§5) 후
-- (b) INSERT: SIZ_000077 가격 304행을 siz_cd만 신규로 바꿔 재삽입(새 comp_price_id 발급)
INSERT INTO t_prc_component_prices (comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt)
SELECT comp_cd, apply_ymd, '<신규3절siz>', clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty, unit_price,
       '[MIGRATE] 3절 전지 통일(SIZ_000077→330x660)', now()
FROM t_prc_component_prices WHERE siz_cd='SIZ_000077';
-- (c) DELETE: 기존 SIZ_000077 가격 304행 제거
DELETE FROM t_prc_component_prices WHERE siz_cd='SIZ_000077';
```

- **국4절 가격(SIZ_000499 923행)은 무변경** — 이미 정합.
- SIZ_000077 siz 행 자체는 **삭제 금지**(product_sizes PRD_000112 완성품이 RESTRICT 참조). 가격 참조만 이전.
- `unit_price numeric` 무손실(값 그대로 복사). `apply_ymd` varchar 그대로. `clr_cd`/`coat_side_cnt`/`bdl_qty`/`mat_cd` 전부 원행 복사.

### 4.3 무손실 입증
DELETE 전 INSERT로 동일 가격 304행이 신규 siz에 선존재 → 순삭제 0. 2-pass 멱등 가드 = INSERT 시 자연키(신규 siz 포함) `ON CONFLICT DO NOTHING`, DELETE 시 `WHERE siz_cd='SIZ_000077' AND EXISTS(신규 siz 가격)`.

---

## 5. 신규 3절 전지 siz 등록 제안

> 부속 CSV `csv/unify-new-siz-3jeol.csv`.

### 5.1 search-before-mint 결과 = 부재 (신규 1개)
라이브 `t_siz_sizes`에서 330x660(±5mm) work/cut/siz_nm 직검색 = **0행**. `SIZ_000475`(330x640)는 가방 작업사이즈(impos=N, 치수 20mm 차·의미 상이) → 재사용 금지. → **신규 1개 제안**.

| 항목 | 값 |
|------|-----|
| siz_cd | `SIZ_PROPOSE_3JEOL` (placeholder — 후니 채번, HANDOFF 번호조율 §6 D-1) |
| siz_nm | `330x660` |
| work_width / work_height | 330.00 / 660.00 |
| cut_width / cut_height | (NULL — 전지는 재단 없음, SIZ_000499도 cut 보유하나 전지 cut은 인쇄가능영역 의미. 🟡 후니 cut 정책 확인) |
| impos_yn | `Y` (조판용 전지) |
| use_yn | `Y` |
| output_paper_typ_cd | (plate 행에 부여 = `OUTPUT_PAPER_TYPE.01` 국전 3절계열) |
| note | `[전지] 디지털인쇄 3절(330x660). 지그재그/와이드접지/와이드벽걸이캘린더` |
| del_yn | `N` |
| reg_dt | DEFAULT now() (명시 NULL 금지 — NOT NULL DEFAULT 함정, 메모리 교훈) |

### 5.2 등록 SQL (설계만)
```
INSERT INTO t_siz_sizes (siz_cd, siz_nm, work_width, work_height, impos_yn, use_yn, output... ❌)
-- 주의: output_paper_typ_cd는 t_siz_sizes 컬럼 아님(plate 테이블 컬럼). siz엔 부여 안 함.
INSERT INTO t_siz_sizes (siz_cd, siz_nm, work_width, work_height, impos_yn, use_yn, note, del_yn)
VALUES ('<채번>', '330x660', 330.00, 660.00, 'Y', 'Y', '[전지] 디지털인쇄 3절(330x660)', 'N')
ON CONFLICT (siz_cd) DO NOTHING;  -- reg_dt/del_yn DEFAULT 발화
```

---

## 6. 작업사이즈 중복행 정리

> 부속 CSV `csv/unify-worksize-orphan-cleanup.csv` = plate 교정으로 참조 끊기는 작업사이즈 siz 전수 + 고아 판정.

### 6.1 정리 대상 = plate 교정 후 무참조(고아)
plate 교정으로 디지털인쇄 작업사이즈 plate 행이 DELETE되면, 그 siz가 **다른 plate·product_sizes·component_prices에서도 미참조**일 때만 고아 → soft-delete.

디지털인쇄 plate가 참조하던 **80 distinct 작업사이즈 siz**(impos=N)를 라이브 전수 판정(`csv/unify-worksize-orphan-cleanup.csv`):

| 케이스 | 라이브 실측 | 수 | 처리 |
|--------|-------------|----|------|
| **ORPHAN 확정**(total_plate_refs = plate_refs_in_corr & prodsize=0 & price=0) | 3절 6행(SIZ_000142/143/186/188/190/292) + 국4절 명함/배경지/캘린더 등 단독·전(全)참조-교정대상 60행 | **66** | soft-delete(`del_yn='Y'`) |
| **PRESERVE 타참조**(prodsize/price>0) | SIZ_000113(prodsize 0·price 3=별색엽서 가격)·SIZ_000132(prodsize 1·price 3)·SIZ_000147(price 3)·SIZ_000148(prodsize 5·price 3) | **4** | 보존 강제(가격 CASCADE·완성품 RESTRICT 위험). 별색엽서 가격(SIZ_000113 등)은 별 트랙 검토 |
| **PRESERVE 비교정 공유**(비교정 제품도 plate 참조) | SIZ_000250(plate 8=책자류 공유)·SIZ_000252(7)·SIZ_000171/173/175/179/180/181/251/157 | **10** | 보존(비교정 제품 plate가 여전히 참조 → 교정 후에도 plate_refs>0) |

### 6.2 안전 정리 규칙 (NOT EXISTS 가드)
```
UPDATE t_siz_sizes SET del_yn='Y', del_dt=now()
WHERE siz_cd IN (<디지털인쇄 작업사이즈 siz 목록>)
  AND del_yn='N'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_plate_sizes x WHERE x.siz_cd=t_siz_sizes.siz_cd)
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_sizes x WHERE x.siz_cd=t_siz_sizes.siz_cd)
  AND NOT EXISTS (SELECT 1 FROM t_prc_component_prices x WHERE x.siz_cd=t_siz_sizes.siz_cd);
```
→ plate 교정(DELETE) **후에만** 실행해야 plate_refs가 0이 됨. RESTRICT FK 순서 강제.

### 6.3 무손실
작업사이즈 정보는 완성품 권위행(impos=Y note 보유) 또는 런타임 재현으로 보존. 본 통일 범위에서 **soft-delete만**(del_yn 토글, 물리삭제 아님) → 롤백 시 복원 가능, 손실 0. NOT_REPRODUCIBLE 접지류는 본 통일이 손대지 않는 비교정 제품 참조분으로 보존됨.

---

## 7. 마이그레이션 설계 (설계만 — 실제 COMMIT/DDL은 인간 승인)

> [HARD] 본 절은 설계다. 라이브 INSERT/UPDATE/DELETE/DDL/COMMIT 미실행. 적용은 인간 승인 후 별도 실행본(`09_load/_migrate_plate_price_unify/`).

### 7.1 적용 순서 (FK 위상 + 무손실 게이트)
```
1) [신규 3절 siz 선등록]   SIZ_PROPOSE_3JEOL(330x660) INSERT ON CONFLICT DO NOTHING.
                          국4절 SIZ_000499 라이브 선존재 → 등록 0.
2) [plate 재기재]          국4절 38제품 + 3절 3제품:
                          - DELETE 기존 plate 행(작업사이즈 중복행 참조, 127행)
                          - INSERT 전지 1행/제품(국4절=SIZ_000499/paper.01, 3절=신규/paper.01) = 41행
                          - PRD_000016 KEEP(이미 정답)
3) [3절 가격 마이그]       SIZ_000077 가격 304행 → 신규 3절 siz:
                          - INSERT 304행(siz_cd만 교체, 새 comp_price_id)
                          - DELETE SIZ_000077 가격 304행
                          - 국4절 SIZ_000499 가격 923행 무변경
4) [작업사이즈 중복행 정리] plate 참조 제거 후 NOT EXISTS 확인 → soft-delete(고아분만)
                          타 참조 보유분·비교정 제품 공유분 보존
```
RESTRICT(plate→siz)·CASCADE(price→siz) 때문에 **1)→2)→3)→4) 순서 강제**. 신규 siz는 부모 추가라 무위험. SIZ_000077 siz는 절대 삭제 안 함(product_sizes RESTRICT).

### 7.2 영향 분석
| 영향 대상 | 변화 | 위험 |
|-----------|------|------|
| `t_siz_sizes` | 신규 3절 siz 1행 INSERT + 작업사이즈 고아 soft-delete(조건부) | 신규=부모추가 무위험. soft-delete=NOT EXISTS 가드로 안전 |
| `t_prd_product_plate_sizes` | DELETE 127 + INSERT 41 (128행→42행) | 중간계산(판수=판걸이수)은 앱 런타임이므로 plate 행수 축소 무해(메모리 `dbmap-compute-in-app-db-stores-lookup`). output_paper_typ_cd FK(.01) 존재 |
| `t_prc_component_prices` | 3절 304행 DELETE+INSERT(siz 교체). 국4절 923행 무변경 | siz_cd CASCADE — 신규 siz 선등록으로 FK 충족. SIZ_000077 미삭제로 CASCADE 미발화 |
| `t_prd_product_sizes` | 무변경(완성품 권위행·PRD_000112 SIZ_000077 보존) | 0 |
| 가격 바인딩 레이어(`product_price_formulas`) | 무변경(comp 바인딩 0건, 통일과 독립) | 0 |

### 7.3 롤백
- before-state 백업: plate 128행 + SIZ_000077 가격 304행 + 정리대상 siz del_yn 상태 → `_migrate_plate_price_unify/backup_*`.
- 롤백 = 신규 siz del_yn='Y' / plate 원행 재INSERT·전지행 DELETE / SIZ_000077 가격 재INSERT·신규siz 가격 DELETE / 정리 siz del_yn='N' 복원. 멱등.

### 7.4 멱등성
- 신규 siz: `ON CONFLICT (siz_cd) DO NOTHING`.
- plate 재기재: `(prd_cd, siz_cd)` 자연키 `ON CONFLICT DO NOTHING`. DELETE는 `WHERE siz_cd IN(작업사이즈 목록)` 재실행 안전.
- 가격 마이그: INSERT `ON CONFLICT(자연키) DO NOTHING`, DELETE `WHERE siz_cd='SIZ_000077' AND EXISTS(신규siz 가격)`. 2회차 델타 0.

### 7.5 라이브 검증 (읽기전용, COMMIT 없음 — 본 설계 완료분)
- SIZ_000077 = 304x629 작업사이즈, 가격 304·prodsize 1(PRD_000112)·plate 0 ✓
- 330x660 search-before-mint = 0행(부재) ✓
- 국4절 SIZ_000499 = 923 가격행, plate 1(PRD_000016) ✓
- 3절 6 작업사이즈 plate 행 = 각 plate_ref 1·prodsize 0·price 0(고아안전) ✓
- OUTPUT_PAPER_TYPE.01=국전계열 존재 ✓
- comp 바인딩 PRINT/COAT/CUT = 0건(통일 독립) ✓

---

## 8. 결정 필요 / 모호 플래그

| ID | 분류 | 내용 |
|----|------|------|
| 🟡 U-1 | 채번 | **신규 3절 siz_cd 채번**: max suffix=500. HANDOFF 번호조율(501~510 sticker원형·511~721 면적·721+ ENV/STK) 따라 3절은 **721 이후 슬롯** 권장. placeholder `SIZ_PROPOSE_3JEOL` 유지, 후니 최종 부여. |
| 🟡 U-2 | 모호 | **신규 3절 siz cut 치수**: 전지는 인쇄가능영역(cut) 보유 여부 정책 후니 확인. SIZ_000499는 cut 306x457 보유(여백 5mm). 3절도 동형 부여할지(330x660 work·~320x650 cut?) 후니 확정. 현재 cut=NULL 제안. |
| 🟡 U-3 | 모호 | **하드커버무선책자 A4(532x355→330x660)**: 판걸이수 시트엔 3절이나 라이브 제품 plate/가격 통일 대상 불명확. 하드커버무선 제품 식별·통일 포함 여부 후니 확인. 현재 본 통일 제외(국4절 39 + 3절 3만). |
| 🟡 U-4 | 범위밖 | **투명원단 전지(315x467)·반칼전지(317x440/307x430)·스티커팩/썬캡 전지**: 디지털인쇄 PRINT/COAT/CUT 계열 아님(반칼=CUT 계열이나 시트 전지축 별도). 본 통일 범위 밖 — 별 트랙(plate-size-correction-design.md 비적용군·sticker 트랙). |
| 🔴 U-5 | 차단(범위밖) | **미지정 전지 5제품**(지그재그엽서는 본 설계서 3절로 확정 해소 / 잔여 스티커팩·타투·반칼팬시 등): plate-size-correction-design.md D-1. 본 디지털인쇄 통일과 별개. |
| 🟢 U-6 | 정보 | **국4절 923 가격 + PRD_000016 plate = 무변경**. 이미 정합. 통일은 3절 추가 + 38 국4절 plate collapse + 304 가격 마이그가 실작업. |

---

## 9. 산출 핵심 수치 (재게재)

| 항목 | 값 |
|------|-----|
| 디지털인쇄 계열 제품 | **42** (국4절 39 + 3절 3) |
| plate 교정 | DELETE 127 + INSERT 41 → 128행을 42행으로 collapse |
| 3절 가격 마이그 | **304행**(DELETE+INSERT, SIZ_000077→330x660) |
| 국4절 가격 | **923행 변경 0** |
| 신규 siz | **1개**(SIZ_PROPOSE_3JEOL 330x660) |
| 작업사이즈 중복행 정리 | 80 distinct siz 중 **66 ORPHAN→soft-delete** / 4 PRESERVE(타참조) / 10 PRESERVE(비교정공유) |
| 미해결 | 🟡 3절 채번(U-1)·cut(U-2)·하드커버(U-3) · 🔴 미지정전지(U-5, 범위밖) |

## 판정
설계 완료. 디지털인쇄 계열 42제품(국4절 39·3절 3) plate+가격을 출력용지규격(전지)으로 통일. 국4절(SIZ_000499)=재사용·이미 정합(변경 0), 3절(330x660)=신규 siz 1 + 가격 304행 DELETE+INSERT 마이그 + plate 6행 교정. 무손실 입증(SIZ_000077 보존·고아 NOT EXISTS 가드·soft-delete). 라이브 read-only 검증 전건 통과. **실제 COMMIT·DDL·siz 채번은 인간 승인 대기(U-1~U-3)**.
