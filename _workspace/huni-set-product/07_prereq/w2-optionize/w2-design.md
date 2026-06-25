# W2 — 면지/굿즈/라벨 자재의 CPQ 옵션화 설계

> 셋트상품 자재 정합 선행조건 W2. §7 dbmap CPQ L2 패턴(polymorphic `ref_dim_cd` · option_groups/options/option_items) 적용.
> **라이브 읽기전용 SELECT만 수행 · DB 미적재**(COMMIT/UPDATE/DELETE/DDL/mint 0). 실 적재는 인간 승인 후 별도 트랙(dbm-cpq-option-mapping/load-execution).
> 실측일 2026-06-25 · 권위 = 상품마스터 260610 + 라이브 실측. 식별자/코드/SQL 영문, 서술 한국어.
> 입력 재사용: `disposition-rev2.csv`(OPTIONIZE 67) · `codex-reconcile.md`(소재축 분리 제안) · `material-master-audit.md` · `CHANGELOG.md:18`(면지 directive).

---

## 0. W2의 본질 (재확인)

현재 자재 마스터(`t_mat_materials`)에 **색/사이즈/형상/투명도 변형**이 자재로 (오)등록돼 있다. 이를 자재가 아니라 **CPQ 옵션값**으로 표현해야 한다. 단 본 설계에서 결정적 라이브 발견은:

**핵심 발견 — "옵션화 미완"의 실체는 두 갈래다:**
1. **자재행은 OK·옵션 레이어만 없음** (면지·머그컵 투명도·실사색·잉크색) → 자재행을 그대로 `OPT_REF_DIM.03` ref로 두고 option_group만 신설하면 됨. **트리거 통과 즉시 가능.**
2. **자재행은 있으나 정작 옮길 차원행(siz/print_options)이 부재** (.09 봉제부자재 사이즈/형상/인쇄면 라벨 대부분) → 옵션값을 siz축/도수축으로 옮기려면 그 차원행을 **L1 선적재**해야 함. 차원행 부재 = **BLOCKED(needs L1 pre-load)**.

> rev2가 67건을 일괄 "OPTIONIZE"로 묶었으나, 라이브 실측 결과 **그 중 다수는 단순 옵션화가 아니라 L1 차원 선적재가 선행돼야 하는 BLOCKED**다. 자재 마스터에서 자재행을 빼서 siz/도수로 옮기려는데 정작 그 상품에 siz/도수 차원행이 0개다. 이걸 무시하고 option_item을 만들면 `fn_chk_opt_item_ref` 트리거가 INSERT를 거부한다.

---

## 1. 변형축 분류 (라이브 실측 기반)

각 항목을 어느 축으로 옵션화할지 결정. WowPress "과분할 금지" + codex 소재축 분리 제안 적용.

| 변형축 | 대상 차원/ref_dim | 항목 예 | 처분 | 차원행 실재 |
|---|---|---|---|---|
| **색축** | 자재 `OPT_REF_DIM.03`(현 자재행 유지) | 면지 화이트/그레이/블랙, 실사 화이트/블랙, 잉크 7색 | OPTIONIZE-색택1 | OK(자재행 존재) |
| **투명도축** | 자재 `OPT_REF_DIM.03` | 머그컵 투명/반투명 | OPTIONIZE-투명도택1 | OK |
| **소재·효과축** | **판정 보류** | 홀로그램·골드·실버·글리터류 | **CONFIRM** | 물성(width/height/weight) **전부 NULL** |
| **사이즈축** | 사이즈 `OPT_REF_DIM.01` | M/L/XL/S, 11/13/15인치, 미니50/일반100mm | BLOCKED-needs-L1 | **siz 차원행 0** |
| **형상축** | 사이즈 `OPT_REF_DIM.01`(siz_nm 융합) | 원형/사각/직사각/정사각/세로형/가로형 | BLOCKED-needs-L1 | **siz 차원행 0** |
| **규격축** | 사이즈 `OPT_REF_DIM.01` | A4용/A5용 | BLOCKED-needs-L1 | siz 0 |
| **인쇄면축** | 도수 `OPT_REF_DIM.06` | 단면/양면/전면만/배면만 | BLOCKED-needs-L1 | **print_options 차원행 0** |
| **구수축** | 공정 `OPT_REF_DIM.04` + ref_param_json | 1구~4구 | CONFIRM(ref_param_json GAP) | — |
| **묶음수축** | 묶음수 `OPT_REF_DIM.05` | 2개1팩 | CONFIRM | bdl 차원행 확인필요 |
| **복합축(색+사이즈 등)** | 분해 vs 1축 | 화이트M, 양면유광L, 정사각M | CONFIRM | 분해 결정 필요 |

