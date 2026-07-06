# Huni-Webadmin-Load (§36) — CHANGELOG (최신 위 PREPEND)

## 2026-07-07 (후속3) — 형압 소형 컴포넌트 신설·적재 (grill 준비·미배선)

지니: 형압 소형(명함)도 적재·단 use_yn=Y만. 실측 결과 **형압명함(PRD_000038)=미구축 stub**(공식0·base 완제품가 없음·형압공정 미등록·use_yn=N)·활성 명함 중 형압 사용 0.
- **형압 소형 컴포넌트만 신설**(대형과 대칭·상품 미배선): `COMP_EMBOSS_SETUP_SMALL`(양각/음각 동판 flat 5000·2행·use_dims [proc_cd,min_qty])·`COMP_EMBOSS_PROC_SMALL_STD`(소형 일반박 그리드 복제·540행·proc_grp:PROC_000050). 값=소형 박 verbatim(검증셀 양각 가로40세로40 200장=17,800 구역D).
- **미배선/미검증**: 형압명함 비활성이라 시뮬레이터 검증 불가. grill만 준비. 형압명함 활성화(base 완제품가 권위=상품마스터 "별도설정"·불명) 시 배선.
- 형압 컴포넌트 4종 완비: 소형/대형 × SETUP/PROC.

## 2026-07-07 (후속2) — 형압 별도 컴포넌트 신설·배선·검증 완료

박 컴포넌트가 형압을 못 담는 구조 블로커(proc_grp=박)를 별도 EMBOSS 컴포넌트 신설로 해결.
- **신설**: `COMP_EMBOSS_SETUP_LARGE`(128행)·`COMP_EMBOSS_PROC_LARGE_STD`(1664행) = 박형압비(PRC_COMPONENT_TYPE.05)·PRICE_TYPE.03·use_dims `[proc_cd,min_qty,proc_grp:PROC_000050]`. 그리드=대형 박 동판/일반박 값 복제(양각 PROC_000051·음각 PROC_000052·금유광 소스).
- **배선**: `PRF_BIND_MUSEON_FOIL`(무선책자)·`PRF_BIND_PUR_FOIL`(PUR책자) 인라인 formset에 disp_seq 5·6·addtn_yn=Y.
- **검증**: 무선책자 양각 가로90세로90 1000장=동판18,000+가공120,000(구역C)·음각 가로50세로50 200장=11,000+65,000(구역A). 권위 일치.
- **UI 교훈**: 컴포넌트 생성=tprcpricecomponents/add(hidden set), 공식배선=tprcpriceformulas change **인라인**(tprcformulacomponents 단독 add 404), comp_cd=autocomplete select(옵션 AJAX·빈값)→`<option>` 주입 후 value 설정·TOTAL_FORMS 증가.

## 2026-07-07 (후속) — 박 대형 차원 교정 완료 + 형압 진행(구조 블로커)

