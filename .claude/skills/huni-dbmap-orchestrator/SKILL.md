---
name: huni-dbmap-orchestrator
description: 후니프린팅 DB 데이터 매핑 하네스 오케스트레이터. Railway railway DB(PostgreSQL 18.4, **44테이블 — t_* 도메인 34 + Django 10, CPQ 컨피규레이터 옵션/템플릿/제약 레이어 라이브 구현 포함**) 구조를 읽기전용으로 시트화하고, 상품마스터·인쇄상품 가격표 엑셀 데이터를 DB 테이블에 매핑(매핑 설계서 + 적재용 CSV)하되 DB 직접 적재는 보류한다. 7인 에이전트 팀(dbm-schema-analyst / dbm-excel-analyst / dbm-mapping-designer / dbm-validator / dbm-load-builder / dbm-ddl-proposer / dbm-option-mapper)으로 구조분석·엑셀분석 병렬 → 매핑 설계 → 경계면 교차검증 파이프라인을 수행한다. round-1(완료): 수량구간별 할인(t_dsc_*, 아크릴/굿즈·파우치/문구) — dbm-mapping 스킬. round-2(진행): 가격 공식 엔진(t_prc_* 4단 구조) — dbm-price-formula 스킬, fit-gap 선행 후 점진 파일럿(디지털인쇄/엽서). round-4(적재 준비): 상품마스터·가격표의 검증된 매핑을 t_* 적재본(FK 위상정렬·코드행 선적재 제안·적재 매니페스트)으로 조립하고 G1~G9 완료 게이트 + 트랜잭션 롤백 DRY-RUN으로 적재 가능성을 증명 — dbm-load-readiness 스킬, t_* 화이트리스트 강제, 실제 INSERT는 인간 승인(권위 docs/goal-2026-06-06-01.md). round-5(적재 실행본): round-4 GO 적재본을 멱등 INSERT … ON CONFLICT UPSERT + 단일 트랜잭션 + FK순 적재 SQL/로더로 실행본화하고, GAP/차단을 라이브 t_* 정합 신규 엔티티 DDL 제안서로 닫으며, 롤백전용 라이브 DRY-RUN으로 멱등성·적재가능성을 R1~R6 게이트로 증명 — dbm-load-execution 스킬, DDL 직접적용·COMMIT 금지(인간 승인), 권위 docs/goal-2026-06-06-02.md. round-6(CPQ 옵션 레이어 매핑): 상품마스터·가격표의 옵션성 속성을 라이브 CPQ 옵션 레이어(t_prd_product_option_groups/options/option_items·templates·constraints)에 매핑 — 이미 적재된 차원행을 polymorphic ref_dim_cd(OPT_REF_DIM 7종)로 참조해 option layer 재구성, 속성→엔티티(차원/CPQ옵션/가격/제약) 마스터 지도 + 상품군 파일럿, WowPress 흡수원칙+RedPrinting 캐스케이드 6종+JSONLogic constraints, 검증 트리거 fn_chk_opt_item_ref 무결성 준수 — dbm-cpq-option-mapping 스킬·dbm-option-mapper 설계가, DB 미적재(인간 승인). 'DB 매핑', 'DB 구조 파악', '테이블 시트화', '엑셀 데이터 매핑', '구간할인 매핑', '수량구간 할인', '가격표 매핑', '상품마스터 매핑', 'Railway DB', '적재 CSV 생성', '매핑 검증', 'DB매핑 하네스 실행', '하네스 재실행', '매핑 업데이트', '특정 테이블만 매핑', '추가 매핑', '가격 매핑', '가격공식 매핑', 'round-2', 't_prc 매핑', '단가표 매핑', '계산공식 매핑', '가격 스키마 적정성', '가격엔진 fit-gap', '가격 fit-gap만', '가격 매핑 다시', 'DB 매핑 검증', '상품 매핑 정합', '적재 검증', '9속성 검증', '엑셀 DB 대조', '매핑 감사', '정합 재검증', '기초데이터 검증', '상품마스터 검증', '사이즈/자재/공정/판형/묶음수/페이지룰/추가상품 검증', '특정 속성만 검증', '검증 다시', 'CPQ 검증', '컨피규레이터 스키마', 'CPQ 정합', '라이브 스키마 재확인', '옵션/템플릿/제약 스키마', '스키마 재문서화', '하네스 강화', '적재 준비', 'round-4', '적재본 빌드', '적재 조립', 'FK 위상정렬', '적재 순서 확정', '코드행 선적재', '적재 매니페스트', 'DRY-RUN', '적재 가능성 검증', 'G1 G9 게이트', '완료 게이트', 't_* 화이트리스트', '적재 게이트 다시', '상품마스터 적재 조립', '가격표 적재 조립', '적재 스크립트', '적재 스크립트 작성', '적재 SQL', 'SQL 쿼리 작성', '멱등 적재', 'UPSERT', 'ON CONFLICT', '트랜잭션 래핑', '적재 로더', '신규 엔티티 제안', 'DDL 제안', '스키마 부족분 제안', 'GAP 엔티티', '라이브 DRY-RUN', 'round-5', '적재 실행본', '적재 실행 게이트', 'R1 R6 게이트', '멱등성 검증', '적재 스크립트 다시', 'DDL 제안 다시', 'CPQ 옵션 매핑', '옵션 레이어 매핑', '속성 엔티티 매핑 지도', 'option_groups 설계', 'polymorphic ref_dim_cd 매핑', '옵션 캐스케이드 매핑', '상품군 옵션 파일럿', 'CPQ 옵션 검증', 'round-6', 'CPQ 옵션 매핑 다시', '입체 커버리지', '커버리지 매트릭스', '전 상품군 조망', '전체 시트 매핑 검증', '상품마스터 전수 검증', '미적재 조망', '필요요소 도출', '엔티티 관계 무결성', '3원 대조', 'round-7', '커버리지 검증 다시', '변경 추적', '버전 diff', '버전 비교', '변경분 적용', '신규 버전 적용', '상품마스터 업데이트', '가격표 업데이트', '변경 매니페스트', '델타 적재', '델타 적용', '엑셀 변경 추적', 'round-10', '변경 추적 다시', '컬럼 의미 분석', '컬럼 도메인 사전', '시트 컬럼 의미', '상품 구성요소 리서치', '상품 자재 공정 도출', '상품 BOM', '인쇄 도메인 리서치', '적재명세 추출', 'webadmin 적재명세', 'round-11', '도메인 분석 다시', '매핑 확정', '매핑 확정 리서치', '정확한 매핑데이터', '컬럼 기초데이터 매핑', '11시트 매핑 확정', '경쟁사 리서치 매핑', 'CIP4', '인쇄표준 리서치', '갭헌팅', '놓친 정보 리서치', 'round-12', '매핑 리서치 다시', '매핑 확정 업데이트', '특정 시트 매핑 확정만', '가격공식 정리 검증', '가격공식 정리 확인', '공식명 비고 정리', '실무진 가격공식 정리표', '가격공식 가독성', '가격공식 사용가능성', '가격뷰어 확인', '가격공식 배선 검증', '가격관리 가격공식 점검', 'round-17', '가격공식 검증 다시', '가격공식 개선안', '가격엔진 실증', '가격계산 검증', '가격공식 매핑 실증', '가격사슬 완전성', '재계산 검증', '단가형 합가형 계산', '수량구간 할인 계산', '가격뷰어 정합', '아크릴 가격 검증', '문구 가격 검증', '굿즈 파우치 가격 검증', 'round-18', '가격엔진 검증 다시', '실증검토', '경쟁사 가격 벤치마크', '와우프레스 가격 대조', '레드프린팅 가격 대조', '가격차이 검증', '터무니없는 가격차', '가격 합리성 검증', '가격공식 클래스 분류', '상품군 전체 가격 검증', '가격 정합 정립', '미진 요건 정립', '돈 크리티컬 검토', '가격 결함 원인 규명', 'round-18 확장', '종단 파이프라인', '상품군 종단 완주', '견적가능 검증', '견적가능 판정', '컬럼 readiness', 'readiness 매트릭스', 'RTM', '진척판', 'round-19', '한 상품군 끝까지', '6축 적재', '6축 교정', '기초데이터 단계 적재', '기초코드 사이즈 도수 자재 공정 카테고리', '축별 매핑 교정', '상품마스터 단계별 적재', '매핑 오류 교정', '라이브 6축 재실측', '축 우선 종단', 'round-22', '특정 축만 교정', '자재 오염 교정', '카테고리 재연결', 'P-TRUNCATE 가드' 요청 시 반드시 사용. 단순 질문은 직접 응답.
---

# huni-dbmap Orchestrator

[HARD] All deliverable documents (.md sheets, specs, reports) under `_workspace/huni-dbmap/` MUST be written in KOREAN (project documentation language per language.yaml). Identifiers, table/column names, code values, CSV headers, and SQL stay in English. Instruct every spawned agent accordingly.

Coordinates a 4-agent team to (1) sheet the live Railway DB structure and (2) map후니프린팅 Excel data to DB tables — producing a mapping spec + load-ready CSV, WITHOUT writing to the live DB. Sheet-first; loading is a later, separately-authorized step.

## Goal & scope

- **Sheet the DB**: extract the `railway` DB's 29-table structure to review-grade Markdown + CSV.
- **Map the data**: design Excel→DB column mappings, transforms, and load-order; emit per-table load CSV.
- **Do NOT load** into the live DB (user decision). Validation uses local constraint checks or rollback-only dry-runs.

## Rounds

