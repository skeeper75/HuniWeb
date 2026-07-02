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
