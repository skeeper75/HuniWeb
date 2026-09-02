# C3 — 세 시스템이 만나는 여섯 접점 (I-1 ~ I-6)

> 카드 M2 / 계약 C3. 지금까지 어느 인벤토리에도 1급 항목으로 잡히지 않았던 여섯 개를
> 각각 독립 항목으로 세운다.
>
> **세 시스템**
> - 자사몰 프론트/BFF — `huni-skin-shopby` (`/Users/innojini/Dev/huni-skin-shopby`, Next.js)
> - 후니 webadmin — 주문위젯 + 가격엔진 + 원고 (`/Users/innojini/Dev/HuniWeb/raw/webadmin`, Django)
> - Shopby — NHN 헤드리스 커머스 (외부 SaaS, 회원·장바구니·주문·결제의 공식 원장)
>
> **권위 순서** — 「계약」란은 라이브 개발자 가이드(`_evidence/sdk-guide-live-20260902.txt`,
> 2026-09-02 채록, 후니가 자사몰 팀에 주는 정본)를 1차 출처로 삼고, 「무엇이 실제로
> 구현돼 있는가」는 코드가 판정한다. 둘이 어긋나는 자리는 그 자체로 소견이므로
> 아래 §0 표에 따로 세웠다.
>
> **범위 밖** — 라이브 브라우저·네트워크 접근 없음. Shopby 셀러어드민 실화면 확인이
> 필요한 항목은 전부 「미확인」으로 남기고 무엇을 보면 닫히는지만 적는다.

---

## §0 먼저 — 가이드(계약)와 자사몰 코드(구현)가 어긋난 자리

이 표가 여섯 접점 전체를 관통하는 가장 큰 소견이다. 각 항목의 상세는 해당 절에 있다.

| # | 계약(가이드) | 자사몰 코드 실측 | 근거 | 결과 |
|---|---|---|---|---|
| G-1 | 텍스트 옵션 라벨은 `huni_order`·`huni_item` **두 개**. `huni_token` 라벨은 **일부러 만들지 않았다** | `huni_token`·`huni_order` 두 개를 쓴다. `huni_item` 은 코드 어디에도 없다 | 가이드 `sdk-guide-live-20260902.txt:1014-1028`, `:1179` / `huni-widget.tsx:70,74` · `requote.ts:73-74` | 등록되지 않은 라벨로 담기 → **담기 실패 또는 값 유실**. 토큰이 주문조회로 노출 |
| G-2 | 담기 = `POST /cart/items` 로 토큰을 후니 보관소에 넘기고 `item_id` 를 받는다 | `cart/items` 를 한 번도 부르지 않는다(문자열 자체가 소스에 없음) | `grep -rn "cart/items" /Users/innojini/Dev/huni-skin-shopby/src` → 0건 | 항목 보관소(B안) 미채택. 자사몰이 토큰을 계속 취급 |
| G-3 | 결제 직후 `POST /order/register` 필수 — 「이게 빠지면 그 주문은 무엇을 만들지 알 수 없다」 | `order/register` 호출 없음 | `grep -rn "order/register" .../src` → 0건 · 가이드 `:1391-1396`, `widget_api.py:4180-4186` | **결제는 되는데 생산 지시가 없다.** 원고도 승격되지 않아 30일 뒤 소멸 |
| G-4 | 서버-투-서버 호출에 `X-Huni-Server-Key` (item_id 경로는 필수, 나머지 3경로는 하위호환 선택) | 헤더를 싣지 않는다 | `grep -rn "X-Huni-Server-Key" .../src` → 0건 · `requote/route.ts:59-70` | 지금은 통과(선택 단계). 후니가 `WAPI_SERVER_KEY_REQUIRED` 를 켜는 순간 **결제 경로 전체 403** |
| G-5 | 재견적 정본은 `PUT /cart/items/{item_id}` | `POST /handoff/requote` (구방식, 토큰 직접 보관) | `requote/route.ts:17` · 가이드 `:1743` | 계약상 유지되는 경로이므로 즉시 깨지지는 않는다. 단 토큰이 브라우저 저장소(Shopby 텍스트 옵션)를 왕복 |
| G-6 | `optionInputs` 에 `inputNo` 동봉 여부 — 가이드가 「확인되지 않았습니다」로 남김 | `inputNo` 를 싣지 않는다 | 가이드 `:1029-1031` · `huni-widget.tsx:69-79` | **미확인.** 라벨만으로 매칭되지 않으면 담기가 400 으로 거절될 수 있다 |

---

## I-1 handoff 토큰 스키마

### 계약

`POST /api/w/v1/handoff` 는 고객이 위젯에서 고른 선택 전체를 **서버가 다시 계산한 뒤**
그 결과에 서명해 토큰으로 돌려준다. 「도장 찍힌 계약서 — 무엇을 얼마에 만들지의 근거」
(가이드 `:1140` 이후 token↔handoff_id 대비표).

**서명 알고리즘·키 출처**

| 항목 | 값 |
|---|---|
| 알고리즘 | HMAC-SHA256 (hexdigest) |
| 키 | `sha256(b"huni-widget-handoff-v1" + settings.SECRET_KEY)` — Django `SECRET_KEY` 파생 |
| 직렬화 | `json.dumps(payload, ensure_ascii=False, sort_keys=True, default=str)` |
| 인코딩 | `base64.urlsafe_b64encode` 후 `=` 패딩 제거 |
| 토큰 형태 | `<b64payload>.<hexsig>` (점 1개로 분리, `rsplit(".", 1)`) |
| TTL | `HANDOFF_TTL_SEC = 3600`(1시간) — `ts` 기준 |
| 재견적 수용 나이 | `REQUOTE_MAX_AGE_SEC = 30*24*3600`(30일) — **`orig_ts` 기준** |

**payload 필드 전수** (서명 대상. 키는 항상 존재하며 해당 없으면 `null`)

| 필드 | 값·의미 | 값인가 참조인가 |
|---|---|---|
| `v` | 스키마 버전 = `1` | 값 |
| `site_cd` | 사이트 코드 | 참조(코드) |
| `wgt_cd` / `ver_no` | 위젯 코드 / 게시 버전 | 참조(코드) |
| `prd_cd` | 상품 코드 | 참조(코드) |
| `selections` | 브라우저가 보낸 차원 선택 원본(`siz_cd`·`siz_width`·`siz_height`·`opt_cd` 등) | 값 |
| `sel_opts` | 선택 옵션 **코드** 배열(원본) | 참조(코드) |
| `sel_opt_grps` | 선택 옵션**그룹** 코드 배열 — 재견적의 제약 평가 입력 | 참조(코드) |
| `options` | 서버가 전개한 주문·MES 전달용 상세(그룹명·옵션명·내부 구성요소) | 값(전개 결과) |
| `combo` | 조합 템플릿(옵션조합→자재) 전개. 없으면 `null` | 값 |
| `set` | 서버가 정제한 셋트 본문(구성원·부수). 단일상품은 `null` | 값 |
| `addons` | 추가상품 내역 `{name, qty, amount, tmpl_cd, components}` | 값 |
| `proc_sels` | 공정 상세옵션(`dtl_opt`·`side`) | 값 |
| `grade_cd` | 고객 등급 — 단가 선택에 관여. **서명 승계분만** | 참조(코드) |
| `dsn_cd` | 디자인 코드 | 참조(코드) |
| `case_cnt` | 건수(미사용 위젯도 `1`) | 값 |
| `pages` | 페이지수 — 인쇄용지 장수 산출 입력(가격 직결) | 값 |
| `order_title` | 제작물 제목(고객 입력, 최대 100 UTF-16 코드유닛) | 값 |
| `spine` / `spine_color` | 책등 계산 파생값 / 고객이 고른 부속 색상 | 값 |
| `qty` **또는** `copies` | 단일=수량 / 셋트=부수 (`**qty_info`) | 값 |
| `supply` / `vat` / `total` | 공급가 / 부가세 / 청구액(부가세 포함) — 전부 문자열 | 값 |
| `files` | 원고 파일 배열 — `key` 는 **S3 임시 버킷 오브젝트 키** | 참조(S3 키) |
| `editors` | Edicus 편집기 결과(`prjid` 등) | 참조(외부 프로젝트 ID) |
| `edicus_uid` | 편집기 원고 주인(Edicus uid) — 결제 후 Edicus 주문 API 필수 헤더 | 참조 |
| `ts` | 이 토큰의 서명 시각(epoch) — TTL 기준 | 값 |
| `orig_ts` | **최초 발급 시각. 재서명해도 승계되는 불변값** — 30일 상한 기준 | 값 |

**서명 밖(응답 최상단)**: `token` · `expires_in` · `handoff_id`(UUID, 추적/조인 키) ·
`qty_rule`(수량 스테퍼 재료). 「추적/조인 키는 응답 최상단에만 — payload(서명 대상)
안에는 넣지 않는다」.

**검증 (`POST /api/w/v1/handoff/verify`)**
요청 `{site_key, token}` → 응답 `{ok:true, valid, payload|reason}`.
`valid=false` 사유: `malformed` · `bad_signature` · `expired` · `site_mismatch` ·
`product_unpublished`. 서명이 멀쩡해도 **판매중지 상품이면 유효로 답하지 않는다**.

