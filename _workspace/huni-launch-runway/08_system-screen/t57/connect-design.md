# 시스템 연결 설계서 — 위젯에서 생산까지

카드 **t57**(오픈일정 S7-B · class C · 조사·문서 · 읽기전용) · 작성 260919 · 브랜치 `WT-connect-design-doc`
HTML 짝: `t57/connect-design.html`(드릴다운) · 검산: `t57/verify.py`

---

## 이 문서를 읽는 법

9/16 산출이 「무엇을 이야기하는 문서인지 모르겠다」를 받은 원인은 데이터가 아니라 **틀**이었다
(`../07_rebaseline/S/CARDS-S.md:3`). 기능 행 목록만 있고 전체 그림이 없었다.

이 문서는 **위에서 아래로 한 번만 읽으면 되게** 짰다.

| 층 | 무엇 | 누가 읽나 |
|---|---|---|
| **L0** | 전체 흐름 1장 — 시스템이 서로 어떻게 이어지는가 | 처음 여는 사람 전원 |
| **L1** | 이음매 10개 × 상태 · 미결 결정 · 결정 주체 | 무엇을 정해야 하는지 보려는 사람 |
| **L2** | 이음매별 설계 입력 — 재사용 / 신규 / 베끼면 안 되는 것 / 조용히 깨지는 계약 | 실제로 설계·구현할 사람 |
| **L3** | 근거 부록 — 어느 카드의 어느 줄에서 나왔는가 | 사실을 의심하는 사람 |

**이 문서가 하지 않는 것 3가지.** ① 판정하지 않는다 — 「된다/안 된다」를 쓰지 않고 **결정 안건**으로 올린다.
② 날짜를 추정하지 않는다 — 선행·순서만 적는다. ③ **담당을 스스로 배정하지 않는다** — L1 의 담당 열은
S7-A(t56 · 커밋 `5bb97cfd`)의 판정을 옮긴 것이고, 근거가 얇은 칸에는 ⚠ 를, 판본이 갈리는 칸에는 **병기**를 남겼다.

**[HARD] 열림PnP 코드는 후니 status 의 근거가 아니다.** `/Users/innojini/Dev/CRT.DigitalEdit.V2` 는
타 고객 납품본이다. 원장 pitstop 23행은 `미착수`/`미확인` 그대로다. 가져가는 것은 **호출 방법과 구간 나눔**뿐이다.

---

# L0 · 전체 흐름 한 장

## 위젯이 몸통이다 (지니 확정 260919)

쇼핑몰 페이지에 임베드된 **위젯**이 상품선택 → 가격계산 → 에디터 → 파일업로드 → PitStop/MES 연계를 처리하고,
**쇼핑몰은 그 값을 받아** 카트·주문·결제를 한다. 즉 몸통은 위젯이고, 쇼핑몰은 돈과 주문의 원장이다.

```
                        ┌──────────────── 위젯 (몸통) ────────────────┐
  고객 ──▶ 상품 선택 ──▶ 가격계산 ──▶ 에디터(Edicus) ──▶ 원고 업로드(S3 tmp)
                        └──────────────────┬─────────────────────────┘
                                           │ ① handoff — 서명 토큰 + 사양 + 금액
                                           ▼
                                      쇼핑몰(스킨)
                                           │ ② 카트 담기
                                           ▼
                                        샵바이 ──── 돈·주문의 원장 ────┐
                                           │ ③ 결제·주문 생성          │
                                           │                          │ ⑩ 상태·송장 회신
                                           ▼ ④ 주문 등록 + ⑤ 웹훅      │  ← 미확인 이음매
                                      관리서버(webadmin)               │
                                           │                          │
                        ⑥ 원고 승격(S3 tmp → order)                    │
                                           │                          │
                                           ▼ ⑦ 작업 지시 (신규)        │
                                       PitStop ── 프리플라이트          │
                                           │ ⑧ 결과 인계 (신규·선례 0) │
                                           ▼                          │
   Edicus 렌더 ──⑨──▶               MES(생산) ───────────────────────┘
                                           │
                                           ▼ NAS ──▶ 공장
```

**읽는 법 3가지.**

1. **관리서버를 거치지 않는 구간은 카트·결제 둘뿐이다.** 주문의 상태를 아는 곳이 한 군데여야 어긋나지 않는다
   (CTO 9/8 문서 원문 — `docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html`).
2. **가로선(①~⑥)은 이어져 있고, 세로선(⑦~⑩)이 비어 있다.** 오픈 전 필수 작업은 대부분 아래쪽에 있다.
3. **⑩은 한 번 일어나고 끝나지 않는다.** 주문이 살아 있는 동안 계속 도는 구간이고, 고객이 「내 주문 어디쯤?」을
   보는 자리가 결국 여기다.

## CTO 10구간과의 대조 (같은 그림, 다른 각도)

CTO 9/8 문서는 같은 길을 **10구간**으로 나눴다. 이 문서의 이음매 번호를 그 틀에 겹친다.

| CTO 구간 | 이 문서 이음매 | CTO 9/8 표기 | 260919 실측 |
|---|---|---|---|
| 01 사양 선택·원고 업로드 | (위젯 내부) | ✓ | 위젯 128행 완료 |
| 02 장바구니에 담기 | **① 위젯→쇼핑몰** | ✓ | 완료 — 단 **금액 표현이 세 문서에서 다르다**(L2-①) |
| 03 샵바이 장바구니에 올리기 | **② 쇼핑몰→샵바이** | ? 전달받음·검증 전 | 그대로 — 표시↔청구 불일치 **별도 과제**로 남아 있음 |
| 04 결제·주문 생성 | **③ 샵바이 결제** | ? 전달받음·검증 전 | 그대로 |
| 05 주문 등록 | **④ 샵바이→webadmin** | ? 받는 쪽 라이브·호출 미확인 | 그대로 |
| 06 원고 승격 | **⑥ S3 tmp→order** | ✓ | 완료 6행 |
| 07 주문 상태 변화 웹훅 | **⑤ 샵바이 웹훅** | 받아서 쌓기만 | 그대로 — **메아리 필터 0건** |
| 08 파일 검사 | **⑦ 원고→PitStop** | 미착수·선행 많음 | 23행 전부 미착수 |
| 09 접수 — 검수하고 제작대기로 | **⑧ PitStop→MES** · **⑦′ 샵바이→MES** | **가장 큰 공백** | 선례 0 · 자리 후보 5 |
| 10 MES 상태 변경→자사몰 전달 | **⑩ MES→샵바이 회신** | 미착수 | **세 카드 모두 미확인** |

CTO 문서가 「✓ 만들어져 있음」으로 적은 06까지는 260919 실측과 일치한다. **갈리는 곳은 02 하나**다 —
CTO 문서는 「1원짜리 상품을 금액만큼의 수량으로」라고 적었는데, 현재 스킨 코드는 **10원 단가**로 돌고 있다(L2-②).

---

# L1 · 이음매 10개 — 상태 · 미결 · 결정 주체

**상태 3값**: `있음` 코드가 실재하고 읽어 확인했다 · `부분` 한쪽만 있거나 저장만 한다 · `신규` 코드 0건.
`미확인` 은 「없다」가 아니라 **「이번 조사로 확인하지 못했다」**다.

