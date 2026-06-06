# Huni-DBMap round-2(가격 평면화) 핸드오프

> **⚡ [2026-06-06 최신 트랙] 가격표 15 단가시트 → component_prices 평면화 완성·적대검증 GO.** 이 문서가 round-2 가격 작업의 최신 재시작 포인터다. 이전 round-2 단계(어색데이터 교차매핑·D-A/B)는 `CHANGELOG.md` 및 메모리 [[dbmap-round2-price-engine]]에 보존. CPQ 컨피규레이터 설계는 별도 트랙 `10_configurator/HANDOFF.md`. round-3 적재설계는 `HANDOFF-audit.md`.

작성 2026-06-06 · 이 문서만 읽고 이어가도록 정리. 식별자/코드/SQL 영어, 설명 한국어.

## 0. 한 줄 현황

가격표 **15 단가시트**(16은 브리프 off-by-one = 19 − 4)를 **베스트프랙티스 재현가능 ETL**(profile → extract[무손실 9게이트] → transform[평면화] → validate[적대검증])로 처리 완료. **`t_prc_component_prices` 4,805행** + price_components 143 + 공식배선 산출(`02_mapping/load_price/`). **적대 교차검증 GO**(매핑 무결성: 역대조 100%·자연키 중복 0·날조 0·dodge 0·과소적재 0·발명 0). **즉시 적재가능 2,106행 / 후니 siz 등록 대기 2,697행**. **DB 미적재 유지**.

> [다음 세션 시작점 — 여기부터]
> 1. **입력** = `03_validation/price-load-validation-final.md`(종합 판정 + §B-2 후니 등록 목록 + §B-5 15시트 대시보드) · `02_mapping/load_price/`(적재 CSV) · `02_mapping/scripts/transform_price_sheets.py`(재현 평면화).
> 2. **다음 = 외부 의존 3건 중 택일** (모두 후니/사용자 결정 필요):
>    - **(A) 박(소형/대형) GAP 모델링 결정** — 면적→분류(A~E/A~I)→가격 2단 룩업이 component_prices 6차원에 중간키 부재. 동판비 등 단순부분만 적재, 가공비는 에스컬레이션(억지 평면화 안 함). 분류키를 어디에 둘지(mat_cd 차용? 신규 차원? 면적함수?) 결정 필요.
>    - **(B) 후니 siz 등록 후 적재** — placeholder 2,697행의 siz_cd를 후니가 `t_siz_sizes`에 등록(군별 목록 = validation-final §B-2)하면 실코드 치환 후 적재가능. `PRC_COMPONENT_TYPE.06` 코드행도 선적재.
>    - **(C) 잔여 정합 검토** — 공식배선(price_formulas)이 봉투/포스터 등 일부만. 계산공식집초안 기반 상품↔공식 바인딩 확대(가격표=단가, 공식은 상품마스터 계산공식집 몫이라는 경계는 검증됨).
> 3. [HARD 원칙] DB 미적재 · 라이브 권위(추출본 stale) · placeholder 만들기 전 **라이브 실코드 탐색 필수**(dodge 방지) · 전수 완전성 self-check(블록 통째 누락 방지) · **실무진 셀 텍스트=가격 의미**(포함가·세트·추가옵션 절대 간과 금지).

## 1. 건드리지 말 것 (확정 산출 · 검증 GO)

- **`02_mapping/load_price/` 적재 CSV** — component_prices 4,805행 외 6테이블. 역대조 100%·자연키 중복 0. B-FINAL-1(comp_cd 55자>50 현수막각목 3종) → `COMP_POPT_BNR_GAKMOK_STR_900_4` 계열 단축 해소(잔존 0·고아 0).
- **`02_mapping/scripts/transform_price_sheets.py`** — 재현 평면화(유형별 transform: 밴드매트릭스/면적/합가/소재판수/4축).
- **`06_extract/scripts/{profile_price_sheets.py,extract_price_sheets.py}`** + `06_extract/price-<slug>-l1.csv` 15종 — 무손실 L1(9게이트 PASS, 메타 청결: font/fill theme컬러 정정).
- **`05_method/F2-price-sheet-structures.md`** — 15시트 구조 카탈로그(블록·밴드헤더·수량축·차원).
- **`03_validation/price-load-validation{,-wave2,-final}.md`** — 적대검증 3종(파일럿 5 / 비면적 7 / 면적 3+종합).
- **`02_mapping/schema-fitgap-price.md`** — 15시트 fit-gap 차원확정.

