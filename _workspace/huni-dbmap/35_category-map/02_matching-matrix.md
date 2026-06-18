# 02 — 매칭 매트릭스 (MAP × 데이터시트 × 라이브 DB)

**산출**: `matching.csv` (전 321 엔트리), `scripts/match_and_classify.py`.
**입력 3축**:
- MAP: 244 product + 20 alias + 57 section (`map-entries.csv`)
- 데이터시트: 11종 distinct 255 상품 (`_live/sheet_products.csv`)
- 라이브 DB: 275 상품 + 옵션/가격사슬/카테고리 스냅샷 (`_live/products_live.tsv`)

## 매칭 규칙

상품명 정규화 = NFC + 공백·괄호·`/`·`-`·`_`·`,`·`.`·`·` 제거 (한글 음절 보존).
- **1차 exact** = 정규화명 완전일치
- **2차 partial** = 정규화명 상호 포함(substring)
- **3차 none** = 미매칭

### ★ partial 매칭 가드 (round-24 검증 D-3 보정 — HARD)

substring(partial) 매칭은 **라이브 prd_nm 1:1 검증을 통과한 경우에만 승인**한다. MAP명이 더 길고
실존 상품명을 포함하는 경우(예: `골드실버아크릴명찰` ⊃ `아크릴명찰`)는 **별개 상품**일 수 있으므로
partial 매칭을 자동 채택하면 안 된다. 검증 절차:
1. MAP명 = 라이브 prd_nm exact 일치 → 승인.
2. partial만 일치 → 라이브에 MAP명 그대로의 상품이 **실재하는지 직접 SELECT**. 부재면 partial 철회 →
   `none`(❌ 또는 Sheet-only)로 분류. 실재하면 그 prd_cd로 재매칭.
3. 어순/오타 변형(`프리미엄 상품권/쿠폰`↔`프리미엄 쿠폰/상품권`)은 alias-dict 등록 후 `alias` 등급으로 승인.

**D-3 적발 4건**(라이브 부재인데 실존 상품에 흡수): `골드실버아크릴명찰`(≠아크릴명찰 PRD_000152)·
`아이스머그컵`(≠머그컵 PRD_000193)·`LED키캡키링`(≠키캡키링 PRD_000202)·`우치와키링`(≠미니우치와키링
PRD_000227) → 전부 partial 철회·❌ 재분류.

## 라이브 옵션/가격사슬 판정 근거 (실측 체인)

```
상품(t_prd_products)
  → t_prd_product_price_formulas (prd_cd→frm_cd)        [가격공식 바인딩]
  → t_prc_formula_components      (frm_cd→comp_cd)       [공식 구성요소 배선]
  → t_prc_component_prices        (comp_cd, unit_price)  [단가행 존재]
옵션 = t_prd_product_option_items (prd_cd, del_yn='N') 행수
```
- `priced=Y` ⟺ 상품→공식→구성요소→단가행 사슬이 전부 존재.
- `opt_n` = 활성 option_items 행수.

## 매칭 결과 요약

| 축 | exact | partial | none |
|----|------:|--------:|-----:|
| MAP product → 데이터시트 | 다수 | 일부 | 12 (MAP-only) |
| MAP product → 라이브 | 다수 | 일부 | 12 |

- MAP product 244 중 **데이터시트·라이브 양쪽 부재 = 12** (❌미출시, §03).
- 별칭 20건은 ◆교차참조로 별도 표기(이중카운트 0).
- 섹션 57건은 ➖N/A.

## 라이브 적재 사실 (★핵심 발견)

라이브 275 상품 중:
- **옵션(option_items>0) 보유 = 36** (87% 옵션0)
- **가격사슬(priced) 보유 = 76** (72% 가격사슬 부재)
- **옵션 AND 가격사슬 둘 다 = 36** → 즉 "완비(✅) 후보"는 구조적으로 36개 한계.

이는 round-7(option_items 전역 거의 0·R7 FAIL)·round-16/18(가격사슬 단절 광범위) 진단과 정합.
높은 🟡 비율은 매칭 오류가 아니라 **CPQ 옵션 레이어 + 가격사슬이 대부분 미적재인 라이브 실상**.

## 검증 (생성≠판정, spot-check)

- PRD_000146 아크릴키링: option_items=0(실측) · priced 사슬 165행(실측) → `priced=Y, opt=0` → 🟡(옵션0). 분류 정확.
- ✅ 샘플(PRD_000016 프리미엄엽서 opt=41·priced=Y / PRD_000031 프리미엄명함 opt=30 / PRD_000136 PET배너 opt=4): 전부 옵션+가격 완비 실측 확인.
