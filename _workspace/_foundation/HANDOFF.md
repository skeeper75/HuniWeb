# 가격 파이프라인 세션 핸드오프 (최신 2026-06-30 10세션)

> 재시작 포인터. 활성 하네스=가격엔진 설계(§18)·가격테이블 무결성(§26)·가격 종단(§27).
> 권위=2엑셀(상품마스터260610·가격표260527). 엑셀=권위·라이브=감사대상·단가 verbatim.
> ★시트별 적재 표준절차=`huni-price-table-integrity/_batch/SHEET-LOAD-PLAYBOOK.md`.

## ★다음 시작점 (우선순위)

1. **디지털/제본 후속(사장님)**: ① 흑백 1도 POPT_000008/009 상품 연결(단가 적재됨·상품 미연결=손님 선택불가) ② 068~070 책자 표지/내지 5비목 누락(저청구)=§23 셋트.
2. **박 분기 2026-07-01 활성 후 시뮬레이터 e2e**(오늘은 base 공식·★내일 2026-07-01부터 박 분기 자동 선택·점진 활성). 활성 후 webadmin price-simulator로 6상품 본체+박 합계 1회 확인 권장.
3. **박영역 상한 CONFIRM (Q-FOIL-SIZE2·실무·적재 비차단)**: 027(170×220)·069/070(A4)은 트림이 대형격자(≤170) 초과. 박영역≤170이면 정확·>170 가능 시 위젯 박영역 입력상한 캡. 돈크리티컬 아님.

## ★완료(10세션 후반) — 전 19시트 미적재 가격구성요소 전수 재확인 (사용자 요청)

라이브 스냅샷 갱신(`snap_20260630_1603`·박류 7,168 반영) 후 전 19시트 결정론 재diff + 원리2 바인딩 필터:
- **진짜 미적재 가격구성요소 = 0건.** 인쇄상품 가격표 19시트 전 가격테이블 적재 완료(박류가 마지막).
- **출력소재 specialty 18행 = 가짜결함**(원리2 COMP_PAPER 바인딩 0·스티커용지 9종은 틀린 그릇·종이 6종은 미사용 BOM)·적재 금지. 8세션 "gap-0 파싱한계 false" 재확인.
- **아크릴 B02 투명1.5T 81셀 = 이미 적재됨**(COMP_ACRYL_CLEAR3T·mat_cd=MAT_000042·두께를 mat_cd로 구분·권위 81셀 verbatim 100% 일치). "매핑미상"은 grid_diff가 mat_cd 자동연결 안 한 가짜 unmapped. → **아크릴 잔여 종결.**
- 산출: `huni-price-table-integrity/_batch/MISSING-COMPONENTS-FINAL-260630.md`.

## ★완료(10세션) — 박류 전파 라이브 COMMIT (다음 시작점 #1 종결)

