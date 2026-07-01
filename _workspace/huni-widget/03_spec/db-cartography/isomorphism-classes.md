# isomorphism-classes.md — 위젯 복잡도 동형 클래스 (대표 1개 파일럿 → 전파)

> 파이프라인 ③' 컨버전 선행. §29 위젯클래스(scorecard-final.csv) 재사용 — 전수 재조립 금지.
> 동형 기준 = 위젯 렌더 형상(componentType 집합) + 가격 모델(공식형/면적/셋트/addon) + 캐스케이드 형태가 같으면 동형.
> 이번 산출은 **디지털인쇄(W-CASCADE)만 종단 파일럿** — 나머지 클래스는 대표 선정·전파 대상만 표기.

## 1. 동형 클래스 (§29 위젯클래스 재사용)

| 클래스 | 상품 수 | 위젯 형상 | 가격 모델 | 캐스케이드 | 대표 후보 |
|--------|---------|-----------|-----------|------------|-----------|
| **W-CASCADE** | 37 | size·material·print·process CPQ 옵션 + counter | 공식형(PRF_*) evaluate_price | material→process disable·도수→색수 | ★ **PRD_000041** (96.8%·golden OK) |
| W-AREA | 53 | dimension-matrix-input/area-input(가로×세로) + material | 면적 매트릭스 [siz_width×siz_height] | base 치수 clamp | (설계후확정 2 포함) 아크릴/실사 대표 |
| W-SET | 8 | 셋트 조립(표지+내지 sides) | evaluate_set_price | 구성원별 + 셋트 제본 | 책자(068~072) |
| W-SET(구성원) | 30 | 반제품(단독 미노출·셋트 멤버) | 구성원 공식 | — | (셋트 내부) |
| W-ADDON(부속) | 20 | addon 템플릿 그룹 | 템플릿단가/공식 | addon 가산 | (addon 템플릿) |
| W-FIX | 19 | 고정 옵션(고정가 by siz_cd) | 직접단가/고정 | 최소 | 스티커류 |
| TBD | 110 | (준비 미완·미적재·설계후확정) | — | — | (후속) |

> 합계 = 284상품(파일럿 분모). W-CASCADE는 디지털인쇄·엽서·카드·명함·라벨 등 가장 많은 분기(size+material+print+process+CPQ)를 가져 **대표 traverse가 전 분기를 커버**한다.

## 2. 디지털인쇄 W-CASCADE 대표 선정

**PRD_000041 스탠다드 쿠폰/상품권** 선정 근거:
- §29 완성률 **96.8%** (디지털인쇄 최상위)·등급 L3·widget_eligible=Y·golden "표본 라이브 PRICE>0 실측확인".
- 전 분기 traverse: 규격 2(option-button) · 도수 2(단면/양면) · 용지 4(select-box) · 후가공 4(finish multi: 오시/미싱/가변텍스트/가변이미지) · CPQ 옵션그룹 3 · 공식 PRF_DGP_A(인쇄+용지+코팅+후가공 10 components).
- frm 체인 완전(바인딩·단가행 OK)·PRICE≠0 골든 재현(`evaluate-price-contract.md` §3).

## 3. W-CASCADE 동형 전파 대상 (대표와 동형 입증)

PRD_000041과 동일 위젯 형상·공식 클래스(PRF_DGP_A 또는 동형 PRF_DGP_*)·동일 캐스케이드를 가진 디지털인쇄 L3 상품 — **매핑 규칙만 전파**(전수 재조립 금지):

PRD_000020(화이트인쇄엽서) · 021(핑크별색엽서) · 022(금은별색엽서) · 023(모양엽서) · 024(포토카드) · 025(투명포토카드) · 026(종이슬로건) · 027(2단접지카드) · 028(미니접지카드) · 029(3단접지카드) · 035(모양명함) · 036(미니모양명함) · 042(프리미엄쿠폰) · 043·044(인쇄배경지) · 045(인쇄헤더택) · 046(라벨/택) · 047(소량전단지).

**동형 검증 규칙**: (a) frm_cd가 PRF_DGP_* 계열 (b) 옵션그룹 = {인쇄·종이·후가공} 또는 부분집합 (c) option_items.ref_dim = {06도수, 03자재, 04공정} (d) 비규격 없음(nonspec_yn='N'). 하나라도 깨지면 새 클래스 분리 — 예: 별색(021/022)은 COMP_PRINT_SPOT 추가 차원(addColor), 모양(023/035)은 완칼 공정 추가 → 같은 W-CASCADE이나 어댑터가 addColor/모양 attb를 추가 운반(계약 필드는 이미 존재: addColor/attb).

## 4. 본 산출 범위

- ✅ 디지털인쇄 W-CASCADE 종단 파일럿(PRD_000041) — `digital-print/pilot-PRD_000041.md`.
- ◻ W-AREA·W-SET·W-ADDON·W-FIX = 클래스 식별·대표 후보까지(종단 파일럿은 후속 재호출 시).
