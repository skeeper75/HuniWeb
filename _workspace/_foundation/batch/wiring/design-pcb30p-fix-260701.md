> ★ 상태 정정 (2026-07-01 2차 — 가격표 재확인) — 한때 SUPERSEDED 표기했으나 **단품 정합 관점에서 본 설계는 유효**.
> 근거: 인쇄상품 가격표(260527) 엽서북떡메 시트 = 단품 완제품 단가표(사이즈×단면양면×20P/30P×수량). 라이브 단가행
> COMP_PCB_S1/S2_20P·30P 와 **verbatim 일치**(100x150 단면: 2부11,000·100부4,500·1000부2,290 등). 094 셋트구성
> (내지095+표지096)은 생산정보·가격은 완제품 통째(책자류 정찰가). 페이지(20/30)=단가표 축→단가행 판별 필요.
> ★본 설계(30P print_opt 충전 + page 판별 + 배선)가 단품 정합에 정확. 단 page_rule(셋트 내지 입력)은 가격 미사용.
> 잔여 결정[운영]: webadmin이 094를 셋트로 다뤄 simulate_set 경로(0원)를 타는 충돌 정리 = 094 단품 운영 전환(§23/§7).
> 재진단 상세 `diag-pcb30p-set-live-260701.md` §가격표재확인. 아래 원문 유효(opt_cd page 판별 = webadmin 내 유일 경로).

# 엽서북30p PRD_000094 배선 설계 — NO-GO 폐루프 보정 (페이지축 선택수단 교체)

- 보정 대상: `gate-design-260701.md` NO-GO(엽서북30p·선택수단 무효·20p 회귀위험) + `codex-design-260701.md` ISSUE-1(OPT_000080 충돌)·ISSUE-2(opt_cd 선택수단 경로 불일치).
- 입력 원본: `design-bind-fold-board-260701.md §A`·`design-bind-fold-board-dryrun.sql §A`(보정 전).
- 권위 단가 = `live-snapshot`/라이브 `t_prc_component_prices`(가격표260527 verbatim). 엔진 = `pricing.py _row_matches`(L94)·`price_views.py _opt_cd_options`(L726/762).
- 작업: **설계 명세까지**(실 COMMIT 없음·DB 미적재·생성≠검증). 단가 verbatim(날조 0). 산출 2026-07-01 · 재검증은 후속 hpe-validator/codex 패스.

---

## 0. 보정 요약 (먼저)

검증이 적발한 3결함을 designer 폐루프로 교체. **배선·disjoint·골든 데이터는 원설계 그대로 정확**(E1/E2/E6 PASS) — 결함은 오직 **선택수단 메커니즘**과 **채번**. 그 둘만 교체하면 GO.

| 결함 (검증 적발) | 원설계 (NO-GO) | 보정 (GO) |
|---|---|---|
| **D1. 페이지 선택수단 무효** | `t_prd_product_option_items(ref_dim_cd='opt_cd')` — opt_cd는 ref_dim 도메인(OPT_REF_DIM.01·03~07)에 **없는 무효 코드**. selections['opt_cd'] 환원 0. | **`t_prd_product_options`(opt_grp+OPV) 직접 INSERT** → `_opt_cd_options`(price_views L732/762) → selections['opt_cd']=OPV. **명함037·ACRYL_BADGE 라이브 실증 경로.** option_items/ref_dim 경로 폐기. |
| **D2. 20p 회귀 위험** | 20P 234행에 opt_cd 충전하나 선택수단이 opt_cd 미공급 → selections=None ↔ 행 non-NULL → **20P까지 no_match PRICE=0**. | **페이지 옵션그룹 dflt=20P·mand_yn=Y** → 미선택 시 widget가 20P 자동공급 → 20P 행 매칭 22,000 불변. 선택수단·행충전·배선을 **단일 BEGIN…COMMIT 원자묶음**(창 없음). |
| **D3. OPT_000080 채번 충돌** | OPT_000080(페이지수) — 명함037이 080(박종류)·040이 081(코팅) 선점. 동일 코드 두 의미. | **OPT_000082**(라이브 MAX=OPT_000079 재확인·명함 080/081 회피) + 옵션값 **OPV_000491/000492**(MAX OPV=OPV_000486·명함 487~490 회피). |

라이브 재확인(읽기전용): `MAX(opt_grp_cd)=OPT_000079` · `MAX(opt_cd)=OPV_000486` · `ref_dim_cd` 도메인 = `OPT_REF_DIM.01,03,04,05,06,07`(opt_cd 부재 — D1 확정).

---

## 1. 현황 실측 (라이브 재측정)

