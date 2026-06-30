# 고아 가격구성요소 23건 배선 판정·설계 명세 (§27 배선 서브트랙 루프 2·3단계)

- 입력: `wiring/wiring-status.json` (snap_20260630_1743) — orphans 23건
- 권위 스냅샷: `_foundation/live-snapshot/latest/` · 엔진 의미: `raw/webadmin/.../catalog/pricing.py`
- 작업: **분류 + 배선 설계 명세까지**(실 COMMIT 없음·DB 미적재·생성≠검증)
- 산출일: 2026-07-01

---

## 0. 핵심 결론 (먼저)

**REAL_GAP(순수 배선으로 해소) = 0건.**

23건 전부가 "단가행만 적재되고 formula_components에 미배선"인 것은 맞으나, **어느 것도 `INSERT formula_components` 한 줄로 안전하게 해소되지 않는다.** 근본 이유는 엔진의 매칭 규칙(`pricing.py`)에 있다:

> `_match_entry`(line 600) + `_row_matches`(line 94): 구성요소의 단가행이 **판별 비수량차원(print_opt_cd·mat_cd·proc_cd·opt_cd·siz_cd 등)을 하나도 안 가지면 = 와일드카드 = 항상 매칭 → addtn_yn=Y로 무조건 합산.**

즉 `use_dims=["min_qty"]`(판별차원 0)인 고아를, 같은 공식에 이미 배선된 형제 옆에 그냥 꽂으면 → **두 변형이 동시 합산 = 과대청구**(silent-sum). 이는 [[namecard-orphan-component-wiring-260630]]·[[booklet-cover-branch cover_mult×2 BLOCKED]]가 실증한 그 함정이다. 판별차원이 있는 경우(폼보드 siz_cd 등)도 **상품이 그 선택지(사이즈·옵션)를 등록하지 않아** 고객이 고를 수 없어 배선만으론 무효.

따라서 23건은 "배선 누락"이 아니라 **"가격 경로(판별차원·공식·옵션·addon)가 미설계인 변형/옵션/미출시"** — 배선 이전에 §18 설계 또는 실무진 확인이 선행돼야 한다. 이 보수적 판정은 [HARD] silent-sum 가드의 정당한 귀결이다(억지 배선 거부).

### 분류 집계

| 분류 | 건수 | comp |
|---|---|---|
| **REAL_GAP** (순수 배선 해소) | **0** | — |
| **NEEDS_FORMULA** (배선 전 설계·데이터 선행) | **15** | 명함박4·명함화이트4·엽서북30p2·캘린더제본1·접지카드2·폼보드/포맥스2 |
| **BLOCKED** (권위·호스트 모호 → 실무진/goods.asp) | **4** | 포토카드대량1·완칼타공2·미러아크릴3T1 |
| **LEGIT_UNUSED** (정당 미배선) | **4** | PET거치대3(addon)·싸바리1(superseded) |
| 합계 | **23** | |

`wiring-fix-dryrun.sql` = **활성 INSERT 0행**(REAL_GAP 0). 억지 배선 방지용 문서·차단 주석만.

---

## 1. 전수 판정표

