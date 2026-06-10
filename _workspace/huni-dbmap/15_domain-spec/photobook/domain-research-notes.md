# 포토북 — 도메인 리서치 노트 (round-11 확대 #3)

> **작성** 2026-06-10 · round-11. **신규로 리서치한 갭·발견한 충돌·🔴/🟡 컨펌 질문 + 경쟁사 SKU 구분 리서치**만 기록. 07_domain이 이미 닫은 것은 재기술하지 않는다(재유도 0).
>
> **권위:** 후니 PDF > 07_domain KB > **경쟁사 SKU 구분(보조)** > 국내외 표준. 표준/경쟁사 충돌 시 후니 권위.

---

## 0. 07_domain 재사용 — 신규 리서치 불요 영역 (재유도 0)

포토북의 다음 의미는 07_domain이 이미 권위로 확정 → 본 round-11은 인용만:

| 주제 | 07_domain 권위 | round-11 적용 |
|------|----------------|---------------|
| 생산방식 3구조(A통합/B셋트) | `entity-semantic-model §4·119`(포토북=B 셋트 명시·자재 권위=parent+usage_cd) | 하드/레더=B 셋트·소프트=A 근접 |
| 표지타입 variant | `entity-semantic-model §2`(하드/레더하드/소프트→반제품 표지 sub_prd, **G-PB-2 평면 혼재 경고**) | C18 variant 분리 |
| 제본 차이(레이플랫 vs PUR) | `entity-semantic-model §5·141~145`(포토북=PUR 권위·레이플랫 PROC_000025 적재0 미운영 가설·**C-10 1순위**) | C28 PUR 단일 |
| 표지종이 복합표기 분해 | `entity-semantic-model §1-1`(`아트250+무광코팅`=자재+공정, **G-PB-3**) | C26 분해 |
| 면지(D-29) | `decision-trail-harvest D-29`(화이트/블랙/그레이·USAGE.03) | C29 그레이 |
| USAGE 슬롯 | `db-structure §196`(.01내지/.02표지/.03면지) | 자재 usage 분리 |
| 책등(무선/PUR mm) | `entity-semantic-model §137` | C30 책등 |

→ **포토북은 07_domain 커버리지가 매우 높다**(§2 표지타입·§4 생산방식·§5 제본이 이미 포토북을 명시 표제로 다룸). 신규 작업 = **경쟁사 SKU 리서치(§1)** + 아래 컨펌.

---

## 1. 경쟁사 포토북 SKU 구분 리서치 (사용자 directive — 신규)

> **사용자 directive:** "다른 경쟁사들은 어떤식으로 포토북을 구분하는지를 먼저 철저하게 확인해야 데이터 매핑·컬럼 분석법을 알 수 있다." → WebSearch 리서치(Shutterfly/Mixbook/Blurb/Saal).

### 1-1. 경쟁사 SKU 차원 (4축 공통)

| SKU 축 | Shutterfly | Mixbook | Blurb | 후니 포토북 대응 |
|--------|------------|---------|-------|------------------|
| **사이즈** | 6종(8x8·8x11·10x10·11x8·11x14·12x12) | 6x6~14x11 | 5x8·8x10·13x11 | **C5 size variant 4종** |
| **커버타입** | hardcover·softcover·layflat | Softcover·Hardcover·Layflat·Album | soft·hard·layflat | **C18 표지타입 3종**(하드/레더하드/소프트) |
| **커버재질** | glossy·matte·eco/genuine leather·acrylic | glossy·soft-touch matte | — | **C26 표지종이**(아트250+코팅·레더) |
| **페이지** | 20 base + per-page | base + per-page | 20 min·layflat 110 max·일부 400 | **C15~17 page(24~150) + C37/38 base+per-page** |

### 1-2. 핵심 발견 — 후니 모델이 글로벌 표준과 1:1 정합

