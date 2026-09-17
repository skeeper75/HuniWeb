---
id: SPEC-LAUNCHPLAN-001
title: "프로세스 기준 오픈 계획서 전면 재작성 — 28구간 척추 · 7트랙 · 단일 HTML"
version: "0.7.0"
status: implemented
created: 2026-09-17
updated: 2026-09-17
author: 지니
priority: P0
phase: "런칭 런웨이 v2.0 target — 오픈 계획서 재작성"
module: "docs/huni"
lifecycle: spec-anchored
tags: "launch, plan, process, swimlane, track, checklist, go-no-go, cutover, html"
tier: M
depends_on: []
related_specs: [SPEC-LAUNCHGUIDE-001]
---

# SPEC-LAUNCHPLAN-001 — 프로세스 기준 오픈 계획서 전면 재작성

> [HARD] 이 SPEC 의 산출물은 **문서 아티팩트 3종**(HTML 계획서 1 · 엑셀 재생성 1 · 검증 스크립트 1)이다.
> 프로덕션 코드·라이브 데이터 변경은 **0건**이다.
>
> [HARD] **쓰기 권한 0.** 라이브 DB·webadmin·셀러어드민·스킨 저장소는 전 기간 읽기 전용이다.
> DB 는 `SELECT` 만. 저장·주문·결제·삭제·발송 버튼을 누르지 않는다. 비밀값은 어느 산출물에도
> 기재하지 않는다(env 키 이름으로만 참조).
>
> [HARD] **문서 테마는 라이트 전용.** 다크 테마 CSS·시스템 테마 질의(`prefers-color-scheme`)·
> 테마 토글을 **0건** 둔다. SPEC-LAUNCHGUIDE-001 의 「라이트+다크 토글」 관습은 이 SPEC 에서
> 계승하지 않는다.
>
> [HARD] **아래 §2 확정 전제는 재론의 대상이 아니다**(지니 확정 2026-09-17). 선택지로 제시하지
> 않고, 완곡하게 되묻지 않고, 「검토 필요」로 되돌리지 않는다.
>
> [HARD] **입력 경로는 메인 체크아웃 절대경로로 고정한다** —
> `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/{R,S}/…` 를 **읽기 전용**
> 으로만 접근한다(쓰기·삭제 0건). 사유: `R/`·`S/` 는 git 미추적이라 새 워크트리에 존재하지 않는다
> (`git ls-files` 실측 0건). 커밋은 지니 지시 대기 상태이고(`R/HANDOFF.md` §이번 세션 결정) S1 이
> 아직 쓰이는 중이므로 지금 커밋하지 않는다 — 커밋 필요성은 sync 단계에서 리드가 올린다.
>
> [HARD] **산출 경로는 워크트리 안이다.** D1 = `docs/huni/후니프린팅_오픈계획서_260917.html`(워크트리
> 상대경로) · D2·D3 = `_workspace/huni-launch-runway/07_rebaseline/S/S5-plan/` 하위. 워크트리에는
> `S/` 디렉터리가 없으므로 run 레인이 `S/S5-plan/` 을 새로 만든다 — 입력 `S/` 와 이름이 겹치지
> 않도록 산출은 반드시 `S5-plan` 하위에 둔다.
>
> [HARD] **날짜 판정 금지.** 계획서는 「10/6 가능/불가」를 쓰지 않는다. 필요한 것 전부 → 임계경로
> → 현실적 오픈일 역산까지만 쓰고, **날짜·인원·범위 중 무엇을 움직일지**를 결정 안건으로 올린다.
> 금지 대상은 **오픈일에 대한 판정**이다 — 개별 작업 항목의 목표일은 금지 대상이 아니라 **의무**다
> (REQ-LP-009).

---

## 0. HISTORY

