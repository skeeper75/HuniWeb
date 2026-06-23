# silsa-price-structure-model.md — 실사 카테고리 가격 구조 종합 모델

> dbm-price-arbiter · 2026-06-23 · §21. 읽기전용 분석·DB 미적재·webadmin 코드 미변경·단가 verbatim·날조 0.
> 사용자 directive: 실사 28상품 전 가격요소를 5장치로 조립(★수량구간할인 제외 — 굿즈/문구/아크릴 전용).
> 권위: silsa-l1(260610)·price-poster-sign-l1(260527)·가공/추가 옵션가(silsa-l1 행). 엔진: pricing.py evaluate_price.
> 생성자(arbiter)≠검증자 — 본 모델 GO 비준은 dbm-validator 독립 게이트.

## ① 28상품 동형 5클래스
| 클래스 | 가격성격 | use_dims | 본체단가 출처 | 비고 |
|---|---|---|---|---|
| C1 면적매트릭스형(13) | 가로×세로→면적티어 ceiling | `[siz_width,siz_height,(min_qty)]` | 가격표 260527(600mm~) | 동작하나 프리셋 미해소 |
| C2 siz_cd 프리셋형(14) | 사이즈코드→고정단가 | `[siz_cd,(min_qty)]` | silsa-l1 행별 | 정상 동작 클래스 |
| C3 면적+가공혼합(현수막) | 면적본체+가공 가산 | 본체면적+옵션comp | 본체=가격표/가공=silsa옵션 | C1 부분집합 |
| C4 가공/추가 add-on군(31 comp) | 본체에 가산(addtn) | `[]`/`[siz_cd]`/`[proc_cd,proc_grp,min_qty]` | silsa-l1 옵션가 | ★구조 결함 클래스 |
| C5 프리셋+커스텀 통합(포스터6) | C1+A3/A2/A1 프리셋+사용자입력 | C1+siz_preset 판별 | 프리셋=silsa/커스텀=가격표 | R-B3-PRICE 대상 |

## ② 7쟁점 배선 모델 (요약)
1·2 **프리셋+커스텀**: 모델 D-2(프리셋 3행 dim_vals={siz_preset:A3/A2/A1}+기존 52행 {CUSTOM} 백필). ★price_views/위젯 siz_preset 주입 동반 필수(별 트랙·§21 범위 밖). 상세=`r-b3-price-model.md`.
3 **가공옵션**: 31 옵션 comp 중 **공식 바인딩 1개뿐**(BANNER PUNCH_4). 30개(각목·끈·큐방·열재단·봉미싱·양면테입·거치대·우드행거·우드봉·천정고리·오버로크·메쉬타공)=단가행만·미바인딩=견적 시 미가산. → addtn_yn=Y 바인딩+use_dims 판별차원 충전.
4 **추가옵션**: 거치대/우드행거/우드봉/천정고리 단가행 존재하나 공식 미바인딩·일부 use_dims=`[]`(빈 판별). WOODHANGER/BONG=siz_cd 정합. 빈 comp=opt_cd 판별차원 신설 필요.
5 **각목 임계**: `..GAKMOK..900_..LE`(≤900=4,000)·`_GT`(>900=8,000) 2 comp 분리등록·use_dims=`[]`. 권고=siz_width 티어 1 comp 통합(엔진 네이티브).
6 **타공 분리**: 일반현수막=`proc_grp:PROC_000104`·메쉬=`proc_grp:PROC_000080`. ★디지털 타공(PROC_000079/092)과 proc_grp 분리=혼동 없음 확인. 단 좀비 comp PUNCH_6/8(빈차원 중복) 정리(use_yn=N).
7 **공정상세 prcs_dtl_opt**: LINEN_FINISH=proc_grp:PROC_000080+opt_cd 5행(오버로크/말아박기/봉미싱)=정상 D-2. 단 미바인딩.

