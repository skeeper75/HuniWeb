# 매핑 설계서 — D-WIRE 제본(BIND)/명함(NAMECARD)/포토카드(PHOTOCARD) 가격공식 상품별 재모델

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 트랙 | D-WIRE remediation 후속 — broken 3공식(`PRF_BIND_SUM`·`PRF_NAMECARD_FIXED`·`PRF_PHOTOCARD_FIXED`) 사슬 단절 해소 |
| 선행 트랙 | `02_mapping/dwire-poster-formula-remodel/` (POSTER 28상품, 동일 처방). 본 트랙은 잔여 3 broken 완결 |
| 권위 순서 | 라이브 DDL/존재/바인딩 > 가격표 엑셀 명시값 > 설계 |
| 가격 DDL 권위 | `00_schema/price-engine-ddl.md` (컬럼명/타입/C-1~C-9) |
| 검증 | 본 문서는 **생성**. 독립 재검증(dbm-validator)은 별도 단계. (단, 본 설계 내 사슬무결성은 read-only SELECT 시뮬로 실증 §4) |
| 입력 감사 | `dwire-poster-formula-remodel/audit.md` (전수 배선 감사 §2·§3) |

## 0. 한 줄 요약
broken 3공식(BIND 4/1·NAMECARD 3/2·PHOTOCARD 2/2-모호)을 POSTER 와 **동일 처방**으로 해소한다 — 9 상품을 각자 **상품별 공식 `PRF_<X>`** 9개로 분리, 각 공식에 자기 comp(들)만 배선(14), 재바인딩(9 DELETE + 9 INSERT), 공유공식 3종 은퇴(use_yn='N', 0바인딩 도달). **BIND 는 합산형(FRM_TYPE.01)** — 각 상품 공식이 ITS OWN 제본비 comp 를 합산(라이브엔 책자용 인쇄/용지/코팅 comp 가 부재 → 합산항=자기 제본비 단일). **NAMECARD/PHOTOCARD 는 단순형(FRM_TYPE.02)**. comp/단가 모두 라이브 선존재 → **BLOCKED 0**. 신규 comp/단가 mint **없음**(공식·배선·바인딩만 조작). **C1 명함 설계(`price211-sticker-namecard`)는 본 트랙으로 supersede**(§3).

---

## 1. 라이브 재검증 (read-only 실측 2026-06-07) — 감사 수치 재확증

`BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK;`. JOIN KEY = `prd_nm`(MES_ITEM_CD NULL).

### 1.1 공식 헤더 + 바인딩 + 현재 배선 (실측)

| frm_cd | frm_typ | use_yn | n_bound | n_wired | broken | 바인딩 상품 |
|---|---|---|--:|--:|--:|---|
| `PRF_BIND_SUM` | **.01 합산형** | Y | **4** | **1** | **3** | 중철/무선/PUR/트윈링책자 |
| `PRF_NAMECARD_FIXED` | .02 단순형 | Y | **3** | **2** | **2** | 프리미엄/코팅/스탠다드명함 |
| `PRF_PHOTOCARD_FIXED` | .02 단순형 | Y | **2** | **2** | **2(모호)** | 포토카드/투명포토카드 |

> 감사(`audit.md §2`) 수치 **전건 일치**: BIND 4/1, NAMECARD 3/2, PHOTOCARD 2/2.

현재 배선(실측):
- `PRF_BIND_SUM` ← `COMP_BIND_JUNGCHEOL`(disp1, Y) **만**. 무선/PUR/트윈링 comp 는 미배선.
- `PRF_NAMECARD_FIXED` ← `COMP_NAMECARD_STD_S1/S2`(disp1·2, Y) **만**. 프리미엄/코팅 comp 미배선.
- `PRF_PHOTOCARD_FIXED` ← `COMP_PHOTOCARD_SET`(disp1, Y) + `COMP_PHOTOCARD_CLEAR_SET`(disp2, Y) **둘 다 배선됐으나 공유공식** → 포토카드↔SET·투명↔CLEAR_SET 라우팅 불가(상품→comp 필터 부재).

