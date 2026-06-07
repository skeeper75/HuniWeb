# 신규 코드 제안 — silsa-price-engine (일반현수막 PRD_000138)

> 본 트랙이 신설하는 식별자(공식 1·구성요소 10). 모두 기존 코드테이블 자식코드행 신설 **불요**
> (FRM_TYPE.01·PRC_COMPONENT_TYPE.04/.06 부모 선존재) — `frm_cd`/`comp_cd`는 PK 식별자라 자유채번.
> siz 신규채번은 area-matrix 트랙과 공유(별도). DB 미적재(적재 CSV만).

## 1. 공식 (`t_prc_price_formulas.frm_cd`)

| frm_cd | frm_nm | frm_typ_cd | 명명 근거 |
|--------|--------|-----------|-----------|
| `PRF_BANNER_NORMAL` | 일반현수막 면적매트릭스+옵션 합산형 | FRM_TYPE.01 | `PRF_<상품군>_<형태>`. round-2 `PRF_POSTER_FIXED`·디지털 `PRF_DGP_A` 컨벤션 일관. per-product 공식(D-WIRE) — 공유공식 sparse 폐기 |

## 2. 구성요소 (`t_prc_price_components.comp_cd`)

명명 = `COMP_BANNER_<역할>_<옵션>`. 면적 comp(`COMP_POSTER_BANNER_NORMAL`)는 라이브 선존재 → 신설 아님.

| comp_cd | comp_nm | comp_typ_cd | 추가가격 | 근거 |
|---------|---------|-------------|--:|------|
| `COMP_BANNER_FIN_HEATCUT` | 열재단 | .04 후가공비 | 3,000 | 가공 마감 |
| `COMP_BANNER_FIN_EYELET4` | 타공(4개) | .04 후가공비 | 3,000 | 아일렛 4 |
| `COMP_BANNER_FIN_EYELET6` | 타공(6개) | .04 후가공비 | 4,000 | 아일렛 6 |
| `COMP_BANNER_FIN_EYELET8` | 타공(8개) | .04 후가공비 | 5,000 | 아일렛 8 |
| `COMP_BANNER_FIN_DTAPE` | 양면테입 | .04 후가공비 | 3,000 | 부착 부속 |
| `COMP_BANNER_FIN_SEW` | 봉미싱 | .04 후가공비 | 4,000 | 끝단 봉제 |
| `COMP_BANNER_ADD_QBANG4` | 큐방(4개)추가 | .06 완제품비 | 3,000 | 거치 부자재 (D-CHUGA-TYP) |
| `COMP_BANNER_ADD_STRING4` | 끈(4개)추가 | .06 완제품비 | 4,000 | 거치 부자재 |
| `COMP_BANNER_ADD_LUMBER_LE900` | 각목(900이하)+끈추가 | .06 완제품비 | 4,000 | 거치 부자재·세로변≤900 (U-3) |
| `COMP_BANNER_ADD_LUMBER_GT900` | 각목(900초과)+끈추가 | .06 완제품비 | 8,000 | 거치 부자재·세로변>900 (U-3) |

`FIN_`=가공(finishing, .04), `ADD_`=추가/거치(.06). 개수·길이단계는 옵션값별 comp로 분기(차원 없음).

## 3. siz (면적치수, 공유 — 신규채번 area-matrix 트랙)

77 면적치수(`{가로}x{세로}`) = `SIZ_000536`~`SIZ_000618` 중 B26 해당분. area-matrix `load/t_siz_sizes_BLOCKED.csv`와 **동일 채번**(중복 채번 금지). 본 트랙 `load/t_siz_sizes_BLOCKED.csv`는 그 77행 subset. 라이브 max siz=SIZ_000510. **siz 등록=후니 인간승인.**

## 4. 코드행 신설 불요 확인

- `FRM_TYPE.01`(합산형) 선존재 → frm_typ_cd FK OK.
- `PRC_COMPONENT_TYPE.04`(후가공비)·`.06`(완제품비) 선존재 → comp_typ_cd FK OK.
- 신규 frm_cd/comp_cd는 식별자(자유채번) — `t_cod_base_codes` 코드행 신설 대상 아님.
