# rc2-gakmok-load-spec.md — RC-2 각목(현수막 마감봉) 적재 명세 (Q1~Q3 확정·후보 C)

> dbm-option-mapper · 2026-06-23 · §21 RC-2 각목. 라이브 읽기전용 SELECT·DB 미적재·단가 verbatim·search-before-mint·날조 0.
> 대상 = **일반현수막(PRD_000138) 각목 옵션** — CONFIRM-4 확정 후속. 메쉬현수막(139)은 가격표에 각목 옵션 없음(미적용 확정·범위 밖).
> ★사용자 확정 반영: **Q1** 손님 택1 enum 2개(각목900이하=4000 / 각목900초과=8000, 포스터사인 r249-250 verbatim) ·
>   **Q2** 세로/가로(부착 변)=가격 무관·생산정보 별도 옵션 분리 · **Q3(a)** 손님 직접 선택(데이터만 닫힘·위젯 코드 불요·자동 사이즈 판정 아님).
> 권위[HARD]: silsa-l1(260610)·인쇄상품 가격표 「포스터사인」 r249-250·라이브 t_prc_component_prices verbatim.
> 엔진[HARD]: pricing.py `_row_matches`(line82-94·NULL 차원=와일드카드·dim_vals 와일드카드 없음).
> ★생성자(option-mapper)≠검증자 — 본 명세 GO 비준은 dbm-validator 독립 게이트. 실 COMMIT은 인간 승인 후 dbm-load-execution.
> 라이브 실측 일시: 2026-06-23. 산출 위치 = `03_cpq_link/`만(04_price_engine 미수정).

---

## 0. 라이브 실측으로 확정된 기준 사실 (근거 SQL·날조 0)

### 0.1 GAKMOK comp 전수 (search-before-mint)
```sql
SELECT comp_cd, comp_nm, use_dims, prc_typ_cd, use_yn, del_yn
FROM t_prc_price_components WHERE comp_cd ILIKE '%GAKMOK%' ORDER BY comp_cd;
```
| comp_cd | comp_nm | use_dims | prc_typ | use_yn | del_yn |
|---|---|---|---|---|---|
| `COMP_POPT_BNR_GAKMOK_STR_900_4` | 추가옵션 통가격(별도 add-on 통가격·껍데기) | **NULL** | PRICE_TYPE.01 | Y | N |
| `COMP_POPT_BNR_GAKMOK_STR_900_4_GT` | 현수막 각목(900mm 초과)+끈(4개) 추가가격 | **`[]`** | PRICE_TYPE.01 | Y | N |
| `COMP_POPT_BNR_GAKMOK_STR_900_4_LE` | 현수막 각목(900mm이하)+끈(4개) 추가가격 | **`[]`** | PRICE_TYPE.01 | Y | N |

### 0.2 GAKMOK 단가행 전수 (verbatim)
```sql
SELECT comp_price_id, comp_cd, opt_cd, siz_cd, siz_width, siz_height, bdl_qty, dim_vals, min_qty, unit_price
FROM t_prc_component_prices WHERE comp_cd ILIKE '%GAKMOK%' ORDER BY comp_cd, comp_price_id;
```
| comp_price_id | comp_cd | opt_cd | 전 차원 | unit_price |
|---|---|---|---|---|
| **4698** | `..._GAKMOK_STR_900_4_LE` | NULL | 전부 NULL | **4000.00** |
| **4700** | `..._GAKMOK_STR_900_4_GT` | NULL | 전부 NULL | **8000.00** |

→ **2 comp 분리·둘 다 use_dims=`[]`·단가행 전 차원 NULL = 둘 다 always-match → 한 주문에 4000+8000=12000 이중합산**(돈크리티컬 과대청구 결함 라이브 재확인). 부모 껍데기(`_900_4`) **단가행 0건**.

