---
name: huni-price-master-orchestrator
description: >-
  후니프린팅 가격 종단 마스터 오케스트레이터 — 한 상품군을 "가격이 정확히 나올 때까지" 기존 가격 하네스들을
  올바른 순서로 구동하는 상품군 단위 종단 파이프라인. ★새 분석 하네스가 아니라 흩어진 8개 가격 하네스(§14 이해·
  §26 적재무결성·§18 설계·§7 적재·§13/§15 검증·§21 전수정합·§16 시각화)를 의존 순서대로 엮어 "분석 과잉 vs 적재
  부족"을 끝내고 실제 정확한 값에 도달시키는 수렴 실행 조율자. 흐름(상품군 단위): ① 토대 무결성(§26 권위→라이브
  적재 이 빠진 것 0 확인) → ② 무결성 결함 교정 적재(§7 dbmap·인간 승인) → ③ 공식·구성요소 설계(§18·무결성 GO
  토대 위) → ④ 설계분 적재(§7 dbmap·인간 승인) → ⑤ 검증(§21 전수+§13/§15 골든 재계산) → NO-GO면 해당 단계로
  라우팅 루프, 전 상품 GO까지. 상품군 진척판(RTM)으로 추적. ★배선 연결 서브트랙(formula_components) 포함 — 가격에
  영향 주는 가격구성요소를 가격공식에 배선(고아 단가행 적발→공식 연결)하는 수렴 루프(wiring_scan.py 토큰0 측도·종료
  척도=배선 결함 0+PRICE≠0·명세까지 DB 미적재). 생성≠검증·권위 엑셀 절대·라이브 읽기전용(검증)·실 COMMIT은 인간
  승인·codex 교차. 트리거: '가격 종단 파이프라인', '상품군 가격 제대로', '가격 마스터 오케스트레이터', '상품군 가격
  종단 완주', '정확한 가격값까지', '가격 하네스 엮어서', '전 상품 가격 정합 완주', '가격 종단 실행/재실행/이어서',
  '특정 상품군 가격 종단', '가격 파이프라인 진척', '가격공식 가격구성요소 연결', '가격공식에 구성요소 배선',
  'formula_components 배선', '고아 구성요소 연결', '배선 연결 서브트랙', '배선 진척 보드', '구성요소 공식 연결 다시'.
  단일 레이어 작업은 해당 하네스 직접(§26/§18/§7/§21), 단순 질문은 직접 응답.
---

# 가격 종단 마스터 오케스트레이터 (상품군 단위 파이프라인)

## 목적
한 상품군이 **"제대로된 가격값"**(전 등록사이즈·옵션 조합이 권위 엑셀대로 정확히 계산)에 도달할 때까지, 기존 가격 하네스를 **의존 순서대로** 구동한다. 핵심 통찰: 토대(권위→라이브 적재)가 이 빠짐 없이 정확해야(§26) 설계(§18)·검증(§13/15/21)이 정확값을 낸다. 따라서 **무결성→설계→적재→검증** 순서를 강제하고, NO-GO면 해당 단계로 되돌려 루프한다.

**이건 새 하네스가 아니다.** 기존 하네스 오케스트레이터 스킬을 순서대로 호출하는 **수렴 실행 조율자**다(SOT "새 하네스 금지·기존으로 수렴 실행"과 정합).

## Phase 0: 컨텍스트·상품군 선택
- 대상 상품군 1개 확정(파일럿=아크릴·디지털인쇄 등 동질군). 전 상품은 동형 전파로 확장.
- 진척판 `_workspace/_foundation/price-pipeline-rtm.csv` 확인(상품군 × 단계 상태). 있으면 이어서, 없으면 신규.
- 단계별 산출물(_workspace/<harness>/)이 최신인지(freshness) 확인 — stale면 그 단계 재실행.

## ★Phase 0.5 — 라이브 사이트 구조 확인 (필수·엑셀 구조 검증 오라클) [HARD·사용자 directive 2026-06-29]
**모든 상품군은 단계1 진입 전 반드시 라이브 이전사이트 구조를 먼저 본다.** 라이브 `goods.asp` 손님 폼의
`<select>` 구조 = **권위 엑셀의 옵션/소재/제약 구조를 읽는 직접 수단**(애매모호한 "별도설정 종이·★제약·옵션"이
실제로 무엇인지 라이브가 보여줌). 이걸 선행하면 BLOCKED가 단계 도중 터지지 않는다(사전 해소). 본 단계가
**"같은 BLOCKED 반복"을 차단하는 핵심**이다.

1. **BLOCKED 위험 전수 스캔(결정론·토큰0):** `python3 _workspace/_foundation/batch/blocked_scan.py` → `blocked-risk-registry.csv`
   (★/별도설정 셀을 7카테고리로 분류). 그 상품군 행만 보면 무엇이 애매한지 즉시 파악.
