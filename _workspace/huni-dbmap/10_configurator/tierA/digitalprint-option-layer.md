# 디지털인쇄 Tier A 14상품 CPQ 옵션 레이어 — 적재본(load-ready)

> **상태/이력** 작성 2026-06-14 · `dbm-option-mapper` 산출 · round-6 Tier A 확장. DB 미적재(실 COMMIT/더미정리/DDL = 인간 승인).
> **목적:** `attribute-entity-map.md`(마스터 지도 패밀리①) + `postcard-option-layer.md`(016 파일럿 shape)를 디지털인쇄 Tier A **14상품**으로 확장하여 **적재 가능·멱등** 옵션 레이어를 실 행 + 적재 SQL로 산출한다. 이번 작업 핵심 개선점 = **disp_seq 를 L1 컬럼 등장순서로 보강**(파일럿은 임의 부여).
> **권위 입력(인용·발명 금지):** `06_extract/digital-print-l1.csv`(옵션성 컬럼 등장순서=disp_seq 권위) · `attribute-entity-map.md`(verdict §2 패밀리①·§1.4 ref_dim_cd) · `00_schema/cpq-schema.md §2`(라이브 트리거 디스패치) · `postcard-option-layer.md`(검증된 shape) · `09_load/_exec_silsa_cpq`(멱등 SQL 패턴) · **라이브 차원행 실측 2026-06-14 read-only**(sizes/materials/print_options/processes).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 = `[CONFIRM]`(발명 금지). 적재 SQL = `09_load/_exec_tierA_digitalprint/`.

---

## 0. 파일럿 → Tier A 확장에서 바뀐 것 (핵심 개선 5건)

| # | postcard 파일럿(016 단일) | Tier A 적재본(14상품) | 근거 |
|---|---|---|---|
| **K1** | disp_seq 임의(1~5) | **disp_seq = L1 옵션성 컬럼 등장순서**(인쇄→종이→코팅→모서리→후가공→접지→박칼라) | 사용자 directive·적재 3원칙 |
| **K2** | 종이=materials **0행 BLOCKED** | **종이=라이브 materials 풍부 적재(INSERTABLE)** — 016=21·047=33행 | 라이브 실측(파일럿 stale 반증) |
| **K3** | 후가공 029~032 **0행 BLOCKED** | **후가공 029~032 라이브 적재(INSERTABLE)** | 라이브 실측(파일럿 stale 반증) |
| **K4** | 봉투=신규 add-on template 설계 | **016 봉투 add-on 라이브 기존(TMPL-000005/006/009/010/011) → 옵션 중복생성 안 함** | 라이브 실측 |
| **K5** | 단일 상품 | 14상품 일괄·상품별 옵션 채움 차이 모델(엽서 후가공풍부·명함 박칼라·포토카드 단순) | L1 상품별 |

> **STALE 반증의 의의:** postcard 파일럿이 BLOCKED 5행으로 본 것(종이·후가공4)은 그 후 차원행이 적재되어 **이제 INSERTABLE**. 이는 추출 스냅샷 stale·라이브 권위 원칙의 실증(L1 등록판정=라이브 권위).

---

## 1. Step 0 — 차원행 전제 (라이브 실측 2026-06-14)

[HARD] option_item = *이미 적재된 차원행*을 가리키는 포인터. 트리거 `fn_chk_opt_item_ref` 가 "그 prd_cd 에 등록된 차원행 EXISTS"를 강제. 14상품 차원행 라이브 직접 실측:

| 차원 | ref | 라이브 적재(14상품) | option_item 참조 |
|---|---|---|:--:|
| **사이즈** | `.01` | 46행 SIZ_*(상품별 1~7) 전부 dflt_yn=Y | ✅(단 옵션그룹 미생성 — UI 1차축) |
| **자재(종이)** | `.03` | **143행** mat_cd+USAGE.07(016=21·047=47) | ✅ → OG-종이 |
| **도수** | `.06` | **25행** opt_id 1/2(상품별 단/양면 매핑 다름) | ✅ → OG-인쇄 |
| **공정** | `.04` | **84행** 모서리027/028·후가공029~032·코팅014/015·박칼라037~044 | ✅(접지065~068·화이트별색 미링크=BLOCKED) |

