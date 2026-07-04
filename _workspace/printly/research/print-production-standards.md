# 프린틀리 — 인쇄 생산 표준·장비·파일포맷 리서치 (프론트 1~4)

> 작성: 2026-07-04 · mbo-standards-researcher (프린틀리 확장) · 방법론 = `mbo-standards-research` 스킬.
> **[HARD] 이 문서는 §35 기존 CIP4 리서치를 심화·확장한다(반복 아님).** §35 `standards-playbook.md`(CIP4 XJDF Intent·2뷰·schema.org·구성 온톨로지)·`routing-layer-schema.md`(DeviceCapabilities E23·능력=축 재사용)를 원천 재사용하고, **프린틀리 ④장비·⑥파일포맷 그릇 근거**로 표준 기관을 확장한다.
> **[HARD] 실 출처 앵커·지어내기 금지·불명확=GAP.** 표준 인용은 1차/공식 URL + 캡처일(2026-07-04). 정밀 열거 미확인은 🟡 candidate.
> **[HARD] 경계**: 온톨로지는 장비 능력·파일 요구·배송 축까지. 프리플라이트/임포지션/견적 **값 계산은 결정론 엔진**(프린틀리 원칙3·§35 D-ROUTE 동형). 이 문서는 축·요구사항 어휘만·값 계산 안 함.
>
> **읽는 법(비전문가용):** 인쇄소는 옵셋·디지털·실사·UV·윤전 같은 "출력 장비"로 물건을 찍는다. 각 장비는 "이런 형식의 파일을 줘야 찍을 수 있다"는 규격이 있다(예: PDF/X-4·재단여백 3mm·해상도 300dpi·CMYK 프로파일). 이 규격들을 국제적으로 표준화한 기관이 여럿(CIP4·Ghent·ISO·Fogra·IDEAlliance·Adobe)이다. 이 문서는 그 기관들이 각각 인쇄 생산의 "무엇"을 표준화하는지 정리하고, 우리 온톨로지의 장비·파일포맷 그릇을 그 표준 이름표에 건다.

---

## 0. §35 승계 선언 — 이미 있는 것(재조사 금지·심화만)

프린틀리 파일포맷/장비 리서치는 §35가 이미 도출한 아래를 **기준선으로 승계**한다(search-before-mint):

| §35 기존 산출 | 내용 | 프린틀리에서의 역할 |
|---|---|---|
| `standards-playbook.md` §1.1 | CIP4 XJDF **Product Intent vs Process 2뷰**·Intent 어휘(Media/Color/Layout/Binding/Folding/Imposition) | 파일포맷은 Process View 접점 — Intent(고객 의도)를 넘어 **RIP-ready 입고 규격**을 이 문서가 보강 |
| `standards-playbook.md` §1.2 | schema.org Product/Offer/PropertyValue | 장비·파일 속성 명명 앵커 재사용 |
| `routing-layer-schema.md` §1~2 | **E23 production_capability = 기존 생산 축(print_method·material·process·size·bundle_qty) `capability_covers`로 가리킴**(재발명 0)·JDF **DeviceCapabilities** 이름표 | 프린틀리 **④장비**의 그릇 — 장비 능력은 새 어휘 안 만들고 축 재사용. 이 문서는 "장비가 요구하는 **파일포맷**" 축을 그 커버 집합에 추가 검토 |
| `routing-layer-schema.md` GAP-ROUTE-2 | XJDF DeviceCapability 구문 **폐기**(레거시 JDF만)·인쇄 능력 열거 미확정 🟡 | 이 문서가 장비 5종 실 능력 축을 2차 자료로 보강(여전히 🟡·brand 실측 대기) |

**프린틀리 추가 임무** = ① CIP4 외 표준 기관(Ghent·PDF Association·ISO·Fogra·IDEAlliance·Adobe)이 인쇄 생산의 무엇을 표준화하는지 지도화 ② 장비 5종 × 요구 파일포맷 매트릭스 ③ 파일포맷 속성(⑥ file_format 그릇)의 표준 근거 ④ 레드 WebToProduct 교차참조(기존 rpmeta 재사용).

---

## 1. 프론트 1 — CIP4 심화 + 표준 기관 지도 (7기관)

