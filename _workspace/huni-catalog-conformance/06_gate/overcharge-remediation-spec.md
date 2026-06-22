# overcharge-remediation-spec.md — 과대청구 8건 교정 명세·정립 (dbm-price-arbiter)

> **§21 카탈로그 정합 — 과대청구 교정 명세** · 2026-06-23 · `huni-catalog-conformance/06_gate`
> 입력=확증 8건(`04_price_engine/overcharge-scan-catalog.md`·`.csv` + `05_codex/reconcile.md` OC 섹션, 8/8 합의·FP 0·환각 0).
> 본 문서 범위 = **"어떻게 고칠지" 정립·명세까지**. 실 COMMIT/적재 없음(인간 승인 후 dbmap 트랙 위임).
>
> ★[HARD] 제약 (전 항목 준수):
> - **단가값 verbatim 불변** — unit_price 숫자는 절대 안 바꾼다. 교정의 전부 = **판별차원 충전 + use_dims 등재**로
>   "둘/넷 중 하나만 매칭되게" 만드는 것. (예: 25,000 합산 → 3단 선택 시 6,000만 매칭. 6,000 숫자 불변.)
> - **기초코드(공유 마스터 t_mat/t_siz/t_prc 코드 마스터) 직접수정 금지** · **webadmin 코드(pricing.py) 직접수정 금지.**
> - 교정 대상 = 상품별 구성요소 배선(t_prc_formula_components) + 단가행 판별축(t_prc_component_prices) + use_dims(t_prc_price_components)만.
> - **클래스 B(공유 use_dims·공유 공식) 영향검토 필수.** 094 use_dims 공유 주의.

---

## 0. 교정 원리 — 왜 "판별차원 충전"이 교정의 전부인가 (engine-contract 근거)

silent 합산이 성립하는 인과(engine-contract `01_engine/engine-contract.md` 인용):

| 단계 | 명제 | 효과 |
|------|------|------|
| 1 | **P3-DEF**(:412-415) — use_dims 비수량 차원이 단가행 전부 NULL이면 `_row_matches` 모든 행 통과. 엔진은 `note="판별차원 없음…"` **경고만** 세팅(제외 안 함) | 판별축 NULL → 단/양면·접지방식 선택이 어느 행도 못 거름 |
| 2 | **P2-2**(자동매칭) — 각 comp가 selections와 매칭되면 자동 포함 | 같은 공식의 분리돼야 할 comp들이 전부 매칭행 보유 |
| 3 | **P3-8**(ERR_AMBIGUOUS는 comp 내부) — combo 2개+ 매칭 차단은 **한 comp_cd 안**에서만 | **별 comp_cd**라 P3-8 비해당 → 차단 안 됨 |
| 4 | **P2-3**(included 합산) — included=True 전부 합산 | silent 합산(경고 없음) |
| 가드 | **P8-1**(proc_sels 다중평가, :462-471) — use_dims에 `proc_cd` 있는 공정 comp는 proc_sels의 **선택된 공정만** 개별평가·합산 | proc_grp 토큰이 있으면 **택일이 정당 분리** = silent 합산 아님 |

→ **교정 = 위 1단계를 깬다.** 판별축에 값을 충전하고 use_dims에 등재하면 P3-DEF가 발화 안 하고,
   비선택 comp는 `_row_matches`에서 자연 탈락(P3-2 `_norm` 불일치). **단가 숫자는 손대지 않는다.**
   → 정합 reference: clean으로 입증된 디지털인쇄·별색·귀돌이·오시·미싱은 전부 proc_grp 토큰을 use_dims에 보유해 P8-1로 분리됨(scan §4).

---

## 1. 변종별 권고 교정안 (트레이드오프·심의)

### V1 — print_opt_cd(단/양면) NULL [OC-01·02·03 / 명함·엽서북]

**구조**: S1(단면)·S2(양면) comp가 같은 공식에 배선 + 단가행 `print_opt_cd` 전 행 NULL → 둘 다 매칭.

