# OT (상자·패키징) — RedPrinting 옵션 구성 역공학 (base-data 렌즈)

> **Phase 2 · 12번째 카테고리 · ★선별 모드 프로브** — "전개도/dieline(접지 구조)이 distinct #18 관리축인가" 적대 검증.
> 11 카테고리 종단 GO(BN·GS·TP·PR·ST·CL·AC·PD·PH·FS·NC)·메타모델 17축 재포화 상태에서 박스/패키징이라는 *평면 인쇄물에 없던 입체/전개 차원*을 가진 첫 상품군으로 #18 후보를 친다.

## 출처 범례
- `[live:detail]` = **2026-06-19 라이브 읽기전용 캡처**. playwright(`raw/widget_monitor/local/node_modules`)로 `/ko/product/item/OT/{code}/detail`(옵션 사양 페이지) 로드 → 렌더된 DOM의 select/사양 텍스트 + 네트워크 JSON 인터셉트. **주문/POST/폼제출 0건**(read-only goto + DOM read·"장바구니/주문하기" 버튼 클릭 안 함). 원본 = `_workspace/huni-rpmeta/categories/OT/captures/ot_cap_{code}.json`.
- `[live:landing]` = `/ko/landing/package`·`/ko/landing/clapper`(상품 진입 경로 발견·`{code}/detail` 링크 노출).
- `[live:catalog]` = `raw/widget_monitor/redprinting_catalog.json`(상품명·URL, 2026-06-19 확인).
- `[reuse:ST]`·`[reuse:PR]`·`[reuse:PD]` = 동형 비교용 기존 카테고리 reverse(칼선/도무송·인쇄물 사이즈·봉제구조).
- `[metamodel]` = `_workspace/huni-rpmeta/02_metamodel/metamodel-dictionary.md` 17축 사전.

