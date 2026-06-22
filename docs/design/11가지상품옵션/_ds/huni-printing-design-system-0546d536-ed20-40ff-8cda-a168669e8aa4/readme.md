# Huni printing — Design System

A design system for **Huni printing** (후니프린팅), a Korean print-on-demand / custom
printing service. Customers pick a print product (stickers, photobooks, calendars,
acrylic goods, posters, stationery…), configure it through a rich **option
configurator** (size, paper, print method, cutting, finishing), and order it. The
system captures the calm, utilitarian, purple-accented UI that runs that flow.

> **Source:** reconstructed from the attached Figma file `huni_product_option.fig`
> (pages: `option_NEW`, `Component`, `Design`, `page`, `Detail-Page`, `Concept`).
> The `Component` page is the original design-system documentation; `option_NEW`
> documents every option-group pattern; `PRODUCT_*_OPTION` frames are full product
> screens. No live URL or codebase was provided — store these references in case the
> reader has access. Everything here was rebuilt from that file's vector/JSX data,
> not from screenshots alone.

---

## CONTENT FUNDAMENTALS — how Huni writes

- **Language:** Korean (UI), with English for system/marketing labels (BEST, NEW,
  UP, DESIGN) and units (mm, ea). Numbers use ko-KR grouping (`82,500원`).
- **Voice:** plain, instructional, service-desk polite. Sentences end in the
  `~요 / ~습니다` register: *"제작수량과 옵션을 선택해 주세요"*, *"3개의 체크항목 완료되었습니다"*,
  *"입력할 수 없어요"*, *"숫자만 입력해주세요"*.
- **Person:** addresses the customer implicitly (no aggressive "you"); the brand
  rarely speaks in the first person. Guidance is framed as gentle direction, not
  command.
- **Casing:** English labels are UPPERCASE for pins/badges (BEST/NEW), Title or
  lowercase for the wordmark (`Huni` + `printing`). Korean has no casing; tone is
  carried by particle/ending choice.
- **Microcopy patterns:** action buttons are verb-final noun phrases —
  *장바구니 담기* (add to cart), *에디터로 디자인하기* (design in editor),
  *PDF파일 직접 올리기* (upload PDF directly), *열기 / 닫기* (open / close).
  Option group titles are short nouns — *사이즈, 종이, 인쇄, 커팅, 제작수량, 후가공*.
- **Emoji:** none. The brand never uses emoji. Status/among-text emphasis is done
  with color (purple) and the circular `!`/`i` callout glyph instead.
- **Vibe:** trustworthy print shop meets clean SaaS configurator — precise,
  quietly confident, never playful-cute.

---

## VISUAL FOUNDATIONS

- **Color:** one dominant brand purple — **`#5538B6`** ("main color") — over a
  large warm-neutral gray field. Purple appears as tints (`#EEEBF9 → #9580D9`) for
  hover/selected surfaces and a deep `#351D87` for hover-fill / pressed states.
  Neutrals run white → `#F6F6F6` → `#CACACA` (default border) → `#979797`
  (secondary text) → `#424242` (headings). A small **경고칼라 (warning/accent)** set —
  amber `#E6B93F`, teal `#7AC8C4`, orange `#DF7939`, red `#E60012` — is reserved for
  labels and status. The palette is overwhelmingly white + gray with purple doing
  all the "interactive" signaling.
- **Type:** a single family — **Noto Sans** (+ **Noto Sans KR** for Hangul). The
  brand signature is **tight tracking (−5%, `--tracking-tight`)** applied at every
  size; buttons go tighter (−7%). Four weights in play: Regular / Medium / SemiBold
  / Bold. Body workhorse is **14px**; option titles 16px; headings 24px; display 36px.
- **Spacing & layout:** calm 4px grid. The configurator sits in a fixed **466px**
  right column beside a flexible image gallery, inside an `1180px` container.
  Controls are **50px** tall (compact actions 40px). Generous vertical rhythm
  between option groups (24px).
- **Backgrounds:** flat white. **No gradients, no photography baked into chrome, no
  textures or patterns.** Product imagery (when present) sits in clean 2px-radius
  frames; the source had only gray placeholders.
- **Borders do the work:** almost every control is defined by a 1px `#CACACA`
  border on white. Selected = swap border to purple + text to purple (fill stays
  white). This "outline-select" pattern is the system's signature interaction.
