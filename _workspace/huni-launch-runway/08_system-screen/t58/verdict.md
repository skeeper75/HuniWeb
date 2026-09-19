# t58 — 오픈일정 S7-C · 위젯 몫 실독 (260919 · 레인 t58 · 브랜치 `WT-widget-scope-read`)

카드 t58(class C · SPEC 없음 · 조사·문서 · 읽기전용). **DB write 0 · 라이브 DB 접속 0 · 실화면 접속 0 · 코드 수정 0.**
대상 = `/Users/innojini/Dev/HuniWeb/raw/webadmin`(별도 git 저장소 · 절대경로 읽기만).
대조 원장 = `08_system-screen/t51/merged.csv`(747행) · `07_rebaseline/S/S5-plan/plan-rows.csv`(735행) · `t52/rejudge.csv`(83행).

> **경로 표기** — 이하 `raw/webadmin/...` 는 전부 `/Users/innojini/Dev/HuniWeb/raw/webadmin/...` 의 줄임이다.
> `_workspace/...` 는 `/Users/innojini/Dev/HuniWeb/.claude/worktrees/t58/_workspace/...`.

---

## 0. 한 장 요약 — 위젯 5구간

지니 확정(260919) 흐름 = **상품선택 → 가격계산 → 에디터 → 파일업로드 → PitStop/MES 연계**.
코드로 확인한 결과, **앞 4구간은 위젯 안에서 거의 완성돼 있고 5구간(PitStop·MES)은 위젯 밖에서 통째로 비어 있다.**

| # | 구간 | 구현 위치(대표) | 상태 | 오픈 전 남은 일 요지 |
|---|---|---|---|---|
| ① | 상품선택(사양 선택) | `raw/webadmin/webadmin/catalog/static/catalog/widget.js:134` · `widget_renderer.js:28` · `widget_api.py:1172`·`:5844` | **있음** | 허용사이트(도메인+site_key) **등록 수단 부재** · 게시 위젯 기본값 전수 점검 |
| ② | 가격계산 | `widget_api.py:3029` `api_price` · `:3043` `_price_core` · `:4150` `_quote` | **있음** | 게시 위젯 가격 전수 대조·3단계 승인(운영 과업) |
| ③ | 에디터(Edicus) | `widget_api.py:5758` `api_editor_resolve` · `:5803` `api_editor_token` · `widget.js:392`·`:414`·`:584` | **있음(코드) / 부분(데이터)** | 편집기 템플릿 연결 **구멍 21건 + 1상품 blocked** 미충전 · 에디터 산출물 렌더→접수 경로 미실측 |
| ④ | 파일업로드 | `widget_api.py:4756` `api_upload_presign` · `:4948` `api_upload_multipart` · `widget.js:773`·`:799`·`:819` | **있음(주문 전) / 없음(주문 후)** | 앞/뒷면 분리 업로드 · VDP · **결제 후 재업로드 경로 전무** · 실패 자동 재시도 없음 |
| ⑤ | PitStop·MES 연계 | **찾지 못했다** — 코드 0 | **없음** | 바이러스검사·프리플라이트·MES 전송(WCF)·상태통보 수신 전부 미착수. 승격(tmp→order)까지만 있음 |

**한 줄 결론:** 「위젯 133행 중 남은 일 5행」은 **사실이 아니다.** 133행이라는 분모가 위젯의 **앞쪽 4구간만** 담고 있고, 5구간과 파일업로드 후반부는 `system=webadmin`·`system=pitstop`·`system=mes` 행으로 흩어져 있거나 **어느 원장에도 없다**.

---

## 1. 「남은 일 5행」 판정 — 5행 전수 실독

`t51/merged.csv` 의 `system=widget` 133행 중 `status≠완료` 는 정확히 **5행**이다(실측). 그 5행을 코드로 확인했다.

