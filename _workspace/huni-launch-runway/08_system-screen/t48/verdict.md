# t48 verdict — shopby + huni-mall 화면·기능 원장

- 카드: **t48** (오픈일정 S1) · 레인 **lane-2** · 브랜치 `WT-shopby-mall-screens` · 워크트리 `.claude/worktrees/t48`
- 계약: `_workspace/huni-launch-runway/08_system-screen/CONTRACT.md` — **보충 1(개정판) · 2 · 3(명확화 포함) · 4 전부 반영**
- 산출: `screens.csv` · `shopby-decisions.md` · `huni-mall-decisions.md` · `out-of-scope.csv` · `build_screens.py` · `verify_screens.py`
- 금지 준수: DB write 0 · 라이브 COMMIT 0 · 라이브 접속 0 · MES 저장소 쓰기 0 · 숫자 날조 0 · 날짜 추정 0

## 1. 수치

| 항목 | 값 |
|---|---|
| `screens.csv` 행 | **271** |
| 화면(screen_id) | **58** |
| system | huni-mall **177** · shopby **94** |
| work_type | integrate **133** · config **72** · build **59** · provided **5** · manual **2** |
| status | 미착수 **149** · 진행 **58** · 완료 **40** · **미확인 24** |
| role | 고객 155 · 운영자(CS·상품) 67 · 시스템(무인) 33 · 관리자 16 · 생산(MES) **0** |
| **NEW** | **6** |
| **오픈분모밖**(보충 1 `[오픈분모밖] ` 접두) | **0** |
| **결정·관리 안건**(보충 4 · decisions.md) | **51** (shopby 20 · huni-mall 31) |
| 대상 구간 원장 | 405 = screens **265** + decisions **51** + out-of-scope **89** (누락 0) |

`role=생산(MES)` 0행은 결손이 아니다 — MES 화면은 이 카드의 두 시스템 밖이며 `out-of-scope.csv` 에 19행으로 이관돼 있다.

## 2. 분모와 세 갈래

원장 735행(`../../07_rebaseline/S/S5-plan/plan-rows.csv`) 중 최상위 28을 뺀 세부 707행에서, shopby·huni-mall 이 등장하는 20개 구간(A4·A5·B1·B4·B5·B6·B7·C1·C3·C6·C7·D1·D2·D3·D4·D5·E1·E2·E3·F4)을 뽑아 **405행**을 분모로 삼았다. 그 405행은 남김없이 셋 중 하나로 간다 — 어느 것도 버려지지 않는다.

| 갈래 | 행 | 어디로 | 왜 |
|---|---:|---|---|
| 화면·기능 | **265** | `screens.csv` (+ NEW 6 = 271행) | 이 카드의 본 산출 |
| 결정·관리 안건 | **51** | `shopby-decisions.md` · `huni-mall-decisions.md` | 보충 4 — 화면도 기능도 없다 |
| 다른 시스템 소관 | **89** | `out-of-scope.csv` | 화면이 webadmin·mes 등에 산다 |

### `out-of-scope.csv` 는 「오픈 분모 밖」이 아니다 — 리드 확인 요청분

리드가 이 파일을 보충 1의 분모밖 처리로 읽었는데, 둘은 다른 축이다.

- **보충 1 「오픈분모밖」** = 오픈과 인과관계 없는 **기존 자산**. 축은 *시간·인과*. 처리는 행을 `screens.csv` 에 남기고 evidence 접두. → 이 카드는 **0행**(§6).
- **`out-of-scope.csv` 89행** = 화면이 **다른 시스템에 사는 행**. 축은 *카드 경계*. webadmin 64 · mes 19 · 그 외 6(edicus·widget·pitstop·외부 결제/회계).

이 89행을 `screens.csv` 에 실으면 `system=webadmin`·`system=mes` 행이 생겨 t49·t50 과 **같은 행이 두 원장에 중복 등재**된다. 계약의 「대상 시스템 8」이 카드별로 시스템을 나눈 이상, 자기 시스템 밖 행은 실을 자리가 없다. 그래서 지우지 않고 별도 파일에 **행 단위로 라우팅 대상과 사유를 적어** 보존했다 — 「행을 빼지 않는다」는 취지는 지켰고, 누락 0은 검산 V11이 기계적으로 증명한다.

다만 이 판단은 t48 것이다. 리드가 「89행도 `screens.csv` 에 `system=webadmin/mes` 로 실어라」고 정하면 `build_screens.py` 의 `OUT_OF_SCOPE` 딕셔너리를 `MAP` 으로 옮기기만 하면 되고, 재작업은 크지 않다.

## 3. 직접 구현과 연동의 구분 (지니 요청의 핵심)

