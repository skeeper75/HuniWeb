# 후니 그릇 필요 항목 우선순위 (vessel-needs)

> rpm-gap-analyst. `gap-matrix.md`의 **GAP/WEAK 축**을 leverage(unblock 상품/축 수·FK 의존도·load-bearing)로 우선순위화.
> 각 항목 = **vessel-gap만**(스키마가 축을 표현 못함). 행 오염(data) 교정은 dbmap 트랙(B-3 등) — 여기 아님.
> [HARD] 본 산출은 *어떤 그릇이 왜 필요한가*까지. 정확한 CREATE/ALTER DDL·search-before-mint 증명은 `rpm-vessel-designer`(04_vessel) 영역.
> ※ vessel ≠ 데이터 적재. 적재는 huni-dbmap. ※ search-before-mint 미수행 — designer가 기존 구조 무손실 표현 가능성 먼저 입증할 것.
>
> **── 버전 ──**
> - **v1.0 (BN):** V-1~V-7 (BN 13축 vessel-gap). **보존.**
> - **v2.0 (GS):** + V-3 **굿즈 분해축 확장**(본체색/용량/두께) + **V-8 본체형태가공(#14 GAP)** + **V-9 생산형태 governing(#15 WEAK)**. GS 라이브 실측(2026-06-17)이 V-4 min-max·④template_prices·⑬nonspec을 **완화**(아래 정정 노트).
> - **v3.0 (TP):** + **V-10 디자인 입력 채널 그릇(#16 GAP·★P1 최우선·directive 핵심)** + V-10 종속 **TemplateAsset 분리**(T-A 이중의미)·**VDP 변수 스키마**(T-B). TP 신규 vessel-gap = V-10 1건(BN/GS 항목 불변·보존).
> - **v4.0 (PR·현재):** **신규 vessel-gap = 0건.** PR(인쇄물·책자·리플렛·포스터)이 distinct 신축 0(facet 강화 9건뿐) → 새 그릇 수요 없음. PR facet 6항(표지/내지·접지/제본·page_rule·면지 bundle·digital_price·인쇄방식 게이팅)의 PASS 4·WEAK 1·GAP 1은 **전부 기존 V-항목에 흡수**(가이드 = 아래 ## PR 흡수 매핑). V-1~V-11 항목·우선순위 **불변·보존**.

---

## 우선순위 산정 기준

leverage = (① unblock 상품 수) × (② 횡단성: 몇 축을 푸는가) × (③ FK load-bearing: 다른 축이 의존하나). GAP > WEAK 우선(표현력 0 vs 부분).

---

## P1 — 최우선 (표현력 0 + 횡단 게이팅)

### V-10. ★디자인 입력 채널 그릇 (#16 GAP) — leverage ★★★ (directive 1순위·TP 본질·dbmap 미터치 신규)

- **무엇:** 상품의 디자인을 *어떻게 입력받나*(에디터 채널 + 입력방식)를 담는 축. RP `DesignInputChannel`(channel=item_gbn[KOI/Edicus/PDF]·use_koi/rp_editor·use_template_download·use_pdf·ord_cnt_source·vdp_capable) + 종속 `TemplateAsset`(에디터 디자인 시안·가격0)·VDP 변수 스키마.
- **왜 필요:** **라이브 information_schema 실측(2026-06-17)**: `t_prd_products`에 디자인 입력 신호 = **`editor_yn`·`file_upload_yn` 불리언 2개뿐.** RP `item_gbn`(3분기)·에디터 종류(KOI vs Edicus vs RP)·`koi_template_resource_id`(템플릿 리소스)·VDP 변수 스키마·디자인수 산정 출처에 대응할 **컬럼·테이블·base_code enum 전무**(전역 검색 0건·16그룹에 에디터 채널 enum 없음). 후니=Edicus를 huni-widget RedEditorSDK *코드 계약*으로만 보유, **DB 그릇 미정(T-1 가설) 라이브 확정.** 그릇 없으면: ① 한 상품이 어느 에디터로 디자인 입력하는지 DB로 표현 불가(앱 하드코딩) ② 에디터 기성 템플릿 시안 카탈로그 미관리(런타임 SDK만) ③ 디자인수(ORD_CNT) 산정 출처(PDF/에디터)가 수량모델#10에 연결 안 됨 ④ VDP(명함·상장 가변데이터) 그릇 부재.
- **unblock:** TP 23상품(디자인명함·티켓·캘린더·북·평면지류) + 전 카테고리 editor_yn=Y **107상품**(에디터 사용). huni-widget 컨버전(Edicus 어댑터)이 DB 입력채널 메타에 의존 → 위젯-DB 경계 1급. MES 생산팀 라우팅(에디터 채널별 입력물 처리)에도 연결.
- **사다리 후보(designer 판정):**
  - ① **base_code enum 신설** — `EDITOR_CHANNEL`(또는 `DESIGN_INPUT`) 그룹(KOI/Edicus/RP/PDF·offset) = 코드행 사다리 최저단(채널 타입 분류).
  - ② **`t_prd_products` 컬럼 추가** — `design_input_channel_cd`(→ ①enum)·`template_resource_id`(에디터 리소스 포인터)·`ord_cnt_source`(PDF/에디터)·`vdp_yn`. 현 `editor_yn` 불리언 *대체/보강*(search-before-mint: editor_yn+file_upload_yn 조합으로 channel 일부 환원 가능한지 — Y/Y vs N/Y vs Y/N 4분포가 KOI/PDF/Edicus 환원에 부족함을 designer가 증명).
  - ③ **TemplateAsset 별 테이블**(T-A 종속) — 에디터 디자인 시안 카탈로그(template_resource_id·asset_options·price=0·channel FK). **★`t_prd_templates`(완제SKU·봉투)와 별 엔티티**(이중의미 분리·아래 V-11).
  - ④ **VDP 변수 스키마**(T-B 종속) — 가변데이터 필드 정의(명함 이름/직함). 미관측(`koiOption[]` 빈배열·로그인 에디터 필요) → 검증 후 designer 판정.
- **dbmap 라우팅:** **dbmap 미터치(신규 vessel-gap·중복/충돌 없음).** huni-widget `seed-redprinting-sdk-analysis.md`(RedEditorSDK 45메서드)·`editor-bridge-protocol.md`(cmd create-design-project·editor_type/run_mode)가 코드 계약 권위 → designer가 DB 그릇 설계·`dbm-ddl-proposer`. **huni-widget 컨버전 전략과 정합 필수**(어댑터가 읽을 입력채널 메타).
- **[HARD] directive 1순위:** 본 하네스(RP-Meta)의 TP directive 핵심 = "디자인 입력 채널 vessel-gap 판정". GAP 확정 → V-10이 vessel 설계 **최우선**. 단 designer는 search-before-mint(editor_yn 환원 한계 증명) 선행.

### V-1. 공정 파라미터 그릇 (#9 GAP) — leverage ★★★

- **무엇:** 공정 멤버에 종속된 매개변수 슬롯(줄수·mm·색·조각수·구수). RP `ProcessParameter`.
- **왜 필요:** 라이브 `option_items`에 `qty`만 — 타공 4/6/8(구수)·봉제 유형·오시 줄수·책등 mm를 표현 못함(의미축 drop·캐스케이드 불가). 설계 `ref_param_json` **미구현**(cpq-schema §4 🔴8).
- **unblock:** 타공/봉제/오시/접지/책등 공정 보유 상품 다수(banner·postcard·booklet·아크릴). CPQ 옵션이 공정 파라미터 의존 → option layer 완성의 선결.
- **사다리 후보(designer 판정):** ① `t_prd_product_option_items.ref_param_json` jsonb 컬럼 추가(설계 원안) ② 또는 `t_proc_*`에 param 슬롯 테이블. search-before-mint: 기존 `qty`+공정 행 분리로 무손실 가능한지 먼저 증명.
- **dbmap 라우팅:** `cpq-schema.md §4 🔴8`·`dbm-ddl-proposer`(컬럼 추가 재제안). round-6 CPQ와 연계.

### V-2. 인쇄방식 레시피 게이팅 그릇 (#12 GAP, 조건부) — leverage ★★★

- **무엇:** 인쇄방식(디지털/실사/UV/옵셋/실크)이 가능 공정 부분집합·파일포맷·생산팀을 게이팅하는 1급 레시피 축. RP `PrintMethod`.
- **왜 필요:** 인쇄방식은 공정 행으론 있으나(PROC_000002~6) 게이팅 lifecycle(방식→가능공정 집합→파일/팀) 표현 그릇 부재. 1상품=1방식 게이팅이 앱 암묵 규칙.
- **unblock:** 전 상품(방식별 가능 공정 결정 = 옵션 캐스케이드 최상위). MES 생산팀 라우팅에도 연결.
- **조건부 주의(HARD):** 인쇄방식 절대축 아님(`dbmap-print-method-not-absolute-axis`) — 강제 1급화 금지. designer는 (a) 1급 PrintMethod 테이블 vs (b) 제약 축(force/disable)으로 게이팅 흡수 중 트레이드오프 평가. 후니 도메인=디지털+굿즈 중심이라 RP만큼 방식 다양성 없을 수 있음.
- **dbmap 라우팅:** `process-recipe-tree §1`·designer가 1급화 여부 판정 후 ddl-proposer.

---

## P2 — 표현력 부분 결손 (의미축 분리)

### V-3. 자재 합성 분해축 (#1 WEAK·vessel 부분) — leverage ★★★ (오염 광범위) ★GS 확장

- **무엇:** 합성 자재의 분해축 — 본체색(CLR)·소재(PTT)·무게/두께(WGT)·인쇄방식을 *분리된* 표현으로. RP `MaterialAxis`. **★GS 확장: 완제 본체의 `{body_color, capacity, thickness, brand}` 분해축**(RP `PCS_DTL_NME` "화이트 20oz" 융합 해소).
- **왜 필요:** `t_mat_materials.mat_nm`이 평면 문자열. **라이브 컬럼 실측(2026-06-17)**: `t_mat_materials`에 `width·height·depth·weight`(물리치수)만 — RP의 `body_color/capacity/thickness/brand` 분해축 컬럼 **부재 확정**. MAT_TYPE.09(파우치) 69행·.10(악세사리) 43행이 색/형상/인쇄면/구수/사이즈/용량을 통째로 `mat_nm`에. 분해축 그릇 없으면 위젯 옵션 캐스케이드·가격 분기 붕괴 + 후니도 RP처럼 상품명/라벨 융합 고착(굿즈 본체소재 결함의 vessel 근원).
- **★굿즈 본체자재 판별(사용자 핵심 질의):** vessel-gap **양면** — ① 본체소재 *링크* 그릇(product_materials+usage)은 **PASS**(레더/린넨/아크릴 코스터 실제 링크·round-22 41 COMMIT) ② 본체소재 *분해축*(색/용량/두께)은 **vessel-gap**(컬럼 부재) ③ 미적재 소재(우드/코르크/규조토)·오염(.09/.10)은 **data**(dbmap). → **여기 산출 = ②의 분해축 그릇만.**
- **unblock:** 굿즈/파우치 103상품+(MAT_TYPE.09 69행·.10 43행). round-22 B-3가 축이동하려면 목적지 그릇(본체색=자재 CLR 슬롯 등) 선결. 텀블러/장패드 용량·두께(20oz·4T) 분해도 이 그릇 의존.
- **사다리 후보:** `t_mat_materials`에 clr_cd/ptt_cd/wgt_cd/capacity 분해 컬럼 vs MaterialAxis 코드행. search-before-mint: 기존 mat_typ_cd+usage_cd 조합·`weight` 컬럼(두께 재활용?)으로 무손실 가능한지. ★MAT_TYPE.09/.10이 상품군명 버킷이라 **버킷 재정의**(파우치/악세사리 = 자재유형 아님)도 designer 검토 — 단 이는 행 영향 커 신중.
- **dbmap 라우팅:** `dbmap-material-option-normalization`(5축 흡수·1축 GAP)·round-22 ④자재 B-3·GPM-4(굿즈 본체자재 BOM). **vessel(분해축)=여기 / data(행 재배치·미적재 소재)=dbmap.**

### V-4. 제약 논리유형 확장 (#5 WEAK) — leverage ★★

- **무엇:** RULE_TYPE을 RP 6 논리유형(match·min-max·essential 추가)으로 확장. RP `Constraint` D-3.
- **왜 필요:** 라이브 RULE_TYPE 3종(호환/금지/필수동반)만 — match(사이즈↔부속물 캐스케이드)·min-max(nonspec 범위)·essential(그룹내 필수)을 별 유형으로 거버넌스 못함.
- **unblock:** 부속물 match(거치대↔size)·nonspec 범위 상품·필수 공정 그룹. 제약은 모든 축 잇는 간선 → 횡단 leverage.
- **사다리 후보(designer 판정·경량):** ① `t_cod_base_codes` RULE_TYPE에 코드행 추가(.04 match·.05 범위·.06 필수) — **코드행 사다리 최저단** ② essential은 option_groups `mand_yn`+min/max_sel_cnt로 이미 일부 흡수(search-before-mint 시 PASS 가능). JSONLogic `logic` 컬럼은 이미 표현력 충분 → 유형 코드만 보강.
- **dbmap 라우팅:** `dbmap-cpq-option-mapping`(캐스케이드 6종)·코드행이라 ddl 거의 불요.

---

## P3 — 단일 축 결손 (샘플 확대 필요)

### V-5. 수량 이중슬롯 (#10 WEAK) — leverage ★

- **무엇:** ORD_CNT(디자인 건수)·PRN_CNT(인쇄 수량)를 구별된 슬롯으로(가격기여 곱수 vs 선형). RP `QuantitySlot` D-5.
- **왜 필요:** bundle_qty 슬롯은 있으나 건수×수량 이중축 미분리 → 평면 qty면 세팅곱수 의미 소실.
- **주의:** RP ORD_CNT는 후니 **미관측**(BN 현수막 한계). 후니 굿즈/디지털에 동형 슬롯 있는지 추가 샘플 검증 후 designer 판정(과잉 일반화 경계).
- **dbmap 라우팅:** `dbmap-compute-in-app-db-stores-lookup`·가격 트랙.

### V-6. 사이즈 nonspec 범위 (#13 WEAK) — leverage ★

- **무엇:** 자유입력 size의 min/max 범위 제약(0~5000). RP `NonspecRange`.
- **왜 필요:** 프리셋 enum은 있으나 nonspec 범위 1급 컬럼 미확인. ※ size/plate 마스터 혼재는 별개(data 정합·plate 트랙).
- **주의:** nonspec은 BN 현수막 RP 관측 — 후니 현수막류(`PRD_000138` 등) 보유 여부 확인 후. min-max는 V-4(제약 RULE_TYPE.05 범위)와 겹침 → 통합 가능.
- **dbmap 라우팅:** `dbmap-platesize-is-output-paper`·V-4와 묶어 designer 판정.

### V-7. 가격기여 role 태그 (#11 WEAK) — leverage ★ (대부분 dbmap 가격 트랙)

- **무엇:** 각 선택축 엔티티에 붙는 price_role 태그(자재=면적단가키·size=면적·qty=곱수/선형) + PricingModel 유형(frm_typ_cd).
- **왜 필요:** prc_typ_cd(단가/합가)는 있으나 frm_typ_cd 라이브 부재(round-17)·선택축 행에 price_flag 부착 컬럼 부재.
- **주의:** **대부분 dbmap 가격 트랙 범위**(실제 값/공식·가격사슬 단절). 본 하네스는 *역할 표현력*까지 — vessel로는 frm_typ_cd 그릇·축별 price_role 태그 컬럼 정도. leverage 낮음(가격 사슬이 이미 component_prices로 작동).
- **dbmap 라우팅:** `dbmap-price-formula-audit-round17`(frm_typ_cd)·`dbmap-price-chain-dwire-per-product-formula`. **우선순위 최하 — 가격 트랙으로 위임 권고.**

---

---

## ═══ GS 신축 vessel (v2.0) ═══

### V-8. 본체 형태가공 그릇 (#14 GAP) — leverage ★★★ (굿즈 본체 생성·load-bearing)

- **무엇:** 평면→입체 본체를 *생성*하는 조립/봉제/지퍼/접합 공정 축. RP `FormAssembly`(assembly_type·consumes_material[지퍼=부자재]·direction_variant[세로/가로]).
- **왜 필요:** 라이브 `t_proc_processes` 실측(2026-06-17): 조립/봉제/지퍼/가공 검색 = **`PROC_000080`·`PROC_000088` 봉제 2행만**. 파우치가공(PDT_WRK)·지퍼(FLX_ZIP)·마이크텍 조립 그릇 부재. 형태가공의 *본체 생성성*(없으면 본체 미완)·방향 variant·지퍼 부자재 consumes를 1급 구별 못함.
- **unblock:** 파우치 103상품(레더/캔버스/타이벡/메쉬/린넨 × 플랫·슬림·삼각·볼륨·스트링)·마이크텍·효자손 등 입체 굿즈. **load-bearing**: 형태가공 없으면 굿즈 본체 BOM 불완전(메모리 round-22 "평면→입체 조립 단계").
- **사다리 후보(designer 판정):** ① `t_proc_processes`에 형태가공 공정 행 추가(PDT_WRK/FLX_ZIP 대응) — **코드행/공정행 사다리**가 우선(봉제 선례 있음) ② 형태가공 *축*으로서 본체 생성성·방향 variant·consumes_material 표현이 공정 행만으론 부족하면 슬롯 컬럼/플래그(`form_assembly_yn`·`consumes_mat_cd`). search-before-mint: 봉제(PROC_000080)에 sub_mtrl_yn/seq 플래그로 무손실 가능한지 먼저.
- **dbmap 라우팅:** round-22 굿즈 본체자재 BOM(`dbmap-axis-staged-load-round22`)·`dbm-ddl-proposer`(공정 행/컬럼). 봉제는 일반 후가공(#2)에 섞여 있어 축 구별이 설계 포인트.

### V-9. 생산형태 governing 그릇 (#15 WEAK) — leverage ★★ (본체 모델링 governing)

- **무엇:** prd_typ가 `body_model`(A·B=자재행 / C=완제SKU)·`set_structure`(B=표지/면지 sub_prd)를 *governing*하고 카테고리와 **직교**하는 표현. RP `ProductionType`.
- **왜 필요:** 라이브 `PRD_TYPE` enum 5종(완제품/반제품/기성/디자인/추가) **존재**하나 — 굿즈 전부 `.03(기성)` 실측. prd_typ_cd가 단순 분류 라벨일 뿐 **본체 모델링 분기(자재행 vs 완제SKU)를 안 가름**·카테고리⊥생산형태 직교성 미표현. RP 모델로는 텀블러/코스터=C 완제품·노트=A통합/B셋트로 갈려야 함.
- **unblock:** 전 굿즈(124 PRD_TYPE.03)·책자/노트(A/B). 본체 모델링(#1/#4)·형태가공(#14 활성 여부)을 governing → 횡단.
- **사다리 후보(designer 판정·경량 우선):** enum 그릇은 이미 있음 → ① **search-before-mint 결과 PASS 가능성 높음**: prd_typ_cd 값 *교정*(굿즈 .03→올바른 생산형태)으로 governing 의미 회복 = **data 교정(dbmap)**, vessel 신설 불요 ② governing 분기(body_model)를 별 컬럼/코드로 명시할지는 designer 판정(과잉 모델 경계). **이 항목은 vessel보다 data 교정이 주** — vessel-needs 최하 우선.
- **dbmap 라우팅:** `dbmap-grid-binding-round15`(prd_typ_cd≠생산형태 오모델·치환표). **값 오모델 교정=dbmap / governing 표현 그릇=설계 검토(designer).**

---

## ═══ TP 신축 vessel (v3.0) ═══

### V-11. TemplateAsset 분리 그릇 (#4↔#16 이중의미·T-A WEAK) — leverage ★★ (V-10 종속·오염 방지)

- **무엇:** 에디터가 로드하는 *디자인 시안 카탈로그*(가격0·런타임 SDK)를 완제SKU 템플릿(#4)과 **별 엔티티**로 분리. RP `TemplateAsset`(template_resource_id·asset_options·channel FK).
- **왜 필요:** **라이브 실측(2026-06-17)**: `t_prd_templates`(12행)=완제SKU/OTC = `봉투(700x200) 50`·`카드봉투(블랙) 165x115 50장`·`OPP접착봉투` — 봉투류 완제 주문단위(`base_prd_cd`→products·`dflt_qty`). TP "템플릿"(`koi_template_resource_id`=가격0 디자인 리소스)을 **여기 적재하면 의미 오염** — 가격0 디자인 시안을 주문단위 SKU로 오모델(dictionary #4 [HARD] 금지). **★`dbmap-schema-design-intent-first`(카드봉투 색=siz 오매핑) 동형 위험** — 같은 값을 잘못된 t_*에.
- **unblock:** TP 디자인 시안 보유 상품(디자인명함·캘린더·상장 등)·에디터 채널 운영. `t_prd_templates` 오염 방지(완제SKU 순수성 보존).
- **사다리 후보(designer 판정):** V-10 ③과 동일 — `TemplateAsset` 별 테이블(template_resource_id·asset_options·price=0·design_input_channel_cd FK→V-10). **`t_prd_templates`에 컬럼 추가로 흡수 금지**(완제SKU↔디자인 시안 이중의미 = 별 엔티티 필수). search-before-mint: 없음(완제SKU 그릇과 의미 명확히 다름).
- **dbmap 라우팅:** **dbmap 미터치(신규).** dbmap은 `t_prd_templates`를 완제SKU(봉투 OTC)로만 다룸(`cpq-schema §5`) — 디자인 시안 미개념. V-10과 함께 설계(종속).

## ═══ PR 흡수 매핑 (v4.0 — 신규 vessel 0·기존 V-항목 귀속) ═══

PR facet 6항(입력 directive)이 어느 기존 V-항목/판정에 흡수되는지. **신규 그릇 0건 — 새 V-번호 부여 안 함.**

| PR facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① 표지/내지 usage 슬롯** (P-2) | **PASS** | (없음·그릇 존재) | USAGE.01/.02/.03 enum + product_materials.usage_cd 실재·실적재 → **vessel 조치 불요**. cover/inner 인쇄비 행은 data-gap(dbmap 가격). |
| **② 접지/제본 공정 family** (P-1·P-4) | **PASS** | (없음·그릇 존재) | 접지 19행·제본 9행·오시 2행 공정 행 실재 → **vessel 조치 불요**. 접지↔오시 cascade는 V-4(제약 RULE_TYPE match)와 겹침. |
| **③ page_rule 엔티티** (P-3) | **PASS** | (없음·그릇 존재) | `t_prd_product_page_rules`(page_min/max/incr) = 메타모델 정밀 매핑 확증 → **vessel 조치 불요**(breadth는 data-gap). |
| **④ 인쇄방식 자재풀 게이팅** (P-7) | **GAP** | **V-2 인쇄방식 게이팅** | P-7 = V-2(#12)의 *자재풀 부분집합 게이팅* 면 강화. V-2 설계 시 "PrintMethod gates Material pool" 관계 간선 포함 권고(신규 V 아님). |
| **⑤ digital_price 라우팅** (P-6) | **WEAK** | **V-7 가격 role 태그** | P-6 = V-7(#11)의 pricing_model/frm_typ 라우팅키 부재와 동일. **가격 트랙 위임(V-7 최하)** — frm_typ_cd 그릇이 digital/면적 라우팅 해소. |
| **⑥ 면지 bundle** (P-5) | **PASS** | (없음·그릇 존재) | 면지=USAGE.03 자재행+제본 공정+COMP_BIND 가격 = bundle 무손실 표현 → **vessel 조치 불요**. |
| (부) 평량 제약 (COV_MIN/INN_MAX_WGT) | WEAK 흡수 | **V-4 제약 RULE_TYPE** | 평량 min/max 컬럼 부재 → V-4 RULE_TYPE.05(min-max 범위) 확장 시 같이 해소(코드행 경량). 단일 vessel 불요. |

> **★PR 요지:** PR facet 6건 = PASS 4(그릇 이미 보유·조치 0)·WEAK 1(V-7 가격 위임)·GAP 1(V-2 인쇄방식 게이팅 강화). **신규 V-번호 0** — PR은 새 그릇 수요를 추가하지 않고, 기존 V-2/V-4/V-7에 facet 강화 메모만 더한다. 이것이 16축 포화의 vessel-side 증거: 4번째 카테고리가 새 그릇을 요구하지 않음. designer는 V-2 설계 시 자재풀 게이팅 면, V-4 설계 시 평량 min/max를 *함께* 고려(PR로 인한 별도 설계 항목 없음).

---

## ═══ GS 라이브 실측 정정 노트 (BN vessel-needs 완화) ═══

GS 라이브 실측(2026-06-17)이 BN의 보수적 vessel-gap 일부를 **그릇 발견으로 완화**:

| BN 항목 | BN 가정 | GS 실측 | 정정 |
|---|---|---|---|
| ④템플릿 가격 | templates.price 미구현 = vessel-gap | **`t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price) 존재**(0행) | 완제SKU 개당가(tmpl/vTmpl) 그릇 **있음** → **vessel-gap 아님·data-gap**(적재만). vessel-needs에서 제외 가능. |
| V-6 사이즈 nonspec | min/max 컬럼 미확인 | `t_prd_products.nonspec_width_min/max·nonspec_height_min/max` **존재** | nonspec 범위 그릇 **있음** → **V-6 완화**(혼재만 잔존·V-4 min-max와 별개). |
| V-4 제약 min-max | 별 유형 부재 | nonspec은 상품 컬럼으로 해결됨 | min-max 중 *nonspec*은 상품 컬럼이 흡수 → V-4는 match·essential 위주로 축소. |

> ★요지: GS 실측으로 후니 표현력이 BN 추정보다 **좋음**(가격·nonspec 그릇 발견). 순 vessel-gap = V-3 굿즈 분해축·V-8 형태가공이 **신규 핵심**, ④/V-6는 완화.

---

## 정비 로드맵 (leverage + FK 의존 순서)

1. **V-10 디자인 입력 채널 (★TP directive 1순위)** — TP 본질·editor_yn 불리언만·dbmap 미터치 신규 GAP·editor_yn=Y 107상품·huni-widget 컨버전 경계. V-11(TemplateAsset)·VDP 종속. **directive 최우선.** search-before-mint(editor_yn 환원 한계) 선행.
2. **V-3 자재 분해축 (★GS 최우선)** — 굿즈 본체자재 핵심 결함·B-3 축이동 목적지·오염 광범위(.09 69·.10 43)·텀블러/장패드 용량/두께 분해 의존.
3. **V-8 본체 형태가공 (GS GAP)** — 파우치 103상품 본체 BOM load-bearing·봉제만 존재. 공정 행 선행.
4. **V-2 인쇄방식 게이팅**(최상위 게이트·다른 축 선행) — 단 조건부 1급화 판정 먼저.
5. **V-1 공정 파라미터**(CPQ 옵션 완성 선결·FK load-bearing).
6. **V-11 TemplateAsset 분리**(V-10 종속·`t_prd_templates` 오염 방지·V-10과 함께 설계).
7. **V-4 제약 논리유형**(코드행 경량·횡단 간선·match/essential 위주로 축소 — nonspec은 상품 컬럼 흡수).
8. **V-9 생산형태 governing**(주로 data 교정·governing 그릇은 designer 검토).
9. **V-5 수량**(샘플 확대 후) / **V-6 사이즈 nonspec**(그릇 발견·혼재만 잔존·완화).
10. **V-7 가격 role**(가격 트랙 위임 권고·최하).

> [HARD] FK 위상: **디자인 입력 채널(V-10)이 TemplateAsset(V-11)·VDP의 참조 대상 → 선행**(채널 enum→리소스→VDP). 자재 분해축(V-3)·인쇄방식(V-2)이 옵션/제약 축의 참조 대상 → 선행. 공정 파라미터(V-1)·형태가공(V-8)은 공정 행 선행. designer는 이 순서로 `_vessel-roadmap.md` 확정.
> ★GS 정정으로 ④template_prices·V-6 nonspec은 vessel-gap에서 **하향**(그릇 발견) — designer는 search-before-mint로 PASS 재확인 권장.
> ★TP 핵심: V-10이 신규 P1 최상위(directive 1순위). V-10⊥본체옵션(직교)·가격0 → 본체 축 그릇과 독립 설계. V-11은 V-10 종속·완제SKU 분리 명시.
> ★PR 핵심(v4.0): **로드맵 불변** — PR은 신규 V-항목 0. PR facet은 기존 V-2(인쇄방식 게이팅에 자재풀 면)·V-4(제약에 평량 min/max)·V-7(가격에 digital_price 라우팅)에 흡수되므로, designer가 그 항목들을 설계할 때 PR facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 4건(표지/내지·접지/제본·page_rule·면지)은 그릇 보유로 vessel 조치 0.
