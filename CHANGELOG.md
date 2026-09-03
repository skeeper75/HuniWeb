# Changelog

이 프로젝트의 주요 변경사항을 기록한다. 형식은 Conventional Commits 매핑을 따른다.

## [Unreleased]

### Added

- SPEC-PRICECOMP-001 트랙 A(아크릴·스티커·포스터/사인) — 가격표 code/name 기준 가격구성요소 신설 43건을 webadmin 실화면으로 등록. 권위 가격표(`docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx`) 코드·이름 그대로 그릇 43개를 새로 세우고 단가행 3,017건을 결정론 스크립트 생성표로 적재했다. (`.moai/specs/SPEC-PRICECOMP-001/progress.md` §E.2 M2·M3)

### Changed

- SPEC-PRICECOMP-001 트랙 A — 54개 대상 상품(판정 시각 기준 게시 위젯 보유분 아크릴 13·스티커 13·포스터 28. `acceptance.md` v0.5.2 분모 정정)의 가격 공식을 신설 그릇으로 재배선. 재배선 과정에서 발견된 회귀 4건(D-14 옵션그룹 스코프 누락·D-15 반칼 사이즈코드 불일치·D-17 현수막 인쇄격자 가로/세로 전치)을 화면 조작으로 교정하고 골든 재계산(141조합)으로 금액 차이 0을 확인했다. (progress.md §E.2 M4·M5)

### Fixed

- SPEC-PRICECOMP-001 — 포스터 8상품(세로 1,200mm 초과 구간)과 현수막 2상품(`PRD_000138`·`PRD_000139`)에서 이번 재배선 작업 자체가 만든 가로/세로 축 전치 결함을 교정(D-11, D-17). 아크릴미니파츠(`PRD_000163`)의 placeholder 단가(10,000원)를 권위 1.5T 격자값(6,320원)으로 교정(C-3).

### Notes

- SPEC-PRICECOMP-001은 트랙 A(3상품군·신설 43)와 트랙 B(공정·후가공·신설 8)로 구성된 Tier M 작업이다. 이번 sync는 **트랙 A만** 완료·문서화한다 — 트랙 B(P1~P6)는 착수 전이다.
- 라이브 DB 직접 쓰기 0건. 전 작업은 webadmin 실화면 조작(누계 106건)으로 수행했고, `use_yn` 상태 전환은 실무진 역할 재정의에 따라 전건 되돌림 상태다(옛 그릇 34개 · `PRF_POSTER_FIXED` 모두 `use_yn=Y` 복귀).
- 근거: `.moai/specs/SPEC-PRICECOMP-001/progress.md` §E.3 Run-phase Audit-Ready Signal · 실무진 인계 문서 `_workspace/price-setup/HANDOFF-TO-STAFF-260903.md`.
