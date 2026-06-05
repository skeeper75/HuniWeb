# CPQ 설계 정본 — 상품/옵션 마스터 + 컨피규레이터 정의 (HuniPrinting)

> **상태/이력**
> - 작성 2026-06-06 · **WIP** · 사용자 합의 완료·리뷰 대기.
> - 본 문서는 그간 대화로만 존재하던 CPQ(Configure-Price-Quote) 데이터모델 설계를 정본화한 것이다.
> - 식별자/테이블/컬럼/코드/SQL/JSON = **English**, 설명 = **Korean**.
> - 검증 인스턴스화: `banner-walkthrough.md`(일반현수막 PRD_000138 종단 실증) 참조.

---

## 0. 시스템 경계 (고정 — HARD)

- **본 시스템 = 상품/옵션 마스터 + 컨피규레이터 정의(+ 검증 규칙)**.
- **주문/결제 = POD 사이트**. **생산 = MES**. POD↔MES 인터페이스 지속(주문/상태/인보이스).
- **설계 원칙 #1 (HARD):** 고객이 화면에서 최종 선택한 것은 **반드시 자재(material) + 공정(process)로 환원(resolve)** 가능해야 하며, 그 환원 결과가 주문 페이로드에 실려 MES로 넘어가 생산된다. **모든 선택 가능한 옵션은 자재/공정으로 해석 가능해야 한다.**
- **이번 라운드 범위 밖:** 주문 인스턴스 테이블, 가격 계산 엔진, 재고/BOM 소비 실행. (단 `consume_qty` 자리만 모델에 남겨둔다.)

---

## 1. 세 축 (요구사항)

### ① 추가상품(add-on) = 구성 템플릿
단순 상품 링크(`t_prd_product_addons.addon_prd_cd`)가 아니라, **"구성 템플릿(configuration template)"** — *상품 + 옵션(예: OPP봉투 + 사이즈 + 수량)* 을 freeze한 것 — 을 add-on으로 등록한다.
MES 핸드오프 시 **별도 주문 상세 라인**으로 분리 → 생산.
**통찰:** 이는 기존에 합의된 **SKU(판매가능 조합 = 주문/재고 단위)** 개념과 동일하다.

### ② 옵션 / 옵션그룹 (복합 옵션) — Model 1 (hybrid), CONFIRMED
- 유형별 차원 테이블(size, bundle-qty, color-count/도수, material, process)을 **AS-IS 유지**하고, 그 위에 일반 **옵션 / 옵션그룹** 레이어를 추가한다.
- **옵션(option)** = 이름 + 상품에 등록된 차원 행(material/process/size…)을 참조하는 묶음. 단일 또는 복합(예: `끈2줄+끈가공`).
- **옵션그룹(option-group)** = 옵션 집합 + 선택 규칙(pick-1 / pick-N / max-N) → **공정 택일그룹(process exclusive-select group)의 일반화**.
- 옵션 재료(ingredient)는 **그 상품에 이미 등록된 차원**에서만 참조 가능.

### ③ 교차 차원 제약 (cross-dimension constraints)
예: 사이즈 A ↔ 세트수 20만 / 자재 X ↔ 공정 Y 금지. UI에서 설정 → **JSON으로 저장**(기존 `t_prd_products.constraint_json` 컬럼 재사용 고려) → 선택 시점에 UI에서 검증.

---

## 2. 결정 로그 (Decision Log)

| # | 결정 | 사유 |
|---|------|------|
| D-1 | 시스템 경계 고정 (§0). 주문=POD, 생산=MES. | 본 시스템은 마스터/컨피규레이터 정의 책임만 |
| D-2 | ② 옵션 모델 = **Model 1 (hybrid)** — 기존 차원 테이블 유지 + 일반 옵션 레이어 추가, 택일그룹 흡수/일반화 | 기존 적재 자산(per-type 차원 행) 보존 + 표현력 확장 |
| D-3 | 옵션 재료 참조 = **polymorphic** (`ref_dim_cd` + key slots) | 처음엔 typed FK 검토했으나 참조 차원이 category 외 **모든 차원(7+종)** 으로 넓어짐 → typed FK 비현실적 → polymorphic + **검증 트리거** |
| D-4 | ① add-on = 재사용 가능 구성 템플릿 카탈로그 (= SKU) | 봉투/거치대 같은 "구성 freeze된 판매단위"를 재사용·분리 라인화 |
| D-5 | ③ constraint = **JSONLogic** rule 행들 → 단일 JSON으로 compile | POD(JS)·백엔드(Python) 동일 평가, side-effect 없음, 안전 |

---

## 3. 스키마 설계 (신규/변경 테이블)

