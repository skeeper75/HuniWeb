# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 7세션)

> 재시작 포인터. 활성 하네스=가격테이블 무결성(§26·배치빌더)·가격 종단(§27).
> 권위=2엑셀(상품마스터260610·가격표260527). 엑셀=권위·라이브=감사대상·단가 verbatim.
> ★다음 세션 필독: **`huni-price-table-integrity/_batch/SHEET-LOAD-PLAYBOOK.md`**(시트별 효율 적재 표준 절차+재사용 쿼리).

## ★이번 세션(7세션) 한 일 — 배치빌더 전수 진단 + 출력소재 적재 종단

1. **배치 빌더 파일럿→전수** — 디지털인쇄비 1시트 결정론 grid-diff(토큰0) 검증 → 19시트 전파(DIFFED 11·결함 36·적재된 셀은 대부분 권위 verbatim). `_batch/ALL-SHEETS-summary.md`.
2. **4원 적재 모델 확정** — 코드↔라이브DB↔라이브화면↔엑셀. 사슬=상품→공식→구성요소(use_dims=그리드 컬럼)→단가행. 자동로더 없음·수동 그리드. `_batch/LOADING-MODEL-4WAY-260629.md`.
3. **라이브 COMMIT 4건**(전부 verbatim·undo 보유):
   - **코팅 유광 92행**(COMP_COAT_GLOSSY 0→92·유광 견적불가 해소·undo=`coating-glossy-undo.sql`).
   - **디지털 흑백 단면 106행**(★도수=인쇄옵션이 담음: 사장님이 POPT_000008"단면1도"(앞면도수 CLR_000002) 추가 → 그 print_opt에 흑백 단면 적재·칼라 212행 무변경·엔진변경 불요·undo=`digital-mono-s1-undo.sql`).
   - **출력소재 PET 2행**(투명/반투명 PET 260g 하위 144/147=1100·투명엽서 견적불가·undo=`paper-gap9-clean5-undo.sql`).
   - **출력소재 특수용지 하위 18행**(아코팩~큐리어스스킨 색상별 권위값 verbatim·디지털엽서3종 견적불가·undo=`paper-specialty18-undo.sql`).
   - ※중간 오적재 3절 3행=가짜결함 적발·즉시 제거(원리2).
4. **시트별 효율 적재 플레이북 정립** — 4원리(카테고리 라우팅·가짜결함 가드·상위하위 레벨·검증) + 재사용 쿼리. `_batch/SHEET-LOAD-PLAYBOOK.md`.

## ★다음 시작점 (우선순위)
1. **출력소재 마무리 결정 1건** — 특수용지 기본색(큐리어스스킨 화이트361=880·스타드림 다이아 등)을 **하위로 통일 적재**할지(권장 옵션1) vs 부모 유지(옵션2). 부모를 손님이 직접 고르는 경로 확인 후 결정. (큐리어스스킨 화이트361=880은 권위에 있음·하위0).
2. **나머지 시트 적재** — 플레이북 절차로: 출력소재 잔여·디지털 흑백 양면(양면1도 print_opt 추가 시·B01 colC 권위값)·제본(del_yn=Y comp 다수=재편 흔적·먼저 이해)·매핑미상 6시트(커팅타공·스티커·명함·박류).
3. **§17 정리거리** — 중복 mat_cd(MAT_000260 "아트250 + 무광코팅"=MAT_000250 dup)·실사 PET(MAT_000178 .08에 1100 잘못 적재=투명엽서가 쓰는 건 .01 디지털 PET).

## 미해결/블로커
- **디지털 흑백 양면** = 사장님이 "양면1도" 인쇄옵션 추가하면 즉시 적재(권위 B01/B02 colC).
- **흑백 상품 노출** = 1도 인쇄 상품 생길 때 t_prd_product_print_options에 POPT_000008 연결(후속·사장님 결정).
- **제본 재편**(중철·무선·하드커버 등 del_yn=Y) = 단순 복원 금지·재편 의도 이해 먼저.
- **면적가격(.08 실사·.20 아크릴)** = mat_cd 아닌 면적 → 별도 감사(이번 출력소재 감사 범위 밖).

## 이번 세션 결정 (relitigate 금지)
- **도수(흑백/칼라)는 인쇄옵션(print_opt)이 담는다** — t_prt_print_options.front/back_colrcnt_cd=clr_cd. 엔진은 print_opt_cd로 매칭(clr_cd는 NON_QTY_DIMS에 없음). 그래서 흑백=새 print_opt(POPT_000008)+단가. clr_cd 엔진변경(갈래A) 폐기.
- **출력소재 적재 레벨=상품 옵션 참조 레벨**(option_items ref_key1). 색상별 절가 상이→부모복사 금지·각 하위 verbatim.
- **가짜결함 가드**=상품 공식이 그 component를 실제 바인딩하는지 필터(아트250코팅·3절=BOM only).
- **substrate 카테고리별 component 라우팅**(.01→COMP_PAPER·.11/.13→완제품가·.08/.20→면적).

## 건드리지 말 것 (라이브 COMMIT·undo 보유)
- 이번 4 COMMIT(코팅유광92·흑백단면106·PET2·특수용지18) + 이전 세션 전부(명함18·포스터transpose 등).
- undo 스크립트: `_batch/{coating-glossy,digital-mono-s1,paper-gap9-clean5,paper-specialty18}-undo.sql`.

## 산출물 위치
- 플레이북: `huni-price-table-integrity/_batch/SHEET-LOAD-PLAYBOOK.md` ★
- 배치 빌더: `_batch/scripts/`·`ALL-SHEETS-{defects.csv,summary.md}`·`LOADING-MODEL-4WAY-260629.md`
- 적재본/undo: `_batch/*-load.sql`·`*-undo.sql`
- 실측 환경: `_foundation/live-snapshot/`·시뮬레이터 `_foundation/batch/lib_huni.py`
- 쉬운 설명: `_foundation/가격파이프라인-쉬운설명-260629.md`
- §18 도수설계(참고·폐기 갈래A): `huni-price-engine-design/03_design/*-dosu.*`
