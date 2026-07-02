# 088 레더 링바인더 — 재설계 적재본 (Q2 확정 · BLOCKED-Q2 CLOSED)

- 작성 2026-07-02 (Q2 해소 갱신) · §23 부분 재실행(088 단일 셋트) · hsp-set-design
- **★이 문서는 적재본 명세** — Q2 값(소재+인쇄비 9,000)이 사용자(실무진 0702 발췌)로 확정되어 준비본의 파라미터 X가 실값으로 채워졌다.
  준비본의 **구조 결정(member 현행 유지·싸바리 제본비 재사용·부모공식 shell 재사용·proc 격리·귀속 home=표지 member M)은 재검토 없이 계승**(relitigate 금지).
- 권위 = 후니프린팅_상품마스터_260702 · 인쇄상품_가격표_260702 (verbatim) · **출력소재관리 0702(사용자 전달·verbatim)** · 라이브 읽기전용 SELECT 실측(2026-07-02)
- 입력: `01_authority/088-0702/`(authority-088-0702.md·sabari-binder-bind-grid.csv·leather-ringbinder-a4-grid.csv 하단 Q2 해소행·live-088-baseline.md)·
  `03_design/088-redesign-260702/component-reuse-audit.md`·`leather-ringbinder-pricing-research-260702.md`
- **DB 미적재** — 본 문서·apply.sql은 명세까지. 실 COMMIT은 게이트 GO + 인간 승인 후 hsp-load-execution 몫.

---

## 0. 결론 한 줄

> **088 최종가 = [레더 링바인더 표지 소재+인쇄비 9,000/부 (member 089·mint)] + [싸바리바인더 제본비 (부모공식·라이브 재사용·6밴드 verbatim)].**
> 1부 = **39,000** / 10부 = **290,000** / 100부 = **1,800,000** (§7 골든). 현 임시 COVERBIND 모델(1부34,100/100부796,900)은 폐기·교체.

---

## 1. Q2 해소 (BLOCKED-Q2 → CLOSED)

### 1.1 확정값 (verbatim)
- **레더 링바인더 A4 = 9,000원** · 구역=출력소재관리>하드커버전용 · 규격설명="A4 하드커버 표지사이즈 기준 **636×374** 기준 소재비".
- 출처 = **출력소재관리 0702(사용자 전달)** — verbatim 기록 = `01_authority/088-0702/leather-ringbinder-a4-grid.csv` 하단(Q2 해소행).
- ★참고: 이 행은 전달받은 **가격표_260702 출력소재(IMPORT) 시트에는 아직 미반영**(실무진측 문서/화면에만 존재). → 라이브 단가행 부재 = **mint 필요**(§3).

### 1.2 실무진 공식 문장 해석 (9,000 = 소재+인쇄비 전체)
- 실무진 공식 문장: **"소재+인쇄비는 (출력소재관리)>하드커버전용>레더링바인더 A4에 가격 입력해놨다."**
- → **9,000이 [소재+인쇄비] 전체를 커버**한다(행 비고의 "소재비" 표기보다 실무진 공식 문장이 권위). 별도 인쇄비 component 추가 **불요**.
- CONFLICT 없음: 준비본이 우려한 별도 인쇄비 근거는 나오지 않았다(실무진 문장이 통합가로 명시). 임의 인쇄비 component 추가 금지.

### 1.3 표지 작업사이즈 3종 (오케스트레이터 보충 2026-07-02) — 가격축 아님
- 레더 링바인더 표지 **작업사이즈 3종 = 611×374 / 622×374 / 636×374** (상품시트 D링 31/42/56 3종 대응 추정 — 링 두께 클수록 표지 랩 커짐).
- **가격 영향 없음**: 출력소재관리 9,000원은 **최대 작업사이즈 636×374 기준 단일가**이고, 실무진이 "링 종류/두께 가격차 없음" 확정. 3종 사이즈 = 가격축 아님 = **생산 메타(작업사이즈)**.
- ★**CONFLICT 아님**: 상품시트 611×374 vs 출력소재관리 636×374 = 둘 다 맞다(3종 중 각각). 준비본의 "611≠636 CONFLICT" 우려는 **해소**(3종 사이즈 중 각각 하나).
- 사이즈 코드 등록은 **본 적재 스코프 밖**(가격 배선·member까지) — 생산 메타 참고로만 기록.

---

## 2. 확정 모델 (준비본 계승 · 값 채움)

```
088 판매가 = [표지 소재+인쇄비 9,000/부]         +  [싸바리바인더 제본비]
             └ member 089 (mint·Home-M)             └ 부모공식 PRF_LEATHER_RINGBINDER_SET (재사용·COMP_BIND_SSABARI@PROC_000098)
```

### 2.1 셋트 member 구조 (현행 유지 — 변경 0)

