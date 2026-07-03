# 큐레이션 팩 — 아크릴 굿즈 (acrylic)

> **작성:** okb-source-curator · 2026-07-04 (첫 작성 — 이전 아크릴 팩 없음)
> **대상 = 아크릴 굿즈 상품군**(순번6·마지막 상품군·별도 팩) — prd_cd 범위 `PRD_000146`~`PRD_000171` + `PRD_000226`.
>   **라이브 실측 확정 노드 25개**(활성 18 + 미출시 7). 167 부재(DB에 상품 자체 없음)·171 지비츠★ `del_yn=Y`(미생성).
> **목적:** 지식 구축가(okb-knowledge-builder)가 아크릴을 온톨로지에 넣을 때, **축(axis)마다 어느 파일·절이 정답 소스이고,
>   무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를 못박는다. 
>   ★이 상품군의 최대 특징 = **① 면적매트릭스 아키타입(silsa 동형)이 지배 · ② 미출시 7·TBD 5(단가행 0) 대량 → 양면·GAP 정직 표기 · ③ 병행 dbmap 세션이 07-03/04 라이브 적재 → live-snapshot 20260702 노후(H-1) → 신규 라이브 SELECT 재프라이싱 필수**.
> **선행 입력(정독 완료):** 같은 폴더 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·`pack-silsa.md`(면적매트릭스 아키타입 형식 계승)·`pack-stationery-goods.md`(단품·양면·GAP 형식 계승) · `02_ontology/{ontology-schema.md,graph-build-spec.md}`(gap 슬러그 규약: gap-goods-fixed-lookup-no-formula·gap-goods-neither) · `_workspace/print-kb/wiki/recipes/acrylic.md`(REVERIFY 대조·AC-ID/DIM/BOM/PRC/CPQ/DEF 블록) · live 신규 SELECT(§0.2 캐시).

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조), `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **수치 손전사 금지[HARD]:** 아래 표의 모든 숫자·상태값은 결정론 psql 전사(transcribed-by)다. 캐시=§0.2. **엑셀 원본 반복 Read 금지.**
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만. **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다.

### 0.1 ★Universe 판정 (라이브 실측 확정)

> {전부 transcribed-by `psql t_prd_products` → `_cache/acryl-universe-260704.csv`}

- **범위:** `PRD_000146`~`PRD_000171` + `PRD_000226`. 실재 확인 = **26상품**(146~166 연속 + 168·169·170·171 + 226). **167은 DB에 존재하지 않음**(범위 내 결번 — 제외 명시).
- **노드 생성 대상 = 25개:**
  - **활성(use_yn=Y·del_yn=N) 18:** 146 키링·147 마그넷·148 뱃지·149 집게·150 스마트톡·151 맥세이프스마트톡·152 명찰·153 명찰(골드실버)·154 머리끈·155 볼펜·156 지비츠·157 네임택·158 포카키링·160 자유형스탠드·161 판아크릴·162 포카스탠드·163 미니파츠·166 카라비너.
  - **미출시(use_yn=N·del_yn=N) 7 → 정직 미출시 라벨(노드 생성·팬텀 금지):** 159 코스터·164 코롯토·165 포카코롯토·168 입체코롯토·169 입체블럭·170 쉐이커★·226 쉐이커코롯토.
- **del_yn=Y → 노드 미생성(정상 은퇴):** **171 지비츠★**(중복 은퇴판·현행 지비츠=156). 상품 노드 만들지 말 것.
- **제외(범위 내이나 아크릴 아님/타 팩):** 142 유광·143 미러 아크릴스티커=**스티커 그룹**(pack-sticker 기구축, 범위 밖). 223 말랑포카홀더=PVC(아크릴 아님·goods 팩). — 이들은 본 팩 대상 아님.

### 0.2 라이브 가격 캐시 (★H-1 회피 — snapshot 금지·신규 SELECT)

> ★[HARD] live-snapshot `snap_20260702_1119`은 **아크릴 가격 정본으로 쓰지 말 것** — 병행 dbmap 세션이 07-03/04 아크릴 가격을 라이브 적재(146 addon 볼체인·부속 등 reg_dt 2026-07-03 실측). 아래 캐시는 **2026-07-04 신규 라이브 SELECT** 결과다.

| 캐시 파일(`01_curation/_cache/`) | 내용 | tier/freshness |
|--------------------------------|------|----------------|
| `acryl-universe-260704.csv` | 26상품 prd_typ·use_yn·del_yn·min/max/incr·editor·nonspec | A · FRESH(07-04) |
| `acryl-price-chain-260704.csv` | **★핵심** — 상품→공식→구성요소→단가행수·min/max가·use_dims (29행) | A · FRESH |
| `acryl-prod-formulas-260704.csv` | 상품↔가격공식 바인딩 26행 + note(TBD 시그널) | A · FRESH |
| `acryl-materials-named-260704.csv` | 자재 39행(mat_nm·mat_typ_cd·usage_cd·dflt_yn) | A · FRESH |
| `acryl-processes-named-260704.csv` | 공정 19행(proc_nm·mand_yn) | A · FRESH |
| `acryl-addon-templates-260704.csv` | addon 템플릿 17종 + 단가(볼체인 1000·자석 800~1700 등) | A · FRESH |
| `acryl-optgroups-260704.csv` | CPQ 옵션그룹 12행 | A · FRESH |
| `acryl-product-summary-260704.csv` | 상품별 공식·자재수·공정수·사이즈수·판형수·옵션수·addon수 종합 | A · FRESH |
| `acryl-prod-prices-260704.csv` | **t_prd_product_prices = 0행**(★아크릴은 직접단가룩업 미사용·전량 공식기반) | A · FRESH |

> **재프라이싱이 또 필요하면** 위 psql 패턴 재실행(`.env.local RAILWAY_DB_*` 읽기전용). 값은 캐시에서만 인용.

**★이 상품군의 5대 특성(다른 상품군과 다른 점):**
1. **면적매트릭스가 지배 아키타입(silsa 동형).** 컬러 아크릴 본체 = `COMP_ACRYL_CLEAR3T` 단일 구성요소(use_dims=`[mat_cd,siz_width,siz_height,min_qty]`·**277 단가행**·2,000~32,700원)를 13상품이 **공유**. silsa 포스터사인 면적매트릭스와 동형(`[가로×세로]` off-grid ceiling). {transcribed-by `acryl-price-chain-260704.csv`}
2. **★t_prd_product_prices(직접단가룩업) = 0행 — 아크릴은 gap-goods-fixed-lookup 아키타입이 아니다.** 굿즈 팩의 "고정가룩업"(직접 unit_price)과 달리 아크릴 "고정가형"도 **가격공식 기반**(`COMP_*` use_dims=`[siz_cd,min_qty]`·component_prices). builder는 아크릴에 `gap-goods-fixed-lookup-no-formula` 슬러그를 붙이지 말 것(§3.10·T-7).
3. **미출시 7·TBD 5(단가행 0) 대량 → 양면·GAP 정직 표기가 주 임무.** 165/168/169/170 = `PRF_ACRYL_*_TBD` + `COMP_ACRYL_PENDING_TBD` **0 단가행**(견적 원천 부재). 163 미니파츠 = 단가행 1개이나 placeholder 10,000원(TBD). 226 = §23 재바인딩본·미출시. → `gap-acryl-tbd-formula-no-priced-rows`.
4. **비종이류지만 판형(plate_sizes) 51행 실재 → 양면 주의.** 면적매트릭스 공식(`COMP_ACRYL_CLEAR3T`)은 `plt_siz_cd`를 **미참조**(use_dims에 없음) → 판형은 가격축 아님(생산 임포지션 메타/오적재 의심). "판형 있으니 종이류처럼 fn_calc_pansu" 금지(§3.8).
5. **substrate = 아크릴 투명 두께변형(1.5/3/8mm) — 색상값이 아님.** 면적매트릭스 `mat_cd` 차원 = `MAT_000042`(1.5mm)·`MAT_000043`(3mm)·`MAT_000044`(8mm) = **두께**. 부속(고리·자석·핀·바디·헤어끈·볼체인)은 substrate 아님 = `has_addon`/부자재(MAT_TYPE.07). 화이트/투명 바디(스마트톡)도 부속이지 substrate 아님(§3.5·T-8).

---

## 1. 아크릴 정답 소스 요약 (한 눈에)

| 계열 | 경로 | tier | freshness | 역할 |
|------|------|------|-----------|------|
| **라이브 가격 사슬(신규 SELECT)** | `01_curation/_cache/acryl-*-260704.csv`(§0.2) | A | **FRESH(07-04)** | ★아크릴 가격·자재·공정·옵션의 유일 신뢰 실측(snapshot 대체) |
| **가격엔진 코드(단일 권위)** | `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price) | A | FRESH | 면적매트릭스 off-grid ceiling·구성요소 합산 알고리즘 권위 |
| **면적매트릭스 적재 동형 권위** | `_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md` + `09_load/_migrate_areamatrix/` | C/A | FRESH(면적모델) | 아크릴 면적매트릭스 = 실사 동형(siz 신규등록+component_prices long-form) |
| **아크릴 전용 dbmap 산출** | `huni-dbmap/31_acrylic-price-link/acrylic-chain-design.md`·`33_silsa-price-quote/acrylic-*`·`09_load/{acrylic,B-acrylic-accessory-260703}` | C | **PARTIAL-STALE** | 가격사슬 설계·부속 적재. 단가값은 07-04 캐시로 재확인(6월 산출 낡음) |
| **도메인 규칙 12항 정본(SOT)** | `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md` | B | FRESH | 종이류만 판형·차원형vs수량단가·시뮬레이터 입증 |
| **인쇄도메인 지식(아크릴 도수변환)** | `docs/kb/01_인쇄도메인_지식체계.md` | B | FRESH | 아크릴 도수변환(양면9도/단면7도 통용단가)·UV 평판인쇄 개념 |
| 위키 레시피 | `_workspace/print-kb/wiki/recipes/acrylic.md`(전체 🟡·AC-* 블록) | C | **PARTIAL-STALE~REVERIFY** | REVERIFY 대조용 — 상품수(23)·PROC 코드·미러×2는 라이브 재측정 |
| 260702 델타 diff | `huni-dbmap/26_change-tracking-260702/` | A | FRESH | ★아크릴 상품/가격은 diff 65행에 없음 = 260702 변경 무영향(구 L1=260702값) |
| live-snapshot(현재상태·**가격 제외**) | `_foundation/live-snapshot/latest`(snap_20260702_1119) | A(현재값) | **STALE(아크릴 가격축)**·FRESH(구조축) | ★가격은 §0.2 신규 SELECT로. 스냅샷은 구조/비가격 확인만 |

