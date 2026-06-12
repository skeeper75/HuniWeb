# global W-gate verdict — CONDITIONAL-GO (2026-06-12)

> scope = 전체 위키(10 recipes + 7 huni축[modeling-axioms+6] + 7 base). Phase 4 횡단 전역 lint 마일스톤.
> 검증자 독립 재측정(라이브 information_schema read-only · linkcheck.py 실행 · CQ comm · 배치3 회귀 · W8 dry walk-through).

| 게이트 | 결과 | findings |
|---|---|---|
| W2 링크 무결성(전역) | PASS | BROKEN 0 · 고아 0 |
| W3 스키마 앵커(라이브 실측) | PASS | 0 SCHEMA-MISMATCH |
| W4 badge 정합 | PASS | 0 BADGE-INFLATED |
| W5 stale/v03 전파 차단 | PASS | 0 STALE-CITED · v03 베어인용 0 |
| W6 CQ 총커버리지 | PASS | 핵심 family-assembly 20/22=90%(≥80%) · README:144 경로 명시 확인 |
| W7 index/log 일관성 | PASS | 24/24 페이지 등재 · badge 카운트 정합 · llms.txt 형식 |
| 축 양방향 정합(표본) | COND | BIDIR-INCOMPLETE 34 anchor(고팬인 사용처 미열거) |
| 배치3 보정 회귀 | PASS | 4 family 보정 반영·라이브 확증·손상 0 |
| W8 dry walk-through(digital-print) | PASS | 6단계 전부 구체 입력 제공 |

**종합: CONDITIONAL-GO** — 치명(FABRICATED/SCHEMA-MISMATCH/STALE/W8-FAIL) 0건. 잔존은 Low(축 사용처 백링크 미완 34 + CQ 태그 누락 2)뿐.

---

## 게이트별 증거

### W2 링크 무결성 — PASS
- `python3 _qa/scripts/linkcheck.py` → `BROKEN: 0`.
- 고아 검사(scope page + index + README + log 의 모든 [[..]]/마크다운 링크 타깃 집계 → scope 페이지 중 피링크 0 검출): **0 고아**. 24 페이지 전부 index 또는 타 페이지에서 참조됨.

### W3 스키마 앵커(라이브 information_schema read-only) — PASS
- 접속: `t_%` 41 테이블 CONNECTED.
- 인용 t_* 테이블 전수 실존(t_proc_processes·t_prd_product_*·t_prc_*·t_mat_*·t_siz_*·t_prd_template_prices 등 22종 1=존재).
- **STALE-삭제 컬럼 정확**: `constraint_json`·`dep_proc_cd` 라이브 부존재(Phase11 삭제) — 위키 STALE 경고와 일치. `t_prd_product_process_excl_groups`·`pricing_dims`·`use_dims` 라이브 부존재 — calendar/sticker "Phase11 삭제·라이브 아님" 주장 정확.
- 코드값 실측: `PROC_000002`=UV(acrylic 정답 앵커 일치)·PROC_000053/080/081/082/030/007 실존. `MAT_000186`=레더(화이트) `MAT_TYPE.08`(silsa/photobook "현재값 .08·정답 .06" 양면표기의 현재값 라이브 확증).
- 가격 사슬 라이브 검증: `t_prc_price_formulas.frm_cd` = PRF_BIND_SUM·PRF_DGP_A~F·PRF_PCB_FIXED·PRF_POSTER_FIXED 등 16행 실존. PRF_PBK_PAGEBAND·PRF_CAL 부존재(위키 "라이브 미적재" 정확). PRF_BIND_SUM↔PRD_000068~071 바인딩 실존. 떡메모지 PRD_000097 바인딩 0행(위키 정확)·PRF_TTEOKME_FIXED 마스터 1행. COMP_PCB component_prices **468행**(booklet "468행, 인용소스 234는 부분집계" 정정 라이브 확증).
- option_items 전역 18행(전부 일반현수막 PRD_000138 og3 — silsa "CPQ 전면 미적재 except 일반현수막 og3/oi18" 정확).
- 배치3 W3 재측정: product-accessory PRD_000016 addon **5행**·t_prd_product_addons 컬럼 = (prd_cd,tmpl_cd,…)[addon_prd_cd 부존재=위키 레거시 표기 처리 정확]. stationery PRD_000097=PRD_TYPE.04·PRD_000098=PRD_TYPE.02 일치.

### W4 badge 정합 — PASS
- ✅ 블록 전수(recipes 44+huni 3) 출처 표본 추출 → 전부 tier A(webadmin sql/code HEAD)·B(mapping/price)·C13/C11(round-13/11 correctness GO·FRESH·라이브 독립 SELECT 재현). 🟡-only 문서를 ✅로 단 사례 0. 개방 사실은 일관되게 🟡/🔴, 라이브검증/GO-round 사실만 ✅.

### W5 stale/v03 전파 차단 — PASS
- `prdmaster_full_migration_v03_20260518.xlsx` 인용 2곳: 둘 다 `[HARD] 인용 금지`/`STALE` 경고 블록 내(격리). 출처라인은 `load_master.py:39`(전파기 코드)·correctness-audit notes(v03=결함진원 입증)만 — v03을 데이터 권위로 인용한 사례 0.
- `price-engine-ddl` 인용 전부 `[PE-STALE]·STALE·인용 금지` 격리 블록. 레시피 Sources에 "price-engine-ddl 인용 0(STALE)" 명시. round-14 진단(I-1~7) 반영.

