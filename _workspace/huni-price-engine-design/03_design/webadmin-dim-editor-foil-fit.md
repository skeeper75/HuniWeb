# webadmin-dim-editor-foil-fit.md — 박류 설계가 webadmin "사용차원(use_dims)" 그리드 에디터에 깨끗이 들어맞는가

> **검증가(읽기전용 소스 + 라이브 SELECT) 산출 — 2026-06-30.** 사용자가 보여준 가격뷰어 "사용차원(사용/사용 안 함)"
> 그리드 에디터(좌→우 칩 배치 = 단가표 그리드 컬럼)가 박류 설계(engine-design-foil.md REV4)의 각 comp 차원을
> **빠짐·순서뒤바뀜 없이** 담아낼 수 있는지를 webadmin 소스(admin.py·price_views.py·pricing.py)에서 추출한 에디터
> 메커니즘 기준으로 대조한다. **소스 읽기전용·라이브 SELECT만·DB 쓰기 0·COMMIT 0.**
>
> 권위: ① webadmin 소스(에디터 동작의 정본) > ② 라이브 t_prc_*(실측 baseline) > ③ engine-design-foil.md(검증 대상).
> 근거는 전부 `파일:라인` 또는 라이브 SELECT.

---

## 1. use_dims 에디터 메커니즘 (소스 정본 추출)

### 1-1. 차원 칩 = `DIM_META` / `_USE_DIM_CHOICES` (화면 칩 목록과 1:1)

사용자 스크린샷의 칩 목록은 소스 두 곳에 정확히 정의돼 있다(동일 11종·동일 순서):

- `price_views.py:29-41` `DIM_META` — 그리드 컬럼 빌더가 읽는 차원 메타(라벨·종류·FK모델).
- `admin.py:132-138` `_USE_DIM_CHOICES` — 에디터 위젯의 칩 목록(좌측 "사용 안 함" 풀).

| 칩(라벨) | use_dims 코드 | 종류 | 근거 |
|---|---|---|---|
| 사이즈 | `siz_cd` | fk(TSizSizes) | `price_views.py:30` |
| 판형사이즈 | `plt_siz_cd` | fk(impos_yn=Y만) | `:31`, `:46-48` DIM_FK_FILTER |
| 인쇄옵션 | `print_opt_cd` | fk(TPrtPrintOptions) | `:32` |
| 자재 | `mat_cd` | fk(TMatMaterials) | `:33` |
| **공정** | `proc_cd` | fk(TProcProcesses) | `:34` |
| 옵션코드 | `opt_cd` | text→그리드선 fk | `:35`, `:758-762` |
| 코팅면수 | `coat_side_cnt` | int | `:36` |
| 묶음수 | `bdl_qty` | int | `:37` |
| **사이즈가로(구간)** | `siz_width` | num(numeric 8,2) | `:38` "사이즈가로(이하)" |
| **사이즈세로(구간)** | `siz_height` | num | `:39` "사이즈세로(이하)" |
| **수량구간** | `min_qty` | int | `:40` "수량(이상)" |

### 1-2. 차원 순서 → 그리드 컬럼 (순서 저장 메커니즘)

- **저장 형식**: use_dims = JSONB 배열. 위젯 hidden input 이 **선택 순서대로 콤마결합 + min_qty + 스코프토큰**을 만들어 제출(`admin.py:194-197` `sync()`). 폼 clean 이 그대로 순서 보존해 리스트로 저장(`admin.py:328-344` `clean_use_dims`).
- **순서 = 좌→우 = 그리드 컬럼 좌→우**: 그리드 빌더가 `use_dims` 배열 순서를 그대로 보존해 컬럼을 만든다 — `price_views.py:704-710` `_comp_dims()`: `out = [d for d in dims if d in valid and d != "min_qty"]; out.append("min_qty")`. 즉 **저장된 순서 유지 + min_qty 마지막 강제**.
- **그리드 컬럼 = 적용일 + (use_dims 순서) + [수량구간] + 단가 + 비고**: 위젯 미리보기 `admin.py:235` `"그리드 컬럼 순서: 적용일 · "+sel.map(nm).concat(["수량구간"])+" · 단가 · 비고"` — 스크린샷 문구의 출처. 실제 그리드 헤더도 동일(`price_views.py:749-765`).
- **드래그 순서지정**: `admin.py:246-250` ondragstart/ondrop 이 sel 배열 인덱스를 재배치 → sync() 재호출 → hidden 갱신. 순서는 사용자가 자유 지정.

### 1-3. "옵션그룹 범위"(opt-group scope) = use_dims 끝 토큰 (차원 아님)