2. **라이브 구조 대조:** 그 상품군 라이브 pcode(`remediation/_huni_live_pcode-index.csv`)를 gstack browse로 열어
   `<select>` 전수 읽기(소재 목록·사이즈축·가공/부속 옵션·제약). 헬퍼=`remediation/_huni_live_crosscheck.md`.
   ★엑셀 ★마커의 정체 판정: **대부분 "단가 미상"이 아니라 "제약 스펙"(값이 셀에 있음)**이고 단가는 가격표에
   이미 있다(`BLOCKED-RISK-RESOLUTION-260629.md` 결론). 진짜 미상(예 하드커버 표지 "계산식")만 라이브 가격
   역산으로 해소(`_huni_live_crosscheck.md` off-grid 절차·한 축씩 변경해 구성요소 단가 분리).
3. **해소 기록:** 애매 항목 → 라이브 증거 → 해소(PRICE_KNOWN/CONSTRAINT/NEEDS_STAFF)를 registry에 갱신.
   값 날조 0(라이브는 보강 증거·자동 DB 주입 금지·차이=조사신호). → 해소 완료분은 단계1~5에서 재논쟁 금지.

### ★[HARD] 애매 → 이전사이트 먼저, "실무진 컨펌"은 최후수단 (모든 트랙·에이전트 적용·2026-06-29 4호)
교정/설계/적재 **어느 트랙이든** `*별도설정`·★마커·BLOCKED·"종이목록 미상"·"어느 옵션인지 모름" 같은
애매가 나오면 **반드시 먼저 이전사이트(`goods.asp?pcode=N`)의 `<select>`를 구동해 해소**한다. **"실무진 확인
필요"로 멈추는 것은 이전사이트로도 안 풀릴 때만** 허용(NEEDS_STAFF는 오라클 시도 후의 최후 분류).
- 실증(4호): 하드커버책자 내지 `*별도설정` 종이 → pcode40 `tmp_p07` = 9종(백모100/120·아트100/120·스노우100/120·
  앙상블100·몽블랑100/130) **정확 노출**. 도메인 추정(8종·앙상블 누락)으로 멈출 게 아니라 이전사이트가 정답.
- 책자 세트 pcode: 36무선·37PUR·38트윈링·39중철·**40하드커버무선(072)**·41하드커버트윈링(082)·44싸바리(088).
- ★에이전트 프롬프트 규칙: 하위 에이전트에 일을 위임할 때 **"애매하면 이전사이트 `<select>` 먼저, 실무진은 최후"**
  를 명시(`_huni_live_crosscheck.md`·`_huni_live_pcode-index.csv` 첨부). 이전사이트=권위 아님(차이=조사신호)이나
  옵션/종이/사이즈 **목록의 실재 확인**에는 강한 오라클(가격값은 권위 엑셀 절대).

**권위 위상:** 권위 엑셀(상품마스터·가격표)이 절대. 라이브 ASP=구 시스템이나 **엑셀 구조를 비추는 거울**
(옵션/소재/제약을 손님 폼으로 구현). 권위 엑셀에 값이 부재("계산식"/행부재)인 항목만 라이브가 정당한 보강 출처.

## 파이프라인 단계 (상품군 단위·의존 순서)

### 단계 1 — 토대 무결성 [§26 huni-price-table-integrity]
권위의 그 상품군 가격테이블(차원+전 셀)이 라이브에 이 빠짐 없이·정확히 적재됐는지 진단. 산출=결함 보드(미적재 셀·차원 누락·정합 불일치)+I1~I7 GO/NO-GO.
- **GO** → 단계 3로.
- **NO-GO(결함)** → 단계 2.

**★[HARD·아크릴 실전 교훈] 절대 셀-카운트 quick diff로 판단하지 말 것.** main이 면적 3블록만 셀 수 비교(141)로 "GO" 직행했다가, 정식 §26 하네스 구동하니 실제는 156셀 미적재 + 12/13 상품 미바인딩 + 고아 comp/formula + addon 저청구 + 카라비너 완전미적재였다. **반드시 4에이전트 정식 구동**: `hpti-authority-extractor`(전 블록·차원+전 셀) → `hpti-load-inspector`(3종 결함·차원+데이터 함께) → `hpti-codex-verifier`(독립 2차) → `hpti-integrity-gate`(I1~I7·라이브 좌표 독립 재실측). 권위 원천 2종 모두:
- **상품마스터 시트(`24_master-extract-260610/<군>-l1.csv`)** = 상품 universe + 상품별 {가격모델·소재·인쇄사양·가공(옵션)+단가·추가상품(옵션)+단가}. ★"각 시트 상품에서 최종 적용대상 확인"(사용자 directive)의 권위.
- **가격표 시트(`24_master-extract`/`06_extract`/`huni-price-table-integrity/01_authority`)** = 격자(차원+전 셀)·후가공/추가 단가블록. ★면적격자만이 아니라 전 블록(수량할인·후가공·파생상품·고정형) 전수.
- **[신설·보조] 라이브 고객사이트 = 구성요소 발굴 오라클** — 라이브 `goods.asp` 손님 폼의 `<select>`(소재·사이즈축·가공/부속 옵션)가 우리 권위 격자/구성요소에 빠진 축을 노출할 수 있다(예 라이브 키링 고리/볼체인·명찰 등록사이즈·스티커 은데드롱 소재). 단계1에서 라이브 옵션 구조를 함께 보면 차원/구성요소 누락을 조기 적발(권위 엑셀이 절대·라이브는 갭헌팅 보조). 헬퍼=`remediation/_huni_live_crosscheck.md`.