### 0.3 각목 관련 옵션 전수 (138·OPV_000015/016 외 구버전 발굴)
```sql
SELECT g.opt_grp_cd, g.sel_typ_cd, g.min_sel_cnt, g.max_sel_cnt, g.mand_yn, o.opt_cd, o.opt_nm, o.dflt_yn, o.disp_seq, o.use_yn, o.del_yn
FROM t_prd_product_options o JOIN t_prd_product_option_groups g ON o.prd_cd=g.prd_cd AND o.opt_grp_cd=g.opt_grp_cd
WHERE o.prd_cd='PRD_000138' ORDER BY g.opt_grp_cd, o.disp_seq;
```
| opt_grp_cd (그룹) | opt_cd | opt_nm | dflt | disp_seq | use_yn | del_yn | 비고 |
|---|---|---|---|---|---|---|---|
| `OPT-000002` 각목추가 (SEL_TYPE.01) | OPV-000003 | 각목 - 세로폭기준 | Y | 1 | Y | **Y** | 구버전·삭제됨 |
| `OPT-000002` | OPV-000004 | 각목 - 가로폭기준 | Y | 2 | Y | **Y** | 구버전·삭제됨 |
| `OPT-000002` | OPV-000005 | 각목 - 세로폭기준 | N | 3 | Y | **Y** | 구버전·삭제됨(중복) |
| `OPT_000003` 가공 (SEL_TYPE.01·1/1·mand Y) | OPV_000006~011 | 열재단/타공4/6/8/양면테입/봉미싱 | — | 1~6 | Y | N | (각목 무관·참고) |
| `OPT_000004` **추가** (SEL_TYPE.01·**0/1**·mand **N**) | OPV_000012 | 추가없음 | **Y** | 1 | Y | N | ★현행 그룹·dflt |
| `OPT_000004` | OPV_000013 | 큐방(4개)추가 | N | 2 | Y | N | ★현행 |
| `OPT_000004` | OPV_000014 | 끈(4개)추가 | N | 3 | Y | N | ★현행 |
| `OPT_000004` | **OPV_000015** | **각목(세로)+끈(4개) 추가** | N | 4 | Y | **N** | ★현행 각목(세로) |
| `OPT_000004` | **OPV_000016** | **각목(가로)+끈(4개) 추가** | N | 5 | Y | **N** | ★현행 각목(가로) |

★구버전 `OPT-000002`(각목 세로폭/가로폭기준)는 그룹·옵션 **전부 del_yn=Y**(이미 정리됨) → 본 명세 미접촉(추가 정리 불요).

### 0.4 OPV_000015/016 option_item 환원 (★세로/가로 가격 무차별 입증)
```sql
SELECT opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty
FROM t_prd_product_option_items WHERE prd_cd='PRD_000138' AND opt_cd IN ('OPV_000015','OPV_000016');
```
| opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|---|
| OPV_000015(세로) | 1 | OPT_REF_DIM.03(자재) | **MAT_000338**(각목) | USAGE.07 | 1 |
| OPV_000015 | 2 | OPT_REF_DIM.03(자재) | MAT_000070(끈) | USAGE.07 | 4 |
| OPV_000015 | 3 | OPT_REF_DIM.04(공정) | PROC_000081(부착) | (NULL) | 4 |
| OPV_000016(가로) | 1 | OPT_REF_DIM.03(자재) | **MAT_000338**(각목) | USAGE.07 | 1 |
| OPV_000016 | 2 | OPT_REF_DIM.03(자재) | MAT_000070(끈) | USAGE.07 | 4 |
| OPV_000016 | 3 | OPT_REF_DIM.04(공정) | PROC_000081(부착) | (NULL) | 4 |

→ **세로(OPV_000015)와 가로(OPV_000016) 환원이 100% 동일**(자재 MAT_000338·MAT_000070, 공정 PROC_000081). 차원 환원으로는 세로/가로 가격을 구분하지 못함 = 세로/가로는 가격 축이 아님(Q2 확정의 라이브 증거). 가격 판별은 오직 별도 단가행(4000/8000)로만 가능.

### 0.5 차원행 138 등록 여부 (폴리모픽 트리거 `fn_chk_opt_item_ref` 통과 검증)
```sql
SELECT prd_cd, mat_cd, usage_cd, del_yn FROM t_prd_product_materials
WHERE prd_cd='PRD_000138' AND mat_cd IN ('MAT_000338','MAT_000070','MAT_000339');
SELECT prd_cd, proc_cd, del_yn FROM t_prd_product_processes WHERE prd_cd='PRD_000138' AND proc_cd='PROC_000081';
```
| 차원행 | usage_cd | del_yn | 트리거 |
|---|---|---|---|
| MAT_000070(끈) @138 | USAGE.07 | N | ✅ PASS |
| MAT_000338(각목) @138 | USAGE.07 | N | ✅ PASS |
| MAT_000339(각목900초과) @138 | USAGE.07 | **Y** | (논리삭제·어느 option_item도 안 씀=고아) |
| PROC_000081(부착) @138 | — | N | ✅ PASS |