### 1.2 각 상품의 INTENDED comp + 단가 존재 (search-before-mint·라이브 실측)

comp/단가 모두 라이브 선존재. **신규 mint 없음.**

| # | prd_cd | 상품 | 공식유형 | INTENDED comp_cd | n_prices | 출처 |
|--:|---|---|---|---|--:|---|
| 1 | PRD_000068 | 중철책자 | 합산.01 | `COMP_BIND_JUNGCHEOL` | 8 | 기존 유일 배선 comp |
| 2 | PRD_000069 | 무선책자 | 합산.01 | `COMP_BIND_MUSEON` | 8 | 미배선이나 단가 8행 존재 |
| 3 | PRD_000070 | PUR책자 | 합산.01 | `COMP_BIND_PUR` | 8 | 〃 |
| 4 | PRD_000071 | 트윈링책자 | 합산.01 | `COMP_BIND_TWINRING` | 8 | 〃 |
| 5 | PRD_000033 | 스탠다드명함 | 단순.02 | `COMP_NAMECARD_STD_S1` + `COMP_NAMECARD_STD_S2` | 2+2 | 단/양면(기존 배선 comp) |
| 6 | PRD_000031 | 프리미엄명함 | 단순.02 | `COMP_NAMECARD_PREMIUM_S1_MGA/MGB` + `S2_MGA/MGB` | 1×4 | 단/양면 × 무게A/B(4 comp) |
| 7 | PRD_000032 | 코팅명함 | 단순.02 | `COMP_NAMECARD_COAT_S1` + `COMP_NAMECARD_COAT_S2` | 2+2 | 단/양면 |
| 8 | PRD_000024 | 포토카드 | 단순.02 | `COMP_PHOTOCARD_SET` | 1 | 세트 완제품가 |
| 9 | PRD_000025 | 투명포토카드 | 단순.02 | `COMP_PHOTOCARD_CLEAR_SET` | 1 | 세트 완제품가 |

**검증**: 9상품 전부 자기 comp + 단가 선존재 → **BLOCKED 0**. orphan 0(SET/CLEAR_SET/STD/JUNGCHEOL 등 기존 배선 comp 가 정확히 매핑 대상에 흡수).

---

## 2. BIND 합산형 comp-set 처리 (적대적 검토 — single-wire 오류 회피)

[HARD·핵심 적대 검사] BIND 는 **FRM_TYPE.01 합산형**이다. 합산형은 "판매가 = Σ components" — 즉 단순히 1 comp 만 배선하면 틀릴 수 있다(스킬 경고). **각 책자 상품의 full summation comp-set 를 라이브에서 결정**해야 한다. 실측 결과:

1. **라이브에 책자용 인쇄/용지/코팅 comp 가 부재.** `COMP_BOOK*`/`COMP_CHAEKJA*`/책자용 `COMP_PRINT*`/`COMP_PAPER`(책자) 탐색 = **0행**. 책자류와 직결된 가격 comp 는 **11종 제본비(COMP_BIND_*, 전부 PRC_COMPONENT_TYPE.04 후가공)** 뿐.
2. **참조 대조 `PRF_DGP_A`**(원자합산형, 29 comp 풀배선 = 인쇄+별색+코팅+용지+오시/미싱/가변/모서리)와 달리, **`PRF_BIND_SUM` 의 라이브 모델은 제본비 단일 comp** 만 배선된 합산형이다. 즉 후니 엔진은 책자 가격을 "제본비"라는 **단일 합산항**으로 모델링했다(인쇄/용지비는 책자 가격사슬에 미반영 — 라이브 권위).
3. **결론(라이브 권위)**: 각 책자 상품의 summation comp-set = **{자기 제본비 comp 1개}**. 따라서:
   - 중철책자 → `PRF_BIND_JUNGCHEOL` ← `COMP_BIND_JUNGCHEOL`(addtn_yn='Y', 합산항 1)
   - 무선책자 → `PRF_BIND_MUSEON` ← `COMP_BIND_MUSEON`
   - PUR책자 → `PRF_BIND_PUR` ← `COMP_BIND_PUR`
   - 트윈링책자 → `PRF_BIND_TWINRING` ← `COMP_BIND_TWINRING`