| Round | Domain | Tables | Skill | Status |
|-------|--------|--------|-------|--------|
| round-1 | quantity-bracket discount | `t_dsc_*`, `t_prd_product_discount_tables` | `dbm-mapping` | DONE (validated GO) |
| round-2 | price formula engine | `t_prc_*` (6 tables), `t_prd_product_price_formulas`, `t_prd_product_prices` | `dbm-price-formula` | IN PROGRESS |
| round-3 | mapping audit (DB↔Excel 정합 검증) | `t_prd_*` 9속성 테이블 + 마스터(`t_siz_/t_mat_/t_proc_/t_cod_`) | `dbm-mapping-audit` | ACTIVE |
| round-4 | load-readiness (적재본 조립 + G1~G9 게이트 + DRY-RUN) | 상품마스터 `t_prd_*` + 가격 `t_prc_*` (whitelist) | `dbm-load-readiness` | DONE (양 트랙 GO) |
| round-5 | load-execution (멱등 SQL/로더 + 신규 엔티티 DDL 제안 + 라이브 DRY-RUN, R1~R6) | round-4 GO 적재본 `t_prd_*` + `t_prc_*` + `11_ddl_proposals` | `dbm-load-execution` | READY |
| round-6 | **CPQ 옵션 레이어(L2) 매핑** (속성→엔티티 마스터 지도 + 상품군 파일럿) | `t_prd_product_option_groups/options/option_items` · `templates/template_selections` · `constraints` | `dbm-cpq-option-mapping` | ACTIVE |
| round-7 | **입체 커버리지 검증** (상품마스터 전 상품군 × 라이브 t_* 엔티티 매트릭스 조망) | 전 `t_prd_*`/`t_prc_*`/CPQ 엔티티 (조망·검증 전용, 적재 아님) | `dbm-coverage-matrix` | DONE (GO) |
| round-8/9 | admin UI 입력 명세 / CPQ 옵션 레이어 실 적재 (이력은 CLAUDE.md §7) | `13_admin-ui-spec` / silsa CPQ 43행 | — / `dbm-cpq-option-mapping` | DONE |
| round-10 | **버전 변경 추적 + 델타 적용** (상품마스터·가격표 신규 버전의 변경분만 추적·적용) | 변경 영향 `t_prd_*`/`t_prc_*`/CPQ (델타 UPSERT) | `dbm-change-tracking` | ACTIVE |
| round-11 | **컬럼 도메인 의미 + 상품 BOM + 적재명세** (상품마스터 각 시트 컬럼의 인쇄 도메인 의미 확정 + 상품별 자재/공정 + raw/webadmin 적재명세 → 매핑 정보) | 상품마스터 전 시트 → 전 `t_*` (의미·BOM·적재명세 정리, 적재 아님) | `dbm-column-domain` · `dbm-loadspec-extract` | ACTIVE |
| round-12 | **매핑 확정 리서치** (4개 내부 권위{round-11 산출·실무진 확정 Q1~Q15·schema-design-intent-map·loadspec} 결합 + 국내10·해외10 경쟁사/CIP4/ISO 표준 갭헌팅 + 라이브 실측 → 시트별 컬럼→기초데이터 확정 매핑) | 상품마스터 11시트 → `16_mapping-research/<family>/mapping-final.md` (M1~M6 게이트, 적재 아님) | `dbm-mapping-research` | ACTIVE |
| round-13 | **라이브 정합 교정** (라이브=교정대상 역전 — webadmin 적재 oracle{`sql/`·`tools/load_master.py`·`docs/`ERD}+스키마의도+엑셀+도메인을 정답으로, 상품별 추출규칙 도출 + 라이브 전수 diff → 교정 매니페스트) | 상품마스터 11시트 → `17_correctness/<family>/`{loadlogic-notes·extraction-plan·live-diff·correction-manifest} (K1~K6 게이트, 적재 아님) | `dbm-correctness-audit` | ACTIVE |
| round-14 | **webadmin 스키마 변경 추적** (라이브 DB 소스 오브 트루스 webadmin이 진화할 때 — 베이스라인↔HEAD git diff로 스키마 구조 변경이력 + 3-way 정합{git 선언/라이브 적용/우리 산출 참조} + DDL·백필 레벨 분리 → 우리 산출 stale 영향/갱신) | webadmin `sql/`·`tools/` → `18_schema-change/<pair>/`{schema-change-log·live-apply-crosscheck·impact-matrix·update-manifest} (W1~W6 게이트, 수정 아님) | `dbm-schema-change-tracking` | ACTIVE |
| round-16 | **가격표 → Phase11 가격엔진 그릇 import 준비** (인쇄상품 가격표 다차원 매트릭스·복합셀을 webadmin Phase11 가격엔진 `evaluate_price`이 먹는 `t_prc_*` 4테이블 그릇으로 분해 + webadmin 복붙용 작업 엑셀 + DB 매핑 절차 mermaid) | 가격표 16시트 → `20_price-import/<sheet>/`{structure·decomposition·import.xlsx·mapping-flow} (P1~P6 게이트, 적재 아님) | `dbm-price-import-prep` | ACTIVE |
| round-17 | **가격공식 정리 검증** (라이브 webadmin 가격관리>가격공식 `t_prc_price_formulas`가 제대로 정리됐는지 — 라이브 DB↔webadmin 소스(`price_views.py`·가격허브/뷰어 mockup)↔admin 화면 3중 대조로 4축{정리 상태·실무진 가독성·`formula_components` 배선 사용가능성·`price_viewer` 노출} 판정 + 실무진 정리표 + 결함 보드 + 공식명/비고 개선안. frm_typ_cd 라이브 실재 결판) | 라이브 가격공식 → `21_price-formula-audit/`{formula-inventory·formula-table·defect-board·improvement-proposal} (F1~F5 게이트, 적재 아님) | `dbm-price-formula-audit` | ACTIVE |
| round-18 | **가격엔진 실증검토** (적재된 가격 데이터가 명세대로 *실제로 올바른 가격을 계산하는지* 상품군별 실증 — 라이브 `evaluate_price` 미구현[가격뷰어 ⑤ "다음 단계 완성 후 활성화"·`pricing.py` 부재·ROADMAP Phase 11 미완·gstack 실증] 확인 후 ① 가격사슬 완전성 라이브 실측[소스 바인딩·공식→`formula_components` 배선→`price_components`→`component_prices` 단가행·`t_dsc` 수량구간 할인 연결·등급] ② Phase11 명세[11-CONTEXT/prcx01] 기반 검증용 재계산기 재구현[단가형/합가형·NULL 와일드카드·동시매칭 오류·수량구간·시계열·할인 순차곱·우선순위] ③ 가격표 엑셀 known값↔가격뷰어 수치 대조 ④ 가격뷰어 정합. 호출할 엔진 없음→검증용 재계산이 핵심) | 아크릴·문구·굿즈/파우치 → `26_price-engine-verify/<family>/`{chain-completeness·recompute.py·recompute-cases·expected-vs-computed·defects} (PE1~PE6 게이트, 적재 아님·읽기전용) | `dbm-price-engine-verify` | ACTIVE |
| round-18+ | **가격엔진 실증 확장 — 클래스 전수 + 경쟁사 벤치마크 + 정합 정립**(round-18 3축 확장) — ① **15 가격공식 클래스 전수**(공식별 동일 적용 상품군: PRF_POSTER_FIXED 28·PRF_DGP_A 9·PRF_BIND_SUM 4 등·직접단가0·184상품 가격미구성) 클래스별 재계산 ② **경쟁사 합리성 벤치마크**(와우프레스 공개 API·레드프린팅 본인계정/캡처와 같은 옵션 대조 — **"터무니없는 가격차=우리측 결함 신호"** 사용자 directive·경쟁사=오라클) ③ **돈-크리티컬 정합 정립 심의**(가격↔상품요소 매핑 권위 엑셀 대조·미진 요건 정립 방안 deliberation). 권위=가격표/상품마스터 엑셀 | 15 클래스 → `27_competitor-benchmark/<class>/`·`28_price-arbitration/<class>/` (PE+B+A 게이트, 적재 아님·읽기전용) | `dbm-competitor-benchmark`·`dbm-price-arbiter` | ACTIVE |
| round-19 | **상품군 종단 견적가능 완주** (한 상품군을 컬럼 readiness→미적재 식별→적재 라우팅→견적가능 판정까지 종단으로 민다 — 기존 레이어 라운드를 호출 순서로 엮는 메타 파이프라인. 견적가능=①UI 옵션선택+②선택의 차원환원 생산정보[MES_ITEM_CD 아님]+③가격계산 셋 다) | `29_readiness/<family>/`{column-readiness·quote-gate}·`_rtm.md` (Q1~Q6 게이트, 적재 아님·점검/판정/조율) | `dbm-product-readiness` | ACTIVE |
| round-20 | **동형 클래스 배치 적재** (270 상품을 한 건씩이 아니라 **동형 클래스**[동일 옵션구성×동일 가격계산방식] 단위로 결정적 스크립트 배치 적재 — 상태 분류[ready/pending/unlisted]·선결 게이트[컬럼 완정성]·멱등 NOT EXISTS NULL-safe UPSERT·apply_ymd 고정·SQL 집계 전수 검증·**백업은 위험변경만+git baseline CSV**[매 적재 백업=과한 프로세스 폐기]. 한 건당 173K 토큰 비효율 제거·컨텍스트 최소화) | `scripts/`(classify·gen_batch_upsert·verify_batch·apply_batch) → `09_load/_batch_<class>/`·`3X_batch/classification` (집계 게이트, DRY-RUN+집계까지·COMMIT은 GO 후 인간 승인) | `dbm-batch-load` | ACTIVE |
| round-21 | **상품군 동형 효율 파이프라인 + 자율 자기개선** (round-18 클래스·19 종단·20 배치를 "상품군 동형" 한 축으로 수렴. 토대 모델[출력소재·판걸이수·가격표 2분류·계산공식집초안 동형성·적재 산출 기준 §9] 위에서 **Sc 동형분류**[계산공식집초안×옵션, 50개 미만, 미출시 제외] + **대표**[시트 실측 superset·상품군마다 다름] 선정 → 대표 **5레이어 완전종단**[구성요소·옵션·템플릿·제약·가격, 주문가능 형태 실적재] → **Sp 동형 자동전파**[batch-load]. **이진 게이트로 자율 검증·보정 폐루프**[가격 골든값 대조·견적가능 Q1~Q6·멱등/제약위반0·webadmin 가시성], 사람 개입은 인간 승인 큐[실 COMMIT·도메인 컨펌·권위 부재]만) | 전 상품군 50개 미만 → `29_readiness/<family>/` + `09_load/_batch_<class>/`, 토대 = `dbm-batch-load/references/product-group-isomorphism-model.md` | `dbm-readiness-auditor` + `dbm-batch-load` | ACTIVE |
| round-22 | **6축 기초데이터 staged 교정·적재** (상품마스터를 webadmin load_master의 실제 적재 단위인 6축[① 기초코드 → ② 사이즈 → ③ 도수 → ④ 자재 → ⑤ 공정 → ⑥ 카테고리]으로 횡단 재조망 → 이미 적재됐으나 매핑 오류[자재축 색/형상/사이즈 오염·도수↔별색·카테고리 고아 113상품]를 인쇄도메인+경쟁사 정답 규칙으로 단계별 교정. **2 절대 전제**[① P-TRUNCATE 재실행 가드 — load_master 6축 전부 TRUNCATE CASCADE 후 무변환 재적재→가드 없으면 교정 무효 ② 착수 전 6축 라이브 전수 재실측 — 부분 진화로 진단 stale]. **v2 경로 판정**: 6축 오류 진원 전부 ⓐ(입력 v03)·load_master=무변환 전파기 → 교정=**교정 입력 엑셀 재적재(경로 Y·근본·P-TRUNCATE 안전)** > 라이브 직접 SQL(경로 X·임시 소멸). webadmin 코드 수정 금지. 권위=상품마스터/가격표·v03 배제. X1~X6 게이트) | 상품마스터 6축 → `32_axis-staged-load/`{01 정답규칙·02 오류진단·03 경로판정·04 재실측·_corrected_xlsx·_verify·_gate·_backlog} (X1~X6, 교정 엑셀+검증까지·실 재적재=개발자 협업·인간 승인) | `dbm-axis-staged-load` (재사용: domain-researcher·correctness-auditor·loadspec-extractor·load-builder·ddl-proposer·validator·option-mapper) | ACTIVE |

- **round-1**: quantity-bracket discounts for 아크릴 / 굿즈·파우치 / 문구. Flat bracket rows. Complete.
- **round-2**: the price is a *formula engine* (`판매가 = Σ components`, each component priced by a multi-dimensional lookup) — not a flat table. Excel authority: 상품마스터 `계산공식집초안` (formula intent, typed by 공식 유형) + 가격표 19 단가시트 (component matrices). **fit-gap FIRST** (is `t_prc_*` adequate? — round-1 did not extract the `t_prc_*` DDL), then **incremental pilot** (디지털인쇄/엽서, 원자합산형) before widening to all 공식 유형. See `dbm-price-formula`.
- **round-3 (audit)**: verify the *already-loaded* `t_prd_*` data against the Excel source, per product × 9 attributes {사이즈·자재·인쇄옵션·공정·공정택일그룹·판형사이즈·묶음수·페이지룰·추가상품}. **프레임: "DB 정규화 규칙=기준"**(엑셀=담을 내용; "엑셀=권위 단순대조"는 false MISSING으로 폐기). **L1↔L2 2계층**: L1 충실추출(전 컬럼·8 정보축·숨김/미출시/내부용 보존, 누락0 기계보증) → L2 정합검증(기대행 대비, 숨김/미출시=비활성). **기초데이터순** (마스터 정합 → 상품별 연결, FK 의존순). Classify MATCH / MISSING / EXTRA / MISMATCH. 검증이지 매핑설계·적재 아님. See `dbm-mapping-audit` + `dbm-excel-parse`(L1).
- **round-4 (load-readiness)**: take the *validated* mappings from round-2/3 and prove they are **loadable** into live `t_*` — distinct from *correct*. `dbm-load-builder` composes the FK-topo-sorted load bundle (`09_load/`: manifest + ordered load CSV + code-row pre-load proposals + blocked/GAP list, **`t_*` whitelist enforced**); `dbm-validator` runs the **G1–G9 completion gate** + rollback-only DRY-RUN and emits GO/NO-GO. Build (builder) and gate (validator) are separate agents — that separation IS gate G9. **No DB writes, no DDL; real INSERT = human approval.** Authority: `docs/goal-2026-06-06-01.md`. See `dbm-load-readiness`.
- **round-5 (load-execution)**: take the *round-4 GO bundle* and make it **executable + re-runnable** — distinct from *loadable*. `dbm-load-builder` turns the bundle into idempotent `INSERT … ON CONFLICT` SQL wrapped in one transaction + a loader (`09_load/_exec*/`); `dbm-ddl-proposer` closes round-4's GAP/BLOCKED items with **minimal `t_*`-consistent new-entity DDL proposals** (`11_ddl_proposals/`, search-before-mint); `dbm-validator` runs the **R1–R6 gate** (멱등성·트랜잭션 원자성·실행가능성·DDL 제안 정합·라이브 DRY-RUN·독립성) on top of carried-forward G1–G9, and emits GO/NO-GO. **No `COMMIT`, no DDL apply; both are human approval.** Authority: `docs/goal-2026-06-06-02.md` (inherits goal-...-01). See `dbm-load-execution`.
- **round-6 (CPQ option-layer mapping)**: map the 옵션성 attributes of 상품마스터/가격표 onto the live CPQ option layer — distinct in kind from L1 (rounds 1–5). **L2 does not load new data; it references already-loaded dimension rows.** `t_prd_product_option_groups`(sel_typ 택1/택N) → `options` → `option_items`(polymorphic `ref_dim_cd` → dimension row, enforced by live trigger `fn_chk_opt_item_ref`) + `constraints`(JSONLogic) + `templates`(=SKU add-on). The unit is: (A) an **attribute→entity master map** (every 옵션성 attribute across 13 sheets → dimension/CPQ-option/price/constraint) + (B) a **per-상품군 pilot** (full option-layer chain, load-ready). Method fuses **WowPress 흡수원칙**(형상→규격·본체색→재질 합성, 과분할 금지) + **RedPrinting 캐스케이드 6종**(material→pcs disable·dosu↔bnc·essential/hidden → JSONLogic). The live GAPs (`ref_param_json` 공정 파라미터, hidden-essential, 포장옵션, 비치수 size) route to `dbm-ddl-proposer` — flagged, never fabricated. `dbm-option-mapper` designs, `dbm-validator` cross-checks (trigger-reference resolution = the load-bearing L2 check). **No DB writes; real INSERT + code-row + DDL = human approval.** See `dbm-cpq-option-mapping`.
- **round-7 (입체 커버리지 검증)**: rounds 1–6 went **시트별 종단(깊이)** — round-7 goes **전 상품군 횡단(너비)**. Build the **one matrix**: 상품마스터 11 상품군(rows) × 라이브 t_* 엔티티(columns), each cell = need(엑셀 권위)/state(라이브 실측 LOADED·PARTIAL·MISSING·N/A)/agreement(대표상품 엑셀↔DB↔admin 3원 대조). Surfaces what is missing *across all families at once* (a single-sheet deep-dive structurally cannot). `dbm-coverage-auditor` builds the matrix + gap-board + relationship-integrity; `evaluator-active` (fresh context) gates C1~C8 — that separation IS C7. admin product-viewer (gstack browse) = 대표상품+의심분 집중 (전수 아님). **검증/조망 전용 — DB 적재(COMMIT) 없음, 미적재 실적재는 인간 승인.** Authority: `docs/goal-2026-06-08-01.md`. See `dbm-coverage-matrix`.
- **round-10 (버전 변경 추적 + 델타 적용)**: rounds 1–7 mapped/loaded a **single snapshot** of the Excel — round-10 tracks the **difference between two versions** (baseline → new, e.g. 상품마스터 260527→260610) and applies only the delta. The load-bearing insight is **3-way**: the delta to apply is NOT (new − baseline) — the **live DB is the state authority**, baseline = operator *intent*, live = *reality* (may differ from a naive baseline mapping). `dbm-change-tracker` does key-based(`prd_cd`/`prd_nm`) cell-level 3-way diff → ADDED/REMOVED/MODIFIED/UNCHANGED, impact-maps each changed cell to t_* entity/column (reusing 9속성·가격·CPQ lenses), reconciles new↔live, and emits ① a row-level **change manifest** (사람이 읽는 추적 감사본) + ② an **idempotent delta UPSERT** (`ON CONFLICT … DO UPDATE …, upd_dt`, reusing `dbm-load-execution` SQL patterns); `dbm-validator` gates V1~V8 + rollback-only DRY-RUN. **REMOVED = 논리삭제 제안·escalate (절대 hard-delete 금지)**; 신규 코드값 = 선적재 제안. **No COMMIT, no DDL apply, no DELETE — all human approval.** See `dbm-change-tracking`.
- **round-11 (컬럼 도메인 의미 + 상품 BOM + 적재명세)**: rounds 1–10 mapped/loaded/tracked the data, but the round-9 lesson (기계적 매핑 금지·스키마 설계의도 선행) requires the **excel-side half to be settled first**: what each column *means* and what each product is *made of*. `dbm-domain-researcher` produces ① a **column dictionary** (각 시트 각 컬럼의 인쇄 도메인 의미, 애매모호 0 — authority ① 후니 PDF ② 07_domain KB ③ 국내외 표준 보조) + ② a **product BOM** (각 상품명 리서치 → 자재+공정 전체). `dbm-loadspec-extractor` extracts from raw/webadmin source ③ a **load-spec** (각 t_* 가 무엇을 어떻게 적재하는가 — `BaseAdmin` 제너릭·`BASE_CODE_GROUP` 코드값·상품뷰어 적재경로, file:line). The three combine into **매핑 정보** that feeds the still-unwritten `schema-design-intent-map.md` + downstream L1/L2 mapping. Reuses 07_domain 의미축 (재유도 금지); 1 product-family pilot (디지털인쇄) sets the depth bar, then widen. **분석/정리 전용 — DB 적재 없음.** See `dbm-column-domain` + `dbm-loadspec-extract`.
- **round-12 (매핑 확정 리서치)**: round-11 settled what each column *means*; round-12 turns that into the **per-sheet definitive mapping** (`mapping-final`: 컬럼 → live `t_*.column` + 변환 규칙 + 코드값/FK + 라이브 실측 상태). Procedure = combine the four internal authorities (round-11 sheet artifacts · 실무진 확정 `_review/실무진-검토질문.md` Q1~Q15 — ★5건 overrides round-11 drafts · `00_schema/schema-design-intent-map.md` OM-1~7 · `_loadspec/loadspec.md`) → **gap-hunt externally** (국내 10·해외 10 경쟁사, CIP4 JDF/XJDF, ISO 인쇄표준, 인쇄용어 — 갭 발견용 보조, 답습 금지, 기존 KB 재사용) → verify every mapping right-hand side against the live DB read-only → `dbm-validator` gates **M1~M6** (커버리지·권위 인용 실재·실무진 정합·오모델 재발 0·라이브 실측·갭 처분). Output feeds round-4/5 load assembly directly. **분석/확정 전용 — DB 적재 없음(인간 승인).** Per the round-10/11 lesson, prefer inline Korean execution or parallel `dbm-domain-researcher` fan-out with main-session QA. See `dbm-mapping-research`.

