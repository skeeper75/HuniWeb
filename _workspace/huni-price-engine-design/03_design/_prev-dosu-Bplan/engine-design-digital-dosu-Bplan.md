# engine-design-digital-dosu.md — 디지털인쇄 도수(흑백/칼라) 차원축 설계

> **핵심 설계가(hpe-engine-designer) 산출.** 사용자 directive: "흑백 디지털 인쇄도 팔 계획" 확정 → 손님이 흑백을
> 선택해 정확한 흑백 단가로 견적되게 만드는 t_prc_* 그릇 설계. **새 엔진 코드 아님 — t_prc_* 데이터 그릇 + 옵션 배선 설계.**
>
> 권위[HARD]: ① 인쇄상품 가격표 `디지털인쇄비` 시트(흑백 단가 실재) > ② 라이브 t_prc_*/엔진 코드(기준선) > ③ 별색 패턴(흡수 정합).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-29 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 COMMIT/DDL은 인간 승인 후 dbmap 위임 · webadmin 코드 직접수정 금지).
> codex 2차 교차: 가용했으나 read-only 코드탐색 단계에서 미완 종료 → **Claude 단독 결론**(라이브 실측 근거로 자립·codex 미완은 design-decisions C-큐에 명기).

---

## 0. 결함 한 줄 + 설계 한 줄

- **결함**: 디지털엽서(PRF_DGP_A~F) 인쇄비 comp `COMP_PRINT_DIGITAL_S1`(212행)이 **전부 칼라(CMYK)**. 도수(흑백/칼라) 선택축이 상품에도(인쇄옵션=단/양면만·front 칼라 고정) 단가행에도(212행 전부 proc_cd=PROC_000004 칼라) 없음 → **손님이 흑백을 못 고르고 항상 칼라로 계산**(흑백 주문 시 과청구). 권위에는 흑백 단가 실재(국4절 단면 qty1=3000 vs 칼라 4000).
- **설계**: 흑백 도수를 **별색이 입증한 패턴(proc_cd 차원)**으로 인코딩 — 흑백 전용 신규 proc_cd 1개 신설 + 흑백 단가행 212개 verbatim 적재 + 기존 칼라 212행 proc_cd 무변경(이미 PROC_000004). 손님 인쇄옵션은 "도수(흑백/칼라) 택1" 추가 → 선택→proc_cd 환원.

---

## 1. ★도수 모델 결정 — A/B/C 3안 trade-off + 권고

사용자 directive의 A안(clr_cd 추가)/B안(별 comp 신설) 외에, 라이브 실측으로 드러난 **C안(proc_cd 신설)** 을 추가해 3안 비교한다. 권고는 **C안(proc_cd로 도수 인코딩·별색 패턴 정합)**.

### 1.1 엔진 계약 — clr_cd는 매칭에 안 쓰임 (★A안 무효의 결정적 근거)

라이브 코드 실측(`raw/webadmin/webadmin/catalog/pricing.py:42`):

```
NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd",
                "proc_cd", "opt_cd", "coat_side_cnt", "bdl_qty")
```

- `_row_matches`(pricing.py:94-106)·`_combo_key`(:109-111)는 **NON_QTY_DIMS 튜플만 순회**해 행↔선택값을 매칭한다.
- **`clr_cd`는 NON_QTY_DIMS에 없다.** ∴ component_prices에 clr_cd 컬럼이 있고 use_dims에 clr_cd를 등재해도 **엔진은 clr_cd로 흑백/칼라를 분기하지 않는다**(행의 clr_cd 값을 읽지 않음·`_dv_key`/dim_vals 경로도 아님).
- clr_cd로 도수를 인코딩하려면 `NON_QTY_DIMS`에 `clr_cd` 추가 = **webadmin 코드 수정(pricing.py)** = C트랙(개발팀·하네스 범위 밖·directive 금지).

→ **사용자 directive의 A안(use_dims에 clr_cd 추가)은 코드 수정 없이는 작동 불가.** A안은 "엔진이 안 보는 차원에 데이터를 넣는 것"이라 흑백 행을 넣어도 칼라/흑백 둘 다 와일드카드 통과 또는 silent 무시. 이 발견이 설계 방향을 바꾼다(돈크리티컬 가드).