4. **단일 합산항이라도 FRM_TYPE.01 합산형 유지**(라이브 `PRF_BIND_SUM` 유형 계승). 단순형(.02)로 바꾸지 않는다 — ① 라이브 유형 보존 ② 향후 책자용 인쇄/용지 comp 가 추가되면 같은 공식에 합산 배선 확장 가능(합산형 의미가 정확). addtn_yn='Y'(합산 멤버, 라이브 JUNGCHEOL 컨벤션 계승).

> [적대적 주의·기록] "BIND 도 POSTER 처럼 단순형으로" 또는 "1 제본 comp 만 배선하면 합산형 깬다"는 두 오판을 모두 회피. 진실 = **라이브가 이미 제본비 단일항 합산형**이며, broken 은 "유형"이 아니라 "공유공식에 1상품 comp 만 배선"이 원인. 처방 = 상품별 공식 + 각자 제본비 합산(유형 .01 유지). 만약 후니가 "책자 가격 = 인쇄비+용지비+제본비" 합산을 원한다면 책자용 인쇄/용지 comp 신규 mint 가 필요(현재 라이브 부재 → §6 설계결정 D-BIND-SCOPE 로 상신, 발명 금지).

---

## 3. C1 SUPERSEDE (LD-2) — 명함 설계 대체

`02_mapping/price211-sticker-namecard/` (slice C1)의 **명함(NAMECARD) 부분**은 본 트랙으로 **폐기·대체**한다. 사유 = LD-2(공유공식+택일 comp 설계는 상품별 라우팅 불가).

### 3.1 supersede 대상 (C1 의 폐기 행)

| C1 파일 | C1 행(폐기) | 폐기 사유 |
|---|---|---|
| `load.sql` 단계2 | `t_prc_formula_components` **17 명함배선** (PRF_NAMECARD_FIXED ← PEARL_S1/S2·SHAPE_S1/S2·MINISHAPE_S1/S2·CLEAR_S1·WHITE 4종·FOIL 4종·FOIL_SETUP 2종, disp_seq 3~19) | 공유공식 PRF_NAMECARD_FIXED 에 7상품 comp 를 한꺼번에 배선 = §1 라우팅 불가(상품별 분기 불가). 본 트랙은 상품별 공식으로 재배선 |
| `load.sql` 단계3 | `t_prd_product_price_formulas` **6 명함바인딩** (PRD_000034 펄·PRD_000035 모양·PRD_000036 미니모양·PRD_000039 투명·PRD_000040 화이트·PRD_000037 오리지널박 → PRF_NAMECARD_FIXED) | 공유공식 바인딩 = 라우팅 불가. 상품별 공식 바인딩으로 대체 필요 |
| `load.csv` | `t_prc_formula_components.csv` 명함분 + `t_prd_product_price_formulas.csv` 명함 6행 | 위와 동일 |

> [HARD·스코프] C1 의 **STICKER 부분은 정당-공유로 유지**(본 트랙 미관여): `PRF_STK_FIXED`(3+반칼변형 = 단일 매트릭스 COMP_STK_PRINT 정당공유) + `PRF_STK_PACK_FIXED`(신규 mint·스티커팩 세트가). 이는 broken 패턴이 **아니다**(동일 가격구조 공유). 본 트랙은 스티커 행을 **건드리지 않는다**.

### 3.2 본 트랙이 C1 명함을 어떻게 정정하나
- C1 은 **STD/PREMIUM/COAT 3 기바인딩 상품을 손대지 않고**(이미 PRF_NAMECARD_FIXED 바인딩), 7 무가격 명함을 같은 공유공식에 추가 배선·바인딩하려 했다 → 라우팅 불가.
- 본 트랙은 **반대로 STD/PREMIUM/COAT 3상품을 상품별 공식으로 분리**(D-WIRE 정공법). 7 무가격 명함(펄/모양/미니모양/투명/화이트/오리지널박/형압)은 **본 트랙 스코프 밖**(과제 = broken 3공식의 9 bound 상품). 7 무가격 명함은 **후속 트랙**에서 동일 상품별 모델(`PRF_NAMECARD_PEARL` 등)로 처리 — C1 의 공유공식 설계를 따르지 말 것.

