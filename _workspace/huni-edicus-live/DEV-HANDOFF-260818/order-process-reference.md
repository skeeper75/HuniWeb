# 전체 주문 프로세스 — 레드프린팅 실측 기준

> **이 문서가 기준선입니다.** 레드프린팅은 Edicus를 붙여 실제로 돌아가고 있는 시스템이고,
> 우리가 만들려는 것과 같은 일을 합니다. 그래서 "어떻게 해야 하나"를 추측하는 대신,
> **돌아가는 시스템이 실제로 무엇을 어떤 순서로 부르는지**를 캡처해 기준선으로 삼았습니다.
>
> 캡처: 2026-08-18 · `redprinting.co.kr` 본인 계정 실주문 세션 · 요청/응답 637건
> 원자료: `../raw/key-events.jsonl` · `../raw/cart.js`

---

## 0. 한 장 요약

```
 ①  상품 진입        get_digital_product_info      ← koiAccessToken 이 여기 동봉돼 옴
 ②  옵션 선택        get_ajax_price_vTmpl (x14)    ← 선택마다 서버 재계산
 ③  편집기 열기      editor/config → token → issueUserToken → getProductInfo
 ④  편집 (자동저장)   exists_doc → backup_doc (반복)
     └ 사진 넣기      imgpool/user-upload-url → user-img-gcs
 ⑤  편집 종료 ★      isReadyToOrder → projectThumbnail → isReadyToOrder
 ⑥  장바구니         cart/ext_add  또는  cart/add
 ⑦  결제 → 주문      [브라우저 캡처 밖 — 서버측] Edicus order/tentative → definitive
```

⑤가 이 문서의 핵심입니다. **우리는 이 단계가 통째로 없습니다.**

---

## 1. 종료 직전 0.9초 — 가장 중요한 구간

캡처의 마지막 4개 호출입니다. 타임스탬프 그대로입니다.

```
+1317.6s  POST makers.redprinting.net/editor  target=isReadyToOrder
                → {"can_order":true,"doc_rev":1,"status":"editing"}
+1318.0s  POST makers.redprinting.net/editor  target=projectThumbnail
                → {"urls":["…/projects/-P-IkO0…/preivew/preview_0.jpg?ts=…"]}
+1318.1s  POST makers.redprinting.net/editor  target=isReadyToOrder
                → {"can_order":true,"doc_rev":1,"status":"editing"}
+1318.5s  POST www.redprinting.co.kr/ko/cart/add
                → {"retCode":200,"result":{"ca_id":"28fc55d0e1bd…"}}
```

읽는 법:

| 호출 | 하는 일 | 우리 |
|---|---|---|
| `isReadyToOrder` | **이 프로젝트를 주문해도 되는가** 판정. 저장 안 된 채 닫혔거나 빈 사진칸이 남았으면 여기서 걸린다 | ❌ 없음 |
| `projectThumbnail` | 장바구니 줄에 띄울 **미리보기 이미지 URL** 생성 | ❌ 없음 |
| `isReadyToOrder` (재확인) | 썸네일 생성 뒤 한 번 더 | ❌ 없음 |
| `cart/add` | 장바구니 담기 | ✅ `handoff` 로 있음 |

**응답 `{can_order, doc_rev, status}` 가 우리가 찾던 답입니다.** 앞선 전달본에서 "주문 상태가
어느 키에 실리는지 미확인"이라고 적었는데, 레드프린팅 실측에서는 **`status` 가 최상위 키**이고
값은 `"editing"` 입니다. `can_order` 는 별도 불리언으로 함께 옵니다.

> ⚠️ 단, 이건 레드프린팅의 **자체 프록시**(`makers.redprinting.net/editor`) 응답 형태입니다.
> Edicus 원본 API(`GET /api/projects/{prjid}`)의 응답 키가 같다는 보장은 없습니다.
> 우리가 Edicus를 직접 부를 때는 **응답 1건을 받아보고 확정**해야 합니다.

---

## 2. 단계별 상세

### ① 상품 진입

```
GET /ko/product/get_digital_product_info?pdt_cod=PHSTPAN
```

응답에 상품 옵션 전체 + **`koiAccessToken` 이 동봉**돼 옵니다(HS256, 유효 1시간,
`refreshToken` 이 payload 안에 들어 있음). 즉 **상품 정보를 받는 순간 편집기 호출용 토큰도
같이 받는** 구조입니다.