### 1.1 소재·효과축 — codex 제안에 대한 정직한 판정

codex가 "홀로그램/골드/실버/글리터류는 단순 색 라벨이 아니라 특수 원단·필름일 수 있다"고 제안했다. 라이브 실측 결과:

```sql
SELECT mat_cd, mat_nm, mat_typ_cd, width, height, weight FROM t_mat_materials
WHERE mat_cd IN ('MAT_000257','MAT_000258','MAT_000259','MAT_000310','MAT_000312','MAT_000314','MAT_000315');
-- 결과: width/height/weight 전부 NULL (물성 미기록)
```

**판정: 라이브 데이터로는 소재 여부를 확증도 부정도 할 수 없다(평량/물성 미기록).** 따라서 일괄 "색 옵션값"으로 단정하지 않고(rev2 가드), 동시에 "특수 소재"로도 단정하지 않는다(codex 가설=확증 전 사실 아님). → **CONFIRM 분류(실무진 확인 큐).** 미러아크릴(골드/실버)은 미러필름 자체 색일 가능성, 글리터는 인쇄효과일 가능성 모두 열려 있음.

### 1.2 복합축(색+사이즈) — 분해 vs 1축

티셔츠(화이트M ~ 블랙XXL 8종), 파우치(정사각M/직사각M), 피켓(양면유광 M/L)처럼 한 자재명에 2~3축이 융합된 항목. WowPress 규칙은 "함께 고르는 물리속성은 1행"이나, 색×사이즈는 독립 선택축(색 따로·사이즈 따로 고름)이라 1행 융합이 부적절할 수 있음. 티셔츠는 **색(택1) × 사이즈(택1) 2그룹**이 자연스러움. → **CONFIRM(축 분해 정책 결정).** 단 분해하면 자재행은 8개 복합행이 아니라 색3+사이즈4로 정규화돼야 하므로 자재 마스터 정리가 동반 → W2 범위 초과(후속).

---

## 2. 파일럿 종단 설계 — 면지 3색 (T1)

### 2.0 Step 0 — 차원행 전제 (라이브 실측 통과)

면지 옵션은 **새 차원행을 만들지 않는다**. 기존 `t_prd_product_materials` 자재행을 `OPT_REF_DIM.03`으로 참조한다(L2는 L1을 재로드하지 않음).

트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.03) 요구: `t_prd_product_materials(prd_cd, mat_cd=ref_key1, usage_cd=ref_key2)` EXISTS.

라이브 사전검증 (PASS):
```sql
SELECT pm.prd_cd, pm.mat_cd, pm.usage_cd,
  EXISTS(SELECT 1 FROM t_prd_product_materials x
         WHERE x.prd_cd=pm.prd_cd AND x.mat_cd=pm.mat_cd AND x.usage_cd=pm.usage_cd) AS trig_ok
FROM t_prd_product_materials pm
WHERE pm.prd_cd='PRD_000072' AND pm.mat_cd IN ('MAT_000001','MAT_000002','MAT_000003') AND pm.usage_cd='USAGE.03';
-- 3행 전부 trig_ok=t
```