- **저장**: 차원이 아니라 use_dims **배열 끝의 토큰 문자열** `"키:코드"` (`price_views.py:50-57`):
  - `opt_grp:코드` — 옵션(opt_cd) 차원의 옵션그룹 범위.
  - `proc_grp:코드` — 공정(proc_cd) 차원의 대상 상위공정(그룹).
- **파싱**: `split_scopes()`(`:60-70`)가 `:` 포함 토큰을 dim 리스트에서 분리 → `{opt_grp, proc_grp}` dict. 토큰은 DIM_ORDER/DIM_META 에 없어 **기존 readers 에 안전**(차원으로 오인 안 됨·`:54` 주석).
- **필터 효과**:
  - `opt_grp` → 옵션코드 드롭다운을 그 그룹 옵션만으로 좁힘(`:726-738` `_opt_cd_options(opt_grp)`).
  - **`proc_grp` → 공정 컬럼을 그 그룹의 하위공정 드롭다운으로 채우고, 그룹의 `prcs_dtl_opt` 상세입력을 추가 "상세 파라미터 컬럼"으로 자동 추가**(`:751-755`, `:602`). 이 상세 파라미터는 `dim_vals`(JSONB)에 저장(`:773-774`, `:836-852`), **siz_width/height 티어 차원과 별개**.
- **에디터 UI**: opt_cd / proc_cd 칩 안에 인라인 검색드롭다운(`admin.py:242-244` `mkSearch`). 별도 폼필드 없음(`admin.py:1307` 주석).

### 1-4. ★"수량구간 항상 마지막" 규칙 — 강제 여부 [돈크리티컬 핵심]

**min_qty 는 모든 comp 에 강제 마지막 컬럼이다 — 사용자가 안 골라도 자동 포함.** 3중 강제:

1. **에디터 위젯**: 좌측 "사용 안 함" 풀에서 min_qty 제외(`admin.py:140` `_NONQTY_DIMS`), 우측 마지막에 **잠금(🔒 항상 마지막) 칩**으로 고정 표시(`admin.py:252-254`). `sync()`가 항상 `sel.concat(["min_qty"])` 제출(`admin.py:194`).
2. **폼 clean**: `clean_use_dims`가 무조건 `out.append("min_qty")`(`admin.py:339`) — 입력에 없어도 추가.
3. **그리드 빌더**: `_comp_dims`가 무조건 `out.append("min_qty")`(`price_views.py:709`). `price_grid_save`도 동일(`:817`).

**∴ webadmin 에디터로 저장하면 use_dims 에 min_qty 가 반드시 들어간다. `["proc_cd"]`로 저장하려 해도 에디터는 `["proc_cd","min_qty"]`로 만든다.**

★ **그러나 이것은 무해하다 — 수량무관 comp(동판비 .03)도 정상 작동.** 엔진 계약으로 입증:
- 엔진은 use_dims 와 무관하게 **항상 TIER_DIMS 3축(siz_width·siz_height·min_qty) 전부를 평가**한다(`pricing.py:160` `for dim in TIER_DIMS`).
- 단가행에 min_qty 가 NULL 이면 `_tier_val` 이 하한차원이라 **0** 반환(`pricing.py:116-117`). 주문수량 qty 는 항상 ≥ 0 → `eligible=[t for t in tiers if t<=qty]` 에 0-티어 항상 포함 → `selected[min_qty]=0` 선택(`:172-178`). 단일 행이 항상 매칭.
- ∴ **min_qty 컬럼이 있어도 단가행 min_qty 를 비우면(NULL) "전 수량 1행"** 이 된다. 곱셈도 없음(`.03` FLAT 은 `component_subtotal:203` `return up,up`·×qty 0).

★ **라이브 실증(SELECT 2026-06-30)**: 명함박 동판비 두 행 — 둘 다 단가행 min_qty=NULL·proc_cd=NULL·5,000원.
- `COMP_NAMECARD_FOIL_SETUP_S1_STD` use_dims=`["min_qty"]` (에디터형) → 1행 min_qty=NULL → 전수량 매칭.
- `COMP_NAMECARD_FOIL_SETUP_S2_STD` use_dims=`[]` (빈 배열) → 1행 min_qty=NULL → 동작 동일.
- **결론**: use_dims 에 min_qty 가 있든(`["min_qty"]`) 없든(`[]`) 단가행 min_qty=NULL 이면 동일하게 "전 수량 1행". min_qty 강제는 가격을 바꾸지 않는다.

### 1-5. 구간(티어) 차원 siz_width/siz_height — 정확매칭 차원과의 차이

