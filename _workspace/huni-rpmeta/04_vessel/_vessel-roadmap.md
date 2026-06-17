# 후니 기초데이터 관리 그릇 정비 로드맵 (_vessel-roadmap)

> rpm-vessel-designer. `04_vessel/vessel-*.md` 전 그릇을 leverage + FK/마이그 의존 순으로 정렬 + 후니 base-data 관리 정비 계획.
> 권위 = 라이브 read-only 실측(2026-06-17·gap-matrix와 동일 세션). [HARD] design ≠ apply — 전 항목 인간 승인. 라이브 CREATE/ALTER/COMMIT 0.
>
> **── 버전 ──**
> - **v1.0 (BN):** §0 8축 인벤토리·§1 Wave·§2·§3. **보존(아래 v1.0 표는 그대로, v2.0 행 추가).**
> - **v2.0 (GS·2026-06-17):** + V-3 굿즈 확장(§7 in vessel-material-axis)·**V-8 형태가공**·**V-9 생산형태**·**MAT_TYPE 오라벨 교정**. GS 라이브 재측이 #14·#15를 BN 추정보다 *덜 vessel-gap*으로 확증(형태가공=분류축 1개·생산형태=신규 그릇 0). 인벤토리·Wave·정비권고에 GS 행만 추가, v1.0 무수정.
> - **v3.0 (TP·2026-06-17):** + **V-10 디자인 입력 채널(#16 GAP·★directive 1순위)** = base_code 그룹 3 + 상품 컬럼 4(신규 테이블 0) + **V-11 TemplateAsset 분리(T-A WEAK)** = 신규 테이블 2(본 하네스 **유일 mint**·이중의미 분리). TP 나머지 facet(VDP·페이지계층·형태variant·특수인쇄) = 기존 흡수(신규 0). 라이브 DRY-RUN(BEGIN..ROLLBACK)으로 양 DDL 유효성 실증·0 leaked. v1.0/v2.0 무수정.
> - **v4.0 (PR·2026-06-17): PR 카테고리 = 신규 그릇 0건.** PR(인쇄물·책자·리플렛·포스터) distinct 신축 0(facet 강화 9건뿐) → search-before-mint 통과·기존 V-항목 충분. PR facet 6항(PASS 4: 표지/내지·접지/제본·page_rule·면지 / WEAK 1 / GAP 1) 중 조치 대상 2건은 기존 그릇에 facet 흡수: **P-7(인쇄방식 자재풀 게이팅) → V-2**(`vessel-print-method-recipe §7`·경로 A 제약흡수가 자재 부분집합도 담음·신규 0)·**P-6(digital_price 라우팅) → V-7**(`vessel-quantity-size-pricing §C4`·frm_typ_cd 결손 동일·가격 트랙 round-16/17 위임). **16축 포화의 vessel-side 검증** — 4번째 카테고리가 새 그릇을 요구하지 않음. 신규 테이블/컬럼/DDL/V-번호 0·인벤토리·Wave·정비권고 무수정.

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

### v2.0 (GS) — 4 (V-3 확장 포함)
| 축 | gap 판정 | vessel 결과 | 사다리 | 신규 그릇 |
|---|---|---|---|---|
| **V-3 굿즈 분해축** (#1 GS·§7) | WEAK 🟡 | `MAT_FACET.03 용량` 코드 1 (+조건부 `capacity` 컬럼) — 색=CPQ option 위임·소재/두께/무게=기존 컬럼·brand=note | 1 코드행(+조건부 컬럼) | 코드 1 |
| **V-8 본체 형태가공** (#14) | GAP ❌→부분PASS | `PROC_CLASS` 코드 5 + `proc_class_cd` 컬럼 1 (파라미터=prcs_dtl_opt+ref_param_json PASS·지퍼/조립 행=data) | 1 코드행 + 1 컬럼 | 코드 5 + 컬럼 1 |
| **V-9 생산형태 governing** (#15) | WEAK 🟡→PASS | **신규 그릇 0** — prd_typ_cd + `semi_role_cd`(set_structure 실재)로 PASS·잔여는 값 교정(data round-15) | — | 0 (PASS 재분류) |
| **MAT_TYPE 오라벨 교정** | vessel-level 분류축 결함 | `.09/.10 use_yn='N'`(행 선이동 후)·신소재 .05 흡수 — 신규 0 | 코드 use_yn(행 의존) | 0 (★open decision·B-3 강결합) |

### 카운트 (v1.0 + v2.0 + v3.0 통합)
- **설계한 실 그릇(DDL/코드행 필요): 7** — V-1(JSONB 컬럼)·V-3(BN facet 코드 2 + GS 용량 코드 1)·V-4(코드행 2)·**V-8(PROC_CLASS 코드 5 + proc_class_cd 컬럼 1)**·**V-10(코드그룹 3 + 상품 컬럼 4)**·**V-11(신규 테이블 2)**. (+조건부: V-3 capacity 컬럼).
- **"신규 그릇 불요" 재분류: 8** — V-2·#4·V-5·V-6·V-7 + **V-9(prd_typ_cd+semi_role_cd PASS)** + MAT_TYPE(신규 0·use_yn만) + **TP facet(VDP본문보류·페이지/형태/특수인쇄 기존 흡수)**. + essential(V-4 내부 PASS).
- **신규 테이블 mint = 2건**(V-11 TemplateAsset 마스터+링크 — **본 하네스 전체 유일**). BN/GS·V-10 채널·**PR 전부 0**(코드행/컬럼/흡수). ★TP 핵심 교훈: **사다리는 축의 카디널리티가 결정** — V-10 채널=상품 1:1 → 컬럼에서 멈춤(테이블 거부), V-11 시안=상품 1:N·독립 lifecycle·완제SKU 이중의미 → 테이블만 무손실(mint 정당). over-modeling도 under-modeling도 아닌 *정확한 사다리*. GS 교훈(라이브 재측이 갭 완화)에 더해 TP는 *이중의미 분리가 테이블 mint를 정당화하는 유일 경우*임을 보임.
- **★PR 교훈(v4.0): 4번째 카테고리가 신규 그릇 0건** — PR facet 9건이 전부 기존 16축의 facet/family/cascade로 흡수(P-7→V-2 자재풀 게이팅·P-6→V-7 digital_price 라우팅·PASS 4건 그릇 보유). 이는 search-before-mint의 *정직한 양성 결과* = 후니 기존 그릇 + V-1~V-11 설계가 인쇄물·책자 도메인까지 무손실 표현. **16축 포화(saturation)의 vessel-side 증거**: 메타모델 축 신설 0건이 그릇 신설 0건으로 일관 확인.

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

## 3. rpm-validator(M-gate) 인계
- **검증 요청:** ① search-before-mint 누락 없는지(특히 V-3 두께/무게 PASS·V-4 essential PASS 재분류·**V-10 editor_yn+file_upload_yn 2-불리언 환원 한계 증명**·**V-11 신규 테이블 mint 정당성[1:N·이중의미]**·8건 "그릇 불요" 정당성) ② V-1 영향분석이 라이브 469행 반영했는지(기존 제안 0행 stale 교정) ③ 컨벤션 정합(코드 cod_cd 형식·jsonb 관용·FK·**reg_dt NOT NULL DEFAULT 트랩**) ④ 정규화(무손실·무중복·함수종속·**V-10 editor_yn↔channel 파생 중복 아님 검증**) ⑤ **신규 테이블 mint 2(V-11)의 적정성**(over-modeling 아닌지·완제SKU 컬럼 흡수가 진짜 불가한지) + 나머지 mint 0 적정성(과소설계 아닌지) ⑥ **V-10 위젯 정규화 계약 정합**(그릇=어댑터 슬롯·DB⊥계약 직교 주장 타당성).
- **DRY-RUN 증거:** V-10/V-11 양 DDL = 라이브 BEGIN..ROLLBACK 실증(ALTER ×4+FK ×3+백필 UPDATE 3행 일치·CREATE ×2+FK·0 leaked). 구문 유효성·FK 무결성·롤백 무위험 확인됨.
- **NEVER:** 라이브 CREATE/ALTER/COMMIT. M-gate FAIL 시 해당 vessel만 수정·재산출.
- **DDL 위임:** 정밀 SQL = dbm-ddl-proposer(`ref-param-json-proposal.sql`·`ddl-proposal-goods-pouch-nondim-size.sql` 패턴 재사용). TP 산출 = `ddl-proposal-design-input-channel.sql`·`ddl-proposal-template-asset.sql`(11_ddl_proposals/). 본 하네스는 *which vessel & why* + 라이브 영향 갱신 + DRY-RUN 유효성.
