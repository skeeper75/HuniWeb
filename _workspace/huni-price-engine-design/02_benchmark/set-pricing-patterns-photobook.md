# 반제품/세트 가격 합성 패턴 — 포토북 (종단 보강 P-9)

> `hpe-benchmark-analyst` 산출 3/3 — 포토북 세트/반제품 가격 합성 패턴.
> 기존 `set-pricing-patterns.md` P-1~P-8(디지털·아크릴·실사·문구·굿즈·스티커)을 **보존**하고,
> 본 파일은 **P-9 포토북 전용 보강**(책자 P-6와 갈리는 "기본가+페이지증분 완제 세트" 사례).
> **흡수 vs 답습[HARD]**: 메커니즘만 흡수·naming/codes 후니 유입 금지·권위 엑셀 최종.

## 출처

- `[red:book]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json` (book2025 부품분해 로그·표지/내지 분리·PAGE_CNT 곱).
- `[red:PH]` = `_workspace/huni-rpmeta/categories/PH/reverse.md` (PHBK* 포토북 5종·digital_price·세트구조 미노출).
- `[red:TP]` = `_workspace/huni-rpmeta/categories/TP/reverse.md` (TPPHSET 사진북·tmpl_price·★"세트=이질N장 assortment" REFUTED).
- `[huni:master]` = `_workspace/huni-dbmap/24_master-extract-260610/photobook-l1.csv` (기본24P+2P당 권위).
- `[huni:ref]` = `_workspace/huni-dbmap/00_schema/ref-products.csv` (PRD_000100~107 세트·SEMI_ROLE 실측).
- `[huni:prior]` = `set-pricing-patterns.md` P-6(책자 다부품 합성·재사용·중복 재유도 0).

---

## P-9. 포토북 세트/반제품 합성 ★ (기본가+페이지증분 완제 세트 — 책자 부품분해와 결정적 분기)

포토북은 **§0 P-1(다부품 합성)의 구성 그릇은 보유하되, 가격은 완제 기본가로 internalize** 한 사례 — 책자 P-6(표지+내지+제본 부품을 외부 합산)와 달리, 포토북은 **표지/내지/제본 부품을 기본가 안에 묶고, 외부로는 "기본가 + 페이지증분"만 노출**한다. 굿즈 P-7a(완제 개당단가)·스티커 P-8b(묶음 총액)와 같은 "완제 단일가" 클래스이나, **페이지 차원이 추가**되는 게 변별.

### P-9a. 포토북 = 완제 기본가 + 페이지 증분 (부품분해 미노출)

- **후니** `[huni:master]`: 포토북 가격 = **가격_기본(24P)[사이즈, 표지타입] + 가격_추가(2P당)[사이즈] × ceil((페이지-24)/2)**. 표지/내지/제본 부품 단가가 **기본가 안에 묶여**(internalized) 외부 노출 안 됨 — 완제 단일가에 페이지 증분만 가산.
- **레드** `[red:PH]`: PHBK* = `digital_price`(면수×사이즈×단/양면 합산)·세트 구조 표면 미노출(`koi=N·pdf=Y`). 사진북 TPPHSET = `tmpl_price`(에디터 완제 통합단가)·부품 미분해 `[red:TP]`.
- **★책자 P-6a와 결정적 차이**: 책자(`book2025`)는 표지인쇄/표지자재/내지인쇄/내지자재/제본/추가커버를 **외부 분해 합산**(result_log 6항 `[red:book]`). 포토북은 같은 부품을 **기본가에 묶음**(외부=기본가+페이지). 즉 **부품 분해 깊이가 다르다** — 책자=full 분해·포토북=기본가 묶음+페이지만 노출.
- **후니 매핑**: 합산형 공식 `PRF_PHOTOBOOK_SUM` = 기본가 comp(`COMP_PHOTOBOOK_BASE` `use_dims=[siz_cd,mat_cd]`) + 페이지단가 comp(`COMP_PHOTOBOOK_PAGE` `use_dims=[siz_cd]` × 앱증분횟수)·`addtn_yn` Σ. **부품(표지/내지/제본)을 별 comp로 분해하지 않음**(기본가에 묶임 = 권위 master 모델). ★책자 하드커버처럼 부품 분해할지는 **권위 가격표가 결정**(master가 기본가 통합으로 줌 = 통합·부품단가 미제공).

### P-9b. 세트 "구성"(생산 BOM) vs 세트 "가격"(완제 기본가) 분리 — P-1b 원칙 명확 사례

- **후니 세트 구조** `[huni:ref]`: PRD_000100(포토북 parent·**PRD_TYPE.04 고정가형**) + sub_prd:
  - 내지: PRD_000101 (SEMI_ROLE.01 내지·몽블랑130)
  - 표지: PRD_000102 하드커버 / 103 아트250+무광코팅 / 105 레더하드커버 / 106 레더 / 107 소프트커버 (SEMI_ROLE.02 표지)
  - 면지: PRD_000104 그레이 (SEMI_ROLE.03 면지)
