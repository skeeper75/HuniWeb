# manifest.md — RC-2 추가물형(비BLOCKED) 적재 매니페스트

> dbm-load-builder · 2026-06-23 · §21 RC-2. DB 미적재(롤백전용 DRY-RUN까지)·단가 verbatim·search-before-mint·날조 0.
> 입력 명세 = `_workspace/huni-catalog-conformance/03_cpq_link/rc2-addon-load-spec-unblocked.md` (전 행 정독).
> 참조 패턴 = `_workspace/huni-dbmap/09_load/_rc2_banner_260623/` (일반현수막 RC-2 COMMIT 동형).
> 라이브 재실측 일시 = 2026-06-23 (psql 읽기전용 SELECT). **명세 주장 전건 라이브 직접 검증·불일치 0.**

## 0. 대상·제외

| | 상품 | prd_cd | 추가물 | 본체 공식(라이브 확정) |
|---|---|---|---|---|
| ✅ | 메쉬현수막 | PRD_000139 | 큐방(4개)·끈(4개) | PRF_POSTER_BANNER_M |
| ✅ | 캔버스행잉 | PRD_000133 | 우드행거+면끈 (★RC-4 siz_cd 재배선) | PRF_POSTER_CANVAS_HANGING |
| ✅ | 린넨우드봉 | PRD_000134 | 우드봉+면끈 | PRF_POSTER_LINEN_WOODBONG |
| ⛔ | **PET배너** | PRD_000136 | 거치대 S1/S2 | **제외 — HOLD-1 BLOCKED**(명세 §4.2 모델링 CONFIRM 미해소) |

PET(136) 관련 opt_cd(OPV_000427/428)·comp(STAND_OUT_S1/S2/IN)·OPV-000019·단가행은 적재본에서 **전부 제외**.
option_item 환원행(MES)은 자재행 선등록 HOLD-2/3 종속이고 **가격 무영향** → 본 적재본에서 제외(가격 정합은 옵션+use_dims+단가행+바인딩만으로 달성).

## 1. 라이브 재실측 결과 (명세 주장 vs 실측 — 전건 일치)

| 검증 항목 | 명세 주장 | 라이브 실측 SQL | 결과 |
|---|---|---|---|
| opt_cd 채번 여유 | MAX=OPV_000424 | `SELECT opt_cd FROM t_prd_product_options WHERE opt_cd ~ '^OPV_[0-9]{6}$' ORDER BY opt_cd DESC LIMIT 1` → OPV_000424 | ✅ 일치·신규 425/426/429/430 충돌 0 |
| 메쉬 그룹 disp MAX | OPT_000023=1 | 139 OPV_000045(추가없음) seq=1 | ✅ 신규 큐방=2·끈=3 |
| 캔버스 그룹 disp MAX | OPT_000012=1 | 133 OPV_000030(출력만) seq=1 | ✅ 신규 우드행거=2 |
| 린넨 그룹 disp MAX | OPT_000014=1 | 134 OPV_000032(출력만) seq=1 | ✅ 신규 우드봉=2 |
| comp use_dims 현재 | 메쉬 []·캔버스/린넨 [siz_cd] | 4 comp SELECT use_dims | ✅ 일치 |
| 메쉬 단가행 | 큐방 3000·끈 4000·opt_cd NULL | 4751=3000·4753=4000·opt_cd NULL | ✅ always-add 결함 확인 |
| 캔버스 우드행거 단가행 | 4598/4599/4600·siz 258/315/317·16000/18000/20000 | 동일 | ✅ RC-4 대상 확정 |
| 린넨 우드봉 단가행 | 4604/4605/4606·siz 258/315/317 (134 등록 정합) | 4604=7000·4605=9800·4606=12000 | ✅ 재배선 불요 |
| frm_cd 3종 | BANNER_M·CANVAS_HANGING·LINEN_WOODBONG | `t_prd_product_price_formulas` SELECT | ✅ 일치 |
| 기존 바인딩 disp MAX | 1 (본체 comp) | 3 공식 각 disp=1 | ✅ 신규 disp=2 |
| 바인딩 충돌 | 0 | 대상 4 comp 바인딩 0행 | ✅ |
| RC-4 치수 대조 | 258↔172 / 315↔174 / 317↔197 동일 등급 | A4(210x297)/A3(297x420)/A2(420x594) 일치 | ✅ |
| comp_cd 길이 | ≤50 | 최장 40자 | ✅ G4 통과 |
| FK 부모 실재 | 그룹·frm_cd·comp_cd | (prd,grp) 3쌍·3 frm_cd·4 comp 전건 실재 | ✅ G5 통과 |
| 트리거 위험 | option_items만 fn_chk_opt_item_ref | options=upd_dt만(INSERT 무트리거)·item 미적재 | ✅ 위험 0 |