| # | 이음매 | CTO 구간 | 상태 | 원장 행 | **담당** | 미결 결정 |
|---|---|---|---|---|---|---|
| ① | 위젯 → 쇼핑몰 (handoff) | 02 | **있음**(우리 쪽) · **부르는 쪽 미착수** | widget↔huni-mall 4 · widget API 3 (전건 완료) · 스킨 호출부 3행 미착수 | **서희항**(위젯·API) + **김동학**(스킨 호출부) | 금액 표현 단위 정본 확정 |
| ② | 쇼핑몰 → 샵바이 (카트·주문·결제) | 03·04 | **부분** | huni-mall↔shopby 104 (완료 20 · 진행 42 · 미착수 42) | **김동학** (98/102) | 표시↔청구 불일치 해소 방식 |
| ③ | 샵바이 → webadmin 주문 등록 | 05 | **부분** | shopby↔webadmin 6 (완료 4 · 미착수 2) | **서희항** (5/6) | 자사몰이 결제 직후 실제로 부르는가 |
| ④ | 샵바이 웹훅 → webadmin | 07 | **부분(저장만)** | `SB-WEBHOOK` 2행 미착수 | **서희항** (2/2) | 어떤 메시지를 골라 어떤 상태로 바꾸나 · **메아리 필터** |
| ⑤ | 원고 승격 (S3 tmp → order) | 06 | **있음** | s3↔webadmin 6 (전건 완료) | **서희항** (5/6 · 1 미정) | — |
| ⑥ | 원고 → PitStop 작업 지시 | 08 | **신규** | pitstop 23 전건 미착수 | **서희항** (5/6 · 1 미정) — 단 **결정 주체는 미정** | **A(큐+DB) vs B(파일+JSON)** — `STD-ART-034` |
| ⑦ | 샵바이 → MES 주문 수신 | 09 | **부분**(변환 재사용·수신 신규) | mes↔shopby 11 전건 미착수·`owner_side=미정` | **미정 + 최숙진** ⚠ **약한 근거**(11행 중 1행만 t56 판정) | **직접 HTTP vs 앞단 큐** |
| ⑧ | PitStop → MES 결과 인계 | 09 | **신규 · 선례 0** | mes↔pitstop 1 미착수 | **서희항** ⚠ **근거 1행뿐** | 자리 후보 5 중 어디 · 재렌더 유실 확인 |
| ⑨ | Edicus 렌더 → MES | — | **있음** | edicus↔mes 1 완료 | **외부(상대측 회신 대기)** ⚠ 담당이 아니라 **상태**다 | — (단 S3 경로가 조인 키) |
| ⑩ | MES → 샵바이 상태·송장 회신 | 10 | **미확인 이음매** | webadmin→shopby 송장·상태 6행 (미착수 4 · 미확인 2) | **서희항** (6/6 · 그중 **4행이 김동학→서희항 재배정**) | MES→webadmin 방향 실측 자체가 없다 |

부수: **MES → NAS → 생산**은 `있음`이다(`mes ↔ 외부(사내 NAS)` 1행 완료 · 오픈 분모 밖).

## 담당 열을 읽는 법 [중요]

**출처**: t56 `rejudge.csv` 735행(브랜치 `WT-role-todo-rejudge` · 커밋 `5bb97cfd`)을 직접 열어,
각 이음매의 원장 행이 가리키는 `plan_row_id` 를 조회해 모았다(`t57/owners.py` · 산출 `t57/owners.json`).
t56 전체 판정 분포 = 담당맞음 457 · 재배정 141 · 미정 63 · provided 37 · 분할 36 · 불필요 1.

**지니 확정 4경계**(260919): webadmin·위젯·SDK·API = **서희항** / 쇼핑몰 스킨·페이지빌더 = **김동학** /
실무운영 = **최숙진** / PM = **신우진**.

**⚠ 표시의 뜻 — 근거 강도가 행마다 다르다.** t56 의 `judged_by` 는 5종이고 강도가 같지 않다:
`merged-owner_side` 366 · `evidence-path` 177 · **`rule-track` 95 · `rule-step` 89**(= 약한 근거 184 · 전체의 25%) ·
`manual-read` 8. 위 표의 이음매 담당은 **대부분 `merged-owner_side`·`evidence-path`·`manual-read`(강한 근거)**에서 나왔고,
⚠ 를 붙인 세 칸(⑦·⑧·⑨)만 근거가 얇다 — **배정이 아니라 제안으로 읽어야 한다.**

- **⑦** 은 11행 중 **10행이 `plan_row_id=NEW`**(샵바이 스펙 yaml 에서 새로 만든 행)라 t56 이 판정할 원장 행이 없다.
  남은 1행(`T4-4`)이 「미정+최숙진」이다. **11행 중 1행으로 이음매 담당을 정하면 안 된다.**
- **⑧** 은 이음매 전체가 원장 1행(`STD-MFG-051`)뿐이다. 그 행은 `merged-owner_side`(강함)로 서희항이지만,
  **이음매의 부피에 비해 표본이 1이다.**
- **⑨** 의 「외부(상대측 회신 대기)」는 4경계 안의 사람이 아니다. **담당이 아니라 대기 상태**이므로
  회신이 오면 다시 판정해야 한다.

**⑩ 의 재배정 4행**(`STD-SHP-012`·`STD-SHP-013`·`STD-MFG-114`·`STD-MFG-123`)은 현재 김동학으로 적혀 있고
t56 이 **서희항으로 재배정을 제안**한 것이다(근거 `merged-owner_side` — 코드가 webadmin 에 산다). 확정 전이다.

## 「있는 줄 알았는데 없는 것」 — MES WebApi 주문 API

**이것 하나만 따로 뗀다.** MES 저장소에 `POST /api/{companyCode}/orders` 가 있고 Swagger 문서도 있어
**「주문 수신 API 가 이미 있으니 샵바이만 붙이면 된다」로 읽힌다. 그렇게 읽으면 안 된다.**

| 사실 | 근거 |
|---|---|
| 솔루션 **빌드 대상이 아니다** — `.sln` 의 `BackOffice.WebApi` 는 VS **솔루션 폴더** GUID이고 csproj 항목 0 | `TS.BackOffice.Huni.sln:102` (t54 §4) |
| 호출하는 저장 프로시저 `USP_T_ORD_ORDER_C` 가 **DB 스크립트에 0건** (콘솔이 쓰는 `USP_ORD_ORDER_EXCEL_C` 는 4건 실재) | t54 §1-(2) |
| 주문 **아이템이 저장되지 않는다** · 멱등성 0 (외부 주문번호 필드 자체가 DTO 에 없다) | `OrderCoreEndPoints.cs:293` (t54 §4) |
| 주문 CRUD 6개 **전부 익명** — `FallbackPolicy` 없음 | t54 §1-(3) 전수 |
| 코드가 스스로 적어 둠: `Notes = "New endpoint - WCF uses COrderByExcel for bulk import"` | t54 §4 |
| 실제 외부 주문 유입 경로는 WebApi 가 아니라 **콘솔(SQS/폴링) 작업자** | t54 §4 |

→ **⑦ 샵바이→MES 의 「수신 층」은 신규다.** 다만 **변환 층은 재사용**이다(L2-⑦).

## 결정 사슬 — 무엇을 먼저 정해야 순서가 안 꼬이나

원장 밖 결정 안건은 `../t50/pitstop-decisions.md`(7건) · `../t50/edicus-decisions.md`(2건)에 있다.
여기서는 **순서만** 보인다.

```
STD-ART-034  연동방식(큐+DB vs 파일+JSON)      ← 여기가 막히면 아래 전부 막힌다
      │                                        t56: 미정 ⚠rule-track
      ├─▶ STD-ART-035  작업범위 산정 4갈래       t56: 미정
      │         │
      │         └─▶ STD-ART-033  일정 상정      t56: 미정 ⚠rule-track
      │
      ├─▶ BLK-S2-4    PitStop 구매·라이선스      t50: 대표(채훈희)  t56: 대표(구매) ⚠rule-track   → 일치
      ├─▶ T4-3        파일 검수 경로             t50: 대표(채훈희)  t56: 서희항+신우진 ⚠rule-track → 상충
      └─▶ STD-MYP-024 PitStop 연동 담당 확정     t56: 미정 ⚠rule-track   (선행 STD-ART-016 → t56: 서희항 재배정)

STD-ADO-010  검수 게이트를 MES 상태값으로 대신할지  t50: 미정(최숙진 추정)  t56: 최숙진 ⚠rule-step → 추정 확인
STD-MYP-031  보관함 저장 시점                    t50: 신우진(PM)      t56: 신우진 ⚠rule-track → 일치
      └─▶ STD-OPT-053  개발 주체                t50: 신우진(PM)      t56: 서희항 재배정 ⚠rule-track → 상충
```