박 방식을 전체로 확장. **라이브 실측으로 범위 확정**: siz_width/height use_dims 쓰는 20 comp 중 `has_proc=t`(공정) 3개(박 대형)만 대상, 나머지 17개(포스터·아크릴)=소재 정당 사용·제외.
- **박 대형 3 comp 완료**: SETUP_LARGE 512·LARGE_STD 3328·LARGE_SPECIAL 3328 → dim_vals{가로,세로} 결정론 full-sync(권위 후가공_박 대형·verbatim), use_dims siz 제외+proc_grp 보강. **3단계 순서 확립**(use_dims proc_grp+siz유지 → 그리드저장 clean delete → siz제거). 검증: 2단접지카드 금유광 가로90세로90 1000장=동판18,000+박120,000(구역C)·특수150,000·격자밖 제외. 권위 일치.
- **형압 PROC_000050**: prcs_dtl_opt 크기→가로/세로 integer 완료. 지니 확정=동판+일반박STD 복제(무선책자·PUR책자=책자=대형). 값 준비(금유광 복제). **구조 블로커**: 박 컴포넌트 proc_grp=박이라 형압 하위(양각PROC_000051·음각PROC_000052) 거부 → 별도 EMBOSS 컴포넌트 신설+PRF_BIND_MUSEON/PUR_FOIL 배선 필요(다음). SETUP_LARGE 원상(거부 원자적).
- 산출물: EXPECTED-FOIL-LARGE.json·browser/*.save.js·*.hyungap.js·backup 3종.

## 2026-07-07 — 박 소형 차원 교정 = 라이브 완료 (dim_vals·프리미엄명함 파일럿)

지니 지시대로 **siz_width/height(소재 전용) 제외·새 차원(dim_vals 가로/세로)으로 값 이전** 완료(전부 webadmin UI 엔드포인트).
- **PROC_000033 prcs_dtl_opt**: "크기"→가로·세로(**integer**·price_dim 없음). integer 필수(`_norm(v)=str(v)`·number면 40.0≠"40" 매칭실패·오시 줄수 동형).
- **STD 1620·SPECIAL 540**: siz 컬럼→dim_vals{가로,세로} 결정론 full-sync(라이브 현행서 생성·LLM 전사 0), use_dims=`[proc_cd,min_qty,proc_grp:PROC_000033]`(siz 제외·SPECIAL proc_grp 보강). SETUP 무변경.
- **전 사슬 검증**(지니 지시): 가격공식(PREMIUM_FOIL 최신 채택)·구성요소 7·상품공정 박8·기준마스터 단가행 모두 정상 확인 → 시뮬레이터 **실화면** 금유광 가로40세로40 200장 = 완제품9000+동판5000+박17,800 = **31,800·제외0**. 권위 B03 일치(19,200·22,700·14,300도).
- **교훈**: ①그리드저장→use_dims siz제거 **순서 필수**(역순=자연키 붕괴·orphan 잔존·ERR_AMBIGUOUS; SPECIAL서 발생·siz 임시복원→재저장→재제거로 복구). ②use_dims 편집기: form 2개(logout-form 함정)·`getElementById('tprcpricecomponents_form')` 타겟·hidden 직접set은 위젯 re-sync에 덮임(항목 .click() 후 올바른 폼 submit).
- **blind spot 정정**: 라이브 시뮬레이터 먼저 안 보고 메모리서 설계 시작→price_dim:siz_width(소재 재사용)로 이탈. 지니가 "siz는 소재 전용·새 차원으로 이전" 반복 지적→dim_vals 원안 복귀. **원본·라이브 먼저·재질문 금지** 강화.
- HUNI_ADMIN_URL=printly.co.kr 도메인으로 갱신(.env.local). 다음: 대형 박 6 comp 전파 + 박크기 상품별 제약 개발요청서(제약엔진 VAR_KEY_MAP에 siz 없음·범위 유형 없음).

## 2026-07-06 (후속) — 박 차원 교정 설계 확정 (공정상세옵션→dim_vals·오시 동형)

지니 정정: 박 가로×세로는 **공정상세옵션(prcs_dtl_opt)→dim_vals**로 매핑 = 오시/타공/가변 등 **16개 공정이 이미
쓰는 표준 패턴**과 동일. 내가 구역/opt_cd/엔진코드/ceiling으로 과하게 돌아간 것을 라이브 실증으로 정정.
- **실증**: 오시 `COMP_PP_CREASE_1L` use_dims=`[proc_cd,min_qty,proc_grp]`·`dim_vals={"줄수":2}=6000`(siz_width 없음).
  박은 가로×세로가 siz_width/height **컬럼**(소재차원)에 = 잘못.
- **설계 확정**(데이터만·코드0·엔진 무변경·webadmin UI): ①박 공정상세옵션 "크기"→가로·세로 ②단가표 재적재
  가로×세로 컬럼→dim_vals·use_dims siz_width/height 제거(오시 동형) ③차원 제거=값 이전과 동시 ④시뮬레이터 예측=실제.
- 권위: 후가공_박(소형) B02(가로×세로→구역A~E)·B03(구역×수량→가격)·동판비 소형5000/대형 구간별·백업시트 미사용.
- 라이브=박 원상(실험 되돌림). 다음: 프리미엄명함 박 UI 재적재(preflight→예측표→master/proc·comp/edit→검증). 상세 HANDOFF.

## 2026-07-06 — 하네스 신설 (webadmin UI 전용 적재)

지니 지시: ①라이브 DB 직접 적재 금지·webadmin UI만 ②webadmin 전 메뉴 전수 조사→적재 경로 맵(누락0)
③원본(SOT+셀·코멘트+코드) 선독 스크립트 ④프리미엄명함 UI 적재 파일럿. 특히 잘못된 차원 매핑(단가편집)을
전수 교정해 가격시뮬레이터에서 예측 기대값=실제 가격.

- **webadmin 코드 전수 조사**: `config/urls.py` 60라우트 + `views.py:565 SECTIONS`(상품 8섹션) 실조사.
- **적재 경로 체크리스트** `WEBADMIN-LOAD-PATH-MAP.md`: 상품8섹션(사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·
  추가상품·페이지룰) + 가격공식/구성요소(단가표 차원편집) + 할인테이블 + 옵션그룹/옵션/아이템 + 제약 + 마스터 + 시뮬레이터.
- **preflight.py**: SOT + 원본 엑셀 실무진 코멘트 + pricing.py 격자식 + 라이브 사슬 선독(재질문 방지). 검증 완료.
- **에이전트 5**(opus): hwl-preflight·hwl-cartographer·hwl-mapping-auditor·hwl-ui-loader·hwl-sim-verifier.
- **오케스트레이터** `huni-webadmin-load-orchestrator`(에이전트 팀·생성≠검증) + rules(§36 경로게이트) + 레지스트리 1행.
- SOT/코멘트 인프라 계승: `_workspace/_foundation/PRICE-SHEET-SOT-260705.md`·`extract_sheet_notes.py`.
- 다음: 프리미엄명함(PRD_000031) 종단 UI 적재 파일럿(preflight→진단→UI적재→시뮬레이터 예측=실제).