★모델 문서(§1-3)는 MAT_000338도 del_yn=Y라 했으나(그건 t_mat_materials 글로벌 레벨), **트리거가 보는 product_materials 레벨에서 MAT_000338은 del_yn=N**(라이브 재실측). → OPV_000015/016의 기존 환원행은 **트리거 통과 상태**(재사용 안전). MAT_000339(고아)는 어느 환원도 안 가리키므로 무영향.

### 0.6 138 본체 공식 + GAKMOK 바인딩 현황
```sql
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000138';
SELECT frm_cd, comp_cd, addtn_yn, disp_seq FROM t_prc_formula_components WHERE frm_cd='PRF_POSTER_BANNER_N' ORDER BY disp_seq;
SELECT frm_cd, comp_cd FROM t_prc_formula_components WHERE comp_cd ILIKE '%GAKMOK%';  -- 0건
```
- 138 본체 공식 = **`PRF_POSTER_BANNER_N`** (단일).
- 현행 바인딩(disp_seq): 본체(1)·타공4(2)·열재단(3)·양면테입(4)·봉미싱(5)·큐방(6)·끈(7). **disp_seq MAX=7**.
- **GAKMOK comp 바인딩 0건**(미바인딩) → 각목 comp가 공식에 안 붙어 있음. 단가행은 always-match라 엔진이 comp 평가 시점에 합산하나 공식 바인딩이 없으면 evaluate_price 가산 경로 자체가 누락 — 현행 12000 이중합산은 comp가 평가 풀에 들어오는 시뮬레이터/위젯 경로에서 발현. 교정 = comp 통합 + opt_cd 충전 + **바인딩 명시**.
- 끈(STRING)·큐방(QBANG) 단가행은 직전 CONFIRM-resolved 적재로 **opt_cd 충전 완료**(STRING=OPV_000014·4000, QBANG=OPV_000013·3000) — 각목과 동일 그룹 OPT_000004 택1이라 동형 패턴 계승.

### 0.7 채번 (search-before-mint·MAX+1·충돌 0 확인)
```sql
SELECT MAX(opt_cd) FROM t_prd_product_options WHERE opt_cd ~ '^OPV_[0-9]{6}$';        -- OPV_000431
SELECT MAX(opt_grp_cd) FROM t_prd_product_option_groups WHERE opt_grp_cd ~ '^OPT_[0-9]{6}$';  -- OPT_000062
SELECT count(*) FROM t_prd_product_options WHERE opt_cd IN ('OPV_000432','OPV_000433');         -- 0
SELECT count(*) FROM t_prd_product_option_groups WHERE opt_grp_cd IN ('OPT_000063');            -- 0
```
- opt_cd MAX = **OPV_000431**(직전 족자 천정고리가 소진) → 신규 가용 = **OPV_000432, OPV_000433**.
- opt_grp_cd MAX = **OPT_000062** → 신규 가용 = **OPT_000063**.
- 베이스코드 확인: SEL_TYPE.01=단일(택1)·SEL_TYPE.02=다중·OPT_REF_DIM.03=자재·OPT_REF_DIM.04=공정 (t_cod_base_codes 실재).

---

## 1. 모델 결정 (후보 C·Q1~Q3 확정 반영)

| 결정 항목 | 확정 (사용자·도메인·경쟁사·권위 수렴) |
|---|---|
| **가격 판별 축** | **900임계(이하/초과) 2종** — opt_cd 임내 내장 enum(후보 C). 자동 사이즈 티어 아님(Q3a). |
| **comp 처리** | **2 comp(`_LE`/`_GT`) → 1 comp 통합** + use_dims=`[opt_cd, min_qty]` (모델 §6 후보 C 데이터 트랙 권고). |
| **단가행** | opt_cd 충전 2행 — 각목≤900=4000 / 각목>900=8000 (verbatim·날조 0). |
| **세로/가로** | **가격 무관 생산정보** → 별도 옵션 그룹 분리(Q2). 가격 comp/단가행 영향 0. |
| **위젯 코드** | **불요**(Q3a·후보 C는 데이터만으로 닫힘·옵션 선택→opt_cd 전송=엔진 기본 경로). |
| **메쉬현수막** | 가격표에 각목 옵션 없음 → 각목 미적용(범위 밖). |

