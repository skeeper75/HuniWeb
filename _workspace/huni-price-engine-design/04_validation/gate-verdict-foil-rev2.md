# gate-verdict-foil-rev2.md — 박류(foil) 설계 REV2 E4 재게이트

> hpe-validator(Claude) 독립 재실측 · 2026-06-30 · 폐루프(REV2) 후 변경분만 재게이트.
> 검증 대상: `03_design/design-decisions-foil-rev2.md` + `engine-design-foil.md` §5(전면 재작성)·§0·§3·§4·§7.
> 이전 게이트: `04_validation/gate-verdict-foil.md`(E4 CONDITIONAL=B-FOIL-1 addon 바인딩 깨짐).
> 권위[HARD]: 가격표 박 시트 > 라이브 t_prc_*/t_proc_* > 역공학/경쟁사. 단일 FAIL=NO-GO.
> 규칙: 생성자 주장 비신뢰·라이브 직접 재실측·DB 미적재·읽기전용. B-FOIL-2(면적→등급 엔진 미지원)=코드트랙(C·개발팀)으로 분리.

---

## 재게이트 범위 (carry-forward)

이전 E1·E2·E3·E5·E6·E7 = PASS(설계 데이터 그릇·골든 산술 불변). **변경분 = E4 + 그 종속(E5 작동·E6 실재현)**. REV2는 ① B-FOIL-1 바인딩 재결정(addon→본체 공식 합산) ② B-FOIL-2 코드트랙 분리 ③ B-FOIL-3 근거 2건 정정. 아래 변경분만 라이브 직접 재실측.

---

## B-FOIL-1 해소 확인 · **해소됨 (PASS)**

이전 NO-GO 사유 = "박가공비 다차원을 addon 템플릿(단일 고정단가)에 담아 ×qty 폭발". REV2가 **본체 공식 formula_components 직접 합산**으로 전환. 라이브 직접 재실측으로 designer 주장 전건 교차.

### (a) 패턴 1 — 명함박 공식이 박 comp를 직접 합산 (designer 주장 ✅ 확정)

라이브 SELECT (`t_prc_formula_components` JOIN `t_prc_price_components`):

```
PRF_NAMECARD_FOIL formula_components:
  COMP_NAMECARD_FOIL_S1_STD       disp_seq=1 addtn_yn=Y  PRICE_TYPE.02  COMPONENT_TYPE.06  use_dims=["min_qty"]
  COMP_NAMECARD_FOIL_SETUP_S1_STD disp_seq=2 addtn_yn=Y  PRICE_TYPE.03  COMPONENT_TYPE.05  use_dims=["min_qty"]
```

- ✅ **addon 템플릿 아님 — 본체 공식 formula_components로 박가공비(.02) + 동판비(.03) 직접 합산.** designer §1-2·§5-1 주장 라이브 정확.
- ✅ 동판비 = `.03 고정금액` → `pricing.py:204-205` unit 그대로·×qty 0. designer "동판비 .03·×qty 금지" 정합.
- ✅ 박가공비 = `.02 합가형` → `pricing.py:206-211` `per_item=unit÷min_qty`, `subtotal=per_item×qty`. qty=min_qty 구간이면 unit 그대로 환원 → **×qty 폭발 없음**. `min_qty<=0`이면 ValueError(NULL 가드). designer C-3~C-6 prc_typ=.02 설계 정합.

### (b) 패턴 2 — PRF_DGP_E 후가공 comp 본체 공식 합산 + proc_cd 차원 미선택 0 (designer 주장 ✅ 확정)

라이브 SELECT (`PRF_DGP_E` formula_components 9 comp):

