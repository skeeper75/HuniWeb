# hdx — CHANGELOG (최신 위 PREPEND)

## 2026-07-04 — 연결 무결성 스코프(linkage·양방향) + 아크릴키링 저청구 규명 + 등록 점검 파일럿

**배경(지니 재정의)**: 실무진이 webadmin 에서 기준정보를 수정·이름변경·삭제후재등록 하면서 상품↔공식↔
구성요소↔단가 **연결 고리가 끊기는(단절)** 걸 한 바퀴 돌며 잡는 것. 값 정확성이 아니라 **배선 무결성**.
각 연결지점을 **정방향+역방향** 모두 확인(정방향만 보면 "참조 정상"이라 안 보이는 단절이 역방향서 드러남).

**신규 스코프 `--scope linkage`** (배선 연결 전용 렌즈·양방향):
- `diagnose/linkage_dx.py` `LinkageDx` — 4에지 양방향: E1 상품↔공식·E2 공식↔구성요소·E3 구성요소↔단가차원·
  E4 상품선택↔단가. search-before-mint: E2 배선(고아/죽은/오염)=`wiring_scan` 재사용·E3/E4=`DimConformanceDx`
  재사용(드리프트 0)·신규=E1 양방향+E2 dangling/빈공식+오염 재연결후보 탐지.
- `remediate/linkage_rmd.py` `LinkageRmd` — 안전 재연결만 auto(E3 use_dims·가격중립)·E2F 재연결후보=review+SQL
  제안(가격 복원이라 가격중립 아님·webadmin 확인)·E4=needs_authority·E2R placeholder=blocked_human·E1=review.
- `diagnose_remediate.py` SCOPES/REMEDIATORS 에 linkage 등록. `linkage_selftest.py`(양방향 검출·재사용 드리프트0·
  전건 라우팅·값 날조 금지·안전 재연결 6검증) **6/6 GO**.
- **실적(라운드1)**: 68건 단절 — E1F 17(비활성 상품 청소)·E1R 8(아크릴 공식 상품 미배선)·E2R 6(아크릴
  placeholder 빈배선)·E4 37(손님선택값 단가행 없음). **E2F/E3=0 = 지금 rename dangling 단절 없음**(코드 안 바뀌는
  거버넌스와 정합·골격 온전). 도구는 앞으로 끊기면 역방향서 즉시 포착하도록 장착.

**★아크릴키링(PRD_000146) 고리 옵션 저청구 규명**(E1R 역방향 단서 → 근본원인 추적):
- 손님 고리옵션(은색고리·금색고리·은색구슬줄)이 **가격에 안 닿아 0원 청구**. 공식 `PRF_CLR_ACRYL`(공용·10상품)이
  base(투명아크릴 인쇄가공비)만 물고 부품 comp 미배선 + option_items 차원환원 0.
- **★오교정 회피(핵심 교훈)**: E1R 고아 공식(PRF_ACRYL_KEYRING 등)은 끊긴 선이 아니라 **폐기된 옛 방식**
  (상품은 옵션-CPQ로 이전·부품 단가행이 opt_cd 로 묶임). 재연결했으면 **이중청구**날 뻔 — [HARD] 값 검증 전
  사실 아님이 오교정 막음.
- **권위값 확보**(가격표 260527 아크릴 60~63행): 고리없음 0·은색구슬줄 300·은색고리 1,100·금색고리 1,200원.
  상품마스터 260610 교차확인("은색/금색고리=*가격표참고"). **값은 이미 DB 단가행에 존재**(COMP_ACRYL_KEYRING·
  옛 코드 OPV_000473/474/026/027)·손님 옵션(OPV_000624~627)이 안 가리켜 0원 = **순수 연결 끊김**(값 문제 아님).
- 교정 = 재연결 2단계(opt_cd 재지정 + 부품 comp 도달성). ★[HARD] SQL 전 엔진 옵션-가산 경로 실측 필요
  (공용 공식 직접 추가 시 타 9상품 오염). 명세 = `remediate/WORKLIST-acryl-keyring-undercharge-260704.md`.

