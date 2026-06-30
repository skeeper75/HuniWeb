# 하드커버 링책자(PRD_000082) 셋트 동작화 적재본 — 적재 명세 / 골든 / 롤백

생성: hsp-set-designer · 2026-07-01 · 권위=`03_design/hardcover-ring-082-authority.md`(권위 대조 결판) · 072/077 동형(동작 기준)
대상: `06_load/hardcover-ring-082-load.sql`(멱등·FK 위상순) · DB 미적재(게이트 DRY-RUN + 인간 승인 후 load-executor COMMIT)
라이브 실측: 2026-07-01 읽기전용 SELECT(`.env.local RAILWAY_DB_*`).

---

## 0. 목표 한 줄

> 082 견적 0원(부모공식 0행) 해소 → **링 전용 부모공식 PRF_HC_TWINRING_SET 신설**(제본비=COMP_BIND_HC_TWINRING 재사용) + 내지 PRD_000286 mint + 셋트행 6행 보정으로 **PRICE≠0(제본 30,000 + 내지 ≈9,100 ≈ 39,100+ 경로)**. 표지/면지 인쇄·코팅 ×2 정확값은 단가행 부재로 BLOCKED(§18·077 +3,900 패턴 동형).

---

## 1. ★077 대비 핵심 차이 (전파 + 링 분기)

| 항목 | 077 레더(방금 COMMIT) | **082 링** | 차이 사유 |
|---|---|---|---|
| 부모공식 | **PRF_HC_MUSEON_SET 재사용**(무선·bundle) | **PRF_HC_TWINRING_SET 신설**(링·분해) | 링에 무선 재사용=S8 오염(무선 제본단가) |
| 부모 비목 | COMP_HC_MUSEON_COVERBIND(표지+제본 bundle 1밴드 34,100) | **COMP_BIND_HC_TWINRING**(제본비만·실재 6밴드·미바인딩) | 링은 표지+제본 합산 bundle 단가행 부재 |
| 내지 member | PRD_000285·page24~300/+2 | **PRD_000286·page8~100/+2** | 082 권위 페이지룰 다름 |
| 면지 | 3종(흰/검/회)·무료 보존 | **4종(흰/검/회/인쇄)·유료비목 CONFIRM** | 082 인쇄면지 추가·권위 면지 유료 명시 |
| 표지/면지 ×2 | 077=펼침×1(축 없음) | **앞뒤×2**(링=책등無)·단가행 BLOCKED | 권위 (3)~(6) ×2 명시 |
| 신규 mint | 1건(내지285) | **2건(내지286 + 부모공식 PRF_HC_TWINRING_SET)** + 비목배선 1 | 077=무선자산 100% 재사용 / 082=링 신설 |

→ **082 동작화를 막는 것은 ×2가 아니라 "링 전용 부모공식 부재 + 내지 member 부재"**. 본 SQL이 그 둘을 해소.

---

## 2. search-before-mint 전수 결과 (라이브 실재·날조 0·2026-07-01)

| 항목 | 라이브 실재? | 처리 |
|---|---|---|
| 부모 PRD_000082 | ✅ PRD_TYPE.01(완제품)·use_yn=Y·del_yn=N | **재사용**(유형 교정 불요) |
| **부모공식 PRF_HC_TWINRING_SET** | ❌ **부재**(PRF_HC_MUSEON_SET=무선·PRF_BIND_TWINRING=일반트윈링071용·COMP_BIND_TWINRING 배선) | **신규 mint(공식 1)** |
| **제본 component COMP_BIND_HC_TWINRING** | ✅ **실재·미바인딩**(6밴드 30000/20000/15000/10000/8000/7000·PROC_000024·use_dims=["proc_cd","min_qty","proc_grp:PROC_000017"]) | **재사용 배선** |
| 내지공식 PRF_DGP_INNER | ✅ 실재(072 내지284·077 내지285 바인딩)=DIGITAL_S1+PAPER | **재사용 바인딩**(신설 0) |
| 공유 단가행 COMP_PRINT_DIGITAL_S1(212밴드@plt499)·COMP_PAPER(81밴드@plt499) | ✅ 상품 비종속 | **재사용**(내지 단가행 신규 0) |
| 표지083·면지084~087 반제품 | ✅ 5건 전부 PRD_TYPE.02·use_yn=Y·del_yn=N | **재사용**(셋트행 보정만) |
| 내지종이 자재 9종·사이즈3·인쇄옵션2·판형 | ✅ 285 동형 실재 | 재사용 |
| **내지 반제품 PRD_000286** | ❌ **부재**(MAX prd_cd=PRD_000285·082 내지 0건·page8~100 전용) | **신규 mint 1건** |
| 링 표지/면지 인쇄·코팅 단가행 | ❌ 부재(072 표지=bundle 흡수·면지=무료) | **BLOCKED**(별도 트랙) |

