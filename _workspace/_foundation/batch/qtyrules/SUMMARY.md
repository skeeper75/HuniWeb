# 수량 체계 진단·교정 트랙 SUMMARY (2026-07-02 종결)

**결론: 전 상품(297)×전 사이즈(490) 수량 데이터 결함 0 도달.** 상세·결정은 `_workspace/huni-set-product/HANDOFF.md`(2026-07-02 오후 섹션)와 메모리 [[qty-system-audit-260702]] 참조.

## 트랙 흐름
1. `../qty_rule_audit_260702.py` → `../qty-rule-audit-260702.csv` — comp 레벨 107상품(TRAP_MIN 10·INFO_MAX 42)
2. `build_qtyrules.py` — 상품마스터 제작수량 권위 468레코드 추출(상품 214·사이즈 254)·채움 계획
3. `qty_diag2.py` — (상품×사이즈) 정밀 재스캔 + 역전 스캔 + 직접단가/bdl 축 (스냅샷 `_db2/`)

## COMMIT (전건 백업/undo/실화면 검증 — 되돌리지 말 것)
- 094 엽서북 min 1→2 · 097 떡메 min 3→6 (`../qtyrule-fix-260702.sql`)
- 065 스티커팩 단가행 min_qty 54→1 (세트당 장수 오키잉)
- 사이즈 수량규칙 49행 충전 (`qtyrules-fill-apply.sql` — 2→51행)
- 016 프리미엄엽서 max 2행 1,000→10,000 (`qty-diag2-fix-dryrun.sql` 기반·backup=`qty-diag2-backup-260702.txt`)

## 잔여 큐
- 미니보드(144)·미니배너(145) 수량축 이하/이상 컨펌 → `../CONFIRM-mini-qty-bands-260702.md` (답 (가)면 25행 재키잉)
- 박(FOIL) 6상품 최소수량 → 제약규칙 §31 (상품 min 인상 금지)
- 역전 4,071경계(`reversal-scan.csv`) → 위젯 절약배지 데이터 (결함 아님)
- 장패드(211) 수량규칙 미보유 (직접단가·저위험 참고)