### 1.1 ★가격모델 분류 (핵심 산출 — 상품별 라이브 판정)

> {전부 transcribed-by `acryl-price-chain-260704.csv`·`acryl-prod-formulas-260704.csv`} — **4모델 + gap**. ★어느 상품도 `t_prd_product_prices`(직접단가룩업) 미사용.

| 모델 | 공식(frm_cd) | 구성요소·use_dims | 단가행/가격범위 | 상품(prd_cd) |
|------|-------------|-------------------|-----------------|--------------|
| **M1 면적매트릭스(본체)** | `PRF_CLR_ACRYL` | `COMP_ACRYL_CLEAR3T` · `[mat_cd,siz_width,siz_height,min_qty]` | 277행·2,000~32,700 | 148·150·151·152·157·158·159(미출시)·161·162 |
| **M2 면적매트릭스+부속선택** | `PRF_ACRYL_{MAGNET,CLIP,HAIRBAND}` | `COMP_ACRYL_CLEAR3T`(면적) **+** `COMP_ACRYL_{MAGNET,CLIP,BLACK_HAIR_BAND}`(부속·`[opt_cd,min_qty,opt_grp:*]`·PRICE_TYPE.01) | 본체277 + 부속1행(800/700/500) | 147·149·154 |
| **M2b 면적매트릭스+addon템플릿** | `PRF_CLR_ACRYL` | `COMP_ACRYL_CLEAR3T` + **addon 템플릿**(t_prd_product_addons·볼체인 8종) | 본체277 + 볼체인 1,000/개 | 146(볼체인 8 addon) |
| **M3 고정가형 by-siz 공식** | `PRF_ACRYL_{NAMETAG_GS,BALLPEN,FREESTAND,CARABINER}` · `PRF_GOODS_FIXED_SIZ` | `COMP_*` · `[siz_cd,min_qty]` (or `[siz_cd]`) | 153:3행(3,400~4,700)·155:3행(1,800~2,700)·160:5행(8,800~22,600)·166:4행(5,800~6,900)·226:공유77행 | 153·155·160·166·226(미출시) |
| **M4 부속선택 공식(zibitz/미니파츠)** | `PRF_ZIBITZ_ACRYL`·`PRF_ACRYL_MINIPART` | `COMP_ACRYL_ZIBITZ`(`[opt_cd,min_qty,opt_grp:OPT_000083]`)·`COMP_ACRYL_MINIPART_TBD`(`[siz_cd,min_qty]`) | 156:2행(200~600)·163:1행 placeholder 10,000(TBD) | 156·163 |
| **M5 코롯토 면적공식** | `PRF_COROTTO_ACRYL` | `COMP_ACRYL_COROTTO` · `[siz_width,siz_height]` | 36행·3,600~8,400 | 164(미출시) |
| **★GAP TBD(단가행 0)** | `PRF_ACRYL_{PHCOROTTO,3DCOROTTO,3DBLOCK,SHAKER}_TBD` | `COMP_ACRYL_PENDING_TBD` · `[min_qty]` | **0행**(견적 원천 부재) | 165·168·169·170 (전부 미출시) |

