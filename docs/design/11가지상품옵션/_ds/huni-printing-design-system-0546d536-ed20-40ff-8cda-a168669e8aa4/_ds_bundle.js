/* @ds-bundle: {"format":3,"namespace":"HuniPrintingDesignSystem_0546d5","components":[{"name":"Logo","sourcePath":"components/brand/Logo.jsx"},{"name":"RegistrationMark","sourcePath":"components/brand/Logo.jsx"},{"name":"Badge","sourcePath":"components/feedback/Badge.jsx"},{"name":"Callout","sourcePath":"components/feedback/Callout.jsx"},{"name":"Button","sourcePath":"components/forms/Button.jsx"},{"name":"Checkbox","sourcePath":"components/forms/Checkbox.jsx"},{"name":"QuantityStepper","sourcePath":"components/forms/QuantityStepper.jsx"},{"name":"Radio","sourcePath":"components/forms/Radio.jsx"},{"name":"SelectBox","sourcePath":"components/forms/SelectBox.jsx"},{"name":"Slider","sourcePath":"components/forms/Slider.jsx"},{"name":"TextField","sourcePath":"components/forms/TextField.jsx"},{"name":"Pagination","sourcePath":"components/navigation/Pagination.jsx"},{"name":"Tabs","sourcePath":"components/navigation/Tabs.jsx"},{"name":"ColorChip","sourcePath":"components/product/ColorChip.jsx"},{"name":"FinishSection","sourcePath":"components/product/FinishSection.jsx"},{"name":"OptionButtonGroup","sourcePath":"components/product/OptionButtonGroup.jsx"},{"name":"OptionField","sourcePath":"components/product/OptionField.jsx"},{"name":"PriceSummary","sourcePath":"components/product/PriceSummary.jsx"}],"sourceHashes":{"components/brand/Logo.jsx":"78d4cf03b0e8","components/feedback/Badge.jsx":"b28e37091d3a","components/feedback/Callout.jsx":"af43286e76f8","components/forms/Button.jsx":"a266e6e03a42","components/forms/Checkbox.jsx":"dfc875a8a1be","components/forms/QuantityStepper.jsx":"dfcc8118861a","components/forms/Radio.jsx":"ebc2d451e438","components/forms/SelectBox.jsx":"aa9aff03a8df","components/forms/Slider.jsx":"123dce10f944","components/forms/TextField.jsx":"c577984bb37b","components/navigation/Pagination.jsx":"a8b9e2baa3ca","components/navigation/Tabs.jsx":"bab6ac28b6da","components/product/ColorChip.jsx":"e296919c6537","components/product/FinishSection.jsx":"ca65d0e771d0","components/product/OptionButtonGroup.jsx":"61b08a6b00a2","components/product/OptionField.jsx":"aa26bf84fd7a","components/product/PriceSummary.jsx":"6bf86677d166","ui_kits/huni_printing/Configurator.jsx":"02c7b9890fe8","ui_kits/huni_printing/DetailTabs.jsx":"d5089b95fb9d","ui_kits/huni_printing/Header.jsx":"40233753efba","ui_kits/huni_printing/ProductGallery.jsx":"018945da2d16"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.HuniPrintingDesignSystem_0546d5 = window.HuniPrintingDesignSystem_0546d5 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/brand/Logo.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing wordmark.
 * "Huni" set bold in the brand purple, "printing" set light in gray,
 * with the optional CMYK registration-mark accent (a print motif).
 */
function Logo({
  variant = "color",
  showMark = true,
  size = 28,
  withCom = false,
  style = {},
  ...rest
}) {
  // tone of the two words per variant
  const tones = {
    color: {
      huni: "var(--huni-purple-600)",
      printing: "var(--huni-gray-600)",
      com: "var(--huni-gray-400)"
    },
    dark: {
      huni: "var(--huni-gray-800)",
      printing: "var(--huni-gray-600)",
      com: "var(--huni-gray-400)"
    },
    reversed: {
      huni: "var(--huni-white)",
      printing: "var(--huni-gray-100)",
      com: "var(--huni-gray-200)"
    }
  };
  const t = tones[variant] || tones.color;
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: "inline-flex",
      alignItems: "flex-start",
      fontFamily: "var(--font-sans)",
      lineHeight: 1,
      letterSpacing: "var(--tracking-tight)",
      fontSize: size,
      whiteSpace: "nowrap",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: "var(--weight-bold)",
      color: t.huni
    }
  }, "Huni"), /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: "var(--weight-regular)",
      color: t.printing
    }
  }, "printing"), withCom && /*#__PURE__*/React.createElement("span", {
    style: {
      fontWeight: "var(--weight-regular)",
      color: t.com
    }
  }, ".com"), showMark && /*#__PURE__*/React.createElement(RegistrationMark, {
    size: size * 0.62
  }));
}

/** The standalone CMYK registration / crop mark. */
function RegistrationMark({
  size = 18,
  style = {}
}) {
  const v = size; // square
  return /*#__PURE__*/React.createElement("svg", {
    width: v,
    height: v,
    viewBox: "0 0 28 28",
    fill: "none",
    "aria-hidden": "true",
    style: {
      marginLeft: size * 0.18,
      flex: "none",
      ...style
    }
  }, /*#__PURE__*/React.createElement("rect", {
    x: "12.6",
    y: "0",
    width: "2.8",
    height: "9",
    fill: "#EC008C"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "12.6",
    y: "19",
    width: "2.8",
    height: "9",
    fill: "#231F20"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "0",
    y: "12.6",
    width: "9",
    height: "2.8",
    fill: "#FFE000"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "19",
    y: "12.6",
    width: "9",
    height: "2.8",
    fill: "#00A1E9"
  }));
}
Object.assign(__ds_scope, { Logo, RegistrationMark });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/brand/Logo.jsx", error: String((e && e.message) || e) }); }

// components/feedback/Badge.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const TONES = {
  best: "var(--huni-purple-600)",
  new: "var(--huni-amber)",
  up: "var(--huni-teal)",
  design: "var(--huni-orange)",
  brand: "var(--huni-purple-600)",
  dark: "var(--huni-black)",
  neutral: "var(--huni-gray-400)"
};

/**
 * Huni printing label / badge. A tiny bold tag, optionally "pinned"
 * with a pointer tail (the product-thumbnail markers BEST / NEW / UP
 * / DESIGN). Without a pin it reads as a plain inline chip (추천,
 * 먹유광, 홀로그램).
 */
function Badge({
  children,
  tone = "brand",
  pin = null,
  // null | "down" | "up"
  size = "sm",
  // sm | md
  style = {},
  ...rest
}) {
  const bg = TONES[tone] || TONES.brand;
  const pad = size === "md" ? "3px 8px" : "2px 7px";
  const fs = size === "md" ? "var(--text-xs)" : "var(--text-2xs)";
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      position: "relative",
      display: "inline-flex",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      display: "inline-flex",
      alignItems: "center",
      padding: pad,
      background: bg,
      color: "var(--huni-white)",
      font: "var(--type-caption)",
      fontSize: fs,
      fontWeight: "var(--weight-bold)",
      lineHeight: 1,
      letterSpacing: "var(--tracking-tight)",
      borderRadius: "var(--radius-sm)",
      whiteSpace: "nowrap"
    }
  }, children), pin && /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      position: "absolute",
      left: "50%",
      transform: "translateX(-50%)",
      [pin === "down" ? "top" : "bottom"]: "100%",
      width: 0,
      height: 0,
      borderLeft: "4px solid transparent",
      borderRight: "4px solid transparent",
      ...(pin === "down" ? {
        borderTop: `4px solid ${bg}`
      } : {
        borderBottom: `4px solid ${bg}`
      })
    }
  }));
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/Badge.jsx", error: String((e && e.message) || e) }); }

// components/feedback/Callout.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing callout. A compact inline notice led by a circular
 * "!" / "i" glyph. Default tone is brand purple (status / info);
 * `warn` switches to the red warning color.
 */
