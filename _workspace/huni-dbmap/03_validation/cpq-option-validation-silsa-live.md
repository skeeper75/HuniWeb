# silsa(PRD_000138) CPQ 옵션 레이어 라이브 정합 정정 — 독립 교차검증 (R6)

> **상태/이력** 작성 2026-06-08 · `dbm-validator` 산출 · round-6 연장(라이브 admin 정합 정정의 적대적 검증).
> **검증 대상:** `dbm-option-mapper`가 `live-admin-groundtruth.md`(라이브 admin UI 실측 ground-truth)를 권위로 정정한 silsa 옵션 레이어(`silsa-option-layer.md`·`silsa-live-reconciliation.md`·`load_silsa/*.csv`).
> **권위 순서:** 라이브 admin UI 실측(later) > cpq-schema 추출(earlier) > 설계 문서. 차원행 존재 판정 = `00_schema/ref-product-*.csv` 스냅샷 + 트리거 `fn_chk_opt_item_ref`.
> **방법:** 생성-검증 분리(R6) — validator는 설계자 아님. 읽기전용 대조만(DB 쓰기·COMMIT 없음). 식별자/테이블/컬럼/코드/SQL/JSONLogic = English, 설명 = Korean.
> **최종 판정:** **CONDITIONAL-GO** (V-4 BLOCKER F-silsa-1 해소 시 GO).

---

## 0. 한 줄 요약

핵심 매핑 정정(V-1 var 키·V-2 GAP 분리·V-3 트리거 reference resolution·V-5 미적재 정직성)은 **전건 PASS** — 라이브 표준 var 정합, GAP 분리 손계산 정당, option_items 9 INSERTABLE 전건 차원행 EXISTS, 발명 0. 생성-검증 분리로 **실결함 1건(F-silsa-1, BLOCKER) 독립 적발**: constraints GAP CSV가 라이브 적재 경로에서 미격리(데이터 결함 아닌 적재 경로 안전성 결함). 부수로 cpq-schema↔ground-truth 권위 충돌 1건(MINOR) 노출. F-silsa-1만 mapper가 해소하면 **22행 적재 GO**.

---

## 1. V-1~V-5 판정 + 핵심 증거

| 경계 | 판정 | 핵심 증거(한 줄) |
|---|:--:|---|
| **V-1** LV-1 var 키 정합 | **PASS** | 비표준 var(`size_mode/width/height/gagong/chuga`)는 `constraints.csv`의 `logic_target_spec`(status=GAP, 라이브 미적재)에만 존재. 적재 경로(items 9행) 전건 `ref_key1=proc_cd` — 표준 var `.04` 슬롯 정합. 라이브 적재 경로 비표준 var **0건** |
| **V-2** LV-2 GAP over/under-claim | **PASS** | 손계산: R-GAKMOK 조건측 `chuga`=opt_cd(차원 코드 아님), set 환원 시 sub_prd_cd 미상(sets 0행) → 조건측조차 표준 var 불가 + 결과측 `height` 수치 부재 = 이중 불가. R-BONGJE 조건측만 `proc_cd` 부분환원이나 결과측 수치라 규칙 전체 미완. under-claim·over-GAP **0** |
| **V-3** 트리거 reference resolution | **PASS** | items 9 INSERTABLE 전건 `OPT_REF_DIM.04`/`ref_key1`∈{PROC_000079,080,081}, `ref-product-processes.csv` PRD_000138 3행 전건 EXISTS → 트리거 통과. BLOCKED 3행(열재단 PROC_000084 부재·각목 set 0행) REJECT 확정 → 분리 정당. over/under-block **0** |
| **V-4** 라이브 컬럼 정합(F-1) | **FAIL** | `constraints.csv`가 라이브 컬럼 `logic`(jsonb NOT NULL)을 `logic_target_spec`으로 개명 + 비라이브 컬럼(`status·gap_reason·disp_seq`) 추가. GAP 보존용이나 정식 테이블명 그대로라 적재 glob 격리 안 됨 → 적재 시 `logic` NOT NULL 위반 즉시 실패 위험 |
| **V-5** 미적재·GAP 정직성 | **PASS** | L2 전 상품 0행 = 5상품(현수막·중철책자·엽서북·프리미엄엽서/명함) 교차 캡처 실측. 비치수 범위 GAP·ref_param_json GAP 발명 0(qty smear 금지 명시), 3후보 도메인/ddl-proposer 정직 라우팅 |