면지 4상품 배선 현황 (실측):

| prd_cd | prd_nm | 면지 자재(USAGE.03) | 옵션그룹 | 단가행 |
|---|---|---|---|---|
| PRD_000072 | 하드커버책자 | 화이트001·블랙002·그레이003 | NONE | 0 |
| PRD_000077 | 레더 하드커버책자 | 화이트001·블랙002·그레이003 | NONE | 0 |
| PRD_000082 | 하드커버 링책자 | 화이트001·블랙002·그레이003·**인쇄004** | NONE | 0 |
| PRD_000088 | 레더 링바인더 | 화이트001·블랙002·그레이003·**인쇄004** | NONE | 0 |

> 인쇄면지(MAT_000004)는 PRD_082·088에만 배선(권위: 하드커버링/레더링바인더 전용 실 stock 변형). PRD_072·077은 3색만. → 상품별 옵션값 구성이 다름. **인쇄면지는 자재로 유지**(실 stock)하면서 옵션값으로도 노출 = stock과 옵션의 이중 역할이 자연스럽게 양립(자재행 그대로, option_item으로 추가 참조).

### 2.1 option_groups — 택1 그룹

상품마다 면지색 그룹 1개. `sel_typ_cd=SEL_TYPE.01`(단일=택1), `min=1·max=1·mand_yn=Y`(면지는 필수 선택, 현 dflt_yn=Y가 전부라 1개만 적용되도록 택1).

| prd_cd | opt_grp_cd | opt_grp_nm | sel_typ_cd | min_sel | max_sel | mand_yn | disp_seq |
|---|---|---|---|---|---|---|---|
| PRD_000072 | `[CONFIRM:OPT_NNNNNN]` | 면지색 | SEL_TYPE.01 | 1 | 1 | Y | 종이그룹 다음(상품마스터 컬럼순서) |
| PRD_000077 | `[CONFIRM:OPT_NNNNNN]` | 면지색 | SEL_TYPE.01 | 1 | 1 | Y | 동일 |
| PRD_000082 | `[CONFIRM:OPT_NNNNNN]` | 면지색 | SEL_TYPE.01 | 1 | 1 | Y | 동일 |
| PRD_000088 | `[CONFIRM:OPT_NNNNNN]` | 면지색 | SEL_TYPE.01 | 1 | 1 | Y | 동일 |

> 채번: opt_grp_cd 최대 `OPT_000063`. 적재 시 MAX+1 surrogate(`OPT_000064`~). [CONFIRM]은 mint 금지 원칙에 따라 적재 단계(인간 승인)에서 채번. disp_seq는 상품마스터 면지 컬럼 표시순서(메모리 [dbmap-load-column-order-staged] 원칙=disp_seq는 옵션 표시순서) — 면지 4상품 상품마스터 추출 컬럼순서 확인 후 확정.

### 2.2 options — 색별 선택지

각 그룹 아래 색 옵션. `dflt_yn`: 화이트를 기본값(Y)로 1개만 — 현재 3색 전부 dflt_yn=Y인 자재 배선의 모호함을 옵션 레이어가 해소.

| prd_cd | opt_cd | opt_grp_cd | opt_nm | dflt_yn | disp_seq |
|---|---|---|---|---|---|
| PRD_000072 | `[CONFIRM:OPV_N]` | (위 그룹) | 화이트 | Y | 1 |
| PRD_000072 | `[CONFIRM:OPV_N]` | (위 그룹) | 그레이 | N | 2 |
| PRD_000072 | `[CONFIRM:OPV_N]` | (위 그룹) | 블랙 | N | 3 |
| PRD_000082 | `[CONFIRM:OPV_N]` | (위 그룹) | 화이트 | Y | 1 |
| PRD_000082 | `[CONFIRM:OPV_N]` | (위 그룹) | 그레이 | N | 2 |
| PRD_000082 | `[CONFIRM:OPV_N]` | (위 그룹) | 블랙 | N | 3 |
| PRD_000082 | `[CONFIRM:OPV_N]` | (위 그룹) | 인쇄 | N | 4 |

