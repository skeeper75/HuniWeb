# ★ M1 — 위젯이 생산으로 넘기는 「자재·공정」 데이터 명세 (M3 인계)

> **이 문서의 목적**: M3(생산·MES)의 **입력**을 필드 단위로 특정한다. 여기가 비면 M3 가 멈춘다.
> **조사 순서 준수**: ① 앱 내장 매뉴얼 2종 정독 → ② 라이브 실화면·실API 관찰 → ③ 코드 대조.
> **근거 없는 칸은 「미확인」.** 추정으로 메우지 않았다.

---

## 0. 한 줄 요약 — 생산 payload 는 어디에 있는가

**위젯이 생산으로 넘기는 데이터 = HMAC 서명된 `payload` 객체 1개.**
그 payload 는 `POST /api/w/v1/handoff` 가 만들고, `POST /api/w/v1/order/register` 가
`t_ord_orders.payload` (JSONB) 에 **통째로** 저장한다. 원고 파일 목록만 별도 표(`t_ord_artworks`)로 승격된다.

```
위젯 선택 → POST /handoff → payload 서명(HMAC) → token
                                    ↓
        쇼핑몰 장바구니(item_id 로만 참조) → 결제
                                    ↓
        POST /order/register → t_ord_orders.payload (사양 원장)
                             + work_size 서버 재계산 주입
                             + t_ord_artworks (원고 승격: tmp→order 버킷)
                                    ↓
                            [여기서부터 M3 영역]
```

**근거**
- 매뉴얼(위젯빌더) § 임베드 안내: 「장바구니 담기 = 주문 인계 — 위젯이 선택값·수량·원고·공정 상세를 정리해 주문 시스템으로 넘깁니다(핸드오프)」 (`tools/widget_manual_content.py` `EMBED_NOTES`)
- SDK 개발가이드 §2 동작 구조 · §14 API 레퍼런스 `POST /api/w/v1/handoff` (`https://huni-admin.printly.co.kr/sdk/guide/`)
- 코드: `raw/webadmin/webadmin/catalog/widget_api.py:2998` `_quote()` — 「선택값 전체를 서버가 재계산해 **서명 대상 payload** 를 만든다 — handoff·requote 공용」
- 코드: 같은 파일 `:3387~3455` payload dict 리터럴 전문
- 코드: 같은 파일 `:4187` `api_order_register` → `:4289` `payload["work_size"] = _order_work_size(payload)`
- 모델: `raw/webadmin/webadmin/catalog/models.py:1060` `TOrdOrders` (`t_ord_orders`) · `:1081` `TOrdArtworks` (`t_ord_artworks`)

> **[HARD] 권위**: 클라이언트가 보낸 값은 신뢰되지 않는다. 자재·공정·책등·작업사이즈는 **서버가 재조회·재계산**해 싣는다.
> 코드 주석(`widget_api.py:3288`): 「자재는 **서버가 템플릿에서 재조회**해 싣는다 — 클라가 자재를 보낼 통로 자체가 없다(T-rcl-01)」

---

## 1. payload 필드 전수 (25키 + 등록시 주입 1키)

`widget_api.py:3387-3455` 의 dict 리터럴을 그대로 전개한 것. **키는 항상 존재**한다(해당 없으면 `null`) — 코드 주석이 이를 "CR-02 규약"으로 명시.

