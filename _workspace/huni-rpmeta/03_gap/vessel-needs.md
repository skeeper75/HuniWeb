# 후니 그릇 필요 항목 우선순위 (vessel-needs)

> rpm-gap-analyst. `gap-matrix.md`의 **GAP/WEAK 축**을 leverage(unblock 상품/축 수·FK 의존도·load-bearing)로 우선순위화.
> 각 항목 = **vessel-gap만**(스키마가 축을 표현 못함). 행 오염(data) 교정은 dbmap 트랙(B-3 등) — 여기 아님.
> [HARD] 본 산출은 *어떤 그릇이 왜 필요한가*까지. 정확한 CREATE/ALTER DDL·search-before-mint 증명은 `rpm-vessel-designer`(04_vessel) 영역.
> ※ vessel ≠ 데이터 적재. 적재는 huni-dbmap. ※ search-before-mint 미수행 — designer가 기존 구조 무손실 표현 가능성 먼저 입증할 것.
>
> **── 버전 ──**
> - **v1.0 (BN):** V-1~V-7 (BN 13축 vessel-gap). **보존.**
> - **v2.0 (GS·현재):** + V-3 **굿즈 분해축 확장**(본체색/용량/두께) + **V-8 본체형태가공(#14 GAP)** + **V-9 생산형태 governing(#15 WEAK)**. GS 라이브 실측(2026-06-17)이 V-4 min-max·④template_prices·⑬nonspec을 **완화**(아래 정정 노트).

---

## 우선순위 산정 기준

leverage = (① unblock 상품 수) × (② 횡단성: 몇 축을 푸는가) × (③ FK load-bearing: 다른 축이 의존하나). GAP > WEAK 우선(표현력 0 vs 부분).

---

## P1 — 최우선 (표현력 0 + 횡단 게이팅)

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

1. **V-3 자재 분해축 (★GS 최우선)** — 굿즈 본체자재 핵심 결함·B-3 축이동 목적지·오염 광범위(.09 69·.10 43)·텀블러/장패드 용량/두께 분해 의존. 사용자 directive 최우선.
2. **V-8 본체 형태가공 (GS GAP)** — 파우치 103상품 본체 BOM load-bearing·봉제만 존재. 공정 행 선행.
3. **V-2 인쇄방식 게이팅**(최상위 게이트·다른 축 선행) — 단 조건부 1급화 판정 먼저.
4. **V-1 공정 파라미터**(CPQ 옵션 완성 선결·FK load-bearing).
5. **V-4 제약 논리유형**(코드행 경량·횡단 간선·match/essential 위주로 축소 — nonspec은 상품 컬럼 흡수).
6. **V-9 생산형태 governing**(주로 data 교정·governing 그릇은 designer 검토).
7. **V-5 수량**(샘플 확대 후) / **V-6 사이즈 nonspec**(그릇 발견·혼재만 잔존·완화).
8. **V-7 가격 role**(가격 트랙 위임 권고·최하).

> [HARD] FK 위상: 자재 분해축(V-3)·인쇄방식(V-2)이 옵션/제약 축의 참조 대상 → 선행. 공정 파라미터(V-1)·형태가공(V-8)은 공정 행 선행. designer는 이 순서로 `_vessel-roadmap.md` 확정.
> ★GS 정정으로 ④template_prices·V-6 nonspec은 vessel-gap에서 **하향**(그릇 발견) — designer는 search-before-mint로 PASS 재확인 권장.
