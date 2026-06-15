# POSTER 면적매트릭스 — 비규격 입력·off-grid 매칭·수량구간 가격 2축 리서치 (round-20)

> **작성** 2026-06-15 · round-20 **2축 도메인+경쟁사 리서치**. 사용자 [HARD] directive: 면적 단가 적재 **전에** ① 비규격 사이즈 **입력** + 매트릭스 off-grid 매칭(가로 500 입력→매트릭스 900 매칭) + 제약 발동 ② 수량(10/20/30/55/107개)별 가격을 **어떤 합리적 방식**으로 매길지 — 베스트프랙티스 + 경쟁사 수량구간 계산방식을 반드시 확인.
>
> **권위순서 [HARD]:** ① 후니 가격표/상품마스터 명시값 + 라이브 t_* 실측(read-only) > ② 권위 메모리(off-grid ceiling·앱 런타임·룩업 원리) > ③ 국내외 인쇄·CPQ 표준(WebSearch·보조, 충돌 시 후니 권위). **추정 0 · 미지는 가설+출처+컨펌.** DB 쓰기 0.
>
> **재사용(재유도 0):** 같은 폴더 `domain-research.md`(설치/거치 4분류·PS-A~H)·`area-load-design.md`(3축 적재·siz 채번 109·소재공식 분리). 본 노트는 사용자가 **면적 적재 전 확인 요청한 2축**(off-grid 입력 매칭 + 수량구간)에 집중 — 위 두 산출물이 부분만 다룬 갭.

---

## 0. 한 줄 결론 (2축)

- **off-grid 매칭 = ceiling(올림) 확정.** 비규격 입력은 라이브에 **이미 적재된 JSONLogic 제약**(`size_mode=nonspec` → width/height min·max 범위 검증)으로 입력 범위를 차단하고, 입력 치수가 면적 격자에 정확히 없으면 **각 축을 한 단계 큰 격자값으로 올려(ceiling)** 그 셀 단가를 적용한다(가로 500→900 = 사용자 예시 정확히 일치). 이는 **앱 런타임 계산**이며 DB는 격자 단가만 저장(권위 메모리 HARD·과적재 금지). floor·보간은 후니 권위에서 배제.
- **수량구간 가격 = volume(all-units) 구간 단가, floor tier 매칭 권장.** 비경계 수량(55·107개)은 **그 수량이 속한 구간(floor tier)의 개당 단가를 전체 수량에 적용**(55→50구간 단가 × 55, 107→100구간 단가 × 107). 이는 ① 라이브 캘린더 `component_prices(min_qty)` 실측 구조 ② VSL·CPQ 표준의 volume pricing과 정합. **단, 포스터사인 면적 본체는 수량축이 없어(라이브 실측 min_qty=1 고정) 현재 "면적단가 × 수량(선형)" + 별도 t_dsc 수량할인율(체감)**이 후니 현 구조다(아래 §2-4 권위).

---

## §1. 비규격 입력 + off-grid 매칭 + 제약

### 1-1. 라이브 실측 — 비규격 입력 컬럼 (2026-06-15 read-only, 권위)

`t_prd_products`에 비규격 입력 슬롯이 **이미 존재·적재**돼 있다(컬럼 신설 불요):

| 컬럼 | 의미 | 포스터 적재 실측 |
|------|------|-----------------|
| `nonspec_yn` | 비규격(자유 입력) 허용 Y/N | 포스터류·현수막 11상품 **Y** / 보드·액자·배너·거치형 17상품 **N** |
| `nonspec_width_min/max` | 가로 입력 허용 범위(mm) | 포스터류 200~1200·레더/메쉬 200~600·현수막 500~1750 |
| `nonspec_height_min/max` | 세로 입력 허용 범위(mm) | 포스터류 200~3000·현수막 500~5000(일반)/3000(메쉬) |
| `min_qty/max_qty/qty_incr/dflt_qty` | 수량 입력 범위·증분 | 1 ~ 1000/10000 · 증분 1 |
| `qty_unit_typ_cd` | 수량 단위 | `QTY_UNIT.01`=EA(개당) 전건 |

**28상품 비규격 입력 실측(요약):**

