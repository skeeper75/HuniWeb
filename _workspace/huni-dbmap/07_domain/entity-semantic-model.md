# 엔티티 의미 모델 (L3) — 9속성 의미축 + UV/별색·variant 의미

> **작성** 2026-06-05 · 전략 H L3. 설명 한국어, 식별자/컬럼/코드/SQL 영어.
>
> **목적:** DB 9속성 매핑이 의존하는 **의미축**을 도메인 지식으로 확정하고, 미해소 3건
> (**C-9 생산방식 · C-10 제본차이 · C-11 UV/별색**)을 PDF·DB·표준 근거로 푼다.
> "도메인 의미를 모른 채 사용자에게 떠넘기지 말라"는 교정에 대한 답.
>
> **권위 순서(HARD):** ① 후니 PDF ② 라이브 DB(07_domain KB) ③ 표준(보조). 추정 0 — 미지는 가설+출처. 표준 충돌 시 후니 권위.
> **연계:** 공정 레시피·제본·생산방식은 `process-recipe-tree.md`(L2). 본 문서는 *의미축*에 집중.
>
> **확정도:** ✅PDF/DB 권위 · 🟡PDF부분+표준 · 🔴PDF미수록(가설).

---

## 1. 9속성 의미축 — 각 속성이 "무슨 의미를 인코딩하는가"

DB 매핑 감사(dbm-mapping-audit)의 9속성을 **의미축**으로 재정의(L1/L2 교훈: 속성별 단일컬럼 평면화가 의미축 drop의 뿌리).

| # | 속성 (DB 테이블) | 의미축 | 핵심 구분(평면화 금지) | 권위 코드 | 확정도 |
|---|---|---|---|---|:---:|
| 1 | **size** (`_sizes`) | **재단치수**(고객 선택 완성품 치수) | ≠ 작업사이즈(plate). 비치수(`사용자입력`)=nonspec 범위 | `t_siz_sizes`, nonspec_*_min/max | ✅ |
| 2 | **material** (`_materials`) | **자재**(종이/소재/부속) + **usage_cd 슬롯**(.01내지/.02표지/.03면지/.07공통) + **두께**(아크릴 mm) | `*별도설정`=IMPORT 포인터(빈값 아님). 두께=자재 식별자. 복합표기(`아트250+무광코팅`)=자재+공정 분해 | MAT_TYPE 11종, USAGE 7종 | ✅ |
| 3 | **print_option** (`_print_options`) | **인쇄면 도수**(단면/양면 front·back color count) | ≠ UV변형(별도 §3). 별색≠도수(별색=공정) | (front/back colrcnt) | ✅ |
| 4 | **process** (`_processes`) | **공정**(코팅·제본·박·형압·완칼·봉제·타공·족자·부착·에폭시) + prcs_dtl_opt param | 줄수/개수/조각수=공정 신호(옵션값 아님). 별색=공정 | `t_proc_processes` 83행 | ✅ |
| 5 | **process_excl_group** (`_process_excl_groups`) | **공정 택일그룹**(상품별, SEL_TYPE.01 단일) | 헤더+멤버 FK(excl_grp_cd) 둘 다 필요. 책자제본·캘린더가공만 | GRP-BOOK-제본·GRP-CAL-가공 | ✅ |
| 6 | **plate_size** (`_plate_sizes`) | **작업/전지 판형**(임포지션·판걸이) | 재단치수(size)와 별개 축. 돔보·판걸이수 | OUTPUT_PAPER_TYPE 3종 | ✅ |
| 7 | **bundle_qty** (`_bundle_qtys`) | **묶음수**(권/세트, 떡제본 50장1권) | 페이지(page_rule)와 다른 도메인. QTY_UNIT.03 권 | QTY_UNIT | ✅ |
| 8 | **page_rule** (`_page_rules`) | **페이지 규칙**(내지 min/max/증가) | 책자·노트 내지 전용. 떡제본·낱장엔 무의미(잡음 주의) | page_min/max/incr | ✅ |
| 9 | **addl_product** (`_addons`) | **추가상품**(완제 부속: 거치대·우드봉·볼체인) | 부착공정(process)과 축 분리. 색상=variant인지 N개 addon인지 | `t_prd_product_addons` | ✅ |

### 1-1. 의미축 평면화 결함 패턴 (L1/L2 교훈 — 횡단)

전 시트에서 반복된 "의미축 drop" 4유형(_summary §2):

