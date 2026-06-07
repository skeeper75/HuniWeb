# 실사 시트 커버리지 지도(L2) 독립 검증 — silsa-coverage-map.md (29상품 × 7축) — round-6

> **검증자** `dbm-validator` (독립·적대적 — 본 커버리지 지도는 `dbm-option-mapper`가 작성, 검증은 분리가 곧 게이트)
> **작성** 2026-06-07 · round-6 CPQ L2 커버리지 게이트. DB 미적재 · 자기 커밋 금지 · 라이브 쓰기 0.
> **권위 순서:** Excel/L1 명시값 > 추출 스냅샷(`ref-*.csv` — 존재 판정은 라이브 권위) · 라이브 스키마 + 트리거 `fn_chk_opt_item_ref` > 설계 문서.
> **검증 대상:** `silsa-coverage-map.md`. 대조 입력(내 직접 룩업): `ref-products.csv`·`ref-processes.csv`·`ref-product-{processes,materials,sizes,sets,addons}.csv`·`silsa-l1.csv`·`cpq-schema.md §2`·`cpq-option-gaps.md`·`silsa-option-layer.md`+`cpq-option-validation-silsa.md`(138 파일럿)·`m1-yeoljaedan-decision.md`.
> **검증 방법:** 로컬 읽기전용 grep/조회. 라이브 롤백전용 DRY-RUN 미실행(리드 승인 필요 — 최종 권고). NEVER COMMIT.

---

## 종합 판정: **PARTIAL-YES는 정직 (CONDITIONAL-GO) — 단 §4.1에 OVER-CLAIM 1건(MAJOR) 정정 필요**

커버리지 verdict "PARTIAL-YES with preconditions"의 **방향성·전제조건 구조·DATA gap 본질 진단은 정확**하고, 코팅=공정·별색=공정·GAP-BOARD 판정은 라이브 증거로 전부 **HOLD UP**한다. 그러나 **복합옵션 §4.1의 `말아박기+면끈`(124) = COVERED 판정은 OVER-CLAIM**(부착 PROC_000081이 PRD_000124에 미적재 — 트리거 REJECT 대상이므로 실제는 PARTIAL/BLOCKED-DATA). 이 1건이 정정되면 verdict 자체는 유지된다(차단을 DATA gap로 더 정확히 분류하는 방향이라 결론 강화).

- **Over-claim 발견: 1건** (MAJOR) — §4.1 `말아박기+면끈`(124) COVERED → 실제 PARTIAL(seq2 부착081 PRD_000124 미적재).
- **Under-claim 발견: 0건** — GAP/BLOCKED으로 분류한 셀이 실제 라이브였던 경우 없음.
- **품질 결함: 1건** (MINOR) — §5.1 천정고리 PRD_000008 "base 실재 ✅"가 `use_yn=N`(비활성) 미표기.
- **코팅=공정: HOLD** · **별색=공정: HOLD** · **GAP-BOARD: HOLD**(신규·정직·cpq-option-gaps.md에 append 확인).
- 적재 차단(NO-GO)급 결함 0건. 커버리지 verdict는 정직.

---

## 경계면별 PASS/FAIL (cite file/row/proc_cd/prd_cd)

### 경계 1 — 신규 축 코팅 = 공정 `OPT_REF_DIM.04` (headline new-axis claim) — **PASS**

내 직접 룩업으로 결정적 검증:

- **마스터 실재:** `ref-processes.csv` 라인15 `PROC_000014,유광,PROC_000013,{면:단/양면}` · 라인16 `PROC_000015,무광,PROC_000013,{면:단/양면}`. 둘 다 코팅 root `PROC_000013` 자식. ✅ 마스터 권위 일치.
- **차원행 적재 (load-bearing):** 코팅 8상품(118·120·121·129·130·131·136·145) **전수**가 `ref-product-processes.csv`에 `PROC_000014` AND `PROC_000015` **양행 적재 실재**(grep 직접 대조, 8/8 통과). 지도의 "전수 확인" 주장 **참**.
- **"확정(모호 아님)" 정당성:** 정당. 코팅이 자재(mat)가 아닌 공정(proc)으로 라이브 마스터에 명시 모델됨 + 8상품 양행 적재 완비 → 자재 합성 후보 B 기각이 침묵 선택 아니라 라이브 증거 기반. 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.04 → processes(proc_cd) EXISTS)가 8상품 코팅 option_item 전부 통과 확정.
- **단/양면 면 파라미터** = GAP-PARAM(`ref_param_json` 부재)로 정직 플래그 — 정합(cpq-schema §4 🔴8).

판정: **PASS.** 코팅=공정 + DATA 완비 COVERED 주장 HOLD. 8상품 즉시 INSERTABLE 정당.

### 경계 2 — 별색(화이트) = 공정 PROC_000008 + 도수 4분기 무충돌 — **PASS**

- **마스터 실재:** `ref-processes.csv` 라인9 `PROC_000008,화이트,PROC_000007`(별색인쇄 PROC_000007 family). ✅ 일치.
- **PRD_000122 차원행:** `ref-product-processes.csv` grep → **PRD_000122 process 0행**. → PROC_000008 미적재 = **BLOCKED(DATA gap)** 정당. 지도 주장 참.
- **도수 4분기 무충돌:** 별색을 도수축(.06=opt_id)이 아닌 공정축(.04=proc_cd)으로 디스패치 — 마스터 지도 §3.2(별색=공정, NOT 도수=opt_id)와 정합. 키 슬롯 혼동 0(별색은 ref_key1=proc_cd, opt_id 미사용). 트리거 디스패치 슬롯 정확.

판정: **PASS.** 별색=공정 스키마 COVERED / DATA 1상품 BLOCKED 분류 정직. over/under-block 0.

### 경계 3 — 차원행 적재 집계 (22 FULLY / 6 PARTIAL) — **PASS (스폿체크 4/4 일치)**

내 독립 grep 집계(`ref-product-*.csv` × 28상품 118~145):

| 차원 | 지도 주장 | 내 룩업 | 판정 |
|------|----------|---------|:--:|
| 사이즈 `.01` | 28/28 | **28/28**(0행 상품 NONE) | ✅ 일치 |
| 소재 `.03` | 23/28 (5 missing: 129·130·131·132·144) | **23/28**(0행 = 정확히 129·130·131·132·144) | ✅ 일치 |
| 셋트 `.07` | 0/28 | **0/28**(set행 보유 상품 NONE) | ✅ 일치 |
| addon | 2/28 (133·134) | **2/28**(133→PRD_000014·134→PRD_000013만) | ✅ 일치 |

스폿체크 FULLY vs PARTIAL(5상품 교차 독립 확인):
- **126·127·128(특수소재)** FULLY: 옵션축 무(소재/사이즈/수량만), mat≥1·size≥1 → FULLY 정당.
- **131·132(액자)** FULLY: 단 mat=0(보드 0행). 지도는 액자를 "옵션축 무 → FULLY"로 분류하나 **소재 0행**이라 소재 선택 불가 — 후술 주의(§경계7 참고, 차단 아닌 무옵션 처리 정합).
- **122(접착투명)** PARTIAL: 별색 PROC_000008 미적재 → 정당.
- **138(일반현수막)** PARTIAL: 각목 셋트 0행 + 열재단 084 미신설 → 정당.

판정: **PASS.** 4 집계 전건 일치, over-claim 0. (단 액자 131/132의 mat=0은 "옵션축 무 FULLY"로 흡수돼 표면 모순 없음 — boards 129/130만 GAP-BOARD로 분리한 것은 정합.)

### 경계 4 — 복합옵션 polymorphic (8 patterns) — **FAIL → OVER-CLAIM 1건 (MAJOR)**

