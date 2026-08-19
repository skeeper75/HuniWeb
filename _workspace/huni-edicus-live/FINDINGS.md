# RedPrinting 라이브 캡처 — Edicus 연동 실측 (2026-08-18)

> 대상: `redprinting.co.kr` (본인 계정, `RP_USERNAME`/`RP_PASSWORD`)
> 방법: scrapling `StealthySession`(Playwright) 헤드풀/헤드리스 캡처 + `cart.js` 원본 정독
> 원자료: `raw/` — `key-events.jsonl`(637건) · `cart.js` · `edicus_theme.json` · `edicus-original-styles.css` · 스크린샷

---

## 0. 자격증명 정정 [확인됨]

- `REDPRINTING_SITE_PW` = **무효** (`ajax_login` → `retCode 995`)
- `RP_PASSWORD` = **유효**. ID는 두 키 동일(`RP_USERNAME` = `REDPRINTING_SITE_ID`)
- `.env.local` 정리 필요

---

## 1. 토큰 2층 구조 [확인됨]

### 층 A — 파트너 API 토큰 `koiAccessToken` (HS256)
`GET /ko/product/get_digital_product_info?pdt_cod=<코드>` **응답에 동봉**되어 옴.
```json
{ "company":"레드프린팅","companyCode":"0101","customerCode":"15090035",
  "userId":"redprinting","division":"host","lang":"ko","isClient":true,
  "refreshToken":"<30자>", "iat":…, "exp":iat+3600 }
```
→ `makers.redprinting.net` 호출용. 유효 **1시간**. **refreshToken이 JWT payload 안에** 동봉.

### 층 B — 편집기 신원 토큰 (Firebase custom token, RS256)
편집기 iframe URL의 `token=` 파라미터.
```json
{ "aud":"https://identitytoolkit.googleapis.com/…/IdentityToolkit",
  "iss":"edicusbase@appspot.gserviceaccount.com",
  "uid":"redp-7Iug7Jqw7KeEbG9qZXN1czc1",
  "claims":{"partner":"redp"}, "iat":…, "exp":iat+3600 }
```
→ Edicus는 **Firebase 기반**. 유효 **1시간**.

### uid 규칙 [확인됨 · 우리와 다름]
```
클라이언트 전송 : 7Iug7Jqw7KeEbG9qZXN1czc1        = base64("신우진lojesus75")
Firebase 토큰   : redp-7Iug7Jqw7KeEbG9qZXN1czc1   ← 파트너 접두사는 서버가 붙임
```
- **회원명 + 회원ID 기반 결정론적 uid** → 기기·브라우저 바뀌어도 동일
- 우리: `mo-` + `sha256(partner:site_cd:guest_id)[:50]`, `guest_id`는 **localStorage** → 브라우저 바뀌면 다른 사람
- ⚠ RedPrinting은 **해시가 아닌 base64**라 회원명이 평문 노출(GCS 경로에도 박힘). **우리 sha256 방식이 이 점에서는 우수** — 취할 것은 "회원 식별자를 씨앗으로" 라는 원칙뿐

---

## 2. `en.call()` API 계약 [확인됨]

```http
POST https://makers.redprinting.net/editor
Content-Type: multipart/form-data
  target       = issueUserToken | getProductInfo | isReadyToOrder |
                 projectThumbnail | cloneProject | deleteProject |
                 tentativeOrder | definitiveOrder | cancelOrder
  uid          = <base64 uid, 접두사 없음>
  email        = null
  staffCode    = null
  collectionId = <상품코드 또는 프로젝트ID>
  qry          = <JSON, 명령별>

POST https://makers.redprinting.net/token
  {"type":"verify"}  → {"refreshToken":"…"}       # 초기 발급
  {"type":"refresh", "refreshToken":"…"} → {token, refreshToken}   # 갱신
```
전부 Edicus Server API와 1:1 대응 — **RedPrinting은 자체 서버로 프록시**(우리 `/api/w/v1/editor/token` 과 같은 패턴).

