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


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [material-MAT_000084] 비코팅스티커 (유형 관찰) {candidate}
- type: material
- anchor: t_mat_materials/MAT_000084
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000084 (★live mat_typ=MAT_TYPE.13·note는 →.11 정정 주장·316x467·90g)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.13", usage_cd: "USAGE.07", note: "★비코팅 점착지·live 자재유형 MAT_TYPE.13인데 note '정정 2026-06-14: 종이(.01)→스티커(.11)'는 .11을 주장(note-값 불일치). 권위(260702)에 명시 없어 단정 불가 → gap-060-mat084-typ. badge=candidate(미확정)"}

### [material-MAT_000153] 유포스티커 {verified}
- type: material
- anchor: t_mat_materials/MAT_000153
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000153 (mat_typ=MAT_TYPE.11·330x470·80g)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", 사양_ref: "전사표 MAT_000153", note: "유포 점착지(스티커 베이스·불투명)·정답 자재유형 MAT_TYPE.11 정합. 스티커 공유 축 승격 후보"}

### [material-MAT_000155] 무광코팅스티커 (★코팅 CONFLICT) {candidate}
- type: material
- anchor: t_mat_materials/MAT_000155
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000155 (mat_typ=MAT_TYPE.11·90g)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 코팅 CONFLICT(라이브 코팅=자재 MAT_000155/156 vs Q9 코팅=공정 PROC_000013)·T-4 단정 금지", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-stk}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", note: "★무광코팅이 자재로 적재(BATCH-3 CONFLICT). Q9=코팅은 공정(PROC_000013)·가격표=코팅 가격축 3컬럼. 미해소 → gap-060-coating-conflict. badge=candidate(오적재 판정 미확정·단정 금지)"}

### [material-MAT_000156] 유광코팅스티커 (★코팅 CONFLICT) {candidate}
- type: material
- anchor: t_mat_materials/MAT_000156
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000156 (mat_typ=MAT_TYPE.11·90g)", captured_at: "live 20260702_1119", badge: candidate, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-ontology-kb/01_curation/pack-sticker.md", source_locator: "§3.9 코팅 CONFLICT·T-4 단정 금지", captured_at: "2026-07-03", badge: candidate, src_id: SR-pack-stk}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", note: "★유광코팅이 자재로 적재(BATCH-3 CONFLICT·MAT_000155 동형). 미해소 → gap-060-coating-conflict. badge=candidate"}

### [material-MAT_000162] 투명스티커(현재값·구값) ↔ 투명스티커(백색후지) 260702(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000162
- badge: defect
- current_value: "MAT_000162 마스터명=투명스티커·평량=105·연당가/국4절가 미저장(t_mat_materials 가격컬럼 없음·COMP_PAPER 스티커 mat_cd 0행) (live-snapshot 20260702_1119·전사표)"
- authority_value: "260702 명=투명스티커(백색후지)·평량=50·연당가=149,500·국4절가=499 (price-diff-260527-260702.csv 출력소재 IMPORT 투명스 행·전사표) — 자식 코드 MAT_000371(백색후지) 06-27 mint됐으나 단가/평량 미반영"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000162(+자식 MAT_000371)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "시트:출력소재(IMPORT) key:투명스 (종이명/평량/연당가/국4절)", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", note: "056 링크 자재(parent). 자재유형 MAT_TYPE.11(스티커) 재분류 완료(C-ST-09). ★연당가 재적재 워크리스트 — 어느 쪽도 삭제 금지(current=라이브 구값/미저장·authority=260702). 재적재 완료 시 badge→verified"}
- rel: {rel: references, target: material-MAT_000372, note: "260702 권위 split 형제(백색후지↔투명후지) — 같은 투명스티커 계열"}
- 본문: 260702 권위가 투명스티커를 백색후지/투명후지로 나누고 연당가를 130,000→149,500(국4절 1,300→499·평량 105→50)로 개편했으나, 라이브는 부모 MAT_000162 속성이 구값(명 "투명스티커"·평량 105)이고 연당가 저장처 자체가 없다([[gap-056-material-cost-storage]]). 완제품 retail(시트가격)은 260702 무변경이라 별개 축(retail dual 아님·pack §4-D).

### [material-MAT_000163] 홀로그램스티커 (점착지·MAT_TYPE.11) {verified}
- type: material
- anchor: t_mat_materials/MAT_000163
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000163(홀로그램스티커·MAT_TYPE.11·weight=50)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000054,MAT_000163) usage_cd=USAGE.07 dflt_yn=Y", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", weight_ref: "전사표(50g)", note: "홀로그램 점착지·정답 자재유형 MAT_TYPE.11(스티커·pack §3.5). 자재 identity(명·평량)는 라이브=권위 일치. 자식 MAT_000590(홀로그램 스티커 50g·2026-06-30 mint)·parent+usage_cd 단일 슬롯. 공유 axis/materials.md 미등재(스티커 자재 첫 등장)·승격 대기(needed_shared)"}
- 본문: 홀로그램 점착지 = PRD_000054 본문 자재([[sticker-halfcut-hologram]] uses_material). 자재 identity는 검증됨 — ★연당가(원가)만 라이브 미저장이라 별도 양면 노드 [[matcost-054-hologram]]로 분리 표기(§4-D).

