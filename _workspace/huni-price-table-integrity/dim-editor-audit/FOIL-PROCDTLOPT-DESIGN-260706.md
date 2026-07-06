# 박(foil) 공정상세옵션 가로×세로 정식화 + use_dims proc_grp 일관화 — 교정 설계 명세 (260706)

> ★★★★ 지니 도메인 교정(260706·최우선·relitigate 금지): **`사이즈가로(구간)×사이즈세로(구간)` 차원 =
> 소재(자재) 전용**(아크릴·실사 등 소재가 면적으로 가격됨). **가공(박) 영역에 이 차원 사용 금지.**
> - ∴ 박 가공비 구성요소(COMP_FOIL_PROC_LARGE/SMALL_STD/SPECIAL)가 use_dims에 `siz_width/siz_height`를 쓰는 것
>   **자체가 모델링 결함** — 제품 소재치수와 충돌 → "가격이 이뤄질 수 없다"(제외/무청구). 이것이 결함4의 진짜 본질.
> - **∴ key=siz_width 데이터-only 교정은 폐기**(소재 차원을 가공에 강제 = 규칙 위반). 아래 §의 siz_width 접근 전부 무효.
> - **올바른 방향**: 박 면적(가로×세로 등급)은 **가공 전용 차원 기제**로 재모델해야 함(소재 siz_width/height 재사용 금지).
>   구체 모델은 지니/가격엔진 설계 결정 사안(예: 박 전용 area 차원·opt_cd 등급·prcs_dtl_opt 전용 price_dim 신설). **추측 금지·확인 후.**
> - 라이브 현재 = 원상(단일 "크기")·무변경. 이 재모델은 데이터 tweak 아닌 **설계/엔진 트랙**(HANDOFF "박 C-track" 옳음).

> (구 분석·소재차원 오용으로 무효화됨) ★★★ 최종 정밀 진단(260706·실 price-simulator UI 실측·앞선 "엔진 미소비" 판단 정정):
> **결함4(박 저청구) 실재 확정 + 데이터-only 교정 실재하나 라벨 위해 프론트 1줄 필요.**
> - **근본원인 확정**: 박 comp는 siz_width/siz_height로 박 면적 매칭. 그런데 `pricing.py:_reduce_siz_dims`(312행)가
>   **제품 재단치수를 siz_width/height에 먼저 주입**(2단접지카드 SIZ_000523 cut=**200×150**). 박 격자 최대 170 초과 →
>   실 UI에서 **박 comp "최대 사이즈 초과 — 합산 제외"**(박 무청구). 박 크기 입력은 `_derive_price_dims` **setdefault**(663행)라 못 덮음.
> - **★데이터-only 교정 작동 확인**(실험 COMMIT→검증→복구): prcs_dtl_opt key를 **`siz_width`/`siz_height`로** 하면
>   is_proc 경로(704-710행)가 detail을 **직접 대입(override)** → 제품치수 덮음 → 박 면적대로 정상 청구
>   (실측 API: 박 30×30→91,000·100×100→177,000·170×170→264,000·면적반응 ✅). **엔진 코드 변경 불요.**
> - **라벨 제약**: 시뮬레이터 프론트(price_simulator.html:521)가 `it.key`를 라벨로 표시(label 필드 무시)+payload도 it.key.
>   → key=siz_width면 작동하나 라벨 "siz_width"(기술적). 예쁜 "가로/세로"는 **프론트 1줄 `it.label||it.key`**(시뮬레이터+위젯) 배포 필요.
> - **정정**: 앞선 "배포 엔진이 price_dim 미소비" 판단은 **부정확**. 진짜는 **차원충돌(siz_width 공유)+setdefault 우선순위**.
>   agent의 "key=가로+price_dim" JSON은 setdefault라 실패(정확). 작동 JSON은 **key=siz_width(직접대입)**.
> - **현재 라이브 = 원상(단일 "크기")**. 인간 승인 대기. 아래 §4 적재본은 key=가로+price_dim이라 **작동 안 함 → key=siz_width로 교체 필요**.