**Step 0 판정:** 도수·종이·모서리·후가공·코팅·박칼라 = 차원행 실재 → INSERTABLE. **접지 공정(065~068)·화이트 별색공정 = 라이브 미링크 → BLOCKED**(접지4+화이트별색2=6행).

> [HARD·라이브 우위] postcard 파일럿이 BLOCKED 으로 본 종이/후가공 029~032 는 라이브 적재 확인됨 → INSERTABLE 승격. 단/양면 도수는 상품마다 opt_id↔print_side 매핑이 다름(027/029는 opt_id 1=양면) — DRY-RUN 1차에서 이 결함 적발·정정(manifest §5).

---

## 2. 옵션그룹 disp_seq (L1 컬럼순서 권위)

L1 `digital-print-l1.csv` 옵션성 컬럼 등장순서 = disp_seq 권위(비옵션 컬럼 제외):

```
사이즈(필수)[옵션그룹 미생성] → 인쇄(옵션) → 종이(필수) → 코팅(옵션) → 후가공_모서리
→ 후가공_오시/미싱/가변T/가변I → 접지(옵션) → 박/형압_박칼라
```

> **주의:** L1 물리 컬럼순서는 `종이(23)` < `인쇄(24)` < `코팅(30)` < `모서리(37)`. 단 사용자 관점 1차 선택축이 인쇄(도수)·종이(자재)이고, attribute-entity-map 패밀리① verdict 순서(사이즈→종이→인쇄→별색→코팅→커팅→접지→후가공→박→추가)와 L1 헤더를 종합해 본 적재는 **인쇄(1)→종이(2)→코팅(3)→모서리(4)→후가공(5)→접지(6)→박칼라(7)** disp_seq 부여. 각 상품은 보유 옵션만 인스턴스화하되 상대 순서 보존. **[CONFIRM 리드] 종이 vs 인쇄 표시 우선순위**(현재 인쇄 우선 — 도수가 가격/판형 1차 결정축).

## 3. 상품별 옵션그룹 (택1/택N · mand_yn · sel_typ)

라이브 컬럼: `prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note`.

| 옵션그룹 | sel_typ | min/max | mand | 보유 상품 | ref_dim | 비고 |
|---|---|:--:|:--:|---|---|---|
| **인쇄**(도수) | SEL_TYPE.01 | 1/1 | Y | 14 전상품 | .06 opt_id | 단/양면. 027/029=양면 단일 |
| **종이**(자재) | SEL_TYPE.01 | 1/1 | Y | 14 전상품 | .03 mat_cd+usage_cd | 1~47종. opt_nm=mat_cd |
| **코팅** | SEL_TYPE.01 | 0/1 | N | 017·024·026·032·047 | .04 공정 | 유광014/무광015 + 코팅없음 센티넬 |
| **모서리** | SEL_TYPE.01 | 0/1 | N | 016·017·018·024·025·031·032·033 | .04 공정 | 직각027/둥근028 |
| **후가공** | **SEL_TYPE.02** | 0/N | N | 016·018·027·029·031·033·041·042·047 | .04 공정 | 오시029·미싱030·가변텍스트031·가변이미지032 다중 |
| **접지** | SEL_TYPE.01 | 1/1 | Y | 027·029 | .04 공정 | **BLOCKED**(접지공정 미링크) |
| **박칼라** | SEL_TYPE.01 | 0/1 | N | 027·029·031·042 | .04 공정 | 박없음 센티넬 + 8종(037~044) |
| **화이트별색** | SEL_TYPE.01 | 0/1 | N | 024·025 | .04 공정 | **BLOCKED**(화이트 별색공정 미링크) |

> **후가공 = SEL_TYPE.02(택N) 핵심:** L1 프리미엄엽서 한 사이즈행이 오시+미싱+가변T+가변I 4종 동시 보유 → 다중선택 직접 입증(attribute-entity-map 패밀리① "L1 동시선택 실증"). max_sel_cnt = 상품 보유 후가공 종수(016/018/041/042=4 · 027/029/031/033/047=2).