### 1.1 후보 C가 후보 B(siz_width 자동 티어)를 배제하는 이유 (모델 §3·Q3 확정)
권위 가격표(포스터사인 r249-250)가 각목을 **"각목(900mm이하) / 각목(900mm 초과)"라는 두 개의 손님 선택 옵션 enum**으로 못박음. 후보 C는 가격표 구조 그대로(무변형). 후보 B는 이를 "엔진 자동 길이 티어"로 재해석=권위 변형 + 슬롯 뒤바뀜 오판정 위험(라이브 nonspec_width 짧은변 500~1750 ≠ 권위 가로 500~5000) + 위젯 코드 동반. Q3=(a) 손님 직접 택1 확정으로 후보 C 채택.

---

## 2. CPQ 옵션 등록표 (Q1 enum 2개 + Q2 세로/가로 + 기존 OPV_000015/016 처리)

### 2.1 ★기존 OPV_000015/016(각목 세로/가로) 처리 방안 — **재사용·재라벨**(신규 채번 회피)

후보 결정(search-before-mint·동형 최소변경):

| 방안 | 내용 | 채택 |
|---|---|---|
| (A) 신규 opt_cd 2개 채번 + 구 015/016 del_yn=Y | 가격 enum을 새로 만들고 구옵션 삭제 | ✗ 불요(015/016이 이미 OPT_000004 택1 그룹의 각목 자리·환원행 트리거 통과 상태) |
| **(B) 기존 OPV_000015/016 재라벨 → 가격 enum 2개로 전용** | 015=각목(900이하)+끈·016=각목(900초과)+끈 으로 opt_nm 교체. **세로/가로 의미는 Q2 신규 그룹으로 이관**. | ✅ **채택** |

**근거**: ① OPV_000015/016은 이미 OPT_000004(추가·택1) 그룹 안의 "각목" 자리 2개 — 가격 enum 2개와 **개수가 정확히 일치**(세로/가로 2개 ↔ 900이하/초과 2개). ② 환원행(자재·공정)이 둘 다 동일·트리거 통과 상태라 재라벨만으로 가격 판별 enum 전환 가능(신규 환원 불요). ③ 신규 채번 회피 = 동형 최소변경. **세로/가로(부착 변) 의미는 가격 무관이므로 Q2 신규 그룹(OPT_000063)으로 분리 이관**.

#### 2.1.1 OPV_000015/016 재라벨표 (opt_nm UPDATE)
| opt_cd | 현 opt_nm | → 신 opt_nm (가격표 verbatim) | dflt_yn | disp_seq | use_yn | 비고 |
|---|---|---|---|---|---|---|
| **OPV_000015** | 각목(세로)+끈(4개) 추가 | **각목(900mm이하)+끈(4개) 추가** | N | 4 | Y | 가격 판별 enum(≤900=4000) |
| **OPV_000016** | 각목(가로)+끈(4개) 추가 | **각목(900mm 초과)+끈(4개) 추가** | N | 5 | Y | 가격 판별 enum(>900=8000) |

> opt_nm = 인쇄상품 가격표 「포스터사인」 r249/r250 verbatim("각목(900mm이하)+끈(4개) 추가" / "각목(900mm 초과)+끈(4개) 추가"). 그룹(OPT_000004)·dflt·disp_seq·환원행 불변.

#### 2.1.2 OPV_000015/016 환원행 처리 (가격 무관·트리거 통과 상태 유지)
- 기존 환원행(MAT_000338 각목·MAT_000070 끈·PROC_000081 부착) **유지**(둘 다 동일·트리거 통과). 가격은 단가행 opt_cd로 판별하므로 환원행은 MES 생산정보로만 쓰임(가격 무영향).
- 단, 재라벨 후 두 옵션은 "각목 길이 구간"만 다르고 부착 변(세로/가로)은 분리됐으므로 환원행은 동일해도 의미 모순 없음(둘 다 각목+끈+부착, 길이만 다름·자재행은 길이 미구분).

### 2.2 Q2 세로/가로(부착 변) 신규 옵션 그룹 (가격 무관·생산정보)

신규 그룹 1개(OPT_000063)·신규 옵션 2개(OPV_000432·OPV_000433). search-before-mint 충족(충돌 0).

