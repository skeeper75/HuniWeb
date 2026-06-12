# foundation (base 7 + 축 6 + modeling-axioms + index/README/log) W-gate verdict — NO-GO (2026-06-12)

> 검증자=pkw-wiki-qa(생성자 독립). scope = `base/{printing-methods,sizes,paper,finishing,binding,color,prepress-file}.md` · `huni/{materials,processes,price-engine,cpq-options,widget-contract,load-path,modeling-axioms}.md` · `index.md`·`README.md`·`log.md`. 권위 = `_curation/`(source-registry·packs)·`_research/`(base-verification·adoption-record). W8 = N/A(레시피 미작성).
> 라이브 W3 = `.env.local` RAILWAY_DB_* 읽기전용 psql 실측(information_schema·행수·트리거·routine). 비밀값 미기록.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | **PASS** | 0 (자가신고 인용 전건 실재·의미일치) |
| W2 링크 무결성 | **FAIL** | 25 BROKEN-LINK (앵커 부존재) |
| W3 스키마 앵커 | **FAIL** | 4 SCHEMA-MISMATCH (라이브 실측) |
| W4 badge 정합 | PASS | 0 (✅3 전건 tier A·라이브 확증) |
| W5 stale/v03 전파 | **PASS** | 0 (v03·price-engine-ddl·constraint_json 전부 STALE 블록 격리) |
| W6 CQ 커버리지 | FAIL(Medium) | answers_cq 사실상 0 (축 페이지 미연결) |
| W7 index/log 일관성 | PASS | 0 (14 페이지 전건 등재·log INGEST 기록 정합) |
| W8 레시피 실행가능성 | N/A | 레시피 미작성 |
| +관계그래프 컨벤션 | PARTIAL | 역링크 슬롯 PASS · 관계 동사 거의 부재(Medium) |

**종합: NO-GO** — W3 SCHEMA-MISMATCH 4건(라이브 부존재 테이블/컬럼 앵커) + W2 BROKEN-LINK 25건. 단 W1/W5는 깨끗(날조 0·stale 전파 0)이므로 구조 재설계가 아니라 **앵커 교정 + 링크 교정 1회 보정**으로 GO 전환 가능.

---

## Findings (심각도순)

### High — SCHEMA-MISMATCH (W3, 라이브 실측 반증)

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| F-W3-1 | processes#PRC-001·PRC-002 | W3 | SCHEMA-MISMATCH | `SELECT table_name FROM information_schema.tables WHERE table_name LIKE '%excl%'` → **0행**. `t_prd_product_process_excl_groups` 라이브 부존재(06-04 ref-csv엔 존재→이후 삭제 추정). | 앵커에서 `t_prd_product_process_excl_groups`(택일그룹 테이블) 제거. 라이브 배타 표현은 `t_prd_product_processes.mand_proc_yn`(실재 컬럼). 택일그룹 구조가 정답 모델이면 "🔴 GAP(라이브 부존재)"로 양면 표기, 아니면 앵커 정정. |
| F-W3-2 | price-engine#PE-001·PE-002 | W3 | SCHEMA-MISMATCH | `tables WHERE table_name LIKE '%dim%'` → **0행**. `pricing_dims`·`use_dims`는 라이브 **테이블 아님**. 단가유형은 `t_prc_price_components.prc_typ_cd`에 존재(`pricing_dims.prc_typ_cd` 아님). sql/21·22는 seed/init 스크립트(테이블 생성 DDL 아님). | PE-001 앵커 `pricing_dims(8차원/10컬럼)·use_dims` → 실재 위치로 정정: 차원 컬럼은 `t_prc_component_prices`(proc_cd·opt_cd·siz_cd 실재)+`t_prc_price_components.prc_typ_cd`. PE-002 앵커 `pricing_dims.prc_typ_cd` → `t_prc_price_components.prc_typ_cd`. ※PE-002 행수 주장(144행 전부 .01)은 라이브 **정확**(`SELECT prc_typ_cd,count(*) FROM t_prc_price_components` → PRICE_TYPE.01\|144). |
| F-W3-3 | materials#MAT-003 · load-path#LP-003 | W3 | SCHEMA-MISMATCH | `tables WHERE table_name LIKE '%base_code%'` → `t_cod_base_codes`(t_base_codes 아님). 컬럼 = cod_cd·upr_cod_cd(자기참조 계층)·… **cod_grp_cd 컬럼 없음**(`SELECT cod_grp_cd…` → ERROR column 부존재). | MAT-003 앵커 `← t_base_codes(MAT_TYPE 그룹)` → `t_cod_base_codes`, 그룹 메커니즘은 `upr_cod_cd`(상위코드) 계층(그룹 컬럼 아님). LP-003 `BASE_CODE_GROUP 14그룹` 표현도 컬럼 아님을 명시. |
| F-W3-4 | cpq-options#CPQ-008 (CONF-1 판정) | W3 | (정정 — 행수 stale 양쪽) | `SELECT count(*) FROM t_prd_product_option_items` → **18행**. ref-csv "0행"도, 메모리 "silsa 43행 COMMIT"도 라이브와 불일치. 위키는 "대부분 미적재(silsa 파일럿만)·정확 행수 라이브 재확인 대상"으로 **정직 헤지** → 치명 아님. | CPQ-008 행수를 **라이브 18행**으로 확정 기입(silsa 43 COMMIT은 이후 일부 미적재/롤백 추정). "라이브 재확인 대상" 슬롯 해소. |

