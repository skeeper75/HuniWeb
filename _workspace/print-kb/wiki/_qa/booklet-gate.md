# booklet W-gate verdict — CONDITIONAL-GO (2026-06-12)

대상: `recipes/booklet.md` (원자 블록 20 · badge ✅4·🟡10·🔴5·⚪1). 검증자 독립 재측정(생성자≠검증자). 라이브 read-only psql 실측 수행.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (날조 0 — 인용 13 소스 라인단위 의미 대조 일치) |
| W2 링크 무결성 | PASS | 0 (outbound 0 broken·역링크 슬롯 10 reciprocal·결번 dangling 0) |
| W3 스키마 앵커 | **FAIL** | 3 (SCHEMA-MISMATCH 1 High + 2 Low 컬럼명) |
| W4 badge 정합 | PASS | 0 (✅4 전부 round-13 GO tier·라이브 재현 corroborated) |
| W5 stale/v03 차단 | PASS | 0 (v03·price-engine-ddl 인용 0 — 전부 STALE 마커/부정 참조) |
| W6 CQ 커버리지 | PASS | 0 (answers_cq 14건 전건 `cq-registry.md` 실재·양방향) |
| W7 index/log 일관성 | PASS | 1 Low (log INGEST 🟡11 표기 vs 실제 🟡10) |
| W8 실행가능성 | PASS | 0 (0→6 dry walk-through 전 단계 구체 입력 or [[link]] 해소) |

**종합: CONDITIONAL-GO.** 치명 발견 1건(W3 BK-PRC-002 PRF_TTEOKME_FIXED 라이브 부존재 — F-PB-1 동형: 인용 소스의 "✓"가 라이브 갭을 은폐). 단 이 finding은 **블록 단위 교정**(BK-PRC-002 + §7 적재현황 양면표기로 전환)으로 닫히며 페이지 구조 결함이 아니므로 NO-GO 아닌 CONDITIONAL-GO. 나머지 2 W3는 컬럼명 정밀화(Low). W6은 `cq-registry.md`가 wiki 상위(`_workspace/print-kb/cq-registry.md`)에 실재 — booklet answers_cq 14건 전건 등재 확인(PASS).

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-BK-1 | booklet#BK-PRC-002 + §7 적재현황 | W3 | **SCHEMA-MISMATCH (High)** | 블록: "떡메모지(PRD_000097) = **PRF_TTEOKME_FIXED + 112행 이미 적재**"; §7: "PRF_TTEOKME_FIXED ... 라이브 적재됨". 라이브: `SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000068' AND 'PRD_000098'` → **PRD_000097 바인딩 0행**. `SELECT count(*) FROM t_prd_product_price_formulas WHERE frm_cd ILIKE '%TTEOK%'` → **0** (frm_cd PRF_TTEOKME_FIXED 부존재). component_prices만 존재: `COMP_TTEOKME=112`. 인용 소스 `02_mapping/.../mapping.md` L124가 "PRF_TTEOKME_FIXED ✓"라 단언했으나 라이브 미확인(F-PB-1 동형 — 소스의 ✓가 갭 은폐). | BK-PRC-002를 양면표기로: "라이브 현재값=떡메모지 가격공식 미바인딩(component_prices COMP_TTEOKME 112행만 존재) → 정답=PRF_TTEOKME_FIXED 공식 신설+바인딩 필요(미적재)". §7 적재현황의 PRF_TTEOKME_FIXED를 "미적재/BLOCKED"로 이동. 엽서북 PRF_PCB_FIXED는 PRD_000094 바인딩 라이브 확인됨(유지). |
| F-BK-2 | booklet#BK-BOM-001 | W3 | SCHEMA-MISMATCH (Low) | 앵커 `t_mat_materials.mat_typ`. 라이브 컬럼명 = `mat_typ_cd` (`mat_typ` 부존재: `SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name LIKE '%typ%'` → mat_typ_cd, sel_typ_cd). | 앵커를 `t_mat_materials.mat_typ_cd`로 정정(round-8 tags jsonb 교훈 — 컬럼명 권위=라이브). |
| F-BK-3 | booklet#BK-DIM-003 | W3 | SCHEMA-MISMATCH (Low) | 앵커 `t_prd_product_bundle_qtys(bdl_qty·bdl_unit=QTY_UNIT.03)`. 라이브 컬럼명 = `bdl_unit_typ_cd` (`bdl_unit` 부존재). 값 자체(QTY_UNIT.03)는 라이브 일치: `SELECT prd_cd,bdl_qty,bdl_unit_typ_cd FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000097'` → 50/100 QTY_UNIT.03. | 앵커를 `bdl_unit_typ_cd=QTY_UNIT.03`로 정정. |
| F-BK-4 | log.md#16 INGEST | W7 | (Low) | log INGEST "badge ✅4·🟡11·🔴5". 실제 booklet 블록 badge: ✅4·🟡10·🔴5·⚪1(`grep -oE '\{(✅|🟡|🔴...|⚪...)\}'`). 🟡 1건 과대 표기 + ⚪1 누락. | log INGEST 행 🟡11→🟡10·⚪1 정정. 경미. |

