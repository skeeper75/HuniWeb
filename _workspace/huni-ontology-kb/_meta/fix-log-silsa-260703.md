# fix-log — 실사(silsa) 검증 결함 교정 (builder · 2026-07-03)

> 입력 결함 보드 3건: `05_verification/defect-silsa-prov-260703.md`(prov)·`defect-silsa-integrity-260703.md`(integrity)·`defect-silsa-pricepath-260703.md`(pricepath).
> 원칙: High·Medium 우선·교정 가능분만·임의 대체 금지·수치는 스크립트 전사(손전사 아님)·자기승인 금지(검증은 별도 레인).
> 빌드: `build_graph.py --idem` → 노드 976→963 · 엣지 3060→3047 · **hard=0** · soft 428→432 · 멱등 True(2회 해시 동일).

## 교정 완료 (3건)

### D-SILSA-INT-1 [Medium·integrity] 실사 size 축 단일소유권 위반 — 로컬 preset 재선언 은퇴·정본 재지향
- **결함:** 실사 로컬 중복 size 노드 13개(6 마스터 앵커)가 정본 노드와 같은 `t_siz_sizes/SIZ_xxx` 앵커를 동일 type으로 중복소유 → "SIZ_000174 쓰는 상품" 질의가 정본 백링크로 탐색 시 실사 126/127/128/132를 조용히 누락(동형결합 공유 축=단일 owner 계약 파손).
- **조치(a·authoring):** 실사 126/127/128/132/139의 `has_size` 6개 정본 재지향 + 로컬 preset 13노드 은퇴.
  - `size-126/127/128-SIZ_000174/197/293` (9) → 정본 `size-SIZ_000174`(product-047)·`size-SIZ_000197`(axis/sizes)·`size-SIZ_000293`(product-119).
  - `size-132-SIZ_000172`·`size-132-SIZ_000174` (2) → `size-SIZ_000172`·`size-SIZ_000174`(product-047).
  - `size-139-SIZ_000320`·`size-139-SIZ_000322` (2) → `size-SIZ_000320`(product-135)·`size-SIZ_000322`(product-138).
  - 상품별 preset/off-grid ceiling/마스터삭제 정직관찰은 `has_size` 엣지 note + 각 main 파일 사이즈 전사표에 보존(정보 손실 0).
  - `gap-139-wide-size-grid-coverage`의 `references` 타깃도 `size-139-SIZ_000322`→`size-SIZ_000322` 재지향(은퇴로 인한 I-2 끊긴 링크 해소).
- **유지(임의 대체 금지):** 정본 부재 로컬 유일소유 5노드(`size-132-SIZ_000304/306/308/310` 액자 전용·`size-139-SIZ_000323` 현수막 900x900)는 은퇴하지 않음(재지향 대상 없음).
- **파일:** product-126/127/128/132/139의 main(relations 재지향·companion mint 목록 정리) + `-nodes`(로컬 블록 삭제·은퇴 사유 blockquote).
- **검증(빌드측 확인):** 정본 6노드가 실사 상품 백링크 흡수 확인(예 size-SIZ_000174 ← 047·119~128·132·135 등 19상품)·실사 로컬 중복 노드 잔존 0·L-20 실사 축 검출 0.

### D-SILSA-INT-1(b)/INT-3 [Medium/Low·builder] 마스터 앵커 중복 lint(L-20) 신설 — 그래프 전역 회귀 가드
- **조치:** `build_graph.py`에 L-20(소프트) 추가. 같은 `t_*/CODE` **마스터** 앵커를 2+ 노드가 **동일 type**으로 소유하는 앵커 중복(L-3 id중복이 못 잡는 사각지대)을 소프트 경고. `t_prd_product_*` 정션(prd_cd 조밀 앵커=자식행 by-design·D-SILSA-INT-2 architect 소관) 제외·크로스타입(product↔bundle_qty·decision↔component)은 (type,anchor) 그룹핑으로 자동 제외.
- **소프트 채택 사유:** 하드 승격 시 미교정 스티커 축 7건으로 빌드 FAIL → "하드 0" 위반. 소프트로 전역 노출해 회귀 가드(INT-3의 "lint 전역 적용" 충족).
- **결과:** 실사 축 0·잔여 L-20 = 7건(전부 비실사·스티커/타 레인 소관: `t_mat_materials/MAT_000163/371/372`·`t_siz_sizes/SIZ_000057/170/520/521`). 리포트 무결성 절에 L-20 카운트 노출.
- **스키마 정합(architect 라우팅분):** `02_ontology/file-format-spec.md` §5.3 L-20 행 + `graph-build-spec.md` §5.6b 신설(v1.0.4). 명세-구현 정합.

