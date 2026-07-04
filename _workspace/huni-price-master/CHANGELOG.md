# §27 price-master — CHANGELOG (최신 위 PREPEND)

## 2026-07-04 — 가격구성요소 병합 서브트랙 (`30_component-merge/`)

**문제**: 인쇄 가격표 각 시트=차원으로 이뤄진 가격테이블. "같은 테이블 차원인데 분리 작성된 가격구성요소(comp)" 병합 필요.

**병합 룰[HARD] 정립** (판정지표=`t_prc_price_components.use_dims` + 단가행 차원값 분포):
- 유형 A 병합대상 = use_dims 동일 + 단일 분리축만 다르고 나머지 격자 동일 + 그 분리축이 이미 차원컬럼(print_opt_cd·opt_cd·mat_cd)으로 존재("한 상품 안 손님 선택").
- 분리 유지 = 종류/상품 자체가 다름(제본종류·별색·접지종류·박종류). 격자 verbatim 동일시만 유형 B dedup.
- 명명[확정] = 축 접미사 제거 clean mint(COMP_NAMECARD_STD 등)·멤버 논리삭제(use_yn=N·del_yn)·단가행 comp_cd 재지정·fc N→1.

**오케스트레이션[검증됨]**: 새 하네스/에이전트 0 — §27 상위조율 + 기존 조합.
- ①탐지 = `_workspace/_foundation/batch/component_merge_scan.py`(재사용 결정론 스크립트·wiring_scan.py 동거)
- ②③설계·재배선 = `hpe-engine-designer`(search-before-mint·hbd-dedup 무손실 패턴)
- ④검증 = `hpe-validator` E1~E7 + `hpe-codex-validator` 독립 2차 (생성≠검증)

**결과**: 유형 A **9군 27comp→9**(명함8군+엽서북1)·단가행 562 재지정·fc 34→12행. 양측 검증 **GO 8 + 조건부GO 1(MC-01)·NO-GO 0**. 골든 단가 verbatim 0오차.
- ★silent 이중합산 **구조적 불가** 확인(분리축 NON_QTY_DIMS 정확매칭 + ERR_AMBIGUOUS 치명차단 + 멤버 print_opt_cd NULL=0). 병합 전/후 가격 verbatim 불변.
- nat_key 라이브 현행 **15열**(스냅샷 DDL 260606 8열=stale)→충돌 0. 엔진 무변경·DDL 불요.
- MC-01 엽서북: 라이브 이미 in-place 병합됨(07-03)·시점종속 → `COMP_PCB_S1_20P=468` halt 하드게이트 필수.

**상태 — ★9군 전건 라이브 COMMIT 완료(2026-07-04)**: 27comp→9·fc 34→12·멤버26 논리삭제·**단가 verbatim 드리프트 0**(comp_price_id별 백업 대비 unit_price 완전동일)·MC-01 468halt 통과. 필수게이트4(혼재0·멤버참조0·nat_key충돌0·골든0오차)=COMMIT SQL 하드어서션 내장·전건 통과. 백업=`z_bak_mcmerge_*`·undo=`_commit/04-undo.sql`. 잔존 351행=3 PCB 고아(fc참조0·del_yn=Y·엔진 무영향 tombstone). webadmin 실화면 **9/9 전건 GO**(골든 verbatim·분기정상·제외정상·PRICE≠0·undo불필요). **완결.** comp_nm 표시명 정비 완료(8 정본 축라벨 제거·가격무영향). 타공 REVIEW 완료 — ★일반현수막 8구 타공 8000→5000 교정(권위 인쇄상품가격표 260702 `포스터사인` verbatim·과청구3000 해소·백업 z_bak_tagong8_fix). MESH 타공 3→1 병합 + NORMAL 이름정비 완료(clean-mint·정본 각 3행 3000/4000/5000·백업 z_bak_tagong_merge_*·webadmin GO). ★저청구 근본원인 규명+교정: 메쉬현수막 타공 옵션 dtl_opt 누락(일반은 {타공수} 완비)→타공수 param 부재로 단가행 미매칭=무료. 교정=메쉬 3옵션 dtl_opt={타공수:4/6/8}(백업 z_bak_mesh_tagong_dtlopt). ★실 견적조립은 신규 BFF/위젯(저장소 밖·개발중)·현 고객견적=레거시 .asp·관리자 시뮬레이터 비대표(price_simulate가 POST selections/procs 그대로 수신). 데이터 일반=메쉬 정합. 최종 검증=신규 시스템 조립 시점. 잔여=스캐너 dim_vals 축 탐지 보강.

**산출물**: `30_component-merge/{component-merge-board.md, merge-rewire-manifest.md, verify-hpe-validator.md, verify-codex.md, _dryrun/, _commit/}` · `_foundation/batch/component_merge_scan.py`.

**후속 미결**: 타공 4/6/8개(축 미인코딩 REVIEW·9군과 별개) · comp_nm 코드노출 102/146 정비(dbm-price-arbiter·비차단).