### 실측 응답
- `isReadyToOrder` → `{"can_order":true,"doc_rev":1,"status":"editing"}`
- `projectThumbnail` → `{"urls":["…/preivew/preview_0.jpg?ts=…"]}`
- `getProductInfo(PHBKBKS)` → `{product:{useFullyFunctionalUI:false, passiveInfo:{}, editor:"template",
   print_option:{…}, template_option:{…}, sizes:[…], userData:"…", multilingualCustomData:{…}}}`

---

## 3. 편집기 실행 파라미터 [확인됨]

```
https://edicusbase.firebaseapp.com/ed#/editor_landing
  ?cmd=create &token=<Firebase JWT>
  &ps_code=144x204@PHSTPAN          # 판스티커: 작업사이즈mm@상품코드
  &ps_code=8X6S@PHBKBKS             # 포토북: 규격코드@상품코드  ← 체계가 상품군마다 다름
  &title=… &template_uri=gcs://template/partners/redp/res/template/<id>.json
  &partner=redp &div=host &lang=ko &ui_locale=ko
  &run_mode=standard  &edit_mode=standard          # ★ passive 아님
  &plugin_param={"mtrlCode":"RXYUP080","companyCode":"0101"}
  &wait_options=true
```

### URL 빌더가 지원하는 전체 파라미터 (역공학 `:2642`)
우리 문서에 **없는 것들**:
```
editor_type · parent_type · master_mode · ui_style · unit_page · max_order · min_order ·
force_plugin · plugin_param · resapi_param · unlayers · edit_lock · video_frames · env_mode ·
wait_ddp · wait_private_css · wait_prod_info · wait_options · wait_option_string ·
dev_apiHost · dev_assetHost · dev_uploadHost · dev_resHost
```
→ **우리 SDK 문서(2026-01-06)가 구버전**으로 판단됨.

---

## 4. run_mode — passive vs standard [확인됨 · 우리 최대 갭]

역공학 코드 4개 호출부 전부:
```js
n.hideToolbar && (e.hideToolbar = n.hideToolbar, K.mode = "passive")
run_mode: e.hideToolbar ? "passive" : "standard"
```
→ **`hideToolbar` 를 넘길 때만 passive.** RedPrinting `cart.js` 어디에도 `hideToolbar` 없음 → **항상 standard**.

우리:
```js
// huni_editor_sdk.js:176-178, 205
// ★ 편집 모드는 항상 이 고정값 — 옵션(runMode·hideToolbar 등)으로 절대 뒤집지 않는다.
run_mode: "passive",
```

### passive가 감추는 것 (Edicus 문서 원문)
> 패시브 모드는 edicus 를 **작업영역인 canvas 만 보이게** 띄우고 … **multi line 은 지원하지 않음.**

→ 사진 가져오기·배경·텍스트·사진틀·undo/redo·미리보기·저장하기가 **전부 사라짐**.
→ 우리 오버레이 상단바는 저장/저장후닫기/닫기 3개뿐 = **고객이 이미지를 넣을 방법이 없음**.

### 실측 툴바 (iframe **내부** innerText — Edicus DOM 확정)
- 판스티커: `실행취소 다시실행 | 미리보기 편집종료 | 사진 디자인 전체`
- 포토북: `실행취소 다시실행 | 저장하기 미리보기 편집종료 | 사진 배경 텍스트 사진틀 | 사진 자동 넣기 · 사진 가져오기`

### 커스텀 탭 = 내용물만 파트너 공급
```js
if (n.customTabInfo) { e.extra.custom_tab = await this.getProductInfo(productCode); }
// customTabInfo 출처: product.multilingualCustomData.product[locale].customTabInfo
```
→ **껍데기는 Edicus, 탭 내용은 파트너.** 순정과 달라 보이는 이유.
→ SDK 이벤트에 `customTabSelectionChange` · `pageCountChange` · `printCountChange` 존재.
→ `cart.js` 의 `disableAllOption` 이 끄는 대상이 이 커스텀 탭(주문 패널과 중복 방지).