### 양쪽 담당

- **쓰기(발급)** — webadmin. 브라우저가 보낸 값은 전부 불신하고 서버가 재계산해 서명한다.
- **읽기(검증)** — 자사몰 **서버**(BFF). 가이드는 「브라우저가 보낸 payload 는 참고용일
  뿐, 금액은 반드시 verify 응답 값을 쓰세요」로 못 박는다.
- **보관** — 계약상 자사몰은 토큰을 보관하지 않는다(§9 항목 보관소). Shopby 에는 **절대**
  넣지 않는다.

### 근거

- `raw/webadmin/webadmin/catalog/widget_api.py:53-54`
  `HANDOFF_TTL_SEC = 3600` / `_HMAC_CONTEXT = b"huni-widget-handoff-v1"`
- `widget_api.py:2511-2520` — `_hmac_key()` = `hashlib.sha256(_HMAC_CONTEXT + settings.SECRET_KEY.encode()).digest()`,
  `_sign()` = `f"{b64.decode()}.{sig}"`
- `widget_api.py:2522-2537` — `_verify()`; `:2536` `if int(time.time()) - int(payload.get("ts", 0)) > HANDOFF_TTL_SEC:`
- `widget_api.py:3388-3455` — payload 조립 전문
- `widget_api.py:3378-3387` — 「`orig_ts` … 재서명해도 **승계되는 불변값**이다. 재견적 나이
  상한의 기준점이 이것이라, `ts` 처럼 매번 갱신되면 재견적이 곧 시계 리셋이 되어 상한이 무력화된다」
- `widget_api.py:3473-3486` — `_handoff_core` 응답: `token`·`payload`·`expires_in`·`handoff_id`·`qty_rule`
- `widget_api.py:3696-3718` — `api_handoff_verify`
- `widget_api.py:10` — 「핸드오프 토큰=HMAC-SHA256(SECRET_KEY 파생 키), 파트너 서버는 handoff/verify 로 검증」
- 가이드 `_evidence/sdk-guide-live-20260902.txt:172-173` — TTL 3600초 · handoff_id 는
  「추적용이지 주문의 신원이 아닙니다」

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| `SECRET_KEY` 가 바뀌거나 인스턴스마다 다름 | 발급된 **모든 토큰이 즉시 `bad_signature`** | 장바구니 전량 결제 불가. 담긴 항목은 「다시 담아 주세요」밖에 방법이 없다 |
| 토큰이 저장 과정에서 잘림(VARCHAR 컬럼·텍스트 옵션 길이 상한) | `bad_token` 422 — 조용히, 담긴 뒤에 | 개별 주문 유실. 원인 추적이 어렵다(가이드가 TEXT 컬럼 권장으로 명시) |
| `orig_ts` 를 `ts` 로 착각해 나이를 잼 | 재견적이 시계 리셋 → 45일차 결제가 「나이 20일」로 통과 | **원고(S3 30일)가 이미 없는 주문이 결제까지 간다.** 승격 단계에서야 터진다 |
| verify 를 건너뛰고 브라우저 payload 로 주문 생성 | 금액 위조 가능 | **직접적 금전 손실**. 서버 재계산·서명의 존재 이유 자체 |
| payload 에 새 필드를 넣고 `_carry_quote_body` 를 안 고침 | 재견적 한 번에 그 사양이 **조용히 사라진다** | 이미 5회(`sel_opt_grps`·`grade_cd`·`pages`·`edicus_uid`·`dsn_cd`) 실제로 밟은 실패 모드 (`widget_api.py:3749-3756`) |

### 미확인

- 라이브 Railway 의 `SECRET_KEY` 가 단일 인스턴스에 고정인지, 재배포로 회전하는지 —
  회전하면 위 1행이 즉시 현실이 된다. Railway 환경변수 실측이 필요.
- 실제 토큰 문자열 길이(payload 크기에 비례) — Shopby 텍스트 옵션 길이 상한과의 관계는
  I-2 의 미확인과 한 몸.

---

## I-2 `optionInputs` 규약

### 계약

Shopby 장바구니 항목(`POST /cart`)이 가질 수 있는 필드는 `productNo` · `optionNo` ·
`orderCnt` · `baseProductNo` · `groupId` · `optionInputs` 뿐이고, 이 중 **주문마다 다른
값을 넣을 수 있는 자리는 `optionInputs` 하나**다(가이드 `:1187-1196`).
형태는 ad-hoc `{inputNo, inputLabel, inputValue}`.

**슬롯 수 = 2개.** 2026-08-27 에 판매 중인 상품 226개에 텍스트 옵션(`customerDemands`)을
일괄 등록했다.

| 라벨 | 값 | 형식 | 쓰는 쪽 | 읽는 쪽 |
|---|---|---|---|---|
| `huni_order` | 사람이 읽는 **주문 요약 한 줄** | 문자열. `POST /cart/items` · `PUT /cart/items/{id}` 응답의 `summary` 를 **그대로** | 자사몰 서버 | 셀러어드민 주문 상세(담당자) · 주문조회 |
| `huni_item` | 항목 보관소 `item_id` | 36자 UUID. **불변**(재견적·수량변경에도 안 바뀜) | 자사몰 서버 | 자사몰(장바구니 그리기·갱신·주문등록) |

**요약(`summary`) 생성 규칙** — 권위는 후니 서버(`cart_items.cart_summary`).
`상품명 / 제작물제목 / {w}×{h}mm / 옵션명(최대 6개) / N개(또는 N부) / N건` 을 `" / "`
로 이어 붙이고 200자에서 자른다. 첫 글자가 `=`·`+`·`@` 면 앞에 공백을 넣는다(스프레드시트
수식 해석 방지).

**금지 사항 3가지** (가이드 `:1207-1213` · `cart_items.py:183-187`)
1. 원고 파일 키를 넣지 말 것
2. 편집기 프로젝트 ID를 넣지 말 것
3. 금액 내역을 넣지 말 것
— 텍스트 옵션은 **주문조회 응답으로 그대로 읽힌다**. Shopby 문서도 「개인정보나 보안이
필요한 정보는 입력하면 안 됩니다」로 명시.

**`huni_token` 은 일부러 만들지 않았다.** 이유 둘: ① 토큰은 금액·사양의 권위라 읽히는
자리에 두면 안 된다 ② 텍스트 옵션 값 길이 상한이 확인되지 않아 **조용히 잘리면 서명
검증이 전부 실패한다**(가이드 `:1019-1021`).

### 양쪽 담당

- **값 생산** — webadmin (`summary` 문자열과 `item_id` 를 담기·갱신 응답으로 내려준다)
- **쓰기** — 자사몰 **서버**가 Shopby `POST /cart` · `PUT /cart` 에 싣는다
- **읽기** — ① 자사몰(장바구니·주문서 화면을 그릴 때 `GET /cart` 응답에서 파싱)
  ② 후니(결제 후 주문조회에서 `huni_item` 을 읽어 `order/register` 로 넘김)
  ③ 셀러어드민 담당자(`huni_order` 를 눈으로 읽음)
- **라벨 등록** — webadmin 이 Shopby `PATCH /products/{no}` + `Version:3.0` 의
  `customerDemands` 로 226건 등록 완료(2026-08-27). **삭제 불가 → `useYn:"N"` 으로만 끌 수 있다**

### 근거

- 가이드 `_evidence/sdk-guide-live-20260902.txt:1014-1031` — 「텍스트 옵션 … `huni_order` ·
  `huni_item` 2개 등록 완료」 / 「토큰 위치 … 샵바이에는 넣지 않습니다. 토큰 전용 라벨을
  일부러 만들지 않았습니다」 / 「`inputNo` — `optionInputs` 에 `inputNo` 를 함께 싣고
  계신지. 라벨만으로 매칭되는지는 확인되지 않았습니다」
- 가이드 `:1179` — 「`huni_order`=담기 응답의 요약(문자열) · `huni_item`=item_id (§9)」
- 가이드 `:1239-1265` — 담기 전체 샘플(`inputNo:1`=huni_order, `inputNo:2`=huni_item,
  「★이게 빠지면 주문을 못 찾습니다」)
- `raw/webadmin/webadmin/catalog/cart_items.py:14-16` — 흐름 ①「자사몰이 샵바이
  `POST /cart` 의 optionInputs 에 `huni_item: item_id`」
- `cart_items.py:176-231` — `cart_summary()` 전문. `:183-186` 「⚠ 여기에 원고 파일 키·편집기
  프로젝트 ID·금액 내역을 넣지 말 것. 이 값은 샵바이 주문조회 응답으로 그대로 읽힌다」
- `cart_items.py:56-59` — `SUMMARY_MAX = 200`, 「샵바이가 텍스트 옵션 값 길이 상한을
  문서화하지 않아(실측도 못 한 상태) 짧게 유지한다」
