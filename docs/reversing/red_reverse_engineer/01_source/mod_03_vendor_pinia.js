    if ("values" in Object) return Object.values(e);
    const t = [];
    for (const n in e) e.hasOwnProperty(n) && t.push(e[n]);
    return t
  }

  function aC(e, t) {
    const n = iC(e);
    if ("find" in n) return n.find(t);
    const o = n;
    for (let s = 0; s < o.length; s++) {
      const r = o[s];
      if (t(r)) return r
    }
  }

  function No(e, t) {
    Object.entries(e).forEach(([n, o]) => t(o, n))
  }

  function Ir(e, t) {
    return e.indexOf(t) !== -1
  }

  function gf(e, t) {
    for (let n = 0; n < e.length; n++) {
      const o = e[n];
      if (t(o)) return o
    }
  }
  var lC = class {
    constructor() {
      this.transfomers = {}
    }
    register(e) {
      this.transfomers[e.name] = e
    }
    findApplicable(e) {
      return aC(this.transfomers, t => t.isApplicable(e))
    }
    findByName(e) {
      return this.transfomers[e]
    }
  };
  q(), q();
  var uC = e => Object.prototype.toString.call(e).slice(8, -1),
    yf = e => typeof e > "u",
    cC = e => e === null,
    vs = e => typeof e != "object" || e === null || e === Object.prototype ? !1 : Object.getPrototypeOf(e) === null ? !0 : Object.getPrototypeOf(e) === Object.prototype,
    pa = e => vs(e) && Object.keys(e).length === 0,
    Fn = e => Array.isArray(e),
    dC = e => typeof e == "string",
    fC = e => typeof e == "number" && !isNaN(e),
    pC = e => typeof e == "boolean",
    _C = e => e instanceof RegExp,
    gs = e => e instanceof Map,
    ys = e => e instanceof Set,
    Cf = e => uC(e) === "Symbol",
    hC = e => e instanceof Date && !isNaN(e.valueOf()),
    mC = e => e instanceof Error,
    Tf = e => typeof e == "number" && isNaN(e),
    vC = e => pC(e) || cC(e) || yf(e) || fC(e) || dC(e) || Cf(e),
    gC = e => typeof e == "bigint",
    yC = e => e === 1 / 0 || e === -1 / 0,
    CC = e => ArrayBuffer.isView(e) && !(e instanceof DataView),
    TC = e => e instanceof URL;
  q();
  var bf = e => e.replace(/\./g, "\\."),
    _a = e => e.map(String).map(bf).join("."),
    Cs = e => {
      const t = [];
      let n = "";
      for (let s = 0; s < e.length; s++) {
        let r = e.charAt(s);
        if (r === "\\" && e.charAt(s + 1) === ".") {
          n += ".", s++;
          continue
        }
        if (r === ".") {
          t.push(n), n = "";
          continue
        }
        n += r
      }
      const o = n;
      return t.push(o), t
    };
  q();

  function an(e, t, n, o) {
    return {
      isApplicable: e,
      annotation: t,
      transform: n,
      untransform: o
    }
  }
  var Sf = [an(yf, "undefined", () => null, () => {}), an(gC, "bigint", e => e.toString(), e => typeof BigInt < "u" ? BigInt(e) : (console.error("Please add a BigInt polyfill."), e)), an(hC, "Date", e => e.toISOString(), e => new Date(e)), an(mC, "Error", (e, t) => {
    const n = {
      name: e.name,
      message: e.message
    };
    return t.allowedErrorProps.forEach(o => {
      n[o] = e[o]
    }), n
  }, (e, t) => {
    const n = new Error(e.message);
    return n.name = e.name, n.stack = e.stack, t.allowedErrorProps.forEach(o => {
      n[o] = e[o]
    }), n
  }), an(_C, "regexp", e => "" + e, e => {
    const t = e.slice(1, e.lastIndexOf("/")),
      n = e.slice(e.lastIndexOf("/") + 1);
    return new RegExp(t, n)
  }), an(ys, "set", e => [...e.values()], e => new Set(e)), an(gs, "map", e => [...e.entries()], e => new Map(e)), an(e => Tf(e) || yC(e), "number", e => Tf(e) ? "NaN" : e > 0 ? "Infinity" : "-Infinity", Number), an(e => e === 0 && 1 / e === -1 / 0, "number", () => "-0", Number), an(TC, "URL", e => e.toString(), e => new URL(e))];

  function Rr(e, t, n, o) {
    return {
      isApplicable: e,
      annotation: t,
      transform: n,
      untransform: o
    }
  }
  var Df = Rr((e, t) => Cf(e) ? !!t.symbolRegistry.getIdentifier(e) : !1, (e, t) => ["symbol", t.symbolRegistry.getIdentifier(e)], e => e.description, (e, t, n) => {
      const o = n.symbolRegistry.getValue(t[1]);
      if (!o) throw new Error("Trying to deserialize unknown symbol");
      return o
    }),
    bC = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array, Uint8ClampedArray].reduce((e, t) => (e[t.name] = t, e), {}),
    Pf = Rr(CC, e => ["typed-array", e.constructor.name], e => [...e], (e, t) => {
      const n = bC[t[1]];
      if (!n) throw new Error("Trying to deserialize unknown typed array");
      return new n(e)
    });

  function Ef(e, t) {
    return e?.constructor ? !!t.classRegistry.getIdentifier(e.constructor) : !1
  }
  var Of = Rr(Ef, (e, t) => ["class", t.classRegistry.getIdentifier(e.constructor)], (e, t) => {
      const n = t.classRegistry.getAllowedProps(e.constructor);
      if (!n) return {
        ...e
      };
      const o = {};
      return n.forEach(s => {
        o[s] = e[s]
      }), o
    }, (e, t, n) => {
      const o = n.classRegistry.getValue(t[1]);
      if (!o) throw new Error(`Trying to deserialize unknown class '${t[1]}' - check https://github.com/blitz-js/superjson/issues/116#issuecomment-773996564`);
      return Object.assign(Object.create(o.prototype), e)
    }),
    If = Rr((e, t) => !!t.customTransformerRegistry.findApplicable(e), (e, t) => ["custom", t.customTransformerRegistry.findApplicable(e).name], (e, t) => t.customTransformerRegistry.findApplicable(e).serialize(e), (e, t, n) => {
      const o = n.customTransformerRegistry.findByName(t[1]);
      if (!o) throw new Error("Trying to deserialize unknown custom value");
      return o.deserialize(e)
    }),
    SC = [Of, Df, If, Pf],
    Rf = (e, t) => {
      const n = gf(SC, s => s.isApplicable(e, t));
      if (n) return {
        value: n.transform(e, t),
        type: n.annotation(e, t)
      };
      const o = gf(Sf, s => s.isApplicable(e, t));
      if (o) return {
        value: o.transform(e, t),
        type: o.annotation
      }
    },
    wf = {};
  Sf.forEach(e => {
    wf[e.annotation] = e
  });
  var DC = (e, t, n) => {
    if (Fn(t)) switch (t[0]) {
      case "symbol":
        return Df.untransform(e, t, n);
      case "class":
        return Of.untransform(e, t, n);
      case "custom":
        return If.untransform(e, t, n);
      case "typed-array":
        return Pf.untransform(e, t, n);
      default:
        throw new Error("Unknown transformation: " + t)
    } else {
      const o = wf[t];
      if (!o) throw new Error("Unknown transformation: " + t);
      return o.untransform(e, n)
    }
  };
  q();
  var Mo = (e, t) => {
    if (t > e.size) throw new Error("index out of bounds");
    const n = e.keys();
    for (; t > 0;) n.next(), t--;
    return n.next().value
  };

  function Af(e) {
    if (Ir(e, "__proto__")) throw new Error("__proto__ is not allowed as a property");
    if (Ir(e, "prototype")) throw new Error("prototype is not allowed as a property");
    if (Ir(e, "constructor")) throw new Error("constructor is not allowed as a property")
  }
  var PC = (e, t) => {
      Af(t);
      for (let n = 0; n < t.length; n++) {
        const o = t[n];
        if (ys(e)) e = Mo(e, +o);
        else if (gs(e)) {
          const s = +o,
            r = +t[++n] == 0 ? "key" : "value",
            a = Mo(e, s);
          switch (r) {
            case "key":
              e = a;
              break;
            case "value":
              e = e.get(a);
              break
          }
        } else e = e[o]
      }
      return e
    },
    ha = (e, t, n) => {
      if (Af(t), t.length === 0) return n(e);
      let o = e;
      for (let r = 0; r < t.length - 1; r++) {
        const a = t[r];
        if (Fn(o)) {
          const i = +a;
          o = o[i]
        } else if (vs(o)) o = o[a];
        else if (ys(o)) {
          const i = +a;
          o = Mo(o, i)
        } else if (gs(o)) {
          if (r === t.length - 2) break;
          const l = +a,
            c = +t[++r] == 0 ? "key" : "value",
            u = Mo(o, l);
          switch (c) {
            case "key":
              o = u;
              break;
            case "value":
              o = o.get(u);
              break
          }
        }
      }
      const s = t[t.length - 1];
      if (Fn(o) ? o[+s] = n(o[+s]) : vs(o) && (o[s] = n(o[s])), ys(o)) {
        const r = Mo(o, +s),
          a = n(r);
        r !== a && (o.delete(r), o.add(a))
      }
      if (gs(o)) {
        const r = +t[t.length - 2],
          a = Mo(o, r);
        switch (+s == 0 ? "key" : "value") {
          case "key": {
            const l = n(a);
            o.set(l, o.get(a)), l !== a && o.delete(a);
            break
          }
          case "value": {
            o.set(a, n(o.get(a)));
            break
          }
        }
      }
      return e
    };

  function ma(e, t, n = []) {
    if (!e) return;
    if (!Fn(e)) {
      No(e, (r, a) => ma(r, t, [...n, ...Cs(a)]));
      return
    }
    const [o, s] = e;
    s && No(s, (r, a) => {
      ma(r, t, [...n, ...Cs(a)])
    }), t(o, n)
  }

  function EC(e, t, n) {
    return ma(t, (o, s) => {
      e = ha(e, s, r => DC(r, o, n))
    }), e
  }

  function OC(e, t) {
    function n(o, s) {
      const r = PC(e, Cs(s));
      o.map(Cs).forEach(a => {
        e = ha(e, a, () => r)
      })
    }
    if (Fn(t)) {
      const [o, s] = t;
      o.forEach(r => {
        e = ha(e, Cs(r), () => e)
      }), s && No(s, n)
    } else No(t, n);
    return e
  }
  var IC = (e, t) => vs(e) || Fn(e) || gs(e) || ys(e) || Ef(e, t);

  function RC(e, t, n) {
    const o = n.get(e);
    o ? o.push(t) : n.set(e, [t])
  }

  function wC(e, t) {
    const n = {};
    let o;
    return e.forEach(s => {
      if (s.length <= 1) return;
      t || (s = s.map(i => i.map(String)).sort((i, l) => i.length - l.length));
      const [r, ...a] = s;
      r.length === 0 ? o = a.map(_a) : n[_a(r)] = a.map(_a)
    }), o ? pa(n) ? [o] : [o, n] : pa(n) ? void 0 : n
  }
  var Nf = (e, t, n, o, s = [], r = [], a = new Map) => {
    var i;
    const l = vC(e);
    if (!l) {
      RC(e, s, t);
      const _ = a.get(e);
      if (_) return o ? {
        transformedValue: null
      } : _
    }
    if (!IC(e, n)) {
      const _ = Rf(e, n),
        p = _ ? {
          transformedValue: _.value,
          annotations: [_.type]
        } : {
          transformedValue: e
        };
      return l || a.set(e, p), p
    }
    if (Ir(r, e)) return {
      transformedValue: null
    };
    const c = Rf(e, n),
      u = (i = c?.value) != null ? i : e,
      d = Fn(u) ? [] : {},
      h = {};
    No(u, (_, p) => {
      if (p === "__proto__" || p === "constructor" || p === "prototype") throw new Error(`Detected property ${p}. This is a prototype pollution risk, please remove it from your object.`);
      const m = Nf(_, t, n, o, [...s, p], [...r, e], a);
      d[p] = m.transformedValue, Fn(m.annotations) ? h[p] = m.annotations : vs(m.annotations) && No(m.annotations, (v, E) => {
        h[bf(p) + "." + E] = v
      })
    });
    const f = pa(h) ? {
      transformedValue: d,
      annotations: c ? [c.type] : void 0
    } : {
      transformedValue: d,
      annotations: c ? [c.type, h] : h
    };
    return l || a.set(e, f), f
  };
  q(), q();

  function Mf(e) {
    return Object.prototype.toString.call(e).slice(8, -1)
  }

  function kf(e) {
    return Mf(e) === "Array"
  }

  function AC(e) {
    if (Mf(e) !== "Object") return !1;
    const t = Object.getPrototypeOf(e);
    return !!t && t.constructor === Object && t === Object.prototype
  }

  function NC(e, t, n, o, s) {
    const r = {}.propertyIsEnumerable.call(o, t) ? "enumerable" : "nonenumerable";
    r === "enumerable" && (e[t] = n), s && r === "nonenumerable" && Object.defineProperty(e, t, {
      value: n,
      enumerable: !1,
      writable: !0,
      configurable: !0
    })
  }

  function va(e, t = {}) {
    if (kf(e)) return e.map(s => va(s, t));
    if (!AC(e)) return e;
    const n = Object.getOwnPropertyNames(e),
      o = Object.getOwnPropertySymbols(e);
    return [...n, ...o].reduce((s, r) => {
      if (kf(t.props) && !t.props.includes(r)) return s;
      const a = e[r],
        i = va(a, t);
      return NC(s, r, i, e, t.nonenumerable), s
    }, {})
  }
  var Ge = class {
    constructor({
      dedupe: e = !1
    } = {}) {
      this.classRegistry = new rC, this.symbolRegistry = new vf(t => {
        var n;
        return (n = t.description) != null ? n : ""
      }), this.customTransformerRegistry = new lC, this.allowedErrorProps = [], this.dedupe = e
    }
    serialize(e) {
      const t = new Map,
        n = Nf(e, t, this, this.dedupe),
        o = {
          json: n.transformedValue
        };
      n.annotations && (o.meta = {
        ...o.meta,
        values: n.annotations
      });
      const s = wC(t, this.dedupe);
      return s && (o.meta = {
        ...o.meta,
        referentialEqualities: s
      }), o
    }
    deserialize(e) {
      const {
        json: t,
        meta: n
      } = e;
      let o = va(t);
      return n?.values && (o = EC(o, n.values, this)), n?.referentialEqualities && (o = OC(o, n.referentialEqualities)), o
    }
    stringify(e) {
      return JSON.stringify(this.serialize(e))
    }
    parse(e) {
      return this.deserialize(JSON.parse(e))
    }
    registerClass(e, t) {
      this.classRegistry.register(e, t)
    }
    registerSymbol(e, t) {
      this.symbolRegistry.register(e, t)
    }
    registerCustom(e, t) {
      this.customTransformerRegistry.register({
        name: t,
        ...e
      })
    }
    allowErrorProps(...e) {
      this.allowedErrorProps.push(...e)
    }
  };
  Ge.defaultInstance = new Ge, Ge.serialize = Ge.defaultInstance.serialize.bind(Ge.defaultInstance), Ge.deserialize = Ge.defaultInstance.deserialize.bind(Ge.defaultInstance), Ge.stringify = Ge.defaultInstance.stringify.bind(Ge.defaultInstance), Ge.parse = Ge.defaultInstance.parse.bind(Ge.defaultInstance), Ge.registerClass = Ge.defaultInstance.registerClass.bind(Ge.defaultInstance), Ge.registerSymbol = Ge.defaultInstance.registerSymbol.bind(Ge.defaultInstance), Ge.registerCustom = Ge.defaultInstance.registerCustom.bind(Ge.defaultInstance), Ge.allowErrorProps = Ge.defaultInstance.allowErrorProps.bind(Ge.defaultInstance), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q();
  var Lf, $f;
  ($f = (Lf = pe).__VUE_DEVTOOLS_KIT_MESSAGE_CHANNELS__) != null || (Lf.__VUE_DEVTOOLS_KIT_MESSAGE_CHANNELS__ = []);
  var xf, Ff;
  (Ff = (xf = pe).__VUE_DEVTOOLS_KIT_RPC_CLIENT__) != null || (xf.__VUE_DEVTOOLS_KIT_RPC_CLIENT__ = null);
  var Uf, Bf;
  (Bf = (Uf = pe).__VUE_DEVTOOLS_KIT_RPC_SERVER__) != null || (Uf.__VUE_DEVTOOLS_KIT_RPC_SERVER__ = null);
  var Vf, Hf;
  (Hf = (Vf = pe).__VUE_DEVTOOLS_KIT_VITE_RPC_CLIENT__) != null || (Vf.__VUE_DEVTOOLS_KIT_VITE_RPC_CLIENT__ = null);
  var Gf, jf;
  (jf = (Gf = pe).__VUE_DEVTOOLS_KIT_VITE_RPC_SERVER__) != null || (Gf.__VUE_DEVTOOLS_KIT_VITE_RPC_SERVER__ = null);
  var zf, Yf;
  (Yf = (zf = pe).__VUE_DEVTOOLS_KIT_BROADCAST_RPC_SERVER__) != null || (zf.__VUE_DEVTOOLS_KIT_BROADCAST_RPC_SERVER__ = null), q(), q(), q(), q(), q(), q(), q();
  let ga;
  const Ts = e => ga = e,
    Kf = Symbol("pinia");

  function no(e) {
    return e && typeof e == "object" && Object.prototype.toString.call(e) === "[object Object]" && typeof e.toJSON != "function"
  }
  var ln;
  (function(e) {
    e.direct = "direct", e.patchObject = "patch object", e.patchFunction = "patch function"
  })(ln || (ln = {}));
  const oo = typeof window < "u",
    Wf = typeof window == "object" && window.window === window ? window : typeof self == "object" && self.self === self ? self : typeof global == "object" && global.global === global ? global : typeof globalThis == "object" ? globalThis : {
      HTMLElement: null
    };

  function MC(e, {
    autoBom: t = !1
  } = {}) {
    return t && /^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(e.type) ? new Blob(["\uFEFF", e], {
      type: e.type
    }) : e
  }

  function ya(e, t, n) {
    const o = new XMLHttpRequest;
    o.open("GET", e), o.responseType = "blob", o.onload = function() {
      Xf(o.response, t, n)
    }, o.onerror = function() {
      console.error("could not download file")
    }, o.send()
  }

  function qf(e) {
    const t = new XMLHttpRequest;
    t.open("HEAD", e, !1);
    try {
      t.send()
    } catch {}
    return t.status >= 200 && t.status <= 299
  }

  function wr(e) {
    try {
      e.dispatchEvent(new MouseEvent("click"))
    } catch {
      const n = new MouseEvent("click", {
        bubbles: !0,
        cancelable: !0,
        view: window,
        detail: 0,
        screenX: 80,
        screenY: 20,
        clientX: 80,
        clientY: 20,
        ctrlKey: !1,
        altKey: !1,
        shiftKey: !1,
        metaKey: !1,
        button: 0,
        relatedTarget: null
      });
      e.dispatchEvent(n)
    }
  }
  const Ar = typeof navigator == "object" ? navigator : {
      userAgent: ""
    },
    Qf = /Macintosh/.test(Ar.userAgent) && /AppleWebKit/.test(Ar.userAgent) && !/Safari/.test(Ar.userAgent),
    Xf = oo ? typeof HTMLAnchorElement < "u" && "download" in HTMLAnchorElement.prototype && !Qf ? kC : "msSaveOrOpenBlob" in Ar ? LC : $C : () => {};

  function kC(e, t = "download", n) {
    const o = document.createElement("a");
    o.download = t, o.rel = "noopener", typeof e == "string" ? (o.href = e, o.origin !== location.origin ? qf(o.href) ? ya(e, t, n) : (o.target = "_blank", wr(o)) : wr(o)) : (o.href = URL.createObjectURL(e), setTimeout(function() {
      URL.revokeObjectURL(o.href)
    }, 4e4), setTimeout(function() {
      wr(o)
    }, 0))
  }

  function LC(e, t = "download", n) {
    if (typeof e == "string")
      if (qf(e)) ya(e, t, n);
      else {
        const o = document.createElement("a");
        o.href = e, o.target = "_blank", setTimeout(function() {
          wr(o)
        })
      }
    else navigator.msSaveOrOpenBlob(MC(e, n), t)
  }

  function $C(e, t, n, o) {
    if (o = o || open("", "_blank"), o && (o.document.title = o.document.body.innerText = "downloading..."), typeof e == "string") return ya(e, t, n);
    const s = e.type === "application/octet-stream",
      r = /constructor/i.test(String(Wf.HTMLElement)) || "safari" in Wf,
      a = /CriOS\/[\d]+/.test(navigator.userAgent);
    if ((a || s && r || Qf) && typeof FileReader < "u") {
      const i = new FileReader;
      i.onloadend = function() {
        let l = i.result;
        if (typeof l != "string") throw o = null, new Error("Wrong reader.result type");
        l = a ? l : l.replace(/^data:[^;]*;/, "data:attachment/file;"), o ? o.location.href = l : location.assign(l), o = null
      }, i.readAsDataURL(e)
    } else {
      const i = URL.createObjectURL(e);
      o ? o.location.assign(i) : location.href = i, o = null, setTimeout(function() {
        URL.revokeObjectURL(i)
      }, 4e4)
    }
  }

  function ot(e, t) {
    const n = "🍍 " + e;
    typeof __VUE_DEVTOOLS_TOAST__ == "function" ? __VUE_DEVTOOLS_TOAST__(n, t) : t === "error" ? console.error(n) : t === "warn" ? console.warn(n) : console.log(n)
  }

  function Ca(e) {
    return "_a" in e && "install" in e
  }

  function Jf() {
    if (!("clipboard" in navigator)) return ot("Your browser doesn't support the Clipboard API", "error"), !0
  }

  function Zf(e) {
    return e instanceof Error && e.message.toLowerCase().includes("document is not focused") ? (ot('You need to activate the "Emulate a focused page" setting in the "Rendering" panel of devtools.', "warn"), !0) : !1
  }
  async function xC(e) {
    if (!Jf()) try {
      await navigator.clipboard.writeText(JSON.stringify(e.state.value)), ot("Global state copied to clipboard.")
    } catch (t) {
      if (Zf(t)) return;
      ot("Failed to serialize the state. Check the console for more details.", "error"), console.error(t)
    }
  }
  async function FC(e) {
    if (!Jf()) try {
      ep(e, JSON.parse(await navigator.clipboard.readText())), ot("Global state pasted from clipboard.")
    } catch (t) {
      if (Zf(t)) return;
      ot("Failed to deserialize the state from clipboard. Check the console for more details.", "error"), console.error(t)
    }
  }
  async function UC(e) {
    try {
      Xf(new Blob([JSON.stringify(e.state.value)], {
        type: "text/plain;charset=utf-8"
      }), "pinia-state.json")
    } catch (t) {
      ot("Failed to export the state as JSON. Check the console for more details.", "error"), console.error(t)
    }
  }
  let Cn;

  function BC() {
    Cn || (Cn = document.createElement("input"), Cn.type = "file", Cn.accept = ".json");

    function e() {
      return new Promise((t, n) => {
        Cn.onchange = async () => {
          const o = Cn.files;
          if (!o) return t(null);
          const s = o.item(0);
          return t(s ? {
            text: await s.text(),
            file: s
          } : null)
        }, Cn.oncancel = () => t(null), Cn.onerror = n, Cn.click()
      })
    }
    return e
  }
  async function VC(e) {
    try {
      const n = await BC()();
      if (!n) return;
      const {
        text: o,
        file: s
      } = n;
      ep(e, JSON.parse(o)), ot(`Global state imported from "${s.name}".`)
    } catch (t) {
      ot("Failed to import the state from JSON. Check the console for more details.", "error"), console.error(t)
    }
  }

  function ep(e, t) {
    for (const n in t) {
      const o = e.state.value[n];
      o ? Object.assign(o, t[n]) : e.state.value[n] = t[n]
    }
  }

  function Wt(e) {
    return {
      _custom: {
        display: e
      }
    }
  }
  const tp = "🍍 Pinia (root)",
    Nr = "_root";

  function HC(e) {
    return Ca(e) ? {
      id: Nr,
      label: tp
    } : {
      id: e.$id,
      label: e.$id
    }
  }

  function GC(e) {
    if (Ca(e)) {
      const n = Array.from(e._s.keys()),
        o = e._s;
      return {
        state: n.map(r => ({
          editable: !0,
          key: r,
          value: e.state.value[r]
        })),
        getters: n.filter(r => o.get(r)._getters).map(r => {
          const a = o.get(r);
          return {
            editable: !1,
            key: r,
            value: a._getters.reduce((i, l) => (i[l] = a[l], i), {})
          }
        })
      }
    }
    const t = {
      state: Object.keys(e.$state).map(n => ({
        editable: !0,
        key: n,
        value: e.$state[n]
      }))
    };
    return e._getters && e._getters.length && (t.getters = e._getters.map(n => ({
      editable: !1,
      key: n,
      value: e[n]
    }))), e._customProperties.size && (t.customProperties = Array.from(e._customProperties).map(n => ({
      editable: !0,
      key: n,
      value: e[n]
    }))), t
  }

  function jC(e) {
    return e ? Array.isArray(e) ? e.reduce((t, n) => (t.keys.push(n.key), t.operations.push(n.type), t.oldValue[n.key] = n.oldValue, t.newValue[n.key] = n.newValue, t), {
      oldValue: {},
      keys: [],
      operations: [],
      newValue: {}
    }) : {
      operation: Wt(e.type),
      key: Wt(e.key),
      oldValue: e.oldValue,
      newValue: e.newValue
    } : {}
  }

  function zC(e) {
    switch (e) {
      case ln.direct:
        return "mutation";
      case ln.patchFunction:
        return "$patch";
      case ln.patchObject:
        return "$patch";
      default:
        return "unknown"
    }
  }
  let ko = !0;
  const Mr = [],
    so = "pinia:mutations",
    ft = "pinia",
    {
      assign: YC
    } = Object,
    kr = e => "🍍 " + e;

  function KC(e, t) {
    tf({
      id: "dev.esm.pinia",
      label: "Pinia 🍍",
      logo: "https://pinia.vuejs.org/logo.svg",
      packageName: "pinia",
      homepage: "https://pinia.vuejs.org",
      componentStateTypes: Mr,
      app: e
    }, n => {
      typeof n.now != "function" && ot("You seem to be using an outdated version of Vue Devtools. Are you still using the Beta release instead of the stable one? You can find the links at https://devtools.vuejs.org/guide/installation.html."), n.addTimelineLayer({
        id: so,
        label: "Pinia 🍍",
        color: 15064968
      }), n.addInspector({
        id: ft,
        label: "Pinia 🍍",
        icon: "storage",
        treeFilterPlaceholder: "Search stores",
        actions: [{
          icon: "content_copy",
          action: () => {
            xC(t)
          },
          tooltip: "Serialize and copy the state"
        }, {
          icon: "content_paste",
          action: async () => {
            await FC(t), n.sendInspectorTree(ft), n.sendInspectorState(ft)
          },
          tooltip: "Replace the state with the content of your clipboard"
        }, {
          icon: "save",
          action: () => {
            UC(t)
          },
          tooltip: "Save the state as a JSON file"
        }, {
          icon: "folder_open",
          action: async () => {
            await VC(t), n.sendInspectorTree(ft), n.sendInspectorState(ft)
          },
          tooltip: "Import the state from a JSON file"
        }],
        nodeActions: [{
          icon: "restore",
          tooltip: 'Reset the state (with "$reset")',
          action: o => {
            const s = t._s.get(o);
            s ? typeof s.$reset != "function" ? ot(`Cannot reset "${o}" store because it doesn't have a "$reset" method implemented.`, "warn") : (s.$reset(), ot(`Store "${o}" reset.`)) : ot(`Cannot reset "${o}" store because it wasn't found.`, "warn")
          }
        }]
      }), n.on.inspectComponent(o => {
        const s = o.componentInstance && o.componentInstance.proxy;
        if (s && s._pStores) {
          const r = o.componentInstance.proxy._pStores;
          Object.values(r).forEach(a => {
            o.instanceData.state.push({
              type: kr(a.$id),
              key: "state",
              editable: !0,
              value: a._isOptionsAPI ? {
                _custom: {
                  value: De(a.$state),
                  actions: [{
                    icon: "restore",
                    tooltip: "Reset the state of this store",
                    action: () => a.$reset()
                  }]
                }
              } : Object.keys(a.$state).reduce((i, l) => (i[l] = a.$state[l], i), {})
            }), a._getters && a._getters.length && o.instanceData.state.push({
              type: kr(a.$id),
              key: "getters",
              editable: !1,
              value: a._getters.reduce((i, l) => {
                try {
                  i[l] = a[l]
                } catch (c) {
                  i[l] = c
                }
                return i
              }, {})
            })
          })
        }
      }), n.on.getInspectorTree(o => {
        if (o.app === e && o.inspectorId === ft) {
          let s = [t];
          s = s.concat(Array.from(t._s.values())), o.rootNodes = (o.filter ? s.filter(r => "$id" in r ? r.$id.toLowerCase().includes(o.filter.toLowerCase()) : tp.toLowerCase().includes(o.filter.toLowerCase())) : s).map(HC)
        }
      }), globalThis.$pinia = t, n.on.getInspectorState(o => {
        if (o.app === e && o.inspectorId === ft) {
          const s = o.nodeId === Nr ? t : t._s.get(o.nodeId);
          if (!s) return;
          s && (o.nodeId !== Nr && (globalThis.$store = De(s)), o.state = GC(s))
        }
      }), n.on.editInspectorState(o => {
        if (o.app === e && o.inspectorId === ft) {
          const s = o.nodeId === Nr ? t : t._s.get(o.nodeId);
          if (!s) return ot(`store "${o.nodeId}" not found`, "error");
          const {
            path: r
          } = o;
          Ca(s) ? r.unshift("state") : (r.length !== 1 || !s._customProperties.has(r[0]) || r[0] in s.$state) && r.unshift("$state"), ko = !1, o.set(s, r, o.state.value), ko = !0
        }
      }), n.on.editComponentState(o => {
        if (o.type.startsWith("🍍")) {
          const s = o.type.replace(/^🍍\s*/, ""),
            r = t._s.get(s);
          if (!r) return ot(`store "${s}" not found`, "error");
          const {
            path: a
          } = o;
          if (a[0] !== "state") return ot(`Invalid path for store "${s}":
${a}
Only state can be modified.`);
          a[0] = "$state", ko = !1, o.set(r, a, o.state.value), ko = !0
        }
      })
    })
  }

  function WC(e, t) {
    Mr.includes(kr(t.$id)) || Mr.push(kr(t.$id)), tf({
      id: "dev.esm.pinia",
      label: "Pinia 🍍",
      logo: "https://pinia.vuejs.org/logo.svg",
      packageName: "pinia",
      homepage: "https://pinia.vuejs.org",
      componentStateTypes: Mr,
      app: e,
      settings: {
        logStoreChanges: {
          label: "Notify about new/deleted stores",
          type: "boolean",
          defaultValue: !0
        }
      }
    }, n => {
      const o = typeof n.now == "function" ? n.now.bind(n) : Date.now;
      t.$onAction(({
        after: a,
        onError: i,
        name: l,
        args: c
      }) => {
        const u = np++;
        n.addTimelineEvent({
          layerId: so,
          event: {
            time: o(),
            title: "🛫 " + l,
            subtitle: "start",
            data: {
              store: Wt(t.$id),
              action: Wt(l),
              args: c
            },
            groupId: u
          }
        }), a(d => {
          Un = void 0, n.addTimelineEvent({
            layerId: so,
            event: {
              time: o(),
              title: "🛬 " + l,
              subtitle: "end",
              data: {
                store: Wt(t.$id),
                action: Wt(l),
                args: c,
                result: d
              },
              groupId: u
            }
          })
        }), i(d => {
          Un = void 0, n.addTimelineEvent({
            layerId: so,
            event: {
              time: o(),
              logType: "error",
              title: "💥 " + l,
              subtitle: "end",
              data: {
                store: Wt(t.$id),
                action: Wt(l),
                args: c,
                error: d
              },
              groupId: u
            }
          })
        })
      }, !0), t._customProperties.forEach(a => {
        F(() => T(t[a]), (i, l) => {
          n.notifyComponentUpdate(), n.sendInspectorState(ft), ko && n.addTimelineEvent({
            layerId: so,
            event: {
              time: o(),
              title: "Change",
              subtitle: a,
              data: {
                newValue: i,
                oldValue: l
              },
              groupId: Un
            }
          })
        }, {
          deep: !0
        })
      }), t.$subscribe(({
        events: a,
        type: i
      }, l) => {
        if (n.notifyComponentUpdate(), n.sendInspectorState(ft), !ko) return;
        const c = {
          time: o(),
          title: zC(i),
          data: YC({
            store: Wt(t.$id)
          }, jC(a)),
          groupId: Un
        };
        i === ln.patchFunction ? c.subtitle = "⤵️" : i === ln.patchObject ? c.subtitle = "🧩" : a && !Array.isArray(a) && (c.subtitle = a.type), a && (c.data["rawEvent(s)"] = {
          _custom: {
            display: "DebuggerEvent",
            type: "object",
            tooltip: "raw DebuggerEvent[]",
            value: a
          }
        }), n.addTimelineEvent({
          layerId: so,
          event: c
        })
      }, {
        detached: !0,
        flush: "sync"
      });
      const s = t._hotUpdate;
      t._hotUpdate = _n(a => {
        s(a), n.addTimelineEvent({
          layerId: so,
          event: {
            time: o(),
            title: "🔥 " + t.$id,
            subtitle: "HMR update",
            data: {
              store: Wt(t.$id),
              info: Wt("HMR update")
            }
          }
        }), n.notifyComponentUpdate(), n.sendInspectorTree(ft), n.sendInspectorState(ft)
      });
      const {
        $dispose: r
      } = t;
      t.$dispose = () => {
        r(), n.notifyComponentUpdate(), n.sendInspectorTree(ft), n.sendInspectorState(ft), n.getSettings().logStoreChanges && ot(`Disposed "${t.$id}" store 🗑`)
      }, n.notifyComponentUpdate(), n.sendInspectorTree(ft), n.sendInspectorState(ft), n.getSettings().logStoreChanges && ot(`"${t.$id}" store installed 🆕`)
    })
  }
  let np = 0,
    Un;

  function op(e, t, n) {
    const o = t.reduce((s, r) => (s[r] = De(e)[r], s), {});
    for (const s in o) e[s] = function() {
      const r = np,
        a = n ? new Proxy(e, {
          get(...l) {
            return Un = r, Reflect.get(...l)
          },
          set(...l) {
            return Un = r, Reflect.set(...l)
          }
        }) : e;
      Un = r;
      const i = o[s].apply(a, arguments);
      return Un = void 0, i
    }
  }

  function qC({
    app: e,
    store: t,
    options: n
  }) {
    if (!t.$id.startsWith("__hot:")) {
      if (t._isOptionsAPI = !!n.state, !t._p._testing) {
        op(t, Object.keys(n.actions), t._isOptionsAPI);
        const o = t._hotUpdate;
        De(t)._hotUpdate = function(s) {
          o.apply(this, arguments), op(t, Object.keys(s._hmrPayload.actions), !!t._isOptionsAPI)
        }
      }
      WC(e, t)
    }
  }

  function QC() {
    const e = du(!0),
      t = e.run(() => H({}));
    let n = [],
      o = [];
    const s = _n({
      install(r) {
        Ts(s), s._a = r, r.provide(Kf, s), r.config.globalProperties.$pinia = s, oo && KC(r, s), o.forEach(a => n.push(a)), o = []
      },
      use(r) {
        return this._a ? n.push(r) : o.push(r), this
      },
      _p: n,
      _a: null,
      _e: e,
      _s: new Map,
      state: t
    });
    return oo && typeof Proxy < "u" && s.use(qC), s
  }

  function sp(e, t) {
    for (const n in t) {
      const o = t[n];
      if (!(n in e)) continue;
      const s = e[n];
      no(s) && no(o) && !Fe(o) && !zt(o) ? e[n] = sp(s, o) : e[n] = o
    }
    return e
  }
  const XC = () => {};

  function rp(e, t, n, o = XC) {
    e.push(t);
    const s = () => {
      const r = e.indexOf(t);
      r > -1 && (e.splice(r, 1), o())
    };
    return !n && fu() && si(s), s
  }

  function Lo(e, ...t) {
    e.slice().forEach(n => {
      n(...t)
    })
  }
  const JC = e => e(),
    ip = Symbol(),
    Ta = Symbol();

  function ba(e, t) {
    e instanceof Map && t instanceof Map ? t.forEach((n, o) => e.set(o, n)) : e instanceof Set && t instanceof Set && t.forEach(e.add, e);
    for (const n in t) {
      if (!t.hasOwnProperty(n)) continue;
      const o = t[n],
        s = e[n];
      no(s) && no(o) && e.hasOwnProperty(n) && !Fe(o) && !zt(o) ? e[n] = ba(s, o) : e[n] = o
    }
    return e
  }
  const ZC = Symbol("pinia:skipHydration");

  function e0(e) {
    return !no(e) || !Object.prototype.hasOwnProperty.call(e, ZC)
  }
  const {
    assign: xt
  } = Object;

  function ap(e) {
    return !!(Fe(e) && e.effect)
  }

  function lp(e, t, n, o) {
    const {
      state: s,
      actions: r,
      getters: a
    } = t, i = n.state.value[e];
    let l;

    function c() {
      !i && !o && (n.state.value[e] = s ? s() : {});
      const u = Qs(o ? H(s ? s() : {}).value : n.state.value[e]);
      return xt(u, r, Object.keys(a || {}).reduce((d, h) => (h in u && console.warn(`[🍍]: A getter cannot have the same name as another state property. Rename one of them. Found with "${h}" in store "${e}".`), d[h] = _n(R(() => {
        Ts(n);
        const f = n._s.get(e);
        return a[h].call(f, f)
      })), d), {}))
    }
    return l = Sa(e, c, t, n, o, !0), l
  }

  function Sa(e, t, n = {}, o, s, r) {
    let a;
    const i = xt({
      actions: {}
    }, n);
    if (!o._e.active) throw new Error("Pinia destroyed");
    const l = {
      deep: !0
    };
    l.onTrigger = y => {
      c ? f = y : c == !1 && !A._hotUpdating && (Array.isArray(f) ? f.push(y) : console.error("🍍 debuggerEvents should be an array. This is most likely an internal Pinia bug."))
    };
    let c, u, d = [],
      h = [],
      f;
    const _ = o.state.value[e];
    !r && !_ && !s && (o.state.value[e] = {});
    const p = H({});
    let m;

    function v(y) {
      let I;
      c = u = !1, f = [], typeof y == "function" ? (y(o.state.value[e]), I = {
        type: ln.patchFunction,
        storeId: e,
        events: f
      }) : (ba(o.state.value[e], y), I = {
        type: ln.patchObject,
        payload: y,
        storeId: e,
        events: f
      });
      const w = m = Symbol();
      Xo().then(() => {
        m === w && (c = !0)
      }), u = !0, Lo(d, I, o.state.value[e])
    }
    const E = r ? function() {
      const {
        state: I
      } = n, w = I ? I() : {};
      this.$patch(U => {
        xt(U, w)
      })
    } : (() => {
      throw new Error(`🍍: Store "${e}" is built using the setup syntax and does not implement $reset().`)
    });

    function k() {
      a.stop(), d = [], h = [], o._s.delete(e)
    }
    const N = (y, I = "") => {
        if (ip in y) return y[Ta] = I, y;
        const w = function() {
          Ts(o);
          const U = Array.from(arguments),
            Z = [],
            me = [];

          function _e(ue) {
            Z.push(ue)
          }

          function B(ue) {
            me.push(ue)
          }
          Lo(h, {
            args: U,
            name: w[Ta],
            store: A,
            after: _e,
            onError: B
          });
          let W;
          try {
            W = y.apply(this && this.$id === e ? this : A, U)
          } catch (ue) {
            throw Lo(me, ue), ue
          }
          return W instanceof Promise ? W.then(ue => (Lo(Z, ue), ue)).catch(ue => (Lo(me, ue), Promise.reject(ue))) : (Lo(Z, W), W)
        };
        return w[ip] = !0, w[Ta] = I, w
      },
      D = _n({
        actions: {},
        getters: {},
        state: [],
        hotState: p
      }),
      O = {
        _p: o,
        $id: e,
        $onAction: rp.bind(null, h),
        $patch: v,
        $reset: E,
        $subscribe(y, I = {}) {
          const w = rp(d, y, I.detached, () => U()),
            U = a.run(() => F(() => o.state.value[e], Z => {
              (I.flush === "sync" ? u : c) && y({
                storeId: e,
                type: ln.direct,
                events: f
              }, Z)
            }, xt({}, l, I)));
          return w
        },
        $dispose: k
      },
      A = xe(xt({
        _hmrPayload: D,
        _customProperties: _n(new Set)
      }, O));
    o._s.set(e, A);
    const C = (o._a && o._a.runWithContext || JC)(() => o._e.run(() => (a = du()).run(() => t({
      action: N
    }))));
    for (const y in C) {
      const I = C[y];
      if (Fe(I) && !ap(I) || zt(I)) s ? p.value[y] = Xs(C, y) : r || (_ && e0(I) && (Fe(I) ? I.value = _[y] : ba(I, _[y])), o.state.value[e][y] = I), D.state.push(y);
      else if (typeof I == "function") {
        const w = s ? I : N(I, y);
        C[y] = w, D.actions[y] = I, i.actions[y] = I
      } else ap(I) && (D.getters[y] = r ? n.getters[y] : I, oo && (C._getters || (C._getters = _n([]))).push(y))
    }
    if (xt(A, C), xt(De(A), C), Object.defineProperty(A, "$state", {
        get: () => s ? p.value : o.state.value[e],
        set: y => {
          if (s) throw new Error("cannot set hotState");
          v(I => {
            xt(I, y)
          })
        }
      }), A._hotUpdate = _n(y => {
        A._hotUpdating = !0, y._hmrPayload.state.forEach(I => {
          if (I in A.$state) {
            const w = y.$state[I],
              U = A.$state[I];
            typeof w == "object" && no(w) && no(U) ? sp(w, U) : y.$state[I] = U
          }
          A[I] = Xs(y.$state, I)
        }), Object.keys(A.$state).forEach(I => {
          I in y.$state || delete A[I]
        }), c = !1, u = !1, o.state.value[e] = Xs(y._hmrPayload, "hotState"), u = !0, Xo().then(() => {
          c = !0
        });
        for (const I in y._hmrPayload.actions) {
          const w = y[I];
          A[I] = N(w, I)
        }
        for (const I in y._hmrPayload.getters) {
          const w = y._hmrPayload.getters[I],
            U = r ? R(() => (Ts(o), w.call(A, A))) : w;
          A[I] = U
        }
        Object.keys(A._hmrPayload.getters).forEach(I => {
          I in y._hmrPayload.getters || delete A[I]
        }), Object.keys(A._hmrPayload.actions).forEach(I => {
          I in y._hmrPayload.actions || delete A[I]
        }), A._hmrPayload = y._hmrPayload, A._getters = y._getters, A._hotUpdating = !1
      }), oo) {
      const y = {
        writable: !0,
        configurable: !0,
        enumerable: !1
      };
      ["_p", "_hmrPayload", "_getters", "_customProperties"].forEach(I => {
        Object.defineProperty(A, I, xt({
          value: A[I]
        }, y))
      })
    }
    return o._p.forEach(y => {
      if (oo) {
        const I = a.run(() => y({
          store: A,
          app: o._a,
          pinia: o,
          options: i
        }));
        Object.keys(I || {}).forEach(w => A._customProperties.add(w)), xt(A, I)
      } else xt(A, a.run(() => y({
        store: A,
        app: o._a,
        pinia: o,
        options: i
      })))
    }), A.$state && typeof A.$state == "object" && typeof A.$state.constructor == "function" && !A.$state.constructor.toString().includes("[native code]") && console.warn(`[🍍]: The "state" must be a plain object. It cannot be
	state: () => new MyClass()
Found in store "${A.$id}".`), _ && r && n.hydrate && n.hydrate(A.$state, _), c = !0, u = !0, A
  } /*! #__NO_SIDE_EFFECTS__ */
  function bs(e, t, n) {
    let o;
    const s = typeof t == "function";
    o = s ? n : t;

    function r(a, i) {
      const l = dc();
      if (a = a || (l ? le(Kf, null) : null), a && Ts(a), !ga) throw new Error(`[🍍]: "getActivePinia()" was called but there was no active Pinia. Are you trying to use a store before calling "app.use(pinia)"?
See https://pinia.vuejs.org/core-concepts/outside-component-usage.html for help.
This will fail in production.`);
      a = ga, a._s.has(e) || (s ? Sa(e, t, o, a) : lp(e, o, a), r._pinia = a);
      const c = a._s.get(e);
      if (i) {
        const u = "__hot:" + e,
          d = s ? Sa(u, t, o, a, !0) : lp(u, xt({}, o), a, !0);
        i._hotUpdate(d), delete a.state.value[u], a._s.delete(u)
      }
      if (oo) {
        const u = hr();
        if (u && u.proxy && !i) {
          const d = u.proxy,
            h = "_pStores" in d ? d._pStores : d._pStores = {};
          h[e] = c
        }
      }
      return c
    }
    return r.$id = e, r
  }

  function t0(e) {
    const t = De(e),
      n = {};
    for (const o in t) {
      const s = t[o];
      s.effect ? n[o] = R({
        get: () => e[o],
        set(r) {
          e[o] = r
        }
      }) : (Fe(s) || zt(s)) && (n[o] = Xs(e, o))
    }
    return n
  }
  var $o = class {
      constructor() {
        this.listeners = new Set, this.subscribe = this.subscribe.bind(this)
      }
      subscribe(e) {
        return this.listeners.add(e), this.onSubscribe(), () => {
          this.listeners.delete(e), this.onUnsubscribe()