> (구 노트·정정됨) 라이브 검증 결과 COMMIT→검증실패→롤백: 데이터만으로 안 고쳐짐(부정확·위 ★★★ 참조).
> - **확정**: 박 저청구 실재(027 박=0·042 박=면적 무반응·103,000 고정). 엔진은 selections.siz_width 직접 주입 시엔
>   정상 매칭(027 30×30→76,000·100×100→147,000) → 매칭 로직은 OK.
> - **검증 실패**: prcs_dtl_opt price_dim COMMIT 후에도 proc detail{가로,세로}→simulate 시 박 여전히 0.
>   sim-meta(price_views.proc_detail_inputs)는 내 변경을 프레시로 반영(가로/세로 price_dim 노출)하나,
>   **배포된 evaluate_price/`_derive_price_dims`가 proc detail을 price_dim으로 주입하지 않음**(코팅 count_y도 동일 무반응).
>   즉 raw/webadmin/pricing.py 소스는 price_dim을 지원하나 **라이브 배포 엔진은 구버전**(표시 코드만 최신).
> - **롤백 사유**: ① SOT=webadmin 확인된 경우만 COMMIT인데 확인 실패 ② 위젯 UI가 가로/세로 2필드를 보이나
>   가격 무반영=오해소지(현행보다 나쁨). undo(`foil-procdtlopt-260706-undo.sql`) 실행·원상 복구 확인(prcs_dtl_opt 단일"크기"·SMALL_STD만 grp).
> - **정정**: 이 명세 §5-2 "메타 교정=마지막 미비 링크(살아난다)"는 **낙관적 오판**. 라이브 실측 결과 링크6(위젯)뿐
>   아니라 **엔진의 price_dim 소비 자체가 미배포** → HANDOFF 원래 경고 "박 엔진 미지원·C-track 개발 대기"가 옳음.
> - **정확한 다음 조치**: 이 설계(prcs_dtl_opt price_dim + use_dims proc_grp)는 **개발 수정요청서로 전환**(pricing.py
>   `_derive_price_dims` 배포 + 위젯 박영역 가로/세로 전송). 엔진 배포 후 이 적재본 재적용+재검증. 데이터 적재는 그때.

> §26 가격테이블 무결성 하네스. **결함B(박 가로×세로 공정상세옵션 JSON 미비)·박3시트 UNMAPPED 해소의 메타 축**.
> 산출자: 라이브 읽기전용 SELECT 실측 2026-07-06 · 단가값=권위 가격표 verbatim(날조 0) · **DB 미적재**(실 COMMIT/DDL 인간 승인 후 별도 트랙).
> 권위[HARD]: ① 인쇄상품 가격표 260705 박(소형)/박(대형)/박(백업) 시트 > ② 라이브 t_prc_*·t_proc_processes(기준선·읽기전용) > ③ pricing.py engine-contract.
> 선행 재사용(search-before-mint): §18 `engine-design-foil.md`(REV4·flatten)·`AUDIT-mat-procdtl-260705.md` §3/§6-B1·`LAYER4-SHEET-CYCLE-MATRIX-260706.md`.
> 생성≠검증: 이 명세는 게이트 대기(E1~E7 / hpti I1~I7 독립 재실측).

---

## 0. 결론 (TL;DR)

| 항목 | 판정 | 근거 |
|---|---|---|
| **prcs_dtl_opt 정식화 = dim-editor 화장인가, 런타임 임계경로인가** | ★**런타임 임계경로** (돈 영향 有·미비 시 박 저청구) | `pricing.py:370 _derive_price_dims` — `price_dim` 선언만이 박 가로/세로를 siz_width/siz_height 선택값으로 주입. 현 단일 "크기"(price_dim 없음)=주입 0 → 박 flatten 단가행이 항상 최소면적셀(등급A 최저가) 매칭 → 체계적 저청구 |
| **use_dims proc_grp 일관화 = 돈 영향** | ⚪ **돈 영향 0** (순수 dim-editor 그룹 메타) | `proc_grp`가 `NON_QTY_DIMS`·`TIER_DIMS` 어디에도 없음(`pricing.py:42-50`)·`L685`가 `":"` 포함 항목을 non_qty에서 명시 제외 → 엔진이 절대 읽지 않음. 편집 그리드 그룹핑 일관화만 |
| **박3시트 UNMAPPED = 데이터 부재인가 파서 미비인가** | ★**grid_diff 파서 미비** (데이터는 flatten으로 이미 적재됨) | 라이브 COMP_FOIL_* 단가행이 면적→등급→단가를 flatten(siz_width/siz_height/min_qty→등급단가 verbatim·grade=note)으로 이미 담음. 골든 셀 verbatim 일치 확인(§3) |
| **SETUP_LARGE/SMALL min_qty 누락** | ✅ **정답(유지)** | 동판비=1회성 제작비(수량 차원 없음). 권위 소형 동판비=단일 5,000·대형=면적매트릭스 only(수량축 부재). min_qty 부여는 오히려 오설계 |
| **이 메타 교정만으로 견적이 살아나나** | ★**부분적 YES — 이것이 마지막 미비 링크** | §18 설계 전 계층(6 comp+flatten 단가행+`_FOIL` 변형공식 배선+7상품 바인딩)은 **이미 라이브 적재 완료**(§5 실측). prcs_dtl_opt price_dim이 **유일하게 남은 미비 링크**. 이것을 채우면 박 견적이 정상 산출(단 위젯이 박 가로/세로를 proc detail로 전송한다는 전제·게이트 시 simulate 확인) |

