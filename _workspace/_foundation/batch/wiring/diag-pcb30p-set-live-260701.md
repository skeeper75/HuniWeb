# 엽서북30p 라이브 실호출 재진단 — opt_cd 설계 폐기 + 셋트 메커니즘 발견

2026-07-01 세션. 사용자 "엽서북부터 시작" → 라이브 webadmin 시뮬레이터 실호출(HuniSim·읽기전용)로 재진단.
결론: **기존 `design-pcb30p-fix-260701.md`(opt_cd 옵션그룹 설계) 폐기.** 094는 셋트이고 webadmin은 페이지를 page_rule로 다룬다.

## 라이브 실측 (sim_meta + simulate + simulate_set)
| 사실 | 실측 |
|---|---|
| 094 is_set | **True** — 셋트 완제품. 구성원 PRD_000095 엽서북-내지(몽블랑240)·role=내지·is_inner=True·min20/max30/incr10 |
| 094 page_rule | **{min:20, max:30, incr:10}** (TPrdProductPageRules 적재됨·price_views L1312) |
| 094 단품 simulate (단면·100x150·qty2) | PRICE=**22,000** (COMP_PCB_S1_20P 매칭·**page_rule 무시·20p 고정**) |
| 094 셋트 simulate_set (copies2·내지 plt SIZ_000114·pages 20) | PRICE=**0** (final_price=0) |
| 094 셋트 simulate_set (pages 30) | PRICE=**0** (동일) |
| 셋트 qty_breakdown | **pansu=None·per_book=None·total_sheets=None** → derive_inner_sheets(pages, pansu) 계산불가 |
| 095 내지 단독 sim_meta | **frm=null·components 없음·page_rule=None** → 내지 가격공식 부재 |

## 진단
1. **094 엽서북 = 셋트**(내지 095). webadmin 정합 가격경로 = `simulate_set` → 내지 구성원 가격 + derive_inner_sheets(총내지매수=부수×⌈pages/(pansu×sides)⌉).
2. 셋트 경로가 **완전히 깨짐**: ① 내지 095 가격공식 부재(frm=null) ② pansu(판걸이수) None → 내지매수 계산불가 → final_price=0.
3. 단품 경로(PRF_PCB_FIXED 완제품 단가형)는 작동하나 **page_rule을 무시**(20p 고정 22,000). 30p 손님도 20p 청구(저청구).
4. ★**기존 opt_cd 설계 폐기 사유**: webadmin은 페이지를 page_rule(전용 차원)로 다루는데, 내 설계는 opt_cd 옵션그룹(20P/30P 드롭다운)을 신설 → 손님이 page_rule(20/30 입력)과 opt_cd(20P/30P 선택)를 **이중 입력**하게 됨. page는 완제품 단가행 매칭 차원이 아니라 셋트 내지매수 환산 입력. design-pcb30p-fix의 "페이지=print동형 opt_cd 차원" 전제가 라이브 메커니즘과 불일치.

## 진짜 해법 (wiring 배선 범위 밖)
엽서북30p 가격은 **셋트 내지 구성원(095) 가격설계** 문제:
- **§18/§23**: 내지 095에 page(또는 내지매수)별 단가공식 설계 — 셋트 책자 내지 단가형([[book-set-page-pricing-inner-member-260629]] "기본24P+추가2P당" 패턴). 포토북100(PRD_000100) 동형 참조.
- **§26**: 내지 095 pansu(판걸이수) 적재 — fn_calc_pansu 개발요청서(`DEV-REQUEST-fn-calc-pansu-260701.md`)와 동일 결함(pansu None→계산불가). 키=(prd_cd, siz_cd).
- 단품 완제품 단가행(COMP_PCB_S1/S2_20P·30P)은 셋트 경로 정착 시 잔재 정리 대상(또는 단품 운영 결정 시 별도).

## ★가격표 재확인 (2026-07-01 2차·사용자 지적) — 단품 정합으로 결론 전환
사용자 "인쇄상품가격표 엽서북/떡메 시트를 봐라" → 가격표(260527) 엽서북떡메 시트 직접 확인. **셋트 vs 단품 결론이 단품으로 확정.**

