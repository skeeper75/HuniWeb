# recipes/silsa W-gate verdict — CONDITIONAL-GO (2026-06-12)

> 검증자 독립(생성자≠검증자). 모든 FAIL은 (블록 인용)+(재현 가능한 반대 증거) 쌍 보유.
> 라이브 실측: db `railway`(읽기전용 SELECT only·비밀값 비기록). W1 인용 의미 대조 + load_master.py file:line 재현.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (FABRICATED 0·날조 0) |
| W2 링크 무결성 | FAIL | 1 (BROKEN-LINK SL-DEF-007) + 역링크 부분누락 1 |
| W3 스키마 앵커 | PASS | 0 (라이브 실측 전건 일치) |
| W4 badge 정합 | PASS | 0 (✅5 전건 tier 정당·인플레 0) |
| W5 stale/v03 차단 | PASS | 0 (v03/price-engine-ddl/constraint_json/dep_proc_cd 전부 negation 인용) |
| W6 CQ 커버리지 | UNGRADED | cq-registry.md 부재(escalate·FAIL 아님) |
| W7 index/log 일관성 | FAIL | 2 (index 미갱신·log INGEST 부재) |
| W8 실행가능성 | PASS | 0 (0정체→6적재경로 전 단계 구체 입력 제공) |

**종합: CONDITIONAL-GO** — FABRICATED/SCHEMA-MISMATCH/STALE-CITED 0·W8 핵심단계 0 FAIL → NO-GO 사유 없음. 잔존 = W2 내부 BROKEN-LINK 1(Med)·W7 index/log 누락 2(Med)·역링크 부분누락 1(Low)·W6 registry 부재(escalate). 전부 보정 가능, 치명 결함 아님.

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현 명령/라인) | 보정 제안 |
|---|---|---|---|---|---|
| SL-QA-01 | silsa #SL-DEF-007 (L93·L256 참조) | W2 | BROKEN-LINK | `[[#SL-DEF-007]]`가 L93·256에서 참조되나 SL-DEF-007은 7.1 표 행(L201)으로만 존재·`### [SL-DEF-007]` 헤딩 블록 부재 → linkcheck `ANCHOR-MISSING:silsa#SL-DEF-007`. 재현: `python3 _qa/scripts/linkcheck.py \| grep silsa`. (SL-DEF-001~006은 헤딩 블록 보유, 007만 누락) | 액자 귀속 SL-DEF-007을 7.2에 `### [SL-DEF-007] 액자 귀속 … {🔴 미결정}` 헤딩 블록으로 승격(sticker F-STK-3 STK-ST-005 §7.2 헤딩 승격 선례 동일 패턴) — 표 행만으로는 anchor 미생성 |
| SL-QA-02 | silsa 전체 | W7 | INDEX-STALE | `index.md` L44 = `_(예정)_ recipes/silsa: 실사 — 팩 ...` (집필 완료인데 "예정" 유지). 재현: `grep -n silsa index.md`. 타 family(digital-print/acrylic/sticker)는 실 카탈로그 1줄 등재 | index.md L44를 실 카탈로그 엔트리로 교체: `[recipes/silsa](recipes/silsa.md): 실사 28등록 PRD_000118~145·소재기반 13군·면적매트릭스 13+고정가 16·일반현수막 CPQ(og3/oi18)·카테고리 고아 CAT_000298·자재.08 평면화. 🟡 (✅5·🟡10·🔴7·⚪2)` |
| SL-QA-03 | silsa 전체 | W7 | LOG-MISSING | `log.md`에 `[INGEST] recipes/silsa` 라인 부재(10 타 family는 전부 보유). 재현: `grep -nE '\[INGEST\] recipes/' log.md` → silsa 0건 | log.md에 silsa INGEST 항목 append(원천·블록수 24·badge 분포·STALE 인용 0·broken 검증 — 타 family 포맷 준수) |
| SL-QA-04 | silsa 4·5·6절 | W2 | BACKLINK-PARTIAL | silsa가 cpq-options(CPQ-002~008)·load-path(LP-001~007)·widget-contract(WID-001~005)를 `uses`/`requires` 하나 해당 축 페이지 `- 사용처:` 슬롯에 `[[recipes/silsa#…]]` 미등재. 재현: `grep -c 'recipes/silsa' huni/{cpq-options,load-path,widget-contract}.md` → 0·0·0. (materials/processes/price-engine 슬롯은 정상 등재됨) | 3 축 페이지 해당 항목 사용처 슬롯에 silsa 역링크 추가(README §3 역링크 슬롯 규약·양방향 추적) |
| SL-QA-05 | silsa #SL-CPQ-002 제목 | W1 | INTERNAL-INCONSISTENCY(Low) | 제목 "(43행 COMMIT 이력)" vs 본문 "oi=18행 COMMIT 실재" vs 라이브 oi=18. 재현: 라이브 `SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000138'`=18. 팩 pack-silsa §"43행 COMMIT"도 stale(라이브=18). 본문·라이브 정합이라 FABRICATED 아님 | 제목의 "43행"을 "18행"으로 정정(또는 "43행 = 과거 silsa CPQ 멱등 실증 누계, 현 라이브 oi=18" 명시). 큐레이션 팩 §13·stale함정5 "43행" → "18행"으로 갱신 escalate |

