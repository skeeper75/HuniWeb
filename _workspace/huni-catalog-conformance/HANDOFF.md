# HANDOFF — Huni-Catalog-Conformance (§21) · 교정 실행 단계

> 갱신 2026-06-23. 전 11시트 종단 정합 검증 **완료**(누락0·3,198행) → 현재 **교정 실행 단계**.
> 권위 종합=`06_gate/conformance-final-summary.md`. 진행 트래커=`_meta/batch-progress-260622.md`.
> 단가 verbatim 불변·기초코드 마스터(t_mat/t_siz/t_prc 공유) 불변·생성≠검증·DB 쓰기는 인간 승인 후만.

## 다음 시작점 (택1·실사 RC 교정 이어가기·★RC-5·RC-2 추가물 3상품 2026-06-23 COMMIT)
실사 RC 교정 — 남은 BLOCKED/CONFIRM 의존분:
1. **RC-2 PET배너(136)**: HOLD-1 = 거치대 택1 그룹에 기존 "실외용거치대"와 신규 단면(S1·23000)/양면(S2·25000)이 **의미 중복** → 모델링 CONFIRM 필요(실무진). 컨펌 후 메쉬/캔버스/린넨과 동일 패턴 적재.
2. **RC-2 CONFIRM 의존분(각목·타공·린넨마감·족자)**: CONFIRM-A(타공 proc_cd 105 vs 104·detail 전송)·CONFIRM-4(각목 세로/가로 ↔ 4000/8000 매핑규칙)·CONFIRM-B(린넨마감 LINEN_FINISH opt_cd 재배선)·CONFIRM-C(족자 bdl_qty 의미) 실무진 확정 후 적재.
3. **RC-1 프리셋(R-B3-PRICE)**: A3/A2/A1/사용자입력을 **opt_cd 옵션그룹**으로 모델(코드 변경 없이·`r-b3-price-model.md`). 단 각목·동시선택 등 코드트랙 CONFIRM 정리 후가 안전.

> **RC-5 완료(2026-06-23)**: 유광아크릴(142)·미러아크릴(143)·폼보드(129) 단가 라이브 COMMIT. 별색옵션 혼동 4축 배제(CONFIRM-2 해소)·권위 verbatim 10행·R1~R6 GO. 진단=`04_price_engine/rc5-acrylic-foamboard-diagnosis.md`.
> **RC-2 추가물 3상품 완료(2026-06-23)**: 메쉬(139) 큐방/끈·캔버스행잉(133) 우드행거(RC-4 재배선)·린넨우드봉(134) 우드봉 라이브 COMMIT(23행·always-add 가드 실효). 명세=`03_cpq_link/rc2-addon-load-spec-unblocked.md`·적재본=`09_load/_rc2_addon_unblocked_260623/`. CONFIRM-D 본체공식 4종 라이브 확정.

실행 패턴(검증된 체인): `dbm-load-builder`(적재본+DRY-RUN·COMMIT 안 함) → `dbm-validator`(R1~R6 독립 게이트) → 사용자 승인 → `hbd-load-executor`(백업·DRY-RUN·COMMIT·사후검증·undo).

## 미해결 / 블로커
- **CONFIRM-A 타공 proc_cd**(코드트랙·실무진): 단가행 proc_cd=PROC_000105 vs 옵션환원 PROC_000104. 시뮬레이터가 procs=[{PROC_000105,타공수}] 직접 보내야 타공 가산. 데이터만으론 타공 효력 미보장. proc_cd 통일(데이터) vs 호출자 전송(코드) 확정 필요.
- **CONFIRM-4 각목**: 의미축=**세로/가로(사용자 확정)**. 단 권위 단가 2개(4000/8000)가 세로↔가로 중 어디에 배정되는지 매핑 규칙 미확정 → 각목 적재 BLOCKED(실무진).
- **opt 동시선택 한계**(코드트랙): 가공+추가 동시(예 봉미싱+큐방) 시 selections opt_cd 단일키로 1건 누락. 그룹별 키 분리=§6/webadmin 코드.
- **위젯 경로**(별 트랙): `_opt_maps` 자동변환은 위젯 전용·시뮬레이터 미동작. 지금은 시뮬레이터 중심(사용자 directive), 위젯은 별도 작업.
- **RC-2 잔여 CPQ 미등록**: 족자 천정고리·LINEN_FINISH·각목 등 BLOCKED분 옵션 미등록 → 가산 트리거 불가(CONFIRM 의존). 메쉬/캔버스/린넨우드봉 큐방·끈·우드행거·우드봉은 2026-06-23 등록 COMMIT 완료.
- **RC-2 PET배너(136) HOLD-1**: 거치대 택1 그룹에 기존 "실외용거치대" ↔ 신규 단면(S1)/양면(S2·23000/25000) 의미 중복 → 거치대 옵션 모델링 실무진 CONFIRM 후 적재.
- **RC-4 캔버스행잉(133)**: ✅ 해소(2026-06-23) — 우드행거 단가행 siz_cd 재배선(258→172·315→174·317→197, 134 사이즈→133 사이즈) COMMIT. 본체 comp use_dims는 `[siz_width,siz_height,min_qty]` 치수티어라 충돌 없음 확인.
- **CONFIRM 잔여**: B(린넨마감 opt_cd 재배선)·C(족자 천정고리 bdl_qty vs opt_cd)·D(본체 공식 바인딩 대상)·미니배너/미니보드 권위부재 수량단가 출처.
- **그 외 카테고리 교정 큐**(전 11시트): 아크릴20 미바인딩 R-B3-1(Q-ACR-MISSING20)·GP-2 FORMULA R-GP4-5(반팔/후드티 포함)·R-GP4-2~4·CPQ MISS·배치1~3 NO-GO 교정명세(`06_gate/remediation-spec-batch*.md`).

## 이번 세션 결정 (재론 금지)
- **4장치 차원 메커니즘은 코드에 이미 구현**(옵션 opt_cd·ref_dim_cd / 공정 proc_grp+dim_vals / 템플릿 addon). 가공/추가/프리셋 교정은 **데이터 작업**(use_dims+단가행 판별값+addtn 바인딩)이지 새 코드가 아님. 빈 use_dims=`[]`로 묶으면 silent always-add 함정.
- **정정**: 앞서 "siz_preset 위젯/price_views 코드 변경 필수"는 과한 진단. opt_cd 차원으로 코드 변경 없이 가능(시뮬레이터 한정).
- **실사는 수량구간할인 없음** — 굿즈/파우치·문구·아크릴 전용(사용자 확정).
- **각목 = 세로/가로 구분**(900mm 임계 아님·사용자 확정).
- **RC-5 권위(silsa-l1)=정답·라이브 교정**(사용자 확정).
- **구조-우선**: 단편 교정(프리셋만) 금지 — 한 상품의 프리셋·커스텀·가공·추가·공정상세를 한 모델로 통합 후 적재.
- **K6 자격증명**: `.env.local HUNI_ADMIN_*`(사용자 갱신분) 정상 동작 — product-viewer gstack 로그인 OK(이전 "stale" 판정은 당시 값 오류).
- R-B3 A3/A2/A1=실제 등록 siz_cd 용지 프리셋(고정 7000/7000/12000)·사용자입력=nonspec 면적매트릭스(600mm~·900은 일반현수막용·포스터 무관).

## 건드리지 말 것 (확정·되돌리지 말 것)
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
