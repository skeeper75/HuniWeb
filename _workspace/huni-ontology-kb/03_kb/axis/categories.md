<!-- axis page: E2 category — 디지털인쇄 파일럿 8상품이 속한 분류 노드. 1 파일 = N 블록(### [id] {badge}). -->
<!-- 파싱 규칙: file-format-spec §1.2·graph-build §3.1(### [ID] 블록). 수치 없음(분류 라벨만). -->

# 축: 카테고리 (category)

디지털인쇄 파일럿이 걸리는 라이브 분류(t_cat_categories). 상품→분류 연결(R1 `in_category`)은
상품 노드(Phase 4)가 건다. 여기서는 분류 노드만 선언한다. 카테고리→상위 카테고리 관계는
스키마 19종에 없으므로(부모 링크 미표현) props의 `upr_cat_cd`로만 기록한다.

### [category-CAT_000307] 엽서 {verified}
- type: category
- anchor: t_cat_categories/CAT_000307
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000307", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "엽서", cat_lvl: 2, upr_cat_cd: "CAT_000001"}

### [category-CAT_000310] 포토카드 {verified}
- type: category
- anchor: t_cat_categories/CAT_000310
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000310", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "포토카드", cat_lvl: 2, upr_cat_cd: "CAT_000001"}

### [category-CAT_000021] 접지카드 {verified}
- type: category
- anchor: t_cat_categories/CAT_000021
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000021", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "접지카드", cat_lvl: 2, upr_cat_cd: "CAT_000001"}

### [category-CAT_000313] 명함 {verified}
- type: category
- anchor: t_cat_categories/CAT_000313
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000313", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "명함", cat_lvl: 2, upr_cat_cd: "CAT_000003"}

### [category-CAT_000062] 쿠폰/상품권 {verified}
- type: category
- anchor: t_cat_categories/CAT_000062
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000062", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "쿠폰/상품권", cat_lvl: 2, upr_cat_cd: "CAT_000003"}

### [category-CAT_000327] 인쇄포장재 {verified}
- type: category
- anchor: t_cat_categories/CAT_000327
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000327", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "인쇄포장재", cat_lvl: 2, upr_cat_cd: "CAT_000012"}
- 본문: 인쇄배경지(043/044)·헤더택(045)·라벨택(046) 포장 계열. 팩 §3.1 "배경지=카테고리 012 포장 세트".

### [category-CAT_000003] 인쇄홍보물 {verified}
- type: category
- anchor: t_cat_categories/CAT_000003
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000003", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "인쇄홍보물", cat_lvl: 1, upr_cat_cd: ""}

### [category-CAT_000001] 엽서/카드 {verified}
- type: category
- anchor: t_cat_categories/CAT_000001
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000001", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "엽서/카드", cat_lvl: 1, upr_cat_cd: ""}


<!-- 스티커 공유 원자(consolidation 2026-07-03·병렬 product-local L-3 중복을 단일 소유권으로 이관·consolidate_sticker_axes.py) -->

### [category-CAT_000002] 스티커 (root) {verified}
- type: category
- anchor: t_cat_categories/CAT_000002
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000002 (스티커·cat_lvl 1·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "스티커", cat_lvl: 1, upr_cat_cd: "", note: "스티커 root·main_cat_yn=Y(052)·공유 axis/categories 미등재 → needed_shared_node(스티커 16상품 공용)"}

### [category-CAT_000037] 규격스티커 (승격 대기) {verified}
- type: category
- anchor: t_cat_categories/CAT_000037
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000037 (upr_cat_cd=CAT_000002)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "규격스티커", upr_cat_cd: "CAT_000002", note: "060 부 카테고리(main_cat_yn=N·상위 스티커). 규격형 스티커(058~062 family) 공유 축 승격 후보"}

### [category-CAT_000309] 자유형스티커 {verified}
- type: category
- anchor: t_cat_categories/CAT_000309
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000309 (자유형스티커·cat_lvl 2·상위 CAT_000002·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "자유형스티커", cat_lvl: 2, upr_cat_cd: "CAT_000002", note: "052 sub 카테고리(main_cat_yn=N)·승격 후보"}

### [category-CAT_000311] 특수스티커 {verified}
- type: category
- anchor: t_cat_categories/CAT_000311
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "테이블:t_cat_categories 키:CAT_000311 (특수스티커·cat_lvl 2·상위 CAT_000002·del_yn=N·2026-06-19 신설)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "특수스티커", cat_lvl: 2, upr_cat_cd: "CAT_000002", note: "067 sub 카테고리(main_cat_yn=N·067 disp 없음)·타투스티커 등 특수 스티커류·승격 후보"}

### [category-CAT_000312] 스티커팩 (cat_lvl 2·상위 스티커) {verified}
- type: category
- anchor: t_cat_categories/CAT_000312
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000312(스티커팩·upr_cat_cd=CAT_000002·cat_lvl 2·disp_seq 3·use_yn=Y·del_yn=N·2026-06-19 mint)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000065,CAT_000312) main_cat_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_cd: "CAT_000312", cat_nm: "스티커팩", upr_cat_cd: "CAT_000002", cat_lvl: "2", note: "스티커 root(CAT_000002·[[category-CAT_000002]]) 하위 2단 분류. 065만 이 분류에 속함(product-local·공유 axis/categories.md 미등재·승격 대기 needed_shared)"}
- 본문: 스티커팩 분류(스티커 root의 자식). [[sticker-pack]] in_category 대상. 상위 스티커(CAT_000002)는 공유 재사용.