1. **size↔plate 혼동**(goods-pouch G-GP-2): 작업사이즈(plate)만 적재, 재단치수(size) 77상품 누락.
2. **자재축에 공정 섞임**(photobook G-PB-3·stationery G-ST-4): `아트250+무광코팅`을 단일 자재로 — 코팅(공정) 미분해.
3. **인쇄면에 UV변형 섞임**(acrylic G-AC-5): `배면양면/풀빼다`를 print_side에 — UV공정(§3) 자리에 가야 함.
4. **size축에 형상 enum drop**(sticker G-SK-2): 도형/치수 enum(원형 25~90mm)이 어느 축에도 없음.

> **공통 뿌리:** 한 엑셀 컬럼이 2개 의미축을 담을 때(복합표기·variant·UV변형), 단일 DB 컬럼에 평면화하며 한 축이 소실. **위젯 옵션 캐스케이드는 이 의미축이 분리돼야 구동.**

---

## 2. variant 의미축 — 색상 vs 사이즈 vs 두께 vs 표지타입

> 사용자 질문 연계(B2 variant 분해). variant = "한 상품의 선택 가능 변형"인데, **어느 차원으로 가는지**가 갈린다.

| variant 유형 | 의미축 | 가야 할 DB 차원 | 현 적재 실태 | 확정도 |
|---|---|---|---|:---:|
| **색상 variant**(머그 화이트/반투명/투명, 만년스탬프 7색) | 자재 색상 | material(자재 코드 분기) | 머그(193) material=4 정상 적재 | ✅ |
| **사이즈 variant**(거울 S/M/L, 티셔츠 M/L/XL) | 재단치수 | **size** | 티셔츠(206) size=0, material에 평면화(G-GP-3) | 🟡(컨펌) |
| **두께 variant**(아크릴 1.5/3/8mm) | 자재 식별자 | material(MAT_000042/043/044) | 192 단일 일괄(두께 소실 G-AC-3) | ✅(결함) |
| **표지타입 variant**(하드/레더하드/소프트) | 반제품 표지 | 표지 sub_prd + USAGE.02 | photobook 5종 평면 혼재(타입↔종이 G-PB-2) | 🟡(컨펌) |
| **장수 variant**(캘린더 4(8P)/8(16P)) | 페이지/선택옵션 | page_rule vs variant(미확정) | 캘린더 page_rule 0행(G-CL-5) | 🟡(컨펌) |
| **링/책등 variant**(링컬러, 책등 mm) | 공정 param/조건부 자식 | process param(고리형 선택시만) | 미적재(조건부 의존 G-CL-5) | 🟡 |

**variant 분해 원칙(L3 확정):**
- **색상→material**(자재 분기), **사이즈→size**(재단치수), **두께→material**(별도 mat_cd), **표지타입→반제품 sub_prd**.
- **복합 variant(색상×사이즈)는 2차원 분리**: 티셔츠 화이트M = material(화이트)×size(M). round-2 `component_prices` 차원과 교차.
- ⚠️ **현 적재는 복합 variant를 전부 material로 평면화** → size 차원 소실. 위젯 사이즈 선택 불가.

---

## 3. C-11 해결 — UV평판인쇄·화이트/별색 용도·사용처

> 사용자 핵심 질문: UV평판인쇄가 무엇이고 어떤 상품에 쓰나. 화이트/클리어/금/은 별색이 각각 어디에·왜 쓰나.
> 권위: PDF 주문프로세스 p3·p7·p8 + DB `PROC_000002`(UV)·`PROC_000007`(별색 family) + 표준(UV flatbed·spot white).

### 3-1. UV평판인쇄(PROC_000002) — 정의·용도·사용처

**정의(✅PDF p3·p8):** UV평판출력 = UV 경화 잉크 평판 인쇄. 접수파일 PDF/PDF+레이저커팅AI. 담당=쿠마샵(외주)·UV인쇄(단품/아크릴).

**사용처(✅PDF 17 Case + KB):**
- Case10 UV단품, Case11 투명클립보드, Case12 아크릴가공 → **acrylic 상품군 전체**(UV→레이저커팅→아크릴가공).
- goods-pouch 일부 리지드 굿즈.

**왜 UV인가(🟡표준 교차):** UV flatbed는 **아크릴·유리·금속·PVC 등 리지드/투명 평면**에 즉시 경화 인쇄. 표준상 **아크릴이 가장 대표적 UV flatbed 소재**(매끈한 표면, 균일 잉크 접착). → 후니가 아크릴 굿즈를 UV로 운영하는 도메인 근거 확보.

