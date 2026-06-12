# acrylic W-gate verdict — CONDITIONAL-GO (2026-06-12)

대상: `wiki/recipes/acrylic.md` (27 원자 블록 + 7.1 양면표 8행 · badge ✅4·🟡10·🔴11·⚪2).
검증자 독립 재측정: W2 linkcheck 실행 · W3 라이브 information_schema/psql 읽기전용 실측 · W1 인용 라인 의미 대조.
종합: NO-GO 사유(FABRICATED/SCHEMA-MISMATCH/STALE/W8 핵심단계 FAIL) **0건**. Low/Med finding 3건 잔존 → **CONDITIONAL-GO**.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 1건(Low — 경로 shorthand) |
| W2 링크 무결성 | PASS | 1건(Low-Med — 오타깃 cross-ref) |
| W3 스키마 앵커 | PASS | 1건(Low — templates count stale) |
| W4 badge 정합 | PASS | 0 |
| W5 stale/v03 차단 | PASS | 0 |
| W6 CQ 커버리지 | PASS | 0 |
| W7 index/log 일관성 | PASS | 0 |
| W8 레시피 실행가능성 | PASS | 0 (핵심단계 전건 통과) |

## W3 라이브 실측 결과 (검증자 독립 SELECT — writer 주장 전건 재현)

| 주장(페이지) | 라이브 실측 | 판정 |
|---|---|---|
| prd_typ_cd=PRD_TYPE.04 · 23등록(146~169·167결번) | `PRD_TYPE.04` × 23 | ✅ 일치 |
| use_yn=N 6상품(153/156/159/164/165/166) | N×6 = 153/156/159/164/165/166 | ✅ 일치 |
| print_side UV변형 오적재 = 20상품 (F-AC-G1 22→20) | print_opt 보유 distinct = **20** (146~153·155~166), 각 배면양면/풀빼다/투명테두리 3행 | ✅ 일치 |
| UV(PROC_000002) 연결 = 14상품 (F-AC-G2 16→14) | distinct = **14** (146~152,155,157,158,160~163) | ✅ 일치 |
| 완칼 053/054/055 아크릴 = 0건 | 0행 | ✅ 일치 |
| 부착 PROC_000081 = 맥세이프151·마그넷147만 | 147·151 (2) | ✅ 일치 |
| 두께 자재 042/043/044/192/195/196 = MAT_TYPE.03 | 전건 MAT_TYPE.03 실재 | ✅ 일치 |
| usage 미분화 = 전 33행 USAGE.07 | USAGE.07 × 33 | ✅ 일치 |
| 머리끈154·입체블럭169 UV=0 (둘 다 use_yn=Y) | 154 use=Y uv=0 · 169 use=Y uv=0 | ✅ 일치 |
| 입체블럭169 두께 = MAT_000192 폴백 | 169 → MAT_000192 | ✅ 일치 |
| 키링146/포카키링158 addon = 0행 (REMOVED) | 0행 | ✅ 일치 |
| addons 구조 = addon_prd_cd→tmpl_cd 재구조화 | 컬럼: prd_cd·disp_seq·note·reg_dt·upd_dt·**tmpl_cd** (addon_prd_cd 없음) | ✅ 일치 |
| PRD_000006 볼체인 master 건재(use_yn=Y) | PRD_000006 use_yn=Y | ✅ 일치 |
| 아크릴 CPQ option_groups/items = 0행 (전면 미적재) | option_groups 0 · option_items 전체=18(silsa 파일럿) | ✅ 일치 |
| component_prices siz 차원 앵커 | `siz_cd` 컬럼 실재 | ✅ 일치 |
| option_items.ref_dim_cd 앵커 | `ref_dim_cd` 컬럼 실재 | ✅ 일치 |
| prc_typ_cd 전부 .01 단가형 | PRICE_TYPE.01 × 144 (유일) | ✅ 일치 |
| PE-003 PK (prd_cd, apply_bgn_ymd) | t_prd_product_price_formulas: prd_cd·frm_cd·**apply_bgn_ymd** | ✅ 일치 |
| 카테고리 009 아크릴 | CAT_000009=아크릴 실재 | ✅ 일치 |
| 마스터 PROC_000002=UV·053=완칼·081=부착 | 전건 실재 | ✅ 일치 |
| 볼체인 template 미신설 (현 N행 봉투류) | t_prd_templates = **11행**(테스트3 + 봉투류8 · 볼체인 0) | ⚠️ 구조 맞음·count stale(F-AC-W3) |

