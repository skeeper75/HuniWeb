# Huni-DBMap round-2(가격 매핑) 핸드오프

> **⚡ [2026-06-06 활성 트랙] CPQ 컨피규레이터 설계 → `10_configurator/HANDOFF.md` 참조.** 현 스키마를 상품 컨피규레이터(옵션·제약·추가상품 템플릿)로 확장하는 새 트랙. 설계 정본 + 2상품(일반현수막·프리미엄엽서) 종단 인스턴스화·적대검증 완료(CONDITIONAL-GO). 본 문서(round-2 가격매핑)·`HANDOFF-audit.md`(round-3 적재)는 보존.

작성: 2026-06-04 · 다음 세션이 이 문서만 읽고 이어가도록 정리. 식별자/코드는 영어, 설명 한국어.

## 0. 한 줄 현황

가격엔진 **구조해석·준비도 평가·결정7건 확정·첫 파일럿(굿즈파우치) 검증 완료** + **어색데이터 전수 교차매핑(product-viewer) 완료·후니 확정요청서 산출 + v2 반영**. **v2: 후니가 면적/사이즈 치수 전건 등록 → D-C(면적치수) 해소(599→366 findings)**. **D-E(일자형식) 확정·후속정정 완료(전 CSV `2026-06-01` 통일) / D-D(완제품비 `.06`) 확정(1안) / D-A·B(색상자재·variant귀속) 후니 등록 대기**. **D-D 데이터 반영 완료**(손거울 comp_typ_cd→`.06` + `t_cod_base_codes.csv` 코드행 신설). 다음은 **D-A/B 후니 등록 대기 → 고정가형 확대 → 원자합산형(엽서) 파일럿**. **DB 미적재 유지**(CSV·md만).

> [다음 세션 시작점] 본 §0 + §10(어색데이터 교차매핑)부터 읽을 것. 미결 의사결정은 §10.3.

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
7. apply_ymd=**`2026-06-01`**(yyyy-MM-dd, **D-E 확정**·AWK-8 해소). 전 적재 CSV 통일 완료.
8. **완제품 유형 단정 금지**.
9. **round-1 통합**(구간할인 재매핑 금지).
10. **완제품가 comp_typ_cd=`PRC_COMPONENT_TYPE.06 완제품비`**(D-D 확정·AWK-7 해소). `t_cod_base_codes` 자식 1행 신설(DDL 무변경, 코드행 INSERT=적재CSV/후니등록). 2경로: 단독판매가→product_prices(규칙④) / 합산·단순형 공식 통가격 구성요소→component.comp_typ_cd=.06. **`.06`(가격항목)≠`PRD_TYPE.01 완제품`(상품분류) — 별개 축, 이름만 겹침. 실데이터 PRD_TYPE.01=0건. 상품유형으로 가격경로 단정 금지**.

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

> [확장] AWK-1~9는 **product-viewer 전수 스캔(v2 366 findings)으로 모집단이 확장·재정리됨 → §10 참조**. AWK-6→105건(~60종), AWK-5→55건, AWK-8→D-E로 확정, AWK-7→D-D로 검토완료, **AWK-4/면적치수→v2 해소**. NEW(잔존) 패턴 125건(인쇄모드·별색마커·단양면자재; 면적치수 결손은 v2 해소).

## 8. 다음 작업 (순서)

