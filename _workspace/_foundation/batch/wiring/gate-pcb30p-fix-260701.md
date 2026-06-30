# 엽서북30p PRD_000094 배선 보정본 독립 재검증 게이트 (E1~E7) — 260701

- 검증가: hpe-validator(Claude). 생성≠검증·라이브 읽기전용 SELECT만·DB 쓰기 0·생성자 주장 비신뢰(직접 재실측).
- 대상: `design-pcb30p-fix-260701.md` + `design-pcb30p-fix-dryrun.sql`(직전 NO-GO 폐루프 보정본).
- 권위: `live-snapshot/latest`(=snap_20260701_0305·박명함037 COMMIT 반영)·엔진 `pricing.py`(`_row_matches` L94·`match_component` L134·`NON_QTY_DIMS` L42)·`price_views.py`(`_opt_cd_options` L726/762·sim-meta `_dim_options` L1342~·`price_simulate` L1744)·시뮬레이터 `price_simulator.html`(`defaultDimValue` L196~203).
- **판정 요약: 조건부 — 데이터 설계 GO(D1·D3 닫힘·disjoint·골든 verbatim) / D2 NO-GO(자동 dflt 메커니즘 반증·돈크리티컬). 보정 협소(데이터 재설계 불요·D2 서사 교정+위젯 계약 확인).**

---

## 0. 보정 3결함 닫힘 판정

| 결함 | 직전 NO-GO | 보정 주장 | 독립 재실측 판정 |
|---|---|---|---|
| **D1 선택수단 무효** | `option_items(ref_dim_cd='opt_cd')` 무효 코드 | `t_prd_product_options`(OPT_000082+OPV) 직접 INSERT | **닫힘 ✅** — dryrun에 ref_dim='opt_cd' 잔재 0. `_opt_cd_options`(L732)가 `TPrdProductOptions`에서 읽음 확인. 선택수단 매칭 경로 유효. |
| **D2 20p 회귀** | opt_cd 미공급 시 20P/30P 둘 다 no_match → PRICE=0 | dflt=20P·mand_yn=Y → 미선택 시 자동공급 → 22,000 불변 | **닫히지 않음 ❌** — **자동 dflt 공급 메커니즘이 시뮬레이터에 존재하지 않음**(반증·아래 §D2). 원 실패모드(opt_cd 미공급→PRICE=0) 잔존. |
| **D3 채번 충돌** | OPT_000080 명함037 선점 | OPT_000082·OPV_000491/492 | **닫힘 ✅** — 최신 스냅샷 실측 충돌 0(아래 §D3). |

---

## D1 — 선택수단 유효성 [HARD] = **PASS**

- dryrun 순서1 = `t_prd_product_option_groups`(OPT_000082) + `t_prd_product_options`(OPV_000491/492) 직접 INSERT. **`option_items`/`ref_dim_cd='opt_cd'` 잔재 0**(grep 0). 무효 코드 폐기 확인.
- 엔진 환원 경로 재실측: `_opt_cd_options`(price_views.py:732) = `M.TPrdProductOptions.objects.exclude(del_yn="Y").filter(opt_grp_cd=opt_grp)`. → 보정본이 INSERT하는 그 테이블에서 정확히 읽음. sim-meta opt_cd 드롭다운도 `TPrdProductOptions`(L1362) 경로. **selections['opt_cd']=OPV 환원 가능**(값이 공급될 때).
- `NON_QTY_DIMS`(pricing.py:42)에 `opt_cd` 포함 확인 → opt_cd는 엔진 행매칭 차원. D1 매칭 메커니즘 건전.

## D2 — 20p 회귀 0 [HARD·돈크리티컬] = **FAIL (자동 dflt 반증)**

설계 D2 핵심 주장 = "페이지 미선택 시 dflt=20P 자동공급으로 20P 행 매칭 → 22,000 불변"·"mand 옵션그룹 dflt 사전선택은 명함/ACRYL_BADGE 검증된 표준 동작." **이 주장을 클라이언트/엔진 코드 실독으로 반증:**

1. **엔진은 default 미주입(실측).** `price_simulate`(L1752): `selections = {k:v for ... in p.get("selections")... if v not in (None,"")}`. selections는 **클라이언트가 POST한 값만**. evaluate_price 어디에도 옵션 dflt 자동주입 없음. → 자동공급 주체=클라이언트뿐(설계도 자인).
2. **시뮬레이터는 opt_cd를 자동 사전선택하지 않음(실측).** `defaultDimValue`(price_simulator.html:197~202): `ys=opts.filter(o=>o.dflt); if(ys.length) return ys[0].v; if(opts.length===1) return opts[0].v; return null;`. 그런데 sim-meta의 opt_cd config(price_views.py:1362~1368)는 `{"v":c,"t":n}`만 반환 — **`dflt` 플래그 미전달**(대조: mat_cd L1359는 `"dflt":dflt` 실음). 페이지 옵션 2개(20P/30P)·dflt 없음 → **`return null`(선택 안 함)**.
3. **mand_yn은 무효.** 옵션그룹은 시뮬레이터에서 **아예 제외**(price_views.py:1423~1429 "옵션그룹은 가격 시뮬레이터에서 제외 2026-06-28"). opt_cd는 raw 드롭다운(frm_opt_grps 한정)으로만 노출. mand_yn=Y·dflt_yn='Y'가 **시뮬레이터에서 inert**.

