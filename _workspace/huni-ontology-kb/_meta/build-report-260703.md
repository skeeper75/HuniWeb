# 구축·그래프 빌드 리포트 — 2026-07-03 (Phase 4 통합)

> 작성: okb-knowledge-builder · 정본 `03_kb/` → `04_graph/`. 생성=빌드(검증은 별도 레인 okb-adversarial-gate).
> 결정론 리포트(자동)=`05_verification/build-report-20260703.md`. 본 문서=세션 종합(통합·승격·연결 현황·GAP·BLOCKED).

## 1. 판정 요약

| 항목 | 값 |
|---|---|
| 판정 | **PASS (하드 위반 0)** |
| 노드 | 204 (유일 204·중복 0) |
| 엣지 | 430 (R2 배선 교정 반영·결정론 리포트 `build-report-20260703.md`와 동기) |
| 소프트 경고 | 30 (전부 정상 — 미해결 [[ ]] 외부/companion 참조 12 + Phase 4 연결대기 축 10 + L-12 산문 수치 8) |
| 멱등(I-5) | **True** (2회 빌드 nodes/edges.jsonl 해시 동일) |
| nodes.jsonl 해시 | `f116635ef5b55181` |
| edges.jsonl 해시 | `da3e882a7272347d` |

> ★2026-07-03 R2 갱신(fix-log R2): 엣지 420→430(016 has_process 3→7·option_refs +4 / 041 has_process 085→031·032·option_refs 085→031·032). 직전 표기 "425"는 R1 dedup 전 값 잔재(결정론 산출물은 420이었음)로 stale였음 → 결정론 리포트 실측 430으로 동기화.

## 2. 이번 세션 작업 (통합·승격·빌드)

### 2.1 index.md 통합 (상품 에이전트 5종 산출)
- `### 상품 노드 (E1·Phase 4)` 섹션 신설 — 대표 8상품 + companion 파일(-nodes/-cpq/-axes/-sizes) 전부 링크(O4 index 미등재 116→0).
- 대표 8상품 로드맵: 헤더 "집필 대기"→"완료 8/8", `상태` 컬럼 추가·8행 집필완료 표기.
- product-027 공식 각주: 로드맵 `PRF_DGP_E(+FOIL)` → 실 바인딩 2공식(`PRF_DGP_E`·`PRF_DGP_E_FOIL`) 확정 각주.
- 검색 라우팅 시작점 1(구체 상품 질의)=product-016 실링크·4(옵션·제약)=optgroup-016-*·constraint-016-demo-exc(오시↔미싱 상호배제) 실예시.
- 축 카운트 갱신(승격 반영): size 8→10·material 6→7·process 12→18. gaps 6→15(횡단6+상품9).
- log.md append(연대기)·gaps.md 상품별 GAP 링크 색인(노드 재정의 아님)·sizes.md 046 사이즈 승격대기 노트.

### 2.2 공유 축 승격 (형제 open_questions 해소 · R2 016 배선 근거)
2+ 상품이 공유하는 마스터 노드가 상품-local 파일에 "임시 거처"로 있어 병렬 빌드 시 L-3 중복 위험(016 보고 "11건"). 단일 소유권을 공유 axis로 확정(값=이미 전사 완료·anchor+src 자립 출처라 손전사 0). ★이 축 노드 공급이 **R2에서 016·041 has_process·option_refs 라이브 부합 배선의 근거**가 됐다(옛 gap-016-process-nodes 대상 소멸 — 아래 §8·fix-log R2). R1 시점 "gap 해소" 표기는 노드 민팅만 됐고 016 배선은 미완이라 조급했음 → R2 배선 완료로 실체 정합:

| 승격 노드 | from(상품-local) | to(공유 축) | 실 참조 상품 수 |
|---|---|---|---|
| process-PROC_000014/015 유광/무광라미 | 032 | axis/processes.md | 4 (032·024 +optgroup) |
| process-PROC_000027/028 직각/둥근 모서리 | 033 | axis/processes.md | 6 (032·033·024 +optgroup) |
| process-PROC_000031/032 가변텍스트/이미지 | 033 | axis/processes.md | 4~5 (033·027 +optgroup) |
| size-SIZ_000008/133 명함 90x50·86x52 | 033 | axis/sizes.md | 2 (032·033) |
| material-MAT_000109 몽블랑 240g | 046 | axis/materials.md | 4 (027·046 +참조) |

