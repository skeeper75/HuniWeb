# ★중대 결함 — 밴드총액 .01 ×수량 과대청구 (2026-06-28 시뮬레이터 실증)

> 사용자 요청 "밴드수량 가족 ×qty 오모델·이중합산 시뮬레이터 점검"의 결과. **확정 결함 발견.**
> 위상: 우리 **리뉴얼 DB**(HuniProductPrice2·미배포)의 가격 데이터 결함. 라이브 구 ASP=정답(13,500).
> 진단까지 — 실 교정(prc_typ 변경)은 **돈크리티컬·인간 승인 후 dryrun→COMMIT**.

## 근본원인 (엔진 코드 + DB 데이터)
엔진 `pricing.py:193 component_subtotal`:
```
.01 단가형  → unit_price × 수량        (나눗셈 없음)
.02 합가형  → unit_price ÷ min_qty × 수량
.03 고정    → unit_price 그대로(수량무관)
```
`prc_typ_cd`(t_prc_price_components)가 **NULL이면 .01로 기본처리**(pricing.py:558·587).

**결함:** "**완제품가**" component(L2 선조립=밴드별 **총액**)들이 unit_price=**밴드 총액**인데 **PRICE_TYPE.01**로 타이핑됨 → 엔진이 **총액 × 주문수량** = 밴드크기 배수로 과대청구. (대조: 스티커 COMP_STK_PRINT는 min_qty=1·unit=장당가라 .01 정상.)

## ★시뮬레이터 실증 (PROVEN)
| 상품 | 케이스 | 매칭단가(밴드총액) | 시뮬 합계 | 정답 | 배수 |
|---|---|---:|---:|---:|---:|
| **투명명함(039)** | qty=100 | 13,500 | **1,350,000** | 13,500 | **×100 과대** |

`매칭단가 13,500 × 100 = 1,350,000원` — 엔진이 .01×qty를 그대로 실행. 라이브 구 사이트는 100매=정상가.

## 영향 바인딩 상품 (구조 동일·밴드총액 .01·완제품가·min_band>1)
### 확정 결함 클래스 (완제품가=명백한 밴드총액) — 10 상품
| prd | 상품 | min_band | 단가행=밴드총액 | ×수량 과대 |
|---|---|---:|---|---|
| 031 | 프리미엄명함 | 100 | COMP_NAMECARD_STD_S1/S2 | ×100 |
| 032 | 코팅명함 | 100 | COMP_NAMECARD_STD_S1/S2 | ×100 |
| 033 | 스탠다드명함 | 100 | COMP_NAMECARD_STD_S1/S2(3,500/4,500) | ×100 |
| 034 | 펄명함 | 100 | COMP_NAMECARD_PEARL_S1/S2(9,000~) | ×100 |
| 035 | 모양명함 | 100 | COMP_NAMECARD_SHAPE_S1/S2(18,000~) | ×100 |
| 036 | 미니모양명함 | 100 | COMP_NAMECARD_MINISHAPE_S1/S2 | ×100 |
| 037 | 오리지널박명함 | 200 | COMP_NAMECARD_FOIL_S1_STD(19,200~) | ×200 |
| 039 | **투명명함** | 100 | COMP_NAMECARD_CLEAR_S1(13,500) | **×100 실증** |
| 050 | **봉투제작** | 1000 | COMP_ENV_MAKING(48,000~152,000) | **×1000** |
| 066 | **합판도무송스티커** | 1000 | COMP_GANGPAN_PRINT(18,000~) | **×1000** |

### 검증필요 클래스 → ★라이브 확인 완료 = 전부 per-unit(.01 정상·버그 아님)
라이브 구동으로 단위기준 확정(우리 .01 산출 = unit×qty 가 라이브와 근사하면 per-unit·정상):
| prd | 상품 | 라이브 | 우리.01(unit×qty) | 판정 |
|---|---|---:|---:|---|
| 097 | 떡메모지 | 6권=16,000 | 3,000×6=18,000 | per-권 .01 정상(근사·값 미세차) |
| 145 | 미니배너 | 4장=28,000·8장=56,000(선형) | 6,500×4=26,000 | per-장 .01 정상(근사) |
| 144 | 미니보드스탠딩 | 4장=14,000·8장=28,000(선형) | 3,500×4=14,000 | per-장 .01 정상 **정확일치** |
| 094 | 엽서북 | 2권=25,200·4권=36,600 | 11,000×2=22,000 | per-book .01 정상(근사·page 결함은 별개) |

→ **검증필요 4 = 밴드총액 버그 아님**(unit_price가 per-unit). .01 유지. (떡메·미니배너·엽서북의 unit 값 미세차는 별도 소규모 점검 사항·×qty 폭증과 무관.)

## ★바인딩 12건 라이브 COMMIT 완료 (2026-06-28·인간 승인 후)
- **실행:** `bandtotal-prctyp-fix-bindings12-COMMIT.sql`(바인딩 12 한정·dryrun ROLLBACK 선검증 12행 정확). 사후 재실측=**12 component 전부 `.02`** 확인.
- **★시뮬레이터 전수 재실증 GO(라이브 huni-admin price-simulator):**
  - 투명명함 100매 = **13,500원** (교정 전 1,350,000 → ×100 과대 해소·smoking-gun 종결).
  - 스탠다드명함 백모조220 단면 100매 = **3,500원** · 1000매 = **35,000원** (`.02` 완전 선형 ÷100×qty 정확·교정 전 350,000·3,500,000).