> [기록] 본 트랙 + 후속(7 무가격 명함 상품별 모델) 완결 시 `PRF_NAMECARD_FIXED` 는 영구 폐공식(은퇴 use_yn='N' 본 트랙에서 수행, 잔존 STD 배선은 FK RESTRICT 로 보존). 펄명함 mat_cd 불일치(C1 §7-2: 상품링크 MAT vs 단가 MAT) 등 C1 의 데이터 flag 는 7무가격 후속 트랙 소관(본 트랙 9상품과 무관).

---

## 4. 재모델 설계 — 상품별 공식 (per-product formula)

### 4.1 공식 헤더 `t_prc_price_formulas` (9 신규)
- 명명 = **`PRF_<도메인>_<X>`**. `<X>` = 상품 정체성(제본종류/명함등급/포토카드종).
  - BIND: `PRF_BIND_JUNGCHEOL`/`_MUSEON`/`_PUR`/`_TWINRING`
  - NAMECARD: `PRF_NAMECARD_STD`/`_PREMIUM`/`_COAT`
  - PHOTOCARD: `PRF_PHOTOCARD_STD`/`_CLEAR`
- `frm_typ_cd`: BIND = `FRM_TYPE.01`(합산형 계승, §2). NAMECARD/PHOTOCARD = `FRM_TYPE.02`(단순형, 라이브 공유공식 유형 계승).
- `frm_nm` = 서술형(varchar200). `use_yn='Y'`(C-8). `note` = 출처 메모.
- **명명 컨벤션 근거**: 라이브 기존 = `PRF_<도메인>_<유형>`(`PRF_BIND_SUM`/`PRF_NAMECARD_FIXED`/`PRF_PHOTOCARD_FIXED`). 본 트랙은 상품별이므로 `<유형>` 자리에 상품 정체성을 넣어 1:1 추적성 확보. 충돌 0(read-only 확인 — 9 신규 코드 라이브 부재).

### 4.2 공식↔구성요소 배선 `t_prc_formula_components` (14 신규)
| 공식 | 배선 comp | disp_seq | addtn_yn | 근거 |
|---|---|---|---|---|
| PRF_BIND_JUNGCHEOL | COMP_BIND_JUNGCHEOL | 1 | **Y** | 합산형 단일 합산항(§2). 라이브 JUNGCHEOL 'Y' 계승 |
| PRF_BIND_MUSEON | COMP_BIND_MUSEON | 1 | Y | 〃 |
| PRF_BIND_PUR | COMP_BIND_PUR | 1 | Y | 〃 |
| PRF_BIND_TWINRING | COMP_BIND_TWINRING | 1 | Y | 〃 |
| PRF_NAMECARD_STD | COMP_NAMECARD_STD_S1, _S2 | 1, 2 | **N** | 단/양면 = 동일상품 내 택일(주문은 1면 단가만 조회). 비합산 |
| PRF_NAMECARD_PREMIUM | _S1_MGA, _S1_MGB, _S2_MGA, _S2_MGB | 1~4 | **N** | 단/양면 × 무게A/B = 4 택일 변형(주문은 1 조합 조회) |
| PRF_NAMECARD_COAT | COMP_NAMECARD_COAT_S1, _S2 | 1, 2 | **N** | 단/양면 택일 |
| PRF_PHOTOCARD_STD | COMP_PHOTOCARD_SET | 1 | **Y** | 세트 완제품가 단일항 |
| PRF_PHOTOCARD_CLEAR | COMP_PHOTOCARD_CLEAR_SET | 1 | Y | 〃 |

