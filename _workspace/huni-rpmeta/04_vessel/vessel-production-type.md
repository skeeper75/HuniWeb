# vessel-production-type (V-9, #15 생산형태 governing) — WEAK 🟡 → 그릇 설계

> rpm-vessel-designer. RP `ProductionType`(prd_typ governing body_model + set_structure, 카테고리와 직교)를 후니가 표현할 그릇.
> 권위 = 라이브 read-only 실측(2026-06-17·본 세션 직접 측정). design ≠ apply.
> **버전:** v2.0 (GS 신축).

## 0. 한 줄 평결
**갭분석 WEAK은 정확하나, GS 라이브 재측은 *vessel-gap이 거의 없음*을 보인다 — 결손의 90%는 data(값 오모델), vessel은 사실상 0.** 실측: ① `PRD_TYPE` enum 5종 실재(PASS) ② **`semi_role_cd`(SEMI_ROLE 내지/표지/면지/간지/투명커버) 컬럼 실재 = RP `set_structure`(B 셋트 구조) 그릇 이미 있음(PASS·28행 적재)** ③ body_model(A=자재행 vs C=완제SKU) governing은 **새 컬럼이 아니라 prd_typ_cd 값 교정 + 본체 모델링 분기(자재행 vs template)를 앱/제약이 prd_typ_cd로 읽으면 됨** = data 교정(round-15). → **신규 그릇 0 권고**(search-before-mint상 PASS 재분류). 정 governing을 명시 컬럼으로 박제하려면 그것이 over-modeling인지 designer 판정.

## 1. search-before-mint (라이브 실측 — 결정적)
| RP ProductionType 요구 | 후니 기존 그릇(라이브) | 무손실 가능? |
|---|---|:--:|
| prd_typ(완제품/반제품/기성/디자인) | `t_cod_base_codes` PRD_TYPE .01~.05 + `t_prd_products.prd_typ_cd` | ✅ enum+상품당1값 실재(분포 .01=8·.02=28·.03=124·.04=115·.05=0) |
| **set_structure**(B 셋트=표지/면지 sub_prd) | **`t_prd_products.semi_role_cd`(SEMI_ROLE .01내지/.02표지/.03면지/.04간지/.05투명커버)** + 반제품 28행 | ✅ **그릇 실재**(반제품 역할 분류·내지3/표지10/면지15 적재) |
| 카테고리 ⊥ 생산형태 직교 | `t_cat_categories`(트리) ∥ `prd_typ_cd`(별 컬럼) = **구조적으로 이미 직교**(한 상품이 카테고리 다중소속 + prd_typ_cd 1값 독립) | ✅ 직교 구조 보유 |
| **body_model**(A·B=자재행 / C=완제SKU 분기) | △ — prd_typ_cd 값으로 *해석 가능*하나 현재 굿즈 전부 .03(기성)이라 본체=자재행 vs 완제SKU 분기를 **값이 안 가름**(오모델) | ❌(값) / 그릇은 prd_typ_cd로 충분 |

**실측 핵심:** body_model이 별 그릇이 필요한가? — **아니다.** RP의 body_model(A 통합=본체가 자재행 / C 완제=본체가 template SKU)은 **prd_typ_cd 값 + 본체 그릇 존재 여부**로 *유도*된다: prd_typ_cd가 완제품(.01)이면 본체=`t_prd_templates`/`template_prices`(완제 SKU), 반제품/기성이면 본체=`t_prd_product_materials`(자재행). 즉 후니는 이미 두 본체 그릇(materials·templates)을 보유하고, prd_typ_cd가 어느 쪽을 쓰는지 governing할 *값*만 맞으면 된다. **굿즈가 전부 .03인 것은 값 오모델(data·round-15)**이지 그릇 부재 아님.

**갭분석 "governing 미표현 WEAK"의 정확한 분해:**
- (a) prd_typ_cd가 body_model을 governing 안 함 → **값 오모델**(텀블러/코스터가 .03인데 RP로는 C 완제품·노트는 A/B). 교정=data(round-15 치환표). **vessel 아님.**
- (b) set_structure 직교 미표현 → **이미 그릇 있음**(semi_role_cd). **PASS.**
- (c) 직교성 → **구조적으로 이미 직교**(카테고리·prd_typ_cd 독립 컬럼). **PASS.**