| # | comp_cd | 소속상품(prd) | 공식 바인딩 | 판별차원(rows) | 분류 | 근거·돈영향 |
|---|---|---|---|---|---|---|
| 1 | COMP_NAMECARD_FOIL_S1_HOLO | 오리지널박명함 PRD_000037 | PRF_NAMECARD_FOIL(바인딩O) | 없음(min_qty) | NEEDS_FORMULA | 형제 S1_STD만 배선. 단/양면·박종류 판별차원 부재→co-wire 시 4변형 동시합산 과대청구. 현재 양면·홀로 주문이 단면일반박가로 오산정 |
| 2 | COMP_NAMECARD_FOIL_S2_HOLO | 〃 | 〃 | 없음 | NEEDS_FORMULA | 〃 |
| 3 | COMP_NAMECARD_FOIL_S2_STD | 〃 | 〃 | 없음 | NEEDS_FORMULA | 〃 |
| 4 | COMP_NAMECARD_FOIL_SETUP_S2_STD | 〃(양면 동판셋업) | 〃 | 없음(.03) | NEEDS_FORMULA | 양면 셋업비. 단면셋업만 배선. 양면 선택 시 셋업비 누락(저청구). 판별차원 선행 필요 |
| 5 | COMP_NAMECARD_WHITE_S1W_CL | 화이트인쇄명함 PRD_000040 | **없음(공식 미바인딩)** | mat_cd·print_opt_cd | NEEDS_FORMULA | 상품에 가격공식 자체가 없음→견적 불가(0). 또 CL/NOCL(코팅) 판별차원 부재. §18 공식+코팅 차원 설계 필요 |
| 6 | COMP_NAMECARD_WHITE_S1W_NOCL | 〃 | 없음 | mat_cd·print_opt_cd | NEEDS_FORMULA | 〃 |
| 7 | COMP_NAMECARD_WHITE_S2W_CL | 〃 | 없음 | mat_cd·print_opt_cd | NEEDS_FORMULA | 〃 |
| 8 | COMP_NAMECARD_WHITE_S2W_NOCL | 〃 | 없음 | mat_cd·print_opt_cd | NEEDS_FORMULA | 〃 |
| 9 | COMP_PCB_S1_30P | 엽서북 PRD_000094 | PRF_PCB_FIXED(바인딩O) | siz_cd(print_opt **없음**) | NEEDS_FORMULA | page_rule 20~30p. 20P 형제는 print_opt로 단/양면 판별·30P는 print_opt 없음+페이지 차원 자체가 엔진에 없음→co-wire 시 30P가 항상 합산. 현재 30p 주문이 20p가로 오산정 |
| 10 | COMP_PCB_S2_30P | 〃 | 〃 | siz_cd(print_opt 없음) | NEEDS_FORMULA | 〃 |
| 11 | COMP_BIND_CAL_WALL | 벽걸이/탁상캘린더 PRD_000108~112 | **없음(공식 미바인딩)** | proc_cd·proc_grp(판별O) | NEEDS_FORMULA | comp는 proc_cd 판별 준비됨. 그러나 캘린더 5상품 전부 가격공식 부재→견적 불가. §18 캘린더 공식 설계 후 wire 가능 |
| 12 | COMP_FOLD_CARD_3H | 접지리플렛/카드(택1) | PRF_FOLD_SUM(형제 2H 배선) | 없음(min_qty) | NEEDS_FORMULA | 2단/3단/6크리즈 접지유형 택일이나 판별차원 부재→co-wire 시 동시합산 과대청구. 접지유형 opt 차원 선행 필요 |
| 13 | COMP_FOLD_CARD_6CR | 〃 | 〃 | 없음 | NEEDS_FORMULA | 〃 |
| 14 | COMP_POSTER_FOAMBOARD_BLACK | 폼보드 PRD_000129 | PRF_POSTER_FOAMBOARD(형제 WHITE 배선) | siz_cd(315/317·**상품 미등록**) | NEEDS_FORMULA | siz_cd가 White(174/197/293)와 disjoint→co-wire는 안전하나, 상품이 사이즈 315/317·색상옵션 미등록→고객 선택 불가(배선해도 무효). 상품구성(사이즈/색상옵션) 선행 |
| 15 | COMP_POSTER_FOMEXBOARD_WHITE5MM | 포맥스보드 PRD_000130 | PRF_POSTER_FOMEXBOARD(형제 3MM 배선) | siz_cd(315/317·상품 미등록) | NEEDS_FORMULA | 3mm/5mm 두께변형. siz_cd disjoint(안전)이나 두께옵션·사이즈 미등록→선택 불가. 상품구성 선행 |
| 16 | COMP_PHOTOCARD_BULK | 포토카드 PRD_000024 | PRF_PHOTOCARD_NORMAL(형제 SET 배선) | 없음(min_qty) | BLOCKED | 세트(siz_cd 고정 6000) vs 대량(min_qty 50구간) 가격모델. 대량이 세트와 수량배타인지·별상품인지 권위 모호→goods.asp/실무진 확인. co-wire 시 동시합산 위험 |
| 17 | COMP_CUT_FULL_PERF_1H6 | (호스트 미식별) | 없음 | 없음(min_qty) | BLOCKED | "완칼+타공1구 완제품가". 타공1구/2구를 제공하는 호스트 상품·선택수단 불명. comp_typ.06 완제품가인데 호스트 부재→실무진/master 확인 |
| 18 | COMP_CUT_FULL_PERF_2H6 | (호스트 미식별) | 없음 | 없음 | BLOCKED | 〃 |
| 19 | COMP_ACRYL_MIRROR3T | (호스트 미식별) | 없음 | siz_width·siz_height(면적) | BLOCKED | 미러아크릴3T 면적단가 81행(권위 적재됨). 그러나 이를 쓰는 아크릴 상품(미러 3T)+공식이 없음(생산 아크릴은 PRF_CLR_ACRYL=투명). 호스트 상품 식별 필요 |
| 20 | COMP_POSTEROPT_PET_BANNER_STAND_IN | PET배너 PRD_000136 | (formula에 미배선이 정상) | 없음 | LEGIT_UNUSED | 거치대=추가옵션(별도 가산). formula에 addtn_yn=Y로 꽂으면 항상 가산→무조건 과금. addon 템플릿 경로(t_prd_product_addons) 소관·formula 미배선이 정당. addon 미구축은 §7/CPQ 별건 |
| 21 | COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1 | 〃 | 〃 | 없음 | LEGIT_UNUSED | 〃 |
| 22 | COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2 | 〃 | 〃 | 없음 | LEGIT_UNUSED | 〃 |
| 23 | COMP_BIND_SSABARI | 하드커버류(세트) | (미배선) | proc_cd·proc_grp | LEGIT_UNUSED | 싸바리/무선/트윈링 묶음 제본comp. 라이브 공식은 **per-type 분리**(COMP_BIND_MUSEON·_PUR·_TWINRING)+하드커버는 COMP_HC_MUSEON_COVERBIND(세트)로 대체 운영→이 묶음comp는 superseded(미사용). 하드커버 제본은 §23 세트 트랙 소관 |

