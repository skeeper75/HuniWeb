# exec-result-260623.md — RC-2 각목(현수막 마감봉) 라이브 COMMIT 실행 결과

> hbd-load-executor · 2026-06-23 · 인간 승인 완료 + dbm-validator R1~R6 GO 후 실 적재.
> 대상 = 일반현수막(PRD_000138) 각목 옵션 · 보수안(2 comp 유지) · 라이브 railway DB(PG 18.4).
> 접속 = `.env.local RAILWAY_DB_*`(읽기전용 SELECT + 단일 트랜잭션 COMMIT). 비밀값 비노출(PGPASSWORD만).
> 권위[HARD] = 인쇄상품 가격표 「포스터사인」 r249/250 verbatim(4000/8000) · 라이브 4698/4700 verbatim · 단가 날조 0.

---

## 종합: **COMMIT 성공 (12행 적재 · 사후검증 전건 PASS · 12000 이중합산 라이브 실효 해소)**

| 단계 | 결과 |
|---|---|
| 1. 물리 백업 | ✅ `backup-before-260623.csv` — baseline 전 항목 명세 일치(불일치 0) |
| 2. DRY-RUN 재실행 | ✅ 12행·제약위반 0·전체 ROLLBACK(라이브 불변) |
| 3. 실 COMMIT | ✅ BEGIN→INSERT3+UPDATE7+INSERT2=12행→COMMIT(단일 TX·에러 0) |
| 4. 사후검증 | ✅ 12행 정착·단가 verbatim·엔진 재현(12000 해소)·마스터 불변·메쉬139 미접촉·멱등 |
| 5. undo 보유 | ✅ `undo.sql` baseline 정합 확인(미실행) |

---

## 1. 물리 백업 (undo ground-truth)

위치 = `09_load/_rc2_gakmok_260623/backup-before-260623.csv` (2026-06-23 라이브 SELECT).

| 항목 | baseline 실측값 | 명세 일치 |
|---|---|---|
| comp 부모 `_900_4` | use_dims=NULL · use_yn=Y | ✅ |
| comp `_LE` | use_dims=`[]` · use_yn=Y | ✅ |
| comp `_GT` | use_dims=`[]` · use_yn=Y | ✅ |
| 단가행 4698 | `_LE` · opt_cd NULL · 4000.00 · apply_ymd 2026-06-01 | ✅ |
| 단가행 4700 | `_GT` · opt_cd NULL · 8000.00 · apply_ymd 2026-06-01 | ✅ |
| OPV_000015 | "각목(세로)+끈(4개) 추가" · OPT_000004 · disp4 | ✅ |
| OPV_000016 | "각목(가로)+끈(4개) 추가" · OPT_000004 · disp5 | ✅ |
| 신규 OPT_000063 그룹 | count=0 (부재) | ✅ |
| 신규 OPV_000432/433 | count=0 (부재) | ✅ |
| GAKMOK 바인딩 | count=0 (부재) | ✅ |

→ 백업 baseline이 manifest §0·validation R2와 100% 일치. undo 복귀 타깃의 ground-truth 확보.

## 2. DRY-RUN 재실행 (COMMIT 직전)

```
BEGIN
INSERT 0 1 ×3  -- 그룹 + 신규옵션2
UPDATE 1   ×7  -- 재라벨2 + use_dims2 + opt_cd2 + 부모 use_yn1
INSERT 0 1 ×2  -- 바인딩2
ROLLBACK
```
**12행 · 제약위반/에러 0**(ON_ERROR_STOP=1 통과·FK/NOT NULL/트리거 정상) · 전체 ROLLBACK(라이브 불변). dryrun-result.md 예측과 정확 일치.

FK 부모 실재 직접 확인: PRD_000138(del_yn=N)·SEL_TYPE.01·PRF_POSTER_BANNER_N·comp `_LE`/`_GT` 전부 실재.

## 3. 실 COMMIT (영향 행수)

`./apply.sh commit` — apply.sql 자체 BEGIN…COMMIT(단일 트랜잭션).
```
BEGIN
INSERT 0 1 ×3 / UPDATE 1 ×7 / INSERT 0 1 ×2
COMMIT
```
**총 12행 적재 (INSERT 3 + UPDATE 7 + INSERT 2) · 에러 0 · 원자 COMMIT.**

| STEP | 테이블 | 연산 | 행수 |
|---|---|---|---|
| 1 | t_prd_product_option_groups | INSERT (OPT_000063) | 1 |
| 2a | t_prd_product_options | INSERT (OPV_000432·OPV_000433) | 2 |
| 2b | t_prd_product_options | UPDATE 재라벨 (OPV_000015·016) | 2 |
| 4 | t_prc_price_components | UPDATE use_dims (_LE·_GT) | 2 |
| 5 | t_prc_component_prices | UPDATE opt_cd 충전 (4698·4700) | 2 |
| 6 | t_prc_price_components | UPDATE 부모 use_yn=N | 1 |
| 7 | t_prc_formula_components | INSERT 바인딩 (_LE·_GT) | 2 |

