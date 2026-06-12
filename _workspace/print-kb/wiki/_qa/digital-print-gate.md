# digital-print W-gate verdict — CONDITIONAL-GO (2026-06-12)

> 대상 `wiki/recipes/digital-print.md` · 검증자=pkw-wiki-qa(생성자 독립). 모든 FAIL=(블록 인용)+(재현 반대증거) 쌍. 라이브=권위(round-8 교훈) — 라이브 직접 재측정, 생성자/round-13 산출 신뢰 안 함.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 |
| W2 링크 무결성 | PASS | 0 (digital-print) / sticker 3건 escalate |
| W3 스키마 앵커 | **FAIL** | 1 (SCHEMA-MISMATCH) |
| W4 badge 정합 | PASS | 0 |
| W5 stale/v03 전파 | PASS | 0 |
| W6 CQ 커버리지 | PASS | 0 |
| W7 index/log 일관성 | PASS-with-Low | 1 (badge 카운트) |
| W8 실행가능성 | PASS | 0 (단 D-1 의존) |

종합: **CONDITIONAL-GO** — 치명(FABRICATED) 0, 라이브 재측정으로 SCHEMA-MISMATCH 1 + STALE 1(라이브가 round-13 이후 변경됨) 적발. 둘 다 단일 블록 보정으로 해소 가능(구조/스키마 재설계 불요). W8 dry walk-through는 끊김 없음.

---

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|----|------------|--------|------|-----------|-----------|
| DP-F1 | digital-print.md:82 [DGP-DM-004] | W3 | **SCHEMA-MISMATCH** | 앵커 `t_prd_product_bundle_qtys(qty_unit)`. 라이브 `information_schema.columns WHERE table_name='t_prd_product_bundle_qtys'` → 컬럼 = `prd_cd,bdl_qty,bdl_unit_typ_cd,dflt_yn,disp_seq,...` — **`qty_unit` 컬럼 부존재**. 실제 단위 컬럼=`bdl_unit_typ_cd`(distinct 값 QTY_UNIT.01~04, .02="매" 실재). round-8 tags jsonb와 동형(문서 컬럼명 ≠ 라이브). | 앵커를 `t_prd_product_bundle_qtys(bdl_unit_typ_cd)`로 정정. 값(QTY_UNIT.02 매)은 정답 유지. |
| DP-F2 | digital-print.md:164 [DGP-CPQ-002] / :167 C-04 인용 | W3/W1 | **STALE-CITED** (라이브 변경) | 블록 주장 "라이브 TMPL-000005 **1행만** → 정답: 다수" {🔴 교정대기}. 라이브 `SELECT tmpl_cd,reg_dt FROM t_prd_product_addons WHERE prd_cd='PRD_000016'` → **5행**(TMPL-000005/006/009/010/011). reg_dt: 006/009/010/011 = **2026-06-12 16:23~16:31 신규 INSERT**(round-13 소스 06-10 이후·위키 집필 시점 전후). 즉 C-04 교정이 라이브에 **이미 적용됨** → "1행만·MIS-LOADED 교정대기" 전제 무효. (DB 전체 addon=5행 전부 016 소속.) | [DGP-CPQ-002] 라이브 현재값을 "TMPL-000005/006/009/010/011 5행(06-12 교정 적용됨)"으로 갱신, badge 🔴→🟡 또는 ✅(C-04 RESOLVED 표기). [DGP-ST-002]·§7 양면표의 addon=0/1 전제도 동반 재확인. **단 카테고리 고아(C-09/14)는 라이브 미교정 확인(043~046→CAT_000296 여전)** — ST-001 유효. |
| DP-F3 | digital-print.md:80-81 [DGP-DM-004] 내용 | W1 | STALE(Low) | 블록 "전 디지털 상품 `qty_unit`=QTY_UNIT.02(라이브 값은 후속 보정 산물)". 라이브 `SELECT FROM t_prd_product_bundle_qtys WHERE prd_cd IN ('PRD_000016','024','031','043','046','047')` → **0행**(샘플 디지털 상품 bundle_qtys 미적재). "라이브 값=후속 보정 산물"은 행 존재를 함의하나 실측은 0행. 블록이 "경로불명"으로 헤지하나 "값정답(라이브)" 표현은 부정확. | "라이브 bundle_qtys 행 부재(샘플 0행) — QTY_UNIT.02는 정답값(코드 실재)이나 라이브 미적재" 로 정밀화. |
| DP-F4 | digital-print.md 헤더 vs index/log | W7 | Low(BADGE-COUNT) | index:37·log "✅5·🟡13·🔴12". 실측 `grep '{badge}'` → ✅5·🟡10·🔴9(교정대기4+plain5)·⚪2 = 26블록. 🟡/🔴 카운트 불일치(13 vs 10, 12 vs 9). ✅5는 일치. | index/log 요약 카운트를 실측(🟡10·🔴9·⚪2)으로 정정. 치명 아님. |
| DP-F5 | sticker.md (범위 외) | W2 | escalate | full-graph linkcheck: `[[STK-ST-002]]`·`[[STK-BOM-001]]`(page-prefix 없는 self-ref → PAGE-MISSING)·`[[#STK-ST-005]]`(ANCHOR-MISSING). digital-print 링크그래프엔 무영향. | sticker 작가 재호출 finding. digital-print 23 역링크는 무손상(아래 재현). |