function Callout({
  children,
  tone = "brand",
  // brand | warn | muted
  glyph = "!",
  style = {},
  ...rest
}) {
  const color = tone === "warn" ? "var(--color-error)" : tone === "muted" ? "var(--text-secondary)" : "var(--huni-purple-600)";
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "inline-flex",
      alignItems: "center",
      gap: "var(--space-2)",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color,
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    "aria-hidden": "true",
    style: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      width: 16,
      height: 16,
      flex: "none",
      borderRadius: "var(--radius-full)",
      border: `var(--border-w) solid ${color}`,
      fontSize: 11,
      fontWeight: "var(--weight-medium)",
      lineHeight: 1
    }
  }, glyph), /*#__PURE__*/React.createElement("span", null, children));
}
Object.assign(__ds_scope, { Callout });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/Callout.jsx", error: String((e && e.message) || e) }); }

// components/forms/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing button. Border-driven, 5px corners, tight tracking.
 * Primary = solid purple; secondary = purple outline; neutral = gray
 * outline; ghost = text only. Sizes map to the configurator (md=50px)
 * and compact actions (sm=40px).
 */
function Button({
  children,
  variant = "primary",
  size = "md",
  block = false,
  disabled = false,
  leadingIcon = null,
  style = {},
  ...rest
}) {
  const [hover, setHover] = React.useState(false);
  const [active, setActive] = React.useState(false);
  const sizes = {
    sm: {
      height: "var(--control-h-sm)",
      padding: "0 16px",
      font: "var(--text-md)"
    },
    md: {
      height: "var(--control-h-md)",
      padding: "0 24px",
      font: "var(--text-md)"
    }
  };
  const s = sizes[size] || sizes.md;

  // resolve palette per variant + interaction
  let bg, color, border;
  if (variant === "primary") {
    bg = disabled ? "var(--color-disabled-fill)" : hover ? "var(--huni-purple-800)" : "var(--huni-purple-600)";
    color = "var(--huni-white)";
    border = "transparent";
  } else if (variant === "secondary") {
    bg = disabled ? "var(--huni-white)" : hover ? "var(--huni-purple-50)" : "var(--huni-white)";
    color = disabled ? "var(--color-disabled-text)" : "var(--huni-purple-600)";
    border = disabled ? "var(--huni-gray-200)" : "var(--huni-purple-600)";
  } else if (variant === "neutral") {
    bg = disabled ? "var(--huni-white)" : hover ? "var(--huni-gray-50)" : "var(--huni-white)";
    color = disabled ? "var(--color-disabled-text)" : "var(--huni-gray-400)";
    border = "var(--huni-gray-200)";
  } else {
    // ghost
    bg = "transparent";
    color = disabled ? "var(--color-disabled-text)" : "var(--huni-purple-600)";
    border = "transparent";
  }
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    disabled: disabled,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => {
      setHover(false);
      setActive(false);
    },
    onMouseDown: () => setActive(true),
    onMouseUp: () => setActive(false),
    style: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      gap: "var(--space-2)",
      width: block ? "100%" : "auto",
      height: s.height,
      padding: s.padding,
      font: "var(--type-title)",
      fontWeight: variant === "primary" ? "var(--weight-bold)" : "var(--weight-semibold)",
      fontSize: s.font,
      letterSpacing: "var(--tracking-tighter)",
      color,
      background: bg,
      border: `var(--border-w) solid ${border}`,
      borderRadius: "var(--radius-md)",
      cursor: disabled ? "not-allowed" : "pointer",
      transition: "background .15s ease, color .15s ease, border-color .15s ease, transform .05s ease",
      transform: active && !disabled ? "scale(0.99)" : "none",
      ...style
    }
  }, rest), leadingIcon, children);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Button.jsx", error: String((e && e.message) || e) }); }

// components/forms/Checkbox.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing checkbox. Rounded square that fills brand purple
 * with a white check when selected. Optional inline label.
 */
function Checkbox({
  checked = false,
  onChange = () => {},
  label = null,
  disabled = false,
  size = 24,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("label", _extends({
    style: {
      display: "inline-flex",
      alignItems: "center",
      gap: "var(--space-3)",
      cursor: disabled ? "not-allowed" : "pointer",
      opacity: disabled ? 0.5 : 1,
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    onClick: () => !disabled && onChange(!checked),
    style: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      width: size,
      height: size,
      flex: "none",
      borderRadius: "var(--radius-sm)",
      background: checked ? "var(--huni-purple-600)" : "var(--huni-white)",
      border: `var(--border-w) solid ${checked ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}`,
      transition: "background .12s ease, border-color .12s ease"
    }
  }, checked && /*#__PURE__*/React.createElement("svg", {
    width: size * 0.62,
    height: size * 0.62,
    viewBox: "0 0 16 16",
    fill: "none",
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3.5 8.5l3 3 6-6.5",
    stroke: "#fff",
    strokeWidth: "2",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }))), label && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-body)"
    }
  }, label));
}
Object.assign(__ds_scope, { Checkbox });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Checkbox.jsx", error: String((e && e.message) || e) }); }

// components/forms/QuantityStepper.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing quantity stepper (Count Input Type). Three joined
 * cells — minus / value / plus — used for 제작수량 and similar counts.
 */
function QuantityStepper({
  value = 1,
  min = 1,
  max = 9999,
  step = 1,
  onChange = () => {},
  size = "md",
  style = {},
  ...rest
}) {
  const h = size === "sm" ? 40 : 50;
  const clamp = n => Math.max(min, Math.min(max, n));
  const set = n => onChange(clamp(n));
  const cell = {
    height: h,
    width: h,
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    background: "var(--huni-white)",
    border: "var(--border-w) solid var(--huni-gray-200)",
    color: "var(--text-secondary)",
    cursor: "pointer",
    userSelect: "none",
    fontSize: "var(--text-lg)",
    transition: "background .12s ease, color .12s ease"
  };
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "inline-flex",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: () => set(value - step),
    disabled: value <= min,
    style: {
      ...cell,
      borderRadius: "var(--radius-md) 0 0 var(--radius-md)",
      opacity: value <= min ? 0.4 : 1,
      cursor: value <= min ? "not-allowed" : "pointer"
    },
    "aria-label": "decrease"
  }, "\u2212"), /*#__PURE__*/React.createElement("input", {
    value: value,
    onChange: e => {
      const n = parseInt(e.target.value.replace(/[^0-9]/g, ""), 10);
      set(Number.isNaN(n) ? min : n);
    },
    inputMode: "numeric",
    style: {
      height: h,
      width: 72,
      textAlign: "center",
      border: "var(--border-w) solid var(--huni-gray-200)",
      borderLeft: "none",
      borderRight: "none",
      outline: "none",
      background: "var(--huni-white)",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-body)"
    }
  }), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: () => set(value + step),
    disabled: value >= max,
    style: {
      ...cell,
      borderRadius: "0 var(--radius-md) var(--radius-md) 0",
      opacity: value >= max ? 0.4 : 1,
      cursor: value >= max ? "not-allowed" : "pointer"
    },
    "aria-label": "increase"
  }, "+"));
}
Object.assign(__ds_scope, { QuantityStepper });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/QuantityStepper.jsx", error: String((e && e.message) || e) }); }

// components/forms/Radio.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing radio. A single choice in a group: unchecked is a
 * gray ring, checked is a purple ring with a purple center dot.
 */
