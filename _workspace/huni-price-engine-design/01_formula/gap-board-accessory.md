# gap-board-accessory.md — 상품악세사리 현 라이브 미설계/불완전 갭 보드 (designer 작업 큐)

> **기준점(생성 입력).** 상품악세사리(가격포함) 18상품(PRD_000001~015 + 281~283)의 라이브 t_prc_*/t_prd_* 미설계·불완전 지점. designer가 채울 곳.
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-22 read-only SELECT · 권위=상품마스터(260610) 절대 · 추정 0.
> 분류: 🔴 가격사슬 전무(설계 필요) · 🟡 그릇/배선 불완전 · 🟢 실재(재사용) · ◆ 돈크리티컬 · 💬 컨펌큐.

---

## 0. 갭 요약 (가격사슬 6종단 중 절대 최저)

| 사슬 단계 | 라이브 실측(2026-06-22) | 상태 |
|-----------|------------------------|------|
| 직접단가 `t_prd_product_prices` | **0행** (18상품 전부) | 🔴 전무 |
| 공식정의 `t_prc_price_formulas` | (부자재 전용 0) | 🔴 미설계 |
| 공식바인딩 `t_prd_product_price_formulas` | **0행** | 🔴 전무 |
| template단가 `t_prd_template_prices` | **0행** (봉투 template 12행 존재하나 단가 0) | 🔴 전무 |
| 구성요소 `t_prc_price_components` | (부자재 전용 0) | 🔴 미설계 |
| 단가행 `t_prc_component_prices` | **0행** | 🔴 전무 |
| 수량구간할인 바인딩 | **0행** (부자재 미해당) | 🟢 정당 부재 |
| 사이즈 `t_siz_sizes`+`t_prd_product_sizes` | cut_* 분해 실재(SIZ_000078~·39행) | 🟡 3축 미완(묶음수 잔존) |
| 색상자재 `t_mat_materials` | 볼체인8·리필7·천정고리1 MAT_TYPE.10 | 🟡 색상=자재 오염(가격엔진 밖) |
| addon template/addon | 봉투 template 12·addon 5행(엽서) | 🟢 배선 실재(단가만 0) |
| option_items | 테스트 잔재 2(items 0) | 🟢 정상 옵션 0 |

**한 줄 평결: 상품악세사리는 가격사슬이 통째로 비어있다 — 양 가격경로(PRODUCT_PRICE·TEMPLATE_PRICE) 단가 모두 0행 → 현재 전 부자재 `source=NONE`(0원).** 단 size/addon/색상자재 배선은 부분 실재(가격값만 충전하면 됨). `확신도: 높음(라이브 직접 카운트)`

---

## 1. 🔴 G-AC-MAIN — 가격사슬 전무 (설계 필요·최우선)

- **무엇:** 18상품 전부 product_prices 0·formula 0·template_prices 0. 상품마스터 inline 가격(1100/3000/16000원 등 67행 명시)이 라이브에 전혀 안 들어감.
- **라이브 증거:** `SELECT COUNT(*) FROM t_prd_product_price_formulas WHERE prd_cd ~ 'PRD_00000[1-9]$|PRD_0000(1[0-5])$|PRD_00028[1-3]$'` → 0 · `SELECT prd_cd,COUNT(*) FROM t_prd_product_prices WHERE …` → 0행.
- **현 동작:** evaluate_price → source=NONE → lenient 0원·strict 차단(pricing.py:335).
- **designer 작업:**
  - AC-1(볼체인/와이어링/리필잉크 3상품) = `t_prd_product_prices` unit_price 1행씩 (PRODUCT_PRICE 무손실·굿즈 GP-1 동형).
  - AC-2(11상품) = variant-매트릭스 formula (G-AC-1 그릇 결판 후).
- `확신도: 높음` · **차단 아님(designer 큐)**.

---

## 2. 🔴◆ G-AC-1 — AC-2 변형고정가 그릇 부재 (굿즈 G-GP-1 동형·최대 난제)