## 셋트 계열 공유 카테고리 — Stage C1(okb-knowledge-builder 260703)

<!-- 셋트/책자/캘린더 계열 상품이 걸리는 분류. Stage B가 프로즈로만 기록·엣지 미배선(브로큰링크 회피). -->
<!-- Stage C1=노드 mint(여기)·Stage C2=상품→분류(R1 in_category) 엣지 배선. 수치 없음(분류 라벨만). -->
<!-- ★일부 마스터 del_yn=Y(논리삭제)이나 상품 정션(t_prd_product_categories) 활성=load-bearing → 노드 보존·note에 정직 표기. -->

### [category-CAT_000006] 책자 (booklet 최상위) {verified}
- type: category
- anchor: t_cat_categories/CAT_000006
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000006(책자·cat_lvl 1·disp 6·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "책자", cat_lvl: 1, upr_cat_cd: "", note: "책자 최상위 분류(068/069/070 in_category 상위·CAT_000316 일반책자의 부모)"}

### [category-CAT_000316] 일반책자 (⊂책자) {verified}
- type: category
- anchor: t_cat_categories/CAT_000316
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000316(일반책자·cat_lvl 2·상위 CAT_000006·disp 1·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "일반책자", cat_lvl: 2, upr_cat_cd: "CAT_000006", note: "068/069/070 중철/무선/PUR 책자 셋트 main_cat_yn=Y 소속"}

### [category-CAT_000105] 하드커버책자 {verified}
- type: category
- anchor: t_cat_categories/CAT_000105
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000105(하드커버책자·cat_lvl 3·상위 CAT_000104·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "하드커버책자", cat_lvl: 3, upr_cat_cd: "CAT_000104", note: "072/073/074 하드커버책자 셋트 분류·082/088 상위(공유·main_cat_yn=N)"}

### [category-CAT_000106] 레더하드커버책자 {verified}
- type: category
- anchor: t_cat_categories/CAT_000106
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000106(레더하드커버책자·cat_lvl 3·상위 CAT_000104·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "레더하드커버책자", cat_lvl: 3, upr_cat_cd: "CAT_000104", note: "077 레더 하드커버책자 전용 분류"}

### [category-CAT_000107] 하드커버링책자 {verified}
- type: category
- anchor: t_cat_categories/CAT_000107
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000107(하드커버링책자·cat_lvl 3·상위 CAT_000104·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "하드커버링책자", cat_lvl: 3, upr_cat_cd: "CAT_000104", note: "082 하드커버링책자(트윈링) main category"}