**읽는 법 3가지.**

1. **사슬의 뿌리가 여전히 미정이다.** `STD-ART-034` 는 t50·t56 양쪽에서 미정이고, t56 판정 근거도
   `rule-track`(약함)이다. 이것이 ⑥·⑧ 이음매의 작업량을 낼 수 없는 직접 원인이며, **t56 이 해소하지 못했다.**
2. **이 사슬은 t56 근거가 유독 약하다.** 9건 중 **7건이 `rule-track`/`rule-step`** 이다.
   이유가 있다 — 결정 안건은 화면도 기능도 없어 `merged-owner_side`(코드가 사는 쪽)로 판정할 수가 없다.
   **결정 안건의 담당은 규칙으로 유도된 제안이지 실측이 아니다.**
3. **상충 2건은 이 문서가 고르지 않는다.** `T4-3`(대표 ↔ 서희항+신우진)과
   `STD-OPT-053`(신우진 ↔ 서희항)은 두 판본을 **병기**했다. 둘 다 t56 근거가 `rule-track` 이므로
   9/17 원장 `owner_name`(t50 이 읽은 값)을 덮을 만큼 강하지 않다 — **지니 확정이 필요한 자리**다.

---

# L2 · 이음매별 설계 입력

각 이음매마다 네 칸이다. **재사용 자산**(있는 것을 쓴다) · **새로 만들 것**(없다) ·
**베끼면 안 되는 것**(선례에 있지만 따라가면 깨진다) · **조용히 깨지는 계약**(예외를 던지지 않고 틀리는 자리).

---

## ① 위젯 → 쇼핑몰 (handoff)

**재사용 자산 — 전건 완료, 손댈 것 없음**

| 무엇 | 근거 |
|---|---|
| `POST /api/w/v1/handoff` — 재계산 + HMAC 서명 토큰 발급 | `raw/webadmin/webadmin/config/urls.py:255` |
| `POST /api/w/v1/handoff/verify` — 쇼핑몰 서버가 서명·금액 검증(서버-투-서버) | `.../urls.py:256` · `catalog/widget_api.py:183` |
| `POST /api/w/v1/handoff/requote` — 결제 직전 재견적·수량 변경 | `.../urls.py:257` · `widget_api.py:5011` |
| `GET /api/w/v1/catalog` — 카탈로그 + 상품별 시작가 | `.../urls.py:248` · `widget_api.py:5841` |
| 위젯 `submit` — `canOrder → validate → 서명 토큰 → huni:submit` 이벤트 방출 | `catalog/static/catalog/widget.js:953` · `:1015` |
| 스킨 수신 — `optionInputs` 에 `huni_order`(JSON) · `huni_token` 저장 | `huni-skin-shopby/README.md:64-67` |

**새로 만들 것 — 우리 쪽은 완료, 부르는 쪽이 통째로 비어 있다 [t58 입력 · 직접 재확인]**

원장의 완료 4행은 **발급하는 쪽**이다. 그것을 **부르는 스킨 쪽 3행이 전부 미착수**다:

| 원장 행 | 기능 | plan_row_id | 담당 |
|---|---|---|---|
| `t48:192` | `handoff/verify` 재검증 호출 | `NEW` (`S1-skin/api-wiring.csv C1` 호출 0건) | 김동학 |
| `t48:193` | 주문 생성 직후 `order/register` S2S 호출 | `STD-ORD-030` | 김동학 |
| `t48:239` | 결제 직전 재견적(최종 금액 확정) | `STD-ORD-029` | 김동학 |

→ **「완료 4행」을 오픈 준비 완료로 읽으면 안 된다.** 이 이음매의 남은 일은 전부 **스킨 쪽(김동학)**에 있다.

**계약에 한 칸 비어 있다**: `verify` 응답에 `handoff_id` 가 없다 — 반환은
`{"ok": True, "valid": valid, **({"payload":…} if valid else {"reason":…})}` 뿐이다
(`widget_api.py:5006-5007` 직접 확인). `submit()` 쪽은 이미 노출된다(`widget.js:1011`).
주문을 추적·조인할 키가 **검증 응답에는 없다**.

**조용히 깨지는 계약 — 허용 도메인 검사가 꺼진 채 열릴 수 있다 [t58 입력 · 직접 재확인]**

`_origin_allowed` 는 `allow_domains` 가 비어 있으면 **무조건 통과**한다 —
docstring 이 「미설정=통과」라고 적고 `if not doms: return True`
(`/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py:709-711` 직접 확인).
그런데 **`allow_domains` 를 채울 수단이 없다**: `tools/issue_site_key.py:35-37` 의 UPDATE 는
`site_key` 와 `upd_dt` 만 쓴다(직접 확인). 신규몰 도메인 추가 = 직접 DB UPDATE 다.
→ 예외가 나지 않고 **Origin 검사만 조용히 꺼진다.**

**조용히 깨지는 계약 — 금액 표현이 세 문서에서 다르다 [결정 안건]**

| 출처 | 적힌 것 |
|---|---|
| CTO 9/8 문서 | **1원짜리 상품 × 금액만큼의 수량** (8/26 샵바이 회신으로 확정) |
| 원장 t48:209 | 「**10원×수량**」 모델 정합 검증 — 미착수 |
| 스킨 실코드 | `"판매가 10원 상품 × 수량(=금액÷10)" 으로 결제 금액을 표현한다(후니 §11 확정)` · `총액은 10원 배수라 반올림은 정확` — `/Users/innojini/Dev/huni-skin-shopby/src/lib/api/widget-order.ts:22-23,29-30` |

→ **돌고 있는 코드는 10원이다.** CTO 문서의 1원은 9/8 시점 표기이거나 이후 바뀐 것이다.
이 문서는 어느 쪽이 맞다고 **판정하지 않는다** — 정본을 한 줄로 확정하는 것이 결정 안건이다.
10원 단가는 「후니 가격엔진이 1원 단위를 절삭해 항상 10원 배수」라는 **전제 위에 서 있다**.
그 전제가 깨지는 상품이 하나라도 있으면 청구액이 조용히 어긋난다.

---

## ② 쇼핑몰 → 샵바이 (카트·주문·결제)

**재사용 자산**: 카트 조회·수량/옵션 수정·삭제·비회원 카트가 전부 완료(`MALL-CART` build 행 · 라이브 확인
`https://shopby.huniprinting.co.kr/cart@2026-09-16 21:27`). 결제 복귀 URL(NCPPay `confirmUrl`)은 **진행**.

**조용히 깨지는 계약 — 표시↔청구 불일치 [알려진 이슈 · 별도 과제]**

> 결제 표시 금액은 위젯 총액을 따르지만, 실제 PG 청구액은 shopby 가 서버에서 옵션가 기준으로 확정한다
> (`/Users/innojini/Dev/huni-skin-shopby/README.md:70-71`)

표시와 청구가 다른 자리다. 예외가 나지 않고 **금액만 다르게 결제된다.** 원장은 이것을
`STD-PAY-031 · 미착수`로 들고 있다. ①의 단위 정본과 같은 뿌리다.

**베끼면 안 되는 것**: 담기 전달값에 **토큰·원고 저장키·프로젝트 식별자가 평문으로 노출**되는 구조
(`L0/N3/ARCHITECTURE-v2.md §10 A-13`). 원장 `STD-SYS-023 · 미착수`.

---

## ③④ 샵바이 → webadmin (주문 등록 · 웹훅)

**재사용 자산**