function Radio({
  checked = false,
  onChange = () => {},
  label = null,
  name,
  value,
  disabled = false,
  size = 24,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("label", _extends({
    style: {
      display: "inline-flex",
      alignItems: "center",
      gap: "var(--space-3)",
      cursor: disabled ? "not-allowed" : "pointer",
      opacity: disabled ? 0.5 : 1,
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    onClick: () => !disabled && onChange(value ?? true),
    style: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      width: size,
      height: size,
      flex: "none",
      borderRadius: "var(--radius-full)",
      background: "var(--huni-white)",
      border: `${checked ? "var(--border-w-strong)" : "var(--border-w)"} solid ${checked ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}`,
      transition: "border-color .12s ease"
    }
  }, checked && /*#__PURE__*/React.createElement("span", {
    style: {
      width: size * 0.42,
      height: size * 0.42,
      borderRadius: "var(--radius-full)",
      background: "var(--huni-purple-600)"
    }
  })), label && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-body)"
    }
  }, label));
}
Object.assign(__ds_scope, { Radio });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Radio.jsx", error: String((e && e.message) || e) }); }

// components/forms/SelectBox.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing select box. Closed control mirrors a text field;
 * opening turns the border purple and drops a shadowed list. Each
 * row highlights to the purple tint on hover; the chosen row reads
 * in brand purple. Supports an optional inline badge (e.g. 추천).
 */
function SelectBox({
  options = [],
  value = null,
  placeholder = "선택하세요",
  onChange = () => {},
  badge = null,
  disabled = false,
  size = "md",
  style = {},
  ...rest
}) {
  const [open, setOpen] = React.useState(false);
  const [hoverIdx, setHoverIdx] = React.useState(-1);
  const ref = React.useRef(null);
  React.useEffect(() => {
    const onDoc = e => {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false);
    };
    document.addEventListener("mousedown", onDoc);
    return () => document.removeEventListener("mousedown", onDoc);
  }, []);
  const sel = options.find(o => (typeof o === "string" ? o : o.value) === value);
  const selLabel = sel ? typeof sel === "string" ? sel : sel.label : null;
  const h = size === "sm" ? "var(--control-h-sm)" : "var(--control-h-md)";
  return /*#__PURE__*/React.createElement("div", _extends({
    ref: ref,
    style: {
      position: "relative",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("button", {
    type: "button",
    disabled: disabled,
    onClick: () => !disabled && setOpen(v => !v),
    style: {
      display: "flex",
      alignItems: "center",
      gap: "var(--space-2)",
      width: "100%",
      height: h,
      padding: "0 14px",
      background: disabled ? "var(--surface-muted)" : "var(--huni-white)",
      border: `var(--border-w) solid ${open ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}`,
      borderRadius: "var(--radius-md)",
      cursor: disabled ? "not-allowed" : "pointer",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: selLabel ? open ? "var(--huni-purple-600)" : "var(--text-body)" : "var(--text-placeholder)",
      fontWeight: selLabel ? "var(--weight-medium)" : "var(--weight-regular)",
      textAlign: "left",
      transition: "border-color .15s ease"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1,
      overflow: "hidden",
      textOverflow: "ellipsis",
      whiteSpace: "nowrap"
    }
  }, selLabel || placeholder), badge, /*#__PURE__*/React.createElement(Chevron, {
    open: open
  })), open && /*#__PURE__*/React.createElement("ul", {
    style: {
      position: "absolute",
      zIndex: 20,
      top: "calc(100% + 4px)",
      left: 0,
      right: 0,
      margin: 0,
      padding: "var(--space-1) 0",
      listStyle: "none",
      background: "var(--huni-white)",
      border: `var(--border-w) solid var(--huni-gray-200)`,
      borderRadius: "var(--radius-md)",
      boxShadow: "var(--shadow-dropdown)",
      maxHeight: 280,
      overflowY: "auto"
    }
  }, options.map((o, i) => {
    const val = typeof o === "string" ? o : o.value;
    const label = typeof o === "string" ? o : o.label;
    const isSel = val === value;
    return /*#__PURE__*/React.createElement("li", {
      key: val,
      onMouseEnter: () => setHoverIdx(i),
      onMouseLeave: () => setHoverIdx(-1),
      onClick: () => {
        onChange(val);
        setOpen(false);
      },
      style: {
        padding: "12px 14px",
        font: "var(--type-body)",
        fontSize: "var(--text-base)",
        cursor: "pointer",
        background: hoverIdx === i ? "var(--huni-purple-50)" : "transparent",
        color: isSel ? "var(--huni-purple-600)" : "var(--text-body)",
        fontWeight: isSel ? "var(--weight-semibold)" : "var(--weight-regular)"
      }
    }, label);
  })));
}
function Chevron({
  open
}) {
  return /*#__PURE__*/React.createElement("svg", {
    width: "14",
    height: "14",
    viewBox: "0 0 14 14",
    fill: "none",
    "aria-hidden": "true",
    style: {
      flex: "none",
      transform: open ? "rotate(180deg)" : "none",
      transition: "transform .15s ease"
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3 5l4 4 4-4",
    stroke: open ? "var(--huni-purple-600)" : "var(--huni-gray-400)",
    strokeWidth: "1.6",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }));
}
Object.assign(__ds_scope, { SelectBox });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/SelectBox.jsx", error: String((e && e.message) || e) }); }

// components/forms/Slider.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing stepped slider. A gray track with dotted stops and a
 * larger purple thumb at the active stop. Labels sit beneath each
 * stop (e.g. quantity tiers 1 · 10 · 50 · 100 · 500 · 1000+).
 */
function Slider({
  stops = ["1", "10", "50", "100", "500", "1000+"],
  index = 0,
  onChange = () => {},
  style = {},
  ...rest
}) {
  const n = stops.length;
  const pct = i => n <= 1 ? 0 : i / (n - 1) * 100;
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      padding: "12px 10px 0",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      position: "relative",
      height: 24
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      top: 11,
      left: 0,
      right: 0,
      height: 2,
      background: "var(--huni-gray-200)",
      borderRadius: "var(--radius-pill)"
    }
  }), stops.map((_, i) => {
    const active = i === index;
    return /*#__PURE__*/React.createElement("button", {
      key: i,
      type: "button",
      onClick: () => onChange(i),
      "aria-label": `stop ${stops[i]}`,
      style: {
        position: "absolute",
        top: active ? 0 : 6,
        left: `${pct(i)}%`,
        transform: "translateX(-50%)",
        width: active ? 24 : 12,
        height: active ? 24 : 12,
        padding: 0,
        borderRadius: "var(--radius-full)",
        border: "none",
        background: active ? "var(--huni-purple-600)" : "var(--huni-gray-200)",
        cursor: "pointer",
        transition: "all .15s ease",
        boxShadow: active ? "var(--shadow-focus)" : "none"
      }
    });
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: "relative",
      height: 22,
      marginTop: 6
    }
  }, stops.map((s, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    style: {
      position: "absolute",
      left: `${pct(i)}%`,
      transform: i === 0 ? "translateX(0)" : i === n - 1 ? "translateX(-100%)" : "translateX(-50%)",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: i === index ? "var(--text-body)" : "var(--text-secondary)",
      fontWeight: i === index ? "var(--weight-medium)" : "var(--weight-regular)",
      whiteSpace: "nowrap"
    }
  }, s))));
}
Object.assign(__ds_scope, { Slider });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/Slider.jsx", error: String((e && e.message) || e) }); }

// components/forms/TextField.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing text field. Border-driven box that turns purple on
 * focus and red on error. Supports a trailing unit suffix (mm, 원,
 * 장) and helper / error text below.
 */
