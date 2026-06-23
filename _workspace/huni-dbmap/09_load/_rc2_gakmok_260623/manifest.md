# manifest.md — RC-2 각목(현수막 마감봉) 적재본 매니페스트

> dbm-load-builder · 2026-06-23 · 대상=일반현수막(PRD_000138) 각목 옵션 · 후보 C · **보수안(§3.3·2 comp 유지)** 채택.
> 입력 명세 = `_workspace/huni-catalog-conformance/03_cpq_link/rc2-gakmok-load-spec.md` (전체 정독·GO).
> 권위[HARD] = 인쇄상품 가격표 「포스터사인」 r249/250 verbatim(4000/8000) · 라이브 4698/4700 verbatim · 단가 날조 0.
> 라이브 재실측 일시 = 2026-06-23(명세 주장 비신뢰·전 항목 직접 SELECT 재확인·불일치 0).
> ★실 COMMIT 금지(빌더). dbm-validator R1~R6 GO + 인간 승인 후 hbd-load-executor.

---

## 0. 라이브 재실측 결과 (명세 검증 — 전 항목 일치·불일치 0)

| # | 항목 | 명세 주장 | 라이브 재실측(2026-06-23) | 판정 |
|---|---|---|---|---|
| 0.1 | GAKMOK comp 3개 | `_900_4`(부모)·`_GT`·`_LE` | 동일 3개 실재 | ✅ |
| 0.1 | comp use_dims | `_GT`/`_LE` 둘 다 `[]`·부모 NULL | `_GT`=`[]`·`_LE`=`[]`·부모 NULL | ✅ |
| 0.1 | comp use_yn | 전부 Y | 전부 Y | ✅ |
| 0.2 | 단가행 4698 | `_LE`·opt NULL·전 차원 NULL·**4000** | comp_price_id 4698·`_LE`·opt NULL·**4000.00**·apply_ymd 2026-06-01 | ✅ |
| 0.2 | 단가행 4700 | `_GT`·opt NULL·전 차원 NULL·**8000** | comp_price_id 4700·`_GT`·opt NULL·**8000.00**·apply_ymd 2026-06-01 | ✅ |
| 0.2 | 부모 단가행 | 0건 | 0건 | ✅ |
| 0.3 | OPV_000015 현재 opt_nm | "각목(세로)+끈(4개) 추가" | "각목(세로)+끈(4개) 추가" | ✅ |
| 0.3 | OPV_000016 현재 opt_nm | "각목(가로)+끈(4개) 추가" | "각목(가로)+끈(4개) 추가" | ✅ |
| 0.3 | OPT_000004 그룹 | SEL_TYPE.01·0/1·mand N | SEL_TYPE.01·min0·max1·mand N·disp_seq2 | ✅ |
| 0.3 | 138 그룹 disp_seq MAX | 2(del_yn=N 기준) | OPT_000003(1)·OPT_000004(2) → MAX=2 (OPT-000002 del_yn=Y 제외) | ✅ |
| 0.4 | OPV_015/016 환원행 동일 | MAT_000338·MAT_000070·PROC_000081 (100% 동일) | 6행 100% 동일(자재2·공정1×2) | ✅ |
| 0.6 | 138 본체 frm_cd | PRF_POSTER_BANNER_N | PRF_POSTER_BANNER_N (단일) | ✅ |
| 0.6 | PRF_POSTER_BANNER_N disp_seq MAX | 7 | 7(본체1·타공4 2·열재단3·양면테입4·봉미싱5·큐방6·끈7) | ✅ |
| 0.6 | GAKMOK 바인딩 | 0건 | 0건 | ✅ |
| 0.7 | opt_cd MAX | OPV_000431 | OPV_000431 | ✅ |
| 0.7 | opt_grp_cd MAX | OPT_000062 | OPT_000062 | ✅ |
| 0.7 | 신규 충돌 | OPV_000432/433·OPT_000063 = 0 | 0 | ✅ |
| 0.7 | SEL_TYPE.01 실재 | — | "단일" 실재 | ✅ |
| — | PRD_000138 실재 | — | "일반현수막"·del_yn=N | ✅ |
| — | apply_ymd | (명세 미명시) | **2026-06-01**(4698/4700·끈/큐방 동일·신규 INSERT 없음→충전만이라 무영향) | ✅ |

**스키마 사실(직접 SELECT)**: `t_prc_component_prices.apply_ymd`=NOT NULL(DEFAULT 없음·단 본 적재는 신규 단가행 INSERT 0건이라 무영향)·`opt_cd`=FK 없음(충전 안전)·reg_dt=DEFAULT now()(전 테이블)·자연키 UNIQUE `ux_t_prc_comp_prices_nat_key`(opt_cd 포함)·comp_cd FK ON UPDATE CASCADE·option_items 트리거 `trg_..._chk_ref`(우리는 환원행 미접촉·세로/가로 환원 HOLD라 미발동).

