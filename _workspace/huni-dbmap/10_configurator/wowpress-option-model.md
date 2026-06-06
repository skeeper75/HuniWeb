# WowPress 옵션 모델 분석 (굿즈/파우치 벤치마크)

> 목적: 후니 `t_mat_materials` 정규화 설계의 **참조 벤치마크**. WowPress가 색상/형상/사이즈/방향/도수/재질을
> 어떤 축으로, 어떤 입도(granularity)로 모델링하는지 증거 기반으로 기술한다.
> **후니 매핑 설계는 하지 않음** — "WowPress가 무엇을, 왜 그렇게 하는가"만 다룬다.
>
> - 분석 대상: `docs/wowpress/` 로컬 캡처 (2025-10-14, 326 products / 47 categories) + `wowpress-api-document.txt`
> - 굿즈/다꾸 카테고리: `cat-8b09c5dd`(굿즈 19), `cat-fa431f9c`(다꾸 4) + 어패럴 에코백·판촉물 표본
> - 모든 인용은 실제 JSON 경로 / API 문서 라인 / product ID 기반. 데이터에 없는 것은 "데이터 없음"으로 명시.

---

## 0. 데이터 소스 구조 (어디를 봐야 하나)

각 product JSON은 두 계층을 가진다:

| 계층 | 경로 | 성격 |
|------|------|------|
| 정규화(가공) 뷰 | `options.{orderQuantities, coverTypes, additionalOptions}`, `pricing` | 캡처 시 후처리된 단순화 뷰 (굿즈에선 대부분 비어있음) |
| **원본 payload (권위)** | `raw.prod_info.*` | WowPress API `/std/prod` 응답 원본 — **가장 풍부한 권위 소스** |

**핵심: 굿즈/파우치 옵션의 진짜 구조는 전부 `raw.prod_info` 안에 있다.** 정규화 `options.additionalOptions`는
표본 전수에서 `[]`(빈 배열)이었다(예: 40274 `options.additionalOptions == []` 인데 `raw.prod_info.optioninfo`엔
포장옵션 5종 존재). 따라서 본 분석은 `raw.prod_info`를 권위로 삼는다.

`raw.prod_info` 옵션 축(7개 array/object):

| prod_info 키 | API 문서 §  | 의미 | 굿즈에서 담는 것 |
|--------------|-----------|------|----------------|
| `ordqty`     | §8.5 수량 | 주문수량(택1 리스트 or 구간) | 100·200·…·1000 |
| `coverinfo`  | —         | 표지/내지 구분 컨테이너 (`covercd`로 다른 축을 스코프) | 굿즈=통합(covercd 0) 1개 |
| `sizeinfo`   | §7.1 규격 | **규격 = 사이즈 + 형상(융합)** | 90x50, 원형32, 하트57x51 |
| `paperinfo`  | §7.3 재질 | **재질 = 지종 + (제품색)** | PET, 캔버스(색별), NCR(색별) |
| `colorinfo`  | §7.2 도수 | **도수 = 인쇄 면/방향** | 단면칼라, 앞면/뒷면/앞면+뒷면 |
| `prsjobinfo` | §6.4 인쇄옵션 | 인쇄기·인쇄방식 프리셋 | 합판UV인쇄, 합판디지털인쇄 |
| `awkjobinfo` | §7.4 후가공 | 후가공(2단계 옵션) | 칼선(단순 N개) |
| `optioninfo` | §8.8 옵션 | **기타 가공/포장 옵션** (flat optlist) | 포장(쉬링크/수축…), 각인 |
| `prodaddinfo`| §7.5 부자재 | 부자재(거치대 등, 별도상품) | 굿즈 표본엔 거의 없음 |

---

## Q1. 옵션 분류 체계 (Option Taxonomy)

WowPress는 옵션을 **7개의 고정된 의미 축**으로 나눈다. 각 축은 product마다 켜지거나(populated) 꺼진다(null).
축마다 JSON path·실제 예시값:

### 1) 주문수량 (`ordqty`)
- path: `raw.prod_info.ordqty[].ordqtylist`
- 예 (40146): `ordqtylist: [100,200,…,1000]`, `ordqtymin: 100`, `ordqtymax: 1000`, `type: "select"`
- `ordqtyinterval`이 있으면 구간 입력, 없으면 택1 리스트.