복합 분해의 차원행 실재를 상품별 직접 룩업:

| 복합값 | 상품 | 지도 판정 | 내 라이브 룩업 | 판정 |
|---|---|:--:|---|:--:|
| `말아박기+면끈` | 124 | **COVERED(080·081 둘 다 실재)** | **PRD_000124 processes = PROC_000080 단 1행. 부착 PROC_000081 미적재** | ❌ **OVER-CLAIM** |
| `오버로크+리본끈` | 124 | PARTIAL(리본끈∉enum) | 124 081 미적재 + 리본끈∉enum (이중 차단) | ⚠️ 결론 OK·사유 불완전 |
| `오버로크+봉미싱(4cm)` | 134 | COVERED(동일공정 2회) | PRD_000134 processes = PROC_000080 실재 → 봉제 2회 080 참조 가능 | ✅ HOLD |
| `각목+끈` | 138 | PARTIAL(끈081 COVERED/각목 BLOCKED) | PRD_000138 = 079·080·081 실재 → 끈081 COVERED 정당 | ✅ HOLD |
| `우드봉+면끈` | 134 | COVERED(addon 링크 실재) | `ref-product-addons.csv` PRD_000134→PRD_000013 실재 | ✅ HOLD(단 스냅샷 주의 하단) |
| `우드행거+면끈` | 133 | COVERED(addon 링크 실재) | PRD_000133→PRD_000014 실재 | ✅ HOLD(스냅샷 주의) |

**핵심 결함 (MAJOR — over-claim):** §4.1 라인96 `말아박기+면끈`(124) = **COVERED "(080·081 둘 다 실재)"**.
- **증거(내 직접 grep):** `ref-product-processes.csv`에서 PRD_000124 = `PROC_000080` 단 **1행**. **PROC_000081 부착은 PRD_000124에 0행**. silsa 전 범위(118~145)에서 PROC_000081을 보유한 상품은 **PRD_000138 단 1개뿐**.
- **트리거 위반:** `fn_chk_opt_item_ref`(OPT_REF_DIM.04 → `t_prd_product_processes(proc_cd=ref_key1)` EXISTS for prd_cd)는 `(PRD_000124, …, ref_key1=PROC_000081)`을 **REJECT**한다(124에 081 차원행 부재). 즉 면끈(부착) seq2는 COVERED가 아니라 **BLOCKED(DATA gap)**.
- **내부 모순:** 같은 지도가 **138**의 `각목+끈`은 "끈081 COVERED"로 정당하게 판정(138은 081 실재)하면서, **124**의 `말아박기+면끈`은 같은 081 의존을 "둘 다 실재"로 무검증 COVERED 처리. 138 파일럿 검증(`cpq-option-validation-silsa.md §경계1`)이 "PROC_000081 = **PRD_000138** 라이브 실재 확정"을 **138 한정**으로 입증했는데, 커버리지 지도가 widening 시 124로 그 COVERED를 **상품별 재룩업 없이 이월**한 것이 결함의 메커니즘.
- **올바른 판정:** `말아박기+면끈`(124) = **PARTIAL** — seq1 봉제(말아박기) PROC_000080 **COVERED** / seq2 면끈(부착) PROC_000081 **BLOCKED-DATA**(PRD_000124에 081 차원행 선적재 필요).
- **부수(MINOR):** `오버로크+리본끈`(124) 결론(PARTIAL)은 맞으나 사유가 "리본끈∉enum"만 — 실제는 seq1 봉제 OK·seq2 **부착081 자체가 124 미적재 + 리본끈∉enum** 이중 차단. seq2가 enum 확장만으론 안 풀리고 차원행 선적재도 필요함을 명시 누락.

판정: **FAIL — OVER-CLAIM 1건(MAJOR) + 사유 불완전 1건(MINOR). 정정 후 PASS 가능.**

