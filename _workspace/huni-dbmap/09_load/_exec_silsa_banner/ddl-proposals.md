# DDL 제안 인덱스 — 일반현수막(PRD_000138) round-5

> 작성 2026-06-08 · **[v2 옵션 자재+공정 BUNDLE 갱신]** · dbm-load-builder. **본 트랙은 신규 DDL 을 재발명하지 않는다** — 기존 제안(11_ddl_proposals/)을 참조하고, 적재 실행 중 발견한 **스키마 부족분 1건(NULLS DISTINCT)** 만 신규 surface. **[v2] 자재 mint 4건(master-data, DDL 아님)** 추가. 모든 DDL/자재 mint/코드행/master-data 는 **인간 승인**(propose ≠ apply).

---

## 1. 무엇이 DDL 이고 무엇이 아닌가 (search-before-mint 결과)

| 항목 | 분류 | DDL 필요? | 처리 |
|------|------|:--:|------|
| siz 77규격 (SIZ_000538~618) | **master-data** | ❌ | `t_siz_sizes` INSERT(인간 승인). 테이블/컬럼 신설 불요. `_blocked/B01` |
| 열재단 PROC_000084 | **data**(신규 마스터 공정 행) | ❌(행) | `t_proc_processes` + `t_prd_product_processes` INSERT(인간 승인). 기존 2테이블 그대로 수용 → `11_ddl_proposals/heat-cut-process-proposal.sql` 재사용 |
| **[v2] 자재 mint 4** (큐방·각목900이하·각목900초과·봉제사) | **master-data** | ❌ | `t_mat_materials` INSERT(MAT_TYPE.07 부속, mat_cd 인간 채번) + `t_prd_product_materials` 링크. 테이블/컬럼 신설 불요 → `_blocked/B03a`(제안)·`B03b`(링크) |
| **[v2] 끈·양면테입 자재 링크** | **data** | ❌ | master 실재(MAT_000070/069). `t_prd_product_materials` 링크만(mint 불요) → `_blocked/B03b` live |
| ~~각목 sub_prd_cd~~ **[v2 폐기]** | — | — | **v2 정정: 각목=material(.03)·셋트(.07) 아님.** 위 "자재 mint 4"로 흡수(각목900이하/초과) |
| 옵션 가격 component 10 | **data** | ❌ | `t_prc_price_components` INSERT(INSERTABLE, 본 트랙 적재) |
| **타공 구수·각목 규격 param 보존처** | **schema GAP** | ⚠️ 후보 | `ref_param_json` 컬럼 부재(LV-5) → `11_ddl_proposals/ref-param-json-proposal.sql` 재사용(GAP-PARAM) |
| **t_prc_component_prices 자연키 UNIQUE = NULLS DISTINCT** | **schema 관찰(신규)** | ⚠️ surface | 아래 §3. ON CONFLICT 불가 우회(변형 C) — 본 트랙 정상 작동. DDL 강제 아님 |

> **핵심:** 본 트랙이 닫는 GAP 은 전부 **data/master-data(인간 승인 INSERT)** 거나 **기존 DDL 제안 재사용**이다. 진짜 신규 DDL(테이블/컬럼) 신설 0건. **[v2] 자재 mint 4 = master-data INSERT(DDL 아님)** — `t_mat_materials` 기존 테이블 그대로 수용. round-5 GOAL "propose minimal, reuse over re-invent" 준수.

### 1A. [v2] 자재 mint 4건 (search-before-mint 재증명 — 라이브 직접 조회 권위)

| 제안 자재 | 라이브 t_mat_materials 검색 | 판정 | 분류 |
|---|---|:--:|---|
| 큐방 | 큐/방/하토메/그로밋/고리 → 아크릴부속 고리·천정고리만, 큐방 0행 | mint | BLOCKED-MINT+LINK |
| 각목(900이하) | 각목/사각목/원목 0행. 우드봉 MAT_000225 존재하나 **차용 배제**(각목=사각단면 목재≠둥근 우드봉) | mint | BLOCKED-MINT+LINK |
| 각목(900초과) | 상동 (2규격 모델 D-2: 별 mat_cd 2개 vs 단일+param) | mint | BLOCKED-MINT+LINK |
| 봉제사(실) | 실/봉제사/봉사/미싱사 → 실버/실사소재만, 봉제용 실 0행 | mint | BLOCKED-MINT+LINK |

> 끈 MAT_000070·양면테입 MAT_000069 = **master 실재**(직접 조회 확인) → mint 안 함(링크만). mat_cd 채번 = 라이브 MAX(mat_cd)=MAT_000336 재확인 후 후니 배정(`[CONFIRM-CHANNEL]`·발명 금지). `_blocked/B03a` 는 채번 전이라 **주석(제안)**.

---

## 2. 재사용 DDL 제안 (재발명 금지)

### 2.1 열재단 신규 공정 — `11_ddl_proposals/heat-cut-process-proposal.{sql,md}`

