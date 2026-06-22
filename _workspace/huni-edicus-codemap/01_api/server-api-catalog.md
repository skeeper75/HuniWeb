# Edicus Server API — 엔드포인트 계약 카탈로그

권위[HARD]: `docs/edicus.man/docs/Edicus Server API.pdf` (43p, Copyright 2018 모션원). 모든 계약에 `PDF p.N` 근거.
보조 대조: reference 구현(`docs/edicus.man/src/lib/edicus/server-api.ts`·`resource-api.ts`)·`deployment-guide.md`(호스트 역할).

## 0. 공통 사항 (`PDF p.1`)

- **호출 위치[HARD]**: 고객사 **서버에서만** 호출 (Browser 호출 금지). edicus-api-key 노출 방지.
- Response content-type = `application/json`.
- 논리 오류: HTTP 200 + `{ err: { code:String, message:String, info?:Object } }`. 인증오류·서버내부 에러는 status 400~500.
- API 주소:
  - Server/Order API base: `https://api-dot-edicusbase.appspot.com` (`PDF p.3`; env `EDICUS_API_HOST`)
  - Resource API base: `https://resource-dot-edicusbase.appspot.com` (2017.3.30 변경, `PDF p.36`; env `EDICUS_RESOURCE_HOST`)
  - Font API base: `https://api-dot-edicusbase.appspot.com` (`PDF p.40`)

## 0.1 공통 헤더 (`PDF p.1-2`)