### [category-CAT_000008] 문구 {verified}
- type: category
- anchor: t_cat_categories/CAT_000008
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000008(문구·cat_lvl 1·disp 8·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "문구", cat_lvl: 1, upr_cat_cd: "", note: "088 레더링바인더 main·097 떡메모지 disp_seq2 소속. 노트(CAT_000124)의 부모"}

### [category-CAT_000124] 노트 {verified}
- type: category
- anchor: t_cat_categories/CAT_000124
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000124(노트·cat_lvl 2·상위 CAT_000008·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "노트", cat_lvl: 2, upr_cat_cd: "CAT_000008", note: "094 엽서북 부·097 떡메모지 부 카테고리. 떡메모지(CAT_000129)의 부모"}

### [category-CAT_000308] 엽서북 (094 주) {verified}
- type: category
- anchor: t_cat_categories/CAT_000308
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000308(엽서북·cat_lvl 2·상위 CAT_000001·disp 2·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "엽서북", cat_lvl: 2, upr_cat_cd: "CAT_000001", note: "094 엽서북 주카테고리(엽서/카드 CAT_000001 하위)"}

### [category-CAT_000026] 엽서북 (095/096 구성원·마스터 논리삭제) {verified}
- type: category
- anchor: t_cat_categories/CAT_000026
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000026(엽서북·cat_lvl 2·상위 CAT_000001·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000095,CAT_000026)·(PRD_000096,CAT_000026) del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "엽서북", cat_lvl: 2, upr_cat_cd: "CAT_000001", note: "★095/096 엽서북 구성원 카테고리. 마스터 del_yn=Y(논리삭제)이나 상품 정션 활성=load-bearing → 삭제 금지·정리 워크리스트(신규 CAT_000308과 중복 정리 실무진 판정)"}

### [category-CAT_000129] 떡메모지 (097 주·098·마스터 논리삭제) {verified}
- type: category
- anchor: t_cat_categories/CAT_000129
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000129(떡메모지·cat_lvl 3·상위 CAT_000124·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000098,CAT_000129) del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "떡메모지", cat_lvl: 3, upr_cat_cd: "CAT_000124", note: "★097 떡메모지 주·098 카테고리. 마스터 del_yn=Y이나 상품 정션 활성=load-bearing → 보존·삭제 금지"}

### [category-CAT_000112] 탁상형캘린더 {verified}
- type: category
- anchor: t_cat_categories/CAT_000112
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000112(탁상형캘린더·cat_lvl 2·상위 CAT_000007·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "탁상형캘린더", cat_lvl: 2, upr_cat_cd: "CAT_000007", note: "108 탁상형캘린더 분류(캘린더 CAT_000007 하위)"}

### [category-CAT_000113] 미니탁상형캘린더 (마스터 논리삭제) {verified}
- type: category
- anchor: t_cat_categories/CAT_000113
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000113(미니탁상형캘린더·cat_lvl 2·상위 CAT_000007·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000109,CAT_000113) del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "미니탁상형캘린더", cat_lvl: 2, upr_cat_cd: "CAT_000007", note: "★109 미니탁상캘린더 분류. 마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [category-CAT_000114] 엽서캘린더 (마스터 논리삭제) {verified}
- type: category
- anchor: t_cat_categories/CAT_000114
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000114(엽서캘린더·cat_lvl 2·상위 CAT_000007·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000110,CAT_000114) del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "엽서캘린더", cat_lvl: 2, upr_cat_cd: "CAT_000007", note: "★110 엽서캘린더 분류. 마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [category-CAT_000115] 벽걸이캘린더 {verified}
- type: category
- anchor: t_cat_categories/CAT_000115
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000115(벽걸이캘린더·cat_lvl 2·상위 CAT_000007·disp 1·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "벽걸이캘린더", cat_lvl: 2, upr_cat_cd: "CAT_000007", note: "111 벽걸이캘린더 분류·와이드벽걸이(CAT_000116)의 부모"}

