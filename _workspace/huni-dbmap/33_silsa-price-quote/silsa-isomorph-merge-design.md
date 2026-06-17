# 실사(포스터/사인) 동형 가격구성요소 결합 설계 — round-23

> **작성** 2026-06-18 · dbm-price-arbiter. **돈-크리티컬·라이브 COMMIT 예정.**
> 설계+결합 매니페스트까지(read-only SELECT만, DB 쓰기 0). 실 SQL=dbm-load-builder · 검증/GO=dbm-validator.
> **권위:** 가격표(byte-identical 단가매트릭스)·통합 모델 `grouping-model-design.md`·메모리 [[dbmap-price-component-grouping]].
> **HARD 전제:** 단가가 다른데 결합하면 가격 오류 → **동형(byte-identical) 아닌 것 결합 절대 금지.** 단가행 DELETE 절대 금지.

---

## 0. 핵심 결정 요약

1. **결합 대상 = 본체 면적매트릭스 13 comp 중 동형 클러스터 2그룹(각 4 comp)뿐.** 단독 5 comp는 결합 금지(명명 가독성만 정비).
2. **결합 = comp 레벨만.** PRF 공식·상품 바인딩 무손상. 레거시 PRF의 본체 disp_seq=1 comp_cd만 정본으로 UPDATE → 정본 단가표(동값) 공유. 레거시 comp `use_yn='N'`. **단가행 재적재 0·DELETE 0.**
3. **정본:** 그룹 A=`COMP_POSTER_CANVAS_FABRIC`, 그룹 B=`COMP_POSTER_ARTPRINT_PHOTO`(이미 PRF_POSTER_FIXED 범용 배선 보유 → 정본이면 FIXED 자연 보존). **사용자 권고 그대로 타당(라이브 근거로 확정).**
4. **comp_nm·note 가독성 정비:** 코드 노출 폐기 → 한글 소재군명 + note에 결합내역·가격축·골든값·정본/레거시 명시.

---

## 1. 동형 클러스터 재검증 (라이브 md5 재실행)

**범위 확정:** `use_dims = '["siz_width","siz_height"]'` 정확 일치 comp = **정확히 13개**(라이브 실측). CANVAS_HANGING(use_dims에 min_qty 포함, 3행)은 대상 외 — 올바르게 제외됨.

### 1.1 전컬럼 byte-identical md5 (siz_width·siz_height·unit_price·min_qty·siz_cd·clr_cd·mat_cd·proc_cd·opt_cd·print_opt_cd·dim_vals·bdl_qty·coat_side_cnt·plt_siz_cd·apply_ymd 전부 포함, ORDER 정렬)

| 클러스터 | full_md5 | 행수 | comp 수 | comp 목록 |
|---------|----------|:--:|:--:|---------|
| **그룹 A** | `21f959568ce7cab1991c61d9001663fa` | 52 | 4 | CANVAS_FABRIC, LEATHER_ARTPRINT, MESH_PRINT, TYVEK_PRINT |
| **그룹 B** | `768633eca8add01493cfacf763d993b8` | 52 | 4 | ADH_WATERPROOF_PVC, ARTFABRIC_GRAPHIC, ARTPRINT_PHOTO, WATERPROOF_PET |
| 단독 | `f4339b35…` | 39 | 1 | ARTPAPER_MATTE |
| 단독 | `7631a823…` | 46 | 1 | BANNER_MESH |
| 단독 | `19134ddf…` | 52 | 1 | ADH_CLEAR_PVC |
| 단독 | `144ad4fb…` | 52 | 1 | LINEN_FABRIC |
| 단독 | `ba938a70…` | 79 | 1 | BANNER_NORMAL |

- 사용자 실측과 **완전 일치.** 그룹 A·B 각 4 comp가 byte-identical, 단독 5개 전부 고유 md5.
- **dup 검사:** 13 comp = 7 distinct md5. 그룹 외 동형 0(추가 결합 가능 클러스터 없음).

### 1.2 단가 실값 교차검증 (행수 같은 52행 단독이 그룹과 같은 게 아님을 입증)

좌표 600×1800 단가:

| comp | 600×1800 단가 | 소속 |
|------|--------------:|------|
| CANVAS_FABRIC | 37,800 | 그룹 A |
| MESH_PRINT | 37,800 | 그룹 A (= CANVAS) |
| ARTPRINT_PHOTO | 21,600 | 그룹 B |
| WATERPROOF_PET | 21,600 | 그룹 B (= ARTPRINT) |
| LINEN_FABRIC | 32,400 | **단독(52행이나 그룹과 다름)** |
| ADH_CLEAR_PVC | 59,400 | **단독(52행이나 그룹과 다름)** |