### [material-MAT_000170] 투명데드롱스티커 (25g·합판스티커용지) {verified}
- type: material
- anchor: t_mat_materials/MAT_000170
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000170 (mat_typ_cd=MAT_TYPE.13·weight 25)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.13(합판스티커용지)", upr_mat_cd: "(없음·parent)", 사양_ref: "전사표 MAT_000170(투명데드롱스티커 25g)", note: "투명 데드롱 점착지·★260702 연당가 변경 소재 '투명스티커(투명후지 MAT_000372)'와는 다른 코드(교집합 0·dual 불요)·공유 축 승격 후보"}

### [material-MAT_000171] 은데드롱스티커 (25g·합판스티커용지) {verified}
- type: material
- anchor: t_mat_materials/MAT_000171
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000171 (mat_typ_cd=MAT_TYPE.13·weight 25)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.13(합판스티커용지)", upr_mat_cd: "(없음·parent)", 사양_ref: "전사표 MAT_000171(은데드롱스티커 25g)", note: "은 데드롱 점착지·260702 연당가 변경분 아님(dual 불요)·공유 축 승격 후보"}

### [material-MAT_000242] 미색스티커 {verified}
- type: material
- anchor: t_mat_materials/MAT_000242
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000242 (mat_typ=MAT_TYPE.11·note 6-14 종이→스티커 정정)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", note: "미색 점착지·자재유형 종이(.01)→스티커(.11) 정정 실증(round-13 오염 교정됨·pack §3.5). 스티커 공유 축 승격 후보"}

### [material-MAT_000371] 투명스티커(백색후지) (점착지·MAT_TYPE.11) {verified}
- type: material
- anchor: t_mat_materials/MAT_000371
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000371(투명스티커(백색후지)·MAT_TYPE.11·upr_mat_cd=MAT_000162·weight 공란·2026-06-27 mint)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000053,MAT_000371) usage_cd=USAGE.07 dflt_yn=Y del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", usage_cd: "USAGE.07", upr_mat_cd: "MAT_000162", note: "투명 점착지(백색박리지 후지)·정답 자재유형 MAT_TYPE.11(스티커·pack §3.5). 자재명은 260702 권위('투명스티커(백색후지)')와 일치. ★단 weight 공란(부모 MAT_000162만 평량 105=구값)·연당가는 라이브 미저장 → 평량50/연당가149500 정답은 양면 [[matcost-053-white-backing]]. 부모 MAT_000162는 상품행 논리삭제(del_yn=Y). 공유 axis/materials.md 미등재(투명 점착지)·승격 대기(needed_shared)"}
- 본문: 투명스티커(백색후지) = PRD_000053 기본 본문 자재([[sticker-halfcut-clear]] uses_material·dflt). identity(명·유형)는 검증됨 — ★평량·연당가(원가)만 라이브 미충전이라 별도 양면 노드로 분리(§4-D).

> ★투명후지 identity(material-MAT_000372)는 **이미 sticker-sheet-clear-white-nodes.md(056)가 정의** — 재정의 금지·재사용.
> [[sticker-halfcut-clear]] uses_material→material-MAT_000372·아래 양면 [[matcost-053-clear-backing]]가 그 노드를 references.

### [material-MAT_000372] (코드만·단가 미반영) ↔ 투명스티커(투명후지) 260702 신규행(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000372
- badge: defect
- current_value: "MAT_000372 마스터명=투명스티커(투명후지)·upr_mat_cd=MAT_000162·평량 공백·연당가/국4절 미저장(06-27 코드만 mint) (live-snapshot 20260702_1119·전사표)"
- authority_value: "260702 신규행(row 86)=투명스티커(투명후지)·평량=50·연당가=222,000·국4절가=740 (price-diff-260527-260702.csv 출력소재 IMPORT 투명투 ADDED row·전사표)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000372(upr=MAT_000162)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "시트:출력소재(IMPORT) key:투명투 (ADDED row 86·H=222000 I=740 D=50)", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000162", note: "투명후지 변형(056 자재 계열·상품 t_prd_product_materials엔 parent MAT_000162만 링크). 코드는 06-27 존재하나 연당가/평량 미반영 → 재적재 워크리스트(pack §4-D). 어느 쪽도 삭제 금지"}
- 본문: 260702가 새로 추가한 투명후지 소재(연당가 222,000/국4절 740/평량 50). 라이브엔 코드만 존재하고 단가/평량이 비어 있다. 홀로그램(MAT_000163)은 형제 스티커 상품(054)이 쓰므로 그 상품 노드가 owner다. ★크라프트(MAT_000164)는 **라이브 상품 어디에도 미사용**(t_prd_product_materials 0행)이라 product owner가 없어 아래 axis 노드가 §4-A 연당가 재적재 워크리스트의 canonical owner다.

