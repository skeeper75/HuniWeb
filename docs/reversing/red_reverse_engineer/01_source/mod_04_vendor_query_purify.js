        }
      }
      hasListeners() {
        return this.listeners.size > 0
      }
      onSubscribe() {}
      onUnsubscribe() {}
    },
    n0 = {
      setTimeout: (e, t) => setTimeout(e, t),
      clearTimeout: e => clearTimeout(e),
      setInterval: (e, t) => setInterval(e, t),
      clearInterval: e => clearInterval(e)
    },
    o0 = class {
      #e = n0;
      #t = !1;
      setTimeoutProvider(e) {
        this.#t && e !== this.#e && console.error("[timeoutManager]: Switching provider after calls to previous provider might result in unexpected behavior.", {
          previous: this.#e,
          provider: e
        }), this.#e = e, this.#t = !1
      }
      setTimeout(e, t) {
        return this.#t = !0, this.#e.setTimeout(e, t)
      }
      clearTimeout(e) {
        this.#e.clearTimeout(e)
      }
      setInterval(e, t) {
        return this.#t = !0, this.#e.setInterval(e, t)
      }
      clearInterval(e) {
        this.#e.clearInterval(e)
      }
    },
    ro = new o0;

  function s0(e) {
    setTimeout(e, 0)
  }
  var io = typeof window > "u" || "Deno" in globalThis;

  function Ft() {}

  function r0(e, t) {
    return typeof e == "function" ? e(t) : e
  }

  function Da(e) {
    return typeof e == "number" && e >= 0 && e !== 1 / 0
  }

  function up(e, t) {
    return Math.max(e + (t || 0) - Date.now(), 0)
  }

  function Bn(e, t) {
    return typeof e == "function" ? e(t) : e
  }

  function Ut(e, t) {
    return typeof e == "function" ? e(t) : e
  }

  function cp(e, t) {
    const {
      type: n = "all",
      exact: o,
      fetchStatus: s,
      predicate: r,
      queryKey: a,
      stale: i
    } = e;
    if (a) {
      if (o) {
        if (t.queryHash !== Pa(a, t.options)) return !1
      } else if (!Ss(t.queryKey, a)) return !1
    }
    if (n !== "all") {
      const l = t.isActive();
      if (n === "active" && !l || n === "inactive" && l) return !1
    }
    return !(typeof i == "boolean" && t.isStale() !== i || s && s !== t.state.fetchStatus || r && !r(t))
  }

  function dp(e, t) {
    const {
      exact: n,
      status: o,
      predicate: s,
      mutationKey: r
    } = e;
    if (r) {
      if (!t.options.mutationKey) return !1;
      if (n) {
        if (ao(t.options.mutationKey) !== ao(r)) return !1
      } else if (!Ss(t.options.mutationKey, r)) return !1
    }
    return !(o && t.state.status !== o || s && !s(t))
  }

  function Pa(e, t) {
    return (t?.queryKeyHashFn || ao)(e)
  }

  function ao(e) {
    return JSON.stringify(e, (t, n) => Oa(n) ? Object.keys(n).sort().reduce((o, s) => (o[s] = n[s], o), {}) : n)
  }

  function Ss(e, t) {
    return e === t ? !0 : typeof e != typeof t ? !1 : e && t && typeof e == "object" && typeof t == "object" ? Object.keys(t).every(n => Ss(e[n], t[n])) : !1
  }
  var i0 = Object.prototype.hasOwnProperty;

  function Ea(e, t) {
    if (e === t) return e;
    const n = fp(e) && fp(t);
    if (!n && !(Oa(e) && Oa(t))) return t;
    const s = (n ? e : Object.keys(e)).length,
      r = n ? t : Object.keys(t),
      a = r.length,
      i = n ? new Array(a) : {};
    let l = 0;
    for (let c = 0; c < a; c++) {
      const u = n ? c : r[c],
        d = e[u],
        h = t[u];
      if (d === h) {
        i[u] = d, (n ? c < s : i0.call(e, u)) && l++;
        continue
      }
      if (d === null || h === null || typeof d != "object" || typeof h != "object") {
        i[u] = h;
        continue
      }
      const f = Ea(d, h);
      i[u] = f, f === d && l++
    }
    return s === a && l === s ? e : i
  }

  function Lr(e, t) {
    if (!t || Object.keys(e).length !== Object.keys(t).length) return !1;
    for (const n in e)
      if (e[n] !== t[n]) return !1;
    return !0
  }

  function fp(e) {
    return Array.isArray(e) && e.length === Object.keys(e).length
  }

  function Oa(e) {
    if (!pp(e)) return !1;
    const t = e.constructor;
    if (t === void 0) return !0;
    const n = t.prototype;
    return !(!pp(n) || !n.hasOwnProperty("isPrototypeOf") || Object.getPrototypeOf(e) !== Object.prototype)
  }

  function pp(e) {
    return Object.prototype.toString.call(e) === "[object Object]"
  }

  function a0(e) {
    return new Promise(t => {
      ro.setTimeout(t, e)
    })
  }

  function Ia(e, t, n) {
    if (typeof n.structuralSharing == "function") return n.structuralSharing(e, t);
    if (n.structuralSharing !== !1) {
      try {
        return Ea(e, t)
      } catch (o) {
        throw console.error(`Structural sharing requires data to be JSON serializable. To fix this, turn off structuralSharing or return JSON-serializable data from your queryFn. [${n.queryHash}]: ${o}`), o
      }
      return Ea(e, t)
    }
    return t
  }

  function l0(e, t, n = 0) {
    const o = [...e, t];
    return n && o.length > n ? o.slice(1) : o
  }

  function u0(e, t, n = 0) {
    const o = [t, ...e];
    return n && o.length > n ? o.slice(0, -1) : o
  }
  var $r = Symbol();

  function _p(e, t) {
    return e.queryFn === $r && console.error(`Attempted to invoke queryFn when set to skipToken. This is likely a configuration error. Query hash: '${e.queryHash}'`), !e.queryFn && t?.initialPromise ? () => t.initialPromise : !e.queryFn || e.queryFn === $r ? () => Promise.reject(new Error(`Missing queryFn: '${e.queryHash}'`)) : e.queryFn
  }

  function Ra(e, t) {
    return typeof e == "function" ? e(...t) : !!e
  }
  var c0 = class extends $o {
      #e;
      #t;
      #n;
      constructor() {
        super(), this.#n = e => {
          if (!io && window.addEventListener) {
            const t = () => e();
            return window.addEventListener("visibilitychange", t, !1), () => {
              window.removeEventListener("visibilitychange", t)
            }
          }
        }
      }
      onSubscribe() {
        this.#t || this.setEventListener(this.#n)
      }
      onUnsubscribe() {
        this.hasListeners() || (this.#t?.(), this.#t = void 0)
      }
      setEventListener(e) {
        this.#n = e, this.#t?.(), this.#t = e(t => {
          typeof t == "boolean" ? this.setFocused(t) : this.onFocus()
        })
      }
      setFocused(e) {
        this.#e !== e && (this.#e = e, this.onFocus())
      }
      onFocus() {
        const e = this.isFocused();
        this.listeners.forEach(t => {
          t(e)
        })
      }
      isFocused() {
        return typeof this.#e == "boolean" ? this.#e : globalThis.document?.visibilityState !== "hidden"
      }
    },
    wa = new c0;

  function Aa() {
    let e, t;
    const n = new Promise((s, r) => {
      e = s, t = r
    });
    n.status = "pending", n.catch(() => {});

    function o(s) {
      Object.assign(n, s), delete n.resolve, delete n.reject
    }
    return n.resolve = s => {
      o({
        status: "fulfilled",
        value: s
      }), e(s)
    }, n.reject = s => {
      o({
        status: "rejected",
        reason: s
      }), t(s)
    }, n
  }
  var d0 = s0;

  function f0() {
    let e = [],
      t = 0,
      n = i => {
        i()
      },
      o = i => {
        i()
      },
      s = d0;
    const r = i => {
        t ? e.push(i) : s(() => {
          n(i)
        })
      },
      a = () => {
        const i = e;
        e = [], i.length && s(() => {
          o(() => {
            i.forEach(l => {
              n(l)
            })
          })
        })
      };
    return {
      batch: i => {
        let l;
        t++;
        try {
          l = i()
        } finally {
          t--, t || a()
        }
        return l
      },
      batchCalls: i => (...l) => {
        r(() => {
          i(...l)
        })
      },
      schedule: r,
      setNotifyFunction: i => {
        n = i
      },
      setBatchNotifyFunction: i => {
        o = i
      },
      setScheduler: i => {
        s = i
      }
    }
  }
  var at = f0(),
    p0 = class extends $o {
      #e = !0;
      #t;
      #n;
      constructor() {
        super(), this.#n = e => {
          if (!io && window.addEventListener) {
            const t = () => e(!0),
              n = () => e(!1);
            return window.addEventListener("online", t, !1), window.addEventListener("offline", n, !1), () => {
              window.removeEventListener("online", t), window.removeEventListener("offline", n)
            }
          }
        }
      }
      onSubscribe() {
        this.#t || this.setEventListener(this.#n)
      }
      onUnsubscribe() {
        this.hasListeners() || (this.#t?.(), this.#t = void 0)
      }
      setEventListener(e) {
        this.#n = e, this.#t?.(), this.#t = e(this.setOnline.bind(this))
      }
      setOnline(e) {
        this.#e !== e && (this.#e = e, this.listeners.forEach(n => {
          n(e)
        }))
      }
      isOnline() {
        return this.#e
      }
    },
    xr = new p0;

  function _0(e) {
    return Math.min(1e3 * 2 ** e, 3e4)
  }

  function hp(e) {
    return (e ?? "online") === "online" ? xr.isOnline() : !0
  }
  var Na = class extends Error {
    constructor(e) {
      super("CancelledError"), this.revert = e?.revert, this.silent = e?.silent
    }
  };

  function mp(e) {
    let t = !1,
      n = 0,
      o;
    const s = Aa(),
      r = () => s.status !== "pending",
      a = p => {
        if (!r()) {
          const m = new Na(p);
          h(m), e.onCancel?.(m)
        }
      },
      i = () => {
        t = !0
      },
      l = () => {
        t = !1
      },
      c = () => wa.isFocused() && (e.networkMode === "always" || xr.isOnline()) && e.canRun(),
      u = () => hp(e.networkMode) && e.canRun(),
      d = p => {
        r() || (o?.(), s.resolve(p))
      },
      h = p => {
        r() || (o?.(), s.reject(p))
      },
      f = () => new Promise(p => {
        o = m => {
          (r() || c()) && p(m)
        }, e.onPause?.()
      }).then(() => {
        o = void 0, r() || e.onContinue?.()
      }),
      _ = () => {
        if (r()) return;
        let p;
        const m = n === 0 ? e.initialPromise : void 0;
        try {
          p = m ?? e.fn()
        } catch (v) {
          p = Promise.reject(v)
        }
        Promise.resolve(p).then(d).catch(v => {
          if (r()) return;
          const E = e.retry ?? (io ? 0 : 3),
            k = e.retryDelay ?? _0,
            N = typeof k == "function" ? k(n, v) : k,
            D = E === !0 || typeof E == "number" && n < E || typeof E == "function" && E(n, v);
          if (t || !D) {
            h(v);
            return
          }
          n++, e.onFail?.(n, v), a0(N).then(() => c() ? void 0 : f()).then(() => {
            t ? h(v) : _()
          })
        })
      };
    return {
      promise: s,
      status: () => s.status,
      cancel: a,
      continue: () => (o?.(), s),
      cancelRetry: i,
      continueRetry: l,
      canStart: u,
      start: () => (u() ? _() : f().then(_), s)
    }
  }
  var vp = class {
      #e;
      destroy() {
        this.clearGcTimeout()
      }
      scheduleGc() {
        this.clearGcTimeout(), Da(this.gcTime) && (this.#e = ro.setTimeout(() => {
          this.optionalRemove()
        }, this.gcTime))
      }
      updateGcTime(e) {
        this.gcTime = Math.max(this.gcTime || 0, e ?? (io ? 1 / 0 : 300 * 1e3))
      }
      clearGcTimeout() {
        this.#e && (ro.clearTimeout(this.#e), this.#e = void 0)
      }
    },
    h0 = {
      NODE_ENV: '"production"'
    },
    m0 = class extends vp {
      #e;
      #t;
      #n;
      #s;
      #o;
      #i;
      #a;
      constructor(e) {
        super(), this.#a = !1, this.#i = e.defaultOptions, this.setOptions(e.options), this.observers = [], this.#s = e.client, this.#n = this.#s.getQueryCache(), this.queryKey = e.queryKey, this.queryHash = e.queryHash, this.#e = yp(this.options), this.state = e.state ?? this.#e, this.scheduleGc()
      }
      get meta() {
        return this.options.meta
      }
      get promise() {
        return this.#o?.promise
      }
      setOptions(e) {
        if (this.options = {
            ...this.#i,
            ...e
          }, this.updateGcTime(this.options.gcTime), this.state && this.state.data === void 0) {
          const t = yp(this.options);
          t.data !== void 0 && (this.setData(t.data, {
            updatedAt: t.dataUpdatedAt,
            manual: !0
          }), this.#e = t)
        }
      }
      optionalRemove() {
        !this.observers.length && this.state.fetchStatus === "idle" && this.#n.remove(this)
      }
      setData(e, t) {
        const n = Ia(this.state.data, e, this.options);
        return this.#r({
          data: n,
          type: "success",
          dataUpdatedAt: t?.updatedAt,
          manual: t?.manual
        }), n
      }
      setState(e, t) {
        this.#r({
          type: "setState",
          state: e,
          setStateOptions: t
        })
      }
      cancel(e) {
        const t = this.#o?.promise;
        return this.#o?.cancel(e), t ? t.then(Ft).catch(Ft) : Promise.resolve()
      }
      destroy() {
        super.destroy(), this.cancel({
          silent: !0
        })
      }
      reset() {
        this.destroy(), this.setState(this.#e)
      }
      isActive() {
        return this.observers.some(e => Ut(e.options.enabled, this) !== !1)
      }
      isDisabled() {
        return this.getObserversCount() > 0 ? !this.isActive() : this.options.queryFn === $r || this.state.dataUpdateCount + this.state.errorUpdateCount === 0
      }
      isStatic() {
        return this.getObserversCount() > 0 ? this.observers.some(e => Bn(e.options.staleTime, this) === "static") : !1
      }
      isStale() {
        return this.getObserversCount() > 0 ? this.observers.some(e => e.getCurrentResult().isStale) : this.state.data === void 0 || this.state.isInvalidated
      }
      isStaleByTime(e = 0) {
        return this.state.data === void 0 ? !0 : e === "static" ? !1 : this.state.isInvalidated ? !0 : !up(this.state.dataUpdatedAt, e)
      }
      onFocus() {
        this.observers.find(t => t.shouldFetchOnWindowFocus())?.refetch({
          cancelRefetch: !1
        }), this.#o?.continue()
      }
      onOnline() {
        this.observers.find(t => t.shouldFetchOnReconnect())?.refetch({
          cancelRefetch: !1
        }), this.#o?.continue()
      }
      addObserver(e) {
        this.observers.includes(e) || (this.observers.push(e), this.clearGcTimeout(), this.#n.notify({
          type: "observerAdded",
          query: this,
          observer: e
        }))
      }
      removeObserver(e) {
        this.observers.includes(e) && (this.observers = this.observers.filter(t => t !== e), this.observers.length || (this.#o && (this.#a ? this.#o.cancel({
          revert: !0
        }) : this.#o.cancelRetry()), this.scheduleGc()), this.#n.notify({
          type: "observerRemoved",
          query: this,
          observer: e
        }))
      }
      getObserversCount() {
        return this.observers.length
      }
      invalidate() {
        this.state.isInvalidated || this.#r({
          type: "invalidate"
        })
      }
      async fetch(e, t) {
        if (this.state.fetchStatus !== "idle" && this.#o?.status() !== "rejected") {
          if (this.state.data !== void 0 && t?.cancelRefetch) this.cancel({
            silent: !0
          });
          else if (this.#o) return this.#o.continueRetry(), this.#o.promise
        }
        if (e && this.setOptions(e), !this.options.queryFn) {
          const i = this.observers.find(l => l.options.queryFn);
          i && this.setOptions(i.options)
        }
        Array.isArray(this.options.queryKey) || console.error("As of v4, queryKey needs to be an Array. If you are using a string like 'repoData', please change it to an Array, e.g. ['repoData']");
        const n = new AbortController,
          o = i => {
            Object.defineProperty(i, "signal", {
              enumerable: !0,
              get: () => (this.#a = !0, n.signal)
            })
          },
          s = () => {
            const i = _p(this.options, t),
              c = (() => {
                const u = {
                  client: this.#s,
                  queryKey: this.queryKey,
                  meta: this.meta
                };
                return o(u), u
              })();
            return this.#a = !1, this.options.persister ? this.options.persister(i, c, this) : i(c)
          },
          a = (() => {
            const i = {
              fetchOptions: t,
              options: this.options,
              queryKey: this.queryKey,
              client: this.#s,
              state: this.state,
              fetchFn: s
            };
            return o(i), i
          })();
        this.options.behavior?.onFetch(a, this), this.#t = this.state, (this.state.fetchStatus === "idle" || this.state.fetchMeta !== a.fetchOptions?.meta) && this.#r({
          type: "fetch",
          meta: a.fetchOptions?.meta
        }), this.#o = mp({
          initialPromise: t?.initialPromise,
          fn: a.fetchFn,
          onCancel: i => {
            i instanceof Na && i.revert && this.setState({
              ...this.#t,
              fetchStatus: "idle"
            }), n.abort()
          },
          onFail: (i, l) => {
            this.#r({
              type: "failed",
              failureCount: i,
              error: l
            })
          },
          onPause: () => {
            this.#r({
              type: "pause"
            })
          },
          onContinue: () => {
            this.#r({
              type: "continue"
            })
          },
          retry: a.options.retry,
          retryDelay: a.options.retryDelay,
          networkMode: a.options.networkMode,
          canRun: () => !0
        });
        try {
          const i = await this.#o.start();
          if (i === void 0) throw h0.NODE_ENV !== "production" && console.error(`Query data cannot be undefined. Please make sure to return a value other than undefined from your query function. Affected query key: ${this.queryHash}`), new Error(`${this.queryHash} data is undefined`);
          return this.setData(i), this.#n.config.onSuccess?.(i, this), this.#n.config.onSettled?.(i, this.state.error, this), i
        } catch (i) {
          if (i instanceof Na) {
            if (i.silent) return this.#o.promise;
            if (i.revert) {
              if (this.state.data === void 0) throw i;
              return this.state.data
            }
          }
          throw this.#r({
            type: "error",
            error: i
          }), this.#n.config.onError?.(i, this), this.#n.config.onSettled?.(this.state.data, i, this), i
        } finally {
          this.scheduleGc()
        }
      }
      #r(e) {
        const t = n => {
          switch (e.type) {
            case "failed":
              return {
                ...n, fetchFailureCount: e.failureCount, fetchFailureReason: e.error
              };
            case "pause":
              return {
                ...n, fetchStatus: "paused"
              };
            case "continue":
              return {
                ...n, fetchStatus: "fetching"
              };
            case "fetch":
              return {
                ...n, ...gp(n.data, this.options), fetchMeta: e.meta ?? null
              };
            case "success":
              const o = {
                ...n,
                data: e.data,
                dataUpdateCount: n.dataUpdateCount + 1,
                dataUpdatedAt: e.dataUpdatedAt ?? Date.now(),
                error: null,
                isInvalidated: !1,
                status: "success",
                ...!e.manual && {
                  fetchStatus: "idle",
                  fetchFailureCount: 0,
                  fetchFailureReason: null
                }
              };
              return this.#t = e.manual ? o : void 0, o;
            case "error":
              const s = e.error;
              return {
                ...n, error: s, errorUpdateCount: n.errorUpdateCount + 1, errorUpdatedAt: Date.now(), fetchFailureCount: n.fetchFailureCount + 1, fetchFailureReason: s, fetchStatus: "idle", status: "error"
              };
            case "invalidate":
              return {
                ...n, isInvalidated: !0
              };
            case "setState":
              return {
                ...n, ...e.state
              }
          }
        };
        this.state = t(this.state), at.batch(() => {
          this.observers.forEach(n => {
            n.onQueryUpdate()
          }), this.#n.notify({
            query: this,
            type: "updated",
            action: e
          })
        })
      }
    };

  function gp(e, t) {
    return {
      fetchFailureCount: 0,
      fetchFailureReason: null,
      fetchStatus: hp(t.networkMode) ? "fetching" : "paused",
      ...e === void 0 && {
        error: null,
        status: "pending"
      }
    }
  }

  function yp(e) {
    const t = typeof e.initialData == "function" ? e.initialData() : e.initialData,
      n = t !== void 0,
      o = n ? typeof e.initialDataUpdatedAt == "function" ? e.initialDataUpdatedAt() : e.initialDataUpdatedAt : 0;
    return {
      data: t,
      dataUpdateCount: 0,
      dataUpdatedAt: n ? o ?? Date.now() : 0,
      error: null,
      errorUpdateCount: 0,
      errorUpdatedAt: 0,
      fetchFailureCount: 0,
      fetchFailureReason: null,
      fetchMeta: null,
      isInvalidated: !1,
      status: n ? "success" : "pending",
      fetchStatus: "idle"
    }
  }
  var v0 = class extends $o {
    constructor(e, t) {
      super(), this.options = t, this.#e = e, this.#r = null, this.#a = Aa(), this.bindMethods(), this.setOptions(t)
    }
    #e;
    #t = void 0;
    #n = void 0;
    #s = void 0;
    #o;
    #i;
    #a;
    #r;
    #h;
    #f;
    #p;
    #u;
    #c;
    #l;
    #_ = new Set;
    bindMethods() {
      this.refetch = this.refetch.bind(this)
    }
    onSubscribe() {
      this.listeners.size === 1 && (this.#t.addObserver(this), Cp(this.#t, this.options) ? this.#d() : this.updateResult(), this.#y())
    }
    onUnsubscribe() {
      this.hasListeners() || this.destroy()
    }
    shouldFetchOnReconnect() {
      return Ma(this.#t, this.options, this.options.refetchOnReconnect)
    }
    shouldFetchOnWindowFocus() {
      return Ma(this.#t, this.options, this.options.refetchOnWindowFocus)
    }
    destroy() {
      this.listeners = new Set, this.#C(), this.#T(), this.#t.removeObserver(this)
    }
    setOptions(e) {
      const t = this.options,
        n = this.#t;
      if (this.options = this.#e.defaultQueryOptions(e), this.options.enabled !== void 0 && typeof this.options.enabled != "boolean" && typeof this.options.enabled != "function" && typeof Ut(this.options.enabled, this.#t) != "boolean") throw new Error("Expected enabled to be a boolean or a callback that returns a boolean");
      this.#b(), this.#t.setOptions(this.options), t._defaulted && !Lr(this.options, t) && this.#e.getQueryCache().notify({
        type: "observerOptionsUpdated",
        query: this.#t,
        observer: this
      });
      const o = this.hasListeners();
      o && Tp(this.#t, n, this.options, t) && this.#d(), this.updateResult(), o && (this.#t !== n || Ut(this.options.enabled, this.#t) !== Ut(t.enabled, this.#t) || Bn(this.options.staleTime, this.#t) !== Bn(t.staleTime, this.#t)) && this.#m();
      const s = this.#v();
      o && (this.#t !== n || Ut(this.options.enabled, this.#t) !== Ut(t.enabled, this.#t) || s !== this.#l) && this.#g(s)
    }
    getOptimisticResult(e) {
      const t = this.#e.getQueryCache().build(this.#e, e),
        n = this.createResult(t, e);
      return y0(this, n) && (this.#s = n, this.#i = this.options, this.#o = this.#t.state), n
    }
    getCurrentResult() {
      return this.#s
    }
    trackResult(e, t) {
      return new Proxy(e, {
        get: (n, o) => (this.trackProp(o), t?.(o), o === "promise" && !this.options.experimental_prefetchInRender && this.#a.status === "pending" && this.#a.reject(new Error("experimental_prefetchInRender feature flag is not enabled")), Reflect.get(n, o))
      })
    }
    trackProp(e) {
      this.#_.add(e)
    }
    getCurrentQuery() {
      return this.#t
    }
    refetch({
      ...e
    } = {}) {
      return this.fetch({
        ...e
      })
    }
    fetchOptimistic(e) {
      const t = this.#e.defaultQueryOptions(e),
        n = this.#e.getQueryCache().build(this.#e, t);
      return n.fetch().then(() => this.createResult(n, t))
    }
    fetch(e) {
      return this.#d({
        ...e,
        cancelRefetch: e.cancelRefetch ?? !0
      }).then(() => (this.updateResult(), this.#s))
    }
    #d(e) {
      this.#b();
      let t = this.#t.fetch(this.options, e);
      return e?.throwOnError || (t = t.catch(Ft)), t
    }
    #m() {
      this.#C();
      const e = Bn(this.options.staleTime, this.#t);
      if (io || this.#s.isStale || !Da(e)) return;
      const n = up(this.#s.dataUpdatedAt, e) + 1;
      this.#u = ro.setTimeout(() => {
        this.#s.isStale || this.updateResult()
      }, n)
    }
    #v() {
      return (typeof this.options.refetchInterval == "function" ? this.options.refetchInterval(this.#t) : this.options.refetchInterval) ?? !1
    }
    #g(e) {
      this.#T(), this.#l = e, !(io || Ut(this.options.enabled, this.#t) === !1 || !Da(this.#l) || this.#l === 0) && (this.#c = ro.setInterval(() => {
        (this.options.refetchIntervalInBackground || wa.isFocused()) && this.#d()
      }, this.#l))
    }
    #y() {
      this.#m(), this.#g(this.#v())
    }
    #C() {
      this.#u && (ro.clearTimeout(this.#u), this.#u = void 0)
    }
    #T() {
      this.#c && (ro.clearInterval(this.#c), this.#c = void 0)
    }
    createResult(e, t) {
      const n = this.#t,
        o = this.options,
        s = this.#s,
        r = this.#o,
        a = this.#i,
        l = e !== n ? e.state : this.#n,
        {
          state: c
        } = e;
      let u = {
          ...c
        },
        d = !1,
        h;
      if (t._optimisticResults) {
        const b = this.hasListeners(),
          C = !b && Cp(e, t),
          y = b && Tp(e, n, t, o);
        (C || y) && (u = {
          ...u,
          ...gp(c.data, e.options)
        }), t._optimisticResults === "isRestoring" && (u.fetchStatus = "idle")
      }
      let {
        error: f,
        errorUpdatedAt: _,
        status: p
      } = u;
      h = u.data;
      let m = !1;
      if (t.placeholderData !== void 0 && h === void 0 && p === "pending") {
        let b;
        s?.isPlaceholderData && t.placeholderData === a?.placeholderData ? (b = s.data, m = !0) : b = typeof t.placeholderData == "function" ? t.placeholderData(this.#p?.state.data, this.#p) : t.placeholderData, b !== void 0 && (p = "success", h = Ia(s?.data, b, t), d = !0)
      }
      if (t.select && h !== void 0 && !m)
        if (s && h === r?.data && t.select === this.#h) h = this.#f;
        else try {
          this.#h = t.select, h = t.select(h), h = Ia(s?.data, h, t), this.#f = h, this.#r = null
        } catch (b) {
          this.#r = b
        }
      this.#r && (f = this.#r, h = this.#f, _ = Date.now(), p = "error");
      const v = u.fetchStatus === "fetching",
        E = p === "pending",
        k = p === "error",
        N = E && v,
        D = h !== void 0,
        A = {
          status: p,
          fetchStatus: u.fetchStatus,
          isPending: E,
          isSuccess: p === "success",
          isError: k,
          isInitialLoading: N,
          isLoading: N,
          data: h,
          dataUpdatedAt: u.dataUpdatedAt,
          error: f,
          errorUpdatedAt: _,
          failureCount: u.fetchFailureCount,
          failureReason: u.fetchFailureReason,
          errorUpdateCount: u.errorUpdateCount,
          isFetched: u.dataUpdateCount > 0 || u.errorUpdateCount > 0,
          isFetchedAfterMount: u.dataUpdateCount > l.dataUpdateCount || u.errorUpdateCount > l.errorUpdateCount,
          isFetching: v,
          isRefetching: v && !E,
          isLoadingError: k && !D,
          isPaused: u.fetchStatus === "paused",
          isPlaceholderData: d,
          isRefetchError: k && D,
          isStale: ka(e, t),
          refetch: this.refetch,
          promise: this.#a,
          isEnabled: Ut(t.enabled, e) !== !1
        };
      if (this.options.experimental_prefetchInRender) {
        const b = I => {
            A.status === "error" ? I.reject(A.error) : A.data !== void 0 && I.resolve(A.data)
          },
          C = () => {
            const I = this.#a = A.promise = Aa();
            b(I)
          },
          y = this.#a;
        switch (y.status) {
          case "pending":
            e.queryHash === n.queryHash && b(y);
            break;
          case "fulfilled":
            (A.status === "error" || A.data !== y.value) && C();
            break;
          case "rejected":
            (A.status !== "error" || A.error !== y.reason) && C();
            break
        }
      }
      return A
    }
    updateResult() {
      const e = this.#s,
        t = this.createResult(this.#t, this.options);
      if (this.#o = this.#t.state, this.#i = this.options, this.#o.data !== void 0 && (this.#p = this.#t), Lr(t, e)) return;
      this.#s = t;
      const n = () => {
        if (!e) return !0;
        const {
          notifyOnChangeProps: o
        } = this.options, s = typeof o == "function" ? o() : o;
        if (s === "all" || !s && !this.#_.size) return !0;
        const r = new Set(s ?? this.#_);
        return this.options.throwOnError && r.add("error"), Object.keys(this.#s).some(a => {
          const i = a;
          return this.#s[i] !== e[i] && r.has(i)
        })
      };
      this.#S({
        listeners: n()
      })
    }
    #b() {
      const e = this.#e.getQueryCache().build(this.#e, this.options);
      if (e === this.#t) return;
      const t = this.#t;
      this.#t = e, this.#n = e.state, this.hasListeners() && (t?.removeObserver(this), e.addObserver(this))
    }
    onQueryUpdate() {
      this.updateResult(), this.hasListeners() && this.#y()
    }
    #S(e) {
      at.batch(() => {
        e.listeners && this.listeners.forEach(t => {
          t(this.#s)
        }), this.#e.getQueryCache().notify({
          query: this.#t,
          type: "observerResultsUpdated"
        })
      })
    }
  };

  function g0(e, t) {
    return Ut(t.enabled, e) !== !1 && e.state.data === void 0 && !(e.state.status === "error" && t.retryOnMount === !1)
  }

  function Cp(e, t) {
    return g0(e, t) || e.state.data !== void 0 && Ma(e, t, t.refetchOnMount)
  }

  function Ma(e, t, n) {
    if (Ut(t.enabled, e) !== !1 && Bn(t.staleTime, e) !== "static") {
      const o = typeof n == "function" ? n(e) : n;
      return o === "always" || o !== !1 && ka(e, t)
    }
    return !1
  }

  function Tp(e, t, n, o) {
    return (e !== t || Ut(o.enabled, e) === !1) && (!n.suspense || e.state.status !== "error") && ka(e, n)
  }

  function ka(e, t) {
    return Ut(t.enabled, e) !== !1 && e.isStaleByTime(Bn(t.staleTime, e))
  }

  function y0(e, t) {
    return !Lr(e.getCurrentResult(), t)
  }

  function bp(e) {
    return {
      onFetch: (t, n) => {
        const o = t.options,
          s = t.fetchOptions?.meta?.fetchMore?.direction,
          r = t.state.data?.pages || [],
          a = t.state.data?.pageParams || [];
        let i = {
            pages: [],
            pageParams: []
          },
          l = 0;
        const c = async () => {
          let u = !1;
          const d = _ => {
              Object.defineProperty(_, "signal", {
                enumerable: !0,
                get: () => (t.signal.aborted ? u = !0 : t.signal.addEventListener("abort", () => {
                  u = !0
                }), t.signal)
              })
            },
            h = _p(t.options, t.fetchOptions),
            f = async (_, p, m) => {
              if (u) return Promise.reject();
              if (p == null && _.pages.length) return Promise.resolve(_);
              const E = (() => {
                  const O = {
                    client: t.client,
                    queryKey: t.queryKey,
                    pageParam: p,
                    direction: m ? "backward" : "forward",
                    meta: t.options.meta
                  };
                  return d(O), O
                })(),
                k = await h(E),
                {
                  maxPages: N
                } = t.options,
                D = m ? u0 : l0;
              return {
                pages: D(_.pages, k, N),
                pageParams: D(_.pageParams, p, N)
              }
            };
          if (s && r.length) {
            const _ = s === "backward",
              p = _ ? C0 : Sp,
              m = {
                pages: r,
                pageParams: a
              },
              v = p(o, m);
            i = await f(m, v, _)
          } else {
            const _ = e ?? r.length;
            do {
              const p = l === 0 ? a[0] ?? o.initialPageParam : Sp(o, i);
              if (l > 0 && p == null) break;
              i = await f(i, p), l++
            } while (l < _)
          }
          return i
        };
        t.options.persister ? t.fetchFn = () => t.options.persister?.(c, {
          client: t.client,
          queryKey: t.queryKey,
          meta: t.options.meta,
          signal: t.signal
        }, n) : t.fetchFn = c
      }
    }
  }

  function Sp(e, {
    pages: t,
    pageParams: n
  }) {
    const o = t.length - 1;
    return t.length > 0 ? e.getNextPageParam(t[o], t, n[o], n) : void 0
  }

  function C0(e, {
    pages: t,
    pageParams: n
  }) {
    return t.length > 0 ? e.getPreviousPageParam?.(t[0], t, n[0], n) : void 0
  }
  var T0 = class extends vp {
    #e;
    #t;
    #n;
    #s;
    constructor(e) {
      super(), this.#e = e.client, this.mutationId = e.mutationId, this.#n = e.mutationCache, this.#t = [], this.state = e.state || Dp(), this.setOptions(e.options), this.scheduleGc()
    }
    setOptions(e) {
      this.options = e, this.updateGcTime(this.options.gcTime)
    }
    get meta() {
      return this.options.meta
    }
    addObserver(e) {
      this.#t.includes(e) || (this.#t.push(e), this.clearGcTimeout(), this.#n.notify({
        type: "observerAdded",
        mutation: this,
        observer: e
      }))
    }
    removeObserver(e) {
      this.#t = this.#t.filter(t => t !== e), this.scheduleGc(), this.#n.notify({
        type: "observerRemoved",
        mutation: this,
        observer: e
      })
    }
    optionalRemove() {
      this.#t.length || (this.state.status === "pending" ? this.scheduleGc() : this.#n.remove(this))
    }
    continue () {
      return this.#s?.continue() ?? this.execute(this.state.variables)
    }
    async execute(e) {
      const t = () => {
          this.#o({
            type: "continue"
          })
        },
        n = {
          client: this.#e,
          meta: this.options.meta,
          mutationKey: this.options.mutationKey
        };
      this.#s = mp({
        fn: () => this.options.mutationFn ? this.options.mutationFn(e, n) : Promise.reject(new Error("No mutationFn found")),
        onFail: (r, a) => {
          this.#o({
            type: "failed",
            failureCount: r,
            error: a
          })
        },
        onPause: () => {
          this.#o({
            type: "pause"
          })
        },
        onContinue: t,
        retry: this.options.retry ?? 0,
        retryDelay: this.options.retryDelay,
        networkMode: this.options.networkMode,
        canRun: () => this.#n.canRun(this)
      });
      const o = this.state.status === "pending",
        s = !this.#s.canStart();
      try {
        if (o) t();
        else {
          this.#o({
            type: "pending",
            variables: e,
            isPaused: s
          }), await this.#n.config.onMutate?.(e, this, n);
          const a = await this.options.onMutate?.(e, n);
          a !== this.state.context && this.#o({
            type: "pending",
            context: a,
            variables: e,
            isPaused: s
          })
        }
        const r = await this.#s.start();
        return await this.#n.config.onSuccess?.(r, e, this.state.context, this, n), await this.options.onSuccess?.(r, e, this.state.context, n), await this.#n.config.onSettled?.(r, null, this.state.variables, this.state.context, this, n), await this.options.onSettled?.(r, null, e, this.state.context, n), this.#o({
          type: "success",
          data: r
        }), r
      } catch (r) {
        try {
          throw await this.#n.config.onError?.(r, e, this.state.context, this, n), await this.options.onError?.(r, e, this.state.context, n), await this.#n.config.onSettled?.(void 0, r, this.state.variables, this.state.context, this, n), await this.options.onSettled?.(void 0, r, e, this.state.context, n), r
        } finally {
          this.#o({
            type: "error",
            error: r
          })
        }
      } finally {
        this.#n.runNext(this)
      }
    }
    #o(e) {
      const t = n => {
        switch (e.type) {
          case "failed":
            return {
              ...n, failureCount: e.failureCount, failureReason: e.error
            };
          case "pause":
            return {
              ...n, isPaused: !0
            };
          case "continue":
            return {
              ...n, isPaused: !1
            };
          case "pending":
            return {
              ...n, context: e.context, data: void 0, failureCount: 0, failureReason: null, error: null, isPaused: e.isPaused, status: "pending", variables: e.variables, submittedAt: Date.now()
            };
          case "success":
            return {
              ...n, data: e.data, failureCount: 0, failureReason: null, error: null, status: "success", isPaused: !1
            };
          case "error":
            return {
              ...n, data: void 0, error: e.error, failureCount: n.failureCount + 1, failureReason: e.error, isPaused: !1, status: "error"
            }
        }
      };
      this.state = t(this.state), at.batch(() => {
        this.#t.forEach(n => {
          n.onMutationUpdate(e)
        }), this.#n.notify({
          mutation: this,
          type: "updated",
          action: e
        })
      })
    }
  };

  function Dp() {
    return {
      context: void 0,
      data: void 0,
      error: null,
      failureCount: 0,
      failureReason: null,
      isPaused: !1,
      status: "idle",
      variables: void 0,
      submittedAt: 0
    }
  }
  var Pp = class extends $o {
    constructor(t = {}) {
      super(), this.config = t, this.#e = new Set, this.#t = new Map, this.#n = 0
    }
    #e;
    #t;
    #n;
    build(t, n, o) {
      const s = new T0({
        client: t,
        mutationCache: this,
        mutationId: ++this.#n,
        options: t.defaultMutationOptions(n),
        state: o
      });
      return this.add(s), s
    }
    add(t) {
      this.#e.add(t);
      const n = Fr(t);
      if (typeof n == "string") {
        const o = this.#t.get(n);
        o ? o.push(t) : this.#t.set(n, [t])
      }
      this.notify({
        type: "added",
        mutation: t
      })
    }
    remove(t) {
      if (this.#e.delete(t)) {
        const n = Fr(t);
        if (typeof n == "string") {
          const o = this.#t.get(n);
          if (o)
            if (o.length > 1) {
              const s = o.indexOf(t);
              s !== -1 && o.splice(s, 1)
            } else o[0] === t && this.#t.delete(n)
        }
      }
      this.notify({
        type: "removed",
        mutation: t
      })
    }
    canRun(t) {
      const n = Fr(t);
      if (typeof n == "string") {
        const s = this.#t.get(n)?.find(r => r.state.status === "pending");
        return !s || s === t
      } else return !0
    }
    runNext(t) {
      const n = Fr(t);
      return typeof n == "string" ? this.#t.get(n)?.find(s => s !== t && s.state.isPaused)?.continue() ?? Promise.resolve() : Promise.resolve()
    }
    clear() {
      at.batch(() => {
        this.#e.forEach(t => {
          this.notify({
            type: "removed",
            mutation: t
          })
        }), this.#e.clear(), this.#t.clear()
      })
    }
    getAll() {
      return Array.from(this.#e)
    }
    find(t) {
      const n = {
        exact: !0,
        ...t
      };
      return this.getAll().find(o => dp(n, o))
    }
    findAll(t = {}) {
      return this.getAll().filter(n => dp(t, n))
    }
    notify(t) {
      at.batch(() => {
        this.listeners.forEach(n => {
          n(t)
        })
      })
    }
    resumePausedMutations() {
      const t = this.getAll().filter(n => n.state.isPaused);
      return at.batch(() => Promise.all(t.map(n => n.continue().catch(Ft))))
    }
  };

  function Fr(e) {
    return e.options.scope?.id
  }
  var b0 = class extends $o {
      #e;
      #t = void 0;
      #n;
      #s;
      constructor(e, t) {
        super(), this.#e = e, this.setOptions(t), this.bindMethods(), this.#o()
      }
      bindMethods() {
        this.mutate = this.mutate.bind(this), this.reset = this.reset.bind(this)
      }
      setOptions(e) {
        const t = this.options;
        this.options = this.#e.defaultMutationOptions(e), Lr(this.options, t) || this.#e.getMutationCache().notify({
          type: "observerOptionsUpdated",
          mutation: this.#n,
          observer: this
        }), t?.mutationKey && this.options.mutationKey && ao(t.mutationKey) !== ao(this.options.mutationKey) ? this.reset() : this.#n?.state.status === "pending" && this.#n.setOptions(this.options)
      }
      onUnsubscribe() {
        this.hasListeners() || this.#n?.removeObserver(this)
      }
      onMutationUpdate(e) {
        this.#o(), this.#i(e)
      }
      getCurrentResult() {
        return this.#t
      }
      reset() {
        this.#n?.removeObserver(this), this.#n = void 0, this.#o(), this.#i()
      }
      mutate(e, t) {
        return this.#s = t, this.#n?.removeObserver(this), this.#n = this.#e.getMutationCache().build(this.#e, this.options), this.#n.addObserver(this), this.#n.execute(e)
      }
      #o() {
        const e = this.#n?.state ?? Dp();
        this.#t = {
          ...e,
          isPending: e.status === "pending",
          isSuccess: e.status === "success",
          isError: e.status === "error",
          isIdle: e.status === "idle",
          mutate: this.mutate,
          reset: this.reset
        }
      }
      #i(e) {
        at.batch(() => {
          if (this.#s && this.hasListeners()) {
            const t = this.#t.variables,
              n = this.#t.context,
              o = {
                client: this.#e,
                meta: this.options.meta,
                mutationKey: this.options.mutationKey
              };
            e?.type === "success" ? (this.#s.onSuccess?.(e.data, t, n, o), this.#s.onSettled?.(e.data, null, t, n, o)) : e?.type === "error" && (this.#s.onError?.(e.error, t, n, o), this.#s.onSettled?.(void 0, e.error, t, n, o))
          }
          this.listeners.forEach(t => {
            t(this.#t)
          })
        })
      }
    },
    Ep = class extends $o {
      constructor(t = {}) {
        super(), this.config = t, this.#e = new Map
      }
      #e;
      build(t, n, o) {
        const s = n.queryKey,
          r = n.queryHash ?? Pa(s, n);
        let a = this.get(r);
        return a || (a = new m0({
          client: t,
          queryKey: s,
          queryHash: r,
          options: t.defaultQueryOptions(n),
          state: o,
          defaultOptions: t.getQueryDefaults(s)
        }), this.add(a)), a
      }
      add(t) {
        this.#e.has(t.queryHash) || (this.#e.set(t.queryHash, t), this.notify({
          type: "added",
          query: t
        }))
      }
      remove(t) {
        const n = this.#e.get(t.queryHash);
        n && (t.destroy(), n === t && this.#e.delete(t.queryHash), this.notify({
          type: "removed",
          query: t
        }))
      }
      clear() {
        at.batch(() => {
          this.getAll().forEach(t => {
            this.remove(t)
          })
        })
      }
      get(t) {
        return this.#e.get(t)
      }
      getAll() {
        return [...this.#e.values()]
      }
      find(t) {
        const n = {
          exact: !0,
          ...t
        };
        return this.getAll().find(o => cp(n, o))
      }
      findAll(t = {}) {
        const n = this.getAll();
        return Object.keys(t).length > 0 ? n.filter(o => cp(t, o)) : n
      }
      notify(t) {
        at.batch(() => {
          this.listeners.forEach(n => {
            n(t)
          })
        })
      }
      onFocus() {
        at.batch(() => {
          this.getAll().forEach(t => {
            t.onFocus()
          })
        })
      }
      onOnline() {
        at.batch(() => {
          this.getAll().forEach(t => {
            t.onOnline()
          })
        })
      }
    },
    S0 = class {
      #e;
      #t;
      #n;
      #s;
      #o;
      #i;
      #a;
      #r;
      constructor(t = {}) {
        this.#e = t.queryCache || new Ep, this.#t = t.mutationCache || new Pp, this.#n = t.defaultOptions || {}, this.#s = new Map, this.#o = new Map, this.#i = 0
      }
      mount() {
        this.#i++, this.#i === 1 && (this.#a = wa.subscribe(async t => {
          t && (await this.resumePausedMutations(), this.#e.onFocus())
        }), this.#r = xr.subscribe(async t => {
          t && (await this.resumePausedMutations(), this.#e.onOnline())
        }))
      }
      unmount() {
        this.#i--, this.#i === 0 && (this.#a?.(), this.#a = void 0, this.#r?.(), this.#r = void 0)
      }
      isFetching(t) {
        return this.#e.findAll({
          ...t,
          fetchStatus: "fetching"
        }).length
      }
      isMutating(t) {
        return this.#t.findAll({
          ...t,
          status: "pending"
        }).length
      }
      getQueryData(t) {
        const n = this.defaultQueryOptions({
          queryKey: t
        });
        return this.#e.get(n.queryHash)?.state.data
      }
      ensureQueryData(t) {
        const n = this.defaultQueryOptions(t),
          o = this.#e.build(this, n),
          s = o.state.data;
        return s === void 0 ? this.fetchQuery(t) : (t.revalidateIfStale && o.isStaleByTime(Bn(n.staleTime, o)) && this.prefetchQuery(n), Promise.resolve(s))
      }
      getQueriesData(t) {
        return this.#e.findAll(t).map(({
          queryKey: n,
          state: o
        }) => {
          const s = o.data;
          return [n, s]
        })
      }
      setQueryData(t, n, o) {
        const s = this.defaultQueryOptions({
            queryKey: t
          }),
          a = this.#e.get(s.queryHash)?.state.data,
          i = r0(n, a);
        if (i !== void 0) return this.#e.build(this, s).setData(i, {
          ...o,
          manual: !0
        })
      }
      setQueriesData(t, n, o) {
        return at.batch(() => this.#e.findAll(t).map(({
          queryKey: s
        }) => [s, this.setQueryData(s, n, o)]))
      }
      getQueryState(t) {
        const n = this.defaultQueryOptions({
          queryKey: t
        });
        return this.#e.get(n.queryHash)?.state
      }
      removeQueries(t) {
        const n = this.#e;
        at.batch(() => {
          n.findAll(t).forEach(o => {
            n.remove(o)
          })
        })
      }
      resetQueries(t, n) {
        const o = this.#e;
        return at.batch(() => (o.findAll(t).forEach(s => {
          s.reset()
        }), this.refetchQueries({
          type: "active",
          ...t
        }, n)))
      }
      cancelQueries(t, n = {}) {
        const o = {
            revert: !0,
            ...n
          },
          s = at.batch(() => this.#e.findAll(t).map(r => r.cancel(o)));
        return Promise.all(s).then(Ft).catch(Ft)
      }
      invalidateQueries(t, n = {}) {
        return at.batch(() => (this.#e.findAll(t).forEach(o => {
          o.invalidate()
        }), t?.refetchType === "none" ? Promise.resolve() : this.refetchQueries({
          ...t,
          type: t?.refetchType ?? t?.type ?? "active"
        }, n)))
      }
      refetchQueries(t, n = {}) {
        const o = {
            ...n,
            cancelRefetch: n.cancelRefetch ?? !0
          },
          s = at.batch(() => this.#e.findAll(t).filter(r => !r.isDisabled() && !r.isStatic()).map(r => {
            let a = r.fetch(void 0, o);
            return o.throwOnError || (a = a.catch(Ft)), r.state.fetchStatus === "paused" ? Promise.resolve() : a
          }));
        return Promise.all(s).then(Ft)
      }
      fetchQuery(t) {
        const n = this.defaultQueryOptions(t);
        n.retry === void 0 && (n.retry = !1);
        const o = this.#e.build(this, n);
        return o.isStaleByTime(Bn(n.staleTime, o)) ? o.fetch(n) : Promise.resolve(o.state.data)
      }
      prefetchQuery(t) {
        return this.fetchQuery(t).then(Ft).catch(Ft)
      }
      fetchInfiniteQuery(t) {
        return t.behavior = bp(t.pages), this.fetchQuery(t)
      }
      prefetchInfiniteQuery(t) {
        return this.fetchInfiniteQuery(t).then(Ft).catch(Ft)
      }
      ensureInfiniteQueryData(t) {
        return t.behavior = bp(t.pages), this.ensureQueryData(t)
      }
      resumePausedMutations() {
        return xr.isOnline() ? this.#t.resumePausedMutations() : Promise.resolve()
      }
      getQueryCache() {
        return this.#e
      }
      getMutationCache() {
        return this.#t
      }
      getDefaultOptions() {
        return this.#n
      }
      setDefaultOptions(t) {
        this.#n = t
      }
      setQueryDefaults(t, n) {
        this.#s.set(ao(t), {
          queryKey: t,
          defaultOptions: n
        })
      }
      getQueryDefaults(t) {
        const n = [...this.#s.values()],
          o = {};
        return n.forEach(s => {
          Ss(t, s.queryKey) && Object.assign(o, s.defaultOptions)
        }), o
      }
      setMutationDefaults(t, n) {
        this.#o.set(ao(t), {
          mutationKey: t,
          defaultOptions: n
        })
      }
      getMutationDefaults(t) {
        const n = [...this.#o.values()],
          o = {};
        return n.forEach(s => {
          Ss(t, s.mutationKey) && Object.assign(o, s.defaultOptions)
        }), o
      }
      defaultQueryOptions(t) {
        if (t._defaulted) return t;
        const n = {
          ...this.#n.queries,
          ...this.getQueryDefaults(t.queryKey),
          ...t,
          _defaulted: !0
        };
        return n.queryHash || (n.queryHash = Pa(n.queryKey, n)), n.refetchOnReconnect === void 0 && (n.refetchOnReconnect = n.networkMode !== "always"), n.throwOnError === void 0 && (n.throwOnError = !!n.suspense), !n.networkMode && n.persister && (n.networkMode = "offlineFirst"), n.queryFn === $r && (n.enabled = !1), n
      }
      defaultMutationOptions(t) {
        return t?._defaulted ? t : {
          ...this.#n.mutations,
          ...t?.mutationKey && this.getMutationDefaults(t.mutationKey),
          ...t,
          _defaulted: !0
        }
      }
      clear() {
        this.#e.clear(), this.#t.clear()
      }
    },
    D0 = "VUE_QUERY_CLIENT";

  function Op(e) {
    const t = e ? `:${e}` : "";
    return `${D0}${t}`
  }

  function La(e, t) {
    Object.keys(e).forEach(n => {
      e[n] = t[n]
    })
  }

  function $a(e, t, n = "", o = 0) {
    if (t) {
      const s = t(e, n, o);
      if (s === void 0 && Fe(e) || s !== void 0) return s
    }
    if (Array.isArray(e)) return e.map((s, r) => $a(s, t, String(r), o + 1));
    if (typeof e == "object" && E0(e)) {
      const s = Object.entries(e).map(([r, a]) => [r, $a(a, t, r, o + 1)]);
      return Object.fromEntries(s)
    }
    return e
  }

  function P0(e, t) {
    return $a(e, t)
  }

  function Pe(e, t = !1) {
    return P0(e, (n, o, s) => {
      if (s === 1 && o === "queryKey") return Pe(n, !0);
      if (t && O0(n)) return Pe(n(), t);
      if (Fe(n)) return Pe(T(n), t)
    })
  }

  function E0(e) {
    if (Object.prototype.toString.call(e) !== "[object Object]") return !1;
    const t = Object.getPrototypeOf(e);
    return t === null || t === Object.prototype
  }

  function O0(e) {
    return typeof e == "function"
  }

  function Ip(e = "") {
    if (!dc()) throw new Error("vue-query hooks can only be used inside setup() function or functions that support injection context.");
    const t = Op(e),
      n = le(t);
    if (!n) throw new Error("No 'queryClient' found in Vue context, use 'VueQueryPlugin' to properly initialize the library.");
    return n
  }
  var I0 = class extends Ep {
      find(e) {
        return super.find(Pe(e))
      }
      findAll(e = {}) {
        return super.findAll(Pe(e))
      }
    },
    R0 = class extends Pp {
      find(e) {
        return super.find(Pe(e))
      }
      findAll(e = {}) {
        return super.findAll(Pe(e))
      }
    },
    w0 = class extends S0 {
      constructor(e = {}) {
        const t = {
          defaultOptions: e.defaultOptions,
          queryCache: e.queryCache || new I0,
          mutationCache: e.mutationCache || new R0
        };
        super(t), this.isRestoring = H(!1)
      }
      isFetching(e = {}) {
        return super.isFetching(Pe(e))
      }
      isMutating(e = {}) {
        return super.isMutating(Pe(e))
      }
      getQueryData(e) {
        return super.getQueryData(Pe(e))
      }
      ensureQueryData(e) {
        return super.ensureQueryData(Pe(e))
      }
      getQueriesData(e) {
        return super.getQueriesData(Pe(e))
      }
      setQueryData(e, t, n = {}) {
        return super.setQueryData(Pe(e), t, Pe(n))
      }
      setQueriesData(e, t, n = {}) {
        return super.setQueriesData(Pe(e), t, Pe(n))
      }
      getQueryState(e) {
        return super.getQueryState(Pe(e))
      }
      removeQueries(e = {}) {
        return super.removeQueries(Pe(e))
      }
      resetQueries(e = {}, t = {}) {
        return super.resetQueries(Pe(e), Pe(t))
      }
      cancelQueries(e = {}, t = {}) {
        return super.cancelQueries(Pe(e), Pe(t))
      }
      invalidateQueries(e = {}, t = {}) {
        const n = Pe(e),
          o = Pe(t);
        if (super.invalidateQueries({
            ...n,
            refetchType: "none"
          }, o), n.refetchType === "none") return Promise.resolve();
        const s = {
          ...n,
          type: n.refetchType ?? n.type ?? "active"
        };
        return Xo().then(() => super.refetchQueries(s, o))
      }
      refetchQueries(e = {}, t = {}) {
        return super.refetchQueries(Pe(e), Pe(t))
      }
      fetchQuery(e) {
        return super.fetchQuery(Pe(e))
      }
      prefetchQuery(e) {
        return super.prefetchQuery(Pe(e))
      }
      fetchInfiniteQuery(e) {
        return super.fetchInfiniteQuery(Pe(e))
      }
      prefetchInfiniteQuery(e) {
        return super.prefetchInfiniteQuery(Pe(e))
      }
      setDefaultOptions(e) {
        super.setDefaultOptions(Pe(e))
      }
      setQueryDefaults(e, t) {
        super.setQueryDefaults(Pe(e), Pe(t))
      }
      getQueryDefaults(e) {
        return super.getQueryDefaults(Pe(e))
      }
      setMutationDefaults(e, t) {
        super.setMutationDefaults(Pe(e), Pe(t))
      }
      getMutationDefaults(e) {
        return super.getMutationDefaults(Pe(e))
      }
    },
    A0 = {
      install: (e, t = {}) => {
        const n = Op(t.queryClientKey);
        let o;
        if ("queryClient" in t && t.queryClient) o = t.queryClient;
        else {
          const a = "queryClientConfig" in t ? t.queryClientConfig : void 0;
          o = new w0(a)
        }
        io || o.mount();
        let s = () => {};
        if (t.clientPersister) {
          o.isRestoring && (o.isRestoring.value = !0);
          const [a, i] = t.clientPersister(o);
          s = a, i.then(() => {
            o.isRestoring && (o.isRestoring.value = !1), t.clientPersisterOnSuccess?.(o)
          })
        }
        const r = () => {
          o.unmount(), s()
        };
        if (e.onUnmount) e.onUnmount(r);
        else {
          const a = e.unmount;
          e.unmount = function() {
            r(), a()
          }
        }
        e.provide(n, o)
      }
    };

  function N0(e, t, n) {
    const o = Ip(),
      s = R(() => {
        const f = Pe(t);
        typeof f.enabled == "function" && (f.enabled = f.enabled());
        const _ = o.defaultQueryOptions(f);
        return _._optimisticResults = o.isRestoring?.value ? "isRestoring" : "optimistic", _
      }),
      r = new e(o, s.value),
      a = s.value.shallow ? hi(r.getCurrentResult()) : xe(r.getCurrentResult());
    let i = () => {};
    o.isRestoring && F(o.isRestoring, f => {
      f || (i(), i = r.subscribe(_ => {
        La(a, _)
      }))
    }, {
      immediate: !0
    });
    const l = () => {
      r.setOptions(s.value), La(a, r.getCurrentResult())
    };
    F(s, l), si(() => {
      i()
    });
    const c = (...f) => (l(), a.refetch(...f)),
      u = () => new Promise((f, _) => {
        let p = () => {};
        const m = () => {
          if (s.value.enabled !== !1) {
            r.setOptions(s.value);
            const v = r.getOptimisticResult(s.value);
            v.isStale ? (p(), r.fetchOptimistic(s.value).then(f, E => {
              Ra(s.value.throwOnError, [E, r.getCurrentQuery()]) ? _(E) : f(r.getCurrentResult())
            })) : (p(), f(v))
          }
        };
        m(), p = F(s, m)
      });
    F(() => a.error, f => {
      if (a.isError && !a.isFetching && Ra(s.value.throwOnError, [f, r.getCurrentQuery()])) throw f
    });
    const d = s.value.shallow ? Lt(a) : Ks(a),
      h = Qs(d);
    for (const f in a) typeof a[f] == "function" && (h[f] = a[f]);
    return h.suspense = u, h.refetch = c, h
  }

  function Rp(e, t) {
    return N0(v0, e)
  }

  function wp(e, t) {
    const n = Ip(),
      o = R(() => n.defaultMutationOptions(Pe(e))),
      s = new b0(n, o.value),
      r = o.value.shallow ? hi(s.getCurrentResult()) : xe(s.getCurrentResult()),
      a = s.subscribe(u => {
        La(r, u)
      }),
      i = (u, d) => {
        s.mutate(u, d).catch(() => {})
      };
    F(o, () => {
      s.setOptions(o.value)
    }), si(() => {
      a()
    });
    const l = o.value.shallow ? Lt(r) : Ks(r),
      c = Qs(l);
    return F(() => r.error, u => {
      if (u && Ra(o.value.throwOnError, [u])) throw u
    }), {
      ...c,
      mutate: i,
      mutateAsync: r.mutate,
      reset: r.reset
    }
  } /*! @license DOMPurify 3.2.6 | (c) Cure53 and other contributors | Released under the Apache license 2.0 and Mozilla Public License 2.0 | github.com/cure53/DOMPurify/blob/3.2.6/LICENSE */
  const {
    entries: Ap,
    setPrototypeOf: Np,
    isFrozen: M0,
    getPrototypeOf: k0,
    getOwnPropertyDescriptor: L0
  } = Object;
  let {
    freeze: Tt,
    seal: Bt,
    create: Mp
  } = Object, {
    apply: xa,
    construct: Fa
  } = typeof Reflect < "u" && Reflect;
  Tt || (Tt = function(t) {
    return t
  }), Bt || (Bt = function(t) {
    return t
  }), xa || (xa = function(t, n, o) {
    return t.apply(n, o)
  }), Fa || (Fa = function(t, n) {
    return new t(...n)
  });
  const Ur = St(Array.prototype.forEach),
    $0 = St(Array.prototype.lastIndexOf),
    kp = St(Array.prototype.pop),
    Ds = St(Array.prototype.push),
    x0 = St(Array.prototype.splice),
    Br = St(String.prototype.toLowerCase),
    Ua = St(String.prototype.toString),
    Lp = St(String.prototype.match),
    Ps = St(String.prototype.replace),
    F0 = St(String.prototype.indexOf),
    U0 = St(String.prototype.trim),
    qt = St(Object.prototype.hasOwnProperty),
    bt = St(RegExp.prototype.test),
    Es = B0(TypeError);

  function St(e) {
    return function(t) {
      t instanceof RegExp && (t.lastIndex = 0);
      for (var n = arguments.length, o = new Array(n > 1 ? n - 1 : 0), s = 1; s < n; s++) o[s - 1] = arguments[s];
      return xa(e, t, o)
    }
  }

  function B0(e) {
    return function() {
      for (var t = arguments.length, n = new Array(t), o = 0; o < t; o++) n[o] = arguments[o];
      return Fa(e, n)
    }
  }

  function Ee(e, t) {
    let n = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : Br;
    Np && Np(e, null);
    let o = t.length;
    for (; o--;) {
      let s = t[o];
      if (typeof s == "string") {
        const r = n(s);
        r !== s && (M0(t) || (t[o] = r), s = r)
      }
      e[s] = !0
    }
    return e
  }

  function V0(e) {
    for (let t = 0; t < e.length; t++) qt(e, t) || (e[t] = null);
    return e
  }

  function Tn(e) {
    const t = Mp(null);
    for (const [n, o] of Ap(e)) qt(e, n) && (Array.isArray(o) ? t[n] = V0(o) : o && typeof o == "object" && o.constructor === Object ? t[n] = Tn(o) : t[n] = o);
    return t
  }

  function Os(e, t) {
    for (; e !== null;) {
      const o = L0(e, t);
      if (o) {
        if (o.get) return St(o.get);
        if (typeof o.value == "function") return St(o.value)
      }
      e = k0(e)
    }

    function n() {
      return null
    }
    return n
  }
  const $p = Tt(["a", "abbr", "acronym", "address", "area", "article", "aside", "audio", "b", "bdi", "bdo", "big", "blink", "blockquote", "body", "br", "button", "canvas", "caption", "center", "cite", "code", "col", "colgroup", "content", "data", "datalist", "dd", "decorator", "del", "details", "dfn", "dialog", "dir", "div", "dl", "dt", "element", "em", "fieldset", "figcaption", "figure", "font", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html", "i", "img", "input", "ins", "kbd", "label", "legend", "li", "main", "map", "mark", "marquee", "menu", "menuitem", "meter", "nav", "nobr", "ol", "optgroup", "option", "output", "p", "picture", "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "section", "select", "shadow", "small", "source", "spacer", "span", "strike", "strong", "style", "sub", "summary", "sup", "table", "tbody", "td", "template", "textarea", "tfoot", "th", "thead", "time", "tr", "track", "tt", "u", "ul", "var", "video", "wbr"]),
    Ba = Tt(["svg", "a", "altglyph", "altglyphdef", "altglyphitem", "animatecolor", "animatemotion", "animatetransform", "circle", "clippath", "defs", "desc", "ellipse", "filter", "font", "g", "glyph", "glyphref", "hkern", "image", "line", "lineargradient", "marker", "mask", "metadata", "mpath", "path", "pattern", "polygon", "polyline", "radialgradient", "rect", "stop", "style", "switch", "symbol", "text", "textpath", "title", "tref", "tspan", "view", "vkern"]),
    Va = Tt(["feBlend", "feColorMatrix", "feComponentTransfer", "feComposite", "feConvolveMatrix", "feDiffuseLighting", "feDisplacementMap", "feDistantLight", "feDropShadow", "feFlood", "feFuncA", "feFuncB", "feFuncG", "feFuncR", "feGaussianBlur", "feImage", "feMerge", "feMergeNode", "feMorphology", "feOffset", "fePointLight", "feSpecularLighting", "feSpotLight", "feTile", "feTurbulence"]),
    H0 = Tt(["animate", "color-profile", "cursor", "discard", "font-face", "font-face-format", "font-face-name", "font-face-src", "font-face-uri", "foreignobject", "hatch", "hatchpath", "mesh", "meshgradient", "meshpatch", "meshrow", "missing-glyph", "script", "set", "solidcolor", "unknown", "use"]),
    Ha = Tt(["math", "menclose", "merror", "mfenced", "mfrac", "mglyph", "mi", "mlabeledtr", "mmultiscripts", "mn", "mo", "mover", "mpadded", "mphantom", "mroot", "mrow", "ms", "mspace", "msqrt", "mstyle", "msub", "msup", "msubsup", "mtable", "mtd", "mtext", "mtr", "munder", "munderover", "mprescripts"]),
    G0 = Tt(["maction", "maligngroup", "malignmark", "mlongdiv", "mscarries", "mscarry", "msgroup", "mstack", "msline", "msrow", "semantics", "annotation", "annotation-xml", "mprescripts", "none"]),
    xp = Tt(["#text"]),
    Fp = Tt(["accept", "action", "align", "alt", "autocapitalize", "autocomplete", "autopictureinpicture", "autoplay", "background", "bgcolor", "border", "capture", "cellpadding", "cellspacing", "checked", "cite", "class", "clear", "color", "cols", "colspan", "controls", "controlslist", "coords", "crossorigin", "datetime", "decoding", "default", "dir", "disabled", "disablepictureinpicture", "disableremoteplayback", "download", "draggable", "enctype", "enterkeyhint", "face", "for", "headers", "height", "hidden", "high", "href", "hreflang", "id", "inputmode", "integrity", "ismap", "kind", "label", "lang", "list", "loading", "loop", "low", "max", "maxlength", "media", "method", "min", "minlength", "multiple", "muted", "name", "nonce", "noshade", "novalidate", "nowrap", "open", "optimum", "pattern", "placeholder", "playsinline", "popover", "popovertarget", "popovertargetaction", "poster", "preload", "pubdate", "radiogroup", "readonly", "rel", "required", "rev", "reversed", "role", "rows", "rowspan", "spellcheck", "scope", "selected", "shape", "size", "sizes", "span", "srclang", "start", "src", "srcset", "step", "style", "summary", "tabindex", "title", "translate", "type", "usemap", "valign", "value", "width", "wrap", "xmlns", "slot"]),
    Ga = Tt(["accent-height", "accumulate", "additive", "alignment-baseline", "amplitude", "ascent", "attributename", "attributetype", "azimuth", "basefrequency", "baseline-shift", "begin", "bias", "by", "class", "clip", "clippathunits", "clip-path", "clip-rule", "color", "color-interpolation", "color-interpolation-filters", "color-profile", "color-rendering", "cx", "cy", "d", "dx", "dy", "diffuseconstant", "direction", "display", "divisor", "dur", "edgemode", "elevation", "end", "exponent", "fill", "fill-opacity", "fill-rule", "filter", "filterunits", "flood-color", "flood-opacity", "font-family", "font-size", "font-size-adjust", "font-stretch", "font-style", "font-variant", "font-weight", "fx", "fy", "g1", "g2", "glyph-name", "glyphref", "gradientunits", "gradienttransform", "height", "href", "id", "image-rendering", "in", "in2", "intercept", "k", "k1", "k2", "k3", "k4", "kerning", "keypoints", "keysplines", "keytimes", "lang", "lengthadjust", "letter-spacing", "kernelmatrix", "kernelunitlength", "lighting-color", "local", "marker-end", "marker-mid", "marker-start", "markerheight", "markerunits", "markerwidth", "maskcontentunits", "maskunits", "max", "mask", "media", "method", "mode", "min", "name", "numoctaves", "offset", "operator", "opacity", "order", "orient", "orientation", "origin", "overflow", "paint-order", "path", "pathlength", "patterncontentunits", "patterntransform", "patternunits", "points", "preservealpha", "preserveaspectratio", "primitiveunits", "r", "rx", "ry", "radius", "refx", "refy", "repeatcount", "repeatdur", "restart", "result", "rotate", "scale", "seed", "shape-rendering", "slope", "specularconstant", "specularexponent", "spreadmethod", "startoffset", "stddeviation", "stitchtiles", "stop-color", "stop-opacity", "stroke-dasharray", "stroke-dashoffset", "stroke-linecap", "stroke-linejoin", "stroke-miterlimit", "stroke-opacity", "stroke", "stroke-width", "style", "surfacescale", "systemlanguage", "tabindex", "tablevalues", "targetx", "targety", "transform", "transform-origin", "text-anchor", "text-decoration", "text-rendering", "textlength", "type", "u1", "u2", "unicode", "values", "viewbox", "visibility", "version", "vert-adv-y", "vert-origin-x", "vert-origin-y", "width", "word-spacing", "wrap", "writing-mode", "xchannelselector", "ychannelselector", "x", "x1", "x2", "xmlns", "y", "y1", "y2", "z", "zoomandpan"]),
    Up = Tt(["accent", "accentunder", "align", "bevelled", "close", "columnsalign", "columnlines", "columnspan", "denomalign", "depth", "dir", "display", "displaystyle", "encoding", "fence", "frame", "height", "href", "id", "largeop", "length", "linethickness", "lspace", "lquote", "mathbackground", "mathcolor", "mathsize", "mathvariant", "maxsize", "minsize", "movablelimits", "notation", "numalign", "open", "rowalign", "rowlines", "rowspacing", "rowspan", "rspace", "rquote", "scriptlevel", "scriptminsize", "scriptsizemultiplier", "selection", "separator", "separators", "stretchy", "subscriptshift", "supscriptshift", "symmetric", "voffset", "width", "xmlns"]),
    Vr = Tt(["xlink:href", "xml:id", "xlink:title", "xml:space", "xmlns:xlink"]),
    j0 = Bt(/\{\{[\w\W]*|[\w\W]*\}\}/gm),
    z0 = Bt(/<%[\w\W]*|[\w\W]*%>/gm),
    Y0 = Bt(/\$\{[\w\W]*/gm),
    K0 = Bt(/^data-[\-\w.\u00B7-\uFFFF]+$/),
    W0 = Bt(/^aria-[\-\w]+$/),
    Bp = Bt(/^(?:(?:(?:f|ht)tps?|mailto|tel|callto|sms|cid|xmpp|matrix):|[^a-z]|[a-z+.\-]+(?:[^a-z+.\-:]|$))/i),
    q0 = Bt(/^(?:\w+script|data):/i),
    Q0 = Bt(/[\u0000-\u0020\u00A0\u1680\u180E\u2000-\u2029\u205F\u3000]/g),
    Vp = Bt(/^html$/i),
    X0 = Bt(/^[a-z][.\w]*(-[.\w]+)+$/i);
  var Hp = Object.freeze({
    __proto__: null,
    ARIA_ATTR: W0,
    ATTR_WHITESPACE: Q0,
    CUSTOM_ELEMENT: X0,
    DATA_ATTR: K0,
    DOCTYPE_NAME: Vp,
    ERB_EXPR: z0,
    IS_ALLOWED_URI: Bp,
    IS_SCRIPT_OR_DATA: q0,
    MUSTACHE_EXPR: j0,
    TMPLIT_EXPR: Y0
  });
  const Is = {
      element: 1,
      text: 3,
      progressingInstruction: 7,
      comment: 8,
      document: 9
    },
    J0 = function() {
      return typeof window > "u" ? null : window
    },
    Z0 = function(t, n) {
      if (typeof t != "object" || typeof t.createPolicy != "function") return null;
      let o = null;
      const s = "data-tt-policy-suffix";
      n && n.hasAttribute(s) && (o = n.getAttribute(s));
      const r = "dompurify" + (o ? "#" + o : "");
      try {
        return t.createPolicy(r, {
          createHTML(a) {
            return a
          },
          createScriptURL(a) {
            return a
          }
        })
      } catch {
        return console.warn("TrustedTypes policy " + r + " could not be created."), null
      }
    },
    Gp = function() {
      return {
        afterSanitizeAttributes: [],
        afterSanitizeElements: [],
        afterSanitizeShadowDOM: [],
        beforeSanitizeAttributes: [],
        beforeSanitizeElements: [],
        beforeSanitizeShadowDOM: [],
        uponSanitizeAttribute: [],
        uponSanitizeElement: [],
        uponSanitizeShadowNode: []
      }
    };

  function jp() {
    let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : J0();
    const t = Ce => jp(Ce);
    if (t.version = "3.2.6", t.removed = [], !e || !e.document || e.document.nodeType !== Is.document || !e.Element) return t.isSupported = !1, t;
    let {
      document: n
    } = e;
    const o = n,
      s = o.currentScript,
      {
        DocumentFragment: r,
        HTMLTemplateElement: a,
        Node: i,
        Element: l,
        NodeFilter: c,
        NamedNodeMap: u = e.NamedNodeMap || e.MozNamedAttrMap,
        HTMLFormElement: d,
        DOMParser: h,
        trustedTypes: f
      } = e,
      _ = l.prototype,
      p = Os(_, "cloneNode"),
      m = Os(_, "remove"),
      v = Os(_, "nextSibling"),
      E = Os(_, "childNodes"),
      k = Os(_, "parentNode");
    if (typeof a == "function") {
      const Ce = n.createElement("template");
      Ce.content && Ce.content.ownerDocument && (n = Ce.content.ownerDocument)
    }
    let N, D = "";
    const {
      implementation: O,
      createNodeIterator: A,
      createDocumentFragment: b,
      getElementsByTagName: C
    } = n, {
      importNode: y
    } = o;
    let I = Gp();
    t.isSupported = typeof Ap == "function" && typeof k == "function" && O && O.createHTMLDocument !== void 0;
    const {
      MUSTACHE_EXPR: w,
      ERB_EXPR: U,
      TMPLIT_EXPR: Z,
      DATA_ATTR: me,
      ARIA_ATTR: _e,
      IS_SCRIPT_OR_DATA: B,
      ATTR_WHITESPACE: W,
      CUSTOM_ELEMENT: ue
    } = Hp;
    let {
      IS_ALLOWED_URI: lt
    } = Hp, Oe = null;
    const Ke = Ee({}, [...$p, ...Ba, ...Va, ...Ha, ...xp]);
    let Ie = null;
    const Pn = Ee({}, [...Fp, ...Ga, ...Up, ...Vr]);
    let He = Object.seal(Mp(null, {
        tagNameCheck: {
          writable: !0,
          configurable: !1,
          enumerable: !0,
          value: null
        },
        attributeNameCheck: {
          writable: !0,
          configurable: !1,
          enumerable: !0,
          value: null
        },
        allowCustomizedBuiltInElements: {
          writable: !0,
          configurable: !1,
          enumerable: !0,
          value: !1
        }
      })),
      lo = null,
      En = null,
      uo = !0,
      co = !0,
      Ls = !1,
      Vn = !0,
      fo = !1,
      P = !0,
      L = !1,
      G = !1,
      Q = !1,
      z = !1,
      Y = !1,
      ie = !1,
      se = !0,
      ee = !1;
    const X = "user-content-";
    let Te = !0,
      ae = !1,
      ve = {},
      Se = null;
    const Re = Ee({}, ["annotation-xml", "audio", "colgroup", "desc", "foreignobject", "head", "iframe", "math", "mi", "mn", "mo", "ms", "mtext", "noembed", "noframes", "noscript", "plaintext", "script", "style", "svg", "template", "thead", "title", "video", "xmp"]);
    let Ue = null;
    const ke = Ee({}, ["audio", "video", "img", "source", "image", "track"]);
    let st = null;
    const ut = Ee({}, ["alt", "class", "for", "id", "label", "name", "pattern", "placeholder", "role", "summary", "title", "value", "style", "xmlns"]),
      Pt = "http://www.w3.org/1998/Math/MathML",
      Et = "http://www.w3.org/2000/svg",
      Ot = "http://www.w3.org/1999/xhtml";
    let On = Ot,
      et = !1,
      Rt = null;
    const Qr = Ee({}, [Pt, Et, Ot], Ua);
    let po = Ee({}, ["mi", "mo", "mn", "ms", "mtext"]),
      Xr = Ee({}, ["annotation-xml"]);
    const SI = Ee({}, ["title", "style", "font", "a", "script"]);
    let $s = null;
    const DI = ["application/xhtml+xml", "text/html"],
      PI = "text/html";
    let rt = null,
      Uo = null;
    const EI = n.createElement("form"),
      uh = function($) {
        return $ instanceof RegExp || $ instanceof Function
      },
      Zl = function() {
        let $ = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
        if (!(Uo && Uo === $)) {
          if ((!$ || typeof $ != "object") && ($ = {}), $ = Tn($), $s = DI.indexOf($.PARSER_MEDIA_TYPE) === -1 ? PI : $.PARSER_MEDIA_TYPE, rt = $s === "application/xhtml+xml" ? Ua : Br, Oe = qt($, "ALLOWED_TAGS") ? Ee({}, $.ALLOWED_TAGS, rt) : Ke, Ie = qt($, "ALLOWED_ATTR") ? Ee({}, $.ALLOWED_ATTR, rt) : Pn, Rt = qt($, "ALLOWED_NAMESPACES") ? Ee({}, $.ALLOWED_NAMESPACES, Ua) : Qr, st = qt($, "ADD_URI_SAFE_ATTR") ? Ee(Tn(ut), $.ADD_URI_SAFE_ATTR, rt) : ut, Ue = qt($, "ADD_DATA_URI_TAGS") ? Ee(Tn(ke), $.ADD_DATA_URI_TAGS, rt) : ke, Se = qt($, "FORBID_CONTENTS") ? Ee({}, $.FORBID_CONTENTS, rt) : Re, lo = qt($, "FORBID_TAGS") ? Ee({}, $.FORBID_TAGS, rt) : Tn({}), En = qt($, "FORBID_ATTR") ? Ee({}, $.FORBID_ATTR, rt) : Tn({}), ve = qt($, "USE_PROFILES") ? $.USE_PROFILES : !1, uo = $.ALLOW_ARIA_ATTR !== !1, co = $.ALLOW_DATA_ATTR !== !1, Ls = $.ALLOW_UNKNOWN_PROTOCOLS || !1, Vn = $.ALLOW_SELF_CLOSE_IN_ATTR !== !1, fo = $.SAFE_FOR_TEMPLATES || !1, P = $.SAFE_FOR_XML !== !1, L = $.WHOLE_DOCUMENT || !1, z = $.RETURN_DOM || !1, Y = $.RETURN_DOM_FRAGMENT || !1, ie = $.RETURN_TRUSTED_TYPE || !1, Q = $.FORCE_BODY || !1, se = $.SANITIZE_DOM !== !1, ee = $.SANITIZE_NAMED_PROPS || !1, Te = $.KEEP_CONTENT !== !1, ae = $.IN_PLACE || !1, lt = $.ALLOWED_URI_REGEXP || Bp, On = $.NAMESPACE || Ot, po = $.MATHML_TEXT_INTEGRATION_POINTS || po, Xr = $.HTML_INTEGRATION_POINTS || Xr, He = $.CUSTOM_ELEMENT_HANDLING || {}, $.CUSTOM_ELEMENT_HANDLING && uh($.CUSTOM_ELEMENT_HANDLING.tagNameCheck) && (He.tagNameCheck = $.CUSTOM_ELEMENT_HANDLING.tagNameCheck), $.CUSTOM_ELEMENT_HANDLING && uh($.CUSTOM_ELEMENT_HANDLING.attributeNameCheck) && (He.attributeNameCheck = $.CUSTOM_ELEMENT_HANDLING.attributeNameCheck), $.CUSTOM_ELEMENT_HANDLING && typeof $.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements == "boolean" && (He.allowCustomizedBuiltInElements = $.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements), fo && (co = !1), Y && (z = !0), ve && (Oe = Ee({}, xp), Ie = [], ve.html === !0 && (Ee(Oe, $p), Ee(Ie, Fp)), ve.svg === !0 && (Ee(Oe, Ba), Ee(Ie, Ga), Ee(Ie, Vr)), ve.svgFilters === !0 && (Ee(Oe, Va), Ee(Ie, Ga), Ee(Ie, Vr)), ve.mathMl === !0 && (Ee(Oe, Ha), Ee(Ie, Up), Ee(Ie, Vr))), $.ADD_TAGS && (Oe === Ke && (Oe = Tn(Oe)), Ee(Oe, $.ADD_TAGS, rt)), $.ADD_ATTR && (Ie === Pn && (Ie = Tn(Ie)), Ee(Ie, $.ADD_ATTR, rt)), $.ADD_URI_SAFE_ATTR && Ee(st, $.ADD_URI_SAFE_ATTR, rt), $.FORBID_CONTENTS && (Se === Re && (Se = Tn(Se)), Ee(Se, $.FORBID_CONTENTS, rt)), Te && (Oe["#text"] = !0), L && Ee(Oe, ["html", "head", "body"]), Oe.table && (Ee(Oe, ["tbody"]), delete lo.tbody), $.TRUSTED_TYPES_POLICY) {
            if (typeof $.TRUSTED_TYPES_POLICY.createHTML != "function") throw Es('TRUSTED_TYPES_POLICY configuration option must provide a "createHTML" hook.');
            if (typeof $.TRUSTED_TYPES_POLICY.createScriptURL != "function") throw Es('TRUSTED_TYPES_POLICY configuration option must provide a "createScriptURL" hook.');
            N = $.TRUSTED_TYPES_POLICY, D = N.createHTML("")
          } else N === void 0 && (N = Z0(f, s)), N !== null && typeof D == "string" && (D = N.createHTML(""));
          Tt && Tt($), Uo = $
        }
      },
      ch = Ee({}, [...Ba, ...Va, ...H0]),
      dh = Ee({}, [...Ha, ...G0]),
      OI = function($) {
        let ne = k($);
        (!ne || !ne.tagName) && (ne = {
          namespaceURI: On,
          tagName: "template"
        });
        const ge = Br($.tagName),
          Ye = Br(ne.tagName);
        return Rt[$.namespaceURI] ? $.namespaceURI === Et ? ne.namespaceURI === Ot ? ge === "svg" : ne.namespaceURI === Pt ? ge === "svg" && (Ye === "annotation-xml" || po[Ye]) : !!ch[ge] : $.namespaceURI === Pt ? ne.namespaceURI === Ot ? ge === "math" : ne.namespaceURI === Et ? ge === "math" && Xr[Ye] : !!dh[ge] : $.namespaceURI === Ot ? ne.namespaceURI === Et && !Xr[Ye] || ne.namespaceURI === Pt && !po[Ye] ? !1 : !dh[ge] && (SI[ge] || !ch[ge]) : !!($s === "application/xhtml+xml" && Rt[$.namespaceURI]) : !1
      },
      dn = function($) {
        Ds(t.removed, {
          element: $
        });
        try {
          k($).removeChild($)
        } catch {
          m($)
        }
      },
      Bo = function($, ne) {
        try {
          Ds(t.removed, {
            attribute: ne.getAttributeNode($),
            from: ne
          })
        } catch {
          Ds(t.removed, {
            attribute: null,
            from: ne
          })
        }
        if (ne.removeAttribute($), $ === "is")
          if (z || Y) try {
            dn(ne)
          } catch {} else try {
            ne.setAttribute($, "")
          } catch {}
      },
      fh = function($) {
        let ne = null,
          ge = null;
        if (Q) $ = "<remove></remove>" + $;
        else {
          const tt = Lp($, /^[\r\n\t ]+/);
          ge = tt && tt[0]
        }
        $s === "application/xhtml+xml" && On === Ot && ($ = '<html xmlns="http://www.w3.org/1999/xhtml"><head></head><body>' + $ + "</body></html>");
        const Ye = N ? N.createHTML($) : $;
        if (On === Ot) try {
          ne = new h().parseFromString(Ye, $s)
        } catch {}
        if (!ne || !ne.documentElement) {
          ne = O.createDocument(On, "template", null);
          try {
            ne.documentElement.innerHTML = et ? D : Ye
          } catch {}
        }
        const pt = ne.body || ne.documentElement;
        return $ && ge && pt.insertBefore(n.createTextNode(ge), pt.childNodes[0] || null), On === Ot ? C.call(ne, L ? "html" : "body")[0] : L ? ne.documentElement : pt
      },
      ph = function($) {
        return A.call($.ownerDocument || $, $, c.SHOW_ELEMENT | c.SHOW_COMMENT | c.SHOW_TEXT | c.SHOW_PROCESSING_INSTRUCTION | c.SHOW_CDATA_SECTION, null)
      },
      eu = function($) {
        return $ instanceof d && (typeof $.nodeName != "string" || typeof $.textContent != "string" || typeof $.removeChild != "function" || !($.attributes instanceof u) || typeof $.removeAttribute != "function" || typeof $.setAttribute != "function" || typeof $.namespaceURI != "string" || typeof $.insertBefore != "function" || typeof $.hasChildNodes != "function")
      },
      _h = function($) {
        return typeof i == "function" && $ instanceof i
      };

    function In(Ce, $, ne) {
      Ur(Ce, ge => {
        ge.call(t, $, ne, Uo)
      })
    }
    const hh = function($) {
        let ne = null;
        if (In(I.beforeSanitizeElements, $, null), eu($)) return dn($), !0;
        const ge = rt($.nodeName);
        if (In(I.uponSanitizeElement, $, {
            tagName: ge,
            allowedTags: Oe
          }), P && $.hasChildNodes() && !_h($.firstElementChild) && bt(/<[/\w!]/g, $.innerHTML) && bt(/<[/\w!]/g, $.textContent) || $.nodeType === Is.progressingInstruction || P && $.nodeType === Is.comment && bt(/<[/\w]/g, $.data)) return dn($), !0;
        if (!Oe[ge] || lo[ge]) {
          if (!lo[ge] && vh(ge) && (He.tagNameCheck instanceof RegExp && bt(He.tagNameCheck, ge) || He.tagNameCheck instanceof Function && He.tagNameCheck(ge))) return !1;
          if (Te && !Se[ge]) {
            const Ye = k($) || $.parentNode,
              pt = E($) || $.childNodes;
            if (pt && Ye) {
              const tt = pt.length;
              for (let wt = tt - 1; wt >= 0; --wt) {
                const Rn = p(pt[wt], !0);
                Rn.__removalCount = ($.__removalCount || 0) + 1, Ye.insertBefore(Rn, v($))
              }
            }
          }
          return dn($), !0
        }
        return $ instanceof l && !OI($) || (ge === "noscript" || ge === "noembed" || ge === "noframes") && bt(/<\/no(script|embed|frames)/i, $.innerHTML) ? (dn($), !0) : (fo && $.nodeType === Is.text && (ne = $.textContent, Ur([w, U, Z], Ye => {
          ne = Ps(ne, Ye, " ")
        }), $.textContent !== ne && (Ds(t.removed, {
          element: $.cloneNode()
        }), $.textContent = ne)), In(I.afterSanitizeElements, $, null), !1)
      },
      mh = function($, ne, ge) {
        if (se && (ne === "id" || ne === "name") && (ge in n || ge in EI)) return !1;
        if (!(co && !En[ne] && bt(me, ne))) {
          if (!(uo && bt(_e, ne))) {
            if (!Ie[ne] || En[ne]) {
              if (!(vh($) && (He.tagNameCheck instanceof RegExp && bt(He.tagNameCheck, $) || He.tagNameCheck instanceof Function && He.tagNameCheck($)) && (He.attributeNameCheck instanceof RegExp && bt(He.attributeNameCheck, ne) || He.attributeNameCheck instanceof Function && He.attributeNameCheck(ne)) || ne === "is" && He.allowCustomizedBuiltInElements && (He.tagNameCheck instanceof RegExp && bt(He.tagNameCheck, ge) || He.tagNameCheck instanceof Function && He.tagNameCheck(ge)))) return !1
            } else if (!st[ne]) {
              if (!bt(lt, Ps(ge, W, ""))) {
                if (!((ne === "src" || ne === "xlink:href" || ne === "href") && $ !== "script" && F0(ge, "data:") === 0 && Ue[$])) {
                  if (!(Ls && !bt(B, Ps(ge, W, "")))) {
                    if (ge) return !1
                  }
                }
              }
            }
          }
        }
        return !0
      },
      vh = function($) {
        return $ !== "annotation-xml" && Lp($, ue)
      },
      gh = function($) {
        In(I.beforeSanitizeAttributes, $, null);
        const {
          attributes: ne
        } = $;
        if (!ne || eu($)) return;
        const ge = {
          attrName: "",
          attrValue: "",
          keepAttr: !0,
          allowedAttributes: Ie,
          forceKeepAttr: void 0
        };
        let Ye = ne.length;
        for (; Ye--;) {
          const pt = ne[Ye],
            {
              name: tt,
              namespaceURI: wt,
              value: Rn
            } = pt,
            xs = rt(tt),
            tu = Rn;
          let _t = tt === "value" ? tu : U0(tu);
          if (ge.attrName = xs, ge.attrValue = _t, ge.keepAttr = !0, ge.forceKeepAttr = void 0, In(I.uponSanitizeAttribute, $, ge), _t = ge.attrValue, ee && (xs === "id" || xs === "name") && (Bo(tt, $), _t = X + _t), P && bt(/((--!?|])>)|<\/(style|title)/i, _t)) {
            Bo(tt, $);
            continue
          }
          if (ge.forceKeepAttr) continue;
          if (!ge.keepAttr) {
            Bo(tt, $);
            continue
          }
          if (!Vn && bt(/\/>/i, _t)) {
            Bo(tt, $);
            continue
          }
          fo && Ur([w, U, Z], Ch => {
            _t = Ps(_t, Ch, " ")
          });
          const yh = rt($.nodeName);
          if (!mh(yh, xs, _t)) {
            Bo(tt, $);
            continue
          }
          if (N && typeof f == "object" && typeof f.getAttributeType == "function" && !wt) switch (f.getAttributeType(yh, xs)) {
            case "TrustedHTML": {
              _t = N.createHTML(_t);
              break
            }
            case "TrustedScriptURL": {
              _t = N.createScriptURL(_t);
              break
            }
          }
          if (_t !== tu) try {
            wt ? $.setAttributeNS(wt, tt, _t) : $.setAttribute(tt, _t), eu($) ? dn($) : kp(t.removed)
          } catch {
            Bo(tt, $)
          }
        }
        In(I.afterSanitizeAttributes, $, null)
      },
      II = function Ce($) {
        let ne = null;
        const ge = ph($);
        for (In(I.beforeSanitizeShadowDOM, $, null); ne = ge.nextNode();) In(I.uponSanitizeShadowNode, ne, null), hh(ne), gh(ne), ne.content instanceof r && Ce(ne.content);
        In(I.afterSanitizeShadowDOM, $, null)
      };
    return t.sanitize = function(Ce) {
      let $ = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {},
        ne = null,
        ge = null,
        Ye = null,
        pt = null;
      if (et = !Ce, et && (Ce = "<!-->"), typeof Ce != "string" && !_h(Ce))
        if (typeof Ce.toString == "function") {
          if (Ce = Ce.toString(), typeof Ce != "string") throw Es("dirty is not a string, aborting")
        } else throw Es("toString is not a function");
      if (!t.isSupported) return Ce;
      if (G || Zl($), t.removed = [], typeof Ce == "string" && (ae = !1), ae) {
        if (Ce.nodeName) {
          const Rn = rt(Ce.nodeName);
          if (!Oe[Rn] || lo[Rn]) throw Es("root node is forbidden and cannot be sanitized in-place")
        }
      } else if (Ce instanceof i) ne = fh("<!---->"), ge = ne.ownerDocument.importNode(Ce, !0), ge.nodeType === Is.element && ge.nodeName === "BODY" || ge.nodeName === "HTML" ? ne = ge : ne.appendChild(ge);
      else {
        if (!z && !fo && !L && Ce.indexOf("<") === -1) return N && ie ? N.createHTML(Ce) : Ce;
        if (ne = fh(Ce), !ne) return z ? null : ie ? D : ""
      }
      ne && Q && dn(ne.firstChild);
      const tt = ph(ae ? Ce : ne);
      for (; Ye = tt.nextNode();) hh(Ye), gh(Ye), Ye.content instanceof r && II(Ye.content);
      if (ae) return Ce;
      if (z) {
        if (Y)
          for (pt = b.call(ne.ownerDocument); ne.firstChild;) pt.appendChild(ne.firstChild);
        else pt = ne;
        return (Ie.shadowroot || Ie.shadowrootmode) && (pt = y.call(o, pt, !0)), pt
      }
      let wt = L ? ne.outerHTML : ne.innerHTML;
      return L && Oe["!doctype"] && ne.ownerDocument && ne.ownerDocument.doctype && ne.ownerDocument.doctype.name && bt(Vp, ne.ownerDocument.doctype.name) && (wt = "<!DOCTYPE " + ne.ownerDocument.doctype.name + `>
` + wt), fo && Ur([w, U, Z], Rn => {
        wt = Ps(wt, Rn, " ")
      }), N && ie ? N.createHTML(wt) : wt
    }, t.setConfig = function() {
      let Ce = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      Zl(Ce), G = !0
    }, t.clearConfig = function() {
      Uo = null, G = !1
    }, t.isValidAttribute = function(Ce, $, ne) {
      Uo || Zl({});
      const ge = rt(Ce),
        Ye = rt($);
      return mh(ge, Ye, ne)
    }, t.addHook = function(Ce, $) {
      typeof $ == "function" && Ds(I[Ce], $)
    }, t.removeHook = function(Ce, $) {
      if ($ !== void 0) {
        const ne = $0(I[Ce], $);
        return ne === -1 ? void 0 : x0(I[Ce], ne, 1)[0]
      }
      return kp(I[Ce])
    }, t.removeHooks = function(Ce) {
      I[Ce] = []
    }, t.removeAllHooks = function() {
      I = Gp()
    }, t
  }
  var eT = jp();

  function tT(e, t) {
    const n = e.hooks ?? {};
    let o;
    for (o in n) {
      const s = n[o];
      s !== void 0 && t.addHook(o, s)
    }
  }

  function zp() {
    return eT()
  }

  function nT(e = {}, t = zp) {
    const n = t();
    tT(e, n);
    const o = function(a) {
        const i = a.value;
        if (a.oldValue === i) return;
        const l = `${i}`,
          c = a.arg,
          u = e.namedConfigurations,
          d = e.default ?? {};
        return u && c !== void 0 ? n.sanitize(l, u[c] ?? d) : n.sanitize(l, d)
      },
      s = function(a, i) {
        const l = o(i);
        l !== void 0 && (a.innerHTML = l)
      },
      r = {
        mounted: s,
        updated: s
      };
    return e.enableSSRPropsSupport ? {
      ...r,
      getSSRProps(a) {
        return {
          innerHTML: o(a)
        }
      }
    } : r
  }
  const oT = {
    install(e, t = {}, n = zp) {
      e.directive("dompurify-html", nT(t, n))
    }
  };