### 경계 5 — 신규 SCHEMA gap GAP-BOARD honesty — **PASS**

- **신규성:** `cpq-option-gaps.md` 라인65 `### GAP-BOARD … (silsa widening 신규)` + 라인123 `🆕` — 기존 8 GAP에 신규로 append 확인. 중복 아님.
- **DATA 사실 확인:** 보드·액자 5상품(129·130·131·132·144) `ref-product-materials.csv` **전수 0행**(내 grep 직접 확인). → 보드 substrate가 자재로 미적재 = 진짜 DATA+SCHEMA 질문이지 dodge 아님.
- **"모호(설계 결정)" 정직성:** 정당. 3 후보(자재 권고/가공/형태)를 명시 제시, 침묵 단일 선택 안 함. 마스터에 "보드" 공정·"보드종류" 자재 둘 다 부재 → L1 W열 배치 ≠ 엔티티 확정이라는 판독 정합. ddl-proposer 라우팅(자재행 vs 공정행) 명시.

판정: **PASS.** GAP-BOARD 신규·정직·라우팅 정확. 화이트/블랙 보드를 침묵 자재 처리하지 않고 결정 큐로 올린 것이 정합.

### 경계 6 — add-on base 실재 (거치대 등) — **PASS (단 MINOR 1건)**

`ref-products.csv` 직접 대조(prd_typ_cd·use_yn):

| add-on base | prd_cd | PRD_TYPE.03? | use_yn | 지도 주장 | 판정 |
|---|---|:--:|:--:|---|:--:|
| 우드봉 | PRD_000013 | ✅ | **Y** | COVERED | ✅ HOLD |
| 우드행거 | PRD_000014 | ✅ | **Y** | COVERED | ✅ HOLD |
| 우드거치대 | PRD_000012 | ✅ | **Y** | PARTIAL(1 base, 2 SKU [CONFIRM]) | ✅ HOLD |
| 천정고리 | PRD_000008 | ✅ | **N (비활성)** | "base 실재 ✅" COVERED(base) | ⚠️ **MINOR** |
| 실외용배너거치대 | (미존재) | — | — | GAP-DATA(base 미등록) | ✅ HOLD |

- **실외용배너거치대 base 부재 확정:** `ref-products.csv`에 해당 상품명 0행 → 실내(우드거치대 PRD_000012 1종)만 실재, 실외용 미등록 = GAP-DATA 정직. 실내/실외 = 1 base vs 2 SKU `[CONFIRM]`도 정직(L1 2값 vs 라이브 1 base).
- **MINOR — 천정고리 use_yn=N:** `ref-products.csv` PRD_000008 = `use_yn=N`(비활성 상품). 지도 §5.1·footnote 2는 천정고리를 "base 실재 확정 ✅ COVERED(base)"로 표기하나 **비활성(use_yn=N)임을 미표기**. addon template이 use_yn=N base를 가리키면 운영상 비활성 부자재 참조 — 최소한 "등록되어 있으나 use_yn=N(비활성)"으로 한정 필요. (어차피 링크 미적재 GAP-DATA라 적재 차단은 아니나, "base 실재 ✅"는 활성 오인 소지.)

판정: **PASS (MINOR 1건).** base 실재/부재 판정 정확, use_yn=N 한정만 보강.

### 경계 7 — coverage verdict integrity ("PARTIAL-YES") — **PASS (정직, 경계4 정정 반영 시)**

