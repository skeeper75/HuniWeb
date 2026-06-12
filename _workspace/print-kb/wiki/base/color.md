# 색·도수 (Color)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
>
> ⚠️ **검증 한계 정직 표기:** base-verification는 인쇄 방식 맥락의 CMYK/망점·VDP까지 검증했다(A). 별색·화이트 underbase·색관리(ICC)·도수 정의의 독립 외부 검증 노트는 일부 미완 → **[추정]** 또는 **GAP**로 정직 표기한다. 날조하지 않는다.

---

## 1. CMYK·망점 (검증된 사실)

### [BCL-001] CMYK 4색 분해 + 망점(halftone)  {[검증]}
- 내용: 풀컬러 인쇄는 이미지를 시안·마젠타·옐로·블랙(CMYK) 4색으로 분해하고, **망점(halftone dot)** 크기/밀도로 농담을 표현한다. 오프셋의 표준 색 재현 방식.
- 출처: Wikipedia Offset/MPA — "halftone ... overprinting four process inks: cyan, magenta, yellow, and black (CMYK)"(`_research/base-verification.md` A-3).
- 연결: [[printing-methods#평판-planographic--오프셋-인쇄]]
- tags: #CMYK #망점 #halftone

### [BCL-002] 디지털 가변데이터(VDP) — 부수마다 다른 데이터  {[검증]}
- 내용: 디지털 인쇄는 각 페이지를 개별 이미징하므로, 멈추지 않고 부수마다 텍스트/이미지(데이터)를 바꿀 수 있다(VDP).
- 출처: Wikipedia VDP/opentextbc — "elements changed from one printed piece to the next, without stopping, using a database"(`_research/base-verification.md` A-8).
- 연결: [[printing-methods#2-무판--디지털-인쇄]]
- tags: #VDP #가변데이터

---

## 2. 별색·도수·화이트 (검증 대기 — 정직 표기)

### [BCL-003] 별색(spot color) — 특정 잉크 1색  {[추정]}
- 내용: CMYK 망점 합성이 아니라 **특정 조색 잉크 1색**으로 인쇄하는 것(금/은/형광/팬톤 등). CMYK로 못 내는 색·정확한 브랜드 컬러에 쓴다. **별색의 외부 표준(팬톤 등) 독립 검증 노트 미완** → [추정].
- 출처: 인쇄 도메인 통념(CMYK [검증]은 A-3, 별색 자체는 미검증). **base-verification에 별색 항목 부재.** [GAP-BCL-1]
- 연결: [[#BCL-001]] · [[../huni/...]] 별색=공정(후니 모델링, clr_cd=NULL — `_curation/axis-processes.md`)
- tags: #별색 #spotcolor #검증대기

### [BCL-004] 도수(刷數) — 인쇄 색 수  {[추정]}
- 내용: 한 면에 쓰는 잉크 색의 수(예: 4도=CMYK, 1도=흑백 또는 단색). "도수"는 색 수, "별색"은 색 종류로 별개 축이다. **외부 표준 직접 대응 검증 미완** → [추정].
- 출처: 한국 인쇄 관용. **base-verification 부재.** [GAP-BCL-2]
- 연결: [[#BCL-003]] · [[../huni/...]] 별색≠도수(후니: 별색→공정·도수→색 수, `_curation/axis-processes.md`)
- tags: #도수 #관용어 #검증대기

### [BCL-005] 화이트·UV white(underbase) — 불투명 백색 받침  {[검증(부분)]}
- 내용: 비백색/투명 소재에 컬러를 올릴 때, 먼저 **백색 잉크층(underbase)**을 깔아 발색을 확보한다. UV 평판/실사에서 흔하다.
- 출처: 잉크젯 UV flatbed 비흡수 소재 직접인쇄(`_research/base-verification.md` A-9, 보편 [검증]). underbase 자체의 표준 명세는 [GAP-BCL-3].
- 연결: [[printing-methods#2-무판--디지털-인쇄]] · [[finishing#BFN-006]] · [[../huni/...]] silsa 화이트 underbase
- tags: #화이트 #underbase #UVwhite

### [BCL-006] 색관리(ICC/색역) — 장치 간 색 일치  {GAP}
- 내용: 입력/출력 장치 간 색을 일치시키는 색관리(ICC 프로파일·색역 변환)가 통용되나, **외부 표준 교차검증 노트가 없어 base 사실로 단정하지 않는다.**
- 출처: **GAP — /deep-research 검증 필요(ICC/색역).**
- 연결: [[prepress-file]]
- tags: #색관리 #ICC #GAP

---

## GAP (검증 대기 — 날조 금지)
- [GAP-BCL-1] 별색(팬톤 등) 표준 정의 — base-verification 부재.
- [GAP-BCL-2] 도수 정의·영어 대응 — 관용어, 검증 대기.
- [GAP-BCL-3] 화이트 underbase 표준 명세 — 보편 맥락만 검증, 세부 GAP.
- [GAP-BCL-4] 색관리(ICC/색역) — 외부 표준 교차 필요.

> 후니 특정 색 모델(별색=공정·clr_cd·도수 분리 등)은 huni 공정 축([[../huni/...]] processes)에 둔다. base는 보편 정의만(검증되면 채움).

## Sources
- Wikipedia Offset(CMYK/망점, A-3) · Wikipedia VDP(A-8) · 잉크젯 UV(A-9) — `_research/base-verification.md` CONFIRMED. 별색·도수·underbase·색관리 세부는 미검증(GAP).