- **어긋남(G-1)**: `/Users/innojini/Dev/huni-skin-shopby/src/components/product/huni-widget.tsx:69-79`
  ```
  const inputs: OptionInput[] = [
    { inputLabel: "huni_token", inputValue: r.token },
  ];
  … inputs.push({ inputLabel: "huni_order", inputValue: JSON.stringify(order) });
  ```
  `src/lib/api/requote.ts:72-75` 동일 구조. `src/lib/api/widget-order.ts:107-111` 은
  `huni_order` 를 **JSON 으로 파싱**하고 `huni_token` 에서 토큰을 꺼낸다 —
  즉 자사몰은 `huni_order` 를 「요약 문자열」이 아니라 `{total, qty, summary, qtyRule,
  editors, files}` **JSON 객체**로 쓰고 있다. `files`·`editors` 가 그 JSON 안에 들어간다
  (`huni-widget.tsx:66-67`, `requote.ts:69-70`) — 금지사항 ①②를 정면으로 위반.
- `.planning/STATE.md:209` — 「⚠요약 JSON 에 **원고 파일 키** 노출 · `optionInputs` 에
  `inputNo` 누락」(후니 쪽이 자사몰 배포본 분석으로 이미 적발한 기록)

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| **지금 상태 그대로 라이브** — 자사몰이 미등록 라벨 `huni_token` 을 보낸다 | Shopby 가 미등록 라벨을 거절하면 **담기 자체가 실패**, 무시하면 값이 조용히 사라진다 | 전 상품 담기 경로. 어느 쪽인지는 라이브 확인 전까지 미확정 |
| `huni_item` 을 안 싣는다(현 상태) | 결제 후 「이 주문이 무엇인가」를 이을 키가 없다 | **주문과 사양의 연결 단절** → I-4 가 통째로 성립하지 않는다 |
| 요약 JSON 에 `files`·`editors` 를 실은 채 결제 | **원고 S3 오브젝트 키가 주문조회 응답으로 평문 노출** | 보안 사고. B안이 없애려던 노출 경로를 요약으로 되살린 형태 |
| 텍스트 옵션 값이 상한에서 잘린다 | `huni_order` 가 잘리면 담당자가 못 읽는 정도. **`huni_token` 이 잘리면 서명 검증 전멸** | 후자는 그 항목의 결제가 영구 불가 |
| `inputNo` 누락으로 라벨 매칭 실패 | `POST /cart` 400 거절 | 담기 전면 중단 |
| 수량 변경 후 `huni_order` 갱신 누락 | 셀러어드민에는 옛 요약, 실제 생산은 새 사양 | **담당자가 틀린 사양을 보고 응대**. 취소·환불 판단이 어긋난다 |

### 미확인

- **Shopby 텍스트 옵션 `inputValue` 길이 상한** — 문서에 없고 실측도 못 했다(가이드가
  스스로 「미측정」으로 남김). 셀러어드민 또는 `PATCH /products` 실호출로 닫아야 한다.
- **`inputNo` 필수 여부** — 가이드가 「라벨만으로 매칭되는지는 확인되지 않았습니다」.
  실제 `POST /cart` 호출 1회로 닫힌다.
- 226개 등록된 라벨의 실제 `inputNo` 값 — 상품마다 다를 수 있다(가이드 샘플의 1·2는
  「예시 값 — 실제 번호는 아래 표 참고」로 명시).
- 자사몰이 `huni_token` 을 계속 쓰는 것이 **미전환 상태**인지 **의도적 유지**인지 —
  자사몰 팀 확인 필요.

---

## I-3 `orderCnt = round(총액 ÷ 10)` — 가격 브리지

### 계약

**규칙**: Shopby 상품의 판매가를 **10원**으로 고정하고, 결제 금액을 `orderCnt`(수량)으로
표현한다. `orderCnt = 청구액 ÷ 10`. 15,000원 주문 → `orderCnt: 1500`.

**정당화(가이드가 명시한 것)**
- Shopby 주문서 API(`POST /order-sheets`)는 **금액을 직접 받지 않는다.** 상품번호·옵션번호·
  수량만 받고 금액은 Shopby 서버가 상품 정보에서 계산한다.
- 「외부에서 금액을 지정할 방법이 있는지」 Shopby 에 공식 문의 → **불가능하다는 회신**
  (2026-08-26 미팅). 「그래서 금액을 표현할 수 있는 자리가 수량밖에 남지 않았습니다.」
- 왜 1원이 아니라 10원인가: 후니 가격엔진이 청구액의 1원 단위를 절삭하므로 청구액은
  **언제나 10원 배수**다. 10원으로 두면 어떤 금액이든 정확히 표현되면서 수량·재고 소모·
  주문서 표시·알림 문구가 전부 1/10 로 가벼워진다.
- 2026-08-26 에 판매 중 226개 상품의 판매가를 **100원 → 10원** 으로 일괄 변경 완료.

**절삭/반올림 거동**
```
raw   = 공급가 + round_won(공급가 × 0.1)
total = int(raw // 10 * 10)              # 1원 단위 절삭(내림)
if raw > 0 and total <= 0: total = int(raw)   # 10원 미만 청구는 절삭하지 않음(0원 판매 방지)
공급가 = round(total ÷ 1.1);  부가세 = total − 공급가   # 등식이 항상 성립하도록 역산
```
`orderCnt` 자체는 자사몰이 `Math.max(1, Math.round(total / 10))` 으로 만든다(항상 10원
배수이므로 반올림은 무손실이지만, **가드가 후니 쪽에 따로 있다**).

**서명 직전 fail-closed 가드**: `int(total) % 10 != 0` 이면 `422 price_unit_mismatch` 로
**서명 발급을 거절**한다. 표시(`api_price`)는 막지 않는다 — 「이 지점이 주문이 될 수 있는
금액에 서명하는 자리」이기 때문. 담기(`cart/items`)에도 같은 가드를 이중으로 둔다.
가이드는 「**반올림해서 재시도하지 마세요** — 임의 보정은 곧 청구액 오차입니다」로 못 박는다.

### 파생 제약 — 증거가 있는 것

| # | 제약 | 근거가 말하는 것 |
|---|---|---|
| C-1 | **최소 주문 금액 = 10원** (실질) | 청구액이 10원 미만이면 절삭이 걸리지 않아 10원 배수가 아니게 되고, `price_unit_mismatch` 로 거절된다. 「7원짜리는 수량 0.7 이라 애초에 샵바이에 실을 수가 없다」 |
| C-2 | **1원 단위 불가** | 가격엔진이 절삭한다. 후니가 절삭 단위를 바꾸는 순간 「화면 15,003원 ↔ 샵바이 1,500개 = 15,000원」으로 **조용히 갈린다** |
| C-3 | **수량 UI 의미 뒤바뀜** | 「명함 200장」의 200은 Shopby 수량 칸에 들어가지 않는다. 실제 제작 수량은 `payload.qty` 와 `huni_order` 요약에만 있고, 화면은 자사몰이 후니 데이터로 그린다 |
| C-4 | **재고 수량 × 10원 = 그 상품의 누적 결제 한도** | Shopby 는 주문 등록 시점에 수량만큼 재고를 차감하고, **재고 관리를 끄는 설정이 존재하지 않는다**. 현재 라이브 재고 9,999(=99,990원어치), 최대값 2,147,483,647(약 214억원). 후니가 주기적 자동 보충을 돌린다 |
| C-5 | **1회 최대구매수량 제한 = 결제 금액 상한** | 100으로 두면 1,000원 넘는 주문이 막힌다. 켜면 안 됨 |
| C-6 | **수량 비례 배송비 영구 금지** (`QUANTITY_PROPOSITIONAL_FEE`) | 15,000원 주문이면 배송비가 1,500배 |
| C-7 | **수량별 차등 배송비 금지** (`QUANTITY_FEE`) | 구간표에서 항상 최상단 구간 |
| C-8 | **중량별 차등 배송비 + 상품 중량 입력 금지** (`WEIGHT_FEE`) | 총중량 = 상품중량 × 수량. 「중량 배송비를 안 쓰더라도 상품에 중량을 입력해 두지 마세요」 |
| C-9 | **즉시할인 금지** | `(판매가 − 할인) × 수량` 으로 계산되어 청구액이 어긋난다. 할인은 쿠폰으로 |
| C-10 | 배송비는 `FREE`·`CONDITIONAL`·`FIXED_FEE`·`PRICE_FEE` 네 가지만(전부 금액 기준) | 현재 `FREE` |
| C-11 | **쿠폰·적립금은 안전** | Shopby 쿠폰은 전부 금액 기준. 정액 쿠폰도 「상품별 총 상품금액을 기준으로 … 수량별로 할인되지 않음」 |
| C-12 | **알림(문자·알림톡·메일)에 수량이 노출된다** | 템플릿 치환 항목에 `count`(옵션 수량)가 있고 `productNames` 는 「상품명(수량)」 형식. 그대로 두면 고객 문자에 「… (1500)」이 찍힌다. 권장 대응 = 템플릿에서 수량 치환 제거 |
| C-13 | **현금영수증·세금계산서에 품목·수량이 Shopby 발행으로 표기된다** | 가이드가 「샵바이가 직접 내보내는 것」 표에 명시. **다만 표기가 어떻게 나오는지는 미확인**(아래) |
| C-14 | **셀러어드민 주문 화면·판매 통계에 수량이 그대로 보인다** | 담당자가 매일 본다. 「요약이 없으면 담당자가 주문을 열어도 "10원 × 1,500개" 만 보여서 취소·환불·문의 응대를 할 수 없습니다」 — `huni_order` 요약의 존재 이유 |
| C-15 | 결제창(PG) | 「금액은 정상, 상품명만 노출」 |

