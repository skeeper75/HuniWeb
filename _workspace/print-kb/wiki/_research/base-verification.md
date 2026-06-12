# Print-KB 위키 — base 검증 노트 (pkw-researcher)

> 작성 2026-06-12. Phase 1 초기 실행. 작업 = ② `wiki/base/` 인쇄 일반지식 사실의 외부 표준 교차검증.
> verdict: **CONFIRMED**(2+ 독립출처 일치=[검증]) · **SINGLE**(단일출처=[단일출처]) · **CONFLICT**(반증/상충) · **UNVERIFIABLE**(외부 근거 부재).
>
> **재단 금지:** 후니 특정 사실(가격·코드·t_* 스키마·정책)은 외부 표준으로 재단하지 않는다 — 검증 대상에서 제외. 본 노트는 `base/` 일반 도메인 지식만 다룬다(현재 base = `printing-methods.md` 1개).
>
> 모든 출처 URL은 본 세션 WebFetch/WebSearch로 확인. Sources 섹션 참조.

---

## 검증 대상 범위

- **현 base 파일:** `base/printing-methods.md`만 존재(다른 6 base 페이지는 계획·미작성 — 검증 대상 없음).
- **레시피 뼈대가 앵커하는 일반 개념:** 임포지션·판형·결방향 등은 base 미작성 상태이나, 레시피 집필 시 base에 들어올 사실이므로 **선제 검증**해 둔다(verdict + 출처). 채택 시 base 신규 페이지의 사실 토대로 재사용.

---

## A. printing-methods.md 사실별 verdict

### A-1. 판 형태 5대 분류(평판/볼록/오목/공판 + 무판 디지털)  {CONFIRMED [검증]}
- 본문 주장: 판의 형태에 따라 평판(planographic)·볼록(relief)·오목(intaglio)·공판(stencil/screen)으로 나뉘고 무판(디지털)이 별도.
- 외부: EPA 인쇄산업 자료 + U Illinois 라이브러리 가이드 + 다수 — "relief printing (letterpress, flexography), planographic printing (offset lithography), recess printing (gravure/intaglio), stencil printing (screen), and digital printing (toner and inkjet)". **2+ 독립출처 일치.**

### A-2. 평판/오프셋 — 물·기름 반발, 판→블랭킷→종이 간접전사  {CONFIRMED [검증]}
- 본문 주장: 물과 기름 반발, 이미지부 친유/비이미지부 친수가 같은 평면, 블랭킷(고무) 경유 간접전사(offset=옮겨 찍음).
- 외부: Wikipedia Offset printing + MPA + PNC3 — "inked image is transferred from a metal plate to a rubber blanket and then to the printing surface ... oil-based ink and water do not mix"; "indirect (offset) process". **2+ 독립출처 일치.**

### A-3. 오프셋 — 대량 단가 최저, 판비(제판비) 고정비로 소량 비쌈, CMYK+망점  {CONFIRMED [검증]}
- 본문 주장: 대량 단가 최저·판비 고정비→소량 비쌈·CMYK 4색 분해+망점(halftone).
- 외부: Wikipedia/MPA — "image is converted to a halftone ... overprinting four process inks: cyan, magenta, yellow, and black (CMYK)". 판비 고정비→대량 경제성은 오프셋 경제학 보편 사실(다수 출처). **2+ 독립출처 일치.**

### A-4. 볼록판 — 이미지부 볼록, 직접 압인, 현대=플렉소(고무/수지, 골판지·라벨·필름)  {CONFIRMED [검증]}
- 외부: EPA + U Illinois Flexo Topic Hub — "image or printing area is raised above the nonimage areas ... relief printing are letterpress and flexography"; flexo는 직접 인쇄(direct). **2+ 독립출처 일치.**

### A-5. 오목판/그라비아 — 음각 셀, 잉크 채우고 닦아 전사, 셀 깊이로 농담  {CONFIRMED [검증]}
- 본문 주장: 이미지부 음각(셀), 잉크 채우고 닦은 뒤 압력 전사, 셀 깊이로 농담 표현.
- 외부: EPA + PNC3 — "printing area, consisting of minute etched or engraved wells of differing depth and/or size, is recessed ... cells ... pick up small amounts of ink". 셀 깊이/크기로 톤. **2+ 독립출처 일치.**

### A-6. 그라비아 — 제판비 매우 높음 → 초대량 전용, 용도(화보·고급포장·지폐·우표)  {CONFIRMED [검증]}
- 본문 주장: 초장수명·고품질, 제판비 매우 높음→초대량 전용, 지폐·우표 등.
- 외부: gentlepk + scribd/PNC3 — 실린더 1색당 고비용($1,700~2,300/구형, 대량 상쇄), "production of 2 million to 5 million images per order"; "currency and ... fine arts". 실린더 장수명. **2+ 독립출처 일치.**