### 1.2 별색이 입증한 정답 패턴 — 색/도수=proc_cd · 면=print_opt_cd

라이브 별색 단가행 실측(`COMP_PRINT_SPOT_WHITE_S1` 530행):

| 차원 | 값 | 의미 |
|------|----|----|
| comp_cd | COMP_PRINT_SPOT_WHITE_S1 (단일 comp·형제 del_yn=Y 통합) | 별색 인쇄비 |
| **proc_cd** | PROC_000008~012 (화이트/클리어/핑크/금색/은색·5종) | **색을 proc_cd로 인코딩** |
| print_opt_cd | POPT_000001(단면)·POPT_000002(양면) | 면 |
| min_qty | 53밴드 | 수량 |

→ 530 = 5색 × 2면 × 53밴드. **별색은 "색/도수는 proc_cd 차원, 면은 print_opt_cd 차원"** 으로 명확히 분리. 흑백도 "도수의 한 종류"이므로 **이 패턴을 그대로 따르는 게 정합**(별색 재설계 금지·directive 충족).

### 1.3 3안 비교표

| 기준 | **A안 (clr_cd 차원)** | **B안 (별 comp 신설)** | **C안 (proc_cd 신설) ★권고** |
|------|----------------------|------------------------|------------------------------|
| 엔진 매칭 가능 | ❌ clr_cd∉NON_QTY_DIMS → 코드 수정 필요(C트랙) | ✅ comp 단위 매칭 | ✅ proc_cd∈NON_QTY_DIMS·즉시 매칭 |
| 기존 칼라 212행 영향 | clr_cd=CLR_000005 UPDATE 필요(but 엔진 무시라 무의미) | 무변경(칼라 comp 그대로) | **무변경**(이미 proc_cd=PROC_000004) |
| 별색 패턴 정합 | ❌ 별색은 proc_cd 패턴인데 도수만 clr_cd=불일치 | △ 별색은 단일 comp인데 도수만 별 comp=불일치 | ✅ **별색과 동일 패턴**(단일 comp+proc_cd) |
| ERR_AMBIGUOUS 위험 | — (작동 안 함) | 낮음(comp 분리) but 두 comp 공식 배선 시 도수 미선택→둘 다 매칭 silent 합산 위험 | 낮음(proc_cd 판별·아래 §4) |
| webadmin 코드 수정 | **필요(금지)** | 불요 | **불요** |
| 유지보수성 | 나쁨(엔진 의미 불명) | 중(comp 2개·공식 2배선) | **좋음**(별색과 1패턴·comp 1개) |
| 단가행 규모 | 212 INSERT | 212 INSERT(새 comp) | **212 INSERT(같은 comp)** |
| 위젯 계약 | 도수→clr_cd 주입(엔진 무시) | 도수→comp 라우팅(특수) | 도수→proc_cd 주입(별색과 동일 경로) |

### 1.4 ★권고 = C안 (proc_cd로 도수 인코딩 · 별색 패턴 정합 · search-before-mint 최소 mint)

**근거 요약:**
1. **엔진 즉시 작동** — proc_cd는 NON_QTY_DIMS에 있어 코드 수정 0(A안 탈락의 거울).
2. **별색 패턴 그대로** — 색/도수=proc_cd·면=print_opt_cd. 흑백은 "도수 종류" → 새 proc_cd로 칼라(PROC_000004)와 형제. directive "별색 패턴 정합" 충족.
3. **기존 칼라 212행 무변경** — 칼라는 이미 proc_cd=PROC_000004. 흑백만 신규 proc_cd로 212행 INSERT. 칼라 행 손대지 않음(돈크리티컬 부작용 0).
4. **search-before-mint** — 신규 comp 0(같은 COMP_PRINT_DIGITAL_S1 사용)·신규 proc_cd 1개만(흑백디지털). clr_cd 코드(CLR_000002)는 인쇄옵션 colrcnt 인코딩에 재사용.
5. **single comp 유지** — 명함 variant처럼 comp를 쪼개지 않음. 한 comp(디지털인쇄비) 안에서 proc_cd 차원으로 칼라/흑백 분기 = 인쇄 도메인 현실(같은 디지털 출력기·도수만 다름) 존중.