### [material-MAT_000164] 크라프트 스티커 (점착지·MAT_TYPE.11) ↔ 260702 연당가 재적재분(정답) {defect}
- type: material
- anchor: t_mat_materials/MAT_000164
- badge: defect
- current_value: "MAT_000164 마스터명=크라프트 스티커·MAT_TYPE.11·평량 57.00·연당가/국4절 미저장(2026-06-03 코드만 mint)·COMP_PAPER 0행 — 원가 라이브 미저장 (live-snapshot 20260702_1119)"
- authority_value: "260702 연당가=81,500·국4절가=272·평량=57(무변)·규격 57g/1박스당 500매 (price-diff-260527-260702.csv 출력소재 IMPORT '크라프' 행 H·I·F·자식 MAT_000591 크라프트스티커 57g 06-30 mint)"
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000164(크라프트 스티커·MAT_TYPE.11·weight 57.00·가격 미저장) + 자식 MAT_000591(upr=MAT_000164·06-30 mint)", captured_at: "live 20260702_1119", badge: defect, src_id: SR-5-livesnap}
- src: {source_file: "_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv", source_locator: "시트:출력소재(IMPORT) key:크라프 (연당가 H=156000→81500·국4절 I=312→272·규격 F=57g/1박스당 500매)", captured_at: "2026-07-03", badge: defect, src_id: SR-2.2-diff}
- props: {mat_typ_cd: "MAT_TYPE.11", weight_ref: "전사표(57g·무변)", note: "★라이브 상품 미사용(t_prd_product_materials·t_prd_product_materials 0행)이라 product owner 부재 → 이 axis 노드가 §4-A 연당가 재적재 워크리스트 owner(4소재 中 유일하게 상품 미배선). 코드는 06-03 존재하나 연당가/국4절 미반영. 어느 쪽도 삭제 금지(pack §4-D·RULE_import_material_no_delete). 값은 스크립트 전사(price-diff CSV·손전사 아님)"}
- 본문: 크라프트 스티커 = 260702 돈-크리티컬 연당가 개편 4소재(투명 162·홀로 163·크라프트 164·투명후지 372) 中 하나. 다른 3소재는 스티커 상품(053/054/056/063)이 써서 그 상품 노드가 dual owner이나, 크라프트는 라이브 어떤 스티커 상품도 쓰지 않아(전수 실측 0행) product 위임 대상이 없다 → 이 axis 양면 노드가 워크리스트 owner(gap-058/062/066이 references). 이로써 §4-D 워크리스트 4/4 완비.

### [material-MAT_000584] 유포스티커 80g {verified}
- type: material
- anchor: t_mat_materials/MAT_000584
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000584 (MAT_TYPE.11·상위 MAT_000153)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000153", 사양_ref: "전사표 MAT_000584(유포 80g)", note: "종이 옵션값 dflt·유포지 점착지·승격 후보"}

### [material-MAT_000585] 무광코팅스티커 (아트지90g+무광라미) {verified}
- type: material
- anchor: t_mat_materials/MAT_000585
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000585 mat_nm:무광코팅스티커(아트지90g+무광라미네이팅)·상위 MAT_000155", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000155", note: "★코팅=자재 흡수(BATCH-3 CONFLICT)·자재명에 무광라미 내장. 동시에 라미공정 PROC_000015도 존재 → [[gap-052-coating-conflict]]. 자재 자체는 live 정당·삭제 금지"}

### [material-MAT_000586] 유광코팅스티커 (아트지90g+유광라미) {verified}
- type: material
- anchor: t_mat_materials/MAT_000586
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000586 mat_nm:유광코팅스티커(아트지90g+유광라미네이팅)·상위 MAT_000156", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000156", note: "★코팅=자재 흡수(BATCH-3 CONFLICT)·자재명에 유광라미 내장. 동시에 라미공정 PROC_000014도 존재 → [[gap-052-coating-conflict]]"}

### [material-MAT_000593] 유포 + 무광쿨코팅 {verified}
- type: material
- anchor: t_mat_materials/MAT_000593
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000593 (upr_mat_cd=MAT_000165 유포지+엠보코팅·mat_typ_cd=MAT_TYPE.11·2026-06-30 mint)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000165", 사양_ref: "전사표 MAT_000593(규격/평량 미기재·상위 유포지 상속)", note: "유포지 점착지+무광쿨코팅 내장(공정 PROC_000114 쿨코팅과 대응). 구 자재 MAT_000153(유포스티커) 논리삭제 후 교체. 연당가는 260702 무변경(유포=라벨 재편만·§4-A) → dual 미해당. 공유 축 승격 후보"}

<!-- 구 자재 MAT_000153(유포스티커·MAT_TYPE.11)은 2026-07-01 product_materials 논리삭제(del_yn=Y) — 노드화하지 않음(활성 아님). 재적재 이력은 배선 §27 round22. -->