| 일자 | 판본 | 작성자 | 변경 |
|---|---|---|---|
| 2026-09-17 | 0.1.0 | manager-spec | 최초 작성 — 9/16 반려(「무슨 문서인지 모르겠다」) 원인 진단(데이터가 아니라 틀)에 대응하는 재작성 규격. 확정 전제 9건 승계, S0 리서치 §6 11섹션 골격 채택, GEARS 요구사항 16항 |
| 2026-09-17 | 0.2.0 | manager-spec | 계획감사 review-1(FAIL 64/100) 어노테이션 수정 — **C-1** 코드명 검사 범위를 산문 노드로 한정(증거 칸·부록 경로·위험 표기 `R1~R10` 제외 명문화) · **C-2** 외부 의존 「딱 둘」을 이관 6단계 하위로 한정하고 T6 블록의 토스·Shopby 엔터프라이즈 대기 항목을 별도 의무화(REQ-LP-014) · **C-3** 트랙당 최상위 항목 3~5 상한 + `data-role="top"` 계약 신설(REQ-LP-009) · **C-4** 여섯 번째 칸 `목표일` 신설(S0 §6-5 원문 계약 복원 — 마감→체크 방법 바꿔치기 철회) · **M-3** AC 20→16(Tier M 예산 REQ 16 AND AC 16) · **M-14** §1 요약·§3 마일스톤·§5 배치도 계약 신설(REQ-LP-008) · **M-15** 역할별 진입점 5블록(REQ-LP-011) · **M-1** 의사소통 주기 복원 → **12섹션**, 시스템 배치도는 S0 이탈로 명시 · **M-16** CTO 10구간 ↔ 28구간 매핑 요구사항화(REQ-LP-007) · **m-4** 조판·반려수치·판정 금지를 Unwanted 요구사항으로 승격(REQ-LP-003) · **m-7** 전제 P-6 이 「구 ASP 코드·DB 미참고」 기록을 덮어씀을 명시 · 거짓 게이트 4건(체크 방법 실질·근거 실재·C1~C7 값 대조·판정 금지 구조 검사)을 실질 검사로 승격 |
| 2026-09-17 | 0.2.0 | manager-spec | (동일 판본 · 지니 추가 요건 3건 병합) **요건 1** ego-browser 라이브 판정 규율 + `작동` 승계 한계 신설(REQ-LP-018 · AC-LP-018) · **요건 2** 「판매 준비 프로세스」 절 신설 — 전수 메뉴 지도 37 + 옵션↔가격 도식(REQ-LP-017 · AC-LP-017), 섹션 12→**13** · **요건 3** M0(28구간 통합 상태판)을 첫 마일스톤으로 신설(plan.md). 결과로 REQ 16→**18** · AC 16→**19** 이 되어 Tier M 예산 두 축 모두 초과 — §3-0 에 초과를 선언하고 Tier L 재판정을 권고(억지 병합으로 검사 강도를 낮추지 않음) |
| 2026-09-17 | 0.3.0 | manager-spec | 재감사 review-2(FAIL 79/100 · 1점 미달) 델타 수정 — **N-1** 「갭 6」 상수 철회: 어느 원천 판독(13 실질 텍스트 / 11 비결함 제외 / 5 ★ / 3 매뉴얼 갭)으로도 6 이 나오지 않아, 상수를 박으면 정직한 문서가 FAIL 하고 통과하는 유일한 길이 「갭 표기를 그 수에 맞춰 조정」이 됨 → REQ-LP-017·AC-LP-014 를 「수 + 판정 기준 + 원천 선언」 파생 검사로 교체, 전파 3곳 정정 · **N-2** §5 성공 기준 표의 AC 오참조 3건 정정(SC-1→016 · SC-8→014 · SC-9→007(d)) + 「SC-1 은 사람 판정」 경고 추가 · **N-3** AC 번호를 판정 주체 순서와 일치(§A 001~014 · §B 015 · §C 016) · **강도 중립 병합 3건**으로 AC 19→**16**(AC 축 예산 준수) · **§6-1** AC-LP-016 에 (e) 「옵션을 바꾸면 어느 화면에서 고치나」 신설 — §6 이 반려 원인의 이사 경로이므로 그 절의 존재 이유로 검사 · **S5 반영**(입력 5/5 완결 · 오늘자 실측이 도식·메뉴 지도의 실입력) · **이월 3건 선반영**(N-5 `class="source"` 제외 · N-6 URL 호스트 화이트리스트 · N-7 `NEW` ≤ 30%) · 리드 판정 ③ 반영 — 예외 선언을 **REQ 한 축**으로 축소 |
| 2026-09-17 | 0.4.0 | manager-spec | 최종감사 review-3(**PASS-WITH-NOTES 88/100** · 추이 64→79→88 · 회귀 0) 마감 수정 — **R-1** `AC-LP-007(d)` 대상 범위 교정(감사관 지정 문언): (a)(b)(c)는 `REQ-LP-010`("Every **top-level** row")을 따라 최상위 행, **(d)는 `REQ-LP-018`("**Every** checklist row")을 따라 최상위 + `detail` 전 행** — `detail` 행이 654행 원장이 접히는 자리라 양이 가장 많고, 거기 `작동` + `파일:줄` 을 적으면 화면 관측 없는 승격이 통과하던 구멍 · **R-6** `plan.md` §C-2 카테고리 「10원~」 원인 단정 → **추정**(S5 는 「화면만으로 판정 불가」로 기록 — `verification-claim-integrity` §1.1 surface 3) · **R-4** §A 제목 stale(「L 재판정 권고」→승인 완료) · D3 검사 수 19→**14** · **R-5** `research.md` §3 제목 stale(「그대로」→「뼈대로 · 이탈 3건 선언」). **R-2**(선언 갭 수 대조) · **R-3**(§6 앵커 순서) · **m-8**(REQ-016 과묶음)은 AC 계약 변경이라 손대지 않고 `progress.md` 에 **잔존 기술부채**로 이월 — 감사 회차 3/3 소진. `plan_status: audit-ready` 서명 + 미검증 4건 기록 |
| 2026-09-17 | 0.5.0 | manager-spec | 지니 결정 반영 — **§G·§H 가 전제한 webadmin 실측의 깊이를 (c) 「매뉴얼 원고 요소와의 1:1 대조」로 확정**. ① `REQ-LP-017` 확장(신설 아님 · REQ 18 불변): §6 이 **매뉴얼 요소 대조 매트릭스**(`id="map-manual-elements"`)를 세 번째 블록으로 동반하고, 행 = 매뉴얼 SCREENS/MODEL_ADMIN 원고(`raw/webadmin/tools/manual_content.py` 1,468행 · `widget_manual_content.py` 1,117행 — 합 2,585행) 기술 요소 전건, 실측 결과 값 집합 4종(`동작확인(URL@일시)`·`불일치(URL@일시+차이)`·`쓰기경로-dev환경필요`·`미실측(사유)`) 고정, 읽기 경로는 ego-browser p2 실클릭 판정·쓰기 경로는 라이브 미클릭 + T1 진입 조건 연결 명시 · **층 분리 계약**(본문 = 요약 층 · 전건 매트릭스 = 접힘 부록 + CSV) ② `AC-LP-014` 에 **(e)** 추가(AC 16 불변) — 분모 상수화가 구조적으로 불가능한 **3항 사슬 관계 검사**(원고 grep 분모 == 부록/CSV 행 수 == 본문 요약 층 집계 수 · 산출 규칙 선언 동반) + 결과 4종 외 값 0 + 미실측 사유 빈칸 0 + 대상 행 0 이면 FAIL ③ `REQ-LP-018` 해설의 「28구간 전건 재실측」 문언을 **「`작동` 으로 적을 행은 전부 화면 근거를 갖는다」**로 한정(실제 AC 보다 무겁게 읽히던 표현 교정) ④ `plan.md` 에 **M1.5 매뉴얼 요소 대조** 신설(M1 뒤 · 같은 p2 드라이버 순차) |
| 2026-09-17 | 0.6.0 | manager-spec | 델타감사(**PASS-WITH-NOTES 85/100** · 추이 64→79→88→85 · 회귀 0) MAJOR 4건 마감 + 지니 정정 1건 — **D-1** `AC-LP-014(e)` 자기축소 구멍 봉쇄: (i)~(iv)만으로는 **1행 매트릭스가 (e) 전체를 닫았다**(산출 규칙을 좁게 선언해 분모 1 · CSV 1행 · 집계 1 로 맞추고 그 행을 `미실측` 으로 두면 전부 통과) → **(v) 화면 축 하한**(메뉴 지도 37행 중 읽기 경로 화면 전건 커버 · 누락 0 · 37은 (a)의 기검증 앵커라 새 상수 아님) + **(vi) 실측 축 하한**(`미실측` ≤ 30% · `NEW` ≤ 30% 와 같은 장치) 추가 — 상수 금지 원칙과 하한은 양립 · **D-2** D3 가 피감사 문서의 명령을 실행하던 구조 철회(감사 독립성 붕괴 + 코드 주입면) → **분모 산출 명령을 D3 의 4번째 입력 인자로** 받고 「선언 명령 == 인자」 문자열 비교 후 **D3 가 자기가** 실행(B 안) · **D-3** `쓰기경로-dev환경필요` 가 문장 수준에 머물러 임계경로에서 보이지 않던 구멍 → `AC-LP-012(b)`·`REQ-LP-015` 에 「§8 선행/외부 대기 항목으로 렌더 + T1 진입 조건 상호 참조」 의무화 · **D-4** `plan.md` stale AC 번호 **10건** 교정(감사관 자인 — 특히 K7·M4-3 이 「654 행수 대조」를 살아 있는 `AC-LP-016`(5분 이해 테스트)로 조용히 해소시켜 D3 제작 지시서가 오지시였다): 016→015(c) 2곳 · 017→015(d) · 018→016 5곳(「4문항」→「5문항」 동반) · 019→007(d) · M4-1 범위 `001~015·019`→`001~014` · **지니 정정** 소유 라벨 신설 — 배치도 전 노드·스윔레인 전 레인명이 열거형 2값(`NHN 제공`/`후니 개발`) 라벨 동반(`REQ-LP-007`·`REQ-LP-008` 확장 · `AC-LP-004(a)`·`AC-LP-005(c)`), 체크리스트 행은 6칸을 늘리지 않고 `data-owner`·`data-work` **속성**으로 싣고 **`nhn` × `dev` 조합 0건**(`REQ-LP-009` 확장 · `AC-LP-006(e)`) — 소유 라벨 부재는 NHN 제공 기능을 자체 개발로 섞어 **임계경로를 길게** 만드는 실패이고, 외부 의존이 지워져 짧아지는 실패의 거울상 · **R-2·R-3·m-8 은 기술부채 유지**(감사 회차 소진), `plan.md` §H 에 R-3 하중 증가(2→3블록)만 기록 + M2 에서 도식을 매트릭스 앞에 두는 운영 회피. **REQ 18 · AC 16 불변** |
| 2026-09-17 | 0.7.0 | manager-spec | 리드 검산 결손 1건 마감 — 0.6.0 의 소유·분류 열거형이 **외부 벤더 행을 수용하지 못해** 같은 SPEC 안에서 세 조항이 충돌했다: `REQ-LP-009`·`AC-LP-006(c)` 는 담당 칸에 「외부(<대상>)」를 인정하는데 `AC-LP-006(e)①` 은 `data-owner` 를 {`nhn`,`huni`} 로 닫아, 이니시스 PG·토스페이먼츠·MES 벤더·구 사이트 운영사·인프라팀 행이 (c) 통과 후 (e)① 에서 전량 FAIL 한다(두 검사 동시 만족 불가 — review-1 C-1 과 같은 형태이고, 확정 전제 P-8 의 역할 5종 중 「외부」와도 어긋났다). 교정 = **열거형 2건 확장**: `data-owner` ∈ {`nhn`,`huni`,**`ext`**} · `data-work` ∈ {`config`,`dev`,**`wait`**}, 제약 세 줄(**`nhn` × `dev` 금지** · **`ext` × `dev` 금지** · **`wait` 은 `ext` 전용**). `wait` 을 `ext` 전용으로 묶은 이유 — `nhn` 과 `ext` 는 「우리가 고칠 수 없다」는 점에서 같아 둘 다 `dev` 를 금지하지만 **성격이 다르다**: `nhn` 은 **이미 제공되는 것**(설정만 하면 된다), `ext` 는 **아직 오지 않은 것**(회신·계약·심사를 기다린다). 그 차이를 표시하지 않으면 외부 대기가 「설정」으로 뭉개져 일정에서 사라지고, 그것이 이번 사이클 내내 막아 온 실패(토스 계약 삭제 → 임계경로 단축)다. `ext` × `wait` 집합은 `REQ-LP-015`·`AC-LP-012(b)` 의 §8 선행/외부 대기 항목과 **같은 집합**임을 명시해 한쪽만 고치는 사고를 막았다. 전파 3곳(§3-0 마커 예시 HTML · `AC-LP-006(e)①②③` · `plan.md` B-5 본문·예시). **REQ 18 · AC 16 불변**(열거형 확장이라 수가 늘지 않는다) |