#### 2.2.1 신규 option_group
| 신규 opt_grp_cd | prd_cd | opt_grp_nm | sel_typ_cd | min_sel_cnt | max_sel_cnt | mand_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|---|---|
| **OPT_000063** | PRD_000138 | 각목 부착 변 | **SEL_TYPE.01**(택1) | 0 | 1 | **N** | **3**(기존 MAX=2) | Y |

> mand_yn=N·min_sel_cnt=0: 각목을 안 고른 손님에겐 무의미(종속) → 필수 아님. 각목 선택 시에만 의미있는 종속은 §2.2.3 제약으로 가드(선택).

#### 2.2.2 신규 option (세로/가로 2개·가격 영향 0)
| 신규 opt_cd | opt_grp_cd | opt_nm | dflt_yn | disp_seq | use_yn |
|---|---|---|---|---|---|
| **OPV_000432** | OPT_000063 | 세로변 부착(좌우) | N | 1 | Y |
| **OPV_000433** | OPT_000063 | 가로변 부착(상하) | N | 2 | Y |

> 라벨 = 레드프린팅 "상하 가로 / 좌우 양끝 세로" 도메인 참조(naming 유입 아님·후니 자체 표현). **가격 comp/단가행/공식 바인딩 영향 0** — 순수 CPQ 생산정보. 단가행 매칭에 opt_cd OPV_000432/433은 일절 안 쓰임.

#### 2.2.3 세로/가로 option_item 환원 (MES 생산정보·HOLD)
| 신규 opt_cd | 환원 가능 차원행 | option_item | 비고 |
|---|---|---|---|
| OPV_000432/433 | 부착 변은 자재/공정/사이즈 어느 차원행에도 "변 방향"으로 대응 안 됨(차원 부재) | **(HOLD — §4 HOLD-G-ITEM)** | 가격 무영향. 부착 변은 생산 메타(어느 변에 봉을 다나)로 주문 텍스트 전달. ref_param_json/생산 메타 컬럼 GAP. |

> ★[HARD] 세로/가로 환원행 HOLD = 가격·견적 무영향. 부착 변은 폴리모픽 차원에 대응 슬롯이 없음(자재·사이즈·공정 어디에도 "변 방향" 축 없음) → option_item 생략(트리거 REJECT 회피). 생산정보는 주문 메타로 전달(GAP-OPT 계열·dbm-ddl-proposer 라우팅).

### 2.3 종속 제약 (선택·각목 선택 시에만 부착 변 의미)

세로/가로(부착 변)는 **각목 옵션을 골랐을 때만 의미**가 있음(끈/큐방/추가없음 선택 시 부착 변 무의미). JSONLogic 제약으로 표현 가능:

```json
{
  "if": [
    { "in": [ {"var":"OPT_000004"}, ["OPV_000015","OPV_000016"] ] },
    true,
    { "==": [ {"var":"OPT_000063"}, null ] }
  ]
}
```
의미: OPT_000004(추가 그룹)에서 각목(015/016)을 골랐으면 OPT_000063(부착 변) 선택 허용·임의; 각목이 아니면 OPT_000063은 비어 있어야 함(부착 변 무의미). rule_typ_cd=호환성(compatible) 계열.

> ★제약은 **선택사항**(HOLD-G-CONSTRAINT). min_sel_cnt=0·mand_yn=N으로 두면 손님이 부착 변을 안 골라도 통과하므로 제약 없이도 가격·견적 정상. 부착 변을 각목 종속으로 강제하려면 위 제약 추가(가격 무영향). 실무진 결정 전 HOLD.

---

## 3. comp 배선표 (후보 C·2 comp → 1 comp 통합)

### 3.1 comp 통합 방식 (모델 §6 후보 C 데이터 트랙)

| 항목 | 현행(결함) | → 후보 C 설계 |
|---|---|---|
| comp 수 | 2 comp(`_LE` 4000·`_GT` 8000) + 부모 껍데기 | **1 comp**(`_LE` 재사용·통합 컨테이너) + 부모·`_GT` use_yn=N |
| use_dims | 둘 다 `[]`(always-add) | **`["opt_cd","min_qty"]`** (opt_cd=각목 길이 구간 판별) |
| 단가행 | `_LE`(opt NULL·4000) / `_GT`(opt NULL·8000) — 두 comp에 1행씩 | **1 comp에 2행**: opt_cd=OPV_000015·4000 / opt_cd=OPV_000016·8000 |
| 공식 바인딩 | 0건(미바인딩) | **PRF_POSTER_BANNER_N · addtn_yn=Y · disp_seq=8** |