| disp_seq | sub_prd_cd | 역할 | 유형 | 가격 | member 변경 |
|---|---|---|---|---|---|
| 1 | PRD_000089 | 표지(레더(화이트)) | PRD_TYPE.02 반제품 | **소재+인쇄비 9,000/부** (Home-M·§2.3) | 없음(존치) |
| 2 | PRD_000090 | 면지(화이트면지) | .02 | 무가격(제본비 포함·Q4) | 없음 |
| 3 | PRD_000091 | 면지(블랙면지) | .02 | 무가격 | 없음 |
| 4 | PRD_000092 | 면지(그레이면지) | .02 | 무가격 | 없음 |
| 5 | PRD_000093 | 면지(인쇄면지) | .02 | 무가격 | 없음 |

- **내지 member 없음** = 빈 바인더 확정(상품 시트 내지 전칸 빈칸). 내지 mint 불요.
- member 6개(088~093) 전부 라이브 실재·전부 .02 반제품 → **search-before-mint 통과, member mint 0**.
- **t_prd_product_sets 5행 변경 없음** → 셋트 행 CSV 신규 불요(적재는 가격 배선·member 089 공식만).

### 2.2 싸바리 제본비 (부모공식) — 재사용 (신설 불요)

- `COMP_BIND_SSABARI`("제본비 싸바리바인더", prc_typ=PRICE_TYPE.01, comp_typ=PRC_COMPONENT_TYPE.04, use_dims=`["proc_cd","min_qty","proc_grp:PROC_000017"]`, use_yn=Y·del_yn=N) **라이브 실재**.
- 단가행(proc_cd=PROC_000098 싸바리 밴드) 6밴드 verbatim 100% 일치(component-reuse-audit.md §1.2): 1부30,000/4부25,000/10부20,000/50부15,000/100부9,000/1000부7,000.
- 현재 **고아**(t_prc_formula_components에 SSABARI 배선 0건) → 부모공식에 배선하는 것이 실질 작업.

### 2.3 표지 소재+인쇄비 (member 089·Home-M) — mint

- 라이브 재확인(§3): "레더 링바인더 A4=9,000" 단가행/전용 component **부재** → **신규 mint**(사용자 directive "없으면 신설 명세").
- **귀속 home = 표지 member 089 (Home-M)** — 준비본 §3.2 권고 계승(relitigate 금지). 근거 재확인:
  1. **작업사이즈 자연 귀속**: 3종 작업사이즈(611/622/636×374)는 표지(member 089) 생산 메타 → 표지 원가는 member 089에 귀속이 자연스럽다.
  2. **부모공식 청결(proc 격리)**: 부모공식은 싸바리 제본비만 = proc_cd 격리 청결 유지(§2.5).
  3. 068 커버분해 선례([[booklet-cover-branch-design-260630]]) 동형.
  4. (참고) 값이 flat 9,000(면적매트릭스 아님)이라 Home-P(부모공식 2nd component)도 기술상 가능하나, **사용자 지시 = Home-M 계승**이므로 채택하지 않는다. 재검토 안 함.
- **mint 명세**:
  - `t_prc_price_components`: **COMP_LEATHER_RINGBINDER_COVER** ("레더 링바인더 표지 소재+인쇄비", prc_typ=PRICE_TYPE.01, comp_typ=PRC_COMPONENT_TYPE.06[COVERBIND 동형], use_dims=`["min_qty"]`, use_yn=Y·del_yn=N).
  - `t_prc_component_prices`: min_qty=1 → unit_price=**9,000**(단일 flat 밴드·636×374 기준·출력소재관리 0702). apply_ymd='2026-06-01'(SSABARI 관례).
  - `t_prc_price_formulas`: **PRF_LEATHER_RINGBINDER_COVER** ("레더 링바인더 표지 소재+인쇄비", use_yn=Y).
  - `t_prc_formula_components`: PRF_LEATHER_RINGBINDER_COVER → COMP_LEATHER_RINGBINDER_COVER (disp_seq=1, addtn_yn=Y).
  - `t_prd_product_price_formulas`: PRD_000089 → PRF_LEATHER_RINGBINDER_COVER (apply_bgn_ymd='2026-01-01'). ← 현재 089 공식 바인딩 0건이므로 신규.
- prc_typ .01(단가형) → member 089 evaluate_price = 9,000 × (표지 출력매수). cover_mult ×1 기준 출력매수=부수 → **9,000/부**.

### 2.4 부모공식 재배선 (COVERBIND 폐기 → SSABARI)

