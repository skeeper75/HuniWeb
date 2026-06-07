# M1 — 현수막 열재단(재단·마감) 경쟁사 벤치마크

> **결정 질문**: 후니 일반현수막 가공 group `[택1·필수·기본값=열재단]`(열재단/타공/양면테입/봉미싱)에서
> **열재단(YEOLJAEDAN)이 ① 실제 공정(distinct process)인가, ② "추가 마감 없음" 기본 센티넬(do-nothing base cut)인가?**
> 경쟁사(RedPrinting·WowPress)가 현수막·실사·배너·대형출력의 가장자리 마감(열재단/미싱/재단/마감)을
> **기본 선택(pre-selected default)인지 / 별도 옵션인지 / 공정인지 / 숨김-필수 자동적용인지** 어떻게 모델링하는지
> 증거 기반으로 수집한다. (사용자: "경쟁사는 어떻게 되어있는지, 기본으로 선택되어있는지")
>
> 본 문서는 **증거 수집·경쟁사 verdict 제시**까지만. 후니 최종 결정은 lead가.
> 모든 인용은 실제 capture JSON path / product ID / 라인 근거. 미검증은 `[추정]`.

---

## 0. 핵심 결론 (먼저)

| 경쟁사 | 현수막/대형 가장자리 마감 모델 | 기본 선택? | 숨김-필수 자동적용? | verdict |
|--------|------------------------------|-----------|-------------------|---------|
| **RedPrinting** (소유자 본인 시스템) | `CUT_ZUN`(재단 group) = **visible-essential 택1 group**, 디테일 3종(정사이즈재단·방풍커팅·모양재단) | **예** — `selectedOptions = [ZDINC 정사이즈재단]` 기본 사전선택 | **아니오** (VIEW_YN=Y, 표시됨) | **① 실제 공정** |
| **WowPress** | 현수막=`테두리마감` group에 **"현수막 열재단(사방/상하/좌우)"** 명명 item + "현수막 미싱"; 포스터/실사=`재단` group `type=radio` 필수택1 | 데이터상 명시 default 플래그 없음(런타임 기본 `[추정]`) | 아니오 (모두 표시되는 옵션) | **① 실제 공정** |

> **양사 모두 "열재단 = 실제 가장자리 마감 공정 ①"** 으로 본다.
> 특히 **결정적 반례**: RedPrinting은 "숨김-필수 자동적용" 센티넬용 코드를 **따로** 가지고 있다(`CUT_DFT`, VIEW_YN=N).
> 현수막의 `CUT_ZUN`은 그 코드가 **아니다**(VIEW_YN=Y). 즉 RedPrinting 스스로 ①(보이는 공정)과 ②(숨김 센티넬)를
> **별개 코드로 구분**하며, 현수막 열재단을 **①에 명시 배치**했다.

---

## 1. RedPrinting (프로젝트 소유자 본인 설계 시스템) — 결정적 증거

### 1.1 현수막 `CUT_ZUN` = visible-essential 택1, 기본 사전선택 있음 [라이브 검증]

라이브 캡처 `01_reverse/s3_raw_captures/s3_BNBNFBL.json`(BNBNFBL 일반현수막)의 PCS_INFO 원본:

```json
{ "PCS_CD": "CUT_ZUN", "PCS_GRP_NM": "재단", "VIEW_YN": "Y", "ESN_YN": "Y",
  "selectedOptions": [ { "PCS_CD": "CUT_ZUN", "PCS_DTL_CD": "ZDINC", "PCS_DTL_NM": "정사이즈재단", "ATTB": "" } ] }
```
디테일(택1 선택지) 3종:
| PCS_DTL_CD | PCS_DTL_NM | ESN_YN | VIEW_YN |
|------------|-----------|--------|---------|
| **ZDINC** | **정사이즈재단** ← 기본 선택(selectedOptions) | Y | Y |
| ZDWND | 방풍커팅 | Y | Y |
| ZDFRM | 모양재단 | Y | Y |