- **SCHEMA-blocked를 DATA로 위장했는가? — NO.** 차단 본질 분류 검증: 22 FULLY / 6 PARTIAL의 PARTIAL 6상품 차단(별색·셋트·addon 링크·열재단·실외거치대·각목)은 내 룩업상 **전부 DATA(차원행 0행) 또는 신규공정 신설(열재단 084)**. 순수 SCHEMA 표현력 부족으로 막힌 상품 0 — "차단의 압도적 다수 = DATA gap" 주장 **방어 가능**.
- **SCHEMA gap 과소평가 여부:** 지도가 SCHEMA gap을 GAP-BOARD(신규)·GAP-PARAM·GAP-COMPOSITE 3종으로 정직 명시. 이는 "적재는 되나 정보 무손실 환원 미보장"(구수·폭·모양·복합동반)으로 PARTIAL(완전 YES 아님) 사유에 정확 반영 — 과소평가 아님.
- **경계4 over-claim의 verdict 영향:** 영향 제한적. `말아박기+면끈`(124)을 COVERED→PARTIAL로 정정하면 차단이 **DATA gap 1건 추가**(124 부착081 미적재)되는 방향 — 이는 "차단 본질=DATA gap" 주장을 **강화**하고 5축 완전 COVERED 결론을 흔들지 않는다(가공축은 이미 PARTIAL로 분류됨). verdict "PARTIAL-YES with preconditions" 자체는 유지.

판정: **PASS.** "PARTIAL-YES" 정직. 단 경계4 정정으로 §4.1 정확도 보강 필수.

---

## Findings (severity + routing)

| # | 심각도 | 경계 | 결함 | 증거 | 라우팅 |
|---|:--:|:--:|------|------|--------|
| F-1 | **MAJOR** | 4 | `말아박기+면끈`(124) = COVERED "(080·081 둘 다 실재)" 는 OVER-CLAIM. PRD_000124 = PROC_000080 1행만, **부착 PROC_000081 미적재** → 트리거 REJECT. 올바른 판정 = PARTIAL(seq1 봉제080 COVERED / seq2 면끈 부착081 **BLOCKED-DATA**) | `ref-product-processes.csv` PRD_000124 grep = PROC_000080 only · silsa 전범위 081 보유 상품 = PRD_000138 단 1개 · `cpq-schema §2` 트리거 디스패치 | → **dbm-option-mapper**: §4.1 라인96 판정 COVERED→PARTIAL 정정 + §6.2 GAP-DATA에 "부착081 PRD_000124 미적재(면끈)" 1행 추가 |
| F-2 | MINOR | 4 | `오버로크+리본끈`(124) 결론 PARTIAL은 맞으나 사유 불완전 — seq2가 enum(리본끈∉) + **부착081 차원행 124 미적재** 이중 차단인데 enum만 명시 | 상동(124 081 미적재) | → dbm-option-mapper: §4.1 라인95 사유에 "부착081 124 미적재" 추가 |
| F-3 | MINOR | 6 | 천정고리 PRD_000008 "base 실재 ✅ COVERED(base)"가 **use_yn=N(비활성)** 미표기 — 활성 base 오인 소지 | `ref-products.csv` PRD_000008 use_yn=N | → dbm-option-mapper: §5.1·footnote2에 "use_yn=N(비활성)" 한정 추가 |
| O-1 | INFO | 4 | addon 링크 실재 인용이 `ref-product-addons.csv`(컬럼 `addon_prd_cd`) 기준 — 라이브는 addon→`tmpl_cd` 마이그 완료(`cpq-schema §1.2`). 링크 자체(133→014·134→013)는 실재하나 컬럼 형태가 스냅샷 stale | `ref-product-addons.csv` 헤더 `addon_prd_cd` vs `cpq-schema §1.2` tmpl_cd | → 정보(적재 단계서 tmpl_cd 변환·DRY-RUN로 확정 권고) |

---

## 정정된 커버리지 집계 (over/under-claim 반영)

지도 §5.2 집계는 **상품 레벨 22 FULLY / 6 PARTIAL은 유지**(124는 이미 PARTIAL 분류 — 코팅·봉제 보유 옵션축 상품). 그러나 **복합옵션 §4.1 셀 레벨 정정**:

| 복합옵션 셀 | 지도 | 정정 |
|---|:--:|:--:|
| `말아박기+면끈`(124) | COVERED | **PARTIAL**(seq2 부착081 BLOCKED-DATA) |
| 나머지 7 복합 셀 | (유지) | HOLD |

