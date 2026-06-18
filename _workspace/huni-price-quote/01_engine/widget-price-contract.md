# widget-price-contract.md — 옵션선택 → 가격계산 정규화 계약

> 옵션 UI 선택값이 `evaluate_price`의 `selections` 딕셔너리(차원 키)로 어떻게 정규화되는지,
> qty·grade_cd·proc_sels·target을 위젯이 어떻게 채우는지 계약화한다.
> **위젯 코드 자체는 huni-widget 하네스 영역** — 여기서는 가격계약(인터페이스)만 명세.
> 권위 = 라이브 시뮬레이터 호출 경로(`price_views.py:price_simulate`/`price_sim_meta`)가
> 보여주는 정규화 패턴 = 엔진이 먹는 입력 형태. 위젯은 이 형태를 그대로 만들어내야 한다.
>
> 소스: `price_views.py`(이하 `pv.py`), `pricing.py`. 산출자: hpq-engine-cartographer.

---

## 1. 엔진 입력 인터페이스 (위젯이 채워야 할 것)

```
evaluate_price(target, selections, qty, grade_cd=None, mode="strict",
               only_comps=None, proc_sels=None)
```

| 필드 | 위젯이 채우는 법 | 정규화 규칙 |
|------|----------------|------------|
| `target` | `{"prd_cd": 상품코드}` 또는 `{"tmpl_cd": SKU코드}` | pv.py:1296 |
| `selections` | 차원키→값 dict | §2 (빈/None 제거) |
| `qty` | int ≥1 | pv.py:1273-1277 (위젯이 1 이상 보장) |
| `grade_cd` | 로그인 고객등급(비로그인=None) | pv.py:1279 / 비로그인=기준가 |
| `mode` | **`"strict"`** (실주문) — 시뮬은 lenient | engine-contract §7 |
| `proc_sels` | 다중공정 `[{proc_cd,detail}]` | §4 |

- **계약 W-0**: 위젯은 실주문에서 **strict** 모드를 써야 한다. 시뮬레이터(검증)만 lenient.
  strict는 매칭실패/데이터오류를 `ok=False` + errors로 차단해 잘못된 0원 견적을 막는다.

---

## 2. selections 정규화 — 차원 키 사전

엔진이 인식하는 차원 키 = `NON_QTY_DIMS` + `TIER_DIMS`(pricing.py:38-45). 위젯 옵션 선택값은
이 키로 정규화돼야 한다. 라벨/종류는 `DIM_META`(pv.py:29-41) 권위.

| selections 키 | 라벨 | 종류 | 매칭 방식 | 값 형태 |
|--------------|------|------|----------|---------|
| `siz_cd` | 사이즈 | FK(TSizSizes) | 정확 | 코드 문자열 |
| `plt_siz_cd` | 판형사이즈 | FK | 정확 | 코드(impos_yn='Y'만) |
| `print_opt_cd` | 인쇄옵션 | FK | 정확 | 코드 |
| `mat_cd` | 자재(두께 등) | FK | 정확 | 코드 |
| `proc_cd` | 공정 | FK | 정확(proc_sels로) | 코드 |
| `opt_cd` | 옵션코드 | text | 정확 | 코드 |
| `coat_side_cnt` | 코팅면수 | int | 정확 | 정수 |
| `bdl_qty` | 묶음수 | int | 정확 | 정수 |
| `siz_width` | 사이즈가로 | num(mm) | 티어 '이하' 상한 | 숫자 |
| `siz_height` | 사이즈세로 | num(mm) | 티어 '이하' 상한 | 숫자 |
| (`min_qty`) | 수량 | — | qty 인자로 전달(selections 아님) | — |
| dim_vals 키 | 공정상세(예 `개수`) | — | 정확(proc detail) | proc_sels.detail |

- **계약 W-1 (빈값 제거)**: `selections`는 `v not in (None, "")` 인 키만 포함 (pv.py:1270-1271).
  미선택 차원은 키 자체를 넣지 않는다 → 엔진이 그 차원 NULL행(와일드카드)과 매칭 또는 자연 제외.
- **계약 W-2 (코드값 그대로)**: FK 차원은 표시 라벨이 아니라 **코드값**을 보낸다(`_norm` 문자열
  비교, pricing.py:68-70). 위젯 드롭다운의 value=코드여야 함.
- **계약 W-3 (수량은 selections 아님)**: 수량은 `qty` 인자로 전달. `min_qty`는 엔진 내부 티어
  비교용이라 selections에 넣지 않는다(`_tier_order_val(min_qty)=qty`, pricing.py:107-108).
- **계약 W-4 (사이즈 mm)**: 비규격 면적상품은 `siz_width`/`siz_height`에 mm 숫자. 엔진이
  '이하' 상한 ceiling 매칭(engine-contract P3-4). 비규격 입력 검증(min/max/incr)은 위젯이
  `price_sim_meta.nonspec`(pv.py:1096-1098) 룰로 선검증.

---

## 3. 옵션 UI → 차원 정규화 (OPT_REF_DIM 매핑)

위젯의 "옵션그룹/옵션 항목" 선택은 가격 차원으로 변환돼야 한다. 라이브 변환 규칙
= `price_sim_meta._opt_maps`(pv.py:1169-1183), polymorphic `ref_dim_cd`(`t_prd_product_option_items`):