- `PRF_LEATHER_RINGBINDER_SET`(실재·use_yn=Y) **shell 재사용**(신설 불요).
- **배선 교체**:
  - ✗ 제거: `PRF_LEATHER_RINGBINDER_SET → COMP_HC_MUSEON_COVERBIND`(현 blended·하드커버무선 표지+제본·레더/싸바리 불일치) — formula_component 행 DELETE. **component 자체(COMP_HC_MUSEON_COVERBIND)는 타상품용 보존**(삭제 안 함).
  - ✔ 추가: `PRF_LEATHER_RINGBINDER_SET → COMP_BIND_SSABARI`(disp_seq=1, addtn_yn=Y).
- 082 하드커버 링책자 동형(PRF_HC_TWINRING_SET → 단일 제본 comp + proc 격리).

### 2.5 면지 무가격 + 링 비가격축 + 옵션 오염 가드 (§3 hsp-set-design)

- 면지 090~093 = 가격공식 0행 유지(제본비에 면지 포함·Q4). 변경 없음.
- 링 두께 31/42/56·링타입 O/D = 가격 무영향(리서치 3자 수렴). 두께=수용량 제약(constraint 축)·링타입=표시. 가격축 아님.
- **★옵션 오염 가드[HARD]**: 088 `product_processes = {PROC_000098}` 단독(현재 088 proc 0건 → PROC_000098 mand 추가). COMP_BIND_SSABARI가 3 proc 밴드(무선023/트윈링024/싸바리098) 통합 보유하므로, 088이 PROC_000098만 선언해야 use_dims의 proc_cd 차원이 싸바리 밴드로만 매칭(무선/트윈링 밴드 silent 미적용). **무선(023)·트윈링(024) proc는 088에 넣지 않는다.**

---

## 3. search-before-mint 판정 (라이브 실측 2026-07-02)

| 조각 | 라이브 실재 | 판정 | 근거 |
|---|---|---|---|
| 싸바리 제본비 (COMP_BIND_SSABARI@PROC_000098) | ✅ 실재·6밴드 verbatim | **재사용** | component-reuse-audit.md §1 |
| 부모공식 shell (PRF_LEATHER_RINGBINDER_SET) | ✅ 실재(use_yn=Y) | **재사용**(component 교체만) | 라이브 실측 |
| 표지 소재+인쇄비 (COMP_LEATHER_RINGBINDER_COVER) | ❌ 부재(comp 0건·9,000 단가행 부재) | **신규 mint** | 사용자 directive "없으면 신설 명세" |
| 표지 공식 (PRF_LEATHER_RINGBINDER_COVER) | ❌ 부재(frm 0건) | **신규 mint** | member 089 Home-M 배선용 |
| member 6종 (PRD_000088~093) | ✅ 전부 실재·.02 반제품 | **재사용**(변경 0) | live-088-baseline.md §1 |
| 현 COVERBIND 배선 | ✅ 실재(부모공식에 배선) | **폐기(배선 제거·component 보존)** | 제본종류·레더 원가 불일치 |
| PROC_000098 (싸바리바인더) | ✅ 실재(use_yn=Y·del_yn=N) | **재사용**(088에 mand 추가) | 옵션 오염 가드 |

- ★반제품 미등록 BLOCKED = **없음**. 가격공식 부재 BLOCKED = **없음**. mint 2건(표지 component+공식)은 값 확정(9,000 verbatim)이므로 날조 0.

---

## 4. evaluate_set_price 정합 (가격 구성 가능성)

`evaluate_set_price` = Σ member evaluate_price(각자 공식·qty) + 부모공식 evaluate_price(copies) + 할인(pricing.py:854~968).
- 재설계 후 기여:
  - member 089(표지) = COMP_LEATHER_RINGBINDER_COVER → **9,000 × 표지출력매수**(×1=부수).
  - member 090~093(면지) = 공식 0 → **0**.
  - 부모(088) = COMP_BIND_SSABARI@PROC_000098 → **싸바리 밴드단가 × 부수**.
  - base_total = 9,000/부 + 싸바리 제본비 → **실무진 2조각 모델과 1:1**.
- **이중합산 가드[HARD]**: 소재+인쇄비는 member 089에만(부모공식·타 member 중복 금지). 제본비는 부모공식에만(면지·표지 member 중복 금지).
- **할인**: 088에 수량구간 할인 테이블 바인딩 **없음**(t_prd_product_discount_tables 0건). 등급할인은 grade_cd 전달 시만. → **골든(무등급) final_price = base_total**.

---

## 5. 적재 항목 (apply.sql 매핑) — 변경 8행

