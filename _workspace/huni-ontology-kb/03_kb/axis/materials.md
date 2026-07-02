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

## 투명·명함박 공유 자재 (공유축 통합 mint 260703)

<!-- 2026-07-03 공유축 통합(okb-knowledge-builder): 아래 4자재는 상품 빌더 needed_shared_nodes 중 -->
<!-- 브로큰링크(product uses_material 배선 실재·노드 부재) 해소 대상. 025/037/039 uses_material 타깃. -->
<!-- 019는 같은 PET(MAT_000144/147)를 gap-019-material로 정직 지연(rewire 미실행) — 노드는 여기 공유. -->

<!-- transcribed-by: _meta/scripts/transcribe_shared_axis_260703.py from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 상위자재 |
|---|---|---|---|---|---|
| MAT_000137 | 큐리어스스킨 | MAT_TYPE.01 | 316x467 | 270 | - |
| MAT_000144 | 투명 PET 260g | MAT_TYPE.01 | 315x467 | 260 | MAT_000143 |
| MAT_000147 | 반투명 PET 260g | MAT_TYPE.01 | 315x467 | 260 | MAT_000146 |
| MAT_000178 | PET | MAT_TYPE.08 | 미기재 | 미기재 | - |

### [material-MAT_000137] 큐리어스스킨 270g {verified}
- type: material
- anchor: t_mat_materials/MAT_000137
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000137", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000137", 사용: "037 오리지널박명함 본문(USAGE.07)·색상 자식 MAT_000361~365 부모"}

### [material-MAT_000144] 투명 PET 260g {verified}
- type: material
- anchor: t_mat_materials/MAT_000144
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000144", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 상위자재: "MAT_000143", 사양_ref: "전사표 MAT_000144", 사용: "025 투명포토카드 dflt·019 투명엽서(gap-019-material 지연)(USAGE.07)"}

### [material-MAT_000147] 반투명 PET 260g {verified}
- type: material
- anchor: t_mat_materials/MAT_000147
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000147", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 상위자재: "MAT_000146", 사양_ref: "전사표 MAT_000147", 사용: "025 투명포토카드·019 투명엽서(USAGE.07)"}

### [material-MAT_000178] PET (투명명함) {verified}
- type: material
- anchor: t_mat_materials/MAT_000178
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000178", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.08", 사양_ref: "전사표 MAT_000178(규격·평량 마스터 미기재)", 사용: "039 투명명함 단일 자재(bare PET·형제 019/025 MAT_TYPE.01과 상이)(USAGE.07)"}
