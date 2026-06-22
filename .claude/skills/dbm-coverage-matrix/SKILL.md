---
name: dbm-coverage-matrix
description: >
  후니프린팅 상품마스터 전 상품군(시트) × 라이브 t_* 엔티티/관계를 3차원 입체 커버리지 매트릭스로 횡단 조망하는
  검증 방법론(round-7). 각 상품 필요요소(엑셀 권위)가 라이브 DB에 빠짐없이 적재됐는지·무엇이 미적재인지 한 판에서
  입증 — 라이브 psql 실측 + admin product-viewer 3원 대조 + FK/polymorphic 무결성 + 갭 보드 분류. DB 미적재.
  트리거: 입체 커버리지, 커버리지 매트릭스, 전 상품군 조망, 상품마스터 전수 검증, 미적재 조망, 엔티티 관계 무결성, 3원 대조, round-7, 매트릭스 재실행.
  단일 상품군 깊이 매핑(L1)은 dbm-mapping/dbm-price-formula, 단건 정합은 dbm-mapping-audit, CPQ 옵션은 dbm-cpq-option-mapping.
---

# dbm-coverage-matrix — 입체 커버리지 검증 방법론

## 1. 왜 입체인가 (방법의 핵심)

기존 매핑/검증은 **시트 하나를 종단으로 깊이** 파고든다(silsa 한 상품군의 9속성을 끝까지).
그러면 "이 상품군은 완성"이라는 국소 판정은 나오지만, **전 상품군에 걸쳐 무엇이 빠졌는지**는
보이지 않는다. 시트마다 따로 검증하면 빠진 것은 "검증을 안 한 시트"에 숨는다.

입체 커버리지는 **하나의 매트릭스**에 전 상품군(행) × 전 엔티티(열)를 동시에 올린다.
그러면 빈 셀(미적재)이 **공간적으로** 드러나고, "스티커는 공정이 있는데 굿즈는 왜 없지?" 같은
**횡단 비교**가 가능해진다. 깊이 검증이 못 보는 것을 너비가 본다.

> 권위 문서: `docs/goal-2026-06-08-01.md` (C1~C8 완료 기준).

## 2. 3축 정의

- **축 1 (행) = 상품군 시트** — 상품마스터 11 상품군(디지털인쇄·스티커·책자·포토북·캘린더·디자인캘린더·실사·아크릴·문구·굿즈파우치·상품악세사리). 메타 시트(계산공식집초안·MAP)는 행이 아니라 **공식/인덱스 참조원**.
- **축 2 (열) = t_\* 엔티티** — 상품에 매달리는 엔티티들. 최소 다음을 열로 둔다:
  - 코어: `t_prd_products`(상품 자체 존재)·`t_prd_product_categories`
  - 차원: `t_prd_product_sizes`·`t_prd_product_materials`·`t_prd_product_print_options`·`t_prd_product_processes`·`t_prd_product_plate_sizes`·`t_prd_product_bundle_qtys`·`t_prd_product_page_rules`·`t_prd_product_sets`·`t_prd_product_addons`
  - CPQ(L2): `t_prd_product_option_groups`/`options`/`option_items`·`t_prd_templates`·`t_prd_product_constraints`
  - 가격: `t_prd_product_price_formulas`(공식 바인딩)·`t_prc_component_prices`(단가 존재)
  - 할인: `t_prd_product_discount_tables`
- **축 3 (셀 깊이) = 정합·상태·관계** — 각 (상품군 × 엔티티) 교차에서:
  1. **필요 여부**: 이 상품군이 이 엔티티를 필요로 하는가? (엑셀 권위, §3)
  2. **적재 상태**: 라이브에 실제로 들어갔는가? `LOADED / PARTIAL / MISSING / N/A` (§5)
  3. **정합**: 들어간 값이 엑셀과 맞는가? (§4 3원 대조 — 대표상품)

## 3. 축2 필요요소 도출 — 엑셀이 권위

