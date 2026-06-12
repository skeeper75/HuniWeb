# photobook W-gate verdict — GO (2026-06-12)

대상: `wiki/recipes/photobook.md` (첫 게이트). 검증자 독립 재측정. 라이브 read-only psql(db railway).

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (출처 19줄 전건 실재·의미 일치·라이브 재현) |
| W2 링크 무결성 | PASS | 0 (linkcheck BROKEN 0·acrylic/calendar 동시편집 역링크 공존) |
| W3 스키마 앵커 | PASS | 0 (t_* 컬럼·코드값·행수 라이브 실측 전건 일치) |
| W4 badge 정합 | PASS | 0 (✅ 4블록 전건 A/B/C tier+라이브 확인, 인플레 0) |
| W5 stale/v03 차단 | PASS | 0 (v03·price-engine-ddl 언급 전부 "인용 금지" 가드레일 문맥, 실인용 0) |
| W6 CQ 커버리지 | PASS | 0 (answers_cq 15건 전건 `cq-registry.md` 실재) |
| W7 index/log 일관성 | PASS | 0 (index 1줄 등재·log INGEST append·badge 분포 정합) |
| W8 실행가능성 | PASS | 0 (0→6 dry walk-through 전 단계 구체 입력 or [[link]] 해소) |

**종합: GO.** 전 게이트 PASS, 치명 발견 0, Low 0.

## 중점 판정 — PB-PRC-002 차단 블록 정당성: **정당(GO)**

writer의 PB-PRC-002("포토북 가격 ≠ PRF_PCB_FIXED, 그건 엽서북 PRD_000094") 주장을 라이브 직접 검증한 결과 **전 항목 일치**. F-PB-1 동형 회피는 정확하며 과잉 아님.

| 주장 | 라이브 실측 | 판정 |
|---|---|---|
| PRD_000100 가격공식 바인딩 0행 | `t_prd_product_price_formulas WHERE prd_cd='PRD_000100'` = **0** | 일치 |
| PRD_000100 가격 0행 | `t_prd_product_prices WHERE prd_cd='PRD_000100'` = **0** | 일치 |
| PRD_000094 = 엽서북 | `PRD_000094 \| 엽서북 \| PRD_TYPE.04` | 일치 |
| PRD_000094 = PRF_PCB_FIXED 바인딩 | `PRD_000094 \| PRF_PCB_FIXED` (실재) | 일치 |
| PRF_PCB_FIXED 실재(엽서북용) | `t_prc_price_formulas` hit | 일치 |
| PRF_PBK_PAGEBAND = 신규·미적재 | `t_prc_price_formulas ILIKE '%PBK%'` = **0행** | 일치 |

판정 근거: PB-PRC-002는 "라이브 갭(가격 0행)을 ✓적재됨으로 단정하는 인용을 차단"하는 블록이다. 큐레이션 팩 헤더가 PRD_000094(엽서북)와 PRD_000100(포토북)을 같은 slice 문서(`02_mapping/price211-booklet-photobook/mapping.md`)에서 다루어 PRF_PCB_FIXED를 포토북 가격으로 오인용할 위험이 실재한다(mapping.md §0.1 L25=엽서북 PRF_PCB_FIXED+234행 / L28=포토북 hasf=0). writer가 두 상품의 prd_cd·공식·정체를 라이브 0행 권위로 명확히 분리한 것은 **F-PB-1(엑셀 공란을 MISSING으로 날조) 동형 결함(라이브 갭 은폐)을 정확히 예방**한 것이며, 사실에 부합하므로 과잉 차단이 아니다. ✅ badge도 "라이브 0행이 권위"라는 검증 가능한 사실에 앵커되어 정당.

## Findings
(없음)

## 비파괴 확인 (의심 → CORRECT 입증, finding 아님)

