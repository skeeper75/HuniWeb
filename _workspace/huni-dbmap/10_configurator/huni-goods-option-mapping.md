# 후니 굿즈/파우치/악세사리 옵션 매핑 설계 (자재오염 → CPQ 옵션 정규화)

> 목적: 후니 `t_mat_materials`에 **자재로 잘못 등록된 옵션 속성**(색·형상·인쇄면·방향·사이즈·구수)을, WowPress 벤치마크의 6 의미축 원칙을 따라 **후니 라이브 CPQ 옵션 테이블**(`t_prd_product_*`)로 어디에·어떻게 매핑할지 설계한다.
>
> [HARD] **설계 제안서일 뿐 — DB 쓰기·COMMIT·DDL 없음.** 자재 정리/재배선은 별도 인간 승인 마이그레이션. 본 문서는 "design proposal"이고 "apply"가 아니다.
>
> - 권위 입력: `04_audit/material-master-analysis.md`·`material-master-fulldump.tsv`(라이브 자재 337행) · `10_configurator/wowpress-option-model.md`(벤치마크) · `00_schema/cpq-schema.md`·`columns.csv`·`code-values.md`(라이브 스키마/코드).
> - 상품↔속성 연결은 라이브 `t_prd_product_materials`(read-only `ref-product-materials.csv`)로 확정 — 추측 0.
> - 식별자/컬럼/코드 영어, 설명 한국어.

---

## 0. 한 줄 결론 (먼저 읽기)

- **축 매핑 평결: 후니 스키마는 WowPress 6축 중 5축을 보유, 1축(포장/기타옵션)은 GAP.**
  규격(형상+치수)·재질(소재+본체색)·도수(인쇄면)·인쇄방식·후가공(개수)은 후니 라이브 테이블에 그대로 대응되나, WowPress `optioninfo`(포장·각인 등 자유 가공/구성 옵션)에 정확히 대응하는 후니 "범용 옵션 그릇"은 `t_prd_product_options`/`option_items`의 **polymorphic ref_dim_cd 7종(OPT_REF_DIM)에 '자유텍스트/포장' 차원이 없다** → GAP-OPT(ddl-proposer 후보, 발명 금지).
- **오염 재분류 접근:** MAT_TYPE.08/09/10의 오염 행 각각을 5개 후니 축으로 분류 — **사이즈→t_prd_product_sizes·형상→t_prd_product_sizes(형상도 규격축에 융합)·본체색→재질행 합성(t_prd_product_materials)·인쇄면→t_prd_product_print_options·잉크색→t_prd_product_print_options/도수·구수→t_prd_product_processes(개수형 공정)**. 자재 마스터엔 진짜 소재만 남긴다.
- **핵심 compose-vs-split 결정 3가지(WowPress 규칙 직접 적용):**
  1. **본체색은 재질행으로 합성**(split 금지) — "빨간 파우치"="파우치원단(빨강)" 1행. 색을 독립 옵션축으로 떼면 WowPress보다 더 잘게 쪼개는 것(사용자 "과분할 금지"에 위배).
  2. **형상은 규격축에 융합**(별도 형상축 신설 금지) — "원형"="원형(치수)" siz_cd 1행. WowPress 40185 핀버튼과 동일.
  3. **잉크색·인쇄면은 도수축으로 분리**(재질과 분리) — 본체색과 의미가 다르다. 만년스탬프 잉크색은 인쇄 도수, 본체색이 아님.

---

## 1. 축 매핑 표 — WowPress 6축 → 후니 라이브 테이블

WowPress가 굿즈/파우치 옵션을 흡수하는 6 의미축을, 후니가 실제 가진 옵션 테이블(라이브 `columns.csv` 확인)에 대응시킨다. 후니의 옵션 레이어는 **(A) 전용 차원 테이블**(sizes/materials/print_options/processes/bundle_qtys)과 **(B) polymorphic 옵션 레이어**(option_groups → options → option_items, ref_dim_cd로 (A)를 가리킴)의 2단 구조다. UI 노출(선택지화)은 (B)의 option_group이 담당한다.

