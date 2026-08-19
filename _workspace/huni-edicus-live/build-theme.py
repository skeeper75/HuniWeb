#!/usr/bin/env python3
"""
후니프린팅 Edicus 편집기 테마 빌더 (private_css)

■ 이 파일이 지키는 경계
  private_css 는 Edicus SDK 의 deferred param 5개 중 하나다.
  URL 에 wait_private_css=true 를 실어 보내면 iframe 이
  {type:"from-edicus-private", action:"waiting-for-extra-param"} 으로 되묻고,
  호스트가 {name:"private_css", private_css:"<CSS 문자열>"} 을 postMessage 로 넘긴다.
  근거: raw/cap-260819/RedEditorSDK.min.js (Qe._add_common_url_param / _set_deferred_params)

  넘길 수 있는 건 CSS 문자열 하나뿐이고, 그 CSS 가 걸 수 있는 손잡이는
  Edicus 전역 스타일시트의 theme-* 클래스 86개다. 그 86개가 정의한 속성을
  세어 보면 색(background-color / color / border-color / outline-color / fill)이
  거의 전부다. 레이아웃·구조·아이콘·문구는 손잡이가 없다.

  그래서 이 빌더는 [경계 검사]를 건다 —
  순정 클래스가 정의하지 않은 속성을 쓰면 빌드가 실패한다.
  (예외는 ALLOW_EXTRA 에 이유와 함께 명시한 것만)

■ 레이아웃을 바꾸고 싶다면 여기가 아니다
  editor_type · parent_type · master_mode · ui_style · force_plugin ·
  plugin_param · unlayers 같은 URL 파라미터, 또는 편집기 셸 선택
  (editor_landing / lite / preview / tnview) 이 담당한다. 전부 Edicus 쪽.

실행:  python3 build-theme.py
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).parent
STOCK = ROOT / "raw" / "edicus-original-styles.css"

# 순정이 정의하지 않은 속성을 예외로 허용하는 곳.
# 지금은 비어 있다 — 색 말고는 아무것도 덮어쓰지 않는다는 뜻이다.
# 여기에 무언가 추가하려면 반드시 이유를 함께 적을 것.
ALLOW_EXTRA: dict = {}


def stock_props():
    """순정 theme-* 클래스가 실제로 정의한 속성 목록."""
    css = STOCK.read_text()
    out = {}
    for sel, body in re.findall(r"([^{}@]+)\{([^{}]*)\}", css):
        names = re.findall(r"\.(theme-[\w-]+)", sel)
        if not names:
            continue
        props = {d.split(":")[0].strip() for d in body.split(";") if ":" in d}
        for n in names:
            out.setdefault(n, set()).update(props)
    return out


# ── 후니 디자인시스템 토큰 ─────────────────────────────────────
# 출처: docs/design/11가지상품옵션/_ds/huni-printing-design-system-*/tokens/
#       colors.css · spacing.css (이름과 값을 그대로 가져온다)
# Edicus iframe 은 외부 CSS 를 못 불러오므로 필요한 만큼만 여기에 옮겨 적는다.
TOKENS = """/* ── 후니 디자인시스템 토큰 ───────────────────────────────────
   출처: docs/design/11가지상품옵션/_ds/huni-printing-design-system-…/tokens/colors.css
   이름과 값을 DS 패키지에서 그대로 가져왔다. 값을 여기서 고치지 말고
   DS 패키지를 고친 뒤 이 블록을 다시 옮겨 적을 것.
   Edicus iframe 은 외부 스타일시트를 못 불러와 @import 를 못 쓴다.

   :root 와 .app-main 두 곳에 건다 — private_css 가 문서 루트에 붙는지
   컴포넌트 하위에 붙는지 확인되지 않았다. */
