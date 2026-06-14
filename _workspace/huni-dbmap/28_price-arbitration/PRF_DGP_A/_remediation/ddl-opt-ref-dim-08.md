# DDL 제안 — OPT_REF_DIM.08 가격구성요소(PRICE_COMP) 신설

> 작성 2026-06-14 · round-18+ PRF_DGP_A 정립 ⓐ단계 · dbm-ddl-proposer
> 목적: C-2 가설 A(option_items 확장) 확정에 따라, 옵션값→가격구성요소(comp_cd) 멤버십 매핑을
> 표현할 신규 참조차원유형 `.08` 을 OPT_REF_DIM 코드그룹에 추가하는 경량 제안.
> 입력 권위: [[mapping-integrity]] §2 D-2 · [[remediation-plan]] §2 가설A·§3 트랙·§4 재검증.
> 라이브 실측 권위(읽기전용 SELECT). **DB 직접 적용 금지 — 제안까지, 실 적용은 인간 승인.**

---

## 0. 결론 요약 (먼저)

- **신규 코드 문자열 = `OPT_REF_DIM.08`** (cod_nm = `가격구성요소`, upr_cod_cd = `OPT_REF_DIM`, disp_seq = `8`, use_yn = `Y`). 기존 7행과 **완전 동형**.
- **트리거 보강 필수 (CRITICAL)**: `fn_chk_opt_item_ref()` 는 `CASE NEW.ref_dim_cd` 7종 분기 후 `ELSE RAISE EXCEPTION '미지원 ref_dim_cd'` 를 둔다. base_code 1행만 추가하고 트리거를 그대로 두면, option_items 에 `.08` 행을 INSERT 하는 즉시 트리거가 예외를 던져 **적재 자체가 불가**하다. → `.08` WHEN 분기(comp_cd 존재 검증)를 추가한 함수 `CREATE OR REPLACE` 가 제안에 포함됨.
- **영향 요약**: 기존 base_code 7행·comp 단가행(component_prices 3,481행)·기존 option_items(`.01/.03/.04/.06/.07` 455행) **전부 불변**. `.08`은 신규 enum 값일 뿐 누구도 아직 참조하지 않음(라이브 `.08` 행 0). 백필 불요. 적용은 base_code → 함수 순. 롤백은 함수 원복 + base_code DELETE.

---

## 1. 라이브 실측 — OPT_REF_DIM 현황 (7종)

`t_cod_base_codes` 구조(라이브 `\d`): PK=`cod_cd varchar(50)`, `cod_nm varchar(100) NOT NULL`,
`upr_cod_cd varchar(50)`(자기참조 FK), `disp_seq int`, `use_yn char(1) NOT NULL CHECK(Y|N)`,
`note varchar(500)`, `reg_dt NOT NULL DEFAULT now()`, `upd_dt`. upd_dt 트리거 `fn_upd_dt` 존재.

부모 코드 1행 + 자식 7종(라이브 `SELECT` 실측, 2026-06-14):

| cod_cd | cod_nm | upr_cod_cd | disp_seq | use_yn | note |
|---|---|---|---|---|---|
| `OPT_REF_DIM` | 옵션참조차원유형 | (NULL) | 12 | Y | (부모 그룹) |
| `OPT_REF_DIM.01` | 사이즈 | OPT_REF_DIM | 1 | Y | → t_prd_product_sizes(siz_cd) |
| `OPT_REF_DIM.02` | 판형 | OPT_REF_DIM | 2 | Y | → t_prd_product_plate_sizes(siz_cd) |
| `OPT_REF_DIM.03` | 자재 | OPT_REF_DIM | 3 | Y | → t_prd_product_materials(mat_cd, usage_cd) |
| `OPT_REF_DIM.04` | 공정 | OPT_REF_DIM | 4 | Y | → t_prd_product_processes(proc_cd) |
| `OPT_REF_DIM.05` | 묶음수 | OPT_REF_DIM | 5 | Y | → t_prd_product_bundle_qtys(bdl_qty) |
| `OPT_REF_DIM.06` | 도수 | OPT_REF_DIM | 6 | Y | → t_prd_product_print_options(opt_id) |
| `OPT_REF_DIM.07` | 셋트 | OPT_REF_DIM | 7 | Y | → t_prd_product_sets(sub_prd_cd) |

**코드 형식 확정**: `OPT_REF_DIM.NN`(zero-pad 2자리). 라벨(cod_nm)=짧은 한국어 명사. note는 7종 모두 라이브에서 빈칸(매핑 대상은 트리거 주석에만 존재) — 동형 유지 위해 `.08`도 note는 두되, 대상(t_prc_price_components.comp_cd)을 간결히 기재(실무진 가독성).