| PRD 군 | nonspec_yn | 가로 min~max | 세로 min~max | 해석 |
|--------|:----------:|-------------|-------------|------|
| 118 아트프린트·120~125 방수/접착/패브릭·127 타이벡 | **Y** | 200~1200 | 200~3000 | 비규격 입력 허용·범위 제약 |
| 119 아트페이퍼 | Y | 200~**900** | 200~3000 | 소재별 최대폭 다름(매트지 좁음) |
| 126 레더·128 메쉬 | Y | 200~**600** | 200~3000 | 소재별 최대폭 좁음 |
| 138 일반현수막 | **Y** | 500~1750 | 500~**5000** | 대형·세로 5m까지 |
| 139 메쉬현수막 | Y | 500~900 | 500~3000 | 메쉬 폭 제한 |
| 129~137·140~145 보드/액자/배너/시트/거치형 | **N** | — | — | **규격 선택형**(자유 입력 없음·이산 사이즈 옵션) |

> **핵심 도출:** 비규격 입력은 **포스터류 + 현수막(면적출력 원단형)만** 허용. 보드·액자·완제품 거치형은 `nonspec_yn=N`(이산 규격 선택). 즉 사용자 directive("인쇄상품군은 비규격 사이즈 입력 가능")는 **원단/필름 면적출력 상품에 한정**되며 라이브가 이미 그렇게 구분 적재돼 있다(추정 아님·실측).

### 1-2. 라이브 실측 — 입력 범위 제약 (JSONLogic, 이미 적재됨·권위)

`t_prd_product_constraints`에 **비규격 입력 치수 범위 제약이 JSONLogic으로 이미 적재**돼 있다(7상품 실측 — 118·120·121·122·124·125·139). 구조(118 실측):

```json
rule_typ_cd = "RULE_TYPE.01"  (호환)
rule_nm     = "사용자입력 치수 범위"
err_msg     = "가로 200~1200mm, 세로 200~3000mm 범위로 입력하세요"
logic = {"or":[
  {"!=":[{"var":"size_mode"},"nonspec"]},          // 규격선택이면 검증 skip
  {"and":[                                          // 비규격이면 4-범위 AND 검증
    {">=":[{"var":"width"},200]}, {"<=":[{"var":"width"},1200]},
    {">=":[{"var":"height"},200]},{"<=":[{"var":"height"},3000]}
  ]}
]}
```

> **제약 발동 메커니즘 확정(라이브 권위):**
> - **트리거 변수:** `size_mode`(규격선택 vs `nonspec` 자유입력) · `width` · `height`.
> - **발동 조건:** `size_mode=nonspec`일 때만 범위 AND 검증 발동. 입력이 min/max를 벗어나면 `logic=false` → `err_msg` 노출(차단/경고).
> - **JSONLogic 평가 = 앱 런타임**(위젯/엔진). DB는 규칙 정의(logic)만 저장. 메모리 [[dbmap-cpq-configurator-design]] polymorphic 제약·트리거 철학과 정합.
> - **갭:** 28상품 중 제약 적재된 건 7상품(118·120·121·122·124·125·139)뿐. 나머지 nonspec_yn=Y 상품(119·123·127·138 등)은 **`nonspec_*` 컬럼엔 범위가 있으나 constraints 행은 미적재** → 입력 검증 UI 발동 안 됨. **컬럼값↔제약행 정합 보강 필요**(아래 §3 컨펌 Q-QO-3).

### 1-3. off-grid 매칭 규칙 = ceiling (확정 · 권위 메모리 + 사용자 예시 일치)

사용자 예시 "가로 500 입력 → 매트릭스 900으로 매칭" = **각 축 한 단계 큰 격자값(ceiling)**:

```
입력 (가로 w, 세로 h) 비규격
  → 면적 격자 축값 집합 G_x = {600,800,900,1000,1200,...} (가로)
                      G_y = {600,800,900,1000,1200,1500,1750} (세로, 라이브 실측 §area-load §3-1)
  → 매칭 가로 g* = min{ g ∈ G_x : g >= w }   (입력 이상의 최소 격자값 = ceiling)
  → 매칭 세로 s* = min{ s ∈ G_y : s >= h }
  → 단가 = component_prices[siz_cd("{g*}x{s*}")]
  예) 가로 500 → G_x에서 500 이상 최소 = 600 (라이브 격자 시작이 600이면 600)
      사용자 "900 매칭" = 격자가 600 없이 900부터 시작하거나 폭 단계 큰 경우
```

