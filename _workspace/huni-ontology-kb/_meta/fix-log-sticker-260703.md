# fix-log — 스티커 검증 결함 교정 (builder · 2026-07-03)

> 입력 결함 보드 3건: `05_verification/defect-sticker-prov-260703.md`(prov)·`defect-sticker-integrity-260703.md`(integrity)·`defect-sticker-pricepath-260703.md`(pricepath).
> 원칙: High·Medium 우선·교정 가능분만·임의 대체 금지·수치는 스크립트 전사(손전사 아님)·자기승인 금지(검증은 별도 레인).
> 빌드: `build_graph.py --idem` → nodes 652→654 · edges 2124→2128 · **hard=0** · soft 313→315 · 멱등 True.

## 교정 완료 (8건)

### D-STK-1 [Medium·integrity] index.md dead-link (404)
- 조치: `03_kb/index.md` L112 링크 `product/product-059-sticker-spec-square.md`(부재) → 실파일 `product/sticker-spec-square.md`로 교정. 파일명↔노드ID 2규칙 분열은 architect 통일 대기(D-STK-2) 주석 병기.
- 근거: 파일 rename보다 링크 정합 우선(작업지시)·기존 그래프 id(`product-059-sticker-spec-square`) 유지. O4b 재빌드 dead-link=0 확인.

### D-STK-01 [Medium·prov] 크라프트(MAT_000164) 연당가 양면노드 누락 + 허위 위임
- 조치A: `axis/materials.md`에 `material-MAT_000164` 양면(defect) 노드 신설(MAT_000372 defect 패턴 동형). current_value=원가 미저장(06-03 코드만·평량 57) / authority_value=연당가 81,500·국4절 272·평량 57(무변)·자식 MAT_000591(06-30 mint).
- 조치B: `gap-058-yeondangga`(circle)·`gap-062-yeondangga`(fancy)·`gap-066-yeondangga`(gangpan)의 gap_fill_from 위임 서술에서 "크라프트→059~064 상품" 허위 위임 제거 → 투명(053/056/063)·홀로(054)만 상품 owner로 정정, 크라프트는 axis material-MAT_000164가 owner임을 명시.
- 조치C: 위 3 gap에 `references → material-MAT_000164` 엣지 추가(허위 위임을 실재 owner 링크로 대체·orphan 방지).
- 수치 전사: `_workspace/huni-dbmap/26_change-tracking-260702/price-diff-260527-260702.csv` '크라프' 행(H 156000→81500·I 312→272·F 57g) 스크립트 대조. 라이브 t_prd_product_materials에서 MAT_000164/591 사용 상품 **0행** 실측 → product 위임 대상 부재 확증. §4-D 워크리스트 3/4→4/4 완비.

### D1 [Medium·pricepath] qty-059 노드/엣지 부재 (16상품 중 059만 누락)
- 조치: `sticker-spec-square-nodes.md`에 `qty-059` bundle_qty 노드 신설(형제 qty-060 동형·anchor t_prd_products/PRD_000059·min4/max10000/incr4·bundle_qtys 0행)+ `sticker-spec-square.md` product-059 노드에 `has_qty_rule → qty-059` 엣지 배선.
- 근거: 15 형제 전부 qty-0xx 보유·059만 prose/props로만 기술 → 그래프 구조 일관화. anchor 실재(L-17 통과).

### D-STK-02 [Low·prov] optgroup-052/067-paper source_file `+` 결합
- 조치: `t_prd_product_options.csv+t_prd_product_option_items.csv` 단일 필드를 파일당 1엔트리(2 src)로 분리. 정답 파일명=`t_prd_product_option_groups.csv`(그룹 def OPT_000006/OPT-000042) + `t_prd_product_option_items.csv`(옵션값)로 교정. 스냅샷에서 OPT_000006 그룹행이 option_groups.csv에 실재 확인 후 반영(임의 대체 아님).

### D-STK-04 [Low·prov] plate-060/061 SIZ_000521 origin 무대조
- 조치: 두 노드 t_siz_sizes locator에 "260702 무변경(전지 규격 diff 비대상)" 주석 추가 → 구권위(260610) 인용 스캔 노이즈 제거.

### D-STK-05 [Low·prov] gap-058/062/066 KB-상대경로 관례 불일치
- 조치: 3 gap src의 `_meta/scripts/…` → `_workspace/huni-ontology-kb/_meta/scripts/…` 전체경로 통일(resolver 미해석 제거).

### D-STK-5 [Low·integrity] 루트 잔여 graph.db(0바이트)
- 조치: `_workspace/huni-ontology-kb/graph.db`(빈) 삭제 + KB 루트 `.gitignore` 신설(`/graph.db`·정본 경로=04_graph/graph.db 명시)로 재발 차단.

### D-STK-3 [Low·integrity/architect] build O4 부분문자열 false-negative
- 조치(빌더 재구현): `build_graph.py` O4에 **O4b index dead-link 스캔** 추가 — index.md 마크다운 링크 `](*.md)` target 파일 실재를 직접 검사(부분문자열 매칭이 dead-link를 은폐하던 것 교정). 소프트 유지(발견성 규칙·I-set 불변).
- 조치(스키마): `02_ontology/graph-build-spec.md`에 v1.0.3 변경이력 등재(O4b 규정).

## 이연 (6건 — 교정 lane 밖·확인 필요)

| # | 보드 | 심각도 | 라우팅 | 이연 사유 |
|---|---|---|---|---|
| D-STK-2 | integrity | Medium | architect→builder | 스티커 노드ID 2규칙(product-NNN 5 : sticker-slug 11) 통일=명명 규칙 정본 결정 필요. 그래프 무결성 결함 아님(id 조회 정상)·dead-link는 D-STK-1로 해소. 일괄 rename은 architect 규칙 확정 후. index에 주석 병기함. |
| D-STK-03 | prov | Low | builder(architect 확인) | MAT_000372 dual 중복(axis material-MAT_000372 ↔ matcost-053-clear-backing 동일 앵커). 2층 원가노드 canonical 규약=architect 확인 필요·노드 삭제/접기는 임의 대체 금지 원칙상 보류. |
| D-STK-4 | integrity | Low | curant/builder | process-PROC_000008 axis 승격. 비-스티커 디지털파일(product-020)이라 스코프 밖·형제 PROC_000009와 쌍 이동 정책은 curator/architect 일괄 판단이 안전(008만 비대칭 이동 회피). |
| D2 | pricepath | Low | curator confirm | gap-055-coating-conflict 신설 여부=BATCH-3 staff 소관(exempt 사유 명문화 택일). |
| D3 | pricepath | Low | curator | 052 relation note "PROC_000054(삭제됨)" 문안 정밀화(마스터 del_yn=N·052 상품공정 delist). 본문(L102)은 정합·문안 lane=curator. |
| D4 | pricepath | Low | curator/architect | GAP_roll_material_price·GAP_product_count systemic-orphan 링크 or 허용 명문화. |

## 검증 위임 (자기승인 금지)
- 본 교정은 생성 레인. 재검증은 okb-adversarial-verifier 소관 — 재빌드 hard=0·멱등 True는 빌드 자체검사이며 "검증 완료" 아님.
- 재검증 필수: D-STK-1(dead-link 해소)·D-STK-01(크라프트 dual 값 전사 정합·위임 정정)·D1(qty-059 anchor/엣지).
