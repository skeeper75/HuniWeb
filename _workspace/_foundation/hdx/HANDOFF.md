# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 (2026-07-05·후속) — 권위 재고정+스캐너 정밀화+수량정합 세션

**★이번 세션 성과(4커밋·라이브 무변경)**:
1. **권위 재고정 260702→260703(상품마스터)/260705(가격표)**: extract 러너 신설
   (`run_extract_master_260703.py`·`run_extract_price_260705.py`)·산출 `24_master-extract-260703`·
   `24_price-extract-260705`·버전상수 8파일·브리지 재빌드=불변(253·EXACT 234). **델타 6건 신규 돈크리티컬 0**
   (레더링바인더A4 9000 미적재만·엽서북 수량1신설=가격중립·MAP만년스탬프=기존addon·굿즈사이즈3·디캘축제거).
2. **스캐너 정밀화(contribution_scan.py)** — ★needs_design "저청구 16" 파일럿 판별 결과 **오시/미싱/6단접지=오탐**
   (배선·과금 완비). ⓐ**proc_grp 흡수**(comp_cover 분리·오시/미싱 오탐 8건·A/B검증 부작용0) ⓑ**활성 상품 필터**
   (지니 지적: 죽은 상품 17개 REVIEW 34건 오염→제거·HIGH 불변). UNCOVERED HIGH 15→7(6단접지 미반영시)→실질 5.
   ★HANDOFF [HARD] 실증: 무작정 §18 설계 시 이중과금 → "채우기 전 판별"이 스캐너 정밀화로 귀결.
3. **6단접지 잔존오탐 교정 SQL**(`remediate/fold6cr-procgrp/`) — COMP_FOLD_CARD_6CR use_dims += proc_grp
   (오시/미싱과 동일패턴 데이터 일관성·가격중립[엔진 proc_grp 미사용]·overlay 확증 HIGH 7→5). **인간+webadmin 게이트 대기**.
4. **수량·최소주문수량 정합 진단**(`board/qty-minqty-conformance/`) — 지니 원칙: **가격표 시작수량=최소주문수량**.
   엔진=min_qty floor tier·ERR_BELOW_MIN. 저청구=옵션comp(박) 시작수량>상품min. 완제품가형: OK39·**저청구2**
   (미니보드/배너 min1<완제품가시작4)·검토11(반칼스티커/수첩 min>시작1·권위대조 필요).

**다음 택일(진짜 저청구 교정·전부 인간+webadmin 게이트)**:
**(a) 라이브 COMMIT 대기분**: ① 6단접지 fold6cr-procgrp/02-fix.sql ② 미니보드/배너 min_qty 1→4.
**(b) 진짜 저청구 5건 webadmin 확증→§18/§7**: 타공(엽서/벽걸이캘린더·단 걸이구멍 제본가 baked 확인)·
  UV평판(아크릴키링)·도장인쇄(만년스탬프)·전사인쇄(폰스트랩).
**(c) 미해결 백로그**: 원자합산형(엽서/쿠폰) 수량정합(판수↔장수 환산)·완제품가형 검토11 권위대조·
  명함 박 저청구(박200>min100 TRAP)·레더링바인더A4 적재.

**[HARD] 교훈(추가)**: ①"저청구로 보이는 것이 스캐너 오탐(공정코드 이원화·proc_grp 미선언)일 수 있다".
②진단 스크립트는 상품 del_yn=Y·use_yn=N·comp use_yn=N 을 **반드시 필터**(미필터=죽은 상품 오염).
③완제품가형=완제품가 시작수량이 최소주문수량 권위·원자합산형=인쇄비 판수기준이라 장수 min과 차원 다름.

---

## 다음 시작점 (2026-07-05) — 진짜 결함 교정 착수 or 스캐너 정밀화

**★이번 세션 대약진**: 실무진 webadmin 배선 끊김을 **최신 상품마스터·인쇄상품 가격표(둘 다 260702)**와
대조해 전수 진단·검증·교정하는 배치 목표. **발견=이 일의 ~85%가 이미 hdx에 존재** → 새로 안 짜고 hdx
확장(search-before-mint). **371 결함이 겁났으나 재프레이밍 = 진짜 돈크리티컬 ~40상품, 나머지 오탐/사람판정 대기.**

