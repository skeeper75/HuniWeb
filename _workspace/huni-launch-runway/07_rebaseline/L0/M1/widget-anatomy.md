# M1 — 위젯 해부 (widget-anatomy)

> **조사 순서 준수**: ① 앱 내장 매뉴얼 2종 정독 → ② 라이브 실화면·실API 관찰 → ③ 코드 대조.
> 근거 없는 칸은 「미확인」.

---

## 1. 위젯이란 무엇인가 — 한 문장

**주문위젯 = 고객이 상품을 주문할 때 보는 「주문서 화면」 전체.** 사이즈·용지·후가공을 고르고, 수량을 넣고, 원고를 올리고, 가격을 확인해 장바구니에 담는 그 화면 하나가 위젯 하나다.

> 매뉴얼(위젯빌더) `OVERVIEW`:
> 「상품 관리 화면이 **재료 창고**라면, 위젯빌더는 그 재료로 **주문서를 차리는 식탁**입니다.
> 창고에 없는 재료는 식탁에 올릴 수 없습니다 — 위젯에 어떤 선택지가 안 보이면
> **거의 항상 상품 설정에 그 값이 없거나 꺼져 있는 것**입니다.」

### 1.1 [HARD] 위젯이 하지 않는 일

| 위젯이 하지 않는 것 | 실제 권위 |
|---|---|
| **가격을 정하지 않는다** | 가격공식·단가표·할인테이블 (서버 `evaluate_price`) |
| **상품 설정을 바꾸지 않는다** | 상품 뷰어 · 기준정보 마스터 |
| **자재를 확정하지 않는다** | 구성템플릿 조합(서버 재조회) · 책등 규격표 |
| **편집기를 띄우지 않는다** | 호스트 페이지(임베드한 쪽). 위젯은 `huni:editor` 신호만 보낸다 |
| 겉모양(색·글꼴)을 정하지 않는다 | 임베드 페이지의 CSS 변수 `--hw-*` |

> 매뉴얼(운영자) 「위젯 › 위젯빌더」 intro: 「위젯은 **가격을 정하지 않습니다** — 금액은 가격공식·단가표·할인테이블이 정하고, 위젯은 그 결과를 보여 줄 뿐입니다.」
> SDK 가이드 §2: 「**가격·검증의 권위는 항상 서버입니다.** 브라우저(위젯)는 표시만 합니다 — 위젯 코드를 조작해도 주문 금액은 바뀌지 않습니다.」

---

## 2. 물리적 형태 — 무엇이 어디에 사는가

| 구성 | 실체 | 위치 |
|---|---|---|
| 임베드 스크립트 | `widget.js` (Web Component `<huni-widget>`) | `https://huni-admin.printly.co.kr/static/catalog/widget.js` |
| 렌더러 | `HuniWidgetRenderer` | `raw/webadmin/webadmin/catalog/static/catalog/widget_renderer.js` |
| 격리 | **Shadow DOM** (`attachShadow`) | 페이지 CSS 와 충돌 없음. 단 `font-family` 는 상속되어 경계를 넘어옴 |
| 구성 데이터 | `GET /api/w/v1/widgets/{wgt_cd}` | 게시본만 서빙 |
| 서버 API | `/api/w/v1/*` (**URL 패턴 22개** 실측) | `raw/webadmin/webadmin/config/urls.py:246-289` |
| 빌더(운영자) | `/admin/widget-builder/` | 자동저장 0.6초 |

**임베드 형태 2가지 (완전히 등가 — 같은 코드 한 벌)**
```html
<!-- 선언형 -->
<script src="https://huni-admin.printly.co.kr/static/catalog/widget.js"></script>
<huni-widget widget-id="WGT_000001" site-key="wk_…"
             accent="#0f766e" design="DSN_000001" hide-submit hide-reasons></huni-widget>
```
```js
// SDK형
const w = new HuniWidgetSDK();
await w.mount("#box", { widgetId:"WGT_000001", siteKey:"wk_…" });
```

**라이브 실측**: `https://huni-admin.printly.co.kr/sdk/demo/` 에서 `<huni-widget id="hw" widget-id="WGT_000005" site-key="wk_B0vJ…">` 로 실제 마운트되어 동작 확인.

---

