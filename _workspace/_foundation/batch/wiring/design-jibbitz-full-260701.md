# 아크릴지비츠(PRD_000156) 제대로된 가격설계 — §18 재설계 (2026-07-01)

이전 flat200(Path 1) 폐기 후 재설계. 권위=`jibbitz-authority-correction-260701.md`(상품마스터 260610 아크릴 시트 + 인쇄상품 가격표 260527 B04). 라이브 읽기전용 실측·**DB 미적재**(설계+dryrun까지·실 COMMIT은 인간 승인 후 §7).

---

## 0. 결론 요약 (TL;DR)

- **가공 모델링 축 = `opt_cd` (옵션 1급 가격차원)** — proc_cd 아님. broken addon 경로(OPT_REF_DIM 환원)와 별개의 **엔진 정식 경로**임을 코드로 확증(`price_views.py:1360-1368,1423-1428`, 2026-06-28 주석). 아크릴 후가공 옵션(BADGE/KEYRING/MAGNET) + 엽서북(OPT_000082)·화이트명함(OPT_000081) 완제품가가 이미 이 패턴 사용 → **동형 재사용**. proc_cd 신설 불요, BLOCKED 없음.
- **수량구간 할인 = `DSC_ACR_QTY` 재사용** — 라이브 아크릴 카테고리 수량구간 할인테이블이 권위와 **정확히 일치**. 신설 0.
- **mint 범위(최소)**: 공식 1(PRF_ZIBITZ_ACRYL)·구성요소 1(COMP_ACRYL_ZIBITZ)·옵션그룹 1(OPT_000083)·옵션 2(OPV_000493 투명·OPV_000494 스핀)·단가행 2(79166/79167)·상품↔할인 링크 1. 사이즈 5+비규격은 이미 등록됨(보정만).
- **사이즈는 가격축 아님** — use_dims에 siz_cd 미포함. 규격 5종+비규격 자유치수는 상품 구성으로 등록(가격 무관).

---

## 1. 라이브 현황 실측 (읽기전용)

| 항목 | 실측값 |
|---|---|
| PRD_000156 | 아크릴지비츠 · use_yn=**N** · del_yn=N · prd_typ=PRD_TYPE.01(완제품) |
| nonspec | nonspec_yn=Y · width 15~35(incr **NULL**) · height 15~35(incr **NULL**) |
| 수량 | min_qty=1 · max_qty=10000 · qty_incr=1 · dflt_qty=**NULL** |
| 현재 바인딩 | PRF_ACRYL_ZIBITZ_TBD → COMP_ACRYL_PENDING_TBD (placeholder·use_dims=["min_qty"]) |
| 사이즈(등록됨) | SIZ_000352(15x15)·SIZ_000336(20x20)·SIZ_000353(25x25)·SIZ_000330(30x30)·SIZ_000354(35x35) — 전부 dflt_yn=Y·disp_seq=1(중복·보정 대상) |
| 옵션그룹 | 없음 |
| 채번 MAX(실측) | opt_grp=OPT_000082 · opt_cd=OPV_000492 · comp_price_id=79165 |

★정정: directive/이전 기록의 "COMP_ACRYL_ZIBITZ·PRF_ZIBITZ_ACRYL free" 는 **stale** — 실제 라이브엔 둘 다 미존재. 존재하는 건 두 placeholder 공식(PRF_ACRYL_ZIBITZ_TBD·PRF_ACRYL_ZIBITZ2_TBD)뿐.

---

## 2. search-before-mint — 가공 모델링 축 결론

### 2-1. opt_cd = 엔진 정식 가격차원 (핵심 결론)
- `pricing.py` `NON_QTY_DIMS` 에 `opt_cd` 포함(정확값 매칭). 구성요소 use_dims에 `opt_cd` + `opt_grp:<코드>` 토큰 선언 시:
  - `price_views.py:split_scopes` 가 `opt_grp:` 토큰을 스코프로 분리(실 dim은 opt_cd).
  - `price_views.py:1360-1368` 가 그 옵션그룹의 옵션만 opt_cd 드롭다운으로 노출 → 손님 선택 → `selections["opt_cd"]` 설정 → 엔진이 단가행 opt_cd로 매칭.
  - `price_views.py:1423-1428`(2026-06-28) 명시: **"옵션이 가격에 작용하는 정상 경로 = 가격구성요소가 opt_cd 차원(+opt_grp 범위)을 쓰는 경우뿐"**.
- broken 모델([[addon-optcd-model-broken-live]])은 **OPT_REF_DIM 하위차원 환원**(option_items→siz/mat/proc) 경로로, 이 opt_cd 원시 드롭다운 경로와 **다른 것**. 이 재설계는 정식 경로 사용.

