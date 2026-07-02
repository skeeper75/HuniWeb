# 088 레더 링바인더 — 재설계 준비본 (구조 확정 + Q2 파라미터)

- 작성 2026-07-02 · §23 부분 재실행(088 단일 셋트) · hsp-set-design
- **★이 문서는 적재본이 아니라 "재설계 준비본"** — 소재+인쇄비 값(X)이 실무진 재확인 대기(BLOCKED-Q2)이므로
  **확정 4항으로 구조를 완성**하고 X 값만 파라미터로 남긴다. **apply.sql·CSV·DB 적재는 값 확정 후** 생성(현 단계 금지).
- 권위 = 후니프린팅_상품마스터_260702 · 인쇄상품_가격표_260702 (verbatim) · 라이브 읽기전용 SELECT 실측(2026-07-02)
- 입력: `01_authority/088-0702/`(authority-088-0702.md·sabari-binder-bind-grid.csv·leather-ringbinder-a4-grid.csv·live-088-baseline.md)·
  `03_design/leather-ringbinder-pricing-research-260702.md`·`088-Q2-재질문-260702.md`·`hardcover-ring-082-authority.md`

---

## 0. 결론 한 줄

> **088 최종가 = [소재+인쇄비 = X (BLOCKED-Q2)] + [싸바리바인더 제본비 (확정·라이브 실재·verbatim)].**
> 싸바리 제본비 조각은 라이브 `COMP_BIND_SSABARI @ proc_cd=PROC_000098`(6밴드 권위 일치)로 **즉시 배선 가능**(고아 → 088 부모공식에 연결).
> 소재+인쇄비 X는 값·귀속 component가 실무진 재확인 대기 → **구조만 완성, 값은 파라미터**. 현 임시 `COMP_HC_MUSEON_COVERBIND`(하드커버무선 blended)은 **교체 대상**(제본 종류 불일치·레더 원가 미반영).

---

## 1. 실무진 확정 모델 (교체 설계)

### 1.1 현 임시 모델 = 폐기 대상
- 라이브 현: `PRF_LEATHER_RINGBINDER_SET` → 단일 `COMP_HC_MUSEON_COVERBIND`("하드커버무선 표지+제본 합산(권당)", use_dims=["min_qty"]) → 1부 34,100 / 100부 796,900.
- 어긋남 2가지(live-088-baseline.md §4):
  1. **제본 종류 불일치**: 하드커버무선(100부 blended 7,969) ≠ 싸바리바인더(100부 9,000). → 저평가.
  2. **레더 표지 원가 미반영**: COVERBIND에 하드커버무선 표지비가 blended, 레더 소재+인쇄비 아님.
- → **COVERBIND 재사용 폐기.** 실무진 확정 2조각 분해로 교체.

### 1.2 실무진 확정 = 2조각 합산
```
088 판매가 = [소재+인쇄비 X]  +  [싸바리바인더 제본비]
             └ BLOCKED-Q2 (값·귀속 미확정)   └ 확정 (COMP_BIND_SSABARI @ PROC_000098)
```
- (Q1) 공식 = [소재+인쇄비] + [싸바리 제본비] — 실무진 구두 확정(계산공식집엔 088 전용 블록 미기재=PARTIAL).
- (Q3) 제본비 = 싸바리바인더, 두께 무차등 — CONFIRMED(수량밴드 단일축).
- (Q4) 제본비에 면지 포함 — CONSISTENT(면지 별도가 어디에도 없음).
- (Q5) 링 종류(O/D)·두께(31/42/56) 무차등 — CONFIRMED(가격축 아님).
- (Q2) 소재+인쇄비 = "출력소재관리 하드커버전용 레더링바인더 A4" — **★CONFLICT**(해당 행이 엑셀·라이브에 부재) → BLOCKED-Q2.

---

## 2. 구조 설계 (값 무관하게 확정 가능한 부분)

### 2.1 셋트 member 구조 (변경 없음 — 전부 라이브 실재 반제품)

