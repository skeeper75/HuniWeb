# Source Registry — Print-KB 위키 큐레이션 (graded inventory)

> 작성 2026-06-12 · pkw-source-curator Phase 1. 위키 집필(pkw-recipe-writer)·검증(pkw-wiki-qa)의 입력.
> **freshness 권위 [HARD]:** `_workspace/huni-dbmap/18_schema-change/impact-diagnosis.md`(round-14, I-1~I-11). round-2/6/11/12/13 산출의 MAJOR stale 축이 문서별로 표기된다.
> **v03 금지 [HARD]:** `prdmaster_full_migration_v03` 계열은 정답 참조 금지(등재만·tier=금지).
> 이 레지스트리는 기존 `_workspace/print-kb/source-registry.md`(2026-06-05, 출처 3계층)를 superseded 하지 않고 보강한다(원본 유지).

## tier 정의

| tier | 의미 | 예 |
|------|------|----|
| **A** | 라이브 스키마/실측 권위(information_schema·라이브 psql·webadmin sql/tools) | `00_schema/_live-schema-dump-260606.txt`, `raw/webadmin/sql/`, 라이브 SELECT |
| **B** | 엑셀 상품마스터 L1 + 실무진 확정(Q1~Q15) | `06_extract/<slug>-l1.csv`, `15_domain-spec/*/domain-research-notes.md`(컨펌) |
| **C** | round 산출 문서(최신 round 우선) | `15_*`/`16_*`/`17_*` 분석본 |
| **D** | 역공학/외부(후보) | `huni-widget/`·`07_domain/benchmark-*` |
| **금지** | v03 마이그레이션 산출 | `raw/webadmin/tools/load_master.py:39` 입력 xlsx |

## freshness 정의

- **FRESH** — round-14 진단상 stale 축 없음.
- **PARTIAL-STALE(축)** — 특정 축(I-N)만 stale, 나머지 유효. 인용 시 해당 축 회피.
- **STALE** — 인용 금지(대체 소스 지목).

---

## A. 라이브 스키마/적재 oracle (tier A — 최상위 권위)

| src_id | 경로 | 내용 요약 | freshness | 담당 축 |
|--------|------|-----------|-----------|---------|
| A-LIVE-DUMP | `huni-dbmap/00_schema/_live-schema-dump-260606.txt` | 라이브 t_* DDL 덤프(06-06 시점) | PARTIAL-STALE(I-1·I-4·I-5·I-6·I-11: proc_cd/opt_cd/prc_typ/use_dims/template_prices 신설·constraint_json/dep_proc_cd 삭제·34→35 미반영) | schema |
| A-COLUMNS | `huni-dbmap/00_schema/columns.csv` | t_* 전 컬럼 인벤토리 | PARTIAL-STALE(I-10·I-11 신규 컬럼/35테이블 미반영) — **컬럼 권위는 라이브 information_schema 재실측** | schema |
| A-REF-* | `huni-dbmap/00_schema/ref-*.csv` (products·sizes·materials·processes·product-materials·product-processes·product-sizes·product-plate-sizes·product-print-options·base-codes·color-counts·product-addons·product-sets·product-bundle-qtys·product-page-rules·product-process-excl-groups·sizes) | 라이브 행 덤프(06-04) — 행수/연결 실측 | PARTIAL-STALE(06-04 스냅샷·round-13 MIS-LOADED 미반영·option_items 0행 표기 stale) | load-path·materials·processes |
| A-PLATE | `huni-dbmap/00_schema/live-plate-sizes-full.csv` | 라이브 plate(출력용지규격) 전수 | FRESH | price-engine·dimensions |
| A-SQL | `raw/webadmin/sql/01a~23_*.sql` | 적재 oracle DDL+seed(01a~23). 18~23=Phase10/11(PK통일·meta·template_prices·pricing_dims·use_dims·drop_columns) | FRESH(소스 오브 트루스·git HEAD bd12d03) | load-path·schema |
| A-LOADMASTER | `raw/webadmin/tools/load_master.py` | 상품마스터 적재 로직(전파기). **입력 xlsx=v03(금지)** — 로직만 oracle, 입력 정답은 L1 | FRESH(로직)·입력 xlsx는 금지 | load-path |
| A-LOADDISC | `raw/webadmin/tools/load_discounts.py` | 구간할인 적재 로직 | FRESH | price-engine(discount) |
| A-DEPLOY | `raw/webadmin/tools/deploy.py` | SQL_FILES 17~23·객체 기대치(테이블45·FK73·인덱스62·트리거37) | FRESH | schema |
| A-INITDIMS | `raw/webadmin/tools/init_use_dims.py` | use_dims 백필 스크립트(신규) | FRESH | price-engine |
| A-WEBADMIN-DOCS | `raw/webadmin/docs/{entity-table-map.md,naming-guide.md,fk-action-policy.md,handoff-2026-06-11.md}` | webadmin 측 명명·FK·핸드오프. handoff-06-11=Phase10/11 후 | FRESH(handoff-06-11) | load-path |
| A-WEBADMIN-PRICEDOC | `raw/webadmin/docs/{pricing-erd.md,prcx01-pricing-model.md}` | webadmin 측 가격 ERD·가격모델 설계 문서 | **STALE(델타 2026-06-18)** — 8차원·`clr_cd`(도수)·`frm_typ_cd` 시절. 신규 A-PED-CODE(design-artifact-trace)가 엔진 미참조·라이브 부재 확정. **구조·차원·단가유형·도수 인용 금지**, 의도 배경(직접단가 vs 공식 등) only. 대체=A-PED-* + A-PQ-CONTRACT + pricing.py 직접 | price-engine |