## §0. 캡처 메커니즘 — OT는 NC와 다른 진입 구조 (중요)
- **★OT `/product/item/OT/{code}` = 상품 소개/랜딩 페이지(옵션 위젯 없음)**. NC/PH가 성공한 `get_digital_product_info` infoCall이 **0건**(`[live:detail]` 전 상품 `infoCallCount=0`). OT 옵션 위젯은 **`/{code}/detail` 경로의 레거시 SSR select 기반 폼**으로 별도 존재(NC의 Vue infoCall과 다른 구식 위젯).
- `/{code}/detail`은 `<select name=paper|paper_sub_select|sodu|size|number2_sel|number1_sel>` + 사양 표시 텍스트(제품/재단/작업 사이즈)를 렌더. **옵션 모델 = 평면 인쇄물과 동일 슬롯**(용지·평량·도수·사이즈·건수·수량).
- 에디터 자산: `makers.redprinting.net/v1/templates/{code}` + `/editor` = **koi 에디터 디자인 시안**(#16 TemplateAsset·박스 dieline 템플릿 다운로드). 박스 전개도 도안은 *주문옵션*이 아니라 *에디터가 로드하는 디자인 자산*.

---

## 대표 샘플 (7상품 중 5 캡처)
| pdtCode | 이름 | 구조 | 캡처 | 대표샘플? |
|---|---|---|---|---|
| OTPKCAK | 케이크상자 | 박스(뚜껑형) | `[live:detail]` | ✅ 박스 대표 |
| OTPKFLT | 납작상자 | 박스(날개형) | `[live:detail]` | ✅ 박스 |
| OTPKHMN | 반달상자 | 박스(반달 날개) | `[live:detail]` | ✅ 박스 |
| OTPKENV | 봉투상자 | 박스(봉투형·커스텀) | `[live:detail]` | ✅ 박스 |
| OTPKARP | 답례품상자 | 박스(소형) | `[live:detail]` | ◐ 보조 |
| OTPOCLP | 클래퍼 | 비박스(평면 손피켓·후가공 코팅) | `[live:detail]` | ✅ 비박스 대비 |
| OTCPHOL | 에어홀더 | 비박스(컵홀더) | 미캡처 | (구조 추정·OTPOCLP로 대비 충족) |

---

## 1. OTPKCAK 케이크상자 (박스 대표)
source: `_workspace/huni-rpmeta/categories/OT/captures/ot_cap_OTPKCAK.json` (`[live:detail]`·2026-06-19·infoCall 0·SSR select)

```
product: OTPKCAK 케이크상자 (OT)
표시 사양(읽기전용 텍스트): 제품사이즈 130 X 105mm (높이:80mm) / 재단사이즈 485 X 270mm / 작업사이즈 495 X 280mm
axes:
  - axis: 용지 (paper)
    choices: [BV]                        # 단일·박스 전용 판지(고정)
    cascade: paper_sub_select(평량) 연동
    price_flag: affects (인쇄비 베이스)
    base_data_tag: 자재
    note: 박스 본체 substrate. ST 점착지·PR 종이와 동형 자재축 facet. [live:detail]
  - axis: 평량 (paper_sub_select)
    choices: [350]                       # 350g 고정
    cascade: none
    price_flag: affects (두께=자재 단가)
    base_data_tag: 자재
    note: 두께/평량 = 자재 facet(메타모델 D-2 두께=자재). [live:detail]
  - axis: 도수 (sodu)
    choices: [단면]                       # 박스=단면 고정(CAK/FLT/HMN/ENV/ARP 전부 단면)
    cascade: none
    price_flag: affects (인쇄비)
    base_data_tag: 기초코드(도수 enum)
    note: 도수축 #6. 박스는 외면만 인쇄(단면). [live:detail]
  - axis: 사이즈 (size)  ★전개도 #18 핵심 증거
    choices: ["케익상자(소) (495 X 280)", "케익상자(중) (553 X 296)", "케익상자(대) (694 X 336)"]
    cascade: 선택 시 제품/재단/작업 사이즈 3종 표시 텍스트 갱신
    price_flag: affects (사이즈별 단가)
    base_data_tag: 사이즈 (+ 칼틀 = 공정#2 도무송 bundle)
    note: ★괄호 안 값(495 X 280) = "작업사이즈" = 전개도 펼친 평면 칼틀 치수. "제품사이즈 130X105 높이80"(3D 완성)은 *표시 텍스트일 뿐 선택 옵션 아님*. 박스 구조=size 프리셋 라벨("케익상자(소)")에 융합. PR/TP 카드형 형상=사이즈 1:1과 동형(ST 1:多 슬롯 분리 아님). [live:detail]
  - axis: 건수 (number2_sel)
    choices: [건수직접입력, 1..14...]      # 디자인 건수(에디터 디자인 종류 수)
    cascade: none
    price_flag: affects (디자인 종류 수 = 주문건수)
    base_data_tag: 옵션 (#16 입력채널 데이터바인딩 — 디자인 건수)
    note: GS 주문건수·NC 디자인 수와 동형. [live:detail]
  - axis: 수량 (number1_sel)
    choices: [수량 직접 입력, 10,30,50,100,150,200,500,1000,...,4000]
    cascade: "200매 초과 입력 시 500매 단위 선택만" 제약·"기본 올림"
    price_flag: affects (수량 = 가격 주체·10개부터·구간)
    base_data_tag: 옵션/가격(#10 수량)
    note: 수량 구간 + 올림/단위 제약(#5). [live:detail]
```
**전개도 #18 직접 증거:** 박스는 ① 표시 사양에 **"제품사이즈(3D 가로×세로×높이) / 재단사이즈 / 작업사이즈" 3종을 *텍스트로 병기***하나, ② 사용자가 **선택**하는 옵션은 size 프리셋(작업사이즈=전개도 평면) 1개뿐. 3D 치수는 *파생 표시값*(선택축 아님). 전개도(접지 구조)는 **에디터 dieline 템플릿**(`makers.../templates/OTPKCAK` = #16 TemplateAsset)으로만 제공 — 주문옵션 슬롯 부재.

---

## 2. OTPKFLT 납작상자 / 3. OTPKHMN 반달상자 / 4. OTPKENV 봉투상자 / 5. OTPKARP 답례품상자
source: `ot_cap_OTPKFLT/HMN/ENV/ARP.json` (`[live:detail]`·2026-06-19)

**전부 OTPKCAK와 *동일 옵션 슬롯*** (용지 BV·평량 350·도수 단면·size 프리셋·건수·수량). 차이는 **size 프리셋 라벨/치수뿐**:
| 상품 | size 프리셋 (작업사이즈) | 표시 3D 제품사이즈 | 박스 구조 단서 |
|---|---|---|---|
| OTPKFLT 납작상자 | 납작상자(소) 324X331 / (미니) 377X335 / (중) 384X431 | — | "날개" 1회(spec kw) |
| OTPKHMN 반달상자 | 반달상자(소) 195X245 / (중) 285X377 / (대) 390X470 | — | "날개" 1회 |
| OTPKENV 봉투상자 | 봉투상자(중) 435X332 / (대) 597X446 | 150X210mm (높이:55mm) | "뚜껑" 1회·"커스텀 제품" |
| OTPKARP 답례품상자 | 답례품상자(소) 425X272 | — | — |

- **★공통 패턴 입증:** 박스 형태 차이(케이크/납작/반달/봉투)는 **size 프리셋 라벨 + 작업사이즈(전개도 평면) 치수**로 전부 흡수. 뚜껑·날개·반달 같은 구조 변형은 *별 옵션축이 아니라 size 프리셋 정체(상품 pdtCode 분기)*에 융합. `[live:detail]`
- **★조립=고객 수작업:** OTPKCAK optBlock "**납작하게 접힌 상태로 배송됩니다. 상자로 만들어 사용해 주세요**" = RP는 평면(전개도+칼선+오시)까지만 생산, **입체 조립은 고객**. → #14 형태가공(RP가 평면→입체 *생성*)과 **반대**(RP가 입체화 안 함). 박스는 평면 인쇄물(접지 가공된 평면지)로 출고.

base-data 태깅(박스 5종 공통):
- 용지 BV / 평량 350 → **자재** (박스 판지 substrate·두께 facet)
- 도수 단면 → **기초코드**(도수 enum)
- size 프리셋(작업사이즈=전개도 평면) → **사이즈** + **공정**(도무송 칼틀·오시 접지선·spec kw "오시"·"칼선")
- 건수 → **옵션**(#16 디자인 건수) / 수량 → **옵션/가격**(#10)

---

## 6. OTPOCLP 클래퍼 (비박스 대비)
source: `ot_cap_OTPOCLP.json` (`[live:detail]`·2026-06-19)

```
product: OTPOCLP 클래퍼 (OT)  # 평면 손피켓(응원도구)·박스 아님
표시 사양: size "700X340 (710 X 350)" 단일
axes:
  - axis: 용지 (paper)
    choices: [아트지, 백색모조]            # 2종 선택(코팅 원치 않으면 백색모조)
    cascade: 아트지→코팅 가능 / 백색모조→코팅 없음 (구매가이드 TIP)
    price_flag: affects
    base_data_tag: 자재
    note: 용지가 후가공(코팅) 가용성 캐스케이드(#5). [live:detail]
  - axis: 평량 (paper_sub_select)
    choices: [300]
    base_data_tag: 자재
  - axis: 도수 (sodu)
    choices: [양면]                       # 클래퍼=양면(박스 단면과 대비)
    base_data_tag: 기초코드(도수)
  - axis: 사이즈 (size)
    choices: ["700X340 (710 X 350)"]      # 작업사이즈 710X350·칼틀 1종
    cascade: none
    base_data_tag: 사이즈 + 공정(칼선·도무송)
    note: spec kw "칼선"·"오시" — 손잡이 모양 도무송. [reuse:ST] 형상칼틀 동형. [live:detail]
  - axis: 후가공 코팅 (coating)  ★박스에 없는 축
    choices: [코팅 양면, 무광, 유광]        # ※단면코팅 선택 시 1p 기준
    cascade: 백색모조 선택 시 비활성(용지→코팅 #5)
    price_flag: affects (후가공 10,600 별도 합산 — 인쇄비 31,100 + 후가공 10,600 = 41,700)
    base_data_tag: 공정 (코팅 = 후가공 공정#2)
    note: ★가격 = 인쇄비 + 후가공 분리 합산(addtn_yn 동형). 박스는 후가공 없음. [live:detail]
  - axis: 건수/수량 (number2_sel/number1_sel)
    choices: 건수직접입력 / [10,30,50,100,150,200]  # 클래퍼=최대200(옵셋은 별 상품)
    cascade: "500개 이상은 [옵셋] 클래퍼에서 주문" (인쇄방식 분기→별 pdtCode)
    base_data_tag: 옵션/가격
    note: NC 옵셋 분기(#12)와 동형 — 부수 초과 시 옵셋 상품으로 라우팅. [live:detail]
```
- **클래퍼 = 평면 인쇄물 + 도무송 칼선 + 코팅 후가공.** 박스와 옵션 슬롯 거의 동일하되 **후가공(코팅) 축 추가**·도수 양면. 박스 특유 차원(전개도/접지) 전무 — 클래퍼는 ST/PR 손피켓류와 동형.

---

## §7. ★전개도/dieline #18 1차 예측 (승격 판정은 metamodel/validator 몫)

### 흡수 매핑 (4축이 박스 차원을 어떻게 담는가)
| 박스 특유 후보 차원 | 관측 증거 | 흡수 축 | 근거 |
|---|---|---|---|
| **3D 입체 치수(가로×세로×높이)** | "제품사이즈 130X105 (높이:80)" *표시 텍스트* | **사이즈#13 (파생 표시값)** | 선택 옵션 아님. 사용자는 size 프리셋(작업=전개도 평면)만 선택. 3D는 파생. |
| **전개도/dieline(접지 평면)** | size 괄호값 "작업사이즈 495X280" | **사이즈#13 + 공정#2(도무송 칼틀·오시 접지선)** | ST 칼선=공정#2 facet 판정과 동형. 전개도=칼틀의 박스 인스턴스. |
| **박스 형태(케이크/납작/반달/봉투/뚜껑/날개)** | size 프리셋 라벨 + pdtCode 분기 | **사이즈#13 프리셋 라벨 + 카테고리#7(상품 분기)** | PR/TP 카드형 형상=사이즈 1:1 동형. ST 1:多 shape_info 슬롯 *부재*. |
| **풀칠/접합/입체 조립** | "납작하게 접힌 상태 배송·고객이 조립" | **흡수 불요(RP 공정 아님)** | RP는 평면까지만 생산. 조립=고객 수작업 → #14 형태가공(RP가 입체 생성)의 *반대*. |

### ★1차 예측: **#18 부결 (흡수)** — ST 형상#17 승격과 정반대, NC 인쇄방식#18 부결과 동형
승격 2조건(① 전용 슬롯 라이브 실재 + ② 후니 KB 결함) **둘 다 불충족**:
1. **① 전용 슬롯 부재:** 박스 옵션 모델은 평면 인쇄물과 **100% 동일 슬롯**(paper/paper_sub/sodu/size/number). 전개도·접지·3D치수 전용 슬롯 0건. ST가 가진 `shape_info` 같은 *분리 슬롯*이 OT엔 없음 — 박스 구조는 전부 size 프리셋 라벨 + 표시 텍스트에 융합. (`[live:detail]` 5상품 일치)
2. **② 후니 KB 결함 부재:** 박스 차원은 기존 후니 축(사이즈=재단/작업치수·공정=도무송/오시·카테고리=상품군)이 *왜곡 없이* 담음. "전개도를 어느 축에도 못 담는다"는 후니 결함 미관측. ST 형상(`entity-semantic G-SK-2 "어느 축에도 없음"`) 같은 명시 결함 없음.

→ **전개도/dieline = 사이즈#13(작업치수) + 공정#2(도무송 칼틀·오시 접지) + 카테고리#7(상품 분기)로 분배 흡수.** 별 "전개도/구조전개(net/dieline)" 1급 관리축 **불요**. ST 형상#17(전용 슬롯+KB 결함 둘 다 충족=승격)과 **결정적 분기** — OT는 둘 다 불충족 = 부결.

### ★단, 후보로 남기는 미관측분 (validator 검증 필요)
- 박스 dieline **에디터 템플릿**(`makers.../templates/{code}`) 내부 구조(접지선 좌표·풀칠 위치 정의) = **#16 TemplateAsset(디자인 자산)** 가설. 자산 카탈로그 내부 스키마 `unobserved` → gap/validation에서 후니 입력채널 리소스 그릇 확인 필요.
- OTCPHOL 에어홀더 미캡처(구조=컵홀더 평면 조립 추정·클래퍼류). 박스 패턴과 다를 가능성 낮으나 `unobserved`.

---

## Ambiguous fragments
(관리 버킷이 불명확 — architect가 해소)

1. **3D 제품사이즈 "표시 텍스트"의 관리 위치** — "제품사이즈 130X105 (높이:80)"이 size 프리셋에서 *파생 계산*되는가, 아니면 별 메타데이터로 *저장*되는가? 박스는 작업사이즈(평면)↔제품사이즈(3D)가 비선형 변환(전개도 접기). 후니가 박스를 담으려면 3D 치수를 (가) size 프리셋의 부가 표시 컬럼 (나) 미저장 파생(앱 계산) 중 어디로? 메모리 `dbmap-compute-in-app-db-stores-lookup`(판수=앱계산) 동형 가설이나 박스 3D는 룩업일 수도. → **사이즈#13 facet vs 미저장 파생** 모호.

2. **dieline 에디터 템플릿 = #16 TemplateAsset인가, 박스 전용 별 자산유형인가** — 박스 dieline(접지선·풀칠탭 좌표 포함 도안)은 일반 디자인 시안(명함 템플릿)보다 *구조 정보가 풍부*(칼선/오시선/접합부). #16 TemplateAsset(가격0 디자인 시안)으로 충분히 담기는가, 아니면 "구조 템플릿(structural dieline)" sub-type이 필요한가? 라벨/카탈로그 내부 `unobserved` → validator가 `makers.../templates/{code}` 응답 스키마 실측 필요.

3. **"작업사이즈 vs 재단사이즈" 이중 표시의 후니 사이즈축 매핑** — 박스는 size 1개 선택에 *재단(485X270)·작업(495X280) 2치수*가 동시 표시(여백 10mm). 후니 size축이 재단/작업 2치수를 한 프리셋에 담는 표현력 있는가(메모리 `dbmap-platesize-is-output-paper`·t_siz 이중등록 동형)? → 사이즈#13 표현력 data-gap 가능성(vessel-gap 아님).

4. **OTPKENV "커스텀 제품" 라벨** — 봉투상자만 "커스텀 제품" 표기. 다른 박스와 옵션 구조 동일하나 *주문 운영 분류*(커스텀=별 처리)가 있는가? → 카테고리#7 vs 생산형태#15 모호(소량 미관측).
