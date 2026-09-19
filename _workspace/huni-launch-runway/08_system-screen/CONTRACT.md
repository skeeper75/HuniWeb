# 08_system-screen — 시스템×역할×화면×기능 원장 계약 (260919 · 리드 823f33f7)

지니 요청(260919): 오픈 일정 문서. 역할별·화면별 기능목록, 그룹→세부 드릴다운, **직접 구현과 연동을 헷갈리지 않게 구분**.
지니 결정: 9/17 원장(`../07_rebaseline/S/S5-plan/plan-rows.csv` 735행) 재사용 + 새 축 추가. 9/17 확정 전제(`../07_rebaseline/S/CARDS-S.md` §0-A) relitigate 금지.

## 대상 시스템 8 (system 열 허용값)
shopby(NHN SaaS) · edicus · mes(`/Users/innojini/Dev/TS.BackOffice.Huni` 읽기전용) · huni-mall(쇼핑몰 스킨) · webadmin · widget · pagebuilder(상세페이지 탭·가이드북) · pitstop

## 레인 산출 = `<card-id>/screens.csv` (UTF-8 · 헤더 고정)
system,group,screen_id,screen_name,role,function,work_type,counterpart,direction,owner_side,plan_row_id,status,evidence

- role: 고객 / 운영자(CS·상품) / 생산(MES) / 관리자 / 시스템(무인)
- **work_type (5값 · 한 행 한 값 · 섞지 않는다)**
  - `build` 우리가 화면·로직을 직접 만든다(상대 시스템 없음)
  - `integrate` 두 시스템을 잇는 코드를 우리가 짠다 → counterpart·direction(A→B)·owner_side(어느 쪽 코드에 사는가) **필수**
  - `config` 외부 시스템 관리화면에서 설정·등록만(코드 0)
  - `provided` 외부가 그대로 제공(우리 작업 0 · 확인만)
  - `manual` 사람이 운영으로 처리
  - 한 화면에 build 와 integrate 가 같이 있으면 **행을 나눈다**.
- plan_row_id: 735행 중 대응 id(없으면 `NEW` + 이유를 evidence 에)
- status: 완료 / 진행 / 미착수 / 미확인 — **코드·화면을 실제로 본 것만 완료/진행**. 못 봤으면 미확인.
- evidence: `path:line` 또는 URL·산출물 경로. 근거 없는 행 금지.

## 금지
DB write 0 · 라이브 COMMIT 0 · MES 저장소 쓰기 0 · 숫자 날조 0 · 일정은 날짜 추정 금지(선행·순서·원장 하한만).
검증 카드 완료 신호 = `<card-id>/verdict.md`(행수·work_type 분포·미확인 수·NEW 수·실행한 검산 명령과 출력).
## 보충 1 (260919 · 리드 lane-1 · t50 제기) — 오픈 분모 밖 기존 자산
이미 있고 이번 오픈과 인과관계가 없는 기존 자산(예: MES 의 카페24·우커머스·성원·이카운트 연동)은 **행을 빼지 않는다**(사내 선례 근거 보존).
표기 = `evidence` 맨 앞에 `[오픈분모밖] ` 접두(대괄호·공백 포함 고정 문자열) **만**. work_type 6번째 값은 만들지 않는다.
**[개정 260919 · t50 지적 · 보충 3 과의 충돌 해소]** 최초판의 「`work_type=provided` 로 덮는다」는 **철회**한다. 분모밖 행의 `work_type` 도 보충 3 축(그 기능이 어떤 방식으로 생기는가)을 그대로 따른다 — 후니가 짠 연동은 `integrate`, 자사 화면은 `build`, 실제 외부 제공만 `provided`. 집계 제외는 접두가 지고, 「무엇의 선례인가」는 work_type 이 보존한다.
verdict.md 에 분모밖 행수를 따로 적는다. t51 은 이 접두로 `scope`(in/out) 열을 파생해 작업량 집계에서 제외한다.

