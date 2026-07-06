# Huni-Webadmin-Load (§36) HANDOFF — webadmin UI 전용 적재·가격시뮬레이터 완성

> ★다음 시작점: **박크기 상품별 제약 개발 요청서**(제약엔진 확장) + 커버리지 갭 보완(펄박·백박·대형 금무광/은무광).
> 목표=라이브 DB 직접 적재 금지·오직 webadmin UI로 → 가격시뮬레이터 **예측(권위)=실제·제외0**.

## ★박 확장 = 소형+대형 완료 (260707)
- **박 소형 3 + 대형 3 = 전부 dim_vals 교정 완료·검증**. use_dims=`[proc_cd,min_qty,proc_grp:PROC_000033]`·siz 0.
  - 소형: STD1620·SPECIAL540 (명함). 대형: STD3328·SPECIAL3328·SETUP512 (책자·접지카드·쿠폰). SETUP_SMALL만 flat 유지.
  - 검증: 대형 2단접지카드 금유광 가로90세로90 1000장=동판18,000+박120,000(구역C)·특수홀로그램=150,000·격자밖 제외. 권위 일치.
- **범위 판별**: `has_proc=t`(공정)만 대상. 포스터·아크릴 17 comp=siz_width/height **정당한 소재 사용·건드리지 말 것**.
- **★3단계 순서**(대형서 확립): ①use_dims proc_grp 추가+siz 유지 ②그리드 /save(dim_vals·siz 유니크키 clean delete) ③siz 제거.
  (proc_grp 없이 저장하면 가로/세로 파라미터 미인식; siz 먼저 빼면 orphan.)

## ★형압(PROC_000050) = 완료 (별도 EMBOSS 컴포넌트 신설·배선·검증)
- prcs_dtl_opt 크기→가로/세로 integer. 양각(PROC_000051)/음각(PROC_000052)=무선책자·PUR책자(책자=대형).
- 지니 확정: 형압=박과 동일(동판+**일반박STD** 복제·금유광 소스).
- **박 컴포넌트가 형압 못 담음**(proc_grp=박) → 별도 EMBOSS 신설로 해결:
  - 신설 `COMP_EMBOSS_SETUP_LARGE`(128)·`COMP_EMBOSS_PROC_LARGE_STD`(1664) = comp_typ **박형압비(PRC_COMPONENT_TYPE.05)**·prc_typ.03·use_dims `[proc_cd,min_qty,proc_grp:PROC_000050]`.
  - 그리드=동판/일반박 대형 값 복제(양각·음각). 공식 배선=`PRF_BIND_MUSEON_FOIL`·`PRF_BIND_PUR_FOIL` disp_seq 5·6·addtn_yn=Y.
  - **검증**: 무선책자 양각 가로90세로90 1000장=동판18,000+가공120,000(구역C)·음각 가로50세로50 200장=11,000+65,000(구역A). 권위 일치.
- **형압 소형**(260707 후속3): `COMP_EMBOSS_SETUP_SMALL`(동판 flat 5000·2행)·`COMP_EMBOSS_PROC_SMALL_STD`(소형 일반박 복제·540행·proc_grp:PROC_000050) 신설·적재. **grill만 준비·미배선/미검증**(형압명함 PRD_000038=미구축 stub·공식0·base 완제품가 "별도설정"·use_yn=N; 활성 명함 형압 사용 0). 형압명함 활성화 시 base 세팅+배선 필요.
- 형압 컴포넌트 4종 완비: 소형/대형 × SETUP/PROC.
- **UI 방법 교훈**: ①컴포넌트 생성=`tprcpricecomponents/add`(hidden set+올바른 폼 submit·use_dims에 proc_grp:PROC_000050) ②공식배선=`tprcpriceformulas/<frm>/change` **인라인 formset**(tprcformulacomponents_set)·comp_cd=**autocomplete select**(옵션 AJAX·빈값)→`<option>` 주입 후 value 설정·TOTAL_FORMS 증가·INITIAL부터 채움. (tprcformulacomponents 단독 add는 404·인라인 전용.)

