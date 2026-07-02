# O1~O7 확장 게이트 판정 — 전 36상품 · 2026-07-03

> 게이트: okb-query-gate(확장·독립 재실측) · 방법론: `.claude/skills/okb-adversarial-gate/SKILL.md §4`
> 대상: `03_kb/`(노드 466·엣지 **1526**·상품 36) + `04_graph/`(직접 재빌드) · 가격 대조만 라이브 evaluate_price 실호출.
> 원칙: 결함 보드·빌더 리포트 주장 **비신뢰** — build_graph.py 직접 2회 재실행 + graph.db 블라인드 재질의 + 라이브 시뮬레이터 직접 재호출로만 판정.
> ★결함 보드 3종은 edges=1521 시점 스냅샷. 본 게이트는 **현재(edges=1526)** 상태를 재측정 — 보드가 HIGH로 지목한 D1(048)·M1(broken rule)·D-1(OPV off-by-one)이 **전부 교정 반영됨**을 독립 확인(생성≠검증의 실효 증거).

## 종합: **GO** (O1~O7 전부 PASS · 단일 FAIL 없음)

| 게이트 | 판정 | 핵심 근거(직접 재실측) |
|---|:---:|---|
| O1 출처 실재성 | **PASS** | prov 보드 A1 잔존 LOW 1건(D-1 OPV_000137 off-by-one)=**교정 확인**. 소스 md에 `OPV_000137` 오기 잔재 **0**, 현재는 "박없음 센티넬·item 0행" 정직 note로 전환. 파일 619/43 전부 실재. |
| O2 권위 정합 | **PASS** | 016 qty min=**15**=KB qty-016 일치. 라이브 sim_meta frm이 KB priced_by와 **9/9 상품 일치**. PRF_DGP_A has_component **10종 = 라이브 components 집합 완전 동일**(comp_set_eq=True 전건). |
| O3 오염 필터 | **PASS** | STALE 인용 0·환각 개체 0(존재하지 않는 상품 5종 node_count=**0**)·use_yn=N **6상품 전부 미출시 정직 표기**·042 굿즈 자재 오적재=`defect` 배지로 양면 표기(라이브 원천 컨펌 큐). |
| O4 그래프 무결성 | **PASS** | build_graph.py `--idem` **md5 바이트 동일**(nodes=6cf6b56a…·edges=1dded191…)·hard=**0**·soft=116. M1(broken `RULE_import_material_keep`)=교정 확인(잔재 0·정타겟 28엣지). 잔존 소프트 orphan 8(6=미사용 공유축 pool·2=index-only meta GAP)=전부 소프트 강등(하드 아님). |
| O5 연결 완전성 | **PASS** | 재귀 완결성 재실행: **SILENT 0·ORPHAN-GAP 0**(D1 HIGH 048 교정→gap 3종 references 배선·traversal 도달)·DECLARED 4(019/038/048 정직 GAP)·36/36 priced_by(038=derived_from→gap O5 예외). |
| O6 종단 질의 재현 | **PASS** | 시나리오 **29**(구체10+용도3+조건3+옵션3+거절10)≥15·유형 **5종 전부**. 가격 대조: 라이브 실호출 9상품 **frm 일치·comp 집합 일치·PRICE≠0 전건**·수치 결정론 재현(041=10,177·016양면=16,024 전 세션값과 오차 0). 거절 정직·환각 추천 0. |
| O7 생성≠검증 독립성 | **PASS** | builder(03_kb 집필)↔verifier(결함 보드 edges=1521 스냅샷)↔본 게이트(edges=1526 현재 상태 독립 재측정) 3중 분리. 본 게이트가 보드 지목 결함의 **교정 여부를 소스·빌드로 직접 재확인**(보드 주장 미신뢰). |

---

## 재실측 증거 (숫자)

### O4 멱등 재빌드 (직접 재실행)
- `python3 build_graph.py --idem` → `nodes=466 edges=1526 hard=0 soft=116`·`2회 빌드 해시 동일: True`.
- 재빌드 전후 md5 불변: nodes=`6cf6b56a8a9280b6…`·edges=`1dded191b38f3173…`. 커밋 산출물==갓 빌드.

### O6 가격 대조 (라이브 evaluate_price 직접 재호출 · PRICE≠0 · 구조 오차 0)

