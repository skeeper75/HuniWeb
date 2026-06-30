# offgrid-flatten-validation-foil.md — 박류 면적 flatten으로 C트랙 제거 가능한가 (설계-검증·라이브 실증)

> **목적**: designer 설계(engine-design-foil §3)가 박가공비 "면적→등급(A~E) 2단 lookup"을 **앱 계산→엔진 미지원→C트랙(개발팀 코드)**로 분류했다. 사용자 가설: 엔진은 이미 면적매트릭스에 off-grid ceiling을 한다(포스터/사인·아크릴 라이브 입증). **등급을 적재 시점에 단가에 미리 펼쳐 넣으면**(grade pre-expand into unit_price) 박가공비가 `(proc_cd, siz_width, siz_height, min_qty) → 단가`의 1단 면적매트릭스가 되고, 현 엔진 off-grid ceiling이 가변사이즈를 코드변경 0으로 처리한다. 그러면 접지카드·책자(가변사이즈)도 지금 적재 가능하고 신규 `t_prc_foil_area_grades` 불필요.
>
> 검증자: dbm-price-engine-verifier · 라이브 읽기전용 SELECT + 라이브 시뮬레이터 호출 + 엔진 순수함수 직접 호출 · 2026-06-30 · **DB 미적재·COMMIT 0** · adversarial.
> 권위: 가격표 박(대형/소형) verbatim = `06_extract/price-foil-{small,large}-l1.csv` · 엔진 = `raw/webadmin/webadmin/catalog/pricing.py` · 골든 = `03_design/golden-cases-foil.md`.

---

## 최종 판정(요약): **부분 GO — 면적 off-grid는 C트랙 제거하나, 새 prc_typ 결함 1건 발견(.02→.03 교정 필요·여전히 코드변경 0)**

- ✅ **면적→등급 off-grid ceiling은 엔진이 코드변경 0으로 처리한다**(라이브 실증). grade를 단가에 미리 펼치면 박가공비는 `[proc_cd, siz_width, siz_height, min_qty]` 면적매트릭스 = 아크릴 `COMP_ACRYL_CLEAR3T`(라이브 277행)와 동형. **신규 `t_prc_foil_area_grades` 테이블 불필요·기존 `t_prc_component_prices` 스키마에 그대로 적재 가능.** designer §3의 "면적→등급 환산 엔진 미지원→C트랙" 판정은 flatten 접근에서 **무효화**된다.
- 🔴 **그러나 박가공비 prc_typ을 설계 doc이 `.02 합가형`으로 잡은 것이 off-band 수량에서 과청구**한다(아래 결함). 작업 1건 고정금액(authority intent)을 정확히 재현하려면 **`.03 PRICE_TYPE_FLAT`**이어야 한다. 이건 **데이터/설계 교정**(적재 시점 prc_typ 값 변경)이지 엔진 코드 변경이 아니므로 **C트랙을 새로 만들지 않는다** — 오히려 designer가 C트랙으로 미룬 면적→등급을 데이터로 흡수.

**결론: 박 가변사이즈(접지카드·책자)는 현 엔진으로 지금 적재 가능 = C트랙 제거 GO. 단, 박가공비 prc_typ = `.03`(designer의 `.02` 부정확) + 동판비 proc_cd 게이트(codex R-FOIL-CDX1) 두 교정이 적재 명세에 반영돼야 한다.**

---

## (a) 엔진 off-grid 메커니즘 — pricing.py 라인 인용

`match_component`(pricing.py:134-190)이 한 구성요소의 단가행에서 선택값·수량에 맞는 **단일 행**을 고른다. 핵심은 **세 티어 차원(siz_width·siz_height·min_qty)을 같은 루프에서 동시에, 각 축 독립 방향으로** 처리한다는 점.

- **TIER_DIMS 정의** (pricing.py:49-50):
  `TIER_DIMS = ("siz_width", "siz_height", "min_qty")` · `TIER_UPPER = ("siz_width", "siz_height")`.
  주석(:45-48): siz_width/siz_height = **'이하' 상한**(값 ≤ 임계, 적용행 중 '최소' 임계 = 그 값을 담는 가장 작은 구간, 넘으면 다음 큰 구간). min_qty = **'이상' 하한**(qty ≥ min_qty 중 '최대' 임계).