→ **신규 mint = 2건**(① 내지 반제품 PRD_000286 ② 링 부모공식 PRF_HC_TWINRING_SET) + 비목배선 1행(COMP_BIND_HC_TWINRING). 단가행·component·자재·사이즈 신규 = **0**(COMP_BIND_HC_TWINRING/PRF_DGP_INNER/공유단가행 전부 재사용). ★077(mint 1)보다 +1(링 부모공식).

---

## 3. 적재본 구성 요약 (INSERT/UPSERT 행)

| 구분 | 항목 | 행수 |
|---|---|---|
| **신규 mint** | 링 부모공식 PRF_HC_TWINRING_SET (t_prc_price_formulas) | 1 |
| **신규 배선** | 부모공식 비목 COMP_BIND_HC_TWINRING (t_prc_formula_components) | 1 |
| **신규 mint** | 내지 반제품 PRD_000286 (t_prd_products) | 1 |
| 신규 차원 | 내지286 사이즈(t_prd_product_sizes) | 3 |
| 신규 차원 | 내지286 인쇄옵션(t_prd_product_print_options) | 2 |
| 신규 차원 | 내지286 자재(t_prd_product_materials·usage_cd=USAGE.07) | 9 |
| 신규 차원 | 내지286 판형(t_prd_product_plate_sizes·SIZ_000499) ★단가행 환원 키 | 1 |
| 재사용 바인딩 | 내지286→PRF_DGP_INNER (t_prd_product_price_formulas) | 1 |
| 신규 바인딩 | 082→PRF_HC_TWINRING_SET (t_prd_product_price_formulas) | 1 |
| 셋트행 보정 | 082 셋트 6행 — 표지083·내지286(신규)·면지084/085/086/087 (t_prd_product_sets) | 6 |
| **합계 INSERT/UPSERT 행** | | **27** |

- 전부 멱등(`ON CONFLICT … DO NOTHING/UPDATE`) — **DRY-RUN 2회 적용 시 2회차 전부 `INSERT 0 0`(delta 0) 입증 완료**.

---

## 4. FK 위상 적재순서 (DRY-RUN 검증 완료)

```
[0]  t_prc_price_formulas INSERT PRF_HC_TWINRING_SET           ← 부모공식 신설(이후 FC·바인딩 FK 타겟)
[0b] t_prc_formula_components PRF_HC_TWINRING_SET→COMP_BIND_HC_TWINRING  ← FK: frm_cd[0]+comp_cd(실재)
[1]  t_prd_products INSERT PRD_000286                          ← 내지 반제품(이후 차원 FK 타겟)
[2]  t_prd_product_{sizes,print_options,materials,plate_sizes}(286)  ← FK: prd_cd=286 선존재
     ★plate_sizes(SIZ_000499)=내지 단가행 plt_siz_cd 환원 키 — 누락 시 내지 0(저청구)
[3]  t_prd_product_price_formulas 286→PRF_DGP_INNER            ← FK: prd_cd=286+frm_cd(실재)
[4]  t_prd_product_price_formulas 082→PRF_HC_TWINRING_SET      ← FK: prd_cd=082(실재)+frm_cd[0]
[5]  t_prd_product_sets 082 members 6행                        ← FK: sub_prd∈{083,286,084,085,086,087} 전부 선존재
                                                                 (286은 [1]에서 mint·083~087 라이브 실재)
```

단일 트랜잭션(load-executor가 `BEGIN … COMMIT` 래핑·DRY-RUN=`ROLLBACK`).

---

## 5. 골든 도달 경로 (evaluate_set_price·PRICE≠0 입증)

`evaluate_set_price` = Σ(구성원 evaluate_price) + 셋트 완제품 자기공식(set_eval) + 할인 (`pricing.py:844`).

| 비목 | 출처 | 단가 근거 | qty1·page30·A5 |
|---|---|---|---|
| 제본비(set_eval) | 082 부모공식 PRF_HC_TWINRING_SET → COMP_BIND_HC_TWINRING[PROC_000024·밴드1] | 라이브 verbatim | **30,000** |
| 내지(인쇄+용지) | 내지286 구성원 PRF_DGP_INNER (DIGITAL_S1 + PAPER) | 공유 단가행·page30 양면·plt SIZ_000499 | **≈ 9,100** |
| 표지인쇄·표지코팅 ×2 | — (단가행 부재) | **BLOCKED-COVER-MYUNJI-PRINT** | (본 SQL 밖) |
| 면지인쇄·면지코팅 ×2 | 면지084~087(택1·가격공식 0행) | ★유료비목 CONFIRM | **0**(현 무료·BLOCKED) |
| **합계(제본+내지 골든 경로·본 SQL)** | | | **≈ 39,100+ 비0** |