---

## 1. comp 통합 vs 보수안 — 선택 근거 (★HOLD-G-MERGE 해소: 보수안 채택)

명세는 §3.2 1 comp 통합을 권고하되 §3.3 2 comp 유지(보수안)도 "always-add 해소 동등·comp 병합 회피·validator/실무진 선택"으로 병기. **본 적재본은 보수안(2 comp 유지)을 채택**한다.

| 근거 | 내용 |
|---|---|
| **① 라이브 동형 패턴 정합** | 직전 CONFIRM-resolved에서 같은 OPT_000004 택1 그룹의 형제 옵션 **끈(STRING)·큐방(QBANG)이 2개 별도 comp 유지 + 각 opt_cd 충전(STRING=OPV_000014·4000·comp_price 4696 / QBANG=OPV_000013·3000·comp_price 4694) + 각 바인딩(disp7/disp6)** 패턴으로 **이미 라이브 검증**됨. 각목도 동일 그룹 형제 → **동형=2 comp 유지**가 라이브 정합. (use_dims도 끈/큐방과 동일 `["opt_cd","opt_grp:OPT_000004"]`로 맞춤) |
| **② 리스크 최소** | 통합안은 4700행의 comp_cd를 `_GT`→`_LE`로 이관(단가행 소속/자연키 변경 + 가격사슬 구조 변경). 보수안은 **행 이관 0·comp_cd 불변** — always-add 해소는 opt_cd 충전만으로 양안 동등(엔진 재현 §4 입증). 불필요한 가격사슬 변경 회피. |
| **③ 메모리 교훈 회피** | "comp 통합 시 use_yn=N+단가행 보존" 함정(좀비 잔존·단가행 유실 위험)을 아예 회피. 보수안은 두 comp 모두 use_yn=Y 유지·각자 단가행 1행 보유. |
| **④ use_dims 정합** | 명세 §3.2 권고 `["opt_cd","min_qty"]` 대신 **라이브 검증된 끈/큐방 동형 `["opt_cd","opt_grp:OPT_000004"]`** 채택(opt_cd 판별차원·opt_grp 토큰=표시/스코프). always-add 해소 효과 동일(opt_cd가 핵심 판별차원). |

> 결과: 12000 이중합산 해소·미선택 0가산·각목 선택 시 정확 단가 1행 = **통합안과 100% 동등한 가격 결과**(엔진 재현 §4). 차이는 comp 1개냐 2개냐뿐이며, 보수안이 라이브 동형 패턴·리스크 모두 우위.

---

## 2. 적재 행 1:1 (FK 위상순서 · 현재값↔설계값 · 멱등 가드)

apply.sql 실행 시 영향 = **INSERT 3 + UPDATE 7 + INSERT 2 = 12행**(DRY-RUN 실측).

### STEP 1 — 옵션 그룹 (t_prd_product_option_groups) · INSERT 1
| FK 위상 | t_prd_products(PRD_000138)·t_cod_base_codes(SEL_TYPE.01) 선행(실재 확인) |
|---|---|
| 행 | OPT_000063 "각목 부착 변"·SEL_TYPE.01·min0·max1·mand N·disp_seq3·use_yn Y·del_yn N |
| 현재값 | 부재(충돌 0·MAX=OPT_000062) |
| 멱등 | NOT EXISTS (prd_cd, opt_grp_cd) |

### STEP 2 — 옵션 (t_prd_product_options) · INSERT 2 + UPDATE 2
| 구분 | opt_cd | 현재값 | → 설계값 | 멱등 가드 |
|---|---|---|---|---|
| 신규 | OPV_000432 | 부재 | "세로변 부착(좌우)"·OPT_000063·disp1·Y | NOT EXISTS |
| 신규 | OPV_000433 | 부재 | "가로변 부착(상하)"·OPT_000063·disp2·Y | NOT EXISTS |
| 재라벨 | OPV_000015 | "각목(세로)+끈(4개) 추가" | "각목(900mm이하)+끈(4개) 추가" | opt_nm IS DISTINCT |
| 재라벨 | OPV_000016 | "각목(가로)+끈(4개) 추가" | "각목(900mm 초과)+끈(4개) 추가" | opt_nm IS DISTINCT |
> FK: OPV_000432/433 → OPT_000063(STEP1 선행). 재라벨은 그룹/dflt/disp_seq/환원행 불변(opt_nm만).

### STEP 3 — option_item 환원 (t_prd_product_option_items) · 적재 0
- 신규 환원행 0. OPV_000015/016 기존 환원행(MAT_000338·MAT_000070·PROC_000081) 유지(트리거 통과 상태).
- 세로/가로(432/433) 환원 = **HOLD-G-ITEM**(폴리모픽 차원에 "변 방향" 슬롯 부재·트리거 REJECT 회피·가격 무영향).