| row_uid | 기능 | 원장 status | **실독 판정** | 근거 |
|---|---|---|---|---|
| t49:318 | 미리보기 원고 업로드 presign 발급 | 미확인 | **완료** | `raw/webadmin/webadmin/catalog/widget_views.py:858` `widget_preview_presign` — 런타임과 같은 `_check_files`·`PREVIEW-` 키 격리까지 구현 |
| t49:319 | 미리보기 대용량 멀티파트(create\|sign\|complete\|abort) | 미확인 | **완료** | `widget_views.py:924` `widget_preview_multipart` — 런타임과 같은 `wapi._multipart_dispatch` 재사용 |
| t49:215 | 신규몰 도메인을 허용 사이트에 등록 | 미확인 | **미착수 · 게다가 수단이 없다** | `TWgtSites` 는 Django admin 에 **미등록**(`webadmin/catalog/admin.py` 전문 grep 0건). `raw/webadmin/tools/issue_site_key.py:35` 는 `site_key` 만 UPDATE 하고 **`allow_domains` 를 쓰는 도구는 없다**. 설계에는 화면이 예정돼 있었다 — `raw/webadmin/docs/widget-builder-design.html:587` 「site-key(공개) 발급·관리 화면(t_wgt_sites 확장)」 |
| t49:259 | 게시 위젯 전수 기본값 미지정 점검·지정 후 재게시 | 진행 | **진행 유지** | 운영 과업(코드로 판정 불가). 근거 원문 `raw/webadmin/tools/widget_manual_content.py:793` COMMON_PROPS |
| t49:316 | 게시 위젯 가격 전수 대조·3단계 승인 | 진행 | **진행 유지** | 운영 과업(코드로 판정 불가) |

**판정:** 5행 중 **2행은 이미 끝났고**, 1행은 기록보다 **더 나쁘며**(등록 수단 자체가 없다), 2행은 코드가 아니라 사람이 해야 하는 일이다.
→ 위젯 133행 안의 「코드로 남은 일」은 **1건**(허용사이트 등록 수단). 그러나 아래 §2·§4 에서 보듯 **원장이 「완료」라고 적은 행 안에도 남은 일이 있고, 원장 밖에 더 많다.**

---

## 2. 구간별 상태 · 남은 일

### ① 상품선택(사양 선택)

- **어디서 일어나나** — 상품을 고르는 행위 자체는 쇼핑몰 PDP 이고, 위젯은 그 상품의 **주문서 화면**이다. 매뉴얼 원문: `raw/webadmin/tools/widget_manual_content.py:133` 「주문위젯은 고객이 우리 상품을 주문할 때 보는 **주문서 화면**입니다」.
- **구현** — `widget.js:134`(embed 속성 `widget-id`/`site-key` 검사) → `widget.js:145`(`/api/w/v1/widgets/<wgt_cd>` 로 게시본 설정 조회) → `widget_renderer.js:28` `SRC`(20종 소스유형 렌더). 카탈로그·시작가는 `widget_api.py:5844` `api_catalog`.
- **게이트** — `widget_api.py:797` `_gate`(site_key + `allow_domains` Origin/Referer + rate limit), `:709` `_origin_allowed`. ⚠ `allow_domains` 가 **비어 있으면 무조건 통과**한다(`widget_api.py:710` 주석 「미설정=통과」).
- **남은 일**
  - **(신규 발견)** 허용사이트 등록·도메인 편집 **화면·도구 부재** → 신규몰 도메인 추가 = 직접 DB UPDATE. `allow_domains` 미설정이면 Origin 검사가 사실상 꺼진 채 오픈된다.
  - 게시 위젯 전수 기본값 점검(t49:259, 운영).

### ② 가격계산

- **구현** — `widget_api.py:3029` `api_price` → `:3043` `_price_core`. 서명 경로(`/handoff`)와 재견적(`/handoff/requote`)은 **같은 `_quote`**(`widget_api.py:4150`)를 쓴다 — 엔드포인트마다 계산이 갈리지 않게 한 벌로 묶여 있다(`:4702` 주석).
- 클라이언트: `widget.js:682` (선택 변경 시 서버 재계산 요청). 표시가=서명가 원칙이 코드 주석에 반복 고정돼 있다(`widget.js:987`·`:993`).
- **남은 일** — 코드 쪽에서 찾지 못했다. 남은 것은 **데이터·운영**(게시 위젯 가격 전수 대조 3단계 승인 = t49:316).

### ③ 에디터(Edicus)

