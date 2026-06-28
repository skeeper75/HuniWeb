# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 2세션)

> 재시작 포인터. 상세 서술은 각 FINDING/매트릭스/메모리에.

## ★다음 시작점 — 배치 채점 스크립트 전파 (토대 완성·이제 상품군 확장)
**2세션(06-29 야간) 완성: ① 하드커버 셋트 구조 라이브 COMMIT ② 결정론 배치 채점 스크립트(토큰0·자가검증) ③ 하드커버 가격 BLOCKED 라이브 오라클 영구 해소.**

**빌드스크립트 = `_workspace/_foundation/batch/`** (lib_huni·authority·score_batch). 프리미엄엽서 결정론 재현 입증(pansu18≠15·부자재0·dflt1) → PRF_DGP_A 동형군 10상품 토큰0 채점 완료. `README.md`에 결함 보드.

**선택지(택1):**
1. **빌드스크립트 다음 상품군 전파** — sticker→문구→acrylic 그룹 프로파일 추가(score_batch.py GROUP dict). 케이스 enumerate=sim-meta·simulate POST(인증=HUNI_ADMIN_*). 권위 추출=24_master-extract.
2. **하드커버 가격 종단 (BLOCKED 해소됨)** — 면지=무료(비목제외)·표지전용지≈7,400 라이브역산. 라이브 사이즈×수량 격자 probe→§18 t_prc_* 단가 설계→셋트공식 PRF_BIND_HC_MUSEON 신설→COMMIT. 권위=`06_load/hc072-blocked-resolution-LIVE-260629.md`.
3. **R1 부자재 오염 4건 COMMIT** — 화이트인쇄020(볼펜·지비츠)·프리쿠폰042(면끈·고리). `batch/remediation-r1.sql`(DRY-RUN 후 인간 승인).

### 라이브 가격 오라클 사용법 (재중단 방지·핵심 도구)
webadmin 시뮬레이터 = **인증 POST 직접 호출**(브라우저 불요·토큰0): 로그인(HUNI_ADMIN_*)→`POST /admin/price-viewer/<prd_cd>/simulate/` `{selections,qty,procs}`→`final_price`. 세트=`simulate-set/` `{copies,members[]}`. sim-meta=enumerate 소스. 코드=`batch/lib_huni.py`.
라이브 고객사이트 = **gstack browse**(EUC-KR·curl 403): 권위 엑셀에 단가 부재("계산식"/행부재) 시 보강 오라클. 하드커버 pcode=40. 면지무료·표지전용지 단가 라이브 역산으로 BLOCKED 해소 입증.

## (이전) 채점 구동 종단(2 방법 확립)
**핵심 전환: "상품 하나씩 LLM 확인=끝없음" → 결정론 배치 스크립트(토큰0) + 동형 전파 + 인간 큐 격리.** 근본원인=종료척도 부재(RC-1)·처방=상품단위 채점(PR 가격재현+OC 주문완전성). SOT=`SCORING-FRAMEWORK-260628.md`·진척판=`product-scoreboard.csv`. 설계=`remediation/BATCH-design-deterministic-isomorphic-260628.md`.

**선택지(택1로 이어받기):**
1. **단순상품 배치 스크립트 빌드** — `isomorphic_batch`(S0 forward-fill+서명분류→S1 권위대조→S2 R1~R4 검출→S3 멱등SQL→S4 PR채점 시뮬레이터→S5 OC→S6 집계). 대상=PRF_DGP_A 동형 10상품(엽서7+슬로건+쿠폰2). ★R1 정제=권위 엑셀 소재 컬럼 대조(mat_typ_cd 단독 불가·PET 주자재/아크릴바디 false-positive). 자기검증=프리미엄엽서 단독 재생산.
2. **세트 BLOCKED 이어 적재** — 하드커버책자 CONDITIONAL GO. 세트구조 적재(GO 큐·인간승인)→제본공식 PRF_BIND_HC_MUSEON 신설+차원충전(§18/dbmap)→재게이트.
3. **R1 종이상품 부자재오염 일괄 COMMIT** — 접지리플렛·소량전단지·펄명함·프리미엄쿠폰·오리지널박명함·화이트인쇄명함·화이트인쇄엽서(권위 소재 대조 후).

## ★라이브 COMMIT (되돌리지 말 것)
- **(2세션 06-29) 하드커버책자(072) 셋트 구조** — 내지 반제품 PRD_000284 신설 + 셋트 5구성원(표지1·내지2·면지3색3·4·5)·disp_seq 1~5·내지 페이지24~300/+2. `03_design/hardcover-book-apply.sql`·baseline=`06_load/_hc072-sets-baseline-260629.csv`. 가격은 미바인딩(BLOCKED 해소됨·다음 종단).
- (1세션) **밴드총액 바인딩 12건** `.01→.02`(과대청구 해소·시뮬레이터 13,500 재실증).
- (1세션) **프리미엄엽서(PRD_000016)** 부자재오염3 제거(면끈/고리/자석 del_yn=Y)·dflt 2→1(백모조220·라이브 오라클).

## ★C트랙 기록 (개발팀·배포 인간승인)
- **판걸이수**: `fn_calc_pansu` 기하계산이 간격/물림변 미반영→과다→저청구. 권위=실무진 엑셀 판수. `CTRACK-fn-calc-pansu-authority-pansu.md`. ★이전 사이트 가격검토 키.
- composite 판형(책자·codex 주장 미검증)·S1/S2 이중합산·책등 by 페이지.

