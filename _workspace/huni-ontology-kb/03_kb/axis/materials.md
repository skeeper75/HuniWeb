<!-- axis page: E4 material — 디지털인쇄 공통 자재(용지) 노드(마스터 t_mat_materials). -->
<!-- ★수치(평량·규격)는 아래 전사표에만. 자재 모델 = parent + usage_cd 단일 슬롯(팩 §3.5). -->
<!-- ★[HARD] 실무진이 IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지(팩 §3.5·배선 갭). -->

# 축: 자재 (material)

낱장 단일 본문 자재 → 자재 모델 = parent + usage_cd 단일 슬롯(빈 용도→USAGE.07 default·정당).
아래는 디지털 파일럿이 공유하는 대표 용지(전체 자재 목록은 상품별·Phase 4). 상품→자재(R3
`uses_material`)는 상품 노드가 건다.

## 자재 사양 전사표 (권위 = 라이브 마스터)

<!-- transcribed-by: _meta/scripts/transcribe_snapshot.py(수동 확장 SELECT t_mat_materials) from live-snapshot/latest (snap_20260702_1119) @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) |
|---|---|---|---|---|
| MAT_000074 | 백색모조지 220g | MAT_TYPE.01 | 316x467 | 220 |
| MAT_000081 | 아트지 250g | MAT_TYPE.01 | 316x467 | 250 |
| MAT_000082 | 아트지 300g | MAT_TYPE.01 | 316x467 | 300 |
| MAT_000091 | 스노우지 250g | MAT_TYPE.01 | 316x467 | 250 |
| MAT_000092 | 스노우지 300g | MAT_TYPE.01 | 316x467 | 300 |
| MAT_000101 | 랑데뷰 WH 240g | MAT_TYPE.01 | 316x467 | 240 |

## 자재 노드

### [material-MAT_000074] 백색모조지 220g {verified}
- type: material
- anchor: t_mat_materials/MAT_000074
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000074", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000074", 사용: "016/033 공통(USAGE.07)"}

### [material-MAT_000081] 아트지 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000081
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000081", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000081"}

### [material-MAT_000082] 아트지 300g {verified}
- type: material
- anchor: t_mat_materials/MAT_000082
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000082", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000082"}

### [material-MAT_000091] 스노우지 250g {verified}
- type: material
- anchor: t_mat_materials/MAT_000091
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000091", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000091"}

### [material-MAT_000092] 스노우지 300g {verified}
- type: material
- anchor: t_mat_materials/MAT_000092
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000092", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000092"}

### [material-MAT_000101] 랑데뷰 WH 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000101
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000101", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000101"}

## 접지카드·라벨택 공용 자재 (축 승격 260703)

<!-- 2026-07-03 승격: MAT_000109 몽블랑 240g는 027(접지카드)·046(라벨택) 공유라 상품-local(046) 정의를 공유 axis로 이관. -->
<!-- 자재 사양(평량/규격)은 마스터 t_mat_materials에 일부 미기재(width/height/weight 공란) — 아래 note에 정직 표기(날조 0). -->

### [material-MAT_000109] 몽블랑 240g {verified}
- type: material
- anchor: t_mat_materials/MAT_000109
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000109", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 상위자재: "MAT_000103", 사양_ref: "마스터 t_mat_materials/MAT_000109(평량 240g·규격 미기재)", 사용: "027 접지카드·046 라벨택 본문(USAGE.07)"}