**완료(생성/진단만·라이브 DB 무변경)**:
1. **권위 260702 재고정**: L1 재추출 `huni-dbmap/24_master-extract-260702/`·`24_price-extract-260702/`
   (러너 `huni-dbmap/_scripts/run_extract_master_260702.py`·`run_extract_price_260702.py`). 버전 상수 6곳
   (260610/260527→260702) 교체: registration_check.py·build_prd_nm_bridge.py·registration_check_pilot.py·
   §26 run_all.py·grid_diff.py·pansu_basis_audit.py. prd_nm 집합 불변(249=249) 검증.
2. **prd_nm→prd_cd 브리지**: `board/prd_nm_bridge.csv`·`build_prd_nm_bridge.py`·`prd_nm_bridge-summary.md`.
   253상품·EXACT 234(92%)·needs_human 20(AMBIGUOUS 13·UNMATCHED 5·DOMAIN_INFERRED 1·del 1). 엑셀 권위 절대·
   후니 이전사이트 보강·레드 보조.
3. **4축 통합 `--scope all`**: Linkage + PriceGrid(§26 어댑터) + **Registration(신규 Diagnoser 편입·브리지 조인·
   전 11시트)** + Contribution. 신규 `diagnose/registration_dx.py`·`remediate/registration_rmd.py`·`all_selftest.py`.
   드리프트0 셀프테스트 8/8·독립검증 GO. 첫 실산출 371→(엽서북 해소 후)370.
4. **권위 이해 문서**: `huni-price-table-integrity/25_price-sheet-understanding-260702/`(INDEX+A/B/C/D).
   [핵심] 값의미 규칙 = .01단가(수량↑값↓)/.02총액·합가(수량↑값↑)·판별=제목 "(단가)/(합가)" 라벨+수량방향.
   시트 3분류=본체/추가가격/기반. blind spot 등기부 11항.
5. **진단 도구 오탐 대거 정리**:
   - 엽서북 468 거짓 missing = component-merge tombstone(grid_diff config가 del_yn=Y 옛 comp 겨냥) → `COMP_PCB`로
     갱신, 468/468 값일치 해소.
   - 명함포토카드 103/105 값일치 해소(grid_diff+matrix_parse+run_all에 namecard config 추가·UNMAPPED→DIFFED).
     잔여: 금유광 qty1000 2셀 진짜불일치(권위63000 vs 라이브64000·권위 오타의심) + 펄/프리미엄 8셀 미상
     (note 부재·값집합 일치·소재그룹↔mat_cd 확정 필요).
   - 스티커 결정론 매핑 불가(COMP_STK_PRINT 6498행 6개 관례층 혼재·중간교정)·config 미변경(정직 보류).
   - 공정 278 트리아지: 진짜 저청구 ~5근본원인(오시·미싱·타공·책자내지 디지털인쇄·접지)/상품~20(=플랜 needs_design
     16)·나머지~210 오탐(BAKED 98·옵션경로~100·UNCOVERED+MISMATCH+ORPHAN 3중계상).

**다음 택일**:
**(a) 진짜 결함 교정 착수**(인간 승인+webadmin 게이트): needs_design 16상품 §18 · 배선 값누락 proc/opt/siz/mat §7
  · 명함 FOIL 판정.
**(b) 스캐너 정밀화**(오탐 자동 감소): BAKED 제외 · 옵션경로 크로스체크 · 3중계상 병합.

**미해결(사람 판정 대기)**: ①명함 금유광 qty1000 63000 vs 64000(권위 오타?) ②명함 펄/프리미엄 소재그룹↔mat_cd
③스티커 캐노니컬 관례층 선정 ④브리지 20건(AMBIGUOUS/UNMATCHED) ⑤판수 이중권위(판걸이수 vs 상품마스터·
예전사이트 실청구 tiebreaker 대기) ⑥ceiling 규칙·박 등급 boundaries(권위 미명문).

**건드리지 말 것(이번 세션)**: 엽서북 config(`COMP_PCB`) 해소됨·라이브 DB 무변경(교정=인간+webadmin)·값 날조 금지.

**[HARD] 교훈**: "미적재"로 보이는 것이 진단 도구 드리프트/포맷 미매칭일 수 있다 → 채우기 전 "라이브에 정말 없나
vs 도구가 못찾나" 판별 필수. 값의미(.01/.02/합가) 시트·블록 단위 선확정. 사용자 위험 감지가 money-critical
자동채우기 중단시킴(오탐/진짜 판별 우선).

---

## 다음 시작점 (직전 260704) — 등록 점검표 REVIEW 잔여(신규 템플릿 mint) · 전 시트 확장

