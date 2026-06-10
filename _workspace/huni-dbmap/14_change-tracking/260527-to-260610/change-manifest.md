# 변경 매니페스트 (감사본) — 상품마스터 260527 → 260610

round-10 변경추적. 행 단위 추적 권위 = `change-manifest.csv`(527행). 본 문서는 사람이
읽는 서사 요약. 적용 종착점 = **검증된 델타 + 롤백전용 DRY-RUN**(실 COMMIT은 인간 승인).

## 0. 한눈 요약

| 지표 | 값 |
|------|----|
| 시트 | 13 (추가/삭제 0) |
| 상품 ADDED / REMOVED / 재명명 | 0 / 0 / 0 |
| MODIFIED 셀 | 527 (HIGH 486 · LOW 41) |
| block_resized | 1 (아크릴미니파츠 −16행) |
| **apply_class** | **ESCALATE 526 · GAP 1 · UPDATE 0 · INSERT 0 · NO_OP 0** |
| 자동 적용 가능 UPSERT | **0건** |

> **핵심 결론**: 이번 버전쌍의 변경은 전부 ① 차원행(size)→CPQ 옵션레이어 **재분류**
> 또는 ② 변형행 감축 또는 ③ 범례 텍스트다. **이미 적재된 스칼라 컬럼을 단순
> 갱신(UPDATE)하는 변경은 0건**이다. 따라서 멱등 델타 UPSERT 자동 생성분은 0이고,
> 모든 변경은 escalate(CPQ 옵션레이어 설계·논리삭제 판단) 또는 GAP(적용대상 없음)다.
> 이는 회피가 아니라 **정직한 평결** — 기계적 size 삭제는 적재된 size/price 사슬을
> 파손하므로 금지(schema-design-intent-first).

## 1. 변경 군집 (전→후)

### A. 굿즈파우치 — size → option 컬럼 마이그레이션 (448셀 = 224쌍, 58/86 상품)
- 패턴: `사이즈(필수)` 셀값 → 빈값, 같은 행 `상품(옵션)` 빈값 → 그 값. **순수 쌍이동**(타 컬럼 변경 0).
- 예: 클립보드 `A5용 (164 x 230 mm)`이 size→option. 레더라벨제작 102쌍(레더 15x30mm, 삼성(갤럭시S20) 등 기종/규격).
- 라이브 현실: 이 값들이 `t_prd_product_sizes`에 **size로 적재**돼 있음(예 레더라벨제작 PRD_000280 = 레더15x30/레더20x40/레더30x50 3행). 신규 권위는 이를 **CPQ 옵션**으로 본다.
- **apply_class = ESCALATE** → `dbm-cpq-option-mapping`(L2) 설계 필요. 전역 옵션레이어
  거의 미적재(option_items 18=silsa만). 기계적 size 삭제 금지.

### B. 스티커 — 합판도무송스티커 커팅옵션 클리어 (37셀)
- `커팅(옵션)` 텍스트(원형10mm(8EA)…) 전부 빈값. 라이브는 커팅을 **size로 적재**
  (정사각NxN(EA) 37행), 커팅 옵션그룹 부재.
- **apply_class = ESCALATE** → 커팅을 옵션레이어로 재모델/제거 의도인지 도메인 확인 필요.

### C. 아크릴 — 아크릴미니파츠 변형행 감축 (41셀 LOW, block_resized −16)
- 변형행 34→18. 위치정렬 cell-diff는 tail-shift 유령(신뢰 LOW). 실제 = 변형행 16개 감축.
- 라이브: PRD_000163 size 1행만 적재. **apply_class = ESCALATE**(변형행 논리삭제 후보·사람 판단).

### D. 실사 — 범례 텍스트 추가 (1셀)
- MES ITEM_CD 헤더영역 주석에 “실사 가격은 '인쇄상품가격표-포스터/사인' 참고” 추가.
- 상품 속성 아님. **apply_class = GAP**(적용 대상 t_* 없음 / NO_OP).

## 2. 추적성 보증 (V7)

- `change-manifest.csv` 527행 ↔ `diff/_diff-raw.json` 변경 527 = **1:1**(누락 0).
- 각 행에 `cell_ref`(엑셀 좌표) provenance. 영향 행은 `live_prd_cd` 실측(read-only psql).
- 재현: `python3 scripts/diff_versions.py` → `scripts/build_manifest.py`.

## 3. upd_dt / 변경로그 (V6)

이번 쌍은 자동 UPSERT 0건이므로 `upd_dt` 갱신 대상도 0. escalate 항목이 후속
라운드(CPQ 매핑·논리삭제 승인)에서 적용될 때 그 델타가 `upd_dt = now()`를 단다.
전용 변경이력 테이블은 부재 → 본 매니페스트가 감사 권위. DB 레벨 이력 테이블은
`logical-delete-and-gaps.md`에서 GAP(선택 DDL 제안)로 기재.

## 4. 다음 행동 (escalate 처리 경로)

1. **굿즈파우치 size→option 재분류** → `dbm-cpq-option-mapping`으로 58상품 옵션레이어 설계
   (option_groups/options/option_items). 적재된 size행의 운명(유지 vs 논리삭제) 결정 동반.
2. **스티커 커팅 옵션** → 커팅을 옵션으로 재모델할지/제거할지 도메인 확인.
3. **아크릴미니파츠 −16변형** → 감축행 논리삭제 후보 검토(라이브 1행과 정합).
4. 위 전부 **인간 승인 후** 별도 적재 트랙. 본 트랙은 추적·분류·DRY-RUN 설계까지.