## 2. 그릇 설계 — **신규 그릇 0 (PASS 재분류 권고)**
search-before-mint 결과 후니 표현력이 RP governing을 **기존 그릇으로 무손실 도달**:
- prd_typ = `prd_typ_cd`(PASS)
- set_structure = `semi_role_cd`(PASS·실재)
- 직교 = 독립 컬럼 구조(PASS)
- body_model = prd_typ_cd 값 + materials/templates 그릇 유무로 유도(그릇 PASS·값 교정은 data)

→ **신규 코드행·컬럼·테이블 0.** #15 WEAK의 잔여는 **전부 data 교정(round-15 prd_typ_cd 값 정정)** + 가격 트랙(완제 SKU개당가=template_prices 적재). 본 vessel은 "그릇 불요 — prd_typ_cd + semi_role_cd 사용"으로 종결.

### 2.x (조건부) governing 명시가 정말 필요하다면
후니가 "prd_typ_cd → 본체 그릇(materials vs template) 분기"를 앱 로직이 아닌 *DB 메타로 박제*해야 한다면(드묾), 사다리 최저단 = `t_cod_base_codes` PRD_TYPE 코드행에 **본체모델 힌트를 코드 의미로 부여**(예: PRD_TYPE.01 완제품=template body / .02·.03=material body) — 별 컬럼 mint 없이 코드 해석 규약으로. **단 이는 앱 규칙으로 충분하므로 over-modeling 경계 — designer 비권장.**

## 3. 정규화 / 영향
- **무손실:** prd_typ_cd·semi_role_cd·카테고리 트리 각 정규 슬롯 보유 → governing 4요소 분리 표현 가능(그릇 기준).
- **무중복:** body_model을 별 컬럼으로 추가하면 prd_typ_cd와 의미 이중화(prd_typ→body_model 함수종속) → **추가 = 이행종속 신설 위험** = 정규화상 추가 안 하는 것이 옳음. ★이것이 신규 그릇 0의 정규화 근거.
- **영향:** 신규 DDL 0 → 라이브 영향 0. 잔여는 data 교정(round-15).
- **롤백:** 해당 없음(그릇 변경 없음).
- **load-bearing:** prd_typ_cd 값 교정(.03→올바른 형태)은 본체 모델링(materials vs template)·가격 분기를 governing하므로 **data 교정 시 본체 그릇 정합 확인 필수**(round-15 치환표 권위) — 단 이는 dbmap 트랙.

## 4. WEAK → 판정
- #15 생산형태: gap-matrix **WEAK** → **vessel은 PASS(그릇 충분), 잔여는 data**. governing 결손은 prd_typ_cd 값 오모델(data·round-15)과 가격 적재(template_prices·data)로 닫힘. **신규 그릇 불요 — 기존 prd_typ_cd + semi_role_cd 사용.**

## 5. DDL 참조
- 해당 없음(신규 DDL 0). 값 교정 SQL = dbmap round-15(`dbmap-grid-binding-round15` 치환표) — vessel 트랙 밖.

## 6. open decision (날조 금지)
1. **governing 명시 컬럼 신설 여부:** 권고=불요(앱 규칙·정규화상 이행종속 회피). 후니가 DB 메타 박제를 directive로 요구할 때만 PRD_TYPE 코드 의미 규약(컬럼 mint 없이)으로 — designer 비권장.
2. **prd_typ_cd 값 교정 범위**(굿즈 .03→완제품/셋트 분류): round-15 치환표 권위·data 트랙. **vessel 선행 불요**(그릇 이미 있음) → dbmap 즉시 가능.
3. **PRD_TYPE.05 추가상품(0행):** 미사용 코드 — 폐기 vs 보존은 dbmap 정합 판정.
4. 실 적용(값 교정) = 인간 승인(dbmap).
