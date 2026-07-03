# 굿즈파우치 GB-2 파일럿 — 캔버스 삼각 파우치(240) variant 고정가 공식식 종단 COMMIT (2026-07-04)

> 트랙: §7 적재 + §18 설계. 방향2(현수막식) 확정: **base 구성요소 grid(use_dims=[siz_cd]·PRICE_TYPE.01·verbatim) + CPQ 옵션(사이즈 택1) + 오적재 자재 정리**.
> 권위 = 상품마스터 260702 verbatim(M 9,800 / L 11,500). 값=스크립트 도출.

## 왜 공식식인가 (방향 판별 근거)
`evaluate_price`는 base source가 **직접단가(product_prices) XOR 공식**(if/else 배타). 직접단가는 (prd_cd,apply_ymd) 단일가라 variant(M/L) 불가.
→ **한 상품에서 손님이 M/L을 골라 가격이 바뀌려면 공식+구성요소가 유일 정합 경로**. 단 base 구성요소는 **명시가(고정단가) grid**(계산 아님)라 (가격포함) 성격 유지 — 일반현수막 "실사 완제품가"(81행 면적 grid)와 동형.

## COMMIT 내용 (종단 15행·FK 위상순서)
1. siz mint 2 — SIZ_000562(캔버스 삼각 파우치 M)·SIZ_000563(L)·등급·치수無
2. product_sizes 2 (240·트리거 OPT_REF_DIM.01 선행요건)
3. **공유 공식** `PRF_GOODS_FIXED_SIZ`(굿즈 사이즈등급 고정가)
4. **공유 구성요소** `COMP_GOODS_FIXED_SIZ`(굿즈 사이즈별 완제품가·PRICE_TYPE.01·use_dims=["siz_cd"])
5. 배선 formula_components
6. 단가행 2 verbatim — (COMP, SIZ_562)=9,800 · (COMP, SIZ_563)=11,500
7. 상품-공식 바인딩 240→PRF (240 product_prices 0이라 공식경로)
8~10. CPQ — 옵션그룹 OPT_000172 "사이즈"(SEL_TYPE.01 택1·mand) + 옵션 OPV_000667 M(dflt)/OPV_000668 L + option_items ref_dim=사이즈→siz_cd (트리거 fn_chk_opt_item_ref 통과)
11. 오적재 자재 정리 — 240의 MAT_000319"M"/MAT_000320"L" 링크 논리삭제(del_yn='Y'·240만·자재 마스터 무접촉·공유 14/13상품 무영향)→active_mat 3→1(캔버스만)

## 사후 검증
- 라이브 재실측: formula=PRF_GOODS_FIXED_SIZ·opt_items 2·active_mat 1·단가행 M9,800/L11,500.
- **webadmin 실화면(라이브 admin simulate)**: 240 M qty1=**9,800**·L qty1=**11,500**·M qty10=**98,000**(src=FORMULA·ok=true). 선택無=0(사이즈 필수옵션이 실주문 가드).

## 확립된 패턴 (전 32 variant 동형 전파용)
공유 자산 `PRF_GOODS_FIXED_SIZ`+`COMP_GOODS_FIXED_SIZ`는 **재사용**. 상품마다:
- variant마다 siz_cd mint(product-unique) + product_sizes + component_prices[siz]=엑셀 verbatim + 바인딩 + CPQ 옵션(→siz_cd) + 오적재 자재 링크 정리.
- variant 축이 달라도(구수·기종·치수·인용) 전부 **이산 variant→siz_cd→고정가** 로 통일 수용.
- 추가상품(볼체인/잉크)=addon 별도합산(상품악세사리 템플릿 재사용)·수량구간 할인=t_dsc_* 별도(후속).

## 안전장치
- 물리백업 `backup/pre_materials.csv`. undo `undo.sql`(15행 전부 역제거 + 자재 링크 복원).

## 잔여
- variant 32 동형 전파(대표 파일럿 완주로 superset 확보). 무가격 5=실무진 BLOCKED.
- 추가상품 addon 연결·수량구간 할인 링크·가공 추가옵션(에폭시/맥세이프)=후속 단계.
