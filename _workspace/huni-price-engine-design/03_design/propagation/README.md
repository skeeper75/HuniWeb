# 박류 동형 전파 적재본 — 6상품 (대형 5 + 펄명함 소형 1)

> hpe/dbm-load-builder 산출 · 2026-06-30 · **DB 미적재(COMMIT 0)·라이브 읽기전용+롤백전용 DRY-RUN만**.
> 권위: `engine-design-foil.md` REV4 + `golden-cases-foil.md` + 검증가 GO `04_validation/offgrid-flatten-validation-foil.md`.
> 단가 verbatim = `06_extract/price-foil-large-l1.csv`(날조 0). 엔진 = `raw/webadmin/catalog/pricing.py`.
> 파일럿 패턴 답습 = `03_design/pilot-load/`(PRD_000031 소형·이미 COMMIT). **명함박 PRD_000037·파일럿 031 미터치.**

## 1. 범위 (6상품)

| prd_cd | 상품 | 시트 | base 공식 | 분기 공식 | 박 comp |
|---|---|---|---|---|---|
| PRD_000034 | 펄명함 | **소형** | PRF_NAMECARD_PEARL | PRF_NAMECARD_PEARL_FOIL | 기존 SMALL 3 (재사용·신규 단가행 0) |
| PRD_000029 | 3단접지카드 | 대형 | PRF_DGP_E | PRF_DGP_E_FOIL | LARGE 3 |
| PRD_000027 | 2단접지카드 | 대형 ⚠️ | PRF_DGP_E | PRF_DGP_E_FOIL (029와 공유 분기) | LARGE 3 |
| PRD_000042 | 프리미엄쿠폰 | 대형 | PRF_DGP_A | PRF_DGP_A_FOIL | LARGE 3 |
| PRD_000069 | 무선책자 | 대형 ⚠️ | PRF_BIND_MUSEON | PRF_BIND_MUSEON_FOIL | LARGE 3 |
| PRD_000070 | PUR책자 | 대형 ⚠️ | PRF_BIND_PUR | PRF_BIND_PUR_FOIL | LARGE 3 |

⚠️ = 박영역 상한 >170 CONFIRM (Q-FOIL-SIZE2·아래 §9).
펄명함034는 소형이라 기존 라이브 `COMP_FOIL_*SMALL*`(파일럿 적재분) 재사용 — **신규 단가행 0**, 공식 분기 + 바인딩만.

## 2. 신규 대형 comp 3종 (search-before-mint·라이브 0건 확인)

| comp_cd | 의미 | prc_typ | use_dims | 단가행(등록색상) |
|---|---|---|---|---|
| `COMP_FOIL_SETUP_LARGE` | 대형 동판비(셋업) | PRICE_TYPE.03 FLAT | `["proc_cd","siz_width","siz_height"]` | **512** = 64 면적셀 × 8색 |
| `COMP_FOIL_PROC_LARGE_STD` | 대형 일반박 가공비 | PRICE_TYPE.03 FLAT | `["proc_cd","siz_width","siz_height","min_qty"]` | **3,328** = 64셀 × 13밴드 × 4색 |
| `COMP_FOIL_PROC_LARGE_SPECIAL` | 대형 특수박 가공비 | PRICE_TYPE.03 FLAT | `["proc_cd","siz_width","siz_height","min_qty"]` | **3,328** = 64셀 × 13밴드 × 4색 |

**component_prices 신규 합계 = 7,168행.** (소형 펄명함은 기존 행 재사용·신규 0.)

### prc_typ = .03 FLAT (검증가 적발 .02→.03 교정 반영)
박가공비는 작업 1건 고정금액(수량 이미 밴드에 반영)이라 `.03`(×qty 0). `.02`였다면 off-band 수량(예 q1500)에서 과청구. 동판비도 1회성 .03. (검증가 `offgrid-flatten-validation-foil.md` §c-2.)

## 3. 등록 색상 라우팅 (6상품 전수 라이브 SELECT·2026-06-30 = PROC_000037~044 8종)

대형 색상 그룹(engine-design §2-3·large-l1 B03/B05 제목 verbatim):
- **일반박(STD)** 6색 정의: 금유광038·금무광048·은유광039·은무광049·동박041·청박043.
  → 등록 4색만 충전: **038·039·041·043** (048·049 6상품 미등록 → 단가행 미생성).
- **특수박(SPECIAL)** 6색 정의: 먹유광040·백박046·홀로37·트윙클044·적박042·녹박047.
  → 등록 4색만 충전: **037·040·042·044** (046·047 미등록 → 단가행 미생성).

