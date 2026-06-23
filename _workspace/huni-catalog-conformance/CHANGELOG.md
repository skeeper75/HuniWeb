# Huni-Catalog-Conformance — CHANGELOG

전 상품 12축 + 가격엔진이 두 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)과 일치하는지
누락 0으로 종단 정합 검증 + 교정 명세. 최신 항목이 맨 위.

---

## 2026-06-23 (9) — RC-2 각목 라이브 COMMIT (12000 이중합산 해소·도메인/경쟁사 Q3 수렴)

RC-2 데이터 트랙의 마지막 BLOCKED 핵심(각목)을 사용자 도메인 입력+가격표 권위+경쟁사 리서치로 닫고 COMMIT.
arbiter 모델 재정립(background) → 사용자 Q1~Q3 → 도메인/경쟁사 Q3 리서치 → option-mapper 명세 →
load-builder 적재본 → validator R1~R6 → 인간 승인 → load-executor COMMIT.

**Q3 도메인·경쟁사 수렴**(`04_price_engine/rc2-gakmok-q3-domain-benchmark.md`): 손님 직접 택1 vs 사이즈 자동
판정 중 **세 권위(인쇄 도메인 관행·경쟁사 5곳 전건·권위 가격표) 모두 (a) 손님 직접으로 수렴**. 자동 사이즈
판정 UX는 어디서도 발견 0(레드프린팅도 각목 위치 "상하 가로/좌우 세로" 손님 직접 선택). → 데이터만으로
닫힘·위젯 코드 불요.

**각목 라이브 COMMIT**(`03_cpq_link/rc2-gakmok-load-spec.md`·`09_load/_rc2_gakmok_260623/`·12행):
① Q1 옵션 재라벨 — 기존 OPV_000015/016을 가격표 verbatim 라벨로(각목900이하+끈/900초과+끈·신규 채번
회피) ② Q2 세로/가로 신규 그룹 OPT_000063(OPV_000432 세로변/OPV_000433 가로변·가격 0·생산메타 분리)
③ comp 정비 — _LE/_GT 2 comp use_dims []→[opt_cd]·단가행 4698 opt_cd=OPV_000015(4000)·4700 opt_cd=
OPV_000016(8000) verbatim·부모 껍데기 use_yn=N ④ PRF_POSTER_BANNER_N addtn_yn=Y 바인딩 2.

**★12000 이중합산 결함 해소**: 현행 _LE/_GT 둘 다 빈 use_dims=always-match → 한 주문에 4000+8000=12000
이중합산(돈크리티컬). opt_cd 충전 + OPT_000004 택1(max_sel_cnt=1)로 동시매칭 원천 차단 → 미선택 0·각목≤900
=4000 1행·각목>900=8000 1행. 빌더가 **보수안(2 comp 유지·각 opt_cd 충전)** 채택(형제 끈/큐방 동형·comp
병합 리스크 회피·메모리 통합 함정 회피). R1~R6 GO·단가 verbatim·기초코드 마스터 불변·메쉬139 미접촉
(가격표 각목 부재). **RC-2 데이터 트랙(추가물 3상품+CONFIRM 3건+각목) 전부 COMMIT 완료.**

---

## 2026-06-23 (8) — RC-2 CONFIRM 확정 3건 라이브 COMMIT + 각목 모델 재정립 (사용자 도메인 입력)

사용자 "CONFIRM 정리하고 막힌 것들 진행" directive. RC-2 미해결 CONFIRM 4건(A 타공·4 각목·B 린넨마감·
C 족자)을 arbiter 결정 패킷으로 가공→사용자 확정→확정 3건 적재(린넨마감·타공·족자)·각목 재정립.