- 닫는 차단: `blocked-and-gaps.md` B-3(열재단 option_item, 가공 dflt).
- 내용: `t_proc_processes` 1행(proc_cd=PROC_000084 `[CONFIRM-CHANNEL]`, proc_nm='열재단', prcs_dtl_opt=NULL flat) + `t_prd_product_processes`(PRD_000138, PROC_000084) 링크 1행.
- search-before-mint: ref-processes 재단/cut family(직각/완칼/반칼/스티커완칼) 전수 = 종이/스티커 대상, 천 열봉합 재단 0건 → 진짜 GAP. 완칼 PROC_053 차용 폐기(매질 불일치, M-1 ①).
- 적용 순서: 라이브 MAX(proc_cd) 재확인 → t_proc_processes → t_prd_product_processes. 기존행 영향 0(순수 INSERT 2행).
- 적용 후: 열재단 option_item INSERTABLE 승격(트리거 통과). **인간 승인 게이트.**

### 2.2 옵션 param 보존처 — `11_ddl_proposals/ref-param-json-proposal.{sql,md}`

- 닫는 GAP: `blocked-and-gaps.md` G-2(GAP-PARAM, 타공 구수·각목 규격).
- 내용: `t_prd_product_option_items` 에 `ref_param_json` jsonb 컬럼 ALTER ADD(초안 존재).
- 본 트랙: param 미적재를 침묵 drop 하지 않고 GAP-PARAM 으로 명시. 컬럼 신설은 인간 승인.

---

## 3. 신규 surface — `t_prc_component_prices` 자연키 UNIQUE 의 NULLS DISTINCT (R4 판단 요청)

| 항목 | 내용 |
|------|------|
| 발견 | 라이브 `ux_t_prc_comp_prices_nat_key`(comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty) = UNIQUE 인덱스이나 **NULLS DISTINCT**(`indnullsnotdistinct=f`, PG 기본). |
| 영향 | 옵션 추가가격 flat 행(siz/clr/mat/coat/bdl/min 전부 NULL)은 NULL 끼리 distinct → `ON CONFLICT (자연키) DO NOTHING` 이 **2회차에 미발화** → 중복 삽입 → R1 멱등 FAIL 위험. |
| 본 트랙 처리 | **변형 C**(`INSERT…SELECT…WHERE NOT EXISTS` + `IS NOT DISTINCT FROM`)로 NULL-safe 멱등 달성(DRY-RUN 2-pass delta=0 실증). DDL 강제 없이 정상 작동. |
| DDL 제안 후보(인간 판단) | 만약 향후 `ON CONFLICT` UPSERT 를 쓰고 싶다면 인덱스를 `NULLS NOT DISTINCT`(PG15+) 로 재생성하는 ALTER 가 후보. **단 기존 4954행 영향·다른 트랙 의존 분석 필요** → 본 트랙 범위 밖. 변형 C 로 충분하므로 **DDL 불요 권고**. validator R4 판단 요청. |

> 이 발견은 round-2/디지털인쇄 트랙의 동일 패턴(변형 C 사용)과 정합 — 새 결함 아니라 **재확인**. 자연키 UNIQUE 가 있어도 NULLS DISTINCT 면 NULL 포함 행에 ON CONFLICT 불가하다는 라이브 사실을 명시 기록.

---

## 4. 인간 승인 대기 종합

| # | 항목 | 종류 | 참조 |
|:--:|------|------|------|
| 1 | siz 77규격 등록 | master-data | `_blocked/B01` · blocked-and-gaps B-1 |
| 2 | 열재단 PROC_000084 DDL 적용 | data(공정 행) | `11_ddl_proposals/heat-cut-process-proposal.sql` · B-3 |
| 3 | **[v2] 자재 mint 4**(큐방·각목LE/GT·봉제사) + PRD_000138 자재 링크 | master-data | `_blocked/B03a`(제안)·`B03b`(링크) · B-5 |
| 4 | **[v2] 끈/양면테입 자재 링크**(MAT_000070/069, mint 불요) | data | `_blocked/B03b` live · B-4 |
| 5 | ref_param_json 컬럼 ALTER | schema(GAP-PARAM) | `11_ddl_proposals/ref-param-json-proposal.sql` · G-2 |
| 6 | R-GAKMOK 폼빌더 입력방식 확정 (**var=mat_cd**) | 정책 | blocked-and-gaps G-1·D-formbuilder |
| 7 | **[v2] 각목 2규격 모델**(별 mat_cd 2개 vs 단일+param) | 설계 | blocked-and-gaps D-2 |
| 8 | 실제 COMMIT (가격 36 + CPQ 22 = 58 INSERTABLE) | 적재 | DRY-RUN GO 후 |

> [HARD] propose ≠ apply. 본 패키지는 실행본 + DRY-RUN 까지. 적용·COMMIT·**자재 mint**·코드행등록은 후니 인간 승인. **[v2] 각목 sub_prd_cd(셋트) 모델 폐기 → 각목=material(.03) 확정**(v1 D-각목-MODEL 종결).
