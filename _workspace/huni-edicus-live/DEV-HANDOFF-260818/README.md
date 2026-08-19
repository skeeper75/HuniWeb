# Edicus 연동 — 개발 전달본 (2026-08-18)

레포 `shopbiz-site/HuniProductPrice2` · 브랜치 `master`

---

## 0. 한 줄 요약

**지금 라이브는 고객이 편집기에서 사진을 넣을 수 없습니다.** 편집기를 패시브 모드로 띄우고
있어서 사진·텍스트·배경 도구가 통째로 안 나옵니다. 이 전달본의 패치가 그걸 고칩니다.
그리고 결제 후 Edicus에 주문을 거는 코드는 **아직 없습니다** — 그 부분의 호출 계층까지
같이 넣었으니, 배선만 하시면 됩니다.

> ### 📌 먼저 읽어주세요 — `order-process-reference.md`
>
> 레드프린팅(같은 Edicus를 붙여 실제로 돌고 있는 시스템)의 주문 세션을 통째로 캡처해,
> **상품 진입부터 장바구니까지 전체 호출 순서를 시간순으로** 정리했습니다.
> 우리가 무엇을 빠뜨렸는지가 그 대조표에 다 나옵니다.
>
> 요약하면 **실질 구멍 3개**입니다.
> 1. 편집기가 패시브 → **이 패치가 수정** ✅
> 2. 담기 직전 **주문 가능 판정이 없음** — 저장 안 된 원고가 그대로 주문됨
> 3. **결제 후 Edicus 주문 걸기가 없음** — 인쇄 데이터가 생성되지 않음

---

## 1. 무엇이 잘못돼 있었나

편집기를 띄울 때 `run_mode=passive` 를 보내고 있었습니다. 패시브는 "툴바만 감추는 옵션"이
아니라 **작업영역인 캔버스만 남기는 모드**라, 사진 가져오기·배경·텍스트·사진틀·실행취소가
전부 사라집니다. 고객은 빈 사진 자리만 보고 아무것도 넣을 수 없습니다.

원래 코드에는 이런 주석이 붙어 있었습니다.

```js
// ★ 편집 모드는 항상 이 고정값 — 옵션(runMode·hideToolbar 등)으로 절대 뒤집지 않는다.
run_mode: "passive",
```

의도는 "오버레이 상단바가 저장/닫기를 제공하니 편집기 툴바를 켜면 이중 UI가 된다"였는데,
실제로는 이중 UI를 피하려다 **편집 기능 자체를 없앤** 상태였습니다.

**공식 SDK가 규정하는 값은 `passive` 하나뿐이고, 이 파라미터를 빼면 풀 편집기로 뜹니다.**
(`edicus-sdk-v2.js:149` — `(params.run_mode ? '&run_mode=' + params.run_mode : '')`,
주석에 `.. / passive : passive 모드 설정`. 공식 데모 `demo-basic/open-editor.js:26` 은
`// run_mode: ''` 로 아예 주석 처리해 둡니다.)

> 참고 — 레드프린팅 라이브는 `run_mode=standard` 를 보내지만 공식 문서에 없는 값입니다.
> 함께 보내는 `edit_mode` 는 SDK 주석이 *"FIXME 호환성 때문에 남겨둠. 삭제해야 함"* 이라고
> 못박은 레거시입니다. 그래서 우리는 **안 보내는 쪽**(공식 기본값)을 택했습니다.

---

## 2. 이 패치를 적용하면 무엇이 바뀌나

### 동작이 바뀌는 것 — 2가지

| 파일 | 변경 | 결과 |
|---|---|---|
| `huni_editor_sdk.js` | `run_mode: "passive"` 삭제 (createProject·openProject 양쪽) | 편집기가 **풀 모드**로 뜬다. 사진·레이아웃·배경·텍스트 탭 + 자동저장 + 편집종료 |
| `widget.js` | 오버레이 상단바에서 「저장」·「저장 후 닫기」 제거 | Edicus 툴바가 저장·편집종료를 담당하므로 상단바는 **「닫기」만**. UI 중복 제거 |