**등록 매핑 점검표 파일럿**(지니 관리 방식 확정 = 엑셀 의도 대조):
- `board/registration_check_pilot.py` — 권위 엑셀(상품마스터 260610 아크릴 시트)을 '의도', DB 를 '실제 등록'
  으로 상품별 대조. **내부 정합만으론 못 잡는 아크릴키링 고리 저청구를 엑셀 대조로 포착**(가격경로 끊김·유료옵션 미등록).
- 파일럿 = 아크릴 그룹(고리 저청구 잡음 실증). 한계: 이름매칭 거침(볼체인 색상 vs 은색구슬줄 오탐)·11시트 확장 필요.
- **거버넌스(지니 확정)**: 기준정보 마스터 = 추가O·삭제X·이름변경O → 코드 안 바뀜 → 관리 초점 = **rename 코드깨짐이
  아니라 등록 완전성**. 관리 그림 = 실무진 등록 → 상품별 점검표 → 엑셀 대비 초록/빨강 → 빨강만 교정.

**세션 시작**: 가격 스코프 전수 진단 라운드9 재실행(416건·9차원·드리프트0·전역 NO-GO·직전 라운드8과 동일).

## 2026-07-04 — P5-②c PriceGridDx(19시트 §26 어댑터) — 가격 진단 9차원 완성

**목표**: 남은 전파 차원(가격격자 19시트)을 §26 배치 **어댑터**로 편입 → 가격 도메인 진단 9차원 전 커버.

**얇은 어댑터(재구현 0)**: `diagnose/price_grid_dx.py` 가 §26 `run_all.main()`(권위 엑셀 L1 CSV ↔ 라이브
스냅샷 시트별 매트릭스 diff·19시트)를 **호출**하고 산출을 공통 Defect 로 변환만. §26 로직 자체는 재사용(재구현 금지).
- **보드 입도**: 셀 단위(499행) 아닌 **시트×결함유형 요약** 1건씩(셀 상세는 §26 `ALL-SHEETS-defects.csv`).
- DIFFED 시트 = 결함유형별(missing_cell/mismatch/transpose/dim_missing…) 요약 · UNMAPPED 시트 = 매핑 미상
  (사람 확인·review) · OUT_OF_SCOPE(판걸이수·굿즈파우치 t_dsc_*) = 제외.
- graceful: §26 배치 미가용(권위 CSV 부재 등) 시 빈 결과 + note(파이프라인 안 깨짐).
- `PriceGridRmd`: HIGH(미적재/불일치)→needs_authority(§26·§7 dbmap 적재·값 날조 금지)·나머지→review.

**실적**(라운드8·9 Diagnoser): 총 407→416. price_grid 9 = missing_cell HIGH 2(출력소재 30셀 specialty 용지
미적재·엽서북 468셀[병합 후 comp_hint 시점종속 드리프트 의심]) + 아크릴 unmapped 1 + UNMAPPED 6시트(커팅타공·
명함포토카드·스티커·박대형/소형/백업). 11 DIFFED 중 7시트 100% 일치(디지털954·코팅184·접지336·인쇄후가공117·
합판370·봉투40·제본74·포스터687) — 라이브=권위 거울 확인.

**주의**: §26 배치는 자체 SNAP=latest 사용(--snap 미반영)·시점종속 드리프트(엽서북 468이 그 예) 재스냅 후 재확인.
§26 dir 산출물(ALL-SHEETS-defects.csv 등)은 §26 소유·재생성물(hdx 커밋 대상 아님).

**셀프테스트**: diagnose 스모크가 9 Diagnoser 커버(§26 어댑터 무네트워크 동작). 전 레이어 5/5 GO.

**가격 파일럿 완성**: 진단 9차원(배선·차원정합·공정·병합·계산가능성·옵션CPQ·수량·판형·가격격자) 전 커버 +
교정생성(값 날조 금지) + 적대적 재실측 + 반자동 라운드 + 첫 실적재. 남음(선택)=codex 2차·실무진 액션·타 도메인 확장.

## 2026-07-04 — P5-②b 도메인 전파: QtyRuleDx(수량) + PlatesizeDx(판형)

**목표**: 파일럿 검증된 Diagnoser 계약을 수량·판형 차원으로 전파 → 진단 커버리지 8차원(설계 §3).

