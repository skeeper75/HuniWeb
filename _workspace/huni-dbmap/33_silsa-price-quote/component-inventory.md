# 가격 구성요소 전수 실측 + 통합 진단 — round-23 (항목 1·4)

> 작성 2026-06-17 · **생성자(auditor) 산출 — 자기 GO 판정 금지**(검증은 dbm-validator 별도).
> 권위: 라이브 `db railway` `t_prc_*` 읽기전용 SELECT 실측(비밀번호 비노출·DB 쓰기 0).
> 입력 재사용: round-17 `21_price-formula-audit/formula-inventory.md`(16공식·frm_typ_cd 라이브 부재).
> ★실측 시점 주의: 오시·귀돌이·가변텍스트/이미지의 단가행 `reg_dt`가 **2026-06-17(오늘) 신규 적재** — 통합 마이그레이션이 **진행 중인 스냅샷**을 포착함. 미싱은 2026-06-06/16 혼재.

---

## 0. 핵심 스키마 사실 (재현 근거)

- `t_prc_component_prices` 컬럼: `comp_price_id(PK)·comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·unit_price·proc_cd·opt_cd·dim_vals(jsonb)·print_opt_cd·plt_siz_cd`.
- 단가형/합가형 = `t_prc_price_components.prc_typ_cd` (`PRICE_TYPE.01`=단가형 / `PRICE_TYPE.02`=합가형). 공식 레벨 유형(frm_typ_cd)은 **라이브 부재**(round-17 §0 확정).
- 줄수/개수 같은 "파라미터"를 담는 신축은 **`dim_vals` jsonb**(예: `{"줄수":1}`, `{"개수":2}`). 구축은 별도 `_2L/_3L` comp 또는 `opt_cd`로 표현 — **요소마다 방식이 제각각**(통합 진단의 핵심).

---

## 1. 8종 구성요소 라이브 현황 표

배선공식 = `formula_components` 조인 · 단가행 = `component_prices` 행수 · 상태 판정은 §3 범례.

| # | 구성요소 | comp_cd | comp_nm | prc_typ | 차원(use_dims / dim_vals) | note 가독성 | 배선공식 | 단가행 | 상태 |
|---|---------|---------|---------|:--:|---|:--:|---|:--:|:--:|
| 1 | **제본비** | COMP_BIND_TWINRING 외 11종 | 제본비/제본비(후가공)[코드]/캘린더 제본비/하드커버 제본비 | .01 단가형 | proc_cd·min_qty·proc_grp:PROC_000017 | 🟡 7종 comp_nm에 코드 노출 | **JUNGCHEOL만 PRF_BIND_SUM** | 6~32 | 🔴 11중 10 미배선 |
| 2 | **디지털인쇄비** | COMP_PRINT_DIGITAL_S1 / _S2 | 디지털인쇄비 출력비 / 디지털인쇄비 | .01 단가형 | proc_cd·plt_siz_cd(S1)/siz_cd(S2)·print_opt_cd·min_qty·proc_grp:PROC_000001 | ✅ 흑백/칼라·단/양면 명시 | PRF_DGP_A~F (6공식) | 212 / 212 | ✅ OK |
| 3 | **별색인쇄비** | COMP_PRINT_SPOT_{CLEAR/GOLD/PINK/SILVER/WHITE}\_{S1,S2} 10종 | 별색인쇄비 클리어/금색/핑크/은색/화이트(단/양면) | .01 단가형 | plt_siz_cd·**proc_cd**·print_opt_cd·min_qty·**proc_grp:PROC_000007** | ✅ 색·면 명시 | PRF_DGP_A | 53(×9) / **530(WHITE_S1)** | 🟡 공정확정·WHITE_S1 중복 |
| 4 | **오시(creasing)** | COMP_PP_CREASE_1L / _2L / _3L | 오시비 / 오시 2줄 / 오시 3줄 | .01 단가형 | proc_cd·min_qty·proc_grp:PROC_000029 / **dim_vals.줄수** | ✅ "오시(접는 줄) N줄" | PRF_DGP_A,PRF_DGP_D | 30 / 10 / 10 | 🟡 **부분통합(1L에 줄수1/2/3 다 들어감 + 2L/3L 레거시 잔존)** |
| 5 | **미싱(perforation)** | COMP_PP_PERF_1L / _2L / _3L | 미싱비 / 미싱 2줄 / 미싱 3줄 | **1L=.02 / 2L·3L=.01** | 1L: **opt_cd(OPV-000007/8/9)**·opt_grp:OPT-000005 / 2L·3L: min_qty만(무축) | ✅ "미싱(점선 절취) N줄" | PRF_DGP_A,PRF_DGP_D | 30 / 10 / 10 | 🔴 **통합방식 불일치(1L=opt축+.02, 2L/3L=무축+.01)** |
| 6 | **귀돌이(round corner)** | COMP_PP_CORNER_ROUND / (COMP_PP_CORNER_RIGHT) | 모서리 둥근 / 모서리 비(직각) | .01 단가형 | proc_cd·min_qty·proc_grp:PROC_000026 | 🟡 "모서리 둥근/비" 모호 | PRF_DGP_A,PRF_DGP_D | 9 / 18 | 🟡 둥근·직각 2 comp 분리 |
| 7 | **가변텍스트** | COMP_PP_VARTEXT_1EA / _2EA / _3EA | 가변텍스트 / 2개 / 3개 | .01 단가형 | proc_cd·min_qty·proc_grp:PROC_000085 / **dim_vals.개수** | ✅ "가변 텍스트 N개" | PRF_DGP_A,PRF_DGP_D | 69 / 23 / 23 | 🟡 **부분통합(1EA에 개수1/2/3 다 들어감 + 2EA/3EA 레거시 잔존)** |
| 8 | **가변이미지** | COMP_PP_VARIMG_1EA / _2EA / _3EA | 가변이미지 / 2개 / 3개 | .01 단가형 | proc_cd·min_qty·proc_grp:PROC_000085 / **dim_vals.개수** | ✅ "가변 이미지 N개" | PRF_DGP_A,PRF_DGP_D | 69 / 23 / 23 | 🟡 **부분통합(1EA에 개수1/2/3 + 2EA/3EA 레거시 잔존)** |

