# 차원정합 UNDECLARED 교정명세 + REVIEW 41 triage (2026-06-30)

입력: `dim-conformance-fullscan-260630.tsv` (UNDECLARED 4행 · MISSING-REVIEW 41행)
라이브 읽기전용 SELECT + 시뮬레이터 실호출(읽기). use_dims/단가행 수정은 dryrun(BEGIN/ROLLBACK)까지 — 실 COMMIT 인간 승인 후 §7 dbmap.

## 핵심 발견 — 엔진의 진짜 매칭 규칙 (dim_conformance 전제 정정)

`pricing.py:94 _row_matches` 는 **use_dims 와 무관하게 단가행에 채워진(NON_QTY_DIMS) 모든 컬럼**을 손님 선택과 정확매칭한다(NULL=와일드카드). use_dims 는 매칭이 아니라 **(a) UI 노출**(`price_views.py:1411` `prod_dims = union(전 component use_dims)`)과 (b) 진단에만 쓰인다.

따라서 UNDECLARED("silent 가산")의 원래 가설(엔진이 미선언 컬럼을 무시→가산)은 이 엔진엔 **틀렸다**. 실제 위험은 반대 방향 두 가지다:
1. 단가행에 채워진 차원이 **어느 component use_dims 에도 없으면** → 그 차원 드롭다운 미노출 → 손님 선택 불가 → 행이 절대 매칭 안 됨 → **견적불가/저청구**.
2. 단가행에 **상수 태그 컬럼**(예 proc_cd=PROC_000080)이 채워졌는데 손님 선택맥락엔 그 값이 안 들어옴 → 행 매칭 실패 → 해당 component **silent 드롭** → **저청구**.

---

## UNDECLARED 4행 → 진짜 2 / FP 1 (COAT=2행 1상품)

### 🔴 [진짜] PRD_000032 코팅명함 — COMP_NAMECARD_COAT_S1·S2 print_opt_cd
- **현 use_dims** `["mat_cd","min_qty"]` · 단가행 print_opt_cd 채워짐(S1=POPT_000001 단면, S2=POPT_000002 양면).
- **자매 명함 전건**(STD·PEARL·PREMIUM·SHAPE·WHITE·MINISHAPE)은 모두 use_dims 에 print_opt_cd 선언 + 단가행 POPT 충전. **COAT 만 use_dims 누락** = 명백 이상치(코팅 COMMIT namecard-orphan-260630 이 단가행엔 print_opt 넣고 use_dims 갱신 누락).
- **효과(시뮬 실증):** print_opt 미선택 시 S1·S2 둘 다 매칭 실패 → **final_price=0(견적불가)**. print_opt 수동 주입 시만 단면5500/양면6500 정상. 즉 print_opt_cd 가 use_dims 에 없어 단면/양면 드롭다운이 노출 안 됨 → 손님이 못 고름 → 0원. (메모리 "사후검증 5500/6500"은 print_opt 수동 주입으로 노출결함을 가렸음.)
- **돈영향:** 견적불가/저청구(0원). 과금 위험 아님(둘 다 매칭 실패라 이중합산도 없음).
- **공유:** COAT_S1/S2 → PRF_NAMECARD_COAT → PRD_000032 **단독**. 교차영향 0.
- **교정(배선·단가 무변):**
  - before `["mat_cd","min_qty"]` → after `["mat_cd","min_qty","print_opt_cd"]` (STD 자매와 동형)
- **dryrun(검증완료·ROLLBACK):**
```sql
UPDATE t_prc_price_components SET use_dims='["mat_cd","min_qty","print_opt_cd"]'::jsonb, upd_dt=now()
 WHERE comp_cd IN ('COMP_NAMECARD_COAT_S1','COMP_NAMECARD_COAT_S2');  -- UPDATE 2
```
- **사후 예상:** 단면/양면 드롭다운 노출 → 단면 5500/5800·양면 6500/6800(아트지250/300) 정상(매칭 로직 이미 실증).

