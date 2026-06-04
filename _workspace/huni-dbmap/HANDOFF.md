# Huni-DBMap round-2(가격 매핑) 핸드오프

작성: 2026-06-04 · 다음 세션이 이 문서만 읽고 이어가도록 정리. 식별자/코드는 영어, 설명 한국어.

## 0. 한 줄 현황

가격엔진 **구조해석·준비도 평가·결정7건 확정·첫 파일럿(굿즈파우치) 검증 완료**. 다음은 **어색데이터 후니 확정 → 색상 variant 보강 → 고정가형 확대 → 원자합산형(엽서) 파일럿**. **DB 미적재 유지**(CSV·md만).

## 1. 절대 원칙 (HARD)

- **DB 적재 절대 금지**(INSERT/UPDATE/DDL). 산출=적재용 CSV + 설계 md까지만.
- **라이브 DB 반복조회 최소화**. 필요시 read-only 1회 추출→CSV 저장 후 그 파일로 작업(`00_schema/ref-*.csv` 이미 추출됨).
- **스키마 변경 금지**. 기존 테이블/컬럼으로만 매핑. 코드/자재 부족=데이터 추가 또는 보류(스키마 불변).
- 산출 .md는 **한국어**, 식별자/컬럼/코드/SQL은 영어. 파일에 **매핑 근거(왜)** 명시.
- 접속정보 `.env.local`의 `RAILWAY_DB_*`만. `_workspace`(git추적)에 비밀값 금지.

## 2. 가격 구조 (핵심 이해)

가격 = 3형태 결합: (가)수량×단가 (나)수량구간할인 (다)여러유형 결합.
```
최종가 = base 단가(상품/사이즈/옵션별)  ×  수량  ×  (1 − 수량구간할인율)
          └ round-2 (현재 작업, t_prc_*)       └주문      └ round-1 (이미 매핑완료, t_dsc_*)
```
- **완제품을 단일유형으로 단정 금지**(고정가 등). 완제품은 여러 방향으로 쓰임.
- 굿즈/파우치·문구·아크릴=수량구간할인 상품 → **round-1이 이미 DSC_GOODSA/B·문구·아크릴 할인+상품링크 매핑**. round-2는 **base 단가만**, 구간할인 재매핑 금지.

## 3. 가격엔진 구조 (요약, 상세=`00_schema/price-engine-ddl.md`)

- 4단 엔진: `t_prc_price_formulas`(공식)→`t_prc_formula_components`→`t_prc_price_components`(구성요소)→`t_prc_component_prices`(6차원 단가) + 상품바인딩 `t_prd_product_price_formulas`/`t_prd_product_prices`(상품단가).
- component_prices 6차원: siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty + 자연키 UNIQUE8. apply_ymd NOT NULL. max_qty 없음(상향개방).
- 코드: FRM_TYPE{.01합산형/.02단순형}, PRC_COMPONENT_TYPE{.01인쇄/.02코팅/.03용지/.04후가공/.05박형압}, clr 5종(별색 없음).
- **최신 스펙 `docs/huni/table-spec_260603.html`=라이브 정합**(260602는 stale). 적재 컬럼명=라이브 DDL(frm_typ_cd/comp_typ_cd/unit_price).

## 4. 확정 결정 (dbm-price-formula 스킬 규칙 1~9 = 권위)

1. **별색=공정**(`PROC_000007 별색인쇄`+화이트/클리어/핑크/금색/은색), clr 아님. 단가=디지털인쇄비 F~O 그대로. 박=`PROC_000033`+17자식.
2. **단/양면**=각 시트 단가 그대로, 양면≠단면×2. 코팅=coat_side_cnt, 인쇄=별도 comp_cd.
3. **variant 가격**=component_prices 차원(사이즈→siz_cd, 색상/재질→mat_cd). product_prices 아님. 스키마 변경0.
4. **합가**=t_prd_product_prices, 단가공존시 합가 그대로(이중원천 방지).
5. 면적형 곱셈·할인=공식 외부.
6. 단가=component_prices.
7. apply_ymd=**20260601**(round-1 정합). 형식표준 미확정(AWK-8).
8. **완제품 유형 단정 금지**.
9. **round-1 통합**(구간할인 재매핑 금지).

## 5. 계산공식집 27블록 (매핑 척추, `02_mapping/mapping-readiness.md`)

원자합산형 10 · 고정가형 15 · 면적매트릭스형 2. 블록별 참조시트 식별 완료.
- 비가격 시트(매핑 대상 아님): 판걸이수(변환계수)·굿즈파우치구간할인(round-1)·후가공_박(백업)(중복). → `01_excel/price-sheet-scope.md`.
- 별색단가 위치: `디지털인쇄비` F~O(5종, 단가 2프로파일).

## 6. 파일럿 현황 (`02_mapping/price-pilot-goods.md`)

굿즈파우치 3상품, 검증 13/13 PASS, DB 미적재:
- 레더코스터(PRD_000188, 3300) → `t_prd_product_prices` (단일 단가)
- 사각손거울(PRD_000186, S/M/L=5000/5500/6000) → `t_prc_component_prices` siz_cd(SIZ_000384/386/388) + 단순형 공식
- 머그컵(PRD_000193) → **보류**(색상 mat_cd 부재 AWK-6)
- 적재 CSV: `02_mapping/load_price_pilot/` 6종.

## 7. 어색한 데이터 (`03_validation/price-awkward-data.md`, AWK-1~9)

후니 확정 필요: **AWK-6**(머그 색상 자재 등록), **AWK-7**(완제품가 comp_typ_cd 유형 신설 여부), **AWK-8**(apply 일자 형식 yyyyMMdd vs yyyy-MM-dd 표준). 기타: AWK-1 미등록상품5, AWK-3 variant35, AWK-5 사이즈칸 옵션혼재.

## 8. 다음 작업 (택1)

- **A. 어색데이터 후니 확정** → AWK-6/7/8 결정 후 색상 variant(mat_cd) 보강 + apply 형식 통일
- **B. 고정가형 확대** — 상품액세서리 등 동일 패턴(단가+round-1 구간할인)
- **C. 원자합산형 파일럿** — 엽서(별색=공정·단/양면·판걸이수 변환·풀엔진 4단 검증). 참조시트 7개(디지털인쇄비/코팅/출력소재/인쇄후가공/판걸이수/박대형/디지털인쇄)

## 9. 산출물 지도

```
_workspace/huni-dbmap/
├ 00_schema/  price-engine-ddl.md(구조)·price-engine-ddl-raw.txt·price-engine-fk-refs.md
│             ref-{products,sizes,materials,product-processes,product-sizes}.csv(읽기전용 참조)
│             schema-overview.md·columns.csv·code-values.md(round-1)
├ 01_excel/   price-sheet-scope.md(시트 범위)·discount-brackets.csv(round-1)
├ 02_mapping/ mapping-readiness.md(준비도+결정7건)·price-pilot-goods.md(파일럿)
│             load/(round-1 할인 CSV)·load_price_pilot/(round-2 가격 CSV 6종)
├ 03_validation/ price-awkward-data.md(AWK-1~9)·validation-report.md(round-1)
└ HANDOFF.md (이 문서)
```
하네스: `.claude/skills/dbm-price-formula`(규칙1~9)·`huni-dbmap-orchestrator`. 메모리: dbmap-round2-price-engine·dbmap-no-db-load-file-first.