1. ✅ **D-D 최종확정 완료**(1안) — 완제품비 `.06` 코드 신설 + 2경로 규칙. dbm-price-formula 규칙10 신설 반영.
2. ✅ **D-E 후속 반영 완료** — apply_ymd `2026-06-01`(yyyy-MM-dd) 확정. dbm-price-formula 규칙7 갱신 + 전 적재 CSV(round-1 `load/` 134행 + round-2 `load_price_pilot/` 5행 = 138행) `20260601`→`2026-06-01` 정정·검증(잔존0).
3. ✅ **D-D 데이터 반영 완료** — ⓐ 손거울 `COMP_GDS_SQMIRROR.comp_typ_cd` NULL→`.06`(규칙10 경로②) + price-pilot-goods.md `:35` 근거 갱신, ⓑ `PRC_COMPONENT_TYPE.06 완제품비` 코드행 CSV 신설(`load_price_pilot/t_cod_base_codes.csv`). FK 정합 검증 ✓(코드행→price_components 선후). 파일럿 CSV 6→7종. AWK-7 전 문서 해소 반영.
4. **D-A/B 후니 등록 대기** — 색상자재(mat_cd)·variant 귀속은 후니 측 실데이터 등록 필요(차단). 등록 도착 시 매핑. (D-C 면적치수는 **v2에서 후니 등록 해소**.)
5. **B. 고정가형 확대** — 상품액세서리 등 동일 패턴(단가+round-1 구간할인). D-A/B 비차단 상품부터 가능.
6. **C. 원자합산형 파일럿** — 엽서(별색=공정·단/양면·판걸이수 변환·풀엔진 4단 검증). 참조시트 7개(디지털인쇄비/코팅/출력소재/인쇄후가공/판걸이수/박대형/디지털인쇄). D-D 확정(완료) → 착수 가능.

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
│   └ product-viewer/  findings.csv(366·v2)·findings-classified.csv(366+분류3컬럼)
│                      awkward-crossmap.md(규칙→가격영향+AWK커버리지)·huni-confirmation-request.md(결정요청서 D-A~F)
└ HANDOFF.md (이 문서)
```
입력원본: `docs/huni/product-viewer-데이터불일치 체크용_v2.html`(**현행 v2**, 51행 `const P` JSON=products280·findings366·data280). v1(`…체크용.html`, findings599)은 SIZE_DIMS_NULL 233 미해소본=참고용. 추출: `sed -n '51p' <html> | sed 's/^const P = //; s/;$//' > /tmp/pv2.json` 후 jq. 산출 findings.csv/findings-classified.csv는 **v2(366) 기준**.
하네스: `.claude/skills/dbm-price-formula`(규칙1~9)·`huni-dbmap-orchestrator`. 메모리: dbmap-round2-price-engine·dbmap-no-db-load-file-first.

---

## 10. 어색데이터 전수 교차매핑 (이번 세션 A작업, 2026-06-04)

### 10.1 무엇을 했나
후니 **데이터 불일치 점검 뷰어**(`docs/huni/product-viewer-…html`)의 전수 스캔을 round-2 **가격매핑 영향도**로 분류하고 기존 AWK-1~9에 교차매핑 → 후니 **확정 요청서** 산출. DB 미적재·스키마 무변경. **이후 후니가 v2(`…_v2.html`) 제공 → 반영 완료**.

**v1→v2 변화(검증됨)**: 후니가 **모든 size의 작업·재단 치수(work/cut dims) 전건 등록** → `SIZE_DIMS_NULL` 233건 전건 해소(치수 null 잔존 0). findings **599→366**(제거 233·신규 0·수정 0). 근거: PRD_000001 SIZ_000078 ww/wh/cw/ch null→70/200/70/200. **나머지 9규칙 불변**.

findings(v2) 4차원: **siz**(81: SIZE_NAME_NOISE만, SIZE_DIMS_NULL 0)·**mat**(179: COLOR_IN_NAME 68·SIZE_ONLY 45·COLOR_ONLY 27·PRINTSIDE_ONLY 19·SHAPE_ONLY 10·ATTR_COMBO 10)·**po**(63: PRINTSIDE_INVALID)·**plt**(43: PLATE_FILETYPE_FREEFORM). sev: high 61(전부 mat)·mid 144·warn 118·low 43.

### 10.2 분류 결과 (`findings-classified.csv`, v2 366건, 집합 일치 검증 0 불일치)
- price_impact: **DIRECT 160 · INDIRECT 125 · NONE 81** (=366) ← v1 246/272/81에서 SIZE_DIMS_NULL(면적86 DIRECT·고정가147 INDIRECT) 해소
- needs_huni: **Y 242 · N 124** ← v1 328/271
- 분류기준: **DIRECT 160 = mat variant축 전부**(색상/형태/용량 자재 미해소), SIZE_NAME_NOISE=NONE(장수 noise), 별색마커 PLATE_FILETYPE·인쇄모드 PRINTSIDE_INVALID·단양면자재=INDIRECT(가격 fallback 존재).
- AWK 커버리지: AWK-3(variant35)→mat160 확장 / AWK-5→자재슬롯혼재55 / AWK-6(머그색상)→105건(~60종) 대폭확장. **AWK-4·N-1 면적치수=v2 해소**. NEW(잔존) 125건.

### 10.3 후니 결정 5종 + 상태 (`huni-confirmation-request.md`)
| 결정 | 내용 | 건수 | AWK | 상태 |
|------|------|------|-----|------|
| **D-A** | 색상/마감 자재(mat_cd) 등록 vs 색상별 SKU 분리 | 105/~60종 | AWK-6확장 | 🔴 **미결**(후니 실무 등록, DIRECT 차단) |
| **D-B** | 용량/개수/사이즈 variant 차원 귀속(siz_cd/bdl_qty/mat_cd) | 55/~25종 | AWK-5확장 | 🔴 **미결**(후니 등록, DIRECT 차단) |
| **D-C** | 면적상품 work/cut 치수 등록(29종) | 86→0 | NEW | ✅ **해소(v2)** — 후니 치수 전건 등록 |
| **D-D** | 완제품가 comp_typ_cd 처리 | 구조 | AWK-7 | ✅ **확정(1안)·데이터 반영 완료**: `.06 완제품비` 신설 + 2경로 규칙(규칙10). 손거울 `.06` + 코드행 CSV 신설(§8-3) |
| **D-E** | apply_ymd 일자 형식 표준 | 구조 | AWK-8 | ✅ **확정·정정완료: `yyyy-MM-dd`(2026-06-01)** 전 CSV 통일 |

**D-A 권고**: 색상/마감이 가격에만 영향·디자인 동일 → `t_mat_materials`에 색상자재 등록 후 mat_cd variant(스키마 무변경, product_prices PK 충돌 회피). 별색(화이트/클리어/핑크/금은)은 D-A 아님=공정(규칙①).
**D-B 권고**: 용량/치수(온스·ml·인치·S/M/L)→siz_cd, 개수/세트(2구·2개1세트)→bdl_qty, 형태(원/사각)→옵션/mat_cd. 파우치 S/M/L은 round-1 product_sizes 재사용(신규매핑 금지, 규칙⑨).
**D-C ✅ 해소(v2)**: 후니가 모든 size의 work/cut 치수를 등록함(면적상품 29종 포함, 치수 null 잔존 0). 면적매트릭스형 가격입력 결손 해소 → 추가 결정 불요. 단 면적형 매핑 착수 시 **완제품을 면적형으로 단정 금지(규칙⑧)** 원칙은 유지 — 일부는 고정가일 수 있어 상품별 가격방식 확인.

**[D-D — ✅ 확정완료(1안), 2026-06-04]**
- 확인결과: `PRC_COMPONENT_TYPE`=`t_cod_base_codes`의 **부모그룹**(현 자식 5종 .01인쇄/.02코팅/.03용지/.04후가공/.05박형압), `t_prc_price_components.comp_typ_cd`=varchar(50) **nullable FK→t_cod_base_codes**. **`.06 완제품비` = `t_cod_base_codes` 자식코드 1행 INSERT**(DDL 무변경이나 코드행 적재 필요).
- 핵심 뉘앙스 = 완제품가 **2경로**: ①단독 최종판매가→`t_prd_product_prices`(comp_typ_cd 무관, 규칙④) / ②합산·단순형 공식의 통가격 구성요소→`t_prc_price_components.comp_typ_cd=.06`(기존 NULL 정상화).
- **추가 확인(사용자 지적)**: `PRC_COMPONENT_TYPE.06 완제품비`(가격항목 축)와 `PRD_TYPE.01 완제품`(상품분류 축, `t_prd_products.prd_typ_cd`)은 **이름만 겹치는 별개 축** — 다른 부모그룹·테이블·FK, DDL 영향 0. 실데이터 `ref-products.csv` 280상품 중 **PRD_TYPE.01=0건**(.02반제품28/.03기성124/.04디자인128). `.06`은 상품유형과 독립, 상품유형으로 가격경로 단정 금지(규칙⑧·⑩).
- **확정 = (1)안**: `.06` 신설 + 2경로 규칙 명문화. dbm-price-formula **규칙10 신설** 반영 완료.

### 10.4 D-E 확정 후속 (✅ 완료, 2026-06-04)
apply_ymd=`yyyy-MM-dd` 확정 → ⓐ dbm-price-formula **규칙7 갱신 완료**(확정), ⓑ round-1 적재 CSV `02_mapping/load/`(discount_details 35행·discount_tables 99행) `20260601`→`2026-06-01` 정정 완료, ⓒ round-2 파일럿 CSV(price_formulas/product_prices/component_prices 5행) 동일 정정 완료, ⓓ 문서 2종(price-pilot-goods.md·mapping-spec.md D2/표) 표기 갱신. 전 산출물 잔존 `20260601` 0건 검증.