| 헤더 | 설명 |
|------|------|
| `edicus-api-key` | 모션원 발급 키. 외부 유출 금지. (전 API 공통) |
| `edicus-uid` | 고객 특정 unique id. (partner-code 포함) 64byte 이내 hash data id, 50byte 권장. 허용문자 `[a-z, A-Z, 0-9, @, -, _, +, =]`. `:` `/` `\` 금지 |
| `edicus-id-token` | (Edicus 내부 전용) admin/staff 이상 권한 토큰 |
| `edicus-target-uid` | (optional) clone 시 복제 대상 user id |

## 0.2 Token (`PDF p.2`)

- 고객사 unique user id 기반 JWT. 유효시간 1시간. 이 토큰으로 edicus web page에서 해당 고객 인증.

---

# A. Auth / Token

## A1. Request User Token (By uid) (`PDF p.2-3`)

- 설명[중요]: 절대 브라우저에서 호출 금지. 서버에서 토큰을 얻어 브라우저엔 결과 token만 전달. edicus-uid가 사용된 적 없으면 즉시 생성됨.
- `POST /api/auth/token`
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `{ token: <string> }`
- Note: edicus-uid는 고객사 각 사용자에게 1:1 대응되는 unique id.

## A2. Request User Token (Edicus 내부용) (`PDF p.3`)

- `GET /api/auth/user/token`
- Headers: `edicus-uid`, `edicus-id-token`(internal only; admin/staff 이상)
- Response: `{ token: <string> }`

## A3. Request Staff's Token (By email and password) (`PDF p.3-4`)

- 설명: edicus manager 등록 사용자 email/password 로그인용. 이 계정 로그인 시 editor에서 resource 업데이트 가능. 받은 custom token은 role 포함.
- `POST /api/auth/staff/token`
- Headers: `edicus-api-key`, `edicus-email`, `edicus-pwd`, (internal) `edicus-id-token`
- Response: `{ token: <string> }`
- 참조 구현: `EDICUS_API_HOST/api/auth/staff/token` (`src/app/api/edicus/auth/staff/route.ts`).

---

# B. Project

## B1. Get Project Data (`PDF p.4-5`)

- `GET /api/projects/:prjid`
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `{ project_id, order_id?(주문된 경우만), ctime, mtime, ps_code, status, template_uri, title, cloned_from?(복제 프로젝트만) }`

## B2. Get Project List (`PDF p.4-5`)

- `GET /api/projects`
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `[ { project_id, ctime, mtime, ps_code, template_uri, title, status } ]`
- Note: status `editing`=편집중, `ordered`=주문됨. 주문된 상품은 편집기로 안 띄우도록 주의.

## B3. Get owner-id by project-id (`PDF p.5-6`)

- `GET /api/projects/:prjid/owner`
- Headers: `edicus-api-key`
- Response: `{ owner: <string> | null }` (못 찾으면 null)

## B4. Get Project Preview Thumbnail Url List (`PDF p.6`)

- (2018.1.2 이후 신규/저장 상품에 제공)
- `GET /api/projects/:prjid/preview_urls`
- Headers: `edicus-api-key`
- Response: `{ urls: [ "https://...", ... ] }` (각 항목=jpg link, 갯수는 상품따라 다름)

## B5. Get Project Preview Thumbnail Url List with multiple project-id's (`PDF p.6-7`)

- `POST /api/projects/preview_urls`
- Headers: `edicus-api-key`
- Body: `{ project-ids: ["ifheoxief", ...] }` (최대 25개)
- Response: `{ urls: [ { project_id, urls:[...] }, ... ] }`
- Error: 없는 prjid/preview url 없으면 항목에 `error:"no preview urls"`; 한도 초과 시 `{ err:{ code:"project-ids limit excess", message:"can request up to 25" } }`

## B6. Create Project (v2) — **사용불가** (`PDF p.7`)

- `PUSH /api/projects/:prjid` (문서상 "PUSH" 표기; **사용불가** 명시)
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `{}`

## B7. Get Project Data (v2) — **사용불가** (`PDF p.7-8`)

- `GET /api/projects/:prjid/data?doc=[true|false]` (doc=true일 때만 doc json 포함)
- Headers: `edicus-api-key`, `edicus-id-token`(browser), `edicus-uid`
- Response: `{ doc_json, project:{ project_id, order_id, ctime, mtime, ps_code, status, template_uri, title } }`

## B8. Delete Project (`PDF p.8`)

- `DELETE /api/projects/:prjid`
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `{}`
- Note: 주문된 상품은 삭제 불가. 주문완료 상품은 일정기간(3~4주) 후 자동 삭제.

## B9. Clone Project SYNC (동기) (`PDF p.8-9`)

- `POST /api/projects/:prjid/clone`
- Headers: `edicus-api-key`, `edicus-uid`, `edicus-target-uid`(optional; 지정 시 해당 user에 복제)
- Response: `{ project_id: "<복제된 프로젝트 id>" }`
- Note: 복제본 title에 "(복제됨)" 추가. 포토북처럼 이미지 많으면 timeout 가능 → Clone Async 사용.

## B10. Clone Project ASYNC (비동기) (`PDF p.9-10`)

- `POST /api/projects/:prjid/clone_async`
- Headers: `edicus-api-key`, `edicus-uid`, `edicus-target-uid`(optional)
- Body(optional): `{ callback_url:"https://..." }` (POST로 호출됨)
- Response: `{ project_id: "..." }` (즉시 반환; 서버는 복제 중, status `cloning`→완료 `editing`. 완료 시 callback_url 호출)
- Note: status `cloning`인 프로젝트를 open하면 편집기 실패. status는 Get Project Data로 확인.

---

# C. Order

## C1. Can Order (`PDF p.10`)

- `GET /api/projects/:prjid/order/can_order`
- Headers: `edicus-api-key`
- Response: `{ can_order:<boolean>(false면 주문 불가), dec_rev:<number>, status:<string>("editing"|"ordering"|"ordered"|"rendering"|"rendered") }`

## C2. Tentative Order (`PDF p.10-12`)

- 설명: **취소 가능**한 주문. 렌더링 안 됨. 이후 Definitive Order 호출 시 렌더링 가능·취소불가.
- `POST /api/projects/:prjid/order/tentative`
- Headers: `edicus-api-key`, `edicus-uid`
- Body(json):

| Key | Type | 설명 |
|-----|------|------|
| `order_for_test` | boolean | 테스트 주문 여부 (true면 render-target=development 상태에서만 렌더링) |
| `order_count` | number | 주문수량 |
| `total_price` | number | 실 결제 금액 |
| `partner_order_id` | string [optional] | 파트너사 주문 번호 |
| `order_name` | string [optional] | 주문자 이름 (45자 이내) |
| `userdata_json` | string [optional] | 사용자 데이터 json (1000자 이내; `{ user_name, receiver_name, order_name, production_count, title }`) |
| `vdp_dataset` | json string [optional] | (vdp 포함 시 Tentative Order with vdp_dataset 사용 권장) |

- Response: `{ order_id:100023(Number), status:'ordering' }`
- Error: 편집가능 상태 아닐 때/이미 주문된 경우/projectId 오류 → `{ err:{ message:"..." } }`
- Note[HARD]: Response의 order_id는 고객사 db에 기록되어야 함.

## C3. Tentative Order with vdp_dataset (`PDF p.12-13`)

- `POST /api/projects/:prjid/order/tentative_with_vdp`
- Headers: `edicus-api-key`, `edicus-uid` (Tentative Order와 동일)
- Body: Tentative Order Body + `vdp_dataset`(Object[optional]) 또는 `vdp_dataset_file`(File/Blob[optional], json format).
  - 중요1: `vdp_dataset_file`(File/Blob, json string) 사용 시 Content-Type `multipart/form-data`.
  - 중요2: `vdp_dataset`만(파일 없이) json string 직접 전송 시 크기 제한 있음; 대량은 vdp_dataset_file, Content-Type `application/json`.
- vdp_dataset 구조: `{ rows:[ { cols:[ { id, value(또는 {segment,value:{text},shrink}) } ] } ] }`. 서버 전달 시 stringify.

## C4. Definitive Order (`PDF p.13`)

- 설명: 주문 확정, 렌더링 가능 상태·**취소 불가**. 반드시 Tentative Order 이후 호출.
- `POST /api/projects/:prjid/order/definitive`
- Headers: `edicus-api-key`, `edicus-uid`
- Body(json): (본문 비어있음)
- Response: `{ order_id:100023(Number), status:'ordered' }`
- Error: http 200 + `{ err:{ ... } }`
- Note[HARD]: order_id는 고객사 db에 기록되어야 함.

## C5. Cancel Order (`PDF p.13`)

- 설명: 주문취소. tentative order 상태에서만 가능. definitive order 상태에서는 취소 불가.
- `POST /api/orders/:order_id/cancel`
- Headers: `edicus-api-key`, `edicus-uid`
- Response: `{ order_id:"10021", status:"canceled" }`

## C6. Reset Rendering Status as Ordered (`PDF p.13-14`)

- 설명: 렌더링 상태를 "ordered"로 변경 (Edicus-manager 주문확인 탭 rerender 기능과 동일; 렌더 실패 시 재시도용).
- `PUT /api/orders/:order_id/status/reset_as_ordered`
- Headers: `edicus-api-key`

## C7. Query Order (Edicus 내부용) (`PDF p.14-16`)

- `POST /api/order/query`
- Headers: `edicus-api-key`
- Body(json) 케이스: `by_time`(from/to/status?·partner_order_id?·order_name?), `by_order_id`({order_id}), `by_project_id`({project_id}), `by_partner_order_id`({partner_order_id}).
- Response: `{ result:[ { id, partner_id, user_id, project_id, order_count, total_price, status, ctime } ] }`

## C8. Request for Render (Edicus 내부용) (`PDF p.16-17`)

- 설명: 렌더링 가능한 상태로 변경.
- `POST /api/order/request_for_render`
- Headers: `edicus-api-key`
- Body(json): `{ prepress_id, last_requested_order_id, prod_codes:["MB","NC"] }`
- Response: `{ result:[ { id, partner_id, user_id, project_id, order_count, total_price, status, ctime, prod_code, size_code, partner_order_id, order_name, render_session } ] }`

## C9. Change Rendering Status (Edicus 내부용) (`PDF p.17`)

- `PUT /api/orders/:order_id/status/as/:status` (:status = "render-fail" | "rendered" | "ordered")
- Headers: `edicus-api-key`
- Body(json): `{ prepress_id }`

---

# D. Resource API (base: `EDICUS_RESOURCE_HOST`) (`PDF p.17~30`)

공통: 서버 전용 호출·Response JSON·`edicus-api-key` 헤더.

## D1. Get Product List (`PDF p.18-22`)

- `GET /resapi/product/list`
- Headers: `edicus-api-key`
- Response: `{ prodCates: Array<Category>, products: Array<Product> }`
  - `Category { cateCode, dpName }`
  - `Product { prodCode, dpName, cateCode, editor("template"|"print"), template_option:TemplateProductOption, print_option:PrintProductOption, userData, sizes:Array<ProductSize> }`
  - `ProductSize { sizeCode, dpName, refDPI, lowDPI, editorMargin_mm, pageInfos:Array<ProductPageInfo>, printInfo:ProductPrintInfo }`
  - (TemplateProductOption/PrintProductOption/ProductPageInfo/ProductPrintInfo 세부 필드는 `PDF p.19-21`에 TS interface로 명세)
- 참조 구현: `EDICUS_RESOURCE_HOST/resapi/product/list`.

## D2. Get Product (`PDF p.21-22`)

- `GET /resapi/product/:prod_code`
- Headers: `edicus-api-key`
- Response: `{ product: Object }` (내용은 Get Product List의 Product와 동일)

## D3. Set Product Userdata (`PDF p.22`)

- `GET /resapi/product/userdata/:product_id` (문서상 verb "GET" 표기)
- Headers: `edicus-api-key`
- Request: `{ userdata: string }`
- Response: `{}`

## D4. Issue Resource Token (`PDF p.22`)

- 설명: Template을 identify하기 위한 Token 발행. 템플릿 최초 등록 시 얻고 이후 업데이트에 계속 사용.
- `GET /resapi/token`
- Headers: `edicus-api-key`
- Response: `{ token: string }` (값을 그대로 token.jwt로 저장)

## D5. Upload Template Package (`PDF p.22-25`)

- 설명: 템플릿+모든 리소스 파일 등록. Multipart Form Data로 한번에 전송. 전체 32Mb 초과 시 "Entry too large" → "Get Template Package Upload URL" 사용.
- `POST /resapi/package`
- Headers: `edicus-api-key`, `download-json`(optional, default false; true면 response에 doc 추가)
- Request(Form Data): `token`(token.jwt), `doc`(template.json=Indesign Exported JSON), `meta`(metadata.json), `dp`(template-dp.png + layout-dp-n.png), `res`(res-file: SVG/PNG/JPG, 파일명=page-item-id).
  - metadata.json 필드: `template_type`(default mot1-indd-json), `partner_code`(default mot1), `ps_codes`, `tags`, `generate_layout`(default false), `cell_movable`(false), `sticker_movable`(false), `sticker_selectable`(true), `post_layers`.
- Response: `{ template_uri, template_dp_url, layout_uris:Array<string>, res_uris:Array<string>, doc?(string), unregistered_fonts_found:[{ familyName, typeStyle }] }`
- Error: "entry too large" → Get Template Package Upload URL 사용. unregistered_fonts_found/unresolved_font_group_ids 항목 array length>0면 폰트 문제.
- Note: 얻은 `template_uri`를 edicus editor 입력으로 사용.

## D6. Get Template Package Upload URL (`PDF p.25-26`)

- 설명: 대용량(32mb 이상) 패키지 업로드용 URL 생성(10분 유효).
- `GET /resapi/pkg-upload-url`
- Headers: `Content-Type: application/json`, `edicus-api-key`
- Response: `{ upload_url:"https://...", filename:"SyGN0Dge3D.zip" }`
- Note: upload_url에 zip을 `PUT` 업로드 (Header `Content-Type: application/x-zip-compressed`). 완료 후 `/resapi/pkg-uploaded`로 알림.

## D7. Template Package Uploaded (`PDF p.26-27`)

- 설명: 업로드 URL로 파일 업로드 완료를 Edicus resource server에 알리고 등록 완료.
- `POST /resapi/pkg-uploaded`
- Headers: `edicus-api-key`, `filename`(Get Template Package Upload URL의 filename 그대로)
- Response: Upload Template Package(D5)의 response와 동일.
- Note: 이 API까지 성공해야 템플릿 업로드 성공.

## D8. Preview Template (`PDF p.27-28`)

- 설명: 인디자인 템플릿을 edicus-doc으로 변환하고 preview용 svg 파일 받기.
- `POST /resapi/preview`
- Headers: `edicus-api-key`
- Request(Multipart Form Data): `meta`(file, metadata.json), `doc`(file, template.json), `dir`(string, template.json 로컬 절대 폴더), `dpi`(string, default 300), `bound_mode`(string, default show; show/cut/none).
- Response: `{ pageInfos:[{ svg:string, layers:[{ type, svg }] }], unregistered_fonts_found:["fontFamily/fontStyle"], unresolved_font_group_ids:["default-host-ja"] }`
- Note: svg 내부 이미지들은 로컬 절대 패쓰 xlink.

## D9. Query Resource (`PDF p.28-29`)

- `POST /resapi/query`
- Headers: `edicus-api-key`
- Request: `{ option:{ type, visibilities:[...], order, limit, tags:[], psCodes:[] } }`
  - `type`: template/layout/background/sticker/deco/mask/guide/token
  - `visibilities`: private/public/deleted array
  - `order`: asc/desc (default asc), `limit`: number (default 0=무제한), `tags`/`psCodes`: string array
- Response: `{ items:[Resource] }` — `Resource { id, type, visibility, deletedTime, psCodes, dpUri, dpWidth, dpHeight, resUri, resWidth, resHeight, valueUri, pageType, itemCount, userData, userDataGen, tags }`

## D10. Query Resource Count (`PDF p.29`)

- `POST /resapi/query/count`
- Headers: `edicus-api-key`
- Request/Response: Query Resource(D9)와 동일.

## D11. Get User Resource Urls (`PDF p.30`)

- 설명: 프로젝트에 사용된 사용자 이미지 리스트.
- `POST /manapi/project/get_user_rsc_urls`
- Headers: `edicus-api-key`
- Request: `{ user_id, project_id, size_tag('org'(default)/'edit'/'tnl'/'tn' = org,900,256,128), limit(default 0) }`
- Response: Query Resource API와 동일.

---

# E. Font API (base: `https://api-dot-edicusbase.appspot.com`) (`PDF p.30~43`)

