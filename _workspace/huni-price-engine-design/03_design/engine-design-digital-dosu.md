# engine-design-digital-dosu.md — 디지털인쇄 도수(흑백/칼라) 차원축 설계 [갈래 A: clr_cd]

> **핵심 설계가(hpe-engine-designer) 산출.** 사용자 directive: "흑백 디지털 인쇄도 팔 계획" + **갈래 A 확정**(도수=clr_cd 차원으로 일관 적재·evaluate_price가 clr_cd를 매칭 차원으로 보게).
>
> ★ **정정[HARD]**: 직전 세션 B안(proc_cd)의 "A안 무효" 판정은 **오해**였다. "webadmin 코드 직접수정 금지"는 *우리가* 코드를 편집하지 말라는 것이지 엔진이 바뀌면 안 된다는 게 아니다. **엔진 변경(clr_cd를 NON_QTY_DIMS에 추가)을 개발팀용 C트랙 명세로 산출**하는 것은 허용된다(우리=명세, 개발팀=적용). B안 산출은 `_prev-dosu-Bplan/`에 보존·결정 기록은 design-decisions-dosu.md.
>
> 권위[HARD]: ① 인쇄상품 가격표 `디지털인쇄비` 시트(흑백 단가 실재) > ② 라이브 t_prc_*/엔진 코드(기준선) > ③ t_clr_color_counts(도수 코드).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-29 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 COMMIT/DDL은 인간 승인 후 dbmap 위임 · webadmin 코드 직접 편집 금지=명세만 산출).

---

## 0. 결함 + 설계 한 줄

- **결함**: 디지털인쇄비 comp `COMP_PRINT_DIGITAL_S1`(212행) 전부 칼라(CMYK)·clr_cd=NULL. 손님이 흑백 선택 불가 → 흑백 주문도 칼라로 계산(과청구). 권위에 흑백 단가 실재(국4절 단면 qty1=3000 vs 칼라 4000).
- **설계(갈래 A)**: 도수를 **clr_cd 차원**으로 일관 인코딩. ① 엔진 변경 명세(NON_QTY_DIMS에 clr_cd 추가·개발팀 C트랙) ② 칼라 212행 clr_cd NULL→CLR_000005 UPDATE + 흑백 212행 clr_cd=CLR_000002 INSERT(verbatim) ③ COMP_PRINT_DIGITAL_S1.use_dims에 clr_cd 등재 ④ 디지털 상품에 도수 택1 옵션→selections.clr_cd 환원(default 칼라).

---

## 1. 엔진 변경 명세 (개발팀 C트랙) ★[HARD] 우리가 적용 안 함·명세만

### 1.1 변경 위치·전후

- **파일**: `raw/webadmin/webadmin/catalog/pricing.py`
- **라인**: 42 (`NON_QTY_DIMS` 튜플 정의)
- **변경**: 튜플에 `"clr_cd"` 1개 추가(한 줄 수정).

**전(현재):**
```python
NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "coat_side_cnt", "bdl_qty")
```

**후(C트랙 적용 후):**
```python
NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "coat_side_cnt", "bdl_qty", "clr_cd")
```

### 1.2 이 한 줄이 바꾸는 것 (코드 경로)

`clr_cd`가 NON_QTY_DIMS에 들어가면 다음 4개 함수가 clr_cd를 매칭/키에 포함한다(전부 NON_QTY_DIMS를 순회):

| 함수(라인) | 변화 |
|-----------|------|
| `_row_matches`(94-106) | 행의 clr_cd가 NULL이면 `continue`(와일드카드·통과), non-NULL이면 `_norm(sel)!=_norm(rv)`로 선택값 비교 |
| `_combo_key`(109-111) | combo 키 튜플 끝에 `_norm(row.clr_cd)` 추가(동시매칭 판정 차원에 clr_cd 포함) |
| `_no_match_detail`(566-580) | clr_cd 차원의 빵꾸 진단(어떤 행이 clr_cd non-NULL일 때만) |
| `_match_entry` non_qty_dims(599) | use_dims에 clr_cd가 있는 comp만 판별차원 목록에 포함(시뮬레이터 표시) |

