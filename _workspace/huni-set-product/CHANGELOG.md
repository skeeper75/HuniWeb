# Huni-Set-Product 하네스 CHANGELOG

셋트상품(부품조립형) 구성·설계·라이브 적재 하네스(§23). 최신이 위.

---

## 2026-06-25 — W1-2 좀비 배선 정리 종단 완주(라이브 COMMIT 4+9건) + rev2 전체 재검토 + codex 교차

### 좀비 배선(삭제 자재가 활성 상품에 BOM 배선) 교정
- **정의**: `t_mat_materials.del_yn='Y'`(논리삭제) 자재가 `t_prd_product_materials.del_yn='N'`(활성) 상품에 BOM 배선됨. baseline 92건 → W1-1/W1-3 COMMIT 후 **87 재집계**.
- **dbm-correctness-auditor 1차**(disposition.csv): ★전 87 자재 component_prices 단가행 0 → 어떤 처분도 **돈영향 0원**. REWIRE 2 / REVIVE 2 / BLOCKED 83.
- **확정 4건 COMMIT**(`_exec/`·되돌리지말것): REWIRE 260→정본250·270→정본343(동일명, 충돌 0=8행 정상 재지정) + REVIVE 008레더(23배선)·261무지내지(4배선). 좀비 **87→83**(wires 175→140)·PK중복0·FK고아0·돈불변·백업 `bak_*_zombiewire_20260625_053924`·undo.

### ★BLOCKED 83 전체 재검토(rev2) — 회의적 재검토가 숨은 REVIVE 9건 적발
- **dbm-correctness-auditor rev2**(disposition-rev2.csv): 1차 76/83 변경. **BLOCKED→REVIVE 9 / BLOCKED→OPTIONIZE 67 / BLOCKED 유지 7**.
- **핵심 적발**: 1차 "옵션화 의존 BLOCKED"로 미룬 것 중 **8건이 사실 REVIVE 대상** — 활성 `option_items.ref_dim_cd='OPT_REF_DIM.03'`가 이 좀비 mat_cd를 ref_key1로 직접 참조 중인데 자재만 삭제됨=**옵션 참조 무결성 깨짐**. 현수막 추가물 5(양면테입069·끈070·큐방337·각목338·봉제사340·RC-2 자재축 누락)·투명커버마감 2(244·245)·유포지154 + 무광75mm262(거울 본체·정본부재)=REVIVE 9. OPTIONIZE 67(.09 라벨62·.08 색5)은 opt_item ref 0=옵션화 미완→부활 금지.
- **codex 독립 2차 교차검증**(codex-reconcile.md·gpt-5.5 high): rev2 **81/83 합의(97.6%)**·신규 적발 0·환각 0. 4대 적발 독립 재현=공유 맹점 낮음. 불일치 2(262·214)=돈0 BLOCKED 경계 보수성. **codex 보강**: 홀로그램/골드/실버/글리터류는 단순 색 라벨이 아닌 특수 원단·필름 가능성→W2 옵션화 시 소재/효과축 분리 검토(역방향 false-positive 가드).

### ZR-1 REVIVE 9건 COMMIT (인간 승인 "지금 실행")
- **COMMIT**(`_exec/zr1-*`·되돌리지말것): 9건 del_yn 'Y'→'N' 부활. 좀비 **83→74**(wires 140→128)·**깨진 옵션 참조 11→0 무결성 복구**·돈불변(단가행0)·멱등·백업 `bak_t_mat_materials_zr1revive_20260625_055716`(9행)·zr1-undo.sql.
- DRY-RUN 전항목 PASS(83→74·11→0·delta0·롤백 후 83 원상)·사후 재실측 PASS.
- ★메인 세션 직접 실행(실행기 서브에이전트가 조정자 전달 승인을 본인 승인으로 인정 거부=교착 → 사용자 본인 AskUserQuestion "지금 실행" 승인을 보유한 메인이 직접 안전 프로토콜 완주).

### 좀비 배선 트랙 마감 상태
- **처분: 13건 COMMIT(4+9) · OPTIONIZE 67→W2 · BLOCKED 7+돈변동 2(투명아크릴192 두께·유포지154→153 REWIRE)→실무진 확인큐.** 좀비 배선 92→**74 자재**(전부 OPTIONIZE/BLOCKED·REVIVE/REWIRE 대상 0=정합 결함 종결, 잔여는 옵션화/확인 트랙 의존).