> 핵심 결함 카운트(print_side 20·UV 14)가 검증자 독립 SELECT로 **전건 재현** — round-13 게이트 F-AC-G1/G2 보정값과 일치. 날조·분류뒤집힘 0.

## W1 인용 의미 대조 (고위험 표본 — 존재만 아닌 의미 일치)

- **price L1 B01** (`06_extract/price-acrylic-price-l1.csv:2-13`): "투명아크릴3T (직접입력형) 양면9도/단면7도 통용 단가" + "아크릴모든 상품에 적용" + "가로/세로" 매트릭스(20mm→2500.0). AC-PRC-001 주장과 라인 일치 — 면적매트릭스·통용·미러전 단가 전건 실재. PASS.
- **load_master:357-369** (`raw/webadmin/tools/load_master.py`): `ACRYLIC = [("배면양면",c4,c4,"Y"),("풀빼다",c4,c0,"N"),("투명테두리",c4,c0,"N")]` PRINT-DEFAULT 3행 전개. 코드 주석 "도수인쇄가 아니라 UV '변형' 3종"·"print_side 컬럼이 보존" — AC-DEF-001 D-AC-1 주장(print_side 오적재 증폭)과 정확 일치. PASS.
- **load_master:324**: `usage = enum_code("USAGE", r["용도"] or "공통", ...)` — AC-DEF-003 D-AC-2 폴백 주장 일치. PASS.
- **acrylic-gate K0~K6** (`17_correctness/_gate/acrylic-gate.md`): 최종판정 GO·F-AC-G1(22→20)·F-AC-G2(16→14)·K5 search-before-mint·sql/01b:108 print_side 정의 전건 실재. PASS.

## W8 실행가능성 dry walk-through (신규 아크릴 1상품 등록)

| 단계 | 페이지가 제공하는 구체 입력 | 판정 |
|---|---|---|
| 0 정체 | t_prd_products(prd_typ_cd=PRD_TYPE.04) · t_cat_categories(009) · 굿즈 UV단품 분류 | PASS |
| 1 차원 | 두께=mat_cd(MAT_000042/043/044) · 형상=siz_nm 부기+완칼 param · 조각수=bundle_qty(bdl_qty) | PASS |
| 2 BOM | 본체 MAT_TYPE.03 + 부속 MAT_TYPE.07(045~057) + usage_cd · UV=PROC_000002 · 완칼=PROC_000053 · 부착=PROC_000081 | PASS |
| 3 가격 | t_prc_component_prices(siz_cd) 면적매트릭스 + ceiling + t_dsc_* 구간할인 · 미러=투명×2 · PK(prd_cd,apply_bgn_ymd) | PASS |
| 4 CPQ | option_groups/options/option_items(ref_dim_cd polymorphic) + fn_chk_opt_item_ref 트리거 → 차원행 선적재 (단 현 미적재=GAP 명시) | PASS |
| 5 위젯 | 정규화 계약 경계(어댑터) · DB 외 앵커 명시 | PASS |
| 6 적재 | load_master oracle · FK 위상순서 · 멱등 이름기반 UPSERT · search-before-mint · admin pvEdit 입력경로 | PASS |

