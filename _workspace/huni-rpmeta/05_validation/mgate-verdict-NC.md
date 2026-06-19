# M-Gate Verdict — NC ([옵셋] 명함·카드·쿠폰·포토카드)

> rpm-validator. Phase 6 경계 교차검증(생성자 주장 비신뢰·직접 재실측).
> 11번째 카테고리. **핵심 프로브 = 인쇄방식(옵셋 vs 디지털)이 distinct #18인가 → 부결(=이미 #12)** 재검.
> 라이브 = Railway `railway` 읽기전용 SELECT(2026-06-19). 캡처 = `categories/NC/captures/nc_cap_*.json`(retCode 200).
> 판정: **GO**(결함 0·재현됨) / **NO-GO**(단일 substantiated 결함) / **CONDITIONAL**(미검증분).

---

## 한눈에 — 전건 GO

| Gate | 판정 | 핵심 |
|---|:---:|---|
| **M1** 추출 충실성 | **GO** | NCDFDFT/FLD/PHO 핵심 원자 전건 capture 재현(item_gbn/price_gbn 토큰·이산 tier null 슬롯·exp_prn populated·접지 SKU·오시). 미캡처 2종은 honest unobserved. |
| **M2** 메타모델 정합 | **GO** | N-1~N-5 전부 17축 facet 귀속·오버피팅 0·인쇄방식=#12(D-7) 무모순. |
| **M3** distinct 타당성 | **GO** | 인쇄방식 #18 부결=옳음. ①전용슬롯 부재 ②KB결함 부재 둘 다 라이브 재검 확정. 과소강등 아님. |
| **M4** 갭 판정 정확 | **GO** | NC 4 facet + N-5 판정이 라이브 information_schema 전건 일치(재실측 11건). |
| **M5** vessel 건전성 | **GO** | NC 신규 그릇 0·search-before-mint 통과·V-1~V-12 불변·N-2 이산 tier=data-gap. |
| **M6** 생성-검증 독립성 | **GO** | self-approve 0·핵심 주장 재유도. dodge-hunt 3건 모두 깨지지 않음. |

---

## M1 — 추출 충실성 · **GO**

캡처 원본을 직접 재읽기(grep)해 reverse 원자와 field-for-field 대조.

| reverse 원자 (file:line) | 재측정 (capture) | 일치 |
|---|---|:---:|
| §1 `item_gbn: offset2023_item · price_gbn: offset2023_price` (reverse.md:76) | nc_cap_NCDFDFT.json: `offset2023_item`×1·`offset2023_price`×1 | ✅ |
| §0.2 옵셋 prn_cnt = FIR/INC/INC_STEP/MIN 전부 **null**·DFT 500 (reverse.md:54) | NCDFDFT: `FIR_CNT:null·INC_CNT:null·INC_STEP:null·MIN_PRN_CNT:null·DFT_PRN_CNT:500·REAM_CNT:0` | ✅ |
| §0.2 `pdt_exp_prn_cnt_info` **populated**(자재×부수) (reverse.md:55) | NCDFDFT·NCCDPHO 둘 다 `exp_prn_cnt_info` 존재·PRN_CNT 100/200/300/400/500 행 | ✅ |
| §1 자재 3종 MTRL_CD RXSNO250/RXSNO300/RXWMO220 (reverse.md:86) | NCDFDFT: RXSNO250·RXSNO300·**RXWMO220**(옵셋전용 모조지) 실재 | ✅ |
| §2 NCDFFLD 접지 SKU(2단/3단 세로·가로)+오시 (reverse.md:117·123) | NCDFFLD: `2단 세로형 90X50` 등 접지 SKU 다수·`OSI_DFT`×3·`오시`×11 | ✅ |
| §3 NCCDPHO `offset2023_price`·exp_prn 10행 (reverse.md:136·149) | NCCDPHO: `offset2023_price`×1·`exp_prn_cnt_info` 존재 | ✅ |

**honest-scope 확인 (directive 요구):** reverse가 NC 9상품 중 명함 3중심(NCDFDFT/FLD/PHO)만 캡처하고 ① 쿠폰(NCDFCPN 넘버링/미싱) ② 고급지 2종(NCDFQLT/NCCDQLT 자재 superset) ③ 박/형압(NCDFFOI/NCCDFOI [Coming soon])을 `unobserved`로 명시(reverse.md:27·31·64-66; deepcheck §data-gap 묶음). 완전성 미흡을 **fabrication으로 분장하지 않음** — 미캡처 영역을 라우팅 큐로 정직 표기. → **honest unobserved·PASS**(완전성 미흡은 M1 FAIL 사유 아님).

