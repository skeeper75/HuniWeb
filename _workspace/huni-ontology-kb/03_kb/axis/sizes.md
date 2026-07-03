<!-- axis page: E3 size — 디지털인쇄 공통 사이즈 노드(마스터 t_siz_sizes). -->
<!-- ★수치(작업·재단 치수)는 아래 전사표(transcribed-by)에만. 블록 props에 raw 치수 미기입(D-9·L-12). -->
<!-- ★판걸이수(UP수)는 사이즈 컬럼이 아님 — 파생(derived_from)·엔진 fn_calc_pansu 계산(F-9·T-7). -->

# 축: 사이즈 (size)

디지털 사이즈 = 이산(離散) 사이즈 행(면적매트릭스 아님·팩 §3.2). 프리미엄엽서(016) 7행 +
출력용지 국전(SIZ_000499) + 명함 2종(승격 260703). 상품→사이즈(R2 `has_size`)는 상품 노드가 건다.

> 승격 대기(단일 소비자라 아직 상품-local): 라벨택 사이즈 SIZ_000047(40x80)·SIZ_000011(50x50·미니모양명함
> 공용 후보)·SIZ_000048(25x110)는 product-046-label-tag-nodes.md에 임시 거처. 2번째 소비 상품(미니모양명함 등)
> 집필 시 이 축으로 승격(canonical id 그대로 안정 resolve). owner=architect.

## 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_snapshot.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000001 | 73x98 | 75x100 | 73x98 |
| SIZ_000002 | 98x98 | 100x100 | 98x98 |
| SIZ_000003 | 100x150 | 102x152 | 100x150 |
| SIZ_000004 | 135x135 | 137x137 | 135x135 |
| SIZ_000005 | 95x210 | 97x212 | 95x210 |
| SIZ_000006 | 110x170 | 112x172 | 110x170 |
| SIZ_000007 | 148x210 | 150x212 | 148x210 |
| SIZ_000499 | 316x467 | 316x467 | 306x457 |

## 사이즈 노드

### [size-SIZ_000001] 73x98 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000001
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000001", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000001", note: "판걸이수 15 vs 18 충돌 — 이 사이즈의 파생값 GAP"}

### [size-SIZ_000002] 98x98 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000002
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000002", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000002"}

### [size-SIZ_000003] 100x150 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000003
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000003", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000003"}

### [size-SIZ_000004] 135x135 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000004
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000004", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000004"}

### [size-SIZ_000005] 95x210 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000005
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000005", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000005"}

### [size-SIZ_000006] 110x170 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000006
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000006", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000006"}

### [size-SIZ_000007] 148x210 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000007
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000007", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000007"}

### [size-SIZ_000499] 316x467 (국전 출력용지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000499
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000499", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000499", note: "출력용지 국전계열(OUTPUT_PAPER_TYPE.01)의 사이즈 — 판형 노드와 연동"}

## 명함 사이즈 (축 승격 260703 — 032/033 공용)

<!-- 2026-07-03 승격: 명함 사이즈 2종은 032·033 공유라 상품-local(033) 정의를 공유 axis로 이관. -->
<!-- 치수 전사표(작업/재단 mm)는 product-033-standard-namecard.md §명함 전용 사이즈(transcribe_product_033.py 산출)에 유지. -->

### [size-SIZ_000008] 90x50mm (명함 기본) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000008
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000008", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사=transcribe_product_033.py(product-033 §명함 전용 사이즈)", note: "명함 기본 사이즈·dflt_yn=Y. 판걸이수는 파생(fn_calc_pansu). 032/033 공용"}

### [size-SIZ_000133] 86x52mm (명함) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000133
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000133", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사=transcribe_product_033.py(product-033 §명함 전용 사이즈)", note: "명함 표준규격(88x54 작업·86x52 재단). 032/033 공용"}


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [size-SIZ_000057] A6 105x148 (반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000057
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000057 note:판걸이=8.0/적용=반칼스티커", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000057(작업/재단 105x148)", note: "A6 반칼·master del_yn=N·공유 axis/sizes 미등재 → needed_shared_node"}

