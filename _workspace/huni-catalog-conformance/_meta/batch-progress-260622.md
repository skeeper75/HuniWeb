# §21 카탈로그 정합 — 나머지 10시트 확대 진행 트래커

권위 자(尺) = 디지털인쇄 파일럿(36상품, 완료). 동형 파이프라인: curator → basedata/cpq-link/price-engine inspector(병렬) → codex-verifier → conformance-gate. 생성≠검증·라이브 읽기전용·DB 미적재.

토큰 안전 운영: 무거운 데이터는 서브에이전트 내부에서만 처리, 메인엔 압축 판정만. 세션당 3시트 배치.

## 시트 모집단 (디지털인쇄 36 = 완료, 제외)

| 시트 | 정제 상품수 | 배치 |
|------|-----------|------|
| photobook(포토북) | 1 (라이브 8 분해) | **배치1** |
| calendar(캘린더) | 5 | **배치1** |
| design-calendar(디자인캘린더) | 5 (calendar 고정가형) | **배치1** |
| booklet(책자) | 10(실측) | **배치2** |
| stationery(문구) | 9(실측) | **배치2** |
| product-accessory(상품악세사리) | 15 | **배치2** |
| sticker(스티커) | 16 | 배치3 후보 |
| acrylic(아크릴) | 21 | 배치3 후보 |
| silsa(실사) | 29 | 배치3 후보 |
| goods-pouch(굿즈파우치) | 103 | 배치4(단독·대형) |
| map / calc-formula-draft | 0 (비상품) | 제외 |

## 배치 진행 상태

### 배치1 (2026-06-22) — photobook · calendar · design-calendar — **종단 완료·NO-GO**
- [x] Phase 1 권위 큐레이션 — checklist +169행(전체 637), 가격엔진 6건 MISSING 후보, CONFIRM 3건
- [x] Phase 2 인스펙터 — 기초데이터 결함 28(112판형 돈크리·자재↔공정 오염4·페이지룰5·반제품 역할축)·CPQ 19 MISSING(옵션레이어 전무·dead link 0)·가격엔진 6 차단(full WIRE·공식 0행)
- [x] Phase 3 codex 교차 — 가용·4쟁점 전건 합의(불일치 0)·환각 0·GATE-1 횡단정정 1건(constraint_json 부재)
- [x] Phase 4 K1~K8 게이트 — K4 FAIL(돈크리 차단 6)→**NO-GO**. K6 BLOCKED(HUNI_ADMIN_PW stale). 클래스 A 14/B 0
- **판정: NO-GO** (라이브가 권위 미달=round-13 역전. 검사 오류 아님)
- 교정 라우팅: price-arbiter 1·option-mapper 1·cpq-option 1·axis-staged 2·load-builder 2·correctness-audit 2. 실 COMMIT 인간 승인.
- 인간 승인 큐 top: ①R-B1-PRICE(돈크리·Q-PB 컨펌 동반) ②R-B1-PLATE-112 ③자재→공정 한 트랜잭션 ④R-GATE1 횡단

### 배치2 (2026-06-22) — booklet · stationery · product-accessory(34상품) — **종단 완료·NO-GO**
- [x] Phase 1 권위 큐레이션 — prd_cd 라이브 1:1 실측(엑셀ID 부정확), checklist +442행(전체 1,079), GATE-1 정정 선반영, 가격엔진 바인딩5/MISSING29
- [x] Phase 2 인스펙터 — 기초데이터 12결함(돈크리 1=PUR책자070 자재누락)+CONFIRM28(축귀속)·CPQ DEAD_LINK 5(siz del_yn=Y→A5 차단)+MISSING28·가격엔진 바인딩5 전부결함+MISSING28 차단
- [x] Phase 3 codex 교차 — 가용·4/5 합의·환각 0·신규발굴(094 양면도 +11,000 과대=양방향)·del_yn 필터부재 실노출 1건뿐(과잉일반화 교정)
- [x] Phase 4 K1~K8 — K4·K5 FAIL→**NO-GO**. K6 BLOCKED(인증). 돈크리 094 silent 양방향 과대 라이브+코드 비준
- **판정: NO-GO**. 돈크리(과대청구) 094 1건 양방향(단면+11,500/장·양면+11,000/장 silent=틀린값 성립·최위험). 클래스 A(DL5·070자재·MISS28일부 즉시)/B(094 use_dims 공유·BIND 공유공식+del_yn 코드위험 보류)
- 교정 라우팅: price-arbiter→load-execution 2·option-mapper 1·axis-staged 1·load-execution 2. 실 COMMIT 0.
- 인간 승인 큐 top: ①R-B2-094(돈크리·use_dims 공유영향 검토 후) ②R-B2-BIND(misfire+표지내지·del_yn 코드) ③R-B2-DL5/070MAT(클래스A 즉시)

