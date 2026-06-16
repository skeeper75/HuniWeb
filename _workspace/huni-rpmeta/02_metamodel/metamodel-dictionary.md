# RedPrinting 옵션 관리 메타모델 사전 (metamodel-dictionary)

> rpm-metamodel-architect. RedPrinting 역공학(`01_reverse/`)에서 추상화한 **옵션 관리 메타모델**.
> **인스턴스 아님 — 패턴이다**(SKILL §"instance vs metamodel"). "현수막=타포린"은 인스턴스, "자재는 usage 역할과 합성 규칙을 가진다"가 메타모델.
> 인쇄 도메인 정초 = `07_domain/{entity-semantic-model(L3 9속성·C-9 생산방식),process-recipe-tree(L2 레시피)}`. **도메인 사실 준수: 별색=공정, 본체색=자재 CLR, 판걸이수=앱계산(DB 미저장).**
> RedPrinting은 검증된 참조 — 모델을 *있는 그대로* 포착(개선/후니 갭은 갭분석가 영역).
>
> **── 버전 ──**
> - **v1.0 (BN 파일럿):** 현수막류(BN) 6상품. 13축(7 정적 + 4 관계/동역학 + 2 횡단).
> - **v2.0 (GS 통합·현재):** + 굿즈/잡화(GS) 12상품. BN(평면 배너)·GS(완제/입체 굿즈) **2 상품군 증거**로 검증. GS 신축 2종 distinct 추가(D-9 생산형태·D-10 본체 형태가공), 기존 7축 확장(완제 본체/본체소재/variant 3채널/usage 다중슬롯/가격모델 3종). 총 **15축**.
>
> 축 총 **15개 = 7 정적 축(자재·공정·옵션·템플릿·제약·기초코드·카테고리) + 4 관계/동역학 축(부속물·공정파라미터·수량모델·제약논리) + 2 횡단 축(가격기여역할·인쇄방식레시피) + GS 신축 2(생산형태·본체 형태가공)**. 발굴 근거=`discovered-axes.md`.
>
> **GS 통합 원칙(과잉 일반화 경계, SKILL §5):** 2 상품군(BN 평면·GS 완제/입체)을 *둘 다* 견디는 패턴만 메타모델 축으로 승격. 한 군만의 특이(폰케이스 기종 enum 규모·코스터 6 pdtCode 분리)는 facet으로 강등(distinct 거부). BN 본체=`ORD_INFO.MTRL_CD`(자재) vs GS 본체=`DIR_MTR/WRK_MTR`(PCS 항목)는 **같은 자재축의 두 표현 facet**(아래 #1·#4 명시).
>
> 각 축 포맷: **identity**(관리 대상) · **entities(그릇 shape)**(추상 레코드, 후니 비종속) · **attributes** · **relationships**(FK/polymorphic/composition) · **constraint & cascade**.
> 확정도: ✅양군+도메인 권위 · 🟡부분+도메인 추론 · 🔴미관측(도메인 KB로 보강).

---

## I. 정적 축 (무엇을 등록하나)

### 1. 자재 축 (Material) ✅ — D-2 심화

- **identity:** 인쇄 본체를 구성하는 substrate/소재와 그 *합성 규칙*. (단순 enum이 아니라 다축 합성 + usage 슬롯 + 공정결합 메타규칙.)
- **entities(그릇):**
  - `Material` — 합성 자재 레코드.
  - `MaterialAxis` — 합성 분해축(TYPE/PTT/CLR/WGT/인쇄방식)의 코드 도메인.
- **attributes(Material):**
  - `mtrl_cd`(합성 PK, RP=MTRL_CD) — *분해 가능*해야 함.
  - `mtrl_type`(P 등 대분류), `ptt_cd`(소재/판형 — BFC현수막·MAS매쉬·TFC텐트천·VGP부직포), `clr_cd`(본체색 — X기본), `wgt_cd`(무게/두께), `print_method_enc`(수성C/라텍스L — 자재코드 인코딩, D-7).
  - `usage_cd`(슬롯 역할 — .01내지/.02표지/.03면지/.07공통, BN=substrate 단일 → **★GS 확인 ✅: usage 다중슬롯 실관측**). GS 스프링노트(GSNTSPR): `MTRL_CD=RIBVW350`(표지) + `INN_DFT`(내지=무지노트) + `RIN_DFT`(트윈링=금속부자재) 동시. GSTGMIC: `MTRL_CD=RXBVW300`(인쇄지) + `WRK_MTR`(스펀지). 즉 **한 주문에 자재가 여러 usage 슬롯**(표지/내지/링/스펀지)으로 분산 — entity-semantic §2 usage_cd 7종과 동형, BN 단일 substrate 한계 해소. 후니 "옵션=자재+공정 BUNDLE"(메모리 `dbmap-option-material-process-bundle`)의 RP 증거.
  - `sub_mtrl_yn`(부자재 여부 — 공정이 소비하는 자재인가).
  - `price_flag`(면적단가 분기키 — D-6).
- **relationships:**
  - Material → Product(belongs-to, 본체 구성).
  - Material.clr_cd → 본체색 variant(색상=자재 분기, *별색 아님*).
  - Process(sub_mtrl_yn=Y) → Material(**consumes**, FK — 아일렛=금속링, A-6).
  - Material → Process(**force**, 제약 — PET→코팅필수, D-3).
  - Material → Process(**disable**, 제약 — `pdt_disable_pcs_info`, D-3).
- **constraint & cascade:**
  - 합성코드 분해 규칙(평면 문자열 금지 — CLR/PTT/WGT/방식 분리 표현). entity-semantic §1-1 "자재축에 공정 섞임" 결함 회피.
  - 자재 선택 → 후가공 disable 룩업(BN 0건, 책자 24건).
  - **도메인 경계(HARD):** 별색≠자재(별색=공정 PROC_000007), 형상≠자재(형상→사이즈/카테고리/완칼, A-3), 두께=자재 식별자(아크릴 mm).

- **★GS 확장 — 완제 본체의 두 표현 facet (v2.0):**
  - **본체 표현이 상품군에 따라 두 가지:** (a) **BN형 = `ORD_INFO.MTRL_CD`** — 본체가 substrate 자재 1행(현수막=타포린). (b) **GS형 = `DIR_MTR`(부자재직접인쇄)/`WRK_MTR`(부자재작업) PCS 항목** — 완제 굿즈 본체(텀블러·실리콘끈·장패드·스펀지)가 PCS_INFO 첫 항목으로 들어가고 그게 result PRICE 주체(텀블러 45000·장패드 10000·마스크끈 2800). **두 표현은 같은 자재축의 facet**(둘 다 "본체 소재를 가리키는 자재 참조") — distinct 신축 아님. GS형에서 본체는 *완제 SKU 라벨*(PCS_DTL_NME="미르 와이드마우스 보틀 화이트 20oz")로 등장(템플릿 #4와 결합).
  - **본체 소재 = pdtCode 분리 패턴:** 같은 기능(코스터)이 본체 소재(규조토/펠트/코르크/종이/아크릴/레더)별로 **6개 별도 pdtCode**(GSTTDTM/GSPLCST/GSTTCRK/GSTTPAP/GSTTACR/GSTTREZ). RedPrinting은 소재를 *옵션이 아닌 상품정체*로 분리(소재≠variant, 소재=pdtCode). **도메인 정합:** entity-semantic §2 "색상 variant→material 자재 분기"·§4 "C 완제품: 굿즈"는 소재를 자재축으로 본다 → 코스터 6 pdtCode는 **자재축 + 카테고리(코스터=공통 기능 그룹) 복합의 RP 표현 선택**(아래 G-2 양면 트레이드오프). 한 군만의 카탈로그 정책이므로 facet(자재축에 흡수).
  - **★자재 오염의 RedPrinting판 (후니 갭 정합):** PCS_DTL_NME에 소재·색·용량·두께·브랜드가 융합("미르 와이드마우스 보틀 화이트 20oz") — 후니 "굿즈 본체소재 컬럼 부재·소재가 상품명에만"(메모리 `dbmap-axis-staged-load-round22` GPM 진단)과 **정확히 동형**. 즉 RP도 완제 본체에서 합성코드 분해(#1 (a))를 *못 하고* 라벨 융합으로 둠 → 메타모델 정답 = 완제 본체도 `{body_material, body_color, capacity, thickness, brand}` 분해축을 가져야 함(평면 라벨 금지).
  - **두께=자재 (GS 정합):** 장패드 "4T"(두께)가 DTL_NME 융합 — round-22 경계규칙 "두께=자재" 동형. 분해 시 wgt_cd로.

### 2. 공정 축 (Process) ✅ — D-2/D-4 확장

- **identity:** 본체에 가하는 작업(재단·코팅·봉제·타공·박·형압·완칼·아크릴가공·제본…). 순수공정 vs 자재소비공정 구분.
- **entities(그릇):**
  - `ProcessGroup` — 후가공 그룹(RP=PCS_COD: CUT_ZUN재단·COT_DFT코팅·ILT_DFT아일렛·SEW_DFT봉제·SEW_RIN고리·LUM_DFT각목·QBG_DFT큐방·ROP_DFT로프·SUB_MTR부자재·PKG_GB포장·CDL_DFT거치대[→부속물 D-1]).
  - `ProcessMember` — 그룹 내 상세 선택(RP=PCS_DTL_COD: ZDINC정사이즈재단·ZDFRM모양재단·TCMAS무광코팅·RCDFT사각귀퉁이…).
- **attributes(ProcessMember):**
  - `pcs_cod`(그룹), `pcs_dtl_cod`(멤버 leaf).
  - `esn_yn`(필수 여부 — CUT_ZUN/COT_DFT=Y, A-5).
  - `sub_mtrl_yn`(자재소비 — Y면 Material FK, D-2).
  - `qty_input_yn`(파라미터 수량 슬롯 보유 — D-4).
  - `seq`(공정 순서 — 출력→코팅→재단→후가공→포장, process-recipe §2).
  - `price_flag`(후가공가 — PCS_INFO[], D-6).
- **relationships:**
  - ProcessMember → ProcessGroup(belongs-to).
  - ProcessMember(sub_mtrl_yn=Y) → Material(consumes, D-2).
  - ProcessMember → ProcessParameter(has, 조건부 — D-4).
  - ProcessMember → ProcessMember(**precedes**, 순서 의존 — 오시→접지, 출력→코팅→재단, UV→레이저커팅, process-recipe §2-3).
  - ProcessGroup → 제약(excl_group 택1·essential — D-3).
- **constraint & cascade:**
  - 그룹 내 택1(SEL_TYPE.01 exclude) / 필수(ESN_YN essential).
  - 선행 공정 완료 후 후행(PDF "앞공정 안 찍으면 다음 못 찍힘" — process-recipe §2-1).
  - **도메인 경계(HARD):** 별색=공정(PROC_000007 family, 화이트/클리어/금/은 후공정), UV 변형=공정 파라미터(PROC_000002, print_side 오적재 금지), 줄수/조각수=공정 신호(옵션값 아님).

- **★GS 확장 — 제본 그룹 + 형태가공 분기 (v2.0):**
  - **제본방식 = 방식별 PCS_COD + 상호배타 택1 그룹:** `RIN_DFT`(트윈링)·`RIN_COL`(코일)·`STA_DFT`(중철). RedPrinting은 *그룹 메타 없이 코드만 다름* — 한 상품은 한 방식만(택1). 좌철/상철(`BPLFT`/`BPTOP`)=제본 방향 variant. 제본=공정+자재(링/코일=금속부자재 consumes #1) bundle. **도메인 정합:** entity-semantic §4 하드커버=표지/면지 반제품, process-recipe 제본 레시피.
  - **형태가공(완제 굿즈 조립)은 별도 distinct 신축으로 분리 → #14 참조.** `PDT_WRK`(파우치가공·마이크텍조립)·`FLX_ZIP`(지퍼)는 평면→입체 본체 조립 공정으로, 일반 후가공(본체에 작업 가함)과 lifecycle이 다름(본체 *형태 자체를 생성*). BN(평면 배너)엔 전무 → GS distinct(D-10).
  - **공정 멤버의 DTL코드가 variant 합일 키:** `THO_CUT`(완칼도무송) DTL = 칼틀 형상(NT001 하트/NT002 여권), GSTGMIC에선 `THO_CUT` DTL(TG001/3) = `WRK_MTR` DTL과 동일 키 → **한 DTL코드가 부자재·칼틀·사이즈·가격 동시 결정**(강결합 SKU variant). variant 3채널 ① DTL 방식(아래 #3 옵션축·G-4).
  - **포장 방식별 PCS_COD + 유료/무료 혼재:** `PAK_ETC`(텀블러·장패드)·`PAK_POL`(폴리백) 방식별 분기. 같은 PAK_ETC라도 텀블러=무료(0)·장패드=유료(1000) → 단가행이 상품×포장 조합. BN PKG_GB(강제 제약·A-5)와 달리 GS는 선택+개당과금 경향(공정-옵션 이중성, 가격기여 #11로 분기).

### 3. 옵션 축 (Option) ✅

- **identity:** 본체의 *독립 선택* 속성으로, 다른 축(자재·공정·사이즈·수량·파라미터)에 귀속되지 않는 순수 선택. (BN에서는 대부분 다른 축으로 분화 — 수량→D-5, 파라미터→D-4.)
- **entities(그릇):** `OptionGroup`(택1/택N) → `Option` → `OptionItem`(polymorphic 참조 — 후니 ref_dim_cd).
- **attributes:** `opt_group_cd`, `sel_type`(택1/택N), `opt_cd`, `ref_dim_cd`(polymorphic — 어느 차원 행을 가리키나: size/material/process/print/bundle), `disp_seq`(표시순서=컬럼순서, 메모리 `dbmap-load-column-order-staged`).
- **relationships:** Option → 차원 행(polymorphic ref — 후니 OPT_REF_DIM 7종), Option → 제약(D-3).
- **constraint & cascade:** 택1/택N, polymorphic 참조 무결성(후니 fn_chk_opt_item_ref). **BN 시사:** 옵션 축은 "분류되지 않은 잔여"가 아니라 *명시적으로* 수량/파라미터/부속물을 분리한 뒤 남는 순수 선택만 담음.

- **★GS 확장 — variant 3채널 인코딩 (v2.0·G-4):** 같은 "variant" 개념이 RedPrinting에서 *세 채널*로 분산 인코딩됨. 메타모델은 셋을 명시 구분(단일 평면화 금지):
  - **① DTL코드 채널 (SKU성 variant):** PCS_DTL_COD가 variant 키. GSMLSLC `DIR_MTR/MLS01`=색(핑크), GSTBMWM `TM039`=색+용량(화이트 20oz), GSTGMIC `TG001/TG003`=S/L(★사이즈+자재+칼틀+가격 동시 결정 강결합). → option_item이 *복수 차원을 동시 게이팅*하는 경우(G-4 정규화 난점). **도메인 정합:** entity-semantic §2 색상 variant→material, 사이즈 variant→size 2차원 분리 원칙 — RP DTL은 이 분리를 *코드 하나에 합일*해 둠 → 메타모델 정답 = DTL→{material, size, process, price} 다중 참조로 분해.
  - **② ATTB 채널 (옵션 파라미터 variant):** 옵션값이 ATTB 파라미터. GSNTSPR 트윈링 `ATTB="RIN_BLK"`(링색), 귀돌이 `ATTB="4"`(라운드 반경 4mm). → 공정 파라미터(#9)와 동근(ATTB=공정종속 매개변수). 링색·반경은 #9로 귀속.
  - **③ CUT 차원 채널 (사이즈 variant):** CUT_WDT/HGH가 variant. GSNTSPR 182×257(Medium)/132×182, GSNTSTA 132×132(여권형)/88×125 — 같은 MTRL_CD에 사이즈 프리셋만 변동 → 사이즈축(#13) 프리셋. THO_CUT 형상과 캐스케이드(형상↔사이즈 1:1).
  - **판정:** 3채널은 *기존 축들(옵션·공정파라미터·사이즈)로 분배*되므로 별도 "variant 축" distinct 신설 거부(facet). 단 ① DTL의 다차원 합일은 polymorphic option_item(후니 ref_dim_cd 다중)으로 명시 표현 필요.

### 4. 템플릿/SKU 축 (Template/Bundle) 🟡 — BN 약관측

- **identity:** 완제 주문 단위(SKU) 묶음 — 본체 + 부속물 + 선택 조합을 하나의 주문 가능 단위로. (BN: "현수막+거치대 1세트" 번들. 후니: 봉투결합 엽서·OTC.)
- **entities(그릇):** `Template`(SKU) → `TemplateSelection`(구성 선택 묶음).
- **attributes:** `tmpl_cd`, `prd_typ`(완제품/반제품/디자인/기성 — entity-semantic §4, BN=완제품 단일 🔴), 구성 selection 목록.
- **relationships:** Template → Product(본체), Template → Addon(부속물 D-1 포함, 번들), Template → 차원 선택 묶음.
- **constraint & cascade:** 번들 내 구성 일관성(거치대 size ↔ 본체 size match, D-3). **BN 한계:** prd_typ 다양성(반제품/디자인/기성)·완제 SKU 계층은 책자/굿즈 샘플 필요(discovered-axes 갭).

- **★GS 확장 — 완제 본체가 템플릿 항목 (v2.0·G-1):** GS 굿즈 본체(`DIR_MTR/WRK_MTR`)는 *완제 SKU 라벨*(PCS_DTL_NME)로 등장 — 자재(#1 본체 facet)이면서 동시에 *주문 가능 완제 단위*(템플릿/SKU). 즉 완제 굿즈에서 **본체 = 자재참조 + 템플릿 항목 복합**. RP는 이 복합을 한 PCS_COD(DIR_MTR)에 융합. **G-1 핵심 의사결정(양면 트레이드오프) → discovered-axes.md G-1.** 메타모델 정답 = 본체를 (a) 자재참조(소재 분해)와 (b) SKU 식별(개당단가 주체)로 *두 역할 분리*하되 한 엔티티가 둘 다 carry(완제 SKU = body_material_ref + sku_price_role). 생산형태(#15)가 이 분기를 governing(C 완제품 → 본체=완제 SKU 항목, A/B 통합·셋트 → 본체=자재행).

### 5. 제약 축 (Constraint) ✅ — D-3 유형화

- **identity:** 축 간 *관계 규칙* — disable/force/require/match/exclude/essential/min-max의 유형화된 논리 어휘. (메타모델의 관계 엔진.)
- **entities(그릇):** `Constraint`(logic-typed) — `{type, subject_axis, subject_ref, object_axis, object_ref, op}`.
- **attributes:** `constraint_type`(6유형, 아래), `logic`(JSONLogic, 후니 constraints.logic NOT NULL), `direction`(force=+ / disable=−).
- **6 논리유형(D-3):** disable(자재→공정−), force/require(자재→공정+, PET→코팅·텐트천→포장), essential(그룹내 필수 ESN_YN), match(사이즈↔부속물 1:1), exclude(그룹내 택1 SEL_TYPE.01), min-max(nonspec 범위 0~5000).
- **relationships:** *모든 축을 잇는 간선* — Material↔Process(disable/force), Size↔Addon(match), ProcessGroup-internal(exclude/essential), value-range(min-max).
- **constraint & cascade:** force = disable의 역방향(대칭 쌍). 캐스케이드 = match(선행 선택이 후행 선택지를 게이팅). 후니 round-6 캐스케이드 6종 → JSONLogic.

### 6. 기초코드 축 (Base-Code / Enum) ✅

- **identity:** enum 도메인 거버넌스 — 사이즈 프리셋, 도수 enum, 코드값 그룹의 권위.
- **entities(그릇):** `EnumGroup`(코드 그룹) → `EnumValue`(코드값) — 후니 BASE_CODE_GROUP.
- **attributes:** `group_cd`, `code`, `label`, `seq`. 사이즈 프리셋(DIV_NM: 5000X900·900X900…), 도수(SID_S 단면·PRN_CLR_CNT=4), usage/qty_unit/mat_type 등.
- **relationships:** EnumValue ← 자재/사이즈/도수/공정 축(코드 도메인 제공).
- **constraint & cascade:** 채번 규칙(surrogate PK + 이름기반 멱등, 메모리 `dbmap-code-identifier-strategy`), separator 통일. **사이즈 = 프리셋 enum + nonspec 범위제약**(기초코드 + 제약 복합, BN 전 상품 — A-2/sizes).

### 7. 카테고리 축 (Category) 🔴 — BN 미발굴

- **identity:** 상품군 트리 + 다중분류 + 생산형태(완제품/반제품/디자인/기성, entity-semantic §4와 직교).
- **entities(그릇):** `Category`(트리 노드, parent FK) — 상품 다중 소속 가능.
- **attributes:** `cat_cd`, `parent_cat_cd`, `main_yn`(잎노드), `생산형태`(prd_typ, 직교 분류).
- **relationships:** Product → Category(multi, 한 상품 여러 트리), Category → Category(트리 parent-child).
- **constraint & cascade:** 트리 무결성(고아 금지 — 메모리 round-22 고아 14노드 113상품 교훈). **BN 한계 해소(GS):** BN 전부 단일/완제품 C형이었으나 GS가 **공통 기능 그룹화**(코스터 6 pdtCode = 1 "코스터" 카테고리, 노트류 = 제본형 그룹)를 드러냄 → 카테고리 = 소재/형태 다른 다수 pdtCode를 한 기능 노드로 묶는 트리. **생산형태(완제품/반제품/디자인/기성)는 카테고리와 직교 → 별도 distinct 신축 #15로 분리**(GS가 C 완제품 다수 노출로 입증). 코스터 G-2 = 소재를 카테고리(공통기능)로 묶되 pdtCode 분리 vs 소재 옵션화 결정(discovered-axes G-2).

---

## II. 관계/동역학 축 (객체들이 어떻게 결합·게이팅·매개변수화되나) — 발굴

### 8. 부속물 축 (Addon) ✅ — distinct D-1

- **identity:** 본체와 *분리된 완제 부속 부품*(거치대·우드봉·볼체인·이젤).
- **entities(그릇):** `Addon`(독립 SKU) — 후니 `t_prd_product_addons`.
- **attributes:** `addon_cd`(독립 코드 — PT001~005·RLU01~03·PTODF…), `label`(실내/실외 + 종류), `size_variant`(롤업거치대 600/850/1000), 자체 재고/가격.
- **relationships:** Addon → Product(belongs-to, 번들 — D-1≠템플릿: 부속물=부품, 템플릿=번들단위), Addon ↔ Size(**match** 제약 — 롤업 size↔거치대 1:1, D-3).
- **constraint & cascade:** 부속물↔사이즈 캐스케이드(size 선택 → 호환 거치대만). 본체와 별개 lifecycle(독립 SKU). **공정 아님**(본체 변형 아님), **옵션 아님**(외부 객체).

### 9. 공정 파라미터 축 (Process Parameter) ✅ — distinct D-4

- **identity:** 공정 멤버에 종속된 *조건부 매개변수* 슬롯(공정 선택 시만 활성).
- **entities(그릇):** `ProcessParameter` — `{owner_process, param_type, value_domain}`. 후니 prcs_dtl_opt / ref_param_json.
- **attributes:** `owner_pcs_dtl_cod`(부모 공정), `param_type`(수량/줄수/단수/mm/색/조각수), `value_domain`(로프 USER/1~10, 오시 0~3, 접지 16종, 책등 mm, 링컬러, 조각수).
- **relationships:** Parameter → ProcessMember(belongs-to, 조건부), Parameter → 가격(공정과 결합 기여, D-6), Parameter ↔ Parameter(캐스케이드 — 오시 줄수→접지 단수, D-3 match).
- **constraint & cascade:** 부모 공정 미선택 시 비존재(조건부 활성). **도메인 경계(HARD):** 판걸이수(impos)는 *앱 계산*(DB 미저장) — 파라미터에 넣지 말 것. 파라미터=*입력* 매개변수만(메모리 `dbmap-compute-in-app-db-stores-lookup`).

### 10. 수량 모델 축 (Quantity Model) ✅ — distinct D-5

- **identity:** 단일 스칼라가 아닌 *다중 의미적 수량 슬롯*(주문 건수 × 인쇄 수량 + 공정종속 수량).
- **entities(그릇):** `QuantitySlot` — `{slot_type, value_domain, price_role}`.
- **attributes:** `slot_type`(ORD_CNT 디자인건수 / PRN_CNT 인쇄수량 / 공정종속 D-4 교차 / bundle_qty 묶음수), `price_role`(건수=세팅곱수 / 수량=선형, D-6).
- **relationships:** QuantitySlot → Product(상품마다 노출 슬롯 다름), QuantitySlot → 가격기여역할(D-6), 공정종속 슬롯 → ProcessParameter(D-4 교차).
- **constraint & cascade:** min(건수 1). **도메인 구별:** ORD_CNT(디자인 건수)≠PRN_CNT(인쇄 수량)≠bundle_qty(묶음 권/세트, entity-semantic #7)≠page_rule(내지). 평면화 금지.

---

## III. 횡단 축 (모든 축에 부착/게이팅) — 발굴

### 11. 가격기여 역할 축 (Pricing Role) ✅ — distinct(횡단) D-6

- **identity:** 각 선택축이 가격에 *어떻게* 기여하는가의 역할 태그(면적/곱수/고정/단가매트릭스).
- **entities(그릇):** 독립 테이블이 아닌 *각 축 엔티티에 부착되는 태그* + `PricingModel`(상품 단위 — SizeMatrix2D 등).
- **attributes:** `price_flag`/`price_role`(자재→면적단가키, size→면적, dosu→도수가, pcs→후가공가, ord_cnt→세팅곱수, prn_cnt→선형), `pricing_model`(real_price=면적 SizeMatrix2D, 고정가형, 합가형 — 메모리 `dbmap-price-formula-types-authority`).
- **relationships:** PricingRole → 모든 선택축(부착), PricingModel → Product(바인딩). 후니 t_prc_* 4단(prc_typ_cd 단가/합가).
- **constraint & cascade:** 면적기반 상품은 size→면적 매트릭스 + ceiling(off-grid). **경계:** 본 하네스는 *역할 분류*까지 — 실제 값/공식은 dbmap 가격 트랙. PRICE=0(비로그인)은 구조 추출에 무관.

- **★GS 확장 — 가격모델 3종 라우팅 (v2.0·G-7):** BN은 `real_price`(면적 SizeMatrix2D) 단일이었으나, GS는 완제 SKU 위 **3 가격모델**이 같은 옵션 모델에서 분기:
  | price_gbn | 가격 SP | 의미 | 가격 주체 |
  |---|---|---|---|
  | `tmpl_price` | `WSP_..._TMPL_PCS_PRICE` | 템플릿(완제 SKU) 개당단가. PRICE_LOG=개당단가+인쇄수량+주문건수 | DIR_MTR(완제 본체) |
  | `vTmpl_price` | `WSP_..._TMPL_PCS_PRICE` | variant 템플릿(v접두). tmpl과 동일 SP·변형 SKU 분기 | DIR_MTR + 가산항(장패드: 본체10000+인쇄5000+포장1000) |
  | `tiered_price` | `WSP_..._TMPL_PCS_TIERED_PRICE` | 구간(tier)가. PRICE_LOG에 **자재단가** 필드 추가(tmpl엔 없음). 수량구간 할인 동반 | PRT_DFT(인쇄, 완제본체 없는 굿즈) |
  - **시사:** `pricing_model` enum이 **면적형(BN real_price)·완제SKU개당가(tmpl)·variant템플릿(vTmpl)·구간가(tiered)** 4종으로 확장. 메모리 `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형) 정합 — tmpl/vTmpl=고정가형 분기, tiered=구간할인(round-1 t_dsc_* 동형). **라우팅 키:** price_gbn = 상품 속성(가격모델 선택)이며, 완제본체 유무(DIR_MTR 있음=tmpl/vTmpl, 없음=tiered가 PRT_DFT 주체)가 분기 단서. **vTmpl vs tmpl 차이(variant 유무)는 옵션 구조에 재영향** → 가격모델↔옵션 양방향. 가격 SP 내부 로직은 `unobserved`(PRICE_LOG 외, 갭분석가·dbmap 가격 트랙 영역).

### 12. 인쇄방식/생산 레시피 축 (Print-Method Recipe) ✅ — distinct(조건부) D-7

- **identity:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 *가능 공정·파일포맷·생산팀·기초데이터를 게이팅*하는 최상위 레시피 축.
- **entities(그릇):** `PrintMethod`(레시피) — 후니 PROC_000002~6. (RP는 자재코드에 인코딩, 후니는 1급 트리.)
- **attributes:** `method_cd`(디지털/실사/UV/옵셋/실크), `allowed_processes`(가능 공정 부분집합), `file_formats`(PDF/JPG/PDF+커팅AI), `team`(생산팀).
- **relationships:** PrintMethod → ProcessMember(**gates** 가능집합), → 파일포맷, → 생산팀, → 자재(RP 인코딩 중첩 — 수성/라텍스 자재 facet, D-7 양면 표현).
- **constraint & cascade:** 1상품=1인쇄방식(process-recipe §1) → 가능 공정 게이팅. UV→레이저커팅→아크릴가공 시퀀스. **양면 표현(HARD):** 인쇄방식은 (a) 자재 facet 인코딩(RP) 또는 (b) 1급 게이팅 축(후니) — 강제 분리 금지(메모리 `dbmap-print-method-not-absolute-axis`).

### 13. 사이즈 축 (Size) ✅ — 기초코드+제약 복합(명시)

> A-2/A-3/A-5에서 횡단 참조되어 별도 명시(기초코드 #6 + 제약 #5의 복합이나 1급 취급).

- **identity:** 재단치수(고객 선택 완성품 치수) — 프리셋 enum + nonspec 자유입력 범위.
- **entities(그릇):** `SizePreset`(enum) + `NonspecRange`(범위 제약).
- **attributes:** `div_nm`(프리셋 — 5000X900·900X900), `cut_wdt/hgh`(재단), `work_size`(=재단+CUT_MRG 4mm 자동), `nonspec_min/max`(0~5000), `user_input`(SIZE_0 자유).
- **relationships:** Size → 가격(면적 SizeMatrix2D, D-6), Size ↔ Addon(match — 롤업, D-3), Size = 형상 흡수(어깨띠 폭좁고 김 — 별도 shape축 없음, A-3).
- **constraint & cascade:** 프리셋 선택→cut 룩업 / 직접입력→USER 수치(min/max 범위). 작업=재단+4mm. **도메인 경계:** size=재단치수 ≠ plate(작업/전지 판형, entity-semantic #1/#6 별개 축). 형상은 size 프리셋으로 흡수(shape 1급화=오버피팅 거부).
- **★GS 확장:** 사이즈 프리셋이 *복합 차원*일 수 있음 — 파우치 "13인치 가로형/세로형"(기종 × 방향), 노트 "여권형/Medium"(형상 캐스케이드). THO_CUT 형상↔사이즈 1:1(메모리 round-3 K컨펌 "도무송 형상=size 칼틀 1:1" 동형). 폰케이스 기종 enum(GSCAPHN, unobserved)은 사이즈 프리셋의 *대규모 enum* — 별도 "기종 축" distinct 거부(facet, G-3): 기종=사이즈/칼틀 프리셋의 대규모 인스턴스일 뿐 고유 lifecycle 없음.

---

## II-b. GS 신축 (완제/입체 굿즈가 드러낸 distinct 축) — 발굴 v2.0

### 14. 본체 형태가공 축 (Body Form-Assembly) ✅ — distinct D-10 (GS 신축)

- **identity:** 평면 인쇄물을 *입체 완제 굿즈로 조립/봉제/형성*하는 공정 — 본체 형태 자체를 생성. 일반 후가공(기존 본체에 작업 가함, #2)과 lifecycle 구별: 형태가공이 없으면 본체가 *존재하지 않음*(파우치 = 가공 없으면 평면지).
- **entities(그릇):** `FormAssembly` — `{assembly_cd, assembly_type, consumes_material, direction_variant}`. RP=PCS_COD `PDT_WRK`(제품가공)·`FLX_ZIP`(지퍼가공).
- **attributes:**
  - `assembly_cd`(RP=PDT_WRK PUBOK 파우치가공·PKT01 마이크텍조립 / FLX_ZIP ZPH01 지퍼).
  - `assembly_type`(봉제/조립/지퍼/접합).
  - `consumes_material`(지퍼=부자재 지퍼 소비 — #1 consumes FK).
  - `direction_variant`(지퍼 세로형/가로형 — DTL variant).
- **relationships:**
  - FormAssembly → Product(belongs-to, 완제 굿즈 본체 형성).
  - FormAssembly(지퍼) → Material(**consumes** — 지퍼=부자재, #1·#2 동형 아일렛 패턴).
  - FormAssembly → 생산형태(#15, C 완제품/입체에서만 활성).
  - FormAssembly → ProcessMember(seq — 인쇄→재단→형태가공 순서).
- **constraint & cascade:** 본체 정체와 결합된 *필수* 공정(파우치는 PDT_WRK 없으면 미완성). 방향 variant(세로/가로)는 옵션. **distinctness 근거:** BN(평면 배너) 전무·GS(파우치·마이크텍) 다수 → 단일상품 아님(GSPUFBC·GSTGMIC 2상품 + 효자손/폰케이스 추정). 일반 후가공이 "본체에 작업"인 반면 형태가공은 "본체를 *생성*" → #2가 왜곡 없이 못 담음(distinct 정당). 후니 굿즈 BOM "평면→입체 조립 단계" 동형(메모리 round-22 본체 자재 BOM).

### 15. 생산형태 축 (Production Type) ✅ — distinct D-9 (GS 신축, 카테고리와 직교)

- **identity:** 상품의 *생산 구조 분류* — 완제품 / 반제품(셋트) / 통합 / 기성 / 디자인. 카테고리(기능 트리)와 **직교**하며, 본체 모델링 방식(#1·#4)·형태가공(#14)·자재 usage(#1)를 *governing*하는 상위 분류축.
- **entities(그릇):** `ProductionType` — `{prd_typ, body_model, set_structure}`. 도메인 권위 = entity-semantic §4 C-9 3구조.
- **attributes:**
  - `prd_typ`(A 통합 / B 셋트·반제품 / C 완제품·단일 / 기성 / 디자인).
  - `body_model`(A·B = 본체=자재행 parent+usage_cd / C = 본체=완제 SKU 항목 DIR_MTR).
  - `set_structure`(B = 표지/면지 sub_prd 빈껍데기 + sets 연결 / A·C = sets 0).
- **relationships:**
  - ProductionType → Product(classifies — 1상품 1생산형태).
  - ProductionType → 본체 모델링(governs #1/#4 — C 완제품→DIR_MTR SKU, A/B→자재행).
  - ProductionType → FormAssembly(#14 — C 입체 굿즈에서 형태가공 활성).
  - ProductionType → 자재 usage(#1 — B 셋트=표지/면지 다중 usage, A 통합=단일 캐스케이드).
  - ProductionType ⊥ Category(직교 — 같은 "노트" 카테고리에 통합책자[A]·하드커버[B] 공존).
- **constraint & cascade:**
  - C 완제품(굿즈·낱장·대형): 내지/표지 개념 없음, 본체=완제 SKU(GS DIR_MTR), 형태가공 가능.
  - B 셋트(하드커버·포토북): 표지/면지=반제품 sub_prd, sets 연결, 자재 권위=parent+usage_cd(sub_prd 9속성 0행=정상).
  - A 통합(일반 책자·노트): 내지/표지 단일행 캐스케이드.
  - **distinctness 근거:** 도메인 권위(entity-semantic §4 "C-9 해결 — 생산방식 3구조 A/B/C 확정·11군 매핑")가 1급 축으로 확정. GS가 C 완제품(텀블러/코스터/효자손)·A 통합(노트)을 다수 노출해 **카테고리와 직교**임을 입증(같은 카테고리에 A·C 공존). 메모리 `dbmap-grid-binding-round15` "생산형태 3분류 × 그릇 binding"·"라이브 prd_typ_cd≠생산형태(오모델)" 정합 — 카테고리/템플릿이 왜곡 없이 못 담음(생산형태는 그 둘을 *governing*). distinct 정당.
  - **★후니 갭 경고:** 메모리 round-15 "라이브 prd_typ_cd가 생산형태와 불일치(굿즈/문구=.03기성·디지털/실사/아크릴=.04디자인 오귀속)" — 후니 라이브가 이 축을 *오모델링* 중. GS가 RP 정합 모델 제공.

---

## 메타모델 핵심 명제 (RedPrinting 정규화 방식 요약)

1. **자재는 합성된다** — MTRL_CD 하나가 소재·색·무게·인쇄방식 4~5축 인코딩(D-2). 분해 표현력 필수(평면화=의미축 drop).
2. **공정은 자재를 소비할 수 있다** — SUB_MTRL_YN 플래그로 순수공정(재단) vs 자재소비공정(아일렛=금속링+타공) 분리(D-2). 후니 [HARD] "옵션=자재+공정 BUNDLE"과 동형.
3. **공정은 파라미터를 갖는다** — 공정 종속 매개변수(줄수·mm·색·수량)는 별도 축(D-4). 옵션·수량과 혼동 금지.
4. **수량은 다중 슬롯이다** — 디자인 건수×인쇄 수량(D-5), 가격기여 메커니즘 다름.
5. **부속물은 본체와 분리된다** — 거치대=독립 SKU(D-1). 템플릿(번들)·옵션과 별개.
6. **제약은 유형화된 어휘다** — disable/force/match/exclude/essential/min-max 6유형(D-3). force=disable의 역방향. 메타모델의 관계 엔진.
7. **가격기여는 횡단 역할이다** — 모든 선택축이 면적/곱수/고정/단가 역할을 가짐(D-6).
8. **인쇄방식이 레시피를 게이팅한다** — 가능 공정·파일·팀 결정(D-7). RP=자재 facet / 후니=1급 축 양면 표현.
9. **UI 런타임은 중립이다** — Vue/jQuery 두 런타임이 단일 base-data 공유(D-8 facet). 메타모델은 표현 독립.
10. **★생산형태가 본체 모델링을 governing한다 (GS·D-9)** — C 완제품(굿즈)→본체=완제 SKU 항목(DIR_MTR), A 통합/B 셋트→본체=자재행. 카테고리(기능 트리)와 직교. BN(평면)·GS(완제) 두 패러다임을 한 메타모델에 통일하는 *governing 축*.
11. **★완제 본체는 자재참조 + SKU 항목 복합이다 (GS·G-1)** — 굿즈 본체(DIR_MTR)가 PCS 항목이자 PRICE 주체. 소재/색/용량/두께가 SKU 라벨에 융합(후니 본체소재 부재 동형) → 분해축 필수(평면 라벨 금지). BN 본체=자재행과 *같은 자재축의 두 facet*(distinct 신축 아님).
12. **★평면→입체 형태가공은 별도 공정 lifecycle이다 (GS·D-10)** — PDT_WRK/FLX_ZIP가 본체를 *생성*(일반 후가공=본체에 작업). 굿즈 특유 distinct 축.
13. **★variant는 3채널로 분산 인코딩된다 (GS·G-4)** — DTL코드(SKU성·다차원 합일)·ATTB(공정 파라미터)·CUT(사이즈 차원). 단일 평면화 금지·기존 축으로 분배. 한 DTL이 자재+사이즈+칼틀+가격 동시 결정(강결합)은 polymorphic option_item 다중 참조로.
14. **★가격모델은 옵션 모델 위에서 라우팅된다 (GS·G-7)** — 면적형(BN)·완제SKU개당가(tmpl)·variant템플릿(vTmpl)·구간가(tiered) 4종. price_gbn=상품 속성, 완제본체 유무가 분기 단서.

> **도메인 사실 준수 체크(HARD):** 별색=공정(D-2/#2) · 본체색=자재 CLR(D-2) · 판걸이수=앱계산 DB미저장(D-4) · UV변형=공정파라미터 not print_side(#2) · size≠plate(#13) · 형상≠자재(#13 흡수) · **생산형태⊥카테고리(#15)** · **완제 본체=자재 facet not 신축(#1)** · **두께=자재(#1 GS 장패드 4T)**. 전부 entity-semantic-model L3(C-9 생산방식)·process-recipe-tree L2 정합.

> **GS 통합 과잉일반화 거부 기록:** ① "완제 본체 SKU" = 자재축 facet(distinct 거부 — BN/GS 같은 자재참조). ② "본체 소재 pdtCode 분리" = 자재+카테고리 복합 facet(distinct 거부 — RP 카탈로그 정책일 뿐). ③ "variant 3채널" = 기존 옵션/공정파라미터/사이즈로 분배(distinct 거부). ④ "기종 enum"(폰케이스) = 사이즈 프리셋 대규모 인스턴스(distinct 거부). **distinct 승격 = 생산형태(#15)·본체 형태가공(#14) 2종만**(BN·GS 둘 다 견디는 governing/lifecycle 보유).
