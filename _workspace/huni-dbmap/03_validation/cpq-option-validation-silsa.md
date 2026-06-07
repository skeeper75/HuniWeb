# CPQ 옵션 레이어(L2) 검증 — 일반현수막 PRD_000138 silsa 파일럿 (round-6)

> **검증자** `dbm-validator` (독립·적대적 — 본 옵션 레이어는 `dbm-option-mapper`가 설계, 검증은 분리가 곧 게이트)
> **작성** 2026-06-07 · round-6 CPQ L2 파일럿 #2(silsa). DB 미적재 · 자기 커밋 금지.
> **권위 순서:** Excel 명시값 > 추출 스냅샷(`ref-*.csv` — 존재 판정은 라이브 권위) · 라이브 스키마 + 트리거 `fn_chk_opt_item_ref` > 설계 문서 · `cpq-schema.md §4`(design↔live) wins.
> **검증 대상:** `silsa-option-layer.md` + `load_silsa/*.csv` 5종.
> **검증 방법:** 로컬 읽기전용 — `00_schema/ref-product-{processes,sets,sizes,materials}.csv`(라이브 차원 스냅샷) + `_live-schema-dump-260606.txt`(컬럼 ground truth) + `cpq-schema.md §2`(트리거 디스패치) + `code-values.md`. 라이브 롤백전용 DRY-RUN 미실행(리드 승인 필요 — §최종 권고).

---

## 종합 판정: **GO** (조건부 — INSERTABLE 25행 적재 가능, BLOCKED 3행 정확히 격리)

- **L2 핵심 검사(option_items ↔ 라이브 차원행 참조 해소)**: INSERTABLE 9행 전부 **트리거 통과 예정 확정** · BLOCKED 3행 전부 **트리거 REJECT 예정 확정**. over-block 0 · under-block 0.
- **PROC_000079/080/081 = PRD_000138 라이브 실재 확정**(ref-product-processes.csv 직접 대조).
- **PROC_000053 = PRD_000138 미적재 확정** · **각목 set = PRD_000138 sets 0행 + 각목 완제상품 부재 확정** → 3 BLOCKED 정당.
- 적재 차단(NO-GO)급 결함 **0건**. MAJOR 1건(열재단 dflt↔BLOCKED 모순, 설계 결정 필요·이미 D-2로 플래그됨), MINOR 3건(전부 정직 플래그 확인용·발명 아님). 모두 적재 전 인간 결정 큐로 라우팅.

---

## 경계면별 PASS/FAIL

### 경계 1 — option_items ↔ 라이브 차원행 참조 해소 (L2 load-bearing) — **PASS**

트리거 `fn_chk_opt_item_ref`의 디스패치(`cpq-schema §2`): `OPT_REF_DIM.04` → `t_prd_product_processes(proc_cd=ref_key1)` EXISTS for prd_cd. 본인 ref 룩업으로 9 INSERTABLE 전수 대조:

| opt_cd | ref_dim_cd | ref_key1 | 라이브 PRD_000138 차원행? | 트리거 | 판정 |
|---|---|---|---|---|:--:|
| OP-GAGONG-TAGONG4 | OPT_REF_DIM.04 | PROC_000079 | ✅ (ref-product-processes.csv 라인 실재) | PASS | INSERTABLE ✅ |
| OP-GAGONG-TAGONG6 | OPT_REF_DIM.04 | PROC_000079 | ✅ | PASS | INSERTABLE ✅ |
| OP-GAGONG-TAGONG8 | OPT_REF_DIM.04 | PROC_000079 | ✅ | PASS | INSERTABLE ✅ |
| OP-GAGONG-YANGMYEONTAPE | OPT_REF_DIM.04 | PROC_000081 | ✅ | PASS | INSERTABLE ✅ |
| OP-GAGONG-BONGMISING | OPT_REF_DIM.04 | PROC_000080 | ✅ | PASS | INSERTABLE ✅ |
| OP-CHUGA-QBANG4 | OPT_REF_DIM.04 | PROC_000081 | ✅ | PASS | INSERTABLE ✅ |
| OP-CHUGA-STRING4 | OPT_REF_DIM.04 | PROC_000081 | ✅ | PASS | INSERTABLE ✅ |
| OP-CHUGA-GAKMOK-LE900 seq1 | OPT_REF_DIM.04 | PROC_000081 | ✅ | PASS | INSERTABLE ✅ |
| OP-CHUGA-GAKMOK-GT900 seq1 | OPT_REF_DIM.04 | PROC_000081 | ✅ | PASS | INSERTABLE ✅ |

