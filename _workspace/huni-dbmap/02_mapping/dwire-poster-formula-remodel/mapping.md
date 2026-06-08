# 매핑 설계서 — D-WIRE 포스터/실사 가격공식 상품별 재모델 (per-product re-model)

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 트랙 | D-WIRE remediation — `PRF_POSTER_FIXED` 28상품 사슬 단절 해소 |
| 권위 순서 | 라이브 DDL/존재 > 가격표 엑셀 명시값 > 설계 |
| 가격 DDL 권위 | `00_schema/price-engine-ddl.md` (컬럼명/타입/C-1~C-9) |
| 검증 | 본 문서는 **생성**. 독립 재검증(dbm-validator)은 별도 단계 |
| 입력 감사 | 본 디렉터리 `audit.md` (전수 배선 감사) |

## 0. 한 줄 요약
28 포스터/실사 상품을 1 공유공식 `PRF_POSTER_FIXED` 에서 떼어, **상품별 단순형 공식 `PRF_POSTER_<X>`**(FRM_TYPE.02) 28개로 분리한다. 각 공식은 그 상품의 고유 완제품가 comp(들)만 배선하고(`disp_seq=1, addtn_yn='Y'`; 변형 2-comp 상품은 disp_seq 1·2 둘 다 addtn_yn='N' 택일), 상품을 `PRF_POSTER_FIXED → PRF_POSTER_<X>` 로 **재바인딩**한다. → 공식 **28**, 배선 **30**(변형상품 2종이 2-comp), 재바인딩 **28**. `PRF_POSTER_FIXED` 는 28상품 제거 후 **0상품 → 은퇴(use_yn='N') 권고**(삭제는 FK RESTRICT·인간승인).

---

## 1. 상품 ↔ comp 매핑 (28상품, 라이브 검증 1:1/1:2)

각 상품은 자기 고유 **완제품가 comp**(`PRC_COMPONENT_TYPE.06`)를 가짐. comp/단가 모두 라이브 선존재(read-only 확인). 신규 comp/단가 mint **없음**(본 트랙은 공식·배선·바인딩만 조작).