**∴ 이 명세 = ① PROC_000033 박·PROC_000050 형압 prcs_dtl_opt를 단일"크기"→가로×세로 2입력+price_dim(siz_width/siz_height) 정식화(돈크리티컬·박 저청구 해소) ② 6 COMP_FOIL_* use_dims에 proc_grp:PROC_000033 일관 부여(편집 그룹핑·돈영향0) ③ 단가행·가격값 절대 무변경(돈영향 0의 메타 교정).**

---

## 1. prcs_dtl_opt 정식화 JSON (돈크리티컬·런타임 임계경로)

### 1-1. 현재 상태 (라이브 실측 2026-07-06)

| proc_cd | proc_nm | 현재 prcs_dtl_opt |
|---|---|---|
| PROC_000033 | 박 | `{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}` ← 단일 크기·price_dim 없음 |
| PROC_000050 | 형압 | `{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}` ← 동일 결함 |
| **PROC_000013** | 라미네이팅 코팅 | `{"inputs":[{"key":"앞면코팅","type":"boolean","contrib":"count_y","price_dim":"coat_side_cnt"},{"key":"뒷면코팅","type":"boolean","contrib":"count_y","price_dim":"coat_side_cnt"}]}` ← ★정답 패턴(price_dim 바인딩) |

### 1-2. 목표 JSON (코팅 price_dim 패턴 준수)

**PROC_000033 박** (그리고 동형 **PROC_000050 형압**):
```json
{"inputs":[
  {"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},
  {"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}
]}
```

- `price_dim`만 선언(코팅의 `contrib:count_y`와 달리 **contrib 생략=passthrough**). `_derive_price_dims`(`pricing.py:394`)가 passthrough면 `out[pdim]=val`(값 그대로) → `selections["siz_width"]=박가로`, `selections["siz_height"]=박세로` 주입.
- 이 주입값이 COMP_FOIL_PROC_* flatten 단가행의 siz_width/siz_height 티어('이하' ceiling)와 매칭 → 정확 등급셀 착지.

### 1-3. 왜 런타임 임계경로인가 (pricing.py 계약 추적)

```
위젯 박영역 입력(가로/세로)  →  proc_sels=[{proc_cd:PROC_0000xx(박색상), detail:{"가로":W,"세로":H}}]
  →  _evaluate_formula:662  _derive_price_dims(proc_sels)
       └ _proc_inputs(proc_cd) → prcs_dtl_opt.inputs (자식 박색상은 부모 PROC_000033 상속·L344-360)
       └ price_dim 선언 있는 입력만 주입:  siz_width=W, siz_height=H  (setdefault·명시 선택값 우선)
  →  COMP_FOIL_PROC_{시트}_{일반|특수} rows 매칭: proc_cd(박색상 게이트)+siz_width/siz_height(면적 ceiling)+min_qty(수량 band)
  →  등급단가 verbatim 반환 (.03 FLAT·수량 무관 작업1건)
```