:root,
.app-main {
  /* 브랜드 보라 */
  --huni-purple-50:  #EEEBF9;
  --huni-purple-100: #DED7F4;
  --huni-purple-200: #C9C2DF;
  --huni-purple-400: #9580D9;
  --huni-purple-600: #5538B6;   /* MAIN COLOR */
  --huni-purple-800: #351D87;

  /* 중립 */
  --huni-white:    #FFFFFF;
  --huni-gray-50:  #F6F6F6;
  --huni-gray-100: #E9E9E9;
  --huni-gray-200: #CACACA;
  --huni-gray-400: #979797;
  --huni-gray-600: #565656;
  --huni-gray-800: #424242;

  /* 경고칼라 */
  --huni-red: #E60012;

  /* 의미 별칭 — DS 의 이름을 그대로 쓴다 */
  --color-brand:         var(--huni-purple-600);
  --color-brand-strong:  var(--huni-purple-800);
  --color-brand-soft:    var(--huni-purple-400);
  --color-brand-surface: var(--huni-purple-50);

  --text-heading:   var(--huni-gray-800);
  --text-body:      var(--huni-gray-600);
  --text-secondary: var(--huni-gray-400);
  --text-on-brand:  var(--huni-white);
  --text-brand:     var(--huni-purple-600);

  --surface-page:        var(--huni-white);
  --surface-muted:       var(--huni-gray-50);
  --surface-hover:       var(--huni-gray-50);
  --surface-brand-hover: var(--huni-purple-50);
  --surface-brand-press: var(--huni-purple-100);

  --border-default:  var(--huni-gray-200);
  --border-hairline: var(--huni-gray-100);
  --border-brand:    var(--huni-purple-600);

  --color-disabled-fill: var(--huni-gray-200);
  --color-disabled-text: var(--huni-gray-400);
  --color-error:         var(--huni-red);
}
"""

HEADER = """/* ── 헤더 ─────────────────────────────────────────────────────
   순정: 하늘색 #64c2ff 바탕 + 흰 글자.
   후니: 흰 바탕 + 진한 글자.
   ※ RedPrinting 실측에서도 헤더가 이미 흰색이었다
     (raw/edicus_dom.json · div.app-header 의 bg = rgb(255,255,255)).

   DS hover 규칙(readme.md VISUAL FOUNDATIONS):
     "outline buttons fill a faint tint — gray-50 for neutral,
      purple-50 for brand / filled primary darkens #5538B6 → #351D87" */
.theme-header-bg            { background-color: var(--surface-page) }
.theme-header-border        { border-color:     var(--border-default) }
.theme-header-separator     { background-color: var(--border-default) }
.theme-header-text          { color: var(--text-heading) }

/* 헤더의 실행취소·미리보기 등은 중립 버튼 → hover 는 gray-50 */
.theme-header-btn           { color: var(--text-body) }
.theme-header-btn:hover     { background-color: var(--surface-hover) }
.theme-header-btn:active    { background-color: var(--border-hairline) }
.theme-header-btn[disabled=true] { color: var(--color-disabled-text) }

/* 장바구니 = filled primary → hover 는 purple-800 */
.theme-header-cart-btn      { color: var(--text-on-brand);
                              background-color: var(--color-brand) }
.theme-header-cart-btn:hover{ background-color: var(--color-brand-strong) }

/* 실패 버튼 — DS 에 오류색이 있다(--color-error #E60012) */
.theme-header-fail-btn      { color: var(--text-on-brand);
                              background-color: var(--color-error) }
.theme-header-fail-btn:hover{ background-color: var(--color-error) }
"""

LIGHT_TABS = """/* ── 탭 ───────────────────────────────────────────────────────
   순정: 다크 #3e4553 / #262c33 바탕. */
.theme-tab-btn              { color: var(--text-secondary) }
.theme-tab-btn.active-tab   { color: var(--text-brand);
                              background-color: var(--color-brand-surface) }
.theme-tab-border           { border-color:     var(--border-default) }
.theme-tab-wing             { background-color: var(--surface-muted) }
.theme-tab-panel-body       { background-color: var(--surface-page) }
.theme-tab-input-box        { outline: 1px solid var(--border-default) }
"""

LIGHT_PANEL = """/* ── 좌측 도구 패널 ───────────────────────────────────────────
   순정 다크(#3e4553 / #626b7c)를 라이트로 뒤집는다. */
.theme-panel-border,
.theme-panel-toolbar,
.theme-panel-print-option-border { border-color: var(--border-default) }

.theme-panel-section-header { color: var(--text-body) }

.theme-panel-round-btn      { border-color:     var(--border-default);
                              color:            var(--text-heading);
                              background-color: var(--surface-page) }
