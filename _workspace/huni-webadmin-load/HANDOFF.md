# Huni-Webadmin-Load (§36) HANDOFF — webadmin UI 전용 적재·가격시뮬레이터 완성

> ★다음 시작점: **프리미엄명함(PRD_000031) 박 차원 교정을 webadmin UI로** — 아래 "박 설계 확정"대로.
> 하네스 신설 260706. 목표=라이브 DB 직접 적재 금지·오직 webadmin UI로 상품 가격 적재/교정 →
> 가격시뮬레이터에서 **예측 기대값(권위 셀)=실제 가격·제외0**. 잘못된 차원 매핑 전수 교정.

## 정책 [HARD] (relitigate 금지·지니)
- **라이브 DB 직접 적재/psql 쓰기 금지.** 모든 등록=webadmin UI(https://huni-admin.printly.co.kr/admin/) · gstack browse.
- 착수 전 **preflight 필수**: `python3 _workspace/huni-webadmin-load/preflight.py "<상품명>"`(SOT+엑셀 셀·실무진 코멘트+pricing.py). 추측·재질문 금지.
- 최신 권위: 가격표 260705·상품마스터 260703. 값=단가.01(×수량)/총액.02(그대로)/합가.

## ★박 차원 교정 설계 = 확정 (다음 세션 즉시 착수·relitigate 금지)
지니 확정: **박 가로×세로 = 공정상세옵션→dim_vals** (오시·타공·가변 16개 공정 동형). 구역/opt_cd/엔진코드/ceiling 다 불필요.
- **정답 패턴**(라이브 실증): 오시 `COMP_PP_CREASE_1L` use_dims=`[proc_cd,min_qty,proc_grp:PROC_000029]`·단가행 `dim_vals={"줄수":2}=6000`.
- **박 교정(데이터만·코드0·엔진 무변경·전부 webadmin UI)**:
  ① 박 공정상세옵션(PROC_000033·PROC_000050): "크기" → **가로·세로**(B02 구간 10/20/40/60/80). 화면=`master/<proc>` 상위공정 편집.
  ② 박 단가표 재적재: 가로×세로 siz_width/height **컬럼→dim_vals{가로,세로}** + use_dims에서 siz_width/height 제거(오시 동형). 화면=`price-viewer/comp/<comp>/edit`.
  ③ **차원 제거=값 이전과 동시**(연결 먼저·끊김 없음). 값=B03 verbatim.
  ④ 시뮬레이터 검증: 가로40×세로40·200장→구역D→17,800 예측=실제.
- 대상 박 comp 6: COMP_FOIL_PROC_LARGE/SMALL_STD·SPECIAL·SETUP_LARGE/SMALL. 상세=[[dimension-siz-width-height-material-only-260706]].

## 다음 세션 순서 (프리미엄명함 파일럿)
1. `preflight.py 프리미엄명함` → 권위 B02/B03로 **예측 기대값 표**(가로×세로×수량→가격) 먼저 작성(DRY-RUN 기준).
2. 박 공정상세옵션 가로/세로 설계 확정 → webadmin `master/proc` 화면에서 편집(인간 승인).
3. 박 단가표 재적재(dim_vals 이전)를 webadmin `comp/edit` 화면에서(인간 승인·직접 DB 금지).
4. sim-verifier: 시뮬레이터 예측=실제·제외0 확인. 미달 시 2로.
5. 통과 후 나머지 박 6상품·타 상품 동형 전파.

## 산출물 (구축 완료 260706)
- `WEBADMIN-LOAD-PATH-MAP.md`(전 메뉴 적재 경로·상품8섹션+가격공식/구성요소+할인+옵션+제약+마스터+시뮬레이터).
- `preflight.py`(원본 선독·검증됨). 시각 명세=`tmp/premium-namecard-load-spec.html`(구조도).
- 에이전트 5(opus): hwl-preflight·cartographer·mapping-auditor·ui-loader·sim-verifier. 오케스트레이터 스킬 + rules §36.
- 인프라: `_workspace/_foundation/PRICE-SHEET-SOT-260705.md`·`extract_sheet_notes.py`.

## 라이브 상태 / 건드리지 말 것
- 박 = **원상**(이번 세션 실험 전부 되돌림·prcs_dtl_opt="크기"·use_dims 원래대로).
- 결함1(아크릴 수량할인 배선 18)·결함3(책자내지 PROC_000004 5)= **정책 전 직접 COMMIT·검증완·유지**(되돌리지 말 것). 앞으로 교정은 UI로만.
- raw/webadmin 코드 = 무수정(라벨 실험 revert 9c5788e). rule 1.