- **QtyRuleDx** ← `batch/qty_rule_audit_260702.py`(라이브 psql) **Snapshot 포팅**(결정론화). 판정 verbatim:
  TRAP_MIN(상품 min_qty < 가격구간 하한 → 구간 아래 주문 시 comp 무료·저청구·high)·NO_RULES(min 미등록+구간·
  high)·INFO_MAX(초대량 검토·low). 대응 `QtyRuleRmd`(함정→needs_authority[올바른 min=권위/가격표 하한·값 날조
  금지]·INFO_MAX→review).
- **PlatesizeDx** ← `platesize-remediation/diagnose_all.py`(이미 스냅샷·로직 verbatim) + 상시게이트
  `plate_wiring_integrity_check.sql`. 판정: PLATE_MISMATCH(상품 판형 ∩ comp 단가 판형 = 0 → 부분 견적0·저청구·
  high)·PLATE_MISWIRE(plate_sizes.siz_cd 가 유효 판형[impos_yn=Y·시트판형 포함] 아님·데이터 위생·medium).
  대응 `PlatesizeRmd`(needs_authority/review).

**충실성 검증(드리프트 0)**: QtyRuleDx TRAP_MIN 8 = 원본 qty_rule_audit(라이브) 8 완전 일치(INFO_MAX 44도 일치).
PlatesizeDx MISMATCH 0 = 원본 diagnose_all 0 일치. 시트판형(SIZ_499/535/475/521) 전부 impos_yn=Y 확인 → 오배선 0.

**실적**(라운드7·8 Diagnoser): 총 355→407. qty_rule 52(TRAP_MIN 8 저청구=2/3단접지카드·프리미엄/펄명함·
무선/PUR책자·미니보드/배너·INFO_MAX 44)·platesize GO(미스매치0·오배선0=이번 세션 dbmap 판형 13상품 교정 완료 확인).

**PriceGridDx(19시트) 제외 명시(no silent caps)**: §26 huni-price-table-integrity 하네스 전체 규모(권위 CSV
추출+시트별 매트릭스 파서)라 단일 Diagnoser 어댑트는 조립 수준 초과 → 별도 어댑터로 후속(P5-②c). 재구현 금지·재사용.

**셀프테스트**: `diagnose/_selftest.py` 확장(QtyRule 함정=high·undercharge·PlatesizeDx MISMATCH 가드 + 전 8 Dx
스모크 무예외·Defect 유효). 전 레이어 5/5 GO.

**다음**: P5-②c PriceGridDx 19시트 어댑터(§26 배치 브릿지) + codex 2차(선택).

## 2026-07-04 — P5-②a OptionCpqDx 신규 (옵션 파라미터 연결 끊김·저청구)

