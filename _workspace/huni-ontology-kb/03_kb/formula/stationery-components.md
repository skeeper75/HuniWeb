<!-- axis page: E10 price_component — 문구 셋트 계열 가격구성요소(마스터 t_prc_price_components). SB-1 Stage A 공유축(okb-knowledge-builder 260703). -->
<!-- ★use_dims=차원 선언(D-18 경계·["siz_cd","min_qty"])·값 계산=evaluate_set_price 권위. 단가행(t_prc_component_prices)은 노드 미펼침·속성 접기(D-22). -->
<!-- ★9 완제품가 comp = 전부 PRICE_TYPE.01·PRC_COMPONENT_TYPE.06·단가행 sparse(1~2셀)·gap-stn-sparse-grid 라우팅. -->
<!-- ★공식→구성요소 배선(has_component·R9)은 stationery-formulas.md(각 PRF_STN_* → COMP_STN_* 1:1). -->

# 축: 문구 셋트 가격구성요소 (price_component — 문구 셋트 계열)

문구 셋트 부모공식의 부품. 전부 **완제품가 comp**(고정가형·부모 all-in)로, 상품 1권당 가격을
`[siz_cd,min_qty]` 차원으로 룩업한다. use_dims는 차원 선언까지만 — 값 계산은 `evaluate_set_price`
단일 권위(온톨로지 밖·D-18). 공식→구성요소 배선은 R9 `has_component`(stationery-formulas.md).

★**단가행 sparse(T-9·D-22):** 9 완제품가 comp의 `component_prices` 단가행이 **1~2셀만**(179
메모패드만 2셀·나머지 8종은 1셀). 즉 등록된 한두 사이즈 외에는 견적이 0 → 각 노드 `단가행` 속성에
셀수 기록 + `[[../rule/gaps.md#gap-stn-sparse-grid]]` 라우팅. 단가값(unit_price)은 접어서 미전사(L-12·
D-22) — 셀수만 결정론 전사. 공유 grid 충전은 GAP(상품마스터 문구 시트·§26/dbmap).

<!-- transcribed-by: _meta/scripts/transcribe_stationery_axis_260703.py from live-snapshot/latest (snap_20260702_1119) t_prc_component_prices @ 2026-07-03 (셀수만·단가값 미전사 L-12) -->

## 만년다이어리 계열 완제품가

### [component-COMP_STN_DIARY_SOFT] 만년다이어리(소프트커버) 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_DIARY_SOFT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_DIARY_SOFT·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "172 만년다이어리(소프트커버) 완제품가(사이즈·수량별 1권당). PRF_STN_DIARY_SOFT 배선."}

### [component-COMP_STN_DIARY_HARD] 만년다이어리(하드커버) 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_DIARY_HARD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_DIARY_HARD·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse·130x190만 등록)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse·130x190)", role: "173 만년다이어리(하드커버) 완제품가. PRF_STN_DIARY_HARD 배선. 단가행=130x190 1건뿐."}

### [component-COMP_STN_DIARY_LHARD] 만년다이어리(레더하드커버) 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_DIARY_LHARD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_DIARY_LHARD·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "174 만년다이어리(레더하드커버) 완제품가. PRF_STN_DIARY_LHARD 배선."}

### [component-COMP_STN_DIARY_LSOFT] 만년다이어리(레더소프트커버) 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_DIARY_LSOFT
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_DIARY_LSOFT·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "175 만년다이어리(레더소프트커버) 완제품가. PRF_STN_DIARY_LSOFT 배선."}

## 플래너·노트 계열 완제품가

### [component-COMP_STN_MONTHLY] 먼슬리플래너 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_MONTHLY
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_MONTHLY·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "176 먼슬리플래너 완제품가. PRF_STN_MONTHLY 배선."}

### [component-COMP_STN_SPRINGNOTE] 스프링노트 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_SPRINGNOTE
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_SPRINGNOTE·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "177 스프링노트 완제품가. PRF_STN_SPRINGNOTE 배선(부모 177 분류 conflict=gap-stn-177-classification)."}

### [component-COMP_STN_SPRINGNOTEBK] 스프링수첩 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_SPRINGNOTEBK
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_SPRINGNOTEBK·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "178 스프링수첩 완제품가. PRF_STN_SPRINGNOTEBK 배선."}

### [component-COMP_STN_MEMOPAD] 메모패드 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_MEMOPAD
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_MEMOPAD·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 2셀(sparse·144x206·B5)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "2셀(sparse·144x206·B5 182x257)", role: "179 메모패드 완제품가. PRF_STN_MEMOPAD 배선. ★9 완제품가 comp 중 유일 2셀(그래도 sparse)."}

### [component-COMP_STN_JUNGCHEOL] 중철노트 완제품가 {verified}
- type: price_component
- anchor: t_prc_price_components/COMP_STN_JUNGCHEOL
- src: {source_file: "live-snapshot/latest/t_prc_price_components.csv", source_locator: "키:COMP_STN_JUNGCHEOL·comp_typ PRC_COMPONENT_TYPE.06·prc_typ PRICE_TYPE.01·use_dims [siz_cd,min_qty]·use_yn=Y·del_yn=N", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}
- rel: {rel: references, target: gap-stn-sparse-grid, note: "단가행 1셀(sparse)"}
- props: {prc_typ_cd: "PRICE_TYPE.01", comp_typ_cd: "PRC_COMPONENT_TYPE.06", use_dims: '["siz_cd", "min_qty"]', 단가행: "1셀(sparse)", role: "181 중철노트 완제품가. PRF_STN_JUNGCHEOL 배선."}