### V-1 상세 (var 키 정합)
- `t_prd_product_option_groups.csv`: `sel_typ_cd=SEL_TYPE.01` — 라이브 SEL_TYPE 코드값 정합.
- `t_prd_product_option_items.csv`(9 INSERTABLE): 전행 `ref_dim_cd=OPT_REF_DIM.04`·`ref_key1`=proc_cd(PROC_000079/080/081)·`ref_key2` 공백 — 표준 var `proc_cd`(.04) 슬롯 정확 일치.
- 비표준 var는 `constraints.csv`의 `logic_target_spec` 컬럼(status=GAP·load order [4] "live 적재 0행")에만 잔존 → 라이브 적재 경로 위반 0건.

### V-2 상세 (GAP 손계산 — under-claim 의혹 직접 반증)
- **R-BONGJE-PARAM**: 조건측 `gagong=봉미싱` → option_item이 `proc_cd=PROC_000080` 참조 → `{"==":[{"var":"proc_cd"},"PROC_000080"]}` *부분* 환원 가능. 결과측 `width>0 AND height>0`은 연속 수치 → 표준 var 부재 → 완결 규칙 불가 → GAP 정당.
- **R-GAKMOK-HEIGHT** (질문 지목): 조건측 `chuga=OP-CHUGA-GAKMOK-LE900/GT900`은 **opt_cd**(옵션 선택 정체성)이지 차원 코드 아님. set 환원 시 `sub_prd_cd`이나 `ref-product-sets.csv` PRD_000138 0행 → 코드 미상(BLOCKED). 결과측 `height` 수치 → 이중 불가 → GAP 정당. "각목 opt_cd↔세로"를 차원-코드 2항으로 환원 가능한 조각 없음.
- **R-SIZE-NONSPEC**: 순수 연속 수치 + 모드 플래그 → 표준 var 모델 밖.

### V-3 상세 (트리거 디스패치 — 라이브 스냅샷 대조)
- 트리거 `fn_chk_opt_item_ref` `OPT_REF_DIM.04` → `t_prd_product_processes(proc_cd=ref_key1)` EXISTS 검사.
- `ref-product-processes.csv` 실측: `PRD_000138,PROC_000079`·`PROC_000080`·`PROC_000081` 3행 EXISTS → 9 INSERTABLE 통과.
- BLOCKED: 열재단(PROC_000084 부재) REJECT·각목 seq2 ×2(`OPT_REF_DIM.07` sets 0행) REJECT → 분리 정당. 복합옵션 끈 seq1(081 EXISTS)은 INSERTABLE로 정확 분리(polymorphic 이종 2행 중 통과분만 적재).

---

## 2. 발견 결함 + 라우팅