## 2. 미해소 (적재 전 — 외부 의존)

- **후니 siz 등록 2,697행**: 국4절/3절(=출력판형 `OUTPUT_PAPER_TYPE.01 국전계열`, `t_prd_product_plate_sizes`가 siz_cd 재사용하나 해당 출력판형 siz 미등록) · 아크릴 면적 149좌표(47종은 SIZ_000336 등 실코드 교체 완료) · 봉투4종 · 스티커 판수결합 · 합판 원형11 · 박 분류. 군별 = `price-load-validation-final.md §B-2`.
- **`PRC_COMPONENT_TYPE.06` 코드행** 라이브 미등록(`.05 박형압비`까지만) → `t_cod_base_codes` 자식 1행 선적재 필요(DDL 무변경, 코드행 INSERT).
- **박(소형/대형) GAP** = 2단 룩업 모델링 후니 결정.
- **공식배선 확대** = 계산공식집초안(`06_extract/calc-formula-draft-l1.csv`) 기반 상품↔공식 바인딩(현재 일부만).

## 3. 이번 세션 결정 (재론 금지)

- **베스트프랙티스 ETL 3단 정립**(재현 스크립트): Extract 무손실 9게이트 → Transform 평면화 → Validate 적대검증. 설계≠검증 분리가 dodge·과소적재 반복 적발의 핵심.
- **siz_cd placeholder = 후니 등록 대기 표식**(발명 아님, 정당 blocker). 국4절/3절은 완성품 규격(siz_cd 본의)이 아닌 출력판형이나 후니 스키마상 siz_cd 재사용으로 표현 가능.
- **면적 = 좌표 siz_cd 방식**(사용자 확정): 가로×세로 조합 = siz_cd. 실코드 우선 탐색, 부재만 placeholder.
- **합가 처리**(규칙④): .04 후가공 / .06 완제품비. `t_prd_product_prices` 미신설 정당(사이즈/수량 변동 → component 차원, 규칙④ 후단).
- **실무진 셀 텍스트 = 가격 의미**(사용자 지침 HARD): 포함가("출력+코팅+가공")·세트("2개1세트"=bdl_qty)·추가옵션을 note·차원에 반영. 날조 0 검증.
- 별색=공정(clr NULL)·단/양면 comp분리·양면≠단면×2 등 규칙1~10 정합.

## 4. 산출물 지도

```
_workspace/huni-dbmap/
├ 06_extract/  scripts/{profile_price_sheets,extract_price_sheets}.py · price-<slug>-l1.csv(15) · _price-sheets-extract-summary.json(9게이트) · price-sheets-profile.json · calc-formula-draft-l1.csv(공식권위)
├ 05_method/   F2-price-sheet-structures.md(15시트 구조 카탈로그)
├ 02_mapping/  scripts/transform_price_sheets.py · load_price/*.csv(적재 7종, component_prices 4805행) · schema-fitgap-price.md · price-code-proposals.md · load_price_pilot/(굿즈파우치 선례)
├ 03_validation/ price-load-validation.md(파일럿5) · -wave2.md(비면적7) · -final.md(면적3+종합·B-2 후니등록목록 권위)
└ HANDOFF.md (이 문서)
```

입력 원본(read-only): `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`(19시트) · `후니프린팅_상품마스터_260527.xlsx` · `docs/huni/DB스키마/*.xlsx`. 가격엔진 DDL = `00_schema/price-engine-ddl.md`. 스킬 = `dbm-price-formula`(규칙1~10)·`huni-dbmap-orchestrator`. 메모리 = [[dbmap-round2-price-engine]]·[[dbmap-l1-l2-extraction-first]]·[[dbmap-no-db-load-file-first]].