## 3. ★ 상품 구성요소 ↔ 가격 구성요소 결합 구조

**핵심**: 위젯 항목(`item`)은 **소스 유형(`src_typ_cd`)** 과 **참조 키(`ref_key`)** 두 값으로 상품 데이터에 묶인다.
그중 `src_typ_cd = WGT_SRC_TYPE.01`(차원)만이 **가격 축**이고, 나머지는 가격에 직접 닿지 않는다.

```
[상품 설정]                    [위젯 항목]                [가격]
 사이즈 목록      ──ref_key=siz_cd──▶  차원(.01)  ──┐
 자재 목록        ──ref_key=mat_cd──▶  차원(.01)  ──┤
 인쇄옵션 목록    ──ref_key=print_opt_cd─▶ 차원(.01)─┼─▶ selections{} ─▶ evaluate_price
 묶음수           ──ref_key=bdl_qty─▶  차원(.01)  ──┤        (use_dims 축 매칭)
 수량 규칙        ──ref_key=qty ────▶  수량(.03)  ──┘
 옵션그룹         ─────────────────▶  옵션그룹(.02) ─▶ sel_opts[] (가격축이 될 수도 있음*)
 공정 연결        ─────────────────▶  공정선택(.14) ─▶ proc_sels[] ─▶ 공정비
 추가상품 연결    ─────────────────▶  추가상품피커(.13) ─▶ addons[] (별도 합산)
 페이지룰         ──ref_key=pages ──▶  수량(.03)  ─────▶ pages (용지 장수 → 가격 직결)
```

\* 코드 `widget_api.py:3258` — 「옵션이 '가격 차원(`opt_cd`)'인 상품(배너사이즈처럼 `use_dims=opt_cd`)도 같은 옵션 엔티티이므로 전개에 합류시킨다」

### 3.1 위젯 항목 1개의 실제 스키마 (라이브 실측)

`GET /api/w/v1/widgets/WGT_000005` 응답 `widget.cfg.items[]` 원본:

```json
{
  "item_cd": "WGTI_000018",          // 항목 코드 — files/editors 좌표계의 `item`
  "src_typ_cd": "WGT_SRC_TYPE.01",   // 소스 유형(무엇을 고르게 하나) — 20종
  "ref_key": "siz_cd",               // 참조 키(어느 축인가). 구조 요소는 null
  "ctrl_typ_cd": "WGT_CTRL_TYPE.01", // 컨트롤 유형(어떤 모양으로) — 26종
  "block_typ_cd": "WGT_BLOCK_TYPE.01", // 제약 위반 시 처리: .01 비활성 / .02 숨김
  "mbr_prd_cd": null,                // 셋트 구성원 스코프(null=본품 공통)
  "parent_item_cd": null,            // 패널 자식이면 부모 항목
  "row_no": 1, "col_no": 1,          // 배치(행/열, 한 행 최대 2열)
  "fold_yn": "N",                    // 패널 초기 접힘
  "visible_yn": "Y",                 // 컨트롤 숨김(숨겨도 기본값은 강제 적용)
  "label_nm": null,                  // 표시 라벨(비우면 원래 소스 이름)
  "dflt_val": "4",                   // 기본값(위젯이 상품설정보다 우선)
  "props": {"cols":3,"show_cut":false,"show_work":true}  // 컴포넌트별 세부 설정
}
```

### 3.2 `props` 로 들어가는 대표 설정 (라이브 관측)

| props 키 | 컴포넌트 | 뜻 |
|---|---|---|
| `cols` | 버튼그룹/스와치 | 버튼 열 수 1~6 |
| `show_cut` / `show_work` | 차원(사이즈) | 재단 사이즈 / 작업 사이즈 표시 |
| `tier_style` | 수량 | 수량구간 할인 표시: `table`(가격표) · 게이지 · 숨김 |
| `show_components` | 가격요약 | 구성요소별 내역 노출 (⚠ 대외 위젯은 합계만 권장) |
| `max_mb` / `max_files` | 파일업로드 | 용량·개수 상한 (오류코드 `bad_file_size`/`bad_file_count` 근거) |
| `required` / `placeholder` | 제작물 제목 | 필수여부(**기본 Y**) · 안내문구 |
| `min` / `max` | 건수 | 건수 범위 (상품 마스터 개념 없음 — **props 가 유일 출처**) |
| `size` | 이미지 스와치 | 버튼 크기 px (렌더러 게이트 24~160) |