**★260704~05 대약진**: 등록 점검표(권위 엑셀↔DB 등록 대조)로 **키링류 저청구 7상품 라이브 교정 완료**.
지니 재설정 확정 = **needs_authority 는 실무진 대기 아님**(엑셀=권위값·webadmin 설계=Claude·값 읽어 매핑
= 날조 아님) + **진단→교정여부 제시→별말없으면 승인 처리**(default-approve·검증체인 유지).
상세 워크플로 = 메모리 [[hdx-remediation-authority-workflow-260704]].

**★webadmin 실화면이 오진단 자기교정 실증**: 아크릴키링 첫 접근(opt_cd 재키잉) → 라이브 sim 이 진짜 버그
규명(고리=base 자재 오모델→선택 시 상품 전체 0원) → **addon 방식으로 전환**(삭제 템플릿 복원+오모델 자재
제거). [HARD] webadmin 확인이 잘못된 COMMIT 막음(생성≠검증). 기록 `COMMITTED-260704-acryl-keyring-addon.md`.

**이번 세션 라이브 교정(7상품·HIGH 4→0·보드 18→11·백업/undo 전부 보유)**:
- 아크릴키링 고리3(은1100/금1200/구슬줄300) + 뱃지·스마트톡·명찰 부속6 = **템플릿 복원+오모델 자재 제거**
  (`remediate/acryl-keyring-addon/`·`acryl-accessories-addon/`).
- 포카키링·엽서캘린더·탁상형캘린더 = **addon 링크만 추가**(오모델 아님·`acryl-review-addonlink/`).

**다음 택일**:
**① REVIEW 잔여 11건 — 신규 템플릿 mint**(정가표 값·설계 판단): 캔버스 라벨부착 300(×6)·임팩트 맥세이프
  6500·아크릴쉐이커 스탠드 1400 = 상품악세사리 정가표에 값 있으나 템플릿 없음 → mint+링크. base 미가격
  말랑증사홀더(공식·자재·단가 전무)는 설계 선행. 실사 메쉬배너 거치대·아크릴볼펜 블랙 = 조사.
**② 등록 점검표 전 시트 확장**: 현재 인라인 유료옵션 5시트(아크릴·캘린더·디자인캘린더·실사·굿즈파우치).
  `board/registration_check.py` `SHEETS` config 에 형식가격 시트(디지털·스티커·책자·문구·포토북) 추가.
**③ 가격 스코프(기존·별개 축)**: `--scope price --loop` 416건 진단(9차원)·auto_data 0(값날조금지). 실무진
  액션 대기(메쉬배너 타공·수량함정 8상품·출력소재 30셀). 지니 재설정으로 이제 엑셀 값 읽어 교정 가능.

---
### (참고) 가격 파일럿 완성 상태 — 진단 9차원 전 커버
파이프라인 골격 성숙 — 한 명령(`--loop`)으로 진단→교정생성→재실측→라운드 종합. 아래는 선택적:

**① codex 2차(선택·설계 §6)**: `hdx/verify/codex_gate.py` 신규 — `codex exec -s read-only` 로 auto_data
교정본을 독립 판정·reconcile(`hpe-codex-validate` 로직 훅화). 미가용 시 "Claude 단독" 폴백. **현재 auto_data 0
이면 NO-OP** → auto_data 재등장(새 UNDECLARED 등) 시 유효. 우선순위 낮음.

**② 실무진 액션(배치 적발 저청구·needs_authority)** — 배치가 찾은 실제 돈 결함, 실무진 값 확인 후 채움:
  - (a) 메쉬배너(PRD_000137) 타공 옵션 OPV_000542 dtl_opt 누락(OptionCpqDx) — 형제 PRD_000139={타공수:4/6/8}
  - (b) 수량 함정 TRAP_MIN 8상품(2/3단접지카드·프리미엄/펄명함·무선/PUR책자·미니보드/배너·QtyRuleDx)
  - (c) 출력소재 specialty 용지 30셀 미적재(PriceGridDx→§26/§7 dbmap)
  값 확보 후 §7 적재→`snapshot.sh` 재생성→`--loop --round N` 재실행으로 결함 감소 확인.

**③ 새 도메인 확장(선택)**: 가격 외 도메인(예 셋트·제약규칙·카탈로그 정합)으로 `--scope` 확장 시 동형 패턴
  (Diagnoser/Remediator 어댑트). 현재 `SCOPES={"price":...}` 한 스코프만.

