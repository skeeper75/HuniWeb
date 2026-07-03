# 결함 보드 — 실사 가격 경로 완전성 (면적매트릭스 [가로×세로])

> 검증가: okb-adversarial-verifier · 2026-07-03 · 배정 축=실사 28상품(118~145) 가격 경로 완전성
> 방법: `graph.db` 재귀 경로 탐색 + `live-snapshot/latest`(snap_20260702_1119) 결정론 diff + `pricing.py`/`mapping.md` 권위 대조
> 자세: **모든 노드 틀렸다 가정→반증 실패분만 생존.** 생성자 리포트 비신뢰·직접 재실측.

## 요약 판정

**축 PASS (GO)** — 실사 28상품 전부 가격 경로 완전(product→공식→base 구성요소→셀·PRICE≠0·zero 0). 면적매트릭스 13/고정가 15 분기 정확. 동형결합 2그룹 가격 안전(셀 diff 0). High KB 결함 0. Medium 1(라이브 자체 결함, KB는 정직 GAP 처리)·Low 2.

| 심각도 | 건수 |
|--------|------|
| High | 0 |
| Medium | 1 (라이브 원천 결함·KB 정직 surface·source-confirm) |
| Low | 2 |

---

## 반증 실패 = 생존 (PASS 항목·전수 스크립트 증거)

1. **전 28상품 가격 경로 완전** — `product→priced_by→formula→has_component→base comp→component_prices 셀` 전건 연결. 라이브 product→공식이 그래프와 **정확 일치**. base 구성요소 셀수/zero: 전 28상품 **zeros=0**(NONE 0건). 그래프 dangling edge 0·빈 배선 공식 0·고아 공식 0.
2. **면적매트릭스 13상품(118-128·138·139) 완전격자** — 전부 use_dims=`[siz_width,siz_height(,min_qty)]` 선언(그래프 archetype ∩ 라이브 price_components use_dims 일치). 셀: 118/120/121/123/125/126/127/128=52·122=52·124=52·119=39·138=81·139=48, **전 셀 siz_width×siz_height 충전·zero 0**. → mapping.md의 "INSERTABLE 1/BLOCKED 51"(round-13 sparse)·round-2 T-5 오모델은 **라이브 260702에서 이미 완전 적재로 해소**. `grid_full=True` 노드 주장 확증.
3. **off-grid ceiling 실재(날조 아님)** — `pricing.py:49-50` `TIER_DIMS=("siz_width","siz_height","min_qty")`·`TIER_UPPER=("siz_width","siz_height")`='이하' 상한(≤ 임계 중 최소)=**한 단계 큰 규격 ceiling**. KB "off-grid=한단계 큰 규격 ceiling(앱)" 선언이 evaluate_price 권위와 정합.
4. **동형결합 2그룹 가격 안전(D-WIRE 오판 아님)** — 그룹A `COMP_POSTER_ARTPRINT_PHOTO`{118,120,121,123}·그룹B `COMP_POSTER_CANVAS_FABRIC`{125,126,127,128}. 독립 셀 대조: canonical vs 은퇴 per-material comp(WATERPROOF_PET/ADH_WATERPROOF_PVC/ARTFABRIC_GRAPHIC / LEATHER_ARTPRINT/TYVEK_PRINT/MESH_PRINT) = **공통 52셀·price_diff 0·only_canon 0·only_member 0**. per-material comp 전부 라이브 `use_yn=N` 은퇴 확인. 노드 126/128 **양면 표기**(활성+은퇴 전사·"행수·격자·단가범위 동일" 명시). 라이브 배선(공식→통합 comp)이 그래프와 정확 일치=환각 아님.
5. **use_dims/셀키 미스매치 = 133 단 1건·정직 GAP** — 전 28 base comp 선언 use_dims ↔ 실 셀키(wh vs siz_cd) 전수 대조: 침묵 미스매치 **0**. 유일 미스매치(133 CANVAS_HANGING: `[siz_width,siz_height,min_qty]` 선언 vs siz_cd 셀키)는 `gap-133-usedims-cellkey-mismatch`로 badge=unknown·양면 표기·anchor=none(사유 명시) **정직 선언**.
6. **판형 미배선 정직** — 실사=비종이류(output_paper_typ_cd=.기타). has_plate_size 배선=119만(3엣지). 라이브 실측: 실사 중 활성(del_yn=N) plate 행 보유=119 유일(118/120/125 등은 del_yn=Y 삭제). 그래프=라이브 del_yn 상태 충실 반영.
7. **GAP 실재 원천부재** — offgrid-golden·roll-material-pricing·minqty-axis·133-mismatch = 전부 evaluate_price 앱계산(KB 경계 D-18) + 롤 소재 가격 암묵지(엑셀 미기재·source-registry §9 GAP-2). 게으른 GAP 아님.
8. **고정가 저셀 정직** — 136 PET배너/137 메쉬배너 각 1셀 = `grid_full=True·본체 1규격×1밴드` 정직 문서화(단일 SKU·침묵 누락 아님).

---

## 결함

