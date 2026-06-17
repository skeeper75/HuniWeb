# 실사 동형 가격구성요소 결합 — 실행본 매니페스트 (round-23 · _exec_isomorph)

> **생성** 2026-06-18 · dbm-load-builder. **돈-크리티컬·라이브 COMMIT 예정(인간 승인 대기).**
> 조립자=본 산출. **자기 GO 아님** — 검증/GO·골든 재현 비준은 dbm-validator R1~R6.
> **권위:** `silsa-isomorph-merge-design.md`(byte-identical 단가매트릭스 재입증)·`grouping-model-design.md`(통합=use_yn=N+배선축소+단가행보존·DELETE 금지).

## 0. 산출 파일
| 파일 | 역할 |
|------|------|
| `gen_load_sql.py` | 생성기(설계→멱등 SQL·재현성 R3/G8·손편집 금지) |
| `apply.sql` | 단일 트랜잭션(BEGIN…)·UPDATE 19행·로더가 COMMIT/ROLLBACK 주입 |
| `dryrun.sql` | 롤백전용(BEGIN…ROLLBACK)·before/after/골든/고아·중복·동시매칭/단가행보존/2-pass 멱등 |
| `apply.sh` | psql 로더(기본 dryrun·dryrun-full·commit[인간승인])·비밀값 미출력 |
| `backup_undo.sql` | 현재값 백업 SELECT + undo UPDATE(배선·use_yn 결정적 원복·comp_nm/note는 백업값) |
| `apply.provenance.csv` | 행별 출처(table·op·target·source) 19행 |

## 1. 라이브 변경 총합 (설계 §6 확정 = 실행본 일치)
- **UPDATE 19행 · INSERT 0 · DELETE 0 · component_prices(단가행) 무변경.**

| # | 테이블 | 작업 | 행수 | 멱등키/가드 |
|---|--------|------|:--:|------|
| STEP1 | t_prc_formula_components | UPDATE comp_cd→정본 A (LEATHER_AP/MESH/TYVEK disp_seq=1) | 3 | (frm_cd,comp_cd=레거시,disp_seq=1) + NOT EXISTS(정본행) |
| STEP2 | t_prc_formula_components | UPDATE comp_cd→정본 B (ADH_WP/ARTFABRIC/WATERPROOF disp_seq=1) | 3 | 동일 |
| STEP3 | t_prc_price_components | UPDATE use_yn='N' (레거시 6) | 6 | comp_cd + use_yn IS DISTINCT FROM 'N' |
| STEP4 | t_prc_price_components | UPDATE comp_nm·note (정본 2) | 2 | comp_cd + (nm/note IS DISTINCT FROM 목표) |
| STEP5 | t_prc_price_components | UPDATE comp_nm·note (단독 5 가독성) | 5 | 동일 |
| — | t_prc_component_prices | **무변경** | 0 | (단가행 보존·DELETE/INSERT 0) |
| — | t_prd_product_price_formulas | **무변경** | 0 | (상품 바인딩 보존) |

## 2. 실행 순서 (FK 위상)
배선 재지정(formula_components)은 정본 comp가 use_yn=Y인 동안 수행 → use_yn=N(STEP3)을 배선(STEP1/2) **뒤**에 둘 필요는 없으나, 본 SQL은 STEP1/2(배선) → STEP3(레거시 비활성)로 자연 정렬. 정본 comp는 결합 전부터 존재·use_yn=Y이므로 고아 없음. 단일 트랜잭션이라 순서 무관하게 원자 적용.
1. STEP1 배선 A 3 → 2. STEP2 배선 B 3 → 3. STEP3 use_yn=N 6 → 4. STEP4 정본 nm/note 2 → 5. STEP5 단독 nm/note 5.

## 3. 멱등키 명시
- **formula_components(PK=frm_cd,comp_cd):** 배선 변경은 PK 일부(comp_cd) 변경 → `WHERE comp_cd=레거시 AND disp_seq=1 AND NOT EXISTS(frm_cd 정본행)`. 이미 정본이면 매칭 0행=no-op. 정본행 사전 부재(1:1 배선)로 PK 충돌 없음.
- **price_components(PK=comp_cd):** use_yn/comp_nm/note는 목표값 UPDATE + `IS DISTINCT FROM` 가드 → 이미 목표값이면 0행.
- **2-pass 실증:** DRY-RUN 2차 APPLY 전건 `UPDATE 0` (delta 0).

## 4. 골든 (DRY-RUN 실측)
| 그룹 | 정본 | 600×1800 단가 | 결합 전 레거시 동일? |
|------|------|--------------:|------|
| A | COMP_POSTER_CANVAS_FABRIC | 37,800 | LEATHER/MESH/TYVEK 모두 37,800 ✓ |
| B | COMP_POSTER_ARTPRINT_PHOTO | 21,600 | ADH_WP/ARTFABRIC/WATERPROOF 모두 21,600 ✓ |