### 실측 증거 (재현 쿼리)
- 별색=공정 입증: `SELECT comp_cd,clr_cd,proc_cd FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_SPOT_GOLD_S1'` → **clr_cd 공백·proc_cd=PROC_000011** (메모리 "별색=공정·clr_cd=NULL" 라이브 확정).
- 오시 부분통합: `COMP_PP_CREASE_1L` min_qty=1 행 3개 = `dim_vals {"줄수":1}/{"줄수":2}/{"줄수":3}` (comp_price_id 8189/8209/8219, note "오시/1줄·2줄·3줄"). **단가행 차원으로는 통합 완료, comp 행으로는 미통합**.
- 미싱 줄수 = `COMP_PP_PERF_1L.opt_cd` OPV-000007/8/9 (미싱 1/2/3줄). 2L/3L은 opt_cd·dim_vals 모두 비어 무축.
- 가변 통합: `COMP_PP_VARTEXT_1EA` 69행 = `dim_vals.개수` 1/2/3 × 23구간.

---

## 2. 통합 후보 보드 (항목 4)

판별 기준(작업 지시): **같은 prc_typ_cd + 같은 차원축 + 단지 줄수/단계만 다른 파라미터형** → 하나의 comp + 차원값(`dim_vals`)으로 흡수. 무리한 통합(의미 손실) 금지.

| 후보 | 현재 분리행 | 통합안 | 근거 / 차원 흡수 방식 | 우선순위 |
|------|------------|--------|----------------------|:--:|
| **C-1 오시 줄수** | CREASE_1L / 2L / 3L (3 comp) | **CREASE_1L 하나로** (이미 dim_vals.줄수 1/2/3 보유) | 1L이 이미 줄수 1/2/3을 dim_vals로 다 담음(30행). 2L(줄수2 10행)·3L(줄수3 10행)은 **중복 잔존 레거시** → 폐기(use_yn=N). 같은 PROC_000029·.01·작업1건고정 = 진짜 동질 | **High** |
| **C-2 가변텍스트 개수** | VARTEXT_1EA / 2EA / 3EA (3 comp) | **VARTEXT_1EA 하나로** (이미 dim_vals.개수 1/2/3 보유) | 1EA가 개수 1/2/3 다 담음(69행). 2EA/3EA(각 23행)는 중복 레거시. 동질(PROC_000085·.01·작업1건고정) | **High** |
| **C-3 가변이미지 개수** | VARIMG_1EA / 2EA / 3EA (3 comp) | **VARIMG_1EA 하나로** (이미 dim_vals.개수 1/2/3 보유) | C-2와 완전 동형 | **High** |
| **C-4 미싱 줄수** | PERF_1L / 2L / 3L (3 comp) | **PERF 단일 comp + dim_vals.줄수** (오시와 동형으로 통일) | 1L은 opt_cd(OPV-000007/8/9)로 줄수, 2L/3L은 무축 → **방식 불일치**. 오시·가변과 동일하게 dim_vals.줄수로 재정규화하면 1 comp로 통합. ★단 1L prc_typ=.02, 2L/3L=.01 **불일치도 동시 교정 필요** | **High** |
| **C-5 귀돌이 형상** | CORNER_ROUND / CORNER_RIGHT (2 comp) | **CORNER 단일 comp + dim_vals.형상(둥근/직각)** | 둘 다 PROC_000026·.01·작업1건고정·동일 수량구간축. 형상만 다른 파라미터형 → dim_vals로 흡수. ⚠️중간단계: ROUND=PROC_000028, RIGHT=PROC_000027·028 혼재 → proc_cd 정합 선행 | Medium |
| **C-6 별색 색상** | SPOT_{CLEAR/GOLD/PINK/SILVER/WHITE}_{S1,S2} (10 comp) | **검토만** — 통합 보류 권고 | 색상은 dim_vals 후보지만 ① 색마다 단가표 다르고 ② 단/양면(S1/S2)은 이미 PRF_DGP_A 내 별 comp로 운용 중. 색=clr_cd 차원 흡수는 의미상 가능하나 **현행 운영(공식 배선) 안정성 우선 → 별트랙**. 무리한 통합 금지 원칙 적용 | Low(보류) |

