# r-b3-price-model.md — 실사 A-프리셋 과대청구(R-B3-PRICE) 교정 모델 정립

> dbm-price-arbiter · 2026-06-23 · 라이브 읽기전용 분석·DB 미적재. 단가 verbatim·기초코드 마스터 불변.
> 결론: **모델 D-2 GO(데이터 측면)** — 단 ★위젯/price_views 계약 변경(siz_preset) 동반 필수(미동반 시 사용자입력 0원 회귀).

## ① 라이브 실측
- comp **COMP_POSTER_ARTPRINT_PHOTO** `use_dims=[siz_width, siz_height, min_qty]`(PRICE_TYPE.01 단가형)·**siz_cd 미사용**(면적매트릭스형).
- 기존 단가행 **52개 전부 siz_cd=NULL**(와일드카드)·비수량 차원 NULL·면적그리드 최소=**600×600**. 라이브 = 권위 포스터/사인 면적매트릭스(600mm~)와 일치.
- 공유: 5공식(PRF_POSTER_ARTPRINT·WATERPROOF·ADH_WP·ARTFABRIC·FIXED)이 단독 구성. 바인딩 상품 **4**(118 아트프린트·120 방수·121 접착방수·123 아트패브릭). 그 외 공유 상품 없음 → **행 추가 시 4상품 동일 영향**.
- 권위 verbatim(silsa-l1 260610·4상품 동일): **A3(297×420)=7,000·A2(420×594)=7,000·A1(594×841)=12,000·사용자입력(200~1200×200~3000)=면적매트릭스(600~)**.

## ② 동시매칭(ERR_AMBIGUOUS) 위험 — 재계산 실증
- **모델 A(siz_cd 프리셋 행 추가) = NO-GO**: A3 선택 시 프리셋행(siz_cd=A3)+면적행(siz_cd=NULL 와일드카드) 둘 다 매칭 → `_combo_key` 2개 → ERR_AMBIGUOUS → 합산 제외(0원). 엔진에 "siz_cd 우선" 로직 없음(`match_component` 동등 취급).
- **모델 B(면적 티어 하향 확장) = NO-GO**: 프리셋은 맞으나 사용자입력 off-grid(예 500×550, 권위=매트릭스)가 추가 프리셋 면적행으로 ceiling→저청구. ★사용자입력 범위가 프리셋 치수와 **완전 중첩** → 면적축 단독 분리 불가.

## ③ 채택 모델: D-2 (dim_vals 판별차원 — comp use_dims 불변)
공유/기초 마스터(use_dims) 무변경, **데이터행만** 변경:
- **프리셋 3행 신규**(comp=COMP_POSTER_ARTPRINT_PHOTO·siz_w/h NULL·min_qty NULL·apply_ymd=2026-06-01):
  - `dim_vals={"siz_preset":"A3"} → 7000`
  - `dim_vals={"siz_preset":"A2"} → 7000`
  - `dim_vals={"siz_preset":"A1"} → 12000`
- **기존 52행 UPDATE**: `dim_vals={"siz_preset":"CUSTOM"}` 백필(가격·치수 불변=상호배타화).
- 대안 모델 C(use_dims에 siz_cd 추가)는 comp 마스터 변경=공유자원 충돌이라 열위 → D-2 우월.

## ④ evaluate_price 재계산 검증표 (허용오차 0·ambiguous 0)
| 입력 | 모델 결과 | 권위 | 판정 |
|---|---|---|---|
| A3 (siz_preset=A3) | 7,000 | 7,000 | PASS |
| A2 (siz_preset=A2) | 7,000 | 7,000 | PASS |
| A1 (siz_preset=A1) | 12,000 | 12,000 | PASS |
| 사용자입력 600×600 (CUSTOM) | 12,000 | 12,000 | PASS |
| 사용자입력 600×1000 (CUSTOM) | 20,000 | 20,000 | PASS |
| off-grid 500×550 (CUSTOM) | 12,000(600 ceiling) | ceiling | PASS |
| ERR_AMBIGUOUS | 0건 | — | PASS |

## ⑤ ★회귀 위험 (결정적 제약)
- **위젯/시뮬레이터 계약 변경 필수**: 위젯이 ⓐ프리셋 클릭→`selections={siz_preset:"A3"}`, ⓑ사용자입력→`selections={siz_preset:"CUSTOM", siz_width, siz_height}`를 **반드시** 주입해야 함.
- 현 `price_simulate`(price_views.py L1581~)는 selections 그대로 전달·siz_preset 주입 로직 없음 → **데이터만 적재하면**: 프리셋=과대청구 잔존(siz_preset 미전달→면적 ceiling), 사용자입력=면적행 dim_vals={CUSTOM} 매칭실패로 **0원 회귀**.
- 즉 **price_views(메타+price_simulate) + 위젯 양쪽 배선 추가**가 데이터 적재의 전제. 이 코드 변경은 §21 범위 밖(webadmin 코드 직접수정 금지)·별 트랙(§6 huni-widget/webadmin) + 인간 승인.

## ⑥ 인간 컨펌 필요사항
1. **Q-WIDGET-PRESET**(★모델 성립의 자): 실사 프리셋/사용자입력을 `siz_preset` 판별값으로 보내도록 위젯/price_views 계약 신설 합의(현 라이브 계약에 없음).
2. **Q-USERINPUT-SUB600**: 권위 매트릭스가 600mm부터인데 사용자입력 최소 200mm. 200~599 입력 가격(현 엔진=600 ceiling=12,000) 권위 확정.
3. **Q-SILSA-SHARE**: 4상품 동일 comp 공유=동일가 정합(권위 4상품 동일 확인됨) → 공식분리 불요 확정.

## ⑦ 판정·다음 단계
- **모델 D-2 = GO(데이터 모델 측면)**·재계산 검증 통과·ambiguous 0·회귀 0(위젯 계약 변경 전제 시).
- ★**적재 보류 권고**: 데이터만 단독 COMMIT 시 사용자입력 0원 회귀 → 위젯/price_views 계약 변경(siz_preset)과 **동반**해야 안전. Q-WIDGET-PRESET·Q-USERINPUT-SUB600 인간 확정 선행.
- GO 비준 시: dbm-validator 독립 재실측 → dbm-load-execution(프리셋 3행 INSERT + 52행 dim_vals UPDATE·백업·DRY-RUN·COMMIT) + 위젯/price_views 배선(별 트랙·인간 승인).

근거: `raw/webadmin/catalog/pricing.py`(L42-50·L82-99·L131-178)·`price_views.py`(L1581-1589·L1366-1367)·`silsa-l1.csv`·`06_extract/price-poster-sign-l1.csv`.
