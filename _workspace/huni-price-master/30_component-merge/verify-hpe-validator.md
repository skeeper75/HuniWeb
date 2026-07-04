# hpe-validator 독립 검증 — 유형 A 병합·재배선 9군 (E1~E7 게이트)

> **검증가:** hpe-validator (Claude측·생성≠검증). **방법론:** hpe-design-validation.
> **대상:** `merge-rewire-manifest.md` + `_dryrun/mc-0{1..9}-*.sql` (읽기전용 검증·DB 미적재).
> **독립 실측 근거:** ① live-snapshot latest CSV(2026-07-02) 결정론 재계산 ② **라이브 Railway DB 읽기전용 SELECT 재실측**(2026-07-04) ③ 엔진 계약 `raw/webadmin/webadmin/catalog/pricing.py` 직접 대조.
> **생성자 주장 비신뢰:** 매니페스트의 라이브 07-03 병합 주장·nat_key 충돌0·골든값을 designer 산출로 받지 않고 스냅샷+라이브+엔진에서 직접 재실측함.

---

## 0. 9군 종합 판정표

| 군 | 정본 | E2 분해정합 | E4 mint/FK/채번 | E6 골든(오차0) | 재배선정합 | 판정 |
|---|---|---|---|---|---|---|
| MC-01 PCB | COMP_PCB | PASS | PASS | PASS | PASS | **GO(조건부)** — 라이브 실측 확인됨·조건 1건 |
| MC-02 PREMIUM | COMP_NAMECARD_PREMIUM | PASS | PASS | PASS | PASS | **GO** |
| MC-03 FOIL | COMP_NAMECARD_FOIL | PASS | PASS | PASS | PASS | **GO** |
| MC-04 WHITE | COMP_NAMECARD_WHITE | PASS | PASS | PASS | PASS | **GO** |
| MC-05 STD | COMP_NAMECARD_STD | PASS | PASS | PASS | PASS | **GO** |
| MC-06 COAT | COMP_NAMECARD_COAT | PASS | PASS | PASS | PASS | **GO** |
| MC-07 PEARL | COMP_NAMECARD_PEARL | PASS | PASS | PASS | PASS | **GO** |
| MC-08 SHAPE | COMP_NAMECARD_SHAPE | PASS | PASS | PASS | PASS | **GO** |
| MC-09 MINISHAPE | COMP_NAMECARD_MINISHAPE | PASS | PASS | PASS | PASS | **GO** |

**전체: GO 8 + 조건부 GO 1(MC-01). NO-GO 0.** E1(공식추출)·E3(경쟁사)·E5(세트) = 본 병합에 N/A(라이브 comp 재배치·경쟁사 유입 0·세트 없음). E7(독립성) = PASS(전 주장 라이브/스냅샷/엔진 재실측으로 교차).

---

## 1. E2 — 구성요소 분해 정합 / silent 이중합산 (전군 PASS)

**독립 재실측 결과(스냅샷 CSV 결정론 + 엔진 계약 대조):**

| 군 | 멤버행 | print_opt NULL | 분리축 NULL | nat_key(15열) 충돌 | 좌표 가격충돌 |
|---|---|---|---|---|---|
| MC-01 | 468 | 0 | 0(opt_cd·siz_cd) | 0 | 0 |
| MC-02 | 28 | 0 | 0(mat_cd) | 0 | 0 |
| MC-03 | 36 | 0 | 0(opt_cd) | 0 | 0 |
| MC-04 | 4 | 0 | 0(opt_cd) | 0 | 0 |
| MC-05 | 10 | 0 | 0(mat_cd) | 0 | 0 |
| MC-06 | 4 | 0 | 0(mat_cd) | 0 | 0 |
| MC-07 | 8 | 0 | 0(mat_cd) | 0 | 0 |
| MC-08 | 2 | 0 | 0(siz_cd) | 0 | 0 |
| MC-09 | 2 | 0 | 0(siz_cd) | 0 | 0 |

