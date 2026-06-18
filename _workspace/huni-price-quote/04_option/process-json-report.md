# process-json-report.md — 공정 상세 json (dim_vals · proc_sels · prcs_dtl_opt) 정합 보고 (요구 6)

> **Phase 2 — hpq-option-constraint-mapper (생성측)** · 2026-06-18 · `huni-price-quote`
> 권위 = engine-contract(P3-3 dim_vals 정확매칭·P8-1 proc_sels 다중평가) + widget-contract(W-8/W-9) + 라이브 t_proc_processes.prcs_dtl_opt.
> 라이브 읽기전용(2026-06-18). DB 미적재. 판정은 검증게이트 독립 재실측.

---

## 0. 공정 상세 json 3-홉 사슬 (검증의 자)

사용자 요구 6 = "공정은 다양한 상세옵션 → json으로 넣을 수 있게 설계". 라이브 실제 흐름:

```
[정의] t_proc_processes.prcs_dtl_opt.inputs   (공정별 상세입력 스펙: key/type/unit/values, 부모공정 상속)
   │   price_views.py:proc_detail_inputs(:79-95)  — 자기 우선, 없으면 upr_proc_cd 상속
   ▼
[선택] proc_sels = [{proc_cd, detail:{key:value}}]   (위젯/시뮬 입력)
   │   price_views.py:price_simulate(:1285-1294) — detail 키=inputs.key
   │   option_items.dtl_opt {key:value}  (옵션이 공정상세를 미리 박는 경우)
   ▼
[매칭] component_prices.dim_vals {key:value}   (단가행의 공정상세 파라미터)
       pricing.py:_evaluate_formula(:462-471) detail를 sel에 병합 →
       _row_matches(:87-89) dim_vals 키 ⟺ sel 키 **정확매칭(와일드카드 없음, P3-3)**
```

**정합 = 세 곳의 key가 동일해야** 공정상세가 가격에 도달한다. 어느 한 홉이라도 key 누락/불일치면 침묵 0원 또는 ERR_AMBIGUOUS.

---

## 1. 라이브 prcs_dtl_opt 정의 (공정별 상세입력 스펙)

```sql
select proc_cd,proc_nm,upr_proc_cd,prcs_dtl_opt::text from t_proc_processes
where prcs_dtl_opt is not null and prcs_dtl_opt::text<>'{}' order by proc_cd;
```

| proc_cd | 공정 | 상세입력 key | 타입 |
|---------|------|-------------|------|
| PROC_000029 | 오시 | **줄수** (0~3 줄) | integer |
| PROC_000030 | 미싱 | **줄수** (0~3 줄) | integer |
| PROC_000079 | 타공 | **구수** (1~8 개) | integer |
| PROC_000080 | 봉제 | **유형**(enum 5종) + **폭**(mm) | enum+number |
| PROC_000081 | 부착 | **대상**(enum 라벨/맥세이프/끈/테입) | enum |
| PROC_000085 | 가변데이타 | **개수** (0~3 개) | integer (→ 자식 PROC_000031 가변텍스트/032 가변이미지 상속) |
| PROC_000084 | 열재단 | (없음) | — |

→ **그릇·정의는 풍부**(요구 6 충족 설계 실재). prcs_dtl_opt.inputs가 json으로 공정상세를 표현.

---

## 2. dim_vals 실사용 (단가행의 공정상세)

```sql
select comp_cd, count(*) filter (where dim_vals is not null and dim_vals::text<>'{}') with_dimvals
from t_prc_component_prices group by comp_cd having ... ;
select distinct dim_vals::text from t_prc_component_prices where dim_vals::text<>'{}';
-- 결과 key 종류: {"줄수":N} · {"개수":N}
```

| component | dim_vals key | 매칭 proc inputs.key | 정합 |
|-----------|-------------|---------------------|:--:|
| COMP_PP_CREASE_1L/2L/3L (오시) | `줄수` | PROC_000029 `줄수` | ✓ |
| COMP_PP_PERF_1L (미싱) | `줄수` | PROC_000030 `줄수` | ✓ |
| COMP_PP_VARTEXT_1~3EA (가변텍스트) | `개수` | PROC_000085 `개수`(상속) | ✓ |
| COMP_PP_VARIMG_1~3EA (가변이미지) | `개수` | PROC_000085 `개수` | ✓ |