### 1.3 리스크 (개발팀 검토용)

- **리스크 R-A1 (낮음·후방호환 입증됨)**: 전 component_prices 8,753행이 clr_cd=NULL(실측). NULL 행은 `_row_matches`에서 와일드카드(통과)·`_combo_key`에서 모두 None(키 구조 불변) → **clr_cd를 NON_QTY_DIMS에 넣어도 기존 매칭 결과 불변**(§2 전역 영향분석에서 입증). 후방호환 OK.
- **리스크 R-A2 (격리됨)**: 실제 분기는 (a)단가행 clr_cd 채움 + (b)comp use_dims에 clr_cd 등재 + (c)selections.clr_cd 주입 — **셋 다** 충족한 comp에서만. 디지털만 충족시키면 디지털만 영향(나머지 NULL 유지=무해).
- **리스크 R-A3 (선택 강제)**: 칼라 행에 clr_cd=CLR_000005 채우고 use_dims 등재하면, 디지털 selection이 **반드시 clr_cd를 넘겨야** 매칭(미선택 None≠CLR_000005→칼라 행 탈락→견적불가). → **도수 옵션 default=칼라(CLR_000005)** 필수(§5).
- **리스크 R-A4 (회귀 테스트)**: vitest/기존 가격 테스트에 clr_cd 미사용 케이스가 모두 통과해야(NULL 와일드카드). C트랙 적용 시 회귀 스위트 재실행 권장.

★ **이 변경은 우리가 적용하지 않는다**(webadmin 코드 직접 편집 금지). 명세만 산출 → 개발팀 C트랙. 적용 순서: §6.1.

---

## 2. ★전역 영향분석 (핵심) — 후방호환·blast radius 격리

### 2.1 NULL clr_cd 행 후방호환 (clr_cd 미선택 시 그대로 매칭되는가?)

라이브 실측: **전 8,753 단가행 clr_cd=NULL**(0행만 비NULL — 즉 현재 누구도 clr_cd 안 씀). 엔진 코드 실측:

| 시나리오 | 코드 동작(라인) | 결과 |
|----------|----------------|------|
| NULL clr_cd 행 + clr_cd 미선택(selections에 clr_cd 없음) | `_row_matches`: `rv=row.clr_cd=None → continue`(와일드카드) | **통과**(기존과 동일) |
| NULL clr_cd 행 + clr_cd 선택(예 흑백 selections.clr_cd=CLR_000002) | `_row_matches`: `rv=None → continue`(행이 NULL이라 와일드카드·선택값 무시) | **통과**(NULL 행은 도수 무관 매칭) |
| `_combo_key` | NULL 행 전부 `_norm(None)=None` → 같은 comp 내 모든 NULL 행이 동일 None → **clr_cd 외 차원이 키 결정**(기존과 동일) | combo 구조 불변 |

**∴ 후방호환 ✅**: clr_cd를 NON_QTY_DIMS에 넣어도, clr_cd=NULL인 8,753행(=디지털 칼라 212행 포함 현재 전부)은 **여전히 와일드카드로 그대로 매칭**. 기존 견적 결과 불변. 디지털 칼라 행을 clr_cd=CLR_000005로 채우기 전까지 동작 변화 0.

### 2.2 어떤 comp가 clr_cd 의존/비의존인가 (blast radius)