| 사실 | 가격표 엽서북떡메 시트 |
|---|---|
| 구조 | **단품 완제품 단가표** — 사이즈(100x150·150x100·135x135) × 인쇄(단면/양면) × 페이지(20P/30P) × 수량(2~3000부) |
| 가격 단위 | **부수당 단가**(수량구간 할인) — "속지 장당"이 아니라 **20P/30P 통째 묶음가** |
| 라이브 정합 | COMP_PCB_S1/S2_20P·30P 단가행과 **verbatim 일치**(100x150 단면 20P: 2부11,000·100부4,500·1000부2,290 / 30P: 11,500·5,100·3,020) |

**결론 전환:**
- 엽서북 가격 = **단품(완제품 통째)** 이 가격표 권위. 페이지(20/30)는 "장당"이 아니라 **단가표의 한 축**(2단계뿐·incr10).
- 094 셋트구성(내지095+표지096·t_prd_product_sets 실측)은 **생산정보**·가격은 완제품 통째(책자류 정찰가 패턴).
- ★직전 "셋트로 가야"(라이브 is_set만 보고) 판단 정정 — **가격표가 권위**. page_rule/derive_inner_sheets(셋트 내지매수 환산)는 엽서북 가격에 미사용(0 나온 이유).
- ★`design-pcb30p-fix`(30P print_opt 충전 + page 판별 opt_cd + 배선)는 **단품 정합에 정확** — 폐기 취소. webadmin 내 page를 단가행 판별로 넣는 유일 경로=opt_cd.

## ★전환 방법 조사 (2026-07-01 3차) — 셋트 해제 불필요 입증
사용자 선택 "전환 방법 먼저 조사" → pricing.py `evaluate_set_price`(L844) 코드 + 라이브 실호출.

**엔진 사실(L920):** 셋트 가격 = 구성원 합산 + **셋트 완제품 자기 공식을 `set_selections`+copies로 호출**(`evaluate_price({prd_cd: set_prd_cd}, set_selections, copies, ...)`). 즉 094의 PRF_PCB_FIXED(완제품 통째 단가표)가 셋트 완제품 공식으로 평가됨.

**라이브 입증:** simulate_set(094, copies2, set_selections={siz_cd:SIZ_000003, print_opt_cd:...}):
- 단면 → **22,000**(=11,000×2 가격표 일치) · 양면 → **23,000**(=11,500×2 일치).
- ★직전 simulate_set PRICE=0은 **set_selections 미전달** 탓(내 호출 오류)이지 데이터 결함 아님. derive_inner_sheets(내지매수·pansu)는 구성원 경로일 뿐, 가격은 셋트 완제품 공식이 통째로 냄.

**결론(전환 방법):**
- ★**094 셋트 해제 불필요** — 셋트 구조(내지095+표지096=생산정보) 유지, 가격은 셋트 완제품 공식(PRF_PCB_FIXED 통째 단가표). 큰 라이브 변경 없음. **사장님 '셋트 vs 단품 운영' 결정 불요**.
- 현재 20P만 22,000 나오고 30P 미혼입 = **30P 고아(미배선)**라 셋트 완제품 공식이 30P 미평가. ★단 30P 단가행 print_opt NULL(와일드)이라 배선만 하면 단면 set_sel에 30P도 와일드 매칭→20P+30P 이중합산 과대 → **design-pcb30p-fix(30P print_opt 충전 + page 판별 opt_cd + 배선)가 필수·정확**.

## 배선 서브트랙 처리 (최종)
- COMP_PCB_S1_30P·S2_30P → **단품 정합 설계 GO**(design-pcb30p-fix 유효·셋트 완제품 공식 경로 입증). 셋트 해제·운영결정 불요.
- **COMMIT 경로(데이터만):** ① 30P 단가행 print_opt 충전(S1_30P=POPT_000001·S2_30P=POPT_000002) ② 20P/30P 단가행 page 판별 opt_cd 충전(20P/30P 구분) ③ 30P 2 comp 배선. → simulate_set(set_selections에 siz·print_opt·page(opt_cd))로 골든 6/6 재현 검증 → 인간 승인 §7.
- **위젯/시뮬 계약:** 셋트 페이지 입력을 `set_selections.opt_cd`로 전송(사이즈·print_opt는 이미 전송=22,000 입증). page를 set_selections에 넣는 경로만 확인(§6/시뮬 UI).
- ★page_rule/내지095 가격공식/pansu = 엽서북 가격에 미사용(셋트 완제품 공식이 통째). 이전 "내지 가격공식 부재가 근본결함" 진단은 **부정확**(통째공식 경로 간과). 정정.
