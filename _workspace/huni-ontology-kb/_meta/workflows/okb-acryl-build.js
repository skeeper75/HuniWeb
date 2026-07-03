export const meta = {
  name: 'okb-acryl-build',
  description: '아크릴 굿즈 25노드 KB 확장 — Stage A 공유축 선민팅 → Stage B 5클러스터 팬아웃 → Stage C 잔여축/index/재빌드',
  phases: [
    { title: 'Stage A', detail: '공유축 6그룹 선민팅(자재·공정·카테고리·공식·구성요소·gap·addon)' },
    { title: 'Stage B', detail: '5 클러스터 병렬(면적본체·부속·고정가형·부속선택·TBD미출시)' },
    { title: 'Stage C', detail: '잔여 축민팅·index 등재·그래프 재빌드·무결성' },
  ],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-acrylic.md`
const CACHE = `${KB}/01_curation/_cache`

// ─────────────────────────────────────────────────────────────────────────
// 공통 규칙 (전 스테이지 공유) — 아크릴 아키타입 [HARD]
// ─────────────────────────────────────────────────────────────────────────
const RULES = `
## 아크릴 아키타입 [HARD] — 팩 ${PACK}가 정본(정독)
- **면적매트릭스가 지배 아키타입(silsa 동형)**: 컬러 아크릴 본체 = 공유 \`COMP_ACRYL_CLEAR3T\`(use_dims=[mat_cd,siz_width,siz_height,min_qty]·277단가행·2,000~32,700). silsa 포스터사인 [가로×세로] off-grid ceiling과 동형.
- **★t_prd_product_prices = 0행 — 아크릴은 \`gap-goods-fixed-lookup-no-formula\` 아키타입이 아니다(T-7)**. "고정가형"(M3/M4)도 가격공식 기반(COMP_* use_dims=[siz_cd,min_qty]·component_prices). 절대 gap-goods-fixed-lookup 슬러그 붙이지 말 것.
- **substrate = 아크릴 투명 두께(1.5/3/8mm·MAT_000042/043/044/192) — 색상값 아님(T-8)**. 부속(고리·자석·핀·바디·헤어끈·볼체인·볼펜심)=has_addon/부자재(dflt_yn=N)이지 substrate 아님. uses_material에 부속 배선 금지(오염).
- **비종이 → 판형은 가격축 아님(T-9)**: plate_sizes 51행 실재하나 면적공식 use_dims에 plt_siz_cd 없음. has_plate_size 걸지 말 것·fn_calc_pansu 종이류 로직 이식 금지. (판형 실재는 승계 메모에 "생산메타/오적재 의심·가격영향 없음" 양면 서술)
- **미출시 7(use_yn=N)**: 159·164·165·168·169·170·226 → 노드 생성 + props \`use_yn: N\`·본문 "미출시(정직)"·추천 결과 제외·팬텀 가격 금지.
- **TBD 단가행 0(견적불가) 4**: 165·168·169·170 = PRF_ACRYL_*_TBD + COMP_ACRYL_PENDING_TBD 0행 → \`references gap-acryl-tbd-formula-no-priced-rows\`(공식 바인딩됨·단가 원천 부재)·badge=candidate/gap. 163 미니파츠 = placeholder 단가(10,000·note "단가 미정") → 양면(current_value:10,000 / authority:미정).
- **171 지비츠★ = del_yn=Y → 상품 노드 미생성**. **167 = DB 부재(결번) → 미생성**. (T-10)
- **slug 정본 = product-NNN-kebab [HARD]**·파일명=id.md·전 단품이므로 has_member/member_of 없음.
- **가격 경계**: 온톨로지는 priced_by(공식)·has_component·use_dims 차원 선언까지만. 값 계산=evaluate_price 엔진 권위(KB 밖·값 손전사 금지).
- **출처 5필드 + badge 필수**·수치는 ${CACHE}/acryl-*-260704.csv psql 전사에서만(손전사 금지·STALE 인용 금지·§2 함정 T-1~T-11 통과).
- **★live-snapshot snap_20260702_1119 = 아크릴 가격 정본 금지(H-1·T-2)**. 가격은 07-04 신규 SELECT 캐시에서만. 과업 인용 대형가(480k/590k/330/380/300k)는 라이브 부재=STALE(T-1).
`

// 노드 형식 앵커
const ANCHORS = `
## 노드 형식 앵커 (그대로 계승)
- **면적매트릭스 상품(2파일: main + -nodes 컴패니언)**: ${KB}/03_kb/product/product-118-artprint-poster.md(main frontmatter/relations/props·archetype "면적매트릭스형") + ${KB}/03_kb/product/product-118-artprint-poster-nodes.md(product-local 사이즈·공식·구성요소·옵션·GAP 블록 + 전사표). 아크릴 CL-1/CL-2가 이 패턴.
- **고정가형/단품(단일 파일 goods 스타일)**: ${KB}/03_kb/product/product-185-card-mirror.md(고정가형 단품). 아크릴 CL-3/CL-4/CL-5가 참고(단, 공식 기반이므로 priced_by 공식 배선).
- **스키마**: ${KB}/02_ontology/ontology-schema.md(관계 폐쇄어휘·priced_by·has_component·use_dims·has_addon R14·references·member_of 없음) + file-format-spec.md(★product 프론트매터 badge=defect 불가·양면=candidate/verified+gap 노드 references) + graph-build-spec.md(L-1·L-20·O5 v1.0.5: priced_by≥1 또는 가격류 gap[PRICE_GAP_HINTS: neither/fixed-lookup/price-unloaded/tbd...] references로 충족·비가격 gap 우회 불가).
`

// ─────────────────────────────────────────────────────────────────────────
// Stage A — 공유축 6그룹 선민팅
// ─────────────────────────────────────────────────────────────────────────
const STAGE_A = `§33 Huni-Ontology-KB 아크릴 확장 — **Stage A 공유 스캐폴드 선민팅가**(okb-knowledge-builder).
${RULES}
${ANCHORS}

## 임무 = 팩 §5.2 공유축 6그룹을 **먼저 민팅**(Stage B 25 상품 빌더가 참조만 하도록·동시 mint 충돌 방지). search-before-mint 강제(이미 존재하면 재사용·중복 금지).
1. **SA-1 substrate 자재(두께)** → axis/materials.md 블록: MAT_000042(1.5mm)·MAT_000043(3mm)·MAT_000044(8mm)·MAT_000192(투명)·MAT_000195/196(153 골드/실버). search-before-mint(이미 다른 상품군이 민팅했으면 재사용). {transcribed ${CACHE}/acryl-materials-named-260704.csv}
2. **SA-2 공유 공정** → axis/processes.md 블록: PROC_000002(UV)·PROC_000111(UV평판인쇄)·PROC_000124(레이저커팅)·PROC_000151(굿즈가공)·PROC_000081(부착·mand N)·PROC_000083(가공). search-before-mint. {${CACHE}/acryl-processes-named-260704.csv}
3. **SA-6 카테고리** → axis/categories.md 블록: CAT_000322(단품형)·CAT_000155(조합형)·CAT_000159(코롯토)·CAT_000009(아크릴). search-before-mint(대부분 이미 존재 가능). {카테고리 캐시}
4. **SA-3 면적매트릭스 가격구성요소 + 공유 공식** → formula/acrylic-components.md + formula/acrylic-formulas.md 신규(digital/set/stationery/sticker-formulas.md 패턴 계승). 팩 §1.1 가격모델표의 전 공식/구성요소를 여기 정의:
   - 구성요소: COMP_ACRYL_CLEAR3T(PRICE_TYPE.02·277행·2000~32700·use_dims=[mat_cd,siz_width,siz_height,min_qty]·13상품 공유·단가행 접기 D-22)·COMP_ACRYL_COROTTO([siz_width,siz_height]·36행)·COMP_ACRYL_MAGNET/CLIP/BLACK_HAIR_BAND(부속 단일가 800/700/500)·COMP_ACRYL_NAMETAG_GS/BALLPEN/FREESTAND/CARABINER([siz_cd,min_qty])·COMP_ACRYL_ZIBITZ([opt_cd,min_qty,opt_grp:OPT_000083])·COMP_ACRYL_MINIPART_TBD([siz_cd,min_qty]·placeholder)·COMP_ACRYL_PENDING_TBD([min_qty]·0행). (226=COMP_GOODS_FIXED_SIZ 공유·이미 존재→참조만)
   - 공식: PRF_CLR_ACRYL·PRF_ACRYL_MAGNET/CLIP/HAIRBAND·PRF_ACRYL_NAMETAG_GS/BALLPEN/FREESTAND/CARABINER·PRF_ZIBITZ_ACRYL·PRF_ACRYL_MINIPART·PRF_COROTTO_ACRYL·PRF_ACRYL_PHCOROTTO_TBD/3DCOROTTO_TBD/3DBLOCK_TBD/SHAKER_TBD·(PRF_GOODS_FIXED_SIZ 공유·존재→참조). 각 공식 --has_component--> 위 구성요소. {${CACHE}/acryl-price-chain-260704.csv·acryl-prod-formulas-260704.csv}
5. **SA-4 공유 가격 gap(TBD)** → 기존 gap 노드 위치(gaps.md 또는 기존 gap 파일)에 \`gap-acryl-tbd-formula-no-priced-rows\`(type=gap·PRICE_GAP_HINTS 정합=tbd·O5 충족용) 블록 민팅.
6. **SA-5 볼체인 addon 템플릿** → 표현 방식(addon 노드 또는 146 props)은 기존 goods addon 처리 관례 계승. TMPL-000056~063(8색·각 1,000). {${CACHE}/acryl-addon-templates-260704.csv}

## 산출·반환(초소형 schema)
minted(신규 노드 id 배열)·reused(search-before-mint로 재사용한 기존 id 배열)·files(편집/생성 파일 경로)·notes(공유축 요지 1~2문장). 라이브 읽기전용 SELECT만·침묵 누락 금지.`

const STAGE_A_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['minted', 'reused', 'files', 'notes'],
  properties: {
    minted: { type: 'array', items: { type: 'string' } },
    reused: { type: 'array', items: { type: 'string' } },
    files: { type: 'array', items: { type: 'string' } },
    notes: { type: 'string' },
  },
}

