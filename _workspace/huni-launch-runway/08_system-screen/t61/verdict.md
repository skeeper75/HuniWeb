# t61 verdict — 김동학 쇼핑개발 역할 5축 Todo

카드 t61 · 브랜치 `WT-mall-role-todo` · 워크트리 `.claude/worktrees/t61`
산출 = `mall-todo.md`(본문) · `axis-rows.csv`(행 원장) · `huni-mall-decisions.md`(결정 안건) ·
`build_axis.py`·`verify.py`·`verify-result.txt`(검산) · `spec-latest/`(샵바이 최신 명세 9개)

읽기전용 — DB write 0 · 라이브 접속 0 · MES 저장소 쓰기 0 · 날짜 추정 0 · 작업량 숫자 0.
t56 원장(`rejudge.csv`)은 **읽기만 했다** — 수정 0.

---

## 1. 행수

| 구분 | 수 |
|---|---:|
| 입력 `t56/rejudge.csv` (a83dc44b) | 735 |
| `owner_proposed` 에 「김동학」 포함 | **219** |
| 그중 남은 일(`remaining=Y`) = **이 카드의 분모** | **189** |
| `axis-rows.csv` 전체 | **211** |
| — 원장 행 | 189 |
| — **신규 제안** | **22** |
| 축 이동(리드 초안 접두 기본에서 옮긴 원장 행) | 16 |
| 결정 안건(`huni-mall-decisions.md` · 계약 보충 4) | 15행 / 13안건 + **신규 세운 안건 2** |

### 축별 분포

| 축 | 원장 | 신규 | 계 |
|---|---:|---:|---:|
| ① 탐색·상세 + 위젯 임베드 | 31 | 3 | 34 |
| ② 장바구니·주문·결제 | 42 | 4 | 46 |
| ③ 회원·마이페이지·클레임 | 66 | 3 | 69 |
| ④ 페이지빌더·정보화면 도구 | 23 | 2 | 25 |
| ⑤ Lightsail 이전·시스템 배선 | 27 | 10 | 37 |
| **합** | **189** | **22** | **211** |

### 원장 189행의 성격

- `status` — 미착수 123 · 부분 63 · 구현-미검증 1 · 없음 1 · 미실측 1
- t56 `verdict` — 담당맞음 127 · 재배정 34 · 분할 25 · 미정 3
- t56 `judged_by` — merged-owner_side 137 · evidence-path 23 · rule-track 13 · rule-step 12 · manual-read 4
  → **약한 근거(rule-\*) 25행**이 섞여 있다. t56 이 스스로 「제안이지 판정이 아니다」라고 적은 부분이다.
- 김동학 **단독이 아닌 공동 담당** 25행(분할·3분할 포함)

---

## 2. 카드 수치와의 차이 — 2행

카드는 「217행·남은 일 187」이라고 했고 내가 센 값은 **219 / 189** 다.
`owner_proposed` 가 3인 공동이거나 역할 접미가 붙은 **2행**(`STD-CAT-034` = `김동학+서희항+최숙진` ·
`BLK-S4-6` = `김동학·PM+신우진`)을 빼면 **정확히 217 / 187** 이 된다(재현 명령 §5).
리드가 그 기준으로 세었는지는 **관측한 것이 아니라 추정**이다. 두 행 다 김동학이 관여하므로
이 문서의 분모는 **189** 를 쓰고, 두 행은 ④·⑤에 남겼다.

---

## 3. 카드 지시 이행

| 지시 | 이행 |
|---|---|
| ㉮ 축별 원장 행 전수 수집(evidence 를 열어 확인) | 189행 전수 배정 · evidence 빈 칸 0(G4). 그중 핵심 자리는 직접 열었다 — `widget_api.py` handoff/verify·order_register 본문 · huni-mall `requote/route.ts`·`cart-page.tsx`·`widget-order.ts`·`product-sections.tsx`·`publications.ts` · `migration-plan.md` F4 전체 |
| ㉯ 원장에 없는 일 식별(신규는 제안) | **22건**(NEW-M1~M22) · 전부 「왜 신규인가」를 `why` 열에 기록 |
| ㉰ 선후 관계표 | `mall-todo.md` §8 — 들어오는 간선 12 · 나가는 간선 6. **간선 대부분이 원장에 없다**는 사실을 「원장 기록」 열에 명시 |
| ㉱ 「먼저 할 순서」를 작업량이 아니라 선후로 | `mall-todo.md` §9 — 0단계(못 정하는 것 5건) → 1~4단계 + ③ 전 구간 병렬 |
| 특별지시: Shopby 3갈래(호출 코드 / config / provided) | §5. **전수 자동 분류는 하지 않았다** — evidence 의 `shopby` 가 몰 도메인·저장소명과 겹쳐 신뢰 불가(무보정 121 → 두 토큰 제외 42, 그것도 오염). 사람이 판정한 행만 적었다 |
| 특별지시: provided 23행 headless 재확인 | §5-1. **21행 provided 유지** · **2행은 유지하되 config 짝 행 필요**(`STD-SHP-016`·`STD-PRM-009`). 관리↔고객화면 짝 8쌍 전부 원장에 실재함을 확인. `STD-SYS-003` 감사로그가 몰 자체 `/admin` 을 덮지 않는다는 공백 1건 보고 |
| 특별지시: ① 위젯 값 수신 3행을 서희항 API 계약과 대조(계약 직접 열람) | §① · §②. `urls.py:255-257,268` + `widget_api.py:4974`·`5275`·`5591` 직접 열람. **`item_id` 경로 서버키 필수**를 코드에서 확인(`:5623-5626`) |
| 특별지시: ④를 t59 콘텐츠 제안과 짝 맞춤 | §④ 표 — t59 ①②가 기다리는 도구 행을 1:1로 연결 |
| 용어 정정(스킨 → huni-mall 독립몰) | 본문 전체 적용. 인용 원문의 「스킨」은 원문 그대로 유지(migration-plan·원장 title) |
| 리드 5축 초안 수정 + 이유 | §6 — **정정 3건 유효 + 초판 정정 1건 철회**(리드 판정 260919) |
| 재배정·신규는 제안까지 · t56 원장 수정 금지 | 준수. `rejudge.csv` diff 0 |