| work_type | 행 | 뜻 |
|---|---:|---|
| `integrate` | 133 | 두 시스템을 잇는 코드를 우리가 짠다 — 133행 전건 `counterpart`·`direction`·`owner_side` 채움 |
| `config` | 72 | 관리화면에서 설정·등록만. **코드 0** (셀러어드민 · AWS/Vercel 콘솔 포함 — 보충 2) |
| `build` | 59 | 우리 화면·로직을 직접 만든다. 상대 시스템 없음 |
| `provided` | 5 | 샵바이가 그대로 제공. 우리 작업 0, 확인만 |
| `manual` | 2 | 사람이 반복 운영으로 처리 — 수동카드결제 키인(STD-PAY-019) · 가상계좌 환불계좌 수기 수령(STD-CLM-026) |

`integrate` 133행의 방향: `huni-mall→shopby` **104** · `webadmin→shopby` **16** · `huni-mall→webadmin` **9** · `shopby→webadmin` **2** · `huni-mall→edicus` **2**.

한 화면에 성격이 다른 일이 같이 있으면 행을 나눴다. 원장 행이 곧 기능 단위라 분리가 자동으로 성립한다(예: `MALL-CHECKOUT` 이 build·integrate·config 로 갈린다).

보충 3의 **`config` 쌍둥이 금지**는 지켰다 — `config` 72행 전건이 원장 대응 행을 가진다(`plan_row_id` 가 전부 실재 id, 검산 V10). build 행에 기계적으로 만든 config 행은 **0**이다.

## 4. status 를 원장에서 그대로 베끼지 않은 이유 (14행 교정)

계약은 **「코드·화면을 실제로 본 것만 완료/진행」** 이다. 원장 status 가 `부분`·`구현-미검증` 인데 근거가 회의록(`후니정기미팅 정리260915.html`)이나 스코프 ID(`SCOPE-151`·`F-140`)뿐인 행이 **14건** 있었다. 이건 실측이 아니다. 각 행을 스킨 실사(`S1-skin/api-wiring.csv`, 84행·39 page.tsx 전건 커버)와 대조해 갈랐고, 교정한 행의 `evidence` 끝에 `|| [t48 교정] …` 로 사유를 남겼다.

14건 중 3건(STD-MYP-027 · STD-MYP-040 · STD-PRM-021)은 §5에서 decisions 로 다시 빠졌고, `screens.csv` 에 **11건**이 남아 진행 3 / 미착수 3 / 미확인 5 로 갈린다.

- **진행 유지 + 근거 보강 3** — STD-MEM-003·STD-SYS-012(가입 SMS 본인인증, `signup-form.tsx:43` 플래그 off) · STD-CAT-034(상세 탭, `product-sections.tsx:32-40`)
- **미착수로 내림 3** — STD-PAY-017(사업자정보, `validations/checkout.ts:35-43` 스키마만) · STD-PAY-018(거래명세서, `document-section.tsx:41-51` 정적) · STD-MYP-030(편집 보관함, 라우트 없음)
- **미확인으로 내림 5** — STD-SHP-007 · STD-SHP-012 · STD-SHP-013 · STD-SYS-029 · STD-ORD-018

## 5. 보충 4 — 결정·관리 안건 51행 분리

화면도 기능도 없는 안건(연동방식 결정·담당자 확정·작업범위 산정·구매 확인·게이트 결정)을 `screens.csv` 에서 빼 `<system>-decisions.md` 로 옮겼다. 열은 계약대로 `plan_row_id · 안건 · 미결 내용(완료 판정 기준) · 근거 · 결정 주체`.

- **shopby 20행** — 프린트머니 원장 소유(A vs B′) · 샵바이 외부포인트 협의 · Shopby 회원 일괄등록 수단 · 웹훅 등록 현황 · 결제수단 범위·계약 확인 등
- **huni-mall 31행** — `[선행 입력] BLK-*` 대부분 · 프린트머니 결정 요청 4건 · 담당·배치 확정 3건 · 증빙 발행 규칙·세무 확인 · 보관함 정책 3건 · 관리자 대시보드/Prisma DB 존폐 등

이 51행을 빼면서 `manual` 이 44 → **2**로 줄었다. 초판의 `manual` 이 컸던 이유가 바로 결정·회신 대기 행을 거기 담았기 때문이고, 보충 4가 그 자리를 따로 만들어 준 것이다. 남은 2행은 계약이 말한 검수·응대·수기 전달에 정확히 해당한다.

## 6. 보충 1(개정판) — 오픈 분모 밖 0행