// ─────────────────────────────────────────────────────────────────────────
// Stage B — 5 클러스터 병렬
// ─────────────────────────────────────────────────────────────────────────
const STAGE_B_COMMON = `§33 Huni-Ontology-KB 아크릴 확장 — **Stage B 클러스터 빌더**(okb-knowledge-builder·단품). Stage A가 공유축(자재·공정·카테고리·공식·구성요소·gap-acryl-tbd·addon)을 선민팅했다. 너는 배정 클러스터 상품을 **단품 product 노드**(+면적매트릭스는 -nodes 컴패니언)로 구축한다. 공유축은 **참조만**(재민팅 금지)·미민팅 발견 시 needs_axis 반환.
${RULES}
${ANCHORS}

## 상품별 구축 절차
1. 각 상품 라이브 재실측(${CACHE}/acryl-*-260704.csv + 필요시 RAILWAY_DB 읽기전용 SELECT)로 가격모델(M1~M5/GAP·팩 §1.1) 판정. 추정 금지.
2. main 파일(product-NNN-slug.md): frontmatter(id·type·anchor·badge·sources[5필드]·relations[in_category·has_size·uses_material·has_process·has_qty_rule·priced_by→공유공식·has_component 경유·has_option_group·has_addon]·props[archetype·use_yn·nonspec_yn·min/max/incr]·standards·answers_cq·tags·updated) + 본문(정체 SOT·차원·자재/공정·판형[비종이 양면]·가격경로·옵션제약addon·승계freshness).
3. 면적매트릭스(M1/M2/M5) 상품은 -nodes 컴패니언(product-local 사이즈·옵션그룹·GAP·전사 요약) — product-118 패턴. 고정가형(M3/M4) 단품은 단일 파일로 충분(product-local 사이즈만 필요하면 -nodes).
4. **가격 배선**: M1/M2/M2b/M5 → priced_by 공유 면적/코롯토 공식(COMP_ACRYL_CLEAR3T/COROTTO). M3/M4 → priced_by 고정가형 공식(gap-goods-fixed-lookup 금지·T-7). GAP TBD(165/168/169/170) → references gap-acryl-tbd-formula-no-priced-rows(O5 충족). 163 → placeholder 양면.
5. **부속(M2/M2b)**: has_addon(R14)·본체 면적가 + 부속 별도합산([[goods-variant-formula-fixed-price-model-260704]]). always-add silent 가산 가드 주의. 146=addon템플릿(볼체인)·147/149/154=옵션그룹+공유 부속 구성요소(이중표현 양면).
6. **미출시**(use_yn=N) props·본문 정직 표기. **판형** 실재하면 승계메모 양면(가격영향 없음). **substrate** 두께만 uses_material·부속 제외.

## 반환(초소형 schema)
cluster·files(경로배열)·product_ids(id배열)·needs_axis("id|anchor|설명|출처" 배열·공유축 누락분만)·notes(가격모델 분포·미출시/TBD/양면 1~2문장).`