---

## B. 엑셀 L1 + 실무진 확정 (tier B — 정답 oracle)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| B-L1-PM | `huni-dbmap/06_extract/<slug>-l1.csv` (digital-print·sticker·booklet·photobook·calendar·design-calendar·acrylic·silsa·goods-pouch·product-accessory·stationery) + `-l1-meta.csv` | 상품마스터 13시트 무손실 L1 추출. **상품 정체·차원·자재/공정의 정답 권위(v03보다 상위)** | FRESH(260527 버전) | 전 family |
| B-L1-PRICE | `huni-dbmap/06_extract/price-<slug>-l1.csv` (digital-print-price·coating·folding·post-process·cutting·sticker-price·gangpan-sticker·envelope·namecard-photocard·foil-small·foil-large·postcard-book·binding·acrylic-price·poster-sign) | 가격표 15단가시트 L1 | FRESH | price-engine |
| B-L1-AUX | `huni-dbmap/06_extract/{pangeori-l1.csv,import-paper-l1.csv,import-paper-matrix-long.csv,seoljeong-import-map.csv}` | 판걸이수(판형 마진 권위)·출력소재IMPORT(별도설정 자재 권위)·별도설정 매핑 | FRESH | dimensions·materials |
| B-SLUGMAP | `huni-dbmap/06_extract/sheet-slug-map.md` | 한글시트↔영문슬러그·시트 구조 비고 | FRESH | 전 family(네비) |
| B-L1-REPORT | `huni-dbmap/06_extract/all-sheets-l1-report.md`·`silsa-l1-report.md` | L1 추출 종합 리포트 | FRESH | 전 family |
| B-CONFIRM | `huni-dbmap/15_domain-spec/*/domain-research-notes.md` 내 컨펌 + 메모리 round-11(Q1~Q15 실무진 회신) | 박/코팅=공정·우드거치대=자재·도무송 형상=size칼틀1:1·반제품=제본 전체관점·디자인=1상품+에디터템플릿 등 | FRESH | processes·materials·cpq |
| B-PDF-PROC | `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf` → `07_domain/pdf-domain-knowledge.md` | 17 Case 공정 흐름 | FRESH | processes |
| B-XLS-PM-610 | `docs/huni/후니프린팅_상품마스터_260610.xlsx` | 신규 버전(round-10 변경추적 입력) | FRESH(델타만·본문은 260527 L1 권위) | change-tracking |

---

## C. round 산출 문서 (tier C — 최신 round 우선)