**무결성 결함 분류(아크릴 실증·전 상품군 동형):** ① 미적재 셀(꽉 찬 권위격자 vs 라이브 sparse·★verbatim INSERT만·**대칭전개 금지**=비대칭쌍 오가격) ② 차원 누락(권위 가격축이 라이브 use_dims/차원행에 없음) ③ 정합 불일치(값/자재/표시 오적재) ④ 상품 공식 0바인딩(단가표 있어도 상품→공식 사슬 단절=견적불가) ⑤ 고아 comp/formula(comp 실재≠배선·formula 실재≠상품바인딩) ⑥ 파생격자(미러=투명×2 등). false-positive 가드: 도수 "통용"=단일가(차원 아님)·원형/사각 동일가·의미축 정당차이.

### 단계 2 — 무결성 결함 교정 적재 [§7 dbmap · 인간 승인]
단계 1 결함을 권위대로 라이브에 보완/교정 적재(dbm-price-import-prep 그릇·dbm-correctness-audit 교정·dbm-load-execution). ★실 COMMIT은 dryrun→인간 승인. 완료 후 단계 1 재실측(GO 확인).

### 단계 3 — 공식·구성요소 설계 [§18 huni-price-engine-design]
무결성 GO 토대 위에서, 그 상품군의 없는/불완전 가격공식+가격구성요소(차원 포함)를 설계. ★[[price-design-before-verify]] 표준 순서(엑셀 가격영향요소 분석→설계). 차원 유형 정확히(등록사이즈 siz_cd vs 면적 vs 자재). codex 교차(E1~E7+5.5).

### 단계 4 — 설계분 적재 [§7 dbmap · 인간 승인]
설계된 공식·구성요소·단가행·바인딩을 라이브 COMMIT(dryrun→인간 승인·멱등·백업/undo). search-before-mint·단가 verbatim·[[base-master-code-no-delete]].

### 단계 5 — 검증 [§21 conformance 전수 + ★라이브 시뮬레이터 전수 + §13/§15 골든]
그 상품군 전 상품×사이즈·옵션 조합을 권위 골든과 수치 대조(허용오차 0). §21 종단 정합 + §13 게이트/§15 단일. 생성≠검증.

**★[HARD·아크릴 실전 교훈] 라이브 가격시뮬레이터(gstack browse)가 진짜 검증 게이트.** dryrun 골든합산(본체단가+가산단가 SQL 합)은 **엔진의 옵션→차원 환원을 우회**해 결함을 숨긴다(아크릴 addon이 SQL 골든 PASS인데 라이브 0원·저청구5종이 SQL상 정상인데 라이브 2500). **반드시 라이브 `huni-admin-production…/admin/price-simulator/`에서 각 상품을 실제 옵션 선택→가격계산해 권위가 일치하는지 실측**(SQL/dryrun만으로 GO 금지):
- 검증 헬퍼 `_workspace/_foundation/remediation/_sim_verify.sh`(로그인 세션 재사용·결과 요약). 자격증명 `.env.local HUNI_ADMIN_*`(읽기 탐색만).
- **전 등록사이즈·전 가공/추가 옵션 조합을 실측**(대표 1개만 보고 "PASS" 금지=오검증 함정. 아크릴서 "코스터 2500 PASS"가 최소 디폴트를 정상으로 오인한 오검증이었음).
- 시뮬레이터 신호 읽기: `제외·데이터 없음`=단가행 부재, `제외·해당 없음`=차원 미스매치/opt_cd 미주입, `합계 0원 경고`=결함, `최소셀 고정`=사이즈 입력 불가(저청구).

