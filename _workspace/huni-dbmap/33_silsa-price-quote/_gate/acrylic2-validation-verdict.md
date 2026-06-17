# 아크릴 마무리 실행본 (A5 + 코롯토 B2~B4) — Phase D 독립 검증 verdict (R1~R6) · 실 COMMIT 직전 게이트

> 검증자 dbm-validator · 2026-06-17 · 생성자(load-builder)와 독립. **실 COMMIT 직전 게이트.**
> 라이브 `railway` read-only + 롤백전용 DRY-RUN(BEGIN…ROLLBACK)으로 전건 재실측. 코롯토 단가는 acrylic-import.xlsx `5_korotto_NEW` openpyxl 독립 추출 + 라이브 siz_nm 해석 후 B3 SQL과 field-for-field 대조(생성자 korotto21.json 비신뢰). 엔진은 pricing.py `component_subtotal` 소스 직접 확인. COMMIT 0·비밀값 비노출.

## 종합 판정: **GO** → 실 COMMIT 가능 (인간 최종 승인 시)

R1~R6 전건 PASS(라이브 독립 재현). **A5 UPDATE81/B2 INSERT1/B3 INSERT21/B4 INSERT2 일치·2-pass delta 0·A5 보정 후 견적불가 행 0·골든 불변·코롯토 21 verbatim(mismatch 0)·채번 0·FK고아 0·MIRROR .01 미접촉·round-trip undo diff 0·BLOCKED 4건 정당 분리·COMMIT 0** 모두 실측. BLOCKER 0·불일치 0.

---

## R1 멱등성 (2-pass) — **PASS**
단일 ROLLBACK tx 내 A5/B2/B3/B4 2회 적용. **PASS2 전건 0**:
```
PASS2: UPDATE 0 · INSERT 0×4   (전건 0)
```
멱등키: A5=`min_qty IS NULL`(보정 후 재매칭 0) · B2/B4=comp_cd/frm_cd PK + (frm_cd,comp_cd) NOT EXISTS · B3=자연키(comp,apply_ymd,siz_width,siz_height,그외 차원 NULL) NOT EXISTS(component_prices PK=comp_price_id 시퀀스·자연키 unique 부재 실측→NOT EXISTS 필수). 생성자 주장 일치.

## R2 트랜잭션 원자성 — **PASS**
단일 `BEGIN; \i A5→B2→B3→B4; ROLLBACK`. `ON_ERROR_STOP on`. 4 유닛 파일 BEGIN/COMMIT/ROLLBACK **0건** → 중첩 tx 위험 0. FK 위상: A5(독립 보정)→B2(comp 부모)→B3(단가·comp FK)→B4(공식→배선). **BLOCKED 파일 `\i` 0**(apply.sql는 주석으로만 언급).

## R3 실행가능성 — **PASS**
DRY-RUN clean(문법·참조 오류 0). 라이브 일치 실측:
- t_prc_component_prices PK=comp_price_id(시퀀스)·자연키 unique 부재 → B3 NOT EXISTS 멱등 정합.
- 코드값 PRC_COMPONENT_TYPE.01·PRICE_TYPE.01 유효(MIRROR3T 사용 실증). siz_width/siz_height numeric.
- search-before-mint: COMP_ACRYL_COROTTO=0·PRF_COROTTO_ACRYL=0(라이브 부재 확인).

## R4 영향행수 — **PASS (생성자 보고와 완전 일치)**
독립 DRY-RUN:
```
A5 UPDATE 81 · B2 INSERT 1 · B3 INSERT 21 · B4 INSERT 2(공식1+배선1) · ERROR 0 · ROLLBACK
```
생성자 보고(UPDATE81·INSERT1·INSERT21·INSERT2)와 **전건 일치**.

## R5 ★A5 보정 (돈-크리티컬·핵심) — **PASS**
엔진 소스 확인(`component_subtotal`): `.02`(PRC_TYPE_TOTAL)는 `base=tier_min_qty or 0; if base<=0: raise ValueError → 합산 제외(견적 불가)`. min_qty NULL → base 0 → ValueError.
- **A5 결함 premise 실측: 81행** (.02 + siz_width NOT NULL + min_qty NULL) — 전건 **COMP_ACRYL_CLEAR3T**. CLEAR3T가 acrylic .02 유일 comp → predicate 보정이 정확히 의도분만 포착(over-reach 0).
- **보정 후 실측: 견적불가 행(.02+siz_width+min_qty NULL) = 0** (엔진 ValueError 해소). CLEAR3T min_qty=1 = 165(84 기존 + 81 보정).
- **골든 불변**: A5는 min_qty NULL→1만, unit_price 미변경. 엔진 .02 min_qty=1 → `unit_price ÷ 1 × qty = unit_price × qty`(.01 단가형과 수학적 동일). 30×30 3T 100개 = 3,100÷1×100 = 310,000 불변.
- **MIRROR(.01) 미접촉 실측**: COMP_ACRYL_MIRROR3T=PRICE_TYPE.01·.02 행 0 → A5 `.02` predicate 미매칭. mirror_minqty_changed=0 확인.