**통합 대상 comp**: `COMP_POPT_BNR_GAKMOK_STR_900_4_LE` 를 통합 컨테이너로 재사용(comp_nm은 "현수막 각목+끈(4개) 추가가격"으로 일반화 권장). `_GT`·부모 껍데기는 use_yn=N(좀비 차단). 단가행은 `_LE` comp 아래 2행으로 모음.

> ★대안(HOLD-G-MERGE): comp 병합 대신 **2 comp 유지 + 각각 opt_cd 충전**도 always-add 해소엔 동등(직전 타공 메쉬 3 comp 유지 패턴과 동형). 본 명세 권고=1 comp 통합(모델 §6 후보 C 권고 따름·comp 정리)이나, comp 병합=가격사슬 영향이라 보수적으로 2 comp 유지(각각 opt_cd 1행)도 선택 가능 → §3.3에 양안 병기. 실무진/validator 선택.

### 3.2 배선표 (1 comp 통합 — 권고안)
| comp | 대상 frm_cd | use_dims 충전 | 단가행 충전 (단가 verbatim) | 공식 바인딩 (addtn_yn·disp_seq) | use_yn |
|---|---|---|---|---|---|
| `COMP_POPT_BNR_GAKMOK_STR_900_4_LE` (통합 컨테이너) | **PRF_POSTER_BANNER_N** | `[]` → **`["opt_cd","min_qty"]`** | comp_price 4698: opt_cd NULL→**OPV_000015**·4000(불변) + **신규 행** opt_cd=**OPV_000016**·8000 | **Y · disp_seq=8**(기존 MAX=7) | Y |
| `COMP_POPT_BNR_GAKMOK_STR_900_4_GT` | — | — | comp_price 4700(8000)을 `_LE`로 이관 후 — | (바인딩 안 함) | **N**(좀비 차단) |
| `COMP_POPT_BNR_GAKMOK_STR_900_4` (부모 껍데기) | — | — | (단가행 0건) | (바인딩 안 함) | **N**(빈 껍데기) |

**단가행 최종 상태(통합 후·`_LE` comp 아래 2행)**:
| comp_cd | opt_cd | unit_price | min_qty | 차원 |
|---|---|---|---|---|
| `..._GAKMOK_STR_900_4_LE` | **OPV_000015**(각목 900이하) | **4000.00** | NULL | opt_cd만 |
| `..._GAKMOK_STR_900_4_LE` | **OPV_000016**(각목 900초과) | **8000.00** | NULL | opt_cd만 |

> 단가 4000/8000 = 포스터사인 r249/250 verbatim·라이브 4698/4700 verbatim. **날조 0·변경 0**(comp_price 4700의 8000을 `_LE` comp로 행 이관·opt_cd 충전만).

### 3.3 ★대안 병기 — 2 comp 유지(보수적·comp 병합 회피)
comp 병합이 가격사슬 위험이라 판단되면(validator 보수안):
| comp | use_dims | 단가행 opt_cd 충전 | 바인딩 |
|---|---|---|---|
| `..._GAKMOK_STR_900_4_LE` | `["opt_cd","min_qty"]` | 4698: opt_cd=**OPV_000015**·4000 | PRF_POSTER_BANNER_N·Y·disp_seq=8 |
| `..._GAKMOK_STR_900_4_GT` | `["opt_cd","min_qty"]` | 4700: opt_cd=**OPV_000016**·8000 | PRF_POSTER_BANNER_N·Y·disp_seq=9 |
| `..._GAKMOK_STR_900_4`(부모) | — | — | use_yn=N |

> 양안 모두 always-add 해소·미선택 0가산·택1 단일매칭 동등. 차이=comp 1개냐 2개냐(컨테이너 정리 vs 최소변경). **권고=§3.2 통합**, 보수안=§3.3. dbm-validator/실무진 선택(HOLD-G-MERGE).

---

## 4. 엔진 재현 (미선택 0·각목 선택 시 정확 단가 1행·12000 이중합산 해소)

엔진 `_row_matches`(line82-94) 순수함수 재현. NON_QTY_DIMS에 opt_cd 포함·정확매칭·NULL 차원=와일드카드.