라이브 사용 분포(실측): option_items 의 ref_dim_cd = `.01`(11)·`.03`(254)·`.04`(143)·`.06`(45)·`.07`(2);
template_selections = `.01`(9)·`.05`(2). `.08` 사용 = **0행**(신규).

---

## 2. search-before-mint — 기존 7종으로 표현 불가 입증

D-2의 본질은 **멤버십(membership)** — 옵션값 선택이 *어느 comp_cd 를 합산집합에 포함*하나(가격 차원이 아님). 기존 7종 검토:

- `.01 사이즈`/`.02 판형`/`.05 묶음수`/`.07 셋트` — 물량/규격 축. comp_cd 와 무관.
- `.03 자재` — 종이(MAT_xxx)는 이미 COMP_PAPER 의 mat 차원과 자동 연결([[mapping-integrity]] §2-3). 그러나 인쇄(S1/S2)·코팅(유광/무광)·모서리·후가공 comp는 자재가 아님.
- `.04 공정` — 모서리·후가공 option_items 가 PROC_000027~032 를 가리키나, **공정코드 ≠ comp코드**. 트리거 `.04`는 `t_prd_product_processes(proc_cd)` 존재만 검증할 뿐 가격 comp(COMP_PP_CORNER_*/CREASE_*) 와의 다리가 없다([[mapping-integrity]] §2-3 ⓒ).
- `.06 도수` — 인쇄 면수 1/2 를 가리키나 COMP_PRINT_DIGITAL_S1/S2 택1과 무관.

대안 슬롯도 부재:
- `component_prices.opt_cd`(미사용·3,481행 NULL) 활용 = 가설 B → opt_cd 는 **상품 스코프**라 공유 comp 폭증 + 멤버십을 단가차원으로 오인코딩(prcx01 차원독립성 충돌). 기각([[remediation-plan]] §2-B).
- comp↔공정 매핑 테이블 신설 = 가설 C → 신규 테이블·부분해·간접. 기각([[remediation-plan]] §2-C).

**결론**: 7종 어느 것도 "옵션값 → comp_cd 멤버십"을 무손실로 담지 못한다. 그릇은 `ref_key1`(varchar50 NOT NULL)으로 이미 존재하나, 이를 comp_cd 로 해석할 **참조차원유형 값(.08)** 이 없다 = D-2 근본원인. → `.08` 신설이 최소·정합 해법(가설 A).

---

## 3. 제안 DDL

### 3-1. base_code 1행 추가 (사다리 최하단 — 코드행)

```sql
-- forward: OPT_REF_DIM.08 가격구성요소(PRICE_COMP) — 옵션값→comp_cd 멤버십 참조차원유형
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note, reg_dt)
VALUES (
  'OPT_REF_DIM.08',
  '가격구성요소',
  'OPT_REF_DIM',
  8,
  'Y',
  'option_items.ref_key1 = t_prc_price_components(comp_cd). 옵션값 선택 시 합산할 가격구성요소 멤버십.',
  now()
)
ON CONFLICT (cod_cd) DO NOTHING;  -- 멱등
```

기존 7행과 동형: 형식 `OPT_REF_DIM.NN`, 짧은 한국어 라벨, 부모 동일, disp_seq=다음 번호 8, use_yn=Y. reg_dt 는 DEFAULT now() 발화를 위해 명시(메모리 교훈 — 명시 NULL은 DEFAULT 미발화).

### 3-2. 가드 트리거 함수 보강 (CRITICAL — 없으면 option_items `.08` 적재 불가)

라이브 `fn_chk_opt_item_ref()` 는 7종 WHEN + `ELSE RAISE EXCEPTION '미지원 ref_dim_cd'`. `.08` WHEN 분기를 추가하되 **`.01~.07` 분기는 라이브와 한 글자도 다르지 않게 보존**(아래는 신규 `.08` 분기만 발췌; 실제 적용은 라이브 전체 함수 본문에 `.08` WHEN 한 블록 삽입한 `CREATE OR REPLACE`).

```sql
-- forward: fn_chk_opt_item_ref 에 .08 분기 추가 (기존 .01~.07 본문 불변, ELSE 그대로)
--   ... (라이브 .01~.07 WHEN 블록 그대로 유지) ...
    WHEN 'OPT_REF_DIM.08' THEN  -- 가격구성요소 → t_prc_price_components(comp_cd)
      IF NOT EXISTS (SELECT 1 FROM t_prc_price_components
                     WHERE comp_cd = NEW.ref_key1) THEN
        RAISE EXCEPTION 'opt_item ref 무결성 위반: 가격구성요소 ref_key1=% 가 t_prc_price_components 에 없음 (ref_dim_cd=%)',
          NEW.ref_key1, NEW.ref_dim_cd;
      END IF;
--   ... (ELSE RAISE EXCEPTION '미지원 ref_dim_cd' 그대로) ...
```

