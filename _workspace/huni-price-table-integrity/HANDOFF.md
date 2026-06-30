# Huni-Price-Table-Integrity (§26) HANDOFF — 차원 정합 진단·교정

최종: 2026-06-30 차원정합 적대적 진단기(Phase 2b) 구축 + 전수 진단 + 라이브 교정 9건 COMMIT.

## 다음 시작점 (정확한 다음 액션)

**가변 단가행 판별차원 교정** (027/028/029 공통·신규 발견·turnkey 후보):
- `COMP_PP_VARTEXT_1EA`·`COMP_PP_VARIMG_1EA` 단가행이 (proc_cd, min_qty)에 25000/35000/45000 **여러 값** → 동시매칭(ambiguous) → 엔진 합산 제외 → 가변 가산 0.
- 권위(상품마스터 260610 가변텍스트/이미지 "1·2·3개")로 **판별차원**(가변 개수 = 어느 컬럼?)을 확인해 단가행에 채우면 작동.
- 검증: `dim_conformance.py` 재진단 + `_foundation/batch/lib_huni.py` HuniSim으로 027 가변 선택 시 증분.
- ★진단가 B의 "가변 배선하면 작동" 주장은 simulate 미검증 오류였음(배선만으론 안 됨). 이미 PRF_DGP_E에 배선됨(무효).

## 미해결 / 블로커

- **가변 동시매칭**(027/028/029) — 위 다음 시작점.
- **박 엔진 미지원**(027/028/029 박 전부 가산 0) — 면적→등급 박을 엔진이 미지원(C-track 개발 대기). 데이터로 못 고침. 028 E_FOIL 공식 바인딩도 박엔진 구현 후에 의미(지금 추가 무효).
- **아크릴 부속 미청구**(147~154) — 6상품이 본체전용 공식 바인딩 + 부속 옵션 미노출. §18 CPQ 재설계 + §7 적재 + 엔진 C-track 다단계 패키지. 명세=`acryl-matfix-260630.md`.
- **REVIEW 나머지 25건** — 대부분 분담 FP. 기추적(책자셋트 §27·현수막타공 위젯·족자 HOLD-C). 신규 actionable 없음(가변 G는 위에서 처리).
- agents/`hpti-dimension-conformance-inspector.md`는 **gitignored**(로컬만) — 다른 머신 세션에선 재생성 필요.

## 이번 세션 결정 (relitigate 금지)

- **차원정합 진단기 신설**(§26 Phase 2b): use_dims↔component_prices 충전↔상품 옵션수단 3자 조인. 에이전트 `hpti-dimension-conformance-inspector` + 스킬 `hpti-dimension-conformance-audit` + 결정론 `scripts/dim_conformance.py`(토큰0).
- **★핵심 알고리즘 = union 분담 흡수**: 같은 차원 쓰는 전 component 충전값 UNION 후 avail 비교(등급 MGA/MGB·역할 분담 흡수). 없으면 FP 폭증(221→41).
- **★도구 가드**: ① mat_typ 분리(원판 .03 vs 부속 .07 — 아크릴 FP 진원) ② REFDIM에서 도수(.06)→print_opt 과대환원 제거. → MISSING-HIGH 12→0.
- **★엔진 규칙 정정[HARD]**: pricing.py `_row_matches`는 use_dims 무관·단가행 채워진 컬럼을 매칭. use_dims는 UI 드롭다운 노출(prod_dims)만. → UNDECLARED 위험은 silent 가산이 아니라 ① 미노출→견적불가 ② 상수 컬럼 매칭 깸→저청구.
- **★차원정합 사각**: "공정 미등록(노출 부재)"은 못 잡음(028 빈공정). 별 신호 = 상품 공정 0건.
- 상세 = 메모리 [[dimension-conformance-3face-diagnosis-260630]].

## 건드리지 말 것 (confirmed-good)

라이브 COMMIT 9건(되돌리지 말 것):
1. 봉투 MAT_169 20행(레자크줄무늬=체크 동일단가) · 2. 132 레더 4행 · 3. 163 미니파츠 1행 · 4. 135 족자 293→294 재지정+A1 · 5. 031 고아옵션 2 논리삭제 · 6. 032 코팅 use_dims+print_opt_cd(견적0→11000) · 7. 124 린넨 proc_cd→NULL · 8. 027/029 접지 192행+가변배선4 · 9. 028 공정 12개 등록(접지 +52000).
- 진단기 스크립트·스킬·에이전트·도구 가드 = 확정.

## 040 화이트인쇄명함 (세션 초반·완료)
자재 4색(화이트 제외·도메인+레드프린팅 BCSPWHT 확증)·클리어 통합 component로 이미 작동(이중과금 가드). 상세 = 메모리 [[whiteprint-material-4color-unified-spot-component-260630]].
