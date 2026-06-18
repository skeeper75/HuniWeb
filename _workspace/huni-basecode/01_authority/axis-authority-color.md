# 축별 정답 사전 — ③ 도수 (`t_clr_color_counts`)

> **하네스** hbg (기초코드 권위 큐레이터) Phase 1 · 2차 회차. **작성** 2026-06-18.
> **지위:** 진단가(`hbg-basecode-diagnostician`)의 기준선. 본 문서는 **도수 마스터 축**(`t_clr_color_counts`)의 정답이다.
>
> **권위 순서 [HARD]:** ① 상품마스터 `후니프린팅_상품마스터_260610.xlsx` + 가격표(명시값=정답)
> → ② 라이브 t_* 설계의도 `00_schema/schema-design-intent-map.md`(§2.2 t_clr WHY·§3 #4·#5·OM-5) + `32_axis-staged-load/01 §3`(도수 규칙) + `entity-semantic-model §3.2`
> → ③ 인쇄 도메인 + rpmeta 역공학 `04_vessel/vessel-print-method-recipe.md`·`benchmark-competitors §7`
> → ④ 경쟁사(갭헌팅 전용) RP `dosu`/`PRT_WHT`·WowPress `colorno`+`addtype`·CIP4 ColorantControl. ③④는 권위 빈칸/모호분에만 개입, 권위를 덮어쓰지 못한다.
>
> **라이브 행수 권위:** `schema-design-intent-map §0` = **`t_clr_color_counts` 5행**(고정 SEED·신규 발급 사실상 없음). 추가 DB 접속 없음.
> **확정도 범례:** **확정**(권위 엑셀 명시 또는 라이브 실측) · **가설**(권위 침묵·도메인 유추, 출처+컨펌ID 부착) · **컨펌**(사용자 결정 필요).

---

## 0. 도수 축 정의 (무엇이 이 축에 속하는가)

`t_clr_color_counts` = **잉크 색 채널 수**(ink color count)만. `chnl_cnt` 0~4(물리 상한). **5행 고정 SEED**.
판별 단일 기준: **"이 색이 CMYK 프로세스 채널인가, 그 외 별도 잉크인가?"** — CMYK 채널수면 도수(clr). CMYK 외 별도 잉크(화이트/형광/메탈/바니시)면 **별색 공정**(도수 아님).
(출처: `01 §3.1` · `schema-design-intent-map §2.2` · `entity-semantic-model §3.2`)

핵심 컬럼: `clr_cd` PK(`CLR_` 순차) · `clr_nm`(도수명) · `chnl_cnt`(채널수).

---

## 1. 도수 5종 SEED 정답 사전 (소속 t_* = `t_clr_color_counts`, 코드 도메인 = CLR)

> 5행 고정. 신규 발급 없음(채널수 도메인 폐쇄·0~4 물리 상한). 진단가는 라이브가 정확히 이 5행인지만 확인.
> (출처: `01 §3.1` 라이브 실측 · `schema-design-intent-map §2.2`·`§4 OM 경계표 line 352`)

| 코드값 | 올바른 의미 (정답) | `chnl_cnt` | 소속 t_* | 코드 도메인 | 권위 출처 | 확정도 |
|--------|-------------------|:----------:|----------|-------------|-----------|--------|
| `CLR_000001` | **인쇄안함** (단면 시 뒷면도수 기본값) | 0 | `t_clr_color_counts` | CLR | `01 §3.1` 라이브 실측 · `§3.2` 단면=back CLR_000001 | 확정 |
| `CLR_000002` | **1도 흑백** (단색) | 1 | `t_clr_color_counts` | CLR | `01 §3.1` 라이브 실측 | 확정 |
| `CLR_000003` | **2도** | 2 | `t_clr_color_counts` | CLR | `01 §3.1` 라이브 실측 | 확정 |
| `CLR_000004` | **3도** | 3 | `t_clr_color_counts` | CLR | `01 §3.1` 라이브 실측 | 확정 |
| `CLR_000005` | **CMYK 4도** (default) | 4 | `t_clr_color_counts` | CLR | `01 §3.1` 라이브 실측 | 확정 |

---

## 2. 도수 오염 경계 (도수 칸에 무엇을 넣으면 안 되는가) [HARD]

> 가장 중요한 경계. 별색·UV·단/양면을 도수와 혼동하면 안 된다.
> (출처: `01 §3.1 오염 금지`·`schema-design-intent-map §2.2 line 352`·OM-5)

| 오적재된 값 | 무엇인가 | 올바른 정답 축 / t_* | 정답 근거 | 확정도 |
|-------------|----------|----------------------|-----------|--------|
| **별색** (화이트/클리어/핑크/금/은) | 별색 공정 잉크 | **⑤ 공정** `t_proc_processes`(`PROC_000007` family, `clr_cd=NULL`) | [HARD] 별색=공정·도수 아님. CMYK4도+별색="5도/9도"로 늘지만 DB 인코딩 위치는 공정칸 · `01 §3.1` · OM-5 | 확정 |
| **UV 변형** (배면양면/풀빼다) | UV 공정 param | **⑤ 공정** `PROC_000002` 변형 param. print_side 오적재 금지 | OM-5 · `01 §3.1` | 확정 |
| **단/양면** (인쇄면 앞/뒤) | 인쇄면 | **(인쇄옵션)** `t_prd_product_print_options.print_side`. 도수 *마스터*는 채널수만 | `01 §3.1` 단/양면 혼동 금지 · `axis-authority-printoption.md §1` | 확정 |
| **박** (금/은/홀로) | 금형 압착 포일 공정 | **⑤ 공정** `PROC_000033` family. 별색금 ≠ 박금 | `entity-semantic-model §3.2` 별색 vs 박 vs 도수 3분 · Q2 | 확정 |

### 2.1 별색 vs 박 vs 도수 3분 [HARD]

(`entity-semantic-model §3.2`·`01 §3.3`)
- **별색** = 잉크 *인쇄*(PROC_000007 family 008~012, clr_cd=NULL). 화이트 underbase·금/은 잉크.
- **박** = 금형 *압착 포일*(PROC_000033 family). 별색금 ≠ 박금(다른 공정).
- **도수** = CMYK *채널수*(clr, 본 축). 0~4.

→ "별색금/박금/4도" 셋을 한 칸에 섞지 말 것. 셋 다 다른 t_*.

---

## 3. clr_cd → print_opt_cd 연결 (도수 마스터 vs 상품연결행)

> ★ 도수 *마스터*(이 축, 5행 고정)와 **상품연결행**(`t_prd_product_print_options`, 별도 사전 `axis-authority-printoption.md`)을 구분.

| 분류 | 올바른 의미 | 소속 t_* | 권위 출처 | 확정도 |
|------|------------|----------|-----------|--------|
| 도수 마스터(이 축) | 5행 SEED. 엑셀에서 **신규 적재 안 됨**(완비) | `t_clr_color_counts` | `01 §3.2` | 확정 |
| 상품 도수 연결 | 엑셀 `인쇄>도수`(4도/CMYK·1도)는 **상품연결행** `front_colrcnt_cd`/`back_colrcnt_cd`(opt_id별)로 가서 CLR_000001~005 참조 | `t_prd_product_print_options` | `01 §3.2` · `schema-design-intent-map §1.2 OPT_REF_DIM.06` | 확정 |
| 단면 뒷면도수 | 단면 시 뒷면도수 = `CLR_000001`(인쇄안함) | `t_prd_product_print_options.back_colrcnt_cd` | `01 §3.2·§3.3` note 권위 | 확정 |

> **[HARD] 도수 option_items 참조 = `OPT_REF_DIM.06` → `opt_id`** (NOT clr_cd). 설계 MISMATCH-1 정정이 라이브 반영(`schema-design-intent-map §1.2`). 즉 CPQ 도수 옵션은 print_options 행(opt_id)을 가리키지 clr_cd를 직접 안 가리킨다.

---

## 4. 잉크색(자재 유입분)과의 관계 — 모호분

> ④자재 사전 §2.1에서 "잉크색은 자재 아님 → 도수 또는 별색공정 또는 옵션"으로 넘긴 항목. **권위 침묵 — 가설+컨펌**.

| 케이스 | 가설 (정답 후보) | 소속 t_* | 권위 출처 | 컨펌ID | 확정도 |
|--------|------------------|----------|-----------|--------|--------|
| 만년스탬프 잉크색 7종·볼펜색(빨강 5cc) | 별색공정 vs 자유옵션 vs 도수 — **설계 결정 필요** | (미확정) | `schema-design-intent-map §5.5` · `01 §3.3`·AX-1 · `attribute-entity-map §5` | **AX-1** | 가설(컨펌) |

> **판별 단서:** "CMYK 채널수면 도수 / CMYK 외 별도 잉크면 별색공정 / 고객이 자유선택하는 색 목록이면 옵션."
> 만년스탬프 7색은 CMYK 채널수가 아니라 *고른 단색 잉크* → 도수 칸 아님이 거의 확실. 단 별색공정 vs 자유옵션 갈림은 AX-1 컨펌 대기.
> **[HARD] 잉크색은 절대 ④자재 아님.** ④자재 사전 §2.1·§3 잉크색 행과 정합(이 축이 흡수 목적지 후보).

---

## 5. 삼중 바인딩 (도수가 어디에 귀속되는가) [HARD]

> `schema-design-intent-map §3` #4(인쇄방식/도수) 인용(재유도 금지).

| 측면 | 도수 귀속 | 출처 |
|------|-----------|------|
| **① UI 바인딩 (componentType)** | `option-button`(단/양면, 4도/1도 선택) | `schema-design-intent-map §3` #4 |
| **② 생산 바인딩 (BOM·MES)** | 단/양면 인쇄 = 인쇄팀. 도수=인쇄 채널수(CMYK 판) | `§3` #4 |
| **③ 가격 바인딩 (가격엔진)** | 인쇄비(PRC_COMPONENT_TYPE.01). `t_prc_component_prices.clr_cd` 차원(NULL 허용=도수 무관) | `§3` #4 · `schema-design-intent-map §1.3` |

> **귀속을 가르는 실례:** 단/양면 vs 별색 — 둘 다 "인쇄 색상"이나 ① 단/양면=`option-button`/도수(opt_id) · 별색=`large-color-chip`/공정(PROC_000007, clr_cd=NULL). ②③가 달라 환원 t_*가 갈린다(`schema-design-intent-map §3.2`).

---

## 6. 정규화 / FK (코드 도메인 거버넌스)

- **코드:** `CLR_NNNNNN` 순차. **5행 고정 — 신규 발급 사실상 없음**(채널수 도메인 폐쇄). 멱등 = (chnl_cnt) 또는 (clr_cd) 자연키.
- **FK:** `t_prd_product_print_options.front/back_colrcnt_cd` · `t_prc_component_prices.clr_cd` → `t_clr_color_counts`. NULL 허용(가격 차원에서 도수 무관 시).
- **적재 선후:** base_codes 다음(또는 병렬). **이미 완비(5행)** — 신규 적재 대상 아님. print_options·component_prices가 참조하므로 이미 선존재 충족.
- (출처: `01 §3.5·§3.6`)

---

## 7. 진단가에게 넘기는 핵심 (정답 사전 요약)

1. **도수축 = CMYK 채널수만**(5행 SEED 고정). 라이브가 정확히 CLR_000001~005인지 확인.
2. **[HARD] 별색은 도수 아님** — 화이트/클리어/금/은 별색이 도수칸(또는 clr_cd)에 들어가면 어긋남(→⑤공정 PROC_000007, clr_cd=NULL).
3. **별색 vs 박 vs 도수 3분** — 별색금 ≠ 박금 ≠ 4도. 셋 다 다른 t_*(§2.1).
4. **도수 CPQ 참조 = opt_id(OPT_REF_DIM.06)**, NOT clr_cd 직접.
5. **잉크색(만년스탬프 7색) = AX-1 컨펌** — 도수/별색/옵션 미확정. 단 도수 칸은 거의 아님(CMYK 채널수 아님).
6. **단/양면 ≠ 도수** — 인쇄면은 print_options.print_side(별도 사전).