---

## 4. 소스 유형 20종 (`WGT_SRC_TYPE`) — 라이브 DB 코드표 + 실사용 분포

라이브 읽기전용 SELECT (`t_cod_base_codes` + `t_wgt_widget_items`) 실측:

| 코드 | 이름 | 가격축? | 배치 규칙 | 전제조건 | **실사용 건수** |
|---|---|---|---|---|---:|
| `.01` | **차원** | ★가격축 | 차원당 1개 | 상품에 그 차원 값 등록 | **740** |
| `.02` | 옵션그룹 | 간접(제약·가격차원 가능) | 그룹당 1개 | 옵션그룹 `사용여부=Y` | 126 |
| `.03` | **수량** | ★가격축 | 수량/페이지수 각 1개 | 없음 | **464** |
| `.04` | 추가상품(체크박스) | 합산 | — | **사용 중단** | 1 |
| `.05` | 패널(접기그룹) | — | 무제한 | 없음 | 21 |
| `.06` | 라벨 | — | 무제한 | 없음 | 53 |
| `.07` | 안내문 | — | 무제한 | 없음 | 8 |
| `.08` | **가격요약** | 표시 | 위젯당 1개 | 없음 | **435** |
| `.09` | **파일업로드** | — | 위젯당 1개 | 상품 `파일업로드지원여부=Y` | **427** |
| `.10` | **편집기버튼** | — | 위젯당 1개 | 상품 `편집기지원여부=Y` | **212** |
| `.11` | 빈공백 | — | 무제한 | 없음 | 83 |
| `.12` | 비규격치수 | ★가격축 | 위젯당 1개 | 상품 `비규격여부=Y` | 23 |
| `.13` | 추가상품피커 | 합산 | 위젯당 1개 | 연결된 추가상품 ≥1 | 57 |
| `.14` | **공정선택(후가공)** | ★가격축 | **무제한** | 연결된 공정 ≥1 | **139** |
| `.15` | 가로선 | — | 무제한 | 없음 | 46 |
| `.16` | 건수 | ★곱셈 | 위젯당 1개 | 없음 | 12 |
| `.17` | 제작물제목 | 가격 무관 | 위젯당 1개 | 설정에 따름(기본 필수) | 8 |
| `.18` | 머리말 | — | 무제한 | 없음 | 68 |
| `.19` | **부속 색상** | ★자재확정 | 위젯당 1개 | 제본 공정에 **링 규격표** 등록 | **0** ⚠ |
| `.20` | 책등/표지 사이즈 | 표시 전용 | 위젯당 1개 | 책등 계산 쓰는 공정 | 2 |

> ⚠ **`.19` 부속 색상 = 라이브 배치 0건.** SDK 가이드 §14 `spine_unavailable` 설명의
> 「라이브 실측: 링 상품 4개의 게시 위젯 3개 전부 컴포넌트 없음」과 정합한다.
> 트윈링 계열 주문은 링 자재코드가 payload 에 실리지 않을 수 있다 → **생산 리스크. M3 확인 필요.**

> 매뉴얼(위젯빌더) `validate()` 는 `.01~.16` 만 문서화 게이트로 강제한다(`widget_manual_content.py`).
> `.17~.20` 은 본문 원고에만 있고, `.19`·`.20` 은 **스크린샷 캡처가 아직 없다**(원고 주석 명시).

---

## 5. 컨트롤 유형 26종 (`WGT_CTRL_TYPE`) — 라이브 DB 코드표

| 코드 | 이름 | 코드 | 이름 | 코드 | 이름 |
|---|---|---|---|---|---|
| `.01` | 버튼그룹 | `.10` | 멀티셀렉트 *(퇴역)* | `.19` | 비규격치수 |
| `.02` | 셀렉트박스 | `.11` | 버튼그룹(다중) | `.20` | 추가상품피커 |
| `.03` | 라디오그룹 | `.12` | 패널 | `.21` | 공정선택 |
| `.04` | **컬러칩** | `.13` | 라벨 | `.22` | 가로선 |
| `.05` | 토글 | `.14` | 안내문 | `.23` | 건수 |
| `.06` | 텍스트필드 | `.15` | 가격요약 | `.24` | 텍스트 |
| `.07` | 수량스텝퍼 | `.16` | 파일업로드 | `.25` | 머리말 |
| `.08` | 이미지스와치 | `.17` | 편집기버튼 | `.26` | 책등/표지 사이즈 |
| `.09` | 체크박스그룹 | `.18` | 빈공백 | | |