- **동시 티어 선택 루프** (pricing.py:160-178): `for dim in TIER_DIMS:` 한 루프가 세 축을 각각 처리.
  - 상한축(siz_width/siz_height, :165-171): `eligible = [t for t in tiers if t >= cmp_val]` → `selected[dim] = min(eligible)`(주문값 이상 임계 중 최소 = ceiling to next-larger tier). 없으면 `ERR_ABOVE_MAX`.
  - 하한축(min_qty, :173-178): `eligible = [t for t in tiers if t <= cmp_val]` → `selected[dim] = max(eligible)`(주문수량 이하 구간 중 최대). 없으면 `ERR_BELOW_MIN`.
- **티어행 교차 필터** (pricing.py:179-180):
  `tier_rows = [r for r in grp if all(_tier_val(r.get(d), d in TIER_UPPER) == selected[d] for d in TIER_DIMS)]`.
  → **세 축의 selected 임계값을 모두 가진 행**이 있어야 매칭(없으면 `no_tier_row` 데이터 갭, :181-184). 즉 (ceiling된 width, ceiling된 height, band된 min_qty) **튜플이 실재하는 단가행이어야** 한다.

**designer 인용 검증**: engine-design §7이 인용한 `pricing.py:158-162`(TIER_UPPER ceiling)·`:42-50`(TIER_DIMS·NON_QTY_DIMS)는 **실재·정확**. NON_QTY_DIMS(:42-43)·TIER_DIMS(:49-50)에 **grade 차원 없음**도 확인 → 엔진이 면적값→등급 변환을 직접 못 한다는 designer §3-1·§7 판정은 맞다. **단 그것이 "C트랙 필요"를 함의하지 않는다** — grade를 단가에 미리 펼치면 grade 차원 자체가 사라지고, 남는 건 엔진이 이미 하는 width/height ceiling + min_qty band뿐이다(아래 (b)·(c) 실증).

★ **핵심 = 세 티어가 한 comp에서 동시에 작동하는가?** 코드상 `for dim in TIER_DIMS:` 단일 루프가 세 축을 각자 방향으로 처리하므로 **구조적으로 동시 작동**한다. 이를 라이브·순수함수로 실증한다.

---

## (b) 라이브 시뮬레이터 실증 — 기존 면적매트릭스 comp의 off-grid ceiling

### 검체 선정 (라이브 SELECT)

`use_dims`에 siz_width+siz_height가 함께 있는 라이브 comp 17개 중, **세 티어축이 동시에 채워진 유일 comp = `COMP_ACRYL_CLEAR3T`**:

| comp_cd | prc_typ | use_dims | 행수 | 세 축 동시 충전 |
|---|---|---|---|---|
| **COMP_ACRYL_CLEAR3T** | **.02** | `["mat_cd","siz_width","siz_height","min_qty"]` | **277** | **277/277** (w·h·minq 전행) |
| COMP_POSTER_CANVAS_FABRIC | .01 | `[siz_width,siz_height,min_qty]` | — | min_qty 전행 NULL |
| COMP_POSTER_ARTPRINT_PHOTO | .01 | `[siz_width,siz_height,min_qty]` | 52 | min_qty 0/52 |

★ **adversarial 발견**: 라이브에 **size 다구간 AND min_qty 다구간을 동시 충전한 comp는 0건**(SQL: `HAVING count(DISTINCT siz_width)>1 AND count(DISTINCT min_qty)>1` → 빈 결과). 아크릴은 width×height(14×14)는 티어링하나 **min_qty=1 단일밴드**다. 즉 "사이즈 ceiling + 수량 band를 한 comp에서 동시에"는 **라이브 미실행 경로**다. 박 flatten은 이 미실행 조합(가변 면적 × 13~18 수량밴드)을 처음 쓴다 → 라이브 시뮬레이터만으론 부족, 엔진 순수함수로 보강((c)).

### 라이브 시뮬레이터 결과 — width/height 동시·독립 ceiling 입증

`PRD_000161 판아크릴`(공식 PRF_CLR_ACRYL, 단일 comp COMP_ACRYL_CLEAR3T·MAT_000043). 그리드 width/height = …,80,90,… 단가(qty band=1): 80×80=8900·80×90=9800·90×90=10700.

