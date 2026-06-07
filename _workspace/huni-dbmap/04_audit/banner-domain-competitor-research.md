# 일반현수막(배너) 도메인지식 + 경쟁사 벤치마킹 리서치

> **목적** 일반현수막(실사/현수막·배너) 상품군을 가격표 권위로 재정합하기 전, 애매한 도메인 판단
> (사이즈 이산 매트릭스 vs 연속·옵션 가격 구조·가공 의미)을 도메인지식과 경쟁사 벤치마킹으로 자가확보.
> **작성** 2026-06-08 · 기존 자산 우선 + 부족분 WebSearch. 추측 금지 — 모든 결론에 출처 표기, 미확인은 명시.
> **권위 우선순위** 후니 가격표 실측(B26) > 라이브 DB 실측 > 경쟁사 실측(WowPress API doc·Red fixture) > 업계 일반론(web).

---

## A. 현수막 사이즈 모델 — **③ 혼합(규격 선택 + 비규격 자유입력)이 업계 표준**

### A.1 결론
일반현수막(배너)의 사이즈 입력은 **③ 혼합형(hybrid)** — 자주 쓰는 이산 규격 프리셋 + "사용자 입력 사이즈"
비규격 자유입력(min/max 범위 내) — 이 **경쟁사·업계 공통 표준**이다. 순수 ① 이산 매트릭스만도, 순수 ②
연속 자유치수만도 아니다.

### A.2 증거 (수렴 4소스)