**★[HARD·신설 오라클 2026-06-28] 라이브 고객사이트 교차검증 (huniprinting.com).** 단계5에 **두 번째 독립 오라클**을 둔다 — webadmin 시뮬레이터(우리 리뉴얼 DB)와 별개로, **현재 손님이 실제 보는 라이브 ASP 가격/옵션**(`https://www.huniprinting.com/product/goods.asp?pcode=N`)을 gstack browse로 손님처럼 구동해 대조. 위상[사용자 결정]=**교차검증 오라클**(경쟁사 벤치마크 동류이되 본인 사이트라 더 강함)·**권위 엑셀이 절대**·라이브 ASP는 구 시스템이라 **차이=조사신호(자동교정 금지)**. 절차·판정·안전 = `_workspace/_foundation/remediation/_huni_live_crosscheck.md`(헬퍼).
- **2층 대조:** ⓐ **구성요소/옵션 구조** — 라이브 `<select>`(사이즈축·소재 `tmp_p02`·가공/부속 `tmp_p05/06…`) ↔ 우리 옵션그룹/구성요소(가격구성요소 검토의 핵심). ⓑ **가격값** — 라이브 `합계금액…공급가 N원` ↔ 우리 골든(공급가=부가세 전·qty 동위상 caveat).
- **판정:** 구조일치+가격근접=고신뢰 PASS / 구조일치+가격상이=조사신호(우리적재·권위엑셀·라이브stale 중 조사) / 구조불일치(라이브에 옵션 더 많음)=갭신호→단계1 라우팅 / 라이브 미존재·분류다름=리뉴얼 의도차 기록 / 폼구동 실패="미실측" 명시.
- **사실(검증됨):** curl 403(봇차단)→**반드시 gstack browse**(200). EUC-KR·이미지 메뉴(상품명=goods 페이지 breadcrumb로만). 라이브 **읽기탐색만**(담기/주문/결제 0).
- **★단가/합가 구조 기준** = `_workspace/_foundation/price-table-formula-structure-map.md/.csv`(가격표 19시트 전수 L1 단가블록/L2 선조립표/L3 modifier 분류 + 가족별 합가 조립사슬). **L2 가족(명함·봉투·스티커)은 권위=라이브 정확 일치 실증**(verbatim 적재면 오차0)·**L1 합가 조립 가족(디지털·책자·아크릴addon)에 라이브 교차검증 우선 투입**(오차 위험 집중).
- **라우팅:** 가격값 조사신호는 **자동교정 금지** — 권위 엑셀 재확인 + 단계1 무결성 재실측 후 인간 판단. 라이브에 맞춰 우리 값을 바꾸지 않는다.
- **★off-grid 공식 역확인(합가 정답 확정):** 가격표에 없는 수량(95·97)·임의 사이즈를 라이브에 입력해 실제 공식을 확정(`remediation/price-formula-live-confirmation.md`). 확정 규칙=자유수량(단가×수량 선형)·per-unit 합가(base+옵션 가산·이중합산0)·면적(격자 lookup·off-grid=견적·보간 아님)·밴드수량(밴드 lookup·×qty 아님). 단계3 설계가 **자유수량/밴드수량 구분·L2 verbatim·면적격자**를 따르는지 이걸로 검증(합가 오류 3근원 반증).
- 산출=`remediation/<군>-live-crosscheck-matrix.md`(상품매핑·구조대조·가격대조·신호·미실측). 가격표 전수 교차검증=`pricetable-live-crosscheck-matrix.md`. off-grid 공식확정=`price-formula-live-confirmation.md`.

- **GO** → 상품군 완주. 진척판 갱신. 다음 상품군.
- **NO-GO** → 결함 유형별 라우팅: 적재 빠짐=단계 2 / 설계·모델 결함=단계 3 / 코드버그=개발팀(C트랙). 루프.

### 단계 0(선택·1회) — 이해 [§14 price-engine-diag]
5장치 역할·코드↔DB 정합이 불확실하면 선행 1회. 이미 이해됐으면 생략.

## ★배선 연결 서브트랙 — 가격공식 ↔ 가격구성요소(formula_components) [신설 2026-07-01·사용자 directive]
**목적:** 전 상품의 **가격에 영향을 주는 구성요소(comp_cd)가 그 상품의 가격공식(frm_cd)의 `t_prc_formula_components`에
배선됐는지**를 수렴 루프로 닫는다. 단가행(component_prices)만 적재하고 공식에 안 배선하면 = **고아** → 권위 알고리즘
(evaluate_price)이 그 구성요소를 합산 못 함 → 견적0/저청구([[namecard-orphan-component-wiring-260630]]·
[[digital-print-base-proc-missing-260701]] 실증). 단계1~5의 **formula_components 정합에 좁힌 수렴 렌즈** — 무결성
(단계1)이 GO인데 견적0/저청구면 대개 배선 문제다. 새 하네스 아님(§13 탐지·§18 설계·§7 적재·§21 검증 재사용).

**★종료 척도 [HARD·사용자 확정 2026-07-01]:** **배선 결함 0 + PRICE≠0**. 배선 결함 = ① 고아(단가행有·공식
미배선) ② 빈배선(배선됐으나 단가행0) ③ 삭제오염(논리삭제 comp 참조) ④ 미배선 공식(상품 공식 바인딩0). 결함 0이고
대표 케이스 evaluate_price 실호출이 PRICE≠0(견적 성립)이면 그 상품군 배선 GO.

**진척 측도(토큰0):** `python3 _workspace/_foundation/batch/wiring_scan.py --round N --note "…"` →
`batch/wiring/wiring-status.json`(전역 결함 리스트 + 상품별 판정) · `wiring-summary.json`(KPI) · `wiring-rounds.csv`
(라운드 추이). 라이브 스냅샷(`live-snapshot/latest`) 3종 CSV로 결정론 스캔. 대시보드 **배선 진척 보드 탭**
(`huni-product-readiness/05_gate/dashboard/dashboard.html` — `build_dashboard.py`가 wiring-status.json 임베드)으로 시각 추적.

**수렴 루프(결함 0까지):**
1. **스캔** — `wiring_scan.py --round N`. 결함 4종 + 상품별 판정 산출. 라운드 비교로 수렴 추이 확인.
2. **탐지·분류** [§13 hpq-price-chain-inspector] — 고아가 **진짜 배선 누락**인지 **정당한 미사용**(addon 템플릿·미출시·중복)인지 분류.
   ★`*_TBD/_PENDING` 빈배선 = 실무진 단가 확인 BLOCKED(배선 대상 아님·임의단가 금지·[[pansu-authority-fn-calc-pansu-260628]]). 보드가 자동 분리.