→ **시뮬레이터에서 094 열고 페이지 미선택 시 selections['opt_cd']=None.** 보정본이 20P 234행에 opt_cd='OPV_000491' 충전한 직후, 20P 행이 와일드카드 상실(non-NULL opt_cd 요구) → `_row_matches`(L101) `_norm(None)!=_norm('OPV_000491')`→False → 20P no_match, 30P no_match → **PRF_PCB_FIXED 전 comp 제외 → PRICE=0.** 직전 NO-GO 실패모드가 **그대로 잔존**. 보정의 dflt 논거는 코드로 반증됨.

### 단, 심각도 완화(공정 평가) — 페이지축은 print_opt와 동형의 필수선택
- **print_opt_cd도 자동 dflt 없음(실측).** sim-meta print_opt config(L1347~1348)=`_named(_pcodes(...))` — dflt 미전달. 094 print_options=단면/양면 2개(스냅샷 실측) → defaultDimValue→null. **즉 094는 보정 전에도 이미 print면을 명시 선택해야 22,000이 나옴**(무선택=현재도 PRICE=0). 골든 baseline "20p단면 22,000"도 print_opt 공급 전제로 산출됨(gate-design L104).
- 따라서 페이지(opt_cd)는 **새 회귀 클래스가 아니라 print_opt와 대칭인 필수선택 차원**. 손님이 정상 필수선택(siz+면+페이지)하면 20P=22,000(아래 골든 검증). PRF_PCB_FIXED 공식명도 "사이즈/면/**페이지**/수량별 단가"라 페이지축은 원 설계 의도.
- **결론:** 정상 주문의 돈 정확성은 무손상(회귀 0). 그러나 설계가 단정한 **"미선택 자동 22,000" 메커니즘은 거짓**이고, 원 D2 실패모드(opt_cd 미공급→0)는 위젯 계약 미확인 상태로 잔존. 돈크리티컬·[HARD] 게이트에서 **거짓 안전논거 통과 불가 → FAIL.**

## D3 — 채번 충돌 0 = **PASS**

최신 스냅샷(snap_20260701_0305·037 COMMIT 반영) 실측:
- `MAX(opt_grp_cd)=OPT_000080`(037 박종류 점유). OPT_000080=037 점유·OPT_000081 미사용(040 코팅 미COMMIT)·**OPT_000082 미사용**. 보정 OPT_000082 = 충돌 0 ✅.
- `MAX(opt_cd)=OPV_000488`(037 OPV_000487/488 점유). OPV_000489/490 미사용(040 미COMMIT)·**OPV_000491/492 미사용**. 보정 OPV_000491/492 = 충돌 0 ✅.
- 080/081/487~490과 겹침 0 확인(설계 요구 충족). (설계문서 stated MAX=OPT_000079는 stale이나 선택값 082/491/492는 037 COMMIT 후에도 안전.)
- 094 페이지수 옵션그룹 부재 확인(기존 OPT_000030~037만) → mint 정당.

---

## disjoint 2×2 진리표 (직접 재구성·행 신호 (print_opt, opt_cd))

보정 충전 후: S1_20P=(POPT1,OPV491) · S2_20P=(POPT2,OPV491) · S1_30P=(POPT1,OPV492) · S2_30P=(POPT2,OPV492).

| comp | (POPT1,20P) | (POPT2,20P) | (POPT1,30P) | (POPT2,30P) |
|---|---|---|---|---|
| S1_20P | ■매칭 | print≠ | page≠ | 둘≠ |
| S2_20P | print≠ | ■매칭 | 둘≠ | page≠ |
| S1_30P | page≠ | 둘≠ | ■매칭 | print≠ |
| S2_30P | 둘≠ | page≠ | print≠ | ■매칭 |

→ 4 주문조합 각 **정확히 1 comp** 매칭. (print_opt×page) 완전 disjoint·silent-sum 0·ERR_AMBIGUOUS 0. **단, 이 표는 opt_cd가 공급될 때만 성립**(미공급 시 4 comp 전부 no_match=D2). disjoint 논리 자체 = **PASS**.

## 골든 재현 (허용오차 0·스냅샷 component_prices verbatim 대조)