### 🔴 [진짜] PRD_000124 린넨현수막 — COMP_POSTEROPT_LINEN_FINISH proc_cd
- **현 use_dims** `["opt_cd","min_qty"]` · 단가행 opt_cd(마감종류) **+ proc_cd=PROC_000080 5행 전건 상수** 채워짐.
- 자매 마감 component(WOODHANGER·WOODBONG)는 proc_cd **NULL**. LINEN_FINISH 만 proc_cd 채움 = 이상치.
- **효과(시뮬 실증):** PRF_POSTER_LINEN 엔 proc_cd 를 use_dims 로 쓰는 component 없음 → proc_cd 드롭다운 미노출 → 손님은 마감을 opt_cd 로만 선택. 그런데 단가행이 proc_cd=PROC_000080 도 요구 → 매칭 실패 → 마감비 **silent 드롭**.
  - opt_cd=OPV_000026(말아박기) 단독 → 마감 sub=0 (총 17000, 가산 안 됨)
  - opt_cd + proc_cd=PROC_000080 동시 → 마감 1000 정상(총 18000). 즉 proc_cd 상수가 매칭을 깨고 있음.
- **돈영향:** **저청구**(마감 800/1000/2000 silent 누락). ref_dim_cd=OPT_REF_DIM.04(proc 환원)는 `pricing.py:1423` 주석대로 **가격계산에 안 씀(MES 전송용)** → opt 선택이 proc_cd 를 주입하지도 않음.
- **공유:** LINEN_FINISH → PRF_POSTER_LINEN → PRD_000124 **단독**. 교차영향 0.
- **교정(단가 무변·매칭 차원 정리):** 단가행 proc_cd 를 NULL(자매 WOODHANGER/WOODBONG 동형) → 매칭은 opt_cd 단독(5행 opt_cd 전부 distinct, 충돌 0).
- **dryrun(검증완료·ROLLBACK):**
```sql
UPDATE t_prc_component_prices SET proc_cd=NULL, upd_dt=now()
 WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH' AND proc_cd IS NOT NULL;  -- UPDATE 5
```
- **사후 예상:** 마감 opt 선택 시 800/0/1000/2000/2000 정상 가산(매칭 로직 실증). ※ use_dims 추가가 아니라 **단가행 컬럼 정리**가 정답(proc_cd 를 use_dims 에 넣으면 잘못된 별도 공정 드롭다운이 생김).

### ⚪ [FP] PRD_000133 캔버스행잉 — COMP_POSTER_CANVAS_HANGING siz_cd
- use_dims `["siz_width","siz_height","min_qty"]` · 단가행 siz_cd 채움(고정가 by 사이즈).
- siz_cd 가 자매 addon(WOODHANGER use_dims `["opt_cd","siz_cd",...]`)을 통해 dim_union 에 들어가 **드롭다운 노출됨** → 손님 siz_cd 선택 → 본체행 siz_cd 정확매칭. **시뮬 6000/10500/20000 권위 정확**.
- **돈영향 0.** 매칭은 채워진 siz_cd 로 작동, 노출은 자매가 담당. 누수 없음 → FP.
- (선택적 견고화) 본체 use_dims 를 `["siz_cd","min_qty"]`로 바꾸면 자매 의존 없이 자족적. 돈 무관·비필수.

---

## REVIEW 41 triage — FP 26 / 추적·후속 15 (신규 누수 0)

판정 근거: ① sim-meta 가 실제 노출하는 proc 리프/opt 옵션 vs ② 전 바인딩 component 단가행 충전 union(선언 무관). FP=노출 안 되거나 이미 가격됨(parent→child·POPT). 

### A. print_opt_cd "1;2" = 16행 → 전부 ⚪FP
TSV 라인 20·21·23·25·28·29·32·33·35·36·37·40·43·44·45·52.
- avail 의 "1"/"2"는 `option_items.ref_dim_cd=OPT_REF_DIM.06`(도수=단면1/양면2) ref_key1 — **POPT 코드 네임스페이스 아님**이고 ref_dim 환원은 가격계산 미사용. 실제 print_opt 선택수단 POPT_000001/002 는 단가행에 충전됨. dim_conformance avail 빌더 과대포함 = FP.

### B. proc_cd parent→child / 전 노출 가격됨 = 5행 → 전부 ⚪FP
TSV 라인 19(016)·22(018)·39(041)·41·42(042).
- 미적발 PROC_000029/030(오시/미싱)은 **parent 코드** — proc 드롭다운이 자식(PROC_000090/086…)으로 펼쳐 노출(`price_views.py:1380`), 자식은 가격됨. sim-meta surface 체크 결과 016/018/041/042 **노출 proc 전건 가격됨(all-priced OK)**.

### C. opt_cd 비노출/무가산-free = 2행 → ⚪FP
TSV 라인 53(133 OPV_000029)·54(134 OPV_000031). avail 은 레거시 option_item 까지 과대포함. 노출 opt 는 "출력만(free)" + 실제 addon(OPV_000429/430 가격됨). 미적발값은 비노출 → 선택불가 → FP.