---

## 5. 장시간 편집 대응 [확인됨]

```js
// cart.js reEditing — passive 분기
var openOption = { projectId, clone:false, uiLocale, autoSave:5, lockGroupPageCount };
Editor.openFullyFunctionalUI(editorConfig, openOption);
```
- **`autoSave: 5`** = 5분 주기 자동저장. **SDK 내장 옵션**(역공학의 `setInterval(save, 6e4*W)` 의 W)
- **`clone: false`** = 장바구니 재편집은 원본 직접 수정. `clone:true` 옵션 존재 → 재주문 설계의 열쇠
- 토큰: `autoRefreshToken` → `setInterval(refreshAccessToken, 3e6)` = **50분 선제 갱신** + iframe에 postMessage push
- Edicus 설계는 **pull**(`request-user-token` → `send-user-token`). 우리는 pull만 구현(정상)

### 상품별 세밀 제어 (else 분기 = standard)
```js
포토북 PHBKBKS·PHBKSMP·PHBKPRM·PHBKPTP·PHBKMYB → {initPageCount, maxPage, minPage}
포스터 PHPTEDT·PHPTSHP·PHPTBKG·PHPTDFT        → {maxPage, minPage}
MEPKDFT·GSSMSTP → disableMasterColorPicker
FBCLTSH → disableSelection      STTPMSK → disableTapeOptions
TPHPFLM(+자재조건) → unableLayers:"White"
// 2025-11-05 전체 적용
openOptionPCS.disableAllOption = true;
_exceptDisableElements.push('.get-button-div');
openOptionPCS.pluginCustomData = { mtrlCode, exceptDisableElements };
```

---

## 6. 장바구니 [확인됨]

| 상품 | 엔드포인트 |
|---|---|
| 판스티커 | `POST /ko/cart/ext_add` |
| 포토북 | `POST /ko/cart/add` |

응답 공통: `{"retCode":200,"result":{"ca_id":"<32자 hex>"}}`

### 편집기 관련 필드 (포토북 `/cart/add`, 총 49필드)
```
edicusProjectID    = -P-IkO0Bd0gjV_6-g0lE
edicusUserID       = 7Iug7Jqw7KeEbG9qZXN1czc1
edicusToken        = <템플릿 리소스 토큰: {partner_code,resource_id,iat} · 만료 없음>
edicusInfo         = <3,932자 — status/projectID/docInfo 전문>
editor_thumb_url   = https://storage.googleapis.com/…/preview_0.jpg
orgEdicusProjectID = (빈값)   ← 재편집·복제 원본 자리
editor_idx         = (빈값)
RedprintingAccessToken = <koiAccessToken 재전송>
priceCalcResult    = <3,668자 계산 로그 전문>
```
⚠ **가격에 서명이 없음** — 브라우저 폼값을 그대로 신뢰. 같은 페이지 내부라 성립.
우리처럼 외부 쇼핑몰 임베드 모델엔 부적합 → **우리 HMAC 서명 방식이 이 지점은 우수**.

### `docInfo` 구조 (= `edicusInfo.docInfo`)
```
editorType "template" · projectID · psCode · docRevision
canAddPage · totalPageCount 22 · coverPageCount 1 · contentPageCount 20 · totalGroupUnitCount
totalCellCount 102 · emptyCellCount 101 · lowResCellCount 0 · notVisitedPageCount 21
spine_mm 11 · layoutMap · pageInfos[] · tnUrlList[] · usedFontsList[]
vdpList[] · foilList[] · layerList[] · userData(productCustomData)
```
→ **내용 충실도 판정 재료가 전부 여기 있음.**
→ 이미지 경로: `gcs://image/partners/redp/users/<uid>/projects/<prjid>/imgpool/<id>.png`

### 🔴 주문 가능 판정이 두 겹
| 검사 | 출처 | 보는 것 |
|---|---|---|
| `can_order` | `isReadyToOrder`(서버) | **저장 여부만** (`doc_rev` null이면 false) |
| `isOrderAble` | `save-doc-report`(편집기) | 내용 충실도 · **passive 모드에서만 읽음** |