**UV 변형 enum 5종(L2 §1-1 + 표준):** 일반/배면양면/풀빼다/투명테두리/단면. 투명 아크릴에서 **배면양면·풀빼다(화이트 베이스)**가 핵심 — 표준의 "투명소재 다층(CMYK+화이트+CMYK) 인쇄"와 정합. ⚠️ 현재 print_side 오적재(G-AC-5) → process(PROC_000002 `변형`)로 옮기는 게 의미축 정합.

### 3-2. 별색인쇄(PROC_000007 family) — 화이트/클리어/핑크/금/은 각 용도

**정의(✅DB Decision 12 "잉크색상, 선택유형=다중"):** 별색 = CMYK 외 별도 잉크 **후공정(공정, 도수 아님)**, 다중 선택. 자식 5종(008~012).

| 별색 (자식 proc) | 용도·사용처 (PDF/DB/표준) | 확정도 |
|---|---|:---:|
| **화이트**(PROC_000008) | **투명/홀로그램/메탈 소재의 베이스 레이어.** 투명 원단은 바탕이 비쳐 CMYK가 탁해짐 → 화이트 underbase가 발색·불투명도 확보. PDF p7 Case7 "라텍스(화이트)출력=투명실사", p8 화이트인쇄. 사용처: 투명/홀로그램 스티커(053·054·056)·접착투명포스터(122)·투명아크릴 | ✅ |
| **클리어**(PROC_000009) | **투명 광택/바니시 레이어**(varnish). 부분 광택·질감(frosted)·보호막. 표준: "clear gloss로 embellishment, 화이트 저투명도+gloss로 frosted" | 🟡 |
| **핑크**(PROC_000010) | 형광/특수 핑크 별색(CMYK로 안 나오는 비비드 핑크) | 🟡 |
| **금색**(PROC_000011) | 금속 금색 잉크(메탈릭 발색). **박(foil)과 구별** — 별색금=잉크 인쇄, 박금=금형 압착 | 🟡 |
| **은색**(PROC_000012) | 금속 은색 잉크. 〃 | 🟡 |

**화이트 별색의 "왜"(✅표준 강한 근거):**
- 표준: 투명/다크/메탈 소재에 **화이트 underbase 없으면 CMYK가 탁하고 판독 불가**(muddy). 화이트가 불투명 베이스 제공.
- 투명소재 **selective transparency**: CMYK→화이트→CMYK 다층으로 양면 시안·부분 투명 제어.
- → 후니 투명/홀로그램 스티커·접착투명포스터의 화이트 별색은 **도메인상 필수**(스티커 G-SK-1·실사 G-SL-2 미적재가 결함인 이유).

**별색 vs 박 vs 도수 구별(C-11 핵심 정정):**
- **별색(공정 PROC_000007)** = CMYK 외 잉크 **인쇄**(화이트/클리어/금/은). 다중. ≠ 도수(print_side).
- **박(공정 PROC_000033)** = 금형 박색상 **압착**(금/은/홀로그램 16종). 물리적으로 별색금과 다름(잉크 vs 포일).
- **도수(print_option)** = CMYK 4도 + 별색이 5도~9도로 **늘림**(PDF p5 "5도/9도"). 별색은 도수칸이 아니라 공정칸.

### 3-3. UV 화이트 vs 별색 화이트 — 의미축 분리

표준상 화이트 잉크는 두 맥락에서 등장 — 혼동 주의:
- **UV flatbed 화이트**(PROC_000002 변형 `풀빼다`): UV 인쇄방식 내 화이트 베이스(아크릴). 인쇄방식 옵션.
- **별색 화이트**(PROC_000008): 별색인쇄 공정의 화이트(투명 스티커/포스터). 후공정.
- → 둘 다 "투명소재 위 화이트 베이스" 원리는 같으나, **DB 인코딩 위치가 다름**(UV=인쇄방식 변형 / 별색=별색공정). 상품의 인쇄방식이 UV면 변형으로, 디지털/실사면 별색공정으로. 🟡 실무 컨펌(B4).

---

## 4. C-9 해결 — 생산방식(셋트/반제품 vs 단일/완제품)

> L2 §4에서 11 상품군 매핑 완료. 본 절은 **의미축 관점 요약**(중복 최소).