| # | 키 | 타입 | 생산 관련성 | 내용 · 근거 |
|---|---|---|---|---|
| 1 | `v` | int | — | payload 스키마 버전. 현재 `1` |
| 2 | `site_cd` | str | — | 사이트 코드 (예: `SITE_OWN`) |
| 3 | `wgt_cd` | str | 추적 | 위젯 코드 |
| 4 | `ver_no` | int | 추적 | **게시 버전 번호** — 어느 스냅샷으로 주문됐는지 |
| 5 | `prd_cd` | str | ★자재/공정 | 상품 코드 — MES 품목 대사의 뿌리 |
| 6 | `selections` | dict | ★자재/공정 | 고객이 고른 **가격 차원** 원본. 키 = `siz_cd`·`mat_cd`·`print_opt_cd`·`opt_cd`·`bdl_qty`·비규격 치수 등 (상품마다 다름) |
| 7 | `sel_opts` | str[] | 제약 | 브라우저가 보낸 **원본 옵션코드 배열**(제약 데이터 계약·하위호환) |
| 8 | `sel_opt_grps` | str[] | 제약 | 선택된 옵션**그룹** 코드 — 재견적 재현용 |
| 9 | **`options`** | obj[] | ★★자재/공정 | **서버가 전개한 주문·MES 전달용 상세.** 그룹/옵션 이름 + **내부 구성요소**. 셋트는 각 행에 `mbr_prd_cd` 로 구성원 귀속 |
| 10 | **`combo`** | obj\|null | ★★★**자재 확정** | **조합 템플릿(옵션 조합 → 자재) 전개 결과.** `{tmpl_cd, tmpl_nm, components[]}`, 등록이 여럿이면 `regs[]` 추가 |
| 11 | `set` | obj\|null | ★자재/공정 | 셋트 상품의 **서버 정제 본문**(구성원 전개) — 아래 §3 |
| 12 | `addons` | obj[] | ★자재 | 추가상품 내역 `{name, qty, amount}` + **템플릿 자재**(`with_components=True` — handoff 전용) |
| 13 | **`proc_sels`** | obj[] | ★★★**공정 확정** | 후가공 선택 `{proc_cd, detail{}, side?, side_nm?}` — 아래 §2 |
| 14 | `grade_cd` | str\|null | 가격 | 고객 등급(서명 승계분만 신뢰) |
| 15 | `dsn_cd` | str\|null | ★원고 | 디자인 코드(포토북 등 고정사양 묶음) |
| 16 | `case_cnt` | int | ★생산수량 | **건수** — 사양·수량 동일, 원고만 다른 반복 벌수. 청구식 = 건당×건수 |
| 17 | `pages` | int\|null | ★자재 | 페이지수 — 「인쇄용지 장수 산출의 입력이라 가격에 직결」 |
| 18 | `order_title` | str\|null | 생산지시 | 제작물 제목. **MES 필드 nvarchar(100)** — UTF-16 코드유닛으로 셈 |
| 19 | **`spine`** | obj\|null | ★★자재/조판 | 책등 계산 파생값 — 아래 §4 |
| 20 | `spine_color` | str\|null | ★자재 | 부속(링) 색상 고객 선택 원문 |
| 21 | `qty` \| `copies` | int | ★생산수량 | 단일=`qty`, **셋트=`copies`(부수)**. 두 키는 **상호배타** |
| 22 | `supply` | str | 금액 | 공급가(부가세 별도) |
| 23 | `vat` | str | 금액 | 부가세액(10%) |
| 24 | `total` | str | 금액 | 청구액 = 공급가+부가세. **10원 배수 강제**(§6) |
| 25 | **`files`** | obj[] | ★★★**원고** | 업로드 원고 `{item, mbr, inst, key, name}` — `key`=S3 **임시버킷** 오브젝트 키 |
| 26 | **`editors`** | obj[] | ★★★**원고** | 편집기 결과 `{item, mbr, inst, result{prjid, ps_cd, saved_at}}` |
| 27 | `edicus_uid` | str\|null | ★원고 | 편집기 원고의 주인 — 「결제 후 Edicus 주문 API 의 **필수 헤더**」 |
| 28 | `ts` | int | — | 서명 시각(재서명마다 갱신) |
| 29 | `orig_ts` | int | — | **최초 담은 시각**(불변) — 30일 상한의 기준점 |
| — | **`work_size`** | obj\|null | ★★★**작업치수** | **payload 에 없다가 `order/register` 시점에 서버가 주입**한다. 아래 §5 |

