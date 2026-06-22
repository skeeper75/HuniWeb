---
name: dbm-mapping-audit
description: >
  후니프린팅 DB 스키마와 상품마스터·가격표 엑셀의 매핑 정합을 상품별 9속성(사이즈·자재·인쇄옵션·공정·
  공정택일그룹·판형사이즈·묶음수·페이지룰·추가상품) 기준으로 검증/감사. 엑셀=원천 권위, 정규화 규칙대로
  변환한 기대행 대비 라이브 DB를 대조해 누락·잉여·불일치를 분류(이미 적재된 DB↔엑셀 정합 전용).
  트리거: DB 매핑 검증, 상품 매핑 정합, 적재 검증, 9속성 검증, 엑셀 DB 대조, 매핑 감사, 정합 재검증,
  특정 속성만 검증, 검증 다시. 매핑 설계·CSV는 dbm-mapping, 가격 공식은 dbm-price-formula 담당.
license: Apache-2.0
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-04"
  tags: "db-audit, mapping-verification, excel-db-reconcile, huni-dbmap, product-attributes"
---

# dbm-mapping-audit — 상품 매핑 정합 검증

후니프린팅 **DB 적재 상태 ↔ 엑셀 원천**의 정합을 상품별 9속성으로 검증한다. 매핑 *설계*(dbm-mapping)나 가격 *공식*(dbm-price-formula)이 아니라, **이미 DB에 적재된 데이터가 엑셀과 맞는지 감사**하는 것이 목적이다.

> **[2026-06-06 라이브 변경 — CPQ 구현]** 9속성 중 **공정택일그룹**(`t_prd_product_process_excl_groups`)은 라이브에서 **제거**되어 CPQ `t_prd_product_option_groups`(`sel_typ_cd`=SEL_TYPE; 제본 `GRP-BOOK`·캘린더 `GRP-CAL` 마이그)로 **흡수**됨. 해당 속성 검증 시 `option_groups`/`options`/`option_items`(polymorphic `ref_dim_cd`→OPT_REF_DIM + 트리거 `fn_chk_opt_item_ref`)를 참조한다. 라이브는 44테이블(CPQ 옵션/템플릿/제약 레이어 + 전 도메인 `del_yn`/`del_dt` 추가 — 적재값 추출 시 `del_yn='N'` 필터 인지). 상세 = `00_schema/cpq-schema.md`.

## 권위 원칙 (Why)

- **[교정] DB 정규화 규칙 = 기준 (엑셀=담을 내용, "단순 집합대조" 폐기).** 엑셀은 정규화 변환 전 원천이고, DB는 그것을 정규화 적재한 결과물이다. **엑셀≠DB가 곧 "DB 오류"가 아니다** — 정규화 변환 결과일 수 있다. 검증 기준 = "정규화 규칙대로 엑셀을 변환한 **기대행(expected rows)**" 대비 실제 DB. MISSING = "규칙대로면 적재됐어야 할 누락분". 구 프레임 "엑셀=권위 단순 집합대조"는 false MISSING을 낳아 폐기됨(포맥스 A1: 엑셀 E칸만 보고 작업사이즈 공백·행숨김 신호를 놓쳐 오판). 엑셀 자체 어색데이터는 본 스킬 범위 밖 — product-viewer 정정 트랙 참조.
- **기초데이터순 검증.** 마스터(코드·사이즈·자재·공정 사전)가 정합해야 상품별 연결이 의미 있다. FK 의존순: 마스터 코드 정합 → 상품별 속성 연결 정합. 마스터가 깨지면 상품 연결 검증은 신뢰 불가.
- **DB는 read-only.** 적재값 확인은 read-only 추출 1회로 파일화한 뒤 그 파일로 대조. 검증은 DB를 절대 변경하지 않는다(INSERT/UPDATE/DDL 금지).

## L1↔L2 2계층 + 정보 축 전수 (HARD — false MISSING 방지)

