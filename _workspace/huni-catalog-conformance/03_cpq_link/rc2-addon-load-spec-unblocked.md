# rc2-addon-load-spec-unblocked.md — RC-2 추가물형 옵션 적재 명세 (CONFIRM 비종속분)

> dbm-option-mapper · 2026-06-23 · §21 RC-2. 라이브 읽기전용 실측·DB 미적재·단가 verbatim·search-before-mint·날조 0.
> 대상=각목/타공/린넨마감/족자 **제외**, CONFIRM-A/4/B/C 비종속 추가물형만: 메쉬 큐방·끈 / PET 거치대 S1·S2 / 캔버스 우드행거 / 린넨우드봉 우드봉.
> 권위[HARD]: 라이브 t_prc_component_prices verbatim·rc2-silsa-addon-binding-design.md ②⑤⑥표. 엔진[HARD]: pricing.py `_row_matches`(line82-94)·`match_component`·use_dims opt_grp 무관(line505-508).
> ★생성자(option-mapper)≠검증자 — 본 명세 GO 비준은 dbm-validator 독립 게이트. 실 COMMIT은 인간 승인 후 dbm-load-execution.
> 라이브 실측 일시: 2026-06-23. 단가 전부 verbatim(0 변경).

---

## 0. 라이브 실측으로 확정된 기준 사실 (근거 SQL 포함)

### 0.1 엔진 가격 메커니즘 (pricing.py 코드 실측 — RC-2 banner 138 패턴)
- **단가행 매칭은 NON_QTY_DIMS(opt_cd/siz_cd/proc_cd…)+dim_vals만**으로 결정. `prd_cd`는 매칭 비참여(`_row_matches` line82-94). comp가 상품 1:1 전용이므로 opt_cd가 prd_cd 범위 코드여도 충돌 없음.
- **단가행 차원이 NULL이면 와일드카드 → always-add 결함**(line87-88). 현재 대상 comp 단가행은 opt_cd/siz_cd가 비어 항상 가산됨.
- **use_dims의 `opt_grp:OPT_xxx` 토큰은 매칭에 무관**(line505-508) — 진단표시용. 실제 판별 = opt_cd/siz_cd 단가행 값.
- **138 RC-2 banner 확정 패턴**(라이브 실측): 큐방 단가행 = `opt_cd=OPV_000013` 단독 충전·타 차원 전부 NULL / use_dims=`["opt_cd","opt_grp:OPT_000004"]` / option_item = 자재(MAT)+공정(PROC) BUNDLE 환원(MES용·가격과 독립).
  - SQL: `SELECT comp_cd,siz_cd,mat_cd,proc_cd,opt_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4';` → `||||OPV_000013||3000.00`

### 0.2 폴리모픽 트리거 `fn_chk_opt_item_ref` (라이브 실측)
- option_item이 **존재하면** ref_dim_cd가 가리키는 차원행이 그 prd_cd에 등록돼 있어야 함(없으면 EXCEPTION). ref_dim_cd=NULL/미지원 = EXCEPTION.
- **결론**: option_item은 가격 트리거가 아니라 **MES 생산정보 환원**. 가격은 단가행 opt_cd/siz_cd로만 작동 → 옵션을 등록하되 option_item 환원행은 **차원행이 등록된 경우에만** 추가(없으면 HOLD, 가격은 무영향).

### 0.3 CONFIRM-D 본체 공식 frm_cd 확정 (라이브 실측)
SQL: `SELECT prd_cd,frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000133','PRD_000134','PRD_000136','PRD_000139');`

| 상품 | prd_cd | 본체 공식 frm_cd (확정) | 기존 formula_components disp_seq MAX |
|---|---|---|---|
| 메쉬현수막 | PRD_000139 | **PRF_POSTER_BANNER_M** | 1 (COMP_POSTER_BANNER_MESH addtn_yn=Y) |
| PET배너 | PRD_000136 | **PRF_POSTER_PET_BANNER** | 1 (COMP_POSTER_PET_BANNER) |
| 캔버스 행잉포스터 | PRD_000133 | **PRF_POSTER_CANVAS_HANGING** | 1 (COMP_POSTER_CANVAS_HANGING) |
| 린넨 우드봉 족자 | PRD_000134 | **PRF_POSTER_LINEN_WOODBONG** | 1 (COMP_POSTER_LINEN_WOODBONG) |