`evidence` 앞에 `[오픈분모밖] ` 접두가 붙은 행은 **0**이다. 보충 1이 든 예(MES 의 카페24·우커머스·성원·이카운트 연동)를 전 행의 `function`·`evidence` 문자열로 훑어 **후보 0건**을 확인했다. shopby·huni-mall 은 이번 오픈으로 새로 서는 시스템이라 「이미 있고 오픈과 인과관계 없는 기존 자산」이 구조적으로 나오지 않는다. 그런 자산은 MES 쪽(t50)에 있다.

개정판이 철회한 「분모밖 = `work_type=provided`」 지정은 이 카드에 적용된 적이 없다(분모밖 0행). 현재 `provided` 5행은 접두 없는 정상 행이며 보충 3 축대로 「외부가 그대로 제공」인 것들이다 — 무통장 입금대기 상태 · 주문완료 알림 · 배송상태 알림 · 가입완료 메일 · 구매확정 적립금 자동지급. 전부 오픈 분모 **안**이다.

## 7. 보충 3(명확화) — owner_side=webadmin 인 integrate 18행

리드 결정 **(b)**: 레인 간 중복을 허용하고 t48 에 남긴다. 조건이었던 「evidence 첫 `path:line` 을 webadmin 코드의 실제 위치로」를 지키되, 보충 4의 **「인용하는 쪽이 직접 확인한다」** 에 따라 t49 의 주장을 옮겨 적지 않고 **t48 이 `raw/webadmin` 을 직접 읽어** 확인했다(260919).

| 확인 결과 | 행 | evidence 첫 위치 |
|---|---:|---|
| 코드 실재 | 3 | `shopby_sync.py:118·315`(상품 동기화) · `shopby_hook.py:82`(웹훅 수신) · `shopby_hook.py:112-121`(클레임 웹훅 저장) |
| 호출 지점 0건 | 15 | `shopby_client.py:137` — `request` 범용 호출만 있고 주문·송장·회원·적립금 전용 호출 함수가 없다 |

읽어서 알게 된 두 가지를 그대로 적어 둔다. **웹훅 메아리 필터(STD-MFG-030)는 구현돼 있지 않다** — `shopby_hook.py` 는 수신한 페이로드를 `TOrdWebhooks` 에 저장만 하고(`:121`) 자기가 올린 변경인지 가리지 않는다. **반품·교환 웹훅 기록(STD-MFG-124)의 기록 쪽은 실재한다** — `shop_clm_sts` 까지 저장한다(`:116`). 다만 「MES 작업 자동생성 안 함」 요건 전체를 확인하지는 못해 status 는 원장대로 두었다.

없는 것을 있다고 적지 않기 위해, 호출 지점이 0건인 15행에는 실재하는 파일의 위치(`shopby_client.py:137`)와 **무엇이 없는지**를 함께 적었다. t51 이 이 키로 t49 행과 합칠 때, 그 15행은 「양쪽 다 아직 코드가 없다」로 합쳐지는 것이 맞다.

## 8. 미확인 24행 — 무엇을 못 봤는가

전부 **관측하지 않아서** 미확인이지, 없다고 판정한 것이 아니다.

1. **셀러어드민 실화면 대부분** — 이 카드는 라이브에 접속하지 않았다(계약 「읽기전용」 준수 + 9/17 이후 셀러어드민 화면 캡처 산출물이 저장소에 없음). 구IA 이관 항목(`[구IA#64]` 공지 관리 등)·통계·쿠폰·회원관리가 여기 속한다.
2. **외부 회신 대기** — NHN커머스 · 토스페이먼츠 · 구 사이트 운영사(이 갈래의 상당수는 §5 decisions 로 빠졌다).
3. **명세 미상** — STD-ORD-018(reserve 필수 `termsType` 세트 미상).

1번을 없애는 길은 셀러어드민 화면 캡처 한 번이다.

## 9. 실행한 검산 명령과 출력

