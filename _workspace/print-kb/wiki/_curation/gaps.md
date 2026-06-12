# Curation GAPs — 원천 부재·상충·컨펌 필요 (정직 수집)

> 작성 2026-06-12 · pkw-source-curator Phase 1. 삭제 금지·상충은 출처 병기.
> 위키 집필 시 이 항목은 ✅사실로 쓰지 말 것 — 🔴미결정/🟡후보/GAP 표기.

## A. 자료 충돌 (출처 병기·잠정 판정)

| ID | 충돌 | 출처 A | 출처 B | 잠정 판정 | 비고 |
|----|------|--------|--------|-----------|------|
| CONF-1 | option_items 행수 | ref-csv/schema-relationship-analysis = **0행** | 메모리 dbmap-code-identifier-strategy = silsa **43행 COMMIT**(06-09) | **silsa 파일럿 일부 적재·나머지 미적재** | 🔴 정확 현재 행수 라이브 재확인(impact-diagnosis §3 인용 가능) |
| CONF-2 | 가격엔진 차원수 | `price-engine-ddl.md` = 6차원/8컬럼 | sql/21 + impact-diagnosis I-1 = **8차원/10컬럼** | **8차원/10컬럼(라이브 권위)** | price-engine-ddl STALE |
| CONF-3 | 코팅 = 공정 vs 자재 | 책자=공정 / 스티커·포토북·일부=자재(round-13 추가-A) | — | **family별 현재 분류 양면 표기·통일 미결(BATCH-3)** | 🔴 |
| CONF-4 | t_* 테이블 수 | CHANGELOG/메모리/cpq-schema = 34 | impact-diagnosis I-11 + 라이브 = **35** | **35** | — |
| CONF-5 | 라이브 행수 스냅샷 | ref-csv(06-04) | schema-relationship-analysis(06-06 재실측) | **06-06 재실측 최신** | schema-design-intent-map §0 |

## B. 스키마 변경 stale (round-14 I-1~I-11) — 인용 금지/주의 매핑

| 항목 | stale 산출 | 대체 권위 |
|------|-----------|-----------|
| I-1 차원/자연키 확장 | price-engine-ddl·메모리 round2 | sql/21·pricing-erd |
| I-2 단가형/합가형 | price-engine-ddl·02_mapping 가격 | sql/21·impact §3(전부 .01) |
| I-3 use_dims | price-engine-ddl·평면화 | sql/22·init_use_dims.py |
| I-4 template_prices | price-engine-ddl·cpq-schema·loadspec | sql/20 |
| I-5 constraint_json 삭제 | cpq-schema·schema-design-intent-map·16_*/digital-print/mapping-final·loadspec | sql/23·constraints.logic 단일경로 |
| I-6 dep_proc_cd 삭제 | loadspec L96·17_*/digital-print/extraction-plan L56·schema-design-intent-map | sql/23·게이팅 대체경로(미확정) |
| I-7 PK 통일 | 09_load 적재본·price-engine-ddl·round-1 | sql/18 |
| I-8 RULE_TYPE 2종 | cpq-schema·10_configurator·메모리 cpq | sql/19 |
| I-9 옵션 in 비교 | cpq-design·JSONLogic | views.py(e5ee96b)·POD data 계약 |
| I-10 usr_def/tags | 13_admin-ui-spec·loadspec | sql/16·19·information_schema |
| I-11 34→35 | cpq-schema·schema-overview·메모리 | 라이브·deploy.py |

## C. 원천 부재 GAP (해소 경로 없음/인간 결정)

| ID | GAP | 영향 | 경로 |
|----|-----|------|------|
| GAP-G1 | 합가형(prc_typ_cd=02) 상품 식별(라이브 전부 .01) | price-engine | 미래 작업·BATCH 미포함 |
| GAP-G2 | CPQ 옵션 레이어 전면 미적재(silsa 외·6+ family) | cpq-options | BATCH-6 |
| GAP-G3 | 카테고리 고아 113상품 재연결 미적재 | 9 family | BATCH-1(인간) |
| GAP-G4 | 색·부속(끈/링/형상/용량) 자재 오염 분리 | 8 family | BATCH-2 |
| GAP-G5 | 레더 .08/.01→.06 일괄 교정(MAT_000186 6상품) | 4 family | BATCH-4 |
| GAP-G6 | dep_proc_cd 삭제 후 자재→공정 게이팅 대체경로 | materials·processes | I-6·미확정 |
| GAP-G7 | 포토북/디자인캘린더/문구/부자재 가격 미적재(prices 0행) | 4 family | BATCH-7 |
| GAP-G8 | 봉투/케이스 세트 모델(addon vs sets) | 3 family | BATCH-5·Q-ID-A |
| GAP-G9 | 신규 공정 신설(미싱제본·보드마운팅·삼각대거치·봉제) | 5 family | BATCH-13 |
| GAP-G10 | 정체 미확정 상품(★·입체·외주미정) | 2 family | BATCH-14 |
| GAP-G11 | S1-TACIT 지니 암묵지·S1-OEM 외주사 규칙 미수집 | 정책·예외 | D 인터뷰(기존 registry) |
| GAP-G12 | 후니 DB 미정 → 위젯 어댑터 교체시점 | widget | 정규화 계약 의존으로 회피 |
| GAP-G13 | 장바구니/주문 = Shopby 제외·백엔드 미정 | widget·order | 정규화 계약 경계 |

## D. 🔴 컨펌 필요 (BATCH-1~14 매핑 — 인간/실무진 결정)

권위: `17_correctness/_crosscut/batch-confirmations.md`. 위키는 결정 전까지 🔴 표기.

| BATCH | 요지 | 영향 family |
|-------|------|:--:|
| BATCH-1 | 카테고리 113상품 재연결 + 빈 임시분류함 숨김 | 9 |
| BATCH-2 | 색·부속을 자재에서 옵션/공정으로 분리 | 8 |
| BATCH-3 | 코팅=공정 통일 | 4 |
| BATCH-4 | 레더=가죽(.06) 분류 정정 | 4 |
| BATCH-5 | 봉투/케이스 세트 모델 | 3 |
| BATCH-6 | CPQ 옵션 일괄 적재 | 6+ |
| BATCH-7 | 가격 적재(0원 상품군) | 4 |
| BATCH-8 | 묶음수/page 잡음 정리 | 3 |
| BATCH-9 | 종이 용도(usage) 내지/표지 분리 | 4 |
| BATCH-10 | 출력용지·생산메타 위치(견적 안/밖) | 5 |
| BATCH-11 | MES 코드 채움 | 5 |
| BATCH-12 | v03 상류 수정 vs DB 직접 교정 | 10 |
| BATCH-13 | 신규 공정/자재 신설 | 5 |
| BATCH-14 | 정체 미확정 상품 처리 | 2 |

### 🔴 round-13 미결 핵심 3 (CLAUDE.md 명시)
- BATCH-3 코팅 CONFLICT(공정 vs 자재)
- BATCH-12 v03 상류 vs DB 직접
- BATCH-6 size↔option(굿즈파우치 재분류 등)

## E. v03 금지 재확인 [HARD]

- `load_master.py:39` 입력 `prdmaster_full_migration_v03_20260518.xlsx` = **정답 참조 금지**.
- 정답 = 상품마스터 L1(`06_extract/<slug>-l1.csv`) > webadmin 적재 oracle(로직).
- round-13이 v03을 결함 진원(패턴축③·10 family 전반)으로 확정.