**권고 (단일안·대안 불요)**: `print_opt_cd`를 **단면/양면 양방향 충전** + use_dims 등재.
- 어느 comp가 단면/양면인지는 comp_cd suffix가 이미 명시(`_S1`=단면·`_S2`=양면) — 권위 판별 명확, mint 불요.
- t_prc_component_prices: S1 단가행 → `print_opt_cd='PRINT_OPT.01'`(단면), S2 단가행 → `print_opt_cd='PRINT_OPT.02'`(양면) 채움.
- t_prc_price_components: 두 comp의 use_dims에 `"print_opt_cd"` 토큰 추가.
- **단가값(3,500/4,500·11,000/11,500) 불변.** 손님이 단면 선택 → S1만 매칭(P3-2), S2 자연 탈락.
- 코드값 권위: PRINT_OPT.01/02는 라이브 기초코드 마스터에 실재하는지 **승인 전 확인 필요**(미실재 시 코드행 선적재는 기초코드 등록=거버넌스 §12 위임, 본 교정은 기존 코드 참조만). → **컨펌 C-1.**

### V2 — 접지방식 판별축 전무 [OC-04·05·06 / 접지카드·PRF_DGP_E]

**구조**: COMP_FOLD_LEAF_3FOLD/4ACC/4GATE/HALF 4개가 PRF_DGP_E에 배선 + use_dims=`["min_qty"]`만(proc_cd·opt_cd·proc_grp 전무) → 접지방식 택일인데 4개 다 합산.

**대안 비교 (3안):**

| 안 | 무엇 | 장점 | 단점·트레이드오프 |
|----|------|------|-------------------|
| **① opt_cd 신설** | 4 comp 단가행에 `opt_cd`(접지방식 코드) 충전 + use_dims 등재 | 명함(V1)과 동형·단순·이미 P3-DEF 메커니즘으로 1택 분리됨 | opt_cd는 "옵션 선택값" 단일축 — 향후 다른 공정과 동시 선택 시 충돌 가능성. CPQ 옵션그룹과 ref_dim_cd 연결 별도 필요 |
| **② proc_grp 토큰 부여(★권고)** | 4 comp에 `proc_cd`(각 접지공정) 충전 + use_dims에 `proc_grp:<접지그룹>` 토큰 등재 → **P8-1 proc_sels 다중평가로 정당 분리** | **엔진 기존 메커니즘 그대로 재사용**(코드 0수정)·디지털인쇄/별색/오시/미싱과 **동일 패턴**(scan §4 clean 입증분과 일치)·접지=택일 공정이라 의미축 정합·향후 다공정 확장 안전 | proc_cd 코드 마스터(t_prc 공정코드)에 접지방식 4종이 실재해야 함 → 미실재 시 기초코드 등록 선행(거버넌스 §12). proc_grp 그룹 코드 결정 필요 |
| **③ 공정 택일그룹(CPQ constraint)** | t_prd_product_constraints JSONLogic로 "접지 4 중 1택" UI 강제 | UI단 택일 보장 | **가격엔진은 UI 제약을 안 봄**(evaluate_price는 selections만 평가) → 백엔드 selections에 4개 다 들어오면 여전히 silent 합산. **가격 교정 아님**(UI 가드일 뿐) → 단독 부적합 |

**★권고 = ②(proc_grp 토큰 부여).** 근거:
1. 접지방식은 본질적으로 **택일 공정**(3단/4단아코디언/4단게이트/반접지) — 의미축이 proc(공정)이지 opt(범용옵션)가 아님. 스키마 설계의도 정합([[dbmap-schema-design-intent-first]]).
2. 엔진의 P8-1이 정확히 이 목적(공정 택일 다중평가)으로 존재 — clean으로 입증된 오시·미싱·귀돌이·디지털vs별색이 전부 같은 패턴(scan §4). **새 메커니즘 없이 기존 정합 패턴에 합류** = 위험 최소.
3. ③은 가격엔진 미적용이라 단독 무효, ①은 동작하나 의미축 오배치(opt에 공정 의미 강제) — 향후 부채.
- **단, proc_cd 4종·proc_grp 그룹코드가 라이브 공정 마스터에 실재하는지 확인 필요** → 미실재 시 코드 등록(거버넌스 §12)이 **선행 전제**. → **컨펌 C-2** (proc_grp 모델 채택 + 코드 실재 여부).
- 단가값(3단6,000·4ACC7,000·4GATE7,000·반접지5,000) 전부 verbatim 불변.