## 보충 2 (260919 · 리드 lane-1 · t49 제기) — `config` 의 판정 기준
판정 기준은 **「코드 0 · 관리화면에서 설정·등록만」**이다. 「외부 시스템」은 전형 사례일 뿐 조건이 아니다 → 자사 관리화면(webadmin·위젯빌더·페이지빌더) 세팅도 `config`.
자사/외부 구분은 `system` 열이 이미 진다(별도 표식 불요). `manual` 은 설정이 아니라 **사람이 반복 운영으로 처리하는 일**(검수·응대·수기 전달)에만 쓴다.

## 보충 3 (260919 · 리드 lane-1 · t49 제기) — `work_type` 은 「그 행의 기능이 어떤 방식으로 생기는가」다
「남은 일인가」는 `work_type` 이 아니라 **`status` 열이 진다**(남은 일 = status≠완료 로 걸러 낸다). 따라서 이미 완성된 자사 화면의 편집 능력은 `build` + `status=완료` 다.
그 화면에서 **오픈 전에 실무진이 값을 넣어야 하는 일**은 능력과 다른 일이므로 **별도 행**(`config`)으로 둔다 — 「한 화면에 성격이 다른 일이 같이 있으면 행을 나눈다」의 연장.
`config` 쌍둥이 행을 모든 build 행에 기계적으로 만들지 않는다. 735행 원장에 대응 행이 있거나 오픈 전 필수 세팅임을 evidence 로 댈 수 있을 때만 만든다.
레인 간 같은 `path:line` 이 겹치면 **코드가 사는 쪽(owner_side) 레인**이 갖는다. 남은 중복은 t51 이 evidence 키로 걸러 낸다.
**[명확화 260919 · t48 질의]** 위 규칙은 **한 카드 안의 이중 계상 정리용**이다. `integrate` 행은 본래 두 시스템에 걸치므로 **레인 간 중복은 허용**한다 — 이미 쓴 행을 상대 레인으로 넘기려고 빼지 않는다(SaaS 처럼 우리 코드가 없는 시스템의 연동이 원장에서 사라지는 것을 막는다). 대신 중복 가능 행은 evidence 의 첫 `path:line` 을 **코드가 사는 쪽의 실제 위치**로 통일해 t51 이 키로 합칠 수 있게 한다. **[병합 키 정정 260919 · t51 실증]** `path:line` 단독 키는 오병합을 낸다(같은 줄에 서로 다른 기능이 걸린다 — `urls.py:249`·`shopby_sync.py:118` 실측). 병합 키 = **`path:line` + 이음매 `{system, counterpart}` 무순 쌍**. 이 키로 레인 간 실제 중복은 0쌍이었다. t51 은 합친 integrate 행을 `system` 과 `counterpart` **양쪽 드릴다운에 모두** 보인다.

## 보충 4 (260919 · 리드 lane-1 · t50 제기) — 결정·관리 안건은 이 원장의 행이 아니다
화면도 기능도 없는 결정·관리 안건(연동방식 결정·담당자 확정·작업범위 산정·구매 확인·게이트 결정 등)은 `screens.csv` 에 넣지 않는다. 그 자리는 9/17 원장 735행이다(이중계상 방지). `screen_name` 을 지어내야 하면 이 경우다.
지우지 않고 옮긴다: `<card-id>/<system>-decisions.md` (열: plan_row_id · 안건 · 미결 내용 · 근거 path:line · 결정 주체). verdict.md 에 건수를 적는다. t51 은 이 파일들을 「관리 요소(RACI·리스크·의존)」 절의 입력으로 쓴다.
레인 간 교차 사실은 **인용하는 쪽이 직접 path:line 을 확인**한다. 다른 레인의 주장을 증거로 옮겨 적지 않는다. 확인 못 하면 `미확인` 유지.

컨텍스트 50% 도달 시: 산출 커밋 → verdict/progress 에 중단점 기록 → 리드에 보고 → /clear 대기.