| ID | 심각도 | 결함 | 증거 | 라우팅 |
|----|:--:|------|------|--------|
| **F-silsa-1** | **BLOCKER** | `load_silsa/t_prd_product_constraints.csv`가 라이브 컬럼 `logic`(jsonb NOT NULL)을 `logic_target_spec`으로 개명 + 비라이브 컬럼(`status·gap_reason·disp_seq`) 추가. GAP 보존용(적재 0행)이나 정식 테이블명 `t_prd_product_constraints.csv` 그대로라 적재 경로 glob에 잡히면 `logic_target_spec` 부재 + `logic` NOT NULL 위반으로 즉시 실패. BLOCKED items는 `_BLOCKED.csv`로 분리했으면서 GAP constraints는 미분리(비대칭) | cpq-schema §1 라이브 컬럼 = `logic jsonb NN` ↔ CSV 헤더 `logic_target_spec`. round-6 F-1 교훈 "적재 CSV=라이브 컬럼만, GAP은 별도 분리"의 문자 위반 | **dbm-option-mapper**(설계) — 권고: `t_prd_product_constraints_GAP.csv`로 개명(items `_BLOCKED.csv`와 일관) 또는 별 디렉터리 격리. 데이터 무손상, 적재 경로 안전성만 수정 |
| **F-silsa-2** | MINOR | 권위 충돌: cpq-schema §1/§5는 `option_groups 13행 적재`(GRP-BOOK 10+GRP-CAL 3)라 기술하나 ground-truth(라이브 admin UI 직접 캡처, later)는 전 상품 0행. mapper는 LV-3 §4 `[HARD]`로 ground-truth 권위 하향 처리(정직). 두 라이브 추출 충돌 — 하나가 stale 의심 | ground-truth §2 [HARD] 5상품 교차캡처 vs cpq-schema §5 "적재됨: option_groups 13" | **orchestrator**(ground-truth 의심) — cpq-schema 13행이 실제 psql count였는지 재확인 권장. silsa 신규 적재엔 영향 없음(어느 쪽이든 silsa는 최초 사례) |

---

## 3. 최종 GO/NO-GO

**CONDITIONAL-GO.**

- 매핑 정정 핵심(V-1·V-2·V-3·V-5) = **GO**. 라이브 표준 var 정합·GAP 분리 손계산 정당·트리거 reference resolution 무결·미적재 정직성 입증.
- 단일 조건(NO-GO 해소 필요분): **V-4 F-silsa-1** — constraints GAP CSV를 라이브 적재 glob에서 격리. 이 1건만 mapper가 수정하면 22행 적재 GO.
- F-silsa-1은 **데이터 결함이 아닌 적재 경로 안전성 결함**(constraints는 어차피 GAP·적재 0행). INSERTABLE 22행 자체의 적재 가능성은 무손상.
- F-silsa-2(MINOR)는 silsa 적재 가능성 무영향(orchestrator 라우팅, 차단 아님).

---

## 4. 적재 가능성 집계

| 테이블 (적재 CSV) | 총행 | INSERTABLE | BLOCKED(needs L1) | GAP | 비고 |
|---|:--:|:--:|:--:|:--:|---|
| `t_prd_product_option_groups` | 2 | **2** | 0 | 0 | OG-GAGONG·OG-CHUGA, 트리거 없음 |
| `t_prd_product_options` | 11 | **11** | 0 | 0 | 가공6+추가5, 트리거 없음(헤더) |
| `t_prd_product_option_items` | 9 | **9** | 0 | 0 | 타공3(079)·081계열5·봉미싱1(080). 전건 차원행 EXISTS |
| `t_prd_product_option_items_BLOCKED` | 3 | 0 | **3** | 0 | 열재단(PROC_000084 신설대기)·각목 seq2 ×2(set 0행) |
| `t_prd_product_constraints` | 3 | 0 | 0 | **3** | R-SIZE-NONSPEC·R-GAKMOK-HEIGHT·R-BONGJE-PARAM, 비표준 var(LV-2 GAP). live 적재 0행 |
| **합계** | **28** | **22** | **3** | **3** | 적재 CSV 합 = **22 INSERTABLE**(groups 2+options 11+items 9). 정정 전 25→22(constraints 3 INSERTABLE→0 하향) 검증 일치 |

> 옵션 값 기준: 가공 6 = 5 INSERTABLE + 1 BLOCKED(열재단). 추가 5 = 5 option INSERTABLE / item 6 INSERTABLE + 2 BLOCKED(각목 seq2).

---

## 5. 검증 제약 준수

- DB 직접 적재·쓰기 **수행 안 함**(읽기전용: 문서 Read + ref-product-*.csv grep 대조). **NEVER COMMIT** 준수.
- finding 조용히 수정 안 함 — F-silsa-1→mapper·F-silsa-2→orchestrator 라우팅(생성-검증 분리 R6).
- 차원행 존재·트리거 디스패치 판정 = 라이브 스냅샷 권위(`ref-product-processes.csv`·`ref-product-sets.csv`·cpq-schema §2 트리거 표).