function TextField({
  value = "",
  placeholder = "",
  onChange = () => {},
  suffix = null,
  helper = null,
  error = false,
  disabled = false,
  align = "left",
  size = "md",
  style = {},
  inputStyle = {},
  ...rest
}) {
  const [focus, setFocus] = React.useState(false);
  const h = size === "sm" ? "var(--control-h-sm)" : "var(--control-h-md)";
  const borderColor = error ? "var(--color-error)" : focus ? "var(--huni-purple-600)" : "var(--huni-gray-200)";
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: "var(--space-2)",
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: "var(--space-2)",
      height: h,
      padding: "0 14px",
      background: disabled ? "var(--surface-muted)" : "var(--huni-white)",
      border: `var(--border-w) solid ${borderColor}`,
      borderRadius: "var(--radius-md)",
      transition: "border-color .15s ease"
    }
  }, /*#__PURE__*/React.createElement("input", _extends({
    value: value,
    placeholder: placeholder,
    disabled: disabled,
    onChange: e => onChange(e.target.value),
    onFocus: () => setFocus(true),
    onBlur: () => setFocus(false),
    style: {
      flex: 1,
      minWidth: 0,
      border: "none",
      outline: "none",
      background: "transparent",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      letterSpacing: "var(--tracking-tight)",
      color: "var(--text-body)",
      textAlign: align,
      ...inputStyle
    }
  }, rest)), suffix && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)",
      flex: "none"
    }
  }, suffix)), helper && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-caption)",
      fontSize: "var(--text-sm)",
      color: error ? "var(--color-error)" : "var(--text-secondary)"
    }
  }, helper));
}
Object.assign(__ds_scope, { TextField });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/forms/TextField.jsx", error: String((e && e.message) || e) }); }

// components/navigation/Pagination.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing pagination. Prev/next chevrons flanking numbered
 * cells. The current page has a purple border + purple text; others
 * fill gray on hover.
 */
function Pagination({
  page = 1,
  count = 3,
  onChange = () => {},
  style = {},
  ...rest
}) {
  const [hover, setHover] = React.useState(-1);
  const pages = Array.from({
    length: count
  }, (_, i) => i + 1);
  const sz = 36;
  const Chevron = ({
    dir,
    disabled
  }) => /*#__PURE__*/React.createElement("button", {
    type: "button",
    disabled: disabled,
    onClick: () => onChange(dir === "prev" ? page - 1 : page + 1),
    "aria-label": dir,
    style: {
      width: sz,
      height: sz,
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      background: "transparent",
      border: "none",
      cursor: disabled ? "not-allowed" : "pointer",
      opacity: disabled ? 0.35 : 1,
      padding: 0
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "12",
    viewBox: "0 0 12 12",
    fill: "none",
    style: {
      transform: dir === "prev" ? "none" : "rotate(180deg)"
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M7.5 2.5L4 6l3.5 3.5",
    stroke: "var(--huni-gray-400)",
    strokeWidth: "1.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })));
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "inline-flex",
      alignItems: "center",
      gap: "var(--space-2)",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement(Chevron, {
    dir: "prev",
    disabled: page <= 1
  }), pages.map(p => {
    const on = p === page;
    return /*#__PURE__*/React.createElement("button", {
      key: p,
      type: "button",
      onClick: () => onChange(p),
      onMouseEnter: () => setHover(p),
      onMouseLeave: () => setHover(-1),
      style: {
        width: sz,
        height: sz,
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        borderRadius: "var(--radius-md)",
        border: `var(--border-w) solid ${on ? "var(--huni-purple-600)" : "transparent"}`,
        background: !on && hover === p ? "var(--huni-gray-50)" : "transparent",
        color: on ? "var(--huni-purple-600)" : "var(--text-secondary)",
        font: "var(--type-body)",
        fontSize: "var(--text-base)",
        fontWeight: on ? "var(--weight-semibold)" : "var(--weight-regular)",
        cursor: "pointer",
        transition: "background .12s ease"
      }
    }, p);
  }), /*#__PURE__*/React.createElement(Chevron, {
    dir: "next",
    disabled: page >= count
  }));
}
Object.assign(__ds_scope, { Pagination });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/Pagination.jsx", error: String((e && e.message) || e) }); }

// components/navigation/Tabs.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing tabs. Underline tabs over a hairline rule; the active
 * tab is purple with a purple underline, inactive tabs are gray.
 */
function Tabs({
  tabs = [],
  value = null,
  onChange = () => {},
  style = {},
  ...rest
}) {
  const items = tabs.map(t => typeof t === "string" ? {
    value: t,
    label: t
  } : t);
  const active = value ?? items[0]?.value;
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "flex",
      borderBottom: "var(--border-w) solid var(--huni-gray-200)",
      ...style
    }
  }, rest), items.map(t => {
    const on = t.value === active;
    return /*#__PURE__*/React.createElement("button", {
      key: t.value,
      type: "button",
      onClick: () => onChange(t.value),
      style: {
        position: "relative",
        flex: 1,
        padding: "14px 8px",
        background: "transparent",
        border: "none",
        cursor: "pointer",
        font: "var(--type-title)",
        fontSize: "var(--text-md)",
        fontWeight: on ? "var(--weight-semibold)" : "var(--weight-regular)",
        letterSpacing: "var(--tracking-tight)",
        color: on ? "var(--huni-purple-600)" : "var(--text-secondary)",
        transition: "color .15s ease"
      }
    }, t.label, /*#__PURE__*/React.createElement("span", {
      "aria-hidden": "true",
      style: {
        position: "absolute",
        left: 0,
        right: 0,
        bottom: -1,
        height: 2,
        background: on ? "var(--huni-purple-600)" : "transparent"
      }
    }));
  }));
}
Object.assign(__ds_scope, { Tabs });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/navigation/Tabs.jsx", error: String((e && e.message) || e) }); }

// components/product/ColorChip.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing finish color chip. A round color sample with a
 * pinned label tag above it. Selecting wraps the sample in the brand
 * purple ring. Used for foil / coating colors (먹유광, 홀로그램 …).
 */
function ColorChip({
  color = "#000000",
  label,
  selected = false,
  onClick = () => {},
  size = 50,
  swatchStyle = {},
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    onClick: onClick,
    style: {
      display: "inline-flex",
      flexDirection: "column",
      alignItems: "center",
      gap: 10,
      background: "transparent",
      border: "none",
      cursor: "pointer",
      padding: 0,
      ...style
    }
  }, rest), label && /*#__PURE__*/React.createElement(__ds_scope.Badge, {
    tone: "dark",
    size: "md",
    pin: "down"
  }, label), /*#__PURE__*/React.createElement("span", {
    style: {
      width: size,
      height: size,
      borderRadius: "var(--radius-full)",
      background: color,
      boxSizing: "border-box",
      border: selected ? "var(--border-w-strong) solid var(--huni-purple-600)" : "var(--border-w) solid var(--huni-gray-200)",
      boxShadow: selected ? "inset 0 0 0 2px var(--huni-white)" : "none",
      transition: "border-color .12s ease",
      ...swatchStyle
    }
  }));
}
Object.assign(__ds_scope, { ColorChip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/product/ColorChip.jsx", error: String((e && e.message) || e) }); }

// components/product/FinishSection.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing collapsible finish section. A title bar with a
 * right-aligned 열기/닫기 toggle over a hairline; content reveals when
 * open. Used to tuck away the 후가공 (post-processing) option groups.
 */
function FinishSection({
  title,
  open = false,
  onToggle = () => {},
  openLabel = "열기",
  closeLabel = "닫기",
  children,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      paddingBottom: "var(--space-3)",
      borderBottom: "var(--border-w) solid var(--huni-gray-200)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-title)",
      fontSize: "var(--text-md)",
      fontWeight: "var(--weight-medium)",
      color: "var(--text-heading)"
    }
  }, title), /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: () => onToggle(!open),
    style: {
      background: "transparent",
      border: "none",
      cursor: "pointer",
      padding: "2px 4px",
      display: "inline-flex",
      alignItems: "center",
      gap: 4,
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--huni-purple-600)"
    }
  }, open ? closeLabel : openLabel, /*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "12",
    viewBox: "0 0 14 14",
    fill: "none",
    "aria-hidden": "true",
    style: {
      transform: open ? "rotate(180deg)" : "none",
      transition: "transform .15s ease"
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3 5l4 4 4-4",
    stroke: "var(--huni-purple-600)",
    strokeWidth: "1.6",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })))), open && /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: "var(--space-6)",
      paddingTop: "var(--space-5)"
    }
  }, children));
}
Object.assign(__ds_scope, { FinishSection });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/product/FinishSection.jsx", error: String((e && e.message) || e) }); }

// components/product/OptionButtonGroup.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing option button group. A wrapping grid of selectable
 * cells (사이즈, 인쇄, 커팅 …). Selected = purple border + purple text;
 * unselected = gray border + gray text, hover fills a faint gray.
 * Each option may carry a small trailing info glyph.
 */
