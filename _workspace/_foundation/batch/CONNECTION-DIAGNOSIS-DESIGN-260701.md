# 상품→공식→구성요소 연결 진단 설계 — silent-0 누락 적발 (2026-07-01)

> 질의: "상품 = 가격공식 ← 가격구성요소" 연결이 제대로 됐는지 어떻게 전수 진단·검증하나.
> 이미 §27 배선 서브트랙·§26 차원정합 파이프라인이 도는데 캘린더 같은 누락이 빠져나갔다 → 갭을 찾는다.
> [HARD] 라이브 읽기전용. evaluate_price(pricing.py)=진실 오라클. 진단까지(교정 §7 인간 승인).

## 1. 연결 사슬과 2개 실패 층

```
상품 t_prd_products
  └─[A]─ 상품-공식 바인딩 t_prd_product_price_formulas
          └─[B]─ 가격공식 t_prc_price_formulas
                  └─[C]─ 공식-구성요소 배선 t_prc_formula_components
                          └─[D]─ 가격구성요소 t_prc_price_components (use_dims 선언)
                                  └─[E]─ 단가행 t_prc_component_prices (proc_cd/opt_cd/siz_cd 값 충전)

   ── 여기까지 = 정적 배선 층(존재하나) ──
   ── 그 아래 = 런타임 매칭 층(실제로 매칭되나) ──

[F] evaluate_price 런타임: 상품의 선택수단(processes/options/sizes/print_options)이
    단가행이 요구하는 차원값(proc_cd 등)을 실제로 공급하는가?
    공급 못 하면 → _match_entry 매칭 실패 → included=False → 비목 합산 누락(silent 0).
```

**핵심:** 결함은 두 층에서 난다. 정적 층(A~E)은 "있나"를, 런타임 층(F)은 "맞나"를 본다.
캘린더·base-proc 결함은 **전부 F층(런타임 매칭)** — A~E는 멀쩡한데 F에서 silent 0.

## 2. 기존 도구가 보는 층 + 정확한 갭

| 도구 | 위치 | 검사 층 | 검출 | 못 보는 것 |
|------|------|---------|------|-----------|
| `wiring_scan.py` | §27 | A·C·D·E **존재** | 고아·빈배선·삭제오염·NO_FORMULA | **F 런타임 매칭 전무**(comp 배선+단가행 있으면 WIRED_OK) |
| `dim_conformance.py` | §26 | A·E·상품수단 3자 | MISSING(수단∖충전)·UNDECLARED | ① **미바인딩 상품 skip**(prod_frm만) ② proc_cd=**REVIEW**(노이즈) ③ 고아 단가행(SURPLUS) skip ④ 실제 매칭 시뮬 안 함 |
| `verify_formula_*.py` | §27 | C **비목 종류**(키워드) | 비목 누락/오염 | 차원값 매칭 무관 |
| `score_batch.py` | §27 | F **상품 레벨** simulate | PRICE≠0·CALC·세트 이중합산 | **비목 단위 0 기여 미보고**(상품 PRICE≠0이면 통과 — 용지비로 비0인데 제본/인쇄 비목 0인 케이스 못 잡음) |

**갭 = "비목 단위 런타임 기여 0" 검증이 없다.** 즉 *배선됐고·단가행 있고·상품 PRICE≠0인데, 특정 구성요소의 런타임 기여가 0*인 상태(=과소청구 silent-0)를 전수로 잡는 도구가 없다. 캘린더 제본(상품이 PROC_000021 바인딩인데 단가행은 PROC_000099)·디지털 인쇄비(단가행 PROC_000004인데 상품 미바인딩)가 정확히 이 사각지대.

## 3. 왜 캘린더가 빠져나갔나 (각 도구 맹점)