**목표**: 실무진이 webadmin 에서 옵션 수정 중 파라미터 연결(dtl_opt)을 빠뜨려 생기는 저청구를 전용
스캐너로 전수 검출(설계 §3 갭#5). 근거=이번 세션 실증(메쉬 타공 옵션 dtl_opt 누락→무료).

**연결 구조**: 옵션 `dtl_opt`(공급 param `{"타공수":4}`) ↔ 단가행 `dim_vals`(요구 param). 엔진은 선택이
dim_vals 키·값을 공급해야 그 단가행 매칭 → 옵션 dtl_opt 비면 param 미공급 → 매칭 실패 → 무료(저청구).

**신뢰도 모델(오탐 가드·핵심)**: 옵션이 공정 참조(ref_dim=OPT_REF_DIM.04)·그 proc 단가행이 dim_vals
param 요구·옵션 dtl_opt 미공급 = 후보. **HIGH** = 같은 (proc,param)을 dtl_opt 로 채운 **형제 옵션 존재**
(param 이 옵션선택형임을 입증) → 저청구 확정. **REVIEW** = 형제 미충전(개수/줄수 = 고객 수치입력 가능성·오탐 회피).

**구조**: `diagnose/option_cpq_dx.py`(OptionCpqDx·`PRICE_DIAGNOSERS` 추가) + `remediate/option_cpq_rmd.py`
(OptionCpqRmd: HIGH→needs_authority[실무진 dtl_opt 값 확인·값 날조 금지]·REVIEW→review).

**실적**(snap_20260704_1554·라운드5): option_cpq 29건(HIGH 1·REVIEW 28). 총 326→355(신규 표면화·전건
라우팅 누락 0). **HIGH 1 = 메쉬배너(PRD_000137) 타공 옵션 OPV_000542 dtl_opt 누락 저청구** — 이번 세션
메쉬 타공 교정(PRD_000138/139)에서 **놓친 상품을 배치 스윕이 전수로 포착**. needs_authority 로 실무진 확인 라우팅
(형제 PRD_000139={타공수:4/6/8} 패턴 참조·값 날조 금지). REVIEW 28 = 개수(변수텍스트/이미지·수치입력 가능성).

**셀프테스트**: `diagnose/_selftest.py`(HIGH=형제 입증형 저청구·REVIEW=수치입력 가능성 판별 가드). verify
셀프테스트 자기완결형으로 견고화(라이브 결함 존재 비의존·합성 Fix). 전 레이어 5/5 GO(foundation·diagnose·remediate·verify·loop).

**다음**: P5-②b codex 2차(선택) + 도메인 전파(판형·가격격자·수량).

## 2026-07-04 — ★첫 실적재: 포스터 use_dims += siz_cd (인간 승인·라이브 COMMIT)

hdx 파이프라인이 낸 **첫 실적재 교정**을 라이브에 반영(인간 승인). 반자동 라운드 종단 실증 —
진단→교정생성→재실측→인간 승인→라이브 COMMIT→재진단 결함 해소를 실제 라이브에서 완주.

- **대상**: `t_prc_price_components.use_dims` / `COMP_POSTER_CANVAS_HANGING` +=siz_cd(사이즈별가 실재하나 미선언).
- **검증 체인**: 라이브 재-SELECT(드리프트 0) → dryrun(무오류·ROLLBACK) → P4 재실측(가격중립 GO) →
  **[HARD] webadmin 실화면**(라이브 가격시뮬레이터: A4=6000·A3=10500·A2=20000·PRICE≠0) → COMMIT →
  **사후 라이브 시뮬 재대조 전 사이즈 불변**(가격중립 실서비스 확증) → 스냅샷 재생성 → 라운드4.
- **라운드4 결함 해소**: dim_conformance 38→37·총 327→326·포스터 UNDECLARED siz_cd **0**·auto_go 1→0.
- **백업/undo**: 라이브 `z_bak_dimconf_usedims_comp_poster_canvas_hanging` 보유·undo SQL 기록.
- 기록: `remediate/COMMITTED-260704-poster-usedims.md`.

## 2026-07-04 — P5-① 반자동 라운드 러너 (`hdx/loop/`)

**목표**: `scan→board→remediate→verify` 를 한 라운드로 묶고 **인간 게이트용 종합 리포트** + 수렴 추이를
낸 뒤 인간 승인 지점서 정지(설계 §2 L6·§5). **[HARD] 완전 무인 금지** — 적재 COMMIT·webadmin 실화면
(7·8)은 인간 게이트. 인간이 승인·적재·`snapshot.sh` 재생성 후 재실행하면 다음 라운드(N+1)가 돈다.

**구조**(`hdx/loop/runner.py`): `run_round(board_res, plan_res, fix_verdicts, round_no, note)` →
이미 계산된 board/plan/verify 결과를 종합 →
- `round-report.md` — 인간이 게이트서 읽는 단일 산출물: 전역 verdict·차원별 결함·**적재 후보**
  (P4 GO auto_data·승인 대상·SQL 포인터)·**재실측 NO-GO**(재조사)·**인간 입력 대기**(worklist·값 날조 금지)·
  **다음 액션**(번호 단계: 승인→적재→snapshot 재생성→재실행).
- `loop-rounds.csv` — 수렴 추이 append(round·total·auto GO/NO-GO·분류별 결함·global verdict).
- 진입점 `--loop` 플래그(→ verify·remediate 자동 활성).

**실행 결과**(snap_20260704_1507·round 3): 전역 NO-GO(라운드 계속). **적재 후보 1**(포스터 use_dims·P4 GO)
· 재실측 NO-GO 0 · 인간 입력 대기 326 결함(blocked_human 10·needs_authority 37·needs_design 21·review 258).
1 + 326 = 327 전건 회계(누락 0). 전역 정지 = `board.global_go`(전 차원 stop_predicate·전 상품 PRICE≠0).

**셀프테스트**(`loop/_selftest.py`): 종합 무손실(차원 결함·전역 verdict 일치)·적재 후보=P4 GO만·
전 결함 회계(worklist+auto=총수·누락 0)·산출물 4검증 GO. 전 레이어 셀프테스트 4/4 GO(foundation·remediate·verify·loop).

**의미**: 가격 파일럿이 **종단으로 GO** — 진단(P2)→교정생성(P3)→적대적 재실측(P4)→라운드 종합(P5-①)까지
한 명령(`--loop`)으로 돌고, 인간 게이트에서 무엇을 승인·적재·재실행할지 단일 리포트로 제시된다.

**다음**: P5-② OptionCpqDx 신규(메쉬 타공 dtl_opt 저청구 근거) + codex 2차(선택) + 판형/가격격자/수량 도메인 전파.

## 2026-07-04 — P4 적대적 재실측 (`hdx/verify/`)

**목표**: auto_data 교정본을 적재 **전**, `foundation/engine.py`(pricing.py verbatim)로 독립 재계산해
배치가 스스로 검증(생성≠검증·설계 §2 L5·§6). auto_data 게이트의 "★P4 재실측" 술어를 실제로 충전.

**3면 판정**(전부 통과=GO·하나라도 실패=NO-GO·적재 금지):
1. **가격중립** — engine 재계산이 교정 전/후 단가 동일(허용오차 0). 영향 comp 를 `mutation` 에서 해석
   (price_components→key.comp_cd·component_prices→comp_price_id 역추적).
2. **결함해소** — 교정이 겨냥한 결함(fix.defects)이 재진단에서 사라짐.
3. **무회귀** — 어떤 차원에도 새 결함 0(적대적: 교정이 다른 곳을 깨지 않는가). 전 Diagnoser 재실행 diff.

**구조**:
- `overlay.py` `MutableSnapshot` — `Fix.mutation`(기계판독 쌍·`models.py` 가산)을 스냅샷 사본에 in-memory
  적용(라이브 미변경·JSON 컬럼 직렬화). Diagnoser·engine_rows 가 `table()` 경유하므로 오버레이 전파.
- `golden.py` — engine.match_component 로 comp 단가 재실측(대표 선택=각 단가행 자기 차원값).
- `base.py` — `Verdict` + `verify_fix(fix, snap_dir)`.
- 진입점 `--verify` 플래그(→ remediate 자동 활성). `verify/verify-report.md` 산출.

**파일럿 결과**(snap_20260704_1507): `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd = **GO**.
- 가격중립: engine 이 siz_cd 를 use_dims 무관하게 하드코딩(NON_QTY_DIMS) 매칭 → 단가 불변 실증
  (실단가 10500/20000/6000 매칭·**허수 GO 아님**). 결함해소: UNDECLARED·siz_cd 1→0. 무회귀: 새 결함 0.
  → 순수 정합 개선(가격 안 바뀌고 UI/차원 인식만 교정).
- **음성 대조**(항상-GO 버그 배제): 단가행 unit_price 변조 mutation → 검증기가 **NO-GO**(가격중립 아님)를 낸다.
  검증기가 GO/NO-GO 를 실제 구별함 증명.

**셀프테스트**(`verify/_selftest.py`): 재실측 실질성·파일럿 GO·음성대조 NO-GO·worklist SKIP 4검증 GO.
foundation/remediate 셀프테스트 회귀 GO(models.py `mutation` 가산 무해).

**다음**: P5 반자동 라운드 루프(scan→board→remediate→verify→[인간]→적재→재scan) + OptionCpqDx 신규(메쉬
타공 dtl_opt 근거) + codex 2차(선택). 파일럿 포스터 교정 = P4 GO → 첫 라운드 인간 승인·적재 후보.

## 2026-07-04 — P3 교정생성 (`hdx/remediate/`)

**목표**: 진단 결함(Defect) → 교정본(Fix)을 공통 `Remediator` 계약으로 생성(설계 §2 L4).
자동은 교정본 생성까지 — 적재 COMMIT·webadmin 실화면은 인간 게이트(L7·[HARD]).

**[HARD] 값 날조 금지 라우팅**(핵심 설계): 단가값이 권위(엑셀/실무진)에서 와야 하는 결함은
**SQL 을 만들지 않는다** — `blocked_human`/`needs_authority`/`needs_design`/`review` worklist 로만.
`auto_data`(값 날조 없는 결정론 데이터/메타 교정)만 dryrun/fix/undo SQL 트리플 생성.
`foundation/models.py` `Fix` 확장: `remediation_class`·`worklist_note`·`root_comps`·`is_auto`(가산·P1 회귀 GO).

**5 Remediator**(`hdx/remediate/`) — 각 차원 Defect 를 분류·교정:
- `WiringRmd` — placeholder(PENDING/TBD) 빈배선 → blocked_human · 그 외 → needs_authority · 고아 → review
- `CalcabilityRmd` — placeholder wired → blocked_human(같은 근본원인) · 그 외 → needs_design
- `DimConformanceRmd` — **UNDECLARED → auto_data**(use_dims 선언 추가·메타·값 날조 없음) · MISSING → needs_authority
- `ContributionRmd` — HIGH → needs_design(§18) · 저신뢰/유령 → review
- `ComponentMergeRmd` — A/B → auto_data(실 SQL 은 검증된 `gen_commit_sql.py` 승계)

**plan(`plan.py`)**: Fix 병합(**입체 근본원인 dedup**: 같은 root_comps 가 여러 차원에 걸치면 하나로)
→ `remediation-plan.md`(분류별 worklist·실무진 열람) + `.csv` + `sql/*.{dryrun,fix,undo}.sql`(auto_data 만).

**SQL 패턴 승계**(`base.py`): `30_component-merge/_commit/`의 백업(DROP IF EXISTS + CREATE TABLE AS·멱등)
+ 게이트 하드어서션(DO $$ … RAISE→abort) + 트랜잭션 래핑. dryrun=BEGIN…ROLLBACK·undo=백업 원복.

**실행 결과**(snap_20260704_1507·재생성): 327 결함 **전건 라우팅**(누락 0·no silent caps) —
auto_data 1(1결함)·blocked_human 1(10결함)·needs_authority 4(37)·needs_design 1(21)·review 1(258).
- **입체 근본원인 dedup 실증**: wiring 6 + calcability 4 = 같은 `COMP_ACRYL_PENDING_TBD`(실무진 미확정)
  → blocked_human **1건(10결함·wiring+calcability 교차)**으로 병합. 실무진 한 작업으로 통합.
- **auto_data 파일럿**: `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd(사이즈별 가격 6000/10500/20000
  실재하나 use_dims 미선언) → SQL 트리플 생성. 기존 use_dims 보존하며 siz_cd 추가·백업·사전/사후 게이트·undo.
  ★가격중립 예상(엔진은 siz_cd 하드코딩 매칭) → **P4 재실측이 확인**(게이트 술어).

**셀프테스트**(`remediate/_selftest.py`): 전 결함 라우팅·auto_data SQL 건전성(BEGIN/COMMIT·백업·게이트·
dryrun·undo)·근본원인 dedup(차원 교차)·값 날조 금지(worklist SQL 없음) 4검증 GO.

**다음**: P4 적대적 재실측(engine verbatim) — auto_data 게이트의 "★P4 재실측(가격중립 확인)" 술어 충전.

## 2026-07-04 — 스냅샷 재생성 (snap_20260704_1507)

이번 세션 병합/타공 교정이 라이브 반영됨 확인(`db-check` prc_comp 183→197 드리프트) → `snapshot.sh` 재생성.
재진단 결과 **component_merge 9→0(GO 전환)** — 병합 라이브 COMMIT 반영 실증(드리프트 재확인·메모리 H-1).

## 2026-07-04 — P2 진단·보드 (`hdx/diagnose/` + `hdx/board/`)

**목표**: 파편화된 결정론 스캐너를 공통 `Diagnoser` 계약으로 어댑트하고, 제각각이던 출력을
공통 `Defect` 하나로 병합한 **통합 결함보드**를 산출(설계 §2 L2·L3·갭#1·갭#2 해소).

**계약** (`hdx/diagnose/base.py`): `Diagnoser.scan(snap)->list[Defect]` + `stop_predicate(defects)->bool`.
차원별 종료술어가 다르면 override(HIGH만 blocking 등).

**가격 파일럿 5 Diagnoser** — 각 원본 알고리즘 verbatim, 산출을 `Defect`로 통일:
- `WiringDx` ← `batch/wiring_scan.py` (순수함수 `scan_from_snapshot` import·call — 재구현 0)
- `ContributionDx` ← `batch/contribution_scan.py` (순수함수 `scan` import·call)
- `ComponentMergeDx` ← `batch/component_merge_scan.py` (검증된 헬퍼·상수 import + 분류루프 Snapshot 재바인딩)
- `DimConformanceDx` ← `huni-price-table-integrity/…/dim_conformance.py` (라이브 psql 원본을 **Snapshot 포팅**·결정론화·갭#2)
- `CalcabilityDx` ← `batch/score_batch.py` PRICED-0 (**구조 프록시**: 공식 바인딩 있으나 wired comp 단가행 총합 0=PRICE 반드시 0)

**통합 결함보드** (`hdx/board/board.py`): 전 Diagnoser 결함 병합 → `defect-board.csv`(돈영향 정렬)
+ `defect-board.html`(실무진 열람·필터/정렬·차원별 GO 배지·전역 verdict). 전역 verdict = Σ stop_predicate(AND).

**진입점** `hdx/diagnose_remediate.py --scope price [--round N --note]` → snap 로드 → 5 scan → board → 콘솔 GO/NO-GO.

**실행 결과**(snap_20260702): 총 331건 — wiring 6·dim_conformance 37·contribution 274·component_merge 9·calcability 5.
돈영향(저/과청구) 33·치명 5. 전역 NO-GO(결함 잔존·정상).
- **CalcabilityDx 5건** = 아크릴 `COMP_ACRYL_PENDING_TBD`(실무진 미확정·단가행0) 상품 → 정확한 계산불가 신호.

**충실성 검증(드리프트 0)**: 원본 스캐너 카운트와 완전 일치 — wiring 6(dead 6)·contribution 274
(UNCOVERED 169+MISMATCH 96+ORPHAN_PROC 9)·component_merge 9(유형 A 9+B 0). foundation 셀프테스트 회귀 GO. 멱등(재실행 331 동일).

**스코프 명시(no silent caps)**: CalcabilityDx 는 결정론·토큰0 **구조 프록시**만 — simulate 기반 정밀
PRICED-0(선택조합별 0원)은 **P4 적대적 재실측**으로 이관(HANDOFF '엔진 재실측 먼저' 결정). WiringDx 는
스냅샷 3종만(NO_FORMULA=이전사이트 분모 필요 → details 폴백 전용·스캔 범위 밖·CalcabilityDx 가 상품롤업으로 보완).

**주의**: `latest`=snap_20260702(이번 세션 병합/타공 교정 이전) → 보드는 그 시점 상태. 정본 검증엔
스냅샷 재생성 후 재실행(P3 착수 전 권장) 또는 게이트 단계 라이브 재-SELECT(메모리 H-1 드리프트).

**미변경**: 원본 스캐너 `batch/*.py`·`dim_conformance.py`는 손대지 않음(import·call 또는 포팅만).

**다음**: P3 Remediator 통일(교정본 dryrun/fix/undo·백업·게이트) — `foundation/models.py` `Fix` 스키마 재사용.

---

## 2026-07-04 — P1 foundation (`hdx/foundation/`)

공용 토대 6모듈(env·db·snapshot·engine·models·sim) — 파편 스캐너의 복붙 로더·엔진매칭을 공통추출.
`engine.py` = pricing.py `match_component` verbatim 이식. `models.py` = 공통 `Defect`/`Fix`. 셀프테스트 GO. 커밋 `401436e`.
