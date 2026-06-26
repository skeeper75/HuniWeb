# BIND_ONLY 교정 명세 + 적재 큐 (게이트 종합)

검증일 2026-06-26 · hsp-set-gate. 결함 명세 = {결함·권위 정답·교정·대상 t_*·돈영향·라우팅·인간 승인}.

## 트랙 A — GO 적재 큐 (6건 · load-executor)

| prd | 공식 | apply_bgn_ymd | 근거 |
|-----|------|---------------|------|
| PRD_000157 아크릴네임택 | PRF_CLR_ACRYL | 2026-06-15 | 등록 siz_cd 전건 ceiling 행 실재·PRICE≠0 |
| PRD_000158 아크릴포카키링 | PRF_CLR_ACRYL | 2026-06-15 | 등록 1사이즈 covered |
| PRD_000159 아크릴코스터 | PRF_CLR_ACRYL | 2026-06-15 | 등록 2사이즈 covered |
| PRD_000160 아크릴자유형스탠드 | PRF_CLR_ACRYL | 2026-06-15 | 등록 5사이즈 covered |
| PRD_000161 판아크릴 | PRF_CLR_ACRYL | 2026-06-15 | 등록 2사이즈 covered |
| PRD_000162 아크릴포카스탠드 | PRF_CLR_ACRYL | 2026-06-15 | 등록 1사이즈 covered |

- 대상 t_*: `t_prd_product_price_formulas` INSERT 6행. SQL = `bind-only-fix.sql`의 해당 6 prd만 추출(멱등 NOT EXISTS·DRY-RUN PASS).
- 돈영향: 견적 0원(현재 공식 미바인딩) → 정상 PRICE 산출. 과대/과소청구 없음(단가 verbatim).
- 인간 승인: **필요**(라이브 COMMIT). 게이트 GO이므로 load-executor 적재 큐로.

## 트랙 B — CONDITIONAL (10건 · 부분커버 / 매트릭스 보강 후 바인딩)

147·148·149·150·151·152·155·156·164·166.

- **결함**: 자기 등록 차원(nonspec 범위 또는 등록 siz_cd)의 일부가 본체 단가 매트릭스에 **행 미존재(no_tier_row) → 그 구간 견적 0원**. 미커버 24~57%(166은 등록사이즈 100% 미커버).
- **권위 정답**: 인쇄상품 가격표(260527) 아크릴 면적표 — 각 상품 차원범위 전체에 단가가 정의돼야. 현 라이브 매트릭스는 희소(특정 (w,h) 쌍만).
- **돈영향[크리티컬]**: 바인딩만 하면 covered 구간은 정상이나 **hole 구간은 PRICE=0(0원 견적)** — 운영 시 손님이 0원 주문 가능. ★단, 동형 선례 PRD_000146(라이브)도 동일(35% 홀)이므로 "신규 회귀"는 아님(운영 기존 리스크와 동급).
- **교정 2안(택일·인간/자율 판정)**:
  - **B1 부분커버 고지 하 바인딩** — 트랙 A와 동일 INSERT(SQL 안전·멱등). 단 hole 구간 0원 리스크를 146 선례와 함께 수용. 위젯/시뮬레이터에서 nonspec 입력을 매트릭스 격자로 제한(incr=NULL→격자 강제)하면 hole 회피 가능(별 트랙).
  - **B2 매트릭스 격자 보강 후 바인딩** — `t_prc_component_prices`(COMP_ACRYL_CLEAR3T·COMP_ACRYL_COROTTO)에 누락 (w,h) 행을 가격표(260527) 권위대로 추가 → 전 차원 covered 후 바인딩. 대상 t_*: component_prices INSERT(단가 가격표 verbatim). 라우팅 = **dbmap 적재 트랙 / §18**. 인간 승인 필요(단가 신규).
- **166 특이**: nonspec=N(siz_cd 모드)인데 등록 사이즈 43x71이 ceil 50x80 미커버. siz_cd 모드는 엔진이 w/h 미주입(price_simulator.html:360)이라 **실엔진에선 width/height 차원 자체가 selections에 없어 더 위험**(0으로 비교→최소행 오매칭 가능). 166은 ① 매트릭스에 50x80 추가 or ② 등록사이즈 재검토 선결. 라우팅 = §18/dbmap.

## 엔진 한계 발견 (횡단 — 별 트랙 고지)

nonspec_yn=N(siz_cd 선택형) 면적매트릭스 상품은 시뮬레이터가 siz_width/siz_height를 주입하지 않음(price_simulator.html:360은 nonspec일 때만 주입). 즉 siz_cd 모드 + 면적매트릭스 본체 comp는 엔진에서 w/h 차원이 비어 `_tier_order_val`=None→cmp_val=0→**항상 최소 사이즈 행 선택**(line 151) 위험. 157~162가 게이트 harness에선 cut_width/height 공급 가정으로 GO였으나, **실 시뮬레이터 경로에선 최소행 오매칭(과소청구) 가능**.
→ 권고: 면적매트릭스 본체를 쓰는 상품은 nonspec_yn=Y(자유치수 입력)로 운영하거나, siz_cd→siz_width/height 주입 로직을 엔진/뷰에 추가. 라우팅 = §6 위젯/§18·webadmin 코드 트랙(코드 직접수정은 인간 승인). 이 게이트 범위 밖(고지만).

## 라우팅 요약

- GO 6건 → load-executor 적재 큐(인간 승인 후 COMMIT).
- CONDITIONAL 10건 → B1(부분커버 수용 바인딩) or B2(매트릭스 보강·dbmap/§18) — 인간/자율 결정.
- 엔진 w/h 미주입 한계 → §6/§18·webadmin 코드 트랙(게이트 밖·고지).
- DB COMMIT 0(게이트는 COMMIT 안 함). DRY-RUN 롤백전용 실증만.