| disp_seq | sub_prd_cd | 역할 | 유형 | 가격 | member 변경 |
|---|---|---|---|---|---|
| 1 | PRD_000089 | 표지(레더(화이트)) | PRD_TYPE.02 반제품 | **[소재+인쇄비 X]** 귀속 후보(§2.3) | 없음(존치) |
| 2 | PRD_000090 | 면지(화이트면지) | .02 | **무가격**(제본비 포함·Q4) | 없음 |
| 3 | PRD_000091 | 면지(블랙면지) | .02 | 무가격 | 없음 |
| 4 | PRD_000092 | 면지(그레이면지) | .02 | 무가격 | 없음 |
| 5 | PRD_000093 | 면지(인쇄면지) | .02 | 무가격 | 없음 |

- **내지 member 없음** = 빈 바인더 확정(상품 시트 내지 전칸 빈칸·82와 구조 차이). 내지 mint 불요.
- member 6개 전부 라이브 실재(PRD_000088~093, 전부 .02 반제품) → **search-before-mint 통과, 신규 member mint 0**.
- 면지 4종은 손님 택1(화이트/블랙/그레이/인쇄) 성격이나 셋트엔 4행 존치(옵션 분기는 셋트 밖 CPQ·제약에서 처리).
- **member 구조는 값과 무관하게 현행 유지 = 확정**. (t_prd_product_sets 5행 변경 없음 → CSV 신규 불요.)

### 2.2 싸바리 제본비 component — search-before-mint 판정 = **재사용**

라이브 실측(2026-07-02):
- `COMP_BIND_SSABARI`("제본비 싸바리바인더", prc_typ=PRICE_TYPE.01, use_dims=`["proc_cd","min_qty","proc_grp:PROC_000017"]`, use_yn=Y·del_yn=N) **실재**.
- 단가행(proc_cd=`PROC_000098` 싸바리 밴드) verbatim 대조:

| min_qty(부) | 라이브 unit_price | 권위 격자(sabari-binder-bind-grid.csv) | 일치 |
|---|---|---|---|
| 1 | 30,000 | 30,000 | ✅ |
| 4 | 25,000 | 25,000 | ✅ |
| 10 | 20,000 | 20,000 | ✅ |
| 50 | 15,000 | 15,000 | ✅ |
| 100 | 9,000 | 9,000 | ✅ |
| 1000 | 7,000 | 7,000 | ✅ |

- **6밴드 100% 일치 → 신설 불요. 재사용 확정.** (상세 근거·인접 component 대조 = `component-reuse-audit.md`)
- **고아 상태**: `t_prc_formula_components WHERE comp_cd='COMP_BIND_SSABARI'` = **0건** → 어떤 공식에도 미배선. 배선 대상.

### 2.3 부모공식 배선 (082 동형)

동형 오라클 — 082 하드커버 링책자(라이브 실측):
- `PRD_000082 → PRF_HC_TWINRING_SET → [COMP_BIND_HC_TWINRING]`(단일·proc_cd=PROC_000024 트윈링 격리).
- 즉 082 부모공식 = "제본비 component 단일 + proc_cd 격리". 088도 이 shape을 **싸바리로** 적용.

**088 재설계 배선:**
```
PRD_000088 → PRF_LEATHER_RINGBINDER_SET (기존 공식 shell 재사용)
  formula_components:
   ① COMP_BIND_SSABARI   (addtn_yn=Y, disp_seq=1)   ← 신규 배선 [싸바리 제본비]
   ✗ COMP_HC_MUSEON_COVERBIND (제거)                 ← 현 blended, 폐기
  088 product_processes: PROC_000098 (싸바리) 필수  ← proc_cd 격리 키 (§2.5)
```
- 소재+인쇄비 X는 부모공식 두 번째 component로 넣을지 / 표지 member 089에 귀속할지 = **Q2 귀속 분기(§3.2)** — 값·경로 확정 후 결정.

### 2.4 면지 = 무가격 member (Q4 정합)
- 제본비에 면지 포함 → 면지 090~093은 **가격공식 0행 유지**(현행). 기존 면지 무가격 원칙([[set-semifinished-3tier-model-260629]] 면지=제본비 포함)과 정합.
- 값 무관 확정. 변경 없음.

### 2.5 링종류·두께 = 가격축 아님 → 제약/표시축 (옵션 오염 가드 §3)