### W2 CPQ 옵션화 1차 — 고신뢰 9그룹 라이브 COMMIT (자재→옵션값 전환)
- **설계**(dbm-option-mapper·`07_prereq/w2-optionize/`): 자재로 (오)등록된 색/투명도 변형을 §7 CPQ L2(polymorphic `OPT_REF_DIM.03`·ref_key1=mat_cd·ref_key2=usage_cd)로 옵션화. 3트랙=T1 면지(4종·책자4)·T2 굿즈 PET(투명도)·T3 OPTIONIZE 67.
- **★T3 정제**: 67건 일괄 옵션화 불가 — 다수가 해당 상품에 siz/print_options **차원행 0**이라 option_item 생성 시 트리거 거부 = **BLOCKED-needs-L1**(차원 선적재 선행·dbm-axis-staged-load 라우팅). 즉시 가능분은 색/투명도만.
- **codex 독립 2차**(w2-codex-reconcile.md·gpt-5.5 high): 합의 5·환각 0. **★머그컵(T2) HOLD 적발** — 같은 USAGE.07 4자재 중 2종만 "투명도"로 뽑은 분류 근거 불명·라이브 dflt/disp_seq 무차별로 구분 불가→상품마스터 재큐레이션+실무진 컨펌. N1(트리거 del_yn 미필터)→게이트 `del_yn='N'` 보완 내장. 링/D링 명세누락→CONFIRM 큐.
- **COMMIT**(`_exec/w2-*`·되돌리지말것): 고신뢰 **9 option_group / 29 option / 29 option_item**(T1 면지 4 + T3 즉시 5: PRD_072·077·082·088 면지색 / 140·142·197·198 색상 / 217 잉크7색). 채번 OPT_000064~072·OPV_000434~462(MAX+1 연속). 트리거 실 INSERT 통과 29/29·옵션 ref 활성자재 해소 29/29·FK고아0·멱등(ON CONFLICT DO NOTHING)·**돈영향 0**(단가행0). 백업 `bak_*_w2opt_20260624215218` 3종·w2-undo.sql. DRY-RUN 6검증 PASS·사후 재실측 PASS.
- **신규 mint = option layer만**(차원/자재/상품 신규 0·search-before-mint). 면지 disp_seq 권위=상품마스터 화이트→블랙→그레이→인쇄.
- **보류분**(w2-deferred.md): 머그컵 1그룹·BLOCKED-needs-L1 ~36(dbm-axis-staged-load)·CONFIRM ~30(소재효과축 홀로그램/골드/실버/글리터=실무진·구수=ref_param_json DDL·복합축=자재 정규화·단독배선·링/D링).

### ★셋트 가격 적재 착수 — 097 떡메모지 가격공식 바인딩 라이브 COMMIT
- **준비도 평가**(06_load/price-mint-readiness.md): 적재 대상 5건 중 **097만 READY**. ★권위 정정 — set-price-authority는 097을 "미바인딩·PRF 신설 필요"로 봤으나 **round-16(dbmap)이 PRF_TTEOKME_FIXED·COMP_TTEOKME·112 단가행·formula_components 전부 적재 완료**, 유일 단절=097 바인딩 0행. 신규 mint 0·선행의존 0.
- **072·077·082(책자 원자합산형)·100(포토북)=BLOCKED**: PRF·comp·단가·배선 전부 신규 민팅 + 선행 W1/W2(책자 제본비). 088=진성 미정(권위 "보류중"·실무진).
- **097 파일럿 종단 검증**: 게이트(S1~S7 FAIL0·evaluate_set_price 독립 손계산 골든 **60,000**[90x90/50장/30권]·**19,200**[70x120/100장/6권] 정확·이중합산0·bdl_qty∈NON_QTY_DIMS pricing.py:43·DRY-RUN 멱등) + codex(GO·6/6 합의·divergence0·환각0) **이중 GO**.
- **COMMIT**(`06_load/price-pilot-tteokme/`·되돌리지말것): t_prd_product_price_formulas 1행 INSERT(PRD_000097→PRF_TTEOKME_FIXED·apply_bgn_ymd=2026-06-01·PK=(prd_cd,apply_bgn_ymd)·ON CONFLICT 멱등). 바인딩 77→78·신규 mint 0·돈영향 현재 0(떡메 견적 올바르게 ON). 백업 `bak_*_tteokme_20260625_153807`·undo.sql. CFM-097(apply_bgn_ymd) 라이브 3중 정합 해소.
- **진행 중**: 072 하드커버책자(원자합산형 6비목) 민팅 종단 설계 착수(077/082 전파 기준·verbatim 단가 추출·선행 W1/W2 평가).