**라이브 권위 인용(내 직접 룩업):** `ref-product-processes.csv` PRD_000138 행 = 정확히 3행 `PROC_000079 / PROC_000080 / PROC_000081`(전부 mand_proc_yn=N, excl_grp_cd 공백). 다른 proc_cd 0행. → 9 INSERTABLE 전부 079/080/081만 참조하므로 트리거 통과 확정. **under-block 0**(INSERTABLE 중 해소 불가행 없음).

**디스패치 슬롯 정확성:** 공정 = `ref_key1=proc_cd`, `ref_key2` 미사용(CSV 공란) — 트리거 디스패치(`cpq-schema §2`)와 정확 일치. 도수(opt_id)·자재(usage_cd=ref_key2) 같은 슬롯 오용 **없음**(현수막은 도수·자재 옵션 미보유라 해당 슬롯 미사용 — 정합).

---

### 경계 1b — BLOCKED 정직성 (핵심 적대 검사: over-block / under-block) — **PASS**

BLOCKED 3행이 정말로 트리거 REJECT 대상인지 내 ref 룩업으로 독립 확인:

| BLOCKED 행 | ref_dim_cd | ref_key1 | 내 라이브 룩업 결과 | BLOCKED 정당? |
|---|---|---|---|:--:|
| OP-GAGONG-YEOLJAEDAN seq1 (열재단) | OPT_REF_DIM.04 | PROC_000053 | **PRD_000138 processes = 079/080/081만 (053 부재)**. 053은 PRD_000055/056/057...에만 존재 | ✅ 정당 (REJECT 확정) |
| OP-CHUGA-GAKMOK-LE900 seq2 (각목) | OPT_REF_DIM.07 | `[CONFIRM]` | **PRD_000138 sets = 0행**(grep no-match) + 각목 완제상품 ref-products **0행**(grep no-match) | ✅ 정당 (sub_prd_cd 미상·REJECT 확정) |
| OP-CHUGA-GAKMOK-GT900 seq2 (각목) | OPT_REF_DIM.07 | `[CONFIRM]` | 상동 | ✅ 정당 |

- **over-block 검사**: 위 3행은 차원행이 실제 부재 → BLOCKED은 과차단 아님. 특히 열재단은 dflt이지만 053 부재라 적재 불가가 맞다(트리거 REJECT). 각목 set은 sub_prd_cd 자체가 미상(`[CONFIRM]`)이라 적재 불가 + (참고) `[CONFIRM]` 리터럴은 ref_key1 NOT NULL 제약은 통과하나(빈 문자열 아님) 트리거 REJECT는 확정 — 이중으로 적재 불가. **분리 CSV로 격리한 것이 정확**.
- **under-block 검사**: 경계 1에서 확인 — INSERTABLE 9행 전부 079/080/081로 해소되므로, 실제론 BLOCKED여야 하는데 INSERTABLE로 잘못 분류된 행 **0건**.

**증거 인용:** `grep "PRD_000138" ref-product-sets.csv` → exit 1(0행). `grep "각목" ref-products.csv` → exit 1(상품명에 각목 없음). `grep "PROC_000053" ref-product-processes.csv` → PRD_000055~ 만, PRD_000138 부재.

---

### 경계 2 — 복합옵션 각목+끈 = 2 option_items (polymorphic 이종 차원 결합) — **PASS**