| 항목 | 실측값 | 함의 |
|---|---|---|
| PRF_PCB_FIXED 배선 | S1_20P(seq1)·S2_20P(seq2)만 | 30P 2건 고아(미배선) → 30p 손님 = 20p가로 청구(저청구). |
| 094 옵션그룹 | OPT_000030~037(사이즈/내지종이/내지인쇄/표지종이/표지인쇄/표지코팅/제본/셋트구성) | **페이지수 그룹 없음** → 손님이 20p/30p 선택 불가(mint 정당). |
| 094 print_options | POPT_000001 단면·POPT_000002 양면 (둘 다 등록) | **단/양면 선택수단 이미 존재** — 페이지축만 신설하면 됨. |
| S1_20P / S2_20P 행 | 각 117행·opt_cd ALL NULL·print_opt ALL 충전 | 20P = opt_cd만 채우면 됨. |
| S1_30P / S2_30P 행 | 각 117행·opt_cd ALL NULL·**print_opt ALL NULL** | 30P = opt_cd + print_opt 둘 다 채워야 함. |
| use_dims | 20P=[siz_cd,min_qty,print_opt_cd]·30P=[siz_cd,min_qty] | 4 comp 모두 +opt_cd(+opt_grp 스코프) 갱신. |

---

## 2. price_formulas — search-before-mint [HARD]

- **PRF_PCB_FIXED 재사용**(신규 공식 mint 0). 엽서북 고정가 공식. 유형 = 고정가/단가형(PRICE_TYPE.01: subtotal = unit_price × qty).
- search 결과: 라이브 페이지/장수 옵션그룹 0건(`grep 페이지|장수|면수` none, 094 옵션그룹 8종에 부재) → 페이지축 **신규 mint 정당**(무손실 표현 불가 입증). mint 범위 = opt_grp 1 + 옵션값 2뿐.

## 3. formula_components → price_components (배선·차원)

PRF_PCB_FIXED ← 4 comp 모두 배선(disjoint이라 형제 동시합산 0):

| seq | comp_cd | addtn_yn | 의미축 | prc_typ | 판별차원 use_dims |
|---|---|---|---|---|---|
| 1 | COMP_PCB_S1_20P | Y | 완제품가(단면·20P) | 단가형.01 | siz_cd·min_qty·**print_opt_cd**·**opt_cd**·opt_grp:OPT_000082 |
| 2 | COMP_PCB_S2_20P | Y | 완제품가(양면·20P) | 단가형.01 | 〃 |
| 3 | COMP_PCB_S1_30P | Y | 완제품가(단면·30P) | 단가형.01 | 〃 |
| 4 | COMP_PCB_S2_30P | Y | 완제품가(양면·30P) | 단가형.01 | 〃 |

(seq3·seq4 = 신규 INSERT. opt_grp:OPT_000082 = UI 그리드 스코프 태그·엔진 매칭 무시 — 명함 패턴 mirror.)

## 4. component_prices — 단가행 그릇 (값 verbatim·판별 컬럼만 충전)

단가값 **변경 0**. 판별 컬럼(opt_cd·print_opt_cd)만 채움(멱등 IS NULL 가드):

| comp_cd | 행수 | print_opt_cd | opt_cd(page) | 동작 |
|---|---|---|---|---|
| COMP_PCB_S1_20P | 117 | (기충전 POPT_000001) | ← OPV_000491(20P) | opt_cd만 |
| COMP_PCB_S2_20P | 117 | (기충전 POPT_000002) | ← OPV_000491(20P) | opt_cd만 |
| COMP_PCB_S1_30P | 117 | ← POPT_000001(단면) | ← OPV_000492(30P) | 둘 다 |
| COMP_PCB_S2_30P | 117 | ← POPT_000002(양면) | ← OPV_000492(30P) | 둘 다 |

## 5. 선택수단 — 페이지수 옵션그룹 [HARD·D1·D2 보정]

★**명함037 패턴 = `t_prd_product_options`(복합PK prd_cd+opt_cd) 직접 INSERT** — `_opt_cd_options`가 이 테이블에서 읽어 selections['opt_cd']=OPV 공급(price_views L732/762, ACRYL_BADGE opt_cd=OPV_000466/467 라이브 실증·명함 E4 PASS 동일 경로). option_items/ref_dim_cd 경로 **폐기**.

```
t_prd_product_option_groups: PRD_000094 · OPT_000082 '페이지수' · SEL_TYPE.01(택1) · min=1 max=1 · mand_yn='Y' · use_yn='Y'
t_prd_product_options:
  PRD_000094 · OPV_000491 'OPT_000082' '20P' · dflt_yn='Y'   ← 미선택 시 기본(20p 회귀방지)
  PRD_000094 · OPV_000492 'OPT_000082' '30P' · dflt_yn='N'
```