**날조 0**: capture에 없는 코드값을 fact로 단언한 사례 미발견. price reqBody/result는 reverse가 `unobserved`(주문플로 회피·옵션 미세팅) 정직 표기(reverse.md:60). → **GO**.

---

## M2 — 메타모델 정합 · **GO**

- **오버피팅 0**: N-1~N-5 어느 것도 NC 단일 카테고리만의 축으로 신설되지 않음. 전부 기존 17축 귀속(`discovered-axes.md:29` NC facet 5종 등재·`_resolved-fragments.md` NC 미작성이나 dictionary v11.0 흡수 명시).
- **인쇄방식=#12 무모순**: dictionary v11.0(`metamodel-dictionary.md:14`)이 "인쇄방식은 이미 #12(D-7)로 v2.0(BN)에 등재 → #18은 중복" 명시. `discovered-axes.md:22` D-7(인쇄방식/생산 레시피·조건부 distinct) 실재 확인. NC가 토큰 레벨(offset2023_*)로 #12 재확인·새 축 0.
- **관계 무모순**: N-5 접지=사이즈#13 SKU 흡수 + 오시=공정#2(라이브 PROC_000029 오시·PROC_000056~ 접지 실재) — 사이즈↔공정 cascade로 표현, FK/composition 모순 없음.

→ **GO**.

---

## M3 — distinct 타당성 (핵심) · **GO**

**인쇄방식 #18 부결이 옳은가** — 두 축으로 적대 재검.

### ① "인쇄방식=이미 #12" 실재 확인
- `discovered-axes.md:22` **D-7 인쇄방식/생산 레시피 = distinct(조건부)** 등재 확인(v2.0 BN). `_resolved-fragments.md:37-44` A-4(수성/라텍스)가 D-7로 승급된 원 판정 실재. → NC의 옵셋 토큰은 *이미 등재된 #12*의 4번째 인코딩이지 새 축 아님. **#18 = #12 중복 = 부결 정당.**

### ② 승격 양방향 기준 적대 재검 (ST 형상 #17과 대조)
| 기준 | 형상 #17 (승격) | 인쇄방식 #18 (NC) | 재측정 |
|---|:---:|:---:|---|
| ① 전용 슬롯 라이브 실재 | ✅ shape_info | **❌** | 옵셋 NC ↔ 디지털 BC가 `pdt_mtrl/size/dosu/prn_cnt/pcs_info` 슬롯 100% 동형 공유(reverse 차이표 7행 전부 "같은 슬롯, 값만 다름"). item_gbn/price_gbn=enum 토큰(새 스키마 슬롯 0). |
| ② 후니 KB "어느 축에도 없음" 결함 | ✅ G-SK-2 | **❌** | 인쇄방식=#12로 이미 1급 게이팅 축(process-recipe §1 PROC_000002~6). KB가 인쇄방식을 이미 모델링·결함 명시 없음. |

→ 둘 다 불충족 = **가장 깨끗한 부결**. ST 형상은 둘 다 충족(승격)·NC 인쇄방식은 둘 다 불충족(부결) = HARD 기준 양방향 정직.

### 별도 가격엔진이 ①을 충족 안 시킴 (재확인)
`price_gbn=offset2023_price`(디지털=digital_price·현수막=면적매트릭스)는 **전용 슬롯이 아니라 #11 가격모델 라우팅 값**. ST 3엔진(digital/vTmpl/tmpl)·AC acrylic2025가 *한 슬롯(frm_cd 바인딩)으로 라우팅된 선례*와 동형 — 라이브 `t_prd_product_price_formulas`(M4-b: 76행/45공식) 바인딩 그릇이 다중 엔진을 한 슬롯으로 흡수함을 실증. → 별도 가격엔진이 ①(전용 슬롯)을 충족시키지 않음 확인.