**실측: 빈 칸 101/102 · 미방문 21쪽인데 `can_order: true`.** 서버 판정은 내용을 안 봄.

---

## 7. 재편집 = 장바구니 항목 잠금 [확인됨]

```
POST /ko/cart/koi_status_update {ca_id, gbn}     gbn ∈ "step1" | "end"
```
- `step1`(편집 시작) → 체크박스 `disabled` + 「개별주문」 버튼을 **"주문 불가 / Editor 업데이트 중입니다"** 로 교체
- `end` → 잠금 해제
- 저장 시: `POST /ko/cart/update {ca_id, edicusInfo, RPEditorData}` → 성공하면 `end`
- 닫기만 해도 `end` + `location.reload(true)`
- 수량: `POST /ko/cart/update_qty {ca_idx, ca_id, number1}`

### UX 규약 (화면 토스트)
> **"편집하신 포토북 제품이 자동으로 장바구니에 저장됐습니다. 재편집을 원하시는 경우 장바구니에서 하시기 바랍니다."**

→ 포토북은 **편집 완료 시 자동 장바구니 저장**, **재편집은 장바구니에서만**. 장시간 편집 보호 장치.

---

## 8. 포토북 전용 API [확인됨]

```
POST /ko/product/get_seneca
  bindType=BID_RFL & cover_type=CVR_SFT & paper_cd=RXART300 & paper2_cd=RXDGP285
  & number3=<장수> & pdt_cd=PHBKBKS          → 책등(spine) 두께 계산

POST /ko/product_price/get_ajax_price2_arr    ← 포토북 가격(폼 배열 방식)
  item[]·pcs_cod[]·pcs_dtl_cod[]·attb[]·wrk_wdt[]·wrk_hgh[]·prn_cnt[]·mtrl_cod[]·sid_gbn[]·bind_yn[]
  & page_cnt=<장수>
```
- 판스티커는 `get_ajax_price_vTmpl`(JSON) — **상품군마다 가격 API가 다름**
- 응답에 `PRICE_LOG`·`PRICE_MALL_LOG` — 계산 근거를 사람이 읽는 문장으로 제공
  예: *"인쇄비 : 4410.00, 자재비 : 3280.25, 총금액(100단위 절상) : 7700.00, 제곱미터환산값 : 0.88"*

---

## 9. 상품별 편집기 플래그 (probe 21종, `raw/probe.json`)

| 코드 | 상품 | useKoiEditor | usePDF | 가격구분 |
|---|---|---|---|---|
| PHSTPAN | 판스티커 | Y | N | vTmpl_price |
| PHBKBKS | 소프트커버 | Y | N | digital_price |
| PHBKSMP | 하드커버 이미지랩 | Y | N | digital_price |
| PHBKPRM | 하드커버 프리미엄 | Y | N | digital_price |
| **PHBKMYB** | 내 파일로 만드는 포토북 | **N** | **Y** | digital_price |
| TPTKDFT | 티켓 | Y | Y | digital_price |
| GSSMSTP | 자동스탬프 | Y | Y | tmpl_calc_price |

→ **`useFullyFunctionalUI: true` 인 상품을 아직 하나도 못 찾음** (= passive 실사용 사례 미발견)

---

## 10. Edicus 테마 시스템 [확인됨 · 신규 발견]

전역 스타일시트 `styles.dda665f6ba99a960b3c3.css`(110KB)에 **`theme-*` 클래스 25종** 정의.

```
theme-header-bg #64c2ff · theme-header-border #529fd2 · theme-header-text · theme-header-btn
theme-header-cart-btn #61a5f4 · theme-header-separator #e2e2e2
theme-tab-btn #8c919d · theme-tab-btn.active-tab #64c2ff/#3e4553 · theme-tab-border #323553
theme-tab-wing #262c33 · theme-tab-panel-body #3e4553
theme-panel-border #626b7c · theme-panel-section-header · theme-panel-round-btn
theme-panel-toolbar #525b6c · theme-panel-toolbar-btn
theme-ui-dropdown-item · theme-plugin.m2 (CSS 변수: --normal-color/--thumb-color/--select-color)
theme-cell-empty-icon(63회) · theme-canvas-body · theme-canvas-overmask · theme-ruler-*
```