### 2) 규격 (`sizeinfo`) — §7.1
- path: `raw.prod_info.sizeinfo[].sizelist[]`
- 필드: `sizeno`(주문키), `sizename`(표시명), `width`/`height`(mm), `non_standard`(0:규격 1:비규격), `cutsize`
- 예 (40146): `{sizeno:5460, sizename:"90x50", width:90, height:50}`
- **형상이 sizename에 융합** (Q2 참조): 40185 핀버튼 `sizename: "원형32" / "정사각37" / "하트57x51"`

### 3) 도수 (`colorinfo`) — §7.2
- path: `raw.prod_info.colorinfo[].pagelist[].colorlist[]`
- 필드: `colorno`(주문키), `colorname`, `type`(select=선택/radio=필수), `pdfpage`, `coloraddlist`(추가도수)
- 예 (40146): `{colorno:255, colorname:"단면 칼라4도"}`, `{colorno:1355, colorname:"단면 칼라+백색"}`, `type:"radio"`
- "도수"이지만 실제로는 **인쇄 면/방향**까지 담는다 (Q2): 40479 에코백 `colorlist: 앞면/뒷면/앞면+뒷면/인쇄없음`

### 4) 재질 (`paperinfo`) — §7.3
- path: `raw.prod_info.paperinfo[].paperlist[]`
- 필드: `paperno`(가격/주문키), `papername`(표시), `papergroup`(대표재질 표시), `pgram`(평량), `ncr`(NCR 예외구조)
- 예 (40146): `{paperno:21036, papergroup:"PET(투명)", papername:"PET(투명) 300μ", pgram:300}`
- **제품 색이 papername에 융합** (Q2): 40479 에코백 `papergroup:"캔버스"` 아래 papername=내추럴/블랙/핫핑크/라이트블루/타코이즈/네이비

### 5) 인쇄옵션 (`prsjobinfo`) — §6.4 "인쇄기및 인쇄옵션 정보 (map) array"
- path: `raw.prod_info.prsjobinfo[].prsjoblist[]`
- 필드: `jobpresetno`(프리셋), `jobno`(주문키), `jobname`, `req_color`(이 인쇄방식이 요구하는 도수)
- 예 (40146): `{jobpresetno:3130, jobname:"합판UV인쇄", jobno:3130, req_color:[칼라4도, 칼라+백색]}`
- 주문 시 `prsjob` array로 전송 (§6.4 Table7), 결과는 `prsjob`=인쇄주문옵션(§ line 943)

### 6) 후가공옵션 (`awkjobinfo`) — §7.4 / §6.4 "후가공 및 후가공 옵션정보(map) array"
- path: `raw.prod_info.awkjobinfo[].jobgrouplist[].awkjoblist[]`
- 그룹: `jobgroup`(후가공명, 예 "칼선"), `type`(select/checkbox=복수/radio=필수)
- 세부: `jobno`(주문키), `jobname`, **`namestep1`/`namestep2`**(2단계 하위옵션), `unit`
- 예 (40008 도무송): group "칼선", `{jobno:36110, jobname:"칼선 단순 10개", namestep1:"단순", namestep2:"10개"}` … 1~N개
- 주문 시 `awkjob` array로 전송. "필수 후가공"은 선택해야만 주문 가능(§7.4).

### 7) 옵션 (`optioninfo`) — §8.8 / 기타 가공·포장
- path: `raw.prod_info.optioninfo[].optlist[]`
- 필드: `optno`(주문키), `optname`, `type`(radio/checkbox)
- 예 (40274 마스킹테이프): `optlist:[수축포장+상/하단라벨, 쉬링크포장+상단라벨, …, 포장없음]`, `type:"radio"`
- **이 축이 후니의 "잡다한 굿즈 부가속성"(각인/포장/구성)에 가장 가까운 그릇**이다.

### coverinfo / coverTypes (축이 아니라 "스코프")
- path: `raw.prod_info.coverinfo[]` = `[{covercd, covername, pagelist}]`
- 책자류는 `표지/내지/간지`(40196, 40198), 굿즈는 `통합`(covercd 0) 1개.
- **중요**: size/paper/color/awkjob 모든 축이 `covercd`로 묶여 "표지의 재질 vs 내지의 재질"을 분리한다.
  굿즈는 covercd 0 단일이라 평면적이지만, 모델 자체는 cover-스코프 다축 구조다.

