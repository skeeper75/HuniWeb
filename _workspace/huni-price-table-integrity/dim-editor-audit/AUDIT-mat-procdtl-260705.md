# 가격구성요소 단가표 편집 차원 정합 감사 — 자재(소재) · 공정상세옵션 JSON (260705)

> 목적: 가격구성요소MD의 `사용차원`이 인쇄상품 가격표 차원과 일치해 **단가표 편집**이 가능한지,
> 특히 ① 자재(소재) 하위구분 ② 공정상세옵션(가로×세로) JSON 이 제대로 등록됐는지 전수 감사.
> 라이브 읽기전용 SELECT. 교정 실행은 인간 승인 후 별도 트랙.

## 0. 데이터 모델 (설계 의도 확인 — 사용자 이해 정확)

| 화면 차원 | DB 저장 | 성격 |
|---|---|---|
| 사이즈 | `t_prc_component_prices.siz_cd` | 이산 코드 |
| 공정 | `.proc_cd` (+ `use_dims`의 `proc_grp:PROC_xxx`) | 이산 코드(그룹) |
| **사이즈가로(구간)** | `.siz_width` (numeric) | **자재(소재)의 물리 크기 구간** — 면적매트릭스 |
| **사이즈세로(구간)** | `.siz_height` (numeric) | **자재(소재)의 물리 크기 구간** — 면적매트릭스 |
| 판형사이즈 | `.plt_siz_cd` | 이산 코드 |
| 인쇄옵션 | `.print_opt_cd` | 이산 코드 |
| **자재** | `.mat_cd` | 이산 코드(소재) |
| 옵션코드 | `.opt_cd` (+ `opt_grp:OPT_xxx`) | 이산 코드(옵션그룹) |
| 코팅면수 | `.coat_side_cnt` | 정수 |
| 묶음수 | `.bdl_qty` | 정수 |
| 수량구간 | `.min_qty` (항상 마지막) | 구간 |

- `use_dims` = `t_prc_price_components.use_dims` (jsonb 배열). 단가표 편집 그리드 컬럼이 이 선언으로 구성됨.
- **공정상세옵션** = `t_proc_processes.prcs_dtl_opt` (jsonb). shape=`{"inputs":[{key,type,unit,...}]}`.
  일부는 `price_dim` 바인딩 존재(예: PROC_000013 코팅 → `price_dim:coat_side_cnt`) → **공정상세옵션이 가격차원과 연결되는 기제는 이미 존재**.

## 1. 전수 분포 (142개, del_yn=N)

구성요소유형(comp_typ_cd): 완제품비 85 · 후가공비 29 · 인쇄비 17 · 박형압비 4 · (미지정) 4 · 코팅비 2 · 용지비 1.

`use_dims` 차원 사용 빈도: min_qty 96 · siz_cd 51 · proc_cd 30 · opt_cd 28 · **siz_width/height 22** · **mat_cd 13** · print_opt_cd 13 · plt_siz_cd 7 · bdl_qty 3 · coat_side_cnt 2.

## 2. [결함 A] 자재(소재) 차원이 구성요소 코드에 흡수됨

**핵심**: 자재 마스터에는 소재 하위구분이 **이미 등록**돼 있으나, 가격구성요소가 이를 `mat_cd`
차원으로 연결하지 않고 **소재별로 구성요소를 쪼개는 방식**으로 등록 → 단가표 편집에서 소재 차원 안 보임.

### 2-1. 아크릴 (사용자 지적 사례)
| 구성요소 | 단가행 | mat_cd 차원 | 자재 마스터 |
|---|---|---|---|
| COMP_ACRYL_CLEAR3T (투명) | 277 | ✓ 2종(MAT_000042 1.5mm·MAT_000043 3mm) | 등록됨 |
| COMP_ACRYL_MIRROR3T (미러) | 81 | ✗ 없음 | **MAT_000614 아크릴(미러) 3mm 존재하나 미연결** |
| COMP_ACRYL_COROTTO | 36 | ✗ 없음 | — |

→ 같은 아크릴군인데 투명만 mat_cd 사용, 미러/코롯토는 코드에 흡수. **인코딩 불일치**.

