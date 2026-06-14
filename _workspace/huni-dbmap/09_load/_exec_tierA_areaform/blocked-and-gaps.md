# BLOCKED & GAP — Tier A 면적형 13상품 CPQ 옵션레이어

> 생성 2026-06-14 (FINDING-1 보정 반영). BLOCKED = 차원행 미링크/미존재 또는 **L1 차원 LINK 선적재 의존**으로 트리거 EXISTS 위반 → 본 L2 적재 격리(차원행/LINK 재적재 안 함·발명 금지). GAP = 라이브 컬럼/엔티티 부재 → `dbm-ddl-proposer`.

## 0. [FINDING-1 보정] L1/L2 경계 일관성 (MAJOR 해소)

dbm-validator 적발: 139 끈 BUNDLE의 product-link 선적재(`t_prd_product_materials/processes` INSERT)는 **L1 차원행 생성**이다 — L2 옵션 트랜잭션에 묶으면 경계 위반이고, 124/133/134/135 복합끈은 BLOCKED로 격리하면서 139만 LINK로 처리한 것은 **처리 불일치**다.

**보정 조치:**
1. **L1 차원 LINK INSERT 3건을 `apply.sql`(L2 순수)에서 분리** → `_l1_link_preload.sql`(별도 패키지·"L1 차원 선적재·인간 승인 필요" 라벨). `apply.sql`은 L1 차원행을 생성하지 않음(DRY-RUN으로 139 product-link BEFORE==AFTER 실증).
2. **139 LINK 의존 옵션을 BLOCKED로 일관 처리** — "재단만"(PROC_000084 미링크)·"끈추가"(MAT_000070+PROC_000081 미링크) = 124/133/134/135 복합끈과 동일하게 BLOCKED 격리. L1 LINK 선적재(인간 승인) 후 INSERTABLE 승격(조건부). 139 "타공4/6/8"은 PROC_000079 **기존 링크** → INSERTABLE 유지, "추가없음"은 센티넬 → INSERTABLE.

> **처리 일관성 근거:** "차원/LINK가 라이브 product에 미링크면 BLOCKED" 단일 규칙으로 통일. LINK 대상이 라이브 차원(mint 불요)이라도 product-link INSERT는 L1 작업이므로 L2 적재 밖. 139만 예외로 LINK 처리하던 불일치 제거.

## 1. BLOCKED options (11건 — 본 L2 적재 미관여)

| prd_cd | prd_nm | BLOCKED option | 필요 차원행 | 사유 | 해소 |
|---|---|---|---|---|---|
| 124 | 린넨패브릭포스터 | 오버로크+리본끈 | .03 리본끈 자재 | 리본끈 자재 라이브 0행(GAP-RIBBON) | 리본끈 자재 mint+124 링크(인간 승인) |
| 124 | 린넨패브릭포스터 | 말아박기+면끈 | .03 면끈 자재 | 면끈 자재(MAT_000224 등) 124 product_material 미링크 | 면끈 자재 124 링크 |
| 133 | 캔버스행잉포스터 | 우드행거+면끈 포함 | .03 우드행거(MAT_000229)+면끈 | 133 미링크 | 우드행거/면끈 133 링크 |
| 134 | 린넨우드봉족자 | 우드봉+면끈 포함 | .03 우드봉(MAT_000225)+면끈 | 134 미링크 | 우드봉/면끈 134 링크 |
| 135 | 족자포스터 | 천정형고리 포함 | .03 자재 or .07 셋트 | 천정고리 자재(MAT_000215) vs 셋트(PRD_000008) [CONFIRM]·135 미링크 | 귀속 결정 + 링크 |
| 136 | PET배너 | 실내용배너거치대 | template (addon) | 거치대 상품 라이브 미발견(GAP-ADDON-STAND) | 거치대 상품/template base 결정 |
| 136 | PET배너 | 실외용배너거치대 | template | 동상 | 동상 |
| 137 | 메쉬배너 | 실내용배너거치대 | template | 동상 | 동상 |
| 137 | 메쉬배너 | 실외용배너거치대 | template | 동상 | 동상 |
| **139** | **메쉬현수막** | **재단만** | .04 열재단(PROC_000084) | **L1 LINK 의존: PROC_000084 139 product-process 미링크 [FINDING-1]** | `_l1_link_preload.sql` 적재(인간 승인) → INSERTABLE 승격 |
| **139** | **메쉬현수막** | **끈추가** | .03 끈(MAT_000070)+.04 부착(PROC_000081) | **L1 LINK 의존: MAT_000070+PROC_000081 139 미링크 [FINDING-1]** | `_l1_link_preload.sql` 적재(인간 승인) → INSERTABLE 승격 |

> BLOCKED option은 option_group/option(센티넬 외)도 본 L2 적재에서 **미생성** — 차원행/LINK 선적재 후 별도 패키지로 적재. "코팅없음/추가없음/출력만/거치대없음" 센티넬은 item 0행이라 INSERTABLE(적재됨). 139는 BLOCKED된 "재단만" 대신 "타공(4개)"를 dflt로 승격.

## 2. GAP (→ dbm-ddl-proposer)

| GAP | 내용 | 영향 상품 | 라이브 권위 | 처리 |
|---|---|---|---|---|
| **GAP-PARAM** | `ref_param_json` 미구현 → 가공 param(타공 구수 4/6/8·봉제 유형·족자 모양·봉미싱 폭) 보존 불가. option_item은 공정행만 가리킴(타공 4/6/8 = PROC_000079 동일행 3 option, 구수 구분 소실) | 124/134/135/136/137/139 | cpq-schema §4 🔴8 | 공정 1행+param vs 공정 N행 복제 |
| **GAP-ADDON-STAND** | 실내용/실외용배너거치대 라이브 상품 미존재 → template base_prd_cd 미정 | 136/137 | 라이브 실측 0행 | 거치대 상품 선등록 vs 가격만 template |
| **GAP-BUNDLE-LINK** | +끈/+면끈/+우드행거/+우드봉/+천정고리 BUNDLE 자재가 해당 상품에 product_material 미링크 → 트리거 .03 위반 | 124/133/134/135 | 라이브 실측 | L1 자재 링크 선적재(인간 승인) |
| **GAP-RIBBON** | 리본끈 자재 라이브 0행 (124 오버로크+리본끈) | 124 | 라이브 실측 0행 | 자재 mint vs 면끈 통합 [CONFIRM] |

## 3. 설계 결정 필요 ([CONFIRM] — 침묵 선택 금지)

1. **천정형고리(135) = 자재(MAT_000215) vs 셋트(PRD_000008 천정고리)** — 둘 다 라이브 존재. set(.07)이면 sub_prd_cd=PRD_000008, 자재(.03)면 mat_cd=MAT_000215+135 링크.
2. **실내/실외 배너거치대 base 상품** — 라이브 미발견. 기존 거치대 상품(PRD_000012 우드거치대)과 동일물인지/신규인지.
3. **+면끈 자재 귀속** — MAT_000224~231(270mm+면끈 등)은 복합 자재명. 우드행거+면끈을 한 자재로 볼지, 2자재 BUNDLE로 볼지.
4. **리본끈(124)** — mint vs 면끈 통합.
5. **134 오버로크+봉미싱 복합유형** — 봉제 유형 enum 단일값. 2공정 동반 → 본 설계는 공정 1행(봉제) 1 item으로 적재(param=GAP). 봉제 2 item_seq 분리 여부 [CONFIRM].

> [HARD] 발명 금지. 라이브 실부재 기반 BLOCKED·[CONFIRM] 정직 표기. 차원 재적재 안 함.