---

## 2. 분류별 다음 단계 라우팅

### REAL_GAP (0건)
없음. **이 서브트랙에서 즉시 배선 가능한 건 0.** dryrun SQL 활성 INSERT 없음.

### NEEDS_FORMULA (15건) → §18 가격엔진 설계 (huni-price-engine-design)
배선만으로 불가. 공통 처방 = **판별차원(또는 공식)을 먼저 설계·적재한 뒤** 배선. 우선순위:

1. **화이트인쇄명함 PRD_000040 (4건·견적0 = 최우선)** — 공식 자체 부재. §18로 공식 신설 + 코팅(CL/NOCL) 판별차원(opt_cd 또는 coat) + print_opt(단/양면, 이미 rows 보유) → 그 후 4 comp 배선. 단가 verbatim(16000/14500/19000/16000).
2. **오리지널박명함 PRD_000037 (4건·양면/홀로 오산정)** — comp rows에 print_opt_cd(단/양면)+opt_cd(박종류 일반/홀로) 판별차원 적재(데이터) → use_dims 갱신 → 4 변형+양면셋업 배선. 현재 단면일반박만 정상.
3. **엽서북 30p (2건)** — 엔진에 페이지수 차원 부재가 근본. 30P rows에 print_opt_cd 보강 + 페이지 선택→comp 라우팅 설계(또는 책자 inner-member 모델 차용). §18 판정 필요.
4. **캘린더 제본 CAL_WALL (1건)** — 캘린더 5상품 공식 전무. §18 캘린더 공식 신설이 선행(comp는 proc_cd 판별 준비완료).
5. **접지카드 3H/6CR (2건)** — 접지유형(2단/3단/6크리즈) 택일 판별차원(opt_cd) 설계 후 배선.
6. **폼보드 블랙·포맥스 5mm (2건)** — 상품에 변형 사이즈(315/317)+색상/두께 옵션 등록(상품구성, §7/§21) 선행. siz_cd disjoint라 배선 자체는 안전하나 선택수단 부재로 무효.