## 1. 배경 — 왜 이 SPEC 이 필요한가

2026-09-16 에 산출한 세 벌(원장 v4 654행 · 엑셀 9시트 · 결정 안건 30건)을 실무진과 CTO 가 검토한
뒤 **「무슨 문서인지 모르겠다」**로 반려했다.

원인은 **데이터가 아니라 틀**로 진단됐다. 산출물은 기능 행 목록이었고, 그 안에 (1) 전체 그림
(2) 프로세스 척추 (3) 사람이 자기 할 일을 찾아 체크하고 일정을 잡을 자리 — 셋 다 없었다.
CTO 는 2026-09-08 자기 문서(`docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html`)
에서 **주문이 지나가는 10구간**으로 사고하고, 9/15 회의에서 「사이트 전체 화면·절차 설계가
필요하다」고 다시 말했다.

이 SPEC 은 그 재작성을 규정한다. **프로세스를 척추로 삼고**, 조사·목록·일정을 전부 그 위에 다시
건다. 척추는 두 층이다 — **상위 = CTO 의 10구간**(읽는 사람의 언어), **하위 = 28구간 A1~E4**
(작업을 매다는 격자). 최상위 그룹 구조는 **7트랙(T1~T7)**이다.

**성공의 정의**: 실무진과 CTO 가 **5분 안에** 「이 문서가 무엇인지 / 내 할 일이 무엇인지」를
답할 수 있고, 그 자리에서 자기 항목을 체크하고 **목표일을 잡을 수** 있다.

## 2. 확정 전제 (지니 확정 2026-09-17 — relitigate 금지)

| # | 전제 | 계획서 반영 |
|---|---|---|
| P-1 | **오픈일 2026-10-06 은 기준점이지 못 박는 날짜가 아니다** | 「가능/불가」 판정 대신 필요한 것 전부 → 임계경로 → 현실적 오픈일 역산. 날짜·인원·범위 중 무엇을 움직일지가 결정 안건. **금지 대상은 오픈일 판정이며, 작업 항목 목표일은 금지 대상이 아니다** |
| P-2 | **AWS Lightsail 이전은 오픈 선행 조건** — Railway(webadmin+DB)·Vercel(스킨) 모두 이전 후 그 위에서 오픈 테스트 | 트랙 T1 = 첫 마일스톤. 구간 E2 + 신설 F1~F4 |
| P-3 | **주문파일 파이프라인은 오픈 필수** — 원고 승격 → PitStop 프리플라이트 → 접수 → MES 인계. 「수동 Plan B 로 오픈」 전제는 **폐기** | 트랙 T4. 설계 결정 D-P1~D-P9 가 1주차 안건 |
| P-4 | **조판(imposition)은 논외** — 오픈 후 마지막에 결정 | 문서 전체에서 **1회 이하**. 오픈 후 트랙에도 항목으로 넣지 않는다(REQ-LP-003) |
| P-5 | **프린팅머니 충전을 뺀 쇼핑몰 기능 전부가 Shopby Shop/Server API 위** — 스킨에 장바구니·주문서·NCPPay·비회원·프로필·마이페이지·소셜 코드 이미 존재 | 쇼핑몰 잔여 = 연결(claims·inquiries·FAQ) + 자체 개발(order/register 호출·huni_token·리다이렉트·홈 더미) |
| P-6 | **회원·프린팅머니 이관은 오픈 범위** — 구 Classic ASP 사이트에서 이관. **구 DB 구조를 직접 분석하고 이관 스크립트를 작성**한다 | 트랙 T3(회원)·T6(프린팅머니). 6단계 작업으로 전개 — blocker 가 아니라 작업 단계. **이 전제는 9/15 회의의 「기존 ASP 코드·DB 는 제공하지 않고 참고하지 않음(최숙진)」 기록을 명시적으로 덮어쓴다** — 계획서 독자 중에 그 발언 당사자가 있으므로, 번복 사실을 T3·T6 블록에 한 줄로 적어 둔다 |
| P-7 | **「565일·348행」은 부풀려진 수치** — 구 IA·검증·설정·오픈후 행까지 일수로 합산한 값 | 본문에서 **제거**. 654행 원장은 부록 링크로 격하 |
| P-8 | **담당 = 역할 5종 + 실명 7인** | 쇼핑개발 김동학 · 기술총괄/인쇄개발 서희항 · 실무운영 최숙진·김용기 · PM 신우진·지니 · 대표 결정 채훈희 |
| P-9 | **쓰기 0** — 라이브 DB·webadmin·셀러어드민·스킨 저장소 읽기 전용 | 전 기간. SELECT 만 |

## 3. 요구사항 (GEARS · 18항 — REQ 축만 예산 초과, §3-0 참조)

### 3-0. [HARD] 예산 초과 선언 — Tier 재판정 권고

`spec-workflow.md` § REQ/AC budget 은 Tier M 에 REQ 16 **AND** AC 16 을 독립 적용하고, 초과는
「예산을 완화하라는 신호가 아니라 **Tier 를 올리거나 SPEC 을 쪼개라는 신호**」로 규정한다.

본 SPEC 은 **REQ 18 · AC 16** — **AC 축은 예산 준수**, **REQ 축만 +2 초과**한다.

AC 는 강도 중립 병합 3건으로 19 → 16 이 됐다(구 004→003(b) / 구 016+017→015 / 구 019→007(d)).
셋 다 같은 파서 패스·같은 실패면을 공유하고, 소조건 `(a)(b)(c)(d)` 단위 위반 목록이 진단
해상도를 보존하므로 검사 강도를 잃지 않는다.

