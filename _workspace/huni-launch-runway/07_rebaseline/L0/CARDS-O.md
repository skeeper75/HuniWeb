# O 카드 — 테스트 시나리오 + L5 게이트·임계경로 + 통합 원장·닫기팩 (2026-09-02 · D-34)

> 선행 완료: N1·N2·N3 — 산출 `L0/N1|N2|N3/`, lead 검산 `L0/LEAD-VERDICT-N.md`. 전략 `07_rebaseline/STRATEGY-D34.md`.
> 세 카드는 **병렬**이다. 서로의 산출을 기다리지 않는다.

## 전 카드 공통 [HARD]

- **초안을 존중하지 마라.** lead 가 이 명세와 `STRATEGY-D34.md` 에 쓴 게이트 날짜·배정·판정은 **초안**이다. 근거가 다르면 뒤집고 근거를 남겨라. (이 지시가 M·N 에서 lead 오류 3건을 잡았다.)
- **1차 참조 순서**: 앱 내장 매뉴얼 2종 → SDK 개발가이드(`L0/M2/_evidence/sdk-guide-live-20260902.txt`) → 라이브 실화면 → 코드. 코드부터 열지 마라.
- **등급 기본값은 「작업 항목」.** 「차단」은 우리가 통제 못 하는 외부 의존(PG·MES·NHN 회신)에만.
- **0행 = 미실행이지 미구현이 아니다.** 미구현·미실행·미확인 3분류(N3 §0.2)를 쓴다.
- 라이브 **읽기전용**. 주문·결제·폼제출·DB write 금지. 모르면 「미확인」.
- **시간 추정 금지**(「2일」). 순서·게이트·날짜(달력)로만 표현.
- 자기 `L5/<O?>/` 안에만 쓴다. 커밋·푸시·`git add -A` 금지. 완료하면 `progress.md` 에 완료조건 대조표를 쓰고 멈춘다.
- **쉬운 말.** 지니가 읽는 문장에 컬럼명·코드명·영문 상태값을 한 문장에 섞지 않는다. 코드명은 괄호 보조.

---

## O1 — 게이트별 테스트 시나리오 (`plan-huniweb`)

**질문**: 각 게이트에서 실무진이 **그대로 따라 하며** 「된다/안 된다」를 판정할 수 있는 시나리오는 무엇인가.

**재료**
- ★ `L0/N1/shopby-order-state-machine.md` §3 매트릭스(13행×10조작) · §4 결제승인 경계 · §5 `nextActions`·`cancelable` 등 플래그
- `L0/N1/open-questions.md` G-1(교환 가능 상태) · G-2(부분취소 범위) — **두 분기 다 시나리오로 써라**(어느 쪽이 맞는지 미확인)
- `L0/M1/customer-journey.md` · `production-payload.md`(25키) — 앞 6단계
- `L0/M3/auto-vs-human.md` — 생산 자동/사람 분계 → 사람 경로 시나리오
- `L0/N3/ARCHITECTURE-v2.md` §4 13단계 종단
- `STRATEGY-D34.md` §3 게이트 초안 · §4 Plan B
- price-setup 결함: `_workspace/price-setup/STATUS-260901.md` §5(개발 4건) · `STATUS-260902.md` §6(아크릴 할인) — **가격 기대값 시나리오**(무선책자 A5 = 13,160 등 권위값)

