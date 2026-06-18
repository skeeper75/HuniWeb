# 축별 정답 사전 — ⑤ 공정 (`t_proc_processes`)

> **하네스** hbg (기초코드 권위 큐레이터) Phase 1 · 2차 회차. **작성** 2026-06-18.
> **지위:** 진단가(`hbg-basecode-diagnostician`)의 기준선. 본 문서는 **공정 마스터 축**(`t_proc_processes`)의 정답이다.
>
> **권위 순서 [HARD]:** ① 상품마스터 `후니프린팅_상품마스터_260610.xlsx` + 가격표(명시값=정답)
> → ② 라이브 t_* 설계의도 `00_schema/schema-design-intent-map.md`(§2.2 t_proc WHY·§3 #5·#6·#7·OM-5·OM-7) + `32_axis-staged-load/01 §5`(공정 규칙) + `process-recipe-tree §1·§3`
> → ③ 인쇄 도메인 + rpmeta 역공학 `04_vessel/vessel-process-parameter.md`(V-1 ref_param_json)·`vessel-shape-axis.md`(V-12 칼틀)·`vessel-print-method-recipe.md`(V-2)
> → ④ 경쟁사(갭헌팅 전용) RP PCS(`disable_pcs`)·WP `rst_awkjob`·CIP4 Process+Parameter. ③④는 권위 빈칸/모호분에만 개입, 권위를 덮어쓰지 못한다.
>
> **라이브 행수 권위:** `schema-design-intent-map §0` = **`t_proc_processes` 83행**(라이브 MAX 000083). `01 §0`=84·22 공정유형(스냅샷 차 — 열재단 PROC_000084 존재 여부가 갈림, C-PROC-1 참조). 추가 DB 접속 없음.
> **확정도 범례:** **확정**(권위 엑셀 명시 또는 라이브 실측) · **가설**(권위 침묵·도메인 유추, 출처+컨펌ID 부착) · **컨펌**(사용자 결정 필요).

---

## 0. 공정 축 정의 (무엇이 이 축에 속하는가)

`t_proc_processes` = **공정**(coating·binding·foil·emboss·cutting·sewing·perforation·attach) + **인쇄방식**(self-ref: `PROC_000001` 인쇄 부모 → UV/옵셋/디지털/실크/실사 자식) + **별색**(`PROC_000007` family) + **`prcs_dtl_opt` JSON param**(타공 구수·오시 줄수·봉제 유형·UV 변형).
판별 단일 기준: **"이것이 재료를 *변형/가공하는 행위*인가?"** — Yes면 공정. 행위의 *대상 재료*는 ④자재 축, 행위의 *수치*는 prcs_dtl_opt param.
(출처: `01 §5.1·§5.3` · `schema-design-intent-map §2.2`)

핵심 컬럼: `proc_cd` PK(`PROC_` 순차) · `proc_nm` · **`upr_proc_cd`**(self-ref family) · **`prcs_dtl_opt`**(jsonb 파라미터 스키마).

---

## 1. 공정 self-ref family 정답 사전 (소속 t_* = `t_proc_processes`, 코드 도메인 = PROC)

> ★ 핵심 — 공정은 **부모(family head) → 자식** self-ref 구조. 진단가는 family head와 자식 코드 범위를 기준으로 어긋남을 판정.
> (출처: `01 §5.1·§5.2·§5.5` · `schema-design-intent-map §2.2 line 350·351` · `process-recipe-tree §1·§3` · `vessel-process-parameter §1`)

| 코드값/family | 올바른 의미 (정답) | 소속 t_* | 코드 도메인 | 권위 출처 | 확정도 |
|---------------|-------------------|----------|-------------|-----------|--------|
| `PROC_000001` (인쇄 부모) | **인쇄방식 family head**. self-ref root | `t_proc_processes` | PROC(self-ref) | `process-recipe-tree §1` · `01 §5.1` | 확정 |
| `PROC_000002~006` (인쇄 자식) | **인쇄방식** — UV/옵셋/디지털/실크/실사. **1상품=1방식**(가능 후가공 부분집합 게이팅) | `t_proc_processes` | PROC | `01 §5.2·§5.3` · `process-recipe-tree §1` · `schema-design-intent-map §3 #4` | 확정 |
| `PROC_000002` (UV) | UV 인쇄방식. `prcs_dtl_opt` = `{"inputs":[{"key":"변형","type":"enum","values":["일반","배면양면","풀빼다","투명테두리","단면"]}]}` (라이브 실측) | `t_proc_processes` | PROC | `01 §5.1` 라이브 실측 · OM-5 | 확정 |
| `PROC_000007` (별색 부모) | **별색 family head**. **`clr_cd=NULL`**(별색=공정, 도수 아님) | `t_proc_processes` | PROC(self-ref) | `01 §5.2·§3.1` · `schema-design-intent-map §3 #5` | 확정 |
| `PROC_000008~012` (별색 자식) | **별색인쇄** — 화이트(008)/클리어/핑크/금/은. 화이트 underbase 포함 | `t_proc_processes` | PROC | `01 §5.2` · `entity-semantic-model §3.2` | 확정 |
| `PROC_000014~016` (코팅) | **코팅** — 무광/유광 + 면 enum param. **코팅=공정**(자재 아님 Q9) | `t_proc_processes` | PROC | `01 §5.2` · Q9 · `schema-design-intent-map line 458` | 확정 |
| `PROC_000017` (제본 부모) | **제본 family head** | `t_proc_processes` | PROC(self-ref) | `process-recipe-tree §3` · `01 §5.2` | 확정 |
| `PROC_000018~025` (제본 자식) | **제본** — 중철/무선/PUR(020)/트윈링/떡 + 택일그룹(GRP-BOOK-제본). 레이플랫(025)=미운영(Q10·AX-6) | `t_proc_processes` | PROC | `process-recipe-tree §3` · Q10 · `01 §5.2` | 확정(025 컨펌 AX-6) |
| `PROC_000029` (오시) | 오시 + `{"줄수":max3}` param | `t_proc_processes` | PROC | `vessel-process-parameter §1` 라이브 실측 | 확정 |
| `PROC_000033` (박 부모) | **박 family head** — 금형 압착 포일. **박=공정**(자재 아님 Q2). 색상 16종 param. `{"크기":mm}` | `t_proc_processes` | PROC(self-ref) | `01 §5.2` · Q2 · `vessel-process-parameter §1` · `schema-design-intent-map line 451` | 확정 |
| `PROC_000053` (완칼) | **완칼**(낱장 컷). `prcs_dtl_opt`=`{"모양"}`(자유칼선 환원처·V-12) | `t_proc_processes` | PROC | `01 §5.2` · `vessel-process-parameter §1·§2.3` · `vessel-shape-axis` | 확정 |
| `PROC_000054` (반칼) | **반칼**(점착지 칼선). `{"모양","조각수":min1}` param | `t_proc_processes` | PROC | `01 §5.2` · `vessel-process-parameter §1` | 확정 |
| `PROC_000055` (스티커완칼) | 스티커 완칼 | `t_proc_processes` | PROC | `01 §5.2` | 확정 |
| `PROC_000084` (열재단) | **열재단** — 순수 공정(자재 없음). 스냅샷 B에만 존재(라이브 MAX 083 vs 084) | `t_proc_processes` | PROC | CLAUDE.md §7 컨펌해소(열재단 PROC_000084) · `01 §0` 84행 | 확정(스냅샷 차 C-PROC-1) |
| (접지/미싱/타공/봉제/부착) | 각 proc + param | `t_proc_processes` | PROC | `01 §5.2` B8 | 확정 |

### 1.1 family 적재 선후 [HARD]

self-ref family는 **부모 선적재 후 자식**: 인쇄(001→002~006)·별색(007→008~012)·박(033 family)·제본(017→018~025).
param 변동은 **신규 proc 금지** — 같은 공정행 prcs_dtl_opt 갱신.
(출처: `01 §5.5·§5.6`)

---

## 2. 공정 오염 경계 (이 축에 무엇을 넣으면/빼면 안 되는가) [HARD]

> (출처: `01 §5.1 오염 금지` · `schema-design-intent-map §2.2 line 351`·OM-7 · `option-material-process-bundle` 메모리)

| 위반 | 무엇이 잘못 | 올바른 모델 | 정답 근거 | 확정도 |
|------|------------|------------|-----------|--------|
| **공정 param 행 분리 비대화** | 타공 구수·오시 줄수·조각수·박 크기를 구수마다 별 proc_cd 신설 | **1 공정행 + param**(`prcs_dtl_opt`). 타공 4/6/8 = PROC 1행 + `{"구수":N}` | OM-7/GAP-PARAM · `vessel-process-parameter §3` | 확정 |
| **칼틀(모양)을 prcs_dtl_opt에 중복** | 합판도무송 형상을 공정 param에 또 입력 | siz_cd가 칼틀 식별자(Q7). 공정엔 "도무송" 1줄만 | `schema-design-intent-map §3.2` · `01 §5.1` · ②사이즈 사전 §2.1 | 확정 |
| **별색을 도수로** (역방향) | 별색을 clr_cd/도수칸에 | 별색=공정(PROC_000007, clr_cd=NULL) | §3.1·OM-5 · `01 §5.1` | 확정 |
| **자재를 공정으로** | 우드거치대·종이를 공정 행으로 | 거치대=자재(Q13)·종이=자재. 공정 아님 | Q13 · `01 §5.1` | 확정 |
| **순수공정에 자재 억지 부여** | 열재단·타공(bare-hole)에 자재 매달기 | 자재 없는 순수 공정 — 자재 억지 부여 금지 | `option-material-process-bundle` · `01 §5.1` | 확정 |

### 2.1 별색 vs UV 화이트 구별 [HARD]

`01 §5.3`·OM-5: **UV flatbed 화이트(PROC_000002 `풀빼다`) ≠ 별색 화이트(PROC_000008)**.
- 인쇄방식이 **UV**면 → 화이트는 `PROC_000002` 변형 param.
- 인쇄방식이 **디지털/실사**면 → 화이트는 `PROC_000008` 별색 공정.

(인쇄옵션 사전 §2.1 화이트 underbase 행과 정합)

---

## 3. prcs_dtl_opt JSON param 정답 (V-1 ref_param_json 연계) [HARD]

> 공정 param의 **저장처**가 핵심 모호점. `t_proc_processes.prcs_dtl_opt`=스키마(정의), 선택값은 어디에?
> (출처: `vessel-process-parameter §1·§2·§4` · OM-7 · `schema-design-intent-map line 442·485`)

| 분류 | 올바른 의미 | 소속 t_* | 권위 출처 | 확정도 |
|------|------------|----------|-----------|--------|
| 공정 param **스키마**(정의) | 공정별 입력 키·타입·범위. 예 `{"줄수":max3}`·`{"방향","책등","고리형"}`·`{"조각수":min1}` | `t_proc_processes.prcs_dtl_opt`(jsonb) | `vessel-process-parameter §1` 라이브 실측 | 확정 |
| 공정 param **선택값**(인스턴스) | 고객이 고른 "줄수=2 / 책등=12mm / 조각수=4" | `t_prd_product_option_items.ref_param_json`(**미구현 GAP**) | OM-7 · `vessel-process-parameter §2`(`ref-param-json-proposal.sql`) | **컨펌 AX-5** |

> **[HARD] GAP-PARAM:** 선택값을 적을 칸이 option_items에 **없다**(`ref_param_json` 미구현). prcs_dtl_opt=스키마, ref_param_json=값(인스턴스)으로 이중저장 아님.
> 진단가: 라이브에 공정 param 행이 비대화(구수마다 별 proc)돼 있으면 OM-7 어긋남. 단 ref_param_json 신설(컬럼 vs qty 재사용)은 **AX-5 컨펌** 대기.

---

## 4. 삼중 바인딩 (공정이 어디에 귀속되는가) [HARD]

> `schema-design-intent-map §3` #5(별색)·#6(후가공)·#7(제본) 인용(재유도 금지).

| 측면 | 공정 귀속 | 출처 |
|------|-----------|------|
| **① UI 바인딩 (componentType)** | `finish-button` / `finish-select-box`(값 多) / 별색=`large-color-chip` / 제본=`option-button`(택1) | `schema-design-intent-map §3` #5·#6·#7 |
| **② 생산 바인딩 (BOM·MES)** | 후가공팀 공정. 별색=후공정 잉크. 제본팀. **타공 구수·오시 줄수=공정 param**. 순서 의존(출력→코팅→재단→후가공) | `§3` #5·#6 · `01 §5.3` 공정 순서 |
| **③ 가격 바인딩 (가격엔진)** | 후가공비(PRC_COMPONENT_TYPE.04)·박형압비(.05)·코팅비(.02). **박등급=앱 면적계산**(DB 미저장) | `§3` #5·#6 · `compute-in-app` |

> **귀속을 가르는 실례:** 코팅·박은 ②가 후가공팀 공정이라 자재 아님(Q2/Q9). 거치대는 ②가 입고 자재라 공정 아님(Q13). ②생산 바인딩이 귀속을 가른다.

---

## 5. 정규화 / FK (코드 도메인 거버넌스)

- **코드:** `PROC_NNNNNN` 순차(라이브 MAX 000083, B 스냅샷 084). 멱등 = (proc_nm) 또는 (proc_nm, upr_proc_cd). **param 변동은 신규 proc 금지**(prcs_dtl_opt 갱신).
- **FK:** `upr_proc_cd` self-ref(부모 선적재) · `t_prd_product_processes.proc_cd`(+mand_proc_yn) · option_items `OPT_REF_DIM.04`(proc_cd=ref_key1) · `t_prd_product_materials.dep_proc_cd`(자재의존 공정, SET NULL).
- **적재 선후:** base_codes 다음. **self-ref 부모(인쇄/별색/박/제본 family head) → 자식**. 상품·product_processes·가격(후가공비 component)보다 먼저. 자재의존 공정(dep_proc_cd)은 자재 선적재 참조.
- (출처: `01 §5.5·§5.6`)

---

## 6. 진단가에게 넘기는 핵심 (정답 사전 요약)

1. **공정축 = 재료 변형/가공 행위 + 인쇄방식 + 별색 + param**. 대상 재료는 ④자재, 수치는 prcs_dtl_opt.
2. **self-ref family** — 인쇄(001→002~006)·별색(007→008~012, clr_cd=NULL)·박(033)·제본(017→018~025). 부모 선적재 후 자식.
3. **[HARD] 별색·박·코팅·UV·완칼/반칼/열재단·미싱·봉제 = 공정**(자재·도수 아님). 거치대·종이=자재(공정 아님).
4. **공정 param = 1행+param**(비대화 금지·OM-7). 선택값 저장처(ref_param_json)는 AX-5 컨펌(미구현 GAP).
5. **칼틀(형상)=siz**(Q7), prcs_dtl_opt 중복 금지. 규격형 반칼/완칼만 형상=공정 param.
6. **별색 화이트 ≠ UV 화이트**(§2.1) — 인쇄방식으로 갈림.
7. **PROC_000084 열재단**=순수공정(자재 없음). 스냅샷 차(C-PROC-1) — 라이브 재실측으로 83 vs 84 확정 필요.