- **에디터 라벨** "사이즈가로(구간)·사이즈세로(구간)"(`admin.py:136`) / 그리드 라벨 "(이하)"(`price_views.py:38-39`).
- **저장**: numeric(8,2) 컬럼. 그리드 저장 시 `Decimal.quantize(0.01)`로 자연키 정규화(`price_views.py:873-879`).
- **엔진 처리**: `pricing.py:49-50` TIER_DIMS·TIER_UPPER — **'이하' 상한 ceiling**(off-grid 처리). 손님값이 격자 사이면 그 값을 담는 가장 작은 구간으로 올림(`:165-171`). siz_cd(정확매칭·NON_QTY_DIMS `:42`)와 다름.
- ∴ 박류 설계의 "siz_width/siz_height (구간) + off-grid ceiling" 표현은 **TIER_DIMS 와 정확히 일치**. flatten 면적매트릭스가 그대로 들어맞음.

---

## 2. 박류 comp별 차원 배치 대조표 (에디터 칩 순서 ↔ 설계 use_dims)

각 comp 의 설계 use_dims(REV4)를 에디터 칩으로 좌→우 배치하고, min_qty 강제·옵션그룹범위·문제를 판정.

| comp | 설계 use_dims (REV4) | 에디터 칩 좌→우 배치 | 옵션그룹범위(proc_grp) | 판정 |
|---|---|---|---|---|
| **C-1 대형 동판비**<br>`COMP_FOIL_SETUP_LARGE` | `[proc_cd, siz_width, siz_height]` | 공정 → 사이즈가로(구간) → 사이즈세로(구간) → **[수량구간🔒]** | proc_grp:PROC_000033 권장 | **OK (주의1)** — 에디터가 min_qty 강제 추가 → 저장형 `[proc_cd,siz_width,siz_height,min_qty]`. 단가행 min_qty=NULL 이면 무해(§1-4). 순서 유효 |
| **C-2 소형 동판비**<br>`COMP_FOIL_SETUP_SMALL` | `[proc_cd]` | 공정 → **[수량구간🔒]** | proc_grp:PROC_000033 권장 | **OK (주의1)** — 사이즈 칩 없이 공정만 유효. 에디터가 min_qty 추가 → `[proc_cd,min_qty]`. 단가행 min_qty=NULL → 전수량 1행(명함박 SETUP `["min_qty"]` 실증과 동일). 소형 80×40 고정이라 siz 차원 불요 — 에디터로 표현 가능 |
| **C-3 대형 박가공비 일반박**<br>`COMP_FOIL_PROC_LARGE_STD` | `[proc_cd, siz_width, siz_height, min_qty]` | 공정 → 사이즈가로(구간) → 사이즈세로(구간) → **수량구간🔒** | proc_grp:PROC_000033 | **OK 깨끗** — 4차원 전부 칩 존재·순서 일치·min_qty 마지막=설계 의도와 동일. 아크릴 `COMP_ACRYL_CLEAR3T`(라이브 277행·동일 4차원 패턴) 선례 |
| **C-4 대형 박가공비 특수박**<br>`COMP_FOIL_PROC_LARGE_SPECIAL` | `[proc_cd, siz_width, siz_height, min_qty]` | 동일 | proc_grp:PROC_000033 (특수색만) | **OK 깨끗** — C-3 동형 |
| **C-5 소형 박가공비 일반박**<br>`COMP_FOIL_PROC_SMALL_STD` | `[proc_cd, siz_width, siz_height, min_qty]` | 동일 | proc_grp:PROC_000033 | **OK 깨끗** |
| **C-6 소형 박가공비 특수박**<br>`COMP_FOIL_PROC_SMALL_SPECIAL` | `[proc_cd, siz_width, siz_height, min_qty]` | 동일 | proc_grp:PROC_000033 (3색만) | **OK 깨끗** |

**판정 종합: 6 comp 전부 에디터로 표현 가능. 권위 가격표 차원(공정=박색상·가로·세로·수량) 누락 0·순서 뒤바뀜 0.** 동판비 2개만 "min_qty 강제 추가"라는 주의가 붙으나 가격에 영향 없음(§3).