## 게이트별 재측정 근거

### W1 인용 실재성 (PASS) — 날조 0
- 출처 24개 라인 추출(`grep -n '출처:' recipes/silsa.md`) → 인용 파일 11종 전수 실재(Glob OK).
- 의미 대조 핵심:
  - [SL-PRC-001] HARD USER RULE — `02_mapping/silsa-poster-area-matrix/mapping.md` L12~30 verbatim 일치(inline R/S/V 권위 아님·687셀 long-form·clr/mat/coat/bdl/min=NULL·off-grid ceiling=앱·round-2 PRF_POSTER_FIXED sparse 오모델 정정·R² 좌표회귀 미사용).
  - [SL-DEF-001/002/003/004/005] correction-manifest C-01/04/06/07/08 + loadlogic-notes §2 L-A~D — file:line 재현 OK.
  - **load_master.py file:line 재현(G-1/F-PB-1 동형 점검)**: L340 `other = ENUM["OUTPUT_PAPER_TYPE"]["기타"]`+주석(=`.기타` 무조건)·L239 `enum_code("MAT_TYPE", r["자재구분"])`(=자재구분→MAT_TYPE 평면화)·L436 `load_rel_addons … read_sheet(wb,"20_상품별추가상품")` — 전부 인용대로 실재. "존재 파일의 없는 내용" 날조 0.
- 미세: [SL-ID-001] 출처에 "product-master.md L23/L74/L75 인용"이 nested 되나 1차 인용(product-identity.md §0·§2)이 해당 정체 주장을 담음(검증). nested 라인은 독립검증 안 했으나 의미 일치라 FABRICATED 아님.

### W2 링크 무결성 (FAIL 1 + 역링크부분 1)
- linkcheck BROKEN 11 중 silsa 귀속 = SL-DEF-007 1건(나머지 10은 cpq-options/product-accessory 동시편집 페이지·silsa scope 밖·공존 확인).
- silsa outbound cross-axis 링크 ~40종 전부 대상 anchor 실재(broken 0). 중복 헤딩 anchor 0(24 distinct).
- 역링크: materials(MAT-001/002/006)·processes(PRC-003)·price-engine(PE-006/007/008) 슬롯 정상. cpq-options/load-path/widget-contract 슬롯 미등재(SL-QA-04).

### W3 스키마 앵커 (PASS) — 라이브 실측 전건 일치
- PRD_000138 og=**3**·options=**14**·option_items=**18**(ref_dim .03=8/.04=10) → [SL-CPQ-002] "og=3·oi=18" 라이브 CORRECT(gate K4 일치·팩 "43행"은 stale).
- constraints PRD_000138=**0** → [SL-CPQ-003] {🔴} CORRECT. addons/sets silsa=**0** → SL-DEF-005 CORRECT.
- CAT_000298: upr_cat_cd=NULL·cat_lvl=3·nm=실사 + silsa 28상품 전부 →CAT_000298 → [SL-DEF-001] 고아 CORRECT.
- MAT_000186=MAT_TYPE.08·레더(화이트) / MAT_TYPE.05=원단·.06=가죽·.08=실사소재 → [SL-DEF-002] 양면표기 CORRECT.
- PROC_000002=UV·PROC_000006=실사·PROC_000007=별색인쇄·PROC_000008=화이트·PROC_000084=열재단 전수 실재·명칭 일치 → SL-BOM-002/004 CORRECT.
- PRD_000008 천정고리 use_yn=**N**·012 우드거치대·013 우드봉·014 우드행거 실재 → SL-BOM-005/SL-DEF-005/F-SL-2 CORRECT.
- 정상카테고리 067(upr004 lvl2)·088(upr005 lvl2)·095(upr092 lvl3)·099(upr097 lvl3) 실재·lvl 혼재 → F-SL-1 CORRECT.
- 접착투명122→PROC_000008 행 실재 → SL-BOM-004 K6 CORRECT.
- silsa 28 products(118~145) 실재. component_prices 3481행 적재(가격사슬 앵커 존재).
- 미세(비FAIL): silsa plate output_paper = 83 blank(=`.기타`) + **1행 OUTPUT_PAPER_TYPE.03** → [SL-DIM-002] "전부 .기타"는 load_master:340 로직 기준으론 정확하나 라이브엔 .03 1행 존재. 페이지가 "load_master:340 .기타 무조건"으로 경로 명시·영향 무 → SCHEMA-MISMATCH 아님(주의 표기로 충분).

