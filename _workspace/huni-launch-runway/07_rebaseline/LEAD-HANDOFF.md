# lead 인계 문서 (2026-09-02 · Opus 5 → Fable 5.1)

읽는 순서: **이 문서 → `L0/CARDS-N.md` → `L0/LEAD-VERDICT-M.md`**. 나머지는 필요할 때만.

## 0. 이 작업이 무엇인가

지니 지시(원문 요지): `huni-skin-shopby` 와 `raw/webadmin` 을 읽고, `docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx` 양식대로 **역할별 기능리스트**를 정의하고, **2026-10-06 오픈**을 위한 전체 일정 체크리스트를 만든다. **엑셀로 먼저 접근하지 말고** 인쇄 쇼핑몰에 필요한 기능을 최대한 상세히 목록화해 **남은 기능**을 확인하고, **오픈 시점별 테스트 시나리오**까지 쓴다. 문서는 **시각화 다이어그램·아티팩트·인터랙티브·후니 디자인시스템·테마모드**로 낸다.

오늘 = 2026-09-02. **D-34.**

## 1. 확정 전제 (지니 승인 · relitigate 금지)

| 축 | 확정 |
|---|---|
| 기능 분모 | 표준 기능목록 **신규 수립** + 기존 716건 원장 **병합**(ID 보존) |
| 역할 축 | **3인** — PM / 인쇄개발 / 쇼핑개발 (260616 IA `01_역할정의` 일치). 런웨이 4담당은 되접기 |
| 마일스톤 | **10/6 오픈 + 중간 게이트 재설정**. 8/30 기준 기존 배정 폐기 |
| 산출 | 인터랙티브 아티팩트 + 엑셀 5시트 + 마크다운 원장/JSON — **3종 전부** |
| 실행 | 칸반 lead + `plan`/`run`/`sync` 3 lane. lead 는 **조사하지 않고 배분·검증·합침**만 |

## 2. ★ 지니가 준 구조 사실 (재확인 불요 · 조사 전제)

`L0/CARDS-M.md` §「지니가 준 구조 사실」 10개가 원문이다. 요약:
`huni-skin-shopby`=쇼핑몰 전반 · `raw/webadmin`=**위젯**(상품구성요소+가격구성요소 결합, **파일업로드·Edicus 포함**, 편집버튼→Edicus 이미 구현) · **위젯이 쇼핑몰에 임베딩** · 둘은 **SDK+API 로 리소스 공유(webadmin 매뉴얼에 상세)** · 전체 결합 확인은 **환경변수의 webadmin 라이브 사이트** · shopby=**NHN 헤드리스, server API 연동** · **MES 별도 시스템**(위젯이 자재·공정 전달→생산지시→상태값 왕복) · **프리플라잇**(접수 전 PDF 검사) 필요 · 인쇄데이터→생산→**공정라우트**→포장→배송 · 이 영역은 지니+서희항 대표가 레드프린팅에서 개발한 영역이라 **할 수 있지만 리스트에는 나와야 함**.

## 3. ★ 전임 lead 가 틀린 7건 — 같은 실수를 반복하지 마라

| # | 오류 | 실제 | 교훈 |
|---|---|---|---|
| 1 | 「에디터 미배선·업로드 stub」 | 위젯 안에 이미 구현 | **shopby 코드만 grep 하고 위젯(webadmin)을 안 봤다** |
| 2 | 위젯 API 27개 | **22개** | `api/assistant` 5건을 위젯으로 오집계 |
| 3 | Shopby API 31개 | **38개** | 고정 접두사 정규식 과소집계 |
| 4 | 「L1 에 생산축 통째 부재」 | **38행 실재** | 확인 없이 단정 |
| 5 | `t_ord_orders` 0행 = 미구현 | **PG 결제승인 대기로 미실행** | **0행은 미구현의 증거가 아니다** |
| 6 | L1 완료조건에 역방향 커버리지 없음 | 23건 누락 발생 | 분모 신규 수립 카드엔 **역방향 완료조건 필수** |
| 7 | 조각(기능목록) 먼저, 전체 그림 나중 | 순서 역전 | **아키텍처 지도가 선행** |

**뿌리 원인 하나**: lead 가 파일 3~4개를 직접 읽고 시스템을 판정했다. 지니 지적 — 「**이런 부분을 너가 하지말고 어떤 일을 할지를 잘 정해서 각 레인에게 역할을 맡기면** 좋을 것 같아」. lane 은 **한 번도 틀리지 않았고 매번 lead 오류를 잡았다.**

## 4. ★ 지켜야 할 규칙 (전부 지니가 준 것)