| # | prd_cd | 상품 | 유형 | comp_cd (1 또는 2) | n_prices(현재) | 비고 |
|--:|---|---|---|---|--:|---|
| 1 | PRD_000118 | 아트프린트포스터 | 면적 | `COMP_POSTER_ARTPRINT_PHOTO` | 1 | 기존 유일 배선 comp |
| 2 | PRD_000119 | 아트페이퍼포스터 | 면적 | `COMP_POSTER_ARTPAPER_MATTE` | 2 | |
| 3 | PRD_000120 | 방수포스터 | 면적 | `COMP_POSTER_WATERPROOF_PET` | 1 | |
| 4 | PRD_000121 | 접착방수포스터 | 면적 | `COMP_POSTER_ADH_WATERPROOF_PVC` | 1 | |
| 5 | PRD_000122 | 접착투명포스터 | 면적 | `COMP_POSTER_ADH_CLEAR_PVC` | 1 | |
| 6 | PRD_000123 | 아트패브릭포스터 | 면적 | `COMP_POSTER_ARTFABRIC_GRAPHIC` | 1 | |
| 7 | PRD_000124 | 린넨패브릭포스터 | 면적 | `COMP_POSTER_LINEN_FABRIC` | 1 | |
| 8 | PRD_000125 | 캔버스패브릭포스터 | 면적 | `COMP_POSTER_CANVAS_FABRIC` | 1 | |
| 9 | PRD_000126 | 레더아트프린트 | 면적 | `COMP_POSTER_LEATHER_ARTPRINT` | 1 | |
| 10 | PRD_000127 | 타이벡프린트 | 면적 | `COMP_POSTER_TYVEK_PRINT` | 1 | |
| 11 | PRD_000128 | 메쉬프린트 | 면적 | `COMP_POSTER_MESH_PRINT` | 1 | |
| 12 | PRD_000129 | 폼보드 | 고정 | `COMP_POSTER_FOAMBOARD_WHITE` + `COMP_POSTER_FOAMBOARD_BLACK` | 2+2 | **2-comp 택일**(화이트보드/블랙보드 옵션) |
| 13 | PRD_000130 | 포맥스보드 | 고정 | `COMP_POSTER_FOMEXBOARD_WHITE3MM` + `COMP_POSTER_FOMEXBOARD_WHITE5MM` | 2+2 | **2-comp 택일**(3mm/5mm 옵션) |
| 14 | PRD_000131 | 프레임리스우드액자 | 고정 | `COMP_POSTER_FRAMELESS_WOOD` | 2 | |
| 15 | PRD_000132 | 레더아트액자 | 고정 | `COMP_POSTER_LEATHER_FRAME` | 2 | |
| 16 | PRD_000133 | 캔버스 행잉포스터 | 고정 | `COMP_POSTER_CANVAS_HANGING` | 3 | |
| 17 | PRD_000134 | 린넨 우드봉 족자 | 고정 | `COMP_POSTER_LINEN_WOODBONG` | 3 | |
| 18 | PRD_000135 | 족자포스터 | 고정 | `COMP_POSTER_JOKJA` | 4 | |
| 19 | PRD_000136 | PET배너 | 고정 | `COMP_POSTER_PET_BANNER` | 1 | |
| 20 | PRD_000137 | 메쉬배너 | 고정 | `COMP_POSTER_MESH_BANNER` | 1 | |
| 21 | PRD_000138 | 일반현수막 | 면적 | `COMP_POSTER_BANNER_NORMAL` | 3 | silsa B26 |
| 22 | PRD_000139 | 메쉬현수막 | 면적 | `COMP_POSTER_BANNER_MESH` | 2 | silsa B27 |
| 23 | PRD_000140 | 무광시트커팅 | 고정 | `COMP_POSTER_SHEETCUT_MATTE` | 3 | |
| 24 | PRD_000141 | 홀로그램 시트커팅 | 고정 | `COMP_POSTER_SHEETCUT_HOLO` | 3 | |
| 25 | PRD_000142 | 유광아크릴스티커 | 고정 | `COMP_POSTER_ACRYLSTK_GLOSS` | 4 | |
| 26 | PRD_000143 | 미러아크릴스티커 | 고정 | `COMP_POSTER_ACRYLSTK_MIRROR` | 4 | |
| 27 | PRD_000144 | 미니보드스탠딩 | 고정 | `COMP_POSTER_MINI_STANDBOARD` | 15 | |
| 28 | PRD_000145 | 미니배너 | 고정 | `COMP_POSTER_MINI_BANNER` | 10 | |

**검증**: 30 base `COMP_POSTER_%` comp = 26 단일상품 + 2 변형상품×2 = 30. orphan(매핑 밖 base comp) **0**. comp 0개 상품(BLOCKED) **0** — 28상품 전부 자기 comp 존재. `COMP_POSTEROPT_*`(24종 추가옵션 add-on)은 **round-6 CPQ 옵션레이어 소관 — 본 트랙 제외**.

> [HARD·sparse 주의] component_prices 가 sparse(1~6%) 인 것(Slice A 진단)은 **단가 데이터 GAP** 이지 배선 GAP 이 아니다. 본 D-WIRE 트랙은 **배선·공식·바인딩**만 해소한다. sparse 단가 본체는 Slice A(670 BLOCKED)/C3(73)가 채운다(§5 적용순서). 두 트랙이 모두 적용돼야 가격이 실제 조회된다.

---

## 2. 재모델 설계 — 상품별 공식 (per-product formula)

### 2.1 공식 헤더 `t_prc_price_formulas` (28 신규)
- `frm_cd` 명명 = **`PRF_POSTER_<X>`** 에서 `<X>` = 해당 comp 의 접미(comp_cd 의 `COMP_POSTER_` 뒤). 변형 2-comp 상품은 상품 대표 접미 사용.
  - 예: `COMP_POSTER_ARTPRINT_PHOTO` → `PRF_POSTER_ARTPRINT_PHOTO`. 폼보드(2comp) → `PRF_POSTER_FOAMBOARD`. 포맥스(2comp) → `PRF_POSTER_FOMEXBOARD`.