### C0. 스키마/공통 (00_schema·07_domain)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-INTENT | `huni-dbmap/00_schema/schema-design-intent-map.md` | t_* 측 설계의도+삼중바인딩 ERD(round-9/11 결합) | PARTIAL-STALE(I-5·I-6: ERD에 constraint_json L91·dep_proc_cd L111 표기·삭제 미반영) — **삼중바인딩 개념은 FRESH** | schema·전 family |
| C-PRICEENG | `huni-dbmap/00_schema/price-engine-ddl.md` | t_prc_* 4단 가격엔진 구조·fit-gap | **STALE(I-1·I-2·I-3·I-4·I-7)** — "6차원/8컬럼 자연키"·단가형/합가형 부재·template_prices 누락·구 PK. 인용 시 가격엔진 구조는 **A-SQL(21·22) + webadmin pricing-erd 대조 필수** | price-engine |
| C-CPQSCHEMA | `huni-dbmap/00_schema/cpq-schema.md` | CPQ 7테이블·트리거·excl_groups | PARTIAL-STALE(I-5·I-8·I-11: constraint_json 삭제·RULE_TYPE 2종·34→35) | cpq-options |
| C-CODEVAL | `huni-dbmap/00_schema/code-values.md`·`ref-base-codes.csv` | base_codes 코드값 도메인 | PARTIAL-STALE(I-8: RULE_TYPE.01 비활성·PRICE_TYPE 3종 신설 미반영) | 전 axis |
| C-CODEID | `huni-dbmap/00_schema/code-identifier-strategy.md` | 채번·식별·멱등 전략(`_` separator) | FRESH | load-path |
| C-SCHEMAREL | `huni-dbmap/00_schema/schema-relationship-analysis.md` | 06-06 재실측 행수·FK 관계 | PARTIAL-STALE(I-11·option_items 0행 표기) — 행수는 06-06 권위 | schema |
| C-SCHEMAOV | `huni-dbmap/00_schema/schema-overview.md` | 34 t_* 개요 | PARTIAL-STALE(I-11: 34→35) | schema |
| C-PRODRES | `huni-dbmap/00_schema/product-resolution.md`·`resolved-prd.csv` | 상품 prd_cd 해소 | FRESH | 전 family |
| C-DISCDOM | `huni-dbmap/00_schema/discount-domain-detail.md` | 구간할인 도메인 | PARTIAL-STALE(I-7: discount_tables PK 통일) | price-engine |
| C-ENTSEM | `huni-dbmap/07_domain/entity-semantic-model.md` | 엔티티 의미모델(제본/UV 표준 인용) | FRESH | materials·processes |
| C-PROCTREE | `huni-dbmap/07_domain/process-recipe-tree.md` | 공정 레시피 트리(인쇄방식별 택일) | FRESH | processes |
| C-DBLIVE | `huni-dbmap/07_domain/db-domain-structure-live.md` | 라이브 DB 도메인 구조 | PARTIAL-STALE(I-11·신규컬럼) | schema |

### C1. 가격엔진 매핑 (02_mapping — round-2/후속)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-MAP-DGP | `huni-dbmap/02_mapping/digital-print-engine/` | 디지털인쇄 원자합산형 6공식(PRF_DGP_A~F)·용지비 | PARTIAL-STALE(I-1·I-2: 차원/단가유형 미반영) — 공식사슬·적재값 FRESH | price-engine(digital) |
| C-MAP-SILSA | `huni-dbmap/02_mapping/silsa-poster-area-matrix/`·`silsa-price-engine/` | 실사=포스터사인 면적매트릭스 가격 | PARTIAL-STALE(I-1·I-3) — 면적매트릭스 모델 FRESH | price-engine(silsa) |
| C-MAP-P211 | `huni-dbmap/02_mapping/price211-{direct,fixedgrid,booklet-photobook,sticker-namecard}/` | 가격표 평면화(direct/fixed/booklet/sticker) | PARTIAL-STALE(I-1·I-2·I-3) | price-engine |
| C-MAP-DWIRE | `huni-dbmap/02_mapping/dwire-poster-formula-remodel/`·`dwire-bind-namecard-photocard-remodel/` | 상품별 공식 PRF_<X> 재모델(가격사슬 단절 해소) | FRESH(상품별공식 도출) | price-engine |
| C-MAP-CORR | `huni-dbmap/02_mapping/correction/`·`correction-price/` | round-13 교정 적재 | PARTIAL-STALE(I-6) | load-path |