```
COMP_PRINT_DIGITAL_S1  .01  ["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]
COMP_COAT_GLOSSY/MATTE .01  ["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]
COMP_PAPER             .01  ["plt_siz_cd","mat_cd"]
COMP_FOLD_LEAF_HALF    .01  ["proc_cd","min_qty","proc_grp:PROC_000056"]
COMP_FOLD_LEAF_3FOLD   .01  ["proc_cd","min_qty","proc_grp:PROC_000056"]
COMP_FOLD_LEAF_4ACC    .01  ["proc_cd","min_qty","proc_grp:PROC_000056"]
COMP_FOLD_LEAF_4GATE   .01  ["proc_cd","min_qty","proc_grp:PROC_000056"]
COMP_CUT_PERF_1H6      .01  ["proc_cd","min_qty","proc_grp:PROC_000079"]
```

- ✅ **접지 comp 4개(HALF/3FOLD/4ACC/4GATE)가 한 공식에 동시 배선**되나 proc_cd+proc_grp 차원으로 선택분만 매칭. designer §5-2 "선택분 1개만 매칭·나머지 0" 정확.
- ✅ **proc_cd 단가행 100% 충전 확인** (silent 합산 차단의 핵심): `COMP_COAT_GLOSSY` 92행 전부 proc_cd=PROC_000014, `COMP_FOLD_LEAF_3FOLD` 48행 전부 PROC_000060, `COMP_FOLD_LEAF_HALF` 48행 전부 PROC_000107. 단가행에 proc_cd가 NULL이 아니라 실제 충전돼야 미선택 시 no_match→0이 보장된다(`pricing.py:601` "판별차원 없음=항상 매칭" 함정 회피). designer가 7상품 박가공비 comp에 동형 proc_cd 충전을 설계(§2-2·§5-2)한 것은 이 라이브 작동 패턴과 정합.

### (c) 본체 합산 경로 ×qty 폭발 0 (코드 재실측)

`pricing.py:565-624` `_match_entry`/`_no_match_detail` 직접 확인:

- `m["row"] is None`(no_match) → `entry["included"]=False`·`subtotal=Decimal(0)` → 합산 제외(line 616~624). **박 미선택 = 0 확정.**
- `pricing.py:577` verbatim: "미선택은 '데이터 없음'이 아니라 '미선택'(예: 공정 안 고름) — 빵꾸로 안 봄". designer §5-2 인용 정확(라인 번호도 일치).
- 동판비 .03(×qty 0) + 박가공비 .02(min_qty 구간 unit 환원) → 둘 다 비-수량비례. **이중 ×qty 폭발 0이 본체 공식 합산 경로에서 라이브 엔진 계약으로 성립.** addon 경로(unit_price×qty)와 달리 폭발 없음 — designer 부결 판단(addon) 정당.

**∴ B-FOIL-1 = 해소.** 이전 거짓단정(§5-3 "addon 이중×qty 0 가드 통과")을 REV2가 폐기하고, 라이브 작동 입증 패턴(명함박/접지카드 = 본체 공식 합산)으로 재결정. designer 주장이 라이브 6쿼리+코드 3구간으로 전건 교차됨.

---

## U-7 silent 합산 차단 확인 · **PASS**

박 comp가 본체 공식에 들어가도 박 미선택 상품/케이스에서 0 보장되나(proc_cd 매칭) 라이브 재실측.

| 검사 | 결과 | 근거(라이브/코드) |
|---|---|---|
| 박 미선택 시 0 | ✅ | proc_cd 미충전→no_match→included=False→subtotal=0 (pricing.py:616-624). PRF_DGP_E 접지 4개 중 선택분만 합산이 실증 |
| 일반/특수 동시배선 가드 | ✅ | 박색상 proc_cd 정확매칭으로 한쪽만 활성·다른 그룹은 proc_cd 불일치→no_match. PRF_DGP_E 접지 4 comp 패턴과 동형 |
| proc_grp:PROC_000033 한정 | ✅ | 박 그룹 안에서만 매칭·타 후가공(코팅 PROC_000013·접지 PROC_000056)이 박 comp를 깨우지 않음 |
| 단가행 proc_cd 충전 필수성 | ✅ designer 정합 | 라이브 후가공 comp가 proc_cd 100% 충전(NULL 아님)이라 "판별차원 없음=항상 매칭"(pricing.py:601) 함정 회피. designer C-3~C-6 use_dims에 proc_cd 명시 |