| 케이스 | 입력(selections) | 현행(결함) | 후보 C 설계후 | 판정 |
|---|---|---|---|---|
| **현행 A** | 아무 주문(각목 미선택) | `_LE`(opt NULL=와일드)·4000 + `_GT`(opt NULL=와일드)·8000 = **12000 이중합산** | — | 🔴 돈크리티컬 결함 재확인 |
| **C-1 미선택** | OPT_000004=OPV_000012(추가없음) | — | 단가행 2행 모두 opt_cd(015/016) 충전 → selections에 opt_cd 015/016 부재 → `_norm(None)≠OPV_000015` → 두 행 다 no_match → **가산 0** | ✅ 미선택 0가산 |
| **C-2 각목≤900 선택** | OPT_000004=**OPV_000015** | — | opt_cd=OPV_000015 행 1개만 매칭(OPV_000016 행=불일치) → **4000 단일 가산** | ✅ 정확 단가 1행 |
| **C-3 각목>900 선택** | OPT_000004=**OPV_000016** | — | opt_cd=OPV_000016 행 1개만 매칭 → **8000 단일 가산** | ✅ 정확 단가 1행 |
| **C-4 끈/큐방 선택** | OPT_000004=OPV_000014(끈) | — | 각목 단가행 opt_cd(015/016) 불일치 → 각목 가산 0(끈 comp만 별도 4000 가산) | ✅ 택1 그룹·각목 미가산 |
| **C-5 부착 변 선택** | OPT_000063=OPV_000432(세로변) | — | 부착 변 opt_cd는 각목 단가행 어디에도 안 쓰임 → 가격 영향 0(생산정보) | ✅ 세로/가로 가격 무관 입증 |
| ERR_AMBIGUOUS/DUPLICATE | 전 케이스 | — | 택1 그룹(OPT_000004 max=1)이라 015·016 동시선택 불가 → 두 단가행 동시매칭 0 → **12000 이중합산 원천 차단** | ✅ ERR 0 |

**결론**: 후보 C 설계는 ① 미선택 0가산(C-1) ② 각목 선택 시 길이 구간별 정확 단가 **단 1행만** 가산(C-2/3) ③ 택1 그룹이라 015·016 동시매칭 불가 → **12000 이중합산 결함 완전 해소**(C-ERR) ④ 세로/가로 가격 무관(C-5) ⑤ 단가 verbatim. 위젯 코드 불요(옵션 선택→opt_cd 전송=엔진 기본 경로).

---

## 5. FK 위상 적재순서 + 잔여 HOLD

### 5.1 적재순서 (FK 위상·멱등 — 전부 인간 승인·DB 미적재·dbm-load-execution 입력)

1. **CPQ 옵션 그룹 선행** (`t_prd_product_option_groups`): **OPT_000063**(각목 부착 변·SEL_TYPE.01·0/1·mand N·disp_seq=3) INSERT.
2. **CPQ 옵션 선행** (`t_prd_product_options`):
   - **신규** OPV_000432(세로변 부착)·OPV_000433(가로변 부착) INSERT(OPT_000063 그룹).
   - **재라벨** OPV_000015 opt_nm→"각목(900mm이하)+끈(4개) 추가"·OPV_000016 opt_nm→"각목(900mm 초과)+끈(4개) 추가" UPDATE(그룹/dflt/disp_seq 불변).
3. **option_item 환원** (`t_prd_product_option_items`): **신규 환원행 0**. OPV_000015/016 기존 환원행 유지(트리거 통과 상태). 세로/가로(432/433) 환원=HOLD-G-ITEM(차원 부재).
4. **comp use_dims 충전/정리** (`t_prc_price_components`):
   - `_LE` comp: `[]`→`["opt_cd","min_qty"]` (통합 컨테이너·IS DISTINCT FROM 가드).
   - `_GT` comp·부모 `_900_4` comp: **use_yn=N**(좀비 차단). [§3.3 보수안 채택 시 `_GT`는 use_yn=Y 유지+opt_cd 충전]
5. **단가행 충전/이관** (`t_prc_component_prices`):
   - comp_price 4698: opt_cd NULL→**OPV_000015**·4000 verbatim(UPDATE WHERE unit_price=4000 가드).
   - comp_price 4700(8000): comp_cd `_GT`→`_LE` 이관 + opt_cd→**OPV_000016**·8000 verbatim. [보수안 채택 시 4700은 `_GT` 유지+opt_cd=OPV_000016 충전만]
