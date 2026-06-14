# Tier A 35상품 CPQ 옵션 레이어 적재 — 종합 (round-6 확대)

> 작성 2026-06-14 · 권위 = 본 문서 + 4 검증 게이트(`03_validation/cpq-tierA-*.md`) + 4 적재본(`09_load/_exec_tierA_*`). **DB 미적재 — 설계·검증·멱등 DRY-RUN까지. 실 COMMIT은 인간 승인.** [HARD] 쉬운 한국어, 식별자/SQL English.

## 0. 무엇을 했나

`25_load-readiness-scan` 기초완전 **Tier A 37상품** 중 이미 CPQ 적재된 일반현수막(138)·합판도무송(066은 stub만) 제외 → **실질 35상품**에 CPQ 옵션 레이어(option_groups → options → option_items → constraints → templates)를 설계·검증·멱등 적재본까지 산출. 옵션 구조(L1 시트)가 같은 **4 덩어리**로 분해, 각 덩어리 `dbm-option-mapper` 설계 → `dbm-validator` 독립 교차검증.

**공통 원칙 적용:**
- **disp_seq = L1 옵션성 컬럼 등장순서**(적재 3원칙 ⒜ — 엽서 파일럿이 누락했던 보강을 전 상품 적용).
- **FK 위상** 기초데이터(적재됨)→옵션그룹→옵션→옵션아이템→템플릿→제약(silsa 패턴).
- **option_item = 이미 적재된 차원행 포인터**. 트리거 `fn_chk_opt_item_ref` EXISTS 강제 → 차원 0행 = BLOCKED 분리 격리(차원 재적재 안 함).
- **멱등 INSERT … SELECT … WHERE NOT EXISTS(자연키)** + 단일 트랜잭션 + 롤백전용 DRY-RUN 2-pass(delta 0).

## 1. 덩어리별 집계 (전 덩어리 검증 통과)

| 덩어리 | 상품 | groups | options | items | constraints | INSERTABLE 합 | BLOCKED | 판정 |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **디지털인쇄** (엽서3·포토카드3·접지카드2·명함3·상품권2·전단지1) | 14 | 58 | 267 | 252 | 0 | **577** | 6 (item) | GO |
| **스티커** (반칼·투명·낱장·합판066보강) | 4 | 12 | 22 | 21 | 0 | **55** | 0 | GO |
| **책자** (중철·무선·트윈링·엽서북) | 4 | 32 | 140 | 140 | 0 | **312** | 0 | GO |
| **면적형** (포스터9·배너4, prn=0) | 13 | 20 | 31 | 24 | 7 | **82** | 11 (item) | GO* |
| **합계** | **35** | **122** | **460** | **437** | **7** | **1,026** | **17** | — |

\* 면적형: L2 순수 82행 + **L1 차원 LINK 3건 분리**(`_l1_link_preload.sql`, 인간 승인 — 139 끈 BUNDLE이 PROC_000084/081·MAT_000070 product-link 의존).

전 덩어리 라이브 롤백전용 DRY-RUN: 트리거 `fn_chk_opt_item_ref` 전건 통과(REJECT 0)·2-pass 멱등 delta 0·ROLLBACK 후 영구변경 0·COMMIT 0.

## 2. 적재 패키지 인덱스 (`09_load/`)

| 패키지 | 설계 문서(`10_configurator/tierA/`) | 검증 게이트(`03_validation/`) |
|---|---|---|
| `_exec_tierA_digitalprint/` | `digitalprint-option-layer.md` | `cpq-tierA-digitalprint-gate.md` (CONDITIONAL-GO→보정 GO) |
| `_exec_tierA_sticker/` | `sticker-option-layer.md` | `cpq-tierA-sticker-gate.md` (GO) |
| `_exec_tierA_booklet/` | `booklet-option-layer.md` | `cpq-tierA-booklet-gate.md` (GO·MINOR 문서보정) |
| `_exec_tierA_areaform/` | `areaform-option-layer.md` | `cpq-tierA-areaform-gate.md` (CONDITIONAL-GO→LINK분리 GO) |