### V3 — 투명/일반 판별축 전무 [OC-07·08 / 포토카드·PRF_PHOTOCARD_FIXED]

**구조**: 상품이 024(일반)·025(투명)로 분리됐는데 **둘 다 같은 PRF_PHOTOCARD_FIXED 바인딩** + COMP_PHOTOCARD_SET·COMP_PHOTOCARD_CLEAR_SET 단가행 차원(siz_cd/bdl_qty/min_qty) 완전 동일·proc_grp 없음 → 둘 다 매칭.

**대안 비교 (2안):**

| 안 | 무엇 | 장점 | 단점·트레이드오프 |
|----|------|------|-------------------|
| **① 상품별 공식 분리(★권고)** | PRF_PHOTOCARD_FIXED를 **PRF_PHOTOCARD_NORMAL**(024 바인딩·SET comp만)·**PRF_PHOTOCARD_CLEAR**(025 바인딩·CLEAR_SET comp만)로 분리. 상품-공식 바인딩 재배선 | 가장 깨끗·각 상품이 자기 comp만 봄·판별 불요(공식 자체가 분리)·[[dbmap-price-chain-dwire-per-product-formula]] 정합(상품→공식 1:1) | 신규 공식 2개 mint + 바인딩 2개 재배선. 단 단가행/comp는 기존 재사용(verbatim) — comp 신규 0 |
| **② 투명여부 판별차원 추가** | 두 comp 단가행에 `opt_cd`(투명여부) 또는 신규 판별축 충전 + use_dims 등재. 공식은 1개 유지 | comp/공식 mint 최소 | **두 상품이 같은 공식 공유 유지** → 024/025 각각 selections에 투명여부를 정확히 주입해야 분리됨. 상품이 이미 물리적으로 분리됐는데 공식만 공유하는 부자연·판별축 누락 재발 위험·CPQ 옵션 연결 추가 필요 |

**★권고 = ①(상품별 공식 분리).** 근거:
1. 024·025는 **이미 별 상품(prd_cd 분리)** — 일반/투명은 상품 정체축이지 한 상품 내 옵션이 아님. 공식 1:1이 설계의도 정합.
2. comp·단가행은 기존 SET(6,000)·CLEAR_SET(8,500) **그대로 재사용**(verbatim) — 신규 공식 2개는 빈 그릇에 기존 comp 배선만. 날조 0.
3. ②는 한 공식 공유 유지라 "판별축 누락" 동형 재발 위험을 구조적으로 남김. ①은 공식 분리로 **그 위험 자체를 제거**.
- **기존 보드 MATCH 오분류 정정 반영**: price-engine-defect-board §0이 포토카드를 MATCH로 분류했으나 silent 합산 확정 → 본 교정으로 정정. → **컨펌 C-3** (공식분리 채택).
- 단가값(6,000·8,500) verbatim 불변.

---

## 2. 8건 교정 명세 (무엇·어느 t_*·어떻게·영향·트랙)

> 공통: 단가값 불변. 교정=판별축 충전+use_dims 등재(V1/V2) 또는 공식분리+바인딩 재배선(V3).
> t_* 약어: FC=t_prc_formula_components·PC=t_prc_price_components(use_dims 보유)·CP=t_prc_component_prices(단가행)·BIND=t_prd_product_price_formulas·FRM=t_prc_price_formulas.