- **현재(단일 "크기", price_dim 없음)**: `pdim=None → continue`(L383) → **아무것도 주입 안 됨**. siz_width/siz_height=미설정 → tier order value=None → cmp_val=Decimal(0)(L163) → upper('이하') eligible = 전 티어 → **최소 티어(소형 10×10·대형 30×30) 선택 = 등급 A 최저가**. 박 실면적이 얼마든 항상 최저 등급 → **체계적 저청구**(언더차지).
- **교정 후**: 박 실면적 주입 → 정확 등급셀 → 정확 단가.
- ★단일 "크기"(1D)는 구조적으로 2D 면적매트릭스(siz_width×siz_height)를 지정 불가 — flatten 모델과 근본 비호환. 2입력 분리가 필수.

### 1-4. 형압(PROC_000050) 주의 [CONFIRM Q-FOIL-EMB1]

- 형압은 **현재 가격 comp가 0건**(라이브 실측: 형압/양각PROC_000051/음각PROC_000052 참조 단가행 0). price_dim 바인딩은 **소비하는 comp가 없어 inert**(향후 형압 면적 comp 신설 시 활성화되는 forward 그릇).
- ★**부작용 경계**: price_dim은 공유 `selections`에 주입(setdefault). 만약 한 상품이 **박+형압 동시 선택**하고 두 영역이 다르면, `_derive_price_dims`가 siz_width/siz_height를 한쪽(먼저·passthrough는 last-wins·L394) 값으로 채워 다른 쪽 comp에 오주입 가능. 현재 박·형압 동시 상품 0·형압 comp 0이라 실무 무발생이나, **형압 comp 신설 시 박·형압 면적 차원 분리(별 price_dim 또는 dim_vals) 재설계 필요**.
- 권고: PROC_000050도 **구조 정식화(가로×세로 2입력)는 지금**(dim-editor·grid 준비), **price_dim 바인딩은 형압 면적 comp 신설과 동시**에. 단 directive #1이 동형 요구·형압 comp 0이라 지금 바인딩해도 무해 → **지금 바인딩하되 위 부작용을 게이트 노트로 표면화**. 실무 컨펌 Q-FOIL-EMB1.

---

## 2. use_dims proc_grp 일관화 (돈영향 0·편집 그룹핑)

### 2-1. 현재 불일치 (라이브 실측)

| comp_cd | 현재 use_dims | proc_grp | 단가행 |
|---|---|---|---|
| COMP_FOIL_PROC_LARGE_STD | `["proc_cd","siz_width","siz_height","min_qty"]` | ✗ | 3328 |
| COMP_FOIL_PROC_LARGE_SPECIAL | `["proc_cd","siz_width","siz_height","min_qty"]` | ✗ | 3328 |
| **COMP_FOIL_PROC_SMALL_STD** | `["proc_cd","siz_width","siz_height","min_qty","proc_grp:PROC_000033"]` | ✅ | 1620 |
| COMP_FOIL_PROC_SMALL_SPECIAL | `["proc_cd","siz_width","siz_height","min_qty"]` | ✗ | 540 |
| COMP_FOIL_SETUP_LARGE | `["proc_cd","siz_width","siz_height"]` | ✗ | 512 |
| COMP_FOIL_SETUP_SMALL | `["proc_cd"]` | ✗ | 8 |

★SMALL_STD 1개만 proc_grp 보유 = 6개 중 유일 이상치. 일관화 = 나머지 5개에 부여(SMALL_STD 기준으로 정렬).

### 2-2. 판정: proc_grp = 순수 편집 그룹 메타 (엔진 무참조·돈영향 0) [HARD 확정]

`pricing.py` 정밀 추적:
- `NON_QTY_DIMS=("siz_cd","plt_siz_cd","print_opt_cd","mat_cd","proc_cd","opt_cd","coat_side_cnt","bdl_qty")` — **proc_grp 없음**.
- `TIER_DIMS=("siz_width","siz_height","min_qty")` — **proc_grp 없음**.
- `_row_matches`(L94-106)는 NON_QTY_DIMS + dim_vals만 순회 → proc_grp 무시.
- `L685 non_qty=[d for d in use_dims if not (":" in d)]` — `proc_grp:PROC_000033`을 **명시 제외**. `is_proc="proc_cd" in non_qty`(L686)도 proc_cd로만 판정 → proc_grp 추가/제거가 is_proc·매칭·판수·합산 **어디에도 무영향**.
- ∴ 박 선택 게이트력 = **proc_cd**(단가행에 박색상 PROC_0000xx 충전됨·실측 확인). proc_grp:PROC_000033 = dim-editor가 proc_cd 컬럼에 어느 그룹(박=PROC_000033) 자식공정을 드롭다운으로 채울지 알려주는 **편집 UI 그룹 태그**.