### additionalOptions / pricing (정규화 뷰)
- `options.additionalOptions`: 굿즈 표본 전수 `[]` — 굿즈 부가옵션은 여기 아니라 `raw.optioninfo`에 있음.
- `pricing.template`: 동적 견적 호출 디스크립터 (Q5). 정적 가격표 아님.

---

## Q2. 색상 / 형상 / 사이즈 / 방향 / 구수(count)는 어디에 사는가 — **핵심 발견**

WowPress는 이들을 **별도 신규 축으로 만들지 않는다.** 기존 7축 중 의미가 가까운 축에 **흡수(융합)** 시킨다.
굿즈/파우치 실제 사례로 보이는 매핑:

| 후니가 "옵션화"하려는 속성 | WowPress가 두는 곳 | 융합 방식 | 실제 증거 |
|---------------------------|--------------------|-----------|-----------|
| **사이즈** (가로L/S/M) | `sizeinfo.sizename` | 규격축 그대로 | 40479 에코백 `sizename: S(200x200)/M(360x370)/L(480x400)`, `width/height` 동반 |
| **형상** (원형/하트/정사각) | `sizeinfo.sizename` (사이즈와 **한 축**) | 형상+치수를 한 문자열로 | 40185 핀버튼 `원형32/원형44/원형58/원형75/정사각37/하트57x51` — 형상별 분리 행 아님, **(형상×치수) 1행=1 sizeno** |
| **제품 색** (빨강 머그/검정…) | `paperinfo.papername` (재질축) | 재질 한 항목으로, `papergroup`으로 묶음 | 40479 에코백 `papergroup:"캔버스"` → papername 내추럴/블랙/핫핑크/라이트블루/타코이즈/네이비 (색이 재질행) |
| **종이(굿즈) 색** | `paperinfo.papername` | 동일 | 40072 NCR `papergroup:"NCR"` → NCR(흰색)/노란색/분홍색/연두색/하늘색 53g |
| **인쇄 면/방향** (앞면/뒷면/단면/양면) | `colorinfo.colorname` (도수축) | 도수 항목으로 | 40479 에코백 `colorlist: 앞면/뒷면/앞면+뒷면/인쇄없음`, `type:radio`; 40146 단면칼라4도/단면칼라+백색 |
| **구수/개수 류** (1구/2구, 칼선 N개) | `awkjobinfo.namestep2` | 후가공 2단계 옵션 | 40008 `namestep1:"단순"` × `namestep2:"10개"…"20개"` (단계형) |
| **포장/구성** | `optioninfo.optname` | 기타옵션 flat | 40274 포장(쉬링크/수축/없음) |

### 가장 중요한 단일 결론
> **WowPress에서 "색상"은 대부분 별도 옵션이 아니라 `paperinfo`(재질)의 한 항목으로 표현된다** —
> 단, 그것은 **인쇄 잉크색이 아니라 "본체(블랭크) 색"** 이다(캔버스 색, NCR 종이색). 즉 WowPress의 재질=
> "물리적 블랭크(소재+색+질감)"라는 합성 SKU 개념이다.
> 반면 **인쇄에 관한 색/방향(단면·양면·앞뒤)은 `colorinfo`(도수)** 가 담당한다.
> **형상은 독립 축이 아니라 `sizeinfo`(규격)에 치수와 함께 융합**된다.

이 분리(블랭크색=재질 vs 인쇄도수=색축 vs 형상=규격축)가 후니의 핵심 의사결정 포인트다.
후니의 잘못 등록된 예시를 WowPress 렌즈로 분류하면:
- "검정"(만년스탬프 잉크색) → 잉크색이면 `colorinfo`(도수) 성격, 본체색이면 `paperinfo`(재질) 성격
- "원형"(말랑키링 형상) → `sizeinfo`(형상은 규격축에 융합)
- "가로L"(에코백 사이즈) → `sizeinfo` (에코백 40479가 정확히 같은 패턴)
- "11온스"(머그컵 용량) → WowPress엔 직접 대응 없음(머그 미취급). 구조상 `sizeinfo`(용량=규격) 또는 `paperinfo`(블랭크 사양) 후보
- "1구/2구"(키캡키링 구수) → `awkjobinfo.namestep2` 형(단계형 개수)에 가장 근접

---

## Q3. 재질(paperinfo) 모델 — 단일 축인가, 하위속성을 갖는가