**CONFIRM 결정 패킷**(`04_price_engine/rc2-confirm-decision-packet.md`): 라이브/권위/엔진 추가 실측으로
4건 선택지·트레이드오프·권고 정리. **CONFIRM-B 린넨마감=CLOSED**(라이브 실측으로 단가행 opt_cd가 이미
린넨패브릭124와 1:1 정합 판명·재배선 불요·설계 문서의 "불일치" 오판 정정).

**확정 3건 라이브 COMMIT**(`03_cpq_link/rc2-confirm-resolved-load-spec.md`·`09_load/_rc2_confirm_resolved_260623/`·19행):
① 린넨마감(124) PRF_POSTER_LINEN addtn_yn=Y 바인딩(캔버스패브릭125=비동형·마감비 단가 부재 HOLD) ② 타공
(138/139) 데이터 트랙 — 일반 PUNCH_4 단가행 proc_cd 105→104(부모) 통일·메쉬 PUNCH_4/6/8 proc_cd NULL→079+
dim_vals{타공수} 충전·use_dims []→proc_cd·바인딩·좀비 PUNCH_6/8 use_yn=N(★타공수별 가산은 위젯 코드
동반 후·데이터는 always-add 과대청구 제거까지) ③ 족자(135) 천정고리 opt_cd 재배선(신규 OPV_000431·단가행
4594 bdl_qty=2→opt_cd·6500 verbatim). R1~R6 GO·단가 verbatim·각목/캔버스125/기초코드 마스터 미접촉.