| 무엇 | 근거 | 상태 |
|---|---|---|
| 웹훅 수신 핸들러 — 결제완료·취소·배송지변경 · 경로 마지막 조각이 비밀키(불일치 404) · 원문 저장 후 즉시 200 | `raw/webadmin/webadmin/config/urls.py:273` · `catalog/shopby_hook.py:82` | 완료 |
| 클레임(반품·교환) 웹훅 저장 — `shop_clm_sts` 포함 | `catalog/shopby_hook.py:112-121` | 완료 |
| 상품 동기화·이미지 동기화·전시 동기화 | `catalog/shopby_sync.py:118` · `catalog/admin.py:2301` | 완료 |

**새로 만들 것 — 읽고 판단하는 층이 통째로 없다**

CTO 문서 원문: 「지금은 받아서 원문 그대로 쌓는 것까지만 되어 있고, **읽고 판단해 MES에 반영하는 부분이 없습니다**.」
260919 재확인 결과 그대로다 — `shopby_hook.py:121` 은 `TOrdWebhooks` 저장만 한다.

**조용히 깨지는 계약 — 메아리 필터 [F7]**

우리가 샵바이에 올린 상태 변경이 **웹훅으로 되돌아온다.** 자기 변경인지 가리는 코드가 0건이다
(`STD-MFG-030 · 미착수` · `shopby_hook.py:112-121` 에 필터 없음 — t48 직접 확인 260919).
무한루프이거나, 자기 변경을 남의 변경으로 읽어 상태를 덮는다. **둘 다 예외를 던지지 않는다.**

**베끼면 안 되는 것**: 우커머스 선례는 **서명 검증이 없다**(헤더 6종을 읽지만 `x-wc-webhook-signature` 는
읽지 않음 — t54 §1-(2)). 샵바이 스펙은 `X-Webhook-Signature`(HMAC-SHA256) 검증을 요구하므로
**이 선례를 그대로 베끼면 스펙 미달**이다. HMAC 은 사내에 **아웃바운드 서명 생성만 있고 검증 코드 0건**이다.

---

## ⑤ 원고 승격 (S3 tmp → order)

**재사용 자산**: `s3 ↔ webadmin` 6행 전건 완료. 입금 전(가상계좌)에도 옮긴다 —
「파일을 지키는 것과 생산을 시작하는 것은 다른 일」(CTO 9/8).

**조용히 깨지는 계약 — S3 키 경로가 곧 조인 키다** (⑨와 같은 뿌리 · L2-⑨ 참조)

---

## ⑥ 원고 → PitStop 작업 지시 [신규]

### 선례는 두 갈래다 — 「핫폴더 vs CLI」가 아니다

열림PnP 는 **둘 다 만들었고 둘 다 CLI 다.** `CRT.Yeolim.ServerProcess.HotFolder` 의 "HotFolder" 는
Enfocus 제품 기능이 아니라 **자체 exe 이름**이고, 내부는 SQS 판과 똑같이 `PitStopServerCLI.exe -config` 를 3회 부른다.
Enfocus 핫폴더 API·SDK 바인딩 0건 · `.ppp` 프로파일 미사용(`CRT.Yeolim.ServerProcess/Program.cs:636`).

**실제로 갈린 축은 「PitStop 을 어떻게 부르나」가 아니라 「작업 지시를 어디서 받나」다.**

| | **A · 큐 + DB** (`CRT.Yeolim.ServerProcess`) | **B · 파일 + JSON** (`…ServerProcess.HotFolder`) |
|---|---|---|
| 입력 | S3 이벤트 → SQS → 다운로드 | 파일 경로 인자 `-i` |
| 옵션 출처 | DB `SETTING_JSON`(주문 시점 동결) | **JSON 파일 인자 `-c`** |
| 작업 식별 | DB `jobId` = 파일명 숫자 접두 (`Common/AppArguments.cs:57`) | 파일명 규약 `yyMMdd_코드` (`HotFolder/Common/AppArguments.cs:66-99`) |
| 상태·결과 | DB 로그 `USP_JOB_LOG_C` + 클라이언트 그리드 | **파일** `{이름}_레포트_{정상\|주의\|오류}.json/.pdf` (`HotFolder/Common/AppReturnValue.cs:274-288`) |
| DB 결합 | 있음 | **0** — `CJobLog` 7곳 전부 주석 · 살아있는 호출 0건 |

→ **`STD-ART-034` 의 결정 문장을 이 축으로 다시 쓰는 편이 정확하다.**
**B 는 후니 쪽 결합면이 가장 얇다** — webadmin 이 옵션 JSON 을 파일로 떨구고 exe 를 부르면 되므로
**PitStop 서버가 후니 DB 를 전혀 모르게** 만들 수 있다.

### 재사용 자산 — 옮기면 되는 것은 753줄뿐이다

`CRT.Framework.Pitstop` 4파일 753줄: `PitStopConfiguration.cs`(318 · 설정 XML 직렬화) ·
`EnfocusReport.cs`(289 · 리포트 파서) · `PitStopEnums.cs`(93) · `VariableSet.cs`(53 · `.evs`→`.evl` 치환).
선언된 의존 2개(`Newtonsoft.Json 13.0.3` · `CRT.Framework.PDF` ProjectReference)는 **소스에서 미사용**이고
using 은 전부 `System.*` 이다. 양쪽 다 .NET Framework 4.7.2 · 같은 csproj 형식 · 같은 `CRT.Framework.*`
네임스페이스라 **이름 충돌 자리가 없다.**

최소 완결 예제: `RunPitstopCLI/Form1.cs`(184줄)가 한 화면에 전 구간을 담고 있다 —
변수세트 로드·치환(`:114-119`) → `Configuration` 조립(`:125`) → `Save`(`:164`) → `-config` 인자(`:168`) →
`CommandLine.Execute`(`:170`) → `EnfocusReport.Deserialize`(`:174`). **PoC 에 그대로 베낄 수 있는 유일한 파일**이다.

호출 계약은 플래그 하나뿐이다:
```
CommandLine.Execute(pitStopActionSet.ExeFileName, $" -config \"{configFilePath}\"", ref outputString, executeTimeoutSec)
```
(`CRT.Yeolim.ServerProcess/Program.cs:654-659`)

### 새로 만들 것 — 부피는 Framework 밖에 있다

| 무엇 | 열림 대응 | 줄 |
|---|---|---|
| 3단계 오케스트레이션(구조검사→본처리→폰트플래튼)·옵션→액션 선택·후처리 | `CRT.Yeolim.ServerProcess/Program.cs` | 1,357 |
| 액션 카탈로그 (`PitStopAction_{Enum}` appSetting 규약) | `Common/ActionsSetList.cs` | 113 |
| 인자 파싱 · 반환 규약 | `Common/AppArguments.cs` · `AppReturnValue.cs` | 97 + 67 |
| **상품별 프로파일** (`.eal` 액션리스트 · `.evs` 변수세트) | **선례 없음** — 열림은 상품 개념 자체가 없고 작업별 옵션 불리언으로 액션을 고른다. `.eal`·`.evs` **실물 0개** | — |
| 기동 주체(감시자·스케줄러) | **저장소 밖** — `FileSystemWatcher`·`ServiceBase`·`Topshelf`·`TaskScheduler` 0건 | — |

즉 **753줄 복사**와 **파이프라인 세우기**는 규모가 다르다. 후자는 위 1,634줄의 등가물 + 저장소 밖 자산이 필요하다.

### 단계별 파라미터 — 설계에 그대로 쓸모 있는 구분

| 단계 | 하는 일 | 변수세트 | 조건 |
|---|---|---|---|
| PitStop01 | 문서 구조 검사 | **없음** | 무조건 |
| PitStop02 | 본 처리 | **있음** (색상 타깃·DPI·근접거리·리샘플 DPI) | 무조건 |
| PitStop03 | 폰트 플래튼 | **없음** | 폰트 미임베드 **그리고** 옵션 켬 |