1. **구분 방식 = 별도 상품 분할 아님, 1상품 + 다축 옵션.** 경쟁사는 포토북을 **"사이즈 먼저 선택 → 커버/종이 마감 선택"**(browse by dimensions first)으로 조직. **별도 SKU로 쪼개지 않음.** → 후니 `포토북[디자인명]`(1상품) × size × 표지타입 variant와 **동형**. 사용자가 말한 "1상품이나 사이즈·커버타입으로 상품 확장 가능"은 정확히 이 구조.
2. **커버타입 = 가격 계층의 핵심.** softcover(최저) < hardcover < leather/layflat(프리미엄). 후니 가격 실측 정합: 소프트(10000~13000) < 하드(12000~22000) < 레더하드(19000~32000). **레더=Shutterfly의 leather cover upgrade 대응.**
3. **가격 = base(특정 페이지) + per-page.** 경쟁사 "20 base + per-page", 후니 "기본(24P) + 추가(2P)당" — **정확히 동형**. page_incr(2) = spread(펼침면) 단위.
4. **layflat은 별 커버타입.** 경쟁사는 layflat을 hardcover와 구별(연속 시트·완전 평탄·파노라마). **후니는 layflat(레이플랫) 미운영, PUR만**(C-10) — 후니가 경쟁사 대비 미보유한 1축. 향후 확장 후보.

### 1-3. 매핑 함의 (리서치 → 컬럼 분석법)

- **표지타입(C18)을 variant 축으로 모델링**(별도 상품 아님) = 경쟁사 정합 + 사용자 directive. → 표지 sub_prd(USAGE.02) + size 차원 + page_rule.
- **디자인명 = 에디터 템플릿**(경쟁사도 디자인 테마는 에디터 내 선택, SKU 분할 아님). PRD_TYPE.04 디자인·디자인보유.
- **가격은 size×표지타입 매트릭스 base + per-page 증분** = round-2 가격엔진. 경쟁사 구조가 round-2 매핑 형태를 확정.

---

## 2. 🔴/🟡 컨펌 질문 (인간 결정 대기)

### CONFIRM-PB-1 [🟡] 표지타입 sub_prd 분해 범위 — 어디까지 반제품인가?
- **상황:** 하드커버/레더하드커버=표지 반제품(B 셋트, sub_prd USAGE.02). 소프트커버=아트250+무광코팅 **종이표지**(A 통합 근접).
- **가설:** 하드/레더만 sub_prd 분해, 소프트는 parent-적재(A). 책자 CONFIRM-BK-5와 동류.
- **질문:** 소프트커버 표지도 sub_prd로 분해할까요, parent 적재(A 통합)할까요? 디자인명별로 다상품인가, 1상품+표지타입 variant인가?

### CONFIRM-PB-2 [🟡·1순위] 레이플랫 vs PUR — 후니 포토북 제본 확정
- **상황:** 라이브·엑셀 모두 포토북=**PUR**(PROC_000020). 레이플랫(PROC_000025)=적재0·마스터 정의만. 경쟁사는 layflat을 프리미엄 별 커버로 운영(파노라마 무손실).
- **가설(유력):** 후니=실제 PUR 운영, 레이플랫 미운영 마스터. (entity-semantic §144 C-10 1순위.)
- **질문:** 후니 포토북 제본은 PUR만인가요? 레이플랫(025)은 미운영(향후 확장 후보)인가요?

### CONFIRM-PB-3 [🟡] 레더(C26 표지종이) 자재유형?
- **상황:** 표지종이=레더. 종이가 아닌 가죽 소재. 표지폴더=특수출력.
- **가설:** MAT_TYPE.06 가죽(db-structure §191). 책자 CONFIRM-BK-4와 동일.
- **질문:** 레더를 MAT_TYPE.06 가죽으로 등록할까요? (전 시트 일괄 — 책자 BK-4와 통합)

### CONFIRM-PB-4 [🟡] 가격 base(24P)+per-page(2P당) → round-2 모델
- **상황:** 가격포함 시트. C37 기본(24P)=size×표지타입 매트릭스 base, C38 추가(2P)당=per-page 증분.
- **가설:** round-2 가격엔진 = `t_prd_product_prices`(고정가 base 24P) + `t_prc_*`(per-page 증분 component, PRF_PHOTOBOOK). 경쟁사 base+per-page 동형.
- **질문:** 포토북 가격을 base(24P 고정가) + per-page(증분 component)로 round-2 매핑할까요? base 기준 페이지(24P)는 어떻게 인코딩?