**silent 이중합산 불가 — 엔진 계약 3중 증명(pricing.py 직접 대조):**
1. **분리축이 전부 정확매칭 차원** — `NON_QTY_DIMS`(L42)에 print_opt_cd·mat_cd·opt_cd·siz_cd 등재. `_row_matches`(L94)가 이 축으로 행을 정확히 가름.
2. **와일드카드 누출 없음** — `_row_matches`는 행 차원이 NULL이면 와일드카드. 위 표에서 전 분리축 NULL=0(라이브 재확인) → 어떤 선택도 정확히 1조합만 매칭.
3. **구조적 배타** — 두 상이 NON_QTY 조합이 단일 선택점에 동시매칭하려면 한쪽이 NULL(와일드카드)이어야 하는데 NULL=0. 설령 발생해도 `match_component`(L152)가 `len(combos)>1 → ERR_AMBIGUOUS`(치명·`_FATAL_ERRORS`·strict 차단)로 **차단**한다 — silent 합산 경로 자체가 없음.

**병합 전 상태도 이미 무-이중합산:** 멤버 격자가 disjoint(충돌0)라, 현재 공식이 4멤버를 모두 배선해도 단일 선택은 정확히 1멤버만 기여(타 멤버 no_match→0). 병합은 이를 1 comp/1행으로 정리할 뿐 가격 불변.

**의미축 이중인코딩 해소 확인:** 멤버 comp명에 하드코딩된 분리축(_S1/_S2·_MGA/_MGB·_STD/_HOLO)이 이미 단가행 컬럼(print_opt_cd·mat_cd·opt_cd)에 값으로 충전됨 → comp분리는 잉여. 병합이 차원컬럼 단일인코딩으로 환원. use_dims에 분리축 등재됨(재실측: 전군 확인).

---

## 2. E4 — search-before-mint / FK 위상 / 채번 (전군 PASS)

- **정본 미존재(clean mint 정당):** 라이브 SELECT 결과 9종 정본 comp_cd **전건 부재**(use_yn·del_yn 어느 행도 없음). 스냅샷도 동일. 기존 재사용 가능 base comp 0 → 신규 채번 정당.
- **채번 규약:** comp_cd = 분리축 접미사 제거한 명명 문자열(결정론 파생·MAX+1 아님). comp_typ_cd·use_dims·prc_typ 멤버 승계(신규 도메인코드 mint 0).
- **FK 위상정렬(DRY-RUN 검수):** ① 정본 INSERT(멱등 ON CONFLICT) → ② 단가행 comp_cd UPDATE(정본 실재 후) → ③ fc 멤버 DELETE + 정본 UPSERT + bystander disp_seq 재정렬 → ④ 멤버 use_yn=N·del_yn=Y·del_dt 논리삭제(hard-delete 금지). 순서상 FK 위반 없음.
- **FK 대상 실재(라이브):** 12 frm_cd(PRF_*) 전건 `t_prc_price_formulas`에 존재. bystander comp(PP_*·FOIL_*·NAMECARD_FOIL_SETUP_*) 참조 무결.
- **nat_key 멱등:** guard0가 이관 전 15열 nat_key 충돌 사전검증(0 기대)·단가행 UPDATE는 재실행 시 0건(멱등)·fc는 복합PK ON CONFLICT.
- **채번 충돌 0:** 정본 부재 확인으로 INSERT 충돌 없음.

---

## 3. E6 — 골든 재현 (허용오차 0·전군 PASS)

**단가값 verbatim 재추출(스냅샷 CSV) — designer 골든표와 전건 일치:**

