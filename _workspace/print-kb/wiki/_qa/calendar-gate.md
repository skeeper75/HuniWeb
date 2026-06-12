# calendar W-gate verdict — GO (2026-06-12)

대상: `wiki/recipes/calendar.md`(캘린더 + 디자인캘린더 통합). 검증자=pkw-wiki-qa(생성자 독립). 재측정 원칙(라이브 read-only psql·소스 직접 Read). 디자인캘린더 별 페이지 미분리 = 팩/index/log 정합 확인.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (출처 24건 전건 실존·의미 일치) |
| W2 링크 무결성 | PASS | 0 (linkcheck BROKEN 0·교차참조 anchor 53건 전건 실재·역링크 공존) |
| W3 스키마 앵커 | PASS | 0 (라이브 실측 전 앵커 일치) |
| W4 badge 정합 | PASS | 0 (✅4 전건 tier C GO-round + 라이브 재현) |
| W5 stale/v03 | PASS | 0 (v03/price-engine-ddl 인용 0·STALE 격리만) |
| W6 CQ 커버리지 | PASS | 0 (answers_cq 16종 전건 cq-registry 등재) |
| W7 index/log 일관성 | PASS | 0 (calendar+design-calendar 통합 등재·INGEST append) |
| W8 실행가능성 | PASS | 0 (0→6 dry walk-through 전 단계 구체 입력 or [[link]] 해소) |

**종합: GO.** 전 게이트 PASS. FABRICATED/SCHEMA-MISMATCH/STALE-CITED/W8 핵심 FAIL 0건. 비차단 관찰 1건(아래 Low, finding 미승격).

## Findings
없음(치명·Low finding 0).

### 비차단 관찰 (finding 미승격 — 증거쌍은 기록)
| # | 위치 | 관찰 | 증거 | 처리 |
|---|---|---|---|---|
| O-1 | [CAL-BOM-001] | "벽걸이 materials 23행 전부 USAGE.07" 수치가 라이브와 정확 일치(과장/축소 아님) | 라이브 `PRD_000111` materials 23행·전부 USAGE.07(w3-calendar.sql §2) | 정합 확인. 조치 불요 |
| O-2 | [CAL-ID-003]/§7 | 미니탁상(109) 카테고리 CAT_000112 연결·CAT_000113 전용노드 미연결 = 페이지가 AMBIGUOUS(C-CAL-14)로 정직 표기 | 라이브 109→CAT_000112·CAT_000113 lvl2 실재·미연결(w3 §7) | 페이지가 양면/컨펌(CL-F) 표기로 닫음. 조치 불요 |

## 비파괴 확인 (반증 의심 → CORRECT 입증)
- **삼각대/링 자재 오적재 양면표기 정확성:** 페이지 §7 양면표(C-CAL-01/02/03)가 "라이브 현재값=MAT_TYPE.07 부속·USAGE.07·dflt Y → 정답=공정"이라 표기. 라이브 실측 = MAT_000252/254 삼각대·MAT_000253 링 전부 MAT_TYPE.07·USAGE.07(108/109에 링 부착=EXTRA 정합). 라이브값 단정 아님(correction-manifest 대조) → G-1/F-PB-1 동형 날조 0.
- **plate .01 적재경로 퇴행(F-PB-1 동형 위험 지점):** [CAL-DIM-003]/[CAL-ST-DEF-004]가 "값 .01/.03=도메인 정답·단 load_master 코드 .03만 산출 → 재적재 퇴행"을 양면 표기. 라이브 실측 = 108~111 .01·112 .03·전역 32/33/359, load_master L338/346 코드 `.기타`(.03)만 — 코드↔라이브 충돌 정확 재현. booklet F-PB-1(소스 "✓"가 라이브 갭 은폐)과 달리 캘린더는 이미 갭을 명시 → 은폐 0.
- **미적재 🔴 정직성:** 장수·GRP-CAL-가공·삼각대거치 공정·봉투 addon·디자인 고정가·editor_yn 전건 라이브 0행/N 독립 재현 → 🔴 미적재/교정대기 badge가 라이브와 정합(과소·과대 0).

## 게이트별 근거