### 과소강등(under-demotion) 적대
"진짜 새 축인데 #12로 뭉갰나" — 옵셋의 *모든* 차이(이산 tier·자재풀·가격엔진·토큰)를 점검했으나 전부 기존 축(#10/#5/#11/#12) 분산 또는 #12 토큰 재확인. 새 관리 관심사(고유 lifecycle/governing) 잔여 0. → 과소강등 아님·부결 정당.

→ **distinct 0 비준 · 인쇄방식=#12 확인 · GO**.

---

## M4 — 갭 판정 정확 · **GO** (라이브 재실측 11건 전건 일치)

후니 live `information_schema`/데이터 직접 SELECT(2026-06-19 read-only)로 NC 갭 4 facet + N-2 양면 재실측.

| NC 갭 주장 (gap-matrix §XXV) | 라이브 재측정 | 일치 |
|---|---|:---:|
| price_gbn/item_gbn/pricing_model/print_method/frm_typ 컬럼 전역 **0건** | 위 6 패턴 ILIKE 전역 검색 = **빈 결과**(0건) | ✅ |
| `t_prd_product_price_formulas` 76행/76상품/45공식·바인딩 작동 | `count(*),distinct prd_cd,distinct frm_cd` = **76·76·45** | ✅ |
| `t_prc_price_formulas` frm_typ/pricing_model **컬럼 부재** | 컬럼 = `frm_cd,frm_nm,note,use_yn,reg_dt,upd_dt` (frm_typ 없음) | ✅ |
| `t_prd_products` 수량모델 = 연속 increment 가정(min/max/qty_incr) | `min_qty,max_qty,qty_incr,dflt_qty,qty_unit_typ_cd,nonspec_*` — **이산 tier 전용 슬롯 부재** 확인 | ✅ |
| `t_prd_product_bundle_qtys` = 묶음수(28행)·자재종속 tier 아님 | 컬럼 `bdl_qty,bdl_unit_typ_cd,...`·**rows=28** | ✅ |
| MTRL_CD×PRN_CNT 전용 테이블 0건 | exp_prn/prn_cnt/mtrl_qty/tier 테이블 검색 = **빈 결과** | ✅ |
| `t_prd_product_constraints` logic jsonb·RULE_TYPE 3종·10행 | 컬럼 `...rule_typ_cd,logic,...`·**rows=10** | ✅ |
| `t_prd_product_option_items` 폴리모픽 ref_key1/ref_key2(469행) | 컬럼 `...ref_dim_cd,ref_key1,ref_key2,qty,...dtl_opt`·**rows=477**(▲아래 드리프트) | ✅(구조) |
| `t_dsc_discount_details.min_qty/max_qty` 부수구간 그릇 실재 | 컬럼 `...min_qty,max_qty,dsc_rate,dsc_amt,...` | ✅ |
| `t_mat_materials` print_method/호환 컬럼 0건 (N-4 GAP=#12) | print/method/compat/pool/allow 검색 = **빈 결과** | ✅ |
| N-5 접지=사이즈#13·오시=공정#2 PASS측면 | `PROC_000029 오시`·`PROC_000056 접지`·057~062 단접지 실재 | ✅ |

**판정 양면 검증**:
- **N-1 가격엔진 라우팅 = WEAK**(기존 #11): 바인딩 그릇(76행) 보유 + frm_typ 라우팅키 부재 — **두 면 모두 라이브 일치**. PASS 오판(비존재 컬럼 인용) 아님.
- **N-3/N-4 자재풀 게이팅·토큰 = GAP**(기존 #12): mat print_method 컬럼 0건 실측 — 실재 그릇을 GAP 오판한 것 아님(진짜 부재).
- **N-2 이산 tier = WEAK·본질 data-gap**: 수용 그릇(option_items 폴리모픽·constraints.logic·t_dsc_*) 전부 실재 확인 + 이산 모드 전용 슬롯만 미흡. **vessel-gap 오판 아님** = N-2 data-gap 비준(아래 M5).

> **드리프트 노트(날조 아님)**: gap-matrix는 `option_items 469행`(2026-06-17 캡처), 라이브 재측 **477행**(+8). 작업 중 라이브 적재 진행의 자연 증가(구조·폴리모픽 ref_key1/ref_key2 불변·판정 무영향). FAIL 아님 — 메모리 `huni-recipe-viz-harness`(라이브=움직이는 표적·upd_dt freshness) 교훈과 정합. 판정 권위는 *구조/그릇 존재*이며 행수 ±8은 WEAK/GAP 판정을 바꾸지 않음.

→ **갭 판정 라이브 일치 11건 · 비존재 컬럼 PASS 0 · 실재 그릇 GAP 오판 0 · GO**.

---

## M5 — vessel 건전성 · **GO**

- **NC 신규 그릇 0**: `04_vessel/`에 NC/offset/discrete/tier 전용 파일 **0건**(ls 확인). `vessel-needs.md` V-항목 = V-1~V-12 불변(NC N-항목 신규 0).
- **search-before-mint 통과**: N-2 이산 tier·offset2023_price·자재×부수 매트릭스가 기존 그릇(option_items·constraints.logic·t_dsc_*·product_price_formulas)으로 무손실 수용 — 라이브 M4 재측이 그릇 실재 확정. → 새 그릇 minting 불요·정당.
- **N-2 data-gap not vessel-gap 비준**: `_data-gaps-noted.md §12`가 자재×허용부수 매트릭스·부수구간 단가·offset2023_price 바인딩을 전부 data-gap(dbmap round-1/6/가격 트랙)으로 라우팅. 라이브에서 ① 그릇 실재(option_items 477·constraints 10·t_dsc_* min/max_qty·product_price_formulas 76) ② 후니 KB "어느 축에도 없음" 결함 부재 → ST 형상 G-SK-2와 정반대 = vessel-gap 아님 확정. PD-4·PH-1/PH-2·FS-1 data-gap 동일 계열.
- **V-11(TemplateAsset)·V-12(SHAPE) 불변**: NC가 이 둘을 건드리지 않음(NC는 디자인입력채널·형상 무관 카테고리). 본 하네스 유일 mint(V-11 2테이블·V-12 컬럼2)는 NC 영향 0.
- **convention 정합**: NC 흡수가 t_* 패턴 위반·duplicate-mint 유발 0.

> **경미 노트(NO-GO 아님)**: `_vessel-roadmap.md`에 v11.0(NC) 행이 아직 미추가. 단 NC=신규 vessel 0이므로 roadmap "무수정"이 정당한 상태(v4.0 PR·v6.0 CL이 신규 0일 때도 "인벤토리·Wave 무수정" 명시한 패턴과 동일). 검증 대상(신규 mint 부재)은 충족. 문서 일관성 차원에서 roadmap에 "v11.0 NC=신규 0" 한 줄 추가 권고(Low·게이트 무관).

→ **신규 mint 0 · 중복 mint 0 · convention drift 0 · GO**.

---

## M6 — 생성-검증 독립성 · **GO**

- **self-approve 0**: reverse/metamodel/gap 어느 산출도 자기 M-gate를 통과 처리한 흔적 없음. 본 검증이 별도 lane에서 capture 재읽기 + 라이브 재query로 독립 재유도.
- **핵심 사실 재유도(echo 아님)**: ① item_gbn/이산 tier null 슬롯 = capture grep으로 직접 재현(생성자 인용 비신뢰) ② 76행/45공식·컬럼 0건 = 라이브 직접 SELECT(gap 문서 숫자를 베끼지 않고 재측정) ③ 인쇄방식=#12 = discovered-axes·dictionary 원문 직접 확인.

### Dodge-hunt — NC 최리스크 3건 깨기 시도 (전부 실패=주장 견고)

1. **인쇄방식 #18 부결이 distinct 은폐인가?**
   별도 가격엔진(offset2023_price)·이산 tier·전용 자재풀(RXWMO220)이라는 가장 강한 distinct 신호를 가졌으나 — capture에서 옵셋 NC↔디지털 BC가 base-data 슬롯 100% 동형 공유 재확인(전용 슬롯 ❌) + #12 D-7 이미 등재(KB 결함 ❌). 둘 다 불충족 = 부결 견고. **깨지지 않음.**

2. **N-2 이산 tier가 진짜 vessel-gap(축 부재)인가?**
   "후니 수량모델이 연속 increment만 가정해 못 담는다"는 주장으로 vessel-gap 격상 가능성 적대. 그러나 라이브 재측: option_items 폴리모픽 ref_key2(자재 페어링·477행)·constraints.logic jsonb·t_dsc_* min/max_qty 모두 실재 → 이산 부수 집합·자재→허용부수 cascade·부수구간 단가를 *수용*. 미흡한 것은 "이산 모드 명시 슬롯"(WEAK 측면·V-5 흡수)이지 축 부재 아님. → **data-gap 확정·깨지지 않음.**

3. **distinct 0이 너무 편한 결론(11연속 재포화 관성)인가?**
   NC가 "최강 #18 후보"로 선별됐는데 결과가 또 0 — 관성적 부결 의심. 그러나 부결 근거가 양방향 HARD 기준(전용 슬롯 + KB 결함)으로 *측정*됐고, 두 면 모두 라이브/capture로 독립 재현됨. ST 형상은 같은 기준으로 *승격*된 선례가 있어 기준이 부결 편향이 아님 입증. codex(deepcheck)도 #18 부결 독립 동의(deepcheck §14·결론). → **관성 아님·증거 강제·깨지지 않음.**

→ **독립성 GO · dodge-hunt 3/3 견고**.

---

## 결함 (defects)

**없음.** M1~M6 전건 GO. NO-GO/CONDITIONAL 사유 0 → `_defects.md` 신규 라우팅 불요.

경미 권고 1건(게이트 무관·Low): `_vessel-roadmap.md`에 "v11.0 NC = 신규 vessel 0" 행 추가(문서 일관성). vessel designer 선택 사항.

---

**검증 시각**: 2026-06-19 · 라이브 read-only psql 직접 SELECT(재실측 11건) + capture grep 재현(원자 6건) · 날조 0 · 드리프트 1건(option_items 469→477·판정 무영향). 이 판정이 Phase 6.5 codex reconcile 베이스라인(codex 비노출).