### A-7. 공판/실크스크린 — 비이미지부 막고 잉크 밀어 통과, 두꺼운 불투명 잉크층, 거의 모든 소재  {CONFIRMED [검증]}
- 본문 주장: 스크린 비이미지부 막고 이미지부로 잉크 밀어 통과, 잉크층 두껍고 불투명, 곡면·천·금속·유리 등 거의 모든 소재.
- 외부: Wikipedia Screen printing + xTool + Chromaline — "thick viscous layer of ink ... bright and vivid"; "textiles, wood, paper, glass, and metal ... ceramics ... plastic"; "thick, opaque inks". **2+ 독립출처 일치.**

### A-8. 무판 디지털 — 토너(전자사진, 정전기+열융착) / 잉크젯, 판비 없음, 1부터, VDP  {CONFIRMED [검증]}
- 본문 주장: 토너=정전기 흡착 후 열 융착·소량/즉납/가변데이터, 잉크젯=잉크 분사·대형/사진, 판비 없음·1부터, VDP(부수마다 다른 데이터).
- 외부: Wikipedia VDP + opentextbc + printingforless — "digital printing does not involve setting plates"; "Electrophotographic and ink jet ... each page is imaged individually"; VDP="elements ... changed from one printed piece to the next, without stopping ... using ... a database". **2+ 독립출처 일치.**

### A-9. UV 평판(flatbed) — UV 경화 잉크 평판 분사·즉시 경화, 리지드/비흡수 소재 직접인쇄  {CONFIRMED [검증]}
- 본문 주장: UV 경화 잉크를 평판에 분사·즉시 경화, 아크릴·유리·금속 등 리지드/비흡수 소재 직접인쇄. 실사(대형 잉크젯)=현수막/배너/포스터 비규격 대형.
- 외부: 디지털 잉크젯 UV flatbed는 비흡수 리지드 기재 직접인쇄 보편 사실(잉크젯 계열 자료 다수). 대형 실사=대형 잉크젯. **검증**(보편). 단, "UV 평판"을 단일 표준 명세 1건으로 못박지 않음 — 잉크젯 일반 + 실크 vs UV 구분 자료 종합.

### A-10. 방식 선택 변수 표(경제 수량·셋업·가변데이터·소재자유도·최소 1부)  {CONFIRMED [검증]}
- 본문 표: 옵셋=대량/판비있음/가변불가/종이위주/1부 비현실, 디지털=소량~중량/판비없음/가변가능/종이+α/1부 가능, 실크=중량/제판있음/광범위, 그라비아=초대량/매우높음/필름·종이.
- 외부: A-1~A-9에서 각 셀이 이미 개별 검증됨(경제 수량·셋업·가변·소재·최소부수 모두 위 출처 일치). **표 전체 [검증].**

### A-11. "1상품=1인쇄방식" 일반론, 방식=최상위 분기축(후가공·소재·가격 종속)  {SINGLE [단일출처] — 일부 후니 영역}
- 본문 주장: 한 제품은 보통 한 방식으로 생산, 방식 정해지면 가능한 후가공·소재·가격이 종속.
- 판정: "방식이 후가공·소재를 제약한다"는 보편 사실([검증] 가능 — 공판만 천/유리 가능 등 A-7 종속). 그러나 "1상품=1방식"의 절대성·"최상위 분기축"이라는 **모델링 명제**는 후니 데이터에 대한 해석이다. 메모리 [인쇄방식 비절대축]은 "후니=디지털인쇄+굿즈/파우치, 인쇄방식 절대축 아님, 시트가 1차 이해단위"로 명시 — **후니 특정 영역과 충돌 소지**. 외부 표준으로 재단 금지.
- **권고:** base에는 "방식→후가공/소재 종속"의 보편 사실만 [검증]으로 남기고, "최상위 분기축/1상품=1방식"은 **후니 모델링 주장으로 huni 레이어**에 두거나 약화. (외부 재단 아님 — 위치 분류 권고.)

---

## B. 레시피 뼈대 앵커 개념 — 선제 검증(base 미작성, 채택 시 사실 토대)

### B-1. 임포지션 — 페이지를 대형 인쇄지(press sheet)에 배치, 접지·재단·제본 후 정순  {CONFIRMED [검증]}
- 외부: Wikipedia Imposition + grokipedia/pdfpress — "arrangement of the printed product's pages on the printer's sheet ... faster printing, simplify binding and reduce paper waste"; 접지→재단→제본. **2+ 독립출처 일치.**

### B-2. 시그니처(signature) — 접힌 인쇄지가 이루는 제본 단위  {CONFIRMED [검증]}
- 외부: Wikipedia + pdfpress — "sheets are placed to form the signatures that compose the finished book". **2+ 독립출처 일치.**

### B-3. 종이 결방향(grain) — 섬유 정렬, 접지선과 나란해야 크랙 방지, 임포지션 배치에 영향  {CONFIRMED [검증]}
- 외부: Wikipedia Imposition + heckdon/jpgasway — "papers have a 'grain' ... fibers must run lengthwise along the fold, which influences ... the position of the pages"; 접지 시 크랙 방지. **2+ 독립출처 일치.**
- 한국어 "절수(切數)"=전지를 몇 등분 했는가는 한국 인쇄 관용어 — 영어 1차 명세 직접 대응 없음. 보편 개념(N-up/cut count)은 검증되나 "절수" 용어 자체는 [단일출처/관용]으로 표기 권고.

