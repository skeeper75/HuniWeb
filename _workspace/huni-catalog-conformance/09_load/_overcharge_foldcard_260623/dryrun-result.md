# dryrun-result.md — 접지카드 V2 교정 DRY-RUN 결과

> §21 카탈로그 정합 · 2026-06-23 · 라이브 읽기전용 + 롤백전용 트랜잭션. 실 COMMIT 없음.
> 대상: PRD_000027/028/029 · 공식 PRF_DGP_E · 4 FOLD_LEAF comp · 권고②(proc_grp/proc_cd 충전).

---

## 1. C-2 선확인 — proc_grp/proc_cd 코드 실재 여부 (search-before-mint)

**proc_grp 모델 = 라이브 메커니즘으로 작동 가능** (코드 0수정). clean 입증분(디지털/별색)에서 역공학한 패턴:
- use_dims에 `"proc_cd"` 토큰 → `pricing.py:461 is_proc=True` → P8-1 proc_sels 다중평가 진입.
- 단가행 `proc_cd` 충전 → `_row_matches`(NON_QTY_DIMS 포함, :38)가 비선택 comp 탈락.
- `proc_grp:<상위그룹코드>` 토큰은 메타 표기(P8-1 분리에 **필수 아님** — `:` 포함이라 non_qty에서 제외, is_proc 판정 무관). clean 일관성 위해 등재.

**필요 proc_cd 4종의 라이브 실재 매칭 (t_proc_processes, FK 대상):**

| comp | 접지방식(권위 260527) | 필요 proc_cd | 라이브 proc_nm | 실재 | 판정 |
|------|----------------------|-------------|---------------|:---:|------|
| 3FOLD | 3단접지 | **PROC_000060** | 3단접지 | ✅ | **재사용** |
| 4ACC | 4단병풍접지(아코디언) | PROC_000071 | 병풍접지("4단" 한정 없음) | ⚠️ 부분 | **CONDITIONAL** — 인간 확인 |
| 4GATE | 4단대문접지(게이트) | — | (대문/게이트 명칭 전무) | ⛔ | **BLOCKED → §12** |
| HALF | 반접지 | — | (반접지 명칭 전무·PROC_000059=2단접지 불일치) | ⛔ | **BLOCKED → §12** |

→ **proc_grp 상위그룹 PROC_000056(접지)는 실재** (4종 모두 그 자식). proc_grp 토큰 코드값은 문제없음.
→ **개별 proc_cd는 1/4만 정확 실재** → **C-2 = 부분 BLOCKED.** 임의 채번 금지·마스터 직접수정 금지(HARD).

---

## 2. 4 comp 현재 상태 실측 (verbatim 기준선)

| comp | use_dims(현) | prc_typ | 단가행 | proc_cd | min_qty=1 단가 | 단가행 합(불변 기준) |
|------|-------------|---------|:---:|:---:|:---:|:---:|
| COMP_FOLD_LEAF_3FOLD | `["min_qty"]` | PRICE_TYPE.01 | 48 | NULL | **6,000** | 31,965.00 |
| COMP_FOLD_LEAF_4ACC | `["min_qty"]` | PRICE_TYPE.01 | 48 | NULL | **7,000** | 41,110.00 |
| COMP_FOLD_LEAF_4GATE | `["min_qty"]` | PRICE_TYPE.01 | 48 | NULL | **7,000** | 41,110.00 |
| COMP_FOLD_LEAF_HALF | `["min_qty"]` | PRICE_TYPE.01 | 48 | NULL | **5,000** | 24,421.00 |

- 각 comp = **단일 접지방식**(48행 전부 같은 방식의 수량구간). 비수량 차원(siz/plt/print_opt/proc) 전부 NULL.
- 바인딩: 027·028·029 셋 다 PRF_DGP_E. comp는 3상품 **공유**(한 번 교정에 3상품 동시 해소).
- 배선: PRF_DGP_E formula_components에 4 FOLD_LEAF + COMP_COAT_*·COMP_PAPER·COMP_CUT_PERF·COMP_PRINT_DIGITAL_S1.
- 028 옵션그룹 0행(027/029는 5행) → 028 접지방식 선택 UI 부재(별 CPQ 트랙).

