# admin-ui-spec round-8 — 독립 검증 게이트 (evaluator-active)

> 검증자: evaluator-active (독립·적대적, 명세 미작성). 검증일 2026-06-08.
> 대상: `13_admin-ui-spec/admin-ui-spec.md` + `entities/{A-dimensions,B-cpq,C-core-price}.md` (34 t_* 엔티티).
> 권위: 라이브 DB `information_schema.columns`(읽기전용 psql 실측) · `t_cod_base_codes`(코드값) ·
> `docs/huni/table-spec_260608.html`(컬럼 스펙) · `_raw/forms/*.json`(catalog 폼 덤프).
> 채점 원칙: **명세 자기주장이 아니라 evaluator가 직접 측정한 컬럼 수로 채점**.
> 사용자 directive(= 합격 기준): "각 페이지의 모든 항목들에 대해 정의 — 하나의 항목도 지나치지 않도록" → **누락 0**.

## 종합 판정: 1차 **NO-GO** (G2 FAIL) → **보정 후 재판정 GO (2026-06-08)**

핵심 결함: `t_prd_product_options.tags`(jsonb) 컬럼이 명세에서 **완전 누락**되었고, 자기검증(B §9 누락점검)이
이를 ✅(누락 0)로 **허위 보고**했다. 사용자 directive의 중심 요구(누락 0)가 라이브 실측으로 깨졌다.
규모는 작다(34엔티티 332컬럼 중 `tags` 컬럼 2개, 1개 완전누락+1개 오분류).

