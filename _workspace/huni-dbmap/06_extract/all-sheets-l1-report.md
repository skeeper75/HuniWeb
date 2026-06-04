# 전 시트 L1 충실추출 종합 리포트 (상품마스터 13 + 가격표 2 = 15시트)

수집일 2026-06-05. 원천 read-only. 스크립트 = `06_extract/scripts/extract_l1.py`(상품마스터 13시트, `--sheet` 파라미터화) + `extract_price.py`(판걸이수·IMPORT) + `verify_l1.py`(9게이트). 배치 = `run_all_master.py`.
기준서 = `05_method/G-extraction-spec.md` §9 (8 정보축).

## 1. 9게이트 종합 (15/15 PASS)

8 정보축 무손실 + 완전성 4종 + 메타 4종. non-empty 보존율 **전 시트 100%**, round-trip diff **전 시트 0**.

| 시트 | rec | fields | nonempty% | roundtrip | 숨김행 | 숨김열 | 수식 | 하이퍼링크 | 댓글 | VERIFY |
|------|:---:|:------:|:---------:|:---------:|:----:|:----:|:---:|:--------:|:---:|:------:|
| 계산공식집초안 | 95 | 27 | 100.0 | 0 | 0 | 0 | 0 | 0 | 1 | PASS |
| MAP | 69 | 26 | 100.0 | 0 | 0 | 0 | 0 | 0 | 1 | PASS |
| 디지털인쇄 | 212 | 44 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 스티커 | 154 | 37 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 책자 | 56 | 46 | 100.0 | 0 | 0 | 0 | 0 | 1 | 0 | PASS |
| 포토북(가격포함) | 14 | 56 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 캘린더 | 20 | 38 | 100.0 | 0 | 0 | 1 | 0 | 0 | 0 | PASS |
| 디자인캘린더(가격포함) | 10 | 36 | 100.0 | 0 | 0 | 1 | 0 | 0 | 0 | PASS |
| 실사 | 115 | 41 | 100.0 | 0 | 8 | 1 | 58 | 0 | 9 | PASS |
| 아크릴 | 117 | 38 | 100.0 | 0 | 10 | 1 | 0 | 0 | 8 | PASS |
| 문구(가격포함) | 15 | 37 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 굿즈파우치(가격포함) | 303 | 31 | 100.0 | 0 | 0 | 1 | 0 | 0 | 5 | PASS |
| 상품악세사리(가격포함) | 67 | 9 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 판걸이수 | 125 | 12 | 100.0 | 0 | 0 | 0 | 0 | 0 | 0 | PASS |
| 출력소재(IMPORT) | 120 | 26 | 100.0 | 0 | 0 | 0 | 947 | 0 | 0 | PASS |

- 상품마스터 13시트 합 **1247** 레코드. 댓글 24건 전수 보존(실사 9·아크릴 8·굿즈 5·계산 1·MAP 1).
- IMPORT 수식 947건 = 가격컬럼(가격 국4절/3절) `연당가` 파생 — 전부 meta `is_formula`+원본수식 보존(가격정보 라벨).
- 9게이트 = ①컬럼커버리지(maxcol==추출필드) ②non-empty 보존율 100% ③행카운트 ④round-trip diff=0 ⑤행숨김 ⑥열숨김 ⑦수식 ⑧하이퍼링크 + 댓글수 일치.

## 2. 산출 파일 (06_extract/)

- 상품마스터 시트별 13쌍: `<slug>-l1.csv` + `<slug>-l1-meta.csv` (슬러그 → `sheet-slug-map.md`)
- 판걸이수: `pangeori-l1.csv` + `pangeori-l1-meta.csv`
- 출력소재(IMPORT): `import-paper-l1.csv` + `import-paper-l1-meta.csv` + `import-paper-matrix-long.csv`(종이×상품 ● unpivot 235행)
- 매핑: `seoljeong-import-map.csv`(+md) — 별도설정 24↔IMPORT 18매칭
- 토대: `product-info-foundation.md`(상품정보 = 정합검증 대상) / `price-info-deferred.md`(가격정보 = round-2 이연)
- 요약 JSON: `_master-extract-summary.json` / `_price-extract-summary.json`

