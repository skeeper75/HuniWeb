# 구축 리포트 — 공유축 통합·index·그래프 빌드 (확장) · 2026-07-03

> okb-knowledge-builder. 입력=상품 빌더 36 파일(017~051 확장) + needed_shared_nodes 보고.
> 산출=공유축 통합 mint + index/gaps 갱신 + 결정론 그래프 재빌드. **생성 산출물 — 검증은 별도 레인**(okb-adversarial-gate).
> 스키마 = `02_ontology/`(v1.0.x·법). 빌더 = `04_graph/build_graph.py`. 무결성 리포트 = `05_verification/build-report-20260703.md`.

---

## 1. 빌드 통계 (최종)

- **판정: PASS(하드 0)** · 하드 위반 **0** · 소프트 경고 120
- 노드 **466** · 엣지 **1521**
- 멱등: **2회 빌드 해시 동일 = True** (nodes.jsonl=`11a4c1727614a548` · edges.jsonl=`7e02a509a194e2e9`)
- 산출: `04_graph/nodes.jsonl`·`04_graph/edges.jsonl`·`04_graph/graph.db`(gitignore)

### 노드 수(타입별·17종)
| type | 수 | type | 수 |
|---|---|---|---|
| product | 36 | option_group | 78 |
| price_formula | 23 | constraint | 2 |
| price_component | 53 | gap | 67 |
| material | 56 | intent | 3 |
| size | 52 | rule | 7 |
| process | 37 | decision | 12 |
| category | 11 | term | 7 |
| bundle_qty | 15 | print_option | 4 |
| plate_size | 3 | | |

### 엣지 수(rel별)
has_process 165 · uses_material 146 · has_size 98 · has_option_group 78 · has_print_option 59 · in_category 59 · priced_by 39 · has_plate_size 34 · has_qty_rule 15 · **has_component 107** · option_refs 210 · constrains 3 · has_member 0 · has_addon 0 · decided_because 19 · supersedes 0 · derived_from 5 · alias_of 19 · references 465.

### badge 분포
verified 388 · unknown 67 · candidate 6 · defect 5 (총 466).

---

## 2. 공유축 통합 mint (21종 — 브로큰링크 해소·단일 소유권)

빌더 needed_shared_nodes를 검토해 **"실제 필요"(상품/결정/gap이 이미 참조하나 노드 부재 = 하드 브로큰링크)**만 공유축에 일괄 mint. 값은 스크립트 전사(`_meta/scripts/transcribe_shared_axis_260703.py` from live-snapshot snap_20260702_1119). 중복 id 0.

**해소 전 하드 11건(I-2 끊긴 링크) → 0.**

| 유형 | 파일 | mint(수) | 소비 상품 |
|---|---|---|---|
| material | `axis/materials.md` | MAT_000137·MAT_000144·MAT_000147·MAT_000178 (4) | 037·025·025/019·039 |
| price_formula | `formula/digital-formulas.md` | PRF_PHOTOCARD_CLEAR·PRF_NAMECARD_SHAPE·PRF_NAMECARD_MINISHAPE·PRF_NAMECARD_FOIL·PRF_NAMECARD_CLEAR (5) | 025·035·036·037·039 |
| price_component | `formula/digital-components.md` | COMP_PHOTOCARD_CLEAR_SET·NAMECARD_SHAPE_S1/S2·MINISHAPE_S1/S2·FOIL_S1_STD/S2_STD/S1_HOLO/S2_HOLO/SETUP_S1_STD/SETUP_S2_STD·CLEAR_S1 (12) | 위 5공식 has_component 배선 |

- 앵커 전수 L-17 통과(live-snapshot 실재). has_component 배선(disp_seq·addtn)=t_prc_formula_components 스크립트 전사. 자재 규격/평량=t_mat_materials 전사표(transcribed-by 마커). MAT_000178은 규격/평량 마스터 공란 → "미기재" 정직 표기(날조 0).

---

## 3. 미mint(정직 지연) — 카테고리 B needed_shared_nodes