> 각 단계가 구체 테이블·컬럼·코드값을 명시(또는 [[축페이지]]로 위임)하며 "다른 문서 봐야 앎" 단계 0. 미모델/미적재 항목은 🔴 GAP·"앱 계산"으로 정직 표기(스키마 발명 0). W8 PASS.

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현 명령/라인) | 보정 제안 |
|---|---|---|---|---|---|
| F-AC-W1 | acrylic.md AC-LP-002·AC-DEF-008 출처 + 헤더 | W1 | BROKEN-LINK(경로 shorthand·Low) | 인용 `_gate/acrylic-gate.md`의 실파일=`17_correctness/_gate/acrylic-gate.md`(sibling). `17_correctness/acrylic/_gate/`는 부존재(`ls`). Sources §293은 sibling 경로 정합 but 본문 shorthand 모호 | 인용 경로를 `17_correctness/_gate/acrylic-gate.md`로 명시(writer 재호출). 파일·내용 실재·의미 일치하므로 FABRICATED 아님 |
| F-AC-W2 | acrylic.md 7.3 [GAP-AC-2] (line 274) | W2 | BROKEN-LINK(오타깃·Low-Med) | `[[../huni/processes#PRC-GAP-2]]`로 "완칼 묵시 적재" 연결하나 PRC-GAP-2=`신규 공정 신설(미싱제본·보드마운팅·삼각대거치) BATCH-13`(processes.md:99-104). 완칼=BATCH-2/CONFIRM-AC-1 무관 토픽. 앵커는 실재(linkcheck PASS)·의미 불일치 | 완칼 묵시 전용 축 GAP 항목 신설(processes #PRC-GAP-X) 후 재연결, 또는 링크 제거(완칼은 family-고유 [[#AC-DEF-002]]로 충분). writer+axis 동시 보정 |
| F-AC-W3 | acrylic.md AC-CPQ-002·AC-DEF-007 (line 130·244) | W3 | STALE-CITED(count drift·Low) | "현 9행 전부 봉투류" ↔ 라이브 t_prd_templates=**11행**(TMPL-000001~003=테스트 템플릿 + 004~011=봉투류). count·"전부 봉투류" 모두 stale | "현 11행(테스트3+봉투류8)·볼체인 template 0" 로 정정. 핵심 주장(볼체인 미신설→mint 필요)은 라이브 정합·유지 |

## 재현 (사용한 명령 — 비밀값 제외)

```bash
# W2 링크 무결성
python3 _qa/scripts/linkcheck.py            # → BROKEN: 0

# W3 라이브 스키마 앵커 (읽기전용·자격증명=.env.local RAILWAY_DB_*)
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -f _qa/scripts/w3-acrylic.sql
# 핵심 재측정 쿼리:
#  SELECT count(DISTINCT prd_cd) FROM t_prd_product_print_options WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';                         -- 20
#  SELECT count(DISTINCT prd_cd) FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd='PROC_000002';   -- 14
#  SELECT proc_cd,count(*) FROM t_prd_product_processes WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' AND proc_cd IN ('PROC_000053','PROC_000054','PROC_000055') GROUP BY proc_cd;  -- 0 rows
#  SELECT usage_cd,count(*) FROM t_prd_product_materials WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169' GROUP BY usage_cd;                  -- USAGE.07 × 33
#  SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd BETWEEN 'PRD_000146' AND 'PRD_000169';                                        -- 0
#  SELECT count(*) FROM t_prd_templates;                                                                                                       -- 11 (page says 9 → F-AC-W3)

# W1 인용 의미 대조 (표본)
grep -niE "B01|모든 상품|가로|세로" _workspace/huni-dbmap/06_extract/price-acrylic-price-l1.csv
sed -n '355,370p;322,326p' raw/webadmin/tools/load_master.py
grep -nE "K0~K6|F-AC-G2|search-before-mint|01b:108" _workspace/huni-dbmap/17_correctness/_gate/acrylic-gate.md
```

저장 산출: `_qa/scripts/w3-acrylic.sql`(재현용 보존). 임시 파일 없음.
