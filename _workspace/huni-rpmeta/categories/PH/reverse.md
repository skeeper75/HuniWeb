# RP 옵션 원자 추출 — PH(포토보드·액자·사진인화·포토북·포토굿즈) 카테고리

> 후니 RP-Meta 하네스 파이프라인 ① 산출물 (rpm-reverse-engineer).
> RedPrinting PH 카테고리(30상품) 대표 3상품 원자추출 + 27상품 그룹 횡단 태깅을 **base-data 관리 렌즈**로 역공학.
> 목적 = 메타모델 아키텍트가 "RedPrinting이 **액자 프레임(원목/알루미늄/종이/아크릴/디아섹)·마운팅·전면(유리/아크릴)·거치(벽걸이/탁상)·사진인화 매체(인화지×유광/반광/스노우/홀로그램)·보드 패널 마운팅** 을 어떤 관리 축으로 분리·정규화하는가"를 추상화할 원재료.
> RedPrinting은 사용자 본인 설계 시스템(검증된 참조 모델 — 답습 아님).
> **★PH 카테고리의 본질 = 한 카테고리 안에 5개 이질 상품군이 공존 — ① 액자류 PHFR*(11) ② 사진인화류 PHPT*/PHPR*/PHPK*(8) ③ 보드/판 PHPTPRM·PHST*(4) ④ 포토북 PHBK*(5) ⑤ 포토굿즈 PHMG/PHPO(2).** ★최대 관전 = **액자 프레임/마운팅·사진인화 매체가 distinct 신규 축 #18인가, 기존 축(자재#1/부속물#8/형태가공#14/AC입체) facet인가** — 1차 판정 §0·§5·Ambiguous PH-1/PH-2/PH-3.
> **★결론 선요약: 액자 프레임 재질 = AC 소재variant/ST 점착소재 spectrum과 동형 — 프레임 재질이 상품을 가른다(pdtCode 분기, 자재#1 facet). 마운팅/거치(벽걸이/탁상)·전면(유리/아크릴) = 라이브 옵션 미노출(SSR-negative) = `unobserved`(날조 금지). 사진인화 매체 = 인화지×마감(유광/반광)을 한 paper select에 합성(자재#1 surface-finish facet). distinct #18 후보 = "완제품 액자 프레임(인쇄물을 끼우는 그릇)" — 단 라이브 옵션 미관측으로 1차 예측은 NO(facet), Ambiguous PH-1로 아키텍트 회부.**

## 출처 표기 규칙 (BN/GS/TP/PR/ST/CL/AC 계승)
- `[reuse:productInfo]` = huni-widget 캡처(`_workspace/huni-widget/01_reverse/captures/product_*.json` · `05_qa/captures/major_*.json`)의 infoCall/widgetDump 풀 응답. **PH는 reuse 캡처 0건 보유**(`product_ACNTHAP/GSTGMIC/PRBKYPR.json`만 존재 — PH* prefix 캡처 부존재 확인). 따라서 PH는 라이브 보강이 1차.
- `[live:SSR-legacy]` = 2026-06-17 라이브 읽기전용 GET `https://www.redprinting.co.kr/ko/product/item/PH/{code}` = HTTP 200. **레거시 jQuery 렌더 상품**은 인라인 `product_option = {…}` JS 객체 + 렌더된 `<select><option>` SSR 노출. **PH 중 4상품만 레거시**: PHPTPRM(포토보드)·PHPODFT(포토화분)·PHBKMYB(포토북)·PHMGDFT(머그·부분). 옵션 select·skin_view 플래그·price_gbn/pdt_gbn/cate 실측.
- `[live:SSR-negative]` = 같은 GET이 HTTP 200(~165KB 스켈레톤)이나 **신규 Vue client-render** — 옵션 select 미노출. 액자류 11종 전부·사진인화 신상품(PHPTEDT/PHPRDFT/PHPKDFT/PHPTSHP)·판스티커(PHSTPAN) 해당. 전역 `km1_size`(750x585/636x469 국2절 등 임포지션 출력판형 select·**HTML 주석처리된 옵션 포함 = 숨김 에디터 스캐폴드, 상품 옵션 아님**)와 PARTNER SITE nav select만 정적 노출 — 옵션은 마케팅/추천 카피로만 보임(액자류 디아섹/원목/벽걸이/탁상/고리 키워드 카운트가 11상품 거의 동일 = 공유 카테고리 nav 블록, 상품 고유 옵션 아님).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json` 상품명·URL·category (2026-06-17 확인, PH 30상품 전부 category=PH·URL=/item/PH/). **catalog에 가격 필드 부재**(it_g_price 공란) — 가격은 레거시 SSR `it_g_price`에서만.
- `[xref:AC]`/`[xref:PR]` = `categories/AC/reverse.md`(아크릴 두께/소재variant/입체)·`categories/PR/reverse.md`(책자 제본) 동형 대조용 참조 표기.
- `unobserved` = 미관측(날조 금지). **액자 프레임 재질/마운팅/전면유리·아크릴/거치 = 도메인 일반지식으로는 추정 가능하나 라이브 옵션 미노출 → 전부 `unobserved` 정직 표기.**

## base_data_tag 7버킷 (가설 — 아키텍트가 최종 확정)
자재(material) / 공정(process) / 옵션(option) / 템플릿(template/SKU) / 제약(constraint) / 기초코드(base-code/enum) / 카테고리(category)

---

## 0. PH 카테고리 핵심 발견 — 5개 이질 상품군이 한 카테고리에 공존, 액자=프레임재질 pdtCode 분기

PH는 단일 옵션 스키마가 아니라 **5개 이질 상품군**이 한 카테고리(category=PH)에 묶인다. 각 군의 base-data 모델은 서로 다르다:

| 상품군 | pdtCode 패턴 | 상품수 | 가격모델(price_gbn) | 에디터(koi/pdf) | 본질 | 동형 카테고리 |
|--------|-------------|--------|---------------------|------------------|------|---------------|
| ① 액자류 | PHFR* | 11 | unobserved(SSR-neg) | unobserved | 완제품 프레임에 인쇄물 끼움 | `[xref:AC]`(완제 SKU)·GS(완제) |
| ② 사진인화류 | PHPT*/PHPR*/PHPK* | 8 | unobserved/tmpl(부분) | unobserved | 인화지 출력(매수×사이즈×마감) | (신규 인화 모델) |
| ③ 보드/판 | PHPTPRM·PHST* | 4 | **tmpl_price**(실측) | **koi=Y/pdf=Y** | 포스터를 보드/판에 인쇄 | PR 포스터 |
| ④ 포토북 | PHBK* | 5 | **digital_price**(실측) | koi=N/pdf=Y | 사진책 제본(면수×사이즈×단/양면) | `[xref:PR]` 책자 |
| ⑤ 포토굿즈 | PHMG/PHPO | 2 | **tmpl_price**(실측) | koi=N/pdf=Y | 머그/화분에 전사인쇄 | GS 완제굿즈 |

**★핵심 = PH는 "사진(이미지)을 어떤 물성(종이/보드/액자/책/머그)으로 출력하느냐"로 묶인 카테고리** — 즉 **출력 매체(output medium)** 가 카테고리 분류 기준. 이는 BN(현수막=대형출력)·GS(굿즈=완제) 같은 "물성 카테고리"와 같은 분류 철학.

### 0.1 ★액자 프레임 재질 = pdtCode 분기 (AC 소재variant·ST 점착소재 spectrum과 동형) — directive 최대 관전 1
액자 11종은 **프레임 재질별 별 pdtCode**로 분기(`[live:catalog]` 11상품 전부 category=PH):

| pdtCode | 상품명 | 프레임 재질 | 거치/형태 단서(상품명) |
|---------|--------|-------------|------------------------|
| PHFRHAN | 한나무 액자 | 한나무(원목) | - |
| PHFRHDU | 한나무 듀얼 액자 | 한나무(원목) | 듀얼(2면) |
| PHFRASB | 애쉬 원목 액자(브라운) | 애쉬 원목 | 브라운 |
| PHFRASH | 애쉬 원목 액자(내추럴) | 애쉬 원목 | 내추럴 |
| PHFRASD | 애쉬 원목 액자(양면형) | 애쉬 원목 | 양면형 |
| PHFRWOD | 포토프레임 액자(원목) | 원목 | - |
| PHFRALU | 포토프레임 액자(알루미늄) | 알루미늄 | - |
| PHFRPAP | 종이 액자 | 종이 | - |
| PHFRACR | 아크릴 액자 | 아크릴 | - |
| PHFRDIA | 디아섹 아크릴 액자 | 디아섹(아크릴 마운팅) | - |
| PHFRMUL | 멀티프레임 액자 | (멀티 프레임) | 멀티(다면) |
| PHFRFIR | 첫돌 액자 | unobserved | 이벤트(첫돌) |

→ 프레임 재질(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹)이 **상품을 가른다**(pdtCode 분기). 한 상품 내 "프레임 재질 select"는 **라이브 옵션 미노출**(전부 `[live:SSR-negative]`). base_data_tag = **자재(프레임 재질) + 카테고리(재질특화 상품)**. **★AC 소재variant(투명/홀로그램/글리터/거울 = pdtCode 분기) §0.2·ST 점착소재 spectrum과 완전 동형 — 자재 variant가 상품을 가르는 패턴 재확인. 단 액자는 "인쇄물을 끼우는 빈 프레임(완제품)"이라는 점이 AC(아크릴 본체에 직접 인쇄)와 다름 → distinct #18 후보 = PH-1 등재.** (PH-1)

### 0.2 ★마운팅/거치(벽걸이/탁상)·전면(유리/아크릴) = 라이브 옵션 미노출 = unobserved (날조 금지) — directive 최대 관전 2
액자의 마운팅(벽걸이/탁상)·전면 보호재(유리/아크릴)·후면 받침은 도메인 일반지식으로는 액자의 핵심 축이나, **라이브에서 옵션 select로 미노출**(`[live:SSR-negative]` 11상품 전부 Vue client-render):
- 마케팅/추천 카피에 "벽걸이"(5~14회)·"탁상"(9~21회)·"고리"(6회)·"와이어"(2회)·"유리"(3회) 키워드 등장하나, **11상품 거의 동일 카운트 = 공유 카테고리 nav 블록**(상품 고유 옵션 아님).
- 실제 거치/전면 select는 client-render 미캡처.

→ base_data_tag = **unobserved**(부속물#8 또는 공정#14 후보이나 미관측). **★날조 금지: 마운팅/거치/전면유리는 도메인상 부자재(받침=AC 등신대 SUB_MTR 동형)·공정(걸이타공) 후보로 강하게 추정되나, 라이브 옵션 미관측이므로 추정 축으로 기록하지 않고 unobserved + PH-2 등재.** distinct #18(마운팅 축) 여부 = 옵션 미관측으로 **판정 불가** → 아키텍트 회부.

### 0.3 ★사진인화 매체 = 인화지 × 마감(유광/반광/스노우/홀로그램)을 한 paper select에 합성 (자재 surface-finish facet)
포토보드(PHPTPRM)의 용지 select가 사진인화 매체 모델의 정점(`[live:SSR-legacy]` PHPTPRM select[0] 실측):

| 용지 옵션(리터럴) | 매체(인화지) | 마감 |
|-------------------|--------------|------|
| 유광(Glossy)_캐논전용지 | 캐논전용지 | 유광(Glossy) |
| 반광(Luster)_캐논전용지 | 캐논전용지 | 반광(Luster) |
| 스노우 | 스노우지 | (무광계) |
| [재고부족]홀로그램 무지개 인화지 | 홀로그램 인화지 | 특수(무지개) |

→ **인화지 종류(캐논전용지/스노우/홀로그램) × 마감(유광/반광)이 한 paper select에 합성** — 별 "마감 축"이 아니라 용지(자재) 옵션의 한 값. base_data_tag = **자재(인화지 매체) + 마감(surface-finish facet)**. **★AC 글리터/거울/자개 = 자재 surface-finish §0.2·BN 코팅(유광/무광) facet과 동형 — 마감은 항상 자재 또는 후가공의 facet, distinct 축 아님.** "[재고부족]" 라벨은 **재고/주문가능 제약**(constraint) — opt 라벨에 인라인. (PH-3 등재: 인화지=자재 vs 마감=공정 경계)

### 0.4 ★보드/판·포토북·포토굿즈 = 기존 카테고리 동형 (PR 포스터·PR 책자·GS 굿즈)
나머지 3군은 기존 카테고리 모델을 재사용(`[live:SSR-legacy]` 실측):
- **보드/판(PHPTPRM 포토보드)**: cate=디지털인쇄>홍보물>**포스터**·pdt_gbn=**edicus_item**·price_gbn=tmpl_price·koi=Y/pdf=Y. skin_view = paper(Y)+size(Y)+subject(Y)+quantity(건수+매수). = **포스터를 보드에 인쇄**(PR 포스터 동형). 보드 패널 자체(두께/마운팅) select 미노출.
- **포토북(PHBKMYB)**: cate=성수동사진관/**포토북**·pdt_gbn=digital_item·price_gbn=**digital_price**·koi=N/pdf=Y. 축 = 수량(매수)·사이즈(8X6/8X8/10X8/10X10/12X12 정사각계)·**단면/양면**. = **사진책 제본**(`[xref:PR]` 책자 동형 — 면수/제본은 client-render 미노출).
- **포토굿즈(PHPODFT 화분)**: cate=디지털인쇄>컵&홀더·pdt_gbn=digital_item·price_gbn=tmpl_price·koi=N/pdf=Y. 축 = **전사지**(transfer paper·자재)·단면·80x95mm·건수+수량. = **전사인쇄 완제굿즈**(GS 동형).

→ base_data_tag = 보드/북/굿즈 모두 **기존 카테고리 모델 재사용** — PH 고유 신규 축 아님.

---

## 1. 대표상품 ① PHPTPRM 포토 보드 (보드/판 — 포스터 동형·풀 SSR 실측)

```
product: PHPTPRM 포토 보드 (PH / 보드·판)
source: [live:SSR-legacy] /ko/product/item/PH/PHPTPRM (2026-06-17·product_option={…} JS 객체 + 7 select 실측)
flags: pdt_gbn=edicus_item · price_gbn=tmpl_price · order_yn=Y · it_g_price="5,800~" · item_unit_name=개 · it_g_base_quant=1
       cate=디지털인쇄>홍보물>포스터 · useKoiEditor=Y · useRPEditor=N · usePDF=Y · usePDFordCnt=Y · isUseGarage=N
       skinInfo: paperSelect(Y·"용지") · sizeSelect(Y·"규격(mm)") · subjectGroup(Y·"주문제목") · quantityGroup(Y·orderCnt="디자인 수(건수)"/printCnt="수량") · pageDirection(N) · dosuSelect(N) · pcs(N) · price_table_yn=N
axes:
  - axis: 용지 (paper = 인화 매체 + 마감)
    choices: [유광(Glossy)_캐논전용지, 반광(Luster)_캐논전용지, 스노우, [재고부족]홀로그램 무지개 인화지]
    cascade: 용지→사이즈 후보 갱신 추정(select[1][2] 빈값=client cascade·unobserved 상세)
    price_flag: affects (tmpl_price 매체별 단가 추정·unobserved 상세)
    base_data_tag: 자재 (인화지 매체) + 마감(surface-finish facet·유광/반광)
    note: 인화지×마감 합성 select. "[재고부족]"=재고 constraint 인라인. §0.3
  - axis: 규격 (size, mm)
    choices: [A6(115X158), A5(158X220), B5(186X260), A4(220X307), Original(260X370)]
    cascade: none(관측)
    price_flag: affects (사이즈별 면적 단가 추정)
    base_data_tag: 기초코드(사이즈 enum) / 사이즈
    note: 보드 규격 5종 이산. A6~A4 표준규격 + Original.
  - axis: 디자인 수 (건수, orderCnt)
    choices: [건수직접입력, 1~50(51개)]
    cascade: none
    price_flag: affects (디자인 건수)
    base_data_tag: 옵션 (수량축·디자인 건수)
    note: TP/PR 동형 — koi 에디터 디자인 건수 축.
  - axis: 수량 (매수, printCnt)
    choices: [수량 직접 입력, 1~10…]
    cascade: none
    price_flag: affects (인쇄 매수)
    base_data_tag: 옵션 (수량축·인쇄매수)
    note: 건수×매수 이중 수량(TP/PR 동형).
  - axis: 주문 제목 (subject)
    choices: (자유입력)
    cascade: none
    price_flag: none
    base_data_tag: 옵션 (주문 메타·비가격)
    note: subjectGroup view_yn=Y.
unobserved: 보드 패널 두께/재질/마운팅 select(client cascade·미노출) · 용지→사이즈 cascade 상세
```

## 2. 대표상품 ② 사진인화 (PHPTEDT 일반 사진인화 — SSR-negative + 매체모델은 PHPTPRM로 대표)

```
product: PHPTEDT 일반 사진인화 (PH / 사진인화)
source: [live:SSR-negative] /ko/product/item/PH/PHPTEDT (2026-06-17·HTTP 200·~266KB·Vue client-render·product_option 미노출)
        [live:catalog] category=PH·name="일반 사진인화"
flags: pdt_gbn=unobserved · price_gbn=unobserved · koi/pdf=unobserved (Vue 미노출)
axes:
  - axis: 출력판형/임포지션 (km1_size·전역 스캐폴드)
    choices: [750x585, 720x520, 636x469(국2절), 545x393(46 4절)]
    cascade: unobserved
    price_flag: unknown
    base_data_tag: (제외 — 상품 옵션 아님)
    note: ★전역 km1_size 숨김 에디터 select(첫 옵션 HTML 주석처리). 전 PH 스켈레톤 공통 노출 = 임포지션 출력판형 스캐폴드, 사진인화 사이즈 옵션 아님. 신규 Vue 상품 SSR-negative 공통 아티팩트.
  - axis: 인화지 종류 (media)
    choices: unobserved (PHPTPRM 매체모델로 대표 §0.3 — 캐논전용지/스노우/홀로그램 추정)
    base_data_tag: 자재 (인화지 매체)
    note: PHPTEDT 자체 옵션 client-render 미노출. 매체 축 존재는 동군 PHPTPRM로 확정.
  - axis: 사이즈 (인화 규격)
    choices: unobserved
    base_data_tag: 기초코드(사이즈) / 사이즈
  - axis: 마감 (유광/반광)
    choices: unobserved (용지 select에 합성 추정 §0.3)
    base_data_tag: 마감(surface-finish facet)
  - axis: 매수 (수량)
    choices: unobserved
    base_data_tag: 옵션(수량)
unobserved: PHPTEDT 옵션 전체(인화지/사이즈/마감/매수/현상)는 Vue client-render — SSR 미캡처. 매체모델만 PHPTPRM(동군 레거시)로 대표.
```
> 보조군 동형(`[live:SSR-negative]` 확인): PHPTSHP(모양 사진인화·형상 완칼 추정)·PHPRDFT(증명사진600)·PHPKDFT(포켓사진600)·PHPRFRM(내컷네컷)·PHPTDFT(심플프레임)·PHPTBKG(Design). 전부 Vue client-render = 옵션 SSR-negative. 매수단위(증명사진600·포켓사진600=600매 set)는 상품명에 인코딩.

## 3. 대표상품 ③ PHFRDIA 디아섹 아크릴 액자 (액자 — SSR-negative·프레임재질=pdtCode 분기)

```
product: PHFRDIA 디아섹 아크릴 액자 (PH / 액자)
source: [live:SSR-negative] /ko/product/item/PH/PHFRDIA (2026-06-17·HTTP 200·~270KB·Vue client-render·product_option 미노출·옵션 select 미노출)
        [live:catalog] category=PH·name="디아섹 아크릴 액자"
flags: pdt_gbn=unobserved · price_gbn=unobserved (Vue 미노출)
axes:
  - axis: 프레임 재질 (frame material)
    choices: [디아섹 아크릴] (이 상품) — 카테고리 전체 스펙트럼: 한나무/애쉬원목/원목/알루미늄/종이/아크릴/디아섹 (각=별 pdtCode §0.1)
    cascade: unobserved (한 상품 내 재질 select 미노출 — 재질=pdtCode 분기)
    price_flag: unknown
    base_data_tag: 자재(프레임 재질) + 카테고리(재질특화 상품)
    note: ★프레임 재질이 상품을 가름(AC 소재variant 동형). 디아섹=아크릴 마운팅 인화. §0.1
  - axis: 사이즈 (액자 규격)
    choices: unobserved
    base_data_tag: 기초코드(사이즈) / 사이즈
    note: client-render 미노출.
  - axis: 마운팅/거치 (벽걸이/탁상)
    choices: unobserved (마케팅 카피에 벽걸이/탁상/고리/와이어 등장하나 공유 nav 블록·옵션 select 아님)
    base_data_tag: unobserved (부자재#8 또는 공정#14 후보·미관측)
    note: ★날조 금지 — 도메인상 핵심 축이나 라이브 옵션 미노출. §0.2 PH-2
  - axis: 전면 보호재 (유리/아크릴)
    choices: unobserved
    base_data_tag: unobserved (자재 후보·미관측)
    note: §0.2 PH-2
unobserved: 디아섹 액자 옵션 전체(사이즈/마운팅/거치/전면/후면받침)는 Vue client-render — SSR 미캡처. 프레임재질=pdtCode 분기만 catalog로 확정.
```
> 보조군 동형(`[live:SSR-negative]` 11액자 전부): 원목계(PHFRHAN/PHFRHDU/PHFRWOD/PHFRASB/PHFRASH/PHFRASD)·알루미늄(PHFRALU)·종이(PHFRPAP)·아크릴(PHFRACR)·디아섹(PHFRDIA)·멀티(PHFRMUL)·이벤트(PHFRFIR 첫돌). 듀얼(PHFRHDU)·양면형(PHFRASD)·멀티(PHFRMUL)는 **다면(multi-aperture)** variant — 형태가공#14 후보이나 옵션 미관측.

---

## 4. PH 30상품 횡단 base-data 태깅 (그룹별)

> 대표 3상품(PHPTPRM·PHPTEDT·PHFRDIA) 외 27상품 — 동형 군별 묶음 태깅(답습 전수수집 회피·라이브 SSR 실측 등급 표기).

### 그룹 A — 액자류 PHFR* (11상품·전부 SSR-negative·프레임재질=pdtCode 분기)
PHFRHAN·PHFRHDU·PHFRASB·PHFRASH·PHFRASD·PHFRWOD·PHFRALU·PHFRPAP·PHFRACR·PHFRDIA·PHFRMUL·PHFRFIR
- 공통 = 완제 프레임(자재=재질 pdtCode 분기) + 인화물 끼움. 옵션(사이즈/마운팅/거치/전면) = `[live:SSR-negative]` 미관측.
- base_data_tag = 자재(프레임 재질) + 카테고리(재질특화 상품) + [unobserved: 마운팅/거치/전면/사이즈]
- 단서: 듀얼/양면형/멀티 = 다면 variant(형태#14 후보·미관측)·첫돌 = 이벤트 SKU.

### 그룹 B — 사진인화류 PHPT*/PHPR*/PHPK* (8상품·SSR-negative, 매체모델은 PHPTPRM 대표)
PHPTEDT(일반)·PHPTSHP(모양)·PHPTDFT(심플프레임)·PHPTBKG(Design)·PHPRDFT(증명사진600)·PHPKDFT(포켓사진600)·PHPRFRM(내컷네컷)
- 공통 = 인화지(자재) × 사이즈 × 마감(유광/반광 facet) × 매수. 전부 Vue client-render = 옵션 SSR-negative.
- base_data_tag = 자재(인화지) + 마감(surface-finish facet) + 기초코드(사이즈) + 옵션(매수)
- 단서: 증명사진600/포켓사진600 = 600매 set 단위(매수=상품명 인코딩)·내컷네컷=4컷 프레임·모양=형상 완칼(형태#14 후보).

### 그룹 C — 보드/판 PHPTPRM·PHST* (4상품·일부 SSR-legacy)
PHPTPRM(포토보드·SSR-legacy 풀)·PHSTPAN(판스티커·SSR-negative)·PHSTNOP(판스티커-노브랜드4sheets)·PHSTSQP(판스티커-스퀘어5sheets)
- 포토보드 = 포스터 동형(§1). 판스티커 = ST 점착 동형(sheets set 단위·노브랜드4/스퀘어5 = sheet 수 인코딩).
- base_data_tag = 자재(용지/점착) + 기초코드(사이즈) + 옵션(수량/sheets) + 템플릿(koi 에디터)

### 그룹 D — 포토북 PHBK* (5상품·일부 SSR-legacy)
PHBKMYB(내 파일 포토북·SSR-legacy 풀)·PHBKBKS(소프트커버)·PHBKSMP(하드커버 이미지랩)·PHBKPRM(하드커버 프리미엄)·PHBKSTA(북클릿 포토A5)
- 공통 = 사진책 제본(`[xref:PR]` 책자 동형). PHBKMYB 실측 = 수량×사이즈(정사각계)×단/양면. 커버(소프트/하드/프리미엄)=제본/커버 variant=pdtCode 분기.
- base_data_tag = 자재(표지/내지) + 공정(제본·소프트/하드) + 기초코드(사이즈) + 옵션(면수·단/양면·매수)
- 단서: 면수/제본방식은 client-render 미노출(PHBKMYB 양면만 실측).

### 그룹 E — 포토굿즈 PHMG/PHPO (2상품·SSR-legacy 부분)
PHMGDFT(포토 머그컵)·PHPODFT(포토 화분·SSR-legacy 풀)
- 공통 = 전사인쇄 완제굿즈(GS 동형). PHPODFT 실측 = 전사지(자재)·단면·80x95mm·건수+수량.
- base_data_tag = 자재(본체 머그/화분 + 전사지) + 공정(전사인쇄) + 옵션(수량)
- ★주의: pdtCode 접두 PH이나 본질=굿즈(머그/화분) — "코드접두≠카테고리 본질"(GS GSTTDTM 코스터 동형).

---

## 5. directive 최대 관전 1차 판정 — 액자 프레임/마운팅·사진인화 매체 = distinct #18인가 facet인가

| 후보 축 | 인코딩 위치 | 동형 기존 축 | 1차 판정 | 근거 |
|---------|-------------|--------------|----------|------|
| **프레임 재질**(한나무/애쉬/원목/알루미늄/종이/아크릴/디아섹) | pdtCode 분기(상품 가름) | 자재#1 variant(AC 소재·ST 점착 spectrum) | **facet (자재#1)** | §0.1 — AC 글리터/거울/자개=pdtCode 분기와 완전 동형 |
| **사진인화 매체**(캐논전용지/스노우/홀로그램) | paper select 값 | 자재#1(용지) | **facet (자재#1)** | §0.3 — PHPTPRM 실측, 용지=자재 |
| **마감**(유광/반광/스노우) | paper select에 합성 | BN 코팅 facet·AC surface-finish | **facet (자재 또는 후가공)** | §0.3 — 별 마감 축 아님, 용지에 합성 |
| **마운팅/거치**(벽걸이/탁상) | 라이브 옵션 미노출 | (AC 등신대 받침 SUB_MTR 후보) | **판정 불가 (unobserved)** | §0.2 — 옵션 SSR-negative, 추정 금지 → PH-2 |
| **전면 보호재**(유리/아크릴) | 라이브 옵션 미노출 | (자재 후보) | **판정 불가 (unobserved)** | §0.2 → PH-2 |
| **완제품 액자 그릇**(인쇄물을 끼우는 빈 프레임) | pdtCode(완제 SKU) | GS 완제SKU·AC 완제 | **distinct #18 후보(약) — 1차 예측 NO** | PH-1 — 옵션 미관측으로 facet/distinct 미확정 |

**★1차 예측: distinct 신규 축 #18 = NO(facet으로 흡수 우세).**
- 프레임 재질·사진인화 매체·마감 = 전부 **자재#1의 facet**(variant/surface-finish) — 기존 17축으로 흡수.
- 마운팅/거치·전면유리 = distinct #18 가능성의 **유일한 후보**이나 **라이브 옵션 미관측**(SSR-negative)으로 판정 불가 → 아키텍트가 추가 라이브 캡처(chrome MCP client-render 대기) 또는 후니 도메인 권위로 확정 필요(PH-1/PH-2).
- **17축 안정성 = 관측된 모든 PH 옵션은 기존 축으로 흡수 가능 → 안정. 단 "완제품 액자 = 인쇄물을 끼우는 그릇"이라는 의미는 AC(직접인쇄)·GS(완제굿즈)와 미묘하게 다른 "사후조립 완제 그릇" 성격 → 아키텍트 회부.**

---

## Ambiguous fragments (아키텍트 회부)

> PH 카테고리 모호 fragment. 기존 deepcheck H-넘버와 혼동 회피 위해 **PH-넘버** 사용.

### PH-1 — "완제품 액자 = 인쇄물을 끼우는 빈 프레임"이 distinct #18(완제 그릇 축)인가, 자재#1 facet인가
- 액자(PHFR* 11종)는 AC(아크릴 본체에 직접 인쇄)·GS(완제굿즈)와 달리 **인화물을 사후에 끼우는 빈 프레임(완제품 그릇)**. 프레임 재질은 자재#1 variant로 흡수되나(§0.1), "인쇄물 + 별도 프레임 조립"이라는 **2-파트 완제 구조**는 단일 자재/완제SKU와 다름.
- 회부 = ① 자재#1 facet(프레임=특수 부자재) ② 템플릿#(완제 프레임 SKU + 인화물 결합) ③ distinct #18(완제 그릇/마운팅 축) 중 어느 버킷? 라이브 옵션 미관측이 결정적 제약 — chrome MCP client-render 재캡처 권장.

### PH-2 — 마운팅/거치(벽걸이/탁상)·전면 보호재(유리/아크릴)·후면 받침 = 미관측 (옵션 SSR-negative)
- 도메인상 액자의 핵심 축(거치 방식·전면 보호재)이나 **라이브 옵션 select 미노출**(11액자 전부 Vue client-render). 마케팅 카피 키워드는 공유 nav 블록(상품 고유 옵션 아님).
- 회부 = 추정 축(부자재#8 받침 BUNDLE / 공정#14 걸이타공 / 자재 전면재)으로 기록하지 않고 **unobserved 정직 표기**. 아키텍트가 ① chrome MCP client-render 재캡처 ② 후니 도메인 권위로 확정. distinct #18 판정의 결정적 미싱데이터.

### PH-3 — 인화지(자재) vs 마감(공정) 경계 — 용지 select에 합성된 "유광/반광"
- PHPTPRM 용지 select = "유광(Glossy)_캐논전용지"처럼 **인화지(자재) + 마감(유광/반광)을 한 값에 합성**. 마감을 ① 자재 surface-finish facet(현재 태깅) ② 별 공정#(코팅/라미 동형) 중 어디로 볼지 경계.
- 동형 = BN 코팅(유광/무광 = 후가공 공정)·AC 글리터/거울(자재 surface). 사진인화 "마감"은 인화지 자체 특성(매체 종속)이므로 자재 facet 우세하나, 합성 인코딩이 후니 정규화 시 분리 필요할 수 있음 → 아키텍트 판정.

### PH-4 — set/sheets 단위 수량(600매·4sheets·5sheets)이 수량 옵션인가 템플릿 SKU 단위인가
- 증명사진600/포켓사진600(=600매 set)·판스티커-노브랜드(4sheets)·스퀘어(5sheets) = **매수/sheets 묶음이 상품명에 인코딩**(고정 set 단위). 한 주문 = 1 set.
- 회부 = ① 옵션(수량 = set 배수) ② 템플릿#(고정 set = 완제 SKU 단위·GS 완제 동형) 경계. GS 텀블러(it_g_base_quant=1·완제)와 동형 — set 단위 = base_quant 인코딩 후보.

### PH-5 — PHMG/PHPO(머그·화분)가 PH 카테고리인가 GS 굿즈인가 (코드접두≠카테고리 본질)
- PHMGDFT(머그)·PHPODFT(화분)은 category=PH이나 본질=전사인쇄 완제굿즈(GS GSTTDTM 코스터·GS 텀블러 동형). cate=디지털인쇄>컵&홀더(PHPODFT 실측).
- 회부 = 카테고리#(category) 다중분류 — "출력매체(사진굿즈) vs 물성(컵&홀더)" 어느 축으로? GS 횡단 다중분류 패턴과 동형. RedPrinting은 PH로 묶음(사진 출력 매체 기준).

---

## 0.5 client-render 재캡처 (gstack browse, 2026-06-17) — 블로커 해소

> 목적 = PH 고유 블로커(액자/사진인화 SSR-negative) 해소를 위한 Vue client-render 재캡처.
> 대상 옵션 = ① 마운팅/거치(벽걸이/탁상) ② 전면 보호재(유리/아크릴) ③ 후면 받침. distinct 축 #18(마운팅 축) 판정의 결정적 미싱데이터.
> **도구 = `gstack browse`(하네스 헤드리스 chromium, `.claude/skills/gstack/browse/dist/browse`).** `claude-in-chrome` MCP 서버는 미등록이나 gstack browse 바이너리가 빌드되어 있어 client-render 실측 성공. `[live:client-render]` 출처.

### 결과: 미싱데이터 OBSERVED — PH-2 마운팅/거치 RESOLVED·전면 보호재는 별도 옵션축 미관측

Vue client-render 후(networkidle 대기) 옵션 패널이 실제로 노출됨. SSR(레거시 GET)에서 미노출이던 옵션이 client-render에서 드러남 = §0.2 "SSR-negative → unobserved" 진단의 원인(Vue 지연 렌더) 확정. 라이브 읽기전용(옵션 토글만·주문/폼제출 0).

### ① PHFRDIA 디아섹 액자 — 마운팅/거치 캐스케이드 OBSERVED `[live:client-render]`
옵션 구조(주문 폼 `product_form`은 SSR fields=[]이나 client-render로 Vue custom combobox 노출 — `<select>` 아님, `forms` 미포착·snapshot accessibility tree로 실측):

| 축 | 위젯 | 값(리터럴) |
|----|------|-----------|
| **거치 방식** | 버튼 토글 | **탁상용 / 벽걸이** ← §0.2 미싱데이터 실재 |
| 거치×마감 합성 | combobox | 탁상용: 유광 / 무반사 / 자작나무 무광 / 자작나무 유광 (4) · 벽걸이: 동일 4 마감 |
| 완제 SKU(거치+마감+사이즈) | combobox | 탁상용유광 127X177·152X203·203X254 (3) → 벽걸이유광 297X420 ~ 1000X1000 (15) |
| 작업/재단 치수 | spinbutton(disabled) | 127·177(작업) / 131·181(재단) 자동표시 |
| 수량 | combobox | 1~10·50·100 |
| 디자인 입력 | 버튼 | PDF / 에디터 / 편집하기(#16 디자인입력채널) |

- **★거치 방식(탁상용/벽걸이)이 캐스케이드 상위 축** — 토글 시 마감 라벨 prefix·사이즈 풀이 통째로 교체(탁상용=소형 3종, 벽걸이=대형 15종). 즉 거치방식 → 마감 → 완제SKU사이즈 → 수량 캐스케이드.
- **전면 보호재(유리/아크릴) = 별도 옵션 select 미관측** — 마감 combobox는 표면처리(유광/무반사/자작나무)만. 디아섹은 전면재가 상품 내재(아크릴 마운팅) → 전면 보호재는 별도 축 아님(자재 내재/facet). **후면 받침도 별도 옵션 미관측.**
- 증거 스크린샷: `/tmp/ph_phfrdia_options.png`(옵션 패널 + "사이즈" 섹션 탁상용/벽걸이용 탭 + 사이즈 표).

### ② PHPTEDT 사진인화(편집형) — 인화지×마감 합성 + 형태축 OBSERVED `[live:client-render]`
| 축 | 위젯 | 값 |
|----|------|-----|
| **형태(비율)** | 버튼 토글 | **일반 / 정사각 / 파노라마** |
| 자재(인화지×마감) | combobox | 인화용지(반광-러스터) / 인화용지(유광) ← §0.3 합성 입증 |
| 사이즈 | combobox | 3x5(89x127) ~ 8.27x11.7(210x297 A4) 8종 |
| 치수 | spinbutton(disabled) | 89·127(작업) / 91·129(재단) 자동 |

### ③ PHPRDFT 사진인화 — 재고 제약 OBSERVED `[live:client-render]`
- 자재 combobox: 인화용지(유광) / **`[재고부족]` 홀로그램 무지개 인화지(disabled)** ← §0.3 "[재고부족] = 재고/주문가능 constraint" + 홀로그램 매체 입증. disabled 속성으로 주문불가 인코딩.
- 수량 combobox: 1·5·10·15·20·25·30·35·40·45·50·100.

### ④ PHFRWOD 원목 / PHFRALU 알루미늄 — "스타일" 진입형(옵션 미펼침)
- 두 상품 모두 옵션 영역에 `[button] "스타일"`만 노출(combobox는 family_site nav만). 디아섹과 다른 옵션 UI(에디터/스타일 진입형 추정) — "스타일" 클릭 후에도 combobox 미펼침. **추가 인터랙션(에디터 진입 등) 필요분은 이번 미확보** = `unobserved`(원목/알루미늄 마운팅 옵션은 디아섹으로 패턴 입증됨, 개별 미확인은 정직 표기).

### PH-1 / PH-2 verdict (재캡처 후)

| 회부 | 재캡처 후 상태 | distinct #18 판정 |
|------|----------------|-------------------|
| **PH-1** (완제 프레임 = distinct #18인가 facet/variant인가) | **OBSERVED·1차 예측 강화** — 거치+마감+사이즈가 완제 SKU(combobox) 1개에 인코딩·거치방식이 캐스케이드 상위 차원. AC 두께/소재 variant·GS 완제SKU와 동형 구조 실측. → **facet/variant 흡수 우세**(최종 architect). | **NO 우세** (facet/variant) |
| **PH-2** (마운팅/거치·전면 보호재·후면 받침) | **거치(탁상용/벽걸이) = RESOLVED·OBSERVED**(실재 캐스케이드 축). 전면 보호재·후면 받침 = **별도 옵션축 미관측**(마감 facet + 전면재 상품 내재). | 거치=실재하나 옵션 차원으로 구현 → **distinct 신규축 NO 우세** |

**verdict 요약: distinct 축 #18(마운팅 축) = 마운팅/거치가 OBSERVED(실재)되었으나, 별도 신규 메타모델 축이 아니라 옵션 캐스케이드 상위 차원(거치방식 → 완제 SKU variant)으로 구현됨. 1차 예측(distinct 0·facet/variant 흡수)이 실측으로 강화.** 단 "거치방식"이라는 의미축이 후니 그릇(t_*)에 명시 차원으로 있는지는 **gap 분석 대상**(거치=옵션 캐스케이드 vs 완제 SKU variant 매핑). 최종 facet/distinct 판정은 metamodel-architect.

**남은 미관측(정직 표기, 추정 승격 0):** 원목/알루미늄 액자 개별 옵션(스타일 진입형 미펼침)·전면 보호재가 별도 옵션인 다른 액자(한나무/멀티 미캡처)·포토북(PHBK* 면수/제본 client-render 미캡처). 디아섹·사진인화 대표로 핵심 축은 확보 — 추가 캡처는 architect/gap이 필요 시 지시.
