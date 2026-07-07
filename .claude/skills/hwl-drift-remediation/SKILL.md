---
name: hwl-drift-remediation
description: >
  후니 §36 webadmin 적재 하네스의 「상품 등록 base코드 ≠ 가격 적재 base코드」(base-data 드리프트) 전수 진단·교정
  방법론. 결정론 verifier(raw/webadmin/tools/verify_price_coverage.py·값별 any-row-exists·읽기전용·exit0/1)로 전
  완제품을 진단하고, 4유형(재키·미적재·과등록·구조복원) + 오탐(상관차원)으로 분류해, 권위(상품마스터·가격표 최신본)
  대조 후 오직 webadmin UI로 교정하고 재검증해 DRIFT 0을 달성한다. 브라우저 스캐너(batch-scan/drift_scan.js)는
  런타임 실엔진 교차검증 보조. 트리거: 드리프트 진단, 드리프트 전수 스캐너, 가격 커버리지 검증, 상품 base코드 가격
  불일치, 재키 교정, 미적재 단가행, 소재 과등록, 인쇄옵션 복원, verify_price_coverage, 드리프트 교정 다시, 특정
  상품 드리프트만. 단순 교정 절차는 §36 오케스트레이터, 제약규칙 등록은 §31이 담당.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Skill
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-07-07"
---

# hwl-drift-remediation — base-data 드리프트 진단·교정

## 목적과 프레임 [HARD]

「상품이 등록한 값(소재·사이즈·인쇄면·옵션)이 가격 그리드에 매칭 단가행을 갖는가」를 전 완제품에서 검사한다.
근본 증상 = **상품 등록 base코드 ≠ 가격 적재 base코드**(base-data 드리프트). 상품코드가 정본 → 가격을 상품에 정합.
드리프트는 「기본조합 1개가 가격 나오면 정상」식 스캔이 놓친다(일부 값만 미적재·구코드 가격보유·add-on이 base 갭을 가림).

핵심 한 문장: **base 구성요소가 use_dims로 키잉하는 차원마다, 상품 등록값이 t_prc_component_prices에 행을 하나라도 갖는가?**
없으면 드리프트. 그 원인을 권위로 규명해 유형을 정하고, webadmin UI로만 고친다. DB 직접 쓰기 없음.

## 진단 도구 (2)

1. **★주 검사기 = 결정론 verifier** `raw/webadmin/tools/verify_price_coverage.py`
   - 실행(webadmin에서): `../.venv/bin/python tools/verify_price_coverage.py [--prd PRD_x] [--json]`. 읽기전용 SELECT·exit 0/1.
   - **값별 any-row-exists** — 그 값이 어느 행에든 존재하나만 봄 → **상관차원 오탐 0**(mat이 siz를 결정하는 대각 그리드도 정상 판정).
   - 검출: `MISSING_DIM`(차원 통째 미등록·그리드엔 값 실재) · `UNCOVERED`(등록값 그리드 매칭 없음).
   - 검사 차원: siz_cd·mat_cd·print_opt_cd·opt_cd(opt_grp 스코프)·bdl_qty. **보류(명시)**: proc_cd(2단 공정그룹)·plt_siz_cd(fn_best_plate 자동).
   - **브라우저보다 엄격**: add-on final>0에 가려진 base 소재 갭도 잡음(아크릴 부자재-as-소재 실증).
2. **보조 = 브라우저 스캐너** `_workspace/huni-webadmin-load/batch-scan/drift_scan.js` (gen_drift.py·run_drift.sh·analyze_drift.py)
   - `/sim-meta`·`/simulate` 실엔진 구동(gstack browse·admin 로그인) → 런타임 동등성 교차검증용.
   - 한계: 한 차원씩 스윕·다른차원 baseline 고정 → **상관차원 오탐**(폼/포맥스보드) 발생. 판정은 결정론 verifier 우선.

## 드리프트 4유형 + 교정 패턴

정답 판정은 **권위 대조 필수**(§ 권위 순서). 유형별 webadmin 메커니즘:

1. **재키(re-key)** — 그리드가 **구 mat/siz 코드**로 가격보유·상품은 **신코드**(spec 추가 정본) 참조.
   교정 = 그리드 코드를 상품 신코드로 재키(가격 무변경). 전용 소규모 컴포넌트 = grid `/save/` full-sync(백업 후).
   예 프리미엄명함 mat 113→347(16행)·봉투 168→595·반칼홀로 163→590. 판정=작업치수/스펙으로([[size-dedup-by-work-dimension-not-name-260707]]).
2. **미적재** — 값이 그리드 어디에도 없음. 권위 대조 후 **동등값 복사**. 공유 대규모 컴포넌트 = Django admin 개별 add
   (`/admin/catalog/tprccomponentprices/add/` POST·순수 INSERT·기존 무영향). 예 반칼팬시 siz 058(100x140=8판)=A6/057(8판) 180행. 스티커=판수 기반(같은 판수=같은 가격).