★§18 engine-design-foil은 proc_grp를 설계에 넣지 않았다(런타임 정합만 모델링·"게이트=proc_cd" 강조·R-FOIL-CDX3). 이 메타축은 그와 **모순 없음** — 런타임 정답은 불변, dim-editor 그룹핑 일관화(편집 그리드에서 6 comp 전부 박 그룹으로 통일 표시)만 추가. 돈영향 0이라 저위험.

### 2-3. 목표 use_dims (5개 변경·SMALL_STD 불변)

| comp_cd | 목표 use_dims |
|---|---|
| COMP_FOIL_PROC_LARGE_STD | `["proc_cd","siz_width","siz_height","min_qty","proc_grp:PROC_000033"]` |
| COMP_FOIL_PROC_LARGE_SPECIAL | `["proc_cd","siz_width","siz_height","min_qty","proc_grp:PROC_000033"]` |
| COMP_FOIL_PROC_SMALL_STD | (불변·이미 보유) |
| COMP_FOIL_PROC_SMALL_SPECIAL | `["proc_cd","siz_width","siz_height","min_qty","proc_grp:PROC_000033"]` |
| COMP_FOIL_SETUP_LARGE | `["proc_cd","siz_width","siz_height","proc_grp:PROC_000033"]` |
| COMP_FOIL_SETUP_SMALL | `["proc_cd","proc_grp:PROC_000033"]` |

- 형압 proc_grp:PROC_000050은 **형압 comp가 0건이라 대상 없음**(현재 6 COMP_FOIL_*는 전부 박 자식공정 PROC_000034~049 참조). 향후 형압 comp 신설 시 그 comp에 proc_grp:PROC_000050 부여.

---

## 3. 면적→등급 A~E 권위 대조 — UNMAPPED = 데이터 부재 아님, 파서 미비 [핵심 판정]

### 3-1. 권위 격자 verbatim (인쇄상품 가격표 260705)

**소형 면적→등급 (B02·A9:F12)** — 일반박/특수박 동일 격자:
| 가로\세로 | 10 | 20 | 40 | 60 | 80 |
|---|---|---|---|---|---|
| 10 | A | A | A | B | C |
| 20 | A | A | B | C | D |
| 40 | A | B | D | E | E |

**대형 면적→등급 (B03·A15:I23)** — 일반박/특수박 동일 격자:
| 가로\세로 | 30 | 50 | 70 | 90 | 110 | 130 | 150 | 170 |
|---|---|---|---|---|---|---|---|---|
| 30 | A | A | A | A | A | A | A | B |
| 50 | A | A | A | A | B | B | B | B |
| 70 | A | A | B | B | B | B | B | D |
| 90 | A | A | B | C | C | D | D | D |
| 110 | A | B | B | C | D | D | D | D |
| 130 | A | B | B | D | D | D | D | E |
| 150 | A | B | B | D | D | D | E | E |
| 170 | B | B | D | D | D | E | E | E |

**등급→단가 골든 셀 (verbatim)**:
- 소형 일반박 등급A·10×10·수량200 = **12,200** (small B03 I10) · 등급E·수량1000 = **64,000** (M18) · 특수박 등급E·1000 = **92,000** (B05 M41)
- 대형 일반박 등급A·수량1000 = **75,000** (large B03 L15) · 등급E·수량1000 = **200,000** (P15)
- 대형 동판비 30×30 = **11,000** · 30×170 = **12,000** · 170×170 = **64,000** (large B01) · 소형 동판비 = **5,000** 고정 (small B01 B3)

### 3-2. 라이브 flatten 단가행이 격자를 이미 담고 있다 (실측)

