# 가격 파이프라인 세션 핸드오프 — 2026-06-28(이어서8·가격표 단가/합가 공식구조 전수맵 + 라이브 교차검증 + 하네스 codify)

## 다음 시작점 (한 줄·★최우선 돈크리티컬)
**★밴드총액 .01 ×수량 과대청구 결함 교정 결정** — 시뮬레이터 실증: **투명명함 100매=1,350,000원(정답 13,500·100배 과대)**. 원인=명함/봉투/합판 "완제품가"(밴드총액) component가 `prc_typ_cd=.01(단가형 ×qty)`로 오타이핑(엔진 .01=총액×수량). **확정 10상품**(명함031~037·039·봉투050 ×1000·합판066 ×1000)+검증필요4(떡메097·엽서북094·미니배너145·미니보드144=단위기준 확인). 교정=`.01→.02(합가형)`(투명명함 .02→13,500÷100×100=13,500 ✓)·인간 승인→dryrun→COMMIT(§7 dbmap). 진단=`remediation/FINDING-bandtotal-x-qty-overcharge.md`. 그 다음=L1 합가 가족 라이브 교차검증 계속.

## (직전) 다음 시작점
**L1 합가 조립 가족 라이브 교차검증 우선 + 조사신호 추적** — ① 가격표 단가/합가 구조맵 완성(`price-table-formula-structure-map.md`)·L2 가족(명함·봉투) 권위=라이브 정확일치 4/4 실증 ② **L1 합가 조립 가족(디지털·책자·아크릴addon)에 라이브 교차검증 우선**(오차 위험 집중)·필요시 §13/§15 시뮬레이터로 DB 조립 수치대조 ③ 조사신호 추적: **아크릴 162 포카스탠드 ~2배 저청구 의심**(10,900 vs 라이브 22,000)·155 볼펜·스티커 은데드롱 소재 점검. 권위 엑셀 재확인+§26 무결성 재실측 후 인간 판단(자동교정 금지).

## ★이어서8-b 결론 — off-grid 계산공식 라이브 확정 (수량 95·97 / 임의 사이즈)
- 가격표에 없는 수량(95·97)·임의 사이즈를 라이브에 입력해 **실제 공식 확정**(`remediation/price-formula-live-confirmation.md`). 4규칙: ① 자유수량 단가형(아크릴·실사규격)=**단가×수량 완전선형**(키링6000×97=582000·현수막29000×95=2755000 정확) ② per-unit 합가=**base+옵션 가산(이중합산0)**(키링 50x50=면적5000+고리은1000/금1100+볼체인900) ③ 면적=**격자 lookup**(preset만 즉시가·**off-grid=견적문의**·연속보간 아님·현수막 비규격=문의) ④ 밴드수량(디지털·명함·봉투·스티커·엽서)=**밴드 lookup**(×qty 아님·97 입력불가).
- **합가 오류 3근원(라이브가 정답 반증):** 밴드를 ×qty로 / L2 선조립표에 L1 단가 또 더함(이중합산) / 면적 연속보간. → 자유수량·밴드수량 구분 + L2 verbatim + 면적격자(off-grid=ceiling/견적) 지키면 오차0.
- codify: §26 Phase4·§27 단계5에 off-grid 공식 역확인 게이트. 헬퍼에 probe 절차.

