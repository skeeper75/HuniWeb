  var Hr = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {};

  function Yp(e) {
    return e && e.__esModule && Object.prototype.hasOwnProperty.call(e, "default") ? e.default : e
  }
  var ja, Kp;

  function Gr() {
    if (Kp) return ja;
    Kp = 1;

    function e(t) {
      var n = typeof t;
      return t != null && (n == "object" || n == "function")
    }
    return ja = e, ja
  }
  var za, Wp;

  function qp() {
    if (Wp) return za;
    Wp = 1;
    var e = typeof Hr == "object" && Hr && Hr.Object === Object && Hr;
    return za = e, za
  }
  var Ya, Qp;

  function bn() {
    if (Qp) return Ya;
    Qp = 1;
    var e = qp(),
      t = typeof self == "object" && self && self.Object === Object && self,
      n = e || t || Function("return this")();
    return Ya = n, Ya
  }
  var Ka, Xp;

  function sT() {
    if (Xp) return Ka;
    Xp = 1;
    var e = bn(),
      t = function() {
        return e.Date.now()
      };
    return Ka = t, Ka
  }
  var Wa, Jp;

  function rT() {
    if (Jp) return Wa;
    Jp = 1;
    var e = /\s/;

    function t(n) {
      for (var o = n.length; o-- && e.test(n.charAt(o)););
      return o
    }
    return Wa = t, Wa
  }
  var qa, Zp;

  function iT() {
    if (Zp) return qa;
    Zp = 1;
    var e = rT(),
      t = /^\s+/;

    function n(o) {
      return o && o.slice(0, e(o) + 1).replace(t, "")
    }
    return qa = n, qa
  }
  var Qa, e_;

  function t_() {
    if (e_) return Qa;
    e_ = 1;
    var e = bn(),
      t = e.Symbol;
    return Qa = t, Qa
  }
  var Xa, n_;

  function aT() {
    if (n_) return Xa;
    n_ = 1;
    var e = t_(),
      t = Object.prototype,
      n = t.hasOwnProperty,
      o = t.toString,
      s = e ? e.toStringTag : void 0;

    function r(a) {
      var i = n.call(a, s),
        l = a[s];
      try {
        a[s] = void 0;
        var c = !0
      } catch {}
      var u = o.call(a);
      return c && (i ? a[s] = l : delete a[s]), u
    }
    return Xa = r, Xa
  }
  var Ja, o_;

  function lT() {
    if (o_) return Ja;
    o_ = 1;
    var e = Object.prototype,
      t = e.toString;

    function n(o) {
      return t.call(o)
    }
    return Ja = n, Ja
  }
  var Za, s_;

  function Rs() {
    if (s_) return Za;
    s_ = 1;
    var e = t_(),
      t = aT(),
      n = lT(),
      o = "[object Null]",
      s = "[object Undefined]",
      r = e ? e.toStringTag : void 0;

    function a(i) {
      return i == null ? i === void 0 ? s : o : r && r in Object(i) ? t(i) : n(i)
    }
    return Za = a, Za
  }
  var el, r_;

  function jr() {
    if (r_) return el;
    r_ = 1;

    function e(t) {
      return t != null && typeof t == "object"
    }
    return el = e, el
  }
  var tl, i_;

  function uT() {
    if (i_) return tl;
    i_ = 1;
    var e = Rs(),
      t = jr(),
      n = "[object Symbol]";

    function o(s) {
      return typeof s == "symbol" || t(s) && e(s) == n
    }
    return tl = o, tl
  }
  var nl, a_;

  function cT() {
    if (a_) return nl;
    a_ = 1;
    var e = iT(),
      t = Gr(),
      n = uT(),
      o = NaN,
      s = /^[-+]0x[0-9a-f]+$/i,
      r = /^0b[01]+$/i,
      a = /^0o[0-7]+$/i,
      i = parseInt;

    function l(c) {
      if (typeof c == "number") return c;
      if (n(c)) return o;
      if (t(c)) {
        var u = typeof c.valueOf == "function" ? c.valueOf() : c;
        c = t(u) ? u + "" : u
      }
      if (typeof c != "string") return c === 0 ? c : +c;
      c = e(c);
      var d = r.test(c);
      return d || a.test(c) ? i(c.slice(2), d ? 2 : 8) : s.test(c) ? o : +c
    }
    return nl = l, nl
  }
  var ol, l_;

  function dT() {
    if (l_) return ol;
    l_ = 1;
    var e = Gr(),
      t = sT(),
      n = cT(),
      o = "Expected a function",
      s = Math.max,
      r = Math.min;

    function a(i, l, c) {
      var u, d, h, f, _, p, m = 0,
        v = !1,
        E = !1,
        k = !0;
      if (typeof i != "function") throw new TypeError(o);
      l = n(l) || 0, e(c) && (v = !!c.leading, E = "maxWait" in c, h = E ? s(n(c.maxWait) || 0, l) : h, k = "trailing" in c ? !!c.trailing : k);

      function N(U) {
        var Z = u,
          me = d;
        return u = d = void 0, m = U, f = i.apply(me, Z), f
      }

      function D(U) {
        return m = U, _ = setTimeout(b, l), v ? N(U) : f
      }

      function O(U) {
        var Z = U - p,
          me = U - m,
          _e = l - Z;
        return E ? r(_e, h - me) : _e
      }

      function A(U) {
        var Z = U - p,
          me = U - m;
        return p === void 0 || Z >= l || Z < 0 || E && me >= h
      }

      function b() {
        var U = t();
        if (A(U)) return C(U);
        _ = setTimeout(b, O(U))
      }

      function C(U) {
        return _ = void 0, k && u ? N(U) : (u = d = void 0, f)
      }

      function y() {
        _ !== void 0 && clearTimeout(_), m = 0, u = p = d = _ = void 0
      }

      function I() {
        return _ === void 0 ? f : C(t())
      }

      function w() {
        var U = t(),
          Z = A(U);
        if (u = arguments, d = this, p = U, Z) {
          if (_ === void 0) return D(p);
          if (E) return clearTimeout(_), _ = setTimeout(b, l), N(p)
        }
        return _ === void 0 && (_ = setTimeout(b, l)), f
      }
      return w.cancel = y, w.flush = I, w
    }
    return ol = a, ol
  }
  var fT = dT();
  const un = Yp(fT);
  var sl, u_;

  function c_() {
    if (u_) return sl;
    u_ = 1;
    var e = Object.prototype;

    function t(n) {
      var o = n && n.constructor,
        s = typeof o == "function" && o.prototype || e;
      return n === s
    }
    return sl = t, sl
  }
  var rl, d_;

  function pT() {
    if (d_) return rl;
    d_ = 1;

    function e(t, n) {
      return function(o) {
        return t(n(o))
      }
    }
    return rl = e, rl
  }
  var il, f_;

  function _T() {
    if (f_) return il;
    f_ = 1;
    var e = pT(),
      t = e(Object.keys, Object);
    return il = t, il
  }
  var al, p_;

  function hT() {
    if (p_) return al;
    p_ = 1;
    var e = c_(),
      t = _T(),
      n = Object.prototype,
      o = n.hasOwnProperty;

    function s(r) {
      if (!e(r)) return t(r);
      var a = [];
      for (var i in Object(r)) o.call(r, i) && i != "constructor" && a.push(i);
      return a
    }
    return al = s, al
  }
  var ll, __;

  function h_() {
    if (__) return ll;
    __ = 1;
    var e = Rs(),
      t = Gr(),
      n = "[object AsyncFunction]",
      o = "[object Function]",
      s = "[object GeneratorFunction]",
      r = "[object Proxy]";

    function a(i) {
      if (!t(i)) return !1;
      var l = e(i);
      return l == o || l == s || l == n || l == r
    }
    return ll = a, ll
  }
  var ul, m_;

  function mT() {
    if (m_) return ul;
    m_ = 1;
    var e = bn(),
      t = e["__core-js_shared__"];
    return ul = t, ul
  }
  var cl, v_;

  function vT() {
    if (v_) return cl;
    v_ = 1;
    var e = mT(),
      t = (function() {
        var o = /[^.]+$/.exec(e && e.keys && e.keys.IE_PROTO || "");
        return o ? "Symbol(src)_1." + o : ""
      })();

    function n(o) {
      return !!t && t in o
    }
    return cl = n, cl
  }
  var dl, g_;

  function y_() {
    if (g_) return dl;
    g_ = 1;
    var e = Function.prototype,
      t = e.toString;

    function n(o) {
      if (o != null) {
        try {
          return t.call(o)
        } catch {}
        try {
          return o + ""
        } catch {}
      }
      return ""
    }
    return dl = n, dl
  }
  var fl, C_;

  function gT() {
    if (C_) return fl;
    C_ = 1;
    var e = h_(),
      t = vT(),
      n = Gr(),
      o = y_(),
      s = /[\\^$.*+?()[\]{}|]/g,
      r = /^\[object .+?Constructor\]$/,
      a = Function.prototype,
      i = Object.prototype,
      l = a.toString,
      c = i.hasOwnProperty,
      u = RegExp("^" + l.call(c).replace(s, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$");

    function d(h) {
      if (!n(h) || t(h)) return !1;
      var f = e(h) ? u : r;
      return f.test(o(h))
    }
    return fl = d, fl
  }
  var pl, T_;

  function yT() {
    if (T_) return pl;
    T_ = 1;

    function e(t, n) {
      return t?.[n]
    }
    return pl = e, pl
  }
  var _l, b_;

  function ws() {
    if (b_) return _l;
    b_ = 1;
    var e = gT(),
      t = yT();

    function n(o, s) {
      var r = t(o, s);
      return e(r) ? r : void 0
    }
    return _l = n, _l
  }
  var hl, S_;

  function CT() {
    if (S_) return hl;
    S_ = 1;
    var e = ws(),
      t = bn(),
      n = e(t, "DataView");
    return hl = n, hl
  }
  var ml, D_;

  function TT() {
    if (D_) return ml;
    D_ = 1;
    var e = ws(),
      t = bn(),
      n = e(t, "Map");
    return ml = n, ml
  }
  var vl, P_;

  function bT() {
    if (P_) return vl;
    P_ = 1;
    var e = ws(),
      t = bn(),
      n = e(t, "Promise");
    return vl = n, vl
  }
  var gl, E_;

  function ST() {
    if (E_) return gl;
    E_ = 1;
    var e = ws(),
      t = bn(),
      n = e(t, "Set");
    return gl = n, gl
  }
  var yl, O_;

  function DT() {
    if (O_) return yl;
    O_ = 1;
    var e = ws(),
      t = bn(),
      n = e(t, "WeakMap");
    return yl = n, yl
  }
  var Cl, I_;

  function PT() {
    if (I_) return Cl;
    I_ = 1;
    var e = CT(),
      t = TT(),
      n = bT(),
      o = ST(),
      s = DT(),
      r = Rs(),
      a = y_(),
      i = "[object Map]",
      l = "[object Object]",
      c = "[object Promise]",
      u = "[object Set]",
      d = "[object WeakMap]",
      h = "[object DataView]",
      f = a(e),
      _ = a(t),
      p = a(n),
      m = a(o),
      v = a(s),
      E = r;
    return (e && E(new e(new ArrayBuffer(1))) != h || t && E(new t) != i || n && E(n.resolve()) != c || o && E(new o) != u || s && E(new s) != d) && (E = function(k) {
      var N = r(k),
        D = N == l ? k.constructor : void 0,
        O = D ? a(D) : "";
      if (O) switch (O) {
        case f:
          return h;
        case _:
          return i;
        case p:
          return c;
        case m:
          return u;
        case v:
          return d
      }
      return N
    }), Cl = E, Cl
  }
  var Tl, R_;

  function ET() {
    if (R_) return Tl;
    R_ = 1;
    var e = Rs(),
      t = jr(),
      n = "[object Arguments]";

    function o(s) {
      return t(s) && e(s) == n
    }
    return Tl = o, Tl
  }
  var bl, w_;

  function OT() {
    if (w_) return bl;
    w_ = 1;
    var e = ET(),
      t = jr(),
      n = Object.prototype,
      o = n.hasOwnProperty,
      s = n.propertyIsEnumerable,
      r = e((function() {
        return arguments
      })()) ? e : function(a) {
        return t(a) && o.call(a, "callee") && !s.call(a, "callee")
      };
    return bl = r, bl
  }
  var Sl, A_;

  function IT() {
    if (A_) return Sl;
    A_ = 1;
    var e = Array.isArray;
    return Sl = e, Sl
  }
  var Dl, N_;

  function M_() {
    if (N_) return Dl;
    N_ = 1;
    var e = 9007199254740991;

    function t(n) {
      return typeof n == "number" && n > -1 && n % 1 == 0 && n <= e
    }
    return Dl = t, Dl
  }
  var Pl, k_;

  function RT() {
    if (k_) return Pl;
    k_ = 1;
    var e = h_(),
      t = M_();

    function n(o) {
      return o != null && t(o.length) && !e(o)
    }
    return Pl = n, Pl
  }
  var As = {
      exports: {}
    },
    El, L_;

  function wT() {
    if (L_) return El;
    L_ = 1;

    function e() {
      return !1
    }
    return El = e, El
  }
  As.exports;
  var $_;

  function AT() {
    return $_ || ($_ = 1, (function(e, t) {
      var n = bn(),
        o = wT(),
        s = t && !t.nodeType && t,
        r = s && !0 && e && !e.nodeType && e,
        a = r && r.exports === s,
        i = a ? n.Buffer : void 0,
        l = i ? i.isBuffer : void 0,
        c = l || o;
      e.exports = c
    })(As, As.exports)), As.exports
  }
  var Ol, x_;

  function NT() {
    if (x_) return Ol;
    x_ = 1;
    var e = Rs(),
      t = M_(),
      n = jr(),
      o = "[object Arguments]",
      s = "[object Array]",
      r = "[object Boolean]",
      a = "[object Date]",
      i = "[object Error]",
      l = "[object Function]",
      c = "[object Map]",
      u = "[object Number]",
      d = "[object Object]",
      h = "[object RegExp]",
      f = "[object Set]",
      _ = "[object String]",
      p = "[object WeakMap]",
      m = "[object ArrayBuffer]",
      v = "[object DataView]",
      E = "[object Float32Array]",
      k = "[object Float64Array]",
      N = "[object Int8Array]",
      D = "[object Int16Array]",
      O = "[object Int32Array]",
      A = "[object Uint8Array]",
      b = "[object Uint8ClampedArray]",
      C = "[object Uint16Array]",
      y = "[object Uint32Array]",
      I = {};
    I[E] = I[k] = I[N] = I[D] = I[O] = I[A] = I[b] = I[C] = I[y] = !0, I[o] = I[s] = I[m] = I[r] = I[v] = I[a] = I[i] = I[l] = I[c] = I[u] = I[d] = I[h] = I[f] = I[_] = I[p] = !1;

    function w(U) {
      return n(U) && t(U.length) && !!I[e(U)]
    }
    return Ol = w, Ol
  }
  var Il, F_;

  function MT() {
    if (F_) return Il;
    F_ = 1;

    function e(t) {
      return function(n) {
        return t(n)
      }
    }
    return Il = e, Il
  }
  var Ns = {
    exports: {}
  };
  Ns.exports;
  var U_;

  function kT() {
    return U_ || (U_ = 1, (function(e, t) {
      var n = qp(),
        o = t && !t.nodeType && t,
        s = o && !0 && e && !e.nodeType && e,
        r = s && s.exports === o,
        a = r && n.process,
        i = (function() {
          try {
            var l = s && s.require && s.require("util").types;
            return l || a && a.binding && a.binding("util")
          } catch {}
        })();
      e.exports = i
    })(Ns, Ns.exports)), Ns.exports
  }
  var Rl, B_;

  function LT() {
    if (B_) return Rl;
    B_ = 1;
    var e = NT(),
      t = MT(),
      n = kT(),
      o = n && n.isTypedArray,
      s = o ? t(o) : e;
    return Rl = s, Rl
  }
  var wl, V_;

  function $T() {
    if (V_) return wl;
    V_ = 1;
    var e = hT(),
      t = PT(),
      n = OT(),
      o = IT(),
      s = RT(),
      r = AT(),
      a = c_(),
      i = LT(),
      l = "[object Map]",
      c = "[object Set]",
      u = Object.prototype,
      d = u.hasOwnProperty;

    function h(f) {
      if (f == null) return !0;
      if (s(f) && (o(f) || typeof f == "string" || typeof f.splice == "function" || r(f) || i(f) || n(f))) return !f.length;
      var _ = t(f);
      if (_ == l || _ == c) return !f.size;
      if (a(f)) return !e(f).length;
      for (var p in f)
        if (d.call(f, p)) return !1;
      return !0
    }
    return wl = h, wl
  }
  var xT = $T();
  const cn = Yp(xT),
    xo = "https://www.redprinting.co.kr",
    qe = "https://d3qehkb69dy9zc.cloudfront.net/assets/images",
    H_ = "https://widget-api.redprinting.co.kr";
  async function G_(e = "ko", t, n) {
    try {
      const o = new URLSearchParams(n ? {
          pdt_cod: t,
          ptt_cod: n
        } : {
          pdt_cod: t
        }).toString(),
        s = `${xo}/${e}/product/get_digital_product_info?${o}`,
        a = await (await fetch(s)).json();
      if (a.retCode !== 200) throw new Error(a.msg);
      const {
        result: i
      } = a;
      return {
        result: i,
        errorMessage: null
      }
    } catch (o) {
      let s = "제품 정보를 가져올 수 없습니다.";
      return o instanceof Error && (console.error("[RedWidgetSDK/ERROR] 제품 정보 가져오기 실패 > ", o), o.message && (s = o.message)), {
        result: null,
        errorMessage: s
      }
    }
  }
  async function Al(e, t = "ko") {
    let n = null;
    try {
      const o = `${xo}/${t}/product_price/get_ajax_price_vTmpl`;
      if (n = await (await fetch(o, {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            dataJson: e.body
          })
        })).json(), n.retCode !== 200) throw new Error(n.msg);
      return {
        result: n,
        errorMessage: null
      }
    } catch (o) {
      console.error("[RedWidgetSDK/ERROR] 가격 요청 실패 > ", o);
      let s = "가격 요청에 실패했습니다.";
      return o instanceof Error && (s = o.message), {
        result: n,
        errorMessage: s
      }
    }
  }
  async function FT(e) {
    try {
      const {
        lang: t,
        file_name: n
      } = e, o = `${xo}/${t}/product/s3GetObjectJson`, r = await (await fetch(o, {
        method: "POST",
        body: JSON.stringify({
          file_name: n
        })
      })).json();
      if (!r) throw new Error("해당 파일은 s3에 존재하지 않습니다");
      return r
    } catch (t) {
      let n = "";
      return t instanceof Error && (n = t.message), console.error("[RedWidgetSDK/ERROR] s3 파일 정보 가져오기 실패 >. ", n || t), null
    }
  }
  async function Nl(e) {
    try {
      const {
        lang: t,
        pdt_cod: n
      } = e, o = `${xo}/${t}/product/guide_product_paper`, r = await (await fetch(o, {
        method: "POST",
        body: JSON.stringify({
          pdt_cod: n
        })
      })).json();
      if (!r) throw new Error;
      const a = [],
        i = new Set([]);
      for (const l of r) {
        const c = `${l.PDT_COD}/${l.PTT_COD}`;
        i.has(c) || (i.add(c), a.push({
          ...l,
          IMG_URL_DEFAULT: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${l.PTT_COD}.png`,
          IMG_URL_DETAIL: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${l.PTT_COD}_over.png`,
          PDT_COD: n
        }))
      }
      return a
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 주문 가능 용지(자재) 정보 가져오기 실패 > ", t), null
    }
  }
  async function UT(e) {
    try {
      const {
        lang: t,
        ...n
      } = e, o = new FormData;
      Object.entries(n).forEach(([c, u]) => o.append(c, u));
      const s = `${xo}/${t}/product/get_download`,
        a = await (await fetch(s, {
          method: "POST",
          body: o
        })).blob();
      if (a.type !== "application/zip") throw new Error("템플릿 파일(.zip)이 존재하지 않습니다.");
      const i = URL.createObjectURL(a),
        l = document.createElement("a");
      return l.href = i, l.download = `${n.file_nm.replace(/\./g,"_")}`, document.body.appendChild(l), l.click(), l.remove(), URL.revokeObjectURL(i), !0
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 템플릿 다운로드 실패 > ", t), !1
    }
  }
  async function BT(e) {
    try {
      const {
        lang: t,
        ...n
      } = e, o = new FormData;
      Object.entries(n).forEach(([l, c]) => o.append(l, c));
      const s = `${xo}/${t}/product/get_pdf_download`,
        a = await (await fetch(s, {
          method: "POST",
          body: o
        })).json();
      if (!a.success || !a.url) throw new Error(a.msg);
      const i = document.createElement("a");
      return i.href = a.url, document.body.appendChild(i), i.click(), i.remove(), !0
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 책자 표지 템플릿 다운로드 실패 > ", t), !1
    }
  }
  const VT = {
      주문서작성: "Orientation",
      가로: "Horizontal",
      세로: "Vertical",
      용지: "Paper",
      자재: "Material",
      액자: "Frame",
      모양: "Shape",
      제작방식: "Type",
      주문가능용지: "Available Papers",
      주문가능자재: "Available Materials",
      인쇄데이터: "Front & Back",
      브랜드: "Brand",
      제조사: "Brand",
      기종: "Model",
      케이스종류: "Case Type",
      자재종류: "Material Type",
      두께: "Thickness",
      규격: "Specification",
      "규격-단위": "Specification (mm)",
      규격가이드: "Specification Guide",
      재단사이즈: "Cutting Size",
      작업사이즈: "Working Size",
      사이즈직접입력: "Input Size",
      사이즈: "Size",
      사이즈별수량: "Size",
      인쇄도수: "Printing Option",
      양면: "Double Sided",
      단면: "Single Sided",
      후가공: "Finishing",
      부자재선택: "Accessories",
      자동화이트: "Auto-Generated",
      수동화이트: "Upload Own White Layer (PDF)",
      디자인수: "No. Of Designs",
      디자인별수량: "Qty per Design",
      수량: "Qty / Per Design",
      세트별수량: "Qty / Per Set",
      세트: "Set",
      총수량: "Total Qty",
      주문수량안내: "* The total order quantity is <span class='bold red'>{QTY}</span>",
      개: "pcs",
      건: "",
      단위주문수량안내: "* {QTY}pc per increment",
      PDF장수안내: "Please upload {QTY} page PDF",
      세트수량안내: "After creating photos in Editor, total quantity will be displayed above",
      디자인건수안내: "* The number of designs is <span class='bold red'>{QTY}</span>",
      "디자인건수가능여부-전체": "No. Of Designs can be added in Editor or PDF Upload.",
      "디자인건수가능여부-에디터": "No. Of Designs can be added in Editor",
      직접입력: "Input Quantity",
      수량선택: "Select Quantity",
      조립: "Attached",
      미조립: "Detached",
      파일업로드: "File Upload",
      내지업로드: "Inner Page Upload",
      표지업로드: "Cover Page Upload",
      "파일업로드-MS": "Printing output may be different when printing using PDF files created by MS-OFFICE series.",
      파일업로드레이어안내: "Submit artwork file in working size.",
      "pdf-only": "PDF ONLY",
      주문제목: "Order Title",
      에디터: "Creative Editor",
      편집하기: "Edit",
      재편집하기: "Re-Edit",
      템플릿다운로드: "Template Download",
      인쇄비: "Printing Fees",
      후가공비: "Finishing Fees",
      합계: "Sub Total",
      부가세: "Tax",
      청구금액: "Total",
      할인: "Discount",
      개당: "unit",
      원: "Won",
      상세내역: "Summary",
      "summary.인쇄방식": "Type",
      "summary.재단": "Cut Size",
      "summary.작업": "Bleed",
      "summary.디자인수": "Design",
      "summary.세트": "Set",
      "summary.수량": "Qty",
      "summary.개당": "Unit",
      "summary.청구금액": "Total",
      "summary.예상무게": "Weight(kg)",
      "summary.예상박스": "Box(est)",
      "summary.배송비": "Shipping",
      "summary.공급가": "Price",
      "summary.부가세": "Tax",
      가이드보기: "View Guide",
      주문불가: "Out of stock",
      "의류.Single Sided": "Custom Printing",
      "의류.No Printing": "No Printing",
      장: "pcs",
      의류주문가능수량: "* <b>{QTY}</b>pc (MOQ).",
      선택: "Selected",
      "인쇄 컬러(팬톤)": "Color Printing(Pantone)",
      "팬톤 컬러": "Pantone",
      "1종 선택 가능": "Choose ONE",
      "팬톤 컬러 선택하기": "Select Pantone Color",
      "팬톤 컬러 선택": "Select Pantone Color",
      "넘버 입력": "Enter Pantone#",
      "의류 컬러": "Color",
      "인쇄 영역": "Printing Area",
      인쇄: "Print",
      의류인쇄영역가이드: "* <b>Only Front & Left Chest</b> cannot be selected together.",
      "의류인쇄영역가이드-직접인쇄": "* <b>{areas}</b>: all printed by Hot Melt & Cut.",
      "의류인쇄영역가이드-실크인쇄": "* Added Cost - (Chest, Arm, Neck: 50,000 won | Front, Back: 70,000 won)",
      팬톤검색문구: "* Pantone Color Finder",
      팬톤검색안내: "The color chip on the left shows the RGB color as displayed on your screen, so it may differ from the actual Pantone color. Please select a Pantone color, or enter the Pantone number directly if you cannot find your desired color.",
      팬톤검색실패문구: "Color not found. Please see desired color from Swatch. If you are unable to find your desired color, kindly email us.",
      적용하기: "Apply",
      퀵오더불가: "* Normal Shipping Only : Imported from Japan (Production: est.3-4 weeks).",
      adult: "Adult",
      child: "Kids",
      "개별 포장": "Individual Packaging",
      선택안함: "No",
      선택함: "Yes",
      업로드파일삭제메시지: `Uploaded file will be deleted
Would you like to continue?`,
      파일형식에러메시지: "This file has an invalid extension. Valid extension(s): {ext}",
      파일사이즈에러메시지: "This file exceeds the allowed file size(1GB)",
      컬러: "Color",
      달력시작: "Starting Year/Month",
      달력시작설명: "* A 12-month calendar is provided starting from the month you selected.",
      달력디자인수설명: "Up to 13 standard, due to ring size, up to 24 can be ordered",
      최소단위수량안내: "You can order in {UNIT_QTY} units of {MIN_QTY} or more.",
      짝수: "even",
      홀수: "odd",
      연도: " Year",
      "1월": "January",
      "2월": "Feburary",
      "3월": "March",
      "4월": "April",
      "5월": "May",
      "6월": "June",
      "7월": "July",
      "8월": "August",
      "9월": "September",
      "10월": "October",
      "11월": "November",
      "12월": "December",
      윤전책자최소수량안내: "* MOQ: {MIN_CNT} books",
      토너책자최소수량안내: "* [Toner] MOQ: {MIN_CNT} books",
      "토너책자최소수량안내-짝수": "* [Toner] MOQ: {MIN_CNT} books. Can be ordered in an incremental of 2 books",
      내지업로드사이즈장수안내: "<b>* {CUT_SIZE} Book: Upload 1 PDF File in <span class='bold red'>{WRK_SIZE}</span> (Bleed Size) containing <span class='bold red'>{QTY}</span>pages</b>",
      표지업로드장수안내: "<b>* Download Cover Template and upload <span class='bold red'>{QTY}</span> Page PDF file</b>",
      내지장수안내: "* Please upload <b>{QTY}</b> page PDF",
      내지최대장수안내: "* Inner Pages : Max <b>{MAX_CNT}</b>sheets",
      내지: "Inner Page",
      표지: "Cover Page",
      표지가이드: "Cover Guide",
      제본방향: "Binding",
      표지작업사이즈: "Cover Working Size",
      표지템플릿다운로드: "Cover Template Download",
      세네카: "Spine",
      낱장커버: "Jacket (Front/Back)",
      소프트커버: "Softcover (Outer)",
      트윈링제본: "Ring binding",
      내지장수: "Inner Page Count",
      "표지(합지)": "Hardcover",
      표지합지: "Hardcover",
      "PVC 추가커버": "PVC Additional Cover",
      "날개 커버": "Dust Jacket",
      무료디자인편집: "Use Free Templates",
      자세히보기: "View more",
      선택하기: "Select",
      옵션: "Option",
      브라운: "Brown",
      블랙: "Black",
      블루: "Blue",
      옐로우: "Yellow",
      그린: "Green",
      레드: "Red",
      그레이: "Grey",
      "불박 후가공": "Debossing",
      세로형: "Portrait",
      가로형: "Landscape",
      "불박 안함": "No Debossed Imprint",
      애플: "Apple",
      삼성: "Samsung",
      옵션선택: "Add Selected",
      패턴: "Pattern",
      종류: "Type",
      "S-300": "Shiny S-300(3mm font)",
      "S-400": "Shiny S-400(4mm font)",
      옵션미선택안내: "Please select an option",
      옵션미선택안내상세: "Please select an option [{OPTION}]",
      템플릿다운로드실패: "Template download failed. Please try again or contact customer support.",
      세네카오류: "The book spine is not set. Please try again or contact customer support.",
      주문불가상태: "This item is currently unavailable for order. We apologize for the inconvenience.",
      "주문불가-파일": "Please upload the file.",
      "주문불가-파일명중복": "The interior and cover files have the same name. Please upload files with different names.",
      "주문불가-에디터": "Please create the file in the editor.",
      "주문불가-옵션미선택": "No option selected. Please select an option to continue.",
      "주문불가-가격": "An error occurred while calculating the price. Please try again or contact customer support.",
      "주문불가-인쇄컬러미선택": "Please select a print color(Pantone).",
      "주문불가-사이즈": `Size entered cannot be produced.
Please check minimum/maximum limits.`,
      "오늘출발-불가능": "* Selected specification is not available for Same-Day delivery.<br /> View 'See Options' to check eligibility.",
      "내일출발-불가능": "* Selected specification is not available for Next-Day delivery.<br /> View 'See Options' to check eligibility.",
      "스티커용지-주의사항": "* Situations whereby PE, BOX, plastic containing agent, embossed, coated small box, short diameter roll, wood, stone surface, harness, non-woven fabric, attached to non-flat surfaces are placed in the refrigerator, might fall off.",
      인쇄함: "Printing",
      인쇄안함: "Blank",
      인풋카드: "Insert Card"
    },
    HT = {
      주문서작성: "주문서 작성",
      가로: "가로",
      세로: "세로",
      용지: "용지",
      자재: "자재",
      액자: "액자",
      모양: "모양",
      제작방식: "제작방식",
      주문가능용지: "주문 가능 용지",
      주문가능자재: "주문 가능 자재",
      인쇄데이터: "인쇄 데이터",
      브랜드: "브랜드",
      제조사: "제조사",
      기종: "기종",
      케이스종류: "케이스 종류",
      자재종류: "자재 종류",
      두께: "두께",
      규격: "규격",
      "규격-단위": "규격 (mm)",
      규격가이드: "가이드 보기",
      재단사이즈: "재단 사이즈",
      작업사이즈: "작업 사이즈",
      사이즈직접입력: "사이즈 직접 입력",
      사이즈: "사이즈",
      사이즈별수량: "사이즈별 수량",
      인쇄도수: "인쇄 옵션",
      양면: "양면",
      단면: "단면",
      후가공: "후가공 선택",
      부자재선택: "부자재 선택",
      자동화이트: "자동 화이트",
      수동화이트: "내 파일로 화이트 데이터 업로드(PDF)",
      디자인수: "디자인 수 (건수)",
      디자인별수량: "수량",
      수량: "수량",
      세트별수량: "수량",
      세트: "세트",
      총수량: "총 수량",
      주문수량안내: "* 총 주문 수량은 <span class='bold red'>{QTY}</span>입니다",
      개: "개",
      건: "건",
      단위주문수량안내: "* {QTY}개 단위로 주문 가능한 제품입니다.",
      PDF장수안내: "{QTY}페이지 PDF를 업로드해 주십시오.",
      세트수량안내: "에디터로 만들기를 종료하면, 선택한 종류의 수와 수량이 표기됩니다.",
      디자인건수안내: "* 디자인 종류 <span class='bold red'>{QTY}건</span>",
      "디자인건수가능여부-전체": "PDF로 주문 또는 에디터 내에서 건수 추가가 가능합니다.",
      "디자인건수가능여부-에디터": "에디터 내에서 건수 추가가 가능합니다.",
      직접입력: "직접 입력하기",
      수량선택: "수량 옵션보기",
      조립: "조립",
      미조립: "미조립",
      파일업로드: "파일 업로드",
      내지업로드: "내지 업로드",
      표지업로드: "표지 업로드",
      "파일업로드-MS": "MS-OFFICE 계열에서 만든 PDF는 주문, 제작이 원활하지 않을 수 있습니다.",
      파일업로드레이어안내: "1개의 PDF파일(*.PDF)만 업로드 가능",
      "pdf-only": "내 파일로 업로드 PDF ONLY",
      주문제목: "주문제목",
      에디터: "에디터",
      편집하기: "편집하기",
      재편집하기: "재편집하기",
      템플릿다운로드: "템플릿 다운로드",
      인쇄비: "인쇄비",
      후가공비: "후가공비",
      합계: "합계",
      부가세: "부가세",
      청구금액: "청구금액",
      할인: "할인",
      개당: "개당",
      원: "Won",
      상세내역: "Summary",
      "summary.인쇄방식": "인쇄방식",
      "summary.재단": "재단 size",
      "summary.작업": "작업 size",
      "summary.디자인수": "디자인 수",
      "summary.세트": "세트",
      "summary.수량": "수량",
      "summary.개당": "개당",
      "summary.청구금액": "청구금액",
      "summary.예상무게": "예상무게(kg)",
      "summary.예상박스": "예상 박스",
      "summary.배송비": "배송비",
      "summary.공급가": "공급가",
      "summary.부가세": "부가세",
      가이드보기: "가이드 보기",
      주문불가: "주문 불가",
      "의류.단면": "인쇄 있음",
      "의류.인쇄없음": "인쇄 없음",
      장: "장",
      의류주문가능수량: "* <b>{QTY}</b> 장부터 주문 가능합니다.",
      선택: "선택",
      "인쇄 컬러(팬톤)": "인쇄 컬러(팬톤)",
      "팬톤 컬러": "팬톤 컬러",
      "1종 선택 가능": "1종 선택 가능",
      "팬톤 컬러 선택하기": "팬톤 컬러 선택하기",
      "팬톤 컬러 선택": "팬톤 컬러 선택",
      "넘버 입력": "넘버 입력",
      "의류 컬러": "의류 컬러",
      "인쇄 영역": "인쇄 영역",
      인쇄: "인쇄",
      의류인쇄영역가이드: "* <b>좌측가슴, 앞면 인쇄만</b> 함께 선택이 불가하며, 다른 영역은 중복 선택이 가능합니다.",
      "의류인쇄영역가이드-직접인쇄": "* <b>{areas}</b>은 열전사로 제작됩니다.",
      "의류인쇄영역가이드-실크인쇄": "* 영역별 기본 인쇄판비용이 추가됩니다 (가슴, 팔, 목 : 5만원ㅣ앞면, 뒷면 : 7만원)",
      팬톤검색문구: "* 찾으시는 팬톤 컬러명을 검색하세요",
      팬톤검색안내: "좌측 컬러 칩은 화면상 보여지는 RGB 컬러로 실제 팬톤 컬러와 색상 차이가 있을 수 있습니다. 팬톤 컬러를 선택하거나, 원하는 컬러가 없는 경우 팬톤 컬러 넘버를 직접 입력해 주세요.",
      팬톤검색실패문구: "제공된 스와치에 없는 색상입니다.<br>스와치 내에서 색상을 선택해 주세요.<br>그 외 색상 주문을 원할 경우 주문 후,<br>1:1상담을 통해 요청해 주세요.",
      적용하기: "적용하기",
      퀵오더불가: "* 퀵오더 불가 : 일본 수입 제품으로, 약 3-4주 제작 소요일이 예상됩니다.",
      adult: "성인용",
      child: "아동용",
      "개별 포장": "개별 포장",
      선택안함: "선택안함",
      선택함: "선택함",
      업로드파일삭제메시지: `업로드된 파일을 삭제합니다. 
계속 진행하시겠습니까?`,
      파일형식에러메시지: "해당 파일 형식은 지원하지 않습니다. 지원 파일 형식: {ext}",
      파일사이즈에러메시지: "허용 파일 사이즈(1GB)를 초과했습니다.",
      컬러: "컬러",
      달력시작: "시작 년도/월",
      달력시작설명: "* 선택하신 달 부터 12달 달력이 제공됩니다.",
      달력디자인수설명: "기본 13장이며, 링 사이즈로 인해 최대 {MAX_CNT}장 까지 주문 가능",
      최소단위수량안내: "{MIN_QTY}개 이상, {UNIT_QTY} 수량으로 주문 가능합니다.",
      짝수: "짝수",
      홀수: "홀수",
      연도: "년",
      "1월": "1월",
      "2월": "2월",
      "3월": "3월",
      "4월": "4월",
      "5월": "5월",
      "6월": "6월",
      "7월": "7월",
      "8월": "8월",
      "9월": "9월",
      "10월": "10월",
      "11월": "11월",
      "12월": "12월",
      윤전책자최소수량안내: "* 윤전 인쇄 책자로 <b>{MIN_CNT}</b> 권 부터 제작 가능합니다",
      토너책자최소수량안내: "* 토너/잉크젯 인쇄 책자로 <b>{MIN_CNT}</b> 권 부터 제작합니다",
      "토너책자최소수량안내-짝수": "* 토너/잉크젯 인쇄 책자로 <b>{MIN_CNT}</b> 권 부터 짝수 수량으로 제작합니다",
      내지업로드사이즈장수안내: "<b>* {CUT_SIZE} 책자: <span class='bold red'>{WRK_SIZE}</span> 사이즈의 <span class='bold red'>{QTY}</span> 페이지 PDF 파일 1개를 준비해 업로드해 주세요</b>",
      표지업로드장수안내: "<b>* 표지 템플릿을 다운받은 후 <span class='bold red'>{QTY}</span> 페이지 PDF 파일을 업로드해 주세요</b>",
      내지장수안내: "* 총 <b>{QTY}</b>페이지",
      내지최대장수안내: "* 내지 장수: 최대 수량 <b>{MAX_CNT}</b>장",
      내지: "내지",
      표지: "표지",
      표지가이드: "표지 가이드",
      제본방향: "제본방향",
      표지작업사이즈: "표지 작업 사이즈",
      표지템플릿다운로드: "표지 템플릿 다운로드",
      세네카: "세네카(책등)",
      낱장커버: "낱장 커버(앞/뒤)",
      소프트커버: "소프트 커버(겉면)",
      트윈링제본: "트윈링제본",
      내지장수: "내지장수",
      "표지(합지)": "표지(합지)",
      표지합지: "표지합지",
      "PVC 추가커버": "PVC 추가커버",
      "날개 커버": "날개 커버",
      무료디자인편집: "무료 디자인으로 편집하기",
      자세히보기: "자세히 보기",
      선택하기: "선택해 주세요",
      옵션: "옵션",
      브라운: "브라운",
      블랙: "블랙",
      블루: "블루",
      옐로우: "옐로우",
      그린: "그린",
      레드: "레드",
      그레이: "그레이",
      "불박 후가공": "불박 후가공",
      세로형: "세로형",
      가로형: "가로형",
      "불박 안함": "불박 안함",
      애플: "애플",
      삼성: "삼성",
      옵션선택: "위 옵션대로 선택",
      패턴: "패턴",
      종류: "종류",
      "S-300": "샤이니 S-300(글자 3mm)",
      "S-400": "샤이니 S-400(글자 4mm)",
      옵션미선택안내: "옵션을 선택해 주세요",
      옵션미선택안내상세: "{OPTION} 옵션을 선택해 주세요",
      템플릿다운로드실패: "템플릿 다운로드 중 오류가 발생했습니다. 문제가 지속될 경우 고객센터에 문의해 주세요.",
      세네카오류: "세네카(책등) 설정이 되지 않았습니다. 문제가 지속될 경우 고객센터에 문의해 주세요.",
      주문불가상태: "일시적으로 주문이 불가합니다. 이용에 불편을 드려 죄송합니다.",
      "주문불가-파일": "PDF 파일을 업로드해 주세요.",
      "주문불가-파일명중복": "내지, 표지 파일명이 같습니다. 서로 다른 파일명으로 업로드해 주세요.",
      "주문불가-에디터": "에디터 편집을 완료해 주세요.",
      "주문불가-옵션미선택": "선택된 옵션이 없습니다. 주문할 옵션을 선택해 주세요.",
      "주문불가-가격": "가격 산정 시 오류가 발생했습니다. 문제가 지속될 경우 고객센터에 문의해 주세요.",
      "주문불가-인쇄컬러미선택": "인쇄 컬러(팬톤)를 선택해 주세요.",
      "주문불가-사이즈": `주문 가능 사이즈 범위를 벗어났습니다.
규격(사이즈)을 다시 확인해 주세요.`,
      "오늘출발-불가능": "* 선택한 옵션은 오늘출발 서비스 적용이 불가합니다.<br /> 가능 조건은 하단 ‘오늘출발-옵션 배너’에서 확인해 주세요.",
      "내일출발-불가능": "* 선택한 옵션은 내일출발 서비스 적용이 불가합니다.<br /> 가능 조건은 하단 ‘내일출발-옵션 배너’에서 확인해 주세요.",
      "스티커용지-주의사항": "* PE, BOX, 가소제 성분이 들어간 플라스틱, 엠보, 코팅된 소형박스, 직경이 작아 말아붙인 것, 나무, 돌표면, 마대, 부직포, 평평하지 않은 표면에 부착하거나 부착 후 냉장고(냉동고)에 넣을 경우 떨어질 수 있습니다.",
      인쇄함: "인쇄 함",
      인쇄안함: "인쇄 안함",
      인풋카드: "인풋 카드"
    },
    Dt = bs("config", () => {
      const e = H("ko");

      function t(n) {
        e.value = n
      }
      return {
        locale: e,
        setLocale: t
      }
    }),
    x = (e, t) => {
      const {
        locale: n
      } = t0(Dt()), s = (n.value === "ko" ? HT : VT)[e] || e;
      if (!t) return s;
      let r = s;
      return Object.entries(t).forEach(([a, i]) => {
        r = r.replace(`{${a}}`, i)
      }), r
    },
    GT = re({
      __name: "Skeleton",
      props: {
        variant: {},
        width: {},
        height: {}
      },
      setup(e) {
        const t = e,
          n = R(() => t.width ? `${t.width}px` : "auto"),
          o = R(() => t.height ? `${t.height}px` : "auto");
        return (s, r) => s.variant === "circular" ? (g(), M("div", {
          key: 0,
          class: we(["skeleton-item", "circular"]),
          style: Qt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : s.variant === "rectangular" ? (g(), M("div", {
          key: 1,
          class: we(["skeleton-item", "rectangular"]),
          style: Qt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : s.variant === "rounded" ? (g(), M("div", {
          key: 2,
          class: we(["skeleton-item", "rounded"]),
          style: Qt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : oe("", !0)
      }
    }),
    Be = (e, t) => {
      const n = e.__vccOpts || e;
      for (const [o, s] of t) n[o] = s;
      return n
    },
    Ne = Be(GT, [
      ["__scopeId", "data-v-e3562e90"]
    ]),
    jT = {
      key: 0,
      class: "skeleton"
    },
    zT = {
      class: "row"
    },
    YT = {
      class: "row"
    },
    KT = {
      class: "row"
    },
    WT = {
      key: 1,
      class: "skeleton"
    },
    qT = {
      class: "row"
    },
    QT = {
      class: "row"
    },
    XT = {
      class: "radio"
    },
    JT = {
      class: "row"
    },
    ZT = {
      class: "row"
    },
    e1 = {
      class: "radio"
    },
    t1 = {
      class: "row"
    },
    n1 = {
      class: "row"
    },
    o1 = {
      class: "radio"
    },
    s1 = {
      class: "row"
    },
    r1 = {
      class: "row"
    },
    i1 = {
      class: "radio"
    },
    a1 = {
      class: "row"
    },
    l1 = {
      class: "row"
    },
    u1 = {
      class: "radio"
    },
    j_ = Be(re({
      __name: "SkeletonGroup",
      props: {
        group: {}
      },
      setup(e) {
        return (t, n) => t.group === "vSubMtrl_item" ? (g(), M("div", jT, [S("div", zT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", YT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", KT, [K(Ne, {
          variant: "rounded",
          height: 40
        })])])) : (g(), M("div", WT, [S("div", qT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", QT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), S("div", XT, [K(Ne, {
          variant: "rounded",
          height: 49
        }), K(Ne, {
          variant: "rounded",
          height: 49
        })])]), S("div", JT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", ZT, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), S("div", e1, [K(Ne, {
          variant: "rounded",
          height: 49
        }), K(Ne, {
          variant: "rounded",
          height: 49
        })])]), S("div", t1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", n1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), S("div", o1, [K(Ne, {
          variant: "rounded",
          height: 49
        }), K(Ne, {
          variant: "rounded",
          height: 49
        })])]), S("div", s1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", r1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), S("div", i1, [K(Ne, {
          variant: "rounded",
          height: 49
        }), K(Ne, {
          variant: "rounded",
          height: 49
        })])]), S("div", a1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), K(Ne, {
          variant: "rounded",
          height: 40
        })]), S("div", l1, [K(Ne, {
          variant: "rounded",
          width: 50,
          height: 20
        }), S("div", u1, [K(Ne, {
          variant: "rounded",
          height: 49
        }), K(Ne, {
          variant: "rounded",
          height: 49
        })])])]))
      }
    }), [
      ["__scopeId", "data-v-096103a5"]
    ]),
    Ms = bs("product", () => {
      const e = H();

      function t() {
        return De(e.value)
      }

      function n(o) {
        e.value = o
      }
      return {
        baseInfo: e,
        getProductBaseInfo: t,
        setProductBaseInfo: n
      }
    });

  function c1() {
    return {
      isDev: R(() => ["dev", "int"].includes("prod"))
    }
  }
  const Ve = bs("exterior", () => {
      const e = xe({
        default: "editor"
      });

      function t(i, l) {
        e[l || "default"] = i
      }
      const n = xe({
          default: null
        }),
        o = (i, l) => {
          n[l || "default"] = i
        },
        s = xe({
          default: null
        }),
        r = (i, l) => {
          s[l || "default"] = i
        };
      return F(() => n, i => {
        c1().isDev.value && console.log("[RedWidgetSDK] 에디터 편집 정보 업데이트 >", i)
      }, {
        deep: !0
      }), {
        uploadType: e,
        setUploadType: t,
        editorData: n,
        setEditorData: o,
        isAfterEdit: i => n[i || "default"] ? e[i || "default"] === "editor" && n[i || "default"].editingYn === "Y" : !1,
        payloadForEditorConfig: s,
        setPayloadForEditorConfig: r
      }
    }),
    zr = bs("order", () => {
      const e = H(),
        t = le("callbacks", {});

      function n() {
        return De(e.value)
      }

      function o(s, r) {
        e.value = s, t?.onOptionChange && t.onOptionChange({
          type: "COMMON",
          data: s,
          summary: r
        })
      }
      return {
        orderData: e,
        getOrderData: n,
        setOrderData: o
      }
    }),
    Ml = bs("acc-order", () => {
      const e = H(),
        t = le("callbacks", {});

      function n() {
        return De(e.value)
      }

      function o(s) {
        e.value = s, t?.onOptionChange && t.onOptionChange({
          type: "ACC",
          data: s
        })
      }
      return {
        orderData: e,
        getOrderData: n,
        setOrderData: o
      }
    }),
    kl = {
      GSPNJLY: "TotalQty",
      GSPNBAL: "SetQty",
      GSPNDFT: "SetQty",
      STDRCAD: "SimpleQty",
      STTBDFT: "SimpleQty",
      TPCAPTW: "SimpleQty"
    },
    d1 = new Set(["GSPNJLY", "GSPNBAL", "GSPNCLP", "GSPNDFT", "GSPNFLT", "GSTTCRK", "GSCAEPB", "GSCAGBP", "GSCAGBM", "GSCAGBR", "GSCAGBH", "GSCATPP", "GSCATPG", "GSCATCP", "GSCACDP", "GSCAPHN", "GSWLMAG", "GSCATIN", "GSKYHOT", "GSHDMGT", "GSTGMIC", "GSCAPDF", "GSCACAP", "PHFRDIA", "GSSKSHH", "GSFBSTK"]),
    f1 = new Set(["GSCAEPB", "GSCAGBP", "GSCAGBM", "GSCAGBR", "GSCAGBH", "GSCATPP", "GSCATPG", "GSCATCP", "GSCACDP", "GSCAPHN", "GSWLMAG"]),
    Ll = {
      GSPNJLY: !0,
      GSPNBAL: !0,
      GSPNDFT: !0
    },
    p1 = {
      TPCLWLB: !0,
      TPCLSTD: !0,
      PRCLSTD: !0,
      PRCLHOL: !0,
      PRCLWAL: !0,
      TPCLHOL: !0,
      TPCLWAL: !0,
      TPCLECO: !0
    },
    z_ = new Set(["PRCLSTD", "PRCLHOL", "PRCLWAL"]),
    $l = new Set(["GSBKLAP", "GSBKBCH", "GSTTDTM", "GSFBPHP", "GSFBSTK"]),
    xl = {
      GSGLPWT: "SUB_MTR",
      GSBKLAP: "DIR_MTR",
      GSBKBCH: "DIR_MTR",
      GSTTDTM: "DIR_MTR",
      PHMGDFT: "SUB_MTR",
      GSFBPHP: "DIR_MTR",
      GSTGMIC: "WRK_MTR",
      GSNTMIS: "SUB_MTR",
      GSFBSTK: "DIR_MTR"
    },
    Fl = {
      GSCATIN: {
        SXTNC010: "Y",
        SXTNC014: "Y"
      }
    },
    _1 = new Set(["ACTHPAM", "ACTHPAA", "ACTHPEN", "ACTHCKY"]),
    h1 = {
      GSCACAP: 3
    },
    m1 = ["SST_DFT", "BON_PAP"],
    v1 = new Set(["TPCLECO", "TPCLWLB", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLHOL", "PRCLWAL", "TPCLSTD", "TPCLSTD", "TPCLSTD", "TPCLSTD", "TPCLHOL", "TPCLWAL"]),
    Yr = {
      GSCDPOP: {
        factor: "size",
        value: {
          1: "3",
          2: "6"
        }
      }
    };

  function g1(e, t) {
    const {
      pdtCode: n,
      option: o,
      editorData: s
    } = t, r = o.skinInfo, a = o.item_gbn, i = r?.sizeSelect.view_yn === "Y" ? e.sizeInfo.cutSize : null, l = r?.sizeSelect.view_yn === "Y" ? e.sizeInfo.workSize : null, c = i ? `${+i.width.toFixed(2)}x${+i.height.toFixed(2)}` : null, u = l ? `${+l.width.toFixed(2)}x${+l.height.toFixed(2)}` : null, d = {
      ...c ? {
        cutSize: {
          value: c,
          label: x("summary.재단")
        }
      } : {},
      ...u ? {
        workSize: {
          value: u,
          label: x("summary.작업")
        }
      } : {}
    }, h = s.default?.cntInfo, f = kl[n] === "SetQty" ? (h?.totalCnt || 1) / (h?.initCnt || 1) : null, _ = a === "book2025_item" ? null : e.quantityInfo.ordCnt, p = a === "book2025_item" ? e.quantityInfo.ordCnt : e.quantityInfo.prnCnt, m = {
      ...f ? {
        setQty: {
          value: f,
          label: x("summary.세트")
        }
      } : _ ? {
        designQty: {
          value: _,
          label: x("summary.디자인수")
        }
      } : {},
      orderQty: {
        value: p,
        label: x("summary.수량")
      }
    }, {
      result_sum: v,
      book_info: E
    } = e.priceCalc.result, {
      ORG_PRICE: k,
      ORG_PRICE_VAT: N,
      PRICE: D,
      PRICE_VAT: O,
      PRICE_MALL: A,
      PRICE_MALL_VAT: b
    } = v, C = D !== A, y = k !== D, I = C ? A + b : y ? D + O : k + N, w = Ll[n] || p1[n] ? p : (p || 1) * (_ || 1), U = Math.round(I / w), Z = {
      vat: {
        value: C ? b : y ? O : N,
        label: x("summary.부가세")
      },
      unitPrice: {
        value: U,
        label: x("summary.개당")
      },
      price: {
        value: C ? A : y ? D : k,
        label: x("summary.공급가")
      },
      totalPrice: {
        value: I,
        label: x("summary.청구금액")
      }
    };
    if (e.acrylicSelectData) {
      const me = e.acrylicSelectData.productionMethod?.COD_NME;
      return {
        ...me ? {
          method: {
            value: me,
            label: x("summary.인쇄방식")
          }
        } : {},
        ...d,
        ...m,
        ...Z
      }
    }
    if (a === "book2025_item") {
      const me = E ? {
        weight: {
          value: E.PDT_WGT,
          label: x("summary.예상무게")
        },
        boxQty: {
          value: E.BOX_CNT,
          label: x("summary.예상박스")
        },
        shipping: {
          value: E.DLVR_AMT,
          label: x("summary.배송비")
        }
      } : null;
      return {
        ...m,
        ...Z,
        ...me
      }
    }
    return {
      ...d,
      ...m,
      ...Z
    }
  }
  const y1 = {
      class: "widget-container"
    },
    C1 = {
      key: 0,
      class: "widget-body"
    },
    T1 = re({
      __name: "Common",
      setup(e) {
        const t = Dt(),
          n = le("productCode", {
            pdtCode: ""
          }),
          {
            data: o,
            isFetchedAfterMount: s
          } = Rp({
            queryKey: ["product/get", n.pttCode ? `${n.pdtCode}/${n.pttCode}` : n.pdtCode],
            queryFn: () => G_(t.locale, n.pdtCode, n.pttCode),
            enabled: R(() => !!n?.pdtCode),
            refetchOnWindowFocus: !1
          }),
          {
            data: r,
            mutate: a
          } = wp({
            mutationKey: ["price/get"],
            mutationFn: O => Al({
              type: "COMMON",
              body: O
            })
          }),
          i = le("callbacks", {}),
          l = R(() => o.value?.result?.product_option.option),
          c = R(() => l.value?.item_gbn),
          u = {
            component: kn(() => Promise.resolve().then(() => SS)),
            className: "widget"
          },
          d = {
            vDigital_item: u,
            acrylic2025_item: {
              component: kn(() => Promise.resolve().then(() => QS)),
              className: "widget"
            },
            clothes2025_item: {
              component: kn(() => Promise.resolve().then(() => hP)),
              className: "clothes-color"
            },
            book2025_item: {
              component: kn(() => Promise.resolve().then(() => qP)),
              className: ""
            }
          },
          h = H(),
          f = R(() => l.value?.price_gbn || "tmpl_price"),
          _ = le("member"),
          p = H({
            ORD_INFO: [],
            PCS_INFO: [],
            price_gbn: f.value,
            mb_cust_cod: _?.mb_cust_cod || "10000000"
          });

        function m(O) {
          const A = [];
          O.pcsInfo && Object.values(O.pcsInfo).forEach(C => {
            C.selectedOptions.forEach(y => {
              A.push({
                PCS_COD: y.PCS_CD,
                PCS_DTL_COD: y.PCS_DTL_CD,
                ATTB: y.ATTB,
                ATTB_2: y.ATTB_2,
                ATTB_3: y.ATTB_3
              })
            })
          });
          const b = c.value === "book2025_item" ? [{
            PDT_CD: n.pdtCode,
            CUT_WDT: O.sizeInfo?.cutSize?.width,
            CUT_HGH: O.sizeInfo?.cutSize?.height,
            WRK_WDT: O.sizeInfo?.workSize?.width,
            WRK_HGH: O.sizeInfo?.workSize?.height,
            PRN_CNT: O.quantityInfo?.ordCnt,
            PAGE_CNT: O.quantityInfo?.prnCnt,
            CVR_CLR_CNT: O.dosuInfo?.PRN_CLR_CNT,
            INN_CLR_CNT: O.inner_dosuInfo?.PRN_CLR_CNT,
            CVR_MTRL_CD: O.meterialInfo?.MTRL_CD,
            INN_MTRL_CD: O.inner_meterialInfo?.MTRL_CD
          }] : [{
            PDT_CD: n.pdtCode,
            MTRL_CD: O.meterialInfo?.MTRL_CD,
            CUT_WDT: O.sizeInfo?.cutSize?.width,
            CUT_HGH: O.sizeInfo?.cutSize?.height,
            WRK_WDT: O.sizeInfo?.workSize?.width,
            WRK_HGH: O.sizeInfo?.workSize?.height,
            PRN_CNT: O.quantityInfo?.prnCnt,
            ORD_CNT: O.quantityInfo?.ordCnt,
            DOSU_COD: O.dosuInfo?.COD,
            PRN_CLR_CNT: O.dosuInfo?.PRN_CLR_CNT,
            ...c.value === "clothes2025_item" ? {
              PRINT_TYPE: O.clothesSelectData.printType?.COD
            } : {}
          }];
          p.value = {
            ORD_INFO: b,
            PCS_INFO: A,
            price_gbn: f.value,
            mb_cust_cod: _?.mb_cust_cod || "10000000"
          }
        }
        const v = Ve();

        function E(O) {
          if (!o.value?.result) return;
          const {
            sizeInfo: A,
            pcsInfo: b,
            meterialInfo: C,
            dosuInfo: y,
            quantityInfo: I,
            clothesSelectData: w,
            calendarInfo: U,
            acrylicSelectData: Z,
            priceCalc: me
          } = O, {
            pdt_base_info: _e,
            pdt_mtrl_info: B,
            pdt_pcs_info: W
          } = o.value.result.product_data, ue = {
            lang_cod: t.locale,
            pdt_cod: n.pdtCode,
            PDT_NM: _e[0].PDT_NM,
            sizeInfo: A,
            pcsInfo: b,
            meterialInfo: C,
            dosuInfo: y,
            quantityInfo: I,
            clothesSelectData: w,
            calendarInfo: U,
            acrylicSelectData: Z,
            base: {
              item_gbn: c.value || "",
              koi_template_resource_id: l.value?.koi_template_resource_id || "",
              pdt_mtrl_info: c.value === "clothes2025_item" ? [...B] : [],
              pdt_pcs_info: c.value === "clothes2025_item" ? [...W] : []
            },
            seneca_info: me?.result.seneca_info
          };
          v.setPayloadForEditorConfig(ue)
        }

        function k(O) {
          h.value = O, m(O)
        }
        F(() => p.value, un(O => {
          cn(O) || a(O)
        }, 200));
        const N = zr();
        F(() => r.value, O => {
          if (h.value && O?.result) {
            const A = {
                ...h.value,
                priceCalc: {
                  params: p.value,
                  result: O.result
                }
              },
              b = l.value ? {
                pdtCode: n.pdtCode,
                option: l.value,
                editorData: v.editorData
              } : null,
              C = b ? g1(A, b) : null;
            N.setOrderData(A, C), i?.onPriceChange && i.onPriceChange(O.result.result_sum), E(A)
          }
        });
        const D = Ms();
        return F(() => o.value, O => {
          O?.result && D.setProductBaseInfo(O.result)
        }), F(() => s.value, O => {
          if (O && !(typeof i.onMounted > "u")) return o.value?.errorMessage && typeof i.onError < "u" ? (i.onError(o.value.errorMessage), i.onMounted(!1)) : i.onMounted(!0)
        }), (O, A) => (g(), M("div", y1, [T(s) && c.value ? (g(), M("div", C1, [(g(), V(ns(d[c.value]?.component || u.component), {
          data: T(o)?.result?.product_data,
          "widget-attr": l.value,
          "seneca-info": T(r)?.result?.seneca_info,
          onUpdate: k
        }, null, 40, ["data", "widget-attr", "seneca-info"]))])) : (g(), V(j_, {
          key: 1,
          group: c.value
        }, null, 8, ["group"]))]))
      }
    }),
    b1 = {
      class: "widget-container"
    },
    S1 = {
      key: 0,
      class: "widget-body acc"
    },
    D1 = re({
      __name: "Acc",
      setup(e) {
        const t = Dt(),
          n = le("productCode", {
            pdtCode: ""
          }),
          {
            data: o,
            isFetchedAfterMount: s
          } = Rp({
            queryKey: ["product/get", n.pttCode ? `${n.pdtCode}/${n.pttCode}` : n.pdtCode],
            queryFn: () => G_(t.locale, n.pdtCode, n.pttCode),
            enabled: R(() => !!n?.pdtCode),
            refetchOnWindowFocus: !1
          }),
          {
            data: r,
            mutate: a
          } = wp({
            mutationKey: ["price/get"],
            mutationFn: v => Al({
              type: "ACC",
              body: v
            })
          }),
          i = le("callbacks", {}),
          l = R(() => o.value?.result?.product_option.option),
          c = H(),
          u = R(() => l.value?.price_gbn || "tmpl_price"),
          d = le("member"),
          h = H({
            ORD_INFO: [],
            PCS_INFO: [],
            price_gbn: u.value,
            mb_cust_cod: d?.mb_cust_cod || "10000000",
            mb_id: d?.mb_id
          });

        function f(v) {
          h.value = {
            ORD_INFO: [{
              PDT_CD: n.pdtCode,
              TMPL_NUM: n.pttCode
            }],
            PCS_INFO: v,
            price_gbn: u.value,
            mb_cust_cod: d?.mb_cust_cod || "10000000"
          }
        }

        function _(v) {
          c.value = v, f(v)
        }
        F(() => h.value, v => {
          cn(v) || a(v)
        });
        const p = Ml();
        F(() => r.value, v => {
          if (c.value && v?.result) {
            const E = {
              subMtrlInfo: c.value,
              priceCalc: {
                params: h.value,
                result: v.result
              }
            };
            p.setOrderData(E), i?.onPriceChange && i.onPriceChange(v.result.result_sum)
          }
        });
        const m = Ms();
        return F(() => o.value, v => {
          v?.result && m.setProductBaseInfo(v.result)
        }), (v, E) => (g(), M("div", b1, [T(s) ? (g(), M("div", S1, [T(o)?.result?.product_data.pdt_sub_mtrl_info ? (g(), V(ns(kn(() => Promise.resolve().then(() => uE))), {
          key: 0,
          data: T(o)?.result?.product_data.pdt_sub_mtrl_info,
          onUpdate: _
        }, null, 40, ["data"])) : oe("", !0)])) : (g(), V(j_, {
          key: 1,
          group: "vSubMtrl_item"
        }))]))
      }
    });

  function P1(e) {
    const {
      pdtCode: t,
      docInfo: n
    } = e, o = n.pageInfos[0], {
      renderBound_mm: s,
      renderBounds: r,
      size_mm: a,
      postWorkBound_mm: i
    } = o, l = s || (r && r.length >= 1 ? r[0].rect_mm : a), c = {
      width: +l.width.toFixed(2),
      height: +l.height.toFixed(2)
    };
    if (!c) return;
    let u;
    return ["ACTHDCO", "ACTHFCO", "ACTHBCO"].includes(t) && (u = i || {
      width: c.width - 2,
      height: c.height - 2
    }), {
      workSize: c,
      ...u ? {
        cutSize: u
      } : {}
    }
  }
  const Y_ = {
    GSPNJLY: 1,
    GSPNBAL: 2,
    GSPNDFT: 6,
    GSBLGLF: 3
  };

  function E1(e) {
    const {
      pdtCode: t,
      docInfo: n
    } = e;
    if (Y_[t]) {
      const o = Y_[t],
        s = n.contentPageCount * o,
        r = n.pageGroup.groups.length * o,
        a = n.contentPageCount * o;
      return {
        quantityInfo: {
          ordCnt: r,
          prnCnt: a
        },
        cntInfo: {
          initCnt: o,
          totalCnt: s
        }
      }
    }
    if (n.pageGroup) return {
      quantityInfo: {
        ordCnt: n.totalPageCount,
        prnCnt: 1
      }
    }
  }
  const O1 = ["ACTHFCO"];

  function I1(e) {
    if (!O1.includes(e.pdtCode)) return;
    const {
      pageInfos: t
    } = e.docInfo, n = t[0].whiteInfo, o = t[1].whiteInfo, s = n ? n.whiteTotalCount - n.whiteOffCount > 0 : !1, r = o ? o.whiteTotalCount - o.whiteOffCount > 0 : !1;
    return {
      PRT_WHT: {
        front: s,
        back: r
      }
    }
  }

  function R1(e) {
    if (e.docInfo.calendarInfo) return {
      calendarInfo: e.docInfo.calendarInfo
    }
  }
  const w1 = ["GSBGRDY"];

  function A1(e, t) {
    const {
      projectID: n,
      customTabSelectedInfo: o
    } = e;
    if (!n) return null;
    const s = t?.product_option.option.item_gbn,
      r = s === "book2025_item" ? null : P1(e),
      a = E1(e),
      i = I1(e),
      l = R1(e),
      c = w1.includes(e.pdtCode);
    return {
      projectID: n,
      editingYn: "Y",
      ...c ? {} : {
        ...r,
        ...a,
        ...i,
        ...s === "clothes2025_item" ? {
          editorClothesInfo: o
        } : {},
        ...l
      }
    }
  }

  function N1(e) {
    const {
      _id: t,
      fileInfo: n
    } = e;
    return t ? {
      projectID: t,
      editingYn: "Y",
      quantityInfo: {
        ordCnt: n.bundle_count
      }
    } : null
  }
  const M1 = new Set(["GSSBMTL", "GSSBSTP", "GSSBACM"]),
    K_ = {
      GSSBMTL: {
        37: {
          uiType: "CASCADE",
          filters: [{
            GRP_TYPE: "MTRL_GRP",
            GRP_NME: "컬러",
            options: [{
              COD: "SMT_BRW",
              COD_NME: "브라운"
            }, {
              COD: "SMT_BLK",
              COD_NME: "블랙"
            }, {
              COD: "SMT_BLU",
              COD_NME: "블루"
            }, {
              COD: "SMT_YEL",
              COD_NME: "옐로우"
            }, {
              COD: "SMT_GRE",
              COD_NME: "그린"
            }]
          }, {
            GRP_TYPE: "MTRL_SUB_GRP",
            GRP_NME: "불박 후가공",
            options: [{
              COD: "세로형",
              COD_NME: "세로형"
            }, {
              COD: "가로형",
              COD_NME: "가로형"
            }, {
              COD: "NONE",
              COD_NME: "불박 안함"
            }]
          }]
        },
        38: {
          uiType: "CASCADE",
          filters: [{
            GRP_TYPE: "MTRL_GRP",
            GRP_NME: "컬러",
            options: [{
              COD: "SMT_BLK",
              COD_NME: "블랙"
            }, {
              COD: "SMT_BLU",
              COD_NME: "블루"
            }, {
              COD: "SMT_GRY",
              COD_NME: "그레이"
            }, {
              COD: "SMT_RED",
              COD_NME: "레드"
            }, {
              COD: "SMT_YEL",
              COD_NME: "옐로우"
            }]
          }, {
            GRP_TYPE: "MTRL_SUB_GRP",
            GRP_NME: "불박 후가공",
            options: [{
              COD: "세로형",
              COD_NME: "세로형"
            }, {
              COD: "가로형",
              COD_NME: "가로형"
            }, {
              COD: "NONE",
              COD_NME: "불박 안함"
            }]
          }]
        },
        19: {
          uiType: "CASCADE",
          filters: [{
            GRP_TYPE: "MTRL_GRP",
            GRP_NME: "제조사",
            options: [{
              COD: "SMT_001",
              COD_NME: "애플"
            }, {
              COD: "SMT_002",
              COD_NME: "삼성"
            }]
          }, {
            GRP_TYPE: "MTRL_SUB_GRP",
            GRP_NME: "기종"
          }]
        },
        61: {
          uiType: "CASCADE",
          filters: [{
            GRP_TYPE: "MTRL_GRP",
            GRP_NME: "사이즈",
            options: [{
              COD: "SMT_579",
              COD_NME: "57x90"
            }, {
              COD: "SMT_679",
              COD_NME: "67x94"
            }]
          }, {
            GRP_TYPE: "MTRL_SUB_GRP",
            GRP_NME: "패턴"
          }]
        }
      },
      GSSBSTP: {
        3: {
          uiType: "CASCADE",
          filters: [{
            GRP_TYPE: "MTRL_GRP",
            GRP_NME: "종류",
            options: [{
              COD: "SMT_SS3",
              COD_NME: "S-300"
            }, {
              COD: "SMT_SS4",
              COD_NME: "S-400"
            }]
          }, {
            GRP_TYPE: "MTRL_SUB_GRP",
            GRP_NME: "컬러"
          }]
        },
        8: {
          uiType: "MULTI",
          filters: [{
            GRP_TYPE: "MTRL_MULTI_GRP",
            GRP_NME: "잉크",
            GRP_COD: "SMT_ISB"
          }, {
            GRP_TYPE: "MTRL_MULTI_GRP",
            GRP_NME: "진공패드",
            GRP_COD: "SMT_VPD"
          }, {
            GRP_TYPE: "MTRL_MULTI_GRP",
            GRP_NME: "희석제",
            GRP_COD: "SMT_DLU"
          }]
        }
      }
    },
    k1 = ["red-mobile", "red-pc"];
  class L1 {
    constructor(t) {
      this.pdtCode = t.pdtCode
    }
    pdtCode = "";
    editorStore = Ve();
    orderStore = zr();
    productStore = Ms();
    getProductBaseInfo() {
      return this.productStore.getProductBaseInfo()
    }
    getOrderData() {
      return this.orderStore.getOrderData()
    }
    getSummary() {
      const t = this.getProductBaseInfo(),
        n = this.getOrderData(),
        o = t?.product_option.option.item_gbn,
        s = n?.acrylicSelectData,
        r = n?.clothesSelectData,
        a = s ? {
          ...s.printData ? {
            printData: {
              label: "인쇄 데이터",
              value: s.printData.COD_NME
            }
          } : {},
          ...s.productionMethod ? {
            productionMethod: {
              label: "제작방식",
              value: s.productionMethod.COD_NME
            }
          } : {},
          ...s.shapeInfo ? {
            shape: {
              label: "모양",
              value: s.shapeInfo.COD_NME
            }
          } : {}
        } : null,
        i = r ? {
          ...r.PrintAreaInfo ? {
            printArea: {
              label: "인쇄 영역",
              value: r.PrintAreaInfo.map(k => k.COD_NME).join("/")
            }
          } : {},
          ...r.colorInfo ? {
            color: {
              label: "의류 컬러",
              value: r.colorInfo.COD_NME
            }
          } : {},
          ...r.pantoneInfo ? {
            pantoneColor: {
              label: "인쇄 컬러(팬톤)",
              value: r.pantoneInfo.pantone_name
            }
          } : {},
          ...r.sizeInfo ? {
            size: {
              label: "사이즈",
              value: r.sizeInfo.map(k => `${k.size.COD_NME}(${k.quantity}장)`).join(", ")
            }
          } : {},
          material: {
            label: "제품명",
            value: n?.meterialInfo.PTT_NM
          }
        } : null,
        l = o === "book2025_item" ? {
          innerInfo: {
            label: "내지 정보",
            children: [{
              label: "내지 인쇄 옵션",
              value: n?.inner_dosuInfo.COD_NME
            }, {
              label: "내지 용지",
              value: n?.inner_meterialInfo.PTT_NM + `${n?.inner_meterialInfo.WGT_CD?`${+n?.inner_meterialInfo.WGT_CD}g`:""}`
            }, {
              label: "내지 장수",
              value: n?.quantityInfo.prnCnt
            }]
          },
          coverInfo: {
            label: "표지 정보",
            children: [{
              label: "표지 인쇄 옵션",
              value: n?.dosuInfo.COD_NME + (n?.dosuInfo.BNC_GB === "BNC_COL" ? "컬러" : "흑백")
            }, {
              label: "표지 용지",
              value: n?.meterialInfo.MTRL_NM
            }]
          },
          ordCnt: {
            label: "수량",
            value: `${n?.quantityInfo.ordCnt}권`
          }
        } : null,
        c = n?.calendarInfo ? {
          calendarSetting: {
            label: "시작년도/월",
            value: `${n.calendarInfo.year}년 ${n.calendarInfo.month}월`
          }
        } : null,
        u = t?.product_option.option.skinInfo,
        d = n?.sizeInfo.DIV_NM === "사이즈직접입력" || n?.sizeInfo.DIV_NM === "Input Size",
        h = n?.sizeInfo.DIV_SEQ ? d ? `${n.sizeInfo.cutSize.width}mm X ${n.sizeInfo.cutSize.height}mm` : n?.sizeInfo.DIV_NM : null,
        f = u?.quantityGroup.view_yn === "Y" ? n?.quantityInfo.ordCnt : null,
        _ = u?.quantityGroup.view_yn === "Y" ? n?.quantityInfo.prnCnt : null,
        p = kl[this.pdtCode] === "SetQty" ? (this.editorStore.editorData.default?.cntInfo?.totalCnt || 1) / (this.editorStore.editorData.default?.cntInfo?.initCnt || 1) : 0,
        m = n?.pcsInfo.reduce((k, N) => {
          const {
            VIEW_YN: D,
            PCS_GRP_NM: O,
            selectedOptions: A
          } = N;
          if (D === "Y" && O && A[0].PCS_DTL_NM) {
            const b = k[O];
            b ? b.push(A[0].PCS_DTL_NM) : k[O] = [A[0].PCS_DTL_NM]
          }
          return k
        }, {}),
        v = m ? Object.entries(m).map(([k, N]) => ({
          label: k,
          value: N.join(", ")
        })) : null;
      return {
        ...a,
        ...!l && u?.paperSelect.view_yn === "Y" ? {
          material: {
            label: n?.meterialInfo.MTRL_TYPE === "R" ? "용지" : "자재",
            value: n?.meterialInfo.MTRL_NM
          }
        } : {},
        ...u?.sizeSelect.view_yn === "Y" && h && n?.dosuInfo.PRN_CLR_CNT !== 0 ? {
          size: {
            label: "사이즈",
            value: h
          }
        } : {},
        ...c,
        ...i,
        ...l,
        ...v && v.length > 0 ? {
          postPcs: {
            label: "후가공/부자재",
            children: v
          }
        } : {},
        ...!l && !i ? {
          ...p ? {
            setCnt: {
              label: "세트",
              value: p
            }
          } : {
            ordCnt: {
              label: "디자인 수(건수)",
              value: f
            }
          },
          prnCnt: {
            label: "수량",
            value: _
          }
        } : {}
      }
    }
    setEditorData(t) {
      if (!t) return this.editorStore.setEditorData(null);
      const n = {
          pdtCode: this.pdtCode,
          ...t
        },
        o = this.getProductBaseInfo(),
        s = n.type === "KOI" ? A1(n, o) : N1(n);
      s ? this.editorStore.setEditorData(s) : console.error(`[RedWidgetSDK/ERROR] 에디터에서 온 데이터가 없습니다 > 받은 데이터: ${t}`)
    }
    canOrder() {
      try {
        const t = this.getProductBaseInfo(),
          n = this.getOrderData();
        if (t?.product_option.option.order_yn === "N") throw new Error(x("주문불가상태"));
        if (n?.validation && n.validation.length > 0) throw new Error(x("주문불가-사이즈"));
        if (n?.priceCalc.result.retCode !== 200 || !n.priceCalc.result.result_sum.PRICE) throw new Error("주문불가-가격");
        const o = t?.product_option.option.item_gbn,
          s = this.editorStore.uploadType,
          r = n?.fileUploadInfo;
        if (o === "book2025_item") {
          for (const [a, i] of Object.entries(s)) {
            const l = x(a === "inner" ? "내지" : "표지");
            if (i === "editor" && !this.editorStore.isAfterEdit(a)) throw new Error(`[${l}] ${x("주문불가-에디터")}`);
            if (i === "pdf") {
              if (!r) throw new Error(`[${l}] ${x("주문불가-파일")}`);
              if (a === "inner" && !r[0]) throw new Error(`[${l}] ${x("주문불가-파일")}`);
              if (a === "default" && !r[1]) throw new Error(`[${l}] ${x("주문불가-파일")}`)
            }
          }
          if (r && r[0] && r[1] && r[0].org_file_nm === r[1].org_file_nm) throw new Error(x("주문불가-파일명중복"));
          return {
            success: !0
          }
        }
        if (s.default === "pdf") {
          if (!r || !r[0]) throw new Error(x("주문불가-파일"));
          if (o === "clothes2025_item" && n.clothesSelectData.printType.COD === "PTP_SLK" && !n?.clothesSelectData.pantoneInfo) throw new Error(x("주문불가-인쇄컬러미선택"))
        }
        if (o === "clothes2025_item" && !n?.clothesSelectData.printType.COD) return {
          success: !0
        };
        if (s.default === "editor" && !this.editorStore.isAfterEdit() && n.dosuInfo.COD !== "SID_X") throw new Error(x("주문불가-에디터"));
        return {
          success: !0
        }
      } catch (t) {
        let n = x("주문불가상태");
        return t instanceof Error && (n = t.message), {
          success: !1,
          errorMessage: n
        }
      }
    }
    async getKOIEditorTabData(t) {
      try {
        if (!t) throw new Error("코이 에디터 커스텀 탭 데이터가 필요합니다");
        const n = this.getProductBaseInfo();
        if (!n) throw new Error("제품 기본 정보 가져오기 실패");
        const o = this.getOrderData(),
          {
            product_data: {
              apparel_info: s,
              pdt_pcs_info: r
            }
          } = n;
        if (s) {
          const a = t.PAGES.map(y => ({
              PCS_COD: "PDT_WRK",
              PCS_DTL_COD: s.print_area.find(w => w.KOI_NME === y)?.COD || ""
            })),
            i = r.find(y => y.MTRL_CD === t.MTRL_COD);
          if (!i) throw new Error("선택된 제품 자재 코드가 없습니다.");
          const l = {
              PCS_COD: i.PCS_CD,
              PCS_DTL_COD: i.PCS_DTL_CD,
              ATTB: o?.quantityInfo.prnCnt
            },
            u = this.getOrderData()?.priceCalc.params;
          if (!u) throw new Error("이전 가격 페이로드 가져오기 실패");
          const h = [{
              ...u.ORD_INFO[0],
              MTRL_CD: t.MTRL_COD
            }],
            _ = [...u.PCS_INFO.filter(y => y.PCS_COD !== "DIR_MTR" && y.PCS_COD !== "PDT_WRK"), ...a, l],
            p = {
              ...u,
              ORD_INFO: h,
              PCS_INFO: _
            },
            m = await Al({
              type: "COMMON",
              body: p
            });
          if (m.errorMessage || !m.result) throw new Error(m.errorMessage);
          const {
            ORG_PRICE: v,
            ORG_PRICE_VAT: E,
            PRICE: k,
            PRICE_VAT: N,
            PRICE_MALL: D,
            PRICE_MALL_VAT: O
          } = m.result.result_sum;
          return {
            type: "PRICE",
            data: k !== D ? D + O : v !== k ? k + N : v + E
          }
        }
      } catch (n) {
        return console.error("[RedWidgetSDK/ERROR] 코이에디터 데이터 산정 실패 > ", n), {
          errorMessage: "데이터 산정 실패"
        }
      }
    }
  }
  class $1 {
    constructor(t) {
      this.pdtCode = t.pdtCode
    }
    pdtCode = "";
    orderStore = Ml();
    productStore = Ms();
    getProductBaseInfo() {
      return this.productStore.getProductBaseInfo()
    }
    getOrderData() {
      return this.orderStore.getOrderData()
    }
    getSummary() {
      const t = this.getProductBaseInfo(),
        n = this.getOrderData();
      if (!n?.subMtrlInfo) return {
        errorMessage: x("주문불가-옵션미선택")
      };
      const o = [];
      let s = 0;
      for (const u of n.subMtrlInfo) o?.push({
        label: u.MTRL_NME,
        value: u.QTY
      }), s += u.QTY;
      const r = n.priceCalc.result.result_sum,
        a = r.PRICE !== r.PRICE_MALL,
        i = r.ORG_PRICE !== r.PRICE,
        l = a ? r.PRICE_MALL + r.PRICE_MALL_VAT : i ? r.PRICE + r.PRICE_VAT : r.ORG_PRICE + r.ORG_PRICE_VAT;
      return {
        product: {
          label: "제품명",
          value: t?.product_option.option.pdt_nme
        },
        qty: {
          label: `수량 (총 수량: ${s})`,
          children: o
        },
        amount: {
          label: "합계",
          value: `${l.toLocaleString()}원`
        }
      }
    }
    canOrder() {
      try {
        if (this.getProductBaseInfo()?.product_option.option.order_yn === "N") throw new Error(x("주문불가상태"));
        const n = this.getOrderData();
        if (!n?.subMtrlInfo) throw new Error(x("주문불가-옵션미선택"));
        if (!n?.priceCalc.result.result_sum.PRICE) throw new Error(x("주문불가-가격"));
        return {
          success: !0
        }
      } catch (t) {
        let n = x("주문불가상태");
        return t instanceof Error && (n = t.message), {
          success: !1,
          errorMessage: n
        }
      }
    }
  }

  function x1(e, t) {
    const n = document.createElement("link");
    n.rel = "stylesheet", n.href = t, e.appendChild(n)
  }
