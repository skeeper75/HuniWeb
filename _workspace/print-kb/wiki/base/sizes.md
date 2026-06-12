# 사이즈·규격 체계 (Sizes & Dimensions)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
> 핵심: 인쇄는 **3축의 크기 개념**(재단/작업/출력판형)을 구분한다 — 같은 "사이즈"라도 의미가 다르다.

---

## 1. 크기 3축 구분 (HARD — 매핑 오류의 단골)

인쇄물의 "크기"는 한 값이 아니라 단계별 3개 축이다. 혼동하면 차원 매핑이 깨진다.

### [BSZ-001] 재단 사이즈 (trim size) — 완성물 크기  {[검증]}
- 내용: 최종 재단선으로 잘린 **완성품의 크기**. 고객이 인지하는 "이 상품의 크기".
- 출처: pdfpress/grokipedia 인쇄 용어집 — trim = 재단된 최종 치수(`_research/base-verification.md` B-4).
- 연결: [[#BSZ-003]](블리드) · [[finishing#BFN-002]]
- tags: #사이즈 #재단 #trim

### [BSZ-002] 작업 사이즈 (work size / artwork) — 디자인 영역  {[검증]}
- 내용: 디자인 데이터가 차지하는 영역. 보통 **재단 + 블리드(여백)**. 재단보다 약간 크다.
- 출처: pdfpress imposition/bleed 가이드(B-4) — bleed가 재단선 밖으로 연장됨.
- 연결: [[#BSZ-003]] · [[prepress-file#BPF-003]]
- tags: #사이즈 #작업 #artwork

### [BSZ-003] 출력판형 (press sheet / output paper) — 대형 인쇄지  {[검증]}
- 내용: 실제로 인쇄기에 걸리는 **대형 인쇄지(전지/절지)**. 여러 면(N-up)이 임포지션으로 배치되고, 인쇄 후 접지·재단해 완성물이 된다. 재단/작업 사이즈와 별개의 큰 단위.
- 출처: Wikipedia Imposition — "arrangement of pages on the printer's sheet"(B-1). EPA/PNC3 매엽 인쇄.
- 연결: [[#BSZ-005]](임포지션) · [[paper#BPP-004]]
- tags: #사이즈 #출력판형 #presssheet

> **3축 요약:** 재단(완성) ⊂ 작업(재단+블리드) ⊂ 출력판형(전지에 N-up 배치). 가격·차원 모델은 어느 축의 값인지 명시해야 한다.

---

## 2. 블리드·재단마크

### [BSZ-004] 블리드(bleed)·재단마크 — 표준 3mm  {[검증]}
- 내용: 디자인을 재단선 너머로 연장한 여백(bleed). 재단 오차에도 흰 테두리가 안 나오게 한다. **표준 0.125인치 = 3mm**. 크롭/재단 마크(crop/trim marks)로 재단 위치 표시.
- 출처: pdfpress/grokipedia — "Bleed extends beyond the trim edge, standard 0.125 inch (3 mm); crop/trim marks"(`_research/base-verification.md` B-4).
- 연결: [[prepress-file#BPF-003]] · [[#BSZ-002]]
- tags: #블리드 #재단마크 #3mm

---

## 3. 임포지션·시그니처 (출력판형 ↔ 완성물 변환)

### [BSZ-005] 임포지션(imposition) — 페이지를 인쇄지에 배치  {[검증]}
- 내용: 완성물의 페이지들을 대형 인쇄지(press sheet)에 **순서·방향을 맞춰 배치**하는 것. 접지·재단·제본 후 페이지가 정순(올바른 순서)이 되도록 한다. 목적 = 인쇄 효율·제본 단순화·용지 낭비 감소.
- 출처: Wikipedia Imposition — "arrangement of the printed product's pages on the printer's sheet ... faster printing, simplify binding and reduce paper waste"(`_research/base-verification.md` B-1).
- 연결: [[#BSZ-006]](시그니처) · [[prepress-file#BPF-002]] · [[../huni/...]] 판수=앱 계산
- tags: #임포지션 #imposition

### [BSZ-006] 시그니처(signature) — 접힌 인쇄지 제본 단위  {[검증]}
- 내용: 접힌 인쇄지가 이루는 **제본 단위**. 책은 여러 시그니처가 모여 구성된다.
- 출처: Wikipedia/pdfpress — "sheets are placed to form the signatures that compose the finished book"(B-2).
- 연결: [[binding#BBD-001]] · [[#BSZ-005]]
- tags: #시그니처 #signature #제본

### [BSZ-007] 절수(切數) — 전지를 몇 등분  {[단일출처/관용]}
- 내용: 한국 인쇄 관용어로, **전지(원지)를 몇 등분 했는가**(예: 국4절 = 국전지를 4등분). 영어 1차 명세의 직접 대응 용어는 없고, 보편 개념인 N-up/cut count에 대응한다.
- 출처: `_research/base-verification.md` B-3(한국 관용어, 영어 표준 직접 대응 없음 — [단일출처/관용] 표기 권고). 보편 N-up 개념은 임포지션(B-1)에서 검증됨.
- 연결: [[#BSZ-003]](출력판형) · [[paper#BPP-004]]
- tags: #절수 #cutcount #관용어

---

## 4. 결방향 (사이즈·접지에 영향)

### [BSZ-008] 종이 결방향(grain) — 접지선과 나란해야  {[검증]}
- 내용: 종이 섬유의 정렬 방향. 섬유가 **접지선과 나란히(lengthwise) 가야** 크랙(균열)을 방지한다. 임포지션에서 페이지 배치 방향에 영향을 준다.
- 출처: Wikipedia Imposition + heckdon — "fibers must run lengthwise along the fold, which influences the position of the pages"(`_research/base-verification.md` B-3).
- 연결: [[paper#BPP-001]] · [[#BSZ-005]] · [[binding]]
- tags: #결방향 #grain #접지

---

## 5. 외부 표준 참조

### [BSZ-009] CIP4 JDF/XJDF — 임포지션 포함 생산 워크플로 표준  {[검증]}
- 내용: 인쇄 생산 워크플로 정보교환 표준. JDF(2000)/XJDF(2018, JDF 2.0). 임포지션 스킴을 prepress 워크플로의 일부로 표현한다. 차원/공정 모델의 표현력 대조 기준으로 쓸 수 있다.
- 출처: CIP4 공식 + XJDF Spec 2.2 — "imposition schemes as part of the workflow"(`_research/base-verification.md` B-5).
- 연결: [[prepress-file]] · [[#BSZ-005]]
- tags: #CIP4 #JDF #XJDF #표준

---

## Sources (base 권위 = 표준/Wikipedia, 사실별 추적은 위 각 블록)
- Wikipedia Imposition · pdfpress/grokipedia Imposition&bleed · CIP4 JDF/XJDF · EPA/PNC3 매엽인쇄 — 전건 `_research/base-verification.md` A·B 섹션에서 CONFIRMED.
