  }
  const ad = ((...e) => {
    const t = Sg().createApp(...e);
    Pg(t), Eg(t);
    const {
      mount: n
    } = t;
    return t.mount = o => {
      const s = Og(o);
      if (!s) return;
      const r = t._component;
      !be(r) && !r.render && !r.template && (r.template = s.innerHTML), s.nodeType === 1 && (s.textContent = "");
      const a = n(s, !1, Dg(s));
      return s instanceof Element && (s.removeAttribute("v-cloak"), s.setAttribute("data-v-app", "")), a
    }, t
  });

  function Dg(e) {
    if (e instanceof SVGElement) return "svg";
    if (typeof MathMLElement == "function" && e instanceof MathMLElement) return "mathml"
  }

  function Pg(e) {
    Object.defineProperty(e.config, "isNativeTag", {
      value: t => Nh(t) || Mh(t) || kh(t),
      writable: !1
    })
  }

  function Eg(e) {
    {
      const t = e.config.isCustomElement;
      Object.defineProperty(e.config, "isCustomElement", {
        get() {
          return t
        },
        set() {
          rn("The `isCustomElement` config option is deprecated. Use `compilerOptions.isCustomElement` instead.")
        }
      });
      const n = e.config.compilerOptions,
        o = 'The `compilerOptions` config option is only respected when using a build of Vue.js that includes the runtime compiler (aka "full build"). Since you are using the runtime-only build, `compilerOptions` must be passed to `@vue/compiler-dom` in the build setup instead.\n- For vue-loader: pass it via vue-loader\'s `compilerOptions` loader option.\n- For vue-cli: see https://cli.vuejs.org/guide/webpack.html#modifying-options-of-a-loader\n- For vite: pass it via @vitejs/plugin-vue options. See https://github.com/vitejs/vite-plugin-vue/tree/main/packages/plugin-vue#example-for-passing-options-to-vuecompiler-sfc';
      Object.defineProperty(e.config, "compilerOptions", {
        get() {
          return rn(o), n
        },
        set() {
          rn(o)
        }
      })
    }
  }

  function Og(e) {
    if (ze(e)) {
      const t = document.querySelector(e);
      return t || rn(`Failed to mount app: mount target selector "${e}" returned null.`), t
    }
    return window.ShadowRoot && e instanceof window.ShadowRoot && e.mode === "closed" && rn('mounting on a ShadowRoot with `{mode: "closed"}` may lead to unpredictable bugs'), e
  }

  function Ig() {
    Zv()
  }
  Ig();
  var Rg = Object.create,
    ld = Object.defineProperty,
    wg = Object.getOwnPropertyDescriptor,
    qi = Object.getOwnPropertyNames,
    Ag = Object.getPrototypeOf,
    Ng = Object.prototype.hasOwnProperty,
    Mg = (e, t) => function() {
      return e && (t = (0, e[qi(e)[0]])(e = 0)), t
    },
    kg = (e, t) => function() {
      return t || (0, e[qi(e)[0]])((t = {
        exports: {}
      }).exports, t), t.exports
    },
    Lg = (e, t, n, o) => {
      if (t && typeof t == "object" || typeof t == "function")
        for (let s of qi(t)) !Ng.call(e, s) && s !== n && ld(e, s, {
          get: () => t[s],
          enumerable: !(o = wg(t, s)) || o.enumerable
        });
      return e
    },
    $g = (e, t, n) => (n = e != null ? Rg(Ag(e)) : {}, Lg(ld(n, "default", {
      value: e,
      enumerable: !0
    }), e)),
    _s = Mg({
      "../../node_modules/.pnpm/tsup@8.4.0_@microsoft+api-extractor@7.51.1_@types+node@22.13.14__jiti@2.4.2_postcss@8.5_96eb05a9d65343021e53791dd83f3773/node_modules/tsup/assets/esm_shims.js"() {}
    }),
    xg = kg({
      "../../node_modules/.pnpm/rfdc@1.4.1/node_modules/rfdc/index.js"(e, t) {
        _s(), t.exports = o;

        function n(r) {
          return r instanceof Buffer ? Buffer.from(r) : new r.constructor(r.buffer.slice(), r.byteOffset, r.length)
        }

        function o(r) {
          if (r = r || {}, r.circles) return s(r);
          const a = new Map;
          if (a.set(Date, d => new Date(d)), a.set(Map, (d, h) => new Map(l(Array.from(d), h))), a.set(Set, (d, h) => new Set(l(Array.from(d), h))), r.constructorHandlers)
            for (const d of r.constructorHandlers) a.set(d[0], d[1]);
          let i = null;
          return r.proto ? u : c;

          function l(d, h) {
            const f = Object.keys(d),
              _ = new Array(f.length);
            for (let p = 0; p < f.length; p++) {
              const m = f[p],
                v = d[m];
              typeof v != "object" || v === null ? _[m] = v : v.constructor !== Object && (i = a.get(v.constructor)) ? _[m] = i(v, h) : ArrayBuffer.isView(v) ? _[m] = n(v) : _[m] = h(v)
            }
            return _
          }

          function c(d) {
            if (typeof d != "object" || d === null) return d;
            if (Array.isArray(d)) return l(d, c);
            if (d.constructor !== Object && (i = a.get(d.constructor))) return i(d, c);
            const h = {};
            for (const f in d) {
              if (Object.hasOwnProperty.call(d, f) === !1) continue;
              const _ = d[f];
              typeof _ != "object" || _ === null ? h[f] = _ : _.constructor !== Object && (i = a.get(_.constructor)) ? h[f] = i(_, c) : ArrayBuffer.isView(_) ? h[f] = n(_) : h[f] = c(_)
            }
            return h
          }

          function u(d) {
            if (typeof d != "object" || d === null) return d;
            if (Array.isArray(d)) return l(d, u);
            if (d.constructor !== Object && (i = a.get(d.constructor))) return i(d, u);
            const h = {};
            for (const f in d) {
              const _ = d[f];
              typeof _ != "object" || _ === null ? h[f] = _ : _.constructor !== Object && (i = a.get(_.constructor)) ? h[f] = i(_, u) : ArrayBuffer.isView(_) ? h[f] = n(_) : h[f] = u(_)
            }
            return h
          }
        }

        function s(r) {
          const a = [],
            i = [],
            l = new Map;
          if (l.set(Date, f => new Date(f)), l.set(Map, (f, _) => new Map(u(Array.from(f), _))), l.set(Set, (f, _) => new Set(u(Array.from(f), _))), r.constructorHandlers)
            for (const f of r.constructorHandlers) l.set(f[0], f[1]);
          let c = null;
          return r.proto ? h : d;

          function u(f, _) {
            const p = Object.keys(f),
              m = new Array(p.length);
            for (let v = 0; v < p.length; v++) {
              const E = p[v],
                k = f[E];
              if (typeof k != "object" || k === null) m[E] = k;
              else if (k.constructor !== Object && (c = l.get(k.constructor))) m[E] = c(k, _);
              else if (ArrayBuffer.isView(k)) m[E] = n(k);
              else {
                const N = a.indexOf(k);
                N !== -1 ? m[E] = i[N] : m[E] = _(k)
              }
            }
            return m
          }

          function d(f) {
            if (typeof f != "object" || f === null) return f;
            if (Array.isArray(f)) return u(f, d);
            if (f.constructor !== Object && (c = l.get(f.constructor))) return c(f, d);
            const _ = {};
            a.push(f), i.push(_);
            for (const p in f) {
              if (Object.hasOwnProperty.call(f, p) === !1) continue;
              const m = f[p];
              if (typeof m != "object" || m === null) _[p] = m;
              else if (m.constructor !== Object && (c = l.get(m.constructor))) _[p] = c(m, d);
              else if (ArrayBuffer.isView(m)) _[p] = n(m);
              else {
                const v = a.indexOf(m);
                v !== -1 ? _[p] = i[v] : _[p] = d(m)
              }
            }
            return a.pop(), i.pop(), _
          }

          function h(f) {
            if (typeof f != "object" || f === null) return f;
            if (Array.isArray(f)) return u(f, h);
            if (f.constructor !== Object && (c = l.get(f.constructor))) return c(f, h);
            const _ = {};
            a.push(f), i.push(_);
            for (const p in f) {
              const m = f[p];
              if (typeof m != "object" || m === null) _[p] = m;
              else if (m.constructor !== Object && (c = l.get(m.constructor))) _[p] = c(m, h);
              else if (ArrayBuffer.isView(m)) _[p] = n(m);
              else {
                const v = a.indexOf(m);
                v !== -1 ? _[p] = i[v] : _[p] = h(m)
              }
            }
            return a.pop(), i.pop(), _
          }
        }
      }
    });
  _s(), _s(), _s();
  var ud = typeof navigator < "u",
    pe = typeof window < "u" ? window : typeof globalThis < "u" ? globalThis : typeof global < "u" ? global : {};
  typeof pe.chrome < "u" && pe.chrome.devtools, ud && (pe.self, pe.top);
  var cd;
  typeof navigator < "u" && ((cd = navigator.userAgent) == null || cd.toLowerCase().includes("electron")), _s();
  var Fg = $g(xg()),
    Ug = /(?:^|[-_/])(\w)/g;

  function Bg(e, t) {
    return t ? t.toUpperCase() : ""
  }

  function Vg(e) {
    return e && `${e}`.replace(Ug, Bg)
  }

  function Hg(e, t) {
    let n = e.replace(/^[a-z]:/i, "").replace(/\\/g, "/");
    n.endsWith(`index${t}`) && (n = n.replace(`/index${t}`, t));
    const o = n.lastIndexOf("/"),
      s = n.substring(o + 1);
    {
      const r = s.lastIndexOf(t);
      return s.substring(0, r)
    }
  }
  var dd = (0, Fg.default)({
    circles: !0
  });
  const Gg = {
    trailing: !0
  };

  function Io(e, t = 25, n = {}) {
    if (n = {
        ...Gg,
        ...n
      }, !Number.isFinite(t)) throw new TypeError("Expected `wait` to be a finite number");
    let o, s, r = [],
      a, i;
    const l = (c, u) => (a = jg(e, c, u), a.finally(() => {
      if (a = null, n.trailing && i && !s) {
        const d = l(c, i);
        return i = null, d
      }
    }), a);
    return function(...c) {
      return a ? (n.trailing && (i = c), a) : new Promise(u => {
        const d = !s && n.leading;
        clearTimeout(s), s = setTimeout(() => {
          s = null;
          const h = n.leading ? o : l(this, c);
          for (const f of r) f(h);
          r = []
        }, t), d ? (o = l(this, c), u(o)) : r.push(u)
      })
    }
  }
  async function jg(e, t, n) {
    return await e.apply(t, n)
  }

  function Qi(e, t = {}, n) {
    for (const o in e) {
      const s = e[o],
        r = n ? `${n}:${o}` : o;
      typeof s == "object" && s !== null ? Qi(s, t, r) : typeof s == "function" && (t[r] = s)
    }
    return t
  }
  const zg = {
      run: e => e()
    },
    Yg = () => zg,
    fd = typeof console.createTask < "u" ? console.createTask : Yg;

  function Kg(e, t) {
    const n = t.shift(),
      o = fd(n);
    return e.reduce((s, r) => s.then(() => o.run(() => r(...t))), Promise.resolve())
  }

  function Wg(e, t) {
    const n = t.shift(),
      o = fd(n);
    return Promise.all(e.map(s => o.run(() => s(...t))))
  }

  function Xi(e, t) {
    for (const n of [...e]) n(t)
  }
  class qg {
    constructor() {
      this._hooks = {}, this._before = void 0, this._after = void 0, this._deprecatedMessages = void 0, this._deprecatedHooks = {}, this.hook = this.hook.bind(this), this.callHook = this.callHook.bind(this), this.callHookWith = this.callHookWith.bind(this)
    }
    hook(t, n, o = {}) {
      if (!t || typeof n != "function") return () => {};
      const s = t;
      let r;
      for (; this._deprecatedHooks[t];) r = this._deprecatedHooks[t], t = r.to;
      if (r && !o.allowDeprecated) {
        let a = r.message;
        a || (a = `${s} hook has been deprecated` + (r.to ? `, please use ${r.to}` : "")), this._deprecatedMessages || (this._deprecatedMessages = new Set), this._deprecatedMessages.has(a) || (console.warn(a), this._deprecatedMessages.add(a))
      }
      if (!n.name) try {
        Object.defineProperty(n, "name", {
          get: () => "_" + t.replace(/\W+/g, "_") + "_hook_cb",
          configurable: !0
        })
      } catch {}
      return this._hooks[t] = this._hooks[t] || [], this._hooks[t].push(n), () => {
        n && (this.removeHook(t, n), n = void 0)
      }
    }
    hookOnce(t, n) {
      let o, s = (...r) => (typeof o == "function" && o(), o = void 0, s = void 0, n(...r));
      return o = this.hook(t, s), o
    }
    removeHook(t, n) {
      if (this._hooks[t]) {
        const o = this._hooks[t].indexOf(n);
        o !== -1 && this._hooks[t].splice(o, 1), this._hooks[t].length === 0 && delete this._hooks[t]
      }
    }
    deprecateHook(t, n) {
      this._deprecatedHooks[t] = typeof n == "string" ? {
        to: n
      } : n;
      const o = this._hooks[t] || [];
      delete this._hooks[t];
      for (const s of o) this.hook(t, s)
    }
    deprecateHooks(t) {
      Object.assign(this._deprecatedHooks, t);
      for (const n in t) this.deprecateHook(n, t[n])
    }
    addHooks(t) {
      const n = Qi(t),
        o = Object.keys(n).map(s => this.hook(s, n[s]));
      return () => {
        for (const s of o.splice(0, o.length)) s()
      }
    }
    removeHooks(t) {
      const n = Qi(t);
      for (const o in n) this.removeHook(o, n[o])
    }
    removeAllHooks() {
      for (const t in this._hooks) delete this._hooks[t]
    }
    callHook(t, ...n) {
      return n.unshift(t), this.callHookWith(Kg, t, ...n)
    }
    callHookParallel(t, ...n) {
      return n.unshift(t), this.callHookWith(Wg, t, ...n)
    }
    callHookWith(t, n, ...o) {
      const s = this._before || this._after ? {
        name: n,
        args: o,
        context: {}
      } : void 0;
      this._before && Xi(this._before, s);
      const r = t(n in this._hooks ? [...this._hooks[n]] : [], o);
      return r instanceof Promise ? r.finally(() => {
        this._after && s && Xi(this._after, s)
      }) : (this._after && s && Xi(this._after, s), r)
    }
    beforeEach(t) {
      return this._before = this._before || [], this._before.push(t), () => {
        if (this._before !== void 0) {
          const n = this._before.indexOf(t);
          n !== -1 && this._before.splice(n, 1)
        }
      }
    }
    afterEach(t) {
      return this._after = this._after || [], this._after.push(t), () => {
        if (this._after !== void 0) {
          const n = this._after.indexOf(t);
          n !== -1 && this._after.splice(n, 1)
        }
      }
    }
  }

  function pd() {
    return new qg
  }
  var Qg = Object.create,
    _d = Object.defineProperty,
    Xg = Object.getOwnPropertyDescriptor,
    Ji = Object.getOwnPropertyNames,
    Jg = Object.getPrototypeOf,
    Zg = Object.prototype.hasOwnProperty,
    ey = (e, t) => function() {
      return e && (t = (0, e[Ji(e)[0]])(e = 0)), t
    },
    hd = (e, t) => function() {
      return t || (0, e[Ji(e)[0]])((t = {
        exports: {}
      }).exports, t), t.exports
    },
    ty = (e, t, n, o) => {
      if (t && typeof t == "object" || typeof t == "function")
        for (let s of Ji(t)) !Zg.call(e, s) && s !== n && _d(e, s, {
          get: () => t[s],
          enumerable: !(o = Xg(t, s)) || o.enumerable
        });
      return e
    },
    ny = (e, t, n) => (n = e != null ? Qg(Jg(e)) : {}, ty(_d(n, "default", {
      value: e,
      enumerable: !0
    }), e)),
    q = ey({
      "../../node_modules/.pnpm/tsup@8.4.0_@microsoft+api-extractor@7.51.1_@types+node@22.13.14__jiti@2.4.2_postcss@8.5_96eb05a9d65343021e53791dd83f3773/node_modules/tsup/assets/esm_shims.js"() {}
    }),
    oy = hd({
      "../../node_modules/.pnpm/speakingurl@14.0.1/node_modules/speakingurl/lib/speakingurl.js"(e, t) {
        q(), (function(n) {
          var o = {
              À: "A",
              Á: "A",
              Â: "A",
              Ã: "A",
              Ä: "Ae",
              Å: "A",
              Æ: "AE",
              Ç: "C",
              È: "E",
              É: "E",
              Ê: "E",
              Ë: "E",
              Ì: "I",
              Í: "I",
              Î: "I",
              Ï: "I",
              Ð: "D",
              Ñ: "N",
              Ò: "O",
              Ó: "O",
              Ô: "O",
              Õ: "O",
              Ö: "Oe",
              Ő: "O",
              Ø: "O",
              Ù: "U",
              Ú: "U",
              Û: "U",
              Ü: "Ue",
              Ű: "U",
              Ý: "Y",
              Þ: "TH",
              ß: "ss",
              à: "a",
              á: "a",
              â: "a",
              ã: "a",
              ä: "ae",
              å: "a",
              æ: "ae",
              ç: "c",
              è: "e",
              é: "e",
              ê: "e",
              ë: "e",
              ì: "i",
              í: "i",
              î: "i",
              ï: "i",
              ð: "d",
              ñ: "n",
              ò: "o",
              ó: "o",
              ô: "o",
              õ: "o",
              ö: "oe",
              ő: "o",
              ø: "o",
              ù: "u",
              ú: "u",
              û: "u",
              ü: "ue",
              ű: "u",
              ý: "y",
              þ: "th",
              ÿ: "y",
              "ẞ": "SS",
              ا: "a",
              أ: "a",
              إ: "i",
              آ: "aa",
              ؤ: "u",
              ئ: "e",
              ء: "a",
              ب: "b",
              ت: "t",
              ث: "th",
              ج: "j",
              ح: "h",
              خ: "kh",
              د: "d",
              ذ: "th",
              ر: "r",
              ز: "z",
              س: "s",
              ش: "sh",
              ص: "s",
              ض: "dh",
              ط: "t",
              ظ: "z",
              ع: "a",
              غ: "gh",
              ف: "f",
              ق: "q",
              ك: "k",
              ل: "l",
              م: "m",
              ن: "n",
              ه: "h",
              و: "w",
              ي: "y",
              ى: "a",
              ة: "h",
              ﻻ: "la",
              ﻷ: "laa",
              ﻹ: "lai",
              ﻵ: "laa",
              گ: "g",
              چ: "ch",
              پ: "p",
              ژ: "zh",
              ک: "k",
              ی: "y",
              "َ": "a",
              "ً": "an",
              "ِ": "e",
              "ٍ": "en",
              "ُ": "u",
              "ٌ": "on",
              "ْ": "",
              "٠": "0",
              "١": "1",
              "٢": "2",
              "٣": "3",
              "٤": "4",
              "٥": "5",
              "٦": "6",
              "٧": "7",
              "٨": "8",
              "٩": "9",
              "۰": "0",
              "۱": "1",
              "۲": "2",
              "۳": "3",
              "۴": "4",
              "۵": "5",
              "۶": "6",
              "۷": "7",
              "۸": "8",
              "۹": "9",
              က: "k",
              ခ: "kh",
              ဂ: "g",
              ဃ: "ga",
              င: "ng",
              စ: "s",
              ဆ: "sa",
              ဇ: "z",
              "စျ": "za",
              ည: "ny",
              ဋ: "t",
              ဌ: "ta",
              ဍ: "d",
              ဎ: "da",
              ဏ: "na",
              တ: "t",
              ထ: "ta",
              ဒ: "d",
              ဓ: "da",
              န: "n",
              ပ: "p",
              ဖ: "pa",
              ဗ: "b",
              ဘ: "ba",
              မ: "m",
              ယ: "y",
              ရ: "ya",
              လ: "l",
              ဝ: "w",
              သ: "th",
              ဟ: "h",
              ဠ: "la",
              အ: "a",
              "ြ": "y",
              "ျ": "ya",
              "ွ": "w",
              "ြွ": "yw",
              "ျွ": "ywa",
              "ှ": "h",
              ဧ: "e",
              "၏": "-e",
              ဣ: "i",
              ဤ: "-i",
              ဉ: "u",
              ဦ: "-u",
              ဩ: "aw",
              "သြော": "aw",
              ဪ: "aw",
              "၀": "0",
              "၁": "1",
              "၂": "2",
              "၃": "3",
              "၄": "4",
              "၅": "5",
              "၆": "6",
              "၇": "7",
              "၈": "8",
              "၉": "9",
              "္": "",
              "့": "",
              "း": "",
              č: "c",
              ď: "d",
              ě: "e",
              ň: "n",
              ř: "r",
              š: "s",
              ť: "t",
              ů: "u",
              ž: "z",
              Č: "C",
              Ď: "D",
              Ě: "E",
              Ň: "N",
              Ř: "R",
              Š: "S",
              Ť: "T",
              Ů: "U",
              Ž: "Z",
              ހ: "h",
              ށ: "sh",
              ނ: "n",
              ރ: "r",
              ބ: "b",
              ޅ: "lh",
              ކ: "k",
              އ: "a",
              ވ: "v",
              މ: "m",
              ފ: "f",
              ދ: "dh",
              ތ: "th",
              ލ: "l",
              ގ: "g",
              ޏ: "gn",
              ސ: "s",
              ޑ: "d",
              ޒ: "z",
              ޓ: "t",
              ޔ: "y",
              ޕ: "p",
              ޖ: "j",
              ޗ: "ch",
              ޘ: "tt",
              ޙ: "hh",
              ޚ: "kh",
              ޛ: "th",
              ޜ: "z",
              ޝ: "sh",
              ޞ: "s",
              ޟ: "d",
              ޠ: "t",
              ޡ: "z",
              ޢ: "a",
              ޣ: "gh",
              ޤ: "q",
              ޥ: "w",
              "ަ": "a",
              "ާ": "aa",
              "ި": "i",
              "ީ": "ee",
              "ު": "u",
              "ޫ": "oo",
              "ެ": "e",
              "ޭ": "ey",
              "ޮ": "o",
              "ޯ": "oa",
              "ް": "",
              ა: "a",
              ბ: "b",
              გ: "g",
              დ: "d",
              ე: "e",
              ვ: "v",
              ზ: "z",
              თ: "t",
              ი: "i",
              კ: "k",
              ლ: "l",
              მ: "m",
              ნ: "n",
              ო: "o",
              პ: "p",
              ჟ: "zh",
              რ: "r",
              ს: "s",
              ტ: "t",
              უ: "u",
              ფ: "p",
              ქ: "k",
              ღ: "gh",
              ყ: "q",
              შ: "sh",
              ჩ: "ch",
              ც: "ts",
              ძ: "dz",
              წ: "ts",
              ჭ: "ch",
              ხ: "kh",
              ჯ: "j",
              ჰ: "h",
              α: "a",
              β: "v",
              γ: "g",
              δ: "d",
              ε: "e",
              ζ: "z",
              η: "i",
              θ: "th",
              ι: "i",
              κ: "k",
              λ: "l",
              μ: "m",
              ν: "n",
              ξ: "ks",
              ο: "o",
              π: "p",
              ρ: "r",
              σ: "s",
              τ: "t",
              υ: "y",
              φ: "f",
              χ: "x",
              ψ: "ps",
              ω: "o",
              ά: "a",
              έ: "e",
              ί: "i",
              ό: "o",
              ύ: "y",
              ή: "i",
              ώ: "o",
              ς: "s",
              ϊ: "i",
              ΰ: "y",
              ϋ: "y",
              ΐ: "i",
              Α: "A",
              Β: "B",
              Γ: "G",
              Δ: "D",
              Ε: "E",
              Ζ: "Z",
              Η: "I",
              Θ: "TH",
              Ι: "I",
              Κ: "K",
              Λ: "L",
              Μ: "M",
              Ν: "N",
              Ξ: "KS",
              Ο: "O",
              Π: "P",
              Ρ: "R",
              Σ: "S",
              Τ: "T",
              Υ: "Y",
              Φ: "F",
              Χ: "X",
              Ψ: "PS",
              Ω: "O",
              Ά: "A",
              Έ: "E",
              Ί: "I",
              Ό: "O",
              Ύ: "Y",
              Ή: "I",
              Ώ: "O",
              Ϊ: "I",
              Ϋ: "Y",
              ā: "a",
              ē: "e",
              ģ: "g",
              ī: "i",
              ķ: "k",
              ļ: "l",
              ņ: "n",
              ū: "u",
              Ā: "A",
              Ē: "E",
              Ģ: "G",
              Ī: "I",
              Ķ: "k",
              Ļ: "L",
              Ņ: "N",
              Ū: "U",
              Ќ: "Kj",
              ќ: "kj",
              Љ: "Lj",
              љ: "lj",
              Њ: "Nj",
              њ: "nj",
              Тс: "Ts",
              тс: "ts",
              ą: "a",
              ć: "c",
              ę: "e",
              ł: "l",
              ń: "n",
              ś: "s",
              ź: "z",
              ż: "z",
              Ą: "A",
              Ć: "C",
              Ę: "E",
              Ł: "L",
              Ń: "N",
              Ś: "S",
              Ź: "Z",
              Ż: "Z",
              Є: "Ye",
              І: "I",
              Ї: "Yi",
              Ґ: "G",
              є: "ye",
              і: "i",
              ї: "yi",
              ґ: "g",
              ă: "a",
              Ă: "A",
              ș: "s",
              Ș: "S",
              ț: "t",
              Ț: "T",
              ţ: "t",
              Ţ: "T",
              а: "a",
              б: "b",
              в: "v",
              г: "g",
              д: "d",
              е: "e",
              ё: "yo",
              ж: "zh",
              з: "z",
              и: "i",
              й: "i",
              к: "k",
              л: "l",
              м: "m",
              н: "n",
              о: "o",
              п: "p",
              р: "r",
              с: "s",
              т: "t",
              у: "u",
              ф: "f",
              х: "kh",
              ц: "c",
              ч: "ch",
              ш: "sh",
              щ: "sh",
              ъ: "",
              ы: "y",
              ь: "",
              э: "e",
              ю: "yu",
              я: "ya",
              А: "A",
              Б: "B",
              В: "V",
              Г: "G",
              Д: "D",
              Е: "E",
              Ё: "Yo",
              Ж: "Zh",
              З: "Z",
              И: "I",
              Й: "I",
              К: "K",
              Л: "L",
              М: "M",
              Н: "N",
              О: "O",
              П: "P",
              Р: "R",
              С: "S",
              Т: "T",
              У: "U",
              Ф: "F",
              Х: "Kh",
              Ц: "C",
              Ч: "Ch",
              Ш: "Sh",
              Щ: "Sh",
              Ъ: "",
              Ы: "Y",
              Ь: "",
              Э: "E",
              Ю: "Yu",
              Я: "Ya",
              ђ: "dj",
              ј: "j",
              ћ: "c",
              џ: "dz",
              Ђ: "Dj",
              Ј: "j",
              Ћ: "C",
              Џ: "Dz",
              ľ: "l",
              ĺ: "l",
              ŕ: "r",
              Ľ: "L",
              Ĺ: "L",
              Ŕ: "R",
              ş: "s",
              Ş: "S",
              ı: "i",
              İ: "I",
              ğ: "g",
              Ğ: "G",
              ả: "a",
              Ả: "A",
              ẳ: "a",
              Ẳ: "A",
              ẩ: "a",
              Ẩ: "A",
              đ: "d",
              Đ: "D",
              ẹ: "e",
              Ẹ: "E",
              ẽ: "e",
              Ẽ: "E",
              ẻ: "e",
              Ẻ: "E",
              ế: "e",
              Ế: "E",
              ề: "e",
              Ề: "E",
              ệ: "e",
              Ệ: "E",
              ễ: "e",
              Ễ: "E",
              ể: "e",
              Ể: "E",
              ỏ: "o",
              ọ: "o",
              Ọ: "o",
              ố: "o",
              Ố: "O",
              ồ: "o",
              Ồ: "O",
              ổ: "o",
              Ổ: "O",
              ộ: "o",
              Ộ: "O",
              ỗ: "o",
              Ỗ: "O",
              ơ: "o",
              Ơ: "O",
              ớ: "o",
              Ớ: "O",
              ờ: "o",
              Ờ: "O",
              ợ: "o",
              Ợ: "O",
              ỡ: "o",
              Ỡ: "O",
              Ở: "o",
              ở: "o",
              ị: "i",
              Ị: "I",
              ĩ: "i",
              Ĩ: "I",
              ỉ: "i",
              Ỉ: "i",
              ủ: "u",
              Ủ: "U",
              ụ: "u",
              Ụ: "U",
              ũ: "u",
              Ũ: "U",
              ư: "u",
              Ư: "U",
              ứ: "u",
              Ứ: "U",
              ừ: "u",
              Ừ: "U",
              ự: "u",
              Ự: "U",
              ữ: "u",
              Ữ: "U",
              ử: "u",
              Ử: "ư",
              ỷ: "y",
              Ỷ: "y",
              ỳ: "y",
              Ỳ: "Y",
              ỵ: "y",
              Ỵ: "Y",
              ỹ: "y",
              Ỹ: "Y",
              ạ: "a",
              Ạ: "A",
              ấ: "a",
              Ấ: "A",
              ầ: "a",
              Ầ: "A",
              ậ: "a",
              Ậ: "A",
              ẫ: "a",
              Ẫ: "A",
              ắ: "a",
              Ắ: "A",
              ằ: "a",
              Ằ: "A",
              ặ: "a",
              Ặ: "A",
              ẵ: "a",
              Ẵ: "A",
              "⓪": "0",
              "①": "1",
              "②": "2",
              "③": "3",
              "④": "4",
              "⑤": "5",
              "⑥": "6",
              "⑦": "7",
              "⑧": "8",
              "⑨": "9",
              "⑩": "10",
              "⑪": "11",
              "⑫": "12",
              "⑬": "13",
              "⑭": "14",
              "⑮": "15",
              "⑯": "16",
              "⑰": "17",
              "⑱": "18",
              "⑲": "18",
              "⑳": "18",
              "⓵": "1",
              "⓶": "2",
              "⓷": "3",
              "⓸": "4",
              "⓹": "5",
              "⓺": "6",
              "⓻": "7",
              "⓼": "8",
              "⓽": "9",
              "⓾": "10",
              "⓿": "0",
              "⓫": "11",
              "⓬": "12",
              "⓭": "13",
              "⓮": "14",
              "⓯": "15",
              "⓰": "16",
              "⓱": "17",
              "⓲": "18",
              "⓳": "19",
              "⓴": "20",
              "Ⓐ": "A",
              "Ⓑ": "B",
              "Ⓒ": "C",
              "Ⓓ": "D",
              "Ⓔ": "E",
              "Ⓕ": "F",
              "Ⓖ": "G",
              "Ⓗ": "H",
              "Ⓘ": "I",
              "Ⓙ": "J",
              "Ⓚ": "K",
              "Ⓛ": "L",
              "Ⓜ": "M",
              "Ⓝ": "N",
              "Ⓞ": "O",
              "Ⓟ": "P",
              "Ⓠ": "Q",
              "Ⓡ": "R",
              "Ⓢ": "S",
              "Ⓣ": "T",
              "Ⓤ": "U",
              "Ⓥ": "V",
              "Ⓦ": "W",
              "Ⓧ": "X",
              "Ⓨ": "Y",
              "Ⓩ": "Z",
              "ⓐ": "a",
              "ⓑ": "b",
              "ⓒ": "c",
              "ⓓ": "d",
              "ⓔ": "e",
              "ⓕ": "f",
              "ⓖ": "g",
              "ⓗ": "h",
              "ⓘ": "i",
              "ⓙ": "j",
              "ⓚ": "k",
              "ⓛ": "l",
              "ⓜ": "m",
              "ⓝ": "n",
              "ⓞ": "o",
              "ⓟ": "p",
              "ⓠ": "q",
              "ⓡ": "r",
              "ⓢ": "s",
              "ⓣ": "t",
              "ⓤ": "u",
              "ⓦ": "v",
              "ⓥ": "w",
              "ⓧ": "x",
              "ⓨ": "y",
              "ⓩ": "z",
              "“": '"',
              "”": '"',
              "‘": "'",
              "’": "'",
              "∂": "d",
              ƒ: "f",
              "™": "(TM)",
              "©": "(C)",
              œ: "oe",
              Œ: "OE",
              "®": "(R)",
              "†": "+",
              "℠": "(SM)",
              "…": "...",
              "˚": "o",
              º: "o",
              ª: "a",
              "•": "*",
              "၊": ",",
              "။": ".",
              $: "USD",
              "€": "EUR",
              "₢": "BRN",
              "₣": "FRF",
              "£": "GBP",
              "₤": "ITL",
              "₦": "NGN",
              "₧": "ESP",
              "₩": "KRW",
              "₪": "ILS",
              "₫": "VND",
              "₭": "LAK",
              "₮": "MNT",
              "₯": "GRD",
              "₱": "ARS",
              "₲": "PYG",
              "₳": "ARA",
              "₴": "UAH",
              "₵": "GHS",
              "¢": "cent",
              "¥": "CNY",
              元: "CNY",
              円: "YEN",
              "﷼": "IRR",
              "₠": "EWE",
              "฿": "THB",
              "₨": "INR",
              "₹": "INR",
              "₰": "PF",
              "₺": "TRY",
              "؋": "AFN",
              "₼": "AZN",
              лв: "BGN",
              "៛": "KHR",
              "₡": "CRC",
              "₸": "KZT",
              ден: "MKD",
              zł: "PLN",
              "₽": "RUB",
              "₾": "GEL"
            },
            s = ["်", "ް"],
            r = {
              "ာ": "a",
              "ါ": "a",
              "ေ": "e",
              "ဲ": "e",
              "ိ": "i",
              "ီ": "i",
              "ို": "o",
              "ု": "u",
              "ူ": "u",
              "ေါင်": "aung",
              "ော": "aw",
              "ော်": "aw",
              "ေါ": "aw",
              "ေါ်": "aw",
              "်": "်",
              "က်": "et",
              "ိုက်": "aik",
              "ောက်": "auk",
              "င်": "in",
              "ိုင်": "aing",
              "ောင်": "aung",
              "စ်": "it",
              "ည်": "i",
              "တ်": "at",
              "ိတ်": "eik",
              "ုတ်": "ok",
              "ွတ်": "ut",
              "ေတ်": "it",
              "ဒ်": "d",
              "ိုဒ်": "ok",
              "ုဒ်": "ait",
              "န်": "an",
              "ာန်": "an",
              "ိန်": "ein",
              "ုန်": "on",
              "ွန်": "un",
              "ပ်": "at",
              "ိပ်": "eik",
              "ုပ်": "ok",
              "ွပ်": "ut",
              "န်ုပ်": "nub",
              "မ်": "an",
              "ိမ်": "ein",
              "ုမ်": "on",
              "ွမ်": "un",
              "ယ်": "e",
              "ိုလ်": "ol",
              "ဉ်": "in",
              "ံ": "an",
              "ိံ": "ein",
              "ုံ": "on",
              "ައް": "ah",
              "ަށް": "ah"
            },
            a = {
              en: {},
              az: {
                ç: "c",
                ə: "e",
                ğ: "g",
                ı: "i",
                ö: "o",
                ş: "s",
                ü: "u",
                Ç: "C",
                Ə: "E",
                Ğ: "G",
                İ: "I",
                Ö: "O",
                Ş: "S",
                Ü: "U"
              },
              cs: {
                č: "c",
                ď: "d",
                ě: "e",
                ň: "n",
                ř: "r",
                š: "s",
                ť: "t",
                ů: "u",
                ž: "z",
                Č: "C",
                Ď: "D",
                Ě: "E",
                Ň: "N",
                Ř: "R",
                Š: "S",
                Ť: "T",
                Ů: "U",
                Ž: "Z"
              },
              fi: {
                ä: "a",
                Ä: "A",
                ö: "o",
                Ö: "O"
              },
              hu: {
                ä: "a",
                Ä: "A",
                ö: "o",
                Ö: "O",
                ü: "u",
                Ü: "U",
                ű: "u",
                Ű: "U"
              },
              lt: {
                ą: "a",
                č: "c",
                ę: "e",
                ė: "e",
                į: "i",
                š: "s",
                ų: "u",
                ū: "u",
                ž: "z",
                Ą: "A",
                Č: "C",
                Ę: "E",
                Ė: "E",
                Į: "I",
                Š: "S",
                Ų: "U",
                Ū: "U"
              },
              lv: {
                ā: "a",
                č: "c",
                ē: "e",
                ģ: "g",
                ī: "i",
                ķ: "k",
                ļ: "l",
                ņ: "n",
                š: "s",
                ū: "u",
                ž: "z",
                Ā: "A",
                Č: "C",
                Ē: "E",
                Ģ: "G",
                Ī: "i",
                Ķ: "k",
                Ļ: "L",
                Ņ: "N",
                Š: "S",
                Ū: "u",
                Ž: "Z"
              },
              pl: {
                ą: "a",
                ć: "c",
                ę: "e",
                ł: "l",
                ń: "n",
                ó: "o",
                ś: "s",
                ź: "z",
                ż: "z",
                Ą: "A",
                Ć: "C",
                Ę: "e",
                Ł: "L",
                Ń: "N",
                Ó: "O",
                Ś: "S",
                Ź: "Z",
                Ż: "Z"
              },
              sv: {
                ä: "a",
                Ä: "A",
                ö: "o",
                Ö: "O"
              },
              sk: {
                ä: "a",
                Ä: "A"
              },
              sr: {
                љ: "lj",
                њ: "nj",
                Љ: "Lj",
                Њ: "Nj",
                đ: "dj",
                Đ: "Dj"
              },
              tr: {
                Ü: "U",
                Ö: "O",
                ü: "u",
                ö: "o"
              }
            },
            i = {
              ar: {
                "∆": "delta",
                "∞": "la-nihaya",
                "♥": "hob",
                "&": "wa",
                "|": "aw",
                "<": "aqal-men",
                ">": "akbar-men",
                "∑": "majmou",
                "¤": "omla"
              },
              az: {},
              ca: {
                "∆": "delta",
                "∞": "infinit",
                "♥": "amor",
                "&": "i",
                "|": "o",
                "<": "menys que",
                ">": "mes que",
                "∑": "suma dels",
                "¤": "moneda"
              },
              cs: {
                "∆": "delta",
                "∞": "nekonecno",
                "♥": "laska",
                "&": "a",
                "|": "nebo",
                "<": "mensi nez",
                ">": "vetsi nez",
                "∑": "soucet",
                "¤": "mena"
              },
              de: {
                "∆": "delta",
                "∞": "unendlich",
                "♥": "Liebe",
                "&": "und",
                "|": "oder",
                "<": "kleiner als",
                ">": "groesser als",
                "∑": "Summe von",
                "¤": "Waehrung"
              },
              dv: {
                "∆": "delta",
                "∞": "kolunulaa",
                "♥": "loabi",
                "&": "aai",
                "|": "noonee",
                "<": "ah vure kuda",
                ">": "ah vure bodu",
                "∑": "jumula",
                "¤": "faisaa"
              },
              en: {
                "∆": "delta",
                "∞": "infinity",
                "♥": "love",
                "&": "and",
                "|": "or",
                "<": "less than",
                ">": "greater than",
                "∑": "sum",
                "¤": "currency"
              },
              es: {
                "∆": "delta",
                "∞": "infinito",
                "♥": "amor",
                "&": "y",
                "|": "u",
                "<": "menos que",
                ">": "mas que",
                "∑": "suma de los",
                "¤": "moneda"
              },
              fa: {
                "∆": "delta",
                "∞": "bi-nahayat",
                "♥": "eshgh",
                "&": "va",
                "|": "ya",
                "<": "kamtar-az",
                ">": "bishtar-az",
                "∑": "majmooe",
                "¤": "vahed"
              },
              fi: {
                "∆": "delta",
                "∞": "aarettomyys",
                "♥": "rakkaus",
                "&": "ja",
                "|": "tai",
                "<": "pienempi kuin",
                ">": "suurempi kuin",
                "∑": "summa",
                "¤": "valuutta"
              },
              fr: {
                "∆": "delta",
                "∞": "infiniment",
                "♥": "Amour",
                "&": "et",
                "|": "ou",
                "<": "moins que",
                ">": "superieure a",
                "∑": "somme des",
                "¤": "monnaie"
              },
              ge: {
                "∆": "delta",
                "∞": "usasruloba",
                "♥": "siqvaruli",
                "&": "da",
                "|": "an",
                "<": "naklebi",
                ">": "meti",
                "∑": "jami",
                "¤": "valuta"
              },
              gr: {},
              hu: {
                "∆": "delta",
                "∞": "vegtelen",
                "♥": "szerelem",
                "&": "es",
                "|": "vagy",
                "<": "kisebb mint",
                ">": "nagyobb mint",
                "∑": "szumma",
                "¤": "penznem"
              },
              it: {
                "∆": "delta",
                "∞": "infinito",
                "♥": "amore",
                "&": "e",
                "|": "o",
                "<": "minore di",
                ">": "maggiore di",
                "∑": "somma",
                "¤": "moneta"
              },
              lt: {
                "∆": "delta",
                "∞": "begalybe",
                "♥": "meile",
                "&": "ir",
                "|": "ar",
                "<": "maziau nei",
                ">": "daugiau nei",
                "∑": "suma",
                "¤": "valiuta"
              },
              lv: {
                "∆": "delta",
                "∞": "bezgaliba",
                "♥": "milestiba",
                "&": "un",
                "|": "vai",
                "<": "mazak neka",
                ">": "lielaks neka",
                "∑": "summa",
                "¤": "valuta"
              },
              my: {
                "∆": "kwahkhyaet",
                "∞": "asaonasme",
                "♥": "akhyait",
                "&": "nhin",
                "|": "tho",
                "<": "ngethaw",
                ">": "kyithaw",
                "∑": "paungld",
                "¤": "ngwekye"
              },
              mk: {},
              nl: {
                "∆": "delta",
                "∞": "oneindig",
                "♥": "liefde",
                "&": "en",
                "|": "of",
                "<": "kleiner dan",
                ">": "groter dan",
                "∑": "som",
                "¤": "valuta"
              },
              pl: {
                "∆": "delta",
                "∞": "nieskonczonosc",
                "♥": "milosc",
                "&": "i",
                "|": "lub",
                "<": "mniejsze niz",
                ">": "wieksze niz",
                "∑": "suma",
                "¤": "waluta"
              },
              pt: {
                "∆": "delta",
                "∞": "infinito",
                "♥": "amor",
                "&": "e",
                "|": "ou",
                "<": "menor que",
                ">": "maior que",
                "∑": "soma",
                "¤": "moeda"
              },
              ro: {
                "∆": "delta",
                "∞": "infinit",
                "♥": "dragoste",
                "&": "si",
                "|": "sau",
                "<": "mai mic ca",
                ">": "mai mare ca",
                "∑": "suma",
                "¤": "valuta"
              },
              ru: {
                "∆": "delta",
                "∞": "beskonechno",
                "♥": "lubov",
                "&": "i",
                "|": "ili",
                "<": "menshe",
                ">": "bolshe",
                "∑": "summa",
                "¤": "valjuta"
              },
              sk: {
                "∆": "delta",
                "∞": "nekonecno",
                "♥": "laska",
                "&": "a",
                "|": "alebo",
                "<": "menej ako",
                ">": "viac ako",
                "∑": "sucet",
                "¤": "mena"
              },
              sr: {},
              tr: {
                "∆": "delta",
                "∞": "sonsuzluk",
                "♥": "ask",
                "&": "ve",
                "|": "veya",
                "<": "kucuktur",
                ">": "buyuktur",
                "∑": "toplam",
                "¤": "para birimi"
              },
              uk: {
                "∆": "delta",
                "∞": "bezkinechnist",
                "♥": "lubov",
                "&": "i",
                "|": "abo",
                "<": "menshe",
                ">": "bilshe",
                "∑": "suma",
                "¤": "valjuta"
              },
              vn: {
                "∆": "delta",
                "∞": "vo cuc",
                "♥": "yeu",
                "&": "va",
                "|": "hoac",
                "<": "nho hon",
                ">": "lon hon",
                "∑": "tong",
                "¤": "tien te"
              }
            },
            l = [";", "?", ":", "@", "&", "=", "+", "$", ",", "/"].join(""),
            c = [";", "?", ":", "@", "&", "=", "+", "$", ","].join(""),
            u = [".", "!", "~", "*", "'", "(", ")"].join(""),
            d = function(m, v) {
              var E = "-",
                k = "",
                N = "",
                D = !0,
                O = {},
                A, b, C, y, I, w, U, Z, me, _e, B, W, ue, lt, Oe = "";
              if (typeof m != "string") return "";
              if (typeof v == "string" && (E = v), U = i.en, Z = a.en, typeof v == "object") {
                A = v.maintainCase || !1, O = v.custom && typeof v.custom == "object" ? v.custom : O, C = +v.truncate > 1 && v.truncate || !1, y = v.uric || !1, I = v.uricNoSlash || !1, w = v.mark || !1, D = !(v.symbols === !1 || v.lang === !1), E = v.separator || E, y && (Oe += l), I && (Oe += c), w && (Oe += u), U = v.lang && i[v.lang] && D ? i[v.lang] : D ? i.en : {}, Z = v.lang && a[v.lang] ? a[v.lang] : v.lang === !1 || v.lang === !0 ? {} : a.en, v.titleCase && typeof v.titleCase.length == "number" && Array.prototype.toString.call(v.titleCase) ? (v.titleCase.forEach(function(Ke) {
                  O[Ke + ""] = Ke + ""
                }), b = !0) : b = !!v.titleCase, v.custom && typeof v.custom.length == "number" && Array.prototype.toString.call(v.custom) && v.custom.forEach(function(Ke) {
                  O[Ke + ""] = Ke + ""
                }), Object.keys(O).forEach(function(Ke) {
                  var Ie;
                  Ke.length > 1 ? Ie = new RegExp("\\b" + f(Ke) + "\\b", "gi") : Ie = new RegExp(f(Ke), "gi"), m = m.replace(Ie, O[Ke])
                });
                for (B in O) Oe += B
              }
              for (Oe += E, Oe = f(Oe), m = m.replace(/(^\s+|\s+$)/g, ""), ue = !1, lt = !1, _e = 0, W = m.length; _e < W; _e++) B = m[_e], _(B, O) ? ue = !1 : Z[B] ? (B = ue && Z[B].match(/[A-Za-z0-9]/) ? " " + Z[B] : Z[B], ue = !1) : B in o ? (_e + 1 < W && s.indexOf(m[_e + 1]) >= 0 ? (N += B, B = "") : lt === !0 ? (B = r[N] + o[B], N = "") : B = ue && o[B].match(/[A-Za-z0-9]/) ? " " + o[B] : o[B], ue = !1, lt = !1) : B in r ? (N += B, B = "", _e === W - 1 && (B = r[N]), lt = !0) : U[B] && !(y && l.indexOf(B) !== -1) && !(I && c.indexOf(B) !== -1) ? (B = ue || k.substr(-1).match(/[A-Za-z0-9]/) ? E + U[B] : U[B], B += m[_e + 1] !== void 0 && m[_e + 1].match(/[A-Za-z0-9]/) ? E : "", ue = !0) : (lt === !0 ? (B = r[N] + B, N = "", lt = !1) : ue && (/[A-Za-z0-9]/.test(B) || k.substr(-1).match(/A-Za-z0-9]/)) && (B = " " + B), ue = !1), k += B.replace(new RegExp("[^\\w\\s" + Oe + "_-]", "g"), E);
              return b && (k = k.replace(/(\w)(\S*)/g, function(Ke, Ie, Pn) {
                var He = Ie.toUpperCase() + (Pn !== null ? Pn : "");
                return Object.keys(O).indexOf(He.toLowerCase()) < 0 ? He : He.toLowerCase()
              })), k = k.replace(/\s+/g, E).replace(new RegExp("\\" + E + "+", "g"), E).replace(new RegExp("(^\\" + E + "+|\\" + E + "+$)", "g"), ""), C && k.length > C && (me = k.charAt(C) === E, k = k.slice(0, C), me || (k = k.slice(0, k.lastIndexOf(E)))), !A && !b && (k = k.toLowerCase()), k
            },
            h = function(m) {
              return function(E) {
                return d(E, m)
              }
            },
            f = function(m) {
              return m.replace(/[-\\^$*+?.()|[\]{}\/]/g, "\\$&")
            },
            _ = function(p, m) {
              for (var v in m)
                if (m[v] === p) return !0
            };
          if (typeof t < "u" && t.exports) t.exports = d, t.exports.createSlug = h;
          else if (typeof define < "u" && define.amd) define([], function() {
            return d
          });
          else try {
            if (n.getSlug || n.createSlug) throw "speakingurl: globals exists /(getSlug|createSlug)/";
            n.getSlug = d, n.createSlug = h
          } catch {}
        })(e)
      }
    }),
    sy = hd({
      "../../node_modules/.pnpm/speakingurl@14.0.1/node_modules/speakingurl/index.js"(e, t) {
        q(), t.exports = oy()
      }
    });
  q(), q(), q(), q(), q(), q(), q(), q();

  function ry(e) {
    var t;
    const n = e.name || e._componentTag || e.__VUE_DEVTOOLS_COMPONENT_GUSSED_NAME__ || e.__name;
    return n === "index" && ((t = e.__file) != null && t.endsWith("index.vue")) ? "" : n
  }

  function iy(e) {
    const t = e.__file;
    if (t) return Vg(Hg(t, ".vue"))
  }

  function md(e, t) {
    return e.type.__VUE_DEVTOOLS_COMPONENT_GUSSED_NAME__ = t, t
  }

  function Zi(e) {
    if (e.__VUE_DEVTOOLS_NEXT_APP_RECORD__) return e.__VUE_DEVTOOLS_NEXT_APP_RECORD__;
    if (e.root) return e.appContext.app.__VUE_DEVTOOLS_NEXT_APP_RECORD__
  }

  function vd(e) {
    var t, n;
    const o = (t = e.subTree) == null ? void 0 : t.type,
      s = Zi(e);
    return s ? ((n = s?.types) == null ? void 0 : n.Fragment) === o : !1
  }

  function Sr(e) {
    var t, n, o;
    const s = ry(e?.type || {});
    if (s) return s;
    if (e?.root === e) return "Root";
    for (const a in (n = (t = e.parent) == null ? void 0 : t.type) == null ? void 0 : n.components)
      if (e.parent.type.components[a] === e?.type) return md(e, a);
    for (const a in (o = e.appContext) == null ? void 0 : o.components)
      if (e.appContext.components[a] === e?.type) return md(e, a);
    const r = iy(e?.type || {});
    return r || "Anonymous Component"
  }

  function ay(e) {
    var t, n, o;
    const s = (o = (n = (t = e?.appContext) == null ? void 0 : t.app) == null ? void 0 : n.__VUE_DEVTOOLS_NEXT_APP_RECORD_ID__) != null ? o : 0,
      r = e === e?.root ? "root" : e.uid;
    return `${s}:${r}`
  }

  function ea(e, t) {
    return t = t || `${e.id}:root`, e.instanceMap.get(t) || e.instanceMap.get(":root")
  }

  function ly() {
    const e = {
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      get width() {
        return e.right - e.left
      },
      get height() {
        return e.bottom - e.top
      }
    };
    return e
  }
  var Dr;

  function uy(e) {
    return Dr || (Dr = document.createRange()), Dr.selectNode(e), Dr.getBoundingClientRect()
  }

  function cy(e) {
    const t = ly();
    if (!e.children) return t;
    for (let n = 0, o = e.children.length; n < o; n++) {
      const s = e.children[n];
      let r;
      if (s.component) r = eo(s.component);
      else if (s.el) {
        const a = s.el;
        a.nodeType === 1 || a.getBoundingClientRect ? r = a.getBoundingClientRect() : a.nodeType === 3 && a.data.trim() && (r = uy(a))
      }
      r && dy(t, r)
    }
    return t
  }

  function dy(e, t) {
    return (!e.top || t.top < e.top) && (e.top = t.top), (!e.bottom || t.bottom > e.bottom) && (e.bottom = t.bottom), (!e.left || t.left < e.left) && (e.left = t.left), (!e.right || t.right > e.right) && (e.right = t.right), e
  }
  var gd = {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: 0,
    height: 0
  };

  function eo(e) {
    const t = e.subTree.el;
    return typeof window > "u" ? gd : vd(e) ? cy(e.subTree) : t?.nodeType === 1 ? t?.getBoundingClientRect() : e.subTree.component ? eo(e.subTree.component) : gd
  }
  q();

  function ta(e) {
    return vd(e) ? fy(e.subTree) : e.subTree ? [e.subTree.el] : []
  }

  function fy(e) {
    if (!e.children) return [];
    const t = [];
    return e.children.forEach(n => {
      n.component ? t.push(...ta(n.component)) : n?.el && t.push(n.el)
    }), t
  }
  var yd = "__vue-devtools-component-inspector__",
    Cd = "__vue-devtools-component-inspector__card__",
    Td = "__vue-devtools-component-inspector__name__",
    bd = "__vue-devtools-component-inspector__indicator__",
    Sd = {
      display: "block",
      zIndex: 2147483640,
      position: "fixed",
      backgroundColor: "#42b88325",
      border: "1px solid #42b88350",
      borderRadius: "5px",
      transition: "all 0.1s ease-in",
      pointerEvents: "none"
    },
    py = {
      fontFamily: "Arial, Helvetica, sans-serif",
      padding: "5px 8px",
      borderRadius: "4px",
      textAlign: "left",
      position: "absolute",
      left: 0,
      color: "#e9e9e9",
      fontSize: "14px",
      fontWeight: 600,
      lineHeight: "24px",
      backgroundColor: "#42b883",
      boxShadow: "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)"
    },
    _y = {
      display: "inline-block",
      fontWeight: 400,
      fontStyle: "normal",
      fontSize: "12px",
      opacity: .7
    };

  function Ro() {
    return document.getElementById(yd)
  }

  function hy() {
    return document.getElementById(Cd)
  }

  function my() {
    return document.getElementById(bd)
  }

  function vy() {
    return document.getElementById(Td)
  }

  function na(e) {
    return {
      left: `${Math.round(e.left*100)/100}px`,
      top: `${Math.round(e.top*100)/100}px`,
      width: `${Math.round(e.width*100)/100}px`,
      height: `${Math.round(e.height*100)/100}px`
    }
  }

  function oa(e) {
    var t;
    const n = document.createElement("div");
    n.id = (t = e.elementId) != null ? t : yd, Object.assign(n.style, {
      ...Sd,
      ...na(e.bounds),
      ...e.style
    });
    const o = document.createElement("span");
    o.id = Cd, Object.assign(o.style, {
      ...py,
      top: e.bounds.top < 35 ? 0 : "-35px"
    });
    const s = document.createElement("span");
    s.id = Td, s.innerHTML = `&lt;${e.name}&gt;&nbsp;&nbsp;`;
    const r = document.createElement("i");
    return r.id = bd, r.innerHTML = `${Math.round(e.bounds.width*100)/100} x ${Math.round(e.bounds.height*100)/100}`, Object.assign(r.style, _y), o.appendChild(s), o.appendChild(r), n.appendChild(o), document.body.appendChild(n), n
  }

  function sa(e) {
    const t = Ro(),
      n = hy(),
      o = vy(),
      s = my();
    t && (Object.assign(t.style, {
      ...Sd,
      ...na(e.bounds)
    }), Object.assign(n.style, {
      top: e.bounds.top < 35 ? 0 : "-35px"
    }), o.innerHTML = `&lt;${e.name}&gt;&nbsp;&nbsp;`, s.innerHTML = `${Math.round(e.bounds.width*100)/100} x ${Math.round(e.bounds.height*100)/100}`)
  }

  function gy(e) {
    const t = eo(e);
    if (!t.width && !t.height) return;
    const n = Sr(e);
    Ro() ? sa({
      bounds: t,
      name: n
    }) : oa({
      bounds: t,
      name: n
    })
  }

  function Dd() {
    const e = Ro();
    e && (e.style.display = "none")
  }
  var ra = null;

  function ia(e) {
    const t = e.target;
    if (t) {
      const n = t.__vueParentComponent;
      if (n && (ra = n, n.vnode.el)) {
        const s = eo(n),
          r = Sr(n);
        Ro() ? sa({
          bounds: s,
          name: r
        }) : oa({
          bounds: s,
          name: r
        })
      }
    }
  }

  function yy(e, t) {
    if (e.preventDefault(), e.stopPropagation(), ra) {
      const n = ay(ra);
      t(n)
    }
  }
  var Pr = null;

  function Cy() {
    Dd(), window.removeEventListener("mouseover", ia), window.removeEventListener("click", Pr, !0), Pr = null
  }

  function Ty() {
    return window.addEventListener("mouseover", ia), new Promise(e => {
      function t(n) {
        n.preventDefault(), n.stopPropagation(), yy(n, o => {
          window.removeEventListener("click", t, !0), Pr = null, window.removeEventListener("mouseover", ia);
          const s = Ro();
          s && (s.style.display = "none"), e(JSON.stringify({
            id: o
          }))
        })
      }
      Pr = t, window.addEventListener("click", t, !0)
    })
  }

  function by(e) {
    const t = ea(Ct.value, e.id);
    if (t) {
      const [n] = ta(t);
      if (typeof n.scrollIntoView == "function") n.scrollIntoView({
        behavior: "smooth"
      });
      else {
        const o = eo(t),
          s = document.createElement("div"),
          r = {
            ...na(o),
            position: "absolute"
          };
        Object.assign(s.style, r), document.body.appendChild(s), s.scrollIntoView({
          behavior: "smooth"
        }), setTimeout(() => {
          document.body.removeChild(s)
        }, 2e3)
      }
      setTimeout(() => {
        const o = eo(t);
        if (o.width || o.height) {
          const s = Sr(t),
            r = Ro();
          r ? sa({
            ...e,
            name: s,
            bounds: o
          }) : oa({
            ...e,
            name: s,
            bounds: o
          }), setTimeout(() => {
            r && (r.style.display = "none")
          }, 1500)
        }
      }, 1200)
    }
  }
  q();
  var Pd, Ed;
  (Ed = (Pd = pe).__VUE_DEVTOOLS_COMPONENT_INSPECTOR_ENABLED__) != null || (Pd.__VUE_DEVTOOLS_COMPONENT_INSPECTOR_ENABLED__ = !0);

  function Sy(e) {
    let t = 0;
    const n = setInterval(() => {
      pe.__VUE_INSPECTOR__ && (clearInterval(n), t += 30, e()), t >= 5e3 && clearInterval(n)
    }, 30)
  }

  function Dy() {
    const e = pe.__VUE_INSPECTOR__,
      t = e.openInEditor;
    e.openInEditor = async (...n) => {
      e.disable(), t(...n)
    }
  }

  function Py() {
    return new Promise(e => {
      function t() {
        Dy(), e(pe.__VUE_INSPECTOR__)
      }
      pe.__VUE_INSPECTOR__ ? t() : Sy(() => {
        t()
      })
    })
  }
  q(), q();

  function Ey(e) {
    return !!(e && e.__v_isReadonly)
  }

  function Od(e) {
    return Ey(e) ? Od(e.__v_raw) : !!(e && e.__v_isReactive)
  }

  function aa(e) {
    return !!(e && e.__v_isRef === !0)
  }

  function hs(e) {
    const t = e && e.__v_raw;
    return t ? hs(t) : e
  }
  var Oy = class {
      constructor() {
        this.refEditor = new Iy
      }
      set(e, t, n, o) {
        const s = Array.isArray(t) ? t : t.split(".");
        for (; s.length > 1;) {
          const i = s.shift();
          e instanceof Map ? e = e.get(i) : e instanceof Set ? e = Array.from(e.values())[i] : e = e[i], this.refEditor.isRef(e) && (e = this.refEditor.get(e))
        }
        const r = s[0],
          a = this.refEditor.get(e)[r];
        o ? o(e, r, n) : this.refEditor.isRef(a) ? this.refEditor.set(a, n) : e[r] = n
      }
      get(e, t) {
        const n = Array.isArray(t) ? t : t.split(".");
        for (let o = 0; o < n.length; o++)
          if (e instanceof Map ? e = e.get(n[o]) : e = e[n[o]], this.refEditor.isRef(e) && (e = this.refEditor.get(e)), !e) return;
        return e
      }
      has(e, t, n = !1) {
        if (typeof e > "u") return !1;
        const o = Array.isArray(t) ? t.slice() : t.split("."),
          s = n ? 2 : 1;
        for (; e && o.length > s;) {
          const r = o.shift();
          e = e[r], this.refEditor.isRef(e) && (e = this.refEditor.get(e))
        }
        return e != null && Object.prototype.hasOwnProperty.call(e, o[0])
      }
      createDefaultSetCallback(e) {
        return (t, n, o) => {
          if ((e.remove || e.newKey) && (Array.isArray(t) ? t.splice(n, 1) : hs(t) instanceof Map ? t.delete(n) : hs(t) instanceof Set ? t.delete(Array.from(t.values())[n]) : Reflect.deleteProperty(t, n)), !e.remove) {
            const s = t[e.newKey || n];
            this.refEditor.isRef(s) ? this.refEditor.set(s, o) : hs(t) instanceof Map ? t.set(e.newKey || n, o) : hs(t) instanceof Set ? t.add(o) : t[e.newKey || n] = o
          }
        }
      }
    },
    Iy = class {
      set(e, t) {
        if (aa(e)) e.value = t;
        else {
          if (e instanceof Set && Array.isArray(t)) {
            e.clear(), t.forEach(s => e.add(s));
            return
          }
          const n = Object.keys(t);
          if (e instanceof Map) {
            const s = new Set(e.keys());
            n.forEach(r => {
              e.set(r, Reflect.get(t, r)), s.delete(r)
            }), s.forEach(r => e.delete(r));
            return
          }
          const o = new Set(Object.keys(e));
          n.forEach(s => {
            Reflect.set(e, s, Reflect.get(t, s)), o.delete(s)
          }), o.forEach(s => Reflect.deleteProperty(e, s))
        }
      }
      get(e) {
        return aa(e) ? e.value : e
      }
      isRef(e) {
        return aa(e) || Od(e)
      }
    };
  q(), q(), q();
  var Ry = "__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS_STATE__";

  function wy() {
    if (!ud || typeof localStorage > "u" || localStorage === null) return {
      recordingState: !1,
      mouseEventEnabled: !1,
      keyboardEventEnabled: !1,
      componentEventEnabled: !1,
      performanceEventEnabled: !1,
      selected: ""
    };
    const e = localStorage.getItem(Ry);
    return e ? JSON.parse(e) : {
      recordingState: !1,
      mouseEventEnabled: !1,
      keyboardEventEnabled: !1,
      componentEventEnabled: !1,
      performanceEventEnabled: !1,
      selected: ""
    }
  }
  q(), q(), q();
  var Id, Rd;
  (Rd = (Id = pe).__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS) != null || (Id.__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS = []);
  var Ay = new Proxy(pe.__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS, {
    get(e, t, n) {
      return Reflect.get(e, t, n)
    }
  });

  function Ny(e, t) {
    Ze.timelineLayersState[t.id] = !1, Ay.push({
      ...e,
      descriptorId: t.id,
      appRecord: Zi(t.app)
    })
  }
  var wd, Ad;
  (Ad = (wd = pe).__VUE_DEVTOOLS_KIT_INSPECTOR__) != null || (wd.__VUE_DEVTOOLS_KIT_INSPECTOR__ = []);
  var la = new Proxy(pe.__VUE_DEVTOOLS_KIT_INSPECTOR__, {
      get(e, t, n) {
        return Reflect.get(e, t, n)
      }
    }),
    Nd = Io(() => {
      Ao.hooks.callHook("sendInspectorToClient", Md())
    });

  function My(e, t) {
    var n, o;
    la.push({
      options: e,
      descriptor: t,
      treeFilterPlaceholder: (n = e.treeFilterPlaceholder) != null ? n : "Search tree...",
      stateFilterPlaceholder: (o = e.stateFilterPlaceholder) != null ? o : "Search state...",
      treeFilter: "",
      selectedNodeId: "",
      appRecord: Zi(t.app)
    }), Nd()
  }

  function Md() {
    return la.filter(e => e.descriptor.app === Ct.value.app).filter(e => e.descriptor.id !== "components").map(e => {
      var t;
      const n = e.descriptor,
        o = e.options;
      return {
        id: o.id,
        label: o.label,
        logo: n.logo,
        icon: `custom-ic-baseline-${(t=o?.icon)==null?void 0:t.replace(/_/g,"-")}`,
        packageName: n.packageName,
        homepage: n.homepage,
        pluginId: n.id
      }
    })
  }

  function Er(e, t) {
    return la.find(n => n.options.id === e && (t ? n.descriptor.app === t : !0))
  }

  function ky() {
    const e = pd();
    e.hook("addInspector", ({
      inspector: o,
      plugin: s
    }) => {
      My(o, s.descriptor)
    });
    const t = Io(async ({
      inspectorId: o,
      plugin: s
    }) => {
      var r;
      if (!o || !((r = s?.descriptor) != null && r.app) || Ze.highPerfModeEnabled) return;
      const a = Er(o, s.descriptor.app),
        i = {
          app: s.descriptor.app,
          inspectorId: o,
          filter: a?.treeFilter || "",
          rootNodes: []
        };
      await new Promise(l => {
        e.callHookWith(async c => {
          await Promise.all(c.map(u => u(i))), l()
        }, "getInspectorTree")
      }), e.callHookWith(async l => {
        await Promise.all(l.map(c => c({
          inspectorId: o,
          rootNodes: i.rootNodes
        })))
      }, "sendInspectorTreeToClient")
    }, 120);
    e.hook("sendInspectorTree", t);
    const n = Io(async ({
      inspectorId: o,
      plugin: s
    }) => {
      var r;
      if (!o || !((r = s?.descriptor) != null && r.app) || Ze.highPerfModeEnabled) return;
      const a = Er(o, s.descriptor.app),
        i = {
          app: s.descriptor.app,
          inspectorId: o,
          nodeId: a?.selectedNodeId || "",
          state: null
        },
        l = {
          currentTab: `custom-inspector:${o}`
        };
      i.nodeId && await new Promise(c => {
        e.callHookWith(async u => {
          await Promise.all(u.map(d => d(i, l))), c()
        }, "getInspectorState")
      }), e.callHookWith(async c => {
        await Promise.all(c.map(u => u({
          inspectorId: o,
          nodeId: i.nodeId,
          state: i.state
        })))
      }, "sendInspectorStateToClient")
    }, 120);
    return e.hook("sendInspectorState", n), e.hook("customInspectorSelectNode", ({
      inspectorId: o,
      nodeId: s,
      plugin: r
    }) => {
      const a = Er(o, r.descriptor.app);
      a && (a.selectedNodeId = s)
    }), e.hook("timelineLayerAdded", ({
      options: o,
      plugin: s
    }) => {
      Ny(o, s.descriptor)
    }), e.hook("timelineEventAdded", ({
      options: o,
      plugin: s
    }) => {
      var r;
      const a = ["performance", "component-event", "keyboard", "mouse"];
      Ze.highPerfModeEnabled || !((r = Ze.timelineLayersState) != null && r[s.descriptor.id]) && !a.includes(o.layerId) || e.callHookWith(async i => {
        await Promise.all(i.map(l => l(o)))
      }, "sendTimelineEventToClient")
    }), e.hook("getComponentInstances", async ({
      app: o
    }) => {
      const s = o.__VUE_DEVTOOLS_NEXT_APP_RECORD__;
      if (!s) return null;
      const r = s.id.toString();
      return [...s.instanceMap].filter(([i]) => i.split(":")[0] === r).map(([, i]) => i)
    }), e.hook("getComponentBounds", async ({
      instance: o
    }) => eo(o)), e.hook("getComponentName", ({
      instance: o
    }) => Sr(o)), e.hook("componentHighlight", ({
      uid: o
    }) => {
      const s = Ct.value.instanceMap.get(o);
      s && gy(s)
    }), e.hook("componentUnhighlight", () => {
      Dd()
    }), e
  }
  var kd, Ld;
  (Ld = (kd = pe).__VUE_DEVTOOLS_KIT_APP_RECORDS__) != null || (kd.__VUE_DEVTOOLS_KIT_APP_RECORDS__ = []);
  var $d, xd;
  (xd = ($d = pe).__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__) != null || ($d.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ = {});
  var Fd, Ud;
  (Ud = (Fd = pe).__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__) != null || (Fd.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ = "");
  var Bd, Vd;
  (Vd = (Bd = pe).__VUE_DEVTOOLS_KIT_CUSTOM_TABS__) != null || (Bd.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__ = []);
  var Hd, Gd;
  (Gd = (Hd = pe).__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__) != null || (Hd.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__ = []);
  var to = "__VUE_DEVTOOLS_KIT_GLOBAL_STATE__";

  function Ly() {
    return {
      connected: !1,
      clientConnected: !1,
      vitePluginDetected: !0,
      appRecords: [],
      activeAppRecordId: "",
      tabs: [],
      commands: [],
      highPerfModeEnabled: !0,
      devtoolsClientDetected: {},
      perfUniqueGroupId: 0,
      timelineLayersState: wy()
    }
  }
  var jd, zd;
  (zd = (jd = pe)[to]) != null || (jd[to] = Ly());
  var $y = Io(e => {
    Ao.hooks.callHook("devtoolsStateUpdated", {
      state: e
    })
  });
  Io((e, t) => {
    Ao.hooks.callHook("devtoolsConnectedUpdated", {
      state: e,
      oldState: t
    })
  });
  var Or = new Proxy(pe.__VUE_DEVTOOLS_KIT_APP_RECORDS__, {
      get(e, t, n) {
        return t === "value" ? pe.__VUE_DEVTOOLS_KIT_APP_RECORDS__ : pe.__VUE_DEVTOOLS_KIT_APP_RECORDS__[t]
      }
    }),
    Ct = new Proxy(pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__, {
      get(e, t, n) {
        return t === "value" ? pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ : t === "id" ? pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ : pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__[t]
      }
    });

  function Yd() {
    $y({
      ...pe[to],
      appRecords: Or.value,
      activeAppRecordId: Ct.id,
      tabs: pe.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__,
      commands: pe.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__
    })
  }

  function xy(e) {
    pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ = e, Yd()
  }

  function Fy(e) {
    pe.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ = e, Yd()
  }
  var Ze = new Proxy(pe[to], {
    get(e, t) {
      return t === "appRecords" ? Or : t === "activeAppRecordId" ? Ct.id : t === "tabs" ? pe.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__ : t === "commands" ? pe.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__ : pe[to][t]
    },
    deleteProperty(e, t) {
      return delete e[t], !0
    },
    set(e, t, n) {
      return {
        ...pe[to]
      }, e[t] = n, pe[to][t] = n, !0
    }
  });

  function Uy(e = {}) {
    var t, n, o;
    const {
      file: s,
      host: r,
      baseUrl: a = window.location.origin,
      line: i = 0,
      column: l = 0
    } = e;
    if (s) {
      if (r === "chrome-extension") {
        const c = s.replace(/\\/g, "\\\\"),
          u = (n = (t = window.VUE_DEVTOOLS_CONFIG) == null ? void 0 : t.openInEditorHost) != null ? n : "/";
        fetch(`${u}__open-in-editor?file=${encodeURI(s)}`).then(d => {
          if (!d.ok) {
            const h = `Opening component ${c} failed`;
            console.log(`%c${h}`, "color:red")
          }
        })
      } else if (Ze.vitePluginDetected) {
        const c = (o = pe.__VUE_DEVTOOLS_OPEN_IN_EDITOR_BASE_URL__) != null ? o : a;
        pe.__VUE_INSPECTOR__.openInEditor(c, s, i, l)
      }
    }
  }
  q(), q(), q(), q(), q();
  var Kd, Wd;
  (Wd = (Kd = pe).__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__) != null || (Kd.__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__ = []);
  var ua = new Proxy(pe.__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__, {
    get(e, t, n) {
      return Reflect.get(e, t, n)
    }
  });

  function ca(e) {
    const t = {};
    return Object.keys(e).forEach(n => {
      t[n] = e[n].defaultValue
    }), t
  }

  function da(e) {
    return `__VUE_DEVTOOLS_NEXT_PLUGIN_SETTINGS__${e}__`
  }

  function By(e) {
    var t, n, o;
    const s = (n = (t = ua.find(r => {
      var a;
      return r[0].id === e && !!((a = r[0]) != null && a.settings)
    })) == null ? void 0 : t[0]) != null ? n : null;
    return (o = s?.settings) != null ? o : null
  }

  function qd(e, t) {
    var n, o, s;
    const r = da(e);
    if (r) {
      const a = localStorage.getItem(r);
      if (a) return JSON.parse(a)
    }
    if (e) {
      const a = (o = (n = ua.find(i => i[0].id === e)) == null ? void 0 : n[0]) != null ? o : null;
      return ca((s = a?.settings) != null ? s : {})
    }
    return ca(t)
  }

  function Vy(e, t) {
    const n = da(e);
    localStorage.getItem(n) || localStorage.setItem(n, JSON.stringify(ca(t)))
  }

  function Hy(e, t, n) {
    const o = da(e),
      s = localStorage.getItem(o),
      r = JSON.parse(s || "{}"),
      a = {
        ...r,
        [t]: n
      };
    localStorage.setItem(o, JSON.stringify(a)), Ao.hooks.callHookWith(i => {
      i.forEach(l => l({
        pluginId: e,
        key: t,
        oldValue: r[t],
        newValue: n,
        settings: a
      }))
    }, "setPluginSettings")
  }
  q(), q(), q(), q(), q(), q(), q(), q(), q(), q(), q();
  var Qd, Xd, kt = (Xd = (Qd = pe).__VUE_DEVTOOLS_HOOK) != null ? Xd : Qd.__VUE_DEVTOOLS_HOOK = pd(),
    Gy = {
      vueAppInit(e) {
        kt.hook("app:init", e)
      },
      vueAppUnmount(e) {
        kt.hook("app:unmount", e)
      },
      vueAppConnected(e) {
        kt.hook("app:connected", e)
      },
      componentAdded(e) {
        return kt.hook("component:added", e)
      },
      componentEmit(e) {
        return kt.hook("component:emit", e)
      },
      componentUpdated(e) {
        return kt.hook("component:updated", e)
      },
      componentRemoved(e) {
        return kt.hook("component:removed", e)
      },
      setupDevtoolsPlugin(e) {
        kt.hook("devtools-plugin:setup", e)
      },
      perfStart(e) {
        return kt.hook("perf:start", e)
      },
      perfEnd(e) {
        return kt.hook("perf:end", e)
      }
    },
    Jd = {
      on: Gy,
      setupDevToolsPlugin(e, t) {
        return kt.callHook("devtools-plugin:setup", e, t)
      }
    },
    jy = class {
      constructor({
        plugin: e,
        ctx: t
      }) {
        this.hooks = t.hooks, this.plugin = e
      }
      get on() {
        return {
          visitComponentTree: e => {
            this.hooks.hook("visitComponentTree", e)
          },
          inspectComponent: e => {
            this.hooks.hook("inspectComponent", e)
          },
          editComponentState: e => {
            this.hooks.hook("editComponentState", e)
          },
          getInspectorTree: e => {
            this.hooks.hook("getInspectorTree", e)
          },
          getInspectorState: e => {
            this.hooks.hook("getInspectorState", e)
          },
          editInspectorState: e => {
            this.hooks.hook("editInspectorState", e)
          },
          inspectTimelineEvent: e => {
            this.hooks.hook("inspectTimelineEvent", e)
          },
          timelineCleared: e => {
            this.hooks.hook("timelineCleared", e)
          },
          setPluginSettings: e => {
            this.hooks.hook("setPluginSettings", e)
          }
        }
      }
      notifyComponentUpdate(e) {
        var t;
        if (Ze.highPerfModeEnabled) return;
        const n = Md().find(o => o.packageName === this.plugin.descriptor.packageName);
        if (n?.id) {
          if (e) {
            const o = [e.appContext.app, e.uid, (t = e.parent) == null ? void 0 : t.uid, e];
            kt.callHook("component:updated", ...o)
          } else kt.callHook("component:updated");
          this.hooks.callHook("sendInspectorState", {
            inspectorId: n.id,
            plugin: this.plugin
          })
        }
      }
      addInspector(e) {
        this.hooks.callHook("addInspector", {
          inspector: e,
          plugin: this.plugin
        }), this.plugin.descriptor.settings && Vy(e.id, this.plugin.descriptor.settings)
      }
      sendInspectorTree(e) {
        Ze.highPerfModeEnabled || this.hooks.callHook("sendInspectorTree", {
          inspectorId: e,
          plugin: this.plugin
        })
      }
      sendInspectorState(e) {
        Ze.highPerfModeEnabled || this.hooks.callHook("sendInspectorState", {
          inspectorId: e,
          plugin: this.plugin
        })
      }
      selectInspectorNode(e, t) {
        this.hooks.callHook("customInspectorSelectNode", {
          inspectorId: e,
          nodeId: t,
          plugin: this.plugin
        })
      }
      visitComponentTree(e) {
        return this.hooks.callHook("visitComponentTree", e)
      }
      now() {
        return Ze.highPerfModeEnabled ? 0 : Date.now()
      }
      addTimelineLayer(e) {
        this.hooks.callHook("timelineLayerAdded", {
          options: e,
          plugin: this.plugin
        })
      }
      addTimelineEvent(e) {
        Ze.highPerfModeEnabled || this.hooks.callHook("timelineEventAdded", {
          options: e,
          plugin: this.plugin
        })
      }
      getSettings(e) {
        return qd(e ?? this.plugin.descriptor.id, this.plugin.descriptor.settings)
      }
      getComponentInstances(e) {
        return this.hooks.callHook("getComponentInstances", {
          app: e
        })
      }
      getComponentBounds(e) {
        return this.hooks.callHook("getComponentBounds", {
          instance: e
        })
      }
      getComponentName(e) {
        return this.hooks.callHook("getComponentName", {
          instance: e
        })
      }
      highlightElement(e) {
        const t = e.__VUE_DEVTOOLS_NEXT_UID__;
        return this.hooks.callHook("componentHighlight", {
          uid: t
        })
      }
      unhighlightElement() {
        return this.hooks.callHook("componentUnhighlight")
      }
    },
    zy = jy;
  q(), q(), q(), q();
  var Yy = "__vue_devtool_undefined__",
    Ky = "__vue_devtool_infinity__",
    Wy = "__vue_devtool_negative_infinity__",
    qy = "__vue_devtool_nan__";
  q(), q();
  var Qy = {
    [Yy]: "undefined",
    [qy]: "NaN",
    [Ky]: "Infinity",
    [Wy]: "-Infinity"
  };
  Object.entries(Qy).reduce((e, [t, n]) => (e[n] = t, e), {}), q(), q(), q(), q(), q();
  var Zd, ef;
  (ef = (Zd = pe).__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__) != null || (Zd.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__ = new Set);

  function tf(e, t) {
    return Jd.setupDevToolsPlugin(e, t)
  }

  function Xy(e, t) {
    const [n, o] = e;
    if (n.app !== t) return;
    const s = new zy({
      plugin: {
        setupFn: o,
        descriptor: n
      },
      ctx: Ao
    });
    n.packageName === "vuex" && s.on.editInspectorState(r => {
      s.sendInspectorState(r.inspectorId)
    }), o(s)
  }

  function nf(e, t) {
    pe.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__.has(e) || Ze.highPerfModeEnabled && !t?.inspectingComponent || (pe.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__.add(e), ua.forEach(n => {
      Xy(n, e)
    }))
  }
  q(), q();
  var ms = "__VUE_DEVTOOLS_ROUTER__",
    wo = "__VUE_DEVTOOLS_ROUTER_INFO__",
    of, sf;
  (sf = (of = pe)[wo]) != null || (of [wo] = {
    currentRoute: null,
    routes: []
  });
  var rf, af;
  (af = (rf = pe)[ms]) != null || (rf[ms] = {}), new Proxy(pe[wo], {
    get(e, t) {
      return pe[wo][t]
    }
  }), new Proxy(pe[ms], {
    get(e, t) {
      if (t === "value") return pe[ms]
    }
  });

  function Jy(e) {
    const t = new Map;
    return (e?.getRoutes() || []).filter(n => !t.has(n.path) && t.set(n.path, 1))
  }

  function fa(e) {
    return e.map(t => {
      let {
        path: n,
        name: o,
        children: s,
        meta: r
      } = t;
      return s?.length && (s = fa(s)), {
        path: n,
        name: o,
        children: s,
        meta: r
      }
    })
  }

  function Zy(e) {
    if (e) {
      const {
        fullPath: t,
        hash: n,
        href: o,
        path: s,
        name: r,
        matched: a,
        params: i,
        query: l
      } = e;
      return {
        fullPath: t,
        hash: n,
        href: o,
        path: s,
        name: r,
        params: i,
        query: l,
        matched: fa(a)
      }
    }
    return e
  }

  function eC(e, t) {
    function n() {
      var o;
      const s = (o = e.app) == null ? void 0 : o.config.globalProperties.$router,
        r = Zy(s?.currentRoute.value),
        a = fa(Jy(s)),
        i = console.warn;
      console.warn = () => {}, pe[wo] = {
        currentRoute: r ? dd(r) : {},
        routes: dd(a)
      }, pe[ms] = s, console.warn = i
    }
    n(), Jd.on.componentUpdated(Io(() => {
      var o;
      ((o = t.value) == null ? void 0 : o.app) === e.app && (n(), !Ze.highPerfModeEnabled && Ao.hooks.callHook("routerInfoUpdated", {
        state: pe[wo]
      }))
    }, 200))
  }

  function tC(e) {
    return {
      async getInspectorTree(t) {
        const n = {
          ...t,
          app: Ct.value.app,
          rootNodes: []
        };
        return await new Promise(o => {
          e.callHookWith(async s => {
            await Promise.all(s.map(r => r(n))), o()
          }, "getInspectorTree")
        }), n.rootNodes
      },
      async getInspectorState(t) {
        const n = {
            ...t,
            app: Ct.value.app,
            state: null
          },
          o = {
            currentTab: `custom-inspector:${t.inspectorId}`
          };
        return await new Promise(s => {
          e.callHookWith(async r => {
            await Promise.all(r.map(a => a(n, o))), s()
          }, "getInspectorState")
        }), n.state
      },
      editInspectorState(t) {
        const n = new Oy,
          o = {
            ...t,
            app: Ct.value.app,
            set: (s, r = t.path, a = t.state.value, i) => {
              n.set(s, r, a, i || n.createDefaultSetCallback(t.state))
            }
          };
        e.callHookWith(s => {
          s.forEach(r => r(o))
        }, "editInspectorState")
      },
      sendInspectorState(t) {
        const n = Er(t);
        e.callHook("sendInspectorState", {
          inspectorId: t,
          plugin: {
            descriptor: n.descriptor,
            setupFn: () => ({})
          }
        })
      },
      inspectComponentInspector() {
        return Ty()
      },
      cancelInspectComponentInspector() {
        return Cy()
      },
      getComponentRenderCode(t) {
        const n = ea(Ct.value, t);
        if (n) return typeof n?.type != "function" ? n.render.toString() : n.type.toString()
      },
      scrollToComponent(t) {
        return by({
          id: t
        })
      },
      openInEditor: Uy,
      getVueInspector: Py,
      toggleApp(t, n) {
        const o = Or.value.find(s => s.id === t);
        o && (Fy(t), xy(o), eC(o, Ct), Nd(), nf(o.app, n))
      },
      inspectDOM(t) {
        const n = ea(Ct.value, t);
        if (n) {
          const [o] = ta(n);
          o && (pe.__VUE_DEVTOOLS_INSPECT_DOM_TARGET__ = o)
        }
      },
      updatePluginSettings(t, n, o) {
        Hy(t, n, o)
      },
      getPluginSettings(t) {
        return {
          options: By(t),
          values: qd(t)
        }
      }
    }
  }
  q();
  var lf, uf;
  (uf = (lf = pe).__VUE_DEVTOOLS_ENV__) != null || (lf.__VUE_DEVTOOLS_ENV__ = {
    vitePluginDetected: !1
  });
  var cf = ky(),
    df, ff;
  (ff = (df = pe).__VUE_DEVTOOLS_KIT_CONTEXT__) != null || (df.__VUE_DEVTOOLS_KIT_CONTEXT__ = {
    hooks: cf,
    get state() {
      return {
        ...Ze,
        activeAppRecordId: Ct.id,
        activeAppRecord: Ct.value,
        appRecords: Or.value
      }
    },
    api: tC(cf)
  });
  var Ao = pe.__VUE_DEVTOOLS_KIT_CONTEXT__;
  q(), ny(sy());
  var pf, _f;
  (_f = (pf = pe).__VUE_DEVTOOLS_NEXT_APP_RECORD_INFO__) != null || (pf.__VUE_DEVTOOLS_NEXT_APP_RECORD_INFO__ = {
    id: 0,
    appIds: new Set
  }), q(), q();

  function nC(e) {
    Ze.highPerfModeEnabled = e ?? !Ze.highPerfModeEnabled, !e && Ct.value && nf(Ct.value.app)
  }
  q(), q(), q();

  function oC(e) {
    Ze.devtoolsClientDetected = {
      ...Ze.devtoolsClientDetected,
      ...e
    };
    const t = Object.values(Ze.devtoolsClientDetected).some(Boolean);
    nC(!t)
  }
  var hf, mf;
  (mf = (hf = pe).__VUE_DEVTOOLS_UPDATE_CLIENT_DETECTED__) != null || (hf.__VUE_DEVTOOLS_UPDATE_CLIENT_DETECTED__ = oC), q(), q(), q(), q(), q(), q(), q();
  var sC = class {
      constructor() {
        this.keyToValue = new Map, this.valueToKey = new Map
      }
      set(e, t) {
        this.keyToValue.set(e, t), this.valueToKey.set(t, e)
      }
      getByKey(e) {
        return this.keyToValue.get(e)
      }
      getByValue(e) {
        return this.valueToKey.get(e)
      }
      clear() {
        this.keyToValue.clear(), this.valueToKey.clear()
      }
    },
    vf = class {
      constructor(e) {
        this.generateIdentifier = e, this.kv = new sC
      }
      register(e, t) {
        this.kv.getByValue(e) || (t || (t = this.generateIdentifier(e)), this.kv.set(t, e))
      }
      clear() {
        this.kv.clear()
      }
      getIdentifier(e) {
        return this.kv.getByValue(e)
      }
      getValue(e) {
        return this.kv.getByKey(e)
      }
    },
    rC = class extends vf {
      constructor() {
        super(e => e.name), this.classToAllowedProps = new Map
      }
      register(e, t) {
        typeof t == "object" ? (t.allowProps && this.classToAllowedProps.set(e, t.allowProps), super.register(e, t.identifier)) : super.register(e, t)
      }
      getAllowedProps(e) {
        return this.classToAllowedProps.get(e)
      }
    };
  q(), q();

  function iC(e) {
