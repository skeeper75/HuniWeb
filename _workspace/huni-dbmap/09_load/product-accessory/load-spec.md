# product-accessory 적재 설계서 (load-spec) — round-3 remediation (대조군)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/product-accessory.md` ⑤의 R1~R3을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/product-accessory-l1.csv`, 67행·15상품) = 상품별 진실 ·
> ref 마스터(`00_schema/ref-*.csv`, stale 2026-06-04 주의). 추정 0 — 모든 행은 L1 셀 또는 ref 라인에 추적(provenance).
> **컨펌 권위:** `_confirmations.md` C-1·C-4(부자재→EA/매)·C-6(봉투/악세사리=기성+addon 이중)·C-8 binding 적용.

---

## 0. 성격 선언 — 본 시트는 대조군(GO수준)

product-accessory는 round-3 종단 시트 중 **라이브 적재 정합도가 가장 높은 대조군**이다(remediation 머리말 권위).
digital-print 파일럿이 **결함 다수(자재 180·공정 26·addon 2·qty_unit 36 적재)**였던 것과 정반대로,
본 시트는 **적재할 게 거의 없다.** 핵심 사실(라이브 권위로 확정):

- **15상품 전부 라이브 등록**(PRD_000001~015, 전부 PRD_TYPE.03, unmatched 0).
- **size↔material 분기가 엑셀 의도대로 정확 적재**(size 7상품 38행 + material 8상품 29행 = 15상품 완전커버, **둘다0=0**).
- **공정 컬럼 자체가 엑셀에 부재** → process 0은 **결함 아닌 원천 정상**.
- 유일한 글로벌 갭 = **qty_unit 전건 NULL**(272 전상품 공통, digital-print과 동일 성격).

→ **"적재 거의 없음 = 정상"**이 본 설계의 결론이다. 없는 결함을 만들지 않는 것(false MISSING 회피)이 1차 목표.

---

## 1. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R3 qty_unit 15상품 일괄(EA) | **15** |
| `_deferred/t_prd_product_bundle_qtys_deferred.csv` | (보류) | R2 묶음장수 후보(정책 미확정) | 9(보류) |
| `gen_load.py` | — | 적재 CSV 생성기(재현 가능) | — |
| `verify_expected.py` | — | 자기검증 게이트(PASS, exit 0) | — |
| `expected-vs-load.md` | — | 게이트 결과·stale 주의 | — |

**INSERT 적재 테이블 = 0개.** 유일한 변경은 qty_unit UPDATE set(컬럼 값 채움) 15행.
size/material/process/addon/discount/plate/page_rule는 **변경 0**(정상 또는 보류).

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_siz`·`t_cod`) 건전 + 15상품 기등록 → **대부분 no-op**. 순서:

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 독립. ★유일한 실 적재★
② size (입도 보정 R1)                 — no-op (현 적재 동작·G-PA-2 Low·정책 확정 후)
③ material                            — no-op (8상품 29행 라이브 정합·변경 0)
④ bundle_qty (분리 R2)               — DEFERRED (PK=prd_cd 단일·정책 미확정·발명 금지)
```

**no-op 단계와 사유(결함별 명시 — false MISSING 회피):**

| 단계 | 결함ID | 판정 | 적재 | 사유 |
|------|--------|------|:----:|------|
| size 분기 | G-PA-1 | **정상 MATCH** | **0** | 봉투류=size·색상/규격 variant=material 분기가 엑셀 의도대로 정확. 투명케이스(009) size 3행·볼체인(006) material 8행 라이브 값 정확 일치. **goods-pouch와 대조적 모범** |
| size 입도 | G-PA-2 | Low·CONFIRM | **0** | 카드봉투 색상(화이트/블랙)이 size 문자열 내포 vs 볼체인은 material 분리 → 분기 기준 비일관. **현 적재 동작** — 정책 확정(D-PA-1) 후 정규화. 지금 변경 시 작동 중인 적재를 깸 |
| material | G-PA-1 | 정상 MATCH | **0** | 8상품 29행(볼체인8·와이어링3·천정고리1·행택끈3·우드거치대1·우드봉3·우드행거3·만년잉크7) 라이브 정합 |
| process | G-PA-4 | **정상(원천부재)** | **0** | 엑셀에 인쇄옵션/별색/공정 컬럼 자체 부재(digital-print 분석서 확인). process 0은 결함 아님 |
| addon | G-PA-4 | 정상 | **0** | 본 시트는 자체 부자재(가격행) 등록. 봉투/볼체인이 *다른* 상품의 addon으로 참조되나 그 링크는 참조측 시트 소관(digital-print 엽서 addon·goods-pouch 키링 addon). 본 시트 addon 0 정상 |
| discount/plate/page_rule | G-PA-4 | 정상 | **0** | 부자재=수량구간할인 없음·작업판 무관·페이지 무의미 |
| bundle_qty | G-PA-3 | Low·DEFERRED | **0(보류)** | §3.R2 |
| MES 중복 | G-PA-5 | **정상(무영향)** | **0** | MES_ITEM_CD 상품간 공유(우드류 012-0012/0013)이나 JOIN KEY=prd_nm·MES 라이브 전부 NULL → 매핑 무영향 |

