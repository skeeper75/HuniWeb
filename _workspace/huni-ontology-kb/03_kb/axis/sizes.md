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

<!-- [size-SIZ_000499] 삭제(Phase4·C-3 2026-07-03): 종이류 판형은 plate-SIZ_000499-gukc4(axis/plate-sizes.md)가 실배선 담당(095/096/098 has_plate_size). t_prd_product_sizes 0행(재단/작업 사이즈 캐리어 부재·live 재실측) → size 표현 불필요. 중복·조용한 고아 제거(도메인: 종이류만 판형). -->

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
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "테이블:t_prd_product_sizes 키:(PRD_000052,SIZ_000170)·(PRD_000176,SIZ_000170)·(PRD_000177,SIZ_000170) 전부 del_yn=N(junction 활성)·dflt_yn=Y", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000170 del_yn=Y(master 논리삭제 2026-06-17)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- current_value: "052 has_size junction SIZ_000170 활성(del_yn=N·dflt=Y)·COMP_STK_PRINT 단가행 실재(15조합 중 SIZ_000170×5소재 각 36행) — 손님 선택·가격 산출 가능한 상태. **추가로 문구 셋트 176 먼슬리플래너(COMP_STN_MONTHLY=12,000)·177 스프링노트(COMP_STN_SPRINGNOTE=4,500)도 유일 단가행 사이즈로 SIZ_000170 junction 활성**(둘 다 load-bearing·마스터 삭제 미반영) (live 20260702_1119)"
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

## 셋트 계열 공유 사이즈 — Stage A(okb-knowledge-builder 260703)

<!-- 셋트 구성원 다수 공유. has_size(product→size·R2)는 상품/구성원 노드(Stage B) 배선. -->
<!-- ★재사용(중복 mint 금지): SIZ_000170 A5·SIZ_000172 A4(product-047-small-flyer.md)·SIZ_000174 A3(product-047)는 기존 노드 — set 구성원 has_size가 그 id로 해소. 여기 신규=SIZ_000380 B5만. -->
<!-- ★셋트 사이즈=구성원 단위(표지 펼침 siz≠내지 siz). 가격 좌표 기준=내지(pack §3.2). 표지 펼침 siz는 COVERBIND 통가라 무영향. -->
<!-- transcribed-by: _meta/scripts/transcribe_set_axis_260703.py from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 셋트 소유 |
|---|---|---|---|---|
| SIZ_000172 | A4(210x297mm) | 210x297 | 210x297 | 재사용(product-047) |
| SIZ_000380 | B5 (182X257) | 182x257 | 182x257 | ★신규(아래 노드) |
| SIZ_000174 | A3(297x420mm) | 297x420 | 297x420 | 재사용(product-047) |

### [size-SIZ_000380] B5 (182x257) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000380
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "테이블:t_siz_sizes 키:SIZ_000380", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000380(B5·work 182x257)", note: "셋트 내지 공유(284/285/286/287 하드커버 내지). ★A4(SIZ_000172)·A3(SIZ_000174)는 product-047 기존 재사용(승격 후보·architect)."}

## 셋트 포토북·캘린더 사이즈 — Stage C1(okb-knowledge-builder 260703)

