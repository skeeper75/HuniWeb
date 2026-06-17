# 신안 + G-D2 통합 실행본 — 최종 독립 검증 verdict (R1~R6 + X-1) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립. **실 COMMIT 직전 최종 게이트.**
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. 가격표 xlsx는 openpyxl 독립 추출 대조(이전 wh-verdict). 엔진은 pricing.py 소스 직접 확인. COMMIT 0·비밀값 비노출.

## 종합 판정: **CONDITIONAL-GO** → 실 COMMIT 가능(조건 충족 시)

R1~R6 + X-1 전건 PASS(라이브 독립 재현). **975/77/28 영향행수 일치·통합 2-pass delta 0·FK고아 0·X-1 비충돌 단일화(area13 siz_width/height·fixed15 siz_cd·leftover siz_cd 0)·결합 골든 27,600 + off-grid 800×800=20,000 + above-max ERR 재현·COMMIT 0** 모두 실측.
**실 COMMIT 가능** — 단, 아래 조건 충족 전제: ① 인간 최종 승인 ② undo 백업 보강 2건(MINOR·아래) 반영 또는 인지 ③ U5'(별색 dedup)·아크릴·고정15 비전환은 의도적 범위 외(별 트랙) 확인. 차단(BLOCKER) 0 — CONDITIONAL은 undo 문서 정밀화 수준.

---

