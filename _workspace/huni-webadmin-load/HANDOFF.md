# Huni-Webadmin-Load (§36) HANDOFF — webadmin UI 전용 적재·가격시뮬레이터 완성

> ★다음 시작점: **대형 박 6 comp 전파** + (별도) **박크기 상품별 제약 개발 요청서**. 아래 참조.
> 목표=라이브 DB 직접 적재 금지·오직 webadmin UI로 → 가격시뮬레이터 **예측(권위)=실제·제외0**.

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