| # | WowPress 축 (prod_info 키) | 담는 의미 | 후니 라이브 테이블 (차원 권위) | 핵심 컬럼 | UI 선택 레이어 (option_group) | 판정 |
|---|----------------------------|-----------|-------------------------------|-----------|------------------------------|------|
| 1 | **규격** `sizeinfo` | 사이즈 **+ 형상**(융합) | `t_prd_product_sizes` → `t_siz_sizes` | `siz_cd`(FK siz) · siz의 `work_width/height·cut_*·siz_nm` | option_group(sel_typ=단일) + option_items(`ref_dim_cd=OPT_REF_DIM.01`, ref_key1=siz_cd) | ✅ 보유 |
| 2 | **재질** `paperinfo` | 소재 **+ 본체색 + 코팅**(합성행) | `t_prd_product_materials` → `t_mat_materials` | `mat_cd`(FK mat) · `usage_cd`(FK USAGE) | option_items(`ref_dim_cd=OPT_REF_DIM.03`, ref_key1=mat_cd, **ref_key2=usage_cd**) | ✅ 보유 |
| 3 | **도수** `colorinfo` | 인쇄 **면/방향 + 잉크 도수** | `t_prd_product_print_options` → `t_clr_color_counts` | `opt_id` · `print_side`(vc20) · `front_colrcnt_cd`·`back_colrcnt_cd`(FK clr) | option_items(`ref_dim_cd=OPT_REF_DIM.06`, ref_key1=opt_id::int) | ✅ 보유 |
| 4 | **인쇄방식** `prsjobinfo` | 인쇄기/인쇄방식 프리셋 | `t_prd_product_processes` → `t_proc_processes` (인쇄계열 공정) | `proc_cd`(FK proc) · `mand_proc_yn` | option_items(`ref_dim_cd=OPT_REF_DIM.04`, ref_key1=proc_cd) | ✅ 보유(공정으로 표현) |
| 5 | **후가공/개수** `awkjobinfo` (namestep1/2) | 마감 가공(개수형: 구수·칼선 N개) | `t_prd_product_processes`(가공 공정) + **택일그룹** `t_prd_product_option_groups`(구 excl_groups 흡수) | `proc_cd` · option_group `sel_typ_cd=SEL_TYPE.01`(단일) | option_group(택일/복수) + option_items(OPT_REF_DIM.04) | ✅ 보유(단, 구수 N의 "개수 파라미터" 보존은 §5 GAP) |
| 6 | **포장/기타** `optioninfo` | 포장·각인·구성 등 자유 가공 옵션 | **대응 없음** — OPT_REF_DIM 7종에 '포장/자유텍스트' 차원 부재 | — | — | 🔴 **GAP-OPT** |

### 보조 축 (WowPress 축은 아니나 후니가 보유, 굿즈에 쓰임)
| 후니 테이블 | 의미 | OPT_REF_DIM | 굿즈 용례 |
|-------------|------|-------------|-----------|
| `t_prd_product_bundle_qtys` | 묶음수(N개1팩) | .05 (ref_key1=bdl_qty::int) | "2개1팩"·"3개1팩"(만년스탬프) → 묶음수로 |
| `t_prd_product_sets` | 셋트(부속 동반상품) | .07 (ref_key1=sub_prd_cd) | "CD커버 세트"·거치대/봉투 등 별도상품 동반 |
| `t_prd_product_plate_sizes` | 판형(출력) | .02 | 굿즈 일반 미사용 |

### 평결: 6축 중 5축 보유, 1축 GAP
- **규격·재질·도수·인쇄방식·후가공** 5축: 후니 라이브에 **직접 대응 테이블 존재**. WowPress의 "형상 융합 규격 / 본체색 융합 재질"도 후니 구조로 그대로 표현 가능(siz_nm에 형상, mat_nm에 본체색).
- **포장/기타옵션(optioninfo)** 1축: 후니 OPT_REF_DIM(.01~.07)에 **"자유 텍스트/포장/구성" 차원이 없음**. 만년스탬프 "리필잉크 N색팩", 파우치 "OPP포장", "각인" 류 자유 가공을 담을 정규 차원 부재. → **GAP-OPT, ddl-proposer 후보**(§5). 발명하지 않고 플래그만 한다.

---

## 2. 오염 재분류 표 (대표 상품 — 라이브 t_prd_product_materials 확정)

