# validation-r1-r6.md — RC-2 각목(현수막 마감봉) 적재본 독립 검증 게이트

> dbm-validator · 2026-06-23 · 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN(BEGIN…ROLLBACK).
> 검증 대상 = `09_load/_rc2_gakmok_260623/`(apply.sql·undo.sql·apply.sh·manifest.md·dryrun-result.md).
> ★생성자(option-mapper·load-builder)≠검증자 — 전 항목 생성자 주장 비신뢰·라이브 직접 재실측. 라이브 파괴적 쓰기 0(전 트랜잭션 ROLLBACK).
> 권위[HARD] = 인쇄상품 가격표 「포스터사인」 r249/250(각목900이하+끈=4000·900초과+끈=8000) · 라이브 4698/4700 verbatim · 엔진 pricing.py `_row_matches`(line82-94).
> 접속 = `.env.local RAILWAY_DB_*`(railway DB·PG18.4 확인).

---

## 종합 판정: **GO** (R1~R6 전 게이트 PASS · 단일 FAIL 0)

| 게이트 | 항목 | 판정 | 핵심 근거(직접 재실측) |
|---|---|---|---|
| **R1** | 권위 충실성 | ✅ PASS | 단가 4000/8000·라벨 가격표 r249/250 verbatim·날조 0 |
| **R2** | 라이브 정합 | ✅ PASS | comp·단가행id·use_dims·라벨·채번여유·바인딩0·frm_cd·disp MAX 전부 라이브 일치 |
| **R3** | 멱등성 | ✅ PASS | 2-pass DRY-RUN 직접실행 PASS1=12행·PASS2=0행·undo baseline 정확복귀 |
| **R4** | 차원·엔진 정합 | ✅ PASS | 12000 이중합산 해소 직접 입증(미선택0·선택시 정확1행·택1 동시매칭0) |
| **R5** | 제약·부작용 범위 | ✅ PASS | FK/PK 충돌0·12행외 영향0·마스터/단가행총량/option_items delta 0·undo 정확 |
| **R6** | 생성-검증 독립성 | ✅ PASS | 라이브·권위·엔진 직접 대조·보수안(2 comp) 타당성 형제 동형 라이브 입증 |

---

## R1 — 권위 충실성 (단가·라벨 verbatim·날조 0) ✅ PASS

라이브 단가행 직접 SELECT:
```
4698 | _LE | unit_price=4000.00 | apply_ymd=2026-06-01
4700 | _GT | unit_price=8000.00 | apply_ymd=2026-06-01
```
- 단가 4000/8000 = 가격표 「포스터사인」 r249(각목900이하+끈=4000)·r250(각목900초과+끈=8000) verbatim 일치.
- 재라벨 → "각목(900mm이하)+끈(4개) 추가"·"각목(900mm 초과)+끈(4개) 추가" = 가격표 옵션명 verbatim(적재후 SELECT 확인).
- apply.sql STEP5 = `unit_price=4000.00`/`8000.00` WHERE 가드(미변경)·opt_cd 충전만 → 단가 날조 0·변경 0.
- 적재 후 단가 재실측: 4698=4000.00·4700=8000.00 불변(R4 트랜잭션 내 확인).

## R2 — 라이브 정합 (전 항목 직접 SELECT) ✅ PASS

| 항목 | 명세/매니페스트 주장 | 라이브 재실측(2026-06-23) | 판정 |
|---|---|---|---|
| GAKMOK comp 3개 | `_900_4`(부모)·`_GT`·`_LE` | 동일 3개 실재·전부 del_yn=N | ✅ |
| comp use_dims 현재 | `_GT`/`_LE`=`[]`·부모 NULL | `_GT`=`[]`·`_LE`=`[]`·부모 NULL | ✅ |
| comp use_yn 현재 | 전부 Y | 전부 Y | ✅ |
| 단가행 4698 | `_LE`·opt NULL·전차원 NULL·4000·06-01 | 정확 일치 | ✅ |
| 단가행 4700 | `_GT`·opt NULL·전차원 NULL·8000·06-01 | 정확 일치 | ✅ |
| 부모 단가행 | 0건 | 0건 | ✅ |
| OPV_000015 현재 라벨 | "각목(세로)+끈(4개) 추가" | 정확 일치·OPT_000004·disp4 | ✅ |
| OPV_000016 현재 라벨 | "각목(가로)+끈(4개) 추가" | 정확 일치·OPT_000004·disp5 | ✅ |
| OPT_000004 그룹 | SEL_TYPE.01·0/1·mand N | SEL_TYPE.01·min0·**max1**·mand N·disp2 | ✅ |
| opt_cd MAX | OPV_000431 | OPV_000431 | ✅ |
| opt_grp_cd MAX | OPT_000062 | OPT_000062 | ✅ |
| 신규 충돌(432/433/063) | 0 | 0 | ✅ |
| GAKMOK 바인딩 | 0건 | 0건 | ✅ |
| frm_cd(138 본체) | PRF_POSTER_BANNER_N 단일 | PRF_POSTER_BANNER_N 단일 | ✅ |
| PRF disp_seq MAX | 7 | 7(본체1·타공4(2)·열재단3·양면테입4·봉미싱5·큐방6·끈7) | ✅ |
| PRD_000138 | 실재 | "일반현수막"·del_yn=N | ✅ |
| SEL_TYPE.01 | 실재 | "단일" 실재 | ✅ |