## 3. 전 상품(고유 prd_nm) 커버리지

상품시트 11종 합 (sheet, prd_nm) 페어 **259** / 전역 고유명 **253**. 시트별 분포 → `product-info-foundation.md` §2.

## 4. 판걸이수 (사이즈 마진/판형 권위)

- 125 레코드(r2~126), 12 컬럼. 조인키 `A 사이즈옵션명`(= 상품마스터 E와 verbatim).
- 상품정보(axis=product): 재단사이즈·블리드·작업사이즈·상품·판걸이·인쇄가능영역·원형아이마크영역(완칼)·격자아이마크영역(반칼).
- 가격정보(axis=price, round-2 이연): 디지털인쇄(국4절)·디지털인쇄(3절)·col_I. → `price-info-deferred.md`.

## 5. 출력소재(IMPORT) (별도설정 자재 권위)

- 120 종이행(r4~123), 26 컬럼. 대분류 5그룹(디지털인쇄 85·실사출력 17·합판인쇄 9·아크릴 6·하드커버전용 3), A/B ffill.
- 상품컬럼 **15종**, ● 매핑 **235건** unpivot (`import-paper-matrix-long.csv`: 종이행 + 상품컬럼 + ●).
- 상품정보: 대분류·중분류·종이명·평량·약어·구매정보·전지·종이사이즈 + ● 매트릭스.
- 가격정보(이연): 연당가·가격(국4절)·가격(3절) + 947 파생수식.

## 6. 별도설정 ↔ IMPORT 매핑

24건 중 **18 매칭가능 / 6 확인필요**(PUR·하드커버 3·형압명함 = IMPORT 상품컬럼 부재). prd_cd 전건 미확정(BLOCK-1). 상세 → `seoljeong-import-map.md`.

## 7. 의미 코드맵 출처 + 확인 필요

footnote 범례(초록셀 FFB6D7A8, 상품시트 8개)에서 도출 — `product-info-foundation.md` §5.

**확인 필요 (실무진/L2)**:
1. goods-pouch 그레이(FFD9D9D9) 103행 row-wide 밴딩 = 품절/준비중인지(footnote는 문구·굿즈 확정) — 행 단위 vs 셀 단위 해석.
2. 타 시트 그레이·실사 파랑(FF92CDDC)·아크릴 분홍 등 미확정색 의미.
3. font 비흑색 대량 카운트(digital-print 9270 등)는 대부분 기본 테마색 가능성 — "비노출" 의미는 RGB 개별 확인 필요(원형 보존만 완료).
4. 판걸이수 `col_I`(헤더값 0) 의미.
5. IMPORT 카드 통합컬럼(2단/3단/미니) 상품별 종이 분기 필요 여부.
6. 별도설정 prd_cd 확정(BLOCK-1).

## 8. 스크립트 보정 이력 (검증 무결성)

- `extract_l1.py`: openpyxl `fgColor.rgb`/`font.color.rgb` 가 RGB 객체 반환 시 `str()` 강제(JSON 직렬화·일관비교). map 시트에서 발현.
- `verify_l1.py`: round-trip ffill 면제 조건을 `orig==""` → `orig.strip()==""` 로 확장(스티커 r162·굿즈 r39 공백-only 연속행 마커 = ragged 정당 ffill). 보정 후 13/13 PASS.
- `extract_price.py`: 정수형 float(`1.0`) → int(`1`) 표기 정규화(verify.norm 일치). 보정 후 판걸이수 PASS.
- 보정은 모두 검증 정확성(false-FAIL 제거)을 위한 것이며 추출 데이터 무손실 원칙 불변.
