# M1 — 원고 경로 (artwork-flow) : 파일 업로드 · Edicus 편집

> 「어떤 파일을, 어떤 검사를 거쳐, 어디에 두는가. 언제 무엇이 막히는가.」
> 「편집 버튼 → 무엇이 열리고 → 무엇이 돌아오는가 → 그것이 주문에 어떻게 실리는가.」

---

## 0. 두 경로는 「원고」라는 한 요건의 두 방식

| | 파일 업로드 | 편집기(Edicus) |
|---|---|---|
| 컴포넌트 | `WGT_SRC_TYPE.09` (라이브 배치 **427건**) | `WGT_SRC_TYPE.10` (라이브 배치 **212건**) |
| 전제조건 | 상품 `파일업로드지원여부(file_upload_yn)=Y` | 상품 `편집기지원여부(editor_yn)=Y` |
| 산출물 | S3 오브젝트 키 | Edicus 프로젝트 ID(`prjid`) |
| payload 위치 | `payload.files[]` | `payload.editors[]` |
| 좌표계 | **동일** — `{item, mbr, inst}` | **동일** |

> [HARD] **한 위젯에 둘 다 배치하면 「둘 중 하나」만 하면 충족된다.**
> 미충족 문구: `"원고 업로드 또는 편집기로 만들기"` (라이브 실측 확인, 핀버튼 WGT_000005)

---

## 1. 파일 업로드 경로

### 1.1 흐름 — 파일은 후니 서버를 지나가지 않는다

```
고객 브라우저
   │ ① POST /api/w/v1/upload/presign   { site_key, wgt_cd, files:[{item,mbr,inst,name,size,ext}] }
   ▼
후니 서버  ──▶ presigned PUT URL 발급 (권한만 내줌)   ※ 한 번에 최대 20개
   │ ② { uploads:[{item,name,key,url,headers,expires_in:600}] }
   ▼
고객 브라우저 ── ③ PUT (직접) ──▶  S3 임시(tmp) 버킷
                                      │ 30일 수명주기
   │ ④ handoff 시 payload.files[] 에 { item, mbr, inst, key, name } 로 실림
   ▼
POST /order/register ── ⑤ 승격(server-side copy) ──▶ S3 주문(order) 버킷
                                                      └▶ t_ord_artworks.ord_key
```

- **100MB 초과는 멀티파트로 자동 전환**: `POST /api/w/v1/upload/multipart/{action}` — `create` → `sign` → `complete`/`abort`
- ⚠ **`create` 후 `complete`/`abort` 없이 방치된 조각은 보이지 않게 과금된다.** 위젯은 자동으로 `abort` 를 부른다.
- 상품이 판매중지로 바뀌면 `create`·`sign` 은 거절되지만 **`complete`·`abort` 는 받아준다**(올린 조각 정리용).

### 1.2 무엇이 허용되나 — 위젯 컴포넌트 속성

| 속성 | 기본 | 상한 | payload/오류 |
|---|---|---|---|
| 허용 형식 | PDF / 이미지(JPG·PNG·TIF) / AI·EPS | 전부 해제 시 **PDF만** | `bad_file_type` |
| 여러 파일 | 끔 | — | — |
| 최대 개수 | 비우면 10 | **50** | `bad_file_count` (`props.max_files`) |
| 파일당 최대 용량 | **500MB** | **2048MB(2GB)** | `bad_file_size` (`props.max_mb`) |
| 안내문구 | 「파일을 끌어다 놓거나 클릭해 업로드」 | — | — |
| **원고 필수** | **켬(기본)** | — | `artwork_required` / `artwork_not_uploaded` |

> [HARD] **브라우저 검사는 안내용이고 최종 차단은 업로드 API 가 다시 한다** (매뉴얼 컴포넌트 「파일 업로드」).
> 라이브 실화면 확인: 무선책자 위젯 드롭존 아래 「PDF · 파일당 최대 500MB」 표시.

### 1.3 언제 무엇이 막히나 — 검증 3층