### D. proc_cd 비노출(명함 박 모서리) = 2행 → ⚪FP
TSV 라인 34(031 PREMIUM_FOIL 027/028/031/032)·38(034 PEARL_FOIL 027/028). sim-meta 에 031/034 proc_cd 드롭다운 자체 미노출 → 손님 선택불가 → 매칭 무관 → FP.

### E. 완칼커팅 mandatory 베이스포함 = 1행 → ⚪FP
TSV 라인 24(023 PROC_000123). mandatory(필수)·단가행 없음 = 도무송 본체가격에 포함(별도 가산 아님). 누수 0.

> A~E = **26행 FP**. dim_conformance 의 avail 과대포함(option ref_dim 환원·parent proc·레거시 opt)이 주원인.

### F. 책자제본 셋트 마감공정 = 6행 → 🟡KNOWN-SET(구조·신규아님)
TSV 라인 46(068)·47·48(069)·49·50(070)·51(071). 라미네이팅(014/015)·수축포장(076)·양각/음각(051/052)이 제본 parent 공식(PRF_BIND_*)엔 미가격. 이는 **셋트 구조** — 표지 마감은 표지 구성원에 가격(parent 공식=제본비만). 068~071 은 §27 책자셋트 미구성/BLOCKED 기 추적. 본 스캔의 신규 누수 아님 → §23/§27 위임.

### G. 디지털 접지·가변데이터 = 4행 → 🟠REAL-CANDIDATE(설계 미완·권위 확인 필요)
TSV 라인 26·27(027)·30·31(029). 노출 proc 중 **2단/3단접지(PROC_000065~068)·가변텍스트/이미지(PROC_000031/032)**가 **어느 component 단가행에도 없음**(홀로그램 등 박류 037~044 는 _FOIL 공식에 가격됨). 선택 시 가산 0 → 접지/가변 마감비가 권위에 있으면 **저청구**. 단 디지털엽서가 접지/가변을 무료로 둘 수도 있어 **인쇄상품 가격표 260527 대조 후 확정**(REVIEW 등급 유지). 실 작업은 §18 설계→§7 위임.

### H. 현수막 타공/마감 = 4행 → 🟡KNOWN(타공 위젯 코드트랙)
TSV 라인 56·57(138)·58·59(139). 타공(opt OPV_000007~009/042~044·proc)은 dim_vals{타공수}+위젯 procs detail 전송 후 작동 — 데이터는 always-add 제거까지 정리됨(메모리 rc2). 봉제/수접착/열재단=마감 free/포함. 위젯 코드트랙 기 추적.

### I. 족자 opt 재배선 미스매치 = 1행 → 🟡REAL-KNOWN(HOLD-C)
TSV 라인 55(135 OPV_000033/034). 시뮬: 노출 옵션 사각족자(OPV_000033) 가산 0, 가격은 **비노출 OPV_000431 에 6500**. 노출옵션↔가격옵션 단절. 메모리 HOLD-C(족자 6500 vs 권위 4000?) 기 추적 — 재배선+권위가 확정 필요(REVIEW 유지).

> F~I = **15행**: 신규 actionable 0(전부 기 추적 트랙). 유일한 신규 후보 G(디지털 접지/가변)는 권위 대조 선행.

---

## 요약
- **UNDECLARED 4행 → 진짜 2(상품 2개)·FP 1**:
  - 🔴 032 코팅명함: COAT_S1/S2 use_dims 에 print_opt_cd 추가(현 견적불가 0원 → 단면/양면 정상). 배선 교정·단가 무변.
  - 🔴 124 린넨: LINEN_FINISH 단가행 proc_cd=PROC_000080 → NULL(현 마감비 silent 누락 저청구 → 정상 가산). 단가행 컬럼 정리.
  - ⚪ 133 캔버스: FP(자매 노출+채운컬럼 매칭으로 정상, 누수 0).
  - 둘 다 단일상품 전용 component(교차영향 0)·dryrun BEGIN/ROLLBACK 검증 완료.
- **REVIEW 41행 → FP 26 / 추적·후속 15(신규 누수 0)**: FP 주원인=avail 과대포함(option ref_dim .06 도수→print_opt·parent proc→자식·레거시 opt). 추적 15=책자셋트(6·§27)·타공 위젯트랙(4)·족자 HOLD-C(1)·디지털 접지/가변(4·권위확인 후보).
- 실 COMMIT 인간 승인 후 §7 dbmap. 코드/엔진 수정 없음.
