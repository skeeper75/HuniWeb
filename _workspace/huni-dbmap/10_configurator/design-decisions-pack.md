# 설계 결정 팩 (Phase-0 Decision Pack) — 5건 미해결 결정

> **목적:** round-6 CPQ 옵션 레이어 적재(L2)와 일부 가격트랙 굿즈를 막는 **5건의 미해결 설계 결정**을 후보·증거·영향·권고로 정리해 사용자 확정을 받는다. **권고는 권고일 뿐** — 침묵 선택 안 함(HARD).
>
> **상태/이력** 작성 2026-06-07 · `dbm-ddl-proposer` 산출 · 라이브 read-only 실측 포함(추정 아님). DB 미적재·DDL 무적용.
> **권위:** `attribute-entity-map.md §5`·`huni-goods-option-mapping.md §2/§5`·`cpq-option-gaps.md`(GAP-BOARD)·`cpq-schema.md §2`(트리거)·round-5 `11_ddl_proposals/ddl-proposal-goods-pouch-nondim-size`·**라이브 read-only 실측(2026-06-07)**.
> 식별자/컬럼/코드 English, 설명 Korean. 라이브 권위 > 설계 문서.

---

## 0. 결정 요약표

| # | 결정 | 후보 | 권고 | 풀리는 것 | 사용자 확정 필요? |
|:-:|------|------|------|-----------|:--:|
| 1 | 잉크색(만년스탬프) | A 도수(.06) / B 자유옵션그릇(GAP-OPT) | **B** (조건부) | 만년스탬프·스탬프류 잉크 선택 | **YES** |
| 2 | 용량(머그 11온스) | A 비치수 size(.01) / B GAP-SHAPE 별 사양축 | **A**(비치수 size 마스터 경유) | 머그·텀블러 용량 옵션 | **YES** |
| 3 | 면지/바인더링(booklet) | A 자재(.03) / B 공정·셋트(.04/.07) | **A — 라이브 확정(이미 .03)** | 책자 면지·링 옵션 (즉시) | NO(라이브 해소) — **검증만** |
| 4 | 보드종류(폼보드/포맥스) | A 자재 / B 가공 / C 형태(siz depth) | **A 자재(.03)** | 보드·액자 5상품 substrate | **YES** |
| 5 | 실내/실외 배너거치대 | A 1 base+옵션 / B 2 SKU(template) | **B 2 template** (라이브 패턴 정합) | 거치대 추가상품 SKU | **YES** |

> **라이브↔설계 문서 모순 발견 = 결정 3** (아래 §3): 설계 문서가 `[CONFIRM]`(자재 vs 공정/셋트 미상)으로 둔 면지/바인더링이, 라이브 실측 결과 **이미 자재(.03)로 적재돼 있음** → 설계 문서의 미상 표기는 라이브보다 보수적(stale). 결정 3은 신규 결정이 아니라 **라이브 확정 사실의 검증**이다.

---

## 0.5 확정 결과 (2026-06-07, 사용자 승인 — 재론 금지)

| # | 결정 | **확정** | 후속 (Phase 0 산출) |
|:-:|------|----------|---------------------|
| 1 | 잉크색(만년스탬프) | **자유옵션그릇(GAP-OPT)** | GAP-OPT 구조 신설 DDL 제안 필요(신규 OPT_REF_DIM vs 전용테이블 — search-before-mint) |
| 2 | 용량(머그 등) | **비치수 size 마스터 경유** | round-5 비치수 size 제안(`t_siz_nonspec_sizes`) DDL + 옵션 연결 시 트리거 분기 |
| 3 | 면지/바인더링 | **자재 .03 (라이브 확정)** | 신규 DDL 0 — option_item이 `(mat_cd, usage_cd)`로 즉시 참조. 검증만 |
| 4 | 보드종류(폼보드/포맥스) | **자재 .03** | 신규 자재행 적재(substrate, 본체색→재질 합성) — DDL 0, 데이터 |
| 5 | 실내/실외 거치대 | **별개 상품 2개(2 template)** | 신규 DDL 0 — 후니 "실내/실외=어느 prd_cd" 데이터 확인 필요(GAP-DATA) |
| + | ref_param_json | **승인 대기(1줄 ALTER)** | `11_ddl_proposals/ref-param-json-proposal` |

