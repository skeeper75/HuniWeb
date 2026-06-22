# domain-lens.md — 12축 + 가격엔진 인쇄 도메인 렌즈 (디지털인쇄 스코프)

> **Phase 1 — hcc-authority-curator** · 2026-06-22 · `huni-catalog-conformance` §21
> 정합 판정 **전에** 각 축이 인쇄에서 무엇을 뜻하는지 먼저 정립한다(directive #1). 코드 표면 대조 전
> 도메인 의미를 고정해야 false-positive를 막는다. 본 렌즈는 기존 `schema-design-intent-map.md`
> §② WHY·§③ 삼중 바인딩·round-11 BOM을 디지털인쇄 관점으로 재사용(`reuse-map.md` 참조).

## 0. 디지털인쇄 = 어떤 레시피인가

디지털인쇄(엽서·명함·접지카드·포토카드·상품권·배경지·전단/리플렛/봉투)는
**출력소재(종이) + 인쇄(도수) + 후가공(코팅·커팅·접지·박/형압) + 추가상품**의 합산 레시피다.
가격은 대부분 **원자합산형**(`PRF_DGP_A~F` + `COMP_PAPER`)이며, 핵심은 **siz_cd 가 완성품이
아니라 "출력판형"**(국4절 SIZ_000499 등)이라는 점이다 — 한 출력판에 완성품 여러 장을 앉히고
(판걸이수=임포지션, 앱 런타임 계산) 출력매수로 단가가 정해진다. 명함·포토카드 일부는
**고정가형**([수량행]×[옵션열] 직접단가, `PRF_NAMECARD_FIXED`·`PRF_PHOTOCARD_FIXED`).

---

## 1. 사이즈코드 (basedata)
- **인쇄 의미:** 고객이 고르는 **완성품 재단 치수**(cut_*). 디지털은 이산 소수 사이즈(엽서 100×148 등).
- **t_*:** `t_prd_product_sizes`(siz_cd) → `t_siz_sizes.cut_*`. **색/형상/수량을 siz_nm에 인코딩 금지**.
- **가르는 핵심:** 완성품 사이즈(축①) ≠ 출력판형(축④, 판형 렌즈). 같은 siz 마스터를 두 역할로 공존.

## 2. 도수 (basedata)
- **인쇄 의미:** 인쇄면 색 수(단/양면, 앞/뒷면 컬러카운트). CMYK 4도가 기본.
- **t_*:** `t_prd_product_print_options`(front/back_colrcnt_cd → CLR 5종, opt_id PK).
- **가르는 핵심:** **별색(화이트/클리어/금/은)은 도수가 아니라 공정**(축③ 인쇄옵션). 도수칸에 별색 금지.
  엑셀 `인쇄(옵션)` 컬럼이 권위. 도수 미사용 상품(화이트인쇄엽서·봉투·오리지널박명함 등)은 needed=N.

## 3. 인쇄옵션 (basedata)
- **인쇄 의미:** 별색인쇄(화이트 underbase·클리어·핑크·금·은) + 코팅·커팅·접지 같은 **잉크/표면 옵션**.
- **t_*:** `t_prd_product_processes`(별색=PROC_000007 family, **clr_cd=NULL**; 코팅·커팅·접지 공정행).
- **가르는 핵심:** 별색은 후공정 잉크(공정), 도수 아님. 코팅=공정(자재 아님). 다중 선택 가능.

## 4. 판형 (basedata)
- **인쇄 의미:** **출력 절수**(국전/46/3절). 한 판에 완성품을 앉히는 출력 치수(work_*). 임포지션/판걸이.
- **t_*:** `t_prd_product_plate_sizes`(siz_cd, output_paper_typ_cd) → `t_siz_sizes.work_*`.
- **가르는 핵심[HARD]:** **디지털인쇄 가격의 component_prices.siz_cd = 판형**(완성품 아님). 국4절=SIZ_000499.
  엑셀 `파일사양_출력용지규격` 권위. 봉투제작·썬캡 등 비판형 상품(불규칙)은 needed=N.

## 5. 자재 (basedata)
- **인쇄 의미:** 인쇄 출력 종이(스노우·아트·랑데뷰 등) + 두께(g). 디지털은 종이 1슬롯(usage_cd=공통).
- **t_*:** `t_prd_product_materials`(mat_cd, **usage_cd** 슬롯). 가격은 용지비 COMP_PAPER(comp_typ .03).
- **가르는 핵심:** 코팅·박 포일을 자재로 넣지 말 것(공정). 복합표기(`아트250+무광코팅`) 분해. 디지털 전 상품 needed=Y.

## 6. 공정 (basedata)
- **인쇄 의미:** 출력 후 물리 가공 — 모서리(라운딩)·오시(접는 줄)·미싱(절취선)·가변(번호/이미지)·박·형압.
- **t_*:** `t_prd_product_processes`(+param). 박/형압=PROC family, 코팅/커팅/접지와 별개.
- **가르는 핵심:** 타공 구수·오시 줄수=공정 param(공정 행 분리 비대화 금지, GAP-PARAM). 후가공 미사용 상품은 needed=N.

## 7. 묶음수 (basedata)
- **인쇄 의미:** 권/세트 단위(떡제본 50장=1권). 디지털 낱장 상품엔 대부분 무의미.
- **t_*:** `t_prd_product_bundle_qtys`(bdl_qty, QTY_UNIT.03=권).
- **가르는 핵심:** 페이지와 혼동 금지(다른 도메인). 엑셀 `제작수량_건수(옵션)`이 있을 때만 needed=Y(명함류 박스단위 등).

## 8. 추가상품 (cpq-link)
- **인쇄 의미:** 본 상품에 딸려 파는 별 SKU(봉투·케이스·OPP봉투 등). 별도 가격.
- **t_*:** `t_prd_product_addons`(tmpl_cd) ← `t_prd_templates`. ref_dim_cd 없음(option_items 아님).
- **가르는 핵심:** 배경지(OPP봉투/케이스 동봉)·엽서류가 추가상품 사용. 엑셀 `추가상품(옵션)` 권위.

## 9. 페이지룰 (basedata)
- **인쇄 의미:** 내지 페이지 규칙(min/max/incr·배수). 책자 내지 전용.
- **t_*:** `t_prd_product_page_rules`. 엑셀 `판수`로 추출.
- **가르는 핵심:** 디지털 낱장(엽서·명함)엔 page_rule 무의미=잡음. 접지카드 판수 표기 상품만 needed=Y.

## 10. 옵션그룹 (cpq-link)
- **인쇄 의미:** 옵션을 **선택 가능하게** 묶는 레이어(택1/택N). 주문방법(업로드/편집기)·후가공 택일 등.
- **t_*:** `t_prd_product_option_groups`(sel_typ_cd) → options → option_items(polymorphic ref_dim_cd).
- **가르는 핵심[HARD]:** option_item은 **이미 적재된 차원행을 가리키는 포인터**(L2≠L1, 차원 데이터 재적재 금지).
  디지털 전 상품이 최소 주문방법 옵션그룹을 가지므로 needed=Y(항상).

## 11. 제약규칙 (cpq-link)
- **인쇄 의미:** 교차축 불가조합·범위 제한(박 크기 min/max·가변텍스트 글자수·블리드 필수 등).
- **t_*:** `t_prd_product_constraints`(logic jsonb=JSONLogic) → `t_prd_products.constraint_json` 캐시.
- **가르는 핵심:** 모든 불가조합 enumerate 금지(최종 가격유효성=가격엔진). 엑셀 별표(*) 주석·박크기·가변 제한·블리드 표기 있을 때 needed=Y.

## 12. 추가상품 템플릿 (cpq-link)
- **인쇄 의미:** 추가상품을 SKU로 동결(base_prd_cd + size freeze). 추가상품 축의 SKU 층.
- **t_*:** `t_prd_templates`(base_prd_cd) + `t_prd_template_selections`.
- **가르는 핵심:** 추가상품(축⑧)이 있는 상품만 템플릿 needed=Y. 추가상품과 1:1 동반.

## 횡단. 가격엔진 (price-engine)
- **인쇄 의미:** 위 축들이 **가격에 어떻게 기여하는가** — 디지털=원자합산(Σ 인쇄비+용지비+후가공+코팅) 또는 고정가.
- **t_*:** `t_prd_product_price_formulas` → `t_prc_price_formulas`(frm_typ 합산/단순) → `formula_components` →
  `price_components`(comp_typ .01인쇄/.02코팅/.03용지/.04후가공/.05박형압/.06완제품) → `component_prices`(6차원 단가, **siz=판형**).
- **가르는 핵심[HARD]:** ① component_prices.siz_cd=출력판형(완성품 아님)·CASCADE FK(선존재 필수) ②
  판수=앱 런타임(DB 미저장) ③ 별색엽서·3절/국4절은 인쇄비 공식 변형(CONFIRM 큐 참조).
  디지털 전 상품 가격 산출 대상 = **항상 needed=Y**(가격 없으면 견적 불가).