const STAGE_B_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['cluster', 'files', 'product_ids', 'needs_axis', 'notes'],
  properties: {
    cluster: { type: 'string' }, files: { type: 'array', items: { type: 'string' } },
    product_ids: { type: 'array', items: { type: 'string' } },
    needs_axis: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' },
  },
}

const CLUSTERS = [
  { key: 'cl1-area-body', spec: `**CL-1 컬러아크릴 면적매트릭스 본체** (M1·9노드): 148 아크릴뱃지·150 아크릴스마트톡·151 맥세이프스마트톡·152 아크릴명찰·157 아크릴네임택·158 아크릴포카키링·161 판아크릴·162 아크릴포카스탠드·159 아크릴코스터(미출시). slug=product-148-acrylic-badge·product-150-acrylic-smart-tok·product-151-magsafe-smart-tok·product-152-acrylic-nametag·product-157-acrylic-nametag-photocard·product-158-acrylic-photocard-keyring·product-161-plate-acrylic·product-162-acrylic-photocard-stand·product-159-acrylic-coaster. 전부 priced_by 공유 PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T(면적매트릭스). 157/158/161/162 사이즈 옵션그룹·판형 51행 중 다수 양면·159 use_yn=N 미출시. -nodes 컴패니언(product-118 패턴).` },
  { key: 'cl2-area-accessory', spec: `**CL-2 면적+부속선택/addon** (M2·M2b·4노드): 146 아크릴키링(볼체인 8색 addon)·147 아크릴마그넷(자석 부속)·149 아크릴집게(투명집게 부속)·154 아크릴머리끈(블랙헤어끈 부속). slug=product-146-acrylic-keyring·product-147-acrylic-magnet·product-149-acrylic-clip·product-154-acrylic-hairband. 본체 priced_by PRF_CLR_ACRYL/PRF_ACRYL_{MAGNET,CLIP,HAIRBAND}→COMP_ACRYL_CLEAR3T + 부속(147/149/154=옵션그룹+COMP_ACRYL_{MAGNET,CLIP,BLACK_HAIR_BAND}·146=볼체인 addon템플릿). has_addon(R14)·부속 별도합산·always-add 가드·이중표현 양면. 부속은 uses_material 아님(T-8). -nodes 컴패니언.` },
  { key: 'cl3-fixed-formula', spec: `**CL-3 고정가형 by-siz 공식** (M3·4노드): 153 아크릴명찰(골드실버)·155 아크릴볼펜·160 아크릴자유형스탠드·166 아크릴카라비너. slug=product-153-acrylic-nametag-goldsilver·product-155-acrylic-ballpen·product-160-acrylic-free-standing·product-166-acrylic-carabiner. priced_by 고정가형 공식(PRF_ACRYL_{NAMETAG_GS,BALLPEN,FREESTAND,CARABINER}→COMP_ACRYL_*·[siz_cd,min_qty]·단가행 3~5개). ★gap-goods-fixed-lookup 금지(T-7). 153=MAT_000195/196 골드실버 substrate·153/166 공정 MISSING(정직). 볼펜심 부속=uses_material 아님.` },
  { key: 'cl4-accessory-select', spec: `**CL-4 부속선택 공식(지비츠/미니파츠)** (M4·2노드): 156 아크릴지비츠·163 아크릴미니파츠. slug=product-156-acrylic-zibitz·product-163-acrylic-minipart. 156=priced_by PRF_ZIBITZ_ACRYL→COMP_ACRYL_ZIBITZ([opt_cd,min_qty,opt_grp:OPT_000083]·2단가 200~600). 163=priced_by PRF_ACRYL_MINIPART→COMP_ACRYL_MINIPART_TBD([siz_cd,min_qty]·단가행 1개 placeholder 10,000)→★양면(current_value:10,000(placeholder) / authority:미정·실무진)·badge=gap. 156 공정 MISSING(정직).` },
  { key: 'cl5-corotto-tbd', spec: `**CL-5 코롯토/쉐이커 TBD류(전 미출시)** (M5·GAP·6노드): 164 아크릴코롯토·165 포카코롯토·168 아크릴입체코롯토·169 아크릴입체블럭·170 아크릴쉐이커★·226 아크릴쉐이커코롯토. slug=product-164-acrylic-corotto·product-165-photocard-corotto·product-168-acrylic-3d-corotto·product-169-acrylic-3d-block·product-170-acrylic-shaker·product-226-acrylic-shaker-corotto. ★전부 use_yn=N 미출시(정직·팬텀 금지). 164=priced_by PRF_COROTTO_ACRYL→COMP_ACRYL_COROTTO(면적 36행 실재·견적가능하나 미출시). 165/168/169/170=PRF_ACRYL_*_TBD→references gap-acryl-tbd-formula-no-priced-rows(단가행 0·견적불가). 226=§23 재바인딩(PRF_GOODS_FIXED_SIZ 공유 77행·인쇄면 siz화+글리터 무가 CPQ OPT_000203/204·미출시). 168/169/170 수량규칙 NULL(미설정).` },
]

