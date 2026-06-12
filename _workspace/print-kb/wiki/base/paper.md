# 종이·자재 (Paper & Materials)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
>
> ⚠️ **검증 한계 정직 표기:** 현 `_research/base-verification.md`는 인쇄 **방식**(A)과 **임포지션/블리드/결방향/CIP4**(B)만 외부 교차검증했다. 종이의 평량·종류·전지 규격 세부는 아직 외부 검증 노트가 없다 → 본 페이지의 그 항목들은 **[추정](도메인 통념)** 또는 **GAP(검증 대기)**로 정직 표기한다. 날조하지 않는다.

---

## 1. 결방향 (검증된 사실)

### [BPP-001] 종이 결방향(grain) — 섬유 정렬  {[검증]}
- 내용: 종이는 제조 시 섬유가 한 방향으로 정렬되는 **결(grain)**이 있다. 결방향은 접지·말림·강도에 영향을 준다(접지선과 나란해야 크랙 방지).
- 출처: Wikipedia Imposition + heckdon — "papers have a 'grain' ... fibers must run lengthwise along the fold"(`_research/base-verification.md` B-3).
- 연결: [[sizes#BSZ-008]] · [[binding]]
- tags: #종이 #결방향 #grain

---

## 2. 평량·전지·종류 (검증 대기 — 정직 표기)

### [BPP-002] 평량(평량/g㎡) — 단위면적당 무게  {[추정]}
- 내용: 종이의 두께·무게를 나타내는 보편 지표로 g/m²(평량)를 쓴다. 값이 클수록 두껍고 빳빳하다(예: 모조지 약 80~120g, 표지용은 더 높음). **세부 수치·종이별 분류는 외부 검증 노트 미작성** → [추정]으로 둔다.
- 출처: 인쇄 도메인 통념. **외부 표준 교차검증 미완 — `_research/base-verification.md`에 종이 평량 항목 부재.** [GAP-BPP-1]
- 연결: [[#BPP-003]]
- tags: #평량 #gsm #검증대기

### [BPP-003] 종이 종류(아트/스노우/모조/특수) — 분류  {GAP}
- 내용: 코팅 여부·표면 처리로 아트지(광택)·스노우지(반광)·모조지(비코팅)·특수지 등으로 분류하는 것이 업계 통념이나, **외부 표준 교차검증이 없어 base 사실로 단정하지 않는다.**
- 출처: **GAP — /deep-research 검증 필요.** 후니 특정 종이×상품 매트릭스는 base가 아니라 huni 레이어(축 materials)에 속한다(`_curation/axis-materials.md` "별도설정 자재 권위").
- 연결: [[../huni/...]] 자재 축 · [[#BPP-002]]
- tags: #종이종류 #GAP #검증대기

### [BPP-004] 전지(원지)·절지 — 대형 인쇄용지  {[검증(부분)]}
- 내용: 인쇄는 완성물보다 큰 **대형 인쇄지(press sheet)**에 N-up으로 인쇄 후 재단한다(전지를 절수로 나눔). "전지에 배치"라는 보편 개념은 검증되나, 한국 전지 규격(국전지/사륙전지 등)의 정확 치수는 관용·검증 대기.
- 출처: Wikipedia Imposition "printer's sheet"(B-1, 보편 개념 [검증]) + 절수 [단일출처/관용](B-3). 전지 규격 치수는 [GAP-BPP-2].
- 연결: [[sizes#BSZ-003]](출력판형) · [[sizes#BSZ-007]](절수)
- tags: #전지 #절지 #presssheet

---

## 3. 비종이 자재 (방식 종속)

### [BPP-005] 비종이 소재 — 인쇄방식이 가능 소재를 종속  {[검증]}
- 내용: 천·금속·유리·아크릴 등 비종이 소재 인쇄 가능 여부는 **인쇄방식에 종속**된다. 공판/실크스크린은 거의 모든 소재, UV 평판은 리지드/비흡수 소재 직접인쇄가 가능하다.
- 출처: Wikipedia Screen printing(소재 다양성) · 잉크젯 UV flatbed(비흡수 리지드)(`_research/base-verification.md` A-7·A-9).
- 연결: [[printing-methods#공판-stencil--실크스크린]] · [[printing-methods#2-무판--디지털-인쇄]]
- tags: #자재 #소재 #방식종속

---

## GAP (검증 대기 — 날조 금지)
- [GAP-BPP-1] 평량 수치·종이별 표준 — base-verification에 항목 없음. /deep-research 필요.
- [GAP-BPP-2] 한국 전지 규격(국전지/사륙전지) 정확 치수 — 관용·검증 대기.
- [GAP-BPP-3] 종이 종류(아트/스노우/모조/특수) 정의 — 외부 표준 교차 필요.

> 후니 특정 종이·자재(코드·종이×상품 매트릭스·MAT_TYPE 등)는 base가 아니라 huni 축 페이지([[../huni/...]] materials)에 둔다(`_curation/axis-materials.md`).

## Sources
- Wikipedia Imposition(결방향·전지 개념) · Wikipedia Screen printing(소재) — `_research/base-verification.md` A-7·B-1·B-3에서 CONFIRMED. 평량·종이종류는 미검증(GAP).