- **컨트롤 선택지는 소스가 정한다** — 다중 선택 그룹에 단일용 컨트롤은 못 쓴다(매뉴얼 `COMMON_PROPS`).
- 단일선택 블랙리스트(렌더러 `:99`): `.05 토글`·`.06 텍스트필드`·`.09 체크박스그룹`·`.10 멀티셀렉트`·`.11 버튼그룹(다중)`
- 유형 자동 교체(렌더러 `:1283-1291`): 다중↔단일 전환 시 `.01↔.11`, `.02↔.09`, `.03↔.09`, `.04→.08`
- ⚠ **`.04 컬러칩`은 매뉴얼 `CTRL_TYPES` 목록에 없다** — 매뉴얼 누락 후보(§9).

---

## 6. 셋트(책자) 위젯의 구조 — `mbr_prd_cd` 스코프

라이브 실측 `WGT_000288`(무선책자 · PRD_000069) 항목 20개 배치:

| 행 | 항목 | 소스 | 참조 | 구성원 스코프 | 라벨 |
|---:|---|---|---|---|---|
| 1 | WGTI_001877 | 차원 | `siz_cd` | 본품 | — |
| 2 | WGTI_001880 | 수량 | `qty` | 본품 | — |
| 2 | WGTI_003276 | 공정선택 | — | 본품 | 개별포장 |
| 3 | WGTI_001974 | 제작물제목 | — | 본품 | — |
| 5 | WGTI_002025 | 머리말 | — | **PRD_000289(내지)** | — |
| 6~9 | … | 차원·차원·수량·파일업로드 | `mat_cd`·`print_opt_cd`·`pages` | **PRD_000289(내지)** | 내지종이·내지인쇄 |
| 11 | WGTI_001975 | 머리말 | — | **PRD_000290(표지)** | — |
| 12 | WGTI_003502 | **책등/표지 사이즈** | — | 본품 | — |
| 13~18 | … | 차원·차원·공정×3·파일업로드 | `mat_cd`·`print_opt_cd` | **PRD_000290(표지)** | 표지종이·표지인쇄·표지코팅·박가공·형압 |
| 19 | WGTI_001883 | 가격요약 | — | 본품 | — |

**meta.set_members[]** 가 구성원 정의를 싣는다(라이브 실측):
```json
{ "sub_prd_cd":"PRD_000290", "prd_nm":"무선책자-표지", "role":"SEMI_ROLE.02", "role_nm":"표지",
  "is_inner": false, "dflt_qty":1, "min_cnt":1, "max_cnt":1, "cnt_incr":null,
  "page_rule":null, "sizes":[…], "materials":[{"v":"MAT_000074","t":"백색모조지 220g",
    "dflt":true, "dep":0.23, "mtyp":"MAT_TYPE.01"}], "print_opts":[…], "procs":[…] }
```
- `dep` = 용지 **두께(mm)** — 책등 계산 입력
- `role`: `SEMI_ROLE.01`=내지 · `SEMI_ROLE.02`=표지
- 수량 개념: 단일=`qty`, **셋트=`copies`(부수)**. 라이브 `qty_unit` = `"권"`

---

## 7. `GET /api/w/v1/widgets/{wgt_cd}` 응답 전체 (라이브 실측)