★ **주의2 — proc_grp:PROC_000033 의 자동 상세 파라미터 컬럼 충돌 [신규 발견]**: 라이브 SELECT 로 PROC_000033(박)의 `prcs_dtl_opt`를 보니 **`{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}`** 가 등록돼 있다. 공정 칩에서 proc_grp:PROC_000033 을 고르면 에디터가 **"크기(mm)"라는 상세 파라미터 컬럼을 자동 추가**(`price_views.py:751-755`·dim_vals 저장)한다. 박가공비 comp 는 가로/세로를 이미 **siz_width/siz_height 티어 차원**으로 쓰므로, proc_grp 의 "크기" 상세 컬럼은 **중복·혼동**이다. 두 갈래 중 택1 필요:
  - (a) **proc_grp:PROC_000033 토큰을 안 쓰고** 공정 칩만 둔다(proc_cd 정확매칭만) → 박색상 16종 전체가 드롭다운에 뜨고 "크기" 상세 컬럼 없음. 단 박색상 드롭다운이 그룹 한정 안 됨(전 공정에서 골라야 함).
  - (b) proc_grp:PROC_000033 을 쓰면 박색상 드롭다운이 박 하위공정으로 깔끔히 좁혀지나 "크기(mm)" 상세 컬럼이 끼어든다 → 이 컬럼을 비워두면(dim_vals 빈값) 매칭에 영향 없음(`pricing.py:103-105`는 dim_vals 가 있을 때만 검사). 비워두는 운영 규칙으로 무해화 가능.
  - **권고**: (b) + "크기 상세 컬럼은 비운다" 적재 규칙. 박색상 드롭다운 한정 이득이 크고, 빈 dim_vals 는 매칭 무영향. 단 적재 SQL 이 dim_vals 에 크기를 넣지 않도록 명시. (설계 §2-1·§5-2 의 "proc_grp 는 그룹 식별 메타·차단력 없음" 서술과 정합 — 단 "크기 상세 컬럼" 부수효과는 설계에 미기재였음 → §5 조정사항.)

---

## 3. 동판비 min_qty 해소 — 수량구간 생략 가능한가, 수량무관을 어떻게 표현하나

**질문**: 동판비(PRICE_TYPE.03·수량무관)를 수량구간 차원 없이 저장할 수 있나? min_qty 가 강제되나?

**답**:
- **에디터로는 min_qty 생략 불가** — 위젯·clean·그리드빌더 3중으로 강제 추가(§1-4). `use_dims=[]`(빈 배열)은 **로더/SQL 직접 적재로만** 가능(`SETUP_S2_STD` 라이브 실증).
- **그러나 생략할 필요가 없다** — min_qty 가 use_dims 에 있어도 **단가행 min_qty 컬럼을 NULL 로 두면 "전 수량 단일 행"** 이 된다. 엔진이 NULL→0 티어로 처리(`pricing.py:116-117`), qty 항상 ≥0 이라 0-티어 항상 매칭, `.03` 은 곱셈 없음(`:203`).
- **수량무관 동판비 표현 = "단가행 1행, min_qty=NULL, unit_price=고정값(.03)"**. 명함박 동판비가 이 패턴으로 라이브 작동 중(SETUP_S1_STD/S2_STD 둘 다 5,000·min_qty NULL).

★ **대형 동판비(C-1)는 면적매트릭스(siz_width·siz_height)** 이므로 면적셀별 여러 행이나 **min_qty 는 전부 NULL**(수량무관). 즉 `[proc_cd,siz_width,siz_height,(min_qty=강제·전행NULL)]` → 면적셀마다 1행, 수량은 안 가름. 정확. 아크릴 `COMP_ACRYL_*`(siz_width/height 면적·min_qty 일부만)이 선례.

**∴ 동판비 수량구간 해소 = "use_dims 에 min_qty 가 강제로 들어가도 단가행 min_qty 를 비우면 수량무관이 정확히 표현된다." 설계 변경 불요.** 단 설계 본문(C-1 use_dims=`[proc_cd,siz_width,siz_height]`·C-2=`[proc_cd]`)은 **에디터 저장형과 다르다**(에디터는 min_qty 추가) — 적재 명세에 "min_qty 자동 추가·단가행 NULL" 을 명기해야 혼동 없음(§5 조정).

---

## 4. 일반박/특수박 통합 vs 분리 — 에디터 적합도 관점 (결정 아님·트레이드오프만)

에디터는 **한 comp 의 단가표를 차원으로 편집**하고, 공정(proc_cd) 차원 한 컬럼이 **여러 박색상(하위공정) 값을 한 그리드에** 담을 수 있다(드롭다운 행마다 다른 proc_cd). 이 관점에서:

| 갈래 | 에디터 편집 모습 | 트레이드오프 |
|---|---|---|
| **통합 (1 comp·공정 차원이 일반+특수 전 박색상)** | 그리드 1개. 공정 컬럼 드롭다운에 박색상 전체(또는 박 하위공정 16종), 행마다 색상+면적+수량 → 단가. 일반/특수 구분은 색상값 자체가 가름(040 먹유광 행 vs 046 백박 행 단가 다름) | **장점**: 그리드 1개로 전 박색상 관리·"공정 차원이 색상 담음" = 에디터 본래 모델에 가장 부합. **단점**: 일반/특수가 같은 면적격자라도 단가블록이 권위상 별도(B03 vs B05)·소형 특수박은 색상 3종만 → 한 그리드에 섞으면 색상별 단가 일관성 육안검수 어려움. ★시트별 일반/특수 색상소속 상이(먹유광=소형일반/대형특수)를 한 그리드 안에서 색상↔단가 직접 입력으로 흡수(매핑테이블 불요해짐) |
| **분리 (2 comp·일반박 comp + 특수박 comp·REV4 채택)** | 그리드 2개(일반/특수 각각). 각 그리드 공정 컬럼=해당 그룹 색상만 | **장점**: 권위 블록 구조와 1:1·추적성·proc_cd 게이트가 silent 이중합산 원천차단(§5-2). **단점**: 그리드 2개 편집·동일 면적격자를 두 번 입력 |

