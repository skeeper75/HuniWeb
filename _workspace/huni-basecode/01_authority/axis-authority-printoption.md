# 축별 정답 사전 — (인쇄옵션) `t_prd_product_print_options`

> **하네스** hbg (기초코드 권위 큐레이터) Phase 1 · 2차 회차. **작성** 2026-06-18.
> **지위:** 진단가(`hbg-basecode-diagnostician`)의 기준선. 본 문서는 **상품 인쇄옵션 연결축**(`t_prd_product_print_options`)의 정답이다.
>
> ★ **본 축은 마스터(③도수 `t_clr_color_counts`)와 별개의 상품연결행 + 인쇄면·별색/UV 라우팅이 교차하는 축**이다. ③도수·⑤공정과 경계를 정밀화해야 한다.
>
> **권위 순서 [HARD]:** ① 상품마스터(명시값=정답)
> → ② 라이브 t_* 설계의도 `00_schema/schema-design-intent-map.md`(§2.2 print_options WHY·§3 #4·#5·OM-5·§1.2 OPT_REF_DIM.06) + `32_axis-staged-load/01 §3`(도수/인쇄면)
> → ③ 인쇄 도메인 + rpmeta 역공학 `04_vessel/vessel-print-method-recipe.md`·`vessel-process-parameter.md`
> → ④ 경쟁사(갭헌팅 전용) CIP4 ColorantControl(Process vs Spot)·RP/WP colorinfo. ③④는 권위 빈칸/모호분에만 개입, 권위를 덮어쓰지 못한다.
>
> **라이브 행수 권위:** `schema-design-intent-map §0` = **`t_prd_product_print_options` 166행**(2026-06-06 재실측, ref-csv 172). 추가 DB 접속 없음.
> **확정도 범례:** **확정**(권위 엑셀 명시 또는 라이브 실측) · **가설**(권위 침묵·도메인 유추, 출처+컨펌ID 부착) · **컨펌**(사용자 결정 필요).

---

## 0. 인쇄옵션 축 정의 (무엇이 이 축에 속하는가)

`t_prd_product_print_options` = **상품별 인쇄면 도수 연결행**. "이 상품을 어느 면(단/양면)에 몇 도(앞/뒤 채널수)로 인쇄하는가"를 opt_id 행으로 표현.
이 축은 **③도수 마스터를 참조**(front/back_colrcnt_cd → CLR 5종)하지 도수값을 새로 정의하지 않는다.
(출처: `schema-design-intent-map §2.2`·`§1.2 OPT_REF_DIM.06`)

핵심 컬럼: `prd_cd` FK · `opt_id` PK(상품별 시퀀스) · `print_side`(단면/양면) · `front_colrcnt_cd`/`back_colrcnt_cd`(→`t_clr_color_counts`).

---

## 1. 인쇄옵션 구성요소 정답 사전

| 코드값/분류 | 올바른 의미 (정답) | 소속 t_* | 코드 도메인 | 권위 출처 | 확정도 |
|------------|-------------------|----------|-------------|-----------|--------|
| `opt_id` (PK) | 상품별 인쇄옵션 행 식별자(상품별 시퀀스). **CPQ 도수 옵션이 가리키는 키**(NOT clr_cd) | `t_prd_product_print_options` | opt_id(상품 시퀀스) | `schema-design-intent-map §1.2 OPT_REF_DIM.06` "도수=opt_id, NOT clr_cd" | 확정 |
| `print_side` | **인쇄면** — 단면/양면. 인쇄팀이 어느 면에 찍는가 | `t_prd_product_print_options` | (단면/양면) | `schema-design-intent-map §2.2`·`01 §3.1` 단/양면=print_side | 확정 |
| `front_colrcnt_cd` | **앞면 도수** → `CLR_000001~005` 참조 | `t_prd_product_print_options` → `t_clr_color_counts` | CLR(참조) | `schema-design-intent-map §2.2`·`01 §3.2` | 확정 |
| `back_colrcnt_cd` | **뒷면 도수** → CLR 참조. **단면 시 = `CLR_000001`(인쇄안함)** | `t_prd_product_print_options` → `t_clr_color_counts` | CLR(참조) | `01 §3.2·§3.3` note 권위 | 확정 |

---

## 2. 인쇄옵션 오염 경계 (이 축에 무엇을 넣으면 안 되는가) [HARD]

> 별색·UV·화이트/클리어 underbase를 이 축(특히 print_side, colrcnt)에 잘못 넣는 위험을 차단.
> (출처: `schema-design-intent-map §2.2`·OM-5·`01 §3.1` · `entity-semantic-model §3`)

| 오적재된 값 | 무엇인가 | 올바른 정답 축 / t_* | 정답 근거 | 확정도 |
|-------------|----------|----------------------|-----------|--------|
| **별색** (화이트/클리어/핑크/금/은) | 별색 공정 잉크 | **⑤ 공정** `PROC_000007` family(clr_cd=NULL). 도수칸/colrcnt 아님 | OM-5 · `schema-design-intent-map §2.2` "별색을 도수칸에 ✗" | 확정 |
| **UV 변형** (배면양면/풀빼다/투명테두리) | UV 공정 param | **⑤ 공정** `PROC_000002` 변형 enum param. **print_side에 ✗** | OM-5 · `schema-design-intent-map §2.2` "UV 변형을 print_side에 ✗" · `01 §5.1` 라이브 실측 | 확정 |
| **화이트/클리어 underbase** (투명/홀로 소재 하지) | 별색 공정(화이트 underbase) | **⑤ 공정** `PROC_000008`(별색 화이트). UV flatbed 화이트(`PROC_000002 풀빼다`)와 구별 | `schema-design-intent-map` line 476(SK-1/SL-2/G-SL-2 화이트별색 투명 underbase)·`§3 #5` 별색=후공정 화이트 underbase · `01 §5.3` | 확정(경계)·일괄결정 후보 |
| 인쇄방식(디지털/실사/UV) | 인쇄방식 공정 | **⑤ 공정** `PROC_000002~006`(인쇄 자식, 1상품=1방식). print_options 아님 | `schema-design-intent-map §3 #4` "인쇄방식=processes" · `process-recipe-tree §1` | 확정 |

### 2.1 화이트/클리어 underbase 정답 [HARD 경계]

투명·홀로그램 소재에 인쇄 시 발색용 **화이트 underbase**는 **별색 공정**(`PROC_000008` family)이지 print_option·자재가 아니다.
- **디지털/실사 인쇄** + 화이트 underbase → **별색 공정**(PROC_000008).
- **UV flatbed** 화이트(`풀빼다`) → **UV 공정 param**(PROC_000002 변형 enum). 별색 화이트와 다른 메커니즘.
- 판별: "인쇄방식이 UV면 변형 param / 디지털·실사면 별색 공정"(`01 §5.3`·`schema-design-intent-map §3.2`).

(일괄결정 후보 — 미회신 5시트 SK-1/SL-2/G-SL-2에도 적용 권고: `schema-design-intent-map line 476`)

---

## 3. CPQ 옵션 레이어(option_items)와의 경계 [HARD]

> 인쇄옵션 행(opt_id, L1)과 CPQ 옵션 레이어(option_items, L2)는 다른 층위. 같은 값을 양쪽에 재적재하면 안 됨.

| 분류 | 올바른 의미 | 소속 t_* | 권위 출처 | 확정도 |
|------|------------|----------|-----------|--------|
| L1 인쇄옵션 행 | 상품별 도수·인쇄면 **실 데이터**(opt_id, print_side, colrcnt) | `t_prd_product_print_options` | `schema-design-intent-map §2.2` | 확정 |
| L2 도수 CPQ 옵션 | 그 L1 행을 **가리키는 포인터**(`OPT_REF_DIM.06`, `ref_key1 = opt_id::int`). 차원값 복사 아님 | `t_prd_product_option_items` | `schema-design-intent-map §1.2·§2.4` "차원 데이터(L1)를 여기 재적재 ✗" | 확정 |

> **[HARD] L2≠L1.** option_item은 *이미 적재된* print_options 행(opt_id)을 가리킬 뿐. 도수값(4도/단면)을 option_items에 재인코딩하면 OM-6 동형 오류.
> 라이브 트리거 `fn_chk_opt_item_ref`가 ref_key1=opt_id 실재성 강제(`cpq-schema §2`).
> 현재 CPQ 옵션 레이어 **대부분 미적재**(OM-6, option_items ≈0~silsa 일부, §0 stale) — 진단가는 "미적재 vs 오적재" 구분 필요.

---

## 4. 삼중 바인딩 (인쇄옵션이 어디에 귀속되는가) [HARD]

> `schema-design-intent-map §3` #4(인쇄방식/도수)·#5(별색) 인용(재유도 금지).

| 측면 | 인쇄옵션(도수/인쇄면) 귀속 | 출처 |
|------|----------------------------|------|
| **① UI 바인딩 (componentType)** | `option-button`(단/양면) | `schema-design-intent-map §3` #4 |
| **② 생산 바인딩 (BOM·MES)** | 단/양면 인쇄 = 인쇄팀. UV평판=PROC_000002(별 공정축) | `§3` #4·#5 |
| **③ 가격 바인딩 (가격엔진)** | 인쇄비(PRC_COMPONENT_TYPE.01). component_prices.clr_cd 차원 | `§3` #4 |

> **귀속을 가르는 실례:** 단/양면=`option-button`/print_side(이 축) · 별색=`large-color-chip`/공정(PROC_000007, clr_cd=NULL·별 축). ②③가 달라 환원 t_*가 갈린다(`schema-design-intent-map §3.2`).

---

## 5. 정규화 / FK (코드 도메인 거버넌스)

- **코드:** `opt_id` = 상품별 시퀀스 정수(전역 surrogate 아님). 멱등 = (prd_cd, print_side, front_colrcnt_cd, back_colrcnt_cd) 조합.
- **FK:** `prd_cd`→`t_prd_products` · `front/back_colrcnt_cd`→`t_clr_color_counts`(NULL 허용=back 단면). option_items가 `OPT_REF_DIM.06`로 opt_id 참조.
- **적재 선후:** clr_color_counts(완비) → products → product_print_options → option_items(L2 포인터).
- (출처: `schema-design-intent-map §1.2·§2.2` · `01 §3.6`)

---

## 6. 진단가에게 넘기는 핵심 (정답 사전 요약)

1. **인쇄옵션축 = 상품별 인쇄면 도수 연결행**(opt_id). 도수값은 ③도수 마스터(CLR)를 참조, 새로 정의 안 함.
2. **[HARD] 별색·UV·화이트 underbase는 이 축 아님** — 별색=PROC_000007(clr_cd=NULL)·UV변형=PROC_000002 param(print_side 금지)·화이트 underbase=PROC_000008(별색).
3. **단면 뒷면도수 = CLR_000001**(인쇄안함).
4. **도수 CPQ 참조 = opt_id(OPT_REF_DIM.06)**, NOT clr_cd 직접. L2≠L1(재적재 금지).
5. **CPQ 옵션 레이어 대부분 미적재**(OM-6) — "미적재 vs 오적재" 구분.
6. **화이트/클리어 underbase = 별색공정 일괄결정 후보**(SK-1/SL-2/G-SL-2 미회신) — 컨펌 전 별색공정 가설.