### BLOCKED (4건) → 이전사이트 goods.asp + 실무진 확인 (임의 생성 금지)
- 포토카드 대량(16): 세트 vs 대량 선택 메커니즘·배타성 확인.
- 완칼타공 1H6/2H6(17·18): 호스트 상품·타공1구/2구 선택수단 확인.
- 미러아크릴3T(19): 호스트 상품(미러 3T 아크릴)·공식 귀속 확인.

### LEGIT_UNUSED (4건) → 배선 대상 아님(현 미배선이 정답)
- PET 거치대 3건: addon 경로(별건, §7/CPQ addon 템플릿). **formula 배선 금지**(always-add 과금).
- 싸바리(23): superseded(per-type 제본comp+COVERBIND로 대체). 정리 시 use_yn=N 후보(별건·삭제금지 원칙).

---

## 3. 심의 로그 (deliberation)

- **왜 REAL_GAP 0인가 (대안 비교)**: ⓐ "형제 옆에 그냥 배선"(addtn_yn=Y) — 판별차원 없는 형제(명함박·접지·포토카드대량·완칼)는 동시합산 과대청구. 거부. ⓑ "addtn_yn=N(대체)으로 배선" — 엔진은 addtn_yn=N도 합산 경로 동일(매칭되면 더함), 택일 미지원. 거부. ⓒ "판별차원 적재 후 배선" — 데이터/설계 선행 = NEEDS_FORMULA. 채택(단, 이 서브트랙 범위 밖→§18 라우팅). 결론: 순수 배선 INSERT만으로 해소되는 건 0.
- **폼보드/포맥스는 siz_cd disjoint라 안전한데 왜 REAL_GAP 아닌가**: 배선 자체는 무해하나 상품이 변형 사이즈/옵션을 등록 안 해 고객이 선택 불가→배선해도 가격 변화 0(무효 배선). "순수 배선으로 견적 회복"이 안 되므로 REAL_GAP 정의 불충족. 상품구성 선행 필요로 NEEDS_FORMULA.
- **싸바리 vs 캘린더(둘 다 proc_cd 판별 보유)**: 싸바리는 라이브가 이미 per-type comp로 대체 운영(superseded)→LEGIT_UNUSED. 캘린더는 대체 경로 없이 공식 전무(pending)→NEEDS_FORMULA. proc_cd 보유라는 표면 동형이나 "대체 운영 여부"로 갈림.
- **미해소 컨펌(인간/실무진)**: BLOCKED 4건(포토카드대량·완칼타공×2·미러아크릴3T) 호스트/선택수단/배타성. 추측 적재 금지.

---

## 4. 인간 승인 게이트로 넘길 요약

- **이 서브트랙(순수 배선) 즉시 적용분 = 0건.** wiring-fix-dryrun.sql 활성 INSERT 없음(억지 배선 거부 = silent-sum 과대청구 방지).
- 23 고아는 배선 누락이 아니라 **가격경로 미설계** — 라우팅: NEEDS_FORMULA 15→§18, BLOCKED 4→goods.asp/실무진, LEGIT_UNUSED 4→배선 제외(addon/superseded).
- **최우선 돈영향**: 화이트인쇄명함(견적0·4건)·오리지널박명함(양면·홀로 오산정·4건)·엽서북30p(오산정·2건).
- 검증(생성≠검증): 본 분류는 생성측. codex 교차·게이트·PRICE≠0 실호출은 후속 별도 패스.