### 2-2. 실사/포스터 (14개) — 소재마다 별도 구성요소
COMP_POSTER_ADH_CLEAR_PVC · ARTPAPER_MATTE · BANNER_MESH · BANNER_NORMAL · CANVAS_FABRIC ·
CANVAS_HANGING · LINEN_FABRIC + [레거시] 7종(ADH_WATERPROOF_PVC · ARTFABRIC_GRAPHIC ·
ARTPRINT_PHOTO · LEATHER_ARTPRINT · MESH_PRINT · TYVEK_PRINT · WATERPROOF_PET).
- 모두 siz_width/height(면적매트릭스)만 사용, mat_cd 없음.
- 자재 마스터엔 소재 등록됨: 메쉬(MAT_000183/606) · 캔버스(MAT_000185/608) · 린넨(MAT_000184/607) ·
  현수막천(MAT_000182/605) 등. → **소재는 있으나 가격차원 미연결**.

### 2-3. 면적매트릭스인데 mat_cd 없는 구성요소: 21개
아크릴 2 · 박 5 · 실사/포스터 14. (박은 공정 이슈=결함 B)

### 2-4. 정상적으로 mat_cd 차원 쓰는 구성요소: 13개
COMP_PAPER(86) · COMP_NAMECARD_PREMIUM(14) · COMP_STK_PRINT(15) · COMP_GANGPAN_PRINT(6) ·
COMP_POSTER_FOAMBOARD_BOARD(4) · COMP_POSTER_FOMEXBOARD_BOARD(4) · COMP_NAMECARD_PEARL(4) ·
COMP_NAMECARD_STD(5) · COMP_ENV_MAKING(3) · COMP_ACRYL_CLEAR3T(2) · COMP_NAMECARD_COAT(2) ·
COMP_STK_TATTOO(2) · COMP_POSTEROPT_PET_BANNER_STAND_SEL(2).
→ 폼보드/포맥스보드는 (보드칼라/두께 × 사이즈)를 mat_cd로 씀 = **아크릴/실사가 따라야 할 정답 패턴**.

## 3. [결함 B] 공정상세옵션(가로×세로) JSON 미비

- **138 공정 중 16개만 prcs_dtl_opt JSON 보유(12%)**.
- **박 (PROC_000033)**: JSON = `{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}` — 단일 크기 입력.
  **가로×세로 구간 차원 아님**. 박 5개 구성요소는 가로×세로를 use_dims의 siz_width/height로 **직접**
  등록(공정상세옵션 우회). 형압(PROC_000050)도 동일하게 단일 "크기"만.
- **박 구성요소 use_dims 불일치**: SMALL_STD만 `proc_grp:PROC_000033` 참조. LARGE_STD/LARGE_SPECIAL/
  SMALL_SPECIAL/SETUP_LARGE/SETUP_SMALL은 proc_grp 참조 없음(proc_cd 개별만).
- JSON 없는 공정 차원 구성요소: 디지털인쇄(PROC_000001) · 별색(PROC_000007) · 접지 4종(PROC_000056) · 귀돌이(PROC_000026).

## 4. 개선/보완/수정/확장/추가 후보

### A. 자재(소재) 차원
- **A-1 (통합·권장)**: 소재 하위구분을 `mat_cd` 차원으로 통합. 아크릴 투명/미러/코롯토 → 1 구성요소 + mat_cd;
  실사 14 → 소재 차원. 폼보드/포맥스보드 패턴 그대로. → 단가표 편집에서 소재 컬럼으로 편집 가능.
- **A-2 (보강·경량)**: 구성요소 분리는 유지하되 각 구성요소 단가행에 mat_cd를 채워 소재를 명시(추적성만 확보).
- **A-3 (마스터 확인)**: 미러아크릴(MAT_000614) 등 이미 등록된 소재를 구성요소에 연결. 누락 소재는 등록 보강.

### B. 공정상세옵션 JSON
- **B-1 (박 가로×세로 정식화·권장)**: PROC_000033 prcs_dtl_opt에 가로×세로 구간을 JSON 차원으로 등록
  (PROC_000013 코팅의 `price_dim` 바인딩 패턴 참조). 박 5개 use_dims에 proc_grp 일관 부여.
- **B-2 (커버리지 확장)**: JSON 없는 공정(디지털/별색/접지 등)의 상세옵션 정합 보강.

## 5-A. 배선 실측 — 통합 설계에 결정적 (260706 보강)

### 아크릴 (사용자 지적 사례 재프레이밍)
- **COMP_ACRYL_CLEAR3T(투명)**: 아크릴 굿즈 8공식 공유(뱃지·집게·머리끈·키링·마그넷·명찰·스마트톡 +
  PRF_CLR_ACRYL). mat_cd=**투명 아크릴 두께**(MAT_000042 1.5mm·MAT_000043 3mm) — 투명 vs 미러 구분 아님.
