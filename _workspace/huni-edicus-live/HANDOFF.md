# huni-edicus-live — 다음 세션 시작점

> 최종 갱신: 2026-08-19 · 세션 `3be86da0`
> 이 파일만 읽고 재개하면 된다. 종합 사실은 `FINDINGS.md`.

---

## 지금 무엇이 되어 있나

Edicus 편집기에 후니 색을 입히는 **private_css** 3종이 완성돼 있고, 자동 검사를 통과한다.

```
edicus-huni-theme.css            15,673B  규칙 76개   ← 정본 (SDK 가 주입할 파일)
theme-compare/theme-light.css    15,625B  규칙 76개   ← A안 사본 (비교용)
theme-compare/theme-dark.css     11,367B  규칙 40개   ← B안 (패널 다크)
```

세 파일 모두 **`build-theme.py` 가 만든다. 직접 고치지 말 것.**
색 값을 바꾸려면 빌더의 `TOKENS` 블록만 고치고 `python3 build-theme.py` 를 다시 돌린다.

재생성·검사:
```bash
python3 build-theme.py     # 경계 위반이 있으면 exit 1
```

---

## 이 하네스의 [HARD] 규율 — 경계

**private_css 로 할 수 있는 것은 색뿐이다.** 이걸 지키느라 두 번 갈아엎었다.

근거 (`raw/cap-260819/RedEditorSDK.min.js`):
- private_css 는 SDK deferred param 5개 중 하나. `?wait_private_css=true` →
  `from-edicus-private / waiting-for-extra-param` → postMessage `{name:"private_css", private_css:"<CSS 문자열>"}`.
  **넘기는 것은 CSS 문자열 하나가 전부.**
- 손잡이는 순정 `theme-*` 클래스 86개. 그중 **70개가 색 속성만** 정의한다
  (`background-color` 45 · `color` 27 · `border-color` 18 · `outline-color` 6 · `fill` 2).

그래서 `build-theme.py` 에 **경계 검사**가 걸려 있다 — 순정이 정의하지 않은 속성을 쓰면 빌드가 실패한다.
현재 **허용 예외 0건**. 실제로 `letter-spacing` · `border-radius` · `display` · `padding` 을 물어서 막는 것을 확인했다.

### 하면 안 되는 것 (과거에 두 번 어겼다)
- 자간(`letter-spacing`) 넣기 — Edicus 툴바는 px 고정이라 글자 폭이 바뀌면 밀린다.
- 모서리(`border-radius`) 넣기 — 순정이 노출하지 않는다.
- **로고 주입** — `.theme-header-logo` 슬롯은 순정 CSS 에만 있고 **실측 DOM 에 그 클래스를 단 노드가 0개**다
  (`raw/edicus_dom.json`: `app-header` 의 자식은 `header-left`/`header-middle`/`header-right` 뿐,
  `header-left` 안은 `product-info-box`=상품명이 차지). 칠해도 안 보이고, 렌더링되면 상품명과 겹친다.
- 편집기 목업 그리기 — 레이아웃을 못 바꾸는데 바꿀 수 있는 것처럼 보이게 만든다.

---

## 확정된 디자인 결정

| 항목 | 결정 | 정한 때 |
|---|---|---|
| 헤더 | 흰 바탕 + 진한 글자 | 지니 선택 260819 |
| A안·B안 | 둘 다 유지 (실화면에 붙여 비교) | 지니 선택 260819 |
| primary | `#5538B6` (`#553886` 아님) | DS 패키지 `tokens/colors.css` 로 확정 |
| 토큰 이름 | DS 패키지 것 그대로 (`--color-brand` 등) | — |
| 재단선·경고·보조선 | 손대지 않음 (기능 표시) | — |
| 로고 | 넣지 않음 | 지니 지시 260819 |

**디자인시스템 SOT** = `docs/design/11가지상품옵션/_ds/huni-printing-design-system-0546d536-…/tokens/`
(스킬 문서의 표가 아니라 이 패키지가 권위. `colors.css` · `spacing.css` · `readme.md`)

---

## 블로커