- `ESN_YN=Y` → **필수**(반드시 1개 선택해야 주문 가능).
- `VIEW_YN=Y` / `HIDE_YN=N` → **화면에 표시되는 옵션**(숨김 아님).
- `selectedOptions=[ZDINC 정사이즈재단]` → **상품 로드 시 기본값으로 사전선택**.
- 즉 **"기본으로 선택되어 있다(=정사이즈재단)" + 사용자가 방풍커팅·모양재단으로 변경 가능**한 **필수·표시 택1 그룹**.
- group 표시명 `PCS_GRP_NM="재단"`. (BNPTPET PET배너도 동일: `CUT_ZUN` ESN_YN=Y/VIEW_YN=Y + `COT_DFT` 코팅 필수.)

> 어댑터 매핑 결과(`s3-poster-capture.md §2`)에서도 배너 가공옵션(CUT_ZUN 열재단/COT_DFT/SEW_RIN 등)이
> **전부 `finish-button` 컴포넌트로 흡수** = 사용자에게 **보이는 선택 컨트롤**로 렌더된다. [라이브 검증]

### 1.2 결정적 대비 — RedPrinting은 "숨김-필수 센티넬"을 별도 코드로 갖는다: `CUT_DFT` [라이브 검증]

`cascade-rules.md §5`의 pcs essential/hidden 분류:

| 상태 | ESN_YN | VIEW_YN | 동작 | 예시 |
|------|--------|---------|------|------|
| **hidden(자동)** | Y | **N** | 필수이나 **미표시 — 자동 적용** | **CUT_DFT 재단** |
| visible-essential | Y | Y | 필수 + 표시 | **CUT_ZUN 재단**(현수막), RIN_DFT 링제본 |
| optional | N | Y | 선택적 | ILT_DFT, ROP_DFT 등 |

라이브로 `CUT_DFT`(ESN_YN=Y / **VIEW_YN=N** = 숨김 자동적용)가 실재함을 **포스터·캘린더 캡처에서 직접 확인**:
- `s3_PRPOXXX.json`(종이포스터): `CUT_DFT` ESN_YN=Y / VIEW_YN=N (PCS_GRP_NM "재단", 미표시 자동)
- `s6_cal_HLCLSTD / HLCLWAL / TPCLECO / TPCLWLB`(캘린더): 동일 `CUT_DFT` Y/N

> **이것이 본 연구의 가장 강한 단일 증거**:
> RedPrinting은 **digital print류(포스터·캘린더·책자)의 "기본 재단(자르기만, 추가 마감 없음)"** 을
> `CUT_DFT`(VIEW_YN=N, 숨김·자동적용 = 후니의 ②-형 "do-nothing base cut")로 모델링하고,
> **현수막의 "열재단"은 그 코드를 쓰지 않는다**. 현수막은 `CUT_ZUN`(VIEW_YN=Y, 보이는 필수 택1)로
> **별개 코드·별개 의미**로 둔다.
> → RedPrinting 스스로 ①(공정)과 ②(센티넬)를 **다른 코드로 구분**하고 있으며, **현수막 열재단을 ①에 배치**했다.
> 만약 현수막 열재단이 "그냥 자르기(②)"였다면 RedPrinting은 포스터처럼 `CUT_DFT`(숨김)를 썼을 것이다. 안 썼다.

### 1.3 보강: 열재단 디테일의 의미 = 실제 가공 방법 차이 [라이브 검증]

`CUT_ZUN` 디테일 3종은 단순 "자르기 유무"가 아니라 **가장자리 처리 방법의 차이**다:
- `ZDINC 정사이즈재단`(주문 사이즈대로 열로 잘라 가장자리 융착) — 현수막 가장자리 풀림 방지 열재단.
- `ZDWND 방풍커팅`(바람 통과용 슬릿 가공) — note: "한쪽면 1,700mm 미만만 가능".
- `ZDFRM 모양재단`(외곽 모양대로 재단).
→ 세 디테일 모두 **물리적 후가공 작업**이며 "마감 안 함"이라는 옵션은 그룹 내에 없다(필수=무조건 1개 가공 수행).
이는 후니 가공 group의 "열재단/타공/양면테입/봉미싱"과 **구조·의미가 1:1 대응**한다.

