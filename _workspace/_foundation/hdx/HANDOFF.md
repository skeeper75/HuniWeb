# hdx 핸드오프 — 통합 진단·교정 배치 (재시작 포인터)

> 새 세션은 이 파일 + `README.md` + 설계 청사진만 읽고 재발견 0으로 재개.
> 설계: [`../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md`](../DIAGNOSE-REMEDIATE-UNIFIED-BATCH-DESIGN-260704.md)

## 다음 시작점 — 연결 무결성 스코프 신규. 아크릴키링 저청구 교정 대기 · 등록 점검표 확장

**신규 `--scope linkage`**(양방향 배선 연결 점검) + **아크릴키링 고리 저청구 규명**(교정 명세까지) +
**등록 매핑 점검표 파일럿**(엑셀 의도 대조·아크릴). 지니 관리방식 확정 = 실무진 등록 → 상품별 점검표 →
엑셀 대비 초록/빨강 → 빨강 교정. 다음 세션 택일:

**① 아크릴키링 저청구 교정 완결**(대기 중·명세 `remediate/WORKLIST-acryl-keyring-undercharge-260704.md`):
  - 권위값 확정됨(가격표 260527: 고리없음0/은색구슬줄300/은색고리1100/금색고리1200·값이 이미 DB에 존재).
  - **★선행 = 엔진 옵션-가산 경로 실측**: COMP_ACRYL_KEYRING 미배선 상태에서 엔진이 opt_cd 단가를 옵션 경로로
    가산하는지 = pricing.py 확인. (a)가산O→opt_cd 재지정만 (b)배선 필요→전용공식(공용 PRF_CLR_ACRYL 은 10상품
    공유·직접추가 시 오염). 판정 후 교정 SQL(백업·게이트·P4 재실측: 은색고리 +1,100 반영)→webadmin→인간 승인.

**② 등록 점검표 정식화**(`board/registration_check_pilot.py` → hdx 스코프): 이름매칭 정교화(볼체인 vs 은색구슬줄
  오탐 제거) + 아크릴 외 11시트(디지털·스티커·책자·캘린더·실사·문구·굿즈…) 확장. **엑셀 의도↔DB 등록 상품별 대조**
  = 실무진 등록 검증 상시도구. 파일럿이 내부점검 놓친 아크릴키링 고리 저청구를 엑셀 대조로 잡음(실증).

**③ 저청구 옵션 미등록 후속**(파일럿 적발): 아크릴뱃지 원형핀·스마트톡 화이트바디·볼펜 블랙/투명·볼체인 색상 등
  "엑셀 유료인데 DB 옵션 없음/가격경로 없음" — 진위(이름차이 vs 진짜누락) 선별 후 실무진 값 확인.

**④ 가격 스코프(기존)**: 라운드9 = 416건·9차원 NO-GO(직전과 동일). 실무진 액션(메쉬배너 타공·수량함정 8상품·
  출력소재 30셀) 대기. codex 2차(선택).

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