→ **52행이 같다고 결합하면 안 됨**을 결정적으로 입증. LINEN(32,400)·ADH_CLEAR(59,400)는 그룹 어느쪽과도 단가 상이 → **결합 금지 정당.**

### 1.3 셀단위 diff (정본↔레거시 단가표 완전동일 입증 — 가격 불변 근거)

| 정본 | 레거시 | 좌표·단가 불일치 행수 |
|------|--------|:--:|
| CANVAS_FABRIC | LEATHER_ARTPRINT | **0** |
| CANVAS_FABRIC | MESH_PRINT | **0** |
| CANVAS_FABRIC | TYVEK_PRINT | **0** |
| ARTPRINT_PHOTO | ADH_WATERPROOF_PVC | **0** |
| ARTPRINT_PHOTO | ARTFABRIC_GRAPHIC | **0** |
| ARTPRINT_PHOTO | WATERPROOF_PET | **0** |

→ 배선을 레거시 comp에서 정본 comp로 재지정해도 **모든 좌표에서 동일 단가** → 각 상품 가격 불변(골든 재현 보장).

---

## 2. 배선 구조 실측 (formula_components·상품 바인딩)

### 2.1 1:1 배선 (각 소재 comp → 자기 전용 PRF의 disp_seq=1 본체)

| comp | 배선 PRF | disp_seq | addtn_yn | carrier 수 |
|------|----------|:--:|:--:|:--:|
| CANVAS_FABRIC | PRF_POSTER_CANVAS | 1 | Y | 1 |
| LEATHER_ARTPRINT | PRF_POSTER_LEATHER_AP | 1 | Y | 1 |
| MESH_PRINT | PRF_POSTER_MESH | 1 | Y | 1 |
| TYVEK_PRINT | PRF_POSTER_TYVEK | 1 | Y | 1 |
| ADH_WATERPROOF_PVC | PRF_POSTER_ADH_WP | 1 | Y | 1 |
| ARTFABRIC_GRAPHIC | PRF_POSTER_ARTFABRIC | 1 | Y | 1 |
| ARTPRINT_PHOTO | **PRF_POSTER_ARTPRINT + PRF_POSTER_FIXED** | 1 | Y | 2 |
| WATERPROOF_PET | PRF_POSTER_WATERPROOF | 1 | Y | 1 |

- 각 PRF은 본체(disp_seq=1) + 후가공 add-on(CREASE_1L·CORNER_ROUND/RIGHT·VARTEXT/VARIMG·PRINT_SPOT_WHITE_S1·PERF_1L, disp_seq 2~9)로 구성된 **소재별 완성 공식**.
- 레거시 6 comp(정본 제외)은 정확히 **1개 PRF에만** 배선 → 재지정 대상이 깨끗하게 6건.

### 2.2 PRF↔상품 1:1 바인딩 (`t_prd_product_price_formulas`)

| PRF | 상품 prd_cd |
|-----|-----|
| PRF_POSTER_CANVAS | PRD_000125 |
| PRF_POSTER_LEATHER_AP | PRD_000126 |
| PRF_POSTER_MESH | PRD_000128 |
| PRF_POSTER_TYVEK | PRD_000127 |
| PRF_POSTER_ADH_WP | PRD_000121 |
| PRF_POSTER_ARTFABRIC | PRD_000123 |
| PRF_POSTER_ARTPRINT | PRD_000118 |
| PRF_POSTER_WATERPROOF | PRD_000120 |
| PRF_POSTER_FIXED | (상품 바인딩 없음·범용/예비) |

→ **결합은 comp 레벨만.** PRF·상품 바인딩은 1:1로 보존되어 각 소재 상품의 견적은 자기 PRF→정본 comp 단가표(동값)로 동일 산출.

---

## 3. 결합 매니페스트

### 그룹 A — 정본 `COMP_POSTER_CANVAS_FABRIC`

| 항목 | 값 |
|------|------|
| 정본 comp | COMP_POSTER_CANVAS_FABRIC (52행 보존) |
| 레거시 comp(use_yn=N) | COMP_POSTER_LEATHER_ARTPRINT, COMP_POSTER_MESH_PRINT, COMP_POSTER_TYVEK_PRINT |
| 배선 재지정 (formula_components UPDATE) | PRF_POSTER_LEATHER_AP[disp_seq=1] · PRF_POSTER_MESH[disp_seq=1] · PRF_POSTER_TYVEK[disp_seq=1] 의 `comp_cd` → COMP_POSTER_CANVAS_FABRIC (3건) |
| 단가행 재적재 | **0** (정본에 52행 전건 존재·셀 diff 0) |
| DELETE | **0** |

### 그룹 B — 정본 `COMP_POSTER_ARTPRINT_PHOTO`