3. **설계** [§18 hpe-engine-designer / dbm-price-arbiter] — 어느 공식에 어느 comp를 어느 disp_seq·addtn_yn으로 배선할지 명세.
   ★[HARD] **시트 차원경계 SOT 준수**(상품마스터 시트=상품군 경계) — 시트 밖 comp를 공식에 배선하면 **silent 합산 오염**([[set-semifinished-3tier-model-260629]]·차원경계 위반 가드). search-before-mint(기존 comp/공식 재사용). codex 교차(가설 경계).
4. **명세 → 적재** [§7 dbmap · 인간 승인] — `t_prc_formula_components` INSERT(고아 배선)·삭제오염 정리. **명세까지가 기본**(DB 미적재)·실 COMMIT은 dryrun→인간 승인([[dryrun-vs-fix-script-commit-lesson]]). 기초코드 mint 금지(반제품/comp 신규는 BLOCKED→해당 트랙).
5. **검증** — 배선 후 evaluate_price 실호출(PRICE≠0)·§21 전수/§13 골든 재계산. NO-GO면 결함 유형별 라우팅(고아 잔존=2·차원경계 위반=3·코드버그=C트랙).
6. **재스캔** — `--round N+1`. 결함 0 + PRICE≠0 = GO. 아니면 1로 루프.

**경계 [HARD]:** 생성≠검증(스캐너=결정론 탐지·정당/누락 판정은 설계/게이트)·라이브 읽기전용(스캔·검증)·DB 미적재(실 배선 COMMIT 인간 승인 후 §7)·codex 주장=가설.

## ★상품군 처리 플레이북 (아크릴 종단 검증·동형 전파)
다음 상품군은 아크릴과 **동일 순서·동일 패턴**으로 처리한다. 각 단계 산출은 인간 승인 후 라이브 COMMIT.

1. **사실 수집(Phase 0+):** 라이브에서 그 상품군 상품 전수 + 현재 바인딩 + 자재 + nonspec_yn 조회. 상품마스터 시트(`<군>-l1.csv`) + 가격표 격자 위치 확보. 가격 코드 의존성(예 siz_cd→cut 환원) **운영 배포 여부 먼저 확인**(미배포면 등록사이즈 상품 바인딩 보류·C트랙).
2. **단계1 무결성(정식 §26 하네스):** 위 [HARD] 절차. 산출=결함보드 + 게이트 확정 `<군>-missing-cells-confirmed.csv`(좌표·verbatim 단가).
3. **단계2 교정적재 R3=미적재 셀:** 게이트 확정 CSV에서 INSERT(단가 verbatim·대칭전개 금지·min_qty/mat 등 기존 행 형태 보존·IDENTITY 시퀀스 setval 선행). dryrun(격자 완전화 어서션)→승인→COMMIT.
4. **단계3 설계 = 상품→공식 귀속(§18 hpe-engine-designer):** 각 미바인딩 상품을 상품마스터 가격모델로 분류(면적/코롯토/고정형/addon)·기존 공식 재사용(search-before-mint). → **validator(hpe-validator) 독립 골든검증이 상품을 3분류**: ⓐ 즉시 GO(순수 면적·저청구 0) ⓑ addon-HOLD(본체+가공·후가공 미적재면 저청구→R4 선결) ⓒ BLOCKED(inline 정찰가 불일치·격자밖·자재無·권위 단가 부재). ★validator가 설계의 골든 날조·과소차단도 적발(아크릴서 163 격자밖 GO오분류·날조 골든 적발).
5. **단계4 적재 = 안전 분류대로:** ⓐ 즉시 GO 바인딩 먼저 COMMIT. ⓑ addon은 R4로(아래). ⓒ BLOCKED는 컨펌큐.
6. **★가격 모델 결정 트리 [HARD·아크릴 라이브 입증]** — 상품을 라이브에서 견적되는 모델로 분류. 시뮬레이터 사이즈 입력은 **`nonspec_yn='Y'`(비규격 자유입력)일 때만** 뜸(price_views.py:1302·1366):
   - **고정가 by-siz_cd**(형상별·등록사이즈별 자체 정찰가·면적격자와 불일치): 본체 comp `use_dims=[siz_cd,min_qty]`·PRICE_TYPE.02·min_qty=1·단가행 siz_cd verbatim. 시뮬레이터가 siz_cd 드롭다운 노출 → 정상. (예 볼펜·자유형·카라비너·명찰GS.)
   - **면적격자 + 자유입력**(nonspec_yn=Y): 본체 `COMP_*_CLEAR3T`(use_dims=[mat_cd,siz_width,siz_height])·자재 선택+비규격 spinbutton → 정상. (예 addon 본체·코롯토.)
   - **면적격자 + 등록사이즈(nonspec_yn=N)** = ★저청구 함정: 사이즈 입력 UI 없어 최소셀(20x20) 고정(코스터 100x100→2500=5배 저청구). **교정=사이즈 라벨 옵션**(옵션그룹 택1 mand_yn=Y·옵션=등록사이즈·옵션아이템 `ref_dim_cd=OPT_REF_DIM.01 ref_key1=siz_cd` → _opt_maps dims[siz_cd]→_reduce_siz_dims→면적격자 환원). 굿즈230·`acryl-sizelabel-*.sql` 동형.