---

## 2. WowPress — 보강 증거 (외부 경쟁사)

WowPress는 후가공을 `awkjobinfo`의 group(`jobgroup`)으로 모델링하고, group마다 `type`(radio=필수택1 / select=선택)을 둔다.
(모델 일반론은 `wowpress-option-model.md §1·§6` 참조.) 현수막·배너·포스터·실사 43개 상품을 직접 스캔.

### 2.1 현수막: 가장자리 마감 = "테두리마감" group + 열재단 명명 item [docs/wowpress 캡처]

`40115 일반현수막`, `40448 현수막`의 `awkjobinfo`:
```
group=테두리마감  (type=select)
   - 현수막 미싱(사방/상하/좌우)
   - 현수막 열재단(사방/상하/좌우)   ← "열재단"이 명시적 가공 item으로 존재
group=나무+로프 (상하/좌우 700·900)
group=아일렛 (4~20개)
```
- WowPress는 **"열재단"을 "미싱"과 나란히 `테두리마감` 그룹 안의 명명된 가공 선택지**로 둔다.
  → 열재단 = **실제 가장자리 마감 공정**(미싱·아일렛·나무로프와 동급). "자르기만/마감없음" 센티넬이 **아님**.
- `40104 대형현수막`: `줄미싱`·`아일렛` group. `40589 메쉬현수막`: `나무+로프`·`아일렛`.
- `40437 미니현수막`·`40585 현수막배너`: `테두리마감`(radio)·`아일렛`.
- → 현수막 가장자리 마감은 **여러 개의 명명된 가공 그룹**(테두리마감/미싱/열재단/아일렛/나무로프)으로 표현되며,
  그중 열재단은 **하나의 실제 공정 선택지**다.

### 2.2 포스터·실사: `재단` group `type=radio` = 필수 택1 공정 [docs/wowpress 캡처]

| product | 재단 group type | 디테일 |
|---------|-----------------|--------|
| `40022 대량포스터` | **radio**(필수택1) | 규격재단 · 비규격재단 · **재단없음** |
| `40029 소량포스터` | **radio** | 2~6등분재단 · 규격재단 · 별도재단 · 비규격재단 |
| `40182 소량포스터` | **radio** | 재단 · 코팅 |
| `40208 한장 포스터 캘린더` | **radio** | 재단 · 코팅 |
| `40609 모양포스터` | (코팅·모양타공·모양컷팅 radio) | 모양컷팅=필수 |
| `40053·40159·40165~40168 시트지류` | **select**(선택) | 재단 |

- 포스터의 `재단`은 **명시적 필수 택1 그룹**(radio)이며, 그 **안에 "재단없음" 항목이 별도로 존재**(40022).
  → 즉 WowPress조차 "재단함 vs 재단없음"을 **그룹 내 명시 선택지**로 펼친다. "재단"은 **수행되는 공정**이고,
  "안 함"은 별도 항목으로 명시. 후니 열재단을 "재단없음 센티넬"로 보는 해석과 **반대 구조**.
- WowPress 캡처에는 항목별 `isdefault/default` 플래그가 채워져 있지 않다(전부 None). 런타임에서 첫 항목/규격재단을
  기본 선택하는지는 캡처만으로 단정 불가 `[추정]`. 단 **radio 그룹은 필수**이므로 1개는 사전선택되는 게 통상.
- 제약 최종판정 = 가격엔진(`§Q5`·"비가격조합=주문불가"). req_/rst_는 UI 사전필터.

---

## 3. buysangsang / print-quote 리서치