| comp 군 | clr_cd 의존? | 처리 |
|---------|-------------|------|
| **COMP_PRINT_DIGITAL_S1**(디지털인쇄비) | **의존(이번 대상)** | 칼라 212행 clr_cd 채움 + 흑백 212행 INSERT + use_dims에 clr_cd 등재 |
| COMP_PRINT_SPOT_WHITE_S1(별색) | 잠재 의존(현 proc_cd로 색 구분) | **현행 유지**(§4 별색 결정·이번 범위 밖) |
| 그 외 전 comp(용지·코팅·후가공·박·제본·면적격자 등) | **비의존** | **무변경**(clr_cd NULL 유지·use_dims에 clr_cd 미등재 → 영향 0) |

**blast radius 격리 = use_dims 등재로 제어**: 엔진 변경(NON_QTY_DIMS)은 전역이지만, **실제 매칭 분기는 use_dims에 clr_cd가 있는 comp에서만 일어나고**(non_qty_dims 목록·_no_match_detail), 단가행이 NULL이면 와일드카드. ∴ **COMP_PRINT_DIGITAL_S1만 (use_dims 등재 + 단가행 clr_cd 채움)** 하고 나머지 comp는 손대지 않으면 **디지털만 영향·나머지 전 comp 무해**.

### 2.3 디지털만 clr_cd 채우고 나머지 NULL 유지 = 안전한가?

**예 — 안전.** 근거:
1. NON_QTY_DIMS에 clr_cd 추가는 전역이나, NULL 행 와일드카드라 비디지털 comp 결과 불변(§2.1).
2. 디지털 comp만 use_dims 등재 + 단가행 clr_cd 채움 → 디지털만 도수 분기.
3. 비디지털 comp는 use_dims에 clr_cd 없음 → `_no_match_detail`이 clr_cd를 빵꾸로 안 봄·`non_qty_dims`에 clr_cd 없음 → selections에 clr_cd가 있어도 비디지털 comp는 clr_cd 무시(단가행 NULL 와일드카드).

★ **단, 안전 전제[HARD]**: 디지털 칼라 212행에 clr_cd=CLR_000005 **채우는 순간** 그 comp는 "도수 선택 필수"가 된다(R-A3). 미선택 시 칼라 행 탈락→견적불가. ∴ 칼라 행 채움과 **동시에** 도수 옵션 default=칼라(§5)를 배선해야 회귀 0. 칼라 행 채움 전(현 NULL)에는 무해.

---

## 3. 데이터 마이그레이션 — 칼라 UPDATE 212 + 흑백 INSERT 212

### 3.1 칼라 212행 clr_cd 채움 (UPDATE NULL→CLR_000005)

- 대상: COMP_PRINT_DIGITAL_S1·proc_cd=PROC_000004(칼라)·clr_cd 현재 NULL인 212행.
- UPDATE clr_cd=CLR_000005(CMYK 4도). **단가값 불변**(clr_cd 컬럼만).
- 멱등: `WHERE comp_cd=... AND proc_cd='PROC_000004' AND clr_cd IS NULL`(이미 채워진 행 재UPDATE 안 함).

### 3.2 흑백 212행 INSERT (clr_cd=CLR_000002 verbatim)

매핑 규칙 (권위 `디지털인쇄비` 시트 → 단가행):

| 권위 차원 | 단가행 차원 | 값 |
|-----------|------------|----|
| 블록 B01=국4절 | plt_siz_cd | SIZ_000499 |
| 블록 B02=3절 | plt_siz_cd | SIZ_000077 |
| 색상열 흑백(1도) | **clr_cd** | **CLR_000002** |
| (인쇄방식) | proc_cd | **PROC_000004**(디지털인쇄·칼라와 동일·도수는 clr_cd로 분기) |
| 면 단면/양면 | print_opt_cd | POPT_000001 / POPT_000002 |
| 수량 row_key | min_qty | verbatim(1,2,…,1000000·53밴드) |
| 셀 값 | unit_price | **권위 verbatim** |
| prc_typ | (comp 상속) | PRICE_TYPE.01(단가형) |

