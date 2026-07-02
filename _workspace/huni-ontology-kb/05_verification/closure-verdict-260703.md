# 교정 해소 확인 판정표 (closure verdict) — R1·R2 — 2026-07-03

> 검증가: okb-adversarial-verifier · 대상: `_meta/fix-log-260703.md` R1(7)+R2(7) = 14행
> 원칙: 생성자(builder) 주장 비신뢰 — 정본 파일·그래프(build_graph.py 직접 재실행)·라이브 스냅샷을 **직접 재실측**. fix-log의 "재실측 증거"는 참고만, 판정은 독립 재측정으로만.
> 재빌드 실측: `python3 04_graph/build_graph.py --idem` → **nodes=204·edges=430·hard=0·soft=30·멱등 True**(독립 2회 full-run byte-identical). 스냅샷=live-snapshot/latest(snap_20260702_1119).

## 종합 판정

- **R1 7행·R2 7행 = 14행 전건 CLOSED.** 미해소/신규 High=0·Medium=0.
- **잔존 Low 1건**: R1 open question(팩 §3.5 rootless 경로) — 파일은 실재(dead-link 아님)·그래프 무영향·R1이 스코프 밖으로 정직 유보한 사전 항목. 신규 회귀 아님.
- **교정이 만든 새 모순 = 0.** 스키마 v1.0.3 변경(file-format ↔ graph-build ↔ builder 코드) 내부 정합 확인. 제거된 gap 노드의 dangling 참조 0.

---

## R1 판정표

| ID | 무엇을 고쳤다 주장 | 독립 재실측 | 판정 |
|----|------|------|------|
| **V1-01A** | 016/027/046 source_file→`huni-dbmap/17_correctness/`·src_id `SR-13-identity`·dead-path/rootless 잔재 0 | `graph.db` source 3건 전부 `_workspace/huni-dbmap/17_correctness/digital-print/{product-identity,correction-manifest}.md`·src_id=SR-13-identity. `print-kb/wiki/17_correctness%` OR bare `17_correctness/%` 잔재 = **0**. 전 node source 38경로 존재성 sweep = 미해결 **0** | **CLOSED** |
| **V1-01B/V1-02A** | blocklist.md 실체화 + `load_blocklist()` 부재 시 하드 FAIL(조용한 통과 위장 제거) | blocklist.md 실재(tier 라인 14). **적대적 테스트**: 파일 rename → `hard=1`("O2/I-6 blocklist.md 부재…게이트 원천 없음"), 복구 → `hard=0`. 코드 line 260-262 present=False→hard.append 확인 | **CLOSED** |
| **V1-02B** | L-18 하드 구현 + 회귀가드 L-1/L-12/L-13/L-16/O3 | build_graph.py line 417-435 L-18 하드(option_refs 부모 차원 정합·hard.append). 현 데이터 위반 0(hard=0). 가드 L-1(271)·L-12/L-16(scan_body_lint)·L-13(300)·O3(294-298) 코드 실재. ★L-18 통과가 V2-02의 016 has_process 3→7 선행에 의존(정합) | **CLOSED** |
| **V1-03A** | 041 옵션그룹 앵커→`t_prd_product_option_groups/PRD_000041`(016 통일)·§1.0 junction 규약 | graph.db: optgroup-041-{finish,paper,print} 3건 전부 앵커=`t_prd_product_option_groups/PRD_000041`. ontology-schema §1.0 line 34 junction·복합키 규약 명문 | **CLOSED** |
| **V1-03B** | 엣지 (src,rel,dst) 전역 dedup(jsonl=sqlite) | `wc -l edges.jsonl`=**430** == `SELECT count(*) FROM edge`=**430** == 리포트 430. jsonl 중복 (src,rel,dst) = **0** | **CLOSED** |
| **V1-04B** | O4 하드→소프트 3원 통일 | 코드 line 459 `soft.append`. file-format-spec §5.3(line 148) O4=소프트로 이설. graph-build I-set 미포함. 3원 정합 | **CLOSED** |
| **V1-05B** | 빌드 리포트 고아 설명 STALE 문구 갱신 | build-report-20260703.md line 91-92 = 실상태("상품 8개 집필 완료·현행 소프트 고아=파일럿 미사용 축+floating GAP"). node type product=8 실측 부합 | **CLOSED** |

## R2 판정표