라이브 `ref-product-materials.csv`로 **각 오염 자재가 어느 상품의 어느 옵션축인지 확정**했다(추측 0). 모든 오염 행이 `usage_cd=USAGE.07(공통)`으로 연결됨 — **진짜 자재라면 내지(.01)/표지(.02) 등 의미 역할을 가질 텐데 전부 '공통'** 이라는 사실 자체가 "이들은 소재가 아니다"의 라이브 증거다.

### 2.1 PRD_000221 말랑키링 — **형상** (규격축 융합)
| 현재 (오염) | 자재명 | → 올바른 후니 축 | 매핑 |
|-------------|--------|------------------|------|
| MAT_TYPE.09 | 원형(MAT_000304) | `t_prd_product_sizes` 형상=원형 | 신규 siz_cd(원형, 치수 동반) + product_size 링크 |
| MAT_TYPE.09 | 사각(MAT_000305) | `t_prd_product_sizes` 형상=사각 | 〃 |
| MAT_TYPE.09 | 꽃(MAT_000306) | `t_prd_product_sizes` 형상=꽃 | 〃 |
| MAT_TYPE.09 | 별(MAT_000307) | `t_prd_product_sizes` 형상=별 | 〃 |
| MAT_TYPE.09 | 하트(MAT_000308) | `t_prd_product_sizes` 형상=하트 | 〃 |

→ WowPress 40185 핀버튼(`원형32/하트57x51`)과 정확히 동일 패턴. **형상은 독립 축이 아니라 규격(siz)으로**. 단, 말랑키링 형상은 치수 미상(엑셀/라이브에 width/height 없음) → **비치수 형상 siz 등록 = §5 GAP-SHAPE**(이미 round-5 DDL 제안 트랙에서 'goods 비치수 size'로 식별됨; 발명 금지).

### 2.2 PRD_000217 만년스탬프 + PRD_000015 리필잉크 — **잉크색** (도수축, 재질 아님)
| 현재 (오염) | 자재명 | → 올바른 후니 축 | 매핑 |
|-------------|--------|------------------|------|
| MAT_TYPE.09/10 | 검정·노랑·빨강·초록·파랑·핑크·청보라 | **도수**(`t_prd_product_print_options`) 또는 잉크 선택 옵션 | print_option(잉크색) 또는 §5 옵션그릇 |

→ **본체색이 아니라 잉크색**이므로 재질행 합성(파우치색 방식)을 쓰면 안 된다. WowPress 규칙 B "본체색은 재질, 잉크색/면은 도수". 단 만년스탬프 잉크색은 인쇄 도수(front_colrcnt)와도 결이 달라(스탬프 잉크 자체 선택) → 엄밀히는 **GAP-OPT(포장/기타 옵션 그릇)** 가 더 맞을 수 있음. 둘 중 어디로 둘지는 후니 도메인 확인 필요(플래그). 리필잉크(PRD_000015)는 **별도 상품(부자재)** 이므로 잉크색 7종은 그 상품의 옵션(또는 `t_prd_product_sets` 동반).

### 2.3 PRD_000193 머그컵 — **본체색 + 용량(혼합)**
| 현재 (오염) | 자재명 | → 올바른 후니 축 | 매핑 |
|-------------|--------|------------------|------|
| MAT_TYPE.01/09 | 투명·반투명·화이트 | **본체색** → 재질행 합성 | `t_prd_product_materials`: "머그(화이트)" 1행(소재×색 합성) |
| MAT_TYPE.09 | 11온스(MAT_000268) | **용량** → 규격 | `t_prd_product_sizes` 용량=11온스(WowPress: 용량=규격 후보) |

→ 본체색(투명/화이트)은 **재질행 합성**(split 금지). 용량(11온스)은 물리 사양이므로 **규격(siz)**. 단 머그 용량은 width/height가 아닌 부피 → 비치수 siz(§5 GAP-SHAPE와 동류). WowPress엔 머그 직접 대응 없음(분석서 명시), 구조상 규격 후보.

### 2.4 PRD_000202 키캡키링 / PRD_000203 LED투명키캡키링 — **구수(개수)**
| 현재 (오염) | 자재명 | → 올바른 후니 축 | 매핑 |
|-------------|--------|------------------|------|
| MAT_TYPE.09 | 1구(MAT_000280)·2구(277)·3구(278)·4구(279) | **개수형 후가공/공정** | `t_prd_product_processes`(타공/구성 공정) + 개수 파라미터 |

