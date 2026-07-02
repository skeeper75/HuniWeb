# 088 레더 링바인더 재설계 — S1~S8 독립 게이트 판정 (hsp-set-gate)

- 작성 2026-07-02 · §23 Phase 4 · hsp-set-gate-validation · **생성자(designer)·codex 주장 비신뢰 — 전부 직접 재실측**
- 대상: `03_design/088-redesign-260702/apply.sql`(변경 8행) · 골든 3케이스(1부 39,000 / 10부 290,000 / 100부 1,800,000)
- 실측 환경: 라이브 Railway DB 읽기전용 SELECT + `BEGIN…ROLLBACK` DRY-RUN(COMMIT 0) + `raw/webadmin/.../pricing.py` **실 매칭함수(match_component·component_subtotal)** 재현
- 재현 스크립트(동 디렉터리): `_dryrun-088-twice.sql`(S6 멱등) · `_s4_engine_repro.py`(S4 실엔진) · `_undo_symmetry.sql`(S6 undo 대칭)

---

## 종합 판정: **GO**

S1~S8 전부 PASS. 단일 FAIL 없음. 골든 3케이스 실엔진 재계산 허용오차 0. 이중합산 0. 인접 상품(072/077) 무영향 실증. codex reconcile 미해결 0.

> 1건의 정직 관측(비블로커): 9,000 소재+인쇄비 값의 출처는 **실무진 전달 "출력소재관리 0702 발췌"**(가격표_260702 IMPORT 시트에는 아직 미반영). 실무진=권위이므로 유효하나, 적재 후 가격표 엑셀에 역반영(traceability)을 실무진 큐로 남긴다. **적재 차단 사유 아님.**

---

## 판정표

| 게이트 | 판정 | 핵심 실측 증거 |
|---|---|---|
| S1 권위 충실성 | **PASS** | 골든 독립 재계산이 실무진 기대값과 일치. 싸바리 6밴드 verbatim 라이브 일치. 9,000 verbatim. |
| S2 구성원 유형 | **PASS** | 088=PRD_TYPE.01(셋트 완제품)·089~093=.02 반제품(전 5행). 완제품/기성/디자인 혼입 0. |
| S3 무결성 | **PASS** | PK/ON CONFLICT 정합·FK 고아 0·전 코드 실재·NOT NULL 충족(reg_dt DEFAULT now()). |
| S4 가격 e2e [HARD] | **PASS** | 실엔진 함수로 3케이스 39,000/290,000/1,800,000 정확 재현·이중합산 0·PRICE≠0. |
| S5 경쟁사/도메인 | **PASS** | 9,000=실무진 통합가(경쟁사 미덮어쓰기)·링두께=제약축(가격 아님)·naming/codes 유입 0. |
| S6 적재 가능성 | **PASS** | DRY-RUN 제약위반 0·2회 재적용 delta 전 0(멱등)·undo 대칭 diff 0. |
| S7 생성≠검증 독립성 | **PASS** | 전 증거 직접 재실측(SQL·실엔진·DRY-RUN)·codex reconcile 2불일치 3자 해소. |
| S8 구성요소 경계 무오염 [HARD] | **PASS** | blast radius={088,089}·COVERBIND 삭제 스코프 정확(072/077 생존)·proc_cd 격리 실증. |

---

## S1 — 권위 충실성 · PASS

독립 재계산(권위 격자 합산):

| 부수 | 표지 소재+인쇄비 (9,000×부) | 싸바리 밴드단가 | 싸바리 (밴드×부) | 합계 | 실무진 기대 |
|---|---|---|---|---|---|
| 1 | 9,000 | 30,000(밴드1) | 30,000 | **39,000** | 39,000 ✓ |
| 10 | 90,000 | 20,000(밴드10) | 200,000 | **290,000** | (10부값·설계 제시) ✓ |
| 100 | 900,000 | 9,000(밴드100) | 900,000 | **1,800,000** | 1,800,000 ✓ |

- 싸바리 6밴드 라이브 실측 = `30000/25000/20000/15000/9000/7000` = 권위 `sabari-binder-bind-grid.csv` **verbatim 100% 일치**(comp_price_id 8318~8323).
- 9,000 = `leather-ringbinder-a4-grid.csv` 하단 Q2 해소행(636×374·출력소재관리 0702) verbatim. **날조 0.**
- ★출처 주의: 9,000은 실무진 채팅 발췌본 값(가격표_260702 IMPORT 시트엔 미반영). 실무진=권위 → 유효. 역반영은 traceability 큐(비블로커).