★ **에디터 관점 결론(트레이드오프만·결정 안 함)**: 에디터는 **공정 차원 한 컬럼에 여러 박색상을 담는 통합 그리드**를 자연히 지원하므로, 순수 "편집 편의"로는 **통합 1 comp 가 에디터 모델에 더 잘 맞는다**(그리드 1개·색상↔단가 직접 입력으로 일반/특수 시트별 소속차이까지 흡수). 그러나 REV4 가 분리를 택한 사유(권위 블록 분리·소형/대형 격자겹침 ceiling 충돌·소형특수 3색·추적성)는 **편집 편의와 무관한 가격정확성 사유**라 유효하다.
- **핵심 실무 함의**: 일반/특수를 한 comp 로 통합해도 에디터·엔진은 막지 않는다(proc_cd 정확매칭이 색상별 단가행 1개만 깨움·silent 이중합산은 proc_cd 충전으로 차단·§5-2). 단 **소형/대형 통합은 금지**(면적격자 30·50 겹침 → off-grid ceiling 이 틀린 시트 셀 착지·돈크리티컬·REV4 §4-② 정합). 즉 **"소형/대형은 반드시 분리, 일반/특수는 통합 가능(에디터 친화)"** 이 에디터 기반 권고. 통합 시 박색상별 단가행에 proc_cd 정확매칭 충전 필수(판별차원 없음=silent 이중합산 가드·U-7).

---

## 5. 설계 조정사항 (권위 차원 누락 방지·에디터 정합)

박류 설계가 에디터에 깨끗이 들어맞으나, 에디터 동작과 정합시키기 위한 **명세 보강 3건**(가격 로직 변경 아님·적재 명세 정밀화):

1. **[조정-1·동판비 use_dims 저장형 명기]** C-1/C-2 의 use_dims 를 "에디터 저장형"으로 표기 정정:
   - C-1 본문 `[proc_cd,siz_width,siz_height]` → **저장 실측형 `[proc_cd,siz_width,siz_height,min_qty]`** (에디터 강제·단가행 min_qty=NULL=수량무관). "min_qty 는 자동 추가되며 단가행에서 비운다" 주석 추가.
   - C-2 본문 `[proc_cd]` → **저장 실측형 `[proc_cd,min_qty]`** (동). 명함박 SETUP `["min_qty"]`/`[]` 실증과 정합.
   - ★이는 §1-4 입증대로 가격 무영향(min_qty NULL→전수량 1행). 설계의 "수량무관 .03" 의도 그대로 달성. 단 "use_dims 에 min_qty 없음" 이라는 본문 단정은 에디터로 적재 시 사실과 달라지므로 정정.

2. **[조정-2·proc_grp 상세 "크기" 컬럼 운영규칙]** §2 주의2 — proc_grp:PROC_000033 사용 시 에디터가 "크기(mm)" 상세 파라미터 컬럼을 자동 추가(`price_views.py:751-755`·라이브 PROC_000033 prcs_dtl_opt 확인). 박가공비는 가로/세로를 siz_width/height 티어로 쓰므로 **"크기" 상세 컬럼은 비운다(dim_vals 미충전)** 는 적재 규칙을 §2-1/§5-2 에 명기. 빈 dim_vals 는 매칭 무영향(`pricing.py:103-105`)이라 무해. (대안: proc_grp 토큰 미사용·proc_cd 정확매칭만 — 단 박색상 드롭다운 한정 이득 상실.)

3. **[조정-3·없음 — 차원 누락 0 확인]** 권위 가격표의 박 차원(박색상=공정·면적가로·면적세로·수량구간)이 **에디터 칩에 전부 존재**하고 설계 use_dims 에 빠짐없이 배치됨을 §2 표로 확인. **누락 차원 0**. flatten(grade→단가 펼침)으로 grade 차원이 에디터에 없어도 문제없음(grade 는 note 추적·매칭 비사용·REV4 정합). **추가 차원 mint 불요.**

★ 위 3건은 전부 **명세 표기·운영규칙** 이며 박 가격 로직(comp 5 신설·.03 FLAT·본체 공식 합산·proc_cd 게이트)은 불변. golden 8/8·돈크리티컬 가드 영향 0.

