# silsa(실사) 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/silsa.md` ⑤의 R1~R6을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> digital-print 파일럿(`09_load/digital-print/`) 구조·메서드를 그대로 복제.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/silsa-l1.csv`) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`, stale 2026-06-04 주의).
> 추정 0 — 모든 행은 L1 셀 또는 ref 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1/C-3/C-4/C-6/C-8 binding 적용.

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R2 화이트별색(접착투명포스터) | **1** |
| `load/t_prd_product_addons.csv` | t_prd_product_addons | R3 천정고리(족자포스터) | **1** |
| `load/t_prd_products_nonspec_update.csv` | t_prd_products (UPDATE) | R4 대형 비규격 가로/세로 범위 | **13** |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R6 qty_unit 일괄(EA) | **28** |
| `_deferred/t_prd_product_materials_board_deferred.csv` | (보류) | R1 보드/액자 자재(master 미존재·소재 공백) | 7 |
| `_deferred/t_prd_product_addons_flag_deferred.csv` | (보류) | 배너거치대/큐방/각목/끈(master 미존재·축모호) | 9 |
| `_deferred/deferred_inactive.csv` | (보류) | 폼보드 nonspec 비활성·★투명포스터 미등록 | 2 |

검증 `verify_expected.py`(게이트 PASS, exit 0 — §6 실행결과 기재).

---

## 1. CRITICAL — 실사 권위반전 (silsa는 모범 시트)

**과업 핵심(HARD):** 실사는 acrylic/digital-print과 달리 **이미 잘 적재된 모범 시트**다. 봉제/타공/족자/부착/코팅
공정과 MAT_TYPE.08 실사소재가 라이브에 도메인대로 정합 적재돼 있다(`08_remediation/silsa.md` 머리말 권위반전).

**따라서 본 적재 설계는 "전면 재적재"가 아니라 "부분 보정"이며, 모범 적재분은 절대 건드리지 않는다:**

- **봉제(PROC_000080)/타공(079)/족자제작(082)/부착(081)/코팅(014/015)** — 라이브 16상품 기적재 정상(G-SL-5 MATCH).
  → **load CSV에 0건.** `verify_expected.py`의 `mobeum-no-reload` 가드가 이를 **기계 보증**(재적재=중복PK 결함 차단).
- 세부 param(봉제 `유형`·타공 `구수`·족자 `모양`)은 **마스터 `ref-processes.prcs_dtl_opt` JSON에 이미 보유**
  (benchmark §5.2 — 후니 스키마가 경쟁사보다 표현력 높음·실제 정합 적재 입증). 상품 연결행은 proc_cd FK만으로 param 자동 상속.
  → **param 적재 대상 없음**(이미 충족). G-SL-5 잔존 "param 적재 여부"는 라이브가 이미 보유 → 점검만.

**결함은 4영역에 국한:** ① 보드/액자 자재 0행(5상품) ② 화이트별색 1건 ③ 거치대/고리/끈 addon ④ 대형 nonspec 범위.

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`)는 건전 → **상품 연결 테이블/컬럼만** 보정.

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 독립 (R6)
② nonspec UPDATE (t_prd_products)    — 컬럼 업데이트, FK 무관, 독립 (R4)
③ size                                — n/a (28/28 기적재, 본 범위 외)
④ material (보드/액자 R1)            — **0 active**(전건 _deferred). FK: prd_cd→t_prd_products, mat_cd→t_mat
                                        보드/포맥스/액자 mat_cd가 master에 미존재 → 발명 금지 → 컨펌 후 적재
⑤ process (화이트별색 R2만)          — 1 active. FK: prd_cd→t_prd_products, proc_cd→t_proc(PROC_000008 실재)
   ※ 봉제/타공/족자/부착/코팅 = 기적재 정상 → 재적재 NO-OP (모범 보존)
⑥ addon (거치대/고리/끈 R3)          — 1 active(천정고리). FK: prd_cd→, addon_prd_cd→t_prd_products(PRD_000008 실재)
                                        배너거치대/큐방/각목/끈 = master 미존재 → _deferred flag
   excl_group / bundle_qty / page_rule — n/a (실사 전무=정상)
```

