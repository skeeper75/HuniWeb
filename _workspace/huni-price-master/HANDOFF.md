# §27 price-master 핸드오프 (재시작 포인터)

> 상세 변경이력 = `CHANGELOG.md`. 이번 세션 = 가격구성요소 병합 + 타공 교정 + 통합 배치 설계·P1.

## 완료 (이번 세션·라이브 반영·커밋)
- **가격구성요소 병합 9군** (`30_component-merge/`): 같은 차원 분리 comp → 정본 통합. 27→9·fc 34→12·단가 verbatim 불변. 라이브 COMMIT + webadmin **9/9 GO** + comp_nm 정비. 커밋 `2a2dddf`. 백업 `z_bak_mcmerge_*`·undo `_commit/04-undo.sql`.
- **타공 교정·병합** (커밋 `1fd9539`·`5f3434d`):
  - 일반현수막 8구 타공 **8,000→5,000**(권위 260702 포스터사인·과청구 해소·백업 `z_bak_tagong8_fix`)
  - MESH 타공 3→1 병합 + NORMAL 이름정비(권위 3000/4000/5000)
  - **저청구 근본원인**: 메쉬 타공 옵션 `dtl_opt` 누락 → `{타공수:4/6/8}` 채움(백업 `z_bak_mesh_tagong_dtlopt`)
- **통합 진단·교정 배치 설계 + P1**: → `_workspace/_foundation/hdx/HANDOFF.md`(별도 재시작 포인터).

## 미해결·후속 (다음 세션 후보)
1. **[활성 빌드] 통합 배치 hdx P4** — 적대적 재실측(engine verbatim·auto_data 가격중립 확인). P2(진단·보드)+P3(교정생성·값 날조 금지 라우팅) 완료(정본 재진단 327건·전건 라우팅·근본원인 dedup). **`_workspace/_foundation/hdx/HANDOFF.md` 참조.**
2. **★옵션 dtl_opt 누락 전수 점검**(저청구 헌팅) — 메쉬 타공처럼 다른 상품의 공정 옵션도 `dtl_opt` 누락으로 저청구될 수 있음. dim_vals 요구 단가행 + 옵션 dtl_opt 빈 경우 전수 스캔(= hdx OptionCpqDx 후보).
3. **최종 프로덕션 검증(타공)** — 실 견적조립은 신규 BFF/위젯(저장소 밖·개발중). 그 시스템이 붙는 시점에 타공(및 유사 공정옵션) 실제 청구 확인. 현 관리자 시뮬레이터는 비대표.
4. **스캐너 dim_vals 축 탐지 보강** — `component_merge_scan.py`가 표준컬럼만 보고 dim_vals(jsonb) 축 병합을 미탐지(타공이 그 예).

## [HARD] 건드리지 말 것
- 병합된 9군 정본 comp·타공 교정 = 전부 webadmin GO·백업 보유. relitigate 금지.
- 배선 서브트랙 스크립트(`_foundation/batch/`)·상시게이트(`plate_wiring_integrity_check.sql`).
