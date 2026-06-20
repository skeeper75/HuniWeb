# Huni-Price-Engine-Design 하네스 — HANDOFF

> CLAUDE.md §18 · 갱신 2026-06-20 · 종단 2건 GO(디지털인쇄·아크릴)

## 다음 시작점

두 상품군 파일럿이 GO로 닫혔다. **DB 미적재** 상태. 다음 중 인간 승인 필요:

1. **실 적재** (돈크리티컬·라이브 COMMIT·인간 승인 필요)
   - 디지털인쇄: 전 고정가형 `prc_typ` `.01→.02`(단가행 값 불변·멱등·백업) → `dbm-axis-staged-load`/`dbm-load-execution`.
   - 아크릴: 본체 활성 16~17상품 `product_price_formulas` 바인딩(신규 mint 0·PRF_CLR_ACRYL/COROTTO 재사용) → source=NONE 해소.
2. **다음 상품군 동형 전파**
   - **면적매트릭스 동형**: 실사·현수막(아크릴과 동형 클래스 → 빠른 전파).
   - 미커버 구조: 스티커·책자·캘린더(세트/반제품) 등.

## 진행 현황 (종단 2건)

| 상품군 | 계산방식 | 게이트 | codex |
|--------|----------|--------|-------|
| 디지털인쇄 | 원자합산형+고정가형 | NO-GO→보정→**재게이트 GO** | NO-GO 지지(medium) |
| 아크릴 | 면적매트릭스형 | **첫 게이트 GO**(보정 0) | GO 지지(**high**) |

## 미해결 / 블로커

**디지털인쇄:**
- 박 동판비(SETUP) 정액 처리법 — 차선A(qty=1 격리·권장) vs 차선B(정액 prc_typ 신설·개발자 백로그).
- 인쇄면/페이지/소재 comp 통합(CV-3) 단가행 병합 적재 미실행.
- G-7 옵션→차원 자동주입 미연결(option_items 0행).

**아크릴 컨펌큐(가격 무영향·비차단):**
- CA-1 미러 별 공식 vs 소재옵션 합류(합류 시 mat_cd 판별차원 선결·돈크리티컬) — dbm-price-arbiter.
- CA-4 후가공 가산 개당/×수량(추측 적재 금지·디지털 동형 위험) — dbm-price-arbiter.
- CA-2 코롯토 동형 컨펌·CA-3 카라비너 형상 opt_cd 채번·신설(LOW)·CA-5 두께 UI→mat_cd 주입.

**공통:**
- webadmin pricing.py = read-only(엔진 코드 직접 수정 금지·개발자 GitHub 배포).

## 이번 세션 결정 (relitigate 금지)

- **effort 상향**: 프로젝트 `effortLevel` medium→high(글로벌과 일치). `codex-review.sh`에 4번째 인자 effort 추가(`-c model_reasoning_effort=<effort>`·하위호환). 아크릴 codex는 effort high로 호출(세션 헤더 confirm).
- **아크릴 = 면적매트릭스형 단일**(카라비너만 고정가). 출력매수 곱셈사슬 없음(디지털과 결정적 차이).
- **★디지털 ×qty/silent 이중합산 결함, 아크릴엔 구조적 부재** — 면적단가=개당 완제품가(묶음총액 아님)·min_qty=1 전건(÷1=개당×수량)·공식당 comp 1배선(합산대상 1개=이중합산 불가). 라이브 confirm(CLEAR3T 165행 min_qty=1·MIRROR 52행 NULL). 디지털과 단가 의미 정반대.
- **G-A1**: 본체 활성 16~17상품 미바인딩(라이브 바인딩 PRD_000146 1건뿐)→PRF_CLR_ACRYL/COROTTO 재사용(신규 mint 0). gap-board "29"는 비활성 포함 광역.
- **W=가로(앞)·H=세로(뒤)·가격축 권위=siz_nm WxH·work사이즈 블리드 가산 절대 금물**(dbmap round-23 돈크리티컬·비대칭 50×30=3,800 라이브 실측).
- **신규 가격축 0건**(rpmeta AC distinct #19 부결 정합·경쟁사 흡수 전부 기존 그릇 수용).

## 건드리지 말 것 (confirmed-good)

- **단가행 값 전부 verbatim 보존**(디지털=prc_typ 플래그만·아크릴=바인딩만·값 0줄 변경).
- 재게이트/게이트 GO 산출: `04_validation/{regate-verdict-digitalprint,gate-verdict-acrylic,recompute-log-acrylic}`(골든 재현).
- codex reconcile: `05_codex/{codex-reconcile-digitalprint,codex-reconcile-acrylic}`(독립 합의).
- 권위 심의: `03_design/pricetype-remediation-arbitration.md` §9(가격표 인용 verbatim).