### 일반 재질: 2계층 (대표재질 → 항목)
- `papergroup` = 대표재질(UI 그룹 라벨), `papername` = 개별 선택지(가격/주문키 `paperno`)
- `pgram` = 평량(있을 때만; 굿즈 블랭크는 null 흔함)
- **재질이 "지종 × (코팅/색/평량/포장)"의 합성 SKU**:
  - 40185 핀버튼: papergroup `유포지(유광)`/`유포지(무광)` × papername `…개별포장있음`/`…개별포장없음`
    → **코팅(질감)과 포장유무가 재질행에 함께 인코딩**됨 (재질이 부가속성을 흡수)
  - 40483 포토카드: `스노우지(무광코팅)/(유광코팅)/(레인보우코팅)` — 코팅이 재질행
- 즉 **WowPress 재질은 단일 select 축이지만, 행 자체가 합성**되어 sub-attribute를 펼치지 않는다.
  (사용자가 우려한 "과분할"을 WowPress는 행 합성으로 회피한다.)

### NCR 예외: 다겹(상지/중지/하지) — `paperinfo.ncr` (§6.6, line 1285-1418; §7.3 line 3163)
- 일반 주문 API는 **재질값 1개만** 받는다(line 1341). 그래서 NCR 다겹을 다음과 같이 우회 모델링:
  - `ncr.paper1list` = **상지** → 정식 `paperno`로 입력 (주문의 재질 슬롯)
  - `ncr.paper2list/paper3list/paper4list` = 중지/하지(/추가 중지) → `PaperItem:PaperName` 쌍
  - 제품 종류별 구성 (Table 11): 2매1조=상/하, 3매1조=상/중/하, 4매1조=상/중/중/하
  - 선택 결과를 파이프(`|`)로 직렬화해 `joboptmsg` 문자열로 전송:
    예 `"중지 지질:NCR노란색53g|하지 지질:NCR하늘색53g"` (line 1444)
  - 유효조합은 `ncr.req_joboptmsg`의 화이트리스트와 정확히 일치해야 함(line 3170)
- **시사점**: WowPress조차 "재질이 여러 겹/여러 부위를 갖는 합성 옵션"은 정규 축으로 못 담고
  **문자열 직렬화 + 화이트리스트**라는 우회책을 쓴다. 다축 옵션의 한계를 보여주는 사례.

---

## Q4. 제약/제한 (Constraints) 모델

WowPress는 제약을 **각 옵션 행에 붙은 `req_*`(필수조건) / `rst_*`(제약조건) 필드의 교차참조**로 모델링한다.
별도 "제약 테이블"이 아니라 **옵션 행 인라인 조건**이다. (§7.1~7.4)

### req_* (필수조건 = "이걸 고르면 저것이 반드시 필요")
| 필드 | 위치(축) | 의미 |
|------|----------|------|
| `req_width` / `req_height` | sizeinfo, paperinfo | 비규격 주문 시 가로/세로 min·max 범위 (§7.1: "비규격에서 min,max 이내만 인쇄") |
| `req_awkjob` | sizeinfo, paperinfo | 이 규격/재질이 **요구하는** 후가공 |
| `req_color` | prsjobinfo | 이 인쇄방식이 요구하는 도수 (40146: 합판UV인쇄 → 칼라4도/칼라+백색) |
| `req_prsjob` | colorinfo | 이 도수가 요구하는 인쇄방식 |
| `req_joboption`/`req_jobsize`/`req_jobqty`/`req_awkjob` | awkjobinfo | 후가공의 옵션/규격/수량/선행후가공 필수조건 |
| `ncr.req_joboptmsg` | paperinfo.ncr | NCR 중·하지 유효조합 화이트리스트 |

### rst_* (제약조건 = "이걸 고르면 저것이 불가")
| 필드 | 위치(축) | 의미 (§ 인용) |
|------|----------|------|
| `rst_ordqty` | sizeinfo, paperinfo | 규격/재질 관련 **주문수량 제약** |
| `rst_awkjob` | sizeinfo, paperinfo, awkjobinfo | 후가공 제약 (§7.1 예: 특정 규격에서 박-앞/박-뒤 불가; §7.3 빌리지200g·스코틀랜드220g에서 박 불가) |
| `rst_prsjob` | paperinfo | 재질 관련 인쇄옵션 제약 (40072 NCR → "독판UV인쇄"만 허용) |
| `rst_paper`/`rst_color`/`rst_size`/`rst_cutcnt`/`rst_jobqty` | awkjobinfo | 후가공에서의 재질/도수/규격/컷수/수량 제약 |
| `rst_opt` | colorinfo.colorlist | "선택된 칼라에 제한된 옵션이 선택됐는지 체크"(§ line 3174) |