- 상품 파일(033/032/046)의 중복 정의 블록 제거 → relations(has_process/has_size/uses_material)가 축 노드로 resolve. 노드 총계 불변(204·이동만·중복 0).
- **미승격(정당·단일 소비자)**: SIZ_000011(50x50·미니모양명함 공용 후보)·SIZ_000047·SIZ_000048 = 046 단독 → axis/sizes.md에 "승격 대기" 노트(2번째 소비 상품 집필 시 승격). 치수 전사표(스크립트 산출)는 상품 파일에 유지.

## 3. 노드 수 (타입별 · 총 204)

| type | n | type | n | type | n |
|---|---|---|---|---|---|
| product | 8 | size | 28 | option_group | 29 |
| category | 8 | material | 18 | constraint | 2 |
| price_formula | 10 | process | 28 | bundle_qty | 2 |
| price_component | 26 | print_option | 4 | intent | 3 |
| plate_size | 1 | term | 7 | rule | 7 |
| decision | 8 | gap | 15 | | |

## 4. 엣지 수 (rel별 · 총 430)

has_component 61 · option_refs 75 · references 84 · has_size 29 · has_option_group 29 · has_process 39 · uses_material 32 · alias_of 19 · has_print_option 15 · in_category 12 · decided_because 11 · priced_by 9 · has_plate_size 8 · constrains 3 · derived_from 2 · has_qty_rule 2.

> 수치 원천=결정론 리포트 `05_verification/build-report-20260703.md`(손계산 아님). R2 변화: has_process 34→39·option_refs 70→75·references 89→84(R2 배선 교정에서 옛 gap 참조 산문 제거).

## 5. badge 분포

| badge | n | 비고 |
|---|---|---|
| verified | 184 | 라이브 실측·권위 대조분 |
| unknown | 15 | GAP 노드(정직 공백·⚪) |
| candidate | 5 | constraint-016-demo-exc/vis [DEMO](§31 확정 대기) 포함 |
| defect | 0 | 현 파일럿에 양면(현재값 vs 정답) 노드 없음 |

## 6. 무결성 6검사 결과

| 검사 | 결과 |
|---|---|
| I-1 고아(하드 유형 product/formula/component) | **0** |
| I-2 끊긴 링크(dst/src 미실재) | **0** |
| I-3 타입 위반(rel src/dst 타입) | **0** |
| I-4 필수 엣지(O5 product priced_by·O6 formula has_component) | **0 위반** (product 8/8 priced_by·formula 10/10 has_component≥2) |
| I-5 멱등(2회 빌드 해시 동일) | **True** |
| I-6 오염(blocklist src_id 인용) | **0** |

- I-1 소프트(연결 대기·Phase 4) 10건: printopt-POPT_000008/009·process-PROC_000001/007/013/056·size-SIZ_000499·GAP 3(roll/transparent019/product_count). 미집필 상품군 확장 시 연결(정상).

## 7. 상품별 가격 경로 연결 현황 (priced_by → 공식 → has_component)

| 상품 | prd_cd | priced_by 공식 | 구성요소 수 | 경로 |
|---|---|---|---|---|
| product-016-premium-postcard | PRD_000016 | PRF_DGP_A | 10 | ✅ 연결 |
| product-024-photocard | PRD_000024 | PRF_PHOTOCARD_NORMAL | 2 | ✅ 연결(고정가) |
| product-027-bifold-card | PRD_000027 | PRF_DGP_E · PRF_DGP_E_FOIL | 11 · 14 | ✅ 연결(박 분기 2공식) |
| product-032-coated-namecard | PRD_000032 | PRF_NAMECARD_COAT | 2 | ✅ 연결(고정가) |
| product-033-standard-namecard | PRD_000033 | PRF_NAMECARD_FIXED | 2 | ✅ 연결(고정가) |
| product-041-coupon | PRD_000041 | PRF_DGP_A | 10 | ✅ 연결(A 공유) |
| product-043-bg-opp | PRD_000043 | PRF_DGP_C | 4 | ✅ 연결 |
| product-046-label-tag | PRD_000046 | PRF_DGP_B | 3 | ✅ 연결(완칼) |

- 8/8 상품 가격 경로 연결·고아 공식 0. 최종 값은 evaluate_price/견적기 권위(D-18 — KB는 배선까지).

## 8. GAP 목록 (15 · 정직 공백·위반 아님)

**횡단 6(rule/gaps.md):** GAP_pansu_73x98(판걸이수 15v18·staff)·GAP_roll_material_price(롤 로직·staff)·GAP_envelope_set_model(봉투세트 모델·사용자)·GAP_foil_parent_children(박 부모/8자식·staff)·GAP_transparent019_pansu(투명019 자재종속·dev C트랙)·GAP_product_count(상품수 분모·설계).

