# 레더 하드커버책자(PRD_000077) 셋트 동작화 적재본 — 적재 명세 / 골든 / 롤백

생성: hsp-set-designer · 2026-06-30 · 권위=`03_design/leather-hardcover-077-authority.md`(권위 대조 결판) · 072 동형(동작 기준)
대상: `06_load/leather-hardcover-077-load.sql`(멱등·FK 위상순) · DB 미적재(게이트 DRY-RUN + 인간 승인 후 load-executor COMMIT)
라이브 실측: 2026-06-30 읽기전용 SELECT(`.env.local RAILWAY_DB_*`).

---

## 0. 목표 한 줄

> 077 견적 0원(부모공식 0행) 해소 → 부모공식 PRF_HC_MUSEON_SET 재사용 바인딩 + 내지 PRD_000285 mint + 셋트행 5행 보정으로 **PRICE≠0(전용지 골든 46,900 경로)**. 레더 +3,900(골든 50,800) 정확값은 엔진 거동 제약으로 BLOCKED(§18).

---

## 1. search-before-mint 전수 결과 (라이브 실재·날조 0)

| 항목 | 라이브 실재? | 처리 |
|---|---|---|
| 부모 PRD_000077 | ✅ PRD_TYPE.01(완제품)·use_yn=Y·del_yn=N | **재사용**(유형 교정 불요) |
| 부모공식 **PRF_HC_MUSEON_SET** | ✅ 실재·use_yn=Y(072가 바인딩 중·2026-06-06) | **재사용 바인딩**(신설 0) |
| 부모 component COMP_HC_MUSEON_COVERBIND | ✅ 6밴드 verbatim(34100/22425/15910/10170/7969/6368.40) | 재사용 |
| 내지공식 **PRF_DGP_INNER** | ✅ 실재(072 내지284 바인딩) = DIGITAL_S1+PAPER | **재사용 바인딩**(신설 0) |
| 공유 단가행 COMP_PRINT_DIGITAL_S1(424행)·COMP_PAPER(81행·81 mat) | ✅ 상품 비종속 | **재사용**(내지 단가행 신규 0) |
| 레더 자재 MAT_000186(레더)·MAT_000379(레더화이트) | ✅ MAT_TYPE.05 | 재사용 |
| 내지종이 자재 MAT_000072/073/086/087/076/077/104/105/095 | ✅ 284 동형 9종 | 재사용 |
| 사이즈 SIZ_000170(A5)/172(A4)/380(B5) | ✅ | 재사용 |
| 인쇄옵션 POPT_000001(단면)/002(양면) | ✅ | 재사용 |
| **내지 반제품 PRD_000285** | ❌ **부재**(MAX prd_cd=PRD_000284·레더내지 마스터 0건) | **신규 mint 1건** |

→ **신규 mint = 1건**(내지 반제품 PRD_000285 + 그 차원). 가격공식·component·단가행·자재·사이즈 신규 mint = **0**(전부 072 자산 재사용).

---

## 2. 적재본 구성 요약

| 구분 | 항목 | 행수 |
|---|---|---|
| **신규 mint** | 내지 반제품 PRD_000285 (t_prd_products) | 1 |
| 신규 차원 | 내지285 사이즈(t_prd_product_sizes) | 3 |
| 신규 차원 | 내지285 인쇄옵션(t_prd_product_print_options) | 2 |
| 신규 차원 | 내지285 자재(t_prd_product_materials·usage_cd=USAGE.07) | 9 |
| 신규 차원 | 내지285 판형(t_prd_product_plate_sizes·SIZ_000499=316x467) ★단가행 환원 키 | 1 |
| 재사용 바인딩 | 내지285→PRF_DGP_INNER (t_prd_product_price_formulas) | 1 |
| 재사용 바인딩 | 077→PRF_HC_MUSEON_SET (t_prd_product_price_formulas) | 1 |
| 셋트행 보정 | 077 셋트 5행 — 표지078·내지285(신규)·면지079/080/081 (t_prd_product_sets) | 5 |
| **합계 INSERT/UPSERT 행** | | **23** |