REQ 를 16 으로 줄일 **강도 중립 경로는 없다** — 유일 후보인 REQ-LP-015+016 병합은 016 의
과묶음을 재발시키고, 001+002 병합은 Ubiquitous 와 Unwanted 를 섞어 GEARS 를 깬다.
리드 판정(③ Tier M 유지 + 선언된 예외)에 따라 **REQ 한 축 초과만 예외로 선언**한다.
전체 기록은 `plan.md` §A-3.

> 판정 그레핑을 위해 본 SPEC 은 산출물 내부의 **안정된 마커 관습**을 지정한다(§4·acceptance.md 와
> 함께 계약을 이룬다): 섹션 `id="sec-01"`…`id="sec-13"`, 트랙 블록 `id="track-T1"`…`id="track-T7"`,
> 역할 진입점 `id="role-shopdev"`·`role-printdev"`·`role-ops"`·`role-pm"`·`role-exec"`,
> 체크리스트 최상위 행 `<tr data-role="top" data-step="…" data-std="…" data-owner="nhn|huni|ext" data-work="config|dev|wait">`
> · 하위 상세 행은 `data-role="detail"`(나머지 속성은 동일하게 보유), 증거 칸 `<td class="evidence">`, 목표일 칸 `<td class="duedate">`,
> 스윔레인 `id="diag-swimlane"`, CTO 10구간 매핑 `id="map-cto10"`, 시스템 배치도 `id="diag-topology"`,
> 판매 준비 프로세스 `id="sec-06"` 안의 메뉴 지도 `id="map-webadmin-menu"` · 옵션↔가격 도식
> `id="diag-option-price"` · 매뉴얼 요소 대조 요약 층 `id="map-manual-elements"` (전건 매트릭스는
> 접힘 부록 `id="manual-element-matrix"`),
> 마일스톤 `id="diag-milestone"`, 임계경로 `id="critical-path"`, 결정 안건 `id="decisions"`,
> Go/No-Go `id="go-no-go"`, 컷오버 `id="cutover"`, 하이퍼케어 `id="hypercare"`,
> RACI·의사소통 `id="raci"`, 부록 `id="appendix"`.

### A. 산출물 형태 — 문서 전체

- **REQ-LP-001** — Ubiquitous: The plan document shall be delivered as one self-contained Korean HTML file at `docs/huni/후니프린팅_오픈계획서_260917.html`, written for a non-developer audience of field staff and the CTO, referencing no external resource other than a web-font CDN and a mermaid CDN.
  - 해설: 배포물은 이 파일 하나. 별도 CSS/JS/이미지 파일을 만들지 않는다. 그림은 인라인 SVG 또는 mermaid 소스로 문서 안에 둔다.

- **REQ-LP-002** — Unwanted: The plan document shall not contain any dark-theme CSS rule, any `prefers-color-scheme` media query, or any theme-toggle control.
  - 해설: 「테마 토글 컨트롤」의 기계적 정의 — `id`/`class`/`data-*` 속성값 또는 인라인 스크립트 식별자에 `theme-toggle`·`themeToggle`·`toggleTheme`·`data-theme` 중 하나를 포함하는 요소. 이 정의 밖의 토글은 검사하지 않는다(정의를 넓히면 오탐이 난다).

- **REQ-LP-003** — Unwanted: The plan document's prose shall not contain internal codenames, the retired load figures, or any verdict on the 2026-10-06 open date, and shall mention 조판 at most once.
  - 해설(금지 4종과 **검사 범위**):
    - **내부 코드명 0** — 카드 ID(`S1`~`S5` · `R1`~`R5` 계열 단독 토큰) · `CARDS-` · 라운드 라벨 · 에이전트/하네스 이름.
    - **반려 수치 0** — `565일` · `348행`(P-7).
    - **오픈일 판정 0** — `10/6`·`10월 6일`·`2026-10-06` 이 판정 술어(`가능`·`불가`·`어렵`·`무리`·`힘들`·`충분`·`맞출 수`)와 **같은 문장에** 등장하지 않는다. 리터럴 2개 금지가 아니라 **구조 검사**다(P-1 이 최상위 전제이므로 게이트도 가장 두껍다).
    - **조판 1회 이하** — 출현 **횟수** 기준(줄 기준이 아니다 — 미니파이하면 줄이 합쳐진다).
  - **[HARD] 검사 범위**: 위 금지는 **산문 노드**에만 적용한다. 다음은 검사 대상에서 **제외**한다 — ① 증거 칸(`<td class="evidence">`) 및 `data-std`/`data-step` 속성값 ② `id="appendix"` 내부의 파일 경로 문자열 ③ 위험 식별자 표기(`R1`~`R10` 이 「위험 R1」 형태로 쓰인 경우) ④ 구간 ID `A1`~`E4`·`F1`~`F4`, 트랙 ID `T1`~`T7`, `std_id`(`STD-*`), 결정 번호 `D-P1`~`D-P9`. 이 제외가 없으면 REQ-LP-010(근거 인용 의무)과 REQ-LP-012(T1 위험 표기)가 본 조항과 **동시에 만족될 수 없다**.

- **REQ-LP-004** — Ubiquitous: The deliverable set shall consist of exactly three artifacts — the HTML plan (D1), a regenerated Excel workbook extending the existing R5 builder (D2), and a verification script (D3) — and the run phase shall create the output directory `_workspace/huni-launch-runway/07_rebaseline/S/S5-plan/` before writing D2 or D3.
  - 해설: D2 는 `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/R/R5/build_xlsx_v4.py` 를 **확장**한다(새 빌더를 처음부터 쓰지 않는다). D3 는 D1 을 기계적으로 검사한다.

### B. 문서 골격 — S0 §6 + 선언된 이탈 2건

- **REQ-LP-005** — Ubiquitous: The plan document shall carry thirteen sections in order with stable anchors `id="sec-01"` through `id="sec-13"` — ①1쪽 요약 ②범위 In/Out ③마일스톤 차트 ④주문 스윔레인 ⑤시스템 배치도 ⑥판매 준비 프로세스 ⑦트랙별 체크리스트 ⑧외부 의존·임계경로 ⑨Go/No-Go ⑩컷오버 런북 ⑪하이퍼케어·지원/CS ⑫RACI·의사소통 주기 ⑬부록.
  - 해설(**S0 §6 대비 선언된 이탈 3건** — 이 SPEC 은 S0 §6 을 「그대로」 채택하지 않는다):
    - **이탈 ①(추가)**: §5 시스템 배치도는 S0 §6 에 **없다**. Lightsail 이전(T1)이 첫 마일스톤이 된 이상 「무엇이 어디로 옮겨지는가」를 그림 없이는 읽을 수 없어 신설한다.
    - **이탈 ②(추가)**: §6 판매 준비 프로세스는 S0 §6 에 **없다**(지니 확정 260917 · REQ-LP-017). 실무진의 일상 질문이 「옵션을 바꾸면 어디서 가격이 정해지고 어느 화면에서 고치나」인데, 트랙 체크리스트는 그 답을 주지 못한다.
    - **이탈 ③(밀림)**: S0 §6 은 RACI·의사소통 주기를 10 에, 부록을 11 에 둔다. 신설 2건으로 두 칸이 밀려 RACI·의사소통 주기 = ⑫, 부록 = ⑬ 이 된다.
    - **비이탈**: 초판(0.1.0)에서 누락됐던 **의사소통 주기**(S0 가 필수로 판정한 요소 — 대상·메시지 수준·주기·채널·담당자)를 ⑪ 에 복원한다. 섹션 개수만 맞추고 필수 요소를 떨어뜨리지 않는다.