**Phase 0 DDL 번들(인간 승인 대상):** ① ref_param_json ALTER ② GAP-OPT 구조 ③ 비치수 size 마스터.
**데이터 항목:** ④ 보드 substrate 자재행 ⑤ 거치대 실내/실외 prd_cd 매핑(후니 input).

---

## 1. 잉크색(만년스탬프 검정/빨강/…) = 도수(OPT_REF_DIM.06) vs 자유옵션그릇(GAP-OPT)

**후보**
- **A — 도수축(`OPT_REF_DIM.06` print_option, opt_id):** WowPress 규칙 B "잉크색=colorinfo(도수)". 인쇄 잉크 색상이므로 도수 성격.
- **B — 자유옵션그릇(GAP-OPT):** 만년스탬프 잉크는 인쇄 도수(front_colrcnt CMYK 인쇄)와 결이 다르다 — **스탬프 잉크 자체를 고르는 것**이지 인쇄 도수가 아님. WowPress `optioninfo`(기타 가공) 성격.

**증거**
- `huni-goods-option-mapping.md §2.2`: "본체색이 아니라 잉크색이므로 재질행 합성을 쓰면 안 됨. 단 만년스탬프 잉크색은 인쇄 도수(front_colrcnt)와도 결이 달라 **엄밀히는 GAP-OPT가 더 맞을 수 있음, 후니 도메인 확인 필요**."
- 라이브 도수축(`t_prd_product_print_options`)은 `front_colrcnt_cd`/`back_colrcnt_cd`(인쇄 색도 1도/4도 CMYK)를 담는 구조 — **"빨강 잉크 1색" 같은 단색 스탬프 잉크와 의미 불일치**(도수=인쇄 색 *수*, 스탬프 잉크=잉크 *종류/색*).
- 리필잉크(PRD_000015)는 **별도 상품(부자재)** → 잉크색 7종은 그 상품의 옵션 또는 `t_prd_product_sets` 동반 후보.

**엔티티/ref_dim 영향**
- A 선택 시: print_option 차원행 신설(.06) — 단 front/back colrcnt 의미축에 단색 잉크를 욱여넣어야 함(의미 왜곡 위험).
- B 선택 시: **GAP-OPT 해소가 선행조건**(신규 OPT_REF_DIM.08 자유옵션 vs 전용 테이블 — search-before-mint 별도). 잉크색을 자유옵션 항목으로.

**풀리는 것:** 만년스탬프·도장류 잉크 선택 옵션의 옵션 레이어화.

**권고: B(자유옵션그릇) — 단 GAP-OPT 해소에 종속, 조건부.** 근거: 스탬프 잉크는 인쇄 도수(CMYK 색도)와 의미가 명백히 다르고(도메인), print_option의 colrcnt 구조에 단색 잉크를 넣으면 의미 왜곡. 다만 GAP-OPT 자체가 아직 미해소(별 결정) → **GAP-OPT 결정과 묶어서 확정 권장.** 임시로 A(도수)로 적재하면 후일 재배선 비용 발생. **사용자 확정 필요(YES)** — 후니 도메인에서 잉크색을 "인쇄 도수"로 보는지, "별 잉크 선택"으로 보는지가 갈림.

---

## 2. 용량(머그 11온스) = 비치수 size(OPT_REF_DIM.01) vs 별 사양축/GAP-SHAPE

**후보**
- **A — 비치수 size(`OPT_REF_DIM.01`):** 물리 사양=규격. width/height 대신 용량 라벨. round-5 제안 `t_siz_nonspec_sizes`(비치수 마스터) 경유.
- **B — 별 사양축(volume 전용 컬럼/enum):** 용량은 부피라 width/height 없음 → 형상(원형/별)과 별도로 volume 컬럼 신설.

**증거**
- `huni-goods-option-mapping.md §2.3`: "WowPress엔 머그 직접대응 없음, 구조상 규격 후보. 용량(11온스)은 물리 사양이므로 규격(siz). 단 머그 용량은 width/height가 아닌 부피 → 비치수 siz(GAP-SHAPE와 동류)."
- round-5 `11_ddl_proposals/ddl-proposal-goods-pouch-nondim-size`: **이미 11온스/350ml/500ml를 "용량" 유형으로 비치수 마스터 `t_siz_nonspec_sizes`에 식별**(§1 라벨 유형표 "용량: 11온스·350ml·500ml — 선형치수 자체 없음"). 형상·용량·사이즈클래스를 한 비치수 마스터가 `kind_cd`(NONDIM_SIZE_KIND)로 분류해 수용하는 설계 존재.
- 라이브 실측(round-5): `t_siz_sizes` 497행 전수에서 **work·cut 치수가 모두 NULL인 순수 라벨 행 0건** → 용량을 기존 siz로는 못 올림(치수 발명 강제).