### [size-SIZ_000058] 100x140 (팬시·판걸이 8) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000058
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000058 (100x140·work 104x144·cut 100x140·판걸이=8.0·del_yn=N·tags 스티커)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000062,SIZ_000058) dflt_yn=N·disp 2·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000058(100x140)", dflt_yn: "N", pangeori_ref: "전사표 판걸이=8.0(사이즈 파생·fn_calc_pansu)", note: "★완제품가 격자(COMP_STK_PRINT) 0행=silent-0([[sticker-spec-fancy#gap-062-siz058-price-missing]])·공유 축(axis/sizes.md) 승격 후보"}
- 본문: 팬시 실치수 사이즈(재단 100x140·작업 104x144). 판걸이수(UP수)는 사이즈 파생([[rule/rules#RULE_pansu_db_function]]). ★이 사이즈만 062 3사이즈 중 유일하게 가격격자 미충전(silent-0·gap). 아무도 정의 안 한 신규 노드 → 승격 후보.

### [size-SIZ_000059] 124x186 (팬시·A5 4판·판걸이 4·dflt) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000059
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000059 (124x186·work 128x190·cut 124x186·판걸이=4.0·del_yn=N·tags 스티커)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000062,SIZ_000059) dflt_yn=Y·disp 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000059(124x186·가격표 'A5(4판)')", dflt_yn: "Y", pangeori_ref: "전사표 판걸이=4.0", note: "완제품가 격자 충전 180행(active 5소재 각 36행)·공유 축 승격 후보"}
- 본문: 팬시 실치수 사이즈(재단 124x186·가격표는 "A5(4판)"로 라벨). dflt 사이즈(disp 1). COMP_STK_PRINT 격자 충전(silent-0 아님·전사표).

### [size-SIZ_000060] 90x190 (팬시·판걸이 6·dflt) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000060
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000060 (90x190·work 94x194·cut 90x190·판걸이=6.0·del_yn=N·tags 스티커)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000062,SIZ_000060) dflt_yn=Y·disp 1·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000060(90x190)", dflt_yn: "Y", pangeori_ref: "전사표 판걸이=6.0", note: "완제품가 격자 충전 180행(active 5소재 각 36행)·공유 축 승격 후보"}
- 본문: 팬시 실치수 사이즈(재단 90x190·작업 94x194). dflt 사이즈(disp 1·059와 함께 dflt 2개). COMP_STK_PRINT 격자 충전(silent-0 아님·전사표).

### [size-SIZ_000061] 50x70 (소형반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000061
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000061 note:판걸이=32.0/적용=소형반칼스티커·master del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000061(작업/재단 50x70)", note: "소형반칼·064 전용(live에서 PRD_000064만 사용)·공유 axis/sizes 미등재 → needed_shared_node(소형 스티커 사이즈군)"}

### [size-SIZ_000062] 70x50 (소형반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000062
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000062 note:판걸이=32.0/적용=소형반칼스티커·master del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000062(작업/재단 70x50)", note: "50x70 가로세로 회전형·064 전용·승격 후보"}

### [size-SIZ_000063] 50x94 (소형반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000063
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000063 note:판걸이=24.0/적용=소형반칼스티커·master del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000063(작업/재단 50x94)", note: "소형반칼·064 전용·승격 후보"}

### [size-SIZ_000064] 94x50 (소형반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000064
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000064 note:판걸이=24.0/적용=소형반칼스티커·master del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000064(작업/재단 94x50)", note: "50x94 가로세로 회전형·064 전용·승격 후보"}

### [size-SIZ_000065] 65x65 (소형반칼) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000065
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000065 note:판걸이=24.0/적용=소형반칼스티커·master del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000065(작업/재단 65x65)", note: "정사각 소형반칼·064 전용·승격 후보"}

### [size-SIZ_000068] 75x110 (스티커팩 주문 사이즈·판걸이16) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000068
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000065,SIZ_000068) dflt_yn=Y del_yn=N disp 1", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000068(75x110·work=cut 75x110·note 판걸이=16.0/전지 미지정/적용 스티커팩·마스터 del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000068", note: "75×110 단일 주문 사이즈(재단=작업 동일). note 판걸이=16.0(판걸이수는 사이즈 파생 fn_calc_pansu·[[rule/rules#RULE_pansu_db_function]]). 스티커팩 전용(타 스티커 052=SIZ_000057/520/170과 상이). 공유 axis/sizes.md 미등재·승격 대기(needed_shared)"}
- 본문: 75×110 스티커팩 주문 사이즈([[sticker-pack]] has_size). 판걸이=16 파생. 가격 격자(COMP_STK_PACK)의 siz_cd 키.

### [size-SIZ_000170] A5 148x210 (양면 defect — junction 활성·master 삭제) {defect}
- type: size
- anchor: t_siz_sizes/SIZ_000170
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000052,SIZ_000170) del_yn=N(junction 활성)·dflt_yn=Y", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000170 del_yn=Y(master 논리삭제 2026-06-17)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- current_value: "052 has_size junction SIZ_000170 활성(del_yn=N·dflt=Y)·COMP_STK_PRINT 단가행 실재(15조합 중 SIZ_000170×5소재 각 36행) — 손님 선택·가격 산출 가능한 상태 (live 20260702_1119)"
- authority_value: "t_siz_sizes master SIZ_000170(A5 148x210) del_yn=Y 논리삭제(2026-06-17) — 사이즈 마스터상 은퇴. A5 재키잉 정리 대상(정답=마스터 삭제 반영해 junction도 정리하거나 마스터 복원 중 택1·미확정)"
- props: {siz_nm_ref: "전사표 SIZ_000170(A5 148x210)", note: "정리 워크리스트·양면 어느 쪽도 삭제 금지·§4-C 사이즈 재키잉 파손복구 계열 잔존분 의심(실무진 확인)"}
- 본문: junction은 활성·가격도 붙는데 사이즈 마스터가 삭제된 dangling-but-priced 상태. 손님이 A5를 고르면 견적은 나오나 마스터 정합이 깨진 상태. current(활성·priced)와 authority(마스터 삭제) 둘 다 보존해 재적재/정리 추적. 판정은 실무진(A5 유지 여부)·§4-C 배선 수렴 소관.

### [size-SIZ_000197] A2 (420x594) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000197
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000197", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000197(작업 420x594·재단 420x594)", note: "낱장 자유형 스티커 A2 규격·공유 axis/sizes 미등재·최초 소비 055 → 승격 후보(needed_shared_node)"}