**할 일**
1. **P0 = 오픈 필수** 시나리오: 전 주문 경로(상품→옵션→견적→원고→장바구니→결제→주문성립→후니 수신→원고승격→생산지시→출고→주문조회) 를 **끊김 없이** 덮는다. 단계마다 「전제 / 조작 / 기대결과 / 확인하는 곳(화면·API·DB 읽기) / PG 승인 전 실행 가능 여부」.
2. **P1 = 운영 필수**: 취소·교환·반품(상태별) · 배송보류 · 게스트 주문 · 셀러어드민 일일 동선 · 알림(알림톡/문자) 수량 노출 확인.
3. **P2 = 돈 검증**: 가격 결함 5건 각각의 「고치기 전 값 / 권위값」 재현 절차. 수량기준 배송비 4종이 꺼져 있는지 확인 절차.
4. **게이트 매핑**: 각 시나리오를 G1~G5 중 어느 게이트의 이탈 조건인지 표시. PG 승인 전에 못 도는 것은 「G4 이후」로 명시.
5. **기대값 검증 수단**: 주문 이후 시나리오는 샵바이가 내려주는 `nextActions`·`cancelable`/`exchangeable`/`returnable` 플래그를 기대값으로 적어 **런타임에 교차검증** 가능하게.
6. **Plan B 시나리오**: 수동 생산지시(의뢰서 출력→현장) · 카드/계좌이체만 오픈 · 사람 검수 — 각각 P0 급으로.
7. ★ **셀러어드민 실화면 읽기전용 확인** (지니 09-02 승인 · N1 ④ 닫기): 계정은 저장소 루트 `.env.local` 의 `SHOPBY_ADMIN_URL` / `SHOPBY_ADMIN_ID` / `SHOPBY_ADMIN_PW`. gstack 으로 로그인해 `L0/N1/open-questions.md` **A-1~A-14** 와 `L0/N3/open-questions.md` **U-1~U-3** 을 화면 이동 순서대로 본다. 특히 A-2 부분취소 창(G-2)·A-14 금지 설정 4종·U-2 `huni_token` 라벨 등록 여부. **[HARD]** 조회만 — 주문·취소·설정 변경·저장·폼 제출 0건. 부분취소 창은 **열기만 하고 실행 버튼 누르지 않는다**. 계정 값은 어떤 파일에도 적지 않는다. 캡처는 `L5/O1/shots/` 에 저장. 본 것과 못 본 것을 나눠 적는다(추정 금지).

**산출** `L5/O1/`: `test-scenarios.md`(사람이 읽는 본문) · `scenario-matrix.csv`(열: `scn_id, 등급(P0/P1/P2), 게이트, 단계, 전제, 조작, 기대결과, 확인처, PG승인전가능(Y/N), 근거, 미확인분기`) · `plan-b-scenarios.md` · `selleradmin-observed.md`(A-1~A-14 · U-1~U-3 관측 결과 + 캡처 경로) · `progress.md`

**완료조건** ① P0 가 13단계 전부를 덮고 빈 단계 0(기계 검산: 단계 열 유니크 = 13) ② 시나리오 전건에 관측 가능한 기대결과(「정상 동작」 금지) ③ G-1·G-2 양분기 각각 시나리오 존재 ④ 가격 결함 5건 재현 시나리오 존재 ⑤ 무작위 10건의 근거 파일 실재 ⑥ **역방향**: N1 매트릭스의 ○/✕ 셀 중 시나리오가 안 덮는 셀을 목록으로 남겨라(숨기지 말 것) ⑦ 셀러어드민 17건(A-14 + U-3) 각각 「본 것 / 못 본 것+사유」 표기 · 쓰기 조작 0건 기록 · 계정 값 파일 내 0건(기계 grep)

**지니 확인 사실(09-02)**: PG 는 **심사 중(신청서 제출함)**. 이니시스 가맹점관리자 추가 작업은 실무진 진행 중(개발 불가). 시나리오의 「PG 승인 전 가능」 판정에 이 전제를 쓴다.

---

## O2 — L5 게이트·임계경로·배정 규칙·10/6 가능성 판정 (`run-huniweb`)

**질문**: 10/6 에서 역산했을 때 무엇이 무엇을 막고, 누가 무엇을 맡으며, **정직하게 10/6 이 가능한가.**

**재료**
- `STRATEGY-D34.md` §2 차단 3 · §3 게이트 초안 · §4 Plan B · §5 역할 초안 — **초안이다. 뒤집어라.**
- `L0/N2/standard-feature-canon-v2.csv`(501) · `L4/{a,b,c}/mapping.csv`(353 상태) · `L0/N2/reverse-coverage.md`
- `L3/legacy-normalized.json` 의 `의존` 필드(runway `blocked_by`·`external_dep`·`precondition` + scope/ia 선행조건 텍스트) · `L2/service-dependency.json`(18종·critical 7) — **1.4MB 는 스크립트로 필터**
- `L0/N3/ARCHITECTURE-v2.md` §10 결함 A-3~A-22 · `L0/N3/open-questions.md` §4 PM 결정 · §5 외부 의존
- `L0/N1/open-questions.md` C(PG)·D(PM 결정)·F(내부 확인) · `L0/N1/payment-approval-flow.md`(원천사 심사 기간). **지니 확인(09-02): PG 심사 중 · 신청서 제출함 · 가맹점관리자 추가 작업은 실무진 진행 중** — 임계경로의 PG 노드는 이 전제로
- `L0/M3/auto-vs-human.md` · `process-route.md`
- price-setup `STATUS-260901.md` §5 · `STATUS-260902.md` §5~§7
- `docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx` `01_역할정의`(3인 정의) · `03_페이즈일정`(양식)