★사용 불가 색상에 과금 안 함(task RULE). 6상품이 모두 동일 8색 등록이라 대형 comp는 union(=8색) 1벌·상품별 노출은 CPQ/공식 게이트가 처리.

## 4. flatten 메커니즘 (grade 소멸·엔진 off-grid ceiling 대행)

대형 면적격자 B02/B04(8×8 가로×세로→등급 A~E·일반/특수 동일) × 등급단가표 B03 일반/B05 특수(등급×13수량밴드→단가)를 적재 전 결정론 join → `(proc_cd, siz_width, siz_height, min_qty) → 단가` 1단 면적매트릭스. **grade는 note 추적용**(매칭 비사용·dim_vals empty).
- siz_width/height = 면적셀 티어 상한('이하' 경계) → 엔진 `match_component` ceiling이 off-grid 각 축 독립 처리(아크릴 277행 동형).
- 동판비 = B01 64셀(가로×세로)·min_qty NULL(수량무관·1회). proc_cd 충전(미선택 게이트).
- 박가공비 min_qty = 구간하한 NOT NULL(.03 band 선택용).

## 5. 분기 공식 = 형제 보호 (Q-FOIL-FRM1 파일럿 패턴)

공유 base 공식에 박을 직접 합산하면 박 비대상 형제에 박 노출(가격은 proc_cd 게이트로 안 새나 표시 오염). → **base 클론 + 박 comp 추가**:
- 각 분기 공식 = base의 라이브 `formula_components` **충실 클론**(disp_seq·addtn_yn verbatim·NULL 보존) + 박 comp 3행 append.
- 027·029는 같은 base(PRF_DGP_E)→같은 분기(PRF_DGP_E_FOIL) 1벌 생성, 바인딩만 둘.
- 042는 PRF_DGP_A(10상품 공유) 클론 → **042만 재바인딩**(나머지 9상품 base 그대로).
- 재바인딩 = `t_prd_product_price_formulas` 시계열 새 행 `apply_bgn_ymd=2026-07-01`(기존 base 행 미터치·엔진 최신 적용일 선택). 형제 공유공식 전부 보존.

### proc_cd 게이트 (박 미선택 0)
동판비·박가공비 단가행 전부 proc_cd 충전 → 박 미선택 주문은 `selections["proc_cd"]` 미충전 → no_match → 0. (codex R-FOIL-CDX1·명함박 SETUP `["min_qty"]` 답습 금지.)

## 6. FK 위상순서

1. `t_prc_price_components` (대형 3 comp)
2. `t_prc_component_prices` (7,168행·proc_cd 부모 037~044 라이브 실재)
3. `t_prc_price_formulas` (분기 3종: PRF_NAMECARD_PEARL_FOIL·PRF_DGP_E_FOIL·PRF_DGP_A_FOIL·PRF_BIND_MUSEON_FOIL·PRF_BIND_PUR_FOIL = 5)
4. `t_prc_formula_components` (base 클론 + 박)
5. `t_prd_product_price_formulas` (6 재바인딩)

**코드행 선적재 불요**: PRICE_TYPE.03·PRC_COMPONENT_TYPE.05/.01 전부 라이브 실재. **DDL 불요**: 기존 컬럼 적재(신규 테이블 0).

## 7. 멱등 (NOT EXISTS NULL-safe)

라이브 `ux_t_prc_comp_prices_nat_key`가 NULLS DISTINCT(`indnullsnotdistinct=f`) → 박 단가행은 siz_cd/mat_cd/opt_cd/clr_cd NULL이라 ON CONFLICT 안 잡힘 → 전 INSERT를 **NOT EXISTS … IS NOT DISTINCT FROM** 가드로 작성(재실행 0행). comp_price_id=IDENTITY BY DEFAULT·reg_dt=now() DEFAULT·del_yn='N' DEFAULT.

## 8. 파일

| 파일 | 용도 |
|---|---|
| `gen_foil_prop.py` | 결정론 flatten + 분기공식 생성기(단가 verbatim). `--body/--undo/--provenance` |
| `foil-prop-body.sql` | 순수 INSERT 본문(트랜잭션 미포함·7,220 INSERT) |
| `foil-prop-load.sql` | 적재본(BEGIN→`\i body`→**COMMIT 주석**·ROLLBACK 종료). 승인 후 COMMIT 주석 해제 |
| `foil-prop-dryrun.sql` | 멱등 DRY-RUN(BEGIN→body 2회→delta=0 판정→ROLLBACK·라이브 무변경) |
| `foil-prop-undo.sql` | UNDO(COMMIT 후 회수·FK 역순·다른 데이터 미영향) |
| `foil-prop.provenance.csv` | 각 단가행 → 권위 셀 역추적(7,168행) |
| `golden_recalc_large.py` | 대형 골든 재계산(pricing.py 순수함수 추적·10케이스) |