> 물리 테이블명은 잠정. 최종 물리명은 Dictionary(명명규칙) 확인 필요. PK/주요 컬럼은 확정.

### 3.1 ② 옵션 레이어 — 상품별 신규 3테이블 (공정 택일그룹의 일반화)

#### `t_prd_product_option_groups` — 옵션 그룹
- **PK** `(prd_cd, opt_grp_cd)`
- 컬럼: `opt_grp_nm`, `sel_typ_cd`(base-code SEL_TYPE: 단일.01/다중.02), `min_sel_cnt`, `max_sel_cnt`, `mand_yn`, `disp_seq`, `use_yn`
- `t_prd_product_process_excl_groups`의 일반화. `sel_typ_cd`로 pick-1(택일) / pick-N(다중) 표현, `min/max_sel_cnt`로 max-N 표현.

#### `t_prd_product_options` — 옵션
- **PK** `(prd_cd, opt_cd)`
- 컬럼: `opt_grp_cd`(그룹 FK), `opt_nm`, `dflt_yn`, `disp_seq`, `use_yn`
- 옵션 1개 = 사용자가 그룹 안에서 고르는 1개 선택지. 복합이면 아래 items 2행+로 표현.

#### `t_prd_product_option_items` — 옵션 재료 (복합 내부 구성요소)
- **PK** `(prd_cd, opt_cd, item_seq)`
- **polymorphic 참조** (참조 차원이 7+로 넓어 typed FK 불가):
  - `ref_dim_cd` — 차원 유형 (base-code group, 잠정 `OPT_REF_DIM`): size / 도수(color-count) / 판형(plate) / material / process / bundle-qty / set / addon(템플릿)
  - `ref_key1`, `ref_key2` (varchar) — 그 차원 행의 자연 서브키
  - `ref_param_json` (jsonb, **신규 제안**) — 공정 파라미터 값 (예: 타공 `{"구수":6}`, 봉제 `{"유형":"봉미싱"}`). 공정 `prcs_dtl_opt` 스키마와 짝.
  - `qty` (수량/소비수량, optional — BOM 훅. consume_qty 자리)
- **ref_dim_cd별 키 매핑 규약:**

  | ref_dim_cd | ref_key1 | ref_key2 | ref_param_json | 대상 차원 테이블 |
  |---|---|---|---|---|
  | `size` | siz_cd | — | — | `t_prd_product_sizes` |
  | `material` | mat_cd | usage_cd | — | `t_prd_product_materials` |
  | `process` | proc_cd | — | 공정 detail opt 값 | `t_prd_product_processes` |
  | `bundle-qty` | bdl_qty | — | — | `t_prd_product_bundle_qtys` |
  | `color-count` | opt_id | — | print_side/front_clr/back_clr | `t_prd_product_print_options` |
  | `plate` | siz_cd | — | — | `t_prd_product_plate_sizes` |
  | `set` | sub_prd_cd | — | — | `t_prd_product_sets` |
  | `addon` | tmpl_cd | — | — | `t_prd_templates` (추가상품 템플릿) |

- **"그 상품에 등록된 차원 행만"** = **검증 트리거**(ref_dim_cd별로 해당 상품 차원 테이블에 그 행이 존재하는지 검사) + 관리자/앱 검증. (polymorphic이라 DB FK 불가 → 트리거. 본 프로젝트는 이미 트리거를 쓴다.)
- **주의:** size와 plate가 모두 siz_cd를 쓴다 → `ref_dim_cd`로 구분 → polymorphic이 충돌을 자연 흡수.
- **주의(color-count 키슬롯 — postcard 검증 MISMATCH-1 정정):** `color-count`의 ref_key1은 색상수 코드(clr_cd)가 아니라 print_option 행 식별자 `opt_id`(1=단면/2=양면)다. 단/양면 도수는 opt_id로 식별하며, clr_cd(front/back colrcnt)는 그 행의 속성이라 `ref_param_json`에 담는다. (초안의 `color-count→clr_cd` 매핑은 단/양면을 식별 못 하는 버그였음.)

**택일그룹 처리:** 기존 `t_prd_product_process_excl_groups`(process 전용)는 본 일반 옵션그룹으로 **흡수/마이그레이션**(공정 옵션그룹으로 변환).

**MES 환원:** 옵션 선택 → option_items의 material/process 행 → 주문 페이로드.

### 3.2 ① 추가상품 템플릿 — 재사용 카탈로그 (= SKU 통합)

#### `t_prd_templates` (신규)
- **PK** `tmpl_cd`
- 컬럼: `base_prd_cd`(FK→product), `tmpl_nm`, `dflt_qty`, `price`(잠정 — addon 추가가격), `use_yn`, `note`
- = SKU 후보.