### W4 badge 정합 (PASS)
- ✅ 5블록(SL-ID-001/002·SL-DIM-001/002·SL-BOM-002) 전건 tier C13(round-13 GO 산출) 또는 라이브 실측 확정·🟡 문서 단독 ✅ 0건. BADGE-INFLATED 0.

### W5 stale/v03 차단 (PASS)
- `v03`/`price-engine-ddl`/`constraint_json`/`dep_proc_cd` 출현 전수 = "인용 금지"·"STALE"·진원 설명(양면표기) negation 맥락. 실인용 0. L276 Sources가 "STALE(인용 0 확인)" 명시.

### W6 CQ 커버리지 (UNGRADED·escalate)
- `cq-registry.md` 위키 내 부재(`find . -name cq-registry.md` 0건) → family CQ 분모 미상. silsa answers_cq 15 distinct(CQ-PROD-01/03/05/06/08·CQ-PRICE-01/05/08·CQ-PROC-01·CQ-FIN-01/03/04/10·CQ-TERM-04·CQ-FILE-05) 전 블록 등재. registry 도입 전까지 정량 미산정 — orchestrator escalate.

### W7 index/log (FAIL 2) — SL-QA-02·03.

### W8 실행가능성 (PASS)
- 0정체(cat004/005·prd_typ·폴더)→1차원(sizes 이산SIZ+nonspec·plate.기타)→2BOM(mat_cd+usage.07·PROC_000006)→3가격(component_prices long-form·ceiling=앱)→4CPQ(option_groups/options/items·ref_dim_cd·BUNDLE 라이브예)→5위젯([[link]] 해소)→6적재(load_master·FK위상·search-before-mint·admin pvEdit) 각 단계 구체 입력(테이블·컬럼·코드·화면) 제공. "입력UX≠가격격자" 명시(SL-DIM-001·SL-WID-001). 단 액자 드릴다운 시 SL-DEF-007 broken(SL-QA-01) 도달 — walk-through 차단 아님.

## 재현 (사용 명령 — 비밀값 제외)

```bash
# W2 linkcheck
python3 _qa/scripts/linkcheck.py | grep silsa

# W1 출처 추출
grep -n '출처:' recipes/silsa.md
# load_master.py file:line 재현 (anti-fabrication)
sed -n '338,348p;237,241p;434,438p' raw/webadmin/tools/load_master.py

# W3 라이브 실측 (db railway·읽기전용)
set -a; source .env.local; set +a
PSQL(){ PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
PSQL "SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000138'"          # 3
PSQL "SELECT count(*) FROM t_prd_product_options WHERE prd_cd='PRD_000138'"                # 14
PSQL "SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000138'"           # 18
PSQL "SELECT ref_dim_cd,count(*) FROM t_prd_product_option_items WHERE prd_cd='PRD_000138' GROUP BY ref_dim_cd"  # .03=8 .04=10
PSQL "SELECT count(*) FROM t_prd_product_constraints WHERE prd_cd='PRD_000138'"            # 0
PSQL "SELECT cat_cd,upr_cat_cd,cat_lvl FROM t_cat_categories WHERE cat_cd='CAT_000298'"    # NULL,3
PSQL "SELECT mat_typ_cd FROM t_mat_materials WHERE mat_cd='MAT_000186'"                    # MAT_TYPE.08
PSQL "SELECT cod_cd,cod_nm FROM t_cod_base_codes WHERE cod_nm IN ('원단','가죽','실사소재')"  # .05/.06/.08
PSQL "SELECT proc_cd,proc_nm FROM t_proc_processes WHERE proc_cd IN ('PROC_000002','PROC_000006','PROC_000008','PROC_000084')"
PSQL "SELECT prd_cd,use_yn FROM t_prd_products WHERE prd_cd IN ('PRD_000008','PRD_000012','PRD_000013','PRD_000014')"  # 008=N

# W7 index/log
grep -n silsa index.md
grep -nE '\[INGEST\] recipes/' log.md   # silsa 0건
```
