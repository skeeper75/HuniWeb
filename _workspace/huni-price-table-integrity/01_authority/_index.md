# 권위 가격격자 인벤토리 (01_authority)

§26 가격테이블 적재 무결성 진단 — 권위 정답 격자(정답 자/尺). 권위 = 두 엑셀(절대).
extractor 산출 = 시트별 `<sheet>-grid.csv`(정규 격자) + `<sheet>-dims.md`(차원 분류·기대 적재방식).
load-inspector가 이 정답 격자를 라이브와 대조, integrity-gate가 재실측.

## 시트 격자 인벤토리

| 시트 | grid.csv | dims.md | 정답셀 | 차원유형 | 상태 |
|---|---|---|---|---|---|
| 아크릴 | `acrylic-authority-grid.csv` | `acrylic-authority-dims.md` | **433** | area·qty_discount·addon·fixed | 추출완료(파일럿) |

(이후 동형 전파 시 시트 추가)

## 아크릴 블록별 셀 수 (433)

| 블록 | 차원유형 | 셀 | 비고 |
|---|---|---|---|
| B01 투명3T | area(가로×세로) | 196 | 14×14 대칭 꽉참 |
| B02 투명1.5T | area | 81 | 9×9 대칭 |
| B03 미러3T | area | 81 | 9×9 = B01×2 파생(81/81 검증) |
| B04a 수량할인 | qty_discount | 6 | 전 아크릴 공통(0~0.5) |
| B04b 후가공옵션 | addon_option | 26 | 상품그룹×옵션 |
| B05 코롯토 | area | 36 | 6×6 꽉참(sparse 아님) |
| B06 카라비너 | fixed_shape | 4 | 형태별 고정단가 |
| B07 카라비너 할인 | qty_discount | 3 | 카라비너 전용(0~0.2) |

## 격자 CSV 스키마
`block, dim_type, axis1, axis2, qty_band, value, note`
- area: axis1=`w<가로mm>`, axis2=`h<세로mm>`, value=단가
- qty_discount: qty_band=수량구간(1~49 등), value=할인율
- addon_option: axis1=상품그룹, axis2=옵션명, value=단가
- fixed_shape: axis1=형태명, value=고정단가

## 추출 원칙 준수
- 권위=엑셀 verbatim·날조 0(셀값 정수화 외 무변환).
- 원천 재사용: `06_extract/price-acrylic-price-l1.csv`(재파싱 없음).
- 라이브 미접속(추출 전용·대조는 inspector).
- 도수 판정: "통용" = 도수 무관 단일가 → 도수 비차원(과적발 가드).
- 면적 판정: 등록사이즈(siz_cd) 아닌 면적(가로×세로) → 라이브 use_dims 확인이 inspector 핵심.