- **무엇:** AC-2 11상품의 variant별 다른 고정가(OPP 11규격·트래싱지 8묶음·우드 3길이·카드 2색)를 **PRODUCT_PRICE(unit_price 1개)에 담을 수 없음**(상품당 단가 1개뿐).
- **라이브 증거:** `t_prd_product_prices`는 prd_cd당 unit_price 1값 구조(information_schema·굿즈 G-GP-1 실측 동일).
- **그릇 후보(search-before-mint):**
  - **(채택후보) variant-매트릭스 formula** — 단일 comp + use_dims=[siz_cd] 또는 [opt_cd] + variant당 단가행. 린넨 `COMP_POSTEROPT_LINEN_FINISH` use_dims=[opt_cd] 그릇 실재(dbmap round-23)·아크릴 면적매트릭스 1축 축소판. **신규 테이블/가격축 0·엔진 변경 0**.
  - (부결) option_items add_price — 컬럼 부재(information_schema 실측·굿즈 검증분).
- **돈크리티컬:** 평탄화 적재 시(variant 1행) → OPP 230x350 주문에 70x200 가격 오청구·트래싱지 100장 주문에 20장 가격(28000 대신 6000) **과소청구**. use_dims 충전 필수.
- `확신도: 높음(굿즈 G-GP-1 라이브 동형)` · **designer 결판 필요(P1)**.

---

## 3. 🔴◆ G-AC-2 — 묶음수 합가형 오적용 위험 (돈크리티컬 함정)

- **무엇:** 사이즈 "(50장)" 묶음수를 합가형(.02·구간총액÷min_qty)으로 오해 시 가격 붕괴.
- **권위:** 상품악세사리 inline 가격 = **팩 단가(.01)**. OPP 70x200 1100원 = 50장 1팩 가격이지 ÷50=22원/장 환산 대상 아님(봉투제작 PRD_000050 MATRIX 합가형과 정반대).
- **돈크리티컬:** ÷min_qty 적용 시 1100원 봉투가 22원/장 × 주문수로 환산 → 묶음수 다른 variant 가격 전손.
- **designer 가드:** AC=PRODUCT_PRICE·variant-매트릭스 formula의 prc_typ=.01(단가형·unit×qty). **합가형 금지.** (책자 제본비 .01 정당 단가 교훈 동형.)
- `확신도: 높음(L1 가격=팩단가·pricing.py:316 unit_price×qty)`.

---

## 4. 🔴◆ G-AC-3 — addon TEMPLATE_PRICE 선점 + 단가 전무 (이중역할 경로)

- **무엇:** 봉투(PRD_000001/002/281/282/283)가 엽서(PRD_000016) addon으로 붙음(addon 5행·template 12행 실재). 그러나 template_prices 0행 → addon 봉투 0원.
- **라이브 증거:** `t_prd_product_addons` 5행(PRD_000016→TMPL-000005/006/009/010/011) · `t_prd_template_prices` 0행.
- **엔진 선점(pricing.py:296):** tmpl_cd 타깃이면 TEMPLATE_PRICE가 PRODUCT_PRICE보다 **우선** — addon 봉투는 product_prices를 봐도 template_prices를 먼저 봄. template_prices 없으면 "기준 상품 가격으로 계산"(pricing.py:300 fallback) → product_prices도 없으면 0원.
- **designer 작업:** 봉투 독립가(product_prices) + addon가(template_prices) **일관 적재**(동일 봉투의 두 경로 단가 정합). 굿즈 GP-2 PRODUCT_PRICE 선점 가드와 유사하나 방향 반대(여기선 template fallback 존재).
- `확신도: 높음(pricing.py:296-300·addon 5행 실측)`.

---

## 5. 🟡 G-AC-4 — 사이즈 3축 미완 분해 (묶음수·색상 siz_nm 잔존)

- **무엇:** siz_nm 텍스트에 묶음수("(50장)")·색상("화이트")이 잔존(cut_*는 정상 분해). 트래싱지(003)는 3치수×묶음수가 8 siz로 평면화(곱셈 오모델).
- **라이브 증거:** `SELECT … s.siz_nm FROM t_prd_product_sizes …` → PRD_000001 "70x200mm(50장)"·PRD_000004 "화이트165x115mm" / PRD_000003 8행(3치수×묶음).
- **가격 함의:** 묶음수가 가격 분기축(트래싱지)이므로 묶음수를 옵션/bdl_qty로 분리해야 use_dims 정합(G-AC-1과 연동). 색상은 카드봉투에서 가격 분기(opt 분리 필요).
- **designer:** AC-2 variant축 정의 시 siz_nm에서 묶음수/색상 분리(dbmap size→option 트랙 협업·가격엔진은 use_dims 충전만).
- `확신도: 높음`.

