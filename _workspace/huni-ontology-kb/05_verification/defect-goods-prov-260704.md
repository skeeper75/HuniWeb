# 결함 보드 — 굿즈/파우치/봉투 (Phase 4 적대검증 · 축: 출처 실재성 + 권위 정합 + 오염 적발)

> **검증가:** okb-adversarial-verifier · 2026-07-04 · **생성≠검증**(구축가 주장 비신뢰·라이브 실측 대조)
> **범위:** 굿즈/파우치/봉투 103 단품 노드(001/002/005/050/283·183~279·011/015) + 공유 gap + O5 코드정렬(2026-07-04)
> **방법:** live-snapshot/latest awk 실측 + edges.jsonl(파생 그래프) 기계 대조 + build_graph.py 코드 감사
> **판정:** **CONDITIONAL-GO** — 색상값 자재를 substrate로 잇는 uses_material 엣지 6건(197/198/227/241) 제거 후 GO.

---

## 요약 (내 축 결과)

| 검사 | 결과 |
|------|------|
| 출처 실재성(sources[] 인용 재확인) | **PASS** — 001/005/196/200/226 등 표본 siz_cd·prd_typ·값 라이브 실재 확인 |
| 고정가룩업 값 정합(15건 verbatim 대조) | **PASS** — 185/205/210/211/212/219/223/224/225/248/263/265/266/272/275 전부 라이브 unit_price 일치(260610 verbatim·260702 diff 미해당) |
| 봉투 오염(001/002/005 = .03 확인) | **PASS(격상)** — 라이브 = **PRD_TYPE.03**(기성). 팩 §1.4가 `.01`로 오기했으나 **구축가가 라이브 .03으로 정직 override**(STALE 회피 성공). 단 팩은 여전히 오기(D-2). |
| use_yn=N 팬텀 가격 없음 | **PASS** — 199/202/203/204/207/208/222/226/227/228 전부 미출시 라벨·고정가 0·팬텀 없음 |
| NEITHER-gap/empty-shell 진짜 부재 | **PASS** — 001/002/005/199/201/214/217/242 등 formulas AND prices 둘 다 0행 실측 확인·242=자재/공정 0행 순수 empty-shell |
| 오염 적발(비-소재 값 자재화) | **FAIL(D-1)** — 화이트/블랙 색상값이 substrate uses_material로 파생 그래프에 전파(자기모순) |
| O5 코드정렬 건전성(2026-07-04) | **조건부 PASS(D-3)** — 이 배치엔 무해(실측 0)하나 잠재 구멍 |

---

## D-1 [HIGH] 색상값(화이트/블랙)을 substrate 자재로 잇는 uses_material 엣지 — 자기모순·오염 전파

**대상:** product-197-mini-mat, product-198-picnic-mat, product-227-mini-uchiwa-keyring, product-241-canvas-strap-label-pouch (엣지 6건)

**증거(기계 실측):**
- `edges.jsonl`에 `uses_material` → `material-MAT_000255`("화이트")/`material-MAT_000256`("블랙") 6건 실재, note=`"substrate 자재(usage USAGE.07·live t_prd_product_materials 활성)"`.
- 그러나 `t_mat_materials.csv`: MAT_000255="화이트"·MAT_000256="블랙" = **MAT_TYPE.08 색상 라벨**(substrate 명사 없음) = 팩 §3.5/T-4 GP-ST-003 "비-소재 값 자재화" 오염.
- **자기모순(227/241):** 같은 노드가 `uses_material→MAT_000256 "substrate 자재"` **동시에** `references→gap-goods-material-contamination "MAT_000256 '블랙'=색 라벨...substrate 아님"`을 파생 그래프에 배출 → 그래프가 "X는 substrate다 ∧ X는 substrate 아니다"를 동시 주장.
- **프로즈 모순(197/198):** 프론트매터는 `uses_material→MAT_000255/256 "활성 substrate"`인데 본문은 "둘 다 del_yn=Y(비활성) → 부모 uses_material 미실재(L-18 회피)"라고 정반대 서술.
- **정당화 부재:** 197/198은 색상 CPQ(OPT_000070/071)의 `option_refs` 엣지가 **0건**(grep 확인) → uses_material 엣지에 L-18 fn_chk_opt_item_ref 정당성조차 없음. 순수 오염 배선.