- **COMP_ACRYL_COROTTO**: 자기 공식 PRF_COROTTO_ACRYL(상품 PRD_000164 아크릴코롯토) 전용. 코롯토=상품형태(자재 아님).
- **COMP_ACRYL_MIRROR3T(81행)**: **어느 공식에도 미배선 = 죽은 고아**. 실제 미러 상품(PRD_000143
  미러아크릴스티커)은 별도 완제품가 **COMP_POSTER_ACRYLSTK_MIRROR**로 가격 산출.
- 결론: 아크릴의 투명·미러는 **다른 가격모델**(굿즈 인쇄가공비 vs 스티커 완제품가)이라 한 mat_cd 차원 병합
  부적합. 아크릴 조치 = ① MIRROR3T 고아 tombstone(use_yn=N/del_yn=Y) ② 투명/코롯토는 별도 상품형태로 유지.

### 실사/포스터 14개 = 통합이 깨끗한 진짜 파일럿
- 전부 동일한 **완제품가 면적매트릭스(siz_width×siz_height)** 모델, 소재만 다름.
- 소재별 1구성요소 = 1공식(대체로 1:1): BANNER_NORMAL→PRF_POSTER_BANNER_N(81), BANNER_MESH→_M(48),
  ARTPAPER→(39), LINEN→(52), ADH_CLEAR→(52), CANVAS_FABRIC→(52, 4공식 canvas/mesh/leather/tyvek 공유).
- 소재 자재 마스터 기 등록: 메쉬 MAT_000183 · 캔버스 MAT_000185 · 린넨 MAT_000184 · 현수막천 MAT_000182 등.

## 6. 교정 설계 명세 (승인 대기 — 실행 금지)

### B-1. 박 가로×세로 공정상세옵션 JSON 정식화 (contained·먼저 실행 추천)
- 대상: `t_proc_processes.prcs_dtl_opt` (PROC_000033 박, PROC_000050 형압).
- 현재: `{"inputs":[{"key":"크기","type":"number","unit":"mm"}]}` → 단일 크기.
- 목표: 가로×세로 구간 차원을 price_dim 바인딩으로 명시(PROC_000013 코팅 `price_dim` 패턴).
  예: `{"inputs":[{"key":"가로","type":"number","unit":"mm","price_dim":"siz_width"},
       {"key":"세로","type":"number","unit":"mm","price_dim":"siz_height"}]}`.
- use_dims 일관화: 박 6구성요소(LARGE/SMALL × STD/SPECIAL + SETUP_LARGE/SMALL) 모두 `proc_grp:PROC_000033`
  참조 부여(현재 SMALL_STD만). **단가행·가격값 무변경**(메타 등록만) → 돈영향 0·저위험.

### A-1. 실사/포스터 소재 mat_cd 차원 통합 (파일럿 = 실사, 아크릴 제외)
- 목표모델: 소재별 분리 구성요소 → **1 완제품가 구성요소 + mat_cd 차원**(면적매트릭스 유지).
  use_dims=`["mat_cd","siz_width","siz_height","min_qty"]`. 폼보드/포맥스보드 정답 패턴 동형.
- 이관: 각 소재 구성요소의 단가행을 생존 구성요소로 이관하며 mat_cd=해당 소재코드 채움(**단가값 verbatim**).
- 배선: 소재별 공식(PRF_POSTER_*)을 생존 구성요소로 재배선(또는 상품별 mat 선택으로 환원).
- 게이트: 골든 재현(이관 전후 견적 동일)·이중합산 0·미배선 고아 0. [레거시] 7종은 use_yn 실측 후 tombstone 판정.
- **주의**: 돈 크리티컬·다상품 배선 변경 → 반드시 1소재 파일럿(예 일반현수막)→검증→동형 전파.

### A-3. 아크릴 정리
- COMP_ACRYL_MIRROR3T 고아 tombstone(단가행 81 보존 백업 후 use_yn=N). 투명/코롯토 현행 유지.

## 5. 게이트/원칙
- 라이브 읽기전용. 실 COMMIT/단가행 적재/JSON 등록 = 인간 승인 + webadmin 실화면 확인 후.
- 권위 = 상품마스터 + 인쇄상품 가격표 엑셀. 단가값 verbatim(날조 금지).
- 생성≠검증: 교정 명세는 §26 게이트(I1~I7) 또는 독립 재실측으로 확정.