## 2. 적재 체인 (FK 위상순서 — 23행)

| step | 파일 | 대상 t_* | op | 행수 | FK 위상 근거 |
|---|---|---|---|---|---|
| 01 | `01_options.sql` | t_prd_product_options | INSERT | 4 | 부모=(prd_cd,opt_grp_cd) 그룹 실재(선결) |
| 02 | `02_use_dims.sql` | t_prc_price_components | UPDATE | 4 | comp 실재(기존)·always-add 가드 opt_cd 충전 |
| 03 | `03_price_fill.sql` | t_prc_component_prices | UPDATE | 11 | ⓐopt_cd 8행 + ⓑRC-4 siz_cd 3행·단가 verbatim |
| 04 | `04_formula_components.sql` | t_prc_formula_components | INSERT(UPSERT) | 4 | 부모=frm_cd·comp_cd 실재(선결)·addtn_yn=Y |

**합계 = 23행** (INSERT 8 [옵션4+바인딩4] · UPDATE 15 [use_dims4+opt_cd8+siz3]).

### 2.1 전 행 1:1 매핑 (현재값 ↔ 설계값)

| 행 | 대상 | 자연키/PK | 현재값 | → 설계값 | 단가(verbatim) |
|---|---|---|---|---|---|
| 1 | options | (139,OPV_000425) | 없음 | 큐방(4개)추가·grp OPT_000023·seq 2 | — |
| 2 | options | (139,OPV_000426) | 없음 | 끈(4개)추가·grp OPT_000023·seq 3 | — |
| 3 | options | (133,OPV_000429) | 없음 | 우드행거+면끈 추가·grp OPT_000012·seq 2 | — |
| 4 | options | (134,OPV_000430) | 없음 | 우드봉+면끈 추가·grp OPT_000014·seq 2 | — |
| 5 | use_dims | MESH_ADD_QBANG_4 | `[]` | `[opt_cd, opt_grp:OPT_000023]` | — |
| 6 | use_dims | MESH_ADD_STRING_4 | `[]` | `[opt_cd, opt_grp:OPT_000023]` | — |
| 7 | use_dims | CANVAS_HANGING_WOODHANGER | `[siz_cd]` | `[opt_cd, siz_cd, opt_grp:OPT_000012]` | — |
| 8 | use_dims | LINEN_WOODBONG_WOODBONG | `[siz_cd]` | `[opt_cd, siz_cd, opt_grp:OPT_000014]` | — |
| 9 | price opt_cd | id=4751 | opt_cd NULL | opt_cd=OPV_000425 | 3000.00 불변 |
| 10 | price opt_cd | id=4753 | opt_cd NULL | opt_cd=OPV_000426 | 4000.00 불변 |
| 11 | price opt_cd | id=4598 | opt_cd NULL | opt_cd=OPV_000429 | 16000.00 불변 |
| 12 | price opt_cd | id=4599 | opt_cd NULL | opt_cd=OPV_000429 | 18000.00 불변 |
| 13 | price opt_cd | id=4600 | opt_cd NULL | opt_cd=OPV_000429 | 20000.00 불변 |
| 14 | price opt_cd | id=4604 | opt_cd NULL | opt_cd=OPV_000430 | 7000.00 불변 |
| 15 | price opt_cd | id=4605 | opt_cd NULL | opt_cd=OPV_000430 | 9800.00 불변 |
| 16 | price opt_cd | id=4606 | opt_cd NULL | opt_cd=OPV_000430 | 12000.00 불변 |
| 17 | price siz RC-4 | id=4598 | SIZ_000258 | SIZ_000172 (A4) | 16000.00 불변 |
| 18 | price siz RC-4 | id=4599 | SIZ_000315 | SIZ_000174 (A3) | 18000.00 불변 |
| 19 | price siz RC-4 | id=4600 | SIZ_000317 | SIZ_000197 (A2) | 20000.00 불변 |
| 20 | bind | (BANNER_M,MESH_ADD_QBANG_4) | 없음 | addtn_yn=Y·seq 2 | — |
| 21 | bind | (BANNER_M,MESH_ADD_STRING_4) | 없음 | addtn_yn=Y·seq 3 | — |
| 22 | bind | (CANVAS_HANGING,CANVAS_HANGING_WOODHANGER) | 없음 | addtn_yn=Y·seq 2 | — |
| 23 | bind | (LINEN_WOODBONG,LINEN_WOODBONG_WOODBONG) | 없음 | addtn_yn=Y·seq 2 | — |