function OptionButtonGroup({
  options = [],
  value = null,
  onChange = () => {},
  columns = 3,
  style = {},
  ...rest
}) {
  const [hover, setHover] = React.useState(null);
  const items = options.map(o => typeof o === "string" ? {
    value: o,
    label: o
  } : o);
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "grid",
      gridTemplateColumns: `repeat(${columns}, 1fr)`,
      gap: "var(--space-2)",
      ...style
    }
  }, rest), items.map(o => {
    const on = o.value === value;
    const hot = hover === o.value;
    return /*#__PURE__*/React.createElement("button", {
      key: o.value,
      type: "button",
      disabled: o.disabled,
      onClick: () => onChange(o.value),
      onMouseEnter: () => setHover(o.value),
      onMouseLeave: () => setHover(null),
      style: {
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        gap: 6,
        minHeight: "var(--control-h-md)",
        padding: "8px 10px",
        background: o.disabled ? "var(--surface-muted)" : !on && hot ? "var(--huni-gray-50)" : "var(--huni-white)",
        border: `var(--border-w) solid ${on ? "var(--huni-purple-600)" : "var(--huni-gray-200)"}`,
        borderRadius: "var(--radius-md)",
        cursor: o.disabled ? "not-allowed" : "pointer",
        font: "var(--type-body)",
        fontSize: "var(--text-base)",
        fontWeight: on ? "var(--weight-medium)" : "var(--weight-regular)",
        letterSpacing: "var(--tracking-tight)",
        color: o.disabled ? "var(--color-disabled-text)" : on ? "var(--huni-purple-600)" : "var(--text-secondary)",
        textAlign: "center",
        transition: "border-color .12s ease, background .12s ease, color .12s ease"
      }
    }, o.label, o.info && /*#__PURE__*/React.createElement("span", {
      "aria-hidden": "true",
      style: {
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        width: 14,
        height: 14,
        borderRadius: "var(--radius-full)",
        border: `1px solid ${on ? "var(--huni-purple-400)" : "var(--huni-gray-200)"}`,
        fontSize: 9,
        lineHeight: 1,
        flex: "none"
      }
    }, "!"));
  }));
}
Object.assign(__ds_scope, { OptionButtonGroup });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/product/OptionButtonGroup.jsx", error: String((e && e.message) || e) }); }

// components/product/OptionField.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing option-group wrapper. A labelled block: title row
 * (with optional info glyph and a right-aligned slot) above the
 * control. The building block of the product configurator.
 */
function OptionField({
  label,
  info = false,
  onInfo = null,
  right = null,
  children,
  style = {},
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "flex",
      flexDirection: "column",
      gap: "var(--space-3)",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      justifyContent: "space-between",
      gap: "var(--space-2)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "inline-flex",
      alignItems: "center",
      gap: "var(--space-2)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-title)",
      fontSize: "var(--text-md)",
      fontWeight: "var(--weight-medium)",
      color: "var(--text-heading)"
    }
  }, label), info && /*#__PURE__*/React.createElement("span", {
    onClick: onInfo || undefined,
    "aria-hidden": "true",
    style: {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      width: 16,
      height: 16,
      borderRadius: "var(--radius-full)",
      border: "var(--border-w) solid var(--huni-gray-200)",
      color: "var(--text-secondary)",
      fontSize: 11,
      lineHeight: 1,
      cursor: onInfo ? "pointer" : "default"
    }
  }, "!")), right), children);
}
Object.assign(__ds_scope, { OptionField });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/product/OptionField.jsx", error: String((e && e.message) || e) }); }

// components/product/PriceSummary.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/**
 * Huni printing price summary. A list of itemised line costs above a
 * total row, separated by hairlines. The grand total is set large in
 * brand purple, with an optional tax breakdown subtitle.
 */
function PriceSummary({
  items = [],
  // [{ label, amount }]
  total,
  totalLabel = "합계금액",
  subtitle = null,
  // e.g. "상품가 75,000원  부가세 7,500원"
  currency = "원",
  style = {},
  ...rest
}) {
  const fmt = n => typeof n === "number" ? n.toLocaleString("ko-KR") : n;
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: "flex",
      flexDirection: "column",
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: "var(--space-3)",
      paddingBottom: "var(--space-4)"
    }
  }, items.map((it, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "flex",
      alignItems: "baseline",
      justifyContent: "space-between",
      gap: "var(--space-4)"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)",
      flex: 1,
      minWidth: 0
    }
  }, it.label), /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body-strong)",
      fontSize: "var(--text-base)",
      color: "var(--text-body)",
      whiteSpace: "nowrap"
    }
  }, fmt(it.amount))))), /*#__PURE__*/React.createElement("div", {
    style: {
      borderTop: "var(--border-w) solid var(--huni-gray-200)",
      paddingTop: "var(--space-4)",
      display: "flex",
      alignItems: "flex-end",
      justifyContent: "space-between",
      gap: "var(--space-4)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 4
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-title)",
      fontSize: "var(--text-md)",
      fontWeight: "var(--weight-bold)",
      color: "var(--text-heading)"
    }
  }, totalLabel), subtitle && /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-caption)",
      fontSize: "var(--text-sm)",
      color: "var(--text-secondary)"
    }
  }, subtitle)), /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-h1)",
      fontSize: "var(--text-2xl)",
      fontWeight: "var(--weight-bold)",
      color: "var(--huni-purple-600)",
      whiteSpace: "nowrap",
      letterSpacing: "var(--tracking-tight)"
    }
  }, fmt(total), currency && /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: "var(--text-md)",
      marginLeft: 2
    }
  }, currency))));
}
Object.assign(__ds_scope, { PriceSummary });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/product/PriceSummary.jsx", error: String((e && e.message) || e) }); }