- **Corners:** gentle — **5px** on buttons/inputs/selects, 4px on chips/labels,
  8px on cards, 2px on image frames, full circles on radios & color chips.
- **Shadows:** minimal. Reserved for floating surfaces — dropdown lists get a soft
  `0 4px 16px rgba(35,24,21,.10)`; focus uses a 3px purple ring. Flat controls
  carry no shadow.
- **Cards:** white, 8px radius, 1px hairline (`#E9E9E9/#F6F6F6`) border, little or
  no shadow. Quiet containers, not floating panels.
- **Animation:** restrained. Color/border transitions ~120–150ms ease on
  hover/select; chevrons rotate on open; toast slides up + fades. No bounces, no
  decorative motion.
- **Hover / press states:** filled primary darkens (`#5538B6 → #351D87`); outline
  buttons fill a faint tint (gray-50 for neutral, purple-50 for brand); press
  scales the button very slightly (0.99). Option cells fill gray-50 on hover.
- **Transparency / blur:** essentially unused. Surfaces are opaque.
- **Imagery vibe:** practical product shots on white (warm-neutral), not moody or
  cinematic.

---

## ICONOGRAPHY

- **Style:** light **line icons**, ~1.6–1.8px stroke, rounded caps/joins, 24px grid
  — drawn inline as SVG (account/menu/search/cart, upload, edit pencil, chevrons,
  the registration `+`). There is no embedded icon font or sprite in the source;
  icons are individual vectors.
- **Brand motif:** the **CMYK registration / crop mark** — four process-color ticks
  (cyan/magenta/yellow/key) forming a "+". It rides at the top-right of the wordmark
  and doubles as a standalone accent. Stored at `assets/cmyk-mark.svg` and exported
  as the `RegistrationMark` component. **Never recolor it to purple.**
- **Status glyphs:** a circular outlined **`!`** (info / required) and **`i`**
  appear throughout the configurator and in `Callout` — small, low-contrast, the
  brand's way of attaching guidance without a heavy alert.
- **Unicode:** the source uses `▼` for some select chevrons; we render real SVG
  chevrons instead for crispness. Stars (reviews) are SVG, filled amber.
- **Emoji:** never.
- If you need an icon not present here, match the line style above (Lucide /
  Feather are the closest CDN families) and keep the 1.6px stroke.

---

## INDEX — what's in this project

**Foundations** (`styles.css` → `tokens/`)
- `tokens/colors.css` · `tokens/typography.css` · `tokens/spacing.css` ·
  `tokens/fonts.css` · `tokens/base.css`. Link `styles.css` to get everything.

**Components** (`components/`) — React primitives, each with `.d.ts` + `.prompt.md`
- `brand/` — **Logo**, **RegistrationMark**
- `forms/` — **Button**, **SelectBox**, **TextField**, **Checkbox**, **Radio**,
  **QuantityStepper**, **Slider**
- `feedback/` — **Badge** (BEST/NEW/UP/DESIGN + chips), **Callout**
- `navigation/` — **Tabs**, **Pagination**
- `product/` — **OptionField**, **OptionButtonGroup**, **ColorChip**,
  **PriceSummary**, **FinishSection**

**UI kit** (`ui_kits/huni_printing/`)
- Full interactive product-configurator page. See its `README.md`.

**Specimen cards** (`guidelines/`) — Colors, Type, Spacing, Brand cards that
populate the Design System tab.

**Assets** (`assets/`) — `cmyk-mark.svg` (the registration mark).

**`SKILL.md`** — makes this folder usable as a downloadable Agent Skill.

---

## Usage

Consumers link the one stylesheet and read components off the window namespace:

```html
<link rel="stylesheet" href="styles.css">
<script src="_ds_bundle.js"></script>
<script type="text/babel">
  const { Button, OptionButtonGroup, PriceSummary } = window.HuniPrintingDesignSystem_0546d5;
</script>
```

### Caveats
- **Fonts** load via a Google Fonts `@import` in `tokens/fonts.css` (Noto Sans +
  Noto Sans KR — exact matches, no substitution). They are not local `@font-face`
  binaries, so the compiler reports "0 fonts"; this is expected and they still load.
- Product **gallery imagery** is placeholder-only (the Figma had no embedded photos).