살아있는 변수세트 대입은 두 곳뿐이고 **둘 다 PitStop02** 다(`ServerProcess/Program.cs:1019` ·
`HotFolder/Program.cs:1051`). 01·03 은 세 판본 모두 주석이다.
→ **구조 검사와 폰트 플래튼은 변수 없이 돈다.**

### 베끼면 안 되는 것 [3건]

1. **동시성 상한이 없다.** 프로세스 수 가드는 `>` 비교라 `ExecuteProcessCnt=4` 인데 **최대 5개**가 공존하고
   (`SQSMonitorService/Program.cs:41-46`), 프로세스 안에서는 받은 메시지마다 `Task.Run` 을 만들어 전부 동시에 띄운다
   (`:116-175`, 상한은 `MaxMsgCntAtATime=10` 뿐). 곱하면 **최악 5×10=50개**가 동시에 돌고 각자 CLI 를 3회까지 부른다.
   **PitStop 라이선스 동시 실행 한도를 넘길 구조다.**
2. **Win32 창 원격 조작.** `SaveAsErrorPdf/Program.cs:166-172` 와 `FoxitSaveAs/Form1.cs:71-77` 이
   `FindWindow`/`SetForegroundWindow` 로 Foxit GUI 창을 조작한다. **무인 서버에서 포커스·창 제목에 의존하는
   자동화는 조용히 깨진다.**
3. **실패 시 메시지를 지우지 않는다** → 작업 전체가 재실행되는데 **멱등 가드가 없다**
   (`:109` `bDeleteMsgOnSuccess:false` + `:155` 성공 시에만 삭제). 재시도도 없다(타임아웃 1800/2400초).

### 조용히 깨지는 계약 [2건]

1. **`CommandLine.Execute` 는 후니에 이미 있고 동작이 다르다.**

| | 열림(88줄) | 후니(85줄) |
|---|---|---|
| 5번째 인자명 | `hiddenWindow` | **`windowHidden`** |
| `CreateNoWindow` | **항상 `true`** | **`windowHidden==true` 일 때만** (기본 `false`) |

열림 호출부는 5번째 인자를 넘기지 않는다(4인자 호출 · `Program.cs:659`). **같은 호출을 후니 `CommandLine`
으로 하면 기본값 `false` 라 콘솔 창이 뜬다.** 상주 워커에서는 동작 차이가 된다. 인자명이 달라
named argument 로 쓴 호출부는 **컴파일이 깨진다.**
→ `CommandLine.cs` 는 **「옮길 파일」이 아니라 「동작 차이를 확인할 파일」이다.**

2. **버전 숫자가 셋 다 다르다** — 코드 `Versioning.Version` 기본값 **10**(`PitStopConfiguration.cs:13`) ·
   XmlRoot 스키마 네임스페이스 **22**(`:289`) · 설치본 **23**. `VersioningStrategy = BestEffort`(`:16`) 로 넘긴다.

### 이 이음매가 결정 못 한 채로 남는 것

PitStop Server 23 의 **라이선스 형태·동시 처리 수·CPU/메모리 요건**은 두 저장소 어디에도 없다(Enfocus 문서 영역).
**「후니 워커 서버에 같이 얹히는가」는 코드로 답할 수 없다** — 현장 서버 실사 또는 인프라 담당 확인이 필요하다.
CTO 문서는 이 자리에 「설치할 서버(EC2 윈도우 인스턴스) 확보」를 적어 두었다.

---

## ⑦ 샵바이 → MES 주문 수신 [수신 층 신규 · 변환 층 재사용]

**스펙**: `docs/api/shopby-integration-api.yaml` — 경로 11 · 오퍼레이션 11 · 구현 `.cs` **0건**.
11개 전부 **MES 가 서버**(base `…/api/integration/shopby`).

**재사용 판정: 복제 0 · 부분 9 · 신규 2**

| 판정 | 대상 | 이유 |
|---|---|---|
| **신규 2** | `POST /inventory/sync`(양방향) · `POST /webhook`(HMAC 인바운드) | 사내 연동은 전부 **단방향 전용 앱으로 분리**돼 있다(`Cafe24Interface` vs `.Update`) — 양방향 조정 로직 0건. 인바운드 HTTP 라우트 0건 · HMAC **검증** 코드 0건 |
| **부분 9** | 나머지 | 형태(페이징 목록·단건 조회·JWT·FluentValidation)는 베낄 수 있으나 **대상 엔티티가 통째로 없다** — `ProductMapping`·수신주문·웹훅이벤트로그의 모델/리포지토리/테이블이 코드에도 DB 스크립트에도 없다 |
| **복제 0** | — | 「대상만 바꾸면 되는」 것이 하나도 없다 |

**가장 두꺼운 재사용 자산 — 변환 층**: 외부 주문 → MES 주문 변환이 셋 다 완성 코드로 있다
(`Cafe24Interface DoCreateOrder` · 우커머스 `CreateUpdateOrder` · `ProductItemFactory` 의 외부 라인아이템 → `ITEM_MDL_CD` 매칭).
→ **`POST /orders/receive` 는 수신 층만 신규고 변환 층은 재사용이다.**

**미결 [결정 안건]**: 현행 4채널 중 **HTTP 웹훅을 직접 받는 것이 하나도 없다** — 전부 SQS 구독이거나 폴링이다.
샵바이 스펙은 MES 가 HTTP 엔드포인트를 노출하고 서명을 검증하라고 요구한다.
**앞단에 큐를 두는 현행 방식을 유지할지, 스펙대로 직접 노출할지가 미결**이고,
「직접 노출」을 고르면 **사내 선례가 없는 구간이 2개 더 생긴다.**
그 전까지 `orders/receive`·`webhook` 두 행의 작업량은 산정할 수 없다(`owner_side=미정` 11건 유지).

**조용히 깨지는 계약**: 인증이 넷이 서로 다르고 샵바이와도 다르다 —
카페24=OAuth2 · 우커머스=**서명검증 없음** · 성원=토큰 없음(쿠키+`company_id`) · 이카운트=`SESSION_ID` 쿼리스트링.
스펙의 `bearerAuth`(JWT)는 MES WebApi 자체 JWT 와 같아 재사용 가능하나, `X-Webhook-Signature` 는 **선례 없음**.

**저장소 어디에도 없는 것**: **샵바이의 무엇이 `USR_ORD_CD` / `MARKET_ORD_ITEM_NO` 가 되는지.**
스펙 yaml 은 `orderNo` · `items[].productId` 만 정의한다. 조인 키를 정하지 않으면 주문이 붙지 않는다.

---

## ⑧ PitStop → MES 결과 인계 [신규 · 선례 0]

**선례가 사내에도 타사에도 없다.** 열림 저장소의 유일한 흔적은 리포트 어셈블리 네임스페이스 공유뿐이고
(`HotFolder/Program.cs:24`), `CRT.Yeolim.IF` 는 WCF 서비스 계약일 뿐이다.
후니 MES 에 PitStop 은 **코드 0 · 문서 0 · 유사 개념어 0**(`grep -ril pitstop` 0건 · `preflight|검판|전산검수` 0건).

**세 저장소 전부 0이다 [t58 입력 · 직접 재확인].** webadmin 도 같다 —
`/Users/innojini/Dev/HuniWeb/raw/webadmin` 에서 `*.py`·`*.js`·`*.html` 전수 grep(`pitstop|pit_stop|pit-stop`)
**0건**. 등장하는 곳은 `docs/**` 7개 · `.planning/**` 5개 · `sql/88_ord_artworks.sql` 뿐이고
전부 「향후·예정」 표기다. 즉 **MES·열림·webadmin 어디에도 실행 코드가 없다** —
⑥·⑧ 이음매는 설계 문서만 있고 시작점이 0이다.