**보정 검증(2026-06-08, 라이브 information_schema 재실측):** `t_prd_product_options.tags`·`t_prd_templates.tags`
= `jsonb NULL` 실재 확정(options 13컬럼·templates 11컬럼). B-cpq.md 보정 반영 확인 — §2 options 필드표 `tags`
행 추가(12→13)·§6 templates GAP-TAGS 해제(10→11)·§9 누락점검 합계 81/81 ✅·❌ 잔존 0·근본 교훈("컬럼 권위
= 라이브 information_schema, table-spec 보조") 명시. **G2 FAIL → PASS 전환, 단일 원인(table-spec의 tags 미기재)
완전 해소.** → **G1~G7 전건 PASS = GO.**

---

## 게이트별 판정

| 게이트 | 판정 | 한 줄 근거 |
|--------|:--:|------------|
| G1 화면 완전성 | **PASS** | 라이브 t_* = 34개, 명세 인벤토리 34개. `comm` diff 결과 누락 0·발명 0 (live∖spec=∅, spec∖live=∅). |
| **G2 컬럼 누락 0** | **FAIL** | 34엔티티 중 32개 컬럼 수 정확 일치. **2개 불일치**: options(live 13 vs 명세 12), templates(live 11 vs 명세 10). 공통 원인=`tags` jsonb. |
| G3 코드값 실측 | **PASS** | OPT_REF_DIM(7)·SEL_TYPE(2)·RULE_TYPE(3)·MAT_TYPE(11)·USAGE(7)·PRD_TYPE(5)·OUTPUT_PAPER_TYPE(3) 전부 라이브와 정확 일치. 발명 0. |
| G4 입력 경로 타당성 | **PASS** | 트리거 `fn_chk_opt_item_ref` 라이브 존재 확인. option_items=pvEdit 전용(catalog 폼 덤프 부재로 입증)·templates=catalog 폼(덤프 존재). page_rules=catalog+pvEdit 양립 표기 타당. |
| G5 미적재 채움 정합 | **PASS** | round-7 갭(option_items 0행·가격사슬 6상품군·차원 PARTIAL)→FK 위상정렬 입력 단계로 환원. 각목추가 사슬 완결 예시가 라이브 PROC 실재로 즉시 입력 가능 입증. |
| G6 GAP 정직성 | **PASS(주의)** | GAP-PARAM(option_items ref_param_json 부재)=라이브 12컬럼 실측으로 정직 확인. GAP-TAGS는 "발명 말고 재확인 필요"로 숨기지 않음(정직)이나 결론이 빗나감(아래 D-2). |
| G7 실결함 ≥1 | **PASS** | 실결함 2건 발견(D-1 HIGH·D-2 MED). 검증 비표면적. |

---

## 독립 컬럼 수 측정표 (live information_schema vs 명세 행수)

`select count(*) from information_schema.columns where table_name='<t>' and table_schema='public'` 직접 측정.

### 샘플 ≥8 (게이트 G2 핵심 — A/B/C 횡단)

| 엔티티 | **live 컬럼수** | 명세 주장 행수 | 일치 |
|--------|:--:|:--:|:--:|
| A-1 t_mat_materials | 17 | 17 | ✅ |
| A-2 t_siz_sizes | 17 | 17 | ✅ |
| A-9 t_prd_product_plate_sizes | 10 | 10 | ✅ |
| A-11 t_prd_product_page_rules | 7 | 7 | ✅ |
| **B-2 t_prd_product_options** | **13** | **12** | ❌ **(tags 누락)** |
| B-3 t_prd_product_option_items | 12 | 12 | ✅ (ref_param_json 부재=정직 GAP) |
| B-5 t_prd_product_addons | 6 | 6 | ✅ |
| **B-6 t_prd_templates** | **11** | **10** | ❌ **(tags 오분류·오집계)** |
| C-1 t_prd_products | 21 | 21 | ✅ |
| C-9 t_prc_component_prices | 13 | 13 | ✅ |
| C-8 t_prc_formula_components | 6 | 6 | ✅ |

### 전수 (34엔티티) 측정 요약

- A군 12엔티티: 17/17/9/11/8/10/11/8/10/9/7/9 — **12/12 정확 일치**.
- B군 7엔티티: option_groups 14✅·**options 13≠12❌**·option_items 12✅·constraints 12✅·addons 6✅·**templates 11≠10❌**·template_selections 13✅ — **5/7 일치**.
- C군 15엔티티: 21/7/8/8/7/7/6/13/6/6/6/10/6/9 — **15/15 정확 일치**.
- **`tags`(jsonb) 보유 테이블 = 라이브 전체에 정확히 2개**(`t_prd_product_options`·`t_prd_templates`) — 둘 다 불일치 테이블과 일치. 결함이 `tags`로 완전 국한됨을 교차 확인.

---

## 발견된 실결함

### D-1 [HIGH] `t_prd_product_options.tags`(jsonb) 컬럼 완전 누락 — 누락 0 기준 위반
- **위치**: `entities/B-cpq.md` §2 (필드표 12행) + §9 누락점검("t_prd_product_options 12컬럼 ✅").
- **사실**: 라이브 `information_schema.columns` = **13컬럼**. 13번째 = `tags jsonb NULL`. 명세 필드표·누락점검 모두 부재.
- **근본 원인**: 권위로 쓴 `table-spec_260608.html`에 `tags` 미기재(grep 결과 0건). options는 catalog 폼 덤프도 없어(pvEdit 전용) table-spec이 단독 권위 → 라이브 `information_schema` 미대조로 침묵 누락. 자기검증이 같은 누락 권위를 재사용해 ✅ 허위 통과.
- **directive 영향**: "하나의 항목도 지나치지 않도록"을 직접 위반(컬럼 1개 통째 누락). 누락 0 기준 불성립.
- **수정 라우팅**: B-cpq §2 필드표에 `tags`(textarea→jsonb, 선택, "SKU/검색 태그 메타. 자유 jsonb. 미사용 시 공란") 1행 추가 → §9 누락점검 12→**13**, ❌→✅ 재집계. (templates의 GAP-TAGS와 동일 컬럼이므로 함께 처리.)

### D-2 [MEDIUM] `t_prd_templates.tags` GAP-TAGS 오판 — 실재 컬럼을 "재확인 필요"로 미결·오집계
- **위치**: `entities/B-cpq.md` §6 `tags` 행 주석("table-spec 미기재 → 컬럼 실재 라이브 재확인 필요") + §9("10컬럼 ✅", tags=폼전용 취급).
- **사실**: 라이브 = **11컬럼**, `tags jsonb NULL` **실재**(form 덤프에도 존재). GAP이 아니라 정규 컬럼.
- **영향**: 컬럼 자체는 본문 행으로 포착됨(완전 누락은 아님·정직 플래그)이나 ① 누락점검 컬럼수 10은 **오집계**(11이어야)이고 ② GAP-TAGS의 "실재 불확실" 결론이 **틀림**. directive 관점에서 자기검증표가 신뢰 불가.
- **수정 라우팅**: §6 `tags` 행에서 GAP-TAGS 해제(라이브 실재 확정, jsonb) → §9 templates 10→**11**, GAP 목록에서 GAP-TAGS 삭제. `dbm-ddl-proposer` 불요(이미 존재).

### 부수 관찰 (결함 아님, 정직성 확인)
- **GAP-PARAM(option_items ref_param_json)**: 라이브 12컬럼 실측으로 부재 확인 → 정직. ALTER 라우팅 타당.
- **B-5 addons use_yn/del_yn 부재**: 라이브 6컬럼(소프트삭제 슬롯 없음) 정확 — 명세 주의 표기 정확.
- **A-11 page_rules del_yn/del_dt 부재(7컬럼)**: 라이브 실측 정확.
- **행수 주장 전건 일치**: options=5·templates=9·option_items=0·products=275·prod_price_formulas=64·customers=0·prod_prices=0 — 라이브와 정확.

---

## 누락 0 기준 성립 여부: **불성립**

directive의 합격선은 "하나의 항목(컬럼)도 누락 없음". 라이브 실측 결과 `t_prd_product_options.tags`가 명세에서
통째로 빠졌고(D-1), 자기검증표가 이를 ✅로 허위 보고했다. **누락 0은 현재 깨져 있다.** 단, 결함은 `tags`
컬럼 2건으로 완전 국한(나머지 330컬럼·32엔티티 정확)이며, table-spec 권위 자체의 누락에서 파생한 체계적·단일
원인이다. **D-1·D-2 수정(필드표 2행 추가/정정 + 누락점검 재집계) 후 재검증 시 GO 가능.**