```
widget: { wgt_cd, wgt_nm, ver_no, theme_opts, cfg:{ cfg_ver, header, items[] } }
  header: { prd_cd, wgt_nm, site_cd, theme_opts }
meta:
  prd_cd · prd_nm
  prod_dims[]        차원별 선택지 — {name, label, options:[{v,t,dflt,cut_w,cut_h,work_w,work_h,dep,mtyp,sd,img,detail[],side_sel,side_pair,mand}]}
  opt_groups[]       옵션그룹
  file_upload_yn · editor_yn        상품 스위치
  apply_pos[]        적용면 코드표 (APPLY_POS.01 앞면 / .02 뒷면)
  qty_rule           {min, max, incr, dflt}
  qty_unit           "세트" · "권" 등
  size_qty_rules{}   사이즈별 수량 규칙
  page_rule / page_rules   {min, max, incr}
  nonspec            {yn, w_min, w_max, w_incr, h_min, h_max, h_incr}
  addons[]           연결 추가상품
  constraints        {rules[], dim_var{}, dim_val{}}   ← JSONLogic 제약
  is_set             boolean
  spine              {PROC_xxxx: {cfg:{spine_mgn_mm, rnd_typ_cd, cover_incl_yn}, specs:[]}}
  set_members[]      셋트일 때만
```

**[HARD] 게시본만 서빙된다.** 작성중 위젯은 `not_published` 409. 상품이 판매중지면 `product_unpublished` 409.

---

## 8. 버전 · 사이트키 · 게시 상태가 좌우하는 것

### 8.1 저장 ≠ 게시

| 행위 | 대상 | 고객 화면 반영 |
|---|---|---|
| 편집 | 작업본 (0.6초 **자동저장**, 저장 버튼 없음) | ❌ 안 됨 |
| **[게시]** | **버전 스냅샷 생성** → 활성 버전 | ✅ 즉시 |
| [게시 중단] | 활성 버전 유지, 노출만 내림 | 화면에서 사라짐 |
| [다시 게시] | **내리기 전 그 버전** 재노출 | ⚠ 그 사이 고친 내용은 안 나감 |
| [이 버전으로 롤백] | 활성 버전 교체 + **작업본도 그 내용으로 되돌아감** | ✅ |

- 게시 후 수정하면 상태 배지에 「**수정 있음 · 재게시 필요**」 칩이 붙는다.
- **처음 게시는 오직 [게시] 버튼으로만** — 「게시 직전 경고 확인과 버전 메모가 [게시] 에만 있기 때문입니다. 그 관문을 건너뛰지 않으려고 **일부러 막아 두었습니다**」(매뉴얼 `PUBLISH_NOTES`)
- payload 에 `ver_no` 가 실린다 → 어느 스냅샷으로 주문됐는지 추적 가능.
- 구 버전 스냅샷은 `cfg_ver_unsupported` **501** — 위젯 재게시 필요.

**게시 직전 확인창(막지 않고 확인만)**: ① 상품 게시여부 N ② **시작가 미산출** ③ 책등 규격표↔부속 색상 불일치.
**게시하면 그 상품의 시작가가 자동으로 다시 계산된다.**

### 8.2 라이브 위젯 현황 (읽기전용 SELECT 실측 · 2026-09-02)

| 항목 | 값 |
|---|---:|
| 작성중 (`WGT_STS_TYPE.01`) | **239** |
| 게시됨 (`.02`) | **193** |
| 게시중단 (`.03`) | 4 |
| 판매중 상품 (`use_yn='Y'`) | **269** |
| 게시 위젯 보유 상품 | 193 |
| **게시 위젯이 없는 판매 상품** | **77** ⚠ |

> ⚠ **런칭 관점 결함 후보**: 판매중 상품 269개 중 **77개가 게시 위젯 없음** → 그 상품은 카탈로그(`/catalog`)에 나오지 않고 주문 페이지를 구성할 수 없다. **런웨이 체크리스트 항목으로 세워야 한다.**

### 8.3 사이트 키 · 허용 도메인 (라이브 실측)