→ WowPress `awkjobinfo.namestep2`(개수형: "10개/20개")에 대응. 후니는 개수형을 **공정 + 개수**로 표현해야 하는데, **개수 N을 보존할 컬럼(ref_param_json)이 라이브 미구현**(cpq-schema §4 🔴8) → §5 GAP-COUNT. 현재는 공정행 분리 또는 option_items.qty로 우회.

### 2.5 PRD_000268 캔버스심플백 / PRD_000270 캔버스에코백 — **사이즈 + 방향**
| 현재 (오염) | 자재명 | → 올바른 후니 축 | 매핑 |
|-------------|--------|------------------|------|
| MAT_TYPE.09 | 세로M(MAT_000334)·가로L(MAT_000336) | **사이즈+방향** → 규격 융합 | `t_prd_product_sizes`: "세로형 M(치수)"·"가로형 L(치수)" 각 siz 1행 |

→ WowPress 40479 에코백(`sizename S/M/L` + `colorlist 앞면/뒷면` 방향)과 동일 모델. **방향(가로/세로)은 규격에 융합**(가로L=한 siz). 단, "방향(인쇄 면)"과 "사이즈"가 독립 선택이면 방향=도수축으로 뗄 수도 있으나 — 에코백은 방향이 곧 사이즈 비율(가로형/세로형)이라 **규격 1축에 합성이 자연스럽다**(WowPress 그대로). 본체색(린넨/내추럴 등)은 별도로 **재질행 합성**.

### 2.6 파우치(MAT_TYPE.05) 본체색 — **재질행 합성** (split 금지)
| 현재 | 자재명 | → 올바른 후니 축 | 매핑 |
|------|--------|------------------|------|
| MAT_TYPE.05 | 파우치 블랙/투명/멜란지/반투명/청보라/화이트 (MAT_000062~067) | **소재×본체색 합성 재질** | `t_prd_product_materials`: mat_cd 각각이 이미 "파우치 블랙" 합성행 — **이건 이미 올바른 형태**(upr=파우치). 색만 떼지 말 것 |

→ **파우치 본체색은 이미 자재행 합성**(MAT_000061 파우치 root + 색별 자식)으로 올바르게 모델링됨. "빨간 파우치"를 색축으로 분리하지 말라는 사용자 지시와 정확히 일치. **이 케이스는 오염이 아니라 정답 패턴** — 다른 굿즈도 이 방식을 따라야 한다(머그 본체색, 에코백 천색).

---

## 3. 입도(granularity) 결정 — compose vs split (WowPress 규칙 인용)

각 속성에 대해 "한 행으로 합성"인지 "별도 옵션축 분리"인지 명시. 근거는 WowPress 규칙 A~E(`wowpress-option-model.md` Q6).

| 속성 | 결정 | 근거(WowPress) | 후니 적용 |
|------|------|----------------|-----------|
| **본체색** (파우치 블랙, 머그 화이트, 에코백 천색) | **COMPOSE — 재질행 1행** | 규칙 A·B: 소재+본체색=한 재질행(40479 캔버스색6, 40072 NCR색). 색을 떼면 과분할 | `t_prd_product_materials` 합성 mat_cd. **색 독립 옵션축 신설 금지** |
| **형상** (원형/하트/별) | **COMPOSE — 규격(siz)에 융합** | 규칙 B: 형상은 sizeinfo 융합(40185 원형32/하트57x51). 형상축 신설 안 함 | `t_prd_product_sizes` siz_nm에 형상. **별도 형상 차원 신설 금지** |
| **사이즈+방향** (가로L/세로M) | **COMPOSE — 규격 1행** | 규칙 A: 함께 고르는 물리속성 1행(40479 에코백 S/M/L) | siz_nm="가로형 L" 1행 |
| **인쇄면** (단면/양면/앞뒤) | **SPLIT — 도수축 분리** | 규칙 B: 인쇄 면/방향=colorinfo(도수). 본체색과 의미 다름 | `t_prd_product_print_options.print_side` 별 행 |
| **잉크색** (만년스탬프 검정/빨강) | **SPLIT — 도수/잉크 옵션** | 규칙 B: 잉크색=도수 성격(본체색 아님) | print_options 또는 §5 옵션그릇 (도메인 확인) |
| **구수/개수** (1구~4구) | **SPLIT — 개수형 공정** | 규칙 C: 후가공 namestep2 개수형(2단계까지) | 공정 + 개수파라미터(§5 GAP) |
| **용량** (11온스/350ml) | **COMPOSE — 규격(siz)** | 머그 직접대응 없음, 구조상 물리사양=규격 | 비치수 siz(§5 GAP) |
| **포장/구성** (OPP봉투, N개팩) | **묶음수 or 옵션그릇** | 규칙: optioninfo flat / 묶음수 | `t_prd_product_bundle_qtys`(N개1팩) 또는 §5 GAP-OPT |