### [size-SIZ_000199] 400x600 (자유형 최대 바운딩) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000199
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000199", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000057,SIZ_000199) dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "본문 전사표 SIZ_000199(400x600·work=cut·impos_yn=N)", note: "자유형 스티커 최대 바운딩 사이즈(고객 업로드 칼선). 규격형 형상=size 흡수(GAP-ST-3)와 무관. 057 단일 소비자 — local"}

### [size-SIZ_000212] 정사각10x10mm(8EA) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000212
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000212", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000212(정사각10x10mm·8EA·work 10x10)", dflt_yn: "Y", note: "정사각 family(12행) 대표·dflt·형상+치수+시트당 8EA를 siz_nm이 흡수(형상=size)·가격격자 COMP_GANGPAN_PRINT 키·공유 축 승격 후보"}

### [size-SIZ_000224] 직사각35x25mm(2EA) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000224
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000224", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000224(직사각35x25mm·2EA·work 35x25)", dflt_yn: "Y", note: "직사각 family(14행) 대표·형상=size·공유 축 승격 후보"}

### [size-SIZ_000501] 원형10x10 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000501
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000501", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000501(원형10x10·work 10x10)", dflt_yn: "N", note: "원형 family(11행·전부 dflt=N) 대표·형상=size(058은 원형을 CPQ 옵션값으로 저장·모델 불일치 GAP-ST-3)·공유 축 승격 후보"}

### [size-SIZ_000514] B3 364x515 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000514
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000514 + t_prd_product_sizes 키:(PRD_000056,SIZ_000514) dflt_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "메인 전사표 SIZ_000514(재단 364x515·작업 컬럼 공백)", dflt: "N", note: "보조 사이즈(dflt N)"}

### [size-SIZ_000515] B4 257x364 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000515
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000515 + t_prd_product_sizes 키:(PRD_000056,SIZ_000515) dflt_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "메인 전사표 SIZ_000515(재단 257x364·작업 컬럼 공백)", dflt: "N", note: "보조 사이즈(dflt N)"}

### [size-SIZ_000520] A4 반칼 {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000520
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000520 note:판걸이=2.0/적용=반칼스티커(058~061)/낱장 SIZ_172와 분리(반칼 전용가)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000520(A4 반칼)", note: "★work/cut 치수 컬럼 공란(라벨만)·반칼 전용 사이즈·master del_yn=N·승격 후보"}