- `frm_typ_cd = FRM_TYPE.02`(단순형) — 라이브 `PRF_POSTER_FIXED` 와 동일 유형 계승(완제품가 단일 룩업, 합산 항목 없음·통가격).
- `frm_nm` = 서술형(라이브 컨벤션 정합, varchar200). 예: `포스터/실사 상품별 완제품가 단순형 [아트프린트포스터]`.
- `use_yn = 'Y'`(C-8). `note` = 출처 메모.
- **명명 컨벤션 근거**: 라이브 기존 공식이 `PRF_<도메인>_<유형>` (`PRF_POSTER_FIXED`/`PRF_NAMECARD_FIXED`/`PRF_STK_FIXED`) 패턴. 본 트랙은 상품별이므로 `PRF_POSTER_<comp접미>` 로 1:1 추적성 확보(`price-code-proposals.md` 컨벤션 일관). → 28 신규 코드는 `dwire-poster-formula-remodel` 전용, 라이브 기존 frm_cd 와 충돌 0(read-only 확인 — `PRF_POSTER_<comp접미>` 형 라이브 부재).

### 2.2 공식↔구성요소 배선 `t_prc_formula_components` (30 신규)
- 단일 comp 상품(26): 1 배선 = `(PRF_POSTER_<X>, COMP_POSTER_<X>, disp_seq=1, addtn_yn='Y')`.
- 2-comp 변형 상품(2 = 폼보드/포맥스): **2 배선** = `(disp_seq=1, addtn_yn='N')` + `(disp_seq=2, addtn_yn='N')`.
  - **addtn_yn='N'(택일)**: 폼보드 = 화이트보드 **또는** 블랙보드 선택(합산 아님). 한 주문은 1 comp 단가만 조회. (C-4: addtn_yn 은 합산플래그 — 'N'=비합산. 변형 택일이 정확.)
  - [설계결정 D-WIRE-VARIANT] 변형 2-comp 를 동일상품 공식에 묶는 것은 §1 라우팅 문제와 **무관** — 둘 다 **같은 상품**의 옵션이므로 옵션선택(앱/CPQ)이 comp 를 결정. 공유공식 broken 은 "다른 상품"이 한 공식을 나눌 때만 발생.
- 단일 comp 상품의 `addtn_yn='Y'` 채택 근거: 라이브 기존 배선(`PRF_POSTER_FIXED↔ARTPRINT`)이 `addtn_yn='Y'`. 단일 comp 단순형에서 'Y'/'N' 은 합산 의미 동일(항이 1개) → **라이브 선례 'Y' 계승**(일관).

### 2.3 상품 재바인딩 `t_prd_product_price_formulas` (28 DELETE + 28 INSERT)
- **제거**: `DELETE (prd_cd, frm_cd='PRF_POSTER_FIXED')` 28행.
- **추가**: `INSERT (prd_cd, frm_cd='PRF_POSTER_<X>', apply_bgn_ymd='2026-06-01', note)` 28행.
- **FK 안전순서**: 공식 헤더(2.1)·배선(2.2)이 바인딩보다 **먼저** INSERT 돼야 `product_price_formulas.frm_cd` FK 충족. DELETE-old 는 INSERT-new 와 독립(같은 prd_cd, 다른 frm_cd PK).
- 각 prd_cd 의 기존 바인딩 수 = **정확히 1**(라이브 확인) → DELETE 후 그 상품은 바인딩 0 → INSERT 로 1 복원. 누락/중복 없음.

### 2.4 `PRF_POSTER_FIXED` 처리 (fate)
- 28상품 재바인딩 완료 후 `PRF_POSTER_FIXED` 바인딩 = **0**.
- 기존 배선 `(PRF_POSTER_FIXED, COMP_POSTER_ARTPRINT_PHOTO)` 1행 잔존(FK RESTRICT — 공식 삭제 차단).
- **권고 = 은퇴**: `UPDATE t_prc_price_formulas SET use_yn='N' WHERE frm_cd='PRF_POSTER_FIXED'`.
  - 삭제(`DELETE`)는 ① formula_components FK(ARTPRINT 배선) ② product_price_formulas FK(0이지만) RESTRICT 로 막힘 → 먼저 배선 DELETE 필요. **운영 파괴 변경이라 본 트랙은 use_yn='N' 비활성만 제안**(삭제는 인간승인 별건).
  - [설계결정 D-RETIRE] use_yn='N' 권고. ARTPRINT 단가행(comp_price_id=4045 등)은 새 `PRF_POSTER_ARTPRINT_PHOTO` 가 동일 comp 를 배선하므로 **그대로 재사용**(단가 이동·삭제 불요). → 폐공식 흔적만 비활성.

