# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 3세션)

> 재시작 포인터. 상세 서술은 각 FINDING/SQL/메모리에. 활성 하네스=가격 종단(CLAUDE.md §27).

## ★다음 시작점
이번 세션은 **채점 로봇이 적발한 막힌 가격을 이전사이트 오라클 방법으로 실제 해소**했다(투명엽서·포토북·072 라이브 COMMIT). 다음 우선순위:

1. **072 하드커버 내지(284) 종단** — 표지+제본 합산가는 COMMIT 완료, **내지(PRD_000284) 디지털인쇄 페이지가만 남음**(§18 설계·포토북 내지 동형). 완결 시 072 종단(현재 set_eval=표지+제본만). 권위=이전사이트 pcode=40 `price_01`(내지) 밴드 + 가격표 booklet-l1.
2. **077/082/088 동형 전파** — 072 표지+제본 합산모델 복제(제본종류별 밴드 교체: 077=레더하드커버·082=하드커버트윈링(pcode41)·088=싸바리(pcode44)). 각 이전사이트 price_02 실측.
3. **채점 로봇 다음 상품군** — `score_batch.py`로 실사/책자 등 추가 채점(갈래1 패턴).

## ★이번 세션 라이브 COMMIT (되돌리지 말 것·undo SQL 보유)
1. **용지비 3건 충전** — COMP_PAPER 미적재 자재(아이보리153·스타드림다이아407.5·로츠쿼츠524=가격표 "가격(국4절)" verbatim·SIZ_000499 전지). `remediation/paper-missing-fill-260629-fix.sql`.
2. **투명엽서019 견적0 해소(2결함)** — ① PET 용지비 미적재→COMP_PAPER MAT_000178=1,100 적재 ② 판형 오적재→소형판형 4개(SIZ_000113/114/115/118) 논리삭제(형제 엽서는 전지뿐). 0원→가격. `petpaper-comp-260629-fix.sql`·`petplate-019-260629-fix.sql`.
3. **포토북100 종단 완성** — 가격데이터(PRF_PHOTOBOOK_FIXED+COMP_PHOTOBOOK_BASE 기본24P 11행 / PRF_PHOTOBOOK_INNER+COMP_PHOTOBOOK_PAGE 추가2P당 4행 / 바인딩2) + OI-3 옵션그룹(OPT_000079 표지타입+OPV_000484~486). 엔진 검증 23,800·38,000·50,000 권위 정확. `photobook-price-260629-fix.sql`·`photobook-oi3-options-260629.sql`.
4. **072 표지+제본 합산가** — PRF_HC_MUSEON_SET+COMP_HC_MUSEON_COVERBIND(권당 6밴드·prc_typ .01·이전사이트 price_02 verbatim). simulate_set copies1=34,100·copies100=796,900 일치. `hardcover072-coverbind-260629.sql`.

## ★핵심 방법론 정립 (이번 세션·재사용)
- **COMP_PAPER 단가 = 가격표 "가격(국4절)" 컬럼 verbatim** (백모조 100g→30.73·220g→70.64 라이브 정확일치로 증명). 미적재 용지는 이 규칙으로 충전(추정 아님).
- **PRICED-0 결함(견적0) = 용지단가 미적재 + 판형(plt_siz_cd) 오적재 복합** — best-plate가 단가행 있는 전지(SIZ_000499)로 수렴하는지(형제 상품 plate_sizes 패리티) 확인이 핵심.
- **책자 세트 페이지 가격 = 내지 구성원에 단가형(.01)** — 엔진 evaluate_set_price는 구성원마다 자기 qty로 가격(부모 set_eval 단일호출만 보면 page 못 곱한다고 오판). 위젯이 내지 qty=부수×⌈(page−24)/2⌉ 전달. [[book-set-page-pricing-inner-member-260629]].
- **별도 vs 합산 판정 = 이전사이트서 cover paper 바꿔 가격 불변이면 합산** — 072 표지종이 3종 전부 41,800 동일→표지+제본=합산(역산 분리 불필요). 표지종이=사양선택(가격 무관).
- **표지타입 차원 = opt_cd(text·OPT_REF_DIM 불요)** — 시뮬레이터 드롭다운=TPrdProductOptions(prd_cd) 직접. OI-3=옵션그룹+옵션 등록.