### 한 줄 입도 지침 (사용자 "과분할 금지"의 구체형)
> **함께 고르는 물리 속성은 한 행으로 합성하라: 소재+본체색=재질행, 형상+치수+방향=규격행. 색을 무조건 분리하지 말 것 — 본체색은 재질, 잉크색/인쇄면만 도수로 분리.** 이것이 WowPress의 정답이자 후니 관리용이성의 답이다.

---

## 4. UI 반영 (sel_typ — 컨피규레이터 렌더)

각 축을 사용자 선택 옵션으로 UI에 띄우려면 `t_prd_product_option_groups`에 그룹을 만들고 `sel_typ_cd`(SEL_TYPE)를 지정한다. UI는 option_group 단위로 렌더된다(라이브 13행 적재 실증: 제본/캘린더 택일그룹).

| 축 | option_group 예 | sel_typ_cd | mand_yn | UI 렌더 | 근거 |
|----|-----------------|-----------|---------|---------|------|
| 규격(형상/사이즈) | "형상 선택"/"사이즈 선택" | SEL_TYPE.01(단일) | Y | 라디오/이미지선택 | 굿즈는 형상 택1 |
| 재질(본체색 합성) | "색상/재질 선택" | SEL_TYPE.01(단일) | Y | 컬러칩/드롭다운 | 본체색=재질행, 택1 |
| 도수(인쇄면) | "인쇄면 선택" | SEL_TYPE.01(단일) | Y | 라디오 | 단면/양면 택1 |
| 잉크색 | "잉크색 선택" | SEL_TYPE.01 or .02 | 상품별 | 컬러칩 | 만년스탬프 다색이면 다중(.02) |
| 구수/개수 | "구수 선택" | SEL_TYPE.01(단일) | Y | 라디오 | 1구~4구 택1 |
| 묶음수 | "수량(팩) 선택" | SEL_TYPE.01 | Y | 드롭다운 | N개1팩 |

- **반영 메커니즘:** 차원행(sizes/materials/print_options/processes) 적재 → option_group 생성 → option_items가 `ref_dim_cd`로 차원행을 가리킴(트리거 `fn_chk_opt_item_ref`가 무결성 강제). **차원행이 없으면 option_item INSERT가 트리거에서 거부됨** → 적재 순서: 차원행 먼저, 그 다음 option layer.
- 현재 라이브: 굿즈 옵션 그룹/아이템 **0행**(cpq-schema §5) — 즉 굿즈 옵션은 아직 UI에 안 뜬다. 본 설계가 그 적재 청사진.

---

## 5. 마이그레이션 영향 + GAP 플래그 (high-level — 적재 아님)

### 5.1 무엇이 바뀌어야 하나 (design proposal, NOT apply)
1. **자재 마스터 정리(retype/remove):** MAT_TYPE.08/09/10의 오염 행(형상·색·면·방향·사이즈·구수 ~120행)을 자재에서 제거 또는 비활성(`del_yn='Y'`). 단 **파우치 본체색(MAT_TYPE.05)·진짜 실사소재(캔버스/타이벡/PET)·아크릴 본체색은 재질로 유지**(합성행이 정답).
2. **신규 규격행:** 형상(원형/하트/별…)·사이즈(가로L/세로M)·용량(11온스)을 `t_siz_sizes` + `t_prd_product_sizes`로. → **비치수 siz 등록 필요**(width/height 없는 형상·용량) = GAP-SHAPE.
3. **재질행 합성 정리:** 머그/에코백 본체색을 "소재(본체색)" 합성 mat_cd로(파우치 방식 따라).
4. **도수행:** 인쇄면(단면/양면)을 `t_prd_product_print_options`로.
5. **공정행:** 구수(1구~4구)를 개수형 공정으로 → 개수 N 보존처(GAP-COUNT).
6. **옵션 레이어:** 위 차원행 위에 option_group/option_items 생성(UI 노출).
7. **재배선(re-link):** `t_prd_product_materials`의 오염 링크를 제거하고, 새 차원행으로 product_sizes/print_options/processes 링크 재생성.