검증 결함의 뿌리는 매핑(L2)이 아니라 **엑셀 추출(L1)**이다. 1차가 속성별 단일컬럼 평면화(사이즈=E만)로 행내 관계(작업사이즈·행숨김)를 버려 false MISSING(포맥스 A1)을 냈다. 따라서:

- **L1 (충실추출, 선행)**: 엑셀 전 컬럼을 행구조 그대로, 어느 정보축도 버리지 않고 추출 → 원본과 셀단위 자동대조로 누락0 기계보증. 방법=`dbm-excel-parse`의 "L1 충실추출" 섹션, 산출 `06_extract/`(검증된 토대 `product-info-foundation.md`).
- **L2 (정합검증, 본 스킬)**: L1 토대 위에서 9속성 정합 판정. L1 미완·미검증이면 L2 진입 금지.
- **정보 축 8개(추출 필수)**: ①값 ②행숨김 ③열숨김 ④셀코멘트 ⑤배경색/글자색 ⑥수식여부 ⑦하이퍼링크 ⑧병합(그룹헤더 composite). 미사용 확정(무시): 취소선·아웃라인·필터·유효성.
- **의미 코드맵(시트 footnote 근거)**: 노랑배경=신규(MES미등록) / **그레이배경 셀=품절·준비중(미출시)** / **그레이 글자·숨김열=내부용(UI미노출, 생산/가격계산)** / **행숨김=사용안함(비활성/단종)** / ★빨강=옵션제약 / 오렌지=개발무시 / (포토북)핑크=편집기사양.
- **L2 판정 시 [HARD]**: 숨김/미출시 행·셀은 **"비활성"으로 분류(MISSING 아님)**. `*별도설정` 자재는 가격표 **출력소재(IMPORT)** 시트의 해당 상품컬럼 ●종이가 실값(빈값 처리 금지).

## 9속성 ↔ DB 테이블 (검증 대상)

| # | 속성 | DB 테이블 | 마스터 참조 | JOIN/식별 |
|---|------|-----------|------------|-----------|
| 1 | 사이즈 | `t_prd_product_sizes` | `t_siz_sizes` | prd_cd + siz_cd |
| 2 | 자재 | `t_prd_product_materials` | `t_mat_materials` | prd_cd + mat_cd (+ usage_cd) |
| 3 | 인쇄옵션 | `t_prd_product_print_options` | — | prd_cd + 옵션키 |
| 4 | 공정 | `t_prd_product_processes` | `t_proc_processes` | prd_cd + proc_cd |
| 5 | 공정택일그룹 | `t_prd_product_process_excl_groups` | (SEL_TYPE) | prd_cd + grp |
| 6 | 판형사이즈 | `t_prd_product_plate_sizes` | (OUTPUT_PAPER_TYPE) | prd_cd + plate |
| 7 | 묶음수 | `t_prd_product_bundle_qtys` | (QTY_UNIT) | prd_cd + bdl_qty |
| 8 | 페이지룰 | `t_prd_product_page_rules` | — | prd_cd |
| 9 | 추가상품 | `t_prd_product_addons` | — | prd_cd + addon |

[HARD] JOIN KEY 주의: `MES_ITEM_CD`는 전부 NULL일 수 있다(상품 식별은 `prd_nm` 기준). `MES_ITEM_CD`는 대문자·따옴표 식별자. 마스터-상품 연결은 prd_cd, 엑셀-DB 매칭은 prd_nm(상품명)을 키로 한다. 컬럼·코드 존재는 `00_schema/columns.csv`·`code-values.md`로 확인 후 단정.

## 검증 절차 (기초데이터순)

### Step 0 — 입력 확정
- 엑셀: `docs/huni/후니프린팅_상품마스터_260527.xlsx`, `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`
- DB 적재값: `00_schema/ref-*.csv`에 있으면 재사용. 없는 9속성 테이블은 **read-only 1회 추출**해 `00_schema/ref-<table>.csv`로 저장(`.env.local` RAILWAY_DB_*, 비밀번호 비출력).

