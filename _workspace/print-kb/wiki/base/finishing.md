# 후가공 (Finishing / Post-press)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
>
> ⚠️ **검증 한계 정직 표기:** 현 base-verification는 인쇄 **방식**(A)과 **임포지션/블리드/결방향/CIP4**(B)만 외부 교차검증했다. 코팅·박·형압 등 개별 후가공 공정의 외부 표준 검증 노트는 아직 없다 → **[추정](도메인 통념)** 또는 **GAP(검증 대기)**로 정직 표기한다. 날조하지 않는다.

---

## 1. 후가공의 위치 (검증된 프레임)

### [BFN-001] 후가공 = 인쇄 후·제본 전후의 가공 단계  {[검증]}
- 내용: 인쇄가 끝난 인쇄지를 완성물로 만드는 단계(재단·접지·코팅·박·제본 등)의 총칭. CIP4 워크플로에서 **PostPress** 단계로 표현된다.
- 출처: CIP4 JDF/XJDF — "PrePress, Press, PostPress, MIS"(`_research/base-verification.md` B-5).
- 연결: [[sizes#BSZ-009]](CIP4) · [[binding]]
- tags: #후가공 #postpress #CIP4

### [BFN-002] 재단(trim)·블리드 — 완성 크기 만들기  {[검증]}
- 내용: 인쇄 후 재단선으로 잘라 완성 크기를 만든다. 재단 오차 대비로 블리드 3mm 표준.
- 출처: pdfpress/grokipedia(`_research/base-verification.md` B-4).
- 연결: [[sizes#BSZ-004]]
- tags: #재단 #블리드

---

## 2. 코팅·박·형압 등 (검증 대기 — 정직 표기)

### [BFN-003] 코팅(라미네이팅) — 표면 보호·질감  {[추정]}
- 내용: 인쇄면에 필름/액상을 입혀 보호·광택/무광 질감을 주는 가공(유광/무광 라미, UV 코팅 등). **외부 표준 교차검증 미완** → [추정].
- 출처: 인쇄 도메인 통념. **base-verification에 코팅 항목 부재.** [GAP-BFN-1]
- 연결: [[#BFN-006]] · [[../huni/...]] 공정 축(코팅=공정/자재 분류는 후니 결정사항)
- tags: #코팅 #라미네이팅 #검증대기

### [BFN-004] 박(箔, foil stamping) — 금속/홀로그램 박 압착  {[추정]}
- 내용: 가열·압력으로 금속/홀로그램 박을 인쇄면에 압착하는 가공. 색상·면적별 등급이 통용된다. **외부 표준 교차검증 미완** → [추정].
- 출처: 인쇄 도메인 통념. **base-verification에 박 항목 부재.** [GAP-BFN-2]
- 연결: [[color#BCL-003]] · [[../huni/...]] 박 등급=앱 계산(후니)
- tags: #박 #foil #검증대기

### [BFN-005] 형압(emboss/deboss)·오시·미싱·귀돌이·도무송·타공  {GAP}
- 내용: 형압(양각/음각)·오시(접는 자국)·미싱(점선 절취)·귀돌이(모서리 라운드)·도무송(칼선 재단)·타공(구멍) 등 다양한 후가공이 통용되나, **개별 정의의 외부 표준 교차검증이 없어 base 사실로 단정하지 않는다.**
- 출처: **GAP — /deep-research 검증 필요.** 후니 특정 공정(proc_cd·완칼/도무송 형상 등)은 huni 공정 축(`_curation/axis-processes.md`).
- 연결: [[../huni/...]] 공정 축 · [[sizes#BSZ-008]](도무송·결방향)
- tags: #형압 #도무송 #타공 #GAP

### [BFN-006] UV 코팅·UV 경화 — 방식과 연계  {[검증(부분)]}
- 내용: UV 경화 잉크/코팅은 자외선으로 즉시 경화한다. UV 평판(flatbed)은 리지드/비흡수 소재 직접인쇄에 쓰인다(코팅 맥락의 UV와 인쇄 맥락의 UV는 구분).
- 출처: 잉크젯 UV flatbed 보편 사실(`_research/base-verification.md` A-9, [검증] 보편). 단 "UV 코팅" 자체의 후가공 표준 명세는 [GAP-BFN-3].
- 연결: [[printing-methods#2-무판--디지털-인쇄]] · [[color#BCL-005]]
- tags: #UV #코팅 #경화

---

## GAP (검증 대기 — 날조 금지)
- [GAP-BFN-1] 코팅(유광/무광/UV) 정의·표준 — base-verification 부재.
- [GAP-BFN-2] 박(색상·면적·등급) 표준 — base-verification 부재.
- [GAP-BFN-3] 형압/오시/미싱/귀돌이/도무송/타공/UV코팅 개별 정의 — 외부 표준 교차 필요.

> 후니 특정 후가공(공정 코드·코팅의 공정/자재 분류·박 등급 계산 등)은 huni 공정 축([[../huni/...]] processes)에 둔다. base는 보편 정의만(검증되면 채움).

## Sources
- CIP4 PostPress(B-5) · pdfpress 재단/블리드(B-4) — `_research/base-verification.md` CONFIRMED. 코팅·박·형압 개별 항목은 미검증(GAP).