**엔티티/ref_dim 영향**
- A 선택 시: round-5 비치수 size 제안(`t_siz_nonspec_sizes` + `t_prd_product_nonspec_sizes`) 적용 후, 용량을 `kind_cd=용량`으로 등록. **단 OPT_REF_DIM.01 트리거는 `t_prd_product_sizes`(siz_cd)를 검사** → 비치수 마스터를 옵션화하려면 트리거에 비치수 차원 분기 추가 또는 별 ref_dim 필요(연계 결정).
- B 선택 시: 용량 전용 컬럼/축 — 형상과 분리, 과설계 위험.

**풀리는 것:** 머그·텀블러·보온병 용량 옵션의 옵션 레이어화.

**권고: A(비치수 size 마스터 경유) — 형상/용량/사이즈클래스 통합.** 근거: 용량은 물리 사양(WowPress 구조상 규격)이고, round-5가 이미 형상·용량·사이즈클래스를 한 비치수 마스터로 통합 식별 — 용량만 별 축을 두면 과분할(사용자 "과분할 금지"). **단 옵션 레이어 연결 시 트리거 분기**(비치수 size용 ref_dim 또는 트리거 확장)가 별도 결정으로 종속됨. **사용자 확정 필요(YES)** — round-5 비치수 size 제안(전용 마스터 ⓐ vs t_siz_sizes+spec_yn 통합 ⓑ) 택일과 묶임.

---

## 3. 면지/바인더링(booklet) = 자재(.03) vs 공정/셋트(.04/.07) — **[CONFIRM] RESOLVED (라이브 실측)**

**라이브 read-only 실측 (2026-06-07) — 결정적 증거:**

면지·링·제본을 `t_mat_materials`/`t_proc_processes`/`t_prd_product_materials`에서 전수 조회:

| 속성 | 라이브 정체 | 코드/유형 | product 연결 usage_cd |
|------|------------|-----------|----------------------|
| **면지(endpaper)** | `t_mat_materials` **자재** | MAT_000001~004 (화이트/블랙/그레이/인쇄면지), `mat_typ_cd=MAT_TYPE.01(종이)` | **USAGE.03(=면지)** ← 전용 용도 스코프 |
| **바인더링/링** | `t_mat_materials` **자재** | MAT_000012~023(링/D링/캘린더링 색상별) `MAT_TYPE.04(금속)`, MAT_000247~253 `MAT_TYPE.07(부속)` | **USAGE.07(=공통)** |
| 제본(itself) | `t_proc_processes` **공정** | PROC_000017~025 (제본/중철/무선/PUR/트윈링/하드커버…) | (택일그룹 GRP-BOOK-제본) |

**실 연결 행(t_prd_product_materials) 발췌:**
```
PRD_000072 하드커버책자  →  MAT_000001~003 면지   (usage_cd=USAGE.03)
PRD_000082 하드커버 링책자 →  MAT_000001~004 면지(USAGE.03) + MAT_000013~015 링(USAGE.07)
PRD_000088 레더 링바인더  →  면지(USAGE.03) + MAT_000247~249 D링(USAGE.07)
```
+ 면지/표지가 **별도 prd_cd 상품으로도 존재**(PRD_000074 "하드커버책자-면지(화이트면지)" 등) — base 상품과 sub-product(SKU) 이중 표현이나, **옵션축으로서의 면지/링은 t_prd_product_materials(.03)가 라이브 권위**.

**판정:** **A(자재 .03) 확정 — 라이브에 이미 그렇게 적재됨.** 면지=USAGE.03 스코프 자재, 바인더링/링=USAGE.07 스코프 자재. 둘 다 `OPT_REF_DIM.03`(ref_key1=mat_cd, **ref_key2=usage_cd**)로 옵션화하면 됨 — **신규 엔티티 0**.

**엔티티/ref_dim 영향:** 신규 DDL 불요. option_item이 `ref_dim_cd=OPT_REF_DIM.03, ref_key1=mat_cd, ref_key2=usage_cd`로 면지/링 자재행을 가리킴. 트리거 `fn_chk_opt_item_ref`가 (mat_cd, usage_cd) EXISTS 검사 — 이미 적재된 차원행이라 통과.

