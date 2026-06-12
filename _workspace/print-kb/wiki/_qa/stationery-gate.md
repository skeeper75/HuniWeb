# stationery W-gate verdict — CONDITIONAL-GO (2026-06-12)

대상: `recipes/stationery.md` · 검증자 독립(생성자 불신·재측정). 라이브 read-only psql 실측 기반.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0건 (booklet L26 "✓" 격리 = 정당 확인) |
| W2 링크 무결성 | PASS | 0건 (stationery 발신 53링크 전건 resolve·역링크 무손상) |
| W3 스키마 앵커 | FAIL | 1건 SCHEMA-MISMATCH ([ST-ID-001] prd_typ_cd 코드/라벨 오류) |
| W4 badge 정합 | PASS | 0건 |
| W5 stale/v03 차단 | PASS | 0건 (v03/price-engine-ddl는 전부 STALE-금지·진원 맥락) |
| W6 CQ 커버리지 | ESCALATE | cq-registry.md 부재(위키 전역 인프라 갭·stationery 결함 아님) |
| W7 index/log 일관성 | PASS | 0건 |
| W8 실행가능성 | PASS | 0건 (0정체→6적재 전 단계 구체 입력/축링크 제공) |

종합: **CONDITIONAL-GO** — W3 SCHEMA-MISMATCH 1건(Low~Med, 단일 앵커 라인·블록 본문 사실은 정확)만 보정하면 GO. NO-GO 사유(FABRICATED/STALE/W8 핵심 FAIL) 없음. 핵심 검증 과제(booklet L26 격리 정당성)는 라이브로 입증되어 W1 clean.

---

## W1 핵심 — booklet mapping.md L26 격리 정당성 (라이브 입증)

writer는 [ST-PRC-002]에서 booklet `mapping.md` L26 "떡메모지 ... PRF_TTEOKME_FIXED + 112행 **✓**"를 **인용하지 않고 격리**(F-PB-1 동형 — 엑셀/문서의 "✓"가 라이브 갭 은폐)했다. 라이브 재측정으로 격리 정당성 확인:

```
A_097_binding  | 0    ← t_prd_product_price_formulas WHERE prd_cd='PRD_000097' = 0행
B_tteok_formula| 0    ← frm_cd ILIKE '%TTEOK%' = 0 (PRF_TTEOKME_FIXED 부존재)
C_comp_tteok   | 112  ← component_prices(%TTEOK%) = 112행 (존재)
```

판정: mapping.md L26 "✓"는 라이브와 모순(formula 부존재·바인딩 0행). writer 주장 "COMP_TTEOKME 112행 존재·바인딩만 미적재"는 라이브와 field-for-field 일치. 격리는 **정당**(인용 시 FABRICATED 될 뻔한 것을 회피). 양면표기(라이브 갭→정답) 정확.

기타 `출처:` 라인 의미 대조: ST-DEF-002 HARD 매핑(노드명↔커버타입), ST-04 레더 .08, 미싱제본 MISSING, USAGE/QTY_UNIT 슬롯 전부 출처 의미 일치(W3 SELECT로 교차확인). 날조 0.

---

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-ST-W3-1 | stationery#ST-ID-001 (L25 앵커) | W3 | SCHEMA-MISMATCH | 페이지 앵커: `t_prd_products(prd_typ_cd .04 완제품·.02 반제품)`. 라이브: 172~181 활성 10상품 = **PRD_TYPE.03**, 097=.04. 코드 도메인 `t_cod_base_codes`: .01=완제품·.02=반제품·**.03=기성상품·.04=디자인상품**. 즉 ".04 완제품" 이중 오류(.04는 디자인상품·완제품은 .01·실제 상품은 .03). `SELECT prd_cd,prd_typ_cd FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000172' AND 'PRD_000181'` → 전부 .03 | 앵커를 `prd_typ_cd .03 기성상품(활성 10)·.04 디자인상품(떡메모지 097)·.02 반제품(098)`으로 정정. 본문 "11 활성 완제품"은 product-master 통속표현으로 유지 가능하나, 앵커의 코드↔라벨 매핑은 라이브 코드값 권위로 교정. 원천 `product-identity.md`는 이 .04 주장을 하지 않음(=writer 도입 오류). |
| F-ST-W6-1 | (위키 전역) | W6 | (escalate) | `README.md:144`가 `cq-registry.md`를 답안 추적 대상으로 명시하나 해당 파일이 위키 어디에도 부재(`find` 0건). stationery는 14 CQ에 `answers_cq` 부착(페이지가 통제 가능한 부분 충족). | orchestrator escalate: cq-registry.md 신설(또는 README §144 참조 정정). stationery 단독 보정 불가·NO-GO 사유 아님. |