---

## 3. 교정 매핑 요약 — 무엇을 추가했나 (단가 불변 확인)

교정 = **(a) 단가행 proc_cd 충전 + (b) use_dims에 `"proc_cd"`+`"proc_grp:PROC_000056"` 토큰 등재**. 그게 전부.

| comp | (a) proc_cd 충전 | (b) use_dims 변경 | unit_price 변경 |
|------|-----------------|-------------------|:---:|
| 3FOLD | NULL → PROC_000060 (48행) | `["min_qty"]` → `["proc_cd","min_qty","proc_grp:PROC_000056"]` | **0 (불변)** |
| 4ACC | (§12/확인 후) | 동상 | **0** |
| 4GATE | (§12 등록 후) | 동상 | **0** |
| HALF | (§12 등록 후) | 동상 | **0** |

→ unit_price를 SET하는 구문 **0개**. 교정의 전부 = 판별축 충전으로 "택일 1개만 매칭" 만들기.

---

## 4. DRY-RUN 실증 결과 (P8-1 택일 분리)

라이브 트랜잭션 안에서 교정 적용 → P8-1 로직(pricing.py:444-475 충실) SQL 재현 → ROLLBACK.

| 단계 | 시나리오 | 접지비 합산 | 판정 |
|------|---------|:----------:|:---:|
| **BEFORE** | 현 라이브(proc_cd NULL·is_proc=False) → 4개 자동합산 | **25,000** (6000+7000+7000+5000) | ✅ 명세 일치(과대 입증) |
| **AFTER 부분교정** | 3FOLD만 교정·3단 택일 → 미교정 3개 여전히 자동합산 | **25,000** (미해소) | ⚠️ **부분교정 무효** |
| **AFTER 전체교정 what-if** | 4개 모두 proc_cd 충전 가정·3단 택일 | **6,000** (3단만·나머지 proc 불일치 탈락) | ✅ **25,000→6,000 분리 실증** |

**★결정적 발견 (정직)**: 4 comp 중 **1개만 교정하면 P8-1 효과 0** — `is_proc`는 comp별 판정이라, 미교정 comp는
여전히 자동합산된다. **4개 전부 proc_cd 충전돼야 비로소 25,000→6,000 분리됨.** 따라서 3FOLD만 적재(부분)는
돈영향 미해소 → **전체를 묶어 BLOCKED 처리**가 정확. 3개 BLOCKED 해소(§12)가 **교정 완성의 선행 전제**.

- `evaluate_price` 실호출 폴백 사유: 시스템 python에 Django/psycopg 미설치·webadmin venv 부재. P8-1 로직을
  SQL로 충실 재현(NON_QTY_DIMS 매칭·is_proc 분기 동일). Django 환경 확보 시 `dryrun_evaluate.py`로 동일 실증 가능.

---

## 5. verbatim 게이트 — 통과 여부

| 검증 | 결과 |
|------|------|
| apply.sql 내장 G-1 가드(적재 전후 행수·합 동일) | ✅ **PASSED** ("VERBATIM GUARD PASSED" NOTICE) |
| 교정 후 4 comp 단가행 합 | 31,965 / 41,110 / 41,110 / 24,421 — **전부 불변** |
| unit_price를 SET하는 구문 수 | **0** |

→ **verbatim 게이트 통과.** 교정은 proc_cd·use_dims만 분화, 단가 숫자 0변경.

---

## 6. 판정 종합

- **C-2 = 부분 BLOCKED**: proc_grp 모델 작동 가능·3단접지(PROC_000060) 실재. 그러나 4단대문접지·반접지 코드
  라이브 전무, 4단병풍접지 부분매칭 → **3개 §12 선행 필요**.
- **부분 적재 무효**: P8-1은 4개 전부 교정돼야 분리 → 3FOLD 단독 적재는 돈영향 미해소(DRY-RUN 입증).
- **전체교정 시 25,000→6,000 분리·verbatim 불변 실증** → 메커니즘·교정 방향은 **검증 완료**. 막힌 것은 코드 실재뿐.
- 실 COMMIT 없음 — 인간 승인 + §12 코드 등록 후 apply.sql STEP 2~4 주석 해제하여 실행.