---

## 2026-06-24 — 하네스 초기 구성 + 엽서북 파일럿 종단 완주(라이브 COMMIT)

### 하네스 구성
- 6 에이전트(`hsp-authority-curator`∥`hsp-domain-researcher` 기준점 → `hsp-set-designer` 설계 → `hsp-codex-verifier` codex 독립 2차 → `hsp-set-gate` S1~S7 → `hsp-load-executor` 안전 적재) + 5 스킬(+ dbm-load-execution·hqv-codex-cross-verify·hpe-competitor-benchmark·rpm-live-reverse 재사용).
- 하이브리드 파이프라인. 생성≠검증·codex 주장=가설·search-before-mint·권위(상품마스터 260610) 절대·라이브 읽기전용(적재 Phase 5만 인간 승인 후 COMMIT).

### 사용자 확정 directive (Phase 0~1 충돌 해소)
- **셋트 = 부품조립형**: 셋트 완제품(prd_cd) ← 반제품 구성원(sub_prd_cd), `t_prd_product_sets`.
- **상품유형**: 기성·디자인 제외·완제품=단일 제조상품·반제품=구성원. 단 **셋트 부모는 01완제품으로 교정**(라이브 7셋트가 04디자인이었음 — directive 충돌→완제품 교정 결정).
- **작업 성격**: 기존 7셋트 보정+확장(빈 테이블 아님 — 라이브 28행/7셋트 실재 확정. 사전탐색 "0 vs 28" 충돌=28 확정).
- **가격**: 가격공식 있는 엽서북 먼저 종단 완주.
- **★면지 자재 정규화**: 자재의 화이트/그레이/인쇄/블랙면지(MAT_000001~004)는 용도성 오등록 → 삭제·출력소재(종이) 귀속·용도(면지)는 상품뷰어 자재추가 용도축 분리.

### 엽서북(PRD_000094) 파일럿 — GO(CONDITIONAL) → 라이브 COMMIT
- **적재 3 DML**(멱등·신규 mint 0): ① t_prd_products 유형 04→01 ② (94,95) 내지 min/max/incr=20/30/10 충전 ③ (94,96) 표지 disp_seq 보정.
- **S1~S7 전부 PASS**. S4 evaluate_set_price 재계산 = **450,000원**(20P·단면·100부)·PRICE≠0·이중합산 0.
- 백업 `bak_*_setbuild_20260624_0600`·undo 보유·사후검증 6항목 PASS·가격사슬 무손상.
- **★생성≠검증 실효 입증**: 설계·codex 모두 "30P 견적불가(comp 부재)"라 진단 → 게이트 라이브 실측이 "30P comp/단가행 실재하나 미바인딩 → 20P 단가로 **과소청구**(돈결함)"로 정정. 부재가 아니라 오청구·교정경로 정반대.
- codex AVAILABLE(gpt-5.5 high)·R-1~R-4 CLOSED(R-3 codex false-positive 기각).

### 라이브 t_prd_product_sets 실스키마 정정
- `semi_role_cd` 컬럼 **부재**(reuse-map "있음" 주장이 틀림) — 역할은 note로 표현. 적재본은 실스키마 컬럼만 사용.

### 미해결 / BLOCKED 라우팅 (인간 승인·별도 트랙)
- **RM-1 [돈결함]**: 30P 미바인딩 과소청구 → §18/dbmap 가격 트랙(30P comp 배선+페이지 차원 도입·신규 단가 생성 아님).
- **RM-2**: 면지 자재 4종 재배선(하드커버/링책자 PRD_000072/077/082/088·엽서북 N/A) → dbmap/basecode.
- **RM-3**: 나머지 6셋트(04디자인) 유형정책 확인 → 확장 phase.

