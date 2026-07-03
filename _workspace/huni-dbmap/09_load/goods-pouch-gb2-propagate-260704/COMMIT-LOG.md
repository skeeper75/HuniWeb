# 굿즈파우치 GB-2 동형 전파 — clean 28상품 (2026-07-04)

> 파일럿(240 캔버스삼각파우치)과 동형인 clean 28 variant 상품에 GB-2 패턴 전파.
> 값 = 상품마스터 260610 엑셀 verbatim(`24_master-extract-260610/goods-pouch-l1.csv`·스크립트 도출·LLM 전사 0). 멱등. **DRY-RUN 완료·COMMIT 인간 승인 대기**.

## 대상 28상품 (변형 33 중 240 done·특수 5 제외)
파우치 15(레더/캔버스/린넨/타이벡/메쉬)·거울 2·키링 3·클립보드 2·기타(핀버튼·폰스트랩·이미지피켓·벨벳쿠션·레더라벨) 6.

## 확립 규칙 (파일럿 대비 교정 3건)
1. **search-before-mint 재사용** — 11상품이 이미 정확한 치수 siz 보유(186 S(75x130mm) 등) → 신규 mint 안 하고 **기존 siz 재사용**(siz 재사용 22·신규 mint 45). 중복 방지[HARD].
2. **186·187 상품별 구성요소** — 사각손거울·블랙사각손거울이 동일 siz(SIZ_384/386/388) 공유하나 가격 상이(S 5000 vs 6000) → 공유 `COMP_GOODS_FIXED_SIZ`(use_dims=[siz_cd])는 siz당 단일가라 구분 불가 → 이 쌍만 `COMP_GOODS_FIX_186/187`+`PRF_GOODS_FIX_186/187`. 나머지 26=공유 재사용. (파일럿 공유모델은 240 siz가 상품유일이라 통했을 뿐)
3. **230 레더플랫파우치 = 기존 CPQ 재사용** — 이미 사이즈 옵션그룹(OPT_073·M/L·siz SIZ_433/434) 완비·가격만 부재 → 옵션 신규생성 없이 가격행+바인딩만.

## COMMIT 규모 (스크립트 도출)
- siz: 재사용 22 + 신규 mint 45 (SIZ_000564~608)
- component_prices: 67행 verbatim (공유 COMP_GOODS_FIXED_SIZ + 상품별 2)
- 상품-공식 바인딩: 28
- CPQ: 신규 옵션그룹 27(OPT_000173~199) + 옵션/아이템 65(OPV_000669~733) + 230 기존 재사용
- 오적재 자재 정리: MAT_TYPE.09 variant 라벨 링크 delink 43(상품 링크만·자재 마스터 무접촉·substrate 유지)

## DRY-RUN 검증 (라이브 ROLLBACK)
- ON_ERROR_STOP 무오류·트리거 fn_chk_opt_item_ref 통과(옵션→siz 참조 해소).
- POST: binds 28·psizes 68(=variant 67 + 220 기존 물리치수 17x320mm 1·미터치)·opt_items 67·**variant_mat_left 0**(전 .09 delink).
- 채번 충돌 0(SIZ_564~608·OPT_173~199·OPV_669~733 전부 미사용).
- **가격사슬 실측**: 186 S=5000(COMP_186/SIZ_384) · 187 S=6000(COMP_187/SIZ_384) = 같은 siz·다른 comp·다른 가격 **무충돌 입증**. 공유 comp는 use_dims=[siz_cd] 정확매칭이라 상품별 선택 siz만 조회.

## 안전장치
- `apply.sh`(dryrun/commit 분리·물리백업 pre_materials/pre_sizes.csv) · `undo.sql`(41 stmt·신규분 역제거+재사용 siz/CPQ 보존+자재 delink 복원) · `manifest.json`(상품별 variant→siz→가격→mint/reuse).

## COMMIT 절차 (승인 시)
계열별 배치 COMMIT + webadmin 가격시뮬 실화면 확인(제외0·PRICE≠0)[HARD §1]. 예: 파우치15 → 거울/키링 → 나머지.

## 잔여 (특수 5상품·별도 설계)
194 워터북보틀(용량·자재=variant)·198 피크닉매트(사이즈+색 이중축)·217 만년스탬프(자재=variant)·226 아크릴쉐이커코롯토(TBD공식·인쇄면+글리터)·슬림하드폰케이스(라이브 미등록·40기종). → `SPECIALS-design.md`