- **page_rule 컬럼명**: 페이지 앵커 "page_min/max/incr". 라이브 실제 컬럼 = `page_min`·`page_max`·`page_incr`(약식 표기 정합). 값 24/150/2 일치. SCHEMA-MISMATCH 아님.
- **`_gate/photobook-gate.md` 경로**: 페이지 약식 인용. 실제 = `17_correctness/_gate/photobook-gate.md`(상품 폴더가 아닌 `17_correctness/_gate/`). 파일 실재·내용 권위 정합 → BROKEN 아님(linkcheck 대상도 아닌 외부 산출 경로).
- **PB-C1 레더 자재유형**: 라이브 MAT_000006=.01·MAT_000186=.08(페이지 "라이브 현재값" 일치)·정답 .06(correction-manifest 권위). 양면 표기 정확.
- **MAT_000186 6상품 횡단**: 라이브 `t_prd_product_materials` DISTINCT prd_cd = 정확히 6(PRD_000077/088/100/126/174/175). manifest·페이지 카운트 일치.
- **PB-C3 PUR mand**: 라이브 PROC_000020 mand_proc_yn=N(페이지 "라이브 현재값" 일치)·정답 Y. 양면 표기 정확.
- **materials 7행 usage 슬롯**: 라이브 .01 MAT_000105 / .02 ×5(005·006·007·186·250) / .03 MAT_000251 — PB-BOM-001과 verbatim 일치.
- **펼침 siz 7종 미연결**: 마스터 실재 7행·product_sizes 연결 0행 — PB-DIM-001/PB-A1 일치.
- **load_master 가격 함수 부재**: `grep -ciE 'price|prc_' raw/webadmin/tools/load_master.py` = 0 — PB-LP-001 일치.

## W8 dry walk-through (신상품 1개 등록 — 전 단계 구체 입력 확인)

| 단계 | 페이지 제공 구체 입력 | 판정 |
|---|---|---|
| 0 정체 | PRD_000100 PRD_TYPE.04 + sub_prd 101~107 .02·CAT_000108→CAT_000006·editor_yn=Y·qty_unit=.03 권·MES NULL | PASS |
| 1 차원 | size 4(SIZ_000170/172/269/274)·page_rule 24/150/2·책등=앱계산(면제 표기 有) | PASS |
| 2 BOM | usage .01 내지 MAT_000105/.02 표지 5/.03 면지 MAT_000251·PUR PROC_000020+무광 PROC_000015·도수 CMYK4 | PASS |
| 3 가격 | PRF_PBK_PAGEBAND(신규)+22행 매트릭스 명시값(8x8 하드 15000/+500 등)·미적재 명시 | PASS(미적재 플래그 정확) |
| 4 CPQ | option_groups 0행·sub_prd/차원 흡수(현행 정상) | PASS |
| 5 위젯 | 정규화 계약 일반형·[[widget-contract]] 해소 | PASS |
| 6 적재 | load_master run_all·시트(10/11/13/14/15/17/19/21)·FK순 [[load-path#LP-003]]·가격 별 트랙 | PASS |

## 재현 (비밀값 제외)

```bash
# W2
python3 _qa/scripts/linkcheck.py   # BROKEN: 0

# W1 출처
grep -n '^- 출처:' recipes/photobook.md | sed 's/.*출처: //'

# W3 + PB-PRC-002 라이브 (.env.local RAILWAY_DB_* read-only)
PSQL() { PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "$1"; }
PSQL "SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000100'"   # 0
PSQL "SELECT count(*) FROM t_prd_product_prices WHERE prd_cd='PRD_000100'"           # 0
PSQL "SELECT prd_cd,prd_nm,prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000094'" # 엽서북 .04
PSQL "SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000094'" # PRF_PCB_FIXED
PSQL "SELECT frm_cd FROM t_prc_price_formulas WHERE frm_cd ILIKE '%PBK%'"            # (없음)
PSQL "SELECT mat_cd,mat_typ_cd FROM t_mat_materials WHERE mat_cd IN ('MAT_000006','MAT_000186')" # .01/.08
PSQL "SELECT count(DISTINCT prd_cd) FROM t_prd_product_materials WHERE mat_cd='MAT_000186'"      # 6
PSQL "SELECT count(*) FROM t_prd_product_sets WHERE prd_cd='PRD_000100'"             # 7
PSQL "SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000100'"            # 4
PSQL "SELECT page_min,page_max,page_incr FROM t_prd_product_page_rules WHERE prd_cd='PRD_000100'" # 24/150/2
PSQL "SELECT mand_proc_yn FROM t_prd_product_processes WHERE prd_cd='PRD_000100' AND proc_cd='PROC_000020'" # N
PSQL "SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd='PRD_000100'"    # 2
PSQL "SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd='PRD_000100'"    # 0
PSQL "SELECT upr_cat_cd FROM t_cat_categories WHERE cat_cd='CAT_000108'"             # CAT_000006

# W5
grep -n 'v03\|price-engine-ddl' recipes/photobook.md   # 전부 인용금지 가드레일 문맥

# W6
for cq in $(grep -oE 'CQ-[A-Z]+-[0-9]+' recipes/photobook.md | sort -u); do \
  grep -q "$cq" ../cq-registry.md && echo "OK $cq" || echo "MISS $cq"; done   # 15/15 OK

# W8: load_master 가격 함수 부재
grep -ciE 'price|prc_' raw/webadmin/tools/load_master.py   # 0
```