| 시나리오 | 상품 | 라이브 frm | KB priced_by | frm | comp 집합 | PRICE(원) | 판정 |
|---|---|---|---|:---:|:---:|---|:---:|
| S1 프리미엄엽서 | PRD_000016 | PRF_DGP_A | PRF_DGP_A | ✓ | =(10종) | 16,024 | PASS |
| S2 포토카드 | PRD_000024 | PRF_PHOTOCARD_NORMAL | 〃 | ✓ | = | 6,000 | PASS |
| S3 스탠다드명함 | PRD_000033 | PRF_NAMECARD_FIXED | 〃 | ✓ | = | 3,500 | PASS |
| S4 봉투제작 | PRD_000050 | PRF_ENV_MAKING | 〃 | ✓ | = | 96,000 | PASS |
| S5 쿠폰 100장 | PRD_000041 | PRF_DGP_A | 〃 | ✓ | = | 10,177 | PASS(전세션값 재현) |
| S6 소량전단 | PRD_000047 | PRF_DGP_D | 〃 | ✓ | = | 4,031 | PASS |
| S7 코팅엽서 | PRD_000017 | PRF_DGP_A | 〃 | ✓ | = | 9,467 | PASS |
| S8 프리미엄명함(박분기) | PRD_000031 | PRF_NAMECARD_PREMIUM_FOIL | PREMIUM+_FOIL | ✓ | = | 4,500 | PASS(박 옵션·base가) |
| S9 라벨택(완칼) | PRD_000046 | PRF_DGP_B | PRF_DGP_B | ✓ | = | 13,927 | PASS |

★KB는 D-18 경계상 **수치 값을 단정하지 않는다**. "오차 0"은 KB 도출 (공식·구성요소 집합)이 라이브와 완전 일치함 + PRICE≠0 sanity에 대한 판정이다. 추가로 041=10,177·016양면=16,024는 전 세션 게이트 기록값과 **바이트 일치**(엔진 결정론 확증).

### O6 유형 커버리지 (블라인드 graph.db 재질의)
- **구체(10):** S1~S9 + S1v(016 양면 override).
- **용도 추천(3):** INTENT_cafe_opening→CAT_000307/062·INTENT_wedding→CAT_000001/307·INTENT_premium→CAT_000313/307 (references 엣지 실재·도달).
- **조건 탐색(3):** 양면(POPT_000002) 역탐색 30상품·완칼(PROC_000123) 역탐색→023·투명PET 소재→019(uses_material 0=`gap-019-material` 정직).
- **옵션 조합(3):** 016 오시↔미싱 상호배제=`constraint-016-demo-exc`(badge=candidate·엔진 미강제 양면표기)·031 박=PRF_..._FOIL 분기·017 코팅 유광/무광.
- **거절(10):** 배송→`RULE_scope_boundary`(주문·배송·회원·쿠폰·경쟁사·재고 out_of_scope 정직 거절)·현수막/아크릴키링/머그/PRD_999999→**node_count=0 환각 추천 0**·미출시 021/022/023/028/038/051 정직·038 형압명함 가격사슬 GAP(derived_from→gap-038-no-price-path).

### O3 미출시(use_yn=N) 정직 표기 (전수)
- 라이브 use_yn=N 6상품 전부 KB props에 미출시 명기: 021·022(`N (미출시·라이브 미노출)`)·023·028·038·051. **미출시인데 활성처럼 답하는 환각 0.**

---

## 결함 보드 종합 + 교정 확인 (edges 1521 스냅샷 → 1526 현재)

| 보드 결함 | 심각도 | 보드 시점 | 본 게이트 현재 재측정 |
|---|:---:|---|---|
| D1 (pricepath) 048 gap 미배선=traversal 미도달 | **High** | OPEN | **교정 확인** — `product-048 --references--> gap-048-no-size/material/price-path-incomplete` 3엣지 실재·ORPHAN-GAP=0. |
| M1 (integrity) `RULE_import_material_keep` 깨진 참조 3파일 | Medium | OPEN | **교정 확인** — 소스 잔재 0·027/029/031 -nodes가 `RULE_import_material_no_delete` 정타겟(28 references). |
| M2 (integrity) 048 gap 백틱/산문 고아 | Medium | OPEN | **교정 확인**(D1과 동일 배선). |
| D-1 (prov) optgroup-OPT_000038 OPV_000137 off-by-one | Low | OPEN | **교정 확인** — 소스에서 `OPV_000138~145`로 정정·OPV_000137=박없음 센티넬(item 0행) 정직 note. |
| D-2 (prov) 042 굿즈 자재 라이브 오적재 | 원천 | OPEN | **KB 정직 유지**(defect 배지+GAP)·라이브 원천 컨펌 큐(실무진). KB 결함 아님. |
| D2/D3 (pricepath) GAP_roll_material_price·GAP_product_count 그래프 고립 | Medium/Low | OPEN | **잔존**(in=out=0). 롤소재=디지털 파일럿 범위 밖·product_count=메타/스코프 GAP. 파일럿 36상품 가격경로 무영향. → architect 권고(비차단). |