- **후니 현재**: 위젯이 `/api/w/v1/widgets/{wgt_cd}` 로 구성을 받고, 편집기 토큰은 편집기를
  누를 때 `/api/w/v1/editor/token` 으로 따로 받습니다.
- **판단**: 우리 방식(필요할 때 발급)이 토큰 수명 관리에 유리합니다. **바꿀 필요 없음.**

### ② 옵션 선택 — 선택마다 서버 재계산

```
POST /ko/product_price/get_ajax_price_vTmpl     (템플릿형 상품)
POST /ko/product_price/get_ajax_price2_arr      (배열형 · 책자류)
POST /ko/product/get_seneca                      (책등 계산)
```

22.8초 동안 **14번** 불렸습니다. 브라우저는 가격을 계산하지 않습니다.

- **후니 현재**: `POST /api/w/v1/price` + `/validate` 로 동일한 구조. ✅ **동등**

### ③ 편집기 열기 — 프록시 3단

```
POST widget-api.redprinting.co.kr/api/editor/config/KOI
POST makers.redprinting.net/token                    {"type":"verify"}
POST makers.redprinting.net/editor                   target=issueUserToken
POST makers.redprinting.net/editor                   target=getProductInfo  collectionId=PHBKBKS
→ edicusbase.firebaseapp.com/ed#/editor_landing?…  (iframe)
```

레드프린팅은 **`makers.redprinting.net/editor` 라는 자체 프록시 하나로 Edicus API를 전부
감쌉니다.** `target` 필드로 무엇을 할지 정하는 방식입니다.

관측된 `target` 5종:

| target | 용도 |
|---|---|
| `issueUserToken` | 편집기용 사용자 토큰 발급 |
| `getProductInfo` | 상품 편집 설정(`useFullyFunctionalUI`·`passiveInfo`·`print_option`) |
| `isReadyToOrder` | **주문 가능 판정** ★ |
| `projectThumbnail` | 미리보기 이미지 URL 생성 ★ |
| (재편집 시) | `cart.js` 의 `reEditing` 분기 |

- **후니 현재**: `edicus_lookup.py` 가 같은 역할(비밀 키를 서버에 가두는 프록시)을 합니다.
  다만 지금 감싼 것은 **`issueUserToken` 하나뿐**입니다.
- **해야 할 일**: `isReadyToOrder` · `projectThumbnail` 에 대응하는 것을 추가해야 합니다.
  (§4 참조 — Edicus 원본 API 로는 무엇에 해당하는지)

**요청 형식이 `multipart/form-data` 입니다** — JSON 이 아닙니다. 우리가 흉내 낼 필요는
없지만, 레드프린팅 코드를 읽을 때 헷갈리지 않도록 적어둡니다.

### ④ 편집 — 자동저장과 사진 업로드

```
POST resource-dot-edicusbase.appspot.com/manapi/project/exists_doc   → {"exists":false}
POST resource-dot-edicusbase.appspot.com/manapi/project/backup_doc   → {}
```

관측된 `backup_doc` 시점: `+26.8s`, `+43.4s`, `+863.0s`, `+1162.8s`.
간격이 16초 ~ 300초로 **일정하지 않습니다** — 시간 주기가 아니라 **편집 이벤트 기반**입니다.

사진 업로드:

```
POST edicusbase.appspot.com/imgpool/user-upload-url
     {"project_id":"-P-IkO0…","user_id":"redp-7Iug…","file_ext":"png"}
     → {"upload_url":"https://storage.googleapis.com/edicusbase-upload/…?X-Goog-Expires=1800…"}
PUT  (그 서명 URL 로 브라우저가 직접 업로드)
POST edicusbase.appspot.com/imgpool/user-img-gcs
     → {"key":"-P-Ikty…","info":{"uri":"gcs://image/…","width":1052,"height":1039}}
```

- **우리가 할 일 없음.** 자동저장도 사진 업로드도 **Edicus 편집기가 자기 안에서** 합니다.
  파트너 서버는 관여하지 않습니다.
- **다만 이게 성립하려면 편집기가 풀 모드여야 합니다.** 패시브 모드에는 사진 탭 자체가
  없으므로 이 경로가 아예 안 열립니다 — 이번 패치가 고치는 지점입니다.

