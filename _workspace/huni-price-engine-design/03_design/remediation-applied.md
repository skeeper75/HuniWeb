# remediation-applied.md — 디지털인쇄 설계 보정 폐루프 적용 요약

> **hpe-engine-designer 산출.** Phase 4 hpe-validator NO-GO(E5·E6 FAIL) + Phase 5.5 codex 교차검증(FAIL·합의)
> 후 **설계 측 보정만** 적용한 변경 요약. 돈크리티컬 prc_typ 교정방향(R-1/R-4/R-6)은 dbm-price-arbiter 심의 +
> 사용자 컨펌 대기 — 설계는 결함+교정후보까지만 명세하고 어느 방향도 확정하지 않음.
> 적용일 2026-06-20 · 라이브 읽기전용 SELECT만 · DB 쓰기 0 · 단가값 verbatim(날조 0).

---

## 적용한 보정 (설계 측)

| # | 보정 | 파일 | 무엇을 어떻게 |
|---|------|------|--------------|
| **R-2** | D-2b 재서술 (ERR_AMBIGUOUS → silent 이중합산) | design-decisions D-2/D-3·engine-design 3.0/3.2·golden §4(GC-9)·set-product 1.3 | "STD_S1·S2 동시매칭 → ERR_AMBIGUOUS 견적 깨짐"을 **"print_opt_cd=NULL 와일드카드로 둘 다 매칭→silent 합산 800,000(경고 없이 과청구·더 위험)"**로 정정. ★근거: S1/S2는 서로 다른 comp_cd라 `match_component` 내부서 안 만남 → ERR_AMBIGUOUS(pricing.py:136-138, 한 comp의 단가행들 사이)는 발생 안 함. 명함·엽서북 PCB 동형. GC-9 제목 "ERR_AMBIGUOUS 회귀"→"인쇄면 silent 이중합산 회귀"로 변경 |
| **R-3** | 엽서북 "이중계상 0" 판정 철회·명함 동일 결함군 재분류 | set-product 1.2/1.3/§5·golden GC-7/8 | "엽서북=고정가 단일·이중계상 0" 판정을 **두 종류로 분리**: ① **BOM(내지+표지) 의미 이중계상 = 0 유지** ✅(완제품 통합단가가 둘 다 포함·별 합산 금지 가드 유효·codex 합의) ② **가격엔진 축 이중합산/과청구 ≠ 0** ❌(S1_20P+S2_20P silent 이중합산 + prc_typ ×qty). 엽서북을 명함과 동일 결함군(V-DGP-1·D-10)으로 재분류. §5 요약표에 "BOM 이중계상"·"가격축 결함" 2열 분리 |
| **R-5** | D-3 사유 정정 (충전이 푸는 건 이중합산이지 ambiguous 아님) | design-decisions D-3·golden GC-9 | "print_opt_cd 충전 → ambiguous 해소"를 **"충전이 푸는 것은 silent 이중합산(R-2)이지 ambiguous 아님. 충전 자체는 타당(POPT_000001/002 실재). 단 option_items 매핑 0행이라 옵션→차원 자동주입 미연결(G-7 유효)"**로 정정 |
| **D-2** | codex use_dims 보강 가설 라이브 검증 + 해소법 반영 | design-decisions D-3 ★·engine-design 3.2·5(use_dims 등재 행 추가) | 아래 §D-2 검증 결과 참조. 해소법 = **단가행 print_opt_cd 컬럼 충전 + 해당 comp의 use_dims 배열에 print_opt_cd 등재 양쪽 필요**로 명세 |
| **R-1 + 골든 정정** | 고정가형 골든 양면표기·범위 전 고정가형 확장 | golden §0.1 신설·GC-1/3/4/6/7/8·§6 체크리스트 | 각 고정가형 골든을 **"설계 기대값(verbatim·옳음)" vs "현 라이브 산출값(×qty 폭발·결함)"** 양면 표기 + 진원(라이브 prc_typ/차원부재) 명시. 범위를 명함 8종→**전 고정가형(명함+엽서북+포토카드BULK+박 FOIL/SETUP)** 확장. §0.1에 8케이스 양면표 신설 |

### 부수 보정 (위 보정의 일관성 유지)
- **D-10 확장** (design-decisions): "명함 8종 잠재결함"→"전 고정가형 횡단 확정 결함"(배수표 6행)·교정후보 X/Y 명세·방향 컨펌 대기.
- **D-11 신설** (design-decisions): 박 SETUP(동판비) use_dims=[]·단가형 ×qty 폭발을 D-10에서 분리해 별 결함으로 명세(R-4 설계측 명세분)·정액 처리 컨펌 대기.
- **컨펌큐 갱신** (design-decisions): D-10/CV-1·CV-2·CV-4/D-11·G-7 행 갱신.

---

## D-2 use_dims 가설 라이브 검증 결과 (codex 보강 가설)

**codex 가설**: "print_opt_cd는 단가행 컬럼 충전뿐 아니라 해당 comp의 use_dims 배열에도 포함돼야 효과가 있다(매칭은 use_dims 기준이므로)."