- **dflt=20P + mand_yn=Y** = D2 핵심. 위젯/시뮬레이터가 mand 옵션그룹을 dflt='Y'로 사전선택 → 손님이 손 안 대도 selections['opt_cd']=OPV_000491(20P) → 20P 행 매칭 → **22,000 불변**. (엔진은 default 자동주입 안 함 — selections 공급자=client. 이 계약은 ACRYL_BADGE/명함 검증 PASS로 입증된 경로와 동일 = 패리티로 건전.)
- **원자성**: 선택수단 INSERT → 행 충전 → 배선을 **하나의 BEGIN…COMMIT**에 묶음. 행에 opt_cd 차 있고 옵션은 없는 중간창 0(검증가 우려한 "무작동 선택수단과 충전 동시 COMMIT=결함" 회피).

## 6. disjoint 진리표 [HARD·자가검증]

엔진은 PRF_PCB_FIXED의 4 comp 전부 평가·합산. 행 신호 (print_opt_cd, opt_cd):

| comp | print_opt | opt_cd(page) | (POPT1,20P) | (POPT2,20P) | (POPT1,30P) | (POPT2,30P) |
|---|---|---|---|---|---|---|
| S1_20P | POPT1 | OPV491(20P) | **■ 매칭** | print≠ | page≠ | 둘≠ |
| S2_20P | POPT2 | OPV491(20P) | print≠ | **■ 매칭** | 둘≠ | page≠ |
| S1_30P | POPT1 | OPV492(30P) | page≠ | 둘≠ | **■ 매칭** | print≠ |
| S2_30P | POPT2 | OPV492(30P) | 둘≠ | page≠ | print≠ | **■ 매칭** |

→ 4 주문조합 각각 **정확히 1 comp** 매칭. (print_opt × page) 2×2 완전 disjoint. ERR_AMBIGUOUS 0·silent-sum 0·이중배선 0. **20P 회귀 0**(20P 조합은 항상 S1/S2_20P로만 환원·30P comp 미매칭). ✅

## 7. product_price_formulas (바인딩)

- PRD_000094 ← PRF_PCB_FIXED **기존 바인딩 유지**(변경 0). 공식 신규 mint 없으므로 바인딩 INSERT 불요.

## 8. 골든 케이스 (verbatim·검증가 재현 대상)

단가형(.01): subtotal = unit_price × qty. 단가 = 라이브 `t_prc_component_prices` verbatim(재측정 완료).

| 케이스 | comp / siz·qty | 권위단가 | 골든 subtotal | 보정 전(결함) |
|---|---|---|---|---|
| 30p·단면·100×150(SIZ_000003)·qty2 | S1_30P | 11,500 | **23,000** | 30p 선택불가→20p 11,000×2=22,000(−1,000) |
| 30p·단면·100×150·qty4 | S1_30P | 9,900 | **39,600** | 20p 9,100×4=36,400(−3,200) |
| 30p·양면·100×150·qty2 | S2_30P | 12,500 | **25,000** | 20p양면 11,500×2=23,000(−2,000) |
| 30p·단면·135×135(SIZ_000004)·qty2 | S1_30P | 12,500 | **25,000** | 20p 12,000×2=24,000(−1,000) |
| **20p·단면·100×150·qty2 (회귀=불변)** | S1_20P | 11,000 | **22,000** | 22,000(불변·disjoint+dflt 보장) |
| **20p·양면·100×150·qty2 (회귀=불변)** | S2_20P | 11,500 | **23,000** | 23,000(불변) |

돈영향: 30p 전 사이즈·수량 저청구 해소(+500~3,200/건). 20p 전건 불변(회귀 0).

---

## 9. 잔여 의존 / 컨펌큐

1. **[채번 최종확정]** OPT_000082·OPV_000491/492는 본 설계의 라이브 MAX+1 실측값. 실 COMMIT 시점 재확인=dbm-axis-staged-load(§7)(다른 배치가 그새 점유했는지). 코드 의미값은 고정.
2. **[위젯 계약]** 위젯/시뮬레이터가 094 페이지수 옵션그룹(OPT_000082)을 렌더·dflt(20P) 사전선택해야 D2 보장 성립. mand 옵션그룹의 dflt 사전선택은 명함/ACRYL_BADGE로 검증된 표준 동작 — 신규 코드 불요·계약 확인만.
3. **[비차단·기존]** 094 print_options POPT_000001·POPT_000002 **둘 다 dflt_yn='Y'**(기존 적재 오묘) — 단/양면 기본 모호. 본 페이지 보정과 직교·20p 현행 작동이라 비차단. §26/실무진 확인 큐(별 트랙).
4. **[검증]** 본 설계=생성측. disjoint 실증·PRICE≠0 실호출·골든 재계산은 후속 hpe-validator + codex 재게이트(폐루프).

## 10. 라우팅

- 실 COMMIT = **인간 승인 후 §7 dbmap**(dbm-axis-staged-load: 옵션그룹/옵션 채번 확정·적재 / dbm-load-execution: 행 충전·배선). webadmin 코드 직접수정 0.
- dryrun = `design-pcb30p-fix-dryrun.sql`(BEGIN…ROLLBACK·멱등·COMMIT 아님).