## R1 멱등성 (통합 2-pass) — **PASS**
통합 apply.sql 전 10단위를 단일 ROLLBACK tx 내 2회 적용. **PASS2 전 26 DML = 0**:
```
PASS2: INSERT 0×6 · UPDATE 0×(2+4+13) · DELETE 0   (전건 0)
```
멱등키: V1=자연키 NOT EXISTS · V1b/V2/W5/V3=조건부 WHERE(전환 전 상태) · W1/W2/W4/W6=NOT EXISTS · W3=DELETE→PK NOT EXISTS INSERT. 생성자 주장 일치.

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i V1→V1b→V2→W1→W2→W3→W4→W5→W6→V3; ROLLBACK`. `ON_ERROR_STOP on`. 10 `\i` 유닛 파일에 **BEGIN/COMMIT/ROLLBACK 0건**(grep 전수) → 중첩 트랜잭션 위험 0. 전체 단일 tx 오류 없이 롤백. FK 위상순: V1/V1b/V2(면적 데이터·모델)가 W1~W6(공식/배선) 선행 → 가격 공백 0.

## R3 실행가능성 — **PASS**
- 10 `\i` 경로 전건 해소(상대경로 `../_exec_wh|gd2/` 실재). 문법·참조 오류 0(R4 clean).
- 라이브 스키마 일치: siz_width/siz_height numeric · use_dims jsonb · `t_prd_product_price_formulas` PK=(prd_cd,apply_bgn_ymd)(실측) · PROC_000086/090 실재 · 28 본체 + 8 후가공 comp 실재.

## R4 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 `psql -f apply.sql`(apply.sh dryrun 동일):
```
INSERT: V1 667 + W1 28 + W2 28 + W3 28 + W4 196 + W6 28 = 975
UPDATE: V1b 17 + V2 13 + W5(1+1+30+2) + V3(1×13) = 77
DELETE: W3 28 = 28 · ERROR 0 · ROLLBACK
```
생성자 보고(975/77/28·재적재0)와 **전건 일치**. 단가행(component_prices) 신규=V1 667 verbatim·V1b/W5=값불변 전환.

## R5 ★X-1 단일화 정합 — **PASS**
- **area13 use_dims=[siz_width,siz_height]: 13** · **fixed15=[siz_cd]/[siz_cd,min_qty]: 14 + CANVAS_HANGING [siz_width,siz_height,min_qty]: 1** = 28 본체 비충돌 분리.
- **area13 잔여 siz_cd 행 = 0**(V1b 17 전건 전환) → siz_cd/siz_width 이중 매칭(combos>1) 위험 제거.
- orphan(fc_frm·fc_comp·bind_frm) = **0** · 28상품 자기공식 바인딩 · FIXED 잔존 0 · 28공식 전부 9 comp.
- 동시매칭 0: 각 PRF_POSTER_* disp_seq=1 본체 1 comp만 매칭(이전 gd2-verdict SIM과 정합·신안은 본체 use_dims만 교체).

## R6 ★결합 골든 독립 재현 (NEW 통합 모델) — **PASS**
post-state(rollback tx) 엔진 TIER 로직 직접 SIM:
| 케이스 | 엔진 매칭 | 산출 | 판정 |
|--------|----------|------|:--:|
| 결합 골든 ARTPRINT 600×1800 + 오시2줄 q1 | 본체 siz_width600·siz_height1800=**21,600** + 오시 CREASE_1L{줄수:2}min_qty1=**6,000** | **27,600** | ✅ |
| off-grid 650×650 | w tier min≥650=800·h=800 → 800×800 | **20,000**(ceiling) | ✅ |
| above-max 6000×600 | w≥6000 eligible **0**(max 3000) | **ERR_ABOVE_MAX** | ✅ |
| W5 미싱 줄수=3 q1 | PROC_000086{줄수:3} | **7,000**(=former OPV-000009·값불변) | ✅ |
- ★결정적: 본체가 **V1b 전환된 siz_width/height 모델**로 21,600 해소 + 오시는 proc_cd/dim_vals(직교축) 가산 = 27,600. 분리 COMMIT 시나리오(selection 키 비결정)와 달리 **통합 단일화가 올바른 결합 견적 산출** 실증.
- 가격표 verbatim: 이전 wh-verdict에서 667셀 field-for-field 일치(mismatch 0) 확인 — 본 통합은 동일 V1 `\i` 참조(중복 사본 0).

---

## undo 충분성 판정 — **충분(MINOR 2건 보강 권고)**
apply.sh가 모드 무관 사전 백업 5종 CSV(timestamp 디렉터리) 저장. 비파괴(INSERT/조건부 UPDATE)이라 DRY-RUN ROLLBACK이 1차 안전망. 실 COMMIT 후 undo:
| 단위 | undo 경로 | 백업 충분성 |
|------|-----------|:--:|
| V1 INSERT 667 | 신규 행 DELETE | ⚠ MINOR — comp_price_id로 정밀 삭제 가능(pre_component_prices)이나 manifest 서술 predicate(`siz_width NOT NULL AND apply_ymd=2026-06-01`)는 **V1b 전환 17행도 매칭**(둘 다 apply_ymd 2026-06-01) → predicate 단독 undo 시 17행 과삭제. comp_price_id 기준 권고 |
| V1b/V2/V3 UPDATE | 백업 CSV 값 복원 | ✅ pre_component_prices/use_dims/nonspec에 PRE값 보존 |
| W5 prc_typ(.02→.01)·use_yn(Y→N) | 역-UPDATE | ⚠ MINOR — **prc_typ_cd·use_yn은 어느 백업 CSV에도 미포함**(pre_use_dims=use_dims만). 단 from-값이 SQL 상수(.02·Y)로 결정적 → 역-SQL 복원 가능(이전 U5 note 누락과 동류·심각도 MINOR) |
| W1/W2/W4/W6 INSERT | 신규 frm/배선 DELETE | ✅ predicate 결정적 |
| W3 DELETE 28 | pre_product_price_formulas로 FIXED 재INSERT | ✅ 백업 28행 PK 보존 |

→ 전 변경 복원 **가능**(comp_price_id + SQL 상수). 단 **백업 CSV 단독으로는 prc_typ/use_yn 미복원**·V1 predicate undo 과삭제 위험 → undo 시 백업 CSV + 역-SQL 병행 명시 권고(MINOR).

## 실 COMMIT 절차 안전성 — **PASS**
- `apply.sh --commit` = `sed 's/^ROLLBACK;/COMMIT;/' apply.sql | psql`. 통합 apply.sql `^ROLLBACK;` **정확히 1건**(line55 terminal)·`\echo` 라인은 `^ROLLBACK;` 미매칭 → 의도된 terminal만 COMMIT 치환. SAFE.
- 비밀값: `.env.local` RAILWAY_DB_* + `PGPASSWORD` env만·출력 비노출. ON_ERROR_STOP=1.

## 미해소 차단 / 컨펌
| ID | 항목 | 상태 | 라우팅 |
|----|------|------|--------|
| (BLOCKER 0) | — | 실 COMMIT 차단 사유 없음 | — |
| C-undo1 | 백업 CSV에 prc_typ_cd·use_yn 미포함(W5) | MINOR·역-SQL로 복원 가능 | dbm-load-builder(백업 SELECT에 컬럼 추가 권고) |
| C-undo2 | V1 undo predicate가 V1b 17행 과삭제 위험 | MINOR·comp_price_id 기준 undo 명시 | dbm-load-builder(undo SQL 정밀화) |
| F-1 | CANVAS_HANGING use_dims=[siz_width,height,min_qty]인데 데이터 siz_cd(3행)·width 0행 | **pre-existing·통합 미변경**(V2 13-list 미포함·grep 0). 엔진은 NON_QTY_DIMS(siz_cd 포함)로 매칭→조회 성립. 라벨만 불일치 | dbm-mapping-designer(use_dims→siz_cd 정정·별건) |
| Q-PR-3 | 아크릴 동형 전환 | 별 트랙 BLOCKED(범위 외) | 별 트랙 |
| U5' | 별색 dedup(WHITE_S1 530) | 별 트랙(W4 배선만 포함·의도) | grouping U5' |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| 영향행수 975/77/28·재적재0 | 보고 | **동일** | 일치 |
| 통합 2-pass delta 0 | 주장 | **확인(26 DML 전건 0)** | 일치 |
| X-1 비충돌(area13 width·leftover sizcd 0) | 주장 | **확인** | 일치 |
| 결합 골든 27,600·off-grid 20,000 | 주장 | **엔진 SIM 재현 일치** | 일치 |
| FK고아0·동시매칭0·COMMIT0 | 주장 | **확인** | 일치 |
| (신규 적발) undo 백업 prc_typ/use_yn 누락·V1 predicate 과삭제 | "undo 충분" | **MINOR 2건 — 백업 CSV 단독 불충분** | 보완 권고 |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·골든 엔진 소스 인용 라인 실재 + post-state SIM·가격표 셀 독립 추출 대조(이전 verdict)·undo 백업 컬럼 실측.

---

### 최종: **CONDITIONAL-GO — 실 COMMIT 가능**
R1~R6+X-1 전건 PASS·BLOCKER 0. 인간 최종 승인 시 `apply.sh --commit` 실행 가능. 권고: undo 백업에 prc_typ_cd·use_yn 추가 + V1 undo를 comp_price_id 기준으로 정밀화(둘 다 MINOR·COMMIT 차단 아님). COMMIT 후 사후검증(FK고아0·골든 27,600·use_dims 13전환·바인딩 28) 필수.