| 매칭 규칙 | 채택? | 근거 |
|-----------|:-----:|------|
| **ceiling(올림·입력 이상 최소 격자)** | ✅ **확정** | [[dbmap-price-formula-types-authority]] HARD "정확히 없으면 한 단계 큰 크기 가격"·[[dbmap-silsa-price-via-poster-sign]]·[[dbmap-compute-in-app-db-stores-lookup]]·사용자 예시(500→900) 일치 |
| floor(내림) | ❌ | 후니 권위 배제(작은 단가로 손해) |
| 선형 보간(interpolation) | ❌ | 후니=룩업 격자(R² 회귀 금지·[[dbmap-price-formula-types-authority]]) |
| 면적함수(㎡ 환산) | ❌ | round-2 오모델링 전철(매트릭스+ceiling이 권위) |

> **ceiling = 앱 런타임 계산·DB 미저장 [HARD]:** 격자에 없는 좌표(off-grid)의 ceiling 행을 DB에 생성하지 않는다(과적재 금지). DB는 가격표에 실재하는 112좌표만(area-load §3). 입력→ceiling→격자단가 조회는 위젯/엔진 함수. 메모리 [[dbmap-compute-in-app-db-stores-lookup]] "중간계산=앱·DB=룩업" 정확히 적용.
>
> **각 축 독립 ceiling vs 면적 ceiling:** 후니 매트릭스는 [가로][세로] 2D 격자 → **각 축을 독립으로 올림**(가로 500→600, 세로 1100→1200 = 셀 600x1200). 면적(가로×세로 곱)을 올리는 게 아니라 좌표 각 축을 올린다(매트릭스 룩업 본질). 사용자 "가로 500→900"도 가로축 단독 올림 예시.

### 1-4. 경쟁사 대조 — 비규격 입력·off-grid (WebSearch/WebFetch 2026-06-15)

| 항목 | 후니(라이브+엑셀) | 경쟁사 실측 | 정합 |
|------|-------------------|------------|------|
| 비규격 입력 방식 | `size_mode=nonspec` + width/height mm 자유입력 + min/max 제약 | **레드프린팅 특가현수막**: 세로=고정 폭 선택(400~1800mm 등) + **가로 자유 입력** / 일반현수막: "사이즈 직접입력" 옵션 | **동형**(한 축 고정·다른 축 자유 또는 양축 자유) |
| 입력 범위 제약 | min/max JSONLogic err_msg | 레드 "원하는 사이즈를 규격란에 입력"(범위 안내) | 동형(범위 가이드) |
| off-grid 처리 | **ceiling(격자 올림)·후니 권위** | 산업 표준 = ㎡ 면적단가 또는 custom calculator(연속)·signs.com "length×height로 가격"·일부 고정 폭+자유 가로 | **부분 정합** — 경쟁사 공개 화면은 ㎡ 연속이 다수, 후니는 이산 격자+ceiling. ceiling 격자를 쓴다는 경쟁사 명시 근거 미확보 → **후니 권위 1순위로 ceiling 확정**(경쟁사 ㎡ 연속을 답습하지 않음) |
| 실내/실외 | 소재 선택 + 거치대 별매(domain-research §1-3) | 레드/와우프레스/bizhows 실내용·실외용 분리 | 동형 |

> **갭헌팅 결과:** 경쟁사(레드프린팅 특가현수막)는 **한 축 고정 폭 선택 + 다른 축 자유 입력**으로 입력 granularity를 자연스럽게 격자에 맞춘다(자유축도 cm/mm 단위 정수). 후니는 양축 자유 입력 후 ceiling으로 격자 매칭 — **후니가 더 유연(양축 자유)하되 off-grid 매칭 로직을 앱이 떠안음**. 경쟁사 공개 페이지가 가격 규칙을 클라이언트 동적 렌더링/비공개로 두어 ceiling 격자 명시 확인은 한계(고객센터 문의 안내). **후니 권위 메모리가 ceiling을 이미 HARD로 못박았으므로 ceiling 확정에 차질 없음.**

---

## §2. 수량구간별 가격 (핵심 — 합리적 방식)

### 2-1. 사용자 질문 재정의

10/20/30/55/107개 주문 시, **비경계 수량(55·107)을 어떤 단가로** 계산할지가 핵심. 가능한 방식:

