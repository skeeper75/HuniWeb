# Huni-Webadmin-Load (§36) — CHANGELOG (최신 위 PREPEND)

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