## ★이번 세션(이어서8) 결론 — 가격표 단가/합가 공식구조 전수 + 라이브 검증 + codify
- **가격표 260527 = 19시트 단가블록 구조** 전수 파악: **L1 단가블록 11**(출력소재·디지털인쇄비·코팅·접지·인쇄후가공·커팅타공·박3·제본·아크릴) + **L2 선조립 합가표 5**(스티커·도무송·봉투·명함·엽서북·포스터사인) + **L3 modifier 2**(판걸이수 판수·굿즈파우치 구간할인). 최종가=L1 합가(원자합산) or L2 직접조회 or ×L3. → `_foundation/price-table-formula-structure-map.md/.csv`.
- **라이브 교차검증(권위 가격표 ↔ 라이브):** **L2 정확 일치 4/4**(봉투 대134,000/소48,000·명함 단3,500/양4,500) → L2 가족은 verbatim 적재면 오차0. L1 합가형 라이브 기준값 확보(엽서 단4,000/양19,000). → `remediation/pricetable-live-crosscheck-matrix.md`.
- **단가/합가 오차 3유형**: 이중합산(과대·명함S1S2/책자제본/always-add)·미바인딩(과소·고리미배선/최소셀고정)·차원미스매치(견적불가). **L1 합가 조립에 오차 집중**.
- **codify(기존 하네스 환류·사용자 directive):** §26 무결성=Phase1 단가/합가 계층분류 선행+Phase4 오차3유형·라이브 교차검증 게이트. §27 마스터=구조맵 기준+L1 합가 우선. env=`HUNI_LIVE_SITE_URL`·`HUNI_LIVE_GOODS_URL`(.env.local)·인덱스=`_huni_live_pcode-index.csv`.

## ★이번 세션(이어서7) 결론 — 라이브 고객사이트 교차검증 오라클 신설
- **신설:** §27 단계5에 huniprinting.com 라이브 ASP(`goods.asp` 손님폼) **2번째 독립 오라클** 추가(webadmin 시뮬레이터와 별개). 위상[사용자 결정]=**교차검증**(권위 엑셀 절대·라이브 구 ASP는 정답 아님·차이=조사신호·자동교정 금지). curl 403 봇차단→**gstack browse(200) 필수**. EUC-KR·이미지메뉴. 헬퍼=`remediation/_huni_live_crosscheck.md`.
- **아크릴(1:1 정합):** 라이브 굿즈블록(72~101)↔우리 146~163 이름기반 1:1. **구성요소 구조 전건 정합**(키링 고리/볼체인 addon·명찰 등록사이즈·조각수·미니파츠 1.5T를 라이브가 독립 입증). 가격: **판아크릴 16,600≈우리 16,700 일치(저청구 교정 라이브 검증 ✅)**·조사신호2(포카스탠드·볼펜)·미니파츠 라이브 7,400(실무진 참고). → `acryl-live-crosscheck-matrix.md`.
- **스티커(분류 발산):** 라이브 3통합상품(반칼56/사각라운딩29/원형타원30·형상=옵션) vs 우리 16 형상별분해(052~067) = **리뉴얼 의도차**(1:1 가격비교 비성립). 소재 대부분정합·**은데드롱 갭신호**·홀로그램(054)=신규·타투/도무송 라이브 단독미존재. → `sticker-live-crosscheck-matrix.md`.

## ★이번 세션(이어서6) 결론 — 스티커 종단 완주 + 아크릴 교훈 일반화
- **스티커=고정가 by-siz_cd 모델**(면적격자 아님·nonspec_yn=N 전부지만 이산 siz_cd 단가형이라 시뮬레이터가 siz_cd 드롭다운 노출 → 아크릴 저청구 함정 회피). §26 정식 무결성이 결함14 적발(셀-카운트 quick diff 금지 [HARD] 준수).
- **단계2 교정 라이브 COMMIT**(undo 백업 보유): 052 A4 저청구(172→520)·053투명/054홀로그램(★긴급 전건 견적불가→144행 단가행+재바인딩)·055/056/057 자재오바인딩(154→153/243→162+B4/B3)·066 합판6소재 동일가복제740행·A6/100x140 권위없는 사이즈 제거·타투 기본가2000(333밴드).
- **★아크릴 교훈 일반화(option_items vs product_materials)**: 055가 단계5에서 NO-GO — 옵션그룹 보유 상품은 시뮬레이터가 `product_materials`가 아닌 **`option_items.ref_key1`(손님 진짜 선택값)**을 봄. 단계2가 product_materials만 교정→무효. OPV_000029 ref_key1 154→153 재교정 후 PASS. **SQL/뷰가 손님 선택경로를 가리는 또 다른 형태**(아크릴 addon=opt_cd 미작동·면적+nonspec과 동류).
- **타투 base-fee 모델**: 엔진 .02에 "고정 1회" 타입 부재 → 밴드 enumeration(총액=2000+4000×(q/3)·333밴드)으로 우회(사장님 도메인 답=권위·3장 6000/6장 10000 라이브 입증).