> **취소된 finding(검증자 자기교정):** 초안의 F-BK-4(W6 cq-registry 부존재)는 **오판**. `cq-registry.md`는 wiki 상위 `_workspace/print-kb/cq-registry.md`에 실재(검증자 1차 `find`가 `wiki/` 하위로만 스코프). booklet answers_cq 14건 전건 등재 확인(`grep` 14/14 OK) → W6 PASS. 증거쌍 원칙 적용해 철회.

## 비파괴 확인 (반증 의심 → CORRECT 입증, finding 아님)

- **BK-2 PRD_000078 sub_prd 오적재**(Top finding): 라이브 = USAGE.01/.02 둘 다 MAT_000105 몽블랑 130g 2행. 정답=빈 껍데기. **양면표기 정확**(블록·correction-manifest BK-2 일치).
- **BK-CAT 고아**: CAT_000100/101/102/103/106/107 = 상품 0, CAT_000105 = 22, 068~071 = CAT_000006 lvl1 직결. **양면표기 정확**.
- **BK-3 레더 .08→.06**: MAT_000186=MAT_TYPE.08(077 표지 연결), MAT_000008/173/174/175=MAT_TYPE.06 전부 상품 0(고아 4행). **정확**.
- **BK-9 option_groups 0행·BK-7 plate NULL(32/32)·page_rule(068 4~28/4·069 24~300/2·094 20~30/10·097 3/3/3)·COMP_BIND_*(8/8/8/8·6/6/6)·COMP_TTEOKME 112·COMP_PCB 4×117·PROC_000017 자식8·박색 PROC_000037~044·형압 050/051/052·068~071 PRF_BIND_SUM 바인딩**: 전부 라이브 일치.
- **참고(소스 정밀도)**: 엽서북 "234행"은 소스가 COMP_PCB 4컴포넌트 중 2개(S1_20P+S2_20P=117+117)만 집계한 수치. 라이브는 4×117=468행. 페이지 주장은 소스 충실 전사(날조 아님)이나 라이브 정밀도와 상이 — F-BK-1 교정 시 함께 정밀화 권장(non-blocking).

## W2 상세 (역링크 슬롯 race 검사)

- booklet outbound `[[...]]`: 0 broken (recipes 포함 anchor universe로 재실행).
- booklet → huni 역링크 슬롯 10 distinct: BK-LP-001(load-path×2), BK-CPQ-002·BK-CPQ-001(cpq), BK-BOM-001·BK-ID-002·BK-DEF-001(materials), BK-BOM-002(processes), BK-PRC-001·BK-PRC-002(price-engine), BK-WID-001(widget) — 전부 실재 anchor로 resolve. 손상·중복·유실 0.
- digital-print·sticker 동시편집 공존 확인: load-path/cpq/processes/materials/price-engine/widget 각 `- 사용처:` 행에 3 family 슬롯 병존(clobber 0).
- 결번 BK-DEF-002/003/004/006: 위키 전역 어떤 참조도 없음(`grep -rn 'BK-DEF-00[2346]'` → 0) → dangling 자기참조 0. writer 의도 결번 정합.