- **round-13 (라이브 정합 교정)**: rounds 1–12 mapped/confirmed against the live DB as authority. round-13 **reverses** that — the live DB is the **defendant**, and the **webadmin load oracle** (the code that actually loaded it) + schema intent + Excel + settled domain are the **judge**. The user's concern: 라이브 DB was loaded by `raw/webadmin` (HuniProductPrice2) without its load logic / schema fully analyzed, so 교정 필요분 many (round-12 already saw 레더 3-way·코팅 family 불일치). The load-bearing check = **reconstruct how `tools/load_master.py` (+`sql/`) transformed each Excel column into `t_*`, then judge that transform against Excel intent + schema intent + domain** — correct→keep, wrong→correct. **[HARD] `catalog/models.py` is `# auto-generated` (inspectdb·`managed=False`) — a DB mirror, NOT load logic; the oracle is `sql/`+`tools/`.** `dbm-correctness-auditor` produces per-product extraction-plan + live-diff + correction-manifest (loadlogic-notes for the reconstructed load rules); `dbm-validator` gates **K1~K6** (추출규칙 커버리지·oracle 인용 실재·적재로직 근거·라이브 실측 독립 재현·비파괴 search-before-mint·오모델 정합). Output = 비파괴 교정 제안 (COMMIT/DDL/DELETE = 인간 승인); GO corrections feed round-5 / round-10 delta tracks. **분석/교정제안 전용 — DB 적재·수정 없음.** Per the round-10/11 lesson, prefer inline Korean execution or `dbm-correctness-auditor` fan-out with main-session QA. See `dbm-correctness-audit`.

- **round-14 (webadmin 스키마 변경 추적)**: rounds 1–13 treated the live DB schema as a fixed target. round-14 tracks what happens when **`raw/webadmin` (the schema+load source-of-truth) itself evolves** — it is a living project (Phase 10/11 redesigned the price engine + CPQ constraints: `constraint_json` dropped, `use_dims`/`template_prices` added). The load-bearing insight is **3-way**: the truth needs (1) **선언 (webadmin git)** — `sql/` DDL + `tools/` load logic diff baseline↔HEAD; (2) **적용 (라이브 information_schema)** — did the declaration reach the live DB, AND **separate DDL-level (column exists) from data-backfill-level (rows filled)** — "컬럼 존재 ≠ 적용 완료" (Phase 11: `proc_cd`/`opt_cd` columns added but 0 rows); (3) **참조 (우리 dbmap 산출)** — which of round-2/6/11/12/13 still references a dropped/changed schema = stale. The three axes diverging IS the finding. **[HARD] baseline = the webadmin commit our artifacts analyzed** (cross-verify by the sql files/columns they cite). `dbm-change-tracker` (round-14 mode) classifies schema changes + impact-maps to our artifacts (CRITICAL/MAJOR/MINOR severity) + emits update-manifest; `dbm-validator` gates **W1~W6**. **추적·영향·갱신 제안 전용 — webadmin/DB/우리 산출 직접 수정 없음.** First run's diagnosis = `18_schema-change/impact-diagnosis.md` (baseline `d6026be` ↔ HEAD `bd12d03`, round-2/6/11/12/13 all MAJOR, 0 CRITICAL — 적재값 무손상·문서만 stale). See `dbm-schema-change-tracking`.

- **round-16 (가격표 → Phase11 가격엔진 그릇 import 준비)**: rounds 2/4/5 mapped/assembled the price as DB CSV against the round-2 snapshot schema. round-16 re-frames it: the **grail is what webadmin's Phase11 price engine (`evaluate_price`, `raw/webadmin/.planning/phases/11-price-engine-simulator/`) eats**, and the deliverable is a **webadmin copy-paste 작업 엑셀(.xlsx)** + **DB 매핑 절차 mermaid**, not a load CSV. The user's concern (공식 이해 없이 매핑 = 복잡성 증가) is precise: the **decomposition criterion IS the engine's matching rule** — ① 단가형/합가형(`prc_typ_cd`: 장당가×수량 vs 구간총액÷min_qty 환산) ② which of the **10 dimensions** (`component_prices` natural key, `proc_cd`/`opt_cd` newly added) via `use_dims` ③ NULL=와일드카드 ④ 동시매칭=데이터 오류. round-2 산출은 round-14 진단대로 **stale**(8→10차원·단가/합가 부재·`template_prices` 누락) → 최신 그릇을 먼저 확정해야 엔진이 먹는 형태가 된다. The 4-table grail = `t_prc_price_formulas`(상품↔공식·frm_typ) → `formula_components`(공식=구성요소) → `price_components`(정의+`prc_typ_cd`+`use_dims`) → `component_prices`(10차원 단가행). `dbm-price-import-builder` decomposes + builds the xlsx + mermaid; `dbm-validator` gates **P1~P6** (그릇 정합·stale 차단·분해 무손실·단가/합가 정당·동시매칭 0·엔진 시뮬레이션). **No DB writes; real INSERT = round-5 + human approval.** Per the round-9/10 lesson, prefer inline Korean execution. See `dbm-price-import-prep`.

- **round-22 (6축 기초데이터 staged 교정·적재)**: rounds 1–21 mapped/loaded/corrected by **시트(상품군)** or **동형 클래스**. round-22 re-frames the *already-loaded-but-wrong* live data by the **6 base-data axes** that webadmin `tools/load_master.py` actually loads by — ① 기초코드 `t_cod_base_codes`(SEED) → ② 사이즈 `t_siz_sizes` → ③ 도수 `t_clr_color_counts` → ④ 자재 `t_mat_materials` → ⑤ 공정 `t_proc_processes` → ⑥ 카테고리 `t_cat_categories`. The load-bearing insight: 매핑 오류의 진원이 load 로직(6축 단위)에 있으므로 같은 축으로 횡단 재조망해야 결함을 정확히 짚는다 — ④자재 오염(색/형상/사이즈/용량/구수가 자재행, .08/.09/.10 130+행)·⑥카테고리 고아(14노드 113상품)·도수↔별색은 분리 정상(③ 깨끗·④의 잉크색 유입 목적지). **[HARD] 2 절대 전제**: (1) **P-TRUNCATE 재실행 가드(B-1·1순위)** — load_master가 6축 전부 `TRUNCATE … CASCADE` 후 v03 무변환 재INSERT → 재실행 가드 없으면 모든 교정 무효(staged의 전제); (2) **착수 전 6축 라이브 전수 재실측** — 라이브 부분 진화(레더 .08→.06 이미 교정)로 진단 stale 위험. 정답 규칙(별색=공정·색≠자재·두께=자재·판걸이수=앱)은 인쇄도메인+경쟁사(WP/RP/CIP4) 흡수 판정으로 정립(`32_axis-staged-load/01`), 축별 교정 의사결정 트리·staged 6단계는 `02`가 권위. FK 위상 staged(기초코드 SEED → ②~⑥ 마스터 → 상품 → 연결행 → CPQ → 가격) + 멱등 `ON CONFLICT` UPSERT + 롤백전용 DRY-RUN; `dbm-validator` gates **X1~X6**(P-TRUNCATE 가드·freshness·경계오염 0·멱등·라이브 DRY-RUN·비파괴/독립). 신규 에이전트 0 — `dbm-domain-researcher`·`dbm-correctness-auditor`·`dbm-loadspec-extractor`·`dbm-load-builder`·`dbm-ddl-proposer`·`dbm-validator`·`dbm-option-mapper` 재사용·조율. **[v2 경로 판정 — 03 분석]** load_master(`tools/load_master.py`)는 **무변환 전파기**(v03 시트 셀값을 `TRUNCATE … CASCADE` 후 그대로 INSERT·도메인 변환 없음·유일 코드 교정=`ENUM_ALIAS`/`MAT_TYP_OVERRIDE`)다. 따라서 **6축 오류 진원은 전부 ⓐ(입력 v03)** — 자재 색/형상 오염·카테고리 고아 모두 v03 인코딩의 무변환 전파이지 코드 결함(ⓑ)이 아니다. ∴ 교정의 정답은 라이브 직접 SQL(**경로 X**·개발자 재적재 시 `TRUNCATE`로 소멸하는 임시책)이 아니라 **진원 v03 입력을 권위(상품마스터/가격표)로 바로잡은 교정 입력 엑셀을 재적재(경로 Y·근본·P-TRUNCATE 안전·CONDITIONAL-YES)**다. **[HARD] webadmin 코드 수정 금지**(개발자 GitHub 배포·read-only oracle) — 코드 강제 영역은 개발자 백로그 C-1~C-6. 경로 Y 3조건: 시트명/헤더 v03 동일·행순/surrogate 코드 보존(삭제=`use_yn='N'`·신규=말미 append·`issue:152` 행순 PK 재발급으로 가격사슬 파손 방지)·개발자가 입력파일 교체+재적재(`:39` 하드코딩). **우리 산출 = 교정 입력 엑셀 + 검증(롤백 DRY-RUN/라이브 대조 X1~X6) + 개발자 백로그 — 실 재적재·코드 수정 = 개발자 협업·인간 승인.** Per the round-9/10 lesson, prefer inline Korean execution. See `dbm-axis-staged-load`.

## Team & roles

