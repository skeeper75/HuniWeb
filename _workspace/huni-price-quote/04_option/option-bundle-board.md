# option-bundle-board.md — 옵션 = 자재/공정 BUNDLE 정합 보드 (요구 5)

> **Phase 2 — hpq-option-constraint-mapper (생성측)** · 2026-06-18 · `huni-price-quote`
> 파일럿: 엽서 PRD_000017 · 현수막 PRD_000138 · 아크릴 PRD_000146.
> 권위 = engine-contract.md(엔진 해석) + authority-golden.md(엑셀 가격축) + 사용자 [HARD] 옵션 정의(옵션=자재/공정 생산전달).
> 라이브 읽기전용 SELECT(2026-06-18). 판정은 검증게이트(P1~P7)가 독립 재실측. DB 미적재.
> **★결함마다 재현 SQL·심각도. R-2 판정 §3.**

---

## 0. 라이브 CPQ L2 레이어 적재 현황 (전역) — 메모리 stale 정정

| 엔티티 | 행수 (del_yn<>Y 기준 아님, 전체) | 비고 |
|--------|------|------|
| t_prd_product_option_groups | 135 | — |
| t_prd_product_options | 497 | — |
| t_prd_product_option_items | **477** | **메모리 [[dbmap-live-admin-product-viewer]](2026-06-08) "전 상품 0행"은 STALE** — round-6/Tier-A 적재 이후 477행. |
| t_prd_product_constraints | 10 | §template-constraint-board 참조 |
| t_prd_templates | 13 | base_prd_cd 바인딩 §template-board |
| t_prd_template_selections | 15 | — |
| **t_prd_template_prices** | **0** | **엔진 우선순위 1(TEMPLATE_PRICE) 라이브 미발화 — engine-contract P1 정합** |
| t_prd_product_addons | 5 | — |

```sql
-- 재현
select 'option_items',count(*) from t_prd_product_option_items
union all select 'template_prices',count(*) from t_prd_template_prices;
```

무결성 위생(전역): 고아 옵션(그룹 없는 options)=0, 고아 아이템(옵션 없는 items)=0.
```sql
select 'opt_no_grp',count(*) from t_prd_product_options o where del_yn<>'Y'
  and not exists(select 1 from t_prd_product_option_groups g where g.prd_cd=o.prd_cd and g.opt_grp_cd=o.opt_grp_cd)
union all select 'item_no_opt',count(*) from t_prd_product_option_items i where del_yn<>'Y'
  and not exists(select 1 from t_prd_product_options o where o.prd_cd=i.prd_cd and o.opt_cd=i.opt_cd);
```

---

## 1. 엽서 PRD_000017 — 옵션 BUNDLE 정합

### 1.1 옵션 구조 (라이브)
| 그룹 | 그룹명 | sel_typ | 필수 | 옵션수 | 옵션→ref_dim |
|------|--------|---------|------|--------|--------------|
| OPT_000009 | 인쇄 | SEL_TYPE.01(단일) | Y(1~1) | 2 | 단면/양면 → **.06 도수** (opt_id 1/2) |
| OPT_000010 | 종이 | 단일 | Y | 2 | 아트지250/300 → **.03 자재** (MAT_000081/082, USAGE.07) |
| OPT_000011 | 코팅 | 단일 | Y(0~1) | 3 | 유광/무광 → **.04 공정** (PROC_000014/015) |
| OPT_000012 | 모서리 | 단일 | N(0~1) | 2 | 직각/둥근 → **.04 공정** (PROC_000027/028) |

- 자재/공정 분해: 종이=순수 자재(.03), 코팅·모서리=순수 공정(.04), 인쇄=도수(.06). **자재+공정 묶음(BUNDLE) 없음** — 엽서는 단일의미 옵션만 → 사용자 BUNDLE 모델 위반 아님. ✓

### 1.2 트리거 무결성 (fn_chk_opt_item_ref)
- `.06` 도수 ref_key1=1/2 → t_prd_product_print_options(opt_id 1/2) **존재** ✓ → 트리거 PASS.
- `.03` 자재 ref_key1=MAT_000081/082, ref_key2=USAGE.07 → 자재링크 가정(PASS, 미반증).
- `.04` 공정 → 공정링크 가정(PASS).
- **결함 없음(트리거 차원)**. 트리거는 "차원행 존재"만 검사 — 가격 배선 정합은 검사 못 함(§1.3).

