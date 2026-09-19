# t58 — 위젯 축 결정·관리 안건 (계약 보충 4 이관분)

계약 `08_system-screen/CONTRACT.md` 보충 4: 화면도 기능도 없는 결정·관리 안건은 `screens.csv` 행이 아니다.
그 자리는 9/17 계획 원장 735행이다. **지우지 않고 옮긴다** — 아래 5건은 §5 에서 「원장 미수록」으로 걸러졌으나
`screens.csv` 대상이 아니므로 여기 둔다. t51 이 「관리 요소(RACI·리스크·의존)」 절의 입력으로 쓸 수 있다.

**이 파일은 제안이다** — 계획 원장(735행)·레인 원장(747행)을 직접 고치지 않았다.

| plan_row_id | 안건 | 미결 내용 | 근거 path:line | 결정 주체 |
|---|---|---|---|---|
| `T4-2` | 원고 승격 실파일 1건 종단 + 웹훅 해석 소비자 구현(입금→PAID 전이) | 승격 코드는 실재하나(`artwork_promote.py`) **실파일 1건 종단 검증이 안 됐다**(계획 상태 「구현-미검증」). 웹훅은 원문 저장+200 까지만 있고(`shopby_hook.py`) **해석 소비자가 없다** — 입금완료를 받아 무엇을 할지 결정·구현이 남았다 | `_workspace/huni-launch-runway/07_rebaseline/S/S5-plan/plan-rows.csv` (row_id `T4-2`) · `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/shopby_hook.py` · 같은 저장소 `docs/order-to-mes-process.md:688` | 서희항(구현) · 게이트 판정은 리드 |
| `T4-3` | 파일 검수 경로 결정 — PitStop 조달 또는 사람 검수 | **구매 결정이 선행**이다. PitStop Server 는 별도 EC2 Windows 로 「추가 예정」 상태이고(`docs/aws-architecture-huni.md:21`·`:210`) 코드는 0건. 사람 검수(Plan B)로 가면 pitstop 레인 `t50:133`(PS-27 검판 판정 화면)이 오픈 범위로 들어온다 | `plan-rows.csv` (row_id `T4-3`) · `/Users/innojini/Dev/HuniWeb/raw/webadmin/docs/aws-architecture-huni.md:210` · `docs/order-to-mes-process.md:719`(★12-6 A목록 확정 = 접수담당자) | 대표(구매) · 접수담당자(A목록) |
| `F1-2` | `huni/dev/admin-runtime-env` 시크릿 채움 | 인프라 설정 안건(화면·기능 아님). 위젯 축에 걸리는 이유 = `AWS_*`(원고 업로드 S3)·HMAC 서명 키가 여기 있다 — 미설정이면 업로드가 `upload_not_configured`(503)로 죽는다 | `plan-rows.csv` (row_id `F1-2`) · `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_views.py:874`(`s3_enabled()` 미설정 시 503) | 서희항 · 외부(인프라팀) |
| `F3-9` | Edicus 허용 도메인/콜백에 새 호스트 필요 여부 확인 | **상대측 확인 안건.** 에디터 SDK 를 새 몰 도메인에서 띄우려면 Edicus 쪽 허용 목록이 필요한지 미확인. 우리 쪽 대응 코드는 이미 있다(`api_editor_token` 대리 발급) | `plan-rows.csv` (row_id `F3-9`) · `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py:5803` | 서희항 → 외부(Edicus) |
| `F3-10` | 전환 후 실측 — `/healthz`·로그인·위젯 설정 API 지연·장바구니→재견적·크론 로그 | **검증 게이트 안건.** 위젯 설정 API(`/api/w/v1/widgets/<wgt_cd>`)와 재견적(`/handoff/requote`)이 실측 대상에 들어 있다 | `plan-rows.csv` (row_id `F3-10`) · `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:247`·`:257` | 서희항 · 게이트 판정은 리드 |

**건수 = 5.**

---

## 덧 — 결정 안건은 아니지만 결정에 걸린 것

아래는 `screens.csv` 행 제안(→ `t58/ledger-proposal.csv` C 구분)으로 두었으나, **선행 결정이 없으면 착수 불가**다.
의존 관계를 여기 적어 둔다(t51 의 의존 절 입력용).

| 행 제안 | 막고 있는 결정 | 근거 |
|---|---|---|
| `STD-MFG-013` MES-1 주문 접수 전송(WCF) | ★12-1 **MES 실제 상태 코드·WCF 인터페이스 스펙** 미확정 — 「§6 매핑표의 MES 열은 지금 **추정**」 | `/Users/innojini/Dev/HuniWeb/raw/webadmin/docs/order-to-mes-process.md:714` |
| `STD-MFG-099` 셋트·건수 MES 작업 분해 | ★12-11 분해 규칙 미확정(우리 payload 에는 이미 정보가 있다) | 같은 문서 `:724` |
| `STD-MFG-036`·`STD-MFG-040` 바이러스 검사·격리 | `T4-3`(검수 경로 결정)에 딸린다 | 위 T4-3 행 |
| `STD-ART-006`·`STD-ART-007` 결제 후 업로드·재업로드 | 설계 4단계 = **PitStop Server + n8n 구축 후**로 미뤄져 있다 | 같은 문서 `:697` |
