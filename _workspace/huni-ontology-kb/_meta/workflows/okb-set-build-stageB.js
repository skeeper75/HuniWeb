export const meta = {
  name: 'okb-set-series-build-stageB',
  description: '셋트 계열 KB 확장 Stage B — 6 클러스터 병렬 빌드(부모+구성원 노드)',
  phases: [{ title: 'Build', detail: '6 클러스터 빌더 병렬(자기 파일만·공유축 반환)' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-set-series.md`
const FOUNDATION = '/Users/innojini/Dev/HuniWeb/_workspace/_foundation'

const COMMON = `
§33 Huni-Ontology-KB 확장 — 셋트 계열 **Stage B 클러스터 빌더**. Stage A가 공유 스캐폴드(셋트 공식·제본 구성요소·면지자재 MAT_000382~385·D링 247~249·제본공정 PROC_000017~024/098·GAP 9)를 이미 mint했다. 너는 **배정된 클러스터의 부모 셋트 + 구성원 반제품 상품(product) 노드만** 자기 파일에 구축한다.

## 입력(정독)
- 큐레이션 팩(정답·전 축): ${PACK} — §1 인벤토리(prd_cd·확정 slug·구성원·가격아키타입·골든값)·§1.1 라이브 급변·§3 축별·§4 양면표기·§5 인계메모.
- 스키마: ${KB}/02_ontology/ontology-schema.md(member_of/has_member/priced_by/has_component·가격아키타입) + file-format-spec.md(frontmatter·출처5필드·badge4종) + graph-build-spec.md(L-1 파일명↔id·I-4 필수엣지·L-18 부모정합).
- 노드 포맷 앵커(기존): ${KB}/03_kb/product/product-016-premium-postcard.md(단품·frontmatter/relations/props/answers_cq/tags 형식).
- Stage A 공유공식 slug: PRF_HC_MUSEON_SET(072/077)·PRF_HC_TWINRING_SET(082)·PRF_LEATHER_RINGBINDER_SET(088)·PRF_BIND_SUM(068)·PRF_BIND_MUSEON(069 base)+PRF_BIND_MUSEON_FOIL(candidate)·PRF_BIND_PUR(070 base)+PRF_BIND_PUR_FOIL(candidate)·PRF_BIND_TWINRING(071 부모)·PRF_PCB_FIXED(094)·PRF_TTEOKME_FIXED(097)·PRF_PHOTOBOOK_FIXED(100)·재사용 PRF_DGP_INNER(내지)/PRF_BOOK_COVER(표지). 캘린더=PRF_DGP_CAL_DESK/WIDE(108/109/111/112)·PRF_DGP_INNER(110).
- 라이브 실측 캐시: ${FOUNDATION}/live-snapshot/latest/ 및 RAILWAY_DB(.env.local·읽기전용 SELECT) — 수치 전사 원천(awk 전사·손전사 금지).

## 공통 규칙(HARD)
- **slug 정본 = product-NNN-kebab**[HARD]. 파일명 = id.md (L-1). 구성원(PRD_TYPE.02)은 product-NNN-<부모>-<역할> 형(팩 §1 구성원 slug 규약).
- **셋트 관계**: 부모 노드 -> has_member(target=구성원 노드)·priced_by(셋트공식)·가격아키타입 prop. 구성원 노드 -> member_of(target=부모)·역할(SEMI_ROLE.01내지/.02표지/.03면지)·priced_by(구성원공식 or 무가격 면지). evaluate_set_price(구성원 evaluate_price 합산+부모공식+할인) 계약을 부모 노드 note로.
- **은퇴 구성원(del_yn=Y)은 노드 미생성**(075/076·085/086/087·091/092/093 — 정상 은퇴·GAP 아님).
- **면지 = 무가격(기여0)·색 내부 택1(용지 드롭다운·멤버 옵션)·자재는 면지멤버 귀속**(팩 §3.5/§3.9·재설계 최신).
- **양면 정직 표기**(팩 §4): 라이브 현재값 + 권위/pending/코드결함을 둘 다 보존. 아래 클러스터별 지시 준수.
- **출처5필드+badge 필수**·수치=결정론 전사(transcribed-by 명기)·손전사 금지·STALE 인용 금지(팩 §2 함정 통과)·라이브값="현재값" 라벨.
- **공유 파일(index.md·axis/materials.md·processes.md·sizes.md·formula/*)은 절대 편집 금지**(Stage C·Stage A 소관). 축 노드는 **참조만**(material-MAT_000XXX 등). 참조하려는 축 노드가 Stage A분·기존에 없으면 **needs_axis로 반환**(직접 mint 금지).
- 클러스터-로컬 노드(구성원 옵션그룹·제약·member 전용 qty)는 **자기 product/ 클러스터 파일**(product-NNN-<slug>-nodes.md)에 쓴다.
- 라이브 읽기전용 SELECT만. 침묵 누락 금지.

## 반환(초소형·대형 반환 금지·HANDOFF 교훈)
JSON schema로 반환: cluster(배정명)·files(작성 파일 경로 배열)·product_ids(작성 product 노드 id 배열)·needs_axis(참조했으나 미민팅인 축 노드: "id|anchor|한줄설명|출처" 문자열 배열)·notes(양면표기/미해결 1~2문장).
`

const SCHEMA = {
  type: 'object',
  additionalProperties: false,
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
    key: '072-077',
    spec: `배정 클러스터 = **072 하드커버책자 + 077 레더 하드커버책자**(COVERBIND 동형).
- 072: 부모 product-072-hardcover-booklet · 구성원 073 표지(.02)·284 내지(.01)·074 면지1멤버(.03·색3택1 MAT_382/383/384). priced_by=PRF_HC_MUSEON_SET. 골든 1/10/100부=34,100/159,100/796,900(transcribed 06_load/leather-hardcover-membrane-072-post-verify.md §2).
- 077: 부모 product-077-leather-hardcover-booklet · 구성원 078 표지(.02)·285 내지(.01)·079 면지1멤버(.03·색3택1). priced_by=PRF_HC_MUSEON_SET(072 동형). 골든 34,100/159,100/796,900(CLAUDE.md §23).
- 은퇴 075/076·080/081 미생성. 면지 무가격·색 택1. 표지=레더/전용지 자재 참조.`,
  },
  {
    key: '082-088',
    spec: `배정 클러스터 = **082 하드커버 링책자 + 088 레더 링바인더**(양면표기 088 필수).
- 082: 부모 product-082-hardcover-ring-booklet · 구성원 083 표지(.02)·286 내지(.01)·084 면지1멤버(.03·색4택1 MAT_382~385 인쇄포함). priced_by=PRF_HC_TWINRING_SET. 골든 30,184/151,844/818,438.
- 088: 부모 product-088-leather-ring-binder · 구성원 089 표지(.02)·090 면지1멤버(.03·색4택1 382~385)·**내지 없음(빈 바인더)**. priced_by=PRF_LEATHER_RINGBINDER_SET(COVERBIND). **★양면(팩§4·gap-set-088-redesign-pending 참조)**: 현재값 34,100/159,100/796,900 + GAP(088-redesign pending·표지9,000·싸바리->100부 1,800,000·승인대기·직교). 088 노드는 현재값을 priced_by 정본으로·gap 노드를 relation(has_gap or note)로 연결.
- 은퇴 085/086/087·091/092/093 미생성. D링자재(USAGE.07) 불가침 note.`,
  },
  {
    key: '068-070',
    spec: `배정 클러스터 = **068 중철책자 + 069 무선책자 + 070 PUR책자**(구성원 mint 완료·2026-06-30·면지없음·소프트커버).
- 068: 부모 product-068-saddle-stitch-booklet · 구성원 288 표지(.02·PRF_BOOK_COVER)·287 내지(.01·PRF_DGP_INNER). priced_by=PRF_BIND_SUM. 골든 100부 158,688(표지88,688+제본70,000·set-price-full-diagnosis §0)·화면 final 127,126(코팅드롭=gap-set-s1s2-double 참조).
- 069: 부모 product-069-perfect-bound-booklet · 구성원 290 표지·289 내지. priced_by=PRF_BIND_MUSEON(base 정본)·**_FOIL=PRF_BIND_MUSEON_FOIL candidate(양면·gap-set-069-070-foil)**. 골든 100부 138,688.
- 070: 부모 product-070-pur-booklet · 구성원 292 표지·291 내지. priced_by=PRF_BIND_PUR(base)·_FOIL candidate. 골든 100부 288,688.
- 면지없음(구성원 미생성·정상). 내지=page파생(부수×⌈page/판걸이수⌉).`,
  },
  {
    key: '094-097',
    spec: `배정 클러스터 = **094 엽서북 + 097 떡메모지**(고정가형·부모 all-in·화면0원 경계).
- 094: 부모 product-094-postcard-book · 구성원 095 내지(.01·페이지20~30/+10)·096 표지(.02). priced_by=PRF_PCB_FIXED(부모 all-in 고정가). 엔진골든 100부 450,000(opt OPV_000491+siz003·set-price-full-diagnosis §3). **★양면(팩§4): 엔진골든=가격사실 vs 화면0원=코드C트랙(gap-set-simulate-sizcd 참조·가격무관)** — notes에 경계 명시.
- 097: 부모 product-097-tteok-memo · 구성원 098 내지(.01·묶음 50/100장). priced_by=PRF_TTEOKME_FIXED. 엔진골든 100부 135,000(bdl_qty=50). 동일 화면0원 경계.
- 094는 부모 all-in이 권위정합(자식 분리 금지·팩 §3.10). 묶음수 옵션(097=50/100).`,
  },
  {
    key: '100',
    spec: `배정 클러스터 = **100 포토북**(고정가형·표지 5종 택1·구성원 7).
- 부모 product-100-photobook · 구성원 101 내지(.01)·102/103/105/106/107 표지5종(.02·택1)·104 면지(.03). priced_by=PRF_PHOTOBOOK_FIXED(부모 all-in·base24+per2p 통합). 엔진골든 100부 1,500,000(opt OPV_000484+siz269·set-price-full-diagnosis §3). **★양면: 엔진골든 vs 화면0원 코드C트랙(gap-set-simulate-sizcd)** notes 명시.
- 표지5종=택1 옵션(has_member 5·표지 역할 SEMI_ROLE.02). 면지104 무가격.`,
  },
  {
    key: 'calendar',
    spec: `배정 클러스터 = **캘린더 108~112**(★셋트 아님·단품 완제품·has_member 금지).
- product-108-desk-calendar(탁상)·109-mini-desk-calendar(미니탁상) -> priced_by=PRF_DGP_CAL_DESK.
- product-111-wall-calendar(벽걸이)·112-wide-wall-calendar(와이드벽걸이) -> priced_by=PRF_DGP_CAL_WIDE.
- product-110-postcard-calendar(엽서캘린더) -> priced_by=PRF_DGP_INNER(재사용).
- 전부 PRD_TYPE.01 단품 완제품·업로드 가격공식 바인딩(2026-07-01). **★디지털인쇄 원자합산형과 동형**(단품 노드·member_of 없음).
- **가격 상태 = 🟡 PRICE≠0 실호출 확인 필요**: 각 캘린더 라이브 simulate(RAILWAY_DB·읽기전용)로 PRICE≠0 확인 시 badge=verified·미확인 시 badge=candidate로. design-calendar 고정가는 gap-design-calendar-fixedprice 참조(미적재·정직).
- 위키 "prd_typ=.04·가격0행"은 STALE(T-6)·인용 금지. 잔존 결함(삼각대/링 자재)은 note로 REVERIFY 표기.`,
  },
]

const results = await parallel(
  CLUSTERS.map((c) => () =>
    agent(`${COMMON}\n\n## ★배정\n${c.spec}`, {
      label: `build:${c.key}`,
      phase: 'Build',
      schema: SCHEMA,
      model: 'opus',
    })
  )
)

const ok = results.filter(Boolean)
log(`Stage B 완료: ${ok.length}/6 클러스터`)
return {
  clusters: ok.map((r) => r.cluster),
  total_files: ok.reduce((a, r) => a + (r.files?.length || 0), 0),
  total_products: ok.reduce((a, r) => a + (r.product_ids?.length || 0), 0),
  all_needs_axis: [...new Set(ok.flatMap((r) => r.needs_axis || []))],
  per_cluster: ok.map((r) => ({ cluster: r.cluster, products: r.product_ids?.length || 0, needs: r.needs_axis?.length || 0, notes: r.notes })),
}