### Step 1 — 마스터 정합 (선행)
사이즈·자재·공정·코드 마스터가 엑셀 코드체계와 정합하는지 먼저 검증한다. 마스터 코드가 누락/불일치면 그 코드를 참조하는 상품 연결은 자동 의심 대상으로 표기. 마스터 검증 없이 상품 연결 검증으로 진행하지 말 것(거짓 정합 위험).

### Step 2 — 상품별 속성 연결 정합 (속성별)
각 속성에 대해 상품별(prd_nm) DB 적재값 ↔ 엑셀 원천값을 대조하고 4분류한다:

| 분류 | 의미 | 신호 |
|------|------|------|
| ✅ MATCH | 엑셀=DB 일치 | 정합 |
| 🔴 MISSING | 엑셀O · DB X | DB 적재 누락 (예: 묶음수 4행뿐인데 엑셀엔 더 있음) |
| 🟡 EXTRA | DB O · 엑셀 X | DB 잉여 (엑셀에 근거 없는 적재) |
| 🟠 MISMATCH | 양쪽 존재·값 다름 | 값 불일치 (수량/코드/순서) |

[HARD] 권위=엑셀이나, EXTRA(DB 잉여)를 "삭제 대상"으로 단정하지 말 것 — 엑셀 외 정당한 원천일 수 있으므로 출처 병기하고 플래그만. 발견은 삭제하지 말고 출처와 함께 기록.

### Step 3 — 정량 집계 + 리포트
속성별 MATCH/MISSING/EXTRA/MISMATCH 카운트 + 상품별 불일치 명세. 마스터 정합 결과를 상단에 두어 "마스터가 깨진 채 상품 연결만 맞는 거짓 정합"을 구분.

## 산출물 (한국어 [HARD])

`_workspace/huni-dbmap/04_audit/` 하위(검증 트랙 전용):
- `00_master-parity.md` — Step 1 마스터 정합(사이즈/자재/공정/코드)
- `<attr>-parity.md` — 속성별 정합 리포트 (9속성, 또는 단계별 진행분)
- `<attr>-mismatches.csv` — 속성별 불일치 명세 (prd_nm, 분류, 엑셀값, DB값, 비고)
- `audit-summary.md` — 9속성 종합 정합 대시보드 (속성별 MATCH/MISSING/EXTRA/MISMATCH 표) + GO/이슈 목록

[HARD] 산출 .md는 **한국어**. 식별자·테이블·컬럼·코드·SQL은 영어. 판정마다 근거(어느 엑셀 시트/행 ↔ 어느 DB 테이블/값) 명시.

## 재실행 / 부분 검증

- 이전 산출(`04_audit/`)이 있고 특정 속성만 재검증 요청 → 해당 속성 리포트만 갱신, 나머지 보존.
- 엑셀·DB가 갱신됐으면 read-only 재추출 후 재대조. **추출본 stale 주의**: ref-*.csv가 옛 스냅샷일 수 있으므로, "비어있다/없다/NULL" 판정은 검증 시점 라이브 read-only로 확증(과거 권위반전 교훈: 추출본 NULL ≠ 라이브 NULL).

## HARD 제약 요약

- DB read-only만(SELECT/\\d). INSERT/UPDATE/DDL·적재 절대 금지. 비밀번호 비출력.
- 엑셀=권위, DB 정합 검증. EXTRA는 삭제 단정 금지(플래그+출처).
- 마스터 선행(기초데이터순). 마스터 미검증 상태로 상품 연결 정합 단정 금지.
- 산출 한국어, 식별자 영어. 추정 금지(컬럼/코드는 추출본·라이브로 확인), 불확실=「확인 필요」.
- 추출본 stale 가능 — 존재/NULL 판정은 라이브 확증.