### DEF-SL-PP + PROV §4 [Low·prov] gap-142-uv-process src_id 오태깅 교정
- **결함:** `gap-142-uv-process`가 live CSV `t_prd_product_processes.csv`(0행 실측)를 `SR-pack-silsa`로 태깅(팩 아님=오태깅).
- **조치:** src를 2개로 분리 — 라이브 실측(0행)은 `SR-5-livesnap`(live CSV 정합), UV PROC_000002 라우팅 기대는 실제 원천인 `pack-silsa.md §3.7`로 별도 태깅(`SR-pack-silsa`·badge=candidate). 임의 대체 아님(각 사실을 실 원천에 귀속).

## 라우팅(교정 안 함·타 레인/architect 소관·근거 명시)

- **DEF-SL-PP-1 [Medium·pricepath] 133 COMP_POSTER_CANVAS_HANGING use_dims≠셀키:** KB는 이미 `gap-133-usedims-cellkey-mismatch`로 정직 GAP+양면 표기(verifier도 KB **PASS** 판정). **라이브 원천 결함**이지 KB 결함 아님 → 현 상태 유지(양면 보존). 원천 컨펌 큐·§26/§27 + evaluate_price 실행 실측 후 라이브 use_dims 교정(인간 승인) 소관. **KB 무수정.**
- **DEF-SL-PP-2 [Low·pricepath] 119 has_plate_size 배선 vs 118 미배선 원칙:** 119 plate 3행은 라이브 `del_yn=N`(활성)·118은 `del_yn=Y`(삭제) — 그래프가 라이브 del_yn을 충실 반영(가격 무영향·침묵 오염 아님). 미배선으로 하모나이즈하면 라이브와 diverge → **KB 무수정**(라이브 정리는 실무 큐). 노드 119 주석은 이미 "★파일사양·종이류 판형 아님·T-7" 정직 표기.
- **DEF-SL-PP-3 [Low·pricepath] pack-silsa.md §3.11 동형결합 1그룹만 문서화(STALE):** 입력 큐레이션 팩(KB 노드 아님)·**curator 소관**. 상품 노드(118/126/128)는 정확(팩만 lag). 팩 §3.11에 그룹B CANVAS_FABRIC 통합·은퇴 comp use_yn=N 반영 = curator 갱신.
- **D-SILSA-INT-2 [Low·integrity] CPQ junction 앵커 조밀도:** junction 노드 앵커를 자식 복합키로 세분하는 **스키마 규약 = architect 소관**(현 상태 무해·질의/가격 무영향). L-20이 정션을 제외하므로 회귀 노이즈 없음.
- **PROV §4 별칭 통일(mapping.md 5 src_id·HARNESS-DOMAIN-RULES 2 src_id):** src_id 정규 키 표 신설/free-form 강등은 **architect 컨벤션 결정 선행 필요**(source-registry에 SR-* 키 미정의). 정규 키 없이 전 노드 스윕 = 임의 대체 위험 → **BLOCKED(architect)**. 이번엔 명백한 CSV 오태깅 1건만 교정(위 §PROV). 가격·권위 무영향(실측 필드 source_file/source_locator 전수 정확).

## 빌드 산출
- `04_graph/nodes.jsonl`(963)·`edges.jsonl`(3047)·`graph.db`·`05_verification/build-report-20260703.md`.
- 멱등 해시(재현): nodes.jsonl=03dcccaf21c42be8 · edges.jsonl=bfc516b8c14e0e3a.
- 자기승인 없음 — 교정 재검증은 okb-adversarial-verifier 레인 몫(생성≠검증).
