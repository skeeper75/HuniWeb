# product-accessory W-gate verdict — CONDITIONAL-GO (2026-06-12)

> 검증자 = pkw-wiki-qa(독립). 대상 = `recipes/product-accessory.md`. 팩 = `_curation/pack-product-accessory.md`.
> 라이브 실측 = read-only psql(db railway·.env.local RAILWAY_DB_*). 비밀값 비기록.
> 종합: **CONDITIONAL-GO** — 치명(FABRICATED/SCHEMA-MISMATCH/STALE)·W8 핵심 FAIL 0. 단 W2 BROKEN-LINK(7건)와 W3 1건 count-mismatch(addon 1행→실 5행) = 블록 단위 보정으로 닫힘. 페이지 구조·정체·교정 모델은 견고.

| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS | 0 (sql/09 삭제목록·PA-01~14·gate K0~K6 전건 의미 일치) |
| W2 링크 무결성 | **FAIL** | 7건 BROKEN-LINK (PA-ST-005~010 미존재 앵커 6 + PA-ST-002b ID규약 위반 1) |
| W3 스키마 앵커 | **CONDITIONAL** | 1 Med(addon "1행"→라이브 5행)·2 Low(컬럼명 anchor 부정확: bdl_unit_typ_cd·addon_prd_cd 부존재) |
| W4 badge 정합 | PASS | 0 (✅3 전건 tier C13 round-13 GO·라이브 psql 근거) |
| W5 stale/v03 차단 | PASS | 0 (v03=금지라벨 용도만·출처 전건 FRESH·STALE은 §245 "인용0" 격리) |
| W6 CQ 커버리지 | PASS | 0 (answers_cq 9종 전건 `_workspace/print-kb/cq-registry.md` 등재 9/9) |
| W7 index/log 일관성 | PASS | 0 (index 46행 등재·log INGEST/INDEX/LINK append·badge 분포 일치) |
| W8 실행가능성 | PASS | 0 (0→6 dry walk-through 전 단계 구체 입력 or [[link]] 해소·갭은 교정대기 명시) |

## Findings

| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현 명령/라인) | 보정 제안 |
|----|------------|--------|------|---------------------|-----------|
| F-PA-1 | product-accessory#PA-DIM-002·#PA-BOM-001·여러 블록 (본문 [[#PA-ST-005]]~[[#PA-ST-010]]) | W2 | BROKEN-LINK | `python3 _qa/scripts/linkcheck.py` → ANCHOR-MISSING product-accessory#PA-ST-005(×2)/006/007(×2)/008/009/010. PA-ST-005~010은 §7.1 **표 행으로만 존재**(line 176~181), `### [PA-ST-NNN]` 헤딩/item_id 부재 → 링크 대상 앵커 없음 (헤딩 존재: 001/002/002b/003/004뿐, `grep -nE '^### \[PA-ST' recipes/product-accessory.md`) | (a) PA-ST-005~010을 §7.2처럼 `### [PA-ST-NNN]` 헤딩 블록으로 승격, 또는 (b) 본문 [[#PA-ST-005~010]] 링크를 §7.1 표 참조 텍스트(앵커 아님)로 강등. 표 행은 링크 가능 앵커가 아님 |
| F-PA-2 | product-accessory#PA-ST-002b (cpq-options.md 86·103行 인입) | W2 | BROKEN-LINK | 헤딩 `### [PA-ST-002b]`(line 202)의 ID가 ID 규약 `[FAMILY-SECTION-NNN]`(대문자+숫자) 위반(소문자 `b`). linkcheck item_id 정규식 `[A-Z][A-Z0-9\-]+`이 캡처 못함 → cpq-options#CPQ-008/GAP-1의 [[recipes/product-accessory#PA-ST-002b]] 2건 + GitHub slug 미정합. 도구 추적 불가 ID | PA-ST-002b → `PA-ST-005`로 재번호(005~010 한 칸씩 밀거나 미사용 번호 사용) + cpq-options 인입 링크 2건 동시 갱신. ID에 소문자 금지 |
| F-PA-3 | product-accessory#PA-CPQ-001 (line 99) + #PA-ST-004 표(line 175) | W3 | SCHEMA-MISMATCH(count) | 페이지: "실제 addon 연결은 프리미엄엽서→TMPL-000005 **1행뿐**". 라이브 재측정: `SELECT prd_cd,tmpl_cd FROM t_prd_product_addons` → PRD_000016이 **5행**(TMPL-000005/006/009/010/011), 전부 봉투 base(005=OPP접착·006=OPP비접착·009=트레싱지·010=카드화이트·011=카드블랙)·전부 del_yn=N. "1행"은 gate(line 74)·manifest(PA-04)가 옮긴 과소 카운트를 페이지가 답습. 단 배경지 043/044 addon=0은 정확 | "엽서(PRD_000016)가 봉투 template 5종(005/006/009/010/011)을 addon으로 참조·배경지(043/044)는 0행"으로 정정. PA-CPQ-001 활성 template 목록도 005/006/009 → 005/006/009/010/011로 확장(010/011도 del_yn=N) |
| F-PA-4 | product-accessory#PA-DIM-002 앵커(line 56) | W3 | SCHEMA-MISMATCH(Low) | 앵커 `t_prd_product_bundle_qtys(QTY_UNIT)` — 라이브 단위 컬럼명 = `bdl_unit_typ_cd`(값이 QTY_UNIT.01/.02). `information_schema` → bundle 컬럼 = prd_cd,bdl_qty,**bdl_unit_typ_cd**,dflt_yn,... ("qty_unit_cd" 부존재). 값 코드(QTY_UNIT.01/.02)는 일치 | 앵커를 `t_prd_product_bundle_qtys(bdl_unit_typ_cd=QTY_UNIT.*)`로 컬럼명 정밀화 |
| F-PA-5 | product-accessory#PA-CPQ-001·#PA-ST-004 앵커 | W3 | SCHEMA-MISMATCH(Low) | 앵커 `t_prd_product_addons(addon_prd_cd)` — `addon_prd_cd` 컬럼 라이브 부존재(전 테이블 검색 0행). addons 실 키 = prd_cd(host)+tmpl_cd, 대상은 tmpl_cd→base_prd_cd 경유. `information_schema` addons 컬럼 = prd_cd,disp_seq,note,reg_dt,upd_dt,**tmpl_cd** | 앵커를 `t_prd_product_addons(prd_cd+tmpl_cd)`로 정정. addon 대상은 addon_prd_cd가 아닌 tmpl_cd가 가리키는 template의 base_prd_cd |

