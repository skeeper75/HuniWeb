# 박류 파일럿 적재본 — 프리미엄명함 PRD_000031 (소형)

> hpe/dbm-load-builder 산출 · 2026-06-30 · **DB 미적재(COMMIT 0)·라이브 읽기전용+롤백전용 DRY-RUN만**.
> 권위: `engine-design-foil.md` REV4 + `golden-cases-foil.md` + `webadmin-dim-editor-foil-fit.md` +
> 권위 단가 `06_extract/price-foil-small-l1.csv`(verbatim·날조 0). 엔진=`raw/webadmin/catalog/pricing.py`.

## 1. 범위 (PILOT = 소형 1상품)

소형 박 comp 3종 + **PRD_000031 등록 박색상(037~044) 단가행** + 분기 공식 바인딩만.
**미터치**: 대형 comp·다른 6상품(027/029/034/042/069/070)·명함박(PRD_000037·PRF_NAMECARD_FOIL).

## 2. 산출 comp + 행수

| comp_cd | 의미 | prc_typ | use_dims | 단가행 | 출처 |
|---|---|---|---|---|---|
| `COMP_FOIL_SETUP_SMALL` | 소형 동판비(셋업) | PRICE_TYPE.03 FLAT | `["proc_cd"]` | **8** | small-l1 B01 5,000 verbatim |
| `COMP_FOIL_PROC_SMALL_STD` | 소형 일반박 가공비 | PRICE_TYPE.03 FLAT | `["proc_cd","siz_width","siz_height","min_qty"]` | **1,620** | B02 면적격자 ⋈ B03 등급단가 verbatim |
| `COMP_FOIL_PROC_SMALL_SPECIAL` | 소형 특수박 가공비 | PRICE_TYPE.03 FLAT | `["proc_cd","siz_width","siz_height","min_qty"]` | **540** | B02 ⋈ B05 특수박 verbatim |

**component_prices 합계 = 2,168행.** 행수 분해:
- SETUP 8 = (STD 6색 + SPECIAL 2색) × 5,000 고정(siz/min_qty NULL=수량·면적 무관).
- PROC_STD 1,620 = 6색 × 15 면적셀(가로3×세로5) × 18 수량밴드.
- PROC_SPECIAL 540 = 2색 × 15 면적셀 × 18 수량밴드.

### PRD_000031 박색상 라우팅 (라이브 SELECT·등록 037~044만 충전)
- **일반박(STD)** 등록 6색: 금유광038·은유광039·먹유광040·동박041·적박042·청박043.
- **특수박(SPECIAL)** 등록 2색: 홀로그램037·트윙클044.
- **제외**: 펄박045·백박046 = PRD_000031 **미등록** → 단가행 미생성(사용 불가 색상 과금 0·task RULE).

## 3. flatten 메커니즘 (grade 소멸·엔진 off-grid ceiling이 대행)

면적격자(B02: 가로×세로→등급 A~E)와 등급단가표(B03/B05: 등급×수량→단가)를 적재 전 결정론 join →
`(proc_cd, siz_width, siz_height, min_qty)→단가` 1단 면적매트릭스. **grade는 note 추적용**(매칭 비사용).
- siz_width/height = 면적셀 티어 상한값('이하' 경계) → 엔진 `match_component` ceiling 이 off-grid를 각 축
  독립 처리(아크릴 277행 동형·`04_validation/offgrid-flatten-validation-foil.md` GO).
- prc_typ = **.03 FLAT** → `component_subtotal` 이 `return up,up`(×qty 0)·off-band 수량도 band total
  (REV3 `.02`의 off-band 과청구 제거·검증가 적발).
- min_qty = 구간하한 NOT NULL(band 선택용·.03은 곱셈만 생략).

## 4. 바인딩 = 분기 공식 (형제 032/033 보호)

PRD_000031 본체 공식 `PRF_NAMECARD_FIXED` 는 **031·032·033 공유**(032=코팅명함·033=스탠다드·박 비대상).
공유 공식에 박 comp를 직접합산하면 32/33 시뮬레이터/구성요소 목록에 박이 노출된다(가격은 proc_cd 게이트로
안 새나 표시 오염). → **분기 공식 채택**(Q-FOIL-FRM1):

1. `PRF_NAMECARD_FIXED_FOIL` 신설 = `PRF_NAMECARD_FIXED` 의 본체 2 comp(`COMP_NAMECARD_STD_S1/S2`) 복제
   + 박 3 comp 추가(formula_components 5행).
2. PRD_000031 만 새 공식으로 재바인딩(`t_prd_product_price_formulas` 시계열 새 행 `apply_bgn_ymd=2026-07-01`).
   기존 2026-06-01 행은 미터치(롤백 안전·엔진은 최신 적용일 선택).
3. **형제 032/033 미영향**(공유 공식 PRF_NAMECARD_FIXED 그대로).

> **대안(채택 안 함)**: 공유 공식 직접합산 + proc_cd 게이트도 가격은 안전(박 미선택 0)하나 32/33 노출
> 부담이 있어 분기가 더 깨끗. 분기는 nesting 아닌 평탄합산(명함박/접지카드 라이브 작동 패턴)이라
> 엔진 완전 지원(공식→공식 참조 스키마 부재·`webadmin-dim-editor-foil-fit.md` §B 입증).

### proc_cd 게이트 (박 미선택 0 보장)
동판비·박가공비 단가행 전부 proc_cd 충전 → 박 미선택 주문은 `selections["proc_cd"]` 미충전 → no_match → 0.
(동판비 use_dims에 proc_cd 필수·명함박 SETUP `["min_qty"]` 답습 금지·codex R-FOIL-CDX1.)

## 5. FK 위상순서 (적재 단계)