**채택 결정**: **흑백 = COMP_PRINT_DIGITAL_S1 + 신규 proc_cd(흑백디지털) × print_opt_cd(단/양) × plt_siz_cd(국4절/3절) × min_qty**. use_dims 무변경(이미 proc_cd 포함).

---

## 2. search-before-mint — 신규 proc_cd 1개 (흑백디지털) · 그 외 0

### 2.1 재사용 확인 (mint 금지 우선)

| 필요 코드 | 재사용 가능? | 판정 |
|-----------|-------------|------|
| comp(디지털인쇄비) | COMP_PRINT_DIGITAL_S1 실재 | **재사용**(신규 0) |
| use_dims | [proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001] 실재 | **무변경**(proc_cd 이미 있음) |
| 칼라 proc_cd | PROC_000004(디지털인쇄) 실재 | **재사용**(칼라 행 그대로) |
| 면 print_opt_cd | POPT_000001/002 실재 | **재사용** |
| 도수 코드 clr_cd | CLR_000002(흑백)·CLR_000005(칼라) 실재 | **재사용**(인쇄옵션 colrcnt 인코딩용) |
| **흑백 proc_cd** | **부재**(PROC_000004 자식 없음·흑백 전용 없음) | **신규 mint 1개**(무손실 표현 불가 입증 — 칼라와 다른 도수를 같은 proc_cd로 담으면 _combo_key 충돌·구분 불가) |

### 2.2 신규 proc_cd 신설 명세 (search-before-mint 후)

- **채번**: t_proc_processes 현재 MAX=PROC_000149 → **PROC_000150**(MAX+1·separator `_`).
- **부모(upr_proc_cd)**: **PROC_000004(디지털인쇄)** — 디지털인쇄의 도수 변형. (대안: PROC_000001 직속. 단 칼라=PROC_000004가 PROC_000001 자식이므로 흑백도 형제로 PROC_000001 직속이 더 평탄. ★컨펌큐 C-1: 부모를 PROC_000004 자식 vs PROC_000001 자식 — 별색은 PROC_000007 자식이라 "도수 그룹" 부모를 따로 두는 방식. 디지털은 "디지털인쇄 칼라/흑백"이 자연 → PROC_000004 자식 권고. use_dims proc_grp:PROC_000001 매칭 영향 검증 필요 — §6.)
- **proc_nm**: `흑백` 또는 `디지털인쇄(흑백)` — 실무진 용어. 코드 노출 금지.
- **use_yn=Y · del_yn=N**.

★ **proc_grp 매칭 주의[HARD]**: COMP_PRINT_DIGITAL_S1.use_dims에 `proc_grp:PROC_000001`이 있다. 단가행 proc_cd가 PROC_000001의 **하위(descendant)**여야 그리드/매칭에 잡힌다(현재 PROC_000004는 PROC_000001 자식). 신규 흑백 proc_cd가 **PROC_000004 자식**이면 PROC_000001의 손자 → proc_grp 매칭이 손자까지 포함하는지 `price_views.py _comp_dims`·proc 트리 lookup 검증 필요(§6 컨펌큐 C-1). **안전책 = 흑백 proc_cd를 PROC_000001 직속 자식**(PROC_000004와 형제)으로 두면 칼라와 동일 depth라 확실히 매칭. → **권고: upr_proc_cd=PROC_000001**(PROC_000004와 형제·proc_grp:PROC_000001 직속 매칭 보장).

---

## 3. 흑백 단가 적재 계획 — 권위 verbatim (212행 INSERT · 칼라 행 무변경)

### 3.1 매핑 규칙 (권위 셀 → 단가행 차원)

권위: `_workspace/huni-dbmap/06_extract/price-digital-print-price-l1.csv` (인쇄상품 가격표 `디지털인쇄비` 시트).

