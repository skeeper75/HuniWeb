---
name: pkw-recipe-authoring
description: >
  후니프린팅 Print-KB LLM 위키(Karpathy 모델)의 레시피 페이지 집필 방법론. 상품군(11시트) 레시피의
  DB-anchored 뼈대(정체→차원→BOM→가격사슬→CPQ옵션→위젯계약→적재경로→결함), 원자 블록 컨벤션(출처·badge·
  [[교차참조]]), 단일 사실 원칙, index/log 워크플로, stale/v03 인용 금지. 트리거: 레시피 페이지 작성, 위키 집필,
  레시피 템플릿, 상품군 위키 작성, 횡단 축 페이지, 위키 컨벤션, 레시피 보완, 위키 갱신. 원천 큐레이션은
  pkw-source-curator, 검증 게이트는 pkw-wiki-evaluation 담당.
---

# Recipe Authoring — Print-KB LLM Wiki

`_workspace/print-kb/wiki/` 의 레시피·축 페이지를 집필하는 표준. 상위 컨벤션은 `wiki/README.md`(스키마 계층)가 권위 — 이 스킬은 그것을 레시피 페이지로 구체화한다. 충돌 시 README 우선.

## 1. 디렉터리 추가분

| 폴더 | 내용 | 소유 |
|---|---|---|
| `wiki/recipes/` | 상품군 레시피 11페이지 | LLM(writer) |
| `wiki/huni/` | 횡단 축 페이지(materials·processes·price-engine·cpq-options·widget-contract·load-path) | LLM(writer) |
| `wiki/_curation/` | family/axis 소스맵 | curator |
| `wiki/_research/` | 방법론 권고·base 검증 노트 | researcher |
| `wiki/_qa/` | W게이트 verdict | qa |

`_`-prefix 폴더는 위키 본문이 아니다(작업 산출) — index.md 카탈로그에 넣지 않는다.

## 2. 레시피 페이지 뼈대 (DB-anchored, HARD)

`wiki/recipes/<family>.md` — 섹션 순서 고정. 각 섹션은 라이브 t_* 실재 구조에 앵커된다. 앵커 불가 항목은 "앱 계산"(판수·박 등급 등) 또는 🔴 GAP(미모델링)으로만 존재할 수 있다 — 스키마 발명 금지.

```markdown
# <family> 레시피  {전체상태: ✅|🟡}

## 0. 정체 (identity)
상품 목록(prd_cd·prd_nm)·범주·세트/단일 구성·생산방식. 권위=실제 사이트>L1.
앵커: t_prd_products · t_cat_categories

## 1. 차원 (dimensions)
사이즈(이산/면적매트릭스 구분)·판형(출력용지규격)·묶음수·세트.
앵커: t_prd_product_sizes/plate_sizes/bundle_qtys/sets · t_siz_sizes

## 2. 자재·공정 BOM
자재(mat_cd+usage_cd, parent 합성 원칙)·공정(proc_cd, 별색=공정·코팅 family별 판정).
앵커: t_prd_product_materials/processes · t_mat_materials · t_proc_processes

## 3. 가격 사슬 (price chain)
공식 유형(원자합산/면적매트릭스/고정가/구간)·PRF→COMP→component_prices 사슬·
앱 계산 경계(판수=임포지션·off-grid ceiling)·구간할인(t_dsc_*).
앵커: t_prc_* 4단 + t_dsc_*

## 4. CPQ 옵션 레이어
option_groups(택1/택N)→options→option_items(polymorphic ref_dim_cd)·
BUNDLE 원칙(옵션=자재+공정)·캐스케이드 제약(JSONLogic).
앵커: t_prd_product_option_groups/options/option_items · constraints · templates

## 5. 위젯 계약 (widget contract)
componentType 매핑·정규화 계약(위젯은 DB 아닌 계약 의존)·어댑터 경계·
가격 권위(서버, PRICE=0 불가 신호).
앵커: 정규화 계약(huni-widget 04_build adapters) — DB 외 앵커임을 명시

## 6. 적재 레시피 (load path)
webadmin 입력 경로(admin UI 화면·필수 컬럼)·FK 위상 순서·멱등 패턴(이름 기반
UPSERT·search-before-mint)·코드행 선적재.
앵커: raw/webadmin sql/tools · round-8 admin-ui-spec

## 7. 현황·결함 (state)
적재 현황(round-7 매트릭스 셀)·round-13 교정 대기 목록(라이브 현재값 vs 정답)·
미결 결정(BATCH-N)·GAP.

## Sources
페이지 전체 인용 원천 목록(큐레이션 팩 ID 포함).
```

## 3. 원자 블록 컨벤션

README §3 그대로 + 레시피 확장:

```markdown
### [DGP-PR-001] 디지털인쇄 가격 공식은 원자합산형 6종  {✅}
- 내용: <한 줄 사실/규칙. 값·코드 명시>
- 앵커: t_prc_price_formulas (PRF_DGP_A~F)
- 출처: _workspace/huni-dbmap/.../price-load-validation-final.md §N
- 연결: [[price-engine#합산형]] · [[digital-print#가격]]
- answers_cq: CQ-023
```

- 항목ID = `<FAMILY약어>-<섹션약어>-NNN` (영문). 한 블록 = 한 조회가능 사실.
- **badge 규칙(HARD)**: ✅는 tier A/B 출처 또는 검증된 round 산출이 뒷받침할 때만. 🟡권장 출처만 있으면 블록도 🟡. 라이브 오적재 확정값은 `라이브 현재값 X → 정답 Y {🔴 교정대기}` 양면 표기.
- **단일 사실 원칙**: 횡단 사실(예: 별색=공정)은 축 페이지에 1회만 쓰고 레시피는 `[[links]]`. 복사 금지 — 갱신 시 모순의 뿌리가 된다.

## 4. 집필 워크플로 (Karpathy ingest 변형)

1. 큐레이션 팩 읽기(없으면 blocker) → 채택된 R-권고 확인.
2. 축 페이지 선행: 그 family가 참조할 횡단 사실이 축 페이지에 없으면 축 먼저 보강.
3. 레시피 집필: 뼈대 순서대로, 팩이 지목한 "정답 소스"만 인용. STALE/v03 인용 금지.
4. 교차참조: 관련 페이지 10~15개에 역링크 반영(기존 policy/base 포함).
5. `index.md` 카탈로그 갱신(1줄 요약+상태) → `log.md` append(`YYYY-MM-DD ingest <family> ...`).

## 5. 자주 틀리는 곳 (이 레포의 실증 교훈)

- 인용은 **의미 일치**까지 — 파일이 존재해도 그 §가 그 말을 안 하면 날조다(G-1·F-PB-1).
- 라이브 값 ≠ 사실. round-13 correction-manifest 미대조 인용 금지.
- 실사 사이즈=면적매트릭스(포스터사인 가격표 권위), round-2 좌표 모델 인용 금지.
- size↔option 재분류(굿즈파우치 448셀) 등 데이터모델 의도 전환은 "현재 모델" 기준으로 쓰고 전환 이력을 7절에 남긴다.
- 페이지가 500줄에 근접하면 하위 분할(`<family>-pricing.md`)하고 본문에 포인터.