### 양쪽 담당

- **금액 산출** — webadmin 가격엔진(`pricing.settle_with_vat`), 절삭·역산까지
- **가드** — webadmin `_quote` 서명 직전 + `cart_items.api_cart_add` 이중
- **`orderCnt` 변환·적재** — 자사몰(`amountToOrderCnt`) → Shopby `POST /cart` · `POST /order-sheets`
- **판매가 10원 유지 / 재고 보충 / 금지 설정 관리** — 후니. 「자사몰이 재고를 직접
  건드리지는 말아 주세요」

### 근거

- `raw/webadmin/webadmin/catalog/widget_api.py:56-62`
  「샵바이에 등록된 **상품 판매가**(원). 맞춤가는 "판매가 10원짜리 상품 × 수량" 으로
  싣기 때문에(개발자가이드 §11), 청구액이 이 값으로 나눠떨어지지 않으면 **샵바이에 실을
  수 있는 금액이 아니다.**」 / `SHOPBY_PRICE_UNIT = 10`
- `widget_api.py:3228-3233` — 가드 본체
  ```
  if total is not None and int(total) % SHOPBY_PRICE_UNIT != 0:
      _logger.error("price_unit_mismatch …")
      return None, _err("주문 금액을 만들지 못했습니다. 담당자에게 문의해 주세요.", 422, "price_unit_mismatch")
  ```
- `widget_api.py:3222-3227` — 「표시(api_price)는 막지 않는다. 여기서만 막는 이유 = 이
  지점이 **주문이 될 수 있는 금액에 서명하는 자리**」
- `raw/webadmin/webadmin/catalog/pricing.py:105` `TOTAL_UNIT = 10` / `:108-129`
  `settle_with_vat()` — 절삭·역산·소액 보호
- `raw/webadmin/webadmin/catalog/cart_items.py:408-415` — 담기 경로 이중 가드,
  「가드 배포 이전에 서명된 토큰이 그대로 굳으면 orderCnt 가 정수로 안 떨어져 조용한
  언더차지나 샵바이 거절이 된다」
- `/Users/innojini/Dev/huni-skin-shopby/src/lib/api/widget-order.ts:26-35`
  `SHOPBY_AMOUNT_UNIT = 10` / `Math.max(1, Math.round(t / SHOPBY_AMOUNT_UNIT))`
- `huni-widget.tsx:257-266` — 「shopby 결제액 = 판매가(10원) × orderCnt 이므로, orderCnt 에
  위젯 총액÷10 을 실어 실제 결제액을 위젯 총액과 일치시킨다」
- 가이드 `:1035-1076`(확정 경위·10원 근거·가드), `:1077-1108`(재고=결제 한도),
  `:1109-1135`(절대 켜면 안 되는 설정), `:1136-1147`(쿠폰·적립금 안전),
  `:695-712`(샵바이가 직접 내보내는 것 — 알림·세금계산서·셀러어드민)
- 가이드 `:2117` 오류 코드 사전 — `price_unit_mismatch` 422

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| `orderCnt: 1` 하드코딩 (자사몰 8월 실측 결함) | **10원이 결제된다** | 주문 1건당 청구액 전액 손실. 실제로 8/27 자사몰 배포본에서 발견된 상태 |
| `TOTAL_UNIT` 이나 판매가 10원 중 한쪽만 바뀜 | 화면 금액 ↔ 결제 금액이 **조용히 갈린다** | 전 주문. 가드가 422 로 잡지만 그 순간부터 **주문 자체가 안 된다**(가용성 사고) |
| 판매가가 100원인 상품이 남아 있음 | 그 상품만 금액이 **10배** 틀어진다 | 오버차지. 226개 일괄 변경에서 누락된 상품이 있으면 발생 |
| 재고 소진 | Shopby 가 품절 처리 → **그 상품 결제 전면 중단** | 자동 보충이 실패하면 매출 정지. 재고 관리를 끌 방법이 없다 |
| 수량 기준 배송비/중량/최대구매수량 중 하나라도 켜짐 | 배송비 1,500배 / 1,000원 넘는 주문 차단 | 즉시 매출·신뢰 사고 |
| 즉시할인 켜짐 | `(10 − 할인) × 수량` — 청구액이 어긋난다 | 전 주문 언더차지 |
| 알림 템플릿 수량 치환을 안 뺌 | 고객 문자에 「… (1500)」 | 고객 혼란·문의 폭주. 금전 손실은 없으나 신뢰 손상 |
| `huni_order` 요약이 없거나 틀림 | 셀러어드민에 「10원 × 1,500개」만 보인다 | **담당자가 취소·환불·문의 응대를 할 수 없다** |

### 미확인

- **부분취소/부분환불 단위** — Shopby 의 부분취소가 「수량 단위」로 동작한다면 취소 수량
  1 = 10원이 되어 실질적으로 임의 금액 부분환불이 되고, 반대로 항목 전량 단위라면 문제
  없다. 어느 쪽인지 **문서·코드 어디에도 근거가 없다.** 한편 `docs/order-to-mes-process.md:723`
  은 「부분취소·수량변경 지원 여부 … 1차 범위에서는 **미지원** 제안(전량 취소만)」으로
  운영 정책 단계에 남겨 두었다 — 확정 기록이 아니다.
  → **Shopby 셀러어드민에서 부분취소 UI 를 열어 단위를 실측**하면 닫힌다.
- **세금계산서·현금영수증 실제 표기** — 「품목·수량 표기」라는 사실만 있고, 「수량 1,500 /
  단가 10원」으로 찍히는지 표기를 조정할 수 있는지는 미확인. 세무·회계 리스크가 여기 있다.
  → 실제 발행 1건으로 닫힌다.
- **판매 통계 왜곡** — 셀러어드민 통계가 수량 기준 지표를 어떻게 보여주는지 미확인.
- 226개 일괄 변경 이후 **신규 등록 상품**의 판매가 기본값이 10원으로 강제되는 장치가
  있는지 미확인(현재는 사람이 지켜야 하는 규칙).
- 알림 템플릿 수정 여부·시점 — 가이드 스스로 「★미확정」으로 남김.

---

## I-4 `POST /api/w/v1/order/register` — S2S 주문 등록

### 계약

**언제**: 쇼핑몰이 주문을 만든 **직후**. 「결제 완료를 기다리지 마세요 — 입금대기(가상계좌·
무통장) 주문도 만들어진 직후 바로 등록해야 원고가 보관 기한(30일)을 넘기지 않습니다.」

**하는 일**: 서명 토큰 안의 검증된 사양과 원고 파일 목록을 **쇼핑몰 주문번호에 묶어 보관**.
「이 호출이 없으면 결제된 주문을 받아도 **무엇을 만들어야 하는지 알 수 없다.**」

**요청**
```
POST /api/w/v1/order/register
X-Huni-Server-Key: <서버키>     // item_id 로 보낼 때 필수
{ "site_key": "...", "order_no": "20260827-0001", "line_no": "1",
  "item_id": "2b9aceca-…" }     // 또는 "token": "<서명 토큰>" — 둘 중 하나
```

**★ 사양의 출처는 `token` 또는 `item_id` 중 하나다.** `item_id` 로 오면 후니가 보관해 둔
토큰을 꺼내 쓴다(`cart_items.token_for_item`). 「자사몰이 토큰을 **한 번도** 만지지 않게
되는 마지막 조각」. 둘 다 없으면 `400 missing_token`.
`handoff_id` 가 아니라 토큰인 이유: 「사양 전문은 서명 토큰 안에 있고 … `handoff_id` 는
추적용 조인 키라 재견적마다 새로 발급되고 사양 전문을 담지도 않는다.」

**인증**

| 축 | 값 |
|---|---|
| 1차 | `site_key`(공개값) — `_site()` 조회 |
| 2차 | `X-Huni-Server-Key` 헤더(50자 내외, `hsk_` 접두). **평문 미보관 — SHA-256 해시만**(`t_wgt_sites.svr_key_hash`) |
| 필수 여부 | `item_id` 경로 = **무조건 필수**. `token` 경로 = 하위호환 **선택**(단 헤더를 실었는데 값이 틀리면 403). 스위치 `settings.WAPI_SERVER_KEY_REQUIRED` 로 하한만 올린다 |
| IP 화이트리스트 | **쓰지 않는다** — 「자사몰이 Vercel 이라 나가는 IP 가 고정이 아니다」 |
| 서명 | 요청 서명 없음. 토큰 자체가 사실상 인증서 |
| Rate limit | `RATE_LIMIT_ORDER_REG_PER_MIN = 600`/분(`widget_api.py:437`), 전용 버킷 `"or:"` |
| 헤더 미전송 | `EVT_NOKEY` 로 abuse 로그에 기록하고 통과(관측점) |