| 권위 차원 | 단가행 차원 | 값 |
|-----------|------------|----|
| 블록 B01=국4절 | plt_siz_cd | **SIZ_000499**(국4절·라이브 실측 = 칼라 국4절 행 사용) |
| 블록 B02=3절 | plt_siz_cd | **SIZ_000077**(3절·라이브 실측) |
| 색상열 `흑백(1도)` | proc_cd | **PROC_000150**(신규 흑백디지털·§2.2) |
| 면 `단면` | print_opt_cd | **POPT_000001** |
| 면 `양면` | print_opt_cd | **POPT_000002** |
| 수량 row_key | min_qty | 그 수량값 verbatim(1,2,…,1000000) |
| 셀 값(value) | unit_price | **권위 셀값 verbatim** |
| clr_cd | clr_cd | **CLR_000002**(흑백·표시/감사용·엔진 매칭 비사용 but 별색 칼라행과 정합 위해 채움) |
| prc_typ_cd | (comp 상속) | PRICE_TYPE.01(단가형·칼라 행과 동일) |

★ **단가 verbatim[HARD]**: 계산·배수·보간 금지. 권위 셀 그대로. 예: 흑백 국4절 단면 qty1=**3000**(B4 셀), 양면 qty1=**4000**(C4), qty100 단면=**200**(B26), 3절 단면 qty1=**3500**(B64). (golden-cases-dosu.md 전수.)

### 3.2 적재 규모 (셀 수)

라이브 칼라 = 국4절(단53+양53) + 3절(단53+양53) = 212행. 권위 흑백 수량밴드 = 칼라와 **1:1 동일 53밴드**(실측 확인: 1~10,15~50,60~10000,1000000). ∴

| 블록 | 면 | 밴드 | 행수 |
|------|----|----|----|
| 국4절(SIZ_000499) | 단면 | 53 | 53 |
| 국4절 | 양면 | 53 | 53 |
| 3절(SIZ_000077) | 단면 | 53 | 53 |
| 3절 | 양면 | 53 | 53 |
| **합계** | | | **212 흑백 단가행 INSERT** |

★ **권위 vs 라이브 밴드 주의**: 권위 B01(국4절)은 표시상 56행(15/20/25 추가)이나 라이브 칼라는 53밴드로 적재됨(추출 awk 일치). 흑백도 **칼라 행과 동일 53밴드 set으로 적재**(칼라와 grid 정합·off-grid 견적 동일 동작). 권위 56행 중 라이브 미적재 3밴드는 칼라도 동일하게 빠져있으므로 **칼라 기준선과 동형**(흑백만 다르게 적재 금지). ★컨펌큐 C-2: 칼라 53밴드 vs 권위 56밴드 차이는 별도 무결성 진단(§26) 이슈 — 본 설계는 **칼라와 동형 53밴드**로 흑백 적재(흑백만 56밴드로 늘리면 칼라와 grid 불일치).

### 3.3 기존 칼라 212행 보정 (A안 시 명시였으나 C안에선 무변경)

- **C안에서는 칼라 212행 무변경**(이미 proc_cd=PROC_000004·도수 판별 충분). clr_cd NULL → CLR_000005 채우기는 **선택적**(엔진 무시·감사 일관성 목적만). 별색 칼라행이 clr_cd 빈 채로도 작동하므로 **보정 불요**(부작용 0 우선).
- ★단, 흑백 행 INSERT 후 "칼라+흑백 동시 매칭" 가드가 핵심(§4). 칼라 행 proc_cd=PROC_000004, 흑백 행 proc_cd=PROC_000150 → **proc_cd 다름 → _combo_key 다름 → 동시매칭 시 ERR_AMBIGUOUS로 안전 표면화**(silent 합산 아님). 단 정상 사용은 손님이 도수 택1 → selections.proc_cd 1개 → 한 쪽만 매칭(§4).

---

## 4. evaluate_price 호환 확인 — 도수 분기·동시매칭·기본값

### 4.1 흑백/칼라 올바른 분기 (proc_cd 자동매칭)