- `wiring_scan`: COMP_BIND_CAL_WALL은 (설계대로면) 배선+단가행 보유 → **WIRED_OK 오판**. F층 안 봄.
- `dim_conformance`: 캘린더 5종 **product_price_formulas 0행 → 아예 skip**. (바인딩 후엔 proc_cd MISSING-REVIEW로 잡힐 수 있으나 노이즈에 묻힘.)
- `score_batch`: 캘린더는 미바인딩이라 PRICE=0 BLOCKED로만 분류 — 바인딩 후엔 용지비로 PRICE≠0 나오면 제본 0 기여를 **상품레벨 통과로 가림**.
- §18 골든: "제본 6/6 verbatim 일치"는 **단가행 값**을 확인한 것 — 손으로 고른 proc_cd(099)로 계산. **상품이 실제 바인딩한 proc(021)로 안 돌림** → 매칭 불일치 자체를 못 봄.

## 4. 진단 해법 — evaluate_price 기여 추적 스캐너 (결정론·전수·토큰0)

진실 오라클 = `evaluate_price`(pricing.py) 자신. 정적 스캐너는 근사일 뿐, silent-0는 **실호출로만** 확증된다.

**`contribution_scan.py` (신규·또는 score_batch `--contrib` 모드):**
```
전 상품(공식 바인딩분) 순회:
  selection = 상품 자신의 선택수단에서 구성
     (sizes default + materials default + processes 전부 + print_options default
      + option_items + 대표 qty; proc_sels = 상품 product_processes 전부)
  res = simulate(prd_cd, selection, qty, procs=proc_sels)        # 엔진 실호출
  공식의 각 component c:
     wired      = c ∈ formula_components(frm)
     has_rows   = component_prices(c) > 0
     included   = res 비목[c].included
     subtotal   = res 비목[c].subtotal
     ▶ DEFECT(SILENT_ZERO) = wired & has_rows & (not included or subtotal==0)
        → 배선·단가행 멀쩡한데 런타임 기여 0 = 과소청구 (캘린더·base-proc 류)
  상품 판정:
     PRICE≠0 + SILENT_ZERO 비목 존재 = ★위험("청구되나 비목 누락"·겉보기 정상)
     PRICE=0                          = BLOCKED(이미 §27 NO_FORMULA/score 검출)
산출: contribution-defects.csv (prd_cd·frm·comp·wired·has_rows·included·subtotal·verdict)
      + 요약(SILENT_ZERO 비목 수·영향 상품 수·돈영향 추정)
```

**검출 보강(교차):**
- 고아 단가행 역추적: 단가행 proc_cd 값 중 **어떤 상품도 product_processes에 안 가진 proc** = 죽은 차원(PROC_000099 류) → `wiring_scan`에 "ORPHAN_DIM_VALUE" 한 종 추가.
- proc 이원화: 같은 물리 공정이 두 proc_cd(021 트윈링 vs 099 벽걸이제본)로 표현 → 중복 카탈로그 보드.

## 5. 메타 교정 (파이프라인 자체 보강)

1. **§18/§13 골든 재계산은 상품의 실제 product_processes/options로 selection 구성** — 손으로 proc_cd 고르지 말 것(매칭 불일치가 골든에서 드러나도록). 이것이 캘린더를 통과시킨 근본 구멍.
2. **§27 배선 게이트에 F층(기여) 추가** — wiring_scan(정적) GO 후 contribution_scan(런타임) GO를 종료척도에 포함. "배선 결함 0"의 정의를 "정적 0 + 런타임 기여 silent-0 = 0"으로 확장.
3. **§26 dim_conformance 미바인딩 상품도 가설 바인딩으로 예진** — 설계 예정 공식(PRF_CAL_* 등)을 가상 배선해 사전 매칭 점검(적재 전 발견).

## 6. 적용 우선순위

1. `contribution_scan.py` 빌드 → **전 상품 1패스**(이미 바인딩된 상품의 silent-0 전수 적발 — 캘린더 외 디지털 18·기타 잠복 동시 발굴).
2. 결함 보드 → §18 설계 정정(캘린더 트윈링 등) + §7 적재 명세에 "기여 검증 GO" 게이트.
3. §27 wiring 루프 종료척도에 F층 통합. 골든 메타교정(#5-1) 반영.