.theme-panel-round-btn:hover  { background-color: var(--surface-hover) }
.theme-panel-round-btn:active { background-color: var(--border-hairline) }

.theme-panel-toolbar-btn                 { color: var(--text-secondary) }
.theme-panel-toolbar-btn:hover           { border-color: var(--color-brand-soft) }
.theme-panel-toolbar-btn[active=true]    { color:        var(--text-brand);
                                           border-color: var(--border-brand) }

/* 썸네일·소재 타일 — DS 서명 패턴: 선택은 채우기가 아니라 보라 테두리 */
.theme-panel-item           { outline-color: var(--border-default);
                              border-color:  var(--border-default) }
.theme-panel-item:hover     { outline-color: var(--color-brand-soft);
                              border-color:  var(--color-brand-soft) }
.theme-panel-item:active    { outline-color: var(--border-brand);
                              border-color:  var(--border-brand) }

.theme-panel-text-btn       { color: var(--text-heading) }
.theme-panel-text-btn:hover { background-color: var(--surface-hover) }

.theme-panel-print-highlight         { color: var(--text-brand) }
.theme-panel-print-counter-btn       { color: var(--text-secondary) }
.theme-panel-print-counter-btn:hover { color: var(--text-brand) }
"""

LIGHT_INVERT = """/* ── 라이트 패널에서 뒤집어야 하는 것들 ───────────────────────
   순정이 hsla(0,0%,100%,…) 흰 글씨로 되어 있는 요소들.
   패널을 라이트로 바꾸면 흰 배경에 묻혀 사라진다.
   B안(다크 패널)에는 이 블록이 없다 — 거기선 순정이 맞다. */
.theme-var-tab-title        { color: var(--text-body) }
.theme-simple-select-box,
.theme-vdp-list             { color: var(--text-body) }
.theme-vdp-input-title      { color: var(--text-secondary) }
.theme-vdp-text-btn         { color: var(--text-secondary) }
.theme-vdp-text-btn:hover   { color: var(--text-brand) }
.theme-vdp-text-btn:active  { color: var(--color-brand-strong) }
.theme-vdp-text-heighlight  { color: var(--text-heading) }
.theme-vdp-input-box        { background-color: var(--surface-muted) }

/* 선택 테두리 — DS 서명 패턴(outline-select) */
.theme-select-box-style     { border: 1px solid var(--border-default) }
.theme-select-box-style-m   { border: 2px solid var(--border-brand) }

/* 순정은 흰 테두리 4px — 흰 배경에서는 안 보인다 */
.theme-thumbnail-box:hover[active=false],
.theme-thumbnail-box[active=true] { outline: 4px solid var(--border-brand) }

.theme-print-pc-btn         { background-color: var(--color-brand) }
.theme-uneditable-box       { background-color: rgba(53,29,135,.55) }

/* .theme-item-bg-white/light/dark/none 은 손대지 않는다 —
   고객이 사진 배경으로 고르는 값이지 UI 색이 아니다.
   .theme-photo-filename(흰 글씨)도 사진 썸네일 위에 얹히므로 그대로. */
"""

LIGHT_CANVAS = """/* ── 캔버스 · 눈금자 ──────────────────────────────────────────
   순정 #efefed 는 DS 팔레트에 없다. 가장 가까운 gray-100 으로 맞춘다. */
.theme-canvas-body          { background-color: var(--huni-gray-100) }
.theme-canvas-overmask      { background-color: rgba(233,233,233,.90) }
.theme-canvas-border-path   { fill: var(--huni-gray-100) }

.theme-ruler-frame          { color:            var(--text-secondary);
                              border-color:     var(--border-default);
                              background-color: var(--surface-page) }
.theme-ruler-origin-box     { background-color: var(--surface-page) }
.theme-ruler-origin-box-h   { border-top: 1px dotted var(--border-default) }
.theme-ruler-origin-box-v   { border-left: 1px dotted var(--border-default) }

/* 캔버스 위 버튼 — 고객 작업물 위라 대비가 우선.
   순정의 검정 반투명을 유지하되 후니 딥퍼플로 물들인다. */
