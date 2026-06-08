# 라이브 롤백전용 DRY-RUN 로그 — 일반현수막(PRD_000138) round-5 (v2 옵션 자재+공정 BUNDLE)

| 항목 | 값 |
|------|----|
| 실행 | dbm-load-builder (자기점검용 DRY-RUN — 최종 게이트는 dbm-validator) |
| 일자 | 2026-06-08 (**v2 옵션부 갱신**: §2A 자재+공정 BUNDLE 재실증 추가. §1 가격·§2 siz 불변) |
| 모드 | **롤백전용**(`BEGIN … apply … ROLLBACK`). **COMMIT 0 — 아무것도 영구 적재 안 됨** |
| 접속 | `.env.local` RAILWAY_DB_*(read-only/rollback). 비밀번호 stdout/_workspace 미기록 |
| 권위 | round-5 R1/R2/R3/R5 게이트(`dbm-load-execution` 스킬 §3) |

> [HARD] 본 로그는 빌더 자기점검 증거다. **자기승인 아님** — R1~R6 최종 판정은 dbm-validator 가 독립 수행한다(R6 생성·검증 분리).

---

## 1. 주 트랜잭션 — 2-pass 멱등 DRY-RUN

단일 롤백 트랜잭션 안에서 적재(PASS1)→재적재(PASS2)→delta 측정→ROLLBACK.

### 1.1 BASELINE (적재 전 라이브)

| 테이블 | 적재 전 행수 | 비고 |
|---|:--:|---|
| t_prc_price_formulas (PRF_BANNER_NORMAL) | 0 | 신규 |
| t_prc_price_components (COMP_BANNER_%) | 0 | 신규 10 예정 |
| t_prc_formula_components (PRF_BANNER_NORMAL) | 0 | 신규 11 예정 |
| t_prc_component_prices (COMP_POSTER_BANNER_NORMAL area) | **3** | round-2 sparse 선존재(SIZ_000320/323/403) |
| t_prd_product_price_formulas (PRD_000138/PRF_BANNER_NORMAL) | 0 | 신규(기존은 PRF_POSTER_FIXED) |
| t_prd_product_option_groups (PRD_000138) | 0 | L2 최초 적재 사례(LV-3) |
| t_prd_product_options (PRD_000138) | 0 | — |
| t_prd_product_option_items (PRD_000138) | 0 | — |

### 1.2 PASS 1 후 행수 (적재 결과)

| 테이블 | PASS1 후 | 신규 적재 |
|---|:--:|:--:|
| formulas | 1 | +1 |
| components (COMP_BANNER_%) | 10 | +10 |
| wiring | 11 | +11 |
| comp_prices_area (COMP_POSTER_BANNER_NORMAL) | 3 | **+0** (3 선존재 → 변형 C 가 중복 억제, 멱등 정합) |
| comp_prices_banner_opt (COMP_BANNER_%) | 10 | +10 |
| prod_formula | 1 | +1 |
| opt_groups | 2 | +2 |
| options | 11 | +11 |
| opt_items | 9 | +9 |

> area 3행은 round-2 가 이미 같은 값으로 적재 → 변형 C(WHERE NOT EXISTS)가 정확히 0행 추가(멱등). 신규 순삽입 = 1+10+11+10+1+2+11+9 = **55**, area 0 = 합 55. (INSERTABLE 정의 58 중 area 3 은 선존재라 순신규 55 — 정합.)

### 1.3 PASS 2 (동일 적재 재실행) — R1 DELTA

| d_formulas | d_components | d_wiring | d_comp_prices | d_prod_formula | d_opt_groups | d_options | d_opt_items |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **0** | **0** | **0** | **0** | **0** | **0** | **0** | **0** |

**→ R1 PASS: 2회차 행 변경 0(8테이블 전건). 멱등 입증.**

### 1.4 setval 가드

`setval(...comp_price_id_seq, 4981, true)` — IDENTITY 시퀀스 MAX 동기화(2회 모두 4981, 멱등). comp_price_id 명시 미사용이라 stale 충돌 없음.

### 1.5 ROLLBACK 후 검증

| 테이블 | 롤백 후 | 판정 |
|---|:--:|:--:|
| t_prc_price_formulas (PRF_BANNER_NORMAL) | 0 | **커밋 0 — 영구 적재 없음** |
| t_prd_product_option_groups (PRD_000138) | 0 | **커밋 0** |

exit code = **0** (전 .sql 파싱·실행 0오류).

---

## 2. BLOCKED 활성화 — siz 의존 실증 + 멱등

### 2.1 TEST 1 — siz 등록 없이 area cell 적재 → FK 위반(EXPECTED)

```
ERROR: insert or update on table "t_prc_component_prices"
       violates foreign key constraint "fk_prc_comp_prices_siz_cd"
DETAIL: Key (siz_cd)=(SIZ_000554) is not present in table "t_siz_sizes".
```
**→ 77 area cell 이 siz 미등록 의존임을 입증.** 주 트랜잭션 분리(BLOCKED) 정당.

### 2.2 TEST 2 — B01(siz 77)→B02(area 77) 순서 적재 → 통과·멱등