| 케이스 | 입력 w×h | qty | 기대 ceiling 셀 | final_price | 판정 |
|---|---|---|---|---|---|
| on-grid | 90×90 | 1 | (90,90)=10700 | **10700** | PASS |
| **off-grid 대칭** | 85×85 | 1 | (90,90)=10700 | **10700** | PASS |
| **off-grid 비대칭** | 81×86 | 1 | (90,90)=10700 | **10700** | PASS |
| **off-grid 한 축만 상승** | 79×85 | 1 | **(80,90)=9800** | **9800** | **PASS(결정적)** |

★ `79×85 → (80,90)=9800`이 결정적 증거: **각 축이 독립적으로 ceiling**(79는 80으로 머묾·85는 90으로 상승)되며 matched_row가 정확히 `(80,90,10minq=1,9800)`. = 박 동판비/박가공비의 가로/세로 면적셀 선택과 동일 연산. **엔진은 가설이 필요로 하는 동작을 이미 한다.**

---

## (c) 등급 경계 정확성 — flatten된 박 단가행이 ceiling 시 등급 경계를 잘못 넘는가?

### (c-1) 엔진 순수함수로 "사이즈 ceiling + 수량 band 동시" 실증 (라이브 미실행 경로 보강)

`match_component`는 ORM 비의존 순수함수. **소형 일반박을 flatten**(grade를 단가에 미리 펼침)한 135행(15 면적셀 × 9 수량밴드)으로 직접 호출:

| 케이스 | 입력 | matched_row | err | 판정 |
|---|---|---|---|---|
| on-grid | 40×80 q1000 | (40,80,minq=1000,**64000**=E등급) | None | PASS |
| **면적 off-grid** | 35×35 q1000 | (40,40,minq=1000,**57000**=D) | None | PASS |
| **수량 off-band** | 40×80 q850 | (40,80,**minq=800**,52800=E@800) | None | matched 정확 / **소계는 결함**(아래) |
| **면적+수량 둘 다 off** | 35×35 q850 | (40,40,minq=800,**47200**=D@800) | None | matched 정확 |
| below-min | 40×80 q100 | — | **below_min_qty** | PASS(정확) |
| above-max | 60×60(>최대 40티어) | — | **above_max_size** | PASS(정확) |

→ **사이즈 ceiling(가로·세로)과 수량 band가 한 comp에서 동시에 올바른 셀을 고른다**. 가설의 가장 어려운 요구(3축 동시 티어링)가 엔진에서 작동.

### (c-2) ★발견 결함 — `.02 합가형`이 off-band 수량에서 과청구 (designer prc_typ 선택 오류)

위 `40×80 q850` 케이스: matched_row는 정확(min_qty=800·unit=52800)이나 **`component_subtotal(.02)` = 56,100 ≠ 52,800**.

`.02 합가형`(pricing.py:205-210)은 `per_item = unit ÷ tier_min_qty` 후 `× qty`:

| qty | band min_qty | unit | **.02 소계** | **.03 소계** | authority intent(작업1건 고정) |
|---|---|---|---|---|---|
| 800 | 800 | 52800 | 52800 | 52800 | 52,800 |
| **850** | 800 | 52800 | **56,100** | **52800** | **52,800** |
| **899** | 800 | 52800 | **59,334** | **52800** | **52,800** |
| 1000 | 1000 | 64000 | 64000 | 64000 | 64,000 |

★ **`.02`는 qty가 band의 min_qty와 정확히 같을 때만 권위값을 낸다**. 밴드 사이 수량(801~899 등)이면 선형 스케일 → **과청구**(돈크리티컬). 골든 G-F1~F8은 전부 qty가 밴드 경계(1000·10·200·500)라 `.02`로도 통과 → **골든 스위트에 off-band 수량 사각지대**. 박 authority의 "제작수량 N 이상 / 작업 1건 고정금액(수량 안 곱함)"(engine-design §4-가드 인용)을 정확히 재현하는 건 **`.03 PRICE_TYPE_FLAT`**(pricing.py:203-204: 매칭 구간 금액 그대로·수량 무관). `.03`은 band 선택(`match_component`)은 그대로 하고 곱셈만 안 한다 → off-band 수량도 flat band total.