// ─────────────────────────────────────────────────────────────────────────
// 실행
// ─────────────────────────────────────────────────────────────────────────
phase('Stage A')
log('Stage A: 공유축 6그룹 선민팅')
const a = await agent(STAGE_A, { label: 'stageA:shared-axes', phase: 'Stage A', schema: STAGE_A_SCHEMA, model: 'opus' })
log(`Stage A 완료: minted ${a?.minted?.length || 0}·reused ${a?.reused?.length || 0}`)

phase('Stage B')
log('Stage B: 5 클러스터 병렬 빌드')
const bResults = await parallel(
  CLUSTERS.map((c) => () =>
    agent(`${STAGE_B_COMMON}\n\n## ★배정 클러스터\n${c.spec}`, {
      label: `build:${c.key}`, phase: 'Stage B', schema: STAGE_B_SCHEMA, model: 'opus',
    })
  )
)
const bOk = bResults.filter(Boolean)
const allNeedsAxis = [...new Set(bOk.flatMap((r) => r.needs_axis || []))]
log(`Stage B 완료: ${bOk.length}/5 클러스터·상품 ${bOk.reduce((s, r) => s + (r.product_ids?.length || 0), 0)}·needs_axis ${allNeedsAxis.length}`)

phase('Stage C')
const STAGE_C = `§33 Huni-Ontology-KB 아크릴 확장 — **Stage C 축민팅·배선·index·재빌드가**(okb-knowledge-builder). Stage A(공유축)·Stage B(25 상품)가 끝났다. 너는 마무리한다.
${RULES}
${ANCHORS}

## 임무
1. **잔여 needs_axis 민팅**: Stage B가 반환한 미민팅 축을 민팅(공유 위치·search-before-mint). 목록:
${allNeedsAxis.length ? allNeedsAxis.map((n) => `   - ${n}`).join('\n') : '   - (없음 — Stage A/B에서 전부 처리됨. 그래도 dead-link 스캔으로 재확인)'}
2. **index.md 등재**: 03_kb/index.md에 신규 노드(상품 25 + 공유 공식/구성요소/gap + 신규 자재/공정/카테고리) 전부 등재. 누락 0.
3. **dead-link 0 확인**: 전 신규 상품의 relations 타깃([[...]])이 실재 노드로 해소되는지 스캔. 미해소=민팅 or 오타 교정.
4. **그래프 재빌드**: python3 04_graph/build_graph.py 실행. **hard=0 필수**·노드 증가분 = 상품25 + 공유축·멱등(재실행 해시 동일) 확인. build-report 경로 기록.
5. **O5 확인**: 면적/고정가형 상품 = priced_by 공식 배선(O5 충족). TBD 4 = references gap-acryl-tbd(O5 충족). 미출시라도 O5는 충족돼야(가격경로 선언).

## 반환(초소형 schema)
minted_extra·index_added(신규 등재 노드 수)·dead_links(잔여 미해소 수)·hard(빌드 하드위반)·nodes_total·edges_total·hash_nodes·report_path·notes(1~2문장). 라이브 읽기전용 SELECT만.`