`_workspace/print-quote/01_research/`(asis-huniprinting·crawl-evidence)는 후니 As-Is 빌더 패턴 역공학과 Shopby/Edicus
분석 중심으로, **현수막·배너 가장자리 마감(열재단)의 옵션 구조를 별도로 정리한 산출물은 없음**(banner finishing 전용 증거 부재).
→ 본 결정에 대한 buysangsang 측 직접 증거는 **수집된 워크스페이스에 없음**. 위 두 경쟁사(RedPrinting·WowPress)로 충분.

---

## 4. 핵심 parallel — RedPrinting `CUT_DFT`(hidden-essential)와 후니 ②의 관계

`attribute-entity-map.md`는 이미 두 GAP을 식별해 둠:
- **GAP-HIDDEN**: hidden-essential(ESN_YN=Y/VIEW_YN=N 자동적용·미표시) 플래그 부재 — 근거 "재단 **CUT_DFT** 등"(cascade-rules §5).
- **GAP-DEFER**: 열재단(PROC_000053 완칼) 미적재 → "차원 선적재 vs **deferred 센티넬(mat_cd=NULL)**".

이 둘을 합치면 후니 결정의 핵심 분기가 그대로 드러난다:

| | 후니 ① 해석 | 후니 ② 해석 |
|---|------------|------------|
| 의미 | 열재단 = 실제 가장자리 마감 공정(타공·미싱과 동급) | 열재단 = "추가 마감 없음" 기본 센티넬(자르기만) |
| RedPrinting 대응 코드 | **CUT_ZUN**(VIEW_YN=Y, 보이는 필수택1, 정사이즈재단 기본) | CUT_DFT(VIEW_YN=N, 숨김 자동적용) |
| 현수막에 실제 쓰인 코드 | ✅ **CUT_ZUN** | ❌ (CUT_DFT는 포스터·캘린더용) |

→ **RedPrinting은 현수막 열재단에 ①형 코드(CUT_ZUN)를 쓰고, ②형 코드(CUT_DFT)는 디지털인쇄 자동재단에만 쓴다.**
   후니가 ②(센티넬)로 본다면 그것은 **RedPrinting의 CUT_DFT 자리**인데, 현수막은 거기 해당하지 않는다.

---

## 5. "기본 선택(pre-selected default)" 질문에 대한 답

- **RedPrinting**: **예, 기본 선택되어 있다.** 단 그 기본값은 "do-nothing base cut(아무것도 안 함)"이 **아니라**
  **명명된 실제 공정 `ZDINC 정사이즈재단`**(열로 잘라 가장자리 융착)이다. `selectedOptions=[ZDINC]`로 사전선택,
  사용자는 방풍커팅·모양재단으로 변경 가능. **필수(ESN_YN=Y)이므로 "선택 안 함" 상태는 불가.**
- **WowPress**: 재단/테두리마감 group이 radio(필수택1)·select. 캡처상 명시 default 플래그는 없으나, radio 필수 그룹은
  1개 사전선택이 통상 `[추정]`. **그룹 안에 "재단없음"을 별도 항목으로 명시**(40022) → "재단"은 수행 공정, "안 함"은 별도.
- → **양사 모두 "기본값 = 명명된 실제 마감 공정"** 이지, "기본값 = 마감 안 함 placeholder"가 아니다.

---

## 6. 경쟁사 Verdict (lead용 권고)

> **경쟁사 관행은 후니 열재단 = ① distinct process(실제 가장자리 마감 공정)를 강하게 지지한다.**

근거 요약(강→약):
1. **[최강] RedPrinting CUT_ZUN vs CUT_DFT 코드 분리** — RedPrinting은 "보이는 필수 공정(CUT_ZUN, 정사이즈재단 기본선택)"과
   "숨김 자동 기본재단(CUT_DFT)"을 **별개 코드로 구분**하며, **현수막 열재단을 CUT_ZUN(①)에 명시 배치**.
   ②(숨김 센티넬)는 디지털인쇄 자동재단(CUT_DFT) 전용이고 현수막엔 안 씀. → ②로 볼 근거가 소유자 본인 시스템에 없음.
