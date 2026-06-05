# digital-print 적재 설계 독립 검증 — dbm-validator (round-3 remediation 파일럿)

> **작성** 2026-06-05 · dbm-validator(독립 적대적 검증) · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **검증 대상:** `09_load/digital-print/` (load-spec.md · load/*.csv · _deferred · conditional · cascade · gen/verify 스크립트).
> **검증자는 설계자가 아님** — 본 산출물을 작성하지 않았다. 기본 입장 = 회의(결함 입증 책임은 검증자에게).
> **권위 순서(HARD):** 라이브 DB > digital-print.md 기록 라이브결과 > ref-*.csv(stale 2026-06-04). 엑셀 L1 > 정규화.
> **DB 쓰기 0** — 읽기전용 SELECT 1회(배치)만 수행. password 미노출.

---

## 0. 최종 판정 — **GO-WITH-FINDINGS**

| 구분 | 결과 |
|------|------|
| **게이트 재실행** | PASS (26/180/36 byte-identical 재현, exit 0) |
| **180·26 독립 재산출** | 둘 다 원천에서 독립 확인 (생성기 미신뢰) |
| **적재성 DRY-RUN** | 4테이블 전부 PASS — type/NOT NULL/FK/PK-dup 위반 0 |
| **라이브 중복-PK 위험** | 0 (라이브 SELECT로 016/018 기적재 직접 확인) |
| **6개 쟁점 판정** | **UPHELD 6 / OVERTURNED 0** (1건은 검증 중 내 잠정의심을 라이브로 RETRACT) |
| **NO-GO 블로커** | 없음 |

**판정 근거:** 적재 CSV는 적재성(type·NULL·FK·PK) 전 항목 통과하고 라이브 중복충돌이 0이라 **기술적으로 적재 가능**(GO). 다만 D-2/D-3/D-4/D-6 등 **미해소 컨펌 항목**과, 게이트가 stale use_yn에 의존하는 구조적 한계가 남아 **WITH-FINDINGS**. 적재 직전 동일 게이트를 라이브 export로 1회 재실행하는 조건이면 무위험 GO.

---

## 1. 게이트 재실행 + 180·26 독립 재산출

### 1-1. 게이트 byte-identical 재현 — PASS
```
=== SELF-CHECK (digital-print) ===
R1-proc-active   26  26  0  0  PASS
R3-material     180 180  0  0  PASS
R6-qtyunit       36  36  0  0  PASS
FK-existence      -   -  -  0  PASS
GATE: PASS — 누락0·날조0   (exit 0)
```
설계자 보고와 동일하게 재현됨.

### 1-2. R3-material=180 독립 재산출 (gen_load.py 미신뢰, raw IMPORT 재집계)
`import-paper-matrix-long.csv`의 ● 마크를 검증자가 독립 재집계:

| IMPORT product_col | ● 수 | 매핑 상품 | 행수 |
|--------------------|:----:|----------|:----:|
| 프리미엄엽서 | 21 | 016 (1상품) | 21 |
| 스탠다드엽서 | 7 | 018 (1상품) | 7 |
| 2단/3단/미니접지카드 | 14 | 027·028·029 (3상품) | 42 |
| 프리미엄명함 | 16 | 031 (1상품) | 16 |
| 소량전단지/접지리플렛… | 47 | 047·048 (2상품) | 94 |
| **합계** | | | **180** |

→ 21+7+42+16+94 = **180**. 게이트와 일치. **모든 ● 행에 paper_name 존재**(빈 ● 0건).

### 1-3. R1-proc-active=26 독립 재산출 (gen_load.py 미신뢰, L1 신호 재스캔)
`digital-print-l1.csv`의 4개 신호컬럼(`후가공(옵션)_오시/미싱/가변(텍스트)/가변(이미지)`)에서 값≠`없음`을 검증자가 직접 재판독:
- **줄수형(29·30·31·32):** 018·041·042 (016 제외) = 3상품 × 4 = **12**
- **개수형(31·32):** 027·029·031·033·047·048·049 (028 제외) = 7상품 × 2 = **14**
- active 합계 = 12+14 = **26**. conditional(016)=4, deferred(028)=2 — 모두 게이트와 일치.

→ **180·26 둘 다 원천에서 독립 검증됨. 설계자 산출과 차이 0.**

---

## 2. 적재성 DRY-RUN (정적, columns.csv + ref 헤더 + 라이브)

> ⚠️ **검증 입력 주의:** `00_schema/columns.csv`에는 본 3개 타깃 테이블(`t_prd_product_processes/_materials/_addons`)이 **부재**(9개 테이블만 수록, 대부분 discount/category계). 따라서 타깃 컬럼 구조는 `ref-product-*.csv` **헤더(라이브 SELECT 산출물)** 와 `round3-extract-note.md`의 PK 정의를 권위로 삼았다. → **검증자 권고: columns.csv에 196/406/34행 3테이블 메타 보강 필요**(향후 시트 확장 검증 토대).

| 테이블 | type/length fit | NOT NULL (PK) | FK 실재 | PK-dup (in-CSV) | PK-collision (vs 라이브) | 판정 |
|--------|:---------------:|:-------------:|:-------:|:---------------:|:-----------------------:|:----:|
| `t_prd_product_processes` (26행) | OK (mand_proc_yn∈{Y,N}, disp_seq int) | OK (prd_cd·proc_cd 전부 채움) | OK (proc_cd→t_proc 26/26, prd_cd→t_prd_products 26/26) | 0 | **0 (라이브 016/018 직접확인)** | **OK** |
| `t_prd_product_materials` (180행) | OK (usage_cd=USAGE.07 실재, dflt_yn∈{Y,N}) | OK (prd_cd·mat_cd·usage_cd 복합키 전부 채움) | OK (mat_cd→t_mat 180/180, prd_cd 180/180) | 0 | **0 (라이브 MAT016cnt=0 확인)** | **OK** |
| `t_prd_product_addons` (2행) | OK (note 18자, varchar 여유) | OK (prd_cd·addon_prd_cd 채움) | OK (addon_prd_cd PRD_000003→t_prd_products 실재) | 0 | **0 (라이브 016/018 addon=001/002/004 직접확인, 003 미존재)** | **OK** |
| `t_prd_products_qtyunit_update` (36행, UPDATE) | OK (QTY_UNIT.02 실재) | n/a (UPDATE) | OK (36상품 PRD_000016~051 전부 실재) | n/a | n/a (컬럼 갱신) | **OK** |

**부가 검증:**
- material `dflt_yn=Y`가 **상품별 정확히 1회**(8상품 전부). default 자재 충돌 없음.
- process `disp_seq`=10~13(직각27/둥근28의 seq=1 이후) → 기존행과 의미 충돌 없음.
- `cascade-constraints.csv`는 **shape 제안 1건**(prd_cd=`PRD_ALL_DP` 의사키, 적재행 아님). 참조 코팅공정 PROC_000014/015/016(유광/무광/UV) 실재 확인. D-4 컨펌 전 적재 대상 아님 — 적재성 검증 비대상(정상).

→ **적재성 위반 0. NO-GO 블로커 없음.**

---

## 3. 6개 쟁점 적대적 재판정 (라이브 권위 대조)

### 쟁점 ①: 016 conditional 처리 — **설계자 판정 UPHELD**
- **설계자 call:** 016 R1 4행(29~32)을 stale(27/28)↔라이브(29~32) 충돌 이유로 `conditional`(active 미포함) 보류.
- **라이브 권위(검증자 SELECT, 2026-06-05):** `PROC016 = 27,28,29,30,31,32` — **016은 29~32 이미 적재**.
- **판정:** active로 넣었으면 **중복 PK INSERT 실패**였을 것. conditional 보류가 정확. **UPHELD.**
  추가 권고: 라이브가 29~32 실재 확정이므로 conditional 4행은 이제 **DROP**(설계자 D-1 "올바르면 폐기"대로) — active 승격 금지.

### 쟁점 ②: R4 addon MISSING 축소 (최고위험) — **설계자 판정 UPHELD**
- **digital-print.md ④(라이브 SELECT #10,12):** 016 addon 3행(001/002/004), **MISSING 3종**(카드봉투화이트·엽서봉투·트레싱지봉투).
- **설계자 축소:** 트레싱지봉투 2행만 적재 + 카드화이트=004 기적재 skip + 엽서봉투 flag (C-8 화/블 통합).
- **검증자 라이브+L1 교차 대조:**
  - 라이브 `ADDON018 = 001,002,004` / `ref 016 = 001,002,004`(note 004="카드봉투(화이트)"). → **카드봉투(화이트)=PRD_000004는 016·018 모두 이미 적재**. digital-print.md ④가 "화이트 MISSING"으로 센 것은 **화/블을 별개 addon으로 과세분화한 과대계상** — 마스터엔 카드봉투 1종(004)뿐.
  - L1(엑셀 권위) 016/018 봉투 6종 = 엽서봉투·OPP비접착·OPP접착·카드봉투(화이트)·카드봉투(블랙)·트레싱지봉투. master 5종엔 **엽서봉투·블랙 부재**.
  - 진짜 신규 누락 = **트레싱지봉투(→PRD_000003, 표기차 "트래싱지 카드봉투")** 1종. 블랙=동일 004(링크 불가), 엽서봉투=마스터 미존재(발명 금지→flag).
- **판정:** 설계자는 라이브-확정 MISSING을 stale로 **부당 강등한 것이 아니라**, digital-print.md의 과대계상(화/블 분리)을 마스터 실재로 교정한 것. 발명 0·중복 0. **UPHELD.**
  단 **잔여 리스크:** 018 기적재(001/002/004)는 digital-print.md가 016만 라이브확인(SELECT #12)했었음 → 검증자가 **라이브로 018=001/002/004 직접 확인 완료**하여 잔여 리스크 해소. 엽서봉투 신규등록 여부는 D-3 컨펌으로 정당하게 미결.

### 쟁점 ③: D-5 029 use_yn — **설계자 판정 UPHELD (검증 중 잠정의심 RETRACT)**
- **설계자 call:** 029 R1 2행을 `active`로 적재(ref-products=Y 따름).
- **검증 경과(정직 기록):** digital-print.md ① 56~57행이 029를 use_yn=**N** 집합에 명시 나열 → 검증자 잠정의심 제기("라이브=N이면 active 24로 게이트 26 붕괴"). 그러나 **라이브 SELECT(2026-06-05): `029 use_yn=Y`**. stale ref(Y)와 라이브(Y)가 **일치**.
- **판정:** **digital-print.md ① 본문 텍스트가 오기**(029를 N으로 잘못 나열)였고, 바인딩 권위인 라이브 DB는 Y. 설계자의 active 적재가 정확. **UPHELD. 검증자 잠정의심 명시 RETRACT.**
  → 부수 findings: digital-print.md ① line 56-57의 "3단접지카드(029)" 항목은 **라이브와 불일치하는 문서결함**(라우팅: dbm-mapping-audit/문서정정). 게이트 R1=26 불변.

### 쟁점 ④: 180 IMPORT exact-match — **설계자 판정 UPHELD**
- **설계자 claim:** exact 180/180, fuzzy 0, unmatched 0.
- **검증자 독립 재매칭:** ref-materials(333 mat_nm) ↔ IMPORT ●종이 180개 exact 문자열 매치 → **unmatched 0**. 스팟체크 8건 전부 정확(백색모조지 220g→MAT_000074, 아트지 300g→MAT_000082, 스노우지 300g→MAT_000092, 랑데뷰 WH 240g→MAT_000101, 몽블랑 240g→MAT_000109, 아코팩 250g→MAT_000113, 리사이클러스 240g→MAT_000114, 매쉬멜로우 233g→MAT_000115).
- **판정:** **UPHELD.** 매처가 exact(`p in mats`)라 비매치는 침묵 drop될 구조이나 unmatched=0이므로 실제 drop 0. 은닉 fuzzy 없음.

### 쟁점 ⑤: prcs_dtl_opt 컬럼 부재 — **설계자 판정 UPHELD**
- **설계자 claim:** `t_prd_product_processes`에 `prcs_dtl_opt` 컬럼 없음 → 줄수/개수 param은 마스터 상속.
- **검증자 확인:** `ref-product-processes.csv` 헤더 = `prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt`(7컬럼, prcs_dtl_opt 부재). param은 **마스터** `t_proc_processes`에 보유: PROC_000029/030=`{줄수 max:3}`, 031/032=`{개수 max:3}`, 051/052=`{크기 mm}` 라이브확인. (round3-extract-note: prcs_dtl_opt=jsonb는 t_proc_processes 소속.)
- **판정:** **UPHELD.** 연결행에 proc_cd FK만 적재하면 param 자동 상속. 적재행에 param 누락 결함 아님.

### 쟁점 ⑥: usage_cd=USAGE.07 컨벤션 — **설계자 판정 UPHELD**
- **설계자 claim:** 180행 전부 usage_cd=USAGE.07(공통), 기존 정상행(017·033)도 .07.
- **검증자 확인:** ref-product-materials 실측 — 코팅엽서 017(MAT_081/082)·코팅명함 032·스탠다드명함 033(MAT_074/081/082/091/092) **전부 USAGE.07**. base-code USAGE.07='공통' 실재.
- **판정:** **UPHELD.** 컨벤션 주장 참. 다른 usage_cd 사용 사례 없음.

---

## 4. 라이브 중복-PK 위험 — **0건**

검증자 라이브 SELECT(읽기전용 1회 배치) 직접 확인:

| 적재 키 | 라이브 현재 | 충돌? |
|---------|------------|:-----:|
| (016, 29/30/31/32) [conditional, active 아님] | 016=27,28,29,30,31,32 | (active 미적재라 무해) |
| (018, 29/30/31/32) [active] | 018=27,28 만 | **충돌 0** |
| (016, MAT 21종) [active] | 016 material=0행 | **충돌 0** |
| (016/018, addon PRD_000003) [active] | 016/018=001,002,004 (003 없음) | **충돌 0** |
| 028=N·038=N (deferred 정당) | 028 use_yn=N, 038 use_yn=N | (deferred 정합) |

→ active 적재 244행(material 180+process 26+addon 2+qtyunit 36) 전부 **라이브 중복충돌 0**. 적재성 GO.

---

## 5. 적재 전 필수 해소 항목 (must-resolve-before-load)

| 우선 | 항목 | 사유 / 조치 |
|:----:|------|------------|
| **HARD** | 적재 직전 동일 `verify_expected.py`를 **라이브 export 기반**으로 1회 재실행 | 본 게이트는 use_yn을 **stale ref**에서 읽음(가령 029=Y 결론은 라이브와 우연 일치였을 뿐, 구조적으로 라이브 미반영). 라이브 export로 stale 격차 닫기 = 검증 권위반전 원칙. |
| **HARD** | 016 conditional 4행 **DROP 확정** | 라이브 29~32 실재 확인됨 → active 승격 금지(중복 PK). 폐기 처리. |
| High | **D-2** 형압명함(038) 자재 출처 | IMPORT 형압명함 컬럼 부재. 추정 발명 금지 — 출처 컨펌(use_yn=N이라 출시 시 처리 가능). |
| High | **D-3** 엽서봉투 addon | master 미존재. 신규 기성상품 등록 vs 기존 매핑 컨펌. 발명 금지·flag 유지 정당. |
| Med | **D-4** 캐스케이드 제약 적재 위치 + 평량 데이터 소스 | constraint_json(DDL 0) vs 신규 테이블. 180g 트리거용 mat별 평량 소스 확정 필요(현재 shape만). |
| Med | **D-6** bundle_qty(명함 건수/낱장 묶음수) | 도메인 미확정 — 본 적재 비대상(보류 정당). |
| Low | digital-print.md ① 029=N 오기 정정 | 라이브=Y와 불일치하는 **문서결함**. dbm-mapping-audit로 라우팅(적재 무영향). |
| Low | columns.csv 3테이블 메타 보강 | processes/materials/addons 컬럼 메타 부재 → 차기 시트 검증 토대로 추가 권고. |

---

## 6. 검증자 종합 의견

- **누락0·날조0 게이트**는 재현·독립재산출까지 견실(180·26 raw 원천에서 검증됨). 생성기 산출을 신뢰하지 않는 독립 재생성 설계는 모범적.
- **stale-vs-live 처리**가 본 파일럿의 핵심 리스크였는데, 설계자는 016 conditional·addon 화/블 통합으로 **보수적·발명회피** 방향을 택했고, 라이브 직접확인 결과 그 보수성이 모두 정당했다(중복충돌 0, 부당강등 0).
- 유일하게 라이브로 뒤집힐 뻔한 지점(029)은 **digital-print.md 본문 오기**였고 라이브는 설계자 편이었다 — 검증자 잠정의심을 정직하게 철회한다.
- **6쟁점 전부 UPHELD, OVERTURN 0, NO-GO 블로커 0.** 적재 직전 라이브-export 게이트 재실행 1회를 조건으로 **GO-WITH-FINDINGS**.