1. **lead 는 직접 조사하지 않는다.** 축을 설계하고 배분하고 교차검증해 합친다. 원장 «내용»을 컨텍스트에 담지 않고 완료조건·evidence 경로만 읽는다.
2. **1차 참조 순서**: webadmin 앱 내장 매뉴얼 2종 → **SDK 개발가이드**(`huni-admin.printly.co.kr/sdk/guide/` · 보존본 `L0/M2/_evidence/sdk-guide-live-20260902.txt` 2,132줄) → **라이브 실화면** → 코드. **코드부터 열면 오진한다**(오류 1번).
3. **등급 기본값은 「작업 항목」.** 「차단」은 **우리가 통제 못 하는 외부 의존**에만. 지니 — 「오픈전에 처리를 할 수 있는 영역이기 때문에 리스트를 넣되 **너무 심각하게 생각하지 않았으면** 한다」. 메모리 `feedback-risk-tone-260902`.
4. **카드마다 [HARD] 「초안을 존중하지 마라」** — 이게 lead 오류 3건을 잡았다. 반드시 유지하라.
5. **완료는 읽은 증거로 판정.** lane 주장 비신뢰. 기계 검산 가능한 것은 lead 가 직접 센다.
6. **라이브는 읽기전용.** 주문·결제·폼제출·DB write 금지. 모르면 「미확인」(추정 금지).
7. 카드 사이 lane **`/clear`** (사용자가 직접 입력 — lead 가 요청).
8. 워크트리 미사용 — lane 마다 겹치지 않는 디렉터리에만 쓰고 커밋은 안 한다.

## 5. 완료된 것 (전부 lead 기계 검산 통과)