### 1.3 ★결함 EOP-1 [HIGH] — 인쇄(도수) 옵션이 가격에 미반영 (R-2 구체 사례)
- **증상**: 인쇄 그룹(단면/양면)이 `.06`로 풀리는데, `_opt_maps`(price_views.py:1169-1183)는 **`.06`을 가격차원에 매핑하지 않고 생략**(코드 주석 ":1171 도수/셋트는 현 가격차원 직접매핑 없음"). → 선택값이 `selections`에 안 들어감.
- **그런데** 엽서 인쇄비 component `COMP_PRINT_DIGITAL_S1/S2`의 use_dims = `[proc_cd, plt_siz_cd/siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]` → **`print_opt_cd`로 단/양면 구분**. 옵션이 `print_opt_cd`를 못 채우므로 단면 vs 양면 인쇄비를 선택으로 가를 수 없다.
- **함의**: 옵션 UI는 단/양면을 보여주나 가격엔진은 그 선택을 무시 → 침묵 0원 또는 ERR_AMBIGUOUS(print_opt_cd NULL-선택에 두 행 매칭). engine-contract C4/R-4.
- **재현 SQL**:
```sql
select fc.comp_cd, pc.use_dims::text from t_prd_product_price_formulas pf
  join t_prc_formula_components fc on fc.frm_cd=pf.frm_cd
  join t_prc_price_components pc on pc.comp_cd=fc.comp_cd
where pf.prd_cd='PRD_000017' and pc.comp_nm like '%인쇄%';
-- use_dims에 print_opt_cd 있음 ↔ option_items .06은 _opt_maps에서 미해석
select ref_dim_cd,count(*) from t_prd_product_option_items where prd_cd='PRD_000017' and ref_dim_cd='OPT_REF_DIM.06';
```
- **권위 정답**: 엑셀 가격축([authority-golden §1.1] 인쇄 도수/면=인쇄비 단가행 열 선택) — 단/양면은 **가격축**. 따라서 인쇄 옵션은 `.06`(미배선)이 아니라 `print_opt_cd`(또는 도수 차원을 가격에 잇는 배선)로 풀려야 함.
- **라우팅**: 옵션→차원 해석 규칙 결함(option-layer 내 R-2). 동시에 `_opt_maps`가 `.06`을 버리는 게 의도면, 도수는 raw `print_opt_cd` 드롭다운으로 별도 노출돼야 함(현재 그 드롭다운이 옵션그룹에 흡수돼 숨겨지는지 확인 필요 → CONFIRM-EOP1).

### 1.4 ★결함 EOP-2 [HIGH] — 코팅 옵션(.04 공정)이 코팅 component 차원과 불일치 (R-2)
- **증상**: 코팅 그룹(유광/무광)이 `.04 공정`(PROC_000014/015)으로 풀려 `_opt_maps`가 `procs=[PROC_000014]` 추가. 그러나 코팅 component `COMP_COAT_GLOSSY/MATTE` use_dims = `[siz_cd, coat_side_cnt, min_qty]` — **proc_cd 차원이 없다**(공정 component 아님 → `_evaluate_formula` else 분기, proc_sels 무관).
  - 코팅 component가 필요로 하는 `coat_side_cnt`(1/2)를 **어느 옵션도 설정하지 않음**.
  - `siz_cd`만 매칭 → COMP_COAT_GLOSSY·COMP_COAT_MATTE **둘 다 매칭** + coat_side_cnt NULL-선택 → 단/양면 행 동시매칭 → **ERR_AMBIGUOUS**(engine-contract C4) 또는 strict ok=False.