### [material-MAT_000594] 타투스티커 (점착지·활성 자식) {verified}
- type: material
- anchor: t_mat_materials/MAT_000594
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000594 mat_nm:타투스티커·mat_typ_cd=MAT_TYPE.11·상위 MAT_000167·2026-06-30 신설·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "테이블:t_prd_product_materials 키:(PRD_000067,MAT_000594) usage USAGE.07·dflt Y·del_yn=N — 구 MAT_000167은 (PRD_000067,MAT_000167) del_yn=Y(2026-07-01 재키잉)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000167", 사양_ref: "전사표 MAT_000594(타투스티커)", legacy_parent: "MAT_000167(타투전용지·210x297·junction del_yn=Y)", note: "★자재유형 열린 질문: live=.11 스티커 점착지 vs 팩 §3.5 '종이 .01 정당 가능(표본 컨펌)' → [[gap-067-mattype-transfer-paper]](양면 아님·정답 미확정)·승격 후보"}

### [material-MAT_000609] 미색스티커 (모조80g) {verified}
- type: material
- anchor: t_mat_materials/MAT_000609
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000609 (MAT_TYPE.11·상위 MAT_000242·모조 80g)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000242", note: "미색 모조지 점착지·부모 MAT_000242 note '정정 2026-06-14 종이(.01)→스티커(.11)'·승격 후보"}

### [material-MAT_000611] 아트스티커 90g {verified}
- type: material
- anchor: t_mat_materials/MAT_000611
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000611 (MAT_TYPE.11·상위 MAT_000610)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.11", upr_mat_cd: "MAT_000610", 사양_ref: "전사표 MAT_000611(아트 90g)", note: "아트지 점착지·비코팅·승격 후보"}

## 셋트 계열 공유 자재 (면지·D링) — Stage A(okb-knowledge-builder 260703)

<!-- 셋트 공유축: 면지 자재(MAT_TYPE.04·072/082/088 면지멤버 색 택1)+D링 자재(088 USAGE.07 불가침). -->
<!-- ★면지 재설계(2026-07-03): 면지 색이 부모→면지멤버로 이관(fn_chk_opt_item_ref 정합·색 내부 택1·기본 화이트). -->
<!-- ★[HARD] 면지 자재는 기여 0(무가격·제본비 포함)이어도 삭제 금지=선택지(pack §3.5). D링(USAGE.07)은 불가침 보존(은퇴 아님). -->
<!-- transcribed-by: _meta/scripts/transcribe_set_axis_260703.py(수동 확장 awk t_mat_materials) from live-snapshot/latest (snap_20260702_1119) @ 2026-07-03 -->

### [material-MAT_000382] 화이트면지 {verified}
- type: material
- anchor: t_mat_materials/MAT_000382
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000382 (MAT_TYPE.04·상위 MAT_000001·2026-06-27 신설·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "MAT_000001", note: "★면지 색(기본·072/082/088 면지멤버 074/084/090 택1·용지 드롭다운 dflt). 무가격(제본비 포함·기여0). 면지멤버 귀속(fn_chk_opt_item_ref 정합·재설계 2026-07-03). uses_material 배선=면지 member 노드(Stage B)."}

### [material-MAT_000383] 블랙면지 {verified}
- type: material
- anchor: t_mat_materials/MAT_000383
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000383 (MAT_TYPE.04·상위 MAT_000001·2026-06-27 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "MAT_000001", note: "면지 색(블랙·072/082/088 면지멤버 택1). 무가격·면지멤버 귀속."}

### [material-MAT_000384] 그레이면지 {verified}
- type: material
- anchor: t_mat_materials/MAT_000384
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000384 (MAT_TYPE.04·상위 MAT_000001·2026-06-27 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "MAT_000001", note: "면지 색(그레이·072=3색 382/383/384 완결·082/088=4색 +385). 무가격·면지멤버 귀속."}

### [material-MAT_000385] 인쇄면지 {verified}
- type: material
- anchor: t_mat_materials/MAT_000385
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000385 (MAT_TYPE.04·상위 MAT_000001·2026-06-27 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "MAT_000001", note: "면지 4번째 색(082/088 4택1). ★기여 0이나 선택지로 보존. 인쇄면지 인쇄비 배선(D-3)은 후속=gaps.md#gap-set-print-membrane."}