인쇄 생산 표준은 **"무엇을 표준화하느냐"로 층이 갈린다.** 한 기관이 전부 하는 게 아니라, **워크플로 교환(CIP4)·파일 컨테이너(ISO PDF/X)·파일 검사규칙(Ghent)·색 프로세스(ISO 12647·Fogra·IDEAlliance)·렌더링 엔진(Adobe)**로 분업한다. 프린틀리 파일포맷 그릇은 이 층들의 이름표를 조합해 건다.

### 1.1 표준 기관 × 표준화 대상 지도 (핵심 산출)

| 기관/표준 | 표준화하는 것 | 인쇄 생산 층 | 프린틀리 그릇 접점 | 1차/공식 출처 | badge |
|---|---|---|---|---|---|
| **CIP4 (JDF/XJDF/JMF/PrintTalk)** | 작업 지시·공정 교환(무엇을 어떻게 찍나)·장비 능력(DeviceCapabilities)·상거래(PrintTalk RFQ→Quote→PO) | 워크플로 교환 | ④장비 능력·⑦주문 라우팅(§35 E22~E25) | [cip4.org](https://www.cip4.org/) · [XJDF 2.2 스펙](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf) | ✅(§35 승계) |
| **ISO 15930 (PDF/X)** | 인쇄 입고용 PDF **파일 컨테이너 규격**(교환 신뢰성) | 파일 컨테이너 | ⑥ file_format `pdf_standard` | [pdfa.org/resource/iso-15930-pdfx](https://pdfa.org/resource/iso-15930-pdfx/) | ✅ |
| **ISO 16612 (PDF/VT)** | **가변데이터**(VDP)·트랜잭션 인쇄용 PDF(PDF/X 위에 얹음·ICC Output Intent) | 파일 컨테이너(VDP) | ⑥ file_format(디지털 VDP 장비) | [pdfa.org/resource/iso-16612-pdfvt](https://pdfa.org/resource/iso-16612-pdfvt/) | ✅ |
| **Ghent Workgroup (GWG 2022)** | PDF/X 위의 **프리플라이트 검사 규칙·베스트 프랙티스**(재단여백·해상도·별색 등 판정)·"Proof of Preflight" | 파일 검사규칙 | 프리플라이트 엔진 인터페이스(§3) | [gwg.org/specifications](https://gwg.org/specifications/) | ✅ |
| **PDF Association** | PDF/X·PDF/VT·PDF 2.0 ISO 표준의 **문헌·리소스 허브**(스펙 자체는 ISO) | 표준 문헌 허브 | ⑥ 규격 참조원 | [pdfa.org](https://pdfa.org/) | ✅ |
| **ISO 12647 (Process Standard)** | 인쇄 **프로세스 제어 파라미터**(CMYK 농도·도트게인/TVI·ΔE 공차·회색균형) — 옵셋 -2 등 | 색·프로세스 제어 | ③사양 색 축·④장비 색 능력 | [ISO 12647-2 (iso.org)](https://www.iso.org/standard/81375.html) · [ISO/DIS 12647-2(en)](https://www.iso.org/obp/ui/en/#!iso:std:81375:en) | ✅ |
| **Fogra (PSO·FograCert)** | ISO 12647-2 **실무 절차·인증**(유럽)·characterization 데이터셋·ICC 프로파일(FOGRA39/51) | 색 인증(유럽) | ⑥ `color_profile` 값 앵커 | [fogra.org/en/certification/offset-printing/pso-certification](https://fogra.org/en/certification/offset-printing/pso-certification) | ✅ |
| **IDEAlliance (GRACoL·G7)** | 북미 **색 목표·G7 근중립 캘리브레이션**(ISO/PAS 15339·CGATS 21 기반)·GRACoL2013 프로파일 | 색 인증(북미) | ⑥ `color_profile` 값 앵커 | [efi 백서 "Demystifying Color Standards G7/GRACoL"](https://www.fiery.com/wp-content/uploads/sites/3/documents/336/efi_fiery_demystifying_color_standards_wp_en_us.pdf) | 🟡(2차 백서) |
| **Adobe PDF Print Engine (APPE)** | PDF **네이티브 렌더링(RIP) 엔진**(PostScript/CPSI 대체)·투명도·컬러관리를 판/프루프 데이터로 | 렌더링 엔진(RIP) | 장비 뒤 RIP(파일포맷 소비자) | [adobe.com/products/pdfprintengine.html](https://www.adobe.com/products/pdfprintengine.html) | ✅ |

### 1.2 표준 층 스택 (파일이 장비까지 가는 경로)

```
[고객 파일]  →  PDF/X-4 (ISO 15930) 컨테이너         ← 파일 규격(무엇을 담나)
             +  ICC Output Intent (FOGRA/GRACoL)     ← 색 목표(어떤 색으로)
             →  Ghent 프리플라이트 검사               ← 규칙 통과/반려(결정론 엔진)
             →  임포지션/터잡기 (JDF Stripping·n-up)   ← 판 배치(결정론 엔진)
             →  RIP: Adobe PDF Print Engine 네이티브   ← 래스터화(장비가 소비)
             →  장비: 옵셋(CTP 판)/디지털/실사/UV/윤전  ← ISO 12647 프로세스 제어로 찍음
```

- **핵심 통찰**: CIP4는 "작업을 **어떻게 주고받나**"(워크플로/능력/상거래), ISO PDF/X·PDF/VT는 "파일을 **무엇에 담나**"(컨테이너), Ghent는 "그 파일이 **규칙에 맞나**"(검사), ISO 12647/Fogra/IDEAlliance는 "**어떤 색으로 찍나**"(프로세스), APPE는 "그 파일을 **어떻게 화면→판으로 바꾸나**"(렌더링). **다섯 층이 직교** — 프린틀리 파일포맷 그릇은 각 층의 속성을 별 슬롯으로 가진다(§3.1).
- **§35와의 관계**: §35는 최상층(CIP4 워크플로·Intent·상거래)만 다뤘다. 프린틀리는 그 아래 **파일 컨테이너·검사·색·렌더링** 4층을 보강해 "장비가 실제 받는 파일"까지 내려간다.

---

## 2. 프론트 2 — 장비 5종 × 능력·요구 파일포맷 매트릭스 (④장비·⑥파일포맷 근거)

각 장비: 무엇을 생산 · 능력 축(속도/색/용지/사이즈) · **요구 입고 파일포맷**(RIP-ready). §35 `capability_covers`(print_method·material·size·bundle_qty) 재사용 + 파일포맷 축 추가 검토.

| 장비 | 생산물(대표) | 능력 축(속도/용지/사이즈) | 색·프로세스 표준 | **요구 파일포맷(RIP-ready)** | 판(plate) | 경제(합판/독판) | 출처 |
|---|---|---|---|---|---|---|---|
| **옵셋 (offset litho)** | 명함·전단·책자·포스터(중~대량) | 셋트지 B1 8~15k sph·셋업 20~40분·4~7 색타워 | **ISO 12647-2** + Fogra PSO/GRACoL | **PDF/X-4**(또는 X-1a)·CMYK+별색·CTP 판출력 | ★CTP 판 필요(셋업 큼) | **합판(gang-run) 경제성 큼**(판 공유) | [Wikipedia Offset](https://en.wikipedia.org/wiki/Offset_printing) · [KETE printing press guide](https://www.ketegroup.com/exploring-the-different-types-of-printing-press/) |
| **디지털 (toner/inkjet)** | 소량·주문형·가변데이터(명함·소책자) | 4색 최대 ~200 fpm·셋업 거의 0·플레이트리스 | ISO 12647-8(디지털)·G7 | **PDF/X-4** + **PDF/VT(ISO 16612)**(가변데이터)·인-RIP 임포지션(Fiery) | 판 없음 | **n-up·gang-run·short-run 배칭**(1레이아웃 최대 160주문 ganging) | [platongraphics 비교](https://platongraphics.com/a-comparison-of-large-format-printing-methods-digital-vs-screen-vs-offset/) · [pdfpress imposition](https://pdfpress.app/blog/best-imposition-software-2026) |
| **실사 (large-format inkjet)** | 현수막·배너·포스터·사인·전시(대형) | 20~60 m²/h(고정밀)·100+ m²/h(단순)·롤/평판 | 프로파일 기반(솔벤트/UV/라텍스 잉크별) | **PDF**·**TIFF**(대형)·**타일링(tiling) 임포지션**(대형 분할) | 판 없음 | 낱장/롤 최적 배치(nesting) | [staplesphotoprinting 기술비교](https://www.staplesphotoprinting.com/blog/digital-inkjet-vs-offset-for-large-posters-a-technical-comparison-591.html) · [printplanet 대형 임포지션](https://printplanet.com/threads/prepress-standards-for-large-format-imposition.256733/) |
| **UV (UV inkjet)** | 경질 기재·특수 소재·패키징(폼보드·아크릴·판스티커) | 600~1200 dpi 그레이스케일 헤드·인라인 경화·체인지오버 5~10분 | 확장색역(ECG) 가능·프로파일 기반 | **PDF**(래스터/벡터)·화이트/바니시 별 채널(스팟) | 판 없음 | 평판 nesting | [Computype flexo/digital/UV](https://computype.com/blog/flexographic-digital-offset-and-uv-inkjet-2/) · [gotprint UV/flexo/offset](https://www.gotprintcoupon.com/2026/04/26/which-print-process-is-right-for-your-packaging-runs-uv-inkjet-flexo-or-offset/) |
| **윤전 (web/rotary·flexo 포함)** | 대량 출판·신문·라벨·패키징(초대량) | 웹 연속급지 고속·flexo=포토폴리머 판·로터리 실린더 | ISO 12647-3(신문)·-6(flexo)·프로파일 | **PDF/X** + **PDF/VT**(트랜잭션·라벨 가변) | ★flexo 포토폴리머 판/실린더 | 초대량 전용(합판 무의미·전량 독판급) | [Computype flexo](https://computype.com/blog/flexographic-digital-offset-and-uv-inkjet-2/) · [KETE press guide](https://www.ketegroup.com/exploring-the-different-types-of-printing-press/) |

### 2.1 매트릭스 요지 (프린틀리 그릇 결론)

- **파일포맷 축은 장비마다 다르다** — 옵셋/윤전=판 출력 전 **PDF/X-4 + 색 프로세스 엄격**(ISO 12647); 디지털=**PDF/VT 가변데이터 + 인-RIP 임포지션**; 실사=**PDF/TIFF + 타일링**; UV=**PDF + 화이트/바니시 스팟 채널**. → ⑥ file_format 그릇은 `pdf_standard`·`color_profile`·`resolution`·`bleed`·`special_channels`(화이트/바니시)·`imposition_required`·`tiling` 속성을 장비별로 달리 요구(§3.1).
- **공통 소비자 = RIP(APPE)** — 5종 모두 최종적으로 Adobe PDF Print Engine 계열 네이티브 RIP이 파일을 래스터화(§1.1). "장비가 받는다"의 실체 = "그 장비의 RIP이 받는다". APPE는 옵셋·그라비어·flexo·잉크젯·전자·나노그래픽 전 세그먼트 구동([Adobe brochure](https://www.adobe.com/content/dam/cc/us/en/products/pdfprintengine/homepage/Q420_Adobe_APPEBrochure_web.pdf)).
- **§35 축 재사용 확인** — 장비 능력은 여전히 print_method(합판/독판·옵셋/디지털/UV/윤전)·material(용지/기재)·size(대형/소형)·bundle_qty(MOQ)로 표현 가능(§35 `capability_covers` 재발명 0 원칙 유지). **추가되는 유일한 신규 능력 축 후보 = "요구 파일포맷"** — 장비 노드가 `requires_file_format`(가칭)으로 ⑥ file_format 노드를 가리킴(architect 확정 대상·§3.3).
- **GAP-PRINTLY-EQ1**: 위 능력 수치(sph·m²/h·dpi·체인지오버)는 **2차 자료(벤더/블로그) 일반값**이다. 후니·와우·레드 **실 보유 장비 실측 능력 프로파일은 데이터 0**(§35 G-ROUTE-1 승계) — 장비 노드는 스키마 형(型)만·실 앵커는 능력 실측 후(anchor=none+candidate).

---

## 3. 프론트 3 — 파일포맷·프리플라이트·임포지션 (⑥ file_format 속성 근거 + 엔진 경계)

### 3.1 PDF/X 규격 계보 + ⑥ file_format 속성 표준 근거

| ⑥ file_format 속성(01_step1 초안) | 표준 근거 | 표준값(예) | 출처 |
|---|---|---|---|
| `pdf_standard` | ISO 15930(PDF/X)·ISO 16612(PDF/VT) | **PDF/X-4**(현대 표준·라이브 투명도/레이어/ICC)·PDF/X-1a(레거시·평탄화 CMYK+별색)·**PDF/VT**(가변데이터) | [img.ly PDF/X 가이드](https://img.ly/blog/what-does-print-ready-pdf-mean-understanding-pdf-x-standards-for-professional-printing/) · [pdfa ISO 15930](https://pdfa.org/resource/iso-15930-pdfx/) |
| `bleed`(재단여백) | 프리플라이트 관행(Ghent) | **3mm / 0.125in** 사방 | [pdfpress 프리플라이트 가이드](https://pdfpress.app/blog/pdf-preflight-guide) |
| `resolution`(해상도) | 프리플라이트 관행 | 이미지 **300 DPI**(실제 인쇄 크기 기준) | [mailpro 파일 체크리스트](https://www.mailpro.org/post/print-file-checklist/) |
| `color_profile`(ICC Output Intent) | ISO 12647 + Fogra/IDEAlliance | **FOGRA39/51**(유럽)·**GRACoL2013**(북미)·CMYK | [fogra PSO](https://fogra.org/en/certification/offset-printing/pso-certification) · [efi G7/GRACoL 백서](https://www.fiery.com/wp-content/uploads/sites/3/documents/336/efi_fiery_demystifying_color_standards_wp_en_us.pdf) |
| `imposition_required`(터잡기 전제) | JDF Stripping·in-RIP | true(합판/책자)·false(단순 낱장) | [pdfpress imposition 가이드](https://www.pdfpress.app/blog/complete-guide-pdf-imposition-2026) |
| `special_channels`(★신규 후보) | UV 화이트/바니시 스팟(별색) | 화이트 잉크·바니시·다이라인 스팟 채널 | [Computype UV](https://computype.com/blog/flexographic-digital-offset-and-uv-inkjet-2/) (레드 STPADPN "화이트강제" rpmeta 교차·§4) |

- **PDF/X-4 = 현대 표준**: 라이브 투명도·레이어·CMYK/RGB/Lab/별색·ICC 유지 → 파일 작아지고 품질 좋음(단 현대 RIP 필요). PDF/X-1a = 평탄화·CMYK+별색만(레거시 호환). GWG 2022도 **PDF/X-4 위에** 지음(PDF 2.0/PDF/X-6는 "아직 어리다"고 유보·[callas GWG 2022](https://www.callassoftware.com/en/blog/gwg-2022-same-old-same-old)).

### 3.2 프리플라이트 = Ghent 규칙 (결정론 엔진 인터페이스·경계)

- **프리플라이트** = 입고 파일이 규격에 맞나 **자동 검사**하고 불합격 시 사유 리포트로 반려(RGB 잔존·폰트 미임베드·해상도 부족·재단여백 미정의 등). 가장 흔한 결함 = **300 DPI 미만 이미지**([pdfpress 프리플라이트](https://pdfpress.app/blog/pdf-preflight-guide)).
- **GWG 2022 혁신** = ① PDF/X-4 기반 ② **거짓 양성(false positive) 감소**(생산 문제 안 되는데 뜨는 에러 컷) ③ 고도 구조화 스프레드시트(고유 ID·버전으로 벤더 구현 용이) ④ **"Proof of Preflight"** — 프리플라이트가 실행됐음을 증명하는 최초 범용 스펙([creativepro Proof of Preflight](https://creativepro.com/the-ghent-pdf-workgroup-releases-first-universal-proof-preflight-specification/)).
- **★경계(프린틀리 원칙3·§35 D-ROUTE 동형)**: 온톨로지는 **"어떤 규칙 축이 검사되나"**(재단여백·해상도·색공간·폰트임베드)를 **축 노드로** 갖는다. 실제 **파일을 열어 통과/반려 판정하는 계산 = 프리플라이트 엔진**(Ghent 규칙 구현·결정론). 온톨로지는 값 계산 안 함 — quote_function(§35 U-18)·routing_function(U-27)과 완전 동형인 **`preflight_function` 경계 노드**(anchor=none·값=엔진) 후보. architect 확정 대상.

### 3.3 임포지션 = JDF Stripping / in-RIP (결정론 엔진 인터페이스·경계)

- **임포지션(터잡기)** = 인쇄 판/시트에 페이지를 **몇 개·어떻게 앉히나**(n-up·책자 접지순·합판 gang-run·대형 타일링). 현대 워크플로는 **JDF로 임포지션을 자동 생성** → RIP에 작업 생성 → MIS로 데이터 회신([printplanet Fuji XMF](https://printplanet.com/threads/fuji-xmf-workflow.20033/)). **in-RIP 임포지션**(EFI Fiery Impose)은 RIP 파이프라인 안에서 gangup·booklet·VDP 처리([pdfpress imposition](https://pdfpress.app/blog/best-imposition-software-2026)).
- **후니 기존 자산 접점**: `fn_calc_pansu`(판걸이수)·`fn_best_plate`(판형)는 **"몇 개 앉나·어느 판"의 수치**를 이미 계산(§35 U-6 ImpositionStrategy·plate-sizes). 이것이 프린틀리 임포지션 엔진의 **판걸이 계산 부분**. 단 "실제 임포지션 파일(면付 PDF) 생성"은 별개 도구(§step0 노트).
- **★경계(원칙3·D-ROUTE 동형)**: 온톨로지는 **임포지션 전략 축**(number-up·gang/dedicated·booklet·tiling·§35 U-6 ImpositionStrategy)을 축 노드로 갖는다. **몇 개 앉나·어느 판·면付 파일 생성 = 임포지션 엔진**(fn_calc_pansu + 판생성 도구·결정론). `imposition_function` 경계 노드 후보(preflight_function과 동형).
- **CIP4 표준 이름표**: 임포지션 = XJDF **Imposition/number-up**(§35 U-6·standards-playbook §1.1 재사용)·JDF **Stripping**(면付 데이터). 표준 어휘 승계 — 신규 mint 0.

### 3.4 두 경계 노드 요약 (§35 경계 노드 계보 확장)

| 경계 노드(후보) | 온톨로지가 갖는 것(축) | 엔진이 하는 것(값·계산) | §35 동형 선례 |
|---|---|---|---|
| `preflight_function` | 검사 규칙 축(재단여백·해상도·색공간·폰트·별색) | 파일 열어 통과/반려·리포트(Ghent 규칙 구현) | quote_function(U-18)·routing_function(U-27) |
| `imposition_function` | 임포지션 전략 축(n-up·gang·booklet·tiling) | 판걸이수·면付 파일 생성(fn_calc_pansu + 도구) | 동상 |

- **정당성**: §35가 이미 "가격 값=엔진"(D-18)·"라우팅 배정 값=엔진"(D-ROUTE) 경계를 세웠다. 프린틀리는 **"프리플라이트 판정 값=엔진"·"임포지션 계산 값=엔진"** 2개를 **동형으로 추가** — 표준 없는 계산 경계를 그래프에 명시(anchor=none+사유). 새 패턴 아님·기존 경계 노드 패턴 재사용.

---

## 4. 프론트 4 — WebToProduct 교차참조 (레드 기존 분석 재사용·재조사 금지)

### 4.1 GAP 명시 — "RED Web To Product System" 영상

- **GAP-PRINTLY-W2P1**: 지니가 준 "RED Web To Product System" 영상은 **자막 추출 불가**(자막 미확보) → 영상 내용 자체는 **인용 불가·지어내기 금지**. 아래는 영상의 **프록시**로 우리 기존 레드 역공학 산출(§11 rpmeta·§6 huni-widget)을 **읽기 재사용**한 것이다(신규 조사 아님).

### 4.2 레드가 웹→상품→생산을 잇는 방식 (기존 rpmeta에서 확인)

레드프린팅 라이브 역공학(§11 rpmeta `_index.md`·HANDOFF·13 카테고리 종단)이 드러낸 **WebToProduct 메커니즘**:

| 레드 메커니즘 | 관측된 것(rpmeta 앵커) | 웹→상품→생산 연결 의미 | 프린틀리 그릇 접점 |
|---|---|---|---|
| **`item_gbn` (생산 모델 라우팅)** | `clothes2025`·`book2025`·`acrylic2025`·`offset2023_item`·`vDigital`·`edicus` 등 상품 헤더 실측 | ★같은 "홍보물"이라도 **어느 생산 모델/엔진으로 처리되나**를 상품이 선언 — 웹 상품이 **생산 경로를 지목** | ④장비/생산모델 라우팅 = §35 print_method + item_gbn 대응(**can_produce 포섭**) |
| **디자인 입력 채널(#16 축)** | `useKoiEditor`(Y/N)·`useTemplate`(Y/N)·`usePDF`(Y/N) 플래그 실측(TP·캘린더·티켓) | ★고객이 **에디터로 만드나·템플릿 쓰나·PDF 입고하나** = **웹→파일 입고 경로** 분기(rpmeta distinct **#16 디자인입력채널** 승격) | ⑥ file_format 입고 채널 = "PDF 직입고 vs 에디터 생성"의 상위 축 |
| **인쇄방식별 상품 분기** | 같은 책자가 `PRBKY*`(윤전)·`PRBKO*`(토너)·`PRIDPRT`(인디고)·`PRPORSO`(리소) 별 pdtCode | ★웹 상품 코드 자체에 **인쇄 장비/방식이 인코딩** — 상품 선택 = 장비 선택 | ④장비 = print_method(§35 U-4·rpmeta #12 가격모델)로 흡수(distinct 아님·부결 확정) |
| **가변데이터/화이트 강제** | STPADPN "DTF·화이트강제·도수숨김"·`vTmpl` 가격 | UV/DTF 장비의 **파일 요구(화이트 채널)**가 웹 옵션으로 노출 | ⑥ `special_channels`(화이트·§3.1) 실증 앵커 |
| **가격 = 서버 호출** | `priceCall`·item_gbn별 가격엔진(`clothes2025_price`·`book2025`·`acrylic2025_price`·`digital_price`·`tmpl_price`) | 웹→가격은 **불투명 서버 계산**(§35 D-18·QuoteFunction 동형) | 가격 값=엔진 경계 재확인 |

### 4.3 교차참조 결론

- **레드 WebToProduct = "웹 상품이 생산 경로(item_gbn·인쇄방식 pdtCode)와 파일 입고 채널(에디터/템플릿/PDF)을 지목하고, 가격은 서버가 계산"** — 이는 프린틀리 온톨로지가 이미 가진 축으로 **전부 흡수**된다(§35 print_method·rpmeta 17축·#16 디자인입력채널). **새 축 필요 없음**(rpmeta 13 카테고리 distinct 0 재확인).
- **프린틀리 함의**: ④장비·⑥파일포맷 그릇은 레드가 실증한 두 접점을 표준 이름표에 건다 — ① 생산 경로 = `capability_covers`/print_method(CIP4 Process·§35) ② 파일 입고 채널 = file_format의 상위 축(에디터생성/PDF직입고·Ghent 프리플라이트 적용 대상은 PDF직입고 경로). 
- **GAP-PRINTLY-W2P2**: 레드 산출은 **옵션/구조 역공학**(기초데이터 렌즈)이지 "생산 파일이 실제 어느 장비 RIP으로 흐르나"의 **백엔드 파이프라인은 미관측**(웹 프런트만). 장비-파일 실 배선은 후니 실측/공급자 레지스트리 확보 후(§35 G-ROUTE-1).

---

## 5. GAP (정직 기록)

- **GAP-PRINTLY-EQ1**: 장비 5종 능력 수치(sph·m²/h·dpi·체인지오버·색타워)는 2차 벤더/블로그 일반값 — 후니·와우·레드 **실 보유 장비 능력 프로파일 데이터 0**(§35 G-ROUTE-1 승계). 장비 노드는 스키마 형만·anchor=none+candidate.
- **GAP-PRINTLY-FF1**: ISO 12647/15930/16612 스펙 **본문 직독 안 함**(iso.org 유료) — PDF Association·Fogra·벤더 2차 자료 교차확인. 정밀 파라미터(도트게인 곡선·ΔE 공차 수치·PDF/X-4 세부 conformance)는 필요 시 스펙 구매/직독 대상.
- **GAP-PRINTLY-FF2**: GRACoL/G7·Fogra characterization 데이터셋 값(FOGRA39 vs 51 LAB 좌표)은 미조사 — color_profile은 **이름표 앵커만**(값=엔진/프로파일 파일 권위). §35 D-18 동형(값 계산 경계 밖).
- **GAP-PRINTLY-W2P1/2**: WebToProduct 영상 자막 미확보(§4.1)·레드 백엔드 파이프라인 미관측(§4.3) — 레드 프런트 역공학 프록시로 대체.
- **GAP-PRINTLY-BND**: `preflight_function`·`imposition_function` 경계 노드는 **후보**(§3.4) — 정식 개체/관계 승격은 architect + MB7 게이트 후. 이 문서는 표준 어휘·경계 방향까지·스키마 확정 아님.
- **GAP-STD-1/2(§35 승계)**: XJDF BindingType/FoldCatalog 정밀 열거·PrintMethod XJDF 자원 위치 미확정(🟡) — §35 GAP 그대로.

## Sources (실 출처 앵커·캡처 2026-07-04)

**§35 승계 원천(읽기·재사용):**
- §35 `_workspace/huni-multibrand-ontology/00_research/standards-playbook.md`(CIP4 XJDF Intent·2뷰·schema.org·구성 온톨로지·GAP-STD-1~4)
- §35 `_workspace/huni-multibrand-ontology/03_upper_ontology/routing-layer-schema.md`(E22~E25·DeviceCapabilities·능력=축 재사용·D-ROUTE 경계·G-ROUTE-1)
- §11 `_workspace/huni-rpmeta/_index.md`·`HANDOFF.md`(레드 13 카테고리 역공학·item_gbn·#16 디자인입력채널·인쇄방식 pdtCode — WebToProduct 프록시)

**표준 기관 1차/공식:**
- CIP4: [cip4.org](https://www.cip4.org/) · [XJDF 2.2](https://www.cip4.org/files/cip4/documents/XJDF%20Specification%202.2.pdf)
- ISO PDF: [ISO 15930 PDF/X (pdfa.org)](https://pdfa.org/resource/iso-15930-pdfx/) · [ISO 16612 PDF/VT (pdfa.org)](https://pdfa.org/resource/iso-16612-pdfvt/) · [PDF Association](https://pdfa.org/)
- Ghent Workgroup: [gwg.org/specifications](https://gwg.org/specifications/) · [Proof of Preflight (creativepro)](https://creativepro.com/the-ghent-pdf-workgroup-releases-first-universal-proof-preflight-specification/) · [GWG 2022 (callas)](https://www.callassoftware.com/en/blog/gwg-2022-same-old-same-old)
- ISO 12647: [ISO 12647-2 (iso.org)](https://www.iso.org/standard/81375.html) · [ISO/DIS 12647-2(en)](https://www.iso.org/obp/ui/en/#!iso:std:81375:en)
- Fogra: [PSO Certification](https://fogra.org/en/certification/offset-printing/pso-certification) · [Fogra offset certification](https://fogra.org/en/certification/offset-printing)
- IDEAlliance/G7: [efi "Demystifying Color Standards" 백서](https://www.fiery.com/wp-content/uploads/sites/3/documents/336/efi_fiery_demystifying_color_standards_wp_en_us.pdf) · [Media Standard Print (Wikipedia)](https://en.wikipedia.org/wiki/Media_Standard_Print)
- Adobe APPE: [adobe.com/products/pdfprintengine.html](https://www.adobe.com/products/pdfprintengine.html) · [APPE brochure PDF](https://www.adobe.com/content/dam/cc/us/en/products/pdfprintengine/homepage/Q420_Adobe_APPEBrochure_web.pdf)

**장비·파일포맷·임포지션(2차 실무):**
- [Wikipedia Offset printing](https://en.wikipedia.org/wiki/Offset_printing) · [KETE 인쇄기 가이드](https://www.ketegroup.com/exploring-the-different-types-of-printing-press/) · [Computype flexo/digital/UV](https://computype.com/blog/flexographic-digital-offset-and-uv-inkjet-2/) · [platongraphics 대형 비교](https://platongraphics.com/a-comparison-of-large-format-printing-methods-digital-vs-screen-vs-offset/)
- [img.ly PDF/X 가이드](https://img.ly/blog/what-does-print-ready-pdf-mean-understanding-pdf-x-standards-for-professional-printing/) · [pdfpress 프리플라이트](https://pdfpress.app/blog/pdf-preflight-guide) · [mailpro 파일 체크리스트](https://www.mailpro.org/post/print-file-checklist/) · [pdfpress imposition 가이드](https://www.pdfpress.app/blog/complete-guide-pdf-imposition-2026)