// ui_kits/huni_printing/Configurator.jsx
try { (() => {
// Huni printing — product option configurator (right column). Plain-babel module.
function Configurator(C) {
  const {
    OptionField,
    OptionButtonGroup,
    SelectBox,
    QuantityStepper,
    ColorChip,
    FinishSection,
    PriceSummary,
    Button,
    Callout,
    Badge,
    onAddToCart
  } = C;
  const [size, setSize] = React.useState("a4");
  const [paper, setPaper] = React.useState("yupo");
  const [print, setPrint] = React.useState("single");
  const [spot, setSpot] = React.useState("white");
  const [cut, setCut] = React.useState("c30");
  const [pieces, setPieces] = React.useState("p5");
  const [qty, setQty] = React.useState(20);
  const [finishOpen, setFinishOpen] = React.useState(true);
  const [corner, setCorner] = React.useState("square");
  const [foil, setFoil] = React.useState("matte");

  // ── pricing model (illustrative) ──
  const sizeBase = {
    a6: 28000,
    a5: 38000,
    a4: 50000
  }[size];
  const paperAdd = {
    yupo: 0,
    art: 6000,
    pet: 12000
  }[paper];
  const spotAdd = spot === "white" ? 9000 : 0;
  const foilAdd = foil === "holo" ? 4000 : 2500;
  const unit = sizeBase + paperAdd + spotAdd;
  const printCost = Math.round(unit * qty / 20);
  const finishCost = 25000;
  const extraCost = 1100;
  const productPrice = printCost;
  const vat = Math.round(productPrice * 0.1);
  const total = productPrice + vat;
  const krw = n => n.toLocaleString("ko-KR");
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 26
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement("h1", {
    style: {
      font: "var(--type-h1)",
      fontSize: "var(--text-2xl)"
    }
  }, "\uD504\uB9AC\uBBF8\uC5C4 \uB3C4\uBB34\uC1A1 \uC2A4\uD2F0\uCEE4"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement(Stars, {
    value: 4.4
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-sm)",
      color: "var(--text-secondary)"
    }
  }, "4.4 \xB7 \uD6C4\uAE30 1,284\uAC1C")), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)"
    }
  }, "\uBC29\uC218 \uC720\uD3EC\uC9C0\uC5D0 \uCE7C\uC120\uAE4C\uC9C0, \uC6D0\uD558\uB294 \uBAA8\uC591 \uADF8\uB300\uB85C \uC81C\uC791\uB418\uB294 \uD504\uB9AC\uBBF8\uC5C4 \uB3C4\uBB34\uC1A1 \uC2A4\uD2F0\uCEE4\uC785\uB2C8\uB2E4.")), /*#__PURE__*/React.createElement(Divider, null), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uC0AC\uC774\uC988"
  }, /*#__PURE__*/React.createElement(OptionButtonGroup, {
    columns: 3,
    value: size,
    onChange: setSize,
    options: [{
      value: "a6",
      label: "A6 (105 x 148 mm)"
    }, {
      value: "a5",
      label: "A5 (148 x 210 mm)"
    }, {
      value: "a4",
      label: "A4 (210 x 297 mm)"
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uC885\uC774",
    info: true
  }, /*#__PURE__*/React.createElement(SelectBox, {
    value: paper,
    onChange: setPaper,
    badge: paper === "yupo" ? /*#__PURE__*/React.createElement(Badge, {
      tone: "brand",
      size: "md"
    }, "\uCD94\uCC9C") : null,
    options: [{
      value: "yupo",
      label: "유포지 (방수)"
    }, {
      value: "art",
      label: "아트지 (+6,000원)"
    }, {
      value: "pet",
      label: "투명 PET (+12,000원)"
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uC778\uC1C4"
  }, /*#__PURE__*/React.createElement(OptionButtonGroup, {
    columns: 3,
    value: print,
    onChange: setPrint,
    options: [{
      value: "single",
      label: "단면"
    }, {
      value: "double",
      label: "양면",
      disabled: true
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uBCC4\uC0C9\uC778\uC1C4 (\uD654\uC774\uD2B8)"
  }, /*#__PURE__*/React.createElement(OptionButtonGroup, {
    columns: 2,
    value: spot,
    onChange: setSpot,
    options: [{
      value: "white",
      label: "화이트인쇄 (단면)"
    }, {
      value: "none",
      label: "사용 안함"
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uCEE4\uD305"
  }, /*#__PURE__*/React.createElement(OptionButtonGroup, {
    columns: 3,
    value: cut,
    onChange: setCut,
    options: [{
      value: "c30",
      label: "30x278mm (8ea)",
      info: true
    }, {
      value: "c30b",
      label: "30x278mm (6ea)",
      info: true
    }, {
      value: "c40",
      label: "40x278mm (4ea)",
      info: true
    }, {
      value: "c50",
      label: "50x278mm (2ea)",
      info: true
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uC870\uAC01\uC218",
    info: true
  }, /*#__PURE__*/React.createElement(SelectBox, {
    value: pieces,
    onChange: setPieces,
    options: [{
      value: "p1",
      label: "1조각"
    }, {
      value: "p3",
      label: "3조각"
    }, {
      value: "p5",
      label: "5조각"
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uC81C\uC791\uC218\uB7C9"
  }, /*#__PURE__*/React.createElement(QuantityStepper, {
    value: qty,
    min: 10,
    step: 10,
    max: 2000,
    onChange: setQty
  })), /*#__PURE__*/React.createElement(Divider, null), /*#__PURE__*/React.createElement(FinishSection, {
    title: "\uD6C4\uAC00\uACF5",
    open: finishOpen,
    onToggle: setFinishOpen
  }, /*#__PURE__*/React.createElement(OptionField, {
    label: "\uADC0\uB3CC\uC774",
    info: true
  }, /*#__PURE__*/React.createElement(OptionButtonGroup, {
    columns: 2,
    value: corner,
    onChange: setCorner,
    options: [{
      value: "square",
      label: "직각모서리"
    }, {
      value: "round",
      label: "둥근모서리"
    }]
  })), /*#__PURE__*/React.createElement(OptionField, {
    label: "\uBC15(\uC55E\uBA74) \uCE7C\uB77C"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      gap: 34,
      paddingTop: 6
    }
  }, /*#__PURE__*/React.createElement(ColorChip, {
    color: "#000000",
    label: "\uBA39\uC720\uAD11",
    selected: foil === "matte",
    onClick: () => setFoil("matte")
  }), /*#__PURE__*/React.createElement(ColorChip, {
    color: "linear-gradient(135deg,#dcdce8,#b9c6d6,#e8d6e2,#cfe3d6)",
    label: "\uD640\uB85C\uADF8\uB7A8",
    selected: foil === "holo",
    onClick: () => setFoil("holo")
  })))), /*#__PURE__*/React.createElement(Divider, null), /*#__PURE__*/React.createElement(PriceSummary, {
    items: [{
      label: `인쇄비 : ${sizeLabel(size)}, ${paperLabel(paper)}, ${qty}ea`,
      amount: printCost
    }, {
      label: `후가공 : 귀돌이 (${corner === "square" ? "직각모서리" : "둥근모서리"}, ${foil === "holo" ? "홀로그램" : "먹유광"})`,
      amount: finishCost
    }, {
      label: "추가상품 : OPP비접착봉투 110 x 160 mm 50장",
      amount: extraCost
    }],
    total: total + finishCost + extraCost,
    subtitle: `상품가 ${krw(productPrice)}원   부가세 ${krw(vat)}원`
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "secondary",
    block: true,
    leadingIcon: /*#__PURE__*/React.createElement(UploadIcon, null)
  }, "PDF\uD30C\uC77C \uC9C1\uC811 \uC62C\uB9AC\uAE30"), /*#__PURE__*/React.createElement(Callout, {
    tone: "muted",
    glyph: "i"
  }, "\uC791\uC5C5\uAC00\uC774\uB4DC \uBC0F \uD30C\uC77C\uAC00\uC774\uB4DC \uB2E4\uC6B4\uB85C\uB4DC")), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 10
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    block: true,
    leadingIcon: /*#__PURE__*/React.createElement(EditIcon, null)
  }, "\uC5D0\uB514\uD130\uB85C \uB514\uC790\uC778\uD558\uAE30"), /*#__PURE__*/React.createElement(Callout, {
    tone: "muted",
    glyph: "i"
  }, "\uC5D0\uB514\uD130 \uC0AC\uC6A9\uBC29\uBC95 \uBCF4\uAE30")), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    block: true,
    size: "md",
    onClick: () => onAddToCart(total + finishCost + extraCost),
    style: {
      height: 56,
      fontSize: "var(--text-md)"
    }
  }, "\uC7A5\uBC14\uAD6C\uB2C8 \uB2F4\uAE30 \xB7 ", krw(total + finishCost + extraCost), "\uC6D0"));
}
function sizeLabel(s) {
  return {
    a6: "105 x 148 mm",
    a5: "148 x 210 mm",
    a4: "210 x 297 mm"
  }[s];
}
function paperLabel(p) {
  return {
    yupo: "유포지",
    art: "아트지",
    pet: "투명 PET"
  }[p];
}
function Divider() {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 1,
      background: "var(--huni-gray-100)"
    }
  });
}
function Stars({
  value
}) {
  return /*#__PURE__*/React.createElement("span", {
    style: {
      display: "inline-flex",
      gap: 1
    }
  }, [0, 1, 2, 3, 4].map(i => /*#__PURE__*/React.createElement("svg", {
    key: i,
    width: "15",
    height: "15",
    viewBox: "0 0 24 24",
    fill: i < Math.round(value) ? "var(--huni-amber)" : "var(--huni-gray-200)"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.8 5.9 20.4l1.4-6.8L2.2 9l6.9-.7L12 2z"
  }))));
}
function UploadIcon() {
  return /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M12 16V4m0 0L7 9m5-5l5 5M5 20h14",
    stroke: "currentColor",
    strokeWidth: "1.7",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }));
}
function EditIcon() {
  return /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M4 20h4l10-10-4-4L4 16v4zM14 6l4 4",
    stroke: "currentColor",
    strokeWidth: "1.7",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }));
}
window.Configurator = Configurator;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/huni_printing/Configurator.jsx", error: String((e && e.message) || e) }); }