> **W3 라이브 확증(PASS 측):** template_prices=0행(PE-004 ✓) · constraint_json 삭제·logic 실재(CPQ-007/CPQ-STALE ✓) · dep_proc_cd 0건(I-6/MAT-GAP-3/PRC-GAP-4 STALE ✓) · fn_chk_opt_item_ref routine 실재(CPQ-003 ✅ ✓) · prc_typ_cd 144행 전부 .01(PE-002 ✓) · 트리거 37개 정확(LP-002 ✅ ✓) · t_*=35테이블(round-14 34→35 ✓) · 가격공식 적용 PK (prd_cd,apply_bgn_ymd)=`t_prd_product_price_formulas` 실 PK(PE-003 ✓) · ref_dim_cd/ref_key1/ref_key2 실재(CPQ-002 ✓) · mat_cd·mat_typ·usage_cd 실재(MAT-001/003 ✓).

### High — BROKEN-LINK (W2, `_qa/scripts/linkcheck.py` 재현)

25건 전건 ANCHOR-MISSING(PAGE-MISSING 0 — 대상 파일은 전부 실재). 원인 = ① heading-text 앵커가 섹션 번호 접두 누락(`#무판--디지털-인쇄` → 실제 `#2-무판--디지털-인쇄`) ② 개념명 앵커가 안정 item-ID 대신 사용(`#별색`→`#BCL-003`·`#재단`→`#BFN-002`). README §3 R-7(안정 @id 교차참조) 위반.

| ID | 출발 페이지 | 깨진 링크 | 정답 앵커 |
|---|---|---|---|
| F-W2-1 | finishing·color·paper | `printing-methods#무판--디지털-인쇄`(×4) | `#2-무판--디지털-인쇄` |
| F-W2-2 | processes·modeling-axioms | `printing-methods#방식-선택을-가르는-변수`(×2) | `#3-방식-선택을-가르는-변수` |
| F-W2-3 | modeling-axioms | `printing-methods#출처` | `#출처-베이스--표준교과서` |
| F-W2-4 | finishing·processes | `color#별색`(×2) | `#BCL-003` |
| F-W2-5 | finishing | `color#화이트` | `#BCL-005` |
| F-W2-6 | printing-methods | `finishing#uv` | `#BFN-006` |
| F-W2-7 | sizes | `finishing#재단` | `#BFN-002` |
| F-W2-8 | processes | `finishing#박` | `#BFN-004` |
| F-W2-9 | processes | `finishing#후가공-프레임` | `#1-후가공의-위치-검증된-프레임` 또는 `#BFN-001` |
| F-W2-10 | sizes | `prepress-file#블리드` | `#BPF-003` |
| F-W2-11 | sizes·price-engine | `prepress-file#판걸이`(×2) | `#BPF-002` |
| F-W2-12 | sizes | `prepress-file#출력규격` | `#2-출력-규격-검증된-사실`(개념·앵커 없음→정정) |
| F-W2-13 | sizes | `paper#전지`(×2) | `#BPP-004` |
| F-W2-14 | sizes | `paper#결방향` | `#BPP-001` |
| F-W2-15 | materials | `paper#종이-종류` | `#BPP-003` |
| F-W2-16 | price-engine | `sizes#출력판형` | `#BSZ-003` |
| F-W2-17 | processes | `binding#제본방식` | (binding 앵커 없음 — `#BBD-003`류 또는 GAP 표기) |
| F-W2-18 | materials | `binding#표지-내지` | (binding 앵커 없음 — `_(존재 시)_` 의도였으나 live 링크 방출) |

