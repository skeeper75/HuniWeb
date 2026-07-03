# GB-5 선행 판정 — evaluate_price 본체 자재필터 여부 (146 silent-0 좌우)

> 실측 2026-07-03 라이브 읽기전용 + `raw/webadmin/catalog/pricing.py`·`price_views.py` 코드 대조.
> 이 판정이 GB-3(146 자재 재매핑) 우선순위를 결정한다.

## 질문
면적매트릭스 본체 구성요소(`COMP_ACRYL_CLEAR3T`)를 evaluate_price가 **상품 기본자재(mat_cd)로 필터링**하는가? 필터하면 146(본체자재=MAT_000386, 격자에 0행)은 본체가격 0 → silent-0.

## 판정: **YES — 엔진은 본체를 mat_cd로 필터한다 → 146은 silent-0 CONFIRMED**

### 근거 1 — 구성요소 use_dims에 mat_cd가 실재 (매칭 차원)
`COMP_ACRYL_CLEAR3T.use_dims = ["mat_cd","siz_width","siz_height","min_qty"]`.
pricing.py `_row_matches`(L94~106)는 `NON_QTY_DIMS`(mat_cd 포함)를 순회해, 단가행의 해당 컬럼이 **NULL이면 와일드카드**, **비-NULL이면 선택값과 정확일치**를 요구한다.

### 근거 2 — CLEAR3T 단가행의 mat_cd가 전부 비-NULL (와일드카드 아님)
```
COMP_ACRYL_CLEAR3T 단가행 mat_cd 분포:  MAT_000042 → 81행,  MAT_000043 → 196행,  (NULL 0행)
MAT_000386 → 0행
```
→ 전 행이 mat_cd를 명시(MAT_000042/043)하므로 와일드카드 통과가 불가능. 선택 mat_cd가 042/043이 아니면 **매칭 0**.

### 근거 3 — 146의 시뮬레이터 기본 mat_cd = MAT_000386 (격자 0행)
`price_views.py` L1385~1395: 자재 드롭다운은 `TPrdProductMaterials.exclude(del_yn="Y")`(논리삭제 제외)에서 `disp_seq` 순으로 구성, dflt_yn='Y'를 기본 선택.
146 자재 실측:

| mat_cd | 자재명 | mat_typ | dflt_yn | disp_seq | del_yn |
|--------|--------|---------|---------|----------|--------|
| MAT_000043 | 아크릴 투명 3mm | TYPE.03 | **Y** | 1 | **Y (삭제)** |
| MAT_000042 | 아크릴 투명 1.5mm | TYPE.03 | Y | 11 | Y (삭제) |
| **MAT_000386** | 아크릴(투명) 3mm | **TYPE.20(굿즈)** | N | 13 | **N (활성)** |
| MAT_000052/051 | 아크릴키링 금/은색고리 | TYPE.07 | N | 14/15 | N (부속) |
| MAT_000456 | 군번줄 | TYPE.03 | N | 16 | N (부속) |

- dflt_yn='Y'인 자재(MAT_000043·042)는 **둘 다 del_yn='Y'라 드롭다운에서 제외**된다.
- 활성 자재 중 dflt_yn='Y' 없음 → 기본 선택은 disp_seq 최소의 활성 본체자재 = **MAT_000386**(굿즈타입, 아크릴 투명 3mm 중복코드).
- MAT_000386은 CLEAR3T 격자에 **0행** → `_row_matches` 실패 → 본체 매칭 0 → `no_match`/`no_tier_row` → 본체 소계 0.

→ **146 본체가격 = 0 (silent-0) 결정적 확인.** (다른 20상품은 활성 MAT_000043 사용 → 정상.)

## 함의
- **GB-3 우선순위 = HIGH.** 146은 자재필터 때문에 실제 silent-0. 본체 견적이 0이 되어 부속(GB-2)을 얹기 전에 본체부터 깨져 있다.
- GB-3 교정 = 146의 MAT_000043 재활성(del_yn Y→N, 이미 dflt_yn='Y'라 재활성 즉시 기본선택 복귀) + 중복 굿즈코드 MAT_000386 은퇴(del_yn N→Y). 그러면 기본 mat_cd=MAT_000043 → 격자 196행과 매칭 → 본체 정상.
- 코드 결함(C트랙) 아님 — 엔진 동작은 설계대로 정상(비-NULL mat_cd = 정확일치). 순수 **데이터 오적재(146 자재 오염)**. 개발팀 라우팅 불필요.

## webadmin 실화면 확인 항목(적재 승인 전 [HARD])
가격시뮬레이터에서 146 아크릴키링 선택 → 본체가격 현재 0(또는 "단가 없음 — mat_cd=MAT_000386") 표시 확인 → GB-3 교정 후 재시뮬 시 제외0·PRICE≠0.