★ **명함박과의 차이 정확 식별**: 명함박 `COMP_NAMECARD_FOIL_S1_STD` 단가행은 **proc_cd NULL**(use_dims=["min_qty"]만) — 박이 완제품가에 통합돼 항상 거는 .06 comp라 박색상 판별 불요. 7상품은 박이 **선택적**이라 proc_cd 충전이 필수. designer가 이 차이를 정확히 설계(명함박 모델 답습 안 하고 PRF_DGP_E 후가공 패턴 채택). 명함박을 그대로 복사했다면 박 미선택 케이스에서 silent 합산 위험이 있었을 것 — designer가 이를 회피.

---

## B-FOIL-3 정정 반영 확인 · **PASS**

| 항목 | REV1(부정확) | REV2 | 라이브 재실측 |
|---|---|---|---|
| 박 자식공정 종수 | "13종(037~049)" | **16종**(034~049) | ✅ `t_proc_processes WHERE upr_proc_cd='PROC_000033' AND use_yn='Y' AND del_yn='N'` = **16** (PROC_000034 금·035 은·036 핑크 + 037~049). designer REV2 정정 정확 |
| 명함박 comp 주석 | "명함박 .06=박만" | "종이+동판+박 통합 완제품가(.06)" | ✅ `COMP_NAMECARD_FOIL_S1_STD` comp_typ_cd=`PRC_COMPONENT_TYPE.06`·comp_nm="...완제품가 단면·일반박(종이+동판+박)". designer 정정 정확. 7상품 박가공비는 박 단독 .01로 모델 다름 |

신규 7상품 comp 설계엔 무영향(근거 주석만 정정). search-before-mint 신규=5 comp만·박 자식공정 16종 재사용(0 mint).

---

## G6 확정 + 골든 8/8 불변 · **PASS**

- ✅ **G6 라이브 확정**: `COMP_NAMECARD_FOIL_S1_STD` 1000구간 = **63,000** vs 권위 64,000 = **−1,000 1셀 오적재**. 200~900구간(19,200/24,800/.../58,400)은 권위 verbatim 일치 → 동판비 SETUP(.03 별도 comp) 합산 정상·갭은 1000구간 1셀뿐. REV1 추정 "동판비 미합산" 반증 확정. designer §4 결론(7상품=권위 64,000 verbatim·명함박 답습 금지) 정합.
- ✅ **골든 8/8 불변**: G-F1~G-F8 기대값(138,000·168,000·66,000·69,000·19,300·138,000·314,000·37,500)이 이전 E6 PASS와 완전 동일. `golden-cases-foil.md` REV2가 미터치. E6 재판정 불요(산술 허용오차 0 유지).

---

## E4 재판정 · **PASS** (이전 CONDITIONAL → PASS)

| 검사 | 이전 | REV2 | 근거 |
|---|---|---|---|
| 동판비 prc_typ=.03·×qty 0 | ✅ | ✅ | pricing.py:204-205 |
| 박가공비 prc_typ=.02+min_qty | ✅ | ✅ | pricing.py:206-211·min_qty NOT NULL ValueError 가드 |
| proc_cd+proc_grp 차원 라이브 실재 | ✅ | ✅ | PRF_DGP_E 후가공 9 comp 실측 |
| 박 자식공정 재사용(mint 0) | ✅ | ✅ | 16종 라이브 실재 |
| **박가공비 바인딩 메커니즘** | ⛔ addon 깨짐 | ✅ **본체 공식 합산** | PRF_NAMECARD_FOIL/PRF_DGP_E 라이브 작동 패턴·proc_cd 미선택 0 |
| **silent 합산/×qty 폭발 가드** | ⛔ §5-3 거짓단정 | ✅ **본체 경로 한정 성립** | proc_cd no_match→included=False(pricing.py:616-624)·동시배선 선택분만 매칭 실증 |
| 면적→등급(grade) 환산 엔진 | ⛔ 코드트랙 | ⛔ **코드트랙 분리 명기(B-FOIL-2)** | NON_QTY_DIMS/TIER_DIMS에 grade 없음(pricing.py:42-50). **설계 결함 아님** — 데이터 그릇 정확·엔진 능력 선결 |