### 과대청구 타겟 스캔 (2026-06-23) — 전 카탈로그·명세 완료
- 적출 8건 확정(codex 8/8 합의·false-positive 0·환각 0): 명함031/032·엽서북094·접지카드027/028/029(신규)·포토카드024/025(신규·MATCH 오분류 정정)
- 변종 V1(print_opt_cd NULL)·V2(접지 proc_grp 토큰 전무)·V3(포토카드 일반/투명 공식공유)
- ★미검증 4시트(sticker·acrylic·silsa·goods-pouch) 적출 0 → 돈 새는 면 전부 확인됨
- 돈영향 1순위=접지카드(+18,000~20,000/장·100장 ~180만원 누적). 교정=단가 verbatim 불변·판별차원 충전만(1택 매칭)
- 권고: V1 print_opt 양방향 충전 / V2 proc_grp 토큰(P8-1 재사용) / V3 공식분리 PRF_PHOTOCARD_NORMAL/CLEAR
- 클래스 A(포토카드)/B(명함·접지·094 공유자원). 094=use_dims 타책자 공유 의심→적재 전 SELECT 필수
- 승인 큐 A-1~A-6 + 컨펌 C-1(PRINT_OPT 코드 실재)·C-2(proc_grp vs opt_cd)·C-3(공식분리 vs 판별차원)
- 명세=`06_gate/overcharge-remediation-spec.md`·`04_price_engine/overcharge-scan-catalog.*`. 실 COMMIT 0(인간 승인 후 dbmap 위임·게이트 evaluate_price 1택매칭 재계산 비준 선행)

### 접지카드 과대청구 교정 — 적재 준비·등록 명세 완료 (2026-06-23·BLOCKED on 인간 승인)
- 적재 준비본=`09_load/_overcharge_foldcard_260623/`(fold-remediation-mapping.csv·apply.sql·dryrun·verbatim-guard). DRY-RUN 25,000→6,000 실증·verbatim PASS·단가 변경 0
- ★4개 다 같이 고쳐야 효과(부분교정=0). 기초코드 부족으로 BLOCKED → §12 등록 선행
- §12 등록 명세=`_workspace/huni-basecode/03_registration/fold-process-registration-{spec.md,rows.csv}`:
  - 4단병풍접지 → **PROC_000071 재사용**(병풍=아코디언 표준명·CONF-FOLD-1)
  - 4단대문접지 → **신규 PROC_000106**(MAX+1) / 반접지 → **신규 PROC_000107**(★2단접지 PROC_000059와 별개·CONF-FOLD-2)
  - 적재경로=catalog admin /tprocprocesses/add/·FK 위상 Phase A(코드 선등록)→Phase B(단가행 충전)
- ★2026-06-23 **라이브 COMMIT 완료**(인간 승인 후·되돌리지말것): PROC_000106(4단대문접지)·PROC_000107(반접지) 신규등록 + 4 comp proc_cd 충전(060/071/106/107)+use_dims 토큰. 사후검증 25,000→6,000 실증·verbatim 단가 0변경·멱등 no-op·undo 보유(`undo.sql`)·백업(`backup-20260623_012612.sql`)
- 잔여: PRD_000028 옵션그룹 0행(접지방식 UI 부재)=별 CPQ 트랙(dbm-cpq-option-mapping). 가격 데이터는 완료