| 옵션 | seq1 (끈) | seq2 (각목) |
|---|---|---|
| OP-CHUGA-GAKMOK-LE900 | `OPT_REF_DIM.04` PROC_000081 (부착·끈) qty=4 — **INSERTABLE** | `OPT_REF_DIM.07` set `[CONFIRM]` qty=1 — **BLOCKED** |
| OP-CHUGA-GAKMOK-GT900 | `OPT_REF_DIM.04` PROC_000081 qty=4 — **INSERTABLE** | `OPT_REF_DIM.07` set `[CONFIRM]` qty=1 — **BLOCKED** |

- 한 옵션 안에 **process(.04) + set(.07) 이종 차원 공존** = polymorphic ref_dim_cd가 typed FK로 불가능한 결합을 자연 표현 — 디스패치 양 슬롯 정확(끈=공정 부착, 각목=셋트). **검증 PASS**.
- `끈` ∈ 부착(081) `대상` enum(`라벨/맥세이프/끈/테입`)이 ref-processes.csv에 실재 → seq1 끈 환원 근거 정합.
- 각목 = process 부착 enum에 부재(끈/테입/라벨/맥세이프만) → set/addon 성격 판정 합리. set vs addon은 설계 결정(D-4, 본 파일럿 set 1차 권고).

---

### 경계 3 — attribute-entity-map 완전성 / silsa verdict 정합 — **PASS**

`attribute-entity-map.md` 패밀리 ③(라인 114~132, 권위 워크스루=banner) verdict와 파일럿 1:1 대조:

| master map verdict | 파일럿 적용 | 정합 |
|---|---|:--:|
| 가공 = L2 택일그룹 OG-GAGONG 01 mand (079/080/081/053) | OG-GAGONG SEL_TYPE.01 min=max=1 mand=Y | ✅ |
| 타공 4/6/8 = 공정 1행(079) + param{구수:N} GAP-PARAM | 동일 PROC_000079 3옵션 재사용·qty=1·param 미보존 GAP-PARAM | ✅ |
| 추가 끈/큐방/각목 = L2 복합옵션 (끈/큐방=부착081 + 각목=set) | OG-CHUGA, 끈/큐방=081, 각목=set seq2 | ✅ |
| R-GAKMOK-HEIGHT(각목규격↔세로) constraint | R-GAKMOK-HEIGHT RULE_TYPE.02 | ✅ |
| 열재단→053 미적재 GAP-DEFER | BLOCKED + D-2 플래그 | ✅ |
| 비규격 사이즈 = products 범위 + constraint(option_items 열거 불가) | 사이즈 그룹 미생성·R-SIZE-NONSPEC constraint | ✅ |
| 별색/코팅 = 일반현수막 미보유 | OG 미생성 (banner §1.2 "코팅 미보유 확정", L1 공백) | ✅ |

- **모순 0건.** 별색·코팅 false 옵션 인스턴스화 없음(banner §1.2/§1.3 권위 — 코팅은 PET배너·미니배너에만, 일반현수막 공백). 거치대 add-on은 사용자 캐스케이드 부재라 미인스턴스화(R6 scope discipline) — master map 라인 128 거치대 행이 있으나 일반현수막 L1엔 거치대 없으므로 미행사가 정확.

---

### 경계 4 — option layer ↔ 라이브 CPQ 스키마 (type/length·NOT NULL·FK·PK·load order) — **PASS**

**`_live-schema-dump-260606.txt` 컬럼 ground truth 대조:**

| 테이블 | CSV 헤더 | 라이브 컬럼(NOT NULL) | 판정 |
|---|---|---|:--:|
| option_groups | prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,min_sel_cnt,max_sel_cnt,mand_yn,disp_seq,use_yn,**note** | note vc(500) **실재** · 누락 NOT NULL컬럼 없음(del_yn/reg_dt DEFAULT) | ✅ |
| options | ...,dflt_yn,disp_seq,use_yn,**note** | note vc(500) **실재** | ✅ |
| option_items | prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn | **note 부재 · ref_param_json 부재** (라이브와 정확 일치) | ✅ |
| constraints | prd_cd,rule_cd,rule_nm,rule_typ_cd,logic,err_msg,disp_seq,use_yn | logic jsonb NN · reg_dt/del_yn DEFAULT(omit OK) | ✅ |

