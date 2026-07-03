export const meta = {
  name: 'okb-goods-pouch-env-verify',
  description: '굿즈/파우치/봉투(SB-2/3/4) Phase 4 — 3축 적대검증(출처·오염 / 무결성 / 가격경로)',
  phases: [{ title: 'Verify', detail: '3축 병렬 → 결함 보드' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-stationery-goods.md`

const SCOPE = `
## 검증 범위 = 굿즈/파우치/봉투 신규 노드(2026-07-04·103 단품)
- 봉투/기성 7(001/002/005/283/011/015/218)·거울코스터10(183~192)·패브릭패드14(193~198·205~212)·키링말랑15(199~225 일부)·키캡피켓7(202/203/204/226~229)·레더파우치19(230~238·251~260)·패브릭파우치12(239~250)·백류19(261~279)
- 공유(Stage A/C1): gap-goods-neither·gap-goods-price-unloaded·gap-pouch-empty-shell·gap-goods-sewing-missing·gap-goods-material-contamination·gap-goods-cardenv-addon·gap-goods-fixed-lookup-no-formula + 축 노드(category/size/material)
- ★O5 코드 정렬(2026-07-04): 오케스트레이터가 build_graph.py O5를 spec §151에 정렬(type=gap 노드 out-edge=O5 충족). 이 변경의 건전성도 검증 대상.

## 권위·규칙(HARD)
- 권위: 상품마스터·인쇄상품 가격표 260702. 팩=${PACK}(정답·§2 STALE·§4 GAP·§3.5 오염·§3.6 봉제MISSING).
- **생성자 주장 비신뢰** — 직접 재실측(라이브 SELECT·live-snapshot awk·t_prd_product_prices/formulas/processes/materials). 기계 대조 우선. 라이브 읽기전용·손전사 금지.
`

const AXES = [
  {
    key: 'prov', out: `${KB}/05_verification/defect-goods-prov-260704.md`,
    task: `**축 1: 출처 실재성 + 권위 정합 + 오염 적발.**
- 출처 실재성: 표본 노드 sources[] 인용 재확인.
- 고정가룩업 값 정합: 185=2,500·205=3,000·210=5,000·211=18,000·212=2,500·219=4,500·223=14,000·224=12,000·225=14,500·248=12,500·263=31,000·265=16,500·266=24,000·272=58,000·275=25,000 등을 라이브 t_prd_product_prices awk 실측 대조(unit_price·260610/260702 verbatim).
- 오염 적발: 봉투 001/002/005 = 라이브 PRD_TYPE.03(팩 §1.4 ".01" STALE 회피 확인)·굿즈 비종이 부속(핀버튼 핀·키링고리·거치대)이 uses_material로 오배선 안 됐는지(gap-goods-material-contamination). use_yn=N 미출시(199/202/203/204/207/208/222/226/227/228) 팬텀 가격 없이 정직.
- ★NEITHER-gap/empty-shell = 진짜 가격 원천 부재(t_prd_product_prices AND formulas 둘 다 0행) 실측 재확인(가짜 gap 아닌지).`,
  },
  {
    key: 'integrity', out: `${KB}/05_verification/defect-goods-integrity-260704.md`,
    task: `**축 2: 그래프 무결성 + 연결 완전성 + O5 코드 정렬 건전성.**
- 재빌드(python3 04_graph/build_graph.py)·하드0 재확인·멱등(해시 동일).
- member_of 0·폐쇄 어휘 19종·L-1 파일명↔id(103 신규)·비종이 판형없음(has_plate_size 0)·index 103 등재·dead-link 0.
- ★**O5 코드 정렬 검증**: build_graph.py O5가 "type=gap 노드 out-edge=O5 충족"으로 정렬됨(spec §151). ① 이 변경이 spec §151과 정합인지 ② 남용 위험(가격 실재 상품이 gap으로 O5 회피·부정직)—특히 고정가룩업(가격 실재)이 gap-goods-fixed-lookup-no-formula로 O5 충족한 게 정직한지(가격 실재는 props에 verified 기록·gap은 "공식 아키타입 부재"만 선언) ③ NEITHER-gap이 gap-goods-neither로 O5 충족=정직(진짜 가격 부재).
- 잔여 고아: gap-goods-cardenv-addon(281/282 미빌드)—처리(references 강등/제거/유지 판정). L-20 신규 충돌.`,
  },
  {
    key: 'pricepath', out: `${KB}/05_verification/defect-goods-pricepath-260704.md`,
    task: `**축 3: 가격 경로 + 정직성(gap/fixed-lookup).**
- **고정가룩업**(~20): 가격 실재(t_prd_product_prices unit_price·라이브 simulate 실호출로 PRICE≠0 확인)·공식 없음·gap-goods-fixed-lookup-no-formula 참조로 O5 충족·badge=verified 정합. 값은 props에 정직 기록(엔진 권위).
- **NEITHER-gap**(다수): t_prd_product_prices AND formulas 둘 다 0행(라이브 simulate=0/견적불가)·references gap-goods-neither·badge=candidate·"가격 있는 것처럼" 안 넣었는지.
- **empty-shell 파우치**: 자재/공정 0행(봉제 MISSING·gap-pouch-empty-shell+gap-goods-sewing-missing) 정직.
- 표본 라이브 simulate: 고정가룩업 3~5개 PRICE≠0(값 일치)·NEITHER-gap 2~3개 =0(견적불가·정직) 실증.
- GAP 정직성: 미출시·오염·봉제 미적재·카드봉투 addon — 팬텀 없음.`,
  },
]

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['axis', 'defect_file', 'high', 'medium', 'low', 'top_defects', 'verdict'],
  properties: {
    axis: { type: 'string' }, defect_file: { type: 'string' },
    high: { type: 'integer' }, medium: { type: 'integer' }, low: { type: 'integer' },
    top_defects: { type: 'array', items: { type: 'string' } }, verdict: { type: 'string' },
  },
}

const COMMON = `§33 Huni-Ontology-KB 확장 — 굿즈/파우치/봉투 **Phase 4 적대적 검증가**(생성≠검증). 구축가 산출을 신뢰하지 않고 반증한다.
${SCOPE}
## 산출
결함 보드를 <defect_file>에 작성. High/Medium/Low. 원천결함(가격 미적재·봉제 미적재·실무진/코드 C트랙)은 "격리"(builder 교정 대상 아님). 반환은 초소형 schema만.`

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