**멱등키와 그 범위**: `(site_cd, shop_ord_no, shop_line_no)` — DB UNIQUE 인덱스가
**유일한 심판**. `line_no` 조건은 두 가지뿐 — ① 한 주문 안에서 항목마다 다를 것
② 재시도해도 같은 값일 것. Shopby 라면 `orderProductOptionNo` 를 그대로 넣는다
(상태변경 웹훅도 같은 값을 싣는다). `order_no`·`line_no` 각 100자 상한.

**응답**
```
{ "ok": true, "order_id": "550e8400-…", "already": false|true,
  "qty": 200, "total": "198000.00" }
```
`total` 은 신규/재시도 모두 `Decimal.quantize(0.01)` 로 강제 정규화한다 — 「같은 주문인데
첫 응답과 재시도 응답의 문자열이 다르다 … 쇼핑몰이 문자열로 비교하면 "금액이 바뀌었다"고
오판한다(라이브 실측에서 발견)」.

**재시도 시 무슨 일이 일어나나**
1. `transaction.atomic()` 안에서 INSERT 시도 → `IntegrityError` 면 재조회
2. `_ord_fingerprint(기존) == _ord_fingerprint(신규)` 면 `already:true` 로 성공 응답
   — 지문은 payload 에서 **`ts` 와 `work_size` 를 제외**한 사양 전문
   (`ts` 제외: 재견적 한 번 더 돌면 내용은 같은데 서명 시각만 다르다.
    `work_size` 제외: 서버가 등록 시점에 파생하는 값이라 배포 전후로 달라진다)
3. 다르면 `409 order_mismatch`
4. **재시도도 `_promote_artwork` 를 다시 몬다** — 앞선 호출이 응답을 못 돌려주고 끊겼을
   수 있다. 이미 승격된 파일은 건너뛴다
5. 재전송 경로에서는 **판매중지 게이트를 적용하지 않는다** — 「이미 만들어진 주문의 응답
   유실 재전송이 409 로 죽으면 `_promote_artwork` 가 영영 안 돌아 원고가 tmp(30일)에서 소멸한다」

**부분 실패 시**
- 원고 승격(`_promote_artwork`)은 **등록 응답을 절대 막지 않는다.** 실패해도 200 을 준다.
  「쇼핑몰은 이미 결제된 주문을 되돌릴 수 없고, 파일 문제를 고객에게 알리는 것은 우리 몫」.
  실패는 삼키지 않고 승격 모듈이 주문을 **보류(HOLD)** 로 세우고 사유를 남긴다.
- `work_size` 재계산 실패도 등록을 막지 않는다(`null` 로 두고 진행).
- UNIQUE 위반인데 행이 없으면(다른 제약 위반) `409 register_failed` — 「조용히 성공시키지 않는다」.

### 양쪽 담당

- **호출(쓰기)** — 자사몰 **서버**. 「여기까지가 자사몰 몫이고, 이후는 저희가 맡습니다」
- **수신·보관·승격** — webadmin (`t_ord_orders` + S3 tmp→order 버킷 복사)
- **경계** — 원고 보관·검수·MES 접수·주문상태 변경·송장·취소 처리는 전부 후니.
  「쇼핑몰 관리자에서 주문 상태를 손으로 바꾸지 마세요」 / 「별도의 주문취소 기능을 만들지 마세요」

### 근거

- `raw/webadmin/webadmin/catalog/widget_api.py:4171-4186` — 헤더 주석
  「왜 handoff_id 가 아니라 token 인가」 / 「260827(B안 D-06): `token` 대신 **`item_id`** 를
  보내도 된다」 / `ORDER_NO_MAX = 100`
- `widget_api.py:4187-4193` — 함수 docstring 「사양의 출처는 **`token` 또는 `item_id` 중
  하나**다(D-06)」
- `widget_api.py:4210-4223` — 서버키 필수 여부 분기
  `required=bool(_item_id_raw) and not _token_raw or _sk_required()`
- `widget_api.py:4238-4249` — `item_id` → `CI.token_for_item()` → 없으면 `404 not_found`
- `widget_api.py:4010-4026` — `_ord_fingerprint` (`ts`·`work_size` 제외 이유)
- `widget_api.py:4028-4039` — `_ord_row_response` (`total` 정규화)
- `widget_api.py:4041-4062` — `_promote_artwork` (등록 응답을 막지 않는다)
- `widget_api.py:4262-4270` — 재전송 시 판매중지 게이트 미적용
- `widget_api.py:4300-4326` — `atomic()` + `IntegrityError` + 지문 대조 + 재승격
- `widget_api.py:136-197` — `SERVER_KEY_HEADER = "X-Huni-Server-Key"`, `server_key_hash`,
  `_sk_required`, `_server_key_err`. `:132` 「IP 화이트리스트는 쓰지 않는다 — 자사몰이
  Vercel 이라 나가는 IP 가 고정이 아니다」
- `raw/webadmin/webadmin/catalog/cart_items.py:628-644` — `token_for_item()`,
  「**만료 여부로 거르지 않는다** … 등록 후에도 행을 지우지 않는다」
- 가이드 `:798-816`(item_id 경로·서버키 필수), `:817-834`(line_no 계약),
  `:835-841`(응답·already), `:846-847`(`order_mismatch`), `:491-497`(입금대기 포함 즉시 등록),
  `:497-501`(「결제 후에는 만료를 보지 마세요」), `:938-947`(가상계좌 입금기한 3~7일 권장)
- **어긋남(G-3/G-4)**: `grep -rn "order/register\|X-Huni-Server-Key" /Users/innojini/Dev/huni-skin-shopby/src`
  → **0건**

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| **호출 자체가 없다(현 자사몰 상태)** | 결제는 되는데 **후니에 주문이 존재하지 않는다.** 웹훅은 주문번호만 실어 오므로 이을 것이 없다 | 전 주문. 「결제는 됐는데 생산이 시작되지 않는」 사고. 원고는 30일 뒤 tmp 버킷에서 소멸 |
| `line_no` 를 재시도마다 다르게 매김 | 같은 항목이 **두 번 등록**된다 | 이중 생산·이중 원고 승격 |
| `line_no` 가 한 주문 안에서 겹침 | 두 번째 항목이 `409 order_mismatch` | 그 항목만 생산 누락 — **조용히** |
| 응답 유실 후 재시도인데 사양이 달라짐(중간에 재견적) | `409 order_mismatch` → 승격이 영영 안 돈다 | **원고 소멸**. 가이드가 「재시도는 같은 토큰(또는 같은 사양)으로」로 못 박은 이유 |
| 서버키 발급 전에 헤더를 미리 실어 보냄 | `403 bad_server_key` | **운영 중인 결제 경로 3개가 한꺼번에 막힌다**(verify·requote·order/register). 가이드가 가장 강하게 경고하는 함정 |
| `WAPI_SERVER_KEY_REQUIRED` 를 켰는데 자사몰이 헤더를 안 실음 | 위와 동일 | 동일 |
| `item_id` 경로가 서버키 없이 열려 있었다면 | 공개값 두 개(site_key + item_id)만으로 아무 브라우저나 주문 등록 + **원고 승격**을 일으킬 수 있다. 진짜 주문번호를 선점당하면 정상 등록이 `409` 로 죽는다 | 그래서 이 경로만 예외 없이 필수로 설계됨 |
| 승격 실패를 응답에 실었다면 | 쇼핑몰이 할 수 있는 일이 없는 정보로 서로의 실패 처리가 얽힌다 | 설계상 배제됨(HOLD + 후니 알림) |

### 미확인

- `t_ord_orders` 라이브 적재 건수 — 마지막 기록(8/27 STATE.md)은 **0건**. 그 뒤 변화는
  라이브 SELECT 로만 확인 가능.
- `_promote_artwork` 의 HOLD 사유가 담당자에게 실제로 도달하는 알림 경로(구현 여부).
- 자사몰이 `order/register` 를 붙일 때 `token` 경로로 갈지 `item_id` 경로로 갈지 —
  후자면 서버키 발급이 선행 필수다.

---

## I-5 Shopby 웹훅 — 실제로 어떤 이벤트를 받는가

### 계약

`POST|PUT /api/w/v1/shopby/webhook/<secret>` — **비밀 경로 방식**.

가이드는 전체 흐름에서 「샵바이는 주문번호만 만들고, 그 번호로 **결제 웹훅**에서 후니와
다시 만난다」(가이드 `:334`)고만 말한다. 구독 대상은 개발자 가이드가 아니라
`raw/webadmin/docs/shopby-server-api.md` 가 정본이다.

**구독 예정 이벤트 4종** (`shopby-server-api.md:78-84`)

| 설계 | 실제 이벤트명 | 단위 | 페이로드 핵심 |
|---|---|---|---|
| SB-1 | `CREATE_ORDER` | 주문 | `order.orderNo` · `payType`/`pgType` · 금액 분리 필드 다수 |
| SB-2 | `CHANGE_ORDER_STATUS` | **주문상품옵션** | `orderNo` · `orderProductOptionNo` · `orderStatusType` · `claimStatusType` · `deliveryNo` |
| SB-3 | `UPDATE_RECEIVER` | 주문 | 수령자·배송지 변경 |
| SB-4 | `ADD/UPDATE/DELETE_TASK_MESSAGE` | 주문 | 업무 메시지(입금 메모 등) |