// ui_kits/huni_printing/DetailTabs.jsx
try { (() => {
// Huni printing — product detail tabs (notice / shipping / reviews). Plain-babel module.
function DetailTabs({
  Tabs,
  Pagination,
  Badge
}) {
  const [tab, setTab] = React.useState("review");
  const [page, setPage] = React.useState(1);
  return /*#__PURE__*/React.createElement("section", {
    style: {
      marginTop: 56
    }
  }, /*#__PURE__*/React.createElement(Tabs, {
    value: tab,
    onChange: setTab,
    tabs: [{
      value: "notice",
      label: "유의사항"
    }, {
      value: "ship",
      label: "포장/배송"
    }, {
      value: "review",
      label: "상품리뷰"
    }]
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      paddingTop: 32
    }
  }, tab === "notice" && /*#__PURE__*/React.createElement(NoticeBody, null), tab === "ship" && /*#__PURE__*/React.createElement(ShipBody, null), tab === "review" && /*#__PURE__*/React.createElement(ReviewBody, {
    Badge: Badge,
    page: page,
    setPage: setPage,
    Pagination: Pagination
  })));
}
function NoticeBody() {
  const items = [["모니터 환경에 따른 색상 차이", "모니터·기기의 색 표현 차이로 실제 인쇄물과 화면상 색상이 다를 수 있습니다. 중요한 색상은 별색(Pantone) 지정을 권장합니다."], ["재단 오차 안내", "기계 작업 특성상 ±1mm 내외의 재단 오차가 발생할 수 있습니다. 칼선 안쪽 3mm 여백을 확보해 주세요."], ["파일 규격", "PDF / AI (CMYK, 300dpi, 외곽 3mm 도련 포함) 파일을 업로드해 주세요."]];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "1fr 1fr",
      gap: 18
    }
  }, items.map(([t, d], i) => /*#__PURE__*/React.createElement("article", {
    key: i,
    style: {
      border: "1px solid var(--huni-gray-100)",
      borderRadius: "var(--radius-lg)",
      padding: 22,
      background: "var(--huni-white)"
    }
  }, /*#__PURE__*/React.createElement("h4", {
    style: {
      font: "var(--type-title)",
      fontSize: "var(--text-md)",
      marginBottom: 8
    }
  }, t), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)",
      lineHeight: "var(--leading-normal)"
    }
  }, d))));
}
function ShipBody() {
  const rows = [["인쇄 제작", "영업일 기준 2~3일"], ["후가공 포함 시", "영업일 기준 +1~2일"], ["배송 방법", "택배 (CJ대한통운) · 3,000원 / 5만원 이상 무료"], ["퀵·방문수령", "서울/경기 일부 지역 당일 수령 가능"]];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: 720,
      border: "1px solid var(--huni-gray-100)",
      borderRadius: "var(--radius-lg)",
      overflow: "hidden"
    }
  }, rows.map(([k, v], i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      display: "grid",
      gridTemplateColumns: "200px 1fr",
      gap: 16,
      padding: "16px 22px",
      borderTop: i ? "1px solid var(--huni-gray-100)" : "none"
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body-strong)",
      fontSize: "var(--text-base)",
      color: "var(--text-heading)"
    }
  }, k), /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)"
    }
  }, v))));
}
function ReviewBody({
  Badge,
  page,
  setPage,
  Pagination
}) {
  const all = [["김*은", "도무송 칼선이 진짜 깔끔하게 나왔어요. 방수도 잘 되고 재구매 의사 있습니다!", "BEST", 5], ["printlover", "홀로그램 박이 생각보다 화려해서 굿즈로 딱이에요.", "NEW", 5], ["스튜디오 호", "색감이 화면이랑 거의 동일하게 나왔습니다. 가이드 친절해요.", null, 4], ["min_design", "수량 대비 가격이 합리적이라 대량으로 또 주문했어요.", null, 5]];
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 14
    }
  }, all.map(([name, body, tag, score], i) => /*#__PURE__*/React.createElement("article", {
    key: i,
    style: {
      display: "flex",
      gap: 18,
      padding: 20,
      border: "1px solid var(--huni-gray-100)",
      borderRadius: "var(--radius-lg)",
      background: "var(--huni-white)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 44,
      height: 44,
      flex: "none",
      borderRadius: "var(--radius-full)",
      background: "var(--huni-purple-50)",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      font: "var(--type-title)",
      fontWeight: "var(--weight-bold)",
      color: "var(--huni-purple-600)"
    }
  }, name[0]), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 10,
      marginBottom: 6
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-body-strong)",
      fontSize: "var(--text-base)",
      color: "var(--text-heading)"
    }
  }, name), /*#__PURE__*/React.createElement("span", {
    style: {
      display: "inline-flex",
      gap: 1
    }
  }, [0, 1, 2, 3, 4].map(s => /*#__PURE__*/React.createElement("svg", {
    key: s,
    width: "13",
    height: "13",
    viewBox: "0 0 24 24",
    fill: s < score ? "var(--huni-amber)" : "var(--huni-gray-200)"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M12 2l2.9 6.3 6.9.7-5.1 4.6 1.4 6.8L12 17.8 5.9 20.4l1.4-6.8L2.2 9l6.9-.7L12 2z"
  })))), tag && /*#__PURE__*/React.createElement(Badge, {
    tone: tag === "BEST" ? "best" : "new",
    size: "md"
  }, tag)), /*#__PURE__*/React.createElement("p", {
    style: {
      margin: 0,
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      color: "var(--text-secondary)",
      lineHeight: "var(--leading-normal)"
    }
  }, body)))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      justifyContent: "center",
      marginTop: 12
    }
  }, /*#__PURE__*/React.createElement(Pagination, {
    page: page,
    count: 5,
    onChange: setPage
  })));
}
window.DetailTabs = DetailTabs;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/huni_printing/DetailTabs.jsx", error: String((e && e.message) || e) }); }

