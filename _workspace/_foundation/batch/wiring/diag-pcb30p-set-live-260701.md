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

## 배선 서브트랙 처리
- COMP_PCB_S1_30P·S2_30P → **BLOCKED**(§23 셋트+§18 내지가격+§26 pansu). wiring 배선으로 해소 불가.
- `design-pcb30p-fix-260701.md`·`-dryrun.sql` = **SUPERSEDED**(opt_cd 가정 오류·미적용·COMMIT 0).
- 사장님/실무진 결정 필요분: 094 엽서북을 **셋트 운영(내지 가격설계)** vs **단품 운영(완제품 page 구분)** 중 무엇으로 갈지 = 가격 메커니즘 분기점.