| Agent | Role | Skill (round-1 / round-2) |
|-------|------|---------------------------|
| `dbm-schema-analyst` | DB structure → sheets (read-only psql); round-2 also extracts the missing `t_prc_*` DDL | dbm-schema-extract |
| `dbm-excel-analyst` | Excel parse + normalize (round-2: 계산공식집초안 + 단가시트 matrices) | dbm-excel-parse |
| `dbm-mapping-designer` | mapping spec + load CSV | dbm-mapping / **dbm-price-formula** |
| `dbm-validator` | boundary cross-check + loadability; round-4 G1–G9 gate | dbm-mapping / **dbm-price-formula** / **dbm-load-readiness** |
| `dbm-load-builder` | **round-4**: assemble FK-ordered load bundle + code-row pre-load + manifest (`09_load/`). **round-5**: turn the GO bundle into idempotent `ON CONFLICT` SQL + transaction wrap + loader (`09_load/_exec*/`) | **dbm-load-readiness** / **dbm-load-execution** |
| `dbm-ddl-proposer` | **round-5/6**: close GAP/BLOCKED with minimal `t_*`-consistent new-entity DDL proposals (`11_ddl_proposals/`, search-before-mint); round-6 GAPs = `ref_param_json`·hidden-essential·포장옵션·비치수 size | **dbm-load-execution** / **dbm-cpq-option-mapping** |
| `dbm-option-mapper` | **round-6 only**: design the CPQ option layer — attribute→entity master map + per-상품군 option-layer pilot (option_groups/options/option_items·templates·constraints), polymorphic `ref_dim_cd` referencing already-loaded dimension rows | **dbm-cpq-option-mapping** |
| `dbm-coverage-auditor` | **round-7 only**: build the 입체 coverage matrix (상품군 × t_* 엔티티), 필요요소 도출(엑셀 권위) + 라이브 실측(읽기전용 psql) + admin 3원 대조 + 관계 무결성 + 갭 보드. 조망/검증 전용 (적재 아님) | **dbm-coverage-matrix** |
| `dbm-change-tracker` | **round-10**: 두 엑셀 버전 키 기반 3-way diff(ADDED/REMOVED/MODIFIED) + 셀→t_* 영향 매핑 + new↔live 정합 + 변경 매니페스트 + 멱등 델타 UPSERT. **round-14**(스키마 모드): webadmin `sql/`·`tools/` 베이스라인↔HEAD git diff → 스키마 구조 변경이력 + 3-way 정합(git 선언/라이브 적용/우리 산출 참조) + DDL·백필 레벨 분리 → 우리 산출 stale 영향 매트릭스 + 갱신 매니페스트 | **dbm-change-tracking** / **dbm-schema-change-tracking** |
| `dbm-domain-researcher` | **round-11 + round-12**: (r11) 상품마스터 각 시트 컬럼의 인쇄 도메인 의미 확정(컬럼 도메인 사전, 애매모호 0) + 각 상품명 리서치 → 자재/공정 BOM. 권위 후니 PDF > 07_domain KB > 국내외 표준(보조). 07_domain 의미축 재사용(재유도 금지). (r12) 4 내부 권위 결합 + 경쟁사/CIP4/표준 갭헌팅 + 라이브 실측 → 시트별 mapping-final | **dbm-column-domain** · **dbm-mapping-research** |
| `dbm-loadspec-extractor` | **round-11 only**: raw/webadmin Django 소스(models/admin/basecodes/views)에서 각 t_* 적재명세 추출 — 컬럼·폼위젯·코드값그룹·자동채번·적재 surface(admin changeform/상품뷰어), file:line 근거. DB 미접속(소스 읽기 전용) | **dbm-loadspec-extract** |
| `dbm-correctness-auditor` | **round-13 only**: 라이브=교정대상 역전. webadmin 적재 oracle(`sql/`·`tools/load_master.py`)+스키마의도+엑셀+도메인을 정답으로, 상품별 추출규칙(extraction-plan) 도출 + 적재로직 재구성(loadlogic-notes) + 라이브 전수 diff(live-diff) → 교정 매니페스트(correction-manifest). 비파괴(COMMIT/DDL/DELETE 없음) | **dbm-correctness-audit** |
| `dbm-price-import-builder` | **round-16 only**: 인쇄상품 가격표 다차원 매트릭스·복합셀 → Phase11 가격엔진 `t_prc_*` 4테이블 그릇(formulas·formula_components·price_components[`prc_typ_cd`·`use_dims`]·component_prices[10차원]) 분해 + webadmin 복붙용 작업 엑셀(.xlsx) + 매핑 절차 mermaid. 분해 기준=엔진 매칭 규칙(단가/합가·opt_cd/proc_cd 차원·NULL 와일드카드·동시매칭 금지). round-14 stale 흡수. 비파괴 | **dbm-price-import-prep** |
| `dbm-price-formula-auditor` | **round-17 only**: 라이브 가격공식(`t_prc_price_formulas`) 정리 검증 — 라이브 DB↔webadmin 소스(`price_views.py`·가격허브/뷰어 mockup)↔admin 화면 3중 대조로 4축(정리 상태·실무진 가독성·`formula_components` 배선 사용가능성·`price_viewer` 노출) 판정 + 실무진 정리표·결함 보드·공식명/비고 개선안. frm_typ_cd 라이브 실재 결판(round-16 전제 대조). round-16 산출·가격사슬 단절 재사용. 비파괴 | **dbm-price-formula-audit** |
| `dbm-price-engine-verifier` | **round-18 only**: 가격엔진 실증검토 — 라이브 `evaluate_price` 미구현 전제(gstack 실증) → 상품군(아크릴·문구·굿즈/파우치)별 ① 가격사슬 완전성 라이브 실측(소스 바인딩·공식→배선→단가행·`t_dsc` 할인 연결·등급) ② Phase11 명세(11-CONTEXT/prcx01) 재구현 검증용 계산기(`recompute.py`)로 대표 케이스 재계산(단가/합가·NULL·동시매칭·수량구간·시계열·할인 순차곱) ③ 가격표 known값↔가격뷰어 수치 대조 ④ 가격뷰어 정합. round-16/17 산출 재사용. 비파괴(읽기전용) | **dbm-price-engine-verify** |
| `dbm-competitor-benchmark` | **round-18 확장**: 경쟁사 가격 합리성 벤치마크 — 우리 재계산값을 같은 옵션으로 와우프레스(공개 WooCommerce Store API)·레드프린팅(본인 계정 jobcost + 기존 캡처)과 대조. **"같은 옵션인데 터무니없이 가격차 = 우리측 결함 신호"**(사용자 directive·경쟁사=합리성 오라클·정답 아님). 동형 옵션 매핑·3열 비교표·B-gate(정상/주의/🔴터무니없음)·🔴분 arbiter 라우팅. 비파괴(경쟁사 가격 조회만·주문/폼 금지) | **dbm-competitor-benchmark** |
| `dbm-price-arbiter` | **round-18 확장**: 가격 정합 정립 심의(돈-크리티컬 전담) — 가격공식 클래스별 가격↔상품요소(자재·공정·사이즈·도수·옵션) 매핑이 권위 엑셀대로 정확한지 심층 검토 + benchmark 🔴/verifier 결함 근본원인 규명 + 미진 요건(184상품 가격 미구성·판형 해석·옵션→구성요소) 정립 방안 deliberation(대안·트레이드오프·권고·t_*·트랙·컨펌). 심의자(보고서 아님). 비파괴(실 교정=round-5/13/ddl-proposer+인간 승인) | **dbm-price-arbiter** |
| `dbm-readiness-auditor` | **round-19 + round-21**: (r19) 상품군 종단 견적가능 감사·조율 — 한 상품군의 엑셀 전 의미컬럼 × 목표 t_* 라이브 적재 점검(booklet식 컬럼 readiness 매트릭스) + 견적가능 Q1~Q6 게이트(①UI 옵션선택+②선택의 차원환원 생산정보+③가격계산) + 미달 라우팅(round-13/5/6/16/18) + RTM(상품군×견적요소 진척판). (r21) 동형 효율 파이프라인 게이트·조율 — Sc 동형 분류(계산공식집초안×옵션·50개 미만)·대표(시트 실측 superset) 선정 → 대표 5레이어 완전종단(주문가능 형태 실적재·토대 §9) → Sp 동형 자동전파(`dbm-batch-load`). 이진 게이트 자율 검증·보정 폐루프. 점검·판정·조율 전담(직접 적재 안 함·실 COMMIT 인간 승인). 토대 = `dbm-batch-load/references/product-group-isomorphism-model.md` | **dbm-product-readiness** |

All agents spawn with `model: "opus"`. Round is resolved in Phase 0; the designer/validator load the round-matching skill (round-2 → `dbm-price-formula`, round-4 → `dbm-load-readiness`, round-5 → `dbm-load-execution`, round-6 → `dbm-cpq-option-mapping`, round-18 → `dbm-price-engine-verify`). round-18 spawns `dbm-price-engine-verifier` (one per family or inline, generate) + `dbm-validator` (PE1~PE6 gate, separate agent = 생성자≠검증자); per the round-9/10 lesson, the orchestrator may run round-18 inline (Korean, visible) — the recompute is read-only. `dbm-load-builder` runs in round-4 and round-5; `dbm-ddl-proposer` is spawned in round-5 and round-6; `dbm-option-mapper` is spawned only in round-6; **round-11 spawns `dbm-domain-researcher` (의미) ∥ `dbm-loadspec-extractor` (적재명세) in parallel, integrated into 매핑 정보; round-13 spawns `dbm-correctness-auditor` (one per family, fan-out) + `dbm-validator` (K1~K6 gate, separate agent); per the round-9/10 lesson (위임이 "완료"만 반환·신규 에이전트 생성세션 미로드), the orchestrator may run round-11/13 inline (Korean, visible) instead of delegating.**

## Execution mode: agent team (hybrid)

- **Phase 2 (analysis)**: schema-analyst and excel-analyst run in PARALLEL — independent inputs, no shared writes.
- **Phase 3 (mapping)**: single mapping-designer integrates both — barrier after Phase 2.
- **Phase 4 (validation)**: validator cross-checks, runs incrementally per table.

Use `TeamCreate` + `TaskCreate` for coordination; agents self-coordinate via `SendMessage` and share the `_workspace/huni-dbmap/` file tree. Call `TeamDelete` only after all teammates shut down.

## Phase 0: context check (re-invocation routing)

Before spawning, inspect `_workspace/huni-dbmap/`:
- Artifacts absent → **initial run**, full pipeline.
- Artifacts present + user asks for a partial change (e.g. "re-map only 문구", "fix the rate unit") → **partial re-run**: re-invoke only the affected agent(s); preserve confirmed outputs.
- Artifacts present + user provides new source/scope → **new round**: keep prior round, add the new target tables/sheets.

Always confirm the resolved mode in your status line before proceeding.

## Pipeline

**Phase 1 — Setup**: verify `.env.local` has `RAILWAY_DB_*`; verify the two xlsx exist; resolve the round's target tables. (Read-only DB connection check.)

**Phase 2 — Parallel analysis** (team, parallel):
- schema-analyst → `00_schema/` (structure sheets, columns.csv, code-values.md, category enumeration for scope resolution).
- excel-analyst → `01_excel/` (workbook-structure.md, discount-brackets.csv, extraction-notes.md).

**Phase 3 — Mapping** (mapping-designer): consume both → `02_mapping/mapping-spec.md`, `load/<table>.csv`, `dsc-code-proposals.md`. List all "design decisions needing confirmation."

**Phase 4 — Validation** (validator, incremental): cross-check Excel↔CSV↔spec↔schema → `03_validation/validation-report.md` with GO/NO-GO. On findings, route back to the designer (or schema-analyst) and re-validate.

**Phase 5 — Report & escalate**: synthesize results, surface design decisions to the user via AskUserQuestion (apply dates, rate unit, last-bracket cap, scope granularity). The lead (this orchestrator) is the only one who talks to the user.

## Pipeline (round-2 price)

Round-2 reuses the same team but inserts a **fit-gap gate before mapping** (the price model is a formula engine, not flat rows). Designer + validator load `dbm-price-formula` instead of `dbm-mapping`.

**Phase 1 — Setup**: same `.env.local` / xlsx checks; round resolved to round-2 (price).

**Phase 2a — DDL extraction** (schema-analyst, FIRST): extract the full `t_prc_*` (6 tables) + `t_prd_product_price_formulas` / `t_prd_product_prices` DDL → `00_schema/price-engine-ddl.md`, append to `columns.csv`. round-1 left these un-extracted; nothing downstream may proceed on guessed columns.

**Phase 2b — Excel analysis** (excel-analyst, parallel with 2a): parse 상품마스터 `계산공식집초안` (enumerate 공식 유형 + steps + 참조시트) and the 19 가격표 단가시트 (matrix shapes, banded headers) → `01_excel/price-formulas-normalized.md`, `01_excel/price-sheets-structure.md`.

**Phase 3 — Fit-gap GATE** (mapping-designer + validator): per 공식 유형, wire onto the engine and verdict ADEQUATE / ADEQUATE-WITH-PROPOSALS / GAP → `02_mapping/schema-fitgap-price.md`. **Mapping of a type does NOT start until its verdict is ADEQUATE\***. This phase answers the user's "is the schema adequate?" question and is the round-2 entry gate.

**Phase 4 — Pilot mapping** (mapping-designer): the unit of mapping is the 상품마스터 sheet. Pilot the SIMPLEST single-formula-type sheet first — **NOT 디지털인쇄** (it mixes 원자합산형 + 고정가형 in one sheet = most complex). Recommended order: a 고정가형 `(가격포함)` sheet (문구/상품악세사리 → `t_prd_product_prices`) → a single-type computed sheet (캘린더 원자합산형 / 아크릴 면적매트릭스형 → engine) → mixed-type sheets last (디지털인쇄, one type at a time). End-to-end for the chosen sheet → `02_mapping/price-mapping-spec.md`, `load/<table>.csv`, `price-code-proposals.md`. List design decisions needing confirmation.

**Phase 5 — Validation** (validator, incremental): boundary cross-check including the price-specific **recompute check** (sum components per formula for a sample product+qty, compare to a known price) → `03_validation/price-validation-report.md` with GO/NO-GO. Route findings back to the designer.

**Phase 6 — Report & widen decision**: surface the fit-gap verdict + pilot result + price user-decisions; on GO, ask whether to widen to the next 공식 유형 / category.

## Pipeline (round-3 mapping audit — L1 토대 → L2 정합)

**[프레임 교정] "엑셀=권위 단순 집합대조" 폐기 → "DB 정규화 규칙=기준" + L1↔L2 2계층.** 검증 결함의 뿌리는 매핑(L2)이 아니라 엑셀 추출(L1)이다(false MISSING — 포맥스 A1: 속성별 단일컬럼 평면화로 작업사이즈 공백·행숨김 신호 소실). 방법론 = `05_method/`(A 베스트프랙티스·B 정규화규칙사전·C 전수대조설계·D 독립검증·E 무손실추출·F 시트구조·G 추출기준서), L1 토대 = `06_extract/`. Designer/validator load `dbm-mapping-audit`, excel-analyst loads `dbm-excel-parse` L1 섹션.

**Phase 0 — 방법론/토대 확인**: `05_method/`(A~G) + `06_extract/`(L1 토대) 존재 점검. 방법 미설계면 **1단계 방법설계**(A 리서치 + B 규칙사전[기초데이터 마스터 전체가 기준, 표본 오버피팅 금지] + C 전수설계) 선행 → D 독립검증 → 하네스 교정.

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* + 두 xlsx. **토대 범위 = 상품마스터 13시트 + 가격표 `판걸이수`(사이즈 마진/작업/블리드/전지 권위) + `출력소재(IMPORT)`(`*별도설정` 자재 권위)**. 가격표 나머지 16시트(단가)=round-2 영역. **엔티티 2축: 상품정보 먼저 정립 / 가격정보(단가·연당가·가격)는 axis=price 분리 라벨링해 round-2 이연**(무손실 보존).

**Phase 2 — L1 충실추출 (토대 정립, excel-analyst)**: `extract_l1.py --sheet`로 15시트 L1 추출(8 정보축, dbm-excel-parse L1 섹션). 의미코드맵(행숨김=비활성·그레이배경=품절/준비중·그레이글자/숨김열=내부용·노랑=신규·★=제약) 라벨. `verify_l1.py` 9게이트(non-empty 100%·round-trip 0, 미통과=L2 차단). `*별도설정`↔IMPORT ● 매핑. → `06_extract/`(`<slug>-l1.csv`+meta·`product-info-foundation.md` 정합검증 대상·`price-info-deferred.md` 이연·`seoljeong-import-map.md`).

**Phase 3 — DB 적재값 추출 + 마스터 정합** (schema-analyst read-only → validator FIRST): 9속성 테이블(`t_prd_product_sizes/materials/print_options/processes/process_excl_groups/plate_sizes/bundle_qtys/page_rules/addons`)+마스터 → `00_schema/ref-<table>.csv`(stale면 라이브 재추출). 마스터(사이즈/자재/공정/코드)↔엑셀 코드체계 정합 → `04_audit/00_master-parity.md`. Gate: 상품 연결 검증은 마스터 정합 후.

**Phase 4 — L2 속성별 정합** (validator, incremental): `product-info-foundation.md`를 입력으로, 속성별 DB↔**기대행(B규칙 정규화 변환)** 대조 → MATCH/MISSING/EXTRA/MISMATCH. **[HARD] 숨김/미출시=비활성 분류(MISSING 아님)**. 기초데이터순 staged(사용자 선택). EXTRA 삭제 단정 금지(플래그+출처). → `04_audit/<attr>-parity.md`+`<attr>-mismatches.csv`.

**Phase 5 — 종합 + 보고** (validator → lead): `04_audit/audit-summary.md` 대시보드(속성별 4분류) + 이슈. Lead가 사용자에 정정 우선순위. → BLOCK 해소 → 가격정보(round-2) → 전수.

## Pipeline (round-4 load-readiness — 적재본 조립 → G1~G9 게이트)

**[프레임] 앞선 라운드는 매핑이 *맞는지*(round-2 가격·round-3 audit)를 증명했다. round-4는 그 검증된 매핑이 *적재 가능한지*를 증명한다 — 순서·라이브 제약·FK 충족은 정확성과 다른 실패면이다.** 권위 = `docs/goal-2026-06-06-01.md`(완료 기준 G1~G9·t_* 화이트리스트·무적재 원칙). 생성(builder)과 게이트(validator)는 **별도 에이전트** — 이 분리가 게이트 G9다. `dbm-load-builder`와 `dbm-validator`는 `dbm-load-readiness` 스킬을 로드한다.