- **복합 8종 셀 정정 후:** COVERED 3 → **2** · PARTIAL 4 → **5** · (각목 2종 PARTIAL 유지). 8종 polymorphic 표현 가능성 결론(이종 차원 결합은 polymorphic으로 자연 표현)은 불변 — 차단은 표현력 아닌 차원행 적재 문제.
- **축 레벨 COVERED 5/7 불변:** 사이즈·소재·별색·코팅·수량 5축 완전 COVERED 결론 HOLD(F-1은 가공축 내부 — 가공축은 이미 PARTIAL).
- **GAP 집계 불변:** 신규 SCHEMA gap = GAP-BOARD 1건. F-1은 GAP-DATA 1행 추가(SCHEMA gap 아님).

---

## insertable / BLOCKED / GAP 정직성 tally (내 독립 룩업)

| 분류 | 지도 | 내 검증 | 판정 |
|------|:--:|:--:|:--:|
| 사이즈축 28/28 적재 | COVERED | 28/28 grep 확인 | ✅ 정직 |
| 소재 23/28 (5 board 0행) | COVERED+GAP | 23/28·5 board 정확 | ✅ 정직 |
| 코팅 8상품 양행(014+015) | COVERED | 8/8 grep 확인 | ✅ 정직 |
| 별색 PROC_000008(122) | BLOCKED-DATA | 122 process 0행 | ✅ 정직 |
| 셋트 0/28 / 각목 BLOCKED | BLOCKED-DATA | 0/28 grep 확인 | ✅ 정직 |
| 부착081 124(면끈) | **COVERED** | **124 081 0행 → BLOCKED-DATA** | ❌ **F-1 over-claim** |
| GAP-BOARD (boards) | 신규 SCHEMA | 5상품 mat 0행·신규 append | ✅ 정직 |
| 실외거치대 base | GAP-DATA | ref-products 0행 | ✅ 정직 |

over-claim 1 (F-1) · under-claim 0 · over-block 0 · under-block 1(F-1: BLOCKED여야 할 면끈을 COVERED로).

---

## 최종 verdict

**커버리지 verdict "PARTIAL-YES with preconditions"는 정직(CONDITIONAL-GO).** 7경계 중 6 PASS(경계 1·2·3·5·6·7), 경계 4만 FAIL(over-claim F-1 1건). 결함은 verdict를 뒤집지 않고 **차단을 DATA gap로 더 정확히 분류하는 방향**이라 정정 시 결론 강화.

- **코팅=공정 + DATA 완비 COVERED: HOLD** (8/8 양행 적재 라이브 확인, 모호 아님 정당).
- **별색=공정 + DATA BLOCKED(122): HOLD** (도수 4분기 키슬롯 무충돌).
- **GAP-BOARD 신규·정직: HOLD** (5상품 mat 0행, 침묵 선택 안 함, 라우팅 정확).
- **"차단의 압도적 다수 = DATA gap": 방어 가능** (순수 SCHEMA 표현력 차단 0).

**조건:** F-1(MAJOR)을 dbm-option-mapper가 §4.1 `말아박기+면끈`(124) COVERED→PARTIAL 정정 + GAP-DATA 1행 추가, F-2/F-3(MINOR) 사유/한정 보강 후 **GO**. 재게이트는 §4.1·§5.1·§6.2 변경분만.

**라이브 DRY-RUN 권고:** 경계 4의 트리거 REJECT(124×PROC_000081)는 로컬 룩업으로 확정했으나, addon→tmpl_cd 마이그(O-1) 영향과 코팅 8상품 option_item 트리거 통과는 **롤백전용 라이브 DRY-RUN**(option_items INSERT → 트리거 발화 → ROLLBACK)이 최강 증명. 리드 승인 시에만 실행, **NEVER COMMIT**.