## S2 — 구성원 유형 정합 · PASS

라이브 `t_prd_products` 실측: `088=PRD_TYPE.01`(완제품=셋트 완제품·부모)·`089~093=PRD_TYPE.02`(반제품). 완제품/기성/디자인 혼입 0. apply.sql는 부모(088)·표지 반제품(089)에만 배선(유형 정합).

## S3 — 무결성 · PASS

- **PK 정합**: 실측 PK ↔ apply ON CONFLICT 전 일치 — comp_cd / frm_cd / (frm_cd,comp_cd) / (prd_cd,apply_bgn_ymd) / (prd_cd,proc_cd). t_prc_component_prices는 PK=comp_price_id뿐이라 자연키 NOT EXISTS 가드(정확).
- **FK/코드 실재**: PRD_000088/089·COMP_BIND_SSABARI·PROC_000098(use_yn=Y,upr=PROC_000017)·COMP_HC_MUSEON_COVERBIND·PRF_LEATHER_RINGBINDER_SET·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01 전부 실재. 고아 0.
- **NOT NULL**: 전 대상 테이블의 not-null-no-default 컬럼을 apply INSERT가 전부 공급. reg_dt는 DEFAULT now()(생략 안전·"reg_dt 함정" 없음).
- 셋트행(t_prd_product_sets 5행)은 apply 무변경(qty=1·min/max/incr NULL=수량고정, 기존상태·본 재설계 도입 결함 아님).

## S4 — 가격 e2e [HARD·돈크리티컬] · PASS

**pricing.py 실 매칭함수(`match_component`+`component_subtotal`)를 재설계상태 단가행에 직접 적용** (`_s4_engine_repro.py`):

```
copies  member089_cover  parent_sabari  base_total   final       판정
1       9000             30000          39000        39000       OK
10      90000            200000         290000       290000      OK
100     900000           900000         1800000      1800000     OK
RESULT: ALL GOLDEN MATCH
```

- member 089(표지): use_dims=["min_qty"]·판별차원 없음→항상 매칭·PRICE_TYPE.01 → 9,000×부.
- 부모(088): COMP_BIND_SSABARI(PRICE_TYPE.01)·set_procs=[{proc_cd:PROC_000098}]→싸바리 밴드×부.
- 면지 090~093=공식 0 → 0. **이중합산 0**(표지=member만·제본=부모만·comp 분리).
- 088 할인테이블 0건 → final=base_total. **PRICE≠0.**
- ★**codex High 리스크 해소**: `proc_grp:PROC_000017` 차원은 실질 무력 — NON_QTY_DIMS 상수에 없고, SSABARI 전 18행 **dim_vals 비어있음**. `_row_matches`는 proc_cd 컬럼으로만 매칭. 실엔진이 골든 정확 재현으로 최종 확증(정적 GO≠런타임 GO 우려 → 런타임 실증 완료).

## S5 — 경쟁사/도메인 타당 · PASS

9,000=실무진 "소재+인쇄비 통합가"(출력소재관리 하드커버전용) — 경쟁사 값이 권위를 덮어쓰지 않음. 리서치(leather-ringbinder-pricing-research-260702) 3자 수렴: 링 두께(31/42/56)=수용량 제약축·링타입 O/D=표시(가격 무영향). 싸바리(하드케이스)≠D링 구분 반영. 대안 경로(레더아트프린트 19,000)는 실무진 미지목이므로 **미채택**. naming/codes 후니 유입 0.

## S6 — 적재 가능성 DRY-RUN · PASS

`_dryrun-088-twice.sql`(BEGIN…ROLLBACK):
- Pass1: 5 INSERT + 1 DELETE + 2 INSERT 전 성공 — **제약위반 0**.
- 사후: 부모=COMP_BIND_SSABARI 단독·표지단가 9,000@1·089→PRF_LEATHER_RINGBINDER_COVER·088 proc=PROC_000098·**COVERBIND는 PRF_HC_MUSEON_SET에만 잔존**.
- Pass2(멱등): #2 NOT EXISTS→INSERT 0·#6 DELETE 0·나머지 ON CONFLICT no-op → **6개 테이블 delta 전 0**.
- SSABARI@PROC_000098 밴드 min_qty별 정확 1행(중복 0 → ERR_DUPLICATE 없음).
- `_undo_symmetry.sql`: baseline→apply→undo → **대칭 diff 0행**(완전 복원).