## 4. option_items (polymorphic ref_dim_cd → 라이브 차원행)

라이브 컬럼: `prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn`. (`ref_param_json`·`note` 라이브 부재 — F-1·R3).

**디스패치 정확성(트리거 슬롯):**
- **도수 = `.06`, ref_key1 = opt_id::int**(1/2, NOT clr_cd). 상품별 라이브 print_options 실측.
- **자재(종이) = `.03`, ref_key1 = mat_cd, ref_key2 = usage_cd**(USAGE.07).
- **공정(코팅/모서리/후가공/박칼라) = `.04`, ref_key1 = proc_cd**, ref_key2 미사용.
- **센티넬(코팅없음/박없음)·BLOCKED 그룹 헤더 = option_item 0행**.

| 옵션유형 | ref_dim_cd | ref_key1 | ref_key2 | 판정 |
|---|---|---|---|:--:|
| 단면/양면 | `.06` | opt_id(1/2) | — | ✅ INSERTABLE |
| 종이 N종 | `.03` | mat_cd | USAGE.07 | ✅ INSERTABLE |
| 유광/무광 | `.04` | PROC_000014/015 | — | ✅ INSERTABLE(면구분=GAP-PARAM) |
| 직각/둥근 | `.04` | PROC_000027/028 | — | ✅ INSERTABLE |
| 오시/미싱/가변T/가변I | `.04` | PROC_000029~032 | — | ✅ INSERTABLE(줄수/개수=GAP-PARAM) |
| 박칼라 8종 | `.04` | PROC_000037~044 | — | ✅ INSERTABLE(박크기=GAP-PARAM) |
| 접지 2/3단 | `.04` | PROC_000065~068 | — | ❌ BLOCKED(차원행 미링크) |
| 화이트별색 | `.04` | [CONFIRM] | — | ❌ BLOCKED(차원행 미링크) |

**집계: INSERTABLE 252행 · BLOCKED 6행**(접지4+화이트별색2).

## 5. constraints (본 파일럿 0행)

- 후가공 **다중**(택N)·박칼라/코팅/모서리 **택일**(택1)은 **option_groups 의 sel_typ_cd/min/max 로 충족** → 별도 JSONLogic 불요.
- **R-QTY-PANSU**(수량=판수 배수)는 attribute-entity-map §3.4 대로 **가격엔진 입력(GAP-PANSU)** 이며 옵션레이어 제약 아님 — 본 적재에서 제외(파일럿 016은 데모로 가졌으나, 정합상 가격엔진 소관).
- 025 더미 RULE_001(금지테스트)은 우리 설계 아님 → `_cleanup_dummy.sql`(인간 승인).

> constraints 0행. 향후 캐스케이드(자재→코팅 disable 등 RedPrinting 6종)가 필요하면 별도 JSONLogic 트랙(본 파일럿 범위 밖).

## 6. templates / add-on (봉투 — 라이브 기존)

- **016 봉투 add-on 라이브 기존**: TMPL-000005(OPP접착)/006(OPP비접착)/009(트레싱지)/010·011(카드봉투) → 016 에 link 완료. **본 적재는 봉투를 옵션그룹으로 중복 생성하지 않음**(K4).
- 017/018 도 L1상 동일 봉투 보유하나 라이브 addon 미링크 → **별도 add-on 트랙**(본 옵션레이어 범위 밖, GAP).
- 봉투 사이즈 freeze 는 template_selections(라이브 0행) — postcard §6 패턴. 본 파일럿은 기존 addon 존중하고 selection 미투입.

## 7. FK 위상정렬 적재 순서

