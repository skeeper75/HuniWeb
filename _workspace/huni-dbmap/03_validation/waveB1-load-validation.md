# Wave B1 적재 설계 독립 검증 — calendar(+design-calendar)·goods-pouch (round-3 remediation 전수)

> **작성** 2026-06-05 · dbm-validator(독립 적대적 검증) · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **검증 대상:** `09_load/calendar/`(택일그룹 H5 BLOCKER)·`09_load/goods-pouch/`(size 77상품 H1 BLOCKER).
> **검증자는 설계자가 아님** — 본 산출물을 작성하지 않았다. 기본 입장 = 회의(결함 입증 책임은 검증자에게).
> **권위 순서(HARD):** 라이브 DB(2026-06-05 SELECT) > 08_remediation/*.md > ref-*.csv(stale 2026-06-04). 엑셀 L1 > 정규화.
> **DB 쓰기 0** — 읽기전용 SELECT 1회(배치)만 수행. password 미노출.

---

## 0. 최종 판정 요약

| 시트 | 판정 | BLOCKER 처리 | 게이트 | 적재성 | 비고 |
|------|------|-------------|--------|--------|------|
| **goods-pouch** | **GO-WITH-FINDINGS** | size H1 = **BLOCKED-LEGIT(정당 차단, dodge 아님)** | PASS(exit 0) | OK(addon/qtyunit) | 폰케이스5·size BLOCKED 모두 정당 |
| **calendar(+design-cal)** | **NO-GO(MAJOR 해소 전)** | 택일 H5 = **PARTIAL(부분 해소)** + material 적재 **PK충돌 4행** | PASS(exit 0, but stale) | **material 4행 라이브 중복충돌** | 게이트는 stale라 충돌 미검출 |

- **upheld 판정:** goods-pouch size BLOCKED(정당)·폰케이스5 비활성(정당)·calendar editor_yn·qtyunit·excl_link UPDATE 타깃 실재. (7건)
- **overturned/finding:** calendar material 4행 라이브 PK충돌(MAJOR), 택일 H5 부분해소(MAJOR), design-cal 110 editor_yn 모호(MINOR). (3건)
- **NO-GO 사유(calendar):** material CSV를 stale 기준 그대로 적재하면 **4행 중복 PK INSERT 실패**(라이브 SELECT 직접 확인). 적재 전 해소 필수.

---

## 1. 게이트 재실행 + 독립 재산출

### 1-1. 게이트 byte 재현 — 양 시트 PASS(exit 0)

```
=== SELF-CHECK (goods-pouch) ===          === SELF-CHECK (calendar+design-calendar) ===
R4-addon-active     1   1  0  0  PASS      R3-material(IMPORT)  47  47  0  0  PASS
R3-proc-active      0   0  0  0  PASS      R1-excl_link(UPDATE)  4   4  0  0  PASS
R6-qtyunit         98  98  0  0  PASS      R6-qtyunit(EA)        5   5  0  0  PASS
GUARD-phonecase=0   -   -  -  0  PASS      C5-editor_yn(●→Y)     4   4  0  0  PASS
GUARD-size-newrow=0 -   -  -  0  PASS      design-cal-신규행0      0   -  -  0  PASS
FK-existence        -   -  -  0  PASS      FK-existence          -   -  -  0  PASS
GATE: PASS (exit 0)                        GATE: PASS (exit 0)
```

설계자 보고와 동일 재현. **단, 게이트는 `ref-*.csv`(stale 2026-06-04)에서 기적재/use_yn을 읽음** → §4 라이브 충돌 미검출(구조적 한계).

### 1-2. 독립 재산출 (생성기 미신뢰, 원천 재집계)

| 항목 | 설계자 claim | 검증자 독립 재산출 | 일치 |
|------|-------------|-------------------|:----:|
| calendar IMPORT ● material | 47 (8+7+10+22) | **47** (탁상8·미니7·엽서10·벽걸이22, 직접 재집계) | ✅ |
| calendar IMPORT mat_nm exact match | unmatched 0 | **unmatched 0** (47/47 t_mat.mat_nm exact) | ✅ |
| calendar excl_link UPDATE | 4 | **4** (110/79·111/21·111/79·112/21) | ✅ |
| calendar editor_yn ●→Y | 4 | **4** (108/109/111/112 디자인보유●, 110 blank) | ✅ |
| calendar excl_member flag | 6 | **6** (108삼각대·109삼각대·110가공없음·110우드·111가공없음·112제본없음) | ✅ |
| goods-pouch matched 98 | 98 / unmatched 5 | **98** (L1 103 distinct − 폰케이스5), unmatched=폰케이스5 | ✅ |
| goods-pouch qtyunit | 98 (PRD_000183~280) | **98** unique, 범위이탈 0, in-CSV dup 0 | ✅ |

→ **카운트·매칭은 전부 원천에서 독립 검증됨. 설계자 산출과 차이 0.** (생성기 출력 미신뢰 재생성 모범적.)

---

## 2. 적재성 DRY-RUN (정적: masters + 라이브)

| 테이블/CSV | type/length | FK 실재 | PK-dup(in-CSV) | PK-collision(라이브) | 판정 |
|-----------|:-----------:|:-------:|:--------------:|:--------------------:|:----:|
| cal `t_prd_product_materials`(47 INSERT) | OK(USAGE.07·dflt_yn∈{Y,N}) | OK(prd 47/47·mat 47/47) | 0 | **4 (MAT_000107 라이브 기적재)** | **FAIL → §4-A** |
| cal `*_excl_link_update`(4 UPDATE) | OK(GRP-CAL-가공·mand_yn=N) | OK(proc 4/4·excl_grp 헤더 실재) | n/a | **0 (라이브 타깃 NULL 확인)** | **OK** |
| cal `*_editor_yn_update`(5 UPDATE,Y=4) | OK(Y/N) | OK(prd 108~112) | n/a | 0 (라이브 전 N→UPDATE 정합) | **OK** |
| cal `*_note_update`(1 UPDATE) | OK | OK(GRP-CAL-가공 헤더) | n/a | 0 | **OK** |
| cal `*_qtyunit_update`(5 UPDATE) | OK(QTY_UNIT.01) | OK | n/a | 0 (라이브 전 NULL) | **OK** |
| gp `t_prd_product_addons`(1 INSERT) | OK(note 통합·disp_seq int) | OK(prd 217·addon_prd 015 실재) | 0 | **0 (라이브 217 addon=0행)** | **OK** |
| gp `t_prd_product_processes`(0행) | n/a(헤더만) | n/a | 0 | 0 | **OK** |
| gp `*_qtyunit_update`(98 UPDATE) | OK(QTY_UNIT.01) | OK(98 PRD_183~280) | 0 | 0 | **OK** |

**UPDATE-set 검증(과업 지시 핵심):**
- **calendar `*_excl_link_update.csv`(4행):** 라이브 SELECT로 110/79·111/21·111/79·112/21 **모두 실재·excl_grp_cd=NULL·mand=N 확인** → 기존 행 UPDATE(phantom INSERT 아님). target=`GRP-CAL-가공`은 110/111/112 헤더 실재(SEL_TYPE.01·max_sel_cnt=1). **타깃 정당.**
- **calendar `*_editor_yn_update.csv`(4행 Y):** 라이브 108~112 editor_yn 전부 N → 기존 행 UPDATE. 신규 prd_cd 0(108~112 강제). **정당.**
- **goods-pouch `*_qtyunit_update.csv`(98행):** 전 prd_cd가 PRD_183~280 실재 상품(UPDATE), 신규 0, dup 0. **정당.**

→ **유일한 적재성 위반 = calendar material 4행 라이브 중복(§4-A).** 나머지 전 항목 통과.

---

## 3. ADVERSARIAL — BLOCKER 처리 정당성 판정 (최우선)

### 3-A. goods-pouch size 77상품 (H1 BLOCKER) — **BLOCKED-LEGIT (정당 차단, dodge 아님) · UPHELD**

설계자는 `t_prd_product_sizes`에 적재하지 않고 `t_prd_product_sizes_BLOCKED.reference.csv`(125행)를 산출. **dodge인지 정당 차단인지가 본 검증 최대 판정.**

**검증자 L1 원천 직접 재판독(권위) — 결정적 증거:**

| 상품(샘플) | L1 `사이즈(필수)` | L1 `파일사양_재단사이즈` | L1 `파일사양_작업사이즈` |
|-----------|------------------|------------------------|------------------------|
| 레더 플랫 파우치 | `M`·`L` | **공란** | `220 x 300`·`260 x 340` |
| 타이벡 플랫 파우치 | `M`·`L`·`XL` | **공란** | `444 x 155`·`524 x 195`·`744 x 285` |
| 레더코스터 | `원형 90mm`·`사각 90mm` | **공란** | `100 x 100` |
| 머그컵 | `11온스` | **공란** | `190 x 80` |
| 틴거울 | `무광 75mm` | **공란** | `100 x 90` |
| 말랑키링 | `원형/사각/꽃/별/하트` | **공란** | `56 x 166` |
| 린넨 에코백 | `세로형`·`가로형` | **공란** | `390 x 910`·`430 x 830` |
| 레더 아이패드 파우치 | `11/13/15인치` | **공란** | `444 x 287`… |

**판정 근거(HARD):**
1. **`파일사양_재단사이즈` 컬럼이 L1에 실재하나 검사한 47 BLOCKED 상품 전부 공란.** 재단치수(WxH) 원천이 **실제로 부재**.
2. `사이즈(필수)`칸 값은 WxH 치수가 아니라 **형상/규격/용량 라벨**(M/L/XL·무광75mm·11온스·350ml·세로형/가로형·11인치) — 설계자의 NONDIM 분류가 **경험적으로 정확**.
3. WxH 치수는 오직 `파일사양_작업사이즈`(=plate 축)에만 존재. 이를 size로 적재하면 **plate 복제(과업 금지)** 또는 마스터 siz_cd 발명(추정 금지).
4. `t_prd_product_sizes` 마스터/테이블은 실재(`ref-product-sizes.csv` 존재, 라이브 확인) — 즉 "테이블 부재" 차단이 아니라 **"비치수 라벨↔마스터 siz_cd 대응 부재"** 차단. 정확한 사유.
5. **라이브 SELECT 교차:** 샘플 47 BLOCKED 상품 중 size 적재 0건 확인 → "plate만 적재, size 누락" 라이브 사실 일치. WxH 보유 8상품(사각손거울 등)은 이미 기적재.

→ **설계자는 headline BLOCKER를 회피(dodge)하지 않았다.** 과업 지시("L1에서 재단치수 적재")의 전제(L1에 재단치수 존재)가 **원천에서 거짓**임을 정직하게 규명했다. plate 복제·siz_cd 발명을 거부한 것은 정당. **UPHELD(BLOCKED-LEGIT).**

- **단, remediation 문서(G-GP-2)의 "size 77상품 → 다행 적재" 낙관은 정정됨이 옳다** — 설계자 load-spec §1이 이 낙관을 명시 반박(WxH 8 기적재·비치수 47 마스터 부재). 검증자도 동의.
- **잔여(D-1, 후니 영역):** 47상품 비치수 라벨을 ⓐ마스터 siz_cd 신설 ⓑ`nonspec_*` 인코딩 중 무엇으로 풀지 = 후니 컨펌. 우리측 발명 불가. **이 시트의 진짜 BLOCKER는 "적재 누락"이 아니라 "비치수 사이즈 마스터 모델링 미정"** — 정확.

### 3-B. goods-pouch 폰케이스 5 비활성 — **UPHELD**

- **GUARD-phonecase=0 라이브 검증:** 어떤 load CSV에도 폰케이스/미등록 prd_cd 0건(qtyunit 98이 PRD_183~280만, unmatched 5는 prd_cd 부재로 자동 제외).
- **C-1 비활성 정당:** L1 unmatched 5 = 버즈/블랙젤리/슬림하드/에어팟/임팩트(전부 회색배경 FFD9D9D9). `phonecase_inactive_record.csv`에 기록만(신규 INSERT 0). hidden MISSING 아님 — 미등록 상품이라 size/material도 부재가 당연.

### 3-C. calendar 택일그룹 (H5 BLOCKER) — **PARTIAL(부분 해소) · MAJOR finding**

excl_link 4 UPDATE가 멤버 process의 excl_grp_cd를 GRP-CAL-가공에 연결. **완전 연결인지 부분인지가 판정.**

**택일그룹별 연결 후 멤버 수(라이브 + flag 교차):**

| prd_cd | L1 택일 후보(remediation ②) | 연결된 멤버(load) | 미연결(flag) | 연결 후 그룹 멤버수 |
|--------|---------------------------|------------------|-------------|:------------------:|
| 110 엽서 | 가공없음 / 우드거치대 / 1구타공+끈 | PROC_000079(타공) | 가공없음·우드거치대 | **1** ⚠ |
| 111 벽걸이 | 고리형트윈링 / 가공없음 / 2구타공+끈 | PROC_000021·PROC_000079 | 가공없음 | **2** |
| 112 와이드 | 고리형트윈링 / 제본없음 | PROC_000021 | 제본없음 | **1** ⚠ |
| 108 탁상형 | 삼각대(그레이) 단일 | (excl 헤더 0행) | 삼각대 | **0**(헤더 부재) |
| 109 미니탁상 | 삼각대(블랙) 단일 | (excl 헤더 0행) | 삼각대 | **0**(헤더 부재) |

**판정 — PARTIAL(MAJOR):**
- **110·112는 SEL_TYPE.01(max_sel_cnt=1) 택일그룹에 멤버가 1개만 연결** → 의미상 "택일"이 성립 안 함(선택지 1개인 택일은 빈 택일과 동치). 위젯 택일 UI가 단일 옵션만 노출 = H5 BLOCKER가 **명목상 연결됐으나 기능상 미완**.
- **미연결 멤버 6종(flag)이 "발명 금지"로 합리적으로 보류된 것은 정당**(가공없음/제본없음=master proc_cd 부재, 우드거치대=addon 단일축, 삼각대=거치대 addon 후보). 추정 proc 신설을 강제하지 않은 판단은 옳다.
- **그러나 결과적으로 택일그룹은 "헤더+1멤버"인 채로 남아 H5가 부분만 해소.** load-spec은 이를 정직하게 flag·deferred·CONFIRM(Q-1·Q-2)로 노출 → **은폐는 아님**. 단 "BLOCKER 해소"로 보고하면 과장 → 본 검증은 **PARTIAL**로 명시.
- **선결 컨펌(Q-1):** "가공없음/제본없음" = 신규 proc_cd 부여인가 UI "선택안함"(proc 없이)인가. 이게 풀려야 110/112 택일이 ≥2 멤버로 완성. **택일 H5는 컨펌 전 미완** — 적재해도 위젯 택일 불완전.

### 3-D. design-calendar editor_yn — **UPHELD (110만 MINOR)**

- **신규행 0 라이브 검증:** editor_yn/qtyunit/material/link 전 prd_cd ⊆ {108~112} 확인(가드 PASS). 별도 디자인캘린더 상품 미신설. **C-5 정합.**
- **108/109/111/112 editor_yn=Y 정당:** design-calendar L1 디자인보유=● 직접 확인. 라이브 현행 N→Y UPDATE.
- **110 모호(MINOR):** L1 110은 가격=4000 보유(디자인캘린더 시트 멤버)이나 디자인보유 셀 **공란** → 설계자 N 유지+flag. 셀 충실 판독상 정당(임의 Y 단정=발명). **단 위젯에서 110이 디자인캘린더로 노출 안 됨** → Q-3 컨펌 필요. 적재 차단은 아님(현행 유지 no-op).

---

## 4. 라이브 중복-PK / UPDATE-타깃 위험 (라이브 SELECT 1회 배치)

검증자 라이브 SELECT(읽기전용, 2026-06-05) 직접 확인:

### 4-A. **[MAJOR · 적재 차단] calendar material MAT_000107 라이브 중복충돌 4행**

```
라이브 t_prd_product_materials (108~112):
  PRD_000108 = MAT_000107, MAT_000252, MAT_000253
  PRD_000109 = MAT_000107, MAT_000253, MAT_000254
  PRD_000110 = MAT_000107
  PRD_000111 = MAT_000107, MAT_000253
  PRD_000112 = MAT_000093, MAT_000111, MAT_000112, MAT_000253
```

- **MAT_000107(몽블랑 190g)이 108·109·110·111에 이미 라이브 적재.** 그런데 load CSV `t_prd_product_materials.csv`도 **동일 4행을 INSERT**(IMPORT 47에 몽블랑190g 포함: 108행3·109행2·110행3·111행13).
- **충돌 INSERT 4행(전부 dup PK on (prd_cd, MAT_000107, USAGE.07)):**
  `(PRD_000108,MAT_000107)`·`(PRD_000109,MAT_000107)`·`(PRD_000110,MAT_000107)`·`(PRD_000111,MAT_000107)`.
- **근본 원인 = stale-vs-live 격차(Wave A 공통 결함의 실체화):** stale ref(2026-06-04)엔 MAT_000107 미적재 → 게이트가 `existing_mat`에서 빠뜨려 **47 전부를 신규로 과대기대(over-expect)**. 라이브엔 몽블랑190g(design-calendar 직접명 종이)가 그 사이 적재됨. **게이트는 stale라 이 충돌을 구조적으로 검출 불가**(설계자 §8 stale 주의가 정확히 예견한 지점).
- **조치:** 적재 전 ⓐ 4행 DROP(43행 적재) 또는 ⓑ load-spec §8대로 **라이브 export로 verify_expected.py 재실행** 후 충돌행 자동 제거. **현 CSV 그대로 적재 시 4행 INSERT 실패 → NO-GO.**

### 4-B. UPDATE-타깃 위험 — **0 (전부 실재 기존행)**

| UPDATE | 라이브 타깃 상태 | 위험 |
|--------|----------------|:----:|
| cal excl_link 4행 | 110/79·111/21·111/79·112/21 실재·excl_grp_cd=NULL | **0** |
| cal editor_yn 4행 | 108~112 editor_yn=N(전건) | **0** |
| cal qtyunit 5행 | 108~112 qty_unit=NULL(전건) | **0** |
| gp qtyunit 98행 | (글로벌 NULL, round-3 일관) | **0** |
| gp addon 217 1행 | 217 addon=0행(라이브 확인) | **0(충돌 0)** |

→ UPDATE/INSERT 타깃은 material 4행 외 **전부 무충돌**. (note_update 1행도 헤더 실재.)

---

## 5. 적재 전 필수 해소 항목 (must-resolve-before-load)

| 우선 | 시트 | 항목 | 사유 / 조치 |
|:----:|------|------|------------|
| **BLOCKER** | calendar | material MAT_000107 충돌 4행 | 라이브 기적재(몽블랑190g 108/109/110/111). **4행 DROP 또는 라이브-export 게이트 재실행 후 적재.** 미해소 시 INSERT 실패 |
| **HARD** | both | 적재 직전 `verify_expected.py`를 **라이브 export 기반**으로 1회 재실행 | 게이트가 stale ref에서 기적재·use_yn 판독 → §4-A 충돌이 그 산물. stale 격차 닫기(검증 권위=라이브) |
| **MAJOR** | calendar | 택일 H5 부분해소(110·112 단일멤버) | Q-1 컨펌(가공없음/제본없음=신규 proc vs UI 선택안함) 전엔 택일 ≥2멤버 미완 → 위젯 택일 불완전. **"H5 해소"로 종결 금지** |
| High | calendar | Q-2: 108/109 excl_group 헤더 0행 | 삼각대 단일가공=택일 불요인지 GRP-CAL-가공 신설인지. 라이브 헤더 0행 확정 |
| Med | design-cal | Q-3: 110 editor_yn 모호 | 디자인보유 셀 공란·가격 존재 → Y/N 컨펌(현 no-op 정당) |
| Med | goods-pouch | D-1: size 비치수 47 마스터 모델링 | 후니 영역(siz_cd 신설 vs nonspec). 우리측 발명 불가 — BLOCKED 유지 정당 |
| Low | calendar | page_rule/링칼라 deferred 12행 | G-CL-5/G-DC-4 CONFIRM 유지(발명 금지). 적재 무영향 |

---

## 6. 검증자 종합 의견

- **goods-pouch:** size BLOCKED는 **정당 차단(dodge 아님)** — L1 `파일사양_재단사이즈` 전 상품 공란을 원천 직접 확인했고, 비치수 라벨을 plate 복제·siz_cd 발명으로 메우길 거부한 판단이 옳다. 폰케이스5·deferred 처리도 라이브 정합. addon 1·qtyunit 98 적재성 통과. **GO-WITH-FINDINGS(D-1은 후니 컨펌).**
- **calendar:** 두 가지가 발목을 잡는다. ① **material 4행 라이브 PK충돌**(MAJOR/적재차단) — 게이트가 stale라 놓친 실결함을 라이브 SELECT로 적발. ② **택일 H5 부분해소**(110/112 단일멤버) — 명목 연결됐으나 기능상 미완(컨펌 선결). UPDATE 타깃·editor_yn·qtyunit은 전부 정당. **material 충돌 해소 + 택일 컨펌 전 NO-GO.**
- **stale 한계가 본 Wave의 핵심 리스크였고, calendar에서 실제 충돌로 터졌다.** "적재 직전 라이브-export 게이트 재실행"은 권고가 아니라 **HARD 필수**다(goods-pouch는 통과하겠지만 calendar material 4행을 반드시 걸러내야 함).
- **날조·부당강등 0:** 양 시트 모두 발명 금지·flag·deferred로 미확정을 정직하게 노출했다. 결함은 "처리 누락"이 아니라 "stale 충돌(calendar)·택일 컨펌 미완(calendar)·마스터 모델링 미정(goods-pouch)"이며 전부 정확히 분류됨.

---

## 부록 — 라이브 SELECT 수행 목록 (1회 배치, 전부 read-only · DB 무변경)

1. calendar 108~112 t_prd_product_materials(MAT_000107 충돌 적발) 2. 110/111/112 process excl_grp_cd/mand(UPDATE 타깃 NULL 확인)
3. 108~112 excl_group 헤더(110/111/112 GRP-CAL-가공, 108/109 부재) 4. 108~112 editor_yn/qty_unit(전 N/NULL)
5. goods-pouch 217 addon(0행=충돌 0) 6. goods-pouch BLOCKED 47 샘플 size(0건=size 미적재 라이브 정합).

비밀값(password 등) stdout/파일 미노출 확인 완료.
