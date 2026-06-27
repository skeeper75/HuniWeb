# 가격 파이프라인 세션 핸드오프 — 2026-06-28(이어서3)

## 다음 시작점 (한 줄)
**다음 상품군 가격 종단 착수** — 아크릴 본체 마감 완료(고정가형·면적격자·addon 템플릿 전부 라이브 작동 검증). 잔여=163 미니파츠(권위 120x50 가격빈칸·실단가 필요)만. 다음 상품군은 검증 레시피(고정가 by-siz·면적격자·addon 템플릿) + ★라이브 시뮬레이터 실증으로 동형.

## ★이번 세션(이어서3) 핵심 — addon 모델 결함 적발+교정 패턴 실증
- **라이브 시뮬레이터 검증이 핵심 결함 적발**: 부속(고리·볼체인·마그넷 등)을 "공식 안 가산 comp(opt_cd 키)"로 넣는 방식이 엔진서 **미작동**(본체 자재 덮임/숨김·가산 opt_cd 미주입). dryrun 골든합산이 은폐→라이브가 적발. → `addon-optcd-model-broken-live` 메모리·`FINDING-*` 문서.
- **교정=addon 템플릿(엔진 정식)**: 147 마그넷 파일럿 **라이브 GO**(본품3100+addon800=3900). 검증 레시피=① 바인딩 본체공식만 ② 가산 옵션그룹 삭제(자재 covered 해소) ③ addon 템플릿(flat 단가)+링크.
- **이번 COMMIT**: 154머리끈·146Step2·166카라비너·153/155/160 고정가(전부 라이브 적재)·166/153 활성화·147 addon 템플릿. 단 **146/148~150/152/154 addon은 아직 미작동**(전파 대기). 고정가형(153/155/160/166)·면적격자=정상.
- **163 미니파츠**: 권위(상품마스터) 120x50 가격 **빈칸** → 적재불가(실 단가 확보 필요).

## 파이프라인 상태 (이번 세션 핵심 성과)
**마스터 오케스트레이터 첫 종단 실행 = 아크릴.** 그 과정에서 파이프라인을 개선해 다음 상품군이 동형으로 돌도록 codify 완료. 진척판 = `_workspace/_foundation/price-pipeline-rtm.csv`.

### 동형 전파 절차 (SKILL.md에 codify됨·HARD)
1. 사실수집(상품 전수·바인딩·자재·nonspec) + ★가격코드 의존성 운영배포 확인.
2. **단계1 무결성 = 정식 §26 4에이전트**(extractor→inspector→codex→gate). ★셀-카운트 quick diff 금지(아크릴서 141로 직행했다 156셀+12미바인딩+고아 놓칠 뻔). 권위=상품마스터 시트(`<군>-l1.csv`)+가격표 전 블록.
3. 단계2 R3 미적재셀 = 게이트 확정 CSV verbatim(대칭전개 금지).
4. 단계3 설계 = 상품→공식 귀속 → validator가 ⓐ즉시GO/ⓑaddon-HOLD/ⓒBLOCKED 3분류(날조·과소차단 적발).
5. 단계4 적재 = 분류대로. R4 addon = 본체+가산comp(opt_cd)+전용공식+CPQ옵션. ★carry-forward 점검(comp 실재≠배선).
6. 채번 = 언더스코어 OPT_/OPV_ 표준.