---

## 게이트별 재측정 상세

### W1 인용 실재성 (PASS)
인용 파일 전건 실재(Glob) + 라인 의미 대조:
- [DGP-ID-001/002/003] ← `17_correctness/digital-print/product-identity.md` §0 표(distinct 36·구분 7·F-ID-0 MIS-LABEL)·§1 정체확정표·F-ID-1/F-ID-2 — 위키 표(엽서8·포토카드3·접지카드4·명함10·상품권2·배경지4·인쇄홍보물5=36) 소스와 byte 수준 일치. 배경지=포장세트(F-ID-1, goods_view_102/product-master:82/172/380) 의미 일치.
- [DGP-DM-001~004]·[DGP-BM-001~004]·[DGP-PR-*]·[DGP-ST-*] ← `correction-manifest.md` C-01~C-18 표 — 분류(CORRECT/MIS-LOADED/MISSING/AMBIGUOUS)·정답값·심각도 모두 소스와 일치. F-PB-1식 "공란→MISSING 날조" 없음(MISSING은 라이브 0행 실측으로 교차확인됨, 아래 W3).
- [DGP-PR-001] PRF_DGP_A~F+COMP_PAPER ← `02_mapping/digital-print-engine/t_prc_price_formulas_DGP.csv`·design.md §2 — 6공식 실재. "308행 COMMIT"은 메모리 `dbmap-digitalprint-atomic-formula-unbuilt` 인용(블록 🟡, 정당).
- 날조 0. (단 W3에서 라이브가 일부 소스를 추월 — DP-F2.)