각 상품군 시트를 열어 **그 상품군이 어떤 t_\* 요소를 요구하는지** 도출한다. **추측 금지** — 시트에
명시된 컬럼/값만 근거로 삼고, 출처(시트명/행/컬럼)를 인용한다.

도출 규칙 (엑셀 컬럼 → 필요 엔티티):
- 사이즈/규격 컬럼 존재 → `t_prd_product_sizes` 필요
- 용지/소재/재질 컬럼 → `t_prd_product_materials` 필요
- 인쇄면/도수(단면/양면, 4도 등) → `t_prd_product_print_options` 필요
- 후가공/코팅/제본/박/타공/재단 컬럼 → `t_prd_product_processes` 필요
- 출력용지규격/판형 → `t_prd_product_plate_sizes` 필요 ([[dbmap-platesize-is-output-paper]])
- 묶음/포장단위 → `t_prd_product_bundle_qtys` 필요
- 페이지/면수 범위(책자·포토북) → `t_prd_product_page_rules` 필요
- 셋트 구성(하위상품) → `t_prd_product_sets` 필요
- 선택/가공/추가상품 옵션(굿즈/파우치류) → CPQ 옵션레이어 필요 ([[dbmap-option-material-process-bundle]])
- 가격(공식/단가) → `t_prd_product_price_formulas` + `t_prc_component_prices` 필요
- 구간할인 적용 → `t_prd_product_discount_tables` 필요

해당 없으면 그 셀은 `N/A`로 **명시**한다(공백은 "검증 안 함"과 구별 불가 — 금지).

## 4. 축3 정합 — 3원 대조 (엑셀 ↔ DB ↔ admin)

각 상품군에서 **대표상품 1개 이상 + 미적재 의심 상품**을 골라 세 소스를 교차한다:

1. **엑셀 (정답)** — 그 상품 행이 요구하는 요소·값.
2. **라이브 DB (사실)** — `prd_cd`로 각 t_* 자식 테이블을 읽기전용 조회한 실제 행.
3. **라이브 admin product-viewer (역할 UI)** — gstack browse로 그 상품을 열어 12편집탭이 무엇을 보여주는지. admin 탭 = t_* 엔티티의 역할 ground-truth ([[dbmap-live-admin-product-viewer]]).

세 소스가 일치하면 LOADED·정합. 불일치는 **증거(스크린샷 경로 / DB 행 / 엑셀 셀)와 함께** 갭 보드로.
admin 접속은 비용이 크므로 **전수 아님** — 대표 + 의심분 집중.

## 5. 적재 상태 실측 — 읽기전용 psql

각 셀 상태는 라이브 DB **실측 행수**로 판정한다(추출본 단독 판정 금지 — stale 위험 [[dbmap-no-db-load-file-first]]).

```bash
set -a; source .env.local; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
psql "host=$RAILWAY_DB_HOST port=$RAILWAY_DB_PORT user=$RAILWAY_DB_USER dbname=$RAILWAY_DB_NAME sslmode=require" \
  -v ON_ERROR_STOP=1 -At -c "SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd='PRD_000016';"
```

판정 기준:
- **LOADED** — 필요 요소가 라이브에 충분히 존재 (행수 > 0, 엑셀이 요구한 변형들 커버).
- **PARTIAL** — 일부만 존재 (예: siz 일부만 등록, 옵션 일부 BLOCKED).
- **MISSING** — 필요한데 0행.
- **N/A** — 그 상품군이 이 엔티티를 요구하지 않음.

[HARD] 라이브 DB는 **읽기전용 SELECT만**. 파괴적 쓰기·COMMIT 금지. 조회도 최소화(셀당 집계 1회 묶음 쿼리 권장).

## 6. 엔티티 관계 무결성

