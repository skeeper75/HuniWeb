# DEV-REQUEST — 스티커 판형환산 누락 (과다청구 6.3배)

> 카드: t37 · 원본 실측: `.moai/reports/price-defects-260904/FINDINGS.md` §결함1 (리드 세션 260904 실측, 재조사 없이 그대로 인용)
> 제약: 가격구성요소(t_prc_price_components / t_prc_component_prices)만 수정 가능한 레인이 처리 — 코드/DB 스키마 변경은 실무진 전달 필요.

## 요약
스티커 전 상품이 "주문 장수"를 그대로 국4절 판수 자리에 넣어 단가를 조회·곱셈한다. 판걸이수(판당 몇 장 나오는지) 환산이 전혀 이뤄지지 않아, 수량이 많을수록 청구액이 정상가 대비 최대 **6.3배**까지 부풀어 오른다.

## 증상
스티커 전 상품이 주문 장수를 그대로 "국4절 판수" 자리에 넣어 단가 조회 + 장수 곱셈.

## 권위(가격표 「스티커」 시트)
- A1 `반칼 자유형/규격 스티커 (국4절)` · A5 `소재 / 수량(국4절)` → **수량 축 = 국4절 판수**
- 4행 옵션명에 판걸이수 명시: `A5(4판)` `A4(2판)` `A3(1판)` `90*190(6판)` `A6(8판)`
- 「판걸이수」 시트 77~93행: 반칼스티커 A6=8 A5=4 A4=2 100x140=8 124x186=4 90x190=6, 소형반칼 50x70=32 … 스티커팩 75x110=16, 타투 = None

## 라이브 실측

| comp_cd | 현 use_dims | 활성 공식(apply ≤ 260904) |
|---|---|---|
| STK_KISSCUT_PRINT | `["siz_cd","mat_cd","min_qty"]` | FORM_STK_KISSCUT (052·053·054·058·059·060·061·062·063) |
| STK_CUT_PRINT | 동일 | FORM_STK_CUT (055) |
| STK_CUT_CLEAR_PRINT | 동일 | PRF_STK_CUT_CLEAR (056) |
| STK_CUT_LARGE_PRINT | 동일 | PRF_STK_CUT_LARGE (057) |
| COMP_STK_PRINT | 동일 | PRF_STK_FIXED (064) |
| STK_TATTOO_PRINT | `["siz_cd","min_qty"]` | PRF_STK_TATTOO (067) — 판걸이 None, **제외 후보** |
| COMP_STK_PACK / COMP_GANGPAN_PRINT | PRICE_TYPE.02 합가형 | 시트 헤더 별도 확인 필요 |

- `plt_siz_cd` 를 쓰는 스티커 구성요소 = **0개** → `pricing.py:951` `needs_plate=False` → 판수 환산 미발생
- 단가행 min_qty 구간 = 1,2,3,4,5,6,8,10,15,20,25,30,38,40,50…500,100000 (판수 구간)
- `t_prd_product_plate_sizes` 스티커 행 = 전부 `del_yn='Y'` (판형 미등록 상태)
- 국4절 판형 = `SIZ_000499` (316x467, margin 5) · `fn_calc_pansu('SIZ_000499', 사이즈)` 가 가격표와 정확히 일치:
  A6(SIZ_000057)=8 · A5(SIZ_000426)=4 · A4(SIZ_000258)=2 · 90x190(SIZ_000060/612)=6 · 124x186(SIZ_000059)=4 · 100x140(SIZ_000058)=8
- 부수 문제: 대형 SIZ_000199(400x600)=0 (3절 판형 필요) · A4 중복코드 SIZ_000172(1판)≠SIZ_000258(2판) · 94x94 중복 SIZ_000036(12)≠SIZ_000064(8) · 치수 미입력 SIZ_000518/519/514/515 → 판수 NULL

## 정량 영향
A6 반칼 유포 1,000장 주문 기준:
- 현재: 4,500 × 1,000 = **4,500,000원**
- 정상: ⌈1000/8⌉=125판 × 5,700 = **712,500원**
- 배율: **6.3배 과다청구**

## 엔진 동작(코드 근거)
- `pricing.py:951` needs_plate = use_dims 에 `plt_siz_cd` 포함 여부
- `pricing.py:264` plate_qty = ⌈qty ÷ pansu⌉ · `pricing.py:384` _calc_pansu → fn_calc_pansu
- `pricing.py:982` pansu None → "판수 환산 불가 — 합산 제외" (ERR_NO_PLATE, strict 차단)
- `_row_matches` 와일드카드: 단가행 `plt_siz_cd` NULL 이면 어떤 판형과도 매칭 → **단가행은 안 건드려도 됨**
- `price_views.py:price_simulate` 가 `_select_default_plate(prd_cd, siz_cd)` 로 판형 자동선택 → **t_prd_product_plate_sizes 살아 있어야 함**

## 제안 수정안

### 옵션 A — 가격구성요소 레인이 처리 가능한 부분 (허용 범위)
STK_* 구성요소 `use_dims` 에 `"plt_siz_cd"` 추가 (단가행 자체는 무변경). 위 표의 STK_KISSCUT_PRINT / STK_CUT_PRINT / STK_CUT_CLEAR_PRINT / STK_CUT_LARGE_PRINT / COMP_STK_PRINT 대상.

### 옵션 B — 실무진 전달 필요(불허 영역, 이 DEV-REQUEST의 본 요청)
① 스티커 상품 판형 등록 복구: `t_prd_product_plate_sizes` 스티커 행이 전부 `del_yn='Y'` — 국4절(SIZ_000499)로 복구, 대형 사이즈(400x600 등)는 3절 판형 등록 필요.
② 사이즈 치수(work_width/height) 정비: SIZ_000518/519/514/515 치수 미입력으로 판수 NULL 발생 — 치수 입력 필요.
③ 사이즈 중복코드 정리: A4 중복(SIZ_000172 1판 ≠ SIZ_000258 2판), 94x94 중복(SIZ_000036 12 ≠ SIZ_000064 8) — 어느 쪽이 정본인지 확정 필요.
④ STK_TATTOO_PRINT(타투 스티커): 가격표상 판걸이수 = None → 판수 환산 대상에서 제외할지, 별도 산식이 있는지 실무진 확인 필요.

## 우선순위 / 긴급도
**High** — 과다청구(6.3배)로 라이브 서비스 중인 소비자 대상 실손실 발생 중. 즉시 조치 대상.

## 비고 — ⚠ 순서 의존성
판형 등록(옵션 B ①) 완료 전에 use_dims 에 `plt_siz_cd` 만 추가(옵션 A)하면, 스티커 가격이 "판수 환산 불가"로 막혀 **가격 산출 자체가 불가능해진다**(fail-closed — 과다청구는 멈추지만 판매 불가로 전환). 따라서:
1. 실무진이 먼저 판형 등록(①)·치수 정비(②)·중복코드 정리(③)를 완료
2. webadmin 실화면(product-viewer/가격시뮬레이터)에서 판형 자동선택·정상가 확인
3. 그 다음에만 가격구성요소 use_dims 변경(옵션 A)을 COMMIT

**COMMIT 은 판형 등록 완료 확인 후에만.**
