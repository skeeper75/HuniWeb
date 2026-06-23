# validation-r1-r6.md — RC-2 CONFIRM 확정 3건 적재본 독립 게이트 (R1~R6)

> dbm-validator · 2026-06-23 · §21 RC-2. 생성자(option-mapper·load-builder) 주장 **비신뢰** — 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN으로 직접 재실측.
> 자격증명 = `.env.local RAILWAY_DB_*`(읽기/롤백 전용). 라이브 파괴적 쓰기 **0**(전 트랜잭션 ROLLBACK).
> 대상 = 린넨마감(124)·타공 데이터(138/139)·족자(135) · **총 19행**. ★각목(GAKMOK)·캔버스125 미접촉 검증 포함.
> 권위[HARD]: silsa-l1(260610) 본 검증자 직접 파싱 · 라이브 t_prc_component_prices verbatim. 엔진[HARD]: pricing.py `_row_matches`(line82-94)·공정 eval(line583-589) 본 검증자 직접 정독.

---

## 종합 판정: **GO** (R1~R6 전 게이트 PASS · 단일 FAIL 0)

| 게이트 | 판정 | 핵심 근거 |
|---|---|---|
| R1 권위 충실성 | **PASS** | 단가·dim_vals 권위/라이브 verbatim 일치·날조 0 (단 1건 정직표기 권고 — §R1.D) |
| R2 라이브 정합 | **PASS** | 13개 기준 사실 라이브 SELECT 직접 재실측 전건 일치·불일치 0 |
| R3 멱등성 | **PASS** | 라이브 BEGIN…ROLLBACK 2-pass: PASS1=19행·PASS2=전문 0행 |
| R4 차원·엔진 정합 | **PASS** | always-add 가드 입증(메쉬 proc_cd NULL=0·족자 opt_cd NULL=0)·단일매칭·FK 정합·한계 정직표기 확인 |
| R5 제약·부작용 범위 | **PASS** | FK/PK/disp_seq 충돌 0·19행 외 영향 0·각목/캔버스125/기초코드 마스터 미접촉·undo 정확 |
| R6 생성-검증 독립성 | **PASS** | 라이브·권위·엔진 원본 직접 대조(생성자 산출 재사용 0)·검증자 자체 probe false-positive 1건 자기교정 |

---

## R1 권위 충실성 — PASS

본 검증자가 silsa-l1.csv를 **직접 파싱**해 권위값 추출(생성자 명세 재인용 0):