<!-- 포토북(100)·떡메모지(097)·캘린더(108~112) 사이즈. Stage B가 프로즈로만 기록·엣지 미배선. -->
<!-- Stage C1=노드 mint·Stage C2=상품→사이즈(R2 has_size) 엣지 배선. 치수는 전사표에만(D-9·§4). -->
<!-- ★판걸이수(UP수)는 사이즈 컬럼 아님=파생(fn_calc_pansu·[[rule/rules#RULE_pansu_db_function]])·마스터 note 값은 참고. -->
<!-- ★재사용(중복 mint 금지): A4=SIZ_000172·A3=SIZ_000174(product-047)·A5=SIZ_000170(sticker)·150x100=SIZ_000124(product-027)·90x90=SIZ_000119(product-023)·B5=SIZ_000380(Stage A). -->
<!-- transcribed-by: _meta/scripts/transcribe_set_axis_c1_260703.py sizes from live-snapshot/latest (snap_20260702_1119) t_siz_sizes @ 2026-07-03 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 마스터del |
|---|---|---|---|---|
| SIZ_000266 | 70x120 | 70x120 | 70x120 | N |
| SIZ_000269 | 8x8(200x200mm) | 200x200 | 200x200 | N |
| SIZ_000274 | 10x10(250x250mm) | 250x250 | 250x250 | N |
| SIZ_000069 | 220x145 | 224x149 | 220x145 | N |
| SIZ_000070 | 130x220 | 134x224 | 130x220 | N |
| SIZ_000018 | 90x100 | 92x102 | 90x100 | N |
| SIZ_000071 | 148x60 | 152x64 | 148x60 | N |
| SIZ_000072 | 145x145 | 149x149 | 145x145 | N |
| SIZ_000073 | 220x130 | 224x134 | 220x130 | N |
| SIZ_000074 | 145x300 | 149x304 | 145x300 | N |
| SIZ_000050 | A4 (210X297) | 216x303 | 210x297 | N |
| SIZ_000075 | 210x420 | 214x424 | 210x420 | N |
| SIZ_000076 | 300x420 | 304x424 | 300x420 | N |
| SIZ_000077 | 300x625 | 304x629 | 300x625 | N |

### 포토북·떡메모지 사이즈

### [size-SIZ_000269] 8x8 (200x200mm·★포토북 골든 기준) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000269
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000269", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000269(8x8·200x200)", note: "★100 포토북 골든 기준선택 사이즈(정사각 200x200). has_size는 상품 노드(Stage B)."}

### [size-SIZ_000274] 10x10 (250x250mm) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000274
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000274", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000274(10x10·250x250)", note: "100 포토북 사이즈(정사각 250x250)"}

### [size-SIZ_000266] 70x120 (떡메모지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000266
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000266", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000266(70x120·work=cut)", note: "097 떡메모지 사이즈"}

### 캘린더 사이즈 (108~112)

### [size-SIZ_000069] 220x145 (탁상형캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000069
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000069 note:판걸이=4.0/전지 316x467/적용 탁상형캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000069(220x145)", pangeori_ref: "마스터 note 판걸이=4.0(파생·fn_calc_pansu)", note: "108 탁상형캘린더 사이즈"}

### [size-SIZ_000070] 130x220 (탁상형캘린더 세로) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000070
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000070 note:판걸이=4.0/전지 316x467/적용 탁상형캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000070(130x220)", pangeori_ref: "마스터 note 판걸이=4.0(파생)", note: "108 탁상형캘린더 세로 사이즈"}

### [size-SIZ_000018] 90x100 (미니·판걸이 12) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000018
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000018 note:판걸이=12.0/전지 316x467/적용 미니접지카드", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000018(90x100)", pangeori_ref: "마스터 note 판걸이=12.0(파생)", note: "★마스터 적용 note=미니접지카드이나 캘린더 계열(109 미니탁상) 공유 사이즈로 Stage B 지목. 적용 라벨과 소비 상품 상이 관찰(단정 금지)"}

### [size-SIZ_000071] 148x60 (미니탁상형캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000071
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000071 note:판걸이=12.0/전지 316x467/적용 미니탁상형캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000071(148x60)", pangeori_ref: "마스터 note 판걸이=12.0(파생)", note: "109 미니탁상형캘린더 사이즈"}

### [size-SIZ_000072] 145x145 (엽서캘린더 정사각) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000072
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000072 note:판걸이=6.0/전지 316x467/적용 엽서캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000072(145x145)", pangeori_ref: "마스터 note 판걸이=6.0(파생)", note: "110 엽서캘린더 정사각 사이즈"}

### [size-SIZ_000073] 220x130 (엽서캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000073
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000073 note:판걸이=4.0/전지 316x467/적용 엽서캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000073(220x130)", pangeori_ref: "마스터 note 판걸이=4.0(파생)", note: "110 엽서캘린더 가로 사이즈"}

### [size-SIZ_000074] 145x300 (엽서캘린더 세로) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000074
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000074 note:판걸이=3.0/전지 316x467/적용 엽서캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000074(145x300)", pangeori_ref: "마스터 note 판걸이=3.0(파생)", note: "110 엽서캘린더 세로 사이즈"}

