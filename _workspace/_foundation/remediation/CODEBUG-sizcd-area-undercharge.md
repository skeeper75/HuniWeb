# 코드버그 명세 — siz_cd 모드 상품 × 면적매트릭스 공식 = 최소사이즈 과소청구

작성 2026-06-26 · 대상 = 개발팀(§6/가격엔진). 라이브 코드 `raw/webadmin/webadmin/catalog/pricing.py`·`price_views.py`·`templates/catalog/price_simulator.html` 실측 + 라이브 DB 실측 근거. **데이터 vs 코드 판정 포함**(사용자 directive).

---

## 1. 한 줄 요약
**등록 사이즈(siz_cd)로 사이즈를 고르는 상품**(`nonspec_yn='N'`)이 **면적매트릭스 가격구성요소**(`use_dims=[siz_width,siz_height,mat_cd]`)에 바인딩되면, 가격엔진이 선택 siz_cd를 가로/세로(mm)로 **환원하지 않아** 항상 **가장 작은 사이즈 구간(최저가)**으로 계산 → **silent 과소청구**.

## 2. 근본 메커니즘 (코드 라인 근거)

### 2.1 엔진: 사이즈 차원은 TIER(ceiling) 매칭 — 선택값 없으면 0 취급
`pricing.py`:
- `TIER_DIMS = ("siz_width","siz_height","min_qty")` (L49) — siz_width/height는 **정확매칭 아닌 '이하 상한' 구간**.
- `match_component()` L150-151:
  ```python
  ov = _tier_order_val(dim, selections, qty)      # 선택값에 siz_width 없으면 None
  cmp_val = ov if ov is not None else Decimal(0)   # ★ None → 0
  ```
- L153-159 (upper tier = siz_width/height):
  ```python
  eligible = [t for t in tiers if t >= cmp_val]   # cmp_val=0 → 모든 구간 적격
  selected[dim] = min(eligible)                    # ★ 최소 사이즈 구간 선택
  ```
- 결과: 선택값에 siz_width/height가 없으면 → 0 이상 전 구간 적격 → **최소 사이즈 행** 채택.

### 2.2 siz_cd → 치수 환원 함수 부재
- `pricing.py` 전체에 siz_cd를 siz_width/siz_height로 푸는 로직 **없음**(`evaluate_price`/`match_component`/헬퍼 전수 확인). 판형(plt_siz_cd)은 `fn_calc_pansu`로 판수 환산하나, **완제품 면적 환원은 없음**.
- `t_siz_sizes`에는 환원 가능한 실치수 컬럼 **존재**: `cut_width,cut_height,work_width,work_height`. 즉 데이터는 있는데 엔진이 안 씀.

### 2.3 호출부도 siz_cd만 전달
- `price_simulator.html` `runSim()` (~L360):
  ```js
  if(d.name==="siz_cd"){ if(!nonspec&&COMBOS.siz_cd){ ... sel.siz_cd=v; } continue; }
  ...
  if(nonspec){ ... sel.siz_width=...; sel.siz_height=...; }  // nonspec(자유치수)일 때만 주입
  ```
  → siz_cd 모드(nonspec=false)는 `sel.siz_cd`만 보내고 width/height **미주입**.
- `price_views.py` `/simulate/` 및 prod_dims 빌더에도 siz_cd→width/height 주입 **없음**.

## 3. 실측 영향 (라이브 데이터)
- `COMP_ACRYL_CLEAR3T`: 165 단가행 **전건 siz_width 채움·siz_cd=0** = 순수 면적키. 샘플: 20x20=2000~2500 … (사이즈↑ 가격↑).
- 영향 상품(가격만결손 51 중 6 GO·전부 nonspec_yn='N'): PRD_000157 아크릴네임택(60x60·55x86)·158 포카키링·159 코스터(100x100)·160 자유형스탠드·161 판아크릴(120x180·120x120)·162 포카스탠드(68x103).
  - 예: 157이 "60x60" 선택 → 엔진은 siz_width 미수신 → 20x20 행(2000원) 청구. **정답 60x60 행 대비 대폭 과소**.
- ★**기존 라이브 146 아크릴키링은 무관**: `nonspec_yn='Y'`(자유치수)라 width/height를 직접 보냄 → 정상. (이 comp의 유일 기존 바인딩이 146이라, **siz_cd 모드 바인딩은 6 GO가 최초 노출**.)

## 4. 데이터로 해결 가능한가? (사용자 핵심 질문)

| 방안 | 코드수정 | 가능성 | 평가 |
|---|---|---|---|
| **A. 기존 comp 단가편집** | 무 | ❌ 불가 | 과소청구는 "어느 행이 뽑히나"의 문제. 단가값을 고쳐도 여전히 최소사이즈 행이 뽑혀 그 행 값으로 청구. **편집으로 해결 안 됨.** |
| **B. siz_cd 키 전용 comp 신설(데이터)** | 무 | 🟡 가능하나 비권장 | 6 상품을 `use_dims=[siz_cd,mat_cd]` 정확매칭 comp에 바인딩 + 등록사이즈별 단가행(면적그리드에서 산출). 코드 불요·즉효. **단, 면적가 모델을 사이즈별로 denormalize·상품마다 반복·면적그리드와 이중관리.** 공유 면적 comp(146)와 분리돼 충돌은 없음. |
| **C. 엔진 siz_cd→치수 환원(코드)** | 유 | ✅ 권장 | `match_component`/`evaluate_price` 진입부에서 선택 siz_cd → `t_siz_sizes.cut_width/cut_height` 환원해 tier 비교에 주입. **단일 지점·전 siz_cd모드×면적 상품 영구 해소·면적그리드 단일 유지·권위 정합.** |

**판정:** 아크릴은 권위 가격표(`acrylic-l1.csv` 가로×세로 그리드)가 **면적가 모델**이므로, 정답 모델은 면적매트릭스다. 따라서 **근본 해법은 코드(C)** — siz_cd를 면적으로 환원. 순수 단가편집(A)으로는 **불가**. 데이터 우회(B)는 코드 없이 즉효지만 면적가를 사이즈별로 복제하는 denormalize라 유지보수 부담·이중관리.

## 5. 권고
1. **단기(코드 없이 안전):** siz_cd 모드 아크릴(157~162)을 area 공식에 **바인딩하지 말 것** — 바인딩 시 과소청구 확정. 빠른성과 대상에서 제외.
2. **정석(코드·§6):** 엔진 siz_cd→치수 환원(방안 C). 환원 소스 = `t_siz_sizes.cut_width/cut_height`(완제품 재단 실치수). 적용 후 6 상품 area 바인딩 안전.
3. **대안(데이터·즉시 매출 필요 시):** 방안 B로 siz_cd 키 comp 신설(권위 면적그리드에서 등록사이즈별 단가 verbatim 산출·인간 승인). 단 면적가 denormalize 트레이드오프 수용 시.

## 6. 재현 (개발자용)
1. `nonspec_yn='N'` 상품을 `use_dims`에 siz_width/height 있는 comp에 바인딩.
2. `evaluate_price(target, {"siz_cd":"<큰사이즈코드>"}, qty)` 호출(siz_width/height 미포함).
3. 결과 matched_row = 최소 siz_width/height 행(최저가) → 정답 대비 과소. `match_component` `selected[siz_width]=min(eligible)` 지점에서 확인.