## 4. 사후검증 (라이브 재실측 — COMMIT 후)

### 4.1 12행 정착 (전 항목 설계값 일치)
- **그룹** OPT_000063 "각목 부착 변": SEL_TYPE.01·min0·max1·mand N·disp3·use_yn Y·del_yn N ✅
- **옵션** OPV_000015→"각목(900mm이하)+끈(4개) 추가"(disp4·Y) · OPV_000016→"각목(900mm 초과)+끈(4개) 추가"(disp5·Y) · OPV_000432 "세로변 부착(좌우)"(OPT_000063·disp1·Y) · OPV_000433 "가로변 부착(상하)"(OPT_000063·disp2·Y) ✅
- **comp** 부모 `_900_4` use_yn=**N** / `_LE`·`_GT` use_dims=`["opt_cd", "opt_grp:OPT_000004"]`·use_yn=Y ✅
- **단가행** 4698=OPV_000015/**4000.00**/2026-06-01 · 4700=OPV_000016/**8000.00**/2026-06-01 (단가·apply_ymd verbatim 불변) ✅
- **바인딩** PRF_POSTER_BANNER_N×`_LE`(disp8·addtn_yn Y)·×`_GT`(disp9·addtn_yn Y) ✅

### 4.2 ★엔진 재현 — 12000 이중합산 라이브 실효 해소
단가행 opt_cd 충전으로 `_row_matches` 와일드카드 소멸 (라이브 직접 SQL 재현):

| 케이스 | wildcard_rows | 매칭 | charge | 판정 |
|---|---|---|---|---|
| **C-1 미선택** | **0** (둘 다 opt_cd 충전) | 0 | **0** | ✅ always-add 해소 |
| **C-2 각목≤900(015)** | — | 1 | **4000.00** | ✅ 정확 단가 1행 |
| **C-3 각목>900(016)** | — | 1 | **8000.00** | ✅ 정확 단가 1행 |
| **C-ERR 동시매칭** | OPT_000004 max_sel_cnt=**1** | — | — | ✅ 015·016 동시선택 불가 → 12000 원천 차단 |

> **Before(적재 전)** = 단가행 2개 opt_cd NULL 와일드 → 미선택에도 SUM 4000+8000=**12000 always-add 돈크리티컬 결함**.
> **After(라이브 실효)** = 미선택 0가산 / 각목 선택 시 길이 구간별 정확 단가 단 1행 / 택1로 동시매칭 불가 → **12000 이중합산 완전 해소(라이브 실효)**.

### 4.3 부수 무손상
- **세로/가로 가격 무관**: OPV_000432/433은 단가행 어디에도 미사용 → 부착 변 선택 가격 영향 0(순수 생산정보 CPQ). 환원행 HOLD(트리거 미발동).
- **기초코드 마스터 불변**: t_mat 343·t_siz 522·t_proc 107·t_cod 85·t_prc_component_prices 총 **7293**(전부 baseline 행수 동일·신규 단가행 INSERT 0건·IDENTITY 미접촉) ✅
- **메쉬현수막 PRD_000139 미접촉**: 각목 옵션 0건 유지 ✅

### 4.4 멱등 (적재 후 재-DRY-RUN)
```
INSERT 0 0 ×3 / UPDATE 0 ×7 / INSERT 0 0 ×2 = 전 12구문 0행 영향
```
→ 멱등 입증(NOT EXISTS·IS DISTINCT FROM 가드 작동). 재실행 안전(delta 0).

## 5. undo 보유 (미실행)

`undo.sql`(자체 BEGIN…COMMIT·역연산) 보유. baseline 복귀 타깃을 backup CSV와 대조 — 전 항목 일치:
- 라벨 원복(015 세로·016 가로) · use_dims `[]` · 부모 use_yn Y · 단가행 opt_cd NULL(단가 verbatim 불변) · 신규 그룹/옵션/바인딩 DELETE.

실 원복은 `./apply.sh undo-commit`(인간 승인 후). 현재 미실행.

---

## 6. 결론

RC-2 각목 적재 **12행 라이브 COMMIT 성공**. 부분 실패·롤백 없음. 12000 always-add 돈크리티컬 결함이 라이브에서 실효 해소(미선택 0·선택시 4000/8000 단 1행·택1 동시매칭 0). 단가 verbatim(4000/8000) 불변·기초코드 마스터 불변·신규 단가행 0건·메쉬139 미접촉·멱등 delta 0·undo 정합 확보.

**되돌리지 말 것**: PRD_000138 GAKMOK 12행 적재(그룹 OPT_000063·옵션 OPV_000015/016 재라벨·432/433 신규·comp use_dims·단가행 opt_cd·부모 use_yn=N·바인딩 2건).