- **REQ-LP-006** — Ubiquitous: The scope section shall present 오픈 필수 and 오픈 후 as two separate tables, and shall state a three-line scope-freeze rule declaring that requests arriving after the freeze date are classified into the 오픈 후 backlog by default.

- **REQ-LP-007** — Ubiquitous: The swimlane section shall render one order's full journey across between three and seven lanes each naming a role or system **and carrying an ownership label drawn from exactly two values — `NHN 제공` or `후니 개발`**, and shall carry a mapping block (`id="map-cto10"`) that binds the CTO's ten segments as the upper layer to the twenty-eight process steps (`A1`~`E4`) as the lower layer, with every one of the ten segments carrying a one-sentence 「이게 없으면 무슨 일이 벌어지나」 consequence line.
  - 해설: 재작성의 근거가 「CTO 가 구간으로 사고한다」인데 척추가 2.8배로 잘게 쪼개졌다. 읽는 사람의 언어(10구간)를 상위에 두고 작업 격자(28구간)를 그 아래로 접는다. CTO 문서가 5분 안에 읽히는 이유가 구간마다 붙은 **영향 한 문장**(예: 「결제는 됐는데 무엇을 만들지 모르는 주문이 됩니다」)이므로, 그 문장을 매핑 블록의 필수 칸으로 계약한다.

### C. 틀을 이루는 세 섹션 — 5분 이해를 실제로 책임지는 곳

- **REQ-LP-008** — Ubiquitous: The one-page summary (`id="sec-01"`) shall carry all six elements — 무엇·왜 · 현재 RAG 상태 · 상위 리스크 3~4건 · 다음 마일스톤과 목표일 · 롤업 타임라인 · 상태 범례 — within 700 Korean characters of body prose; the milestone chart (`id="diag-milestone"`) shall carry between four and six milestones each with an owner (실명) and a state, with T1 first; and the topology diagram (`id="diag-topology"`) shall carry at most twelve nodes, each labelling the system name, its owner (실명), and an ownership label drawn from exactly two values — `NHN 제공` or `후니 개발`.
  - **[HARD] 소유 라벨 — 열거형 2값 고정**(지니 정정 260917). `NHN 제공` = Shopby SaaS(셀러어드민 · 주문/결제/회원 원장 · Shop/Server API · NCPPay) · `후니 개발` = 자사몰 스킨 `shopby.huniprinting.co.kr`(김동학) · webadmin · 위젯 · 가격엔진 · DB(서희항). **그 밖의 값 0건**(결과 4종 집합과 같은 방식으로 고정한다). 라벨이 빠지면 NHN 이 제공하는 기능이 「우리가 개발할 것」으로 섞여 들어가 **임계경로가 실제보다 길게** 나온다 — 외부 대기가 지워져 짧게 나오는 것의 정확한 거울상이다. 기계 판정은 AC-LP-005(c)(배치도) · AC-LP-004(a)(스윔레인) · AC-LP-006(e)(분류 제약).
  - 해설: 세 섹션 모두 「양을 제한하는 것」이 계약의 핵심이다. 요약이 길어지면 요약이 아니고, 마일스톤이 7개를 넘으면 임원용이 아니며, 배치도 노드가 12개를 넘으면 한 눈에 안 들어온다. 상태 범례는 RAG 각 색의 의미를 **수치로** 정의한다(예: 마일스톤 2주+ 지연 = Red).

### D. 체크리스트 — 「내 자리」가 성립하는 곳

- **REQ-LP-009** — Ubiquitous: The plan document shall carry one checklist block per track `id="track-T1"` through `id="track-T7"`; each block shall carry between three and five top-level rows marked `data-role="top"`, with any finer breakdown carried as `data-role="detail"` rows inside a collapsed container or in the appendix; and every top-level row shall carry all six fields — 담당(실명 또는 「외부(<대상>)」) · **목표일** · 완료 증거 · 체크 방법(한 문장) · 선행 · 상태 — and every checklist row shall additionally carry two attributes, `data-owner` ∈ {`nhn`, `huni`, `ext`} and `data-work` ∈ {`config`, `dev`, `wait`}, where no row with `data-owner` ∈ {`nhn`, `ext`} carries `data-work="dev"` and `data-work="wait"` occurs only on rows with `data-owner="ext"`.
  - 해설(**두 가지가 신설됐다**):
    - **행 수 상한** — S0 §6-5 는 「트랙당 3~5항목」이다. 상한이 없으면 트랙 제목을 씌운 300행 표가 모든 기계 검사를 통과하고, 그것은 9/16 에 반려된 물건과 구조적으로 같다. 654행 원장은 `data-std` **다중값**으로 최상위 행에 매단다(행을 늘려서 담지 않는다).
    - **목표일 칸** — S0 §6-5 의 원문 계약은 「담당·완료 증거·**마감**·상태·블로커」다. 초판은 마감→체크 방법, 블로커→선행으로 바꿔치기하고 그 사실을 적지 않았다. 마감(목표일)을 여섯 번째 칸으로 **복원**한다. 성공 정의가 「자기 일을 체크하고 **일정을 잡는다**」인 이상 날짜 칸 없는 표로는 성공 기준을 만족할 수 없다.
    - **소유·분류 두 속성**(지니 정정 260917) — 여섯 칸을 늘리지 않고 **속성**으로 싣는다(칸을 늘리면 6칸 계약이 깨진다). `data-owner="nhn"` = NHN 제공(Shopby SaaS · 셀러어드민 · 주문/결제/회원 원장 · Shop/Server API · NCPPay) · `"huni"` = 후니 개발(스킨·webadmin·위젯·가격엔진·DB). `"ext"` = **외부 벤더**(이니시스 PG · 토스페이먼츠 · MES 벤더 · 구 사이트 운영사 · 인프라팀 · NHN 계약 창구 — 확정 전제 P-8 의 역할 5종 중 「외부」이고, 담당 칸의 `외부(<대상>)` 형식과 짝을 이룬다). `data-work="config"` = 설정/확인 · `"dev"` = 개발/수정 · `"wait"` = 회신·계약·심사 대기. **[HARD] `data-owner` ∈ {`nhn`, `ext`} 인 행은 `data-work="dev"` 를 가질 수 없고, `data-work="wait"` 은 `ext` 전용이다** — 두 금지의 이유는 같다: **우리가 고칠 수 있는 대상이 아닌 것을 「개발/수정」으로 분류하면 임계경로가 부풀려진다.** 다만 성격이 다르다 — `nhn` 은 **이미 제공되는 것**(설정만 하면 된다)이고 `ext` 는 **아직 오지 않은 것**(기다려야 한다). `wait` 가 그 차이를 표시하며, `wait` 행의 집합은 `REQ-LP-015`·`AC-LP-012(b)` 의 **「§8 선행/외부 대기 항목」과 같은 집합**을 가리킨다(같은 것을 다른 각도에서 보는 두 장치이므로 한쪽만 고치지 않는다). 셀러어드민에서 관측한 항목은 **「설정/확인」만** 허용한다. 실무진 관점에서도 답이 달라진다 — 셀러어드민이면 답은 「NHN 설정에서 확인」이지 「개발 요청」이 아니다(AC-LP-016(e) 가 묻는 「어느 화면에서 고치나」에 이 라벨이 답한다).
    - **체크 방법**은 실무진이 그대로 따라 할 수 있는 한 문장이어야 한다 — 행위 동사(`열`·`누르`·`접속`·`조회`·`실행`) 1개 이상 + 화면 지시어(`화면`·`메뉴`·`페이지`·`콘솔`·`목록`) 1개 이상, 15자 이상. 「확인」 한 글자는 체크 방법이 아니다.