**메커니즘:** build_graph.py L145 `n.rels = meta.get("relations")` — 엣지는 CSV 자동유도가 아니라 **구축가가 프론트매터에 직접 저작**. 즉 구축가가 오염을 프로즈로 적발하고도 프론트매터에 substrate 엣지를 남겨 SOT·파생 그래프에 전파.

**실패 시나리오:** 그래프 질의 "이 파우치(241)는 무엇으로 만드나?" → "블랙"(색상)을 자재로 답함. 노드 자신의 오염 선언과 정반대.

**교정:** 197/198/227/241의 `uses_material→MAT_000255/256` 엣지 6건 삭제(색상은 substrate 아님). 색상은 CPQ 옵션/color 축으로만. 구축가 교정 대상(파일 저작 결함·라이브 원천은 격리).

---

## D-2 [LOW] 팩 §1.4 봉투 prd_typ 오기(.01) — 구축가는 override 성공, 팩 미교정

**증거:** 팩 `pack-stationery-goods.md` §1.4 표가 001/002/005를 `prd_typ=.01`로 기재. 라이브 실측 = **PRD_TYPE.03**(기성). 구축가는 노드에서 라이브 .03 채택 + 팩 오기를 명시 정정("팩 §1.4 초기 서술은 001을 .01로 표기했으나 라이브 실측은 PRD_TYPE.03") → **노드 결함 아님**. 다만 큐레이션 팩은 여전히 오기 → 후속 배치에서 STALE 재전파 위험.

**교정:** 팩 §1.4 표 001/002/005 prd_typ를 .03으로 정정(권장·구축가 산출물 아님).

---

## D-3 [LOW] O5 코드정렬(2026-07-04) — gap 종류 무제한 수용(잠재 가격정직 우회)

**증거:** build_graph.py L432-439 `has_gap_decl = any(... nodes[dst].type == "gap" ...)` — 상품이 **type=gap 노드로의 out-edge를 하나라도** 가지면 O5(priced_by≥1 또는 gap 선언) 충족. 가격-부재 gap(goods-neither 등)으로 **제한하지 않음**.

**이 배치 영향:** **없음(실측 0)** — 무가격 상품 전부가 가격-gap(goods-neither/price-unloaded/pouch-empty-shell/226-acryl-tbd)을 선언(o5.py 스캔 0건 위반). 코드정렬 자체는 건전.

**잠재 구멍:** 향후 상품이 가격사슬이 끊겼는데 비-가격 gap(예 size-gap·cpq-missing)만 가리켜도 O5 통과 → 가격정직 우회 가능. 방어적 강화 권장: `has_gap_decl`를 가격-부재 gap 집합으로 제한하거나 O5 note에 "가격 관련 gap" 조건 명시.

---

## 격리(원천결함 · 구축가 교정 대상 아님)

- **라이브 색상-자재 오염(GP-ST-003):** t_prd_product_materials에 "화이트"/"블랙"이 MAT_TYPE.08로 등록된 라이브 원천 오염. 구축가는 **배선하지 말고 flag**해야 하며(→ D-1은 배선한 것이 결함), 원천 행 제거는 실무진/dbmap(§7/§17) C트랙.
- **NEITHER-gap/empty-shell 가격 원천 부재:** 001/002/005/199/201/214/217/242 등 formulas AND prices 둘 다 0행 = 진짜 부재(가짜 gap 아님·실측 확인). 채움=실무진 가격표·dbmap.
- **봉제 공정 MISSING(GP-ST-005):** 242 등 t_prd_product_processes 0행 = 라이브 미적재(정직 표기됨). C트랙.

---

## 실측 근거 파일
- live-snapshot: `_workspace/_foundation/live-snapshot/latest/{t_prd_products,t_prd_product_prices,t_prd_product_price_formulas,t_prd_product_materials,t_mat_materials}.csv`
- 파생 그래프: `04_graph/edges.jsonl`(uses_material 엣지)·`04_graph/build_graph.py`(L145 저작·L432 O5)
- 팩: `01_curation/pack-stationery-goods.md` §1.4·§3.5·§4·T-4
