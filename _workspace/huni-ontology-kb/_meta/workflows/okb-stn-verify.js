export const meta = {
  name: 'okb-stationery-set-verify',
  description: '문구 셋트(SB-1) Phase 4 — 3축 적대검증(출처·오염 / 무결성 / 가격경로)',
  phases: [{ title: 'Verify', detail: '3축 병렬 → 결함 보드' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-stationery-goods.md`

const SCOPE = `
## 검증 범위 = 문구 셋트(SB-1) 신규 노드(2026-07-03)
- 상품 25: 부모 9(172/173/174/175 만년다이어리·176 먼슬리·177 스프링노트·178 스프링수첩·179 메모패드·181 중철노트) + 구성원 16(293~308)
- 공유(Stage A): formula/stationery-formulas.md(공식9 PRF_STN_*)·stationery-components.md(구성요소9)·GAP4(gap-stn-*)
- 축(Stage C1): category CAT_000321·size 4·plate 5·qty 3 + 배선 엣지(Stage C2)

## 권위·규칙(HARD)
- 권위: 상품마스터·인쇄상품 가격표 **260702**. 팩=${PACK}(정답소스·§2 STALE·§4 양면/GAP).
- **생성자 주장 비신뢰** — 직접 재실측(라이브 SELECT·live-snapshot awk·evaluate_set_price 실호출). 기계 대조 우선.
- 라이브 읽기전용 SELECT만·손전사 금지.
`

const AXES = [
  {
    key: 'prov', out: `${KB}/05_verification/defect-stnset-prov-260703.md`,
    task: `**축 1: 출처 실재성 + 권위 정합 + 오염 적발.**
- 출처 실재성: 25 노드 sources[] 인용(파일:절·라이브 쿼리) 직접 재확인(t_prd_product_sets·t_prd_products·t_prc_component_prices).
- 권위 정합: sparse 단가행 셀수(만년다이어리 1셀·179 메모패드 2셀 등)를 라이브 t_prc_component_prices awk로 실측 대조. 173 하드=130x190 12,000 등 실재 확인. **공식 존재≠가격 완성 정직 표기** 재확인.
- 오염 적발(STALE): 팩 §2 함정(T-2 위키 stationery.md "미싱제본 MISSING"·ST-01~16 결함표 시점·T-6 문구셋트 단일 evaluate_price·T-9 grid "채워짐" 가정). 구권위 잔재·라이브 오적재를 정답으로 오기했는지.
- ★177 conflict: current(.02) vs authority(셋트완제품) 양면 정직·badge=defect 프론트매터 미사용(candidate+props+gap) 확인.`,
  },
  {
    key: 'integrity', out: `${KB}/05_verification/defect-stnset-integrity-260703.md`,
    task: `**축 2: 그래프 무결성 + 연결 완전성.**
- 재빌드(python3 04_graph/build_graph.py)·하드0 재확인·멱등(해시 동일)·전 그래프 I-1 고아 0 확인.
- member_of 엣지 0·폐쇄 어휘 19종 밖 0·L-1 파일명↔id·L-18 부모정합·has_member 카디널리티.
- **구성원 O5**: 293~308 자체공식 0행 → derived_from 부모로 충족(priced_by 위조 아닌지 라이브 t_prd_product_price_formulas 실측). 특히 면지 295/297·무지내지 302/304/306/308 empty-shell 정직.
- **candidate 정합**: 부모 9 전부 badge=candidate(sparse·전 사이즈 PRICE≠0 아님) 근거 실재. 179만 2셀.
- index.md 25 등재·dead-link 0·plate/size/qty 축 노드 정합(L-17 정션 대표키).`,
  },
  {
    key: 'pricepath', out: `${KB}/05_verification/defect-stnset-pricepath-260703.md`,
    task: `**축 3: 가격 경로 연결 완전성 + sparse 정직성.**
- 각 부모: 상품→priced_by→PRF_STN_*→has_component→COMP_STN_* 경로 끊김 없이 추적. evaluate_set_price(구성원 합산+부모 완제품가) 계약 반영.
- **★sparse grid 정직성 실측**: 각 부모의 COMP_STN_* 단가행 셀수를 라이브 awk 실측 → 노드가 "N셀·전 사이즈 견적0 아님·gap-stn-sparse-grid" 정직 표기했는지. 라이브 evaluate_set_price 실호출로 sparse 좌표(예 173 130x190)는 PRICE≠0·off-grid는 견적0 확인.
- 구성원 derived_from 부모·면지 무가격(component_prices 0행)·무지내지 empty-shell 정직.
- GAP 정직성: 177 conflict·sparse grid·무지내지 min/max·구성원 UI — "가격 있는 것처럼" 넣지 않았는지.
- 비종이 표지(레더 296/298)=판형없음 정합·종이 구성원만 판형.`,
  },
]

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['axis', 'defect_file', 'high', 'medium', 'low', 'top_defects', 'verdict'],
  properties: {
    axis: { type: 'string' }, defect_file: { type: 'string' },
    high: { type: 'integer' }, medium: { type: 'integer' }, low: { type: 'integer' },
    top_defects: { type: 'array', items: { type: 'string' } },
    verdict: { type: 'string' },
  },
}

const COMMON = `§33 Huni-Ontology-KB 확장 — 문구 셋트(SB-1) **Phase 4 적대적 검증가**(생성≠검증). 구축가 산출을 신뢰하지 않고 반증한다.
${SCOPE}
## 산출
결함 보드를 <defect_file>에 작성(노드·유형·증거[재현쿼리/파일:절]·영향·교정안·라우팅). High/Medium/Low. 원천결함(실무진/코드 C트랙·sparse grid 원천부재)은 "격리". 반환은 초소형 schema만.`

const results = await parallel(
  AXES.map((a) => () =>
    agent(`${COMMON}\n\n## ★배정 축\n결함 보드: ${a.out}\n${a.task}`, {
      label: `verify:${a.key}`, phase: 'Verify', schema: SCHEMA, model: 'opus',
    })
  )
)
const ok = results.filter(Boolean)
log(`Phase 4 완료: ${ok.length}/3`)
return {
  axes: ok.map((r) => ({ axis: r.axis, high: r.high, medium: r.medium, low: r.low, verdict: r.verdict, file: r.defect_file })),
  total_high: ok.reduce((a, r) => a + (r.high || 0), 0),
  total_medium: ok.reduce((a, r) => a + (r.medium || 0), 0),
  all_top_defects: ok.flatMap((r) => (r.top_defects || []).map((d) => `[${r.axis}] ${d}`)),
}