### ⑤ 편집 종료 ★ — 우리에게 통째로 없는 단계

§1 참조. 이 문서에서 가장 중요한 부분입니다.

### ⑥ 장바구니

```
POST /ko/cart/ext_add    → {"retCode":200,"result":{"ca_id":"9f9133a9…"}}   (에디터 원고)
POST /ko/cart/add        → {"retCode":200,"result":{"ca_id":"28fc55d0…"}}   (일반)
```

`cart/add` 본문에 가격이 **분해되어** 실립니다.

```
BASIC_PRICE=900 & BASIC2_PRICE=7700 & price=34400 & price_sub=3440 & total_price=37840
SALE_PCS_COST=22000,1400,2400,0
SALE_PCS_COST_COD=BID_RFL,COT_DFT,CUT_DFT,CVR_DFT
priceCalcResult={"pri_data":[…]}
```

- **후니 현재**: `POST /api/w/v1/handoff` 가 **서명된 토큰**으로 사양 전체를 봉인합니다.
  레드프린팅은 평문 폼 필드로 가격을 넘깁니다.
- **판단**: 우리 방식이 더 낫습니다. 쇼핑몰이 가격을 고칠 수 없습니다. **바꿀 필요 없음.**

### ⑦ 결제 → Edicus 주문

**이 구간은 브라우저 캡처에 없습니다.** 레드프린팅도 서버에서 부르기 때문에 보이지 않습니다.
따라서 이 단계는 레드프린팅이 아니라 **Edicus 공식 문서**가 근거입니다.

→ `edicus-server-api.md` 및 `edicus_lookup.py` 하단 블록 참조.

---

## 3. 레드프린팅과 대조한 결과 — 우리가 빠뜨린 것

| # | 항목 | 레드프린팅 | 후니 | 심각도 |
|---|---|---|---|---|
| 1 | 편집기 모드 | 풀 모드(`run_mode` 미전송) | `passive` 고정 | 🔴 **고객이 사진을 못 넣음** — 이번 패치가 수정 |
| 2 | 주문 가능 판정 | 담기 직전 `isReadyToOrder` **2회** | 없음 | 🔴 저장 안 된 원고가 그대로 주문됨 |
| 3 | 장바구니 썸네일 | `projectThumbnail` 별도 호출 | 없음 (단 **저장 이벤트에 딸려 옴** — §4C) | 🟡 고객이 뭘 담았는지 못 봄 |
| 4 | 결제 후 주문 걸기 | (서버측, 캡처 밖) | 없음 | 🔴 인쇄 데이터가 생성되지 않음 |
| 5 | 재편집 진입 | `cart.js` `reEditing` 분기 | 있으나 실검증 전 | 🟡 |
| 6 | 자동저장 | Edicus 내부 | Edicus 내부 | ✅ 동등 |
| 7 | 사진 업로드 | Edicus 내부 | Edicus 내부 | ✅ 동등 (풀 모드 전제) |
| 8 | 가격 재계산 | 선택마다 서버 | 선택마다 서버 | ✅ 동등 |
| 9 | 사양 봉인 | 평문 폼 | **서명 토큰** | ✅ 우리가 우위 |
| 10 | 토큰 갱신 | 50분 선제 push | 요구 시 pull | 🟡 장시간 편집 미검증 |

**🔴 3건이 실질 구멍입니다.** 1번은 이번 패치가 고치고, 2·4번이 남습니다.

---

## 4. 그래서 무엇을 만들어야 하나

### A. 주문 가능 판정 — `isReadyToOrder` 대응 (구멍 #2)

레드프린팅은 자체 프록시로 감쌌지만, **Edicus 원본 API 로는 프로젝트 조회가 대응**합니다.

```python
# edicus_lookup.py — 이미 추가돼 있음
body, err = get_project(uid, prjid)      # GET /api/projects/{prjid}
```

**부르는 위치**: `POST /api/w/v1/handoff` (장바구니 담기) 안, 원고 검사 구간.
지금 원고 필수 검사가 "`editors[]` 에 `prjid` 가 있는가"만 보는데, **있다고 저장된 것은
아닙니다.** 레드프린팅이 담기 직전에 두 번 확인하는 이유가 이것입니다.