| 층 | 시점 | 무엇을 보나 | 실패 코드 |
|---|---|---|---|
| ① 브라우저 | 파일 고를 때 | 확장자·용량·개수 (안내용) | — |
| ② presign API | URL 발급 시 | 형식·용량·개수 + 상품 판매상태 | `bad_file_type`·`bad_file_size`·`bad_file_count`·`no_files`·`too_many_files`·`upload_not_configured`(503) |
| ③ **handoff** | 주문 직전 | **원고 필수 충족** + **S3 키 모양** | `artwork_required`·`artwork_not_uploaded`·`bad_files` |

**③의 S3 키 모양 검증** (코드 `widget_api.py:3242`, `S3.key_belongs(key, site_cd, wgt_cd)`):
- ① `key` 없음 = 「브라우저가 파일을 고르기만 하고 올리지 않은 상태」 → 원고 없는 주문 차단
- ② 남의 `key` = 다른 사이트/위젯의 원고를 자기 주문에 붙이는 시도 → **접두로 차단**
- ⚠ **오브젝트가 실제로 존재한다는 증명은 아니다** — 발급 이력 미저장, `head_object` 미호출.
  「위조 키는 승격 시점에 부재로 시끄럽게 실패한다 — 실측 존재/크기 대조는 **승격 워커 몫**」
- S3 미설정(개발 환경)이면 이 검사를 하지 않는다.

**`bad_files` 가 나는 조건** (SDK 가이드 §15): 「이 위젯 항목 소속이 아니거나, **구성원(`mbr`) 정보가 항목과 다르거나**, **벌(`inst`) 번호가 구성 범위를 벗어남**」

### 1.4 승격 (tmp → order 버킷) — **MES 가 쓸 키가 여기서 생긴다**

`models.py:1081` `TOrdArtworks` docstring:
> 「주문 등록이 받은 서명 payload 의 원고 키는 **임시 버킷** 키다(30일 시한부). 주문이 등록되는 즉시 주문 버킷으로 복사(승격)하고 그 결과를 여기 남긴다 —
> **MES 에 넘길 키 목록의 출처가 이 표다**(payload 의 키로는 MES 가 가져갈 수 없다).」

| 특성 | 내용 |
|---|---|
| 실행 시점 | `POST /order/register` **요청 안에서 동기 실행** (`widget_api.py:4041` `_promote_artwork`) |
| 왜 워커가 아닌가 | 「**크론·워커 인프라가 없다**」 — S3 서버사이드 복사라 파일이 서버를 지나가지 않음 |
| 시간 예산 | 초과분은 다음 호출로 이월 (`AP.sweep_pending()`, **5분 스로틀**) |
| 응답 반영 | **안 함** — 「쇼핑몰은 이미 결제된 주문을 되돌릴 수 없고, 파일 문제를 고객에게 알리는 것은 우리 몫」 |
| 실패 시 | 「승격 모듈이 주문을 **보류(HOLD)** 로 세우고 사유를 남긴다」 |
| 크기 검증 | `decl_size`(서명 신고값) vs `file_size`(**head_object 실측**) — 「**승격이 크기가 처음 강제되는 지점**」 |
| 상태값 | `PENDING` · `PROMOTED` · `FAILED` — 「**파일 검사 단계가 붙으면 값이 늘어난다**」 ← 프리플라이트 미구현 신호 |
| 멱등 | 「이미 승격된 파일은 건너뛰므로 중복 복사가 되지 않는다」 |

**라이브 실측**: `t_ord_artworks` **0행** — 승격이 라이브에서 한 번도 실행된 적 없음.

### 1.5 30일 수명주기 — 연쇄 제약

- 결제 전 원고는 **임시 저장소 30일**. 규칙 목적 자체가 「장바구니만 담고 안 산 원고 정리」.
- 그래서 **항목 보관소(`t_wgt_cart_items`) 도 30일**, 기준점은 **최초로 담은 시각**(재견적해도 연장 안 됨).
- **가상계좌 입금기한 3~7일 권장** — 그보다 길면 입금 전에 원고가 사라진다.
- ⚠ **알려진 구멍**: 「갱신은 원고 존재를 확인하지 않는다. 30일 이내라면 갱신은 통과하지만, 그 사이 원고가 삭제되었다면 **주문은 뒤 단계에서 실패**한다」 (SDK 가이드 §9-07-②) — 후니 후속 작업으로 검토 중.

---

## 2. 편집기(Edicus) 경로

### 2.1 흐름 — 「편집 버튼을 누르면 무엇이 열리는가」