**상품별 9(상품 파일 정의·gaps.md 링크 색인):**
- GAP_016_material(016 활성자재 21종 중 17종 공유 axis/materials 미민팅·그래프 커버리지 공백·대표 4종만 배선)·owner=설계. ※옛 gap-016-process-nodes(공정 4행 미민팅)는 R2에서 축 노드 민팅+016 has_process 3→7·option_refs 배선 완료로 **대상 소멸·제거**(해소 판정은 검증가 몫·fix-log R2 V2-02).
- gap-016-addon-target(봉투 addon 대상 상품/template 미민팅·tmpl live 038/039 vs 팩 010/011 불일치)·owner=설계
- gap-024-addon-envelope·gap-027-addon-envelope(봉투 addon 대상 product 노드 미구축)·owner=설계
- GAP_032_coat_side(코팅 면수·고정가 가격무영향)·owner=staff/§31
- gap-033-vardata-param·GAP_finish_param_041(가변데이터 줄수·개수 미보존)·owner=위젯/§31
- GAP_043_perf_process(배경지 타공비 배선 vs 타공 공정 미등록)·owner=dev
- gap-046-diecut-golden(완칼 골든 절대값 미검증·.01→.03 교정 후 pcode 미상)·owner=dev

## 9. BLOCKED 목록

| BLOCKED | 상태 |
|---|---|
| (016) 공유 축 마스터노드 L-3 중복 11건(형제 병렬 mint) | **해소** — §2.2 축 승격으로 단일 소유권 확정·중복 0 |
| (046) 완칼 모양(나뭇잎/별타공/리니니)×사이즈 물리제약 미확정 | **대기** — §31 제약규칙 거버넌스 소관·데모 미착수라 제약 노드 미생성(GAP 아닌 대기) |
| (016 open) 봉투 addon tmpl_cd live 038/039 vs 팩 010/011 불일치 | **부분 해소(R2)** — 팩 §3.12 서술을 038/039로 교정(V2-05·STALE 함정에 010/011 등재). 잔여=대상 봉투 상품/template 노드 미민팅→has_addon 미배선(gap-016-addon-target) |
| 스키마 변경 요청(신규 유형/관계/필드) | **없음** — 17유형·19관계로 8상품 전 구성요소 표현(mint 불요) |

## 10. 잔여 open questions (구축가 소관 밖·상신)

1. **[architect] 공유 축 단일 소유권 규약 명문화** — 이번 5종은 승격 완료. 향후 마스터 노드는 "알파벳 최초 파일 소유" 또는 "2+ 소비 즉시 axis 승격" 규약을 SKILL/컨벤션에 확정(현재는 사후 정리).
2. **[architect·L-17] option_group 복합키 앵커** — t_prd_product_option_groups는 (prd_cd+opt_grp_cd) 복합키이나 col0=prd_cd라 닫힌세계 검사가 opt_grp_cd 미검증. props.opt_grp_cd+정밀 source_locator로 통과 중. 복합키 앵커 허용 규칙(예 `t_.../PRD_000027:OPT_000029`) 신설 검토.
3. **[설계·L-12] 상품레벨 수량 표현 컨벤션** — bundle_qtys 행 없는 상품(027/033/046)은 수량을 props 스칼라(min/max/incr)로 접음. 별도 bundle_qty 노드 승격 여부 컨벤션 확정(현재 props 접기·L-12 예외).
4. **[curator] 봉투 addon tmpl_cd 불일치** — live 038/039 vs 팩§3.12·위키 서술 010/011. live 우선 채택했으나 원 서술 낡음 여부 확정.
5. **[§31] R_DEMO_VIS/R_DEMO_EXC·046 커팅모양 제약** — [DEMO] 제약(badge=candidate)의 생산규칙 격상·완칼 모양×사이즈 물리제약은 제약규칙 거버넌스 확정 대기.
6. **[§17] SIZ_000524/525 표시중복 후보** — 접힌 135×135 동일·펼침 방향만 상이(가로 270×135 vs 세로 135×270). KB는 양쪽 라이브 기록·dedup 판정은 §17 소관(병합 안 함).

## Sources
- `04_graph/nodes.jsonl`·`edges.jsonl`·`graph.db` (빌드 산출)
- `05_verification/build-report-20260703.md` (결정론 자동 리포트)
- `_foundation/live-snapshot/latest/` (앵커 실재검사·전사 원천·재사용)
- `01_curation/pack-digital-print.md` (원천 큐레이션 팩) · `02_ontology/` v1.0.1 (스키마·빌드 명세)