**Phase 0 — 입력 확인**: round-2/3 산출물에 GO 판정(`03_validation/*-final.md`)이 있는 테이블만 적재 대상. 검증 GO 없는 매핑은 round-4 진입 불가(먼저 해당 라운드 완료).

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용 연결 확인. 적재 대상 = 상품마스터 `t_prd_*` + 가격 `t_prc_*`(`dbm-load-readiness` `references/fk-load-order.md` 화이트리스트). round-4로 해소.

**Phase 2 — 적재본 조립** (load-builder): 검증된 매핑(`02_mapping/load*`)을 입력으로 ① t_* 화이트리스트 강제 → ② 라이브 FK 위상정렬로 적재 순서 확정 → ③ 누락 FK-타깃 코드값 = `t_cod_base_codes` 선적재 *제안*(DDL 무변경, step 00) → ④ 행 분류(즉시적재 / 차단-후니등록대기 / GAP) → `09_load/`(`load-manifest.md` + 순서접두 `load/<NN>_<table>.csv` + `code-row-preload.md` + `blocked-and-gaps.md`). 자기승인 금지 — validator에 인계.

**Phase 3 — G1~G9 게이트 + DRY-RUN** (validator, 적대적): `dbm-load-readiness` §2 + `references/g-gates.md`로 G1~G9 각각 증거기반 PASS/FAIL. G6 = 롤백전용 DRY-RUN(`references/dry-run.md`, lead 승인 시; 기본은 로컬 제약검사). 전부 PASS여야 GO. builder가 만든 번들을 validator가 검증(G9 독립성) — 조용히 고치지 말고 finding을 builder(순서/행)·designer(매핑)로 라우팅, 변경분만 재게이트. → `03_validation/load-readiness-gate.md`(GO/NO-GO + 게이트별 결과 + 즉시적재/차단/GAP 집계). **NEVER COMMIT.**

**Phase 4 — 보고 + 승인 게이트** (lead): GO 번들 + 코드행 선적재 제안 + GAP을 사용자에 에스컬레이션. 실제 INSERT 실행 승인은 본 트랙 종착점 너머(인간 승인). NO-GO면 실패 게이트·라우팅 보고 후 해당 단계 재조립·재게이트.

## Pipeline (round-5 load-execution — 멱등 실행본 + DDL 제안 → R1~R6 게이트)

**[프레임] round-4는 적재본이 *적재 가능*함을 증명했다. round-5는 그 GO 적재본이 *실행 가능·재실행 안전*하고, round-4가 GAP/차단으로 남긴 부분이 *정직하게 닫힘*을 증명한다 — 적재가능성과 실행가능성·멱등성은 다른 실패면이다.** 권위 = `docs/goal-2026-06-06-02.md`(R1~R6 + G1~G9 carry-forward, DDL 제안 격상·COMMIT 금지). 생성(builder/proposer)과 게이트(validator)는 **별도 에이전트** = R6. 세 에이전트는 `dbm-load-execution` 스킬을 로드한다.

**Phase 0 — 입력 확인**: round-4 GO 적재본(`09_load/_assembled*/`) + 게이트 판정서(`03_validation/load-readiness-gate*.md`)가 GO인지 확인. round-4 GO 없는 트랙은 round-5 진입 불가(먼저 round-4 완료).

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용 연결 확인. 입력 = round-4 GO 적재본(재매핑 금지) + `blocked-and-gaps.md`(GAP 목록).

**Phase 2 — 실행본 빌드 + DDL 제안** (team, **병렬** — 독립 입력):
- **load-builder** → GO 적재본을 ① 멱등 `INSERT … ON CONFLICT`(충돌키=라이브 PK/UNIQUE에서 읽기) → ② 단일 트랜잭션 래핑(`apply.sql`, `ON_ERROR_STOP`) → ③ FK순 + 코드행 선적재 step 00 → ④ 적재 로더(기본 롤백, `--commit`=인간 승인) → `09_load/_exec/`·`_exec_price/`. 재현 생성기·provenance.
- **ddl-proposer** → round-4 `blocked-and-gaps.md`의 GAP/BLOCKED를 입력으로 ① search-before-mint(기존 t_* 무손실 표현 불가 입증) → ② 최소 신규 엔티티(사다리: 코드행<컬럼<JSONB<테이블) 라이브 컨벤션 정합 설계 → ③ 영향분석(기존 행·FK·적용순서·백필·롤백) → `11_ddl_proposals/`(`.sql`+`.md`+summary). DDL 직접 적용 금지.

**Phase 3 — R1~R6 게이트 + 라이브 DRY-RUN** (validator, 적대적): `dbm-load-execution` §3 + `references/live-dry-run.md`로 **G1~G9 carry-forward 재확인 + R1~R6** 각 증거기반 PASS/FAIL. 기본은 로컬 선검사(SQL 파싱·`ON CONFLICT` 존재·충돌키 정합·트랜잭션 구조). **R1/R5 라이브 DRY-RUN(롤백전용)은 lead 승인 시 1회** — 멱등성 2회 적용 + 제약위반 0 실증. builder/proposer 산출을 validator가 검증(R6 독립성) — 조용히 고치지 말고 finding을 builder(SQL/순서)·proposer(DDL)·designer(매핑)로 라우팅, 변경분만 재게이트. → `03_validation/load-execution-gate.md` GO/NO-GO. **NEVER COMMIT.**

**Phase 4 — 보고 + 승인 게이트** (lead): GO 실행본(`_exec*/`) + DDL 제안(`11_ddl_proposals/`) + 인간 승인 큐(① 라이브 DRY-RUN 실행 ② 실제 `COMMIT` 적재 ③ 신규 DDL 적용 ④ 코드행 등록)를 사용자에 에스컬레이션. 실제 적재·DDL 적용은 본 트랙 종착점 너머(인간 승인). NO-GO면 실패 게이트·라우팅 보고 후 재빌드·재게이트.

## Pipeline (round-6 CPQ option-layer mapping — 속성→엔티티 마스터 지도 + 상품군 파일럿)

**[프레임] rounds 1–5는 L1(차원·가격)을 매핑·적재했다. round-6는 L2(CPQ 옵션 레이어)를 매핑한다 — 종류가 다르다: L2는 새 데이터를 적재하지 않고, 이미 적재된 차원행을 `ref_dim_cd`로 참조해 선택 옵션으로 묶는다.** L2를 L1과 혼동(차원 데이터를 option_items에 재적재)하는 것이 1차 실패모드. 권위 입력 = `10_configurator/`(cpq-design·cpq-schema·walkthrough 2종·wowpress-option-model·huni-goods-option-mapping) + `00_schema/cpq-schema.md`(트리거 `fn_chk_opt_item_ref` 권위). 경쟁사 참조 = WowPress(`wowpress-option-model.md`) + RedPrinting(`_workspace/huni-widget/02_analysis/cascade-rules.md`·`03_spec/componenttype-mapping-matrix.md`). 설계(option-mapper)와 검증(validator)은 별도 에이전트. 산출물 루트 = `10_configurator/`. 둘 다 `dbm-cpq-option-mapping` 스킬 로드.

**Phase 0 — 입력 확인**: `10_configurator/`(설계 정본·walkthrough·벤치마크) + `06_extract/<sheet>-l1.csv`(엑셀 옵션성 컬럼) + `00_schema/`(cpq-schema 트리거·ref-product-*.csv 차원행) 존재 점검. 차원행이 라이브에 적재돼 있어야 option_items가 참조 가능(없으면 L1 선적재 BLOCKED 표기).

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용. 우선 상품군 결정(사용자 — 굿즈/배너/엽서 등). 마스터 지도는 13시트 전체, 파일럿은 1상품군.

**Phase 2 — 속성→엔티티 마스터 지도** (option-mapper): 13 상품마스터 시트의 옵션성 attribute 인벤토리 → 각 attribute 타깃 엔티티(dimension/CPQ-option/price/constraint) verdict + 근거 + WowPress축/Red제약 대응 → `10_configurator/attribute-entity-map.md`. 입도 결정(흡수 vs 분리: 형상→규격·본체색→재질·인쇄면→도수).

**Phase 3 — 상품군 파일럿** (option-mapper): 1상품군에 option_groups(sel_typ)→options→option_items(polymorphic ref_dim_cd → 라이브 차원행, 트리거 dispatch 정합)+constraints(JSONLogic)+templates 종단 인스턴스화. FK 위상정렬(차원행→그룹→옵션→아이템→템플릿→제약). → `<family>-option-layer.md` + `load/<table>.csv`. GAP(ref_param_json/hidden-essential/포장/비치수)는 `cpq-option-gaps.md`로 분리해 ddl-proposer 라우팅. design decisions 표기.

**Phase 4 — 검증** (validator, 적대적): 경계면 교차 — ① option_items↔라이브 차원행(트리거 reference resolution = L2 load-bearing 검사, 도수=opt_id·자재 usage_cd 키슬롯 정합·부재행 BLOCKED) ② 마스터 지도 완전성(누락0) ③ option layer↔라이브 CPQ 스키마 ④ constraints↔JSONLogic 손계산 ⑤ GAP 정직성. → `03_validation/cpq-option-validation.md` GO/NO-GO + insertable/BLOCKED/GAP 집계. builder/designer 분리(검증 독립성). NEVER COMMIT.

**Phase 5 — 보고 + 결정** (lead): 마스터 지도 + 파일럿 결과 + design decisions(attribute 타깃·sel_typ·잉크색 축·우선 상품군) + GAP을 사용자에 에스컬레이션. 다음 상품군 확대 여부 결정. 실제 적재·코드행·DDL은 인간 승인.

## Pipeline (round-10 change-tracking — 버전 diff → 변경 매니페스트 + 멱등 델타 적용)

**[프레임] 앞선 라운드는 *단일 스냅샷*을 매핑·적재했다. round-10은 *두 버전의 차이*를 추적·적용한다 — 적용할 델타 ≠ (new − baseline). 라이브 DB가 상태 권위(baseline=의도·live=현실).** 생성(change-tracker)과 게이트(validator)는 별도 에이전트 = V8. 둘 다 `dbm-change-tracking` 스킬 로드. 산출 루트 = `14_change-tracking/<baseline>-to-<new>/`.

**Phase 0 — 입력 확인**: 두 버전 xlsx 존재(baseline=현 라이브 적재 소스, new=목표). 직전 버전쌍 산출물이 있으면 보존(감사 체인). 버전쌍 미존재 → 신규 추적.

**Phase 1 — Setup**: `.env.local` RAILWAY_DB_* 읽기전용 확인. 대상 시트 = 변경 발생 시트(전 시트 diff 후 변경분만). 키 컬럼 시트별 확정(`prd_cd`/`prd_nm`).

**Phase 2 — 버전쌍 정규화 추출 + 키 기반 3-way diff** (change-tracker, excel-analyst 보조): 양 버전을 동일 추출기(`dbm-excel-parse`)로 L1 정규화 → `diff_versions.py`로 시트별 `{key→row}` 3-way diff → ADDED/REMOVED/MODIFIED(셀별 전→후)/UNCHANGED + 키 무결성·rename 의심쌍 플래그. → `_extract/{baseline,new}/`·`diff/<sheet>-changes.csv`·`_diff-summary.md`.

**Phase 3 — 셀→t_* 영향 매핑 + 라이브 정합** (change-tracker, schema-analyst 보조): 각 변경 셀 → 영향 t_* 엔티티/컬럼(9속성·가격·CPQ 렌즈) + 영향 라이브 행(prd_cd) 현재값 읽기전용 실측 → new 목표와 대조해 apply_class(INSERT/UPDATE/NO_OP/LOGICAL_DELETE_PROPOSAL/ESCALATE/GAP). → `impact/<entity>-impact.csv`.

**Phase 4 — 변경 매니페스트 + 델타 적용본** (change-tracker): V7 매니페스트(행 단위 감사본 CSV+MD) + 멱등 델타 UPSERT(`dbm-load-execution` 패턴: `_delta/<NN>_<table>.sql`·`apply.sql`·롤백 로더, FK 위상정렬, `upd_dt`) + 코드행 선적재 제안 + REMOVED 논리삭제 제안/GAP 분리. → `14_change-tracking/<pair>/`. NEVER COMMIT/DELETE.

**Phase 5 — V1~V8 게이트** (validator, 적대적): V1 키매칭·V2 분류완전성(셀 누락0)·V3 REMOVED 비파괴·V4 영향매핑·V5 멱등성(DRY-RUN 2회 delta 0)·V6 upd_dt·V7 추적성(매니페스트↔diff 1:1)·V8 라이브 수렴(독립). 전부 PASS = GO. → `03_validation/change-tracking-gate.md`.

**Phase 6 — 보고 + 승인 게이트** (lead): 변경 매니페스트 요약(시트별 4분류) + 델타 적용본 + 인간 승인 큐(① REMOVED 논리삭제 처리 ② rename 의심쌍 판정 ③ 신규 코드행 등록 ④ 실제 델타 COMMIT)를 사용자에 에스컬레이션. 실 적재는 본 트랙 종착점 너머.

- File-based via `_workspace/huni-dbmap/` (00_schema / 01_excel / 02_mapping / 03_validation / 14_change-tracking / _meta).
- Task-based via TaskCreate/TaskUpdate for dependency + progress.
- Message-based via SendMessage for live coordination and findings handoff.

## Error handling

- DB connection fail: retry once, then report the blocker (do not guess ports). NEVER print the password.
- Agent fail: retry once with a tightened prompt; if still failing, proceed without that result and note the gap in the report.
- Conflicting data: never delete — keep both with provenance and flag for user decision.
- Constraint conflict in mapping: stop and document (no silent truncation).

## Security (HARD)

- DB credentials live ONLY in `.env.local` (chmod 600, gitignored). NEVER write them into `_workspace/` (git-tracked) or echo them to stdout.
- This harness performs NO destructive DB writes. Any dry-run must be rollback-only and lead-authorized.

## User-decision gate

Surface these to the user before declaring the round done (via AskUserQuestion):

round-1 (discount):
- Rate unit: `dsc_rate` stored as percent (5.00) or fraction (0.05)?
- `apply_ymd` / `apply_bgn_ymd` effective date value.
- Last bracket cap: real `max_qty` or open-ended (NULL)?
- Apply-scope granularity: category-level vs explicit product list.
- New code values (`dsc_tbl_cd`, `dsc_typ_cd`) naming.

round-2 (price):
- Fit-gap resolution for any `GAP`/`ADEQUATE-WITH-PROPOSALS` 공식 유형 (modeling workaround vs escalate).
- New code naming (`*_cd` for formulas / components, e.g. `PRF_DGP_ATOMIC`).
- Quantity-axis semantics: store 출력매수 vs 주문수량 in `component_prices`; where the 판걸이수 conversion lives (formula step vs baked-in).
- Effective-date value for time-series `component_prices` / `product_prices`.
- Widen-or-stop after the pilot: which 공식 유형 / category next.