7. **★addon 부속(고리·볼체인·마그넷 등) = addon 템플릿 [HARD·엔진 정식·라이브 입증]** — ❌**옵션그룹+가산 comp(opt_cd 키) 방식은 엔진서 미작동**(option group의 _opt_maps가 opt_cd 미생성·OPT_REF_DIM.03이 본체 mat_cd 덮음·covered가 자재 드롭다운 숨김 → 본체+가산 둘 다 0원). **정식=t_prd_product_addons→템플릿**(`t_prd_templates` base_prd_cd=본상품 + `t_prd_template_prices` flat 단가 B04b verbatim + `t_prd_product_addons` 링크). evaluate_price(target=tmpl)=unit_price×qty(pricing.py:436)·개별 평가·합산(price_simulate:1769). 교정 3단계=① 바인딩 본체공식만(PRF_CLR_ACRYL 등) ② 가산 옵션그룹/옵션/아이템 삭제(자재 covered 해소) ③ addon 템플릿+링크. 채번 TMPL-0000NN(하이픈 채널 MAX+1). `acryl-pilot-147-addon-template-*.sql`·`acryl-addon-template-propagate-*.sql` 레시피. (다중 부속=택1 단일은 0원옵션 미추가·색=생산메타 단일템플릿.)
8. **★권위 단가 부재 = "확인필요" 시그널 [HARD·임의단가 금지]** — 가격표/상품마스터에 단가 빈칸이면 임의 생성 금지(돈크리티컬). 대신 단가행 없는 구성요소(comp_nm=구체 갭 메시지)+공식(frm_nm 메시지)+바인딩 → 시뮬레이터가 `제외·데이터없음`+공식명으로 "실무진 단가/구성 확인필요" 노출(코드0·DB only). 실무진 확정 후 단가행1줄/정상공식 교체로 해소. `acryl-163-minipart-pending-*.sql`·`acryl-unbound-pending-*.sql`.
9. **★carry-forward 결함 점검:** 이미 바인딩된 상품도 **comp 실재≠배선** 저청구 가능(아크릴 146 키링=고리 comp 미배선). 기존 바인딩 상품의 가공/추가 배선 점검.
10. **단계5 검증(필수):** 위 ★라이브 시뮬레이터 전수(각 등록사이즈·옵션 조합 실측·골든 허용오차 0). SQL 골든합산만으로 GO 금지.

**채번 거버넌스 [HARD]:** 옵션 코드는 **언더스코어 OPT_/OPV_ 표준**(라이브 다수). 신규 mint=언더스코어 MAX+1. 템플릿=하이픈 TMPL- 채널 MAX+1. webadmin `views.py _next_opt_grp_code/_next_opt_code` 하이픈 발번은 C트랙 언더스코어 교체(`CTRACK-webadmin-optcode-numbering.md`·운영 배포 인간). comp_cd/frm_cd=이름기반.

## ★배치 도구 (결정론·토큰0·`_workspace/_foundation/batch/`) [신설 2026-06-29]
"상품 하나씩 LLM 확인=끝없음"을 끝내는 결정론 배치. 채점 프레임워크(SCORING-FRAMEWORK-260628)의 실행 계측.
- **`lib_huni.py`** — 시뮬레이터 인증 클라이언트(브라우저 불요·토큰0): 로그인(HUNI_ADMIN_*)→`POST /admin/price-viewer/<prd_cd>/simulate/` `{selections,qty,procs}`→`final_price`·`base.components[].subtotal`·`matched_row.pansu`. 세트=`simulate-set/` `{copies,members[]}`. `sim_meta()`=케이스 enumerate 소스. + 라이브 DB 읽기전용 psql.
- **`authority.py`** — 권위 엑셀 추출(24_master-extract) 리더: 사이즈별 권위 판수·주자재(종이)·요구 OC축·가격공식.
- **`score_batch.py`** — 동형군 채점 드라이버: sim-meta enumerate→simulate→**5축 채점**(CALC 계산가능성·PR 엔진pansu vs 권위판수·R1 부자재오염·R3 dflt 1개·OC 요구축 선택가능)→scoreboard CSV+교정 SQL. `python3 score_batch.py <group> [prd_cd]`.
- **`blocked_scan.py`** — 두 권위 엑셀 BLOCKED 위험 전수 스캔→7카테고리 분류+해소(Phase 0.5).
- **`wiring_scan.py`** [신설 2026-07-01] — 배선 연결 서브트랙 측도: 라이브 스냅샷 3종(formula_components·component_prices·price_components)+상품-공식 바인딩을 결정론 diff→배선 결함 4종(고아·빈배선·삭제오염·미배선공식) 전수 검출→`wiring/wiring-status.json`+라운드 추이. `python3 wiring_scan.py --round N --note "…"`. 대시보드 배선 진척 보드가 임베드.
- **R1 자가수렴 교훈[HARD]:** 부자재 오염은 mat_typ 단독 판정 불가(PET .08=투명 주자재·정상종이 false-positive). 디지털인쇄군=substrate 화이트리스트{.01,.08}로 진짜 오염(부속 .03/.17)만. 군별 substrate_typ 프로파일 정의.
- **상품군 확장:** `score_batch.py` GROUP dict에 군 프로파일(extract·print_proc_kw·qty_cases·substrate_typ) 추가. BATCH-design 순서=sticker→문구→acrylic→digital(완)→실사→책자(세트). 자기검증=프리미엄엽서 단독 재생산.