★도달 판정 — **SQL DRY-RUN 결정론 입증(2026-07-01·라이브 쓰기 0·`BEGIN; \i load.sql; ...; ROLLBACK;`)**:
- 부모공식 PRF_HC_TWINRING_SET·비목 COMP_BIND_HC_TWINRING(addtn_yn=Y) 배선 확인 → set_eval 제본비 **30,000**(PROC_000024 밴드1) 매칭 가능.
- 내지286 PRF_DGP_INNER 비목 DIGITAL_S1+PAPER 둘 다 plt_siz_cd=SIZ_000499 단가행 실재(인쇄 212밴드·용지 81밴드) → 내지 **PRICE≠0** 보증(077 내지285 동일 환원 성공 경로).
- → **082 PRICE ≠ 0 = 달성**(견적 0원 → ≈39,100+). 핵심 목표 해소.
- ★**게이트가 evaluate_set_price 실호출로 재확인**(설계가 환경에 Django 미설치 — SQL 결정론 매칭으로 대체 입증). 게이트는 내지 qty를 `derive_inner_sheets(copies, pages, pansu, sides=2)`로 산출해 전달(`pricing.py:851`).

이중합산 가드(S8): set_eval=제본(COMP_BIND_HC_TWINRING)만 · 내지=PRF_DGP_INNER(인쇄+용지)만 · 면지=0. 같은 비목 두 곳 금지. **DRY-RUN에서 부모공식에 무선 COVERBIND·일반 COMP_BIND_TWINRING 미배선 확인(오염 카운트=0)**.

---

## 6. 게이트 DRY-RUN이 확인할 포인트 (hsp-set-gate · S1~S8)

| 게이트 | 확인 포인트 |
|---|---|
| **S1 권위 충실** | 셋트 6행 ↔ 권위 booklet row37~41(표지1/내지8~100/+2/면지택1·4종). COMP_BIND_HC_TWINRING 6밴드 verbatim. |
| **S2 구성원 반제품 유형** | 083/286/084/085/086/087 = PRD_TYPE.02. 286 mint도 .02(admin.py:1082 정합). 완제품/기성/디자인 혼입 0. |
| **S3 복합PK/FK** | 082 셋트 복합PK 유일·disp_seq 1~6 단조. FK 타겟 6건 라이브 실재(286은 [1] 선적재). min8≤max100·incr2>0. |
| **S4 가격 e2e [HARD]** | ① **PRICE≠0 재계산**(제본 30,000 + 내지 ≈9,100 ≈ 39,100+). ② 이중합산 0(set_eval=제본만·내지=인쇄+용지·면지=0). ③ **표지/면지 ×2 미반영 = 정직한 BLOCKED**(저청구 잔존하나 0원 아님·단가행 부재·§7). ④ COMP_BIND_HC_TWINRING ×copies(권당×부수) false-positive 가드. |
| **S5 경쟁사/도메인** | 하드커버트윈링 단가 verbatim·naming 외부유입 0. |
| **S6 적재 가능성 DRY-RUN** | `BEGIN; \i ...load.sql; ROLLBACK;` 제약위반 0(✅ 검증). 멱등 2회 delta 0(✅ INSERT 0 0). ROLLBACK 후 286 미존재(✅). |
| **S7 생성≠검증 독립성** | 설계자 주장 비신뢰·직접 재실측(PRF_HC_TWINRING_SET 신설·COMP_BIND_HC_TWINRING use_dims·286 미존재·이중합산 0). |
| **S8 구성요소 경계(옵션 오염)** | ★링 부모공식=COMP_BIND_HC_TWINRING(링 제본)만·**무선 COMP_HC_MUSEON_COVERBIND·일반 COMP_BIND_TWINRING(071) 미배선(✅ 오염 0)**. 내지=DIGITAL_S1+PAPER만·표지/면지=0. 다른 책자(중철/무선/PUR/일반트윈링) comp 오염 0. |

★게이트가 반드시 잡아야 할 돈크리티컬: **(a)** 링에 무선 제본단가 silent 적용 안 됐는지(부모공식 비목 = COMP_BIND_HC_TWINRING 단 1개 확인). **(b)** 표지/면지 ×2 비목이 단가행 없이 silent 0인지 = 정직한 BLOCKED(결함 아닌 단가행 부재).

---

## 7. BLOCKED / CONFIRM 보드 (본 SQL 밖 · 인간 승인 후)