### 제약 모델의 성격 (후니 CPQ excl-group과의 대비)
- WowPress 제약은 **양방향 인라인 교차참조**다(규격행이 후가공을 제약, 후가공행이 규격을 제약). 대칭적으로 양쪽에 기록.
- "주문 불가 옵션"은 **별도 플래그가 아니라 가격조회 실패로 표현**된다:
  §6.4 line 594 "제품가격이 조회 되지 않으면 주문이 불가능한 옵션". 즉 **제약 최종판정 = 가격엔진**.
  클라이언트의 req_/rst_는 UI 사전필터일 뿐, 진짜 게이트는 `/std/prod/jobcost`다.
- 후니의 excl-group(상호배타 묶음)과 비교하면: WowPress엔 "그룹" 개념이 약하고, **개별 행 간 페어 제약**이 기본.
  굿즈에서는 표본상 req_/rst_가 대부분 null(굿즈는 조합이 단순)이라 제약이 거의 없다.

---

## Q5. 가격 연동 (Pricing Linkage)

WowPress는 **정적 가격표가 없다.** 선택된 옵션 코드 묶음을 **동적 견적 엔진에 던져 가격을 받는다.**

- 엔드포인트: `/std/prod/jobcost` (`pricing.source`, §6.4 `https://api.wowpress.co.kr/api/v1/ord/cjson_jobcost`)
- 요청(§6.4 Table7): `{prodno, ordqty, ordcnt, ordtitle, prsjob[], awkjob[]}`
  - `prsjob[]` = 인쇄옵션 묶음(jobno, sizeno, paperno, colorno0, joboptmsg…)  ← 선택한 규격/재질/도수/인쇄방식
  - `awkjob[]` = 후가공 묶음(jobno…)
- 응답(§6.4 Table8): `ordcost_price/dc/sup/tax/bill`(원가·할인·공급가·부가세·청구가) + `prsjob`(인쇄주문옵션)·`awkjob`(후가공주문옵션) 에코
- 비선형: §6.4 line 589 "제품의 가격이 수량에 정확히 비례하지 않습니다" — 수량 구간/합판 효율 반영.

### 캡처된 두 가격 모드
1. **quote 모드**: 굿즈 전수 — `pricing.status: "requires-configuration"`, `quotes: []`. 옵션을 다 채워 호출해야 가격이 나옴.
   캡처 시점엔 가격 미확정(옵션 미선택).
2. **template 모드**: 6개 책자류만(40196 무선책자, 40198 중철책자 등) — `pricing.template`에 자동견적용 payload 스켈레톤
   (`{endpoint:/std/prod/jobcost, payload:{prodno, jobpresetno, ordqty:1, awkjob:[]}, notes:"jobpresetno 및 후가공 채운 뒤 호출"}`).
   여전히 동적 호출이며, 다만 자동견적 진입점을 제공.

### 옵션→가격 키 흐름
옵션 행이 들고 있는 `sizeno / paperno / colorno / jobno / optno`(주문키) 가 그대로 가격요청 payload에 들어가
가격엔진이 (제품×규격×재질×도수×인쇄방식×후가공×수량) 매트릭스에서 단가를 찾는다.
**가격은 옵션 코드 조합의 함수이며, 클라이언트는 가격 로직을 모른다(서버 권위).**

---

## Q6. 입도(Granularity) 교훈 — 언제 묶고 언제 쪼개는가

WowPress 실구조에서 도출되는 **자연 입도 규칙** (= 사용자의 "과분할 금지" 우려에 대한 직접 답):

### 규칙 A — "함께 고르는 물리 속성"은 한 행으로 합성 (over-split 회피)
- WowPress는 **형상+치수**를 한 행(sizename "하트57x51", 1 sizeno)으로, **지종+코팅+포장유무**를 한 재질행
  ("유포지(유광) 개별포장있음")으로 묶는다. 별도 축으로 폭발시키지 않는다.
