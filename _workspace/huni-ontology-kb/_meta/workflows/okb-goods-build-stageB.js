export const meta = {
  name: 'okb-goods-pouch-env-build-stageB',
  description: '굿즈/파우치/봉투(SB-2/3/4) KB 확장 Stage B — 8 family 클러스터 병렬 빌드(단품 102)',
  phases: [{ title: 'Build', detail: '8 family 클러스터 병렬(단품·정직 GAP·공유축 반환)' }],
}

const KB = '/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb'
const PACK = `${KB}/01_curation/pack-stationery-goods.md`
const FOUNDATION = '/Users/innojini/Dev/HuniWeb/_workspace/_foundation'

const COMMON = `
§33 Huni-Ontology-KB 확장 — 굿즈/파우치/봉투 **Stage B 클러스터 빌더**(단품). Stage A가 공유 GAP 노드(gap-goods-neither·gap-goods-price-unloaded·gap-pouch-empty-shell·gap-goods-sewing-missing·gap-goods-material-contamination·gap-goods-cardenv-addon)를 mint했다. 이 상품군은 **대부분 단품·empty-shell/NEITHER-gap(가격 원천 부재)**이라 **정직 GAP 표기가 주 산출**이다. 너는 배정 family의 상품을 **단품 product 노드**로 구축한다(★셋트 아님·has_member 없음).

## 입력(정독)
- 큐레이션 팩: ${PACK} — §1.2 굿즈·§1.3 파우치·§1.4 봉투·§3(축별·오염·empty-shell·봉제MISSING)·§4 GAP표.
- 노드 형식 앵커(단품): ${KB}/03_kb/product/product-016-premium-postcard.md(단품 frontmatter/relations/props). 굿즈 고정가 참조: ${KB}/03_kb/product/product-024-photocard.md(고정가형 단품).
- 스키마: ${KB}/02_ontology/ontology-schema.md(priced_by·has_size·uses_material·has_process·has_qty_rule·references·가격아키타입·member_of 없음) + file-format-spec.md(★product 프론트매터 badge=defect 불가·양면=candidate/verified+gap) + graph-build-spec.md(L-1·O5 priced_by≥1 or gap/양면 선언).
- 라이브: ${FOUNDATION}/live-snapshot/latest/ + RAILWAY_DB(.env.local·읽기전용 SELECT)·수치 awk 전사·손전사 금지.

## 공통 규칙(HARD)
- **slug 정본 = product-NNN-kebab**[HARD·자기 prd_cd]. 파일명=id.md(L-1). 단품이므로 has_member/member_of 없음.
- **가격 3분기(라이브 실측으로 상품별 판정)**:
  ① **고정가룩업**(t_prd_product_prices 단일 unit_price 존재·예 185=2,500·205=3,000·210=5,000): priced_by 대신 props "고정가룩업(t_prd_product_prices·N원·transcribed)" + badge=verified. 온톨로지는 "가격 존재" 사실까지(값=엔진 권위). 라이브 SELECT로 unit_price 확인.
  ② **NEITHER-gap**(공식·고정가 둘 다 없음·001/002/005 봉투 등): priced_by 없음 → O5를 **references [[gap-goods-neither]]**(가격 원천 부재)로 충족·badge=candidate.
  ③ **empty-shell**(파우치 다수·자재/공정 0행): references [[gap-pouch-empty-shell]]+[[gap-goods-sewing-missing]]·badge=candidate.
  ★어느 분기인지 각 상품 라이브 t_prd_product_prices/materials/processes awk로 판정(추정 금지).
- **use_yn=N 미출시**(199/202/203/204/207/208/222/226/227/228): props "use_yn=N·미출시"·badge=candidate·정직 표기(팬텀 가격 금지).
- **비종이 → 판형 없음**(굿즈 금속/원단/아크릴·파우치 봉제·봉투 OPP)[도메인 HARD]. has_plate_size 금지.
- **자재 오염 주의**(팩 §3.5): 비종이 부속(거치대/키링고리/볼펜/면끈/핀버튼)은 substrate 자재 아님 → uses_material 배선 제외·[[gap-goods-material-contamination]] note. 실 원단/금속 자재만 uses_material.
- **봉투 001/002/005/283 = 라이브 prd_typ_cd=PRD_TYPE.03(기성)**(팩 .01 표기는 stale·라이브 실측). 011/015/218도 기성.03. 기성=제조없음·가격없음/NEITHER-gap.
- **출처5필드+badge 필수**·수치 transcribed(손전사 금지)·STALE 인용 금지·라이브값="현재값".
- **공유 파일(index.md·axis/*·formula/*·gaps.md) 편집 금지**(Stage C·A 소관). 축 노드 참조만·미민팅은 needs_axis 반환. 라이브 읽기전용 SELECT만·침묵 누락 금지.

## 반환(초소형·schema)
cluster·files(경로배열)·product_ids(id배열)·needs_axis("id|anchor|설명|출처" 배열)·notes(고정가/gap/use_yn 분포·양면 1~2문장).
`