### W6 CQ 총커버리지 — PASS
- 답변 CQ-ID 31종 distinct·전부 cq-registry 실재(PHANTOM 0)·양방향(answers_cq 슬롯 10/10 recipe 보유).
- 핵심 family-assembly CQ(PROD/PRICE/PROC/FIN 22종) **20/22=90%** ≥ 80% 목표.
- README:144 = `위키 = CQ 레지스트리(../cq-registry.md — 위키 상위 _workspace/print-kb/cq-registry.md)` 경로 명시 확인.

### W7 index/log 일관성 — PASS
- 24/24 페이지(10 recipes+7 huni+7 base) index 등재.
- index badge 카운트 = 페이지 실제 블록 카운트 정합(silsa ✅5·🟡10·🔴8·⚪2 / acrylic ✅4·🟡10·🔴11·⚪2 / digital-print ✅6·🟡10·🔴8·⚪2 전건 일치).
- index = llms.txt 형식(H2+불릿+콜론·README §8). log.md = 배치3 CONDITIONAL→보정 마일스톤 + 레시피/INDEX/INGEST 기록 보유.

### W8 dry walk-through(digital-print 신규 엽서 등록) — PASS
| 단계 | 페이지가 제공한 구체 입력 |
|---|---|
| 0 정체 | DGP-ID-001/002: `t_prd_products`·`t_cat_categories` 일반인쇄물·엽서 구분 |
| 1 차원 | DGP-DM-001/003/004: `t_prd_product_sizes`(이산 7행)·plate OUTPUT_PAPER_TYPE.01·bundle `bdl_unit_typ_cd=QTY_UNIT.02` |
| 2 BOM | DGP-BM-001/002: `t_prd_product_materials.usage_cd=USAGE.07`·`t_prd_product_processes` 라우트 |
| 3 가격 | DGP-PR-001: `t_prc_price_formulas` PRF_DGP_A~F+COMP_PAPER 원자합산(PRF 라이브 실존 확인) |
| 4 CPQ | DGP-CPQ-001/002: option_groups/items polymorphic ref_dim_cd·addon `t_prd_product_addons(tmpl_cd)` |
| 6 적재 | DGP-LP-001/002: webadmin sql+load_master·FK 위상순서·멱등 name UPSERT·search-before-mint |
- 모든 단계가 구체 테이블·컬럼·코드값 또는 답하는 축 [[link]] 제공. "다른 문서 봐야 앎" 단계 0.

---

## Findings (전부 Low — CONDITIONAL)

| ID | 페이지#블록 | 게이트 | 분류 | 증거 | 보정 제안 |
|---|---|---|---|---|---|
| GL-1 | huni/* 34 anchor(MAT-005·CPQ-GAP-1·WID-GAP-3·LP-GAP-3/4·PE-010 등) | 축 양방향 | BIDIR-INCOMPLETE | 백링크 감사: recipe→axis 680 링크 중 100건이 대상 축 블록 `사용처:`에 해당 recipe 미열거. 고팬인 anchor일수록 심함(MAT-005 9 linker 중 5 누락·CPQ-GAP-1 10 중 4). forward 링크는 전부 resolve(W2 BROKEN 0)·축 anchor 26/60 완전 양방향 | 고팬인 공유/GAP anchor의 `사용처:` 슬롯을 전 인용 recipe 열거로 확장(또는 "전 family 공통" 명시). writer 재호출·집필 아닌 슬롯 보강 |
| GL-2 | recipes(booklet/photobook BOM·dimension 블록) | W6 | COVERAGE-GAP(Low) | CQ-PROC-06(제본 8종 물리차이)·CQ-PROD-07(size 목록+비규격 허용)이 본문 내용엔 존재하나 `answers_cq:` 태그 미부착 → 역추적 누락 | 해당 블록에 `answers_cq: CQ-PROC-06`·`CQ-PROD-07` 태그 추가(내용 변경 0) |

## 잔존 — 비-finding(정당)
- goods-pouch plate "122행/85상품"은 🟡 "정합 재판정 필요" 플래그된 개방 항목(✅ 단정 아님). 라이브 plate 총 424행·카테고리명 직매칭 46/26 — family 범위는 round-13 상품 range 기준이라 카테고리명 단순 join과 불일치는 정상. SCHEMA-MISMATCH 아님(테이블 실존·값 미단정).

---

## 재현(비밀값 제외)
```bash
# W2
python3 _qa/scripts/linkcheck.py                 # BROKEN: 0
# 고아: scope+index+README+log 링크타깃 집계 vs scope 페이지 → 0

# W3 (라이브, .env.local RAILWAY_DB_*)
set -a; source .env.local; set +a
PSQL(){ PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
PSQL "SELECT count(*) FROM information_schema.columns WHERE column_name IN ('constraint_json','dep_proc_cd')"  # 0
PSQL "SELECT frm_cd FROM t_prc_price_formulas ORDER BY frm_cd"                                                # 16행
PSQL "SELECT count(*) FROM t_prc_component_prices WHERE comp_cd LIKE 'COMP_PCB%'"                             # 468
PSQL "SELECT count(*) FROM t_prd_product_addons WHERE prd_cd='PRD_000016'"                                    # 5
PSQL "SELECT mat_cd,mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000186'"                                # MAT_TYPE.08
PSQL "SELECT count(*) FROM t_prd_product_option_items"                                                        # 18

# W5
grep -rnE 'prdmaster_full_migration_v03|price-engine-ddl' base/ huni/ recipes/   # 전부 STALE/인용금지 격리

# W6
grep -rohE 'CQ-[A-Z]+-[0-9]+' recipes/ huni/ | sort -u   # 31종·전부 registry 실재

# 축 양방향 감사 + index badge 정합: python 인라인(verdict 본문)
```
