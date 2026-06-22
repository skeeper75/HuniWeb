// ============================================================
// RedEditorSDK v6.6.48 -- 디옵퓨스케이트 버전
// 원본: RedEditorSDK.min.js (레드프린팅 온라인 디자인 에디터 SDK)
// 처리: 변수 리네이밍 + 한글 주석 추가 (로직 변경 없음)
// ============================================================
"use strict";
var _slicedToArray = function(t, e) {
    if (Array.isArray(t)) return t;
    if (Symbol.iterator in Object(t)) return function(t, e) {
      var n = [],
        r = !0,
        o = !1,
        i = void 0;
      try {
        for (var a, c = t[Symbol.iterator](); !(r = (a = c.next()).done) && (n.push(a.value), !e || n.length !== e); r = !0);
      } catch (t) {
        o = !0, i = t
      } finally {
        try {
          !r && c.return && c.return()
        } finally {
          if (o) throw i
        }
      }
      return n
    }(t, e);
    throw new TypeError("Invalid attempt to destructure non-iterable instance")
  },
  _extends = Object.assign || function(t) {
    for (var e = 1; e < arguments.length; e++) {
      var n = arguments[e];
      for (var r in n) Object.prototype.hasOwnProperty.call(n, r) && (t[r] = n[r])
    }
    return t
  },
  _createClass = function() {
    function r(t, e) {
      for (var n = 0; n < e.length; n++) {
        var r = e[n];
        r.enumerable = r.enumerable || !1, r.configurable = !0, "value" in r && (r.writable = !0), Object.defineProperty(t, r.key, r)
      }
    }
    return function(t, e, n) {
      return e && r(t.prototype, e), n && r(t, n), t
    }
  }(),
  _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(t) {
    return typeof t
  } : function(t) {
    return t && "function" == typeof Symbol && t.constructor === Symbol && t !== Symbol.prototype ? "symbol" : typeof t
  };

function _toConsumableArray(t) {
  if (Array.isArray(t)) {
    for (var e = 0, n = Array(t.length); e < t.length; e++) n[e] = t[e];
    return n
  }
  return Array.from(t)
}

function _defineProperty(t, e, n) {
  return e in t ? Object.defineProperty(t, e, {
    value: n,
    enumerable: !0,
    configurable: !0,
    writable: !0
  }) : t[e] = n, t
}

function _classCallCheck(t, e) {
  if (!(t instanceof e)) throw new TypeError("Cannot call a class as a function")

// ============================================================
// 메인 IIFE 시작 - We = window 참조
// Qe = 에디터 브릿지 (iframe 통신), A = 에디터 사용중 플래그
// i = Sentry 에러 추적 라이브러리 (v5.22.0, 서드파티)
// ============================================================
}! function(We) {
  var Qe, A = !1,
    i = function(u) {
      var r = function(t, e) {
        return (r = Object.setPrototypeOf || {
            __proto__: []
          }
          instanceof Array && function(t, e) {
            t.__proto__ = e
          } || function(t, e) {
            for (var n in e) e.hasOwnProperty(n) && (t[n] = e[n])
          })(t, e)
      };

      function n(t, e) {
        function n() {
          this.constructor = t
        }
        r(t, e), t.prototype = null === e ? Object.create(e) : (n.prototype = e.prototype, new n)
      }
      var t, e, o, i, a, c, f = function() {
        return (f = Object.assign || function(t) {
          for (var e, n = 1, r = arguments.length; n < r; n++)
            for (var o in e = arguments[n]) Object.prototype.hasOwnProperty.call(e, o) && (t[o] = e[o]);
          return t
        }).apply(this, arguments)
      };

      function h(t, e) {
        var n = "function" == typeof Symbol && t[Symbol.iterator];
        if (!n) return t;
        var r, o, i = n.call(t),
          a = [];
        try {
          for (;
            (void 0 === e || 0 < e--) && !(r = i.next()).done;) a.push(r.value)
        } catch (t) {
          o = {
            error: t
          }
        } finally {
          try {
            r && !r.done && (n = i.return) && n.call(i)
          } finally {
            if (o) throw o.error
          }
        }
        return a
      }

      function s() {
        for (var t = [], e = 0; e < arguments.length; e++) t = t.concat(h(arguments[e]));
        return t
      }(e = t || (t = {}))[e.None = 0] = "None", e[e.Error = 1] = "Error", e[e.Debug = 2] = "Debug", e[e.Verbose = 3] = "Verbose", (o = u.Severity || (u.Severity = {})).Fatal = "fatal", o.Error = "error", o.Warning = "warning", o.Log = "log", o.Info = "info", o.Debug = "debug", o.Critical = "critical", (i = u.Severity || (u.Severity = {})).fromString = function(t) {
        switch (t) {
          case "debug":
            return i.Debug;
          case "info":
            return i.Info;
          case "warn":
          case "warning":
            return i.Warning;
          case "error":
            return i.Error;
          case "fatal":
            return i.Fatal;
          case "critical":
            return i.Critical;
          case "log":
          default:
            return i.Log
        }
      }, (a = u.Status || (u.Status = {})).Unknown = "unknown", a.Skipped = "skipped", a.Success = "success", a.RateLimit = "rate_limit", a.Invalid = "invalid", a.Failed = "failed", (c = u.Status || (u.Status = {})).fromHttpCode = function(t) {
        return 200 <= t && t < 300 ? c.Success : 429 === t ? c.RateLimit : 400 <= t && t < 500 ? c.Invalid : 500 <= t ? c.Failed : c.Unknown
      };
      var l = Object.setPrototypeOf || ({
          __proto__: []
        }
        instanceof Array ? function(t, e) {
          return t.__proto__ = e, t
        } : function(t, e) {
          for (var n in e) t.hasOwnProperty(n) || (t[n] = e[n]);
          return t
        });
      var v = function(r) {
        function t(t) {
          var e = this.constructor,
            n = r.call(this, t) || this;
          return n.message = t, n.name = e.prototype.constructor.name, l(n, e.prototype), n
        }
        return n(t, r), t
      }(Error);

      function p(t) {
        switch (Object.prototype.toString.call(t)) {
          case "[object Error]":
          case "[object Exception]":
          case "[object DOMException]":
            return !0;
          default:
            return w(t, Error)
        }
      }

      function d(t) {
        return "[object ErrorEvent]" === Object.prototype.toString.call(t)
      }

      function g(t) {
        return "[object DOMError]" === Object.prototype.toString.call(t)
      }

      function _(t) {
        return "[object String]" === Object.prototype.toString.call(t)
      }

      function y(t) {
        return null === t || "object" !== (void 0 === t ? "undefined" : _typeof(t)) && "function" != typeof t
      }

      function m(t) {
        return "[object Object]" === Object.prototype.toString.call(t)
      }

      function b(t) {
        return "undefined" != typeof Event && w(t, Event)
      }

      function x(t) {
        return "undefined" != typeof Element && w(t, Element)
      }

      function k(t) {
        return Boolean(t && t.then && "function" == typeof t.then)
      }

      function w(t, e) {
        try {
          return t instanceof e
        } catch (t) {
          return !1
        }
      }

      function S(t, e) {
        return void 0 === e && (e = 0), "string" != typeof t || 0 === e ? t : t.length <= e ? t : t.substr(0, e) + "..."
      }

      function E(t, e) {
        if (!Array.isArray(t)) return "";
        for (var n = [], r = 0; r < t.length; r++) {
          var o = t[r];
          try {
            n.push(String(o))
          } catch (t) {
            n.push("[value cannot be serialized]")
          }
        }
        return n.join(e)
      }

      function I(t, e) {
        return !!_(t) && (function(t) {
          return "[object RegExp]" === Object.prototype.toString.call(t)
        }(e) ? e.test(t) : "string" == typeof e && -1 !== t.indexOf(e))
      }

      function T() {
        return "[object process]" === Object.prototype.toString.call("undefined" != typeof process ? process : 0)
      }
      var P = {};

      function O() {
        return T() ? global : void 0 !== We ? We : "undefined" != typeof self ? self : P
      }

      function j() {
        var t = O(),
          e = t.crypto || t.msCrypto;
        if (void 0 !== e && e.getRandomValues) {
          var n = new Uint16Array(8);
          e.getRandomValues(n), n[3] = 4095 & n[3] | 16384, n[4] = 16383 & n[4] | 32768;
          var r = function(t) {
            for (var e = t.toString(16); e.length < 4;) e = "0" + e;
            return e
          };
          return r(n[0]) + r(n[1]) + r(n[2]) + r(n[3]) + r(n[4]) + r(n[5]) + r(n[6]) + r(n[7])
        }
        return "xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx".replace(/[xy]/g, function(t) {
          var e = 16 * Math.random() | 0;
          return ("x" === t ? e : 3 & e | 8).toString(16)
        })
      }

      function C(t) {
        if (!t) return {};
        var e = t.match(/^(([^:/?#]+):)?(\/\/([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?$/);
        if (!e) return {};
        var n = e[6] || "",
          r = e[8] || "";
        return {
          host: e[4],
          path: e[5],
          protocol: e[2],
          relative: e[5] + n + r
        }
      }

      function R(t) {
        if (t.message) return t.message;
        if (t.exception && t.exception.values && t.exception.values[0]) {
          var e = t.exception.values[0];
          return e.type && e.value ? e.type + ": " + e.value : e.type || e.value || t.event_id || "<unknown>"
        }
        return t.event_id || "<unknown>"
      }

      function M(t) {
        var e = O();
        if (!("console" in e)) return t();
        var n = e.console,
          r = {};
        ["debug", "info", "warn", "error", "log", "assert"].forEach(function(t) {
          t in e.console && n[t].__sentry_original__ && (r[t] = n[t], n[t] = n[t].__sentry_original__)
        });
        var o = t();
        return Object.keys(r).forEach(function(t) {
          n[t] = r[t]
        }), o
      }

      function N(t, e, n) {
        t.exception = t.exception || {}, t.exception.values = t.exception.values || [], t.exception.values[0] = t.exception.values[0] || {}, t.exception.values[0].value = t.exception.values[0].value || e || "", t.exception.values[0].type = t.exception.values[0].type || n || "Error"
      }

      function F(e, n) {
        void 0 === n && (n = {});
        try {
          e.exception.values[0].mechanism = e.exception.values[0].mechanism || {}, Object.keys(n).forEach(function(t) {
            e.exception.values[0].mechanism[t] = n[t]
          })
        } catch (t) {}
      }

      function L(t) {
        try {
          for (var e = t, n = [], r = 0, o = 0, i = " > ".length, a = void 0; e && r++ < 5 && !("html" === (a = A(e)) || 1 < r && 80 <= o + n.length * i + a.length);) n.push(a), o += a.length, e = e.parentNode;
          return n.reverse().join(" > ")
        } catch (t) {
          return "<unknown>"
        }
      }

      function A(t) {
        var e, n, r, o, i, a = t,
          c = [];
        if (!a || !a.tagName) return "";
        if (c.push(a.tagName.toLowerCase()), a.id && c.push("#" + a.id), (e = a.className) && _(e))
          for (n = e.split(/\s+/), i = 0; i < n.length; i++) c.push("." + n[i]);
        var s = ["type", "name", "title", "alt"];
        for (i = 0; i < s.length; i++) r = s[i], (o = a.getAttribute(r)) && c.push("[" + r + '="' + o + '"]');
        return c.join("")
      }
      var D = Date.now(),
        U = 0,
        B = {
          now: function() {
            var t = Date.now() - D;
            return t < U && (t = U), U = t
          },
          timeOrigin: D
        },
        z = function() {
          if (T()) try {
            return function(t, e) {
              return t.require(e)
            }(module, "perf_hooks").performance
          } catch (t) {
            return B
          }
          var t = O().performance;
          return t && t.now ? (void 0 === t.timeOrigin && (t.timeOrigin = t.timing && t.timing.navigationStart || D), t) : B
        }();

      function H() {
        return (z.timeOrigin + z.now()) / 1e3
      }

      function W(t, e) {
        if (!e) return 6e4;
        var n = parseInt("" + e, 10);
        if (!isNaN(n)) return 1e3 * n;
        var r = Date.parse("" + e);
        return isNaN(r) ? 6e4 : r - t
      }
      var G = "<anonymous>";

      function q(t) {
        try {
          return t && "function" == typeof t && t.name || G
        } catch (t) {
          return G
        }
      }
      var V = O(),
        J = "Sentry Logger ",
        K = function() {
          function t() {
            this._enabled = !1
          }
          return t.prototype.disable = function() {
            this._enabled = !1
          }, t.prototype.enable = function() {
            this._enabled = !0
          }, t.prototype.log = function() {
            for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
            this._enabled && M(function() {
              V.console.log(J + "[Log]: " + t.join(" "))
            })
          }, t.prototype.warn = function() {
            for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
            this._enabled && M(function() {
              V.console.warn(J + "[Warn]: " + t.join(" "))
            })
          }, t.prototype.error = function() {
            for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
            this._enabled && M(function() {
              V.console.error(J + "[Error]: " + t.join(" "))
            })
          }, t
        }();
      V.__SENTRY__ = V.__SENTRY__ || {};
      var Y, $, X = V.__SENTRY__.logger || (V.__SENTRY__.logger = new K),
        Z = function() {
          function t() {
            this._hasWeakSet = "function" == typeof WeakSet, this._inner = this._hasWeakSet ? new WeakSet : []
          }
          return t.prototype.memoize = function(t) {
            if (this._hasWeakSet) return !!this._inner.has(t) || (this._inner.add(t), !1);
            for (var e = 0; e < this._inner.length; e++) {
              if (this._inner[e] === t) return !0
            }
            return this._inner.push(t), !1
          }, t.prototype.unmemoize = function(t) {
            if (this._hasWeakSet) this._inner.delete(t);
            else
              for (var e = 0; e < this._inner.length; e++)
                if (this._inner[e] === t) {
                  this._inner.splice(e, 1);
                  break
                }
          }, t
        }();

      function Q(t, e, n) {
        if (e in t) {
          var r = t[e],
            o = n(r);
          if ("function" == typeof o) try {
            o.prototype = o.prototype || {}, Object.defineProperties(o, {
              __sentry_original__: {
                enumerable: !1,
                value: r
              }
            })
          } catch (t) {}
          t[e] = o
        }
      }

      function tt(t) {
        if (p(t)) {
          var e = t,
            n = {
              message: e.message,
              name: e.name,
              stack: e.stack
            };
          for (var r in e) Object.prototype.hasOwnProperty.call(e, r) && (n[r] = e[r]);
          return n
        }
        if (b(t)) {
          var o = t,
            i = {};
          i.type = o.type;
          try {
            i.target = x(o.target) ? L(o.target) : Object.prototype.toString.call(o.target)
          } catch (t) {
            i.target = "<unknown>"
          }
          try {
            i.currentTarget = x(o.currentTarget) ? L(o.currentTarget) : Object.prototype.toString.call(o.currentTarget)
          } catch (t) {
            i.currentTarget = "<unknown>"
          }
          for (var r in "undefined" != typeof CustomEvent && w(t, CustomEvent) && (i.detail = o.detail), o) Object.prototype.hasOwnProperty.call(o, r) && (i[r] = o);
          return i
        }
        return t
      }

      function et(t) {
        return function(t) {
          return ~-encodeURI(t).split(/%..|./).length
        }(JSON.stringify(t))
      }

      function nt(t, e) {
        return "domain" === e && t && "object" === (void 0 === t ? "undefined" : _typeof(t)) && t._events ? "[Domain]" : "domainEmitter" === e ? "[DomainEmitter]" : "undefined" != typeof global && t === global ? "[Global]" : void 0 !== We && t === We ? "[Window]" : "undefined" != typeof document && t === document ? "[Document]" : function(t) {
          return m(t) && "nativeEvent" in t && "preventDefault" in t && "stopPropagation" in t
        }(t) ? "[SyntheticEvent]" : "number" == typeof t && t != t ? "[NaN]" : void 0 === t ? "[undefined]" : "function" == typeof t ? "[Function: " + q(t) + "]" : t
      }

      function rt(t, e, n, r) {
        if (void 0 === n && (n = 1 / 0), void 0 === r && (r = new Z), 0 === n) return function(t) {
          var e = Object.prototype.toString.call(t);
          if ("string" == typeof t) return t;
          if ("[object Object]" === e) return "[Object]";
          if ("[object Array]" === e) return "[Array]";
          var n = nt(t);
          return y(n) ? n : e
        }(e);
        if (null != e && "function" == typeof e.toJSON) return e.toJSON();
        var o = nt(e, t);
        if (y(o)) return o;
        var i = tt(e),
          a = Array.isArray(e) ? [] : {};
        if (r.memoize(e)) return "[Circular ~]";
        for (var c in i) Object.prototype.hasOwnProperty.call(i, c) && (a[c] = rt(c, i[c], n - 1, r));
        return r.unmemoize(e), a
      }

      function ot(t, n) {
        try {
          return JSON.parse(JSON.stringify(t, function(t, e) {
            return rt(t, e, n)
          }))
        } catch (t) {
          return "**non-serializable**"
        }
      }($ = Y || (Y = {})).PENDING = "PENDING", $.RESOLVED = "RESOLVED", $.REJECTED = "REJECTED";
      var it = function() {
          function a(t) {
            var n = this;
            this._state = Y.PENDING, this._handlers = [], this._resolve = function(t) {
              n._setResult(Y.RESOLVED, t)
            }, this._reject = function(t) {
              n._setResult(Y.REJECTED, t)
            }, this._setResult = function(t, e) {
              n._state === Y.PENDING && (k(e) ? e.then(n._resolve, n._reject) : (n._state = t, n._value = e, n._executeHandlers()))
            }, this._attachHandler = function(t) {
              n._handlers = n._handlers.concat(t), n._executeHandlers()
            }, this._executeHandlers = function() {
              if (n._state !== Y.PENDING) {
                var t = n._handlers.slice();
                n._handlers = [], t.forEach(function(t) {
                  t.done || (n._state === Y.RESOLVED && t.onfulfilled && t.onfulfilled(n._value), n._state === Y.REJECTED && t.onrejected && t.onrejected(n._value), t.done = !0)
                })
              }
            };
            try {
              t(this._resolve, this._reject)
            } catch (t) {
              this._reject(t)
            }
          }
          return a.resolve = function(e) {
            return new a(function(t) {
              t(e)
            })
          }, a.reject = function(n) {
            return new a(function(t, e) {
              e(n)
            })
          }, a.all = function(t) {
            return new a(function(n, r) {
              if (Array.isArray(t))
                if (0 !== t.length) {
                  var o = t.length,
                    i = [];
                  t.forEach(function(t, e) {
                    a.resolve(t).then(function(t) {
                      i[e] = t, 0 === (o -= 1) && n(i)
                    }).then(null, r)
                  })
                } else n([]);
              else r(new TypeError("Promise.all requires an array as input."))
            })
          }, a.prototype.then = function(r, o) {
            var t = this;
            return new a(function(e, n) {
              t._attachHandler({
                done: !1,
                onfulfilled: function(t) {
                  if (r) try {
                    return void e(r(t))
                  } catch (t) {
                    return void n(t)
                  } else e(t)
                },
                onrejected: function(t) {
                  if (o) try {
                    return void e(o(t))
                  } catch (t) {
                    return void n(t)
                  } else n(t)
                }
              })
            })
          }, a.prototype.catch = function(t) {
            return this.then(function(t) {
              return t
            }, t)
          }, a.prototype.finally = function(o) {
            var i = this;
            return new a(function(t, e) {
              var n, r;
              return i.then(function(t) {
                r = !1, n = t, o && o()
              }, function(t) {
                r = !0, n = t, o && o()
              }).then(function() {
                r ? e(n) : t(n)
              })
            })
          }, a.prototype.toString = function() {
            return "[object SyncPromise]"
          }, a
        }(),
        at = function() {
          function t(t) {
            this._limit = t, this._buffer = []
          }
          return t.prototype.isReady = function() {
            return void 0 === this._limit || this.length() < this._limit
          }, t.prototype.add = function(t) {
            var e = this;
            return this.isReady() ? (-1 === this._buffer.indexOf(t) && this._buffer.push(t), t.then(function() {
              return e.remove(t)
            }).then(null, function() {
              return e.remove(t).then(null, function() {})
            }), t) : it.reject(new v("Not adding Promise due to buffer limit reached."))
          }, t.prototype.remove = function(t) {
            return this._buffer.splice(this._buffer.indexOf(t), 1)[0]
          }, t.prototype.length = function() {
            return this._buffer.length
          }, t.prototype.drain = function(n) {
            var r = this;
            return new it(function(t) {
              var e = setTimeout(function() {
                n && 0 < n && t(!1)
              }, n);
              it.all(r._buffer).then(function() {
                clearTimeout(e), t(!0)
              }).then(null, function() {
                t(!0)
              })
            })
          }, t
        }();

      function ct() {
        if (!("fetch" in O())) return !1;
        try {
          return new Headers, new Request(""), new Response, !0
        } catch (t) {
          return !1
        }
      }

      function st(t) {
        return t && /^function fetch\(\)\s+\{\s+\[native code\]\s+\}$/.test(t.toString())
      }
      var ut, lt = O(),
        ft = {},
        pt = {};

      function dt(t) {
        if (!pt[t]) switch (pt[t] = !0, t) {
          case "console":
            ! function() {
              if (!("console" in lt)) return;
              ["debug", "info", "warn", "error", "log", "assert"].forEach(function(r) {
                r in lt.console && Q(lt.console, r, function(n) {
                  return function() {
                    for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                    vt("console", {
                      args: t,
                      level: r
                    }), n && Function.prototype.apply.call(n, lt.console, t)
                  }
                })
              })
            }();
            break;
          case "dom":
            ! function() {
              if (!("document" in lt)) return;
              lt.document.addEventListener("click", bt("click", vt.bind(null, "dom")), !1), lt.document.addEventListener("keypress", xt(vt.bind(null, "dom")), !1), ["EventTarget", "Node"].forEach(function(t) {
                var e = lt[t] && lt[t].prototype;
                e && e.hasOwnProperty && e.hasOwnProperty("addEventListener") && (Q(e, "addEventListener", function(r) {
                  return function(t, e, n) {
                    return e && e.handleEvent ? ("click" === t && Q(e, "handleEvent", function(e) {
                      return function(t) {
                        return bt("click", vt.bind(null, "dom"))(t), e.call(this, t)
                      }
                    }), "keypress" === t && Q(e, "handleEvent", function(e) {
                      return function(t) {
                        return xt(vt.bind(null, "dom"))(t), e.call(this, t)
                      }
                    })) : ("click" === t && bt("click", vt.bind(null, "dom"), !0)(this), "keypress" === t && xt(vt.bind(null, "dom"))(this)), r.call(this, t, e, n)
                  }
                }), Q(e, "removeEventListener", function(r) {
                  return function(t, e, n) {
                    try {
                      r.call(this, t, e.__sentry_wrapped__, n)
                    } catch (t) {}
                    return r.call(this, t, e, n)
                  }
                }))
              })
            }();
            break;
          case "xhr":
            ! function() {
              if (!("XMLHttpRequest" in lt)) return;
              var t = XMLHttpRequest.prototype;
              Q(t, "open", function(i) {
                return function() {
                  for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                  var r = this,
                    n = t[1];
                  r.__sentry_xhr__ = {
                    method: _(t[0]) ? t[0].toUpperCase() : t[0],
                    url: t[1]
                  }, _(n) && "POST" === r.__sentry_xhr__.method && n.match(/sentry_key/) && (r.__sentry_own_request__ = !0);
                  var o = function() {
                    if (4 === r.readyState) {
                      try {
                        r.__sentry_xhr__ && (r.__sentry_xhr__.status_code = r.status)
                      } catch (t) {}
                      vt("xhr", {
                        args: t,
                        endTimestamp: Date.now(),
                        startTimestamp: Date.now(),
                        xhr: r
                      })
                    }
                  };
                  return "onreadystatechange" in r && "function" == typeof r.onreadystatechange ? Q(r, "onreadystatechange", function(n) {
                    return function() {
                      for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                      return o(), n.apply(r, t)
                    }
                  }) : r.addEventListener("readystatechange", o), i.apply(r, t)
                }
              }), Q(t, "send", function(n) {
                return function() {
                  for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                  return vt("xhr", {
                    args: t,
                    startTimestamp: Date.now(),
                    xhr: this
                  }), n.apply(this, t)
                }
              })
            }();
            break;
          case "fetch":
            ! function() {
              if (! function() {
                  if (!ct()) return !1;
                  var t = O();
                  if (st(t.fetch)) return !0;
                  var e = !1,
                    n = t.document;
                  if (n && "function" == typeof n.createElement) try {
                    var r = n.createElement("iframe");
                    r.hidden = !0, n.head.appendChild(r), r.contentWindow && r.contentWindow.fetch && (e = st(r.contentWindow.fetch)), n.head.removeChild(r)
                  } catch (t) {
                    X.warn("Could not create sandbox iframe for pure fetch check, bailing to window.fetch: ", t)
                  }
                  return e
                }()) return;
              Q(lt, "fetch", function(r) {
                return function() {
                  for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                  var n = {
                    args: t,
                    fetchData: {
                      method: function(t) {
                        void 0 === t && (t = []);
                        if ("Request" in lt && w(t[0], Request) && t[0].method) return String(t[0].method).toUpperCase();
                        if (t[1] && t[1].method) return String(t[1].method).toUpperCase();
                        return "GET"
                      }(t),
                      url: function(t) {
                        void 0 === t && (t = []);
                        if ("string" == typeof t[0]) return t[0];
                        if ("Request" in lt && w(t[0], Request)) return t[0].url;
                        return String(t[0])
                      }(t)
                    },
                    startTimestamp: Date.now()
                  };
                  return vt("fetch", f({}, n)), r.apply(lt, t).then(function(t) {
                    return vt("fetch", f(f({}, n), {
                      endTimestamp: Date.now(),
                      response: t
                    })), t
                  }, function(t) {
                    throw vt("fetch", f(f({}, n), {
                      endTimestamp: Date.now(),
                      error: t
                    })), t
                  })
                }
              })
            }();
            break;
          case "history":
            ! function() {
              if (! function() {
                  var t = O(),
                    e = t.chrome,
                    n = e && e.app && e.app.runtime,
                    r = "history" in t && !!t.history.pushState && !!t.history.replaceState;
                  return !n && r
                }()) return;
              var o = lt.onpopstate;

              function t(i) {
                return function() {
                  for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                  var n = 2 < t.length ? t[2] : void 0;
                  if (n) {
                    var r = ut,
                      o = String(n);
                    vt("history", {
                      from: r,
                      to: ut = o
                    })
                  }
                  return i.apply(this, t)
                }
              }
              lt.onpopstate = function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                var n = lt.location.href,
                  r = ut;
                if (vt("history", {
                    from: r,
                    to: ut = n
                  }), o) return o.apply(this, t)
              }, Q(lt.history, "pushState", t), Q(lt.history, "replaceState", t)
            }();
            break;
          case "error":
            kt = lt.onerror, lt.onerror = function(t, e, n, r, o) {
              return vt("error", {
                column: r,
                error: o,
                line: n,
                msg: t,
                url: e
              }), !!kt && kt.apply(this, arguments)
            };
            break;
          case "unhandledrejection":
            wt = lt.onunhandledrejection, lt.onunhandledrejection = function(t) {
              return vt("unhandledrejection", t), !wt || wt.apply(this, arguments)
            };
            break;
          default:
            X.warn("unknown instrumentation type:", t)
        }
      }

      function ht(t) {
        t && "string" == typeof t.type && "function" == typeof t.callback && (ft[t.type] = ft[t.type] || [], ft[t.type].push(t.callback), dt(t.type))
      }

      function vt(e, t) {
        var n, r;
        if (e && ft[e]) try {
          for (var o = function(t) {
              var e = "function" == typeof Symbol && t[Symbol.iterator],
                n = 0;
              return e ? e.call(t) : {
                next: function() {
                  return t && n >= t.length && (t = void 0), {
                    value: t && t[n++],
                    done: !t
                  }
                }
              }
            }(ft[e] || []), i = o.next(); !i.done; i = o.next()) {
            var a = i.value;
            try {
              a(t)
            } catch (t) {
              X.error("Error while triggering instrumentation handler.\nType: " + e + "\nName: " + q(a) + "\nError: " + t)
            }
          }
        } catch (t) {
          n = {
            error: t
          }
        } finally {
          try {
            i && !i.done && (r = o.return) && r.call(o)
          } finally {
            if (n) throw n.error
          }
        }
      }
      var gt, _t, yt = 1e3,
        mt = 0;

      function bt(e, n, r) {
        return void 0 === r && (r = !1),
          function(t) {
            gt = void 0, t && _t !== t && (_t = t, mt && clearTimeout(mt), r ? mt = setTimeout(function() {
              n({
                event: t,
                name: e
              })
            }) : n({
              event: t,
              name: e
            }))
          }
      }

      function xt(r) {
        return function(t) {
          var e;
          try {
            e = t.target
          } catch (t) {
            return
          }
          var n = e && e.tagName;
          n && ("INPUT" === n || "TEXTAREA" === n || e.isContentEditable) && (gt || bt("input", r)(t), clearTimeout(gt), gt = setTimeout(function() {
            gt = void 0
          }, yt))
        }
      }
      var kt = null;
      var wt = null;
      var St = /^(?:(\w+):)\/\/(?:(\w+)(?::(\w+))?@)([\w.-]+)(?::(\d+))?\/(.+)/,
        Et = "Invalid Dsn",
        It = function() {
          function t(t) {
            "string" == typeof t ? this._fromString(t) : this._fromComponents(t), this._validate()
          }
          return t.prototype.toString = function(t) {
            void 0 === t && (t = !1);
            var e = this,
              n = e.host,
              r = e.path,
              o = e.pass,
              i = e.port,
              a = e.projectId;
            return e.protocol + "://" + e.user + (t && o ? ":" + o : "") + "@" + n + (i ? ":" + i : "") + "/" + (r ? r + "/" : r) + a
          }, t.prototype._fromString = function(t) {
            var e = St.exec(t);
            if (!e) throw new v(Et);
            var n = h(e.slice(1), 6),
              r = n[0],
              o = n[1],
              i = n[2],
              a = void 0 === i ? "" : i,
              c = n[3],
              s = n[4],
              u = void 0 === s ? "" : s,
              l = "",
              f = n[5],
              p = f.split("/");
            if (1 < p.length && (l = p.slice(0, -1).join("/"), f = p.pop()), f) {
              var d = f.match(/^\d+/);
              d && (f = d[0])
            }
            this._fromComponents({
              host: c,
              pass: a,
              path: l,
              projectId: f,
              port: u,
              protocol: r,
              user: o
            })
          }, t.prototype._fromComponents = function(t) {
            this.protocol = t.protocol, this.user = t.user, this.pass = t.pass || "", this.host = t.host, this.port = t.port || "", this.path = t.path || "", this.projectId = t.projectId
          }, t.prototype._validate = function() {
            var e = this;
            if (["protocol", "user", "host", "projectId"].forEach(function(t) {
                if (!e[t]) throw new v(Et + ": " + t + " missing")
              }), !this.projectId.match(/^\d+$/)) throw new v(Et + ": Invalid projectId " + this.projectId);
            if ("http" !== this.protocol && "https" !== this.protocol) throw new v(Et + ": Invalid protocol " + this.protocol);
            if (this.port && isNaN(parseInt(this.port, 10))) throw new v(Et + ": Invalid port " + this.port)
          }, t
        }(),
        Tt = function() {
          function n() {
            this._notifyingListeners = !1, this._scopeListeners = [], this._eventProcessors = [], this._breadcrumbs = [], this._user = {}, this._tags = {}, this._extra = {}, this._contexts = {}
          }
          return n.clone = function(t) {
            var e = new n;
            return t && (e._breadcrumbs = s(t._breadcrumbs), e._tags = f({}, t._tags), e._extra = f({}, t._extra), e._contexts = f({}, t._contexts), e._user = t._user, e._level = t._level, e._span = t._span, e._transactionName = t._transactionName, e._fingerprint = t._fingerprint, e._eventProcessors = s(t._eventProcessors)), e
          }, n.prototype.addScopeListener = function(t) {
            this._scopeListeners.push(t)
          }, n.prototype.addEventProcessor = function(t) {
            return this._eventProcessors.push(t), this
          }, n.prototype.setUser = function(t) {
            return this._user = t || {}, this._notifyScopeListeners(), this
          }, n.prototype.setTags = function(t) {
            return this._tags = f(f({}, this._tags), t), this._notifyScopeListeners(), this
          }, n.prototype.setTag = function(t, e) {
            var n;
            return this._tags = f(f({}, this._tags), ((n = {})[t] = e, n)), this._notifyScopeListeners(), this
          }, n.prototype.setExtras = function(t) {
            return this._extra = f(f({}, this._extra), t), this._notifyScopeListeners(), this
          }, n.prototype.setExtra = function(t, e) {
            var n;
            return this._extra = f(f({}, this._extra), ((n = {})[t] = e, n)), this._notifyScopeListeners(), this
          }, n.prototype.setFingerprint = function(t) {
            return this._fingerprint = t, this._notifyScopeListeners(), this
          }, n.prototype.setLevel = function(t) {
            return this._level = t, this._notifyScopeListeners(), this
          }, n.prototype.setTransactionName = function(t) {
            return this._transactionName = t, this._notifyScopeListeners(), this
          }, n.prototype.setTransaction = function(t) {
            return this.setTransactionName(t)
          }, n.prototype.setContext = function(t, e) {
            var n;
            return this._contexts = f(f({}, this._contexts), ((n = {})[t] = e, n)), this._notifyScopeListeners(), this
          }, n.prototype.setSpan = function(t) {
            return this._span = t, this._notifyScopeListeners(), this
          }, n.prototype.getSpan = function() {
            return this._span
          }, n.prototype.getTransaction = function() {
            var t = this.getSpan();
            if (t && t.spanRecorder && t.spanRecorder.spans[0]) return t.spanRecorder.spans[0]
          }, n.prototype.update = function(t) {
            if (!t) return this;
            if ("function" != typeof t) return t instanceof n ? (this._tags = f(f({}, this._tags), t._tags), this._extra = f(f({}, this._extra), t._extra), this._contexts = f(f({}, this._contexts), t._contexts), t._user && (this._user = t._user), t._level && (this._level = t._level), t._fingerprint && (this._fingerprint = t._fingerprint)) : m(t) && (t = t, this._tags = f(f({}, this._tags), t.tags), this._extra = f(f({}, this._extra), t.extra), this._contexts = f(f({}, this._contexts), t.contexts), t.user && (this._user = t.user), t.level && (this._level = t.level), t.fingerprint && (this._fingerprint = t.fingerprint)), this;
            var e = t(this);
            return e instanceof n ? e : this
          }, n.prototype.clear = function() {
            return this._breadcrumbs = [], this._tags = {}, this._extra = {}, this._user = {}, this._contexts = {}, this._level = void 0, this._transactionName = void 0, this._fingerprint = void 0, this._span = void 0, this._notifyScopeListeners(), this
          }, n.prototype.addBreadcrumb = function(t, e) {
            var n = f({
              timestamp: H()
            }, t);
            return this._breadcrumbs = void 0 !== e && 0 <= e ? s(this._breadcrumbs, [n]).slice(-e) : s(this._breadcrumbs, [n]), this._notifyScopeListeners(), this
          }, n.prototype.clearBreadcrumbs = function() {
            return this._breadcrumbs = [], this._notifyScopeListeners(), this
          }, n.prototype.applyToEvent = function(t, e) {
            return this._extra && Object.keys(this._extra).length && (t.extra = f(f({}, this._extra), t.extra)), this._tags && Object.keys(this._tags).length && (t.tags = f(f({}, this._tags), t.tags)), this._user && Object.keys(this._user).length && (t.user = f(f({}, this._user), t.user)), this._contexts && Object.keys(this._contexts).length && (t.contexts = f(f({}, this._contexts), t.contexts)), this._level && (t.level = this._level), this._transactionName && (t.transaction = this._transactionName), this._span && (t.contexts = f({
              trace: this._span.getTraceContext()
            }, t.contexts)), this._applyFingerprint(t), t.breadcrumbs = s(t.breadcrumbs || [], this._breadcrumbs), t.breadcrumbs = 0 < t.breadcrumbs.length ? t.breadcrumbs : void 0, this._notifyEventProcessors(s(Pt(), this._eventProcessors), t, e)
          }, n.prototype._notifyEventProcessors = function(o, i, a, c) {
            var s = this;
            return void 0 === c && (c = 0), new it(function(e, t) {
              var n = o[c];
              if (null === i || "function" != typeof n) e(i);
              else {
                var r = n(f({}, i), a);
                k(r) ? r.then(function(t) {
                  return s._notifyEventProcessors(o, t, a, c + 1).then(e)
                }).then(null, t) : s._notifyEventProcessors(o, r, a, c + 1).then(e).then(null, t)
              }
            })
          }, n.prototype._notifyScopeListeners = function() {
            var e = this;
            this._notifyingListeners || (this._notifyingListeners = !0, setTimeout(function() {
              e._scopeListeners.forEach(function(t) {
                t(e)
              }), e._notifyingListeners = !1
            }))
          }, n.prototype._applyFingerprint = function(t) {
            t.fingerprint = t.fingerprint ? Array.isArray(t.fingerprint) ? t.fingerprint : [t.fingerprint] : [], this._fingerprint && (t.fingerprint = t.fingerprint.concat(this._fingerprint)), t.fingerprint && !t.fingerprint.length && delete t.fingerprint
          }, n
        }();

      function Pt() {
        var t = O();
        return t.__SENTRY__ = t.__SENTRY__ || {}, t.__SENTRY__.globalEventProcessors = t.__SENTRY__.globalEventProcessors || [], t.__SENTRY__.globalEventProcessors
      }

      function Ot(t) {
        Pt().push(t)
      }
      var jt = 3,
        Ct = function() {
          function t(t, e, n) {
            void 0 === e && (e = new Tt), void 0 === n && (n = jt), this._version = n, this._stack = [], this._stack.push({
              client: t,
              scope: e
            }), this.bindClient(t)
          }
          return t.prototype.isOlderThan = function(t) {
            return this._version < t
          }, t.prototype.bindClient = function(t) {
            (this.getStackTop().client = t) && t.setupIntegrations && t.setupIntegrations()
          }, t.prototype.pushScope = function() {
            var t = this.getStack(),
              e = 0 < t.length ? t[t.length - 1].scope : void 0,
              n = Tt.clone(e);
            return this.getStack().push({
              client: this.getClient(),
              scope: n
            }), n
          }, t.prototype.popScope = function() {
            return void 0 !== this.getStack().pop()
          }, t.prototype.withScope = function(t) {
            var e = this.pushScope();
            try {
              t(e)
            } finally {
              this.popScope()
            }
          }, t.prototype.getClient = function() {
            return this.getStackTop().client
          }, t.prototype.getScope = function() {
            return this.getStackTop().scope
          }, t.prototype.getStack = function() {
            return this._stack
          }, t.prototype.getStackTop = function() {
            return this._stack[this._stack.length - 1]
          }, t.prototype.captureException = function(t, e) {
            var n = this._lastEventId = j(),
              r = e;
            if (!e) {
              var o = void 0;
              try {
                throw new Error("Sentry syntheticException")
              } catch (t) {
                o = t
              }
              r = {
                originalException: t,
                syntheticException: o
              }
            }
            return this._invokeClient("captureException", t, f(f({}, r), {
              event_id: n
            })), n
          }, t.prototype.captureMessage = function(t, e, n) {
            var r = this._lastEventId = j(),
              o = n;
            if (!n) {
              var i = void 0;
              try {
                throw new Error(t)
              } catch (t) {
                i = t
              }
              o = {
                originalException: t,
                syntheticException: i
              }
            }
            return this._invokeClient("captureMessage", t, e, f(f({}, o), {
              event_id: r
            })), r
          }, t.prototype.captureEvent = function(t, e) {
            var n = this._lastEventId = j();
            return this._invokeClient("captureEvent", t, f(f({}, e), {
              event_id: n
            })), n
          }, t.prototype.lastEventId = function() {
            return this._lastEventId
          }, t.prototype.addBreadcrumb = function(t, e) {
            var n = this.getStackTop();
            if (n.scope && n.client) {
              var r = n.client.getOptions && n.client.getOptions() || {},
                o = r.beforeBreadcrumb,
                i = void 0 === o ? null : o,
                a = r.maxBreadcrumbs,
                c = void 0 === a ? 100 : a;
              if (!(c <= 0)) {
                var s = H(),
                  u = f({
                    timestamp: s
                  }, t),
                  l = i ? M(function() {
                    return i(u, e)
                  }) : u;
                null !== l && n.scope.addBreadcrumb(l, Math.min(c, 100))
              }
            }
          }, t.prototype.setUser = function(t) {
            var e = this.getStackTop();
            e.scope && e.scope.setUser(t)
          }, t.prototype.setTags = function(t) {
            var e = this.getStackTop();
            e.scope && e.scope.setTags(t)
          }, t.prototype.setExtras = function(t) {
            var e = this.getStackTop();
            e.scope && e.scope.setExtras(t)
          }, t.prototype.setTag = function(t, e) {
            var n = this.getStackTop();
            n.scope && n.scope.setTag(t, e)
          }, t.prototype.setExtra = function(t, e) {
            var n = this.getStackTop();
            n.scope && n.scope.setExtra(t, e)
          }, t.prototype.setContext = function(t, e) {
            var n = this.getStackTop();
            n.scope && n.scope.setContext(t, e)
          }, t.prototype.configureScope = function(t) {
            var e = this.getStackTop();
            e.scope && e.client && t(e.scope)
          }, t.prototype.run = function(t) {
            var e = Mt(this);
            try {
              t(this)
            } finally {
              Mt(e)
            }
          }, t.prototype.getIntegration = function(e) {
            var t = this.getClient();
            if (!t) return null;
            try {
              return t.getIntegration(e)
            } catch (t) {
              return X.warn("Cannot retrieve integration " + e.id + " from the current Hub"), null
            }
          }, t.prototype.startSpan = function(t) {
            return this._callExtensionMethod("startSpan", t)
          }, t.prototype.startTransaction = function(t) {
            return this._callExtensionMethod("startTransaction", t)
          }, t.prototype.traceHeaders = function() {
            return this._callExtensionMethod("traceHeaders")
          }, t.prototype._invokeClient = function(t) {
            for (var e, n = [], r = 1; r < arguments.length; r++) n[r - 1] = arguments[r];
            var o = this.getStackTop();
            o && o.client && o.client[t] && (e = o.client)[t].apply(e, s(n, [o.scope]))
          }, t.prototype._callExtensionMethod = function(t) {
            for (var e = [], n = 1; n < arguments.length; n++) e[n - 1] = arguments[n];
            var r = Rt().__SENTRY__;
            if (r && r.extensions && "function" == typeof r.extensions[t]) return r.extensions[t].apply(this, e);
            X.warn("Extension method " + t + " couldn't be found, doing nothing.")
          }, t
        }();

      function Rt() {
        var t = O();
        return t.__SENTRY__ = t.__SENTRY__ || {
          extensions: {},
          hub: void 0
        }, t
      }

      function Mt(t) {
        var e = Rt(),
          n = Lt(e);
        return At(e, t), n
      }

      function Nt() {
        var t = Rt();
        return Ft(t) && !Lt(t).isOlderThan(jt) || At(t, new Ct), T() ? function(e) {
          try {
            var t = Rt(),
              n = t.__SENTRY__;
            if (!n || !n.extensions || !n.extensions.domain) return Lt(e);
            var r = n.extensions.domain,
              o = r.active;
            if (!o) return Lt(e);
            if (!Ft(o) || Lt(o).isOlderThan(jt)) {
              var i = Lt(e).getStackTop();
              At(o, new Ct(i.client, Tt.clone(i.scope)))
            }
            return Lt(o)
          } catch (t) {
            return Lt(e)
          }
        }(t) : Lt(t)
      }

      function Ft(t) {
        return !!(t && t.__SENTRY__ && t.__SENTRY__.hub)
      }

      function Lt(t) {
        return t && t.__SENTRY__ && t.__SENTRY__.hub || (t.__SENTRY__ = t.__SENTRY__ || {}, t.__SENTRY__.hub = new Ct), t.__SENTRY__.hub
      }

      function At(t, e) {
        return !!t && (t.__SENTRY__ = t.__SENTRY__ || {}, t.__SENTRY__.hub = e, !0)
      }

      function Dt(t) {
        for (var e = [], n = 1; n < arguments.length; n++) e[n - 1] = arguments[n];
        var r = Nt();
        if (r && r[t]) return r[t].apply(r, s(e));
        throw new Error("No hub defined or " + t + " was not found on the hub, please open a bug report.")
      }

      function Ut(t, e) {
        var n;
        try {
          throw new Error("Sentry syntheticException")
        } catch (t) {
          n = t
        }
        return Dt("captureException", t, {
          captureContext: e,
          originalException: t,
          syntheticException: n
        })
      }

      function Bt(t) {
        Dt("withScope", t)
      }
      var zt = function() {
          function t(t) {
            this.dsn = t, this._dsnObject = new It(t)
          }
          return t.prototype.getDsn = function() {
            return this._dsnObject
          }, t.prototype.getBaseApiEndpoint = function() {
            var t = this._dsnObject,
              e = t.protocol ? t.protocol + ":" : "",
              n = t.port ? ":" + t.port : "";
            return e + "//" + t.host + n + (t.path ? "/" + t.path : "") + "/api/"
          }, t.prototype.getStoreEndpoint = function() {
            return this._getIngestEndpoint("store")
          }, t.prototype.getStoreEndpointWithUrlEncodedAuth = function() {
            return this.getStoreEndpoint() + "?" + this._encodedAuth()
          }, t.prototype.getEnvelopeEndpointWithUrlEncodedAuth = function() {
            return this._getEnvelopeEndpoint() + "?" + this._encodedAuth()
          }, t.prototype.getStoreEndpointPath = function() {
            var t = this._dsnObject;
            return (t.path ? "/" + t.path : "") + "/api/" + t.projectId + "/store/"
          }, t.prototype.getRequestHeaders = function(t, e) {
            var n = this._dsnObject,
              r = ["Sentry sentry_version=7"];
            return r.push("sentry_client=" + t + "/" + e), r.push("sentry_key=" + n.user), n.pass && r.push("sentry_secret=" + n.pass), {
              "Content-Type": "application/json",
              "X-Sentry-Auth": r.join(", ")
            }
          }, t.prototype.getReportDialogEndpoint = function(t) {
            void 0 === t && (t = {});
            var e = this._dsnObject,
              n = this.getBaseApiEndpoint() + "embed/error-page/",
              r = [];
            for (var o in r.push("dsn=" + e.toString()), t)
              if ("user" === o) {
                if (!t.user) continue;
                t.user.name && r.push("name=" + encodeURIComponent(t.user.name)), t.user.email && r.push("email=" + encodeURIComponent(t.user.email))
              } else r.push(encodeURIComponent(o) + "=" + encodeURIComponent(t[o]));
            return r.length ? n + "?" + r.join("&") : n
          }, t.prototype._getEnvelopeEndpoint = function() {
            return this._getIngestEndpoint("envelope")
          }, t.prototype._getIngestEndpoint = function(t) {
            return "" + this.getBaseApiEndpoint() + this._dsnObject.projectId + "/" + t + "/"
          }, t.prototype._encodedAuth = function() {
            return function(e) {
              return Object.keys(e).map(function(t) {
                return encodeURIComponent(t) + "=" + encodeURIComponent(e[t])
              }).join("&")
            }({
              sentry_key: this._dsnObject.user,
              sentry_version: "7"
            })
          }, t
        }(),
        Ht = [];

      function Wt(t) {
        var e = {};
        return function(t) {
          var e = t.defaultIntegrations && s(t.defaultIntegrations) || [],
            n = t.integrations,
            r = [];
          if (Array.isArray(n)) {
            var o = n.map(function(t) {
                return t.name
              }),
              i = [];
            e.forEach(function(t) {
              -1 === o.indexOf(t.name) && -1 === i.indexOf(t.name) && (r.push(t), i.push(t.name))
            }), n.forEach(function(t) {
              -1 === i.indexOf(t.name) && (r.push(t), i.push(t.name))
            })
          } else r = "function" == typeof n ? (r = n(e), Array.isArray(r) ? r : [r]) : s(e);
          var a = r.map(function(t) {
            return t.name
          });
          return -1 !== a.indexOf("Debug") && r.push.apply(r, s(r.splice(a.indexOf("Debug"), 1))), r
        }(t).forEach(function(t) {
          ! function(t) {
            -1 === Ht.indexOf(t.name) && (t.setupOnce(Ot, Nt), Ht.push(t.name), X.log("Integration installed: " + t.name))
          }(e[t.name] = t)
        }), e
      }
      var Gt, qt = function() {
          function t(t, e) {
            this._integrations = {}, this._processing = !1, this._backend = new t(e), (this._options = e).dsn && (this._dsn = new It(e.dsn))
          }
          return t.prototype.captureException = function(t, e, n) {
            var r = this,
              o = e && e.event_id;
            return this._processing = !0, this._getBackend().eventFromException(t, e).then(function(t) {
              o = r.captureEvent(t, e, n)
            }), o
          }, t.prototype.captureMessage = function(t, e, n, r) {
            var o = this,
              i = n && n.event_id;
            return this._processing = !0, (y(t) ? this._getBackend().eventFromMessage("" + t, e, n) : this._getBackend().eventFromException(t, n)).then(function(t) {
              i = o.captureEvent(t, n, r)
            }), i
          }, t.prototype.captureEvent = function(t, e, n) {
            var r = this,
              o = e && e.event_id;
            return this._processing = !0, this._processEvent(t, e, n).then(function(t) {
              o = t && t.event_id, r._processing = !1
            }).then(null, function(t) {
              X.error(t), r._processing = !1
            }), o
          }, t.prototype.getDsn = function() {
            return this._dsn
          }, t.prototype.getOptions = function() {
            return this._options
          }, t.prototype.flush = function(t) {
            var n = this;
            return this._isClientProcessing(t).then(function(e) {
              return clearInterval(e.interval), n._getBackend().getTransport().close(t).then(function(t) {
                return e.ready && t
              })
            })
          }, t.prototype.close = function(t) {
            var e = this;
            return this.flush(t).then(function(t) {
              return e.getOptions().enabled = !1, t
            })
          }, t.prototype.setupIntegrations = function() {
            this._isEnabled() && (this._integrations = Wt(this._options))
          }, t.prototype.getIntegration = function(e) {
            try {
              return this._integrations[e.id] || null
            } catch (t) {
              return X.warn("Cannot retrieve integration " + e.id + " from the current Client"), null
            }
          }, t.prototype._isClientProcessing = function(r) {
            var o = this;
            return new it(function(t) {
              var e = 0,
                n = 0;
              clearInterval(n), n = setInterval(function() {
                o._processing ? (e += 1, r && r <= e && t({
                  interval: n,
                  ready: !1
                })) : t({
                  interval: n,
                  ready: !0
                })
              }, 1)
            })
          }, t.prototype._getBackend = function() {
            return this._backend
          }, t.prototype._isEnabled = function() {
            return !1 !== this.getOptions().enabled && void 0 !== this._dsn
          }, t.prototype._prepareEvent = function(t, e, n) {
            var r = this,
              o = this.getOptions().normalizeDepth,
              i = void 0 === o ? 3 : o,
              a = f(f({}, t), {
                event_id: t.event_id || (n && n.event_id ? n.event_id : j()),
                timestamp: t.timestamp || H()
              });
            this._applyClientOptions(a), this._applyIntegrationsMetadata(a);
            var c = e;
            n && n.captureContext && (c = Tt.clone(c).update(n.captureContext));
            var s = it.resolve(a);
            return c && (s = c.applyToEvent(a, n)), s.then(function(t) {
              return "number" == typeof i && 0 < i ? r._normalizeEvent(t, i) : t
            })
          }, t.prototype._normalizeEvent = function(t, e) {
            if (!t) return null;
            var n = f(f(f(f(f({}, t), t.breadcrumbs && {
              breadcrumbs: t.breadcrumbs.map(function(t) {
                return f(f({}, t), t.data && {
                  data: ot(t.data, e)
                })
              })
            }), t.user && {
              user: ot(t.user, e)
            }), t.contexts && {
              contexts: ot(t.contexts, e)
            }), t.extra && {
              extra: ot(t.extra, e)
            });
            return t.contexts && t.contexts.trace && (n.contexts.trace = t.contexts.trace), n
          }, t.prototype._applyClientOptions = function(t) {
            var e = this.getOptions(),
              n = e.environment,
              r = e.release,
              o = e.dist,
              i = e.maxValueLength,
              a = void 0 === i ? 250 : i;
            void 0 === t.environment && void 0 !== n && (t.environment = n), void 0 === t.release && void 0 !== r && (t.release = r), void 0 === t.dist && void 0 !== o && (t.dist = o), t.message && (t.message = S(t.message, a));
            var c = t.exception && t.exception.values && t.exception.values[0];
            c && c.value && (c.value = S(c.value, a));
            var s = t.request;
            s && s.url && (s.url = S(s.url, a))
          }, t.prototype._applyIntegrationsMetadata = function(t) {
            var e = t.sdk,
              n = Object.keys(this._integrations);
            e && 0 < n.length && (e.integrations = n)
          }, t.prototype._sendEvent = function(t) {
            this._getBackend().sendEvent(t)
          }, t.prototype._processEvent = function(t, i, e) {
            var a = this,
              n = this.getOptions(),
              c = n.beforeSend,
              r = n.sampleRate;
            if (!this._isEnabled()) return it.reject("SDK not enabled, will not send event.");
            var s = "transaction" === t.type;
            return !s && "number" == typeof r && Math.random() > r ? it.reject("This event has been sampled, will not send event.") : new it(function(r, o) {
              a._prepareEvent(t, e, i).then(function(t) {
                if (null !== t) {
                  var e = t;
                  if (i && i.data && !0 === i.data.__sentry__ || !c || s) return a._sendEvent(e), void r(e);
                  var n = c(t, i);
                  if (void 0 === n) X.error("`beforeSend` method has to return `null` or a valid event.");
                  else if (k(n)) a._handleAsyncBeforeSend(n, r, o);
                  else {
                    if (null === (e = n)) return X.log("`beforeSend` returned `null`, will not send event."), void r(null);
                    a._sendEvent(e), r(e)
                  }
                } else o("An event processor returned null, will not send event.")
              }).then(null, function(t) {
                a.captureException(t, {
                  data: {
                    __sentry__: !0
                  },
                  originalException: t
                }), o("Event processing pipeline threw an error, original event will not be sent. Details have been sent as a new event.\nReason: " + t)
              })
            })
          }, t.prototype._handleAsyncBeforeSend = function(t, e, n) {
            var r = this;
            t.then(function(t) {
              null !== t ? (r._sendEvent(t), e(t)) : n("`beforeSend` returned `null`, will not send event.")
            }).then(null, function(t) {
              n("beforeSend rejected with " + t)
            })
          }, t
        }(),
        Vt = function() {
          function t() {}
          return t.prototype.sendEvent = function(t) {
            return it.resolve({
              reason: "NoopTransport: Event has been skipped because no Dsn is configured.",
              status: u.Status.Skipped
            })
          }, t.prototype.close = function(t) {
            return it.resolve(!0)
          }, t
        }(),
        Jt = function() {
          function t(t) {
            this._options = t, this._options.dsn || X.warn("No DSN provided, backend will not do anything."), this._transport = this._setupTransport()
          }
          return t.prototype.eventFromException = function(t, e) {
            throw new v("Backend has to implement `eventFromException` method")
          }, t.prototype.eventFromMessage = function(t, e, n) {
            throw new v("Backend has to implement `eventFromMessage` method")
          }, t.prototype.sendEvent = function(t) {
            this._transport.sendEvent(t).then(null, function(t) {
              X.error("Error while sending event: " + t)
            })
          }, t.prototype.getTransport = function() {
            return this._transport
          }, t.prototype._setupTransport = function() {
            return new Vt
          }, t
        }();

      function Kt(t, e) {
        var n = "transaction" === t.type,
          r = {
            body: JSON.stringify(t),
            url: n ? e.getEnvelopeEndpointWithUrlEncodedAuth() : e.getStoreEndpointWithUrlEncodedAuth()
          };
        if (n) {
          var o = JSON.stringify({
            event_id: t.event_id,
            sent_at: new Date(1e3 * H()).toISOString()
          }) + "\n" + JSON.stringify({
            type: t.type
          }) + "\n" + r.body;
          r.body = o
        }
        return r
      }
      var Yt = function() {
          function t() {
            this.name = t.id
          }
          return t.prototype.setupOnce = function() {
            Gt = Function.prototype.toString, Function.prototype.toString = function() {
              for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
              var n = this.__sentry_original__ || this;
              return Gt.apply(n, t)
            }
          }, t.id = "FunctionToString", t
        }(),
        $t = [/^Script error\.?$/, /^Javascript error: Script error\.? on line 0$/],
        Xt = function() {
          function a(t) {
            void 0 === t && (t = {}), this._options = t, this.name = a.id
          }
          return a.prototype.setupOnce = function() {
            Ot(function(t) {
              var e = Nt();
              if (!e) return t;
              var n = e.getIntegration(a);
              if (n) {
                var r = e.getClient(),
                  o = r ? r.getOptions() : {},
                  i = n._mergeOptions(o);
                if (n._shouldDropEvent(t, i)) return null
              }
              return t
            })
          }, a.prototype._shouldDropEvent = function(t, e) {
            return this._isSentryError(t, e) ? (X.warn("Event dropped due to being internal Sentry Error.\nEvent: " + R(t)), !0) : this._isIgnoredError(t, e) ? (X.warn("Event dropped due to being matched by `ignoreErrors` option.\nEvent: " + R(t)), !0) : this._isDeniedUrl(t, e) ? (X.warn("Event dropped due to being matched by `denyUrls` option.\nEvent: " + R(t) + ".\nUrl: " + this._getEventFilterUrl(t)), !0) : !this._isAllowedUrl(t, e) && (X.warn("Event dropped due to not being matched by `allowUrls` option.\nEvent: " + R(t) + ".\nUrl: " + this._getEventFilterUrl(t)), !0)
          }, a.prototype._isSentryError = function(t, e) {
            if (!e.ignoreInternal) return !1;
            try {
              return t && t.exception && t.exception.values && t.exception.values[0] && "SentryError" === t.exception.values[0].type || !1
            } catch (t) {
              return !1
            }
          }, a.prototype._isIgnoredError = function(t, n) {
            return !(!n.ignoreErrors || !n.ignoreErrors.length) && this._getPossibleEventMessages(t).some(function(e) {
              return n.ignoreErrors.some(function(t) {
                return I(e, t)
              })
            })
          }, a.prototype._isDeniedUrl = function(t, e) {
            if (!e.denyUrls || !e.denyUrls.length) return !1;
            var n = this._getEventFilterUrl(t);
            return !!n && e.denyUrls.some(function(t) {
              return I(n, t)
            })
          }, a.prototype._isAllowedUrl = function(t, e) {
            if (!e.allowUrls || !e.allowUrls.length) return !0;
            var n = this._getEventFilterUrl(t);
            return !n || e.allowUrls.some(function(t) {
              return I(n, t)
            })
          }, a.prototype._mergeOptions = function(t) {
            return void 0 === t && (t = {}), {
              allowUrls: s(this._options.whitelistUrls || [], this._options.allowUrls || [], t.whitelistUrls || [], t.allowUrls || []),
              denyUrls: s(this._options.blacklistUrls || [], this._options.denyUrls || [], t.blacklistUrls || [], t.denyUrls || []),
              ignoreErrors: s(this._options.ignoreErrors || [], t.ignoreErrors || [], $t),
              ignoreInternal: void 0 === this._options.ignoreInternal || this._options.ignoreInternal
            }
          }, a.prototype._getPossibleEventMessages = function(e) {
            if (e.message) return [e.message];
            if (e.exception) try {
              var t = e.exception.values && e.exception.values[0] || {},
                n = t.type,
                r = void 0 === n ? "" : n,
                o = t.value,
                i = void 0 === o ? "" : o;
              return ["" + i, r + ": " + i]
            } catch (t) {
              return X.error("Cannot extract message for event " + R(e)), []
            }
            return []
          }, a.prototype._getEventFilterUrl = function(e) {
            try {
              if (e.stacktrace) {
                var t = e.stacktrace.frames;
                return t && t[t.length - 1].filename || null
              }
              if (e.exception) {
                var n = e.exception.values && e.exception.values[0].stacktrace && e.exception.values[0].stacktrace.frames;
                return n && n[n.length - 1].filename || null
              }
              return null
            } catch (t) {
              return X.error("Cannot extract url for event " + R(e)), null
            }
          }, a.id = "InboundFilters", a
        }(),
        Zt = Object.freeze({
          __proto__: null,
          FunctionToString: Yt,
          InboundFilters: Xt
        }),
        Qt = "?",
        te = /^\s*at (?:(.*?) ?\()?((?:file|https?|blob|chrome-extension|address|native|eval|webpack|<anonymous>|[-a-z]+:|.*bundle|\/).*?)(?::(\d+))?(?::(\d+))?\)?\s*$/i,
        ee = /^\s*(.*?)(?:\((.*?)\))?(?:^|@)?((?:file|https?|blob|chrome|webpack|resource|moz-extension|capacitor).*?:\/.*?|\[native code\]|[^@]*(?:bundle|\d+\.js))(?::(\d+))?(?::(\d+))?\s*$/i,
        ne = /^\s*at (?:((?:\[object object\])?.+) )?\(?((?:file|ms-appx|https?|webpack|blob):.*?):(\d+)(?::(\d+))?\)?\s*$/i,
        re = /(\S+) line (\d+)(?: > eval line \d+)* > eval/i,
        oe = /\((\S*)(?::(\d+))(?::(\d+))\)/,
        ie = /Minified React error #\d+;/i;

      function ae(t) {
        var e = null,
          n = 0;
        t && ("number" == typeof t.framesToPop ? n = t.framesToPop : ie.test(t.message) && (n = 1));
        try {
          if (e = function(t) {
              if (!t || !t.stacktrace) return null;
              for (var e, n = t.stacktrace, r = / line (\d+).*script (?:in )?(\S+)(?:: in function (\S+))?$/i, o = / line (\d+), column (\d+)\s*(?:in (?:<anonymous function: ([^>]+)>|([^)]+))\((.*)\))? in (.*):\s*$/i, i = n.split("\n"), a = [], c = 0; c < i.length; c += 2) {
                var s = null;
                (e = r.exec(i[c])) ? s = {
                  url: e[2],
                  func: e[3],
                  args: [],
                  line: +e[1],
                  column: null
                }: (e = o.exec(i[c])) && (s = {
                  url: e[6],
                  func: e[3] || e[4],
                  args: e[5] ? e[5].split(",") : [],
                  line: +e[1],
                  column: +e[2]
                }), s && (!s.func && s.line && (s.func = Qt), a.push(s))
              }
              return a.length ? {
                message: se(t),
                name: t.name,
                stack: a
              } : null
            }(t)) return ce(e, n)
        } catch (t) {}
        try {
          if (e = function(t) {
              if (!t || !t.stack) return null;
              for (var e, n, r, o = [], i = t.stack.split("\n"), a = 0; a < i.length; ++a) {
                if (n = te.exec(i[a])) {
                  var c = n[2] && 0 === n[2].indexOf("native");
                  n[2] && 0 === n[2].indexOf("eval") && (e = oe.exec(n[2])) && (n[2] = e[1], n[3] = e[2], n[4] = e[3]), r = {
                    url: n[2] && 0 === n[2].indexOf("address at ") ? n[2].substr("address at ".length) : n[2],
                    func: n[1] || Qt,
                    args: c ? [n[2]] : [],
                    line: n[3] ? +n[3] : null,
                    column: n[4] ? +n[4] : null
                  }
                } else if (n = ne.exec(i[a])) r = {
                  url: n[2],
                  func: n[1] || Qt,
                  args: [],
                  line: +n[3],
                  column: n[4] ? +n[4] : null
                };
                else {
                  if (!(n = ee.exec(i[a]))) continue;
                  n[3] && -1 < n[3].indexOf(" > eval") && (e = re.exec(n[3])) ? (n[1] = n[1] || "eval", n[3] = e[1], n[4] = e[2], n[5] = "") : 0 !== a || n[5] || void 0 === t.columnNumber || (o[0].column = t.columnNumber + 1), r = {
                    url: n[3],
                    func: n[1] || Qt,
                    args: n[2] ? n[2].split(",") : [],
                    line: n[4] ? +n[4] : null,
                    column: n[5] ? +n[5] : null
                  }
                }!r.func && r.line && (r.func = Qt), o.push(r)
              }
              return o.length ? {
                message: se(t),
                name: t.name,
                stack: o
              } : null
            }(t)) return ce(e, n)
        } catch (t) {}
        return {
          message: se(t),
          name: t && t.name,
          stack: [],
          failed: !0
        }
      }

      function ce(e, t) {
        try {
          return f(f({}, e), {
            stack: e.stack.slice(t)
          })
        } catch (t) {
          return e
        }
      }

      function se(t) {
        var e = t && t.message;
        return e ? e.error && "string" == typeof e.error.message ? e.error.message : e : "No error message"
      }
      var ue = 50;

      function le(t) {
        var e = de(t.stack),
          n = {
            type: t.name,
            value: t.message
          };
        return e && e.length && (n.stacktrace = {
          frames: e
        }), void 0 === n.type && "" === n.value && (n.value = "Unrecoverable error caught"), n
      }

      function fe(t, e, n) {
        var r = {
          exception: {
            values: [{
              type: b(t) ? t.constructor.name : n ? "UnhandledRejection" : "Error",
              value: "Non-Error " + (n ? "promise rejection" : "exception") + " captured with keys: " + function(t, e) {
                void 0 === e && (e = 40);
                var n = Object.keys(tt(t));
                if (n.sort(), !n.length) return "[object has no keys]";
                if (n[0].length >= e) return S(n[0], e);
                for (var r = n.length; 0 < r; r--) {
                  var o = n.slice(0, r).join(", ");
                  if (!(o.length > e)) return r === n.length ? o : S(o, e)
                }
                return ""
              }(t)
            }]
          },
          extra: {
            __serialized__: function t(e, n, r) {
              void 0 === n && (n = 3), void 0 === r && (r = 102400);
              var o = ot(e, n);
              return et(o) > r ? t(e, n - 1, r) : o
            }(t)
          }
        };
        if (e) {
          var o = de(ae(e).stack);
          r.stacktrace = {
            frames: o
          }
        }
        return r
      }

      function pe(t) {
        return {
          exception: {
            values: [le(t)]
          }
        }
      }

      function de(t) {
        if (!t || !t.length) return [];
        var e = t,
          n = e[0].func || "",
          r = e[e.length - 1].func || "";
        return -1 === n.indexOf("captureMessage") && -1 === n.indexOf("captureException") || (e = e.slice(1)), -1 !== r.indexOf("sentryWrapped") && (e = e.slice(0, -1)), e.slice(0, ue).map(function(t) {
          return {
            colno: null === t.column ? void 0 : t.column,
            filename: t.url || e[0].url,
            function: t.func || "?",
            in_app: !0,
            lineno: null === t.line ? void 0 : t.line
          }
        }).reverse()
      }

      function he(t, e, n) {
        var r = ge(e, n && n.syntheticException || void 0, {
          attachStacktrace: t.attachStacktrace
        });
        return F(r, {
          handled: !0,
          type: "generic"
        }), r.level = u.Severity.Error, n && n.event_id && (r.event_id = n.event_id), it.resolve(r)
      }

      function ve(t, e, n, r) {
        void 0 === n && (n = u.Severity.Info);
        var o = _e(e, r && r.syntheticException || void 0, {
          attachStacktrace: t.attachStacktrace
        });
        return o.level = n, r && r.event_id && (o.event_id = r.event_id), it.resolve(o)
      }

      function ge(t, e, n) {
        var r;
        if (void 0 === n && (n = {}), d(t) && t.error) return r = pe(ae(t = t.error));
        if (g(t) || function(t) {
            return "[object DOMException]" === Object.prototype.toString.call(t)
          }(t)) {
          var o = t,
            i = o.name || (g(o) ? "DOMError" : "DOMException"),
            a = o.message ? i + ": " + o.message : i;
          return N(r = _e(a, e, n), a), r
        }
        return p(t) ? r = pe(ae(t)) : (m(t) || b(t) ? F(r = fe(t, e, n.rejection), {
          synthetic: !0
        }) : (N(r = _e(t, e, n), "" + t, void 0), F(r, {
          synthetic: !0
        })), r)
      }

      function _e(t, e, n) {
        void 0 === n && (n = {});
        var r = {
          message: t
        };
        if (n.attachStacktrace && e) {
          var o = de(ae(e).stack);
          r.stacktrace = {
            frames: o
          }
        }
        return r
      }
      var ye = function() {
          function t(t) {
            this.options = t, this._buffer = new at(30), this._api = new zt(this.options.dsn), this.url = this._api.getStoreEndpointWithUrlEncodedAuth()
          }
          return t.prototype.sendEvent = function(t) {
            throw new v("Transport Class has to implement `sendEvent` method")
          }, t.prototype.close = function(t) {
            return this._buffer.drain(t)
          }, t
        }(),
        me = O(),
        be = function(e) {
          function t() {
            var t = null !== e && e.apply(this, arguments) || this;
            return t._disabledUntil = new Date(Date.now()), t
          }
          return n(t, e), t.prototype.sendEvent = function(t) {
            var a = this;
            if (new Date(Date.now()) < this._disabledUntil) return Promise.reject({
              event: t,
              reason: "Transport locked till " + this._disabledUntil + " due to too many requests.",
              status: 429
            });
            var e = Kt(t, this._api),
              n = {
                body: e.body,
                method: "POST",
                referrerPolicy: function() {
                  if (!ct()) return !1;
                  try {
                    return new Request("_", {
                      referrerPolicy: "origin"
                    }), !0
                  } catch (t) {
                    return !1
                  }
                }() ? "origin" : ""
              };
            return void 0 !== this.options.fetchParameters && Object.assign(n, this.options.fetchParameters), void 0 !== this.options.headers && (n.headers = this.options.headers), this._buffer.add(new it(function(o, i) {
              me.fetch(e.url, n).then(function(t) {
                var e = u.Status.fromHttpCode(t.status);
                if (e !== u.Status.Success) {
                  if (e === u.Status.RateLimit) {
                    var n = Date.now(),
                      r = t.headers.get("Retry-After");
                    a._disabledUntil = new Date(n + W(n, r)), X.warn("Too many requests, backing off till: " + a._disabledUntil)
                  }
                  i(t)
                } else o({
                  status: e
                })
              }).catch(i)
            }))
          }, t
        }(ye),
        xe = function(e) {
          function t() {
            var t = null !== e && e.apply(this, arguments) || this;
            return t._disabledUntil = new Date(Date.now()), t
          }
          return n(t, e), t.prototype.sendEvent = function(t) {
            var a = this;
            if (new Date(Date.now()) < this._disabledUntil) return Promise.reject({
              event: t,
              reason: "Transport locked till " + this._disabledUntil + " due to too many requests.",
              status: 429
            });
            var e = Kt(t, this._api);
            return this._buffer.add(new it(function(r, o) {
              var i = new XMLHttpRequest;
              for (var t in i.onreadystatechange = function() {
                  if (4 === i.readyState) {
                    var t = u.Status.fromHttpCode(i.status);
                    if (t !== u.Status.Success) {
                      if (t === u.Status.RateLimit) {
                        var e = Date.now(),
                          n = i.getResponseHeader("Retry-After");
                        a._disabledUntil = new Date(e + W(e, n)), X.warn("Too many requests, backing off till: " + a._disabledUntil)
                      }
                      o(i)
                    } else r({
                      status: t
                    })
                  }
                }, i.open("POST", e.url), a.options.headers) a.options.headers.hasOwnProperty(t) && i.setRequestHeader(t, a.options.headers[t]);
              i.send(e.body)
            }))
          }, t
        }(ye),
        ke = Object.freeze({
          __proto__: null,
          BaseTransport: ye,
          FetchTransport: be,
          XHRTransport: xe
        }),
        we = function(e) {
          function t() {
            return null !== e && e.apply(this, arguments) || this
          }
          return n(t, e), t.prototype.eventFromException = function(t, e) {
            return he(this._options, t, e)
          }, t.prototype.eventFromMessage = function(t, e, n) {
            return void 0 === e && (e = u.Severity.Info), ve(this._options, t, e, n)
          }, t.prototype._setupTransport = function() {
            if (!this._options.dsn) return e.prototype._setupTransport.call(this);
            var t = f(f({}, this._options.transportOptions), {
              dsn: this._options.dsn
            });
            return this._options.transport ? new this._options.transport(t) : ct() ? new be(t) : new xe(t)
          }, t
        }(Jt),
        Se = 0;

      function Ee() {
        return 0 < Se
      }

      function Ie(e, r, o) {
        if (void 0 === r && (r = {}), "function" != typeof e) return e;
        try {
          if (e.__sentry__) return e;
          if (e.__sentry_wrapped__) return e.__sentry_wrapped__
        } catch (t) {
          return e
        }
        var t = function() {
          var n = Array.prototype.slice.call(arguments);
          try {
            o && "function" == typeof o && o.apply(this, arguments);
            var t = n.map(function(t) {
              return Ie(t, r)
            });
            return e.handleEvent ? e.handleEvent.apply(this, t) : e.apply(this, t)
          } catch (e) {
            throw Se += 1, setTimeout(function() {
              Se -= 1
            }), Bt(function(t) {
              t.addEventProcessor(function(t) {
                var e = f({}, t);
                return r.mechanism && (N(e, void 0, void 0), F(e, r.mechanism)), e.extra = f(f({}, e.extra), {
                  arguments: n
                }), e
              }), Ut(e)
            }), e
          }
        };
        try {
          for (var n in e) Object.prototype.hasOwnProperty.call(e, n) && (t[n] = e[n])
        } catch (t) {}
        e.prototype = e.prototype || {}, t.prototype = e.prototype, Object.defineProperty(e, "__sentry_wrapped__", {
          enumerable: !1,
          value: t
        }), Object.defineProperties(t, {
          __sentry__: {
            enumerable: !1,
            value: !0
          },
          __sentry_original__: {
            enumerable: !1,
            value: e
          }
        });
        try {
          Object.getOwnPropertyDescriptor(t, "name").configurable && Object.defineProperty(t, "name", {
            get: function() {
              return e.name
            }
          })
        } catch (t) {}
        return t
      }

      function Te(t) {
        if (void 0 === t && (t = {}), t.eventId)
          if (t.dsn) {
            var e = document.createElement("script");
            e.async = !0, e.src = new zt(t.dsn).getReportDialogEndpoint(t), t.onLoad && (e.onload = t.onLoad), (document.head || document.body).appendChild(e)
          } else X.error("Missing dsn option in showReportDialog call");
        else X.error("Missing eventId option in showReportDialog call")
      }
      var Pe = function() {
          function s(t) {
            this.name = s.id, this._onErrorHandlerInstalled = !1, this._onUnhandledRejectionHandlerInstalled = !1, this._options = f({
              onerror: !0,
              onunhandledrejection: !0
            }, t)
          }
          return s.prototype.setupOnce = function() {
            Error.stackTraceLimit = 50, this._options.onerror && (X.log("Global Handler attached: onerror"), this._installGlobalOnErrorHandler()), this._options.onunhandledrejection && (X.log("Global Handler attached: onunhandledrejection"), this._installGlobalOnUnhandledRejectionHandler())
          }, s.prototype._installGlobalOnErrorHandler = function() {
            var c = this;
            this._onErrorHandlerInstalled || (ht({
              callback: function(t) {
                var e = t.error,
                  n = Nt(),
                  r = n.getIntegration(s),
                  o = e && !0 === e.__sentry_own_request__;
                if (r && !Ee() && !o) {
                  var i = n.getClient(),
                    a = y(e) ? c._eventFromIncompleteOnError(t.msg, t.url, t.line, t.column) : c._enhanceEventWithInitialFrame(ge(e, void 0, {
                      attachStacktrace: i && i.getOptions().attachStacktrace,
                      rejection: !1
                    }), t.url, t.line, t.column);
                  F(a, {
                    handled: !1,
                    type: "onerror"
                  }), n.captureEvent(a, {
                    originalException: e
                  })
                }
              },
              type: "error"
            }), this._onErrorHandlerInstalled = !0)
          }, s.prototype._installGlobalOnUnhandledRejectionHandler = function() {
            var c = this;
            this._onUnhandledRejectionHandlerInstalled || (ht({
              callback: function(t) {
                var e = t;
                try {
                  "reason" in t ? e = t.reason : "detail" in t && "reason" in t.detail && (e = t.detail.reason)
                } catch (t) {}
                var n = Nt(),
                  r = n.getIntegration(s),
                  o = e && !0 === e.__sentry_own_request__;
                if (!r || Ee() || o) return !0;
                var i = n.getClient(),
                  a = y(e) ? c._eventFromIncompleteRejection(e) : ge(e, void 0, {
                    attachStacktrace: i && i.getOptions().attachStacktrace,
                    rejection: !0
                  });
                a.level = u.Severity.Error, F(a, {
                  handled: !1,
                  type: "onunhandledrejection"
                }), n.captureEvent(a, {
                  originalException: e
                })
              },
              type: "unhandledrejection"
            }), this._onUnhandledRejectionHandlerInstalled = !0)
          }, s.prototype._eventFromIncompleteOnError = function(t, e, n, r) {
            var o, i = d(t) ? t.message : t;
            if (_(i)) {
              var a = i.match(/^(?:[Uu]ncaught (?:exception: )?)?(?:((?:Eval|Internal|Range|Reference|Syntax|Type|URI|)Error): )?(.*)$/i);
              a && (o = a[1], i = a[2])
            }
            var c = {
              exception: {
                values: [{
                  type: o || "Error",
                  value: i
                }]
              }
            };
            return this._enhanceEventWithInitialFrame(c, e, n, r)
          }, s.prototype._eventFromIncompleteRejection = function(t) {
            return {
              exception: {
                values: [{
                  type: "UnhandledRejection",
                  value: "Non-Error promise rejection captured with value: " + t
                }]
              }
            }
          }, s.prototype._enhanceEventWithInitialFrame = function(t, e, n, r) {
            t.exception = t.exception || {}, t.exception.values = t.exception.values || [], t.exception.values[0] = t.exception.values[0] || {}, t.exception.values[0].stacktrace = t.exception.values[0].stacktrace || {}, t.exception.values[0].stacktrace.frames = t.exception.values[0].stacktrace.frames || [];
            var o = isNaN(parseInt(r, 10)) ? void 0 : r,
              i = isNaN(parseInt(n, 10)) ? void 0 : n,
              a = _(e) && 0 < e.length ? e : function() {
                try {
                  return document.location.href
                } catch (t) {
                  return ""
                }
              }();
            return 0 === t.exception.values[0].stacktrace.frames.length && t.exception.values[0].stacktrace.frames.push({
              colno: o,
              filename: a,
              function: "?",
              in_app: !0,
              lineno: i
            }), t
          }, s.id = "GlobalHandlers", s
        }(),
        Oe = ["EventTarget", "Window", "Node", "ApplicationCache", "AudioTrackList", "ChannelMergerNode", "CryptoOperation", "EventSource", "FileReader", "HTMLUnknownElement", "IDBDatabase", "IDBRequest", "IDBTransaction", "KeyOperation", "MediaController", "MessagePort", "ModalWindow", "Notification", "SVGElementInstance", "Screen", "TextTrack", "TextTrackCue", "TextTrackList", "WebSocket", "WebSocketWorker", "Worker", "XMLHttpRequest", "XMLHttpRequestEventTarget", "XMLHttpRequestUpload"],
        je = function() {
          function e(t) {
            this.name = e.id, this._options = f({
              XMLHttpRequest: !0,
              eventTarget: !0,
              requestAnimationFrame: !0,
              setInterval: !0,
              setTimeout: !0
            }, t)
          }
          return e.prototype.setupOnce = function() {
            var t = O();
            (this._options.setTimeout && Q(t, "setTimeout", this._wrapTimeFunction.bind(this)), this._options.setInterval && Q(t, "setInterval", this._wrapTimeFunction.bind(this)), this._options.requestAnimationFrame && Q(t, "requestAnimationFrame", this._wrapRAF.bind(this)), this._options.XMLHttpRequest && "XMLHttpRequest" in t && Q(XMLHttpRequest.prototype, "send", this._wrapXHR.bind(this)), this._options.eventTarget) && (Array.isArray(this._options.eventTarget) ? this._options.eventTarget : Oe).forEach(this._wrapEventTarget.bind(this))
          }, e.prototype._wrapTimeFunction = function(r) {
            return function() {
              for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
              var n = t[0];
              return t[0] = Ie(n, {
                mechanism: {
                  data: {
                    function: q(r)
                  },
                  handled: !0,
                  type: "instrument"
                }
              }), r.apply(this, t)
            }
          }, e.prototype._wrapRAF = function(e) {
            return function(t) {
              return e.call(this, Ie(t, {
                mechanism: {
                  data: {
                    function: "requestAnimationFrame",
                    handler: q(e)
                  },
                  handled: !0,
                  type: "instrument"
                }
              }))
            }
          }, e.prototype._wrapEventTarget = function(o) {
            var t = O(),
              e = t[o] && t[o].prototype;
            e && e.hasOwnProperty && e.hasOwnProperty("addEventListener") && (Q(e, "addEventListener", function(r) {
              return function(t, e, n) {
                try {
                  "function" == typeof e.handleEvent && (e.handleEvent = Ie(e.handleEvent.bind(e), {
                    mechanism: {
                      data: {
                        function: "handleEvent",
                        handler: q(e),
                        target: o
                      },
                      handled: !0,
                      type: "instrument"
                    }
                  }))
                } catch (t) {}
                return r.call(this, t, Ie(e, {
                  mechanism: {
                    data: {
                      function: "addEventListener",
                      handler: q(e),
                      target: o
                    },
                    handled: !0,
                    type: "instrument"
                  }
                }), n)
              }
            }), Q(e, "removeEventListener", function(r) {
              return function(t, e, n) {
                try {
                  r.call(this, t, e.__sentry_wrapped__, n)
                } catch (t) {}
                return r.call(this, t, e, n)
              }
            }))
          }, e.prototype._wrapXHR = function(n) {
            return function() {
              for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
              var r = this;
              return ["onload", "onerror", "onprogress", "onreadystatechange"].forEach(function(n) {
                n in r && "function" == typeof r[n] && Q(r, n, function(t) {
                  var e = {
                    mechanism: {
                      data: {
                        function: n,
                        handler: q(t)
                      },
                      handled: !0,
                      type: "instrument"
                    }
                  };
                  return t.__sentry_original__ && (e.mechanism.data.handler = q(t.__sentry_original__)), Ie(t, e)
                })
              }), n.apply(this, t)
            }
          }, e.id = "TryCatch", e
        }(),
        Ce = function() {
          function e(t) {
            this.name = e.id, this._options = f({
              console: !0,
              dom: !0,
              fetch: !0,
              history: !0,
              sentry: !0,
              xhr: !0
            }, t)
          }
          return e.prototype.addSentryBreadcrumb = function(t) {
            this._options.sentry && Nt().addBreadcrumb({
              category: "sentry." + ("transaction" === t.type ? "transaction" : "event"),
              event_id: t.event_id,
              level: t.level,
              message: R(t)
            }, {
              event: t
            })
          }, e.prototype.setupOnce = function() {
            var n = this;
            this._options.console && ht({
              callback: function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                n._consoleBreadcrumb.apply(n, s(t))
              },
              type: "console"
            }), this._options.dom && ht({
              callback: function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                n._domBreadcrumb.apply(n, s(t))
              },
              type: "dom"
            }), this._options.xhr && ht({
              callback: function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                n._xhrBreadcrumb.apply(n, s(t))
              },
              type: "xhr"
            }), this._options.fetch && ht({
              callback: function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                n._fetchBreadcrumb.apply(n, s(t))
              },
              type: "fetch"
            }), this._options.history && ht({
              callback: function() {
                for (var t = [], e = 0; e < arguments.length; e++) t[e] = arguments[e];
                n._historyBreadcrumb.apply(n, s(t))
              },
              type: "history"
            })
          }, e.prototype._consoleBreadcrumb = function(t) {
            var e = {
              category: "console",
              data: {
                arguments: t.args,
                logger: "console"
              },
              level: u.Severity.fromString(t.level),
              message: E(t.args, " ")
            };
            if ("assert" === t.level) {
              if (!1 !== t.args[0]) return;
              e.message = "Assertion failed: " + (E(t.args.slice(1), " ") || "console.assert"), e.data.arguments = t.args.slice(1)
            }
            Nt().addBreadcrumb(e, {
              input: t.args,
              level: t.level
            })
          }, e.prototype._domBreadcrumb = function(t) {
            var e;
            try {
              e = t.event.target ? L(t.event.target) : L(t.event)
            } catch (t) {
              e = "<unknown>"
            }
            0 !== e.length && Nt().addBreadcrumb({
              category: "ui." + t.name,
              message: e
            }, {
              event: t.event,
              name: t.name
            })
          }, e.prototype._xhrBreadcrumb = function(t) {
            if (t.endTimestamp) {
              if (t.xhr.__sentry_own_request__) return;
              Nt().addBreadcrumb({
                category: "xhr",
                data: t.xhr.__sentry_xhr__,
                type: "http"
              }, {
                xhr: t.xhr
              })
            } else;
          }, e.prototype._fetchBreadcrumb = function(t) {
            t.endTimestamp && (t.fetchData.url.match(/sentry_key/) && "POST" === t.fetchData.method || (t.error ? Nt().addBreadcrumb({
              category: "fetch",
              data: t.fetchData,
              level: u.Severity.Error,
              type: "http"
            }, {
              data: t.error,
              input: t.args
            }) : Nt().addBreadcrumb({
              category: "fetch",
              data: f(f({}, t.fetchData), {
                status_code: t.response.status
              }),
              type: "http"
            }, {
              input: t.args,
              response: t.response
            })))
          }, e.prototype._historyBreadcrumb = function(t) {
            var e = O(),
              n = t.from,
              r = t.to,
              o = C(e.location.href),
              i = C(n),
              a = C(r);
            i.path || (i = o), o.protocol === a.protocol && o.host === a.host && (r = a.relative), o.protocol === i.protocol && o.host === i.host && (n = i.relative), Nt().addBreadcrumb({
              category: "navigation",
              data: {
                from: n,
                to: r
              }
            })
          }, e.id = "Breadcrumbs", e
        }(),
        Re = function() {
          function r(t) {
            void 0 === t && (t = {}), this.name = r.id, this._key = t.key || "cause", this._limit = t.limit || 5
          }
          return r.prototype.setupOnce = function() {
            Ot(function(t, e) {
              var n = Nt().getIntegration(r);
              return n ? n._handler(t, e) : t
            })
          }, r.prototype._handler = function(t, e) {
            if (!(t.exception && t.exception.values && e && w(e.originalException, Error))) return t;
            var n = this._walkErrorTree(e.originalException, this._key);
            return t.exception.values = s(n, t.exception.values), t
          }, r.prototype._walkErrorTree = function(t, e, n) {
            if (void 0 === n && (n = []), !w(t[e], Error) || n.length + 1 >= this._limit) return n;
            var r = le(ae(t[e]));
            return this._walkErrorTree(t[e], e, s([r], n))
          }, r.id = "LinkedErrors", r
        }(),
        Me = O(),
        Ne = function() {
          function n() {
            this.name = n.id
          }
          return n.prototype.setupOnce = function() {
            Ot(function(t) {
              if (Nt().getIntegration(n)) {
                if (!Me.navigator || !Me.location) return t;
                var e = t.request || {};
                return e.url = e.url || Me.location.href, e.headers = e.headers || {}, e.headers["User-Agent"] = Me.navigator.userAgent, f(f({}, t), {
                  request: e
                })
              }
              return t
            })
          }, n.id = "UserAgent", n
        }(),
        Fe = Object.freeze({
          __proto__: null,
          GlobalHandlers: Pe,
          TryCatch: je,
          Breadcrumbs: Ce,
          LinkedErrors: Re,
          UserAgent: Ne
        }),
        Le = "sentry.javascript.browser",
        Ae = "5.22.0",
        De = function(r) {
          function t(t) {
            return void 0 === t && (t = {}), r.call(this, we, t) || this
          }
          return n(t, r), t.prototype.showReportDialog = function(t) {
            void 0 === t && (t = {}), O().document && (this._isEnabled() ? Te(f(f({}, t), {
              dsn: t.dsn || this.getDsn()
            })) : X.error("Trying to call showReportDialog with Sentry Client disabled"))
          }, t.prototype._prepareEvent = function(t, e, n) {
            return t.platform = t.platform || "javascript", t.sdk = f(f({}, t.sdk), {
              name: Le,
              packages: s(t.sdk && t.sdk.packages || [], [{
                name: "npm:@sentry/browser",
                version: Ae
              }]),
              version: Ae
            }), r.prototype._prepareEvent.call(this, t, e, n)
          }, t.prototype._sendEvent = function(t) {
            var e = this.getIntegration(Ce);
            e && e.addSentryBreadcrumb(t), r.prototype._sendEvent.call(this, t)
          }, t
        }(qt),
        Ue = [new Xt, new Yt, new je, new Ce, new Pe, new Re, new Ne];
      var Be = {},
        ze = O();
      ze.Sentry && ze.Sentry.Integrations && (Be = ze.Sentry.Integrations);
      var He = f(f(f({}, Be), Zt), Fe);
      return u.BrowserClient = De, u.Hub = Ct, u.Integrations = He, u.SDK_NAME = Le, u.SDK_VERSION = Ae, u.Scope = Tt, u.Transports = ke, u.addBreadcrumb = function(t) {
        Dt("addBreadcrumb", t)
      }, u.addGlobalEventProcessor = Ot, u.captureEvent = function(t) {
        return Dt("captureEvent", t)
      }, u.captureException = Ut, u.captureMessage = function(t, e) {
        var n;
        try {
          throw new Error(t)
        } catch (t) {
          n = t
        }
        return Dt("captureMessage", t, "string" == typeof e ? e : void 0, f({
          originalException: t,
          syntheticException: n
        }, "string" != typeof e ? {
          captureContext: e
        } : void 0))
      }, u.close = function(t) {
        var e = Nt().getClient();
        return e ? e.close(t) : it.reject(!1)
      }, u.configureScope = function(t) {
        Dt("configureScope", t)
      }, u.defaultIntegrations = Ue, u.eventFromException = he, u.eventFromMessage = ve, u.flush = function(t) {
        var e = Nt().getClient();
        return e ? e.flush(t) : it.reject(!1)
      }, u.forceLoad = function() {}, u.getCurrentHub = Nt, u.getHubFromCarrier = Lt, u.init = function(t) {
        if (void 0 === t && (t = {}), void 0 === t.defaultIntegrations && (t.defaultIntegrations = Ue), void 0 === t.release) {
          var e = O();
          e.SENTRY_RELEASE && e.SENTRY_RELEASE.id && (t.release = e.SENTRY_RELEASE.id)
        }! function(t, e) {
          !0 === e.debug && X.enable();
          var n = Nt(),
            r = new t(e);
          n.bindClient(r)
        }(De, t)
      }, u.injectReportDialog = Te, u.lastEventId = function() {
        return Nt().lastEventId()
      }, u.makeMain = Mt, u.onLoad = function(t) {
        t()
      }, u.setContext = function(t, e) {
        Dt("setContext", t, e)
      }, u.setExtra = function(t, e) {
        Dt("setExtra", t, e)
      }, u.setExtras = function(t) {
        Dt("setExtras", t)
      }, u.setTag = function(t, e) {
        Dt("setTag", t, e)
      }, u.setTags = function(t) {
        Dt("setTags", t)
      }, u.setUser = function(t) {
        Dt("setUser", t)
      }, u.showReportDialog = function(t) {
        void 0 === t && (t = {}), t.eventId || (t.eventId = Nt().lastEventId());
        var e = Nt().getClient();
        e && e.showReportDialog(t)
      }, u.startTransaction = function(t) {
        return Dt("startTransaction", f({}, t))
      }, u.withScope = Bt, u.wrap = function(t) {
        return Ie(t)()
      }, u
    }({});
  Math.random();
  
  // ============================================================
  // 섹션: 에디터 브릿지 (Qe) - iframe 통신 관리자
  // 역할: 에디터 iframe 생성, URL 파라미터 구성, postMessage 기반 양방향 통신
  // base_url: 운영=edicusbase.firebaseapp.com, 개발=edicus-stage.firebaseapp.com
  // ============================================================
(Qe = {
    base_url: "https://edicusbase.firebaseapp.com",
    landing_path: "/ed#/editor_landing",
    tnview_path: "/ed#/tnview/landing",
    preview_path: "/ed#/preview/landing",
    lite_path: "/ed#/lite/landing",
    target_callback: null,
    iframe_el: null,
    messageListener: null,
    ddp_block: null,
    private_css: null,
    prod_info: null,
    options: null,
    option_string: null,
    data_row: null,
    data_feed: null,
    zoom: null,
    size_option: null,
    rsc_option: null,
    template_list: null
  }).base_url = "https://edicusbase.firebaseapp.com", Qe.dev_base_url = "https://edicus-stage.firebaseapp.com", Qe._lastUpdatedAt = "20210609", Qe.init = function(t, e) {
    var i = this;
    Qe._isDev = t, Qe.base_url = t ? Qe.dev_base_url : Qe.base_url, e && (Qe.base_url = e), We.__KOI_EVENT_LISNTER_INITIALIZE || (i.messageListener = function(t) {
      if (t.data && "string" == typeof t.data && t.data.match(/^{.*}$/g)) {
        var e = JSON.parse(t.data);
        if (e)
          if ("from-edicus" == e.type || "from-edicus-root" == e.type || "from-edicus-tnview" == e.type) i.target_callback && i.target_callback(null, e);
          else if ("from-edicus-private" == e.type)
          if ("waiting-for-extra-param" == e.action) {
            for (var n = [], r = 0; r < e.info.param_names.length; r++) "ddp_block" == e.info.param_names[r] ? n.push({
              name: "ddp_block",
              ddp_block: i.ddp_block
            }) : "private_css" == e.info.param_names[r] ? n.push({
              name: "private_css",
              private_css: i.private_css
            }) : "prod_info" == e.info.param_names[r] ? n.push({
              name: "prod_info",
              prod_info: i.prod_info
            }) : "options" == e.info.param_names[r] ? n.push({
              name: "options",
              options: i.options
            }) : "option_string" == e.info.param_names[r] ? n.push({
              name: "option_string",
              option_string: i.option_string
            }) : "data_row" == e.info.param_names[r] ? n.push({
              name: "data_row",
              data_row: i.data_row
            }) : "data_feed" == e.info.param_names[r] ? n.push({
              name: "data_feed",
              data_feed: i.data_feed
            }) : "zoom" == e.info.param_names[r] ? n.push({
              name: "zoom",
              zoom: i.zoom
            }) : "size_option" == e.info.param_names[r] ? n.push({
              name: "size_option",
              size_option: i.size_option
            }) : "rsc_option" == e.info.param_names[r] ? n.push({
              name: "rsc_option",
              rsc_option: i.rsc_option
            }) : "template_list" == e.info.param_names[r] && n.push({
              name: "template_list",
              zoom: i.template_list
            });
            var o = {
              type: "to-edicus-root",
              action: "send-extra-param",
              info: {
                params: n
              }
            };
            i.iframe_el.contentWindow.postMessage(JSON.stringify(o), "*")
          } else if ("waiting-for-ddp-data" == e.action) {
          o = {
            type: "to-edicus-root",
            action: "send-ddp-data",
            info: {
              ddp_block: i.ddp_block
            }
          };
          i.iframe_el.contentWindow.postMessage(JSON.stringify(o), "*")
        }
      }
    }, We.addEventListener("message", i.messageListener, !1), We.__KOI_EVENT_LISNTER_INITIALIZE = !0)
  }, Qe.destroy = function(t, e) {
    e && this.messageListener && (We.removeEventListener("message", this.messageListener, !1), this.messageListener = null, We.__KOI_EVENT_LISNTER_INITIALIZE = !1), this.iframe_el && t && t.firstElementChild && (t.removeChild(this.iframe_el), this.iframe_el = null)
  }, Qe.open_portal = function(t, e) {
    var n = this.base_url + "/ed#/editor_portal?cmd=open_portal&token=" + t.token;
    this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe._add_common_url_param = function(t, e) {
    return t += (e.partner ? "&partner=" + e.partner : "") + (e.mobile ? "&mobile=" + e.mobile : "") + (e.div ? "&div=" + e.div : "") + (e.lang ? "&lang=" + e.lang : "") + (e.ui_locale ? "&ui_locale=" + e.ui_locale : "") + (e.editor_type ? "&editor_type=" + e.editor_type : "") + (e.parent_type ? "&parent_type=" + e.parent_type : "") + (this._isDev ? "&env_mode=dev" : "") + (e.run_mode ? "&run_mode=" + e.run_mode : "") + (e.master_mode ? "&master_mode=" + e.master_mode : "") + (e.edit_mode ? "&edit_mode=" + e.edit_mode : "") + (e.ui_style ? "&ui_style=" + e.ui_style : "") + (e.num_page ? "&num_page=" + e.num_page : "") + (e.max_page ? "&max_page=" + e.max_page : "") + (e.min_page ? "&min_page=" + e.min_page : "") + (e.unit_page ? "&unit_page=" + e.unit_page : "") + (e.max_order ? "&max_order=" + e.max_order : "") + (e.min_order ? "&min_order=" + e.min_order : "") + (e.force_plugin ? "&force_plugin=" + e.force_plugin : "") + (e.plugin_param ? "&plugin_param=" + e.plugin_param : "") + (e.resapi_param ? "&resapi_param=" + e.resapi_param : "") + (e.unlayers ? "&unlayers=" + e.unlayers : "") + (e.edit_lock ? "&edit_lock=" + e.edit_lock : "") + (e.no_update ? "&no_update=" + e.no_update : "") + (e.clear_src ? "&clear_src=" + e.clear_src : "") + (e.cal_date ? "&cal_date=" + e.cal_date : "") + (e.video_frames ? "&video_frames=" + e.video_frames : "") + (e.ddp_block ? "&wait_ddp=true" : "") + (e.private_css ? "&wait_private_css=true" : "") + (e.prod_info ? "&wait_prod_info=true" : "") + (e.options ? "&wait_options=true" : "") + (e.option_string ? "&wait_option_string=true" : "") + (e.dev_apiHost ? "&dev_apiHost=" + e.dev_apiHost : "") + (e.dev_assetHost ? "&dev_assetHost=" + e.dev_assetHost : "") + (e.dev_uploadHost ? "&dev_uploadHost=" + e.dev_uploadHost : "") + (e.dev_resHost ? "&dev_resHost=" + e.dev_resHost : "")
  }, Qe.create_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=create&token=" + t.token + "&ps_code=" + t.ps_code + "&title=" + encodeURIComponent(t.title) + (t.template_uri ? "&template_uri=" + t.template_uri : "") + (t.content_uri ? "&content_uri=" + t.content_uri : "");
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.open_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=open&token=" + t.token + "&prjid=" + t.prjid;
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.edit_template = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=edit-template&token=" + t.token + "&ps_code=" + t.ps_code + (t.prjid ? "&prjid=" + t.prjid : "") + (t.template_uri ? "&template_uri=" + t.template_uri : "");
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.create_design_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=create-design-project&token=" + t.token + "&ps_code=" + t.ps_code + "&title=" + encodeURIComponent(t.title) + (t.template_uri ? "&template_uri=" + t.template_uri : "");
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.open_design_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=open-design-project&token=" + t.token + "&prjid=" + t.prjid;
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.recycle_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=recycle&token=" + t.token + "&prjid=" + t.prjid + "&title=" + encodeURIComponent(t.title);
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.reform_project = function(t, e) {
    var n = this.base_url + this.landing_path + "?cmd=reform&token=" + t.token + "&prjid=" + t.prjid + "&ps_code=" + t.ps_code;
    this.target_callback = e, n = this._add_common_url_param(n, t), this._set_deferred_params(t), this._build_iframe(n, t.parent_element)
  }, Qe.change_project = function(t) {
    var e = {
      type: "to-edicus-root",
      action: "change-project",
      info: {
        project_id: t
      }
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(e), "*")
  }, Qe.change_template = function(t, e) {
    var n = {
      type: "to-edicus-root",
      action: "change-template",
      info: {
        ps_code: t,
        template_uri: e
      }
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(n), "*")
  }, Qe.change_layout = function(t, e, n) {
    var r = {
      type: "to-edicus",
      action: "change-layout",
      info: {
        layout_uri: t,
        page_index: e || 0,
        change_background_if_available: n
      }
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(r), "*")
  }, Qe.execute_ddp_block = function(t, e) {
    var n = {
      ddp_block: t,
      history_label: e
    };
    We.edicusSDK.post_to_editor("execute-ddp-block", n)
  }, Qe.open_preview = function(t, e) {
    var n = this.base_url + this.preview_path + "?cmd=open&token=" + t.token + "&partner=" + t.partner + "&uid=" + t.uid + "&prjid=" + t.prjid + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&npage=" + (t.npage || 1) + "&flow=" + (t.flow || "horizontal") + (t.options ? "&wait_options=true" : "") + (t.data_row ? "&wait_data_row=true" : "") + (t.zoom ? "&wait_zoom=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.show_tnview = function(t, e) {
    var n = this.base_url + this.tnview_path + "?cmd=show&token=" + t.token + "&ps_code=" + t.ps_code + "&template_uri=" + t.template_uri + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&npage=" + (t.npage || 1) + "&flow=" + (t.flow || "horizontal") + (t.options ? "&wait_options=true" : "") + (t.data_row ? "&wait_data_row=true" : "") + (t.zoom ? "&wait_zoom=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.create_tnview = function(t, e) {
    var n = this.base_url + this.tnview_path + "?cmd=create&token=" + t.token + "&ps_code=" + t.ps_code + "&template_uri=" + t.template_uri + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&npage=" + (t.npage || 1) + "&flow=" + (t.flow || "horizontal") + (t.options ? "&wait_options=true" : "") + (t.data_row ? "&wait_data_row=true" : "") + (t.zoom ? "&wait_zoom=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.open_tnview = function(t, e) {
    var n = this.base_url + this.tnview_path + "?cmd=open&token=" + t.token + "&prjid=" + t.prjid + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&npage=" + (t.npage || 1) + "&flow=" + (t.flow || "horizontal") + (t.options ? "&wait_options=true" : "") + (t.data_row ? "&wait_data_row=true" : "") + (t.zoom ? "&wait_zoom=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.show_gallery = function(t, e) {
    var n = this.base_url + this.tnview_path + "?cmd=gallery&token=" + t.token + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + (t.options ? "&wait_options=true" : "") + (t.data_feed ? "&wait_data_feed=true" : "") + (t.data_row ? "&wait_data_row=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.create_lite_project = function(t, e) {
    var n = this.base_url + this.lite_path + "?cmd=create&token=" + t.token + "&ps_code=" + t.ps_code + "&template_uri=" + t.template_uri + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&uilocale=" + (t.uilocale || "ko") + (t.private_css ? "&wait_private_css=true" : "") + (t.prod_info ? "&wait_prod_info=true" : "") + (t.size_option ? "&wait_size_option=true" : "") + (t.rsc_option ? "&wait_rsc_option=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.open_lite_project = function(t, e) {
    var n = this.base_url + this.lite_path + "?cmd=open&token=" + t.token + "&prjid=" + t.prjid + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&uilocale=" + (t.uilocale || "ko") + (t.private_css ? "&wait_private_css=true" : "") + (t.prod_info ? "&wait_prod_info=true" : "") + (t.size_option ? "&wait_size_option=true" : "") + (t.rsc_option ? "&wait_rsc_option=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.show_lite_editor = function(t, e) {
    var n = this.base_url + this.lite_path + "?cmd=show&token=" + t.token + "&ps_code=" + t.ps_code + "&template_uri=" + t.template_uri + "&div=" + (t.div || "host") + "&lang=" + (t.lang || "ko") + "&uilocale=" + (t.uilocale || "ko") + (t.private_css ? "&wait_private_css=true" : "") + (t.prod_info ? "&wait_prod_info=true" : "") + (t.size_option ? "&wait_size_option=true" : "") + (t.rsc_option ? "&wait_rsc_option=true" : "");
    this._set_deferred_params(t), this._build_iframe(n, t.parent_element), this.target_callback = e
  }, Qe.post_to_editor = function(t, e) {
    var n = {
      type: "to-edicus",
      action: t,
      info: e
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(n), "*")
  }, Qe.post_to_tnview = function(t, e) {
    var n = {
      type: "to-edicus-tnview",
      action: t,
      info: e
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(n), "*")
  }, Qe.post_to_preview = function(t, e) {
    var n = {
      type: "to-edicus-preview",
      action: t,
      info: e
    };
    this.iframe_el.contentWindow.postMessage(JSON.stringify(n), "*")
  }, Qe._build_iframe = function(t, e) {
    this.iframe_el = document.createElement("iframe"), this.iframe_el.setAttribute("src", t), this.iframe_el.setAttribute("frameborder", 0), this.iframe_el.style.width = "100%", this.iframe_el.style.height = "100%", e.appendChild(this.iframe_el)
  }, Qe._set_deferred_params = function(t) {
    t.ddp_block ? (console.log("detect_ddp", t.ddp_block), this.ddp_block = t.ddp_block) : this.ddp_block = null, t.private_css ? this.private_css = t.private_css : this.private_css = null, t.prod_info ? (console.log("detect_prod_info", t.prod_info), this.prod_info = t.prod_info) : this.prod_info = null, t.options ? (console.log("detect_options", t.options), this.options = t.options) : this.options = null, t.data_feed ? (console.log("detect_date_feed", t.data_feed), this.data_feed = t.data_feed) : this.data_feed = null, t.data_row ? (console.log("detect_initial_data_row", t.data_row), this.data_row = t.data_row) : this.data_row = null, t.zoom ? (console.log("detect_zoom", t.zoom), this.zoom = t.zoom) : this.zoom = null, t.show3d ? (console.log("detect_show3d", t.show3d), this.show3d = t.show3d) : this.show3d = null, t.size_option ? (console.log("detect_size_option", t.size_option), this.size_option = t.size_option) : this.size_option = null, t.rsc_option ? (console.log("detect_rsc_option", t.rsc_option), this.rsc_option = t.rsc_option) : this.rsc_option = null, t.template_list ? (console.log("detect_template_list", t.template_list), this.template_list = t.template_list) : this.template_list = null, t.option_string ? this.option_string = t.option_string : this.option_string = null
  };
  
  // ============================================================
  // 섹션: API 클라이언트 (a) - 레드프린팅 makers API HTTP 통신
  // 엔드포인트: makers.redprinting.net (운영) / dev.makers.redprinting.net (개발)
  // 인증: red-editor-token 헤더 사용
  // 메서드: getToken, setToken, call, getProductList, getTemplateList,
  //         getResourceList, getResourceWithId, updateTemplateCount,
  //         verifyToken, refreshAccessToken, autoRefreshToken, getProjectOwnerId
  // ============================================================
var a = function() {
    function n(t, e) {
      _classCallCheck(this, n), this.baseUrl = "product" === e ? "https://makers.redprinting.net/" : "dev" === e ? "https://dev.makers.redprinting.net/" : "http://172.17.6.47:6500/", this.token = t
    }
    return _createClass(n, [{
      key: "getToken",
      value: function() {
        return this.token
      }
    }, {
      
        // ---- 인증 메서드 (5개) ----
        /**
         * API 액세스 토큰을 변경한다.
         * @param {string} t - 새 액세스 토큰
         */
        key: "setToken",
      value: function(t) {
        this.token = t
      }
    }, {
      key: "call",
      value: function(t, e, n) {
        var r = this,
          o = new FormData;
        o.append("target", t), o.append("uid", D("userId")), o.append("email", D("email")), o.append("staffCode", D("staffCode")), ["projectThumbnail", "deleteProject", "tentativeOrder", "definitiveOrder", "getProductInfo", "cloneProject", "isReadyToOrder"].includes(t) ? (e ? o.append("collectionId", e) : o.append("collectionId", D("projectId")), "cloneProject" === t && (n.projectOwnerId && o.append("projectOwnerId", n.projectOwnerId), n = null)) : "cancelOrder" === t && o.append("collectionId", D("orderId")), n && o.append("qry", JSON.stringify(n));
        var i = r.baseUrl + "editor";
        return new Promise(function(t, e) {
          var n = new XMLHttpRequest;
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(JSON.parse(n.responseText)) : 4 == n.readyState && 200 != n.status && e({
              code: n.status,
              message: JSON.parse(n.responseText)
            })
          }, n.open("POST", i), n.setRequestHeader("red-editor-token", r.token), n.send(o)
        })
      }
    }, {
      
        /**
         * 전체 상품 목록을 조회한다.
         * @param {Function} r - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getProductList",
      value: function() {
        var o = this;
        return new Promise(function(t, e) {
          var n = new XMLHttpRequest,
            r = o.baseUrl + "v1/templates";
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(JSON.parse(n.responseText)) : 4 == n.readyState && 200 != n.status && e(new Error(n.statusText))
          }, n.open("GET", r), n.setRequestHeader("red-editor-token", o.token), n.send()
        })
      }
    }, {
      key: "getTemplateList",
      value: function(o, i) {
        var a = this;
        return new Promise(function(t, e) {
          var n = new XMLHttpRequest,
            r = a.baseUrl + "v1/templates/" + o + ("function" == typeof i || 0 === Object.keys(i).length ? "" : c(i));
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(JSON.parse(n.responseText)) : 4 == n.readyState && 200 != n.status && e(new Error(n.statusText))
          }, n.open("GET", r), n.setRequestHeader("red-editor-token", a.token), n.send()
        })
      }
    }, {
      
        /**
         * 리소스 목록을 조회한다.
         * @param {string} r - 상품 코드
         * @param {Object} o - 리소스 쿼리 { resourceType 필수 }
         * @param {Object|Function} e - 필터 또는 콜백
         * @param {Function} i - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getResourceList",
      value: function(t, e, o) {
        var i = this;
        return e.productCode = t, o = _extends({}, o, e), new Promise(function(t, e) {
          var n = new XMLHttpRequest,
            r = i.baseUrl + "v1/resources/resource/query" + ("function" == typeof o || 0 === Object.keys(o).length ? "" : c(o));
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(JSON.parse(n.responseText)) : 4 == n.readyState && 200 != n.status && e(new Error(n.statusText))
          }, n.open("GET", r), n.setRequestHeader("red-editor-token", i.token), n.send()
        })
      }
    }, {
      
        /**
         * ID로 단일 리소스를 조회한다.
         * @param {string} r - 리소스 ID
         * @param {Function} o - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getResourceWithId",
      value: function(o) {
        var i = this;
        return new Promise(function(t, e) {
          var n = new XMLHttpRequest,
            r = i.baseUrl + "v2/template/resource/" + o;
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(JSON.parse(n.responseText)) : 4 == n.readyState && 200 != n.status && e(new Error(n.statusText))
          }, n.open("GET", r), n.setRequestHeader("red-editor-token", i.token), n.send()
        })
      }
    }, {
      key: "updateTemplateCount",
      value: function(o, i) {
        var a = this;
        return new Promise(function(t, e) {
          var n = new XMLHttpRequest,
            r = a.baseUrl + "v1/template/" + btoa(o) + "/" + i;
          n.onreadystatechange = function() {
            4 == n.readyState && 200 == n.status ? t(n.responseText) : 4 == n.readyState && 200 != n.status && e(n.statusText)
          }, n.open("PUT", r), n.setRequestHeader("red-editor-token", a.token), n.send()
        })
      }
    }, {
      key: "verifyToken",
      value: function() {
        var e = this,
          n = new XMLHttpRequest,
          t = this.baseUrl + "token";
        n.onreadystatechange = function() {
          if (4 == n.readyState && 200 == n.status) {
            var t = JSON.parse(n.responseText).refreshToken;
            e.refreshToken = t
          }
        }, n.open("POST", t), n.setRequestHeader("content-type", "application/json"), n.setRequestHeader("red-editor-token", this.token);
        n.send(JSON.stringify({
          type: "verify"
        }))
      }
    }, {
      key: "refreshAccessToken",
      value: function(r) {
        var o = this,
          i = new XMLHttpRequest,
          t = this.baseUrl + "token";
        i.onreadystatechange = function() {
          if (4 == i.readyState && 200 == i.status) {
            var t = JSON.parse(i.responseText),
              e = t.token,
              n = t.refreshToken;
            o.token = e, o.refreshToken = n, r && r(null, {
              token: e,
              refreshToken: n
            })
          }
        }, i.open("POST", t), i.setRequestHeader("content-type", "application/json"), i.setRequestHeader("red-editor-token", this.token);
        var e = {
          type: "refresh",
          refreshToken: this.refreshToken
        };
        i.send(JSON.stringify(e))
      }
    }, {
      key: "autoRefreshToken",
      value: function(t) {
        var e = this;
        setInterval(function() {
          e.refreshAccessToken(t)
        }, 3e6)
      }
    }, {
      
        /**
         * 프로젝트의 소유자 ID를 조회한다.
         * @param {string} t - 프로젝트 ID
         * @param {Function} e - 콜백 (error, data)
         * @returns {Promise<Object>|void}
         */
        key: "getProjectOwnerId",
      value: function(o) {
        var i = this;
        return new Promise(function(e, n) {
          var r = new XMLHttpRequest,
            t = i.baseUrl + "v1/project/" + o + "/ownerId";
          r.onreadystatechange = function() {
            if (4 == r.readyState && 200 == r.status) {
              var t = JSON.parse(r.responseText);
              e(t)
            } else 4 == r.readyState && 200 != r.status && n(r.statusText)
          }, r.open("GET", t), r.setRequestHeader("red-editor-token", i.token), r.send()
        })
      }
    }]), n
  }();
  
  // ============================================================
  // 섹션: Babel 폴리필 + regeneratorRuntime (서드파티, 리네이밍 제외)
  // 역할: async/await 구문 지원을 위한 regenerator 런타임
  // ============================================================
We._babelPolyfill || ! function i(a, c, s) {
    function u(e, t) {
      if (!c[e]) {
        if (!a[e]) {
          var n = "function" == typeof require && require;
          if (!t && n) return n(e, !0);
          if (l) return l(e, !0);
          var r = new Error("Cannot find module '" + e + "'");
          throw r.code = "MODULE_NOT_FOUND", r
        }
        var o = c[e] = {
          exports: {}
        };
        a[e][0].call(o.exports, function(t) {
          return u(a[e][1][t] || t)
        }, o, o.exports, i, a, c, s)
      }
      return c[e].exports
    }
    for (var l = "function" == typeof require && require, t = 0; t < s.length; t++) u(s[t]);
    return u
  }({
    1: [function(n, t, e) {
      (function(t) {
        function e(t, e, n) {
          t[e] || Object.defineProperty(t, e, {
            writable: !0,
            configurable: !0,
            value: n
          })
        }
        if (n(327), n(328), n(2), t._babelPolyfill) throw new Error("only one instance of babel-polyfill is allowed");
        t._babelPolyfill = !0, e(String.prototype, "padLeft", "".padStart), e(String.prototype, "padRight", "".padEnd), "pop,reverse,shift,keys,values,entries,indexOf,every,some,forEach,map,filter,find,findIndex,includes,join,slice,concat,push,splice,unshift,sort,lastIndexOf,reduce,reduceRight,copyWithin,fill".split(",").forEach(function(t) {
          [][t] && e(Array, t, Function.call.bind([][t]))
        })
      }).call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : void 0 !== We ? We : {})
    }, {
      2: 2,
      327: 327,
      328: 328
    }],
    2: [function(t, e, n) {
      t(130), e.exports = t(23).RegExp.escape
    }, {
      130: 130,
      23: 23
    }],
    3: [function(t, e, n) {
      e.exports = function(t) {
        if ("function" != typeof t) throw TypeError(t + " is not a function!");
        return t
      }
    }, {}],
    4: [function(t, e, n) {
      var r = t(18);
      e.exports = function(t, e) {
        if ("number" != typeof t && "Number" != r(t)) throw TypeError(e);
        return +t
      }
    }, {
      18: 18
    }],
    5: [function(t, e, n) {
      var r = t(128)("unscopables"),
        o = Array.prototype;
      null == o[r] && t(42)(o, r, {}), e.exports = function(t) {
        o[r][t] = !0
      }
    }, {
      128: 128,
      42: 42
    }],
    6: [function(t, e, n) {
      e.exports = function(t, e, n, r) {
        if (!(t instanceof e) || void 0 !== r && r in t) throw TypeError(n + ": incorrect invocation!");
        return t
      }
    }, {}],
    7: [function(t, e, n) {
      var r = t(51);
      e.exports = function(t) {
        if (!r(t)) throw TypeError(t + " is not an object!");
        return t
      }
    }, {
      51: 51
    }],
    8: [function(t, e, n) {
      var u = t(119),
        l = t(114),
        f = t(118);
      e.exports = [].copyWithin || function(t, e) {
        var n = u(this),
          r = f(n.length),
          o = l(t, r),
          i = l(e, r),
          a = 2 < arguments.length ? arguments[2] : void 0,
          c = Math.min((void 0 === a ? r : l(a, r)) - i, r - o),
          s = 1;
        for (i < o && o < i + c && (s = -1, i += c - 1, o += c - 1); 0 < c--;) i in n ? n[o] = n[i] : delete n[o], o += s, i += s;
        return n
      }
    }, {
      114: 114,
      118: 118,
      119: 119
    }],
    9: [function(t, e, n) {
      var c = t(119),
        s = t(114),
        u = t(118);
      e.exports = function(t) {
        for (var e = c(this), n = u(e.length), r = arguments.length, o = s(1 < r ? arguments[1] : void 0, n), i = 2 < r ? arguments[2] : void 0, a = void 0 === i ? n : s(i, n); o < a;) e[o++] = t;
        return e
      }
    }, {
      114: 114,
      118: 118,
      119: 119
    }],
    10: [function(t, e, n) {
      var r = t(39);
      e.exports = function(t, e) {
        var n = [];
        return r(t, !1, n.push, n, e), n
      }
    }, {
      39: 39
    }],
    11: [function(t, e, n) {
      var s = t(117),
        u = t(118),
        l = t(114);
      e.exports = function(c) {
        return function(t, e, n) {
          var r, o = s(t),
            i = u(o.length),
            a = l(n, i);
          if (c && e != e) {
            for (; a < i;)
              if ((r = o[a++]) != r) return !0
          } else
            for (; a < i; a++)
              if ((c || a in o) && o[a] === e) return c || a || 0;
          return !c && -1
        }
      }
    }, {
      114: 114,
      117: 117,
      118: 118
    }],
    12: [function(t, e, n) {
      var m = t(25),
        b = t(47),
        x = t(119),
        k = t(118),
        r = t(15);
      e.exports = function(f, t) {
        var p = 1 == f,
          d = 2 == f,
          h = 3 == f,
          v = 4 == f,
          g = 6 == f,
          _ = 5 == f || g,
          y = t || r;
        return function(t, e, n) {
          for (var r, o, i = x(t), a = b(i), c = m(e, n, 3), s = k(a.length), u = 0, l = p ? y(t, s) : d ? y(t, 0) : void 0; u < s; u++)
            if ((_ || u in a) && (o = c(r = a[u], u, i), f))
              if (p) l[u] = o;
              else if (o) switch (f) {
            case 3:
              return !0;
            case 5:
              return r;
            case 6:
              return u;
            case 2:
              l.push(r)
          } else if (v) return !1;
          return g ? -1 : h || v ? v : l
        }
      }
    }, {
      118: 118,
      119: 119,
      15: 15,
      25: 25,
      47: 47
    }],
    13: [function(t, e, n) {
      var l = t(3),
        f = t(119),
        p = t(47),
        d = t(118);
      e.exports = function(t, e, n, r, o) {
        l(e);
        var i = f(t),
          a = p(i),
          c = d(i.length),
          s = o ? c - 1 : 0,
          u = o ? -1 : 1;
        if (n < 2)
          for (;;) {
            if (s in a) {
              r = a[s], s += u;
              break
            }
            if (s += u, o ? s < 0 : c <= s) throw TypeError("Reduce of empty array with no initial value")
          }
        for (; o ? 0 <= s : s < c; s += u) s in a && (r = e(r, a[s], s, i));
        return r
      }
    }, {
      118: 118,
      119: 119,
      3: 3,
      47: 47
    }],
    14: [function(t, e, n) {
      var r = t(51),
        o = t(49),
        i = t(128)("species");
      e.exports = function(t) {
        var e;
        return o(t) && ("function" != typeof(e = t.constructor) || e !== Array && !o(e.prototype) || (e = void 0), r(e) && null === (e = e[i]) && (e = void 0)), void 0 === e ? Array : e
      }
    }, {
      128: 128,
      49: 49,
      51: 51
    }],
    15: [function(t, e, n) {
      var r = t(14);
      e.exports = function(t, e) {
        return new(r(t))(e)
      }
    }, {
      14: 14
    }],
    16: [function(t, e, n) {
      var i = t(3),
        a = t(51),
        c = t(46),
        s = [].slice,
        u = {};
      e.exports = Function.bind || function(n) {
        var r = i(this),
          o = s.call(arguments, 1),
          t = function t() {
            var e = o.concat(s.call(arguments));
            return this instanceof t ? function(t, e, n) {
              if (!(e in u)) {
                for (var r = [], o = 0; o < e; o++) r[o] = "a[" + o + "]";
                u[e] = Function("F,a", "return new F(" + r.join(",") + ")")
              }
              return u[e](t, n)
            }(r, e.length, e) : c(r, e, n)
          };
        return a(r.prototype) && (t.prototype = r.prototype), t
      }
    }, {
      3: 3,
      46: 46,
      51: 51
    }],
    17: [function(t, e, n) {
      var o = t(18),
        i = t(128)("toStringTag"),
        a = "Arguments" == o(function() {
          return arguments
        }());
      e.exports = function(t) {
        var e, n, r;
        return void 0 === t ? "Undefined" : null === t ? "Null" : "string" == typeof(n = function(t, e) {
          try {
            return t[e]
          } catch (t) {}
        }(e = Object(t), i)) ? n : a ? o(e) : "Object" == (r = o(e)) && "function" == typeof e.callee ? "Arguments" : r
      }
    }, {
      128: 128,
      18: 18
    }],
    18: [function(t, e, n) {
      var r = {}.toString;
      e.exports = function(t) {
        return r.call(t).slice(8, -1)
      }
    }, {}],
    19: [function(t, e, n) {
      var a = t(72).f,
        c = t(71),
        s = t(93),
        u = t(25),
        l = t(6),
        f = t(39),
        r = t(55),
        o = t(57),
        i = t(100),
        p = t(29),
        d = t(66).fastKey,
        h = t(125),
        v = p ? "_s" : "size",
        g = function(t, e) {
          var n, r = d(e);
          if ("F" !== r) return t._i[r];
          for (n = t._f; n; n = n.n)
            if (n.k == e) return n
        };
      e.exports = {
        getConstructor: function(t, i, n, r) {
          var o = t(function(t, e) {
            l(t, o, i, "_i"), t._t = i, t._i = c(null), t._f = void 0, t._l = void 0, t[v] = 0, null != e && f(e, n, t[r], t)
          });
          return s(o.prototype, {
            clear: function() {
              for (var t = h(this, i), e = t._i, n = t._f; n; n = n.n) n.r = !0, n.p && (n.p = n.p.n = void 0), delete e[n.i];
              t._f = t._l = void 0, t[v] = 0
            },
            delete: function(t) {
              var e = h(this, i),
                n = g(e, t);
              if (n) {
                var r = n.n,
                  o = n.p;
                delete e._i[n.i], n.r = !0, o && (o.n = r), r && (r.p = o), e._f == n && (e._f = r), e._l == n && (e._l = o), e[v]--
              }
              return !!n
            },
            forEach: function(t) {
              h(this, i);
              for (var e, n = u(t, 1 < arguments.length ? arguments[1] : void 0, 3); e = e ? e.n : this._f;)
                for (n(e.v, e.k, this); e && e.r;) e = e.p
            },
            has: function(t) {
              return !!g(h(this, i), t)
            }
          }), p && a(o.prototype, "size", {
            get: function() {
              return h(this, i)[v]
            }
          }), o
        },
        def: function(t, e, n) {
          var r, o, i = g(t, e);
          return i ? i.v = n : (t._l = i = {
            i: o = d(e, !0),
            k: e,
            v: n,
            p: r = t._l,
            n: void 0,
            r: !1
          }, t._f || (t._f = i), r && (r.n = i), t[v]++, "F" !== o && (t._i[o] = i)), t
        },
        getEntry: g,
        setStrong: function(t, n, e) {
          r(t, n, function(t, e) {
            this._t = h(t, n), this._k = e, this._l = void 0
          }, function() {
            for (var t = this, e = t._k, n = t._l; n && n.r;) n = n.p;
            return t._t && (t._l = n = n ? n.n : t._t._f) ? o(0, "keys" == e ? n.k : "values" == e ? n.v : [n.k, n.v]) : (t._t = void 0, o(1))
          }, e ? "entries" : "values", !e, !0), i(n)
        }
      }
    }, {
      100: 100,
      125: 125,
      25: 25,
      29: 29,
      39: 39,
      55: 55,
      57: 57,
      6: 6,
      66: 66,
      71: 71,
      72: 72,
      93: 93
    }],
    20: [function(t, e, n) {
      var r = t(17),
        o = t(10);
      e.exports = function(t) {
        return function() {
          if (r(this) != t) throw TypeError(t + "#toJSON isn't generic");
          return o(this)
        }
      }
    }, {
      10: 10,
      17: 17
    }],
    21: [function(t, e, n) {
      var a = t(93),
        c = t(66).getWeak,
        o = t(7),
        s = t(51),
        u = t(6),
        l = t(39),
        r = t(12),
        f = t(41),
        p = t(125),
        i = r(5),
        d = r(6),
        h = 0,
        v = function(t) {
          return t._l || (t._l = new g)
        },
        g = function() {
          this.a = []
        },
        _ = function(t, e) {
          return i(t.a, function(t) {
            return t[0] === e
          })
        };
      g.prototype = {
        get: function(t) {
          var e = _(this, t);
          if (e) return e[1]
        },
        has: function(t) {
          return !!_(this, t)
        },
        set: function(t, e) {
          var n = _(this, t);
          n ? n[1] = e : this.a.push([t, e])
        },
        delete: function(e) {
          var t = d(this.a, function(t) {
            return t[0] === e
          });
          return ~t && this.a.splice(t, 1), !!~t
        }
      }, e.exports = {
        getConstructor: function(t, n, r, o) {
          var i = t(function(t, e) {
            u(t, i, n, "_i"), t._t = n, t._i = h++, t._l = void 0, null != e && l(e, r, t[o], t)
          });
          return a(i.prototype, {
            delete: function(t) {
              if (!s(t)) return !1;
              var e = c(t);
              return !0 === e ? v(p(this, n)).delete(t) : e && f(e, this._i) && delete e[this._i]
            },
            has: function(t) {
              if (!s(t)) return !1;
              var e = c(t);
              return !0 === e ? v(p(this, n)).has(t) : e && f(e, this._i)
            }
          }), i
        },
        def: function(t, e, n) {
          var r = c(o(e), !0);
          return !0 === r ? v(t).set(e, n) : r[t._i] = n, t
        },
        ufstore: v
      }
    }, {
      12: 12,
      125: 125,
      39: 39,
      41: 41,
      51: 51,
      6: 6,
      66: 66,
      7: 7,
      93: 93
    }],
    22: [function(t, e, n) {
      var _ = t(40),
        y = t(33),
        m = t(94),
        b = t(93),
        x = t(66),
        k = t(39),
        w = t(6),
        S = t(51),
        E = t(35),
        I = t(56),
        T = t(101),
        P = t(45);
      e.exports = function(r, t, e, n, o, i) {
        var a = _[r],
          c = a,
          s = o ? "set" : "add",
          u = c && c.prototype,
          l = {},
          f = function(t) {
            var n = u[t];
            m(u, t, "delete" == t ? function(t) {
              return !(i && !S(t)) && n.call(this, 0 === t ? 0 : t)
            } : "has" == t ? function(t) {
              return !(i && !S(t)) && n.call(this, 0 === t ? 0 : t)
            } : "get" == t ? function(t) {
              return i && !S(t) ? void 0 : n.call(this, 0 === t ? 0 : t)
            } : "add" == t ? function(t) {
              return n.call(this, 0 === t ? 0 : t), this
            } : function(t, e) {
              return n.call(this, 0 === t ? 0 : t, e), this
            })
          };
        if ("function" == typeof c && (i || u.forEach && !E(function() {
            (new c).entries().next()
          }))) {
          var p = new c,
            d = p[s](i ? {} : -0, 1) != p,
            h = E(function() {
              p.has(1)
            }),
            v = I(function(t) {
              new c(t)
            }),
            g = !i && E(function() {
              for (var t = new c, e = 5; e--;) t[s](e, e);
              return !t.has(-0)
            });
          v || (((c = t(function(t, e) {
            w(t, c, r);
            var n = P(new a, t, c);
            return null != e && k(e, o, n[s], n), n
          })).prototype = u).constructor = c), (h || g) && (f("delete"), f("has"), o && f("get")), (g || d) && f(s), i && u.clear && delete u.clear
        } else c = n.getConstructor(t, r, o, s), b(c.prototype, e), x.NEED = !0;
        return T(c, r), l[r] = c, y(y.G + y.W + y.F * (c != a), l), i || n.setStrong(c, r, o), c
      }
    }, {
      101: 101,
      33: 33,
      35: 35,
      39: 39,
      40: 40,
      45: 45,
      51: 51,
      56: 56,
      6: 6,
      66: 66,
      93: 93,
      94: 94
    }],
    23: [function(t, e, n) {
      var r = e.exports = {
        version: "2.5.0"
      };
      "number" == typeof __e && (__e = r)
    }, {}],
    24: [function(t, e, n) {
      var r = t(72),
        o = t(92);
      e.exports = function(t, e, n) {
        e in t ? r.f(t, e, o(0, n)) : t[e] = n
      }
    }, {
      72: 72,
      92: 92
    }],
    25: [function(t, e, n) {
      var i = t(3);
      e.exports = function(r, o, t) {
        if (i(r), void 0 === o) return r;
        switch (t) {
          case 1:
            return function(t) {
              return r.call(o, t)
            };
          case 2:
            return function(t, e) {
              return r.call(o, t, e)
            };
          case 3:
            return function(t, e, n) {
              return r.call(o, t, e, n)
            }
        }
        return function() {
          return r.apply(o, arguments)
        }
      }
    }, {
      3: 3
    }],
    26: [function(t, e, n) {
      var r = t(35),
        o = Date.prototype.getTime,
        i = Date.prototype.toISOString,
        a = function(t) {
          return 9 < t ? t : "0" + t
        };
      e.exports = r(function() {
        return "0385-07-25T07:06:39.999Z" != i.call(new Date(-5e13 - 1))
      }) || !r(function() {
        i.call(new Date(NaN))
      }) ? function() {
        if (!isFinite(o.call(this))) throw RangeError("Invalid time value");
        var t = this,
          e = t.getUTCFullYear(),
          n = t.getUTCMilliseconds(),
          r = e < 0 ? "-" : 9999 < e ? "+" : "";
        return r + ("00000" + Math.abs(e)).slice(r ? -6 : -4) + "-" + a(t.getUTCMonth() + 1) + "-" + a(t.getUTCDate()) + "T" + a(t.getUTCHours()) + ":" + a(t.getUTCMinutes()) + ":" + a(t.getUTCSeconds()) + "." + (99 < n ? n : "0" + a(n)) + "Z"
      } : i
    }, {
      35: 35
    }],
    27: [function(t, e, n) {
      var r = t(7),
        o = t(120);
      e.exports = function(t) {
        if ("string" !== t && "number" !== t && "default" !== t) throw TypeError("Incorrect hint");
        return o(r(this), "number" != t)
      }
    }, {
      120: 120,
      7: 7
    }],
    28: [function(t, e, n) {
      e.exports = function(t) {
        if (null == t) throw TypeError("Can't call method on  " + t);
        return t
      }
    }, {}],
    29: [function(t, e, n) {
      e.exports = !t(35)(function() {
        return 7 != Object.defineProperty({}, "a", {
          get: function() {
            return 7
          }
        }).a
      })
    }, {
      35: 35
    }],
    30: [function(t, e, n) {
      var r = t(51),
        o = t(40).document,
        i = r(o) && r(o.createElement);
      e.exports = function(t) {
        return i ? o.createElement(t) : {}
      }
    }, {
      40: 40,
      51: 51
    }],
    31: [function(t, e, n) {
      e.exports = "constructor,hasOwnProperty,isPrototypeOf,propertyIsEnumerable,toLocaleString,toString,valueOf".split(",")
    }, {}],
    32: [function(t, e, n) {
      var c = t(81),
        s = t(78),
        u = t(82);
      e.exports = function(t) {
        var e = c(t),
          n = s.f;
        if (n)
          for (var r, o = n(t), i = u.f, a = 0; o.length > a;) i.call(t, r = o[a++]) && e.push(r);
        return e
      }
    }, {
      78: 78,
      81: 81,
      82: 82
    }],
    33: [function(t, e, n) {
      var v = t(40),
        g = t(23),
        _ = t(42),
        y = t(94),
        m = t(25),
        r = function t(e, n, r) {
          var o, i, a, c, s = e & t.F,
            u = e & t.G,
            l = e & t.P,
            f = e & t.B,
            p = u ? v : e & t.S ? v[n] || (v[n] = {}) : (v[n] || {}).prototype,
            d = u ? g : g[n] || (g[n] = {}),
            h = d.prototype || (d.prototype = {});
          for (o in u && (r = n), r) a = ((i = !s && p && void 0 !== p[o]) ? p : r)[o], c = f && i ? m(a, v) : l && "function" == typeof a ? m(Function.call, a) : a, p && y(p, o, a, e & t.U), d[o] != a && _(d, o, c), l && h[o] != a && (h[o] = a)
        };
      v.core = g, r.F = 1, r.G = 2, r.S = 4, r.P = 8, r.B = 16, r.W = 32, r.U = 64, r.R = 128, e.exports = r
    }, {
      23: 23,
      25: 25,
      40: 40,
      42: 42,
      94: 94
    }],
    34: [function(t, e, n) {
      var r = t(128)("match");
      e.exports = function(e) {
        var n = /./;
        try {
          "/./" [e](n)
        } catch (t) {
          try {
            return n[r] = !1, !"/./" [e](n)
          } catch (e) {}
        }
        return !0
      }
    }, {
      128: 128
    }],
    35: [function(t, e, n) {
      e.exports = function(t) {
        try {
          return !!t()
        } catch (t) {
          return !0
        }
      }
    }, {}],
    36: [function(t, e, n) {
      var c = t(42),
        s = t(94),
        u = t(35),
        l = t(28),
        f = t(128);
      e.exports = function(e, t, n) {
        var r = f(e),
          o = n(l, r, "" [e]),
          i = o[0],
          a = o[1];
        u(function() {
          var t = {};
          return t[r] = function() {
            return 7
          }, 7 != "" [e](t)
        }) && (s(String.prototype, e, i), c(RegExp.prototype, r, 2 == t ? function(t, e) {
          return a.call(t, this, e)
        } : function(t) {
          return a.call(t, this)
        }))
      }
    }, {
      128: 128,
      28: 28,
      35: 35,
      42: 42,
      94: 94
    }],
    37: [function(t, e, n) {
      var r = t(7);
      e.exports = function() {
        var t = r(this),
          e = "";
        return t.global && (e += "g"), t.ignoreCase && (e += "i"), t.multiline && (e += "m"), t.unicode && (e += "u"), t.sticky && (e += "y"), e
      }
    }, {
      7: 7
    }],
    38: [function(t, e, n) {
      var h = t(49),
        v = t(51),
        g = t(118),
        _ = t(25),
        y = t(128)("isConcatSpreadable");
      e.exports = function t(e, n, r, o, i, a, c, s) {
        for (var u, l, f = i, p = 0, d = !!c && _(c, s, 3); p < o;) {
          if (p in r) {
            if (u = d ? d(r[p], p, n) : r[p], l = !1, v(u) && (l = void 0 !== (l = u[y]) ? !!l : h(u)), l && 0 < a) f = t(e, n, u, g(u.length), f, a - 1) - 1;
            else {
              if (9007199254740991 <= f) throw TypeError();
              e[f] = u
            }
            f++
          }
          p++
        }
        return f
      }
    }, {
      118: 118,
      128: 128,
      25: 25,
      49: 49,
      51: 51
    }],
    39: [function(t, e, n) {
      var p = t(25),
        d = t(53),
        h = t(48),
        v = t(7),
        g = t(118),
        _ = t(129),
        y = {},
        m = {};
      (n = e.exports = function(t, e, n, r, o) {
        var i, a, c, s, u = o ? function() {
            return t
          } : _(t),
          l = p(n, r, e ? 2 : 1),
          f = 0;
        if ("function" != typeof u) throw TypeError(t + " is not iterable!");
        if (h(u)) {
          for (i = g(t.length); f < i; f++)
            if ((s = e ? l(v(a = t[f])[0], a[1]) : l(t[f])) === y || s === m) return s
        } else
          for (c = u.call(t); !(a = c.next()).done;)
            if ((s = d(c, l, a.value, e)) === y || s === m) return s
      }).BREAK = y, n.RETURN = m
    }, {
      118: 118,
      129: 129,
      25: 25,
      48: 48,
      53: 53,
      7: 7
    }],
    40: [function(t, e, n) {
      var r = e.exports = void 0 !== We && We.Math == Math ? We : "undefined" != typeof self && self.Math == Math ? self : Function("return this")();
      "number" == typeof __g && (__g = r)
    }, {}],
    41: [function(t, e, n) {
      var r = {}.hasOwnProperty;
      e.exports = function(t, e) {
        return r.call(t, e)
      }
    }, {}],
    42: [function(t, e, n) {
      var r = t(72),
        o = t(92);
      e.exports = t(29) ? function(t, e, n) {
        return r.f(t, e, o(1, n))
      } : function(t, e, n) {
        return t[e] = n, t
      }
    }, {
      29: 29,
      72: 72,
      92: 92
    }],
    43: [function(t, e, n) {
      var r = t(40).document;
      e.exports = r && r.documentElement
    }, {
      40: 40
    }],
    44: [function(t, e, n) {
      e.exports = !t(29) && !t(35)(function() {
        return 7 != Object.defineProperty(t(30)("div"), "a", {
          get: function() {
            return 7
          }
        }).a
      })
    }, {
      29: 29,
      30: 30,
      35: 35
    }],
    45: [function(t, e, n) {
      var i = t(51),
        a = t(99).set;
      e.exports = function(t, e, n) {
        var r, o = e.constructor;
        return o !== n && "function" == typeof o && (r = o.prototype) !== n.prototype && i(r) && a && a(t, r), t
      }
    }, {
      51: 51,
      99: 99
    }],
    46: [function(t, e, n) {
      e.exports = function(t, e, n) {
        var r = void 0 === n;
        switch (e.length) {
          case 0:
            return r ? t() : t.call(n);
          case 1:
            return r ? t(e[0]) : t.call(n, e[0]);
          case 2:
            return r ? t(e[0], e[1]) : t.call(n, e[0], e[1]);
          case 3:
            return r ? t(e[0], e[1], e[2]) : t.call(n, e[0], e[1], e[2]);
          case 4:
            return r ? t(e[0], e[1], e[2], e[3]) : t.call(n, e[0], e[1], e[2], e[3])
        }
        return t.apply(n, e)
      }
    }, {}],
    47: [function(t, e, n) {
      var r = t(18);
      e.exports = Object("z").propertyIsEnumerable(0) ? Object : function(t) {
        return "String" == r(t) ? t.split("") : Object(t)
      }
    }, {
      18: 18
    }],
    48: [function(t, e, n) {
      var r = t(58),
        o = t(128)("iterator"),
        i = Array.prototype;
      e.exports = function(t) {
        return void 0 !== t && (r.Array === t || i[o] === t)
      }
    }, {
      128: 128,
      58: 58
    }],
    49: [function(t, e, n) {
      var r = t(18);
      e.exports = Array.isArray || function(t) {
        return "Array" == r(t)
      }
    }, {
      18: 18
    }],
    50: [function(t, e, n) {
      var r = t(51),
        o = Math.floor;
      e.exports = function(t) {
        return !r(t) && isFinite(t) && o(t) === t
      }
    }, {
      51: 51
    }],
    51: [function(t, e, n) {
      e.exports = function(t) {
        return "object" == (void 0 === t ? "undefined" : _typeof(t)) ? null !== t : "function" == typeof t
      }
    }, {}],
    52: [function(t, e, n) {
      var r = t(51),
        o = t(18),
        i = t(128)("match");
      e.exports = function(t) {
        var e;
        return r(t) && (void 0 !== (e = t[i]) ? !!e : "RegExp" == o(t))
      }
    }, {
      128: 128,
      18: 18,
      51: 51
    }],
    53: [function(t, e, n) {
      var i = t(7);
      e.exports = function(t, e, n, r) {
        try {
          return r ? e(i(n)[0], n[1]) : e(n)
        } catch (e) {
          var o = t.return;
          throw void 0 !== o && i(o.call(t)), e
        }
      }
    }, {
      7: 7
    }],
    54: [function(t, e, n) {
      var r = t(71),
        o = t(92),
        i = t(101),
        a = {};
      t(42)(a, t(128)("iterator"), function() {
        return this
      }), e.exports = function(t, e, n) {
        t.prototype = r(a, {
          next: o(1, n)
        }), i(t, e + " Iterator")
      }
    }, {
      101: 101,
      128: 128,
      42: 42,
      71: 71,
      92: 92
    }],
    55: [function(t, e, n) {
      var m = t(60),
        b = t(33),
        x = t(94),
        k = t(42),
        w = t(41),
        S = t(58),
        E = t(54),
        I = t(101),
        T = t(79),
        P = t(128)("iterator"),
        O = !([].keys && "next" in [].keys()),
        j = function() {
          return this
        };
      e.exports = function(t, e, n, r, o, i, a) {
        E(n, e, r);
        var c, s, u, l = function(t) {
            if (!O && t in h) return h[t];
            switch (t) {
              case "keys":
              case "values":
                return function() {
                  return new n(this, t)
                }
            }
            return function() {
              return new n(this, t)
            }
          },
          f = e + " Iterator",
          p = "values" == o,
          d = !1,
          h = t.prototype,
          v = h[P] || h["@@iterator"] || o && h[o],
          g = v || l(o),
          _ = o ? p ? l("entries") : g : void 0,
          y = "Array" == e && h.entries || v;
        if (y && (u = T(y.call(new t))) !== Object.prototype && u.next && (I(u, f, !0), m || w(u, P) || k(u, P, j)), p && v && "values" !== v.name && (d = !0, g = function() {
            return v.call(this)
          }), m && !a || !O && !d && h[P] || k(h, P, g), S[e] = g, S[f] = j, o)
          if (c = {
              values: p ? g : l("values"),
              keys: i ? g : l("keys"),
              entries: _
            }, a)
            for (s in c) s in h || x(h, s, c[s]);
          else b(b.P + b.F * (O || d), e, c);
        return c
      }
    }, {
      101: 101,
      128: 128,
      33: 33,
      41: 41,
      42: 42,
      54: 54,
      58: 58,
      60: 60,
      79: 79,
      94: 94
    }],
    56: [function(t, e, n) {
      var i = t(128)("iterator"),
        a = !1;
      try {
        var r = [7][i]();
        r.return = function() {
          a = !0
        }, Array.from(r, function() {
          throw 2
        })
      } catch (t) {}
      e.exports = function(t, e) {
        if (!e && !a) return !1;
        var n = !1;
        try {
          var r = [7],
            o = r[i]();
          o.next = function() {
            return {
              done: n = !0
            }
          }, r[i] = function() {
            return o
          }, t(r)
        } catch (t) {}
        return n
      }
    }, {
      128: 128
    }],
    57: [function(t, e, n) {
      e.exports = function(t, e) {
        return {
          value: e,
          done: !!t
        }
      }
    }, {}],
    58: [function(t, e, n) {
      e.exports = {}
    }, {}],
    59: [function(t, e, n) {
      var c = t(81),
        s = t(117);
      e.exports = function(t, e) {
        for (var n, r = s(t), o = c(r), i = o.length, a = 0; a < i;)
          if (r[n = o[a++]] === e) return n
      }
    }, {
      117: 117,
      81: 81
    }],
    60: [function(t, e, n) {
      e.exports = !1
    }, {}],
    61: [function(t, e, n) {
      var r = Math.expm1;
      e.exports = !r || 22025.465794806718 < r(10) || r(10) < 22025.465794806718 || -2e-17 != r(-2e-17) ? function(t) {
        return 0 == (t = +t) ? t : -1e-6 < t && t < 1e-6 ? t + t * t / 2 : Math.exp(t) - 1
      } : r
    }, {}],
    62: [function(t, e, n) {
      var i = t(65),
        r = Math.pow,
        a = r(2, -52),
        c = r(2, -23),
        s = r(2, 127) * (2 - c),
        u = r(2, -126);
      e.exports = Math.fround || function(t) {
        var e, n, r = Math.abs(t),
          o = i(t);
        return r < u ? o * function(t) {
          return t + 1 / a - 1 / a
        }(r / u / c) * u * c : s < (n = (e = (1 + c / a) * r) - (e - r)) || n != n ? o * (1 / 0) : o * n
      }
    }, {
      65: 65
    }],
    63: [function(t, e, n) {
      e.exports = Math.log1p || function(t) {
        return -1e-8 < (t = +t) && t < 1e-8 ? t - t * t / 2 : Math.log(1 + t)
      }
    }, {}],
    64: [function(t, e, n) {
      e.exports = Math.scale || function(t, e, n, r, o) {
        return 0 === arguments.length || t != t || e != e || n != n || r != r || o != o ? NaN : t === 1 / 0 || t === -1 / 0 ? t : (t - e) * (o - r) / (n - e) + r
      }
    }, {}],
    65: [function(t, e, n) {
      e.exports = Math.sign || function(t) {
        return 0 == (t = +t) || t != t ? t : t < 0 ? -1 : 1
      }
    }, {}],
    66: [function(t, e, n) {
      var r = t(124)("meta"),
        o = t(51),
        i = t(41),
        a = t(72).f,
        c = 0,
        s = Object.isExtensible || function() {
          return !0
        },
        u = !t(35)(function() {
          return s(Object.preventExtensions({}))
        }),
        l = function(t) {
          a(t, r, {
            value: {
              i: "O" + ++c,
              w: {}
            }
          })
        },
        f = e.exports = {
          KEY: r,
          NEED: !1,
          fastKey: function(t, e) {
            if (!o(t)) return "symbol" == (void 0 === t ? "undefined" : _typeof(t)) ? t : ("string" == typeof t ? "S" : "P") + t;
            if (!i(t, r)) {
              if (!s(t)) return "F";
              if (!e) return "E";
              l(t)
            }
            return t[r].i
          },
          getWeak: function(t, e) {
            if (!i(t, r)) {
              if (!s(t)) return !0;
              if (!e) return !1;
              l(t)
            }
            return t[r].w
          },
          onFreeze: function(t) {
            return u && f.NEED && s(t) && !i(t, r) && l(t), t
          }
        }
    }, {
      124: 124,
      35: 35,
      41: 41,
      51: 51,
      72: 72
    }],
    67: [function(t, e, n) {
      var i = t(160),
        r = t(33),
        o = t(103)("metadata"),
        a = o.store || (o.store = new(t(266))),
        c = function(t, e, n) {
          var r = a.get(t);
          if (!r) {
            if (!n) return;
            a.set(t, r = new i)
          }
          var o = r.get(e);
          if (!o) {
            if (!n) return;
            r.set(e, o = new i)
          }
          return o
        };
      e.exports = {
        store: a,
        map: c,
        has: function(t, e, n) {
          var r = c(e, n, !1);
          return void 0 !== r && r.has(t)
        },
        get: function(t, e, n) {
          var r = c(e, n, !1);
          return void 0 === r ? void 0 : r.get(t)
        },
        set: function(t, e, n, r) {
          c(n, r, !0).set(t, e)
        },
        keys: function(t, e) {
          var n = c(t, e, !1),
            r = [];
          return n && n.forEach(function(t, e) {
            r.push(e)
          }), r
        },
        key: function(t) {
          return void 0 === t || "symbol" == (void 0 === t ? "undefined" : _typeof(t)) ? t : String(t)
        },
        exp: function(t) {
          r(r.S, "Reflect", t)
        }
      }
    }, {
      103: 103,
      160: 160,
      266: 266,
      33: 33
    }],
    68: [function(t, e, n) {
      var c = t(40),
        s = t(113).set,
        u = c.MutationObserver || c.WebKitMutationObserver,
        l = c.process,
        f = c.Promise,
        p = "process" == t(18)(l);
      e.exports = function() {
        var n, r, o, t = function() {
          var t, e;
          for (p && (t = l.domain) && t.exit(); n;) {
            e = n.fn, n = n.next;
            try {
              e()
            } catch (t) {
              throw n ? o() : r = void 0, t
            }
          }
          r = void 0, t && t.enter()
        };
        if (p) o = function() {
          l.nextTick(t)
        };
        else if (u) {
          var e = !0,
            i = document.createTextNode("");
          new u(t).observe(i, {
            characterData: !0
          }), o = function() {
            i.data = e = !e
          }
        } else if (f && f.resolve) {
          var a = f.resolve();
          o = function() {
            a.then(t)
          }
        } else o = function() {
          s.call(c, t)
        };
        return function(t) {
          var e = {
            fn: t,
            next: void 0
          };
          r && (r.next = e), n || (n = e, o()), r = e
        }
      }
    }, {
      113: 113,
      18: 18,
      40: 40
    }],
    69: [function(t, e, n) {
      function r(t) {
        var n, r;
        this.promise = new t(function(t, e) {
          if (void 0 !== n || void 0 !== r) throw TypeError("Bad Promise constructor");
          n = t, r = e
        }), this.resolve = o(n), this.reject = o(r)
      }
      var o = t(3);
      e.exports.f = function(t) {
        return new r(t)
      }
    }, {
      3: 3
    }],
    70: [function(t, e, n) {
      var p = t(81),
        d = t(78),
        h = t(82),
        v = t(119),
        g = t(47),
        o = Object.assign;
      e.exports = !o || t(35)(function() {
        var t = {},
          e = {},
          n = Symbol(),
          r = "abcdefghijklmnopqrst";
        return t[n] = 7, r.split("").forEach(function(t) {
          e[t] = t
        }), 7 != o({}, t)[n] || Object.keys(o({}, e)).join("") != r
      }) ? function(t, e) {
        for (var n = v(t), r = arguments.length, o = 1, i = d.f, a = h.f; o < r;)
          for (var c, s = g(arguments[o++]), u = i ? p(s).concat(i(s)) : p(s), l = u.length, f = 0; f < l;) a.call(s, c = u[f++]) && (n[c] = s[c]);
        return n
      } : o
    }, {
      119: 119,
      35: 35,
      47: 47,
      78: 78,
      81: 81,
      82: 82
    }],
    71: [function(r, t, e) {
      var o = r(7),
        i = r(73),
        a = r(31),
        c = r(102)("IE_PROTO"),
        s = function() {},
        u = function() {
          var t, e = r(30)("iframe"),
            n = a.length;
          for (e.style.display = "none", r(43).appendChild(e), e.src = "javascript:", (t = e.contentWindow.document).open(), t.write("<script>document.F=Object<\/script>"), t.close(), u = t.F; n--;) delete u.prototype[a[n]];
          return u()
        };
      t.exports = Object.create || function(t, e) {
        var n;
        return null !== t ? (s.prototype = o(t), n = new s, s.prototype = null, n[c] = t) : n = u(), void 0 === e ? n : i(n, e)
      }
    }, {
      102: 102,
      30: 30,
      31: 31,
      43: 43,
      7: 7,
      73: 73
    }],
    72: [function(t, e, n) {
      var r = t(7),
        o = t(44),
        i = t(120),
        a = Object.defineProperty;
      n.f = t(29) ? Object.defineProperty : function(t, e, n) {
        if (r(t), e = i(e, !0), r(n), o) try {
          return a(t, e, n)
        } catch (t) {}
        if ("get" in n || "set" in n) throw TypeError("Accessors not supported!");
        return "value" in n && (t[e] = n.value), t
      }
    }, {
      120: 120,
      29: 29,
      44: 44,
      7: 7
    }],
    73: [function(t, e, n) {
      var a = t(72),
        c = t(7),
        s = t(81);
      e.exports = t(29) ? Object.defineProperties : function(t, e) {
        c(t);
        for (var n, r = s(e), o = r.length, i = 0; i < o;) a.f(t, n = r[i++], e[n]);
        return t
      }
    }, {
      29: 29,
      7: 7,
      72: 72,
      81: 81
    }],
    74: [function(e, t, n) {
      t.exports = e(60) || !e(35)(function() {
        var t = Math.random();
        __defineSetter__.call(null, t, function() {}), delete e(40)[t]
      })
    }, {
      35: 35,
      40: 40,
      60: 60
    }],
    75: [function(t, e, n) {
      var r = t(82),
        o = t(92),
        i = t(117),
        a = t(120),
        c = t(41),
        s = t(44),
        u = Object.getOwnPropertyDescriptor;
      n.f = t(29) ? u : function(t, e) {
        if (t = i(t), e = a(e, !0), s) try {
          return u(t, e)
        } catch (t) {}
        if (c(t, e)) return o(!r.f.call(t, e), t[e])
      }
    }, {
      117: 117,
      120: 120,
      29: 29,
      41: 41,
      44: 44,
      82: 82,
      92: 92
    }],
    76: [function(t, e, n) {
      var r = t(117),
        o = t(77).f,
        i = {}.toString,
        a = "object" == (void 0 === We ? "undefined" : _typeof(We)) && We && Object.getOwnPropertyNames ? Object.getOwnPropertyNames(We) : [];
      e.exports.f = function(t) {
        return a && "[object Window]" == i.call(t) ? function(t) {
          try {
            return o(t)
          } catch (t) {
            return a.slice()
          }
        }(t) : o(r(t))
      }
    }, {
      117: 117,
      77: 77
    }],
    77: [function(t, e, n) {
      var r = t(80),
        o = t(31).concat("length", "prototype");
      n.f = Object.getOwnPropertyNames || function(t) {
        return r(t, o)
      }
    }, {
      31: 31,
      80: 80
    }],
    78: [function(t, e, n) {
      n.f = Object.getOwnPropertySymbols
    }, {}],
    79: [function(t, e, n) {
      var r = t(41),
        o = t(119),
        i = t(102)("IE_PROTO"),
        a = Object.prototype;
      e.exports = Object.getPrototypeOf || function(t) {
        return t = o(t), r(t, i) ? t[i] : "function" == typeof t.constructor && t instanceof t.constructor ? t.constructor.prototype : t instanceof Object ? a : null
      }
    }, {
      102: 102,
      119: 119,
      41: 41
    }],
    80: [function(t, e, n) {
      var a = t(41),
        c = t(117),
        s = t(11)(!1),
        u = t(102)("IE_PROTO");
      e.exports = function(t, e) {
        var n, r = c(t),
          o = 0,
          i = [];
        for (n in r) n != u && a(r, n) && i.push(n);
        for (; e.length > o;) a(r, n = e[o++]) && (~s(i, n) || i.push(n));
        return i
      }
    }, {
      102: 102,
      11: 11,
      117: 117,
      41: 41
    }],
    81: [function(t, e, n) {
      var r = t(80),
        o = t(31);
      e.exports = Object.keys || function(t) {
        return r(t, o)
      }
    }, {
      31: 31,
      80: 80
    }],
    82: [function(t, e, n) {
      n.f = {}.propertyIsEnumerable
    }, {}],
    83: [function(t, e, n) {
      var o = t(33),
        i = t(23),
        a = t(35);
      e.exports = function(t, e) {
        var n = (i.Object || {})[t] || Object[t],
          r = {};
        r[t] = e(n), o(o.S + o.F * a(function() {
          n(1)
        }), "Object", r)
      }
    }, {
      23: 23,
      33: 33,
      35: 35
    }],
    84: [function(t, e, n) {
      var s = t(81),
        u = t(117),
        l = t(82).f;
      e.exports = function(c) {
        return function(t) {
          for (var e, n = u(t), r = s(n), o = r.length, i = 0, a = []; i < o;) l.call(n, e = r[i++]) && a.push(c ? [e, n[e]] : n[e]);
          return a
        }
      }
    }, {
      117: 117,
      81: 81,
      82: 82
    }],
    85: [function(t, e, n) {
      var r = t(77),
        o = t(78),
        i = t(7),
        a = t(40).Reflect;
      e.exports = a && a.ownKeys || function(t) {
        var e = r.f(i(t)),
          n = o.f;
        return n ? e.concat(n(t)) : e
      }
    }, {
      40: 40,
      7: 7,
      77: 77,
      78: 78
    }],
    86: [function(t, e, n) {
      var r = t(40).parseFloat,
        o = t(111).trim;
      e.exports = 1 / r(t(112) + "-0") != -1 / 0 ? function(t) {
        var e = o(String(t), 3),
          n = r(e);
        return 0 === n && "-" == e.charAt(0) ? -0 : n
      } : r
    }, {
      111: 111,
      112: 112,
      40: 40
    }],
    87: [function(t, e, n) {
      var r = t(40).parseInt,
        o = t(111).trim,
        i = t(112),
        a = /^[-+]?0[xX]/;
      e.exports = 8 !== r(i + "08") || 22 !== r(i + "0x16") ? function(t, e) {
        var n = o(String(t), 3);
        return r(n, e >>> 0 || (a.test(n) ? 16 : 10))
      } : r
    }, {
      111: 111,
      112: 112,
      40: 40
    }],
    88: [function(t, e, n) {
      var r = t(89),
        u = t(46),
        l = t(3);
      e.exports = function() {
        for (var o = l(this), i = arguments.length, a = Array(i), t = 0, c = r._, s = !1; t < i;)(a[t] = arguments[t++]) === c && (s = !0);
        return function() {
          var t, e = arguments.length,
            n = 0,
            r = 0;
          if (!s && !e) return u(o, a, this);
          if (t = a.slice(), s)
            for (; n < i; n++) t[n] === c && (t[n] = arguments[r++]);
          for (; r < e;) t.push(arguments[r++]);
          return u(o, t, this)
        }
      }
    }, {
      3: 3,
      46: 46,
      89: 89
    }],
    89: [function(t, e, n) {
      e.exports = t(40)
    }, {
      40: 40
    }],
    90: [function(t, e, n) {
      e.exports = function(t) {
        try {
          return {
            e: !1,
            v: t()
          }
        } catch (t) {
          return {
            e: !0,
            v: t
          }
        }
      }
    }, {}],
    91: [function(t, e, n) {
      var r = t(69);
      e.exports = function(t, e) {
        var n = r.f(t);
        return (0, n.resolve)(e), n.promise
      }
    }, {
      69: 69
    }],
    92: [function(t, e, n) {
      e.exports = function(t, e) {
        return {
          enumerable: !(1 & t),
          configurable: !(2 & t),
          writable: !(4 & t),
          value: e
        }
      }
    }, {}],
    93: [function(t, e, n) {
      var o = t(94);
      e.exports = function(t, e, n) {
        for (var r in e) o(t, r, e[r], n);
        return t
      }
    }, {
      94: 94
    }],
    94: [function(t, e, n) {
      var i = t(40),
        a = t(42),
        c = t(41),
        s = t(124)("src"),
        r = Function.toString,
        u = ("" + r).split("toString");
      t(23).inspectSource = function(t) {
        return r.call(t)
      }, (e.exports = function(t, e, n, r) {
        var o = "function" == typeof n;
        o && (c(n, "name") || a(n, "name", e)), t[e] !== n && (o && (c(n, s) || a(n, s, t[e] ? "" + t[e] : u.join(String(e)))), t === i ? t[e] = n : r ? t[e] ? t[e] = n : a(t, e, n) : (delete t[e], a(t, e, n)))
      })(Function.prototype, "toString", function() {
        return "function" == typeof this && this[s] || r.call(this)
      })
    }, {
      124: 124,
      23: 23,
      40: 40,
      41: 41,
      42: 42
    }],
    95: [function(t, e, n) {
      e.exports = function(e, n) {
        var r = n === Object(n) ? function(t) {
          return n[t]
        } : n;
        return function(t) {
          return String(t).replace(e, r)
        }
      }
    }, {}],
    96: [function(t, e, n) {
      e.exports = Object.is || function(t, e) {
        return t === e ? 0 !== t || 1 / t == 1 / e : t != t && e != e
      }
    }, {}],
    97: [function(t, e, n) {
      var r = t(33),
        a = t(3),
        c = t(25),
        s = t(39);
      e.exports = function(t) {
        r(r.S, t, {
          from: function(t) {
            var e, n, r, o, i = arguments[1];
            return a(this), (e = void 0 !== i) && a(i), null == t ? new this : (n = [], e ? (r = 0, o = c(i, arguments[2], 2), s(t, !1, function(t) {
              n.push(o(t, r++))
            })) : s(t, !1, n.push, n), new this(n))
          }
        })
      }
    }, {
      25: 25,
      3: 3,
      33: 33,
      39: 39
    }],
    98: [function(t, e, n) {
      var r = t(33);
      e.exports = function(t) {
        r(r.S, t, {
          of: function() {
            for (var t = arguments.length, e = Array(t); t--;) e[t] = arguments[t];
            return new this(e)
          }
        })
      }
    }, {
      33: 33
    }],
    99: [function(e, t, n) {
      var r = e(51),
        o = e(7),
        i = function(t, e) {
          if (o(t), !r(e) && null !== e) throw TypeError(e + ": can't set as prototype!")
        };
      t.exports = {
        set: Object.setPrototypeOf || ("__proto__" in {} ? function(t, n, r) {
          try {
            (r = e(25)(Function.call, e(75).f(Object.prototype, "__proto__").set, 2))(t, []), n = !(t instanceof Array)
          } catch (t) {
            n = !0
          }
          return function(t, e) {
            return i(t, e), n ? t.__proto__ = e : r(t, e), t
          }
        }({}, !1) : void 0),
        check: i
      }
    }, {
      25: 25,
      51: 51,
      7: 7,
      75: 75
    }],
    100: [function(t, e, n) {
      var r = t(40),
        o = t(72),
        i = t(29),
        a = t(128)("species");
      e.exports = function(t) {
        var e = r[t];
        i && e && !e[a] && o.f(e, a, {
          configurable: !0,
          get: function() {
            return this
          }
        })
      }
    }, {
      128: 128,
      29: 29,
      40: 40,
      72: 72
    }],
    101: [function(t, e, n) {
      var r = t(72).f,
        o = t(41),
        i = t(128)("toStringTag");
      e.exports = function(t, e, n) {
        t && !o(t = n ? t : t.prototype, i) && r(t, i, {
          configurable: !0,
          value: e
        })
      }
    }, {
      128: 128,
      41: 41,
      72: 72
    }],
    102: [function(t, e, n) {
      var r = t(103)("keys"),
        o = t(124);
      e.exports = function(t) {
        return r[t] || (r[t] = o(t))
      }
    }, {
      103: 103,
      124: 124
    }],
    103: [function(t, e, n) {
      var r = t(40),
        o = r["__core-js_shared__"] || (r["__core-js_shared__"] = {});
      e.exports = function(t) {
        return o[t] || (o[t] = {})
      }
    }, {
      40: 40
    }],
    104: [function(t, e, n) {
      var o = t(7),
        i = t(3),
        a = t(128)("species");
      e.exports = function(t, e) {
        var n, r = o(t).constructor;
        return void 0 === r || null == (n = o(r)[a]) ? e : i(n)
      }
    }, {
      128: 128,
      3: 3,
      7: 7
    }],
    105: [function(t, e, n) {
      var r = t(35);
      e.exports = function(t, e) {
        return !!t && r(function() {
          e ? t.call(null, function() {}, 1) : t.call(null)
        })
      }
    }, {
      35: 35
    }],
    106: [function(t, e, n) {
      var s = t(116),
        u = t(28);
      e.exports = function(c) {
        return function(t, e) {
          var n, r, o = String(u(t)),
            i = s(e),
            a = o.length;
          return i < 0 || a <= i ? c ? "" : void 0 : (n = o.charCodeAt(i)) < 55296 || 56319 < n || i + 1 === a || (r = o.charCodeAt(i + 1)) < 56320 || 57343 < r ? c ? o.charAt(i) : n : c ? o.slice(i, i + 2) : r - 56320 + (n - 55296 << 10) + 65536
        }
      }
    }, {
      116: 116,
      28: 28
    }],
    107: [function(t, e, n) {
      var r = t(52),
        o = t(28);
      e.exports = function(t, e, n) {
        if (r(e)) throw TypeError("String#" + n + " doesn't accept regex!");
        return String(o(t))
      }
    }, {
      28: 28,
      52: 52
    }],
    108: [function(t, e, n) {
      var r = t(33),
        o = t(35),
        a = t(28),
        c = /"/g,
        i = function(t, e, n, r) {
          var o = String(a(t)),
            i = "<" + e;
          return "" !== n && (i += " " + n + '="' + String(r).replace(c, "&quot;") + '"'), i + ">" + o + "</" + e + ">"
        };
      e.exports = function(e, t) {
        var n = {};
        n[e] = t(i), r(r.P + r.F * o(function() {
          var t = "" [e]('"');
          return t !== t.toLowerCase() || 3 < t.split('"').length
        }), "String", n)
      }
    }, {
      28: 28,
      33: 33,
      35: 35
    }],
    109: [function(t, e, n) {
      var l = t(118),
        f = t(110),
        p = t(28);
      e.exports = function(t, e, n, r) {
        var o = String(p(t)),
          i = o.length,
          a = void 0 === n ? " " : String(n),
          c = l(e);
        if (c <= i || "" == a) return o;
        var s = c - i,
          u = f.call(a, Math.ceil(s / a.length));
        return u.length > s && (u = u.slice(0, s)), r ? u + o : o + u
      }
    }, {
      110: 110,
      118: 118,
      28: 28
    }],
    110: [function(t, e, n) {
      var o = t(116),
        i = t(28);
      e.exports = function(t) {
        var e = String(i(this)),
          n = "",
          r = o(t);
        if (r < 0 || r == 1 / 0) throw RangeError("Count can't be negative");
        for (; 0 < r;
          (r >>>= 1) && (e += e)) 1 & r && (n += e);
        return n
      }
    }, {
      116: 116,
      28: 28
    }],
    111: [function(t, e, n) {
      var a = t(33),
        r = t(28),
        c = t(35),
        s = t(112),
        o = "[" + s + "]",
        i = RegExp("^" + o + o + "*"),
        u = RegExp(o + o + "*$"),
        l = function(t, e, n) {
          var r = {},
            o = c(function() {
              return !!s[t]() || "​" != "​" [t]()
            }),
            i = r[t] = o ? e(f) : s[t];
          n && (r[n] = i), a(a.P + a.F * o, "String", r)
        },
        f = l.trim = function(t, e) {
          return t = String(r(t)), 1 & e && (t = t.replace(i, "")), 2 & e && (t = t.replace(u, "")), t
        };
      e.exports = l
    }, {
      112: 112,
      28: 28,
      33: 33,
      35: 35
    }],
    112: [function(t, e, n) {
      e.exports = "\t\n\v\f\r   ᠎             　\u2028\u2029\ufeff"
    }, {}],
    113: [function(t, e, n) {
      var r, o, i, a = t(25),
        c = t(46),
        s = t(43),
        u = t(30),
        l = t(40),
        f = l.process,
        p = l.setImmediate,
        d = l.clearImmediate,
        h = l.MessageChannel,
        v = l.Dispatch,
        g = 0,
        _ = {},
        y = function() {
          var t = +this;
          if (_.hasOwnProperty(t)) {
            var e = _[t];
            delete _[t], e()
          }
        },
        m = function(t) {
          y.call(t.data)
        };
      p && d || (p = function(t) {
        for (var e = [], n = 1; arguments.length > n;) e.push(arguments[n++]);
        return _[++g] = function() {
          c("function" == typeof t ? t : Function(t), e)
        }, r(g), g
      }, d = function(t) {
        delete _[t]
      }, "process" == t(18)(f) ? r = function(t) {
        f.nextTick(a(y, t, 1))
      } : v && v.now ? r = function(t) {
        v.now(a(y, t, 1))
      } : h ? (i = (o = new h).port2, o.port1.onmessage = m, r = a(i.postMessage, i, 1)) : l.addEventListener && "function" == typeof postMessage && !l.importScripts ? (r = function(t) {
        l.postMessage(t + "", "*")
      }, l.addEventListener("message", m, !1)) : r = "onreadystatechange" in u("script") ? function(t) {
        s.appendChild(u("script")).onreadystatechange = function() {
          s.removeChild(this), y.call(t)
        }
      } : function(t) {
        setTimeout(a(y, t, 1), 0)
      }), e.exports = {
        set: p,
        clear: d
      }
    }, {
      18: 18,
      25: 25,
      30: 30,
      40: 40,
      43: 43,
      46: 46
    }],
    114: [function(t, e, n) {
      var r = t(116),
        o = Math.max,
        i = Math.min;
      e.exports = function(t, e) {
        return (t = r(t)) < 0 ? o(t + e, 0) : i(t, e)
      }
    }, {
      116: 116
    }],
    115: [function(t, e, n) {
      var r = t(116),
        o = t(118);
      e.exports = function(t) {
        if (void 0 === t) return 0;
        var e = r(t),
          n = o(e);
        if (e !== n) throw RangeError("Wrong length!");
        return n
      }
    }, {
      116: 116,
      118: 118
    }],
    116: [function(t, e, n) {
      var r = Math.ceil,
        o = Math.floor;
      e.exports = function(t) {
        return isNaN(t = +t) ? 0 : (0 < t ? o : r)(t)
      }
    }, {}],
    117: [function(t, e, n) {
      var r = t(47),
        o = t(28);
      e.exports = function(t) {
        return r(o(t))
      }
    }, {
      28: 28,
      47: 47
    }],
    118: [function(t, e, n) {
      var r = t(116),
        o = Math.min;
      e.exports = function(t) {
        return 0 < t ? o(r(t), 9007199254740991) : 0
      }
    }, {
      116: 116
    }],
    119: [function(t, e, n) {
      var r = t(28);
      e.exports = function(t) {
        return Object(r(t))
      }
    }, {
      28: 28
    }],
    120: [function(t, e, n) {
      var o = t(51);
      e.exports = function(t, e) {
        if (!o(t)) return t;
        var n, r;
        if (e && "function" == typeof(n = t.toString) && !o(r = n.call(t))) return r;
        if ("function" == typeof(n = t.valueOf) && !o(r = n.call(t))) return r;
        if (!e && "function" == typeof(n = t.toString) && !o(r = n.call(t))) return r;
        throw TypeError("Can't convert object to primitive value")
      }
    }, {
      51: 51
    }],
    121: [function(t, e, n) {
      if (t(29)) {
        var _ = t(60),
          y = t(40),
          m = t(35),
          b = t(33),
          x = t(123),
          r = t(122),
          p = t(25),
          k = t(6),
          o = t(92),
          w = t(42),
          i = t(93),
          a = t(116),
          S = t(118),
          E = t(115),
          c = t(114),
          s = t(120),
          u = t(41),
          I = t(17),
          T = t(51),
          d = t(119),
          h = t(48),
          P = t(71),
          O = t(79),
          j = t(77).f,
          v = t(129),
          l = t(124),
          f = t(128),
          g = t(12),
          C = t(11),
          R = t(104),
          M = t(141),
          N = t(58),
          F = t(56),
          L = t(100),
          A = t(9),
          D = t(8),
          U = t(72),
          B = t(75),
          z = U.f,
          H = B.f,
          W = y.RangeError,
          G = y.TypeError,
          q = y.Uint8Array,
          V = Array.prototype,
          J = r.ArrayBuffer,
          K = r.DataView,
          Y = g(0),
          $ = g(2),
          X = g(3),
          Z = g(4),
          Q = g(5),
          tt = g(6),
          et = C(!0),
          nt = C(!1),
          rt = M.values,
          ot = M.keys,
          it = M.entries,
          at = V.lastIndexOf,
          ct = V.reduce,
          st = V.reduceRight,
          ut = V.join,
          lt = V.sort,
          ft = V.slice,
          pt = V.toString,
          dt = V.toLocaleString,
          ht = f("iterator"),
          vt = f("toStringTag"),
          gt = l("typed_constructor"),
          _t = l("def_constructor"),
          yt = x.CONSTR,
          mt = x.TYPED,
          bt = x.VIEW,
          xt = g(1, function(t, e) {
            return It(R(t, t[_t]), e)
          }),
          kt = m(function() {
            return 1 === new q(new Uint16Array([1]).buffer)[0]
          }),
          wt = !!q && !!q.prototype.set && m(function() {
            new q(1).set({})
          }),
          St = function(t, e) {
            var n = a(t);
            if (n < 0 || n % e) throw W("Wrong offset!");
            return n
          },
          Et = function(t) {
            if (T(t) && mt in t) return t;
            throw G(t + " is not a typed array!")
          },
          It = function(t, e) {
            if (!(T(t) && gt in t)) throw G("It is not a typed array constructor!");
            return new t(e)
          },
          Tt = function(t, e) {
            return Pt(R(t, t[_t]), e)
          },
          Pt = function(t, e) {
            for (var n = 0, r = e.length, o = It(t, r); n < r;) o[n] = e[n++];
            return o
          },
          Ot = function(t, e, n) {
            z(t, e, {
              get: function() {
                return this._d[n]
              }
            })
          },
          jt = function(t) {
            var e, n, r, o, i, a, c = d(t),
              s = arguments.length,
              u = 1 < s ? arguments[1] : void 0,
              l = void 0 !== u,
              f = v(c);
            if (null != f && !h(f)) {
              for (a = f.call(c), r = [], e = 0; !(i = a.next()).done; e++) r.push(i.value);
              c = r
            }
            for (l && 2 < s && (u = p(u, arguments[2], 2)), e = 0, n = S(c.length), o = It(this, n); e < n; e++) o[e] = l ? u(c[e], e) : c[e];
            return o
          },
          Ct = function() {
            for (var t = 0, e = arguments.length, n = It(this, e); t < e;) n[t] = arguments[t++];
            return n
          },
          Rt = !!q && m(function() {
            dt.call(new q(1))
          }),
          Mt = function() {
            return dt.apply(Rt ? ft.call(Et(this)) : Et(this), arguments)
          },
          Nt = {
            copyWithin: function(t, e) {
              return D.call(Et(this), t, e, 2 < arguments.length ? arguments[2] : void 0)
            },
            every: function(t) {
              return Z(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            fill: function(t) {
              return A.apply(Et(this), arguments)
            },
            filter: function(t) {
              return Tt(this, $(Et(this), t, 1 < arguments.length ? arguments[1] : void 0))
            },
            find: function(t) {
              return Q(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            findIndex: function(t) {
              return tt(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            forEach: function(t) {
              Y(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            indexOf: function(t) {
              return nt(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            includes: function(t) {
              return et(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            join: function(t) {
              return ut.apply(Et(this), arguments)
            },
            lastIndexOf: function(t) {
              return at.apply(Et(this), arguments)
            },
            map: function(t) {
              return xt(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            reduce: function(t) {
              return ct.apply(Et(this), arguments)
            },
            reduceRight: function(t) {
              return st.apply(Et(this), arguments)
            },
            reverse: function() {
              for (var t, e = this, n = Et(e).length, r = Math.floor(n / 2), o = 0; o < r;) t = e[o], e[o++] = e[--n], e[n] = t;
              return e
            },
            some: function(t) {
              return X(Et(this), t, 1 < arguments.length ? arguments[1] : void 0)
            },
            sort: function(t) {
              return lt.call(Et(this), t)
            },
            subarray: function(t, e) {
              var n = Et(this),
                r = n.length,
                o = c(t, r);
              return new(R(n, n[_t]))(n.buffer, n.byteOffset + o * n.BYTES_PER_ELEMENT, S((void 0 === e ? r : c(e, r)) - o))
            }
          },
          Ft = function(t, e) {
            return Tt(this, ft.call(Et(this), t, e))
          },
          Lt = function(t) {
            Et(this);
            var e = St(arguments[1], 1),
              n = this.length,
              r = d(t),
              o = S(r.length),
              i = 0;
            if (n < o + e) throw W("Wrong length!");
            for (; i < o;) this[e + i] = r[i++]
          },
          At = {
            entries: function() {
              return it.call(Et(this))
            },
            keys: function() {
              return ot.call(Et(this))
            },
            values: function() {
              return rt.call(Et(this))
            }
          },
          Dt = function(t, e) {
            return T(t) && t[mt] && "symbol" != (void 0 === e ? "undefined" : _typeof(e)) && e in t && String(+e) == String(e)
          },
          Ut = function(t, e) {
            return Dt(t, e = s(e, !0)) ? o(2, t[e]) : H(t, e)
          },
          Bt = function(t, e, n) {
            return !(Dt(t, e = s(e, !0)) && T(n) && u(n, "value")) || u(n, "get") || u(n, "set") || n.configurable || u(n, "writable") && !n.writable || u(n, "enumerable") && !n.enumerable ? z(t, e, n) : (t[e] = n.value, t)
          };
        yt || (B.f = Ut, U.f = Bt), b(b.S + b.F * !yt, "Object", {
          getOwnPropertyDescriptor: Ut,
          defineProperty: Bt
        }), m(function() {
          pt.call({})
        }) && (pt = dt = function() {
          return ut.call(this)
        });
        var zt = i({}, Nt);
        i(zt, At), w(zt, ht, At.values), i(zt, {
          slice: Ft,
          set: Lt,
          constructor: function() {},
          toString: pt,
          toLocaleString: Mt
        }), Ot(zt, "buffer", "b"), Ot(zt, "byteOffset", "o"), Ot(zt, "byteLength", "l"), Ot(zt, "length", "e"), z(zt, vt, {
          get: function() {
            return this[mt]
          }
        }), e.exports = function(t, f, e, o) {
          var p = t + ((o = !!o) ? "Clamped" : "") + "Array",
            r = "get" + t,
            i = "set" + t,
            d = y[p],
            a = d || {},
            n = d && O(d),
            c = !d || !x.ABV,
            s = {},
            u = d && d.prototype,
            h = function(t, e) {
              z(t, e, {
                get: function() {
                  return function(t, e) {
                    var n = t._d;
                    return n.v[r](e * f + n.o, kt)
                  }(this, e)
                },
                set: function(t) {
                  return function(t, e, n) {
                    var r = t._d;
                    o && (n = (n = Math.round(n)) < 0 ? 0 : 255 < n ? 255 : 255 & n), r.v[i](e * f + r.o, n, kt)
                  }(this, e, t)
                },
                enumerable: !0
              })
            };
          c ? (d = e(function(t, e, n, r) {
            k(t, d, p, "_d");
            var o, i, a, c, s = 0,
              u = 0;
            if (T(e)) {
              if (!(e instanceof J || "ArrayBuffer" == (c = I(e)) || "SharedArrayBuffer" == c)) return mt in e ? Pt(d, e) : jt.call(d, e);
              o = e, u = St(n, f);
              var l = e.byteLength;
              if (void 0 === r) {
                if (l % f) throw W("Wrong length!");
                if ((i = l - u) < 0) throw W("Wrong length!")
              } else if ((i = S(r) * f) + u > l) throw W("Wrong length!");
              a = i / f
            } else a = E(e), o = new J(i = a * f);
            for (w(t, "_d", {
                b: o,
                o: u,
                l: i,
                e: a,
                v: new K(o)
              }); s < a;) h(t, s++)
          }), u = d.prototype = P(zt), w(u, "constructor", d)) : m(function() {
            d(1)
          }) && m(function() {
            new d(-1)
          }) && F(function(t) {
            new d, new d(null), new d(1.5), new d(t)
          }, !0) || (d = e(function(t, e, n, r) {
            var o;
            return k(t, d, p), T(e) ? e instanceof J || "ArrayBuffer" == (o = I(e)) || "SharedArrayBuffer" == o ? void 0 !== r ? new a(e, St(n, f), r) : void 0 !== n ? new a(e, St(n, f)) : new a(e) : mt in e ? Pt(d, e) : jt.call(d, e) : new a(E(e))
          }), Y(n !== Function.prototype ? j(a).concat(j(n)) : j(a), function(t) {
            t in d || w(d, t, a[t])
          }), d.prototype = u, _ || (u.constructor = d));
          var l = u[ht],
            v = !!l && ("values" == l.name || null == l.name),
            g = At.values;
          w(d, gt, !0), w(u, mt, p), w(u, bt, !0), w(u, _t, d), (o ? new d(1)[vt] == p : vt in u) || z(u, vt, {
            get: function() {
              return p
            }
          }), s[p] = d, b(b.G + b.W + b.F * (d != a), s), b(b.S, p, {
            BYTES_PER_ELEMENT: f
          }), b(b.S + b.F * m(function() {
            a.of.call(d, 1)
          }), p, {
            from: jt,
            of: Ct
          }), "BYTES_PER_ELEMENT" in u || w(u, "BYTES_PER_ELEMENT", f), b(b.P, p, Nt), L(p), b(b.P + b.F * wt, p, {
            set: Lt
          }), b(b.P + b.F * !v, p, At), _ || u.toString == pt || (u.toString = pt), b(b.P + b.F * m(function() {
            new d(1).slice()
          }), p, {
            slice: Ft
          }), b(b.P + b.F * (m(function() {
            return [1, 2].toLocaleString() != new d([1, 2]).toLocaleString()
          }) || !m(function() {
            u.toLocaleString.call([1, 2])
          })), p, {
            toLocaleString: Mt
          }), N[p] = v ? l : g, _ || v || w(u, ht, g)
        }
      } else e.exports = function() {}
    }, {
      100: 100,
      104: 104,
      11: 11,
      114: 114,
      115: 115,
      116: 116,
      118: 118,
      119: 119,
      12: 12,
      120: 120,
      122: 122,
      123: 123,
      124: 124,
      128: 128,
      129: 129,
      141: 141,
      17: 17,
      25: 25,
      29: 29,
      33: 33,
      35: 35,
      40: 40,
      41: 41,
      42: 42,
      48: 48,
      51: 51,
      56: 56,
      58: 58,
      6: 6,
      60: 60,
      71: 71,
      72: 72,
      75: 75,
      77: 77,
      79: 79,
      8: 8,
      9: 9,
      92: 92,
      93: 93
    }],
    122: [function(t, e, n) {
      function r(t, e, n) {
        var r, o, i, a = Array(n),
          c = 8 * n - e - 1,
          s = (1 << c) - 1,
          u = s >> 1,
          l = 23 === e ? D(2, -24) - D(2, -77) : 0,
          f = 0,
          p = t < 0 || 0 === t && 1 / t < 0 ? 1 : 0;
        for ((t = A(t)) != t || t === F ? (o = t != t ? 1 : 0, r = s) : (r = U(B(t) / z), t * (i = D(2, -r)) < 1 && (r--, i *= 2), 2 <= (t += 1 <= r + u ? l / i : l * D(2, 1 - u)) * i && (r++, i /= 2), s <= r + u ? (o = 0, r = s) : 1 <= r + u ? (o = (t * i - 1) * D(2, e), r += u) : (o = t * D(2, u - 1) * D(2, e), r = 0)); 8 <= e; a[f++] = 255 & o, o /= 256, e -= 8);
        for (r = r << e | o, c += e; 0 < c; a[f++] = 255 & r, r /= 256, c -= 8);
        return a[--f] |= 128 * p, a
      }

      function o(t, e, n) {
        var r, o = 8 * n - e - 1,
          i = (1 << o) - 1,
          a = i >> 1,
          c = o - 7,
          s = n - 1,
          u = t[s--],
          l = 127 & u;
        for (u >>= 7; 0 < c; l = 256 * l + t[s], s--, c -= 8);
        for (r = l & (1 << -c) - 1, l >>= -c, c += e; 0 < c; r = 256 * r + t[s], s--, c -= 8);
        if (0 === l) l = 1 - a;
        else {
          if (l === i) return r ? NaN : u ? -F : F;
          r += D(2, e), l -= a
        }
        return (u ? -1 : 1) * r * D(2, l - e)
      }

      function i(t) {
        return t[3] << 24 | t[2] << 16 | t[1] << 8 | t[0]
      }

      function a(t) {
        return [255 & t]
      }

      function c(t) {
        return [255 & t, t >> 8 & 255]
      }

      function s(t) {
        return [255 & t, t >> 8 & 255, t >> 16 & 255, t >> 24 & 255]
      }

      function u(t) {
        return r(t, 52, 8)
      }

      function l(t) {
        return r(t, 23, 4)
      }

      function f(t, e, n) {
        I(t[O], e, {
          get: function() {
            return this[n]
          }
        })
      }

      function p(t, e, n, r) {
        var o = S(+n);
        if (o + e > t[W]) throw N(j);
        var i = t[H]._b,
          a = o + t[G],
          c = i.slice(a, a + e);
        return r ? c : c.reverse()
      }

      function d(t, e, n, r, o, i) {
        var a = S(+n);
        if (a + e > t[W]) throw N(j);
        for (var c = t[H]._b, s = a + t[G], u = r(+o), l = 0; l < e; l++) c[s + l] = u[i ? l : e - l - 1]
      }
      var h = t(40),
        v = t(29),
        g = t(60),
        _ = t(123),
        y = t(42),
        m = t(93),
        b = t(35),
        x = t(6),
        k = t(116),
        w = t(118),
        S = t(115),
        E = t(77).f,
        I = t(72).f,
        T = t(9),
        P = t(101),
        O = "prototype",
        j = "Wrong index!",
        C = h.ArrayBuffer,
        R = h.DataView,
        M = h.Math,
        N = h.RangeError,
        F = h.Infinity,
        L = C,
        A = M.abs,
        D = M.pow,
        U = M.floor,
        B = M.log,
        z = M.LN2,
        H = v ? "_b" : "buffer",
        W = v ? "_l" : "byteLength",
        G = v ? "_o" : "byteOffset";
      if (_.ABV) {
        if (!b(function() {
            C(1)
          }) || !b(function() {
            new C(-1)
          }) || b(function() {
            return new C, new C(1.5), new C(NaN), "ArrayBuffer" != C.name
          })) {
          for (var q, V = (C = function(t) {
              return x(this, C), new L(S(t))
            })[O] = L[O], J = E(L), K = 0; J.length > K;)(q = J[K++]) in C || y(C, q, L[q]);
          g || (V.constructor = C)
        }
        var Y = new R(new C(2)),
          $ = R[O].setInt8;
        Y.setInt8(0, 2147483648), Y.setInt8(1, 2147483649), !Y.getInt8(0) && Y.getInt8(1) || m(R[O], {
          setInt8: function(t, e) {
            $.call(this, t, e << 24 >> 24)
          },
          setUint8: function(t, e) {
            $.call(this, t, e << 24 >> 24)
          }
        }, !0)
      } else C = function(t) {
        x(this, C, "ArrayBuffer");
        var e = S(t);
        this._b = T.call(Array(e), 0), this[W] = e
      }, R = function(t, e, n) {
        x(this, R, "DataView"), x(t, C, "DataView");
        var r = t[W],
          o = k(e);
        if (o < 0 || r < o) throw N("Wrong offset!");
        if (r < o + (n = void 0 === n ? r - o : w(n))) throw N("Wrong length!");
        this[H] = t, this[G] = o, this[W] = n
      }, v && (f(C, "byteLength", "_l"), f(R, "buffer", "_b"), f(R, "byteLength", "_l"), f(R, "byteOffset", "_o")), m(R[O], {
        getInt8: function(t) {
          return p(this, 1, t)[0] << 24 >> 24
        },
        getUint8: function(t) {
          return p(this, 1, t)[0]
        },
        getInt16: function(t) {
          var e = p(this, 2, t, arguments[1]);
          return (e[1] << 8 | e[0]) << 16 >> 16
        },
        getUint16: function(t) {
          var e = p(this, 2, t, arguments[1]);
          return e[1] << 8 | e[0]
        },
        getInt32: function(t) {
          return i(p(this, 4, t, arguments[1]))
        },
        getUint32: function(t) {
          return i(p(this, 4, t, arguments[1])) >>> 0
        },
        getFloat32: function(t) {
          return o(p(this, 4, t, arguments[1]), 23, 4)
        },
        getFloat64: function(t) {
          return o(p(this, 8, t, arguments[1]), 52, 8)
        },
        setInt8: function(t, e) {
          d(this, 1, t, a, e)
        },
        setUint8: function(t, e) {
          d(this, 1, t, a, e)
        },
        setInt16: function(t, e) {
          d(this, 2, t, c, e, arguments[2])
        },
        setUint16: function(t, e) {
          d(this, 2, t, c, e, arguments[2])
        },
        setInt32: function(t, e) {
          d(this, 4, t, s, e, arguments[2])
        },
        setUint32: function(t, e) {
          d(this, 4, t, s, e, arguments[2])
        },
        setFloat32: function(t, e) {
          d(this, 4, t, l, e, arguments[2])
        },
        setFloat64: function(t, e) {
          d(this, 8, t, u, e, arguments[2])
        }
      });
      P(C, "ArrayBuffer"), P(R, "DataView"), y(R[O], _.VIEW, !0), n.ArrayBuffer = C, n.DataView = R
    }, {
      101: 101,
      115: 115,
      116: 116,
      118: 118,
      123: 123,
      29: 29,
      35: 35,
      40: 40,
      42: 42,
      6: 6,
      60: 60,
      72: 72,
      77: 77,
      9: 9,
      93: 93
    }],
    123: [function(t, e, n) {
      for (var r, o = t(40), i = t(42), a = t(124), c = a("typed_array"), s = a("view"), u = !(!o.ArrayBuffer || !o.DataView), l = u, f = 0, p = "Int8Array,Uint8Array,Uint8ClampedArray,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array".split(","); f < 9;)(r = o[p[f++]]) ? (i(r.prototype, c, !0), i(r.prototype, s, !0)) : l = !1;
      e.exports = {
        ABV: u,
        CONSTR: l,
        TYPED: c,
        VIEW: s
      }
    }, {
      124: 124,
      40: 40,
      42: 42
    }],
    124: [function(t, e, n) {
      var r = 0,
        o = Math.random();
      e.exports = function(t) {
        return "Symbol(".concat(void 0 === t ? "" : t, ")_", (++r + o).toString(36))
      }
    }, {}],
    125: [function(t, e, n) {
      var r = t(51);
      e.exports = function(t, e) {
        if (!r(t) || t._t !== e) throw TypeError("Incompatible receiver, " + e + " required!");
        return t
      }
    }, {
      51: 51
    }],
    126: [function(t, e, n) {
      var r = t(40),
        o = t(23),
        i = t(60),
        a = t(127),
        c = t(72).f;
      e.exports = function(t) {
        var e = o.Symbol || (o.Symbol = i ? {} : r.Symbol || {});
        "_" == t.charAt(0) || t in e || c(e, t, {
          value: a.f(t)
        })
      }
    }, {
      127: 127,
      23: 23,
      40: 40,
      60: 60,
      72: 72
    }],
    127: [function(t, e, n) {
      n.f = t(128)
    }, {
      128: 128
    }],
    128: [function(t, e, n) {
      var r = t(103)("wks"),
        o = t(124),
        i = t(40).Symbol,
        a = "function" == typeof i;
      (e.exports = function(t) {
        return r[t] || (r[t] = a && i[t] || (a ? i : o)("Symbol." + t))
      }).store = r
    }, {
      103: 103,
      124: 124,
      40: 40
    }],
    129: [function(t, e, n) {
      var r = t(17),
        o = t(128)("iterator"),
        i = t(58);
      e.exports = t(23).getIteratorMethod = function(t) {
        if (null != t) return t[o] || t["@@iterator"] || i[r(t)]
      }
    }, {
      128: 128,
      17: 17,
      23: 23,
      58: 58
    }],
    130: [function(t, e, n) {
      var r = t(33),
        o = t(95)(/[\\^$*+?.()|[\]{}]/g, "\\$&");
      r(r.S, "RegExp", {
        escape: function(t) {
          return o(t)
        }
      })
    }, {
      33: 33,
      95: 95
    }],
    131: [function(t, e, n) {
      var r = t(33);
      r(r.P, "Array", {
        copyWithin: t(8)
      }), t(5)("copyWithin")
    }, {
      33: 33,
      5: 5,
      8: 8
    }],
    132: [function(t, e, n) {
      var r = t(33),
        o = t(12)(4);
      r(r.P + r.F * !t(105)([].every, !0), "Array", {
        every: function(t) {
          return o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      12: 12,
      33: 33
    }],
    133: [function(t, e, n) {
      var r = t(33);
      r(r.P, "Array", {
        fill: t(9)
      }), t(5)("fill")
    }, {
      33: 33,
      5: 5,
      9: 9
    }],
    134: [function(t, e, n) {
      var r = t(33),
        o = t(12)(2);
      r(r.P + r.F * !t(105)([].filter, !0), "Array", {
        filter: function(t) {
          return o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      12: 12,
      33: 33
    }],
    135: [function(t, e, n) {
      var r = t(33),
        o = t(12)(6),
        i = "findIndex",
        a = !0;
      i in [] && Array(1)[i](function() {
        a = !1
      }), r(r.P + r.F * a, "Array", {
        findIndex: function(t) {
          return o(this, t, 1 < arguments.length ? arguments[1] : void 0)
        }
      }), t(5)(i)
    }, {
      12: 12,
      33: 33,
      5: 5
    }],
    136: [function(t, e, n) {
      var r = t(33),
        o = t(12)(5),
        i = !0;
      "find" in [] && Array(1).find(function() {
        i = !1
      }), r(r.P + r.F * i, "Array", {
        find: function(t) {
          return o(this, t, 1 < arguments.length ? arguments[1] : void 0)
        }
      }), t(5)("find")
    }, {
      12: 12,
      33: 33,
      5: 5
    }],
    137: [function(t, e, n) {
      var r = t(33),
        o = t(12)(0),
        i = t(105)([].forEach, !0);
      r(r.P + r.F * !i, "Array", {
        forEach: function(t) {
          return o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      12: 12,
      33: 33
    }],
    138: [function(t, e, n) {
      var p = t(25),
        r = t(33),
        d = t(119),
        h = t(53),
        v = t(48),
        g = t(118),
        _ = t(24),
        y = t(129);
      r(r.S + r.F * !t(56)(function(t) {
        Array.from(t)
      }), "Array", {
        from: function(t) {
          var e, n, r, o, i = d(t),
            a = "function" == typeof this ? this : Array,
            c = arguments.length,
            s = 1 < c ? arguments[1] : void 0,
            u = void 0 !== s,
            l = 0,
            f = y(i);
          if (u && (s = p(s, 2 < c ? arguments[2] : void 0, 2)), null == f || a == Array && v(f))
            for (n = new a(e = g(i.length)); l < e; l++) _(n, l, u ? s(i[l], l) : i[l]);
          else
            for (o = f.call(i), n = new a; !(r = o.next()).done; l++) _(n, l, u ? h(o, s, [r.value, l], !0) : r.value);
          return n.length = l, n
        }
      })
    }, {
      118: 118,
      119: 119,
      129: 129,
      24: 24,
      25: 25,
      33: 33,
      48: 48,
      53: 53,
      56: 56
    }],
    139: [function(t, e, n) {
      var r = t(33),
        o = t(11)(!1),
        i = [].indexOf,
        a = !!i && 1 / [1].indexOf(1, -0) < 0;
      r(r.P + r.F * (a || !t(105)(i)), "Array", {
        indexOf: function(t) {
          return a ? i.apply(this, arguments) || 0 : o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      11: 11,
      33: 33
    }],
    140: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Array", {
        isArray: t(49)
      })
    }, {
      33: 33,
      49: 49
    }],
    141: [function(t, e, n) {
      var r = t(5),
        o = t(57),
        i = t(58),
        a = t(117);
      e.exports = t(55)(Array, "Array", function(t, e) {
        this._t = a(t), this._i = 0, this._k = e
      }, function() {
        var t = this._t,
          e = this._k,
          n = this._i++;
        return !t || n >= t.length ? (this._t = void 0, o(1)) : o(0, "keys" == e ? n : "values" == e ? t[n] : [n, t[n]])
      }, "values"), i.Arguments = i.Array, r("keys"), r("values"), r("entries")
    }, {
      117: 117,
      5: 5,
      55: 55,
      57: 57,
      58: 58
    }],
    142: [function(t, e, n) {
      var r = t(33),
        o = t(117),
        i = [].join;
      r(r.P + r.F * (t(47) != Object || !t(105)(i)), "Array", {
        join: function(t) {
          return i.call(o(this), void 0 === t ? "," : t)
        }
      })
    }, {
      105: 105,
      117: 117,
      33: 33,
      47: 47
    }],
    143: [function(t, e, n) {
      var r = t(33),
        o = t(117),
        i = t(116),
        a = t(118),
        c = [].lastIndexOf,
        s = !!c && 1 / [1].lastIndexOf(1, -0) < 0;
      r(r.P + r.F * (s || !t(105)(c)), "Array", {
        lastIndexOf: function(t) {
          if (s) return c.apply(this, arguments) || 0;
          var e = o(this),
            n = a(e.length),
            r = n - 1;
          for (1 < arguments.length && (r = Math.min(r, i(arguments[1]))), r < 0 && (r = n + r); 0 <= r; r--)
            if (r in e && e[r] === t) return r || 0;
          return -1
        }
      })
    }, {
      105: 105,
      116: 116,
      117: 117,
      118: 118,
      33: 33
    }],
    144: [function(t, e, n) {
      var r = t(33),
        o = t(12)(1);
      r(r.P + r.F * !t(105)([].map, !0), "Array", {
        map: function(t) {
          return o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      12: 12,
      33: 33
    }],
    145: [function(t, e, n) {
      var r = t(33),
        o = t(24);
      r(r.S + r.F * t(35)(function() {
        function t() {}
        return !(Array.of.call(t) instanceof t)
      }), "Array", {
        of: function() {
          for (var t = 0, e = arguments.length, n = new("function" == typeof this ? this : Array)(e); t < e;) o(n, t, arguments[t++]);
          return n.length = e, n
        }
      })
    }, {
      24: 24,
      33: 33,
      35: 35
    }],
    146: [function(t, e, n) {
      var r = t(33),
        o = t(13);
      r(r.P + r.F * !t(105)([].reduceRight, !0), "Array", {
        reduceRight: function(t) {
          return o(this, t, arguments.length, arguments[1], !0)
        }
      })
    }, {
      105: 105,
      13: 13,
      33: 33
    }],
    147: [function(t, e, n) {
      var r = t(33),
        o = t(13);
      r(r.P + r.F * !t(105)([].reduce, !0), "Array", {
        reduce: function(t) {
          return o(this, t, arguments.length, arguments[1], !1)
        }
      })
    }, {
      105: 105,
      13: 13,
      33: 33
    }],
    148: [function(t, e, n) {
      var r = t(33),
        o = t(43),
        u = t(18),
        l = t(114),
        f = t(118),
        p = [].slice;
      r(r.P + r.F * t(35)(function() {
        o && p.call(o)
      }), "Array", {
        slice: function(t, e) {
          var n = f(this.length),
            r = u(this);
          if (e = void 0 === e ? n : e, "Array" == r) return p.call(this, t, e);
          for (var o = l(t, n), i = l(e, n), a = f(i - o), c = Array(a), s = 0; s < a; s++) c[s] = "String" == r ? this.charAt(o + s) : this[o + s];
          return c
        }
      })
    }, {
      114: 114,
      118: 118,
      18: 18,
      33: 33,
      35: 35,
      43: 43
    }],
    149: [function(t, e, n) {
      var r = t(33),
        o = t(12)(3);
      r(r.P + r.F * !t(105)([].some, !0), "Array", {
        some: function(t) {
          return o(this, t, arguments[1])
        }
      })
    }, {
      105: 105,
      12: 12,
      33: 33
    }],
    150: [function(t, e, n) {
      var r = t(33),
        o = t(3),
        i = t(119),
        a = t(35),
        c = [].sort,
        s = [1, 2, 3];
      r(r.P + r.F * (a(function() {
        s.sort(void 0)
      }) || !a(function() {
        s.sort(null)
      }) || !t(105)(c)), "Array", {
        sort: function(t) {
          return void 0 === t ? c.call(i(this)) : c.call(i(this), o(t))
        }
      })
    }, {
      105: 105,
      119: 119,
      3: 3,
      33: 33,
      35: 35
    }],
    151: [function(t, e, n) {
      t(100)("Array")
    }, {
      100: 100
    }],
    152: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Date", {
        now: function() {
          return (new Date).getTime()
        }
      })
    }, {
      33: 33
    }],
    153: [function(t, e, n) {
      var r = t(33),
        o = t(26);
      r(r.P + r.F * (Date.prototype.toISOString !== o), "Date", {
        toISOString: o
      })
    }, {
      26: 26,
      33: 33
    }],
    154: [function(t, e, n) {
      var r = t(33),
        o = t(119),
        i = t(120);
      r(r.P + r.F * t(35)(function() {
        return null !== new Date(NaN).toJSON() || 1 !== Date.prototype.toJSON.call({
          toISOString: function() {
            return 1
          }
        })
      }), "Date", {
        toJSON: function(t) {
          var e = o(this),
            n = i(e);
          return "number" != typeof n || isFinite(n) ? e.toISOString() : null
        }
      })
    }, {
      119: 119,
      120: 120,
      33: 33,
      35: 35
    }],
    155: [function(t, e, n) {
      var r = t(128)("toPrimitive"),
        o = Date.prototype;
      r in o || t(42)(o, r, t(27))
    }, {
      128: 128,
      27: 27,
      42: 42
    }],
    156: [function(t, e, n) {
      var r = Date.prototype,
        o = r.toString,
        i = r.getTime;
      new Date(NaN) + "" != "Invalid Date" && t(94)(r, "toString", function() {
        var t = i.call(this);
        return t == t ? o.call(this) : "Invalid Date"
      })
    }, {
      94: 94
    }],
    157: [function(t, e, n) {
      var r = t(33);
      r(r.P, "Function", {
        bind: t(16)
      })
    }, {
      16: 16,
      33: 33
    }],
    158: [function(t, e, n) {
      var r = t(51),
        o = t(79),
        i = t(128)("hasInstance"),
        a = Function.prototype;
      i in a || t(72).f(a, i, {
        value: function(t) {
          if ("function" != typeof this || !r(t)) return !1;
          if (!r(this.prototype)) return t instanceof this;
          for (; t = o(t);)
            if (this.prototype === t) return !0;
          return !1
        }
      })
    }, {
      128: 128,
      51: 51,
      72: 72,
      79: 79
    }],
    159: [function(t, e, n) {
      var r = t(72).f,
        o = Function.prototype,
        i = /^\s*function ([^ (]*)/;
      "name" in o || t(29) && r(o, "name", {
        configurable: !0,
        get: function() {
          try {
            return ("" + this).match(i)[1]
          } catch (t) {
            return ""
          }
        }
      })
    }, {
      29: 29,
      72: 72
    }],
    160: [function(t, e, n) {
      var r = t(19),
        o = t(125);
      e.exports = t(22)("Map", function(t) {
        return function() {
          return t(this, 0 < arguments.length ? arguments[0] : void 0)
        }
      }, {
        get: function(t) {
          var e = r.getEntry(o(this, "Map"), t);
          return e && e.v
        },
        set: function(t, e) {
          return r.def(o(this, "Map"), 0 === t ? 0 : t, e)
        }
      }, r, !0)
    }, {
      125: 125,
      19: 19,
      22: 22
    }],
    161: [function(t, e, n) {
      var r = t(33),
        o = t(63),
        i = Math.sqrt,
        a = Math.acosh;
      r(r.S + r.F * !(a && 710 == Math.floor(a(Number.MAX_VALUE)) && a(1 / 0) == 1 / 0), "Math", {
        acosh: function(t) {
          return (t = +t) < 1 ? NaN : 94906265.62425156 < t ? Math.log(t) + Math.LN2 : o(t - 1 + i(t - 1) * i(t + 1))
        }
      })
    }, {
      33: 33,
      63: 63
    }],
    162: [function(t, e, n) {
      var r = t(33),
        o = Math.asinh;
      r(r.S + r.F * !(o && 0 < 1 / o(0)), "Math", {
        asinh: function t(e) {
          return isFinite(e = +e) && 0 != e ? e < 0 ? -t(-e) : Math.log(e + Math.sqrt(e * e + 1)) : e
        }
      })
    }, {
      33: 33
    }],
    163: [function(t, e, n) {
      var r = t(33),
        o = Math.atanh;
      r(r.S + r.F * !(o && 1 / o(-0) < 0), "Math", {
        atanh: function(t) {
          return 0 == (t = +t) ? t : Math.log((1 + t) / (1 - t)) / 2
        }
      })
    }, {
      33: 33
    }],
    164: [function(t, e, n) {
      var r = t(33),
        o = t(65);
      r(r.S, "Math", {
        cbrt: function(t) {
          return o(t = +t) * Math.pow(Math.abs(t), 1 / 3)
        }
      })
    }, {
      33: 33,
      65: 65
    }],
    165: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        clz32: function(t) {
          return (t >>>= 0) ? 31 - Math.floor(Math.log(t + .5) * Math.LOG2E) : 32
        }
      })
    }, {
      33: 33
    }],
    166: [function(t, e, n) {
      var r = t(33),
        o = Math.exp;
      r(r.S, "Math", {
        cosh: function(t) {
          return (o(t = +t) + o(-t)) / 2
        }
      })
    }, {
      33: 33
    }],
    167: [function(t, e, n) {
      var r = t(33),
        o = t(61);
      r(r.S + r.F * (o != Math.expm1), "Math", {
        expm1: o
      })
    }, {
      33: 33,
      61: 61
    }],
    168: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        fround: t(62)
      })
    }, {
      33: 33,
      62: 62
    }],
    169: [function(t, e, n) {
      var r = t(33),
        s = Math.abs;
      r(r.S, "Math", {
        hypot: function(t, e) {
          for (var n, r, o = 0, i = 0, a = arguments.length, c = 0; i < a;) c < (n = s(arguments[i++])) ? (o = o * (r = c / n) * r + 1, c = n) : o += 0 < n ? (r = n / c) * r : n;
          return c === 1 / 0 ? 1 / 0 : c * Math.sqrt(o)
        }
      })
    }, {
      33: 33
    }],
    170: [function(t, e, n) {
      var r = t(33),
        o = Math.imul;
      r(r.S + r.F * t(35)(function() {
        return -5 != o(4294967295, 5) || 2 != o.length
      }), "Math", {
        imul: function(t, e) {
          var n = +t,
            r = +e,
            o = 65535 & n,
            i = 65535 & r;
          return 0 | o * i + ((65535 & n >>> 16) * i + o * (65535 & r >>> 16) << 16 >>> 0)
        }
      })
    }, {
      33: 33,
      35: 35
    }],
    171: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        log10: function(t) {
          return Math.log(t) * Math.LOG10E
        }
      })
    }, {
      33: 33
    }],
    172: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        log1p: t(63)
      })
    }, {
      33: 33,
      63: 63
    }],
    173: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        log2: function(t) {
          return Math.log(t) / Math.LN2
        }
      })
    }, {
      33: 33
    }],
    174: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        sign: t(65)
      })
    }, {
      33: 33,
      65: 65
    }],
    175: [function(t, e, n) {
      var r = t(33),
        o = t(61),
        i = Math.exp;
      r(r.S + r.F * t(35)(function() {
        return -2e-17 != !Math.sinh(-2e-17)
      }), "Math", {
        sinh: function(t) {
          return Math.abs(t = +t) < 1 ? (o(t) - o(-t)) / 2 : (i(t - 1) - i(-t - 1)) * (Math.E / 2)
        }
      })
    }, {
      33: 33,
      35: 35,
      61: 61
    }],
    176: [function(t, e, n) {
      var r = t(33),
        o = t(61),
        i = Math.exp;
      r(r.S, "Math", {
        tanh: function(t) {
          var e = o(t = +t),
            n = o(-t);
          return e == 1 / 0 ? 1 : n == 1 / 0 ? -1 : (e - n) / (i(t) + i(-t))
        }
      })
    }, {
      33: 33,
      61: 61
    }],
    177: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        trunc: function(t) {
          return (0 < t ? Math.floor : Math.ceil)(t)
        }
      })
    }, {
      33: 33
    }],
    178: [function(t, e, n) {
      var r = t(40),
        o = t(41),
        i = t(18),
        a = t(45),
        l = t(120),
        c = t(35),
        s = t(77).f,
        u = t(75).f,
        f = t(72).f,
        p = t(111).trim,
        d = r.Number,
        h = d,
        v = d.prototype,
        g = "Number" == i(t(71)(v)),
        _ = "trim" in String.prototype,
        y = function(t) {
          var e = l(t, !1);
          if ("string" == typeof e && 2 < e.length) {
            var n, r, o, i = (e = _ ? e.trim() : p(e, 3)).charCodeAt(0);
            if (43 === i || 45 === i) {
              if (88 === (n = e.charCodeAt(2)) || 120 === n) return NaN
            } else if (48 === i) {
              switch (e.charCodeAt(1)) {
                case 66:
                case 98:
                  r = 2, o = 49;
                  break;
                case 79:
                case 111:
                  r = 8, o = 55;
                  break;
                default:
                  return +e
              }
              for (var a, c = e.slice(2), s = 0, u = c.length; s < u; s++)
                if ((a = c.charCodeAt(s)) < 48 || o < a) return NaN;
              return parseInt(c, r)
            }
          }
          return +e
        };
      if (!d(" 0o1") || !d("0b1") || d("+0x1")) {
        d = function(t) {
          var e = arguments.length < 1 ? 0 : t,
            n = this;
          return n instanceof d && (g ? c(function() {
            v.valueOf.call(n)
          }) : "Number" != i(n)) ? a(new h(y(e)), n, d) : y(e)
        };
        for (var m, b = t(29) ? s(h) : "MAX_VALUE,MIN_VALUE,NaN,NEGATIVE_INFINITY,POSITIVE_INFINITY,EPSILON,isFinite,isInteger,isNaN,isSafeInteger,MAX_SAFE_INTEGER,MIN_SAFE_INTEGER,parseFloat,parseInt,isInteger".split(","), x = 0; b.length > x; x++) o(h, m = b[x]) && !o(d, m) && f(d, m, u(h, m));
        (d.prototype = v).constructor = d, t(94)(r, "Number", d)
      }
    }, {
      111: 111,
      120: 120,
      18: 18,
      29: 29,
      35: 35,
      40: 40,
      41: 41,
      45: 45,
      71: 71,
      72: 72,
      75: 75,
      77: 77,
      94: 94
    }],
    179: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Number", {
        EPSILON: Math.pow(2, -52)
      })
    }, {
      33: 33
    }],
    180: [function(t, e, n) {
      var r = t(33),
        o = t(40).isFinite;
      r(r.S, "Number", {
        isFinite: function(t) {
          return "number" == typeof t && o(t)
        }
      })
    }, {
      33: 33,
      40: 40
    }],
    181: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Number", {
        isInteger: t(50)
      })
    }, {
      33: 33,
      50: 50
    }],
    182: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Number", {
        isNaN: function(t) {
          return t != t
        }
      })
    }, {
      33: 33
    }],
    183: [function(t, e, n) {
      var r = t(33),
        o = t(50),
        i = Math.abs;
      r(r.S, "Number", {
        isSafeInteger: function(t) {
          return o(t) && i(t) <= 9007199254740991
        }
      })
    }, {
      33: 33,
      50: 50
    }],
    184: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Number", {
        MAX_SAFE_INTEGER: 9007199254740991
      })
    }, {
      33: 33
    }],
    185: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Number", {
        MIN_SAFE_INTEGER: -9007199254740991
      })
    }, {
      33: 33
    }],
    186: [function(t, e, n) {
      var r = t(33),
        o = t(86);
      r(r.S + r.F * (Number.parseFloat != o), "Number", {
        parseFloat: o
      })
    }, {
      33: 33,
      86: 86
    }],
    187: [function(t, e, n) {
      var r = t(33),
        o = t(87);
      r(r.S + r.F * (Number.parseInt != o), "Number", {
        parseInt: o
      })
    }, {
      33: 33,
      87: 87
    }],
    188: [function(t, e, n) {
      var r = t(33),
        u = t(116),
        l = t(4),
        f = t(110),
        o = 1..toFixed,
        i = Math.floor,
        a = [0, 0, 0, 0, 0, 0],
        p = "Number.toFixed: incorrect invocation!",
        d = function(t, e) {
          for (var n = -1, r = e; ++n < 6;) r += t * a[n], a[n] = r % 1e7, r = i(r / 1e7)
        },
        h = function(t) {
          for (var e = 6, n = 0; 0 <= --e;) n += a[e], a[e] = i(n / t), n = n % t * 1e7
        },
        v = function() {
          for (var t = 6, e = ""; 0 <= --t;)
            if ("" !== e || 0 === t || 0 !== a[t]) {
              var n = String(a[t]);
              e = "" === e ? n : e + f.call("0", 7 - n.length) + n
            } return e
        },
        g = function t(e, n, r) {
          return 0 === n ? r : n % 2 == 1 ? t(e, n - 1, r * e) : t(e * e, n / 2, r)
        };
      r(r.P + r.F * (!!o && ("0.000" !== 8e-5.toFixed(3) || "1" !== .9.toFixed(0) || "1.25" !== 1.255.toFixed(2) || "1000000000000000128" !== (0xde0b6b3a7640080).toFixed(0)) || !t(35)(function() {
        o.call({})
      })), "Number", {
        toFixed: function(t) {
          var e, n, r, o, i = l(this, p),
            a = u(t),
            c = "",
            s = "0";
          if (a < 0 || 20 < a) throw RangeError(p);
          if (i != i) return "NaN";
          if (i <= -1e21 || 1e21 <= i) return String(i);
          if (i < 0 && (c = "-", i = -i), 1e-21 < i)
            if (n = (e = function(t) {
                for (var e = 0, n = t; 4096 <= n;) e += 12, n /= 4096;
                for (; 2 <= n;) e += 1, n /= 2;
                return e
              }(i * g(2, 69, 1)) - 69) < 0 ? i * g(2, -e, 1) : i / g(2, e, 1), n *= 4503599627370496, 0 < (e = 52 - e)) {
              for (d(0, n), r = a; 7 <= r;) d(1e7, 0), r -= 7;
              for (d(g(10, r, 1), 0), r = e - 1; 23 <= r;) h(1 << 23), r -= 23;
              h(1 << r), d(1, 1), h(2), s = v()
            } else d(0, n), d(1 << -e, 0), s = v() + f.call("0", a);
          return s = 0 < a ? c + ((o = s.length) <= a ? "0." + f.call("0", a - o) + s : s.slice(0, o - a) + "." + s.slice(o - a)) : c + s
        }
      })
    }, {
      110: 110,
      116: 116,
      33: 33,
      35: 35,
      4: 4
    }],
    189: [function(t, e, n) {
      var r = t(33),
        o = t(35),
        i = t(4),
        a = 1..toPrecision;
      r(r.P + r.F * (o(function() {
        return "1" !== a.call(1, void 0)
      }) || !o(function() {
        a.call({})
      })), "Number", {
        toPrecision: function(t) {
          var e = i(this, "Number#toPrecision: incorrect invocation!");
          return void 0 === t ? a.call(e) : a.call(e, t)
        }
      })
    }, {
      33: 33,
      35: 35,
      4: 4
    }],
    190: [function(t, e, n) {
      var r = t(33);
      r(r.S + r.F, "Object", {
        assign: t(70)
      })
    }, {
      33: 33,
      70: 70
    }],
    191: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Object", {
        create: t(71)
      })
    }, {
      33: 33,
      71: 71
    }],
    192: [function(t, e, n) {
      var r = t(33);
      r(r.S + r.F * !t(29), "Object", {
        defineProperties: t(73)
      })
    }, {
      29: 29,
      33: 33,
      73: 73
    }],
    193: [function(t, e, n) {
      var r = t(33);
      r(r.S + r.F * !t(29), "Object", {
        defineProperty: t(72).f
      })
    }, {
      29: 29,
      33: 33,
      72: 72
    }],
    194: [function(t, e, n) {
      var r = t(51),
        o = t(66).onFreeze;
      t(83)("freeze", function(e) {
        return function(t) {
          return e && r(t) ? e(o(t)) : t
        }
      })
    }, {
      51: 51,
      66: 66,
      83: 83
    }],
    195: [function(t, e, n) {
      var r = t(117),
        o = t(75).f;
      t(83)("getOwnPropertyDescriptor", function() {
        return function(t, e) {
          return o(r(t), e)
        }
      })
    }, {
      117: 117,
      75: 75,
      83: 83
    }],
    196: [function(t, e, n) {
      t(83)("getOwnPropertyNames", function() {
        return t(76).f
      })
    }, {
      76: 76,
      83: 83
    }],
    197: [function(t, e, n) {
      var r = t(119),
        o = t(79);
      t(83)("getPrototypeOf", function() {
        return function(t) {
          return o(r(t))
        }
      })
    }, {
      119: 119,
      79: 79,
      83: 83
    }],
    198: [function(t, e, n) {
      var r = t(51);
      t(83)("isExtensible", function(e) {
        return function(t) {
          return !!r(t) && (!e || e(t))
        }
      })
    }, {
      51: 51,
      83: 83
    }],
    199: [function(t, e, n) {
      var r = t(51);
      t(83)("isFrozen", function(e) {
        return function(t) {
          return !r(t) || !!e && e(t)
        }
      })
    }, {
      51: 51,
      83: 83
    }],
    200: [function(t, e, n) {
      var r = t(51);
      t(83)("isSealed", function(e) {
        return function(t) {
          return !r(t) || !!e && e(t)
        }
      })
    }, {
      51: 51,
      83: 83
    }],
    201: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Object", {
        is: t(96)
      })
    }, {
      33: 33,
      96: 96
    }],
    202: [function(t, e, n) {
      var r = t(119),
        o = t(81);
      t(83)("keys", function() {
        return function(t) {
          return o(r(t))
        }
      })
    }, {
      119: 119,
      81: 81,
      83: 83
    }],
    203: [function(t, e, n) {
      var r = t(51),
        o = t(66).onFreeze;
      t(83)("preventExtensions", function(e) {
        return function(t) {
          return e && r(t) ? e(o(t)) : t
        }
      })
    }, {
      51: 51,
      66: 66,
      83: 83
    }],
    204: [function(t, e, n) {
      var r = t(51),
        o = t(66).onFreeze;
      t(83)("seal", function(e) {
        return function(t) {
          return e && r(t) ? e(o(t)) : t
        }
      })
    }, {
      51: 51,
      66: 66,
      83: 83
    }],
    205: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Object", {
        setPrototypeOf: t(99).set
      })
    }, {
      33: 33,
      99: 99
    }],
    206: [function(t, e, n) {
      var r = t(17),
        o = {};
      o[t(128)("toStringTag")] = "z", o + "" != "[object z]" && t(94)(Object.prototype, "toString", function() {
        return "[object " + r(this) + "]"
      }, !0)
    }, {
      128: 128,
      17: 17,
      94: 94
    }],
    207: [function(t, e, n) {
      var r = t(33),
        o = t(86);
      r(r.G + r.F * (parseFloat != o), {
        parseFloat: o
      })
    }, {
      33: 33,
      86: 86
    }],
    208: [function(t, e, n) {
      var r = t(33),
        o = t(87);
      r(r.G + r.F * (parseInt != o), {
        parseInt: o
      })
    }, {
      33: 33,
      87: 87
    }],
    209: [function(n, t, e) {
      var r, o, i, a, c = n(60),
        s = n(40),
        u = n(25),
        l = n(17),
        f = n(33),
        p = n(51),
        d = n(3),
        h = n(6),
        v = n(39),
        g = n(104),
        _ = n(113).set,
        y = n(68)(),
        m = n(69),
        b = n(90),
        x = n(91),
        k = s.TypeError,
        w = s.process,
        S = s.Promise,
        E = "process" == l(w),
        I = function() {},
        T = o = m.f,
        P = !! function() {
          try {
            var t = S.resolve(1),
              e = (t.constructor = {})[n(128)("species")] = function(t) {
                t(I, I)
              };
            return (E || "function" == typeof PromiseRejectionEvent) && t.then(I) instanceof e
          } catch (t) {}
        }(),
        O = c ? function(t, e) {
          return t === e || t === S && e === a
        } : function(t, e) {
          return t === e
        },
        j = function(t) {
          var e;
          return !(!p(t) || "function" != typeof(e = t.then)) && e
        },
        C = function(u, e) {
          if (!u._n) {
            u._n = !0;
            var n = u._c;
            y(function() {
              for (var c = u._v, s = 1 == u._s, t = 0; n.length > t;) ! function(t) {
                var e, n, r = s ? t.ok : t.fail,
                  o = t.resolve,
                  i = t.reject,
                  a = t.domain;
                try {
                  r ? (s || (2 == u._h && N(u), u._h = 1), !0 === r ? e = c : (a && a.enter(), e = r(c), a && a.exit()), e === t.promise ? i(k("Promise-chain cycle")) : (n = j(e)) ? n.call(e, o, i) : o(e)) : i(c)
                } catch (t) {
                  i(t)
                }
              }(n[t++]);
              u._c = [], u._n = !1, e && !u._h && R(u)
            })
          }
        },
        R = function(i) {
          _.call(s, function() {
            var t, e, n, r = i._v,
              o = M(i);
            if (o && (t = b(function() {
                E ? w.emit("unhandledRejection", r, i) : (e = s.onunhandledrejection) ? e({
                  promise: i,
                  reason: r
                }) : (n = s.console) && n.error && n.error("Unhandled promise rejection", r)
              }), i._h = E || M(i) ? 2 : 1), i._a = void 0, o && t.e) throw t.v
          })
        },
        M = function t(e) {
          if (1 == e._h) return !1;
          for (var n, r = e._a || e._c, o = 0; r.length > o;)
            if ((n = r[o++]).fail || !t(n.promise)) return !1;
          return !0
        },
        N = function(e) {
          _.call(s, function() {
            var t;
            E ? w.emit("rejectionHandled", e) : (t = s.onrejectionhandled) && t({
              promise: e,
              reason: e._v
            })
          })
        },
        F = function(t) {
          var e = this;
          e._d || (e._d = !0, (e = e._w || e)._v = t, e._s = 2, e._a || (e._a = e._c.slice()), C(e, !0))
        },
        L = function t(n) {
          var r, o = this;
          if (!o._d) {
            o._d = !0, o = o._w || o;
            try {
              if (o === n) throw k("Promise can't be resolved itself");
              (r = j(n)) ? y(function() {
                var e = {
                  _w: o,
                  _d: !1
                };
                try {
                  r.call(n, u(t, e, 1), u(F, e, 1))
                } catch (t) {
                  F.call(e, t)
                }
              }): (o._v = n, o._s = 1, C(o, !1))
            } catch (n) {
              F.call({
                _w: o,
                _d: !1
              }, n)
            }
          }
        };
      P || (S = function(t) {
        h(this, S, "Promise", "_h"), d(t), r.call(this);
        try {
          t(u(L, this, 1), u(F, this, 1))
        } catch (t) {
          F.call(this, t)
        }
      }, (r = function(t) {
        this._c = [], this._a = void 0, this._s = 0, this._d = !1, this._v = void 0, this._h = 0, this._n = !1
      }).prototype = n(93)(S.prototype, {
        then: function(t, e) {
          var n = T(g(this, S));
          return n.ok = "function" != typeof t || t, n.fail = "function" == typeof e && e, n.domain = E ? w.domain : void 0, this._c.push(n), this._a && this._a.push(n), this._s && C(this, !1), n.promise
        },
        catch: function(t) {
          return this.then(void 0, t)
        }
      }), i = function() {
        var t = new r;
        this.promise = t, this.resolve = u(L, t, 1), this.reject = u(F, t, 1)
      }, m.f = T = function(t) {
        return O(S, t) ? new i(t) : o(t)
      }), f(f.G + f.W + f.F * !P, {
        Promise: S
      }), n(101)(S, "Promise"), n(100)("Promise"), a = n(23).Promise, f(f.S + f.F * !P, "Promise", {
        reject: function(t) {
          var e = T(this);
          return (0, e.reject)(t), e.promise
        }
      }), f(f.S + f.F * (c || !P), "Promise", {
        resolve: function(t) {
          return t instanceof S && O(t.constructor, this) ? t : x(this, t)
        }
      }), f(f.S + f.F * !(P && n(56)(function(t) {
        S.all(t).catch(I)
      })), "Promise", {
        all: function(t) {
          var a = this,
            e = T(a),
            c = e.resolve,
            s = e.reject,
            n = b(function() {
              var r = [],
                o = 0,
                i = 1;
              v(t, !1, function(t) {
                var e = o++,
                  n = !1;
                r.push(void 0), i++, a.resolve(t).then(function(t) {
                  n || (n = !0, r[e] = t, --i || c(r))
                }, s)
              }), --i || c(r)
            });
          return n.e && s(n.v), e.promise
        },
        race: function(t) {
          var e = this,
            n = T(e),
            r = n.reject,
            o = b(function() {
              v(t, !1, function(t) {
                e.resolve(t).then(n.resolve, r)
              })
            });
          return o.e && r(o.v), n.promise
        }
      })
    }, {
      100: 100,
      101: 101,
      104: 104,
      113: 113,
      128: 128,
      17: 17,
      23: 23,
      25: 25,
      3: 3,
      33: 33,
      39: 39,
      40: 40,
      51: 51,
      56: 56,
      6: 6,
      60: 60,
      68: 68,
      69: 69,
      90: 90,
      91: 91,
      93: 93
    }],
    210: [function(t, e, n) {
      var r = t(33),
        i = t(3),
        a = t(7),
        c = (t(40).Reflect || {}).apply,
        s = Function.apply;
      r(r.S + r.F * !t(35)(function() {
        c(function() {})
      }), "Reflect", {
        apply: function(t, e, n) {
          var r = i(t),
            o = a(n);
          return c ? c(r, e, o) : s.call(r, e, o)
        }
      })
    }, {
      3: 3,
      33: 33,
      35: 35,
      40: 40,
      7: 7
    }],
    211: [function(t, e, n) {
      var r = t(33),
        c = t(71),
        s = t(3),
        u = t(7),
        l = t(51),
        o = t(35),
        f = t(16),
        p = (t(40).Reflect || {}).construct,
        d = o(function() {
          function t() {}
          return !(p(function() {}, [], t) instanceof t)
        }),
        h = !o(function() {
          p(function() {})
        });
      r(r.S + r.F * (d || h), "Reflect", {
        construct: function(t, e) {
          s(t), u(e);
          var n = arguments.length < 3 ? t : s(arguments[2]);
          if (h && !d) return p(t, e, n);
          if (t == n) {
            switch (e.length) {
              case 0:
                return new t;
              case 1:
                return new t(e[0]);
              case 2:
                return new t(e[0], e[1]);
              case 3:
                return new t(e[0], e[1], e[2]);
              case 4:
                return new t(e[0], e[1], e[2], e[3])
            }
            var r = [null];
            return r.push.apply(r, e), new(f.apply(t, r))
          }
          var o = n.prototype,
            i = c(l(o) ? o : Object.prototype),
            a = Function.apply.call(t, i, e);
          return l(a) ? a : i
        }
      })
    }, {
      16: 16,
      3: 3,
      33: 33,
      35: 35,
      40: 40,
      51: 51,
      7: 7,
      71: 71
    }],
    212: [function(t, e, n) {
      var r = t(72),
        o = t(33),
        i = t(7),
        a = t(120);
      o(o.S + o.F * t(35)(function() {
        Reflect.defineProperty(r.f({}, 1, {
          value: 1
        }), 1, {
          value: 2
        })
      }), "Reflect", {
        defineProperty: function(t, e, n) {
          i(t), e = a(e, !0), i(n);
          try {
            return r.f(t, e, n), !0
          } catch (t) {
            return !1
          }
        }
      })
    }, {
      120: 120,
      33: 33,
      35: 35,
      7: 7,
      72: 72
    }],
    213: [function(t, e, n) {
      var r = t(33),
        o = t(75).f,
        i = t(7);
      r(r.S, "Reflect", {
        deleteProperty: function(t, e) {
          var n = o(i(t), e);
          return !(n && !n.configurable) && delete t[e]
        }
      })
    }, {
      33: 33,
      7: 7,
      75: 75
    }],
    214: [function(t, e, n) {
      var r = t(33),
        o = t(7),
        i = function(t) {
          this._t = o(t), this._i = 0;
          var e, n = this._k = [];
          for (e in t) n.push(e)
        };
      t(54)(i, "Object", function() {
        var t, e = this._k;
        do {
          if (this._i >= e.length) return {
            value: void 0,
            done: !0
          }
        } while (!((t = e[this._i++]) in this._t));
        return {
          value: t,
          done: !1
        }
      }), r(r.S, "Reflect", {
        enumerate: function(t) {
          return new i(t)
        }
      })
    }, {
      33: 33,
      54: 54,
      7: 7
    }],
    215: [function(t, e, n) {
      var r = t(75),
        o = t(33),
        i = t(7);
      o(o.S, "Reflect", {
        getOwnPropertyDescriptor: function(t, e) {
          return r.f(i(t), e)
        }
      })
    }, {
      33: 33,
      7: 7,
      75: 75
    }],
    216: [function(t, e, n) {
      var r = t(33),
        o = t(79),
        i = t(7);
      r(r.S, "Reflect", {
        getPrototypeOf: function(t) {
          return o(i(t))
        }
      })
    }, {
      33: 33,
      7: 7,
      79: 79
    }],
    217: [function(t, e, n) {
      var a = t(75),
        c = t(79),
        s = t(41),
        r = t(33),
        u = t(51),
        l = t(7);
      r(r.S, "Reflect", {
        get: function t(e, n) {
          var r, o, i = arguments.length < 3 ? e : arguments[2];
          return l(e) === i ? e[n] : (r = a.f(e, n)) ? s(r, "value") ? r.value : void 0 !== r.get ? r.get.call(i) : void 0 : u(o = c(e)) ? t(o, n, i) : void 0
        }
      })
    }, {
      33: 33,
      41: 41,
      51: 51,
      7: 7,
      75: 75,
      79: 79
    }],
    218: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Reflect", {
        has: function(t, e) {
          return e in t
        }
      })
    }, {
      33: 33
    }],
    219: [function(t, e, n) {
      var r = t(33),
        o = t(7),
        i = Object.isExtensible;
      r(r.S, "Reflect", {
        isExtensible: function(t) {
          return o(t), !i || i(t)
        }
      })
    }, {
      33: 33,
      7: 7
    }],
    220: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Reflect", {
        ownKeys: t(85)
      })
    }, {
      33: 33,
      85: 85
    }],
    221: [function(t, e, n) {
      var r = t(33),
        o = t(7),
        i = Object.preventExtensions;
      r(r.S, "Reflect", {
        preventExtensions: function(t) {
          o(t);
          try {
            return i && i(t), !0
          } catch (t) {
            return !1
          }
        }
      })
    }, {
      33: 33,
      7: 7
    }],
    222: [function(t, e, n) {
      var r = t(33),
        o = t(99);
      o && r(r.S, "Reflect", {
        setPrototypeOf: function(t, e) {
          o.check(t, e);
          try {
            return o.set(t, e), !0
          } catch (t) {
            return !1
          }
        }
      })
    }, {
      33: 33,
      99: 99
    }],
    223: [function(t, e, n) {
      var s = t(72),
        u = t(75),
        l = t(79),
        f = t(41),
        r = t(33),
        p = t(92),
        d = t(7),
        h = t(51);
      r(r.S, "Reflect", {
        set: function t(e, n, r) {
          var o, i, a = arguments.length < 4 ? e : arguments[3],
            c = u.f(d(e), n);
          if (!c) {
            if (h(i = l(e))) return t(i, n, r, a);
            c = p(0)
          }
          return f(c, "value") ? !(!1 === c.writable || !h(a) || ((o = u.f(a, n) || p(0)).value = r, s.f(a, n, o), 0)) : void 0 !== c.set && (c.set.call(a, r), !0)
        }
      })
    }, {
      33: 33,
      41: 41,
      51: 51,
      7: 7,
      72: 72,
      75: 75,
      79: 79,
      92: 92
    }],
    224: [function(t, e, n) {
      var r = t(40),
        i = t(45),
        o = t(72).f,
        a = t(77).f,
        c = t(52),
        s = t(37),
        u = r.RegExp,
        l = u,
        f = u.prototype,
        p = /a/g,
        d = /a/g,
        h = new u(p) !== p;
      if (t(29) && (!h || t(35)(function() {
          return d[t(128)("match")] = !1, u(p) != p || u(d) == d || "/a/i" != u(p, "i")
        }))) {
        u = function(t, e) {
          var n = this instanceof u,
            r = c(t),
            o = void 0 === e;
          return !n && r && t.constructor === u && o ? t : i(h ? new l(r && !o ? t.source : t, e) : l((r = t instanceof u) ? t.source : t, r && o ? s.call(t) : e), n ? this : f, u)
        };
        for (var v = a(l), g = 0; v.length > g;) ! function(e) {
          e in u || o(u, e, {
            configurable: !0,
            get: function() {
              return l[e]
            },
            set: function(t) {
              l[e] = t
            }
          })
        }(v[g++]);
        (f.constructor = u).prototype = f, t(94)(r, "RegExp", u)
      }
      t(100)("RegExp")
    }, {
      100: 100,
      128: 128,
      29: 29,
      35: 35,
      37: 37,
      40: 40,
      45: 45,
      52: 52,
      72: 72,
      77: 77,
      94: 94
    }],
    225: [function(t, e, n) {
      t(29) && "g" != /./g.flags && t(72).f(RegExp.prototype, "flags", {
        configurable: !0,
        get: t(37)
      })
    }, {
      29: 29,
      37: 37,
      72: 72
    }],
    226: [function(t, e, n) {
      t(36)("match", 1, function(r, o, t) {
        return [function(t) {
          var e = r(this),
            n = null == t ? void 0 : t[o];
          return void 0 !== n ? n.call(t, e) : new RegExp(t)[o](String(e))
        }, t]
      })
    }, {
      36: 36
    }],
    227: [function(t, e, n) {
      t(36)("replace", 2, function(o, i, a) {
        return [function(t, e) {
          var n = o(this),
            r = null == t ? void 0 : t[i];
          return void 0 !== r ? r.call(t, n, e) : a.call(String(n), t, e)
        }, a]
      })
    }, {
      36: 36
    }],
    228: [function(t, e, n) {
      t(36)("search", 1, function(r, o, t) {
        return [function(t) {
          var e = r(this),
            n = null == t ? void 0 : t[o];
          return void 0 !== n ? n.call(t, e) : new RegExp(t)[o](String(e))
        }, t]
      })
    }, {
      36: 36
    }],
    229: [function(t, e, n) {
      t(36)("split", 2, function(o, i, a) {
        var d = t(52),
          h = a,
          v = [].push,
          g = "length";
        if ("c" == "abbc".split(/(b)*/)[1] || 4 != "test".split(/(?:)/, -1)[g] || 2 != "ab".split(/(?:ab)*/)[g] || 4 != ".".split(/(.?)(.?)/)[g] || 1 < ".".split(/()()/)[g] || "".split(/.?/)[g]) {
          var _ = void 0 === /()??/.exec("")[1];
          a = function(t, e) {
            var n = String(this);
            if (void 0 === t && 0 === e) return [];
            if (!d(t)) return h.call(n, t, e);
            var r, o, i, a, c, s = [],
              u = (t.ignoreCase ? "i" : "") + (t.multiline ? "m" : "") + (t.unicode ? "u" : "") + (t.sticky ? "y" : ""),
              l = 0,
              f = void 0 === e ? 4294967295 : e >>> 0,
              p = new RegExp(t.source, u + "g");
            for (_ || (r = new RegExp("^" + p.source + "$(?!\\s)", u));
              (o = p.exec(n)) && !((i = o.index + o[0][g]) > l && (s.push(n.slice(l, o.index)), !_ && 1 < o[g] && o[0].replace(r, function() {
                for (c = 1; c < arguments[g] - 2; c++) void 0 === arguments[c] && (o[c] = void 0)
              }), 1 < o[g] && o.index < n[g] && v.apply(s, o.slice(1)), a = o[0][g], l = i, s[g] >= f));) p.lastIndex === o.index && p.lastIndex++;
            return l === n[g] ? !a && p.test("") || s.push("") : s.push(n.slice(l)), s[g] > f ? s.slice(0, f) : s
          }
        } else "0".split(void 0, 0)[g] && (a = function(t, e) {
          return void 0 === t && 0 === e ? [] : h.call(this, t, e)
        });
        return [function(t, e) {
          var n = o(this),
            r = null == t ? void 0 : t[i];
          return void 0 !== r ? r.call(t, n, e) : a.call(String(n), t, e)
        }, a]
      })
    }, {
      36: 36,
      52: 52
    }],
    230: [function(e, t, n) {
      e(225);
      var r = e(7),
        o = e(37),
        i = e(29),
        a = /./.toString,
        c = function(t) {
          e(94)(RegExp.prototype, "toString", t, !0)
        };
      e(35)(function() {
        return "/a/b" != a.call({
          source: "a",
          flags: "b"
        })
      }) ? c(function() {
        var t = r(this);
        return "/".concat(t.source, "/", "flags" in t ? t.flags : !i && t instanceof RegExp ? o.call(t) : void 0)
      }) : "toString" != a.name && c(function() {
        return a.call(this)
      })
    }, {
      225: 225,
      29: 29,
      35: 35,
      37: 37,
      7: 7,
      94: 94
    }],
    231: [function(t, e, n) {
      var r = t(19),
        o = t(125);
      e.exports = t(22)("Set", function(t) {
        return function() {
          return t(this, 0 < arguments.length ? arguments[0] : void 0)
        }
      }, {
        add: function(t) {
          return r.def(o(this, "Set"), t = 0 === t ? 0 : t, t)
        }
      }, r)
    }, {
      125: 125,
      19: 19,
      22: 22
    }],
    232: [function(t, e, n) {
      t(108)("anchor", function(e) {
        return function(t) {
          return e(this, "a", "name", t)
        }
      })
    }, {
      108: 108
    }],
    233: [function(t, e, n) {
      t(108)("big", function(t) {
        return function() {
          return t(this, "big", "", "")
        }
      })
    }, {
      108: 108
    }],
    234: [function(t, e, n) {
      t(108)("blink", function(t) {
        return function() {
          return t(this, "blink", "", "")
        }
      })
    }, {
      108: 108
    }],
    235: [function(t, e, n) {
      t(108)("bold", function(t) {
        return function() {
          return t(this, "b", "", "")
        }
      })
    }, {
      108: 108
    }],
    236: [function(t, e, n) {
      var r = t(33),
        o = t(106)(!1);
      r(r.P, "String", {
        codePointAt: function(t) {
          return o(this, t)
        }
      })
    }, {
      106: 106,
      33: 33
    }],
    237: [function(t, e, n) {
      var r = t(33),
        a = t(118),
        c = t(107),
        s = "".endsWith;
      r(r.P + r.F * t(34)("endsWith"), "String", {
        endsWith: function(t) {
          var e = c(this, t, "endsWith"),
            n = 1 < arguments.length ? arguments[1] : void 0,
            r = a(e.length),
            o = void 0 === n ? r : Math.min(a(n), r),
            i = String(t);
          return s ? s.call(e, i, o) : e.slice(o - i.length, o) === i
        }
      })
    }, {
      107: 107,
      118: 118,
      33: 33,
      34: 34
    }],
    238: [function(t, e, n) {
      t(108)("fixed", function(t) {
        return function() {
          return t(this, "tt", "", "")
        }
      })
    }, {
      108: 108
    }],
    239: [function(t, e, n) {
      t(108)("fontcolor", function(e) {
        return function(t) {
          return e(this, "font", "color", t)
        }
      })
    }, {
      108: 108
    }],
    240: [function(t, e, n) {
      t(108)("fontsize", function(e) {
        return function(t) {
          return e(this, "font", "size", t)
        }
      })
    }, {
      108: 108
    }],
    241: [function(t, e, n) {
      var r = t(33),
        i = t(114),
        a = String.fromCharCode,
        o = String.fromCodePoint;
      r(r.S + r.F * (!!o && 1 != o.length), "String", {
        fromCodePoint: function(t) {
          for (var e, n = [], r = arguments.length, o = 0; o < r;) {
            if (e = +arguments[o++], i(e, 1114111) !== e) throw RangeError(e + " is not a valid code point");
            n.push(e < 65536 ? a(e) : a(55296 + ((e -= 65536) >> 10), e % 1024 + 56320))
          }
          return n.join("")
        }
      })
    }, {
      114: 114,
      33: 33
    }],
    242: [function(t, e, n) {
      var r = t(33),
        o = t(107);
      r(r.P + r.F * t(34)("includes"), "String", {
        includes: function(t) {
          return !!~o(this, t, "includes").indexOf(t, 1 < arguments.length ? arguments[1] : void 0)
        }
      })
    }, {
      107: 107,
      33: 33,
      34: 34
    }],
    243: [function(t, e, n) {
      t(108)("italics", function(t) {
        return function() {
          return t(this, "i", "", "")
        }
      })
    }, {
      108: 108
    }],
    244: [function(t, e, n) {
      var r = t(106)(!0);
      t(55)(String, "String", function(t) {
        this._t = String(t), this._i = 0
      }, function() {
        var t, e = this._t,
          n = this._i;
        return n >= e.length ? {
          value: void 0,
          done: !0
        } : (t = r(e, n), this._i += t.length, {
          value: t,
          done: !1
        })
      })
    }, {
      106: 106,
      55: 55
    }],
    245: [function(t, e, n) {
      t(108)("link", function(e) {
        return function(t) {
          return e(this, "a", "href", t)
        }
      })
    }, {
      108: 108
    }],
    246: [function(t, e, n) {
      var r = t(33),
        a = t(117),
        c = t(118);
      r(r.S, "String", {
        raw: function(t) {
          for (var e = a(t.raw), n = c(e.length), r = arguments.length, o = [], i = 0; i < n;) o.push(String(e[i++])), i < r && o.push(String(arguments[i]));
          return o.join("")
        }
      })
    }, {
      117: 117,
      118: 118,
      33: 33
    }],
    247: [function(t, e, n) {
      var r = t(33);
      r(r.P, "String", {
        repeat: t(110)
      })
    }, {
      110: 110,
      33: 33
    }],
    248: [function(t, e, n) {
      t(108)("small", function(t) {
        return function() {
          return t(this, "small", "", "")
        }
      })
    }, {
      108: 108
    }],
    249: [function(t, e, n) {
      var r = t(33),
        o = t(118),
        i = t(107),
        a = "".startsWith;
      r(r.P + r.F * t(34)("startsWith"), "String", {
        startsWith: function(t) {
          var e = i(this, t, "startsWith"),
            n = o(Math.min(1 < arguments.length ? arguments[1] : void 0, e.length)),
            r = String(t);
          return a ? a.call(e, r, n) : e.slice(n, n + r.length) === r
        }
      })
    }, {
      107: 107,
      118: 118,
      33: 33,
      34: 34
    }],
    250: [function(t, e, n) {
      t(108)("strike", function(t) {
        return function() {
          return t(this, "strike", "", "")
        }
      })
    }, {
      108: 108
    }],
    251: [function(t, e, n) {
      t(108)("sub", function(t) {
        return function() {
          return t(this, "sub", "", "")
        }
      })
    }, {
      108: 108
    }],
    252: [function(t, e, n) {
      t(108)("sup", function(t) {
        return function() {
          return t(this, "sup", "", "")
        }
      })
    }, {
      108: 108
    }],
    253: [function(t, e, n) {
      t(111)("trim", function(t) {
        return function() {
          return t(this, 3)
        }
      })
    }, {
      111: 111
    }],
    254: [function(t, e, n) {
      var r = t(40),
        a = t(41),
        o = t(29),
        i = t(33),
        c = t(94),
        s = t(66).KEY,
        u = t(35),
        l = t(103),
        f = t(101),
        p = t(124),
        d = t(128),
        h = t(127),
        v = t(126),
        g = t(59),
        _ = t(32),
        y = t(49),
        m = t(7),
        b = t(117),
        x = t(120),
        k = t(92),
        w = t(71),
        S = t(76),
        E = t(75),
        I = t(72),
        T = t(81),
        P = E.f,
        O = I.f,
        j = S.f,
        C = r.Symbol,
        R = r.JSON,
        M = R && R.stringify,
        N = d("_hidden"),
        F = d("toPrimitive"),
        L = {}.propertyIsEnumerable,
        A = l("symbol-registry"),
        D = l("symbols"),
        U = l("op-symbols"),
        B = Object.prototype,
        z = "function" == typeof C,
        H = r.QObject,
        W = !H || !H.prototype || !H.prototype.findChild,
        G = o && u(function() {
          return 7 != w(O({}, "a", {
            get: function() {
              return O(this, "a", {
                value: 7
              }).a
            }
          })).a
        }) ? function(t, e, n) {
          var r = P(B, e);
          r && delete B[e], O(t, e, n), r && t !== B && O(B, e, r)
        } : O,
        q = function(t) {
          var e = D[t] = w(C.prototype);
          return e._k = t, e
        },
        V = z && "symbol" == _typeof(C.iterator) ? function(t) {
          return "symbol" == (void 0 === t ? "undefined" : _typeof(t))
        } : function(t) {
          return t instanceof C
        },
        J = function(t, e, n) {
          return t === B && J(U, e, n), m(t), e = x(e, !0), m(n), a(D, e) ? (n.enumerable ? (a(t, N) && t[N][e] && (t[N][e] = !1), n = w(n, {
            enumerable: k(0, !1)
          })) : (a(t, N) || O(t, N, k(1, {})), t[N][e] = !0), G(t, e, n)) : O(t, e, n)
        },
        K = function(t, e) {
          m(t);
          for (var n, r = _(e = b(e)), o = 0, i = r.length; o < i;) J(t, n = r[o++], e[n]);
          return t
        },
        Y = function(t) {
          var e = L.call(this, t = x(t, !0));
          return !(this === B && a(D, t) && !a(U, t)) && (!(e || !a(this, t) || !a(D, t) || a(this, N) && this[N][t]) || e)
        },
        $ = function(t, e) {
          if (t = b(t), e = x(e, !0), t !== B || !a(D, e) || a(U, e)) {
            var n = P(t, e);
            return !n || !a(D, e) || a(t, N) && t[N][e] || (n.enumerable = !0), n
          }
        },
        X = function(t) {
          for (var e, n = j(b(t)), r = [], o = 0; n.length > o;) a(D, e = n[o++]) || e == N || e == s || r.push(e);
          return r
        },
        Z = function(t) {
          for (var e, n = t === B, r = j(n ? U : b(t)), o = [], i = 0; r.length > i;) !a(D, e = r[i++]) || n && !a(B, e) || o.push(D[e]);
          return o
        };
      z || (c((C = function() {
        if (this instanceof C) throw TypeError("Symbol is not a constructor!");
        var n = p(0 < arguments.length ? arguments[0] : void 0);
        return o && W && G(B, n, {
          configurable: !0,
          set: function t(e) {
            this === B && t.call(U, e), a(this, N) && a(this[N], n) && (this[N][n] = !1), G(this, n, k(1, e))
          }
        }), q(n)
      }).prototype, "toString", function() {
        return this._k
      }), E.f = $, I.f = J, t(77).f = S.f = X, t(82).f = Y, t(78).f = Z, o && !t(60) && c(B, "propertyIsEnumerable", Y, !0), h.f = function(t) {
        return q(d(t))
      }), i(i.G + i.W + i.F * !z, {
        Symbol: C
      });
      for (var Q = "hasInstance,isConcatSpreadable,iterator,match,replace,search,species,split,toPrimitive,toStringTag,unscopables".split(","), tt = 0; Q.length > tt;) d(Q[tt++]);
      for (var et = T(d.store), nt = 0; et.length > nt;) v(et[nt++]);
      i(i.S + i.F * !z, "Symbol", {
        for: function(t) {
          return a(A, t += "") ? A[t] : A[t] = C(t)
        },
        keyFor: function(t) {
          if (V(t)) return g(A, t);
          throw TypeError(t + " is not a symbol!")
        },
        useSetter: function() {
          W = !0
        },
        useSimple: function() {
          W = !1
        }
      }), i(i.S + i.F * !z, "Object", {
        create: function(t, e) {
          return void 0 === e ? w(t) : K(w(t), e)
        },
        defineProperty: J,
        defineProperties: K,
        getOwnPropertyDescriptor: $,
        getOwnPropertyNames: X,
        getOwnPropertySymbols: Z
      }), R && i(i.S + i.F * (!z || u(function() {
        var t = C();
        return "[null]" != M([t]) || "{}" != M({
          a: t
        }) || "{}" != M(Object(t))
      })), "JSON", {
        stringify: function(t) {
          if (void 0 !== t && !V(t)) {
            for (var e, n, r = [t], o = 1; arguments.length > o;) r.push(arguments[o++]);
            return "function" == typeof(e = r[1]) && (n = e), !n && y(e) || (e = function(t, e) {
              if (n && (e = n.call(this, t, e)), !V(e)) return e
            }), r[1] = e, M.apply(R, r)
          }
        }
      }), C.prototype[F] || t(42)(C.prototype, F, C.prototype.valueOf), f(C, "Symbol"), f(Math, "Math", !0), f(r.JSON, "JSON", !0)
    }, {
      101: 101,
      103: 103,
      117: 117,
      120: 120,
      124: 124,
      126: 126,
      127: 127,
      128: 128,
      29: 29,
      32: 32,
      33: 33,
      35: 35,
      40: 40,
      41: 41,
      42: 42,
      49: 49,
      59: 59,
      60: 60,
      66: 66,
      7: 7,
      71: 71,
      72: 72,
      75: 75,
      76: 76,
      77: 77,
      78: 78,
      81: 81,
      82: 82,
      92: 92,
      94: 94
    }],
    255: [function(t, e, n) {
      var r = t(33),
        o = t(123),
        i = t(122),
        u = t(7),
        l = t(114),
        f = t(118),
        a = t(51),
        c = t(40).ArrayBuffer,
        p = t(104),
        d = i.ArrayBuffer,
        h = i.DataView,
        s = o.ABV && c.isView,
        v = d.prototype.slice,
        g = o.VIEW;
      r(r.G + r.W + r.F * (c !== d), {
        ArrayBuffer: d
      }), r(r.S + r.F * !o.CONSTR, "ArrayBuffer", {
        isView: function(t) {
          return s && s(t) || a(t) && g in t
        }
      }), r(r.P + r.U + r.F * t(35)(function() {
        return !new d(2).slice(1, void 0).byteLength
      }), "ArrayBuffer", {
        slice: function(t, e) {
          if (void 0 !== v && void 0 === e) return v.call(u(this), t);
          for (var n = u(this).byteLength, r = l(t, n), o = l(void 0 === e ? n : e, n), i = new(p(this, d))(f(o - r)), a = new h(this), c = new h(i), s = 0; r < o;) c.setUint8(s++, a.getUint8(r++));
          return i
        }
      }), t(100)("ArrayBuffer")
    }, {
      100: 100,
      104: 104,
      114: 114,
      118: 118,
      122: 122,
      123: 123,
      33: 33,
      35: 35,
      40: 40,
      51: 51,
      7: 7
    }],
    256: [function(t, e, n) {
      var r = t(33);
      r(r.G + r.W + r.F * !t(123).ABV, {
        DataView: t(122).DataView
      })
    }, {
      122: 122,
      123: 123,
      33: 33
    }],
    257: [function(t, e, n) {
      t(121)("Float32", 4, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    258: [function(t, e, n) {
      t(121)("Float64", 8, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    259: [function(t, e, n) {
      t(121)("Int16", 2, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    260: [function(t, e, n) {
      t(121)("Int32", 4, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    261: [function(t, e, n) {
      t(121)("Int8", 1, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    262: [function(t, e, n) {
      t(121)("Uint16", 2, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    263: [function(t, e, n) {
      t(121)("Uint32", 4, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    264: [function(t, e, n) {
      t(121)("Uint8", 1, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      })
    }, {
      121: 121
    }],
    265: [function(t, e, n) {
      t(121)("Uint8", 1, function(r) {
        return function(t, e, n) {
          return r(this, t, e, n)
        }
      }, !0)
    }, {
      121: 121
    }],
    266: [function(t, e, n) {
      var i, r = t(12)(0),
        a = t(94),
        o = t(66),
        c = t(70),
        s = t(21),
        u = t(51),
        l = t(35),
        f = t(125),
        p = o.getWeak,
        d = Object.isExtensible,
        h = s.ufstore,
        v = {},
        g = function(t) {
          return function() {
            return t(this, 0 < arguments.length ? arguments[0] : void 0)
          }
        },
        _ = {
          get: function(t) {
            if (u(t)) {
              var e = p(t);
              return !0 === e ? h(f(this, "WeakMap")).get(t) : e ? e[this._i] : void 0
            }
          },
          set: function(t, e) {
            return s.def(f(this, "WeakMap"), t, e)
          }
        },
        y = e.exports = t(22)("WeakMap", g, _, s, !0, !0);
      l(function() {
        return 7 != (new y).set((Object.freeze || Object)(v), 7).get(v)
      }) && (c((i = s.getConstructor(g, "WeakMap")).prototype, _), o.NEED = !0, r(["delete", "has", "get", "set"], function(r) {
        var t = y.prototype,
          o = t[r];
        a(t, r, function(t, e) {
          if (!u(t) || d(t)) return o.call(this, t, e);
          this._f || (this._f = new i);
          var n = this._f[r](t, e);
          return "set" == r ? this : n
        })
      }))
    }, {
      12: 12,
      125: 125,
      21: 21,
      22: 22,
      35: 35,
      51: 51,
      66: 66,
      70: 70,
      94: 94
    }],
    267: [function(t, e, n) {
      var r = t(21),
        o = t(125);
      t(22)("WeakSet", function(t) {
        return function() {
          return t(this, 0 < arguments.length ? arguments[0] : void 0)
        }
      }, {
        add: function(t) {
          return r.def(o(this, "WeakSet"), t, !0)
        }
      }, r, !1, !0)
    }, {
      125: 125,
      21: 21,
      22: 22
    }],
    268: [function(t, e, n) {
      var r = t(33),
        o = t(38),
        i = t(119),
        a = t(118),
        c = t(3),
        s = t(15);
      r(r.P, "Array", {
        flatMap: function(t) {
          var e, n, r = i(this);
          return c(t), e = a(r.length), n = s(r, 0), o(n, r, r, e, 0, 1, t, arguments[1]), n
        }
      }), t(5)("flatMap")
    }, {
      118: 118,
      119: 119,
      15: 15,
      3: 3,
      33: 33,
      38: 38,
      5: 5
    }],
    269: [function(t, e, n) {
      var r = t(33),
        o = t(38),
        i = t(119),
        a = t(118),
        c = t(116),
        s = t(15);
      r(r.P, "Array", {
        flatten: function() {
          var t = arguments[0],
            e = i(this),
            n = a(e.length),
            r = s(e, 0);
          return o(r, e, e, n, 0, void 0 === t ? 1 : c(t)), r
        }
      }), t(5)("flatten")
    }, {
      116: 116,
      118: 118,
      119: 119,
      15: 15,
      33: 33,
      38: 38,
      5: 5
    }],
    270: [function(t, e, n) {
      var r = t(33),
        o = t(11)(!0);
      r(r.P, "Array", {
        includes: function(t) {
          return o(this, t, 1 < arguments.length ? arguments[1] : void 0)
        }
      }), t(5)("includes")
    }, {
      11: 11,
      33: 33,
      5: 5
    }],
    271: [function(t, e, n) {
      var r = t(33),
        o = t(68)(),
        i = t(40).process,
        a = "process" == t(18)(i);
      r(r.G, {
        asap: function(t) {
          var e = a && i.domain;
          o(e ? e.bind(t) : t)
        }
      })
    }, {
      18: 18,
      33: 33,
      40: 40,
      68: 68
    }],
    272: [function(t, e, n) {
      var r = t(33),
        o = t(18);
      r(r.S, "Error", {
        isError: function(t) {
          return "Error" === o(t)
        }
      })
    }, {
      18: 18,
      33: 33
    }],
    273: [function(t, e, n) {
      var r = t(33);
      r(r.G, {
        global: t(40)
      })
    }, {
      33: 33,
      40: 40
    }],
    274: [function(t, e, n) {
      t(97)("Map")
    }, {
      97: 97
    }],
    275: [function(t, e, n) {
      t(98)("Map")
    }, {
      98: 98
    }],
    276: [function(t, e, n) {
      var r = t(33);
      r(r.P + r.R, "Map", {
        toJSON: t(20)("Map")
      })
    }, {
      20: 20,
      33: 33
    }],
    277: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        clamp: function(t, e, n) {
          return Math.min(n, Math.max(e, t))
        }
      })
    }, {
      33: 33
    }],
    278: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        DEG_PER_RAD: Math.PI / 180
      })
    }, {
      33: 33
    }],
    279: [function(t, e, n) {
      var r = t(33),
        o = 180 / Math.PI;
      r(r.S, "Math", {
        degrees: function(t) {
          return t * o
        }
      })
    }, {
      33: 33
    }],
    280: [function(t, e, n) {
      var r = t(33),
        i = t(64),
        a = t(62);
      r(r.S, "Math", {
        fscale: function(t, e, n, r, o) {
          return a(i(t, e, n, r, o))
        }
      })
    }, {
      33: 33,
      62: 62,
      64: 64
    }],
    281: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        iaddh: function(t, e, n, r) {
          var o = t >>> 0,
            i = n >>> 0;
          return (e >>> 0) + (r >>> 0) + ((o & i | (o | i) & ~(o + i >>> 0)) >>> 31) | 0
        }
      })
    }, {
      33: 33
    }],
    282: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        imulh: function(t, e) {
          var n = +t,
            r = +e,
            o = 65535 & n,
            i = 65535 & r,
            a = n >> 16,
            c = r >> 16,
            s = (a * i >>> 0) + (o * i >>> 16);
          return a * c + (s >> 16) + ((o * c >>> 0) + (65535 & s) >> 16)
        }
      })
    }, {
      33: 33
    }],
    283: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        isubh: function(t, e, n, r) {
          var o = t >>> 0,
            i = n >>> 0;
          return (e >>> 0) - (r >>> 0) - ((~o & i | ~(o ^ i) & o - i >>> 0) >>> 31) | 0
        }
      })
    }, {
      33: 33
    }],
    284: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        RAD_PER_DEG: 180 / Math.PI
      })
    }, {
      33: 33
    }],
    285: [function(t, e, n) {
      var r = t(33),
        o = Math.PI / 180;
      r(r.S, "Math", {
        radians: function(t) {
          return t * o
        }
      })
    }, {
      33: 33
    }],
    286: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        scale: t(64)
      })
    }, {
      33: 33,
      64: 64
    }],
    287: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        signbit: function(t) {
          return (t = +t) != t ? t : 0 == t ? 1 / t == 1 / 0 : 0 < t
        }
      })
    }, {
      33: 33
    }],
    288: [function(t, e, n) {
      var r = t(33);
      r(r.S, "Math", {
        umulh: function(t, e) {
          var n = +t,
            r = +e,
            o = 65535 & n,
            i = 65535 & r,
            a = n >>> 16,
            c = r >>> 16,
            s = (a * i >>> 0) + (o * i >>> 16);
          return a * c + (s >>> 16) + ((o * c >>> 0) + (65535 & s) >>> 16)
        }
      })
    }, {
      33: 33
    }],
    289: [function(t, e, n) {
      var r = t(33),
        o = t(119),
        i = t(3),
        a = t(72);
      t(29) && r(r.P + t(74), "Object", {
        __defineGetter__: function(t, e) {
          a.f(o(this), t, {
            get: i(e),
            enumerable: !0,
            configurable: !0
          })
        }
      })
    }, {
      119: 119,
      29: 29,
      3: 3,
      33: 33,
      72: 72,
      74: 74
    }],
    290: [function(t, e, n) {
      var r = t(33),
        o = t(119),
        i = t(3),
        a = t(72);
      t(29) && r(r.P + t(74), "Object", {
        __defineSetter__: function(t, e) {
          a.f(o(this), t, {
            set: i(e),
            enumerable: !0,
            configurable: !0
          })
        }
      })
    }, {
      119: 119,
      29: 29,
      3: 3,
      33: 33,
      72: 72,
      74: 74
    }],
    291: [function(t, e, n) {
      var r = t(33),
        o = t(84)(!0);
      r(r.S, "Object", {
        entries: function(t) {
          return o(t)
        }
      })
    }, {
      33: 33,
      84: 84
    }],
    292: [function(t, e, n) {
      var r = t(33),
        s = t(85),
        u = t(117),
        l = t(75),
        f = t(24);
      r(r.S, "Object", {
        getOwnPropertyDescriptors: function(t) {
          for (var e, n, r = u(t), o = l.f, i = s(r), a = {}, c = 0; i.length > c;) void 0 !== (n = o(r, e = i[c++])) && f(a, e, n);
          return a
        }
      })
    }, {
      117: 117,
      24: 24,
      33: 33,
      75: 75,
      85: 85
    }],
    293: [function(t, e, n) {
      var r = t(33),
        o = t(119),
        i = t(120),
        a = t(79),
        c = t(75).f;
      t(29) && r(r.P + t(74), "Object", {
        __lookupGetter__: function(t) {
          var e, n = o(this),
            r = i(t, !0);
          do {
            if (e = c(n, r)) return e.get
          } while (n = a(n))
        }
      })
    }, {
      119: 119,
      120: 120,
      29: 29,
      33: 33,
      74: 74,
      75: 75,
      79: 79
    }],
    294: [function(t, e, n) {
      var r = t(33),
        o = t(119),
        i = t(120),
        a = t(79),
        c = t(75).f;
      t(29) && r(r.P + t(74), "Object", {
        __lookupSetter__: function(t) {
          var e, n = o(this),
            r = i(t, !0);
          do {
            if (e = c(n, r)) return e.set
          } while (n = a(n))
        }
      })
    }, {
      119: 119,
      120: 120,
      29: 29,
      33: 33,
      74: 74,
      75: 75,
      79: 79
    }],
    295: [function(t, e, n) {
      var r = t(33),
        o = t(84)(!1);
      r(r.S, "Object", {
        values: function(t) {
          return o(t)
        }
      })
    }, {
      33: 33,
      84: 84
    }],
    296: [function(t, e, n) {
      var r = t(33),
        i = t(40),
        a = t(23),
        o = t(68)(),
        c = t(128)("observable"),
        s = t(3),
        u = t(7),
        l = t(6),
        f = t(93),
        p = t(42),
        d = t(39),
        h = d.RETURN,
        v = function(t) {
          return null == t ? void 0 : s(t)
        },
        g = function(t) {
          var e = t._c;
          e && (t._c = void 0, e())
        },
        _ = function(t) {
          return void 0 === t._o
        },
        y = function(t) {
          _(t) || (t._o = void 0, g(t))
        },
        m = function(t, e) {
          u(t), this._c = void 0, this._o = t, t = new b(this);
          try {
            var n = e(t),
              r = n;
            null != n && ("function" == typeof n.unsubscribe ? n = function() {
              r.unsubscribe()
            } : s(n), this._c = n)
          } catch (e) {
            return void t.error(e)
          }
          _(this) && g(this)
        };
      m.prototype = f({}, {
        unsubscribe: function() {
          y(this)
        }
      });
      var b = function(t) {
        this._s = t
      };
      b.prototype = f({}, {
        next: function(t) {
          var e = this._s;
          if (!_(e)) {
            var n = e._o;
            try {
              var r = v(n.next);
              if (r) return r.call(n, t)
            } catch (t) {
              try {
                y(e)
              } finally {
                throw t
              }
            }
          }
        },
        error: function(t) {
          var e = this._s;
          if (_(e)) throw t;
          var n = e._o;
          e._o = void 0;
          try {
            var r = v(n.error);
            if (!r) throw t;
            t = r.call(n, t)
          } catch (t) {
            try {
              g(e)
            } finally {
              throw t
            }
          }
          return g(e), t
        },
        complete: function(t) {
          var e = this._s;
          if (!_(e)) {
            var n = e._o;
            e._o = void 0;
            try {
              var r = v(n.complete);
              t = r ? r.call(n, t) : void 0
            } catch (t) {
              try {
                g(e)
              } finally {
                throw t
              }
            }
            return g(e), t
          }
        }
      });
      var x = function(t) {
        l(this, x, "Observable", "_f")._f = s(t)
      };
      f(x.prototype, {
        subscribe: function(t) {
          return new m(t, this._f)
        },
        forEach: function(r) {
          var o = this;
          return new(a.Promise || i.Promise)(function(t, e) {
            s(r);
            var n = o.subscribe({
              next: function(t) {
                try {
                  return r(t)
                } catch (t) {
                  e(t), n.unsubscribe()
                }
              },
              error: e,
              complete: t
            })
          })
        }
      }), f(x, {
        from: function(t) {
          var e = "function" == typeof this ? this : x,
            n = v(u(t)[c]);
          if (n) {
            var r = u(n.call(t));
            return r.constructor === e ? r : new e(function(t) {
              return r.subscribe(t)
            })
          }
          return new e(function(e) {
            var n = !1;
            return o(function() {
                if (!n) {
                  try {
                    if (d(t, !1, function(t) {
                        if (e.next(t), n) return h
                      }) === h) return
                  } catch (t) {
                    if (n) throw t;
                    return void e.error(t)
                  }
                  e.complete()
                }
              }),
              function() {
                n = !0
              }
          })
        },
        of: function() {
          for (var t = 0, e = arguments.length, r = Array(e); t < e;) r[t] = arguments[t++];
          return new("function" == typeof this ? this : x)(function(e) {
            var n = !1;
            return o(function() {
                if (!n) {
                  for (var t = 0; t < r.length; ++t)
                    if (e.next(r[t]), n) return;
                  e.complete()
                }
              }),
              function() {
                n = !0
              }
          })
        }
      }), p(x.prototype, c, function() {
        return this
      }), r(r.G, {
        Observable: x
      }), t(100)("Observable")
    }, {
      100: 100,
      128: 128,
      23: 23,
      3: 3,
      33: 33,
      39: 39,
      40: 40,
      42: 42,
      6: 6,
      68: 68,
      7: 7,
      93: 93
    }],
    297: [function(t, e, n) {
      var r = t(33),
        o = t(23),
        i = t(40),
        a = t(104),
        c = t(91);
      r(r.P + r.R, "Promise", {
        finally: function(e) {
          var n = a(this, o.Promise || i.Promise),
            t = "function" == typeof e;
          return this.then(t ? function(t) {
            return c(n, e()).then(function() {
              return t
            })
          } : e, t ? function(t) {
            return c(n, e()).then(function() {
              throw t
            })
          } : e)
        }
      })
    }, {
      104: 104,
      23: 23,
      33: 33,
      40: 40,
      91: 91
    }],
    298: [function(t, e, n) {
      var r = t(33),
        o = t(69),
        i = t(90);
      r(r.S, "Promise", {
        try: function(t) {
          var e = o.f(this),
            n = i(t);
          return (n.e ? e.reject : e.resolve)(n.v), e.promise
        }
      })
    }, {
      33: 33,
      69: 69,
      90: 90
    }],
    299: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = r.key,
        a = r.set;
      r.exp({
        defineMetadata: function(t, e, n, r) {
          a(t, e, o(n), i(r))
        }
      })
    }, {
      67: 67,
      7: 7
    }],
    300: [function(t, e, n) {
      var r = t(67),
        i = t(7),
        a = r.key,
        c = r.map,
        s = r.store;
      r.exp({
        deleteMetadata: function(t, e) {
          var n = arguments.length < 3 ? void 0 : a(arguments[2]),
            r = c(i(e), n, !1);
          if (void 0 === r || !r.delete(t)) return !1;
          if (r.size) return !0;
          var o = s.get(e);
          return o.delete(n), !!o.size || s.delete(e)
        }
      })
    }, {
      67: 67,
      7: 7
    }],
    301: [function(t, e, n) {
      var a = t(231),
        c = t(10),
        r = t(67),
        o = t(7),
        s = t(79),
        u = r.keys,
        i = r.key;
      r.exp({
        getMetadataKeys: function(t) {
          return function t(e, n) {
            var r = u(e, n),
              o = s(e);
            if (null === o) return r;
            var i = t(o, n);
            return i.length ? r.length ? c(new a(r.concat(i))) : i : r
          }(o(t), arguments.length < 2 ? void 0 : i(arguments[1]))
        }
      })
    }, {
      10: 10,
      231: 231,
      67: 67,
      7: 7,
      79: 79
    }],
    302: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = t(79),
        a = r.has,
        c = r.get,
        s = r.key;
      r.exp({
        getMetadata: function(t, e) {
          return function t(e, n, r) {
            if (a(e, n, r)) return c(e, n, r);
            var o = i(n);
            return null !== o ? t(e, o, r) : void 0
          }(t, o(e), arguments.length < 3 ? void 0 : s(arguments[2]))
        }
      })
    }, {
      67: 67,
      7: 7,
      79: 79
    }],
    303: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = r.keys,
        a = r.key;
      r.exp({
        getOwnMetadataKeys: function(t) {
          return i(o(t), arguments.length < 2 ? void 0 : a(arguments[1]))
        }
      })
    }, {
      67: 67,
      7: 7
    }],
    304: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = r.get,
        a = r.key;
      r.exp({
        getOwnMetadata: function(t, e) {
          return i(t, o(e), arguments.length < 3 ? void 0 : a(arguments[2]))
        }
      })
    }, {
      67: 67,
      7: 7
    }],
    305: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = t(79),
        a = r.has,
        c = r.key;
      r.exp({
        hasMetadata: function(t, e) {
          return function t(e, n, r) {
            if (a(e, n, r)) return !0;
            var o = i(n);
            return null !== o && t(e, o, r)
          }(t, o(e), arguments.length < 3 ? void 0 : c(arguments[2]))
        }
      })
    }, {
      67: 67,
      7: 7,
      79: 79
    }],
    306: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = r.has,
        a = r.key;
      r.exp({
        hasOwnMetadata: function(t, e) {
          return i(t, o(e), arguments.length < 3 ? void 0 : a(arguments[2]))
        }
      })
    }, {
      67: 67,
      7: 7
    }],
    307: [function(t, e, n) {
      var r = t(67),
        o = t(7),
        i = t(3),
        a = r.key,
        c = r.set;
      r.exp({
        metadata: function(n, r) {
          return function(t, e) {
            c(n, r, (void 0 !== e ? o : i)(t), a(e))
          }
        }
      })
    }, {
      3: 3,
      67: 67,
      7: 7
    }],
    308: [function(t, e, n) {
      t(97)("Set")
    }, {
      97: 97
    }],
    309: [function(t, e, n) {
      t(98)("Set")
    }, {
      98: 98
    }],
    310: [function(t, e, n) {
      var r = t(33);
      r(r.P + r.R, "Set", {
        toJSON: t(20)("Set")
      })
    }, {
      20: 20,
      33: 33
    }],
    311: [function(t, e, n) {
      var r = t(33),
        o = t(106)(!0);
      r(r.P, "String", {
        at: function(t) {
          return o(this, t)
        }
      })
    }, {
      106: 106,
      33: 33
    }],
    312: [function(t, e, n) {
      var r = t(33),
        o = t(28),
        i = t(118),
        a = t(52),
        c = t(37),
        s = RegExp.prototype,
        u = function(t, e) {
          this._r = t, this._s = e
        };
      t(54)(u, "RegExp String", function() {
        var t = this._r.exec(this._s);
        return {
          value: t,
          done: null === t
        }
      }), r(r.P, "String", {
        matchAll: function(t) {
          if (o(this), !a(t)) throw TypeError(t + " is not a regexp!");
          var e = String(this),
            n = "flags" in s ? String(t.flags) : c.call(t),
            r = new RegExp(t.source, ~n.indexOf("g") ? n : "g" + n);
          return r.lastIndex = i(t.lastIndex), new u(r, e)
        }
      })
    }, {
      118: 118,
      28: 28,
      33: 33,
      37: 37,
      52: 52,
      54: 54
    }],
    313: [function(t, e, n) {
      var r = t(33),
        o = t(109);
      r(r.P, "String", {
        padEnd: function(t) {
          return o(this, t, 1 < arguments.length ? arguments[1] : void 0, !1)
        }
      })
    }, {
      109: 109,
      33: 33
    }],
    314: [function(t, e, n) {
      var r = t(33),
        o = t(109);
      r(r.P, "String", {
        padStart: function(t) {
          return o(this, t, 1 < arguments.length ? arguments[1] : void 0, !0)
        }
      })
    }, {
      109: 109,
      33: 33
    }],
    315: [function(t, e, n) {
      t(111)("trimLeft", function(t) {
        return function() {
          return t(this, 1)
        }
      }, "trimStart")
    }, {
      111: 111
    }],
    316: [function(t, e, n) {
      t(111)("trimRight", function(t) {
        return function() {
          return t(this, 2)
        }
      }, "trimEnd")
    }, {
      111: 111
    }],
    317: [function(t, e, n) {
      t(126)("asyncIterator")
    }, {
      126: 126
    }],
    318: [function(t, e, n) {
      t(126)("observable")
    }, {
      126: 126
    }],
    319: [function(t, e, n) {
      var r = t(33);
      r(r.S, "System", {
        global: t(40)
      })
    }, {
      33: 33,
      40: 40
    }],
    320: [function(t, e, n) {
      t(97)("WeakMap")
    }, {
      97: 97
    }],
    321: [function(t, e, n) {
      t(98)("WeakMap")
    }, {
      98: 98
    }],
    322: [function(t, e, n) {
      t(97)("WeakSet")
    }, {
      97: 97
    }],
    323: [function(t, e, n) {
      t(98)("WeakSet")
    }, {
      98: 98
    }],
    324: [function(t, e, n) {
      for (var r = t(141), o = t(81), i = t(94), a = t(40), c = t(42), s = t(58), u = t(128), l = u("iterator"), f = u("toStringTag"), p = s.Array, d = {
          CSSRuleList: !0,
          CSSStyleDeclaration: !1,
          CSSValueList: !1,
          ClientRectList: !1,
          DOMRectList: !1,
          DOMStringList: !1,
          DOMTokenList: !0,
          DataTransferItemList: !1,
          FileList: !1,
          HTMLAllCollection: !1,
          HTMLCollection: !1,
          HTMLFormElement: !1,
          HTMLSelectElement: !1,
          MediaList: !0,
          MimeTypeArray: !1,
          NamedNodeMap: !1,
          NodeList: !0,
          PaintRequestList: !1,
          Plugin: !1,
          PluginArray: !1,
          SVGLengthList: !1,
          SVGNumberList: !1,
          SVGPathSegList: !1,
          SVGPointList: !1,
          SVGStringList: !1,
          SVGTransformList: !1,
          SourceBufferList: !1,
          StyleSheetList: !0,
          TextTrackCueList: !1,
          TextTrackList: !1,
          TouchList: !1
        }, h = o(d), v = 0; v < h.length; v++) {
        var g, _ = h[v],
          y = d[_],
          m = a[_],
          b = m && m.prototype;
        if (b && (b[l] || c(b, l, p), b[f] || c(b, f, _), s[_] = p, y))
          for (g in r) b[g] || i(b, g, r[g], !0)
      }
    }, {
      128: 128,
      141: 141,
      40: 40,
      42: 42,
      58: 58,
      81: 81,
      94: 94
    }],
    325: [function(t, e, n) {
      var r = t(33),
        o = t(113);
      r(r.G + r.B, {
        setImmediate: o.set,
        clearImmediate: o.clear
      })
    }, {
      113: 113,
      33: 33
    }],
    326: [function(t, e, n) {
      var r = t(40),
        o = t(33),
        i = t(46),
        a = t(88),
        c = r.navigator,
        s = !!c && /MSIE .\./.test(c.userAgent),
        u = function(n) {
          return s ? function(t, e) {
            return n(i(a, [].slice.call(arguments, 2), "function" == typeof t ? t : Function(t)), e)
          } : n
        };
      o(o.G + o.B + o.F * s, {
        setTimeout: u(r.setTimeout),
        setInterval: u(r.setInterval)
      })
    }, {
      33: 33,
      40: 40,
      46: 46,
      88: 88
    }],
    327: [function(t, e, n) {
      t(254), t(191), t(193), t(192), t(195), t(197), t(202), t(196), t(194), t(204), t(203), t(199), t(200), t(198), t(190), t(201), t(205), t(206), t(157), t(159), t(158), t(208), t(207), t(178), t(188), t(189), t(179), t(180), t(181), t(182), t(183), t(184), t(185), t(186), t(187), t(161), t(162), t(163), t(164), t(165), t(166), t(167), t(168), t(169), t(170), t(171), t(172), t(173), t(174), t(175), t(176), t(177), t(241), t(246), t(253), t(244), t(236), t(237), t(242), t(247), t(249), t(232), t(233), t(234), t(235), t(238), t(239), t(240), t(243), t(245), t(248), t(250), t(251), t(252), t(152), t(154), t(153), t(156), t(155), t(140), t(138), t(145), t(142), t(148), t(150), t(137), t(144), t(134), t(149), t(132), t(147), t(146), t(139), t(143), t(131), t(133), t(136), t(135), t(151), t(141), t(224), t(230), t(225), t(226), t(227), t(228), t(229), t(209), t(160), t(231), t(266), t(267), t(255), t(256), t(261), t(264), t(265), t(259), t(262), t(260), t(263), t(257), t(258), t(210), t(211), t(212), t(213), t(214), t(217), t(215), t(216), t(218), t(219), t(220), t(221), t(223), t(222), t(270), t(268), t(269), t(311), t(314), t(313), t(315), t(316), t(312), t(317), t(318), t(292), t(295), t(291), t(289), t(290), t(293), t(294), t(276), t(310), t(275), t(309), t(321), t(323), t(274), t(308), t(320), t(322), t(273), t(319), t(272), t(277), t(278), t(279), t(280), t(281), t(283), t(282), t(284), t(285), t(286), t(288), t(287), t(297), t(298), t(299), t(300), t(302), t(301), t(304), t(303), t(305), t(306), t(307), t(271), t(296), t(326), t(325), t(324), e.exports = t(23)
    }, {
      131: 131,
      132: 132,
      133: 133,
      134: 134,
      135: 135,
      136: 136,
      137: 137,
      138: 138,
      139: 139,
      140: 140,
      141: 141,
      142: 142,
      143: 143,
      144: 144,
      145: 145,
      146: 146,
      147: 147,
      148: 148,
      149: 149,
      150: 150,
      151: 151,
      152: 152,
      153: 153,
      154: 154,
      155: 155,
      156: 156,
      157: 157,
      158: 158,
      159: 159,
      160: 160,
      161: 161,
      162: 162,
      163: 163,
      164: 164,
      165: 165,
      166: 166,
      167: 167,
      168: 168,
      169: 169,
      170: 170,
      171: 171,
      172: 172,
      173: 173,
      174: 174,
      175: 175,
      176: 176,
      177: 177,
      178: 178,
      179: 179,
      180: 180,
      181: 181,
      182: 182,
      183: 183,
      184: 184,
      185: 185,
      186: 186,
      187: 187,
      188: 188,
      189: 189,
      190: 190,
      191: 191,
      192: 192,
      193: 193,
      194: 194,
      195: 195,
      196: 196,
      197: 197,
      198: 198,
      199: 199,
      200: 200,
      201: 201,
      202: 202,
      203: 203,
      204: 204,
      205: 205,
      206: 206,
      207: 207,
      208: 208,
      209: 209,
      210: 210,
      211: 211,
      212: 212,
      213: 213,
      214: 214,
      215: 215,
      216: 216,
      217: 217,
      218: 218,
      219: 219,
      220: 220,
      221: 221,
      222: 222,
      223: 223,
      224: 224,
      225: 225,
      226: 226,
      227: 227,
      228: 228,
      229: 229,
      23: 23,
      230: 230,
      231: 231,
      232: 232,
      233: 233,
      234: 234,
      235: 235,
      236: 236,
      237: 237,
      238: 238,
      239: 239,
      240: 240,
      241: 241,
      242: 242,
      243: 243,
      244: 244,
      245: 245,
      246: 246,
      247: 247,
      248: 248,
      249: 249,
      250: 250,
      251: 251,
      252: 252,
      253: 253,
      254: 254,
      255: 255,
      256: 256,
      257: 257,
      258: 258,
      259: 259,
      260: 260,
      261: 261,
      262: 262,
      263: 263,
      264: 264,
      265: 265,
      266: 266,
      267: 267,
      268: 268,
      269: 269,
      270: 270,
      271: 271,
      272: 272,
      273: 273,
      274: 274,
      275: 275,
      276: 276,
      277: 277,
      278: 278,
      279: 279,
      280: 280,
      281: 281,
      282: 282,
      283: 283,
      284: 284,
      285: 285,
      286: 286,
      287: 287,
      288: 288,
      289: 289,
      290: 290,
      291: 291,
      292: 292,
      293: 293,
      294: 294,
      295: 295,
      296: 296,
      297: 297,
      298: 298,
      299: 299,
      300: 300,
      301: 301,
      302: 302,
      303: 303,
      304: 304,
      305: 305,
      306: 306,
      307: 307,
      308: 308,
      309: 309,
      310: 310,
      311: 311,
      312: 312,
      313: 313,
      314: 314,
      315: 315,
      316: 316,
      317: 317,
      318: 318,
      319: 319,
      320: 320,
      321: 321,
      322: 322,
      323: 323,
      324: 324,
      325: 325,
      326: 326
    }],
    328: [function(t, R, e) {
      (function(t) {
        ! function(t) {
          function i(t, e, n, r) {
            var o = e && e.prototype instanceof c ? e : c,
              i = Object.create(o.prototype),
              a = new f(r || []);
            return i._invoke = function(i, a, c) {
              var s = w;
              return function(t, e) {
                if (s === E) throw new Error("Generator is already running");
                if (s === I) {
                  if ("throw" === t) throw e;
                  return d()
                }
                for (c.method = t, c.arg = e;;) {
                  var n = c.delegate;
                  if (n) {
                    var r = l(n, c);
                    if (r) {
                      if (r === T) continue;
                      return r
                    }
                  }
                  if ("next" === c.method) c.sent = c._sent = c.arg;
                  else if ("throw" === c.method) {
                    if (s === w) throw s = I, c.arg;
                    c.dispatchException(c.arg)
                  } else "return" === c.method && c.abrupt("return", c.arg);
                  s = E;
                  var o = u(i, a, c);
                  if ("normal" === o.type) {
                    if (s = c.done ? I : S, o.arg === T) continue;
                    return {
                      value: o.arg,
                      done: c.done
                    }
                  }
                  "throw" === o.type && (s = I, c.method = "throw", c.arg = o.arg)
                }
              }
            }(t, n, a), i
          }

          function u(t, e, n) {
            try {
              return {
                type: "normal",
                arg: t.call(e, n)
              }
            } catch (t) {
              return {
                type: "throw",
                arg: t
              }
            }
          }

          function c() {}

          function n() {}

          function e() {}

          function r(t) {
            ["next", "throw", "return"].forEach(function(e) {
              t[e] = function(t) {
                return this._invoke(e, t)
              }
            })
          }

          function a(c) {
            function s(t, e, n, r) {
              var o = u(c[t], c, e);
              if ("throw" !== o.type) {
                var i = o.arg,
                  a = i.value;
                return a && "object" == (void 0 === a ? "undefined" : _typeof(a)) && g.call(a, "__await") ? Promise.resolve(a.__await).then(function(t) {
                  s("next", t, n, r)
                }, function(t) {
                  s("throw", t, n, r)
                }) : Promise.resolve(a).then(function(t) {
                  i.value = t, n(i)
                }, r)
              }
              r(o.arg)
            }
            var e;
            "object" == _typeof(t.process) && t.process.domain && (s = t.process.domain.bind(s)), this._invoke = function(n, r) {
              function t() {
                return new Promise(function(t, e) {
                  s(n, r, t, e)
                })
              }
              return e = e ? e.then(t, t) : t()
            }
          }

          function l(t, e) {
            var n = t.iterator[e.method];
            if (n === h) {
              if (e.delegate = null, "throw" === e.method) {
                if (t.iterator.return && (e.method = "return", e.arg = h, l(t, e), "throw" === e.method)) return T;
                e.method = "throw", e.arg = new TypeError("The iterator does not provide a 'throw' method")
              }
              return T
            }
            var r = u(n, t.iterator, e.arg);
            if ("throw" === r.type) return e.method = "throw", e.arg = r.arg, e.delegate = null, T;
            var o = r.arg;
            return o ? o.done ? (e[t.resultName] = o.value, e.next = t.nextLoc, "return" !== e.method && (e.method = "next", e.arg = h), e.delegate = null, T) : o : (e.method = "throw", e.arg = new TypeError("iterator result is not an object"), e.delegate = null, T)
          }

          function o(t) {
            var e = {
              tryLoc: t[0]
            };
            1 in t && (e.catchLoc = t[1]), 2 in t && (e.finallyLoc = t[2], e.afterLoc = t[3]), this.tryEntries.push(e)
          }

          function s(t) {
            var e = t.completion || {};
            e.type = "normal", delete e.arg, t.completion = e
          }

          function f(t) {
            this.tryEntries = [{
              tryLoc: "root"
            }], t.forEach(o, this), this.reset(!0)
          }

          function p(e) {
            if (e) {
              var t = e[y];
              if (t) return t.call(e);
              if ("function" == typeof e.next) return e;
              if (!isNaN(e.length)) {
                var n = -1,
                  r = function t() {
                    for (; ++n < e.length;)
                      if (g.call(e, n)) return t.value = e[n], t.done = !1, t;
                    return t.value = h, t.done = !0, t
                  };
                return r.next = r
              }
            }
            return {
              next: d
            }
          }

          function d() {
            return {
              value: h,
              done: !0
            }
          }
          var h, v = Object.prototype,
            g = v.hasOwnProperty,
            _ = "function" == typeof Symbol ? Symbol : {},
            y = _.iterator || "@@iterator",
            m = _.asyncIterator || "@@asyncIterator",
            b = _.toStringTag || "@@toStringTag",
            x = "object" == (void 0 === R ? "undefined" : _typeof(R)),
            k = t.regeneratorRuntime;
          if (k) x && (R.exports = k);
          else {
            (k = t.regeneratorRuntime = x ? R.exports : {}).wrap = i;
            var w = "suspendedStart",
              S = "suspendedYield",
              E = "executing",
              I = "completed",
              T = {},
              P = {};
            P[y] = function() {
              return this
            };
            var O = Object.getPrototypeOf,
              j = O && O(O(p([])));
            j && j !== v && g.call(j, y) && (P = j);
            var C = e.prototype = c.prototype = Object.create(P);
            n.prototype = C.constructor = e, e.constructor = n, e[b] = n.displayName = "GeneratorFunction", k.isGeneratorFunction = function(t) {
              var e = "function" == typeof t && t.constructor;
              return !!e && (e === n || "GeneratorFunction" === (e.displayName || e.name))
            }, k.mark = function(t) {
              return Object.setPrototypeOf ? Object.setPrototypeOf(t, e) : (t.__proto__ = e, b in t || (t[b] = "GeneratorFunction")), t.prototype = Object.create(C), t
            }, k.awrap = function(t) {
              return {
                __await: t
              }
            }, r(a.prototype), a.prototype[m] = function() {
              return this
            }, k.AsyncIterator = a, k.async = function(t, e, n, r) {
              var o = new a(i(t, e, n, r));
              return k.isGeneratorFunction(e) ? o : o.next().then(function(t) {
                return t.done ? t.value : o.next()
              })
            }, r(C), C[b] = "Generator", C[y] = function() {
              return this
            }, C.toString = function() {
              return "[object Generator]"
            }, k.keys = function(n) {
              var r = [];
              for (var t in n) r.push(t);
              return r.reverse(),
                function t() {
                  for (; r.length;) {
                    var e = r.pop();
                    if (e in n) return t.value = e, t.done = !1, t
                  }
                  return t.done = !0, t
                }
            }, k.values = p, f.prototype = {
              constructor: f,
              reset: function(t) {
                if (this.prev = 0, this.next = 0, this.sent = this._sent = h, this.done = !1, this.delegate = null, this.method = "next", this.arg = h, this.tryEntries.forEach(s), !t)
                  for (var e in this) "t" === e.charAt(0) && g.call(this, e) && !isNaN(+e.slice(1)) && (this[e] = h)
              },
              stop: function() {
                this.done = !0;
                var t = this.tryEntries[0].completion;
                if ("throw" === t.type) throw t.arg;
                return this.rval
              },
              dispatchException: function(n) {
                function t(t, e) {
                  return i.type = "throw", i.arg = n, r.next = t, e && (r.method = "next", r.arg = h), !!e
                }
                if (this.done) throw n;
                for (var r = this, e = this.tryEntries.length - 1; 0 <= e; --e) {
                  var o = this.tryEntries[e],
                    i = o.completion;
                  if ("root" === o.tryLoc) return t("end");
                  if (o.tryLoc <= this.prev) {
                    var a = g.call(o, "catchLoc"),
                      c = g.call(o, "finallyLoc");
                    if (a && c) {
                      if (this.prev < o.catchLoc) return t(o.catchLoc, !0);
                      if (this.prev < o.finallyLoc) return t(o.finallyLoc)
                    } else if (a) {
                      if (this.prev < o.catchLoc) return t(o.catchLoc, !0)
                    } else {
                      if (!c) throw new Error("try statement without catch or finally");
                      if (this.prev < o.finallyLoc) return t(o.finallyLoc)
                    }
                  }
                }
              },
              abrupt: function(t, e) {
                for (var n = this.tryEntries.length - 1; 0 <= n; --n) {
                  var r = this.tryEntries[n];
                  if (r.tryLoc <= this.prev && g.call(r, "finallyLoc") && this.prev < r.finallyLoc) {
                    var o = r;
                    break
                  }
                }
                o && ("break" === t || "continue" === t) && o.tryLoc <= e && e <= o.finallyLoc && (o = null);
                var i = o ? o.completion : {};
                return i.type = t, i.arg = e, o ? (this.method = "next", this.next = o.finallyLoc, T) : this.complete(i)
              },
              complete: function(t, e) {
                if ("throw" === t.type) throw t.arg;
                return "break" === t.type || "continue" === t.type ? this.next = t.arg : "return" === t.type ? (this.rval = this.arg = t.arg, this.method = "return", this.next = "end") : "normal" === t.type && e && (this.next = e), T
              },
              finish: function(t) {
                for (var e = this.tryEntries.length - 1; 0 <= e; --e) {
                  var n = this.tryEntries[e];
                  if (n.finallyLoc === t) return this.complete(n.completion, n.afterLoc), s(n), T
                }
              },
              catch: function(t) {
                for (var e = this.tryEntries.length - 1; 0 <= e; --e) {
                  var n = this.tryEntries[e];
                  if (n.tryLoc === t) {
                    var r = n.completion;
                    if ("throw" === r.type) {
                      var o = r.arg;
                      s(n)
                    }
                    return o
                  }
                }
                throw new Error("illegal catch attempt")
              },
              delegateYield: function(t, e, n) {
                return this.delegate = {
                  iterator: p(t),
                  resultName: e,
                  nextLoc: n
                }, "next" === this.method && (this.arg = h), T
              }
            }
          }
        }("object" == (void 0 === t ? "undefined" : _typeof(t)) ? t : "object" == (void 0 === We ? "undefined" : _typeof(We)) ? We : "object" == ("undefined" == typeof self ? "undefined" : _typeof(self)) ? self : this)
      }).call(this, "undefined" != typeof global ? global : "undefined" != typeof self ? self : void 0 !== We ? We : {})
    }, {}]
  }, {}, [1]);
  
  // ============================================================
  // 섹션: SDK 내부 유틸리티 함수 및 상태 변수
  // D = sessionStorage 관리자 (Base64 인코딩/디코딩)
  // U = 필수 파라미터 검증 함수
  // c = URL 쿼리스트링 빌더
  // B = 인증 상태 조회 함수 (editorToken + userId)
  // z = 플러그인 파라미터 빌더
  // l,f,p,d,h,v,g,_,y,m = 이벤트 핸들러 콜백 (on() 메서드로 등록)
  // b = 명령 Promise 핸들러 (resolve/reject)
  // H = 에러 콜백, x = 전체 이벤트 콜백
  // k = DDP 실행 완료 콜백, w = 이미지 풀 콜백
  // S = 프리뷰 닫기 콜백, E = 폰트 목록 콜백
  // I = 모드 변경 콜백, T = 페이지 수 변경 콜백
  // P = 페이지 변경 콜백, O = 임포즈 열림 콜백
  // j = 인쇄 수량 변경 콜백, C = 커스텀 탭 선택 변경 콜백
  // R = 문서 리포트 콜백
  // s = KOI 토큰 갱신 리스너, M = 자동 저장 interval ID
  // W = 자동 저장 간격(분), N = 씬 정보 콜백
  // ============================================================
var D = function(t, e) {
      if (void 0 !== e) {
        "object" === (void 0 === e ? "undefined" : _typeof(e)) && (e = JSON.stringify(e));
        var n = We.btoa(encodeURIComponent(e));
        return "userId" === t && 64 < n.length && (n = n.slice(0, 64)), sessionStorage.setItem(t, n)
      }
      var r = sessionStorage.getItem(t);
      return r ? decodeURIComponent(We.atob(r)) : null
    },
    U = function(t, e) {
      t.map(function(t) {
        if (!e[t]) throw new Error(t + " is undefined.")
      })
    },
    c = function(n) {
      return "?" + Object.keys(n).reduce(function(t, e) {
        return t.push(e + "=" + encodeURIComponent("object" === _typeof(n[e]) ? JSON.stringify(n[e]) : n[e])), t
      }, []).join("&")
    },
    B = function() {
      var t = D("editorToken"),
        e = D("userId"),
        n = {};
      if (n.user = !("null" === e || "undefined" === e || !e), t) {
        var r = JSON.parse(t);
        n.token = r.token
      }
      return n
    },
    z = function(t, e) {
      var n = {
        companyCode: t
      };
      return e && e.constructor === Object && (n = _extends({}, e, n)), n
    },
    l = function(t) {
      return null
    },
    f = function(t) {
      return null
    },
    p = function(t) {
      return null
    },
    d = function(t) {
      return null
    },
    h = function(t) {
      return null
    },
    v = function(t) {
      return null
    },
    g = function(t) {
      return null
    },
    _ = function(t) {
      return null
    },
    y = function(t) {
      return null
    },
    m = function(t) {
      return null
    },
    b = {
      resolve: function(t) {
        return null
      },
      reject: function(t) {
        return null
      }
    },
    H = function(t) {
      return J({
        message: t,
        projectId: null,
        data: null,
        level: "error"
      }), null
    },
    x = function(t) {
      return null
    },
    k = function() {
      return null
    },
    w = function(t) {
      return null
    },
    S = function() {
      return null
    },
    E = function(t) {
      return null
    },
    I = function(t) {
      return null
    },
    T = function(t) {
      return null
    },
    P = function(t) {
      return null
    },
    O = function(t) {
      return null
    },
    j = function(t) {
      return null
    },
    C = function(t) {
      return null
    },
    R = function(t) {
      return null
    },
    s = function(t) {
      if (t.data && "string" == typeof t.data && t.data.match(/^{.*}$/g)) {
        var e = JSON.parse(t.data);
        "KOI-SDK" == e.target && "refreshToken" == e.action && en.setToken(e.info.token)
      }
    },
    M = null,
    W = null,
    N = null,
    tn = function(n, t) {
      return t ? n && "object" === (void 0 === n ? "undefined" : _typeof(n)) && 0 < Object.keys(n).length ? Object.values(n) : "" : n && "object" === (void 0 === n ? "undefined" : _typeof(n)) && 0 < Object.keys(n).length ? "?" + Object.keys(n).reduce(function(t, e) {
        return t + (e + "=") + n[e] + "&"
      }, "") : ""
    },
    
    // ============================================================
    // G = DDP 명령 블록 빌더
    // 역할: SDK의 고수준 명령을 에디터가 이해하는 DDP 블록으로 변환
    // 지원: hiddenItems, deletePages, setItems, setAttributes,
    //       clonePages, flipStickers, changeLayout, copyPageContent,
    //       newDocument, addPages, addItems, addExternalImages,
    //       addInternalImages, setTexts, setItemAttributes,
    //       setLayerFeatures, resizePages, imposePages,
    //       addPageGroup, clonePageGroup, changeGroupInfo,
    //       setPageAttribute, setPostLayer
    // ============================================================
G = function(t, e) {
      return console.log(t, e), {
        commands: t.reduce(function(t, e) {
          if (e.hiddenItems && e.hiddenItems.constructor === (new Array).constructor) {
            var n = !0,
              r = !1,
              o = void 0;
            try {
              for (var i, a = e.hiddenItems[Symbol.iterator](); !(n = (i = a.next()).done); n = !0) {
                var c = i.value,
                  s = {
                    action: "set-item-attribute",
                    target: {
                      object: "item"
                    }
                  };
                "name" === c.type ? s.target.name = c.target : "item" === c.type ? s.target.var_id = c.target : "layer" === c.type && (s.target.postlayer = c.target), c.pageIndex && (s.target.page_index = c.pageIndex), c.itemId && (s.target.item_id = c.itemId), "document" === c.scope && (s.target.object = "all-items"), s.data = {
                  hidden: void 0 === c.value || c.value
                }, t.push(s)
              }
            } catch (t) {
              r = !0, o = t
            } finally {
              try {
                !n && a.return && a.return()
              } finally {
                if (r) throw o
              }
            }
          }
          if (e.deletePages && e.deletePages.constructor === (new Array).constructor) {
            var u = !0,
              l = !1,
              f = void 0;
            try {
              for (var p, d = e.deletePages[Symbol.iterator](); !(u = (p = d.next()).done); u = !0) {
                var h = p.value,
                  v = {
                    action: "delete-page",
                    target: {
                      object: "page"
                    }
                  };
                "index" === h.target ? v.target.index = h.value : "cover" === h.target ? v.target.type = h.target : "subType" === h.target && (v.target.subType = h.value), v.data = {
                  store_to_pool: !0
                }, t.push(v)
              }
            } catch (t) {
              l = !0, f = t
            } finally {
              try {
                !u && d.return && d.return()
              } finally {
                if (l) throw f
              }
            }
          }
          if (e.setItems && e.setItems.constructor === (new Array).constructor) {
            var g = !0,
              _ = !1,
              y = void 0;
            try {
              for (var m, b = e.setItems[Symbol.iterator](); !(g = (m = b.next()).done); g = !0) {
                var x = m.value,
                  k = {};
                k.action = "cell" === x.type ? "set-cell-src" : "set-item-src", k.target = {
                  object: "item"
                }, x && x.target && "background" === x.target.type ? (k.target.type = x.target.type, k.data = {
                  src: x.data.src
                }) : (x.tid ? k.target.item_id = x.tid : (x.id && (k.target.var_id = x.id), x.name && (k.target.name = x.name)), k.data = {
                  src: x.src
                }, x.srcSize && (k.data.srcSize = x.srcSize), x.scaleType && (k.data.scaleType = x.scaleType), "center" === x.scaleType && x.srcSize && (k.data.size_mm = x.srcSize), x.nocache && (k.data.nocache = x.nocache)), t.push(k)
              }
            } catch (t) {
              _ = !0, y = t
            } finally {
              try {
                !g && b.return && b.return()
              } finally {
                if (_) throw y
              }
            }
          }
          if (e.setAttributes && e.setAttributes.constructor === (new Array).constructor) {
            var w = !0,
              S = !1,
              E = void 0;
            try {
              for (var I, T = e.setAttributes[Symbol.iterator](); !(w = (I = T.next()).done); w = !0) {
                var P = I.value;
                if ("page" === P.type) {
                  var O = {
                    action: "set-page-attribute"
                  };
                  O.target = {
                    object: "page",
                    index: P.target
                  }, O.data = P.data, t.push(O)
                }
                if ("layer" === P.type) {
                  var j = {};
                  j.target = {
                    object: "all-items",
                    type: P.target,
                    scope: P.scope || "document"
                  }, j.data = {}, "color" === P.data.attribute && ("textbox" === P.target ? (j.action = "set-text-style", j.data.fontColor = P.data.value) : "svgart" === P.target ? (j.action = "set-item-overlay-src", j.data.overlaySrc = "value://color/" + P.data.value) : (j.action = "set-item-src", j.data.src = "value://color/" + P.data.value + tn(P.data.cmyk))), "textbox" === P.target && "font" === P.data.attribute && P.data.font && (j.data.font = P.data.font), t.push(j)
                }
                if ("item" === P.type) {
                  var C = {};
                  C.target = {
                    object: "item",
                    var_id: P.data.id
                  }, P.data.pageIndex && (C.target.page_index = P.data.pageIndex), P.data.itemId && (C.target.item_id = P.data.itemId), C.data = {}, "color" === P.data.attribute && ("textbox" === P.target ? (C.action = "set-text-style", C.data.fontColor = P.data.value) : "svgart" === P.target ? (C.action = "set-item-overlay-src", C.data.overlaySrc = "value://color/" + P.data.value) : (C.action = "set-item-src", C.data.src = "value://color/" + P.data.value)), "textbox" === P.target && "font" === P.data.attribute && P.data.font && (C.data.font = P.data.font), t.push(C)
                }
              }
            } catch (t) {
              S = !0, E = t
            } finally {
              try {
                !w && T.return && T.return()
              } finally {
                if (S) throw E
              }
            }
          }
          if (e.clonePages && e.clonePages.constructor === (new Array).constructor) {
            var R = !0,
              M = !1,
              N = void 0;
            try {
              for (var F, L = e.clonePages[Symbol.iterator](); !(R = (F = L.next()).done); R = !0) {
                var A = F.value,
                  D = {
                    action: "clone-page"
                  };
                D.target = {
                  object: "page",
                  index: A.target
                }, D.data = {
                  position: A.value
                }, t.push(D)
              }
            } catch (t) {
              M = !0, N = t
            } finally {
              try {
                !R && L.return && L.return()
              } finally {
                if (M) throw N
              }
            }
          }
          if (e.flipStickers && e.flipStickers.constructor === (new Array).constructor) {
            var U = !0,
              B = !1,
              z = void 0;
            try {
              for (var H, W = e.flipStickers[Symbol.iterator](); !(U = (H = W.next()).done); U = !0) {
                var G = H.value,
                  q = {
                    action: "flip-sticker"
                  };
                q.target = {
                  object: "item",
                  var_id: G.target
                }, G.pageIndex && (q.target.page_index = G.pageIndex), G.itemId && (q.target.item_id = G.itemId), q.data = {
                  direction: G.value
                }, t.push(q)
              }
            } catch (t) {
              B = !0, z = t
            } finally {
              try {
                !U && W.return && W.return()
              } finally {
                if (B) throw z
              }
            }
          }
          if (e.changeLayout && e.changeLayout.constructor === (new Array).constructor) {
            var V = !0,
              J = !1,
              K = void 0;
            try {
              for (var Y, $ = e.changeLayout[Symbol.iterator](); !(V = (Y = $.next()).done); V = !0) {
                var X = Y.value,
                  Z = {
                    action: "change-layout",
                    target: {
                      object: "page",
                      position: "active-page"
                    }
                  };
                Z.data = {
                  templateUri: X.resourceUri,
                  indexInTemplate: X.targetIndex,
                  changeBackgroundIfAvailable: X.changeBackground || !1,
                  changeOverlay: !1 !== X.changeOverlay,
                  transferCellContent: !1 !== X.transferCellContent,
                  transferTextContent: !1 !== X.transferTextContent,
                  userItemTypesToPreserve: ["textbox"]
                }, en.updateTemplateCount(X.resourceUri || "null", "hit"), t.push(Z)
              }
            } catch (t) {
              J = !0, K = t
            } finally {
              try {
                !V && $.return && $.return()
              } finally {
                if (J) throw K
              }
            }
          }
          if (e.copyPageContent && e.copyPageContent.constructor === (new Array).constructor) {
            var Q = !0,
              tt = !1,
              et = void 0;
            try {
              for (var nt, rt = e.copyPageContent[Symbol.iterator](); !(Q = (nt = rt.next()).done); Q = !0) {
                var ot = nt.value,
                  it = {
                    action: "copy-page-content"
                  };
                it.target = {
                  object: "page",
                  index: ot.copyIndex
                }, it.data = {
                  position: ot.pasteIndex
                }, t.push(it)
              }
            } catch (t) {
              tt = !0, et = t
            } finally {
              try {
                !Q && rt.return && rt.return()
              } finally {
                if (tt) throw et
              }
            }
          }
          if (e.newDocument && (t = []).push({
              action: "new-document",
              target: "project"
            }), e.addPages && e.addPages.constructor === (new Array).constructor) {
            var at = !0,
              ct = !1,
              st = void 0;
            try {
              for (var ut, lt = e.addPages[Symbol.iterator](); !(at = (ut = lt.next()).done); at = !0) {
                var ft = ut.value,
                  pt = {
                    action: "add-page",
                    target: "document",
                    data: {}
                  };
                if (ft.width && ft.height && (pt.data.size_mm = {
                    width: ft.width,
                    height: ft.height
                  }), ft.count && (pt.data.count = ft.count), ft.template && (pt.data.templateUri = ft.template.resourceUri, pt.data.indexInTemplate = ft.template.targetIndex), ft.setBackground) {
                  var dt = ft.bgColor || "#ffffff";
                  pt.data.backgroundSrc = "value://color/" + dt, "transparent" === ft.bgColor && (pt.data.backgroundSrc = "value://color/transparent")
                }
                if (ft.cutMargin) {
                  pt.data.cutMargin_mm = {};
                  var ht = !0,
                    vt = !1,
                    gt = void 0;
                  try {
                    for (var _t, yt = Object.entries(ft.cutMargin)[Symbol.iterator](); !(ht = (_t = yt.next()).done); ht = !0) {
                      var mt = _slicedToArray(_t.value, 2),
                        bt = mt[0],
                        xt = mt[1];
                      pt.data.cutMargin_mm[bt] = xt
                    }
                  } catch (t) {
                    vt = !0, gt = t
                  } finally {
                    try {
                      !ht && yt.return && yt.return()
                    } finally {
                      if (vt) throw gt
                    }
                  }
                }
                t.push(pt)
              }
            } catch (t) {
              ct = !0, st = t
            } finally {
              try {
                !at && lt.return && lt.return()
              } finally {
                if (ct) throw st
              }
            }
          }
          if (e.addItems && e.addItems.constructor === (new Array).constructor) {
            var kt = !0,
              wt = !1,
              St = void 0;
            try {
              for (var Et, It = e.addItems[Symbol.iterator](); !(kt = (Et = It.next()).done); kt = !0) {
                var Tt = Et.value,
                  Pt = {};
                switch (Tt.type) {
                  case "picFrame":
                    Pt.action = "add-cell", Pt.target = {
                      object: "page",
                      index: Tt.pageIndex
                    }, Pt.data = {}, Tt.position && Tt.position.constructor === Object ? Pt.data.rect_mm = {
                      x: Tt.position.x,
                      y: Tt.position.y,
                      width: Tt.position.width,
                      height: Tt.position.height
                    } : Pt.data.rect_mm = "page-full", Tt.variable && (Pt.data.variable = Tt.variable), Tt.insertIndex && (Pt.data.insertIndex = Tt.insertIndex);
                    break;
                  case "sticker":
                    Pt.action = "add-sticker", Pt.target = {
                      object: "page",
                      index: Tt.pageIndex
                    }, Pt.data = {}, Tt.src && (Pt.data.src = "value://svg/base64," + Tt.src.split("base64,")[1]), Tt.externalSrc && (Pt.data.src = Tt.externalSrc), Tt.layer && (Pt.data.postLayer = Tt.layer), Tt.position && Tt.position.constructor === Object ? Pt.data.rect_mm = {
                      x: Tt.position.x,
                      y: Tt.position.y,
                      width: Tt.position.width,
                      height: Tt.position.height
                    } : Pt.data.rect_mm = "page-full", Tt.variable && (Pt.data.variable = Tt.variable), Tt.insertIndex && (Pt.data.insertIndex = Tt.insertIndex)
                }
                t.push(Pt)
              }
            } catch (t) {
              wt = !0, St = t
            } finally {
              try {
                !kt && It.return && It.return()
              } finally {
                if (wt) throw St
              }
            }
          }
          if (e.addExternalImages && e.addExternalImages.constructor === (new Array).constructor) {
            var Ot = !0,
              jt = !1,
              Ct = void 0;
            try {
              for (var Rt, Mt = e.addExternalImages[Symbol.iterator](); !(Ot = (Rt = Mt.next()).done); Ot = !0) {
                var Nt = Rt.value,
                  Ft = {
                    src_type: "url",
                    src: Nt.src,
                    src_format: Nt.format,
                    item_type: Nt.type
                  };
                Qe.post_to_editor("add-image", Ft)
              }
            } catch (t) {
              jt = !0, Ct = t
            } finally {
              try {
                !Ot && Mt.return && Mt.return()
              } finally {
                if (jt) throw Ct
              }
            }
          }
          if (e.addInternalImages && e.addInternalImages.constructor === (new Array).constructor) {
            var Lt = !0,
              At = !1,
              Dt = void 0;
            try {
              for (var Ut, Bt = e.addInternalImages[Symbol.iterator](); !(Lt = (Ut = Bt.next()).done); Lt = !0) {
                var zt = Ut.value;
                if (zt.multi) {
                  var Ht = {
                    empty_cell_only: zt.onlyEmptyFrame,
                    repeat: zt.repeat,
                    sort_type: "default",
                    srcs: zt.images.map(function(t) {
                      return {
                        src_key: t.key,
                        src_info: t.info
                      }
                    })
                  };
                  Qe.post_to_editor("set-cell-src-infos", Ht)
                } else {
                  var Wt = {
                    src_type: "src-info",
                    item_type: zt.type,
                    src_key: zt.key,
                    src_info: zt.info
                  };
                  zt.tid && (Wt.item_id = zt.tid), zt.rectInfo && (Wt.item_mm = zt.rectInfo), Qe.post_to_editor("add-image", Wt)
                }
              }
            } catch (t) {
              At = !0, Dt = t
            } finally {
              try {
                !Lt && Bt.return && Bt.return()
              } finally {
                if (At) throw Dt
              }
            }
          }
          if (e.setTexts && e.setTexts.constructor === (new Array).constructor) {
            var Gt = !0,
              qt = !1,
              Vt = void 0;
            try {
              for (var Jt, Kt = e.setTexts[Symbol.iterator](); !(Gt = (Jt = Kt.next()).done); Gt = !0) {
                var Yt = Jt.value,
                  $t = {
                    action: "set-text-style",
                    target: {
                      object: "item",
                      var_id: Yt.variableId
                    },
                    data: {}
                  };
                (Yt.pageIndex || 0 === Yt.pageIndex) && ($t.target.page_index = Yt.pageIndex), 1 == Yt.shrink && ($t.data.shrink = Yt.shrink), Yt.font && (Yt.font.family && Yt.font.style && ($t.data.font = {
                  fontFamily: Yt.font.family,
                  typeStyle: Yt.font.style
                }), Yt.font.size && ($t.data.fontSize = Yt.font.size), Yt.font.align && ($t.data.align = Yt.font.align), Yt.font.color && ($t.data.fontColor = Yt.font.color, Yt.font.cmyk && ($t.data.fontColorCMYK = tn(Yt.font.cmyk, !0)))), (Yt.value || "" === Yt.value) && ($t.data.text = Yt.value), t.push($t)
              }
            } catch (t) {
              qt = !0, Vt = t
            } finally {
              try {
                !Gt && Kt.return && Kt.return()
              } finally {
                if (qt) throw Vt
              }
            }
          }
          if (e.setItemAttributes && e.setItemAttributes.constructor === (new Array).constructor) {
            var Xt = !0,
              Zt = !1,
              Qt = void 0;
            try {
              for (var te, ee = e.setItemAttributes[Symbol.iterator](); !(Xt = (te = ee.next()).done); Xt = !0) {
                var ne = te.value,
                  re = {
                    action: "set-item-attribute",
                    target: {
                      object: "item"
                    },
                    data: {}
                  };
                ne.variableId && (re.target.var_id = ne.variableId), ne.itemId && (re.target.item_id = ne.itemId), re.data[ne.type] = ne.value, ne.scope && (re.target.scope = ne.scope), ne.target && (re.target.type = ne.target), ne.data && (re.data = ne.data), ne.allItem && (re.target.object = "all-items"), t.push(re)
              }
            } catch (t) {
              Zt = !0, Qt = t
            } finally {
              try {
                !Xt && ee.return && ee.return()
              } finally {
                if (Zt) throw Qt
              }
            }
          }
          if (e.setLayerFeatures && e.setLayerFeatures.constructor === (new Array).constructor) {
            var oe = !0,
              ie = !1,
              ae = void 0;
            try {
              for (var ce, se = e.setLayerFeatures[Symbol.iterator](); !(oe = (ce = se.next()).done); oe = !0) {
                var ue = ce.value,
                  le = {
                    action: "set-item-layer-filter",
                    target: {
                      object: "item",
                      postlayer: ue.target
                    },
                    data: _defineProperty({}, "" + ue.feature, ue.value ? "true" : "false")
                  };
                "document" === ue.scope && "object" == _typeof(le.target) && (le.target.object = "all-items"), t.push(le)
              }
            } catch (t) {
              ie = !0, ae = t
            } finally {
              try {
                !oe && se.return && se.return()
              } finally {
                if (ie) throw ae
              }
            }
          }
          if (e.resizePages && e.resizePages.constructor === (new Array).constructor) {
            var fe = !0,
              pe = !1,
              de = void 0;
            try {
              for (var he, ve = e.resizePages[Symbol.iterator](); !(fe = (he = ve.next()).done); fe = !0) {
                var ge = he.value,
                  _e = {
                    action: "resize-page",
                    target: {
                      object: "page",
                      index: ge.pageIndex
                    },
                    data: {
                      size_mm: {
                        width: ge.width,
                        height: ge.height
                      },
                      imposing_rect_mm: ge.imposing_rect_mm,
                      userData: ge.userData
                    }
                  };
                t.push(_e)
              }
            } catch (t) {
              pe = !0, de = t
            } finally {
              try {
                !fe && ve.return && ve.return()
              } finally {
                if (pe) throw de
              }
            }
          }
          if (e.imposePages && e.imposePages.constructor === (new Array).constructor) {
            var ye = !0,
              me = !1,
              be = void 0;
            try {
              for (var xe, ke = e.imposePages[Symbol.iterator](); !(ye = (xe = ke.next()).done); ye = !0) {
                var we = xe.value,
                  Se = {
                    action: "impose-pages",
                    target: {
                      object: "document"
                    },
                    data: {
                      type: "bin-packing",
                      info: {
                        methods: we.methods,
                        srcPages: we.srcPages,
                        paperSize_mm: we.paperSize,
                        imposeRect_mm: we.imposeRect,
                        baseTemplateUri: we.baseTemplateUri,
                        rotatable: we.rotatable,
                        border: we.border,
                        sort: we.sort,
                        preserve_page_group: we.preservePageGroup || !1
                      }
                    }
                  };
                t.push(Se)
              }
            } catch (t) {
              me = !0, be = t
            } finally {
              try {
                !ye && ke.return && ke.return()
              } finally {
                if (me) throw be
              }
            }
          }
          if (e.addPageGroup && e.addPageGroup.constructor === (new Array).constructor) {
            var Ee = !0,
              Ie = !1,
              Te = void 0;
            try {
              for (var Pe, Oe = e.addPageGroup[Symbol.iterator](); !(Ee = (Pe = Oe.next()).done); Ee = !0) {
                var je = Pe.value,
                  Ce = {
                    action: "add-page-group",
                    target: "document",
                    data: {
                      pages: je.pages,
                      printCount: je.printCount
                    }
                  };
                t.push(Ce)
              }
            } catch (t) {
              Ie = !0, Te = t
            } finally {
              try {
                !Ee && Oe.return && Oe.return()
              } finally {
                if (Ie) throw Te
              }
            }
          }
          if (e.clonePageGroup && e.clonePageGroup.constructor === (new Array).constructor) {
            var Re = !0,
              Me = !1,
              Ne = void 0;
            try {
              for (var Fe, Le = e.clonePageGroup[Symbol.iterator](); !(Re = (Fe = Le.next()).done); Re = !0) {
                var Ae = {
                  action: "clone-page-group",
                  target: {
                    object: "group",
                    position: "active-group"
                  },
                  data: {
                    position: "after-last-group",
                    clearCell: Fe.value.clearCell
                  }
                };
                t.push(Ae)
              }
            } catch (t) {
              Me = !0, Ne = t
            } finally {
              try {
                !Re && Le.return && Le.return()
              } finally {
                if (Me) throw Ne
              }
            }
          }
          if (e.changeGroupInfo && e.changeGroupInfo.constructor === (new Array).constructor) {
            var De = !0,
              Ue = !1,
              Be = void 0;
            try {
              for (var ze, He = e.changeGroupInfo[Symbol.iterator](); !(De = (ze = He.next()).done); De = !0) {
                var We = ze.value,
                  Ge = {
                    action: "change-page-group-info",
                    target: {
                      object: "group",
                      index: We.index
                    },
                    data: We.data
                  };
                t.push(Ge)
              }
            } catch (t) {
              Ue = !0, Be = t
            } finally {
              try {
                !De && He.return && He.return()
              } finally {
                if (Ue) throw Be
              }
            }
          }
          if (e.setPageAttribute) {
            var qe = !0,
              Ve = !1,
              Je = void 0;
            try {
              for (var Ke, Ye = e.setPageAttribute[Symbol.iterator](); !(qe = (Ke = Ye.next()).done); qe = !0) {
                var $e = Ke.value,
                  Xe = {
                    action: "set-page-attribute",
                    target: {
                      object: "page",
                      index: $e.index
                    },
                    data: {
                      selectedKey: $e.selectKey
                    }
                  };
                t.push(Xe)
              }
            } catch (t) {
              Ve = !0, Je = t
            } finally {
              try {
                !qe && Ye.return && Ye.return()
              } finally {
                if (Ve) throw Je
              }
            }
          }
          if (e.setPostLayer) {
            var Ze = {
              action: "set-item-attribute",
              target: {
                object: "item",
                name: "postlayer"
              },
              data: {
                postLayer: e.setPostLayer
              }
            };
            t.push(Ze)
          }
          return t
        }, e || [])
      }
    },
    
    // F = VDP 카탈로그 데이터, u = KOI 컨테이너, L = KOI iframe
    // en = API 클라이언트 인스턴스, q = KOI 패시브 메시지 리스너
    // V = Sentry Hub, J = Sentry 로거, K = SDK 상태 객체
    // Y = 커스텀 탭 원본 데이터, $ = 품절 조합 목록
F = null,
    u = void 0,
    L = void 0,
    en = null,
    q = function(t) {
      if (t.data && "string" == typeof t.data && t.data.match(/^{.*}$/g)) {
        var e = JSON.parse(t.data);
        if (e && "From-KOI-Passive" === e.target) switch (e.type) {
          case "load":
            A = !1, D("projectId", e.info.info.project_id), f(e.info);
            break;
          case "save":
            h(e.info);
            break;
          case "error":
            H(e.info);
            break;
          case "close":
            d(e.info)
        }
      }
    },
    V = null,
    J = function(t) {
      var e = t.message,
        n = t.projectId,
        r = t.data,
        o = t.level,
        i = void 0 === o ? "info" : o;
      try {
        V.withScope(function(t) {
          t.setUser({
            id: D("userId"),
            username: D("userId")
          }), t.setTag("projectId", n), t.setTag("editorBaseURL", Qe.base_url), K.clone && (t.setTag("originProjectId", K.originProjectId), r.clone = !0, r.originProjectId = K.originProjectId), t.setExtras(r), t.addEventProcessor(function(t) {
            return t.request = _extends({
              headers: {
                "User-Agent": navigator.userAgent
              },
              url: location.href
            }, t.request), t
          }), V.captureMessage(e, i)
        })
      } catch (t) {
        console.log(t)
      }
    },
    K = {},
    Y = {},
    $ = [],
    
    // ============================================================
    // 섹션: RedEditorSDK 메인 클래스 (t)
    // 버전: 6.6.48
    // 메서드 수: 45개 프로토타입 메서드
    // 분류: 템플릿(5) + 프로젝트(7) + 에디터UI(5) + VDP(3) +
    //       라이프사이클(5) + 인증(5) + 이벤트(2) + 조회(9) + 주문(1) + 데이터(2) + 기타(1)
    // ============================================================
t = function() {
      function o(t) {
        _classCallCheck(this, o);
        var n = this;
        n.version = "6.6.48", n.isDev = !1, K.fromKOIPassive = t.fromKOIPassive, K.mode = "standard", K.deviceTarget = "pc";
        try {
          U(["accessToken"], t)
        } catch (t) {
          H && H.constructor === Function && (t.code = "002", H(t)), console.error(t)
        } finally {
          var e = "local" === t.sandboxMode ? "local" : t.sandboxMode ? "dev" : "product";
          if (en = new a(t.accessToken, e), t.inheritToken || (en.verifyToken(), en.autoRefreshToken(function(t, e) {
              if (L) {
                var n = {
                  target: "KOI-SDK",
                  action: "refreshToken",
                  info: {
                    token: e.token
                  }
                };
                L.contentWindow.postMessage(JSON.stringify(n), "*")
              }
            })), n.isDev = t.sandboxMode, Qe.init(n.isDev, t.initialStageUrl), We.addEventListener("message", s, !1), t.userId) D("userId", t.userId), en.call("issueUserToken").then(function(t) {
            t.division && D("division", t.division), t.lang && D("lang", t.lang), t.companyCode && D("companyCode", t.companyCode);
            var e = {
              token: t.token,
              expiredAt: (new Date).getTime()
            };
            D("editorToken", e), n.isReady = !0
          }).catch(function(t) {
            H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
          });
          else try {
            var r = D("userId");
            "bnVsbA==" === r || "dW5kZWZpbmVk" === r ? en.call("issueUserToken").then(function(t) {
              t.division && D("division", t.division), t.lang && D("lang", t.lang), t.companyCode && D("companyCode", t.companyCode);
              var e = {
                token: t.token,
                expiredAt: (new Date).getTime()
              };
              D("editorToken", e), n.isReady = !0
            }).catch(function(t) {
              H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
            }) : n.isReady = !1
          } catch (t) {
            console.error(t), n.isReady = !1
          }
          t.email && D("email", t.email), t.staffCode && D("staffCode", t.staffCode),
            function() {
              var t = new i.BrowserClient({
                dsn: "https://d574a33afd6c41cfb5f1afddc2110603@logging.betterwaysystems.com/1",
                integrations: [].concat(_toConsumableArray(i.defaultIntegrations)),
                normalizeDepth: 8,
                release: "v6.6.48"
              });
              new i.Hub(t).run(function(t) {
                V = t
              })
            }()
        }
      }
      return _createClass(o, [{
        
        /**
         * 현재 사용할 디자인 템플릿을 설정한다.
         * sessionStorage에 currentTemplate 키로 저장된다.
         * @param {Object} t - 템플릿 설정 객체 (ID, 이름, 타입 포함)
         */
        key: "setCurrentTemplate",
        value: function(t) {
          D("currentTemplate", t)
        }
      }, {
        
        /**
         * 현재 설정된 디자인 템플릿 정보를 반환한다.
         * @returns {Object} 현재 템플릿 설정 객체 (미설정 시 빈 객체)
         */
        key: "getCurrentTemplate",
        value: function() {
          return JSON.parse(D("currentTemplate") || "{}")
        }
      }, {
        
        // ---- 프로젝트 관리 메서드 (7개) ----
        /**
         * 새 프로젝트를 생성하고 에디터를 연다.
         * 상품 코드, 템플릿 URL, 제목 기반으로 에디터 iframe 생성.
         * 최대 4회 재시도. 옵션: 캘린더, 커스텀 탭, 팔레트, 페이지 조작 등.
         * @param {Object} e - 에디터 설정 (selector, psCode, title 필수)
         * @param {Object} n - 프로젝트 옵션 (다양한 에디터 설정)
         * @param {number} L - 재시도 횟수 (내부용, 기본 0)
         */
        key: "createProject",
        value: function(e, n) {
          var r, o, i, a, c, s, u, l, f, p, d, h, v, g, _, y, m, b, x, k, w, S, E, I, T, P, O, j, C, R, M, N, F, L = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : 0;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (A) return t.abrupt("return", !1);
                t.next = 2;
                break;
              case 2:
                if (A = !0, r = this, K.openType = "CREATE", K.clone = !1, K.originProjectId = null, K.params = JSON.parse(JSON.stringify({
                    editorConfig: e,
                    options: n
                  })), We.__KOI_EVENT_LISNTER_INITIALIZE || Qe.init(r.isDev), this.isReady) {
                  t.next = 16;
                  break
                }
                if (L < 4) return setTimeout(function() {
                  A = !1, r.createProject(e, n, L + 1)
                }, 500), t.abrupt("return", !1);
                t.next = 15;
                break;
              case 15:
                return t.abrupt("return", alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId."));
              case 16:
                t.prev = 16, U(["selector", "psCode", "title"], e), t.next = 23;
                break;
              case 20:
                t.prev = 20, t.t0 = t.catch(16), H && H.constructor === Function && (t.t0.code = "001", H(t.t0));
              case 23:
                if (t.prev = 23, e.psCode && e.psCode.split("@")[1] && ["PHBKPRM"].includes(e.psCode.split("@")[1]) && ((n = n || {}).deletePages = [{
                    target: "cover"
                  }]), e.locale && ((n = n || {}).locale = e.locale), !n) {
                  t.next = 102;
                  break
                }
                if (n.initPageCount && (e.initPageCount = n.initPageCount), n.maxPage && (e.maxPage = n.maxPage), n.minPage && (e.minPage = n.minPage), n.maxOrder && (e.maxOrder = n.maxOrder), n.testPlugin && (e.testPlugin = !0), n.bundlePageUnit && (e.bundlePageUnit = n.bundlePageUnit), n.calendarConfig && "object" === _typeof(n.calendarConfig) && (o = new Date, i = n.calendarConfig, a = i.initialYear, c = i.initialMonth, s = i.range, u = i.prefixMonths, l = i.afterMonths, a = a || o.getFullYear(), c = c || o.getMonth() + 1, s = s || 12, u = u || 0, l = l || 0, e.calendarDate = a + "-" + c + "-" + s + "-" + u + "-" + l), n.emptyDocument && (e.ddpBlock ? e.ddpBlock = G([{
                    newDocument: !0
                  }], e.ddpBlock.commands) : e.ddpBlock = G([{
                    newDocument: !0
                  }]), e.templateUrl = null), n.addPages && (e.ddpBlock ? e.ddpBlock = G([{
                    addPages: n.addPages
                  }], e.ddpBlock.commands) : e.ddpBlock = G([{
                    addPages: n.addPages
                  }])), n.customDocument && (n.executeList ? n.executeList = [{
                    newDocument: !0
                  }, {
                    addPages: n.customDocument.pages.map(function(t) {
                      return t.setBackground = !0, t
                    })
                  }].concat(_toConsumableArray(n.executeList)) : (f = [{
                    newDocument: !0
                  }, {
                    addPages: n.customDocument.pages.map(function(t) {
                      return t.setBackground = !0, t
                    })
                  }], e.ddpBlock = G(f)), e.templateUrl = null), n.executeList && (e.ddpBlock = G(n.executeList)), n.deletePages && (e.ddpBlock ? e.ddpBlock = G([{
                    deletePages: n.deletePages
                  }], e.ddpBlock.commands) : e.ddpBlock = G([{
                    deletePages: n.deletePages
                  }])), n.hiddenItems && (e.ddpBlock ? e.ddpBlock = G([{
                    hiddenItems: n.hiddenItems
                  }], e.ddpBlock.commands) : e.ddpBlock = G([{
                    hiddenItems: n.hiddenItems
                  }])), n.autoSave && "number" == typeof n.autoSave && (W = n.autoSave), n.extra && (e.extra = n.extra), n.locale && (e.locale = n.locale), n.isMobile && (e.isMobile = n.isMobile, K.deviceTarget = "mobile"), n.hideToolbar && (e.hideToolbar = n.hideToolbar, K.mode = "passive"), n.showSetting && (e.showSetting = n.showSetting), n.useVideoFrame && (e.useVideoFrame = n.useVideoFrame), !n.limitColor && !n.paletteCode) {
                  t.next = 71;
                  break
                }
                if (!e.extra) {
                  t.next = 60;
                  break
                }
                if (n.limitColor && (e.extra.palette = {
                    max_color: parseInt(n.limitColor)
                  }), !n.paletteCode) {
                  t.next = 58;
                  break
                }
                t.t1 = _typeof(n.paletteCode), t.next = "string" === t.t1 ? 54 : "object" === t.t1 ? 56 : 58;
                break;
              case 54:
                return e.extra.palette = {
                  palCode: n.paletteCode
                }, t.abrupt("break", 58);
              case 56:
                return e.extra.palette = {
                  palCode: n.paletteCode.palCode,
                  palNameFilters: n.paletteCode.filters,
                  foilNameFilters: n.paletteCode.filters,
                  foilNameMajor: n.paletteCode.default,
                  palNameMajor: n.paletteCode.default
                }, t.abrupt("break", 58);
              case 58:
                t.next = 71;
                break;
              case 60:
                if (e.extra = {}, e.extra.palette = {}, n.limitColor && (e.extra.palette.max_color = parseInt(n.limitColor)), !n.paletteCode) {
                  t.next = 71;
                  break
                }
                t.t2 = _typeof(n.paletteCode), t.next = "string" === t.t2 ? 67 : "object" === t.t2 ? 69 : 71;
                break;
              case 67:
                return e.extra.palette = {
                  palCode: n.paletteCode
                }, t.abrupt("break", 71);
              case 69:
                return e.extra.palette = {
                  palCode: n.paletteCode.palCode,
                  palNameFilters: n.paletteCode.filters,
                  foilNameFilters: n.paletteCode.filters,
                  foilNameMajor: n.paletteCode.default,
                  palNameMajor: n.paletteCode.default
                }, t.abrupt("break", 71);
              case 71:
                if (!0 !== n.setTransparentBackground && !1 !== n.setTransparentBackground || (e.extra || (e.extra = {}), e.extra.background || (e.extra.background = {}), e.extra.background.set_transparent = n.setTransparentBackground), !0 !== n.activeTransparentBackground && !1 !== n.activeTransparentBackground || (e.extra || (e.extra = {}), e.extra.background || (e.extra.background = {}), e.extra.background.can_transparent = n.activeTransparentBackground), n.customTabInfo) return e.extra || (e.extra = {}), p = n.customTabInfo, d = p.productCode, h = p.data, v = p.initValues, g = p.options, t.next = 78, regeneratorRuntime.awrap(this.getProductInfo(d));
                t.next = 94;
                break;
              case 78:
                return _ = t.sent, t.next = 81, regeneratorRuntime.awrap(this.getTemplateList(d));
              case 81:
                return y = t.sent.list, m = {
                  productCode: d,
                  product: _,
                  templateList: y,
                  isDev: this.isDev,
                  locale: n.locale || "ko"
                }, b = new X(m), Y = h, t.next = 87, regeneratorRuntime.awrap(b.getCustomTabFormat(h, v, g));
              case 87:
                x = t.sent, $ = x.noStocks, x.varMap && (!e.templateUrl && x.varMap.$TMPL && (e.templateUrl = x.varMap.$TMPL), !e.psCode && x.varMap.$PSCD && (e.psCode = x.varMap.$PSCD)), e.extra.custom_tab = x, (k = b.whetherUsePalette(v)) && (e.extra.palette = _.paletteInfo), console.log(">>>>>>>>>>>>>", {
                  usePalette: k
                }, {
                  editorConfig: e
                }, _);
              case 94:
                n.useTabless && (e.uiStyle = "tab-less,header-less"), n.hideCustomTab && (e.uiStyle = "tab-less,hide-custom"), n.setSpine && (e.extra || (e.extra = {}), e.extra.override || (e.extra.override = {}), e.extra.override.spine_mm = n.setSpine), n.documentSizeInfo && (e.extra || (e.extra = {}), w = n.documentSizeInfo, S = w.width, E = w.height, I = w.round, e.extra.sizing = {
                  width_mm: S,
                  height_mm: E
                }, I && (e.extra.sizing.round_mm = I)), n.setDefaultSelectKey && (e.ddpBlock ? e.ddpBlock = G([{
                  setPageAttribute: n.setDefaultSelectKey
                }], e.ddpBlock.commands) : e.ddpBlock = G([{
                  setPageAttribute: n.setDefaultSelectKey
                }])), n.minItemSize && (e.extra || (e.extra = {}), e.extra.override || (e.extra.override = {}), e.extra.override.min_item_mm = n.minItemSize), n.tabControl && (e.extra || (e.extra = {}), e.extra.override || (e.extra.override = {}), T = Object.keys(n.tabControl).map(function(t) {
                  return {
                    type: t,
                    value: n.tabControl[t]
                  }
                }), e.extra.override.sizeOption = {
                  tabControls: T
                }), n.changeLayer && (e.ddpBlock ? e.ddpBlock = G([{
                  setPostLayer: n.changeLayer
                }], e.ddpBlock.commands) : e.ddpBlock = G([{
                  setPostLayer: n.changeLayer
                }]));
              case 102:
                if (P = {
                    parent_element: document.querySelector(e.selector),
                    ps_code: e.psCode,
                    template_uri: e.templateUrl,
                    title: e.title,
                    run_mode: e.hideToolbar ? "passive" : "standard",
                    edit_mode: e.showSetting ? "design" : "standard",
                    ddp_block: e.ddpBlock || "",
                    private_css: e.privateCSS || "",
                    num_page: e.initPageCount,
                    max_page: e.maxPage,
                    min_page: e.minPage,
                    max_order: e.maxOrder,
                    force_plugin: e.testPlugin,
                    partner: "redp",
                    mobile: e.isMobile,
                    unit_page: e.bundlePageUnit,
                    ui_locale: e.locale,
                    cal_date: e.calendarDate,
                    options: e.extra,
                    clear_src: e.clearSource,
                    video_frames: e.useVideoFrame,
                    ui_style: e.uiStyle
                  }, n && n.unableLayers && (n.unableLayers.constructor === String().constructor ? P.unlayers = n.unableLayers : n.unableLayers.constructor === Array().constructor && 0 < n.unableLayers.length && (P.unlayers = n.unableLayers.join(","))), n && n.resourceParams && (P.resapi_param = n.resourceParams), n && n.lockGroupPageCount && (P.no_edit_group = n.lockGroupPageCount, P.edit_lock = "edit-group"), n && n.disableMasterColorPicker && (P.no_edit_group = n.lockGroupPageCount, P.edit_lock = P.edit_lock ? P.edit_lock + ",set-strict-color" : "set-strict-color"), n && n.disableFontPreview && (P.edit_lock = P.edit_lock ? P.edit_lock + ",no-font-preview" : "no-font-preview"), n && n.disableSelection && (P.edit_lock = P.edit_lock ? P.edit_lock + ",no-selection" : "no-selection"), n && n.disableTapeOptions && (P.edit_lock = P.edit_lock ? P.edit_lock + ",tape-option" : "tape-option"), n && n.disableAllOption && (P.edit_lock = "lock-all, edit-custom-tab"), n && n.clearSource && (P.clear_src = n.clearSource), n && n.privateCSS) return t.next = 115, regeneratorRuntime.awrap(this.getCustomCss(n.privateCSS));
                t.next = 116;
                break;
              case 115:
                P.private_css = t.sent;
              case 116:
                if (n && n.preview && (P.option_string = "file_3d=" + n.preview), n && n.pantone && (O = n.pantone, j = O.name, C = O.dpName, R = O.hex, M = O.rgb, P.option_string = "single_strict_palette=name:" + j + ";dpName:" + C + ";hex:" + R + ";rgb:" + M + ";"), (N = B()).user) {
                  t.next = 121;
                  break
                }
                return t.abrupt("return", !1);
              case 121:
                return D("edicusConfig", e), D("targetElement", e.selector), F = r.editorEventHandler, e.promotionInfo && (P.options || (P.options = {}), e.promotionInfo.useExternal ? P.options.promo = {
                  type: "external"
                } : P.options.promo = {
                  preferredWidth: e.promotionInfo.width,
                  preferredHeight: e.promotionInfo.height,
                  url: e.promotionInfo.url,
                  opened: e.promotionInfo.autoShow
                }), N.token ? (P.token = N.token, P.div = D("division"), P.lang = D("lang"), P.plugin_param = JSON.stringify(z(D("companyCode"), n && n.pluginCustomData)), n && n.locale && (P.lang = n.locale), Qe.create_project(P, F), en.updateTemplateCount(P.template_uri || "null", "hit")) : en.call("issueUserToken").then(function(t) {
                  P.token = t.token, t.division && (D("division", t.division), P.div = t.division), t.lang && (D("lang", t.lang), P.lang = t.lang, n && n.locale && (P.lang = n.locale)), t.companyCode && (D("companyCode", t.companyCode), P.plugin_param = JSON.stringify(z(t.companyCode, n && n.pluginCustomData))), Qe.create_project(P, F);
                  var e = {
                    token: t.token,
                    expiredAt: (new Date).getTime()
                  };
                  D("editorToken", e), en.updateTemplateCount(P.template_uri, "hit")
                }).catch(function(t) {
                  H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
                }), t.finish(23);
              case 127:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [16, 20, 23, 127]
          ])
        }
      }, {
        
        /**
         * 기존 프로젝트를 열어 에디터를 실행한다.
         * clone 옵션으로 프로젝트 복제 후 열기 가능.
         * @param {Object} o - 에디터 설정 (selector, projectId 필수)
         * @param {Object} i - 프로젝트 옵션
         * @param {number} k - 재시도 횟수 (내부용, 기본 0)
         */
        key: "openProject",
        value: function(o, i) {
          var a, e, n, r, c, s, u, l, f, p, d, h, v, g, _, y, m, b, x, k = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : 0;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (A) return t.abrupt("return", !1);
                t.next = 2;
                break;
              case 2:
                if (A = !0, a = this, K.openType = "OPEN", K.params = JSON.parse(JSON.stringify({
                    editorConfig: o,
                    options: i
                  })), We.__KOI_EVENT_LISNTER_INITIALIZE || Qe.init(a.isDev), this.isReady) {
                  t.next = 14;
                  break
                }
                if (k < 4) return setTimeout(function() {
                  A = !1, a.openProject(o, i, k + 1)
                }, 500), t.abrupt("return", !1);
                t.next = 13;
                break;
              case 13:
                return t.abrupt("return", alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId."));
              case 14:
                t.prev = 14, U(["selector", "projectId"], o), t.next = 21;
                break;
              case 18:
                t.prev = 18, t.t0 = t.catch(14), H && H.constructor === Function && (t.t0.code = "001", H(t.t0));
              case 21:
                if (t.prev = 21, o.locale && ((i = i || {}).locale = o.locale), !i) {
                  t.next = 95;
                  break
                }
                if (i.initPageCount && (o.initPageCount = i.initPageCount), i.maxPage && (o.maxPage = i.maxPage), i.minPage && (o.minPage = i.minPage), i.maxOrder && (o.maxOrder = i.maxOrder), i.testPlugin && (o.force_plugin = !0), i.executeList && (o.ddpBlock = G(i.executeList)), i.autoSave && "number" == typeof i.autoSave && (W = i.autoSave), i.extra && (o.extra = i.extra), i.locale && (o.locale = i.locale), i.isMobile && (o.isMobile = i.isMobile, K.deviceTarget = "mobile"), i.hideToolbar && (o.hideToolbar = i.hideToolbar, K.mode = "passive"), i.showSetting && (o.showSetting = i.showSetting), i.clone && (o.clone = i.clone), i.useVideoFrame && (o.useVideoFrame = i.useVideoFrame), !i.limitColor && !i.paletteCode) {
                  t.next = 62;
                  break
                }
                if (!o.extra) {
                  t.next = 51;
                  break
                }
                if (i.limitColor && (o.extra.palette = {
                    max_color: parseInt(i.limitColor)
                  }), !i.paletteCode) {
                  t.next = 49;
                  break
                }
                t.t1 = _typeof(i.paletteCode), t.next = "string" === t.t1 ? 45 : "object" === t.t1 ? 47 : 49;
                break;
              case 45:
                return o.extra.palette = {
                  palCode: i.paletteCode
                }, t.abrupt("break", 49);
              case 47:
                return o.extra.palette = {
                  palCode: i.paletteCode.palCode,
                  palNameFilters: i.paletteCode.filters,
                  foilNameFilters: i.paletteCode.filters,
                  foilNameMajor: i.paletteCode.default
                }, t.abrupt("break", 49);
              case 49:
                t.next = 62;
                break;
              case 51:
                if (o.extra = {}, o.extra.palette = {}, i.limitColor && (o.extra.palette.max_color = parseInt(i.limitColor)), !i.paletteCode) {
                  t.next = 62;
                  break
                }
                t.t2 = _typeof(i.paletteCode), t.next = "string" === t.t2 ? 58 : "object" === t.t2 ? 60 : 62;
                break;
              case 58:
                return o.extra.palette = {
                  palCode: i.paletteCode
                }, t.abrupt("break", 62);
              case 60:
                return o.extra.palette = {
                  palCode: i.paletteCode.palCode,
                  palNameFilters: i.paletteCode.filters,
                  foilNameFilters: i.paletteCode.filters,
                  foilNameMajor: i.paletteCode.default
                }, t.abrupt("break", 62);
              case 62:
                if (!1 === i.setTransparentBackground && (o.extra || (o.extra = {}), o.extra.background || (o.extra.background = {}), o.extra.background.set_transparent = i.setTransparentBackground), !0 !== i.activeTransparentBackground && !1 !== i.activeTransparentBackground || (o.extra || (o.extra = {}), o.extra.background || (o.extra.background = {}), o.extra.background.can_transparent = i.activeTransparentBackground), i && i.privateCSS) return t.next = 67, regeneratorRuntime.awrap(this.getCustomCss(i.privateCSS));
                t.next = 68;
                break;
              case 67:
                o.privateCSS = t.sent;
              case 68:
                if (i.customTabInfo) return o.extra || (o.extra = {}), e = i.customTabInfo, n = e.productCode, r = e.data, c = e.initValues, s = e.options, u = void 0 === s ? {} : s, t.next = 73, regeneratorRuntime.awrap(this.getProductInfo(n));
                t.next = 87;
                break;
              case 73:
                return l = t.sent, t.next = 76, regeneratorRuntime.awrap(this.getTemplateList(n));
              case 76:
                return f = t.sent.list, p = {
                  productCode: n,
                  product: l,
                  templateList: f,
                  isDev: this.isDev,
                  locale: i.locale || "ko"
                }, d = new X(p), Y = r, u.skipInitVarMap = !0, t.next = 83, regeneratorRuntime.awrap(d.getCustomTabFormat(r, c, u));
              case 83:
                h = t.sent, o.extra.custom_tab = h, d.whetherUsePalette(c) && (o.extra.palette = l.paletteInfo);
              case 87:
                i.useTabless && (o.uiStyle = "tab-less,header-less"), i.hideCustomTab && (o.uiStyle = "tab-less,hide-custom"), i.setSpine && (o.extra || (o.extra = {}), o.extra.override || (o.extra.override = {}), o.extra.override.spine_mm = i.setSpine), i.documentSizeInfo && (o.extra || (o.extra = {}), v = i.documentSizeInfo, g = v.width, _ = v.height, y = v.round, o.extra.sizing = {
                  width_mm: g,
                  height_mm: _
                }, y && (o.extra.sizing.round_mm = y)), i.setDefaultSelectKey && (o.ddpBlock ? o.ddpBlock = G([{
                  setPageAttribute: i.setDefaultSelectKey
                }], o.ddpBlock.commands) : o.ddpBlock = G([{
                  setPageAttribute: i.setDefaultSelectKey
                }])), i.minItemSize && (o.extra || (o.extra = {}), o.extra.override || (o.extra.override = {}), o.extra.override.min_item_mm = i.minItemSize), i.tabControl && (o.extra || (o.extra = {}), o.extra.override || (o.extra.override = {}), m = Object.keys(i.tabControl).map(function(t) {
                  return {
                    type: t,
                    value: i.tabControl[t]
                  }
                }), o.extra.override.sizeOption = {
                  tabControls: m
                }), i.changeLayer && (o.ddpBlock ? o.ddpBlock = G([{
                  setPostLayer: i.changeLayer
                }], o.ddpBlock.commands) : o.ddpBlock = G([{
                  setPostLayer: i.changeLayer
                }]));
              case 95:
                return b = function(t) {
                  var n = {
                    parent_element: document.querySelector(o.selector),
                    prjid: t || o.projectId,
                    run_mode: o.hideToolbar ? "passive" : "standard",
                    edit_mode: o.showSetting ? "design" : "standard",
                    ddp_block: o.ddpBlock || "",
                    max_page: o.maxPage,
                    min_page: o.minPage,
                    max_order: o.maxOrder,
                    force_plugin: o.testPlugin,
                    resapi_param: o.resapiParam,
                    private_css: o.privateCSS || "",
                    partner: "redp",
                    mobile: o.isMobile,
                    ui_locale: o.locale,
                    options: o.extra,
                    video_frames: o.useVideoFrame,
                    ui_style: o.uiStyle
                  };
                  i && null !== i.unableLayers && void 0 !== i.unableLayers && (i.unableLayers.constructor === String().constructor ? n.unlayers = i.unableLayers : i.unableLayers.constructor === Array().constructor && (n.unlayers = i.unableLayers.join(","))), i && i.resourceParams && (n.resapi_param = o.resourceParams), i && i.lockGroupPageCount && (n.no_edit_group = i.lockGroupPageCount, n.edit_lock = "edit-group"), i && i.disableMasterColorPicker && (n.no_edit_group = i.lockGroupPageCount, n.edit_lock = n.edit_lock ? n.edit_lock + ",set-strict-color" : "set-strict-color"), i && i.disableFontPreview && (n.edit_lock = n.edit_lock ? n.edit_lock + ",no-font-preview" : "no-font-preview"), i && i.disableSelection && (n.edit_lock = n.edit_lock ? n.edit_lock + ",no-selection" : "no-selection"), i && i.disableTapeOptions && (n.edit_lock = n.edit_lock ? n.edit_lock + ",tape-option" : "tape-option"), i && i.disableAllOption && (n.edit_lock = "lock-all"), i && i.clearSource && (n.clear_src = i.clearSource), i && i.viewerMode && (n.no_update = i.viewerMode), D("projectId", o.projectId), D("edicusConfig", o), D("targetElement", o.selector);
                  var e = B();
                  if (!e.user) return !1;
                  var r = a.editorEventHandler;
                  o.promotionInfo && (n.options || (n.options = {}), o.promotionInfo.useExternal ? n.options.promo = {
                    type: "external"
                  } : n.options.promo = {
                    preferredWidth: o.promotionInfo.width,
                    preferredHeight: o.promotionInfo.height,
                    url: o.promotionInfo.url,
                    opened: o.promotionInfo.autoShow
                  }), e.token ? (n.token = e.token, n.div = D("division"), n.lang = D("lang"), n.plugin_param = JSON.stringify(z(D("companyCode"), i && i.pluginCustomData)), i && i.locale && (n.lang = i.locale), Qe.open_project(n, r)) : en.call("issueUserToken").then(function(t) {
                    n.token = t.token, t.division && (D("division", t.division), n.div = t.division), t.lang && (D("lang", t.lang), n.lang = t.lang, i && i.locale && (n.lang = i.locale)), t.companyCode && (D("companyCode", t.companyCode), n.plugin_param = JSON.stringify(z(t.companyCode, i && i.pluginCustomData)));
                    var e = {
                      token: t.token,
                      expiredAt: (new Date).getTime()
                    };
                    D("editorToken", e), Qe.open_project(n, r)
                  }).catch(function(t) {
                    H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
                  })
                }, !0 === o.clone ? (x = {}, i && i.projectOwnerId && (x.projectOwnerId = i.projectOwnerId, K.projectOwnerId = i.projectOwnerId), this.cloneProject(o.projectId, x).then(function(t) {
                  K.clone = !0, K.originProjectId = o.projectId, o.projectId = t, b(t)
                }).catch(function(t) {
                  H && H.constructor === Function && (t.code = "004", H(t)), console.error(t)
                })) : (K.clone = !1, K.originProjectId = null, b(o.projectId)), t.finish(21);
              case 98:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [14, 18, 21, 98]
          ])
        }
      }, {
        
        /**
         * 기존 프로젝트를 새 상품 코드로 리폼(재구성)한다.
         * 디자인은 유지하면서 상품 규격(psCode)을 변경.
         * @param {Object} o - 에디터 설정 (selector, projectId, psCode 필수)
         * @param {Object} i - 프로젝트 옵션
         * @param {number} n - 재시도 횟수 (내부용, 기본 0)
         */
        key: "reformProject",
        value: function(o, i) {
          var a, e, n = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : 0;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (a = this, K.openType = "REFORM", K.params = JSON.parse(JSON.stringify({
                    editorConfig: o,
                    options: i
                  })), We.__KOI_EVENT_LISNTER_INITIALIZE || Qe.init(a.isDev), this.isReady) {
                  t.next = 11;
                  break
                }
                if (n < 4) return setTimeout(function() {
                  a.reformProject(o, i, n + 1)
                }, 500), t.abrupt("return", !1);
                t.next = 10;
                break;
              case 10:
                return t.abrupt("return", alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId."));
              case 11:
                t.prev = 11, U(["selector", "projectId", "psCode"], o), t.next = 18;
                break;
              case 15:
                t.prev = 15, t.t0 = t.catch(11), H && H.constructor === Function && (t.t0.code = "001", H(t.t0));
              case 18:
                if (t.prev = 18, !i) {
                  t.next = 39;
                  break
                }
                if (i.initPageCount && (o.initPageCount = i.initPageCount), i.maxPage && (o.maxPage = i.maxPage), i.minPage && (o.minPage = i.minPage), i.maxOrder && (o.maxOrder = i.maxOrder), i.testPlugin && (o.force_plugin = !0), i.executeList && (o.ddpBlock = G(i.executeList)), i.autoSave && "number" == typeof i.autoSave && (W = i.autoSave), i.extra && (o.extra = i.extra), i.locale && (o.locale = i.locale), i.isMobile && (o.isMobile = i.isMobile, K.deviceTarget = "mobile"), i.hideToolbar && (o.hideToolbar = i.hideToolbar, K.mode = "passive"), i.showSetting && (o.showSetting = i.showSetting), i.clone && (o.clone = i.clone), i.useVideoFrame && (o.useVideoFrame = i.useVideoFrame), (i.limitColor || i.paletteCode) && (o.extra ? (i.limitColor && (o.extra.palette = {
                    max_color: parseInt(i.limitColor)
                  }), i.paletteCode && (o.extra.palette = {
                    palCode: i.paletteCode
                  })) : (o.extra = {}, o.extra.palette = {}, i.limitColor && (o.extra.palette.max_color = parseInt(i.limitColor)), i.paletteCode && (o.extra.palette.palCode = i.paletteCode))), i && i.privateCSS) return t.next = 38, regeneratorRuntime.awrap(this.getCustomCss(i.privateCSS));
                t.next = 39;
                break;
              case 38:
                o.privateCSS = t.sent;
              case 39:
                return e = function(t) {
                  var n = {
                    parent_element: document.querySelector(o.selector),
                    prjid: t || o.projectId,
                    ps_code: o.psCode,
                    run_mode: o.hideToolbar ? "passive" : "standard",
                    edit_mode: o.showSetting ? "design" : "standard",
                    ddp_block: o.ddpBlock || "",
                    max_page: o.maxPage,
                    min_page: o.minPage,
                    max_order: o.maxOrder,
                    force_plugin: o.testPlugin,
                    resapi_param: o.resapiParam,
                    private_css: o.privateCSS || "",
                    partner: "redp",
                    mobile: o.isMobile,
                    ui_locale: o.locale,
                    options: o.extra,
                    video_frames: o.useVideoFrame
                  };
                  i && null !== i.unableLayers && void 0 !== i.unableLayers && (i.unableLayers.constructor === String().constructor ? n.unlayers = i.unableLayers : i.unableLayers.constructor === Array().constructor && (n.unlayers = i.unableLayers.join(","))), i && i.resourceParams && (n.resapi_param = o.resourceParams), i && i.lockGroupPageCount && (n.no_edit_group = i.lockGroupPageCount, n.edit_lock = "edit-group"), i && i.disableMasterColorPicker && (n.no_edit_group = i.lockGroupPageCount, n.edit_lock = n.edit_lock ? n.edit_lock + ",set-strict-color" : "set-strict-color"), i && i.disableFontPreview && (n.edit_lock = n.edit_lock ? n.edit_lock + ",no-font-preview" : "no-font-preview"), i && i.disableSelection && (n.edit_lock = n.edit_lock ? n.edit_lock + ",no-selection" : "no-selection"), i && i.clearSource && (n.clear_src = i.clearSource), D("projectId", o.projectId), D("edicusConfig", o), D("targetElement", o.selector);
                  var e = B();
                  if (!e.user) return !1;
                  var r = a.editorEventHandler;
                  o.promotionInfo && (n.options || (n.options = {}), n.options.promo = {
                    preferredWidth: o.promotionInfo.width,
                    preferredHeight: o.promotionInfo.height,
                    url: o.promotionInfo.url,
                    opened: o.promotionInfo.autoShow
                  }), e.token ? (n.token = e.token, n.div = D("division"), n.lang = D("lang"), n.plugin_param = JSON.stringify(z(D("companyCode"), i && i.pluginCustomData)), Qe.reform_project(n, r)) : en.call("issueUserToken").then(function(t) {
                    n.token = t.token, t.division && (D("division", t.division), n.div = t.division), t.lang && (D("lang", t.lang), n.lang = t.lang), t.companyCode && (D("companyCode", t.companyCode), n.plugin_param = JSON.stringify(z(t.companyCode, i && i.pluginCustomData)));
                    var e = {
                      token: t.token,
                      expiredAt: (new Date).getTime()
                    };
                    D("editorToken", e), Qe.reform_project(n, r)
                  }).catch(function(t) {
                    H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
                  })
                }, !0 === o.clone ? this.cloneProject(o.projectId).then(function(t) {
                  K.clone = !0, K.originProjectId = o.projectId, o.projectId = t, e(t)
                }).catch(function(t) {
                  H && H.constructor === Function && (t.code = "004", H(t)), console.error(t)
                }) : (K.clone = !1, K.originProjectId = null, e(o.projectId)), t.finish(18);
              case 42:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [11, 15, 18, 42]
          ])
        }
      }, {
        
        /**
         * 템플릿 편집 모드로 에디터를 연다 (스태프 전용).
         * issueStaffToken API로 스태프 토큰 발급. 50분간 캐시.
         * @param {Object} e - 템플릿 편집 설정 (selector, psCode, division 등)
         */
        key: "editTemplate",
        value: function(e) {
          var n, r, o, i, a;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (K.openType = "EDIT", n = this, r = {
                    parent_element: document.querySelector(e.selector),
                    ps_code: e.psCode,
                    template_uri: e.templateUrl || null,
                    ddp_block: e.ddpBlock || "",
                    div: e.division,
                    lang: e.lang || "ko",
                    num_page: e.initPageCount,
                    max_page: e.maxPage,
                    no_update: e.unableUpdate,
                    run_mode: e.hideToolbar ? "passive" : "standard",
                    plugin_param: e.pluginParams,
                    force_plugin: e.testPlugin,
                    partner: "redp",
                    mobile: e.isMobile,
                    unit_page: e.bundlePageUnit,
                    ui_locale: e.locale,
                    cal_date: e.calenderDate,
                    options: e.extra,
                    video_frames: e.useVideoFrame
                  }, e && e.unableLayers && (e.unableLayers.constructor === String().constructor ? r.unlayers = e.unableLayers : e.unableLayers.constructor === Array().constructor && 0 < e.unableLayers.length && (r.unlayers = e.unableLayers.join(","))), e && e.lockGroupPageCount && (r.no_edit_group = e.lockGroupPageCount, r.edit_lock = "edit-group"), e && e.disableMasterColorPicker && (r.no_edit_group = e.lockGroupPageCount, r.edit_lock = r.edit_lock ? r.edit_lock + ",set-strict-color" : "set-strict-color"), e && e.disableFontPreview && (r.edit_lock = r.edit_lock ? r.edit_lock + ",no-font-preview" : "no-font-preview"), e && e.disableSelection && (r.edit_lock = r.edit_lock ? r.edit_lock + ",no-selection" : "no-selection"), e.resourceParams && (r.resapi_param = e.resourceParams), e.clearSource && (r.clear_src = e.clearSource), e.privateCSS) return t.next = 13, regeneratorRuntime.awrap(this.getCustomCss(e.privateCSS));
                t.next = 14;
                break;
              case 13:
                r.private_css = t.sent;
              case 14:
                if (B().user) {
                  t.next = 17;
                  break
                }
                return t.abrupt("return", !1);
              case 17:
                o = n.editorEventHandler, e.promotionInfo && (r.options || (r.options = {}), r.options.promo = {
                  preferredWidth: e.promotionInfo.width,
                  preferredHeight: e.promotionInfo.height,
                  url: e.promotionInfo.url,
                  opened: e.promotionInfo.autoShow
                }), i = D("staffEditorToken"), i = JSON.parse(i || "{}"), 3e6, a = {}, (new Date).getTime() - i.expiredAt < 3e6 ? a.token = i.token : a.token = !1, a.token ? (r.token = a.token, Qe.edit_template(r, o)) : en.call("issueStaffToken").then(function(t) {
                  r.token = t.token;
                  var e = {
                    token: t.token,
                    expiredAt: (new Date).getTime()
                  };
                  D("staffEditorToken", e), Qe.edit_template(r, o)
                }).catch(function(t) {
                  H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
                });
              case 25:
              case "end":
                return t.stop()
            }
          }, null, this)
        }
      }, {
        
        // ---- VDP(가변 데이터 인쇄) 메서드 (3개) ----
        /**
         * VDP 뷰어를 iframe으로 연다.
         * @param {Object} t - VDP 설정 (selector, projectId 필수, npage, flow, dataRow, psCode)
         */
        key: "openVdpViewer",
        value: function(t) {
          var n = this;
          try {
            U(["selector", "projectId"], t)
          } catch (t) {
            H && H.constructor === Function && (t.code = "003", H(t)), console.log(t)
          } finally {
            var r = {
                parent_element: document.querySelector(t.selector),
                prjid: t.projectId,
                npage: t.npage || 1,
                flow: t.flow || "horizontal",
                data_row: t.dataRow,
                ps_code: t.psCode
              },
              e = B();
            if (!e.user) return !1;
            e.token ? (r.token = e.token, Qe.open_tnview(r, this.editorEventHandler)) : en.call("issueUserToken").then(function(t) {
              r.token = t.token;
              var e = {
                token: t.token,
                expiredAt: (new Date).getTime()
              };
              D("editorToken", e), Qe.open_tnview(r, n.editorEventHandler)
            }).catch(function(t) {
              H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
            })
          }
        }
      }, {
        
        /**
         * VDP 데이터 행을 에디터에 설정한다.
         * @param {Object} t - VDP 데이터 행 객체
         */
        key: "setVariableData",
        value: function(t) {
          Qe.set_variable_data_row(t)
        }
      }, {
        
        /**
         * 썸네일 뷰어의 페이지를 원격으로 이동한다.
         * @param {Object} t - 페이지 이동 데이터
         */
        key: "remotePageTnViewer",
        value: function(t) {
          Qe.move_page_tnview(t)
        }
      }, {
        
        /**
         * 현재 템플릿의 VDP 카탈로그를 반환한다.
         * @returns {Object|null} { totalPage, variableDataList } 또는 null
         */
        key: "getCurrentTemplateVdpList",
        value: function() {
          return F
        }
      }, {
        
        /**
         * 에디터에서 열린 프로젝트를 다른 프로젝트로 변경한다.
         * @param {string} t - 변경할 프로젝트 ID
         */
        key: "changeProject",
        value: function(t) {
          D("projectId", t), Qe.change_project(t)
        }
      }, {
        
        /**
         * 에디터의 현재 템플릿을 변경한다.
         * @param {string} t - 상품 코드
         * @param {string} e - 새 템플릿 URI
         */
        key: "changeTemplate",
        value: function(t, e) {
          Qe.change_template(t, e)
        }
      }, {
        
        // ---- 에디터 UI 제어 메서드 (5개) ----
        /**
         * 현재 활성 페이지의 레이아웃을 변경한다.
         * DDP change-layout 명령을 생성하여 에디터에 전송.
         * @param {string} t - 템플릿 URI
         * @param {number} e - 템플릿 내 인덱스
         * @param {Object} n - 옵션 { changeBackground, changeOverlay, transferCellContent, transferTextContent }
         * @param {Function} r - 완료 콜백
         * @returns {RedEditorSDK} this (체이닝)
         */
        key: "changeLayout",
        value: function(t, e) {
          var n = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {},
            r = arguments[3],
            o = {
              ddp_block: {
                commands: [{
                  action: "change-layout",
                  target: {
                    object: "page",
                    position: "active-page"
                  },
                  data: {
                    templateUri: t,
                    indexInTemplate: e,
                    changeBackgroundIfAvailable: n.changeBackground || !1,
                    changeOverlay: !1 !== n.changeOverlay,
                    transferCellContent: !1 !== n.transferCellContent,
                    transferTextContent: !1 !== n.transferTextContent,
                    userItemTypesToPreserve: ["textbox"]
                  }
                }]
              }
            };
          return r && r.constructor === Function && (k = r), Qe.post_to_editor("execute-ddp-block", o), this
        }
      }, {
        
        /**
         * 페이지 콘텐츠를 다른 위치로 복사한다.
         * @param {number} t - 원본 페이지 인덱스
         * @param {number} e - 대상 위치
         * @returns {RedEditorSDK} this (체이닝)
         */
        key: "copyPageContent",
        value: function(t, e) {
          var n = {
            commands: [{
              action: "copy-page-content",
              target: {
                object: "page",
                index: t
              },
              data: {
                position: e
              }
            }]
          };
          return Qe.post_to_editor("execute-ddp-block", {
            ddp_block: n
          }), this
        }
      }, {
        
        // ---- 이벤트 처리 메서드 (2개) ----
        /**
         * 에디터 이벤트 핸들러 (내부용).
         * iframe에서 수신되는 모든 이벤트를 분기 처리. Sentry 로깅 포함.
         * 주요 이벤트: project-id-created, load-project-report, doc-changed,
         *   save-doc-report, close, selection-changed, scene-info-report,
         *   request-user-token, impose-opened, prod-var-changed 등
         * @param {Error|null} e - 에디터 에러
         * @param {Object} n - 이벤트 데이터 { action, info }
         */
        key: "editorEventHandler",
        value: function(e, n) {
          var r, o, i, a, c, s, u;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (this, !e) {
                  t.next = 5;
                  break
                }
                alert(e), t.next = 62;
                break;
              case 5:
                if ("project-id-created" === n.action && (D("projectId", n.info.project_id), l(n)), "load-project-report" !== n.action && "edit-template-report" !== n.action || "end" !== n.info.status || (A = !1, f(n), W && "number" == typeof W && (M = setInterval(function() {
                    Qe.post_to_editor("command", {
                      type: "save",
                      show_progress: !1,
                      force_save: !1
                    })
                  }, 6e4 * W)), J({
                    message: "[" + K.openType + "]Editor Loaded" + (K.fromKOIPassive ? "(KOI-Passive)" : ""),
                    projectId: D("projectId"),
                    data: _extends({}, n.info, {
                      mode: K.mode,
                      deviceTarget: K.deviceTarget,
                      config: K.params
                    })
                  })), "show-tn-report" === n.action && "end" === n.info.status && f(n), !["doc-changed", "var-added", "var-deleted", "var-changed"].includes(n.action)) {
                  t.next = 20;
                  break
                }
                if (p(n), "doc-changed" !== n.action || !n.info) {
                  t.next = 20;
                  break
                }
                if (n.info && n.info.template_uri) return r = n.info.template_uri.split("/"), o = r.length, i = r[o - 1].split(".")[0], t.next = 17, regeneratorRuntime.awrap(en.getResourceWithId(i));
                t.next = 19;
                break;
              case 17:
                (a = t.sent) && a.template_uri ? en.updateTemplateCount(a.template_uri, "hit") : console.warn("Fail Resource Info LookUp");
              case 19:
                F = void 0 !== n.info.vdp_catalog && null !== n.info.vdp_catalog && 0 < Object.keys(n.info.vdp_catalog).length ? {
                  totalPage: n.info.page_count,
                  variableDataList: n.info.vdp_catalog
                } : null;
              case 20:
                if ("page-changed" === n.action && P(n), "promo-external-report" === n.action && y(n), "command-completed" === n.action && (b.resolve(n), b.resolve = function() {
                    return null
                  }), "command-rejected" === n.action && (b.reject(n), b.reject = function() {
                    return null
                  }), "save-doc-report" === n.action && "end" === n.info.status && (c = {
                    message: "[" + K.openType + "]Editor Saved" + (K.fromKOIPassive ? "(KOI-Passive)" : ""),
                    projectId: D("projectId"),
                    data: _extends({}, n.info, {
                      mode: K.mode,
                      deviceTarget: K.deviceTarget
                    })
                  }, J(c), h(n)), "close" !== n.action && "goto-cart" !== n.action) {
                  t.next = 45;
                  break
                }
                if (s = null, t.prev = 27, n.info && n.info.projectID) return t.next = 31, regeneratorRuntime.awrap(en.call("isReadyToOrder", n.info.projectID || D("projectId")));
                t.next = 33;
                break;
              case 31:
                (s = t.sent).can_order ? n.isCanOrder = !0 : (n.error = s, n.isCanOrder = !1);
              case 33:
                J({
                  message: "[" + K.openType + "]Editor Close" + (K.fromKOIPassive ? "(KOI-Passive)" : ""),
                  projectId: D("projectId"),
                  data: _extends({}, n.info, {
                    mode: K.mode,
                    deviceTarget: K.deviceTarget
                  })
                }), t.next = 41;
                break;
              case 36:
                t.prev = 36, t.t0 = t.catch(27), H && H.constructor === Function && (t.t0.code = "003", H(t.t0)), n.error = t.t0, console.log(t.t0);
              case 41:
                return t.prev = 41, d(n), t.finish(41);
              case 44:
                M && "number" == typeof M && clearInterval(M);
              case 45:
                "selection-changed" === n.action && v(n), "state-history" === n.action && g(n), "label-history" === n.action && _(n.info), "dpp-execute-report" === n.action && "end" === n.info.status && (k && k.constructor === Function && k(), k = null), "scene-info-report" === n.action && N && N.constructor === Function && (n.info.activePage && (n.info.sceneInfo.activePage = n.info.activePage), N(n.info.sceneInfo), N = null), "imgpool-notify" === n.action && w(n.info), "preview-closed" === n.action && S(), "font-list" === n.action && E(n.info), "enter-overlay-mode" !== n.action && "exit-overlay-mode" !== n.action || I(n), "page-count-changed" === n.action && T(n), "request-page-size-change" === n.action && m(n), "request-user-token" === n.action && en.call("issueUserToken").then(function(t) {
                  t.division && D("division", t.division), t.lang && D("lang", t.lang), t.companyCode && D("companyCode", t.companyCode);
                  var e = {
                    token: t.token,
                    expiredAt: (new Date).getTime()
                  };
                  D("editorToken", e);
                  var n = {
                    token: t.token
                  };
                  Qe.post_to_editor("send-user-token", n)
                }).catch(function(t) {
                  H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
                }), "impose-opened" === n.action && O(n), "page-group-print-count-changed" === n.action && j(n), "prod-var-changed" == n.action && C(n), "doc-report" == n.action && (u = {
                  message: "[" + K.openType + "]Editor Doc Report " + (K.fromKOIPassive ? "(KOI-Passive)" : ""),
                  projectId: D("projectId"),
                  data: _extends({}, n.info, {
                    mode: K.mode,
                    deviceTarget: K.deviceTarget
                  })
                }, J(u), R(n)), x(n);
              case 62:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [27, 36, 41, 44]
          ])
        }
      }, {
        
        /**
         * 에디터 이벤트 콜백을 등록한다.
         * 지원 이벤트(22종): create, close, load, change, save, select,
         *   historyState, historyLabel, promoReport, error, imagePool,
         *   previewClose, fontList, changeMode, pageCountChange, pageChange,
         *   groupCaption, imposeOpened, printCountChange, customTabSelectionChange,
         *   docReport, all
         * @param {string} t - 이벤트 타입
         * @param {Function} e - 콜백 함수
         * @returns {RedEditorSDK} this (체이닝)
         */
        key: "on",
        value: function(t, e) {
          return "create" === t ? l = e : "close" === t ? d = e : "load" === t ? f = e : "change" === t ? p = e : "save" === t ? h = e : "select" === t ? v = e : "historyState" === t ? g = e : "historyLabel" === t ? _ = e : "promoReport" === t ? y = e : "error" === t ? H = function(t) {
            J({
              message: t,
              projectId: null,
              data: null,
              level: "error"
            }), e(t)
          } : "imagePool" === t ? w = e : "previewClose" === t ? S = e : "fontList" === t ? E = e : "changeMode" === t ? I = e : "pageCountChange" === t ? T = e : "pageChange" === t ? P = e : "groupCaption" === t ? m = e : "imposeOpened" === t ? O = e : "printCountChange" === t ? j = e : "customTabSelectionChange" === t ? C = e : "docReport" === t ? R = e : "all" === t && (x = e), this
        }
      }, {
        
        // ---- 조회/인증 메서드 ----
        /**
         * 현재 프로젝트 ID를 반환한다.
         * @returns {string|null} sessionStorage의 projectId
         */
        key: "getProjectId",
        value: function() {
          return D("projectId")
        }
      }, {
        
        /**
         * 에디터에 원격 명령을 전송한다. changeLayout은 deprecated.
         * @param {string} t - 명령 타입
         * @param {Object} e - 명령 데이터
         * @returns {Promise<void>}
         */
        key: "remoteEditor",
        value: function(t, e) {
          if ("changeLayout" !== t) return Qe.post_to_editor(t, e), ["command"].includes(t) && ["close-preview"].includes(e.type) ? new Promise(function(t, e) {
            b.resolve = t, b.reject = e
          }) : new Promise(function(t, e) {
            t(void 0)
          });
          console.warn("[Deprecated] This Action Will be Deprecated ! Check change API Document, should be use changeLayout method!"), Qe.change_layout(e.uri, e.pageIndex, e.isChangeableBackground)
        }
      }, {
        
        /**
         * 여러 DDP 명령을 일괄 전송한다.
         * @param {Object[]} t - 고수준 명령 배열
         * @param {Object|Function} e - 히스토리 라벨 또는 콜백
         * @param {boolean|Function} n - 히스토리 리셋 또는 콜백
         * @param {Function} r - 완료 콜백
         */
        key: "remoteEditorBulk",
        value: function(t, e, n, r) {
          var o = {
            ddp_block: G(t)
          };
          void 0 !== e && e.constructor === Function && void 0 === r ? r = e : e && e.constructor === Object && (o.history_label = e), void 0 !== n && n.constructor === Function && void 0 === r ? r = n : n && n.constructor === Boolean && (o.reset_history = n), r && r.constructor === Function && (k = r), o.ddp_block.commands.some(function(t) {
            return "set-text-style" === t.action ? t.data.text || "" === t.data.text : "set-item-src" === t.action && (t.data.src && t.data.src.includes("color"))
          }) && (o.show_progress = !1), 0 < o.ddp_block.commands.length && Qe.post_to_editor("execute-ddp-block", o)
        }
      }, {
        
        /**
         * 사용자 ID를 설정하고 사용자 토큰을 발급받는다.
         * @param {string} t - 사용자 ID
         * @returns {null}
         */
        key: "setUserId",
        value: function(t) {
          var n = this;
          return D("userId", t), this.isReady = !1, en.call("issueUserToken").then(function(t) {
            t.division && D("division", t.division), t.lang && D("lang", t.lang), t.companyCode && D("companyCode", t.companyCode);
            var e = {
              token: t.token,
              expiredAt: (new Date).getTime()
            };
            D("editorToken", e), n.isReady = !0
          }).catch(function(t) {
            H && H.constructor === Function && (t.code = "003", H(t)), console.error(t)
          }), null
        }
      }, {
        
        // ---- 프로젝트 데이터 메서드 (2개) ----
        /**
         * 현재 사용자의 프로젝트 목록을 조회한다.
         * @param {Function} r - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getProjectList",
        value: function(r) {
          this.isReady || alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId.");
          var t = D("userId");
          return new Promise(function(e, n) {
            en.call("projectList", t).then(function(t) {
              r && "function" == typeof r ? r(null, t) : e(t)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), r && "function" == typeof r ? r(t) : n(t)
            })
          })
        }
      }, {
        
        /**
         * 상품 정보를 조회한다 (userData, paletteInfo 포함).
         * division과 defaultLanguage에 따라 userData를 파싱.
         * @param {string} r - 상품 코드
         * @param {Function} o - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getProductInfo",
        value: function(r, o) {
          return new Promise(function(n, e) {
            D("division") ? en.call("getProductInfo", r).then(function(t) {
              var e = t.product;
              e.userData = JSON.parse(e.userData || "{}"), e.userData && e.userData.productCustomData && e.userData.productCustomData[D("division")] ? e.userData.productCustomData[D("division")][e.defaultLanguage] ? e.userData = e.userData.productCustomData[D("division")][e.defaultLanguage] : e.userData = e.userData.productCustomData[D("division")] : e.userData = null, o && "function" == typeof o ? o(null, e) : n(e)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), o && "function" == typeof o ? o(t) : e(t)
            }) : en.call("issueUserToken").then(function(t) {
              t.division && D("division", t.division), t.lang && D("lang", t.lang);
              var e = {
                token: t.token,
                expiredAt: (new Date).getTime()
              };
              D("editorToken", e), en.call("getProductInfo", r).then(function(t) {
                var e = t.product;
                e.userData = JSON.parse(e.userData || "{}"), e.userData && e.userData.productCustomData && e.userData.productCustomData[D("division")] ? e.userData = e.userData.productCustomData[D("division")] : e.userData = null, o && "function" == typeof o ? o(null, e) : n(e)
              })
            }).catch(function(t) {
              H && H.constructor === Function && H(t), o && "function" == typeof o ? o(t) : e(t)
            })
          })
        }
      }, {
        
        /**
         * 프로젝트 썸네일 목록을 조회한다.
         * @param {string|Function} t - 프로젝트 ID 또는 콜백
         * @param {Function} r - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getProjectThumbnails",
        value: function(t, r) {
          return this.isReady ? (null !== t && "function" == typeof t && (r = t, t = null), new Promise(function(e, n) {
            en.call("projectThumbnail", t).then(function(t) {
              r && "function" == typeof r ? r(null, t) : e(t)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), r && "function" == typeof r ? r(t) : n(t)
            })
          })) : alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId.")
        }
      }, {
        
        /**
         * 임포징 수량을 계산한다.
         * @param {Object} t - { methods, sourceSize, imposeSize, rotatable, border }
         * @param {Function} r - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getImposeCount",
        value: function(t, r) {
          if (!this.isReady) return alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId.");
          var e = t.methods,
            n = void 0 === e ? ["contact-point"] : e,
            o = t.sourceSize,
            i = t.imposeSize,
            a = t.rotatable,
            c = void 0 === a || a,
            s = t.border,
            u = void 0 === s ? 0 : s,
            l = {
              methods: n,
              srcSize_mm: _extends({}, o),
              imposeSize_mm: _extends({}, i),
              rotatable: c,
              border: u
            };
          return new Promise(function(e, n) {
            en.call("getImposeCount", null, l).then(function(t) {
              r && "function" == typeof r ? r(null, t) : e(t)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), r && "function" == typeof r ? r(t) : n(t)
            })
          })
        }
      }, {
        
        /**
         * 프로젝트를 복제하고 새 프로젝트 ID를 반환한다.
         * @param {string} t - 원본 프로젝트 ID
         * @param {Object} r - 복제 옵션 { projectOwnerId }
         * @returns {Promise<string>} 복제된 프로젝트 ID
         */
        key: "cloneProject",
        value: function(t, r) {
          return this.isReady || alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId."), new Promise(function(e, n) {
            en.call("cloneProject", t, r).then(function(t) {
              e(t.project_id)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), n(t)
            })
          })
        }
      }, {
        
        // ---- 주문 메서드 (1개) ----
        /**
         * [Deprecated] 임시 주문을 생성한다. 서버에서 직접 호출 권장.
         * @param {string} t - 프로젝트 ID
         * @param {Object} r - 주문 파라미터 { order_count, total_price }
         * @param {Function} o - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "prepareOrder",
        value: function(t, r, o) {
          if (console.warn("[Deprecated] This API will be deprecated, should be call on Server."), !this.isReady) return alert("UserID Must be Set before use this function. Please call setUserId or re-init with userId.");
          if (null === t && "string" != typeof t) return alert("projectId must be string");
          try {
            U(["order_count", "total_price"], r)
          } catch (t) {
            console.error(t)
          }
          var i = JSON.parse(D("edicusConfig") || "{}");
          return new Promise(function(e, n) {
            en.call("tentativeOrder", t, r).then(function(t) {
              o && "function" == typeof o ? o(null, t) : e(t), en.updateTemplateCount(i.template_uri, "order")
            }).catch(function(t) {
              H && H.constructor === Function && H(t), o && "function" == typeof o ? o(t) : n(t)
            })
          })
        }
      }, {
        key: "getProductList",
        value: function(r) {
          return new Promise(function(e, n) {
            en.getProductList().then(function(t) {
              r && "function" == typeof r ? r(null, t) : e(t)
            }).catch(function(t) {
              H && H.constructor === Function && H(t), r && "function" == typeof r ? r(t) : n(t)
            })
          })
        }
      }, {
        
        // ---- 템플릿 관리 메서드 (5개) ----
        /**
         * 특정 상품의 템플릿 목록을 조회한다.
         * 필터(사이즈, 피처, 정렬) 지원. 콜백 또는 Promise 반환.
         * @param {string} r - 상품 코드
         * @param {Object|Function} e - 필터 조건 또는 콜백
         * @param {Function} o - 콜백 (error, data)
         * @returns {Promise<Object>}
         */
        key: "getTemplateList",
        value: function(r, e, o) {
          var i, n, a, c, s;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (null === e || "function" != typeof e) {
                  t.next = 5;
                  break
                }
                o = e, i = {}, t.next = 28;
                break;
              case 5:
                if (null != e) {
                  t.next = 9;
                  break
                }
                i = {}, t.next = 28;
                break;
              case 9:
                if ("object" !== (void 0 === e ? "undefined" : _typeof(e))) {
                  t.next = 28;
                  break
                }
                if ((i = JSON.parse(JSON.stringify(e))).size && Array.isArray(i.size) && (i.size = {
                    $in: i.size
                  }), i.features) return n = [], t.prev = 14, t.next = 17, regeneratorRuntime.awrap(this.getProductInfo(r));
                t.next = 27;
                break;
              case 17:
                a = t.sent, n = a.userData || [], t.next = 24;
                break;
              case 21:
                t.prev = 21, t.t0 = t.catch(14), H && H.constructor === Function && (t.t0.code = "003", H(t.t0));
              case 24:
                c = i.features, delete i.features, Object.keys(c).map(function(e) {
                  var t = null;
                  t = n.some(function(t) {
                    return t.field === e && "text" === t.type
                  }) ? c[e] : "string" == typeof c[e] ? [c[e]] : c[e], i["features." + e] = {
                    $in: t
                  }
                });
              case 27:
                i.sort && (s = i.sort, i.sort = {}, Object.keys(s).map(function(t) {
                  ["hit", "ordered", "priority"].includes(t) ? i.sort["sortReference." + t] = s[t] : i.sort[t] = s[t]
                }));
              case 28:
                return t.abrupt("return", new Promise(function(e, n) {
                  en.getTemplateList(r, i).then(function(t) {
                    o && "function" == typeof o ? o(null, t) : e(t)
                  }).catch(function(t) {
                    H && H.constructor === Function && H(t), o && "function" == typeof o ? o(t) : n(t)
                  })
                }));
              case 29:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [14, 21]
          ])
        }
      }, {
        key: "getResourceList",
        value: function(r, o, e, i) {
          var a, n, c, s, u;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (!o.resourceType) {
                  t.next = 32;
                  break
                }
                if (null === e || "function" != typeof e) {
                  t.next = 6;
                  break
                }
                i = e, a = {}, t.next = 29;
                break;
              case 6:
                if (null != e) {
                  t.next = 10;
                  break
                }
                a = {}, t.next = 29;
                break;
              case 10:
                if ("object" !== (void 0 === e ? "undefined" : _typeof(e))) {
                  t.next = 29;
                  break
                }
                if ((a = JSON.parse(JSON.stringify(e))).size && Array.isArray(a.size) && (a.size = {
                    $in: a.size
                  }), a.features) return n = [], t.prev = 15, t.next = 18, regeneratorRuntime.awrap(this.getProductInfo(r));
                t.next = 28;
                break;
              case 18:
                c = t.sent, n = c.userData || [], t.next = 25;
                break;
              case 22:
                t.prev = 22, t.t0 = t.catch(15), H && H.constructor === Function && (t.t0.code = "003", H(t.t0));
              case 25:
                s = a.features, delete a.features, Object.keys(s).map(function(e) {
                  var t = null;
                  t = n.some(function(t) {
                    return t.field === e && "text" === t.type
                  }) ? s[e] : "string" == typeof s[e] ? [s[e]] : s[e], a["features." + e] = {
                    $in: t
                  }
                });
              case 28:
                a.sort && (u = a.sort, a.sort = {}, Object.keys(u).map(function(t) {
                  ["hit", "ordered"].includes(t) ? a.sort["sortReference." + t] = u[t] : a.sort[t] = u[t]
                }));
              case 29:
                return t.abrupt("return", new Promise(function(e, n) {
                  en.getResourceList(r, o, a).then(function(t) {
                    i && "function" == typeof i ? i(null, t) : e(t)
                  }).catch(function(t) {
                    H && H.constructor === Function && H(t), i && "function" == typeof i ? i(t) : n(t)
                  })
                }));
              case 32:
                console.warn("resourceType does not exist. Please enter the type again");
              case 33:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [15, 22]
          ])
        }
      }, {
        key: "getResourceWithId",
        value: function(r, o) {
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                return t.abrupt("return", new Promise(function(e, n) {
                  en.getResourceWithId(r).then(function(t) {
                    o && "function" == typeof o ? o(null, t) : e(t)
                  }).catch(function(t) {
                    H && H.constructor === Function && H(t), o && "function" == typeof o ? o(t) : n(t)
                  })
                }));
              case 1:
              case "end":
                return t.stop()
            }
          }, null, this)
        }
      }, {
        
        /**
         * 에디터의 전체 씬(장면) 정보를 조회한다. 텍스트 정보 포함.
         * @param {Function} t - 씬 정보 수신 콜백
         */
        key: "getSceneInfo",
        value: function(t) {
          Qe.post_to_editor("get-scene-info", {
            include_text_info: !0
          }), N = t
        }
      }, {
        
        /**
         * 현재 활성 페이지의 씬 정보를 조회한다.
         * @param {Function} t - 씬 정보 수신 콜백
         */
        key: "getActiveSceneInfo",
        value: function(t) {
          Qe.post_to_editor("get-scene-info", {
            active_page_only: !0,
            include_text_info: !0
          }), N = t
        }
      }, {
        
        // ---- 라이프사이클 메서드 (5개) ----
        /**
         * 에디터를 닫는다 (저장 없이).
         */
        key: "close",
        value: function() {
          var t = {
            action: "close"
          };
          Qe.post_to_editor("return-message", t)
        }
      }, {
        
        /**
         * 현재 프로젝트를 저장한다.
         * @param {Object} options - { removeOutterItems: boolean }
         */
        key: "save",
        value: function() {
          var t = {
            type: "save"
          };
          (0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {}).removeOutterItems && (t.remove_outter_item = !0), Qe.post_to_editor("command", t)
        }
      }, {
        
        /**
         * 현재 프로젝트를 저장한 후 에디터를 닫는다.
         * @param {Object} options - { removeOutterItems: boolean }
         */
        key: "saveThenClose",
        value: function() {
          var t = {
            type: "save-then-close"
          };
          (0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : {}).removeOutterItems && (t.remove_outter_item = !0), Qe.post_to_editor("command", t)
        }
      }, {
        key: "setToken",
        value: function(t) {
          en.setToken(t)
        }
      }, {
        
        /**
         * 프로젝트의 주문 가능 여부를 확인한다.
         * @param {string} e - 프로젝트 ID
         * @param {Function} n - 콜백 (error, result)
         * @returns {Promise<Object>} { can_order, doc_rev, message }
         */
        key: "checkOrderable",
        value: function(e, n) {
          var r;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                return r = null, t.prev = 1, U(["projectId"], {
                  projectId: e
                }), t.next = 5, regeneratorRuntime.awrap(en.call("isReadyToOrder", e));
              case 5:
                if (null === (r = t.sent).doc_rev && (r.can_order = !1), !n || n.constructor !== Function) {
                  t.next = 11;
                  break
                }
                n(null, r), t.next = 12;
                break;
              case 11:
                return t.abrupt("return", r);
              case 12:
                t.next = 21;
                break;
              case 14:
                return t.prev = 14, t.t0 = t.catch(1), H && H.constructor === Function && H(t.t0), r = {
                  can_order: !1,
                  message: t.t0.message
                }, n && n.constructor === Function && n(t.t0, r), console.log(t.t0), t.abrupt("return", r);
              case 21:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [1, 14]
          ])
        }
      }, {
        
        /**
         * 외부 CSS 파일을 다운로드하여 문자열로 반환한다.
         * @param {string} r - CSS 파일 URL
         * @returns {Promise<string>} CSS 텍스트
         */
        key: "getCustomCss",
        value: function(r) {
          return new Promise(function(e, t) {
            var n = new XMLHttpRequest;
            n.open("GET", r, !0), n.setRequestHeader("Cache-Control", "max-age=0"), n.responseType = "blob", n.onload = function() {
              var t = new FileReader;
              t.readAsText(n.response), t.onload = function(t) {
                e(t.target.result)
              }
            }, n.send()
          })
        }
      }, {
        
        /**
         * SDK 인스턴스를 파괴하고 리소스를 정리한다.
         * 모든 이벤트 콜백을 초기화하고 iframe을 제거.
         * @param {boolean} t - 이벤트 콜백 초기화 여부
         */
        key: "destroy",
        value: function(t) {
          var e = JSON.parse(D("edicusConfig"));
          t && (l = function() {
            return null
          }, f = function() {
            return null
          }, p = function() {
            return null
          }, d = function() {
            return null
          }, h = function() {
            return null
          }, v = function() {
            return null
          }, g = function() {
            return null
          }, _ = function() {
            return null
          }, H = function() {
            return null
          }, E = function() {
            return null
          }, I = function() {
            return null
          }, T = function() {
            return null
          }, P = function() {
            return null
          }, R = function() {
            return null
          }, x = function() {
            return null
          }), Qe.destroy(e ? document.querySelector(e.selector) : null, t), u && (We.removeEventListener("message", q, !1), u.removeChild(L))
        }
      }, {
        
        /**
         * KOI 풀 기능 게이트웨이 UI를 iframe으로 연다.
         * @param {Object} t - { selector, productCode }
         * @param {Object} e - UI 옵션 { targetUrl, ... }
         * @returns {Function|false} iframe 메시지 전송 함수 또는 false
         */
        key: "openFullyFunctionalUI",
        value: function(t, e) {
          var n = t.selector,
            r = t.productCode;
          return !A && (A = !0, u = document.querySelector(n), L = function(t, e, n) {
            var r = n ? "http://koi-staging.redprinting.net/" : "https://koi.redprinting.net/";
            e && e.targetUrl && (r = e.targetUrl, delete e.targetUrl);
            var o = r + "gateway/" + t + "?",
              i = {
                accessToken: en.getToken(),
                userId: D("userId"),
                companyCode: D("companyCode"),
                division: D("division"),
                lang: D("lang")
              };
            o += "config=" + encodeURIComponent(JSON.stringify(i)), e && "object" === (void 0 === e ? "undefined" : _typeof(e)) && (o += "&options=" + encodeURIComponent(JSON.stringify(e)));
            var a = document.createElement("iframe");
            return a.setAttribute("src", o), a.setAttribute("frameborder", "0"), a.style.width = "100%", a.style.height = "100%", a
          }(r, e, this.isDev), We.addEventListener("message", q, !1), u.appendChild(L), function(t) {
            L.contentWindow.postMessage(JSON.stringify(t), "*")
          })
        }
      }, {
        key: "getProjectOwnerId",
        value: function(t, e) {
          if (!e) return en.getProjectOwnerId(t);
          en.getProjectOwnerId(t).then(function(t) {
            e(null, t)
          }).catch(function(t) {
            e(t, null)
          })
        }
      }, {
        
        /**
         * 에디터에 가격 정보를 설정한다 ($PRCE 변수).
         * @param {string|number} t - 가격 값
         */
        key: "setPrice",
        value: function(t) {
          var e = {
            varMap: {
              $PRCE: t
            }
          };
          Qe.post_to_editor("set-mutable-prod-var", e)
        }
      }, {
        
        /**
         * 커스텀 탭의 현재 선택 정보를 조합하여 반환한다.
         * $CODE 파싱, combination/rawData/findData 타입 처리, NO_STOCK 판별.
         * @param {Object} g - 선택 데이터 ($CODE 포함)
         * @returns {Object} 조합된 선택 정보 (MTRL_COD 등)
         */
        key: "getCustomTabSelectInfo",
        value: function(g) {
          var _ = {},
            n = g.$CODE.split(",").reduce(function(t, e) {
              var n = e.split(":"),
                r = _slicedToArray(n, 2),
                o = r[0],
                i = r[1],
                a = o.split("@"),
                c = _slicedToArray(a, 2),
                s = c[0];
              switch (c[1]) {
                case "combination":
                  var u = i.split("/");
                  if (t[s] = u.reduce(function(t, e) {
                      return t += Object.keys(g).includes(e) ? g[e] : e
                    }, ""), "NO_STOCK" === s) {
                    var l = u.reduce(function(t, e) {
                        return t += e + ":" + g[e] + "/"
                      }, ""),
                      f = $.some(function(t) {
                        return t === l.slice(0, -1)
                      });
                    t[s] = f
                  }
                  break;
                case "rawData":
                  t[s] = g[i];
                  break;
                case "findData":
                  var p = i.split("/"),
                    d = _slicedToArray(p, 2),
                    h = d[0],
                    v = d[1];
                  _[s] = {
                    findField: h,
                    baseData: v
                  }
              }
              return t
            }, {});
          if (0 < Object.keys(_).length) {
            var t = !0,
              e = !1,
              r = void 0;
            try {
              for (var o, i = Object.entries(_)[Symbol.iterator](); !(t = (o = i.next()).done); t = !0) {
                var a = _slicedToArray(o.value, 2),
                  c = a[0],
                  s = a[1],
                  u = s.baseData,
                  l = s.findField.split("&").reduce(function(t, e) {
                    return t = t.filter(function(t) {
                      return t[e] === n[e]
                    })
                  }, Y[u]);
                n[c] = l[0][c]
              }
            } catch (t) {
              e = !0, r = t
            } finally {
              try {
                !t && i.return && i.return()
              } finally {
                if (e) throw r
              }
            }
          }
          return g.$FCMC && (n.MTRL_COD = g.$FCMC), n
        }
      }, {
        
        /**
         * 에디터 스테이지 서버 URL을 변경한다.
         * @param {string} t - 커스텀 스테이지 URL
         */
        key: "setEdicusStageUrl",
        value: function(t) {
          Qe.base_url = t
        }
      }]), o
    }(),
    
    // ============================================================
    // 섹션: 커스텀 탭 매니저 (X) — 상품 옵션 UI 데이터 가공 헬퍼
    // 역할: 소재 목록에서 동적 아이템 추출, 템플릿 매칭, 초기 변수 설정,
    //       품절(NO_STOCK) 판별, 엔티티 구성
    // ============================================================
    X = function() {
      function e(t) {
        _classCallCheck(this, e), this.productCode = t.productCode, this.locale = t.locale, this.product = t.product, this.customTabInfo = this.getCustomTabInfo(), this.templateList = t.templateList, this.isDev = t.isDev
      }
      return _createClass(e, [{
        key: "getCustomTabInfo",
        value: function() {
          return this.product.multilingualCustomData.product[this.locale].customTabInfo
        }
      }, {
        key: "whetherUsePalette",
        value: function(r) {
          return Object.entries({
            printType: ["PTP_SLK"]
          }).some(function(t) {
            var e = _slicedToArray(t, 2),
              n = e[0];
            if (e[1].includes(r[n])) return !0
          })
        }
      }, {
        key: "getExceptionCondition",
        value: function(t, r) {
          var e = !1;
          return t && (e = t.reduce(function(t, e) {
            var n = e.values.includes(r[e.field]);
            return t || n
          }, !1)), e
        }
      }, {
        key: "getGroupingCodes",
        value: function(o) {
          var t = this.customTabInfo,
            e = t.grouping,
            n = t.groupingInfo;
          return e ? n.list.map(function(t) {
            var e = t.sliceField,
              n = t.targetField,
              r = t.range;
            return e ? o[n].slice(r[0], r[1]) : o[n]
          }) : ["material"]
        }
      }, {
        key: "getMatchTemplate",
        value: function(t, g) {
          var _ = t.material,
            y = t.mappingData;
          return this.templateList.find(function(r) {
            var o = {},
              t = !0,
              e = !1,
              n = void 0;
            try {
              for (var i, a = g[Symbol.iterator](); !(t = (i = a.next()).done); t = !0) {
                var c = i.value,
                  s = c.key,
                  u = c.sliceField,
                  l = c.baseField,
                  f = c.range,
                  p = c.haveMappingData,
                  d = c.compareField,
                  h = u ? _[l].slice(f[0], f[1]) : _[l],
                  v = p ? y[s][h][d] : h;
                o[s] = v
              }
            } catch (t) {
              e = !0, n = t
            } finally {
              try {
                !t && a.return && a.return()
              } finally {
                if (e) throw n
              }
            }
            return Object.keys(o).reduce(function(t, e) {
              var n = r.features.customInfo[e] === o[e];
              return t && n
            }, !0)
          })
        }
      }, {
        key: "getSettingDocs",
        value: function(t, e) {
          var n = t.material,
            r = t.mappingData,
            o = e.haveMappingData,
            i = e.sliceField,
            a = e.targetItem,
            c = e.baseField,
            s = e.range,
            u = e.docFields,
            l = e.includeTemplateInfo,
            f = e.matchingTemplateInfo,
            p = {},
            d = i ? n[c].slice(s[0], s[1]) : n[c],
            h = o ? r[a][d] : n,
            v = !0,
            g = !1,
            _ = void 0;
          try {
            for (var y, m = u[Symbol.iterator](); !(v = (y = m.next()).done); v = !0) {
              var b = y.value;
              "code" === b.key ? p[b.key] = d : p[b.key] = h[b.value]
            }
          } catch (t) {
            g = !0, _ = t
          } finally {
            try {
              !v && m.return && m.return()
            } finally {
              if (g) throw _
            }
          }
          if (l) {
            var x = this.getMatchTemplate({
              material: n,
              mappingData: r
            }, f);
            p.templateUri = x ? x.template_uri : "", p.psCode = x ? x.psCode : "", p.sortNumber = x ? x.features.sortNumber : ""
          }
          return p
        }
      }, {
        key: "getItemList",
        value: function(t) {
          var f = this,
            e = this.customTabInfo,
            p = e.grouping,
            d = e.mappingData,
            n = e.dynamicItems,
            h = n.list.reduce(function(t, e) {
              return t[e.targetItem + "Tree"] = {}, t
            }, {});
          return t.reduce(function(r, u) {
            var t = n.exceptions,
              e = n.list;
            if (f.getExceptionCondition(t, u)) return r;
            var l = f.getGroupingCodes(u);
            return e.forEach(function(a) {
              var t = a.sliceField,
                e = a.baseField,
                n = a.range,
                c = a.targetItem,
                s = t ? u[e].slice(n[0], n[1]) : u[e];
              l.reduce(function(o, i, t, e) {
                if (void 0 === o[i] && (o[i] = p ? {} : []), t === l.length - 1)
                  if (p) void 0 === o[i][c] && (o[i][c] = []), l.reduce(function(t, e, n) {
                    if (void 0 === t[e] && (t[e] = {}), n === l.length - 1 && void 0 === t[e][s]) {
                      t[e][s] = !0;
                      var r = f.getSettingDocs({
                        material: u,
                        mappingData: d
                      }, a);
                      o[i][c].push(r)
                    }
                    return t[e]
                  }, h[c + "Tree"]);
                  else if (void 0 === h[c + "Tree"][s]) {
                  h[c + "Tree"][s] = !0;
                  var n = f.getSettingDocs({
                    material: u,
                    mappingData: d
                  }, a);
                  o[i].push(n)
                }
                return o[i][c].sort(function(t, e) {
                  return d[c][t.code].sortNumber ? d[c][t.code].sortNumber - d[c][e.code].sortNumber : t.sortNumber - e.sortNumber
                }), o[i]
              }, r)
            }), r
          }, {})
        }
      }, {
        key: "getInitVariable",
        value: function(r, o) {
          var t = Object.keys(r).reduce(function(t, e) {
              if (o[e]) {
                var n = o[e];
                t[e] = r[e].find(function(t) {
                  return t.code === n
                })
              } else t[e] = r[e][0];
              return t
            }, {}),
            e = {},
            n = !0,
            i = !1,
            a = void 0;
          try {
            for (var c, s = this.customTabInfo.initVariables[Symbol.iterator](); !(n = (c = s.next()).done); n = !0) {
              var u = c.value;
              if ("text" === u.type) e[u.variable] = u.value;
              else {
                if ("selected" === u.type) continue;
                void 0 === t[u.targetItem] ? e[u.variable] = r[u.targetItem][0][u.itemField] : e[u.variable] = t[u.targetItem][u.itemField]
              }
            }
          } catch (t) {
            i = !0, a = t
          } finally {
            try {
              !n && s.return && s.return()
            } finally {
              if (i) throw a
            }
          }
          return e
        }
      }, {
        key: "getSelection",
        value: function(e) {
          var n = this,
            t = this.customTabInfo.settings;
          if (!t) return [];
          var r = void 0;
          switch (t.selectionInfo.compareKey) {
            case "materialType":
              r = this.templateList.find(function(t) {
                return t.features.customInfo.materialType === e.materialType
              });
              break;
            case "productCode":
              r = this.templateList[0]
          }
          return r.features.customInfo.printArea.map(function(t) {
            return n.customTabInfo.mappingData.printArea[t]
          }).filter(function(t) {
            return null != t
          })
        }
      }, {
        key: "getEntities",
        value: function(n, r) {
          var o = this,
            t = this.customTabInfo.entities,
            i = [],
            _ = this.customTabInfo.dynamicItems.list.find(function(t) {
              return t.includeTemplateInfo
            }),
            e = !0,
            a = !1,
            c = void 0;
          try {
            for (var s, u = function() {
                var g = s.value;
                if ("uniform-select" === g.type) {
                  var t = n[g.items.target].reduce(function(t, e) {
                    var n = {},
                      r = !1,
                      o = !0,
                      i = !1,
                      a = void 0;
                    try {
                      for (var c, s = Object.keys(g.items)[Symbol.iterator](); !(o = (c = s.next()).done); o = !0) {
                        var u = c.value;
                        if ("target" !== u)
                          if ("varMap" === u) {
                            if (n[u] = {}, g.items.target === _.targetItem && !e[g.items[u].TMPL]) {
                              r = !0;
                              break
                            }
                            var l = !0,
                              f = !1,
                              p = void 0;
                            try {
                              for (var d, h = Object.keys(g.items[u])[Symbol.iterator](); !(l = (d = h.next()).done); l = !0) {
                                var v = d.value;
                                n[u]["$" + v] = e[g.items[u][v]]
                              }
                            } catch (t) {
                              f = !0, p = t
                            } finally {
                              try {
                                !l && h.return && h.return()
                              } finally {
                                if (f) throw p
                              }
                            }
                          } else n[u] = e[g.items[u]]
                      }
                    } catch (t) {
                      i = !0, a = t
                    } finally {
                      try {
                        !o && s.return && s.return()
                      } finally {
                        if (i) throw a
                      }
                    }
                    return r ? t : [].concat(_toConsumableArray(t), [n])
                  }, []);
                  g.items = t
                }
                if ("uniform-toggle" === g.type) {
                  var e = o.getSelection(r);
                  g.items = e
                }
                i.push(g)
              }, l = t[Symbol.iterator](); !(e = (s = l.next()).done); e = !0) u()
          } catch (t) {
            a = !0, c = t
          } finally {
            try {
              !e && l.return && l.return()
            } finally {
              if (a) throw c
            }
          }
          return t
        }
      }, {
        key: "getNoStocksInfo",
        value: function(e) {
          var n, y, m, r, b = this;
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                return n = this.customTabInfo.noStocks, y = n.exceptions, m = n.tagItems, r = e.reduce(function(t, r) {
                  var e = !1;
                  if (y && (e = y.reduce(function(t, e) {
                      var n = e.values.includes(r[e.field]);
                      return t || n
                    }, !1)), e) return t;
                  var n = "";
                  if ("Y" === r.HIDE_YN) {
                    var o = !0,
                      i = !1,
                      a = void 0;
                    try {
                      for (var c, s = m[Symbol.iterator](); !(o = (c = s.next()).done); o = !0) {
                        var u = c.value,
                          l = u.sliceField,
                          f = u.variable,
                          p = u.mappingKey,
                          d = u.baseField,
                          h = u.range,
                          v = u.mappingField,
                          g = u.referenceMappingData,
                          _ = l ? r[d].slice(h[0], h[1]) : r[d];
                        n += f + ":" + (g ? b.customTabInfo.mappingData[p][_][v] : _) + "/"
                      }
                    } catch (t) {
                      i = !0, a = t
                    } finally {
                      try {
                        !o && s.return && s.return()
                      } finally {
                        if (i) throw a
                      }
                    }
                    t.push(n.slice(0, -1))
                  }
                  return t
                }, []), t.abrupt("return", r);
              case 3:
              case "end":
                return t.stop()
            }
          }, null, this)
        }
      }, {
        key: "getCustomTabFormat",
        value: function(e, r) {
          var n, o, i, a, c, s, u, l, f, p, d, h, v, g, _, y, m, b, x, k, w, S, E, I, T, P, O, j, C, R, M, N, F, L = 2 < arguments.length && void 0 !== arguments[2] ? arguments[2] : {};
          return regeneratorRuntime.async(function(t) {
            for (;;) switch (t.prev = t.next) {
              case 0:
                if (n = this.customTabInfo, o = n.baseData, i = n.noStocks, a = n.grouping, c = n.groupingInfo, s = n.defaultPrice, u = n.settings, l = void 0 === u ? {} : u, f = this.getItemList(e[o]), p = L.skipInitVarMap, d = L.generateCutLayer, h = l.forceMaterialCode, v = this.product.controlPsCode, g = {}, _ = f, y = {}, m = Object.keys(r), a ? _ = c.list.reduce(function(t, e) {
                    var n = "";
                    return m.includes(e.key) && (n = r[e.key], m.splice(m.indexOf(e.key), 1)), e.initVariable && (y[e.initVariable] = r[e.key]), n ? t[n] : t
                  }, f) : y.$MTRL = r.material, b = m.reduce(function(t, e) {
                    return t[e] = r[e], t
                  }, {}), p) {
                  t.next = 47;
                  break
                }
                if (x = this.getInitVariable(_, b), k = _extends({
                    $CDBG: this.isDev
                  }, y, x), h && (w = h.condition, S = w.key, E = w.value, r[S] === E && (k.$FCMC = h.value)), d && (k.$PGLR = "Cut"), !v || !v.length) {
                  t.next = 46;
                  break
                }
                T = !(I = !0), P = void 0, t.prev = 20, O = v[Symbol.iterator]();
              case 22:
                if (I = (j = O.next()).done) {
                  t.next = 32;
                  break
                }
                if (C = j.value, R = C.condition, M = C.filter, N = C.data, R.every(function(t) {
                    var e = t.key,
                      n = t.value;
                    return r[e] === n
                  })) {
                  t.next = 28;
                  break
                }
                return t.abrupt("continue", 29);
              case 28:
                k.$PSCD = N[r[M]];
              case 29:
                I = !0, t.next = 22;
                break;
              case 32:
                t.next = 38;
                break;
              case 34:
                t.prev = 34, t.t0 = t.catch(20), T = !0, P = t.t0;
              case 38:
                t.prev = 38, t.prev = 39, !I && O.return && O.return();
              case 41:
                if (t.prev = 41, T) throw P;
                t.next = 44;
                break;
              case 44:
                return t.finish(41);
              case 45:
                return t.finish(38);
              case 46:
                g.varMap = k;
              case 47:
                return F = {
                  entities: this.getEntities(_, r)
                }, t.t1 = _extends, t.t2 = {}, t.t3 = g, t.t4 = {
                  $PRCE: "" + s
                }, t.next = 54, regeneratorRuntime.awrap(this.getNoStocksInfo(e[i.baseData]));
              case 54:
                return t.t5 = t.sent, t.t6 = F, t.t7 = {
                  mutableVarMap: t.t4,
                  noStocks: t.t5,
                  doc: t.t6
                }, g = (0, t.t1)(t.t2, t.t3, t.t7), t.abrupt("return", g);
              case 59:
              case "end":
                return t.stop()
            }
          }, null, this, [
            [20, 34, 38, 46],
            [39, , 41, 45]
          ])
        }
      }]), e
    }();
  // RedEditorSDK를 window 객체에 전역 등록
  We.RedEditorSDK = t
}(window);