> PRD_077=072와 동형(3색), PRD_088=082와 동형(4색·인쇄 포함). opt_cd 채번: opt_cd(options PK 2번째)는 라이브 `OPV_*` 체계 최대 `OPV_000433` → MAX+1. (cpq-schema.md가 "options 0행"이라 한 것은 260606 stale — 현재 507행 적재됨.)

### 2.3 option_items — 자재행 polymorphic 참조

각 옵션 = 1개 option_item, `OPT_REF_DIM.03`(자재), ref_key1=mat_cd, **ref_key2=USAGE.03**(트리거 필수).

| prd_cd | opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |
|---|---|---|---|---|---|---|
| PRD_000072 | (화이트) | 1 | OPT_REF_DIM.03 | MAT_000001 | USAGE.03 | 1 |
| PRD_000072 | (그레이) | 1 | OPT_REF_DIM.03 | MAT_000003 | USAGE.03 | 1 |
| PRD_000072 | (블랙) | 1 | OPT_REF_DIM.03 | MAT_000002 | USAGE.03 | 1 |
| PRD_000082 | (인쇄) | 1 | OPT_REF_DIM.03 | MAT_000004 | USAGE.03 | 1 |

> ref_key2=USAGE.03 누락 시 트리거 거부(자재 ref는 usage_cd 필수). 이미 §2.0에서 EXISTS 검증 통과.

### 2.4 좀비 자재 처리 + 인쇄면지 stock 유지

- **면지 4종 모두 활성(del_yn=N)** — 직전 audit가 "좀비"로 표기했으나 라이브 실측은 활성. 즉 **del_yn 정리 불필요**. 자재행을 그대로 두고 option_item으로 참조만 추가하면 됨.
- 옵션화 후에도 **자재행은 삭제하지 않는다**: 화이트/그레이/블랙면지는 면지색 옵션값의 ref 대상이고, 인쇄면지는 실 stock + 옵션값. 자재 마스터에서 빼면 트리거 ref가 깨짐.
- **단, 자재 마스터 색 오염 재생산 가드**: 면지색은 자재 마스터에 "색3종 stock"으로 잔존하나, 옵션 레이어가 색 선택을 담당하므로 추가 색 변형이 자재로 늘어나지 않도록 함(거버넌스). 이것이 "자재 부활하면 오염 재생산" directive의 충족 방식 — 새 자재행을 만들지 않고 기존 행을 옵션 ref로 재사용.

### 2.5 constraints / templates

- **constraint 불필요**: 면지색은 다른 축과 교차 제약 없음(단순 택1). JSONLogic 룰 0.
- **template 불필요**: 면지는 add-on/SKU 아님(상품 본체 구성요소).

### 2.6 FK 위상 적재 순서 (면지 파일럿)

1. (선행 완료) dimension rows: `t_prd_product_materials` 면지 4종 — **이미 라이브**(추가 적재 0).
2. `t_prd_product_option_groups` (면지색 그룹 4상품).
3. `t_prd_product_options` (색 옵션 3~4개/상품).
4. `t_prd_product_option_items` (자재행 ref) — 트리거 발화 지점, §2.0에서 통과 입증.

> 면지 파일럿은 **차원 선적재 0 · 트리거 통과 입증 완료 · 단가행 0(돈영향 없음)** → 적재 준비 완료(승인 후 즉시 가능). 채번 [CONFIRM]만 적재 단계에서 확정.

---

## 3. 트랙 2 (굿즈 투명/반투명) 접근

### 3.1 머그컵 (PRD_000193) — 동형 적용 가능