- **구현** — `widget_api.py:5758` `api_editor_resolve`(옵션조합→PSCode·템플릿 URI) · `:5803` `api_editor_token`(사용자 토큰 대리 발급). 클라이언트 `widget.js:392`(resolve 호출) · `:414`(에디터 SDK 로드·오버레이) · `:584`(토큰 요청) · `:331` `setEditorResult`(docInfo 반영). SDK 본체 `raw/webadmin/webadmin/catalog/static/catalog/huni_editor_sdk.js`.
- 비회원 증표: `widget.js:446` `_guestToken` → handoff 에 `guest_token` 으로 실려 서버가 `edicus_uid` 를 서명에 넣는다(`widget_api.py:4047` `_edicus_uid_for`, `:4685` payload `edicus_uid`). 코드 주석(`widget.js:1000`)이 「빠지면 그 주문은 원고가 있어도 인쇄로 넘어가지 못한다」고 명시한다.
- **남은 일**
  - **(신규 발견 · 데이터)** 편집기 템플릿 연결 구멍이 남아 있다 — `raw/webadmin/tools/edicus_coverage_baseline.json`(updated 2026-09-16): `PRD_000062` miss **5**, `PRD_000063` miss **16**, `PRD_000226` **blocked:true**. 계획 원장 `STD-ART-030`(「옵션 조합에 연결된 편집기 템플릿 없음」 오류) 상태 = **미착수**. 원장은 이 자리를 `t49:218 = 완료`로 적고 있다 — **코드는 완료, 데이터는 미완**이다.
  - 에디터 산출물 → 인쇄용 렌더 → 접수 경로: `t50:103`(EDI-15)가 `완료`이나 그 행의 function 자체가 「현행 구현 여부 **미실측**」이라고 적혀 있다. 이 레인에서도 webadmin 코드에서 렌더 트리거를 **찾지 못했다**(돌린 패턴 §6).

### ④ 파일업로드

- **주문 전(있음)** — `widget_api.py:4756` `api_upload_presign`(서버는 권한만 발급, 파일은 브라우저→S3 직행) · `:4948` `api_upload_multipart`(create/sign/complete/abort). 클라 `widget.js:773` `_upload`(파일 간 **순차**) · `:799` `_uploadSingle` · `:812` **진행률 콜백** · `:819` `_uploadMultipart`. 검증은 `widget_api.py:2179` `_check_files`(소속·확장자·용량·개수) — 빌더 미리보기도 **같은 함수**를 쓴다(`widget_views.py:863` 주석).
- **주문 후(없음)** — 승격까지만 있다: `raw/webadmin/webadmin/catalog/artwork_promote.py`(tmp→order `CopyObject` + `head_object` 실측 + `promoted=true` 태깅, 결과 `t_ord_artworks`). 그 앞뒤(재업로드 링크·회차 증가·검사 재실행)는 코드 0.
- **남은 일**
  - 앞면/뒷면 **분리 업로드** — 업로드 항목 props 에 `side` 개념이 없다(`widget_api.py:2091` `_file_accept` / `:2100` `_file_max_mb` / `:2108` `_file_max_files` / `:2118` `_inst_of` 가 전부 — 좌표계는 `item·mbr·inst` 뿐). 계획 `STD-ART-005` = 부분.
  - **VDP** — 명시적으로 미이식: `huni_editor_sdk.js:4` 「레드프린팅 전용 KOI-Passive 채널·Sentry·**VDP**·팔레트는 이식하지 않는다」. 계획 `STD-ART-029` = 미착수.
  - **실패 자동 재시도 없음** — `widget.js:784` 는 실패를 `{error: …}` 로 표시할 뿐 재시도하지 않는다(고객이 다시 고름). 계획 `STD-ART-003` = 부분.
  - **결제 후 업로드·재업로드 경로 전무** — `STD-ART-006`·`STD-ART-007`·`STD-MFG-054~057`. 재업로드 화면은 pitstop 레인 `t50:130`(PS-23, 미착수)에 「위젯 업로드 컴포넌트를 재사용해」로 적혀 있다 → **위젯 몫이 pitstop 시스템 행에 걸려 있다.**

### ⑤ PitStop · MES 연계 — **위젯/webadmin 쪽 코드 0**

실행한 전수 탐색(§6 검산 2·3)의 결과:

- **PitStop** — `raw/webadmin` 의 `*.py`·`*.js`·`*.html` 전체에서 `pitstop|pit_stop|pit-stop` **0건**. 등장은 `docs/*.md` 뿐이고 전부 「향후·예정」 표기다(`raw/webadmin/docs/aws-architecture-huni.md:21` 「PitStop Server (EC2 Windows) — **추가 예정**」, `:210` 「PitStop 도입 시」).
  → **t53·t54 의 「MES 에 PitStop 코드 0」 판정은 webadmin 쪽에서도 같다.** 세 저장소 모두 PitStop 코드가 없다.
- **바이러스 검사** — `clamav|virus|scan_engine|artwork_scan` 전체 **0건**(비-venv). 설계 문서만 있다(`docs/artwork-scan-integration.md`).
- **MES 전송** — `wcf|mes_send|send_to_mes|mes_client` **0건**. `MES_SENT` 는 `tests/test_artwork_promote.py:400` 의 **가드 테스트 상수**로만 존재한다(승격이 그 상태를 건드리지 않는지 확인하는 용도, `artwork_promote.py:54` 주석).
- **있는 것** — 주문 등록 `widget_api.py:5591` `api_order_register`(`POST /api/w/v1/order/register`, `config/urls.py:268`), 샵바이 웹훅 수신 `webadmin/catalog/shopby_hook.py`(`urls.py:272`), 승격 `artwork_promote.py`, 그릇 `t_ord_orders`(`models.py:1091`)·`t_ord_artworks`(`:1133`)·`t_ord_webhooks`(`:1177`).
- 설계 정본의 자기 진술도 같다 — `raw/webadmin/docs/order-to-mes-process.md:10` 「**SF-1 을 제외한 나머지는 아직 코드가 없습니다**」.

> ⚠ 그 문서 §11 체크리스트는 **260818~19 시점 스냅샷**이라 지금 코드와 어긋나는 칸이 있다(예: `submit()` 의 `handoff_id` 노출은 이미 됐다 — `widget.js:1011`). 판정은 문서가 아니라 코드로 했다.

---

## 3. 위젯 → 쇼핑몰 값 전달(handoff) 계약

### 무엇을 어떤 모양으로 넘기나

1. **브라우저**: `widget.js:953` `submit()` — `canOrderReasons()` → `/api/w/v1/validate` → `/api/w/v1/handoff` → `huni:submit` 이벤트 방출.
   이벤트 detail = 반환값과 **같은 객체 한 벌**(`widget.js:1010`): `{ ok:true, token, payload, handoff_id, summary, expires_in }`.
   실패도 항상 resolve 한다 — `{ ok:false, code, message, reasons|violations|errors }`, `code ∈ not_ready|incomplete|constraint|validate_failed|handoff_failed`(`widget.js:944` 계약 주석).
2. **서버**: `widget_api.py:4735` `api_handoff` → `:4699` `_handoff_core` → `:4150` `_quote` 로 **전량 서버 재계산** 후 `_sign(payload)`(`:3456`, HMAC).
   응답 최상단에 `token`·`payload`·`expires_in`·`handoff_id`·`qty_rule`(`widget_api.py:4721~4731`). `handoff_id` 는 **서명 대상 밖**(추적·조인 키).
3. **서명 payload 의 모양**(`widget_api.py:4624~4691`) — `v·site_cd·wgt_cd·ver_no·prd_cd·cust_key·selections·sel_opts·sel_opt_grps·options·combo·set·addons·proc_sels·grade_cd·dsn_cd·case_cnt·pages·order_title·spine·spine_color·qty_info·supply·vat·total·files·editors·edicus_uid·ts·orig_ts`.
   즉 **금액(공급가·부가세·청구액)·제작사양 전문·원고 S3 키·Edicus uid** 가 전부 서명 안에 들어간다 → 인계 후 위변조 불가.

### 스킨(쇼핑몰)이 무엇을 검증·저장해야 하나