// ui_kits/huni_printing/Header.jsx
try { (() => {
// Huni printing — global site header. Plain-babel module: attaches to window.
function HuniHeader({
  Logo
}) {
  const icons = [{
    key: "login",
    label: "로그인",
    path: "M12 11a4 4 0 100-8 4 4 0 000 8zm0 2c-4 0-7 2-7 5v1h14v-1c0-3-3-5-7-5z"
  }, {
    key: "join",
    label: "회원가입",
    path: "M12 11a4 4 0 100-8 4 4 0 000 8zm-7 9v-1c0-3 3-5 7-5s7 2 7 5v1M19 8v6M16 11h6"
  }, {
    key: "my",
    label: "마이페이지",
    path: "M4 19V7l8-4 8 4v12H4zm6 0v-6h4v6"
  }, {
    key: "cart",
    label: "장바구니",
    path: "M5 6h16l-2 9H7L5 6zm0 0L4 3H2m5 17a1 1 0 100 2 1 1 0 000-2zm10 0a1 1 0 100 2 1 1 0 000-2z"
  }];
  return /*#__PURE__*/React.createElement("header", {
    style: {
      borderBottom: "1px solid var(--huni-gray-100)",
      background: "var(--huni-white)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: "var(--container-max)",
      margin: "0 auto",
      height: 78,
      padding: "0 24px",
      display: "flex",
      alignItems: "center",
      gap: 24
    }
  }, /*#__PURE__*/React.createElement("button", {
    "aria-label": "menu",
    style: {
      background: "none",
      border: "none",
      cursor: "pointer",
      padding: 6,
      display: "flex"
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "24",
    height: "24",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3 6h18M3 12h18M3 18h18",
    stroke: "var(--huni-gray-800)",
    strokeWidth: "1.8",
    strokeLinecap: "round"
  }))), /*#__PURE__*/React.createElement(Logo, {
    size: 30
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      maxWidth: 420,
      height: 44,
      display: "flex",
      alignItems: "center",
      gap: 8,
      padding: "0 16px",
      border: "1px solid var(--huni-gray-200)",
      borderRadius: "var(--radius-pill)",
      color: "var(--text-placeholder)"
    }
  }, /*#__PURE__*/React.createElement("input", {
    placeholder: "\uC5B4\uB5A4 \uC0C1\uD488\uC744 \uCC3E\uC73C\uC138\uC694?",
    style: {
      flex: 1,
      border: "none",
      outline: "none",
      background: "transparent",
      font: "var(--type-body)",
      fontSize: "var(--text-base)",
      letterSpacing: "var(--tracking-tight)",
      color: "var(--text-body)"
    }
  }), /*#__PURE__*/React.createElement("svg", {
    width: "18",
    height: "18",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "11",
    cy: "11",
    r: "7",
    stroke: "var(--huni-gray-400)",
    strokeWidth: "1.8"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M21 21l-4-4",
    stroke: "var(--huni-gray-400)",
    strokeWidth: "1.8",
    strokeLinecap: "round"
  }))), /*#__PURE__*/React.createElement("nav", {
    style: {
      display: "flex",
      alignItems: "center",
      gap: 22,
      marginLeft: "auto"
    }
  }, icons.map(ic => /*#__PURE__*/React.createElement("a", {
    key: ic.key,
    href: "#",
    style: {
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      gap: 4,
      textDecoration: "none",
      color: ic.key === "cart" ? "var(--huni-purple-600)" : "var(--text-secondary)"
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "22",
    height: "22",
    viewBox: "0 0 24 24",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: ic.path,
    stroke: "currentColor",
    strokeWidth: "1.6",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), /*#__PURE__*/React.createElement("span", {
    style: {
      font: "var(--type-caption)",
      fontSize: "var(--text-2xs)",
      letterSpacing: "var(--tracking-tight)"
    }
  }, ic.label))))), /*#__PURE__*/React.createElement("div", {
    style: {
      background: "var(--huni-gray-50)",
      borderTop: "1px solid var(--huni-gray-100)"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      maxWidth: "var(--container-max)",
      margin: "0 auto",
      padding: "10px 24px",
      font: "var(--type-caption)",
      fontSize: "var(--text-sm)",
      color: "var(--text-secondary)",
      display: "flex",
      alignItems: "center",
      gap: 8
    }
  }, /*#__PURE__*/React.createElement("span", null, "\uD648"), /*#__PURE__*/React.createElement("span", null, "\u203A"), /*#__PURE__*/React.createElement("span", null, "\uC2A4\uD2F0\uCEE4"), /*#__PURE__*/React.createElement("span", null, "\u203A"), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--text-body)"
    }
  }, "\uD504\uB9AC\uBBF8\uC5C4 \uB3C4\uBB34\uC1A1 \uC2A4\uD2F0\uCEE4"))));
}
window.HuniHeader = HuniHeader;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/huni_printing/Header.jsx", error: String((e && e.message) || e) }); }

// ui_kits/huni_printing/ProductGallery.jsx
try { (() => {
// Huni printing — product image gallery (left column). Plain-babel module.
function ProductGallery({
  Badge
}) {
  const [active, setActive] = React.useState(0);
  // Subtle placeholder frames — print-craft tinted, with the CMYK mark watermark.
  const tints = ["linear-gradient(135deg,#EEEBF9,#DED7F4)", "linear-gradient(135deg,#F6F6F6,#E9E9E9)", "linear-gradient(135deg,#DED7F4,#C9C2DF)", "linear-gradient(135deg,#F6F6F6,#EEEBF9)", "linear-gradient(135deg,#E9E9E9,#F6F6F6)", "linear-gradient(135deg,#EEEBF9,#F6F6F6)"];
  const Frame = ({
    tint,
    big
  }) => /*#__PURE__*/React.createElement("div", {
    style: {
      position: "relative",
      width: "100%",
      aspectRatio: big ? "1 / 1" : "1 / 1",
      borderRadius: "var(--radius-xs)",
      background: tint,
      overflow: "hidden",
      border: "1px solid var(--huni-gray-100)",
      display: "flex",
      alignItems: "center",
      justifyContent: "center"
    }
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/cmyk-mark.svg",
    width: big ? 48 : 20,
    height: big ? 48 : 20,
    alt: "",
    style: {
      opacity: 0.5
    }
  }), big && /*#__PURE__*/React.createElement("span", {
    style: {
      position: "absolute",
      bottom: 14,
      font: "var(--type-caption)",
      fontSize: "var(--text-sm)",
      color: "var(--text-secondary)",
      letterSpacing: "var(--tracking-tight)"
    }
  }, "\uC0C1\uD488 \uB300\uD45C \uC774\uBBF8\uC9C0"));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      flexDirection: "column",
      gap: 14
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "relative"
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      top: 12,
      left: 12,
      zIndex: 2,
      display: "flex",
      gap: 6
    }
  }, /*#__PURE__*/React.createElement(Badge, {
    tone: "best",
    size: "md"
  }, "BEST"), /*#__PURE__*/React.createElement(Badge, {
    tone: "new",
    size: "md"
  }, "NEW")), /*#__PURE__*/React.createElement(Frame, {
    tint: tints[active],
    big: true
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: "grid",
      gridTemplateColumns: "repeat(6, 1fr)",
      gap: 8
    }
  }, tints.map((t, i) => /*#__PURE__*/React.createElement("button", {
    key: i,
    onClick: () => setActive(i),
    style: {
      padding: 0,
      background: "none",
      cursor: "pointer",
      borderRadius: "var(--radius-xs)",
      outline: i === active ? "2px solid var(--huni-purple-600)" : "1px solid var(--huni-gray-200)",
      outlineOffset: i === active ? "-2px" : "-1px",
      overflow: "hidden"
    }
  }, /*#__PURE__*/React.createElement(Frame, {
    tint: t
  })))));
}
window.ProductGallery = ProductGallery;
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/huni_printing/ProductGallery.jsx", error: String((e && e.message) || e) }); }

__ds_ns.Logo = __ds_scope.Logo;

__ds_ns.RegistrationMark = __ds_scope.RegistrationMark;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.Callout = __ds_scope.Callout;

__ds_ns.Button = __ds_scope.Button;

__ds_ns.Checkbox = __ds_scope.Checkbox;

__ds_ns.QuantityStepper = __ds_scope.QuantityStepper;

__ds_ns.Radio = __ds_scope.Radio;

__ds_ns.SelectBox = __ds_scope.SelectBox;

__ds_ns.Slider = __ds_scope.Slider;

__ds_ns.TextField = __ds_scope.TextField;

__ds_ns.Pagination = __ds_scope.Pagination;

__ds_ns.Tabs = __ds_scope.Tabs;

__ds_ns.ColorChip = __ds_scope.ColorChip;

__ds_ns.FinishSection = __ds_scope.FinishSection;

__ds_ns.OptionButtonGroup = __ds_scope.OptionButtonGroup;

__ds_ns.OptionField = __ds_scope.OptionField;

__ds_ns.PriceSummary = __ds_scope.PriceSummary;

})();