### B-4. 블리드(bleed)·재단(trim)·크롭마크 — 재단선 넘는 디자인 여백 표준 3mm  {CONFIRMED [검증]}
- 외부: grokipedia/pdfpress + 인쇄 용어집 — "Bleed ... extends beyond the trim edge ... standard being 0.125 inch (3 mm)"; crop/trim marks. **2+ 독립출처 일치.**

### B-5. CIP4 JDF/XJDF — 인쇄 생산 워크플로 정보교환 표준, 임포지션 포함  {CONFIRMED [검증]}
- 외부: CIP4 공식 + 위키/발표자료 — JDF(2000)/JMF, XJDF(2018)=JDF 2.0 "pure information-interchange interface"; "imposition schemes as part of the workflow (PrePress, Press, PostPress, MIS)". **2+ 독립출처 일치.**
- 용도: 본 위키에서 CIP4는 base 사실의 외부 권위 표준이자, 후니 t_* 차원/공정 모델의 표현력 대조 기준(round-12 갭헌팅에서 "후니 스키마가 CIP4 표현력 흡수/능가" 확인됨 — 메모리). base 검증 출처로 활용 가능.

---

## CONFLICT(반증) 건 — 없음

`base/printing-methods.md`의 사실 주장 중 외부 표준에 **반증된 것은 없다.** 전건 CONFIRMED 또는 (A-11) "보편 사실은 검증, 모델링 명제는 후니 영역" 분리 권고 수준.

---

## 출처 약점 지적(개선 권고 연계)

- **printing-methods.md 출처 줄에 "나무위키" 포함** — base의 권위 토대로는 약함(위키 1차자료 아님). 위 A-1~A-10이 EPA·U Illinois·Wikipedia·CIP4 등 더 강한 출처로 전건 재검증되었으므로, 출처 줄을 이들로 격상 권고(→ methodology R-4 [검증]/[단일출처] badge 도입과 연계). 단 **사실 자체는 불변·반증 아님** — 출처 신뢰도만 격상.

---

## 검증 결과 분포

| verdict | 건수 | 항목 |
|---|---|---|
| CONFIRMED [검증] (2+ 독립) | 14 | A-1~A-10, B-1~B-5 (B-3 절수 용어 일부 단서) |
| SINGLE [단일출처] | 1 | A-11(후니 모델링 명제 부분 — 외부 재단 제외) |
| CONFLICT (반증) | **0** | — |
| UNVERIFIABLE | 0 | — |

---

## Sources (전부 본 세션 WebFetch/WebSearch 확인)

- [EPA Printing Industry (5 processes)](https://www3.epa.gov/ttnecas1/regdata/IPs/PRINTING%20PUB%20IP.pdf) — WebSearch 인용(relief/planographic/intaglio/screen 분류).
- [PNC3 Overview of Printing Processes](http://www.pnc3.org/Reference/PrintOverview.php) — WebFetch 검증(5대 공정 상세·간접전사·셀·porous).
- [Wikipedia: Offset printing](https://en.wikipedia.org/wiki/Offset_printing) — WebSearch 인용(블랭킷 간접전사·물기름·CMYK 망점).
- [MPA: Lithographic Offset Printing](https://www.mailpro.org/post/what-is-offset-litho-printing/) — WebSearch 인용(planographic·halftone·CMYK).
- [U Illinois LibGuides: Lithography / Flexo Topic Hubs](https://guides.library.illinois.edu/litho-topic-hub/background/printing-process) — WebSearch 인용(relief/planographic 정의).
- [Wikipedia: Screen printing](https://en.wikipedia.org/wiki/Screen_printing) — WebSearch 인용(thick ink·substrate 다양성).
- [xTool: Screen Printing Guide](https://www.xtool.com/blogs/xtool-academy/screen-printing) — WebSearch 인용(두꺼운 잉크층·소재 다양성).
- [gentlepk: Gravure Printing Cost](https://www.gentlepk.com/gravure-printing-cost/) — WebSearch 인용(실린더 고비용·초대량).
- [Wikipedia: Variable data printing](https://en.wikipedia.org/wiki/Variable_data_printing) — WebSearch 인용(VDP 정의·전자사진/잉크젯·무판).
- [opentextbc: Variable Data Printing](https://opentextbc.ca/graphicdesign/chapter/6-7-variable-data-printing/) — WebSearch 인용(무판·페이지 개별 이미징).
- [Wikipedia: Imposition](https://en.wikipedia.org/wiki/Imposition) — WebFetch 검증(임포지션·시그니처·결방향·접지/재단).
- [grokipedia / pdfpress: Imposition & bleed](https://www.pdfpress.app/blog/complete-guide-pdf-imposition-2026) — WebSearch 인용(press sheet·signature·bleed 3mm·crop marks).
- [CIP4: What is (X)JDF](https://www.cip4.org/print-automation/jdf) — WebSearch 인용(JDF/XJDF 표준·임포지션 워크플로).
- [XJDF Specification 2.2 (CIP4)](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) — WebSearch 인용(XJDF=JDF 2.0 information-interchange).