- 손님이 "칼라" 선택 → selections.proc_cd=PROC_000004 → `_row_matches`가 칼라 행(proc_cd=PROC_000004)만 통과·흑백 행(PROC_000150)은 `_norm(sel)!=_norm(rv)` → False 탈락. **칼라 단가만 합산.**
- 손님이 "흑백" 선택 → selections.proc_cd=PROC_000150 → 흑백 행만 통과·칼라 행 탈락. **흑백 단가만 합산.**
- `is_proc = "proc_cd" in non_qty`(:676) True → proc_sels 경로 또는 selections.proc_cd 직접 주입 둘 다 매칭(별색과 동일 메커니즘).

### 4.2 동시매칭(ERR_AMBIGUOUS) 가드

- 칼라 행·흑백 행은 **proc_cd가 다름**(PROC_000004 vs PROC_000150) → `_combo_key`(NON_QTY_DIMS 튜플) 다름. 손님이 도수 택1 → selections.proc_cd 1개 값 → cand에 한 도수 그룹만 들어옴 → combos 길이 1 → **ambiguous 없음**.
- **도수 미선택 시**(selections.proc_cd=None) → 칼라·흑백 행 둘 다 _row_matches에서 proc_cd가 NULL이 아니므로(행값 PROC_000004/150) `_norm(None)!=_norm(PROC_*)` → **둘 다 탈락 → 매칭 0건 → 인쇄비 0원 침묵**(언더차지 위험). ∴ **도수는 필수 선택(택1 mand_yn=Y)** 으로 강제해야 함(§5). 또는 default 처리(§4.3).

### 4.3 도수 미선택 시 default (CLR_000005 칼라 = 현행 동작 보존)

- 사용자 directive "도수 미선택 시 default(칼라)" → **인쇄옵션그룹에서 칼라를 dflt_yn=Y**로 두어 미선택 시 selections.proc_cd=PROC_000004(칼라) 자동 주입. 현행(전부 칼라) 동작과 동일 → **회귀 0**(기존 엽서 견적 불변).
- ★단 "0원 침묵" 회피의 진짜 가드는 **옵션→차원 주입 레이어가 도수 선택값을 proc_cd로 환원**하는 것(§5). 주입 미연결이면 default도 안 먹어 0원 → §5 배선이 선결.

### 4.4 계약 정합 체크표

| 계약(engine-contract) | C안 준수 |
|----------------------|----------|
| C7 frm_typ 미참조·공식=합산 | ✅ proc_cd 차원만 추가·공식 구조 불변 |
| P3-8 ERR_AMBIGUOUS 금지 | ✅ 칼라/흑백 proc_cd 상이·도수 택1 → combos 1개 |
| P3-DEF 판별차원 없음 금지 | ✅ proc_cd가 판별차원(NULL 아님·신규 행도 PROC_000150 채움) |
| P4-1 단가형 ×qty | ✅ 칼라 행과 동일 PRICE_TYPE.01(장당가×판수) |
| U-7 시트 차원경계 | ✅ 디지털인쇄비 시트 안(도수×면×수량×판형)에서만 배선·시트 밖 comp 침입 0 |
| search-before-mint | ✅ 신규 comp 0·신규 proc_cd 1개만(무손실 입증) |
| clr_cd 비사용 가드 | ✅ A안 무효 명문화(코드 수정 회피) |

---

## 5. 상품 도수 옵션 노출 — 손님 선택 → proc_cd 환원

### 5.1 현행 (흑백 못 고름)

프리미엄엽서(PRD_000016) 인쇄옵션그룹 `OPT_000005`("인쇄" 택1 필수) = print_options 2행(단면 opt_id=1·양면 opt_id=2)만. front_colrcnt_cd=CLR_000005(칼라) 하드코딩 → **도수 선택지 없음·proc_cd=PROC_000004 고정**.

### 5.2 설계 — 도수 택1 옵션 추가 (option_group + option_items → proc_cd 환원)