### 리드 초안에서 고친 것 — 유효 3건

1. **`STD-ADC` 는 7이 아니라 6** — `STD-ADC-014` 는 t56 이 재배정→서희항 판정.
2. **초안 접두 10개 합(163) ≠ 남은 일(189)** — 빠진 26행을 성격대로 배정.
3. **`STD-SYS` 25행은 한 축이 아니다** — 7행이 ①③④의 일. `STD-SYS-045`(서버키)는 **②의 선행**이다.

### 초판의 정정 1건은 **철회**했다 (리드 판정 260919)

초판은 「⑤의 페이지빌더 Lightsail 이전은 성립하지 않는다」고 적었다. **틀렸다.**
증거 읽기는 맞았으나(`pie-canvas-model.md:20` Vercel icn1 · `:97` REST 미노출) **귀속 전제가 틀렸다** —
「파트너사」가 제3자 제품이 아니라 **김동학 대표의 작업분**이다(지니 확정 260919 · 후니프린팅에 맞게
제작해 **Lightsail 로 모두 통합**). Vercel 호스팅·REST 미노출·`/sites` 500 은 **옮길 수 없다는 근거가
아니라 출발 상태**다.

되살린 내용: ⑤에 **NEW-M17(상위) + 하위 6건**(M18 컨테이너화 · M19 저장 스키마·DB 목적지 ·
M20 Supabase Storage 이관 판정 · M21 도메인·Google OIDC · M22 `/sites`·`/assets` 500 선행 해소 ·
**M12 발행본 DB 동시 전환** — ④에서 옮겨 하위로 뒀고 버리지 않았다).
⑤ 머리에 「Lightsail 통합 대상 4개 = webadmin · DB · huni-mall · 페이지빌더」를 한 줄로 적었고,
**그중 페이지빌더만 `migration-plan` F1~F4 에 행이 0**임을 근거로 세웠다.
선후 반영: **서희항의 ⑤ 인프라(F4-1)가 선행**(§8 #9), **t59 ②상세탭·①가이드북이 후행**(§8 역방향 표).

이 철회 기록을 `mall-todo.md` §6 정정 1에 그대로 남겼다 — 다음 세션이 같은 문서를 읽고 같은 결론에
다시 도달하지 않게 하기 위해서다.

**찾지 못한 것**: 페이지빌더 소스 저장소. 돌린 패턴 2개 —
`find /Users/innojini/Dev -maxdepth 2 -iname '*canvas*' -o -iname '*vibe*' -o -iname '*pagebuilder*'` → 0건 ·
`grep -rl 'vibe-canvas|vc_v_product_detail_tabs' --include=package.json --include=README.md --include=CLAUDE.md /Users/innojini/Dev`
→ 소비자 쪽(huni-skin-shopby)만. 그래서 NEW-M18 의 첫 걸음을 「저장소 소재 확인」으로 뒀고,
M18~M22 는 2026-07-29 실측 문서 위에 세운 것이지 코드를 직접 보고 쓴 것이 아니다.

---

## 4. 이 카드가 처음 적은 사실 3건

1. **재견적 배관은 이미 있고 장바구니에만 달려 있다.** 유일한 호출부 `cart-page.tsx:126,177`.
   원장 `STD-ORD-029` 의 「미착수」 한 줄을 그대로 읽으면 **이미 있는 배관을 다시 만든다.**
2. **`order/register` 의 `item_id` 경로는 서버키가 스위치와 무관하게 필수**인데
   (`widget_api.py:5623-5626`), huni-mall 의 위젯 env 는 `HUNI_WIDGET_SITE_KEY` 하나뿐이다
   (`src/lib/printly/widget.ts:56`). 경로 선택이 곧 선행 작업을 바꾼다.
3. **샵바이 명세가 4월본에서 움직였고, 원장 판정 전제가 4건 바뀐다** — 나중배송(API 신설) ·
   상품쿠폰(2경로 삭제) · 앱카드(신설) · 회원 외부ID(신설). **삭제 3경로 전부 huni-mall 호출 0건이라 회귀는 없다.**

---

## 5. 실행한 검산 명령과 출력

```
$ python3 build_axis.py
입력 rejudge.csv = 735행 / 김동학·남은일 = 189행 / 출력 = 211행
  ('1.탐색·상세+위젯임베드', '신규제안'): 3
  ('1.탐색·상세+위젯임베드', '원장'): 31
  ('2.장바구니·주문·결제', '신규제안'): 4
  ('2.장바구니·주문·결제', '원장'): 42
  ('3.회원·마이페이지·클레임', '신규제안'): 3
  ('3.회원·마이페이지·클레임', '원장'): 66
  ('4.페이지빌더·정보화면 도구', '신규제안'): 2
  ('4.페이지빌더·정보화면 도구', '원장'): 23
  ('5.Lightsail 이전·시스템배선', '신규제안'): 10
  ('5.Lightsail 이전·시스템배선', '원장'): 27
OVERRIDE(원장 축 이동): 16 행

$ python3 verify.py
PASS G1 — rejudge.csv 735행 / 김동학·남은일 189행
PASS G2 — 원장 189행 · row_id 집합 일치
PASS G3 — 전체 211행 = 원장 189 + 신규 22 · 축 5개 1:34 2:46 3:69 4:25 5:37
PASS G4 — evidence 빈 행 0건
PASS G5 — 리드 초안 접두 10개 중 미포함 []
PASS G6 — 4월본 대비 삭제 경로 3건 {'product-server-public.yml': ['/products/{mallProductNo}'],
          'promotion-shop-public.yml': ['/coupons/products/download', '/coupons/products/issuable/coupons']}
PASS G7 — 「0건」 주장 13패턴 중 실제 히트 []

결과: 전부 PASS
```

카드 수치(217/187) 재현:

```
$ python3 -c "import csv; rows=list(csv.DictReader(open('../t56/rejudge.csv'))); \
  kd=[r for r in rows if '김동학' in (r['owner_proposed'] or '')]; \
  a=[r for r in kd if r['row_id'] not in {'STD-CAT-034','BLK-S4-6'}]; \
  print(len(a), sum(1 for r in a if r['remaining']=='Y'))"
217 187
```

최신 샵바이 명세 취득(로컬 `docs/shopby/shopby-api` 는 덮어쓰지 않았다):

```
$ curl -sS -o <f> -w "%{http_code}" https://docs.shopby.co.kr/spec/<f>          # shop 계열 6개 · 전부 200
$ curl -sS -o <f> -w "%{http_code}" https://server-docs.shopby.co.kr/spec/<f>   # server 계열 3개 · 전부 200
→ t61/spec-latest/ 9파일
```

---

## 6. 확정하지 못한 것 (전문은 `mall-todo.md` §11)

1. 샵바이 명세는 **경로 존재만** 비교했다 — 파라미터·응답 스키마 미확인.
2. 금액 단위(1원 vs 10원)를 판정하지 않았다. 돌고 있는 코드가 10원이라는 것만 실측.
3. 선후 관계표의 간선은 **제안**이고, 원장에 없다는 사실을 열로 표시했다.
4. 카드의 217/187 과 189 의 차이 원인은 **추정**이다.
5. Shopby 3갈래를 189행 전수로 분류하지 않았다(자동 분류 신뢰 불가).
6. **페이지빌더 소스 저장소를 찾지 못했다** — NEW-M18~M22 는 2026-07-29 실측 문서 위에 세웠다.
7. **라이브 접속 0** — `provided` 23행 evidence 의 셀러어드민 URL 은 t56 이 9/16 에 본 것이고
   내가 재확인한 것이 아니다.
8. 작업량·기간 0. **행수는 일의 크기가 아니다.**

---

## 7. 리드 회신용 한 줄

t61 재작업 완료 — `WT-mall-role-todo` · 산출 `08_system-screen/t61/`(mall-todo.md · axis-rows.csv **211행** =
원장 189 + 신규 22 · huni-mall-decisions.md · verify.py 7게이트 전부 PASS).
분모는 **189**(카드 187 과 2행 차 · 원인 §2). 리드 5축 초안 **정정 3건 유효**이고,
초판의 「페이지빌더 이전 철회」는 **철회**했다 — 귀속 전제가 틀렸다(파트너사 = 김동학 대표).
⑤에 **NEW-M17 + 하위 6건**으로 되살렸고 NEW-M12 는 그 하위로 옮겨 보존했다.
샵바이 최신 명세 9개 직접 대조 완료 — 삭제 3경로 전부 huni-mall 호출 0건(회귀 없음), 판정 전제 변경 4건.