```
$ cd _workspace/huni-launch-runway/08_system-screen/t48
$ python3 build_screens.py
shopby-decisions.md   : 20
huni-mall-decisions.md   : 31
scope rows      : 405
out-of-scope    : 89
screens.csv rows: 271
decisions       : 51
unmapped        : 0

$ python3 verify_screens.py ; echo "EXIT=$?"
PASS V1 헤더 고정 — system,group,screen_id,screen_name,role,function,work_type,counterpart,direction,owner_side,plan_row_id,status,evidence
PASS V2 system 허용값(이 카드는 shopby·huni-mall 만)
PASS V3 role 허용값
PASS V4 work_type 5값 — {'config': 72, 'manual': 2, 'integrate': 133, 'provided': 5, 'build': 59}
PASS V5 status 4값 — {'미확인': 24, '미착수': 149, '완료': 40, '진행': 58}
PASS V6 integrate 는 counterpart·direction·owner_side 필수 — 결손 0
PASS V7 비-integrate 행에 연동 3열 없음 — 오염 0
PASS V8 근거 없는 행 0 — 빈 근거 0
PASS V9 완료/진행 행은 파일:줄·URL·산출물 경로 근거 보유 — 약한 근거 0
PASS V10 plan_row_id 는 실재하는 735행 id — 미존재 0
PASS V11 대상 구간 원장 누락 0 (screens ∪ out-of-scope ∪ decisions == scope) — 미분류 0
PASS V14 decisions 는 screens 와 겹치지 않는다(보충 4 이중계상 방지) — 겹침 0
PASS V15 decisions 는 원장 실재 id — 미존재 0
PASS V12 screens 와 out-of-scope 교집합 0 — 0
PASS V13 보충1 분모밖 접두는 provided 행에만 — 분모밖 0 행

행수            : 271 (screens.csv)
화면 수         : 58
system          : {'shopby': 94, 'huni-mall': 177}
work_type       : {'config': 72, 'manual': 2, 'integrate': 133, 'provided': 5, 'build': 59}
status          : {'미확인': 24, '미착수': 149, '완료': 40, '진행': 58}
role            : {'운영자(CS·상품)': 67, '관리자': 16, '시스템(무인)': 33, '고객': 155}
미확인          : 24
NEW             : 6
오픈분모밖      : 0
결정·관리 안건  : 51 (shopby+huni-mall decisions.md)
대상 구간 원장  : 405 (screens 265 + out-of-scope 89 + decisions 51)
EXIT=0
```

`verify_screens.py` 는 읽기전용이며 `screens.csv`·`out-of-scope.csv`·두 `decisions.md`·원장 735행만 읽는다. 재실행하면 같은 출력이 나온다. V13 은 보충 1 개정으로 구속력을 잃었지만(분모밖 행의 work_type 은 이제 보충 3 축을 따른다) 이 카드는 분모밖 0행이라 참으로 남아 있다 — 분모밖 행이 생기는 카드에서는 이 검사를 떼야 한다.

## 10. 입력 원천

| 원천 | 경로 | 쓰임 |
|---|---|---|
| 원장 735행 | `07_rebaseline/S/S5-plan/plan-rows.csv` (워크트리 = `origin/main` `48714c44`) | 분모·`plan_row_id`·`function`·`evidence`·원장 status |
| 스킨 배선 실사 84행 | `_workspace/.../S/S1-skin/api-wiring.csv` (메인 체크아웃 **미추적**) | status 교정 14행 · NEW 6행의 근거 |
| 스킨 라우트 39 | `~/Dev/huni-skin-shopby/src/app/**/page.tsx` | `MALL-*` 화면 축 |
| webadmin 샵바이 연동 코드 | `raw/webadmin/webadmin/catalog/shopby_{client,sync,hook}.py` | §7 의 18행 evidence — t48 직접 확인 |
| 9/17 확정 전제 | `07_rebaseline/S/CARDS-S.md` §0-A · `HANDOFF.md` | relitigate 하지 않음 |

원장 `plan-rows.csv` 는 메인 체크아웃 로컬 `main`(`90be92fb`)에 **없다** — 원격 `origin/main` 에만 있어 워크트리를 원격 기준으로 만들어 확보했다. 메인 체크아웃에서 찾으면 없는 것처럼 보인다.

## 11. 남은 것 / 다음 카드가 알아야 할 것

- **셀러어드민 화면 캡처가 없다.** 미확인 24의 대부분을 푸는 열쇠다. 라이브 접속은 이 카드 계약이 금지해 하지 않았다.
- **`out-of-scope.csv` 89행은 버려진 것이 아니다.** webadmin 64 · mes 19 등은 해당 시스템 카드가 받아야 한다. 받지 않으면 735행 원장에서 조용히 사라진다(§2의 리드 확인 요청 참조).
- **웹훅 메아리 필터 미구현은 t49 와 공유할 사실이다** — `shopby_hook.py` 가 저장만 한다는 것은 t48 이 직접 읽어 확인했다.
- **STD-SYS-028(webadmin 영역 분리)이 미해결이라 shopby/webadmin 경계가 유동적이다.** 분리가 확정되면 `owner_side=webadmin` 인 18행의 귀속을 다시 볼 필요가 있다.
- **t51이 소비할 `scope` 열은 접두로 파생하면 된다** — 이 카드는 접두 행이 0이라 전 271행이 `in` 이다.

---

작성: lane-2 · 2026-09-19