**풀리는 것:** 책자 면지(USAGE.03)·바인더링(USAGE.07) 옵션 즉시 옵션화 가능(차원행 선존재).

**권고: A — 라이브 확정 사실.** 사용자 신규 확정 불요. **검증만 필요(NO/검증)** — dbm-validator가 "면지=.03 USAGE.03, 링=.03 USAGE.07" 매핑을 엑셀 상품마스터(내지/표지/면지/링 컬럼)와 교차 확인. **라이브↔설계 문서 모순:** attribute-entity-map §5.3·cpq-option-gaps가 `[CONFIRM]`(자재 vs 공정/셋트 미상)으로 둔 것이 **라이브 실측으로 자재 확정** — 설계 문서를 라이브 기준으로 정정 권고.

---

## 4. 보드종류(폼보드/포맥스) = 자재 vs 가공 vs 형태 (GAP-BOARD)

**라이브 read-only 실측 (2026-06-07):**

| prd_cd | prd_nm | n_mat | n_proc | n_siz |
|--------|--------|:--:|:--:|:--:|
| PRD_000129 | 폼보드 | **0** | 2 | 2 |
| PRD_000130 | 포맥스보드 | **0** | 2 | 2 |
| PRD_000131 | 프레임리스우드액자 | **0** | 2 | 2 |
| PRD_000132 | 레더아트액자 | **0** | 0 | 6 |
| PRD_000144 | 미니보드스탠딩 | **0** | 0 | 3 |

+ `t_mat_materials`에서 "포맥스/폼보드/보드" 자재명 **0건**, `t_proc_processes`에서 동 키워드 **0건** → 보드 substrate가 자재로도 공정으로도 **라이브 미존재**(cpq-option-gaps GAP-BOARD 실측 확정).

**후보**
- **A — 자재(`OPT_REF_DIM.03`):** 보드 substrate=물리 소재. 화이트/블랙=본체색→재질 합성(마스터 지도 §3.1 정합), 두께(3mm/5mm)=depth spec.
- **B — 가공(`OPT_REF_DIM.04`):** L1 W열(가공축)에 둔 충실. "화이트보드"/"블랙보드"가 가공명처럼 기재됨.
- **C — 형태(siz depth 융합):** 두께를 siz에 융합.

**증거**
- `cpq-option-gaps.md GAP-BOARD`: "보드종류가 가공vs자재vs형태 모호. 라이브 마스터에 보드 공정·보드종류 자재 둘 다 부재. 5상품 materials 0행. **제안 후보 ① 자재(권고) — 보드 substrate=물리 소재, 화이트/블랙=본체색→재질 합성, 두께=depth spec.**"
- `silsa-coverage-map.md §6.1`: 공정명 키워드 0건·자재명 0건 실측.
- 마스터 지도 §3.1: "함께 고르는 물리 속성은 한 행으로 합성(소재+본체색=재질)" — 보드+색은 재질행 패턴 정합.

**엔티티/ref_dim 영향**
- A 선택 시: 신규 자재행(`t_mat_materials`: "폼보드(화이트)", "포맥스(화이트 3mm)" 등 합성행) + `t_prd_product_materials` 링크(usage_cd=USAGE.07). 두께는 mat_nm 라벨 또는 depth. ref_dim=.03. **신규 코드 불요**(MAT_TYPE 기존, 보드는 .07부속/신규 substrate 유형 검토).
- B 선택 시: 신규 공정행 — 단 "보드"는 substrate(본체)이지 가공이 아님 → 의미 부정합.
- C 선택 시: siz depth 융합 — 두께만 담고 substrate 종류(폼/포맥스/우드) 소실.

**풀리는 것:** 보드·액자 5상품의 본체 substrate 옵션화(현재 n_mat=0이라 옵션 불가).

**권고: A(자재 .03) — 보드 substrate=물리 소재.** 근거: 보드는 인쇄/가공 대상의 **본체**(종이/아크릴과 동격)이지 가공이 아니므로 자재가 의미 정합. 화이트/블랙은 본체색→재질 합성(과분할 금지), 두께(3/5mm)는 mat_nm 라벨 또는 depth. **단 신규 자재행 적재 + 본체 substrate를 어느 MAT_TYPE로(부속.07 vs 신규 substrate 유형)** 가 종속 결정. **사용자 확정 필요(YES)** — L1이 가공축에 둔 의도가 있다면 그 이유 확인 후 자재 vs 공정 최종 라우팅(침묵 선택 안 함).