## S7 — 생성≠검증 독립성 · PASS

전 증거를 직접 재실측(라이브 SQL·pricing.py 실엔진·DRY-RUN 트랜잭션)으로 확보. designer/codex 주장 인용으로 PASS한 게이트 없음. codex reconcile 2불일치를 독립 3자 판정으로 해소: (1) 부모공식 잔여 component → 라이브 실측 "COVERBIND 단독 1행→교체 후 SSABARI 단독"(잔여 0 확증), (2) comp_price_id MAX+1 동시성 → MAX=88046 확인·load-executor 단일 트랜잭션 관례(비블로커). codex 미해결 0.

## S8 — 구성요소 경계 무오염 [HARD·돈크리티컬] · PASS

- **blast radius = {088, 089}만** (SQL 실증): PRF_LEATHER_RINGBINDER_SET는 088에만 바인딩·COMP_BIND_SSABARI는 배선 전 고아(0공식)→후 088공식에만·신규 mint(표지 comp/공식)는 089에만.
- **COVERBIND 삭제 스코프 정확**: apply #6은 (PRF_LEATHER_RINGBINDER_SET, COMP_HC_MUSEON_COVERBIND) 배선행만 제거. COMP_HC_MUSEON_COVERBIND는 **PRF_HC_MUSEON_SET(072·077)에도 배선** — DRY-RUN 사후 "PRF_HC_MUSEON_SET 생존" 확인 → **072/077 무영향**(라이브 실측: 072=926,338·077=806,119·PRICE≠0·의존 입력 불변→불변).
- **proc 격리 실증**(실엔진): 088이 PROC_000098만 선언 → set_procs=[{PROC_000098}]→싸바리 밴드(9,000/100부). 만약 PROC_000023/024가 섞이면 각각 무선(7,000)·트윈링(8,000) 별 밴드로 갈려 **동시매칭 ambiguity/오밴드** 위험이나, 088 proc 0→PROC_000098 단독 추가로 차단. 무선/트윈링 밴드 silent 적용 0.
- 공유 comp(COMP_BIND_SSABARI 3밴드 보유)가 다른 상품 견적에 새는 경로 없음(088 formula 전용).

---

## 적재 GO 큐 요약 (load-executor 인계)

| 항목 | 내용 |
|---|---|
| 변경 | apply.sql 8행 (mint 5: 표지 comp/단가9000/공식/배선/089바인딩 · 부모 재배선 2: COVERBIND del + SSABARI ins · proc 격리 1: 088→PROC_000098 mand) |
| 골든 검증자 | golden-088.csv (1부 39,000 / 10부 290,000 / 100부 1,800,000) — 실엔진 재현 완료 |
| 멱등/undo | 2회 재적용 delta 0 · undo.sql 대칭 복원 확인 |
| 적재 前 조건[HARD] | ① 인간 승인 ② hsp-load-execution 단일 트랜잭션·단독 세션(comp_price_id MAX+1 동시성 가드) ③ webadmin 가격시뮬레이터 실화면 "제외 0·PRICE≠0" 확인(적재 후 오케/load-executor 몫) |
| traceability 큐(비블로커) | 9,000을 가격표_260702 출력소재 IMPORT 시트에 역반영(실무진) |
| 잔존 블로커(본 건 무관) | cover_mult ×2(링 표지 앞뒤 2장) = 엔진 C트랙(개발팀)·×1로 동작화(082/077 선례). 표지 저평가분은 ×2 구현 후 재계산. |

## 출처

- 라이브 읽기전용 SELECT(2026-07-02): t_prd_products·t_prd_product_sets·t_prd_product_price_formulas·t_prc_formula_components·t_prc_price_components·t_prc_component_prices·t_proc_processes·t_prd_product_processes·t_prd_product_discount_tables·information_schema
- 실엔진: raw/webadmin/webadmin/catalog/pricing.py (match_component·component_subtotal·evaluate_set_price 계약)
- DRY-RUN: _dryrun-088-twice.sql · _undo_symmetry.sql (BEGIN…ROLLBACK·COMMIT 0)
- 설계/codex: 03_design/088-redesign-260702/* · 04_codex/088-redesign/reconcile-088.md (독립 재판정 대상, 인용 아님)