```
현재:  editors[].result.prjid 존재?          → 있으면 통과
필요:  editors[].result.prjid 존재?
       → get_project(uid, prjid)
       → 주문 가능 상태인가?                  → 아니면 422 artwork_not_saved
```

> ⚠️ 응답에서 상태를 읽는 키는 **실제 응답 1건을 보고 확정**하세요. 레드프린팅 프록시는
> `{can_order, doc_rev, status}` 를 주지만 Edicus 원본이 같은 형태라는 근거는 없습니다.
> 추정 파싱은 "항상 통과" 또는 "항상 차단" 둘 다로 조용히 망가집니다.

**새 오류 코드**가 하나 필요합니다 — 기존 `artwork_not_uploaded`(원고 자체가 없음)와
"편집은 했는데 저장이 안 됨"은 고객 안내 문구가 달라야 합니다.

### B. 결제 후 Edicus 주문 (구멍 #4)

`edicus_lookup.py` 하단 `@TODO(edicus-G7)` 블록에 배선 4곳이 적혀 있습니다.
호출 규격은 `edicus-server-api.md`.

### C. 장바구니 썸네일 (구멍 #3) — API 호출이 아예 필요 없습니다

레드프린팅은 `projectThumbnail` 을 따로 부르지만, **우리는 부를 필요가 없습니다.**
썸네일 URL이 **저장 이벤트에 딸려 옵니다.**

```js
// 공식 데모 demo-vdp/open-tnview.js handleSaveDocReport
if (data.info.docInfo.tnUrlList && data.info.docInfo.tnUrlList.length > 0) {
    console.log("대표 썸네일 Url:", data.info.docInfo.tnUrlList[0]);
}
```

`save-doc-report` 의 `info.docInfo.tnUrlList[0]` 이 대표 썸네일입니다.
**이번 패치에서 `docInfo` 를 `save` 이벤트로 올려두었으므로** 배선이 거의 끝나 있습니다.

```js
// huni_editor_sdk.js — 이번 패치 적용분
self._fire("save", { projectId: self._projectId, docInfo: info.docInfo || null });
```

남은 일은 `widget.js` 의 `sdk.on("save", …)` 에서 꺼내 `setEditorResult` 에 함께 싣는 것뿐입니다.

```js
sdk.on("save", function (d) {
  el.setEditorResult(uid, { prjid: …, ps_cd: …, saved_at: …,
                            tn_url: (d.docInfo && d.docInfo.tnUrlList || [])[0] || null });
});
```

그러면 `handoff` 의 `editors[].result` 에 썸네일 URL이 실려 장바구니에서 바로 쓸 수 있습니다.

> 대안: Edicus 원본 API `GET /api/projects/{prjid}/preview_urls` → `{urls:[…]}`
> (공식 데모 `server.js` `get_preview_urls` · `project.js` `on_get_preview_tn`).
> 저장 이벤트를 놓쳤을 때(재편집 진입 등)의 보조 경로로 쓸 수 있습니다.

---

## 5. 근거

| 주장 | 근거 |
|---|---|
| 전체 호출 순서·타임스탬프 | `../raw/key-events.jsonl` (637건, 2026-08-18 캡처) |
| `isReadyToOrder` 응답 `{can_order,doc_rev,status}` | 같은 파일, `+1317.6s` / `+1318.1s` 응답 |
| `projectThumbnail` 응답 `{urls:[…]}` | 같은 파일, `+1318.0s` 응답 |
| `cart/add` 폼 필드 | 같은 파일, `+1318.5s` 요청 본문 |
| 자동저장이 Edicus 내부 동작 | `backup_doc` 호출 주체가 편집기 iframe |
| 편집기 재편집 분기 | `../raw/cart.js` `reEditing` |
| Edicus 원본 주문 API | `raw/edicus_dev/demo-basic/server.js` · `ORDER_PROCESS.md` |
| 패시브 모드가 사진 탭을 없앰 | 2026-08-18 라이브 실화면 대조 (`../theme-compare/` 및 FINDINGS §4) |

**캡처의 한계 — 정직하게**: 이 세션은 `cart/add` 에서 끝납니다. 결제·주문확정 구간은
레드프린팅도 서버에서 처리하므로 브라우저에 보이지 않습니다. ⑦단계만은 레드프린팅 실측이
아니라 Edicus 공식 문서가 근거이며, 이 문서는 그 둘을 섞지 않았습니다.