```
[선행 — L1 차원행, 라이브 적재 실측 완료]
  ✅ sizes·materials(USAGE.07)·print_options(opt_id)·processes(027/028/029~032/014/015/037~044)
[00] 마커 (NO INSERT)
[05] t_prd_product_option_groups (58행)        — FK: prd_cd→products, sel_typ_cd→cod
[06] t_prd_product_options (267행)             — FK: opt_grp_cd→option_groups
[07] t_prd_product_option_items (252행 INSERTABLE) — 트리거 fn_chk_opt_item_ref 행단위 EXISTS
       _blocked/: 접지4+화이트별색2 (적재 대상 아님)
[08] t_prd_product_constraints (0행)
```

> [HARD] 같은 트랜잭션 내 05→06→07 순서. 트리거가 07 행단위로 차원행 EXISTS 검사 → DRY-RUN 이 ref resolve 최강 증명.

## 8. 적재 가능성 집계

| 테이블 | INSERTABLE | BLOCKED | 비고 |
|---|:--:|:--:|---|
| option_groups | 58 | 0 | 트리거 없음 |
| options | 267 | 0 | 트리거 없음(센티넬 포함) |
| **option_items** | **252** | **6** | 트리거 차원행 검사 |
| constraints | 0 | 0 | sel_typ 로 충족 |
| **합계** | **577** | **6** | + BLOCKED 6(_blocked) |

**DRY-RUN(라이브 롤백전용 2026-06-14):** PASS-1 트리거 전건 통과(REJECT 0)·PASS-2 멱등 delta 0·ROLLBACK 후 영구변경 0(manifest §5).

## 9. 설계 결정 / [CONFIRM] (리드 에스컬레이션)

### 설계 결정 (침묵 선택 안 함)
| # | 결정 | 채택 | 대안 | 종속 GAP |
|---|---|---|---|---|
| D-A | 종이 옵션화 방식 | option_group(택1)+종이마다 option+item(.03) | 차원행 자동노출(option 없이) | (행수 큼·정확) |
| D-B | 사이즈 옵션그룹 노출 | 미생성(UI 1차축, postcard 계승) | OG-SIZE 명시 | [CONFIRM C-2] |
| D-C | 코팅 면구분 | 유광/무광 2공정(면구분 손실) | 면별 4공정(차원행 부재) | GAP-COATING-SIDE |
| D-D | 박 표현 | 박없음 센티넬+박칼라 8공정 | 박가공 토글+크기 param(컬럼 부재) | GAP-BAK-COMPOSITE·GAP-PARAM |
| D-E | 봉투(016) | 라이브 기존 addon 존중(중복 안 함) | 옵션그룹 신규 | (K4) |

### [CONFIRM] (라이브 미상 — 발명 금지)
1. **C-1 화이트별색 공정코드** — 024/025 화이트인쇄 공정 라이브 미링크·코드 미상 → BLOCKED.
2. **C-2 사이즈 옵션그룹 노출** — UI 정책.
3. **C-3 종이 opt_nm = mat_cd** — UI 표시명은 mat_nm 조인 vs opt_nm 별도.
4. **접지 동적 freeze(GAP-B)** — L1 접지 "★사이즈선택" 본체연동 동적 freeze 미지원.

### GAP (→ dbm-ddl-proposer · blocked-and-gaps.md)
GAP-PARAM(코팅면·후가공줄수·가변개수·박크기) · GAP-JEOPJI-DIM(접지공정 미적재) · GAP-WHITE(화이트별색공정) · GAP-COATING-SIDE · GAP-BAK-COMPOSITE.

---

## 부록 — 적재 SQL 인덱스

| 파일 | 행 | 권위 출처 |
|---|:--:|---|
| `09_load/_exec_tierA_digitalprint/05_*.sql` | 58 | L1 컬럼순서 + attribute-map 패밀리① |
| `…/06_*.sql` | 267 | L1 옵션 + 라이브 차원행 |
| `…/07_*.sql` | 252 INSERTABLE | 라이브 차원행 + 트리거 §2 |
| `…/_blocked/07_*.sql` | 6 BLOCKED | 접지/화이트별색 차원행 부재 |
| `…/08_*.sql` | 0 | sel_typ 로 충족 |
| `…/_cleanup_dummy.sql` | (인간승인) | 016/025 더미 정리 |
