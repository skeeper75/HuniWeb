# 전처리·파일 (Prepress & File)

> 베이스 지식(인쇄산업 일반). 후니 특정 아님 — 보편 도메인 지식.
> 출처 신뢰도 표기 = [검증]/[단일출처]/[추정] (권위: `_research/base-verification.md`).
>
> ⚠️ **검증 한계 정직 표기:** base-verification는 임포지션·블리드·CIP4까지 검증했다(B). 파일포맷(PDF/X)·해상도 등 입고 규격의 독립 외부 검증 노트는 일부 미완 → **[추정]** 또는 **GAP**로 정직 표기한다. 날조하지 않는다.

---

## 1. 임포지션·판걸이 (검증된 사실)

### [BPF-001] 임포지션(imposition) — 인쇄지에 페이지 배치  {[검증]}
- 내용: 완성물 페이지를 대형 인쇄지에 순서·방향 맞춰 배치하는 prepress 작업. 접지·재단·제본 후 정순이 되게 하고, 인쇄 효율·용지 절감을 노린다.
- 출처: Wikipedia Imposition — "arrangement of pages on the printer's sheet ... faster printing, simplify binding and reduce paper waste"(`_research/base-verification.md` B-1).
- 연결: [[sizes#BSZ-005]] · [[sizes#BSZ-006]](시그니처)
- tags: #임포지션 #prepress

### [BPF-002] 판걸이(N-up) — 한 인쇄지에 몇 면  {[검증(개념)]}
- 내용: 한 출력판형(전지/절지)에 완성물을 몇 면(N-up) 앉히는가. 작업 사이즈와 인쇄 가능 영역으로 결정되며, 임포지션의 핵심 변수다.
- 출처: Wikipedia Imposition N-up 개념(B-1, [검증]). "판걸이/판걸이수"는 한국 관용어 [단일출처/관용].
- 연결: [[sizes#BSZ-003]](출력판형) · [[sizes#BSZ-002]](작업 사이즈)
- tags: #판걸이 #Nup #관용어

> ⚠️ **"판수=런타임 앱 계산·DB 미저장"은 후니 모델링 원칙**(보편 사실 아님) → [[../huni/modeling-axioms]] 또는 huni 가격 축에 둔다. base에는 N-up 보편 개념만(`_curation/axis-price-engine.md` "판수=앱 계산", 메모리 dbmap-compute-in-app-db-stores-lookup).

---

## 2. 출력 규격 (검증된 사실)

### [BPF-003] 블리드·재단마크 — 입고 표준 3mm  {[검증]}
- 내용: 입고 파일은 재단선 너머 3mm 블리드 + 재단마크를 포함해야 재단 오차에 대응한다.
- 출처: pdfpress/grokipedia(`_research/base-verification.md` B-4).
- 연결: [[sizes#BSZ-004]] · [[#BPF-004]]
- tags: #블리드 #재단마크 #입고

### [BPF-004] CIP4 JDF/XJDF — prepress 정보교환 표준  {[검증]}
- 내용: 인쇄 생산 정보교환 표준. prepress(임포지션 포함)·press·postpress·MIS 단계 정보를 표현한다.
- 출처: CIP4 + XJDF Spec 2.2(`_research/base-verification.md` B-5).
- 연결: [[sizes#BSZ-009]] · [[#BPF-001]]
- tags: #CIP4 #JDF #XJDF

---

## 3. 파일포맷·해상도 (검증 대기 — 정직 표기)

### [BPF-005] PDF/X — 인쇄 입고 표준 포맷  {[추정]}
- 내용: 인쇄 입고용으로 폰트 임베드·색공간 고정 등을 강제하는 PDF 서브셋(PDF/X 계열)이 통용된다. **독립 외부 검증 노트 미완** → [추정].
- 출처: 인쇄 도메인 통념. **base-verification에 PDF/X 항목 부재.** [GAP-BPF-1]
- 연결: [[color#BCL-006]](색관리) · [[#BPF-003]]
- tags: #PDFX #입고포맷 #검증대기

### [BPF-006] 해상도·이미지 품질 — 인쇄용 dpi  {GAP}
- 내용: 인쇄용 래스터 이미지는 일정 해상도(통상 300dpi 통념)가 권장되나, **외부 표준 교차검증 노트가 없어 base 사실로 수치를 단정하지 않는다.**
- 출처: **GAP — /deep-research 검증 필요.**
- 연결: [[#BPF-005]]
- tags: #해상도 #dpi #GAP

---

## GAP (검증 대기 — 날조 금지)
- [GAP-BPF-1] PDF/X 표준 정의 — base-verification 부재.
- [GAP-BPF-2] 인쇄 해상도(dpi) 권장값 — 수치 검증 대기.

> 후니 특정 전처리(판수=앱 계산·출력용지규격 매핑·파일사양 컬럼 등)는 huni 축([[../huni/...]] price-engine / load-path)에 둔다. base는 보편 개념만(검증되면 채움).

## Sources
- Wikipedia Imposition(B-1) · pdfpress 블리드(B-4) · CIP4(B-5) — `_research/base-verification.md` CONFIRMED. 판걸이 관용어·PDF/X·해상도는 미검증/관용(GAP).