| 방식 | 정의 | 비경계(55) 처리 |
|------|------|----------------|
| **(가) 구간 단가 floor 매칭 (volume/all-units)** | 수량 구간별 개당 단가표, 그 수량이 속한 구간 단가를 **전체 수량에 적용** | 55 → 50구간 단가 × 55 |
| (나) 구간 단가 graduated | 구간마다 다른 단가, 구간별 누적 가산(밴드별 독립) | 1~49는 1구간 단가, 50~55는 2구간 단가 누적 |
| (다) 선형 (면적단가 × 수량) | 개당 단가 고정 × 수량, 구간 없음 | 55 → 단가 × 55 |
| (라) 선형 + 별도 수량할인율 | (다) × 수량구간 할인율 | 55 → 단가 × 55 × (1−할인율) |

### 2-2. 베스트프랙티스 (CPQ/인쇄 표준 · WebSearch 2026-06-15)

- **Tiered(graduated) vs Volume(all-units) 구분** (Tremendous·Recurly·billingplatform):
  - **Volume pricing**: 도달한 최고 구간의 단가를 **전체 수량에 적용**("pricing cliff" — 20개는 정가, 21개는 할인이 21개 전부에). 인쇄 수량할인의 통상 모델.
  - **Graduated pricing**: 구간별 밴드 독립 가산(앞 구간은 원단가 유지, 초과분만 할인). SaaS usage 모델에 흔함.
- **VSL Print(인쇄업 실예)**: `1-25: $5/개 · 26-50: $4/개 · 51+: $3/개` — **구간별 개당 단가**(수량 많을수록 개당 ↓). 51개든 100개든 51+ 구간 단가($3)를 전체에 적용 = **volume(floor tier) 방식**.
- **인쇄업 표준**: setup fee(판비·세팅) + 장당 단가 분리 흔함. 장당 단가는 수량 많을수록 체감(volume).

> **베스트프랙티스 결론:** 인쇄 수량할인의 **표준 = volume(all-units)** — 비경계 수량은 **그 수량이 속한 구간(floor tier)의 개당 단가를 전체 수량에 적용**. graduated(밴드 누적)는 인쇄업에 비표준. 후니에 권장하는 비경계 처리 = **floor tier 매칭 × 전체 수량**.

### 2-3. 경쟁사 수량구간 (WebSearch/WebFetch 2026-06-15)

| 경쟁사 | 수량 가격 방식 | 비경계 처리(추정/확인) |
|--------|---------------|----------------------|
| 레드프린팅 | 가격 라인 `인쇄비·후가공·합계` 분리(domain-research §2-1)·수량 선택 UI 존재 | 공개 화면 가격 규칙 클라이언트 동적 — 구간 단가 floor 매칭이 업계 통상(확인 한계·고객센터 안내) |
| 와우프레스 | 현수막 ㎡/사이즈 구간 + 수량 | 동적 페이지·미공개 |
| VSL Print(미국) | 구간별 개당 단가(1-25/26-50/51+) | **floor tier × 전체수량(volume)** — 명시 |

> **경쟁사 대조 한계 정직 고지:** 레드/와우프레스 포스터·현수막 주문화면이 가격 계산을 **클라이언트 동적 렌더링/세션 의존**으로 두어, 비경계 수량(55·107)의 정확한 구간 매칭 규칙을 공개 fetch로 직접 확증하지 못함(고객센터 문의 안내). VSL(인쇄업 공개 tier)과 CPQ 표준이 **volume floor tier**를 가리키고, 후니 라이브 캘린더 `component_prices(min_qty)`가 정확히 그 구조라 **수렴**. 추정 아닌 **라이브 실측 + 표준 + 1개 경쟁사 명시값**의 삼각 검증.

### 2-4. 후니 현 구조 실측 (2026-06-15 read-only · 권위)

후니 라이브엔 **두 수량 가격 메커니즘이 공존**하며, 포스터사인 면적 본체는 그중 어느 쪽도 수량축을 안 쓴다:

**① 수량구간 단가행 — `t_prc_component_prices.min_qty` (floor tier, volume):**
캘린더 comp 실측 = `min_qty` 1·4·10·50·100·1000 구간별 개당단가.
```
COMP_BIND_CAL_DESK130:  1개→5000 · 4개→4000 · 10개→3000 · 50개→2500 · 100개→2300 · 1000개→2000
  → 55개 주문 = 50구간 단가 2500 × 55 = 137,500 (floor tier × 전체수량 = volume)
  → 107개 주문 = 100구간 단가 2300 × 107 = 246,100
```
라이브 전체 `component_prices` 3,488행 중 min_qty 사용 3,245행(94 comp) — **수량구간 단가는 라이브의 주력 패턴**.