→ 메쉬=PRF_POSTER_BANNER_M (설계 추정 일치 확인). 추가물 바인딩 disp_seq는 각 공식에서 **2부터** 시작.

### 0.4 채번 (라이브 실측 MAX+1)
- `opt_cd` 글로벌 MAX (underscore형 `OPV_[0-9]{6}`) = **OPV_000424** → 신규 **OPV_000425~OPV_000430** (6개). dash형(OPV-)은 별 계열이라 미사용.
- `opt_grp_cd` 신규 채번 = **0건** (4상품 추가/거치대 그룹 전부 기존 재사용).
- 각 그룹 기존 옵션 disp_seq MAX: 메쉬 OPT_000023=1·PET OPT-000009=2·캔버스 OPT_000012=1·린넨 OPT_000014=1 → 신규 disp_seq는 +1부터.
- option_item item_seq = 신규 opt_cd마다 1부터.

### 0.5 RC-4 캔버스 사이즈 불일치 (라이브 실측 — 결정적)
SQL: `SELECT prd_cd,siz_cd FROM t_prd_product_sizes WHERE prd_cd IN ('PRD_000133','PRD_000134');` + 치수 대조.

| 상품 | 등록 siz_cd | 치수 |
|---|---|---|
| 캔버스(133) | SIZ_000172 / SIZ_000174 / SIZ_000197 | A4(210x297) / A3(297x420) / A2(420x594) |
| 린넨(134) | SIZ_000258 / SIZ_000315 / SIZ_000317 | A4 / A3 / A2 (치수 동일) |

- 우드행거 단가행 siz_cd = **SIZ_000258/315/317** (=린넨 134 사이즈) → **상품 133에 미등록 → 트리거 OPT_REF_DIM.01 시 REJECT·가격 매칭 불가**. RC-4 재배선 필요.
- 우드봉(린넨 134) 단가행 siz_cd = 258/315/317 = 134 등록 사이즈와 **정합** → 재배선 불필요.

---

## 1. CPQ 옵션 등록표 (신규 옵션 — 기존 그룹 재사용)

신규 그룹 0건. 기존 추가/거치대 그룹에 옵션만 추가(search-before-mint 충족). disp_seq=기존 MAX+1.

| # | 상품(prd_cd) | option_group (기존·근거) | 신규 opt_cd | opt_nm | dflt_yn | disp_seq | use_yn |
|---|---|---|---|---|---|---|---|
| 1 | 메쉬(PRD_000139) | OPT_000023 추가 (실측: OPV_000045 추가없음만) | **OPV_000425** | 큐방(4개)추가 | N | 2 | Y |
| 2 | 메쉬(PRD_000139) | OPT_000023 추가 | **OPV_000426** | 끈(4개)추가 | N | 3 | Y |
| 3 | PET(PRD_000136) | OPT-000009 거치대구매여부 (실측: 실내OPV-000019/실외OPV-000020) | **OPV_000427** | 실외용거치대(단면) | N | 3 | Y |
| 4 | PET(PRD_000136) | OPT-000009 거치대구매여부 | **OPV_000428** | 실외용거치대(양면) | N | 4 | Y |
| 5 | 캔버스(PRD_000133) | OPT_000012 추가 (실측: OPV_000030 출력만만) | **OPV_000429** | 우드행거+면끈 추가 | N | 2 | Y |
| 6 | 린넨우드봉(PRD_000134) | OPT_000014 추가 (실측: OPV_000032 출력만만) | **OPV_000430** | 우드봉+면끈 추가 | N | 2 | Y |