### C2. 적재본/실행본 (09_load — round-4/5/후속)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-LOAD-FAM | `huni-dbmap/09_load/<family>/` (전 11 family + design-calendar) | family별 적재 매니페스트·CSV | PARTIAL-STALE(round-13 교정 전·일부 MIS-LOADED 반영분 혼재) | load-path |
| C-LOAD-EXEC | `huni-dbmap/09_load/_exec*/` (_exec·_exec_dgp·_exec_env·_exec_price·_exec_silsa_*·_exec_postcard_cpq) | 멱등 UPSERT 실행본(실제 COMMIT 분 포함) | PARTIAL-STALE(I-7: ON CONFLICT 구 PK) — 적재값 FRESH | load-path |
| C-LOAD-MIG | `huni-dbmap/09_load/_migrate_*/` (areamatrix·fixedprice·gp_circle·plate_load_guk4) | 가격 siz 권위정정 마이그레이션 | FRESH | price-engine |
| C-LOAD-ASM | `huni-dbmap/09_load/_assembled/`·`_assembled_price/` | round-4 적재본 조립 | PARTIAL-STALE | load-path |

### C3. CPQ 옵션 레이어 (10_configurator — round-6)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-CPQ-ATTRMAP | `huni-dbmap/10_configurator/attribute-entity-map.md` | 속성→4엔티티(차원/CPQ옵션/가격/제약) 마스터 지도 | PARTIAL-STALE(I-5·I-9) | cpq-options |
| C-CPQ-DESIGN | `huni-dbmap/10_configurator/cpq-design.md` | CPQ 옵션 레이어 설계·JSONLogic 제약 | PARTIAL-STALE(I-5·I-8·I-9: constraint_json·RULE_TYPE 2종·옵션 in 비교) | cpq-options |
| C-CPQ-SILSA | `huni-dbmap/10_configurator/silsa-option-layer-v2.md`·`silsa-live-reconciliation.md` | silsa CPQ 파일럿(43행 COMMIT 실증) | FRESH | cpq-options |
| C-CPQ-POSTCARD | `huni-dbmap/10_configurator/postcard-option-layer.md`·`postcard-walkthrough*.md` | 엽서 옵션 파일럿 | FRESH | cpq-options |
| C-CPQ-OTC | `huni-dbmap/10_configurator/all-sheets-otc-extract.md`·`option-vs-template-guide.md` | OTC TEMPLATE 추출·옵션vs템플릿 가이드 | FRESH | cpq-options |
| C-CPQ-GOODS | `huni-dbmap/10_configurator/huni-goods-option-mapping.md`·`wowpress-option-model.md` | 굿즈 옵션 매핑·WowPress 6축 흡수 | FRESH(D보조: wowpress 역공학) | cpq-options·materials |
| C-CPQ-GAPS | `huni-dbmap/10_configurator/cpq-option-gaps.md`·`design-decisions-pack.md`·`HANDOFF.md` | CPQ GAP·설계결정 | FRESH | cpq-options·gaps |
| C-CPQ-GT | `huni-dbmap/10_configurator/live-admin-groundtruth.md`·`live_admin_capture/` | admin product-viewer ground-truth | FRESH | cpq-options·widget-contract |

### C4. admin UI 명세 (13_admin-ui-spec — round-9)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-ADMINUI | `huni-dbmap/13_admin-ui-spec/admin-ui-spec.md`·`entities/` | 34 t_* 332컬럼 입력명세(라벨·위젯·코드값·입력화면) | PARTIAL-STALE(I-10·I-11: usr_def/tags 컬럼·35테이블 미반영) — 입력경로는 FRESH | load-path·widget-contract |

### C5. 도메인 스펙 (15_domain-spec — round-11)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-DS-COLDICT | `huni-dbmap/15_domain-spec/<family>/column-dictionary.md` | family별 엑셀 컬럼 의미축→목표 t_* | FRESH | 전 family(차원/자재/공정) |
| C-DS-BOM | `huni-dbmap/15_domain-spec/<family>/product-bom.md` | family별 상품 자재/공정 BOM | FRESH | materials·processes |
| C-DS-MAPINFO | `huni-dbmap/15_domain-spec/<family>/mapping-info.md` | 컬럼→t_* 통합·FK 적재순서 | PARTIAL-STALE(I-6: dep_proc_cd 게이팅 참조 family 있음) | load-path |
| C-DS-NOTES | `huni-dbmap/15_domain-spec/<family>/domain-research-notes.md` | 컨펌·도메인 연구노트(Q1~Q15 회신 포함) | FRESH | 전 family |
| C-DS-LOADSPEC | `huni-dbmap/15_domain-spec/_loadspec/loadspec.md` | webadmin BaseAdmin 제너릭 적재명세 | PARTIAL-STALE(I-4·I-5·I-6: constraint_json L79·dep_proc_cd L96·template_prices 누락) | load-path |