**E4 = PASS.** B-FOIL-1(돈크리티컬 바인딩)이 라이브 작동 입증 패턴으로 해소·이전 거짓단정 폐기·×qty 폭발 위험 제거. 잔여 B-FOIL-2(면적→등급 환산)는 **코드트랙(C·개발팀)으로 정당 분리** — 데이터 설계 결함이 아니라 엔진 능력 미확정(설계측이 정직 분류·Q-FOIL-CODE1 High). 단가행 그릇은 권위 verbatim·골든 8/8 일치.

---

## 게이트 종합 (REV2)

| 게이트 | 이전 | REV2 |
|---|---|---|
| E1 공식 추출 충실성 | PASS | PASS(carry·B-FOIL-3 정정 반영) |
| E2 구성요소 분해 정합 | PASS | PASS(carry·명함박 주석 정정 반영) |
| E3 경쟁사 흡수 타당성 | PASS | PASS(carry) |
| **E4 엔진 설계 건전성** | **CONDITIONAL** | **PASS** ★해소 |
| E5 세트 조합 정합 | PASS(작동 E4 종속) | PASS(본체 합산 작동 입증으로 종속 해소) |
| E6 골든 재현 | PASS(산술) | PASS(골든 8/8 불변·실재현은 고정사이즈 collapse 상품만 현 엔진 작동) |
| E7 생성-검증 독립성 | PASS | PASS(designer 주장 6쿼리+3코드구간 직접 교차·베끼지 않음) |

**종합 = GO.** 단일 FAIL 없음. E4가 CONDITIONAL→PASS로 해소(본체 공식 합산 전환). 데이터 그릇·골든 산술 건전.

---

## 잔여 (분리 명기)

1. **B-FOIL-2 면적→등급 환산 = 코드트랙(C·개발팀)** — `pricing.py:42-50` NON_QTY_DIMS/TIER_DIMS에 grade 없음. **데이터 설계 결함 아님**(설계측 정직 분류). 고정사이즈 상품(명함박·펄명함·프리미엄명함)은 단일등급 collapse → 현 엔진 작동. 가변사이즈 상품(2/3단접지카드·무선/PUR책자)은 면적→등급 환산이 선결 → dbm-price-arbiter 심의·Q-FOIL-CODE1(High). **이 트랙이 닫히기 전 가변상품 적재 보류가 정합(돈크리티컬).**
2. **G6 명함박 1셀 오적재(63,000→64,000)** — 명함박 라이브 교정 후보(검증/C트랙·인간 승인). 7상품 설계는 권위 64,000 verbatim·명함박 미터치(답습 금지).
3. **CONFIRM 큐(설계 무영향)** — Q-FOIL-SIZE1(대형/소형 경계·실무 컨펌)·Q-FOIL-SETUP1(소형 동판비 신설 vs 공유)·Q-FOIL-FACE1(면 차원 없음 확인).

## 라우팅

- **dbmap 위임(인간 승인 후)**: 5 comp 신설 + 고정사이즈 4상품(명함박류·collapse) 본체 공식 formula_components에 박 comp 직접 합산 배선. 단가행 권위 verbatim. comp_cd=COMP_FOIL_*(MAX+1).
- **dbm-price-arbiter**: B-FOIL-2 면적→등급 환산 엔진 지원(High). 가변상품(접지카드/책자)은 이 트랙 선결 후 적재.
- **codex 2차 교차(Phase 5.5)**: hpe-codex-validator가 본 E4 PASS 결론을 독립 재판정 중(reconcile는 오케스트레이터).
</content>
</invoke>