### [material-MAT_000247] D링(31mm) {verified}
- type: material
- anchor: t_mat_materials/MAT_000247
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000247 (MAT_TYPE.07·상위 MAT_000017·2026-06-03·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.07", upr_mat_cd: "MAT_000017", note: "★[HARD] 088 레더 링바인더 D링(USAGE.07 불가침·활성 3 불변). 면지 재설계(USAGE.03)가 미터치·격리(088-post-verify §4). 은퇴 아님."}

### [material-MAT_000248] D링(42mm) {verified}
- type: material
- anchor: t_mat_materials/MAT_000248
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000248 (MAT_TYPE.07·상위 MAT_000017·2026-06-03)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.07", upr_mat_cd: "MAT_000017", note: "★[HARD] 088 D링(USAGE.07 불가침·활성 보존)."}

### [material-MAT_000249] D링 {verified}
- type: material
- anchor: t_mat_materials/MAT_000249
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "테이블:t_mat_materials 키:MAT_000249 (MAT_TYPE.04·상위 없음·2026-06-03·upd 2026-06-29·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "", note: "★[HARD] 088 D링 자재(USAGE.07 불가침). mat_typ .04(247/248의 .07과 상이·라이브 실값 전사·단정 금지)."}

## 셋트 계열 표지·내지·링·캘린더 자재 — Stage C1(okb-knowledge-builder 260703)

<!-- 셋트/책자/캘린더 계열이 쓰는 표지·내지 종이·트윈링·캘린더 용지. Stage B가 프로즈로만 기록·엣지 미배선. -->
<!-- Stage C1=노드 mint·Stage C2=상품/구성원→자재(R3 uses_material) 엣지 배선. 규격/평량은 전사표에만(D-9·§4). -->
<!-- ★[HARD] 트윈링 링자재(MAT_000013/014/015·082 USAGE.07)=불가침·은퇴 금지(pack §3.5). -->
<!-- ★일부 마스터 del_yn=Y(논리삭제)이나 상품 정션(t_prd_product_materials) 활성=load-bearing → 노드 보존·note 정직 표기. -->
<!-- ★규격/평량 미기재 자재(전용지·레더·링·하드커버 등 별색/비종이·구자재)는 마스터 원천 공란 → 날조 0·미상 정직(GAP). -->
<!-- transcribed-by: _meta/scripts/transcribe_set_axis_c1_260703.py materials from live-snapshot/latest (snap_20260702_1119) t_mat_materials @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 상위 | 마스터del |
|---|---|---|---|---|---|---|
| MAT_000246 | 전용지 | MAT_TYPE.01 | 미기재 | 미기재 | - | Y |
| MAT_000379 | 레더(화이트) | MAT_TYPE.05 | 미기재 | 미기재 | MAT_000186 | N |
| MAT_000073 | 백색모조지 120g | MAT_TYPE.01 | 316x467 | 120 | MAT_000071 | N |
| MAT_000076 | 아트지 100g | MAT_TYPE.01 | 316x467 | 100 | MAT_000075 | N |
| MAT_000077 | 아트지 120g | MAT_TYPE.01 | 316x467 | 120 | MAT_000075 | N |
| MAT_000086 | 스노우지 100g | MAT_TYPE.01 | 316x467 | 100 | MAT_000085 | N |
| MAT_000087 | 스노우지 120g | MAT_TYPE.01 | 316x467 | 120 | MAT_000085 | N |
| MAT_000095 | 앙상블 100g | MAT_TYPE.01 | 316x467 | 100 | MAT_000094 | N |
| MAT_000104 | 몽블랑 100g | MAT_TYPE.01 | 316x467 | 100 | MAT_000103 | N |
| MAT_000013 | 화이트링 | MAT_TYPE.02 | 미기재 | 미기재 | MAT_000012 | N |
| MAT_000014 | 블랙링 | MAT_TYPE.02 | 미기재 | 미기재 | MAT_000012 | N |
| MAT_000015 | 링 메탈링 | MAT_TYPE.04 | 미기재 | 미기재 | MAT_000012 | Y |
| MAT_000079 | 아트지 180g | MAT_TYPE.01 | 316x467 | 180 | MAT_000075 | N |
| MAT_000080 | 아트지 200g | MAT_TYPE.01 | 316x467 | 200 | MAT_000075 | N |
| MAT_000090 | 스노우지 200g | MAT_TYPE.01 | 316x467 | 200 | MAT_000085 | N |
| MAT_000096 | 앙상블 130g | MAT_TYPE.01 | 316x467 | 130 | MAT_000094 | Y |
| MAT_000106 | 몽블랑 160g | MAT_TYPE.01 | 316x467 | 160 | MAT_000103 | N |
| MAT_000005 | 하드커버 | MAT_TYPE.01 | 미기재 | 미기재 | - | Y |
| MAT_000250 | 아트250+무광코팅 | MAT_TYPE.01 | 미기재 | 미기재 | - | Y |
| MAT_000251 | 그레이 | MAT_TYPE.01 | 미기재 | 미기재 | - | Y |
| MAT_000006 | 레더하드커버 | MAT_TYPE.06 | 미기재 | 미기재 | - | Y |
| MAT_000007 | 소프트커버 | MAT_TYPE.01 | 미기재 | 미기재 | - | Y |
| MAT_000127 | 스타드림 | MAT_TYPE.01 | 316x467 | 240 | - | N |
| MAT_000098 | 앙상블 190g | MAT_TYPE.01 | 316x467 | 190 | MAT_000094 | Y |

### 표지 자재 (USAGE.02)

### [material-MAT_000246] 전용지 (표지·규격 미상) {verified}
- type: material
- anchor: t_mat_materials/MAT_000246
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000246(전용지·MAT_TYPE.01·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000246(규격·평량 마스터 미기재=미상)", note: "073 하드커버책자·082 하드커버링책자 표지 전용지(USAGE.02). ★마스터 del_yn=Y이나 상품 정션 활성=load-bearing → 보존. 규격/평량 미상(원천 공란·날조 0)"}

### [material-MAT_000379] 레더(화이트) (표지·MAT_TYPE.05) {verified}
- type: material
- anchor: t_mat_materials/MAT_000379
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000379(레더(화이트)·MAT_TYPE.05·상위 MAT_000186·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.05", upr_mat_cd: "MAT_000186", 사양_ref: "전사표 MAT_000379(규격·평량 미기재)", note: "078 레더·088 레더링바인더 표지 레더 자재(USAGE.02). 레더=비종이(MAT_TYPE.05·판형 불요). 상위 MAT_000186(레더)"}

### [material-MAT_000005] 하드커버 (표지·규격 미상) {verified}
- type: material
- anchor: t_mat_materials/MAT_000005
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000005(하드커버·MAT_TYPE.01·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000100,MAT_000005) usage_cd=USAGE.02 dflt_yn=Y del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000005(규격·평량 미상)", note: "100 포토북 하드커버 표지(USAGE.02). ★마스터 del_yn=Y이나 정션 활성=load-bearing → 보존·삭제 금지"}

### [material-MAT_000250] 아트250+무광코팅 (표지·규격 미상) {verified}
- type: material
- anchor: t_mat_materials/MAT_000250
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000250(아트250+무광코팅·MAT_TYPE.01·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000100,MAT_000250) usage_cd=USAGE.02 del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000250(규격·평량 미상)", note: "100 포토북 표지(아트지250g+무광코팅 내장·USAGE.02). ★마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [material-MAT_000006] 레더하드커버 (표지·MAT_TYPE.06) {verified}
- type: material
- anchor: t_mat_materials/MAT_000006
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000006(레더하드커버·MAT_TYPE.06·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000100,MAT_000006) usage_cd=USAGE.02 del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.06", 사양_ref: "전사표 MAT_000006(규격·평량 미상)", note: "100 포토북 레더 하드커버 표지(USAGE.02·MAT_TYPE.06 비종이). ★마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [material-MAT_000007] 소프트커버 (표지·규격 미상) {verified}
- type: material
- anchor: t_mat_materials/MAT_000007
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000007(소프트커버·MAT_TYPE.01·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000100,MAT_000007) usage_cd=USAGE.02 del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000007(규격·평량 미상)", note: "100 포토북 소프트커버 표지(USAGE.02). ★마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### 면지 자재 (USAGE.03·무가격)

### [material-MAT_000251] 그레이 (면지·무가격) {verified}
- type: material
- anchor: t_mat_materials/MAT_000251
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000251(그레이·MAT_TYPE.01·규격/평량 공란·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000100,MAT_000251) usage_cd=USAGE.03 del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000251(규격·평량 미상)", note: "100 포토북 면지(USAGE.03·무가격·제본비 포함·기여0). ★셋트 면지멤버(MAT_000382~385·Stage A)와는 별개(100 포토북 전용). 마스터 del_yn=Y이나 정션 활성=load-bearing → 보존·선택지 삭제 금지"}

### 내지 종이 자재 (USAGE.07 / USAGE.01)

### [material-MAT_000073] 백색모조지 120g {verified}
- type: material
- anchor: t_mat_materials/MAT_000073
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000073", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000071", 사양_ref: "전사표 MAT_000073", note: "284/285/286/287 내지·097 부모 본문 종이(USAGE.07/.01). 상위 MAT_000071(백색모조지)"}

### [material-MAT_000076] 아트지 100g {verified}
- type: material
- anchor: t_mat_materials/MAT_000076
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000076", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000075", 사양_ref: "전사표 MAT_000076", note: "284/285/286/287 하드커버 내지 종이(USAGE.07). 상위 MAT_000075(아트지)"}

### [material-MAT_000077] 아트지 120g {verified}
- type: material
- anchor: t_mat_materials/MAT_000077
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000077", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000075", 사양_ref: "전사표 MAT_000077", note: "284/285/286/287 내지·표지군 종이(USAGE.07/.01). 상위 MAT_000075(아트지)"}