### W2 링크 무결성 (PASS · digital-print)
- recipe-aware linkcheck scope=digital-print → **BROKEN 0**.
- 역링크 race 검사: digital-print → huni/* 역링크 occurrence **27**(unique 18 항목). "중복" 6건은 전부 **서로 다른 축 항목**에서 같은 DGP 항목을 참조(one-to-many, 정당) — 동일 슬롯 내 중복 INSERT 아님(컨텍스트 확인: processes:18/40/57/109 등 각기 다른 `- 사용처:` 행). 유실 0·손상 0.
- 동시편집 공존: sticker 23·booklet 12 역링크 무손상 병존. digital-print의 23 참조(log 신고)는 unique-item 기준, 27은 occurrence — 모순 아님.

### W3 스키마 앵커 (FAIL → DP-F1)
라이브 information_schema/SELECT 읽기전용 재측정:
- 앵커 테이블 20종 전건 실재.
- 컬럼: `usage_cd`(materials)✅·`output_paper_typ_cd`(plate)✅·`frm_cd`(formulas)✅·`tmpl_cd`(addons)✅ — 그러나 **`qty_unit`(bundle_qtys) 부존재**(DP-F1). 실제=`bdl_unit_typ_cd`.
- 코드값 실재: QTY_UNIT.02(매)·OUTPUT_PAPER_TYPE.01(국전계열)·USAGE.07(공통)·PROC_000002/033/053/056 전건 실재.
- 라이브 데이터 교차확인: 016 size=7·046 size=3·016 proc=6·016 mat=21(USAGE.07)·043/044/046 proc=0(MISSING 확증)·카테고리 고아 043~046→CAT_000296·041/042→CAT_000295(정상노드 273/274/275/283=upr012 실재) — 위키 §7 양면표·DGP-ST-001 전건 라이브 일치.
- "앱 계산"/🔴GAP(판수·박 등급) 앵커 면제 표기 존재 → PASS 처리.

### W4 badge 정합 (PASS)
✅5 블록(ID-001/002/003·DM-001·ST-003) 전건 tier C13(round-13 GO 산출, FRESH) + 라이브 실측 확증(36/7·sizes 7/3·category 사실). 🟡권장 출처만으로 ✅인 인플레 0. 과소(권위인데 🔴) 없음.

### W5 stale/v03 전파 (PASS)
`- 출처:` 라인 전수에 v03/price-engine-ddl/constraint_json/dep_proc_cd 인용 0. 본문 v03 언급 3건(L109/206/245)은 전부 "v03 진원/입력 금지" 경고 맥락(허용). Sources STALE 블록(L284)에 인용금지 명문 격리.

### W6 CQ 커버리지 (PASS)
answers_cq 13건(unique 12 CQ): CQ-PROD-01/03/05/08/11·CQ-FILE-05·CQ-PROC-01·CQ-FIN-05·CQ-PRICE-01/03/04/06 — 전건 `_workspace/print-kb/cq-registry.md` 실재. family 관련 그룹(PROD·PRICE·PROC·FIN·FILE) 커버. 80%+ 충족.

### W7 index/log 일관성 (PASS-with-Low → DP-F4)
index:37·log 2건 등재. badge 요약 카운트만 실측과 불일치(Low).

### W8 실행가능성 (PASS)
dry walk-through(엽서 신상품 1개 등록): 0정체(ID-001/002 prd_cd 범위)→1차원(DM-001 size 이산행·DM-003 plate OUTPUT_PAPER_TYPE.01·DM-004 단위)→2BOM(BM-001 자재 usage_cd·BM-002 공정 라우트)→3가격(PR-001 PRF_DGP_A 배선)→4CPQ(CPQ-001 엽서 파일럿 ref_dim_cd, [[../huni/cpq-options]] 참조)→5위젯(WID-001/002 정규화 계약)→6적재(LP-001 oracle·LP-002 FK위상·멱등). 각 단계 구체 입력(테이블·컬럼·코드값·[[축]]) 제공 — 끊긴 단계 없음. 단 LOADED=행존재 검증 한계(round-7 D-1) 상속: BM-003/ST-002 MISSING·CPQ 미적재는 정직 표기됨.

---

## 재현 (비밀값 제외)

```bash
# W2 recipe-aware linkcheck
python3 /tmp/linkcheck_dp.py   # (scope=digital-print → BROKEN 0; full-graph → sticker 3)

# 역링크 race
cd _workspace/print-kb/wiki
grep -roh '\[\[recipes/digital-print#[^]]*\]\]' huni/ | sort | uniq -c

# W3 라이브 재측정 (읽기전용)
set -a; source .env.local; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
PG="psql -h $RAILWAY_DB_HOST -p $RAILWAY_DB_PORT -U $RAILWAY_DB_USER -d $RAILWAY_DB_NAME -tAc"
# DP-F1: bundle_qtys 컬럼
$PG "SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_bundle_qtys' ORDER BY ordinal_position"
# DP-F2: 016 addon 행수·reg_dt
$PG "SELECT tmpl_cd,reg_dt FROM t_prd_product_addons WHERE prd_cd='PRD_000016' ORDER BY reg_dt"
# DP-F3: 디지털 bundle_qtys 0행
$PG "SELECT prd_cd,bdl_qty,bdl_unit_typ_cd FROM t_prd_product_bundle_qtys WHERE prd_cd IN ('PRD_000016','PRD_000043','PRD_000047')"
# 라이브 일치 확증
$PG "SELECT prd_cd,count(*) FROM t_prd_product_sizes WHERE prd_cd IN ('PRD_000016','PRD_000046') GROUP BY prd_cd"
$PG "SELECT pc.prd_cd,pc.cat_cd FROM t_prd_product_categories pc WHERE pc.prd_cd IN ('PRD_000041','PRD_000043','PRD_000046') ORDER BY 1"
```

---

## 재측정 (2026-06-12 · 보정 검증 · pkw-wiki-qa)

> 1차 CONDITIONAL-GO 4 finding(DP-F1~F4) writer 보정 완료 신고 → 불신·재측정. 라이브 read-only psql 실측 + 보정 블록 한정 + W1/W2/W5 회귀.

| finding | 1차 분류 | 보정 검증 결과 |
|---|---|---|
| DP-F1 | SCHEMA-MISMATCH | **RESOLVED** — [DGP-DM-004] 앵커 `t_prd_product_bundle_qtys(bdl_unit_typ_cd)`. 라이브 `information_schema` → `qty_unit` 부존재·`bdl_unit_typ_cd` 실재 확인. 값 QTY_UNIT.02(매) 정답 유지. tags `#bdl_unit_typ_cd`. |
| DP-F2 | STALE-CITED | **RESOLVED** — [DGP-CPQ-002] badge 🔴→✅, 내용 "라이브 5행(TMPL-000005/006/009/010/011)". 라이브 재측정: 016 addon **5행**, reg_dt 006/009=06-12 16:23·010=16:30·011=16:31(신규 INSERT=C-04 교정 적용)·005=06-08. 양면표기·출처 `{tier C13, FRESH}` 동반 갱신. 정합. |
| DP-F3 | STALE(Low) | **RESOLVED** — DP-F1 블록에 통합. "샘플 016/043/047 bundle_qtys 0행=라이브 미적재" 명문. 라이브 재측정 0행 확인. load_master.py:269 단위 None 귀속. |
| DP-F4 | BADGE-COUNT(Low) | **RESOLVED** — index `✅6·🟡10·🔴8·⚪2`. 실측 census: ✅6·🟡10·🔴8(plain 5+교정대기 3)·⚪2 = 26블록. 일치. |

**회귀(보정이 finding 외 손상 안 냈는지):**
- W2: `_qa/scripts/linkcheck.py`(recipes 포함 현행) 전체 실행 → **BROKEN 0**(digital-print 무손상).
- W1/W5: 보정 블록(DGP-DM-004·DGP-CPQ-002)의 `출처:` 라인 의미 재대조 — 인용 소스(correction-manifest C-04/C-15)+라이브 재측정 일치, 날조 0. v03/STALE 신규 인용 0(보정으로 인한 stale 전파 0).
- 카테고리 고아 미교정 확인(라이브 043/046→CAT_000296 여전) → ST-001 유효 보존(보정이 정직성 훼손 안 함).

**재판정: GO.** 4 finding 전건 RESOLVED·치명 0·회귀 손상 0.