**자리 후보 5개 — 「빈 자리」 목록이지 구현이 아니다**

| 후보 | 기존 그릇 | 새로 필요한 것 |
|---|---|---|
| **A. `T_ORD_ORDER_FILES` 에 파일 종류 추가** | `FILE_TYP` 이 `T_COM_CD`(`CD_GRP='FILE_TYP'`) 코드 도메인 · `UPR_SEQ` 부모-자식 축 · `PRCS_CD` 공정 축 | 코드값 추가(**varchar(10)**) + C# `enum FileType` 확장 + **재렌더 시 삭제 범위 확인** |
| **B. 「접수완료」 게이트** | `FrmOrder2.DoSave()` 가 `STAT_0100 → STAT_0400` 올리기 전 **이미 파일필수 검사**를 한다(`REQ_FILE_YN`·`DSIGN_CNT==0` → 경고) | 검판 결과 조회 + 차단/경고 정책 결정. **선례가 같은 모양** |
| **C. NAS 배포 게이트** | `DesignFileCopyToNas` 가 `ORD_DTL_STAT_CD != DOWNLOAD_STATUS` 면 복사하지 않는다 | **코드 변경 없이 상태값만으로 생산 차단 가능** |
| **D. 주문상세 화면** | `UcOrderDetail` 에 원본/접수/공정 3격자 + 썸네일 탐색기 | 격자 1개 추가 또는 공정 격자에 합부 열 |
| **E. `ItfTrace` 로깅** | 전 작업자 공통 · 컨텍스트가 이미 주문 단위 | 이벤트 코드 정의 |

**가장 값싼 길은 C 다** — 코드를 안 고치고 상태값만으로 생산을 막을 수 있다.
**가장 자연스러운 길은 B 다** — 파일필수 검사가 이미 같은 자리에 같은 모양으로 있다.

### 조용히 깨지는 계약 — 검판 결과 재렌더 유실 [확정 전 반드시 확인]