**G0 — `run_mode: passive` → `standard`.** 이게 안 풀리면 이 CSS 는 화면에 닿지 못한다.
`huni_editor_sdk.js:176,205` 한 줄. 상세 = `FINDINGS.md` §4, §11.

따라서 현재 3종 CSS 는 전부 **[미검증]** 이다. 실화면에서 확인할 것:
1. `!important` 없이도 먹는가 (주입 순서 미확인이라 지금은 전부 붙여 뒀다 — 먹으면 걷어낼 것)
2. `:root` 와 `.app-main` 중 어디에 토큰이 걸리는가 (몰라서 양쪽에 걸어 뒀다)
3. 다크 패널 A/B 중 실제로 어느 쪽이 나은가

---

## 남은 일

- [ ] `FINDINGS.md` §10 갱신 — theme-* 는 25종이 아니라 **86종**, 그중 70개가 색 전용
- [ ] `FINDINGS.md` §12 담당자 질문에 추가 — `ui_style` · `editor_type` · `master_mode` ·
      `force_plugin` 이 각각 무엇을 바꾸는가 (현재 질문 목록에 없다. 1순위 후보)
- [ ] 편집기 실제 진입 캡처 — 편집 버튼을 눌러 iframe URL 의 파라미터 조합을 뽑으면
      상품별 화면 차이를 확정할 수 있다. **프로젝트가 생성되므로 지니 확인 후 진행.**
- [ ] B안(다크) 유지 여부 — 헤더가 흰색으로 확정된 지금도 필요한가

---

## 건드리지 말 것

- `raw/` — 실측 원자료. 재캡처 비용이 크다.
  ★ 이 중 4개는 **실제 자격증명이 들어 있어 git 에 넣지 않았다**(`.gitignore` 참조):
  `key-events.jsonl` · `s2_bodies.json` · `cap-260819/{ACTHPEN,CLSTDLD}.json`.
  RedPrinting 자산 API 키 2종(Bearer …)과 JWT 23종. 로컬에만 있으니 지우지 말 것.
- `assets/huni-logo.png` — 참조하는 곳이 없는 채로 남겨 뒀다.
  원본 붙여넣기가 임시 파일이라 지우면 되살릴 수 없다. 편집기 밖(사이트 헤더 등)에서 쓸 수 있다.
- `theme-compare/theme-*.png` — 260818 세션의 화면 비교 캡처.

---

## 실측으로 확정한 사실 (이번 세션 추가분)

편집기 URL 공통 파라미터 **30개** (`Qe._add_common_url_param`):
```
partner mobile div lang ui_locale editor_type parent_type run_mode master_mode
edit_mode ui_style num_page max_page min_page unit_page max_order min_order
force_plugin plugin_param resapi_param unlayers edit_lock no_update clear_src
cal_date video_frames dev_apiHost dev_assetHost dev_uploadHost dev_resHost
```
편집기 셸 **4종**: `/ed#/editor_landing` · `/ed#/lite/landing` · `/ed#/preview/landing` · `/ed#/tnview/landing`
2단 핸드셰이크 `wait_*` **5종**: `wait_ddp` `wait_options` `wait_option_string` `wait_private_css` `wait_prod_info`

**상품 플래그로는 편집기 화면 차이를 설명할 수 없다.**
ACTHPEN(아크릴 젤펜)·CLSTDLD(티셔츠)는 `useKoiEditor:"Y"` · `useRPEditor:"N"` · `usePDF:"Y"` · `koiOption:[]` 이
완전히 같은데 편집기 화면이 다르다. 차이는 위 30개 파라미터 / 플러그인 / 셸 선택에서 온다 — 전부 Edicus 쪽.

상품페이지(편집기 아님) 쪽은 `item_gbn` + `skinInfo`(섹션별 `view_yn`)로 갈린다:
ACTHPEN=`vDigital_item`, CLSTDLD=`clothes2025_item`.

원자료 = `raw/cap-260819/` (두 상품 HTML·JSON·스크린샷 + `RedEditorSDK.min.js` + `productRedWidgetSDK.js`)