6. **공식 바인딩** (`t_prc_formula_components`): `_LE` 통합 comp → PRF_POSTER_BANNER_N·addtn_yn=Y·disp_seq=8 UPSERT. [보수안: `_LE`(disp8)+`_GT`(disp9) 2건]
7. **(선택) 제약** (`t_prd_product_constraints`): §2.3 부착 변 종속 제약(가격 무영향) — HOLD-G-CONSTRAINT.

### 5.2 잔여 HOLD (라이브로 못 닫은 것·정직 표기)
- **HOLD-G-MERGE (comp 1개 통합 vs 2개 유지)**: 권고=§3.2 1 comp 통합(모델 §6 후보 C·comp 컨테이너 정리). 보수안=§3.3 2 comp 유지(comp 병합 회피·직전 메쉬 타공 3 comp 패턴 동형). 양안 가격 결과 동등(always-add 해소·미선택 0·택1 단일매칭). dbm-validator/실무진 선택. **단가 verbatim·결과 무차이**.
- **HOLD-G-ITEM (세로/가로 부착 변 환원)**: 부착 변(세로/가로)은 폴리모픽 차원(자재/사이즈/공정/묶음수)에 "변 방향" 대응 슬롯 부재 → option_item 환원 불가(트리거 REJECT 회피 위해 생략). **가격·견적 무영향**(부착 변=생산 메타). 생산정보 전달은 GAP-OPT/ref_param_json 계열(dbm-ddl-proposer 라우팅).
- **HOLD-G-CONSTRAINT (부착 변 종속 제약)**: §2.3 JSONLogic 제약(각목 선택 시에만 부착 변 의미)은 선택사항. min_sel_cnt=0·mand_yn=N이라 제약 없이도 가격·견적 정상. 종속 강제 필요 시만 추가(가격 무영향). 실무진 결정 전 HOLD.
- **자재 정리(범위 밖)**: MAT_000339(각목900초과·고아·product_materials del_yn=Y)는 어느 환원행도 안 가리킴 → 무영향. 정리는 별 트랙(기초데이터·본 가격 모델 범위 밖).

### 5.3 본 명세로 닫힌 것 (GO 범위)
- ✅ **12000 이중합산 결함 해소** — 2 comp always-add → opt_cd 판별(택1 단일매칭)로 각목 선택 시 정확 단가 1행만, 미선택 0가산(§4).
- ✅ **Q1 손님 택1 enum 2개** — OPV_000015/016 재라벨(가격표 verbatim "각목900이하/초과")·신규 채번 회피(search-before-mint).
- ✅ **Q2 세로/가로 분리** — 신규 그룹 OPT_000063 + OPV_000432/433(가격 영향 0·생산정보). 가격 comp/단가행 일절 미접촉.
- ✅ **Q3(a) 데이터만 닫힘** — 옵션 선택→opt_cd 전송(엔진 기본 경로)·위젯 코드 불요·자동 사이즈 판정 없음.
- ✅ **단가 verbatim** — 4000/8000 라이브·가격표 verbatim(comp_price 4698/4700 값 불변·행 이관/opt_cd 충전만).

---

## 판정

**분석·명세까지 GO** (라이브 실측 SQL 근거 전수·단가 verbatim·search-before-mint(OPV_000432/433·OPT_000063 MAX+1·충돌 0·OPV_000015/016 재사용으로 신규 채번 최소화)·날조 0). 핵심:
① **후보 C 채택** — Q1(손님 택1 2개)·Q3a(데이터만 닫힘·코드 불요) 확정 반영. 권위 가격표 구조 그대로(무변형).
② **OPV_000015/016 재라벨** — 기존 각목 자리 2개를 가격표 verbatim 라벨(900이하/초과)로 전용·환원행 유지(트리거 통과). 신규 채번 회피.
③ **세로/가로 분리** — 신규 그룹 OPT_000063·OPV_000432/433(가격 0·생산정보). Q2 확정.
④ **12000 이중합산 해소 입증** — 택1 단일매칭으로 각목 선택 시 1행만·미선택 0·동시매칭 원천 차단(§4 C-ERR).
⑤ **HOLD 3건 정직 표기** — comp 병합 양안(MERGE)·부착 변 환원(ITEM)·종속 제약(CONSTRAINT) 전부 가격 무영향.
**DB 미적재·단가 verbatim·라이브 읽기전용 SELECT·생성자(option-mapper)≠검증자.** 본 명세 = dbm-load-builder 적재본 입력 / dbm-validator 독립 게이트 비준 대상.