- **F-1 재확인 (핵심 lesson):** `option_items.csv`에 **`note` 컬럼 없음** = 라이브 부재와 일치 (round-6 교훈 적용 확인 ✅). 동시에 **`note`는 option_groups/options에 라이브 실재**(varchar 500) — 파일럿이 그 두 곳에 note 유지한 것은 **발명 아님, 라이브 정합** ✅ (라이브 dump 라인 172·196 직접 확인).
- **`ref_param_json` 라이브 부재 확정** — option_items에 없음(dump 라인 175~182). 파일럿이 구수/규격 param을 GAP-PARAM으로 분리한 것이 정확(R3) ✅.
- **NOT NULL:** INSERTABLE 9행 전부 ref_key1(NOT NULL) 실값 보유(PROC_000079/080/081). sel_typ_cd·opt_grp_cd 실값. BLOCKED의 `[CONFIRM]` ref_key1은 분리 CSV에 격리 — 적재 CSV에 미포함 ✅.
- **FK:** opt_grp_cd→option_groups(CSV 내 OG-GAGONG/OG-CHUGA 2그룹 ↔ options 11행 전부 그 2그룹 참조, 고아 0) · sel_typ_cd→t_cod_base_codes(SEL_TYPE.01 — GRP-BOOK 라이브 선례 동일 풀코드 형식) · ref_dim_cd→t_cod_base_codes(OPT_REF_DIM.04/.07) · rule_typ_cd→t_cod_base_codes(RULE_TYPE.01/.02/.03) — 코드값 전부 `cpq-schema §3`·`code-values.md` 실재 ✅.
- **PK 유일성(CSV 내):** option_groups PK(prd_cd,opt_grp_cd)=2 유일 · options PK(prd_cd,opt_cd)=11 유일 · option_items PK(prd_cd,opt_cd,item_seq) — 9행 전부 item_seq=1, opt_cd 유일 → 복합키 충돌 0 · constraints PK(prd_cd,rule_cd)=3 유일. **중복 0** ✅.
- **load order:** §8 위상정렬 = 차원행(L1, 079/080/081 적재됨) → groups → options → option_items(트리거 행단위) → constraints → constraint_json UPDATE. FK·트리거 의존 만족 ✅.

---

### 경계 5 — constraints ↔ JSONLogic 의미 — **PASS**

3 rule 전부 valid JSONLogic 문법(CSV의 `""` 이스케이프 정상 — jsonb 파싱 가능). 손계산 재현:

**R-GAKMOK-HEIGHT (RULE_TYPE.02 금지)** — 내 독립 손평가:
- 각목900이하 + height=900 → `{"<=":[900,900]}=true`, GT900절=true(chuga≠GT900) → **PASS** ✅ (의도: 900이하 OK)
- 각목900이하 + height=1200 → `{"<=":[1200,900]}=false` → AND **FAIL** ✅ (의도: 900이하인데 세로 초과 → 차단)
- 각목900초과 + height=1200 → LE900절=true(chuga≠LE900), `{">":[1200,900]}=true` → **PASS** ✅
- 각목900초과 + height=900 → `{">":[900,900]}=false` → **FAIL** ✅ (의도: 초과 선택인데 세로 900 → 차단)

**R-SIZE-NONSPEC (RULE_TYPE.01 호환)** — 내 독립 손평가:
- size_mode≠nonspec(규격) → `or` 첫 항 `{"!=":["spec","nonspec"]}=true` → **PASS**(규격 무조건 통과) ✅
- nonspec width=1500 height=900 → 1500∈[500,1750]·900∈[500,5000] 전부 true → **PASS** ✅
- nonspec width=4000 → `{"<=":[4000,1750]}=false` → **FAIL**(가로 상한 위반) ✅

**R-BONGJE-PARAM (RULE_TYPE.03 필수동반)**: gagong=봉미싱 → width·height>0 강제, 아니면 true. valid ✅.

- **compiled constraint_json = 3 active rule AND 결합** (§5 마지막 블록) — 내가 재구성한 AND와 일치 ✅. rule on/off 시 재compile 규약 정합.
- 파일럿 §5 검증표(6 케이스)와 내 독립 손평가 **전건 일치**. 의도(입력 유효성, 최종 가격유효성=가격엔진) 정합.