- → 후니의 "금색 열쇠고리 / 빨간 머그 / 빨간 파우치"는 WowPress식이면 **(본체×색)을 한 재질/블랭크 행**으로
  합성하는 것이 자연스럽다(=`paperinfo` 패턴). 색을 독립 축으로 떼면 WowPress보다 더 잘게 쪼개는 것.

### 규칙 B — 축의 정체성으로 분류 (의미가 다르면 다른 축)
WowPress는 6개 의미 축을 **고정**하고 새 속성을 거기에 흡수한다. 새 축을 만들지 않는다:
- 물리 치수/형상 → 규격(sizeinfo)
- 물리 본체(소재·본체색·코팅·포장) → 재질(paperinfo)
- 인쇄 면/방향 → 도수(colorinfo)
- 인쇄 방식 → 인쇄옵션(prsjobinfo)
- 마감 가공(개수형) → 후가공(awkjobinfo, namestep1/2)
- 포장/기타 가공 → 옵션(optioninfo)
- → "색"을 무조건 "color 옵션"으로 보내지 말 것. **본체색은 재질, 잉크색/면은 도수.** 의미축이 결정.

### 규칙 C — 2단계까지만 (namestep1/namestep2), 그 이상은 직렬화
- 후가공만 `namestep1`/`namestep2` 2단계 펼침을 허용(예 단순×10개). 그 이상 다겹 조합(NCR 상중하지)은
  정규 축을 포기하고 **문자열 직렬화+화이트리스트**(`joboptmsg`/`req_joboptmsg`)로 처리.
- → 다축 곱집합이 깊어지면 정규 옵션 축으로 표현하려 무리하지 말고, **유효조합 화이트리스트**로 닫는 게
  WowPress의 실용적 선택. (관리 가능성 우선 = 사용자 우려와 정확히 일치)

### 규칙 D — cover-스코프로 "부위별 옵션"을 분리(굿즈는 안 씀)
- `covercd`(표지/내지/간지)로 같은 축을 부위별로 분기. 굿즈는 통합 1개라 평면적.
- → 후니 굿즈는 cover 분기 불요. 단축(통합) 평면 모델로 충분.

### 규칙 E — 제약은 "행 인라인 조건", 최종 판정은 가격엔진
- 조합 유효성을 별도 거대 제약테이블로 만들지 않고, 옵션 행에 `req_*`/`rst_*`를 붙이고
  **최종 게이트는 가격조회 성공 여부**로 둔다.
- → 후니가 모든 불가조합을 정적으로 enumerate하려 들 필요 없음. 행 페어 제약 + 가격엔진 판정 조합이 현실적.

### 한 줄 요약 (후니로 가져갈 지침)
> **새 축을 만들지 말고 6개 의미 축에 흡수하라. "함께 고르는 물리 속성"은 한 행으로 합성하라
> (형상+치수=규격, 소재+본체색+코팅=재질, 인쇄면=도수). 색을 무조건 분리하지 말 것 —
> 본체색은 재질행으로 묶는 것이 WowPress의 정답이고, 그게 곧 "과분할 금지"의 구체적 형태다.**

---

## 부록: 인용 product / 라인 인덱스 (재현용)

- 굿즈 단순형: `products/40146.json` 투명포토카드 (size 1·paper PET·color 2·UV인쇄)
- 사이즈축 굿즈: `products/40479.json` 에코백 (size S/M/L·paper 캔버스색6·color 앞뒤방향)
- 형상축 굿즈: `products/40185.json` 핀버튼 (size 원형/정사각/하트 융합)
- 후가공 굿즈: `products/40008.json` / `40149.json` 도무송 (awkjob 칼선 namestep)
- optioninfo: `products/40274.json` 마스킹테이프 (포장 optlist)
- 재질 합성: `products/40483.json` 포토카드 (코팅이 재질행)
- NCR 다겹: API doc line 1285-1418 (§6.6), 3163-3170 (§7.3) / `products/40072.json` NCR 색별
- 제약 스펙: §7.1 line 2773-2918, §7.2 2921-3020, §7.3 3023-3174, §7.4 3176-3473
- 가격: §6.4 line 584-958 / `pricing.template` = products 40196·40198·40200·40201·40433(+ index pricingStats: templated 6)
- coverinfo 다부위: products 40196(표지/내지/간지), 40198(표지/내지)
