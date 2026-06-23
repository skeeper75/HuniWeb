# dryrun-result.md — RC-2 각목 적재 롤백전용 DRY-RUN 실증

> dbm-load-builder · 2026-06-23 · BEGIN…ROLLBACK(아무것도 커밋 안 됨·라이브 읽기전용 보존).
> 실행 = `./apply.sh` (apply.sql 내부 BEGIN/COMMIT 무력화 + 외곽 트랜잭션 ROLLBACK 래핑).
> 단가 verbatim·제약위반 0·멱등 2-pass·12000 해소·always-add 가드 전부 입증.

---

## 1. 적재 영향행수 (DRY-RUN pass1·즉시 ROLLBACK)

```
BEGIN
INSERT 0 1   -- STEP1 OPT_000063 그룹
INSERT 0 1   -- STEP2a OPV_000432 세로변
INSERT 0 1   -- STEP2a OPV_000433 가로변
UPDATE 1     -- STEP2b OPV_000015 재라벨(900이하)
UPDATE 1     -- STEP2b OPV_000016 재라벨(900초과)
UPDATE 1     -- STEP4 _LE use_dims
UPDATE 1     -- STEP4 _GT use_dims
UPDATE 1     -- STEP5 4698 opt_cd=OPV_000015
UPDATE 1     -- STEP5 4700 opt_cd=OPV_000016
UPDATE 1     -- STEP6 부모 _900_4 use_yn=N
INSERT 0 1   -- STEP7 _LE 바인딩 disp8
INSERT 0 1   -- STEP7 _GT 바인딩 disp9
ROLLBACK
```
**합계 = INSERT 3 + UPDATE 7 + INSERT 2 = 12행. 제약위반/에러 0**(ON_ERROR_STOP=1 통과·FK·NOT NULL·트리거 전부 정상).

## 2. 적재 후 상태 검증 (롤백 전 SELECT·설계값 일치)

### A. 신규 그룹/옵션 (STEP1·2)
| opt_grp_cd | opt_grp_nm | sel_typ | min/max | mand | disp | use_yn |
|---|---|---|---|---|---|---|
| OPT_000063 | 각목 부착 변 | SEL_TYPE.01 | 0/1 | N | 3 | Y |

| opt_cd | opt_grp_cd | opt_nm | disp | use_yn |
|---|---|---|---|---|
| OPV_000015 | OPT_000004 | **각목(900mm이하)+끈(4개) 추가** | 4 | Y |
| OPV_000016 | OPT_000004 | **각목(900mm 초과)+끈(4개) 추가** | 5 | Y |
| OPV_000432 | OPT_000063 | 세로변 부착(좌우) | 1 | Y |
| OPV_000433 | OPT_000063 | 가로변 부착(상하) | 2 | Y |

### B. comp use_dims/use_yn (STEP4·6)
| comp_cd | use_dims | use_yn |
|---|---|---|
| `..._900_4`(부모) | NULL | **N**(좀비 차단) |
| `..._900_4_GT` | `["opt_cd","opt_grp:OPT_000004"]` | Y |
| `..._900_4_LE` | `["opt_cd","opt_grp:OPT_000004"]` | Y |

### C. 단가행 opt_cd 충전 (STEP5·단가 verbatim)
| comp_price_id | comp_cd | opt_cd | unit_price | apply_ymd |
|---|---|---|---|---|
| 4698 | `..._LE` | **OPV_000015** | **4000.00**(불변) | 2026-06-01(불변) |
| 4700 | `..._GT` | **OPV_000016** | **8000.00**(불변) | 2026-06-01(불변) |

### D. 공식 바인딩 (STEP7)
| frm_cd | comp_cd | addtn_yn | disp_seq |
|---|---|---|---|
| PRF_POSTER_BANNER_N | `..._LE` | Y | 8 |
| PRF_POSTER_BANNER_N | `..._GT` | Y | 9 |