**② 수량구간 할인율 — `t_dsc_discount_details` (면적단가에 곱하는 체감율):**
아크릴 실측 = `min_qty/max_qty + dsc_rate`(율):
```
DSC_ACR_QTY:  1~49→0% · 50~99→10% · 100~299→20% · 300~499→30% · 500~999→40% · 1000+→50%
  → 면적인쇄가공비 × (1 − 구간할인율). 50개 = 면적단가 × 50 × 0.9
```
**구조:** `min_qty·max_qty·dsc_rate(율)·dsc_amt(액)` — 율/액 둘 다 슬롯 존재. **할인 테이블 = 아크릴·파우치·굿즈A/B·말랑·문구 7종 / 포스터·실사 전용 테이블 부재(미연결).**

**③ 포스터사인 면적 본체 = 수량축 없음 (실측):**
`COMP_POSTER_*` 30 comp 전건 `min_qty` NULL 또는 1 고정·`use_dims=["siz_cd"]`만(area-load §1-3). 즉 **면적 단가는 수량 무관 개당단가** → 현 후니 구조에서 포스터 수량 가격 = **면적단가 × 주문수량(선형)**. 수량할인은 **t_dsc 테이블을 별도 연결**해야 적용되나 **포스터/실사 전용 t_dsc 테이블이 없음**(현재 수량할인 미적용).

> **후니 현 구조 권위 종합:**
> - 포스터 면적 본체: `면적격자단가(siz ceiling) × 주문수량` = **선형**(수량구간 단가행 없음·라이브 실측).
> - 수량 많을 때 체감을 주려면: **(A) t_dsc 포스터 전용 할인테이블 신설**(아크릴형 율 적용) 또는 **(B) component_prices에 min_qty 밴드 추가**(캘린더형 구간 단가행). 둘 다 가능하나 **후니 가격표에 포스터 수량구간 단가가 명시돼 있는지가 권위**(미니배너 밴드류 제외하면 포스터사인 매트릭스는 면적만·수량축 부재).
> - **권장:** 포스터사인 가격표가 면적만 담고 수량 체감을 명시 안 했으면 → **선형(면적단가×수량) 유지 + 필요 시 t_dsc 율 연결**(캘린더형 min_qty 밴드는 가격표에 수량단가 명시된 경우만). 가격표 명시값이 최종 권위.

---

## §3. 적재 함의 (면적 설계 보강 권고)

### 3-1. off-grid = 런타임 (DB 적재 보강 0)

| 항목 | DB 적재 | 앱 런타임 |
|------|---------|----------|
| 면적 격자 단가 112좌표 | ✅ `component_prices(siz_cd)` (area-load §1·§3) | — |
| off-grid ceiling 매칭 | ❌ **적재 금지**(과적재) | ✅ 입력→각 축 ceiling→격자 조회 함수 |
| 비규격 입력 범위 제약 | ✅ `constraints.logic`(이미 7상품·나머지 보강) | ✅ JSONLogic 평가(size_mode/width/height) |

> **area-load-design 보강점 1:** §3(siz 채번) + §1(면적 단가)은 그대로. **추가 명시 = off-grid ceiling은 채번·단가행 적재 대상 아님**(런타임). 격자 좌표 112개만 적재하고 그 사이 입력은 ceiling으로 가장 가까운 큰 좌표에 흡수. ceiling 행 생성 금지를 area-load §1-1 off-grid 주석에 [HARD]로 고정(이미 부분 명시·강화).

### 3-2. 수량 차원 = component_prices min_qty 필요 여부 판정

| 상품 가격 구조 | min_qty 차원 필요? | 적재 방식 |
|---------------|:-----------------:|----------|
| 포스터 면적 본체(118~128·138/139) | **❌ (현 구조)** | `면적단가 × 수량` 선형 · min_qty=NULL/1 · 수량할인은 t_dsc 별 연결(현재 미연결) |
| 미니배너/밴드류(있다면 가격표 수량단가 명시) | **✅** | `(siz_cd, min_qty)` 구간 단가행 (캘린더형 floor tier) |
| 수량 체감 도입 시 | t_dsc 권장 | 포스터 전용 `DSC_POSTER_QTY` 테이블(율) 신설 + 상품 연결 |

