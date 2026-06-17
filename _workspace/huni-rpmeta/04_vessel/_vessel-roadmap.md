# 후니 기초데이터 관리 그릇 정비 로드맵 (_vessel-roadmap)

> rpm-vessel-designer. `04_vessel/vessel-*.md` 전 그릇을 leverage + FK/마이그 의존 순으로 정렬 + 후니 base-data 관리 정비 계획.
> 권위 = 라이브 read-only 실측(2026-06-17·gap-matrix와 동일 세션). [HARD] design ≠ apply — 전 항목 인간 승인. 라이브 CREATE/ALTER/COMMIT 0.
>
> **── 버전 ──**
> - **v1.0 (BN):** §0 8축 인벤토리·§1 Wave·§2·§3. **보존(아래 v1.0 표는 그대로, v2.0 행 추가).**
> - **v2.0 (GS·2026-06-17):** + V-3 굿즈 확장(§7 in vessel-material-axis)·**V-8 형태가공**·**V-9 생산형태**·**MAT_TYPE 오라벨 교정**. GS 라이브 재측이 #14·#15를 BN 추정보다 *덜 vessel-gap*으로 확증(형태가공=분류축 1개·생산형태=신규 그릇 0). 인벤토리·Wave·정비권고에 GS 행만 추가, v1.0 무수정.
> - **v3.0 (TP·2026-06-17):** + **V-10 디자인 입력 채널(#16 GAP·★directive 1순위)** = base_code 그룹 3 + 상품 컬럼 4(신규 테이블 0) + **V-11 TemplateAsset 분리(T-A WEAK)** = 신규 테이블 2(본 하네스 **유일 mint**·이중의미 분리). TP 나머지 facet(VDP·페이지계층·형태variant·특수인쇄) = 기존 흡수(신규 0). 라이브 DRY-RUN(BEGIN..ROLLBACK)으로 양 DDL 유효성 실증·0 leaked. v1.0/v2.0 무수정.
> - **v4.0 (PR·2026-06-17): PR 카테고리 = 신규 그릇 0건.** PR(인쇄물·책자·리플렛·포스터) distinct 신축 0(facet 강화 9건뿐) → search-before-mint 통과·기존 V-항목 충분. PR facet 6항(PASS 4: 표지/내지·접지/제본·page_rule·면지 / WEAK 1 / GAP 1) 중 조치 대상 2건은 기존 그릇에 facet 흡수: **P-7(인쇄방식 자재풀 게이팅) → V-2**(`vessel-print-method-recipe §7`·경로 A 제약흡수가 자재 부분집합도 담음·신규 0)·**P-6(digital_price 라우팅) → V-7**(`vessel-quantity-size-pricing §C4`·frm_typ_cd 결손 동일·가격 트랙 round-16/17 위임). **16축 포화의 vessel-side 검증** — 4번째 카테고리가 새 그릇을 요구하지 않음. 신규 테이블/컬럼/DDL/V-번호 0·인벤토리·Wave·정비권고 무수정.
> - **v5.0 (ST·2026-06-17): ★16축 포화 붕괴 — 신규 그릇 1건(V-12 형상 축).** ST(스티커)가 distinct 신축 1건(#17 형상)으로 PR 포화를 정직하게 깸 → 17축. **V-12 형상 축**(`vessel-shape-axis.md`) = `SHAPE` base_code 그룹 1 + `t_prd_products.shape_cd`(상품 1형상) + `t_prd_product_sizes.shape_cd`(형상↔칼틀 1:多 게이팅·**기존 junction 재사용·테이블 mint 0**) — **컬럼 2(서로 다른 카디널리티)·신규 테이블 0.** 라이브 3-레벨 실측(형상 컬럼/테이블/SHAPE enum 0건)이 KB G-SK-2 확증. ★siz 흡수 거부 근거 = 형상↔칼틀 1:多(CL→CL001~100)·5형상 superset(STDCFBR) → siz 행 흡수 시 정규화 붕괴. **dbmap round-3 "도무송 형상=siz_cd 신설" 권고를 1:多 증거가 정정(충돌 아닌 정밀화).** ST facet 5항(칼선 S-2·재단입자 S-3·점착 S-4·인쇄방식 S-5·disable S-8) = **신규 vessel 0** — 전부 기존 V-항목 흡수(재단입자=PASS 그릇존재·점착→V-3·인쇄방식→V-2·disable→V-4·칼선→V-12/V-1 게이팅). 라이브 DRY-RUN(BEGIN..ROLLBACK)으로 코드행 6+ALTER ×2+FK ×2 유효성·백필 smoke·0 leaked 실증. **★[HARD] 1:1 흡수 카테고리(BN/GS/TP/PR)는 shape_cd NULL 유지·형상축 전면 강제 금지(오모델 회피).** v1.0~v4.0 무수정.
> - **v6.0 (CL·2026-06-17): CL 카테고리 = 신규 그릇 0건, 의류 variant facet 흡수(size×color 2D=V-3·ref_key1/ref_key2 라이브 활성), 17축 재포화 vessel-side 검증.** CL(의류·티셔츠·앞치마·가방류) distinct 신축 0(의류 variant #18 부결·PR 패턴 반복) → search-before-mint 통과·기존 V-1~V-12 충분. CL facet 5항(PASS 1: Pantone 별색 PROC_000007 / WEAK 3 / GAP 1) 흡수: **C-2/C-3(size×color 2D matrix) → V-3**(`vessel-material-axis.md §9`·★2D 셀 구조는 `option_items.ref_key1/ref_key2` 페어링 **라이브 활성 255/469**이 무손실 수용=후니 옵션 그릇이 GS 1D→CL 2D variant 일반화 견딤·색=자재 CLR 라우팅·의류 원단 버킷 designer 판정)·**C-4(인쇄위치 멀티슬롯) → V-1**(위치별 공정 파라미터 `ref_param_json`·`vessel-process-parameter.md §5c`)+**V-10**(KOI_NME 위치-에디터 매핑·`vessel-design-input-channel.md §8`)·**C-6(인쇄방식 실크/전사/DTF) → V-2**(`vessel-print-method-recipe.md §9`·삼면 표현·경로 A 흡수)·**C-5(item_gbn=clothes2025 discriminator) → V-9**(`vessel-production-type.md §5d`·생산형태 governing·data 교정 주). **신규 테이블/컬럼/DDL/V-번호 0**(별색 지정값 1124 Pantone enum=#6 경량 후보·우선순위 최하·실크인쇄 한정·designer 판정 보류). **17축 재포화의 vessel-side 검증** — 6번째 카테고리가 새 그릇을 요구하지 않음. 인벤토리·Wave·정비권고 무수정·dbm-ddl-proposer 미호출.

---

## 0. 그릇 인벤토리 (v1.0 BN 8축 + v2.0 GS 4 → 설계 결과)

### v1.0 (BN) — 8축
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-1 공정파라미터** (#9) | GAP ❌ | `ref_param_json jsonb` 컬럼 1개 | **3 JSONB** | 컬럼 1 (기존 ddl-proposer 재사용) |
| **V-2 인쇄방식레시피** (#12) | GAP ❌(조건부) | 제약 축 흡수(경로 A) — **신규 그릇 0** | 데이터 | 0 (open decision) |
| **V-3 자재분해축** (#1) | WEAK 🟡 | `MAT_FACET` 코드 2~3 (+선택 `mat_facet_cd` 컬럼) — 두께/무게는 기존 컬럼 PASS | 1 코드행(+선택 컬럼) | 코드 2~3 |
| **V-4 제약논리유형** (#5) | WEAK 🟡 | `RULE_TYPE.04 match`·`.05 범위` 코드 2 (essential=PASS 재분류) | 1 코드행 | 코드 2 |
| #4 템플릿가격 | WEAK 🟡 | 가격 사슬 위임 — **신규 그릇 0** | — | 0 (open decision) |
| **V-5 수량** (#10) | WEAK 🟡 | 보류 — **신규 그릇 0** | — | 0 (샘플 확대) |
| **V-6 사이즈 nonspec** (#13) | WEAK 🟡 | V-4 RULE_TYPE.05 흡수 — **신규 그릇 0** | (V-4 공유) | 0 |
| **V-7 가격 role** (#11) | WEAK 🟡 | 가격 트랙 위임 — **신규 그릇 0** | — | 0 |

### v3.0 (TP) — 2 신축 + facet 흡수
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-10 디자인 입력 채널** (#16·★directive 1순위) | GAP ❌ → PASS | `DESIGN_INPUT_CHANNEL`·`EDITOR_KIND`·`ORD_CNT_SOURCE` 코드그룹 3 + `t_prd_products` 컬럼 4(`design_input_channel_cd`·`editor_kind_cd`·`ord_cnt_source_cd`·`vdp_yn`, ADD COLUMN NULL) — **신규 테이블 0**(채널=상품 1:1) | **2 컬럼**(코드행+ALTER NULL) | 코드 3그룹 + 컬럼 4 |
| **V-11 TemplateAsset 분리** (T-A 이중의미) | WEAK 🟡 → PASS | `t_prd_template_assets` + `t_prd_product_template_assets` 신규 테이블 2(시안 1:N·독립 lifecycle·가격0·완제SKU 분리) | **4 테이블** | ★테이블 2 (본 하네스 유일 mint) |
| TP facet(VDP·페이지계층·형태variant·특수인쇄) | GAP→흡수 / PASS | **신규 그릇 0** — VDP=`vdp_yn` 게이트(본문 보류 open)·페이지=page_rules 기존·형태=사이즈/공정 기존·특수인쇄=공정(화이트 PROC_000008·박) 기존 | — | 0 (기존 흡수) |

### v4.0 (PR) — facet 흡수만 (신규 그릇 0)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **PR P-7 인쇄방식 자재풀 게이팅** | GAP → V-2 경로 A PASS | **신규 그릇 0** — V-2(`vessel-print-method-recipe §7`)에 "PrintMethod gates Material pool" 간선 흡수·제약 logic이 자재 부분집합도 담음 | (V-2 공유·데이터) | 0 (V-2 흡수) |
| **PR P-6 digital_price 라우팅** | WEAK → V-7 위임 | **신규 그릇 0** — V-7(`vessel-quantity-size-pricing §C4`)의 frm_typ_cd 결손 동일·가격 트랙 round-16/17 위임 | (V-7 공유·위임) | 0 (V-7 흡수) |
| PR facet(표지/내지·접지/제본·page_rule·면지) | PASS ×4 | **신규 그릇 0** — usage_cd·접지/제본 공정 행·page_rules·면지 bundle 전부 라이브 실재 | — | 0 (그릇 보유) |

### v5.0 (ST) — 1 신축 + facet 흡수 (★16축 포화 붕괴)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-12 형상 축** (#17·★directive 1순위·신규) | GAP ❌ → PASS | `SHAPE` base_code 그룹 1 + `t_prd_products.shape_cd`(상품 1형상·ADD COLUMN NULL) + `t_prd_product_sizes.shape_cd`(형상↔칼틀 1:多 게이팅·기존 junction 재사용) — **신규 테이블 0**(1:多인데 junction 선재→컬럼 무손실) | **2 컬럼**(코드행+ALTER NULL×2) | 코드 1그룹(6) + 컬럼 2 |
| ST facet(칼선 S-2·재단입자 S-3·점착 S-4·인쇄방식 S-5·disable S-8) | PASS/WEAK/GAP→흡수 | **신규 그릇 0** — 재단입자 S-3=PASS(PROC_053/054/055 실재)·점착 S-4→V-3 분해축(adhesion/weather 차원)·인쇄방식 S-5→V-2(UV/DTF/후지 enum)·disable S-8→V-4(RULE_TYPE disable 유형)·칼선 S-2→V-12/V-1 게이팅 | — | 0 (기존 흡수) |

### v6.0 (CL) — facet 흡수만 (신규 그릇 0·17축 재포화)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **CL C-2/C-3 size×color 2D matrix** | WEAK → V-3 흡수 | **신규 그릇 0** — 2D 셀 구조=`option_items.ref_key1/ref_key2` 페어링 **라이브 활성 255/469**(use_yn=셀 가용성)이 무손실 수용·색=자재 CLR 라우팅·의류 원단 버킷=V-3 §9 designer 판정 | (V-3 공유·그릇 보유) | 0 (V-3 흡수) |
| **CL C-4 인쇄위치 멀티슬롯** | WEAK → V-1+V-10 흡수 | **신규 그릇 0** — 위치 다중선택=옵션 레이어(SEL_TYPE.02·기존)·위치별 공정 파라미터=V-1 `ref_param_json`·KOI_NME 위치-에디터 매핑=V-10 채널 | (V-1·V-10 공유) | 0 (V-1·V-10 흡수) |
| **CL C-6 인쇄방식 실크/전사/DTF** | GAP → V-2 경로 A PASS | **신규 그릇 0** — V-2(`vessel-print-method-recipe.md §9`) 경로 A(제약 흡수)가 의류 인쇄방식 삼면(자재facet/상품내옵션) 게이팅 담음 | (V-2 공유·데이터) | 0 (V-2 흡수) |
| **CL C-5 item_gbn discriminator** | WEAK → V-9 흡수 | **신규 그릇 0** — clothes2025/tmpl 모델분기=생산형태 governing(prd_typ_cd+본체 그릇 유도)·data 교정 주·구현 discriminator라 vessel-gap 아님 | (V-9 공유·data) | 0 (V-9 흡수) |
| **CL C-7 Pantone 별색** | PASS | **신규 그릇 0** — `PROC_000007 별색인쇄`+화이트/클리어/금/은 라이브 실재·별색=공정 경계 준수 | — | 0 (그릇 보유·1124 지정값 enum=#6 경량 후보·최하 보류) |

### v2.0 (GS) — 4 (V-3 확장 포함)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-3 굿즈 분해축** (#1 GS·§7) | WEAK 🟡 | `MAT_FACET.03 용량` 코드 1 (+조건부 `capacity` 컬럼) — 색=CPQ option 위임·소재/두께/무게=기존 컬럼·brand=note | 1 코드행(+조건부 컬럼) | 코드 1 |
| **V-8 본체 형태가공** (#14) | GAP ❌→부분PASS | `PROC_CLASS` 코드 5 + `proc_class_cd` 컬럼 1 (파라미터=prcs_dtl_opt+ref_param_json PASS·지퍼/조립 행=data) | 1 코드행 + 1 컬럼 | 코드 5 + 컬럼 1 |
| **V-9 생산형태 governing** (#15) | WEAK 🟡→PASS | **신규 그릇 0** — prd_typ_cd + `semi_role_cd`(set_structure 실재)로 PASS·잔여는 값 교정(data round-15) | — | 0 (PASS 재분류) |
| **MAT_TYPE 오라벨 교정** | vessel-level 분류축 결함 | `.09/.10 use_yn='N'`(행 선이동 후)·신소재 .05 흡수 — 신규 0 | 코드 use_yn(행 의존) | 0 (★open decision·B-3 강결합) |

### 카운트 (v1.0 + v2.0 + v3.0 + v5.0 통합)
- **설계한 실 그릇(DDL/코드행 필요): 8** — V-1(JSONB 컬럼)·V-3(BN facet 코드 2 + GS 용량 코드 1)·V-4(코드행 2)·**V-8(PROC_CLASS 코드 5 + proc_class_cd 컬럼 1)**·**V-10(코드그룹 3 + 상품 컬럼 4)**·**V-11(신규 테이블 2)**·**V-12(SHAPE 코드그룹 1[6코드] + 컬럼 2)**. (+조건부: V-3 capacity 컬럼).
- **"신규 그릇 불요" 재분류: 8** — V-2·#4·V-5·V-6·V-7 + **V-9(prd_typ_cd+semi_role_cd PASS)** + MAT_TYPE(신규 0·use_yn만) + **TP facet(VDP본문보류·페이지/형태/특수인쇄 기존 흡수)** + **ST facet 5항(재단입자 PASS·점착→V-3·인쇄방식→V-2·disable→V-4·칼선→V-12/V-1 게이팅)**. + essential(V-4 내부 PASS).
- **신규 테이블 mint = 2건**(V-11 TemplateAsset 마스터+링크 — **본 하네스 전체 유일**). BN/GS·V-10 채널·**V-12 형상**·**PR 전부 0**(코드행/컬럼/흡수). ★TP 핵심 교훈: **사다리는 축의 카디널리티가 결정** — V-10 채널=상품 1:1 → 컬럼에서 멈춤(테이블 거부), V-11 시안=상품 1:N·독립 lifecycle·완제SKU 이중의미 → 테이블만 무손실(mint 정당). over-modeling도 under-modeling도 아닌 *정확한 사다리*.
- **★ST/V-12 핵심 교훈(v5.0): 1:多여도 junction이 선재하면 테이블 mint 불요.** 형상↔칼틀 1:多(CL→CL001~100)는 *카디널리티만 보면* 종속 테이블처럼 보이나 — `t_prd_product_sizes`(prd×siz junction)가 **이미 그 쌍을 담고 있어** `shape_cd` 분류 컬럼이 무손실. V-11(시안 1:N·*junction 부재*·독립 lifecycle → 테이블 mint 정당)과 대비: **mint 정당성 = 카디널리티 단독이 아니라 [1:N/M:N] AND [선재 junction 없음] AND [독립 lifecycle]의 합.** V-12는 1:多이나 선재 junction이 있어 컬럼에서 멈춤 = *정확한 사다리*. siz_sizes 마스터(497행 공유)가 아닌 prd×siz junction에 매는 것이 정규화 핵심(공유 칼틀 형상 충돌 회피).
- **★PR 교훈(v4.0): 4번째 카테고리가 신규 그릇 0건** — PR facet 9건이 전부 기존 16축의 facet/family/cascade로 흡수. **16축 포화(saturation)의 vessel-side 증거.**
- **★ST 교훈(v5.0): 5번째 카테고리가 포화를 정직하게 깸(신규 그릇 1)** — ST가 형상축 1건만 새 그릇을 요구하고 facet 5항은 전부 기존 흡수. 이는 오버피팅이 아니라 *사이즈축이 형상을 1:1 칼틀로 흡수해온 전제가 ST의 전용 shape_info 슬롯·1:多로 깨진* 증거 강제 결과. PR 포화 입증(distinct 0)도 여전히 유효 — PR은 형상을 1:1로만 가져 흡수 정당, ST가 1:多 분리를 명시 슬롯으로 드러내 차이를 만듦. **그릇 설계는 카테고리 증거에 정직(포화도 진화도 증거가 결정).**
- **★CL 교훈(v6.0): 6번째 카테고리가 신규 그릇 0건(17축 재포화·PR 패턴 반복)** — CL facet 5항이 전부 기존 17축(V-1/V-2/V-3/V-9/V-10)의 facet/cascade로 흡수. ★핵심 vessel-side 검증 = **`option_items.ref_key1/ref_key2` 2D 페어링이 라이브 활성(255/469)으로 의류 size×color 2D 매트릭스·셀 가용성을 *구조적으로 견딤*** — 후니 옵션 그릇이 GS 1D variant→CL 2D variant 일반화를 무손실 수용. ST가 형상으로 포화를 깬 직후 CL은 다시 포화를 확인(distinct 0): **포화/붕괴/재포화는 카테고리 증거가 결정하지 미리 정해진 곡선이 아님.** 의류 variant #18 부결(별 그릇 가설→ref_key 페어링으로 환원)이 over-modeling 거부의 정직성 증거.

---

## 1. 적용 순서 (leverage + FK 위상)

> [HARD] FK 위상: 목적지 그릇(자재 분해·제약 코드)이 옵션/제약/축이동의 참조 대상 → 선행. 공정 파라미터는 공정 행 선행(이미 라이브).

### Wave 1 — 경량 코드행 (즉시·무위험·무영향)
1. **V-4 RULE_TYPE.04/.05 코드행** — 제약 거버넌스. 기존 행 무영향·FK 0. match/min-max(V-6 포함) 일원화. → dbm-ddl-proposer 코드그룹.
2. **V-3 MAT_FACET 코드행** — 자재 분해 facet 분류축(소재/두께). 기존 340행 무영향. → B-3 축이동 *목적지* 선행 조건.

### Wave 2 — JSONB 컬럼 (무잠금·백필 0)
3. **V-1 `ref_param_json` ALTER** — 공정 파라미터. ★영향분석 라이브 469행 기준 갱신(`vessel-process-parameter.md §4`): ADD COLUMN NULL = 백필 0·무잠금, 단 롤백 시 채운 값 백업 권고. CPQ option layer 완성의 선결. → `ref-param-json-proposal.sql` 재사용.

### Wave 2-TP — V-10 디자인 입력 채널 (★directive 1순위·코드행 + ALTER NULL·무잠금)
2a. **V-10 코드그룹 3 + `t_prd_products` 컬럼 4** — TP directive 1순위·editor_yn=Y 107상품 unblock·huni-widget 컨버전 경계. ADD COLUMN NULL=백필 0·무잠금(DRY-RUN 실증). FK 3→base_codes. 정합 규칙 `editor_yn='Y'⇒channel∈{.01,.03}`. → `ddl-proposal-design-input-channel.sql`. **V-11 선행**(EDITOR_KIND 코드행).

### Wave 2-ST — V-12 형상 축 (★directive 1순위·코드행 + ALTER NULL·무잠금)
2b. **V-12 `SHAPE` 코드그룹 1(6코드) + `t_prd_products.shape_cd`(상품 1형상) + `t_prd_product_sizes.shape_cd`(형상↔칼틀 1:多)** — ST directive 1순위·ST 36상품 unblock·형상 3-레벨 전무. ADD COLUMN NULL ×2 = 백필 0·무잠금(DRY-RUN 실증·0 leaked). FK 2→base_codes. **★[HARD] 1:1 흡수 카테고리(BN/GS/TP/PR)는 shape_cd NULL 유지·형상축 전면 강제 금지.** 형상→칼선(FR→완칼 모양)=**V-1 ref_param_json 연동**(V-1 선행/병행)·입력모드 게이팅=**V-4 RULE_TYPE.04(match)**. → `ddl-proposal-shape-axis.sql`. **V-1(공정파라미터)·#13(사이즈 PASS)과 연동 설계.**

### Wave 3 — 선택적/조건부 (도메인 결정 후)
4. **V-3 `mat_facet_cd` 컬럼** — upr_mat_cd 계층으로 부족 입증 시만(search-before-mint 잔여).
5. **V-2 제약흡수 데이터** — 인쇄방식 게이팅 constraints(경로 A). 후니 1급화 결정(open decision) 후.
6. **V-11 TemplateAsset 테이블 2** — V-10 EDITOR_KIND 코드행 선행 후 CREATE ×2. 완제SKU 오염 차단·시안 1:N. → `ddl-proposal-template-asset.sql`. 시안 데이터 적재=후니 카탈로그 확정 후(발명 금지·dbmap).

### 위임 (본 하네스 밖)
- #4 템플릿가격·V-5 수량·V-7 가격 role → dbmap 가격 트랙 / 샘플 확대.
- 자재/색/형상 **행 오염 축이동(B-3 data)** → dbmap round-22(vessel Wave 1·2 선행 후).

---

## 2. 후니 base-data 관리 체계 정비 권고

1. **jsonb 페이로드 패턴 일관화** — 라이브 jsonb 7컬럼(logic·tags×3·dim_vals·use_dims·prcs_dtl_opt) 중 `options.tags`(494행 전부 빈값)·`sizes.tags`(510중 1행)는 **미사용 유연 슬롯**. 새 facet은 테이블 신설 전에 이 tags/코드행부터 검토(사다리 준수). GIN 인덱스 0 컨벤션 유지(조회는 PK).
2. **분류축은 코드행, 값은 기존 컬럼/jsonb** — V-3 MAT_FACET·V-4 RULE_TYPE 확장이 보여주듯 후니 메타모델 표현력 확장의 90%는 `t_cod_base_codes` 코드행으로 도달. 테이블 mint는 진짜 1:N/독립 lifecycle만.
3. **vessel 선행 → data 이동** [HARD] — round-22 B-3 자재 축이동은 목적지 그릇(MAT_FACET·본체색 option·비치수 size)이 *먼저* 있어야 안전(80/82 상품 BOM이 .08/.09/.10 의존, 자재행 use_yn='N'은 마지막). 본 로드맵 Wave 1·2가 그 선결.
4. **라이브 = 권위, 스냅샷 stale 경계** — 00_schema 스냅샷(2026-06-06)은 round-22 이전이라 다수 stale(option_items 0→469 등). 그릇 판정은 라이브 information_schema 실측으로(본 세션 전건 라이브 확인).
5. **propose ≠ apply** — 전 그릇 인간 승인 게이트. 가격(#4·V-7)·돈 크리티컬은 특히 신중.

---

## 3-TP. TP open decision (인간 결정 남김·날조 금지)
1. **editor_yn 운명** — V-10 `design_input_channel_cd` 롤아웃 후 `editor_yn` 불리언 유지 vs 폐기(위젯/admin/쿼리 의존성 조사). 본 그릇은 공존+정합 규칙으로 안전.
2. **VDP 변수 스키마 본문** — `vdp_yn` 게이트만 설계. 변수 필드 본문(명함 이름/직함)은 후니 미관측(`koiOption[]` 빈배열·로그인 에디터 필요). 관측 후 jsonb vs 종속 테이블(`t_prd_product_vdp_fields` 또는 `t_prd_template_asset_vdp_fields` 1:N) 판정 — **관측 전 mint 금지**.
3. **에디터 종류 백필 출처** — RP item_gbn(KOI/Edicus 분기) 라이브 미보유. 후니가 Edicus 단일이면 EDITOR_KIND.02 고정·`editor_kind_cd` 컬럼 불요 가능(후니 에디터 운영 정책 결정).
4. **채널 ⊥ 인쇄방식(#12)** — 입력채널(주문측 UX) ≠ 인쇄방식(생산측 게이팅·V-2). 상관하나 별 축·한 컬럼 통합 금지(메타모델 §16 경계·에디터축 결정은 인쇄방식 1급화와 무관).
5. **시안 데이터 적재** — V-11 시안 마스터 행은 후니 에디터 카탈로그 권위(발명 금지·dbmap 적재 트랙).

## 4-TP. TP facet "기존 흡수" 기록 (신규 그릇 0)
- **VDP(T-B)** — #16 GAP에 `vdp_yn` 게이트로 흡수(본문 보류·open §2).
- **페이지 계층(T-C)** — 캘린더 월수/북 대수 = `t_prd_product_page_rules`(11행·INN_PAGE min/max/step) 기존 그릇 PASS. TP 미적재분=data(dbmap round-6).
- **형태 variant(T-D)** — 티켓 M/I/보딩·캘린더 탁상/벽걸이 = 사이즈/공정(칼틀) 기존 축 흡수.
- **특수인쇄(T-E)** — 화이트(PROC_000008)·클리어(009)·박(033~049)·별색(007) 라이브 보유·PASS(별색=공정 경계 준수). 미싱=공정·넘버링=VDP(#16) 귀속. 신규 vessel 불요.

## 4-ST. ST facet "기존 흡수" 기록 (신규 그릇 0 — V-12 형상만 신축)
- **재단입자(S-3 반칼/완칼/낱장)** — `PROC_000053 완칼`·`PROC_000054 반칼`·`PROC_000055 스티커완칼` 라이브 실재 → **PASS**(공정#2 멤버 무손실). vessel 조치 0.
- **칼선 2메커니즘(S-2 THO_GRA/THO_DFT)** — 프리셋칼틀=완칼/반칼 공정+사이즈 cascade(PASS)·자유칼선(도무송)=완칼 PROC_053+`{"모양"}` 파라미터(**V-1 ref_param_json**)·형상=FR→자유칼선 강제(**V-12 게이팅**). 별 vessel 0.
- **점착/내후 소재(S-4)** — V-3 자재 분해축의 추가 차원(adhesion_grade/weather_grade·색상/두께 동형). V-3 설계 시 함께 고려(신규 V 0). ST 자재는 `.11 스티커용지` 클린 버킷(파우치 .09 오염 아님).
- **인쇄방식(S-5 UV/DTF/후지)** — V-2 인쇄방식 게이팅(#12)의 자재/도수/화이트강제/가격엔진 게이팅 면. PR P-4/P-7과 횡단 합류. V-2 설계 시 ST enum(UV/DTF/후지) 포함(신규 V 0).
- **disable 227건 룰엔진(S-8)** — `logic jsonb` 스케일 견딤(227건 OK)·RULE_TYPE disable 전용 유형 부재 = V-4(#5) 유형 확장. ST가 disable 정점 케이스로 룰엔진 스케일 검증. V-4에 흡수(코드행 경량·신규 V 0).
- **가격엔진 3종(S-6 판/die-cut/정가)** — pricing_model 6종이 ST 3엔진(digital/vTmpl/tmpl) 흡수 = V-7 frm_typ_cd 라우팅. 가격 트랙 위임(V-7 최하·신규 V 0).

## 3-ST. ST open decision (인간 결정 남김·날조 금지)
1. **②a 상품 shape_cd vs ②b junction shape_cd 중복 운영** — 상품분기형(원형 스티커)은 ②a만·5형상 superset(STDCFBR)은 ②b만(②a NULL)·둘 다 보유는 파생 일관(정합 규칙 `prd.shape_cd NOT NULL ⇒ junction.shape_cd ∈ {NULL,동일값}`). ST 적재 실측 후 단순화 판정(상품분기형만이면 ②a·옵션형만이면 ②b).
2. **EL(타원·SHAPE.03) 칼틀 enum** — 원형(CL001~010)·라운드(RC001~025) reverse 실측·EL 프리셋 목록 unobserved. 칼틀 행 *데이터*=dbmap 적재(그릇은 ②b로 충분·EL 코드행만 선존재).
3. **자유칼선 전용 process row 신설 여부** — 라이브 칼선=완칼/반칼/스티커완칼 3행만·자유칼선(도무송) 전용 row 부재. FR=완칼(PROC_000053)+`{"모양"}`(V-1) 환원이 현 설계. 별 공정 행 신설은 공정 마스터 정책(dbmap·vessel 범위 밖).
4. **형상축 적용 경계 [HARD]** — 1:1 흡수 카테고리(BN/GS/TP/PR)는 shape_cd NULL·size 프리셋 유지. 형상축 전면 강제 = 오모델(이전 흡수 판정 번복 금지).
5. 실 적용 = 인간 승인 + dbmap 적재 트랙.

## 3. rpm-validator(M-gate) 인계
- **검증 요청:** ① search-before-mint 누락 없는지(특히 V-3 두께/무게 PASS·V-4 essential PASS 재분류·**V-10 editor_yn+file_upload_yn 2-불리언 환원 한계 증명**·**V-11 신규 테이블 mint 정당성[1:N·이중의미]**·**V-12 형상 siz 흡수 불가 1:多 증명·junction 재사용이 테이블 mint 거부 정당한지**·9건 "그릇 불요" 정당성) ② V-1 영향분석이 라이브 469행 반영했는지(기존 제안 0행 stale 교정) ③ 컨벤션 정합(코드 cod_cd 형식·jsonb 관용·FK·**reg_dt NOT NULL DEFAULT 트랩**·**use_yn DEFAULT 부재→명시**) ④ 정규화(무손실·무중복·함수종속·**V-10 editor_yn↔channel 파생 중복 아님**·**V-12 ②a상품/②b junction shape_cd 이중 함수종속 무중복·siz_sizes 마스터 아닌 junction에 매는 이행종속 회피 검증**) ⑤ **신규 테이블 mint 2(V-11)의 적정성** + 나머지 mint 0 적정성(특히 **V-12 1:多인데 junction 선재→컬럼 정당·과소설계 아닌지**) ⑥ **V-10 위젯 정규화 계약 정합** ⑦ **V-12 dbmap round-3 siz_cd 흡수 권고 정정이 충돌 아닌 정밀화인지**(1:多 증거 타당성·G-SK-2 진단 보존).
- **DRY-RUN 증거:** V-10/V-11/**V-12** 3 DDL = 라이브 BEGIN..ROLLBACK 실증. V-12: 코드행 6 INSERT + ALTER ×2 + FK ×2 + 백필 smoke(UPDATE 1) 일치·**post-rollback 0 leaked**(SHAPE 코드 0·shape_cd 컬럼 0 확인). 구문 유효성·FK 무결성·롤백 무위험 확인됨.
- **NEVER:** 라이브 CREATE/ALTER/COMMIT. M-gate FAIL 시 해당 vessel만 수정·재산출.
- **DDL 위임:** 정밀 SQL = dbm-ddl-proposer(`ref-param-json-proposal.sql`·`ddl-proposal-goods-pouch-nondim-size.sql` 패턴 재사용). TP 산출 = `ddl-proposal-design-input-channel.sql`·`ddl-proposal-template-asset.sql`. **ST 산출 = `ddl-proposal-shape-axis.sql`**(11_ddl_proposals/·design-input-channel 패턴 동형). 본 하네스는 *which vessel & why* + 라이브 영향 갱신 + DRY-RUN 유효성.