- 폰트: `"Noto Sans KR", sans-serif` — **후니 DS와 이미 동일**
- Angular 구조: `app-root > editor-main > div.app-main > {div.app-header, div.app-body{left-section>tool-panel, right-section-main>edit-section{canvas-section, storyboard-section}}}`
- **RedPrinting은 `private_css` 를 쓰지 않음** (캡처 전체에 `wait_private_css` 0건) → 베낄 원본 없음
- 후니 매핑 초안: `../edicus-huni-theme.css`

---

## 11. 우리 갭 정리 (우선순위)

| # | 갭 | 크기 | 비고 |
|---|---|---|---|
| **G0** | `run_mode: passive` → `standard` | **한 줄** | 이게 안 되면 아래 대부분이 무의미 |
| G1 | 자동저장 없음 | 옵션 한 줄? | `autoSave: N` 이 우리 SDK에 있는지 확인 필요 |
| G2 | `prjid` 영속화 없음(메모리만) | 작음 | 새로고침 시 편집결과 링크 소실 |
| G3 | 이탈 경고가 업로드 중일 때만 | 작음 | 편집 미저장 상태 미방어 |
| G4 | 선제 토큰 갱신 없음 | 중간 | 벤더 설계는 pull이라 정상. 보험 여부 판단 |
| G5 | `doc_dirty`/`state-history` 미수신 | 작음 | G1의 조건으로 필요 |
| G6 | `can_order` 미호출 | 중간 | **편집기 닫는 순간** 호출이 정답(RedPrinting 실측) |
| G7 | Edicus 주문 API 전체 미구현 | **큼** | tentative/definitive 없음 → 결제해도 인쇄 안 감 |
| G8 | 편집 중 장바구니 항목 잠금 없음 | 작음 | 이중 주문 방지 |
| G9 | `edicusInfo`(docInfo) 미저장 | 중간 | 충실도 판정 재료 |
| G10 | `orgEdicusProjectID` 자리 없음 | 작음 | 재편집·복제 계보 |
| G11 | 책등(`get_seneca`)·페이지수 가격 | 중간 | 책자 상품 필수 |
| G12 | 회원 uid 승격 미구현 | 중간 | 「내 디자인」의 전제 |

---

## 12. 담당자(모션원) 질문 목록

1. **최신 SDK 문서** — 우리 문서(2026-01-06)에 없는 파라미터가 다수. 최신본 요청 ← **1순위**
2. `autoSave: N` 옵션이 우리 버전에 있는가
3. `openFullyFunctionalUI` 메서드 — `create_project`/`open_project` 와의 관계
4. `useFullyFunctionalUI` · `passiveInfo` 상품 플래그를 파트너가 설정 가능한가
5. `disableAllOption` / `exceptDisableElements` 정식 스펙
6. `custom_tab` / `customTabInfo` 를 파트너가 구성 가능한가
7. `clone: true` 동작 — 새 프로젝트 생성 시점
8. `private_css` — 전달 action 이름, 적용 범위, `open_project`에도 되는가
9. `wait_options` / `wait_prod_info` / `wait_ddp` 의 의미
10. standard 모드에서도 `save-doc-report` 에 `isOrderAble` 이 오는가
11. **미주문 프로젝트 보존기간** — `doc_rev` null / 저장됨 두 경우 각각. 기준은 `ctime`인가 `mtime`인가
12. 주문완료 후 "3~4주"의 정확한 값과 기준 시점
13. 과금 단위(주문 건당/렌더 건당/저장용량) · `order_for_test` 제외 여부 · Clone 과금 여부
14. 장기보관 옵션 / 프로젝트 원본 다운로드 수단
