# design-decisions-foil-rev3.md — 박류(foil) 설계 폐루프 보정 REV3 변경 이력

> hpe-engine-designer 폐루프 보정 · 2026-06-30 · **codex 2차 교차 reconcile** 판정에 대한 designer 재결정.
> 입력: `05_codex/codex-reconcile-foil.md`(codex gpt-5.5 read-only high ↔ Claude validator E1~E7 reconcile).
> 보정 대상: `03_design/{engine-design-foil,design-decisions-foil-rev2}.md`. 골든(`golden-cases-foil.md`)은 **변경 없음**(8/8 권위 verbatim 일치·codex 독립 재계산도 8/8 확인).
> 권위[HARD]: 가격표 박(대형/소형) 시트 절대 · 단가 verbatim · DB 미적재 · 라이브 읽기전용 · webadmin 코드 직접수정 금지 · 동판비 게이트는 박가공비와 동형(proc_cd 충전)으로 silent 과청구 0 보장.

---

## 0. 보정 트리거 — codex가 validator E4 CONDITIONAL이 놓친 돈크리티컬 적발

codex gpt-5.5(read-only·high)가 설계 본문 + `pricing.py`로 독립 2차 교차검증을 수행해, **Claude validator(E1~E7)와 REV2 보정이 모두 놓친 동판비 게이트 누락(돈크리티컬)을 적발**했다(생성≠검증·독립 2차 교차의 가치 입증). reconcile 매트릭스(`05_codex/codex-reconcile-foil.md` §1): 8축 합의(고신뢰 확정) + 동판비 게이트 1축 불일치(codex 단독·★Claude 라이브 재확인으로 가설→확정 격상) + 표 정합 2건.

REV3은 codex 적발 3건(R-FOIL-CDX1~3)을 폐루프 보정한다.

---

## 1. R-FOIL-CDX1 [돈크리티컬·반드시 보정] — 동판비 comp proc_cd 게이트 누락

### 1-1. codex 발견 + Claude 라이브 재확인 (가설→확정)

codex 주장 = 동판비 comp(C-1 대형 `use_dims=["siz_width","siz_height"]`·C-2 소형 `use_dims=[]`)에 **proc_cd가 없다**. Claude가 라이브 코드 + 설계 본문으로 독립 재확인:

| 재확인 항목 | 결과 |
|---|---|
| `pricing.py:99-111 _row_matches` | `for d in NON_QTY_DIMS: rv=row.get(d); if rv is None: continue` = **행 차원이 NULL이면 와일드카드(어떤 선택값이든 통과)** 확인 |
| 동판비 단가행 proc_cd NULL의 결과 | 박 미선택 주문(selections에 proc_cd 없음)도, 그 주문의 실제 사이즈(siz_width/height)에 동판비 tier행이 매칭 → **동판비(소형 5,000·대형 면적별 11,000~64,000) 상시 청구**(silent 과청구) |
| 박가공비 comp(C-3~C-6) 대조 | use_dims에 `proc_cd` 보유 → 박 미선택 시 selections.proc_cd 부재로 no_match(0). **동판비(C-1/C-2)만 게이트 누락** |
| REV2 §5-2 "박 미선택 0 보장" 논거 | proc_cd 차원을 근거로 하나 이는 **박가공비에만 성립**·동판비 comp는 proc_cd 부재라 그 논거가 적용 안 됨. REV2가 동판비 게이트를 미적시한 누락 |

∴ **codex 신규 결함은 가설이 아니라 라이브 코드+설계 본문으로 재확인된 실 돈크리티컬 결함**(박 미선택 주문 상시 과금).

### 1-2. ★라이브 명함박 SETUP use_dims 재실측 (동형 패턴 확인)

보정 권고대로 라이브 명함박 SETUP(`COMP_NAMECARD_FOIL_SETUP_*`) use_dims를 직접 SELECT(2026-06-30·읽기전용):

```
COMP_NAMECARD_FOIL_SETUP_S1_STD  PRC_COMPONENT_TYPE.05  PRICE_TYPE.03  use_dims = ["min_qty"]
COMP_NAMECARD_FOIL_SETUP_S2_STD  PRC_COMPONENT_TYPE.05  PRICE_TYPE.03  use_dims = []
COMP_NAMECARD_FOIL_S1_STD        PRC_COMPONENT_TYPE.06  PRICE_TYPE.02  use_dims = ["min_qty"]   (본체 완제품가)
COMP_NAMECARD_FOIL_S1_HOLO       PRC_COMPONENT_TYPE.06  PRICE_TYPE.02  use_dims = ["min_qty"]
...
PRF_NAMECARD_FOIL formula_components = COMP_NAMECARD_FOIL_S1_STD + COMP_NAMECARD_FOIL_SETUP_S1_STD  (2행)
```

**★결정적 재실측 결과**: 명함박 SETUP/본체 comp 모두 use_dims=`["min_qty"]`(또는 `[]`)으로 **proc_cd가 없다**. 명함박은 박을 **항상 거는 박 전용 상품**(PRF_NAMECARD_FOIL이 동판비+박가공비를 박 선택 여부와 무관하게 무조건 합산·박 미선택 주문 자체가 존재하지 않음)이라 동판비에 proc_cd 게이트가 불필요하다.