### STEP 4 — comp use_dims (t_prc_price_components) · UPDATE 2
| comp_cd | 현재값 use_dims | → 설계값 | 멱등 가드 |
|---|---|---|---|
| `..._GAKMOK_STR_900_4_LE` | `[]` | `["opt_cd","opt_grp:OPT_000004"]` | use_dims IS DISTINCT |
| `..._GAKMOK_STR_900_4_GT` | `[]` | `["opt_cd","opt_grp:OPT_000004"]` | use_dims IS DISTINCT |

### STEP 5 — 단가행 opt_cd 충전 (t_prc_component_prices) · UPDATE 2 · 단가 verbatim 불변
| comp_price_id | comp_cd | 현재 opt_cd | → 설계 opt_cd | unit_price | apply_ymd | 멱등 가드 |
|---|---|---|---|---|---|---|
| 4698 | `..._LE` | NULL | **OPV_000015** | **4000.00**(불변·WHERE 가드) | 2026-06-01(불변) | opt_cd IS DISTINCT + unit_price=4000 가드 |
| 4700 | `..._GT` | NULL | **OPV_000016** | **8000.00**(불변·WHERE 가드) | 2026-06-01(불변) | opt_cd IS DISTINCT + unit_price=8000 가드 |
> 행 이관 0(보수안)·comp_cd 불변·단가 verbatim(가격표 r249/250)·apply_ymd 불변(분기 금지=이중계상 방지).

### STEP 6 — 좀비 차단 (t_prc_price_components) · UPDATE 1
| comp_cd | 현재 use_yn | → 설계 use_yn | 근거 | 멱등 가드 |
|---|---|---|---|---|
| `..._GAKMOK_STR_900_4`(부모 껍데기) | Y | **N** | 단가행 0건·빈 컨테이너·평가 풀 제외 | use_yn IS DISTINCT |
> `_LE`/`_GT`는 use_yn=Y 유지(보수안·각각 가산 경로).

### STEP 7 — 공식 바인딩 (t_prc_formula_components) · INSERT 2
| frm_cd | comp_cd | addtn_yn | disp_seq | 멱등 가드 |
|---|---|---|---|---|
| PRF_POSTER_BANNER_N | `..._GAKMOK_STR_900_4_LE` | Y | 8 | NOT EXISTS (frm_cd, comp_cd) |
| PRF_POSTER_BANNER_N | `..._GAKMOK_STR_900_4_GT` | Y | 9 | NOT EXISTS (frm_cd, comp_cd) |
> 기존 disp_seq MAX=7 → _LE=8·_GT=9. addtn_yn=Y(가산형·끈/큐방 동형).

### STEP 8(선택·HOLD-G-CONSTRAINT) — 부착 변 종속 제약 · 적재 0
- §2.3 JSONLogic 제약(각목 선택 시에만 부착 변 의미)은 선택사항·미적재. min_sel_cnt=0·mand_yn=N이라 제약 없이도 가격·견적 정상. 실무진 결정 전 HOLD.

---

## 3. 멱등성 (DRY-RUN 2-pass 실측)
- PASS1: INSERT 3·UPDATE 7·INSERT 2(=12행 영향).
- PASS2(동일 트랜잭션 재실행): **전 구문 0 영향**(INSERT 0 0·UPDATE 0) → 멱등 입증(NOT EXISTS·IS DISTINCT FROM 작동).

## 4. 잔여 HOLD (정직 표기·전부 가격 무영향)
| HOLD | 내용 | 처리 |
|---|---|---|
| HOLD-G-MERGE | comp 1개 통합 vs 2개 유지 | **해소 → 보수안(2 comp 유지) 채택**(§1 근거). validator 재확인 대상. |
| HOLD-G-ITEM | 세로/가로 부착 변 환원행 | 폴리모픽 차원 슬롯 부재 → 환원 생략(가격 무영향·생산정보는 GAP-OPT/ref_param_json·dbm-ddl-proposer 라우팅). |
| HOLD-G-CONSTRAINT | 부착 변 종속 제약 | 선택사항·미적재(가격 무영향). 실무진 결정 전 HOLD. |
| 자재 정리(범위 밖) | MAT_000339(고아·product_materials del_yn=Y) | 어느 환원행도 안 가리킴·무영향. 기초데이터 별 트랙(본 가격 모델 범위 밖). |

## 5. 범위 가드
- 기초코드 마스터(t_siz/t_mat/t_proc/t_cod) **불변**. t_prd 구성요소(option_groups/options) + CPQ + 가격사슬(comp use_dims·단가행 opt_cd·바인딩)만 접촉.
- 메쉬현수막(PRD_000139) = 가격표에 각목 옵션 부재 → 범위 밖(미접촉).
- 단가 verbatim(4000/8000·날조 0)·apply_ymd 분기 없음·IDENTITY/시퀀스 미접촉(신규 단가행 INSERT 0건).