### 동형 전파 2차 — 남은 6셋트 구조 보정 라이브 COMMIT (같은 날)
- 대상=하드커버책자(072)·레더 하드커버(077)·하드커버 링(082)·레더 링바인더(088)·떡메(097)·포토북(100).
- **적재 32 DML**: 6 UPDATE(유형 04→01·RM-3 정책=완제품 확정 해소) + 26 UPSERT(disp_seq 단조·note). min/max/incr는 **NULL 유지**(권위 침묵·내지 member 부재=MES별도설정·RM-4). 백업 `bak_*_setbuild_ext_20260624_0651`·되돌리지말것·사후검증 5 PASS·멱등 fingerprint 동일.
- **S1~S7 GO·codex AVAILABLE·D1~D5 CLOSED**. D1(유형 권위)=게이트가 094 선례+admin.py:1095(디자인 셋트부모 허용·반제품만 제외)+라이브 PRD_TYPE.04 셋트부모=정확히 이 6개뿐(타 영향0)으로 해소.
- **★택1 면지 합산0 재확인**: 면지/표지 평면 다중행(072 면지3·082/088 면지4·100 표지5)이 공식0·차원0이라 현재 합산 오염 0(행 보존이 정답). GUARD-1=가격 신설 시 평면합산 즉시 과대청구 → §18 가격설계서 옵션축 모델링 필수.
- **6셋트 전부 BLOCKED-PRICE(엽서북과 다름)**: 셋트공식·구성원공식 **진성 부재** → PRICE=0 견적불가(엽서북 30P "미바인딩 오청구"보다 무거움). §18 셋트 제본/조립 공식 신설 라우팅.

### 현재 상태 (7/7 셋트 구조 보정 완료)
- 7 셋트 부모 유형 전부 01완제품 교정·disp_seq 정규화 라이브 반영. 엽서북만 가격 견적 가능(20P·450,000원), 나머지 6셋트는 가격공식 부재로 견적불가.

### ★하네스 진화 + 권위 재큐레이션 (계산공식집 시트 누락 적발·같은 날)
- **누락 적발(사용자)**: Phase 1 큐레이터가 booklet-l1(구성)만 보고 상품마스터 **"계산공식집" 시트**(`calc-formula-draft-l1.csv`)를 안 봄 → "6셋트 셋트공식 진성 부재 → §18 신설"이 **오프레이밍**. 실제 권위엔 공식 명시 존재.
- **하네스 보완**: hsp-authority-curator/curation·hsp-set-gate(S4)·orchestrator에 **계산공식집 시트 필수화 + BLOCKED-PRICE "2층 구분"**(권위 공식 존재+라이브 미적재=적재 대상 vs 진성 부재=신설) 강제.
- **권위 재큐레이션 결과**(set-price-authority.md): 7셋트 권위 공식 추출 — 원자합산형(072/077 하드커버무선 6비목·082/088 하드커버링 8비목·표지/면지×2)·고정가형(094/097 `(가격포함)`)·통합형(100 포토북). **§18 PRF_BIND_* 대조 일치 6/7·갭 0**.
- **2층 재분류**: 적재 대상(전사) **5건**(072·077·082·097·100) · 적재됨(결함) **1건**(094 엽서북 silent 이중합산+prc_typ×qty §18 R-3) · 진성 미정 **1건**(088 권위 보류중) · **진성 부재 0건**. CONFIRM-3(포토북) 해소.
- 단 §18 설계 PRF(PRF_HC_MUSEON_SUM 등)는 **라이브 미민팅(설계 제안 단계)** — 라이브엔 PRF_BIND_SUM(stale)·PRF_PCB_FIXED(094)만.