> 실측 카운트: dict 리터럴 키 25개 + `**qty_info`(qty 또는 copies) + 등록시 `work_size` 주입.

---

## 2. ★ 공정(procs) — 어떤 형태로 나오는가

### 2.1 단일 상품 — `payload.proc_sels[]`

```json
"proc_sels": [
  { "proc_cd": "PROC_000037", "detail": { "가로": 30, "세로": 20 }, "side": "APPLY_POS.01", "side_nm": "앞면" }
]
```

| 필드 | 뜻 | 권위 |
|---|---|---|
| `proc_cd` | 공정 코드 | 상품에 연결된 공정 화이트리스트 |
| `detail` | 공정 상세옵션 값 | **공정정보 마스터의 `prcs_dtl_opt` 정의**(상위 공정에서 정의, 하위가 상속). 미선언 키는 **제거**, 범위 밖은 `bad_proc_detail` 422 |
| `side` / `side_nm` | 적용면 | `면별선택여부(side_sel_yn)=Y` 인 공정만. 값은 `APPLY_POS.01`(앞면)/`.02`(뒷면). **미등록 임의 문자열은 거절** |

**근거**
- 매뉴얼(운영자) FIELD_REF 「공정정보 — 위젯 동작을 바꾸는 필드」: `side_sel_yn` → 「면마다 따로 과금되며 **주문 데이터에 적용위치가 실려 MES 로 갑니다**」 (`manual_content.py`)
- 코드 `widget_api.py:1756` — 「③등록되지 않은 임의 `side` 문자열이 HMAC 서명 payload 로 **MES 까지 인계**된다」(차단 이유)
- 코드 `widget_api.py:3411` — `"proc_sels": proc_sels or []`
- 라이브 실측(`GET /api/w/v1/widgets/WGT_000288`) `meta.prod_dims[proc_cd].options[]`:
  ```json
  {"v":"PROC_000019","t":"무선제본","detail":[{"key":"제본방향","type":"enum",
    "values":["세로형좌철","세로형상철","가로형좌철","가로형상철"],"ctrl":"btn"}]}
  {"v":"PROC_000037","t":"홀로그램박","detail":[{"key":"가로","type":"integer","unit":"mm"},
    {"key":"세로","type":"integer","unit":"mm"}],"side_sel":true}
  {"v":"PROC_000014","t":"유광라미네이팅","detail":[{"key":"앞면코팅","type":"boolean"},
    {"key":"뒷면코팅","type":"boolean"}],"side_pair":["앞면코팅","뒷면코팅"]}
  ```

### 2.2 셋트 상품 — `payload.proc_sels` 는 **비어 있다**

[HARD] 셋트는 공정이 `payload.set.members[].procs` 또는 `payload.set.set_procs` 에 실린다.
코드 `widget_api.py:3140` — 「셋트의 공정은 payload 최상단이 아니라 `set.members[].procs` 로 이미 서명본에 실려 있다 (본품 단일 경로용 키라 여기서는 비운다)」, `proc_sels = None`.

> **M3 주의**: `payload.proc_sels` 만 읽으면 **셋트(책자류) 주문의 후가공이 통째로 사라진다.**
> 반드시 `is_set` 판정(= `payload.set != null`) 후 분기할 것.

### 2.3 필수 공정은 화면에서 감춰도 실린다

매뉴얼(위젯빌더) 컴포넌트 「후가공(공정선택)」 속성: 「필수 공정은 항상 선택되고 해제할 수 없습니다. 체크를 끄면 **화면에서만 감추고 가격·주문에는 그대로 들어갑니다**」·「컨트롤 숨김 … 후가공은 예외로, 숨기면 **필수 공정만** 가격·주문에 실립니다」

