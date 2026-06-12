# Axis Pack — load-path (webadmin 적재 경로)

> freshness 권위: impact-diagnosis I-4·I-5·I-6·I-7·I-10. round-13 결함축 ③(v03 정규화 진원). **v03 입력 xlsx 금지·load_master 로직은 oracle.**

## 정답 소스

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| 적재 oracle DDL+seed(01a~23) | `raw/webadmin/sql/01a~23_*.sql` | A | FRESH(HEAD bd12d03) |
| 상품마스터 적재 로직(전파기) | `raw/webadmin/tools/load_master.py`(로직만) | A | FRESH(로직)·**입력 xlsx=v03 금지** |
| 구간할인 적재 로직 | `raw/webadmin/tools/load_discounts.py` | A | FRESH |
| 배포·객체 기대치(테이블45·FK73·인덱스62·트리거37) | `raw/webadmin/tools/deploy.py` | A | FRESH |
| FK 위상순서·코드행 선적재 | `huni-dbmap/00_schema/code-identifier-strategy.md` + `15_domain-spec/<family>/mapping-info.md` | C | FRESH(전략)·mapping-info는 PARTIAL(I-6) |
| webadmin BaseAdmin 제너릭 적재명세 | `15_domain-spec/_loadspec/loadspec.md` | C(round-11) | PARTIAL-STALE(I-4·I-5·I-6: template_prices 누락·constraint_json L79·dep_proc_cd L96) |
| family별 적재본/실행본 | `09_load/<family>/`·`09_load/_exec*/` | C | PARTIAL-STALE(I-7 ON CONFLICT 구 PK·round-13 교정 전) |
| admin UI 입력경로(34 t_* 332컬럼) | `13_admin-ui-spec/admin-ui-spec.md`·`entities/` | C(round-9) | PARTIAL-STALE(I-10·I-11) — 입력경로 FRESH |
| 적재로직 재구성(load_master 규칙) | `17_correctness/<family>/loadlogic-notes.md` | C(round-13) | FRESH |
| 실 적재 현황("GO분 적재됨·차단/결정분 미적재") | CLAUDE.md §7 진행상태 + `09_load/_exec*/` 매니페스트 | C | FRESH |

## 보조 소스

- `raw/webadmin/docs/entity-table-map.md`·`fk-action-policy.md`·`naming-guide.md`·`handoff-2026-06-11.md`. tier A FRESH.
- `huni-admin-manual/manual/{02_product-register,07_masters}.md` — 운영자 입력 step. tier D FRESH(06-10 0드리프트).
- 메모리 dbmap-no-db-load-file-first(파일우선·등록/NULL/존재는 라이브 권위)·dbmap-code-identifier-strategy(채번 MAX+1·`_`)·dbmap-schema-design-intent-first(기계적 매핑 금지·삼중바인딩). FRESH.

## stale 함정

1. **v03 입력 xlsx 인용 금지 [HARD].** `load_master.py:39` 입력 = `prdmaster_full_migration_v03_20260518.xlsx`. 정답=상품마스터 L1(B-L1-PM). round-13이 v03을 결함 진원(③)으로 확정. load_master **로직(전파기)**만 oracle.
2. **constraint_json/dep_proc_cd 적재 타깃 — STALE(I-5·I-6).** `_loadspec/loadspec.md` L79·L96이 두 컬럼을 입력 컬럼으로 명시. 삭제됨. 제약=constraints.logic·게이팅=대체경로.
3. **ON CONFLICT 구 PK — PARTIAL(I-7).** `09_load/_exec*/` 적재 SQL이 구 PK(frm_cd/dsc_tbl_cd 포함)면 멱등 UPSERT 충돌. 새 PK (prd_cd, apply_bgn_ymd).
4. **라이브 적재값 = 교정대상(round-13).** "LOADED=행존재만"(round-7 D-1). 라이브값 인용 시 family correction-manifest 대조 → MIS-LOADED는 "오적재(교정 대기)".

## 미해결 GAP

- v03 상류 수정 vs DB 직접 교정 미결(BATCH-12·crosscut). [GAP-LP-1]
- template_prices 적재 경로(SKU 가격 오버라이드·I-4) 미반영. [GAP-LP-2]
- 카테고리 고아 113상품 재연결 미적재(BATCH-1·9 family). [GAP-LP-3]
- 실 교정 COMMIT은 인간 승인 대기(round-5/6/10 + 승인). [GAP-LP-4]