### W1 (PASS) — 출처 24건 직접 Read 의미 대조
- `17_correctness/calendar/product-identity.md`: 5 form factor PRD_000108~112·MES 007-0001~5 1:1·정체 오분류0·디자인=같은 상품·부자재 별개 — 페이지 [CAL-ID-001~004] 주장과 의미 일치.
- `correction-manifest.md`: C-CAL-01~14·C-DC-10~12 분류표(MIS-LOADED3·MISSING7·EXTRA1·AMBIGUOUS2·CORRECT7)·CL-A~G 컨펌 — 페이지 §7 양면표 14행·[CAL-ST-DEF-013] CL 목록과 라인 일치.
- `loadlogic-notes.md`: F-1~F-5 file:line(L338/346 plate·L440 addon·L390-401/L476 excl·L261 MES) — 페이지 [CAL-LP-001/002]·[CAL-ST-DEF-004/008] 인용 라인 정확.
- `16_mapping-research/calendar/mapping-final.md`: USAGE.07 정정·sizes 2/2/6/3/1·plate .01/.03 계열코드·page_rules/option/prices/addons 0·디자인 고정가 4000~24000·editor_yn 축 — 페이지 [CAL-DIM-*]·[CAL-BOM-001]·[CAL-DC-001] 일치.
- `17_correctness/_gate/calendar-gate.md`: K0~K6 GO·F-GATE-CAL-1 비차단·K2 oracle 인용 직접 Read·K4 라이브 14항 독립 재현 — 페이지 출처 인용과 일치.
- 위젯 `huni-widget/03_spec/s6-calendar-spec.md`·`data-contract.md`·`editor-integration.md` 실존(tier D, GO-loaded 주장 없음).
- round-11 "USAGE.01 본체"/"316x467 치수 코드값"은 페이지가 STALE 인용금지로 격리(폐기 명시) — 날조 아님.

### W2 (PASS) — `python3 _qa/scripts/linkcheck.py` → BROKEN 0
- 교차참조 anchor 53건(huni 13·base 5·self 15·widget 5 등) 전건 대상 페이지에 item-ID 실재(스크립트 + 수동 grep 확인).
- `[[링크]]`는 본문 안내문 placeholder(linkcheck PLACEHOLDER 제외) — 실 참조 아님.
- 역링크: index에 calendar 줄 + design-calendar 통합 줄. acrylic/photobook 동시편집과 calendar 역링크 슬롯 공존(log L11/15/19).

### W3 (PASS) — 라이브 information_schema/SELECT 실측 (`w3-calendar.sql`)
- identity: 5상품 PRD_TYPE.04·editor_yn=N·file_upload_yn=Y·MES NULL ✓
- sub counts: sizes 2/2/6/3/1·page_rules/ogrp/addon/price 전 5상품 0 ✓
- materials: 삼각대 252/254·링 253 = MAT_TYPE.07 USAGE.07·dflt; 본체 종이 MAT_TYPE.01 USAGE.07 ✓ (벽걸이 23행)
- plate: 108~111 .01·112 .03·전역 .01=32 .03=33 NULL=359 ✓
- processes: 108/109→076·110→079·111→021+079·112→021; 삼각대/거치 proc 검색 0행 ✓
- drift: `to_regclass('t_prd_product_process_excl_groups')`=NULL(Phase11 삭제)·addons 컬럼=tmpl_cd(addon_prd_cd 없음)·editor_yn/file_upload_yn 컬럼 실재 ✓
- 봉투 PRD_000005=012-0008 PRD_TYPE.03 ✓; 카테고리 CAT_000112/114/115 lvl2 upr=CAT_000007·CAT_000113 실재 미연결 ✓
- option_groups 전역 PRD_000001/002/066/138만·price_formulas 캘린더 0 ✓

### W4 (PASS) — ✅4 블록
- CAL-ID-001/002/003·CAL-DIM-001 = 전부 tier C(round-13 GO gate·round-12) + 라이브 재현. 🟡-only 출처로 ✅인 블록 0. 라이브 SELECT로 5상품·고아0·sizes·USAGE.07 직접 재현 → 인플레 0.