★ **갈래 A 핵심**: 흑백 행의 proc_cd는 **칼라와 동일 PROC_000004**(둘 다 디지털인쇄 방식). 도수 구분은 **오직 clr_cd**(흑백 CLR_000002 vs 칼라 CLR_000005). 별색처럼 proc_cd로 도수를 가르지 않음 — **도수=clr_cd로 일관**(갈래 A 정의).

### 3.3 적재 규모

| 작업 | 대상 | 규모 |
|------|------|------|
| 칼라 clr_cd UPDATE | PROC_000004 행 NULL→CLR_000005 | **212 UPDATE** |
| 흑백 단가행 INSERT | CLR_000002·국4절(단53+양53)+3절(단53+양53) | **212 INSERT** |
| use_dims 등재 UPDATE | COMP_PRINT_DIGITAL_S1.use_dims에 clr_cd 추가 | **1 UPDATE**(comp) |
| 도수 옵션그룹/아이템 | 디지털 상품마다(§5·~15상품) | 상품별 |

흑백 53밴드 = 칼라 라이브 53밴드와 1:1 정합(실측). 단가 verbatim: 국4절 단면 qty1=3000·양면=4000·qty100=200·qty1000=70·3절 단면 qty1=3500(golden-cases-dosu 전수·dosu-load-draft.sql).

---

## 4. 별색 처리 결정 — 현행 유지 (blast radius 최소화 · 권고)

- 현재 별색7종 = COMP_PRINT_SPOT_WHITE_S1 단일 comp + proc_cd(PROC_000008~012 색)·proc_grp:PROC_000007. **도수가 아니라 색을 proc_cd로 인코딩**.
- **권고: 별색은 현행 유지**(이번 A안 범위는 디지털 흑백/칼라 도수). 근거:
  1. 별색은 "도수"보다 "추가 색 인쇄"(화이트/클리어/금/은/핑크) — clr_cd(도수=1도/4도) 의미축과 다름. clr_cd로 강제 통합 시 의미 왜곡.
  2. blast radius 최소화 — 별색 530행을 건드리면 별색 쓰는 상품 전부 회귀 위험. 이번 목표(흑백 판매)와 무관.
  3. 별색 통합은 **후속 가능**(별색도 clr_cd 의미축으로 재정리할지는 별 설계·도메인 컨펌 C-5).
- ∴ A안 = **디지털 흑백/칼라만 clr_cd로·별색은 proc_cd 현행 유지**. 두 축(도수 clr_cd·별색 proc_cd)이 공존(엔진은 둘 다 NON_QTY_DIMS 차원으로 독립 매칭).

---

## 5. 선택 배선 — 도수 옵션 → selections.clr_cd 환원 + default

### 5.1 도수 택1 옵션그룹 (clr_cd 환원)

- 신규 option_group `도수`(또는 `인쇄도수`) 택1 필수(mand_yn=Y·SEL_TYPE.01).
- option_items 2개: `칼라(CMYK)`→ref_dim_cd=**clr_cd**·ref_key1=**CLR_000005**(dflt_yn=Y) / `흑백`→ref_dim_cd=clr_cd·ref_key1=**CLR_000002**.
- 손님 선택 → option_items.ref_dim_cd/ref_key1로 **selections.clr_cd** 주입(옵션→차원 polymorphic 환원).

### 5.2 ★default=칼라 (R-A3 견적불가 가드)

- 칼라 212행 clr_cd=CLR_000005 채우면, 디지털 selection은 **반드시 clr_cd를 넘겨야** 칼라 행 매칭(미선택 None≠CLR_000005→탈락→견적불가).
- ∴ **도수 옵션 dflt_yn=Y를 칼라(CLR_000005)** 로 → 미선택 시 selections.clr_cd=CLR_000005 자동 주입 → 칼라 매칭(현행 동작 보존·회귀 0).
- ★주입 미연결(option_items ref_dim 0행 가능·명함 G-7 동일) → 칼라 행 탈락→견적불가 위험. **칼라 행 채움 = 도수 옵션 주입 작동과 동시 적용**(시뮬레이터 게이트 선결 C-3). 미연결 동안은 칼라 행을 NULL로 두면 와일드카드라 무해(점진 적용).