> 보정 규칙: heading-텍스트 앵커 폐기, **안정 item-ID(`#BSZ-003` 등) 또는 번호포함 slug**로 통일(README §3 R-7). `_(존재 시)_`/`_(보편 없음)_` 의도 링크는 실제 `[[...]]`로 방출되어 404 → 미존재 앵커는 링크 제거하거나 대상 항목 신설.

### Medium — COVERAGE-GAP / 컨벤션

| ID | 페이지 | 게이트 | 분류 | 증거 | 보정 |
|---|---|---|---|---|---|
| F-W6-1 | 축 6 페이지 전체 | W6 | COVERAGE-GAP | `grep answers_cq huni/*.md base/*.md` → modeling-axioms 1건(빈 placeholder)뿐. cq-registry(`_workspace/print-kb/cq-registry.md`) 98 CQ·8그룹(PRICE/PROC/FIN/TERM/FILE/POL/SUB 축 정합)인데 축 원자 항목이 0개 연결. README §3/§7 양방향 추적 미발현. | 축 항목에 `answers_cq` 채우기(예: price-engine→CQ-PRICE·processes→CQ-PROC·cpq-options→CQ-POL/CQ-PROD). base는 §1상 면제 가능하나 축은 템플릿 필수. |
| F-WG-1 | 축 6 페이지 `연결` 라인 | +관계그래프 | 컨벤션 | `연결: [[link]] (한글 설명)` 형식 — README §3 1급 관계 동사(uses/requires/excludes/priced-by/loaded-via/mapped-to) 거의 미사용. 역링크 슬롯 `사용처:`는 전건 존재(PASS). | 항목 간 링크에 관계 동사 명시(특히 레시피 집필 전 정착). 레시피가 소비자이므로 차기 집필 전 보정 권장. |

### 무발견(증거 기반 PASS 근거)

- **W1 FABRICATED 0:** 자가신고 인용 전건 라인 단위 실재·의미일치 — `load_master.py:39`=`prdmaster_full_migration_v03_20260518.xlsx`(정확) · `_loadspec/loadspec.md` L79(constraint_json)·L96(dep_proc_cd) · `extraction-plan.md` L56(dep_proc_cd) · sql 18/20/21/22 · 02_mapping/{digital-print-engine,silsa-poster-area-matrix,price211-fixedgrid,dwire-poster-formula-remodel} · 09_load/_migrate_{areamatrix,fixedprice} · 17_correctness/{photobook,acrylic,stationery}/correction-manifest.md · _crosscut/crosscut-synthesis.md · impact-diagnosis.md 전건 실재.
- **W5 STALE-CITED 0:** v03·price-engine-ddl·constraint_json·dep_proc_cd 인용은 전부 `🔴 STALE`/`[HARD] 인용 금지` 블록 내 격리(권위로 인용 0). 라이브가 삭제 확증(constraint_json·dep_proc_cd 0건) — 격리 정확.
- **W4 BADGE-INFLATED 0:** ✅3(LP-001 sql 실재·LP-002 트리거37 라이브 EXACT·CPQ-003 routine 실재) 전건 tier A 라이브 확증.
- **W7:** base 7+huni 7 전건 index 등재(고아 0)·log 2026-06-12 INGEST 3건 정합.

---

## CONF-1 판정 (라이브 실측)

`SELECT count(*) FROM t_prd_product_option_items` → **18행**. ref-csv "0행"·메모리 "silsa 43 COMMIT" 둘 다 stale. **라이브 권위 = 18행.** 위키 CPQ-008은 정확 행수를 단정하지 않고 "라이브 재확인 대상"으로 헤지 → 치명 아님(정직). 보정 시 18행으로 확정.

---

## 재현 (사용한 명령 — 비밀값 제외)