- ★**세트 "구성"(`t_prd_product_sets` parent+sub_prd)은 생산 BOM/주문 단위**(표지/내지/면지 빈 껍데기 sub_prd = `schema-design-intent-map` "B 셋트라도 자재 권위는 parent+usage_cd"). **세트 "가격"은 완제 기본가+증분**(부품 단가 합산 아님). → **구성과 가격 분리**(P-1b·디지털 종단 set-product-design §0 실증)의 가장 명확한 포토북 사례.
- **가드**: sub_prd(표지/내지/면지)에 단가행을 두고 합산하려 하면 **이중계상**(기본가에 이미 묶임). 가격 = parent 기본가 공식만·sub_prd는 BOM(가격 0행 정상).

### P-9c. ★"포토북 세트 = 이질 N장 assortment" 오해 가드 (RP REFUTED)

- **레드** `[red:TP §H-8]`: 사진북 TPPHSET이 "세트 = 서로 다른 N장 묶음"인지 검증 → **REFUTED**(`quantityGroup` = 디자인수×부수·"이질 N장 assortment" 구조 부재). 사진북 = **같은 디자인의 페이지 묶음**(한 책의 N페이지)이지 N개 다른 상품 세트가 아니다.
- **후니 매핑**: 포토북 세트(parent+표지/내지/면지)는 **한 책을 만드는 부품 구성**(생산 BOM)이지 "여러 완제품 묶음 판매"가 아니다. 묶음수(`bdl_qty`·여러 권 발주)는 별개 차원(P-2). ★포토북 "세트"를 묶음판매(여러 권)로 오해 금지 — 1권 = parent 1개·페이지 = 그 권의 면수.

### P-9d. 페이지 = 입력 차원·증분횟수 = 앱계산 (SKU 폭발 금지)

- **후니** `[huni:master]`: 내지페이지(편집기) 24~150·STEP 2 = **입력 차원**(에디터에서 페이지 추가). 증분횟수 = `ceil((페이지-24)/2)` = **앱 런타임**.
- **가드 [HARD]**: 페이지 64단계(24,26,…,150)를 siz_cd 또는 product_prices 행으로 베이크 금지(SKU/행 폭발·책자 P-6b·디지털 set-product-design §3 동형). 페이지단가(2P당) 1행만 DB·증분 곱은 앱.
- **책등(seneca 동류)**: `제본사양_책등` = 페이지×내지두께 파생(앱·DB 미저장·off-grid ceiling 동류). 가격 영향(무선/하드커버 표지 재단)이 있으면 앱 계산(신규 단가행 불요).

### 포토북 합성 가드 (종합)

- **완제 기본가(P-9a)** = 부품 internalize·외부=기본가+페이지(책자 full 분해와 다름)·**세트 구성≠가격(P-9b)** = parent 기본가 공식만(sub_prd 가격 0)·**이질 N장 오해(P-9c)** = REFUTED(같은 책 페이지 묶음)·**페이지 입력+앱증분(P-9d)** = SKU 폭발 금지. 넷을 한 공식으로 강제 금지(메모리 `dbmap-print-domain-recipe-philosophy`).
- **★세트 vs 완제 기본가 분기 = 권위 가격표 단위가 결정** — master가 부품단가(표지/내지/제본 별 단가) 주면 책자형 부품 합산(P-6a)·**완제 기본가 + 페이지증분 주면 P-9a(현 master = 후자)**. 포토북 현 권위 = 완제 기본가(부품 미분해).

---

## P-9 세트 가격 합성 종합 판정

1. **포토북은 P-1(다부품 합성)의 "구성 그릇 보유 + 가격 internalize" 변형** — 책자(P-6a full 분해)와 굿즈(P-7a 완제 개당단가) 사이. 구성(세트 parent+sub_prd)은 책자 하드커버와 동형 보유, 가격은 **완제 기본가 + 페이지 증분**(완제 단일가 클래스이나 페이지 차원 추가).
2. **신규 가격축 0** — 후니 합산형 공식(기본가 comp + 페이지단가 comp)으로 표현. 페이지 증분은 앱 계산·DB는 페이지단가 1행(메모리 `compute-in-app-db-stores-lookup` 정합).
3. **designer 핵심 입력**:
   - **세트 "구성"(parent + 표지/내지/면지 sub_prd `SEMI_ROLE`) vs 세트 "가격"(완제 기본가+증분 공식) 분리**(P-9b·이중계상 가드·sub_prd 가격 0행 정상).
   - **포토북 = 합산형 공식기반**(고정가형 product_prices 단독 불가·페이지폭발 GAP·absorption C-PB1/D-PB-MODEL).
   - **페이지 = 입력 차원·증분횟수 = 앱**·페이지단가는 `siz_cd`만 차원(표지 무관·C-PB4).
4. **흡수 실질 = 0건(세트 합성 메커니즘)** — 후니 권위 충분. RedPrinting `digital_price`/`tmpl_price`·book2025 부품분해는 흡수 대상이 아니라 후니가 이미 동형/우월(페이지 증분을 후니가 더 투명하게 명시).

### naming 유입 가드 [HARD]
`digital_price`·`tmpl_price`·`book2025`·`INN_PAGE`·`PHBK*`·`TPPHSET`·`seneca`·`MTRL_CD`·`SEMI_ROLE`은 후니 자체 코드(SEMI_ROLE 후니 실재) 외 RP/WP 토큰 후니 유입 금지. 후니 `frm_cd`(`PRF_PHOTOBOOK_SUM`)·`comp_cd`(`COMP_PHOTOBOOK_*`)·`t_prd_product_sets`·`page_rules` 컨벤션으로 번역.