## 비파괴 확인 (반증 의심 → CORRECT 입증, finding 아님)

- **색상 자재 오염 양면표기(PA-BOM-002·PA-ST-002):** 라이브 재측정 006=8행·007=3행(실버/화이트/블랙 MAT_000210/212/213)·010=3행(사각검정/백색/마사 MAT_000217/219/220)·015=7행·012=1행 전부 MAT_TYPE.10 USAGE.07 — 페이지 mat_cd까지 완전 일치. F-PA-GATE-1 보정 충실 반영(MISSING→MIS-LOADED).
- **이중등록 의도(PA-ID-003):** `sql/09_delete_dup_products.sql` 삭제목록 = 099/113/114/115/116/117/167/182(8건)·281/282/283 부재 = 의도 보존. 라이브 004=.03·281/282/283=.05·283→CAT_000276 정상연결 전건 일치.
- **카테고리 고아(PA-ST-001):** 라이브 15상품 전부 CAT_000293(upr NULL·lvl3)·정상노드 276/285/287 전부 upr=012 lvl2 실재 — 재연결 패턴 입증.
- **가격사슬 0행(PA-PRC-001·PA-ST-003):** price_formulas 0·component_prices 테이블 실재·template_prices 테이블 실재(0행). 라이브 부재 양면표기 정확.
- **CPQ 미적재·테스트 잔재(PA-ST-002b):** option_items 전역 18행(silsa 파일럿)·001~015 옵션그룹 = PRD_000001 "테스트"·PRD_000002 "제본방식" 2행만 — 정확. ref_dim_cd 컬럼 실재.
- **template del_yn(PA-CPQ-001):** TMPL-000004~009 del_yn = 004/007/008·001/002/003=Y·005/006/009=N — 페이지 정확. (단 010/011도 N = F-PA-3 보정 대상)

## 재현 (사용 명령 — 비밀값 제외)

```bash
# W1 인용 실재성 — 소스 Read + sql/09 삭제목록
grep -nE "DELETE|PRD_000(281|282|283)" raw/webadmin/sql/09_delete_dup_products.sql

# W2 링크 무결성
python3 _workspace/print-kb/wiki/_qa/scripts/linkcheck.py
grep -nE '^### \[PA-ST' _workspace/print-kb/wiki/recipes/product-accessory.md   # 헤딩 PA-ST = 001/002/002b/003/004뿐

# W3 스키마 앵커 (read-only)
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -f _workspace/print-kb/wiki/_qa/scripts/w3-product-accessory.sql
# 핵심: addon은 PRD_000016 5행(005/006/009/010/011)·배경지 043/044 0행·색상 MAT_TYPE.10 006=8/007=3/010=3/015=7
# 컬럼명: bundle=bdl_unit_typ_cd / addons=(prd_cd,tmpl_cd) addon_prd_cd 부존재

# W6 CQ 커버리지
cd _workspace/print-kb && for cq in $(grep -ohE 'CQ-[A-Z]+-[0-9]+' wiki/recipes/product-accessory.md|sort -u); do grep -q "$cq" cq-registry.md && echo OK $cq; done   # 9/9

# W5 v03/stale
grep -niE 'v03|constraint_json|dep_proc_cd' _workspace/print-kb/wiki/recipes/product-accessory.md   # 전건 금지라벨/§245 격리
```

W3 스크립트 보존: `_qa/scripts/w3-product-accessory.sql`(재현용).