라이브 실측: `WGT_000288` 표지 구성원 `procs[0]` = `{"v":"PROC_000004","t":"디지털인쇄","mand":true}` — 고객이 고르지 않아도 state 의 `members[].procs` 에 `{"proc_cd":"PROC_000004","detail":{}}` 로 이미 들어 있음(라이브 `huni:change` 이벤트 캡처).

---

## 3. ★ 자재 — 어떤 형태로 나오는가 (3경로)

자재는 **한 곳이 아니라 세 경로**로 확정된다. M3 는 셋 다 읽어야 한다.

### 경로 A — 고객이 직접 고른 자재 : `selections.mat_cd` / `set.members[].mat_cd`

라이브 실측(`huni:change`, WGT_000288 무선책자):
```json
"members": [
  { "sub_prd_cd":"PRD_000290", "role":"SEMI_ROLE.02", "role_nm":"표지", "inst":1,
    "label":"무선책자-표지", "siz_cd":"SIZ_000632", "mat_cd":"MAT_000074",
    "print_opt_cd":"POPT_000001", "procs":[{"proc_cd":"PROC_000004","detail":{}}] },
  { "sub_prd_cd":"PRD_000289", "role":"SEMI_ROLE.01", "role_nm":"내지", "inst":1,
    "label":"무선책자-내지", "siz_cd":"SIZ_000250",
    "print_opt_cd":"POPT_000002", "pages":24 }
]
```
> `mat_cd` 는 **고객선택여부(`cust_sel_yn`)=Y** 인 자재만 위젯 선택지에 나온다(매뉴얼 FIELD_REF 「상품별 자재·사이즈」). N인 부자재는 이 경로로 오지 않는다 → 경로 B 가 담당.

### 경로 B — ★조합 템플릿이 확정하는 자재 : `payload.combo`

**이것이 「옵션 조합 → 실제 생산 자재」의 결정 지점이다.**

매뉴얼(운영자) 화면 「상품 › 구성템플릿 조합 (내부 대조표)」:
> 「옵션 조합이 실제로 어떤 자재로 만들어지는지 적어 두는 내부 대조표입니다. **고객 화면에는 절대 나오지 않고, 주문이 들어왔을 때 어떤 자재로 생산할지 결정하는 데 쓰입니다.**」
> 「**매핑이 비어 있으면 주문이 막힙니다**(잘못된 자재로 생산되는 것을 막는 안전장치)」

payload 형태 (`widget_api.py:3334-3341`):
```json
"combo": {
  "tmpl_cd": "TMPL_000003",
  "tmpl_nm": "…",
  "components": [ /* TC.ref_components() 결과 — 자재 구성요소 행 */ ],
  "regs": [ { "seq":1, "reg_nm":"앞뒤판", "tmpl_cd":"…", "tmpl_nm":"…", "components":[…] },
            { "seq":2, "reg_nm":"책등판", "tmpl_cd":"…", "tmpl_nm":"…", "components":[…] } ]
}
```
- **등록이 1개면** `regs` 없음(하위호환), **여러 개면** `components` 는 합집합 + `regs[]` 로 등록별 분해.
- 결정 축(차원)은 등록마다 다르다 — 코드 `:3313` 「자재별로 결정 차원이 다르기 때문(앞뒤판=사이즈 / 책등판=사이즈+책등두께)」
- 매칭 입력 = `_opt_codes`(옵션) + `selections`(비옵션 차원) + `proc_codes` + `spine_mm`
- **미등록 조합 = `tmpl_combo_gap` 422 fail-closed** — 코드 `:3290` 「조용한 오생산 대신 시끄러운 거절」
- ⚠ **알려진 한계(코드 `:3287`)**: 「셋트(body.set) 경로는 `proc_sels=None` 이라 **proc_cd 차원 조합은 항상 미매칭** → 422 fail-closed」

### 경로 C — 책등 규격표가 확정하는 부속 자재 : `payload.spine.ring`