`sdk.save()` / `sdk.saveThenClose()` 는 **공개 API로 그대로 남겨뒀습니다.** 호스트가 직접
저장 UI를 만들고 싶을 때 쓰라고 남긴 것이고, 기본 오버레이만 안 쓸 뿐입니다.

### 동작이 안 바뀌는 것 — 3가지

| 추가분 | 왜 동작이 안 바뀌나 |
|---|---|
| `edicus_lookup.py` 주문 API 함수 6개 | **어디에서도 호출하지 않습니다.** HTTP 호출 계층만 넣었습니다 |
| `edicus-huni-theme.light.css` / `.dark.css` | 파일만 있고 배선은 주석 처리 (§4 결정 대기) |
| `huni_editor_sdk.js` 의 `privateCssUrl` 옵션 | 아무도 안 넘기므로 `null` → 아무 일도 안 일어남 |

---

## 3. 적용 방법

```bash
git checkout master && git pull origin master
git apply --check edicus-260818.patch   # 먼저 검사
git apply         edicus-260818.patch
```

**충돌 없음을 확인했습니다.** 패치가 건드리는 3개 파일(`edicus_lookup.py`,
`huni_editor_sdk.js`, `widget.js`)은 `origin/master` 최신본과 우리 로컬 HEAD에서
바이트 단위로 동일합니다 — 즉 최신 master 위에 그대로 얹힙니다.

### 적용 후 검증

```bash
node --check webadmin/catalog/static/catalog/huni_editor_sdk.js
node --check webadmin/catalog/static/catalog/widget.js
python -c "import ast;ast.parse(open('webadmin/catalog/edicus_lookup.py',encoding='utf-8').read())"

# 배포 후 실화면 — 편집기 버튼을 눌러 아래 3가지 확인
#   1) 좌측에 사진 · 레이아웃 · 배경 · 텍스트 탭이 보이는가
#   2) 상단 Edicus 툴바에 「저장됨」과 「편집종료」가 보이는가
#   3) 우리 오버레이 상단바에 「닫기」 하나만 있는가
```

배포 확인용 데모 페이지:
`https://huni-admin-production.up.railway.app/sdk/demo/?wgt=WGT_000311`

---

## 4. 결정 대기 1건 — 편집기 테마

편집기 iframe 안에 CSS를 주입해 브랜드 색을 입힐 수 있습니다(`private_css`). 배선 코드는
넣었지만 **디자인 결정이 안 나서 꺼둔 상태**입니다.

`widget.js` 의 이 한 줄만 풀면 켜집니다.

```js
// privateCssUrl: BASE + "/edicus-huni-theme.dark.css" + VQ,
```

두 안 모두 헤더를 후니 보라(`#5538B6`)로 바꾸는 것은 같고, **좌측 도구 패널**만 다릅니다.

| | 안 A `.light.css` | 안 B `.dark.css` |
|---|---|---|
| 좌측 패널 | 라이트로 뒤집음 | Edicus 기본 다크 유지 |
| override | 20줄 | 6줄 |
| 장점 | 사이트 전체와 톤 연속 | 흰 종이가 도드라짐, Edicus UI 변경에 덜 깨짐 |

비교 캡처: `../theme-compare/theme-compare.png`

**결정되면 파일명에서 `.light` / `.dark` 만 고르고 주석을 풀면 끝입니다.** 우리 쪽에서
확정 회신드리겠습니다 — 그 전까지는 꺼둔 채로 두셔도 됩니다.

---

## 5. 남은 작업 — 개발자분이 만드셔야 할 것

코드에 `@TODO(edicus-G6)` ~ `@TODO(edicus-G9)` 로 표시해 뒀습니다. 아래는 그 요약입니다.