---

## 6. 근거 인덱스 (file:line · 라이브 SELECT)

- 차원 칩 정의: `price_views.py:29-41` DIM_META · `admin.py:132-138` _USE_DIM_CHOICES
- 순서 저장·그리드 컬럼: `admin.py:194-197,235,246-250` 위젯 sync/preview/drag · `price_views.py:704-710` _comp_dims · `:749-768` price_grid 컬럼빌더
- opt_grp/proc_grp 토큰: `price_views.py:50-70` 토큰 정의·split_scopes · `:726-738,751-755` 스코프 적용
- min_qty 강제: `admin.py:139-140,194,252-254,339` · `price_views.py:709,817`
- 수량무관 .03 무해성: `pricing.py:116-117,160-178,193-204` (NULL→0 티어·항상매칭·FLAT 곱셈0)
- 티어 차원(siz_width/height ceiling): `pricing.py:45-50,114-118,165-171`
- 라이브 실측(2026-06-30·읽기전용): 명함박 SETUP_S1_STD use_dims=`["min_qty"]`·SETUP_S2_STD=`[]`·둘 다 단가행 min_qty=NULL·proc_cd=NULL·5,000 / 아크릴 COMP_ACRYL_CLEAR3T `[mat_cd,siz_width,siz_height,min_qty]` 277행(.02 면적매트릭스 선례) / 제본·코팅 comp `[proc_cd,...,min_qty,proc_grp:PROC_xxx]` 선례 / PROC_000033(박) 하위 16종·prcs_dtl_opt={크기 mm}

---

## 가격공식 결합(formula-composition) 메커니즘 — 동판비·박비를 공식으로 계산 가능한가

> 사용자 질문: "상품은 가격구성요소를 결합하여 가격공식을 만들어 계산하도록 돼 있는데, 이 부분을 이용해 동판비와 박비를 계산할 수 없는 것인지 확인 필요."
> **답: 가능하다. 그것이 바로 라이브에서 이미 작동하는 정식 방식이다(명함박 PRF_NAMECARD_FOIL 실증).** 아래 소스·라이브로 입증.

### A. 공식 = 묶인 구성요소들의 평탄(flat) 합산 [소스 정본·file:line]

- **공식 빌더 = 공식↔구성요소 junction 편집**: `t_prc_formula_components`(`models.py:205-217`) PK=`(frm_cd, comp_cd)` — 공식코드 ↔ **구성요소코드** 묶음. 컬럼=`disp_seq`(표시순서)·`addtn_yn`(가산여부). webadmin admin 가격공식 change 화면에서 구성요소를 인라인 추가/순서지정(`admin.py:962` `ordering_field="disp_seq"`·`:965` "구성요소 (이 공식이 합산할 항목 — 드래그로 순서 조정)").
- **★공식에는 "구성요소"만 묶인다 — "다른 공식"을 묶는 필드가 없다**: `TPrcFormulaComponents` 의 두 FK 는 `frm_cd→TPrcPriceFormulas`·`comp_cd→TPrcPriceComponents`(`models.py:207-208`)뿐. `TPrcPriceFormulas`(`:241-252`)에도 sub-formula·parent-formula 컬럼 없음. **공식→공식 참조(nesting) 스키마가 존재하지 않는다.**
- **evaluate_price 의 합산**: 상품→최신 공식 1개 해석(`pricing.py:469-477`) → `_evaluate_formula`(`:643-711`). 그 안: `:657-660` 공식 구성요소를 `disp_seq` 순으로 로드(comp 만·다른 공식 미참조) → `:672-711` **평탄 루프 합산** `total += entry["subtotal"]`(`:705,710`) → 최종 `base_amount = included_sum`(`:498-500`). ∴ **"공식 = 그 공식에 묶인 구성요소들의 합산"** 확정(`:498` `sum(c["subtotal"] for c if c["included"])`).
- **proc_cd 게이트로 미선택 구성요소가 0 기여**: 공정(`proc_cd`) 차원 구성요소는 손님이 그 공정을 안 고르면 `selections["proc_cd"]` 미충전 → `_row_matches` 실패 → `match_component` `{"row":None,"reason":"no_match"}`(`pricing.py:143-146`) → `_match_entry` `included=False·subtotal=0`(`:593-594,618-620`). **합산 자동 제외(0 기여).** 한 공식에 택일 구성요소를 여러 개 묶어도 고른 1개만 가산(라이브 PRF_DGP_E 접지 4종 실증·C). 다중 공정은 고른 공정마다 개별 평가 합산(`:694-705`).

### B. 박 와이어링 2안 — (a) 본체 공식 직접합산 vs (b) 전용 박 공식 — 판정