| OC | prd | 변종 | 무엇을 | 어느 t_* (컬럼) | 어떻게 | 영향분석 | 클래스 | 트랙 |
|----|-----|:---:|--------|----------------|--------|----------|:---:|------|
| **OC-01** | 032 코팅명함 | V1 | print_opt_cd 충전 | CP(print_opt_cd)·PC(use_dims) | S1 각2행→PRINT_OPT.01·S2 각2행→PRINT_OPT.02·use_dims+`print_opt_cd` | **공유 주의**: COMP_NAMECARD_STD_S1/S2는 031·032 **공유 comp**. use_dims 변경=두 상품 동시 영향(둘 다 동일 교정 필요라 정합) | **B** | dbm-load-execution |
| **OC-02** | 031 프리미엄명함 | V1 | 동상 | 동상 | 동상 | OC-01과 같은 comp 공유 → 한 번 교정에 둘 다 해소(되돌리기=use_dims 토큰 제거+CP NULL 복원) | **B** | dbm-load-execution |
| **OC-03** | 094 엽서북 | V1 | print_opt_cd 충전(★양방향) | CP(print_opt_cd)·PC(use_dims) | S1_20P 117행→PRINT_OPT.01·S2_20P 117행→PRINT_OPT.02·use_dims+`print_opt_cd`. ★codex 신규: 양면 선택도 S1(11,000) 합산되므로 **양방향 충전 필수**(단면만 X) | **use_dims 공유 주의**: COMP_PCB_S1_20P/S2_20P가 094 전용인지 타 책자 공유인지 **승인 전 확인**(공유 시 동시 영향). 30p variant(S1_30P/S2_30P) 단가행 실재·미배선 → 30p 도달불가 별건(본 교정 범위 밖·라우팅만) | **B** | dbm-load-execution |
| **OC-04** | 027 2단접지 | V2 | proc_grp 판별축 신설(권고②) | FC·PC(use_dims+proc_grp 토큰)·CP(proc_cd) | 4 FOLD_LEAF comp에 proc_cd 충전+use_dims에 proc_grp 토큰 → P8-1 분리. 선택 접지만 proc_sels 평가 | **공유 comp 주의**: COMP_FOLD_LEAF_* 4개가 027/028/029 **공유**. 한 번 교정에 3상품 동시 해소(정합). proc_cd 마스터 실재 전제(미실재=거버넌스 §12 선행) | **B** | dbm-price-arbiter(proc_grp 모델 확정)→dbm-load-execution |
| **OC-05** | 028 미니접지 | V2 | 동상(옵션그룹 0행) | 동상 | 동상 + 접지방식 선택 UI 부재 → CPQ 옵션그룹 적재 별도 필요(가격 교정과 분리) | OC-04 공유 comp로 동시 해소. UI 옵션그룹 0행은 별 트랙(CPQ) | **B** | 동상 + dbm-cpq-option-mapping(옵션그룹) |
| **OC-06** | 029 3단접지 | V2 | 동상 | 동상 | 동상 | OC-04 공유 comp 동시 해소 | **B** | 동상 |
| **OC-07** | 024 포토카드 | V3 | 공식 분리(권고①) | FRM(신규 PRF_PHOTOCARD_NORMAL)·BIND(024 재배선)·FC(SET comp만 배선) | 신규 공식에 COMP_PHOTOCARD_SET만 배선·024 바인딩 교체. 단가행/comp 기존 재사용 | **공식 분리**: 기존 PRF_PHOTOCARD_FIXED는 025 전용으로 남기거나 폐기. comp는 024/025 전용이라 공유충돌 없음. 되돌리기=바인딩 원복+신규공식 del_yn=Y | **A** (상품별 구성요소·바인딩만·공유 마스터 무수정) | dbm-price-arbiter(공식분리 확정)→dbm-load-execution |
| **OC-08** | 025 투명포토카드 | V3 | 공식 분리(권고①) | FRM(신규 PRF_PHOTOCARD_CLEAR or 기존 재명명)·BIND(025)·FC(CLEAR_SET만) | 신규/재명명 공식에 COMP_PHOTOCARD_CLEAR_SET만 배선·025 바인딩 교체 | OC-07과 짝. 두 공식 분리로 구조적 silent 합산 제거 | **A** | 동상 |

**클래스 판정 근거:**
- **클래스 A (상품별 구성요소·바인딩만 손대면 됨)**: OC-07·08 포토카드. comp가 상품 전용(SET/CLEAR_SET)이고 교정이 공식 신설+바인딩 재배선에 국한 — 공유 마스터·타 상품 무영향.
- **클래스 B (공유 공식·공유 comp·공유 use_dims라 영향검토 필요)**: OC-01~06.
  - OC-01/02: COMP_NAMECARD_STD_S1/S2를 031·032 공유 → use_dims 변경이 두 상품 동시 영향(동일 교정이라 정합이나 **공유 자원 변경**).
  - OC-03: 094 use_dims 변경 — COMP_PCB_S1/S2_20P 타 책자 공유 가능성 **확인 필요**.
  - OC-04/05/06: COMP_FOLD_LEAF_* 4개를 027/028/029 공유 + proc_cd/proc_grp 코드 마스터 실재 전제 → 공유 comp + 기초코드 의존.

