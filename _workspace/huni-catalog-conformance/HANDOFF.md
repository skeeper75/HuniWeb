# HANDOFF — Huni-Catalog-Conformance (§21) · 교정 실행 단계

> 갱신 2026-06-23. 전 11시트 종단 정합 검증 **완료**(누락0·3,198행) → 현재 **교정 실행 단계**.
> 권위 종합=`06_gate/conformance-final-summary.md`. 진행 트래커=`_meta/batch-progress-260622.md`.
> 단가 verbatim 불변·기초코드 마스터(t_mat/t_siz/t_prc 공유) 불변·생성≠검증·DB 쓰기는 인간 승인 후만.

## 다음 시작점 (택1·실사 RC 교정 이어가기·★RC-2 전 데이터 트랙 2026-06-23 COMMIT 완료)
실사 RC 교정 — RC-2 데이터 트랙(추가물·CONFIRM·각목) 전부 COMMIT. 남은분:
1. **RC-2 PET배너(136)**: HOLD-1 = 거치대 택1 그룹 기존 "실외용거치대" ↔ 신규 단/양면(S1/S2·23000/25000) 의미 중복 → 거치대 옵션 모델링 CONFIRM(실무진) 후 메쉬/캔버스/린넨 동일 패턴 적재.
2. **잔여 단가 결정(돈크리·인간 컨펌)**: ① 일반현수막 타공수8 라이브 8000 vs 권위(가격표) 5000(메쉬는 5000 일치)=HOLD-NORMAL-PUNCH8-PRICE ② 족자 천정고리 라이브 6500 vs 권위 "4000?"=HOLD-C-PRICE. 둘 다 현재 verbatim 적재됨·정정은 인간 결정.
3. **타공 위젯 코드트랙(§6)**: 시뮬레이터/위젯이 procs=[{proc_cd,detail{타공수:N}}] 전송해야 타공수별 가산 작동(데이터는 always-add 제거까지 완료). §21 범위 밖·§6 위임.
4. **RC-1 프리셋(R-B3-PRICE)**: A3/A2/A1/사용자입력을 **opt_cd 옵션그룹**으로 모델(`r-b3-price-model.md`).

> **RC-5 완료(2026-06-23)**: 유광/미러아크릴·폼보드 단가 COMMIT. 별색옵션 혼동 4축 배제·권위 verbatim 10행·R1~R6 GO.
> **RC-2 추가물 3상품 완료(2026-06-23)**: 메쉬 큐방/끈·캔버스 우드행거(RC-4 재배선)·린넨우드봉 우드봉 COMMIT(23행·always-add 가드). 명세=`03_cpq_link/rc2-addon-load-spec-unblocked.md`.
> **RC-2 CONFIRM 3건 완료(2026-06-23)**: 린넨마감(124 바인딩·B=CLOSED opt_cd 이미 정합)·타공(138/139 데이터 정리·proc_cd 통일·좀비 use_yn=N·미선택 0가산)·족자(135 opt_cd 재배선 OPV_000431) COMMIT(19행). 명세=`03_cpq_link/rc2-confirm-resolved-load-spec.md`·적재본=`09_load/_rc2_confirm_resolved_260623/`. 캔버스패브릭(125)=비동형 HOLD(마감비 단가 부재).
> **RC-2 각목 완료(2026-06-23)**: 손님 택1(각목900이하=4000/900초과=8000·가격표 verbatim)·세로가로 부착=생산메타 별도그룹(OPT_000063·가격0)·12000 이중합산 결함 해소(보수안 2 comp opt_cd 충전·부모 use_yn=N) COMMIT(12행). Q3=손님 직접(도메인·경쟁사 5곳 수렴·자동판정 사례 부재). 명세=`03_cpq_link/rc2-gakmok-load-spec.md`·모델=`04_price_engine/rc2-gakmok-model-revisit.md`·근거=`rc2-gakmok-q3-domain-benchmark.md`·적재본=`09_load/_rc2_gakmok_260623/`. 메쉬 각목=가격표 부재 미적용.

실행 패턴(검증된 체인): `dbm-load-builder`(적재본+DRY-RUN·COMMIT 안 함) → `dbm-validator`(R1~R6 독립 게이트) → 사용자 승인 → `hbd-load-executor`(백업·DRY-RUN·COMMIT·사후검증·undo).