### [DEF-SL-PP-1] MEDIUM — 133 COMP_POSTER_CANVAS_HANGING 라이브 use_dims 선언≠셀키 (원천/라이브 자체 결함)
- **노드/엣지:** `component-COMP_POSTER_CANVAS_HANGING`(product-133) · `gap-133-usedims-cellkey-mismatch`
- **축:** 6 반증 패널 / 데이터 렌즈
- **결함:** 라이브 `t_prc_price_components.COMP_POSTER_CANVAS_HANGING.use_dims=["siz_width","siz_height","min_qty"]`(면적템플릿) 이나 실 단가행 3셀은 `siz_cd+min_qty` 키(siz_width/siz_height 전부 빈값). 고정가·이산 규격이므로 `[siz_cd,min_qty]`여야 정합. evaluate_price가 siz_cd 폴백 룩업하는지 미상=**가격조회 실패 가능성**.
- **증거(재현):** `awk` t_prc_price_components(use_dims) + t_prc_component_prices(wh_cells=0·sizcd_cells=3). 전수 미스매치 스캔 결과 이 1건만 검출.
- **심각도:** Medium(가격 영향 잠재·단 라이브 원천 결함이지 KB 결함 아님).
- **KB 판정:** **PASS** — KB는 `gap-133`로 정직 GAP + 양면 표기(선언값 vs 정답 셀키·둘 다 보존·값 날조 없음). KB 처리 정확.
- **라우팅:** 원천 컨펌 큐 / §26 무결성·§27 배선 + evaluate_price 실행 실측 후 라이브 use_dims 교정(인간 승인). KB는 현 상태 유지(양면 보존).

### [DEF-SL-PP-2] LOW — 노드 119 has_plate_size 배선이 형제 118 명시 원칙과 불일치
- **노드/엣지:** `product-119-artpaper-poster` has_plate_size 3엣지(plate-119-SIZ_000052/198/294)
- **축:** 4 그래프 무결성 / 5 연결 완전성 (의미 일관성)
- **결함:** 118은 "그래서 has_plate_size 관계를 걸지 않는다(정직 표기·환각 방지)"를 실사 원칙으로 선언했으나, 119는 동일 성격(output_paper_typ_cd 공란·output_file_typ=JPG·파일사양 placeholder)의 행 3개를 배선. 차이는 오직 del_yn(118=Y 삭제/119=N 활성). `has_plate_size` 관계타입을 "판형 아님"이라 스스로 주석한 행에 사용=의미 긴장.
- **증거:** 라이브 t_prd_product_plate_sizes 119=3행 del_yn=N(형제 118/120/125=del_yn=Y). 노드 119 주석 "★파일사양·종이류 판형 아님·T-7" 정직 표기 확인.
- **심각도:** Low(가격 무영향·양측 정직·라이브 del_yn 충실 반영). 침묵 오염 아님.
- **라우팅:** builder(하모나이즈 — 119 placeholder 행도 118처럼 미배선하거나 원칙 문구를 "활성 판형행만 배선"으로 정밀화) 또는 라이브 정리(119 placeholder del_yn=Y화, 실무 큐).

### [DEF-SL-PP-3] LOW — 큐레이션 팩 pack-silsa.md §3.11 동형결합 2그룹 중 1그룹만 문서화(STALE)
- **파일:** `01_curation/pack-silsa.md` §3.11 (KB 노드 아님·입력 팩)
- **축:** 3 오염 적발 (STALE 큐레이션 lag)
- **결함:** §3.11이 "comp_cd 13개(COMP_POSTER_ARTPRINT_PHOTO~COMP_POSTER_BANNER_MESH)"로 상품별 개별 comp 열거·동형결합은 ARTPRINT_PHOTO 4소재 그룹만 명시. 라이브 260702 통합(그룹B CANVAS_FABRIC{125,126,127,128}·per-material comp use_yn=N 은퇴) 미반영. 즉 팩이 은퇴 comp(WATERPROOF_PET·LEATHER_ARTPRINT 등)를 활성처럼 열거=STALE.
- **증거:** mapping.md §1.2(팩 승계원)는 B03=WATERPROOF_PET·B09=LEATHER_ARTPRINT 개별 지정이나 라이브는 canonical 2그룹 통합. 상품 노드(118/126/128)는 **정확**(팩만 지연).
- **심각도:** Low(제품 노드 정확·팩만 lag·향후 큐레이션 오인 위험).
- **라우팅:** curator(팩 §3.11 갱신 — 동형결합 2그룹·은퇴 comp use_yn=N 반영).

---

## 검증 범위·한계 (무결 단정 금지)

- **전수:** 28상품 product→공식→base comp→셀 연결·PRICE≠0·zero·use_dims 선언 vs 셀키·plate_size 배선·동형결합 셀 diff·그래프 dangling — 전부 결정론 스크립트 전수.
- **표본/미확인:** ① 각 셀 단가를 260702 엑셀 "포스터사인" 시트와 셀단위 재대조 안 함(=§26 소관·본 축은 라이브 셀 존재+동형결합 셀 동일성까지). ② 라이브 evaluate_price 종단 골든(옵션 선택→최종가) 실호출 안 함(=query-gate O6 소관). ③ 롤 소재 가격 로직·off-grid 절대값 골든=원천부재 GAP(대조 불가). ④ 고정가 15상품 셀 완전성(수량밴드 누락 여부)은 PRICE≠0까지만·§26 granular 미실시.
- **오라클:** 라이브=live-snapshot 20260702_1119(현재값)·엔진=pricing.py·권위공식=포스터사인 룩업(좌표회귀 T-4·round-2 T-5 DROP 정합 확인).
- codex 2차 미실시(Claude 단독). 필요 시 hqv-codex-cross-verify 재호출 가능.