### [category-CAT_000116] 와이드벽걸이캘린더 (마스터 논리삭제) {verified}
- type: category
- anchor: t_cat_categories/CAT_000116
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000116(와이드벽걸이캘린더·cat_lvl 3·상위 CAT_000115·del_yn=Y)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000112,CAT_000116) del_yn=N(정션 활성)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "와이드벽걸이캘린더", cat_lvl: 3, upr_cat_cd: "CAT_000115", note: "★112 와이드벽걸이캘린더 분류. 마스터 del_yn=Y이나 정션 활성=load-bearing → 보존"}

### [category-CAT_000118] 디자인캘린더 {verified}
- type: category
- anchor: t_cat_categories/CAT_000118
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000118(디자인캘린더·cat_lvl 2·상위 CAT_000007·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "디자인캘린더", cat_lvl: 2, upr_cat_cd: "CAT_000007", note: "디자인캘린더 분류(캘린더 CAT_000007 하위·캘린더 6종 축의 하나)"}

## 문구 셋트(SB-1) 카테고리 — Stage C1(okb-knowledge-builder 260703)

<!-- 만년다이어리 클러스터(172~175·293~298) + 먼슬리플래너(176) 유일 카테고리 축. 문구 CAT_000008 하위. -->
<!-- in_category(product→category·R?)는 상품 노드(Stage B/C2)가 배선. C1은 축 노드만 mint. dedup: stn-needs-axis 2줄→1노드. -->

### [category-CAT_000321] 플래너 (문구 하위) {verified}
- type: category
- anchor: t_cat_categories/CAT_000321
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000321(플래너·cat_lvl 2·상위 CAT_000008·disp_seq 1·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "플래너", cat_lvl: 2, upr_cat_cd: "CAT_000008", note: "만년다이어리 클러스터(172~175·293~298 완제품 10노드) + 먼슬리플래너(176)의 카테고리 축. 문구(CAT_000008) 하위. in_category는 상품 노드(Stage C2)가 배선"}

## 굿즈/파우치/봉투 카테고리 — Stage C1(okb-knowledge-builder 260704)

<!-- goods-needs-axis category 33줄 → dedup 24 unique. CAT_000181(여행/아웃도어)는 product-051-suncap이 이미 노드로 소유(canonical) → skip(L-3 중복 회피·consolidation은 C2/architect). 나머지 23 mint. -->
<!-- in_category(product→category)는 상품 노드(Stage C2)가 배선. C1은 축 노드만 mint. upr_cat_cd는 props만(카테고리→상위 관계는 스키마 19종에 없음). -->

### [category-CAT_000276] 봉투/케이스 {verified}
- type: category
- anchor: t_cat_categories/CAT_000276
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000276(봉투/케이스·cat_lvl 2·상위 CAT_000012·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "봉투/케이스", cat_lvl: 2, upr_cat_cd: "CAT_000012", note: "001/002/005/283 in_category 대상(봉투 계열)"}

### [category-CAT_000285] 포장부자재 {verified}
- type: category
- anchor: t_cat_categories/CAT_000285
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000285(포장부자재·cat_lvl 2·상위 CAT_000012·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "포장부자재", cat_lvl: 2, upr_cat_cd: "CAT_000012", note: "011 in_category 대상"}

### [category-CAT_000287] 상품액세서리 {verified}
- type: category
- anchor: t_cat_categories/CAT_000287
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000287(상품액세서리·cat_lvl 2·상위 CAT_000012·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "상품액세서리", cat_lvl: 2, upr_cat_cd: "CAT_000012", note: "015 in_category 대상"}

### [category-CAT_000130] 홀더/클립보드 {verified}
- type: category
- anchor: t_cat_categories/CAT_000130
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000130(홀더/클립보드·cat_lvl 2·상위 CAT_000008·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "홀더/클립보드", cat_lvl: 2, upr_cat_cd: "CAT_000008", note: "215/216/218 in_category 대상(문구 하위)"}

