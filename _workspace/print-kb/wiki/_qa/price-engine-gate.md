# price-engine W-gate verdict — CONDITIONAL-GO (2026-06-18)

Scope: `wiki/huni/price-engine.md` (33 atomic blocks: PE-SOT-1~7 · PE-DEV-1~5 · PE-001~010 · PE-STALE/STALE2 · PE-GAP-1~10).
검증자 = pkw-wiki-qa (writer와 독립·자기승인 아님). 라이브 읽기전용 information_schema/SELECT 실측 + pricing.py 라인 대조.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (라인 의미 대조 통과·골든 일치) |
| W2 링크 무결성 | PASS | 0 (linkcheck.py BROKEN:0·앵커검증 포함) |
| W3 스키마 앵커 | PASS | 0 (라이브 전건 일치·SOT4 prd_cd 부재 실측 확정) |
| W4 badge 정합 | PASS | 0 (✅ 전건 tier-A FRESH/GO 근거) |
| W5 stale/v03 차단 | PASS | 0 (STALE 인용 0·v03 0·미구현진술 STALE표기만) |
| W6 CQ 커버리지 | PASS(Low) | 1 (cq-registry.md 부재 — 독립검증 불가) |
| W7 index/log 일관성 | PASS(Low) | 1 (index 배지분포 +1 drift) |
| W8 실행가능성 | PASS | 0 (배선 단계 구체입력 제공·제약부재 경고 포함) |

## 종합: CONDITIONAL-GO
FABRICATED·SCHEMA-MISMATCH·STALE-CITED·W8 핵심단계 FAIL = **0건**. Low 2건만 잔존(index 요약 drift·CQ 레지스트리 부재). 본문은 라이브 권위에 전건 정합. writer 보정 후 GO 승격 가능(보정 없이도 본문 사용 가능).

## ★Dodge-hunt 결과 (생성자 주장 라이브 재실측)
writer가 SOT4에서 "`t_prc_formula_components`에 prd_cd 부재"를 주장 → **독립 information_schema 재실측으로 진짜 부재 확인**:
- `t_prc_formula_components` 컬럼 = `frm_cd·comp_cd·disp_seq·addtn_yn·reg_dt·upd_dt` 정확히 6개. **prd_cd 없음·상품 FK 0개 = SOT4 주장 TRUE (날조 아님)**.
- **clr_cd dodge**: `t_prc_component_prices.clr_cd` 컬럼은 **물리적으로 존재**하나 non-null **0행**(dead). `print_opt_cd`는 1431행. → SOT3 "clr_cd 폐기·도수=print_opt_cd"는 "엔진 차원집합에서 제외+데이터 dead"의 정확한 표현(컬럼 삭제 주장 아님). 정합.
- **10차원**: pricing.py:38-39 `NON_QTY_DIMS` = 8개(clr_cd 미포함) + `TIER_DIMS` siz_width/siz_height = PE-001/SOT3과 정확 일치.

## Findings
| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현) | 보정 제안 |
|---|---|---|---|---|---|
| QA-PE-L1 | index.md (price-engine 요약줄) | W7 | (Low) 배지분포 drift | index 주장 `✅18(SOT7·장치5·거동6)·🟡5·🔴12`. 실측: ✅SOT7+장치5+거동**5**=**17**, 🟡**4**, 🔴12, 총33블록. "거동6"·"🟡5"가 각 +1 과대(PE-005/007/009/010=🟡 4건, PE-001/002/003/006/008=✅ 5건). 재현: `grep -E "^### \[PE" huni/price-engine.md \| grep -oE "\{[^}]+\}" \| sort \| uniq -c` | index 요약을 `✅17(SOT7·장치5·거동5)·🟡4·🔴12`로 정정 |
| QA-PE-L2 | price-engine.md (answers_cq 22건) | W6 | (Low) COVERAGE-GAP(검증불가) | 페이지가 CQ-PRICE-01~22(신규 11~22 포함) 답변을 선언하나 `wiki/**/cq-registry.md` 부재 → 커버리지% 독립검증 불가. 재현: `find wiki -name cq-registry.md`(0건) | cq-registry.md 신설 또는 가격 CQ 그룹 정의를 큐레이션 팩/registry에 박제(이번 보정 범위 밖일 수 있음·orchestrator 판단) |

## W1 라인 의미 대조 (FRESH 원천 실재·일치 확인)
- pricing.py:8-14 → "frm_typ 폐기·공식=구성요소 합산·우선순위 템플릿단가→직접단가→공식→없음" 일치(PE-DEV-1·PE-SOT-5).
- pricing.py:38-39 `NON_QTY_DIMS` 8개(clr_cd 없음) 일치(PE-001·PE-SOT-3).
- pricing.py:177-192 `component_subtotal` .02 합가형 min_qty≤0 시 `ValueError` 일치(PE-002 C3).
- pricing.py:247 `evaluate_price(target,selections,qty,grade_cd,mode,as_of,only_comps,proc_sels)` 시그니처 일치(PE-DEV-5). (라인수 569 vs 위키 "570" — off-by-1·무해·정보용)
- gate-verdict.md P2 골든 = 실사1000×1000=20,000·off-grid600×900=20,000·아크릴3T=3,100·1.5T=2,480·엽서골든20,000 vs 라이브11,750(FAIL) — PE-006(검증GO)·PE-005/GAP-7(엽서 검증미완) 정확 반영.
- 인용 소스 파일 7종 전부 실재(diag 4·quote 2·pricing.py).