.theme-canvas-plugin-btn        { background-color: rgba(53,29,135,.55) }
.theme-canvas-plugin-btn:hover  { background-color: rgba(53,29,135,.78) }
.theme-canvas-plugin-btn:active { background-color: var(--color-brand-strong) }
.theme-canvas-bottom-btn        { background-color: var(--color-brand) }
.theme-canvas-bottom-btn:hover  { background-color: var(--color-brand-strong) }

/* 빈 사진칸 — 순정 하늘색 #add8e6 → 후니 연보라 */
.theme-cell-empty           { fill: var(--huni-purple-100) }
"""

MODAL = """/* ── 모달 · 다이얼로그 · 셀렉트박스 ───────────────────────────
   순정은 파란색(#61a5f4 / #64c2ff / #2284f4) 계열이라
   손대지 않으면 편집 중 팝업만 파랗게 뜬다. */
.theme-modal-title-bar      { background-color: var(--color-brand) }
.theme-modal-button         { background-color: var(--color-brand) }
.theme-modal-button-gray    { background-color: var(--color-disabled-fill) }
.theme-modal-item           { outline-color: var(--border-default);
                              border-color:  var(--border-default) }
.theme-modal-item:hover     { outline-color: var(--color-brand-soft);
                              border-color:  var(--color-brand-soft) }
.theme-modal-item:active    { outline-color: var(--border-brand);
                              border-color:  var(--border-brand) }

/* 닫기·삭제 — DS --color-error */
.theme-dialog-btn:hover     { background-color: var(--color-error) }

.theme-white-select-box            { background-color: var(--color-brand) }
.theme-white-select-item-selected  { background-color: var(--color-brand-strong) }

.theme-print-preview-box    { background-color: var(--surface-muted) }
"""

DROPDOWN = """/* ── 드롭다운 ─────────────────────────────────────────────────
   DS Select box: hover 배경 gray-50 */
.theme-ui-dropdown-item:hover,
.theme-ui-dropdown-item:active { color: var(--text-brand) }
"""

PLUGIN = """/* ── 플러그인(슬라이더 등) — CSS 변수로 열려 있음 ─────────────
   DS Slider: track gray-200 · active track / thumb purple-600 */
.theme-plugin,
.theme-plugin.m2 {
  --normal-color:  #5538B6;
  --hover-color:   rgba(85,56,182,.90);
  --active-color:  rgba(53,29,135,.97);
  --track-color:   #CACACA;
  --thumb-color:   #5538B6;
  --select-color:  #5538B6;
}
.theme-plugin-button        { background-color: var(--color-brand) }
.theme-plugin-button:hover  { background-color: var(--color-brand-strong) }
.theme-plugin-button:active { background-color: var(--color-brand-strong) }
"""

DARK_BODY = """/* ── 탭 ───────────────────────────────────────────────────────
   Edicus 기본 다크면을 유지하고 강조색만 후니 보라로 바꾼다.
   다크 위에서 purple-600 은 너무 어두워 안 읽히므로
   DS 의 purple-400(--color-brand-soft)을 강조색으로 쓴다. */