## 미해결 / 블로커
- **CONFIRM-A 타공**: ✅ 데이터 트랙 해소(2026-06-23) — 단가행 proc_cd 부모 통일(일반 105→104·메쉬 NULL→079)+dim_vals{타공수}+미선택 0가산 COMMIT. 잔여=위젯 코드트랙(procs detail{타공수} 전송·§6·타공수별 가산은 이후 작동).
- **CONFIRM-4 각목**: ✅ 해소(2026-06-23) — 손님 택1(900이하/초과)·세로가로=생산메타 분리·12000 이중합산 해소 COMMIT. Q3 손님직접(도메인·경쟁사 수렴).
- **HOLD-NORMAL-PUNCH8-PRICE**(돈크리·인간): 일반현수막 타공수8 라이브 8000 vs 권위 가격표 5000(메쉬는 5000 일치). 현재 verbatim(8000) 적재됨·정정 여부 인간 결정.
- **HOLD-C-PRICE**(돈크리·인간): 족자 천정고리 라이브 6500 vs 권위 "4000?". 현재 verbatim(6500) 적재됨·정정 여부 인간 결정.
- **opt 동시선택 한계**(코드트랙): 가공+추가 동시(예 봉미싱+큐방) 시 selections opt_cd 단일키로 1건 누락. 그룹별 키 분리=§6/webadmin 코드.
- **위젯 경로**(별 트랙): `_opt_maps` 자동변환은 위젯 전용·시뮬레이터 미동작. 지금은 시뮬레이터 중심(사용자 directive), 위젯은 별도 작업.
- **RC-2 PET배너(136) HOLD-1**: 거치대 택1 그룹에 기존 "실외용거치대" ↔ 신규 단면(S1)/양면(S2·23000/25000) 의미 중복 → 거치대 옵션 모델링 실무진 CONFIRM 후 적재.
- **CONFIRM 잔여**(해소분 제외): B(린넨마감)=CLOSED·C(족자)=opt_cd 해소·D(본체공식)=라이브 실측 해소. 미니배너/미니보드 권위부재 수량단가 출처만 잔존.
- **그 외 카테고리 교정 큐**(전 11시트): 아크릴20 미바인딩 R-B3-1(Q-ACR-MISSING20)·GP-2 FORMULA R-GP4-5(반팔/후드티 포함)·R-GP4-2~4·CPQ MISS·배치1~3 NO-GO 교정명세(`06_gate/remediation-spec-batch*.md`).

## 이번 세션 결정 (재론 금지)
- **4장치 차원 메커니즘은 코드에 이미 구현**(옵션 opt_cd·ref_dim_cd / 공정 proc_grp+dim_vals / 템플릿 addon). 가공/추가/프리셋 교정은 **데이터 작업**(use_dims+단가행 판별값+addtn 바인딩)이지 새 코드가 아님. 빈 use_dims=`[]`로 묶으면 silent always-add 함정.
- **정정**: 앞서 "siz_preset 위젯/price_views 코드 변경 필수"는 과한 진단. opt_cd 차원으로 코드 변경 없이 가능(시뮬레이터 한정).
- **실사는 수량구간할인 없음** — 굿즈/파우치·문구·아크릴 전용(사용자 확정).
- **각목**(★2026-06-23 정정): 가격=900mm 임계(가격표 포스터사인 r249-250 권위·900이하 4000/초과 8000)·세로/가로=가격 무관 **생산메타**(별도 그룹). 둘은 충돌 아닌 직교. Q3=손님 직접 택1(도메인 관행+경쟁사 5곳+가격표 수렴·사이즈 자동판정 UX 사례 0). 직전 "세로/가로 구분(900 아님)" 판정은 폐기.
- **always-add 가드 원칙**(RC-2 전반·재론 금지): 추가/가공 comp use_dims에 opt_cd(or proc_cd) 판별차원 미포함=빈 `[]` 또는 단가행 NULL → "미선택에도 silent 가산"(과대청구). 해법=use_dims+단가행에 opt_cd/proc_cd 판별값 충전. 엔진 `_row_matches` NULL=와일드카드.
- **comp 통합 vs 2 comp 유지**: 형제 동형 패턴(같은 택1 그룹 옵션) 존재 시 **2 comp 유지+각 opt_cd 충전** 우선(통합=comp 병합 가격사슬 리스크·메모리 통합함정 회피). 통합·유지 둘 다 always-add 해소 효과 동등.
- **CONFIRM-D 본체공식 frm_cd**: 실무진 컨펌 불요 — t_prd_product_price_formulas 라이브 실측으로 확정 가능(메쉬=PRF_POSTER_BANNER_M 등).
- **단가 컨펌 보류분**(verbatim 적재됨·정정은 인간): 타공수8 라이브 8000 vs 권위 5000·족자 6500 vs 권위 "4000?". 권위 의심되나 현재값 보존, 교정은 별도 인간 결정.
- **RC-5 권위(silsa-l1)=정답·라이브 교정**(사용자 확정).
- **구조-우선**: 단편 교정(프리셋만) 금지 — 한 상품의 프리셋·커스텀·가공·추가·공정상세를 한 모델로 통합 후 적재.
- **K6 자격증명**: `.env.local HUNI_ADMIN_*`(사용자 갱신분) 정상 동작 — product-viewer gstack 로그인 OK(이전 "stale" 판정은 당시 값 오류).
- R-B3 A3/A2/A1=실제 등록 siz_cd 용지 프리셋(고정 7000/7000/12000)·사용자입력=nonspec 면적매트릭스(600mm~·900은 일반현수막용·포스터 무관).