매뉴얼(위젯빌더) 컴포넌트 「부속 색상」:
> 「색상 목록·표시명·스와치는 전부 **공정관리 규격표**에서 옵니다 — 별도 색상 마스터가 없습니다.
> **확정된 링 자재코드는 서버가 재계산해 주문 정보에 실립니다**(고객이 보낸 값은 신뢰하지 않습니다).」

매뉴얼(운영자) FIELD_REF 「공정정보 — 책등 계산 설정 § 규격표」: 「**자재를 연결해야 주문에 자재코드가 실립니다.**」

---

## 4. `payload.spine` — 책등·조판 근거값

SDK 가이드 `POST /handoff` 응답 예시:
```json
"spine": {
  "proc_cd": "PROC_000019", "proc_nm": "무선제본",
  "spine_mm": 5.0,
  "spread": { "w": 425.0, "h": 297.0 },
  "ring": null, "color": null,
  "rnd_typ_cd": "SPINE_RND_TYPE.02",
  "label": "책등 5mm · 표지 펼침 425×297mm"
}
```

- **적재 조건**: 계산 설정이 있고 계산 성공이면 **부속 색상 컴포넌트 유무와 무관하게 항상** 싣는다.
  코드 `:3355` — 「표지 펼침 사이즈(spread)는 **PDF 원고 검수·조판의 근거값**이라 … 무선/PUR·하드커버 위젯에도 필요하다(D-1)」
- **거절 조건**: 부속 색상 컴포넌트가 있는 위젯 **또는** 규격표 올림(`SPINE_RND_TYPE.03`) 제본의 **신규 발급**에서 계산 실패 → `spine_unavailable` 422
- 고정 제본 상품(고객이 제본을 안 고르는 상품)도 `proc_cd`/`proc_nm` 이 함께 실려 **payload 만으로 어떤 제본인지 알 수 있다** (SDK 가이드 §14)
- 라이브 실화면 확인: 무선책자 위젯에 「펼침면 사이즈: 661 × 210 mm (책등 1mm 포함)」 + 펼침 도해가 그려짐 (스크린샷 `set-widget.png`)

---

## 5. ★ `payload.work_size` — 원고 검수·생산이 기대하는 치수

**완성(재단) 사이즈가 아니라 이 값이 생산 치수다.**

SDK 가이드 §10:
> 「저희 서버가 **등록 시점에** 실제 작업 크기를 다시 계산해 보관 사양의 `work_size` 에 담습니다 —
> **원고 검수·생산(MES) 이 기대하는 치수는 완성사이즈가 아니라 이 값**입니다.」

| 항목 | 값 |
|---|---|
| 형태 | `{ w, h }`(mm) · `m`(상·하·좌·우 여유) · `procs`(여유를 만든 공정 코드) |
| 셋트 | `members` 로 구성원마다 독립 계산(표지 후가공이 내지 치수를 키우지 않음) |
| 합성 규칙 | **방향별 최대값 한 번만** — 합산 아님 (20mm + 10mm → 20mm) |
| 없을 때 | `null` (해당 후가공 없음 또는 계산 실패) |
| 가격 영향 | **없음** — 안내·제작용 치수 |
| 주입 시점 | `order/register` — `widget_api.py:4289` |
| 재계산 이유 | 「위젯/쇼핑몰이 보낸 값을 저장하지 않고 여기서 다시 계산한 값만 주입한다(T-wzh-01 tampering 대응)」 |
| 실패 시 | `work_size=None` 으로 **등록은 계속 진행**(결제된 주문을 죽이지 않음) |
| 멱등 지문 제외 | `_ord_fingerprint` 가 `ts`·`work_size` 를 뺀다 — 서버 파생 필드라 재전송 비교 대상 아님 (`:4011`) |