단가형(.01): subtotal = unit_price × qty. 단가 = `t_prc_component_prices` 실측값(검증가 직접 추출).

| 케이스(선택값) | comp | 실측 unit_price | 재계산 | 권위 | 일치 |
|---|---|---|---|---|---|
| 30p단면 SIZ_000003 qty2 | S1_30P | 11,500.00 | 23,000 | 23,000 | ✅ |
| 30p단면 SIZ_000003 qty4 | S1_30P | 9,900.00 | 39,600 | 39,600 | ✅ |
| 30p양면 SIZ_000003 qty2 | S2_30P | 12,500.00 | 25,000 | 25,000 | ✅ |
| 30p단면 SIZ_000004 qty2 | S1_30P | 12,500.00 | 25,000 | 25,000 | ✅ |
| **20p단면 SIZ_000003 qty2(회귀)** | S1_20P | 11,000.00 | 22,000 | 22,000 | ✅ (단 page 선택 시) |
| **20p양면 SIZ_000003 qty2(회귀)** | S2_20P | 11,500.00 | 23,000 | 23,000 | ✅ (단 page 선택 시) |

전 6케이스 verbatim 일치. 단가행 unit_price 무변경(dryrun UPDATE는 opt_cd/print_opt_cd/use_dims만). **회귀 골든 22,000/23,000은 페이지 명시 선택 전제에서만 재현**(자동 dflt 미선택 시 0=D2).

---

## E게이트 종합

| 게이트 | 판정 | 근거 |
|---|---|---|
| E1 공식 추출 충실성 | PASS | 30P/20P 단가 verbatim(11500/9900/12500/11000…)·행충전 전제 스냅샷 일치(20P opt NULL·print 충전 / 30P 둘 NULL). |
| E2 구성요소 분해 정합 | PASS | PRF_PCB_FIXED 4 comp disjoint(print_opt×page)·시트경계 내·이중배선 0(opt_cd 공급 전제). |
| E3 경쟁사 흡수 | N/A | 후니 권위(흡수 아님). |
| E4 엔진 건전성 | **FAIL** | D1 매칭경로 유효하나 **D2 자동 dflt 메커니즘 부재(코드 반증)** → opt_cd 미공급 시 PRICE=0 잔존(돈크리티컬). |
| E5 세트 조합 | N/A | 본 보정=완제품 단가 배선(세트 합성 아님). |
| E6 골든 재현 | PASS(조건) | 6/6 verbatim. 단 20P 회귀 골든은 page 선택 전제. |
| E7 생성검증 독립성 | PASS | 시뮬레이터/엔진 코드 직접 실독으로 설계 dflt 주장 반증·스냅샷 직접 채번/단가 재측정. |

**단일 FAIL(E4/D2) = NO-GO. 데이터 설계는 GO(E1/E2/E6/D1/D3).**

---

## 보정 요구 (→ designer 폐루프·협소)

데이터 재설계 불요. 둘 중 택1:
1. **(권장·데이터 트랙)** D2 서사 교정 — "dflt=20P 자동공급→22,000 자동" 거짓 주장 삭제. 명시: **페이지(opt_cd)는 print_opt와 동형의 필수선택 차원**(시뮬레이터/엔진 자동 dflt 없음·옵션그룹 sim 제외). 위젯이 페이지수를 **필수선택으로 강제+opt_cd 전송**해야 함(094의 기존 print_opt 계약과 동일). 이 위젯 계약을 **확인(실측 또는 위젯 코드)**해야 COMMIT 가능. dflt_yn='Y'는 무해하나 시뮬레이터에서 inert임을 명기. → 확인 시 GO.
2. **(코드 트랙·C)** 진짜 자동 dflt가 필요하면 `price_views.py` sim-meta opt_cd config가 dflt_yn 전파 + 시뮬레이터 defaultDimValue 적용(webadmin 코드 수정=개발팀 C트랙). 설계 트랙 범위 밖.

## COMMIT 승인 가능 여부

- **현 보정본 단정("미선택 22,000 자동") 그대로는 COMMIT 불가**(돈크리티컬 거짓 안전논거).
- **데이터 dryrun(채번·행충전·배선·disjoint·골든)은 정확**하여, 위 보정요구1(서사 교정+위젯 page-필수 계약 확인) 충족 시 **DB 측 COMMIT 승인 가능**. 데이터 자체 재작업 불요.

## 잔여 / 라우팅
- D2 위젯 계약 확인 = 폐루프 designer + 위젯(§6) 실측. C트랙(price_views dflt 전파)은 개발팀.
- 094 print_options 둘 다 dflt_yn 모호(기존)·본 보정과 직교(비차단).
- codex 2차(Phase 5.5)는 본 판정 비참조 독립 재판정 → 오케스트레이터 reconcile.