### C6. 매핑 확정 리서치 (16_mapping-research — round-12, 5 family만)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-MR-FINAL | `huni-dbmap/16_mapping-research/<family>/mapping-final.md` (digital-print·sticker·booklet·photobook·calendar) | family별 매핑 확정(4 권위 결합+갭헌팅) | PARTIAL-STALE(I-5: digital-print "180g→constraint_json" 타깃 무효) — 그 외 FRESH | 5 family 매핑 |
| C-MR-GAP | `huni-dbmap/16_mapping-research/<family>/research-gap-board.md` | 갭보드(경쟁사/CIP4/ISO 대조·신규 갭 0) | FRESH | gaps |
| C-MR-LIVE | `huni-dbmap/16_mapping-research/<family>/live-crosscheck.md` | 라이브 실측 대조 | PARTIAL-STALE(round-13이 일부 라이브값 오적재 확정) | load-path |

### C7. 라이브 정합 교정 (17_correctness — round-13, 전 11 family) — "현재값 vs 정답" 양면 권위

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-CO-IDENT | `huni-dbmap/17_correctness/<family>/product-identity.md` | 상품 정체(실제 사이트 huniprinting.com 대조) | FRESH(round-13·정체 권위) | 전 family 정체 |
| C-CO-EXTRACT | `huni-dbmap/17_correctness/<family>/extraction-plan.md` | 상품별 추출규칙(size·자재·공정·도수) | PARTIAL-STALE(I-6: digital-print oracle dep_proc_cd 컬럼 기반) | 전 family |
| C-CO-DIFF | `huni-dbmap/17_correctness/<family>/live-diff.md` | 라이브 전수 diff | FRESH(round-13 실측) | load-path |
| C-CO-MANIFEST | `huni-dbmap/17_correctness/<family>/correction-manifest.md` | 교정 매니페스트(CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS + why + how) | FRESH(round-13·결함현황 권위) | 전 family 결함현황 |
| C-CO-LOADLOGIC | `huni-dbmap/17_correctness/<family>/loadlogic-notes.md` | 적재로직 재구성 노트(load_master 규칙) | FRESH | load-path |
| C-CO-SYNTH | `huni-dbmap/17_correctness/_crosscut/crosscut-synthesis.md` | 횡단 결함 종합(171 finding·패턴축①②③+A~I) | FRESH | 전 axis 결함 |
| C-CO-BATCH | `huni-dbmap/17_correctness/_crosscut/batch-confirmations.md` | 14 결정점(BATCH-1~14·비전문가용) | FRESH | gaps |
| C-CO-ROADMAP | `huni-dbmap/17_correctness/_crosscut/remediation-roadmap.md` | 교정 로드맵 | FRESH | load-path |
| C-CO-GATE | `huni-dbmap/17_correctness/_gate/<family>-gate.md`·`crosscut-gate.md` | family별 게이트(보정 반영 채택분) | FRESH | 전 family |

### C8. 변경 추적 (14_change-tracking·18_schema-change)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-CT-1060 | `huni-dbmap/14_change-tracking/260527-to-260610/` | 상품마스터 버전 델타(추가/삭제 0·527셀 MODIFIED) | FRESH | change-tracking |
| C-SC-IMPACT | `huni-dbmap/18_schema-change/impact-diagnosis.md` | **freshness 권위 본체**(I-1~I-11) | FRESH | 전 축 stale 판정 |

### C9. 기타 round (04_audit·05_method·08_remediation·12_coverage)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| C-AUDIT | `huni-dbmap/04_audit/` | round-3 9속성 매핑 audit(L2 v2 GO) | PARTIAL-STALE(구 스키마) | mapping |
| C-METHOD | `huni-dbmap/05_method/` (A~G·F2-price-sheet-structures.md) | L1/L2 추출 방법론·가격시트 구조 카탈로그 | FRESH | 방법론 |
| C-REMED | `huni-dbmap/08_remediation/` | round-3 결함 처리 적재 설계 | PARTIAL-STALE | load-path |
| C-COV | `huni-dbmap/12_coverage/` | round-7 입체 커버리지 209셀 매트릭스 | PARTIAL-STALE(I-10·I-11·option_items 0행 당시) | coverage |

### C10. ★가격엔진 실측 하네스 (2026-06-18 — 라이브 information_schema + pricing.py 실측) — tier A·FRESH