- **REQ-LP-010** — Ubiquitous: Every top-level checklist row shall carry an evidence citation in `<td class="evidence">` that resolves — a `파일:줄` citation whose path exists and whose line number does not exceed that file's line count, or a `URL@일시` citation — and shall carry the ledger identifiers it covers in `data-std`, every value of which exists in `unified-ledger-v4.csv` (the literal `NEW` is permitted only with a stated reason).
  - 해설: 모양만 맞는 인용(`메모:3`)은 근거가 아니다. 경로 실재와 줄 번호 상한까지 검사한다 — 바로 옆 `data-std` 는 원장 실재를 대조하는데 증거 칸만 정규식으로 통과시킬 이유가 없다.

- **REQ-LP-011** — Ubiquitous: Every checklist row shall carry a `data-step` attribute naming one of `A1`…`E4` or `F1`…`F4`, and the plan document shall carry five role entry points (`id="role-shopdev"` · `role-printdev` · `role-ops` · `role-pm` · `role-exec`), each listing that role's rows gathered from all seven tracks.
  - 해설: 반려 진단의 셋째 결핍은 「자기 할 일을 찾을 자리가 없다」였다. 트랙 구조만으로는 최숙진 실장이 자기 일을 찾으려고 7트랙을 전부 훑어야 한다. 데이터는 담당 칸에 이미 있으므로 **렌더를 한 번 더 할 뿐** 새 조사는 없다.

### E. 트랙별 필수 내용

- **REQ-LP-012** — Ubiquitous: Track T1 shall be presented as the first milestone and shall state the Lightsail migration's four stages (F1~F4), the nine entry conditions that must hold before the end-to-end open test begins, the two irreversible steps (F3-11 Railway 종료 · F4-8 Vercel 정지) as gated on open-test pass, and a re-verification row for the login redirect's absolute-origin correction.
  - 해설: T1 이 첫 마일스톤인 이유는 작업량이 아니라 **의존 밀도**다(미해결 차단 입력 24건 중 9건이 T1). 진입 조건 9항은 `S4-infra/migration-plan.md` §3 을 승계한다.

- **REQ-LP-013** — Ubiquitous: Track T4 shall be presented in three stages — ①설계 결정 주(D-P1~D-P9, each with a named decider) ②구현 ③종단 테스트 — and shall state each segment's current status verbatim from the measurement: `C1`·`C2`·`C3 수신` = 구현-미검증, and `C3 해석`·`C4`·`C5`·`C6`·`C7` = 없음.
  - 해설: 상태 값은 열거형 소속이 아니라 **실측값 그대로**여야 한다. C4 를 「작동」으로 적으면 계획서가 거짓말을 한다. PitStop 은 코드 이전에 조달 문제이므로 조달 리드타임 자체가 임계경로임을 함께 적는다.

- **REQ-LP-014** — Ubiquitous: Tracks T3 and T6 shall each present the migration as a six-step sequence — ①구 DB 접근 확보 ②스키마 분석 ③매핑 설계 ④이관 스크립트 ⑤샘플 검증→전량 리허설(건수 지문·잔액 합계 대사) ⑥컷오버 delta 동기화 — where exactly two of those six steps' dependencies are marked 외부(Shopby 회원 생성 경로 · 구 DB 접속 권한); and track T6 shall **additionally** carry 토스페이먼츠 계약 and Shopby 엔터프라이즈 플랜·외부포인트 정식 적용 as external waiting items outside the six-step sequence.
  - 해설(**감사 지적 반영**): 확정 전제의 「외부 의존은 딱 둘」은 **이관 6단계 그 자체**에 걸리는 조건이지 트랙 전체의 외부 의존 총량이 아니다. T6 는 6단계 밖에 토스 계약·Shopby 엔터프라이즈 플랜이라는 별개 외부 대기가 있고, 그것을 지우면 REQ-LP-015 의 임계경로가 실제보다 짧게 나온다. 또한 「Shopby 회원 생성 경로」는 T3 의 의존이지 T6 의 의존이 아니다 — T6 의 두 번째 외부 의존은 구 DB 접속 권한과 짝을 이루는 잔액 스냅샷 원천이다. 담당은 **미확정** 표기를 동반한다(스크립트 = 인쇄개발 서희항/지니 · Shopby 측 적재 = 쇼핑개발 김동학 — 기본배정). 잔액 대사는 **1원 차이도 NO-GO**.

### F. 일정·판정·운영

- **REQ-LP-015** — Ubiquitous: The critical-path section (`id="critical-path"`) shall build the schedule forward — 필요 항목 전부 → 의존·외부 대기 → 임계경로 → 도출되는 현실적 오픈일 — shall render the `쓰기경로-dev환경필요` set from the manual-element matrix as 선행/외부 대기 항목 cross-referenced with the T1 entry conditions; and the decisions section (`id="decisions"`) shall raise 날짜·인원·범위 as three levers, each with a named decider.
  - **[HARD] `쓰기경로-dev환경필요` 는 문장이 아니라 항목으로 실린다**(AC-LP-012(b)). 이 집합은 「dev 환경이 서기 전에는 판정 불가」라는 뜻이므로 그 자체가 선행 조건이다. 요약 층의 언급만으로 두면 일정 계산에 들어오지 않고, 그러면 **판정 불가 경로가 임계경로에서 사라진다** — 외부 대기(토스 계약)가 지워져 임계경로가 짧게 나오던 것과 같은 계열의 실패다.
  - 해설: REQ-LP-003 이 금지(판정 없음)를 맡고, 이 조항이 의무(날짜 도출)를 맡는다. 문서는 날짜를 **도출**하고, 그 날짜를 어떻게 할지는 사람이 고른다. 외부 대기 항목은 미해결 입력 통합표의 차단 항목을 회신 요청 대상(실명 또는 외부 기관)과 함께 렌더한다.

- **REQ-LP-016** — Ubiquitous: The plan document shall carry four operating sections — a Go/No-Go scorecard (`id="go-no-go"`) declaring Green/Yellow/Red/Unknown with Unknown treated as blocking, exactly one 결정권자 by real name, and a fixed decision-meeting date; a cutover runbook (`id="cutover"`) whose every row holds 순서·담당 실명·선행조건·검증 증거·비상조치 plus a rollback trigger stated as a measurable threshold with a named decider and a time limit; a hypercare section (`id="hypercare"`) whose exit criteria are stated as metrics with numeric thresholds rather than a calendar date; and a RACI·communications section (`id="raci"`) with exactly one Accountable per row plus the communication cadence (대상·메시지 수준·주기·채널·담당자).
  - 해설: 「데이터 없음」을 통과로 취급하면 판정이 아니다. 「그 절차는 누가 안다」로 적힌 단계는 준비되지 않은 단계다. 롤백은 토론이 아니라 임계값으로 발동한다. 하이퍼케어 종료 기준의 기계적 정의 — 각 기준 문장이 숫자와 단위/비교어(`이하`·`이상`·`미만`·`%`·`건`)를 포함하고, 날짜 리터럴(`\d{4}-\d{2}-\d{2}`·`\d+월 \d+일`)을 포함하지 않는다.