각 패키지: `gen_load_sql.py`(생성기·손편집 금지)·`apply.sql`(FK 위상순 단일 트랜잭션)·`apply.sh`(기본 dryrun/ROLLBACK·`commit`은 인간 승인)·단계별 `NN_*.sql`·`load-manifest.md`·`blocked-and-gaps.md`·`load.provenance.csv`.

## 3. 인간 승인 큐 (실 COMMIT 전 결정 필요)

| # | 항목 | 위치 | 처리 |
|---|---|---|---|
| **A** | **L2 옵션레이어 1,026행 실 COMMIT** | 4 패키지 `apply.sh commit` | 백업→DRY-RUN→COMMIT→검증→멱등2회차 (silsa 패턴) |
| **B** | **테스트 더미 정리** — 016 후가공 더미(OPT-000005·OPV-)·025 `RULE_001` "금지테스트" | `_exec_tierA_digitalprint/_cleanup_dummy.sql` | 우리 코드체계와 분리·자동삭제 금지 |
| **C** | **066 고아 정리** — del_yn=Y stub `OPT-000004`·고아 `OPV-000006` | `_exec_tierA_sticker/_cleanup_dummy.sql` | 인간 승인 DELETE |
| **D** | **L1 차원 LINK 선적재** — 면적형 139 끈 BUNDLE(PROC_000084/081·MAT_000070 product-link) | `_exec_tierA_areaform/_l1_link_preload.sql` | 적재 후 139 끈 옵션 BLOCKED→INSERTABLE 승격 |
| **E** | **BLOCKED 차원 선적재** — 디지털인쇄 6(접지 공정 PROC_000065~068·화이트 별색공정) | `_exec_tierA_digitalprint/blocked-and-gaps.md` | 차원 L1 적재 or `dbm-ddl-proposer` |
| **F** | **GAP DDL 제안** — `ref_param_json`(공정 파라미터 보존)·print_options usage 분리(내지/표지)·거치대 template·GAP-HIDDEN(셋트 미노출) | 각 `blocked-and-gaps.md` | `dbm-ddl-proposer` |
| **G** | **[CONFIRM] 도메인 결정** — 094 셋트=생산BOM vs 사용자옵션·사이즈 OG UI 노출·종이 opt_nm 표시명·천정고리/거치대 base·화이트별색 공정코드 | 각 설계서 §설계결정 | 실무진/사용자 |

## 4. 교훈 (이번 확대)

- **추출 스냅샷 stale·라이브 권위**: postcard 파일럿이 BLOCKED로 본 종이·후가공 공정이 실제 라이브 적재되어 INSERTABLE 승격(K2/K3 stale 반증). BLOCKED 판정은 라이브 실측 권위.
- **disp_seq 보강 = L1 컬럼순서**: 엽서 파일럿의 임의 disp_seq를 전 상품 L1 등장순서로 정정(적재 3원칙 ⒜ 실행).
- **형제 상품 대조로 과소적재 검출**: PRD_000029 종이 13→14행(형제 027 14종과 대조, silent drop 적발).
- **opt_id↔print_side는 상품마다 다름**: 도수 고정 가정 금지(라이브 (opt_id, print_side) 실측 — 디지털인쇄 027/029 정정).
- **L1/L2 경계 엄수**: 면적형 139 끈이 차원 product-link(L1)를 L2 트랜잭션에 묶은 것 적발 → 별도 선적재 패키지 분리. "차원행을 새로 거는 것은 L2가 아니다."
- **생성자≠검증자 필수**: 4 검증 모두 독립 라이브 실측으로 재현, 디지털인쇄 1행 과소적재·면적형 L1 경계 위반을 검증이 적발.
- **코팅=자재 예외(스티커)**: 052/066 라이브 materials에 코팅이 소재행 합성(MAT_000155/156) — 다른 상품군 "코팅=공정"을 스티커에 적용 안 함(사용자 확정 준수).

## 5. 다음

1. **인간 승인 큐 A** (실 COMMIT) — 사용자 "GO분 안전 적재" 승인 시 4 패키지 순차 COMMIT.
2. **Tier B 가격결손 46상품** 가격 적재(round-2/16) → 완전화.
3. **Tier C 미흡 54상품** 기초데이터부터(굿즈/포토북/하드커버).
4. GAP DDL(F)·BLOCKED 차원 선적재(D/E)는 `dbm-ddl-proposer` 트랙.