### ★전 카탈로그 과대청구 8건 전부 라이브 COMMIT 완료 (2026-06-23·되돌리지말것)
- V2 접지카드 027/028/029 — 25,000→6,000 (PROC_000106/107 신규+proc_cd 충전)·`09_load/_overcharge_foldcard_260623/`
- V3 포토카드 024/025 — 14,500→6,000/8,500 (공식분리 PRF_PHOTOCARD_NORMAL/CLEAR·기존 FIXED use_yn=N)·`09_load/_overcharge_photocard_260623/`
- V1 명함 031/032/**033**·엽서북 094 — 명함 8,000→3,500/4,500·094 22,500→11,000/11,500 (print_opt_cd 충전 POPT_000001단면/002양면+use_dims 토큰)·`09_load/_overcharge_v1_260623/`. ★033도 공유 comp라 동시 해소
- 전부 단가 verbatim 불변·멱등·백업·undo 보유. ★print_opt_cd FK=t_prt_print_options(t_cod_base_codes 아님)·t_prc_price_formulas엔 del_yn 없음(논리비활성=use_yn=N)
- 돈 새는 면 전부 차단 완료. 미검증 4시트엔 과대청구 0(스캔 확인)

### 배치3 (2026-06-23) — sticker · acrylic · silsa — **Phase 1 권위 큐레이션 완료**
- [x] Phase 1 — prd_nm 라이브 1:1 실측(엑셀ID 부정확): 스티커16(052~067)·실사28(118~145)·아크릴21(146~166) = **65 라이브 prd**(엑셀 66·실사 투명포스터★ 1 미등록=CONFIRM)
- [x] checklist +845행(65×13축·전체 1,924 데이터행·중복 prd_cd 0). 산출=`authority-spec-batch3.md`·`domain-lens-batch3.md`·reuse-map §배치3
- ★바인딩 급상승: 45/65=69%(스티커16+실사28+아크릴1) vs 배치2 5/34 — §18 가격엔진 설계가 라이브 적재된 결과. **MISSING 20=아크릴 147~166 전부**(배치3 최대 리스크)
- 판별차원: 스티커=소재(점착종이)×사이즈×수량(단면=print_opt NULL 안전)·실사=소재별 1:1공식 × **면적매트릭스(siz_w/h)** 또는 사이즈티어(배너)·아크릴=소재(두께/색)×가공(부속물 BUNDLE)×조각수
- 과대청구 0 비준(스캔 재사용 + 판별차원 정합). ★실사 가공 단가행 proc_cd NULL·공유공식 4상품 동일성은 인스펙터 1택매칭 확인 권고
- CONFIRM +4: Q-SILSA-투명포스터(미등록)·Q-SILSA-SHARE(공유공식)·Q-ACR-MISSING20(고정가 vs 가공가산)·Q-ACR-부속물BUNDLE
- [x] Phase 2~4 **종단 완료·NO-GO**(2026-06-23): 인스펙터 팬아웃 → codex 교차(합의6·불일치0) → K1~K8 게이트
  - K1 PASS(845셀 빈0)·K2 PASS(BUNDLE4 비준)·K3 PASS(고아0 직접 재측정)·**K4 FAIL**·K5 PASS(G1=7000/G2=2000 오차0)·K6 BLOCKED(인증 3연속 stale)·K7 PASS(H1/H2 가설 라이브 기각)·K8 PASS
  - **★게이트 신규발굴(생성≠검증 입증)**: R-B3-2 격상=실사 면적그리드 A-사이즈 과대청구 확정. 인스펙터·codex가 놓친 **A1 +8,000**(594<600 off-grid) 독립 적발. A3/A2 +5,000. 4상품(118/120/121/123)×3프리셋. 근본=A3/A2/A1 고정가 프리셋행(7000/7000/12000) 미적재(사용자입력 ≥600 연속티어만 적재)
  - codex 가설 H1(스티커 tuple 중복)·H2(실사 formula_components 중복) 라이브 GROUP BY 재측정=전부 0 기각(double-count 없음)
  - 산출=`06_gate/{conformance-verdict,e2e-golden-trace,remediation-spec}-batch3.md`. 인간승인큐 top: ①R-B3-PRICE(돈크리·신규·verbatim) ②R-B3-1(아크릴20 차단·Q-ACR-MISSING20) ③R-B3-BUNDLE ④CPQ 클래스A(MM1/MM2/EXTRA)
  - 실 COMMIT 0(인간 승인 후 dbmap 위임). K6은 PW 갱신 후 누적 일괄 재실행 큐

### 배치4 (2026-06-23) — goods-pouch(굿즈파우치) — **종단 완료·CONDITIONAL GO**
- [x] Phase 1 — 라이브 1:1 실측(엑셀ID 부정확): 엑셀 103 distinct(레더라벨 중복 102) ↔ **라이브 98 prd**(PRD_000183~280 연속·del_yn=N). 폰케이스 5종(슬림하드/블랙젤리/임팩트젤하드/에어팟/버즈)=엑셀 "준비해야함"·라이브 미등록(C-GP-1). "메쉬 에코백"=메쉬에코백(PRD_000279 공백차) 매칭.
- [x] checklist +1,274행(98×13축·전체 **3,198 데이터행**·중복 prd_cd 0·빈셀 0). 산출=`authority-spec-batch4.md`·`domain-lens-batch4.md`·reuse-map §배치4
- ★**동형 7클래스 압축**: GP-1 단일고정가~52·GP-2-SIZE 사이즈등급~10·GP-2-VAR 용량/면~9·GP-PROC 가공8·GP-ADD 추가상품5·GP-COUNT 구수~6·GP-NOPRICE 가격부재5. ★**전부 고정가형**(면적매트릭스/규격티어/세트조합 0건·calc-draft row122~123 권위)
- ★**바인딩 0/98 = 전건 MISSING**(배치 최대 리스크·가격계산 불가). product_prices 0·product_price_formulas 0·옵션레이어 0·print_options 0. §18 design은 GP-1 product_prices INSERT·GP-2 formula 신설 처방 완비(미적재)
- 판별차원: GP-1=차원없음(안전)·GP-2-SIZE=[siz_cd]·GP-2-VAR=[opt_cd]·GP-PROC=가공 개당/×수량 가드. ★평탄화 금지(G-GP-3 M주문에 S가격)·PRODUCT_PRICE 선점 가드(G-GP-5 GP-2에 product_prices 1행=FORMULA 영영 우회)
- 과대청구 0(전 카탈로그 스캔 재사용·base 미적재라 발생 여지 0) — 단 적재 시점 판별차원 미충전하면 신규 발생 위험(인스펙터 적재명세 검증 시 강제점검)
- CONFIRM +5: C-GP-1 폰케이스5 미등록·C-GP-2 GP-NOPRICE5 가격부재(투명부채/미니CD앨범/극세사타월/타이벡북커버/말랑증사홀더)·C-GP-3 판형85 EXTRA(굿즈=전지없음)·C-GP-4 가공 개당vs×수량·C-GP-5 구수 가격축여부
- §18 `engine-design-goods-pouch.md`·`golden-cases-goods-pouch.md` 핵심 재사용(동형클래스·판별차원·가드 전부 계승·재조사 0)
- [x] Phase 2~4 **종단 완료·CONDITIONAL GO**(2026-06-23): 인스펙터 팬아웃 → codex 교차(합의6·신규1·가설2) → K1~K8
  - 인스펙터: basedata 784셀(MISSING240·자재MISMATCH76 오염·**판형EXTRA85**·도수MISSING98·돈크리0)·cpq-link 392셀(MISSING77·DEAD_LINK0·전CPQ테이블0행)·price-engine 98셀(**MISSING_BIND93**·NO_AUTHORITY5 권위공란·신규 ACR할인오귀속1)
  - codex: 가용·합의6·불일치0·신규발굴1(discount82 FK/del 무결성)·false-positive0·환각0
  - K1 PASS·K2 PASS(판형output NOT NULL=0 EXTRA확정)·K3 PASS·**K4 PASS**(formula0/pp0·discount5FK전건해소use_yn=Y정률)·K5 PASS(GC-GP2 base단절재현·할인verbatim오차0)·K6 BLOCKED(PW 5연속stale)·K7 PASS·K8 PASS → **CONDITIONAL GO**(K6만 미해소)
  - codex 게이트큐 4건 해소: ★자재"100%오염"기각(PRD_000230 `레더|L|M` 본체+옵션 공존→교정은 **행 단위**)·discount FK 전건 해소(유일결함=PRD_000203 DSC_ACR_QTY 오귀속)·단가행유일성=base0이라 적재명세 가드 G-GP-6 이월
  - 핵심결함: **바인딩0/98=견적0원**(D-GP4-BIND·최대). 인간승인큐 클래스A=R-GP4-1(GP-1 base적재·1순위)·R-GP4-2(ACR재바인딩)·R-GP4-3(판형정리)·R-GP4-4(자재 행단위 정규화)/클래스B=GP-2 FORMULA·가공·구수·CPQ77. NO_AUTHORITY5=결함아님(권위공란). 실 COMMIT 0
  - 산출=`06_gate/{conformance-verdict,e2e-golden-trace,remediation-spec}-batch4.md` + **★`conformance-final-summary.md`(전11시트 종합)**

## ★전 카탈로그 11시트 종단 완료 (2026-06-23)
- **누락 0 완주**: 3,198 데이터행·246 prd·16 그룹·빈 셀 0(`conformance-final-summary.md`)
- 시트별 verdict: 디지털·배치1·2·3 = **NO-GO**(라이브 적재 권위 미달=round-13 역전·검사 오류 아님)·배치4 = **CONDITIONAL GO**(K6만 BLOCKED)
- 과대청구 8건 전부 라이브 COMMIT 차단 완료(되돌리지말것)·미검증이던 4시트(sticker/acrylic/silsa/goods-pouch)는 종단 검증 결과 신규 과대청구 1건(배치3 실사 A-프리셋·게이트 적발·미적재상태라 미COMMIT)
- 생성≠검증 입증 누적: 배치2 094 양방향·배치3 실사 A1+8,000·배치4 자재100%오염 기각 등 게이트 독립 적발/정정
- 실 COMMIT 0(전 교정 인간 승인 후 dbmap 위임). 단가 verbatim 불변·기초코드 마스터 불변 원칙 준수

## 미해결/블로커
- **HUNI_ADMIN_PW stale** — K6 product-viewer 3원 대조 디지털+배치1 2연속 BLOCKED. 갱신 후 일괄 재실행.
- **CONFIRM 큐 6건** 인간 확정 대기 — 적재값이 여기 종속(Q-PB-SUPERSET·Q-CAL-PAGE-SHAPE·Q-CAL-PLATE-112·Q-CAL-PROC-EXTRA-110·Q-PB-SETPRICE류·B-N4 반제품 고객노출)
- **인스펙터 미세 정정**: basedata "109 공정=0행"은 실측 수축포장 1행(본질 불변·문구만)

## 진행 현황 (2026-06-22~23)
- ★**전 11/11 시트 종단 완료**: 디지털인쇄(파일럿)+배치1+배치2+배치3(=NO-GO)·배치4(=CONDITIONAL GO). checklist 3,198 데이터행·246 prd·빈 셀 0.
- 검증·교정명세까지 완료. 실 COMMIT 0(전 교정 인간 승인 후 dbmap 위임).

## 다음 세션 시작점 (검증 단계 종료 → 교정 실행 단계)
전 카탈로그 종단 정합 검증 완료. 다음은 **인간 승인 후 교정 실행**(검증 아님):
1. **HUNI_ADMIN_PW 갱신** → K6 product-viewer 3원 대조를 전 5배치 누적 일괄 재실행(현재 유일 미해소 게이트·5연속 stale).
2. **교정 실행 우선순위(인간 승인 큐)**: ★배치4 R-GP4-1(굿즈 GP-1 base 적재=98상품 견적0 해소·최대 임팩트) → 배치3 R-B3-PRICE(실사 A-프리셋 과대청구) → 배치3 R-B3-1(아크릴20 미바인딩) → 배치1·2 잔여(094 보류·DL5 등). 전부 dbmap(`dbm-load-execution`/`dbm-axis-staged-load`) 위임·단가 verbatim 불변·기초코드 마스터 불변.
3. **CONFIRM 큐** 인간 확정(굿즈 NO_AUTHORITY5 권위 공란·가공 개당vs1회·구수 가격축 등).
권위 종합=`06_gate/conformance-final-summary.md`. 시트별 verdict·누적 인간승인큐·누락0 커버리지 수록.