---

## 게이트별 근거 요약

- **W2**: stationery 발신 `[[...]]` 53종(헤더 `[[링크]]` placeholder 제외) 전건 대상 페이지·앵커 실재. booklet 동형 교차참조 10건(BK-BOM-001/002·BK-CPQ-001/002·BK-DIM-002·BK-ID-001/002·BK-LP-001·BK-PRC-002·BK-WID-001) 전건 resolve. base 3건(BBD-001/003·BSZ-001) resolve. 전역 linkcheck BROKEN 11건은 cpq-options/silsa/product-accessory 발신(동시편집 family)이며 stationery 역링크 무손상.
- **W3**: 검증 앵커 — bdl_unit_typ_cd(존재)·QTY_UNIT.03=권·USAGE.01/02/03/05/07·PROC_000017 자식(트윈링021)·미싱제본 MISSING(030 부모NULL·074 부모056=제본 아님)·CAT_000300 고아(upr NULL)·CAT_000119~123 upr=008 노드명 매칭·MAT_000186=MAT_TYPE.08·option_groups 0·prices 0행 — **prd_typ_cd 1건 제외 전건 라이브 일치**.
- **W4**: ✅2(ST-ID-001/002 tier C round-13 GO 산출)·🟡9·🔴8(미적재/교정대기 정직 표기)·⚪1. 🟡 출처로 ✅ 단 사례 없음. 인플레 0.
- **W5**: `출처:` 라인에 v03 xlsx·price-engine-ddl 인용 0. v03 문자열은 전부 "전파기/진원/금지" 맥락(load_master oracle은 로직만·tier A).
- **W7**: index.md:47 1줄+🟡 일치·log.md:11~14 INGEST/INDEX/LINK append.
- **W8**: 0정체(prd_cd 목록+typ)·1차원(size+3축 page_rule/장수/묶음수)·2BOM(usage_cd 슬롯+proc_cd)·3가격(고정가형+round-2 미실행 명시)·4CPQ·5위젯(축링크)·6적재(load_master 시트10/11~21+FK순 [[LP-003]]) 전 단계 구체 입력 또는 resolve 가능 축링크 제공. dry walk-through 가능.

---

## 재현 (비밀값 제외)

```bash
# linkcheck
python3 _qa/scripts/linkcheck.py

# W1/W3 라이브 (자격증명 .env.local RAILWAY_DB_*)
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "
SELECT prd_cd, prd_typ_cd FROM t_prd_products WHERE prd_cd BETWEEN 'PRD_000172' AND 'PRD_000181' OR prd_cd IN ('PRD_000097','PRD_000098') ORDER BY prd_cd;
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE cod_cd LIKE 'PRD_TYPE%' ORDER BY cod_cd;
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000097';
SELECT count(*) FROM t_prd_product_price_formulas WHERE frm_cd ILIKE '%TTEOK%';
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd ILIKE '%TTEOK%';
SELECT cat_cd, cat_nm, upr_cat_cd FROM t_cat_categories WHERE cat_cd IN ('CAT_000300','CAT_000119','CAT_000120','CAT_000121','CAT_000122','CAT_000123');
SELECT proc_cd, proc_nm, upr_proc_cd FROM t_proc_processes WHERE proc_nm LIKE '%미싱%';
SELECT mat_cd, mat_nm, mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000186';
"
```