### [size-SIZ_000050] A4 (210x297·전단지/책자내지) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000050
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000050 note:판걸이=2.0/전지 316x467/적용 전단지·책자내지", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000050(A4 210x297)", pangeori_ref: "마스터 note 판걸이=2.0(파생)", note: "★A4이나 SIZ_000172(product-047 A4)와 별 코드=전단지/책자내지 전용 A4 마스터. 캘린더/책자 내지 공유. 중복 mint 아님(다른 siz_cd)"}

### [size-SIZ_000075] 210x420 (벽걸이캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000075
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000075 note:판걸이=1.0/전지 316x467/적용 벽걸이캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000075(210x420)", pangeori_ref: "마스터 note 판걸이=1.0(파생)", note: "111 벽걸이캘린더 사이즈"}

### [size-SIZ_000076] 300x420 (벽걸이캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000076
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000076 note:판걸이=1.0/전지 316x467/적용 벽걸이캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000076(300x420)", pangeori_ref: "마스터 note 판걸이=1.0(파생)", note: "111 벽걸이캘린더 대형 사이즈(impos_yn=Y)"}

### [size-SIZ_000077] 300x625 (와이드벽걸이캘린더) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000077
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000077 note:판걸이=1.0/전지 미지정/적용 와이드벽걸이캘린더", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000077(300x625)", pangeori_ref: "마스터 note 판걸이=1.0(파생·전지 미지정)", note: "112 와이드벽걸이캘린더 사이즈(impos_yn=Y·전지 미지정)"}

## 문구 셋트(SB-1) 사이즈 — Stage C1(okb-knowledge-builder 260703)

<!-- 만년다이어리 완제품 dflt(SIZ_000375) + 문구 셋트(스프링수첩178/메모패드179/정철노트181) 부모 dflt 사이즈. -->
<!-- has_size(product→size)는 상품 노드(Stage B/C2)가 배선. C1은 축 노드만 mint. SIZ_000007(148x210)은 이미 존재(재사용). -->