### ★ 핸들러를 전수로 읽은 결과 — **이벤트별 분기가 하나도 없다**

`shopby_hook.py` 는 133줄 전체가 **수신·저장 전용**이다. `eventType` 을 **읽기만 하고
분기하지 않는다.**

```python
evt = _s(_dig(payload, "eventType"), 50) or "_UNKNOWN"
row = dict(evt_typ=evt, shop_ord_no=…, shop_line_no=…, shop_ord_sts=…,
           shop_clm_sts=…, payload=payload, hook_sts=HOOK_RECEIVED, reg_dt=…)
hook = M.TOrdWebhooks.objects.create(**row)
return JsonResponse({"ok": True, "hook_id": hook.hook_id})
```

**실제로 하는 일 전부**
1. 메서드가 `POST`/`PUT` 이 아니면 `405`
2. 비밀 경로를 `hmac.compare_digest` 로 대조 — 불일치면 **`404`**(403 이 아니다.
   「403 은 "경로는 맞다"는 정보를 줍니다」). `SHOPBY_WEBHOOK_SECRET` **미설정이면 무조건 실패**
3. 원문을 256KB 상한으로 자르고(잘리면 `_truncated: True` 를 남김) JSON 파싱
4. 파싱 실패해도 버리지 않고 `{"_unparsed": raw}` 로 통째 저장
5. `eventType`·`orderNo`·`orderProductOptionNo`·`orderStatusType`·`claimStatusType` 을
   최상단 → `order`/`orderInfo` 컨테이너 순으로 찾아(`_dig`) 컬럼에 넣는다
6. `t_ord_webhooks` 에 `hook_sts="RECEIVED"` 로 INSERT → 200
7. INSERT 실패면 원문을 로그에 남기고 **500** — 「500 을 주면 샵바이의 **실패한 웹훅
   목록**(`GET /webhooks/failed`)에 남아 나중에 건져낼 수 있습니다」

**무시하는 것 = 사실상 전부.** 어떤 이벤트든 동일하게 저장만 한다. `_UNKNOWN` 도 저장한다.

**일부러 하지 않는 것 3가지**(docstring 명시)
- **중복 제거를 하지 않는다** — 페이로드에 이벤트 고유번호가 없어 재전송인지 진짜 두 번
  일어난 일인지 구분 불가. 「임의의 키로 접으면 진짜 사건을 잃습니다」
- **rate limit 을 걸지 않는다** — 다른 API 와 반대. 「재전송이 없으므로 우리가 한 건이라도
  거절하면 그 주문은 사라집니다」
- **처리를 하지 않는다** — 「무거운 일을 요청 안에서 하면 타임아웃 = 유실입니다」

**상태값 4종은 정의만 되어 있다**: `RECEIVED`(기본값) · `DONE` · `FAILED` · `IGNORED`.
`RECEIVED` 외에는 코드 어디서도 세팅되지 않는다.

**★ 소비자가 없다.** `TOrdWebhooks` 를 참조하는 코드는 모델 정의(`models.py:1123`)와
이 파일의 `create`(`shopby_hook.py:124`) **둘뿐**이다. 즉 **수신함은 있으나 그것을 읽어
주문을 진행시키는 처리 단계가 아직 존재하지 않는다.**

### 양쪽 담당

- **쓰기(발신)** — Shopby (설치된 앱 기준. 서명·인증 헤더 없음)
- **읽기(수신·저장)** — webadmin
- **비밀 경로 발급·보관** — 후니(Railway 환경변수 `SHOPBY_WEBHOOK_SECRET`)
- **Shopby 측 등록** — 후니 대표 계정이 셀러어드민 > 상품 > 앱 > [T]개발 정보 에서 수행
- **후속 처리(판단)** — 설계상 「주문 조회 API 로 다시 읽어 판단」(fail-closed). **미구현**

### 근거

- `raw/webadmin/webadmin/catalog/shopby_hook.py:1-27` — 파일 docstring 전문
  「**이 파일이 하는 일은 하나다: 잃어버리지 않는 것.**」 / 「샵바이는 **실패한 웹훅을 다시
  보내지 않습니다**」 / 「**웹훅 본문은 판단 근거가 아니라 신호입니다.**」
- `shopby_hook.py:44-47` — `HOOK_RECEIVED`/`DONE`/`FAILED`/`IGNORED` 정의
- `shopby_hook.py:49-51` — `_ORDER_CONTAINERS = ("order", "orderInfo")`
  「CREATE_ORDER 는 `order` 안에, 나머지는 최상단에 둔다」
- `shopby_hook.py:77-82` — `_secret_ok()`, 「**미설정이면 무조건 실패**」
- `shopby_hook.py:85-96` — 응답 규약 docstring (200/500/404)
- `shopby_hook.py:110-133` — 저장 본문 전체(분기 없음)
- `raw/webadmin/webadmin/config/urls.py:271-272` — 라우팅
- `raw/webadmin/webadmin/config/settings.py:455-465` — `SHOPBY_WEBHOOK_SECRET`(기본 `""`) ·
  `SHOPBY_SYSTEM_KEY` · `SHOPBY_ACCESS_TOKEN` · `SHOPBY_API_BASE`
- **소비자 부재**: `grep -rn "TOrdWebhooks" raw/webadmin/webadmin/` →
  `models.py:1123`(정의) · `shopby_hook.py:124`(생성) 2건뿐
- `raw/webadmin/docs/shopby-server-api.md:23-25`(웹훅 메서드·재전송 없음·서명 없음),
  `:29-48`(대표님이 해 주셔야 하는 것 — 앱 등록·권한·이벤트 켜기·수신 URL·**설치**),
  `:78-84`(구독 4종), `:97-107`(샘플), `:139-151`(신뢰성·미결)
- `docs/shopby/shopby-api/parsed/workspace-server-public.md:435` — Shopby 가 제공하는
  `eventType` enum 전체(`CREATE_ORDER`·`CHANGE_ORDER_STATUS`·`UPDATE_RECEIVER`·
  `ADD_TASK_MESSAGE`·`UPDATE_TASK_MESSAGE`·`PRODUCT_UPDATED`·회원계열·적립금계열 등)
- 가이드 `:334`(결제 웹훅에서 다시 만난다), `:695-700`(주문·결제·배송 알림은 샵바이,
  파일 관련 알림만 후니), `:916-931`(관리자에서 주문 상태를 손으로 바꾸지 말 것)

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| **Shopby 쪽에 웹훅이 등록되지 않았거나 앱이 설치되지 않음** | 웹훅이 **아예 오지 않는다**. 「등록만 해서는 오지 않습니다」 | 결제된 주문이 후니에 전혀 도달하지 않는다. 전 주문 |
| `SHOPBY_WEBHOOK_SECRET` 미설정 | 모든 웹훅이 **404** 로 거절 | 위와 동일 + Shopby 실패 목록에 쌓임(그나마 건질 수 있다) |
| 우리 서버가 재시작 중/타임아웃 | **그 사건은 영영 오지 않는다**(재전송 없음) | 「결제는 됐는데 생산이 시작되지 않는」 사고. `GET /webhooks/failed` + 보정 폴링이 유일한 구제 |
| 저장 실패를 200 으로 덮음 | 사건이 조용히 사라진다 | 설계상 배제됨(500 반환) |
| 비밀 경로 유출 | 서명이 없으므로 **누구나 가짜 주문 이벤트를 쏠 수 있다** | 방어는 「조회 재확인(fail-closed)」뿐인데 그 처리 단계가 아직 없다 |
| **수신함 소비자 부재(현 상태)** | `t_ord_webhooks` 에 행만 쌓이고 아무 일도 일어나지 않는다 | **결제 → 생산 전환이 통째로 미구현.** I-4 가 붙어도 이게 없으면 파이프라인이 끊긴 채다 |
| 중복 수신 | 설계상 허용(멱등은 처리 단계 책임) | 처리 단계가 없으므로 현재는 무해하나, 붙일 때 반드시 조회 재확인 기반이어야 한다 |

### 미확인

- **Shopby 측 웹훅 등록 여부 — 파일로는 확정할 수 없다.**
  `docs/shopby/` 와 `docs/huni/shopby-onboarding/` 를 전수 검색했으나 등록 완료를 증언하는
  문서가 없다(`docs/shopby/` 하위의 webhook 언급은 전부 Shopby OpenAPI 원문이고,
  onboarding 문서에는 「웹훅」이라는 단어 자체가 나오지 않는다).
  → **라이브 Shopby 셀러어드민 > 상품 > 앱 > [T]개발 정보 에서 ① 앱 설치 여부
  ② 켜진 웹훅 이벤트 목록 ③ 수신 URL ④ 메서드 를 직접 확인해야 닫힌다.**
  보조로 `GET /webhooks/failed` 호출 1회면 「오긴 왔는데 실패했다」와 「아예 안 왔다」를 가른다.