**할 일**
1. **의존 그래프**: 엣지 전수(출처 필수) · 순환 검출 · 외부 계약 의존(PG·MES·NHN·Edicus·알림톡·본인인증·배송사)은 별도 등급.
2. **임계경로**: D-34 기준. 외부 의존이 걸린 경로를 표시. 「차단」은 STRATEGY §2 의 셋 + 근거로 추가/삭제.
3. **게이트 확정**: G0~G5 각각 **진입 조건 / 이탈 조건**을 관측 가능한 문장으로(「~가 화면에 보인다」「~행이 0이 아니다」「~캡처가 있다」). 날짜는 달력(연휴 반영)으로 재계산해 초안과 다르면 근거.
4. **배정 규칙표**: 대분류·중분류 → 담당(PM/인쇄개발/쇼핑개발) + `sub_track(web|builder)` + 근거. 항목 하나하나가 아니라 **규칙**으로(O3 원장에 lead 가 기계 적용). 규칙으로 못 가르는 항목은 예외표로.
5. **부하 합산**: 규칙을 501 + 신규 유입에 적용했을 때 담당별 todo/partial/new 건수 — 쇼핑개발은 web+builder 합산.
6. **10/6 가능성 판정**: 게이트별로 「가능 / 조건부 / 불가」 + 조건. 불가면 불가로 쓰고 **범위 축소 시나리오**를 2~3개 놓는다(결정은 PM).
7. **`done_criteria` 규칙**: 상태별·대분류별 기본 완료조건 문장 템플릿(관측 가능). O3 가 원장 전건에 채울 때 쓴다.

**산출** `L5/O2/`: `dep-graph.json` · `critical-path.md` · `gates.md` · `assignment-rules.csv`(열: `대분류, 중분류(선택), 담당, sub_track, 근거`) + `assignment-exceptions.csv` · `load-summary.md` · `feasibility-verdict.md` · `done-criteria-templates.md` · `unparsed-preconditions.md` · `progress.md`

**완료조건** ① 엣지 전건 출처 ② 순환 검출 결과 명시 ③ 게이트 6개 전부 진입/이탈 조건 관측 가능 ④ 임계경로에 외부 의존 표시 ⑤ 배정 규칙을 501행에 적용해 미배정 0(예외표 포함) ⑥ 가능성 판정에 「불가」가 있으면 축소 시나리오 ≥2 ⑦ **역방향**: STRATEGY §2~§5 의 주장 중 근거로 뒤집은 것 목록(0건이면 「0건·확인함」)

---

## O3 — 통합 원장 + X·P 트랙 + 미확인 닫기팩 + 지도 v2 §11 합침 (`sync-huniweb`)

**질문**: 오픈까지 추적할 **단일 원장**은 무엇이고, 지니가 **이번 주에 바로 들고 움직일 문서**는 무엇인가.

**재료**
- `L0/N2/standard-feature-canon-v2.csv`(501) · `L4/{a,b,c}/mapping.csv` · `L0/N2/reverse-coverage.md`(재귀속 56) · `L0/N2/new-recheck.md` · `category-decision.md` · `merge-decisions.md`
- ★ `L0/LEAD-VERDICT-N.md` §2 — lead 결정 5건(그대로 적용)
- 고아 64건(X 55 · P 9): `L3/legacy-normalized.json` 에서 · `CARDS.md` §6 (가)
- 신규 유입 항목: price-setup `STATUS-260901.md` §5(개발 4건) · `STATUS-260902.md` §5~§7(아크릴 할인·미매핑 4) · `L0/N3/ARCHITECTURE-v2.md` §10 A-3~A-22 · `L0/N1/open-questions.md` D·F · M1 §10(위젯 없는 77상품·부속색상·셋트 summary 라벨)
- `L0/N1/*.md` 6종 → `L0/N3/ARCHITECTURE-v2.md` §11 합침 (`LEAD-VERDICT-N.md` §3 정정 2건 필수)
- `L0/N1/open-questions.md` A~G 47건 · `L0/N3/open-questions.md`