---

## 3. 돈영향 최종 수치 — 우선순위 (1단위·실수량 누적)

| 순위 | prd | 1단위당 과대 | 실수량 누적 (확정) | 근거 |
|:--:|-----|:-----------:|:------------------:|------|
| **1** | **027/028/029 접지카드** | **+18,000~20,000/장**(min_qty=1 구간) | **★100장 주문 시 ~수십만~180만원**(단가형 ×qty·100구간 +~1,030/장이면 ×100=+103,000/주문·소량 구간은 ×qty로 폭증) | min_qty=1 구간 4 접지비 합 25,000 − 선택 1개 = 3개분 과대(단가형 ×qty) |
| **2** | **094 엽서북** | **+11,500/장**(단면) / **+11,000/장**(양면) | 장당 누적(책자 다장 주문 시 ×장수) | S1 11,000+S2 11,500 둘 다 매칭(정답 택일). ★양방향(codex 신규) |
| **3** | **024 포토카드** | **+8,500/세트** | 세트당 | 일반6,000+투명8,500(정답 일반 6,000) |
| **4** | **025 투명포토카드** | **+6,000/세트** | 세트당 | 투명8,500+일반6,000(정답 투명 8,500) |
| **5** | **031/032 명함** | **+4,500/100매** | 100매 묶음당 | S1 3,500+S2 4,500(정답 단면 3,500)·MAT_000074 min_qty=100 |

★ **접지카드가 돈크리티컬 1순위 확정** — 단가형 ×qty라 수량 곱하면 누적 과대 최대(100장 ~180만원 가능). 게이트 권장: evaluate_price 실호출로 25,000 합산·14,500 합산을 독립 재계산해 최종 수치 비준.

---

## 4. 인간 승인 큐 (순서·각 건 무엇을 승인)

> 승인 순서 = 돈영향 우선순위 + 의존(코드 마스터 실재 확인) + 클래스(B는 공유영향 검토 후).

| # | 승인 대상 | 무엇을 승인 | 선행 확인 | 트랙 |
|:-:|-----------|------------|-----------|------|
| **A-1** | **C-2: V2 접지 proc_grp 모델 + 코드 실재** | proc_grp 부여안(권고②) 채택 여부 + proc_cd 4종·proc_grp 그룹코드가 라이브 공정 마스터에 실재하는지(미실재면 거버넌스 §12 코드등록 선행) | 라이브 공정 마스터 SELECT(proc_cd 실재) | dbm-price-arbiter→dbm-load-execution (+미실재 시 §12) |
| **A-2** | **OC-04~06 단가행 교정 적재** | 4 FOLD_LEAF comp proc_cd 충전+use_dims proc_grp 등재(단가값 불변)·공유 comp(027/028/029 동시 해소) | A-1 모델 확정 | dbm-load-execution |
| **A-3** | **OC-03 094 양방향 충전** | print_opt_cd S1=01·S2=02 충전+use_dims 등재(양방향)·COMP_PCB use_dims 타 책자 공유 여부 확인 후 | 094 comp 공유범위 SELECT + C-1(PRINT_OPT 코드 실재) | dbm-load-execution |
| **A-4** | **C-3: V3 포토카드 공식분리** | PRF_PHOTOCARD_NORMAL/CLEAR 신설+024/025 바인딩 재배선(comp/단가행 재사용)·MATCH 오분류 정정 | (클래스 A·공유충돌 없음) | dbm-price-arbiter→dbm-load-execution |
| **A-5** | **OC-01~02 명함 print_opt_cd 충전** | S1=01·S2=02 충전+use_dims 등재·공유 comp(031/032 동시) | C-1(PRINT_OPT 코드 실재) | dbm-load-execution |
| **A-6** | **(별건·동시) OC-05 접지 CPQ 옵션그룹** | 028 접지방식 선택 UI(옵션그룹 0행) 적재 — 가격 교정과 분리 | A-1 후 | dbm-cpq-option-mapping |