**각목(CONFIRM-4) 모델 재정립**(`04_price_engine/rc2-gakmok-model-revisit.md`): 사용자 도메인 입력("가로형/
세로형에 따라 부착 변 다름·양쪽/위아래 가능")으로 직전 "세로/가로=오라벨" 판정 **번복** — 삭제된 구버전 옵션
그룹 라벨 "각목 세로폭기준/가로폭기준" 실측이 사용자 입력 뒷받침. **단가 권위 출처=인쇄상품 가격표 260527
포스터사인 r244-250**(각목900이하+끈=4000·900초과+끈=8000) 발견 → 라이브 _LE/_GT verbatim 출처 확정. 모델
권고 **B→C 전환**(가격표가 각목을 "900이하/초과 enum"으로 못박음→opt_cd에 임계 내장·데이터만·코드 불요).
세로/가로=가격 무관(생산 메타 분리)·양쪽/개수=가격 무관(단가 2종뿐). 현행 2 comp 빈차원=12000 이중합산 결함
재확인. 사용자 확인 Q1~Q3 후 적재 예정.

**잔여 HOLD(돈크리·인간 결정)**: 일반현수막 타공수8 라이브 8000 vs 권위 5000(HOLD-NORMAL-PUNCH8-PRICE·
verbatim 적재됨)·족자 6500 vs 권위 "4000?"(HOLD-C-PRICE)·PET(136) 거치대 의미중복(HOLD-1)·타공 위젯 코드트랙.

---

## 2026-06-23 (7) — RC-2 추가물 3상품 라이브 COMMIT (always-add 가드 실효·RC-4 재배선)

RC-2(실사 현수막류 가공/추가 바인딩) 중 **CONFIRM에 안 묶인 추가물형 옵션**만 선별 COMMIT(사용자
"안 막힌 것부터 진행" directive). 체인: option-mapper 통합명세(CPQ 채번+CONFIRM-D 실측+RC-4 재배선) →
load-builder 적재본+DRY-RUN → validator R1~R6 → 인간 승인 → load-executor COMMIT.

**대상 3상품(23행)**: 메쉬현수막(139) 큐방/끈·캔버스행잉(133) 우드행거+면끈·린넨우드봉(134) 우드봉+면끈.
옵션 INSERT 4(OPV_000425/426/429/430·기존 그룹 재사용·신규 그룹 0) + comp use_dims UPDATE 4(opt_cd
always-add 가드 충전) + 단가행 UPDATE 11(opt_cd 8 + RC-4 siz_cd 재배선 3·단가 verbatim) + 공식 바인딩
INSERT 4(addtn_yn=Y·PRF_POSTER_BANNER_M/CANVAS_HANGING/LINEN_WOODBONG·disp_seq=2+).

**라이브 실측으로 닫은 4건**(`03_cpq_link/rc2-addon-load-spec-unblocked.md`): ① CONFIRM-D 본체공식 frm_cd
4종 확정(메쉬=PRF_POSTER_BANNER_M 등) ② CPQ 신규 그룹 0(search-before-mint·기존 추가그룹 재사용) ③ RC-4
캔버스 우드행거 단가행 siz_cd가 실은 134 사이즈(258/315/317)→133 등록 사이즈(172/174/197) 재배선(동일 치수
A4/A3/A2·단가 16000/18000/20000 verbatim) ④ 가격 메커니즘=banner 138 동형(opt_cd 단독 판별).

**★always-add 가드 라이브 실효**: 우드행거/우드봉 use_dims에 opt_cd 미포함 시 "출력만 선택"에도 silent
가산(NULL opt_cd 와일드카드 누출) → opt_cd 가드 충전으로 미선택 가산 0·선택 시 정확 단가 1행 매칭. 엔진
`_row_matches` 순수함수 재현 + 라이브 COMMIT 후 재실측 입증. 검증 GO(R1~R6 전건 PASS·undo 보유·기초코드
마스터 불변). **PET(136)=HOLD-1**(거치대 택1 그룹 의미 중복 모델링 CONFIRM)·각목/타공/린넨마감/족자=
CONFIRM-A/4/B/C 의존 BLOCKED 유지·option_item MES 환원=HOLD-2/3(가격 무영향) 후속.

---

## 2026-06-23 (6) — RC-5 아크릴/폼보드 단가 교정 라이브 COMMIT (별색옵션 혼동 4축 배제)

실사 RC 교정 이어가기 — RC-5(아크릴·폼보드 본체단가 오적재) 라이브 COMMIT 완주. 전 체인 검증된
순서대로: 진단(arbiter) → 적재본+DRY-RUN(load-builder) → R1~R6 독립 게이트(validator) → 인간 승인 →
COMMIT+사후검증(load-executor).

**선행 진단 CONFIRM-2 해소**(`04_price_engine/rc5-acrylic-foamboard-diagnosis.md`): 라이브 어긋난 단가가
별색옵션 값 오인이 아니라 본체 siz_cd 단가 **단순 오적재**(진원=상류 v03 추정)임을 4축 교차로 배제 —
① 권위 silsa-l1 "화이트별색(옵션)" col26 3상품 전행 공란 ② 라이브 단가행 clr_cd/opt_cd/dim_vals 전 10행
NULL ③ CPQ 별색옵션 그룹 0개 ④ 엔진 NON_QTY_DIMS(pricing.py)에 clr_cd 부재. 각 상품 1:1 전용 공식 +
단일 본체 comp(use_dims=`["siz_cd"]`).

**교정 라이브 COMMIT**(`09_load/_rc5_acrylic_foamboard_260623/`·component_prices 10행·단가 verbatim):
유광아크릴(142) 4792~4795 → 12000/18000/28000/47000 · 미러아크릴(143) 4796~4799 → 15000/22000/36000/62000 ·
폼보드(129) 4780(A3) 7000→6000 / A2(4781)=12000 불변 / **A1=SIZ_000294(594×841 세로형) 20000 신규 INSERT**
(comp_price_id 38239). search-before-mint 충족(siz_cd 전부 기존재·신규 채번 0)·기초코드 마스터 t_siz/t_mat
불변. undo=`undo.sql`·백업=`backup-before-260623.csv` 보유.

**검증 GO**: R1~R6 전건 PASS(BLOCKER/MAJOR 0). MINOR-1=빌더 manifest IDENTITY 시퀀스 수치 기재 오류
(dry-run nextval 전진·ROLLBACK이 시퀀스 미복원하는 PostgreSQL 정상 동작) — seq>MAX라 채번 충돌 0·적재
안전성 무영향. 생성≠검증 실효 입증(검증자 독립 재실측이 적발).

---

## 2026-06-23 (5) — 실사 가격 구조 종합 모델 + 차원 메커니즘 감사 + RC-2 일반현수막 COMMIT

사용자 directive(장치를 적재적소에·정확한 값까지 끈기있게)로 실사 카테고리를 단편 교정이 아니라
구조-우선으로 종합 모델링. 4장치(가격공식·구성요소·뷰어·시뮬레이터) 코드+라이브 양면 확인.

**4장치 라이브 실측**: 공식 50(use_yn 49)·공식-구성요소 링크 87·구성요소 149(단가행 7,292)·직접단가 26
(=GP-1)·템플릿 13(단가 0)·할인 8테이블/35상세/102링크. ★전 275상품 중 가격가능 103(37%)·**견적불가 172(63%)**.
공식유형(frm_typ) 컬럼 실제 부재=코드 폐기와 정합.

**차원 메커니즘 감사**(`04_price_engine/price-component-dimension-mechanism-audit.md`): 옵션(ref_dim_cd 매핑·
opt_cd 직접차원)·공정+공정상세옵션(proc_grp+dim_vals·데이터드리븐 price_dim/contrib)·템플릿/추가상품이
**코드에 이미 구현**되어 시뮬레이터가 판별값을 전송. ★정정: 앞선 "siz_preset 위젯 코드 변경 필수"는 과한
진단 — opt_cd 차원 메커니즘으로 코드 변경 없이 처리 가능(시뮬레이터 한정·위젯은 별도 트랙).

**실사 가격 구조 종합 모델**(`04_price_engine/silsa-price-structure-model.md`): 28상품 동형 5클래스(C1 면적13·
C2 siz_cd 고정14·C3 현수막혼합·C4 가공/추가 add-on 31comp·C5 프리셋통합6). 수량구간할인=굿즈/문구/아크릴
전용·실사 없음(사용자 확정). **6대 RC 결함**: RC-1 면적프리셋 과대(R-B3-PRICE)·**RC-2 옵션comp 30/31 고아
(최대·가공/추가 견적 미완성)**·RC-3 빈 use_dims/좀비·RC-4 캔버스행잉 차원역배선·RC-5 아크릴/폼보드 단가
오적재(권위=정답·라이브 교정·사용자 확정)·미니류 권위부재.

**R-B3-PRICE 모델 확정**(`r-b3-price-model.md`): A3/A2/A1=실제 등록 용지 프리셋(siz_cd·고정가 7000/7000/
12000)·사용자입력=nonspec 면적매트릭스(600mm~). 라이브가 프리셋을 면적 ceiling으로 올림=과대청구(A3·A2
+5,000·A1 +8,000). 모델=opt_cd 판별차원(옵션그룹화).

**★RC-2 일반현수막 파일럿 라이브 COMMIT(되돌리지 말 것)**: PRD_000138/PRF_POSTER_BANNER_N 가공/추가 6 comp
종단 배선 — use_dims 충전 5(빈 `[]`→`[opt_cd,opt_grp]`)·단가행 opt_cd 충전 5(verbatim)·공식 addtn_yn=Y
바인딩 6. dbm-load-builder DRY-RUN → dbm-validator R1~R6 GO(생성≠검증) → COMMIT → 사후검증 PASS: **미선택=0가산
(단일 가공/추가 옵션 과소청구 해소)**·선택별 정확(타공 3000/4000/8000·끈/봉미싱/큐방/열재단/양면테입 각 단가)·
ERR_AMBIGUOUS/DUPLICATE 0·멱등·회귀 0·단가 0변경. 백업/undo=`09_load/_rc2_banner_260623/`.
★잔존 코드트랙(§21 밖): 타공 효력(CONFIRM-A·proc_cd 104↔105·실무진)·opt 동시선택(selections 단일키)·각목
세로/가로(CONFIRM-4 사용자 확정)·나머지 6 현수막류 CPQ 미등록.

**잔여**: RC-2 6 현수막류(CPQ 선등록)·RC-5 단가교정·RC-4 차원정정·RC-3 좀비·RC-1 프리셋(opt_cd)·R-B3-1 아크릴20.

---

## 2026-06-23 (4) — 교정 실행 단계 진입: K6 PASS + R-GP4-1 굿즈 base 라이브 COMMIT

검증 종료 후 인간 승인(굿즈 GP-1만 먼저)으로 교정 실행 시작.

**K6 해소(전 5배치 BLOCKED→PASS):** `.env.local` 자격증명 갱신 → product-viewer
gstack 로그인 SUCCESS(이전 stale 판정은 당시 `.env.local` 값 오류였음). 화면축 3원 대조 8상품 불일치 0·과대청구
교정분(027 접지·094 엽서북) silent-sum 차단이 화면에 반영 확인. 종합 verdict 불변(화면축이 역전 없이
독립 재확인). 산출=`06_gate/k6-screen-recheck-260623.md`+captures.

**R-GP4-1 굿즈 GP-1 base 라이브 COMMIT(되돌리지 말 것):** 단일고정가 26행 `t_prd_product_prices`
INSERT(상품마스터 C열 단가 verbatim). 견적 0→정상 실증(카드거울 qty10=25,000·캔버스 qty3=174,000·
말랑포카 qty10=140,000). DRY-RUN PASS·멱등(PK prd_cd+apply_ymd·ON CONFLICT DO NOTHING)·물리
백업·undo 보유(`09_load/_gp1_base_260623/`). 기초코드 마스터 무접촉·단가 0변경·search-before-mint.

★로드 실행기 독립 적발: 반팔티(PRD_000206)·후드티(PRD_000209)가 checklist 옵션그룹=N 오분류였으나
엑셀 권위에 색상×사이즈 variant 존재 → **G-GP-5 위반 위험**(product_prices 선점=FORMULA 영영 우회)으로
적재 보류·R-GP4-5 라우팅. 적재 26 / 보류 2.

**잔여 교정(미실행):** 실사 A-프리셋 R-B3-PRICE(arbiter 모델정립)·아크릴20 R-B3-1(Q-ACR-MISSING20)·
GP-2 FORMULA R-GP4-5·R-GP4-2~4·CPQ MISS — 전부 모델정립/CONFIRM 선행.

---

## 2026-06-23 (3) — ★전 카탈로그 11시트 종단 완료 + 배치4(goods-pouch 98 prd) CONDITIONAL GO

마지막 잔여 시트 goods-pouch 종단 → **전 11시트 종단 정합 검증 완료**. checklist 누계 3,198 데이터행·
246 prd·16 그룹·**빈 셀 0**(누락 0 완주). 동형 7클래스 압축으로 103상품 토큰 효율 처리.

**배치4 결과:**
- Phase 1: 라이브 98 prd(PRD_000183~280, 엑셀 103 중 폰케이스 5 미등록). 동형 7클래스 전부 고정가형.
- Phase 2 인스펙터: basedata 784셀(MISSING 240·자재 MISMATCH 76 오염·판형 EXTRA 85·도수 MISSING 98·
  돈크리 0)·cpq-link 392셀(MISSING 77·DEAD_LINK 0·전 CPQ 테이블 0행)·price-engine 98셀(MISSING_BIND 93·
  NO_AUTHORITY 5 권위공란·신규 ACR 할인 오귀속 1).
- Phase 3 codex(gpt-5.5 high): 합의 6·불일치 0·신규발굴 1(discount 82 FK/del_yn 무결성)·환각 0.
- Phase 4 게이트: K1~K5·K7·K8 PASS·**K6 BLOCKED(HUNI_ADMIN_PW 5연속 stale)** → **CONDITIONAL GO**.

**게이트 codex 큐 해소(생성≠검증):** ★자재 "100% 오염" 가설 기각 — PRD_000230 `레더|L|M`(본체소재+옵션값
공존)이라 교정은 **행 단위**(레더 잔류·옵션값만 이관). discount FK 전건 해소(유일 결함=PRD_000203
DSC_ACR_QTY 오귀속). 단가행 유일성은 base 0이라 적재명세 가드(G-GP-6)로 이월.

**핵심 결함:** 바인딩 0/98 = 가격 산출 불가(견적 0원·최대 결함·D-GP4-BIND). 판형 85 EXTRA(굿즈=전지없음·
round-22 잔재). 자재 76 오염·묶음수 64 MISSING(구수 materials 오적재)·CPQ MISSING 77. NO_AUTHORITY 5는
결함 아닌 권위 공란.

**인간 승인 큐:** 클래스 A=R-GP4-1(GP-1 base 적재·1순위·98상품 견적0 해소)·R-GP4-2(ACR 재바인딩)·
R-GP4-3(판형 정리)·R-GP4-4(자재 행단위 정규화) / 클래스 B=GP-2 FORMULA·가공·구수·CPQ77.

### ★전 11시트 종합 (`06_gate/conformance-final-summary.md`)
- 시트별 verdict: 디지털·배치1·2·3 = NO-GO(라이브 권위 미달=round-13 역전)·배치4 = CONDITIONAL GO.
- 과대청구 8건 전부 라이브 COMMIT 차단 완료(되돌리지 말 것). 미검증이던 4시트 종단 결과 신규 과대청구
  1건(배치3 실사 A-프리셋·게이트 적발·미적재라 미COMMIT).
- 생성≠검증 입증 누적: 배치2 094 양방향·배치3 실사 A1+8,000·배치4 자재100%오염 기각.
- **실 COMMIT 0**(전 교정 인간 승인 후 dbmap 위임). 검증 단계 종료 → 교정 실행 단계.
- 유일 미해소: K6 product-viewer(HUNI_ADMIN_PW 5연속 stale·갱신 후 전 배치 일괄 재실행).

---

## 2026-06-23 (2) — 배치3 (sticker·acrylic·silsa, 라이브 65 prd) 종단 완료·NO-GO

미검증 4시트 중 3시트 동형 파이프라인 완주(잔여=goods-pouch 배치4). checklist +845행(누계 1,924
데이터행). 모집단=라이브 prd_nm 1:1 실측(엑셀 66 중 실사 투명포스터 1 미등록=CONFIRM).

**Phase 결과:**
- Phase 1 권위: 바인딩 45/65=69%(§18 가격엔진 설계가 라이브 적재된 결과·배치2 5/34 대비 급상승).
  판별차원 명시(스티커=소재×사이즈×수량 단면=NULL 안전 / 실사=소재별 1:1+면적매트릭스 / 아크릴=두께/색×가공×조각수).
- Phase 2 인스펙터 3병렬: basedata 520셀(MISSING 4=아크릴 부속물 부착공정 누락 148/149/152/154)·
  cpq-link 260셀(MISSING 76·MISMATCH 2·옵션→차원 100% 해소·DEAD_LINK 0)·price-engine 65셀(BOUND 45·
  MISSING_BIND 20=아크릴 147~166·NULL_WILDCARD 0).
- Phase 3 codex(gpt-5.5 high): 합의 6·불일치 0·신규발굴 0·false-positive 0·환각 0. 신규 가설 2건 게이트로.
- Phase 4 게이트 K1~K8: **K4 FAIL → NO-GO**. K6 BLOCKED(PW 3연속 stale)→CONDITIONAL.

**★게이트 신규발굴(생성≠검증 입증·돈크리티컬):**
- 인스펙터·codex 모두 "과대청구 0/조건부 보류"로 봤으나, 게이트가 evaluate_price ceiling 재계산으로
  **실사 면적그리드 A-사이즈 과대청구 확정 적발** — 실사 118/120/121/123 ×3프리셋. A3/A2 +5,000,
  **A1 +8,000(594<600 off-grid)은 generation-side가 "A1=on-grid"로 오판해 놓친 신규 결함**.
  근본=A3/A2/A1 고정가 프리셋행(7000/7000/12000) 미적재(사용자입력 ≥600 연속티어만 평면화 적재).
- codex 가설 H1(스티커 tuple 중복)·H2(실사 formula_components 중복) 라이브 GROUP BY=전부 0 기각.

**핵심 결함:** ①실사 A-사이즈 과대청구(R-B3-PRICE·돈크리·클래스 B 4상품 공유 comp) ②아크릴 147~166
20 미바인딩=가격0 견적불가(R-B3-1·G-4 끊김 라이브 재현) ③부속물 BUNDLE 부착공정 4(R-B3-BUNDLE)
④CPQ MISSING 76·MISMATCH 2(거치대 비대칭·고리 sel_typ NULL)·EXTRA 1(TMPL-000013 테스트 잔재).

**실 COMMIT 0**(인간 승인 후 dbmap 위임). 인간승인큐: R-B3-PRICE > R-B3-1 > R-B3-BUNDLE > CPQ 클래스 A.
산출=`06_gate/{conformance-verdict,e2e-golden-trace,remediation-spec}-batch3.md`·`_meta/batch-progress-260622.md`.

---

## 2026-06-22 (2) — 019 첫 교정 라이브 COMMIT (클래스 A·directive 준수·되돌리지 말 것)

사용자 directive "기초코드 미수정·상품별 구성요소만"으로 교정 명세 재분류 → 클래스 A(상품별 9)/
클래스 B(공유 마스터 수정 필요·보류 5). 최대 돈결함(명함 D-A/D-B·미바인딩)은 공유 공식 영역이라
**클래스 B 보류**(directive 엄수·추후 §18에서 공유 공식 재설계로). 클래스 A 중 019만 교정 실행.

**019 투명엽서 묶음 교정 (라이브 COMMIT 완료·되돌리지 말 것):**
- **A5-plate**: 출력판형 SIZ_000522(315x467 오적재) → **SIZ_000499(316x467, 사용자 확정)** 멱등 UPDATE.
- **A2-bind**: PRD_000019 ↔ **PRF_DGP_A** 바인딩 UPSERT(@2026-06-01).
- 효과: 가격 **0원 차단 → 77,064원**(대표 골든 qty100·단면·MAT_000074·무광). 형제 016/017/018 동일 경로 합류.
- **directive 준수**: `t_prd_product_plate_sizes`·`t_prd_product_price_formulas` 019 2행만 접근. 공유 마스터(t_siz_sizes·t_prc_* 공식/comp/단가행) 무수정·신규 mint 0.
- 검증 체인(생성≠검증): load-builder DRY-RUN(목표 미달 적발→판형 정정 동반 필요 분리) → dbm-validator R1~R6 GO(77,064 독립 재계산) → 사용자 승인 → COMMIT → 독립 사후검증 PASS(영속·부작용0·멱등).
- 잔여: 025/039 동형 판형(권위 확인 후 별도)·019 완성품치수 혼입 EXTRA 정리.

산출: `06_gate/remediation/019-bind/`(apply.sql·apply.sh·preflight·dryrun-log·validation-verdict·postcommit-verify).

---

## 2026-06-22 — 하네스 초기 구성 + 디지털인쇄 첫 종단 실행 (NO-GO)

### 하네스 구성
- 6 에이전트(`hcc-authority-curator`→`hcc-basedata-inspector`·`hcc-cpq-link-inspector`·
  `hcc-price-engine-inspector` 팬아웃→`hcc-codex-verifier` 독립 2차→`hcc-conformance-gate` K1~K8).
- 6 스킬(hcc-* 5 + orchestrator). codex 교차는 `hqv-codex-cross-verify` 재사용. CLAUDE.md §21.

### 첫 실행: 디지털인쇄 36상품(PRD_000016~051) 종단 정합 검증
- **Phase 1 큐레이션**: 36상품 × 13축 = 468셀 체크리스트(누락 0의 자)·domain-lens·reuse-map.
  기존 산출물 재사용(조사 반복 0). CONFIRM 큐 4건. frm_cd 미바인딩 10건 단서.
- **Phase 2 인스펙터 3 병렬**: 468셀 전수 채움(빈 셀 0).
  - basedata 288셀: MATCH158·N/A85·MISSING31·MISMATCH9·EXTRA2·CONFIRM3. 별색인쇄 미적재·판형 오매칭·자재 미적재.
  - cpq-link 144셀: MATCH15·MISMATCH2·MISSING73·N/A54. **옵션→차원 264/264 해소(DEAD_LINK 0)**·템플릿→추가상품 5/5. 갭=광범위 미적재. cpq-schema.md stale 정정(옵션 대량 적재됨).
  - price-engine 36셀: MATCH23·MISMATCH3·MISSING10. frm_cd 미바인딩 10 확정(단서 1:1).
- **Phase 3 codex 교차**(gpt-5.5 가용·환각 0): 합의 7·불일치 5·codex 신규 2. codex가 false-positive 후보 3건(포토카드 별색 과판정·constraints 34 근거 부족·페이지룰 강등)·놓친 결함 N2 적발.
- **Phase 4 게이트 K1~K8 → 종합 NO-GO**:
  - K1 PASS(누락 0) · K2 PASS(결함 입증) · K3 PASS(연결 무결) · **K4 FAIL** · **K5 FAIL** · K6 BLOCKED(gstack 로그인 인증 실패) · K7 PASS(codex 큐 미해결 0) · K8 PASS.
  - 게이트 독자 적발(생성≠검증 작동): D-B 이중합산 진원=STD use_dims에 print_opt_cd 부재·COMP_PRINT 키=plt_siz_cd·constraint_json 캐시 라이브 부재·032 MAT_000081 STD 행 부재로 0원.

### 돈 크리티컬 결함 (교정 명세 9항목·전부 인간 승인 큐)
- **R1 명함 D-A/D-B** — 이중합산 과대(+280K)·미충전 과소(−550K). use_dims에 print_opt_cd 등재 선행. → dbm-price-arbiter→dbm-load-execution
- **R2 미바인딩 10상품** — 견적 0원 차단. 공식 신설+바인딩(comp orphan 실재). → dbm-load-execution
- **R4 COMP_COAT_GLOSSY 0행** — 유광 과소.

### 블로커 / 다음 시작점
- **K6 gstack BLOCKED**: `.env.local HUNI_ADMIN_PW`·CLAUDE.md "[REDACTED]" 모두 라이브 인증 불일치. **유효 PW 갱신 후 product-viewer 3원 대조 재실행** 필요(추측 로그인 금지).
- 교정 실행(R1~R9)은 인간 승인 후 dbmap 트랙 위임(본 하네스는 검증+명세까지).
- 전 상품 확장: 동일 자(尺)로 나머지 10시트 전파 가능(디지털인쇄 파일럿 완주).

### 산출물 루트
`_workspace/huni-catalog-conformance/`(01_authority·02_basedata·03_cpq_link·04_price_engine·05_codex·06_gate).
종합 판정=`06_gate/conformance-verdict.md`·교정 명세=`06_gate/remediation-spec.md`·종단 추적=`06_gate/e2e-golden-trace.md`.