| ref_dim_cd | 정규화 결과 | 근거 |
|-----------|------------|------|
| `OPT_REF_DIM.01` | `selections["siz_cd"] = ref_key1` | pv.py:1176 |
| `OPT_REF_DIM.02` | `selections["plt_siz_cd"] = ref_key1` | :1177 |
| `OPT_REF_DIM.03` | `selections["mat_cd"] = ref_key1` | :1178 |
| `OPT_REF_DIM.05` | `selections["bdl_qty"] = int(ref_key1)` | :1180-1181 |
| `OPT_REF_DIM.04` | `proc_sels`에 `proc_cd=ref_key1` 추가 | :1182 |
| `OPT_REF_DIM.06`(도수)/`.07`(셋트) | **현 가격차원 직접매핑 없음 — 생략** | :1171 |

- **계약 W-5 (옵션→차원 변환)**: 위젯은 선택한 option_item의 ref_dim_cd를 보고 위 표대로
  selections/proc_sels를 채운다. 옵션 선택 단위는 옵션코드가 아니라 **참조 차원값**으로 풀림.
  (단, CONTEXT :21은 "옵션 매칭 단위=옵션코드만" 의도였으나 라이브 시뮬은 ref_dim으로 풀어
  차원 매칭함 — **불일치 주의**, §6 위험지점 R-2.)
- **계약 W-6 (중복차원 숨김)**: 옵션그룹이 커버하는 차원(자재·사이즈·판형·묶음)은 raw 차원
  드롭다운에서 숨긴다(pv.py:1203-1208). 위젯도 옵션그룹과 raw 차원의 이중노출을 피해야 함.
- **계약 W-7 (선택규칙)**: 옵션그룹의 단일/다중(`sel_typ_cd≠SEL_TYPE.01`=다중), min/max,
  필수(`mand_yn='Y'`)는 `price_sim_meta.opt_groups`(pv.py:1188-1202)로 제공. 위젯이 선검증.

---

## 4. 다중공정 (proc_sels) 계약

- **계약 W-8**: 공정은 `procs=[{proc_cd, detail:{키:값}}]` 형태로 보낸다(pv.py:1287-1294).
  엔진이 공정 구성요소를 공정마다 개별평가·합산(engine-contract P8-1).
- **계약 W-9 (공정 상세 = dim_vals)**: 공정 detail(예 가변텍스트 `{"개수":2}`)은 단가행
  `dim_vals`와 **정확매칭**(와일드카드 없음, engine-contract P3-3). 위젯은 `price_sim_meta`의
  `proc_cd` 옵션이 제공하는 `detail` 입력스펙(pv.py:1153)을 그대로 키로 보내야 함.

---

## 5. 추가상품(끼워팔기) 계약

- **계약 W-10**: `addons=[{tmpl_cd, qty}]`. 각 addon은 자체 템플릿(다른 상품 SKU) 단가로
  개별 evaluate_price → grand_total 합산(pv.py:1300-1327). 본품과 별개 미니주문(항목별
  수량할인 반영, 등급은 동일 고객 전달).

---

## 6. 뼈대의 위험지점 (검증·구현 시 주의)

| ID | 위험 | 근거 / 함의 |
|----|------|------------|
| **R-1** | **침묵 0원** — lenient에서 매칭 0건/소스 부재가 0원으로 반환(ok=True). 위젯이 lenient면 손님에게 0원 견적 노출 | engine-contract P7-1·P2-3. **위젯=strict 필수(W-0)** + 메모리 [[huni-widget-red-price-never-zero]](PRICE=0은 항상 결함신호) |
| **R-2** | **옵션 매칭 단위 불일치** — CONTEXT는 "옵션코드만 매칭" 의도였으나 라이브 시뮬은 ref_dim으로 차원 풀이. 위젯이 어느 쪽을 따르냐에 따라 매칭 결과 다름 | pv.py:1169-1183 vs CONTEXT:21. 검증 필요(option_constraint-mapper 협업) |
| **R-3** | **합가형 min_qty 결손** — 합가형 구성요소 단가행에 min_qty NULL 유입 시 ValueError로 견적 전체 붕괴. strict면 ok=False, lenient면 0원 | engine-contract P4-3·C3. 아크릴 파일럿 현재 min_qty=1 전행(안전) |
| **R-4** | **판별차원 없음 항상매칭** — use_dims 비수량차원 단가행 전부 NULL → 옵션 무관 무조건 합산(과청구) | engine-contract C2·P3-DEF. note 경고로 발현 |
| **R-5** | **사이즈 상한초과 무음** — ERR_ABOVE_MAX는 strict여도 비치명(그 comp만 0원 제외). 본체 면적comp가 빠지면 견적 과소 | engine-contract P3-5·P7-3. 위젯이 면적 본체 0원을 별도 검지해야 |
| **R-6** | **코드값 vs 라벨** — 위젯 드롭다운 value가 라벨이면 매칭 전부 실패 → 0원 | 계약 W-2 |
| **R-7** | **DB 미정/어댑터** — 위젯은 후니 DB가 아닌 정규화 계약 의존(메모리 [[huni-widget-conversion-strategy]]). 이 selections 키 사전이 어댑터 계약 경계 | — |

---

## 7. 위젯 가격계약 한 줄 요약

> 위젯은 옵션 UI 선택을 **(코드값 기반) selections 차원 dict + qty + grade_cd + proc_sels + addons**로
> 정규화해, `target`(prd_cd 또는 tmpl_cd)과 함께 **strict 모드**로 `evaluate_price`에 넘기고,
> `ok=True`일 때만 `final_price`를 표시한다. 0원/ok=False는 결함신호로 차단한다.