| 항목 | 값 |
|------|------|
| 정본 comp | COMP_POSTER_ARTPRINT_PHOTO (52행 보존·PRF_POSTER_FIXED 배선 보유) |
| 레거시 comp(use_yn=N) | COMP_POSTER_ADH_WATERPROOF_PVC, COMP_POSTER_ARTFABRIC_GRAPHIC, COMP_POSTER_WATERPROOF_PET |
| 배선 재지정 (formula_components UPDATE) | PRF_POSTER_ADH_WP[disp_seq=1] · PRF_POSTER_ARTFABRIC[disp_seq=1] · PRF_POSTER_WATERPROOF[disp_seq=1] 의 `comp_cd` → COMP_POSTER_ARTPRINT_PHOTO (3건) |
| FIXED 배선 | PRF_POSTER_FIXED[disp_seq=1]=ARTPRINT_PHOTO → **무변경(자연 보존)** |
| 단가행 재적재 | **0** (셀 diff 0) |
| DELETE | **0** |

### 정본 선정 근거 (검토 결과 — 사용자 권고 확정·정정 없음)

- **그룹 A=CANVAS_FABRIC:** 단가표 대표·소재명이 가장 일반적(캔버스천). 다른 후보 대비 우위 결정 요인 없음 → 사용자 권고 채택.
- **그룹 B=ARTPRINT_PHOTO:** PRF_POSTER_FIXED 범용 공식이 이미 ARTPRINT_PHOTO를 가리킴 → 정본으로 두면 FIXED 배선 재지정 불요(부작용 최소). **타당성 라이브 확인 완료.**

---

## 4. comp_nm·note 최종 문안 (사용자 형식 — 한글 소재군명 + note 결합내역)

### 정본 2 comp (가독성 정비 + 결합 표시)

**COMP_POSTER_CANVAS_FABRIC**
- comp_nm: `실사 완제품가 (캔버스천·레더아트·메쉬프린트·타이벡)`
- note:
  `[동형결합] 가격표 동일 4소재 통합 · 결합소재: 캔버스천, 레더아트프린트, 메쉬프린트, 타이벡프린트 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=37,800원 · 정본 COMP_POSTER_CANVAS_FABRIC(레거시 LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT use_yn=N)`

**COMP_POSTER_ARTPRINT_PHOTO**
- comp_nm: `실사 완제품가 (방수PVC·아트패브릭·아트프린트·방수PET)`
- note:
  `[동형결합] 가격표 동일 4소재 통합 · 결합소재: 방수PVC(점착), 아트패브릭그래픽, 아트프린트포토, 방수PET · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=21,600원 · 정본 COMP_POSTER_ARTPRINT_PHOTO(레거시 ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC/WATERPROOF_PET use_yn=N) · PRF_POSTER_FIXED 범용배선 보유`

> 결합소재 한글명은 컨펌 Q-IM1(아래) 대상 — 약식 한글명을 임의 확정하지 않음.

### 단독 5 comp 가독성 정비 (코드 제거만·결합 0)

| comp | 정비 comp_nm | note(접두만) |
|------|-------------|------|
| COMP_POSTER_ARTPAPER_MATTE | `실사 완제품가 (아트지무광)` | `[단독] 동형 없음 · 가격축: 가로×세로 구간(39셀)` |
| COMP_POSTER_BANNER_MESH | `실사 완제품가 (메쉬배너)` | `[단독] 동형 없음 · 가격축: 가로×세로 구간(46셀)` |
| COMP_POSTER_ADH_CLEAR_PVC | `실사 완제품가 (투명점착PVC)` | `[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=59,400원` |
| COMP_POSTER_LINEN_FABRIC | `실사 완제품가 (린넨페브릭)` | `[단독] 동형 없음 · 가격축: 가로×세로 구간(52셀) · 골든 600×1800=32,400원` |
| COMP_POSTER_BANNER_NORMAL | `실사 완제품가 (일반배너)` | `[단독] 동형 없음 · 가격축: 가로×세로 구간(79셀)` |

> 단독 소재의 한글명도 Q-IM1 컨펌 대상.

---

## 5. 영향분석 (검증 계획 — GO는 validator)

