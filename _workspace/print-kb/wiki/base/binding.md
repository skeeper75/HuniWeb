# 제본 (Binding)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
>
> ⚠️ **검증 한계 정직 표기:** 현 base-verification는 임포지션·시그니처·결방향까지만 외부 교차검증했다(B). 개별 제본 방식(중철/무선/PUR/트윈링/하드커버 등)의 외부 표준 검증 노트는 아직 없다 → **[추정]** 또는 **GAP**로 정직 표기한다. 날조하지 않는다.

---

## 1. 제본의 기반 (검증된 사실)

### [BBD-001] 시그니처(signature) = 제본 단위  {[검증]}
- 내용: 접힌 인쇄지가 이루는 제본 단위. 책은 여러 시그니처가 모여 구성된다. 임포지션이 시그니처 단위로 페이지를 배치한다.
- 출처: Wikipedia/pdfpress — "sheets are placed to form the signatures that compose the finished book"(`_research/base-verification.md` B-2).
- 연결: [[sizes#BSZ-006]] · [[sizes#BSZ-005]](임포지션)
- tags: #시그니처 #제본단위

### [BBD-002] 결방향이 제본 품질에 영향  {[검증]}
- 내용: 종이 결이 접지선과 나란해야 접지/제본 시 크랙을 방지한다. 제본 방향 결정에 결방향이 관여한다.
- 출처: Wikipedia Imposition + heckdon(`_research/base-verification.md` B-3).
- 연결: [[paper#BPP-001]] · [[sizes#BSZ-008]]
- tags: #결방향 #제본

---

## 2. 제본 방식 (검증 대기 — 정직 표기)

### [BBD-003] 중철(saddle-stitch) — 가운데 철심  {[추정]}
- 내용: 페이지를 반으로 접어 가운데를 철심(스테이플)으로 고정하는 방식. 얇은 책자(소책자·팸플릿)에 통용. **외부 표준 교차검증 미완** → [추정].
- 출처: 인쇄 도메인 통념. **base-verification에 제본방식 항목 부재.** [GAP-BBD-1]
- 연결: [[#BBD-001]] · [[../huni/...]] booklet 시트
- tags: #중철 #saddlestitch #검증대기

### [BBD-004] 무선(perfect)·PUR — 등 접착  {[추정]}
- 내용: 책등을 접착제로 붙이는 방식(무선철). PUR는 폴리우레탄 접착으로 강도가 높은 변형으로 통용. **외부 표준 교차검증 미완** → [추정].
- 출처: 인쇄 도메인 통념. **base-verification 부재.** [GAP-BBD-2]
- 연결: [[#BBD-001]] · [[../huni/...]] photobook/booklet
- tags: #무선 #PUR #perfectbinding #검증대기

### [BBD-005] 트윈링/스프링·하드커버·떡제본·레이플랫  {GAP}
- 내용: 트윈링(이중 링)·스프링·하드커버(양장)·떡제본·레이플랫(펼침 평탄) 등 다양한 제본이 통용되나, **개별 정의의 외부 표준 교차검증이 없어 base 사실로 단정하지 않는다.**
- 출처: **GAP — /deep-research 검증 필요.** 후니 특정 제본(엑셀 제본대로·미싱제본 신규 등)은 huni 공정/family 축.
- 연결: [[../huni/...]] booklet/photobook 시트 · [[finishing]]
- tags: #트윈링 #하드커버 #떡제본 #GAP

---

## GAP (검증 대기 — 날조 금지)
- [GAP-BBD-1] 중철 정의·적용범위 — base-verification 부재.
- [GAP-BBD-2] 무선/PUR 정의·차이 — base-verification 부재.
- [GAP-BBD-3] 트윈링/하드커버/떡/레이플랫/미싱제본 — 외부 표준 교차 필요.

> 후니 특정 제본(공정 코드·제본 family 관점·미싱제본 신설 등)은 huni 축([[../huni/...]] processes / family 레시피)에 둔다. base는 보편 정의만(검증되면 채움).

## Sources
- Wikipedia/pdfpress 시그니처·결방향 — `_research/base-verification.md` B-2·B-3 CONFIRMED. 개별 제본방식은 미검증(GAP).
