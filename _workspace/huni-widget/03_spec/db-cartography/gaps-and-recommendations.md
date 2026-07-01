# gaps-and-recommendations.md — 갭 분류 + hw-architect/hw-builder 권고

> 파이프라인 ③' 컨버전 선행. 권위 `docs/huni/table-spec_260619.html` + 라이브 스냅샷(2026-07-01).
> 갭 3분류: **(A) 어댑터 흡수** / **(B) 위젯 계약 변경 필요** / **(C) DB 작성·교정 필요(§7 인간 승인)**.
> 목표 = 위젯 가시 계약 변경 0(어댑터가 흡수). (C)·추가 스키마 실 적용은 §7 dbmap 인간 승인.

## (A) 어댑터 흡수 가능 — 계약/위젯 무변경 (대부분)

| # | 갭 | 어댑터 처리 |
|---|----|-------------|
| A1 | CPQ polymorphic ref_dim 환원 | option_items.ref_dim_cd → 가격요청 차원키(siz/plt/mat/proc/print_opt) 환원. 응답 시 opt_cd round-trip echo |
| A2 | 필수공정 자동주입(mand_proc_yn=Y) | hidden-essential 공정(PROC_000004 인쇄 base 등)을 렌더 안 하고 evaluate_price selections에 자동 포함 |
| A3 | 판형(plt_siz_cd) 비노출 | product_plate_sizes.dflt_plt_yn='Y'를 어댑터가 자동 채움(위젯 미선택·파일럿 실측: prod_dims에 plate 미노출) |
| A4 | hidden-essential 표시여부 | view_yn 컬럼 부재 시 disp_seq<0 관례로 visible=false 도출 |
| A5 | unit 라벨 환원 | qty_unit_typ_cd → t_cod_base_codes.cod_nm |
| A6 | 도수→색수 평면화 | print_options.front/back_colrcnt → clr_color_counts.chnl_cnt → priceColorCount |
| A7 | sides 도출 | semi_role_cd + t_prd_product_sets 구성원 → [default,inner] |
| A8 | 제약 JSONLogic 파싱 | t_prd_product_constraints.logic → disableRules/visibilityRules |
| A9 | 공정 입력메타 파싱 | proc_processes.prcs_dtl_opt(jsonb inputs) → finish 내부 InputSpec·attb |
| A10 | editor_partner 단정 | editor_partner_cd NULL+editor_yn='Y' → edicus fallback(다중 에디터 전까지) |
| A11 | vat/shipping 산정 | evaluate_price는 base만 — vat/shipping은 어댑터/BFF 산정 |
| A12 | PRICE=0 진단 | final_price=0 시 priceUnavailableReason 채움(침묵 금지) |

## (B) 위젯 계약 변경 필요 — hw-architect 권고 (단순성 우선 최소화)

| # | 갭 | 권고 | 상태 |
|---|----|------|------|
| B1 | (현재 없음) | 위젯 계약(`04_build/src/contract/*`)은 colorHex/imageUrl/badge/addColorCapable/colorSide/attb/itemGroup을 **이미 OPTIONAL 필드로 보유**(2026-06 보강). DB만 채우면 됨 → (C). | ✅ 계약 변경 불요 |

> **목표 달성**: 위젯 가시 계약 변경 0건. 위젯 계약은 후니 추가 메타를 이미 OPTIONAL slot으로 수용. 갭은 전부 어댑터(A) 또는 DB(C).

## (C) DB 작성·교정 필요 — §7 dbmap 인간 승인

| # | 갭 | 조치 | 라우팅 |
|---|----|------|--------|
| C1 | 자재 colorHex/imageUrl/add_clr_yn 부재 | `added-schema-260701.sql` ALTER t_mat_materials | §7 dbmap·인간 승인 |
| C2 | 옵션 badge 표준 enum 부재 | ALTER t_prd_product_options.badge_cd + BADGE_TYPE 기초코드 | §7 dbmap·인간 승인 |
| C3 | 에디터 파트너 분기 부재 | ALTER t_prd_products.editor_partner_cd + EDITOR_PARTNER 기초코드 | §7 dbmap·인간 승인 |
| C4 | 공정 view_yn 명시 부재 | ALTER t_prd_product_processes.view_yn (선택·A4로 흡수 가능) | §7 dbmap·선택 |
| C5 | **디지털인쇄비 영구 0** (COMP_PRINT_DIGITAL_S1) | PROC_000004 base 공정 단가행/배선 충전 — 저청구 교정 | §7/§26·인간 승인 ([[digital-print-base-proc-missing-260701]]) |
| C6 | 위젯 세션/장바구니/주문 테이블 부재 | 커머스 바인딩 UNDECIDED — 추가 안 함 | 스코프 밖(BFF/커머스 결정) |
| C7 | Edicus psCode/templateUrl/token 컬럼 부재 | DB 비보관(보안·런타임 발급) | BFF 책임·DB 추가 안 함 |
| C8 | NormalizedOrderReadiness 서버 검수 | 서버 doc 검수 로직 부재 | 서버/BFF 책임 |

## OPEN (미해결)

- **O1**: PRD_000041 인쇄비 0(C5)은 final_price를 용지비만으로 PRICE≠0 유지하나 정답 미달(저청구). 위젯 골든은 통과하나 §26 교정 전까지 인쇄비 누락 — 디지털인쇄 W-CASCADE 전파 전 §26 교정 권고.
- **O2**: W-AREA/W-SET/W-ADDON/W-FIX 클래스 종단 파일럿 미수행(이번은 디지털인쇄만). 재호출 시 각 클래스 대표 1개 종단.
- **O3**: editor_partner(C3) — 후니가 Edicus 외 에디터 없으면 A10(어댑터 단정)으로 충분. partner 컬럼은 다중 에디터 대비 선제 권고.

## 인계

- **hw-architect**: db-contract-mapping.md(매핑 매트릭스)·added-schema-260701.{sql,md}(추가 스키마)·gaps(B 0건·C 8건)를 후니 어댑터 명세(`data-adapter.md` 후니 arm) 갱신 입력으로. 계약 변경 권고 0(목표 달성).
- **hw-builder**: `digital-print/pilot-PRD_000041.md` NormalizedProduct + golden을 `createHuniAdapter` fixture 후보·구현 입력으로. round-trip echo 검증 대상=opt_cd/mat_cd/proc_cd/siz_cd/print_opt_cd.
- **hw-qa**: evaluate-price-contract.md 골든(PRICE≠0: 307/2581/12814/467)·CPQ 환원 e2e를 검증 기준으로.
- **§7 dbmap**: (C1~C5) 추가 스키마/교정 인간 승인 후 적재.
