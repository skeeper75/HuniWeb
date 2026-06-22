# Huni-RE-Verify — 역공학 재검증 + 런타임 동등성 검증 하네스 (§22)

RedPrinting 위젯/SDK 역공학을 **다시 하지 않고**, 기존 역공학·재구성 위에 *런타임 동등성 검증 레이어*를 얹어
**"역공학한 코드가 실제로 동작/재현되는가"** 를 라이브 RedPrinting을 기준 오라클로 한 차등 테스트로 입증한다.
codex-cli high 독립 2차 교차검증으로 환각을 가드. 검증+교정명세까지(실 수정은 §6 위임·인간 승인).

## 권위 문서 (시작 전 필독)
- `_meta/re-methodology-research.md` — 방법론 스택·게이트(V-PRICE/WIDGET/EDITOR)·함정(소스 인용).
- `_meta/codex-high-spec.md` — codex high 운영(함정 패치·폴백·reconcile).

## 실행
`huni-re-verify-orchestrator` 스킬(트리거: "역공학 코드 동작 검증", "RedPrinting 위젯 동등성 검증", "차등 테스트" 등).
**파일럿 = 가격계산 API**(get_ajax_price_vTmpl). GO 후 widget·editor 동형 확대.

## 디렉토리
- `01_inventory/` — 자산 인벤토리·역공학 계약·검증대상 매니페스트·골든 캡처 계획·재사용 맵
- `02_golden/` — 라이브 골든 마스터(HAR/JSON·시나리오당 1·비밀 [REDACTED])
- `03_price/` `04_widget/` `05_editor/` — 서브시스템 검사 보드·셀
- `06_codex/` — codex high reconcile
- `07_gate/` — GO/NO-GO verdict·교정명세·종단 골든 추적

## 재사용 (재구축 금지)
`_workspace/huni-widget/`(04_build 재구성·05_qa 동등성게이트·07_parity) · `raw/widget_monitor/local`(읽기전용 프록시·Playwright 캡처) · `docs/reversing`(역공학 계약·디옵) · `hqv-codex-cross-verify/scripts/codex-review.sh`(effort=high).

## 안전 [HARD]
라이브 읽기전용(주문/결제/장바구니 COMMIT/폼submit/에디터 저장 0)·DB 미접속·비밀값은 `.env.local`에만(골든/로그/스크린샷 [REDACTED])·생성≠검증·오라클=라이브·PRICE=0=결함신호·codex 주장=가설.
