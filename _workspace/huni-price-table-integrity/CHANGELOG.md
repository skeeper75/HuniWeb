# Huni-Price-Table-Integrity (§26) — CHANGELOG (최신 위 PREPEND)

## 2026-07-05 — 권위 260702 재고정 + 권위 이해 문서(25_) + 엽서북/명함 격자 오탐 해소

이번 세션은 hdx `--scope all` 4축 통합(Linkage+PriceGrid+Registration+Contribution)의 **§26 가격격자 축**으로
진행. §26 배치를 최신 권위에 재고정하고, 값의미 이해 문서를 신설하고, 격자 diff의 merge-tombstone 오탐을 해소.

**권위 260702 재고정**:
- L1 재추출 `huni-dbmap/24_master-extract-260702/`·`24_price-extract-260702/`(러너 `huni-dbmap/_scripts/`).
- §26 배치 버전 상수 260527→260702 교체: `_batch/scripts/run_all.py:29`·`_batch/scripts/grid_diff.py:821`·
  `_batch/pansu_basis_audit.py:16`(pangeori-l1.csv 경로를 24_price-extract-260702로).
- 최신 권위 = 상품마스터·인쇄상품 가격표 **둘 다 260702**(prd_nm 집합 불변 249=249 검증).

**권위 이해 문서 신설** `25_price-sheet-understanding-260702/`(INDEX + A/B/C/D):
- **[핵심] 값의미 규칙** = .01단가(수량↑값↓) / .02총액·합가(수량↑값↑). 판별 = 제목 "(단가)/(합가)" 라벨 +
  수량 방향. 이 판별이 적재 진단의 선결 조건(값의미 블록 단위 선확정).
- 시트 3분류 = 본체(A 합가 · B 면적) / 추가가격(C 공정) / 기반(D 자재 modifier).
- blind spot 등기부 11항.

**격자 오탐 해소**(merge-tombstone 부류):
- **엽서북 468 거짓 missing** = component-merge tombstone(grid_diff config가 del_yn=Y 옛 comp 겨냥) → `COMP_PCB`로
  갱신 → 468/468 값일치 해소. (이후 되돌리지 말 것.)
- **명함포토카드 103/105 값일치 해소** = grid_diff+matrix_parse+run_all에 namecard config 추가(UNMAPPED→DIFFED).
  잔여 미해결: 금유광 qty1000 2셀 진짜불일치(권위 63000 vs 라이브 64000·권위 오타 의심) + 펄/프리미엄 8셀 미상
  (note 부재·값집합 일치·소재그룹↔mat_cd 확정 필요).
- **스티커 결정론 매핑 불가**(COMP_STK_PRINT 6498행 6개 관례층 혼재·중간교정) → config 미변경(정직 보류).

**산출 갱신**: `_batch/ALL-SHEETS-summary.md`·`ALL-SHEETS-defects.csv`·`namecard-defects.csv`·`postcard-book-defects.csv`.

**[HARD] 교훈**: "미적재"로 보이는 것이 진단 도구 드리프트/포맷 미매칭일 수 있다 → 채우기 전 "라이브에 정말
없나 vs 도구가 못찾나" 판별 필수. 사람 판정 대기 = 명함 63000/64000 · 명함 소재그룹↔mat_cd · 스티커 관례층 ·
판수 이중권위 · ceiling/박등급 boundaries.

---
> 이전 변경이력 서술은 HANDOFF.md 상단 타임라인(★★★2026-07-01 등)에 누적돼 있다(이 CHANGELOG는 260705 신설).