빌더가 "승격 후보·advisory·mint 필수 아님·architect 판단"으로 flag했고, **상품이 edge를 걸지 않아 브로큰링크가 아닌** 분(honest GAP으로 지연). 무비판 mint 시 orphan 축 노드 양산+GAP 미해소(순증 가치 0)라 최소 변경 원칙으로 보류. GAP이 곧 지식(위반 아님).

- 018 자재 MAT_000080/090 (GAP_018_material) · 019 PET rewire+화이트공정 PROC_000008 (gap-019-*) · 020/040 색지4·별색공정008/009 product-local 유지(2소비=승격 후보·중복 dedup은 architect) · 021 핑크공정 PROC_000010·자재2 · 022 자재2 · 023 완칼 PROC_000123 승격(023/055 2소비) · 028/029 접지자식 PROC_000067/068 · 030 3절 판형/자재/공정 · 031/034/037 명함박 자식공정 PROC_000037~044 승격 · 044/045 사이즈 축승격 · 047/048 종이자재 다수(30+) · 050 봉투 사이즈/자재·category CAT_000058/065/181 · 051 category CAT_000181.
- 처리 경로: architect 축 승격 결정 + 상품 rewire(uses_material·option_refs·GAP 해소)를 **후속 라운드**로(각 상품 전사표 재생성 필요). 현 상태에서 이들은 상품별 GAP으로 색인(`rule/gaps.md` §확장 상품 GAP 색인).

---

## 4. GAP 현황 (67종·정직 노출)

- 횡단 6(`rule/gaps.md` 정의): GAP_pansu_73x98·GAP_roll_material_price·GAP_envelope_set_model·GAP_foil_parent_children·GAP_transparent019_pansu·GAP_product_count.
- 상품별 61(상품 파일 정의·gaps.md 색인): 자재 미민팅·봉투 addon 대상 미노드·코팅면수/가변 파라미터 미보존·타공비 배선 vs 공정 미등록·박색 선택 옵션 미표현·완칼 골든 미검증·제약 스냅샷 지연 등.
- ★가격경로 관련 GAP: gap-048-price-path-incomplete(접지비만 배선·인쇄/용지 미배선)·gap-038-no-price-path(priced_by 0→derived_from→gap·O5 예외)·022 별색 미배선·025 화이트별색 BLOCKED.

---

## 5. BLOCKED (스키마 변경 요청)

- **없음.** 스키마 밖 유형/관계/필드 신설 불요 — 전 mint가 기존 17종 개체·19종 관계로 표현. 042 PRF_DGP_A_FOIL·박색 8자식 승격 등은 스키마가 아니라 데이터/축승격 후속(architect·staff 소관).

---

## 6. 무결성 6검사

| 검사 | 결과 |
|---|---|
| I-1 고아(하드 유형 product/formula/component) | **0** (소프트 연결대기 11=축 노드·floating gap) |
| I-2 끊긴 링크 | **0** (11건→0 해소) |
| I-3 타입 위반 | **0** |
| I-4 필수 엣지(O5 product priced_by·O6 formula has_component) | **0** (36/36 가격경로·23공식 전부 has_component≥1) |
| I-5 멱등(2회 빌드 해시 동일) | **True** |
| I-6 오염(blocklist src_id/path) | **0** (blocklist.md 실재·게이트 작동) |

L-18(option_refs 부모정합 fn_chk_opt_item_ref) 하드 위반 0. 소프트 120 = 본문 [[ ]] 미해결 참조 91(서술·엣지 미생성)·L-12 산문 수치 19(기존·mint 노드 무관)·I-1 연결대기 11(축 노드). 정직 GAP·soft는 위반 아님.

---

## 7. 상품별(36) 가격 경로 연결 현황

> priced_by→공식→has_component→구성요소 사슬. comp#=공식이 배선한 구성요소 수(evaluate_price 값 계산은 온톨로지 밖·D-18). **36/36 연결**(35 공식배선·038 GAP-O5).