**검증 의미론(다른 7종과의 차이, 정합 근거)**:
- `.01~.07` 은 대상 행이 **prd_cd 스코프**(`WHERE prd_cd = NEW.prd_cd AND ...`)였다. comp_cd 는 `t_prc_price_components` 의 **글로벌 PK**(prd_cd 컬럼 없음·라이브 144행 공유) → `.08` 검증은 `prd_cd` 조건 없이 `comp_cd = NEW.ref_key1` 존재만 확인. 이는 공유 comp 보존(단가행 불변)의 직접 귀결이며 의도적.
- `ref_key2`(usage_cd 용) 는 `.08`에서 미사용(NULL 허용). qty 컬럼도 멤버십에는 불요(수량변형 `_nL/_nEA` 는 comp_cd 자체에 인코딩됨 — [[remediation-plan]] §1).

> `CREATE OR REPLACE FUNCTION` 이므로 트리거(`trg_..._chk_ref`)는 재생성 불요(함수 본문만 교체). template_selections 는 이 트리거를 쓰지 않으므로(라이브 실측: upd_dt 트리거만) 영향 없음.

---

## 4. 영향분석

| 항목 | 영향 | 근거 |
|---|---|---|
| 기존 base_code 7행 | **불변** | INSERT 신규 1행만. 기존 행 UPDATE 없음. |
| comp 단가행(component_prices 3,481·components 144) | **불변** | `.08`은 base_code enum 추가일 뿐. 단가/배선 무수정. |
| 기존 option_items 455행(.01/.03/.04/.06/.07) | **불변** | 함수 `.01~.07` 분기 바이트 동일 유지. INSERT/UPDATE 시 동일 경로. |
| template_selections | **무영향** | 가드 트리거 미부착(라이브 실측). `.05` 등 그대로. |
| FK | **충족** | option_items.ref_dim_cd FK→t_cod_base_codes 는 `.08` 행 선적재로 만족. comp_cd 참조는 FK 불가(폴리모픽)라 트리거가 대행 — 신규 `.08` 분기가 그 무결성을 담보. |
| 백필 | **불요** | NOT NULL 신규 컬럼 추가 아님·기존행 NULL 발생 없음. |
| 적용순서 | ① base_code `.08` INSERT → ② `fn_chk_opt_item_ref` CREATE OR REPLACE → (이후 ⓑ단계) option_items `.08` 멤버십 행 적재 | 함수가 `.08` 검증 시 base_code FK 와 comp 존재를 전제. 둘 다 선행돼야 ⓑ가 통과. |
| 멱등성 | base_code = ON CONFLICT DO NOTHING. 함수 = CREATE OR REPLACE(반복 안전). | |

**롤백** (ⓑ에서 `.08` option_items 미적재 상태 기준):
```sql
-- 1) 함수 원복: 라이브 백업한 .08 미포함 본문으로 CREATE OR REPLACE (또는 .08 WHEN 블록 제거)
-- 2) 코드행 제거 (참조 없을 때만)
DELETE FROM t_cod_base_codes WHERE cod_cd='OPT_REF_DIM.08'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_items WHERE ref_dim_cd='OPT_REF_DIM.08');
```
`.08` option_items 가 이미 적재된 후라면 그 행을 먼저 논리삭제/제거해야 base_code DELETE 가 FK(RESTRICT)에 막히지 않음 — 안전장치로 작동.

---

## 5. ⓑ단계 핸드오프 (이 제안 적용 후)

- option-mapper(round-6 `dbm-cpq-option-mapping`)가 [[remediation-plan]] §1 표를 option_items `{ref_dim_cd=OPT_REF_DIM.08, ref_key1=comp_cd}` 행으로 적재. 인쇄 단/양면→S1/S2, 코팅 유광/무광→GLOSSY/MATTE, 모서리 직각/둥근→CORNER_RIGHT/ROUND, 후가공 택N→CREASE/PERF/VARIMG/VARTEXT. 종이는 이미 `.03` 연결됨(추가 불요).
- 재검증([[remediation-plan]] §4): 보정 하드코딩 없이 option_items `.08` 매핑만으로 활성 comp 집합 재현 → G-DATA A-1 재실행.

---

## 6. 컨펌 (인간 승인 필요)

- [ ] `.08` 코드 문자열 `OPT_REF_DIM.08` / 라벨 `가격구성요소` 비준.
- [ ] 트리거 함수 `fn_chk_opt_item_ref` CREATE OR REPLACE 적용 승인(라이브 현행 전체 본문 + `.08` 분기). **적용 전 현행 함수 정의를 백업(pg_get_functiondef)** — 롤백 원본.
- [ ] base_code INSERT + 함수 교체 실 COMMIT 은 인간/개발이 실행(본 제안서는 미적용).