### 2-2. 동형 선례 (재사용 근거)
| 선례 comp | use_dims | 성격 | 상태 |
|---|---|---|---|
| COMP_ACRYL_BADGE/KEYRING/MAGNET… | `["opt_cd","min_qty","opt_grp:OPT_00007x"]` | 아크릴 후가공 옵션(단가형) | use_yn=Y (라이브) |
| **COMP_PCB_S1_30P**(엽서북) | `["siz_cd","min_qty","print_opt_cd","opt_cd","opt_grp:OPT_000082"]` | **완제품가에 opt_cd 축** | 최근 COMMIT·골든 일치(22k/23k) |
| COMP_NAMECARD_WHITE_* | `["print_opt_cd","opt_cd","min_qty","opt_grp:OPT_000081"]` | 완제품가에 opt_cd 축 | use_yn=Y |

→ 지비츠는 이보다 **더 단순**(opt_cd + min_qty만). 가공(투명/스핀) 택1이 **본체 단가 자체**(별도 본체가 없음·가격표 B04가 투명200/스핀600을 상품 장당가로 규정). 따라서 opt_cd를 **유일 base 구성요소**로 모델링(addon 가산 아님).

### 2-3. 수량구간 할인 = DSC_ACR_QTY 재사용
라이브 `DSC_ACR_QTY`("아크릴 카테고리 수량별 구간할인"·DSC_TYPE.01 정률) 상세 = 권위 B04와 **정확 일치**:

| min_qty | max_qty | dsc_rate(%) | 권위 할인율 |
|---|---|---|---|
| 1 | 49 | 0.00 | 0.0 |
| 50 | 99 | 10.00 | 0.1 |
| 100 | 299 | 20.00 | 0.2 |
| 300 | 499 | 30.00 | 0.3 |
| 500 | 999 | 40.00 | 0.4 |
| 1000 | (NULL) | 50.00 | 0.5 |

엔진 `_quantity_discount`(pricing.py:714)가 상품↔할인테이블 링크(`t_prd_product_discount_tables`)로 조회·base 합산 후 1회 적용(`after = amount×(1−rate/100)`). PRD_000146/160~171 등 아크릴 상품 다수가 이 링크 사용 = 링크 선례 확립. → **신설 0, PRD_000156→DSC_ACR_QTY 링크만 추가**.

---

## 3. 설계 명세

### 3-1. price_formulas (신설 1)
| frm_cd | frm_nm(레거시 용어) | 비고 |
|---|---|---|
| **PRF_ZIBITZ_ACRYL** | 아크릴지비츠 가공단가 | 단일 구성요소(가공 opt_cd 단가) 합산. 사이즈 무관 |

- 기존 placeholder(PRF_ACRYL_ZIBITZ_TBD)는 156 바인딩 해제 후 **§7 정리 후보**(PRF_ACRYL_ZIBITZ2_TBD·COMP_ACRYL_PENDING_TBD 공유 여부 확인 후 정리 — 이 재설계에서 삭제 안 함).

### 3-2. price_components (신설 1) → formula_components 배선
| comp_cd | comp_nm | prc_typ_cd | use_dims | 배선 |
|---|---|---|---|---|
| **COMP_ACRYL_ZIBITZ** | 아크릴지비츠 가공(투명/스핀) 완제품가 | PRICE_TYPE.01(단가형=단가×수량) | `["opt_cd","min_qty","opt_grp:OPT_000083"]` | PRF_ZIBITZ_ACRYL, disp_seq=1, addtn_yn=N |

- 의미축=**옵션(가공)**. 판별차원=opt_cd(투명/스핀 disjoint). min_qty=단일밴드(1). opt_grp 토큰=드롭다운 스코프(엔진 매칭엔 미참여).

### 3-3. component_prices (신설 2·단가 verbatim)
| comp_price_id | comp_cd | opt_cd | min_qty | unit_price | apply_ymd | note |
|---|---|---|---|---|---|---|
| 79166 | COMP_ACRYL_ZIBITZ | OPV_000493(투명) | 1 | **200** | 2026-07-01 | 가격표 B04 투명 |
| 79167 | COMP_ACRYL_ZIBITZ | OPV_000494(스핀) | 1 | **600** | 2026-07-01 | 가격표 B04 스핀 |

- 나머지 차원 컬럼(siz_cd/mat_cd/print_opt_cd/proc_cd/dim_vals…)=NULL. 수량할인은 단가행에 굽지 않음(t_dsc가 적용).

### 3-4. 옵션그룹/옵션 (신설·opt_cd 드롭다운 소스)
| 엔티티 | 코드 | 값 |
|---|---|---|
| option_group | OPT_000083 | opt_grp_nm=가공 · sel_typ=SEL_TYPE.01(택1) · min_sel=1 · max_sel=1 · mand_yn=Y · disp_seq=1 |
| option | OPV_000493 | opt_nm=투명 · dflt_yn=Y · disp_seq=1 |
| option | OPV_000494 | opt_nm=스핀 · dflt_yn=N · disp_seq=2 |

- option_items(OPT_REF_DIM) **불요** — opt_cd 원시 드롭다운 경로는 t_prd_product_options만 읽음(가격). items는 외부전송용이라 이 가격설계 범위 아님.

### 3-5. product_price_formulas 바인딩 (재바인딩)
- 기존 (PRD_000156, 2026-06-28) 행의 frm_cd: `PRF_ACRYL_ZIBITZ_TBD` → **`PRF_ZIBITZ_ACRYL`** UPDATE.