> 두 하네스는 round 산출(tier C)이 아니라 **라이브 코드·스키마 직접 실측**이므로 tier A로 등재. 가격 축의 **최상위 FRESH 권위**(구조·차원·엔진 거동). 기존 round-2 가격 매핑 산출(C-MAP-*) 및 prcx01/pricing-erd 설계 문서를 **supersede**(구조·차원·단가유형·도수 한정).

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| A-PED-SOT | `huni-price-engine-diag/01_mechanism/sot-definitions.md` | **사용자 7 SOT(권위 도메인 정의)** — 11시트=허용 차원 경계(SOT1)·결합/독립 구성요소(SOT2)·10차원(SOT3b)·옵션 BUNDLE 가격없음(SOT3a)·제약 부재=오적재 근본(SOT4)·가격소스 우선순위(SOT5)·수량×단가 두 갈래(SOT6) | FRESH·**최상위 권위** | price-engine |
| A-PED-DEVICE | `huni-price-engine-diag/01_mechanism/device-roles.md`·`combination-mechanism.md`·`knowledge-map.md` | 5 가격 장치 역할·결합 메커니즘·지식맵(SOT 반영) | FRESH | price-engine |
| A-PED-CODE | `huni-price-engine-diag/02_code_schema/{code-schema-matrix,price-source-intent,constraint-mechanism-gap,impl-gap-board,design-artifact-trace}.md` | 코드↔스키마 정합 매트릭스·가격소스 의도·**배선 제약 부재 실증**·구현 갭 보드·**prcx01/erd STALE 추적** | FRESH | price-engine |
| A-PED-SYN | `huni-price-engine-diag/03_synthesis/{known-vs-unknown,sot-reconciliation,engine-comprehension,verify-handoff}.md` | **K-1~8 확정/U-1~6 미지/C-1~3 컨펌큐**·SOT 정합·종합 이해 | FRESH | price-engine |
| A-PQ-CONTRACT | `huni-price-quote/01_engine/{engine-contract,price-flow-map,widget-price-contract}.md` | **`evaluate_price` 권위 계약(검증의 자·pricing.py:line 인용 C1~C9)**·흐름도·위젯 가격 계약 | FRESH·**엔진 거동 권위** | price-engine·widget-contract |
| A-PQ-AUTH | `huni-price-quote/02_authority/{authority-golden,golden-cases,authority-gaps}.md` | **골든 케이스(권위 엑셀 기대값)**·적재 갭 | FRESH | price-engine |
| A-PQ-CHAIN | `huni-price-quote/03_chain/{dimension-mapping-matrix,chain-defect-board,size-dedup-report}.md` | 10차원↔단가행 3원 대조·**가격사슬 결함보드 D-1~D-7**·사이즈 무중복 | FRESH | price-engine |
| A-PQ-OPTION | `huni-price-quote/04_option/{option-bundle-board,process-json-report,template-constraint-board}.md` | 옵션 BUNDLE 무결성·공정 dim_vals·템플릿/제약 정합 | FRESH | price-engine·cpq-options |
| A-PQ-GATE | `huni-price-quote/05_gate/{gate-verdict,arbiter-deliberation-N1,confirmed-defects,recompute-log}.md` | **P1~P7 CONDITIONAL-GO(면적매트릭스 GO·합산형 엽서 NO-GO N-1)**·arbiter 심의·확정 결함·재계산 로그 | FRESH·**검증 판정** | price-engine |

---

## D. 역공학/외부 (tier D — 후보)