**컨펌(승인 전 결정 필요):**
- **C-1**: PRINT_OPT.01/02 코드값이 라이브 기초코드 마스터에 실재하는가(V1·V2 공통 전제). 미실재 시 코드 등록=거버넌스 §12.
- **C-2**: V2 = proc_grp(권고②) vs opt_cd(①) 채택 + proc_cd 4종·proc_grp 그룹코드 실재 여부.
- **C-3**: V3 = 상품별 공식분리(권고①) vs 투명 판별차원(②) 채택.

---

## 5. 주의 — 공유자원 영향·되돌리기 난이도

| 항목 | 주의 | 되돌리기 난이도 |
|------|------|----------------|
| **OC-04~06 공유 comp** | COMP_FOLD_LEAF_* 4개가 027/028/029 **공유** — 단가행 proc_cd 충전이 3상품 동시 영향(다행히 동일 교정이라 정합). 단 **proc_cd/proc_grp 코드 마스터 직접수정 금지**(공유 마스터) — 미실재 시 거버넌스 §12 선행 | **중**: use_dims 토큰 제거+CP proc_cd NULL 복원. 단 코드 신규등록 했으면 그 코드는 §12 롤백 별도 |
| **OC-01~03 use_dims 공유** | COMP_NAMECARD_STD_S1/S2(031·032 공유)·COMP_PCB_S1/S2_20P(094, 타 책자 공유 가능성) — use_dims 변경=공유 comp 변경이라 **타 상품 견적 동시 변동**. 094는 **승인 전 공유범위 SELECT 필수** | **하**: use_dims 토큰 제거+CP print_opt_cd NULL 복원(가역) |
| **OC-07~08 공식분리(클래스 A)** | 신규 공식 mint+바인딩 재배선 — comp/단가행은 재사용(verbatim)이라 공유충돌 없음. 단 기존 PRF_PHOTOCARD_FIXED 처리(폐기 vs 025 잔존) 결정 필요 | **하**: 바인딩 원복+신규공식 del_yn=Y(논리삭제·가역). [[dbmap-del-yn-soft-delete-authority]] |
| **★단가값 불변 게이트** | 전 교정에서 unit_price 숫자 변경 0이어야 함. 적재 전후 단가행 합 동일성(판별축만 분화) 검증 필수 | — |
| **CPQ 옵션그룹 0행(028)** | 가격 교정과 **분리** — 028은 접지방식 선택 UI 자체 부재라 가격 교정해도 손님이 못 고름. CPQ 트랙 병행 | — |
| **webadmin 코드 미변경** | pricing.py P3-DEF/P8-1 메커니즘은 정상 — 교정은 **데이터(판별축 충전)만**으로 충분. 코드 직접수정 금지 | — |

---

## 6. 다음 액션 — 승인 시 어느 트랙이 적재

- **V1(OC-01·02·03)** → 승인(A-3·A-5) 후 **dbm-load-execution**(print_opt_cd 충전+use_dims 등재·멱등 UPSERT·단가값 불변 검증).
- **V2(OC-04·05·06)** → 모델 확정(A-1·dbm-price-arbiter로 proc_grp vs opt_cd 심의 종결) 후 **dbm-load-execution**(proc_cd/use_dims 교정). proc_cd 코드 미실재 시 **거버넌스 §12(hbg)** 코드등록 선행. 028 옵션그룹은 **dbm-cpq-option-mapping** 병행.
- **V3(OC-07·08)** → 공식분리 확정(A-4·dbm-price-arbiter) 후 **dbm-load-execution**(신규 FRM+BIND 재배선·comp 재사용).
- **게이트 비준(권장)**: 적재 전 hcc-conformance-gate가 evaluate_price 실호출로 교정 후 "1택만 매칭"을 독립 재계산(접지 25,000→6,000·포토 14,500→6,000/8,500·명함 8,000→3,500) 검증.

> 실 COMMIT/DDL은 **전부 인간 승인 후**. 본 명세는 정립까지. webadmin 코드 직접수정·기초코드 마스터 직접수정 금지.
