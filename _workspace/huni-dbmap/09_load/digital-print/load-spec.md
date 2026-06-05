# digital-print 적재 설계서 (load-spec) — round-3 remediation 파일럿

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/digital-print.md` ⑤의 R1~R6을 FK 순서 적재 설계 + 적재용 CSV로 변환.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/digital-print-l1.csv`) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`,
> stale 2026-06-04 주의) · IMPORT 매트릭스(`06_extract/import-paper-matrix-long.csv`). 추정 0 — 모든 행은
> L1 셀 또는 ref/IMPORT 라인에 추적된다(provenance 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1/C-3/C-4/C-6/C-7/C-8 binding 적용.

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R1 줄수/개수 공정 (active) | 26 |
| `load/t_prd_product_materials.csv` | t_prd_product_materials | R3 IMPORT 종이 자재 | 180 |
| `load/t_prd_product_addons.csv` | t_prd_product_addons | R4 누락 봉투 addon | 2 |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R6 qty_unit 일괄 | 36 |
| `cascade-constraints.csv` | (신설 shape) | benchmark §9 캐스케이드 제약 | 1 |
| `t_prd_product_processes_conditional.csv` | (보류) | 016 라이브충돌 R1 행 | 4 |
| `_deferred/t_prd_product_processes_deferred.csv` | (보류) | use_yn=N + R2 형압 | 4 |

생성기 `gen_load.py`(재현 가능) · 검증 `verify_expected.py`(게이트 PASS).

---

## 1. CRITICAL — 016 검증 결과 (R1 생성 선행)

**과업 지시:** 프리미엄엽서(016)는 줄수/개수 공정이 "수동시험 적재"됐다(사용자 확인). 무비판 복제 금지 —
016이 엑셀 의도대로 들어갔는지 검증 후 패턴화.

**검증 절차·결과:**

1. **L1 엑셀 신호(016, row_seq 3~6):** `오시 없음|1줄|2줄|3줄` · `미싱 없음|1줄|2줄|3줄` ·
   `가변(텍스트) 없음|1개|2개|3개` · `가변(이미지) 없음|1개|2개|3개`. → 도메인상 016은
   **PROC_000029(오시)·030(미싱)·031(가변텍스트)·032(가변이미지) 4종 보유**가 엑셀 의도.
2. **stale ref-CSV(`ref-product-processes.csv`, 2026-06-04) 실태:** 016 processes = **PROC_000027·028(직각·둥근)뿐.
   29/30/31/32 부재.**
3. **remediation 라이브(2026-06-05) 보고:** 016은 **29/30/31/32 이미 적재**(머리말 권위반전).

**판정 — DIVERGENCE(권위 충돌):** stale ref와 라이브 보고가 **정면 충돌**한다.
- 엑셀 의도(29~32 보유)는 양쪽 모두와 정합 — **패턴 자체는 검증됨**(줄수형: 29·30·31·32).
- 그러나 016에 *지금 무엇이 적재돼 있는가*는 stale=27/28만 / 라이브=29~32로 갈려 **단정 불가**.
- 016은 "수동시험 적재"라 **의도된 레퍼런스 아님** → **016 자체를 자동 적재 대상에서 분리(conditional)**.

**조치:**
- 016의 R1 4행은 `t_prd_product_processes_conditional.csv`에 **보류**(active 적재 미포함).
  사유: 라이브가 이미 29~32를 가지면 중복 PK, stale대로 부재면 적재 필요 — **적재 직전 라이브 재확인 후 결정**.
- 검증된 패턴(줄수형=29·30·31·32 / 개수형=31·32)은 **016이 아니라 L1 신호에서 직접 도출**해 나머지 상품에 적용.
- 016 자체 정정(만약 라이브가 잘못 적재됐다면)은 **본 패스에서 자동 수정 안 함** — finding으로만 보고(과업 지시).

> **설계결정 D-1(컨펌):** 016 라이브 process 실상태 확인 — 29~32 적재돼 있나? 수동시험분이 올바른가?
> 올바르면 conditional 4행 폐기(중복), 부재면 active로 승격. **라이브 SELECT 1회로 즉시 해소 가능.**
>
> **[해소 2026-06-05]** dbm-validator 라이브 SELECT 결과 016 = `27,28,29,30,31,32` 실재 → conditional 4행
> **DROP 확정**(active 승격 금지=중복PK). 016 수동시험분 자체 정합성(엑셀 의도대로 들어갔나)은 D-1 잔여로 별도 검토.

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`)는 건전 → **상품 연결 테이블만** 적재.

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 선/후 무관(독립)
② size                                — n/a (digital-print 대부분 기적재, 본 범위 외)
③ material (R3)                       — IMPORT 해소 선행. FK: prd_cd→t_prd_products, mat_cd→t_mat
④ process (R1)                        — FK: prd_cd→t_prd_products, proc_cd→t_proc
   excl_group                         — n/a (digital-print 전무=정상, ③ 라이브)