- **재현 SQL**:
```sql
select comp_cd,proc_cd,siz_cd,coat_side_cnt,unit_price
from t_prc_component_prices where comp_cd in ('COMP_COAT_GLOSSY','COMP_COAT_MATTE') limit 6;
-- proc_cd NULL, 구분축=coat_side_cnt. 옵션은 .04로 proc_cd만 보냄(coat_side_cnt 미설정)
select oi.opt_cd,op.opt_nm,oi.ref_dim_cd,oi.ref_key1
from t_prd_product_option_items oi join t_prd_product_options op
  on op.prd_cd=oi.prd_cd and op.opt_cd=oi.opt_cd
where oi.prd_cd='PRD_000017' and op.opt_grp_cd='OPT_000011';
```
- **권위 정답**: [authority-golden §1.1] 코팅 = 코팅타입(무광/유광)×면수 → 코팅비 단가행 열. 코팅 옵션은 `coat_side_cnt`(+유광/무광 구분축)로 풀려야 component와 맞는다.
- **라우팅**: 옵션→차원 해석 + component 차원설계 불일치. option-layer(.04 오선택) ↔ price-chain(coat comp가 proc_cd가 아닌 coat_side_cnt 사용) **경계**. chain-inspector 공유(SendMessage 로그됨).

---

## 2. 현수막 PRD_000138 — 옵션 BUNDLE 정합 (BUNDLE 모범 + 가격 단절)

### 2.1 옵션 구조 (라이브)
| 그룹 | 그룹명 | 상태 | 옵션→item 구성 |
|------|--------|------|----------------|
| **OPT-000002** | 각목추가 | **del_yn=Y(논리삭제)** | 레거시. **코드 separator `OPT-`(하이픈)** — 정책 `_`(언더스코어) 위반 잔재 |
| OPT_000003 | 가공 | 활성(필수 1~1) | 열재단/타공(4/6/8)/양면테입/봉미싱 |
| OPT_000004 | 추가 | 활성(0~1) | 큐방/끈/각목(세로)+끈/각목(가로)+끈 |

### 2.2 BUNDLE 분해 (사용자 [HARD] 모델 — 자재+공정 묶음) ✓
| 옵션 | item_seq 구성 | 판정 |
|------|---------------|------|
| 열재단 OPV_000006 | .04 PROC_000084 | 순수공정(천절단) ✓ |
| 타공 OPV_000007/8/9 | .04 PROC_000079 ×3 | 순수공정(bare-hole) — **구수 미구분, §2.3 결함** |
| 양면테입 OPV_000010 | seq1 .03 MAT_000069 + seq2 .04 PROC_000081 | **자재+공정 BUNDLE** ✓ |
| 봉미싱 OPV_000011 | seq1 .03 MAT_000340 + seq2 .04 PROC_000080 | **BUNDLE** ✓ |
| 큐방 OPV_000013 | seq1 .03 MAT_000337(qty4) + seq2 .04 PROC_000081(qty4) | **BUNDLE** ✓ |
| 끈 OPV_000014 | seq1 .03 MAT_000070(qty4) + seq2 .04 PROC_000081(qty4) | **BUNDLE** ✓ |
| 각목(세로)+끈 OPV_000015 | seq1 .03 MAT_000338 + seq2 .03 MAT_000070(qty4) + seq3 .04 PROC_000081(qty4) | **자재2+공정1 BUNDLE** ✓ ([[dbmap-option-material-process-bundle]] 모델 정확 재현) |
| 각목(가로)+끈 OPV_000016 | 동일 (각목 방향만 다름) | BUNDLE ✓ |

- **트리거 무결성**: 자재 MAT_000069/070/337/338/340 전부 t_prd_product_materials(PRD_000138, USAGE.07) **존재** → fn_chk_opt_item_ref PASS ✓.
```sql
select mat_cd,usage_cd from t_prd_product_materials where prd_cd='PRD_000138'
  and mat_cd in ('MAT_000069','MAT_000340','MAT_000337','MAT_000070','MAT_000338');
```
- **BUNDLE 모델 자체는 정확** — 주문접수(옵션) + 생산 BOM(자재+공정) 둘 다 성립. 사용자 정의 충족.