### G. 판매 준비 프로세스 — 실무진의 일상 질문에 답하는 절

- **REQ-LP-017** — Ubiquitous: The 판매 준비 프로세스 section (`id="sec-06"`) shall carry three blocks — a complete webadmin menu map (`id="map-webadmin-menu"`) enumerating all 37 menus (사이드바 33 + 비사이드바 4) with a gap column on every row, and stating the gap count as a number **accompanied by the gap criterion it used and the source path**; an option-to-price wiring diagram (`id="diag-option-price"`) tracing 상품 구성요소 → 가격공식·가격구성요소·단가표(`use_dims` 12축) → 위젯 cfg·기본값 → 고객 화면 → `/api/w/v1/price`, with every stage labelling the webadmin screen on which it is edited; and a manual-element conformance matrix whose summary layer (`id="map-manual-elements"`) sits in the section body while its full per-element rows sit in a collapsed appendix block (`id="manual-element-matrix"`) that also states the CSV source path.
  - 해설(지니 확정 260917): 실무진이 그림 **한 장**으로 「옵션을 바꾸면 어디서 가격이 정해지고 어느 화면에서 고치나」를 알 수 있어야 한다. 도식의 각 단계는 **고치는 화면 이름**을 반드시 달고 있어야 한다 — 그것이 없으면 그림이 아니라 개념도다.
  - **[HARD] 실측의 깊이 = 매뉴얼 원고 요소와의 1:1 대조**(지니 결정 260917). 메뉴 지도의 실측 열은 「메뉴가 렌더된다」까지만 말한다 — 그 깊이로는 §G 판매 준비 프로세스도 §H 상태 판정도 뒷받침되지 않는다. 그래서 세 번째 블록으로 **매뉴얼 요소 대조 매트릭스**를 둔다.
    - **행** = 매뉴얼 원고(`raw/webadmin/tools/manual_content.py` **1,468행** · `widget_manual_content.py` **1,117행** · 합 2,585행)의 `SCREENS` / `MODEL_ADMIN_SCREENS` 에 기술된 **화면별 요소·버튼·패널 전건**.
    - **열** = 화면 · 매뉴얼 원문 위치(`파일:줄`) · 요소 · 경로 종류(읽기/쓰기) · 실측 결과.
    - **실측 결과 값 집합은 정확히 4종이고 그 밖의 값을 쓰지 않는다** — `동작확인(URL@일시)` · `불일치(URL@일시+차이)` · `쓰기경로-dev환경필요` · `미실측(사유)`.
    - **읽기 경로**(탭·필터·검색·상세·미리보기·진단·다운로드 열기)는 ego-browser p2 에서 **실제로 눌러** 판정한다.
    - **쓰기 경로**(등록·수정·삭제·게시·저장)는 라이브에서 누르지 않고 `쓰기경로-dev환경필요` 로 둔다. 이 값을 가진 행의 집합이 **T1 오픈 테스트 진입 조건과 연결됨을 문서가 한 줄로 명시**한다 — dev 환경이 서기 전에는 이 경로들이 판정 불가라는 사실이 곧 진입 조건이다.
  - **[HARD] 층 분리 — 읽는 문서와 참조 자료를 나눈다.** 원고 2,585행에서 도출되는 요소 전건은 수백 행 규모일 수 있고, 그것을 §6 본문에 그대로 실으면 §6 이 **행 목록**이 되어 9/16 반려 원인이 §7 에서 §6 으로 이사한다(`AC-LP-016(e)` 사람 판정이 정확히 그것을 잡는다). 매트릭스는 전건 그대로 만들고 문서에도 싣되, **어디에 싣는가**를 계약한다:
    - **본문 = 요약 층**(`id="map-manual-elements"`) — 화면 단위 집계(화면 수 · 요소 수) · 결과 4종 분포 · **불일치 행 목록** · **`쓰기경로-dev환경필요` 행 목록**. 뒤 두 목록은 접지 않는다 — 전자는 고쳐야 할 것이고 후자는 T1 진입 조건에 걸리는 것이라 실무진이 펼치지 않고 봐야 한다.
    - **부록 = 전건 층**(`id="manual-element-matrix"`) — `<details>` 접힘 블록 + CSV 원본 경로(`S/S5-plan/manual-element-matrix.csv`) 명시.
  - **[HARD] 요소 전건의 분모도 상수로 박지 않는다.** 갭 수와 같은 실패형이다(「외부 의존 딱 2건」·「갭 6」 두 번 다 감사에 잡혔다). 문서는 **분모 산출 규칙**(어느 파일의 어느 최상위 구조를 열거하고, 무엇을 요소 1건으로 세는가 — 그리고 그것을 재현하는 명령)을 선언하고, 검사는 **3항 사슬 관계**로만 이뤄진다 — `원고 grep 분모 == 부록/CSV 행 수 == 본문 요약 층 집계 수`. 어느 지점에도 숫자를 박을 자리가 없으므로 상수화가 구조적으로 불가능하고, 동시에 **층 분리가 요약과 전건을 어긋나게 만드는 위험**(본문엔 12건, 부록엔 340행)을 같은 검사가 함께 잡는다. 기계 판정은 `AC-LP-014(e)`.
  - **[HARD] 갭 개수를 상수로 고정하지 않는다.** 갭 판정 기준이 원천마다 다르다 — 원장 CSV 의 갭 열은 판독에 따라 13(실질 텍스트) / 11(비결함 2건 제외) / 5(★ 표기)로 갈리고, 오늘자 실측은 매뉴얼 갭 **3건**으로 읽는다. 어느 판독으로도 단일 상수가 나오지 않으므로, **수를 요구사항에 박지 않고 「수 + 판정 기준 + 원천」을 문서가 선언하게** 한다. 상수를 박으면 정직한 문서가 FAIL 하고 통과하는 유일한 길이 「갭 표기를 그 수에 맞춰 조정하는 것」이 된다 — 기계 검사가 문서 왜곡을 보상하는 형태이며, 이 절의 존재 이유(실무진이 화면을 찾게 하는 것)가 먼저 깨진다.
  - 정본 입력(읽기 전용 · 메인 체크아웃 절대경로): `.claude/rules/moai/domains/huni-product-lifecycle.md` §1 6단계·§2 네 결정 · `.claude/rules/moai/domains/huni-pricing-engine-map.md` · `_workspace/postersign-audit/widget-contract-260829.md` · `_workspace/huni-widget-flow/02_mermaid` · `R/R1b/evidence/menu-map.csv`(37행) · `S/S5-live/menu-map-260917.csv`(37행 · 오늘자 재실측) · `S/S5-live/option-price-trace.md`(**mermaid 연결 도식 실재 — 도식의 실입력**) · `R/R1b/findings.md` §4(3상품 종단표) · webadmin 매뉴얼 2종 `raw/webadmin/tools/manual_content.py`·`widget_manual_content.py`.
  - 도메인 정본이 못 박은 두 문장을 도식에 그대로 싣는다 — 「위젯의 선택지는 전부 상품 설정에서 온다」·「**위젯은 가격을 정하지 않는다** — 금액은 가격공식·단가표·할인테이블이 정하고 위젯은 결과를 보여 줄 뿐이다」. 실무진이 ④에서 이상한 값을 보면 ③을 고쳐야 한다는 것이 이 절의 실용적 목적이다.

