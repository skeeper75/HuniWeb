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
> - **v4.0 (PR):** **신규 vessel-gap = 0건.** PR(인쇄물·책자·리플렛·포스터)이 distinct 신축 0(facet 강화 9건뿐) → 새 그릇 수요 없음. PR facet 6항(표지/내지·접지/제본·page_rule·면지 bundle·digital_price·인쇄방식 게이팅)의 PASS 4·WEAK 1·GAP 1은 **전부 기존 V-항목에 흡수**(가이드 = 아래 ## PR 흡수 매핑). V-1~V-11 항목·우선순위 **불변·보존**.
> - **v5.0 (ST) ★포화 붕괴:** + **V-12 형상 축 그릇(#17 GAP·★P1 신규 최우선·directive 핵심·16축 포화 붕괴)**. ST가 distinct 신축 1건(형상) 도입 → 신규 vessel-gap 1. ST facet 5항(칼선·재단입자·점착·인쇄방식·disable)은 **전부 기존 V-항목 흡수**(재단입자=PASS 그릇존재·점착=V-3·disable=V-4·인쇄방식=V-2·칼선=공정+V-12 게이팅·가격엔진=V-7) — 신규 V-번호 0(흡수 가이드 = 아래 ## ST 흡수 매핑). V-1~V-11 항목·우선순위 **불변·보존.**
> - **v8.0 (PD·현재) ★17축 재포화:** **신규 vessel-gap = 0건.** PD(스툴·슬리퍼·강아지계단=봉제 구조물/3D 조립 완제품)가 distinct 신축 0(완제 구조물 내재BOM #18 부결·facet 강화 5항뿐) → 새 그릇 수요 없음(PR·CL·AC 패턴 반복). PD facet 5항(봉제/제품가공·직물/PU 원단·단수/형상·밑창색 SUB_MTR·★완제 내재BOM)의 PASS 1·WEAK 2·GAP 1·★data-gap 1은 **전부 기존 V-항목에 흡수 또는 data-gap**(가이드 = 아래 ## PD 흡수 매핑). V-1~V-12 항목·우선순위 **불변·보존.** ★라이브 핵심: ① 봉제=`PROC_000080/088` 2행만(=#14 V-8 GAP·GS 동근) ② 직물 린넨/타이벡/메쉬 자재행 실재·물성 차원 부재(=V-3) ③ 단수/형상=`t_siz_sizes` 1:1 프리셋 흡수(ST 형상#17 1:多 미충족·V-12 불요·PASS) ④ 밑창색=★SUB_MTR 부자재 variant(별색 아님·D-PD-1 정정·=V-3) ⑤ **★PD-4 내재BOM=data-gap not vessel-gap**(`t_prd_product_addons` addon→tmpl_cd 그릇·usage_cd .07 공통 639행 슬롯 보유·다리/받침/논슬립=부속물#8·솜/지퍼=자재 usage 적재만 안 됨·축 부재 아님·dbmap 트랙). PD가 더한 것은 새 그릇이 아니라 *기존 그릇이 봉제 구조물 완제품을 견딘다는 검증*.
> - **v7.0 (AC) ★17축 재포화:** **신규 vessel-gap = 0건.** AC(아크릴·키링·코롯토·명찰·등신대)가 distinct 신축 0(가공방식 그룹핑 #18 부결·facet 강화 6항뿐) → 새 그릇 수요 없음(PR·CL 패턴 반복). AC facet 6항(두께·소재 surface-finish·입체/받침 부속물·부자재 횡단공유·acrylic2025 가격엔진·인쇄면/화이트)의 PASS 2·WEAK 4는 **전부 기존 V-항목에 흡수**(가이드 = 아래 ## AC 흡수 매핑). V-1~V-12 항목·우선순위 **불변·보존.** ★라이브+dbmap 31_acrylic 대조 핵심: ① 받침=부속물(`t_prd_product_addons` addon→tmpl_cd 그릇 보유·PASS)·화이트=`PROC_000008` 공정(PASS) ② 두께=자재 mat_cd 차원(dbmap CLEAR3T 통합 확증·`weight`/`depth` 컬럼 NULL·mat_nm 텍스트 융합=V-3) ③ surface-finish 컬럼 전역 0건(ST S-4와 동근·V-3) ④ ★단일 부자재 마스터 부재(고리/받침/자석/와이어링이 MAT_TYPE.04/.07/.10/.02 4버킷 분산·D링 3중복=V-3 버킷 재정의) ⑤ acrylic2025 Q-ACR-7(.02) 미해소=가격 트랙. CL이 더한 것 없듯 AC도 *기존 그릇이 아크릴 두께/입체/가공방식을 견딘다는 검증*.
> - **v12.0 (OT·현재) ★17축 재포화·12번째:** **신규 vessel-gap = 0건.** OT(케이크/납작/반달/봉투/답례품상자·클래퍼·에어홀더=박스/패키징)가 distinct 신축 0(전개도/dieline #18 부결·facet 강화 5항뿐) → 새 그릇 수요 없음(PR·CL·AC·PD 패턴 반복). OT facet 5항(3D 제품치수·전개도/dieline 2치수·도무송칼틀/오시접지·dieline 에디터템플릿·OTPKENV 커스텀)의 PASS 4·data-gap/unobserved 1은 **전부 기존 V-항목에 흡수 또는 data-gap**(가이드 = 아래 ## OT 흡수 매핑). V-1~V-12 항목·우선순위 **불변·보존.** ★라이브 핵심(2026-06-20): ① 전개도 2치수=★`t_siz_sizes` work/cut width·height + margin 4종 단일 행 보유(박스 재단/작업 2치수 무손실 흡수·실데이터 65행 work≠cut 입증·#13 PASS·plate_size 동원 불요) ② 3D 제품치수=작업사이즈[전개도]에서 비선형 파생(미저장 앱계산 정답·별 메타데이터 그릇 부재가 결함 아님·#13 PASS) ③ 도무송칼틀/오시접지=`t_proc_processes` 오시 PROC_000029/090·접지 family PROC_000056~074·형압 050·타공 079/092 실재(ST 칼선 family 동형·#2 PASS·자유칼선 전용 row 부재=V-12 게이팅) ④ dieline 에디터템플릿=#16 TemplateAsset[V-11]로 충분(`t_prd_templates` 그릇 보유·접지선 좌표 unobserved·"구조 dieline" sub-type 불요·data-gap) ⑤ OTPKENV 커스텀=카테고리#7 운영 라벨(별 축 아님). OT가 더한 것은 새 그릇이 아니라 *기존 그릇(사이즈 2치수+공정 칼틀/접지+TemplateAsset)이 입체 박스/전개도를 견딘다는 검증*. **V-11·V-12 신규 mint 불변(누적 신규 테이블 mint 2건 유지).**
> - **v6.0 (CL) ★17축 재포화:** **신규 vessel-gap = 0건.** CL(의류·티셔츠·앞치마·가방류)이 distinct 신축 0(의류 variant #18 부결·facet 강화 5항뿐) → 새 그릇 수요 없음(PR 패턴 반복). CL facet 5항(size×color 2D matrix·인쇄위치 멀티슬롯·인쇄방식·Pantone 별색·item_gbn discriminator)의 PASS 1·WEAK 3·GAP 1은 **전부 기존 V-항목에 흡수**(가이드 = 아래 ## CL 흡수 매핑). V-1~V-12 항목·우선순위 **불변·보존.** ★라이브 핵심: `option_items.ref_key1/ref_key2` 2D 페어링이 활성(255/469)으로 size×color 2D 셀 구조는 그릇 견딤 — CL이 더한 것은 새 그릇이 아니라 *기존 그릇이 의류 2D variant를 견딘다는 검증*.

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

### V-12. ★형상 축 그릇 (#17 GAP) — leverage ★★★ (directive 1순위·ST 본질·16축 포화 붕괴·dbmap G-SK-2 위 정밀화)

- **무엇:** 인쇄물 *외곽 형상*(사각 SQ/원형 CL/타원 EL/사각라운드 RC/자유형 FR)을 사이즈와 *분리된 전용 enum 슬롯*으로 담는 축. RP `Shape`(shape_info enum) — 형상이 ① 칼틀 enum 부분집합 게이팅(CL→CL001~100) ② 자유형(FR)→자유칼선(완칼+모양 파라미터) 강제 ③ 사이즈 입력모드(자유형=자유사이즈/정형=프리셋 enum) 게이팅.
- **왜 필요:** **라이브 information_schema 3-레벨 실측(2026-06-17)**: 형상 전용 **컬럼 0건**(t_* 전 테이블·`shape`/`shape_cd`/`outline`/`die`/`form_typ` 매치 전부 false positive)·형상 전용 **테이블 0건**·base_code 16그룹에 **SHAPE/형상 enum 부재**(코드값 도메인조차 없음). `t_siz_sizes`(497행)는 "재단치수"(width×height)이지 형상(원/사각) 분류 슬롯 아님. KB G-SK-2 "도형/치수 enum(원형 25~90mm)이 어느 축에도 없음"을 라이브가 3-레벨 확증. 그릇 없으면: ① 형상이 상품명/note에만(원형 스티커·사각라운드) ② 형상↔사이즈 1:多(CL→CL001~100 칼틀 11종)인데 사이즈 흡수 강제 시 "원형이라는 사실"을 매 칼틀 프리셋에 중복 인코딩(정규화 붕괴) ③ 5형상 superset(STDCFBR) 한 상품 표현 불가.
- **★형상↔칼선/사이즈 게이팅(설계 포인트):** 형상은 단독 enum이 아니라 **관계 그릇** — 형상→칼틀 프리셋 부분집합(#13 사이즈) + 형상=FR→완칼(PROC_053) 모양 파라미터(#9 공정파라미터 ref_param_json) 활성. 라이브 칼선 공정은 완칼(053)/반칼(054)/스티커완칼(055)만 존재하고 *자유칼선(도무송) 전용 row가 없어* 자유형은 완칼+모양 파라미터로 환원 → V-12는 #13·#2·#9를 잇는 분류자.
- **unblock:** ST 36상품(자유형·사각반칼·원형·타원·라운드·5형상 데코·점착특화) + 도무송/모양재단 보유 상품(굿즈 칼틀·실사 족자 PROC_082 `모양enum`). 형상은 BN 어깨띠·GS 하트·TP 티켓·PR 카드형에도 *값으로* 존재하나 1:1이라 사이즈 흡수가 정당 — **ST만 1:多 분리가 명시 슬롯으로 드러나 전용 그릇 필요.**
- **사다리 후보(designer 판정):**
  - ① **base_code enum 신설** — `SHAPE`(또는 `FORM_TYPE`) 그룹(SQ/CL/EL/RC/FR) = 코드행 사다리 최저단(형상 코드값 도메인). search-before-mint: 현재 형상 분류 코드 도메인 자체가 부재(16그룹에 없음) → enum 신설은 명백.
  - ② **사이즈/상품에 `shape_cd` 컬럼 vs 형상→칼틀 게이팅 테이블** — 형상↔칼틀 1:多 게이팅을 `t_siz_sizes`나 `t_prd_product_sizes`에 `shape_cd`(→①enum)로 둘지, 형상→칼틀 부분집합 매핑 테이블로 둘지. **★[HARD] 1:1 흡수 카테고리는 size 프리셋 유지**(형상축 전면 강제 금지·오모델 회피) → shape_cd는 ST류 1:多 상품에만 의미(nullable).
  - ③ **형상=FR→완칼 모양 파라미터 게이팅** — #9 공정파라미터(V-1 ref_param_json)와 연동(완칼의 `모양` 인자). V-1·V-12 함께 설계.
- **dbmap 라우팅:** **dbmap이 G-SK-2로 결함 명시·그릇 미신설.** `entity-semantic-model.md:39`(형상 어느 축에도 없음)·round-3 "도무송 형상=siz_cd 신설 컨펌"(`dbmap-round3-mapping-audit`) — **단 dbmap은 형상을 siz_cd 흡수로 닫으려 함**. ST 1:多 증거(CL→CL001~100·5형상 superset)는 siz 흡수가 정규화 붕괴임을 보임 → **형상 전용 그릇이 정답(dbmap siz 흡수 권고 정정).** 신규 vessel-gap(dbmap G-SK-2 위 정밀화·중복 아님)·`dbm-ddl-proposer`(enum+컬럼/게이팅).
- **[HARD] directive 1순위:** 본 하네스(RP-Meta)의 ST directive 핵심 = "형상축 #17 vessel-gap 판정·신규 그릇 필요 여부". GAP 확정 → V-12가 ST vessel 설계 **최우선**(V-10 디자인입력채널·V-3 자재분해축과 나란한 P1). 단 designer는 ① 1:1 흡수 카테고리 size 유지 ② 형상↔칼틀/모양파라미터 게이팅 간선을 함께 설계.

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

- **무엇:** 합성 자재의 분해축 — 본체색(CLR)·소재(PTT)·무게/두께(WGT)·인쇄방식을 *분리된* 표현으로. RP `MaterialAxis`. **★GS 확장: 완제 본체의 `{body_color, capacity, thickness, brand}` 분해축**(RP `PCS_DTL_NME` "화이트 20oz" 융합 해소). **★ST 확장: 점착강도(adhesion_grade)·내후등급(weather_grade) 합성 차원. ★AC 확장 3차원: ① 두께 measure_type(평량 g vs 두께 mm vs 용량 — WGT 슬롯 다의·아크릴 `weight`/`depth` NULL·mat_nm 텍스트 융합) ② surface_finish(글리터/거울/자개/홀로그램·ST adhesion/weather와 통합) ③ 단일 부자재 마스터(고리/받침/자석/와이어링이 MAT_TYPE.04/.07/.10/.02 4버킷 분산·D링 3중복 → 횡단 단일 카탈로그·RP KR/CN/CR 동형).**
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

## ═══ ST 흡수 매핑 (v5.0 — 신규 vessel 1[V-12 형상]·facet 5항 기존 V-항목 귀속) ═══

ST가 추가한 신규 vessel-gap = **V-12 형상 축 1건**(위 P1). ST facet 5항(directive ②)이 어느 기존 V-항목/판정에 흡수되는지. **facet 신규 그릇 0건 — 새 V-번호는 V-12 형상뿐.**

| ST facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **★형상**(S-1·#17) | **GAP** | **V-12(신규)** | 형상 전용 enum+게이팅 그릇 신설 — **신규 vessel(P1·directive 1순위).** dbmap G-SK-2 위 정밀화·siz 흡수 정정. |
| **재단입자**(S-3 반칼/완칼) | **PASS** | (없음·그릇 존재) | PROC_000053 완칼·054 반칼·055 스티커완칼 **라이브 실재**(메타모델 주장 전건 확인) → **vessel 조치 불요**(공정#2 멤버 무손실). |
| **칼선 2메커니즘**(S-2) | **PASS(부분)** | (없음/V-12·V-1 게이팅) | 프리셋칼틀=완칼/반칼 공정+사이즈 cascade(PASS). 자유칼선(도무송)=완칼+모양 파라미터(#9 V-1 의존)·형상=FR→자유칼선 강제는 V-12 게이팅 → **별 vessel 불요**(V-12·V-1에 게이팅 면 흡수). |
| **점착/내후 소재**(S-4) | **WEAK** | **V-3 자재 분해축** | 점착강도/내후등급 = V-3(#1) 합성 분해축의 추가 차원(adhesion_grade/weather_grade·색상/두께 동형). **신규 V 아님** — V-3 설계 시 점착/내후 차원 함께 고려. ※ ST 자재는 `.11 스티커용지` 클린 버킷(파우치 .09 오염 아님). |
| **인쇄방식**(S-5 UV/DTF/후지) | **GAP** | **V-2 인쇄방식 게이팅** | PR P-4/P-7과 동일 #12 GAP — V-2(#12)의 자재/도수/화이트강제/가격엔진 게이팅 면. ST UV/DTF/후지가 횡단 합류(신규 V 아님). V-2 설계 시 ST 인쇄방식 enum(UV/DTF/후지) 포함 권고. |
| **disable 227건 룰엔진**(S-8) | **WEAK** | **V-4 제약 논리유형** | logic jsonb 스케일은 견딤(227건 OK)·**RULE_TYPE disable 전용 유형 부재** = V-4(#5)의 유형 확장(코드행 .04 disable 등 경량). ST가 disable 정점 케이스로 룰엔진 스케일 검증 — V-4 설계 시 disable 유형 명시 권고. |
| (부) 가격엔진 3종(S-6 판/die-cut/정가) | WEAK 흡수 | **V-7 가격 role 태그** | pricing_model 6종이 ST 3엔진(digital/vTmpl/tmpl) 흡수 — V-7(#11) frm_typ_cd 라우팅과 동일. **가격 트랙 위임(V-7 최하).** |

> **★ST 요지:** ST facet 5항 = PASS 1(S-3 재단입자·그릇존재·조치 0)·WEAK 2(S-4→V-3·S-8→V-4)·GAP 1(S-5→V-2)·부분PASS 1(S-2→V-12/V-1 게이팅). **신규 V-번호 = V-12 형상 1건뿐** — facet은 새 그릇 수요 0(전부 V-2/V-3/V-4/V-7에 흡수·V-12 게이팅). 이것이 포화 붕괴의 vessel-side 정직성: ST는 새 *축* 1건(형상)만 그릇을 요구하고, 칼선/재단/점착/인쇄방식/disable은 기존 그릇이 견딤. designer는 V-12 설계 시 형상↔칼틀(#13)·형상↔모양파라미터(#9 V-1)·형상=FR→자유칼선 게이팅 간선을 함께, V-3 설계 시 점착/내후 차원, V-2 설계 시 ST 인쇄방식 enum, V-4 설계 시 disable 유형을 *함께* 반영(별 순서 추가는 V-12뿐).

## ═══ CL 흡수 매핑 (v6.0 — 신규 vessel 0·facet 5항 기존 V-항목 귀속) ═══

CL이 추가한 신규 vessel-gap = **0건**(의류 variant #18 부결). CL facet 5항(directive 1~5)이 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.**

| CL facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① size×color 2D matrix**(C-2/C-3) | **WEAK** | **V-3 자재 분해축**(+그릇존재 부분) | ★2D 셀 *구조*는 그릇 견딤(`option_items.ref_key1/ref_key2` 페어링 활성 255/469·`use_yn`=셀가용성·GS SKU·ST disable 정점 동형) → **2D vessel 조치 불요**. 단 ① 색상이 OPT_REF_DIM에 별 ref 타입 없음→자재 CLR 라우팅·자재 CLR 분해축 = **V-3**(#1 합성 분해축) ② 의류 원단 MAT_TYPE 버킷 부재(.09/.10는 상품군명)→V-3 버킷 재정의 검토. **신규 V 아님 — V-3 설계 시 의류 본체(원단×색×사이즈) 분해/버킷 함께 고려.** |
| **② 인쇄위치 멀티슬롯**(C-4) | **WEAK** | **공정#2(옵션 경유 PASS측면)·V-1 공정파라미터·V-10 에디터매핑** | 본체 멀티슬롯 선택=option_groups(SEL_TYPE.02 다중)→option_items(공정.04 156행)로 표현 가능(그릇 보유) → **별 vessel 불요**. 위치별 공정 파라미터(앞면 size·소매 좌표)=**V-1**(#9 ref_param_json)·KOI_NME 에디터 캔버스 매핑=**V-10**(#16 디자인입력 채널). **신규 V 아님 — V-1·V-10에 흡수.** |
| **③ 인쇄방식 실크/전사/DTF**(C-6) | **GAP** | **V-2 인쇄방식 게이팅** | PR P-4/P-7·ST S-5와 동일 #12 GAP — V-2(#12)의 자재(DTF필름)/도수노출/화이트강제/Pantone활성/가격엔진 게이팅 면. CL 의류 인쇄방식(실크/전사/DTF)이 *상품내 옵션 인코딩*으로 횡단 합류(신규 V 아님). V-2 설계 시 CL 인쇄방식 enum(DTF/전사/실크)·삼면 표현(자재facet/상품분기/상품내옵션) 포함 권고. |
| **④ Pantone 별색**(C-7) | **PASS** | (없음·그릇 존재) | `PROC_000007 별색인쇄`+화이트008/클리어009/금색011/은색012 **라이브 실재**·별색=공정 경계 준수 → **vessel 조치 불요**(별색 *공정* 그릇 보유). ※ 1124 PANTONE C *색값 도메인*(어떤 팬톤색)을 담을 별색 enum은 #6 기초코드 미비 — **경량 enum 후보**(V-13 검토급·코드행 사다리·실크인쇄 상품 한정·우선순위 낮음·designer가 별색 지정값 관리 필요성 판정). |
| **⑤ item_gbn discriminator**(C-5) | **WEAK** | **V-9 생산형태 governing** | item_gbn(clothes2025/tmpl)=§V-15 생산형태#15 WEAK과 동일·구현 discriminator라 vessel-gap 아님 → 주로 data(prd_typ_cd 교정)·governing 표현은 **V-9**(designer 검토). 의류는 PRD_TYPE 분류 또는 discriminator 컬럼 검토 — **신규 V 아님·V-9에 흡수.** |

> **★CL 요지:** CL facet 5항 = PASS 1(C-7 Pantone 별색·그릇존재·조치 0)·WEAK 3(C-2/C-3→V-3·C-4→V-1/V-10·C-5→V-9)·GAP 1(C-6→V-2). **신규 V-번호 0** — CL은 새 그릇 수요를 추가하지 않고, 기존 V-1/V-2/V-3/V-9/V-10에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR 패턴 반복): 6번째 카테고리가 새 그릇을 요구하지 않음. ★특기: `option_items.ref_key1/ref_key2` 2D 페어링이 라이브 활성(255/469)으로 의류 size×color 2D 매트릭스·셀가용성을 *구조적으로 견딤* — 후니 옵션 그릇이 GS 1D variant→CL 2D variant 일반화를 무손실 수용(검증 신호). designer는 V-3 설계 시 의류 본체(원단×색×사이즈) 분해/버킷, V-2 설계 시 CL 인쇄방식 enum, V-1 설계 시 위치별 공정 파라미터, V-10 설계 시 KOI_NME 위치-에디터 매핑을 *함께* 반영(별 순서/V-번호 추가 0). 별색 지정값(1124 Pantone) enum은 #6 경량 후보(우선순위 낮음·실크인쇄 한정).

## ═══ AC 흡수 매핑 (v7.0 — 신규 vessel 0·facet 6항 기존 V-항목 귀속) ═══

AC가 추가한 신규 vessel-gap = **0건**(가공방식 그룹핑 #18 부결). AC facet 6항(directive 1~6)이 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.**

| AC facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① 두께(3T/5T·자재 WGT)** | **WEAK** | **V-3 자재 분해축** | 두께=자재 mat_cd 차원으로 담되(dbmap CLEAR3T 통합 확증) `weight`/`depth` 컬럼 아크릴 NULL·`mat_nm` 텍스트 융합("아크릴 투명 3mm")·★**WGT measure_type 구분 부재**(평량 g vs 두께 mm vs 용량 다의) → V-3(#1) 분해축에 두께 측정유형 차원 함께 고려. **신규 V 아님.** |
| **② 소재 surface-finish(글리터/거울/자개/홀로그램)** | **WEAK** | **V-3 자재 분해축** | surface/finish/glitter/mirror/holo 컬럼 **전역 0건**·`mat_nm` 텍스트 융합 → V-3(#1)에 `surface_finish` 분해축 추가(★ST S-4 점착/내후[adhesion_grade/weather_grade]와 **동근**·자재 합성 차원). 거울 별 가격공식(PRF_MIRROR_ACRYL)은 #11/V-7 라우팅. **신규 V 아님 — V-3 설계 시 surface-finish 차원 함께(ST S-4와 통합).** |
| **③ 입체/받침 부속물(#8)** | **PASS** | (없음·그릇 존재) | `t_prd_product_addons`(addon→tmpl_cd) = 받침/스탠드를 **부속물로 표현**(BN 거치대 D-1 동형) → **vessel 조치 불요**. 입체성 분산(받침=#8·코롯토 두께=자재·양면=옵션·조형=공정) 전부 기존 축 보유. ※ 받침 12 SKU breadth(형상×크기)는 template/자재 SKU data. |
| **④ 부자재 횡단 공유(고리 KR/CN/CR·받침 AB)** | **WEAK** | **V-3 자재 분해축(버킷 재정의)** | ★**단일 부자재 마스터 부재** — 고리/받침/자석/와이어링이 MAT_TYPE.04(링)/.07(핀·자석·고리)/.10(와이어링)/.02(D링) **4버킷 분산**·**D링 .02/.04/.07 3중복**. RP는 KR/CN/CR 코드를 ST/GS/AC 횡단 단일 카탈로그로 공유 → 후니 단일화 미달. **★vessel-gap이 아니라 버킷 정합(주로 data·일부 vessel)** = V-3(#1) MAT_TYPE 버킷 재정의(상품군명 버킷 .09/.10 오라벨과 동근·§IV). designer가 V-3 설계 시 **"부자재 횡단 카탈로그 단일화"** 검토(우선순위 중·행 영향 큼·신중). **신규 V 아님.** |
| **⑤ acrylic2025 가격엔진(prc_typ .02)** | **WEAK** | **V-7 가격 role 태그** | `PRF_CLR_ACRYL` 1행·frm_typ_cd 부재·★**Q-ACR-7(.02 엔진계산 미확정) 라이브 확증**(CLEAR3T prc_typ .02·84행) = V-7(#11) frm_typ_cd 라우팅 부재와 동일·acrylic2025가 ST 3엔진·GS tmpl·PR digital과 횡단 합류. **가격 트랙 위임(V-7 최하)** — .02 정합·미러/코롯토/카라비너 공식 신설은 **dbmap 31_acrylic Q-ACR/GAP-CHAIN**(범위 외). **신규 V 아님.** |
| **⑥ 인쇄면+화이트(투명소재 종속)** | **PASS** | (없음·그릇 존재) | `PROC_000008 화이트` 별색 family **라이브 실재**·인쇄면=옵션#3·투명소재→가용=제약#5(JSONLogic) → **vessel 조치 불요**(ST S-7·TP T-E 동형). ※ 인쇄면(앞뒤다름)이 2면 디자인 데이터 요구하는 점은 #16/V-10(디자인입력 채널·VDP) 경계. |
| (부) ACTPKEY 키링 템플릿 | GAP 흡수 | **V-10/V-11 TemplateAsset** | "아크릴 키링 템플릿"(ACTPKEY)=에디터 디자인 자산(#16 TemplateAsset·T-A 동형)·`t_prd_templates` 완제SKU 적재 금지 → V-10(#16)·V-11(TemplateAsset 분리)에 흡수. **신규 V 아님.** |

> **★AC 요지:** AC facet 6항 = PASS 2(#3 받침 부속물·#6 인쇄면/화이트·그릇존재·조치 0)·WEAK 4(#1 두께→V-3·#2 surface-finish→V-3·#4 부자재 횡단공유→V-3 버킷·#5 acrylic2025→V-7). **신규 V-번호 0** — AC는 새 그릇 수요를 추가하지 않고, 기존 V-3(자재 분해축에 두께 measure_type·surface_finish·부자재 단일 마스터 3차원 합류)·V-7(가격 acrylic2025 frm_typ)·V-10/V-11(ACTPKEY TemplateAsset)에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR·CL 패턴 반복): 7번째 카테고리(가장 강한 새 후보 A-8 가공방식 그룹핑 포함)가 새 그릇을 요구하지 않음. ★특기: **V-3가 AC로 3차원 확장** — ① 두께 measure_type(평량/두께/용량 다의 WGT 슬롯) ② surface_finish(글리터/거울/자개·ST adhesion/weather와 통합) ③ 단일 부자재 마스터(고리/받침/자석 MAT_TYPE 4버킷 분산·D링 3중복 통합). designer는 V-3 설계 시 이 3차원을 *함께* 반영(별 순서/V-번호 추가 0). ★dbmap 31_acrylic 라이브 산출과 구조 동형 확증(CLEAR3T mat_cd 통합·MIRROR3T 별 comp·화이트=공정)·Q-ACR-7(.02)/미러 GAP은 가격 트랙 범위 외.

---

## ═══ PD 흡수 매핑 (v8.0 — 신규 vessel 0·facet 5항 기존 V-항목 귀속·★PD-4 내재BOM=data-gap) ═══

PD가 추가한 신규 vessel-gap = **0건**(완제 구조물 내재BOM #18 부결). PD facet 5항(directive 1~5)이 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.** ★PD-4 내재BOM은 vessel 아님(data-gap·dbmap).

| PD facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① 봉제/제품가공(형태가공#14 봉제 family)** | **GAP** | **V-8 본체 형태가공** | PD-1 = V-8(#14)의 봉제(SEW_LTR)/제품가공(PDT_WRK) family 멤버 — GS PDT_WRK/FLX_ZIP과 동일 #14 GAP(`PROC_000080/088 봉제` 2행만·제품가공/조립/솜충전 공정 행 부재). PD가 봉제 구조물 완제품으로 횡단 합류(신규 V 아님). V-8 설계 시 봉제(sewing)/제품가공(assembly-finish) family 멤버 포함 권고. |
| **② 직물/PU 원단(자재#1 PTT)** | **WEAK** | **V-3 자재 분해축** | 린넨(.05)/타이벡(.05)/메쉬(.08) 자재행 실재로 *링크* PASS·★직물 *물성 차원*(면10수=번수·신축성·원단 종류) 분해 컬럼 부재 = V-3(#1) 합성 분해축에 직물 물성 차원 함께 고려(AC 두께 measure_type·ST 점착/내후와 동근). 미적재 본체소재 행(면10수/슬리퍼/PU)=data-gap. **신규 V 아님.** |
| **③ 단수(2/3단)·스툴 형상** | **PASS** | (없음·그릇 존재) | `t_siz_sizes`(work/cut width·height)로 단수(2단=495×320)·형상(원형=305×305) **1:1 프리셋 흡수** → **vessel 조치 불요**. ★ST 형상#17의 1:多 미충족(원형↔305×305 1개)이라 형상축 V-12 강제 *불요*(BN/GS/TP/PR 1:1 흡수 카테고리 동형·size 유지). 단수→생산BOM 게이팅은 data/가격. |
| **④ ★완제 구조물 내재BOM(다리/받침/솜/지퍼/논슬립)** | **★data-gap (not vessel-gap)** | (vessel 아님·dbmap) | ★**그릇 보유 확정·축 부재 아님** — 다리/받침/논슬립=`t_prd_product_addons`(addon→tmpl_cd·#8 부속물 그릇·BN 거치대 D-1·AC 받침 동형)·솜/지퍼=`t_prd_product_materials.usage_cd .07 공통`(639행 슬롯). RP 마케팅 카피([live:SSR-marketing])로만 두는 것은 *그릇에 적재해야 할 데이터 미적재*=data-gap·후니 KB가 addl_product/usage/생산방식 이미 1급 모델링(ST 형상 G-SK-2와 정반대). **vessel-needs 산출 아님 → `_data-gaps-noted.md §9`(dbmap 적재 트랙).** ★directive metamodel 예측(data-gap) 라이브 실측 확정(그릇 실재). |
| **⑤ 밑창색×사이즈 SUB_MTR variant**(PD-6·★별색 아님 정정) | **WEAK** | **V-3 자재 분해축** | ★D-PD-1 정정: 밑창색(검정/흰색)은 `six_clr`(별색·공정#2) 아니라 SUB_MTR 부자재 variant(SLB*/SLW* 밑창색×사이즈 12-variant). 밑창=완제 부자재(addon→tmpl_cd·#8) *또는* 본체 결합 부품(자재 sub_mtrl·usage .07) **둘 다 그릇 보유**·색×사이즈 12-variant=`option_items.ref_key1/ref_key2` 2D 페어링(CL §XV-1 동형·라이브 255/469). ★밑창 sole 자재코드(SLB*/SLW*) 미적재=data-gap·부속물#8 vs 자재 sub_mtrl 최종 귀속은 reverse 정정본 검증 후. 별색≠부자재 variant 경계. **신규 V 아님 — V-3 자재 분해축에 흡수.** |

> **★PD 요지:** PD facet 5항 = PASS 1(#3 단수/형상·#13 흡수·조치 0)·WEAK 2(#2 직물/PU→V-3·#5 밑창 SUB_MTR→V-3)·GAP 1(#1 봉제/제품가공→V-8)·★data-gap 1(#4 내재BOM=vessel 아님·dbmap). **신규 V-번호 0** — PD는 새 그릇 수요를 추가하지 않고, 기존 V-3(직물 물성 차원·밑창 sub_mtrl)·V-8(봉제/제품가공 family)에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR·CL·AC 패턴 반복): 8번째 카테고리(가장 이질적 봉제 구조물 완제품·directive 최대 관전 조립/구조/3D폼/완제 내재BOM 포함)가 새 그릇을 요구하지 않음. ★특기: **PD-4 완제 구조물 내재BOM = data-gap not vessel-gap 라이브 확정** — `t_prd_product_addons`(addon→tmpl_cd) 그릇·usage_cd .07 공통 639행 슬롯 실재·후니 KB가 addl_product/usage/생산방식 이미 1급 모델링 → 다리/받침/논슬립=부속물#8·솜/지퍼=자재 usage 적재만 안 됨(축 부재 아님). designer는 V-8 설계 시 봉제/제품가공 family, V-3 설계 시 직물 물성 차원·밑창 sub_mtrl을 *함께* 반영(별 순서/V-번호 추가 0). ★PD-4는 dbmap 라우팅(vessel 아님).

---

## ═══ PH 흡수 매핑 (v9.0 — 신규 vessel 0·facet 6항 기존 V-항목 귀속·★PH-1/PH-2 거치/완제 액자=facet/data-gap) ═══

PH가 추가한 신규 vessel-gap = **0건**(완제 액자 그릇/마운팅 #18 부결). PH facet 6항(directive)이 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.** ★PH-1/PH-2 거치/완제 액자(directive 최대 관전)는 vessel 아님(facet/data-gap·dbmap).

| PH facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① ★거치방식(탁상용/벽걸이) 캐스케이드**(PH-2·directive 최대 관전) | **PASS** | (없음·그릇 존재) | ★거치=택1 `option_groups`(SEL_TYPE.01·134행)→`option_items`(469행·polymorphic)→cascade `constraints.logic` jsonb(10행·JSONLogic) **그릇 보유** → **vessel 조치 불요**. §0.5 거치 OBSERVED했으나 옵션#3 캐스케이드 상위 차원으로 무왜곡 구현·후니 KB 결함 없음(AC 명찰 cascade·ST disable·BN 어깨띠 동형) → distinct #18 부결. ★ST 형상#17 승격 기준(전용 슬롯+KB 결함 둘 다)과 분기: 거치=전용 슬롯 OBSERVED(✅)·KB 결함 없음(❌)=②불충족. 거치 cascade 적재=data(dbmap). |
| **② 완제 액자 SKU(거치+마감+사이즈 인코딩)**(PH-1) | **WEAK** | **V-11 TemplateAsset / 기존 #4 템플릿** | `t_prd_templates`(12행)+`template_selections`(14행)로 거치+마감+사이즈 combobox 완제 SKU 표현 그릇 보유(AC 두께/소재 variant·GS 완제SKU 동형)·★템플릿이 디자인시안↔완제SKU 이중의미(TP T-A·V-11 분리 결함과 동근) → V-11 설계 시 완제 액자 SKU(주문 단위)↔에디터 자산 분리 함께 반영. "인쇄물+별도 프레임 조립" 2-파트 완제도 template으로 담음. SKU breadth 적재=data. **신규 V 아님.** |
| **③ 인화지×마감 surface-finish**(PH-3) | **WEAK** | **V-3 자재 분해축** | surface/finish/glitter 컬럼 전역 0건·마감(유광/반광/스노우)이 `mat_nm` 텍스트 융합("유광(Glossy)_캐논전용지") = V-3(#1) surface_finish 합성 차원에 흡수(AC A-2·ST S-4 점착/내후와 동근). 인화지 매체행 적재=data. **신규 V 아님.** |
| **④ 형태(일반/정사각/파노라마) 비율 프리셋**(형태축) | **PASS** | (없음·그릇 존재) | `t_siz_sizes`(work/cut width·height)로 형태=비율(정사각=W:H 동일·파노라마=W≫H)을 **1:1 프리셋 흡수** → **vessel 조치 불요**. ★ST 형상#17의 1:多 미충족(형태 1개↔width·height 1:1·PD-3 단수/형상 동형)이라 형상축 V-12 강제 *금지*(size#13 유지·BN/GS/TP/PR/PD 1:1 흡수 동형). |
| **⑤ PHMG/PHPO 다중분류**(출력매체 PH ⊥ 컵&홀더·PH-5) | **PASS** | (없음·그릇 존재·정책) | `t_prd_product_categories`(PK=(prd_cd,cat_cd)·`main_cat_yn`)·2카테고리 8상품 **라이브 실재** = N:M 다중분류 그릇 보유·작동(GS 코스터 동형) → **vessel 조치 불요**. "PH로 묶을지 컵&홀더로 묶을지"는 **정책 결정**(GS G-2 동형·메타모델/vessel 판정 아님). |
| **⑥ set/sheets 고정 단위**(600매·4/5sheets·PH-4) | **WEAK** | **기존 #10 수량모델** | `t_prd_product_bundle_qtys`(28행)+`qty_unit_typ_cd` 고정 set 단위 그릇 보유(GS 텀블러 base_quant 동형)·★set-as-base-unit vs 자유 수량 구분 약함=기존 #10 수량모델 WEAK. set 단위 적재=data. **신규 V 아님.** |

> **★PH 요지:** PH facet 6항 = PASS 3(#1 거치 캐스케이드·#4 형태 비율·#5 다중분류·그릇존재·조치 0)·WEAK 3(#2 완제 액자 SKU→V-11·#3 인화지×마감→V-3·#6 set 단위→#10). **신규 V-번호 0** — PH는 새 그릇 수요를 추가하지 않고, 기존 V-3(인화지×마감 surface_finish)·V-11(완제 액자 SKU↔디자인시안 이중의미 분리)에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR·CL·AC·PD 패턴 반복): 9번째 카테고리(directive 최대 관전 완제 액자 프레임[인쇄물 사후 끼우는 2-파트 빈 그릇]·마운팅/거치[탁상용/벽걸이]·전면 보호재 포함)가 새 그릇을 요구하지 않음. ★특기: **PH-1/PH-2 거치/완제 액자 = data-gap/facet not vessel-gap 라이브 확정** — 거치=옵션#3 `option_groups`(134)/`option_items`(469)/`constraints.logic`(10행) 그릇·완제 액자=완제SKU#4 `templates`(12)/`selections`(14) 그릇·프레임재질=자재#1 variant 실재·§0.5 거치 OBSERVED했으나 옵션 일반 cascade로 무왜곡 표현·후니 KB 옵션/완제SKU/자재 이미 1급 모델링(ST 형상 G-SK-2 "어느 축에도 없음" vessel-gap과 정반대). designer는 V-11 설계 시 완제 액자 SKU↔에디터 자산 분리, V-3 설계 시 인화지×마감 surface_finish를 *함께* 반영(별 순서/V-번호 추가 0). ★PH-1/PH-2·거치 cascade·완제 액자 SKU breadth·다중분류·set은 dbmap 라우팅(vessel 아님).

---

## ═══ FS 흡수 매핑 (v10.0 — 신규 vessel 0·facet 8항 기존 V-항목 귀속·★FS-1 타일링=data-gap) ═══

FS가 추가한 신규 vessel-gap = **0건**(타일링 TILL_WH_GBN #18 부결). FS facet 8항(directive)이 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.** ★FS-1 타일링(directive 1순위)·FS-6 완제 부자재는 vessel 아님(data-gap·dbmap).

| FS facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① ★타일링(TILL_WH_GBN 없음/세로/가로)**(FS-1·directive 1순위) | **GAP** | **V-1 공정 파라미터(#9)** | ★타일링=공정#2 인쇄 배치 파라미터#9 — `t_proc_processes.prcs_dtl_opt` jsonb **라이브 활성**(오시/미싱 줄수·코팅 면 enum·제본 방향) → 타일링(없음/세로/가로) enum 무손실 적재 가능 그릇 보유 → **별 vessel 불요**(V-1 공정 파라미터 GAP·#9에 흡수). 전 9 카테고리 미관측 전용 라디오 슬롯(승격 ① 충족)이나 후니 KB plate_size/prcs_dtl_opt가 인쇄 배치 1급·"패턴 반복 어느 축에도 없음" 결함 부재(승격 ② **불충족**) → distinct #18 부결. ★ST 형상#17 승격(전용 슬롯+KB 결함 둘 다)과 분기: 타일링=전용 슬롯 OBSERVED(✅)·KB 결함 없음(❌)=②불충족. ★**타일링≠판걸이수(HARD)**: 타일링=고객 입력(공정#9 등재)·판걸이수=앱계산 파생(등재 금지). 타일링 enum 적재=data(dbmap). |
| **② 방향(PAPER_WH W/H)**(FS-2) | **PASS** | (없음·그릇 존재) | `t_siz_sizes`(work/cut width·height)로 방향(가로 W/세로 H)=가로/세로 치수 매핑 **흡수** → **vessel 조치 불요**. ★타일방향(TILL_WH_GBN 공정#9)과 분리 슬롯=본체 방향(사이즈#13)≠패턴 반복 방향·다른 의미축 정당. |
| **③ 면직물 자재(면사 수 PXFBW0NN)**(FS-3) | **WEAK** | **V-3 자재 분해축** | `weight`/`depth` numeric 컬럼 실재하나 **measure_type 판별자 0건**(한 weight 컬럼이 평량 g·두께 mm·면사 수·용량 다의)·면사 수 `mat_nm` 텍스트("면10수화이트") 융합 = V-3(#1) measure_type 차원(평량/두께/oz/번수 구분)에 흡수(AC 두께 §0.1·PD 번수·CL oz와 동근). 면직물 본체 행 적재=data(round-22 굿즈 본체소재 부재 결함 동근). **신규 V 아님.** |
| **④ 별색(SID_FBR 6색×3농도)**(FS-4) | **PASS** | (없음·그릇 존재) | `PROC_000007 별색인쇄` 공정 행 **라이브 실재**·round-22 별색=공정 경계 준수 → **vessel 조치 불요**(별색 *공정* 그릇 보유·CL C-7 동형). ※ 6색×3농도 *색값 도메인*을 담을 별색 지정 enum은 #6 기초코드 경량 후보(CL 1124 Pantone enum과 동일·V-13 검토급·우선순위 낮음·매체별 별색 라이브러리 거버넌스). |
| **⑤ 마감봉제(SEW_FBR)·제품가공(PDT_WRK 상품별)**(FS-5) | **WEAK** | **V-8 형태가공(#14) family** | `PROC_000080 봉제`·`PROC_000084 열재단` 공정 행 **라이브 실재**(마감봉제 SEW_FBR=봉제 family·PD SEW_LTR 동형)·PDT_WRK=동일 PCS 슬롯+상품별 인스턴스(쿠션가공≠에코백가공·별 "제품별 가공 축" 아님·GS/PD/FS 횡단) = V-8(#14 본체 형태가공 GAP·봉제 family 멤버)에 흡수(PD-1 봉제=#14 동형). LAB_FBR/LIN_PRT/POC_FBR/WRK_MTR=자재(라벨/끈/자석)+공정(부착)+부속물#8 BUNDLE(AC/ST/PD SUB_MTR 동형). 봉제/별색/재단 공정 행은 실재(PASS측면)·상품별 인스턴스 적재=data. **신규 V 아님.** |
| **⑥ ★완제 부자재(솜 TN001/끈/자석/라벨/포켓)**(FS-6·directive 핵심) | **PASS** | (없음·그릇 존재·선택 노출은 옵션#3) | ★`t_prd_product_addons`(prd_cd·tmpl_cd) **완제 부속 그릇**(PD-4·AC 받침·#8)+**MAT_TYPE.09 봉제부자재 버킷 실재**(자재행 0건·솜/끈/라벨/자석 자재 귀속처·자재#1)+선택형 노출(솜 선택안함)=옵션#3 택1 그릇 보유 → **vessel 조치 불요**. ★`t_prd_product_addons`에 view_yn/노출 모드 컬럼 부재이나 선택형은 옵션#3 레이어로 표현(PD-4 고정 ESN=Y와 **노출 차원만 분기**·FS는 view_yn=Y 선택형). 솜/끈/자석 자재행·addon 행·옵션 선택 노출 적재=data(round-22 ④자재·GPM-4·round-6 CPQ). **신규 V 아님.** |
| **⑦ 가격모델(real_price/real_calc_price)**(FS-7) | **WEAK** | **기존 #11 가격기여역할** | FSSQPST=real_price(면적·BN/실사 동형)·나머지4=real_calc_price(완제 봉제 실계산) → 후니 면적매트릭스형 vs 고정가형 라우팅 그릇 보유(`dbmap-price-formula-types-authority` 정합)·단 real_price↔real_calc_price 차이·타일링/마감봉제/솜 단가=infoCall `unobserved`=기존 #11 WEAK. 면적함수/가산=가격검증 트랙. **신규 V 아님.** |
| **⑧ PCS 상세 enum·단가(infoCall)**(FS-8) | **— (unobserved)** | (축 판정 무영향) | infoCall AJAX 후행·SSR 미노출·축 판정(타일링 #18 부결·17축 재포화) SSR 슬롯만으로 확정. infoCall 캡처(node monitor)=validation/가격검증 트랙. **축/vessel 판정 무영향.** |

> **★FS 요지:** FS facet 8항 = PASS 3(#2 방향=사이즈#13·#4 별색=공정#2 PROC_000007·#6 완제 부자재=부속물#8/MAT_TYPE.09/옵션#3·그릇존재·조치 0)·WEAK 3(#3 면직물 measure_type→V-3·#5 봉제/제품가공→V-8·#7 가격모델→#11)·GAP 1(#1 타일링→V-1 공정파라미터#9)·unobserved 1(#8 infoCall). **신규 V-번호 0** — FS는 새 그릇 수요를 추가하지 않고, 기존 V-1(타일링 enum 공정 파라미터·jsonb 그릇 실재·반복배치 enum 미적재 측면)·V-3(면직물 measure_type 번수/면사 수·평량/두께/oz/번수 구분)·V-8(봉제 SEW_FBR/제품가공 PDT_WRK family 멤버)에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR·CL·AC·PD·PH 패턴 반복): 10번째 카테고리(directive 1순위 타일링[반복 배치 차원]·마감봉제·완제 부자재 포함 직물 풀프린팅+봉제 완제 굿즈)가 새 그릇을 요구하지 않음. ★특기: **FS-1 타일링 = data-gap not vessel-gap 라이브 확정** — 공정#2 인쇄 배치 파라미터#9 `t_proc_processes.prcs_dtl_opt` jsonb(오시/미싱 줄수·코팅 면 enum) 인쇄배치 1급 그릇 실재·후니 KB plate_size/공정 파라미터 인쇄 배치 1급 모델링(ST 형상 G-SK-2 "어느 축에도 없음" vessel-gap과 정반대)·타일링≠판걸이수(HARD·고객 입력 vs 앱계산 파생). **FS-6 완제 부자재 = data-gap** — `t_prd_product_addons`+MAT_TYPE.09 봉제부자재 버킷+옵션#3 선택 노출 그릇 실재(PD-4 동형·선택형은 view_yn=Y 노출 차원만 분기). designer는 V-1 설계 시 타일링 enum(인쇄 배치 파라미터), V-3 설계 시 면직물 measure_type(번수/신축성)·면사 수, V-8 설계 시 봉제(SEW_FBR)/제품가공(PDT_WRK) family를 *함께* 반영(별 순서/V-번호 추가 0). ★FS-1 타일링·FS-6 완제 부자재·infoCall 단가는 dbmap 라우팅(vessel 아님).

---

## ═══ NC 흡수 매핑 (v11.0 — 신규 vessel 0·facet 4항+N-5 기존 V-항목 귀속·★N-2 이산 부수 tier=data-gap) ═══

NC가 추가한 신규 vessel-gap = **0건**(인쇄방식 옵셋 vs 디지털 #18 부결=이미 #12). NC facet 4항+N-5(directive)가 어느 기존 V-항목/판정에 흡수되는지. **새 V-번호 부여 안 함.** ★N-2 이산 부수 tier(directive 핵심)·offset2023_price 산정식은 vessel 아님(data-gap·dbmap).

| NC facet | gap-matrix 판정 | 흡수 대상 | 그릇 조치 |
|---|:---:|---|---|
| **① ★N-2 이산 부수 tier(MTRL_CD×PRN_CNT 100~500)**(directive 핵심) | **WEAK** | **V-5 수량 이중슬롯(#10)·★주로 data-gap** | ★옵셋 이산 tier=옵션#3(`option_items` 폴리모픽 469행·`ref_key2` 자재 페어링·CL 2D 동형)+제약#5(`constraints.logic` jsonb 자재→허용부수 cascade)+가격#11(`t_dsc_discount_details.min_qty/max_qty` round-1 부수구간 단가) **3 의미 분산 표현 그릇 보유** → **별 vessel 불요**. 단 `t_prd_products.min_qty/max_qty/qty_incr` 연속 increment 가정→이산 모드(연속 vs 이산 tier) 명시 슬롯 미흡=V-5(#10 수량 이중슬롯)에 *이산 모드 차원* 함께 고려. ★본질=data-gap(자재×부수 매트릭스·부수구간 단가 미적재·dbmap·PD-4/PH-1/FS-1 동형). **신규 V 아님.** |
| **② N-1 가격엔진 라우팅(offset2023_price)** | **WEAK** | **V-7 가격 role 태그(#11)** | `t_prd_product_price_formulas`(76행/76상품/45공식) 바인딩 그릇이 offset2023_price를 *frm_cd 값 하나*로 흡수(ST digital/vTmpl·AC acrylic2025 동형 라우팅)·★frm_typ/pricing_model 1급 라우팅키만 부재=V-7(#11) frm_typ_cd 라우팅 부재와 동일(PR P-6/ST S-6/AC A-6 동일). **가격 트랙 위임(V-7 최하)** — frm_typ_cd 그릇이 offset2023/digital/면적 라우팅 해소. offset2023_price 산정식=dbmap 가격 트랙(unobserved·범위 외). **신규 V 아님.** |
| **③ N-4 옵셋전용 자재 pool 게이팅(RXWMO220)** | **GAP** | **V-2 인쇄방식 게이팅(#12)** | PR P-7(윤전→YWM)·ST S-5(DTF→DTF필름)와 동일 #12 GAP — V-2(#12)의 *자재풀 부분집합 게이팅* 면(인쇄방식↔자재 호환). `t_mat_materials`에 print_method/호환 컬럼 0건. V-2 설계 시 "PrintMethod gates Material pool(옵셋→모조지 RXWMO·디지털→아트지/얼스팩)" 관계 간선 포함 권고(신규 V 아님). |
| **④ N-1 인쇄방식 토큰(item_gbn=offset2023_item)** | **GAP** | **V-2 인쇄방식 게이팅(#12)** | item_gbn(offset2023_item vs digital_item)=인쇄방식 discriminator enum(CL clothes2025·PR pdtCode·ST prefix 동형·명제#19)·새 스키마 슬롯 0(reverse 차이표 7행 전부 "같은 슬롯 값만 다름")=V-2(#12) lifecycle 게이팅. NC가 *4번째 인코딩*(item_gbn/price_gbn 토큰 bundle)으로 토큰 레벨 재확인(신규 V 아님). V-2 설계 시 인쇄방식 enum에 offset2023 포함 권고. |
| **(부) N-5 접지(NCDFFLD 사이즈 SKU)·오시(OSI_DFT)·귀돌이(ROU_DFT)** | **PASS** | (없음·그릇 존재) | 접지=`t_siz_sizes` 접지치수 SKU(2단/3단×세로/가로) **1:1 프리셋 흡수**(PR 리플렛 FLD_DFT 옵션축 vs NC 명함 사이즈 SKU=상품군별 접지 관리축 분기·둘 다 기존 축)·오시/귀돌이=공정#2 멤버(PROC) → **vessel 조치 불요**. 사이즈↔오시 cascade는 V-4(제약 RULE_TYPE match)와 겹침. |

> **★NC 요지:** NC facet 4항+N-5 = WEAK 2(#1 이산 tier→V-5·주로 data·#2 가격엔진→V-7)·GAP 2(#3 자재풀 게이팅→V-2·#4 토큰→V-2)·PASS 1(N-5 접지=#13/오시=#2·그릇존재·조치 0). **신규 V-번호 0** — NC는 새 그릇 수요를 추가하지 않고, 기존 V-2(인쇄방식 게이팅에 옵셋 자재풀 면·offset2023 토큰)·V-5(수량에 이산 tier 모드)·V-7(가격에 offset2023_price 라우팅)에 facet 강화 메모만 더한다. 이것이 17축 재포화의 vessel-side 증거(PR·CL·AC·PD·PH·FS 패턴 반복): 11번째 카테고리(directive 최강 #18 후보 인쇄방식 옵셋 vs 디지털·별도 가격엔진·이산 tier·전용 자재풀·item_gbn 토큰 포함)가 새 그릇을 요구하지 않음. ★특기: **N-2 이산 부수 tier = data-gap not vessel-gap 라이브 확정** — 옵션#3 `option_items`(폴리모픽 469행)·제약#5 `constraints.logic`(jsonb 10행)·가격#11 `t_dsc_discount_details`(min_qty/max_qty 구간할인) 그릇 실재·후니 KB가 수량/제약/가격 이미 1급 모델링(ST 형상 G-SK-2 "어느 축에도 없음" vessel-gap과 정반대)·옵셋 이산 tier=공유 슬롯의 채움 차이(디지털 BC와 100% 동형)·전용 슬롯 부재→#18 부결. designer는 V-2 설계 시 옵셋 자재풀 게이팅·offset2023 토큰, V-5 설계 시 이산 tier 모드, V-7 설계 시 offset2023_price 라우팅을 *함께* 반영(별 순서/V-번호 추가 0). ★N-2 이산 부수 tier·offset2023_price 산정식은 dbmap 라우팅(vessel 아님).

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
1b. **V-12 형상 축 (★ST directive 1순위·신규)** — ST 본질·형상 컬럼/테이블/enum 3-레벨 전무·dbmap G-SK-2 위 정밀화(siz 흡수 정정)·ST 36상품+도무송/모양재단·형상↔칼틀(#13)/모양파라미터(#9)/자유칼선(#2) 게이팅 분류자. **단 1:1 흡수 카테고리는 size 유지(전면 강제 금지).** SHAPE enum 신설은 명백(16그룹에 부재). V-1(공정파라미터)·#13과 연동 설계.
2. **V-3 자재 분해축 (★GS 최우선)** — 굿즈 본체자재 핵심 결함·B-3 축이동 목적지·오염 광범위(.09 69·.10 43)·텀블러/장패드 용량/두께 분해 의존. **+ST 점착/내후 차원(adhesion_grade/weather_grade) 합류.**
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
> ★ST 핵심(v5.0): **V-12 형상 = 신규 P1**(V-10·V-3과 나란한 directive 1순위·16축 포화 붕괴). FK 위상: 형상축(V-12)이 칼틀/사이즈(#13)·모양 파라미터(#9 V-1)의 *게이팅 분류자* → V-1·#13과 연동 선행 설계. ST facet 5항은 신규 V 0(재단입자 S-3=PASS 그릇존재·점착 S-4→V-3·disable S-8→V-4·인쇄방식 S-5→V-2·가격엔진 S-6→V-7·칼선 S-2→V-12/V-1 게이팅). designer는 V-12 설계 시 ① SHAPE enum 신설(명백) ② 1:1 흡수 카테고리 size 유지(전면 강제 금지) ③ 형상↔칼틀/모양파라미터/자유칼선 게이팅 간선을 함께 반영(별 순서 추가는 V-12뿐).
> ★AC 핵심(v7.0): **로드맵 불변** — AC는 신규 V-항목 0(가공방식 그룹핑 #18 부결·17축 재포화). AC facet 6항은 기존 V-3(★3차원 확장: 두께 measure_type·surface_finish·단일 부자재 마스터)·V-7(acrylic2025 frm_typ)·V-10/V-11(ACTPKEY TemplateAsset)에 흡수. PASS 2(받침=addon 그릇·화이트=PROC_000008)는 조치 0. designer는 **V-3 설계 시 AC 3차원(두께 measure_type·surface_finish·부자재 단일 마스터)을 ST 점착/내후 차원과 *통합* 반영**(별 순서/V-번호 추가 0). ★단일 부자재 마스터(고리/받침/자석 4버킷 분산·D링 3중복)는 V-3 버킷 재정의의 일부이나 행 영향 커 신중(주로 data·dbmap B-3과 조율). ★dbmap 31_acrylic 라이브 산출과 구조 동형 확증(CLEAR3T mat_cd 통합·MIRROR3T 별 comp·화이트=공정)·Q-ACR-7(.02)/미러 GAP은 dbmap 가격 트랙 범위 외(vessel 아님).
> ★PD 핵심(v8.0): **로드맵 불변** — PD는 신규 V-항목 0(완제 구조물 내재BOM #18 부결·17축 재포화). PD facet 5항은 기존 V-8(봉제/제품가공 family·#14)·V-3(직물 물성 차원·밑창 sub_mtrl)에 흡수되므로, designer가 그 항목들을 설계할 때 PD facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 1건(단수/형상=#13 사이즈 1:1 흡수·★ST 형상#17 1:多 미충족이라 V-12 강제 불요)·★PD-4 내재BOM(addon→tmpl_cd 그릇·usage .07 슬롯 보유)는 그릇 보유로 vessel 조치 0. ★핵심 directive 직답: **PD-4 완제 구조물 내재BOM = data-gap not vessel-gap**(부속물#8·자재 usage 그릇 실재·후니 KB 1급 모델링·ST G-SK-2와 정반대) → dbmap 적재 트랙(`_data-gaps-noted.md §9`)·vessel 신설 불요. designer는 V-8 설계 시 봉제(SEW_LTR)/제품가공(PDT_WRK) family 멤버, V-3 설계 시 직물 물성 차원(번수/신축성)·밑창 sub_mtrl을 *함께* 반영(별 V-번호 추가 0).
> ★PH 핵심(v9.0): **로드맵 불변** — PH는 신규 V-항목 0(완제 액자 그릇/마운팅 #18 부결·17축 재포화·9번째 카테고리). PH facet 6항은 기존 V-3(인화지×마감 surface_finish)·V-11(완제 액자 SKU↔디자인시안 이중의미 분리)에 흡수되므로, designer가 그 항목들을 설계할 때 PH facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 3건(거치 캐스케이드=옵션#3 option_groups 134/constraints.logic 10 그릇·형태 비율=#13 사이즈 1:1·다중분류=#7 main_cat_yn 2카테고리 8상품)은 그릇 보유로 vessel 조치 0. ★핵심 directive 최대 관전 직답: **PH-1/PH-2 완제 액자/거치 마운팅 = data-gap/facet not vessel-gap**(거치 §0.5 OBSERVED했으나 옵션#3 캐스케이드·완제SKU#4 templates/selections·자재#1 프레임재질 그릇 실재·후니 KB 결함 없음·ST 형상 G-SK-2와 정반대) → dbmap CPQ 옵션레이어/적재 트랙(`_data-gaps-noted.md §10`)·vessel 신설 불요. ★ST 형상#17 승격(전용 슬롯+KB 결함 둘 다)과 결정적 분기: 거치=전용 슬롯 OBSERVED(✅)+KB 결함 없음(❌)=②불충족→부결. designer는 V-11 설계 시 완제 액자 SKU 분리, V-3 설계 시 인화지×마감 surface_finish를 *함께* 반영(별 V-번호 추가 0).
> ★CL 핵심(v6.0): **로드맵 불변** — CL은 신규 V-항목 0(의류 variant #18 부결·17축 재포화). CL facet 5항은 기존 V-1(위치별 공정 파라미터)·V-2(CL 인쇄방식 enum)·V-3(의류 본체 원단×색×사이즈 분해/버킷)·V-9(item_gbn 생산형태)·V-10(KOI_NME 위치-에디터 매핑)에 흡수되므로, designer가 그 항목들을 설계할 때 CL facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 1건(Pantone 별색 PROC_000007)·option_items 2D 페어링 활성(255/469 ref_key2)은 그릇 보유로 vessel 조치 0. ★주의: 의류 size×color 2D matrix는 후니 옵션 그릇이 *구조적으로 견딤*(ref_key1/ref_key2)이나 색상이 OPT_REF_DIM 7종에 별 ref 타입 없음→자재 CLR 라우팅·의류 원단 MAT_TYPE 버킷 부재 → V-3 설계 시 의류 본체 분해/버킷을 함께 고려. 별색 지정값(1124 Pantone) enum은 #6 경량 후보(우선순위 최하·실크인쇄 한정).
> ★NC 핵심(v11.0): **로드맵 불변** — NC는 신규 V-항목 0(인쇄방식 옵셋 vs 디지털 #18 부결=이미 #12·17축 재포화·11번째 카테고리·★최강 #18 후보 정면 격파). NC facet 4항+N-5는 기존 V-2(인쇄방식 게이팅에 옵셋 자재풀 면·offset2023 토큰)·V-5(수량에 이산 tier 모드)·V-7(가격에 offset2023_price 라우팅)에 흡수되므로, designer가 그 항목들을 설계할 때 NC facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 1건(N-5 접지=사이즈#13 SKU 1:1 흡수·오시=공정#2 PROC)은 그릇 보유로 vessel 조치 0. ★핵심 directive 직답: **N-2 이산 부수 tier(MTRL_CD×PRN_CNT 100~500·자유입력 불가) = data-gap not vessel-gap**(옵션#3 option_items 폴리모픽 469행·제약#5 constraints.logic jsonb 10행·가격#11 t_dsc_* min_qty/max_qty 구간할인 그릇 실재·후니 KB 수량/제약/가격 1급 모델링·옵셋 이산 tier=공유 슬롯 채움 차이[디지털 BC와 100% 동형]·ST G-SK-2와 정반대) → dbmap round-1 구간할인/round-6 CPQ 트랙(`_data-gaps-noted.md §12`)·vessel 신설 불요. ★ST 형상#17 승격(전용 슬롯+KB 결함 둘 다)과 결정적 분기: 인쇄방식 #18=① 전용 슬롯 부재(enum 토큰·새 슬롯 0·reverse 차이표 7행 "같은 슬롯 값만 다름")+② KB 결함 부재(#12로 이미 1급)=둘 다 불충족→가장 깨끗한 부결(PH 거치·FS 타일링 부결과 동일 구조·양방향 정직). designer는 V-2 설계 시 옵셋 자재풀 게이팅·offset2023 토큰, V-5 설계 시 이산 tier 모드, V-7 설계 시 offset2023_price 라우팅을 *함께* 반영(별 V-번호 추가 0).
> ★FS 핵심(v10.0): **로드맵 불변** — FS는 신규 V-항목 0(타일링 TILL_WH_GBN #18 부결·17축 재포화·10번째 카테고리). FS facet 8항은 기존 V-1(타일링 enum 공정 파라미터#9·jsonb 그릇 실재)·V-3(면직물 measure_type 번수/면사 수)·V-8(봉제 SEW_FBR/제품가공 PDT_WRK family·#14)에 흡수되므로, designer가 그 항목들을 설계할 때 FS facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 3건(방향=#13 사이즈 매핑·별색=공정#2 PROC_000007·완제 부자재=부속물#8 addons+자재#1 MAT_TYPE.09+옵션#3 선택 노출)은 그릇 보유로 vessel 조치 0. ★핵심 directive 1순위 직답: **FS-1 타일링 = data-gap not vessel-gap**(공정#2 인쇄 배치 파라미터#9 `t_proc_processes.prcs_dtl_opt` jsonb[오시/미싱 줄수·코팅 면 enum] 인쇄배치 1급 그릇 실재·후니 KB plate_size/공정 파라미터 인쇄 배치 1급 모델링·ST G-SK-2와 정반대·타일링≠판걸이수 HARD[고객 입력 vs 앱계산 파생]) → dbmap round-22 ③공정 트랙(`_data-gaps-noted.md §11`)·vessel 신설 불요. **FS-6 완제 부자재(솜/끈/자석)도 data-gap**(addons+MAT_TYPE.09 봉제부자재 버킷+옵션#3 선택 노출 그릇 실재·PD-4 동형·선택형은 view_yn=Y 노출 차원만 분기). ★ST 형상#17 승격(전용 슬롯+KB 결함 둘 다)과 결정적 분기: 타일링=전용 슬롯 OBSERVED(✅·5상품 전수)+KB 결함 없음(❌)=②불충족→부결. designer는 V-1 설계 시 타일링 enum(인쇄 배치 파라미터), V-3 설계 시 면직물 measure_type(번수/신축성)·면사 수, V-8 설계 시 봉제(SEW_FBR)/제품가공(PDT_WRK) family를 *함께* 반영(별 V-번호 추가 0).
> ★PO 핵심(v13.0): **로드맵 불변** — PO는 신규 V-항목 0(기재마운팅/자립구조 #18 부결·17축 재포화·13번째 카테고리·★기재마운팅/자립구조 관측 기반 부결). PO facet 4항은 기존 V-2(제작방식=합지/직접출력→가능 후가공 게이팅 lifecycle)·V-3(검정포맥스/검정폼보드 색 variant 분해축)·V-7(real_price 면적계수 라우팅)에 흡수되므로, designer가 그 항목들을 설계할 때 PO facet 메모를 *함께* 반영(별 순서 추가 없음). PASS 2건(★PO-2 거치대 독립 SKU 다중 귀속=부속물#8 `t_prd_product_addons.tmpl_cd`·PO-4 면적 연속차원=사이즈#13 nonspec_width/height_min/max/incr + t_siz work/cut 2치수)은 그릇 보유로 vessel 조치 0. ★핵심 directive 최대 관전 2건 직답: **① 제작방식(합지/직접출력) = facet not vessel-gap**(한 상품 내 "제작방식 select" 부재·pdtCode 분기·합지=라미/코팅 공정#2 PROC_000013~015 실재·검정 variant=#1·게이팅 lifecycle=#12 GAP으로 3축 분산·NC item_gbn 동형) **② 자립구조(등신대 거치대/피켓) = PASS/facet not vessel-gap**(★거치대 add-on이 독립 SKU 참조하는 정규화 그릇 `addons.tmpl_cd` 라이브 실재·PRD_000016 5 SKU 다중 귀속 실데이터·옵션값 복제 아님·모양재단=형상#17 V-12 게이팅·피켓 손잡이=부자재 무) → dbmap CPQ 옵션레이어/적재 트랙(`_data-gaps-noted.md §14`)·vessel 신설 불요. ★ST 형상#17 승격(전용 슬롯+KB 결함 둘 다)과 결정적 분기: 거치대=독립 SKU 참조 그릇 OBSERVED(✅·addons.tmpl_cd 다중 귀속 실데이터)+KB 결함 없음(❌·부속물#8 무왜곡 표현)=②불충족→부결(PH 거치·NC 인쇄방식·OT 전개도 부결과 동일 구조·양방향 정직). ★PO 우월점=SSR 완전노출로 PH(§0.5 재캡처 필요)와 달리 *1회 GET 관측 기반 부결*. designer는 V-2 설계 시 제작방식(합지/직접출력) 후가공 게이팅, V-3 설계 시 검정 기재 variant 분해축, V-7 설계 시 real_price 면적계수를 *함께* 반영(별 V-번호 추가 0). ★누적 신규 mint V-11(TemplateAsset)·V-12(SHAPE) 불변(13 카테고리 통틀어 신규 테이블 mint 2건 유지).