### 2.3 ★결함 EOP-3 [HIGH] — 현수막 가공/추가 옵션 전부 가격 component 부재 (침묵 0원)
- **증상**: 현수막 공식 `PRF_POSTER_BANNER_N` 구성요소 = 본체면적(COMP_POSTER_BANNER_NORMAL) + 오시(029) + 귀돌이(026) + 가변(085) + 별색(007) + 미싱(030). **타공(PROC_000079)·열재단(PROC_000084)·부착(PROC_000081)·봉미싱(PROC_000080) component = 0개.**
- 옵션 선택 시 `_opt_maps`가 proc_cd를 proc_sels에 넣어도 → 매칭 component 없음 → engine P2-2 자연제외 → **침묵 0원**(가공비 미청구). lenient면 0원, strict도 경고 없이 빠짐(매칭 0건은 그 comp만 제외).
- **재현 SQL**:
```sql
select count(*) from t_prc_formula_components fc join t_prc_price_components pc on pc.comp_cd=fc.comp_cd
where fc.frm_cd='PRF_POSTER_BANNER_N'
  and (pc.comp_nm like any (array['%타공%','%부착%','%열재단%','%봉미싱%','%큐방%','%각목%','%끈%']));
-- = 0
```
- **권위 정답**: [authority-golden §2] + [authority-gaps Q-LINEN-FINISH 류] 가공은 후가공비 가산. 옵션은 적재됐으나 **가격사슬(공식 component) 부재**.
- **라우팅**: **경계** — 옵션 레이어(내 담당, 적재 정확) ↔ 가격사슬 component 커버리지(chain-inspector). SendMessage 공유됨. dbmap 메모리 [[dbmap-price-chain-dwire-per-product-formula]] 류 결함과 동근.

### 2.4 ★결함 EOP-4 [MEDIUM] — 타공 구수(4/6/8) 판별 소실
- 타공 OPV_000007/8/9가 **동일 PROC_000079 + dtl_opt NULL** → 4개/6개/8개 구분이 가격축·생산지시 어디에도 없음(opt_nm 텍스트만). 구수는 가격·생산 차이를 낳음(천공 작업량). `dtl_opt {"개수":N}` 또는 proc detail로 보존돼야(§process-json-report 상세).
- **재현**: §1.4 위 현수막 item 덤프에서 OPV_000007/8/9 ref_key1=PROC_000079 동일, dtl_opt 공란.

### 2.5 결함 EOP-5 [LOW] — 레거시 그룹 코드 위생
- OPT-000002(하이픈) 논리삭제 그룹 잔존 + min/max NULL. 코드 separator 정책(`_`) 위반. price_views가 del_yn='Y' 제외하므로 런타임 무해, 위생/혼동 리스크만.

---

## 3. ★★ R-2 판정 — 옵션 매칭 단위: 옵션코드 vs ref_dim 차원풀이

**질문(engine-contract R-2 / widget-contract §6)**: 옵션 선택의 가격매칭 단위가 "옵션코드(opt_cd)만"인가, 아니면 "ref_dim_cd로 차원 풀이"인가?

**판정 = ref_dim 차원풀이가 라이브 진실. 그리고 그 풀이는 불완전(7종 중 4종만 가격에 연결).**

- **근거 (소스)**: `price_views.py:_opt_maps`(1169-1183)가 option_item.ref_dim_cd를 보고 가격차원으로 변환:
  - `.01`→siz_cd, `.02`→plt_siz_cd, `.03`→mat_cd, `.05`→bdl_qty, `.04`→proc_sels.proc_cd.
  - **`.06`(도수)·`.07`(셋트)는 변환 생략**(:1171 주석 "현 가격차원 직접매핑 없음").
- **근거 (데이터, 파일럿)**:
  - 엽서 인쇄=`.06` → 미해석 → 인쇄비 component의 `print_opt_cd` 미충족 (EOP-1).
  - 엽서 코팅=`.04` proc → 코팅 component는 `coat_side_cnt` 사용(proc_cd 아님) → 옵션 차원 ≠ component 차원 (EOP-2).
  - 현수막 가공=`.04` proc → component 자체 부재 (EOP-3).
- **결론**:
  1. CONTEXT(:21)의 "옵션 매칭 단위=옵션코드만" **의도는 라이브 미구현**. 라이브는 ref_dim 차원풀이.
  2. 차원풀이조차 **불완전**: `.06/.07` 미연결 + `.04`가 코팅처럼 proc_cd 아닌 차원을 쓰는 component와 어긋남.
  3. → **옵션 선택이 가격에 도달하지 못하는 경로가 파일럿 3상품군 중 2(엽서·현수막)에서 실재.** 위젯이 strict면 ok=False/0원 차단(R-1), lenient면 침묵 0원·과소청구.
