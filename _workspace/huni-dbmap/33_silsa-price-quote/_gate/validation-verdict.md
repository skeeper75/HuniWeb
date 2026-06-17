# 실사 가격 견적화 — round-23 Phase D 독립 검증 verdict (R1~R6)

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립.
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. COMMIT 0·비밀값 비노출.
> 권위: 라이브 information_schema + 실데이터(2026-06-17). 생성자 보고는 신뢰하지 않고 직접 psql 재현.

## 종합 판정: **CONDITIONAL-GO**

R1~R6 전건 PASS(실측 재현). 단 ① U2/U7 BLOCKED 미해소(silsa 좌표 본체 단가 미적재 → 가격 데이터 완전성 미달, 가격사슬 "배선"은 해소되었으나 "단가 데이터"는 GAP), ② U5 백업 컬럼 누락(note) MINOR, ③ 실 COMMIT·U5 hard-delete·U2/U7 해소는 인간 승인 — 이 3건이 잔존 조건. 돈-크리티컬 별색 행수 논쟁은 **Phase C(106 유지) 손**으로 독립 판정.

---

## R1 멱등성 — **PASS**
2-pass 독립 재현(단일 ROLLBACK tx 내 apply 2회). **PASS2 전 DML = 0**:
```
PASS2: INSERT 0 0 ×4 · UPDATE 0 ×18 · DELETE 0 ×3   (전건 0)
```
모든 INSERT=NOT EXISTS·UPDATE=조건부(현재값<>목표)·DELETE=결정적 필터 → 재실행 무해. 생성자 주장과 일치.

## R2 트랜잭션 원자성 — **PASS**
`apply.sql` 단일 `BEGIN; \i U1→U3→U4→U5→U6→U8`. `ON_ERROR_STOP on`. apply.sql 자체 COMMIT 0(로더가 ROLLBACK/COMMIT 주입). FK 위상순(siz 부모 → comp/배선 → 삭제 → 공식/배선/바인딩 → 가독성) 정합. 전체 파일이 오류 없이 단일 tx로 롤백됨.

## R3 실행가능성 — **PASS**
apply.sql 전 6단위가 라이브 스키마에서 문법·참조 오류 0으로 실행(R4 DRY-RUN이 clean 통과로 입증).
- **U6 PK 정정 실측 확인**: `t_prd_product_price_formulas` PK = **(prd_cd, apply_bgn_ymd)** (information_schema 직접 조회). 생성자 정정 정확 — DDL 문서 (prd_cd,frm_cd)는 stale. apply_bgn_ymd NOT NULL → DELETE(FIXED) 선행 후 INSERT(동일 '2026-06-01') 방식이 PK 충돌·이중계상 모두 회피.

## R4 라이브 DRY-RUN(영향행수) — **PASS (생성자 보고와 완전 일치)**
독립 BEGIN…ROLLBACK 실측:
```
U1 INSERT 106 · U3 UPDATE 6 / DELETE 12 · U4 UPDATE 1+30+2 / DELETE 4
U5 DELETE 424 · U6 INSERT 28+28 / DELETE 28 / INSERT 28 · U8 UPDATE 15
합계: INSERT 162 · UPDATE 54 · DELETE 468 · ERROR 0 · ROLLBACK
```
생성자 보고(INSERT162 / UPDATE54 / DELETE468)와 **전건 일치**. 불일치 0.

## R5 신규 엔티티/코드행 정합 — **PASS**
- SIZ_000518~623 라이브 사전 존재 = **0** (채번 충돌 없음). max 기존 siz_cd = **SIZ_000517** → 518이 정확한 next.
- 106 신규 좌표 (work_width,work_height) 중 **기존 siz와 좌표 충돌 = 0** (전수 대조) → search-before-mint 위반 없음.
- EXACT-4 재사용 주장 검증: SIZ_000320(900x1200)·322(5000x900)·323(900x900)·402(1000x1500) — 이 4 좌표는 106 신규 목록에 **미포함**(올바르게 제외/재사용). 일관.

## R6 생성-검증 독립성 + 돈-크리티컬 쟁점 — **PASS**

### ★ 별색 WHITE_S1 행수 논쟁 — 독립 판정: **Phase C(106 유지)가 맞음**
라이브 WHITE_S1 530행 직접 분해:
```
구조 = 53 min_qty밴드 × print_opt 2(POPT_000001/000002) × proc 5(PROC_000008~012)
```
- **POPT는 실 가격축**: POPT_000001 unit_price 300~3,000 / POPT_000002 600~6,000 — 단/양면 단가티어 실재. → Phase B "53(키별 1행)"은 이 티어를 붕괴시켜 **돈-크리티컬 오류**. Phase B 부결.
- **proc는 잉여 교차곱**: 형제 별색 comp(CLEAR/GOLD/PINK/SILVER/WHITE_S2) 전부 **proc 1종·print_opt 1종·53행**. WHITE_S1만 5proc×2popt로 오염. 삭제 대상 424행의 note가 "별색(은색)/별색(클리어)/별색(금색)…"로 라벨됨 = WHITE comp에 타색 단가가 잘못 매달림을 자증.
- **값 무손실 정밀 판정**: 생성자 주석 "5 proc unit_price 동일"은 **부정확**(MINOR 정정). 실측: {PROC_000008 화이트 == 000009 클리어} = base, {000010 핑크·011 금·012 은} = base+150(POPT1)/+300(POPT2). 그러나 유지 대상 PROC_000008(화이트)은 106행 전건 보존 → **화이트 자기 가격 손실 0**. 삭제되는 타색 proc는 WHITE comp에 부적합 → WHITE 견적가에 손실 없음. 결론 동일(106 유지 정답), 근거 문구만 정정 필요.
- **추가 관찰(차단 아님)**: 형제 _S1은 POPT_000001만 보유하나 WHITE_S1은 POPT_000002도 보유(WHITE_S2가 POPT_000002 담당). S1/S2=단/양면 추정 시 WHITE_S1의 POPT_000002 티어는 별도 정리 후보지만, 엔진 라우팅 미확인 → Phase C가 보수적으로 양 POPT 보존(106)은 **안전한 선택**. 53 강제 미채택 정당.