| src_id | 경로 | 내용 요약 | freshness | 담당 |
|--------|------|-----------|-----------|------|
| D-WIDGET-PRICE | `huni-widget/01_reverse/price-engine-reversed.md`·`03_spec/price-engine.md` | RedPrinting 가격엔진 역공학(후보·후니 가격과 정합 금지) | FRESH(D) | widget-contract |
| D-WIDGET-DATA | `huni-widget/03_spec/data-contract.md`·`data-adapter.md`·`api-contract.md` | 위젯 정규화 데이터 계약·어댑터 | FRESH(D) | widget-contract |
| D-WIDGET-CT | `huni-widget/03_spec/componenttype-mapping-matrix.md`·`component-tree.md` | 14 componentType↔shadcn 매핑 | FRESH(D) | widget-contract |
| D-WIDGET-DBMAP | `huni-widget/03_spec/huni-db-mapping.md`·`huni-red-matching-methodology.md` | 후니 DB↔위젯 매핑 방법론 | PARTIAL-STALE(라이브 스키마 변경 미반영 가능) | widget-contract |
| D-WIDGET-FAM | `huni-widget/03_spec/{s4-acryl,s5-goods-pouch,s6-calendar}-spec.md` | family별 위젯 스펙(아크릴·굿즈파우치·캘린더) | FRESH(D) | widget-contract |
| D-WIDGET-PARITY | `huni-widget/07_parity/parity-matrix-*.md`·`red-code-map-*.md` | Red 동등성 검증 매트릭스 | FRESH(D) | widget-contract |
| D-DESIGN | `print-quote/04_design/DESIGN.md`·`screen-inventory.md` | 14 componentType·화면설계 | FRESH(D) | widget-contract |
| D-PQ-BIZ | `print-quote/02_business/{product-master,pricing-rules,process-flow,glossary}.md` | 사업분석(상품마스터·가격규칙·공정·용어) | PARTIAL-STALE(라이브 변경 미반영) | 보조 |
| D-BENCH | `huni-dbmap/07_domain/benchmark-competitors.md`·`benchmark-evidence/` | 경쟁사 벤치마킹(RedPrinting/WowPress) | FRESH(D) | materials·cpq |
| D-ADMINMAN | `huni-admin-manual/manual/0X_*.md` (02_product-register·04_options·05_sku-templates·06_constraints·08_pricing) | 운영자 매뉴얼(라이브 admin 입력 step) | FRESH(라이브 06-10 재대조 0드리프트) | load-path·widget-contract |

---

## 금지 (v03)

| src_id | 경로 | 사유 |
|--------|------|------|
| FORBID-V03 | `raw/webadmin/tools/load_master.py:39` 입력 `data/raw/prdmaster_full_migration_v03_20260518.xlsx` | [HARD 사용자] v03=상품마스터 미분석 오류 多. **정답 참조 금지.** load_master 로직(전파기)은 oracle이나 그 입력 xlsx 값은 금지 — 정답=상품마스터 L1(B-L1-PM). round-13이 v03을 결함 진원(③ 패턴축)으로 확정 |

---

## 인벤토리 건수 요약

- tier A: 약 14 그룹(라이브 덤프·ref-csv 17종·sql 23·tools 7+ · **★신규 가격엔진 실측 2 하네스 = A-PED-* 4 + A-PQ-* 5 = 9 그룹·29 파일**)
- tier B: 약 11 L1(family) + 15 price-L1 + aux 4 + 컨펌·PDF
- tier C: 약 60 분석 산출(00·02·09·10·13·14·15·16·17·18·04·05·08·12)
- tier D: 약 15 역공학/외부
- 금지: 1(v03)

> 델타 2026-06-18(가격 축): 신규 등재 9 그룹(29 파일, 전부 tier A·FRESH) · 강등 1(A-WEBADMIN-PRICEDOC = pricing-erd·prcx01 → STALE).

## freshness 분포 (대표)

- STALE(인용 금지): `price-engine-ddl.md`(C-PRICEENG) — 대체=§0 신규 하네스+A-SQL(21·22). **★`pricing-erd.md`·`prcx01-pricing-model.md`(A-WEBADMIN-PRICEDOC) 신규 STALE 강등(8차원·clr_cd·frm_typ_cd)** — 대체=A-PED-*·A-PQ-CONTRACT+pricing.py. v03(FORBID-V03).
- ★FRESH 최상위(가격 구조·차원·엔진 거동): A-PED-SOT(사용자 7 SOT)·A-PQ-CONTRACT(evaluate_price 계약)·A-PQ-GATE(P1~P7 판정). 2026-06-18 라이브 실측.
- PARTIAL-STALE 다수: I-5(constraint_json 삭제) 참조 = `cpq-schema.md`·`schema-design-intent-map.md`·`16_*/digital-print/mapping-final.md`·`_loadspec/loadspec.md`. I-6(dep_proc_cd) = `_loadspec/loadspec.md`·`17_*/digital-print/extraction-plan.md`·`schema-design-intent-map.md`.
- FRESH: 전 17_correctness(round-13)·15_domain-spec 본문·06_extract L1·raw/webadmin/sql · **신규 가격엔진 실측 2 하네스(A-PED-*·A-PQ-*)**.