### W5 (PASS)
- `v03`/`prdmaster_full_migration_v03` 문자열: STALE 인용금지 격리·"load_master=순수 전파기 v03 인용 금지"·tag `#v03전파기`만 — 긍정 인용 0.
- `price-engine-ddl.md`: STALE 블록(L6/277/281)에만 — 인용 0 명시.
- constraint_json/dep_proc_cd/excl_groups 적재타깃 = 전부 STALE/삭제로 격리.

### W6 (PASS)
- answers_cq 16종(CQ-PROD-01/03/05/06/08/11·CQ-PRICE-01/06/07/08·CQ-FIN-01/10·CQ-PROC-01·CQ-FILE-01·CQ-SUB-01·CQ-TERM-04) 전건 `_workspace/print-kb/cq-registry.md` 등재(wiki 상위 — booklet 게이트 동일 스코프 교훈 적용).

### W7 (PASS)
- index.md L41 calendar 실링크+1줄 요약+🟡 badge·L42 design-calendar 통합 명시.
- log.md L17 [INGEST]·L18 [INDEX]·L19 [LINK] calendar append. INGEST badge 분포(✅5·🟡8·🔴11·⚪1) = 페이지 실제 badge 분포(✅4·🟡8·🔴11·⚪1)와 1건 차이(✅5 표기 vs 실 4) — Low 수준이나 booklet 동형(log 표기 보정 권고). 아래 처리.

### W8 (PASS) — 신규 form factor 등록 dry walk-through
0 정체(CAL-ID-001/003: t_prd_products PRD_TYPE.04·MES·CAT lvl2) → 1 차원(CAL-DIM-001 siz_cd→t_siz_sizes·DIM-002 장수 CPQ·DIM-003 plate output_paper_typ_cd) → 2 BOM(CAL-BOM-001 자재 USAGE.07·BOM-002 공정 PROC_000021/079/076+삼각대거치 mint·BOM-003 param) → 3 가격(CAL-PRC-001 원자합산형 [[PE-005]]·CAL-DC-001 고정가 t_prd_product_prices) → 4 CPQ(CAL-CPQ-001 GRP-CAL-가공 SEL_TYPE.01·CPQ-002 봉투 tmpl_cd) → 5 위젯(CAL-WID-001) → 6 적재(CAL-LP-001 load_master tables+lines·FK 위상 [[LP-003]]·drift 주의 CAL-LP-002). 각 단계 구체 테이블·컬럼·코드·값 제공 또는 [[축 link]] 해소. "다른 문서 봐야 알 수 있음" 0.

## W7 Low 권고 (비차단·생성자 재호출용)
| ID | 페이지#블록 | 게이트 | 분류 | 증거 | 보정 제안 |
|---|---|---|---|---|---|
| F-CAL-L1 | log.md L17 INGEST | W7 | STALE-CITED(경미) | INGEST "badge ✅5·🟡8·🔴11·⚪1" vs 페이지 실 `grep` ✅4·🟡8·🔴11·⚪1 | log INGEST의 ✅5→✅4 표기 정정(페이지 본문이 권위·비차단). recipe-writer 재호출 시 log 한 줄 수정 |

## 재현
```bash
# W2
cd _workspace/print-kb/wiki && python3 _qa/scripts/linkcheck.py     # BROKEN: 0

# W3 (read-only · 비번 비노출)
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -f _workspace/print-kb/wiki/_qa/scripts/w3-calendar.sql

# W4/W5 badge·stale
grep -oE '\{(✅|🟡|🔴[^}]*|⚪[^}]*)\}' recipes/calendar.md | sort | uniq -c
grep -nE "v03|prdmaster_full_migration|price-engine-ddl" recipes/calendar.md

# W6 (cq-registry는 wiki 상위)
cd _workspace/print-kb && for cq in CQ-PROD-01 ... CQ-TERM-04; do grep -q "$cq" cq-registry.md && echo OK $cq; done

# W1 oracle 직접 Read
17_correctness/calendar/{product-identity,correction-manifest,loadlogic-notes}.md · _gate/calendar-gate.md · 16_mapping-research/calendar/mapping-final.md
```