## 재현 명령 (비밀값 제외)

```bash
# W2 (recipes 포함 universe)
cd _workspace/print-kb/wiki && python3 - <<'PY'  # (anchor universe = base+huni+recipes)
# ...lc2 변형: scope=recipes/booklet.md, universe includes recipes/*  → broken 0
PY
grep -rohE 'recipes/booklet#[A-Z0-9-]+' huni/*.md | sort -u   # 10 distinct slots
grep -rn 'BK-DEF-00[2346]' recipes/ huni/ base/ index.md log.md   # 0 → no dangling

# W3 (read-only, .env.local RAILWAY_DB_*) — full set in _qa/scripts/w3-booklet.sql
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -f _qa/scripts/w3-booklet.sql

# W5 / W7
grep -nE '^- 출처:' recipes/booklet.md | grep -iE 'v03|price-engine-ddl|prdmaster'  # 0 → PASS
grep -n 'recipes/booklet' index.md ; grep -niE 'booklet|책자' log.md
```

## 재게이트 트리거

F-BK-1(High) 보정(BK-PRC-002 + §7 양면표기 전환) 후 BK-PRC-002 1블록만 재측정(부분 재실행). F-BK-2/3 컬럼명·F-BK-5 log은 동시 정정 가능(재측정 불요·자명). F-BK-4(cq-registry)는 orchestrator 인프라 결정 대기 — booklet 재게이트 차단 사유 아님.

---

## 재측정 (2026-06-12 · 보정 검증 · pkw-wiki-qa)

> 1차 CONDITIONAL-GO 4 finding(F-BK-1 High·F-BK-2/3 Low·F-BK-4 Low) writer 보정 완료 신고 → 불신·재측정. 라이브 read-only psql 실측.

| finding | 1차 분류 | 보정 검증 결과 |
|---|---|---|
| F-BK-1 | SCHEMA-MISMATCH(High) | **부분 RESOLVED → 신규 잔존 F-BK-5.** 양면표기 전환·§7 PRF_TTEOKME_FIXED를 미적재/BLOCKED로 이동·엽서북 468행 정밀화는 정확(라이브 확인). **단 "frm_cd PRF_TTEOKME_FIXED 부존재" 주장은 라이브와 불일치** — 아래 F-BK-5. PRD_000097 바인딩 0행(정답=바인딩 필요)은 정확. |
| F-BK-2 | SCHEMA-MISMATCH(Low) | **RESOLVED** — [BK-BOM-001] 앵커 `mat_typ_cd`(line 82). 라이브 `mat_typ` 부존재·`mat_typ_cd` 실재 확인. |
| F-BK-3 | SCHEMA-MISMATCH(Low) | **RESOLVED** — [BK-DIM-003] 앵커 `bdl_unit_typ_cd=QTY_UNIT.03`(line 69). 라이브 PRD_000097 bundle_qtys = 50/100 QTY_UNIT.03 확인. |
| F-BK-4 | BADGE-COUNT(Low) | **RESOLVED** — log INGEST `✅4·🟡10·🔴5·⚪1`. 페이지 census ✅4·🟡10·🔴5·⚪1(20블록) 일치. |

**라이브 재측정 핵심(F-BK-5 근거):**
- `t_prd_product_price_formulas WHERE prd_cd='PRD_000097'` → **0행**(바인딩 미적재 — 정답 방향 정확).
- `t_prc_price_formulas WHERE frm_cd ILIKE '%TTEOK%'` → **1행 = PRF_TTEOKME_FIXED**(공식 마스터에 **실재**).
- `t_prc_component_prices WHERE comp_cd ILIKE '%TTEOK%'` → 112행(단가 존재).
- 엽서북: `t_prd_product_price_formulas WHERE prd_cd='PRD_000094'` → PRF_PCB_FIXED 1행·COMP_PCB component_prices 468행. **블록 양면표기·정밀화 정확.**

