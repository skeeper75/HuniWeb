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

## 미해결/블로커
- **HUNI_ADMIN_PW stale** — K6 product-viewer 3원 대조 디지털+배치1 2연속 BLOCKED. 갱신 후 일괄 재실행.
- **CONFIRM 큐 6건** 인간 확정 대기 — 적재값이 여기 종속(Q-PB-SUPERSET·Q-CAL-PAGE-SHAPE·Q-CAL-PLATE-112·Q-CAL-PROC-EXTRA-110·Q-PB-SETPRICE류·B-N4 반제품 고객노출)
- **인스펙터 미세 정정**: basedata "109 공정=0행"은 실측 수축포장 1행(본질 불변·문구만)

## 진행 현황 (2026-06-22~23)
- 완료: 디지털인쇄(파일럿) + 배치1(3시트) + 배치2(3시트) = **7/11 시트**
- 남은 4시트: sticker(16)·acrylic(21)·silsa(29) = 배치3 / goods-pouch(103) = 배치4(단독·대형)

## 다음 세션 시작점
배치3 = sticker·acrylic·silsa(66상품, 배치2보다 큼·+50~80k 예상). 이 트래커 + 06_gate(배치1·2 섹션) 읽고 동형 파이프라인 재개. goods-pouch(103)는 단독 배치4로 분리(대형). ★HUNI_ADMIN_PW 갱신되면 K6 product-viewer 3원 대조를 디지털+배치1+배치2 누적 일괄 재실행(축귀속 CONFIRM 다수 종속).