```bash
# W2 링크/앵커 (재사용 스크립트)
python3 _qa/scripts/linkcheck.py
# → BROKEN: 25 (전건 ANCHOR-MISSING, PAGE-MISSING 0)

# W3 라이브 실측 (읽기전용)
set -a; source .env.local; set +a; export PGPASSWORD="$RAILWAY_DB_PASSWORD"
P(){ psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
P "SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_name LIKE 't_%' ORDER BY 1"   # 35 t_*
P "SELECT table_name FROM information_schema.tables WHERE table_name LIKE '%excl%' OR table_name LIKE '%dim%'"          # 0 → excl_groups·pricing_dims·use_dims 부존재
P "SELECT count(*) FROM t_prd_product_option_items"        # 18 (CONF-1)
P "SELECT count(*) FROM t_prd_template_prices"             # 0 (PE-004 ✓)
P "SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_constraints'"   # logic ○ constraint_json ✗
P "SELECT table_name,column_name FROM information_schema.columns WHERE column_name='dep_proc_cd'"      # 0 (I-6 ✓)
P "SELECT prc_typ_cd,count(*) FROM t_prc_price_components GROUP BY 1"   # PRICE_TYPE.01|144 (PE-002 ✓)
P "SELECT routine_name FROM information_schema.routines WHERE routine_name='fn_chk_opt_item_ref'"     # 실재 (CPQ-003 ✓)
P "SELECT count(*) FROM information_schema.triggers WHERE trigger_schema='public'"                    # 37 (LP-002 ✓)
# 가격공식 적용 PK
P "SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid=i.indrelid AND a.attnum=ANY(i.indkey) WHERE i.indrelid='t_prd_product_price_formulas'::regclass AND i.indisprimary"  # prd_cd,apply_bgn_ymd (PE-003 ✓)

# W1 인용 라인 (예)
sed -n '39p' raw/webadmin/tools/load_master.py    # v03 입력 (정확)
sed -n '79p;96p' _workspace/huni-dbmap/15_domain-spec/_loadspec/loadspec.md  # constraint_json / dep_proc_cd
```

---

## 2차 재측정 (2026-06-12 — writer 보정 후, finding 한정 재측정)

> 검증자=pkw-wiki-qa(독립). writer가 "finding 한정 보정 완료"를 신고 → 신뢰하지 않고 재측정. 1차 NO-GO 사유(W2 25·W3 4·W6·관계동사) 전건 재확인 + W1/W4/W5/W7 빠른 회귀.
> W3 = `.env.local` RAILWAY_DB_* 읽기전용 psql 라이브 직접 재대조(writer는 1차 기재값 전재만 했으므로 라이브 실측 의미 있음). 비밀값 미기록.

| 게이트 | 1차 | 2차 결과 | 잔존 findings |
|---|---|---|---|
| W1 인용 실재성 | PASS | **PASS** | 0 (load_master.py:39 라이브 재확인=v03 정확·paper.md 출처 전건 resolve) |
| W2 링크 무결성 | FAIL(25) | **PASS** | 0 (linkcheck.py 재실행 BROKEN=0. skip 대상 placeholder는 의도된 forward-ref) |
| W3 스키마 앵커 | FAIL(4) | **PASS** | 0 (4건 전건 라이브 직접 재대조 일치 — 아래) |
| W4 badge 정합 | PASS | **PASS** | 0 (✅3 불변·tier A) |
| W5 stale/v03 전파 | PASS | **PASS** | 0 (v03 2건 전부 🔴 STALE/GAP 블록 격리·인용금지 명시) |
| W6 CQ 커버리지 | FAIL(M) | **PASS** | 0 (29 unique answers_cq 전건 cq-registry 실재) |
| W7 index/log 일관성 | PASS | **PASS** | 0 (14/14 등재·보정 log append 확인) |
| W8 레시피 실행가능성 | N/A | N/A | 레시피 미작성 |
| +관계그래프 컨벤션 | PARTIAL | **PASS** | 0 (6동사 41건 적용·의미 정합) |

**종합 2차: GO** — 1차 NO-GO 사유(W3 4·W2 25·W6·관계동사) 전건 해소. 라이브 직접 재대조로 W3 확정. 회귀(W1/W4/W5/W7) 무손상. finding 외 변경 0.

### W2 재측정
- `python3 _qa/scripts/linkcheck.py` → **BROKEN: 0**.
- skip 표본 검사: 스크립트가 `...` 포함 링크를 skip(라인 23). 본문 잔존 placeholder = `[[../huni/...]]`×17·`[[../base/...]]`×1·`[[index]]`×1. 전건 `연결:` 라인의 **의도된 forward-ref**(아직 미집필 레시피 가리킴)이며 각 링크 옆에 실제 권위 소스를 prose로 병기(예: color.md:31 `[[../huni/...]] 별색=공정 ... _curation/axis-processes.md`). `[[index]]`는 index.md 실재(고아 아님). → 죽은 클릭 링크 아님·Low 수준 컨벤션(레시피 집필 시 실 앵커로 치환 예정). FAIL 아님.

