export const meta = {
  name: 'okb-stationery-set-build-stageB',
  description: '문구 셋트(SB-1) KB 확장 Stage B — 3 클러스터 병렬 빌드(부모+구성원 25노드)',
  phases: [{ title: 'Build', detail: '3 클러스터 빌더 병렬(자기 파일만·공유축 반환)' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-stationery-goods.md`
const FOUNDATION = '/Users/innojini/Dev/HuniWeb/_workspace/_foundation'

const COMMON = `
§33 Huni-Ontology-KB 확장 — 문구 셋트(SB-1) **Stage B 클러스터 빌더**. Stage A가 공유 스캐폴드(문구 셋트 공식 PRF_STN_* 9·구성요소 COMP_STN_* 9·제본공정·종이자재·GAP4)를 이미 mint했다. 셋트 계열(122상품 GO) 패턴 재사용. 너는 **배정 클러스터의 부모 셋트 + 구성원 반제품 상품 노드만** 자기 파일에 구축한다.

## 입력(정독)
- 큐레이션 팩(정답·전 축): ${PACK} — §1.1 문구 셋트 인벤토리(prd_cd·확정 slug·구성원·아키타입·sparse)·§3 축별·§4 양면/GAP표·§6 인계메모.
- 셋트 계열 선례 노드(형식·규약 재사용): ${KB}/03_kb/product/product-094-postcard-book.md·product-072-hardcover-booklet.md(고정가형 셋트·has_member·derived_from 부모·양면·구성원 slug).
- 스키마: ${KB}/02_ontology/ontology-schema.md(has_member 부모→구성원 R13 단방향·member_of 없음·derived_from·priced_by·가격아키타입) + file-format-spec.md + graph-build-spec.md(L-1·I-4·L-18).
- Stage A 공유공식 slug: formula-PRF_STN_DIARY_SOFT(172)·_HARD(173)·_LHARD(174)·_LSOFT(175)·PRF_STN_MONTHLY(176)·PRF_STN_SPRINGNOTE(177)·PRF_STN_SPRINGNOTEBK(178)·PRF_STN_MEMOPAD(179)·PRF_STN_JUNGCHEOL(181). 각 has_component→component-COMP_STN_*.
- 라이브 캐시 ${FOUNDATION}/live-snapshot/latest/ + RAILWAY_DB(읽기전용 SELECT)·수치 awk 전사·손전사 금지.

## 공통 규칙(HARD·셋트 계열 교훈 계승)
- **slug 정본 = product-NNN-kebab**[HARD·팩 §1.1 확정 slug]. 파일명=id.md(L-1). 구성원(PRD_TYPE.02)=product-NNN-<부모>-<역할>.
- **셋트 관계**: 부모 -> has_member(구성원)·priced_by(PRF_STN_*)·가격아키타입 prop(고정가형·evaluate_set_price note). 구성원 -> **자체 공식 없으면 derived_from 부모**(priced_by 위조 금지·셋트 계열 095/096/098 교훈)·member_of는 references [[부모]]+props(엣지 아님·member_of 관계 없음). 역할 SEMI_ROLE.01 내지/.02 표지/.03 면지.
- **★sparse grid(T-9)**: 문구 셋트 완제품가 단가행 1~2셀만 → priced_by=PRF_STN_* 정본 + props "단가행 N셀(sparse·전 사이즈 견적0 아님)" + references [[gap-stn-sparse-grid]]. **전 사이즈 PRICE≠0 아니므로 부모 badge=candidate(🟡)**(공식 존재≠가격 완성). 라이브 실측 셀수 전사.
- **★product 프론트매터 노드 badge=defect 금지**(L-9는 블록노드만) — 양면은 **badge=verified/candidate + gap 노드 references**(088 선례).
- **종이 구성원만 판형**(표지/내지/면지)·비종이 없음. 만년다이어리 172/175=표지만·173/174=표지+면지(내지없음)·176~181=표지+내지.
- **출처5필드+badge 필수**·수치 transcribed(손전사 금지)·STALE 인용 금지(팩 §2)·라이브값="현재값".
- **공유 파일(index.md·axis/*·formula/*·gaps.md) 편집 금지**(Stage C·A 소관). 축 노드 참조만·미민팅은 needs_axis 반환. 클러스터-로컬 노드(옵션그룹 등)는 자기 product/ 파일에.
- 라이브 읽기전용 SELECT만·침묵 누락 금지.

## 반환(초소형·schema)
cluster·files(경로배열)·product_ids(id배열)·needs_axis("id|anchor|설명|출처" 배열)·notes(양면/sparse/미해결 1~2문장).
`

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['cluster', 'files', 'product_ids', 'needs_axis', 'notes'],
  properties: {
    cluster: { type: 'string' },
    files: { type: 'array', items: { type: 'string' } },
    product_ids: { type: 'array', items: { type: 'string' } },
    needs_axis: { type: 'array', items: { type: 'string' } },
    notes: { type: 'string' },
  },
}

const CLUSTERS = [
  {
    key: 'diary',
    spec: `배정 = **만년다이어리 172/173/174/175**(표지 위주·내지 없음).
- 172 만년다이어리(소프트커버) product-172-perpetual-diary-soft · 구성원 293 표지만(.02·면지/내지 없음). priced_by=PRF_STN_DIARY_SOFT.
- 173 만년다이어리(하드커버) product-173-perpetual-diary-hard · 구성원 294 표지(.02)·295 면지(.03·무가격). priced_by=PRF_STN_DIARY_HARD·단가행 1셀(130x190=12,000).
- 174 만년다이어리(레더하드) product-174-perpetual-diary-leather-hard · 296 표지 레더(.02)·297 면지(.03). priced_by=PRF_STN_DIARY_LHARD.
- 175 만년다이어리(레더소프트) product-175-perpetual-diary-leather-soft · 298 표지만(.02). priced_by=PRF_STN_DIARY_LSOFT.
- 구성원 slug: 293=product-293-perpetual-diary-soft-cover·294=-hard-cover·295=-hard-membrane·296=-leather-hard-cover·297=-leather-hard-membrane·298=-leather-soft-cover. 구성원 derived_from 부모·면지 무가격·표지 자체공식0. 전부 sparse→부모 badge=candidate.`,
  },
  {
    key: 'planner-spring',
    spec: `배정 = **176 먼슬리플래너 + 177 스프링노트 + 178 스프링수첩**(표지+내지).
- 176 먼슬리플래너 product-176-monthly-planner · 299 표지(.02)·300 내지(.01·28p고정). priced_by=PRF_STN_MONTHLY.
- 177 스프링노트 product-177-spring-note · 301 표지(.02)·302 내지(.01·무지). priced_by=PRF_STN_SPRINGNOTE. **★양면(팩 §3.1·T·gap-stn-177-classification)**: prd_typ_cd 라이브=**.02(반제품)** but SOT=셋트 완제품(t_prd_product_sets 부모). badge=verified·props both_sided(current .02 / authority 셋트완제품)·references [[gap-stn-177-classification]](badge=defect 프론트매터 쓰지 마라·088 선례).
- 178 스프링수첩 product-178-spring-notebook · 303 표지(.02)·304 내지(.01·무지). priced_by=PRF_STN_SPRINGNOTEBK.
- 구성원 slug: 299=product-299-monthly-planner-cover·300=-monthly-planner-inner·301/302=-spring-note-{cover,inner}·303/304=-spring-notebook-{cover,inner}. 종이 내지=판형 대상. 무지 내지 302/304 min/max 미설정→[[gap-stn-muji-inner-minmax]]. 전부 sparse→부모 candidate.`,
  },
  {
    key: 'memo-jungcheol',
    spec: `배정 = **179 메모패드 + 181 중철노트**(표지+내지).
- 179 메모패드 product-179-memo-pad · 305 표지(.02)·306 내지(.01·무지). priced_by=PRF_STN_MEMOPAD·**단가행 2셀**(문구 셋트 중 유일·다른 건 1셀).
- 181 중철노트 product-181-jungcheol-note · 307 표지(.02)·308 내지(.01·무지·중철제본). priced_by=PRF_STN_JUNGCHEOL.
- 구성원 slug: 305/306=-memo-pad-{cover,inner}·307/308=-jungcheol-note-{cover,inner}. 무지 내지 306/308 min/max 미설정→gap. 종이 내지 판형. sparse→부모 candidate(179는 2셀이라 일부 사이즈 PRICE≠0 가능·라이브 실측 확인).`,
  },
]

const results = await parallel(
  CLUSTERS.map((c) => () =>
    agent(`${COMMON}\n\n## ★배정\n${c.spec}`, {
      label: `build:${c.key}`, phase: 'Build', schema: SCHEMA, model: 'opus',
    })
  )
)

const ok = results.filter(Boolean)
log(`Stage B 완료: ${ok.length}/3 클러스터`)
return {
  clusters: ok.map((r) => r.cluster),
  total_files: ok.reduce((a, r) => a + (r.files?.length || 0), 0),
  total_products: ok.reduce((a, r) => a + (r.product_ids?.length || 0), 0),
  all_needs_axis: [...new Set(ok.flatMap((r) => r.needs_axis || []))],
  per_cluster: ok.map((r) => ({ cluster: r.cluster, products: r.product_ids?.length || 0, needs: r.needs_axis?.length || 0, notes: r.notes })),
}