1. `t_prc_price_components` (3 comps) — component_prices·formula_components 의 부모
2. `t_prc_component_prices` (2,168행) — comp_cd·proc_cd 부모 전부 라이브 실재
3. `t_prc_price_formulas` (PRF_NAMECARD_FIXED_FOIL)
4. `t_prc_formula_components` (5행: 본체 2 + 박 3)
5. `t_prd_product_price_formulas` (재바인딩 1행)

**코드행 선적재 불요**: PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 전부 라이브 `t_cod_base_codes` 실재.

## 6. 멱등성 (NOT EXISTS NULL-safe)

라이브 `ux_t_prc_comp_prices_nat_key` UNIQUE 인덱스가 **NULLS DISTINCT**(`indnullsnotdistinct=f`) →
박 단가행은 siz_cd/mat_cd/opt_cd/clr_cd 가 NULL 이라 `ON CONFLICT` 가 안 잡힌다(NULL≠NULL).
∴ 전 INSERT 를 **`NOT EXISTS … IS NOT DISTINCT FROM`** 가드로 작성(재실행 0행). comp_price_id=IDENTITY
BY DEFAULT(미지정·자동채번). reg_dt=now() DEFAULT(미지정).

## 7. 파일

| 파일 | 용도 |
|---|---|
| `gen_foil_pilot.py` | **결정론 flatten 생성기**(단가 verbatim·재현가능). `--sql/--body/--undo/--provenance/--rows` |
| `foil-pilot-namecard031-load.sql` | 적재본(BEGIN→`\i body`→**COMMIT 주석**·ROLLBACK 종료). 승인 후 COMMIT 주석 해제 |
| `foil-pilot-namecard031-body.sql` | 순수 INSERT 본문(트랜잭션 미포함·load/dryrun 이 `\i`·17,344 INSERT) |
| `foil-pilot-namecard031-dryrun.sql` | **멱등 DRY-RUN**(BEGIN→body 2회→delta=0 판정→ROLLBACK·라이브 무변경) |
| `foil-pilot-namecard031-undo.sql` | UNDO(COMMIT 후 회수·FK 역순·다른 데이터 미영향) |
| `foil-pilot-namecard031.provenance.csv` | 각 단가행 → 권위 셀 역추적(2,168행·검증가용) |
| `golden_recalc.py` | 골든 재계산(pricing.py match_component 순수함수 추적) |

실행(승인 전·전부 ROLLBACK·라이브 안전):
```
cd 03_design/pilot-load
psql ... -v ON_ERROR_STOP=1 -f foil-pilot-namecard031-dryrun.sql   # 멱등 DRY-RUN
python3 golden_recalc.py                                            # 골든 재계산
```
> `_rows.sql` 가 있으면 `--rows` 초기 테스트 잔여물(무해)·삭제 가능.

## 8. 검증 결과

### DRY-RUN (라이브 BEGIN…ROLLBACK·2026-06-30 실행)
- PASS 1: 전 INSERT 성공 — **FK·NOT NULL·CHECK 위반 0**(exit 0).
- PASS 2: 전 statement `INSERT 0 0`(NOT EXISTS 가드) → delta(comp_prices·components·formula_comps·binding)
  전부 **0** → **`IDEMPOTENT: PASS`**. 종료 `ROLLBACK`(라이브 무변경).
- 카운트 실측: SETUP 8 · PROC_STD 1620(6 proc) · PROC_SPECIAL 540(2 proc) · components 3 · formula 1 ·
  formula_comps 5 · binding(2026-07-01) 1 — 설계와 정확 일치.

### 골든 재계산 (소형·match_component 순수함수)
| 케이스 | 입력 | 동판비 | 박가공비 | 합계 | 권위 | 판정 |
|---|---|---|---|---|---|---|
| **G-F4** | STD 금유광 40×80 q1000 | 5,000 | 64,000(E) | **69,000** | 69,000 | ✅ PASS |
| **G-F5** | SPECIAL 트윙클 10×10 q200 | 5,000 | 14,300(A) | **19,300** | 19,300 | ✅ PASS |
| **G-F8** | STD 먹유광 40×40 q500 | 5,000 | 32,500(D) | **37,500** | 37,500 | ✅ PASS |
| **G-F9 off-band** | STD 금유광 40×80 **q850** | 5,000 | 52,800(E@800) | **57,800** | 57,800 | ✅ PASS |
| OFF-X 회귀 | STD 금유광 40×80 **q899** | 5,000 | 52,800(E@800) | **57,800** | 57,800 | ✅ PASS |
| GATE0 가드 | 펄박045(미등록) q1000 | — | no_match | **박 0** | 박 0 | ✅ PASS |

- **off-band ×qty 폭발 가드**: q800=q850=q899=**52,800**(전부 E@800 band·flat). `.02`였다면 56,100/59,334
  과청구 → `.03 FLAT` 교정 회귀 가드 통과.
- **proc_cd 게이트**: 미등록 색상(펄박045) → 동판비·박가공비 둘 다 no_match → 박 0(사용 불가 색상 과금 0).
- 라이브 시뮬레이터 실호출은 **post-COMMIT** 으로 연기(아직 행 미적재) — 본 순수함수 재계산이 대행.

## 9. 블로커 / 잔여

- **없음(파일럿 범위 내)**. 코드행 선적재 불요·DDL 불요(신규 테이블 0·기존 스키마 컬럼 적재).
- 동형 전파 시: 대형 comp(C-1/C-3/C-4) + 책자/접지 5상품은 별 파일럿. 2단접지027/책자069·070 박영역
  상한 >170 정책 = Q-FOIL-SIZE2 실무 컨펌 후.
- **실 COMMIT = 인간 승인 후** dbm-validator R1~R6 게이트 통과 → load.sql COMMIT 주석 해제. 본 산출은 검증까지.