### [material-MAT_000079] 아트지 180g {verified}
- type: material
- anchor: t_mat_materials/MAT_000079
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000079", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000075", 사양_ref: "전사표 MAT_000079", note: "책자 표지군 종이(USAGE.01·288/290/292). 상위 MAT_000075(아트지)"}

### [material-MAT_000080] 아트지 200g {verified}
- type: material
- anchor: t_mat_materials/MAT_000080
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000080", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000075", 사양_ref: "전사표 MAT_000080", note: "책자 표지군 종이(USAGE.01). 상위 MAT_000075(아트지)"}

### [material-MAT_000086] 스노우지 100g {verified}
- type: material
- anchor: t_mat_materials/MAT_000086
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000086", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000085", 사양_ref: "전사표 MAT_000086", note: "284/285/286/287 내지 종이(USAGE.07). 상위 MAT_000085(스노우지)"}

### [material-MAT_000087] 스노우지 120g {verified}
- type: material
- anchor: t_mat_materials/MAT_000087
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000087", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000085", 사양_ref: "전사표 MAT_000087", note: "284/285/286/287 내지·표지군 종이(USAGE.07/.01). 상위 MAT_000085(스노우지)"}

### [material-MAT_000090] 스노우지 200g {verified}
- type: material
- anchor: t_mat_materials/MAT_000090
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000090", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000085", 사양_ref: "전사표 MAT_000090", note: "표지군·캘린더 기본용지(스노우지200g). 상위 MAT_000085(스노우지)"}