**option_group 변경 주의 (PET S1/S2 — BLOCKED 후보)**: OPT-000009는 SEL_TYPE.01(택1)·기존 실외용거치대(OPV-000020)가 단일 항목. S1/S2를 추가하면 "실외용거치대"(통합·단가 없음)와 "실외 단면/양면"이 그룹 내 공존 → 의미 충돌. **권고: 기존 OPV-000020(실외용거치대) use_yn=N 후보 + 신규 단면/양면으로 대체** 또는 실내/실외단면/실외양면 3택1 재구성. 단 이는 **모델링 결정이라 CONFIRM 필요**(아래 §4 HOLD-1).

### 1.1 option_item 환원행 (MES 생산정보 — 가격 독립·트리거 통과 가능분만)

option_item은 **차원행이 그 prd_cd에 등록된 경우에만** 추가. 138 큐방/끈 패턴 = 자재(OPT_REF_DIM.03 MAT+USAGE.07)+공정(OPT_REF_DIM.04 PROC) BUNDLE.

| 신규 opt_cd | 환원 가능 차원행 (라이브 실측) | option_item (가능분) | 비고 |
|---|---|---|---|
| OPV_000425 메쉬 큐방 | 자재 MAT_000337(큐방·글로벌存) **139 미등록**·공정 PROC_000081(부착) **139 등록✓** | OPT_REF_DIM.04 PROC_000081 (공정만) | ★자재 MAT_000337 139 product_materials 미등록 → 큐방 자재 환원 **HOLD-2**(가격 무영향) |
| OPV_000426 메쉬 끈 | 자재 MAT_000070(끈) **139 등록✓**·공정 PROC_000081 **139 등록✓** | OPT_REF_DIM.03 MAT_000070/USAGE.07 + OPT_REF_DIM.04 PROC_000081 | 138 끈 패턴 동형 완비 |
| OPV_000427 PET 단면 | 자재 MAT_000223(우드거치대) **136 등록✓(USAGE.07)** | OPT_REF_DIM.03 MAT_000223/USAGE.07 | 거치대=자재 환원 |
| OPV_000428 PET 양면 | 자재 MAT_000223 **136 등록✓** | OPT_REF_DIM.03 MAT_000223/USAGE.07 | 동상 |
| OPV_000429 캔버스 우드행거 | 자재 MAT_000223(우드거치대)? **133 미등록**·공정 PROC_000080(봉제) 133 등록✓ | (HOLD — §4 HOLD-3) | 우드행거 자재 코드 미확정·133 미등록 → 환원 HOLD(가격 무영향) |
| OPV_000430 린넨 우드봉 | 공정 PROC_000080(봉제) 134 등록✓·우드봉 자재 미확정 | (HOLD — §4 HOLD-3) | 동상 |

> ★[HARD] option_item HOLD분은 **가격에 무영향**(가격=단가행 opt_cd/siz_cd). 옵션 등록·use_dims·단가행 충전·바인딩만으로 가격 정합 달성. option_item은 MES 환원 보강분으로 후속(자재행 선등록 후).

---

## 2. comp 배선표 (comp별 1행 — CONFIRM-D 확정 frm_cd 반영)

원칙: ⓐ use_dims 판별차원 충전 ⓑ 단가행 판별값 충전(단가 verbatim) ⓒ 공식 바인딩(addtn_yn=Y·disp_seq).