라이브 COMP_FOIL_PROC_SMALL_STD 단가행 실측(2026-07-06):
```
proc_cd=PROC_000038(금유광)  siz_width=10.00  siz_height=10.00  min_qty=200  unit_price=12200.00
  note="소형 박가공비 등급A·가로10이하×세로10이하·수량200이상 (flatten·grade=추적)"
... (min_qty 300→14300, 400→16400, 500→18500, 600→20600, 700→22700, 800→24800, 900→26900 …)
```
- unit_price=12,200 = 권위 small B03 I10(등급A·qty200) **verbatim 일치**. grade는 note에 추적(매칭 비사용).
- use_dims=`[proc_cd,siz_width,siz_height,min_qty]` — 면적→등급 2단이 **1단 면적매트릭스로 flatten**(§18 REV4·C-1). 엔진 off-grid ceiling(`pricing.py:160-178`)이 siz_width/siz_height '이하' 착지 + min_qty band = **코드변경 0**으로 처리.
- 행수: SMALL_STD 1620 = 270행(면적15×수량18) × 색상6. LARGE_STD/SPECIAL 3328 = 832행(면적64×수량13) × 색상4. (색상 커버리지는 §5 인접발견 참조.)

### 3-3. 판정: LAYER4 "박3시트 UNMAPPED"의 성격