## 건드리지 말 것 (확정·되돌리지 말 것)
- **RC-2 각목 라이브 COMMIT**(2026-06-23·12행·PRD_000138): OPV_000015/016 가격표 라벨 재라벨·세로가로 신규 그룹 OPT_000063(OPV_000432/433·가격0)·각목 _LE/_GT comp opt_cd 충전(4698=4000/4700=8000 verbatim)·부모 use_yn=N·바인딩 2. 12000 이중합산 결함 해소(택1 max_sel_cnt=1). undo=`09_load/_rc2_gakmok_260623/undo.sql`·백업 보유.
- **RC-2 CONFIRM 3건 라이브 COMMIT**(2026-06-23·19행): 린넨마감(124) PRF_POSTER_LINEN 바인딩·타공(138/139) 단가행 proc_cd 통일(일반 105→104·메쉬 NULL→079)+dim_vals 충전+바인딩+좀비 PUNCH_6/8 use_yn=N·족자(135) OPV_000431 opt_cd 재배선(단가행 4594 bdl_qty→opt_cd·6500 verbatim). always-add 가드 라이브 실효. undo=`09_load/_rc2_confirm_resolved_260623/undo.sql`·백업 보유.
- **RC-2 추가물 3상품 라이브 COMMIT**(2026-06-23·23행): 메쉬(139) 큐방/끈·캔버스행잉(133) 우드행거(RC-4 siz_cd 258→172·315→174·317→197 재배선)·린넨우드봉(134) 우드봉. 옵션 INSERT 4(OPV_000425/426/429/430)+comp 차원 4+단가행 11+공식바인딩 4. always-add 가드 라이브 실효(opt_cd 충전). undo=`09_load/_rc2_addon_unblocked_260623/undo.sql`·백업 보유. **PET(136) 제외(HOLD-1)**.
- **RC-5 아크릴/폼보드 단가 라이브 COMMIT**(2026-06-23·component_prices 10행 권위 verbatim): 유광아크릴 4792~4795·미러아크릴 4796~4799·폼보드 4780(A3 6000)·A1 신규 38239(20000). undo=`09_load/_rc5_acrylic_foamboard_260623/undo.sql`·백업=`backup-before-260623.csv`.
- **RC-2 일반현수막 라이브 COMMIT**(PRD_000138/PRF_POSTER_BANNER_N 가공/추가 6 comp 배선·미선택0가산 해소). undo=`09_load/_rc2_banner_260623/undo.sql`.
- **R-GP4-1 굿즈 GP-1 base 26행 COMMIT**(`09_load/_gp1_base_260623/`).
- **과대청구 8건 COMMIT**(접지카드·포토카드·명함·094·배치2 PROC) + **019 교정** — 전부 되돌리지 말 것.
- 전 11시트 종단 검증 결과(checklist 3,198행·verdict·final-summary).
- 확정 모델 문서: `04_price_engine/silsa-price-structure-model.md`·`price-component-dimension-mechanism-audit.md`·`r-b3-price-model.md`·`rc2-silsa-addon-binding-design.md`.

## 핵심 경로·자격증명
- 권위 엑셀 캐시: `_workspace/huni-dbmap/24_master-extract-260610/silsa-l1.csv`·`06_extract/price-poster-sign-l1.csv`·`00_schema/ref-*.csv`.
- 엔진 권위: `raw/webadmin/catalog/pricing.py`(evaluate_price)·`price_views.py`(시뮬레이터/뷰어/그리드).
- 적재본: `_workspace/huni-dbmap/09_load/_{rc2_banner,gp1_base,overcharge_*}_260623/`.
- 자격증명: `.env.local RAILWAY_DB_*`(읽기전용 SELECT)·`HUNI_ADMIN_*`(gstack 읽기 탐색만). 비밀값 `_workspace`·git·stdout 비노출.
- 실행 에이전트: dbm-price-arbiter(모델정립)·dbm-load-builder(적재본+DRY-RUN)·dbm-validator(R1~R6)·hbd-load-executor(COMMIT)·dbm-cpq-option-mapping(CPQ 옵션 등록).