### G7 — 결제 후 Edicus 주문 걸기 ★ 가장 큰 구멍

**지금 결제가 끝나도 Edicus 쪽 프로젝트는 `editing` 에 머물고, 인쇄 데이터 생성이 시작되지
않습니다.** 우리가 부르는 Edicus API는 토큰 발급 하나뿐이었습니다.

호출 계층은 `edicus_lookup.py` 하단에 넣어뒀습니다 — `get_project` · `tentative_order` ·
`definitive_order` · `cancel_order` · `clone_project` · `delete_project`. 엔드포인트·헤더·
본문 규격은 공식 데모(`demo-basic/server.js`)에서 그대로 옮긴 것이라 추측이 아닙니다.
자세한 규격표는 `edicus-server-api.md` 참조.

배선이 필요한 곳 4군데(같은 파일 하단 블록에 상세):

1. **결제 완료 훅** — 주문의 `editors[].result.prjid` 마다 상태 확인 → 잠정주문 → 확정주문
2. **주문 취소 훅** — 저장해 둔 `order_id` 로 취소
3. **재주문** — `clone_project`
4. **장바구니에서 뺄 때** — `delete_project`

> ⚠️ **선행 확인 항목** — 주문 API는 전부 `edicus-uid` 헤더를 요구하고, 이 uid는 편집기
> 토큰 발급 때 쓴 것과 **같아야** 합니다(`guest_uid(partner, site_cd, guest_id)`).
> 주문 레코드에 `guest_id` 와 `site_cd` 가 남아 있지 않으면 uid를 재현할 수 없습니다.
> 안 남고 있다면 **그것부터 저장하셔야 합니다.**

> ⚠️ **취소 경로만 다릅니다** — 나머지는 `/api/projects/{prjid}/…` 인데 취소만
> `POST /api/orders/{order_id}/cancel` 입니다. 잠정주문 응답의 `order_id` 를 반드시
> 우리 주문 레코드에 저장해야 취소할 수 있습니다.

### G6 — 저장 안 된 채 닫힌 경우 잡기 ★ 두 번째로 큰 구멍

지금 원고 필수 검사는 `editors[].result` 가 비어있지 않으면 통과입니다. 그런데 `result` 는
**클라이언트가 보낸 값**이라, 고객이 편집기를 열어 `prjid` 만 받고 저장 없이 닫아도
(뒤로가기·강제종료) 통과합니다. **인쇄 단계에 가서야 빈 원고가 드러납니다.**

레드프린팅은 이걸 막습니다 — 실측 캡처 기준 **장바구니 담기 0.9초 전에 두 번** 확인합니다.

```
+1317.6s  target=isReadyToOrder  → {"can_order":true,"doc_rev":1,"status":"editing"}
+1318.0s  target=projectThumbnail
+1318.1s  target=isReadyToOrder  → {"can_order":true,…}
+1318.5s  cart/add
```

**붙일 자리에 마커를 심어 뒀습니다** — `widget_api.py:948` `@TODO(edicus-G6)`.
수단도 이미 있습니다 → `edicus_lookup.get_project(uid, prjid)`.

먼저 정해야 할 것 2가지(마커에 상세):
- 응답에서 상태를 읽는 **키**. 레드프린팅 프록시는 `can_order`/`status` 를 주지만 Edicus
  원본이 같은 형태라는 근거가 없습니다. **응답 1건 받아보고 확정하세요.**
- 이 함수 스코프에서 **uid 를 어떻게 얻을지** (`guest_uid(partner, site_cd, guest_id)`)

새 오류 코드도 하나 필요합니다 — "원고 없음"(`artwork_required`)과 "편집했는데 저장 안 됨"은
고객 안내 문구가 달라야 합니다.

### G10 — 장바구니 썸네일 (신규 발견)

