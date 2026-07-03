# 굿즈 variant 특수 4상품 — GB-2 흡수 라이브 COMMIT (2026-07-04)

> clean 28과 별도 판별했던 5상품 중 4상품 구축(폰케이스=미등록 블로커). 값=엑셀 verbatim. 공유 PRF/COMP_GOODS_FIXED_SIZ 재사용.

## COMMIT 내용
- **194 워터북보틀**: siz 2 mint(용량 350ml/500ml·SIZ_609/610) + 단가행 9,000/9,300 + 바인딩 + CPQ "용량" + 자재 MAT_269/343(용량라벨) delink.
- **198 피크닉매트**: 기존 siz 재사용(SIZ_399 1인/402 2인·mint 0) + 단가행 40,000/60,000 + 바인딩 + 신규 CPQ "사이즈"(택1) + 기존 "색상"(화이트/블랙) 유지(이중축·무delink).
- **217 만년스탬프**: 기존 siz 7 재사용(SIZ_419~425·라벨매칭·mint 0) + 단가행 7행(9,000~23,000) + 바인딩 + 신규 CPQ "사이즈" + 자재(스탬프몸체 MAT_TYPE.06)·잉크칼라 유지.
- **226 아크릴쉐이커코롯토**: ★TBD 공식 은퇴(PRF_ACRYL_SHCOROTTO_TBD use_yn=N·rebind→PRF_GOODS_FIXED_SIZ) + siz 3 mint(인쇄면 양면/전면만/배면만·SIZ_611~613) + 단가행 9,000/7,500/7,500 + CPQ "인쇄면"(택1) + CPQ "글리터"(무가·핑크/화이트/블루/블랙 ref→mat·ref_key2=USAGE.07) + 인쇄면 자재 MAT_309/311/313 delink(글리터 4는 유지=글리터 CPQ ref 대상).

## 규모 (스크립트 도출)
- siz mint 5(SIZ_609~613·194·226) + 재사용 9(198:2·217:7)
- component_prices 14행 verbatim(공유 COMP_GOODS_FIXED_SIZ)
- 바인딩 4(194/198/217 INSERT·226 rebind UPDATE)
- CPQ 옵션그룹 5(OPT_200~204) + 옵션/아이템 18(OPV_734~751)
- 자재 delink 5(194:2·226 인쇄면3)

## 검증 (webadmin 가격시뮬·제외0·PRICE≠0·전건 PASS)
- 워터북보틀 350ml=9,000 · 피크닉매트 1인=40,000 · 만년스탬프 원형13x13=9,000 · 아크릴쉐이커 양면=9,000/전면=7,500(★TBD PRICE 0→정상 해소).
- 전부 ok=True·src=FORMULA·excl=0.

## 확립 (트리거 교훈)
- **OPT_REF_DIM.03(자재) 옵션아이템은 ref_key2=usage_cd(USAGE.07) 필수**(fn_chk_opt_item_ref·198 정상배선 동일). 초기 dryrun에서 ref_key2 NULL로 위반 적발→교정.
- 226 인쇄면=유가 siz화 + 글리터=무가 CPQ(자재 ref)=이중축·TBD 교체는 §18 설계 성격이나 값 엑셀 verbatim이라 적재.

## 안전장치
- `apply.sh`(백업 pre_materials/pre_formulas.csv) · `undo.sql`(15 stmt·226 TBD 복원 포함) · manifest.

## 잔여 (블로커·명세만)
- **슬림하드 폰케이스** = 라이브 미등록 → 상품 등록 선행(별도 트랙). `SPECIALS-design.md` §폰케이스.
- OPTION-same-price 계열(레더코스터·젤리·에어팟·버즈 등)=가격동일 variant → CPQ만(공식 불요·후속).
