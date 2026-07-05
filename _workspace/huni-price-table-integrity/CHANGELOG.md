# Huni-Price-Table-Integrity (§26) — CHANGELOG (최신 위 PREPEND)

## 2026-07-06 — 가격구성요소 차원정합 감사 + 전 사슬 프레임워크 + 옵션코드 라이브 교정

스크린샷("가격구성요소MD 단가표 편집 차원")을 계기로, 가격구성요소 use_dims가 인쇄상품 가격표 각 시트 차원과
정합하는지를 **전 사슬(상품→공식→구성요소→차원→기준정보 마스터↔시트차원)** 로 진단·교정.

- **전 사슬 정합 원칙 정립**(지니 directive) + 프레임워크 문서(`dim-editor-audit/FULLCYCLE-CONFORMANCE-FRAMEWORK-260706.md`).
  [HARD] grid_diff "N% 일치"는 한 차원 L6일 뿐 시트 정합 아님. 계층4 매핑 매트릭스로 종합(아크릴 79→100%).
- **순환고리 4계층 전수 센서스**(`cycle_census.py`): 죽은공식11·공식미연결상품125(활성완제품57=굿즈미적재)·
  죽은구성요소21(SUPERSEDED14=소재분리→mat_cd통합 잔재)·opt_cd 폴리모픽(진짜고아11)·EMPTY_DECL54. 진단 닫힘.
- **굿즈 57 미적재**: 최신 권위(상품마스터 260703 굿즈시트)가 57/57 커버·band 4종 DB골든일치. 적재본 준비 완료(적재 미실행).
- **(가) 아크릴 결함A = 거짓양성**: 투명1.5T 골든 81/81(CLEAR3T mat_cd MAT_042 실재). `grid_diff.py` mat_cd-aware
  keying 교정(백업 .bak_260706)→아크릴 100%. 아크릴 자재차원 실제 정상. 진짜 결함=키링 고리 미도달.
- **★옵션코드 정합 라이브 railway DB COMMIT**(webadmin verify_optcode_integrity.py ✅ 전항목 정상): ①키링 고리 4행
  opt_cd→정본 OPV_000624~627 ②PRD_000146 재배선 PRF_ACRYL_KEYRING(면적+고리)+볼체인 tombstone→[4]11→0 ③교차중복14
  재번호(migrate·keeper유지)→[1]14→0 ④전역 UNIQUE 인덱스 2개→재발차단. 백업 z_bak_keyring_*·z_bak_ballchain_260706·라이브 base가격 무변경.
- **최신 권위 교정**: 상품마스터 260703·가격표 260705(260702도 stale). 메모리 [[authority-excel-latest-version-260706]].
- 미해결: 박 공정상세옵션(나)·굿즈적재(다)·권위 3시트 재추출(라)·계층4 전시트 배치화. 하이픈 레거시=보류(지니).

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
