export const meta = {
  name: 'okb-acryl-verify',
  description: '아크릴(25노드) Phase 4 — 3축 적대검증(출처·오염 / 무결성 / 가격경로)',
  phases: [{ title: 'Verify', detail: '3축 병렬 → 결함 보드' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-acrylic.md`
const CACHE = `${KB}/01_curation/_cache`

const SCOPE = `
## 검증 범위 = 아크릴 신규 노드(2026-07-04·25 단품 + 공유축)
- 상품 25(146~166 연속 minus 167·168·169·170·226) — CL-1 면적본체9(148/150/151/152/157/158/159/161/162)·CL-2 부속4(146/147/149/154)·CL-3 고정가형4(153/155/160/166)·CL-4 부속선택2(156/163)·CL-5 코롯토TBD 6(164/165/168/169/170/226·전 미출시).
- 공유(Stage A): formula/acrylic-formulas.md·acrylic-components.md(PRF_CLR_ACRYL·COMP_ACRYL_CLEAR3T 277셀·COMP_ACRYL_COROTTO·부속 COMP·고정가형 COMP·PRF_ACRYL_*_TBD·COMP_ACRYL_PENDING_TBD)·gap-acryl-tbd-formula-no-priced-rows(rule/gaps.md)·신규 자재/공정/카테고리(axis/*).
- 빌드 실측(오케 baseline): nodes 1486·edges 4571·hard 0·soft 712·멱등 hash 256b103f. 171 지비츠 del_yn=Y 미생성·167 결번 미생성.

## 권위·규칙(HARD)
- 권위: 상품마스터·인쇄상품 가격표 260702 + ★07-04 신규 라이브 SELECT 캐시 ${CACHE}/acryl-*-260704.csv(H-1·live-snapshot 20260702 가격 금지). 팩=${PACK}(정답·§1.1 가격모델·§2 STALE T-1~T-11·§4 미출시TBD양면·§5 클러스터/공유축).
- **생성자 주장 비신뢰** — 직접 재실측(라이브 SELECT·캐시 awk·t_prd_product_prices/formulas/component_prices/materials/processes). 기계 대조 우선. 라이브 읽기전용·손전사 금지.
`

const AXES = [
  {
    key: 'prov', out: `${KB}/05_verification/defect-acryl-prov-260704.md`,
    task: `**축 1: 출처 실재성 + 권위 정합 + 오염 적발.**
- 출처 실재성: 표본 노드 sources[] 인용 재확인(캐시/라이브 실재).
- **★가격모델 정합(핵심)**: 아크릴 t_prd_product_prices=**0행** 재확인(캐시 acryl-prod-prices=0행) → 어느 상품도 gap-goods-fixed-lookup-no-formula 슬러그 미부착(T-7). M1 면적(148/150/151/152/157/158/161/162·159미출시)=priced_by PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(277셀 실재). M3 고정가형(153/155/160/166)=priced_by 공식·component_prices siz_cd 단가행 실재(153=3·155=3·160=5·166=4셀) 라이브 awk 대조.
- **★H-1/T-1 STALE 오값 적발**: "146=480,000·151=590,000·부속 330/380/300k" 등 대형 숫자가 노드 어디에도 값으로 적재 안 됐는지(라이브 실측 최대 32,700·부속 800/700/500·볼체인 1,000). 본문 STALE 경고문으로만 등장하는지 확인.
- **오염 적발**: ① substrate=아크릴 두께(MAT_000042/043/044/192)만 uses_material·부속(고리/자석/핀/바디/헤어끈/볼체인/볼펜심)이 uses_material로 오배선 안 됐는지(T-8·색상값≠substrate). ② 판형 has_plate_size 미배선 확인(비종이·T-9). ③ **226 드리프트**: 병행 goods 세션 STALE stub(PRF_ACRYL_SHCOROTTO_TBD·인쇄면자재 MAT_000309/311/313 오염)이 §23 재바인딩(PRF_GOODS_FIXED_SIZ·인쇄면 siz화·글리터 무가 CPQ·구자재 del_yn=Y)으로 정정됐는지·구 오염 references 제거됐는지 라이브 실측 대조.
- **미출시 정직**: 159/164/165/168/169/170/226 use_yn=N(캐시 실측)·팬텀 가격 없이 props+본문 정직·추천 제외 명시. 171 del_yn=Y 노드 미생성·167 결번 미생성.`,
  },
  {
    key: 'integrity', out: `${KB}/05_verification/defect-acryl-integrity-260704.md`,
    task: `**축 2: 그래프 무결성 + 연결 완전성 + L-3/L-12/O5 건전성.**
- 재빌드(python3 04_graph/build_graph.py)·**hard=0 재확인**·멱등(재실행 해시 256b103f 동일).
- member_of 0·폐쇄어휘·L-1 파일명↔id(25 신규)·비종이 has_plate_size 0·index 25상품+공유축(acrylic-formulas/components) 등재·**dead-link 0**(신규 relations 타깃 전부 해소).
- **★L-3 사이즈 단일소유 검증**: CL-5가 플래그한 제네릭 사이즈(SIZ_000330 3정의·SIZ_000333 2·SIZ_000011 2)가 Stage C에서 단일 정의로 통합됐는지(각 id 정확히 1 파일 정의·L-20 통과). needs_axis 11건(사이즈10+CAT_000163) 전부 민팅 확인.
- **★L-12 본문 숫자 건전성**: 아크릴 L-12 경고(본문 가격형 숫자)가 ① 정당(use_dims props·차원요약 "277셀·2000~32700"·STALE 경고문 "480,000 인용금지"·addon 단가) vs ② 위반(raw 단가 손전사·transcribed-by 누락)인지 판정. 위반이면 결함(교정 대상).
- **★O5 아크릴 정렬**: 면적/고정가형 상품 priced_by 공식 배선(O5 충족)·TBD 4(165/168/169/170)=references gap-acryl-tbd-formula-no-priced-rows(가격 gap·PRICE_GAP_HINTS tbd·O5 충족)·163 placeholder priced_by+gap 양면(O5 충족)·미출시라도 O5 선언. gap 노드가 "가격 실재 상품의 O5 부정직 회피"에 남용 안 됐는지(면적/고정가형은 priced_by로 충족·gap 미사용).
- 잔여 고아/soft: 아크릴 신규 soft(+72)가 전부 정당(값경계·축승격대기·서술참조)인지·진짜 dead-link 혼입 없는지.`,
  },
  {
    key: 'pricepath', out: `${KB}/05_verification/defect-acryl-pricepath-260704.md`,
    task: `**축 3: 가격 경로 + 정직성 + 라이브 simulate 실증.**
- **면적매트릭스(M1/M2·활성)**: priced_by PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(277셀·off-grid ceiling)·라이브 simulate 실호출로 PRICE≠0 확인(표본 3~5: 148/150/152/161 등). silsa 동형([[product-118]] 참조).
- **고정가형(M3·활성)**: 153/155/160/166 priced_by 공식·component_prices siz_cd 단가행·라이브 simulate PRICE≠0(표본 2~3). ★gap-goods-fixed-lookup 미사용 재확인.
- **부속 별도합산(M2/M2b)**: 146 볼체인 addon·147/149/154 부속(옵션+구성요소 이중표현)·본체가+부속가·always-add silent 가산 가드([[goods-variant-formula-fixed-price-model-260704]] 모델 정합).
- **TBD 정직(견적불가)**: 165/168/169/170 = COMP_ACRYL_PENDING_TBD 0행·라이브 simulate=0/견적불가·references gap-acryl-tbd·badge candidate·"가격 있는 것처럼" 안 넣었는지(표본 2). 163 placeholder 10,000 양면.
- **미출시**: 164(코롯토·단가36행 실재하나 use_yn=N)·미출시 6 전부 팬텀 가격 없이 정직·추천 제외.
- GAP 정직성: 공정 MISSING(153/154/156/166 등 GAP-AC-2)·옵션 items 0행(GAP-AC-4)·plate 비가격(GAP-AC-3)·mat_typ 오타이핑(GAP-AC-1) — 팬텀/과대 없이 양면 표기.`,
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

const COMMON = `§33 Huni-Ontology-KB 아크릴 확장 — **Phase 4 적대적 검증가**(생성≠검증). 구축가 산출을 신뢰하지 않고 반증한다.
${SCOPE}
## 산출
결함 보드를 <defect_file>에 작성. High/Medium/Low. 원천결함(가격 미적재·공정 미적재·옵션 items 미적재·plate 오적재·mat_typ 오타이핑·실무진 TBD·코드 C트랙)은 "격리"(builder 교정 대상 아님·정직 표기 정당하면 결함 아님). 반환은 초소형 schema만.`

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