round-4 (load-readiness):
- Code-row pre-load proposals: 후니가 라이브에 등록할 `t_cod_base_codes` 코드값(예: `PRC_COMPONENT_TYPE.06`) 승인.
- GAP 모델링: t_*로 무손실 표현 불가 항목(예: 박 2단 룩업) — 에스컬레이션 처리 방향.
- Real INSERT 실행 승인: GO 번들 제시 후 실제 적재를 진행할지(본 하네스 종착점 너머).

round-5 (load-execution):
- 라이브 DRY-RUN 실행 승인: 롤백전용이라도 쓰기 트랜잭션 — R1/R5 실증을 위해 라이브에서 1회 돌릴지.
- 신규 엔티티 DDL 적용 승인: `11_ddl_proposals/`의 CREATE/ALTER를 후니가 라이브에 적용할지(제안≠적용). GAP별 채택/보류.
- 실제 `COMMIT`(영구 적재) 승인: G1~G9 + R1~R6 PASS 실행본 제시 후 실제 적재를 진행할지(본 하네스 종착점 너머).
- `DO UPDATE` 대상 확정: round-4 update-set 컬럼(qty_unit·nonspec 등)을 멱등 갱신할지, 변경분만 적용할지.

round-6 (CPQ option-layer mapping):
- 우선 상품군: 마스터 지도 후 어느 상품군부터 option-layer 파일럿할지(굿즈/배너/엽서/캘린더 등).
- Attribute 타깃 모호 해소: 잉크색=도수 vs 자유옵션그릇, 머그 용량=비치수 size vs 규격 등 — 후니 도메인 확정.
- sel_typ 결정: 옵션그룹별 택1(SEL_TYPE.01)/택N(SEL_TYPE.02)·mand_yn·max_sel_cnt.
- GAP 처리 방향: ref_param_json(공정 파라미터)·hidden-essential·포장옵션·비치수 size를 ddl-proposer 제안으로 닫을지/보류할지.
- 실제 옵션 레이어 INSERT·코드행 등록 승인: GO 파일럿 제시 후 실제 적재 진행 여부(본 하네스 종착점 너머).

round-10 (change-tracking):
- REMOVED 처리: 엑셀에서 사라진 행(예: 아크릴 −24행)을 논리삭제(use_yn=N)할지·진짜 단종인지·재명명(rename)인지 — 인간 판정.
- rename 의심쌍 확정: ADDED+REMOVED 고유사도 쌍이 재명명인지 별개 변경인지.
- 신규 코드행 등록 승인: 신규 상품/속성이 요구하는 미존재 코드값(`t_cod_base_codes`) 등록.
- 실제 델타 COMMIT 승인: V1~V8 PASS 델타 적용본 제시 후 라이브에 실제 적용할지(본 하네스 종착점 너머).
- 변경이력 DB 정착 여부: upd_dt 외 전용 변경이력 테이블이 필요한지(필요 시 ddl-proposer 제안).

round-12 (mapping-research):
- 파일럿 시트 선정: 어느 시트부터 mapping-final을 확정할지(권장 디지털인쇄 — round-11 파일럿·검증 최다).
- CONFLICT 행 판정: 4 내부 권위가 불일치하는 컬럼의 최종 귀속(침묵 선택 금지 — 사용자/실무진 판정).
- 외부 갭 처분 승인: research-gap-board의 "매핑 수정" / "DDL 제안 라우팅" 처분 채택 여부.
- 🔴 컨펌 잔여: mapping-final의 미확정 행에 대한 실무진 추가 질문 발송 여부.
- round-4/5 인계 승인: M1~M6 GO 시트를 적재본 조립 트랙으로 넘길지(적재 자체는 별도 인간 승인).

round-14 (schema-change-tracking):
- 베이스라인 커밋 확정: 우리 산출이 분석한 webadmin 시점(자동 추정 vs 명시 지정).
- stale 산출 갱신 승인: impact-matrix MAJOR 항목(constraint_json 삭제·가격차원·dep_proc_cd)을 우리 산출에 실제 반영할지(추적은 제안까지).
- 백필 미완 처리: 신규 컬럼/테이블 0행(proc_cd/opt_cd·template_prices)을 우리 적재 트랙(round-5)에서 채울지.
- 정기 추적 트리거: webadmin Phase 12~15 진화 시 재추적 주기.

round-13 (correctness-audit):
- 파일럿 시트 선정: 어느 시트부터 교정 감사할지(권장 디지털인쇄 — round-11/12 검증 최다).
- MIS-LOADED 교정 방향: 라이브 오적재분(예: 코팅=공정인데 자재로 적재·레더 자재유형 혼재)을 어떻게 고칠지 — 기존행 재연결 vs 정정 vs 신설.
- 적재 로직 결함 처리: `load_master.py` 등에서 발견된 변환 규칙 결함을 webadmin 팀에 회신할지(원인 교정) vs DB만 교정.
- AMBIGUOUS 컨펌: oracle 내부 충돌(엑셀 vs ERD 문서) 행의 최종 판정(실무진/사용자).
- 실 교정 승인: 교정 매니페스트 GO분을 round-5(멱등 UPSERT)/round-10(델타) 트랙으로 넘겨 실제 COMMIT/논리삭제할지(본 하네스 종착점 너머·인간 승인).

## Pipeline (round-14 schema-change-tracking — webadmin 진화 → 스키마 변경이력 + 우리 산출 영향)

**[프레임] rounds 1–13은 라이브 스키마를 고정 타깃으로 봤다. round-14는 `raw/webadmin`(스키마+적재 소스)이 *진화*할 때를 추적한다 — 3-way 정합(git 선언/라이브 적용/우리 산출 참조) + DDL·백필 레벨 분리("컬럼 존재≠적용 완료").** `dbm-change-tracker`(round-14 모드)가 추적, `dbm-validator`가 게이트. 둘 다 `dbm-schema-change-tracking` 스킬 로드. 산출 루트 = `18_schema-change/<baseline>-to-<head>/`.

**Phase 0 — 베이스라인 식별**: 우리 산출이 분석한 webadmin 시점 커밋을 베이스라인으로 특정(인용 sql/컬럼 존재 시점 교차검증). HEAD=현재. 이전 추적 있으면 직전 HEAD가 다음 베이스라인.

**Phase 1 — 스키마 변경 분류** (change-tracker, 선언): 베이스라인↔HEAD `sql/`+`tools/`+`basecodes.py` git diff → 테이블/컬럼/FK/트리거/코드값/적재로직 add/modify/drop, 커밋 해시·file:line 근거 → `schema-change-log.md`.

**Phase 2 — 라이브 적용 대조** (change-tracker, 적용·읽기전용): 각 선언 변경을 라이브 information_schema로 실측, **DDL 적용 + 백필 상태 분리** → `live-apply-crosscheck.md`(선언/DDL적용/백필 3열).

**Phase 3 — 우리 산출 영향 매핑** (change-tracker): 각 변경 → 우리 산출 stale 부분 Grep 전수 추적 + 심각도(CRITICAL/MAJOR/MINOR) → `impact-matrix.md` + 갱신 제안 `update-manifest.md`.

**Phase 4 — W1~W6 게이트** (validator, 적대적): W1 베이스라인 정확·W2 변경 분류 완전(커밋 실재)·W3 라이브 적용 대조(DDL≠백필)·W4 영향 매핑 완전·W5 DDL·백필 분리·W6 갱신 라우팅 정합. → `18_schema-change/_gate/<pair>-gate.md`. **NEVER 수정.**

**Phase 5 — 보고 + 갱신 라우팅** (lead): 영향 매트릭스 + 시급 stale + 갱신 제안을 사용자에 에스컬레이션. 실제 산출 갱신은 별도(라우팅 후).

## Pipeline (round-13 correctness-audit — 라이브=교정대상 → 교정 매니페스트)

**[프레임] rounds 1–12는 라이브를 권위로 봤다. round-13은 역전 — 라이브=피고, oracle(webadmin 적재 SQL+`load_master.py`+ERD 문서)+스키마의도+엑셀+도메인=판관.** 생성(correctness-auditor)과 게이트(validator)는 별도 에이전트 = K-게이트 독립성. 둘 다 `dbm-correctness-audit` 스킬 로드. 산출 루트 = `17_correctness/<family>/`.

**Phase 0 — 입력 확인**: oracle 4소스 존재 점검(엑셀 L1 `06_extract/<slug>-l1.csv` · webadmin `sql/`+`tools/load_master.py` · `00_schema/schema-design-intent-map.md` · round-11/12 `15_domain-spec`/`16_mapping-research`). 부재 시 BLOCKED 보고(round-11/12 선행 안내). 라이브 `.env.local` `RAILWAY_DB_*` 읽기전용 확인.

**Phase 1 — 상품 정체 확정 → 적재 로직 재구성** (correctness-auditor): (a) **C-ID 상품 정체**: 각 상품이 무엇인지(범주 일반인쇄/포장재/굿즈·구성 세트/단품·생산방식)를 권위 0(실제 사이트 `huniprinting.com` gstack + 기존 크롤 + print-quote `product-master.md`)로 확정 → `product-identity.md`. 정체가 칼럼 추출의 전제(실증: 인쇄배경지=포장재 세트, round-11 오분류). (b) `tools/load_master.py`(+`sql/`)에서 엑셀 칼럼→t_* 변환 규칙 재구성 → `loadlogic-notes.md`. **models.py는 거울일 뿐(db_comment만 사용).**

**Phase 2 — 정답 추출규칙 + 라이브 diff** (correctness-auditor): 상품별 × 5속성축(size·자재·공정·도수·인쇄옵션) 정답 추출규칙 도출(엑셀+스키마의도+도메인) → `extraction-plan.md`; 라이브 전수 실측 후 field-for-field 대조 → `live-diff.md`; 분류(CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS)+why+how(비파괴)+라우팅 → `correction-manifest.md`.

**Phase 3 — K1~K6 게이트** (validator, 적대적): K1 추출규칙 커버리지 · K2 oracle 인용 실재 · K3 적재로직 근거 · K4 라이브 실측 독립 재현 · K5 비파괴·search-before-mint · K6 오모델 정합. 전부 PASS = GO. → `17_correctness/_gate/<family>-gate.md`. 발견 결함은 correctness-auditor로 라우팅, 조용히 수정 금지. **NEVER COMMIT/DDL/DELETE.**

**Phase 4 — 보고 + 승인 게이트** (lead): 교정 매니페스트 요약(분류 분포) + 적재 로직 결함 + 인간 승인 큐(MIS-LOADED 교정 방향·실 COMMIT은 round-5/10 트랙)를 사용자에 에스컬레이션.

## Pipeline (round-16 price-import-prep — 가격표 다차원 → Phase11 엔진 그릇 + 엑셀 + mermaid)

**[프레임] round-2/4/5는 가격을 round-2 스냅샷 스키마 기준 DB CSV로 매핑·조립했다. round-16은 재정렬 — 그릇=webadmin Phase11 가격엔진(`evaluate_price`)이 먹는 형태, 산출=webadmin 복붙용 작업 엑셀(.xlsx) + 매핑 절차 mermaid.** round-2 산출은 round-14 진단대로 stale(8→10차원·단가/합가·template_prices). 분해 기준=엔진 매칭 규칙. 생성(price-import-builder)과 게이트(validator)는 별도 = P6. 둘 다 `dbm-price-import-prep` 스킬 로드. 산출 루트 = `20_price-import/<sheet>/`. 권위 = `raw/webadmin/.planning/phases/11-price-engine-simulator/11-CONTEXT.md` + 라이브 `t_prc_*`. round-9/10 교훈으로 인라인 한국어 진행 선호.

**Phase 0 — 입력 확인**: 가격표 xlsx(`docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`) · Phase11 `11-CONTEXT.md` · `18_schema-change/impact-diagnosis.md`(stale) · round-2 `01_excel`/`00_schema` 존재 점검. 라이브 `.env.local RAILWAY_DB_*` 읽기전용.

**Phase 1 — 최신 그릇 확정 + 시트 해부** (builder): round-14 stale(8→10차원·`prc_typ_cd`·`use_dims`·`template_prices`) 흡수 + 라이브 information_schema 실측 → 시트 논리블록 분리·복합셀 식별 → `<sheet>-structure.md`.

**Phase 2 — 분해 + 단가/합가 판별** (builder): 매트릭스 언피벗·복합셀→10차원·공식유형(frm_typ)·`prc_typ_cd` 판별(단위 표기 근거·추정 금지)·`use_dims` → `<sheet>-decomposition.md`.

**Phase 3 — 엑셀 그릇 + mermaid** (builder): 테이블별 시트 `.xlsx`(컬럼 1:1·한국어 라벨 병기·복붙용) + 매핑 절차 mermaid(flowchart 시트→그릇→엔진, 선택 sequence) → `<sheet>-import.xlsx`·`<sheet>-mapping-flow.md`.

**Phase 4 — P1~P6 게이트** (validator, 적대적): P1 그릇 정합(라이브 t_prc_* 컬럼 1:1)·P2 stale 차단(prc_typ/proc/opt/use_dims 반영)·P3 분해 무손실(round-trip)·P4 단가/합가 정당(근거)·P5 동시매칭 0·P6 엔진 시뮬레이션(대표 선택+수량 손계산↔기지값). → `20_price-import/_gate/<sheet>-gate.md` GO/NO-GO. NEVER COMMIT.

**Phase 5 — 보고 + 결정** (lead): 그릇 엑셀 + mermaid + 단가/합가 분포 + 미해소 컨펌(모호 분해·합가형 판별)을 사용자에 에스컬레이션. 다음 시트 확대·실 적재(round-5)는 인간 승인.

## Pipeline (round-18 price-engine-verify — 가격엔진 실증검토: 사슬 실측 + 검증용 재계산)

**[프레임] round-2/16/17은 가격을 매핑·그릇·정적정리(공식이 정리·배선됐는가)했다. round-18은 *계산이 맞는가*를 수치로 증명한다. 라이브 `evaluate_price` 엔진은 미구현(가격뷰어 ⑤ "다음 단계 완성 후 활성화"·`pricing.py` 부재·ROADMAP Phase 11 미완·gstack 실증) → 호출할 엔진 없음 → 명세(11-CONTEXT/prcx01) 기반 검증용 재계산이 유일 비침습 경로.** 생성(`dbm-price-engine-verifier`)·게이트(`dbm-validator` PE1~PE6) 분리. 둘 다 `dbm-price-engine-verify` 스킬 로드. 산출 루트 = `26_price-engine-verify/<family>/`. round-9/10 교훈으로 인라인 한국어 진행 선호(재계산 read-only).