## 정책 [HARD] (relitigate 금지·지니)
- **라이브 DB 직접 적재/psql 쓰기 금지.** 등록·교정=webadmin UI 엔드포인트만(gstack browse). `HUNI_ADMIN_URL=https://huni-admin.printly.co.kr/admin/product-viewer/`(260707 printly 도메인으로 갱신).
- 착수 전 **preflight 필수**: `python3 _workspace/huni-webadmin-load/preflight.py "<상품명>"`. 추측·재질문 금지.
- **★전 사슬 확인**(지니): 가격공식 ← 가격구성요소 / 상품구성요소 / 기준마스터 모두 점검 후 시뮬레이터 검증.
- **siz_width/siz_height = 소재(자재) 전용 차원**. 가공(박·형압)의 가로/세로는 **공정상세옵션→dim_vals**(재사용 금지).

## ★박 소형 교정 = 완료 (프리미엄명함 파일럿·260707)
- **PROC_000033 prcs_dtl_opt**: "크기" → 가로·세로(**integer**·mm·price_dim 없음). integer 필수(_norm str 매칭·오시 동형).
- **COMP_FOIL_PROC_SMALL_STD(1620)·SPECIAL(540)**: siz_width/height 컬럼→dim_vals{가로,세로} 이전, siz 컬럼 NULL,
  use_dims=`[proc_cd, min_qty, proc_grp:PROC_000033]`(siz 제외·SPECIAL은 proc_grp 보강). SETUP_SMALL 무변경.
- **검증 통과**: 실화면 금유광 가로40세로40 200장 → 박17,800+동판5,000, 최종 31,800, **제외0**. 권위 B03 일치(19,200·22,700·14,300도).
- 상세·교훈=`REMAP-SPEC-FOIL-SMALL.md`. 값=권위 verbatim(EXPECTED-FOIL-SMALL.json 504행).

## ★적재 순서 교훈 [HARD] (재발방지)
- **그리드 저장 → use_dims siz 제거 순서 필수.** 역순=자연키 붕괴→orphan(empty dim_vals) 잔존→ERR_AMBIGUOUS.
  (SPECIAL에서 발생·복구: siz 임시복원→페이로드 재저장(orphan 전삭제)→siz 재제거.)
- use_dims 편집기(OrderedDimsWidget) 함정: 페이지에 form 2개(logout-form·tprcpricecomponents_form).
  **반드시 `document.getElementById('tprcpricecomponents_form')` 타겟**(querySelector('form')=logout→세션끊김).
  hidden 직접set은 위젯 re-sync에 덮임 → available 항목 .click()으로 이동 후 올바른 폼 submit.

## 다음 세션 순서
1. **대형 박 전파**: COMP_FOIL_PROC_LARGE_STD/SPECIAL·SETUP_LARGE. 대형은 siz 컬럼 사용/동판 구간별 여부 preflight 먼저.
   PROC_000050(형압)도 "크기"→가로/세로 동형(명함 미사용이라 후속). 순서=그리드 저장→use_dims 정리(위 교훈).
2. **박크기 상품별 min/max 제약 = 개발 요청서**: 제약엔진 VAR_KEY_MAP(7차원)에 siz_width/height 없음·범위 규칙유형 없음.
   상품군마다 박 상한 다름(명함 세로≤50) → 코드 확장 필요(§31 또는 개발 전달). 현재는 격자상한 40/80 자동 ERR_ABOVE_MAX만 방어.
3. **커버리지 갭**: 일반박 펄박(PROC_000045)·특수박 백박(PROC_000046) 단가행 누락 보완 판단.
4. 위젯 레이어: dim_vals 정확매칭이라 손님 격자밖(35mm) 입력 시 no_match → 위젯이 tier 제시/올림(프런트).

## 산출물 (260706~07)
- `REMAP-SPEC-FOIL-SMALL.md`(완료 실적재본·교훈)·`EXPECTED-FOIL-SMALL.json`·`WEBADMIN-LOAD-PATH-MAP.md`·`preflight.py`.
- `tmp/foil-remap/`(페이로드·browser 스크립트·백업 2168행).
- 에이전트5·오케스트레이터 스킬·rules §36.

## 라이브 상태 / 건드리지 말 것
- 박 소형 3 comp = **교정 완료**(위 상태). 되돌리지 말 것.
- 결함1(아크릴 수량할인 배선)·결함3(책자내지 PROC_000004)= 정책 전 COMMIT·검증완·유지.
- raw/webadmin 코드 = 무수정. `.env.local` IGNORED 검증됨(HUNI_ADMIN_URL printly로 갱신).