⑤ addon (R4)                          — FK: prd_cd→t_prd_products, addon_prd_cd→t_prd_products(기성상품)
⑥ page_rule / bundle_qty             — n/a (낱장상품→전무=정상)
```

**no-op 단계와 사유:**
- **excl_group 전무 = 정상**: digital-print는 공정 택일그룹 부재(택일은 책자·캘린더 도메인). MISSING 아님.
- **bundle_qty 전무 = 정상(보류)**: 낱장 묶음수 도메인 미확정(G-DP-8 CONFIRM). 본 적재 대상 아님.
- **page_rule 전무 = 정상**: 낱장 상품엔 페이지 규칙 무의미.
- **size 본 범위 외**: 33/36 기적재(봉투류 3종만 0행). 본 파일럿은 R1/R3/R4/R6에 집중.

addon은 process 뒤에 둔다(`addon_prd_cd`가 기성 봉투상품 PRD_000001~005를 FK로 가리키며, 이들은 이미 등록됨).

---

## 3. R-카테고리별 적재 설계

### R3 (High) — 자재 IMPORT 종이 적재 [material 180행]

**도메인 근거(R-MAT-2, C-3 binding):** 엑셀 종이칸 `*별도설정`은 빈값이 아니라 가격표 `출력소재(IMPORT)`에
실자재가 정의됨의 포인터(C-3 "IMPORT ● 종이 = 실자재"). 원적재가 이를 제외해 자재 전량 누락.

**변환 로직 (엑셀/IMPORT → DB):**
| 단계 | 입력 | 출력 |
|------|------|------|
| 1 | IMPORT 매트릭스 `product_col`+`mark=●` | 상품별 ●종이 리스트 |
| 2 | `paper_name`("백색모조지 220g") → `t_mat.mat_nm` 정확매치 | `mat_cd`(MAT_000074) |
| 3 | (prd_cd, mat_cd, usage_cd=USAGE.07 공통, dflt_yn, disp_seq) | t_prd_product_materials 행 |

- `usage_cd = USAGE.07(공통)` — digital-print 낱장은 내지/표지 분해 없는 단일슬롯(생산구조 C 완제품, L2 §4).
  기존 정상 적재(코팅엽서 017·스탠다드명함 033)가 모두 USAGE.07이라 컨벤션 정합.
- `dflt_yn = Y`(disp_seq 1), 나머지 N. `disp_seq` 1부터 증가.

**IMPORT 커버리지 (9상품 중):**
| prd_cd | 상품 | IMPORT 컬럼 | 종이수 | 해소 |
|--------|------|------------|:------:|:----:|
| 016 프리미엄엽서 | 프리미엄엽서 | 프리미엄엽서 | 21 | ✅ |
| 018 스탠다드엽서 | 스탠다드엽서 | 스탠다드엽서 | 7 | ✅ |
| 027 2단접지카드 | 카드3종 공용 | 2단/3단/미니접지카드 | 14 | ✅ |
| 028 미니접지카드 | 카드3종 공용 | 〃 | 14 | ✅ |
| 029 3단접지카드 | 카드3종 공용 | 〃 | 14 | ✅ |
| 031 프리미엄명함 | 프리미엄명함 | 프리미엄명함 | 16 | ✅ |
| 047 소량전단지 | 전단지/리플렛 공용 | 소량전단지/접지리플렛 | 47 | ✅ |
| 048 접지리플렛 | 전단지/리플렛 공용 | 〃 | 47 | ✅ |
| **038 형압명함** | — | **IMPORT 컬럼 부재** | — | ❌ **미해소** |

- **매칭 품질:** 21+7+14+14+14+16+47+47 = **180행, exact 매치 100%**(fuzzy 0, unmatched 0). 추정·날조 없음.
- **카드 3종 공용:** IMPORT 1컬럼이 3상품 공유(동일 종이세트). 상품별 14행 동일 적재(C 단일상품).
- **형압명함(038) 미해소:** IMPORT에 형압명함 전용/공유 컬럼 없음(`seoljeong-import-map.md` 미매칭6 중 1).
  → **추정으로 종이 리스트 발명 금지**. 자재 적재 보류 + 컨펌(설계결정 D-2). 게다가 038은 use_yn=N(R2 보류군)이라
  자재도 출시 시점 처리가 타당.

> **provenance 예:** `IMPORT:프리미엄엽서● 백색모조지 220g→MAT_000074 (R3, seoljeong-import-map)`

---

### R1 (High) — 줄수/개수 공정 적재 [process active 26행, conditional 4, deferred 2]

**도메인 근거:** 엑셀 `없음|1줄|2줄|3줄`(오시·미싱)·`없음|1개|2개|3개`(가변텍스트·가변이미지)는
**그 후가공 공정이 이 상품에 존재한다는 신호**(옵션값 아님). 원적재가 옵션값으로 오해해 공정행 누락.

**변환 로직 (L1 → DB):**
| L1 신호컬럼 (값≠`없음`) | 기대 proc_cd | proc_nm |
|-------------------------|:------------:|---------|
| `후가공(옵션)_오시` | PROC_000029 | 오시(Crease 누름선) |
| `후가공(옵션)_미싱` | PROC_000030 | 미싱(Perforation) |
| `후가공(옵션)_가변(텍스트)` | PROC_000031 | 가변텍스트 (VDP) |
| `후가공(옵션)_가변(이미지)` | PROC_000032 | 가변이미지 (VDP) |

- **`prcs_dtl_opt`(줄수/개수 max=3)는 마스터(`ref-processes`)에 이미 보유** — 29/30=`{줄수 max:3}`, 31/32=`{개수 max:3}`.
  `t_prd_product_processes`에는 `prcs_dtl_opt` 컬럼이 **없다**(스키마=`prd_cd,proc_cd,excl_grp_cd,mand_proc_yn,disp_seq,reg_dt,upd_dt`).
  → 상품 연결행은 **proc_cd FK만** 적재하면 param은 마스터에서 자동 상속. (R1의 "prcs_dtl_opt 부여"는 마스터 레벨 — 이미 충족.)
- `mand_proc_yn = N`(선택 후가공), `excl_grp_cd` 공란(택일그룹 무관), `disp_seq` 10부터(직각27/둥근28 이후).

**상품별 패턴 (L1 신호 검증 결과, 016 제외):**
| 패턴 | 상품 (prd_cd) | proc | use_yn | 분류 |
|------|---------------|------|:------:|------|
| **줄수형**(29·30·31·32) | 스탠다드엽서 018·스탠다드쿠폰/상품권 041·프리미엄쿠폰/상품권 042 | 4종 | Y | active(12행) |
| **개수형**(31·32) | 2단접지카드 027·3단접지카드 029·프리미엄명함 031·스탠다드명함 033·소량전단지 047·접지리플렛 048·와이드접지리플렛 049 | 2종 | Y | active(14행) |
| 개수형 | **미니접지카드 028** | 2종 | **N** | **deferred** |
| 줄수형 | **프리미엄엽서 016** | 4종 | Y | **conditional**(§1) |

- **active 26행** = 줄수형 3상품×4 + 개수형 7상품×2 = 12+14. (016 conditional·028 deferred 제외)
- **개수형에 스탠다드명함(033)·와이드접지리플렛(049) 포함**: L1에서 가변T/가변I 1~3개 신호 확인(remediation ④표 정합).
- **줄수형에 쿠폰/상품권(041·042)**: L1에서 오시·미싱·가변 4종 모두 신호 보유 확인.

> **provenance 예:** `L1:스탠다드엽서 오시/미싱(없음|1~3줄)+가변T/가변I(없음|1~3개) → 29오시·30미싱·31가변텍스트·32가변이미지 (R1)`

---

### R2 (Low, DEFERRED) — 형압명함 형압 자식 공정

- **도메인 근거:** L1 형압명함 `박/형압 가공 = 형압(양각)|형압(음각)|형압(없음)` → 자식 leaf
  PROC_000051(양각)·052(음각). 부모 050 미적재(R-PROC-4 자식 leaf 규칙). `prcs_dtl_opt.크기`(mm) 마스터 보유.
- **분류:** 형압명함(038) **use_yn=N(미출시, C-1 비활성)** → active 적재 분리.
  → `_deferred/t_prd_product_processes_deferred.csv`에 2행 보류(reason="use_yn=N 미출시 + R2 Low(출시 시 적재)").
- **출시 시 적재**: 038 출시(use_yn=Y) 전환 시 deferred 2행 + R3 형압명함 자재(IMPORT 해소 후)를 함께 적재.

---

### R4 (Medium) — 누락 봉투 addon [addon 2행 + flag 2]

**도메인 근거(C-6 binding):** 봉투 = 기성상품(독자판매)+addon 이중성. 엽서류 추가상품 = 봉투 6종.
addon 링크행으로 설계하되, **봉투명↔addon_prd_cd 매칭은 brittle** → best-match + 불확실은 flag(추정 금지).

**master 봉투 5종(addon_prd_cd 후보):**
PRD_000001 OPP접착봉투 · 002 OPP비접착봉투 · 003 트래싱지 카드봉투 · 004 카드봉투 · 005 캘린더봉투.

**L1 봉투 6종 → addon_prd_cd 매칭표:**
| L1 봉투 표기 | → addon_prd_cd | 매칭근거 | 처리 |
|--------------|:--------------:|----------|------|
| OPP접착봉투 | PRD_000001 | 정확 | 016·018 **기적재**(skip) |
| OPP비접착봉투 | PRD_000002 | 정확 | 016·018 **기적재**(skip) |
| 카드봉투(화이트) | PRD_000004 | 색상=비addon축 → 카드봉투 통합 | 016·018 **기적재**(skip) |
| 카드봉투(블랙) | PRD_000004 | 〃 (화/블 동일 prd_cd) | **PK 통합**(화이트와 1행, 색상은 note) |
| 트레싱지봉투 | PRD_000003 | 표기차(트래싱지 카드봉투) | **적재**(016·018 각 1행) |
| **엽서봉투** | **(없음)** | master 미존재 | **flag — 신규등록/매칭 컨펌** |

**핵심 정정 (stale 권위반전):** remediation ④ G-DP-4는 016에 "카드봉투(화이트)·엽서봉투·트레싱지봉투 3종 누락"으로
보고했으나, **stale ref-CSV는 016·018 모두 PRD_000001/002/004 기적재**를 보인다. 즉:
- 카드봉투(화이트)=PRD_000004는 **이미 적재됨** → 누락 아님(중복 PK 회피로 skip).
- 카드봉투(블랙)도 PRD_000004로 귀속되므로 **별도 링크 불가**(PK=prd_cd+addon_prd_cd 1행, 색상은 비addon축=note).
- **진짜 누락 = 트레싱지봉투(PRD_000003)뿐** → 016·018 각 1행 = **2행 적재**.
- **엽서봉투 = master 미존재 → 발명 금지, flag**(D-3).

> **PK 충돌 처리:** C-8(과세분화 금지·관리 용이성) 적용 — 카드봉투 화/블은 색상변형으로 1 addon_prd_cd에 통합,
> 색상은 `note`로 구분. addon 테이블에 색상축 신설은 과세분화라 지양.

> **provenance 예:** `L1:프리미엄엽서 추가상품=트레싱지봉투 → addon PRD_000003 (표기차 트래싱지 카드봉투) (R4)`

---

### R6 (Medium) — qty_unit 일괄 부여 [UPDATE set 36행]

- **C-4 binding:** "상품군별 기본 일괄 부여". digital-print 낱장 → **QTY_UNIT.02(매)**.
- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  별도 `t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.02), use_yn, provenance`.
- **대상:** digital-print 36상품(PRD_000016~051) 전건. 라이브 현재 전건 NULL(글로벌 갭 G-DP-9).
  use_yn=N 7상품도 포함(컬럼 업데이트는 비활성 무관, 출시 시 즉시 유효).
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품 — digital-print 한정 아님. 본 set은 digital-print 36건만.
  전사 정책은 상품군별 매핑표(낱장=매/책자=권/굿즈=EA) 별도 일괄(C-4) — 본 파일럿 범위 밖.

---

### R5 — false EXTRA 정정 (적재 변경 없음)

- **G-DP-5 박색상 자식 EXTRA**: 프리미엄명함·프리미엄상품권의 박색상 자식 8종 적재는 **R-PROC-4 정합(정상 MATCH)**.
  v2 EXTRA 철회. **적재 변경 없음.**
- **G-DP-6 자재 표기차 EXTRA**: 코팅엽서 `아트250`=`아트지 250g`(MAT_000081) 정규화 MATCH. v2 false EXTRA.
  **적재 변경 없음.**
- **삭제 절대 금지:** 본 파일럿은 누락 행 추가만 — 어떤 행도 삭제 제안하지 않음(EXTRA 삭제 단정 금지 HARD).

---

## 4. 캐스케이드 제약 신설 (benchmark §9 권고, 1건)

**근거:** benchmark §9는 후니 스키마가 경쟁사 표현력을 흡수했으나 **단 하나 — 캐스케이드 제약(자재/사이즈→공정 disable)**만
보강 권고. `constraint_json`은 digital-print 전상품 NULL(약한 제약 테이블, 라이브 확인).

**L1 실근거(추정 아님):** digital-print `코팅(옵션)` 컬럼이 셀 주석으로
**"★종이두께선택시 : 180g이상 코팅가능"**을 명시. = **자재(종이 평량) < 180g → 코팅 공정 disable**.
digital-print에서 발견된 **유일한 실제 disable 제약**(다른 disable 신호 L1 전수 점검 결과 없음).

**제안 shape (`cascade-constraints.csv`):**
| 컬럼 | 값 | 의미 |
|------|-----|------|
| scope | digital-print | 적용 범위 |
| prd_cd | PRD_ALL_DP | digital-print 전상품(코팅 보유 상품) |
| constraint_type | material_thickness->process_disable | 제약 유형 |
| trigger_axis / trigger_cond | material(종이 평량 g) / 평량 < 180g | 트리거 |
| target_axis / target_action / target_value | process(코팅 PROC_000014~016) / disable / 코팅 비활성(180g 미만) | 효과 |

**적재 위치 권고(D-4 컨펌):** `t_prd_products.constraint_json`(기존 NULL 컬럼)에 위 구조를 JSON으로 인코딩하거나,
신규 제약 테이블(`t_prd_product_constraints`) 신설. constraint_json 재사용이 DDL 0이라 우선 권고.
**실 rows는 shape 1건만 제시** — digital-print엔 이 1개 외 grounded disable 제약 없음(발명 금지).

---

## 5. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류 | 보류 사유 |
|---|------|------------|:----------:|:----:|----------|
| R3 | 자재 IMPORT | t_prd_product_materials | **180** | (038 미해소) | IMPORT 컬럼 부재 + use_yn=N |
| R1 | 줄수/개수 공정 | t_prd_product_processes | **26** | 016=4(conditional)·028=2(deferred) | 라이브충돌·use_yn=N |
| R2 | 형압 자식 | t_prd_product_processes | 0 | 038=2(deferred) | use_yn=N 미출시 |
| R4 | 봉투 addon | t_prd_product_addons | **2** | 엽서봉투=2(flag) | master 미존재 |
| R6 | qty_unit | t_prd_products(UPDATE) | **36** | — | — |
| R5 | false EXTRA | — | 0(정정만) | — | 정상 MATCH |
| 신설 | 캐스케이드 제약 | constraint_json(shape) | 1(shape) | — | — |

- **active 적재 합계: material 180 + process 26 + addon 2 + qtyunit 36 = 244행** + cascade shape 1.
- **보류 합계: conditional 4 + deferred 4 + flag 2 + 038 자재미해소.**

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-1** | 016 라이브 process 실상태 | conditional 보류(4행) | 016에 29~32 이미 적재됐나? 수동시험분이 엑셀의도대로 올바른가? → 적재/폐기/정정 결정 |
| **D-2** | 형압명함(038) 자재 출처 | 미해소·보류 | IMPORT 형압명함 컬럼 부재. 프리미엄명함 종이세트 공유? 별도 종이리스트 출처? (use_yn=N이라 출시 시 처리 가능) |
| **D-3** | 엽서봉투 addon 매칭 | flag(미적재) | master에 "엽서봉투" 미존재. 신규 기성상품 등록? 기존 봉투(005 캘린더봉투 등)에 매핑? |
| **D-4** | 캐스케이드 제약 적재 위치 | shape만 제시 | `constraint_json`(DDL 0) vs 신규 제약테이블? 180g 기준 평량 데이터 소스(mat별 평량) 어디서? |
| **D-5** | 3단접지카드(029) use_yn 충돌 | active 적재(ref=Y 따름) | ref-products=Y이나 remediation 문서는 use_yn=N군에 029 나열. 라이브 use_yn 재확인 필요 |
| **D-6** | bundle_qty(G-DP-8) | 미처리(보류) | 명함 `건수`·낱장 묶음수 = bundle_qty 적재 대상인가? (도메인 미확정 CONFIRM) |
| **D-7** | qty_unit use_yn=N 7상품 포함 | 포함(36건) | 미출시 상품도 지금 qty_unit 부여? 출시 시 일괄? (컬럼 업데이트라 무해하나 정책 확인) |

> **D-1·D-5는 라이브 SELECT 1~2회로 즉시 해소 가능**(적재 직전 라이브 export로 verify 재실행 시 자동 검출).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 자재/addon 기적재 판정에 사용.
- **판정이 stale에 의존하는 지점** = D-1(016 process)·D-5(029 use_yn)·R4 addon 중복(016/018 기적재 여부).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0**"(자기검증 PASS, `expected-vs-load.md`).