---

## 6. 🟡 G-AC-5 — 색상=자재 오염 (가격엔진 밖·dbmap 위임)

- **무엇:** 볼체인 8색·리필잉크 7색·천정고리 1 = t_mat_materials MAT_TYPE.10 오염. 색상은 자재가 아님([[material-option-normalization]]).
- **라이브 증거(2026-06-22):** `SELECT pm.prd_cd,count(*) FILTER(WHERE m.mat_typ_cd='MAT_TYPE.10') …` → PRD_000006=8·007=0·008=1·010=0·012~014=0·015=7.
- **★드리프트(GATE-1 stale):** round-13 GATE-1은 와이어링(007)·행택끈(010)을 "3행 색상자재 오염"으로 기록했으나 **2026-06-22 라이브는 둘 다 0행** — round-13 이후 라이브 변화(007/010 색상자재 제거됨). designer는 라이브 권위(007/010 현재 깨끗·006/015만 잔존).
- **가격 함의:** AC-1(볼체인/리필잉크)은 색상 무영향(동가) → 가격엔진엔 무관. 색상 자재 정리는 **dbmap 자재축 트랙 위임**(가격엔진 inline 고정가 verbatim만).
- `확신도: 높음(라이브 재측정)`.

---

## 7. 💬 컨펌큐 (인간/designer·차단 아님)

| ID | 질문 | 권위 후보 |
|----|------|-----------|
| **Q-AC-PRICE** | AC-1/AC-2 단가 적재 = PRODUCT_PRICE(독립) + TEMPLATE_PRICE(addon) 양 경로. 동일 봉투의 두 경로 단가가 같아야 하나, addon은 별 단가(마진)인가? | pricing.py 경로 분리·designer 결판 |
| **Q-AC-DUP** | 카드봉투 이중역할(004 기성 + 281/282 별 PRD + TMPL-000005~011). 라이브 281/282/283 = PRD_TYPE.03(round-13 "PRD_TYPE.05"와 불일치). 역할 분리(004 독립가 vs 281/282 addon가) 의도 확인. | 라이브 §1 PRD_TYPE.03 우선 |
| **Q-AC-CEIL** | 천정고리(PRD_000008·use_yn=N·6500) 판매중지 의도인가? 가격 적재 대상 제외? | round-13 Q-PA-3 미결 |
| **Q-AC-MES** | MES 8/15 NULL(천정고리·행택끈·우드봉·리필잉크). 가격 무관이나 견적→생산 전달에 필요. | 가격엔진 밖(MES 트랙) |
| **Q-AC-OTC** | 봉투 addon 단가가 본체(엽서) 사이즈와 캐스케이드(봉투 규격↔엽서 규격 매칭)? 현 캐스케이드 0. | rpmeta PO addon·designer |

---

## 8. designer 작업 큐 (우선순위)

| 순위 | 작업 | 갭 | 돈크리티컬 |
|------|------|-----|------------|
| P1 | AC-2 variant-매트릭스 그릇 결판(use_dims=[siz_cd]/[opt_cd]·신규축0) | G-AC-1 | ◆ |
| P1 | AC=고정가형(.01) prc_typ 가드(합가형 금지) | G-AC-2 | ◆ |
| P2 | AC-1 3상품 PRODUCT_PRICE 1행 적재(굿즈 GP-1 동형) | G-AC-MAIN | — |
| P2 | AC-2 11상품 variant 단가행 + 바인딩 | G-AC-MAIN | — |
| P2 | 봉투 addon template_prices 단가 + PRODUCT_PRICE 정합 | G-AC-3 | ◆ |
| P3 | siz_nm 묶음수/색상 분리 use_dims 충전(dbmap size 트랙 협업) | G-AC-4 | — |
| (위임) | 색상 자재 오염 정리(006/015) | G-AC-5 | dbmap 자재축 |

★전 작업 **신규 가격축 0·엔진 변경 0**(굿즈 종단 그릇 전파). 실 COMMIT은 인간 승인 후 dbmap 위임·DB 미적재. `확신도: 높음`