→ 16/16 항목 라이브 일치·불일치 0. 생성자 주장이 라이브와 100% 정합.

## R3 — 멱등성 (2-pass DRY-RUN 직접 실행) ✅ PASS

단일 트랜잭션에서 apply.sql 본문 2회 실행 후 ROLLBACK(라이브 불변):
```
PASS 1: INSERT 0 1 ×3 / UPDATE 1 ×7 / INSERT 0 1 ×2  = 12행 영향 (에러/제약위반 0)
PASS 2: INSERT 0 0 ×3 / UPDATE 0 ×7 / INSERT 0 0 ×2  = 전 0행 영향
```
- PASS1 12행(INSERT 3 + UPDATE 7 + INSERT 2)·ON_ERROR_STOP 통과(FK·NOT NULL·트리거 정상).
- PASS2 전 0행 → NOT EXISTS(그룹/옵션/바인딩)·IS DISTINCT FROM(재라벨/use_dims/opt_cd/use_yn) 가드 전부 작동. 재실행 안전.
- **undo 정확성**: apply→undo 단일 TX 후 baseline 완전 복귀 직접 확인 — 라벨 원복·OPT_000063/OPV_432/433 잔존 0·comp use_dims `[]`·use_yn Y·단가행 opt_cd NULL(단가 verbatim 불변)·GAKMOK 바인딩 0.

## R4 — 차원·엔진 정합 (★핵심: 12000 이중합산 해소) ✅ PASS

**엔진 의미론 확인(pricing.py 실측)**: `_row_matches`(line85-90)는 **단가행** opt_cd가 NULL이면 `continue`(와일드카드), 충전되면 `_norm(selections.opt_cd)==_norm(row.opt_cd)` 정확매칭. `opt_grp:` 토큰(line506·569)은 non_qty_dims 계산에서 제외 = 매칭 무영향(표시/스코프). → **12000 해소의 실작용 메커니즘 = 단가행 opt_cd 충전(STEP5)**. use_dims는 끈/큐방 동형 정합용.

**Before(현행 라이브 SELECT)**: 두 단가행 opt_cd 전부 NULL → 둘 다 와일드 always-match → 각목 미선택 주문에서 SUM=4000+8000=**12000.00 always-add 결함 재확인**(돈크리티컬).

**After(적재 후·엔진 _row_matches SQL 재현·단일 TX)**:
| 케이스 | selections.opt_cd | 매칭 행수 | charge | 판정 |
|---|---|---|---|---|
| C-1 미선택(OPV_000012) | 추가없음 | **0** | **0** | ✅ always-add 해소 |
| C-2 각목≤900(OPV_000015) | 015 | **1** | **4000.00** | ✅ 정확 단가 1행 |
| C-3 각목>900(OPV_000016) | 016 | **1** | **8000.00** | ✅ 정확 단가 1행 |
| C-4 끈선택(OPV_000014) | 끈 | **0** | **0** | ✅ 각목 미가산(택1) |
| C-5 부착변(OPV_000432) | 세로변 | **0** | **0** | ✅ 세로/가로 가격 무관 |

- **C-ERR 동시매칭 차단**: OPT_000004 max_sel_cnt=1(라이브 직접 확인) → OPV_000015·016 동시선택 불가. 적재 후 두 단가행 opt_cd가 015≠016 → 한 selections에 둘 다 매칭 0 → 12000 원천 차단.
- 세로/가로 opt_cd(432/433)는 각목 단가행 어디에도 미사용 → 가격 무관(C-5). 부모 use_yn=N으로 빈 껍데기 평가 풀 제외(적재후 use_yn=N 확인).

