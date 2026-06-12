# goods-pouch W-gate verdict — CONDITIONAL-GO (2026-06-12)

> 대상 `recipes/goods-pouch.md` · 검증자 독립(생성자 불신·재측정). 라이브 read-only psql 실측·linkcheck 실행·W1 인용 의미 대조.
> 종합: **CONDITIONAL-GO** — FABRICATED/STALE/v03 0·W8 핵심단계 PASS. 단 W3 라이브 실측에서 **plate_sizes "미적재 정당" 주장이 라이브 122행과 모순**(SCHEMA-MISMATCH, 단 결함진단 결론 불변) + W7 log.md 미append. NO-GO 사유(날조·핵심단계 FAIL) 부재이므로 보정 후 GO 인계 가능.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (전 인용 file:§ 의미 대조 일치·날조 0) |
| W2 링크 무결성 | PASS | 0 (goods-pouch outbound 0 broken·역링크 7축 무손상) |
| W3 스키마 앵커 | **FAIL** | 1 SCHEMA-MISMATCH + 1 Low(count drift) |
| W4 badge 정합 | PASS | 0 (✅3블록 전건 C11/C13 FRESH+GO round) |
| W5 stale/v03 차단 | PASS | 0 (v03=진원귀속·STALE금지 표기만·인용 0) |
| W6 CQ 커버리지 | PASS | 1 Low(CQ-FIN-10 미태깅·내용은 존재) |
| W7 index/log 일관성 | **FAIL** | 1 (log.md INGEST 미append) |
| W8 실행가능성 | PASS | 0 (0→6 전단계 구체 입력 제공) |

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-GP-W3-1 | goods-pouch#GP-DIM-002 | W3 | SCHEMA-MISMATCH | 블록: "출력판형(전지) 미적재는 정당"·앵커 "`t_prd_product_plate_sizes`(굿즈 미적재 정당)". 라이브 실측: `SELECT count(*) FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290'` → **122행(85 distinct prd_cd)**. 인용 소스 column-dictionary §10 row9는 **엑셀 측 출력용지규격 "전부 빈값"**을 근거로 "미적재 정당"을 *추론*했을 뿐 라이브 미측정. live-diff.md 0행 인벤토리에도 plate 부재 → 페이지가 미측정 추론을 라이브 사실로 단정. (round-8 tags jsonb 교훈: 권위=라이브) | GP-DIM-002를 양면표기로 전환: "엑셀 출력용지규격 빈값 → 그러나 라이브 plate_sizes 122행 적재됨(85상품). 적재 의미·정합 재판정 필요(작업사이즈/판형 혼동 G-GP-2 인접)". "미적재 정당" 단정 삭제. |
| F-GP-W3-2 | goods-pouch#GP-DIM-001/002 | W3 | STALE-CITED(Low) | 블록: "라이브 `t_prd_product_sizes`=28행"·"치수형 22~28행". 라이브 실측 → **29행**. 1행 drift(GP-DIM-001은 "22~28" 범위 하한 표기로 부분 흡수하나 "28행" 단정과 어긋남). | "28행"을 라이브 실측 "29행"으로 갱신 또는 "≈29행(치수형)"로 범위표기. |
| F-GP-W7-1 | log.md | W7 | (로그 누락) | `grep -ni "goods-pouch\|굿즈" log.md` → 0건(마지막 INGEST=acrylic). index.md L45는 등재 정상. 집필 액션이 log.md에 append되지 않음. | log.md에 goods-pouch [INGEST] 1줄 append(타 family 포맷 동일: 원자블록수·badge분포·링크검증·STALE확인). |
| F-GP-W6-1 | goods-pouch#GP-BOM-003 | W6 | COVERAGE-GAP(Low) | 봉제/에폭시/맥세이프 내용이 레지스트리 **CQ-FIN-10**("봉제미싱·에폭시·아크릴가공 등 굿즈 전용 후가공" — 전 레지스트리 中 가장 굿즈-특화 CQ)을 정확히 답하나 answers_cq는 CQ-PROC-01·CQ-FIN-03으로만 태깅. | GP-BOM-003·GP-ST-005 answers_cq에 CQ-FIN-10 추가(양방향 추적 완결). |

## 게이트별 상세