### ★자재 기초데이터 총점검 + W1 계층 부활 라이브 COMMIT (가격 적재 선행조건·같은 날)
- **사용자 directive**: 가격 적재 전 자재 정합 라이브 확인. 자재=실 재고품만·출력소재는 상위자재→자재 계층·면지/내지/표지=용도(자재 아님)·상품마스터 적재 원칙 반영 여부.
- **전수 총점검**(07_prereq/full-audit): t_mat_materials 343(활성194/삭제149). 출력소재 110 중 **종이 family root 9 전멸→고아64**. 비출력 활성96% 정당 stock·오염8. ★진짜 위기="논리삭제 정합 붕괴"(고아64+좀비배선92+좀비가격행2 돈영향). **그릇 합격·데이터 불합격**(상품마스터 적재가 자재 vs 용도 원칙 미반영).
- **결정**: 면지=색상 택1 CPQ 옵션화(자재 4종 정리·인쇄면지만 실 stock 유지). 상위자재 13 del_yn=Y=오류→부활. 자재 교정 먼저(돈 제외).
- **W1 계층 부활 COMMIT**(07_prereq/remediation/_exec·되돌리지말것): 종이 root 9+전용지=**10행 del_yn Y→N**·자식41 계층복구·**FK 고아 64→23**·돈0·멱등·백업 bak_*_w1_20260624_1137·undo 보유. ★dbm-validator가 설계의 "전 9root 부작용없음" 오단언 적발(생성≠검증)=투명/반투명 PET 굿즈 USAGE.07 오배선. 굿즈 PET=**CONFIRM 분리**(상품마스터가 투명/반투명을 머그컵/키링 정당 선택옵션 등재→스퓨리어스 아님·올바른 굿즈 투명자재 부재→면지 동형 CPQ 옵션 트랙·추측 COMMIT 거부).

### ★좀비 가격행 판정 + 부활 COMMIT (돈크리티컬·같은 날)
- dbm-price-arbiter 전수 판정(07_prereq/zombie-price): MAT_000159 모조120g(단가행20=봉투 COMP_ENV_MAKING)·MAT_000119 리브스250g(단가행1=COMP_PAPER) **둘 다 고유·유효**(원 의심 159=073 동일물 기각·073 봉투가격행0=병합슬롯 부재). 21 단가행 중복0·전부 분할.
- ★결정적: `pricing.py:259 _component_rows`가 comp_cd만 필터·**자재 del_yn JOIN 없음** → 삭제 자재도 단가가 견적 도달=**현행 라이브 이미 좀비 단가로 청구 중**. 단순 삭제 정리했으면 봉투 0원/전단지 저청구 돈결함 유발(함정 회피).
- **부활 COMMIT**(07_prereq/zombie-price/_exec·되돌리지말것): 159·119 del_yn Y→N **2 UPDATE**·단가행/배선 0변경·**견적 골든 diff=0**(봉투 96,000/672,000·전단지 500/판 전후 동일=청구 불변)·백업 bak_*_zombie_20260624_1250·undo. 권고2(죽은 119 배선)·CONFIRM(159=073 통합·119 root) 제외.

### 다음 시작점 (정정 2026-06-25 W2 1차 후)
**자재 W1(종이 계층)+좀비 가격행+좀비 배선(4+9건)+W2 1차(9그룹/29옵션) COMMIT 완료.** 자재 잔여: ① **W2 보류분 처리** — 머그컵(실무진 컨펌)·BLOCKED-needs-L1 ~36(dbm-axis-staged-load로 siz/print_options 차원 선적재 후 옵션화)·CONFIRM ~30(소재효과축 홀로그램/골드/실버/글리터=실무진·구수 ref_param_json DDL·복합축 자재정규화·링/D링) ② **돈변동 2건 실무진 확인큐**(투명아크릴192 정본 두께 1.5/3mm·유포지154→정본153 REWIRE 돈변동) ③ 31 NO_ROOT·비종이 root 4 CONFIRM ④ 권고2 죽은 119 배선·CONFIRM 159=073 통합. **그 후 가격 적재**: 적재 대상 5셋트 §18 PRF→t_prc_* 민팅+바인딩 ·097 고정가 신설 ·094 결함 교정(이중합산+prc_typ×qty·30P) ·088 실무진. 권위·설계 갖춰짐(신설 아닌 적재). ★자재 논리삭제 결함(고아·좀비가격·좀비배선) 3건 종결 + 핵심 색/면지 옵션화 1차 완료 → 셋트 가격 적재 선행조건 실질 충족(잔여는 옵션 확장·실무진 컨펌 의존).