| 항목 | 상태 |
|---|---|
| 등록 사이트 | **`SITE_OWN`(자사) 1개뿐** |
| `site_key` | 설정됨 (공개값 — 임베드 태그에 노출) |
| `svr_key_hash` (서버키) | **설정됨** — cart/* 4종 + item_id 방식 order/register 에 필수 |
| `allow_domains` | `huni-printing.vercel.app`, `huni-skin-shopby.vercel.app`, `printly.co.kr`, `huni-admin-production.up.railway.app`, `huni-admin-test-production.up.railway.app`, `localhost`, `127.0.0.1`, `shopby.huniprinting.co.kr`, `shopby.huniprinting.com`, `shopby.huniprint.co.kr` |

- 등록 도메인의 **하위 도메인 자동 포함**. `localhost`/`127.0.0.1` 은 포트 무관.
- ⚠ **Vercel 브랜치 미리보기 주소는 별도 등록 필요** — `myshop-git-dev-team.vercel.app` 는 다른 호스트라 `origin_not_allowed` 403 (SDK 가이드 §1).
- ⚠ 목록에 **운영 자사몰 최종 도메인이 무엇인지 미확인** — `printly.co.kr`·`shopby.huniprinting.co.kr` 등 후보가 여럿이다.
- 서버-투-서버 예외(Origin 없음 허용): `/handoff/verify`, `/handoff/requote`, `/guides`, `/main-images`, `cart/*`, `/order/register`

---

## 9. 매뉴얼 누락 후보 (개발자 전달 대상)

`huni-webadmin-manual-first.md` 절차대로, **매뉴얼이 답하지 않아 실화면·코드·DB 로 확정한 항목**을 기록한다.

| # | 항목 | 매뉴얼 상태 | 확정 근거 |
|---|---|---|---|
| 1 | **`WGT_CTRL_TYPE.04` 컬러칩** | 매뉴얼 `CTRL_TYPES` 목록에 **없음** | 라이브 DB `t_cod_base_codes` |
| 2 | `.19 부속 색상` · `.20 책등/표지 사이즈` 스크린샷 | 원고 주석: 「캡쳐는 아직 없다 … 데모 상품 데이터 준비 필요」 | 원고 자체 명시 |
| 3 | 위젯빌더 매뉴얼 `validate()` 게이트 범위 | `.01~.16` 만 강제 — `.17~.20` 은 게이트 밖 | `widget_manual_content.py` `validate()` |
| 4 | **SDK 개발가이드·라이브 데모의 존재** | 운영자 매뉴얼 `OVERVIEW` 사이드바 지도에 **「개발자 문서(외부 공개)」 그룹이 없다** | 라이브 사이드바 실화면 |
| 5 | `props` 키 전수 | 컴포넌트별 속성 설명은 있으나 **props JSON 키 이름 대조표는 없음** | 라이브 `cfg.items[].props` |

---

## 10. 미확인

1. **`cfg_ver` 의 현재 값과 지원 범위** — 라이브 관측값은 `1` 뿐. `cfg_ver_unsupported` 가 어느 값에서 나는지 미확인.
2. **`theme_opts`** — 라이브 두 위젯 모두 `null`. 실제로 쓰이는 상품이 있는지 미확인.
3. **`block_typ_cd`(제약 위반 시 비활성/숨김) 의 렌더 동작** — 제약 규칙이 있는 위젯을 라이브로 관찰하지 못했다(관찰한 두 위젯 모두 `constraints.rules = []`).
4. **`t_wgt_widget_items` 에 `del_yn` 컬럼이 없다** — 항목 삭제가 물리삭제인지 미확인(§4 분포는 전체 행 기준).
5. **작성중 239건의 성격** — 개발 중인 것인지, 버려진 것인지, 데모(`[메뉴얼]` 접두) 인지 구분하지 않았다.
6. **운영 최종 도메인** — `allow_domains` 10개 중 무엇이 런칭 대상인지 미확인.
7. **매뉴얼 HTML 생성본과 원고의 동기 여부** — 원고(`*.py`)만 읽었고 `docs/*.html` 재생성 시점은 미확인.

---

## 부록 — 재현 명령

```bash
# 코드표(읽기전용)
psql "$DATABASE_URL" -At -c "SELECT cod_cd, cod_nm FROM t_cod_base_codes
  WHERE upr_cod_cd IN ('WGT_CTRL_TYPE','WGT_SRC_TYPE','WGT_BLOCK_TYPE','WGT_STS_TYPE')
  ORDER BY upr_cod_cd, cod_cd;"

# 위젯 구성 원본(읽기전용 GET · 브라우저 Origin 필요)
GET https://huni-admin.printly.co.kr/api/w/v1/widgets/WGT_000288?site_key=<site_key>

# 라이브 위젯 실동작(주문 직전까지)
https://huni-admin.printly.co.kr/sdk/demo/?wgt=WGT_000288
```