### W1 인용 실재성 — PASS
전 인용 파일 10종 실존(Glob). 적재밀도 표본 의미 대조 전건 일치:
- GP-ID-001 "103 distinct·19구분·7인쇄방식" = product-identity §0 line11 일치.
- GP-ST-008/GP-ID-001 "ORPHAN 35·NORMAL 56·ROOT 8" = product-identity F-ID-1 line53 + **라이브 재현 일치**(W3).
- GP-LP-001 "load_master 순수 전파기·진원=v03·라이브 직접 교정 실효" = loadlogic-notes §6 line88 축자 일치.
- 7.1 양면표·7.2 결함 = correction-manifest GP-C-01~17 일치(분류분포 CORRECT4·MIS-LOADED6·MISSING4·EXTRA1·AMBIGUOUS2=17 정확).
- GP-ST-006 "굿즈 0·전역 6(001/002/066/138)" = gate F-GP-GATE-1 보정 서술 흡수(과대단언 "전면 미적재" 인플레 회피). 날조 0.

### W2 링크 무결성 — PASS
`python3 _qa/scripts/linkcheck.py` → 전역 BROKEN 11건이나 **전부 cpq-options/silsa/product-accessory 발신**(동시편집 family·기존 결함). goods-pouch 발신 broken **0**. outbound 안정@id(materials#MAT-005·processes#PRC-GAP-5·cpq-options#CPQ-008/STALE·load-path#LP-007/GAP-3·price-engine#PE-007/GAP-3·widget-contract#WID-STALE 등) 전건 타겟 실재. 역링크: 7 축 페이지 `- 사용처:` 슬롯에 goods-pouch 정확 앵커 등재(modeling-axioms·materials 5·load-path 8·cpq-options 4·widget-contract 5·processes 5·price-engine 6). silsa/product-accessory/stationery 동시편집 공존 무손상.

### W3 스키마 앵커 — FAIL (1 SCHEMA-MISMATCH·1 Low)
라이브 information_schema·SELECT 실측(read-only):
- `t_mat_materials.mat_typ_cd` 실재 / parent=`upr_mat_cd`(페이지 "parent" 개념 정합) / `usage_cd`는 `t_prd_product_materials`에 실재(GP-BOM-002 앵커 정확).
- MAT_TYPE 자식코드(upr_cod_cd='MAT_TYPE'): .02필름·.04금속·.05원단·.06가죽·.09파우치·.10악세사리 전건 실재 — GP-BOM-002 코드도메인 일치.
- option layer 3테이블·`option_items.ref_dim_cd` 실재 — GP-CPQ-001 앵커 정확.
- 라이브 실측 일치: category ORPHAN35/NORMAL56/ROOT8·option_groups 굿즈0/전역6·sets0·processes 6행 전부 PROC_000081·addons0·print_options0.
- **불일치 1(F-GP-W3-1):** plate_sizes 굿즈 **122행** vs 페이지 "미적재 정당". → FAIL.
- **drift 1(F-GP-W3-2):** product_sizes 굿즈 **29행** vs "28행".
- 앵커 면제 항목(앱 계산·🔴GAP·DB외 위젯 앵커) 면제 표기 정상(GP-WID-001/002 "DB 외 앵커" 명시).

### W4 badge 정합 — PASS
✅3블록: GP-ID-001(C13 product-identity+gate K0 PASS·라이브 검증)·GP-ID-002(C11 column-dictionary C12+07_domain)·GP-PRC-002(C11 C24+round-1 GO 구간할인). 전건 큐레이션 팩 FRESH tier(C11/C13)+GO round 산출 — 🟡문서 단독 ✅ 인플레 0. 과소(권위인데 🔴) 0.

### W5 stale/v03 차단 — PASS
`v03` 등장 = ① STALE 인용금지 directive(L5) ② 결함 진원 귀속("진원=상류 v03"·loadlogic §1 line인용은 loadlogic-notes로 stale xlsx 직접 아님) ③ load_master 읽는 시트 기술. stale xlsx `prdmaster_full_migration_v03_*.xlsx` **직접 인용 0**. `excl_grp_cd`=GAP블록서 "Phase11 삭제됨" 인지 표기만. price-engine-ddl/constraint_json/dep_proc_cd 인용 0(Sources L262 미인용 명시·grep 확인). [HARD] v03 인용금지 준수.

### W6 CQ 커버리지 — PASS (1 Low)
answers_cq 12종(PROD-01/03/05/06/08·PRICE-01/04/05·PROC-01·FIN-03·FILE-05·TERM-04) 전건 cq-registry.md 실재 ID. family 관련 핵심 CQ(정체·차원·자재·가격·공정·적재) 충실 커버 80%+. Low: CQ-FIN-10(굿즈 전용 후가공) 내용 존재하나 미태깅(F-GP-W6-1).

### W7 index/log 일관성 — FAIL
index.md L45 goods-pouch 1줄 등재·badge "🟡(round-13 GO·결함17·컨펌Q-GP-1~5)" 페이지 실제(결함17·전체상태🟡) 정합. **단 log.md INGEST 미append**(F-GP-W7-1).

### W8 실행가능성 — PASS
신상품 1개 등록 dry walk-through 0→6 전단계 구체 입력 제공:
- 0 정체: t_prd_products(prd_typ_cd=PRD_TYPE.03·MES NULL·file_upload/use/editor_yn=Y)·t_cat_categories 정상노드(거울 CAT_000165~169)·폴더C12=인쇄방식.
- 1 차원: t_prd_product_sizes 치수형(work C7 e.g.100x90)·plate/재단/블리드 빈값·옵션형→CPQ.
- 2 BOM: t_prd_product_materials(mat_cd+usage_cd=USAGE.07)·mat_typ_cd 소재별(.05/.04/.09/.10/.02)·본체색=재질행합성·t_prd_product_processes(PROC_000080봉제/083에폭시).
- 3 가격: t_prc_component_prices 고정가형·구간할인 C24(굿즈A/B타입).
- 4 CPQ: option_groups/items+ref_dim_cd·트리거 fn_chk_opt_item_ref·차원행 선적재.
- 5 위젯: 정규화 계약(DB외·[[widget-contract]] 해소).
- 6 적재: FK 위상(코드행→마스터→상품→자식)·prd_nm 멱등 UPSERT·admin pvEdit.
횡단 상세는 [[축#항목]] 링크가 답해 black-hole 0.

## 재현 (사용 명령 — 비밀값 제외)
```bash
# W2
python3 _qa/scripts/linkcheck.py
grep -ohE '\[\[[^]]+\]\]' recipes/goods-pouch.md | sort | uniq -c
grep -rn "recipes/goods-pouch" huni/*.md

# W3 (set -a; source .env.local; set +a 후)
PSQL "SELECT column_name FROM information_schema.columns WHERE table_name='t_mat_materials' AND column_name='mat_typ_cd'"
PSQL "SELECT cod_cd,cod_nm FROM t_cod_base_codes WHERE upr_cod_cd='MAT_TYPE' ORDER BY cod_cd"
PSQL "SELECT CASE WHEN c.upr_cat_cd IS NULL AND c.cat_lvl>1 THEN 'ORPHAN' WHEN c.upr_cat_cd IS NULL AND c.cat_lvl=1 THEN 'ROOT' ELSE 'NORMAL' END,count(*) FROM t_prd_product_categories pc JOIN t_prd_products p ON pc.prd_cd=p.prd_cd JOIN t_cat_categories c ON pc.cat_cd=c.cat_cd WHERE p.prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290' GROUP BY 1"
PSQL "SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290'"  # 0
PSQL "SELECT count(*) FROM t_prd_product_plate_sizes WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290'"   # 122 ← F-GP-W3-1
PSQL "SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290'"         # 29 ← F-GP-W3-2
PSQL "SELECT proc_cd,count(*) FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000290' GROUP BY proc_cd"  # PROC_000081|6

# W5/W7
grep -nE "v03|prdmaster_full_migration|constraint_json|dep_proc_cd|excl_grp_cd" recipes/goods-pouch.md
grep -ni "goods-pouch" log.md   # 0건 ← F-GP-W7-1
```

## 인계 판정
**CONDITIONAL-GO.** 보정 목록 = F-GP-W3-1(plate_sizes 양면표기 전환·"미적재 정당" 단정 삭제 — 필수)·F-GP-W7-1(log append — 필수)·F-GP-W3-2/F-GP-W6-1(Low). FABRICATED·STALE·v03·W8 핵심단계 FAIL 부재. pkw-recipe-writer 재호출로 4건 보정 후 재게이트 시 GO. round-13 결함진단 결론(굿즈 size→option·자재오염·봉제오적재·카테고리고아·CPQ미적재)은 라이브 실측으로 전건 확증 — 무영향.