---

## 3. 다른 broken 공식 (BIND/NAMECARD/PHOTOCARD) — 동일 처방, 본 번들 밖

`audit.md §2` 의 나머지 3 broken 공식도 **상품별 공식 분리**가 정답(LD-2). 단 본 번들 스코프 = POSTER 28상품이므로 **재모델 SQL 미포함**(scope discipline). 후속 트랙용 처방만 명시:

| frm_cd | 처방 | 신규 공식 | 비고 |
|---|---|---|---|
| `PRF_BIND_SUM` | 무선/PUR/트윈링 = 각자 `PRF_BIND_<X>`(또는 기존 합산형 유지하되 상품별 comp 배선+상품별 공식) | 3 | 단 BIND 는 FRM_TYPE.01 합산형(제본=인쇄+제본 합산)이라 POSTER 단순형과 처방 디테일 상이 — 후속 트랙에서 합산 comp 셋 재검토 |
| `PRF_NAMECARD_FIXED` | 프리미엄/코팅 = 각자 `PRF_NAMECARD_<X>` + 자기 comp 배선 + 재바인딩. STD 는 잔존 가능 | 2+ | `price211-sticker-namecard` 의 "공유공식 7-comp 택일" 설계는 LD-2 로 폐기 권고 |
| `PRF_PHOTOCARD_FIXED` | 포토카드→`PRF_PHOTOCARD_STD`, 투명→`PRF_PHOTOCARD_CLEAR` 분리 + 재바인딩 | 2 | 둘 다 배선돼도 공유라 라우팅 불가 — 분리 필수 |

> [HARD] 이 3건은 **본 트랙 load.sql 미포함**. 별도 트랙 상신(인간 우선순위 결정). 본 트랙은 POSTER 28만 완결.

---

## 4. 제약 준수 (C-1~C-9, price-engine-ddl §7)

| 제약 | 준수 방법 |
|------|-----------|
| C-1 apply_ymd/apply_bgn_ymd | `product_price_formulas.apply_bgn_ymd = '2026-06-01'`(varchar10, nullable 메모이나 통일값 명시). component_prices 미적재(본 트랙 무관) |
| C-5 FRM_TYPE | 신규 28공식 전건 `FRM_TYPE.02`(라이브 선존재 코드). FK 충족 |
| C-6 comp_typ_cd | comp 신규 mint **없음** — 30 comp 전부 라이브 `.06 완제품비` 선존재 |
| C-4 addtn_yn | char(1) CHECK Y/N. 단일=Y, 변형택일=N. 곱셈 표현 없음 |
| C-8 use_yn | 신규 공식 'Y'. PRF_POSTER_FIXED 은퇴='N' |
| FK 선존재 | frm_typ_cd(.02)·comp_cd(30)·prd_cd(28) 전건 라이브 선존재(read-only 확인). 단계0 검증문 포함 |
| reg_dt NOT NULL | `now()` 명시(round-5 적발: 명시 NULL 은 DEFAULT 미발화 → `DEFAULT` 키워드 또는 omit. 본 트랙은 `now()` 명시) |
| 멱등성 | 공식 INSERT = `WHERE NOT EXISTS`; 배선 INSERT = `WHERE NOT EXISTS`; 재바인딩 = DELETE(있으면)+INSERT NOT EXISTS. 2-pass 행변경 0 |

---

## 5. 다른 트랙과의 상호작용 (Slice A / C3)