| 시트 | LAYER4 상태 | 실제 원인 | 성격 |
|---|---|---|---|
| 후가공_박소형(#11) | UNMAPPED | flatten 단가행 실재(격자 verbatim)·grid_diff가 2블록(면적정의+등급단가) 구조를 flatten과 대조하는 파서 미보유 | ★**파서 미비**(데이터 부재 아님) |
| 후가공_박대형(#14) | UNMAPPED | 동상·대형 flatten 실재 | ★**파서 미비** |
| 후가공_박백업(#18) | UNMAPPED | L1 CSV 부재(추출 안 됨)·라이브 comp는 소형/대형 flatten에 흡수 | 추출 갭(백업시트=소형/대형 원천 사본) |

→ **박소형/대형 UNMAPPED = grid_diff 파서가 면적→등급→단가 2블록을 flatten 단가행으로부터 재구성·대조하지 못하는 도구 드리프트**(LAYER4 §5 "미적재로 보여도 도구 드리프트일 수 있음" 교훈 적중). 데이터는 verbatim 적재됨. 박백업은 별도 CSV 추출 필요(소형/대형과 값 동일 여부 확인).

---

## 4. 제안 적재본 (메타 전용·COMMIT 금지·돈영향 0·저위험)

> ★**단가행·가격값 절대 무변경.** 이 적재는 t_proc_processes.prcs_dtl_opt(2행)·t_prc_price_components.use_dims(5행)만 수정. 돈 흐름 0(prcs_dtl_opt price_dim은 견적을 **정상화**하는 방향·저청구 해소이나 단가값 자체는 무터치). undo 포함·멱등.

### 4-1. prcs_dtl_opt 정식화 (박·형압)
```sql
-- FOIL-PROCDTLOPT-260706-load.sql  (인간 승인 후 COMMIT 주석 해제)
BEGIN;
-- PROC_000033 박: 단일 "크기" → 가로×세로 2입력 + price_dim(siz_width/siz_height)
UPDATE t_proc_processes
SET prcs_dtl_opt = '{"inputs":[{"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},{"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}]}'::jsonb
WHERE proc_cd = 'PROC_000033'
  AND prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb;   -- 멱등 가드
-- PROC_000050 형압: 동형(형압 comp 0건·forward 그릇·§1-4 부작용 노트)
UPDATE t_proc_processes
SET prcs_dtl_opt = '{"inputs":[{"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},{"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}]}'::jsonb
WHERE proc_cd = 'PROC_000050'
  AND prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb;
-- ROLLBACK;  -- DRY-RUN 시. 승인 후 COMMIT.
COMMIT;
```

### 4-2. use_dims proc_grp 일관화 (5행·SMALL_STD 제외)
```sql
-- 멱등 가드: proc_grp 미보유 행만 추가. jsonb 배열에 요소 append.
UPDATE t_prc_price_components
SET use_dims = use_dims || '["proc_grp:PROC_000033"]'::jsonb
WHERE comp_cd IN ('COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL',
                  'COMP_FOIL_PROC_SMALL_SPECIAL','COMP_FOIL_SETUP_LARGE','COMP_FOIL_SETUP_SMALL')
  AND NOT (use_dims @> '["proc_grp:PROC_000033"]'::jsonb);   -- 멱등: 이미 있으면 0행
```

### 4-3. undo
```sql
-- FOIL-PROCDTLOPT-260706-undo.sql
BEGIN;
UPDATE t_proc_processes SET prcs_dtl_opt = '{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}'::jsonb
WHERE proc_cd IN ('PROC_000033','PROC_000050');
UPDATE t_prc_price_components SET use_dims = use_dims - 'proc_grp:PROC_000033'
WHERE comp_cd IN ('COMP_FOIL_PROC_LARGE_STD','COMP_FOIL_PROC_LARGE_SPECIAL',
                  'COMP_FOIL_PROC_SMALL_SPECIAL','COMP_FOIL_SETUP_LARGE','COMP_FOIL_SETUP_SMALL');
-- (SMALL_STD는 원래 proc_grp 보유였으므로 undo 대상 제외·불변)
COMMIT;
```

- 멱등성: prcs_dtl_opt=old 값 가드(재실행 0행)·use_dims `@>` 가드(이미 있으면 0행).
- 비파괴: UPDATE만(DELETE/DDL 없음)·단가행·가격값 무터치.
- ★COMMIT 전 게이트: DRY-RUN(ROLLBACK) BEFORE/AFTER 실증 + webadmin 가격시뮬레이터에서 7상품 박 견적 재계산(저청구 해소 확인).

---

## 5. BLOCKED / C-track 판정 — 이 메타 교정으로 견적이 살아나나

### 5-1. 박 견적 체인 전 계층 라이브 실측 (2026-07-06)

| # | 링크 | 라이브 상태 | 판정 |
|---|---|---|---|
| 1 | 박 comp 6종(SETUP 2 + PROC 4) | ✅ 적재됨(COMP_FOIL_*·3328/3328/1620/540/512/8행) | GO |
| 2 | flatten 단가행(면적→등급→단가 verbatim) | ✅ 적재됨(§3·골든 verbatim 일치) | GO |
| 3 | `_FOIL` 변형공식에 박 comp 배선 | ✅ 배선됨 — PRF_NAMECARD_FIXED/PEARL/PREMIUM_FOIL·PRF_DGP_A/E_FOIL·PRF_BIND_MUSEON/PUR_FOIL | GO |
| 4 | 7상품 ↔ `_FOIL` 공식 바인딩 | ✅ 바인딩됨 — PRD_000027/029→PRF_DGP_E_FOIL·042→PRF_DGP_A_FOIL·069→MUSEON·070→PUR·031→PREMIUM·034→PEARL(t_prd_product_price_formulas) | GO |
| **5** | **prcs_dtl_opt price_dim(박 가로/세로→siz_width/siz_height)** | ❌ **단일 "크기"·price_dim 없음** | ★**이 메타축이 유일한 미비 링크** |
| 6 | 위젯이 박 가로/세로를 proc detail로 전송 | ❓ 미확인(위젯 트랙) | 게이트 확인 |

★**중대 재프레이밍**: LAYER4·AUDIT는 "7상품 박 0원(comp 부재)"를 결함으로 봤으나, 라이브는 §18 설계 전체가 **이미 적재 완료**(6 comp+flatten+`_FOIL` 공식+7상품 바인딩). 남은 것은 **prcs_dtl_opt price_dim 하나**. 즉 이 메타 교정이 **박 견적의 마지막 미비 링크**다.

### 5-2. 판정: 이 메타 교정 = 살아나게 하는 핵심 (단 조건부)

- **살아난다** — §5-1 링크 1~4가 이미 GO이므로, prcs_dtl_opt price_dim(링크5)을 채우면 박 가로/세로가 flatten 단가행에 도달 → 정확 등급 → 정확 단가. **엔진 코드 변경 불요**(off-grid ceiling·FLAT 이미 지원·§18 REV4 검증가 GO). HANDOFF "박 엔진 미지원·가산0" 경고는 **flatten 모델로 이미 해소됨**(면적→등급 환산을 엔진이 할 필요 없음·단가에 펼침).
- **조건(게이트 확인 필요·개발/위젯 트랙 분리)**:
  1. **위젯이 박영역 가로/세로를 proc detail(`{"가로":W,"세로":H}`)로 전송**해야 `_derive_price_dims`가 주입. 위젯이 단일 "크기"만 보내거나 top-level siz_width/siz_height로 보내면 경로 불일치 → 위젯 트랙 정합 필요(§18 §6 박영역 UX·상한=트림).
  2. **CPQ option_items가 상품별 박색상 proc_cd를 노출**(§18 §5-3)해야 손님이 박색상 선택 → proc_sels에 proc_cd 실림. 미노출이면 박 선택 자체 불가 → 별도 확인.
- **저청구 현행 경고(코드 유도·simulate 확인 대기)**: 링크5 미비 상태에서 박 선택 주문이 실행되면 siz_width/siz_height 미주입 → 최소 면적셀(등급A 최저가) 매칭 → **박 실면적 무관 최저 등급 청구=저청구**. 이 메타 교정이 저청구를 해소. ★이는 pricing.py 계약 유도 가설 — 게이트 시 webadmin 시뮬레이터로 박 견적 실측 확인 후 COMMIT.

### 5-3. 인접 발견 (내 메타축 범위 밖·라우팅 표기)

- ★**박색상 커버리지 갭 (dbm-price-arbiter 심의)**: 라이브 COMP_FOIL_PROC_* 단가행이 권위 시트 선언 색상보다 **적게** 적재됨.
  - LARGE_STD proc_cd=038/039/041/043(4색) ↔ 권위 대형 일반박 6색(금유광038·금무광048·은유광039·은무광049·동박041·청박043) → **금무광048·은무광049 미적재**.
  - LARGE_SPECIAL=037/040/042/044(4색) ↔ 권위 대형 특수박 6색(먹유광040·백박046·홀로그램037·트윙클044·적박042·녹박047) → **백박046·녹박047 미적재**.
  - SMALL_STD=038/039/040/041/042/043(6색) ↔ 권위 소형 일반박 7색(+펄박045) → **펄박045 미적재**.
  - SMALL_SPECIAL=037/044(2색) ↔ 권위 소형 특수박 3색(백박046·홀로그램037·트윙클044) → **백박046 미적재**.
  - → 미적재 박색상 선택 시 proc_cd no_match → 박가공비 0(저청구). **단가행 추가 적재 사안**(내 메타축 아님·dbmap 위임·권위 verbatim). 이 명세는 prcs_dtl_opt·use_dims 메타만.
- **박백업 시트 L1 추출**(§3-3): 소형/대형 flatten 원천이나 별 CSV 미추출. 값 동일 검증 위해 추출 필요(hpti-matrix-batch-build).
- **위젯 박영역 전송·CPQ 박색상 노출**(§5-2 조건): huni-widget / CPQ 트랙 확인.

---

## 6. 컨펌 큐 / 게이트

| ID | 질문 | 권고 |
|---|---|---|
| Q-FOIL-EMB1 | 형압(PROC_000050) price_dim 지금 바인딩 vs 형압 comp 신설 시 | 지금 구조 정식화(가로×세로)+바인딩(형압 comp 0이라 무해)·§1-4 부작용(박+형압 공유 siz 충돌)을 게이트 노트로. 형압 comp 신설 시 면적차원 분리 재설계 |
| Q-FOIL-WIDGET1 | 위젯이 박영역을 proc detail로 전송하는가 | webadmin 시뮬레이터/위젯 실측 후 COMMIT(§5-2 조건1) |
| Q-FOIL-COLOR1 | 미적재 박색상(048/049/045/046/047) 적재 | dbm-price-arbiter 심의→dbmap 적재(권위 verbatim·내 메타축 아님) |

### 게이트/원칙
- 라이브 읽기전용. 실 COMMIT/DDL = 인간 승인 + webadmin 가격시뮬레이터 실화면(7상품 박 견적 저청구 해소·판형/색상 자동선택) 확인 후 dbmap 트랙.
- 권위 = 인쇄상품 가격표 260705 박 3시트·상품마스터 260703. 단가값 verbatim(날조 0)·**단가행·가격값 절대 무변경**(이 명세는 prcs_dtl_opt 2행·use_dims 5행 메타만).
- 생성≠검증: 이 명세는 hpti I1~I7 / hpe E1~E7 독립 재실측 대기(특히 §5-2 저청구 가설은 simulate 확인).