---

## 5. 실내/실외 배너거치대 = 1 base 상품 + 옵션 vs 2 SKU(template)

**라이브 read-only 실측 (2026-06-07):**
- `우드거치대 PRD_000012` = **standalone 상품**으로 존재 + **이미 `TMPL-PRD_000012` 템플릿 보유**(base_prd_cd=PRD_000012). 라이브 "추가상품=template/SKU" 패턴 실증(addons 34행·templates 11행이 이 방식).
- "실내거치대"/"실외거치대" 명칭의 **distinct prd_cd 미존재** — 거치대 계열은 PRD_000012(우드거치대)·PRD_000160(아크릴자유형스탠드)·PRD_000162(아크릴포카스탠드) 등 **개별 상품**으로 분리돼 있음.

**후보**
- **A — 1 base 상품 + 옵션:** 거치대 1 상품에 "실내/실외" option_group(택1).
- **B — 2 SKU(template):** 실내·실외를 별 base_prd_cd 상품으로, 각각 `t_prd_templates` add-on template.

**증거**
- `attribute-entity-map.md` 패밀리③: "추가상품(거치대)=L2 add-on template(option_items 아님). 거치대 base_prd `[CONFIRM]`."
- `cpq-option-gaps.md`/HANDOFF "거치대 GAP-DATA": 거치대를 add-on으로 붙이는데 base_prd_cd 정체가 데이터 GAP.
- 라이브 패턴: 추가상품(봉투·거치대)은 **이미 add-on template(t_prd_templates)** 으로 모델 — 봉투(엽서 add-on)·우드거치대(TMPL-PRD_000012) 실증. add-on은 option_items가 아니라 template로 가는 것이 라이브 정합(cpq-schema §1.2: addon=tmpl_cd).

**엔티티/ref_dim 영향**
- A 선택 시: 거치대 1 상품 + 옵션그룹 — 단 실내·실외가 물리적으로 다른 거치대(다른 SKU·가격)면 옵션으로 묶기 부적합(가격·재고 분리 필요).
- B 선택 시: 실내·실외 각 prd_cd(이미 PRD_000012 등 분리 존재) + 각 template. **add-on 연결은 `t_prd_product_addons`(prd_cd, tmpl_cd)** — 신규 DDL 0, 데이터만.

**풀리는 것:** 배너 상품에 거치대 추가상품(실내/실외) 부착.

**권고: B(2 SKU/template) — 라이브 add-on 패턴 정합.** 근거: 라이브가 거치대를 이미 **개별 상품 + template**(우드거치대 PRD_000012 + TMPL-PRD_000012)으로 모델하고, 추가상품=template가 라이브 컨벤션(cpq-schema §1.2). 실내·실외가 다른 물리 거치대(다른 가격·SKU)면 2 template가 자연. **단 "실내거치대/실외거치대"의 실 prd_cd 매핑은 데이터 GAP**(어느 라이브 상품이 실내/실외인지) — 후니 데이터 확정 필요. **신규 DDL 불요**(template/addons 구조 실재) — **데이터 결정만**. **사용자 확정 필요(YES)** — 실내/실외가 별 SKU인지, 한 거치대의 옵션인지 + 실 prd_cd 매핑.

---

## 6. 핸드오프 (다음 단계)

1. **사용자 확정 4건**(1·2·4·5) + **검증 1건**(3, 라이브 확정 사실 교차검증).
2. 결정 1(잉크색 B) → GAP-OPT 해소와 묶음. 결정 2(용량 A) → round-5 비치수 size 제안 + 트리거 분기와 묶음. 결정 4(보드 A) → 신규 자재행 MAT_TYPE 결정. 결정 5(거치대 B) → 실내/실외 prd_cd 데이터 매핑.
3. 결정 3은 **신규 DDL 불요**(자재 .03 라이브 확정) → dbm-load-builder가 면지/링 option_item을 `OPT_REF_DIM.03`(ref_key1=mat_cd, ref_key2=usage_cd)로 즉시 조립 가능.
4. **DB 미적재·DDL 무적용 유지.** 본 문서는 결정 팩(proposal) — 적용·코드행·DDL은 인간 승인.