| 안 | webadmin 모델 적합 | 기계적 가능성 |
|---|---|---|
| **(a) 각 상품 본체 공식 formula_components 에 동판비+박가공비 comp 행 추가** | ✅ **채택(REV4 현 선택)** — `t_prc_formula_components` 행 추가 = 빌더 인라인 추가 그대로. 라이브 광범위 선례(C) | **가능**(스키마·엔진 완전 지원) |
| **(b) 전용 박 공식(예 PRF_FOIL)이 동판비+박가공비를 묶고 본체 공식이 그 박 공식을 참조/포함** | ✗ **불가** | **★기계적으로 불가능** — 공식→공식 참조 스키마·엔진 경로 부재(§A: junction 은 frm↔comp·`TPrcPriceFormulas` sub-formula FK 없음·`_evaluate_formula:657` comp 만 로드·nesting 미구현). 상품은 **최신 공식 1개**만 가짐(`pricing.py:469-471`)이라 "본체+박 두 공식 동시" 도 불가 |

★ **(b)를 억지로 하면 = (a)로 귀결**: 박 전용 공식을 만들어도 본체가 참조할 길이 없어, 결국 **박 comp 들을 각 본체 공식에 복제 투입**(=a)해야 한다. 상품에 직접 바인딩 안 된 PRF_FOIL 은 evaluate_price 가 절대 호출 안 하는 죽은 행(`pricing.py:469` 는 링크된 공식만 평가). **∴ (a)가 유일하게 작동하는 방식.**

### C. 라이브 선례 — (a)가 실증된 정식 패턴 [SELECT 2026-06-30·읽기전용]

- **PRF_NAMECARD_FOIL = 박가공비 + 동판셋업 직접합산** (사용자 질문 직접 답):

  | disp_seq | comp_cd | comp_nm | prc_typ | use_dims |
  |---|---|---|---|---|
  | 1 | COMP_NAMECARD_FOIL_S1_STD | 오리지널박명함 완제품가 단면·일반박(종이+동판+박) | .02 | `["min_qty"]` |
  | 2 | COMP_NAMECARD_FOIL_SETUP_S1_STD | 박·형압 동판셋업비 단면 | .03 | `["min_qty"]` |

  → 박가공비 comp + 동판셋업 comp 두 행을 한 공식에 묶어 합산. **동판비·박비가 "가격구성요소를 결합한 공식"으로 이미 계산되고 있다 = 사용자 질문의 라이브 Yes.**
- **PRF_DGP_E(접지카드) = 9 구성요소 직접합산 + 택일 게이트**: 디지털인쇄비·유광/무광코팅비·용지비·**접지 4종(반접지/3단/4단아코디언/4단게이트·disp_seq 4~7)**·타공비. 손님이 고른 접지 1개만 proc_cd 매칭·나머지 3개 no-match→0. **"한 평탄 공식에 택일 구성요소 여러 개 + proc_cd 게이트로 1개만 가산"** 라이브 작동 = 박 일반/특수·박색상 다종을 같은 식으로 넣을 근거.

### D. 7 박 상품 바인딩 절차 (각 본체 공식에 박 comp 행 추가·proc_cd 게이트 미선택 0) [라이브 실측]

| prd_cd | 상품명 | 현재 본체 공식 | 추가할 박 comp(시트) | 미선택 0 |
|---|---|---|---|---|
| PRD_000031 | 프리미엄명함 | PRF_NAMECARD_FIXED(공유 3) | 소형 동판비 + 소형 일반/특수 박가공비 | proc_cd 게이트 |
| PRD_000034 | 펄명함 | PRF_NAMECARD_PEARL(전용 1) | 소형 동판비 + 소형 일반/특수 박가공비 | proc_cd 게이트 |
| PRD_000029 | 3단접지카드 | PRF_DGP_E(공유 3) | 대형 동판비 + 대형 일반/특수 박가공비 | proc_cd 게이트 |
| PRD_000027 | 2단접지카드 | PRF_DGP_E(029와 동일 공식) | (같은 공식·1회 추가로 둘 다 적용) | proc_cd 게이트 |
| PRD_000042 | 프리미엄쿠폰/상품권 | PRF_DGP_A(공유 10) | 대형 동판비 + 대형 일반/특수 박가공비 | proc_cd 게이트 |
| PRD_000069 | 무선책자 | PRF_BIND_MUSEON(전용 1) | 대형 동판비 + 대형 일반/특수 박가공비(표지박) | proc_cd 게이트 |
| PRD_000070 | PUR책자 | PRF_BIND_PUR(전용 1) | 대형 동판비 + 대형 일반/특수 박가공비 | proc_cd 게이트 |