- **addtn_yn 결정**(C-4: 합산 플래그):
  - BIND/PHOTOCARD = **'Y'**(합산형 단일항 / 단순형 단일 완제품가 — 항이 1개이므로 'Y'/'N' 의미 동일, 라이브 선례 'Y' 계승).
  - NAMECARD 다중 comp = **'N'**(단/양면·무게 = **택일 변형**, 합산 아님). POSTER 템플릿의 변형 2-comp(폼보드 화이트/블랙 addtn_yn='N')와 동일 처리. 한 주문은 1 comp 단가만 조회.
  - [설계결정 D-NC-ADDTN] C1 은 명함 변형 comp 를 addtn_yn='Y'로 배선(round-5 STD 컨벤션 답습). 본 트랙은 **변형 택일 = 'N' 채택**(C-4 합산 의미 정합 + POSTER 변형 컨벤션 일치). 단/양면을 'Y'로 두면 단면+양면 단가가 합산되는 오해 소지 → 'N' 이 의미적으로 정확. (단일항 BIND/PHOTOCARD 는 항이 1개라 무해하게 'Y' 유지.)
  - [동일상품 변형 ≠ 공유공식 broken] 단/양면·무게 변형을 한 상품 공식에 묶는 것은 §1 라우팅 문제와 **무관**(같은 상품의 옵션 → 앱/CPQ 옵션선택이 comp 결정). 공유공식 broken 은 "다른 상품"이 한 공식을 나눌 때만.

### 4.3 상품 재바인딩 `t_prd_product_price_formulas` (9 DELETE + 9 INSERT)
- **제거**: `DELETE (prd_cd, 공유 frm_cd)` 9행 — BIND 4(PRF_BIND_SUM)·NAMECARD 3(PRF_NAMECARD_FIXED)·PHOTOCARD 2(PRF_PHOTOCARD_FIXED).
- **추가**: `INSERT (prd_cd, PRF_<X>, apply_bgn_ymd='2026-06-01', note)` 9행.
- **FK 안전순서**: 공식 헤더(4.1)·배선(4.2)이 바인딩보다 **먼저** INSERT → `product_price_formulas.frm_cd` FK 충족. DELETE-old↔INSERT-new 는 PK 독립(같은 prd_cd, 다른 frm_cd).
- 각 prd_cd 의 기존 바인딩 수 = **정확히 1**(라이브 확인) → DELETE 후 0 → INSERT 로 1 복원. 누락/중복 없음.

### 4.4 공유공식 3종 처리 (fate)
재바인딩 완료 후 3 공유공식 전부 바인딩 = **0**:
- `PRF_BIND_SUM`: 4→0. 잔존 배선 `(PRF_BIND_SUM, COMP_BIND_JUNGCHEOL)` 1행.
- `PRF_NAMECARD_FIXED`: 3→0. 잔존 배선 `STD_S1/S2` 2행. (C1 미적재 확증 — 라이브 배선 2·바인딩 3뿐.)
- `PRF_PHOTOCARD_FIXED`: 2→0. 잔존 배선 `SET`·`CLEAR_SET` 2행.
- **권고 = 은퇴**: `UPDATE … SET use_yn='N'` 3종. 삭제(DELETE)는 잔존 formula_components FK RESTRICT 로 차단 → **use_yn='N' 비활성만 제안**(삭제는 인간승인 별건, POSTER D-RETIRE 동형).
  - [설계결정 D-RETIRE] 잔존 단가행은 새 `PRF_<X>` 공식이 동일 comp 를 배선하므로 그대로 재사용(단가 이동·삭제 불요). 폐공식 흔적만 비활성.
  - [주의] `PRF_NAMECARD_FIXED` 은퇴는 본 트랙 9상품엔 충분하나, **7 무가격 명함 후속 트랙**이 이 공식을 재사용할 계획이면 은퇴를 보류해야 한다 → 본 트랙은 "C1 공유공식 설계 폐기"가 권위(§3)이므로 은퇴가 정합(후속도 상품별 공식 사용). 후속 트랙 우선순위 결정 시 재확인 권고(§6 D-NC-RETIRE).

---

## 5. 제약 준수 (C-1~C-9, price-engine-ddl §7)