**판정: 결론은 맞다(둘 다 필요). 단 codex가 댄 사유는 틀렸다.**

### 라이브/코드 실측 (읽기전용 SELECT + pricing.py 소스 대조)

1. **use_dims 실측** (`t_prc_price_components.use_dims`):
   - COMP_NAMECARD_STD_S1 / STD_S2 = `["mat_cd","min_qty"]` (print_opt_cd **미등재**)
   - COMP_PCB_S1_20P / S2_20P = `["siz_cd","min_qty"]` (print_opt_cd 미등재)
   - COMP_NAMECARD_FOIL_SETUP_S1_STD = `[]` (use_dims=[]·D-11 근거 재확인)

2. **매칭 메커니즘 실측** (pricing.py):
   - `_row_matches`(:78-90)·`_combo_key`(:93-95)는 **고정 상수 `NON_QTY_DIMS`**(:38-39 = siz_cd·plt_siz_cd·**print_opt_cd**·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty)를 순회한다. **`use_dims` 배열은 행 매칭 로직에 쓰이지 않는다.**
   - print_opt_cd는 이미 NON_QTY_DIMS 멤버 → **단가행 컬럼에 값만 충전하면(NULL→코드)** `_row_matches`가 즉시 차원으로 작동(단면행=단면 선택만 통과). **∴ 컬럼 충전만으로 매칭(=이중합산 차단)은 성립** → codex의 "매칭이 use_dims 기준" 사유는 **거짓**.
   - use_dims가 쓰이는 곳: `_match_entry`(:412-415, "판별차원 없음 항상매칭" 경고/note 산출)·`_evaluate_formula`(:460-461, proc comp 판정). 즉 **경고/주입 레이어용**.

3. **그럼에도 use_dims 등재가 필요한 이유 2가지**:
   - ① use_dims에 print_opt_cd 미등재 시, 컬럼을 충전해도 `_match_entry`가 **잘못된 "판별차원 없음 — 항상 매칭" note**(:414-415)를 남김(오경고).
   - ② 옵션→차원 자동주입 레이어(option_items→selections)가 use_dims를 읽어 "손님에게 받을 차원"을 정한다면, print_opt_cd 미등재 시 인쇄면 선택값이 selections에 안 실림 → 충전된 행(non-NULL)과 NULL 선택값 불일치 → 이중합산이 아니라 **0원 침묵(no_match)** 으로 부작용이 뒤집힘.

### 반영

해소법 명세(design-decisions D-3 ★·engine-design 3.2·§5)에 **"① 단가행 print_opt_cd 컬럼 충전 + ② 두 comp의 use_dims 배열에 print_opt_cd 등재 동시"**를 무손실 해법으로 기록. 둘 중 하나만 하면 각각 오경고 / 0원 침묵 부작용.

★ 단, 옵션→차원 자동주입 레이어는 **option_items 매핑 0행이라 현재 미연결**(G-7) — 주입 레이어 실연결 시점에 use_dims 효과가 발현되므로 컨펌큐 G-7로 유지.

---

## 컨펌 대기로 남긴 항목 (돈크리티컬 — 방향 확정 금지)

| # | 항목 | 누가 | 설계 명세 상태 |
|---|------|------|---------------|
| **R-1 / D-10 / CV-1** | 고정가형 단가 의미 = 묶음/구간총액인가 장당가인가 → prc_typ 교정방향(합가형÷min_qty=X / qty정규화=Y) | dbm-price-arbiter + 사용자 | 결함 범위(전 고정가형) 확정·교정후보 X/Y 양쪽 명세·**어느 방향도 확정 안 함** |
| **R-4 / D-11 / CV-4** | 박 SETUP(동판비) = 수량 무관 1회 정액 확정인가 + 정액 처리법(현 엔진 정액 모드 부재) | 사용자·가격표·dbm-price-arbiter | 결함(use_dims=[]·×qty) 명세·후보(합가형 min_qty=1로도 정액 불가→qty=1 정규화/엔진 확장) 명세·**확정 안 함** |
| **R-6 / CV-2** | 명함 주문 UX = 100매 고정세트인가 장당 누적인가(X vs Y 결정) | 사용자 | 컨펌큐 명시 |
| **G-7** | 인쇄 옵션값↔POPT 코드 매핑·옵션→차원 자동주입(option_items 0행 미연결) | designer/사용자 | D-3/D-2 해소법 전제·미연결 명시 |

★ 본 보정은 **메커니즘·범위·판정 오기**의 설계측 정정 + use_dims 가설 라이브 검증까지. **단가값은 전부 verbatim 불변·교정방향은 확정 안 함**. 실 교정(prc_typ 전환·print_opt_cd 충전·use_dims UPDATE·박 SETUP 처리)은 **인간 승인 후 dbmap 위임**(dbm-price-arbiter 심의 → dbm-axis-staged-load·dbm-load-execution).

## DB 미적재 [HARD]
라이브 읽기전용 SELECT만 수행(use_dims·prc_typ 실측·pricing.py 소스 대조)·DB 쓰기 0. 산출은 03_design 보정본 + 본 요약.