**라이브 COMMIT 성공**(7,220 INSERT·단일 트랜잭션·EXIT=0·`foil-prop-COMMIT.sql`). 사전 라이브 재실측으로
미적재 확인(LARGE comp 0건)→실행→사후검증 전 항목 통과:
- price_components 대형 박 3종(SETUP/PROC_STD/PROC_SPECIAL_LARGE·전부 PRICE_TYPE.03 FLAT)
- component_prices 단가행 **512/3328/3328 = 7,168**
- 분기공식 5종(PRF_DGP_E_FOIL·DGP_A_FOIL·NAMECARD_PEARL_FOIL·BIND_MUSEON_FOIL·BIND_PUR_FOIL)
- formula_components 38·바인딩 6(2026-07-01)·형제보호(PRF_DGP_A base 10상품 유지·042만 분기) 확인.
- undo `foil-prop-undo.sql` 보유. → **박 시트(§26 #11 박소형/#14 박대형) 종결·가격테이블 19시트 무결성 완료.**

## ★이번 세션(9세션) 한 일 — 박류 종단 적재 + 3번 잔여 종결

### 라이브 COMMIT 2건 (undo 보유)
1. **명함박 G6 1셀 교정**(COMP_NAMECARD_FOIL_S1/S2_STD 1000구간 63,000→64,000 권위 verbatim·undo `_batch/namecard-foil-g6-undo.sql`).
2. **박류 파일럿**(프리미엄명함 PRD_000031 소형): 신규 SMALL comp 3(SETUP/PROC_STD/PROC_SPECIAL)·**2,168 단가행**·PRF_NAMECARD_FIXED_FOIL 분기·031만 재바인딩(2026-07-01)·시뮬레이터+골든 e2e PASS. undo `pilot-load/foil-pilot-namecard031-undo.sql`.

### 박류 전파 6상품 — 빌드+검증 GO·COMMIT만 미실행(다음 시작점 #1)
대형 comp 3(7,168행)+5 분기공식(펄명함034/접지카드027·029/쿠폰042/책자069·070)·독립검증 R1~R6 GO(단가 7,168행 전수 재펼침 불일치0·골든10/10).

### 스티커 B02~B07: gap-0 확정(완료·조치 불요·파싱한계 false 신호)

## 이번 세션 핵심 결정 (relitigate 금지)

- ★**박 면적→등급 = flatten으로 C트랙 불필요**(사용자 off-grid 지적 정확·REV3 "면적→등급 엔진 미지원=C트랙" **무효화**): 등급을 적재 시점에 단가로 펼치면(flatten) 박가공비=`[proc_cd,siz_width,siz_height,min_qty]→단가` 1단 면적매트릭스→엔진 off-grid ceiling이 처리(아크릴 277행 동형·라이브 시뮬 판아크릴 79×85→ceiling 80×90 실증). 신규 테이블(t_prc_foil_area_grades) 불필요·가변사이즈 7상품 지금 적재 가능. → [[foil-flatten-ctrack-eliminated-260630]]
- ★**박가공비 prc_typ = .03 FLAT**(REV4 C-2): .02는 off-band 수량 과청구(q850→52,800÷800×850=56,100·정답52,800). codex+검증이 골든 사각지대(전 골든이 밴드경계라 못 잡음) 적발. .03=밴드 lookup+×qty0(pricing.py:203-204).
- **박 comp = 6개 분리**: 소형/대형 면적격자 겹침→통합 시 off-grid 틀린 셀(돈크리티컬·분리 필수). 일반/특수=통합 가능하나 추적성·ERR_AMBIGUOUS 회피로 분리.
- **박 공식 = 본체 직접합산**(nesting 스키마 불가=공식→공식 FK 부재·상품 공식 1개): 공유 공식은 박 대상 상품만 분기(PRF_*_FOIL)·형제 미오염. 명함박 PRF_NAMECARD_FOIL/접지카드 PRF_DGP_E 라이브 실증.
- **박 바인딩 = 2026-07-01 미래일자**(점진 활성·오늘 base·내일 박). 즉시 활성 원하면 적용일 조정.
- **동판비 proc_cd 게이트 필수**(codex 적발·REV3): 게이트 없으면 박 미선택 주문 동판비 silent 과금(pricing.py:99-111 NULL=와일드카드).
- **전체 가격구성요소 과분리 점검(127 comp)**: 위험 과분리 0·오적재 0·별색이 이미 모범 통합(proc_cd)·SAFE 병합 후보 3건(실익 Low)·진짜 할일=미바인딩 24건 연결(§7). 산출=`_foundation/price-component-conformance-oversplit-audit.md`.
- **webadmin 차원 에디터 정합**: 박 6 comp 전부 차원 누락0·동판비 수량NULL=수량무관(명함박 동판비 동형)·박공정 "크기(mm)" 상세 dim_vals 비움(siz_width/height 티어와 중복 회피).

## 건드리지 말 것 (라이브 COMMIT·undo 보유)
- **박 전파(10세션)**: 대형 박 3 comp·단가행 7,168·분기공식 5종(_FOIL)·formula_components 38·바인딩 6(2026-07-01)·undo `propagation/foil-prop-undo.sql`.
- 명함박 G6(64,000)·박 파일럿 SMALL comp(031·2,168행·PRF_NAMECARD_FIXED_FOIL·2026-07-01)·이전 세션 COMMIT 전부.

## 미해결/블로커
- **박영역 상한 CONFIRM**(027 170×220·069/070 A4·박영역≤170이면 정확·>170 위젯 입력상한 캡·적재 무관·실무 컨펌).
- 디지털 흑백 상품 노출·068~070 책자 저청구(사장님).

## 산출물 위치
- 박류 설계: `huni-price-engine-design/03_design/{engine-design-foil.md REV4·design-decisions-foil-rev2/3/4·webadmin-dim-editor-foil-fit·golden-cases-foil}`
- 파일럿(COMMIT 완료): `03_design/pilot-load/`(COMMIT-LOG.md)
- 전파(COMMIT 대기): `03_design/propagation/`(foil-prop-load.sql·undo·gate)
- 검증 GO: `04_validation/{pilot-foil-validation-gate·propagation-foil-validation-gate·offgrid-flatten-validation-foil}`
- 명함박 G6: `huni-price-table-integrity/_batch/namecard-foil-g6-*.sql`
- 전체 comp 과분리: `_foundation/price-component-conformance-oversplit-audit.md`
- 시트 무결성: `huni-price-table-integrity/_batch/ALL-SHEETS-summary.md`
- 메모리: [[foil-flatten-ctrack-eliminated-260630]]·[[price-component-unify-vs-split-criterion-260630]]