- 규칙 단일 진실: `raw/webadmin/webadmin/catalog/work_margin.py` (Django import 금지 순수함수)
- **짝**: 렌더러 `catalog/static/catalog/widget_renderer.js` 의 `HuniWidgetRenderer.workMargin/workSize` — 「규칙이 갈리면 화면(위젯)과 주문(payload.work_size)이 다른 숫자를 말하게 된다」
- 마스터 필드: 공정정보 `work_margin_top/bot/lft/rgt`
  ⚠ 매뉴얼 명시: 「**운영 DB 에 아직 이 값을 쓰는 공정이 없어 화면의 4칸이 지금은 비어 있다**」
  → **현재 라이브에서 `work_size` 는 사실상 항상 `null` 일 가능성이 높다. M3 가 라이브 실측으로 확정할 것.**

---

## 6. 원고(files/editors) — 생산이 실제로 가져가는 것

### 6.1 좌표계 — `item` · `mbr` · `inst`

세 값이 「어느 입력칸의, 어느 구성원의, 몇 번째 벌」을 가리킨다. **files 와 editors 가 같은 좌표계**를 쓴다.

| 키 | 뜻 |
|---|---|
| `item` | 위젯 항목 코드 `WGTI_xxxxxx` (파일업로드/편집기 컴포넌트) |
| `mbr` | 셋트 구성원 상품코드 (`null` = 본품 공통) |
| `inst` | 벌 번호(내지를 여러 벌 넣는 경우) |

### 6.2 `files[]` — 업로드 원고

```json
"files": [ { "item":"WGTI_000123", "mbr":null, "inst":1, "key":"uploads/…", "name":"원고.pdf" } ]
```
- `key` 는 **임시(tmp) 버킷** S3 오브젝트 키다. **30일 수명주기**가 걸려 있다.
- [HARD] **MES 는 이 키로 파일을 가져갈 수 없다.** `models.py:1086`:
  > 「주문이 등록되는 즉시 주문 버킷으로 복사(승격)하고 그 결과를 여기 남긴다 —
  > **MES 에 넘길 키 목록의 출처가 이 표(`t_ord_artworks`)다**(payload 의 키로는 MES 가 가져갈 수 없다).」

### 6.3 `t_ord_artworks` — ★M3 가 읽어야 할 실제 원고 표

| 컬럼 | 뜻 |
|---|---|
| `art_id` / `ord_id` | 주문원고ID / 주문등록ID(FK) |
| `rev_no` | 회차번호 |
| `item_cd` · `mbr_prd_cd` · `inst_no` | payload 와 **같은 좌표계** |
| `orig_file_nm` · `file_ext` | 원본 파일명 · 확장자 |
| `decl_size` / `file_size` | 신고값(서명 payload) / **head_object 실측값** — 「승격이 크기가 처음 강제되는 지점」 |
| `tmp_key` → **`ord_key`** | 임시버킷 키 → **주문버킷 키(MES 가 쓸 키)** |
| `art_sts` | `PENDING`(승격대기) · `PROMOTED`(승격완료) · `FAILED`(승격실패) |
| `fail_rsn` · `promo_dt` | 실패사유 · 승격일시 |

승격 실행: `widget_api.py:4041` `_promote_artwork()` → `catalog/artwork_promote.py` `promote_order()` + `sweep_pending()`
- 「크론·워커 인프라가 없다」 — **주문 등록 요청 안에서 동기 실행**, 시간 예산 초과분은 다음 호출로 이월
- 실패 시 「승격 모듈이 주문을 **보류(HOLD)** 로 세우고 사유를 남긴다」
- `art_sts` 주석: 「**파일 검사 단계가 붙으면 값이 늘어난다**」 → **프리플라이트는 아직 없다**(§8)

### 6.4 `editors[]` — 편집기 원고