∴ **보정 권고가 예상한 그대로 — 명함박은 박 항상 거는 상품이라 proc_cd NULL·7상품엔 답습 금지·proc_cd 충전 필수.** 7상품(2단/3단접지카드·프리미엄명함·펄명함·프리미엄쿠폰·무선책자·PUR책자)은 박을 **선택적으로** 거는 상품이라, 명함박 SETUP use_dims를 답습하면 박 미선택 주문에 동판비가 상시 과금된다.

### 1-3. 동형 패턴 라이브 실증 (접지카드 PRF_DGP_E)

박 선택형 상품의 정합 게이트 패턴을 라이브에서 확인(2026-06-30·SELECT):

```
PRF_DGP_E 후가공 comp use_dims (전건 proc_cd 충전):
COMP_COAT_GLOSSY    PRICE_TYPE.01  ["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]
COMP_COAT_MATTE     PRICE_TYPE.01  ["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]
COMP_CUT_PERF_1H6   PRICE_TYPE.01  ["proc_cd","min_qty","proc_grp:PROC_000079"]
COMP_FOLD_LEAF_3FOLD PRICE_TYPE.01 ["proc_cd","min_qty","proc_grp:PROC_000056"]
COMP_FOLD_LEAF_4ACC  ...
COMP_FOLD_LEAF_4GATE ...
COMP_FOLD_LEAF_HALF  ...
```

접지카드(박 선택형)의 후가공 comp는 **전건 use_dims에 proc_cd 100% 충전** → 손님이 안 고른 후가공은 proc_cd no_match로 0(`pricing.py:601`의 "판별차원 없음=항상 매칭" 함정 회피). 동판비도 이 동형으로 proc_cd를 게이트로 걸어야 한다.

### 1-4. designer 보정 결정

| comp | REV2 use_dims | **REV3 use_dims(보정)** |
|---|---|---|
| C-1 COMP_FOIL_SETUP_LARGE(대형 동판비) | `["siz_width","siz_height"]` | **`["proc_cd","siz_width","siz_height"]`** |
| C-2 COMP_FOIL_SETUP_SMALL(소형 동판비) | `[]` | **`["proc_cd"]`** |

- **단가행 proc_cd 충전**: 동판비는 박색상과 무관하게 동일값(면적/단일값만 좌우)이라, 박 그룹 전 색상(박 자식공정 PROC_000034~049)에 같은 값을 곱셈 충전하거나 상품별 등록 박색상 proc_cd에만 충전. **proc_cd가 NULL이 아니어야** 게이트가 걸린다(R-FOIL-CDX3·proc_grp는 게이트력 없음).
- **결과**: 박 미선택 주문 = 동판비 proc_cd no_match → 0(박가공비와 동형). 박 선택 주문 = 그 박색상 proc_cd 매칭 + 면적 매칭 → 동판비 1행 정상 청구.
- **반영**: `engine-design-foil.md` 헤더 REV3 노트·§0 가드(다) 신설·C-1/C-2 표·§5-2·§5-4·§7 계약표·§8 큐 갱신.

### 1-5. 재검증 라우팅

- validator E4 재게이트(동판비 게이트 반영 확인) + 라이브 시뮬레이터로 "박 미선택 주문 = 동판비 0·박가공비 0" 실증(인간 승인 후 dbmap 적재 → §13/§21 검증 트랙).
- **위상**: REV3 동판비 게이트 보정 + 재게이트 GO까지 박 설계 = CONDITIONAL → 보정 반영 후 수렴 기대.

---

## 2. R-FOIL-CDX2 [저위험·표 정정] — C-3/C-5 본문 표 prc_typ `.01` stale

### 2-1. codex 발견

C-3(대형 박가공비 일반박)·C-5(소형 박가공비 일반박) 본문 표의 `prc_typ_cd`가 **`.01`(단가형)**으로 적혀 있는데, §4-가드 결론은 **`.02`(합가형)+min_qty=구간하한**이다(단가형 .01은 ×qty 폭발 위험이라 부결). 표와 결론이 모순 → 구현자가 표만 보면 `.01`로 적재 → `unit_price×qty` 폭발(예 75,000×1000=7,500만).

### 2-2. designer 정정

- C-3/C-5 본문 표 `prc_typ_cd`를 **`.02`로 수정** + "이전 표 `.01`은 stale·결론은 항상 .02" 명기.
- C-4/C-6(C-3/C-5 동형 서술)은 이미 결론 .02 참조. 골든 산술 불변(.02+min_qty 메커니즘은 REV2에서 이미 확정·골든 8/8 일치).
- **반영**: `engine-design-foil.md` C-3·C-5 표 prc_typ_cd 행.

---

## 3. R-FOIL-CDX3 [표기 정밀화] — proc_grp는 코드상 매칭 차단 차원 아님

### 3-1. codex 발견