### 28상품 공식 분리 후 전건 조회가능 — **PASS (배선 차원)**
- PRE: 28상품(PRD_000118~145) 전건 PRF_POSTER_FIXED 단일 바인딩(체인 단절 실재 확인).
- POST(rollback tx): 28상품 전건 자기 유형 공식 바인딩 / FIXED 잔존 0 / 배선된 공식으로 resolvable 28 / orphan(fc_comp·fc_frm·binding_frm) **전부 0**. U6 본체 comp 28종 전부 price_components 실재 → **FK 고아 0**.
- **단, 데이터 완전성 단서(차단 항목, R6 통과 무관)**: 28 본체 comp는 가격행을 보유하나 **silsa 좌표(SIZ_000518~623) 단가행 = 0** (ARTPRINT_PHOTO 1행·BANNER_NORMAL 3행 수준의 희소 좌표). 즉 U6은 **배선 단절은 해소**하나 **silsa 면적매트릭스 단가 데이터는 U2(BLOCKED)에 의존**. 생성자 매니페스트가 U2 BLOCKED로 정직 공시 — 날조 0. "전건 가격 조회가능"은 "전건 배선 resolvable"로 한정 해석해야 정확.

### 통합(C-1~C4) 후 단가행 재적재 0·의미손실 0 — **PASS**
- 정본 coverage 실측: CREASE_1L=30·PERF_1L=30·VARTEXT_1EA=69·VARIMG_1EA=69 (U3/U4 주장 일치). 레거시 use_yn=N·배선만 교체 → 단가행 INSERT 0. 의미손실 0.
- U4 "이설 불요·opt_cd→dim_vals 재정규화(값 불변)" 정합(PERF_1L 30행 opt_cd OPV-000007/8/9 보유 실측).

### 별색 hard-delete 백업+undo 동반 — **PASS (MINOR 정정 동반)**
- apply.sh가 COMMIT/DRY-RUN 무관 항상 백업 SELECT(424행=DELETE 대상과 정확히 일치) → backup_U5_white.csv. surrogate PK(comp_price_id) 캡처 → undo 재INSERT 가능.
- **MINOR**: 백업 SELECT 14컬럼 / 테이블 18컬럼. 누락 4 = note·reg_dt·upd_dt·dim_vals. 이 중 **note는 424행 전건 non-null**(dim_vals/upd_dt는 null) → 백업 CSV로 복원 시 note 유실. note 내용=별색 색상/면/매수 라벨(파생 가능·고유 비즈니스값 아님) → 심각도 MINOR. 권고: 백업 SELECT에 note·dim_vals 추가(`SELECT *` 또는 18컬럼 전체).

### 생성-검증 독립성 — **PASS**
검증자가 생성과 분리(load-builder가 빌드, 검증자가 게이트). 실 결함 ≥1 적발:
- R6-1 "5 proc 단가 동일" 문구 부정확(실=2티어) — 정정 요구.
- R6-2 U5 백업 note 누락(undo 불완전) MINOR.
- R6-3 "전건 가격 조회가능" 과장(배선만, silsa 단가 데이터는 U2 BLOCKED 의존) — 표현 정정.

---

## 미해소 차단 / 컨펌 (인간 승인 대기)
| ID | 항목 | 상태 | 라우팅 |
|----|------|------|--------|
| U2 | silsa 면적매트릭스 본체 단가행(~687) | BLOCKED(좌표 단가 언피벗 CSV 부재·날조 금지) | dbm-price-import-prep(poster-sign decomposition) → CSV → NOT EXISTS INSERT |
| U7 | 제본 고아 배선(10) | BLOCKED(대상 공식 부재·상호배타·silsa 스코프 밖) | 상품별 PRF_BIND_<TYPE> 1:1 별 트랙 |
| C-1 | U5 백업 note/dim_vals 누락 | MINOR(수정 권고) | dbm-load-builder — apply.sh 백업 SELECT 18컬럼화 |
| C-2 | U5 doc "5 proc 동일"·"전건 조회가능" 문구 | 정정 권고(판정엔 무영향) | dbm-load-builder — 주석/매니페스트 문구 정정 |
| — | 실 COMMIT·U5 hard-delete·U2/U7 해소 | 인간 승인 | lead |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| 영향행수 162/54/468 | 보고 | **동일** | 일치 |
| PK=(prd_cd,apply_bgn_ymd) | 정정 | **확인** | 일치 |
| WHITE_S1 106 유지 | 정답 | **확인(Phase B 53 부결)** | 일치 |
| siz 채번/좌표 충돌 0 | 주장 | **확인** | 일치 |
| "5 proc unit_price 동일" | 주장 | **부정확(2티어: 화이트=클리어 base, 핑크/금/은 +surcharge)** | **불일치(MINOR·결론 무변)** |
| 본체 단가 조회가능 | 암시 | **배선만 OK·silsa 좌표 단가는 0(U2 의존)** | **불일치(표현 과장)** |
| U5 백업 14컬럼 undo | 주장 | **note 유실(424행 non-null)** | **불일치(MINOR)** |