→ 12000 이중합산 **완전 해소** 직접 입증(before 12000 → after 미선택0 / 선택시 4000 or 8000 단 1행).

## R5 — 제약·부작용 범위 ✅ PASS

- **FK**: options FK=(prd_cd→products)·(prd_cd,opt_grp_cd→option_groups) → STEP1(OPT_000063)→STEP2(432/433) 순서가 FK 충족. groups FK sel_typ_cd→SEL_TYPE.01 실재. 바인딩 FK frm_cd(PRF_POSTER_BANNER_N)·comp_cd(_LE/_GT) 실재.
- **PK 충돌 0**: options PK=(prd_cd,opt_cd)→432/433 신규. groups PK=(prd_cd,opt_grp_cd)→063 신규. formula_components PK=(frm_cd,comp_cd)→GAKMOK 0건이라 신규.
- **disp_seq 중복 0**: 적재 후 PRF_POSTER_BANNER_N disp_seq GROUP BY HAVING count>1 = 0건(8/9 신규).
- **단가행 자연키**(`ux_t_prc_comp_prices_nat_key`·opt_cd 포함): comp별 단가행 1개씩이라 opt_cd 충전이 자연키 충돌 0.
- **영향 범위 delta(apply 전후 행수)**: t_mat(343)·t_siz(522)·t_proc(107)·t_cod(85)·t_prc_component_prices 총(7293)·option_items@138(18) **전부 delta 0**. → 기초코드 마스터 불변·신규 단가행 INSERT 0(IDENTITY 미접촉)·option_items 미접촉(트리거 미발동).
- **트리거**: `trg_..._chk_ref`는 option_items INSERT/UPDATE에만 발동 → apply는 option_items 미접촉이라 미발동.
- **undo 정확 원복**: R3에서 baseline 완전 복귀 입증.
- 메쉬현수막(139)·MAT_000339(고아) 미접촉.

## R6 — 생성-검증 독립성 ✅ PASS

- 전 게이트를 생성자 산출물 인용이 아닌 **라이브 직접 SELECT + 엔진 코드 실측 + 2-pass DRY-RUN 직접 실행**으로 독립 재판정.
- **★보수안(2 comp 유지) 타당성 독립 평가 = 타당**:
  - 형제 comp 직접 SELECT: 끈(STRING)·큐방(QBANG)이 **둘 다 같은 OPT_000004 택1 그룹**에서 use_dims=`["opt_cd","opt_grp:OPT_000004"]`(각목 보수안과 동일)·각자 opt_cd 충전(STRING=OPV_000014·4000·4696 / QBANG=OPV_000013·3000·4694)·각자 바인딩(disp7/6)·둘 다 use_yn=Y로 **2 comp 유지** 패턴이 라이브에 이미 검증돼 있음. 각목은 동일 그룹 형제 → **동형=보수안이 라이브 정합**.
  - always-add 해소 효과 = 통합안과 동등(R4 직접 입증·실작용은 단가행 opt_cd 충전). 통합안은 4700행 comp_cd 이관(자연키·가격사슬 구조 변경) 리스크 — 보수안은 행 이관 0·comp_cd 불변으로 리스크 낮음.
  - 결론: 보수안 채택이 always-add 해소엔 통합안과 동등하면서 라이브 동형·저리스크 우위. 타당.

---

## 적재 가능성 종합

**INSERTABLE 12행(GO)**: 그룹1·옵션INSERT2·재라벨2·use_dims2·opt_cd충전2·좀비차단1·바인딩2.
**BLOCKED 0 · GAP(정직 표기·전부 가격 무영향)**: HOLD-G-ITEM(세로/가로 환원·폴리모픽 슬롯 부재)·HOLD-G-CONSTRAINT(부착변 종속 제약·선택)·MAT_000339 고아(기초데이터 별 트랙).

**판정 = GO.** R1~R6 전 PASS·단일 FAIL 0·라이브 파괴적 쓰기 0(전 트랜잭션 ROLLBACK).
★실 COMMIT은 본 GO + **인간 승인** 후 hbd-load-executor/`./apply.sh commit`. 검증자 COMMIT 금지.
