# 가격 파이프라인 세션 핸드오프 (최신 2026-06-28)

> 재시작 포인터. 상세 서술은 각 FINDING/매트릭스/메모리에. 라이브 교차검증 = 본 세션 신규 축.

## ★다음 시작점 (band-total 바인딩 12 COMMIT 완료 — 다음=나머지 band-total 상품 probe)
**✅ 밴드총액 .01 ×수량 과대청구 — 바인딩 12건 라이브 COMMIT 완료(2026-06-28·인간 승인).** 시뮬레이터 전수 재실증 GO: 투명명함 100매=13,500(과거 1,350,000)·스탠다드명함 100매=3,500/1000매=35,000(.02 선형). 상세=`FINDING-bandtotal-x-qty-overcharge.md`·`_REMEDIATION-LOG.md`.

**다음 시작점 = 나머지 band-total 상품 차원배치+라이브 전밴드 probe로 선형/비선형 확정 후 미바인딩 13건 처리 결정.**
- **나머지 band-total 상품 probe**: 펄034·모양035·미니모양036·박037·합판066이 명함처럼 선형(단일밴드 .02 충분)인지 비선형밴드(전밴드 적재 필수)인지 상품별 실증(`price-dimension-layout-method.md` 방법·블랭킷 가정 금지).
- **미바인딩 13건(예방)**: 현재 과대청구 0(미바인딩). 위 probe로 선형 확정 후 `.01→.02` 후속 COMMIT(SQL은 `bandtotal-prctyp-fix-COMMIT.sql`이 25건 전체본·또는 13건 스코프 신규 작성). 박명함 FOIL 4comp use_dims=[min_qty]만 → 동시매칭/이중합산 2차 점검 선결.

## 그 다음 (순서)
2. **L1 합가 조립 가족 라이브 교차검증 계속** — 디지털·책자(아크릴addon은 완료). 필요시 §13/§15 시뮬레이터 DB 수치대조.
3. **조사신호 추적**(자동교정 금지·권위 엑셀 재확인+§26 재실측 후 인간): 아크릴 **162 포카스탠드 ~2배 저청구 의심**(우리 10,900 vs 라이브 22,000)·155 볼펜·스티커 **은데드롱 소재 적재여부** 점검.

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