## ★이번 세션 결론 — 아크릴 전수 종단 + 라이브 검증 + 파이프라인 개선
- **라이브 가격시뮬레이터(gstack)가 진짜 검증 게이트**: dryrun SQL 골든합산이 숨긴 결함 2종을 라이브가 적발 — ① addon 부속(opt_cd 가산 comp) **엔진 미작동**(본체 자재 덮임·가산 opt_cd 미주입) ② 면적격자+nonspec_yn=N **사이즈 입력 불가→2500 저청구**(코스터 5배). "대표1개 PASS" 오검증 함정 입증(코스터 2500을 정상 오인).
- **교정 전부 라이브 실증 GO·COMMIT**: addon 7상품→**addon 템플릿** 모델 전환(146=5200·147=3900·152=5100) / 저청구 5상품(157/158/159/161/162)→**사이즈 라벨 옵션**(코스터 2500→12700·판아크릴 16700) / 미니파츠+미바인딩7→**"확인필요" 시그널** 바인딩(권위 단가부재·임의단가 금지·시뮬레이터 노출).
- **파이프라인 codify**(`huni-price-master-orchestrator/SKILL.md`·HARD): ① 단계5에 라이브 시뮬레이터 전수 게이트 ② R4 addon=opt_cd 가산(❌미작동)→**addon 템플릿** 교체 ③ **가격 모델 결정 트리**(고정가 by-siz / 면적+nonspec / 면적+등록사이즈=사이즈 라벨옵션 / addon 템플릿 / 확인필요 시그널) ④ 임의단가 금지 시그널.

## 잔여 (실무진·다음)
- **확인필요 시그널 8종**(미니파츠163·지비츠156·포카코롯토165·입체코롯토168·입체블럭169·쉐이커170·지비츠★171·쉐이커코롯토226): 시뮬레이터에 무엇이 필요한지 표시됨. 실무진 단가/구성 확정 후 정상 공식·단가행 교체(RESOLVE 템플릿).
- **잔재 고아 comp 정리**(무해): addon opt_cd 모델의 COMP_ACRYL_KEYRING/BALLCHAIN/MAGNET 등·구舊 PRF_ACRYL_* 가산공식. 최종 정리 트랙.
- **C트랙(운영 배포=인간)**: webadmin 채번 언더스코어 통일(`CTRACK-webadmin-optcode-numbering.md`)·`pricing.py _reduce_siz_dims`(siz_cd→cut·확정).

## 이번 세션 라이브 COMMIT (되돌리지 말 것) — 전부 dryrun→인간승인→사후검증
로그 = `remediation/_REMEDIATION-LOG.md`(2026-06-27~28). 단가 verbatim·물리삭제 0·undo 보유.
1. **R3 면적격자 156셀 보완** — 투명3T 196·투명1.5T 81·미러3T 81·코롯토 36 권위 완전화. `acryl-grid-fill-v2-*.sql`.
2. **안전 6상품 바인딩** — 157·158·159·161·162→PRF_CLR_ACRYL·164→PRF_COROTTO_ACRYL(고아 해소)·157 BYSIZ 임시모델 폐기. `acryl-bind-safe6-*.sql`.
3. **146 키링 저청구 교정** — 신규 PRF_ACRYL_KEYRING(본체+고리)→재바인딩(라이브 저청구 해소). `acryl-146-keyring-*.sql`.
4. **147~152 addon CPQ** — 마그넷·뱃지·집게·스마트톡·명찰 5상품(본체+가공옵션·택1 비필수). 옵션그룹5(OPT_000074~078)·옵션8(OPV_000465~472)·가산comp5·전용공식5·단가행8·바인딩5+자재보강1. `acryl-addon-147-152-*.sql`.

