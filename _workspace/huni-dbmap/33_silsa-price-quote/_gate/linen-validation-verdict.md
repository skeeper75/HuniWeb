# 린넨패브릭포스터 마감가공 옵션 — Phase D 독립 검증 verdict (R1~R6) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립. **실 COMMIT 직전 게이트.**
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK·트리거 fn_chk_opt_item_ref 실발화)으로 전건 재실측. COMMIT 0·비밀값 비노출. 권위: 라이브 information_schema + 실데이터 + 트리거 소스(2026-06-17).

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

R1~R6 전건 PASS(라이브 독립 재현). **INSERT 10/UPDATE 0 일치·2-pass delta 0·FK고아 0·트리거 통과·단가 5건 verbatim 정확·결합 골든 재현·동시매칭 0·중복 mint 0(OPV-000024 재사용·OPV_000424 신규 충돌0)·COMMIT 0** 모두 실측. BLOCKER 0. 전 단위 비파괴 INSERT(L5 no-op UPDATE)라 undo 단순·완전. 이전 트랙(U5 note 누락·V1 predicate 과삭제) 같은 undo 결함 없음.

---

## R1 멱등성 (2-pass) — **PASS**
단일 ROLLBACK tx 내 L1~L5 2회 적용. **PASS2 전건 0**:
```
PASS2: INSERT 0×5 · UPDATE 0×2   (전건 0)
```
멱등키: L1/L1b/L2/L4 = PK NOT EXISTS · L3 = (comp_cd,apply_ymd,opt_cd) 논리키 NOT EXISTS(component_prices 자연키 unique 부재·PK 시퀀스라 필수) · L5 = `dflt_yn IS DISTINCT FROM 목표`. 생성자 주장 일치.

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i L1→L1b→L2→L3→L4→L5; ROLLBACK`. `ON_ERROR_STOP on`. 6 유닛 파일에 BEGIN/COMMIT/ROLLBACK **0건**(grep) → 중첩 tx 위험 0. FK 위상순: L1(옵션)→L1b(item·트리거)→L2(comp)→L3(단가·comp 부모)→L4(배선)→L5(UPDATE) 정합.

## R3 실행가능성 — **PASS**
- DRY-RUN clean(문법·참조 오류 0). 라이브 일치 실측:
  - PRD_000124 = 린넨패브릭포스터 실재 · OPT_000009 그룹 기존 4옵션(OPV_000025/26/27 + OPV-000024).
  - **트리거 `trg_t_prd_product_option_items_chk_ref`→`fn_chk_opt_item_ref()` BEFORE INSERT/UPDATE 라이브 실재**(소스 확인). OPT_REF_DIM.04 분기 = `t_prd_product_processes WHERE prd_cd=NEW.prd_cd AND proc_cd=NEW.ref_key1`. **PRD_000124에 PROC_000080(봉제) 실재** → L1b 2건 INSERT 시 트리거 **EXCEPTION 0**(DRY-RUN 실발화 통과).
  - L3 컬럼(opt_cd·proc_cd·note) 실재 · PROC_000080=봉제.

## R4 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 DRY-RUN(트리거 발화):
```
L1 INSERT 1(OPV_000424) · L1b INSERT 2(items·트리거 통과) · L2 INSERT 1(comp)
L3 INSERT 5(단가) · L4 INSERT 1(배선) · L5 UPDATE 0+0
합계: INSERT 10 · UPDATE 0 · ERROR 0 · ROLLBACK
```
생성자 보고(INSERT10·UPDATE0)와 **전건 일치**. L5 UPDATE 0 = 라이브 오버로크 이미 dflt_yn=Y·나머지 N(멱등 정합 실증).

## R5 ★단가 verbatim (돈-크리티컬) — **PASS**
post-state 5 단가행 실측(opt_cd별):
| 옵션 | opt_cd | 단가 | 판정 |
|------|--------|:--:|:--:|
| 오버로크 | OPV_000025 | **0** | ✅ |
| 오버로크+리본끈 | OPV-000024 | **800** | ✅ |
| 말아박기 | OPV_000026 | **1,000** | ✅ |
| 말아박기+면끈 | OPV_000424 | **2,000** | ✅ |
| 봉미싱(7cm) | OPV_000027 | **2,000** | ✅ |
- 5 distinct opt · 5 total rows(opt_cd별 1행·중복 0). 0원(오버로크)=명시 0행(미적재 아님·견적 "무료" 표시). 날조 0.

## R6 ★골든 가산 + 중복 mint 점검 — **PASS**
**중복 mint 독립 확인**:
- **OPV-000024(오버로크+리본끈) 라이브 이미 존재**(하이픈·disp4·item/단가 없던 상태) → 재사용·INSERT skip 실측 확인. spec OPV_000028 신규 가정이 의미 중복(2벌) 됐을 것 — 교정 정당.
- **OPV_000424(말아박기+면끈) 라이브 부재**·max OPV_(밑줄)=OPV_000423 → +1 정확·**채번 충돌 0**(전수 0).
- proc/자재 신규 mint 0(PROC_000080 재사용·트리거 통과).
- **dflt_yn=Y 오버로크(OPV_000025)** 실측·복합/유료 N — L5 정합.

**결합 골든**(엔진: 본체 면적 + opt_cd add-on 합산·addtn_yn 무참조):
린넨 본체 600×1800 = **32,400**(라이브 COMP_POSTER_LINEN_FABRIC siz_width=600/siz_height=1800·신안 모델 실측):
| 선택 | 합산 | 결과 |
|------|------|:--:|
| 오버로크(기본 무료) | 32,400+0 | **32,400** ✅ |
| 오버로크+리본끈 | 32,400+800 | **33,200** ✅ |
| 말아박기 | 32,400+1,000 | **33,400** ✅ |
| 말아박기+면끈 | 32,400+2,000 | **34,400** ✅ |
| 봉미싱(7cm) | 32,400+2,000 | **34,400** ✅ |
- **동시매칭 0**: COMP_POSTEROPT_LINEN_FINISH use_dims=`["opt_cd"]` → 선택 1 opt_cd에 단가행 1건 매칭(combos=1). 본체(siz_width/height)와 차원축 직교 → 동시매칭 없음. PRF_POSTER_LINEN 배선 L4 후 10(=기존 9 + finishing 1).

---

## 선행 의존성 (확인·만족)
린넨 본체가 siz_width/height로 32,400 해소 + PRF_POSTER_LINEN 9 comp 배선 + PRD_000124→PRF_POSTER_LINEN 바인딩은 **신안+G-D2 통합 트랙이 이미 라이브 COMMIT됨**을 전제. 라이브 실측 확인:
```
PRF_POSTER_LINEN 존재=1 · formula_components 라이브=9 · COMP_POSTER_LINEN_FABRIC use_dims=["siz_width","siz_height"]·width행 52·sizcd행 0 · PRD_000124 바인딩=PRF_POSTER_LINEN
```
→ 본 린넨 run은 그 위의 **순수 가산 레이어**(finishing add-on disp10). 의존성 만족·순환/stale 없음.

## undo 충분성 판정 — **충분(결함 0)**
apply.sh가 모드 무관 5 백업 CSV(이미 생성됨) 저장. **전 단위 비파괴 INSERT**(L5만 조건부 UPDATE·이번 no-op)라 undo 단순:
| 단위 | undo | 백업 충분성 |
|------|------|:--:|
| L1/L2/L3/L4 INSERT | 신규 행 DELETE(comp_cd/opt_cd predicate) | ✅ pre_component_prices에 comp_price_id 포함 |
| L1b item 2 | 백업 PRE에 없던 (opt_cd,item_seq) DELETE | ✅ pre_option_items PRE=OPV_000025/26/27만(OPV-000024/000424 0 items) → 정밀 |
| L5 UPDATE | 백업 dflt_yn 복원(이번 0변경) | ✅ pre_options |
→ 이전 트랙의 prc_typ/use_yn 누락·predicate 과삭제 같은 결함 **없음**(hard-delete 0·값 전환 0).

## 실 COMMIT 절차 안전성 — **PASS**
`apply.sh --commit` = `sed 's/^ROLLBACK;/COMMIT;/'`. apply.sql `^ROLLBACK;` **정확히 1건**(line33 terminal)·`\echo` 라인 미매칭 → terminal만 치환. SAFE. 비밀값 `.env.local` RAILWAY_DB_*만·비노출. ON_ERROR_STOP=1.

## 미해소 차단 / 컨펌
| ID | 항목 | 상태 |
|----|------|------|
| (BLOCKER 0) | — | 실 COMMIT 차단 사유 없음 |
| (컨펌 0) | 단가/옵션/mint/트리거 전건 라이브 정합 | — |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| INSERT10·UPDATE0 | 보고 | **동일** | 일치 |
| OPV-000024 기존 재사용·OPV_000424 신규(max+1) | 정정 | **확인(라이브 실재·충돌0·max OPV_000423)** | 일치 |
| 단가 0/800/1000/2000/2000 | 주장 | **5행 verbatim 일치** | 일치 |
| 결합 골든 32,400~34,400 | 주장 | **본체32,400+가산 재현 일치** | 일치 |
| 트리거 fn_chk_opt_item_ref 통과 | 주장 | **트리거 실발화 EXCEPTION 0(PROC_000080 실재)** | 일치 |
| 동시매칭0·FK고아0·2-pass0·COMMIT0 | 주장 | **확인** | 일치 |
| 불일치 적발 | — | **없음**(전건 일치) | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·트리거 소스+실발화 검증·단가 post-state 실측·중복 mint 라이브 전수 대조.

---

### 최종: **GO — 실 COMMIT 가능**
R1~R6 전건 PASS·BLOCKER 0·불일치 0·undo 완전. 인간 최종 승인 시 `apply.sh --commit` 실행 가능. COMMIT 후 사후검증(5택1 단가·골든 32,400+가산·dflt 오버로크·트리거 정합) 권고.