const SCHEMA = {
  type: 'object', additionalProperties: false,
  required: ['cluster', 'files', 'product_ids', 'needs_axis', 'notes'],
  properties: {
    cluster: { type: 'string' }, files: { type: 'array', items: { type: 'string' } },
    product_ids: { type: 'array', items: { type: 'string' } },
    needs_axis: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' },
  },
}

const CLUSTERS = [
  { key: 'envelope-giseong', spec: `배정 = **봉투류 + 기성 기타** (7): 001 OPP접착봉투·002 OPP비접착봉투·005 캘린더봉투·283 트레싱지봉투(전부 기성.03·NEITHER-gap or 가격없음)·011 자석고정용고무판(기성.03)·015 만년스탬프 리필잉크(기성.03·addon성)·218 타이벡북커버(기성.03). slug=product-001-opp-adhesive-envelope·product-002-opp-non-adhesive-envelope·product-005-calendar-envelope·product-283-tracing-paper-envelope·product-011-magnet-rubber-plate·product-015-refill-ink·product-218-tyvek-book-cover. ★050 봉투제작은 이미 구축(참조만·미터치). 전부 기성.03·가격없음/NEITHER-gap 정직.` },
  { key: 'mirror-coaster', spec: `배정 = **거울류 + 코스터류** (10): 183 틴거울·184 컴팩트거울·185 카드거울(★고정 2,500)·186 사각손거울·187 블랙사각손거울·188 레더코스터·189 코르크코스터·190 우드코스터·191 린넨패브릭코스터·192 규조토코스터. slug=product-183-tin-mirror … product-192-diatomite-coaster. 185만 고정가룩업(라이브 확인)·나머지 gap 다수. 비종이(금속/유리/레더/코르크/우드/린넨/규조토)·판형없음.` },
  { key: 'fabric-pad', spec: `배정 = **패브릭·의류·패드** (14): 193 머그컵·194 워터북보틀·195 벨벳쿠션·196 레더여권케이스·197 미니매트·198 피크닉매트·205 양말(★3,000)·206 반팔티셔츠·207 극세사타월(use_yn=N)·208 슬로건(use_yn=N)·209 후드티셔츠·210 초슬림마우스패드(★5,000)·211 장패드(★18,000)·212 극세사클리너(★2,500). slug=product-NNN-kebab. 205/210/211/212 고정가룩업(라이브 확인)·나머지 gap·207/208 use_yn=N 미출시. 비종이·판형없음.` },
  { key: 'keyring-mallang', spec: `배정 = **키링·톡·말랑·기타** (15): 199 투명부채(use_yn=N)·200 핀버튼·201 레더스트랩키링·213 틴케이스·214 자석북마크·215 클립보드·216 투명클립보드·217 만년스탬프·219 밴드톡(★4,500)·220 폰스트랩·221 말랑키링·222 말랑증사홀더(use_yn=N)·223 말랑포카홀더(★14,000)·224 말랑네임택(★12,000)·225 말랑여권케이스(★14,500). slug=product-NNN-kebab. 219/223/224/225 고정가룩업·나머지 gap·199/222 use_yn=N. ★핀버튼200 부속(핀)·키링고리=오염 주의(uses_material 제외·gap-goods-material-contamination). 비종이·판형없음.` },
  { key: 'keycap-picket', spec: `배정 = **키캡·앨범·피켓·미러** (7·미출시 다수): 202 키캡키링(use_yn=N)·203 LED투명키캡키링(use_yn=N)·204 미니CD앨범(use_yn=N)·226 아크릴쉐이커코롯토(use_yn=N)·227 미니우치와키링(use_yn=N)·228 하트 이미지피켓(use_yn=N)·229 이미지피켓(use_yn=Y). slug=product-NNN-kebab. 226~229 gap·202/203/204/226/227/228 use_yn=N 미출시 정직(팬텀가 금지). 229만 활성. 비종이·판형없음.` },
  { key: 'pouch-leather', spec: `배정 = **레더 파우치·미니·필통** (19): 230 레더플랫파우치·231 레더슬림파우치·232 레더삼각파우치·233 레더볼륨파우치·234 레더스트링파우치·235 레더스트링원형파우치·236 레더플랫클러치·237 레더삼각클러치·238 레더아이패드노트북파우치·251 레더플랫미니파우치·252 레더슬림미니파우치·253 레더삼각미니파우치·254 레더볼륨미니파우치·255 레더원형미니파우치·256 레더플랫필통·257 레더슬림필통·258 레더삼각필통·259 레더볼륨필통·260 레더원형필통. slug=product-NNN-kebab. ★봉제·empty-shell 다수(자재/공정 0행·gap-pouch-empty-shell+gap-goods-sewing-missing)·일부 고정가(251/253/256~260 등 라이브 확인). 비종이(레더)·판형없음.` },
  { key: 'pouch-fabric', spec: `배정 = **캔버스·린넨·메쉬·타이벡 파우치** (12): 239 캔버스플랫파우치·240 캔버스삼각파우치·241 캔버스스트랩라벨파우치·242 광목스트링라벨파우치(★순수 empty-shell·자재/공정 0행)·243 린넨스트링파우치·244 타이벡플랫파우치·245 타이벡슬림파우치·246 타이벡삼각파우치·247 타이벡스트링파우치·248 타이벡플랫클러치(★12,500)·249 메쉬슬림파우치·250 메쉬볼륨파우치. slug=product-NNN-kebab. 248 고정가·나머지 empty-shell/gap 다수. 봉제·비종이·판형없음.` },
  { key: 'bags', spec: `배정 = **백류·필통(캔버스)** (18): 261 캔버스플랫필통·262 캔버스삼각필통·263 레더토트백(★31,000)·264 레더숄더백·265 린넨미니에코백(★16,500)·266 린넨토트백(★24,000)·267 린넨에코백·268 캔버스심플백·269 캔버스포켓심플백·270 캔버스에코백·271 캔버스숄더백·272 캔버스포켓숄더백(★58,000)·273 타이벡양면백팩·274 타이벡보냉보틀백·275 타이벡보냉미니백(★25,000)·276 타이벡에코백·277 타이벡보냉에코백·278 메쉬토트백·279 메쉬에코백. slug=product-NNN-kebab. 263/265/266/272/275 고정가·나머지 gap/empty-shell. 봉제·비종이·판형없음.` },
]

const results = await parallel(
  CLUSTERS.map((c) => () =>
    agent(`${COMMON}\n\n## ★배정\n${c.spec}`, {
      label: `build:${c.key}`, phase: 'Build', schema: SCHEMA, model: 'opus',
    })
  )
)
const ok = results.filter(Boolean)
log(`Stage B 완료: ${ok.length}/8 클러스터`)
return {
  clusters: ok.map((r) => r.cluster),
  total_files: ok.reduce((a, r) => a + (r.files?.length || 0), 0),
  total_products: ok.reduce((a, r) => a + (r.product_ids?.length || 0), 0),
  all_needs_axis: [...new Set(ok.flatMap((r) => r.needs_axis || []))],
  per_cluster: ok.map((r) => ({ cluster: r.cluster, products: r.product_ids?.length || 0, needs: r.needs_axis?.length || 0, notes: r.notes })),
}
