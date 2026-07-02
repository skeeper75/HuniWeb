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