| 산출 | 위치 | 수치 |
|---|---|---|
| L1 표준 기능목록 | `L1/standard-feature-canon.csv` | **353행** · 16대분류 · 근거빈칸 0 (단 누락 23건 · 생산축 세분 거칢) |
| L2 현행 실측 | `L2/as-is-inventory.csv` + `service-dependency.json` | **124행**(done96/partial14/stub9/absent5) · 서비스 **18종** |
| L3 legacy 정규화 | `L3/legacy-normalized.json` | **716건**(runway410+scope162+ia144) · 유실 0 · ID 보존 |
| L4 병합 | `L4/{a,b,c}/mapping.csv` | 353/353 커버 · done80/partial76/todo130/**new67** · 고아 120(정상 64 + L1 누락 56) |
| M1 위젯 본체 | `L0/M1/` | payload **25키** 전수 · 자재 4경로 · handoff 192건(성공179) |
| M2 연동 계약 | `L0/M2/` | SDK 가이드 발굴 · 접점 6 · 프로모션 판정 |
| M3 생산·MES | `L0/M3/` | 생산축 **135행** · auto-vs-human 분계 · MES/프리플라잇/공정라우트 판정 |
| lead 검산 | `L0/LEAD-VERDICT-M.md` | 등급 재조정 · 지니 질문 답 · M1 검산 |

**명세 4종**: `CARDS.md`(L1~L6 + §4 인계 9건 + §6 고아분류) · `L0/CARDS-M.md` · `L0/CARDS-N.md` · `L0/ARCHITECTURE.md`(**오류 포함 초안 — N3 가 v2 로 대체 중**).

## 6. 지금 돌고 있는 것 (중단하지 마라)

| lane | 카드 | 산출 예정 |
|---|---|---|
| `plan-huniweb [5d5bad]` | **N1 shopby 플랫폼 전체 플로우** | `L0/N1/shopby-order-state-machine.md` 외 7종 |
| `run-huniweb [a067ab]` | **N2 분모 보강 3갈래** | `L0/N2/standard-feature-canon-v2.csv` 외 5종 |
| `sync-huniweb [941347]` | **N3 지도 v2** | `L0/N3/ARCHITECTURE-v2.md` 외 3종 |

명세는 `L0/CARDS-N.md`. **lane 이름은 반드시 `[ref]` 를 붙여 보내라** — 7일 전 원격 동명 세션이 있어 bare name 은 거부된다.

## 7. 남은 일 (순서 고정)

1. **N 종료 → lead 검산·합침** — N1 상태머신 ↔ N3 지도 v2 의 「주문 이후」 절 · N2 분모 확정
2. **테스트 시나리오** — N1 상태머신 없이는 성립 불가(어느 상태에서 무엇이 가능한지 모름). M3 `auto-vs-human.md` 가 **자동/사람 분계**의 근거
3. **L5** — 3인 역할배정(쇼핑개발은 web|builder 겸임, 부하 **합산**) · 10/6 역산 중간 게이트 · 관측가능 `done_criteria` 전건 · **10/6 가능성 정직 판정**(불가면 불가로 쓰고 시나리오만 제안 — 범위 결정은 PM)
4. **L6** — 마크다운 원장/JSON → 260616 양식 엑셀 5시트 → **인터랙티브 아티팩트**(후니 DS `huni-design-system` 스킬 · 라이트/다크 테마 · 담당필터 · 마일스톤탭 · localStorage 체크박스(**키는 legacy_id**) · mermaid 의존도)

## 8. 아직 안 닫힌 미확인 (L5 전에)

운영정책 260827 수량배송비 **PM 결정** · `orderCnt`>재고 거절 여부 · `optionInputs` 길이 상한 삼자 충돌(가이드 150자 권장·몰 주석 5000자+·샵바이 문서 없음 → **초과 시 조용한 절단**) · 샵바이 셀러어드민 webhook 등록 여부 · MES 실제 스펙 · 게스트 라이브 미검증 · 라이브 DB 테이블 44 vs `models.py` 60/120 불일치.

## 9. 참고

- 권위 엑셀 최신본은 **매번 절대경로로 확인**: `ls -la /Users/innojini/Dev/HuniWeb/docs/huni/*.xlsx` (현재 260822_1)
- 메모리 인덱스: `~/.claude/projects/-Users-innojini-Dev-HuniWeb/memory/MEMORY.md`
- 이 세션은 kanban lead(`lead-peta`). lane 은 사용자가 직접 터미널에서 띄웠다 — lead 는 세션을 만들 수 없다.

---

## 10. 이어쓰기 (2026-09-02 12:58 · lead-peta [a760e0] · Fable 5.1)

- N1·N2·N3 **전부 lead 기계검산 GO** → `L0/LEAD-VERDICT-N.md` (N2 가 넘긴 판단 5건 확정 포함).
- **전략서** `STRATEGY-D34.md` — 오픈의 정의(13단계) · 차단 3(PG·MES·NHN) · 역산 게이트 G0~G5(연휴 반영) · Plan B · 3인 역할 · 지니 G0 할 일 5가지.
- **다음 카드** `L0/CARDS-O.md` — O1 테스트 시나리오(plan) / O2 L5 게이트·임계경로·배정규칙·가능성 판정(run) / O3 통합 원장·X·P·닫기팩·지도 §11 합침(sync). 병렬. 산출 `L5/O?/`.
- 배분 전 조건: 지니가 세 lane `/clear` → lead 가 `[ref]` 붙여 SendMessage. O 종료 → lead 합침(O2 규칙을 O3 원장에 기계 적용) → L6.
- **O 라운드 완료(15시)** → `L0/LEAD-VERDICT-O.md`. 합침본 `L5/unified-ledger-assigned.csv`(504행·담당 채움). 전략서 §9 에 판정·차단 재정의·계정 보호 상태 반영. 다음 = 지니 결정 → P1 + L6 카드(`CARDS-P.md` 예정).
- **P 라운드 배분(15시)** → `L0/CARDS-P.md`: P1(run · 미판정 143·done_criteria·차단열·가능성 v2) / P2(plan · NHN 답신·문의서 v2·시나리오 v2) / L6(sync · 엑셀·아티팩트 **생성기**). 지니 정정: PG 는 기존 가맹점 MID 추가(3~5영업일) — 전략서 §9 말미.
- **P 라운드 완료(16:3x)** → `L0/LEAD-VERDICT-P.md`. 최종 원장 `L5/P1/unified-ledger-v2.csv`(504행·완료조건·오픈차단여부). 산출 3종: `07_rebaseline/LEDGER.md` · `docs/huni/후니프린팅_통합IA_일정_역할분담_260902.xlsx` · 대시보드 `L6/runway-dashboard.html`(아티팩트 발행본 `.artifact.html`). 재생성 1줄: `L=L5/P1/unified-ledger-v2.csv && python3 L6/build_xlsx.py --ledger $L && python3 L6/build_artifact.py --ledger $L`. ★9/7 MID 신청 마감 · huni_token 드리프트 결함(쇼핑개발) · NHN 발송본 `L5/P2/NHN-SEND-READY.md`. 다음 = 게이트 운영 모드 + Q1(partial 비고·STD-ORD done 재판정·A-13/A-5 API·71건 정리 반영).
- **Q 라운드 완료(17:1x)** → `L0/LEAD-VERDICT-Q.md`. 무통장 선개통 반영 · 최종 원장 **`L5/Q1/unified-ledger-v3.csv`(505행)** · 게이트 `L5/Q1/gates-v2.md` · 가능성 `feasibility-verdict-v3.md`(시나리오 D 조건부) · 절차서 `L5/Q2/e2e-bank-transfer-runbook.md` · 개발 전달 `L5/Q3/DEV-REQUEST-0{1,2,3}` · 아티팩트 재발행. 재생성: `L=L5/Q1/unified-ledger-v3.csv && python3 L6/build_xlsx.py --ledger $L && python3 L6/build_artifact.py --ledger $L`. 다음 = 게이트 운영 모드(실행 결과 반영).