```
고객이 사이즈·옵션을 고른다
   │
   ▼ 🎨 편집기 버튼 클릭
위젯이 `huni:editor` 이벤트 발화 { item, mbr, product, widgetId }
   │  ├─ 호스트가 preventDefault() 하면 → 호스트 자체 편집기 (§2.5)
   │  └─ 취소 안 하면(기본) → 위젯이 전부 처리:
   │
   ├─① POST /api/w/v1/editor/resolve  { site_key, wgt_cd, selections{}, sel_opts[] }
   │      → { ps_cd:"SIZ_000012@PRD_000016", tmpl_uri:"https://…/template.psd" }
   │      ※ 조합→템플릿 매핑은 관리자가 상품별로 등록. 클라이언트는 어떤 매핑도 추론하지 않는다
   │
   ├─② POST /api/w/v1/editor/token    { site_key, wgt_cd, guest_id }
   │      → { token(1시간), partner:"huni", uid:"mo-…", expires_in:3600 }
   │      ※ 편집기 비밀 API 키는 서버 밖으로 나가지 않는다
   │
   ├─③ 전체화면 오버레이 오픈 — 편집기가 **패시브 모드**로 표시
   │      편집기 내부 툴바 대신 오버레이 상단바(저장 / 저장 후 닫기 / 닫기)가 조작 담당
   │
   └─④ 고객이 저장 → prjid 가 위젯에 기록 → payload.editors[] 에 자동 탑재
```

- 같은 항목을 다시 누르면 **이어 편집**. 단, **사이에 규격이 바뀌었으면 새 디자인으로 시작.**
- `guest_id` = 비로그인 고객을 구분하는 안정적 식별자. 위젯이 **localStorage** 에 보관. 형식 `[A-Za-z0-9-]` 8~64자 (`bad_guest_id`).

### 2.2 조건에 따라 다른 템플릿이 열린다 — **느슨한 매칭 금지**

> SDK 가이드 §8: 「등록되지 않은 조합에서는 편집기가 열리지 않습니다(`no_editor_mapping`). **필수 옵션을 아직 고르지 않은 상태도 마찬가지**입니다. 이는 **의도된 안전장치**입니다 — 조합에 맞지 않는 규격으로 고객이 원고를 만들어 버리는 사고를 막기 위해 **느슨하게 근접 매칭하지 않고 차단**합니다.」

**매핑 등록 화면**: 운영자 매뉴얼 「상품 › 상품별 Edicus 템플릿 연결」 (`/admin/edicus-template-md/`)
- ① 사용차원 칩 선택 → ② 「조합 생성/갱신」 → ③ 조합마다 **PSCode + URI 둘 다** 입력 → 저장
- 엑셀 복사·붙여넣기 가능

### 2.3 주문에 실리는 결과

```json
"editors": [
  { "item":"WGTI_000123", "mbr":null, "inst":1,
    "result": { "prjid":"-KzvOwkOBG3ym3G9Mp6i",
                "ps_cd":"124x186@HU_14545",
                "saved_at":"2026-08-15T07:21:40.512Z" } }
]
```
- [HARD] **`prjid` 를 주문 레코드에 반드시 저장** — 「**인쇄용 데이터를 뽑을 때 쓰는 열쇠**」
- `payload.edicus_uid` = 편집기 원고의 주인. 「**결제 후 Edicus 주문 API 의 필수 헤더**」 (`widget_api.py:2964`)
  → `t_ord_orders.payload` 가 payload 를 통째로 저장하므로 주문 기록까지 따라간다.
- **저장 없이 주문하면** `artwork_not_uploaded` 422.
- **빈 원고 방지**: `artwork_empty` 422 — 「편집기로 만든 원고가 **비어 있음**(사진칸이 하나도 채워지지 않음). 파일 업로드 안내가 아니라 **편집기를 다시 열어 내용을 넣고 저장**하라고 안내해야 합니다. 저장은 됐지만 내용이 없는 상태라 그대로 주문하면 **빈 인쇄물이 나갑니다**」

### 2.4 디자인(고정 사양 묶음) — 포토북형 상품

운영자 매뉴얼 「상품 › 상품별 디자인」 + SDK 가이드 `GET /designs`:

```json
{ "dsn_cd":"DSN_000001", "dsn_nm":"봄나들이",
  "thumb_url":"…", "tags":["여행","심플"],
  "fixed_specs":[ {"mbr":null,"field":"siz_cd","value":"SIZ_000250"},
                  {"mbr":"PRD_000101","field":"pages","value":24} ],
  "disp_seq":1, "start_price":{"amt":32000,"qty":1,"src":"auto"} }
```

- 고객 흐름: 상품 목록 → (`design_cnt ≥ 1`) **디자인 고르기 페이지** → 주문 화면(고정 사양 잠김 + 안내 배너) → 편집기가 그 디자인 템플릿으로 열림
- **서버도 주문 때 같은 값을 다시 검사** → `design_spec_mismatch` 422 (위조 방지)
- 「**URI 가 디자인의 정체**」 — 같은 사이즈의 디자인끼리 PSCode 가 같은 것은 정상
- 오류: `bad_design`(삭제·타상품) · `design_spec_mismatch`
- ⚠ **라이브 카탈로그 게시 위젯 전부 `design_cnt = 0`** (실측) — 디자인 경로는 아직 라이브에 없다.

### 2.5 호스트가 편집기를 가로채는 경우

```js
el.addEventListener("huni:editor", (e) => {
  e.preventDefault();                    // 기본 오버레이 취소
  const { item, mbr, product } = e.detail;
  openMyOwnEditor(product).then(r => el.setEditorResult(item, { prjid: r.id }));
});
```
> [HARD] 가로챘으면 **`setEditorResult` 를 반드시 불러야** 주문에 실린다. 안 부르면 원고 미충족으로 막힌다.

### 2.6 오버레이 스타일 토큰

`--hw-editor-z`(기본 2147483000) · `--hw-editor-bg` · `--hw-editor-bar-bg` · `--hw-editor-title-c`
(드롭다운 패널은 `--hw-dd-panel-z` = 2147482999 — **편집기 바로 아래**로 독립 상수)

---

## 3. 원고 관련 오류 코드 전수 (SDK 가이드 §15)

| 코드 | HTTP | 언제 | 고객 안내 |
|---|---|---|---|
| `artwork_required` | 422 | 필수 원고가 **아예 없음**(파일도 편집기 결과도 없음) | 원고를 올리거나 편집기로 만들어 달라 |
| `artwork_not_uploaded` | 422 | 필수 원고 **미업로드** 상태로 주문 시도 | 다시 올려 달라 |
| `artwork_empty` | 422 | 편집기 원고가 **비어 있음** | **편집기를 다시 열어 내용을 넣고 저장** |
| `bad_files` | 422 | 파일 목록이 위젯 구성과 불일치(`item`/`mbr`/`inst`) | 다시 담아 달라 |
| `bad_file_type` | 422 | 허용하지 않는 확장자 | 형식 안내 |
| `bad_file_size` | 422 | 용량 상한 초과 (`props.max_mb`) | 용량 안내 |
| `bad_file_count` | 422 | 개수 상한 초과 (`props.max_files`) | 개수 안내 |
| `bad_editors` | 422 | 편집기 결과가 위젯 구성과 불일치 | 다시 담아 달라 |
| `no_files` / `too_many_files` | 422 | presign 요청이 비었거나 20개 초과 | 개발 오류 |
| `presign_failed` | **502** | S3 서명 실패 | 잠시 후 같은 요청 재시도 |
| `complete_failed` | **502** | 분할 업로드 완료 실패(조각 누락·손상) | **처음부터 다시 올려야 함** |
| `upload_not_configured` | **503** | 업로드 스토리지 미설정(후니 측) | 담당자 문의 |
| `editor_not_enabled` | 422 | 편집기 미지원 상품에 편집기 API 호출 | 개발 오류 |
| `no_editor_mapping` | 422 | **이 옵션 조합에 연결된 템플릿 없음** (조합 미등록 또는 필수 옵션 미선택) | 담당자에게 조합 등록 요청 |
| `editor_not_configured` | 422 | 편집기 연동 설정 미완(후니 측) | 담당자 문의 |
| `editor_token_failed` | 422 | 편집기 토큰 발급 실패(외부 응답 오류) | 잠시 후 재시도 |
| `bad_guest_id` | 422 | `guest_id` 형식 위반 | 개발 오류 |