```json
"editors": [ { "item":"WGTI_000123","mbr":null,"inst":1,
  "result":{ "prjid":"-KzvOwkOBG3ym3G9Mp6i", "ps_cd":"124x186@HU_14545",
             "saved_at":"2026-08-15T07:21:40.512Z" } } ]
```
- SDK 가이드 §8: 「`prjid`(편집기 프로젝트 식별자)를 주문 레코드에 **반드시 저장**하세요 — **인쇄용 데이터를 뽑을 때 쓰는 열쇠**입니다.」
- `payload.edicus_uid` = 「결제 후 **Edicus 주문 API 의 필수 헤더**」 (`widget_api.py:2964`)
- ⚠ 편집기 원고는 **파일이 아니라 Edicus 쪽 프로젝트**로 보관된다. 후니는 프로젝트 ID만 갖는다.
- ⚠ **미확인(후니가 확인 중)**: 편집기 프로젝트의 보존 기간 — SDK 가이드 §9-07-③ 「저희가 Edicus 담당자에게 확인하고 있습니다」

---

## 7. M3 가 읽을 인계 지점 — 정리

| 무엇 | 어디 | 비고 |
|---|---|---|
| 제작 사양 전문 | `t_ord_orders.payload` (JSONB) | 서명 payload 통째 |
| 주문 키 | `t_ord_orders` `(site_cd, shop_ord_no, shop_line_no)` UNIQUE | 쇼핑몰 주문번호 + 라인번호 |
| 주문 상태 | `t_ord_orders.ord_sts` | 등록 직후 `"REGISTERED"` |
| **원고 실파일 키** | `t_ord_artworks.ord_key` (`art_sts='PROMOTED'`) | payload 의 `key` 아님 |
| 편집기 원고 | `payload.editors[].result.prjid` + `payload.edicus_uid` | Edicus API 로 조회 |
| **자재** | `payload.combo` + `selections.mat_cd` + `set.members[].mat_cd` + `spine.ring` | 4경로 |
| **공정** | 단일 `payload.proc_sels` / 셋트 `payload.set.members[].procs`·`set_procs` | 분기 필수 |
| **생산치수** | `payload.work_size` (없으면 `selections.siz_cd` 의 재단치수) | 현재 대부분 `null` 추정 → M3 실측 |
| 옵션 전개 | `payload.options[]` (그룹/옵션명 + 내부 구성요소, `mbr_prd_cd` 귀속) | MES 대사는 **코드 기준**(`opt_nm` 변경 금지 — `:1929`) |
| MES 품목코드 | `t_prd_products.MES_ITEM_CD` (max 30) | 매뉴얼: 「**한글화·약어화하지 않고 대문자 원형 그대로**」 |

---

## 8. ★ M3 에게 넘기는 확정 사실 — 「MES 접수는 아직 없다」

**코드 주석이 명시적으로 범위를 긋고 있다** (`widget_api.py:4005-4006`):

> 「이번 범위는 **기록까지**다. **원고 승격(tmp→order 버킷 복사)·프리플라이트·MES 접수는 각각 별도 플랜** — 쇼핑몰이 부르는 계약은 그대로 두고 뒤에 붙인다.」

그중 **원고 승격은 그 뒤 구현됐다**(`artwork_promote.py` 실재 + `t_ord_artworks` 표 + `_promote_artwork` 호출). 남은 둘:

| 항목 | M1 이 관측한 상태 | 판정 주체 |
|---|---|---|
| 원고 승격 (tmp→order) | **구현됨** — `artwork_promote.py`, `t_ord_artworks`, `art_sts` 3값 | 확정 |
| **프리플라이트**(PDF 검사) | **코드상 미구현** — `art_sts` 주석 「파일 검사 단계가 **붙으면** 값이 늘어난다」. 설계 문서는 존재: `raw/webadmin/docs/artwork-scan-integration.md` · `artwork-scan-engine-review.md` · `artwork-scan-clamav-vs-eset.md` | **M3 가 확정** |
| **MES 접수** | **코드상 미구현** — `MES` 문자열은 전부 *주석·필드명·설계 참조*이고 인계 호출부 없음 | **M3 가 확정** |

### ★★ M3 에게 알리는 문서 — L0 지도에 없다