## 이번 세션 라이브 COMMIT (되돌리지 말 것) — 전부 dryrun→인간승인→사후검증
로그 = `remediation/_REMEDIATION-LOG.md`(2026-06-27~28). 단가 verbatim·물리삭제 0·undo 보유.
1. **R3 면적격자 156셀 보완** — 투명3T 196·투명1.5T 81·미러3T 81·코롯토 36 권위 완전화. `acryl-grid-fill-v2-*.sql`.
2. **안전 6상품 바인딩** — 157·158·159·161·162→PRF_CLR_ACRYL·164→PRF_COROTTO_ACRYL(고아 해소)·157 BYSIZ 임시모델 폐기. `acryl-bind-safe6-*.sql`.
3. **146 키링 저청구 교정** — 신규 PRF_ACRYL_KEYRING(본체+고리)→재바인딩(라이브 저청구 해소). `acryl-146-keyring-*.sql`.
4. **147~152 addon CPQ** — 마그넷·뱃지·집게·스마트톡·명찰 5상품(본체+가공옵션·택1 비필수). 옵션그룹5(OPT_000074~078)·옵션8(OPV_000465~472)·가산comp5·전용공식5·단가행8·바인딩5+자재보강1. `acryl-addon-147-152-*.sql`.

## 이번 세션 C트랙 (운영 배포 = 인간)
- **webadmin 채번 언더스코어 통일** — `raw/webadmin/webadmin/catalog/views.py _next_opt_grp_code/_next_opt_code`를 OPT_/OPV_로 교체(로컬 준비완료·py_compile OK). 운영 HuniProductPrice2 배포는 인간. 명세=`remediation/CTRACK-webadmin-optcode-numbering.md`.
- (직전 세션) `pricing.py _reduce_siz_dims`(siz_cd→cut 환원)=운영 배포 확정(사용자) → 아크릴 면적공식 단일진실원.

## 미해결/블로커 (아크릴 잔여)
- **154 머리끈** — HAIR_BAND comp 단가행(500) 충전+전용공식+옵션(147~152 동형·미실행).
- **146 Step2** — 볼체인(1000)·고리없음(0)·은색구슬줄(300) 옵션 추가(채번 언더스코어).
- **R1 카라비너(166)** — 완전 미적재·고정형 신규 그릇(dbm-price-import-prep) 설계 필요.
- **163 미니파츠** — 등록 120x50인데 1.5T격자 100까지=격자밖 견적불가(무결성 폐루프 or 사이즈 컨펌).
- **BLOCKED 컨펌큐(사용자 판단 필요):** 미러153(정체 모호·MIRROR3T comp 고아)·볼펜155(본체 inline 정찰가 B01 불일치)·자유형스탠드160(8800 정찰가)·쉐이커170/226·157 네임택 가공(B04b 단가 부재).

## 이번 세션 결정 (relitigate 금지)
- **무결성은 정식 §26 하네스로** — 셀-카운트 quick diff는 토대 결함을 놓침(아크릴 입증).
- **권위 = 상품마스터 시트**(상품별 가격모델+가공/추가) + 가격표 전 블록. "각 시트 상품에서 최종 적용대상 확인"(사용자).
- **채번 = 언더스코어 표준**(다수 135/510) + webadmin 채번코드 C트랙 교체로 재혼재 차단.
- **addon = 본체면적공식 + opt_cd 가산comp + 상품별 전용공식**(공유공식 오염 차단·미선택0·이중합산0).
- 비대칭쌍 격자는 verbatim only(대칭전개=오가격).

## 건드리지 말 것
- 위 COMMIT 4건(R3 156셀·안전6·146·147~152). undo 보유.
- 면적격자 217 기존셀·공유공식 PRF_CLR_ACRYL/COMP_ACRYL_CLEAR3T·고리 COMP_ACRYL_KEYRING 단가행·부속자재 마스터코드.
- C트랙 webadmin 코드 변경(배포 전까지 운영 영향 0·로컬만).

## 산출물 위치
- 무결성: `_workspace/huni-price-table-integrity/`(01_authority 433셀·02_load·03_codex·04_gate verdict+confirmed CSV).
- 설계/검증: `_workspace/huni-price-engine-design/`(03_design acrylic-binding/addon·04_validation verdict).
- 교정 SQL/로그: `_workspace/_foundation/remediation/`(acryl-*·CTRACK-*·_REMEDIATION-LOG.md).
- 진척판: `_workspace/_foundation/price-pipeline-rtm.csv`.