### 3-6. 상품↔할인테이블 링크 (신설 1)
- `t_prd_product_discount_tables`: (PRD_000156, DSC_ACR_QTY, apply_bgn_ymd=2026-06-01).

### 3-7. 사이즈 (등록됨·보정만)
- 규격 5종 이미 바인딩. 비규격 nonspec_yn=Y·15~35 이미 설정 → **nonspec_width_incr=1·nonspec_height_incr=1**(권위 "증가1") 보정.
- dflt_qty=NULL→100(합리적 기본), disp_seq/dflt 중복 정규화(15x15 단일 dflt·disp_seq 1~5) — 표시 정리(가격 무영향).

---

## 4. disjoint 진리표 자가검증 (이중합산 0)

공식 PRF_ZIBITZ_ACRYL = 구성요소 1개(COMP_ACRYL_ZIBITZ). 손님은 가공 택1(SEL_TYPE.01·mand). 단가행 2개는 opt_cd로 **상호배타**:

| 선택 opt_cd | 매칭 단가행 | 매칭 수 | included_sum |
|---|---|---|---|
| OPV_000493(투명) | 79166 (opt_cd=OPV_000493) | 1 | 200×qty |
| OPV_000494(스핀) | 79167 (opt_cd=OPV_000494) | 1 | 600×qty |
| 미선택 | (opt_cd 판별차원 매칭 실패) | 0 | 0(경고) |

- 동시매칭(ERR_AMBIGUOUS) 없음(opt_cd 값 disjoint). 중복행(ERR_DUPLICATE) 없음(comp_price_id·조합·apply_ymd 유일). min_qty=1 단일밴드 → tier가 항상 그 행 선택. **판별차원 있음**(opt_cd) → "항상매칭" silent 합산 없음(U-7 계승). 시트 차원경계 SOT: opt_cd만 배선(시트 밖 comp 합산 0).

---

## 5. 골든 케이스 (verbatim 재계산·검증가 재현 대상)

base = 단가(가공) × 수량 → DSC_ACR_QTY 구간 `×(1−rate/100)` → round_won(HALF_UP·정수 원).

| # | 가공 | 수량 | base=단가×수량 | 구간 rate | 최종가 |
|---|---|---|---|---|---|
| G1 | 투명 | 1 | 200×1=200 | 0% | **200** |
| G2 | 투명 | 50 | 200×50=10,000 | 10% | **9,000** |
| G3 | 투명 | 100 | 200×100=20,000 | 20% | **16,000** |
| G4 | 투명 | 300 | 200×300=60,000 | 30% | **42,000** |
| G5 | 투명 | 1000 | 200×1000=200,000 | 50% | **100,000** |
| G6 | 스핀 | 1 | 600×1=600 | 0% | **600** |
| G7 | 스핀 | 100 | 600×100=60,000 | 20% | **48,000** |
| G8 | 스핀 | 500 | 600×500=300,000 | 40% | **180,000** |
| G9 | 스핀 | 1000 | 600×1000=600,000 | 50% | **300,000** |

전부 정수 → round_won 무손실. 검증가는 라이브 evaluate_price/시뮬레이터(opt_cd 실선택)로 G3(투명100=16,000)·G7(스핀100=48,000) 재현 확인 권고.

---

## 6. mint 범위·채번

| 신규 | 코드 | 근거 |
|---|---|---|
| 공식 | PRF_ZIBITZ_ACRYL | 지비츠 전용 무손실 표현(placeholder 대체) |
| 구성요소 | COMP_ACRYL_ZIBITZ | opt_cd 가공 단가(동형 mint) |
| 옵션그룹 | OPT_000083 | MAX(OPT_000082)+1 |
| 옵션 | OPV_000493·OPV_000494 | MAX(OPV_000492)+1,+2 |
| 단가행 | 79166·79167 | MAX(79165)+1,+2 (§7 적재 시 시퀀스 setval 주의) |
| 링크 | PRD_000156→DSC_ACR_QTY | 재사용(신설 아님) |

재사용(mint 0): DSC_ACR_QTY 및 상세 6행·opt_cd 엔진경로·아크릴 사이즈 5종.

---

## 7. BLOCKED / 컨펌큐

- **BLOCKED 없음** — proc_cd 신설 불요(가공=opt_cd). §12/§7 위임 불필요.
- 컨펌(비차단): ① dflt_qty=100 합리적 기본값 확인(권위 미규정) ② 사이즈 disp_seq/dflt 정규화 여부(가격 무영향·표시 정리) ③ 링크 apply_bgn_ymd=2026-06-01(아크릴 패밀리 정합) vs 2026-07-01.
- 활성화(use_yn N→Y)는 설계+적재+골든 검증(라이브 시뮬레이터) 통과 후 §7에서.

---

## 8. 산출 파일
- 설계: `_workspace/_foundation/batch/wiring/design-jibbitz-full-260701.md` (이 문서)
- dryrun: `_workspace/_foundation/batch/wiring/design-jibbitz-full-260701-dryrun.sql` (BEGIN…ROLLBACK)
