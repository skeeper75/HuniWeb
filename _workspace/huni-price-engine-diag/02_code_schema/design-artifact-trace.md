# design-artifact-trace — 설계 산출물 반영도 추적 (Phase 1)

**진단가:** hped-code-schema-auditor · **일자:** 2026-06-18
설계 산출물(prcx01·pricing-erd·sql DDL Phase7~10)이 코드(pricing.py)·라이브 DB에 반영된 정도. {반영됨/부분/미반영/stale}.

> 핵심 분리[HARD]: "DDL에 선언됨 ≠ 코드가 씀 ≠ 라이브에 적용됨". stale = 설계는 옛 모델, 코드/DB는 진화한 경우.

---

## A. prcx01-pricing-model.md (LOCKED 2026-05-27) — 합산형 다차원 단가 모델

| 설계 결정 | 코드 반영 | 라이브 반영 | 판정 |
|-----------|-----------|-------------|:----:|
| 다차원 단가 테이블 + 차원 NULL=무관 | pricing.py:82-90 `_row_matches` NULL=와일드카드 | ✅ NULL 허용 | **반영됨** |
| surrogate PK comp_price_id | models.py:178·pricing.py:437 | ✅ bigint PK | **반영됨** |
| 시계열 apply_ymd varchar(10) | pricing.py:128,170 `<=as_of` | ✅ NOT NULL | **반영됨** |
| **8차원 키**(comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,coat_side_cnt,bdl_qty,min_qty) | 코드는 **14차원**(NON_QTY_DIMS 8 + TIER 3 + dim_vals) | 라이브 자연키 14컬럼(models.py:201) | **stale** — prcx01은 8차원 시절, 이후 proc_cd·opt_cd·print_opt_cd·plt_siz_cd·siz_width/height·dim_vals 6차원 추가됨 |
| **clr_cd 핵심 차원**(§6 인쇄비) | 코드 NON_QTY_DIMS에 clr_cd 없음 | 라이브 clr_cd 0행 | **stale** — clr_cd→print_opt_cd 이관(sql/28). prcx01 §6.clr_cd 설명 무효 |
| 인쇄비=사이즈+도수(§1 표) | 코드: 사이즈+인쇄옵션(print_opt) | print_opt_cd 1431행 | **stale**(도수→인쇄옵션) |

**종합:** prcx01은 모델 골격(다차원·NULL·surrogate·시계열)은 충실히 반영됐으나 **차원 목록이 8→14로 진화해 차원 부분이 stale**. 도수(clr_cd) 차원 폐기·인쇄옵션 도입을 반영 못 함.

---

## B. pricing-erd.md (구조 설명용 6테이블) — 가격 도메인 ERD

| 설계 요소 | 코드 반영 | 라이브 | 판정 |
|-----------|-----------|--------|:----:|
| 6테이블 구조(formulas·components·formula_components·component_prices·product_price_formulas·product_prices) | pricing.py 전부 참조 | ✅ 실재 | **반영됨** |
| 상품→공식→구성요소→단가 흐름 | pricing.py:320-475 | ✅ FORMULA 경로 | **반영됨** |
| **frm_typ_cd FK**(formulas, FRM_TYPE 합산형/단순형) :24,:17 | **코드 미참조**(pricing.py:8 폐기 명시) | **라이브 컬럼 부재**(sql/25 drop) | **stale** — ERD는 frm_typ 존재 시절. 코드·DB 모두 제거(깨끗) |
| **addtn_yn**(formula_components, Y=합산) :39 | **코드 미참조** | 라이브 컬럼 존재(미사용) | **부분/미반영** — 코드가 합산/차감 분기 안 함(공식=항상 합산) |
| component_prices 8차원(siz/clr/mat/coat/bdl/min_qty) :42-51 | 코드 14차원 | 라이브 14차원 | **stale**(A와 동일·8→14) |
| prc_typ_cd(단가/합가) | **ERD 미기재** | 라이브·코드 존재(prc_typ_cd) | **설계 누락** — ERD는 단가/합가 환산 개념 자체가 없음(이후 도입) |
| use_dims | **ERD 미기재** | 라이브·코드 존재 | **설계 누락** |
| dim_vals | **ERD 미기재** | 라이브·코드 존재(310행) | **설계 누락** |
| 할인 t_dsc_*(순차 곱) | **ERD 범위 외** | pricing.py:478-537 구현 | **설계 누락** — ERD는 할인 도메인 미포함 |