- **권위 정답**: 옵션→가격은 **옵션이 실제로 바꾸는 가격축(authority-golden 가격축)**으로 풀려야 한다. 즉 도수→print_opt_cd, 코팅→coat_side_cnt(+유무광), 가공→(component 신설 후) proc_cd. 현 ref_dim 매핑표가 가격축과 1:1이 아닌 게 근본결함.
- **라우팅**: option-layer 해석규칙(`_opt_maps` 확장 or 옵션 모델 재설계) + price-chain component 차원 정합. **양측 합동 교정 필요** — 검증게이트가 R-2를 "라이브=ref_dim 풀이·불완전" 으로 비준 권고.

---

## 4. 아크릴 PRD_000146 — 옵션 레이어 전무 (GAP)

- **CPQ L2 = 0행** (option_groups/options/items 전부 0). 그러나 차원은 적재: sizes 8·materials 3·processes 1·price_formula 1.
```sql
select 'opt_groups',count(*) from t_prd_product_option_groups where prd_cd='PRD_000146'
union all select 'sizes',count(*) from t_prd_product_sizes where prd_cd='PRD_000146'
union all select 'addons',count(*) from t_prd_product_addons where prd_cd='PRD_000146';
```
- **권위 정답**: [authority-golden §3.1] 아크릴 후가공 옵션 = 키링/뱃지/마그넷/집게/명찰/스마트톡/지비츠/볼펜/머리끈/카라비너 (제작수량당 가산). 두께(투명3T/1.5T/미러)=소재축.
- **GAP-ACR-OPT [HIGH]**: 후가공 옵션·두께 선택 옵션이 **그릇 부재가 아니라 미적재**(option_groups 테이블 실재, 데이터 0). round-23/아크릴 트랙 BLOCKED와 정합([[dbmap-acrylic-price-chain-link]] — .02 엔진계약·미러 바인딩 미해소).
- **라우팅**: 미적재(생성 필요) — dbmap CPQ 옵션 적재 트랙. 본 하네스는 갭 기록까지.

---

## 5. 결함 요약 (검증게이트 인계)

| ID | 상품 | 결함 | 심각도 | 분류 | 라우팅 |
|----|------|------|:--:|------|--------|
| EOP-1 | 엽서 | 인쇄(도수 .06) 가격 미반영 — _opt_maps 미해석 vs print_opt_cd | HIGH | R-2/배선 | 옵션해석규칙 + chain |
| EOP-2 | 엽서 | 코팅(.04 proc) ↔ coat comp(coat_side_cnt) 차원 불일치 → ERR_AMBIGUOUS | HIGH | R-2/경계 | 옵션모델 + chain |
| EOP-3 | 현수막 | 가공/추가 옵션 전부 component 부재 → 침묵 0원 | HIGH | 경계(가격사슬) | **chain-inspector** |
| EOP-4 | 현수막 | 타공 구수(4/6/8) 판별 소실(동일 proc·dtl_opt NULL) | MEDIUM | 공정상세 | 옵션 dtl_opt + component |
| EOP-5 | 현수막 | 레거시 그룹 OPT-000002 하이픈·논리삭제 잔재 | LOW | 위생 | 정리 |
| GAP-ACR-OPT | 아크릴 | CPQ 옵션 레이어 전무(후가공·두께 미적재) | HIGH | 미적재 | dbmap 적재 |
| CONFIRM-EOP1 | 엽서 | `.06` 미배선이 의도면 도수는 raw print_opt_cd 드롭다운으로 노출되는가? | — | 확인 | 라이브 admin 재캡처 |

> **R-2 한 줄**: 라이브는 옵션을 ref_dim 차원으로 풀지만(코드 매칭 아님), 그 풀이가 **7종 중 4종만 가격에 연결**되고 `.04/.06`이 실제 가격 component 차원과 어긋나 — 파일럿 2/3에서 옵션 선택이 가격에 도달 못 함. CONTEXT "옵션코드만" 의도는 미구현.
