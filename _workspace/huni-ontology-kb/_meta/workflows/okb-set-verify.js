export const meta = {
  name: 'okb-set-series-verify',
  description: '셋트 계열 KB 확장 Phase 4 — 3축 적대적 검증(출처·오염 / 무결성 / 가격경로)',
  phases: [{ title: 'Verify', detail: '3축 적대 검증 병렬 → 결함 보드' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-set-series.md`

const SCOPE = `
## 검증 범위 = 셋트 계열 신규 노드(2026-07-03 확장분)
- 상품 42: product-{068,069,070,072,073,074,077,078,079,082,083,084,088,089,090,094,095,096,097,098,100,101,102,103,104,105,106,107,108,109,110,111,112,284,285,286,287,288,289,290,291,292}-*
- 공유(Stage A): formula/set-formulas.md·set-components.md(공식17·구성요소15)·GAP 9(rule/gaps.md)
- 축(Stage C1): axis/{categories,sizes,materials,processes,plate-sizes}.md 신규 58
- 배선(Stage C2): 상품→축 엣지 132·index.md 등재 42

## 권위·규칙(HARD)
- 권위: 상품마스터·인쇄상품 가격표 **260702**(구 260610/260527 STALE). 큐레이션 팩=${PACK}(정답소스·§2 STALE함정·§4 양면표기).
- **생성자 주장 비신뢰** — 직접 재실측(라이브 SELECT·live-snapshot awk·§23 post-verify 실호출·evaluate_set_price). 기계 대조 우선(스크립트).
- 라이브 읽기전용 SELECT만·LLM 숫자 손전사 금지.
`

const AXES = [
  {
    key: 'prov',
    out: `${KB}/05_verification/defect-setseries-prov-260703.md`,
    task: `**축 1: 출처 실재성 + 권위 정합 + 오염 적발.**
- ① 출처 실재성: 각 셋트 노드 sources[]의 인용(파일:절·라이브 쿼리)을 직접 열어 재확인(실존·해당 내용 일치). set-price-full-diagnosis·088-post-verify·leather-hardcover-membrane-*-post-verify·ref-product-sets.csv·set-checklist.csv 실측.
- ② 권위 정합: 골든 수치(072/077/088=34,100/159,100/796,900·082=30,184/151,844/818,438·068=158,688·069=138,688·070=288,688·094=450,000·097=135,000·100=1,500,000·캘린더 108~112 golden)를 §23 산출·라이브 evaluate_set_price/evaluate_price 실호출과 결정론 대조(오차 0).
- ③ 오염 적발(STALE): 팩 §2 함정(T-1 readiness-master 06-26 "BLOCKED"·T-2 set-checklist "mint 예약"·T-3 live-snapshot 면지재설계前 088=구멤버5·T-6 위키 캘린더 .04/0행)을 노드가 인용/전제하지 않았는지 검사. 구권위(260610/260527) 잔재·라이브 오적재값을 정답으로 오기했는지.`,
  },
  {
    key: 'integrity',
    out: `${KB}/05_verification/defect-setseries-integrity-260703.md`,
    task: `**축 2: 그래프 무결성 + 연결 완전성.**
- 그래프 재빌드(python3 04_graph/build_graph.py) 재실행·하드 0 재확인·멱등(2회 해시 동일).
- 잔여 L-19 고아(제본 부가공정 PROC_000001/017/021/056/098·SIZ_000499) 판정: 상품 캐리어 없어 배선 불가면 references 강등 or 정직 GAP로 처리할지 결함으로 상신(고아=조용한 미완 금지).
- 셋트 필수엣지(O5 priced_by≥1 or 양면/gap·L-18 부모정합·has_member 카디널리티): 42 노드 전수. 구성원 노드가 derived_from→부모로 O5 충족했는지(priced_by 위조 아닌지).
- 은퇴 구성원(075/076/085/086/087/091/092/093) 노드 미생성 확인(오생성=결함). 071=셋트 미성립 GAP·캘린더=has_member 없음(셋트 오모델 금지) 확인.
- 스키마 준수: member_of 엣지 잔존 0·폐쇄 관계어휘 19종 밖 엣지 0·L-1 파일명↔id·L-20 마스터앵커 단일소유(신규분).
- index.md dead-link 0·42 노드 전수 등재 확인.`,
  },
  {
    key: 'pricepath',
    out: `${KB}/05_verification/defect-setseries-pricepath-260703.md`,
    task: `**축 3: 가격 경로 연결 완전성(상품→가격).**
- 각 셋트 부모: 상품→priced_by→셋트공식(PRF_*_SET/FIXED)→has_component→구성요소→(단가행 차원) 경로가 그래프에서 끊김 없이 추적되는지. evaluate_set_price(구성원 합산+부모공식) 계약이 노드에 반영됐는지.
- **양면 표기 정직성 재실측**: 088(현재값796,900 라이브 + pending1,800,000 gap·둘 다 보존·badge=verified)·069/070(base정본+_FOIL candidate gap)·094/097/100(엔진골든 verified + 화면0원 코드C트랙 gap-set-simulate-sizcd)·068~070(코팅드롭). 현재값이 라이브 실호출과 일치하는지·pending/권위를 현재값으로 오기 안 했는지.
- 면지=무가격(기여0) 표기 정합(component_prices 0행 실측)·D링 불가침.
- GAP 정직성: 071 셋트미성립·design-calendar 고정가 미적재·내지페이지단가·인쇄면지비 등 "가격 있는 것처럼" 넣지 않았는지.
- 캘린더 5: PRICE≠0 실호출 재확인(108=271,555·109=197,660·110=21,555·111=231,032·112=261,922 100부)·단품(member_of 없음).`,
  },
]

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['axis', 'defect_file', 'high', 'medium', 'low', 'top_defects', 'verdict'],
  properties: {
    axis: { type: 'string' },
    defect_file: { type: 'string' },
    high: { type: 'integer' }, medium: { type: 'integer' }, low: { type: 'integer' },
    top_defects: { type: 'array', items: { type: 'string' }, description: '결함 요약 "노드|유형|증거|교정안" 최대 8건' },
    verdict: { type: 'string', description: 'PASS(결함0 or 원천격리) / DEFECTS(교정 필요) 한 줄' },
  },
}

const COMMON = `§33 Huni-Ontology-KB 확장 — 셋트 계열 **Phase 4 적대적 검증가**(생성≠검증). 구축가 산출을 신뢰하지 않고 반증한다.
${SCOPE}
## 산출
결함 보드를 <defect_file>에 작성(노드·결함유형·증거[재현 쿼리/파일:절]·돈영향/영향·교정안·라우팅). High/Medium/Low 분류. 원천 자체 결함(실무진/승인 대기·코드 C트랙)은 "격리"로 분류(builder 교정 대상 아님).
반환은 초소형 schema(파일 경로+개수+top결함+verdict)만.`

const results = await parallel(
  AXES.map((a) => () =>
    agent(`${COMMON}\n\n## ★배정 축\n결함 보드 파일: ${a.out}\n${a.task}`, {
      label: `verify:${a.key}`, phase: 'Verify', schema: SCHEMA, model: 'opus',
    })
  )
)

const ok = results.filter(Boolean)
log(`Phase 4 검증 완료: ${ok.length}/3 축`)
return {
  axes: ok.map((r) => ({ axis: r.axis, high: r.high, medium: r.medium, low: r.low, verdict: r.verdict, file: r.defect_file })),
  total_high: ok.reduce((a, r) => a + (r.high || 0), 0),
  total_medium: ok.reduce((a, r) => a + (r.medium || 0), 0),
  all_top_defects: ok.flatMap((r) => (r.top_defects || []).map((d) => `[${r.axis}] ${d}`)),
}