도수를 손님이 고르게 하려면 **선택값이 proc_cd 차원으로 환원**돼야 한다(엔진은 selections.proc_cd로 매칭). 두 배선안:

- **안 ① 별도 "도수" 옵션그룹**(권고·별색 패턴 정합):
  - 신규 option_group `도수`(또는 `인쇄도수`) 택1 필수(mand_yn=Y·sel_typ_cd=SEL_TYPE.01).
  - option_items 2개: `칼라(CMYK)`→ref_dim_cd=proc_cd·ref_key1=**PROC_000004**(dflt_yn=Y) / `흑백`→ref_dim_cd=proc_cd·ref_key1=**PROC_000150**.
  - 손님 선택 → option_items.ref_dim_cd/ref_key1로 selections.proc_cd 주입(옵션→차원 polymorphic 환원·[[dbmap-cpq-option-layer-mapping]]).
  - **별색과 동일 구조**(별색도 색=proc_cd 택N 옵션). 도수는 택1(흑백 or 칼라).
- **안 ② 기존 인쇄옵션(단/양면)에 도수 결합** = 단면칼라/단면흑백/양면칼라/양면흑백 4지선다. print_opt_cd는 면만 인코딩하므로 도수를 print_opt에 넣으면 §1.3 C안과 충돌(면×도수 4 POPT 신설=과설계). **비권장**(별색은 면과 색을 분리축으로 둠).

**채택 = 안 ①**(도수 별도 택1 옵션그룹·proc_cd 환원). 면(print_opt)·도수(proc_cd) 분리 = 별색 패턴·엔진 차원 분리 정합.

### 5.3 ★옵션→차원 주입 연결 (선결 과제)

- 라이브 option_items의 ref_dim_cd→selections 주입이 **현재 미연결(0행)** 일 수 있음(기존 명함 G-7·인쇄옵션 단/양면도 option_items 매핑 0행 이슈 — engine-design-digitalprint §3.2 D-2). 도수 옵션을 추가해도 **주입 레이어가 proc_cd를 selections에 넣어야** 매칭. 이 주입 경로(option_items.ref_dim_cd=proc_cd → selections.proc_cd)가 라이브에서 작동하는지 **시뮬레이터 실측 선결**(§golden-cases 검증가 재현). 미연결이면 **proc_sels 경로**(시뮬레이터 procs 파라미터)로도 주입 가능(별색이 쓰는 경로).
- **위젯 계약**: 위젯은 "도수(흑백/칼라)" 드롭다운 → 선택값을 selections.proc_cd(또는 proc_sels)로 전송. 별색·인쇄옵션과 동일 직렬화 경로(신규 계약 키 불요).

### 5.4 영향 상품 (PRF_DGP_A~F 바인딩 전수)

흑백 도수 적용 = 디지털인쇄비 comp(COMP_PRINT_DIGITAL_S1)를 쓰는 전 상품 = **PRF_DGP_A~F 바인딩 20상품**(라이브 실측). 출시분(use_yn=Y)·미출시분(use_yn=N) 구분:

| 공식 | 상품(prd_cd) | 출시 |
|------|-------------|------|
| PRF_DGP_A | 프리미엄엽서016·코팅엽서017·스탠다드엽서018·투명엽서019·화이트인쇄엽서020·종이슬로건026·스탠다드상품권041·프리미엄상품권042 | Y(8) |
| PRF_DGP_A | 핑크별색엽서021·금은별색엽서022 | N(2·미출시) |
| PRF_DGP_B | 라벨택046 | Y / 모양엽서023 | N |
| PRF_DGP_C | 인쇄배경지043/044·인쇄헤더택045 | Y(3) |
| PRF_DGP_D | 소량전단지047 | Y |
| PRF_DGP_E | 2단접지카드027·3단접지카드029 | Y(2) / 미니접지카드028 | N |
| PRF_DGP_F | 썬캡051 | N(미출시) |

→ **출시 영향 상품 ≈ 15개**(흑백 도수 옵션 추가 대상). 도수 옵션그룹은 **공식이 아니라 상품마다 추가**(option_group은 상품 종속). ★단 흑백 단가행은 comp 단위(1회 적재)라 전 상품이 공유. **상품별 작업 = 도수 옵션그룹 추가(15)·단가행은 1회**.