### [material-MAT_000095] 앙상블 100g {verified}
- type: material
- anchor: t_mat_materials/MAT_000095
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000095", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000094", 사양_ref: "전사표 MAT_000095", note: "284/285/286/287 내지·표지군 종이(USAGE.07/.01). 상위 MAT_000094(앙상블)"}

### [material-MAT_000096] 앙상블 130g (마스터 논리삭제) {verified}
- type: material
- anchor: t_mat_materials/MAT_000096
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000096(앙상블 130g·MAT_TYPE.01·상위 MAT_000094·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000094", 사양_ref: "전사표 MAT_000096", note: "책자 표지군 종이(USAGE.01). ★마스터 del_yn=Y이나 상품 정션 활성=load-bearing → 보존"}

### [material-MAT_000098] 앙상블 190g (마스터 논리삭제) {verified}
- type: material
- anchor: t_mat_materials/MAT_000098
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000098(앙상블 190g·MAT_TYPE.01·상위 MAT_000094·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000094", 사양_ref: "전사표 MAT_000098", note: "캘린더 기본용지(앙상블190g). ★마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [material-MAT_000104] 몽블랑 100g {verified}
- type: material
- anchor: t_mat_materials/MAT_000104
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000104", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000103", 사양_ref: "전사표 MAT_000104", note: "284/285/286/287 내지·표지군 종이(USAGE.07/.01). 상위 MAT_000103(몽블랑)"}

### [material-MAT_000106] 몽블랑 160g {verified}
- type: material
- anchor: t_mat_materials/MAT_000106
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000106", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", upr_mat_cd: "MAT_000103", 사양_ref: "전사표 MAT_000106", note: "책자 표지군 종이(USAGE.01·288/290/292). 상위 MAT_000103(몽블랑)"}