**A 를 택하면 검판 결과가 재렌더 때 파일행과 함께 지워질 수 있다.**
`USP_ORD_ORDER_FILES_D`(전체 삭제) → `USP_ORD_ORDER_FILES_C`(재삽입)가 **매 렌더 반영 전에 호출**된다.
라이브 SP 본문을 보지 못했으므로 「지워진다」가 아니라 **「확인해야 한다」**로 남긴다
(`USP_ORD_ORDER_FILES_D` 의 `FILE_TYP` 필터 유무 — t54 미확인 #15).

**사람이 한 번 보는 자리**라는 점도 설계 입력이다. CTO 문서 원문:
「접수자가 그 결과를 화면에서 봅니다 — 프리플라이트 결과와 미리보기를 확인하고, 필요하면 원본 파일을 직접 열어 검수합니다.」
→ D(주문상세 화면)는 선택이 아니라 사실상 필수다. 미결 1건: **Edicus 산출물은 파일검수를 건너뛸지**
(템플릿 생성물이라 검사가 불필요할 수 있다 — CTO 제기).

**판정 규칙은 베낄 수 있다**: 오류>0 → `오류` · 경고>0 → `주의` · 아니면 `정상`
(`HotFolder/Common/AppReturnValue.cs:274-288`). 판정 입력은 리포트 XML 5범주(`EnfocusReport.cs:66-162`) +
종료코드 + 출력 실재(`ServerProcess/Program.cs:676-680`).

---

## ⑨ Edicus 렌더 → MES [있음]

**재사용 자산 — 이미 돈다**

```
Edicus(모션원) 렌더완료
  └SQS→ MotionOneInterface ─S3 업로드 2벌→ {CMPNY_CD}/Order/Original/{ORD_YMD}/{ORD_CD}/{파일}
                             │              {CMPNY_CD}/Order/Design/{ORD_YMD}/{ORD_CD}/{파일} (S3 내부 Copy)
                             └WCF→ USP_ORD_ORDER_S4 → USP_ORD_ORDER_DTL_EDICUS_CU
                                    → USP_ORD_ORDER_FILES_D → USP_ORD_ORDER_FILES_C
                                    → USP_ORD_ORDER_DTL_EDICUS_COMPLETE
  S3 업로드 이벤트 ─EventBridge→SQS→ ① ThumbnailCreator  ② DesignFileCopyToNas
```
(`BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs:41`)

### 조용히 깨지는 계약 — **S3 키 경로가 곧 조인 키다**

주문과 파일을 잇는 키는 **두 겹이고 성질이 다르다**.

| 겹 | 키 | 성질 |
|---|---|---|
| 외부주문 → MES주문 | `USR_ORD_CD` + `MARKET_ORD_ITEM_NO` + `EDICUS_EDITOR_ITEM_ID` | 코드 주석이 각각 「네이버 주문번호 / 네이버 상품주문번호 / 에디쿠스 편집아이템ID」 |
| MES주문 → 파일행 | `ORD_CD` + `ORD_DTL_SEQ` + `ORD_DTL_ITEM_NBR` | `ORD_DTL_SEQ` 미존재 시 `EditorItemIndex` 대체 |
| **S3 이벤트 → 주문** | **S3 키 문자열의 부모 디렉터리 이름** | 썸네일·NAS 두 작업자가 `parentDirectory.Name` 을 `ORD_CD` 로 쓴다 |

→ **샵바이 경로를 새로 만들 때 `…/{ORD_YMD}/{ORD_CD}/{파일명}` 모양을 깨면 하류 두 작업자가 주문을 못 찾는다.**
**예외가 아니라 skip 이다** — 아무 일도 안 일어난 것처럼 보인다.

**설계 입력 1건**: 렌더 경로의 「접수파일」은 **원본의 S3 내부 복사본**이다(주석: 「원본 파일 = 디자인접수파일 인 경우」).
**검수를 거친 산출물이라는 의미가 코드에 없다.** PitStop 을 넣는다면 이 자리의 의미가 바뀐다.

---

## ⑩ MES → 샵바이 상태·송장 회신 [미확인 이음매]

**이 이음매는 「없다」가 아니라 「세 카드가 모두 확인하지 못했다」다.**

webadmin → 샵바이 **쓰기 방향**은 원장에 6행 있는데 전부 열려 있다:

| 행 | 상태 |
|---|---|
| `STD-MFG-027` 샵바이 상품준비중 전환(취소 창구 닫기) | **미착수** |
| `STD-MFG-029` 샵바이 배송처리(송장 등록·정정) | **미착수** |
| `STD-MFG-114` 한 주문에 다중 송장 부여 | **미착수** |
| `STD-MFG-123` 재출고 신규송장 부여 | **미착수** |
| `STD-SHP-012` 송장번호 등록(판매자) | **미확인** |
| `STD-SHP-013` 송장 기반 배송상태 일괄변경 | **미확인** |

evidence 는 6행 모두 `catalog/shopby_client.py:137` 로 같다 — **범용 request 함수 하나**이고,
주문·송장 **전용 호출 함수가 없다**(F2).

**MES → webadmin 방향은 실측 자체가 없다.** MES 쪽 push-back 선례는 3개뿐이고(카페24 `.Update` ·
성원 `setStatus/setInvoiceNo/SendDelv` · CommandHandler 우커머스) **전부 오픈 분모 밖 기존 자산**이다.
그중 `CommandHandler.UpdateTracking` 은 **본문이 비어 있다** — 송장 명령을 받아도 아무것도 보내지 않고
SQS 메시지를 삭제한다(`CommandHandler/CommandService.cs:206-214`). 의도인지 미구현인지는 코드로 알 수 없다.

→ **결정 안건**: MES 가 상태를 밀어 주는가(push), webadmin 이 끌어 오는가(pull), 아니면 사람이 넣는가.
CTO 문서는 이 자리를 「고객이 "내 주문 어디쯤?"을 보는 자리가 결국 여기」라고 적었다.

---

# L3 · 근거 부록

## 입력 카드와 그 성격

| 카드 | 대상 | 성격 | 이 문서가 가져온 것 |
|---|---|---|---|
| **t51** `t51/merged.csv` | 원장 747행 | 화면·기능 원장(정본) | L1 상태·행수 전부 |
| **t52** | 미수록 83행 재판정 | 분모 보정 | (직접 인용 없음) |
| **t53** `t53/verdict.md` | 열림PnP `CRT.DigitalEdit.V2` | **타 고객 코드** — status 근거 아님 | L2-⑥ 두 갈래·단계별 파라미터·베끼면 안 되는 것 |
| **t54** `t54/verdict.md` | 후니 MES `TS.BackOffice.Huni` | 읽기전용 실독 | L1 WebApi·L2-⑦⑧⑨ |
| **t55** `t55/verdict.md` | 두 저장소 뼈대 대조 | 읽기전용 실독 | L2-⑥ 이식 조건·`CommandLine` 차이 |
| **t56** `t56/rejudge.csv` | 735행 담당 재판정 (커밋 `5bb97cfd`) | 규칙+실측 혼합 — **25%가 약한 근거** | **L1 담당 열 전부** · 결정 사슬 담당 |
| **t58** `t58/verdict.md` | 위젯 몫 실독 `raw/webadmin` (커밋 `e023dd87`) | 읽기전용 실독 | L2-① 스킨 호출부 3행·`handoff_id` 미노출·`allow_domains` · L2-⑧ webadmin PitStop 0 |
| CTO 9/8 | `docs/huni/후니-주문흐름-…_서희항_260908.html` | 10구간 사고 틀 | L0 구간 대조표 |
| 프린팅머니 | `../PRINTMONEY-BRIEF.md` (미트래킹 유일본 · 읽기만) | 리드 브리프 | 아래 §재기준 |

## 원장 수치 (`t51/merged.csv` · 직접 재계산 — `t57/seams.py`)

전 747행 · `scope=in` 683 · `out` 64. `work_type`: build 378 · integrate 229 · config 99 · provided 35 · manual 6.

시스템별 `status`:

| system | 완료 | 진행 | 미착수 | 미확인 | 계 |
|---|---:|---:|---:|---:|---:|
| webadmin | 146 | 0 | 0 | 1 | 147 |
| widget | 128 | 2 | 0 | 3 | 133 |
| mes | 77 | 0 | 11 | 0 | 88 |
| huni-mall | 31 | 50 | 94 | 2 | 177 |
| shopby | 9 | 8 | 55 | 22 | 94 |
| edicus | 13 | 3 | 4 | 3 | 23 |
| pagebuilder | 0 | 1 | 44 | 17 | 62 |
| **pitstop** | **0** | **0** | **23** | **0** | **23** |

**읽는 법**: `status=완료` 는 **「코드가 있다」이지 「오픈 시나리오에서 돈다」가 아니다**
(실주문 확인 0 · 메뉴 DB 등록 미확인 — t50 정정). webadmin·widget 의 높은 완료율을 「준비됐다」로 읽으면 안 된다.

## 프린팅머니 행 재기준 (`../PRINTMONEY-BRIEF.md`)

브리프가 **낡은 것으로 지목한 원장 행**이다. 이 문서는 행을 고치지 않는다 — 재기준 대상임을 기록만 한다.

| 위치 | 지금 적힌 것 | 문제 |
|---|---|---|
| `STD-MYP-042` | M0 — 어드민 설정 + 충전권 상품 6종 | A안 유물. 토스 직접 발급에선 충전권 상품이 없다 |
| `STD-MYP-048` | M6 — PG 계약 후 카드 충전 활성 | 「충전은 현금만」 확정과 충돌 |
| `STD-MYP-044` | M2 — `useChargePoint` → 충전권 주문서 | 대상이 후니 충전 API 로 바뀐다 |
| `STD-MYP-007` | 충전(PG 결제→적립 전환) | 구 표현 |
| `STD-MYP-008` | 구매확정 적립금 자동 지급 · provided | 켜 두면 후니 원장에 리워드가 들어온다 |
| `STD-MYP-051` | 원장 소유 A vs B′ 미결 | 미팅은 B′ 로 닫았다 |
| `STD-MYP-052` | 충전 전용 입금계좌·과입금 정책 | 토스는 금액 정확 일치만 받는다 — 안건 소멸 |
| `STD-MYP-025` | 완료 기준 「충전권 상품 적립률 0」 | 충전권 상품이 없다 |
| `STD-MYP-026` | 구 DB 미제공 · 스냅샷만 | 9/17 지니: 구 DB 직접 분석 |
| t52 프린트머니 4행 | 「M1 은 A 채택 시 불요」 | 방향이 반대 — A형 M1 이 **B′ 에서** 불요 |

**원장에 아예 없는 것**: 외부포인트 API 5종 · 원장 스키마 · 가용성/모니터링 · 토스 발급·웹훅·환불 ·
충전 운영 화면 · 일 마감 대사 · 탈퇴 시 잔액 환불.

**슬롯이 하나다 [구조 결정]**: 외부포인트 연동은 프린팅머니 전용 통로가 아니라 **샵바이 적립금 기능 전체를
후니로 돌리는 것**이다. 두 지갑 병행은 가이드만으로 성립이 확인되지 않았고, 그대로 두면
**리워드(할인)와 선수금(부채)이 후니 원장 한 통에 섞인다.**

## 리드 정정 3건 — 이 세션이 직접 재확인

계약 보충 4(교차 사실은 인용하는 쪽이 직접 `path:line` 확인)에 따라 **세 건 모두 직접 열어 봤다. 셋 다 리드가 옳다.**

| # | 원 문서 | 정정 | 이 세션 재확인 |
|---|---|---|---|
| 1 | t53 §3-7 — 캡처 변수 재대입을 `SQSMonitorService/Program.cs:120-121` | → **`:125-126`** | `:125` 가 `savePdfFileDirectory = Path.Combine(savePdfFileDirectory` · `:126` 이 이어지는 인자. `:120-121` 은 `{`·`try` 뿐 — **정정 채택** |
| 2 | t55 F-50 — 후니 `packages.config` md5 동일 **8**개 | → **9개** | `md5 -q Framework/*/packages.config \| sort \| uniq -c` → `9 078435635886cf070ccb2b271e298a0c` — **정정 채택** |
| 3 | t55 §2-B — `grep "CRT\." Pitstop/*.cs` **0건** | → **4건** | 4건 전부 `namespace CRT.Framework.Pitstop` **선언**이다(`EnfocusReport.cs:9`·`PitStopConfiguration.cs:7`·`VariableSet.cs:11`·`PitStopEnums.cs:7`). **grep 수치는 정정 채택**하되 원 결론(「CRT 타입 **참조** 0」)은 유지된다 — 선언은 참조가 아니다 |

3번은 **정정이 결론을 뒤집지 않는 사례**다. 수치는 고치되 「753줄만 옮기면 된다」는 판단은 그대로다.

## 인용 승격표 — 본문 축약 ↔ 전체경로

t54 가 짚은 함정이다: **이 저장소들에서 `path:line` 축약 인용은 위험하다.** 같은 파일명이 프로젝트마다 반복된다
(`Program.cs` 17개 · `OrderDac.cs` 4개 · 열림에는 `ProgramOld.cs` 죽은 사본까지 두 벌).
본문은 읽기 쉽게 축약을 쓰되, **모든 축약을 여기서 전체경로로 승격**한다. `t57/verify.py` C3 가 이 표를 기계 대조한다.

| 본문 표기 | 전체경로 |
|---|---|
| `ServerProcess/Program.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess/Program.cs` |
| `HotFolder/Program.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess.HotFolder/Program.cs` |
| `SQSMonitorService/Program.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.SQSMonitorService/Program.cs` |
| `AppArguments.cs` (A판) | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess/Common/AppArguments.cs` |
| `HotFolder/AppArguments.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess.HotFolder/Common/AppArguments.cs` |
| `AppReturnValue.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess.HotFolder/Common/AppReturnValue.cs` |
| `ActionsSetList.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.ServerProcess/Common/ActionsSetList.cs` |
| `PitStopConfiguration.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Framework.Pitstop/PitStopConfiguration.cs` |
| `EnfocusReport.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Framework.Pitstop/EnfocusReport.cs` |
| `VariableSet.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Framework.Pitstop/VariableSet.cs` |
| `PitStopEnums.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Framework.Pitstop/PitStopEnums.cs` |
| `RunPitstopCLI/Form1.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/RunPitstopCLI/Form1.cs` |
| `SaveAsErrorPdf/Program.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/CRT.Yeolim.SaveAsErrorPdf/Program.cs` |
| `FoxitSaveAs/Form1.cs` | `/Users/innojini/Dev/CRT.DigitalEdit.V2/FoxitSaveAs/Form1.cs` |
| `OrderCoreEndPoints.cs` | `/Users/innojini/Dev/TS.BackOffice.Huni/BackOffice.WebApi/CRT.EasyMES.V2.Web.Api/EndPoints/OrderCoreEndPoints.cs` |
| `CommandHandler/CommandService.cs` | `/Users/innojini/Dev/TS.BackOffice.Huni/BackOffice.Console/TS.BackOffice.WooCommerce.CommandHandler/CommandService.cs` |
| `TS.BackOffice.Huni.sln` | `/Users/innojini/Dev/TS.BackOffice.Huni/TS.BackOffice.Huni.sln` |
| `MotionOneInterface/Program.cs` | `/Users/innojini/Dev/TS.BackOffice.Huni/BackOffice.Console/CRT.EasyMES.V2.Console.MotionOneInterface/Program.cs` |
| `config/urls.py` · `urls.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py` |
| `widget_api.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py` |
| `shopby_hook.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/shopby_hook.py` |
| `shopby_sync.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/shopby_sync.py` |
| `shopby_client.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/shopby_client.py` |
| `admin.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/admin.py` |
| `widget.js` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/static/catalog/widget.js` |
| `tools/issue_site_key.py` | `/Users/innojini/Dev/HuniWeb/raw/webadmin/tools/issue_site_key.py` |
| `widget-order.ts` | `/Users/innojini/Dev/huni-skin-shopby/src/lib/api/widget-order.ts` |
| 스킨 `README.md` | `/Users/innojini/Dev/huni-skin-shopby/README.md` |
| `CARDS-S.md` | `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md` |

**주의 2건.** ① 열림 저장소에는 `ProgramOld.cs` **죽은 사본**이 두 벌 있어 grep 하면 같은 줄이 더 나온다 —
이 문서의 인용은 전부 **살아있는 `Program.cs`** 쪽이다. ② `AppArguments.cs` 는 A판·B판의 **작업 식별 규약이 서로 달라**
(숫자 jobId 접두 ↔ 파일명 `yyMMdd_코드`) 승격표에서 둘을 갈라 두었다 — 섞어 인용하면 결론이 뒤집힌다.

## 이 문서가 확정하지 못한 것

| # | 미확인 | 왜 |
|---|---|---|
| 1 | 금액 표현 단위 정본 (1원 vs 10원) | 세 문서가 다르다 — 결정 안건 |
| 2 | 자사몰이 결제 직후 주문등록 창구를 실제로 부르는가 | 라이브 미확인(CTO 9/8 이후 변동 없음) |
| 3 | `USP_ORD_ORDER_FILES_D` 의 `FILE_TYP` 필터 유무 | 라이브 SP 본문 미접속 |
| 4 | 샵바이의 무엇이 `USR_ORD_CD`/`MARKET_ORD_ITEM_NO` 가 되는가 | 스펙에도 코드에도 없다 |
| 5 | PitStop Server 23 라이선스·동시성·사양 | Enfocus 문서 영역 |
| 6 | 후니 워커 서버에 PitStop 이 같이 얹히는가 | 서버 실사 필요 |
| 7 | MES → webadmin 상태 push 경로 | 세 카드 모두 미실측 |
| 8 | `CommandHandler.UpdateTracking` 빈 본문이 의도인지 미구현인지 | 코드로 알 수 없다 |
| 9 | ⑦ 샵바이→MES 의 이음매 담당 | 11행 중 10행이 `NEW` — t56 이 판정할 원장 행이 없다 |
| 10 | `T4-3`·`STD-OPT-053` 의 담당 | t50 판본 ↔ t56 판본 상충 · t56 근거가 `rule-track`(약함) |
| 11 | ⑨ 의 「외부(상대측 회신 대기)」가 누구인가 | 상대측 회신 전 |
| 12 | `allow_domains` 가 신규몰에 실제로 채워지는가 | 채울 수단(화면·도구)이 없어 직접 DB UPDATE 외 경로 미확인 |

**「없다」는 전부 「찾지 못했다」다.** 돌린 grep 패턴은 각 카드 verdict 에 적혀 있고, 패턴 밖 구현이 있다면 이 판정은 틀린다.

## 담당 열 — 채워졌다 (t56 `5bb97cfd` 반영)

초판은 담당 열을 비워 두었다(S7-A 대기). t56 재작업이 끝나 **L1 표에 담당 열을 넣었다.**

| 항목 | 값 |
|---|---|
| 입력 | `.claude/worktrees/t56` · 브랜치 `WT-role-todo-rejudge` · 커밋 `5bb97cfd` · `t56/rejudge.csv` 735행 |
| 조회 방법 | 이음매별 원장 행 → `plan_row_id` → t56 판정 (`t57/owners.py` · 산출 `t57/owners.json`) |
| t56 판정 분포 | 담당맞음 457 · 재배정 141 · 미정 63 · provided 37 · 분할 36 · 불필요 1 |
| 근거 강도 분포 | `merged-owner_side` 366 · `evidence-path` 177 · **`rule-track` 95 + `rule-step` 89 = 약한 근거 184(25%)** · `manual-read` 8 |

**이 문서가 담당에 대해 하지 않는 것 3가지.**

1. **스스로 배정하지 않는다.** 담당 값은 전부 t56 이 판정한 것을 옮긴 것이고, 이 문서가 고른 것은 없다.
2. **약한 근거를 강한 것처럼 적지 않는다.** ⑦·⑧·⑨ 세 칸과 결정 사슬 9건 중 7건에 ⚠ 를 붙였다.
3. **상충을 임의로 닫지 않는다.** `T4-3`·`STD-OPT-053` 두 건은 t50 판본과 t56 판본을 **병기**했다 — 지니 확정이 필요하다.

**4경계 이탈 2건** — 지니 확정 경계(서희항 / 김동학 / 최숙진 / 신우진) 밖의 값이 둘 있다.
`미정`(⑦ 일부 · 결정 사슬 4건)과 `외부(상대측 회신 대기)`(⑨)다. **둘 다 사람이 아니라 상태**이며
그대로 두는 것이 맞다 — 사람 이름을 채우면 없는 배정을 만드는 것이 된다.
검산기 게이트 **C5** 가 이 규칙을 강제한다(§ 검산 참조).

---

## 금지 준수

DB write 0 · 라이브 DB 접속 0 · 라이브 COMMIT 0 · 세 대상 저장소(`CRT.DigitalEdit.V2` · `TS.BackOffice.Huni` ·
`huni-skin-shopby`) **쓰기 0 · 빌드 0 · 실행 0 · git 조작 0** · 자격증명 값 전사 0 · **날짜 추정 0** ·
작업량(일수) 추정 0 · 푸시 0 · `PRINTMONEY-BRIEF.md` 읽기만(워크트리 복사 0).