실행(승인 전·전부 ROLLBACK·라이브 안전):
```
cd 03_design/propagation
psql ... -v ON_ERROR_STOP=1 -f foil-prop-dryrun.sql   # 멱등 DRY-RUN
python3 golden_recalc_large.py                         # 골든 재계산
```

## 9. 검증 결과 + 블로커

### 골든 재계산 (대형·match_component 순수함수·10/10 PASS)
| 케이스 | 입력 | 동판비 | 박가공비 | 합계 | 권위 | 판정 |
|---|---|---|---|---|---|---|
| G-F1 | STD 금유광 90×90 q1000 | 18,000 | 120,000(C) | **138,000** | 138,000 | PASS |
| G-F2 | SPECIAL 홀로 90×90 q1000 | 18,000 | 150,000(C) | **168,000** | 168,000 | PASS |
| G-F3 | STD 은유광 30×30 q10 | 11,000 | 55,000(A) | **66,000** | 66,000 | PASS |
| G-F7 | SPECIAL 백박→먹유광 170×170 q1000 | 64,000 | 250,000(E) | **314,000** | 314,000 | PASS |
| G-F6 off-grid | STD 75×85→ceil 90×90 q1000 | 18,000 | 120,000(C) | **138,000** | 138,000 | PASS |
| G-F10 off-band | STD 90×90 q1500(band1000) | 18,000 | 120,000 | **138,000** | 138,000 | PASS(.03 FLAT) |
| q899 회귀 | STD 90×90 q899(band500) | 18,000 | 100,000 | **118,000** | 118,000 | PASS(.02면 과청구) |
| 박-미선택 | proc_cd=None q1000 | — | no_match | **0** | 0 | PASS |
| 미등록 백박046 | direct q1000 | — | no_match | **0** | 0 | PASS |

★ **G-F7 주의**: 권위 골든의 박색상 백박046은 6상품 **미등록** → 단가행 미생성. 동일 SPECIAL E단가(먹유광040 등 등록색상)로 314,000 재현 = 단가는 색상 무관·grade/qty만(B05 검증). 백박046 직접 호출은 의도대로 0.

### off-band ×qty 폭발 가드
q500=q899=**118,000**(둘 다 band500·flat). `.02`였다면 q899=100000÷500×899=179,800 과청구 → `.03 FLAT` 회귀 가드 통과.

### DRY-RUN (라이브 BEGIN…body 2회…ROLLBACK·2026-06-30·**완주 PASS**·`foil-prop-dryrun-result.txt`)
- **실행**: `foil-prop-dryrun.sql` 라이브 `-v ON_ERROR_STOP=1`(body 2회 `\i`·멱등 delta·ROLLBACK). **exit 0**.
- **PASS 1 카운트 실측**(설계와 정확 일치): `COMP_FOIL_SETUP_LARGE 512 · COMP_FOIL_PROC_LARGE_STD 3328 · COMP_FOIL_PROC_LARGE_SPECIAL 3328` = 7,168.
- **PASS 2 멱등**: `d_prices 0 · d_comps 0 · d_formulas 0 · d_fc 0 · d_bindings 0` → **`IDEMPOTENT: PASS`**.
- **제약위반 0**(exit 0·ERROR 0 → FK·NOT NULL·CHECK·UNIQUE 위반 없음)·종료 **ROLLBACK**(라이브 무변경·커밋 누출 0).
- 확정 게이트(R1/R5)는 dbm-validator 재실행 위임(생성≠검증).

### 블로커 / CONFIRM
- **박영역 상한 CONFIRM (Q-FOIL-SIZE2·실무 컨펌 대기·돈크리티컬 아님·적재 가능)**:
  - PRD_000027 2단접지카드 트림 170×220 (세로 220 > 대형격자 170)
  - PRD_000069 무선책자 / PRD_000070 PUR책자 트림 A4 210×297 (양축 > 170)
  - 박영역(실제 박 크기)은 트림보다 작아 대부분 대형 격자(≤170) 안. >170 박영역 시 엔진 `ERR_ABOVE_MAX`. 위젯 박영역 입력 상한을 트림(또는 대형격자 max 170)으로 캡 — 실무 컨펌 후 위젯 트랙. **단가/적재 자체는 CONFIRM 무관(격자 안 박영역은 정확)**.
- **실 COMMIT = 인간 승인 후** dbm-validator R1~R6 게이트 통과 → load.sql COMMIT 주석 해제. 본 산출은 검증까지.