## 3. 멱등 2-pass (동일 트랜잭션 apply×2)
```
=== PASS 1 ===  INSERT 0 1 ×3 / UPDATE 1 ×7 / INSERT 0 1 ×2   (12행 영향)
=== PASS 2 ===  INSERT 0 0 ×3 / UPDATE 0 ×7 / INSERT 0 0 ×2   (전 0 영향)
```
→ **멱등 입증**: NOT EXISTS(그룹·옵션·바인딩)·IS DISTINCT FROM(재라벨·use_dims·opt_cd·use_yn) 가드 전부 작동. 재실행 안전.

## 4. 엔진 재현 — 12000 이중합산 해소 + always-add 가드 (pricing.py `_row_matches` SQL 시뮬)

`_row_matches`: 행.opt_cd가 NULL이면 와일드카드, 충전되면 selections의 선택 opt_cd와 정확매칭. use_dims에 opt_cd 도입으로 opt_cd가 판별차원.

### Before(현행 결함·라이브 현 상태 SELECT)
| 케이스 | 매칭 단가행 | charge |
|---|---|---|
| 아무 주문(각목 미선택) | 4698(opt NULL=와일드)·4700(opt NULL=와일드) **둘 다** | **12000.00** 🔴 |
> 라이브 실측: `opt_cd IS NULL` 단가행 2행 합 = 4698:4000 + 4700:8000 = **12000 always-add 결함 재확인**(돈크리티컬).

### After(적재 후·DRY-RUN 상태 SQL 시뮬)
| 케이스 | selections opt_cd | 매칭 단가행(id) | charge | 판정 |
|---|---|---|---|---|
| **C-1 미선택** | (없음) | 0행 | **0** | ✅ always-add 해소 |
| **C-2 각목≤900** | OPV_000015 | 4698 1행 | **4000** | ✅ 정확 단가 1행 |
| **C-3 각목>900** | OPV_000016 | 4700 1행 | **8000** | ✅ 정확 단가 1행 |
| **C-4 끈 선택** | OPV_000014 | 0행 | **0** | ✅ 각목 미가산(택1 정합) |
| **C-ERR 동시매칭** | 015 AND 016 불가 | — | — | ✅ max_sel_cnt=1 → 12000 원천 차단 |

> **결론**: 적재 후 ① 미선택 0가산 ② 각목 선택 시 길이 구간별 정확 단가 **단 1행만** ③ 택1 그룹이라 015·016 동시선택 불가 → **12000 이중합산 완전 해소**. before(12000 always-add) → after(미선택0·선택시4000 or 8000 1행).

### 세로/가로 가격 무관 입증 (C-5)
- OPV_000432/433은 단가행 어디에도 안 쓰임(각목 단가행 opt_cd=015/016만) → 부착 변 선택은 가격 영향 0(순수 생산정보 CPQ). 환원행 HOLD라 트리거 미발동.

## 5. undo.sql DRY-RUN
```
./apply.sh undo → BEGIN / DELETE·UPDATE 전건 / ROLLBACK   (문법·제약 통과·커밋 0)
```
- 현재 baseline(미적재) 상태에선 undo 대상 부재라 0 영향(정상·멱등). 적재 후 상태(2-pass 내)에선 undo가 정확히 baseline 복귀(재라벨 원복·신규 제거·opt_cd NULL·use_dims []·use_yn Y).

## 6. 안전 확인
- 라이브 **읽기전용 보존**: 전 실행 ROLLBACK(COMMIT 0). 라이브 데이터 변경 없음.
- 비밀값 비노출: PGPASSWORD만 사용·stdout echo 0.
- 기초코드 마스터 불변·신규 단가행 INSERT 0건(IDENTITY/시퀀스 미접촉)·apply_ymd 분기 없음.
- ★실 COMMIT = dbm-validator R1~R6 GO + 인간 승인 후 hbd-load-executor(`./apply.sh commit`). 빌더 COMMIT 금지.