---

## 4. ★ 프리플라이트(접수 전 PDF 검사) — 현재 상태

**M1 관측 결과: 코드에 구현된 흔적이 없다.** 근거 3가지:

1. **코드 주석이 범위를 명시적으로 뺀다** (`widget_api.py:4005`):
   > 「이번 범위는 **기록까지**다. 원고 승격·**프리플라이트**·MES 접수는 각각 **별도 플랜**」
2. **`art_sts` 값 도메인이 3개뿐** (`models.py:1094`):
   > 「`PENDING` · `PROMOTED` · `FAILED`. **파일 검사 단계가 붙으면 값이 늘어난다**」
3. **파일 검증은 「모양」까지만** — `S3.key_belongs()` 접두 검사, `head_object` 미호출. 크기 실측은 승격 시점.

**단, 설계 문서는 존재한다** (`raw/webadmin/docs/`):

| 문서 | 성격 |
|---|---|
| `artwork-scan-integration.md` | 원고 검사 **통합 설계** |
| `artwork-scan-engine-review.md` | 검사 **엔진 검토** |
| `artwork-scan-clamav-vs-eset.md` / `.pdf` | 엔진 비교(ClamAV vs ESET) — **바이러스 검사 관점** |
| `artwork-external-file-guide.md` | 외부 파일 가이드 |
| `aws-architecture-huni.md` / `.pdf` | 인프라 (M3 카드가 지목한 PDF 의 **md 판본이 webadmin 안에 있다**) |

> ⚠ 문서명이 「scan」인 점에 주의 — **바이러스 스캔**과 **인쇄 적합성 프리플라이트**(재단선·블리드·해상도·폰트·색상·페이지수)는 다른 것이다.
> **M1 은 두 문서를 읽지 않았다.** 프리플라이트 구현/미구현 **확정은 M3 의 몫**이다.

**SDK 가이드는 프리플라이트를 후니 책임으로 선언한다** (§10 담당 경계):
> 「파일 오류 검사 · 고객 재업로드 안내 — **후니**」 · 「✕ 파일 오류 검사와 고객 재업로드 안내: **인쇄 적합성 검사**, 재업로드 요청 알림, 재업로드 화면 전부 저희 몫입니다.」

→ **계약상 약속돼 있으나 코드에 없다.** 런웨이 항목으로 세워야 한다.

---

## 5. 미확인

1. **S3 버킷 구성 실물** — 임시/주문 버킷 이름·리전·수명주기 정책의 실제 설정값 미확인(`s3_artwork.py` 미독).
2. **`artwork_promote.py` 의 승격 로직 상세** — 시간 예산·재시도·HOLD 전이 조건 미독.
3. **Edicus 프로젝트 보존 기간** — SDK 가이드가 「후니가 Edicus 담당자에게 **확인 중**」이라고 명시. 미해결.
4. **Edicus 계약·연동 설정 상태** — `editor_not_configured` 가 나는지 여부를 실호출로 확인하지 않았다(외부 SaaS 호출 발생 우려).
5. **프리플라이트 설계 문서 3종의 내용** — 미독(M3 영역).
6. **실제 업로드 동작** — presign 호출·S3 PUT 을 수행하지 않았다(읽기전용 원칙).
7. **`payload.files[]` 실물** — 라이브 주문 0건이라 실제 형태 미관측.

---

## 6. M3 인계 요약

| 무엇 | 어디서 읽나 | 주의 |
|---|---|---|
| 업로드 원고 실파일 | `t_ord_artworks` where `art_sts='PROMOTED'` → **`ord_key`** | `payload.files[].key` 는 tmp 키라 **못 쓴다** |
| 편집기 원고 | `payload.editors[].result.prjid` + `payload.edicus_uid` | Edicus 주문 API 헤더 필수 |
| 원고 좌표 | `item_cd` · `mbr_prd_cd` · `inst_no` | payload 와 동일 좌표계 |
| 파일 크기 검증 | `decl_size` vs `file_size` | 불일치는 승격 단계 신호 |
| 승격 실패 | `art_sts='FAILED'` + `fail_rsn`, 주문은 **HOLD** | 사람 개입 지점 |
| 프리플라이트 | **없음(M1 관측)** → M3 확정 | 설계문서 3종 참조 |