| 소스 | 사이즈 모델 증거 |
|---|---|
| **RedPrinting 현수막 (BNBNFBL fixture, 라이브 역공학)** | `pdt_size_info`에 **"사이즈직접입력" 행**(sentinel `CUT_WDT=0.00 CUT_HGH=0.00`, `DIV_SEQ=0`) + **이산 규격 프리셋 행**(5000X900[DFT_YN=Y 기본], 900X900, 900X5000, 1800X1780…) **공존**. `pdt_base_info`: `MAX_CUT_WDT=5000.00 MAX_CUT_HGH=5000.00`, `CUT_MRG=4`(재단마진 4mm). 즉 프리셋 택1 OR 자유입력(상한 5000mm). 위젯은 이를 `dimension-matrix-input` 컴포넌트로 렌더(`componenttype-mapping-matrix.md` #10: `real_price`+0×0 sentinel → hasFreeInput=true). |
| **WowPress API doc (§7.1 sizeinfo)** | `sizeinfo.sizelist[]`에 `non_standard` 플래그(**0:규격, 1:비규격**) + `req_width`/`req_height`(비규격 주문 시 min/max 필수조건). 문서 명시: *"규격종류: 88x53, 90x50, **비규격**"* / *"비규격에서 min,max 이내에서만 인쇄가능"*. → 규격 프리셋 + 비규격 자유입력(범위 게이트) 혼합 구조. |
| **업계 일반론 (web)** | bizhows: *"[사용자 입력 사이즈]를 선택하면 비규격 사이즈로 주문 가능, cm 단위 입력… 5cm 단위"*. mangoboard/publog: *"가로·세로 자유 사이즈"* + 짧은 변 **최대 1500mm(150cm)** 상한. → 자유입력 + 단변 상한이 업계 패턴. |
| **후니 가격표 B26 (silsa-price-table-gap.md, 실측 권위)** | 가로 **5 이산 규격**{900,1000,1200,1500,1750} × 세로 **16 이산 규격**{900…5000} = 5×16 면적 매트릭스. **가격은 이산 격자로만 정의**. off-grid 메모(G247 `1000x1000:8000`) = 매트릭스 외 치수는 **한 단계 큰 규격 가격(ceiling)**. |

### A.3 후니 적용 권위 판단 — 핵심 구분 (입력 UX ≠ 가격 격자)
> **사이즈 입력 UX**(혼합형: 프리셋 + 자유입력)와 **가격 격자**(이산 매트릭스)는 **별개 층위**다.
> - 후니 가격표 B26은 **가격을 이산 5×16 격자로만 정의** — 이것이 가격 권위.
> - 자유입력 치수(off-grid)는 **새 가격을 만들지 않고**, **한 단계 큰 격자 셀의 가격으로 ceiling 룩업**(B26 G247 명시, round-2 면적매트릭스형 규약 `dbmap-price-formula-types-authority`·`dbmap-compute-in-app-db-stores-lookup`과 일치).
> - 따라서 후니 = **WowPress/Red와 동일한 혼합 입력 UX** + **이산 매트릭스 가격 + off-grid ceiling(앱 런타임)**. silsa 설계의 "비치수 연속범위(R-SIZE-NONSPEC)" 오판은 **입력 허용범위를 가격 모델로 착각**한 것 — 가격 권위는 이산 매트릭스다.
> - **유효 사이즈의 권위 = 가격표 매트릭스 존재 여부**(가격 없는 치수는 ceiling으로 환원, 매트릭스 범위 밖[가로<900 or >1750 등]은 주문 가능성=가격엔진 판정). 상품마스터 "비규격(500~1750)"은 **입력 폼 허용범위**일 뿐.

### A.4 off-grid 처리 — ceiling이 표준임을 교차확인
- 후니 B26: off-grid = "한 단계 큰 규격 가격"(명시 메모). **DB는 격자 셀 단가만 저장, ceiling 룩업은 앱 런타임**.
- 업계(web): 면적(㎡)×단가 **연속 함수**로 가격을 내는 업체도 다수(mangoboard 예: 4.5㎡→₩15,750). 즉 업계엔 **두 모델 공존** — (a) 이산 매트릭스+ceiling, (b) 면적 연속 단가. **후니는 명백히 (a)**(B26이 이산 격자, ceiling 메모). → round-2의 R² 면적-좌표 회귀 함수는 후니 권위 아님(매핑.md §4.1 D-FRM과 일치).

---

## B. 현수막 가격 모델 — **이산 (가로×세로) 면적 매트릭스 셀단가 / 옵션 추가가격은 flat(사이즈 무관, 단 각목은 길이 의존)**

### B.1 결론
후니 현수막 가격 = **[가로×세로] 순서쌍별 이산 셀단가**(면적 매트릭스형, 규격별 고정가의 2D 확장). 단순
규격별 1D 고정가도 아니고, 순수 면적(㎡) 연속함수도 아니다. **(가로,세로)는 비대칭 순서쌍**((600,1000)≠(1000,600)).

### B.2 증거

| 항목 | 증거 |
|---|---|
| **가격 = 이산 셀단가** | 후니 B26: 5×16=80셀 각각 명시 단가(`silsa-price-table-gap.md` §1.1). `silsa-poster-area-matrix/mapping.md` §2: 13상품 687셀 long-form 평면화, `component_prices(comp_cd, siz_cd=치수)` 단일 룩업. clr/mat/coat/bdl/min=NULL(코팅포함 통가격). |
| **비대칭 순서쌍** | mapping.md §2.3: 매트릭스 비대칭 — (가로,세로) 각 순서쌍이 고유 siz_cd. "면적 스칼라로 합치면 round-2 오모델 함정." |
| **가격엔진=서버권위** | WowPress §6.4: 정적 가격표 없이 `/std/prod/jobcost` 동적 견적, *"수량에 정확히 비례하지 않음"*. RedPrinting: PRICE=0 절대 없음(서버 권위, 메모리 `huni-widget-red-price-never-zero`). → 가격은 옵션 코드 조합의 함수, 클라가 로직 모름. |

### B.3 옵션(가공/추가) 추가가격 — flat(사이즈 무관)이 기본, 각목만 길이 의존

후니 B26 사이드바(silsa-price-table-gap.md §1.2~1.3, **실측 권위**):

| 옵션 | 추가가격 | 사이즈 의존? |
|---|---|---|
| 열재단 | 3,000 | flat |
| 타공(4/6/8개) | 3,000/4,000/5,000 | **개수 의존**(사이즈 아님) |
| 양면테잎 | 3,000 | flat |
| 봉미싱 | 4,000 | flat |
| 큐방(4개) | 3,000 | flat |
| 끈(4개) | 4,000 | flat |
| 각목(900mm이하)+끈 | 4,000 | **길이 의존**(900기준 2단) |
| 각목(900mm초과)+끈 | 8,000 | **길이 의존** |

- **추가가격은 단일 컬럼**(사이즈축 없음) → 사이즈 무관 flat가 기본. 예외 = **타공(구멍 개수별)·각목(900mm 기준 2단)**.
- WowPress 교차확인: 후가공 가격도 `awkjob` 코드별 단가(jobcost 응답), 사이즈 의존은 `rst_*`/개수 옵션으로 표현. → flat + 개수/길이 단계가 업계 패턴과 일치.
- **silsa 설계 결함**(silsa-price-table-gap.md §2 PG-2): 옵션 레이어가 이 추가가격을 0으로 누락 → **재정합 시 옵션별 추가가격을 가격 구성요소로 반영**해야.

---

## C. 가공 옵션 도메인 의미 — 전부 확정 (web + Red pcs 코드 교차확인)

후니 silsa 가공/추가 옵션 = RedPrinting 현수막 `pdt_pcs_info` 그룹과 **거의 1:1 대응**. 의미는 web으로 확정.

| 후니 옵션 | 의미 (도메인) | Red pcs 코드 | 옵션/가공/부자재 분류 |
|---|---|---|---|
| **열재단** | 열로 깔끔히 재단하는 **기본 마감**. 실내 압정/양면테이프로 부착. (printingkorea/swimmingmall) | `CUT_ZUN`(정사이즈재단) | **가공**(공정 `.04`). 후니 M-1 결정: 열재단=① 실제 가공(가격표 3,000원 권위, 메모리 `dbmap` round-6). |
| **타공(아일렛)** | 모서리/사방에 **타공 후 금속링** 부착 → 끈 거는 구멍 마감. (bizhows/designel) | `ILT_DFT`(사각귀퉁이) | **가공**. 개수별(4/6/8) 단가. |
| **봉제(봉미싱)** | 좌우/상하 끝을 **미싱**하여 봉·파이프·거치대에 끼우는 마감(헤리/오버로크 류). (swimmingmall) | `SEW_DFT`(접어꿰매기)·`SEW_RIN`(사방고리) | **가공**. |
| **양면테입** | 부착용 양면테이프 부속. | `SUB_MTR`(큐브 양면 젤리테이프) | **부자재성 가공**(Red는 SUB_MTR=하위자재 연동). |
| **봉미싱** | (=봉제, 위와 동일 계열) | `SEW_DFT` | **가공**. |
| **큐방(규방)** | 타공 후 **투명 큐방** 제공 — 유리/거울/타일/스텐면에 설치하는 거치 부속. (designel/speedad24) | `QBG_DFT`(큐방) | **추가(거치 부자재)**. |
| **끈(4개)** | 현수막 거는 **노끈** 부속. | `ROP_DFT`(3mm) | **추가(거치 부자재)**. |
| **각목(900mm 기준)** | 좌우/상하에 막대 넣게 **미싱 가공 후 각목 삽입**. 각목은 현수막보다 10cm 이상 길게, 양끝 타공해 노끈 묶음. (speedad24) | `LUM_DFT`(각목_타공포함) | **추가(거치 부자재 + 가공 복합)**. 900mm 기준 2단가. |

### C.1 분류 권위 판단 (가공 vs 추가 vs 부자재)
- **가공(공정 `.04`)** = 현수막 본체에 가하는 마감 작업: **열재단·타공(아일렛)·봉제(봉미싱)·양면테입**. (마감법 = 후가공)
- **추가/부자재** = 거치·설치용 별도 부속: **큐방·끈·각목**. (각목+끈은 복합 — Red `LUM_DFT`=각목_타공포함, 후니 round-6에서 polymorphic 이종 2행 `.04`공정+`.07`자재로 분해한 선례 있음, 메모리 `dbmap-cpq-option-layer-mapping`).
- **업계·Red 공통**: 가공(본체 마감)과 거치부속(각목/끈/큐방)을 **분리**하되, 둘 다 "옵션"으로 노출하고 추가가격을 부여. 후니 가격표 B26도 J/K 컬럼(가공)과 M/N 컬럼(추가)으로 **물리적으로 분리** — 정합.

---

## D. 경쟁사 현수막 옵션 트리

### D.1 RedPrinting (BNBNFBL fixture, 라이브 역공학)
- **사이즈**: `pdt_size_info` = 자유입력 행 + 프리셋 행 혼합 → `dimension-matrix-input`.
- **가공(pcs)**: `pdt_pcs_info` 8그룹(CUT_ZUN/ILT_DFT/LUM_DFT/QBG_DFT/ROP_DFT/SEW_DFT/SEW_RIN/SUB_MTR) → 각 `finish-button`(componenttype #12).
- **캐스케이드**: 자재→pcs disable(`pdt_disable_pcs_info`), 6종 제약 룰엔진(`cascade-rules.md`). 단 현수막 fixture는 disable 단순.
- **택1/택N**: pcs 그룹 `type`(radio=필수/select=택1/checkbox=복수). 가격은 선택 코드 묶음 → 서버 jobcost 권위.
- **부자재**: `pdt_add_info`(현수막류는 거치대 등 별도상품, BNBNFBL fixture엔 비어있음 — 입간판류에 존재).

### D.2 WowPress (API doc)
- **사이즈**: `sizeinfo` 규격행 + `non_standard=1` 비규격행(req_width/height min·max). → 혼합형.
- **가공**: `awkjobinfo`(후가공, 2단계 namestep1/2 + select/checkbox/radio) + `optioninfo`(기타 가공/포장 flat).
- **부자재**: `prodaddinfo`(주제품에 추가 구매하는 별도 제품 — 거치대 등). API 문서 명시 *"부자재 단독 주문 불가… 예) 물통스프링배너의 거치대, 거치대바퀴"*.
- **제약**: 옵션 행 인라인 `req_*`/`rst_*` 교차참조 + 최종판정=가격조회 성공 여부.
- **가격**: 정적표 없음, `jobcost` 동적 견적(서버 권위).

### D.3 옵션 트리 공통 구조 (양 경쟁사 + 후니)
```
현수막 상품
├─ 사이즈     : [프리셋 규격 택1] OR [자유입력 가로×세로(min/max 게이트)]   → 가격격자 룩업(+off-grid ceiling)
├─ 가공(마감) : 열재단/타공(아일렛)/봉제(봉미싱)/양면테입  (택1 또는 복수)   → 추가가격 flat(타공만 개수별)
└─ 추가(거치) : 큐방/끈/각목(+끈)  (택1 또는 복수)                          → 추가가격 flat(각목만 길이 2단)
```
후니 polymorphic 옵션레이어(option_groups→options→option_items, `ref_dim_cd`)는 이 트리를 그대로 수용 가능
(round-6 silsa-option-layer 선례, 메모리 `dbmap-cpq-option-layer-mapping`). **구조는 정합 — 결함은 가격 미반영뿐.**

---

## 재정합에 쓸 권위 판단 (요약)

| 차원 | 권위 판단 (재정합 기준) |
|---|---|
| **사이즈 모델** | 입력 UX = **혼합형**(프리셋 + 자유입력). 가격 = **이산 (가로×세로) 면적 매트릭스**(후니 B26 = 5×16, 권위). off-grid = **한 단계 큰 셀 ceiling(앱 런타임, DB는 격자 셀단가만)**. silsa의 R-SIZE-NONSPEC(비치수 연속) **폐기**. 유효 사이즈 권위 = **가격표 매트릭스 존재 여부**. |
| **가격 모델** | **이산 셀단가**(비대칭 순서쌍), `component_prices(comp_cd, siz_cd=치수)` 단일 룩업, 코팅포함 통가격(FRM_TYPE.02 단순형). R² 면적-좌표 회귀 **미사용**. round-2 sparse 적재(2~6%) → 전체 매트릭스 셀 정정 적재(`silsa-poster-area-matrix` 트랙이 이미 설계). |
| **옵션 가격** | 가공/추가 옵션 **각각 추가가격 보유**(B26 J/K/M/N, 실측). **사이즈 무관 flat가 기본**, 예외 = **타공(개수별)·각목(900mm 2단)**. silsa 옵션레이어의 가격 0 누락(PG-2) → 추가가격을 가격 구성요소로 매핑. |
| **가공 의미** | 열재단=기본 마감 가공(① 실 가공 확정), 타공=아일렛 금속링 구멍, 봉제=봉미싱(거치용 끝마감), 양면테입=부착 부속. **거치부속**(큐방/끈/각목)은 추가로 분리. 가공(`.04` 공정) vs 추가(거치 부자재 `.07`) 분류 권위 = C.1 표. |

---

## 여전히 애매해 사용자 질의 필요한 항목

| # | 애매분 | 왜 애매한가 (자가확보로 못 닫은 이유) | 질의 형태 권고 |
|---|---|---|---|
| **Q-1** | **off-grid 가격 규약 — ceiling 방향 정확성** | B26 G247 stray 메모(`1000x1000:8000`)가 ceiling 규약의 **명시 주석인지 불명**(silsa-price-table-gap §4 미확인). "한 단계 큰 규격"이 가로·세로 **각각** 올림인지, 면적 기준인지 미명시. 가격 직결이라 추측 불가. | "off-grid(매트릭스 외) 치수는 가로·세로를 **각각** 한 단계 큰 규격으로 올려 그 셀 가격을 쓰는지, 아니면 다른 규칙인지?" |
| **Q-2** | **가로 하한 차이 (상품마스터 500 vs 가격표 900)** | 상품마스터 비규격=500~1750, 가격표 매트릭스=900~1750. 500~900 구간이 **입력만 허용(가격 없음→주문불가)** 인지, 별도 가격이 있는지(추출 누락) 불명. | "현수막 가로 500~900mm는 주문 가능한가? 가능하면 가격은 어떻게(가장 작은 셀 가격? 별도표?)?" |
| **Q-3** | **각목 길이 기준 (900mm = 가로? 세로? 단변?)** | 각목 추가가격 2단(900이하/초과)의 **기준 변이 무엇인지** 가격표에 미명시. web(speedad24)은 "각목=현수막보다 10cm 길게"만 설명. 거치 방향(가로형=좌우 각목 / 세로형=상하 각목)에 따라 기준 변이 달라 가격 갈림. | "각목 900mm 기준은 현수막의 어느 변(가로/세로/긴변/짧은변) 길이인가?" |
| **Q-4** | **봉미싱 vs 봉제 — 후니 옵션 2개가 같은가 다른가** | 후니 silsa 옵션에 "봉제"와 "봉미싱"이 별도 등장(silsa-price-table-gap §1.2엔 봉미싱만 4,000). Red는 SEW_DFT(접어꿰매기)·SEW_RIN(사방고리) 2그룹. 후니 두 값의 구분이 가격표에 명확치 않음. | "후니 silsa의 '봉제'와 '봉미싱'은 같은 가공인가, 다른가(예: 사방고리 vs 끝단 봉제)?" |
| **Q-5** | **타공·각목 등이 택1인가 복수선택인가** | B26은 가격만, 택1/택N(option_group mand_yn/multi) 규칙은 가격표에 없음. Red pcs `type`은 라이브 권위지만 후니 정책과 다를 수 있음. 옵션레이어 구조(택1 그룹 vs 복수)에 직결. | "가공(열재단/타공/봉제…)과 추가(큐방/끈/각목)는 각각 **하나만** 고르는가, **여러 개** 동시 선택 가능한가?" |

> **닫힌 것**: A(혼합 입력+이산 매트릭스 가격), B(셀단가+flat 옵션가), C(가공 의미 전부), D(경쟁사 트리) — 자가확보 완료.
> **남은 것**: 위 Q-1~Q-5는 **가격 직결 + 가격표에 미명시**라 추측 시 오적재 위험 → 사용자 질의 필요.

---

## 출처

### 후니 내부 자산 (권위)
- `_workspace/huni-dbmap/10_configurator/silsa-price-table-gap.md` — B26 실측(5×16 매트릭스·옵션 추가가격·off-grid 메모·재정합 GAP 3건)
- `_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md` — 면적매트릭스 평면화 설계(687셀·비대칭·FRM_TYPE.02·D-WIRE)
- `_workspace/huni-dbmap/10_configurator/wowpress-option-model.md` — WowPress 7축 흡수원칙·비규격 sizeinfo·제약 req_/rst_
- `_workspace/huni-widget/02_analysis/cascade-rules.md` — Red 6종 제약 룰엔진(size/material→pcs disable)
- `_workspace/huni-widget/03_spec/componenttype-mapping-matrix.md` — Red dimension-matrix-input(#10) = 현수막 자유입력(BNBNFBL·BNPTPET)
- `_workspace/huni-widget/04_build/fixtures/product_BNBNFBL.json` — Red 현수막 라이브 fixture(pdt_size_info 혼합·pcs 8그룹·MAX 5000·CUT_MRG 4)
- `docs/wowpress/wowpress-api-document.txt` — WowPress API(§7.1 sizeinfo non_standard·§7.5 prodaddinfo 부자재·§6.4 jobcost)
- 메모리: `dbmap-silsa-price-via-poster-sign`(HARD)·`dbmap-price-formula-types-authority`·`dbmap-compute-in-app-db-stores-lookup`·`dbmap-cpq-option-layer-mapping`

### 업계 일반론 (web — 교차확인용)
- [bizhows 현수막 사이즈](https://www.bizhows.com/cms/help_center/plancard_size/) · [bizhows 비규격 주문](https://www.bizhows.com/cms/help_center/freesize_plancard_order/) · [bizhows 후가공](https://help.bizhows.com/hc/ko/articles/4408517044889)
- [mangoboard 자유사이즈 현수막](https://www.mangoboard.net/print/%EC%9E%90%EC%9C%A0%EC%82%AC%EC%9D%B4%EC%A6%88_%ED%98%84%EC%88%98%EB%A7%89) · [publog 현수막 가이드 2026](https://www.publog.co.kr/blog/publog-banner-guide-2026)
- [printingkorea 열재단/미싱/타공 마감](https://printingkorea.net/m/board_view.php?num=5444&view=1&board=guide) · [designel 마감법](https://designel.co.kr/sub4/_pop.finish.php) · [swimmingmall 후가공](https://swimmingmall.com/product/%ED%98%84%EC%88%98%EB%A7%89/48/) · [speedad24 각목/아일렛/큐방/로프](https://speedad24.com/product/8%EB%AF%B8%ED%84%B0-%EC%9D%B4%ED%95%98-%ED%98%84%EC%88%98%EB%A7%89-8m-x-09m90cm-%EC%9D%BC%EB%B0%98-%ED%98%84%EC%88%98%EB%A7%89-%ED%9B%84%EA%B0%80%EA%B3%B5%EA%B0%81%EB%AA%A9-%EC%95%84%EC%9D%BC%EB%A0%9B-%ED%81%90%EB%B0%A9-%EB%A1%9C%ED%94%84-%EC%84%A0%ED%83%9D-%EA%B0%80%EB%8A%A5/166/)
- [RedPrinting 현수막 상품페이지](https://www.redprinting.co.kr/ko/product/item/BN/BNBNFBL)