**종합:** pricing-erd는 6테이블 관계·흐름은 정확하나 **Phase 11 가격엔진 도입분(prc_typ_cd·use_dims·dim_vals·할인 순차곱·단가/합가 환산·6차원 추가)을 전혀 담지 못한 stale 문서**. frm_typ_cd는 깨끗이 제거(코드·DB 정합), addtn_yn은 잔존하나 코드가 무시.

---

## C. sql DDL Phase7~10 (10~34번대) — 진화 이력

| DDL 파일 | 결정 | 코드 반영 | 라이브 적용 | 판정 |
|----------|------|-----------|-------------|:----:|
| 21_pricing_dims | proc_cd·opt_cd 차원 + prc_typ_cd + PRICE_TYPE 코드 | NON_QTY_DIMS·:185 분기 | ✅ proc 1901·opt 5행·prc_typ 채움 | **반영됨** |
| 22_use_dims | use_dims jsonb | pricing.py:404,459 | ✅ 채움 | **반영됨** |
| 23_drop_columns | constraint_json·dep_proc_cd 삭제 | 코드 미참조(정합) | ✅ 삭제 | **반영됨** |
| 25_drop_frm_typ | frm_typ_cd·FRM_TYPE 제거 | 코드 미참조(주석만) | ✅ 라이브 부재 | **반영됨**(모범) |
| 27_print_options_master | t_prt_print_options 마스터 신설 | pricing.py print_opt_cd 매칭 | ✅ 7행 | **반영됨** |
| 28_price_dim_print_option | clr_cd→print_opt_cd 전환·clr행 DELETE | NON_QTY_DIMS print_opt_cd(clr 제외) | ✅ clr 0·print_opt 1431 | **반영됨** |
| 29_price_dim_plate_size | plt_siz_cd 차원 | NON_QTY_DIMS | ✅ 1219행 | **반영됨** |
| 30_nonspec_size_incr | nonspec_width/height_incr | (엔진 미사용·상품 차원) | ✅ 컬럼 존재 | 반영됨(엔진 범위 외) |
| 32_price_dim_size_wh | siz_width·siz_height 구간 | TIER_DIMS(:45) | ✅ 922행 | **반영됨** |
| 33_size_dim_upper_comment | siz 방향 '이상'→'이하' | TIER_UPPER(:46) | ✅ comment '이하' | **반영됨**(코드·DB·코멘트 3원 정합) |
| 34_opt_tmpl_dtl_opt | dtl_opt jsonb(option_items·template_selections) | (외부전송용·가격 미반영, sql/34 주석) | ✅ 컬럼 | 반영됨(가격엔진 미사용 명시) |
| **(dim_vals)** | **전용 DDL 파일 없음** | pricing.py 핵심 사용·models.py:194 | ✅ 라이브 310행 | **DDL 누락**(G-1 phantom — 인덱스 식에서만 등장) |

**종합:** sql Phase7~10 DDL은 거의 전부 코드·라이브 3원 정합(가장 신선한 권위). **단 dim_vals만 정식 ADD COLUMN DDL이 없어 repo 재구축 시 취약**(G-1). frm_typ 제거·siz 방향 정정은 코드·DB·코멘트까지 깨끗이 동기화된 모범.

---

## 권위 신선도 순위 (가격엔진 진실 기준)

1. **라이브 information_schema + 실데이터** (2026-06-18 실측) — 최우선 진실.
2. **pricing.py + models.py** — 라이브와 3원 정합(차원·할인·단가형). 단 frm_typ/clr_cd/addtn_yn 주변 잔재 주의.
3. **sql DDL 21~34** — 거의 정합(dim_vals DDL 누락·01a:242 dsc_typ_cd stale 제외).
4. **pricing-erd.md** — **stale** (Phase 11 미반영: prc_typ/use_dims/dim_vals/할인 누락·frm_typ/8차원 잔존).
5. **prcx01-pricing-model.md** — **stale** (8차원·clr_cd 핵심 시절·LOCKED 2026-05-27).

→ 검증·적재는 **라이브+pricing.py를 자(尺)로**, 설계 문서 prcx01/pricing-erd는 "의도 배경"으로만 인용(차원·할인은 stale이므로 권위로 쓰지 말 것).