#### `t_prd_template_selections` (신규)
- **PK** `(tmpl_cd, seq)`
- base 상품의 **옵션(opt_cd)** 또는 차원(siz_cd, bdl_qty…) 선택 + 값/수량.

#### `t_prd_product_addons` 변경
- `addon_prd_cd` → **`tmpl_cd` 참조** (부모 상품 → 구성 템플릿).
- PK `(prd_cd, tmpl_cd)`.
- MES: 템플릿 → 별도 주문 상세 라인 → 생산.

### 3.3 ③ 제약 모델 — JSONLogic + rule 행 → compile JSON

#### `t_prd_product_constraints` (신규)
- **PK** `(prd_cd, rule_cd)`
- 컬럼: `rule_nm`, `rule_typ`(compatible / forbidden / required), `logic`(**jsonb, JSONLogic**), `err_msg`, `use_yn`, `disp_seq`
- 일반화 대상: size×set-count 2축에 한정되지 않음 → 임의 옵션/차원 조합 + boolean logic(AND/OR/NOT, implies)으로 호환/금지/필수 표현.
- **표현 언어 = JSONLogic** — 순수 JSON 규칙, POD(JS: `json-logic-js`)·백엔드(Python: `json-logic-py`) 동일 평가, 안전(side-effect 없음).
- **친화적 작성 UI:** 호환성 매트릭스 / 금지쌍 / 필수동반 에디터가 내부적으로 JSONLogic 생성.
- **저장:** rule 행 = `{rule_nm, rule_typ, logic(JSONLogic), err_msg, use_yn, disp_seq}` → 관리자 행 단위 CRUD/on-off + **활성 규칙들을 단일 JSON으로 compile** → POD용 캐시(`t_prd_products.constraint_json`).
- **한계:** JSONLogic은 *검증* 용(이 조합이 OK인가?). "선택 시 후보 자동 좁힘"은 규칙으로 후보를 brute-force 필터(인쇄 옵션 공간이 충분히 작다). 전면 CSP 제외.

### 3.4 신규/변경 테이블 요약

| 테이블 | 역할 | 키 | 비고 |
|---|---|---|---|
| `t_prd_product_option_groups` | 옵션 그룹 | (prd_cd, opt_grp_cd) | 신규. 택일그룹 일반화 |
| `t_prd_product_options` | 옵션 | (prd_cd, opt_cd) | 신규 |
| `t_prd_product_option_items` | 옵션 재료 | (prd_cd, opt_cd, item_seq) | 신규. polymorphic(ref_dim_cd+key slots)→차원 행, 검증 트리거 |
| `t_prd_templates` | 구성 템플릿(=SKU) | tmpl_cd | 신규. base_prd_cd |
| `t_prd_template_selections` | 템플릿 선택 | (tmpl_cd, seq) | 신규. 옵션/차원 참조 |
| `t_prd_product_constraints` | 제약 규칙 | (prd_cd, rule_cd) | 신규. logic jsonb (JSONLogic) |
| `t_prd_product_addons` | add-on | (prd_cd, tmpl_cd) | **변경**: addon_prd_cd→tmpl_cd |
| `t_prd_product_process_excl_groups` | 공정 택일그룹 | - | **흡수/마이그레이션** → option_groups |
| `t_prd_products.constraint_json` | compile된 제약 JSON 캐시 | - | 기존 컬럼 재사용 |

---

## 4. polymorphic 검증 트리거 (설계 명세)

DB FK가 불가능한 `t_prd_product_option_items`의 무결성을 트리거로 보장한다.

```
TRIGGER trg_option_item_dim_check  BEFORE INSERT/UPDATE ON t_prd_product_option_items
  CASE NEW.ref_dim_cd
    WHEN 'size'        → EXISTS(t_prd_product_sizes        WHERE prd_cd=NEW.prd_cd AND siz_cd=NEW.ref_key1)
    WHEN 'material'    → EXISTS(t_prd_product_materials     WHERE prd_cd=NEW.prd_cd AND mat_cd=NEW.ref_key1 AND usage_cd=NEW.ref_key2)
    WHEN 'process'     → EXISTS(t_prd_product_processes     WHERE prd_cd=NEW.prd_cd AND proc_cd=NEW.ref_key1)
    WHEN 'bundle-qty'  → EXISTS(t_prd_product_bundle_qtys   WHERE prd_cd=NEW.prd_cd AND bdl_qty=NEW.ref_key1::int)
    WHEN 'color-count' → EXISTS(t_prd_product_print_options WHERE prd_cd=NEW.prd_cd ...)
    WHEN 'plate'       → EXISTS(t_prd_product_plate_sizes   WHERE prd_cd=NEW.prd_cd AND siz_cd=NEW.ref_key1)
    WHEN 'set'         → EXISTS(t_prd_product_sets          WHERE prd_cd=NEW.prd_cd AND sub_prd_cd=NEW.ref_key1)
    ELSE RAISE 'unknown ref_dim_cd'
  → 없으면 RAISE EXCEPTION '옵션 재료가 상품에 등록되지 않은 차원 행을 참조함'
```