본 D-WIRE 트랙은 **배선/공식/바인딩**만, Slice A·C3 는 **component_prices 단가 본체**만 적재한다. 둘은 직교하나 **둘 다 적용돼야** 포스터/실사 가격이 실제 조회된다.

- **Slice A** = `02_mapping/silsa-poster-area-matrix/` — 면적매트릭스 13상품 670 BLOCKED(siz 108 미등록 의존) + 17 INSERTABLE.
- **C3** = fixedgrid 73 INSERTABLE component_prices(고정가형 15상품).

### 적용 순서 (FK + 의미 정합)
```
[1] 본 트랙: PRF_POSTER_<X> 28 공식 INSERT  (FRM_TYPE.02 선존재)
[2] 본 트랙: formula_components 30 배선 INSERT  ([1] 후, comp 선존재)
[3] 본 트랙: 재바인딩 (DELETE 28 + INSERT 28)  ([1] 후 — frm_cd FK)
        └ 이 시점에 prd→공식→comp 사슬 '구조' 완성 (단가는 아직 sparse)
[4] Slice C3: component_prices 73 INSERT  (comp 선존재, 본 트랙과 독립 가능)
[5] (인간승인) siz 108 등록 → Slice A: component_prices 670 INSERT
        └ [4][5] 후 매트릭스 단가 본체 충전 → 모든 치수 가격조회 가능
```
- **[1][2][3] ↔ [4][5] 순서 무관**(직교) — 단 **[3] 재바인딩이 없으면** [4][5] 단가를 적재해도 27상품은 여전히 자기 comp 가 공식에 없어 조회 불가. 반대로 [3]만 하고 [4][5] 없으면 사슬은 연결되나 단가 sparse(거의 NULL). → **양쪽 필수**.
- 본 트랙은 component_prices 를 건드리지 않으므로 IDENTITY 시퀀스 무관(공식/배선/바인딩은 surrogate id 없음). Slice A/C3 가 component_prices INSERT 시 setval 가드 적용(각 트랙 책임).

---

## 6. 산출 파일
| 파일 | 내용 | 행수 |
|------|------|:--:|
| `load/t_prc_price_formulas.csv` | 신규 공식 28 | 28 |
| `load/t_prc_formula_components.csv` | 신규 배선 30 | 30 |
| `load/t_prd_product_price_formulas_INSERT.csv` | 재바인딩 추가 28 | 28 |
| `load/t_prd_product_price_formulas_DELETE.csv` | 재바인딩 제거 키 28 | 28 |
| `load.sql` | 멱등 단일 tx (공식·배선·재바인딩·은퇴) + 단계0 FK검증 | — |
| `dryrun-plan.md` | FK 적재순서 + DRY-RUN 게이트(R1~R6) + 설계자 사전점검 | — |
| `README.md` | 트랙 요약·실행 절차 | — |

CSV 공란 = NULL 규약. 헤더 = DB 컬럼명. `_note`/provenance 보조컬럼은 적재 시 note 컬럼으로 매핑(라이브 컬럼만).

---

## 7. 설계결정 — 인간 확인 필요
| ID | 결정사항 | 권고 |
|----|----------|------|
| D-RETIRE | `PRF_POSTER_FIXED`(0상품) 처리 = use_yn='N' 비활성 vs 완전 DELETE | **use_yn='N' 권고**(삭제는 ARTPRINT 배선 FK RESTRICT·운영파괴 → 별건 인간승인) |
| D-WIRE-VARIANT | 폼보드/포맥스 2-comp = 단일공식 2배선 택일(addtn_yn='N') vs 옵션별 2공식 | **2배선 택일 권고**(동일상품 옵션 = CPQ 옵션선택이 comp 결정. 2공식 분리는 과잉) |
| D-FRMTYPE | 신규 공식 유형 = FRM_TYPE.02(라이브 계승) vs .01 | **.02 유지**(완제품가 단일 룩업, 합산 항 없음. 라이브 PRF_POSTER_FIXED 동일) |
| D-OTHER3 | BIND/NAMECARD/PHOTOCARD 동일 broken 3건 재모델 | **별도 트랙 상신**(본 번들 밖). LD-2: 공유공식+택일 설계 폐기·상품별 분리로 통일 |