## ★C트랙 기록 (개발팀·배포 인간승인)
- **fn_calc_pansu 양방향 결함**(이번 세션 정량화): 기하 임포지션 과다→투명엽서 전사이즈 +43~50% **저청구**, **그러나 스탠다드엽서 148x210 −33% 과청구**(역방향). 권위=실무진 엑셀 판수. 코드=`raw/webadmin/sql/32_fn_calc_pansu.sql` L56-59. 회귀=투명 100x150 권위판수6(엔진14전지). `CTRACK-fn-calc-pansu-authority-pansu.md`.
- **OI-PAGE**: 위젯이 포토북/책자 내지 qty=부수×페이지스텝 산출 계약(데이터는 적재완료·코드 외부).
- composite 판형·S1/S2 이중합산(기존).

## 미해결/블로커
- **072 내지(284)** = 디지털인쇄 페이지가 미설계(§18). 077/082/088 동형 대기.
- **094 엽서북 내지(095) 무공식** = 포토북과 동일 구조 결함(추가페이지 미반영 가능)·별도 점검.
- **로츠쿼츠(MAT_000241)** = 로즈쿼츠 오타 판단으로 524 적재(실무진 1건 확인 권장·상이시 실버425/골드435).
- **투명엽서 잔여 갭**(49,000 vs 75,500)=전부 fn_calc_pansu C트랙(데이터는 정확·교정 금지).
- 포토북 10x10 소프트커버=권위 빈칸(미제공·CPQ 제약).

## 이번 세션 결정 (relitigate 금지)
- **미적재 용지 단가 = 가격표 가격(국4절) verbatim**(역산/추정 금지·증명됨).
- **책자 세트 페이지가 = 내지 구성원**(BLOCKED 아님·엔진 구성원별 qty).
- **072 표지+제본 = 합산**(이전사이트 실측·표지종이 무관·역산 분리 폐기).
- **포토북 ≠ 072**(포토북=리뉴얼 신규·이전사이트 부재·가격표 권위 / 072=pcode40 독립 책자).
- 이전사이트=조사 오라클(가격표 절대 권위·차이=조사신호·자동교정 금지·역산값은 인간/실측 확정).

## 건드리지 말 것
- 이번 세션 라이브 COMMIT 4건(위)·이전 세션 COMMIT 전부 — undo SQL 보유. 단가행 verbatim 불변.
- 채점 로봇(`batch/`)·기존 라이브 COMMIT(아크릴·스티커·밴드총액·디지털 종단) — `remediation/_REMEDIATION-LOG.md`.

## 산출물 위치
- **이번 세션 신규**: `remediation/{paper-missing-fill,petpaper-comp,petplate-019,photobook-price,photobook-oi3-options,hardcover072-coverbind,hardcover072-price-design,FINDING-transparent-postcard-PET-paper}-260629.*`·`CTRACK-fn-calc-pansu-authority-pansu.md`.
- 채점 로봇: `_foundation/batch/`(score_batch·lib_huni·authority·README). 교정 로그: `remediation/_REMEDIATION-LOG.md`.
- 메모리: [[transparent-postcard-price-fix-260629]]·[[book-set-page-pricing-inner-member-260629]]·[[batch-scoring-driver-260629]].
- 시뮬레이터 헬퍼: `batch/lib_huni.py`(인증 POST). 이전사이트 오라클: `remediation/_huni_live_crosscheck.md`(gstack browse·EUC-KR·price_01/02 분해).