- 링 두께 31/42/56mm·링타입 O/D = **가격 무영향**(Q3/Q5 CONFIRMED·리서치 3자 수렴: 레드·Hartnack·도메인 모두 링 비가격축).
- 링 두께 = **수용량 제약(최대 면지 매수 상한)**으로 constraint 축에만 표현(가격 아님). 링타입 = 표시 옵션.
- **★옵션 오염 가드[HARD]**: 088 부모공식·표지 member에 **싸바리(PROC_000098) 제본 comp만** 배선. 무선(023)·트윈링(024) proc는 088 product_processes에 **넣지 않는다**. `COMP_BIND_SSABARI`가 3 proc 밴드(무선/트윈링/싸바리)를 모두 보유하므로, 088이 PROC_000098만 선언해야 use_dims의 proc_cd 차원이 싸바리 밴드로만 매칭됨(silent 다중매칭 0). → **088 product_processes = {PROC_000098} 단독 확인 필수**(현재 088 proc 0건 → PROC_000098 추가가 배선 항목, 값 무관·지금 명세 가능).

---

## 3. Q2 파라미터 시나리오 (X = 소재+인쇄비)

**★아래 예상 최종가는 참고용(합리성 오라클)이며 권위 아님. X 값은 실무진 재확인 전까지 확정 금지(날조 0).**

### 3.1 두 후보 (실무진 재확인 큐)

| 후보 | X 원천 | 라이브 실재 | 값(611×374 커버) | note |
|---|---|---|---|---|
| **(a)** 레더하드커버 A4 소재 + 인쇄비 | 출력소재(IMPORT) 하드커버전용 r101 "레더하드커버 A4=7000"(소재비만) + 인쇄비 component(미지정) | **소재 7000 = 라이브 단가행 부재**(엑셀에만·mint 필요)·인쇄비 component 미지정 | 소재 7,000 (+인쇄비 TBD) | 실무진 지목에 가장 근접하나 이름(레더하드커버≠레더링바인더)·사이즈(532×355≠611×374)·"소재비"만 명시(인쇄비 포함 불명) |
| **(b)** 레더아트프린트 611×374 (소재+인쇄 통합) | 포스터사인 레더아트프린트 면적매트릭스 | **실재** — `COMP_POSTER_CANVAS_FABRIC`(use_dims=[siz_width,siz_height,min_qty]) 800×600 밴드 = **19,000**(611×374 커버가 드는 밴드·flat) | 19,000 | 실무진 미지목 경로(리서치 대안)·소재+인쇄 통합값 |

### 3.2 X 귀속(home) 분기 (Q2 값 확정 후 결정)
- **(Home-P) 부모공식 component**: X를 `PRF_LEATHER_RINGBINDER_SET` 두 번째 component로 배선. 실무진 "2조각 합산" 멘탈모델에 직결·(a) flat 7000 per-unit에 적합.
- **(Home-M) 표지 member 089**: X를 표지 member 089의 자체 가격(component/공식)으로. (b) 레더아트프린트는 **611×374 면적매트릭스**라 완제품 A4 사이즈와 달라 부모공식에선 NO_MATCH → **member 089(작업사이즈 611×374 보유)에 귀속 필연**([[booklet-cover-branch-design-260630]] 068 커버분해 선례). 또한 blended component에 레더 정액행 추가 시 `_row_matches` AMBIGUOUS 0원 함정 회피(리서치 §4).
- **권고(값 무관)**: **Home-M(표지 member 089)** — ① 611×374 작업사이즈 자연 귀속 ② AMBIGUOUS 회피 ③ 068 선례 검증됨 ④ 부모공식은 싸바리 제본비만 = proc 격리 청결. 단 실무진이 (a) flat 7000 단일값을 의도하면 Home-P도 가능 → **값·경로 확정 시 최종 결정**.

### 3.3 예상 최종가 표 (참고용·권위 아님·cover_mult ×1 기준)

싸바리 제본비(고정): 1부 = 30,000×1 = **30,000** / 100부 = 9,000×100 = **900,000**.

| 시나리오 | X (per cover) | 1부 예상 최종가 | 100부 예상 최종가 |
|---|---|---|---|
| **(a) 소재 7000만**(인쇄비 미포함) | 7,000 | 7,000 + 30,000 = **37,000** | 700,000 + 900,000 = **1,600,000** |
| **(a) 소재 7000 + 인쇄비 Y** | 7,000+Y | 7,000+Y + 30,000 | (7,000+Y)×100 + 900,000 |
| **(b) 레더아트프린트 19000** | 19,000 | 19,000 + 30,000 = **49,000** | 1,900,000 + 900,000 = **2,800,000** |
| (참고) 현 임시 COVERBIND | blended | 34,100 | 796,900 |