**주의(재시작 시)**: 스냅샷 신선도 먼저 확인 — `db-check.sh` 후 필요시 `snapshot.sh` 재생성(H-1 드리프트).
PriceGridDx 는 §26 배치를 호출하며 §26 dir 에 `ALL-SHEETS-defects.csv` 등 산출(§26 소유·재생성물·hdx 커밋 대상 아님).

## 완료 (직전 세션·P2~P5-②c 종단)
- **P5-②c PriceGridDx**(9번째 Diagnoser) — §26 `run_all.main()` **어댑터**(재구현 0). 19시트 권위↔라이브 격자
  diff 산출을 **시트×결함유형 요약** Defect 로 변환(셀 상세는 §26 CSV). 라운드8 = 9 Diagnoser·총 416·price_grid 9
  (missing_cell: 출력소재 30·엽서북 468[병합후 comp_hint 드리프트 의심]·아크릴 unmapped 1 + UNMAPPED 6시트).
  `PriceGridRmd`(needs_authority/review). graceful(§26 미가용 시 빈+note). 전 레이어 5/5 GO.
- **P5-②b 도메인 전파(수량·판형)** — `QtyRuleDx`(TRAP_MIN 저청구·드리프트0 8) + `PlatesizeDx`(미스매치0·판형 GO).
- **P5-②a OptionCpqDx 신규**(갭#5) — `hdx/diagnose/option_cpq_dx.py`(+`PRICE_DIAGNOSERS`) + `OptionCpqRmd`.
  옵션 dtl_opt↔단가행 dim_vals 연결 끊김(저청구) 검출. ★신뢰도 모델(오탐 가드): HIGH=형제 dtl_opt 가
  param 채움(옵션선택형 확정)·REVIEW=형제 미충전(개수/줄수 수치입력 가능성). 실적: option_cpq 29건
  (HIGH 1=메쉬배너 타공 저청구·REVIEW 28=개수). 라운드5 총 326→355(신규 표면화·전건 라우팅). 셀프테스트
  `diagnose/_selftest.py`(HIGH/REVIEW 판별 가드). 전 레이어 5/5 GO.
- **★첫 실적재** — 포스터 `use_dims += siz_cd`(auto_data) 라이브 COMMIT(인간 승인). 라운드4 결함 해소.
- **★첫 실적재** — 포스터 `use_dims += siz_cd`(auto_data) 라이브 COMMIT(인간 승인). 검증 체인 전 게이트 GO:
  드리프트0 재-SELECT → dryrun → P4 재실측 → **webadmin 라이브 시뮬(A4/A3/A2 PRICE≠0)** → COMMIT →
  사후 시뮬 전 사이즈 불변(가격중립 실서비스 확증) → 스냅샷 재생성 → 라운드4(dim_conformance 38→37·
  총 327→326·UNDECLARED siz_cd 0). 백업 `z_bak_dimconf_usedims_comp_poster_canvas_hanging`·undo 보유.
  기록 `remediate/COMMITTED-260704-poster-usedims.md`.
- **P5-① 반자동 라운드 러너** — `hdx/loop/`(runner) + 진입점 `--loop` 플래그. scan→board→remediate→verify 를
  한 라운드로 묶어 **인간 게이트용 `round-report.md`**(적재 후보[P4 GO]·재실측 NO-GO·인간 입력 대기·다음 액션)
  + `loop-rounds.csv`(수렴 추이) 산출 후 **인간 승인 지점서 정지**([HARD] 완전 무인 금지·적재/webadmin=인간).
  실행 GO(라운드3: 적재 후보 1·인간 입력 326·전역 NO-GO). 셀프테스트 `loop/_selftest.py`(4검증 GO).
- **P4 적대적 재실측** — `hdx/verify/`(base 계약 + overlay + golden) + 진입점 `--verify` 플래그.
  auto_data 교정본을 `foundation/engine.py`(pricing.py verbatim)로 독립 재계산·자체검증(생성≠검증).
  - 3면 판정(전부 통과=GO): ① **가격중립**(engine 재계산 교정 전/후 단가 허용오차 0) ② **결함해소**
    (겨냥 결함 재진단서 소멸) ③ **무회귀**(어떤 차원에도 새 결함 0·적대적).
  - `MutableSnapshot`(overlay): `Fix.mutation`(기계판독 쌍·`models.py` 가산)을 스냅샷 사본에 in-memory 적용(라이브 미변경).
  - **파일럿 GO**: `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd → 가격중립(엔진 siz_cd 하드코딩 매칭)·
    결함해소(UNDECLARED 1→0)·무회귀 실증. **실단가 매칭 검증**(10500/20000/6000·허수 아님).
  - **음성 대조**(항상-GO 버그 배제): 단가행 unit_price 변조 → 검증기가 NO-GO 를 낸다(가격중립 아님).
  - 실행: `python3 …/diagnose_remediate.py --scope price --verify` · 셀프테스트 `verify/_selftest.py`(4검증 GO).
- **P3 교정생성** — `hdx/remediate/`(값 날조 금지 라우팅·입체 근본원인 dedup·327 전건 라우팅). 커밋 `2c6468d`.
- **P3 교정생성** — `hdx/remediate/`(base 계약 + 5 Remediator + plan) + 진입점 `--remediate` 플래그.
  실행 GO(327 결함 전건 라우팅·auto_data 1·blocked_human 10·needs_authority 37·needs_design 21·review 258).
  - **[HARD] 값 날조 금지**: 단가값이 권위/실무진에서 와야 하는 결함(needs_authority/blocked_human/
    needs_design)은 **SQL 안 만들고 worklist 로만**. `auto_data`(값 날조 없는 메타/데이터 교정)만 SQL 트리플.
  - **입체 근본원인 dedup**: wiring 6 + calcability 4(같은 `COMP_ACRYL_PENDING_TBD`) → blocked_human 1건(10결함) 병합.
  - auto_data 파일럿 = `COMP_POSTER_CANVAS_HANGING` use_dims += siz_cd → SQL 트리플 생성 → **P4 재실측 GO**(가격중립·결함해소·무회귀).
  - SQL 승계 = `30_component-merge/_commit/`(백업 CREATE TABLE AS·게이트 RAISE·트랜잭션 래핑).
  - `models.py` `Fix` 확장: `remediation_class`·`worklist_note`·`root_comps`·`mutation`·`is_auto`(가산·P1 회귀 GO).
  - 실행: `python3 …/diagnose_remediate.py --scope price --remediate` · 셀프테스트 `remediate/_selftest.py`(4검증 GO).
- **P2 진단·보드** — `hdx/diagnose/`(5 Diagnoser) + `hdx/board/`. 드리프트 0(원본 카운트 일치). 커밋 `8f2e876`.
- **P1 foundation** — `hdx/foundation/`(6모듈). 셀프테스트 GO. 커밋 `401436e`.
- **스냅샷 재생성**: snap_20260704_1507(병합/타공 반영) → component_merge 9→0 GO 전환 실증(드리프트 재확인).

## 확정 결정 (사용자 260704)
1. 위치 = `_workspace/_foundation/hdx/`
2. **순수 배치(python·실무진 직접) + 얇은 오케스트레이터 스킬 1개**(인간게이트·codex·조율만). 새 하네스 아님.
3. 적대검증 = **엔진 verbatim 재실측 먼저**(결정론·토큰0), codex 배치호출은 **P5 선택**.
4. **가격 도메인 파일럿** 종단 → 판형·수량·옵션CPQ 전파.

## 블로커·주의
- 블로커 없음(P5-②c 독립 완결·전 레이어 셀프테스트 5/5 GO·가격 파일럿 진단 9차원 완성).
- **스냅샷 신선도**: 현재 latest=snap_20260704_1507(재생성·병합/타공 반영). 정본 검증엔 재생성(`live-snapshot/snapshot.sh`) 후 재실행 또는 게이트 단계 **라이브 재-SELECT**(메모리 H-1).
- **[HARD] 건드리지 말 것**: `foundation/engine.py`는 pricing.py와 verbatim(엔진 변경 시 재이식·드리프트 0). `db.py`는 읽기전용 유지. 원본 스캐너(`batch/*.py`)·`dim_conformance.py`는 미변경(import·call 또는 포팅만). auto_data SQL 도 자동 COMMIT 금지(dryrun→P4→인간 승인). 완전 무인 자기회귀 금지(COMMIT=인간+webadmin).

## 큰 로드맵
~~P1 foundation~~ → ~~P2 보드~~ → ~~P3 Remediator~~ → ~~P4 재실측~~ → ~~P5-① 루프~~ → ~~P5-②abc 전파(옵션·수량·판형·가격격자)~~ → **가격 파일럿 완성**(진단 9차원 전 커버·첫 실적재 완료·전 레이어 5/5 GO). 남음(선택)=codex 2차·실무진 액션·타 도메인 확장.