### 통합 비후보 (동질 아님 — 통합 금지)
- 제본 11 comp: proc(중철/무선/PUR/트윈링/하드커버/캘린더…) **공정 종류 자체가 다름** → 줄수형 파라미터 아님. dim_vals 흡수 부적합(별색 색상보다도 이질). 통합 대상 아님.
- 디지털인쇄 S1/S2: 단면/양면은 별 comp 유지가 현 공식 배선과 정합 — 통합 불요.

---

## 3. 갭 보드 — 실사 견적에 필요하나 라이브에 결함

상태 범례: 🔴 결함 · 🟡 주의 · OK 정상.

| ID | 결함 | 실측 | 영향 | 등급 |
|----|------|------|------|:--:|
| **G-1 별색 WHITE_S1 단가행 10배 중복** | COMP_PRINT_SPOT_WHITE_S1 **530행** vs 형제(GOLD/PINK/…) 각 53행 | 같은 (plt_siz_cd·print_opt_cd·min_qty) 키에 **5중복** (`HAVING count(*)>1` 다수) | 가격엔진이 어느 단가를 집을지 모호 → 화이트 별색 견적 비결정 | 🔴 |
| **G-2 미싱 통합방식 불일치** | PERF_1L=.02·opt축 / 2L·3L=.01·무축 (C-4) | prc_typ·차원축이 형제간 제각각 | 같은 "미싱 N줄"인데 엔진이 1L과 2L/3L을 다른 경로로 계산 → 단가/합가 혼선 | 🔴 |
| **G-3 제본 10/11 comp 고아(미배선)** | JUNGCHEOL만 PRF_BIND_SUM 배선, 나머지 10(무선·PUR·트윈링·하드커버3·캘린더4) 미배선 | `formula_components`에 미존재 | 책자·캘린더 등 제본 상품 다수가 가격원천 NONE → 실사/책자 견적 불가 (round-17 X-1 가격원천0 212상품의 일부) | 🔴 |
| **G-4 오시/가변 레거시 중복 comp** | CREASE_2L/3L·VARTEXT_2EA/3EA·VARIMG_2EA/3EA = 1L/1EA에 이미 dim_vals로 흡수됐는데 별 comp로 잔존 | reg_dt 2026-06-17 동시 적재(통합 중) | 같은 줄수/개수에 comp 2벌 → 배선·집계 중복 위험 | 🟡(통합으로 해소·C-1/2/3) |
| **G-5 제본 comp_nm 코드 노출** | 7종 comp_nm = "제본비(후가공) [COMP_BIND_…]" | comp_nm에 코드 그대로 | 실무진 화면에 코드 노출(round-17 B축 가독성 미달) | 🟡 |
| **G-6 귀돌이 comp_nm 모호 + proc_cd 혼재** | "모서리 둥근/모서리 비", RIGHT=PROC_000027·028 양쪽 | comp_nm "비"가 직각인지 불명 | 가독성·통합(C-5) 선행 정합 필요 | 🟡 |

### 실사 견적 직접 적용 메모
- 실사(포스터사인)는 **완제품 통가격**(COMP_POSTER_* 53행 PRC_COMPONENT_TYPE.06)으로 별도 트랙 — 위 8종(후가공/인쇄비) 중 실사에 직결되는 것은 **별색인쇄비·디지털인쇄비**가 아닌 포스터 통가격이 주. 단 실사에도 오시·미싱·귀돌이·가변이 후가공으로 붙을 수 있어 8종 정합이 실사 견적 정확성의 전제. G-1/G-2/G-3은 실사 외 상품군에도 공통 결함.

---

## 4. 비파괴 원칙 / 다음

- 본 산출은 **실측 + 통합 진단 + 갭 보드**까지. 실 교정(중복 삭제·comp 통합·배선 INSERT·prc_typ 정정)은 **인간 승인** 대상(round-5/dbm-load-execution).
- 통합 실행 시 권장 경로: dim_vals 흡수형(C-1~C-4)은 1L/1EA를 정본으로, 레거시(2L/3L·2EA/3EA)는 use_yn=N + 배선 재지정. **단가행 재적재 0**(이미 정본에 존재).
- G-1(WHITE 중복)·G-2(미싱 불일치)는 통합과 별개로 **선결 데이터 정합** 필요 — 통합 전 단가 비결정 제거.