### H. 상태 판정의 근거 규율

- **REQ-LP-018** — Ubiquitous: Every checklist row whose 상태 is `작동` shall carry a `URL@일시` evidence citation obtained by live screen observation; a row shall not be marked `작동` on code or DB evidence alone.
  - 해설(지니 확정 260917 · [HARD]):
    - **라이브 판정은 ego-browser 로만 한다** — space **20** 재사용(p1 신규몰 · p2 webadmin · p3 셀러어드민 · p4 구 사이트). 자기 탭만 쓰고 새 space 를 만들지 않는다.
    - **[HARD] 「전건 재실측」의 뜻을 한정한다** — 이 조항이 요구하는 것은 「28구간을 모두 한 번씩 본다」가 **아니라** 「**`작동` 으로 적을 행은 전부 화면 근거를 갖는다**」이다. 기계 판정(AC-LP-007(d))도 딱 그것만 검사한다. 넓게 읽으면 실제 AC 보다 무거운 의무가 생겨 M0 가 완료 불가로 보인다(요소 수준의 1:1 대조는 §G 의 매뉴얼 요소 대조 매트릭스가 맡는다 — REQ-LP-017).
    - run 단계 M0 의 재실측 절차가 곧 각 행의 **체크 방법 문장**이다 — 체크 방법 칸은 장식이 아니라 M0 에서 실제로 실행되는 절차이고, 따라 갈 수 없는 문장은 그 자체로 결함이다(REQ-LP-009 의 실질 요건과 같은 방향).
    - **[HARD] 승계의 한계**: 오늘 시점의 입력 조사(S1~S4)는 **코드·문서만** 본 것이다. 따라서 `작동` 표기는 **9/16 라이브 실측 승계분에 한정**된다. 입력 카드가 `구현-미검증`으로 적은 행을 화면 확인 없이 `작동`으로 승격시키는 것은 금지한다 — 미관측은 부재의 증거가 아니지만, 마찬가지로 **미관측은 작동의 증거도 아니다**.
    - S5(오늘자 ego-browser 실측 — webadmin 37메뉴 재확인 · 3상품 옵션↔가격 종단 추적 · 신규몰 주문 흐름)가 도착하면 M0 가 이를 소비한다. 도착 전에도 M0 는 자체 재실측으로 진행한다.

## 4. 범위에서 제외하는 것 (exclusions)

이 절은 계획서 본문에 **넣지 않을 것**을 확정한다. 아래 항목이 문서에 등장하면 그 자체가 결함이다.
기계 판정은 REQ-LP-003(Unwanted)이 담당하고, `acceptance.md` AC-LP-002 가 검사한다.

### Out of Scope — 조판(imposition)

- 조판 도입 여부·방식·도구는 오픈 후 마지막에 결정한다(P-4).
- 계획서 본문에서 조판 언급은 **출현 1회 이하**로 제한한다. 오픈 후 트랙에도 항목으로 넣지 않는다.

### Out of Scope — 라이브 시스템 변경

- 라이브 DB·webadmin·셀러어드민·스킨 저장소에 대한 쓰기·배포·설정 변경(P-9).
- 실주문 생성·결제 실행·알림 실발송·파일 삭제.
- 비밀값(토큰·키·비밀번호)의 산출물 기재 — env 키 이름으로만 참조한다.

### Out of Scope — 새 조사·재수집

- 654행 원장(`unified-ledger-v4.csv`)의 재실측·재분류. 이 SPEC 은 기존 산출물을 **다시 엮는** 작업이지 다시 조사하는 작업이 아니다.
- 스킨·webadmin 코드의 신규 역공학. 기존 조사 산출물과 증거를 재사용한다.
- **예외(제외 아님)**: 라이브 **화면 관측**은 REQ-LP-018 이 의무화한다. run 단계 M0 의 ego-browser 재실측은 새 조사가 아니라 **상태 판정의 필수 근거**이며, 읽기 전용 탐색만 한다(저장·주문·결제·삭제·발송 버튼 0). M1.5 의 **매뉴얼 요소 대조**도 같은 예외에 속한다 — 원고(`manual_content.py`·`widget_manual_content.py`)는 기존 산출물이고, 화면 쪽은 읽기 경로만 눌러 보는 **읽기 전용 관측**이다. 쓰기 경로는 라이브에서 누르지 않는다.

### Out of Scope — 오픈 후 기능

- 네이버페이 연동, 회원 잔액 이관 이후의 운영 정산, 리뷰 보상 설계.
- 이 항목들은 계획서 「오픈 후」 표에 **행으로만** 존재하고, 트랙 체크리스트를 갖지 않는다.

### Out of Scope — 반려된 수치와 표현

- 「565일」·「348행」 등 합산 부하 수치(P-7).
- 오픈일에 대한 판정 문장 — 판정 술어와 오픈일이 같은 문장에 오는 형태 전부(P-1).
- 다크 테마 CSS·테마 토글(REQ-LP-002).

## 5. 성공 기준 요약

| # | 기준 | 판정 방식 |
|---|---|---|
| SC-1 | 5분 이해 + 자기 일 지목 + 체크 방법 실행 + 옵션↔가격 화면 지목 | **사람 판정(AC-LP-016)** — CTO 시점 리뷰어 1인 + 실무운영 시점 리뷰어 1인, 5문항. **기계 검사 아님 — 기계로 구현하려 들지 말 것** |
| SC-2 | 금지 4종 0건(코드명·반려 수치·오픈일 판정·조판 2회+) | 기계 검사(AC-LP-002) |
| SC-3 | 다크 테마 0건 | 기계 검사(AC-LP-001) |
| SC-4 | 전 최상위 행이 실재하는 근거 보유 | 기계 검사(AC-LP-007(a)(b)(c)) — 경로 실재 + 줄 번호 상한 |
| SC-5 | 트랙당 최상위 행 3~5 · 6칸 완비 | 기계 검사(AC-LP-006) |
| SC-6 | 역할별 진입점 5블록 | 기계 검사(AC-LP-008) |
| SC-7 | C1~C7 상태가 실측값과 일치 | 기계 검사(AC-LP-010) — 값 대조 |
| SC-8 | 판매 준비 프로세스 3블록(37메뉴 지도 · 옵션↔가격 도식 · 매뉴얼 요소 대조 매트릭스) | 기계 검사(AC-LP-014) — 갭 수·요소 분모 모두 상수 아님(수 대신 3항 사슬 관계 검사) |
| SC-9 | `작동` 전 행이 `URL@일시` 근거 보유 | 기계 검사(AC-LP-007(d)) |

> [HARD] 이 표의 AC 번호는 `acceptance.md` 의 실제 배치(§A 001~014 · §B 015 · §C 016)와
> 일치한다. **SC-1 은 §C 사람 판정이다** — SC 표를 보고 기계 구현으로 가면 이 SPEC 이 가장
> 경계하는 실패(대리 지표 치환)를 저지르는 것이다.

## 6. 참조

- 골격 권위: `_workspace/huni-launch-runway/07_rebaseline/S/S0-bestpractice/research.md` §6
- 프로세스 척추(하위 28구간): `_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md` §1
- 프로세스 척추(상위 10구간)·영향 문장: `docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html`
- 원장: `_workspace/huni-launch-runway/07_rebaseline/R/R2/unified-ledger-v4.csv` (654행 · `std_id`)
- 집필 관습 선례: `.moai/specs/SPEC-LAUNCHGUIDE-001/spec.md`