- `SHOPBY_WEBHOOK_SECRET` / `SHOPBY_SYSTEM_KEY` / `SHOPBY_ACCESS_TOKEN` 이 Railway 에
  실제로 채워져 있는지 — 환경변수 실측 필요(코드 기본값은 빈 문자열).
- `t_ord_webhooks` 라이브 적재 건수 — 0건이면 위 등록 미완의 강한 신호.
- 웹훅 호출 **IP 대역** — Shopby 문서에 없음(`shopby-server-api.md:151`).
- `RETURN_DONE`/`EXCHANGE_DONE` 은 `CHANGE_ORDER_STATUS` 의 `orderStatusType` 값으로
  오는 것으로 보이나(`order-to-mes-process.md:221`), 별도 이벤트인지 상태값인지 실측 미확인.

---

## I-6 토큰 만료 / 재견적

### 계약

**두 개의 시계가 있다 — 역할이 다르다.**

| 시계 | 값 | 기준 시각 | 무엇을 보증하나 |
|---|---|---|---|
| `HANDOFF_TTL_SEC` | 3600초(1시간) | `ts`(이 토큰의 서명 시각) | 「이 **가격**을 보증하는 시간」 |
| `REQUOTE_MAX_AGE_SEC` = `CART_TTL_SEC` | 30일 | **`orig_ts`**(최초 발급 시각, 승계 불변값) | 「이 **사양서**를 사양서로 인정하는 시간」 |

**TTL 을 늘리지 않는 이유**(가이드가 길게 설명): 「서명은 위조를 막을 뿐 최신성을 보장하지
못한다. 30일 토큰은 개정된 단가·삭제된 수량구간·등록 해제된 자재조합·단종 상품·수명주기로
지워진 원고를 전부 검사 없이 통과시킨다.」

**30일이 30일인 이유**: **S3 임시 버킷 원고 수명이 30일**이고, 그 수명주기의 명시적 목적이
「장바구니만 담고 안 산 원고 정리」다. 이보다 길면 「재견적은 통과하는데 원고가 이미 없는」
주문이 만들어진다. 「보관 기간은 **가장 짧은 것**을 따릅니다」 — 현재 확인된 것은 S3 30일뿐이고
Edicus 프로젝트 보존 기간과 Shopby 장바구니 보존 기간은 확인 중.

**만료되면 고객이 겪는 것**

| 상황 | 고객 경험 | 코드 |
|---|---|---|
| 담기 시점에 토큰이 1시간을 넘김 | **막지 않는다.** 저장 전에 다시 계산하고 `repriced:true` + `prev_total`(고객이 보던 옛 금액)을 준다. 「total 과 다르면 "가격이 변경되었습니다" 안내 후 동의를 받고 담아 주세요」 | `cart_items.py:396-406` |
| 장바구니에 1시간 넘게 담겨 있음 | **정상.** 결제 직전 갱신이 새 토큰을 발급한다 | `_verify_for_requote` 가 `expired` 를 통과시킴 |
| 담은 지 30일 초과 | `410 expired` / `422 token_too_old` → 「장바구니에 담긴 지 오래되어 **다시 담아 주셔야 합니다**」 | `cart_items.py:533`, `widget_api.py:3942-3944` |
| 서명 자체가 깨짐(저장 중 절단 등) | `422 bad_token` → 「주문 정보를 확인할 수 없습니다. 장바구니에서 다시 담아 주세요」 | `widget_api.py:3939-3941` |
| 담긴 뒤 상품이 판매중지 | `409 product_unpublished` — **그 줄만** 결제 불가로 표시하고 나머지 줄은 진행 | `_reprice` → `_prd_sellable_err` |
| 결제 **이후** | 「결제 후에는 만료를 보지 마세요. … 만료를 이유로 막으면 결제는 됐는데 주문이 안 들어가는 상황이 됩니다」 | `token_for_item` 이 만료로 거르지 않음 |

**재견적 = 결제 직전 갱신 = 수량 변경, 전부 같은 호출**

| 정본(B안) | 구방식 |
|---|---|
| `PUT /api/w/v1/cart/items/{item_id}` `{site_key, qty?|copies?}` | `POST /api/w/v1/handoff/requote` `{site_key, token, qty?|copies?}` |
| 서버키 **필수** | 서버키 선택(하위호환) |
| `item_id` **불변** — Shopby 에 박은 값을 고칠 필요 없음 | 토큰이 매번 새로 발급 → Shopby 텍스트 옵션 갱신 필요 |

- `qty`/`copies` **생략** = 가격만 재계산(결제 직전 갱신). **필수 단계** — 「③(수량 변경)은
  안 만들어도 되지만 ④는 없으면 결제 자체가 안 됩니다(토큰 유효기간 1시간)」
- `qty` 지정 = 수량 변경(단일), `copies` 지정 = 부수 변경(셋트).
  셋트에 `qty` → `422 set_not_supported`, 단일에 `copies` → `422 copies_not_allowed`
- **선택 사양은 받지 않는다.** 서명 payload 에서 전부 승계(`_carry_quote_body`) —
  「"수량 외에는 바꿀 수 없다"가 규칙이 아니라 **구조로 강제**된다」. 사양을 바꾸려면
  항목을 지우고 상품 페이지에서 다시 담아야 한다
- `exp_dt`·`orig_dt` 는 **갱신하지 않는다** — 「재견적이 시계를 리셋하면 30일 상한이
  무의미해진다」
- 계산은 `widget_api._reprice` **한 벌**을 공유한다 — 「경로가 둘이 되면 금액이 갈린다」
- 호출 상한: 서버-투-서버 전용 버킷(`"rq:"`, `"ct:"`) — `RATE_LIMIT_REQUOTE_PER_MIN = 600`(`widget_api.py:435`), `RATE_LIMIT_CART_PER_MIN = 600`(`cart_items.py:53`). 「브라우저 트래픽과 별도
  버킷 … 위젯 조회와 한 버킷을 쓰면 429 가 곧 결제 불가가 된다」

**가격이 바뀔 수 있는가 — 그렇다.**
- 응답에 `price_changed`(boolean|null) + `prev_total` 이 온다.
- `price_changed` 는 **수량을 바꾸지 않은 호출에서만** 판정된다. 수량을 바꾼 호출은
  수량구간별 단가 때문에 비교 조건이 달라 `null`. 「조건이 다른 두 금액을 비교해 경고를
  띄우면 항상 떠서 경고 자체가 무의미해진다」
- 비교 불가면 `null` — 「거짓 안심보다 '모름'이 낫다」

**바뀐 가격을 받아들일지 결정하는 주체 = 자사몰/고객.** 후니는 판정만 내려준다.
가이드: 「200 · `price_changed: true` → "장바구니에 담으신 뒤 가격이 변경되었습니다" 안내 후
**동의를 받고** 진행. 동의 없이 오른 금액으로 결제하면 **분쟁이 됩니다**.」

**장바구니 항목 보관소의 역할** (`cart_items.py`)
- 「자사몰이 우리 토큰을 한 번도 보관하지 않게 만든다.」 토큰·사양(원고 파일 키 포함)은
  후니가 갖고, 자사몰은 짧은 `item_id` 하나만 Shopby 텍스트 옵션에 붙인다
- **장바구니 자체의 원장은 계속 Shopby** — 「여기 있는 것은 "항목에 붙는 부가정보"뿐이라
  이중 원장이 되지 않는다」(장바구니를 통째로 후니가 갖는 A안을 기각한 이유)
- `PUT /cart/items/{item_id}` 는 갱신 시 `tkn`·`payload`·`summ_txt`·`tot_amt`·`qty`·
  `qty_rule` 을 한 번에 다시 쓰고, **핸드오프 로그를 남긴다** — 「없으면 자사몰이 B안으로
  옮기는 순간 결제 직전 갱신 트래픽 **전량**이 기록 없는 경로로 이동한다」
- 갱신 도중 항목이 삭제되면 `404`(500 아님) — 「500 은 앞단 CDN 이 본문을 갈아쳐 자사몰이
  사유조차 못 읽는다」
- 4종 API 전부 CORS 헤더를 **일부러 내보내지 않는다**(브라우저는 preflight 에서 막힘)

### 양쪽 담당

- **재계산·재서명·보관** — webadmin
- **호출 시점 결정·고객 동의 받기·Shopby 반영** — 자사몰 서버.
  「응답의 `total` 로 샵바이 장바구니 수량도 함께 고치고(`orderCnt = total ÷ 10`),
  `summary` 로 `huni_order` 텍스트 옵션도 갱신하세요」
- **권장 호출 시점** — 「결제 버튼 클릭 직후」. 주문서 진입 시점에 부르면 고객이 머무는
  동안 다시 만료될 수 있다

### 근거

- `raw/webadmin/webadmin/catalog/widget_api.py:2541-2563` — `REQUOTE_MAX_AGE_SEC` 주석
  (TTL 과의 역할 차이 · 30일=S3 원고 수명 · Edicus·Shopby 보존기간 미확인)
- `widget_api.py:2565-2600` — `_verify_for_requote()`. 「⚠ 나이의 기준점은 `orig_ts`
  (**최초 발급 시각**)이지 `ts` 가 아니다 … 25일차에 장바구니를 열어 재견적이 돌면 45일차
  결제도 "나이 20일"로 통과하고, 그때 원고(30일 수명)는 이미 없다」
