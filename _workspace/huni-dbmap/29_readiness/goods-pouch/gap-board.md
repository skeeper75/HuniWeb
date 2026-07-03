# 굿즈파우치 — 갭 보드 (round-19 종단·재실측)

> 재실측 2026-07-03 · 라이브 읽기전용. 실 COMMIT 0. 각 갭 = 재현(라이브 쿼리) + 돈영향 + 라우팅 + COMMIT 필요분.
> 상품 범위 = PRD_000183~280(98 상품). 대표 = 캔버스 삼각 파우치 PRD_000240.

---

## GB-1 — 71/98 무가격 (③ 가격 미달·핵심)

- **현상:** 굿즈 98상품 중 direct 단가(t_prd_product_prices)도 formula 바인딩도 **없는 상품 71개(72%)**. §21 GP-1 base 적재(0623)가 26상품(주로 파우치/에코백/필통 16·말랑3·데스크3·기타2·패션1·라이프1)만 커버.
- **재현:**
  ```sql
  select count(*) from t_prd_products p where p.del_yn='N'
   and p.prd_cd between 'PRD_000183' and 'PRD_000280'
   and not exists(select 1 from t_prd_product_prices pp where pp.prd_cd=p.prd_cd)
   and not exists(select 1 from t_prd_product_price_formulas pf where pf.prd_cd=p.prd_cd);  -- 71
  ```
  대표 240 캔버스 삼각 파우치: price 0·formula 0 → evaluate_price base_amount 없음 → **PRICE=0(견적불가)**.
- **돈영향:** 71상품 전량 견적 불가(주문 0). 거울·머그·키링·의류·투명부채·다수 파우치 variant. 값 자체는 상품마스터에 verbatim 실재(예 M 9,800·L 11,500) — 적재만 안 됨.
- **적재된 26상품은 base PRICE≠0 정상**(pricing.py:470 `unit_price×qty`. 예 양말 3000·레더 삼각 미니파우치 7200).
- **라우팅:** round-16 `dbm-price-import-builder`(고정가형 그릇) → 71상품 direct 단가 적재. 단 GB-2와 함께 봐야 함(variant별 가격은 옵션 축이 있어야 완성). 인간 승인 후 COMMIT.
- **COMMIT 필요분:** ✅ 있음 — 71상품 direct base 단가 적재.

## GB-2 — variant/사이즈등급 202행이 CPQ 아닌 MAT_TYPE.09 자재로 오적재 (①UI·②환원·핵심)

- **현상:** round-10 size→option 재분류로 확정된 옵션형 값(사이즈등급 M/L/XL·형상 원형/사각/하트·방향 가로/세로형·구수 1~4구·면 단/양면)이 CPQ option_items가 아니라 **MAT_TYPE.09(파우치) 자재행**으로 대량 적재. MAT_TYPE.09 = 굿즈 자재 113행 = variant 덤핑장.
- **재현:**
  ```sql
  select count(*) rows, count(distinct pm.prd_cd) prods
   from t_prd_product_materials pm join t_mat_materials m on m.mat_cd=pm.mat_cd
   where pm.prd_cd between 'PRD_000183' and 'PRD_000280'
     and (m.mat_nm ~ '^(S|M|L|XL|XXL|2L)$' or m.mat_nm ~ '구$|형$|원형|삼각|사각|하트|단면|양면'); -- 85행/42상품
  ```
  대표 240: 자재 MAT_000319 "M"·MAT_000320 "L" (MAT_TYPE.09) = 사이즈등급이 자재로 위장.
- **영향:** ① 손님이 화면에서 사이즈/색/형상을 못 고름(option_groups 5/98뿐·대표 240=0). ② 생산정보 환원이 자재축으로 왜곡(사이즈가 material). 굿즈 option_items 총 13행뿐(전 상품).
- **라우팅:** round-13 `dbm-correctness-auditor`(오적재 자재행 논리삭제 or 옵션화 판정) → round-6 `dbm-option-mapper`(색상/사이즈등급/형상/방향/구수/면 option_groups 신설·본체색=재질행 합성 원리 적용). Q-GP-1/GP-2 도메인 컨펌 선결(폰기종·M/L을 size vs option).
- **COMMIT 필요분:** ✅ 있음 — 오적재 자재행 정리 + CPQ 옵션 신설(규모 큼·설계 선행).