.theme-tab-btn              { color: #8c919d }
.theme-tab-btn.active-tab   { color: var(--color-brand-soft) }

/* ── 좌측 도구 패널 ─────────────────── (다크면 유지, 강조만 보라) */
.theme-panel-round-btn:hover             { border-color: var(--color-brand-soft) }
.theme-panel-toolbar-btn:hover           { border-color: var(--color-brand-soft) }
.theme-panel-toolbar-btn[active=true]    { color:        var(--color-brand-soft);
                                           border-color: var(--color-brand-soft) }
.theme-panel-item:hover     { outline-color: var(--color-brand-soft);
                              border-color:  var(--color-brand-soft) }
.theme-panel-item:active    { outline-color: var(--huni-white);
                              border-color:  var(--huni-white) }
.theme-panel-print-highlight         { color: var(--color-brand-soft) }
.theme-panel-print-counter-btn:hover { color: var(--color-brand-soft) }

/* ── 캔버스 ───────────────────────────────────────────────────
   캔버스 주변은 순정 회색 그대로. 어두운 패널과 대비되어
   작업물이 도드라지는 것이 B안의 존재 이유다. */
.theme-canvas-bottom-btn       { background-color: var(--color-brand) }
.theme-canvas-bottom-btn:hover { background-color: var(--color-brand-strong) }
.theme-cell-empty              { fill: var(--huni-purple-200) }
"""

OPEN_ITEMS = """
/* ⚠ private_css 로는 못 하는 것 — Edicus 쪽에 요청해야 한다
   근거: raw/cap-260819/RedEditorSDK.min.js (Qe._add_common_url_param)

   편집기 URL 공통 파라미터 30개 중 화면 구성을 가르는 것들:
     editor_type · parent_type · master_mode · ui_style ·
     force_plugin · plugin_param · unlayers · edit_lock · unit_page
   편집기 셸 자체도 넷이다:
     /ed#/editor_landing · /ed#/lite/landing ·
     /ed#/preview/landing · /ed#/tnview/landing

   그래서 이 파일로는 다음을 할 수 없다 —
     · 좌측 도구 레일의 위치·순서·아이콘 종류
     · 없던 옵션 패널 추가 (customTabInfo 는 상품 데이터 쪽)
     · 「모양컷」 같은 전용 도구 (force_plugin / plugin_param)
     · 버튼 모서리 반경, 자간, 여백, 컨트롤 높이
       (순정 theme-* 가 이 속성들을 노출하지 않는다)
     · theme-cell-empty-icon 아이콘 교체 (배경이미지가 별도 SVG 파일)

   ■ 로고를 넣지 않는 이유
     순정 스타일시트에 .theme-header-logo 슬롯이 있고 흰 워드마크
     SVG(103x15)를 배경이미지로 물고 있다. 하지만 실측 DOM
     (raw/edicus_dom.json)에 그 클래스를 단 노드가 하나도 없다 —
     app-header 의 자식은 header-left / header-middle / header-right 뿐이고
     header-left 안에는 product-info-box(상품명)가 들어 있다.
     즉 이 배포에서는 렌더링되지 않는 슬롯이다.

     배경이미지를 갈아끼워도 아무 데도 안 보이고, 혹시 다른 설정에서
     렌더링되면 이미 상품명이 앉아 있는 자리와 겹친다. 그래서 넣지 않는다.
     편집기에 후니 로고를 세우는 일은 Edicus 쪽에 요청할 항목이다.

   [미검증] run_mode=standard 전환 전이라 아직 적용해 본 적이 없다
            (FINDINGS.md G0). !important 없이 먹는지도 미확인 —
            주입 순서가 확인되면 필요한 곳에만 붙인다.
*/
"""


def banner(title, note):
    return f"""/* ============================================================
   후니프린팅 Edicus 편집기 테마 — {title}
   생성물: build-theme.py 가 만든다. 이 파일을 직접 고치지 말 것.
   토큰:   docs/design/…/_ds/huni-printing-design-system-…/tokens/
   근거:   raw/edicus-original-styles.css (순정 theme-* 실측)
           raw/cap-260819/RedEditorSDK.min.js (private_css 전달 경로)
   주입:   wait_private_css=true → from-edicus-private /
           waiting-for-extra-param → postMessage {{name:"private_css"}}
   범위:   색만. 레이아웃·구조는 Edicus 쪽 파라미터 소관 (아래 주석 참조)
   {note}
   ============================================================ */
"""


FILES = {
    "edicus-huni-theme.css": (
        banner("정본 (A안 · 전체 라이트)",
               "SDK 가 실제로 주입하는 정본.\n           theme-compare/theme-light.css 는 비교용 사본."),
        [TOKENS, HEADER, LIGHT_TABS, LIGHT_PANEL, LIGHT_INVERT,
         LIGHT_CANVAS, MODAL, DROPDOWN, PLUGIN, OPEN_ITEMS],
    ),
    "theme-compare/theme-light.css": (
        banner("A안 · 전체 라이트 (비교용)",
               "정본 ../edicus-huni-theme.css 와 같은 내용."),
        [TOKENS, HEADER, LIGHT_TABS, LIGHT_PANEL, LIGHT_INVERT,
         LIGHT_CANVAS, MODAL, DROPDOWN, PLUGIN, OPEN_ITEMS],
    ),
    "theme-compare/theme-dark.css": (
        banner("B안 · 패널 다크 (비교용)",
               "헤더만 후니 흰 헤더로 바꾸고 패널·캔버스는\n           Edicus 기본 다크 유지. 강조색은 purple-400."),
        [TOKENS, HEADER, DARK_BODY, MODAL, DROPDOWN, PLUGIN, OPEN_ITEMS],
    ),
}



def add_important(css):
    """theme-* 규칙의 선언에 !important 를 붙인다.

    private_css 가 순정 스타일시트보다 먼저 주입되는지 나중인지 확인되지 않았다.
    선택자 특정도가 순정과 같으므로(단일 클래스), 순서가 앞이면 우리 규칙이 진다.
    주입 순서가 확인되면 이 함수를 빼는 것이 낫다 — 그때까지는 보험.

    토큰 블록(:root/.app-main)과 .theme-plugin 의 --*-color 커스텀 속성은
    건드리지 않는다. 전자는 변수 선언이고, 후자는 플러그인이 읽어 가는 공식 손잡이다.
    """
    def fix(m):
        sel, body = m.group(1), m.group(2)
        if not re.search(r"\.theme-[\w-]+", sel):
            return m.group(0)
        out = []
        for d in body.split(";"):
            if ":" not in d:
                out.append(d); continue
            prop = d.split(":")[0].strip()
            if prop.startswith("--") or "!important" in d:
                out.append(d); continue
            out.append(d.rstrip() + " !important")
        return f"{sel}{{{';'.join(out)}}}"

    # 주석은 건드리지 않도록 잘라 두고 처리한 뒤 되돌린다
    stash = []
    def keep(m):
        stash.append(m.group(0)); return f"\x00{len(stash)-1}\x00"
    tmp = re.sub(r"/\*.*?\*/", keep, css, flags=re.S)
    tmp = re.sub(r"([^{}]+)\{([^{}]*)\}", fix, tmp)
    return re.sub(r"\x00(\d+)\x00", lambda m: stash[int(m.group(1))], tmp)


def check_boundary(css, stock):
    """순정이 정의하지 않은 속성을 쓴 곳을 찾아낸다."""
    body = re.sub(r"/\*.*?\*/", "", css, flags=re.S)
    bad = []
    for sel, decl in re.findall(r"([^{}]+)\{([^{}]*)\}", body):
        classes = re.findall(r"\.(theme-[\w-]+)", sel)
        if not classes:
            continue                      # :root / .app-main 토큰 블록
        for d in decl.split(";"):
            if ":" not in d:
                continue
            prop = d.split(":")[0].strip()
            if prop.startswith("--"):
                continue                  # theme-plugin 은 CSS 변수가 공식 손잡이
            for c in classes:
                if prop in stock.get(c, set()):
                    continue
                if (c, prop) in ALLOW_EXTRA:
                    continue
                # border-top-color 처럼 순정의 border-top 을 좁힌 형태는 허용
                root = prop.rsplit("-", 1)[0]
                if root in stock.get(c, set()):
                    continue
                bad.append((c, prop, sel.strip()[:60]))
    return bad


def main():
    stock = stock_props()
    failures = []
    for path, (head, blocks) in FILES.items():
        css = head + "\n" + "\n".join(blocks)
        bad = check_boundary(css, stock)   # !important 붙이기 전에 검사
        css = add_important(css)
        out = ROOT / path
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(css, encoding="utf-8")
        n_rules = len(re.findall(r"\{", re.sub(r"/\*.*?\*/", "", css, flags=re.S)))
        print(f"  {path:32s} {out.stat().st_size:7,}B  규칙 {n_rules:3d}개  "
              f"경계위반 {len(bad)}건")
        for c, p, s in bad:
            print(f"      ✗ .{c} 에 {p} — 순정에 없는 속성 ({s})")
        failures += bad


    if failures:
        print(f"\n  ✗ 경계 위반 {len(failures)}건 — private_css 범위를 넘었다.")
        sys.exit(1)
    print("\n  ✓ 경계 검사 통과 — 순정 theme-* 가 노출한 속성만 덮어썼다.")


if __name__ == "__main__":
    main()
