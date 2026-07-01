# 포토카드 PRD_000024 — 제작방식(세트/대량) 선택수단 + BULK 고아 배선 설계

- §27 배선 서브트랙. 고아 `COMP_PHOTOCARD_BULK`(포토카드 완제품가 대량) 미배선 → 대량제작 견적 불가.
- 사용자 지시(260701): "세트(20장1세트)와 대량제작 둘 다 손님이 선택 가능하게"(배타 아님·각각 정확 가격).
- 선례 동형: `design-bind-fold-board-260701.md` A(엽서북30p)·`commit-report-pcb30p-260701.md` — 와일드카드 comp에 opt_cd 판별축 부여 → 형제 disjoint 입증 → 옵션그룹 신설.
- 산출: **dryrun까지**(실 COMMIT 없음·DB 미적재·생성≠검증). 단가=verbatim(날조 0).

---

## 0. 현황 실측 (라이브 SELECT)

| 항목 | 실측값 |
|---|---|
| 상품 | PRD_000024 포토카드 · PRD_TYPE.01 · use_yn=Y · **셋트부모 아님**(t_prd_product_sets 0행 → 평가경로 = `evaluate_price` 직접, evaluate_set_price 아님) |
| 공식 바인딩 | PRD_000024 → **PRF_PHOTOCARD_NORMAL** (← COMP_PHOTOCARD_SET seq1만) |
| 사이즈 | SIZ_000012 1건 |
| 옵션그룹 | 인쇄/종이/코팅/모서리(seq1~4)·화이트별색(del_yn=Y) — **제작방식 그룹 없음** |

### 3 컴포넌트 (모두 comp_typ=.06 완제품가 · prc_typ=**PRICE_TYPE.02 합가형**)
| comp | use_dims | 단가행 | opt_cd | 배선처 |
|---|---|---|---|---|
| COMP_PHOTOCARD_SET (일반세트) | [siz_cd,bdl_qty,min_qty] | **1행**(SIZ_000012·bdl20·minq20·**6,000**) | NULL | PRF_PHOTOCARD_NORMAL(seq1)·PRF_PHOTOCARD_FIXED(seq1·비활성) |
| COMP_PHOTOCARD_BULK (대량) | **[min_qty]뿐=와일드** | **50행**(수량구간 20~3000·합가총액) | NULL | **없음=고아** |
| COMP_PHOTOCARD_CLEAR_SET (투명세트) | [siz_cd,bdl_qty,min_qty] | 1행(8,500) | NULL | PRF_PHOTOCARD_CLEAR(PRD_000025)·PRF_PHOTOCARD_FIXED |

- ★PRF_PHOTOCARD_FIXED = **어떤 상품에도 바인딩 안 됨**(비활성 고아 공식) → SET에 opt_cd 넣어도 라이브 무영향.
- BULK 50행(합가형 총액): 20→5,000 · 100→9,500 · 500→24,600 · 1000→45,000 · 3000→126,000 (verbatim).

### 근본결함
BULK가 고아라 대량제작 견적 불가. 그냥 배선하면 BULK use_dims=[min_qty]뿐(siz_cd/bdl_qty/opt_cd 모두 NULL=와일드카드) → `_row_matches`(pricing.py:94)가 **모든 주문에 매칭** → 세트 주문에도 SET+BULK 동시합산 이중과금.

---

## 1. search-before-mint

- 라이브에 "제작방식/세트/대량/묶음/방식"류 옵션그룹 **0건** → 재사용 대상 없음 → 신규 mint 정당.
- 채번 라이브 재확인: MAX opt_grp=**OPT_000083** · MAX opt_cd=**OPV_000494** → OPT_000084 · OPV_000495/496 free. (separator `_`·MAX+1)

---

## 2. ★[HARD] CLEAR_SET 제외 결정 (교차상품 회귀 가드)

사용자 지시 #2는 SET·CLEAR_SET·BULK 3개에 opt_cd 부여를 명시했으나 **CLEAR_SET은 건드리지 않는다**:
- CLEAR_SET은 PRD_000025 **투명포토카드**의 별도 공식(PRF_PHOTOCARD_CLEAR)에만 배선. PRD_000024와 공식을 공유하지 않음 → PRF_PHOTOCARD_NORMAL의 disjoint에 무관.
- PRD_000025는 **제작방식 옵션그룹이 없다**(인쇄/종이/모서리/화이트별색뿐). CLEAR_SET에 opt_cd=OPV_SET을 넣으면 투명포토카드 손님이 opt_cd 미전달 → CLEAR_SET no_match → **투명포토카드 견적0 회귀**.
- → 지시와 배치되지만 교차상품 파손 방지를 위해 SET·BULK만 처리. (투명포토카드에도 대량을 열려면 별건 설계 — 컨펌큐 3.)

---

## 3. 판별차원 설계 + disjoint 입증

판별축 = **opt_cd(제작방식)** 1축. PRF_PHOTOCARD_NORMAL 안 2 comp만 가르면 됨(CLEAR_SET 부재).

| comp | opt_cd(제작방식) | 나머지 판별 | 매칭 조건 |
|---|---|---|---|
| COMP_PHOTOCARD_SET | **OPV_000495(세트)** | siz_cd·bdl_qty·min_qty | 세트 선택 시만 |
| COMP_PHOTOCARD_BULK | **OPV_000496(대량)** | (없음·min_qty 티어) | 대량 선택 시만 |