★ **명함박(PRD_000037·PRF_NAMECARD_FOIL)은 미터치**(이미 (a)로 와이어드·보존).

★★ **[돈크리티컬 신규 발견·공유 공식 오염 가드]** 본체 공식이 여러 상품에 공유된다 — 라이브 실측:
- **PRF_DGP_E** = PRD_000027·**028(미니접지카드·박 비대상)**·029 **3상품 공유**.
- **PRF_DGP_A** = 엽서 7종+슬로건+쿠폰 2종 **10상품 공유**(박 대상은 PRD_000042 하나뿐).
- **PRF_NAMECARD_FIXED** = PRD_000031·**032(코팅명함)·033(스탠다드명함)** **3상품 공유**(박 대상 031뿐).
- → **오염 신호이나 proc_cd 게이트가 무해화**: 비-박 상품 손님은 박 공정 자체를 선택지로 안 받음(product_processes 미등록) → 박색상 proc_cd 미충전 → no-match→0(B·C 실증). **가격은 안 샌다.** 단 시뮬레이터/공식 구성요소 목록에 박 comp 가 included=False 카드로 비-박 상품에도 보일 수 있음.
- **★권고(Q-FOIL-FRM1 신설)**: 비-박 상품 화면 노출 부담·상품군별 박 단가 분기 위험이 있으면, 박 대상 상품만 **별 공식으로 분기**해 그 상품 링크 교체(`t_prd_product_price_formulas` 시계열 새 행)가 깔끔하다(예 PRD_000042→`PRF_DGP_A_FOIL`·PRD_000031→`PRF_NAMECARD_FIXED_FOIL`). **이는 (a)의 변형(여전히 평탄 합산·nesting 아님)** 이며 공유오염을 원천차단. 전용 공식(PEARL·MUSEON·PUR)은 1:1이라 분기 불요. 분기 vs 공유유지는 가격 무영향·표시/유지보수 트레이드오프(실무 판단).

### E. formula-composition 이해 후 최종 일반박/특수박 통합 vs 분리 권고

§4(에디터 관점)에 공식결합 관점을 더한 **최종 권고**:
- **공식 와이어링 부담**: 통합 1 comp → 공식 박가공비 행 **1개** 추가. 분리 2 comp → **2개**(일반+특수) 추가. 둘 다 평탄 합산이라 기계적으로 동일 동작(택일 게이트 한쪽만 매칭).
- **매칭 안전성(돈크리티컬)**:
  - 통합 1 comp: 한 단가표에 일반·특수 섞임. **proc_cd 정확매칭이 색상별 1행만 깨움**→이중합산 없음. 단 색상별 proc_cd 충전을 누락하면 동일 (proc_cd·면적·수량) 충돌→`ERR_AMBIGUOUS`(`pricing.py:152-154`) 위험.
  - 분리 2 comp: 일반/특수 comp 둘 다 한 공식에 묶임·고른 색상 그룹만 매칭·반대 comp no-match→0(PRF_DGP_E 접지 택일 동형·안전). **+ 소형/대형 격자겹침 ceiling 충돌을 comp 경계로 원천차단**(REV4 §4·통합 불가 사유).
- **★최종 권고**: **소형/대형은 반드시 분리**(격자겹침 ceiling 돈크리티컬·통합 절대 금지). **일반/특수도 분리 유지 권장**(REV4 정합) — 공식 와이어링 1행 더 늘 뿐이고 PRF_DGP_E "한 공식 택일 comp 다수"가 라이브 안전 입증됐으며, 권위 단가블록(B03/B05)·소형특수 3색·추적성·proc_cd 충전누락 시 ERR_AMBIGUOUS 회피 측면에서 분리가 더 견고. 통합도 기계적 가능(에디터 친화·§4)이나 가격정확성 이득이 분리에 있어 **분리 유지가 최종 권고**(가격 무영향 구조선택·실무 최종 판단 존중).

### F. 근거 인덱스 (이 절)

- 공식=구성요소 평탄합산: `pricing.py:498`·`:643-711`(`:657-660` comp 로드·`:705,710` total) · `models.py:205-217`
- nesting 불가: `models.py:207-208,241-252`(공식↔공식 FK 없음)·`pricing.py:469-471`(상품당 공식 1개)
- proc_cd 미선택→0: `pricing.py:143-146,593-594,618-620,694-705`
- 라이브 선례(SELECT 2026-06-30): PRF_NAMECARD_FOIL=박가공비(.02)+동판셋업(.03) 2행 / PRF_DGP_E=9 comp(접지 4종 택일) / 7 박상품 본체공식=NAMECARD_FIXED(3공유)·PEARL(전용)·DGP_E(3공유)·DGP_A(10공유)·BIND_MUSEON/PUR(전용)