2. WowPress가 "열재단"을 미싱·아일렛과 나란히 **명명된 테두리마감 가공 item**으로 둠(40115·40448).
3. RedPrinting 열재단 디테일 3종(정사이즈재단·방풍커팅·모양재단)이 전부 **물리적 후가공**이며, 그룹 내 "마감없음" 항목 없음(필수).
4. 후니 가공 group 4값(열재단/타공/양면테입/봉미싱)은 RedPrinting CUT_ZUN·WowPress 테두리마감 그룹과 **구조·의미 1:1 대응**.

**시사(결정은 lead)**: 후니 열재단을 ①(실제 공정)로 본다면, RedPrinting처럼 **`PROC_000053`(완칼/열재단) 차원행을 선적재**해
`OG-GAGONG` 택1 그룹의 기본값으로 두는 정석 경로가 경쟁사 관행과 일치(silsa-option-layer D-2·GAP-DEFER 정석안).
②(센티넬) 처리는 경쟁사 어디서도 현수막에 쓰지 않으므로 **권장하지 않음**.

---

## Sources

- **RedPrinting (라이브 캡처, 소유자 본인 시스템)**:
  - `_workspace/huni-widget/01_reverse/s3_raw_captures/s3_BNBNFBL.json` (일반현수막 PCS_INFO: CUT_ZUN ESN_YN=Y/VIEW_YN=Y, selectedOptions=ZDINC 정사이즈재단; 디테일 ZDINC/ZDWND/ZDFRM)
  - `_workspace/huni-widget/01_reverse/s3_raw_captures/s3_BNPTPET.json` (PET배너: CUT_ZUN + COT_DFT 필수)
  - `_workspace/huni-widget/01_reverse/s3_raw_captures/s3_PRPOXXX.json`, `s6_cal_{HLCLSTD,HLCLWAL,TPCLECO,TPCLWLB}.json` (CUT_DFT ESN_YN=Y/VIEW_YN=N = 숨김 자동재단, ①↔② 코드 분리 증거)
  - `_workspace/huni-widget/02_analysis/cascade-rules.md` §5 (pcs essential/hidden: CUT_DFT hidden vs CUT_ZUN visible)
  - `_workspace/huni-widget/01_reverse/s3-poster-capture.md` §1.5·§2 (배너 가공옵션 finish-button 흡수, PCS_INFO 실측)
- **WowPress (로컬 캡처 2025-10-14)**:
  - `docs/wowpress/catalog/products/{40115,40448}.json` (일반현수막·현수막: 테두리마감 group에 "현수막 열재단(사방/상하/좌우)" item)
  - `docs/wowpress/catalog/products/{40022,40029,40182,40208}.json` (포스터: 재단 group type=radio 필수택1, "재단없음" 별도 item)
  - `docs/wowpress/catalog/products/{40104,40160,40161,40437,40585,40589}.json` (배너·메쉬·미니현수막 후가공 그룹)
  - `_workspace/huni-dbmap/10_configurator/wowpress-option-model.md` §1·§6 (awkjobinfo type radio/select, 제약·가격엔진 모델)
- **후니 내부 매핑 컨텍스트**:
  - `_workspace/huni-dbmap/10_configurator/silsa-option-layer.md` (OG-GAGONG 택1·필수, 열재단=PROC_000053 BLOCKED/GAP-DEFER, D-2)
  - `_workspace/huni-dbmap/10_configurator/attribute-entity-map.md` (GAP-HIDDEN: CUT_DFT, GAP-DEFER: 열재단 센티넬 vs 선적재)
- **buysangsang/print-quote**: `_workspace/print-quote/01_research/` — 현수막 마감 옵션 구조 전용 증거 **없음**(banner finishing 미정리).

미검증/추정: WowPress 캡처에 항목별 default 플래그 부재 → 런타임 기본선택 항목은 `[추정]`. RedPrinting PRICE=0(비로그인) 무관(구조 증거는 productInfo·selectedOptions로 충분).