## GB-3 — 추가상품(볼체인/스탠드) addon 부재·잉크가 자재 오염 (①UI·②환원)

- **현상:** C22 추가상품(볼체인 9색·아크릴스탠드·만년스탬프 리필잉크 5cc)이 `t_prd_product_addons`/`t_prd_templates`에 미적재. **리필잉크 7행은 MAT_TYPE.06 자재로 오적재**([[goods-material-contamination-260630]] 계열 — 굿즈 부속이 자재 오염되는 시스템 패턴).
- **재현:**
  ```sql
  select distinct m.mat_nm, m.mat_typ_cd from t_prd_product_materials pm
   join t_mat_materials m on m.mat_cd=pm.mat_cd
   where pm.prd_cd between 'PRD_000183' and 'PRD_000280' and m.mat_nm ~ '리필잉크'; -- 7행 MAT_TYPE.06
  ```
- **영향:** 볼체인/스탠드 선택 UI 부재(addon 미청구)·잉크 addon이 자재로 잘못 모델링. 굿즈 자재 오염 이력과 동형(비substrate가 자재).
- **라우팅:** round-13(잉크 자재행 논리삭제) → round-6/템플릿(addon = t_prd_templates SKU). 인간 승인.
- **COMMIT 필요분:** ✅ 있음(중규모).

## GB-4 — 가공 택일그룹 미적재 (①UI)

- **현상:** C17 가공(라벨없음/라벨부착·에폭시·맥세이프)이 UI 택일이나 excl_group 부재(GRP-BOOK/CAL만). 손님이 라벨 유무를 못 고름.
- **라우팅:** round-6 `dbm-option-mapper`(GRP-GP-가공 신설 vs 상품별 단순공정 — Q-GP-3 컨펌).
- **COMMIT 필요분:** 🟡 있음(소규모·컨펌 의존).

## GB-5 — 대표 240 기본자재 모호 (②환원)

- **현상:** 240 캔버스 삼각 파우치 자재 3행(캔버스+M+L) **전부 dflt_yn='Y'** → 기본 자재가 3개 = 엔진이 어느 것을 기본으로 볼지 모호(M/L은 애초에 자재 아님·GB-2).
- **재현:** `select count(*) filter(where dflt_yn='Y') from t_prd_product_materials where prd_cd='PRD_000240';` → 3/3.
- **라우팅:** GB-2 정리에 포함(M/L 자재행 제거하면 캔버스 1행만 dflt → 해소).
- **COMMIT 필요분:** GB-2 종속.

## GB-6 — 206 반팔티셔츠 빈 껍데기 CPQ (①UI·소)

- **현상:** 206은 option_groups 2개(칼라·사이즈) 있으나 **option_items 0행** → 손님이 선택지 없음. 나머지 4 CPQ 상품(197/198/217/230)은 ref_dim 정상 해소(13행 전부).
- **라우팅:** round-6(206 옵션 items 채움). 소규모.

---

## 갭 → COMMIT 필요분 종합

| 갭 | 견적요소 | 규모 | 라우팅 | COMMIT |
|----|----------|------|--------|:--:|
| GB-1 무가격 71 | ③ | 대 | round-16 direct 단가 | ✅ |
| GB-2 variant 자재오적재 202행 | ①② | 대(설계선행) | round-13→round-6 | ✅ |
| GB-3 addon 부재·잉크오염 | ①② | 중 | round-13→템플릿 | ✅ |
| GB-4 가공 택일그룹 | ① | 소(컨펌) | round-6 | 🟡 |
| GB-5 240 모호 기본자재 | ② | GB-2 종속 | round-13 | 종속 |
| GB-6 206 빈 CPQ | ① | 소 | round-6 | 🟡 |

**결론:** COMMIT 필요분 **있음(대규모)**. 값 결함은 0(상품마스터 verbatim) — 차단은 전부 **시스템성**(적재 그릇·CPQ 신설·오적재 정리). per-product 값 교정 아님.