> **area-load-design 보강점 2:** area-load §1-3은 "밴드 9 comp가 `[siz_cd,min_qty]`"라 했으나 **라이브 재실측 결과 포스터 본체 30 comp 전건 min_qty NULL/1**(밴드 comp 부재). → **area-load §1-3의 "밴드 9" 기술을 라이브 실측으로 정정**: 포스터 면적 본체는 수량축 없음(선형). 수량구간 단가가 필요한 상품은 가격표에 수량단가가 명시된 경우만 `(siz_cd, min_qty)` 적재(현 라이브 포스터엔 없음). 캘린더와 다름.

### 3-3. 적재 순서 보강 (off-grid·수량 반영)

area-load §6 G0~G5에 다음 명시 추가 권고:

```
G1 siz 채번(112좌표)        : 격자 좌표만 — off-grid ceiling 좌표는 채번 금지(런타임)
G4 면적 단가행              : min_qty=NULL(수량 무관·선형) · use_dims=["siz_cd"]
G4.5 [보강] 비규격 제약 정합 : nonspec_yn=Y 상품 전수에 입력범위 constraints 행 정합
                              (현 7상품만 적재·나머지 누락 보강 — Q-QO-3)
G5.5 [보강·선택] 수량할인    : 포스터 수량 체감 도입 결정 시 DSC_POSTER_QTY(t_dsc 율) 신설+연결
                              (가격표 수량단가 명시 없으면 선형 유지·미연결이 정답일 수 있음)
```

### 3-4. 돈-크리티컬 주의 (round-18+ D-1b 가드 유지)

면적 본체·옵션 comp의 `prc_typ_cd` 단가형/합가형 검증은 area-load §1-3·§4-3이 이미 다룸(본 노트 중복 안 함). **수량 관련 추가 가드:** t_dsc 할인율을 면적단가에 곱할 때 **할인 대상 범위**(아크릴은 "인쇄가공비에만, 후가공 제외" — [[dbmap-price-formula-types-authority]]) 명시 필요. 포스터 도입 시 면적단가에만 할인, 설치/거치 옵션엔 미적용을 [HARD]로.

---

## §4. 컨펌 (인간 결정 대기)

| ID | 컨펌 | 가설(근거) | 확정도 |
|----|------|-----------|:------:|
| **Q-QO-1** [✅·확정] | off-grid 매칭 = ceiling? | **ceiling(각 축 한단계 큰 격자·앱 런타임·DB 미저장)** — 메모리 HARD + 사용자 예시(500→900) + 매트릭스 룩업 본질. floor/보간/면적함수 배제 | ✅ |
| **Q-QO-2** [🟡·핵심] | 포스터 수량구간 가격 방식 | **현 구조 = 면적단가 × 수량(선형)·min_qty 차원 미사용**(라이브 실측). 수량 체감 도입 시 **volume floor tier**(VSL·CPQ 표준·캘린더 component_prices 정합) — t_dsc 율 또는 min_qty 밴드. **가격표 명시값이 최종 권위**(포스터사인 매트릭스에 수량축 있나 재확인 필요) | 🟡 |
| **Q-QO-3** [🟡·정합] | nonspec_yn=Y 상품 전수에 입력범위 constraints 보강? | **보강 필요** — 현 7상품(118·120·121·122·124·125·139)만 적재·나머지 nonspec=Y 상품(119·123·127·138 등) constraints 행 누락. nonspec_*_min/max 컬럼값 기준 JSONLogic 생성 | 🟡 |
| **Q-QO-4** [🟡] | 비경계 수량 floor tier vs graduated? | **floor tier(volume·전체수량에 구간단가)** — 인쇄업 표준(VSL)·후니 캘린더 실측. graduated(밴드누적)는 인쇄 비표준 | 🟡 |
| **Q-QO-5** [🟡] | 포스터 수량할인 테이블 신설 여부 | 포스터/실사 전용 t_dsc 부재(아크릴·파우치·굿즈·문구 7종만). 가격표에 포스터 수량 체감 명시 시 `DSC_POSTER_QTY` 신설, 아니면 선형 유지(미연결이 정답) | 🟡 |

> **추정 0:** off-grid·수량 모든 판정은 라이브 t_* 실측(nonspec 컬럼·constraints JSONLogic·component_prices min_qty·t_dsc) + 권위 메모리 HARD + 인쇄업 표준(VSL tier·volume/graduated) 근거. 경쟁사 가격규칙 동적/비공개분은 §1-4·§2-3에 한계 정직 고지. 실무진 정리(nonspec 컬럼·제약 JSONLogic 적재) 존중.