## W3 라이브 실측 (information_schema·SELECT 읽기전용)
| 위키 주장 | 라이브 실측 | 판정 |
|---|---|---|
| formula_components에 prd_cd 부재 | 컬럼 6개·prd_cd 없음 | ✅ |
| 10차원·clr_cd 폐기 | NON_QTY_DIMS 8(no clr_cd)·clr_cd 0행·print_opt_cd 1431행 | ✅ |
| component_prices 7,293 / price_components 146 / formula_components 301 / price_formulas 48 | 7293 / 146 / 301 / 48 | ✅ |
| 바인딩 76·직접단가 0·템플릿단가 0 | 76 / 0 / 0 | ✅ |
| prc_typ .01=143 / .02=3 (CLEAR3T·STK_PACK·STK_TATTOO) | 143 / 3·동일 comp_cd | ✅ |
| 할인 7/35/102·등급할인 0행 | 7 / 35 / 102 / 0 | ✅ |
| addtn_yn=N 2행(PRF_CLR_ACRYL/CLEAR3T·PRF_COROTTO_ACRYL/COROTTO) | 동일 2행 | ✅ |
| CLEAR3T 165행 전부 min_qty=1(÷0 안전) | 165/165·bad 0 | ✅ |
| opt_cd 단가행 5행·option_items add_price 컬럼 부재·option_items 477·addons5·templates13 | 5 / 컬럼0 / 477 / 5 / 13 | ✅ |

라이브 측정값이 위키와 **전건 일치**. 생성자 수치 날조 0건.

## W4 badge 정합
✅ 17건 전부 출처 tier A(라이브 information_schema·pricing.py 코드근거·SOT) 또는 GO 판정(gate-verdict). 🟡 4건(PE-005 엽서검증미완·PE-007 고정가tier C·PE-009 broken4·PE-010 앱계산)·🔴 12건(0행/STALE/GAP) 정직. ✅ 인플레 없음. (PE-002 "143/.01+3/.02"는 큐레이션 팩 §3 "144행 전부 .01"을 라이브로 정정한 것 — 페이지가 팩보다 정확·올바른 거동.)

## W5 stale/v03
`v03` 문자열 = §Sources STALE-금지목록 1회뿐(인용 아님). prcx01/pricing-erd/price-engine-ddl = PE-STALE/STALE2 선언블록·권위반전 헤더에만 등장(인용 아님·강등 대상). "evaluate_price 미구현" = PE-DEV-5에서 STALE로 명시 정정. 모든 인용 출처가 큐레이션 팩에 등급됨(UNGRADED 0).

## W8 dry walk-through (배선 단계 실행가능성)
"새 가격구성요소를 공식에 묶기" 단계: 페이지가 `t_prc_price_components`(comp 정의·use_dims·prc_typ_cd) → `t_prc_formula_components`(frm_cd+comp_cd+disp_seq+addtn_yn 배선) → `t_prc_component_prices`(차원조합별 단가행) 3테이블·컬럼·PK까지 구체 제공(PE-DEV-2). 멱등키 (prd_cd,apply_bgn_ymd)(PE-003). 단가유형 .01/.02 환산식(PE-002). **★제약장치 부재 경고(PE-SOT-4)를 명시** — "배선이 시트 허용차원 안인지 검사하는 장치 없음, 수동 검증 필수"를 LLM에게 경고. 실행가능 PASS.

## 재현 (사용한 명령 — 비밀값 제외)
```bash
set -a; source .env.local; set +a
PSQL(){ PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
# W3 핵심
PSQL "SELECT column_name FROM information_schema.columns WHERE table_name='t_prc_formula_components' ORDER BY ordinal_position"  # prd_cd 부재
PSQL "SELECT count(*),count(clr_cd),count(print_opt_cd) FROM t_prc_component_prices"  # clr_cd dead
PSQL "SELECT prc_typ_cd,count(*) FROM t_prc_price_components GROUP BY prc_typ_cd"      # 143/3
PSQL "SELECT frm_cd,comp_cd FROM t_prc_formula_components WHERE addtn_yn='N'"          # 2행
PSQL "SELECT count(*) FILTER(WHERE min_qty=1) FROM t_prc_component_prices WHERE comp_cd='COMP_ACRYL_CLEAR3T'"  # 165
# W1
sed -n '38,49p;177,192p;247,250p' raw/webadmin/webadmin/catalog/pricing.py
grep -nE "20,?000|11,?750|3,?100|2,?480" _workspace/huni-price-quote/05_gate/gate-verdict.md
# W2 / W5 / W7
python3 _qa/scripts/linkcheck.py               # BROKEN: 0
grep -n "v03\|prcx01\|pricing-erd\|미구현" huni/price-engine.md
grep -E "^### \[PE" huni/price-engine.md | grep -oE "\{[^}]+\}" | sort | uniq -c
```