머그컵 자재 배선(실측): 투명143 + 반투명146 (.01 투명도) + 화이트255 (.08 색) + 화이트머그268 (.12 본체 stock) — **4자재 전부 USAGE.07·dflt_yn=Y 혼재**. siz 차원행 0.

- **투명/반투명 → 투명도 택1 옵션** (면지 동형): `OPT_REF_DIM.03`, ref_key1=MAT_000143/146, ref_key2=USAGE.07. 트리거 통과 가능(자재행 존재).
- **화이트(255) → 색축**(트랙3과 동일 색 옵션). 단 머그컵에 색이 화이트 1종뿐이라 택1 불성립(대안 부재) → 색 옵션 미생성 or dflt 고정.
- **화이트머그(268) → 본체 stock 유지**(dflt, 옵션 아님).
- 트리거 사전검증 필요: ref_key2=USAGE.07로 EXISTS 확인(머그컵 배선 usage=USAGE.07이므로 통과 예상).

### 3.2 미니우치와키링 (PRD_000227) — CONFIRM

반투명146만 단독 배선(투명 대안 부재) → 택1 그룹 불성립. 단일 자재면 옵션화 의미 없음(고정 stock). → **CONFIRM**(실무진: 투명 옵션이 누락된 것인지, 반투명 단일이 정상인지).

### 3.3 트랙 2 스켈레톤

머그컵 투명도 그룹 = 면지 §2와 동일 구조(option_group 택1 → options 투명/반투명 2개 → option_items OPT_REF_DIM.03 ref_key2=USAGE.07). 돈영향 0(단가행 0). 머그컵 1상품 종단은 면지 파일럿 검증 후 동형 전파.

---

## 4. 트랙 3 (OPTIONIZE 67) 접근 — 그룹 분류

라이브 실측으로 67건을 **처분 가능성**별로 재분류(rev2의 일괄 OPTIONIZE를 정제):

| 그룹 | 변형축 | 항목수(자재기준) | 처분 | 동형 적용 |
|---|---|---|---|---|
| **3A 즉시 옵션화** | 색축·투명도축 | 잉크7색(297~303)·실사화이트/블랙(255/256) | OPTIONIZE-색택1 (면지 동형) | 면지 파일럿과 동일. 자재행 OK·트리거 통과 가능 |
| **3B BLOCKED(needs L1)** | 사이즈/형상/규격축 → siz | M/L/XL/S·인치·mm·A4/A5·원형/사각/세로/가로 등 | **BLOCKED** | siz 차원행 0 → siz 선적재 후 OPT_REF_DIM.01 |
| **3C BLOCKED(needs L1)** | 인쇄면축 → 도수 | 단면/양면/전면만/배면만 | **BLOCKED** | print_options 차원행 0 → 선적재 후 OPT_REF_DIM.06 |
| **3D CONFIRM 소재·효과** | 소재효과축? | 홀로그램/골드/실버/글리터류 | CONFIRM | 물성 NULL — 소재 여부 확인 후 색축 or 신규 소재 차원 |
| **3E CONFIRM 구수** | 구수축 → 공정+param | 1~4구 | CONFIRM | ref_param_json GAP(공정행 분리 vs param) |
| **3F CONFIRM 복합축** | 색+사이즈/인쇄면+마감+사이즈 | 화이트M·양면유광L·정사각M 등 | CONFIRM | 축 분해 정책 + 자재 정규화 동반(W2 초과) |
| **3G CONFIRM 단독배선** | 색/형상(택1 불성립) | 캔버스라벨파우치 블랙단독·마카롱 등 | CONFIRM | 대안 부재 = 옵션 불성립, 고정 stock or 옵션 누락 |

### 4.1 그룹별 설계 스켈레톤