→ **이 전체가 인간 승인 마이그레이션**(DELETE/UPDATE/INSERT 혼합, 멱등 append 아님 — round-5 교훈: GO 커밋 후 교정은 별도 마이그레이션). 본 문서는 **설계 제안**이며 실행(apply)은 별도 승인.

### 5.2 GAP 플래그 (ddl-proposer 후보 — 발명 금지, 플래그만)
| GAP | 내용 | 영향 축 | 기존 식별 여부 | 제안 방향(미확정) |
|-----|------|---------|----------------|-------------------|
| **GAP-SHAPE** | 비치수 형상/용량을 siz로 등록 시 width/height 부재(형상=원형/별, 용량=11온스) | 규격(1) | round-5 11_ddl_proposals 'goods 비치수 size'로 이미 식별 | siz_nm에 형상라벨 + width/height NULL 허용(이미 nullable) or 형상 enum 컬럼 — ddl-proposer 결정 |
| **GAP-COUNT** | 개수형 공정의 개수 N(1구~4구, 칼선 N개) 보존 컬럼 부재 | 후가공(5) | cpq-schema §4 🔴8 ref_param_json 미구현 | option_items.qty 재사용 vs ref_param_json 컬럼 추가 — ddl-proposer 결정 |
| **GAP-OPT** | 포장/각인/잉크색팩 등 자유 가공 옵션 그릇(WowPress optioninfo 대응) 부재 | 포장/기타(6) | 신규 식별 | 신규 OPT_REF_DIM 차원 vs optioninfo 전용 테이블 vs 묶음수 전용(N개팩) — ddl-proposer 결정 |

- **3 GAP 모두 발명 금지.** 후니 라이브 컨벤션 정합 최소 신규엔티티 제안은 `dbm-ddl-proposer` 소관(search-before-mint, 사다리 코드행<컬럼<JSONB<테이블).
- **잉크색(만년스탬프)·용량(머그)** 의 정확한 축(도수 vs 옵션그릇 vs 규격)은 **후니 도메인 확인 필요**(플래그). 설계는 후보 2안 제시, 확정은 사용자/도메인.

### 5.3 design proposal ↔ apply 구분 (명시)
- ✅ **본 문서가 한 것(proposal):** WowPress 6축↔후니 테이블 매핑, 오염 자재의 올바른 축 분류(대표 상품), compose/split 입도 결정, UI 반영 청사진, 마이그레이션 영향·GAP 식별.
- ⛔ **본 문서가 안 한 것(apply, 인간 승인):** `t_mat_materials` 행 삭제/retype, 신규 siz/material/print_option/process 행 INSERT, product 재배선, option_group/items 적재, GAP DDL 적용, COMMIT.

---

## 6. 다음 단계 (핸드오프)
1. **후니 도메인 확인 (플래그 해소):** ① 만년스탬프 잉크색 = 도수축 vs 옵션그릇? ② 머그 용량 = 규격 비치수 siz 확정? ③ 굿즈 옵션 UI 노출 우선순위(어느 상품군부터).
2. **`dbm-ddl-proposer`:** GAP-SHAPE/COUNT/OPT 3건을 라이브 정합 신규엔티티 제안서로(11_ddl_proposals/).
3. **`dbm-load-builder`(승인 후):** 본 설계를 차원행→option layer 적재본으로 조립(FK 위상정렬: 차원행 먼저 → option_group → option_items, 트리거 무결성 충족). 멱등 + 마이그레이션(오염 자재 DELETE/retype).
4. **`dbm-validator`:** 재분류 결과를 라이브 t_prd_product_materials·엑셀 상품마스터와 교차검증(엑셀=원천 권위).

> **DB 미적재·DDL 무적용 유지.** 본 문서는 설계/제안 단계 산출물이다.