**3구조(라이브 권위, booklet 반전):**
- **A 통합상품**: 내지/표지 단일행 캐스케이드, 자재=parent+usage_cd, sets=0(정상). 일반 책자(068~071)·노트.
- **B 셋트상품**: 표지/면지=반제품 sub_prd(빈 껍데기), sets로 연결, 자재=여전히 parent+usage_cd. 하드커버·포토북.
- **C 완제품/단일**: 내지/표지 개념 없음. 낱장·굿즈·대형.

**왜(도메인 인과):** 표지가 **별도 생산라인(하드보드+싸바리/레더 반제품)**이면 B 셋트, 표지도 종이 디지털출력이면 A 통합. → 반제품 분해는 **하드커버·포토북에 국한**.

**의미축 함의(자재 권위 위치):** B 셋트라도 **자재 권위는 parent + usage_cd**(sub_prd 아님). 적재 감사에서 sub_prd 9속성 0행은 **정상**(빈 껍데기), parent usage_cd 0행이 **결함**(booklet 내지종이 G-BK-1).

**→ C-9 해결:** 생산방식 3구조 확정 + 자재 권위 위치 확정. 잔여 컨펌 = "통합상품 4종을 향후 sub_prd 분해할 것인가"(booklet Q2, 현 모델은 parent-적재).

---

## 5. C-10 해결 — 제본 종류별 차이 (레이플랫 vs PUR)

> L2 §3에서 제본 8종 차이·필요 기초데이터 표 완료. 본 절은 **결론 요약 + 의미축**.

**제본별 필요 기초데이터 차이(✅):**
- **트윈링** → 링컬러·D링mm·방향·타공(링 정보 필수).
- **하드커버** → 표지/면지 반제품(USAGE.02/.03), 책등.
- **무선/PUR** → 책등(mm), 페이지 규칙.
- **떡제본** → 묶음수(권), 페이지 무의미(page_rule 잡음 주의).
- **중철** → 페이지 4배수, 책등 없음.

**레이플랫 vs PUR 결론(C-10 핵심):**
- **사실:** 라이브·엑셀 모두 포토북=**PUR**(PROC_000020). 레이플랫(PROC_000025)=**적재 0건, 마스터 정의만**.
- **표준:** 레이플랫=gutter 없는 완전 평탄(파노라마 무손실, 보드/특수힌지). PUR=perfect binding, gutter 이미지 손실·중앙 휨(반복사용 시 다소 이완). **물리적으로 다른 제본.**
- **결론(단정 금지):** 표준은 포토북에 레이플랫 우위를 알려주나, **후니 운영 사실(PUR)이 권위**(HARD). 가설①(유력): 후니는 실제 PUR 운영, 레이플랫은 미운영 마스터. → **실무 컨펌 1순위**: "후니 포토북 제본=PUR인가 레이플랫인가? 025는 미운영인가?"
- **→ C-10 해결:** 제본 8종 차이·필요 기초데이터 확정. 레이플랫vsPUR는 **도메인 충돌로 정확 분류**(결함 아님, 미확정). 표준이 물리차를 보강했으나 후니 사실을 뒤집지 않음.

---

## 6. 의미코드맵 — 엑셀 표기 → 의미축 → DB 코드 (요약)

| 엑셀 표기 패턴 | 의미축 | DB 인코딩 | 함정 |
|---|---|---|---|
| `*별도설정` | 자재(IMPORT 포인터) | material + IMPORT 매핑 | 빈값 아님 — 제외 시 종이옵션 소멸 |
| `아트250+무광코팅` | 자재+공정 복합 | material(아트250)+process(PROC_000015) | 단일 자재 평면화 금지 |
| `배면양면/풀빼다/투명테두리` | UV 변형 | process(PROC_000002 `변형`) | print_side 오적재 금지 |
| `화이트인쇄(단면)` | 별색 공정 | process(PROC_000008) | 인쇄옵션 텍스트로 오해 금지 |
| `1줄/2줄`·`N구`·`N조각` | 공정 신호+param | process+prcs_dtl_opt | 옵션값으로 오해→공정행 누락 금지 |
| `제본사양` enum | 제본 공정 | process(PROC_000017 family)+excl_group | enum→공정 변환 필수 |
| 거울 S/M/L·티셔츠 M/L/XL | 사이즈 variant | size | material 평면화 금지 |
| 머그 화이트/투명 | 색상 variant | material 분기 | (정상) |
| `사용자입력` | 비치수 | nonspec_*_min/max | size 0행만 두면 검증 불가 |