| ID | 무엇을 고쳤다 주장 | 독립 재실측(그래프 + 라이브) | 판정 |
|----|------|------|------|
| **V2-02 (High)** | 016 has_process 3→7·gap-016-process-nodes 제거 | 그래프 016 has_process = PROC_000004/027/028/029/030/031/032 (**7**). **라이브** t_prd_product_processes PRD_000016 del_yn=N = 동일 **7공정** → 정확 일치. gap-016-process-nodes 노드 count=**0**. 잔여 `[[ ]]` dangling 참조=0(전부 log/설명/HTML주석 — 소멸 기록) | **CLOSED** |
| **V2-01 (Med)** | 016 corner/vartext/varimg optgroup option_refs 배선 | optgroup-016-corner→PROC_000027/028·vartext→031·varimg→032. L-18 부모정합 통과(has_process 실재) | **CLOSED** |
| **V2-03 (Med)** | 041 has_process 085(환각) 제거·031/032 추가·finish optgroup 085→031/032 | 그래프 041 has_process=004/029/030/031/032(085 **0**). **라이브** PRD_000041=동일 5공정. **라이브 PROC_000085 상품바인딩=0**(t_proc_processes엔 실재=True → 상품-공정 바인딩만 환각이었음 확증). optgroup-041-finish option_refs=029/030/031/032(085 없음) | **CLOSED** |
| **V2-05 (Low)** | 팩 §3.12 봉투 addon tmpl 010/011→005/006/009/038/039·STALE 함정 등재 | 팩 line 193 = 005/006/009/038/039·line 195 STALE 함정에 010/011 등재. **라이브** t_prd_product_addons PRD_000016 = TMPL-000005/006/009/038/039 정확 일치 | **CLOSED** |
| **V2-06 (Low)** | 인간 종합 리포트 엣지 425→430·§8 gap·§9 addon 정정 | `_meta/build-report-260703.md` line 12/55 엣지=430·rel 소계(has_process 39·option_refs 75·references 84·has_component 61) = graph.db 실측과 완전 동기. §8 GAP_016_material 신설·gap-016-process-nodes 제거 기록·§9 addon 부분해소 | **CLOSED** |
| **V2-01 (Low·arch)** | file-format v1.0.3: 유령 L-7 제거·`updated` 필수→선택 | grep L-7 = 규칙행 0(제거 설명·changelog 산문만). §2.1 필수=id·type·anchor·badge·sources 5개. §2.3에 updated(선택·권장). 빌더 코드 updated 미파싱 정합 | **CLOSED** |
| **V2-02 (Low·arch)** | graph-build v1.0.3 §3.1 블록 파싱 서술 정정(영문키·상속 없음) | graph-build-spec line 60 = "파일 frontmatter 자동 상속 없음·한글 라벨 미파싱·영문키". 빌더 parse_block(line 82-119) 영문키 `type/anchor/src/rel` 분기와 일치 | **CLOSED** |

---

## 교정이 만든 새 모순 수색 (0건)

- **제거된 gap-016-process-nodes dangling**: 잔여 언급 전부 log.md 이력·gaps.md/product-016 소멸 설명·HTML 주석 — 라이브 `[[ ]]` 참조 0(빌드 리포트 미해결참조 목록에 부재). 끊긴 링크·고아 유발 없음.
- **스키마 v1.0.3 정합**: file-format(필수 5필드·O4 soft·updated 선택) ↔ graph-build(§3.1 영문키·상속 없음·O4 I-set 제외) ↔ builder 코드 3원 무모순. hard=0 회귀 없음.
- **GAP_016_material 신설**: type=gap·badge=unknown·gap 3필드 구비(L-10 통과)·degree=2(product-016이 `[[ ]]` 참조 — floating 아님). V2-04를 조용한 누락 대신 정직 GAP로 선언 = 올바른 builder 처리.

## Open questions — 검증가 의견

1. **PROC_000085 소프트 고아 경계 (fix-log R2 상신)** — 실측: 085 degree=**in 1**(material-MAT_000105 `references`)·out 0. 즉 산문 참조로만 고아를 우연히 회피 중(고아 아님·모순 아님). **의견**: 085는 라이브에 실재하나 상품 미바인딩(가격 proc_grp 전용)이므로, (a) 축 카탈로그 노드로 유지하되 프론트/노트에 "가격 proc_grp 전용·상품 바인딩 없음" 명시하거나 (b) 031/032에 `derived_from(parent)` 엣지로 정식 연결해 MAT_000105 우연 참조 의존을 제거하는 편이 견고. **비차단**(현재 무결성 위반 아님) — architect 판단 대기. Low.

2. **V2-04 자재 subset 정책 (architect 상신)** — GAP_016_material로 17자재 커버리지 공백을 정직 선언(builder 처리 정확). 대표 subset 유지 vs 전수 민팅은 진짜 architect 완전성 정책 결정. **의견**: 파일럿 KB에서 "대표 subset + 커버리지 GAP 선언"은 방어 가능한 설계이나, builder 권고대로 **"비대표 축멤버 subset → 커버리지 GAP 선언 필수"를 wiki-inheritance/graph-build §5에 규약으로 못박아** ad-hoc이 아닌 표준으로 만들 것을 권고. **비차단**.

## 잔존 Low (사전 open question·신규 회귀 아님)

- **팩 §3.5 `15_domain-spec/digital-print/column-dictionary.md` rootless 경로** — 파일은 `_workspace/huni-dbmap/15_domain-spec/digital-print/column-dictionary.md`에 **실재**(dead-link 아님·단지 `_workspace/huni-dbmap/` 접두사 누락). **그래프 node source 아님**(graph.db 영향 0). V1-01A와 동류이나 R1이 정직하게 스코프 밖으로 유보한 사전 항목 → **여전히 OPEN**. 라우팅=curator. Low(외형). 교정: 팩 line 116 경로에 절대 접두사 부여.
- (관찰·결함 아님) `03_kb/log.md:23` "edges=425" 잔존 — append-only 이력 항목(line 32이 425→430 교정을 후속 기록). 타임라인·정상.

## 검증 범위·한계 (정직 표기)

- **전수 재실측**: 그래프 재빌드(멱등 독립 2회)·hard/soft·016·041 has_process/option_refs·optgroup 앵커·엣지 dedup·전 node source 38경로 존재성·스키마 v1.0.3 3원 정합·라이브 스냅샷 016/041 공정·085 바인딩·016 addon tmpl.
- **표본/미수행**: evaluate_price 실호출 가격값 오차 대조(라이브 DB 미접속·이 라운드는 배선·경로 실재까지)·단가행(component_prices) 셀값 정합·비파일럿 카탈로그. 이는 R1/R2 결함 범위 밖(가격 오차 라운드 별도).
- "무결" 단정 아님: 14행 CLOSED이나 위 open question 2건·잔존 Low 1건은 architect/curator 후속. blocklist 게이트는 실작동(적대 테스트 통과)이나 HARD 목록 5/5·advisory 2/2 범위 내에서만 방어.