---

### 경계 6 — GAP 정직성 (smear / 발명 검사) — **PASS**

| GAP/플래그 | 검증 | 판정 |
|---|---|:--:|
| **GAP-PARAM (타공 구수 4/6/8)** | 타공 3옵션 전부 qty=**1**(소비량), 구수는 qty에 **미주입**. 동일 PROC_000079 재사용·복제 행 없음(마스터 오염 회피). ref_param_json 라이브 부재라 구수 보존 불가 — 정직 플래그 | ✅ smear 0 |
| **qty 의미 일관성** | 가공(079/080/081 적용=1회) qty=1 / 추가(큐방·끈·각목 = N개 물리 부착물) qty=4 — 의미 구분 일관(구수≠qty) | ✅ |
| **각목 set `[CONFIRM]`** | sub_prd_cd 미상 → 발명 금지 `[CONFIRM]`, BLOCKED 격리. 임의 코드 날조 없음 | ✅ |
| **열재단 PROC_053 `[CONFIRM]`** | 053→열재단은 도메인 해석(엑셀 명시 아님)이라 `[CONFIRM]`, BLOCKED | ✅ |
| **큐방 enum `[CONFIRM]`** | 부착 enum(라벨/맥세이프/끈/테입)에 큐방 부재 → `[CONFIRM]`(item은 081 EXISTS라 INSERTABLE이나 param 미검사). 정직 | ✅ |
| **양면테입→{대상:테입} `[CONFIRM]`** | L1 `양면테입`≠enum `테입` → `[CONFIRM]`(validation GAP-4 비대칭 보정 적용) | ✅ |

- **GAP를 qty/note에 smear한 흔적 0건.** 모든 미상 코드는 `[CONFIRM]`으로 노출 + BLOCKED 분리. `dbm-ddl-proposer`(ref_param_json·각목 set·053 차원) 라우팅 대상으로 §10 D-1~D-5에 정직 등재.

---

## 적재 가능성 집계 (내 독립 ref 룩업으로 교차확인 — 파일럿 자기보고 미신뢰)

| 테이블 | 총 | INSERTABLE | BLOCKED | GAP | 내 확인 |
|---|:--:|:--:|:--:|:--:|---|
| option_groups | 2 | 2 | 0 | 0 | 트리거 없음·PK유일·FK정합 |
| options | 11 | 11 | 0 | 0 | 트리거 없음·11행 2그룹 참조 고아0 |
| option_items (적재) | 9 | 9 | 0 | (3 param GAP) | 079/080/081 전수 라이브 실재 — under-block 0 |
| option_items (분리 BLOCKED) | 3 | 0 | 3 | — | 053부재·각목set 0행 — over-block 0 |
| constraints | 3 | 3 | 0 | 0 | JSONLogic 손평가 PASS |
| **합계** | **28** | **25** | **3** | — | 적재 CSV=25행 + constraint_json UPDATE 1건 |

옵션 값 기준: **가공 6 = 5 INSERTABLE + 1 BLOCKED(열재단)** / **추가 5 = option 5 INSERTABLE, item 6 INSERTABLE(끈/큐방/각목LE끈/각목GT끈 seq1) + 2 BLOCKED(각목 seq2 ×2)**. — 파일럿 자기보고와 내 룩업 **일치**.

---

## Findings (severity + 라우팅)

### MAJOR