### [size-SIZ_000375] 130x190 (만년다이어리 완제품) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000375
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000375(130x190·work 130.00x190.00·cut 130.00x190.00·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000375(130x190)", note: "만년다이어리 4종 완제품(172~175) dflt 사이즈·완제품가 sparse 유일 단가행 좌표. has_size는 상품 노드(Stage C2)가 배선"}

### [size-SIZ_000377] 90x145 (스프링수첩) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000377
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000377(90x145·work 90.00x145.00·cut 90.00x145.00·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000178,SIZ_000377) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000377(90x145)", note: "178 스프링수첩 기본 사이즈. has_size는 상품 노드(Stage C2)가 배선"}

### [size-SIZ_000379] 144x206 (메모패드 부모) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000379
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000379(144x206·work 144.00x206.00·cut 144.00x206.00·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000179,SIZ_000379) dflt_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000379(144x206)", note: "179 메모패드 부모 dflt 사이즈(SIZ_000380도 dflt_yn=Y 존재·이 노드는 379만). has_size는 상품 노드(Stage C2)가 배선"}

### [size-SIZ_000196] A6 (105x148mm·정철노트 부모·마스터 논리삭제) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000196
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000196(A6(105x148mm)·work 105.00x148.00·cut 105.00x148.00·use_yn=Y·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000181,SIZ_000196) dflt_yn=Y·del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000196(A6 105x148mm)", note: "★181 정철노트 부모 유일 사이즈. 마스터 del_yn=Y이나 정션(PRD_000181,SIZ_000196) 활성=load-bearing → 보존. has_size는 상품 노드(Stage C2)가 배선"}

## 굿즈/파우치 사이즈 — Stage C1(okb-knowledge-builder 260704)

<!-- goods-needs-axis size 11줄 → 실 사이즈 코드 13(explicit 10 + pouch-axis 복합키 대표 3: 448/246/449). 이미 product-186 local canonical 3종 skip(consolidation은 C2/architect): SIZ_000384(S)·SIZ_000386(M)·SIZ_000388(L). 나머지 10 mint. -->
<!-- L-17 정션 복합키 대표키: 448(241)·246·449(242)는 t_prd_product_sizes 실재이나 마스터 t_siz_sizes에도 실재→anchor=t_siz_sizes/SIZ_xxx(대표키). 나머지 파우치 사이즈가 t_prd_product_plate_sizes에만 있는 것(비종이 판형 오용)은 has_plate_size 금지·미민팅. -->
<!-- has_size(product→size)는 상품 노드(Stage C2)가 배선. 치수는 아래 전사표(transcribed-by)에만. -->

## 굿즈/파우치 치수 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: awk -F',' from live-snapshot/latest/t_siz_sizes.csv (snap_20260702_1119) work=work_width x work_height·cut=cut_width x cut_height @ 2026-07-04 -->
| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |
|---|---|---|---|
| SIZ_000406 | 2x2구 | 2x2 | 2x2 |
| SIZ_000433 | 220x300 | 220x300 | — |
| SIZ_000434 | 260x340 | 260x340 | — |
| SIZ_000435 | 220x294 | 220x294 | — |
| SIZ_000436 | 260x374 | 260x374 | — |
| SIZ_000437 | 440x160 | 440x160 | — |
| SIZ_000438 | 520x200 | 520x200 | — |
| SIZ_000448 | 70x100 | 70x100 | — |
| SIZ_000246 | 100x70 | 100x70 | 100x70 |
| SIZ_000449 | 100x40 | 100x40 | — |

## 굿즈/파우치 사이즈 노드

### [size-SIZ_000406] 2x2구 (키캡 구수 규격) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000406
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000406(2x2구·impos_yn=N·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000406", note: "202 유일 사이즈. 키캡 구수(2x2) 규격 — 길이 mm가 아닌 구수 축(작업/재단 동일·impos_yn=N)"}

### [size-SIZ_000433] 220x300 (플랫파우치 M) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000433
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000433(220x300·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000433", note: "230 플랫파우치 M(dflt·option_group OPT_000073 사이즈 참조). 재단치수 마스터 공란"}

### [size-SIZ_000434] 260x340 (플랫파우치 L) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000434
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000434(260x340·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000434", note: "230 플랫파우치 L. 재단치수 마스터 공란"}

### [size-SIZ_000435] 220x294 (슬림파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000435
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000435(220x294·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000435", note: "231 슬림파우치(dflt). 재단치수 마스터 공란"}

### [size-SIZ_000436] 260x374 (슬림파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000436
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000436(260x374·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000436", note: "231 슬림파우치. 재단치수 마스터 공란"}

### [size-SIZ_000437] 440x160 (삼각파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000437
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000437(440x160·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000437", note: "232 삼각파우치(dflt). 재단치수 마스터 공란"}

### [size-SIZ_000438] 520x200 (삼각파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000438
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000438(520x200·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000438", note: "232 삼각파우치. 재단치수 마스터 공란"}

### [size-SIZ_000448] 70x100 (파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000448
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000448(70x100·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000241,SIZ_000448) dflt_yn=Y·del_yn=N(정션 활성·대표키)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000448", note: "241 파우치 유일 사이즈(t_prd_product_sizes 실재). 재단치수 마스터 공란"}

### [size-SIZ_000246] 100x70 (파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000246
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000246(100x70·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000242,SIZ_000246) dflt_yn=Y·del_yn=N(정션 활성·대표키)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000246", note: "242 파우치 사이즈(dflt·t_prd_product_sizes 실재). 449와 공유"}

### [size-SIZ_000449] 100x40 (파우치) {verified}
- type: size
- anchor: t_siz_sizes/SIZ_000449
- src: {source_file: "live-snapshot/latest/t_siz_sizes.csv", source_locator: "키:SIZ_000449(100x40·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_sizes.csv", source_locator: "키:(PRD_000242,SIZ_000449) del_yn=N(정션 활성·대표키)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {siz_nm_ref: "전사표 SIZ_000449", note: "242 파우치 2번째 사이즈(t_prd_product_sizes 실재). 246과 공유"}