| 군 | 선택 | 재실측 unit_price | 매니페스트 | 일치 |
|---|---|---|---|---|
| MC-05 | 단면/양면 MAT_000074 q100 | 3500 / 4500 | 3500 / 4500 | ✓ |
| MC-02 | S1_MGA/S1_MGB/S2_MGA/S2_MGB q100 | 4500/5000/5500/6500 | 동일 | ✓ |
| MC-03 | S1_STD q200 / S1_HOLO q200 / S2_STD q300 | 19200/24800/24800 | 동일 | ✓ |
| MC-04 | 단면코팅/무코팅·양면코팅/무코팅 | 16000/14500/19000/16000 | 동일 | ✓ |
| MC-06 | 단면 MAT_000081 / 양면 MAT_000082 | 5500 / 6800 | 동일 | ✓ |
| MC-07 | 단면/양면 MAT_000352 q100 | 9000 / 10000 | 동일 | ✓ |
| MC-08 | 단면/양면 SIZ_000008 q100 | 18000 / 19000 | 동일 | ✓ |
| MC-09 | 단면/양면 SIZ_000011 q100 | 16000 / 17000 | 동일 | ✓ |
| MC-01 | 단면20p SIZ_000003 q2 / 양면30p q2 | 11000 / 12500 | 동일 | ✓ |

**병합 전=후 동치 재계산(엔진 동치 재구현):** 병합은 comp_cd만 재지정(행 verbatim 불변)이고, 엔진은 차원값으로 행 매칭. 격자 disjoint(충돌0)·분리축 NON-NULL이므로 단일 선택은 병합 전후 동일한 단일 행 매칭 → 동일 unit_price → `component_subtotal` 동일.
- .01 단가형(MC-01): `unit_price×수량`. 예 11000×2=22000 (매니페스트 comp소계 일치).
- .02 합가형(MC-02~09): `unit_price÷tier_min_qty×수량`. 예 3500÷100×100=3500 (일치).
- **dodge-hunt:** 골든이 설계값 순환참조 아님(권위 격자 CSV verbatim 원천). off-grid/판걸이수 런타임 위장 없음(전 매칭이 정확값 축·min_qty 티어는 실 등재 구간).

---

## 4. MC-01 특수 — 라이브 07-03 병합 주장 독립 재실측 (조건부 GO 사유)

**생성자 주장(불신):** "라이브가 07-03 이미 IN-PLACE 병합됨·S1_20P가 전 468행 보유·3멤버는 고아 중복본." → 권위 스냅샷(07-02)은 **정반대**(4멤버 각 117행 disjoint 타일링)라 주장과 불일치 → **라이브 직접 SELECT로 독립 재판정 강제**:

| 라이브 SELECT(2026-07-04) | 결과 | 판정 |
|---|---|---|
| S1_20P 행수·조합 | **468행 / 4조합**(POPT1·2 × OPV491·492) | 주장 참 |
| S1_30P/S2_20P/S2_30P 각 행수 | **각 117 / 단일조합**(고아) | 주장 참 |
| PRF_PCB_FIXED 배선 | **S1_20P 단독**(disp_seq=1) | 주장 참 |
| COMP_PCB 존재 | **부재** | clean mint 여지 |
| 고아 351행 중 S1_20P에 부재(누락) | **0** | 무손실 |
| 고아 vs S1_20P 동좌표 가격충돌 | **0** | 무손실 |

→ **07-03 라이브 in-place 병합 주장은 라이브 실측으로 참으로 확인됨.** 고아 3멤버 351행은 전부 S1_20P 468행 안에 값-동일(0 누락·0 충돌)로 존재 → **DRY-RUN이 S1_20P만 468행 이관·고아 3멤버는 재이관 없이 tombstone 해도 가격커버리지 손실 0**.

**clean-mint 정합:** DRY-RUN이 옵션(a) 채택 = 신규 `COMP_PCB` 채번 + S1_20P 468행 이관 + PRF 재배선 + 4멤버 전건 논리삭제(S1_20P 포함). → 사용자 확정 "9군 전건 clean mint 일관"에 **정합**(라이브 in-place는 07-03 과도상태였고 DRY-RUN이 이를 clean-mint COMP_PCB로 교정). 별도 보정 불요.