→ 배선 정본 재지정 후 동일 단가 룩업 = **각 상품 가격 불변**(설계 §1.3 셀 diff 0 + DRY-RUN 골든 일치).

## 5. 한글 소재명 근거 (Q-IM1 해소 — 라이브 대조 확정)
약식 임의명 금지. 라이브 `t_prc_price_formulas.frm_nm` / `t_prd_products.prd_nm` 대조.

| comp | 확정 한글명 | 출처 | 비고(설계 약식명→정정) |
|------|------------|------|------|
| CANVAS_FABRIC | 캔버스패브릭포스터 | PRF_POSTER_CANVAS frm_nm | (캔버스천→정식) |
| LEATHER_ARTPRINT | 레더아트프린트 | PRD_000126 prd_nm | (레더아트→정식) |
| MESH_PRINT | 메쉬프린트 | PRD_000128 prd_nm | 일치 |
| TYVEK_PRINT | 타이벡프린트 | PRD_000127 prd_nm | 일치 |
| ARTPRINT_PHOTO | 아트프린트포스터 | PRF_POSTER_ARTPRINT frm_nm | (아트프린트포토→정식) |
| ADH_WATERPROOF_PVC | 접착방수포스터 | PRF_POSTER_ADH_WP frm_nm | (방수PVC점착→정식) |
| ARTFABRIC_GRAPHIC | 아트패브릭포스터 | PRF_POSTER_ARTFABRIC frm_nm | (아트패브릭그래픽→정식) |
| WATERPROOF_PET | 방수포스터 | PRF_POSTER_WATERPROOF frm_nm | (방수PET→정식) |
| ARTPAPER_MATTE | 아트페이퍼포스터 | PRF_POSTER_ARTPAPER frm_nm·PRD_000119 | **★설계 "아트지무광"→라이브=아트페이퍼포스터** |
| BANNER_MESH | 메쉬현수막 | PRF_POSTER_BANNER_M·PRD_000139 | **★설계 "메쉬배너"→라이브=메쉬현수막** |
| ADH_CLEAR_PVC | 접착투명포스터 | PRF_POSTER_ADH_CLEAR frm_nm·PRD_000122 | **★설계 "투명점착PVC"→라이브=접착투명포스터** |
| LINEN_FABRIC | 린넨패브릭포스터 | PRF_POSTER_LINEN frm_nm·PRD_000124 | (린넨페브릭→정식) |
| BANNER_NORMAL | 일반현수막 | PRF_POSTER_BANNER_N·PRD_000138 | **★설계 "일반배너"→라이브=일반현수막** |

> ★ 단독 4종 한글명을 설계 약식명에서 라이브 정식명으로 정정(임의 표기 금지). 근거 라이브 SELECT 코멘트로 SQL/provenance에 보존.

## 6. R1~R6 자가점검 표 (조립자 자가점검·자기 GO 금지 — 비준=dbm-validator)
| Gate | 항목 | 자가점검 | 근거 |
|------|------|:--:|------|
| R1 | 멱등성 | OK(점검) | DRY-RUN 2-pass: 2차 UPDATE 전건 0행. UPDATE 가드(IS DISTINCT FROM·NOT EXISTS) |
| R2 | 원자성 | OK(점검) | apply.sql 단일 BEGIN…·중간 COMMIT 0·로더 `-1`+ON_ERROR_STOP·테이블파일 분리 없음(단일) |
| R3 | 실행성 | OK(점검) | dryrun-full 라이브 실행 0 syntax error·19 UPDATE 정상·로더 .env.local 접속 |
| R4 | DDL 제안 | N/A | DDL 0(결합=UPDATE만·신규 엔티티 없음·단가행 보존). search-before-mint 무관 |
| R5 | 라이브 DRY-RUN | OK(점검) | BEGIN…ROLLBACK·COMMIT 0·제약위반 0·고아0·중복배선0·동시매칭0·단가행684 보존·POST-ROLLBACK 원복 |
| R6 | 독립검증 | 대기 | 조립자≠검증자. dbm-validator 비준 필요(자기 GO 금지) |

## 7. 인간 승인 대기 (escalation)
- **실 COMMIT**: `apply.sh commit` — 인간 승인 후만. 본 트랙은 DRY-RUN까지.
- **Q-IM2(정보)**: 정본 comp_nm 4소재 나열형 채택(사용자 형식 예시 준수). 길이 우려 시 `(캔버스패브릭포스터 외 3종)` 대안 가능 — 현재는 나열형.
- **Q-IM3(정보)**: PRF_POSTER_FIXED 상품 바인딩 없음(범용/예비)·결합과 무관(ARTPRINT_PHOTO 정본이라 배선 보존). 별도 정리 트랙.