| 항목 | 기대 | 검증 방법(validator) |
|------|------|------|
| 배선 고아 0 | 재지정 후 모든 PRF의 disp_seq=1 본체가 use_yn=Y comp 가리킴 | formula_components⋈price_components use_yn=Y join, 고아 0 |
| 중복 배선 0 | 한 PRF에 본체 comp 2건 안 생김 | PRF별 disp_seq=1 행수 = 1 |
| 동시매칭 0 | 정본 comp 단가표가 한 좌표에 1행 | 정본 comp (siz_w,siz_h,min_qty) UNIQUE |
| 각 상품 가격 불변 | 6 상품 골든 재현 (PRD_000126/128/127/121/123/120) | 재지정 전후 evaluate_price 동일 — §1.3 셀 diff 0이 이미 입증 |
| FIXED 배선 보존 | PRF_POSTER_FIXED→ARTPRINT_PHOTO 무변경 | formula_components 행 비교 |
| 단가행 보존 | component_prices 행수 8×52 무변동·DELETE 0 | before/after count |
| use_yn=N 6건 | 레거시 6 comp만 use_yn=N(정본 2·단독 5는 Y 유지) | comp use_yn 점검 |

**가격 불변 핵심 논거:** 배선 재지정 = 레거시 PRF의 본체 comp_cd를 정본으로 교체. 정본 단가표 ≡ 레거시 단가표(byte-identical·셀 diff 0). 따라서 정본을 가리켜도 동일 단가 룩업 → **상품 가격 변화 0.**

---

## 6. load-builder 인계 단위 (테이블별 UPDATE·멱등키)

| # | 테이블 | 작업 | 행수 | 멱등키 |
|---|--------|------|:--:|------|
| 1 | t_prc_formula_components | UPDATE comp_cd → 정본 (그룹A: LEATHER_AP/MESH/TYVEK PRF disp_seq=1) | 3 | (frm_cd, disp_seq=1) |
| 2 | t_prc_formula_components | UPDATE comp_cd → 정본 (그룹B: ADH_WP/ARTFABRIC/WATERPROOF PRF disp_seq=1) | 3 | (frm_cd, disp_seq=1) |
| 3 | t_prc_price_components | UPDATE use_yn='N' (레거시 6 comp) | 6 | comp_cd |
| 4 | t_prc_price_components | UPDATE comp_nm·note (정본 2) | 2 | comp_cd |
| 5 | t_prc_price_components | UPDATE comp_nm·note (단독 5 가독성 정비) | 5 | comp_cd |
| — | t_prc_component_prices | **무변경**(단가행 보존·DELETE 0·INSERT 0) | 0 | — |
| — | t_prd_product_price_formulas | **무변경**(상품 바인딩 보존) | 0 | — |

- **총 라이브 변경: UPDATE 19행, INSERT 0, DELETE 0.**
- 멱등: formula_components는 (frm_cd, disp_seq=1) WHERE comp_cd=레거시 조건부 UPDATE(이미 정본이면 no-op). use_yn/comp_nm/note는 목표값 UPDATE(재실행 idempotent).
- 단일 트랜잭션 래핑 + 롤백 DRY-RUN 권고(load-execution R1~R6).

---

## 7. BLOCKED / 컨펌 정직 분류

| ID | 분류 | 내용 | 권고 |
|----|------|------|------|
| Q-IM1 | 컨펌 | 결합소재·단독 한글 약식명(캔버스천/레더아트/방수PVC 등) 표기 확정 — 가격표/상품마스터 공식 표기명과 일치하는지 | load-builder가 가격표 원본 표기명 대조 후 문안 확정. 임의 확정 금지 |
| Q-IM2 | 컨펌 | comp_nm 정본을 결합 4소재 나열형(`(캔버스천·레더아트·메쉬·타이벡)`) vs 대표 소재명(`(캔버스천 외 3)`) — 가독성 vs 길이 | 4소재 나열형(사용자 형식 예시 준수). 단 길면 `(캔버스천 외 3종)` 대안 |
| Q-IM3 | 정보 | PRF_POSTER_FIXED 상품 바인딩 없음 — 범용/예비 공식인지 사용 안 하는 잔존인지 | 결합과 무관(ARTPRINT_PHOTO 정본이라 배선 보존). 별도 정리 트랙 |
| (없음) | BLOCKED | 동형 byte-identical 입증 완료·단가행 보존·배선 깨끗 1:1 → **기술적 BLOCKED 없음** | — |

**결합 금지(HARD 준수 확인):** ARTPAPER_MATTE·BANNER_MESH·ADH_CLEAR_PVC·LINEN_FABRIC·BANNER_NORMAL 5개는 행수가 그룹과 같아도(ADH_CLEAR·LINEN=52) md5·단가 상이 → **절대 결합 안 함**(가독성 정비만).

---

## 8. read-only 준수

- 라이브 SELECT만(comp 메타·전컬럼 md5·셀 diff·formula_components 배선·상품 바인딩·컬럼 스키마). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 생성자=설계자 → 자기 GO 판정 금지. GO·DRY-RUN·골든 재현 실증 = dbm-validator 독립 게이트. 실 SQL = dbm-load-builder. 실 COMMIT = 인간 승인.