- **가변텍스트 골든 (P3-3 검증)**: `COMP_PP_VARTEXT_1EA` proc_cd=PROC_000031, dim_vals `{"개수":1}`=15000 / `{"개수":2}`=20000 / `{"개수":3}`=25000(min_qty=1) → 위젯이 `detail={"개수":2}` 보내면 정확매칭 20000. ✓ **3-홉 사슬 완결 사례.**
```sql
select comp_cd,proc_cd,dim_vals::text,min_qty,unit_price from t_prc_component_prices
where comp_cd='COMP_PP_VARTEXT_1EA' order by min_qty,unit_price;
```

→ **오시·미싱·가변 = 공정상세 json 정합 모범**(key 3곳 일치, P3-3 통과).

---

## 3. ★결함 — 공정상세 json 단절 (파일럿)

### 3.1 EPJ-1 [HIGH] — 린넨 봉제 마감유형이 dim_vals로 흐르지 못함 (린넨 PRD_000124)
- 정의: PROC_000080 봉제 inputs = `유형`(enum 오버로크/오버로크+리본끈/말아박기/말아박기+면끈/봉미싱(7cm)) + `폭`(mm). ✓ 정의 충분.
- 선택: 옵션 dtl_opt가 **정확히 그 key로 박혀 있음** — `{"유형":"오버로크"}`, `{"폭":7.0,"유형":"봉미싱(7cm)"}` 등 5행. ✓
```sql
select prd_cd,opt_cd,item_seq,dtl_opt::text from t_prd_product_option_items
where dtl_opt is not null and del_yn<>'Y';  -- 전부 PRD_000124, key=유형/폭
```
- 매칭: 그러나 component `COMP_POSTEROPT_LINEN_FINISH`의 **dim_vals = 전행 NULL/공란**. 단가행 5개가 unit_price(0/800/1000/2000/2000)만 다르고 **판별 dim_vals 없음**.
```sql
select comp_cd,proc_cd,dim_vals::text,unit_price,min_qty from t_prc_component_prices
where comp_cd='COMP_POSTEROPT_LINEN_FINISH' order by unit_price;  -- dim_vals 전부 공란
```
- **결과**: detail `{"유형":"말아박기"}` 보내도 dim_vals에 `유형` key가 없어 → `_row_matches` 기준 **5행 전부 통과(판별차원 없음, P3-DEF/C2)** → combo_key 동일 5행 동시매칭 = **ERR_AMBIGUOUS(C4)** 또는 strict ok=False. 마감유형별 단가(800/1000/2000) 선택 불가.
- **권위 정답**: 마감유형이 가격을 바꾸므로(authority-gaps Q-LINEN-FINISH) component 단가행에 `dim_vals={"유형":"오버로크"}` 식으로 판별 박혀야 함. **3홉 중 [매칭] 홉의 dim_vals 누락**이 근본.
- **라우팅**: 단가행 dim_vals 적재(가격사슬). 정의·선택은 정확 → **chain-inspector 경계**(component dim_vals 보강). SendMessage 공유됨.