> **★가격모델 요지(builder 채택):**
> - **M1/M2/M2b/M5 = `references 아크릴 면적매트릭스`**(priced_by 공식·`COMP_ACRYL_CLEAR3T`/`COMP_ACRYL_COROTTO`·use_dims 차원 선언까지만·값 계산=엔진 권위). silsa 면적매트릭스와 동형([[recipes/acrylic#AC-PRC-002]]).
> - **M3/M4 = priced_by 고정가형 공식**(component_prices `[siz_cd,min_qty]`·직접단가룩업 아님). ★`gap-goods-fixed-lookup-no-formula` 붙이지 말 것.
> - **M2/M2b 부속 = `has_addon`(R14)** — 본체 면적가 + 부속 별도합산([[goods-variant-formula-fixed-price-model-260704]] "본체 공식 + 부자재 별도합산" 모델 정합).
> - **GAP TBD = `gap-acryl-tbd-formula-no-priced-rows`**(공식 바인딩됨·단가행 0 = 견적 불가). 163은 placeholder 단가(10,000)로 "TBD 가격" 양면.

---

## 2. STALE 함정 목록 (아크릴 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **아크릴 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | **과업/구 문서의 "146 키링=480,000·151 맥세이프=590,000·부속 마그넷/집게/머리끈 330/380/300k"** | ★라이브 실측 불일치 — 면적매트릭스 최대 32,700·부속 800/700/500·볼체인 1,000. 저 대형 숫자는 **어디에도 없음**(구 readiness-master 06-26 or 노후 스냅샷 추정) | §0.2 `acryl-price-chain`·`acryl-addon-templates` 신규 SELECT |
| T-2 | **live-snapshot `snap_20260702_1119`을 아크릴 가격 정본으로 인용** | 병행 dbmap 세션이 07-03/04 아크릴 가격 라이브 적재(146 addon reg_dt 07-03 실측)→스냅샷 노후(H-1) | §0.2 07-04 신규 라이브 SELECT |
| T-3 | 위키 `recipes/acrylic.md` **"완칼=PROC_000053"·"UV=PROC_000002 단일"** | 라이브 146 = `PROC_000111 UV평판인쇄`+`PROC_000124 레이저커팅`+`PROC_000151 굿즈가공`(6월 이후 공정 세분화). 대부분 상품은 `PROC_000002 UV`뿐 | `acryl-processes-named-260704.csv` 실측 |
| T-4 | 위키 **"아크릴 23등록(단품14+조합9)"** 상품수 | 라이브 = 26상품(활성18+미출시7+del1)·노드 25 | `acryl-universe-260704.csv` |
| T-5 | 위키 **"미러=투명×2"** 를 본 팩 상품에 적용 | 아크릴 굿즈 universe(146~171·226)에 **미러 상품 없음** — 미러/유광 아크릴스티커(142/143)는 스티커 팩 소속 | 본 universe에 미러 노드 미생성(§0.1) |
| T-6 | `price-engine-ddl.md`·`prcx01-pricing-model`(좌표 회귀·8차원·frm_typ_cd) | 구설계·좌표 회귀 — 후니 권위=매트릭스 룩업. 위키 상단도 STALE 마킹 | pricing.py + live `t_prc_*` + mapping.md §1.2 |
| T-7 | 아크릴에 **`t_prd_product_prices` 직접단가룩업(gap-goods-fixed-lookup) 아키타입** 적용 | 아크릴 `t_prd_product_prices`=**0행**·전량 공식기반(M1~M5) | `acryl-prod-prices-260704.csv`(0행) + `acryl-price-chain` |
| T-8 | **색상값(투명/화이트/블랙)을 substrate 자재로** 모델 | substrate=아크릴 투명 두께(1.5/3/8mm·MAT_TYPE.03/.20). 화이트/투명 바디·고리·자석=부속(MAT_TYPE.07·dflt_yn=N) | `acryl-materials-named-260704.csv`(dflt_yn·mat_typ_cd) |
| T-9 | 아크릴에 **판형(fn_calc_pansu·t_siz_pansu) 종이류 로직** 이식 | 비종이·UV 평판. plate_sizes 51행 실재하나 면적공식 미참조(생산메타/오적재 의심) | `HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형) + `acryl-price-chain`(use_dims에 plt_siz_cd 없음) |
| T-10 | 171 지비츠★를 **판매 상품 노드로** | `del_yn=Y`(은퇴·중복판)·현행 지비츠=156 | `acryl-universe-260704.csv`(del_yn=Y) |
| T-11 | 165/168/169/170 TBD를 **"가격 있는 상품"으로** | `COMP_ACRYL_PENDING_TBD` 0 단가행·전부 미출시 = 견적 불가 | `acryl-price-chain`(price_rows=0) |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP) — 12축

> 이 상품군은 특히 **§3.10 가격공식(면적매트릭스+고정가형+TBD 분기)·§3.5 자재(substrate 두께 vs 부속)·§3.8 판형(비종이 양면)·§3.12 addon(부속선택)** 축이 중점.

### 3.1 정체(identity)

- **정답 소스:** live `acryl-universe-260704.csv`(prd_typ_cd·use_yn·del_yn) + `_foundation/product-type-classification-sot.md`. {tier A/B · FRESH}
- **핵심 사실:** 전 25노드 = `PRD_TYPE.01` 완제품(단품·has_member 없음). 카테고리 = 라이브 혼재(단품형 CAT_000322·조합형 CAT_000155·코롯토 CAT_000159·아크릴 CAT_000009 등) — 위키 "카테고리 009 단일"은 REVERIFY. **미출시 7**(159/164/165/168/169/170/226)·**del 1**(171). {transcribed-by `acryl-universe`·카테고리 SELECT}
- **위키 REVERIFY 대조:** `[AC-ID-001]`(UV 평판인쇄 굿즈·단품)·`[AC-ID-002]`(23등록) → 개념 INHERIT·**상품수·카테고리 live 재측정**(REVERIFY).
- **STALE 함정:** T-4·T-5·T-10.
- **GAP:** 카테고리 leaf 귀속 정밀도(혼재 8종) — 현재값 라벨.

### 3.2 차원 — 사이즈(size)

- **정답 소스:** live `t_prd_product_sizes.csv`·`t_siz_sizes.csv`(상품별) + 면적매트릭스 `mapping.md`(silsa 동형). {tier A/C · FRESH}
- **핵심 사실:** 아크릴 사이즈 = **① 면적 [가로×세로] 연속(nonspec_yn=Y 다수: 146/147/148/164 등)** + **② 고정 규격 SIZ(고정가형 153/155/160/166)**. 면적매트릭스는 siz_width/siz_height 20~200mm 격자(off-grid=한 단계 큰 규격 ceiling·앱 계산). 상품별 사이즈행 = `acryl-product-summary`(siz열: 146=9·158=1·170=6 등). {transcribed-by `acryl-product-summary-260704.csv`}
- **위키 REVERIFY 대조:** `[AC-DIM-001]`(두께=자재)·`[AC-DIM-002]`(형상=완칼 param)·`[AC-DIM-003]`(조각수=묶음+param) → REVERIFY.
- **STALE 함정:** T-6.
- **GAP:** 면적 siz 신규등록 잔여(mapping.md·인간 승인)·형상 param 표준화.

### 3.3 차원 — 도수(색상 수)

- **정답 소스:** `docs/kb/01_인쇄도메인_지식체계.md`(아크릴 도수변환) + live `t_prt_print_options`. {tier B/A · FRESH}
- **핵심 사실:** 아크릴 = **도수 컬럼 축이 얕음** — 면적매트릭스 단가가 "양면9도/단면7도 통용단가"로 **도수를 흡수**(단가표 헤더). clr_cd = 면적매트릭스에서 NULL(도수·자재 무관 통가격). 화이트 underbase(불투명 받침)는 도수 아닌 공정 개념(투명 소재만).
- **위키 REVERIFY 대조:** `[AC-PRC-001]`(양면9도/단면7도 통용) INHERIT.
- **STALE 함정:** T-6(도수를 clr_cd/좌표로).
- **GAP:** 투명 아크릴 화이트 underbase 공정 연결 여부 live 재측정.

### 3.4 차원 — 수량규칙(묶음·min/max/incr)

- **정답 소스:** live `acryl-universe-260704.csv`(min_qty/max_qty/qty_incr) + `_foundation/batch/qty_rule_audit_260702.py`. {tier A/C · FRESH}
- **핵심 사실:** 활성 상품 min/max/incr = **1/10000/+1 균일**(146~166·226). 미출시 4(168/169/170)는 min/max/incr **NULL**(미설정). 면적매트릭스 use_dims에 `min_qty` 포함(수량 티어) — 수량축 실재. {transcribed-by `acryl-universe`}
- **위키 REVERIFY 대조:** `[AC-DIM-003]`(묶음수·조각수) REVERIFY.
- **STALE 함정:** 없음(라이브 균일).
- **GAP:** 미출시 3(168/169/170) 수량규칙 미설정(출시 시 필요).

### 3.5 자재(materials) — ★substrate 두께 vs 부속

- **정답 소스:** live `acryl-materials-named-260704.csv`(mat_nm·mat_typ_cd·usage_cd·dflt_yn) + `t_mat_materials`. {tier A · FRESH}
- **핵심 사실(★이 상품군 특유):**
  - **substrate = 아크릴 투명 두께변형**(`dflt_yn=Y`): `MAT_000042`(1.5mm)·`MAT_000043`(3mm·최다)·`MAT_000044`(8mm·코롯토)·`MAT_000192`(투명아크릴). 153만 `MAT_000195/196 아크릴(골드/실버)`. 면적매트릭스 `mat_cd` 차원 = 두께(1.5/3mm). 
  - **부속 = `dflt_yn=N`·MAT_TYPE.07 포장부자재**: 은/금 고리·군번줄(146)·네오디움 자석(147)·원형핀/1구자석(148)·투명집게(149)·화이트/투명 바디(150)·2구자석/일자핀(152)·블랙헤어끈(154). → substrate 아님 = `has_addon`/부자재.
  - **★mat_typ 불일치(양면·현재값):** 아크릴 투명 3mm가 `MAT_TYPE.03 아크릴부자재`로 타이핑됨(substrate인데 "부자재" 유형)·153 골드실버는 `MAT_TYPE.20 아크릴`. 226 글리터는 `MAT_TYPE.09 봉제부자재`(오타이핑). 유형 라벨은 현재값으로 기록·정합은 §7 위임.
- **위키 REVERIFY 대조:** `[AC-BOM-001]`(본체+부속=parent+usage_cd·MAT_TYPE .03/.07) INHERIT(개념)·유형 라벨 REVERIFY.
- **STALE 함정:** T-8(색상=substrate). ★[HARD 사용자] 실무진 IMPORT 등록 자재 삭제 금지.
- **GAP:** **[GAP-AC-1]** substrate/부속 mat_typ 오타이핑 정정(아크릴판=.03↔.20·글리터=.09)·226 글리터 유형.

### 3.6 공정(processes) — ★UV·레이저커팅·부착

- **정답 소스:** live `acryl-processes-named-260704.csv`(proc_nm·mand_yn) + `t_proc_processes`. {tier A · FRESH}
- **핵심 사실:** 아크릴 정체 공정 = **① UV 인쇄**(`PROC_000002 UV` 다수·146만 `PROC_000111 UV평판인쇄`) + **② 레이저커팅**(`PROC_000124`·완칼 형상·146) + **③ 굿즈가공**(`PROC_000151`·146)·**④ 부착**(`PROC_000081`·mand=N·147/151 부속결합). ★**공정 0행 MISSING 10상품:** 153·154·156·159·164·165·166·168·170·226(+169는 `PROC_000083 가공` 1행). {transcribed-by `acryl-processes-named`·`acryl-product-summary`(proc열)}
- **위키 REVERIFY 대조:** `[AC-BOM-002]`(UV 단일)·`[AC-BOM-003]`(완칼 묵시필수)·`[AC-BOM-004]`(부착 2축 BUNDLE) → **REVERIFY**(PROC 코드 세분화·완칼=PROC_000124 실측·T-3).
- **STALE 함정:** T-3(완칼=PROC_000053·UV 단일 코드)·T-6.
- **GAP:** **[GAP-AC-2]** 공정 MISSING 10상품(레이저커팅/굿즈가공 미적재)·146 외 UV평판인쇄 세분 미전파.

### 3.7 인쇄옵션(print_options)

- **정답 소스:** live `t_prd_product_print_options.csv` + `t_prt_print_options`. {tier A · FRESH}
- **핵심 사실:** 인쇄방식 = UV 평판(도수는 면적단가에 흡수·§3.3). 인쇄옵션 축 얕음.
- **위키 REVERIFY 대조:** `[AC-BOM-002]` INHERIT.
- **STALE 함정:** T-6.
- **GAP:** [GAP-AC-2]와 동류.

### 3.8 판형(plate size) — ★비종이 양면

- **정답 소스:** live `acryl-product-summary-260704.csv`(plate열) + `HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형). {tier A/B · FRESH}
- **핵심 사실(★도메인 [HARD]·양면):** 아크릴 = 비종이(UV 평판) → **원칙상 판형 불필요**. 그러나 라이브에 **plate_sizes 51행 실재**(146=8·147=7·148~155=3씩·160=5·157/161=2·158/159/163=1). ★면적매트릭스 공식(`COMP_ACRYL_CLEAR3T`)의 use_dims=`[mat_cd,siz_width,siz_height,min_qty]`에 **`plt_siz_cd` 없음** → 판형은 **가격축 아님**(생산 임포지션 메타 or 오적재 의심). → **양면 표기:** `현재값: plate_sizes N행 실재` / `가격영향: 없음(공식 미참조)`·종이류 fn_calc_pansu 이식 금지. {transcribed-by `acryl-product-summary`(plate) + `acryl-price-chain`(use_dims)}
- **위키 REVERIFY 대조:** 없음(비종이).
- **STALE 함정:** T-9(종이류 판형 로직 이식).
- **GAP:** **[GAP-AC-3]** plate_sizes 51행 성격 판정(생산메타 정당 vs 오적재)·가격 미영향 확증.

### 3.9 옵션그룹/제약(CPQ·constraints)

- **정답 소스:** live `acryl-optgroups-260704.csv`·`t_prd_product_option_items.csv`·`t_prd_product_constraints.csv` + `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 shape·§31). {tier A/C · FRESH}
- **핵심 사실:**
  - **옵션그룹 12개**(SEL_TYPE.01 택1): 부속형(146 고리·147 자석·149 집게·154 헤어끈·156 가공) + 사이즈형(157/158/159/161/162 사이즈) + **226 인쇄면+글리터**(OPT_000203·OPT_000204·§23 이력 일치). option_items 실적재 = 157/158/159/161/162/226만(나머지 og는 items 0). {transcribed-by `acryl-optgroups`·oi count}
  - **★제약(constraints) = 아크릴 전 상품 0행**(146~226 constraints 미실측). {transcribed-by `t_prd_product_constraints` count=0}
  - 옵션참조(ref_dim_cd)는 같은 부모 prd_cd 실재 필수(`fn_chk_opt_item_ref`)·제약은 폼빌더 정형 shape만(§31).
- **위키 REVERIFY 대조:** `[AC-CPQ-001]`(속성→4엔티티)·`[AC-CPQ-002]` → REVERIFY(옵션 items·226 인쇄면/글리터 재측정).
- **STALE 함정:** T-6(constraint_json 삭제 컬럼).
- **GAP:** **[GAP-AC-4]** CPQ 옵션 items 미적재(og만 있고 oi 0인 상품)·제약 0행(필요 시 §31).

### 3.10 가격공식(price formula) — ★면적매트릭스+고정가형+TBD

- **정답 소스:** `pricing.py`(evaluate_price=단일 권위) + live `acryl-price-chain-260704.csv`·`acryl-prod-formulas-260704.csv` + 면적매트릭스 `mapping.md`. {tier A · FRESH}
- **핵심 사실(★§1.1 가격모델 4+gap):** M1 면적매트릭스 본체(`COMP_ACRYL_CLEAR3T` 277행·13상품 공유)·M2/M2b 면적+부속선택·M3 고정가형 by-siz 공식·M4 부속선택 공식·M5 코롯토 면적공식·**GAP TBD 4**(0 단가행). ★**t_prd_product_prices 0행 = 직접단가룩업 미사용**(T-7). off-grid=ceiling(앱 계산).
- **★가격 경계(방법론):** 온톨로지는 **priced_by(공식)·has_component·use_dims 차원 선언까지만**. 값 계산=엔진 권위(KB 밖).
- **위키 REVERIFY 대조:** `[AC-PRC-001]`(면적매트릭스·양면9도/단면7도)·`[AC-PRC-002]`(silsa 동형 적재) INHERIT·좌표 회귀 인용부 DROP.
- **STALE 함정:** T-1·T-2·T-6·T-7·T-11.
- **GAP:** **[GAP-AC-5]** TBD 4상품(165/168/169/170) 단가행 부재(실무진 단가 대기·source-registry §9 GAP-5)·163 placeholder 10,000 실단가 대체.

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스:** live `acryl-price-chain-260704.csv`(comp_cd·prc_typ_cd·use_dims·단가행수·min/max) + `t_prc_price_components`·`t_prc_component_prices`. {tier A · FRESH}
- **핵심 사실:** 면적 13상품 = **공유 `COMP_ACRYL_CLEAR3T`**(PRICE_TYPE.02·277행·(mat,W,H,min_qty) long-form). 고정가형 = 상품별 `COMP_ACRYL_*`(siz_cd 단가행 3~5개). 부속 = `COMP_ACRYL_{MAGNET,CLIP,...}`(단일가). TBD = `COMP_ACRYL_PENDING_TBD`(0행). 226 = 공유 `COMP_GOODS_FIXED_SIZ`(77행 공유·굿즈와 공유).
- **★단가행 접기(방법론·D-22):** 단가행은 노드로 펼치지 않고 구성요소 노드의 속성/집계로 접음("단가행 277셀·2000~32700"). off-grid ceiling은 엔진 소관.
- **위키 REVERIFY 대조:** `[AC-PRC-002]`(component_prices siz·silsa 동형) INHERIT.
- **STALE 함정:** T-1·T-6.
- **GAP:** [GAP-AC-5](TBD 0행)·226 공유 component 내 자기 siz 단가 실재 확인.

### 3.12 셋트/추가상품(has_member / addons) — ★부속선택

- **정답 소스:** live `acryl-addons-detail-260704.csv`·`acryl-addon-templates-260704.csv` + `t_prd_product_addons`·`t_prd_templates`·`t_prd_template_prices`. {tier A · FRESH}
- **핵심 사실:**
  - **has_member 없음**(전 단품). 
  - **addon(부속) 17건 = t_prd_product_addons + 템플릿 단가:** 146 볼체인 8색(TMPL-000056~063·각 1,000)·147 자석부착(800)·148 원형핀600/1구자석1000·149 투명집게700·150 화이트바디2600/투명바디3000·152 일자핀700/2구자석1700·154 블랙머리끈500. `has_addon`(R14)·always-add 가드(use_dims에 opt_cd 미포함→silent 가산 주의). {transcribed-by `acryl-addon-templates`·`acryl-addons-detail`}
  - M2 부속(자석/집게/헤어끈)은 **옵션그룹+구성요소**로도 표현(147/149/154)·M2b(146)는 addon 템플릿 — 이중 표현 양면 주의.
- **위키 REVERIFY 대조:** `[AC-BOM-004]`(부착=부속+부착 BUNDLE) REVERIFY.
- **STALE 함정:** T-1(부속 단가 330/380/300k 오값)·T-10.
- **GAP:** **[GAP-AC-6]** 부속 표현 이중성(옵션 구성요소 vs addon 템플릿) 정합·always-add silent 가산 가드.

---

## 4. ★핵심 임무 — 미출시·TBD·양면 정직 표기표

> 이 상품군의 최대 임무 = **미출시/TBD/판형/부속 양면을 정직 표기**. 위키 🟡/과거 서술을 그대로 옮기지 말고 07-04 라이브 실측으로 재판정. {전부 transcribed-by §0.2 캐시}

| 구분 | 상품(prd_cd) | 현재 상태(07-04 라이브) | 양면/판정·builder 지침 |
|------|-------------|-------------------------|------------------------|
| **미출시(use_yn=N)** | 159·164·165·168·169·170·226 | del_yn=N·정상 등록·미노출 | **노드 생성 + `status: 미출시(use_yn=N)`**·팬텀 금지·추천 결과에서 제외 |
| **TBD 단가행 0(견적 불가)** | 165·168·169·170 | `PRF_ACRYL_*_TBD`+`COMP_ACRYL_PENDING_TBD` 0행 | **`gap-acryl-tbd-formula-no-priced-rows`**·"공식 바인딩됨·단가 원천 부재"·실무진 대기 |
| **TBD placeholder 단가** | 163 미니파츠 | 단가행 1개 = 10,000(placeholder·note "단가 미정") | **양면:** `current_value: 10,000(placeholder)` / `authority_value: 미정(실무진)`·badge=gap |
| **면적매트릭스 견적 가능** | 146·148·150·151·152·157·158·161·162 (+147/149/154 부속) | `COMP_ACRYL_CLEAR3T` 277행 실재(2,000~32,700) | **가격 있음·면적매트릭스.** priced_by 공식·값 엔진 권위·off-grid ceiling |
| **고정가형 견적 가능** | 153·155·160·166 | `COMP_ACRYL_*` siz_cd 단가행 3~5개 | **가격 있음·고정가형 공식**(직접룩업 아님·T-7) |
| **판형 51행(비종이)** | 16상품(146=8 등) | plate_sizes 실재·면적공식 미참조 | **양면:** `현재값: plate_sizes N행` / `가격영향: 없음`·fn_calc_pansu 금지(§3.8) |
| **부속 이중표현** | 146(addon)·147/149/154(옵션+구성요소) | 146=addon템플릿·147등=옵션그룹+`COMP_ACRYL_*` | `has_addon`(R14)·always-add silent 가산 가드·이중 표현 정합 주의 |
| **del_yn=Y(미생성)** | 171 지비츠★ | 은퇴(중복판)·현행=156 | **상품 노드 미생성**(T-10) |
| **부속 단가 오값** | (T-1) | 480k/590k/330/380/300k = **라이브 부재** | 실단가: 면적 최대 32,700·부속 500~3,000·볼체인 1,000. 오값 인용 금지 |

> **원장 경로:** 아크릴 가격/부속 적재 = 07-03/04 dbmap 라이브 COMMIT(146 addon reg_dt 2026-07-03 실측·`09_load/B-acrylic-accessory-260703`). 226 재바인딩 = §23 set-product(인쇄면 siz화+글리터 무가 CPQ). TBD 6건 = `_foundation/batch/wiring/HANDOFF`(아크릴 *_TBD 실무진 BLOCKED·source-registry §9 GAP-5).

---

## 5. 클러스터 분류 + 공유축 (Stage A 선민팅 / Stage B 팬아웃)

### 5.1 클러스터 (Stage B 팬아웃 단위 — 5 클러스터·25노드)

| 클러스터 | 아키타입 | 상품(prd_cd) | 노드수 | 주의점 |
|----------|----------|--------------|--------|--------|
| **CL-1 컬러아크릴 면적매트릭스 본체** | M1 | 148·150·151·152·157·158·161·162 + 159(미출시) | 9 | `COMP_ACRYL_CLEAR3T` 공유·판형 51행 양면·157/158/161/162 사이즈 옵션 |
| **CL-2 면적+부속선택/addon** | M2·M2b | 146(볼체인 addon)·147(자석)·149(집게)·154(머리끈) | 4 | 부속 이중표현(addon vs 옵션구성요소)·always-add 가드 |
| **CL-3 고정가형 by-siz 공식** | M3 | 153·155·160·166 | 4 | 직접단가룩업 아님(T-7)·siz_cd 단가행·공정 MISSING(153/166) |
| **CL-4 부속선택 공식(지비츠/미니파츠)** | M4 | 156·163 | 2 | 156=옵션가공 2단가·163=placeholder TBD 10,000 |
| **CL-5 코롯토/쉐이커 TBD류(전 미출시)** | M5·GAP | 164(코롯토)·165·168·169·170·226 | 6 | 164만 단가행 36·나머지 TBD 0행·226 재바인딩·전부 use_yn=N |

> **빌드 순서 권고:** CL-1(면적 본체·공유축 확립) → CL-2(부속) → CL-3(고정가형) → CL-4(부속선택) → CL-5(미출시/TBD·정직 표기 주산출).

### 5.2 공유축 목록 (Stage A 선민팅 — 6 공유축 그룹)

| 공유축 | 노드/슬러그 | 공유 상품 | 근거 캐시 |
|--------|-------------|-----------|-----------|
| **SA-1 substrate 자재(두께)** | 아크릴 투명 1.5mm(`MAT_000042`)·3mm(`MAT_000043`)·8mm(`MAT_000044`)·투명(`MAT_000192`) | 전 아크릴(dflt_yn=Y) | `acryl-materials-named` |
| **SA-2 공유 공정** | UV(`PROC_000002`)·UV평판인쇄(`PROC_000111`)·레이저커팅(`PROC_000124`)·굿즈가공(`PROC_000151`)·부착(`PROC_000081`)·가공(`PROC_000083`) | 다수 | `acryl-processes-named` |
| **SA-3 면적매트릭스 가격구성요소** | `COMP_ACRYL_CLEAR3T`(277행·PRICE_TYPE.02) | M1/M2 13상품 공유 | `acryl-price-chain` |
| **SA-4 공유 가격 gap(TBD)** | `gap-acryl-tbd-formula-no-priced-rows` | 165·168·169·170(+163 placeholder) | `acryl-price-chain`(0행) |
| **SA-5 볼체인 addon 템플릿** | TMPL-000056~063(8색·각 1,000) | 146(+타 굿즈 재사용 가능) | `acryl-addon-templates` |
| **SA-6 카테고리 노드** | 단품형/조합형/코롯토/아크릴(CAT_000322/155/159/009) | 혼재 | 카테고리 SELECT |

---

## 6. 지식 구축가 인계 메모 (착수 시)

1. **★live-snapshot 가격 금지·07-04 신규 SELECT만(§0.2·T-2):** 병행 세션이 07-03/04 아크릴 가격 적재. 스냅샷 `snap_20260702_1119`은 아크릴 가격 정본 아님. 캐시 `_cache/acryl-*-260704.csv`에서만 가격 인용.
2. **★과업/구 문서의 대형 부속 숫자(480k/590k/330/380/300k)는 STALE(T-1):** 라이브 실측 = 면적 최대 32,700·부속 500~3,000·볼체인 1,000. 저 숫자 인용 금지.
3. **가격모델 4+gap(§1.1·§3.10):** M1 면적매트릭스·M2 면적+부속·M3 고정가형 공식·M4 부속선택·M5 코롯토·GAP TBD. ★**t_prd_product_prices 0행 = 직접단가룩업 미사용** → `gap-goods-fixed-lookup-no-formula` 붙이지 말 것(T-7).
4. **면적매트릭스 = silsa 동형(§3.10):** `references 아크릴 면적매트릭스`·priced_by 공식·use_dims 차원까지만·값 엔진 권위·off-grid ceiling.
5. **substrate=두께(1.5/3/8mm)·색상값 아님(§3.5·T-8):** 부속(고리/자석/핀/바디/헤어끈/볼체인)=`has_addon`이지 substrate 아님. mat_typ 오타이핑은 현재값 기록.
6. **비종이=판형 가격축 아님(§3.8·T-9):** plate_sizes 51행 실재하나 면적공식 미참조 → 양면(생산메타/오적재 의심)·fn_calc_pansu 이식 금지.
7. **미출시 7·TBD 4·placeholder 1 정직 표기(§4):** 165/168/169/170=단가행 0=`gap-acryl-tbd`·전부 use_yn=N. 팬텀 금지.
8. **171 del_yn=Y 미생성·167 부재(§0.1·T-10):** 상품 노드 만들지 말 것.
9. **slug 정본=product-NNN-kebab[HARD]·has_member 없음(단품).**
10. **수치**는 §0.2 캐시 psql 전사에서만(손전사 금지). **엑셀 원본 반복 Read 금지.**
11. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**
12. **범위 밖 거절:** 주문·배송·회원·쿠폰은 KB 범위 밖.

### 미확정/실무진 확인 필요 큐 (GAP 원장)

- **[GAP-AC-5]** TBD 4상품(165/168/169/170) 단가행 부재·163 placeholder 10,000 실단가 — 실무진 단가 대기(source-registry §9 GAP-5·`batch/wiring` BLOCKED).
- **[GAP-AC-3]** plate_sizes 51행 성격(생산메타 정당 vs 오적재)·가격 미영향 확증 — §7/§29.
- **[GAP-AC-2]** 공정 MISSING 10상품(레이저커팅/굿즈가공 미적재)·UV평판인쇄 세분 미전파 — §7.
- **[GAP-AC-1]** substrate/부속 mat_typ 오타이핑(아크릴판 .03↔.20·글리터 .09) — §7/§12.
- **[GAP-AC-4]** CPQ 옵션 items 미적재(og만·oi 0)·제약 아크릴 전 상품 0행 — §31.
- **[GAP-AC-6]** 부속 표현 이중성(옵션 구성요소 vs addon 템플릿) 정합·always-add silent 가산 가드 — §34/§7.
- **226 재바인딩본** 미출시(use_yn=N)·인쇄면 siz화+글리터 무가 CPQ(§23) — 출시 승인 대기.