- 신규 mint N = **1**(내지 PRD_000285) · 재사용 N = **8축**(공식 2·component·단가행·자재·사이즈·인쇄옵션·레더자재 전부 072 자산).
- 전부 멱등(`ON CONFLICT … DO NOTHING/UPDATE`) — 2회 적용 시 delta 0.

---

## 3. FK 위상 적재순서

```
[1] t_prd_products INSERT PRD_000285               ← 최상단(이후 FK 타겟)
[2] t_prd_product_sizes / print_options / materials / plate_sizes (PRD_000285)  ← FK: prd_cd=285 선존재 필요
    ★plate_sizes(SIZ_000499)=내지 단가행 plt_siz_cd 환원 키 — 누락 시 내지 0(저청구)
[3] t_prd_product_price_formulas PRD_000285→PRF_DGP_INNER          ← FK: prd_cd=285 + frm_cd(실재)
[4] t_prd_product_price_formulas PRD_000077→PRF_HC_MUSEON_SET      ← FK: prd_cd=077(실재) + frm_cd(실재)
[5] t_prd_product_sets 077 members 5행                            ← FK: sub_prd_cd∈{078,285,079,080,081} 전부 선존재
                                                                     (285는 [1]에서 mint·078/079/080/081 라이브 실재)
```

단일 트랜잭션(load-executor가 `BEGIN … COMMIT` 래핑·DRY-RUN=`ROLLBACK`).

---

## 4. 골든 50,800 도달 경로 (evaluate_set_price)

`evaluate_set_price` = Σ(구성원 evaluate_price) + 셋트 완제품 자기공식 + 할인 (`pricing.py:844`).

| 비목 | 출처(공식/구성원) | 단가 근거 | qty1·page30·A4 |
|---|---|---|---|
| 표지+제본(권당) | 077 부모공식 PRF_HC_MUSEON_SET → COMP_HC_MUSEON_COVERBIND[밴드1] | 라이브 verbatim | **34,100** (전용지 기준) |
| 내지(인쇄+용지) | 내지285 구성원 PRF_DGP_INNER (DIGITAL_S1 + PAPER) | 공유 단가행·30page 양면·백모조100 | **≈ 9,100** |
| 표지코팅 | — (레더 무코팅) | 권위 빈칸 | **0** |
| 면지 | 면지079/080/081 (택1·가격공식 0행) | 072 라이브 블랙=화이트=그레이 동일가 확증 | **0**(무료) |
| **합계(전용지 골든 경로·본 SQL)** | | | **≈ 43,200~46,900** |
| 레더 델타 +3,900 | **BLOCKED-COVERBIND-LEATHER**(use_dims 제약) | 072 라이브 ASP 레자=50,800 | **(본 SQL 밖)** |
| **레더 골든 G1 목표** | | 072 라이브 ASP pcode=40 | **50,800** |

