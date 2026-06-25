# 떡메모지(PRD_000097) 가격 바인딩 파일럿 — codex 독립 2차 교차검증 reconcile

생성: hsp-codex-verifier · codex=gpt-5.5(reasoning_effort=high·`-s read-only`) · 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh` · Claude 판정 비노출(독립성)·핵심 사실은 Claude가 라이브 SELECT 재실측해 codex에 제공 · **DB 미적재**(COMMIT 금지·읽기전용) · codex 주장=가설(라이브/권위로 확인된 것만 사실)

> 대상 = `t_prd_product_price_formulas` 1행 INSERT(097→PRF_TTEOKME_FIXED·apply_bgn_ymd=2026-06-01·ON CONFLICT (prd_cd,apply_bgn_ymd) DO NOTHING). 신규 mint 0.

---

## 0. 결론 요약

- **codex 가용**: gpt-5.5(high) 정상 호출·종료코드 0. 폴백 불요.
- **codex OVERALL = GO** (7축 중 6 GO + 1 CONFIRM-NEEDED[신규결함 #7]).
- **Claude ↔ codex 합의 = 6/6 핵심축 전건 일치**(바인딩·골든·차원·PK/멱등·false-positive·돈영향). divergence 0.
- **codex 신규 적발 = 3건**(전부 라이브 코드/데이터로 확인됨·전부 "097 바인딩 자체 결함 아님"·UI/게이트 경계 처리 항목):
  - N-1 competing temporal binding(다른 apply_bgn_ymd 재삽입은 충돌 안 함).
  - N-2 copies < 최소 min_qty 티어(=6) 시 동작.
  - N-3 off-grid(미등록 사이즈/장수 조합) 시 동작.
- **돈 안전**: 이 바인딩은 떡메 견적을 PRICE≠0으로 켜고, 다른 상품 무영향(코드/데이터 정합 확인). 단가 날조 0·이중합산 0.
- **권고**: 인간 게이트(hsp-set-gate S4)에서 CFM-097(apply_bgn_ymd) + N-1~N-3을 확인 후 COMMIT. 바인딩 1행 자체는 GO.

---

## 1. Claude ↔ codex 합의/불일치 (6 핵심축)

| 축 | codex 판정 | Claude 라이브 실측 사실 | reconcile |
|---|---|---|---|
| 1. 바인딩 정합 | **GO** — 097=고정가형 셋트 완제품, PRF_TTEOKME_FIXED→COMP_TTEOKME 단일 완제품 단가 = 권위 [수량행][옵션열] 정합 | PRF 실재(use_yn=Y)·formula_components 1건(COMP_TTEOKME·addtn_yn=Y)·권위 §1.4 고정가형 | **합의 GO**. 엉뚱한 공식 아님 |
| 2. 골든 정합 | **GO** — 2000×30=60,000·3200×6=19,200·verbatim 근거·098 비기여·이중합산 없음 | DB verbatim: 90x90/50/min30=2000·70x120/100/min6=3200(날조 0)·098 가격공식 0행·097 discount 0행 | **합의 GO**. 손계산 일치·날조 0·이중합산 0 |
| 3. 차원 매칭 | **GO** — use_dims=[siz_cd,bdl_qty,min_qty] 정합·골든 각 1행(모호성 0) | `golden1_match_rows=1`·`golden2_match_rows=1` 실측. ★pricing.py L43 `bdl_qty`∈NON_QTY_DIMS(정확매칭)·min_qty∈TIER_DIMS(티어) | **합의 GO**. 엔진 코드로 차원 의미 확인 |
| 4. PK/멱등 | **GO with guard** — ON CONFLICT (prd_cd,apply_bgn_ymd) = 실 PK 정합·멱등·2026-06-01=단가행 apply_ymd 정합·단 다른 ymd 재삽입은 미충돌(N-1) | 실 PK=(prd_cd,apply_bgn_ymd) 실측(frm_cd=비유니크 ix만)·112 단가행 apply_ymd 전건=2026-06-01·097 현재 0행 | **합의 GO**. apply.sql L14 ON CONFLICT 정합. N-1 가드는 §2 |
| 5. false-positive 가드 | **GO** — 097 READY 정당(신규 mint 0·전 참조행 라이브)·셋트라서 BLOCK은 false-positive | 신규 mint 0(PRF·comp·112행·배선 전부 라이브)·과보류 없음 | **합의 GO**. 과속 아님·과보류 아님 |
| 6. 돈영향/부작용 | **GO** — 097만 견적 ON·formula/comp/단가/타 바인딩 불변·타 상품 무영향 | INSERT 1행만(상품↔공식 연결)·공유 자원 미수정·t_prd_product_sets 불변 | **합의 GO**. 격리됨 |

**divergence = 0.** codex가 Claude와 독립으로(판정 비노출) 동일 결론 → 고신뢰.

---

## 2. codex 신규 적발 3건 (라이브 검증 후 처분)

> codex가 #7에서 제기. 전부 **확인됨**이나 **097 바인딩 1행의 결함은 아님** — UI/게이트/거버넌스 경계 항목. 바인딩 GO를 막지 않음.

### N-1. competing temporal binding (PK가 frm_cd 미포함)
- **codex 가설**: 다른 `apply_bgn_ymd`로 재삽입하면 (prd_cd, apply_bgn_ymd) PK가 충돌 안 함 → 같은 097에 경쟁 공식 바인딩이 미래에 생길 수 있음.
- **라이브 확인**: 사실. 실 PK=(prd_cd, apply_bgn_ymd)·frm_cd는 비유니크 ix만(실측). 본 INSERT의 ON CONFLICT는 **동일 apply_bgn_ymd** 재실행만 멱등 보장. 다른 ymd는 별행.
- **처분**: 본 파일럿 1행에 한해 **무해**(097 현재 0행·apply_bgn_ymd=2026-06-01 단일). 엔진은 `apply_ymd <= as_of` 중 최신을 택하므로(pricing.py match_component) 미래 다른 ymd 추가는 "시계열 교체"가 설계 의도. → **거버넌스 항목**(향후 바인딩 적재 시 effective-date 규칙 통제). 게이트 라우팅.

### N-2. copies < 최소 min_qty 티어(=6) 동작
- **codex 가설**: copies < 6 / 티어 사이 수량 처리 정의 필요·silent PRICE=0 회피.
- **라이브 코드 확인**: pricing.py L160-164 — 수량 티어에서 `이하 임계 없음`이면 `ERR_BELOW_MIN`(에러 반환·"최소 구간 미달=계산불가"). **silent 0 아님**(명시 에러). 티어 사이 수량은 "이하 최대 임계"(largest min_qty ≤ copies) 선택 — codex 가정과 코드 일치.
- **처분**: 엔진은 안전하게 **에러로 차단**(저청구 0). 다만 UI가 최소수량(6권) 미만 주문을 막아야 사용자 경험 정상. → **UI/제약 경계 항목**(097 바인딩 결함 아님). CONFIRM.

### N-3. off-grid(미등록 사이즈/장수 조합) 동작
- **codex 가설**: 미등록 size/sheets 선택 시 정의된 동작 필요(silent PRICE=0 회피).
- **라이브 코드 확인**: pricing.py — `_row_matches` 미매칭 → `no_match`(row=None) 또는 티어조합 행 없음 → `no_tier_row`(row=None). row=None이면 그 비목 0. COMP_TTEOKME가 단일 비목이라 **떡메 전체가 0이 될 수 있음**(고정가형 단일 comp 특성). 단가행은 siz 2종·bdl 2종만(실측)이라 그 밖 조합은 off-grid.
- **처분**: 이는 떡메 가격표(112행) 자체의 그리드 범위 문제이지 **바인딩 1행의 결함 아님**. UI가 등록된 사이즈(90x90·70x120)·장수(50·100)만 노출하면 off-grid 미발생. → **UI/제약 + 데이터 커버리지 경계 항목**. CONFIRM(가격표 그리드 완전성은 round-16 권위 검산 580=580로 무손실 확인됨).

---

## 3. 설계 문서 모순 1건 (Claude 적발 · codex 무관)

- `price-pilot-tteokme-design.md` §4 L145: "멱등 키 = 복합 PK(prd_cd, **frm_cd**, apply_bgn_ymd)"라고 적혀 있으나 — **실 PK는 (prd_cd, apply_bgn_ymd)**(frm_cd 미포함·라이브 pg_constraint 실측). 같은 문서 §2.5 L78·`apply.sql` L4-14·CSV는 **올바르게** (prd_cd, apply_bgn_ymd)로 ON CONFLICT 작성됨.
- **영향**: 실 적재 SQL(apply.sql)은 정확하므로 **COMMIT 안전**. §4 본문 1줄의 서술 오타. → 설계자 보정 권고(set-designer 라우팅·돈영향 0).

---

## 4. CFM-097 판단 (apply_bgn_ymd=2026-06-01)

- **사실**: COMP_TTEOKME 112 단가행 apply_ymd가 **전건 2026-06-01**(실측). 엽서북 094 바인딩과 동일 적용일(설계 주장).
- **판단**: apply_bgn_ymd=2026-06-01은 **단가행 적용일과 정합**(추정이 아니라 데이터 근거). 엔진은 `apply_ymd <= as_of` 필터를 쓰므로 바인딩 적용일이 단가행 적용일과 같거나 빠르면 안전. 2026-06-01=동일 → 안전.
- **잔여 확인**: 실무진/게이트가 "이 셋트의 영업 개시 적용일이 정말 2026-06-01인가"만 행정 확인하면 됨(데이터 정합은 입증). 돈영향 0(어차피 현재 097 다른 바인딩 0행).

---

## 5. 게이트/실무진 확인 필요 항목 (라우팅)

| ID | 항목 | 라우팅 | 차단성 |
|---|---|---|---|
| CFM-097 | apply_bgn_ymd=2026-06-01 영업 개시일 행정 확인 | 인간 게이트(hsp-set-gate) | 비차단(데이터 정합 입증·1행 무충돌) |
| N-1 | 향후 097 바인딩 effective-date 거버넌스(다른 ymd 경쟁 바인딩 통제) | 거버넌스/게이트 | 비차단(본 1행 무해) |
| N-2 | UI가 최소수량(6권) 미만 주문 차단(엔진은 에러로 안전) | UI/제약 트랙 | 비차단(엔진 silent 0 아님) |
| N-3 | UI가 등록 사이즈/장수만 노출(off-grid 회피) | UI/제약 + 데이터 커버리지 | 비차단(바인딩 결함 아님) |
| FIX-DOC | design §4 L145 "복합 PK(frm_cd 포함)" 서술 오타 보정 | set-designer | 비차단(apply.sql 정확) |

→ **차단 항목 0.** 전부 비차단(거버넌스/UI/문서 보정). 바인딩 1행 COMMIT은 게이트 S4(evaluate_set_price 재계산 60,000·19,200 독립 재현) GO + CFM-097 행정 확인 후 안전.

---

## 6. 방법·재현 (날조 0)

- codex 호출: `bash .claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh _workspace/huni-set-product/06_load/.codex-prompt-tteokme.md gpt-5.5 _workspace/huni-set-product high` (rc=0·48,771 tokens·session 019efd79).
- Claude 라이브 실측(2026-06-25 읽기전용 SELECT, `.env.local RAILWAY_DB_*`): PRF 정의·formula_components·COMP_TTEOKME(112행·siz2·bdl2·min 6..600·apply_ymd 전건 2026-06-01·proc/opt/clr 전건 NULL)·골든 단가행 verbatim(min30=2000·min6=3200·각 1행)·097 바인딩 0행·098 가격공식 0행·097 discount 0행·실 PK=(prd_cd,apply_bgn_ymd)·FK 양 타깃 실재·097=PRD_TYPE.01/del N·097→098 set member 실재.
- 엔진 계약 확인: `raw/webadmin/webadmin/catalog/pricing.py` L42-50(NON_QTY_DIMS에 bdl_qty 포함·TIER_DIMS=min_qty 등)·L82-99(_row_matches NULL 와일드카드/정확매칭)·L122-178(match_component 티어 선택·ERR_AMBIGUOUS/ERR_BELOW_MIN/no_tier_row)·L181(component_subtotal 단가형 ×qty).