| 제약 | 준수 방법 |
|------|-----------|
| C-1 apply_bgn_ymd | `product_price_formulas.apply_bgn_ymd='2026-06-01'`(varchar10, nullable 메모이나 통일값 명시). component_prices 미적재(본 트랙 무관) |
| C-5 FRM_TYPE | BIND 4 = `FRM_TYPE.01`·NAMECARD/PHOTOCARD 5 = `FRM_TYPE.02`. 둘 다 라이브 선존재. FK 충족 |
| C-6 comp_typ_cd | comp 신규 mint **없음** — 14 comp 전부 라이브 선존재(BIND=.04 후가공·NAMECARD/PHOTOCARD=.06 완제품비) |
| C-4 addtn_yn | char(1) CHECK Y/N. BIND/PHOTOCARD 단일항=Y, NAMECARD 변형택일=N. 곱셈 표현 없음 |
| C-8 use_yn | 신규 9공식 'Y'. 공유 3공식 은퇴='N' |
| FK 선존재 | frm_typ_cd(.01/.02)·comp_cd(14)·prd_cd(9) 전건 라이브 선존재(read-only 확인). 단계0 검증문 포함 |
| reg_dt NOT NULL | INSERT 컬럼목록에서 omit → DEFAULT now() 발화(round-5 '명시 NULL=DEFAULT 미발화' 함정 회피) |
| 멱등성 | 공식/배선 INSERT = `WHERE NOT EXISTS`; 재바인딩 = DELETE(있으면)+INSERT NOT EXISTS; 은퇴 = `IS DISTINCT FROM`. 2-pass 행변경 0 |

---

## 6. 설계결정 — 인간 확인 필요

| ID | 결정사항 | 권고 |
|----|----------|------|
| D-BIND-SCOPE | 책자 가격 = 제본비 단일항 합산(라이브 현황) vs 인쇄비+용지비+제본비 합산(계산공식집초안 일반론) | **제본비 단일항 유지 권고**(라이브 권위·책자용 인쇄/용지 comp 부재). "책자=인쇄+용지+제본 합산" 원하면 책자용 comp 신규 mint 필요 → 별건 인간승인(발명 금지) |
| D-NC-ADDTN | NAMECARD 변형 comp addtn_yn = 'N'(택일) vs 'Y'(C1 답습) | **'N' 권고**(C-4 합산 의미 정합·POSTER 변형 컨벤션). 단/양면 합산 오해 회피 |
| D-RETIRE | 공유 3공식(0상품) = use_yn='N' 비활성 vs 완전 DELETE | **use_yn='N' 권고**(삭제는 잔존 배선 FK RESTRICT·운영파괴 → 별건 인간승인) |
| D-NC-RETIRE | `PRF_NAMECARD_FIXED` 은퇴가 7 무가격 명함 후속 트랙과 충돌? | **은퇴 권고**(후속도 상품별 공식·C1 공유설계 폐기). 후속 우선순위 확정 시 재확인 |
| D-OTHER-NC7 | C1 의 7 무가격 명함(펄/모양/미니모양/투명/화이트/오리지널박/형압) | **후속 트랙 상신**(본 트랙 스코프=broken 3공식의 9 bound 상품). 동일 상품별 모델 적용, C1 공유설계 폐기 |

---

## 7. 산출 파일
| 파일 | 내용 | 행수 |
|------|------|:--:|
| `load/t_prc_price_formulas.csv` | 신규 공식 9 | 9 |
| `load/t_prc_formula_components.csv` | 신규 배선 14 | 14 |
| `load/t_prd_product_price_formulas_INSERT.csv` | 재바인딩 추가 9 | 9 |
| `load/t_prd_product_price_formulas_DELETE.csv` | 재바인딩 제거 키 9 | 9 |
| `load/BLOCKED.csv` | 차단 상품(헤더만 — BLOCKED 0) | 0 |
| `load.sql` | 멱등 단일 tx (공식·배선·재바인딩·은퇴 3 + 단계0 FK검증 + 말미 사슬무결성 assert) | — |
| `dryrun-plan.md` | FK 적재순서 + DRY-RUN 게이트(R1~R6) + 설계자 사전점검 | — |
| `README.md` | 트랙 요약·실행 절차 | — |

CSV 공란 = NULL 규약. 헤더 = DB 컬럼명. `_DELETE.csv` 의 `note` 는 추적 보조(적재 시 DELETE 키만 사용).