## 실행 모드
각 단계는 해당 하네스 **오케스트레이터 스킬을 직접 호출**(Skill 도구)하거나 그 하네스 에이전트를 `model:"opus"`로 구동. 마스터는 단계 전이·진척판·인간 승인 게이트만 관리(중앙 조율). **단순/반복 채점·스캔은 배치 도구 우선(토큰0)·LLM은 설계·판정·교정에 집중.**

## 데이터 전달·진척판
- 파일 기반: 각 하네스 `_workspace/<harness>/` 산출물을 다음 단계 입력으로.
- **진척판(RTM):** `_workspace/_foundation/price-pipeline-rtm.csv` — {상품군, 단계1무결성, 단계2교정, 단계3설계, 단계4적재, 단계5검증, 상태(GO/진행/BLOCKED), 차단사유}. 매 단계 후 갱신.
- **배선 진척판:** `_workspace/_foundation/batch/wiring/wiring-status.json`·`wiring-rounds.csv`(전역) — 배선 서브트랙의 결함 0 수렴 추적. 대시보드 배선 진척 보드 탭으로 시각화. (상품군 RTM의 단계3/5와 상보 — 배선은 formula_components 정합에 좁힌 렌즈.)

## 인간 승인 게이트 [HARD]
- 단계 2·4의 실 라이브 COMMIT은 **반드시 dryrun→인간 승인 후** 실행([[dryrun-vs-fix-script-commit-lesson]]).
- 코드 수정 필요분(siz_cd×면적 등)은 개발팀 C트랙으로 라우팅(webadmin 직접수정 금지).

## 에러 핸들링·경계
- 단계 실패 1회 재시도 → 재실패 시 진척판에 BLOCKED+사유, 다른 상품군 진행(전체 멈춤 금지).
- 상충은 삭제 금지·출처 병기. codex 미가용 시 Claude 단독 명시.
- **경계:** 마스터는 조율만. 실제 분석·설계·검증·적재는 각 하네스가 수행(재구현 금지). 단일 레이어만 필요하면 해당 하네스 직접.

## 테스트 시나리오
- **정상:** "아크릴 가격 종단" → §26 무결성(sparse grid·차원누락 적발)→§7 교정적재(승인)→§18 설계(모델 결정 트리)→§7 적재(승인)→**라이브 시뮬레이터 전수 실측**+§21/§13 골든 GO → 진척판 GO.
- **에러1(적재):** 단계5 라이브 NO-GO(특정 사이즈 저청구) → 단계1 미적재 셀 → 단계2 라우팅·교정→재검증.
- **에러2(모델·아크릴 실증):** 라이브 0원/2500 고정 → addon이 opt_cd 가산 방식(미작동)→addon 템플릿 전환 / 면적+nonspec_yn=N(사이즈 입력불가)→사이즈 라벨 옵션. 둘 다 라이브 시뮬레이터 재실증.
- **에러3(권위 부재):** 단가 빈칸 → 임의단가 금지 → "확인필요" 시그널 바인딩(시뮬레이터 노출)·실무진 해소.
- **배선 서브트랙 정상:** "가격공식에 가격구성요소 연결" → `wiring_scan.py --round 1`(고아 N 적발)→§13 분류(진짜 누락 vs 정당 미사용·*_TBD 분리)→§18 배선 설계(차원경계 SOT)→인간 승인 후 §7 formula_components COMMIT→재계산 PRICE≠0→`--round 2`(고아 0)→배선 GO. 대시보드 배선 보드로 추이 확인.
- **배선 서브트랙 에러:** 고아 배선했더니 시트 밖 comp가 silent 합산(과대청구) → 차원경계 위반 → 단계3 재설계(그 comp는 그 공식 비대상)·codex 교차로 적발.

## ★아크릴 종단 완주 기록 (1호·전 패턴 라이브 입증 2026-06-28)
무결성(§26 정식)→R3 156셀 교정적재→설계→적재(고정가 by-siz·면적·addon)→**라이브 시뮬레이터 전수 검증**. 발견·교정: ① addon opt_cd 모델 미작동→템플릿 전환(147=3900·146=5200·152=5100 GO) ② 저청구5종(157/158/159/161/162) 면적+nonspec_yn=N→사이즈 라벨 옵션(코스터 2500→12700) ③ 미니파츠·미바인딩7=확인필요 시그널. 최종=정상19·시그널8·돈크리티컬 저청구0. 산출=`_workspace/_foundation/remediation/`·`acryl-simulator-verification-matrix.md`. 다음 상품군은 이 패턴 동형.