`raw/webadmin/docs/` 에 **M3 의 1차 참조 문서 2종**이 있다. lead 지도에 언급 없음.

| 문서 | 줄수 | 왜 중요한가 |
|---|---:|---|
| **`raw/webadmin/docs/order-to-mes-process.md`** | 737 | 코드가 §4·§6.5 를 직접 인용(`widget_api.py:3995`, `models.py:1087`). **주문→MES 프로세스의 설계 정본** |
| **`raw/webadmin/docs/order-to-mes-diagrams.md`** | 306 | 위 문서의 도해 |
| `raw/webadmin/docs/artwork-scan-integration.md` 외 2종 | — | **프리플라이트(원고 검사) 엔진 검토·통합 설계** |
| `raw/webadmin/docs/aws-architecture-huni.md` / `.pdf` | — | 인프라 (M3 카드가 지목한 PDF 의 md 판본이 webadmin 안에 있다) |

> **M3 는 PDF 3종을 읽기 전에 이 4종을 먼저 볼 것.** 코드가 참조하는 설계 정본이다.

---

## 9. 미확인 (추정으로 메우지 않음)

1. **`payload.options[]` 의 정확한 행 스키마** — `_expand_opt_sels()` 반환 형태를 코드로 확인하지 못했다(`widget_api.py:1889` 함수 존재만 확인). 라이브 주문 payload 실물을 보지 못했다.
2. **`combo.components[]` 의 행 스키마** — `TC.ref_components()` 반환 형태 미확인. 자재코드 컬럼명 미확인.
3. **라이브 `t_ord_orders` 실제 행** — 읽지 않았다(라이브 DB 읽기전용 조회 미수행). 실제 주문이 있는지, payload 실물이 어떤 모양인지 미확인.
4. **`work_size` 가 라이브에서 실제로 채워지는가** — 매뉴얼이 「작업여백을 쓰는 공정이 아직 없다」고 명시하나 **라이브 DB 실측은 하지 않았다.**
5. **MES 인계 방식(API/파일/DB)** — 코드에 없다. `docs/order-to-mes-process.md` 미독(M3 영역).
6. **`ord_sts` 의 전체 값 도메인** — `REGISTERED` 와 `HOLD`(승격 실패 시)만 관측. CHECK 제약 없음(모델 주석).
7. **셋트 `set_procs`(본품 스코프 공정) 의 실제 payload 형태** — 코드 경로만 확인, 실물 미관측.
8. **프리플라이트/MES 미구현 판정** — M1 은 *코드에 인계 호출부가 없다*까지만 관측했다. **「미구현」 확정은 M3 의 몫**(설계문서·라이브·별도 시스템 확인 필요).

---

## 부록 A — 실측 근거 (재현 가능)

| 근거 | 획득 방법 |
|---|---|
| 매뉴얼 2종 | `raw/webadmin/tools/manual_content.py`(924줄) · `tools/widget_manual_content.py`(821줄) 전문 정독 |
| SDK 개발가이드 | 라이브 `https://huni-admin.printly.co.kr/sdk/guide/` 전문(2,132줄) — 로그인 후 사이드바 「개발자 문서(외부 공개)」 |
| 라이브 위젯 실동작 | `https://huni-admin.printly.co.kr/sdk/demo/` — 핀버튼(WGT_000005) · 무선책자(WGT_000288). **주문 직전 정지**, 장바구니 버튼 미클릭 |
| 위젯 state 실캡처 | 데모 페이지에 읽기전용 이벤트 리스너 주입 → `huni:change` detail 전문 |
| 위젯 구성 원본 | `GET /api/w/v1/widgets/{wgt_cd}?site_key=…` (읽기전용 GET) |
| 코드 | `raw/webadmin/webadmin/catalog/widget_api.py`(4,666줄) · `models.py` · `work_margin.py` |

**읽기전용 준수**: 주문·결제·폼제출·DB write 를 수행하지 않았다. 커밋·푸시 없음.