### 5.3 위젯 계약

- 위젯 "도수(흑백/칼라)" 드롭다운 → selections.clr_cd 전송(siz_cd·print_opt_cd 등과 동일 직렬화 경로·신규 계약 키=clr_cd 1개).

### 5.4 영향 상품 (PRF_DGP_A~F 바인딩)

COMP_PRINT_DIGITAL_S1을 쓰는 PRF_DGP_A~F 바인딩 **20상품**(출시 use_yn=Y ≈ **15**: 엽서 6·상품권 2·슬로건·접지카드 2·배경지 2·헤더택·라벨택·소량전단). 도수 옵션그룹은 상품별 추가(흑백 단가행은 comp 공유·1회). 부분 판매 가능(엽서만 등·C-4).

---

## 6. evaluate_price 동작 — 분기·동시매칭·default

### 6.1 적용 순서

```
1) [C트랙·개발팀] pricing.py NON_QTY_DIMS에 "clr_cd" 추가
2) [dbmap] COMP_PRINT_DIGITAL_S1.use_dims에 clr_cd 등재 (UPDATE)
3) [dbmap] 흑백 212행 INSERT (clr_cd=CLR_000002 verbatim)
   + UPDATE 칼라 212행 clr_cd NULL→CLR_000005   ← ★원자(같은 트랜잭션·§6.3)
4) [dbmap] 도수 옵션그룹/아이템 추가 (selections.clr_cd 주입·default 칼라)
```
- ★ 3)의 칼라 채움은 4)(default 칼라 주입) 작동 확인과 묶여야(미선택 견적불가 가드 R-A3). 점진 적용 시 칼라 채움을 마지막에·그 전엔 칼라 NULL(와일드카드 무해).

### 6.2 흑백/칼라 분기

- 칼라 선택 → selections.clr_cd=CLR_000005 → `_row_matches`: 칼라 행(clr_cd=CLR_000005) 통과·흑백 행(CLR_000002) `_norm(sel)!=_norm(rv)` 탈락 → **칼라 단가만**.
- 흑백 선택 → selections.clr_cd=CLR_000002 → 흑백 행만 통과·칼라 행 탈락 → **흑백 단가만**.

### 6.3 동시매칭(ERR_AMBIGUOUS) 가드 ★핵심

- **칼라 채움 후 정상**: 칼라 행(CLR_000005)·흑백 행(CLR_000002) clr_cd 다름·proc_cd 동일 → `_combo_key`(clr_cd 포함)로 키 구분 → 도수 택1 시 combos 1개 → ambiguous 없음.
- **★칼라 채우기 전 위험**: 칼라 행 clr_cd=NULL(와일드카드) 상태에서 흑백 행(CLR_000002) INSERT하면 → 흑백 선택 시 칼라(NULL·와일드카드 통과)+흑백(CLR_000002 명시 통과) **둘 다 cand** → combo_key 다름(None vs CLR_000002) → **ERR_AMBIGUOUS**(데이터 오류·합산 제외=언더차지 위험·silent 합산은 아님). ∴ **칼라 UPDATE 212 + 흑백 INSERT 212를 같은 트랜잭션으로 원자 적용**(둘 다 명시값이라 깨끗이 분기). 이게 갈래 A의 핵심 가드[HARD].

### 6.4 default

- 도수 옵션 dflt=칼라(CLR_000005) → 미선택 시 selections.clr_cd=CLR_000005 → 칼라 매칭(현행 보존). use_dims 등재·옵션 주입 작동 전제.

### 6.5 계약 정합 체크표