| 상품 | 공식(priced_by) | comp# | 경로 |
|---|---|---|---|
| 016 프리미엄엽서 | PRF_DGP_A | 10 | OK |
| 017 코팅엽서 | PRF_DGP_A | 10 | OK |
| 018 스탠다드엽서 | PRF_DGP_A | 10 | OK |
| 019 투명엽서 | PRF_DGP_A | 10 | OK |
| 020 화이트인쇄엽서 | PRF_DGP_A | 10 | OK |
| 021 핑크별색엽서 | PRF_DGP_A | 10 | OK(별색 미배선 GAP) |
| 022 금은별색엽서 | PRF_DGP_A | 10 | OK(별색 미배선 GAP) |
| 023 모양엽서 | PRF_DGP_B | 3 | OK |
| 024 포토카드 | PRF_PHOTOCARD_NORMAL | 2 | OK |
| 025 투명포토카드 | PRF_PHOTOCARD_CLEAR | 1 | OK(통합 mint) |
| 026 종이슬로건 | PRF_DGP_A | 10 | OK |
| 027 2단접지카드 | PRF_DGP_E,+_FOIL | 25 | OK |
| 028 미니접지카드 | PRF_DGP_E | 11 | OK(박분기 GAP) |
| 029 3단접지카드 | PRF_DGP_E,+_FOIL | 25 | OK |
| 030 지그재그엽서 | PRF_DGP_C_6CR | 4 | OK |
| 031 프리미엄명함 | PRF_NAMECARD_PREMIUM,+_FOIL | 17 | OK |
| 032 코팅명함 | PRF_NAMECARD_COAT | 2 | OK |
| 033 스탠다드명함 | PRF_NAMECARD_FIXED | 2 | OK |
| 034 펄명함 | PRF_NAMECARD_PEARL,+_FOIL | 7 | OK |
| 035 모양명함 | PRF_NAMECARD_SHAPE | 2 | OK(통합 mint) |
| 036 미니모양명함 | PRF_NAMECARD_MINISHAPE | 2 | OK(통합 mint) |
| 037 오리지널박명함 | PRF_NAMECARD_FOIL | 6 | OK(통합 mint) |
| 038 형압명함 | (none·derived_from→gap) | - | GAP-O5(가격사슬 부재 정직) |
| 039 투명명함 | PRF_NAMECARD_CLEAR | 1 | OK(통합 mint) |
| 040 화이트인쇄명함 | PRF_NAMECARD_WHITE | 4 | OK |
| 041 스탠다드 쿠폰/상품권 | PRF_DGP_A | 10 | OK |
| 042 프리미엄 쿠폰/상품권 | PRF_DGP_A | 10 | OK(박분기 PRF_DGP_A_FOIL=GAP) |
| 043 인쇄배경지(OPP) | PRF_DGP_C | 4 | OK(타공비 GAP) |
| 044 인쇄배경지(투명케이스) | PRF_DGP_C | 4 | OK(타공비 GAP) |
| 045 인쇄헤더택 | PRF_DGP_C | 4 | OK(타공비 GAP) |
| 046 라벨/택 | PRF_DGP_B | 3 | OK |
| 047 소량전단지 | PRF_DGP_D | 10 | OK |
| 048 접지리플렛 | PRF_FOLD_SUM | 1 | OK·★불완전(접지비만·gap-048-price-path-incomplete) |
| 049 와이드 접지리플렛 | PRF_DGP_E | 11 | OK |
| 050 봉투제작 | PRF_ENV_MAKING | 1 | OK(매트릭스 60행) |
| 051 썬캡 | PRF_DGP_F | 3 | OK(use_yn=N) |

**연결 36/36.** 형식 연결과 의미 완전성은 다름 — 048(접지비만)·042(박분기 미바인딩)·021/022(별색 미배선)은 경로는 살아있으나 GAP으로 미완 명시(검증가 판정 대상).

---

## Sources
- `02_ontology/`(ontology-schema·file-format-spec·graph-build-spec v1.0.x) — 개체 17·관계 19·lint·무결성.
- `04_graph/build_graph.py` — 결정론 빌드(멱등·L-17 닫힌세계·I-1~I-6).
- `_meta/scripts/transcribe_shared_axis_260703.py` — 21 공유노드 수치 전사(live-snapshot snap_20260702_1119).
- `05_verification/build-report-20260703.md` — 빌더 자동 무결성 리포트(하드 0·소프트 120).
- 상품 빌더 36 파일 needed_shared_nodes 보고(017~051).