> **검증자 주의:** 1차 게이트 F-BK-1의 증거 쿼리 `t_prd_product_price_formulas WHERE frm_cd ILIKE '%TTEOK%' → 0`은 **바인딩 테이블** 기준이라 정당(바인딩 0행). 그러나 writer가 이를 "frm_cd PRF_TTEOKME_FIXED 부존재(공식 자체 없음)"로 일반화해 보정 블록·log에 전사 → 공식 **마스터**(`t_prc_price_formulas`)에는 PRF_TTEOKME_FIXED가 실재하므로 과대진술. 교정 방향(정답=바인딩 필요)은 맞으나 "공식 신설 필요"는 틀림(공식 존재·**바인딩만** 필요).

## 재측정 잔존 Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-BK-5 | booklet#BK-PRC-002 line 118-120 · §7 미적재행 · log.md FIX/INGEST | W3 | SCHEMA-MISMATCH(Low) | 블록: "frm_cd `PRF_TTEOKME_FIXED` 부존재(`SELECT count(*) WHERE frm_cd ILIKE '%TTEOK%' → 0`)" + "정답=PRF_TTEOKME_FIXED **공식 신설**+바인딩 필요". 라이브 `SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd ILIKE '%TTEOK%'` → **PRF_TTEOKME_FIXED 1행(공식 마스터 실재)**. 부존재는 `t_prd_product_price_formulas`(바인딩) 기준이지 공식 마스터 기준이 아님. | "공식 마스터 `t_prc_price_formulas`에 PRF_TTEOKME_FIXED **실재**하나, `t_prd_product_price_formulas` PRD_000097 **바인딩 0행**(+COMP_TTEOKME 112행 단가) → 정답=**바인딩만 적재 필요**(공식 신설 불요)"로 정밀화. "frm_cd 부존재" 문구의 테이블을 바인딩 테이블로 명시. §7·log FIX 행 동반. |

**재판정: GO(잔존 Low 1 — F-BK-5).** High finding F-BK-1의 본질(라이브 갭 은폐=F-PB-1 동형, 떡메모지 가격 미적재 양면표기)은 RESOLVED. 잔존 F-BK-5는 같은 사실의 **테이블 귀속 오기**(공식 마스터 vs 바인딩 — 교정 방향 정확·심각도 Low). 치명 0·구조 결함 0.

---

## 축 잔여 verdict — huni/materials (2026-06-12 · pkw-wiki-qa)

> 배치1 보정이 레시피 측 `mat_typ`→`mat_typ_cd`는 교정했으나(F-STK-4·F-BK-2 RESOLVED), 단일 사실 원칙의 권위 페이지인 축 `huni/materials.md`는 미교정. 레시피 작가들이 "축 동반은 별도 처리"로 명시 escalate(sticker FIX log).

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-AX-MAT-1 | huni/materials.md MAT-001(L13·앵커 L35)·MAT-003(L35)·MAT-005(L57·L64·L65) | W3 | SCHEMA-MISMATCH(Low·High 전파성) | 5곳 bare `mat_typ`(앵커 2곳 포함: `t_mat_materials.mat_typ`). 라이브 `SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name IN ('mat_typ','mat_typ_cd')` → **`mat_typ_cd`만**(`mat_typ` 부존재). 값 MAT_000186=MAT_TYPE.08(라이브 확인·정답 .06)·.07~.10 오염 도메인 의미는 정합. 축=단일 사실 권위라 미교정 시 향후 레시피가 축 참조로 오기 재유입 위험. | L13/35/57/64/65 5곳 `mat_typ`→`mat_typ_cd` 교정(앵커 2곳 우선). 라이브 컬럼 권위(round-8 tags jsonb·DP-F1 동형). pkw-recipe-writer 재호출 finding(검증자는 직접 수정 안 함). |

**축 materials verdict: CONDITIONAL — Low 1(F-AX-MAT-1).** 컬럼명 오기 1종 5곳·테이블/도메인값 정합·치명 0. 단 축은 단일 사실 권위라 레시피보다 우선 교정 권장.