3. **과등록** — 상품이 잉여 값 등록·권위엔 base로 없음. 교정 = 상품 옵션/소재 논리삭제(del_yn·물리삭제 금지).
   예 폰스트랩 siz 428(17x320) 중복 물리치수 · 아크릴 부자재-as-소재(자석/집게/헤어끈 = 후가공 add-on으로 이미 가격 보유).
4. **구조복원(차원 미등록/삭제)** — base use_dims 차원이 상품에 통째 논리삭제/미등록(MISSING_DIM). 교정 = 섹션 endpoint로
   `row{i}-__key`+`del_yn=N` POST 복원(GET이 del_yn=N만 보여줘도 POST로 되살림)+코드 정합. 예 화이트인쇄명함 인쇄옵션 2행 복원+opt_cd 재키.
5. **오탐(상관차원)** — mat명이 사이즈 내포(A3/A2)·mat×siz 1:1 대각 그리드. 브라우저 스윕만 오검출 → **무조치**.
   손님이 대각 밖 선택 못 하게 §31 제약(mat↔siz 동반) 후보. 결정론 verifier는 CLEAN 판정.

## 권위 순서 [HARD]

**최신버전 검증 선행** — 착수 전 각 엑셀의 최신본이 추출됐는지 확인. 없으면 진행, 더 최신이면 재추출→diff→병합 후 진행.
1. **인쇄상품 가격표(최신)** = `docs/huni/후니프린팅_인쇄상품_가격표_260705.xlsx` · 추출 `_workspace/huni-dbmap/24_price-extract-260705/`.
   후가공(자석·집게·헤어끈 등) 별도 옵션 단가표 포함. 시트 읽는 법 = `_workspace/_foundation/PRICE-SHEET-SOT-260705.md`.
2. **상품마스터(최신)** = `docs/huni/후니프린팅_상품마스터_260703.xlsx` · 추출 `24_master-extract-260703/`.
   default 1행은 면수·옵션 미기재일 수 있음 → 가격표로 교차확정.
3. **판걸이수(pangeori)** 시트 = 판수 권위(스티커 8판/6판/4판 등). **라이브 = 교정대상**(권위 아님).

## 절차 (파일럿 → 동형 전파)

1. **최신버전 검증** → 필요 시 재추출/diff.
2. **전수 진단** = `verify_price_coverage.py` → DRIFT/MISSING 목록.
3. **유형 분류** = 각 건 그리드 실측(구코드 존재?·값 부재?·잉여?·차원삭제?) → 4유형+오탐.
4. **권위 대조** = 상품마스터+가격표로 정답 값·구조 확정(preflight). 추측·재질문 금지.
5. **인간 승인** = 교정 명세(before→after·메커니즘) 제시 후 승인.
6. **webadmin UI 교정** = 유형별 메커니즘(위). gstack browse·admin 로그인(`HUNI_ADMIN_*`).
7. **재검증** = verify_price_coverage 재실행 → 해당 건 CLEAN·전수 DRIFT 0. 필요 시 브라우저 sim으로 예측=실제 교차확인.

## 제약엔진 한계 (참고)

시뮬레이터 제약규칙 = **프런트 cascade(비활성화)용**이지 가격 차단 아님. cascade 지원 차원(`_SIM_DIM_CONSTRAINT`) =
siz·plt_siz·mat(usage)·proc·bdl_qty + 옵션그룹/옵션. **print_opt_cd(인쇄면)·opt_id(도수)·sub_prd_cd는 미지원**.
→ 「단면만」류 인쇄면 제약은 현재 시뮬 미작동 → **옵션 미등록**으로 처리(제약 아님). opt_id cascade 추가 = 개발 전달 후보.

## 산출

- 진단·교정 확정표·유형별 근거 = `_workspace/huni-webadmin-load/batch-scan/DRIFT-SCAN.md`.
- 유형별 상세 실적재본 = `PREMIUM-NAMECARD-DRIFT-FIX.md` 등 + 백업/페이로드 JSON(`tmp/`).
- 한눈 대시보드 = `batch-scan/drift-dashboard.html`(로컬 open·Artifact).

## [HARD] 원칙

- **라이브 DB 직접 적재/psql 쓰기 금지** — 교정은 webadmin UI만(gstack). 검증 SELECT만 psql 허용.
- **생성≠검증** — 교정(생성)과 verify_price_coverage 재검(검증) 분리. 자기 산출 자기 승인 금지.
- **권위 verbatim** — 단가·구조는 권위 셀 그대로. LLM 숫자 전사·날조 금지.
- **부자재 판정** — UNCOVERED 소재가 부자재(자석·집게 등)면 add-on(opt_cd) 가격 여부 먼저 확인(과등록 vs 진짜 미적재).