| 순서 | 호출 | 무엇을 | 근거 |
|---|---|---|---|
| 1 | `POST /api/w/v1/handoff/verify` (S2S) | 토큰 서명·`site_cd` 일치·**판매중지 상품 차단** 재확인 | `widget_api.py:4974`·`:5002`(`_prd_sellable_err` 로 `product_unpublished` 반려) |
| 2 | `POST /api/w/v1/cart/items` 계열 (S2S) | 토큰·payload 를 자사몰이 들고 있지 않게 **우리 쪽 보관소**에 맡김 | `config/urls.py:263~267` · 헤더 `X-Huni-Server-Key` 필수 · CORS 미개방 |
| 3 | `POST /api/w/v1/handoff/requote` (S2S) | 결제 직전 재견적(수량 변경 포함) — 금액 최종 확정 | `widget_api.py:5275` |
| 4 | `POST /api/w/v1/order/register` (S2S) | 주문 생성 **직후** `{site_key, order_no, line_no, token}` → 사양·원고를 주문번호에 묶음. 멱등(`already:true`), 같은 자리 다른 사양 409 | `widget_api.py:5591` · `urls.py:268` · `docs/order-to-mes-process.md:416` |

### 원장의 4행(rt_submit·wapi_handoff·wapi_handoff_verify·wapi_handoff_requote)이 전부 「완료」인가 — **맞다, 다만 계약에 한 칸 비어 있다**

네 엔드포인트 모두 구현·라우팅 실재를 확인했다(위 근거). 다만:

- **`verify` 응답에 `handoff_id` 가 없다** — `widget_api.py:5005` 의 반환은 `{ok, valid, payload|reason}` 뿐이다. 설계 정본이 남은 일로 적어 둔 항목(`docs/order-to-mes-process.md:650` 「`submit()` 결과와 `verify` 응답에 `handoff_id` 노출(현재 둘 다 빠져 있음)」) 중 **`submit()` 쪽만 해소**됐다(`widget.js:1011`, 주석이 260818 발견이라 적고 있다). **`verify` 쪽은 여전히 미노출.**
- **4행 모두 `MALL-SERVER` 반대편이 미착수다** — `t48:192`(handoff/verify 재검증 호출) · `t48:193`(order/register S2S 호출) · `t48:239`(결제 직전 재견적) 전부 `미착수`. 즉 **우리 쪽은 완료, 부르는 쪽이 없다.** 「완료 4행」을 오픈 준비 완료로 읽으면 안 된다.

---

## 4. 원장 대조 — 5구간 관련 행 전수

### 4-1. `system=widget` 133행 분포(실측)

| 축 | 분포 |
|---|---|
| status | 완료 128 · 미확인 3 · 진행 2 |
| work_type | build 108 · integrate 22 · config 2 · manual 1 |
| scope | in 133 (분모밖 0) |
| group | 위젯빌더(운영자) 93 · 위젯 런타임(고객) 23 · 위젯 API 11 · SDK·임베드 6 |

**93/133 이 위젯빌더(운영자) 행이다.** 고객 흐름 5구간에 직접 걸리는 행은 런타임 23 + API 11 + SDK 6 = **40행**뿐이다. 「위젯 133행」을 고객 흐름의 분모로 읽으면 실제보다 2.4배 커 보인다.

### 4-2. 위젯 API 가 두 시스템으로 갈라져 있다

같은 `widget_api.py` 안의 엔드포인트가 `system=widget`(11행)과 `system=webadmin`(10행)으로 나뉘어 있다.

- `system=widget` — `wapi_widget·catalog·price·validate·presign·multipart·handoff·handoff_verify·handoff_requote·editor_resolve·editor_token`
- `system=webadmin` — `wapi_cart_add`(t49:200)·`wapi_cart_fetch`(t49:201)·`wapi_cart_item`(t49:202)·`wapi_order_register`(t49:208)·`shopby_webhook`(t49:199)·`wapi_guides`·`wapi_designs`·`wapi_design_image`·`wapi_main_image(s)`·`wapi_swatch_image`

**이 분할 자체는 결함이 아니다**(계약 보충 3: 코드가 사는 쪽이 갖는다 — 둘 다 webadmin 코드다). 다만 **「위젯 몫」을 `system=widget` 으로만 세면 장바구니 보관소·주문등록·웹훅이 빠진다.** 위젯 계약의 뒤쪽 절반이 그쪽에 있다.

### 4-3. 원장이 「완료」인데 남은 일이 있는 행 (2건)

| row_uid | 원장 | 실독 | 근거 |
|---|---|---|---|
| t49:218 `wapi_editor_resolve` | 완료 / `STD-ART-030` | 코드 완료 · **데이터 미완** | `tools/edicus_coverage_baseline.json` miss 21 + blocked 1 · 계획행 `STD-ART-030` 상태 미착수 |
| t49:222 `wapi_handoff_verify` | 완료 / `STD-PAY-031` | 동작 완료 · **계약 한 칸 미노출** | `widget_api.py:5005` 응답에 `handoff_id` 없음 |