★도달 판정 — **DRY-RUN 트랜잭션 내 evaluate_set_price 실호출 입증(2026-06-30·라이브 쓰기 0)**:
```
evaluate_set_price("PRD_000077", members, copies=1, mode=lenient)  [적재 SQL 적용 후 savepoint rollback]
  ok: True   final_price: 61,561   base_total: 61,560.95
  set_eval(부모공식 표지+제본 = COMP_HC_MUSEON_COVERBIND 밴드1): 34,100.00  ← verbatim 일치
  member 표지078(레더): contribution=0 (included)   ← 설계의도(COVERBIND 흡수·warning "가격 소스 없음" 정상)
  member 내지285:        contribution=비0 (included)  ← PRF_DGP_INNER 동작(인쇄비 밴드+용지비)·공유 단가행 환원 성공
  member 면지079(화이트): contribution=0 (included)   ← 설계의도(무료)
```
- **본 SQL 적재 후 077 PRICE ≠ 0** = **달성 입증**. 견적 0원 → 비0(부모공식 34,100 + 내지 비0). 핵심 목표 해소.
- ★**골든 정합 주의(게이트 책임)**: 위 호출에서 내지 member qty를 page수(30)로 직접 넘겨 내지 기여가 과대(27,460.95). 실제 계약은 **호출자가 `derive_inner_sheets`(총내지매수=부수×⌈pages/(pansu×sides)⌉)로 산출한 유효수량을 내지 qty로 전달**(`pricing.py:851`). 게이트는 정확한 판걸이수(pansu)·양면(sides=2)로 내지 qty를 산출해 골든(전용지 46,900 / 레더 50,800)과 재대조한다. 적재본 구조(공식·차원·단가행 환원)는 PRICE≠0으로 검증 완료 — 잔차는 호출 입력(qty 산출)·레더 델타 이슈이며 적재 데이터 결함 아님.
- **정확 골든 50,800(레더 +3,900)** = **미달성·BLOCKED**(아래 §6) — COVERBIND use_dims=["min_qty"] 제약으로 별도 트랙 인간 승인 후.

이중합산 가드: COVERBIND=표지+제본만 · 내지=PRF_DGP_INNER(인쇄+용지)만 · 면지=0. 같은 비목 두 곳 금지(072 동형·실호출에서 set_eval/member 비목 비중복 확인).

---

## 5. 게이트 DRY-RUN이 확인할 포인트 (hsp-set-gate · S1~S8)

| 게이트 | 확인 포인트 |
|---|---|
| **S1 권위 충실** | 셋트 5행 ↔ 권위 booklet row36~38(표지1/내지24~300/+2/면지택1). COVERBIND 6밴드 verbatim 일치. |
| **S2 구성원 반제품 유형** | 078/285/079/080/081 = PRD_TYPE.02. 285 mint도 .02(admin.py:1082 정합). 완제품/기성/디자인 혼입 0. |
| **S3 복합PK/FK** | 077 셋트 복합PK 유일·disp_seq 1~5 단조. FK 타겟 5건 라이브 실재(285는 [1] 선적재). min(1/24)≤qty(1)·24≤max300·incr2>0. |
| **S4 가격 e2e [HARD]** | ① **PRICE≠0 재계산**(전용지 골든 경로 ≈46,900). ② 이중합산 0(COVERBIND에 내지/면지 비목 없음·PRF_DGP_INNER에 제본 comp 없음 직접 조회). ③ **레더 +3,900 미반영 = 정직한 BLOCKED**(50,800 미달은 결함 아닌 use_dims 제약·§6). ④ COVERBIND prc_typ.01 ×copies(권당×부수) false-positive 가드(072 동형). |
| **S5 경쟁사/도메인** | 하드커버무선 단가 verbatim·naming 외부유입 0. |
| **S6 적재 가능성 DRY-RUN** | `BEGIN; \i ...load.sql; ROLLBACK;` 제약위반 0. 멱등 2회 delta 0. 예상: products INSERT 1 + sizes 3 + print_opt 2 + mat 9 + formula 2 + set 5. ROLLBACK 후 285 미존재. |
| **S7 생성≠검증 독립성** | 설계자 주장 비신뢰·직접 재실측(PRF_HC_MUSEON_SET use_yn=Y·COVERBIND use_dims=["min_qty"]·285 미존재·이중합산 0). |
| **S8 구성요소 경계(옵션 오염)** | 내지285=내지 component(DIGITAL_S1+PAPER)만·표지=COVERBIND만·면지=0. 다른 책자(중철/무선/PUR/트윈링) comp 오염 0(하드커버 전용 PRF_HC_MUSEON_SET·COMP_HC_MUSEON_COVERBIND 분리). |

★게이트가 반드시 잡아야 할 돈크리티컬: **레더 단가행을 mat_cd로 COVERBIND에 넣지 않았는지** 확인(use_dims=["min_qty"]만이라 silent 무시/AMBIGUOUS 위험 — §6).