| # | 테이블 | 작업 | 행 | 멱등 키 |
|---|---|---|---|---|
| 1 | t_prc_price_components | INSERT(mint) | COMP_LEATHER_RINGBINDER_COVER | ON CONFLICT(comp_cd) DO UPDATE |
| 2 | t_prc_component_prices | INSERT(mint) | 9,000@min_qty=1 | NOT EXISTS(comp_cd,apply_ymd,min_qty) |
| 3 | t_prc_price_formulas | INSERT(mint) | PRF_LEATHER_RINGBINDER_COVER | ON CONFLICT(frm_cd) DO UPDATE |
| 4 | t_prc_formula_components | INSERT(mint) | PRF_LEATHER_RINGBINDER_COVER→COMP_LEATHER_RINGBINDER_COVER | ON CONFLICT(frm_cd,comp_cd) DO UPDATE |
| 5 | t_prd_product_price_formulas | INSERT | PRD_000089→PRF_LEATHER_RINGBINDER_COVER | ON CONFLICT(prd_cd,apply_bgn_ymd) DO UPDATE |
| 6 | t_prc_formula_components | DELETE | PRF_LEATHER_RINGBINDER_SET→COMP_HC_MUSEON_COVERBIND | (idempotent DELETE) |
| 7 | t_prc_formula_components | INSERT | PRF_LEATHER_RINGBINDER_SET→COMP_BIND_SSABARI | ON CONFLICT(frm_cd,comp_cd) DO UPDATE |
| 8 | t_prd_product_processes | INSERT | PRD_000088→PROC_000098(mand=Y) | ON CONFLICT(prd_cd,proc_cd) DO UPDATE |

- COMP_HC_MUSEON_COVERBIND **component 자체는 삭제하지 않음**(#6은 배선 행만 제거·타상품 077 등 보존).

---

## 6. 확정분 / 잔여 (게이트 인계)

| 항목 | 상태 |
|---|---|
| Q2 소재+인쇄비 값(9,000·member 089 Home-M) | **CLOSED**(확정·mint 명세 완료) |
| 싸바리 제본비 배선(부모공식) | 확정(재사용·verbatim) |
| COVERBIND 폐기(배선 제거) | 확정 |
| member 구조·면지 무가격·proc 격리 | 확정(값 무관·현행) |
| 표지 작업사이즈 3종 CONFLICT | **해소**(가격축 아님·생산 메타) |
| cover_mult ×2(링 표지 앞뒤 2장) | **BLOCKED(C트랙·개발팀·본 건 무관)** — ×1로 동작화(082/077 선례) |
| 사이즈 코드 등록(611/622/636×374) | 스코프 밖(생산 메타 참고) |

---

## 7. 골든 케이스 (게이트가 evaluate_set_price 재계산으로 대조할 자)

전제: mode=lenient·grade 미전달·cover_mult ×1(표지출력매수=부수)·할인 바인딩 없음 → final_price = base_total.

| 부수(copies) | member 089 (9,000×부수) | 부모 싸바리 밴드단가 | 부모 (밴드×부수) | base_total = final_price |
|---|---|---|---|---|
| **1** | 9,000×1 = 9,000 | 30,000 (밴드1) | 30,000×1 = 30,000 | **39,000** |
| **10** | 9,000×10 = 90,000 | 20,000 (밴드10) | 20,000×10 = 200,000 | **290,000** |
| **100** | 9,000×100 = 900,000 | 9,000 (밴드100) | 9,000×100 = 900,000 | **1,800,000** |

- 검산: 1부 39,000·100부 1,800,000 = 사용자 제시 기대값과 일치.
- (참고) 현 임시 COVERBIND: 1부 34,100·100부 796,900 → 재설계로 100부 +1,003,100 상향(싸바리 제본+레더 원가 정상 반영).
- 골든 CSV = `golden-088.csv`(동 디렉터리).

---

## 출처
- 권위: authority-088-0702.md · sabari-binder-bind-grid.csv · **leather-ringbinder-a4-grid.csv 하단 Q2 해소행(9,000·636×374·출력소재관리 0702)** · live-088-baseline.md
- 라이브 실측(2026-07-02 읽기전용): t_prc_price_components/component_prices(COMP_BIND_SSABARI@098 6밴드·COMP_LEATHER_RINGBINDER_COVER/PRF_LEATHER_RINGBINDER_COVER 부재·MAX comp_price_id=88046)·t_prc_formula_components(SSABARI 고아·PRF_LEATHER_RINGBINDER_SET→COVERBIND 현 배선)·t_prd_product_price_formulas(088→SET·089 공식 0건·PK=(prd_cd,apply_bgn_ymd))·t_prd_product_processes(088 proc 0건·PK=(prd_cd,proc_cd))·t_proc_processes(PROC_000098)·t_prd_product_discount_tables(088 할인 0건)
- 계약: pricing.py:854 evaluate_set_price(Σ member + 부모공식 + 할인)·:402 evaluate_price
- 동형: hardcover-ring-082-authority.md · [[leather-hardcover-077-live-commit-260701]] · [[booklet-cover-branch-design-260630]]
- 보충: 오케스트레이터 2026-07-02(표지 작업사이즈 3종·가격 636 기준 9,000 단일)