---

## 5. 계획 원장(서희항 202행) 대조

`plan-rows.csv` 735행 중 `owner_name=서희항` = **202행**(T2 96 · T4 83 · T1 14 · T5 4 · T3 3 · T7 2).
그중 위젯 5구간 낱말(위젯·편집기·에디터·edicus·업로드·원고·핸드오프·PitStop·MES)이 걸린 행 = **57행**.

- 그 57행 중 `merged.csv` 에 `plan_row_id` 로 대응 행이 있는 것 = **22행**(system 분포: widget 18 · pitstop 8 · webadmin 5 · edicus 5 · mes 3 · shopby 2 — integrate 중복 포함).
- **대응 행이 없는 것 = 35행.** 그중 **6행만** t52 가 이미 재판정했고(`STD-MFG-022·024·025·028·125·126`), **29행은 t52 재판정에도 없다.**
  - t52 의 입력은 「t48 `out-of-scope.csv` 89행의 부분집합 83행」이었다(`t52/verdict.md:8`). 따라서 **t48 이 넘기지 않은 계획행은 t52 의 분모 밖**이었다 — 이 29행이 거기 해당한다.

**즉 위젯·원고·MES 축에서 계획 원장에는 있는데 화면·기능 원장 747행에도 t52 재판정 83행에도 없는 일이 29건 있다.** 상세 판정은 `t58/ledger-proposal.csv`.

### 다른 담당에 잘못 걸린 위젯 일

- `STD-MFG-055`(재업로드 화면 — 「**위젯 업로드 컴포넌트 재사용**」) 는 담당 서희항이고 원장에도 있다(`t50:130` PS-23). **담당 배정은 맞고**, 시스템만 `pitstop` 으로 잡혀 있다. 보충 3 상 owner_side(코드가 사는 쪽)는 위젯/webadmin 이므로 **`system` 을 다시 볼 자리**다 — 다만 이 판단은 pitstop 레인(t50)의 몫이라 **제안까지만** 둔다.
- 그 밖에 「위젯 일인데 다른 담당에 걸린 행」은 **찾지 못했다**(위젯 낱말이 걸린 계획행 중 서희항 외 담당은 최숙진의 데이터·가격 행들로, 코드 작업이 아니다).

---

## 6. 원장 보강 제안

행 고치기는 **제안까지만** 한다(t49·t50·t51 원장 직접 수정 금지). 산출 = **`t58/ledger-proposal.csv`** (열: `구분 · 대상원장 · 키 · 제안 · 근거 · 근거요지`).

| 구분 | 건수 | 뜻 |
|---|---:|---|
| **A. status 정정** | 3 | 코드 실독으로 판정이 바뀌는 기존 행 |
| **B. 재연결만**(원장 실재 · `plan_row_id` 연결) | 5 | 행 추가 불요 |
| **C. 빠진 일**(행 추가 제안) | 21 | 747행·t52 83행 어디에도 없다 |
| **D. 결정·관리 안건**(계약 보충 4) | 5 | `t58/widget-decisions.md` 로 이관 |
| **E. 완료 행에 붙일 보강 행** | 2 | §4-3 의 2건 |

**C 21건의 대상 원장 분포** — t49(webadmin) **15** · t49(widget) **4** · t50(pitstop) **2**.
그중 **이미 구현돼 있는데 원장에 행이 없는 것이 4건**(`STD-MFG-004`·`008`·`009`·`011` — 원고 승격 축)이다.
남은 17건은 미구현이다. 즉 원장 누락은 「아직 안 한 일」만이 아니라 **「이미 한 일」도 빠뜨리고 있다.**

D 5건은 `t58/widget-decisions.md` 에 옮겨 적었다(지우지 않고 옮긴다 — 계약 보충 4).

### 산출물

| 파일 | 내용 |
|---|---|
| `t58/verdict.md` | 이 문서 — 5구간 요약·구간별 상태·handoff 계약·원장 대조 |
| `t58/ledger-proposal.csv` | 원장 보강 제안 36행(A 3 · B 5 · C 21 · D 5 · E 2) · 열 = 구분·대상원장·키·제안·근거·근거요지 |
| `t58/widget-decisions.md` | 계약 보충 4 이관분 5건 + 결정에 막힌 행 제안 4건의 의존 관계 |