### 3.2 EPJ-2 [MEDIUM] — 현수막 타공 구수(구수) 미전달 (현수막 PRD_000138)
- 정의: PROC_000079 타공 inputs = `구수`(1~8 개). ✓ 정의 충분.
- 선택: 그러나 옵션 OPV_000007/8/9(타공 4/6/8개)가 **동일 PROC_000079 + dtl_opt NULL** → 구수 4/6/8이 어디에도 안 실림(opt_nm 텍스트만). `_opt_maps`는 proc_cd만 append, detail 없음.
```sql
select opt_cd,item_seq,ref_key1,dtl_opt::text from t_prd_product_option_items
where prd_cd='PRD_000138' and ref_key1='PROC_000079';  -- 3행, dtl_opt 전부 공란
```
- 매칭: 게다가 현수막 공식 PRF_POSTER_BANNER_N에 **타공 component 자체 부재**(option-bundle-board EOP-3) → 구수 이전에 타공비 0원.
- **결과**: 타공 4/6/8개가 가격·생산지시 동일(구분 소실). 천공 작업량 차이 미반영.
- **권위 정답**: 옵션이 구수를 박으려면 ① dtl_opt `{"구수":4}` 또는 ② proc detail로 위젯이 전달 + ③ 타공 component 신설(dim_vals `{"구수":N}`). **3홉 중 [선택]·[매칭] 동시 결손.**
- **라우팅**: 옵션 dtl_opt 적재(내 담당) + 타공 component 신설(chain). 합동.

### 3.3 EPJ-3 [LOW] — 부착(PROC_000081) 대상 enum 미활용
- 정의: PROC_000081 부착 inputs = `대상`(라벨/맥세이프/끈/테입). 현수막 BUNDLE(양면테입/큐방/끈/각목)이 전부 PROC_000081로 풀리나 dtl_opt에 `대상` 미기재 → 부착 종류 구분이 자재(mat_cd)로만 표현됨. component 부재(EOP-3)라 현재 무영향이나, 부착 component 신설 시 `대상` 판별 필요.

---

## 4. proc_sels 다중공정 평가 정합 (P8-1)

- 엔진 `_evaluate_formula`(:462-471): proc 차원(use_dims에 `proc_cd`) component를 proc_sels 각 공정마다 개별평가, detail을 sel에 병합. ✓ 코드 정합.
- 현수막 공식의 proc component(오시 029·귀돌이 026·가변 085·미싱 030·별색 007)는 proc_grp로 묶여 정상 다중평가. 단 **옵션이 거는 공정(타공/부착/열재단/봉미싱)은 component 부재**라 proc_sels에 넣어도 무매칭(P2-2 자연제외).
- **검증 함의**: proc_sels 메커니즘 자체는 건전. 결함은 데이터(component·dim_vals) 측. 엔진 분기 결함 아님.

---

## 5. 결함 요약 (검증게이트 인계)

| ID | 대상 | 결함 | 심각도 | 단절 홉 | 라우팅 |
|----|------|------|:--:|--------|--------|
| EPJ-1 | 린넨 PRD_000124 | 봉제 마감유형 dtl_opt(유형/폭) ↔ component dim_vals 전행 NULL → ERR_AMBIGUOUS | HIGH | [매칭] | chain (dim_vals 적재) |
| EPJ-2 | 현수막 PRD_000138 | 타공 구수(4/6/8) dtl_opt 미박힘 + 타공 component 부재 | MEDIUM | [선택]+[매칭] | 옵션 dtl_opt + chain |
| EPJ-3 | 현수막 | 부착 `대상` enum 미활용(현재 무영향) | LOW | [선택] | 보강 |

> **공정상세 json 한 줄**: 정의(prcs_dtl_opt.inputs)·엔진(proc_sels→dim_vals 정확매칭)은 **건전**, 모범(오시·미싱·가변=key 3곳 일치 ✓). 결함은 **단가행 dim_vals 누락(린넨)·옵션 dtl_opt 미박힘(현수막 타공)**으로 공정상세가 가격에 도달 못 하는 데이터 단절. key 네이밍 규약(줄수/개수/구수/유형/폭/대상)은 정의↔dtl_opt 간 일관 — dim_vals 측만 비어 있음.

---

## 부록. chain-inspector 경계 공유 (SendMessage 로그)

옵션선택이 가격 component에 도달 못 하는 3건(엽서 인쇄→print_opt_cd 미배선·엽서 코팅→coat_side_cnt 미배선·현수막 가공→component 부재)과 본 보고 EPJ-1/2(dim_vals 누락)는 **옵션레이어(내 담당) ↔ 가격사슬 component 커버리지(chain-inspector 담당) 경계**. 각 결함에 재현 SQL 동반 → 검증게이트가 독립 재실측 가능.