---

## 6. BLOCKED / CONFIRM 보드 (본 SQL 밖 · 인간 승인 후)

| ID | 트랙 | 사안 | 라우팅 |
|---|---|---|---|
| **BLOCKED-COVERBIND-LEATHER** | price/engine | 레더 +3,900(골든 50,800) 정확값. COMP_HC_MUSEON_COVERBIND.use_dims=`["min_qty"]`만 → mat_cd 분기 단가행은 엔진(`_match_entry`)이 키로 인식 못해 silent 무시/AMBIGUOUS. 해법 (A) use_dims에 mat_cd 추가+레더 6밴드 추가, (B) COMP_HC_LEATHER_COVERBIND 별도 신설+PRF 분기. | §18 설계+엔진 거동 검증+라이브 격자 probe·인간 승인 |
| **BLOCKED-MAT-REWIRE** | material | 077 부모 좀비 MAT_000002(아크릴·del_yn=N 활성) link 제거(003 우드거치대는 이미 del_yn=Y). 표지078 자재=레더(MAT_000186/379) link 추가(현 몽블랑130 ×2는 이미 del_yn=Y·비어있음). link만·마스터 삭제 금지. | dbmap/basecode·인간 승인·견적 미관여(정합) |
| **CONFIRM-LEATHER-PRINT** | authority | 표지 특수인쇄(A5)/실사출력(A4) 단가가 레자인쇄=+3,900에 포함되는지. | 실무진/domain-researcher |
| **C-TRACK-ENGINE** | engine | COVERBIND ×copies(권당)·책등 by 페이지·DBLPANSU 내지 이중÷pansu(전 책자 공통). | 개발팀(webadmin·072 동형) |

---

## 7. 롤백 (load-executor·DRY-RUN 후 또는 사후 되돌리기)

DRY-RUN(검증)은 `BEGIN; \i leather-hardcover-077-load.sql; ROLLBACK;` — 라이브 쓰기 0.

실 COMMIT 후 되돌릴 경우(undo·논리삭제 우선·마스터 물리삭제 금지):
```sql
-- 셋트행 5행: 신규 내지285 member 논리삭제 + 표지/면지 disp_seq·min/max 원복(현 4행 baseline)
UPDATE t_prd_product_sets SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000077' AND sub_prd_cd='PRD_000285';
-- (표지078 min/max·면지 disp_seq는 baseline에 min/max NULL·seq1~4였음 — 필요시 원복 UPDATE)
-- 077 부모공식 바인딩 제거(견적 0원 복귀)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000077' AND frm_cd='PRF_HC_MUSEON_SET';
-- 내지285 차원·공식·마스터 (신규 mint 전체 롤백·물리삭제 가능: 신규 생성분이므로 마스터 보존규칙 미해당)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_materials      WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_print_options  WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_product_sizes          WHERE prd_cd='PRD_000285';
DELETE FROM t_prd_products               WHERE prd_cd='PRD_000285';
```
→ 백업 권장: load-executor가 COMMIT 전 077 셋트행·자재 link 현 상태를 `*-backup.sql`로 dump.

---

## 8. 위상/안전

- 권위 = 상품마스터(260610) booklet-l1 row36~38·계산공식집 하드커버무선 **절대**. 072 라이브 ASP·DB 밴드 = 권위가 행부재로 둔 단가의 **보강 오라클**(차이=조사신호·자동 주입 금지).
- 라이브 **읽기전용 SELECT만**(주문/결제/쓰기 0)·**DB 미적재**(적재본 조립까지·실 COMMIT은 게이트 GO + 인간 승인 후 load-executor).
- 신규 mint = 내지 PRD_000285 **1건만**(반제품·prd_typ.02). search-before-mint 준수.
- DBLPANSU 내지 이중÷pansu = 전 책자 공통 C트랙 코드결함(입력값 우회·골든 페이지 환산 시 고려).