---

## 7. 실행한 검산 명령과 출력

| # | 명령(요지) | 출력 |
|---|---|---|
| 1 | `merged.csv` 에서 `system=widget` 집계 | 133행 · status 완료 128/미확인 3/진행 2 · work_type build 108/integrate 22/config 2/manual 1 · scope in 133 |
| 2 | `grep -rni "pitstop\|pit_stop\|pit-stop" --include='*.py' --include='*.js' --include='*.html' --include='*.md'` (raw/webadmin, .venv·node_modules·.git 제외) | 코드 **0건** · `docs/*.md` 20건(전부 향후·예정) |
| 3 | `grep -rniE "wcf\|mes_send\|send_to_mes\|mes_client" --include='*.py'` | **0건**(ord_sts 매칭만 잔류) · `grep -rniE "clamav\|virus\|scan_engine\|artwork_scan" --include='*.py'` → **0건** |
| 4 | `grep -rn "TWgtSites\|t_wgt_sites\|allow_domains" --include='*.py' --include='*.html' --include='*.js'` | 비-venv 60여 건 중 **admin 등록 0 · allow_domains 편집 도구 0**(tests·tools 생성만) |
| 5 | 서희항 위젯류 계획행 ↔ `merged.csv` `plan_row_id` 조인 | 57행 중 대응 22 / **미대응 35** |
| 6 | 미대응 35행 ↔ `t52/rejudge.csv` 조인 | t52 기판정 6 / **t52 에도 없음 29** |
| 7 | `python3 -c` 로 `edicus_coverage_baseline.json` 직독 | `PRD_000062 miss 5` · `PRD_000063 miss 16` · `PRD_000226 blocked:true` · updated 2026-09-16 |
| 8 | `widget_views.py:800~1000` 직독 | `widget_preview_presign`(858)·`widget_preview_multipart`(924) 구현 실재 확인 |

---

## 8. 「없다」가 아니라 「찾지 못했다」 — 돌린 패턴과 한계

- **PitStop** — 돌린 패턴 `pitstop`·`pit_stop`·`pit-stop`(대소문자 무시), 대상 `*.py *.js *.html *.md`. 제품명을 쓰지 않은 우회 표현(예: `preflight` 만으로 된 식별자)은 잡지 못한다. `preflight`·`프리플라이트` 도 코드에서 찾지 못했다.
- **MES 전송** — 돌린 패턴 `wcf|mes_send|send_to_mes|mes_client`. 다른 이름(예: `production_push`)을 썼다면 놓칠 수 있다. 다만 설계 정본 자신이 「SF-1 외에는 코드가 없다」고 적고 있어(`docs/order-to-mes-process.md:10`) 정황이 일치한다.
- **에디터 산출물 렌더→접수 경로** — webadmin 쪽에서 트리거를 찾지 못했다. `t50:112`(EDI-15b)·`t50:72`(MotionOne 렌더 Webhook)는 **MES 저장소 쪽 증거**라 이 레인에서 직접 확인하지 않았다 — 계약(보충 4 말미)대로 **인용하지 않고 미확인으로 둔다.**
- **라이브 실태 미확인** — `allow_domains` 가 실제로 채워져 있는지, 편집기 템플릿 구멍 21건이 지금도 그대로인지는 **라이브 DB·실화면을 보지 않았으므로 모른다**(카드 제약: 접속 0). `edicus_coverage_baseline.json` 은 2026-09-16 스냅샷이다.
- **작업량 숫자·날짜 추정 없음** — 이 문서에 공수·일정 추정치는 넣지 않았다.

---

## 9. 리드 회신용 한 줄

> 「위젯 133행 중 남은 일 5행」은 아니다. 5행 중 2행은 이미 끝났고(`widget_views.py:858`·`:924`), 1행은 **등록 수단조차 없으며**, 위젯의 뒤쪽 두 구간(파일업로드 후반·PitStop/MES)은 **webadmin·pitstop·mes 행으로 흩어졌거나 어느 원장에도 없다**(계획 원장 대비 **29건 미수록**). PitStop 코드는 webadmin 에도 **0**이다 — t53·t54 판정과 같다.