- **3A (즉시)**: 면지 §2 패턴 그대로. 잉크색=만년스탬프(PRD_217) 7색 택1 그룹 1개. 자재행 ref_key2=USAGE.07. **돈영향 0**.
- **3B/3C (BLOCKED)**: option_item 생성 전 **L1 차원 선적재가 선행조건**. siz/print_options 차원행을 상품마스터 권위대로 적재(dbm-axis-staged-load 트랙) → 그 후 OPT_REF_DIM.01/.06 ref. **현 단계에서 option_item 생성 시 트리거 거부** → list-only, mint 금지.
- **3D**: 평량 실측 + 실무진 확인 → 색축(자재행 유지) or 신규 소재 차원. 결정 전 동결.
- **3E**: ref_param_json 미구현 GAP(cpq-schema.md §4 🔴8). 1~4구를 공정 4행 분리(마스터 오염) vs param 보존(컬럼 부재) — `dbm-ddl-proposer` 라우팅.
- **3F**: 복합 자재행을 색/사이즈 독립축으로 분해하려면 자재 마스터 정규화가 동반(8복합행 → 색3+사이즈4). W2 옵션화 범위 초과 → 후속 트랙.
- **3G**: 단독 배선은 택1 불성립. 옵션 아님(고정 stock) 처리 or 옵션 누락 여부 실무진 확인.

---

## 5. 돈영향 분석

- **W2 전 항목 단가행(t_prc_component_prices) = 0** (실측 확인, 면지 4종·투명/반투명 root+자식·OPTIONIZE 67 전건). → 옵션 선택이 가격을 바꾸지 않음(옵션가 미발생).
- 따라서 W2 옵션화는 **돈영향 0**. 옵션화는 "선택 UI 구성"만 담당하고, 가격은 별도 가격사슬(가격 발생 시 component_prices 적재는 별도 인간 승인).
- 단 3D 소재·효과축이 실제 특수소재로 판명되면 향후 단가 차등 발생 가능 → 그 시점 가격 트랙(현재는 0).

---

## 6. search-before-mint 근거

- **신규 차원행 mint 0**: 면지·머그컵 투명도·잉크색·실사색은 기존 자재행 재사용(OPT_REF_DIM.03). 새 mat_cd 만들지 않음.
- **3B/3C는 mint가 아니라 L1 적재**: siz/print_options 차원행은 상품마스터 권위 값이 이미 존재(자재명에 "M"·"양면"으로 박혀 있음)하나 차원 테이블에 미적재. 이를 옮기는 것 = 적재이지 창작이 아님. 단 현 W2에서는 list-only(BLOCKED), 실 L1 적재는 별도 트랙.
- opt_grp_cd/opt_cd 채번 = MAX+1 surrogate(라이브 최대 OPT_000063 / OPV_000433). [CONFIRM]으로 표기, 적재 단계(인간 승인)에서 확정.

---

## 7. CONFIRM 필요 항목 (실무진/리드 결정)

| # | 항목 | 결정 필요 | 돈영향 |
|---|---|---|---|
| C-1 | 면지 disp_seq | 상품마스터 면지 컬럼 표시순서(종이그룹 다음 위치 확정) | 0 |
| C-2 | 소재·효과축(홀로그램/골드/실버/글리터) | 색 라벨인가 특수소재인가(평량 NULL·codex 제안) → 색축 or 신규소재차원 | 0(현재) |
| C-3 | 구수(1~4구) | 공정행 분리 vs ref_param_json(미구현 GAP) — dbm-ddl-proposer | 0 |
| C-4 | 복합축(색+사이즈 등) | 1축 융합 vs 2축 분해(+자재 정규화 동반) | 0 |
| C-5 | 단독 배선 라벨(블랙단독·마카롱·반투명단독) | 옵션 불성립(고정 stock) or 옵션 누락 | 0 |
| C-6 | 묶음수(2개1팩) | bundle_qtys 차원행 실재 확인 후 OPT_REF_DIM.05 | 0 |
| C-7 | 3B/3C L1 선적재 우선순위 | siz/print_options 차원 적재 트랙(dbm-axis-staged-load) 착수 시점 | 0 |