### [category-CAT_000010] 라이프 (root) {verified}
- type: category
- anchor: t_cat_categories/CAT_000010
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000010(라이프·cat_lvl 1·root·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "라이프", cat_lvl: 1, upr_cat_cd: "", note: "굿즈 공통 root 카테고리(전 굿즈 상품 다수 공유·타 family 재사용). lvl2 데코소품/여행/패션/생활소품/응원시즌/기념품/폰케이스의 부모"}

### [category-CAT_000328] 데코소품 {verified}
- type: category
- anchor: t_cat_categories/CAT_000328
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000328(데코소품·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "데코소품", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "193/194/195 in_category 대상"}

### [category-CAT_000206] 패션 {verified}
- type: category
- anchor: t_cat_categories/CAT_000206
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000206(패션·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "패션", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "205/206/209 in_category 대상"}

### [category-CAT_000323] 생활소품 {verified}
- type: category
- anchor: t_cat_categories/CAT_000323
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000323(생활소품·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "생활소품", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "207/212 in_category 대상"}

### [category-CAT_000198] 응원/시즌 {verified}
- type: category
- anchor: t_cat_categories/CAT_000198
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000198(응원/시즌·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "응원/시즌", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "208·227/228/229(보조) in_category 대상"}

### [category-CAT_000134] 데스크소품 {verified}
- type: category
- anchor: t_cat_categories/CAT_000134
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000134(데스크소품·cat_lvl 2·상위 CAT_000008·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "데스크소품", cat_lvl: 2, upr_cat_cd: "CAT_000008", note: "210/211·213/214/217 in_category 대상(문구 하위)"}

### [category-CAT_000189] 기념품/액세서리 {verified}
- type: category
- anchor: t_cat_categories/CAT_000189
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000189(기념품/액세서리·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "기념품/액세서리", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "200/201/202/203/204·221/222/223 in_category 대상"}

### [category-CAT_000210] 폰케이스&액세서리 {verified}
- type: category
- anchor: t_cat_categories/CAT_000210
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000210(폰케이스&액세서리·cat_lvl 2·상위 CAT_000010·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "폰케이스&액세서리", cat_lvl: 2, upr_cat_cd: "CAT_000010", note: "219/220 in_category 대상"}

### [category-CAT_000009] 아크릴 (root) {verified}
- type: category
- anchor: t_cat_categories/CAT_000009
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000009(아크릴·cat_lvl 1·root·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "아크릴", cat_lvl: 1, upr_cat_cd: "", note: "226 main 카테고리 root. 코롯토(CAT_000159)의 부모"}

### [category-CAT_000159] 코롯토 {verified}
- type: category
- anchor: t_cat_categories/CAT_000159
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000159(코롯토·cat_lvl 2·상위 CAT_000009·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "코롯토", cat_lvl: 2, upr_cat_cd: "CAT_000009", note: "226 보조 카테고리(아크릴 하위)"}

### [category-CAT_000011] 에코백 (root) {verified}
- type: category
- anchor: t_cat_categories/CAT_000011
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000011(에코백·cat_lvl 1·root·main_cat_yn=Y·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "에코백", cat_lvl: 1, upr_cat_cd: "", note: "굿즈 봉제(파우치/백) root. 전 파우치/에코백 상품 공통 상위. 레더파우치/미니파우치/필통/패브릭/타이벡/메쉬 파우치·타이벡/메쉬에코백의 부모. 261~275·277·278 main 분류"}

### [category-CAT_000324] 레더파우치 {verified}
- type: category
- anchor: t_cat_categories/CAT_000324
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000324(레더파우치·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "레더파우치", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "230~238 in_category 대상"}

### [category-CAT_000237] 미니파우치 {verified}
- type: category
- anchor: t_cat_categories/CAT_000237
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000237(미니파우치·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "미니파우치", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "251~255 in_category 대상"}

### [category-CAT_000243] 필통 {verified}
- type: category
- anchor: t_cat_categories/CAT_000243
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000243(필통·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "필통", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "256~260 in_category 대상"}

### [category-CAT_000222] 패브릭파우치 {verified}
- type: category
- anchor: t_cat_categories/CAT_000222
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000222(패브릭파우치·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "패브릭파우치", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "239/240/241/242 in_category 대상(리프)"}