## 이번 세션 C트랙 (운영 배포 = 인간)
- **webadmin 채번 언더스코어 통일** — `raw/webadmin/webadmin/catalog/views.py _next_opt_grp_code/_next_opt_code`를 OPT_/OPV_로 교체(로컬 준비완료·py_compile OK). 운영 HuniProductPrice2 배포는 인간. 명세=`remediation/CTRACK-webadmin-optcode-numbering.md`.
- (직전 세션) `pricing.py _reduce_siz_dims`(siz_cd→cut 환원)=운영 배포 확정(사용자) → 아크릴 면적공식 단일진실원.

## 미해결/블로커 (아크릴 = 전수 마감·잔여는 실무진/정리만)
- **확인필요 시그널 8종** — 미니파츠163·지비츠156·포카코롯토165·입체코롯토168·입체블럭169·쉐이커170·지비츠★171·쉐이커코롯토226. 권위 단가 부재(미세격자15·8mm·구성 미설정)라 임의단가 금지·시뮬레이터에 갭 노출. 실무진 단가/구성 확정 후 정상 공식·단가행 교체.
- **잔재 고아 comp 정리(무해)** — addon opt_cd 모델 잔재(COMP_ACRYL_KEYRING/BALLCHAIN/MAGNET 등·구舊 PRF_ACRYL_* 가산공식). 최종 정리 트랙.

## 이번 세션 결정 (relitigate 금지)
- **★라이브 시뮬레이터가 진짜 검증 게이트** — dryrun SQL 골든합산은 옵션→차원 환원을 우회해 결함 은폐. 대표1개 PASS=오검증 함정. 각 등록사이즈·옵션 전수 실측.
- **★addon 부속 = addon 템플릿(엔진 정식)** — opt_cd 가산 comp 방식은 라이브 미작동(❌). t_prd_product_addons→템플릿(flat 단가).
- **★면적격자+등록사이즈(nonspec_yn=N) = 사이즈 라벨 옵션**(OPT_REF_DIM.01 siz_cd) — 안 하면 2500 저청구.
- **★권위 단가 부재 = 확인필요 시그널**(임의단가 금지·돈크리티컬).
- 무결성=정식 §26 하네스 / 권위=상품마스터 시트+가격표 전블록 / 채번=언더스코어 OPT_·OPV_, 템플릿=TMPL- / 비대칭격자 verbatim only.

## 건드리지 말 것
- 이번 세션 라이브 COMMIT 전부(되돌리지 말것·undo 보유) — 상세=`remediation/_REMEDIATION-LOG.md`(2026-06-28 이어서~이어서5). 고정가 by-siz 4·면적 격자·addon 템플릿 7·사이즈 라벨 5·확인필요 시그널 8·166/153 활성화.
- 면적격자 셀·공유공식 PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T·부속자재 마스터코드([[base-master-code-no-delete]]).
- C트랙 webadmin 코드 변경(배포 전까지 운영 영향 0·로컬만).

## 산출물 위치
- 무결성: `_workspace/huni-price-table-integrity/`(01_authority 433셀·02_load·03_codex·04_gate verdict+confirmed CSV).
- 설계/검증: `_workspace/huni-price-engine-design/`(03_design acrylic-binding/addon·04_validation verdict).
- 교정 SQL/로그: `_workspace/_foundation/remediation/`(acryl-*·CTRACK-*·_REMEDIATION-LOG.md).
- ★시뮬레이터 검증 매트릭스: `remediation/acryl-simulator-verification-matrix.md`·헬퍼 `remediation/_sim_verify.sh`.
- ★addon 모델 결함·교정: `remediation/FINDING-addon-optcd-model-broken.md`.
- 진척판: `_workspace/_foundation/price-pipeline-rtm.csv`. 파이프라인 플레이북=`huni-price-master-orchestrator/SKILL.md`(codify).