const STAGE_C_SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['minted_extra', 'index_added', 'dead_links', 'hard', 'nodes_total', 'edges_total', 'hash_nodes', 'report_path', 'notes'],
  properties: {
    minted_extra: { type: 'array', items: { type: 'string' } },
    index_added: { type: 'integer' }, dead_links: { type: 'integer' }, hard: { type: 'integer' },
    nodes_total: { type: 'integer' }, edges_total: { type: 'integer' },
    hash_nodes: { type: 'string' }, report_path: { type: 'string' }, notes: { type: 'string' },
  },
}
const c = await agent(STAGE_C, { label: 'stageC:mint-index-rebuild', phase: 'Stage C', schema: STAGE_C_SCHEMA, model: 'opus' })
log(`Stage C 완료: hard=${c?.hard}·dead_links=${c?.dead_links}·nodes=${c?.nodes_total}·hash=${c?.hash_nodes}`)

return {
  stageA: { minted: a?.minted?.length || 0, reused: a?.reused?.length || 0, files: a?.files },
  stageB: bOk.map((r) => ({ cluster: r.cluster, products: r.product_ids?.length || 0, needs: r.needs_axis?.length || 0, notes: r.notes })),
  needs_axis: allNeedsAxis,
  stageC: c,
  verdict: (c?.hard === 0 && c?.dead_links === 0) ? 'BUILD_OK' : 'BUILD_ISSUE',
}
