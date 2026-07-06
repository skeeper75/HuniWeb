# 박 차원 교정 = 완료 (소형·프리미엄명함 파일럿) — webadmin UI 실적재본

> 260706~07 완료. 근거: preflight + 권위 가격표 260705 후가공_박(소형) + 라이브 실증 + pricing.py 엔진 추적 + 시뮬레이터 실화면.
> [HARD] 라이브 DB 직접 쓰기 금지 — 전부 webadmin UI(gstack browse) 엔드포인트로 적재. 값 무변경(순수 re-key).

## 0. 문제의 실체 (엔진 추적 + 라이브 실증)
- **지니 정본**: `siz_width`/`siz_height`=**소재(자재) 전용 차원**. 박 가로/세로를 여기 넣으면 소재와 충돌.
- 박 가공비가 siz_width/height **컬럼**에 있었고, prcs_dtl_opt="크기"는 **price_dim 없음·dead input**.
- 결과: 손님 박 크기가 어디에도 안 닿음 → 시뮬레이터가 박 가공비를 **최소tier(10×10=12,200)로 저청구** 또는 제외.
  (라이브 실증: 크기 미입력 시 STD=12,200 고정; siz_cd 없는 상품이라 제품치수 폴백도 없음.)

## 1. 정답 = 새 차원(dim_vals 가로/세로)으로 값 이전 (지니 원안·오시 줄수 동형)
- 엔진 경로(pricing.py 709·103): 손님 `detail{가로,세로}` → `sel[가로]/sel[세로]` 직접주입 → dim_vals **정확매칭**.
- **type=integer 필수**: `_norm(v)=str(v)`. number면 40.0 저장→"40.0"≠손님"40" 매칭실패. integer면 40→"40" 일치(오시 동형).
- price_dim:siz_width 방식은 **폐기**(소재 차원 재사용=지니 금지). 순수 dim_vals.

## 2. 실적재본 (완료 — webadmin UI)
| # | 대상 | 조치 | 화면/엔드포인트 |
|---|---|---|---|
| A | PROC_000033 prcs_dtl_opt | "크기" → 가로·세로(**integer**·mm·price_dim 없음) | `master/proc` 상위공정 편집(iframe change form) |
| B | COMP_FOIL_PROC_SMALL_STD 1620행 | siz_width→dim_vals["가로"]·siz_height→["세로"]·siz 컬럼 NULL | `price-viewer/comp/<comp>/save` full-sync(결정론 페이로드) |
| C | COMP_FOIL_PROC_SMALL_SPECIAL 540행 | 동일 + use_dims proc_grp:PROC_000033 **보강** | 동상 |
| D | 양 comp use_dims | siz_width/height **제외** → `[proc_cd, min_qty, proc_grp:PROC_000033]` | `catalog/tprcpricecomponents/<comp>/change` (OrderedDimsWidget) |
| — | COMP_FOIL_SETUP_SMALL | **무변경**(proc_cd만·flat 5000·정상) | — |

## 3. ★교훈: 적재 순서 (재발방지)
- **그리드 저장(B/C) → use_dims siz 제거(D) 순서 필수.** 역순이면 자연키 붕괴로 구 행이 collapse돼
  full-sync가 orphan(empty dim_vals)만 남김 → ERR_AMBIGUOUS 위험. (SPECIAL에서 발생·복구: siz 임시복원→재저장→siz 재제거.)
- STD는 저장 먼저라 clean. SPECIAL은 use_dims 먼저 바꿔 orphan 468 발생 → siz 복원 후 재저장으로 전삭제.

## 4. 결정론 페이로드 (LLM 전사 금지)
- `tmp/foil-remap/{comp}.payload.json` = 라이브 현행에서 생성(siz_width→가로·siz_height→세로·값·note verbatim).
- `tmp/foil-remap/browser/{comp}.save.js` = /save 엔드포인트 POST(CSRF). 백업=`tmp/foil-remap/backup/foil-small-BEFORE-*.json`(2168행).
- 예측 기대값표=`EXPECTED-FOIL-SMALL.json`(504행·권위 B02/B03).

## 5. 검증 = 통과 (시뮬레이터 실화면·API)
| 케이스 | 박 가공비 | 권위 B03 | 판정 |
|---|---|---|---|
| 일반 금유광 가로40×세로40·200 | **17,800** | 구역D | ✅ |
| 일반 가로40×세로80·200 | 19,200 | 구역E | ✅ |
| 특수 홀로그램 가로40×세로40·200 | 22,700 | 특수D | ✅ |
| 특수 가로10×세로10·200 | 14,300 | 특수A | ✅ |
- **실화면**: 박종류 선택→가로/세로 입력창 등장→최종가 31,800(완제품9000+동판5000+박17800)·**제외 0**. [HARD] 종료척도 달성.

## 6. 남은 일 (후속·이번 범위 아님)
- **박크기 상품별 min/max 제약**: 제약엔진(VAR_KEY_MAP)에 siz_width/height 없음·범위 규칙유형 없음 → **개발 요청 필요**(§31/개발문서).
  현재는 격자 상한(가로40/세로80) 초과 시 엔진 자동 ERR_ABOVE_MAX만 방어. 상품별 상한(명함 세로≤50 등)은 코드 확장 대기.
- **dim_vals 정확매칭 vs 연속입력**: 손님이 격자 밖(35mm) 입력 시 no_match. 위젯이 tier(10/20/40) 제시/올림 필요(프런트 레이어).
- **커버리지 갭**: 일반박 펄박(PROC_000045)·특수박 백박(PROC_000046) 단가행 누락(권위 대비). 가로10세로10 과적재(권위 공란).
- **대형 박 6 comp 전파**: LARGE_STD/SPECIAL·SETUP_LARGE 동형(단 대형은 siz 컬럼 사용 여부·동판 구간별 확인). 형압 PROC_000050도 동형.