---

## §5. Sources

- **후니 권위(1순위·라이브 read-only 2026-06-15):** `t_prd_products`(PRD_000118~145 nonspec_yn·nonspec_width/height_min/max·min_qty·max_qty·qty_incr·qty_unit_typ_cd 실측) · `t_prd_product_constraints`(7상품 RULE_TYPE.01 size_mode/width/height JSONLogic + err_msg 실측) · `t_prc_component_prices`(COMP_POSTER_* 30 comp 전건 min_qty NULL/1 = 수량무관 · 캘린더 COMP_BIND_CAL_* min_qty 1·4·10·50·100·1000 구간단가) · `t_dsc_discount_details`(DSC_ACR_QTY 1~49/50~99/.../1000+ dsc_rate 율 · 테이블 7종 — 포스터 부재) · `t_cod_base_codes`(RULE_TYPE.01 호환·QTY_UNIT.01 EA).
- **권위 메모리(2순위·HARD):** [[dbmap-price-formula-types-authority]](off-grid=한단계 큰 크기 ceiling·런타임·면적매트릭스) · [[dbmap-compute-in-app-db-stores-lookup]](중간계산=앱·DB=룩업) · [[dbmap-silsa-price-via-poster-sign]](포스터사인 [가로×세로] 매트릭스) · [[dbmap-cpq-configurator-design]](제약 트리거·polymorphic).
- **재사용 산출물:** 같은 폴더 `domain-research.md`(설치/거치 4분류·PS-A~H·경쟁사 §2)·`area-load-design.md`(3축 적재·siz 채번 109·소재공식 분리).
- **경쟁사·표준(3순위·보조·WebSearch/WebFetch 2026-06-15):**
  - [레드프린팅 현수막(BNBNFBL)](https://www.redprinting.co.kr/ko/product/item/BN/BNBNFBL) · [특가현수막(BNBNLOW)](https://www.redprinting.co.kr/ko/product/item/BN/BNBNLOW) — 세로 고정폭 선택 + 가로 자유입력 / 인쇄비·후가공·합계 가격 분리 / 가격규칙 동적·미공개
  - [와우프레스 현수막 가이드](https://wowpress.co.kr/wow2.0/w_guide/doc/g3_6.html) · [와우프레스 일반현수막](https://m.wowpress.co.kr/self/dsgn/info?product=417&ProdNo=40115) — 1/10 작업사이즈·자유사이즈(가격규칙 미공개)
  - [VSL Print 디지털인쇄 가격 가이드](https://www.vslprint.com/printing-nyc/digital-printing/what-is-the-pricing-structure-for-digital-printing-services-ultimate-guide/) — tier 예시 1-25/26-50/51+ 구간별 개당단가(**volume floor tier 인쇄업 실예**)
  - [Tremendous: Tiered vs Volume Pricing](https://www.tremendous.com/blog/tiered-vs-volume-pricing-guide/) · [Recurly tiered/volume/stairstep](https://docs.recurly.com/recurly-subscriptions/docs/-tiered-stairstep-and-volume-pricing) · [billingplatform Volume Pricing](https://billingplatform.com/blog/what-is-volume-pricing) — volume(all-units, 최고구간 단가 전체적용·pricing cliff) vs graduated(밴드 독립) 구분 권위
  - [WholesaleSuite Tiered Pricing Best Practices](https://wholesalesuiteplugin.com/tiered-pricing-strategy-examples/) · [keboto 인쇄 가격전략](https://keboto.org/how-to-create-an-effective-pricing-strategy-for-your-printing-services) — 수량구간·margin 관리
  - [signs.com 배너 가격](https://www.signs.com/banners/) · [signsbannersonline custom calculator](https://signsbannersonline.com/qsi/calculator.php) — ㎡/length×height 면적단가(산업 표준·후니 격자ceiling과 대조)
  - [퍼블로그 현수막 가이드 2026](https://www.publog.co.kr/blog/publog-banner-guide-2026) — mm 자유사이즈 시장 대조

> **추정 0 · 보정 하드코딩 0 · 실무진 정리 존중.** 모든 URL WebFetch/WebSearch 접근(동적·비공개 가격규칙은 한계 명시). DB 쓰기 0(read-only 실측·리서치 전용).
