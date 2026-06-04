# 할인 테이블 코드 제안 — FINAL (Round 1e)

`t_dsc_discount_tables.dsc_tbl_cd`는 `varchar(50)` NOT NULL PK이며 **Excel 소스가 없다** — 우리가
생성하는 코드다. `dsc_tbl_cd`는 자체 테이블의 자유 PK이므로 (`t_cod_base_codes`로의 FK 없음)
등록할 `DSC_TBL` 부모 코드 그룹이 존재하지 않는다; 코드는 50자 이하의 유일한 문자열이기만 하면 된다.
아래 코드는 이번 라운드에 대해 사용자가 CONFIRMED 한 것이다 (7개 테이블 범위 결정).

## 명명 규약

`DSC_<SCOPE>_QTY`

- `DSC_` — 도메인 접두사, `t_dsc_*` 계열과 코드 그룹 스타일 (`PRD_TYPE`, `DSC_TYPE`)을 반영.
- `<SCOPE>` — 적용 대상 상품 그룹에 연결된 짧은 대문자 범위 토큰.
- `_QTY` — 할인 축 = 수량을 표시 (등급 기반은 다른 테이블에 존재).
  향후 `_AMT`/`_GRADE` 형제 코드를 충돌 없이 추가할 여지를 남긴다.

길이 점검: 최장은 `DSC_ACRCARA_QTY` = 15자 ≤ 50. `varchar(50)`에 넉넉히 들어맞음.

## 최종 7개 코드

| group | dsc_tbl_cd | dsc_tbl_nm | 범위 (해소됨) | brackets |
|-------|------------|------------|------------------|---------:|
| acrylic_general   | `DSC_ACR_QTY`     | 아크릴 카테고리 수량별 구간할인 | 아크릴 category 전체, 카라비너 제외 (11 prd) | 6 |
| acrylic_carabiner | `DSC_ACRCARA_QTY` | 아크릴카라비너 수량별 구간할인   | PRD_000166 아크릴카라비너 only (1 prd)    | 3 |
| fabric            | `DSC_FABRIC_QTY`  | 파우치/에코백 수량별 구간할인    | 패브릭 전체, 에코백부자재 PRD_000280 제외 (50) | 5 |
| stationery        | `DSC_STAT_QTY`    | 문구상품 수량별 구간할인       | 문구 master rows (6 prd)                | 5 |
| goods_a           | `DSC_GOODSA_QTY`  | 굿즈상품 A타입 수량별 구간할인   | goods_a master rows (15 prd)           | 5 |
| goods_b           | `DSC_GOODSB_QTY`  | 굿즈상품 B타입 수량별 구간할인   | goods_b master rows (11 prd)           | 3 |
| squishy           | `DSC_SQUISHY_QTY` | 말랑상품 수량별 구간할인       | squishy master rows (5 prd)            | 8 |

## 이전 초안 대비 변경 (3개 코드 → 7개 코드)

이전 초안에는 헤더가 3개뿐이었다 (`DSC_ACR_QTY`, `DSC_POUCH_QTY`, `DSC_STAT_QTY`). 최종 변경:
- `DSC_POUCH_QTY` → **`DSC_FABRIC_QTY`** (범위가 파우치뿐 아니라 필통/에코백 포함 모든 패브릭 상품).
- 4개 코드 추가: `DSC_ACRCARA_QTY`, `DSC_GOODSA_QTY`, `DSC_GOODSB_QTY`, `DSC_SQUISHY_QTY`.
- `DSC_ACR_QTY` 범위를 좁혀 카라비너를 **제외** (PRD_000166은 자체 테이블로 이동) — 이중 할인 방지.

## 근거 / 비고

1. **범위당 공유 테이블 하나 (상품별 아님).** `t_prd_product_discount_tables`가 단일
   `dsc_tbl_cd`를 다수 상품으로 팬아웃한다. 7개 테이블 × N개 상품 링크는 최소이며 출처가 깔끔하다.
2. **`fabric`·`stationery`·`goods_a`는 동일한 요율 스케줄을 공유** (0/5/10/15/20)하지만 별도
   테이블로 유지 — 범위 (상품 집합)가 다르고 서로 다른 Excel 블록에서 유래. 통합하면 출처를 잃고
   독립적으로 편집 가능한 스케줄이 결합된다.
3. **acrylic_general과 acrylic_carabiner는 실제로 다른 스케줄** (6구간 최대 50% vs 3구간 최대 20%)
   이며 상호 배타적 상품 집합 → 두 테이블, 절대 겹치지 않음.
4. **안정성 / 멱등성.** 코드는 사람이 읽을 수 있고 시퀀스 번호가 없어 → 재실행 시 동일한 코드를
   산출한다. `t_dsc_discount_tables`는 비어 있어 (0행) 기존 코드 충돌 가능성 없음.

## dsc_typ_cd (이미 존재 — 제안 아님)

`DSC_TYPE.01` (정률 / rate)은 이미 `t_cod_base_codes`에 존재 (`code-values.md`에서 검증).
모든 detail 행은 `DSC_TYPE.01`을 `dsc_rate` (퍼센트)와 짝지어 사용하고 `dsc_amt` = NULL. 신규
DSC_TYPE 코드 불필요.