**판정**: designer §4-가드·§7의 `박가공비 = .02 + min_qty=구간하한`은 **off-band 수량 부정확**. **교정 = `.03`**. 이건 적재 값(prc_typ_cd) 변경이지 엔진 코드 변경 아님 → **C트랙 아님**(엔진은 .03 이미 지원).
*(명함박이 `.02`로 라이브 작동하는 이유 = 명함은 사이즈 고정·수량이 항상 밴드 경계(1000 등)로 노출돼 off-band가 발생 안 함. 가변사이즈·자유수량 7상품엔 `.02`가 위험.)*

### (c-3) 등급 경계 monotonic 검증 — ceiling이 등급을 잘못 넘는가? → 아니오

flatten 행을 **티어 상한값**(authority의 '이하' 경계)으로 키잉하면, 엔진의 width/height ceiling('주문값 이상 최소 임계' = 그 값을 담는 가장 작은 셀)이 **authority가 그 사이즈에 부여하는 등급셀과 정확히 동일**하다. 위험은 등급격자가 비단조(큰 사이즈가 더 싼 등급)일 때뿐. 검증:

- **대형 등급격자(8×8) monotonic 검사**: 양 축 비감소(non-decreasing) — **위반 0건**. ∴ ceiling-to-next-tier가 항상 authority 셀에 착지. 잘못된 경계 넘음 없음.
- 구체: 35×35→(50,50)=A · 75×85→(90,90)=C · 91×91→(110,110)=D · 170×170→(170,170)=E · 171×50→OVER(>170 = ERR_ABOVE_MAX·CONFIRM 영역). 골든 G-F6(75×85→90×90→C·138,000)과 정합.
- 소형 등급격자(3×5)도 동일 단조 → ceiling 안전.

**판정**: ceiling이 등급 경계를 잘못 넘는 케이스 **없음**(등급격자 단조·flatten 키=티어 상한). 골든 일치 + 단조 입증으로 경계 정확.

---

## (d) flatten 행수 + 스키마 적합 + 아크릴 선례

### 행수 (grade를 단가에 미리 펼친 후 = 면적셀 × 수량밴드, proc_cd 색상 1개 기준)

| comp | 면적셀 | 수량밴드 | 행수(색상1) |
|---|---|---|---|
| 소형 일반 박가공비 | 15 (3×5) | 18 | 270 |
| 소형 특수 박가공비 | 15 | 18 | 270 |
| 대형 일반 박가공비 | 64 (8×8) | 13 | 832 |
| 대형 특수 박가공비 | 64 | 13 | 832 |
| 동판비 대형(setup·수량밴드 없음) | ~72 | — | ~72 × #색상 |
| 동판비 소형 | 1(고정5000) | — | 1 × #색상 |

박가공비 소계(색상1 기준) = **2,204행**. ★proc_cd 게이트 충전 시 일반/특수 그룹 내 색상은 단가 동일 → 그룹 색상 수만큼 행 복제(예 대형 일반 6색 → 832×6). 그래도 수천~만 단위로 **기존 단가표(라이브 7,293행)와 동급**·스키마 압박 없음. (대안: 색상별 복제 대신 proc_grp 메타로 1색 키잉 후 CPQ가 색상→그룹 환원 — 행수 절감 트레이드오프는 적재 명세 결정사항.)

### 스키마 적합 (라이브 information_schema)

`t_prc_component_prices` 컬럼: `proc_cd`·`siz_width`(numeric)·`siz_height`(numeric)·`min_qty`(integer)·`unit_price`·`dim_vals`(jsonb) **전부 실재**. 박 flatten `[proc_cd, siz_width, siz_height, min_qty] → unit_price`는 **기존 컬럼에 그대로 적재** → **신규 `t_prc_foil_area_grades` 테이블 불필요**.

### 아크릴 선례 (메모리 정합)

`COMP_ACRYL_CLEAR3T` = **라이브 277행**, `[mat_cd, siz_width, siz_height, min_qty]` 면적매트릭스를 **이 스키마로** 적재(메모리 acrylic siz_cd×면적 area grid 정합). 박 flatten은 `mat_cd`→`proc_cd`만 바뀐 **동형**. 선례 입증됨.

