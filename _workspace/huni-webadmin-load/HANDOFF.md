# Huni-Webadmin-Load (§36) HANDOFF — webadmin UI 전용 적재·가격시뮬레이터·드리프트·사이즈 정합

> ★다음 시작점 후보(택1):
> 1. **사이즈 WRONG_CODE 4건 교정**(스티커 059/060/053→SIZ_000426·맥세이프151→SIZ_000559) — 그리드 결합(아래 블로커).
> 2. **폼보드(129) 비규격 완성** — 방금 nonspec_yn=Y 플립·범위 미설정+커스텀 가격(면적가) 미배선.
> 3. **데이터 위생** — WORK_NULL 115·MULTI_DFLT 86·미태깅 421·규격-0size 48·테스트태그 SIZ_000510.
> 4. **무공식 57**(굿즈 가격 미구축·별도 트랙).
> 목표=라이브 DB 직접 적재 금지·webadmin UI로만 → 시뮬레이터 예측(권위)=실제·제외0.

## ★도구 2종 (raw/webadmin/tools/·결정론·읽기전용·exit0/1)
- **`verify_price_coverage.py`** — 가격 커버리지 드리프트. base 구성요소 use_dims 차원마다 상품 등록값이 t_prc_component_prices에 **값별 any-row-exists**인지 검사. 상관차원 오탐0(브라우저 대체). 실행 `../.venv/bin/python tools/verify_price_coverage.py [--prd|--json]`. **현재 전수 DRIFT 0.**
- **`verify_size_mapping.py`** — 상품↔사이즈 매핑 정합. **재단사이즈 그룹 + 블리드 + 비규격 인지**. `--only WRONG_CODE|TAG_MISMATCH|WORK_NULL|MULTI_DFLT`. WRONG_CODE 4·기타 다수.
- 브라우저 스캐너 `batch-scan/drift_scan.js`(gen_drift·run_drift·analyze_drift)=런타임 실엔진 교차검증 보조(상관차원 오탐 있음·판정은 결정론 우선).

## ★드리프트 전수 = 완결·DRIFT 0 (실 7건 교정)
5유형(재키·미적재·과등록·구조복원·오탐). 상세=`batch-scan/DRIFT-SCAN.md`·`PREMIUM-NAMECARD-DRIFT-FIX.md`·대시보드 `batch-scan/drift-dashboard.html`.
- 프리미엄명함(031)=mat 재키 113→347 등 16행 / 반칼팬시(062)=siz 058=A6/057 8판 복사 180행 / 폰스트랩(220)=siz 428 과등록 제거 / 화이트인쇄명함(040)=인쇄옵션 단면/양면 2행 구조복원+opt_cd 490→810 / 아크릴마그넷·집게·머리끈(147/149/154)=부자재-as-소재 과등록 제거(후가공 add-on 800/700/500 유지).
- 폼보드·포맥스보드=상관차원 오탐(가격 정상·무조치).
- method-skill `hwl-drift-remediation`(§36) 추가.

## ★사이즈 감사 (지니 인쇄도메인 렌즈) — 진단완·교정 대기
상세=`batch-scan/SIZE-AUDIT.md`. **사이즈=재단사이즈·작업사이즈=재단+블리드**(용도별 다름: 엽서1·전단지2·반칼스티커0).
- **WRONG_CODE 4(고신뢰·블리드 근거)**: 053/059/060 스티커=엽서/전단지 코드(블리드2/4)→**SIZ_000426 스티커(블리드0)** · 151 맥세이프=미니모양명함(블리드10)→**SIZ_000559 아크릴키링(블리드0)**.
  - 권위=pangeori row78(반칼스티커 A5 작업148x210·블리드0·아이마크 사방10mm).
  - 반칼원형(058)은 정상 SIZ_000426 매핑(대조 확인).
- **★교정 블로커(스티커)**: COMP_STK_PRINT 가격그리드 A5가 SIZ_000007(엽서·15소재·540행)에 지어짐·SIZ_000426은 1소재(36행). 상품 매핑만 426으로 바꾸면 **가격 깨짐** → 그리드 540행 007→426 재키 동반 필요(dedup·공유 컴포넌트). 실행 방식 결정 대기.
- 맥세이프(151)=아크릴 면적가(siz_width/height)+비규격 → 별도 트랙.
- 기타 버킷: TAG_MISMATCH 55(검토·오탐 있음)·WORK_NULL 115·MULTI_DFLT 86·미태깅 421.

## ★비규격(nonspec_yn) — 폼보드 플립 완료
- **권위 신호 = 상품마스터 사이즈옵션 "사용자입력"**(실사15+아크릴12=27종). 라이브 활성 24종 이미 Y·**폼보드(129)만 N→Y 플립 완료**(Django admin·DB확인). 포맥스보드=사용자입력 없음(규격) N 유지 정확.
- ⚠️ 폼보드 후속: 비규격 범위(nonspec_width/height) 미설정·커스텀 가격(COMP_POSTER_FOAMBOARD_BOARD siz_cd 키잉→면적가) 미지원. 사용자입력 사이즈는 현재 0원.
- 편집 경로: `/admin/catalog/tprdproducts/<prd>/change/` nonspec_yn SELECT(Y/N).

## 정책 [HARD] (relitigate 금지·지니)
- 라이브 DB 직접 적재/psql 쓰기 금지. 등록·교정=webadmin UI만(gstack). 검증 SELECT만 psql 허용.
- 착수 전 preflight. 권위=상품마스터 260703+가격표 260705(+pangeori 판걸이수). **최신버전 검증 선행**(재추출/diff).
- **사이즈=재단사이즈·작업사이즈=재단+블리드**(소재/상품/인쇄방식별)·**"사용자입력"=비규격**·**부자재 add-on 확인**(과등록 판정).
- 전 사슬 확인: 가격공식←구성요소/상품구성요소/기준마스터 점검 후 시뮬 검증.

## 라이브 상태 / 건드리지 말 것
- 드리프트 교정 7건·폼보드 nonspec Y = 완료·되돌리지 말 것.
- 사이즈 WRONG_CODE 4건 = **미교정**(그리드 결합 결정 대기).
- 브라우저 세션 불안정(재시작 시 재로그인 필요·`HUNI_ADMIN_*`). `.env.local` IGNORED.