- `widget_api.py:3848-3884` — `_reprice()` 「계산 경로가 둘이 되면 **금액이 갈린다**」
- `widget_api.py:3749-3760` — `_carry_quote_body()` 「승계의 단일 지점 … 여기서 빠뜨린
  필드는 재견적 한 번에 조용히 사라진다」
- `widget_api.py:3885-3975` — `_requote_core()` (게이트 정책·409 파트너 처리 지침)
- `widget_api.py:3959-3974` — `price_changed` 판정 조건
- `widget_api.py:3236-3237` — 「⚠ 알려진 한계: S3 수명주기로 원고가 이미 삭제된 장바구니
  항목도 재견적은 통과한다 — 결제·승격 단계에서 잡아야 한다」
- `raw/webadmin/webadmin/catalog/cart_items.py:1-27` — 파일 docstring(B안 전체 흐름 6단계)
- `cart_items.py:44-49` — `CART_TTL_SEC = WAPI.REQUOTE_MAX_AGE_SEC`,
  「두 벌이면 언젠가 갈리고, 갈리는 순간 "조회는 되는데 재견적은 거절" 같은 죽은
  장바구니 항목이 생긴다」
- `cart_items.py:508-580` — `_cart_update()` 「`exp_dt` 는 **갱신하지 않는다**」
- `cart_items.py:606-625` — `api_cart_item()` (PUT/POST/DELETE 한 경로 · 핸드오프 로그)
- `cart_items.py:78-90` — `s2s_endpoint` (CORS 미개방)
- 가이드 `:404-410`(④가 핵심 · ③④는 같은 API), `:470-501`(수량변경·결제직전 갱신·3분기),
  `:530-545`(응답 필드), `:546-560`(`repriced` 경고), `:640-660`(보관 기간 · 갱신해도 연장 안 됨),
  `:672-681`(가장 짧은 것을 따른다), `:681-683`(호출 시점 권장), `:1743`(requote 전체 계약)
- **자사몰 구현**: `src/app/api/printly/requote/route.ts:17` (`POST /handoff/requote` 프록시,
  로그인 세션 필수, `site_key` 는 서버 env), `src/lib/api/requote.ts:44-58`(호출),
  `:63-77`(`optionInputsFromRequote` — `huni_token`+`huni_order`),
  `:79-85`(`orderCntFromRequote`),
  `src/components/cart/cart-page.tsx:118-152`(수량 변경 → 600ms 디바운스 → 재견적 →
  `updateLine(cartNo, orderCntFromRequote(res), optionInputsFromRequote(res))`),
  `:161-190`(로드 시 `qty_rule` 없는 줄 1회 자가 정규화)

### ★깨지면 무엇이 무너지는가

| 깨지는 방식 | 결과 | 폭발반경 |
|---|---|---|
| **결제 직전 갱신을 안 부른다** | 1시간 지난 장바구니는 **결제 자체가 불가** | 장바구니 경유 주문 전량 |
| 재견적 후 `orderCnt` 만 고치고 `huni_order` 요약을 안 고침 (또는 그 반대) | 「한쪽만 고치면 **화면 금액과 결제 금액이 갈립니다**」 | 결제 금액 오차 + 담당자가 틀린 사양을 봄. **직접적 금전 손실·분쟁** |
| `price_changed:true` 를 무시하고 그대로 결제 | 고객이 본 적 없는 금액이 청구된다 | 「동의 없이 오른 금액으로 결제하면 **분쟁이 됩니다**」 |
| `orig_ts` 대신 `ts` 로 나이를 잼 | 재견적이 시계 리셋 → 30일 상한 무력화 | **원고 없는 주문이 조용히 결제까지 간다.** 승격 단계에서야 터진다 |
| `exp_dt` 를 갱신함 | 위와 같은 구조 | 동일 |
| 재견적과 담기의 계산 경로가 둘로 갈림 | 담긴 금액 ≠ 재견적 금액 | 전 주문 금액 불일치. `_reprice` 단일화의 존재 이유 |
| `_carry_quote_body` 에 새 필드를 안 넣음 | 그 사양이 **재견적 한 번에 사라진다** | 이미 5회 발생. 사양 유실 = 오생산 |
| 재견적을 브라우저 버킷과 같은 rate limit 에 둠 | 429 가 곧 결제 불가 | 장바구니 항목이 많은 고객부터 결제 실패 |
| 재견적이 원고 존재를 확인하지 않음(현재 설계) | 30일 이내라면 통과하지만 원고가 이미 없을 수 있다 | 결제 후 승격 실패 → HOLD. 「현재로서는 장바구니 보존 기간을 30일 이하로 두는 것이 가장 확실한 방어」 |
| 갱신 중 삭제 경합에 500 을 반환 | 앞단 CDN 이 본문을 갈아쳐 자사몰이 사유를 못 읽고 재시도 폭주 | 설계상 배제됨(404 반환) |

### 미확인

- **Shopby 장바구니 보존 기간** — 가이드가 자사몰에 물어보고 있는 상태(「알려 주세요」).
  30일보다 짧으면 후니 보관 기간을 그 값으로 내려야 한다.
- **Edicus 편집기 프로젝트 보존 기간** — 「저희가 Edicus 담당자에게 확인하고 있습니다」.
  30일보다 짧으면 상한이 그쪽으로 내려간다. `payload.editors` 의 `prjid` 가 죽으면
  원고 없는 주문이 되는 것은 S3 원고와 완전히 같은 구조.
- 자사몰이 `PUT /cart/items/{item_id}` 로 전환할 시점 — 현재는 `handoff/requote` 구방식.
  전환하면 서버키가 **필수**가 되므로 발급이 선행돼야 한다.
- 자사몰이 결제 직전 갱신을 **실제로 부르는지** — `cart-page.tsx` 는 수량 변경과
  로드 시 정규화에서만 재견적을 부르고, `onCheckout()`(`:198-224`)에는 재견적 호출이
  없다. 주문서/결제 페이지에서 부르는지는 이 조사 범위 밖(체크아웃 코드 미확인).
  **→ `src/app/checkout/` 전수 확인으로 닫힌다. 안 부르고 있다면 1시간 지난 장바구니
  결제가 전부 실패한다는 뜻이므로 최우선 확인 대상.**

---

## 부록 — 이 문서를 닫으려면 확인해야 할 것 (우선순위 순)

| # | 무엇을 | 어디서 | 닫히는 항목 |
|---|---|---|---|
| 1 | Shopby 앱 설치 여부 + 켜진 웹훅 이벤트 목록 + 수신 URL | 셀러어드민 > 상품 > 앱 > [T]개발 정보 | I-5 전체 |
| 2 | 자사몰 체크아웃 경로에 결제 직전 갱신이 있는지 | `huni-skin-shopby/src/app/checkout/` | I-6 |
| 3 | `t_ord_orders` · `t_ord_webhooks` · `t_wgt_cart_items` 라이브 건수 | Railway 읽기전용 SELECT | I-4 · I-5 · I-6 |
| 4 | `optionInputs` 에 `inputNo` 없이 `POST /cart` 가 통과하는지 | Shopby 쇼핑몰 API 실호출 1회 | I-2 |
| 5 | 텍스트 옵션 `inputValue` 길이 상한 | Shopby 실호출(점증 길이) | I-2 |
| 6 | 부분취소 UI 의 단위(수량 vs 항목 전량) | 셀러어드민 주문 상세 | I-3 |
| 7 | 세금계산서·현금영수증 실제 품목·수량 표기 | 발행 1건 | I-3 |
| 8 | Railway 환경변수 `SHOPBY_WEBHOOK_SECRET` 외 3종 설정 여부 | Railway 대시보드 | I-5 |
| 9 | `SECRET_KEY` 가 재배포로 회전하는지 | Railway 대시보드 | I-1 |
| 10 | Edicus 프로젝트 보존 기간 | Edicus 담당자 | I-6 |
| 11 | Shopby 장바구니 보존 기간 | Shopby 문서/문의 | I-6 |

---

**출처 파일**
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py` (4,666줄)
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/cart_items.py` (645줄)
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/shopby_hook.py` (133줄)
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/pricing.py`
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py` · `config/settings.py`
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/docs/shopby-server-api.md`
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/docs/order-to-mes-process.md`
- `/Users/innojini/Dev/HuniWeb/raw/webadmin/docs/guide-sections/shopby-integration.html` · `cart.html`
- `/Users/innojini/Dev/HuniWeb/docs/shopby/shopby-api/parsed/workspace-server-public.md`
- `/Users/innojini/Dev/huni-skin-shopby/src/components/product/huni-widget.tsx`
- `/Users/innojini/Dev/huni-skin-shopby/src/lib/api/widget-order.ts` · `requote.ts`
- `/Users/innojini/Dev/huni-skin-shopby/src/app/api/printly/requote/route.ts`
- `/Users/innojini/Dev/huni-skin-shopby/src/components/cart/cart-page.tsx`
- `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/L0/M2/_evidence/sdk-guide-live-20260902.txt` (2,132줄, 2026-09-02 채록)