**Phase 0 — 입력 확인**: 계산 명세(`raw/webadmin/.planning/phases/11-price-engine-simulator/11-CONTEXT.md`·`docs/prcx01-pricing-model.md`) · 가격표 엑셀(`docs/huni/..._가격표_260527.xlsx`) · round-16 `20_price-import/`·round-17 `21_price-formula-audit/` 존재 점검. 라이브 `.env.local RAILWAY_DB_*`(읽기전용)·`HUNI_ADMIN_*`(가격뷰어 gstack).

**Phase 1 — 가격사슬 완전성 실측** (verifier): 상품군별 각 상품 → 가격소스(템플릿>직접단가>공식>없음)·공식→`formula_components` 배선→`comp_cd`→`component_prices` 단가행·`t_dsc` 수량구간 할인 연결·등급 라이브 실측 + 가격뷰어 `qvSelect` 3원 대조 → `chain-completeness.md`(완결/단절 지점).

**Phase 2 — 검증용 재계산** (verifier): Phase11 명세 재구현 `recompute.py`(우선순위·합산형/단순형·NULL 와일드카드·동시매칭 오류·단가/합가 환산·수량구간·시계열·할인 순차곱·ROUND_HALF_UP) → 대표 선택+수량 케이스 재계산 내역 → `recompute-cases.md`. 사슬 단절분=계산불가(임의 0원 금지).

**Phase 3 — 기대값 대조 + 결함** (verifier): 재계산값 ↔ 가격표 known값/가격뷰어 수치 대조 → `expected-vs-computed.md`(일치/불일치 원인/계산불가) + `defects.md`(미구성·단절·미연결·동시매칭·최소수량·prc_typ 오적재·불일치 + 라우팅).

**Phase 4 — PE1~PE6 게이트** (validator, 적대적): PE1 권위 인용 실재·PE2 사슬 실측 독립 재현(가격뷰어 3원)·PE3 계산 알고리즘 정합·PE4 기대값 대조·PE5 결함 정직성(위장 0·임의 0원 0)·PE6 독립 재계산(대표 1건+ 손계산). → `26_price-engine-verify/_gate/<family>-gate.md` GO/NO-GO. NEVER COMMIT/DDL.

**Phase 5 — 보고 + 결정** (lead): 사슬 완결/단절 분포 + 재계산 일치/불일치/계산불가 + 결함을 사용자에 에스컬레이션. 단절 실 교정(round-5/13)·실제 엔진(Phase 11) 구현·불일치 원인 판정은 인간 승인.

## Pipeline (round-18+ 확장 — **게이트형** 클래스 전수 + 경쟁사 벤치마크 + 정합 정립)

**[프레임] round-18 파일럿(단일 상품)을 상품군 전체로 확장 + 경쟁사 합리성 대조 + 돈-크리티컬 정합 정립.** 권위 = 가격표/상품마스터 엑셀(사용자 directive: 모든 가격 구성요소는 엑셀에 정립). 경쟁사(와우프레스 공개 API·레드프린팅 본인계정) = **합리성 오라클**(정답 아님). 생성≠검증. round-9/10 교훈으로 인라인 한국어 선호.

**[HARD·핵심 정립 — 사용자 directive + 베스트프랙티스] 게이트 순서 = 데이터 정합 → 사슬 → 계산.** 베스트프랙티스(CPQ 표준 data integrity→config→pricing·source-to-target value-level reconciliation·metamorphic 오라클·closed-loop remediation·RTM, `28_price-arbitration/_pipeline-review/bestpractice-research.md`): **구성요소가 엑셀대로 맞게 적재됐는지 먼저 검증하고, 통과한 클래스만 가격계산으로 진입한다.** 틀린 매핑 위 계산은 garbage(엽서 D-2가 실증: 명세 순수매칭 22,849,330원). **[HARD] 계산기(`recompute.py`)가 라이브에 없는 옵션→구성요소 매핑을 코드로 메우는 보정 하드코딩 금지 — 보정이 필요하면 그것이 G-DATA 반려 신호(거짓 GO 방지). corrected 경로는 진단 대조용일 뿐 GO 근거 아님.**

**Phase 1 — 클래스 분류**: 라이브 `t_prd_product_price_formulas` 역인덱스로 15 가격공식 클래스 + 184 가격미구성 분류 → `26_price-engine-verify/_class-map.md`.

**Phase 2 — 선행 게이트 ① G-DATA(의미·적재 정합)** (arbiter `mapping-integrity` + round-13 재사용): 클래스 대표·변형의 구성요소(자재·공정·사이즈·도수·옵션)가 **권위 엑셀대로 라이브에 셀단위 적재**됐는지(완전성·차원 키 정합·옵션→comp 존재·round-13 적재값 정확성[A-2]) 검증. **행 존재≠적재(round-7 D-1)**: 변형 조합별 단가행 존재+값일치까지. NO-GO 클래스는 계산 진입 차단 → arbiter 정립(Phase 6) 직행. → `28_price-arbitration/<class>/mapping-integrity.md`.

**Phase 3 — 선행 게이트 ② G-CHAIN(구조·사슬 배선)** (verifier `chain-completeness`): 가격소스 바인딩·공식→formula_components→price_components→component_prices·할인 연결이 *연결*됐나(구조). → `26_price-engine-verify/<class>/chain-completeness.md`.

**Phase 4 — G-CALC(계산, G-DATA+G-CHAIN PASS 클래스만)** (verifier `recompute.py`): 출력판형 해석·차원 매칭·단가/합가·수량구간·시계열·할인 순차곱. **보정 하드코딩 0**. + **합리성 오라클(metamorphic)**: 수량↑→단가↓ 단조·면적 k배→가격 ≈k배·옵션 추가→총가 비감소 위반 검출. → `26_price-engine-verify/<class>/`{recompute-cases·expected-vs-computed}.

**Phase 5 — 경쟁사 벤치마크** (competitor-benchmark): 같은 옵션 × 와우프레스·레드프린팅 대조. **정답 오라클(엑셀 known=exact)** + **합리성 오라클(경쟁사 plausibility)**. **materiality 임계 PASS/WARN/🔴FAIL**(절대+상대 blended·자릿수/비정상=🔴). → `27_competitor-benchmark/<class>/`{benchmark·absurd-gaps}.

**Phase 6 — 정합 정립 심의** (arbiter, 돈-크리티컬): G-DATA NO-GO + benchmark 🔴 + 오라클 위반의 근본원인·미진 요건 정립 방안(대안·트레이드오프·권고·t_*·트랙·컨펌) → `28_price-arbitration/<class>/`{root-cause·remediation-plan}.

**Phase 7 — 게이트 + 재검증 폐루프** (validator): G-DATA·G-CHAIN·PE(재계산)·B(벤치마크)·A(정립) 독립 게이트 + **요건↔게이트 추적표(RTM, 상품군×가격요소 커버리지 빈칸=미검증)** + **교정 적용 후 게이트 재실행 → 통과해야 RESOLVED(폐루프)** → `_gate/`. NEVER COMMIT/DDL.

**Phase 8 — 보고 + 정립 라우팅** (lead): 클래스별 게이트 통과/차단·🔴 차이·정립 방안·RTM 커버리지를 사용자에 에스컬레이션. 실 교정(round-5/13/ddl-proposer)은 인간 승인(가격=돈, 더 보수적).

## Pipeline (round-19 product-readiness — 상품군 종단 견적가능 완주)

**[프레임] rounds 1–18은 레이어(분석·매핑·적재·CPQ·가격)를 *가로*로 완주했으나 한 상품군도 견적가능까지 *세로*로 닫힌 적이 없다(끝까지 닫힌 상품군=0). round-19는 한 상품군을 종단으로 민다 — 신규 적재 로직을 만들지 않고 기존 레이어 라운드를 호출 순서로 엮는 메타 파이프라인.** round-7(전 상품군 횡단·엔티티 레벨 조망)과 종류가 다르다: round-19=한 상품군·컬럼 레벨·액션(적재 라우팅)·폐루프(견적가능 확인). **[HARD] 견적가능 = ① UI 옵션선택 + ② 선택의 차원환원(자재·공정·사이즈·도수 = 생산정보·MES_ITEM_CD 아님 [[dbmap-goal-ui-quote-mes]]) + ③ 가격계산, 셋 다 성립해야 GO**(하나라도 미달이면 견적가능 아님·거짓 GO 금지). 게이트(S0·S5·S7)=`dbm-readiness-auditor`, 적재(S2~S4)=기존 라운드(생성≠검증). 둘 다 `dbm-product-readiness` 스킬 로드. 산출 루트 `29_readiness/`. round-9/10 교훈으로 인라인 한국어 선호.

**Phase 0 — 상품군 선정**: `29_readiness/_rtm.md` 빈칸에서 다음 닫을 상품군 선정(권장 기초완전 Tier A부터 [[dbmap-tierA-cpq-option-load]]). 기존 산출(`06_extract`·`15_domain-spec` 컬럼사전·`16_mapping-research`·`17_correctness`·`09_load`·`10_configurator`) 입력 점검(재활용하되 권위는 라이브).

**Phase 1 — S0 컬럼 readiness** (auditor 게이트): 그 상품군 엑셀 전 의미컬럼 × 목표 t_* × 라이브 읽기전용 실측 → `<family>/column-readiness.md`(✅적재완료/🟡부분/❌미적재·빈칸0·booklet식). booklet 선례 = `26_price-engine-verify/_binding-overview/booklet-column-readiness.md`.

**Phase 2 — S1 미적재/오적재 식별 + 라우팅** (auditor → round-7/13): ❌/🟡 컬럼을 차단유형+라우팅(교정→round-13·L1→round-5·CPQ→round-6·가격→round-16/18·DDL→ddl-proposer). ✅ 요소는 적재 단계 스킵(중복 적재 금지).

**Phase 3 — S2~S4 적재** (기존 라운드, 인간 승인): L1 기초데이터/차원(round-5)·CPQ 3종 option/template/constraint(round-6)·가격 그릇/사슬(round-16/18). 각 라운드 자체 게이트(G/R/M/K/P/PE + validator). round-19는 라우팅·조율만, 적재본 게이트를 대신하지 않음.

**Phase 4 — S5 견적가능 Q-게이트** (auditor): Q1 컬럼 커버리지(빈칸0)·Q2 기초 완전·Q3 ①UI+②차원환원(option_items polymorphic 해소·트리거 정합)·Q4 ③가격사슬 완결·Q5 견적 시뮬레이션(대표 선택→차원환원 BOM+가격, 보정 하드코딩0)·Q6 정직 갭 → `<family>/quote-gate.md` GO/NO-GO. 셋(①②③) 다 PASS여야 견적가능 GO.

**Phase 5 — S7 RTM 갱신 + 보고** (auditor → lead): 적재 라우팅 후 해당 요소 라이브 재실측(견적가능 폐루프·적재 전 stale 판정 금지) + `_rtm.md`(상품군×견적요소 진척판·견적가능 열 ✅ 개수=진짜 진척) 갱신 + 차단·인간 승인 큐 에스컬레이션. NEVER COMMIT.

## Pipeline (round-21 product-group isomorphism — 동형 효율 + 자율 자기개선)

**실행 모드:** 하이브리드 (Sc 분류·게이트 = 메인/`dbm-readiness-auditor`, S2~S4 적재 = 기존 라운드 서브, Sp 전파 = `dbm-batch-load` 스크립트)

**[프레임] round-18(가격공식 클래스)·19(종단)·20(배치)를 "상품군 동형" 한 축으로 수렴한다.** 모든 상품을 하나씩 보지 않는다 — 같은 상품군은 옵션·가격공식이 동형(계산공식집초안 권위)이므로, 대표 1개를 주문가능 형태로 완전종단시키고 동형 나머지는 자동 전파한다. **토대 = `dbm-batch-load/references/product-group-isomorphism-model.md` (전 단계가 먼저 읽음).**

**Sc — 동형 분류 + 대표 선정** (readiness-auditor): 계산공식집초안 × 옵션구성으로 상품군(동형 클래스, 50개 미만) 분류, 미출시·옵션 미완비 제외. 각 상품군 시트 실측으로 대표(superset — 옵션/구성요소/제약 최대) 선정. 추상 원리 금지(일반화의 오류), 상품군마다 다름(프리미엄엽서=디지털인쇄, 일반현수막=실사).

**S0~S5 — 대표 5레이어 완전종단** (readiness-auditor 게이트 + 기존 라운드 적재): 구성요소(BOM)·옵션(CPQ)·템플릿·제약·가격이 어우러져 **주문가능 형태로 실적재**. 가격검증은 전체 옵션×전체 공식×다양 조합(인쇄비 한정 금지). 적재 산출은 토대 §9 준수 — 코드 3축(시스템 `*_cd`·관리 `*_nm`/tags·고객 disp_nm)·비고 실무진 한국어·명칭 권위 후니 용어·사이즈 공용/전용/판형(impos_yn) 구분 + search-before-mint 중복 금지 + 정규화.

**Sp — 동형 자동 전파** (batch-load): 대표 GO면 동형 나머지를 스크립트 자동 적재 + 집계 전수 검증(예외만 사람).

**[HARD] 자율 자기개선 폐루프.** 각 단계는 사람 판단 없이 **이진 게이트**로 판정한다 — 가격 = 가격표 골든값 수치 대조, 견적가능 = Q1~Q6 라이브 실측, 적재 = 멱등·제약위반0·FK고아0 DRY-RUN, 가시성 = webadmin admin 명칭 노출. NO-GO면 결함을 라우팅·보정하고 재게이트하는 폐루프를 돈다(생성≠검증: `dbm-validator`/`evaluator-active` 독립). 상품군 큐를 자율 반복하며 사람 개입은 **인간 승인 큐(실 COMMIT·도메인 컨펌·권위/골든값 부재)만**으로 모은다 — 매 턴 방향 지시가 아니라 가끔 큐 승인. 같은 결함이 반복되면 토대 모델·에이전트를 갱신(하네스 진화).

## Test scenarios