---

## 부수 확인 — 동판비 proc_cd 게이트 (codex R-FOIL-CDX1 독립 재확인)

순수함수로 REV2 버그(동판비 proc_cd NULL) 재현: 박 미선택(selections에 proc_cd 없음) + 동판비 단가행 proc_cd=NULL → `_row_matches`(pricing.py:99-100)가 NULL=와일드카드 통과 → **90×90 동판비 18,000 상시 매칭(silent 과청구)**. proc_cd 충전 시 박 미선택 → no_match → 동판비 0. **codex R-FOIL-CDX1·REV3 교정 = 유효**(라이브 계약 실증). 적재 명세에 동판비 use_dims proc_cd 게이트 필수.

---

## 최종 판정 (C트랙 제거 여부)

| 가설 주장 | 판정 | 근거 |
|---|---|---|
| 엔진 off-grid ceiling이 가변 면적을 코드변경 0으로 처리 | ✅ **GO** | 라이브 아크릴 79×85→(80,90) 비대칭 ceiling 실증·순수함수 35×35→(40,40) |
| grade pre-expand → `[proc_cd,w,h,min_qty]` 면적매트릭스 = 아크릴 동형·기존 스키마 적재 | ✅ **GO** | 스키마 컬럼 실재·아크릴 277행 선례·신규 테이블 불필요 |
| 면적→등급 환산이 C트랙(엔진 미지원) | ❌ **무효화** | grade를 단가에 펼치면 grade 차원 소멸·엔진은 width/height ceiling만 하면 됨(이미 함) |
| 박가공비 = `.02 합가형` (designer) | 🔴 **부정확** | off-band 수량 과청구(850→56,100 vs 52,800). 교정=`.03`(엔진 변경 0) |
| 가변사이즈 상품(접지카드·책자) 지금 적재 가능 | ✅ **GO**(2 교정 전제) | flatten + `.03` + 동판비 proc_cd 게이트로 현 엔진 작동 |

### 결론: **C트랙 제거 = GO**

박 가변사이즈는 **신규 엔진 코드 없이** 지금 적재 가능하다 — 면적→등급을 적재 시점에 단가로 펼치고(`[proc_cd, siz_width, siz_height, min_qty]`), **현 엔진의 off-grid ceiling이 등급셀 선택을 정확히 대행**한다(등급격자 단조라 경계 잘못 넘음 0). `t_prc_foil_area_grades` 불필요. **단 적재 명세 2건 교정 필수**: ① 박가공비 prc_typ = **`.03 PRICE_TYPE_FLAT`**(designer의 `.02`는 off-band 수량 과청구 — 새 결함 발견). ② 동판비 use_dims **proc_cd 게이트**(codex R-FOIL-CDX1). 두 교정 모두 **데이터/설계 값 변경**이지 엔진 코드 변경이 아니므로 **C트랙을 새로 만들지 않는다.**

### 가장 중요한 단일 증거
라이브 시뮬레이터: `PRD_000161 판아크릴` 79mm×85mm → matched_row `(80,90,9800)` final_price **9,800** = 각 면적 축이 **독립적으로** 다음 큰 티어로 ceiling. 이 동작이 박 면적→등급셀 선택과 동일하므로, grade를 단가에 펼치면 엔진이 박 가변사이즈를 코드변경 0으로 처리한다.

### designer 큐로 라우팅
- **G1 적재 명세 수정**: 박가공비 C-3~C-6 prc_typ **`.02`→`.03`**(off-band 수량 정확). designer가 `.02 + min_qty=구간하한`을 "명함박 동형"으로 정당화했으나 명함박은 수량이 항상 밴드 경계라 off-band 미발생 — 가변 7상품엔 `.03` 필수.
- **§3 C트랙 분류 철회 후보**: "면적→등급 환산=C트랙(Q-FOIL-CODE1)" → flatten으로 데이터 흡수 가능. dbm-price-arbiter 심의 시 본 검증 결과 반영.
- **골든 보강**: G-F 케이스에 **off-band 수량 케이스 추가**(예 소형 일반 40×80 q850 → 52,800 flat). 현 골든은 밴드경계 수량만이라 `.02` vs `.03` 차이를 못 잡음.