---

## 3. R-카테고리별 적재 설계

### R3 (C-4 binding) — qty_unit 상품군 기본단위 일괄 [UPDATE set 15행] ★유일 실적재★

**도메인 근거(C-4):** "상품군별 기본 일괄 부여". PA 15상품 라이브 qty_unit_typ_cd 전건 NULL(글로벌 갭, 272 전상품 공통).

**변환 로직:**
| 단계 | 입력 | 출력 |
|------|------|------|
| 1 | ref-products PA 15상품(PRD_TYPE.03) | 대상 상품 집합 |
| 2 | 부자재 상품군 기본단위 = **EA(QTY_UNIT.01)** | `target_qty_unit_typ_cd` |
| 3 | (prd_cd, prd_nm, current=NULL, target=QTY_UNIT.01, use_yn, provenance) | UPDATE set 행 |

- **단위 선정 근거(추정 아님):** L1 자연단위가 **혼재** — 봉투(50장/장·매), 볼체인(3개1팩/개), 우드봉(EA), 잉크(5cc).
  단일 상품군 기본단위로 **EA(QTY_UNIT.01)가 가장 포괄적**(개·세트 모두 EA로 수렴 가능). C-4 "상품군별 기본"에 정합.
- **UPDATE-class:** `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) → 별도 CSV에
  `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.01), use_yn, provenance`. digital-print R6과 동일 형식(단위만 매→EA).
- **천정고리(008) use_yn=N 포함:** 컬럼 업데이트는 비활성 무관(출시 시 즉시 유효). digital-print D-7과 동일 정책 확인 대상.
- **봉투류 '매' 세분 — 발명 금지:** 봉투/케이스가 '장/매' 단위가 더 자연스러울 수 있으나, 상품군 내 하위 단위 분기는
  **임의 발명이 됨** → CONFIRM(D-PA-1)으로 분리. 본 set은 EA 일괄(C-4 "기본 일괄"에 충실).

> **provenance 예:** `C-4 상품군별 일괄(부자재 PRD_TYPE.03=봉투/케이스 기본단위=EA=QTY_UNIT.01). 라이브 현재 NULL`

---

### R2 (G-PA-3 Low, DEFERRED) — 묶음장수 bundle_qty 분리

- **도메인 근거:** size 문자열 괄호 장수(`70x200mm(50장)`·`(3개1팩)`·`(10개)`)는 묶음수 신호. 라이브는
  OPP접착/비접착(001/002)만 `bdl_qty=50` 적재(reg_dt 2026-06-05, **stale 추출 이후 최신 보정**).
- **DEFERRED 사유(HARD — 발명 경계):**
  1. **PK=prd_cd 단일행**(스키마 `t_prd_product_bundle_qtys` PK=prd_cd, bdl_qty NOT NULL) → **상품당 묶음 1행만 가능**.
     트래싱지(003)는 같은 상품에 `20/30/40/100장`이 공존 → **어느 장수를 대표로 둘지 미확정**(임의 선택=발명).
  2. **장수가 size 문자열에 이미 내포** → bundle 별도 적재가 필수인지 정책 의존. 위젯이 size 옵션으로 장수를 보여줄지,
     bundle 차원으로 분리할지 미확정.
  3. OPP봉투 2상품은 **라이브 기적재**(중복 PK 회피 skip).
- **조치:** `_deferred/t_prd_product_bundle_qtys_deferred.csv`에 **장수 신호 보유 9상품을 후보로 기록**(대표값 미선정).
  active 적재 0. 정책 확정(D-PA-2) 후 일괄 적재.

> **provenance 예:** `L1:트래싱지 카드봉투 size괄호 장수신호=[20, 30, 40, 100] (R2 G-PA-3 Low DEFERRED)`

---

### R1 (G-PA-2 Low) — size 입도(색상/장수) 정규화 [no-op]

- **도메인 근거:** 카드봉투(004) size = `화이트 165x115mm(10장)`·`블랙 165x115mm(10장)` — 색상이 size 문자열 내포.
  볼체인(006)은 색상을 material로 분리 → **분기 기준 비일관**(위젯 옵션 입도에 영향).
- **판정 — no-op(변경 없음):** 현 라이브 적재가 **동작 중**(카드봉투 size 2행, 볼체인 material 8행). 지금 색상을
  카드봉투 size→material로 옮기면 작동하는 적재를 깬다. **분기 일관 기준 확정(D-PA-1) 후** 정규화가 타당.
  C-8(과세분화 금지·관리 용이성)와 균형 — 색상 2종 카드봉투를 굳이 material 분리하는 게 현장 관리에 이득인지 실무 판정.
- **적재 변경 0.** 정정 기록만(비일관은 위젯 UX 일관성 위해 추후 정리 권장).

---

### R3-정상군 (G-PA-1/4/5) — false MISSING 회피 (적재 변경 없음)

대조군 핵심 — 아래는 **모두 정상**이며 적재/변경하지 않는다(없는 결함을 만들지 않음):

- **G-PA-1 size↔material 분기 = 정상 MATCH.** 봉투류=size·색상/규격 variant=material. 라이브 값 정확 일치(검증 INV PASS).
- **G-PA-4 process/addon/discount/plate 전무 = 정상.** 공정 컬럼 원천 부재·자체 부자재. **0행이 옳음.**
- **G-PA-5 MES_ITEM_CD 중복 = 무영향.** JOIN KEY=prd_nm·MES 라이브 NULL. 참고 기록만.
- **삭제 절대 금지:** EXTRA 삭제 단정 0. 본 설계는 어떤 행도 삭제 제안하지 않음(HARD).

---

## 4. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류 | 사유 |
|---|------|------------|:----------:|:----:|------|
| R3 | qty_unit | t_prd_products(UPDATE) | **15** | — | C-4 EA 일괄 |
| R2 | bundle 분리 | t_prd_product_bundle_qtys | 0 | 9(deferred) | PK단일·정책 미확정 |
| R1 | size 입도 | t_prd_product_sizes | 0 | (정책) | 현 적재 동작·D-PA-1 |
| G-PA-1 | 분기 | size/material | 0(정상) | — | 정합 MATCH |
| G-PA-4 | process/addon/disc/plate | — | 0(정상) | — | 원천부재·자체부자재 |
| G-PA-5 | MES 중복 | — | 0(정상) | — | 무영향 |

- **active 적재 합계 = 15행(qty_unit UPDATE set)뿐.** INSERT 신규 행 = 0.
- **보류 = bundle 후보 9(정책 확정 후).** 정상확인(false MISSING 회피) = size/material 분기·process부재·MES중복.
- digital-print(244행 적재) 대비 본 시트는 **15행** — 대조군임을 수치로 확인.

---

## 5. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-PA-1** | qty_unit 단위 + size 색상 입도 | EA 일괄 / size no-op | 부자재 기본단위 EA가 맞나? 봉투류는 '매/장'(QTY_UNIT.02)이 더 적절? 카드봉투 색상을 size 유지 vs material 분리(볼체인과 일관)? (C-8 관리 용이성 저울질) |
| **D-PA-2** | bundle_qty 분리 정책 | DEFERRED(9 후보) | 묶음장수(50/20/10개)를 별도 bundle_qty로 분리 적재? PK=prd_cd 단일행이라 다중장수(트래싱지 20/30/40/100) 상품은 대표값을 어떻게 정하나? size 표기로 충분한가? |
| **D-PA-3** | addon↔자체상품 이중정의(B9) | flag(본 라운드 비대상) | 봉투/볼체인이 다른 상품 addon으로 참조(엽서 addon=OPP봉투, 키링 addon=볼체인)되며 자체 가격행도 보유 → round-2 가격 이중정의 우려. 본 라운드 9속성 비대상이나 가격 설계 시 확인 |
| **D-PA-4** | use_yn=N(천정고리 008) qty_unit | 포함(15건) | 미출시 상품도 지금 qty_unit 부여? (컬럼 업데이트라 무해하나 정책 확인 — digital-print D-7과 동일) |

> **D-PA-1·D-PA-2는 위젯 옵션 입도에 직결**하나 **위젯 차단 요소는 아님**(현 적재 동작). 정책 확정 후 일괄 정리 권장.

---

## 6. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 size/material/bundle 기적재 판정에 사용.
- **권위반전 발견(중요):** ref-product-bundle-qtys.csv는 PA **0행**이나 remediation 라이브는 OPP봉투 2상품
  `bdl_qty=50` 적재(reg_dt 2026-06-05, 추출 *이후*). → **추출본은 stale**. DEFERRED가 이를 skip으로 흡수.
- **판정이 stale에 의존하는 지점** = size/material 커버리지(INV)·bundle 기적재 여부(R2).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0**"(자기검증 PASS, `expected-vs-load.md`).