- **Round-16 flow (price-import-prep)**: "가격표 정리" / "round-16" / "스티커 가격 그릇" / "webadmin 가격 엑셀" → Phase 0 입력 확인 → builder 최신 그릇 확정(round-14 stale 흡수)·다차원 분해·단가/합가 판별·엑셀 그릇·mermaid → validator P1~P6 → lead가 단가/합가 분포·컨펌 에스컬레이션. 인라인 한국어 진행 선호.
- **Round-17 flow (price-formula-audit)**: "가격공식 정리 검증" / "round-17" / "가격관리 가격공식 점검" / "공식명 비고 정리" → Phase 0 입력 확인 → auditor 라이브 스키마 결판(frm_typ_cd)·전수 인벤토리·4축 판정(정리·가독성·배선·뷰어)·실무진 정리표·결함 보드·개선안 → validator F1~F5 독립 게이트 → lead가 가독성 미달·미배선 고아·뷰어 미노출 수 + 개선안 에스컬레이션. round-16 산출 재사용·인라인 한국어 선호. 산출 루트 `21_price-formula-audit/`.
- **Round-18 flow (price-engine-verify)**: "가격엔진 실증" / "가격계산 검증" / "round-18" / "가격공식 매핑 실증" / "아크릴/문구/굿즈 가격 검증" → Phase 0 명세·가격표·round-16/17 확인 → verifier 가격사슬 완전성 실측(소스·배선·단가행·할인·가격뷰어 3원) → Phase11 명세 재구현 `recompute.py`로 대표 케이스 재계산 → 가격표 known값 대조 + 결함 보드 → validator PE1~PE6 독립 게이트(대표 1건 손계산 재현) → lead가 사슬 단절·재계산 불일치·계산불가 + 단절 교정 에스컬레이션. 엔진 미구현 전제(gstack 실증)·읽기전용·인라인 한국어 선호. 산출 루트 `26_price-engine-verify/`.
- **Round-18 single-family / chain-only**: "아크릴 가격사슬만" → 해당 상품군 Phase 1(chain-completeness)까지, 재계산 생략. "재계산만" → Phase 2~3(recompute·대조)만.
- **Round-18+ flow (클래스 전수 + 경쟁사 + 정립)**: "상품군 전체 가격 검증" / "경쟁사 가격 대조" / "가격공식 클래스 분류" / "터무니없는 가격차 점검" / "가격 정합 정립" → Phase 1 15클래스 분류 → Phase 2 클래스별 재계산(verifier) → Phase 3 경쟁사 벤치마크(benchmark·🔴 absurd-gap) → Phase 4 정합 정립 심의(arbiter·돈-크리티컬) → Phase 5 PE+B+A 게이트(validator) → lead가 🔴·정립 방안 에스컬레이션. 권위=엑셀·경쟁사=오라클·인라인 한국어.
- **Round-19 flow (product-readiness)**: "종단 파이프라인" / "상품군 종단 완주" / "round-19" / "엽서 견적가능까지" → Phase 0 RTM 상품군 선정(Tier A 권장) → S0 컬럼 readiness(booklet식·빈칸0) → S1 미적재 식별·라우팅(✅ 스킵) → S2~S4 적재(기존 라운드·인간 승인) → S5 견적가능 Q1~Q6(①UI+②차원환원+③가격 셋 다) → S7 RTM 갱신·폐루프. 인라인 한국어·게이트는 읽기전용.
- **Round-19 readiness-only**: "엽서 컬럼 readiness만" / "견적가능 점검만" → S0(column-readiness.md) + S5 게이트까지, 적재 라우팅(S2~S4) 생략. **rtm-only**: "진척판만" → `_rtm.md`만 갱신.
- **Round-18+ benchmark-only**: "엽서 경쟁사 가격만 대조" → 해당 클래스 Phase 3(benchmark)만(재계산 입력은 기존 26_/). **arbitration-only**: "디지털A 정합 정립만" → Phase 4(arbiter)만.
- **Round-18+ absurd-gap error**: 우리값이 경쟁사 대비 자릿수 차이(예: round-18 D-2 과대합산 22,849,330 vs 44,000) → benchmark가 🔴 판정 + 원인가설 → arbiter가 근본원인(옵션→구성요소 미매핑) 규명 + 정립 방안 → round-5/ddl-proposer 라우팅(인간 승인).
- **Round-16 single-sheet / decompose-only**: "스티커만 분해" → 해당 시트 Phase 1~2(structure·decomposition)까지, 엑셀·mermaid 생략. "엑셀 그릇만" → Phase 3만.
- **Normal flow (round-1)**: "DB 구조 파악하고 구간할인 매핑해줘" → Phase 0 initial → 2 parallel analysts → designer → validator GO → report with decision gate.
- **Partial re-run**: "문구 구간할인 매핑만 다시" → Phase 0 partial → excel-analyst (문구 block) + mapping-designer (문구 table) + validator (문구 only); other tables untouched.
- **Round-2 flow (price)**: "가격 매핑해줘" / "round-2 진행" → round-2 pipeline → 2a DDL extraction + 2b excel analysis (parallel) → Phase 3 fit-gap GATE → pilot 디지털인쇄/엽서 mapping → validator recompute check GO → report fit-gap verdict + widen decision.
- **Fit-gap only**: "가격 스키마 적정성만 확인" / "가격 fit-gap만" → run Phases 1–3 (DDL + excel + fit-gap), stop before pilot mapping; deliver `schema-fitgap-price.md` only.
- **Round-3 flow (audit)**: "DB 매핑 검증" / "정합 재검증" → Phase 0 방법론/토대 확인 → (미설계면 1단계 방법설계 A~G) → Phase 2 L1 충실추출(15시트, 9게이트 PASS) → Phase 3 마스터 정합 → Phase 4 L2 속성별 정합(숨김/미출시=비활성) → Phase 5 대시보드 + 정정 우선순위.
- **Round-3 L1 only**: "엑셀 충실추출만" / "전 상품 토대만" → Phase 1–2 (L1 추출 + 9게이트 검증), stop before L2; deliver `06_extract/product-info-foundation.md` only.
- **Round-4 flow (load-readiness)**: "적재 준비 진행" / "round-4" / "상품마스터 적재 조립" → Phase 0 GO 입력 확인 → load-builder가 `09_load/` 번들 조립(t_* 화이트리스트·FK 위상정렬·코드행 선적재·차단/GAP 분리) → validator G1~G9 + DRY-RUN → `load-readiness-gate.md` GO/NO-GO → lead가 코드행 선적재·GAP·실제 INSERT 승인을 사용자에 에스컬레이션.
- **Round-4 gate-only**: "적재 게이트 다시" / "G1 G9 게이트 다시" → 기존 `09_load/` 번들 재조립 없이 validator만 G1~G9 재실행.
- **Round-4 partial rebuild**: "가격표 적재 조립만 다시" → load-builder가 `t_prc_*` 단계만 재조립, validator가 해당 단계만 재게이트; 나머지 적재 단계 보존.
- **Round-4 whitelist error**: 매핑이 비-`t_`(Django) 테이블을 가리킴 → load-builder가 G1(화이트리스트)에서 정지·플래그, 번들 미산출.
- **Round-5 flow (load-execution)**: "적재 스크립트 작성" / "round-5" / "적재 SQL 만들어줘" → Phase 0 round-4 GO 확인 → Phase 2 병렬(load-builder 멱등 SQL+로더 `_exec*/` · ddl-proposer GAP DDL 제안 `11_ddl_proposals/`) → Phase 3 validator G1~G9 carry-forward + R1~R6 + (lead 승인 시)라이브 DRY-RUN → `load-execution-gate.md` GO/NO-GO → lead가 라이브 DRY-RUN·COMMIT·DDL 적용·코드행 승인을 사용자에 에스컬레이션.
- **Round-5 SQL-only**: "멱등 적재 SQL만" → load-builder가 `_exec*/` SQL+로더만, validator R1~R3 로컬 검사; DDL 제안·라이브 DRY-RUN 생략.
- **Round-5 DDL-proposal-only**: "신규 엔티티 제안만" / "스키마 부족분 제안" → ddl-proposer가 `11_ddl_proposals/`만, validator R4(search-before-mint·정규화·충돌); 적재 SQL 무변경.
- **Round-5 gate-only**: "적재 실행 게이트 다시" / "R1 R6 다시" → validator가 기존 `_exec*/` + `11_ddl_proposals/`에 R1~R6 재실행, 재빌드 없음.
- **Round-5 live DRY-RUN**: "라이브 DRY-RUN 해줘" → lead 승인 후에만 validator가 `BEGIN…ROLLBACK` 2회(R1 멱등성/R5 제약위반), 위반 보고, NEVER COMMIT.
- **Round-5 idempotency error**: 어떤 INSERT에 `ON CONFLICT` 누락 → validator R1 FAIL, load-builder로 라우팅; DDL 제안이 기존 테이블 중복 → R4 FAIL(search-before-mint), ddl-proposer로 라우팅.
- **Round-6 flow (CPQ option-layer)**: "CPQ 옵션 매핑" / "옵션 레이어 매핑" / "round-6" → Phase 0 입력 확인 → Phase 2 option-mapper 마스터 지도(13시트 attribute→entity) → Phase 3 상품군 파일럿(option_groups/options/option_items·constraints·templates) → Phase 4 validator 경계면 교차(트리거 reference resolution) → `cpq-option-validation.md` GO/NO-GO → lead가 우선 상품군·attribute 타깃·GAP을 사용자에 에스컬레이션.
- **Round-6 map-only**: "속성 엔티티 매핑 지도만" → option-mapper가 `attribute-entity-map.md`만(13시트 속성→엔티티 verdict), 파일럿 생략.
- **Round-6 pilot family**: "굿즈 옵션 레이어만" / "배너 CPQ 파일럿" → option-mapper가 해당 상품군 option-layer + load CSV, validator 해당 상품군만 검증.
- **Round-6 trigger-ref error**: option_item이 도수를 `clr_cd`로 참조(올바른 키=opt_id) 또는 라이브 미적재 차원행 참조 → validator가 trigger-reference resolution에서 FAIL/BLOCKED, option-mapper로 라우팅; 차원행 부재면 L1 선적재 BLOCKED로 분리.
- **Round-10 flow (change-tracking)**: "변경 추적" / "신규 버전 적용" / "상품마스터 260610 변경분 적용" → Phase 0 두 버전 확인 → Phase 2 양 버전 L1 추출 + 키 기반 3-way diff → Phase 3 셀→t_* 영향 매핑 + 라이브 정합 → Phase 4 change-tracker가 변경 매니페스트 + 멱등 델타 UPSERT → Phase 5 validator V1~V8 + DRY-RUN → `change-tracking-gate.md` GO/NO-GO → lead가 REMOVED·rename·코드행·COMMIT 승인을 사용자에 에스컬레이션.
- **Round-10 diff-only**: "버전 비교만" / "무엇이 바뀌었는지만" → change-tracker가 `diff/` + `change-manifest.*`만(추적 감사본), 델타 SQL 생략.
- **Round-10 REMOVED escalation**: 아크릴 −24행 → change-tracker가 키 매칭으로 REMOVED 분류 + rename 의심쌍 검사 → 논리삭제 제안(hard-delete 금지)으로 분리, lead가 사용자 판정 요청.
- **Round-10 key-undecidable**: 시트 키 후보가 행을 유일 식별 못함(중복/공백) → change-tracker가 그 시트를 diff BLOCKED 표기(불신뢰 diff 미산출), 후보 키 보고.
- **Round-10 gate-only**: "변경 게이트 다시" / "V1 V8 다시" → validator가 기존 `_delta/` + `change-manifest.*`에 V1~V8 재실행, 재diff 없음.
- **Round-12 flow (mapping-research)**: "매핑 확정 리서치" / "round-12" / "정확한 매핑데이터 만들어줘" → Phase 0 입력 4소스 존재 확인(round-11 시트 산출·실무진 확정·intent-map·loadspec) → 파일럿 시트 P1 내부 결합 → P2 외부 갭헌팅(경쟁사·CIP4·표준, Sources 필수) → P3 라이브 실측 대조 → `16_mapping-research/<family>/mapping-final.md` → validator M1~M6 → lead가 CONFLICT·갭 처분·round-4/5 인계를 사용자에 에스컬레이션 → GO 후 시트 확대(병렬 팬아웃 가능).
- **Round-12 single-sheet**: "스티커 매핑 확정만" → 해당 시트만 P1~P4 + M게이트, 타 시트 산출 보존.
- **Round-12 gap-hunt-only**: "갭헌팅만" / "놓친 정보 리서치만" → P2만 수행해 research-gap-board 산출, mapping-final 미작성.
- **Round-12 missing-input error**: 입력 4소스 중 하나라도 부재(예: 해당 시트 round-11 미완) → Phase 0에서 BLOCKED 보고, round-11 선행을 안내(추측 매핑 금지).
- **Round-13 flow (correctness-audit)**: "라이브 정합 교정" / "round-13" / "적재 정확성 점검" → Phase 0 oracle 4소스 확인 → Phase 1 적재 로직 재구성(`load_master.py`) → Phase 2 상품별 추출규칙+라이브 diff+교정 매니페스트 → Phase 3 validator K1~K6 → `<family>-gate.md` GO/NO-GO → lead가 MIS-LOADED 교정 방향·실 교정(round-5/10 인계)을 사용자에 에스컬레이션.
- **Round-13 single-sheet / partial**: "디지털인쇄 교정만" / "스티커 자재만 교정 점검" → 해당 시트(또는 속성)만 Phase 1~3, 타 산출 보존.
- **Round-13 extraction-plan-only**: "추출 계획만" / "어떻게 뽑을지 계획만" → Phase 1~2의 extraction-plan까지, 라이브 diff·교정 매니페스트 생략.
- **Round-13 mis-load found**: 라이브가 코팅을 자재로 적재(Q9=공정) → correctness-auditor가 MIS-LOADED 분류 + load_master.py 원인 재구성 + 기존 공정행 재연결 제안(search-before-mint), validator K3/K6 확인, 실 교정은 round-5/10 인계(인간 승인).
- **Round-13 missing-input error**: oracle 4소스 중 부재(해당 시트 round-11/12 미완 등) → Phase 0 BLOCKED 보고, 선행 안내(추측 교정 금지).
- **Round-14 flow (schema-change-tracking)**: "webadmin 변경 추적" / "스키마 변경이력" / "round-14" / "매핑 stale 점검" → Phase 0 베이스라인 식별 → Phase 1 git diff 스키마 변경 분류 → Phase 2 라이브 적용 대조(DDL/백필 분리) → Phase 3 우리 산출 영향 매트릭스 → validator W1~W6 → lead가 stale 갱신·백필 미완을 사용자에 에스컬레이션.
- **Round-14 diff-only**: "무엇이 바뀌었는지만" / "스키마 변경이력만" → change-tracker가 `schema-change-log.md`+`live-apply-crosscheck.md`만, 영향 매핑 생략.
- **Round-14 impact-only**: "우리 산출 어디가 stale인지만" → 기존 schema-change-log 기반 `impact-matrix.md`만(변경 재분류 없이 영향 추적).
- **Round-14 baseline-undecidable**: 베이스라인 커밋이 우리 산출 인용과 모호 → change-tracker가 후보 보고(불신뢰 diff 미산출).
- **Round-14 DDL≠backfill**: 신규 컬럼 존재하나 0행 → Phase 2가 "선언만·미적용(백필 갭)"으로 분리 표기(W5), "적용 완료" 오판 금지.
- **Error flow**: DB unreachable → Phase 1 blocker report, ask user to verify host/port; no agents spawned.

## CLAUDE.md pointer

This harness is registered in CLAUDE.md under "하네스: Huni-DBMap". On any matching request, this skill is the entry point.