추가로 `ref_param_json`이 있으면 해당 `proc_cd`의 `t_proc_processes.prcs_dtl_opt` 스키마에 맞는지 앱 레벨 검증(트리거에서 JSON 스키마 검사까지는 과함 — 앱/관리자 검증으로 분담).

---

## 5. 신규 base-code 그룹 제안

| 그룹 | 자식 | 사용처 |
|---|---|---|
| `OPT_REF_DIM` (신규) | size / material / process / bundle-qty / color-count / plate / set / addon | `t_prd_product_option_items.ref_dim_cd` |
| (기존) `SEL_TYPE` 재사용 | .01 단일(pick-1/택일) · .02 다중(pick-N) | `t_prd_product_option_groups.sel_typ_cd` |

> `SEL_TYPE`은 기존 2종(단일/다중)으로 pick-1/pick-N을 표현. max-N은 `min_sel_cnt`/`max_sel_cnt` 컬럼으로 보강(SEL_TYPE.02 + max_sel_cnt=N).

---

## 6. 미해결/컨펌 대상

- `OPT_REF_DIM` base-code 그룹 신설 vs 기존 그룹 재사용 — Dictionary 확인.
- `t_prd_product_option_items.ref_param_json` 신규 컬럼 추가 가부 (공정 파라미터 보존 필수 — 본 설계는 추가를 권고).
- 끈/큐방/각목의 addon-vs-process 축 결정 (G-SL-4) — `banner-walkthrough.md` §5(a) 권고 규약 참조.
- 물리 테이블/컬럼명 최종 확정(명명규칙).

### 실증 공백 (banner-walkthrough 독립 검증 발견 — `banner-walkthrough-validation.md`)

배너 1종 인스턴스화는 사실정확성 검증 통과(MISMATCH 0·INVENTED 0)했으나, 다음 설계 일반화는 배너가 **행사하지 못해 미실증**으로 남는다(별도 상품 인스턴스 필요):
- **pick-N/max-N(SEL_TYPE.02 + max_sel_cnt)** — 배너는 전 그룹 택일(SEL_TYPE.01)뿐 → 다중선택 일반화 미실증. SEL_TYPE.02 케이스 보조 실증 필요.
- **`t_prd_product_process_excl_groups` 마이그레이션** — 배너는 excl_grp 0행 → "기존 택일그룹 변환"이 아니라 "공백에서 신규 표현". excl_grp_cd 실재 상품(제본류 등)으로 변환 실증 필요.
- **차원 EXISTS 트리거 vs 미적재 옵션** — 열재단(→PROC_000053)은 PRD_000138에 미적재 차원 → 옵션 등록 시 폴리모픽 검증 트리거(§4)에 걸림. "이미 등록된 차원만 참조" 규약과 충돌 → 차원 선적재 또는 센티넬 처리 규약 필요. (프리미엄엽서에서 종이 material 0행 + 후가공 PROC_000029~032 0행으로 **더 광범위하게 재확인** — postcard 검증 GAP-5.)
- **진짜 max-N(전체 옵션수 > max_sel_cnt) 미실증** — 프리미엄엽서 후가공이 SEL_TYPE.02 다중선택은 실증했으나 max_sel_cnt=4=전체4라 상한이 무의미(항상 만족). max_sel_cnt<옵션수인 진짜 상한(예: 박색상 16종 중 N종 제한)은 미실증 (postcard 검증 GAP-A). pick-N의 '다중'은 닫혔고 '상한 N'은 부분.
- **template 고정 freeze vs 동적 선택** — `t_prd_template_selections`는 siz_cd를 1개로 고정 freeze. 그러나 L1 ★사이즈선택(엽서 본체 사이즈에 연동되는 가변 봉투 사이즈)은 미지원 (postcard 검증 GAP-B). AS-IS note 문자열("110x160 50장")→siz_cd 마이그레이션 결정규칙도 미정 (GAP-C).
- **template 깊이 한계** — 옵션 풍부한 상품을 add-on으로 freeze하면 selections가 base 옵션트리를 복제 → 폭발. 봉투는 단순 기성품(PRD_TYPE.03)이라 우연히 회피 (postcard 검증 GAP-D). "base 옵션 상속" 메커니즘 별도 설계 필요.
</content>
</invoke>
