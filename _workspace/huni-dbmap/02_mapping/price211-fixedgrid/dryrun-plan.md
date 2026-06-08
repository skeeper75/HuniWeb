# DRY-RUN 계획 + 설계자 사전점검 — price211-fixedgrid (slice C3)

| 항목 | 값 |
|------|----|
| 트랙 | price-211 Phase-1 고정가형(slice C3) |
| 타깃 | `t_prc_component_prices` 단가 73행(신규 10 + 멱등 no-op 63) |
| 적재 SQL | `load.sql`(멱등 NOT EXISTS, 단일 트랜잭션, 기본 ROLLBACK) |
| 권위 | 포스터사인 고정가형 [수량×규격] 명시값 (실사 inline 미사용) |

> [HARD] 본 문서는 **DRY-RUN 계획**이다. 본 세션은 **라이브 DRY-RUN 미실행**(USER RULE:
> "No live DRY-RUN exec. Read-only SELECT only"). 아래 R1~R6 은 read-only SELECT 실측 +
> 설계자 정적점검으로 사전 통과를 입증하고, 실제 DRY-RUN(BEGIN…ROLLBACK)은 인간 승인 후
> dbm-validator/적재 단계에서 수행한다.

## DRY-RUN 절차 (인간 승인 시 실행 — 본 세션 미실행)
```
BEGIN; SET TRANSACTION READ WRITE;   -- (실제 DRY-RUN 시)
  -- load.sql 의 단계0 FK검증 + setval + INSERT(NOT EXISTS) 실행
  -- 1-pass 기대: 10행 INSERT
  -- 재실행(2-pass) 기대: 0행 INSERT (멱등)
  -- 제약위반/FK고아 0 확인
ROLLBACK;   -- 영구변경 0 (COMMIT 은 인간 승인 후에만)
```

## R1~R6 게이트 (설계자 사전점검 — read-only 실측 근거)

### R1. FK 부모 선존재 (PASS)
- comp_cd 17종 → `t_prc_price_components` 17/17 존재(read-only 실측).
- siz_cd 18종 → `t_siz_sizes` 18/18 존재(read-only 실측, search-before-mint).
- frm_cd `PRF_POSTER_FIXED`·prd_cd 15종 → 라이브 존재(바인딩 15/15).
- comp_typ_cd `.06`, FRM_TYPE `.02` → 코드 존재. **→ FK 고아 0.**

### R2. 자연키 UNIQUE / 중복 (PASS)
- CSV 내 8컬럼 자연키 중복 = **0**(평면화 dedup 검증).
- 라이브 대조: 73 중 63 자연키 기존재(멱등 no-op), 10 신규. 단가충돌 0.
- **NULLS DISTINCT 함정 대응**: 자연키 인덱스가 NULLS DISTINCT(기본)라 NULL 차원 행은
  ON CONFLICT 미발화 → **NOT EXISTS(IS NOT DISTINCT FROM) 가드**로 멱등 보장(load.sql §2).

### R3. 타입/길이/NOT NULL/CHECK (PASS)
- unit_price numeric(12,2): 최대 50000.00 — 범위 내. 소수 2자리 정규화(`.00`).
- apply_ymd varchar(10) `'2026-06-01'` NOT NULL: 전건 충족.
- siz_cd varchar(50): `SIZ_0000xx` 안전. clr/mat/coat/bdl/일부 min_qty = NULL(C-9).
- reg_dt NOT NULL: `now()` 명시(round-5 함정 회피 — 명시 NULL 은 DEFAULT 미발화).
- min_qty integer: 1·4·19·49·99·10000 — 범위 내.

### R4. 멱등성 (설계 PASS — 라이브 실증은 인간 승인 후)
- 1-pass 기대 = 10행 INSERT(EXPANSION). 2-pass 기대 = 0행(NOT EXISTS 전건 차단).
- 라이브 실측으로 "63 기존재 + 10 부재"를 사전 확인 → NOT EXISTS 가 63 차단·10 통과 예측.
- **NULL 차원까지 IS NOT DISTINCT FROM 으로 매칭** → ON CONFLICT 방식의 중복 위험 제거.

### R5. IDENTITY 시퀀스 (가드 적용)
- 라이브 실측: `MAX(comp_price_id)=4971` > `seq.last_value=4954` (**stale**).
- load.sql 단계1 `setval(seq, GREATEST(MAX(id),1), true)` 재동기 → 신규 INSERT 시 4972+
  발급(기존 id 충돌 0). 메모리 lesson `dbmap-digitalprint-...`(IDENTITY stale) 적용.

### R6. 적재 순서 / 트랜잭션 (PASS)
- 단계 0(FK 검증) → 단계 1(setval) → 단계 2(INSERT). 부모 전부 선존재라 동일 트랜잭션 내
  단가 행만 INSERT(병렬 부모적재 불요).
- 단일 트랜잭션 BEGIN…ROLLBACK(기본). COMMIT 은 인간 승인 시 교체.

## 정적 검증 결과 (본 세션 수행)
- VALUES 데이터 행 = 73, 괄호 균형 147/147, BEGIN/ROLLBACK 각 1, dollar-quote 1/1.
- comp_cd 17종 분포 = 추출본과 정확 일치.
- INSERTABLE.csv 73행 / BLOCKED.csv 0행(헤더만).

## 종합 판정
설계 사전점검 **GO** (R1~R6 통과 예측). 라이브 멱등 2-pass 실증·실제 COMMIT·F-WIRE 배선은
**인간 승인** 후 dbm-validator 독립 재검증 + 적재 단계에서 수행.