## R6 ★코롯토 verbatim + 골든 — **PASS**
**verbatim(돈-크리티컬)**: acrylic-import.xlsx `5_korotto_NEW` openpyxl 독립 추출(17 siz_cd + 4 GAP) → 17 siz_cd를 **라이브 siz_nm로 해석(W앞)** + GAP 4 GxS 직접 → (w,h)→price 21셀 구성 → B3 SQL 21행과 field-for-field diff:
```
only_in_xls=0 · only_in_b3=0 · price_mismatch=0
비대칭 검증: 50×30=4,400(≠30×50)·80×30=6,400·30×70=5,200 → W앞 파싱 정확·전치 0
golden: 30×30=3,600·50×30=4,400·70×80(GAP)=8,400·80×80=8,400 일치
```
- **채번 0**: siz_cd 미사용·siz_width/height 직접·t_siz_sizes **517 불변**(미접촉).
- post-state: 21 rows·21 distinct WH(중복 0)·FK고아(price·wiring) 0.
- 엔진 룩업: COMP_ACRYL_COROTTO prc_typ.01 단가형·use_dims [siz_width,siz_height]·PRF_COROTTO_ACRYL 배선 disp1 addtn_yn=N(본체 합산 시작).

---

## BLOCKED 분리 정당성 — **PASS (4건 모두 정당·라이브 미적용 확인)**
| ID | 항목 | 분리 사유 | 라이브 실측 |
|----|------|-----------|:--:|
| Q-ACR-9 | 미러 공식·바인딩 | 미러3T 본체 상품 0개·CPQ 소재옵션 선결·추측 금지 | PRF_MIRROR_ACRYL=0(미적용) ✅ |
| Q-ACR-CARA-OPT | 카라비너 comp/단가 | 형상 4 opt_cd 채번 선행·PRD_000166 비활성 | COMP_ACRYL_CARABINER=0 ✅ |
| Q-ACR-CO1 | 코롯토 바인딩(B5) | 코롯토 4상품 정체 컨펌 후(comp/단가/공식 GO) | korotto_binding=0 ✅ |
| Q-ACR-7b | CLEAR3T .02→.01 시맨틱 | 가격 무영향(min_qty=1)·개발자 컨펌 LOW | 미변경 ✅ |
- `acrylic2-blocked.BLOCKED.sql` = **실행 SQL 0건(전부 주석)** → 우발 실행해도 무영향. apply.sql `\i` 0(주석 언급만).

## undo 충분성 — **충분(round-trip diff 0 실증)**
apply.sh가 3 백업 CSV(A5 81행 comp_price_id + min_qty·코롯토 신설 전 부재 스냅샷) 저장. **apply→undo 한 tx 라운드트립 실측**:
```
post_korotto_comp=0 · post_korotto_rows=0 · post_korotto_formula=0  (신설분 전건 제거)
post_a5_restored_null=81 · a5_still_1_after_undo=0  (81 전건 NULL 복원·과삭제 0)
```
→ 적재 전 상태 완전 복원. A5는 comp_price_id 기준 정밀 원복(이전 트랙 predicate 과삭제 같은 결함 없음). 코롯토는 comp_cd 기준 신설분만 삭제(다른 comp 무관).

## 실 COMMIT 절차 안전성 — **PASS**
`apply.sh --commit` = `sed 's/^ROLLBACK;/COMMIT;/'`. apply.sql `^ROLLBACK;` **정확히 1건**(terminal) → 의도분만 치환. 비밀값 `.env.local` RAILWAY_DB_*만·비노출. ON_ERROR_STOP=1.

## 미해소 차단 / 컨펌
| ID | 항목 | 상태 |
|----|------|------|
| (BLOCKER 0) | — | 실 COMMIT 차단 사유 없음(A5·코롯토 comp/단가/공식 GO) |
| Q-ACR-CO1 | 코롯토 상품 바인딩(B5) | 컨펌 후 별도(이번 미적재·정당) |
| Q-ACR-9/CARA/7b | 미러·카라비너·.02 시맨틱 | 채번/컨펌 후 별도(정당) |

## 생성자 주장 vs 검증자 실측 불일치
| 항목 | 생성자 | 검증자 실측 | 판정 |
|------|--------|-------------|------|
| A5 UPDATE81·B2/B3/B4 1/21/2 | 보고 | **동일** | 일치 |
| A5 결함 81=CLEAR3T·보정후 0·골든 불변 | 주장 | **엔진 소스+라이브 실측 확인** | 일치 |
| 코롯토 21 verbatim·W앞·채번0 | 주장 | **xlsx 독립 추출 field-for-field 일치(mismatch 0)·siz 517 불변** | 일치 |
| MIRROR .01 미접촉 | 주장 | **확인(.02 행 0·min_qty 미변)** | 일치 |
| FK고아0·2-pass0·round-trip diff0·BLOCKED 미적용 | 주장 | **확인** | 일치 |
| 불일치 적발 | — | **없음**(전건 일치) | — |

**self-approve 0 / 날조 0**: 전 수치 라이브 직접 재현·코롯토 verbatim xlsx 독립 추출+라이브 siz_nm 해석·엔진 ValueError 소스 검증·round-trip undo 실측.

---

### 최종: **GO — 실 COMMIT 가능**
R1~R6 전건 PASS·BLOCKER 0·불일치 0·undo round-trip diff 0. 인간 최종 승인 시 `apply.sh --commit` 실행 가능(A5는 견적불가 결함 해소라 우선). COMMIT 후 사후검증(.02 min_qty NULL=0·코롯토 골든·MIRROR 불변·siz 517) 권고. 바인딩(B5)·미러·카라비너·.02 시맨틱은 컨펌/채번 후 별 트랙.