## 그 다음 (잔여)
- band-total 나머지 상품 probe(펄034·모양035·박037·합판066)+미바인딩13. `price-dimension-layout-method.md`.
- 조사신호(자동교정 금지): 아크릴 162 포카스탠드 ~2배 저청구·155 볼펜·스티커 은데드롱.
- 동형 시작순서(codex): 스티커→문구→아크릴→디지털→실사→책자(D6 미결 최다 마지막).

## 이번 세션 한 일 (요약)
- **라이브 고객사이트 교차검증 오라클 신설**(§27 단계5·2번째 독립 오라클·huniprinting.com goods.asp). 위상=교차검증(엑셀 권위 절대·라이브=계산방식 권위·차이=조사신호·자동교정 금지). curl 403→**gstack browse 필수**·EUC-KR. env `HUNI_LIVE_SITE_URL`·`HUNI_LIVE_GOODS_URL`·인덱스 `_huni_live_pcode-index.csv`.
- **가격표 260527 단가/합가 구조 전수맵**: L1 단가블록 11 + L2 선조립 합가표 5~6 + L3 modifier 2. `price-table-formula-structure-map.md/.csv`.
- **off-grid 계산공식 라이브 확정**(수량 95·97/임의 사이즈): 자유수량=단가×수량 선형·면적=격자 lookup(off-grid=견적·보간 아님)·밴드수량=밴드 lookup. `price-formula-live-confirmation.md`.
- **★band-total .01 과대청구 결함 발견+.02 실증+dryrun**(위 다음 시작점).
- **상품별 가격 차원 정밀배치+라이브 off-grid 공식확정 방법** codify(사용자 directive). `price-dimension-layout-method.md`.
- 교차검증: 아크릴(1:1정합·판아크릴 가격일치)·스티커(분류발산)·명함/봉투(권위=라이브 정확일치). 매트릭스=`{acryl,sticker,pricetable}-live-crosscheck-matrix.md`.

## 미해결/블로커
- ✅ band-total 바인딩 12 COMMIT 완료. **잔여=미바인딩 13건(예방·과대청구 0)**+나머지 band-total 상품 probe(위 다음 시작점). 박명함 FOIL 4comp use_dims=[min_qty]만→동시매칭/이중합산 2차 점검(부차).
- **검증필요 4 = 종결**(per-unit .01 정상): 떡메097·미니배너145·미니보드144·엽서북094 라이브 확인 완료(버그 아님).
- 조사신호: 포카스탠드 ~2배·볼펜·은데드롱(위 그 다음 3).
- **아크릴 잔여**(전수 마감·실무진/정리만): 확인필요 시그널 8종(미니파츠163·지비츠156·165·168·169·170·171·226 단가/구성 실무진 확정)·잔재 고아 comp 정리(무해).
- **C트랙(운영 배포=인간)**: webadmin 채번 언더스코어(`CTRACK-webadmin-optcode-numbering.md`)·`pricing.py _reduce_siz_dims`(siz_cd→cut·확정).

## 이번 세션 결정 (relitigate 금지)
- **엑셀 가격테이블=1순위 권위(값)·라이브 구 사이트=격자 밖 수량/사이즈 계산방식의 권위.** 라이브=정답 아님(구 ASP)·차이=조사신호·자동교정 금지.
- **방법=상품별 차원 정밀배치→라이브 격자+격자밖 probe→공식 실증 확정**(스팟/블랭킷 가정 금지).
- **band-total 결함 정답=.02**(라이브 실증·명함 선형·봉투 밴드총액). 선형상품=단일밴드 충분·비선형밴드=전밴드 적재 필수.
- 엔진 의미론: `.01 단가형=unit×qty`·`.02 합가형=unit÷min_qty×qty`·`.03 고정=그대로`·NULL=.01 기본(pricing.py:193·558).
- (이전 세션 유지) 라이브 시뮬레이터=진짜 게이트·addon=템플릿·면적+등록사이즈=사이즈라벨옵션·권위단가부재=확인필요 시그널·무결성=정식 §26.

## 건드리지 말 것
- 이전 세션 라이브 COMMIT 전부(아크릴 종단·스티커 종단·되돌리지 말것·undo 보유) — 상세=`remediation/_REMEDIATION-LOG.md`. 면적격자 셀·공유공식 PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T·부속자재 마스터코드([[base-master-code-no-delete]]).
- band-total 바인딩 12건 `.02` 라이브 COMMIT(2026-06-28·인간 승인·undo 보유·단가행 verbatim 불변) — **되돌리지 말 것**. 미바인딩 13건은 미적용(후속).
- C트랙 webadmin 코드(배포 전 운영영향 0·로컬만).

## 산출물 위치
- **이번 세션 신규**: `_foundation/price-table-formula-structure-map.{md,csv}`·`price-dimension-layout-method.md`·`remediation/{_huni_live_crosscheck.md,_huni_live_pcode-index.csv,price-formula-live-confirmation.md,FINDING-bandtotal-x-qty-overcharge.md,pricetable-live-crosscheck-matrix.md,acryl-live-crosscheck-matrix.md,sticker-live-crosscheck-matrix.md,bandtotal-prctyp-*.sql,bandtotal-prctyp-undo-backup.csv}`.
- 무결성: `_workspace/huni-price-table-integrity/`. 교정 SQL/로그: `_workspace/_foundation/remediation/`(`_REMEDIATION-LOG.md`).
- 진척판: `_foundation/price-pipeline-rtm.csv`. 플레이북: `huni-price-master-orchestrator/SKILL.md`·`huni-price-table-integrity-orchestrator/SKILL.md`(codify).
- 시뮬레이터 헬퍼: `remediation/_sim_verify.sh`(로그인=HUNI_ADMIN_*). 라이브 교차검증 헬퍼: `remediation/_huni_live_crosscheck.md`(gstack browse).