| 계약 | A안 준수 |
|------|----------|
| C7 frm_typ 미참조 | ✅ clr_cd 차원만·공식 구조 불변 |
| P3-8 ERR_AMBIGUOUS 금지 | ✅ 칼라/흑백 clr_cd 상이·도수 택1·칼라 채움과 흑백 INSERT 원자 적용(§6.3) |
| P3-DEF 판별차원 없음 금지 | ✅ clr_cd 판별차원(채운 후)·use_dims 등재 |
| 후방호환(NULL 와일드카드) | ✅ 8,753 NULL 행 불변(§2.1) |
| blast radius 격리 | ✅ 디지털만 use_dims+단가행 채움(§2.2) |
| search-before-mint | ✅ 신규 comp·proc·clr 코드 0(CLR_000002/5 재사용) |
| U-7 시트 차원경계 | ✅ 디지털인쇄비 시트 내 |

---

## 7. search-before-mint · FK 위상 · 인간 승인

### 7.1 search-before-mint

- 신규 comp 0·신규 proc_cd 0·신규 clr_cd 0(CLR_000002 흑백·CLR_000005 칼라 **재사용**·실재 확인)·신규 siz/POPT 0. **신규 코드 mint 0**.
- 신규 = 흑백 단가행 212(데이터)·칼라 clr_cd UPDATE 212·use_dims UPDATE 1·도수 옵션그룹(상품별).

### 7.2 FK 위상·멱등

```
1) [C트랙] pricing.py 변경 (코드·우리 적용 안 함)
2) UPDATE COMP_PRINT_DIGITAL_S1.use_dims += clr_cd
3) INSERT 흑백 212행 (clr_cd=CLR_000002·NOT EXISTS 가드)
   + UPDATE 칼라 212행 clr_cd NULL→CLR_000005  ← 원자(같은 트랜잭션·§6.3)
4) 도수 옵션그룹/아이템 (prd_cd·복합키 멱등)
```
- 멱등: 흑백 INSERT NOT EXISTS(comp,proc,plt,popt,clr,min_qty,apply_ymd)·칼라 UPDATE WHERE clr_cd IS NULL.
- **실 COMMIT 금지** — dryrun(BEGIN…ROLLBACK)·인간 승인 후 dbmap 위임.

### 7.3 라우팅

| 항목 | 트랙 |
|------|------|
| pricing.py NON_QTY_DIMS 변경 | **개발팀 C트랙**(우리=명세·§1) |
| 흑백 INSERT·칼라 UPDATE·use_dims·옵션 | **dbmap**(dbm-load-execution·인간 승인) |
| 칼라 채움+흑백 INSERT 원자성·default 주입 | **dbm-price-arbiter 심의** + 라이브 시뮬레이터 |
| 옵션→clr_cd 주입 미연결 | **§15 quote-verify**(시뮬레이터 게이트·C-3) |
| 별색 clr_cd 통합 여부 | **후속 설계**(C-5·현행 유지) |

---

## 8. designer 큐 잔여 (design-decisions-dosu / golden-cases-dosu)

- **C-1**: 칼라 clr_cd UPDATE 212 + 흑백 INSERT 212 = **원자 적용 필수**(§6.3 ambiguous 가드·둘 다 명시값). 점진 적용 시 칼라 NULL 유지(와일드카드 무해)→마지막에 채움.
- **C-2**: 칼라 53밴드 vs 권위 56밴드 — 흑백 칼라 동형 53밴드(§26 무결성 별 이슈).
- **C-3**: 옵션→clr_cd 자동주입(option_items ref_dim=clr_cd) 라이브 작동·시뮬레이터 게이트.
- **C-4**: 흑백 판매 범위(전 디지털 ~15 vs 엽서만)·실무진.
- **C-5**: 별색 clr_cd 통합 여부(현행 proc_cd 유지 권고·후속).
- **C-6**: C트랙 엔진 변경(NON_QTY_DIMS) 회귀 테스트(vitest/가격 스위트) — 개발팀 적용 후.