- **M-1 (라우팅: `dbm-option-mapper` + 리드 결정 D-2)** — 열재단(OP-GAGONG-YEOLJAEDAN)이 **dflt_yn=Y(기본 가공)인데 그 item은 BLOCKED**(PROC_000053 미적재). 즉 OG-GAGONG은 mand_yn=Y(필수)이고 기본 선택값의 차원행이 적재 불가 → 적재 시점에 "필수 그룹의 기본값이 참조 해소 불가"라는 의미적 모순.
  - 증거: `load_silsa/t_prd_product_options.csv` 라인2(dflt=Y) ↔ `..._BLOCKED.csv` 라인2(053 REJECT). `ref-product-processes.csv` PRD_000138=079/080/081만.
  - 이것은 **적재 차단 결함은 아니다**(option/group 레벨엔 트리거 없어 11/2행은 적재됨; item만 분리). 그러나 옵션 그룹을 적재하고 기본값 item을 못 넣으면 런타임에 기본 선택이 깨진다.
  - 제안 수정: ① PROC_000053을 PRD_000138에 선적재(정석) **또는** ② "열재단=기본재단(가공없음 센티넬, item 0행)" 규약으로 재정의 — 이 경우 dflt 옵션은 item 불요라 모순 해소. **파일럿이 이미 D-2 GAP-DEFER로 정직 플래그함** — 본 finding은 그 결정을 리드 큐로 승격(적재 전 결정 필수). 침묵 적재 금지.

### MINOR (전부 정직 플래그 확인 — 결함 아닌 결정대기)

- **m-1 (`dbm-ddl-proposer`)** — `ref_param_json` 라이브 부재로 타공 구수(4/6/8)·각목 규격(900이하/초과) param 보존 불가(GAP-PARAM). 파일럿이 qty smear 없이 정직 분리. DDL 제안 대상(round-5 비치수 size·박 2단룩업과 같은 줄). 적재 자체는 가능(param 없이도 INSERTABLE).
- **m-2 (`dbm-option-mapper` + 리드)** — 각목 set `[CONFIRM]` sub_prd_cd: 각목 완제상품 미등록. 해소=각목 상품 PRD 신규등록 + t_prd_product_sets 적재(인간 승인). 복합옵션 seq2 2행 직결. 정직 BLOCKED.
- **m-3 (`dbm-option-mapper`)** — 큐방 enum 확장 / 양면테입→테입 매핑 `[CONFIRM]`: 둘 다 ref_key1=081 EXISTS라 item은 INSERTABLE(트리거는 proc_cd만 검사, param 미검사). param 의미는 enum 확장/도메인 해석 결정 필요 — 적재 비차단.

### 검증 중 점검했으나 **결함 아님**(적대 검사 통과 항목)

- note 컬럼: option_groups/options 라이브 실재 확인(dump 라인 172/196) → 파일럿 유지가 정합. option_items엔 미사용 확인 → F-1 lesson 적용 정확. **발명 아님**.
- SEL_TYPE.01 풀코드 형식: GRP-BOOK 라이브 선례(SEL_TYPE.01 max=1)와 동일 → 정합. 텍스트 'single' 미사용.
- ref_dim_cd 코드 FK(.04/.07): banner-walkthrough/master map은 텍스트 'process'/'set'였으나 파일럿이 라이브 코드 FK로 정정(R1) → `cpq-schema §2` 정합.

---

## 최종 권고 (다음 단계)

1. **로컬 검증 GO** — 적재 CSV 25행은 라이브 스키마·트리거·FK·PK·JSONLogic 전 경계 PASS. 적재 가능성 증명됨(로컬 권위).
2. **라이브 롤백전용 DRY-RUN 권고(리드 승인 필요)** — 트리거 `fn_chk_opt_item_ref`를 실제 발화시켜 9 INSERTABLE 통과 + (대조용) BLOCKED 3행 REJECT를 실증하는 것이 참조 해소의 최강 증명. `BEGIN … INSERT … ROLLBACK` — **NEVER COMMIT**. 본 검증은 스냅샷 기반이라 stale 가능성 0은 아니나, PRD_000138 processes 3행은 2026-06-03 dump로 안정적. DRY-RUN은 리드 승인 시에만.
3. **적재 전 인간 결정 큐:** M-1(열재단 dflt↔BLOCKED — 053 선적재 vs 센티넬 규약) · m-2(각목 상품+sets 등록) · m-1(ref_param_json DDL) · m-3(큐방 enum/양면테입 매핑). 전부 침묵 선택 금지.
4. **DB 미적재 유지** — 실 INSERT·코드행·DDL = 별도 인간 승인.