| comp_cd | 대상 frm_cd (CONFIRM-D) | use_dims 충전 | 단가행 판별값 충전 (단가 verbatim·comp_price_id) | 공식 바인딩 (addtn_yn·disp_seq) |
|---|---|---|---|---|
| `COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4` | PRF_POSTER_BANNER_M | `["opt_cd","opt_grp:OPT_000023"]` (현 `[]`) | opt_cd=**OPV_000425**·3000 (현 NULL) | Y·disp_seq=2 |
| `COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4` | PRF_POSTER_BANNER_M | `["opt_cd","opt_grp:OPT_000023"]` (현 `[]`) | opt_cd=**OPV_000426**·4000 (현 NULL) | Y·disp_seq=3 |
| `COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1` | PRF_POSTER_PET_BANNER | `["opt_cd","opt_grp:OPT-000009"]` (현 `[]`) | opt_cd=**OPV_000427**·23000 (현 NULL) | Y·disp_seq=2 |
| `COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2` | PRF_POSTER_PET_BANNER | `["opt_cd","opt_grp:OPT-000009"]` (현 `[]`) | opt_cd=**OPV_000428**·25000 (현 NULL) | Y·disp_seq=3 |
| `COMP_POSTEROPT_PET_BANNER_STAND_IN` | PRF_POSTER_PET_BANNER | `["opt_cd","opt_grp:OPT-000009"]` (현 `[]`) | opt_cd=**OPV-000019**(실내·기존)·7000·min_qty=1 (현 NULL) | Y·disp_seq=4 |
| `COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER` | PRF_POSTER_CANVAS_HANGING | `["opt_cd","siz_cd","opt_grp:OPT_000012"]` (현 `["siz_cd"]`) | ★siz_cd **RC-4 재배선**(§3) + opt_cd=**OPV_000429** 충전 (3행) | Y·disp_seq=2 |
| `COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG` | PRF_POSTER_LINEN_WOODBONG | `["opt_cd","siz_cd","opt_grp:OPT_000014"]` (현 `["siz_cd"]`) | siz_cd 유지(정합) + opt_cd=**OPV_000430** 충전 (3행) | Y·disp_seq=2 |

### 2.1 우드행거/우드봉 always-add 가드 (★엔진 검증)
현재 use_dims=`["siz_cd"]`만 → 본체 사이즈가 selections.siz_cd로 자동 실리면 **우드행거 미선택(출력만)에도 always-add**(`_row_matches`: siz_cd만 매칭, opt_cd NULL=와일드카드). 
→ **use_dims에 opt_cd 추가 + 단가행 3행 모두에 opt_cd=신규옵션 충전** 필수. 그래야 "출력만"(opt_cd≠신규) 선택 시 row=None → 가산 0. siz_cd는 그대로 본체 사이즈로 티어 결정.

PET STAND_IN(7000): 기존 실내거치대 OPV-000019에 단가행 opt_cd 충전(신규 옵션 아님·기존 항목). 거치대 그룹 3옵션(실내/단면/양면) 각 opt_cd로 택1 가산.

---

## 3. RC-4 재배선표 (우드행거 siz_cd 정정 — 캔버스 133)

근거: 상품 133 등록 사이즈(172/174/197) ≠ 우드행거 단가행 siz_cd(258/315/317=린넨134 사이즈). 치수 동일 → 동일 등급에 재배선.

| comp_price_id | comp_cd | 현재 siz_cd | 치수 | → 정정 siz_cd (133 실등록) | 단가 verbatim |
|---|---|---|---|---|---|
| 4598 | CANVAS_HANGING_WOODHANGER | SIZ_000258 (A4) | 210x297 | **SIZ_000172** (A4) | 16000 (불변) |
| 4599 | CANVAS_HANGING_WOODHANGER | SIZ_000315 (A3) | 297x420 | **SIZ_000174** (A3) | 18000 (불변) |
| 4600 | CANVAS_HANGING_WOODHANGER | SIZ_000317 (A2) | 420x594 | **SIZ_000197** (A2) | 20000 (불변) |

**린넨우드봉(134) 우드봉**: comp_price_id 4604/4605/4606 siz_cd=258/315/317 = 134 등록 사이즈와 **정합 → 재배선 없음**(opt_cd만 추가 충전).

---

## 4. FK 위상 적재순서 + 잔여 불확실분(HOLD)

### 4.1 적재순서 (FK 위상·멱등 — RC-2 banner 패턴 동형)
전부 인간 승인·DB 미적재. dbm-load-execution 입력.