**no-op 단계와 사유:**
- **봉제/타공/족자/부착/코팅 process 재적재 = NO-OP(모범 기적재 정상)**: G-SL-5 권위반전 MATCH. 라이브 16상품 적재됨. **변경·재적재 절대 금지.**
- **material active 0행**: 보드/액자 5상품 자재는 grounded mat_cd 부재(폼보드/포맥스/액자 master 미존재) → 발명 금지 → 전건 `_deferred`(④).
- **excl_group 전무 = 정상**: 실사 공정 택일그룹 부재(택일은 책자·캘린더 도메인). 라이브 0/28 정합.
- **bundle_qty 전무 = 정상**: 실사 대형 = 장당 단위(묶음 없음). 라이브 0/28.
- **page_rule 전무 = 정상**: 낱장 대형 출력엔 페이지 규칙 무의미. 라이브 0/28.
- **size 본 범위 외**: 28/28 기적재(양호).

addon은 process 뒤(`addon_prd_cd`가 기성 천정고리 PRD_000008을 FK로 가리키며 master 등록됨).

---

## 3. R-카테고리별 적재 설계

### R2 (Medium) — 화이트별색 공정 적재 [process active 1행]

**도메인 근거(G-SL-2, entity-model §3-2):** L1 접착투명포스터 `화이트별색(옵션)=단면`. 별색 = 공정(PROC_000007 family,
화이트=PROC_000008). **투명소재 위 화이트 underbase** — 투명 원단은 바탕이 비쳐 CMYK가 탁해짐 → 화이트가 불투명 베이스로
발색·불투명도 확보(표준 강한 근거). 라이브 122 process 0행(SELECT #11) = 결함.

**변환 로직 (L1 → DB):**
| L1 신호컬럼 (값≠`없음`) | 상품 | 기대 proc_cd | proc_nm |
|-------------------------|------|:------------:|---------|
| `화이트별색(옵션)`=`단면` | 접착투명포스터(122) | PROC_000008 | 화이트(별색) |

- `t_prd_product_processes`에는 면(단면/양면) 컬럼이 **없다**(스키마=`prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt`).
  `단면` 정보는 `prcs_dtl_opt`(마스터) 또는 process 라인의 의미로 흡수 — 상품 연결행은 proc_cd FK만 적재.
- `mand_proc_yn = N`(선택 별색), `excl_grp_cd` 공란(택일 무관), `disp_seq = 10`(코팅 등 기적재 이후).
- **단일 상품**: L1 전수 점검 결과 화이트별색 신호는 접착투명포스터 1건뿐(다른 투명/접착 계열 = `없음` 또는 미보유).
  ★투명포스터는 미등록(C-1 비활성)이라 적재 대상 아님(D-SL-7 컨펌 시 동반).

> **provenance:** `L1:접착투명포스터 화이트별색(옵션)=단면 → PROC_000008 (R2/G-SL-2)`

---

### R3 (Medium) — 거치대/고리/끈 addon [addon active 1행 + flag 9]

**도메인 근거(G-SL-4, C-6 binding):** L1 추가(옵션) = 족자포스터 `천정형고리`, PET/메쉬배너 `실내/실외 배너거치대`,
현수막 `큐방/끈/각목`. C-6 확정: 부속은 **단일 분류 불가 — 항목·맥락별**. 거치대/고리=완제 addon, 끈/큐방/각목=부착(081) 성격.

**master addon 후보(라이브 ref-products):**
PRD_000008 천정고리(use_yn=N) · PRD_000012 우드거치대 · PRD_000013 우드봉 · PRD_000014 우드행거 · PRD_000010 행택끈.

**L1 추가옵션 → addon_prd_cd 매칭표:**
| L1 추가옵션 표기 | 상품 | → addon_prd_cd | 매칭근거 | 처리 |
|------------------|------|:--------------:|----------|------|
| 우드행거+면끈 | 캔버스행잉(133) | PRD_000014 | 정확 | **기적재**(skip) |
| 우드봉+면끈 | 린넨우드봉족자(134) | PRD_000013 | 정확 | **기적재**(skip) |
| 천정형고리 | 족자포스터(135) | PRD_000008 | 정확(천정고리) | **적재 1행** |
| 실내/실외 배너거치대 | PET배너(136)·메쉬배너(137) | **(없음)** | master 미존재(우드거치대≠배너거치대) | **flag**(D-SL-3) |
| 큐방(4개) | 일반현수막(138) | (없음) | master 미존재 + 부착(081) 성격 | **flag/CONFIRM**(D-SL-4) |
| 끈(4개)/각목 | 일반현수막(138)·메쉬현수막(139) | (없음) | master 미존재 + 부착 성격 | **flag/CONFIRM**(D-SL-4) |

**핵심 처리:**
- **진짜 적재 = 천정고리(PRD_000008)뿐** → 족자포스터(135) 1행. (단 천정고리 master `use_yn=N` → `note`로 출시연동 표기, D-SL-3.)
- 우드행거/우드봉은 133/134에 **기적재**(라이브 SELECT #10) → 중복PK 회피 skip.
- **배너거치대/큐방/각목/끈 = master 미존재 → 발명 금지, `_deferred/...addons_flag_deferred.csv`에 9건 flag.**
  digital-print "엽서봉투 미존재→flag" 패턴과 동일.
- **C-6 축 모호(끈/큐방/각목)**: 부착공정(PROC_000081) vs 완제 addon 이중성. 단정 금지 → CONFIRM(D-SL-4).

> **PK·이중성 처리:** C-8(과세분화 금지·관리 용이성) 적용 — 끈/큐방/각목을 무리하게 신규 addon 등록하지 않고
> 도메인 축(addon vs 부착공정)을 컨펌으로 남김. 발명보다 보류가 안전.

> **provenance:** `L1:족자포스터 추가(옵션)=천정형고리 포함 → addon 천정고리 PRD_000008 (R3/G-SL-4)`

---

### R4 (Medium) — 대형 nonspec 범위 적재 [UPDATE 13행]

**도메인 근거(G-SL-6, R-SIZE-5):** L1 포스터/패브릭/현수막류 `사용자입력`+비규격 가로/세로 범위. 라이브 nonspec_yn=Y이나
`width/height_min/max` 전 28상품 NULL(acrylic과 동일 갭) → 위젯 사용자입력 검증·round-2 면적가격 불가.

**변환 로직 (L1 → DB UPDATE):**
| L1 신호 | DB 컬럼 | 변환 |
|---------|---------|------|
| `비규격(최소/최대)_가로`=`200~1200` | nonspec_width_min/max | `200.00`/`1200.00` (numeric(8,2)) |
| `비규격(최소/최대)_세로`=`200~3000` | nonspec_height_min/max | `200.00`/`3000.00` |

- **active 13상품**: nonspec_yn=Y + 비규격 가로/세로 보유 + 숨김아님. (118~128 포스터/패브릭 11 + 일반현수막138 + 메쉬현수막139).
- **nonspec_yn 정정 불요**: 13상품 모두 라이브 nonspec_yn 이미 Y → UPDATE는 width/height 범위만(target_nonspec_yn=Y 동일).
- **numeric(8,2) 적합 확인**: 최대값 5000.00(일반현수막 세로) ≤ 정수부 6자리(999999.99) 한계 → 제약 위반 0(verify 가드 PASS).
- **폼보드(129) 제외(보류)**: nonspec_yn=N + 사용자입력 행 `_row_hidden=true` + 단위 스케일 이상(`20~120` vs 포스터 `200~1200`
  → cm 의심) → active 제외, `_deferred/deferred_inactive.csv`. 활성화·단위 컨펌(D-SL-5).

> **provenance:** `L1:아트프린트포스터 비규격 가로=200~1200·세로=200~3000mm (R4/G-SL-6)`

---

### R6 (Medium) — qty_unit 일괄 부여 [UPDATE 28행]

- **C-4 binding:** "상품군별 기본 일괄 부여". silsa 대형 실사 출력물 = 장당 1개 단위(L1 제작수량 증가=1, 묶음 없음) → **QTY_UNIT.01(EA)**.
- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  `t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.01), use_yn, _provenance`.
- **대상:** silsa 28등록 전건(PRD_000118~145). 라이브 현재 전건 NULL(글로벌 갭 G-SL-9).
- **EA vs 매 택일**: 과업 노트 "C-4(대형→EA/매)". 실사 대형 = 장당 출력물 → EA가 자연스러움(digital-print 낱장=매와 구별).
  단 EA/매 최종 택일은 D-SL-6 컨펌.
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품 — silsa 한정 아님. 본 set은 silsa 28건만. 전사 정책(상품군별 매핑표)은 별도 일괄.

---

### R1 (High, DEFERRED) — 보드/액자 자재 [material active 0행, deferred 7]

**도메인 근거(G-SL-1):** 폼보드/포맥스/프레임리스/레더아트액자/미니보드 = 보드/액자 자체가 자재. L1 `소재(필수)` 공백
(보드 자체가 소재) → 라이브 5상품 material 0행(SELECT #11).

**L1 자재 신호 실태(가공칸):**
| 상품 | L1 가공(옵션) 신호 | 자재 후보 | mat_cd master | 처리 |
|------|--------------------|-----------|:-------------:|------|
| 폼보드(129) | `화이트보드`/`블랙보드` | 화이트/블랙 보드 variant | **미존재** | **deferred**(D-SL-1) |
| 포맥스보드(130) | `화이트포맥스(3mm)`/`(5mm)` | 두께 variant | **미존재** | **deferred**(D-SL-1) |
| 프레임리스우드액자(131) | 소재·가공 전 공백 | 프레임? 출력소재? | **불명** | **deferred**(D-SL-2) |
| 레더아트액자(132) | 소재·가공 전 공백 | 레더? 프레임? | **불명** | **deferred**(D-SL-2) |
| 미니보드스탠딩(144) | 소재·가공 전 공백 | 보드? | **불명** | **deferred**(D-SL-2) |

**핵심 — 발명 금지로 active 0행:**
- 폼보드/포맥스는 grounded 자재 **이름**(화이트보드/블랙보드/화이트포맥스3mm/5mm)이 L1에 있으나, **MAT master에 대응 mat_cd가 없다**
  (MAT_TYPE.08 실사소재 = 인화지/PET/PVC/천 등뿐, 보드/포맥스 mat_cd 부재 — 라이브 ref 확인). → **mat_cd 발명 금지 → active 0행**.
- 액자 3종(131/132/144)은 L1 소재/가공 전 공백 → 자재 식별 자체 불가(프레임 vs 출력소재 모호) → 발명 금지.
- 전 7행 `_deferred/...materials_board_deferred.csv`에 grounded 이름·미존재 사유 보존. **보드자재 신규 mat_cd 등록 컨펌(D-SL-1/2) 후 적재.**
- C-8 적용: 폼보드 화이트/블랙·포맥스 3/5mm는 자재 variant(색상·두께) — 신규 등록 시 별도 mat_cd vs 통합 관리는 실무 판단.

> **provenance:** `L1:폼보드 가공=화이트보드/블랙보드 → 보드자재(소재칸 공백) (R1/G-SL-1) | MAT master 미존재 → 발명 금지`

---

### R5 — false 누락 정정 (적재 변경 없음)

- **G-SL-3 코팅 부분누락**: 라이브 SELECT #6 결과 아트프린트·방수·접착방수·폼보드·포맥스·프레임리스·PET배너·미니배너
  코팅(014/015) **적재됨(정합 MATCH)**. v2가 코팅 누락으로 봤다면 false. **적재 변경 없음.**
- **G-SL-5 봉제/타공/족자/부착**: 라이브 정합 적재(MATCH·권위반전). param도 마스터 보유. **적재 변경 없음**(모범 보존, mobeum-no-reload 가드).
- **삭제 절대 금지:** 본 설계는 누락 행 추가/UPDATE만 — 어떤 행도 삭제 제안하지 않음(EXTRA 삭제 단정 금지 HARD).

---

## 4. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류 | 보류 사유 |
|---|------|------------|:----------:|:----:|----------|
| R1 | 보드/액자 자재 | t_prd_product_materials | **0** | 7(deferred) | mat_cd master 미존재(폼보드/포맥스)·소재 공백(액자) → 발명 금지 |
| R2 | 화이트별색 | t_prd_product_processes | **1** | — | — |
| R3 | 거치대/고리/끈 addon | t_prd_product_addons | **1** | 9(flag) | master 미존재(배너거치대/큐방/각목)·축 모호(끈/큐방=부착?) |
| R4 | 대형 nonspec | t_prd_products(UPDATE) | **13** | 1(폼보드 deferred) | nonspec_yn=N+숨김+단위이상 |
| R6 | qty_unit | t_prd_products(UPDATE) | **28** | — | — |
| R5 | false 누락 | — | 0(정정만) | — | 코팅·봉제/타공/족자 정합 MATCH |
| 모범 | 봉제/타공/족자/부착/코팅 | t_prd_product_processes | **0(NO-OP)** | — | 기적재 정상(G-SL-5) — 재적재 금지 |

- **active 적재 합계: process 1 + addon 1 + nonspec UPDATE 13 + qtyunit UPDATE 28 = 43행.**
- **보류 합계: 보드자재 7 + addon flag 9 + 비활성 2(폼보드 nonspec·★투명포스터) = 18.**
- **모범 재적재 0행**(봉제/타공/족자/부착/코팅) — mobeum-no-reload 가드로 기계 보증.

---

## 5. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-SL-1** | 폼보드/포맥스 자재 등록 | deferred(4행) | 폼보드 화이트/블랙보드·포맥스 3/5mm를 **신규 mat_cd로 MAT master 등록**할지? 색상/두께 variant는 별도 mat_cd vs 통합(C-8)? |
| **D-SL-2** | 액자 3종 자재 식별 | deferred(3행) | 프레임리스/레더아트액자/미니보드 = 자재가 프레임(우드)인지 출력소재인지? (L1 소재/가공 전 공백) |
| **D-SL-3** | 배너거치대 addon | flag(4행) | 실내/실외 배너거치대 = master 미존재. 신규 기성상품 등록? 우드거치대(012)에 매핑? 천정고리(008) use_yn=N 출시 연동? |
| **D-SL-4** | 큐방/각목/끈 축 | flag(5행) | C-6: 끈/큐방/각목 = **addon(완제 부속)** vs **부착공정(PROC_000081)** 어느 축? master 미존재 시 처리? |
| **D-SL-5** | 폼보드 nonspec | deferred(1행) | 폼보드 사용자입력 행 숨김+nonspec_yn=N → 비활성 맞나? 비규격 `20~120` 단위(cm? mm?) 확정 |
| **D-SL-6** | qty_unit EA vs 매 | EA(QTY_UNIT.01) 적재 | 실사 대형 = 장당 → EA로 가정. 매(QTY_UNIT.02)가 맞나? 상품군별 정책 확정 |
| **D-SL-7** | ★투명포스터 미등록 | deferred(비활성) | ★제약 미등록 투명포스터 출시 대기 등록? 보류? (출시 시 화이트별색 동반) |

> **D-SL-3·D-SL-4는 C-6 도메인 권위 답변(맥락별 판정) 후속** — 항목별 addon/공정 축 확정 필요.
> **D-SL-5·R2/R3 stale 의존**은 적재 직전 라이브 export로 verify 재실행 시 자동 검출.

---

## 6. self-check 실행결과 (PASS 확인)

재실행: `python3 09_load/silsa/verify_expected.py` → **exit 0 (2026-06-05 실행 확인):**

```
=== SELF-CHECK (silsa) ===
label                    exp   act  miss  extra  result
R2-white-spot              1     1     0      0  PASS
mobeum-no-reload           0     0     -      0  PASS
R4-nonspec                13    13     0      0  PASS
R6-qtyunit                28    28     0      0  PASS
R3-addon                   1     1     0      0  PASS
FK-existence               -     -     -      0  PASS
nonspec-numeric(8,2)       -     -     -      0  PASS

GATE: PASS — 누락0·날조0·모범재적재0   (exit 0)
```

상세는 `expected-vs-load.md`. **모범재적재0 가드가 봉제/타공/족자/부착/코팅 미건드림을 기계 보증.**

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 자재/addon/process 기적재 판정에 사용.
- **판정이 stale에 의존하는 지점** = ① 122 화이트별색 process 0행(remediation 라이브 #11도 0행 — 일치) ② 봉제/타공/족자
  기적재(머리말 권위반전) ③ 135 addon 0행 ④ 5상품 material 0행(SELECT #11).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0·모범재적재0**"(자기검증 PASS, exit 0).
