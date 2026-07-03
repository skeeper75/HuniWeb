---
paths:
  - "_workspace/huni-price-table-integrity/**"
  - "_workspace/_foundation/live-snapshot/**"
---

# §26 Harness: Huni-Price-Table-Integrity — 가격테이블 적재 무결성

권위 엑셀 가격테이블의 차원+전 셀이 라이브에 이 빠짐 없이 적재됐는지 결정론 배치 diff 진단(I1~I7).
스킬=`huni-price-table-integrity-orchestrator` (트리거: 가격테이블 무결성·미적재 셀·차원 누락·sparse grid).
산출=`_workspace/huni-price-table-integrity/`. 라이브 실측=`_workspace/_foundation/live-snapshot/`.
변경이력: 최신 2026-07-01 t_siz_pansu 신설+판걸이수 11건 교정+썬캡 3절 이관 COMMIT·도메인 규칙 12항 SOT 신설
(미마무리: 투명019 C트랙·3절 3상품·HOLD_BASIS32) → `_workspace/huni-price-table-integrity/HANDOFF.md`

> 전문 directive 아카이브: `.moai/_archive/CLAUDE-full-harness-2026-07-04.md` §26.
> 변경이력 서술은 이 파일이 아니라 하네스 `CHANGELOG.md`에 누적한다(이 파일은 최신 1줄 포인터만).