### [category-CAT_000228] 타이벡파우치 {verified}
- type: category
- anchor: t_cat_categories/CAT_000228
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000228(타이벡파우치·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "타이벡파우치", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "244/245/246/247/248 in_category 대상(리프)"}

### [category-CAT_000234] 메쉬파우치 {verified}
- type: category
- anchor: t_cat_categories/CAT_000234
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000234(메쉬파우치·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "메쉬파우치", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "249/250 in_category 대상(리프)"}

### [category-CAT_000263] 타이벡에코백 {verified}
- type: category
- anchor: t_cat_categories/CAT_000263
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000263(타이벡에코백·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "타이벡에코백", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "276 main 분류 in_category 대상"}

### [category-CAT_000269] 메쉬에코백 {verified}
- type: category
- anchor: t_cat_categories/CAT_000269
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000269(메쉬에코백·cat_lvl 2·상위 CAT_000011·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "메쉬에코백", cat_lvl: 2, upr_cat_cd: "CAT_000011", note: "279 main 분류 in_category 대상"}

## 아크릴 굿즈 카테고리 (SA-6 Stage A 공유축 260704)

<!-- 2026-07-04 SA-6 공유축(okb-knowledge-builder·pack-acrylic §5.2): 아크릴 굿즈(146~166·226)가 걸리는 분류. -->
<!-- ★search-before-mint: CAT_000009(아크릴 root)·CAT_000159(코롯토)는 226 굿즈팩이 이미 민팅함(위쪽 블록 재사용·여기 재-mint 금지). SA-6 신규 = CAT_000322(단품형)·CAT_000155(조합형)만. -->
<!-- 라이브 혼재(단품형/조합형/코롯토가 아크릴 루트 CAT_000009 하위·상품별 leaf는 다수 del_yn=Y). in_category는 상품 노드(Stage B). -->
<!-- transcribed-by: live-snapshot/latest t_cat_categories.csv (snap_20260702_1119·cat_nm·upr_cat_cd·cat_lvl·use_yn=Y·del_yn=N 전수 실측) @ 2026-07-04 -->

### [category-CAT_000322] 단품형 {verified}
- type: category
- anchor: t_cat_categories/CAT_000322
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000322(단품형·cat_lvl 2·상위 CAT_000009·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "단품형", cat_lvl: 2, upr_cat_cd: "CAT_000009", note: "단품 아크릴(키링/마그넷/뱃지 등). 상품 in_category 대상(Stage B)."}

### [category-CAT_000155] 조합형 {verified}
- type: category
- anchor: t_cat_categories/CAT_000155
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000155(조합형·cat_lvl 2·상위 CAT_000009·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "조합형", cat_lvl: 2, upr_cat_cd: "CAT_000009", note: "조합 아크릴(자유형스탠드/판아크릴/포카스탠드 등·157/158/160/161/162 계열). 상품 in_category 대상(Stage B)."}

### [category-CAT_000163] 액세서리 {verified}
- type: category
- anchor: t_cat_categories/CAT_000163
- src: {source_file: "live-snapshot/latest/t_cat_categories.csv", source_locator: "키:CAT_000163(액세서리·cat_lvl 2·상위 CAT_000009 아크릴·use_yn=Y·del_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- src: {source_file: "live-snapshot/latest/t_prd_product_categories.csv", source_locator: "키:(PRD_000163,CAT_000163) main_cat_yn=N·del_yn=N(정션 실재)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- props: {cat_nm: "액세서리", cat_lvl: 2, upr_cat_cd: "CAT_000009", note: "아크릴 액세서리 leaf. 163 아크릴미니파츠 in_category 대상(260704 Stage C 민팅·needs_axis 반환분)."}

<!-- CAT_000009(아크릴 root)·CAT_000159(코롯토)는 위쪽(226 굿즈팩 민팅) 블록 재사용 — 여기 재정의 금지(search-before-mint). 코롯토 계열=164/165/168/226 등 in_category CAT_000159. -->