### CONFIRM-PB-5 [🟡] 디자인명 SKU 모델 — 1상품 vs 다상품?
- **상황:** `포토북 [디자인명]` 12행 전부 동일 상품명. 디자인보유=●. 에디터 중심.
- **가설:** 경쟁사처럼 **1상품(포토북) + 에디터 디자인 템플릿**(디자인명=템플릿 선택). 디자인별 별도 상품 아님.
- **질문:** `포토북[디자인명]`은 디자인마다 별 상품(prd_cd)인가요, 1 상품 + 에디터 디자인 템플릿(`t_prd_templates`/디자인보유)인가요?

### CONFIRM-PB-6 [🔴] C10/C23 파일명약어 — 견적 DB 귀속?
- **상황:** 내지/표지 파일명약어(포토북하드/cover) = 생산 메타. t_* 컬럼 부재.
- **가설:** 견적 밖(생산/MES). 디지털 CONFIRM-DP-2·스티커 ST-5·책자 BK-6과 동일.
- **질문:** (a) 견적 밖 (b) note 보존 (c) 신규 컬럼? (전 시트 일괄)

---

## 3. 디지털인쇄·스티커·책자 컨펌과의 관계 (중복 제거·일괄 결정 후보)

| 컨펌 | 디지털 | 스티커 | 책자 | 포토북 | 일괄 결정 |
|------|--------|--------|------|--------|----------|
| 레더 자재유형(MAT_TYPE.06 가죽) | — | — | BK-4 | PB-3 | ✅ 통합(레더 사용 시트) |
| 표지 sub_prd 분해 범위 | — | — | BK-5 | PB-1 | ✅ 통합(B 셋트 반제품 — schema-design-intent-map 의존) |
| 파일명약어/메타 견적밖 | DP-2 | ST-5 | BK-6 | PB-6 | ✅ 통합(생산메타 일괄) |

포토북 **고유 신규 컨펌**: PB-2(레이플랫 vs PUR·C-10 1순위)·PB-4(가격 base+per-page round-2)·PB-5(디자인명 SKU 모델 — 에디터 중심 특화).

---

## 4. 다음 단계 (확대 #3 완료 → #4)

1. **컨펌 6건 해소** — PB-1~6. PB-2(레이플랫)=C-10 1순위. PB-3/PB-1/PB-6은 책자와 일괄. PB-4(가격)=round-2 의존. PB-5(디자인 SKU)=schema-design-intent-map 의존.
2. **확대 #4 = 캘린더(+디자인캘린더)** — 포토북과 정반대(form factor 5상품·장수 variant·캘린더가공 택일그룹·조건부 캐스케이드).
3. **schema-design-intent-map 입력** — 포토북 variant 모델(size·표지타입·page·디자인명 SKU)·B 셋트 반제품·가격포함 구조를 HANDOFF #1과 결합. 경쟁사 SKU 구분이 variant 모델 권위.

---

## Sources
- **후니 권위(1순위):** `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf`(제본팀·하드커버 싸바리) · `docs/huni/후니프린팅_주문프로세스_20251001.pdf` · 상품마스터 `260610.xlsx` 포토북(가격포함) 시트(실측 12 variant·가격포함).
- **07_domain KB(2순위):** `entity-semantic-model.md`(§2 표지타입 variant·G-PB-2/3·§4 포토북 B 셋트·§5 레이플랫vsPUR C-10) · `db-domain-structure-live.md`(PROC_000017·USAGE/PRD_TYPE) · `decision-trail-harvest.md`(D-29 면지).
- **경쟁사 SKU(3순위·보조·신규 WebSearch 2026-06-10):**
  - [Mixbook — Hardcover vs Softcover Photo Books](https://www.mixbook.com/inspiration/hardcover-vs-softcover-photo-books-the-ultimate-guide) · [Mixbook — Photo Books Pricing](https://www.mixbook.com/photo-book-pricing)
  - [Shutterfly — Create Custom Photo Books](https://www.shutterfly.com/photo-books/) · [Shutterfly — How Much Do Photo Books Cost](https://www.shutterfly.com/ideas/how-much-do-photo-books-cost-pricing-guide/)
  - [Blurb — Pricing Calculator](https://www.blurb.com/pricing) · [Photobook Press — Layflat vs Perfect Binding](https://photobookpress.com/blogs/news/layflat-vs-perfect-binding-which-to-consider)
- 라이브 적재 소스: `raw/webadmin/webadmin/catalog/{models,admin,basecodes}.py`.