> 행 11~13(opt_cd 충전)과 17~19(siz_cd 재배선)는 동일 단가행(4598/4599/4600)에 대한 2속성 갱신 — 둘 다 같은 UPDATE 대상이나 단가행 1행당 opt_cd·siz_cd가 별 UPDATE문(멱등 분리).

## 3. 멱등성 근거

| 단계 | 가드 | 2-pass 입증 |
|---|---|---|
| 01 옵션 INSERT | `WHERE NOT EXISTS (... PK 일치)` | PASS2 = INSERT 0 0 |
| 02 use_dims UPDATE | `use_dims IS DISTINCT FROM 설계값::jsonb` | PASS2 = UPDATE 0 |
| 03 opt_cd UPDATE | `unit_price = verbatim AND opt_cd IS DISTINCT FROM 신규` | PASS2 = UPDATE 0 |
| 03 siz_cd UPDATE | `unit_price = verbatim AND siz_cd IS DISTINCT FROM new AND siz_cd IN (cur,new)` | PASS2 = UPDATE 0·오행 보호 |
| 04 바인딩 UPSERT | `ON CONFLICT DO UPDATE WHERE addtn_yn/disp_seq DISTINCT` | PASS2 = INSERT 0 0 |

`apply_ymd` 분기 없음(전 단가행 기존 apply_ymd='2026-06-01' 유지·신규 단가행 INSERT 0 → 이중계상 함정 무관).
`reg_dt` NOT NULL DEFAULT now() 명시 충전(옵션·바인딩 INSERT). IDENTITY 시퀀스 무관(comp_price_id 신규 발번 없음·기존 PK UPDATE만).

## 4. 잔존 BLOCKED/HOLD (적재본 제외 — 명세 §4.2)

- **HOLD-1 PET S1/S2** (BLOCKED): OPT-000009 그룹 모델링 충돌(실외용거치대 OPV-000020 vs 단면/양면). 실무진 CONFIRM 후 별 트랙.
- **HOLD-2 메쉬 큐방 자재 환원**: MAT_000337 139 미등록 → option_item 자재 환원 HOLD. **가격 무영향**(본 적재본 가격 정합 완비).
- **HOLD-3 캔버스/린넨 우드 자재 환원**: 우드 부속 자재 미확정·133/134 미등록 → option_item 자재 환원 HOLD. **가격 무영향**.
- option_item(MES 환원) 일체 본 적재본 제외 — 자재행 선등록 후 후속 트랙.

## 5. 게이트 핸드오프

본 적재본은 **dbm-validator R1~R6 독립 게이트** 입력. 빌더 self-approve 없음. 실 COMMIT(`./apply.sh commit`)은
검증 GO + 인간 승인 후 hbd-load-executor가 수행. DRY-RUN 증거 → `dryrun-result.md`.