| 대상 | 권위(silsa-l1) | 라이브 현재 | 적재본 | 판정 |
|---|---|---|---|---|
| 린넨(14569) 가공 5종 | 오버로크0·오버로크+리본끈800·말아박기1000·말아박기+면끈2000·봉미싱(7cm)2000 | id22341~45 opt_cd 5개 0/800/1000/2000/2000 | 단가 불변·재배선 0 | ✅ verbatim |
| 메쉬현수막(14584) 타공 | 타공4=3000·타공6=4000·타공8=5000 | 4750/4752/4754 = 3000/4000/5000 | 단가 verbatim·dim_vals{타공수} 충전 | ✅ verbatim |
| 일반현수막(14583) 타공 | 타공4=3000·타공6=4000·**타공8=5000** | 38219/20/21 = 3000/4000/**8000** | 라이브 8000 verbatim 보존 | ⚠ §R1.D |
| 족자(19311) 천정고리 | 천정형고리 포함 = **"4000?"**(물음표=미확정) | 4594 = 6500 | 6500 verbatim·HOLD-C-PRICE | ✅ verbatim+HOLD |

- **opt_nm "천정형고리 포함"** = 권위 엑셀 텍스트 verbatim 일치 확인.
- **날조 0**: 신규 단가값 0건. 전 UPDATE에 `unit_price=<검증값>` 가드 → 단가 불변 강제.

### §R1.D — 일반 타공수8=8000(라이브) vs 권위 5000 불일치 (MINOR·정직표기 권고)
- 라이브 일반현수막 PUNCH_4 타공수8 단가행 = **8000**, 그러나 권위 silsa-l1 일반현수막 타공(8개) = **5000**(메쉬와 동일).
- 적재본은 라이브 8000을 **verbatim 보존**(단가 미변경) — 지침 "단가 verbatim"에 부합하므로 본 적재 자체는 결함 아님(R1 PASS 유지).
- **단, 명세·매니페스트가 이 불일치를 HOLD로 surface하지 않음.** 족자 6500↔4000?는 HOLD-C-PRICE로 정직 표기했으나, 일반 타공8 8000↔권위 5000은 미표기.
- **권고(NON-BLOCKER)**: dbm-mapping-designer에게 라우팅 — `HOLD-NORMAL-PUNCH8-PRICE`(일반 8000 vs 권위 5000) 추가 정직 표기. **단가 정정은 별 결정**(verbatim 적재는 그대로 진행 가능). GO 차단 사유 아님(verbatim 보존이 원칙).

---

## R2 라이브 정합 — PASS

본 검증자 직접 SELECT(생성자 manifest §0 재실측을 신뢰하지 않고 재측정), 13개 기준 전건 일치:

- opt_cd MAX=**OPV_000430**·OPV_000431 count=**0**(충돌 0) ✅
- 린넨 LINEN_FINISH 5행 id22341~45 opt_cd=OPV_000025/OPV-000024/OPV_000026/OPV_000424/OPV_000027·proc=PROC_000080·단가 0/800/1000/2000/2000·use_dims=`["opt_cd","min_qty"]`·바인딩 0 ✅
- 124=PRF_POSTER_LINEN(disp_seq=1 COMP_POSTER_LINEN_FABRIC만) ✅
- 일반 PUNCH_4 id38219/20/21 proc=**PROC_000105**·{타공수:4/6/8}·3000/4000/8000 ✅
- 일반 PUNCH_4 PRF_POSTER_BANNER_N disp_seq=2 이미 바인딩 ✅
- 일반 좀비 PUNCH_6(4695)/PUNCH_8(4697) comp del_yn=Y·use_dims=[]·use_yn=Y ✅
- 메쉬 PUNCH_4/6/8 id4750/4752/4754 각1행·proc NULL·dim_vals NULL·3000/4000/5000·del_yn=N ✅
- 메쉬 use_dims PUNCH_4=[]·PUNCH_8=[]·PUNCH_6=`["proc_cd","min_qty","proc_grp:PROC_000080"]` ✅
- 메쉬 PRF_POSTER_BANNER_M 바인딩 본체+QBANG+STRING(disp_seq 1/2/3)·타공 0 ✅
- 족자 4594 bdl_qty=2·opt/proc/dim NULL·6500·use_dims=`["bdl_qty","min_qty"]`·바인딩 0 ✅
- 135 PRF_POSTER_JOKJA(disp_seq=1)·OPT_000016 추가(SEL_TYPE.01·min0/max1/mand_yn=N·disp_seq=2·OPV_000035만·옵션 MAX disp_seq=1) ✅
- proc 마스터 PROC_000104(부모del_yn=N)·105(자식upr=104·del_yn=N)·079(부모del_yn=N)·103(자식upr=079·**del_yn=Y 좀비**)·080(봉제del_yn=N) ✅
- FK `fk_comp_prices_proc` proc_cd→t_proc_processes 실재·opt_cd FK 없음(print_opt_cd FK만) → proc UPDATE FK 안전·opt_cd 충전 FK-free ✅

---

## R3 멱등성 — PASS (라이브 롤백전용 DRY-RUN 직접 실행)

단일 `BEGIN … apply×2 … ROLLBACK` 직접 실행:

| pass | 01 opt | 02 use_dims×4 | 03 price×7 | 04 formula×5 | 05 zombie | 합 |
|---|---|---|---|---|---|---|
| PASS1 | INSERT 1 | UPDATE 1×4 | UPDATE 1×7 | INSERT 1×5 | UPDATE 2 | **19** |
| PASS2 | INSERT 0 | UPDATE 0×4 | UPDATE 0×7 | INSERT 0×5 | UPDATE 0 | **0** |

- PASS2 전 문 0행 → 멱등 확정. 가드 = INSERT `WHERE NOT EXISTS`(PK)·UPDATE `IS DISTINCT FROM`+`unit_price=<검증값>` verbatim 가드.
- 구문 오류 0·`ON_ERROR_STOP=1` 하 정상 완주 → ROLLBACK. **라이브 커밋 0.**

---

## R4 차원·엔진 정합 — PASS (★always-add 가드 핵심)

엔진 코드 본 검증자 직접 정독: `NON_QTY_DIMS`에 proc_cd·opt_cd·bdl_qty 포함(line42-43). `_row_matches` line87-88 — **행 차원 NULL = 와일드카드(always-match)**. line91-93 — dim_vals 키는 와일드카드 없음. line583-589 — proc_sels마다 `sel["proc_cd"]`+detail 병합.

- **always-add 제거 입증(DRY-RUN POST-STATE)**: 메쉬 타공 3행 proc_cd NULL 잔존 = **0**·족자 천정고리 opt_cd NULL 잔존 = **0**. 적재 후 판별차원 충전으로 와일드카드 소거.
- **추가 독립 probe**: 3 바인딩 공식(PRF_POSTER_BANNER_M/JOKJA/LINEN)의 활성 addtn COMP_POSTEROPT comp 중 전 차원 NULL 진짜 와일드카드 = **0**(본체 area-matrix comp는 siz_width/siz_height 차원 보유 → 와일드카드 아님·검증자 자체 false-positive 자기교정).
- **미선택 0가산**: 타공/족자 미선택 시 selections에 proc_cd/opt_cd 키 부재 → `_norm(None)≠_norm(실제값)` → row=None → 가산 0. 데이터로 완결.
- **선택 시 단일매칭**: 메쉬 3 comp 각 1행·같은 proc_cd(079)+다른 dim_vals(4/6/8) → 위젯 procs[].detail{타공수:N} 전송 시 해당 타공수 1 comp의 1행만 매칭(나머지 dim_vals 불일치→0). ERR_AMBIGUOUS/DUPLICATE 0(comp당 1행 실측).
- **부모 proc_cd 통일 FK 정합**: 105→104·NULL→079 모두 `fk_comp_prices_proc` 부모(del_yn=N) 가리킴. 환원 option_item도 이미 부모(104/079) 참조 → 단가행-환원 정렬.
- **★타공 데이터 한계 정직표기 확인**: 명세 §2.3·매니페스트·dryrun-result 모두 "데이터만으론 타공수별 미작동·위젯 코드 동반 필요(§21 범위 밖)·데이터 트랙 성과=always-add 제거까지" 명시. **정직 표기 충족**(검증자 동의 — 환원 option_item이 타공수 detail 미전송은 엔진 경로상 사실).

---

## R5 제약·부작용 범위 — PASS

- **대상 테이블 화이트리스트**: `t_prd_product_options`·`t_prc_price_components`·`t_prc_component_prices`·`t_prc_formula_components` 4종만. **t_siz_*·t_mat_materials·t_proc_processes(기초코드 마스터) 쓰기 0** → 마스터 불변 확인.
- **FK**: 옵션 INSERT 부모 OPT_000016 실재·opt PK(prd_cd,opt_cd) 충돌 0(OPV_000431 부재). 바인딩 INSERT 부모 frm_cd(PRF_POSTER_LINEN/BANNER_M/JOKJA)·comp_cd 실재·PK(frm_cd,comp_cd) 충돌 0. proc_cd 충전 부모 104/079 실재.
- **disp_seq 충돌 0**: LINEN 현 {1}→신규2·BANNER_M {1,2,3}→신규4/5/6·JOKJA {1}→신규2·OPT_000016 옵션 {1}→신규2. 전건 충돌 없음.
- **좀비 정확**: 일반 PUNCH_6/8 del_yn=Y 가드 하 use_yn=N(활성 comp 보호·DRY-RUN POST-STATE use_yn=N·del_yn=Y 확인).
- **19행 외 영향 0**: DRY-RUN 영향행수 정확히 19.
- **★각목(GAKMOK) 미접촉**: 전 SQL grep — GAKMOK/각목/WOOD 변경문 0(apply.sql 주석 1건만). 라이브에 COMP_POPT_BNR_GAKMOK_* 등 실재하나 일절 미변경. ✅
- **캔버스125 미접촉**: canvas/PRD_000125/OPV_000028/PRF_POSTER_CANVAS 변경문 0. HOLD-125 정직 표기. ✅
- **undo 정확**: undo.sql 직전값(메쉬6 proc_grp:PROC_000080·메쉬4/8 []·족자 bdl_qty=2/use_dims `["bdl_qty","min_qty"]`·일반 proc 105) 라이브 현재값과 일치 확인. 현 미적재 라이브에 undo 단독 적용 시 가드 0행(안전 no-op) 실증.

---

## R6 생성-검증 독립성 — PASS

- 권위(silsa-l1) **직접 파싱**·라이브 13기준 **직접 SELECT**·엔진 pricing.py **직접 정독**·DRY-RUN **직접 실행**. 생성자 manifest §0 재실측표를 신뢰하지 않고 독립 재측정(전건 일치 확인).
- 검증자 자체 R4 와일드카드 probe가 본체 area-matrix comp를 와일드카드로 오판(siz_width/siz_height 필터 누락) → **자기교정**해 진짜 와일드카드 0 확정. 적대적 재측정 입증.
- 실 결함(GO 차단)은 0이나, **MINOR 1건(§R1.D 일반 타공8 8000↔권위 5000 미표기)** 독립 적발 → dbm-mapping-designer 라우팅.

---

## 라우팅 (재게이트 불요 — GO 유지)

- **dbm-mapping-designer (MINOR·NON-BLOCKER)**: 일반현수막 타공수8 단가 8000(라이브) vs 권위 5000 불일치를 `HOLD-NORMAL-PUNCH8-PRICE`로 명세·매니페스트에 정직 표기 추가. verbatim 적재는 그대로 진행(단가 정정은 별 인간 결정).

## 인간 결정 큐 (COMMIT 전)
- **실 COMMIT**: `./apply.sh commit` — 본 R1~R6 GO + 인간 승인 후에만. (현재 DRY-RUN만 수행·커밋 0)
- **HOLD-C-PRICE**: 족자 천정고리 6500 vs 권위 4000? 실무 확정(verbatim 6500 적재는 가능).
- **HOLD-NORMAL-PUNCH8-PRICE**(신규 적발): 일반 타공8 8000 vs 권위 5000 실무 확정.
- **HOLD-C-ITEM**: 족자 천정고리 자재 MAT_000215 135 미등록(option_item 환원 HOLD·가격 무영향).
- **HOLD-125·HOLD-MESH-MERGE·타공 코드 트랙**: 명세 정직 표기분 유지.

**라이브 파괴적 쓰기 0 · 전 트랜잭션 ROLLBACK · 비밀값 미노출.**