**조건(GO의 전제):** MC-01 DRY-RUN의 정합성은 "S1_20P가 468행 보유·고아가 값-동일 중복"이라는 **현행 라이브 상태에 전적으로 종속**한다(권위 스냅샷 07-02 단독으로는 반증되는 상태). 따라서:
- **[필수] COMMIT 직전 재실측 하드게이트:** DRY-RUN 내 `'정본 COMP_PCB 단가행수(468기대)'` SELECT를 **advisory가 아니라 halt 조건**으로 격상(≠468이면 즉시 중단). 스냅샷 상태(4멤버 각 117 disjoint)로 되돌아간 DB에 이 DRY-RUN을 그대로 COMMIT하면 S1_20P의 117행만 이관·나머지 351행(양면·30p 전체=격자 3/4) tombstone → **언더차지/no_match**. 현 라이브에선 안전하나, 시점 종속 리스크를 게이트로 봉인해야 함.

---

## 5. 재배선 정합 (전군 PASS)

- **fc N→1 계정 일치(스냅샷 재실측):** MC-01 4→1(PRF_PCB_FIXED) · MC-02 8→2(PREMIUM·PREMIUM_FOIL 각 4멤버) · MC-03 4→1 · MC-04 4→1 · MC-05 4→2(FIXED·FIXED_FOIL 각 2) · MC-06 2→1 · MC-07 4→2 · MC-08 2→1 · MC-09 2→1. **매니페스트·보드 일치.**
- **단가행 재지정 계정:** 468+28+36+4+10+4+8+2+2 = **562건**(보드·매니페스트 일치).
- **disp_seq 재정렬 무충돌:** 정본=1, bystander=2,3,4…로 밀기(DRY-RUN [3b]). 정본과 bystander disp_seq 겹침 없음. addtn_yn='Y' 보존.
- **영향공식 누락 0:** PRF_NAMECARD_FIXED_FOIL은 **product 바인딩 0(라이브 확인)=고아 공식**이나 배선 일관성 위해 동일 재배선 — 무해(가격영향 상품 없음).
- **bystander 보존:** PP_*·FOIL_*·NAMECARD_FOIL_SETUP_* 는 병합 대상 아님(별개 원가항·의도 가산). 재배선에서 disp_seq만 조정·삭제 없음.

---

## 6. 컨펌큐 / 보정 요구

| # | 항목 | 대상 | 성격 |
|---|---|---|---|
| C1 | **[필수·MC-01]** DRY-RUN `468기대` SELECT를 COMMIT-halt 하드게이트로 격상(≠468 중단). 시점종속 데이터손실 봉인 | designer/executor | GO 전제조건 |
| C2 | **[승인]** MC-01 옵션(a) 재명명(S1_20P→COMP_PCB) 인간 승인 필요(매니페스트 §7.3에 별도 승인 명시) | 인간 | 승인 |
| C3 | **[cosmetic·후속]** 정본 comp_nm이 대표행 "…단면…" 승계라 병합 후 표시 어긋남(load-bearing 아님) → 표시명 정비 | dbm-price-arbiter | 비차단 |
| C4 | **[공통]** 전 9군 실 COMMIT은 군별 ROLLBACK→COMMIT 교체·물리백업·webadmin 시뮬레이터 실화면(PRICE≠0·병합 전후 동일가) 확인 후 | 인간+executor | 절차 |

---

## 7. 안전·독립성 확인 (E7 PASS)

- 라이브 **읽기전용 SELECT만** 수행(PCB 멤버 행수·조합·고아 무손실·정본 부재·FK 실재·drift). DB 쓰기·COMMIT·DDL **0**.
- designer 주장(라이브 병합·nat_key 충돌0·골든값·고아 중복)을 **그대로 채택하지 않고** 스냅샷 결정론 재계산 + 라이브 재SELECT + pricing.py 계약 대조로 **자기 실측 교차**. 특히 스냅샷과 어긋난 MC-01 라이브 주장을 라이브 직접 SELECT로 독립 재판정.
- 골든 순환참조(설계값으로 골든 제작) 없음 — 권위 CSV verbatim 원천.
- codex-validator 2차 판정은 보지 않음(독립성). 오케스트레이터 reconcile 대상.
- 비밀값 비노출(자격증명 `.env.local`만).

**종합: 유형 A 병합 9군 = GO 8 + 조건부 GO 1(MC-01, C1 하드게이트 조건). NO-GO 0. silent 이중합산 = 전군 구조적 불가(재실측 확인).**