- **cover_mult ×2**(링 표지 앞뒤 물리 2장) 적용 시 X×2: (a)소재만 1부 44,000/100부 2,300,000 · (b) 1부 68,000/100부 4,700,000. 단 **cover_mult ×2 = 엔진 BLOCKED**(pricing.py plate_qty÷pansu만·×2 phantom·C트랙 개발팀 [[booklet-cover-branch-design-260630]]) → 현 설계는 ×1 기준, ×2는 개발팀 트랙 잔존.
- **핵심 관찰**: (a)와 (b)는 100부에서 ~1.2M(소재만)~1.75M 차이 → Q2 확정이 돈크리티컬. 임의 채택 금지.

---

## 4. evaluate_set_price 정합 (가격 구성 가능성)

`evaluate_set_price` = Σ member evaluate_price + 부모공식 + 할인(pricing.py:718).
- 재설계 후 기여: 부모(싸바리 제본비 = COMP_BIND_SSABARI@098) + 표지 member 089(X, Home-M 시) + 면지 090~093(0) → 합 = X + 싸바리 제본비. **실무진 2조각 모델과 1:1**.
- **이중합산 가드**: 제본비는 부모공식에만(면지·표지 member에 중복 금지). X는 표지 member에만(부모공식엔 중복 금지). Home-P 채택 시 X는 부모공식에만·member 089는 0.
- 부모공식 shell(`PRF_LEATHER_RINGBINDER_SET`) 실재(use_yn=Y) → 신설 불요. 배선(component 교체)만.
- **가격계산 가능 조건**: ① 싸바리 조각 = 지금 배선 가능(확정) ② X 조각 = BLOCKED-Q2(값·component). X 미확정 상태로 배선하면 표지 원가 0 = 저청구 → **X 확정 전 COMMIT 금지**.

---

## 5. 확정분 / BLOCKED 분리 (게이트 인계)

| 항목 | 상태 | 지금 가능 |
|---|---|---|
| member 구조(표지1+면지4·내지없음) | **확정** | 현행 유지(변경 0) |
| 싸바리 제본비 component | **확정**(COMP_BIND_SSABARI@098 재사용·6밴드 verbatim) | 배선 명세 완료 |
| 부모공식 shape(싸바리 제본 단일·proc 격리) | **확정**(082 동형) | 배선 명세 완료 |
| COVERBIND 폐기 | **확정** | 교체 명세 완료 |
| 면지 무가격(Q4) | **확정** | 현행 유지 |
| 링 두께/타입 비가격(제약축) | **확정** | 제약/표시축 명세 |
| product_processes = PROC_000098 단독 | **확정**(옵션 오염 가드) | 명세 완료(현재 088 proc 0건→추가) |
| **소재+인쇄비 X 값** | **★BLOCKED-Q2** | 불가(실무진 재확인) |
| X 귀속 home(P/M) | Q2 종속 | 권고=Home-M·확정 유보 |
| cover_mult ×2 | BLOCKED(엔진 C트랙·개발팀) | 별도 트랙 |

---

## 출처
- 권위: authority-088-0702.md · sabari-binder-bind-grid.csv · leather-ringbinder-a4-grid.csv · live-088-baseline.md
- 라이브 실측(2026-07-02 읽기전용): t_prc_price_components·t_prc_component_prices(COMP_BIND_SSABARI@PROC_000098 6밴드·COMP_POSTER_CANVAS_FABRIC 800×600=19000)·t_prc_formula_components(SSABARI 고아 0건)·t_prd_product_price_formulas(082=PRF_HC_TWINRING_SET+COMP_BIND_HC_TWINRING 동형)·t_proc_processes(PROC_000098 싸바리바인더)·t_prd_product_processes(088 proc 0건)
- 동형: hardcover-ring-082-authority.md · [[leather-hardcover-077-live-commit-260701]] · [[booklet-cover-branch-design-260630]]
- 리서치: leather-ringbinder-pricing-research-260702.md(링 비가격축·커버분해 권고·AMBIGUOUS 함정)