### [material-MAT_000127] 스타드림 (캘린더 기본용지) {verified}
- type: material
- anchor: t_mat_materials/MAT_000127
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000127(스타드림·MAT_TYPE.01·240g·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.01", 사양_ref: "전사표 MAT_000127", note: "캘린더 기본용지 3종의 하나(스타드림 240g). 108~112 캘린더 uses_material 후보(Stage B 배선)"}

### 트윈링 링자재 (USAGE.07·★불가침·은퇴 금지)

### [material-MAT_000013] 화이트링 (트윈링·불가침) {verified}
- type: material
- anchor: t_mat_materials/MAT_000013
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000013(화이트링·MAT_TYPE.02·상위 MAT_000012·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.02", upr_mat_cd: "MAT_000012", 사양_ref: "전사표 MAT_000013(규격·평량 미기재=비종이 링)", note: "★[HARD] 082 하드커버링책자 트윈링 링자재(USAGE.07·불가침·은퇴 금지·pack §3.5). 비종이(MAT_TYPE.02·판형 불요)"}

### [material-MAT_000014] 블랙링 (트윈링·불가침) {verified}
- type: material
- anchor: t_mat_materials/MAT_000014
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000014(블랙링·MAT_TYPE.02·상위 MAT_000012·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.02", upr_mat_cd: "MAT_000012", 사양_ref: "전사표 MAT_000014(규격·평량 미기재)", note: "★[HARD] 082 트윈링 링자재(USAGE.07·불가침·은퇴 금지). 비종이"}

### [material-MAT_000015] 링 메탈링 (트윈링·불가침·마스터 논리삭제) {verified}
- type: material
- anchor: t_mat_materials/MAT_000015
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000015(링 메탈링·MAT_TYPE.04·상위 MAT_000012·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.04", upr_mat_cd: "MAT_000012", 사양_ref: "전사표 MAT_000015(규격·평량 미기재)", note: "★[HARD] 082 트윈링 링자재 계열(불가침·은퇴 금지). 마스터 del_yn=Y이나 링 자재군(MAT_000012 하위)·비종이. 규격/평량 미상"}

## 문구 셋트 자재 (SB-1 Stage A·신규 1종·okb-knowledge-builder 260703)

<!-- 문구 셋트(172~181) 구성원(293~308)이 쓰는 표지·내지·레더 자재 중 어느 파일에도 미민팅인 것은 MAT_000261(무지내지) 1종뿐(search-before-mint 전수). -->
<!-- ★재사용(이미 mint·재-mint 금지·L-3): MAT_000072 백색모조지100g(product/product-041-coupon-axes.md)·MAT_000186 레더(product/product-126-leather-artprint-nodes.md)· -->
<!--   MAT_000073 백색모조지120g·MAT_000250 아트250+무광코팅·MAT_000379 레더화이트(materials.md 기존). Stage B 구성원 노드는 이 기존 id를 그대로 uses_material로 배선. -->
<!--   ※MAT_000072/186은 현재 product 파일 소유(로컬 프리셋)=L-20 소프트 후보. 공유 축 re-home은 architect 소관(Stage A는 재-mint 안 함). -->
<!-- ★무지내지(MAT_TYPE.21)는 내지 종이. 규격/평량 미기재는 마스터 원천 공란(날조 0·미상 정직). -->
<!-- ★상품/구성원→자재(R3 uses_material) 엣지는 Stage B(구성원 노드)가 배선. Stage A는 자재 노드 mint만. -->
<!-- transcribed-by: _meta/scripts/transcribe_stationery_axis_260703.py(수동 확장 awk t_mat_materials) from live-snapshot/latest (snap_20260702_1119) @ 2026-07-03 -->
| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 상위 | 마스터del | 상태 |
|---|---|---|---|---|---|---|---|
| MAT_000261 | 무지내지 | MAT_TYPE.21 | 미기재 | 미기재 | - | N | 신규 mint |
| MAT_000072 | 백색모조지 100g | MAT_TYPE.01 | 316x467 | 100 | MAT_000071 | N | 재사용(product-041) |
| MAT_000186 | 레더 | MAT_TYPE.05 | 미기재 | 미기재 | - | N | 재사용(product-126) |

### [material-MAT_000261] 무지내지 (내지·MAT_TYPE.21) {verified}
- type: material
- anchor: t_mat_materials/MAT_000261
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000261(무지내지·MAT_TYPE.21·규격/평량 공란·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000302/304/306/308,MAT_000261) usage_cd=USAGE.01(정션 활성·내지 대표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.21", 사양_ref: "전사표 MAT_000261(규격·평량 마스터 미기재)", note: "무지 내지 자재(302 스프링노트·304 스프링수첩·306 메모패드·308 중철노트 내지 USAGE.01). 무지 내지 4종 공용. ★min/max 미설정(커스텀인쇄 확장 예정)=gap-stn-muji-inner-minmax. 규격/평량 미상(원천 공란)"}

## 굿즈/파우치 자재 — Stage C1(okb-knowledge-builder 260704)

<!-- goods-needs-axis material 9줄 → dedup 8 unique. 이미 product-local canonical 4종 skip(consolidation은 C2/architect): MAT_000262 틴거울(product-183)·MAT_000185 캔버스(product-125)·MAT_000184 린넨(product-134)·MAT_000183 메쉬(product-128). 나머지 4 mint. -->
<!-- uses_material(product→material)는 상품 노드(Stage C2)가 배선. C1은 축 노드만 mint. 규격/평량 없음(본체 substrate·마스터 공란)→props에 mat_typ_cd만. -->

### [material-MAT_000268] 머그컵 (11온스) {verified}
- type: material
- anchor: t_mat_materials/MAT_000268
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000268(머그컵 (11온스)·mat_typ_cd MAT_TYPE.12·규격/평량 공란·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.12", note: "머그컵 본체 substrate(193 uses_material 배선 대상). 비종이 굿즈 본체·규격/평량 마스터 공란"}

### [material-MAT_000269] 워터북보틀 {verified}
- type: material
- anchor: t_mat_materials/MAT_000269
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000269(워터북보틀·mat_typ_cd MAT_TYPE.12·규격/평량 공란·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.12", note: "워터북보틀 본체 substrate(194 uses_material 배선 대상). 500ml 변형=MAT_000343"}

### [material-MAT_000343] 워터북보틀 500ml {verified}
- type: material
- anchor: t_mat_materials/MAT_000343
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000343(워터북보틀 500ml·mat_typ_cd MAT_TYPE.12·규격/평량 공란·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.12", note: "워터북보틀 500ml 변형 substrate(194). 기본형=MAT_000269"}

### [material-MAT_000008] 레더 (마스터 논리삭제·load-bearing) {verified}
- type: material
- anchor: t_mat_materials/MAT_000008
- src: {source_file: "live-snapshot/latest/t_mat_materials.csv", source_locator: "키:MAT_000008(레더·mat_typ_cd MAT_TYPE.06·sel_typ_cd SEL_TYPE.01·규격/평량 공란·use_yn=Y·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_materials.csv", source_locator: "키:(PRD_000251,MAT_000008) usage_cd=USAGE.07(정션 활성·레더 substrate 대표)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {mat_typ_cd: "MAT_TYPE.06", note: "★레더(가죽) substrate — 레더파우치/미니파우치/필통 등 다수 굿즈 공통 자재(uses_material 배선 대상). 마스터 del_yn=Y이나 정션(예 251) 활성=load-bearing → 보존(CAT_000116·SIZ_000196 선례). 263/264 등 실 substrate"}
