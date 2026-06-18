# 축별 정답 사전 — ② 사이즈 (`t_siz_sizes`)

> **하네스** hbg (기초코드 권위 큐레이터) Phase 1 · 2차 회차. **작성** 2026-06-18.
> **지위:** 진단가(`hbg-basecode-diagnostician`)의 기준선. "라이브 사이즈 행이 정답과 어긋났는가"를 판정하려면
> 먼저 이 사전이 정답을 못박아야 한다. 본 문서는 **사이즈 마스터 축**(`t_siz_sizes`)의 정답이다.
>
> **권위 순서 [HARD]:** ① 상품마스터 `후니프린팅_상품마스터_260610.xlsx` + 가격표 `후니프린팅_인쇄상품_가격표_260527.xlsx`(명시값=정답)
> → ② 라이브 t_* 설계의도 `00_schema/schema-design-intent-map.md`(§2.1 사이즈 WHY·§3 #1·#2 삼중바인딩·OM-1/OM-2/OM-3) + `32_axis-staged-load/01 §2`(사이즈 규칙)
> → ③ 인쇄 도메인 + rpmeta 역공학 `04_vessel/vessel-shape-axis.md`(V-12 형상↔칼틀)·`vessel-quantity-size-pricing.md`
> → ④ 경쟁사(갭헌팅 전용) WowPress `non_standard`·RP `pdt_size_info`·CIP4 Media/TrimSize. ③④는 권위 빈칸/모호분에만 개입, 권위를 덮어쓰지 못한다.
>
> **라이브 행수 권위:** `schema-design-intent-map §0` = **`t_siz_sizes` 500행**(2026-06-06 재실측, ref-csv 497). `01 §2`=510(del 53·impos_yn=Y 79). 추가 DB 접속 없음.
> **확정도 범례:** **확정**(권위 엑셀 명시 또는 라이브 실측) · **가설**(권위 침묵·도메인 유추, 출처+컨펌ID 부착) · **컨펌**(사용자 결정 필요).

---

## 0. 사이즈 축 정의 (무엇이 이 축에 속하는가)

`t_siz_sizes` = **물리 치수만**. 한 마스터에 **두 치수 축이 공존**(이중축):
- **작업치수**(`work_width/work_height`) = 블리드 포함, 인쇄·재단 전 출력 치수.
- **재단치수**(`cut_width/cut_height`) = 고객이 고르는 완성품 치수.
- **여백**(`margin_*`) = 작업−재단 차(도련/블리드, 보통 1~5mm, 자동 도출).
- **`impos_yn`** = 조판(임포지션) 가능 여부.

판별 단일 기준: **"이 값이 mm 물리 치수인가?"** — Yes면 siz. No(색·형상·수량·재질)면 다른 축으로 분리.
(출처: `01 §2.1` · `schema-design-intent-map §2.1` · `entity-semantic-model §1.1`)

핵심 컬럼: `siz_cd` PK(`SIZ_` 순차 surrogate) · `work_*`/`cut_*`/`margin_*`(치수) · `impos_yn` · `note`(판걸이/전지/적용 메타 보존) · `tags` jsonb.

---

## 1. 사이즈 3축 구분 정답 사전 (work / cut / plate)

> ★ 핵심: 같은 물리 사이즈라도 **세 가지 역할 슬롯**으로 나뉜다. 진단가가 가장 자주 혼동하는 경계.
> (출처: `schema-design-intent-map §2.1`·`§3` #1·#2 · `01 §2.1·§2.3` · `platesize-is-output-paper` 메모리)

| 코드값/분류 | 올바른 의미 (정답) | 소속 t_* | 코드 도메인 | 권위 출처 | 확정도 |
|------------|-------------------|----------|-------------|-----------|--------|
| `work_width` / `work_height` | **출력(작업) 치수** — 블리드 포함, 인쇄·재단 전. 상품연결은 `t_prd_product_plate_sizes`(출력판형) | `t_siz_sizes` | (치수 슬롯) | 상품마스터 `파일사양>작업사이즈` C8 · `01 §2.2` · `schema-design-intent-map §2.1` | 확정 |
| `cut_width` / `cut_height` | **완성(재단) 치수** — 고객이 고르는 완성품. 상품연결은 `t_prd_product_sizes` | `t_siz_sizes` | (치수 슬롯) | 상품마스터 `사이즈(필수)`/`재단사이즈` C5/C9 · `01 §2.2` | 확정 |
| `margin_*` (도련) | 작업−재단 차의 도련/블리드. **자동 도출**(별 컬럼 약함) | `t_siz_sizes` | (치수 슬롯) | 상품마스터 `파일사양>블리드` · Q14(자동 도출) · `01 §2.2` | 확정(도출) |
| `impos_yn` (조판가능) | 임포지션(조판) 가능 여부. impos=Y 79행(`01 §0` 실측) | `t_siz_sizes` | YN | `schema-design-intent-map §2.1` · `01 §0` | 확정 |
| **출력판형** (국4절/3절/전지) | **작업치수(work_*) 슬롯을 쓰지만 상품연결은 별 축** `t_prd_product_plate_sizes`(siz_cd, `output_paper_typ_cd`). 완성품 size 아님 | `t_siz_sizes`(마스터) + `t_prd_product_plate_sizes`(연결) | OUTPUT_PAPER_TYPE | `schema-design-intent-map §2.1`·`§3` #2 · `platesize-is-output-paper` 메모리 · 국4절=SIZ_000499(316x467) | 확정 |
| **판걸이수**(판수) | **siz에 적재 안 함 — 앱 런타임 계산**(임포지션/네스팅). note 텍스트 보존만(`SIZ_000001` note=`판걸이=18.0`) | (DB 미저장) | — | `01 §2.3`·round-11 C6 · `compute-in-app-db-stores-lookup` 메모리 · `schema-design-intent-map §3.2 #2` | 확정 |

### 1.1 라이브 note 구조 (메타 보존 — 정규 컬럼 아님)

`SIZ_000001` note = `판걸이=18.0 / 전지=316x467 / 적용=엽서`. 판걸이수·전지(출력판형)·적용상품이 **note에 텍스트로** 보존됨.
가격엔진·임포지션은 이 note를 파싱하지 않고 **앱이 런타임 계산**한다. → note 값은 진단 기준 아님(앱 계산 입력일 뿐).
(출처: `01 §2.2 라이브 note 구조`)

---

## 2. 사이즈 오염 경계 (siz_nm에 무엇을 인코딩하면 안 되는가) [HARD]

> 이 표가 진단가의 핵심 룩업 — "이 siz 행이 진짜 치수인가, 아니면 다른 축 값이 치수로 위장했는가."
> (출처: `schema-design-intent-map` OM-1/OM-2/OM-3·`§2.1 anti-pattern` · `01 §2.1 오염 금지`)

| 오적재된 값 (라이브 siz 예) | 무엇인가 | 올바른 정답 축 / t_* | 정답 근거 | 확정도 |
|-----------------------------|----------|----------------------|-----------|--------|
| 색상 (`SIZ_000104`="화이트165x115mm"·`SIZ_000105`="블랙") | 본체색 | **④ 자재** `t_mat_materials`(본체색=재질행 합성) 또는 옵션 variant. siz=165x115만 | OM-1 대표 위반(PRD_000004 카드봉투) | 확정 |
| 형상 (원형/하트/별 enum) | 형상 | **② 사이즈 칼틀**(합판도무송=siz_cd 1:1 Q7) / **규격형 반칼/완칼=공정 param** | OM `size축에 형상` · Q7 · `schema-design-intent-map §3.2` 형상 분기 | 확정 |
| 수량 (10장) | 묶음/주문수량 | **묶음수** `t_prd_product_bundle_qtys` 또는 주문수량 | `01 §2.1` 수량 인코딩 금지 | 확정 |
| 출력판형(전지/절수)을 완성품 size로 | 출력판형 | **판형축** `t_prd_product_plate_sizes`(완성품 size와 별 연결축) | `01 §2.1` · §1 본 사전 | 확정 |
| 비규격 연속범위(실사 `사용자입력`) | 입력 UX 한계 | `t_prd_products.nonspec_*_min/max`(siz 이산 행 아님) | OM-3 · `01 §2.3 비규격` | 확정(가격은 AX-3) |

### 2.1 형상 ↔ 칼틀 귀속 분기 [HARD] (일률규칙 금지)

**"형상은 무조건 공정" 일률규칙은 틀림.** 칼틀 물리존재 여부로 귀속이 갈린다(`schema-design-intent-map §3.2`):
- **칼틀 물리존재**(합판도무송) → 형상=**`t_siz_sizes` siz_cd가 칼틀 식별자 1:1**(Q7). 칼선 자동 도출. 공정 prcs_dtl_opt에 중복 금지.
- **규격형 반칼/완칼**(칼틀 없음) → 형상=**⑤ 공정 param**(완칼 PROC_000053 `{"모양"}`·반칼 PROC_000054).

(출처: `schema-design-intent-map §3.2`·`01 §2.1`·`§5.3 형상 귀속 분기` · ④자재 사전 §2.1 형상 룩업과 정합)

---

## 3. 비치수 size / 면적매트릭스 좌표 경계 (굿즈·실사) — 모호분

> 굿즈/파우치의 비치수 size, 실사의 면적매트릭스 좌표는 권위가 침묵·모호하다. **가설+컨펌ID로 분리**(추정 단정 금지).

| 케이스 | 가설 (정답 후보) | 소속 t_* | 권위 출처 | 컨펌ID | 확정도 |
|--------|------------------|----------|-----------|--------|--------|
| 굿즈파우치 사이즈등급(M/L/XL)·폰기종 | 치수형 22=size 유지 / 옵션형 202=CPQ option 이동(기계적 삭제 금지·사슬 보존) | `t_prd_product_sizes` ↔ `option_items` | OM-2 · round-10 변경추적(448셀 size→option) | **AX-2** | 가설(컨펌) |
| 실사/현수막 비규격 사이즈 | 입력 UX=`nonspec_*` 범위 / 가격·유효성=포스터사인 **이산 면적매트릭스 셀**(좌표 siz 채번) + off-grid ceiling(앱) | `t_prd_products.nonspec_*` + `t_prc_component_prices.siz_cd` | OM-3 · `schema-relationship-analysis §5` open · round-23 신안(siz_width/height 구간 차원) | **AX-3** | 가설(컨펌) |
| 면적매트릭스 좌표 siz vs 구간 차원 | round-23 신안 = 좌표 siz 채번 폐기 → `siz_width/siz_height` 구간 차원(본체 comp use_dims). 고정가형(A시리즈)은 siz_cd 이산 유지 | `t_prc_component_prices`(siz_width/height) | round-23 [[dbmap-area-matrix-wh-dimension]] 메모리(라이브 COMMIT됨) | **AX-3 후속** | 가설(라이브 진화 반영) |

> **판별 규칙:** "이 값이 *mm 물리 치수*인가?" Yes→siz / "비규격 *연속범위*인가?"→nonspec_* / "면적 가격 *격자 셀*인가?"→component_prices siz 차원.
> 입력 UX(사이즈 격자) ≠ 가격 격자 — 둘을 혼동하면 OM-3 재발([[dbmap-l2-requires-l1-price-table]]).

---

## 4. 삼중 바인딩 (사이즈 구성요소가 어디에 귀속되는가) [HARD]

> `schema-design-intent-map §3` #1(완성품)·#2(출력판형) 인용(재유도 금지). 같은 치수가 잘못된 역할 슬롯에 가는 위험 차단.

| 측면 | 완성품 사이즈 (#1) | 출력판형 (#2) | 출처 |
|------|--------------------|----------------|------|
| **① UI 바인딩 (componentType)** | `option-button`(이산 ≤6) / `dimension-matrix-input`(면적형) | 보통 미노출(`OPT_REF_DIM.02`) | `schema-design-intent-map §3` #1·#2 |
| **② 생산 바인딩 (BOM·MES)** | 재단치수(cut_*) = 작업지시 컷 | 임포지션·판걸이 = MES 생산판(작업 work_*) | `§3` #1·#2 · `01 §2.3` |
| **③ 가격 바인딩 (가격엔진)** | 면적매트릭스형=siz가 가격 격자 셀 / 고정가형=siz가 직접단가 키 | 디지털인쇄 절수가격의 siz_cd = **판형**(완성품 아님). 국4절=SIZ_000499 | `§3` #1·#2 · `§3.1` 가격공식 4유형 |

> **귀속을 가르는 실례:** 한 물리 사이즈가 완성행(impos=Y + 판걸이 note)과 작업사이즈 중복행으로 **두 번 등록**될 수 있음(`platesize-is-output-paper`). 적재/진단 전 중복 점검 필수.
> **[HARD] `t_prc_component_prices.siz_cd` = `ON DELETE CASCADE` FK** → 가격 siz_cd는 반드시 마스터 선존재. placeholder(`SIZ_PENDING_*`)는 100% FK 위반(`schema-design-intent-map §1.3`).

---

## 5. 정규화 / FK (코드 도메인 거버넌스)

- **코드:** `SIZ_NNNNNN` 순차 surrogate(D1 비준). 멱등 키 = 치수 조합(work_w,work_h,cut_w,cut_h) 또는 `siz_nm`(치수 문자열). **같은 치수 재발급 금지**(search-before-mint — OM-1 후속 SIZ_000422 원형35mm 사례).
- **FK:** `t_prd_product_sizes.siz_cd`·`t_prd_product_plate_sizes.siz_cd` = **RESTRICT** · `t_prc_component_prices.siz_cd` = **ON DELETE CASCADE**(가격이 siz에 묶임).
- **적재 선후:** base_codes(OUTPUT_PAPER_TYPE) → sizes(완비) → products → product_sizes/plate_sizes → component_prices. 가격사슬이 CASCADE FK로 siz에 묶이므로 siz는 가격 적재 전 완비 필수.
- (출처: `01 §2.5·§2.6` · `schema-design-intent-map §1.3`)

---

## 6. 진단가에게 넘기는 핵심 (정답 사전 요약)

1. **사이즈축 = 물리 치수만.** 색/형상/수량/재질은 siz 아님 — §2 표로 목적지 축 룩업.
2. **3역할 슬롯 구분**: work(출력) vs cut(완성) vs plate(출력판형). plate는 같은 마스터의 work_* 슬롯이나 **상품연결은 `t_prd_product_plate_sizes`** 별 축.
3. **판걸이수 = DB 미저장**(앱 계산). note 보존만 — 진단 기준 아님.
4. **형상↔칼틀 1:多** — 칼틀 물리존재면 siz_cd 1:1(Q7), 규격형은 공정 param. 일률규칙 금지(§2.1).
5. **비치수/면적 좌표는 컨펌**(AX-2 size→option·AX-3 비규격 면적매트릭스) — 기계적 삭제 금지(가격사슬·FK 위상).
6. **이중 등록 점검** — 완성행 + 작업사이즈 중복행. 진단 전 중복 확인.
