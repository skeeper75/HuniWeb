# 가격엔진 통합 이해 — 5장치 역할 + 조합 메커니즘

> Phase 2 통합 진단 (리더 종합) · 2026-06-18 · huni-price-engine-diag
> 입력: `01_mechanism/`(역할 원리 정의·지식맵) + `02_code_schema/`(코드↔DB 속성 정합)
> 권위 순서[HARD]: ① 라이브 코드(pricing.py 동작) ② 라이브 스키마/데이터 ③ 설계 산출물(prcx01 — **STALE 확인**, 의도 배경만) ④ 인쇄 도메인.

## 1. 5장치 역할 (확정 정의)

| 장치 | 역할 (한 줄) | 책임 차원 | 확신도 |
|------|------------|----------|:--:|
| **가격공식** `t_prc_price_formulas`(+바인딩 `t_prd_product_price_formulas`) | **값 없는 레시피 헤더** — 상품→구성요소 묶음 진입점. frm_typ 폐기, 공식=항상 합산 | (없음·묶음만) | 확정·코드 |
| **가격구성요소** 마스터 `t_prc_price_components`+배선 `t_prc_formula_components`+단가행 `t_prc_component_prices` | **원자 비용 항목 정의(use_dims·prc_typ) + 차원조합별 실제 단가 룩업**(7,293행). ★가격의 모든 차원 책임이 여기 | siz/mat/proc/print_opt/coat/bdl/siz_wh/min_qty/dim_vals | 확정·코드 |
| **할인테이블** `t_dsc_*` | base 산출 후 **수량구간→등급 순차 후처리**(곱/차감). 가격 구성 아닌 후처리 | 수량구간·등급 | 확정·코드 |
| **가격뷰어** `price_viewer`·`price_diagram` | **적재 확인 읽기 UI** — 계산 안 함 | — | 확정·코드 |
| **가격시뮬레이터** `price_simulator`→`evaluate_price` | **선택값+수량→실견적 실행** — 위젯·주문과 동일 단일 알고리즘 호출(자기 로직 없음) | (전부 호출) | 확정·코드 |

**권위 골격**: 단일 알고리즘 `pricing.py:evaluate_price` / 우선순위 템플릿단가→직접단가→공식 / 공식=구성요소 단순 합산 / 차원=단가행 정확매칭(NON_QTY_DIMS)·티어(siz_w/h·min_qty) / 단가형·합가형 환산 / 할인 후처리 순차곱.

## 2. 조합 메커니즘 (파일럿 3상품군)

- **엽서(합산형)**: 공식 1개가 17 구성요소(인쇄·코팅·용지·후가공) 묶음 → 각 구성요소가 자기 차원으로 단가행 룩업 → **단순 합산**. 차원 책임: 인쇄=print_opt_cd(도수)·용지=siz_cd+mat_cd·코팅=coat_side_cnt.
- **현수막/실사(면적매트릭스)**: 본체 구성요소가 `[siz_width][siz_height]` 티어 매트릭스 셀 단가(ceiling) + 가공 add-on 합산.
- **아크릴(면적+두께)**: 단일 합가형 구성요소 `[siz_width,siz_height,mat_cd]` (mat_cd=두께축, 면적축과 직교) ÷min_qty×qty.

## 3. ★ 결정적 발견 (두 에이전트 교차정합)

### F-1 [🔴] 설계 산출물이 STALE — 권위로 쓰면 오판
`prcx01-pricing-model.md`(LOCKED 2026-05-27)·`pricing-erd.md` 둘 다 **8차원·clr_cd·frm_typ_cd 시절**. 실제는 14차원으로 진화, 도수 폐기 미반영. **검증의 자(尺)는 라이브 information_schema + pricing.py이며, 설계 문서는 "의도 배경"으로만**(차원·할인은 stale이라 권위 금지).

### F-2 [🔴] 도수 차원 전환: clr_cd(설계) → print_opt_cd(실제)
- `clr_cd` = **dead-data** (설계 prcx01 §6 인쇄비 핵심 차원인데 코드 NON_QTY_DIMS에서 빠지고 라이브 **0/7293행**. sql/28이 도수→인쇄옵션 전환·clr행 424 DELETE).
- 실제 도수 매칭 = `print_opt_cd`(1431행).
- ★ **직전 검증(huni-price-quote)의 N-1a "칼라CMYK 행 부재" 혼란의 근원이 바로 이 차원 전환.** 도수를 clr_cd로 찾으면 0행, print_opt_cd로 찾아야 함.

### F-3 [🔴] addtn_yn(가산여부) dead — 공식=항상 전 합산, 차감 불가
설계(pricing-erd "Y=합산")의 합산/차감 핵심 플래그를 **pricing.py가 전혀 안 읽음**. 라이브 301행 전부 채워졌으나 무시 → 공식=항상 전 구성요소 합산. **차감형 구성요소 표현 불가.**
- ★ **직전 검증의 D-1/D-2/D-3 이중합산과 직결**: 잘못 배선된 `_2L/_3L` comp를 차감/배제할 엔진 수단이 없으니, 배선된 것은 무조건 합산된다. 즉 이중합산 결함은 "addtn_yn 무시 + 의미축 이중 인코딩"의 합작.

### F-4 [🟡] dim_vals phantom-DDL — repo 재구축 시 누락 위험
공정 상세 `{키:값}` 정확매칭의 핵심인데 정식 `ADD COLUMN` DDL이 sql/에 0건(인덱스 식에서만 등장). 라이브 310행·코드·models.py:194 정합하나, **repo 재구축 시 컬럼 누락 위험**(frm_typ 제거와 동형의 ad-hoc 라이브 적용).

### F-5 [🟡] 데이터 레벨 dead 경로
템플릿단가·직접단가·등급할인 3경로는 **코드 정상이나 라이브 데이터 0행**. → 검증·이해는 **FORMULA + 수량구간할인** 경로에 집중해야 유효(다른 경로는 현재 미발화).

### F-6 [🟡] dsc_typ_cd DDL 위치 stale / proc_grp 토큰 비대칭
- 할인유형 컬럼: DDL(sql/01a:242)은 details에 선언, 라이브·코드는 master에. 코드·라이브 정합, DDL만 stale.
- `proc_grp:`/`opt_grp:` 스코프 토큰을 pricing.py 두 곳이 비대칭 처리(:413 opt_grp만 / :460 일반) → 36 comp "판별차원 없음" 오라벨 가능성. **추가 추적 필요.**