1. **CPQ 옵션 선행** (t_prd_product_options): OPV_000425~430 6옵션 INSERT (기존 그룹·disp_seq MAX+1). PET S1/S2는 HOLD-1 해소 후.
2. **option_item 환원** (t_prd_product_option_items): 트리거 통과 가능분만(끈=MAT_000070+PROC_000081·PET=MAT_000223·메쉬큐방=PROC_000081). HOLD-2/3 제외.
3. **comp use_dims 충전** (t_prc_price_components): `[]`/`["siz_cd"]`→opt_cd 추가(§2). IS DISTINCT FROM 가드.
4. **단가행 판별값 충전** (t_prc_component_prices): opt_cd/siz_cd 채움·**단가 verbatim 불변**(UPDATE WHERE에 unit_price 검증값 가드). RC-4 우드행거 siz_cd 재배선 포함.
5. **공식 바인딩** (t_prc_formula_components): 각 frm_cd(CONFIRM-D)에 addtn_yn=Y·disp_seq(§2) UPSERT.

### 4.2 잔여 불확실분 (라이브 실측으로 못 닫음 — 정직 HOLD)

- **HOLD-1 (PET S1/S2 그룹 모델링·BLOCKED)**: OPT-000009(택1)에 기존 "실외용거치대"(OPV-000020·단가 없음)와 신규 단면(S1·23000)/양면(S2·25000)이 의미 중복. OPV-000020 폐기(use_yn=N)+단면/양면 대체인지, 별 모델인지 **실무진 컨펌 필수**. 컨펌 전 PET S1/S2 옵션 등록·바인딩 **BLOCKED**. (메쉬·캔버스·린넨은 무관·진행 가능.)
- **HOLD-2 (메쉬 큐방 자재 환원)**: 큐방 자재 MAT_000337(글로벌 存)이 PRD_000139 product_materials에 **미등록** → 큐방 option_item OPT_REF_DIM.03 환원 시 트리거 REJECT. 자재행 선등록(별 트랙·기초데이터)이 선결. **가격은 무영향**(공정 PROC_000081만 환원·또는 환원 생략). 옵션·가격 배선은 진행 가능.
- **HOLD-3 (캔버스/린넨 우드행거·우드봉 자재 환원)**: 우드행거/우드봉 자재 코드가 단가행/option_item에 없고(단가행 자재 NULL), 133/134 product_materials에 우드 부속물 자재 미확정. option_item 자재 환원 **HOLD**(공정 PROC_000080 봉제만 환원 가능). **가격은 siz_cd+opt_cd로 무영향**.
- **CONFIRM-A/4/B/C**: 본 명세 범위 밖(각목/타공/린넨마감/족자). 별도 트랙.

### 4.3 본 명세로 닫힌 것 (CONFIRM 비종속 GO 범위)
- ✅ CONFIRM-D 4상품 본체 frm_cd 라이브 확정 (메쉬=PRF_POSTER_BANNER_M 외 3종).
- ✅ RC-4 캔버스 우드행거 siz_cd 재배선 확정(258/315/317→172/174/197·치수 근거·단가 verbatim).
- ✅ 메쉬 큐방·끈, 캔버스 우드행거, 린넨 우드봉 옵션 등록+use_dims+단가행 opt_cd+바인딩 종단 명세(가격 정합 GO).
- ✅ 우드행거/우드봉 always-add 가드(use_dims opt_cd 추가) 엔진 근거 입증.
- ⛔ PET S1/S2 = HOLD-1(모델링 CONFIRM) 전 BLOCKED.

---

## 판정

**분석·명세까지 GO** (CONFIRM-D·RC-4 라이브 실측 확정). 핵심:
① 가격 메커니즘=단가행 opt_cd/siz_cd 단독 판별·option_item은 MES 환원(가격 독립)·opt_grp 토큰 무관 — RC-2 banner 138 패턴 동형.
② CONFIRM-D 4 frm_cd 라이브 확정·RC-4 우드행거 siz_cd 재배선 확정(치수 근거·verbatim).
③ 메쉬 큐방/끈·캔버스 우드행거·린넨 우드봉 = GO. PET S1/S2 = HOLD-1(모델링 CONFIRM) BLOCKED.
④ option_item 자재 환원 HOLD-2/3 = 가격 무영향·후속 자재행 선등록.
**DB 미적재·단가 verbatim·search-before-mint(신규 그룹 0·opt_cd MAX+1)·날조 0.** 생성자≠검증자 — dbm-validator 독립 재실측 후 인간 승인.
</content>
</invoke>
