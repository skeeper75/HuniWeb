# 가격 파이프라인 세션 핸드오프 (최신 2026-06-29 2세션)

> 재시작 포인터. 상세 서술은 각 FINDING/매트릭스/메모리에.

## ★다음 시작점 — 빌드 스크립트(자동 검사 기계)에 집중 [사용자 directive]
**사용자 결정: 다음 세션은 "빌드 스크립트(자동 채점 기계)"에 모든 에너지 집중.** 아래 3갈래 중 사용자가 고르게
한다(★[HARD] 반드시 비전문가 쉬운 말 + 단계별로 제시·AskUserQuestion 선택지도 쉬운 말). 사용자가 "알아서
진행"하면 갈래1+갈래3 추천.

**비전문가 프레이밍(그대로 활용):** 후니 상품 275개를 사람이 하나씩 가격·주문가능 확인=끝없음 → "자동 검사
로봇"(빌드 스크립트)이 빠르게(토큰0) 불량(가격0·부자재오염·빠진선택지)을 찾음. 현재 로봇은 **"디지털 엽서류"
한 종류만** 검사 가능(10개 검사 완료). 목표=전 상품군 검사.

| 갈래 | 쉬운 말 | 기술 | 산출 |
|------|---------|------|------|
| **1 (추천)** | 로봇이 **더 많은 단순상품** 검사(스티커·문구·아크릴) | `score_batch.py` GROUP dict에 군 프로파일(extract·print_proc_kw·qty_cases·substrate_typ) 추가. enumerate=sim-meta·simulate POST | 단순상품 다수 자동 채점·결함 보드 |
| **2** | 로봇이 **조립형 상품**(책자=표지+내지+면지) 검사 | `lib_huni.simulate_set` 경로 추가(구성원별 합산). 하드커버→책자류 | 세트 채점(단 하드커버 가격 일부 실무진 대기) |
| **3** | 검사결과 **성적표 자동기록**(275상품×점수) | scoreboard-summary가 `product-scoreboard.csv` 자동 갱신·"몇%완료" | 진척 대시보드(갈래1과 함께 가능) |

**빌드스크립트 현황 = `_workspace/_foundation/batch/`** (README.md 권위):
- `lib_huni.py` 시뮬레이터 인증 POST 클라이언트(토큰0)·`authority.py` 권위 리더·`score_batch.py` 5축 채점·`blocked_scan.py` BLOCKED 스캔.
- 자가검증 완료: 프리미엄엽서 결정론 재현(pansu18≠15·부자재0·dflt1). PRF_DGP_A 동형군 10상품 채점(투명019 CALC FAIL·화이트020/쿠폰042 R1오염).
- ★R1 자가수렴 교훈: mat_typ 단독 불가(PET.08·정상종이 false-positive)→군별 substrate 화이트리스트.

### 승인/큐 대기 (빌드스크립트와 별개·인간 승인 시 처리)
- **R1 부자재 오염 4건 COMMIT** — 화이트020(볼펜·지비츠)·프리쿠폰042(면끈·고리). `batch/remediation-r1.sql`(DRY-RUN 후 승인).
- **하드커버 가격 종단** — BLOCKED 해소됨(면지무료·표지전용지≈7,400 라이브역산). 라이브 사이즈×수량 격자 probe→§18 단가설계→셋트공식 PRF_BIND_HC_MUSEON→COMMIT. 권위=`06_load/hc072-blocked-resolution-LIVE-260629.md`.
- **투명엽서019 PET 용지비 미적재**·**박 prc_typ .01/.02 점검** → §26/dbmap.

### 핵심 도구 사용법 (재중단 방지·codify됨=master SKILL Phase 0.5)
- **시뮬레이터 인증 POST**(토큰0): 로그인(HUNI_ADMIN_*)→`POST /admin/price-viewer/<prd_cd>/simulate/` `{selections,qty,procs}`→`final_price`. 세트=`simulate-set/`. sim-meta=enumerate. 코드=`batch/lib_huni.py`.
- **라이브 이전사이트=엑셀 구조 검증 필수 오라클**(gstack browse·EUC-KR·curl 403): `blocked_scan.py`→7카테고리·★대부분=제약스펙≠단가미상(단가는 가격표에 있음). 진짜 미상만 라이브 역산. 전수해소=`batch/BLOCKED-RISK-RESOLUTION-260629.md`.

## (이전 세션 토대·완료) 채점 프레임워크 + 배치 설계
"상품 하나씩 LLM 확인=끝없음" → 결정론 배치(토큰0)+동형 전파+인간 큐. 근본원인=종료척도 부재(RC-1)·처방=상품단위 채점(PR 가격재현+OC 주문완전성). SOT=`SCORING-FRAMEWORK-260628.md`·진척판=`product-scoreboard.csv`·설계=`remediation/BATCH-design-deterministic-isomorphic-260628.md`. → **2세션에서 score_batch로 구현 완료**(위 다음 시작점).

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