레드프린팅은 담기 직전 `projectThumbnail` 로 미리보기 이미지를 만들어 장바구니 줄에 씁니다.
우리는 없어서 **고객이 뭘 담았는지 볼 수 없습니다.**

Edicus 원본 API 로는 `GET /api/projects/{prjid}/preview_urls` 가 대응합니다. `edicus_lookup.py`
에 **일부러 안 넣었습니다** — 응답 구조가 미확인이고 장바구니 UI를 쇼핑몰이 어떻게 그릴지에
달려 있어서입니다. 필요해지면 `_edicus_api()` 한 줄입니다.

### G8 — 이어 편집(`openProject`) 실화면 검증

장바구니에서 다시 여는 경로는 아직 실화면으로 확인하지 않았습니다. `createProject` 만
확인했습니다.

### G9 — 재주문

주문된 프로젝트는 편집도 삭제도 안 되므로, "같은 걸로 또"는 `clone_project` 로 복제해
새 프로젝트를 여는 것이 정답 경로입니다.

---

## 6. 확인 필요 — 추정으로 채우지 않은 것

| 항목 | 상태 |
|---|---|
| `get_project()` 응답에서 주문 상태가 실리는 키 | 공식 데모가 표만 그리고 키를 못박지 않음. **실제 응답 1건 받아보고 확정할 것.** 추정 파싱 금지 |
| 자동저장 주기 지정 | 편집기가 자체 자동저장을 도는 것은 실화면 확인(「저장됨」). 파트너가 주기를 지정하는 파라미터는 공식 SDK URL 파라미터 목록에 **없음**. 레드프린팅의 `autoSave:5` 는 그쪽 상위 래퍼 옵션 |
| 토큰 선제 갱신 | 우리는 편집기가 요구할 때만 재발급(pull). 레드프린팅은 50분 주기로 밀어넣음(push). 장시간 편집에서 pull만으로 충분한지 미검증 |
| 미주문 프로젝트 자동삭제 기간 | Edicus 문서에 없음. **모션원에 문의 필요** — 이 값이 30일보다 짧으면 재견적 상한을 그 값으로 내려야 함 |
| 주문완료 후 "3~4주"의 정확한 일수·기준 시점 | 범위라서 상한 계산에 못 씀. **모션원에 문의 필요** |

---

## 7. 근거

우리 추정이 아니라 **공식 소스와 실화면**에서 확인한 것들입니다.

- **`MotionOne/edicus-dev`** (공식 SDK·데모·문서) — 로컬 사본 `raw/edicus_dev/`
  - `edicus-sdk-v2.js` (2.0.3) — 우리 `vendor/edicus-sdk-v2.js` 와 **바이트 단위 동일**.
    SDK 업그레이드할 것 없음
  - `demo-basic/server.js` — 모든 엔드포인트·헤더의 1차 근거
  - `demo-basic/order.js` — 상태 전이 주석
  - `ORDER_PROCESS.md` — `editing` → `ordering` → `ordered` 상태 흐름
- **라이브 실화면 확인 2026-08-18** — `huni-admin-production` SDK 데모, 반칼팬시스티커
  `WGT_000311`. 패시브(현재 배포본)와 풀 모드를 각각 열어 캡처 대조
- **분석 원장** — `../FINDINGS.md` (12절)
- **전체 파이프라인 문서** — https://claude.ai/code/artifact/6410e130-3c7e-4267-b9c1-244009d2f31e

---

## 8. 이 폴더의 파일

```
README.md                    이 문서 — 적용 방법과 남은 작업
order-process-reference.md   ★ 레드프린팅 실측 기준 전체 주문 프로세스 + 대조표
edicus-server-api.md         Edicus Server API 규격표 (G7 구현용)
edicus-260818.patch          적용할 패치 (git apply)
```

읽는 순서: `order-process-reference.md`(전체 그림) → 이 문서(적용) → `edicus-server-api.md`(구현).