- **disjoint 입증** (라이브 dryrun 검증4/5): opt_cd=OPV_495 고정 → SET 1행만 매칭(BULK 0). opt_cd=OPV_496·qty100 → BULK min_qty=100 1행만(SET 0). 정확히 1 comp → 상호 배타. ✅ 이중과금 0.
- ★[HARD] SET 1행에도 opt_cd 충전 필수: 안 하면 SET(opt_cd=NULL=와일드)가 대량주문(OPV_496)에도 매칭 → BULK와 동시합산. 그래서 **SET 1행 opt_cd + BULK 50행 opt_cd** 한 묶음.
- 엔진 매칭 원리(pricing.py:94~106): 행의 opt_cd(NON_QTY_DIMS)가 non-NULL이면 선택값과 일치해야 매칭. use_dims는 UI 스코프/진단용이지 매칭 강제원은 ROW 컬럼.

---

## 4. 선택수단 설계 [HARD] (§7 동반)

- 신설 옵션그룹 `제작방식`(OPT_000084) · sel_typ=SEL_TYPE.01(택1) · **mand_yn=Y** · disp_seq=6.
- 옵션값: OPV_000495 세트(**dflt_yn=Y**) · OPV_000496 대량제작.
- ★mand_yn=Y + dflt=세트가 회귀 안전판: SET 1행에 opt_cd=OPV_495 넣어도 손님이 항상 opt_cd 전달(기본 세트) → 현행 세트 6,000 불변. 선택수단 없으면 배선 무효(손님이 대량 미선택).
- 위젯 계약(§6): 옵션그룹 dflt·mand_yn으로 사전선택(세트 회귀 방지). 시뮬레이터 opt_cd 드롭다운 dflt 방출은 개발팀 C트랙(pcb30p 동일 이슈·데이터는 무관).
- UX: 제작방식이 사이즈/묶음 유효성을 게이트하므로 이상적 위치는 seq 상단이나, 기존 그룹 재정렬은 범위 밖 → seq6 배치(컨펌큐 2).

---

## 5. 배선 + 단가행

- formula_components: **PRF_PHOTOCARD_NORMAL ← COMP_PHOTOCARD_BULK(disp_seq=2, addtn_yn=Y)** 추가. (disjoint→SET과 동시합산 없음)
- component_prices: 단가값 **변경 0**(verbatim). opt_cd 컬럼만 UPDATE — SET 1행(OPV_495)·BULK 50행(OPV_496). IS NULL 멱등 가드. **신규 INSERT/대칭전개 없음.**
- use_dims: SET → `[siz_cd,bdl_qty,min_qty,opt_cd,opt_grp:OPT_000084]` · BULK → `[min_qty,opt_cd,opt_grp:OPT_000084]`.

---

## 6. 골든 케이스 (verbatim·합가형 subtotal = up÷min_qty × qty · 검증가 재현 대상)

| # | 제작방식(opt_cd) | 선택 | 매칭 comp | 단가행 | per_item | qty | **골든** | 판정 |
|---|---|---|---|---|---|---|---|---|
| A | 세트(495) | SIZ_000012·bdl20 | SET | 6,000@minq20 | 300 | 20 | **6,000** | 현행 불변(회귀0) |
| B | 세트(495) | SIZ_000012·bdl20 | SET | 6,000@minq20 | 300 | 40 | **12,000** | 2세트 |
| C | 대량(496) | — | BULK | 5,000@minq20 | 250 | 20 | **5,000** | 세트20장(6,000)과 불일치=정상(안 섞임) |
| D | 대량(496) | — | BULK | 9,500@minq100 | 95 | 100 | **9,500** | 대량 활성화(현행 견적불가) |
| E | 대량(496) | — | BULK | 24,600@minq500 | 49.2 | 500 | **24,600** | — |
| F | 세트(495)·qty100 [회귀대조] | SIZ_000012·bdl20 | SET only | 6,000@minq20 | 300 | 100 | **30,000** | BULK 미매칭 확인(대량은 반드시 496 선택) |

- 각 케이스 disjoint(정확히 1 comp). C vs A: 20장이라도 세트6,000 ≠ 대량5,000 — **각각 정확 가격·안 섞임**(사용자 지시 충족).
- 돈영향: 대량제작 견적 신규 활성화(현행 고아=불가). 세트 회귀 0.
- 단가 출처 = `t_prc_component_prices` id 3439(SET)·3389/3393/3413(BULK 20/100/500).

---

## 7. 산출물 / 라우팅

- `design-photocard-260701.md`(본) · `photocard-backup-260701.csv`(SET1+BULK50 opt_cd·use_dims 원값) · `photocard-fix-dryrun.sql`(BEGIN…ROLLBACK·검증1~6·멱등) · `photocard-undo.sql`.
- dryrun 실증: INSERT 1/1/1·UPDATE 1/50·use_dims 2·배선 1 → 검증1~6 통과·ROLLBACK. 멱등=NOT EXISTS+opt_cd IS NULL 가드.
- 실 COMMIT: **인간 승인 후** photocard-fix.sql(dryrun의 BEGIN/ROLLBACK만 제거·§7 트랙)·**webadmin 가격시뮬레이터 실화면 확인 필수**(제외0·PRICE≠0·세트/대량 드롭다운 노출) [HARD].
- 검증(생성≠검증): 본 설계는 생성측. E게이트·codex 교차·evaluate_price 실호출 disjoint는 후속 패스.

## 8. 컨펌큐 (인간)
1. 포토카드 손님 UI에 "제작방식(세트/대량제작)" 옵션 신설 노출 OK? SET 1행 opt_cd 충전(데이터 변경·단가 불변) 승인?
2. 제작방식 옵션 위치 = seq6(끝) vs seq1(사이즈보다 앞·게이트 역할) 중 선호?
3. 투명포토카드(PRD_000025)에도 대량제작을 열까? (현재 CLEAR_SET만·별건 설계 필요 — 이번 범위 밖)