공통: 서버 전용 호출·Response JSON·`edicus-api-key` 헤더.

## E1. Get Font Group List (`PDF p.41`)

- 설명: 등록된 모든 font-group-id 리스트.
- `GET /api/font/group_id_list`
- Headers: `edicus-api-key`
- Response: `{ list:[ "banner-basefont", "banner-host-ko", "default-basefont", "default-host-ja", "default-host-ko" ] }`

## E2. Get Font List by Font-Group-ID (`PDF p.41-42`)

- 설명: font-group-id로 폰트 리스트.
- `GET /api/font/:font-group-id/list`
- Headers: `edicus-api-key`
- Response: `{ font_group_id, list:[ { key, family, style, byteLength, issue, url } ] }`

---

## 미상 / 정직 표기

- Auth API(A2/A3) 등 일부 API의 Error 본문 구조: 표가 비어 **모름(PDF 미기재)** (공통 err 포맷 적용 추정).
- Resource/Font API 공통 "오류시 Response"는 PDF에 `{ TDB... }`로 미정의 (`PDF p.36, p.40`) → **모름(PDF 미기재)**.
- B6/B7(Create/Get Project v2)은 PDF에 **"사용불가"** 명시.
- D3 Set Product Userdata의 verb는 PDF에 "GET"으로 표기되나 Request body가 있어 표기 불일치 가능 — PDF 표기 그대로 기록.