**하드 무결성 결함 0·가격영향(High) 미교정 결함 0.** 보드가 지목한 유일한 High(D1)는 교정 반영 확인.

---

## 잔존 비차단 항목 (advisory · NO-GO 아님)

- **A-1 (architect):** index-only meta GAP 2건(`GAP_roll_material_price` Medium·`GAP_product_count` Low)의 그래프 고립 — 스키마에 "메타/경계 GAP 고립 허용" 규약 명문화 또는 경계축 최소 앵커. 파일럿 가격경로 무영향.
- **A-2 (builder/log):** 교정 라운드(048 gap 배선·M1·D-1)로 edges **1521→1526** 변동했으나 `03_kb/log.md` 최신 build 엔트리는 1521 표기 — append-only 로그에 교정 라운드 미기록(추적성 Low·데이터 결함 아님). 교정 자체는 소스·빌드에 실재 확인.
- **A-3 (curator/convention):** use_yn prop 표기 편차 — 5상품 `"N"`·022만 `"N (미출시·라이브 미노출)"`. 둘 다 미출시 정직 전달(의미 동일)이나 값 포맷 비일관. use_yn=Y 활성 30상품은 prop 부재(암묵 Y). 표기 규약 정비 권고.
- **OBS(전 게이트 승계):** scope_boundary "쿠폰" 토큰 중의성(과잉거절 위험)·파일럿 밖 명시 RULE 부재 — 카테고리/RULE 커버리지 확장 시 재판정.

---

## 동형 전파 가능성 평가

- **✅ 스키마 고정 경로는 전파 가능.** `product→has_size/print_option/process→priced_by→formula→has_component→use_dims + qty_rule/option_refs/constraint`는 상품 무관 고정 탐색 — 36/36 상품에서 동일 질의 재현됨을 실증(파일럿 8→36 확대에도 프레임 불변). 거절 기계(RULE_scope_boundary·node 부재·use_yn=N·정직 GAP)도 횡단 전파.
- **✅ 확장분(엽서/명함/박/별색/완칼/투명/전단/봉투/썬캡/미출시) 커버 확인.** 박 분기(PRF_..._FOIL)·완칼(PRF_DGP_B/F+PROC_000123)·별색(공정 환원)·투명PET(자재 GAP)·매트릭스형(PRF_ENV_MAKING 봉투)·미출시(use_yn=N) 각 유형이 blind 질의로 정확히 도달/거절.
- **⚠️ 무조건 복제 금물(재실측 필수).** ① 비종이류(현수막/아크릴/롤소재)는 §26/§27 라이브 결함(fn_calc_pansu·sparse grid·C트랙) 미해소분 존재 → 가격 값 정합 상품군별 재실측 필요(`GAP_roll_material_price`가 경계 신호). ② candidate/DEMO 제약(constraint-016-demo-*)은 §31 거버넌스 확정 전 — 엔진 미강제 양면표기 유지. ③ intent 추천은 category `references` 의존 → 카테고리 커버리지 확장 선행.

---

## 검증 범위·한계 (정직 표기 · "무결" 단정 아님)

- **전수(스크립트 결정론):** 그래프 재빌드 멱등(md5)·36상품 priced_by/축 연결·재귀 완결성(SILENT/ORPHAN-GAP/DECLARED)·use_yn=N 6상품·존재하지않는 상품 node 부재·양면/완칼 역탐색·intent references.
- **표본(라이브 직접 재측):** 가격 9상품 evaluate_price 실호출(frm+comp 집합+PRICE≠0)·수치 재현 2건(041/016양면 전세션값 일치). 나머지 27 use_yn=Y 상품 가격 값 정합은 미전수(구조 경로는 전수 확인·값은 §26 소관).
- **파일럿 한정:** 디지털인쇄 36상품. 비파일럿 상품군·비종이류 셀 무결성은 §26/§27 소관. 라이브 결함(042 굿즈오적재·롤소재)은 KB 밖 원천 컨펌.
- **codex 2차 미호출**(Claude 단독 재측정).

## NO-GO 라우팅
- 해당 없음(GO). 후속 비차단 A-1(architect)·A-2(builder/log)·A-3(curator)·D-2(원천 컨펌 큐) 등재. 단일 FAIL 없음.