## ③ 돈크리티컬 단가 불일치 (권위 verbatim 대조·신규 발견)
| 상품 | 권위 | 라이브 | 판정 |
|---|---|---|---|
| 유광아크릴(142) | 12000/18000/28000/47000 | 9000/14000/32000/37000 | 전부 불일치 |
| 미러아크릴(143) | 15000/22000/36000/62000 | 11000/18000/29000/50000 | 전부 불일치 |
| 폼보드(129) | A3=6000/A1=20000 | A3=7000/**A1 누락** | 불일치+누락 |
| 미니배너(145)·미니보드(144) | silsa price **공란** | 수량구간 2800~6500 적재 | 출처불명·directive 위반 |
| 무광/홀로시트(140/141) | 6000/11000/32000·8000/16000/32000 | 동일 | PASS |

## ④ 근본원인(RC)
- **RC-1** 면적 프리셋 미해소 → A3 ceiling 과대청구(+5,000). siz_preset 판별 부재.
- **RC-2** ★옵션 comp 30/31 고아(formula 미바인딩) → 가공/추가 견적 전면 미완성(최대·과소청구).
- **RC-3** 빈 use_dims(`[]`)·좀비 comp(PUNCH_6/8) → 묶는 순간 silent 합산/ERR_DUPLICATE.
- **RC-4** 캔버스행잉(133) use_dims=siz_width/height인데 단가행은 siz_cd 충전 → 매칭실패/모호(설계의도 역배선).
- **RC-5** 아크릴(142/143)·폼보드(129) 단가 오적재+누락(진원=상류 v03 추정·별색옵션 단가 혼동 의심).

## ⑤ evaluate_price 재계산 검증
| 대표 | 입력 | 라이브 | 권위 | 판정 |
|---|---|---|---|---|
| C2 폼보드 A2 | siz_cd=A2 | 12,000 | 12,000 | PASS |
| C2 무광시트 A3 | siz_cd=A3 | 11,000 | 11,000 | PASS |
| C1 아트프린트 A3 | 면적 ceiling | 12,000 | 7,000 | FAIL(RC-1) |
| C2 유광아크릴 | siz_cd | 9,000 | 12,000 | FAIL(RC-5) |
| C4 현수막+각목 | 옵션 | 본체만 | 본체+각목 | FAIL(RC-2) |
| C4 캔버스행잉 | siz | 모호 | siz별가 | FAIL(RC-4) |
| ERR_AMBIGUOUS | C2 | 0건 | — | PASS |
| 수량할인 | 본체 | 무할인 | 무할인 | PASS(미니류 예외) |

## ⑥ 미해결 CONFIRM (인간/실무진)
- CONFIRM-1 (Q-WIDGET-PRESET): siz_preset 위젯/price_views 계약 신설 합의(R-B3 승계·코드 트랙).
- CONFIRM-2 (아크릴/폼보드 단가): 권위 verbatim 정답·라이브 오적재 확정 + 별색옵션 단가 혼동 여부(v03 추적).
- CONFIRM-3 (미니류 수량단가): 미니배너/미니보드 라이브 수량단가(2800~6500) 출처·"실사 수량할인 없음" directive 예외 여부.
- CONFIRM-4 (각목/큐방 판별): ≤900/>900을 (a)2 comp 분리유지 vs (b)1 comp siz_width 티어 통합. 권고=(b).
- CONFIRM-5 (현수막 사용자입력 본체단가): 일반현수막 본체 면적행 권위 시트(silsa-l1 price 공란).

## ⑦ 적재 순서·인간 승인 큐 (데이터 vs 코드 분리·전부 인간 승인·DB 미적재)
**데이터 트랙(dbm-load-execution)**: ① RC-5 단가 교정(아크릴142·143·폼보드129 A1·CONFIRM-2 선행·verbatim) ② RC-4 캔버스행잉 차원 정정 ③ RC-2 옵션 comp 30 바인딩+use_dims 충전 ④ RC-3 좀비 comp use_yn=N ⑤ RC-1 프리셋 3행+52행 백필(코드 트랙 동반 강제).
**코드 트랙(§6/webadmin·별 트랙·§21 범위 밖)**: ⑥ price_simulate+위젯 siz_preset 주입(RC-1 데이터의 전제).

**판정**: 분석·명세까지 GO. 데이터 트랙은 CONFIRM-1~5 확정 + dbm-validator 독립 재실측 후 적재. RC-1은 데이터 단독 시 커스텀 0원 회귀 → 코드 트랙 동반 강제.