| ID | 트랙 | 사안 | 라우팅 |
|---|---|---|---|
| **BLOCKED-COVER-MYUNJI-PRINT** | price/engine | 표지인쇄·표지코팅·면지인쇄·면지코팅 비목(권위 (3)~(6)·전부 ×2). 라이브에 링 표지/면지 인쇄·코팅 단가행 부재(072 표지=COVERBIND bundle 흡수·면지=무료). 해법: COMP_PRINT_COVER_*·COMP_COAT_COVER_*·COMP_PRINT_MYUNJI_* 단가행 신설 + PRF_HC_TWINRING_SET 비목 배선. | §18 설계 + 082 라이브 ASP 골든 역산 + 인간 승인 |
| **BLOCKED-COVERMULT-X2** | price/engine | 표지/면지 ×2(앞뒤 물리 2장·링=책등無). 권고=단가행 2매분 내재(데이터 흡수). 엔진 ×2 곱셈 경로 미지원([[booklet-cover-branch-design-260630]]). | §18 설계(단가행 ×2) 또는 개발팀(엔진). 동작화 막지 않음 |
| **CONFIRM-MYUNJI-PAID** | authority | 082 면지=유료 비목(권위 면지인쇄·코팅 ×2 명시) vs 072 면지=무료(라이브 동형). 면지 종류별 단가·인쇄면지(087) 추가단가. | domain-researcher/실무진·082 라이브 ASP 역산 |
| **BLOCKED-MAT-REWIRE** | material | 082 부모 좀비 자재 link(MAT_000246/001/013/002/014/015/004 활성·MAT_000003만 del_yn=Y·072/077 동형 오염 가능). 표지083 자재=전용지 배선(현 0행)·면지 정자재. | dbmap/basecode·link만(마스터 삭제 금지)·견적 미관여·인간 승인 |
| **C-TRACK-ENGINE** | engine | COMP_BIND_HC_TWINRING ×copies(권당)·책등 by 페이지·DBLPANSU 내지 이중÷pansu·cover_mult ×2 곱셈(전 책자 공통). 입력값 우회 명시. | 개발팀(webadmin·072 동형) |

---

## 8. 롤백 (load-executor·DRY-RUN 후 또는 사후 되돌리기)

DRY-RUN(검증)은 `BEGIN; \i hardcover-ring-082-load.sql; ROLLBACK;` — 라이브 쓰기 0(검증 완료).

실 COMMIT 후 되돌릴 경우(undo·논리삭제 우선·마스터 물리삭제 금지·신규 mint는 물리삭제 가능):
```sql
-- 셋트행: 신규 내지286 member 논리삭제 + 면지 disp_seq 원복(현 baseline 5행·seq1~5)
UPDATE t_prd_product_sets SET del_yn='Y', del_dt=now() WHERE prd_cd='PRD_000082' AND sub_prd_cd='PRD_000286';
-- (표지083 min/max·면지 disp_seq는 baseline에 min/max NULL·seq1~5였음 — 필요시 원복 UPDATE)
-- 082 부모공식 바인딩 제거(견적 0원 복귀)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000082' AND frm_cd='PRF_HC_TWINRING_SET';
-- 내지286 차원·공식·마스터 (신규 mint 전체 롤백·물리삭제 가능)
DELETE FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_plate_sizes    WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_materials      WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_print_options  WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_product_sizes          WHERE prd_cd='PRD_000286';
DELETE FROM t_prd_products               WHERE prd_cd='PRD_000286';
-- 링 부모공식 신설분 (다른 상품 미사용 시·082 전용)
DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_HC_TWINRING_SET';
DELETE FROM t_prc_price_formulas     WHERE frm_cd='PRF_HC_TWINRING_SET';
```
→ 백업 권장: load-executor가 COMMIT 전 082 셋트행·자재 link 현 상태를 `*-backup.sql`로 dump.

---

## 9. 위상/안전

- 권위 = 상품마스터(260610) booklet-l1 row37~41·계산공식집 하드커버링책자(L81~89) **절대**. COMP_BIND_HC_TWINRING DB 밴드·082/071 라이브 ASP = 권위가 행부재로 둔 단가의 **보강 오라클**(차이=조사신호·자동 주입 금지·§18 설계+인간 승인).
- 라이브 **읽기전용 SELECT만**(주문/결제/쓰기 0)·**DB 미적재**(적재본 조립까지·실 COMMIT은 게이트 GO + 인간 승인 후 load-executor).
- 신규 mint = **2건**(내지 PRD_000286·반제품 prd_typ.02 / 링 부모공식 PRF_HC_TWINRING_SET) + 비목배선 1. search-before-mint 준수(무선 부모 재사용=S8 오염 금지).
- 088 레더 링바인더 = 082 동형 미동작 셋트(표지=레더·면지 인쇄면지 포함) → 082 패턴 동형 전파 가능.
- cover_mult ×2·표지/면지 인쇄·코팅 단가 = 동작화 막지 않음(077 +3,900 별도 트랙 동형)·BLOCKED 분리(저청구 잔존하나 0원 아님).