- **되돌리지 말 것**: 단가행 verbatim 불변·prc_typ만 변경·undo=`bandtotal-prctyp-undo.sql`+`bandtotal-prctyp-undo-backup.csv` 보유.
- **잔여 미바인딩 13건(예방)** = 후속(현재 과대청구 없음). COMP_NAMECARD_{FOIL_S2_STD·FOIL_S1/S2_HOLO·COAT_S1/S2·PREMIUM_S1/S2_MGA/MGB·WHITE_S1/S2W_CL/NOCL} 등.

## ★교정 준비 완료 (dryrun 검증·실 COMMIT은 인간 승인)
- **대상 25 component**(명함 완제품가 + 봉투 + 합판·밴드총액 .01·min_qty>1): **바인딩 12(긴급·현재 과대청구)** + 미바인딩 13(잠재·예방).
  - 바인딩 12=COMP_NAMECARD_{STD_S1/S2·PEARL_S1/S2·SHAPE_S1/S2·MINISHAPE_S1/S2·FOIL_S1_STD·CLEAR_S1}·COMP_ENV_MAKING·COMP_GANGPAN_PRINT.
  - 미바인딩 13=COMP_NAMECARD_{FOIL_S2_STD·FOIL_HOLO×2·COAT×2·PREMIUM×4·WHITE×4}.
- **교정 = `prc_typ_cd .01 → .02`**(합가형·단가행 verbatim 불변). 검증: 투명명함 .02 → 13,500÷100×100=13,500 ✓·봉투 134,000÷1000×1000=134,000 ✓.
- **★.02 라이브 실증 확정(가정 아님·`price-dimension-layout-method.md` 차원 정밀배치 probe):** 명함 백모조220 단면 전 밴드 라이브=100→3,500·200→7,000·500→17,500·1000→35,000 = **완전 선형 35원/매** → .02(밴드단가÷min_qty×수량)가 전 수량 정확 일치(.03 고정이면 1000매=3,500으로 틀림). 봉투 1000~5000 라이브=DB 밴드총액 정확 일치(272,000 등) → .02 매칭밴드 정확. **단, 선형상품(명함)은 단일밴드로 충분·비선형밴드(봉투)는 전밴드 적재 필수** — 상품마다 차원배치+라이브 전밴드 probe로 확정.
- **dryrun 실행·ROLLBACK 검증 완료**(25행 .01→.02 트랜잭션 내 적용 후 롤백·실변경 0):
  - `bandtotal-prctyp-fix-dryrun.sql`(ROLLBACK 종결) · `bandtotal-prctyp-fix-COMMIT.sql`(COMMIT·★승인 후 실행) · `bandtotal-prctyp-undo.sql` · `bandtotal-prctyp-undo-backup.csv`(현재값 스냅샷).
- **실 COMMIT은 인간 승인 후**([[dryrun-vs-fix-script-commit-lesson]])·교정 후 시뮬레이터 전수 재실증(투명명함 13,500 등) 필수.

## 교정 명세 (인간 승인 후·dryrun→COMMIT)
- **확정 10 상품의 밴드총액 component를 `prc_typ_cd` `.01`→`.02`(합가형) 변경.**
  - 검증: 투명명함 .02 → 13,500 ÷ 100 × 100 = **13,500** ✓ (밴드 정확). 봉투 1000 → 134,000÷1000×1000=134,000 ✓.
  - .02는 min_qty 필수(전부 보유)·중간수량은 per-unit 환산(밴드÷min_qty×qty)으로 합리적.
  - 영향: t_prc_price_components 약 12~16 comp_cd의 prc_typ_cd UPDATE. 단가행 불변(verbatim).
- **검증필요 4**: 라이브 단위기준 확정 → 총액이면 .02, per-unit이면 .01 유지.
- **부차 관찰(별도 점검):** 박명함 FOIL 4 component가 use_dims=["min_qty"]만 → 판별차원 없이 동시매칭/중복합산 가능성(이중합산 2차 위험). 검증 권고.
- 라우팅: 실 교정 = §7 dbmap COMMIT(인간 승인)·webadmin 코드 미변경. 교정 후 시뮬레이터 전수 재실증(투명명함 13,500 등).

## 의의
- 사용자 우려("합가 잘못 접근=의도와 다름")가 **실재 확정** — 밴드총액을 ×qty(단가형)로 본 전형적 합가 오류.
- 라이브 교차검증(구 ASP=정답 13,500)이 우리 리뉴얼 DB의 100~1000배 과대를 **배포 전 적발**. = 교차검증 오라클의 핵심 가치 입증.
- 단가/합가 공식 확정(`price-formula-live-confirmation.md`)의 규칙 4(밴드수량=밴드 lookup·×qty 아님) 위반 사례.