---

## 7. 미해소 3건 해결 요약 (C-9/10/11)

| ID | 미해소 | 해결 여부 | 근거 | 잔여 컨펌 |
|---|---|---|---|---|
| **C-9** 생산방식 | 셋트/반제품 vs 단일/완제품 구분 | **해결**(3구조 A/B/C 확정, 11군 매핑) | 라이브 booklet/photobook + PRD_TYPE + sets | 통합상품 향후 sub_prd 분해 여부 |
| **C-10** 제본차이 | 제본별 차이·필요 기초데이터·레이플랫vsPUR | **해결**(8종 차이·기초데이터 표 + 레이플랫vsPUR 충돌 분류) | DB PROC_000017 family + PDF Case4/5/5b + 표준 | 포토북 PUR/레이플랫 사실 컨펌(1순위) |
| **C-11** UV/별색 | UV용도·화이트/클리어/금/은 별색 용도 | **해결**(UV=아크릴 리지드·변형 5종 / 별색 5종 각 용도) | DB PROC_000002·007 + PDF p3/p7/p8 + 표준(UV flatbed·spot white) | UV화이트 vs 별색화이트 인코딩 위치 통일(B4) |

> **표준=보조·후니=권위 준수:** 표준은 ① UV flatbed 아크릴 적합성 ② 화이트 underbase 필수성 ③ 레이플랫 gutter-free 원리 — **물리/원리를 보강**했고, 후니 운영 사실(PUR 포토북·UV 아크릴·화이트별색)과 **정합**. 충돌(레이플랫)은 단정 않고 컨펌으로 남김.

---

## Sources (표준 리서치 — WebSearch 검증, 보조 권위)

**제본(lay-flat vs PUR / Wire-O):**
- [Graphic Finishing Services — Perfect Binding vs Lay-Flat Binding](https://www.gfsmn.com/insights/perfect-binding-vs-lay-flat-binding-comparison)
- [Milk Books — Our Binding Process (lay-flat board pages)](https://www.milkbooks.com/blog/getting-started/our-binding-process/)
- [Photobook Press — Layflat vs Perfect Binding](https://photobookpress.com/blogs/news/layflat-vs-perfect-binding-which-to-consider)
- [Saal Digital — Layflat Photo Book Binding Types](https://www.saal-digital.eu/blog/photo-book/layflat-photo-book-binding-types/)
- [Printing Center USA — Spiral vs Wire-O Binding](https://www.printingcenterusa.com/blog/spiral-binding-vs-wire-o-binding/)
- [Nancy Starkman — Wire-O bindings hardcover/softcover](https://nancystarkman.com/wire-o-bindings/)

**UV flatbed 인쇄·화이트 잉크·프라이머:**
- [Andresjet — Why White Ink Is Essential in UV Flatbed Printing](https://www.andresjet.com/blogs/info/why-is-white-ink-essential-in-uv-flatbed-printing)
- [Custom Made Better — Best Materials for UV Flatbed Printing (acrylic)](https://www.custommadebetter.com/blogs/cmb-acrylic/best-materials-for-uv-flatbed-printing)
- [Boston Industrial Solutions — UV Printing Primers](https://bostonindustrialsolutions.com/blog/improving-uv-ink-adhesion-with-uv-printing-primers/)

**별색 화이트/클리어 (투명소재):**
- [The Print Reviewer — White Ink, Clear Materials, and Spot Colors](https://printreviewer.com/white-ink-clear-materials-and-spot-colors-beginners-guide/)
- [LogoJET — UV Printing with White Ink](https://www.logojet.com/blogs/blog-articles/uv-printing-with-white-ink)
- [Sundance — Guide to Using White Ink in Print and Packaging](https://sundanceusa.com/blog/white-ink-guide/)
- [Avery — White Underprint for clear/coloured labels](https://www.avery.co.uk/blog/tips/white-underprint-guidelines-for-labels)

> **후니 권위(1순위, 표준보다 상위):** `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf`(17 Case 공정플로우·14 공정팀)·
> `docs/huni/후니프린팅_주문프로세스_20251001.pdf`(p3 인쇄타입·p5 조판·p6 파일명·p7 클레임·p8 인쇄타입별 파일) +
> 라이브 Railway DB(`07_domain/db-domain-structure-live.md`).