### W3 재측정 (라이브 직접 — 1차 기재값 전재 아닌 실측)
| ID | 라이브 SELECT 출력 | 위키 현재 앵커 | 판정 |
|---|---|---|---|
| F-W3-1 | `%excl%`→0행 · `t_prd_product_processes.mand_proc_yn` 실재 · `t_proc_processes`/`t_prd_product_processes` 실재 | PRC-001 앵커=`t_proc_processes`·`t_prd_product_processes(mand_proc_yn)`, excl_groups=🔴GAP[PRC-GAP-5] | 일치 ✓ |
| F-W3-2 | `%dim%`→0행 · `prc_typ_cd`는 `t_prc_price_components`에만 · `PRICE_TYPE.01\|144` · `t_prc_component_prices`에 proc_cd/opt_cd/siz_cd 실재 | PE-001 차원=`t_prc_component_prices`+`t_prc_price_components.prc_typ_cd`, PE-002=`t_prc_price_components.prc_typ_cd`(144 .01) | 일치 ✓ |
| F-W3-3 | 테이블=`t_cod_base_codes` · 컬럼=cod_cd·upr_cod_cd·…(**cod_grp_cd 부재**) | MAT-003/LP-003 앵커=`t_cod_base_codes`(upr_cod_cd 계층·cod_grp_cd 없음·BASE_CODE_GROUP=컬럼 아님 명시) | 일치 ✓ |
| F-W3-4 | `count(*) t_prd_product_option_items`→**18** | CPQ-008=`t_prd_product_option_items`(라이브 18행 확정·ref 0/메모리 43 stale 주기) | 일치 ✓ |

### W6 재측정
- 위키 answers_cq 29 unique 추출 → `_workspace/print-kb/cq-registry.md` 대조: **전건 실재**(CQ-FILE/FIN/PRICE/PROC/PROD/TERM 6그룹). 미존재 CQ-ID 0. 1차 "answers_cq 사실상 0"→해소. (registry는 CQ→answering-asset, 위키는 block→CQ — 양방향 충족. registry 총 81 CQ는 1차 기재 98과 차이 있으나 위키 참조분 전건 resolve라 비치명.)

### 관계동사 재측정
- uses 19·requires 6·excludes 2·priced-by 4·loaded-via 4·mapped-to 6 = 41건. 표본 의미 검사: requires=트리거 의존(LP-003→CPQ-003), loaded-via=적재경로(PE-001→LP-002), priced-by=가격참조(PRC-005→PE-005), mapped-to=위젯/코드매핑, excludes=캐스케이드. 정합.

### 회귀 (W1/W4/W5/W7)
- **W1:** `load_master.py:39`=`prdmaster_full_migration_v03_20260518.xlsx` 라이브 재확인(정확). paper.md 출처 5건 전건 `_research/base-verification.md`/정직 GAP로 resolve. 날조 0.
- **W5:** huni/base 전 v03 언급 2건(LP-STALE·LP-GAP-1) 전부 🔴 STALE/GAP "인용 금지" 블록 격리. 권위 인용 0. STALE-CITED 0.
- **W4:** ✅3 불변(보정이 badge 미변경).
- **W7:** 14/14 index 등재·보정 entry log.md append 확인.
- **paper.md "건드렸다 원복" 검증:** 위키 디렉터리 git 미추적(`??`)이라 git-diff 불가. 단 내용 무손상 확증 — 출처 전건 resolve·linkcheck BROKEN 0(paper.md 포함)·앵커 정합. 손상 흔적 없음.

### 2차 재현 (비밀값 제외)
```bash
python3 _qa/scripts/linkcheck.py    # BROKEN: 0
# skip된 placeholder 본문 잔존 확인
grep -rnoE '\[\[[^]]*\.\.\.[^]]*\]\]' base/*.md huni/*.md   # 18건 전부 forward-ref placeholder
# W3 라이브 직접
P "SELECT table_name FROM information_schema.tables WHERE table_name LIKE '%excl%'"   # 0
P "SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_processes' AND column_name='mand_proc_yn'"  # mand_proc_yn
P "SELECT table_name FROM information_schema.tables WHERE table_name LIKE '%dim%'"    # 0
P "SELECT prc_typ_cd,count(*) FROM t_prc_price_components GROUP BY 1"                 # PRICE_TYPE.01|144
P "SELECT column_name FROM information_schema.columns WHERE table_name='t_cod_base_codes' ORDER BY 1"  # cod_grp_cd 부재
P "SELECT count(*) FROM t_prd_product_option_items"                                  # 18
# W6
grep -rohE 'CQ-[A-Z]+-[0-9]+' huni/*.md base/*.md | sort -u   # 29 → 전건 cq-registry.md 대조
```