★ **부분 적용 가능**: 흑백을 일부 상품만 팔면(예 엽서만) 그 상품에만 도수 옵션그룹 추가. 단가행은 공유라 무해(옵션 없는 상품은 칼라 default).

---

## 6. 영향분석 · 적재 순서 · FK 위상 · 멱등

### 6.1 적재 순서 (FK 위상정렬)

```
1) t_proc_processes        : PROC_000150(흑백디지털) INSERT   ← 부모 PROC_000001 실재
2) t_prc_component_prices  : 흑백 212행 INSERT (proc_cd=PROC_000150 참조)  ← 1) 후
3) t_prd_product_option_groups : 상품별 "도수" 택1 그룹 INSERT (15상품)   ← 상품 실재
4) t_prd_product_option_items  : 칼라(PROC_000004)·흑백(PROC_000150) 2 item INSERT  ← 3)·1) 후
   (옵션→proc_cd 주입 연결 — 미연결 시 proc_sels 경로 폴백)
```

- **무변경**: COMP_PRINT_DIGITAL_S1(use_dims 그대로)·칼라 212행·PRF_DGP_* 공식·바인딩.
- **신규 mint**: proc_cd 1개(PROC_000150). comp/공식/clr_cd 신규 0.

### 6.2 멱등 (UPSERT·dryrun=BEGIN…ROLLBACK)

- proc INSERT: `ON CONFLICT(proc_cd) DO NOTHING` 또는 이름 기반 NOT EXISTS 가드.
- 단가행 INSERT: 멱등키 = (comp_cd, proc_cd, plt_siz_cd, print_opt_cd, min_qty, apply_ymd) NOT EXISTS 가드(중복 금지·`a2 NULLS DISTINCT` 함정 주의 [[dbmap-live-load-transition-260615]]).
- 옵션그룹/아이템: (prd_cd, opt_grp_cd)·(prd_cd, opt_cd, item_seq) 복합키 멱등.
- **실 COMMIT 금지** — dryrun(BEGIN…ROLLBACK)만·인간 승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution) 위임.

### 6.3 라우팅

| 항목 | 트랙 |
|------|------|
| proc_cd 신설·단가행 INSERT·옵션그룹 적재 | **dbmap**(dbm-load-execution·인간 승인) |
| proc 부모 결정(C-1)·proc_grp 손자 매칭 검증 | **dbm-price-arbiter 심의** + 라이브 시뮬레이터 실측 |
| 옵션→proc_cd 주입 미연결(option_items ref_dim) | **§15 quote-verify / dbmap CPQ**(시뮬레이터 게이트) |
| 칼라 53밴드 vs 권위 56밴드 차이 | **§26 무결성**(별 이슈·본 설계는 칼라 동형) |

---

## 7. designer 큐 잔여 (design-decisions-dosu / golden-cases-dosu 이관)

- **C-1**: 흑백 proc_cd 부모 = PROC_000001 직속(권고·칼라 형제·proc_grp 직속 매칭 보장) vs PROC_000004 자식(의미적 자연·손자 매칭 검증 필요). → 라이브 시뮬레이터 실측으로 확정.
- **C-2**: 칼라 53밴드 vs 권위 56밴드(15/20/25 일부) — 흑백은 칼라 동형 53밴드. 56밴드 보강은 §26 무결성 별도.
- **C-3**: 옵션→proc_cd 자동주입 연결 여부(option_items.ref_dim_cd=proc_cd 라이브 작동) — 미연결 시 proc_sels 폴백. 시뮬레이터 게이트.
- **C-4**: 흑백 판매 범위(전 디지털 상품 vs 엽서만) — 상품별 도수 옵션그룹 추가 범위 = 실무진 컨펌.
- **C-5**: 별색+흑백 동시(흑백 본문+별색 강조)? 현 별색은 칼라 전제 — 흑백 도수에서 별색 가산 허용 여부 = 도메인 컨펌.