**할 일**
1. **통합 원장**: 501 std 행 + legacy 귀속 + 상태 재판정(done 은 L2 file:line 필수) + lead 결정 5건 적용 + 신규 유입 항목(위 목록·`std_id` 는 `STD-NEW-…` 가 아니라 해당 대분류 채번·근거 필수). 열: `std_id, 대분류, 중분류, 기능, 상태, 매핑legacy_id, 매핑asis_id, 돈여부, 주문여부, 근거, 비고(실물있음 등), 담당(비움·lead 가 O2 규칙으로 채움), done_criteria(비움)`. 원장 밖 항목 창작 금지.
2. **X·P 트랙**: 64건 성격 분류(정책결정/외부계약/인프라/코드부채 · P 는 상품군·결함유형·`affected_count`) · 의사결정자(PM/외부/개발/미상) · 오픈 차단 여부(등급 규칙) · runway conflict 7건 양측 보존 확인. 돈 32·주문 26 재현.
3. **미확인 닫기팩** — 지니가 바로 쓰는 문서 5종:
   - `close-pack/A-selleradmin-checklist.md` 셀러어드민 14건 점검표(화면 이동 순서 · 결과 칸) — **실접속 관측은 O1 이 병렬로 수행**(`L5/O1/selleradmin-observed.md`), O3 는 양식만 만든다. lead 가 합침
   - `close-pack/B-nhn-inquiry.md` NHN 문의서 초안 12건(웹훅 7·정산 4·정책 1 — 질문 그대로 보낼 수 있게)
   - `close-pack/C-pg-capture-request.md` 이니시스 캡처 1장 요청 + 단계별 해석표(행 없음/접수/처리완료)
   - `close-pack/D-pm-decisions.md` PM 결정서 양식 6건(결제수단·배송비 문구·에스크로·세금계산서 수량·PitStop·범위) — 각각 「정하지 않으면 무엇이 밀리나」 한 줄
   - `close-pack/F-internal-check.md` 사내 확인 3건(고도몰 PG ID·MID/계정 소재·webhooks/failed 폴링 여부) + E-4 서버키 1회 호출 절차(실행은 승인 후)
4. **지도 v2 §11 합침**: N1 6종의 요지+링크로 채우고 「N1 대기」 0 으로. 정정 2건(고정 IP 아웃바운드 · 취소 구간) 반영.
5. **라이브 DB 테이블 수 재실측**: 44 / 59 / 60·120 불일치를 읽기전용 `information_schema` 1회로 확정하고 실측 시각 기록.

**산출** `L5/O3/`: `unified-ledger.csv` + `.json` · `ledger-build.py`(재현 스크립트) · `xp-track.csv` · `xp-decision-owners.md` · `close-pack/{A,B,C,D,F}-*.md` · `L0/N3/ARCHITECTURE-v2.md`(§11 갱신 — 이 파일만 `L5/O3/` 밖 쓰기 허용) · `db-table-count.md` · `progress.md`

**완료조건** ① 원장 std 행 = 501 + 신규 유입(건수 명시) · std_id 중복 0 ② legacy 716 전건이 원장 매핑 또는 X·P 트랙 중 하나에 있음(누락 0 · 기계 검산) ③ done 전건 L2 file:line ④ lead 결정 5건 적용 흔적(`ledger-build.py` 에 명시) ⑤ X·P 64 전건 분류·돈 32·주문 26 재현 ⑥ 닫기팩 5종 존재 · 미확인 47건 전부 어느 팩에 속하는지 표시(누락 0) ⑦ v2 §11 「N1 대기」 0 ⑧ **역방향**: 신규 유입 후보 중 원장에 안 넣은 것과 사유

---

## 다음 (O 종료 후)

lead 합침: O2 배정 규칙 → O3 원장에 기계 적용 · O1 시나리오 ↔ O2 게이트 대조 · 가능성 판정 지니 보고.
그 다음 **L6**: 원장 → 260616 양식 엑셀 5시트 → 인터랙티브 아티팩트(후니 DS · 라이트/다크 · 담당 필터 · 게이트 탭 · localStorage 체크박스 키=`legacy_id`/`std_id` · mermaid 의존도 · 시나리오 뷰).