## ★스티커 종단 완주 기록 (2호·라이브 시뮬레이터 22조합 전건 PASS 2026-06-28)
무결성(§26 정식 4에이전트)→NO-GO(결함14·**resolver 부재 pricing.py 코드실측**으로 false-positive 기각)→단계2 교정적재 COMMIT→**라이브 시뮬레이터 전수**. 스티커=**고정가 by-siz_cd 모델**(면적격자 아님·nonspec_yn=N 전부지만 이산 siz_cd 단가형이라 시뮬레이터가 siz_cd 드롭다운 노출→아크릴 저청구 함정 회피). 교정: ① 052 A4 저청구(product_sizes 172→520·-1000/장) ② 053투명/054홀로그램(★긴급 전건 견적불가)→144행 단가행 verbatim+재바인딩 ③ 055/056/057 자재오바인딩(154→153/243→162)+B4/B3 사이즈 ④ 066 합판6소재 동일가복제740행 ⑤ A6/100x140 권위없는 사이즈 제거 ⑥ 타투 기본가2000=333밴드(엔진 .02 고정-1회 타입부재 우회). 최종=22조합 전건 PASS·NO-GO0·저청구/견적불가0.
**★단계5가 적발한 신규 함정 = option_items vs product_materials**: 옵션그룹 보유 상품(055)은 시뮬레이터가 `product_materials`가 아닌 **`option_items.ref_key1`(손님 진짜 선택값)**을 본다. 단계2가 product_materials만 교정→시뮬레이터 무효(SQL PASS·라이브 견적불가). OPV ref_key1 재교정 후 PASS. **아크릴 addon=opt_cd 미작동·면적+nonspec과 동류 = "SQL/뷰가 손님 선택경로를 가린다"**. → ★[HARD 추가] 옵션그룹 보유 상품 교정 시 product_materials만이 아니라 option_items.ref_key1을 함께 점검. 산출=`remediation/sticker-*`·`sticker-simulator-verification-matrix.md`.

## ★라이브 고객사이트 교차검증 신설 + 아크릴·스티커 실행 (3호 보강·2026-06-28)
단계5에 **두 번째 독립 오라클**(huniprinting.com 라이브 ASP) 신설하고 완료 2종 재실행. 헬퍼=`remediation/_huni_live_crosscheck.md`. 위상=교차검증(권위 엑셀 절대·차이=조사신호·자동교정 금지·읽기탐색만).
- **아크릴(1:1 정합):** 라이브 굿즈블록(goods.asp 72~101) ↔ 우리 146~163 이름기반 1:1. **구성요소 구조 전건 정합**(키링 고리/볼체인 addon·명찰 등록사이즈·조각수·미니파츠 1.5T 라이브 입증). 가격: **판아크릴 16,600≈우리 16,700 일치(저청구 교정 라이브 검증)** / **조사신호 2건**=162 포카스탠드 10,900 vs 라이브 22,000(~2배 저청구 의심)·155 볼펜 1,800 vs 2,900 / 미니파츠 라이브 단가 7,400(실무진 해소 참고). → `acryl-live-crosscheck-matrix.md`.
- **스티커(분류 발산):** 라이브=3통합상품(56 반칼·29 사각라운딩·30 원형타원·형상=옵션·소량/대량 2분리) vs 우리=16 형상별 분해(052~067)+시트사이즈+수량밴드. **1:1 골든 가격비교 비성립**(리뉴얼 의도차·라이브 정답 아님). 소재 대부분 정합·**갭신호=라이브 은데드롱 보유**(우리 적재 점검)·우리 홀로그램(054)=신규·타투(067)/도무송(066) 라이브 단독 미존재. → `sticker-live-crosscheck-matrix.md`.
- **교훈[HARD]:** 라이브 고객사이트는 **본인 시스템이라 강한 오라클**이되 구 ASP라 정답 아님 — 가격 조사신호는 **권위 엑셀 재확인+단계1 무결성 재실측 후 인간 판단**(자동교정 금지). 분류·수량모델이 다르면(스티커) 가격차는 신호 아닌 "의도차"로 분류.

## ★Phase 0.5 라이브 구조 오라클 + 배치 도구 신설 (4호·2026-06-29)
사용자 directive로 **라이브 이전사이트를 "엑셀 구조 검증 필수 선행 오라클"로 격상** + 결정론 배치 도구 신설.
- **BLOCKED 위험 전수 해소:** `blocked_scan.py`로 두 권위 엑셀 146건 7카테고리 발굴 → 라이브/가격표 대조로
  **★마커 대부분=제약 스펙(값 셀에 있음)≠단가 미상·단가는 가격표에 이미 적재** 확정(`BLOCKED-RISK-RESOLUTION-260629.md`).
  진짜 미상=하드커버 표지 "계산식"만 라이브 역산 해소(면지=무료·표지전용지≈7,400·`hc072-blocked-resolution-LIVE-260629.md`).
  → **BLOCKED 재중단 구조 위험 해소.** 잔여=per-product 미적재(score_batch CALC 자동적발)·박 prc_typ 점검·OC 파싱.
- **배치 채점 드라이버:** `score_batch.py`가 프리미엄엽서 결정론 재현(pansu18≠15·부자재0·dflt1) 자가검증 →
  PRF_DGP_A 동형군 10상품 토큰0 채점(투명019 CALC FAIL=PET용지비 미적재 자동적발·화이트020/쿠폰042 R1오염).
- **하드커버 셋트 구조 라이브 COMMIT:** 내지 284 신설+5구성원(가격은 BLOCKED 해소됨·다음 종단).
- 다음=score_batch 상품군 전파(sticker→문구→acrylic). 산출=`_workspace/_foundation/batch/`(README.md 권위).