`use_dims`에 표기된 `proc_grp:PROC_000033`은 박 그룹을 식별하는 **메타 표기일 뿐, `pricing.py:99-111 _row_matches`의 매칭 차단 차원이 아니다**(차단력=proc_cd·dim_vals만). REV2 본문 일부가 "proc_grp:PROC_000033(박 그룹) 한정"을 차단 메커니즘처럼 서술 → proc_grp만 두고 proc_cd를 비우면 게이트가 안 걸린다는 오해 소지.

### 3-2. designer 정밀화

- use_dims 표기에서 proc_grp는 "박 그룹 식별 메타·코드상 차단 차원 아님" 명기. **실제 박 선택 여부 차단력은 proc_cd 정확매칭**이 한다고 일원화.
- 박가공비 use_dims 핵심 표기를 `["proc_cd","min_qty"]`로 정리하고 proc_grp는 괄호 보조 메타로 분리.
- **반영**: `engine-design-foil.md` §2-1(2번 근거)·C-3/C-5 use_dims 행·§5-2(1·2번)·§7 계약표 P3-DEF.

---

## 4. 불변 (codex도 확인·건드리지 않음)

| 항목 | 위상 |
|---|---|
| 골든 8/8 권위 verbatim 일치 | ✅ 불변 — codex 독립 재계산도 8/8 일치(reconcile §1·고신뢰 확정) |
| 박가공비 .02 + min_qty 작업1건 고정 모델 | ✅ 불변(codex 합의·×qty 폭발 0·pricing.py:205) |
| 본체 공식 formula_components 직접 합산 바인딩(addon 부결) | ✅ 불변(codex 합의·REV2 B-FOIL-1) |
| B-FOIL-2 면적→등급 환산 엔진 미지원=C트랙 분리 | ✅ 불변(codex 합의·고정사이즈 collapse만 현 엔진 작동) |
| G6 명함박 1000구간 1셀 오적재(63,000 vs 권위 64,000) | ✅ 불변(codex 합의·답습 금지·7상품 권위 64,000 verbatim) |
| 권위 가격모델 해석(동판비+박가공비·대형 면적/소형 고정) | ✅ 불변(codex 합의·E1 PASS) |

---

## 5. CONFIRM 큐 (REV3)

| ID | REV3 상태 |
|---|---|
| **R-FOIL-CDX1** | ★돈크리티컬 — 동판비 proc_cd 게이트 보정 완료(C-1/C-2 use_dims)·라이브 명함박 SETUP 재실측으로 "박 전용 상품은 게이트 불요·7상품 박 선택형은 충전 필수" 확정·validator E4 재게이트+시뮬레이터 실증 대기 |
| R-FOIL-CDX2 | 표 정정 완료(C-3/C-5 .01→.02)·구현자 혼동 제거 |
| R-FOIL-CDX3 | 표기 정밀화 완료(proc_grp=그룹 메타·게이트=proc_cd)·일원화 |
| Q-FOIL-CODE1 | ⛔ 면적→등급 환산 미지원 확정·C트랙(High)·불변 |
| Q-FOIL-SIZE1 | 유효(권위 면적임계 없음·범위겹침)·실무진 컨펌·Medium |
| Q-FOIL-SETUP1 | 신설 권장 유효·Low. ★REV3에서 소형 동판비는 명함박 SETUP 공유 시 use_dims `["min_qty"]` 답습 위험이 추가 부각(proc_cd 게이트 필요)이라 **신설 권장 강화** |
| Q-FOIL-FACE1 | 권위에 면 차원 없음 확인·실무진 컨펌·Medium |
| Q-FOIL-G6 | ✅ 1셀 오적재 확정·명함박 라이브 교정 후보·답습 금지·Medium |

---

## 6. 다음 행동 (라우팅)

1. **dbmap 위임(인간 승인 후)** — G1 박 5 comp 신설 시 ★동판비 C-1/C-2 use_dims에 proc_cd 포함 + 단가행 proc_cd 충전(박 선택 시만 매칭)·박가공비 C-3~C-6 .02+min_qty 권위 verbatim·각 7상품 본체 공식 formula_components 합산 배선. comp_cd=COMP_FOIL_*(MAX+1·separator `_`).
2. **validator E4 재게이트 + codex 3차** — REV3 동판비 게이트 보정 반영 확인 + 라이브 시뮬레이터로 박 미선택 주문 동판비 0 실증.
3. **dbm-price-arbiter 심의** — B-FOIL-2 면적→등급 환산(grade) 엔진 지원(Q-FOIL-CODE1 High·불변).
4. **검증/C트랙** — G6 명함박 1셀 오적재 별도 라이브 교정 후보(불변).

★ **요약**: 박 가격모델 추출·골든 산술·본체 공식 합산·박가공비 .02 모델은 정확(불변·codex 합의). REV3 보정 = ① **동판비 comp proc_cd 게이트 추가**(R-FOIL-CDX1·돈크리티컬·박 미선택 상시 과금 0 보장·명함박 SETUP 답습 금지) ② C-3/C-5 표 .02 정정(R-FOIL-CDX2) ③ proc_grp 표기 정밀화(R-FOIL-CDX3). codex가 validator E4 CONDITIONAL이 놓친 동판비 게이트를 적발 = 생성≠검증·독립 2차 교차의 가치 입증.
