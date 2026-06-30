# 디지털 접지카드 027/029 접지·가변 proc_cd MISSING 진단·교정 명세 (§26 REVIEW G)

작성 2026-06-30 · 라이브 읽기전용 실측 + 시뮬레이터 실증 + 권위 대조 · 실 COMMIT 금지(인간 승인 후 §7 dbmap 위임)

## 대상
- PRD_000027 2단접지카드 · PRD_000029 3단접지카드 (공식 PRF_DGP_E / PRF_DGP_E_FOIL)
- (동형) PRD_000028 미니접지카드도 PRF_DGP_E를 쓰나 065~068/031/032 **미노출** → 본 결함 비해당.

## 판정 요약 (둘 다 진짜 저청구 — FP 아님)

| 항목 | 노출 proc | 판정 | 돈영향 | 원인 |
|---|---|---|---|---|
| 접지(2단) 027 | PROC_000065 가로 / 066 세로 | 🔴 저청구 | 단가형 ×수량 (예 q800: 65×800=52,000원 미청구) | 접지비 단가행이 **리플렛 proc(107)** 로 키잉돼 카드 proc 065/066에 미스 |
| 접지(3단) 029 | PROC_000067 가로 / 068 세로 | 🔴 저청구 | 단가형 ×수량 (예 q800: 120×800=96,000원 미청구) | 단가행이 **리플렛 proc(060)** 로 키잉돼 카드 proc 067/068에 미스 |
| 가변텍스트 027/029 | PROC_000031 | 🔴 저청구 | 고정금액 (예 개수1·q800: 20,000원 미청구) | COMP_PP_VARTEXT_1EA가 PRF_DGP_E에 **미배선** |
| 가변이미지 027/029 | PROC_000032 | 🔴 저청구 | 고정금액 | COMP_PP_VARIMG_1EA가 PRF_DGP_E에 **미배선** |

## 근거 사슬

### 1. 매칭 메커니즘 (엔진 실측)
- `_row_matches`(pricing.py:94)는 use_dims 무관, 단가행의 **채워진 proc_cd 컬럼**을 선택값과 매칭. proc_grp:PROC_000056 토큰은 `:` 포함이라 매칭 차원 아님(UI 게이트 힌트).
- 접지 component(COMP_FOLD_LEAF_HALF/3FOLD/4ACC/4GATE)는 PRF_DGP_E/E_FOIL에 **배선됨**(disp_seq 4~7, addtn_yn=Y). 그러나 단가행 proc_cd는 리플렛 코드:
  - HALF→PROC_000107(반접지) · 3FOLD→PROC_000060(3단) · 4ACC→PROC_000071(병풍) · 4GATE→PROC_000106(4단대문).
- 027/029가 노출하는 접지 proc는 **카드 코드** 065(2단가로)/066(2단세로)/067(3단가로)/068(3단세로). 전 component_prices에 proc 065~068 단가행 **0건** → 선택 시 어느 fold component도 매칭 못 함 → 가산 0.
- 가변 component는 PRF_DGP_E/E_FOIL에 **미배선**(배선 공식은 PRF_DGP_A/A_FOIL/D뿐). 가변 1/2/3개는 단가행 dim_vals `{"개수":N}` 로 구분(COMP_PP_VARTEXT_1EA 한 component가 처리, _2EA/_3EA는 미배선 잔재).

### 2. 권위 대조 (인쇄상품 가격표 260527 · price-folding 시트)
- 두 블록 분리 존재: **B01 카드접지 단가(오시+접지)** = 2단/3단/6단 / **B02 리플렛 접지 단가** = 반접지/3단/병풍/대문.
- 기존 leaflet component 단가행 = B02 리플렛 값과 전 구간 일치(**오염 아님, 리플렛용으로 정상 적재**).
- 카드접지 B01은 **별도 마감비**로 명시 → "접지비 본체 포함" 가설 **반증**. 저청구 확정.
- B01 2단 단가 ≡ B02 반접지(COMP_FOLD_LEAF_HALF) 전 48구간 **수치 동일**, B01 3단 ≡ B02 3단(COMP_FOLD_LEAF_3FOLD) 동일 → 카드 접지비 데이터는 사실상 이미 존재, **proc_cd 키만 잘못**.
- 가변: 상품마스터 디지털인쇄 시트의 2단/3단접지카드 행에 `후가공_가변(텍스트/이미지)=1개/2개/3개` 명시 → 가변 노출 **정당**(오등록 아님). COMP_PP_VARTEXT_1EA 단가행(개수1=15,000~ / 개수3=25,000~40,000) 존재.

### 3. 시뮬레이터 실증 (qty=800)
| 상품 | baseline | +접지 | +가변텍스트 | 증분 |
|---|---|---|---|---|
| 027 | 6,287 | 6,287 (+065) | 6,287 (+031) | **0 / 0** |
| 029 | 6,287 | 6,287 (+067) | 6,287 (+031) | **0 / 0** |

접지 선택 시 4개 fold component 전부 no-match로 표시 생략 = proc_cd 미스 입증. 가변은 component 부재로 항목 자체 없음.

## 교정 명세 (권고: 최소·엔진충실)

**접지** — 기존 배선 component에 카드 proc 단가행 추가(권위 B01 verbatim):
- COMP_FOLD_LEAF_HALF ← proc 065/066, B01 2단 48구간 (×2 = 96행)
- COMP_FOLD_LEAF_3FOLD ← proc 067/068, B01 3단 48구간 (×2 = 96행)
- 근거: ① 두 component는 PRF_DGP_E/E_FOIL에 이미 배선 ② prc_typ(PRICE_TYPE.01 단가형)·use_dims 이미 정확 ③ 값이 권위와 동일 ④ 두 component는 **PRF_DGP_E/E_FOIL 외 어느 공식도 미사용**(교차오염 0) ⑤ 차원컬럼 전부 NULL 와일드카드라 신규 카드 proc 행이 깔끔히 매칭.
- 잔여(코스메틱): component 표시명이 "리플렛"이라 카드 접지를 담는 게 의미상 어색. 카드전용 component mint(COMP_FOLD_CARD_2DAN/3DAN) 또는 리네임은 §18 후속 설계 선택지(정확성에 불필요).

**가변** — 배선 추가(PRF_DGP_A 동형):
- PRF_DGP_E ← COMP_PP_VARTEXT_1EA(disp_seq 9) + COMP_PP_VARIMG_1EA(10), addtn_yn=Y
- PRF_DGP_E_FOIL ← 동 2 component(disp_seq 12/13)

## 산출물
- dryrun: `digital-fold-vardata-027-029-260630-dryrun.sql` (BEGIN…ROLLBACK · 라이브에서 무오류 적용·롤백 검증 완료: fold_2dan=96·fold_3dan=96·var_wire=4)
- 라우팅: §7 dbmap 적재 트랙 (인간 승인 후). comp_price_id는 수동 MAX+1(현 78973) — 실행 시 재계산 필수.

## 검증(생성≠검증)
- 독립 재판정은 hpti-integrity-gate가 I1~I7로 수행. 본 명세는 라이브 읽기전용 실측·시뮬 실증·권위 verbatim 대조까지.