| 측정 | 값 |
|---|:--:|
| new_siz (SIZ_000538~618) | 77 |
| banner_area_total (COMP_POSTER_BANNER_NORMAL) | 80 (3 기존 + 77 신규) |
| R1 재적재 delta (d_siz / d_cp) | 0 / 0 |
| 롤백 후 new_siz | 0 (커밋 0) |

**→ siz 등록(인간 승인) 후 면적매트릭스 80셀 완결. BLOCKED 경로도 멱등·롤백 안전.**

---

## 2A. [v2] 자재+공정 BUNDLE — 옵션부 재실증 (라이브 DRY-RUN)

### 2A.1 DRY-RUN A — 주 트랜잭션 옵션부(공정 seq 9) 2-pass 멱등

| 테이블 | PASS1 후 | R1 delta(PASS2-1) | 판정 |
|---|:--:|:--:|:--:|
| option_groups | 2 | 0 | 멱등 |
| options | 11 | 0 | 멱등 |
| option_items(공정 seq .04) | 9 | 0 | 멱등 |

item_seq 분포 검증: 타공4/6/8 = **item_seq 1**(bare-hole, 자재 seq 없음) · 부착/봉제 = item_seq 2 · 각목+끈 부착 = item_seq 3. ref_dim_cd 전건 `OPT_REF_DIM.04`(공정). **→ v2 공정 seq 9행 INSERTABLE 통과·멱등.**

### 2A.2 DRY-RUN B1 — 자재 seq, 자재 링크 없이 → 트리거 REJECT(EXPECTED)

```
ERROR: opt_item ref 무결성 위반: 자재 mat_cd=MAT_000070/usage_cd=USAGE.07 가 상품 PRD_000138에 없음 (ref_dim_cd=OPT_REF_DIM.03)
```
**→ 자재 seq 가 PRD_000138 자재 링크 부재로 BLOCKED 임을 입증**(발명 아님·트리거 실재). 주 트랜잭션 분리 정당.

### 2A.3 DRY-RUN B2/D2 — 자재 링크(B03b) → 자재 seq(B04) → BUNDLE 성립·멱등

| 측정 | 값 |
|---|:--:|
| 자재 링크 live (MAT_000069 양면테입·MAT_000070 끈) | 2 |
| 자재 seq item live (.03) | 4 |
| R1 재적재 delta (d_links / d_items) | 0 / 0 |
| 롤백 후 링크 | 0 (커밋 0) |

### 2A.4 DRY-RUN C — FULL BUNDLE (공정 seq 08 + 자재 seq B04 동시) 실증

| opt_cd | 자재 seq(.03) | 공정 seq(.04) | BUNDLE |
|---|---|---|:--:|
| OP-CHUGA-STRING4(끈) | seq1 MAT_000070 | seq2 PROC_000081 | ✅ 자재+공정 |
| OP-GAGONG-YANGMYEONTAPE(양면테입) | seq1 MAT_000069 | seq2 PROC_000081 | ✅ |
| OP-CHUGA-GAKMOK-LE900(각목+끈) | seq2 MAT_000070(끈) | seq3 PROC_000081 | △ seq1 각목=mint BLOCKED |

ref_dim 합계: `.03`(자재) 4 + `.04`(공정) 9 = 13. **→ v2 자재+공정 BUNDLE 모델이 실 행으로 성립**(끈/양면테입은 자재+공정 둘 다, 각목+끈은 끈 자재+부착 공정 성립·각목 자재만 mint 대기). 롤백 → 0 커밋.

> **[v2 빌더 자체 발견·해소]** B04 자재 seq item 은 FK `fk_prd_opt_items_opt` → t_prd_product_options 필요 → 옵션헤더(06/07) 선행. `apply_blocked_options.sql` 단독 실행이 옵션헤더 없이 FK 위반함을 자체 DRY-RUN 으로 적발 → 06/07 멱등 선포함으로 해소(운영 시 주 적재 후 실행이라 no-op). R6 생성·검증 분리 정신으로 빌더 자체 점검에서 실결함 1건 발견·수정.

---

## 3. 게이트 자기점검 요약 (최종 판정은 validator)

| 게이트 | 결과 | 증거 |
|---|:--:|---|
| **R1 멱등성** | PASS | §1.3 2-pass delta=0(8테이블) · §2.2 area BLOCKED delta=0 · **§2A.1/2A.3 [v2] 옵션·자재 BUNDLE delta=0** |
| **R2 원자성** | PASS | 단일 BEGIN…ROLLBACK, 중간 COMMIT 0, ON_ERROR_STOP on |
| **R3 실행성** | PASS | 전 .sql 파싱·실행 exit 0, 0 syntax error. 재생성 byte-identical(재현성) |
| **R5 라이브 DRY-RUN** | PASS | 제약위반 0. 공정 seq 9행 트리거 통과 · **[v2] 자재 seq BLOCKED REJECT(링크 부재)·BUNDLE 성립(링크 후) 실증**. BLOCKED FK/트리거 위반은 EXPECTED(분리 정당) |
| COMMIT 금지 | 준수 | 롤백 후 라이브 banner 행 0 |

> R4(DDL 정합)·R6(독립 검증)는 validator 소관. R4 에는 **① 자연키 UNIQUE NULLS DISTINCT → ON CONFLICT 불가(변형 C)** · **② [v2] 자재 mint 4건**(큐방·각목LE/GT·봉제사, MAT_TYPE.07·search-before-mint 재증명) surface.