매트릭스는 셀(존재)뿐 아니라 **셀 사이의 선(관계)**도 본다:
- **FK 고아 검사** — 각 자식 테이블의 `prd_cd`·`siz_cd`·`mat_cd`·`*_typ_cd`가 부모에 실재하는가(고아 0).
- **CPQ polymorphic 해소** — `option_items.(ref_dim_cd, ref_key1[,ref_key2])`가 해당 상품의 라이브 차원행으로 해소되는가(트리거 `fn_chk_opt_item_ref`와 동일 검사). 도수=opt_id, 자재=mat_cd+usage_cd ([[dbmap-cpq-option-layer-mapping]]).
- **가격 사슬 연결** — 상품→공식바인딩→공식별구성요소→component_prices가 끊김 없이 이어지는가 ([[dbmap-price-chain-dwire-per-product-formula]]).
- **코드 FK** — `*_typ_cd`·`ref_dim_cd` 등이 `t_cod_base_codes`의 유효 코드값인가.

`relationship-integrity.md`에 검사별 PASS/FAIL + 위반 행을 기록.

## 7. 미적재 갭 보드 — 정직 분류

모든 MISSING/PARTIAL을 **원인유형 + 라우팅**으로 분류한다. over-report(없는 누락 날조)·under-report(은폐) 금지.

| 차단유형 | 의미 | 라우팅 |
|---------|------|--------|
| CODE-ROW | 코드행(siz/proc/mat) 미적재 | 코드행 선적재 제안 (인간 승인) |
| SIZ-REG | siz 미등록(신규 규격) | siz 등록 제안 |
| MAT-MINT | 자재 신규 채번 필요 | dbm-load-builder mint 제안 |
| DDL-GAP | 스키마 부족(컬럼/엔티티 없음) | dbm-ddl-proposer |
| DIM-UNLOADED | 참조 대상 차원행 미적재(L2 BLOCKED) | L1 선적재 |
| DOMAIN-UNDECIDED | 도메인 의미 미결정 | 사용자 [CONFIRM] |
| MAPPING-DEFECT | 매핑 자체 결함 | dbm-mapping-designer |

각 갭은 (상품군, 엔티티, 상품 예시, 차단유형, 증거, 라우팅, 인간승인 여부)를 한 행으로 기록한다.
**차단은 발명으로 닫지 않는다** — BLOCKED/GAP-DEFER로 정직하게 남긴다([[dbmap-domain-knowledge-before-asking]]).

## 8. 재현 스크립트 패턴

다음 세션 재실행을 위해 `12_coverage/scripts/`에 둔다:
- `extract_excel_requirements.py` — 상품마스터 11시트 → 상품군별 필요요소 (openpyxl, [[dbmap-l1-l2-extraction-first]] 전컬럼 행구조 보존).
- `probe_db_coverage.sh` — prd_cd 목록 × t_* 자식 테이블 행수 집계 (읽기전용, 묶음 쿼리).
- `build_matrix.py` — 위 둘을 합쳐 `coverage-cells.csv` + `coverage-matrix.md` 생성.

스크립트는 **결정적**이어야 한다(같은 입력 → 같은 매트릭스). 수작업 판정은 셀 note에 근거를 남긴다.

## 9. 출력 규약

- `coverage-matrix.md` — 행=상품군, 열=엔티티, 셀=상태아이콘(✅LOADED/🟡PARTIAL/❌MISSING/➖N/A) + 행수. 상단에 범례·집계(LOADED/PARTIAL/MISSING/N/A 카운트).
- `coverage-cells.csv` — (상품군, 엔티티, 필요여부, 상태, 행수, 근거셀, note) 1행/셀.
- `gap-board.md` — §7 분류표 + 갭 행 목록.
- `relationship-integrity.md` — §6 검사 결과.
- 모든 판정은 **증거 인용**(엑셀 시트/행/컬럼, DB 쿼리/행수, admin 캡처 경로). "보인다"는 금지.

## 10. 재호출 동작

기존 `12_coverage/` 산출물이 있으면 **변경된 상품군·엔티티 셀만** 재실측·갱신하고, 여전히 유효한
LOADED 판정은 note와 함께 이월한다. 매트릭스 전체를 매번 재생성하지 않는다(단, 라이브 DB 상태가
바뀌었으면 해당 열/행 재실측).
