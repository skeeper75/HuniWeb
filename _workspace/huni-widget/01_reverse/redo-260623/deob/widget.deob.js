(function () {
  "use strict";

  /**
  * @vue/shared v3.5.21
  * (c) 2018-present Yuxi (Evan) You and Vue contributors
  * @license MIT
  **/
  function An(e) {
    const t = Object.create(null);
    for (const n of e.split(",")) t[n] = 1;
    return n => n in t;
  }
  const Je = Object.freeze({}),
    wo = Object.freeze([]),
    Mt = () => {},
    wu = () => !1,
    ps = e => e.charCodeAt(0) === 111 && e.charCodeAt(1) === 110 && (e.charCodeAt(2) > 122 || e.charCodeAt(2) < 97),
    _a = e => e.startsWith("onUpdate:"),
    ct = Object.assign,
    Ii = (e, t) => {
      const n = e.indexOf(t);
      n > -1 && e.splice(n, 1);
    },
    Ov = Object.prototype.hasOwnProperty,
    je = (e, t) => Ov.call(e, t),
    Ie = Array.isArray,
    io = e => _s(e) === "[object Map]",
    Lo = e => _s(e) === "[object Set]",
    Lu = e => _s(e) === "[object Date]",
    we = e => typeof e == "function",
    at = e => typeof e == "string",
    cn = e => typeof e == "symbol",
    ze = e => e !== null && typeof e == "object",
    Ri = e => (ze(e) || we(e)) && we(e.then) && we(e.catch),
    ku = Object.prototype.toString,
    _s = e => ku.call(e),
    Ni = e => _s(e).slice(8, -1),
    $u = e => _s(e) === "[object Object]",
    Ai = e => at(e) && e !== "NaN" && e[0] !== "-" && "" + parseInt(e, 10) === e,
    hs = An(",key,ref,ref_for,ref_key,onVnodeBeforeMount,onVnodeMounted,onVnodeBeforeUpdate,onVnodeUpdated,onVnodeBeforeUnmount,onVnodeUnmounted"),
    Ev = An("bind,cloak,else-if,else,for,html,if,model,on,once,pre,show,slot,text,memo"),
    ha = e => {
      const t = Object.create(null);
      return n => t[n] || (t[n] = e(n));
    },
    Iv = /-\w/g,
    Ut = ha(e => e.replace(Iv, t => t.slice(1).toUpperCase())),
    Rv = /\B([A-Z])/g,
    Qn = ha(e => e.replace(Rv, "-$1").toLowerCase()),
    ro = ha(e => e.charAt(0).toUpperCase() + e.slice(1)),
    lo = ha(e => e ? `on${ro(e)}` : ""),
    qn = (e, t) => !Object.is(e, t),
    ko = (e, ...t) => {
      for (let n = 0; n < e.length; n++) e[n](...t);
    },
    va = (e, t, n, o = !1) => {
      Object.defineProperty(e, t, {
        configurable: !0,
        enumerable: !1,
        writable: o,
        value: n
      });
    },
    ma = e => {
      const t = parseFloat(e);
      return isNaN(t) ? e : t;
    },
    Nv = e => {
      const t = at(e) ? Number(e) : NaN;
      return isNaN(t) ? e : t;
    };
  let Fu;
  const vs = () => Fu || (Fu = typeof globalThis < "u" ? globalThis : typeof self < "u" ? self : typeof window < "u" ? window : typeof global < "u" ? global : {});
  function mt(e) {
    if (Ie(e)) {
      const t = {};
      for (let n = 0; n < e.length; n++) {
        const o = e[n],
          s = at(o) ? Lv(o) : mt(o);
        if (s) for (const a in s) t[a] = s[a];
      }
      return t;
    } else if (at(e) || ze(e)) return e;
  }
  const Av = /;(?![^(]*\))/g,
    Mv = /:([^]+)/,
    wv = /\/\*[^]*?\*\//g;
  function Lv(e) {
    const t = {};
    return e.replace(wv, "").split(Av).forEach(n => {
      if (n) {
        const o = n.split(Mv);
        o.length > 1 && (t[o[0].trim()] = o[1].trim());
      }
    }), t;
  }
  function $e(e) {
    let t = "";
    if (at(e)) t = e;else if (Ie(e)) for (let n = 0; n < e.length; n++) {
      const o = $e(e[n]);
      o && (t += o + " ");
    } else if (ze(e)) for (const n in e) e[n] && (t += n + " ");
    return t.trim();
  }
  const kv = "html,body,base,head,link,meta,style,title,address,article,aside,footer,header,hgroup,h1,h2,h3,h4,h5,h6,nav,section,div,dd,dl,dt,figcaption,figure,picture,hr,img,li,main,ol,p,pre,ul,a,b,abbr,bdi,bdo,br,cite,code,data,dfn,em,i,kbd,mark,q,rp,rt,ruby,s,samp,small,span,strong,sub,sup,time,u,var,wbr,area,audio,map,track,video,embed,object,param,source,canvas,script,noscript,del,ins,caption,col,colgroup,table,thead,tbody,td,th,tr,button,datalist,fieldset,form,input,label,legend,meter,optgroup,option,output,progress,select,textarea,details,dialog,menu,summary,template,blockquote,iframe,tfoot",
    $v = "svg,animate,animateMotion,animateTransform,circle,clipPath,color-profile,defs,desc,discard,ellipse,feBlend,feColorMatrix,feComponentTransfer,feComposite,feConvolveMatrix,feDiffuseLighting,feDisplacementMap,feDistantLight,feDropShadow,feFlood,feFuncA,feFuncB,feFuncG,feFuncR,feGaussianBlur,feImage,feMerge,feMergeNode,feMorphology,feOffset,fePointLight,feSpecularLighting,feSpotLight,feTile,feTurbulence,filter,foreignObject,g,hatch,hatchpath,image,line,linearGradient,marker,mask,mesh,meshgradient,meshpatch,meshrow,metadata,mpath,path,pattern,polygon,polyline,radialGradient,rect,set,solidcolor,stop,switch,symbol,text,textPath,title,tspan,unknown,use,view",
    Fv = "annotation,annotation-xml,maction,maligngroup,malignmark,math,menclose,merror,mfenced,mfrac,mfraction,mglyph,mi,mlabeledtr,mlongdiv,mmultiscripts,mn,mo,mover,mpadded,mphantom,mprescripts,mroot,mrow,ms,mscarries,mscarry,msgroup,msline,mspace,msqrt,msrow,mstack,mstyle,msub,msubsup,msup,mtable,mtd,mtext,mtr,munder,munderover,none,semantics",
    Uv = An(kv),
    Bv = An($v),
    xv = An(Fv),
    Hv = An("itemscope,allowfullscreen,formnovalidate,ismap,nomodule,novalidate,readonly");
  function Uu(e) {
    return !!e || e === "";
  }
  function Gv(e, t) {
    if (e.length !== t.length) return !1;
    let n = !0;
    for (let o = 0; n && o < e.length; o++) n = uo(e[o], t[o]);
    return n;
  }
  function uo(e, t) {
    if (e === t) return !0;
    let n = Lu(e),
      o = Lu(t);
    if (n || o) return n && o ? e.getTime() === t.getTime() : !1;
    if (n = cn(e), o = cn(t), n || o) return e === t;
    if (n = Ie(e), o = Ie(t), n || o) return n && o ? Gv(e, t) : !1;
    if (n = ze(e), o = ze(t), n || o) {
      if (!n || !o) return !1;
      const s = Object.keys(e).length,
        a = Object.keys(t).length;
      if (s !== a) return !1;
      for (const r in e) {
        const i = e.hasOwnProperty(r),
          l = t.hasOwnProperty(r);
        if (i && !l || !i && l || !uo(e[r], t[r])) return !1;
      }
    }
    return String(e) === String(t);
  }
  function Mi(e, t) {
    return e.findIndex(n => uo(n, t));
  }
  const Bu = e => !!(e && e.__v_isRef === !0),
    Y = e => at(e) ? e : e == null ? "" : Ie(e) || ze(e) && (e.toString === ku || !we(e.toString)) ? Bu(e) ? Y(e.value) : JSON.stringify(e, xu, 2) : String(e),
    xu = (e, t) => Bu(t) ? xu(e, t.value) : io(t) ? {
      [`Map(${t.size})`]: [...t.entries()].reduce((n, [o, s], a) => (n[wi(o, a) + " =>"] = s, n), {})
    } : Lo(t) ? {
      [`Set(${t.size})`]: [...t.values()].map(n => wi(n))
    } : cn(t) ? wi(t) : ze(t) && !Ie(t) && !$u(t) ? String(t) : t,
    wi = (e, t = "") => {
      var n;
      return cn(e) ? `Symbol(${(n = e.description) != null ? n : t})` : e;
    };
  var Wv = {
    NODE_ENV: '"production"'
  };
  function Yt(e, ...t) {
    console.warn(`[Vue warn] ${e}`, ...t);
  }
  let wt;
  class Hu {
    constructor(t = !1) {
      this.detached = t, this._active = !0, this._on = 0, this.effects = [], this.cleanups = [], this._isPaused = !1, this.parent = wt, !t && wt && (this.index = (wt.scopes || (wt.scopes = [])).push(this) - 1);
    }
    get active() {
      return this._active;
    }
    pause() {
      if (this._active) {
        this._isPaused = !0;
        let t, n;
        if (this.scopes) for (t = 0, n = this.scopes.length; t < n; t++) this.scopes[t].pause();
        for (t = 0, n = this.effects.length; t < n; t++) this.effects[t].pause();
      }
    }
    resume() {
      if (this._active && this._isPaused) {
        this._isPaused = !1;
        let t, n;
        if (this.scopes) for (t = 0, n = this.scopes.length; t < n; t++) this.scopes[t].resume();
        for (t = 0, n = this.effects.length; t < n; t++) this.effects[t].resume();
      }
    }
    run(t) {
      if (this._active) {
        const n = wt;
        try {
          return wt = this, t();
        } finally {
          wt = n;
        }
      } else Yt("cannot run an inactive effect scope.");
    }
    on() {
      ++this._on === 1 && (this.prevScope = wt, wt = this);
    }
    off() {
      this._on > 0 && --this._on === 0 && (wt = this.prevScope, this.prevScope = void 0);
    }
    stop(t) {
      if (this._active) {
        this._active = !1;
        let n, o;
        for (n = 0, o = this.effects.length; n < o; n++) this.effects[n].stop();
        for (this.effects.length = 0, n = 0, o = this.cleanups.length; n < o; n++) this.cleanups[n]();
        if (this.cleanups.length = 0, this.scopes) {
          for (n = 0, o = this.scopes.length; n < o; n++) this.scopes[n].stop(!0);
          this.scopes.length = 0;
        }
        if (!this.detached && this.parent && !t) {
          const s = this.parent.scopes.pop();
          s && s !== this && (this.parent.scopes[this.index] = s, s.index = this.index);
        }
        this.parent = void 0;
      }
    }
  }
  function Gu(e) {
    return new Hu(e);
  }
  function Wu() {
    return wt;
  }
  function Li(e, t = !1) {
    wt ? wt.cleanups.push(e) : t || Yt("onScopeDispose() is called when there is no active effect scope to be associated with.");
  }
  let et;
  const ki = new WeakSet();
  class Vu {
    constructor(t) {
      this.fn = t, this.deps = void 0, this.depsTail = void 0, this.flags = 5, this.next = void 0, this.cleanup = void 0, this.scheduler = void 0, wt && wt.active && wt.effects.push(this);
    }
    pause() {
      this.flags |= 64;
    }
    resume() {
      this.flags & 64 && (this.flags &= -65, ki.has(this) && (ki.delete(this), this.trigger()));
    }
    notify() {
      this.flags & 2 && !(this.flags & 32) || this.flags & 8 || zu(this);
    }
    run() {
      if (!(this.flags & 1)) return this.fn();
      this.flags |= 2, Xu(this), Ku(this);
      const t = et,
        n = dn;
      et = this, dn = !0;
      try {
        return this.fn();
      } finally {
        et !== this && Yt("Active effect was not restored correctly - this is likely a Vue internal bug."), Yu(this), et = t, dn = n, this.flags &= -3;
      }
    }
    stop() {
      if (this.flags & 1) {
        for (let t = this.deps; t; t = t.nextDep) Bi(t);
        this.deps = this.depsTail = void 0, Xu(this), this.onStop && this.onStop(), this.flags &= -2;
      }
    }
    trigger() {
      this.flags & 64 ? ki.add(this) : this.scheduler ? this.scheduler() : this.runIfDirty();
    }
    runIfDirty() {
      Ui(this) && this.run();
    }
    get dirty() {
      return Ui(this);
    }
  }
  let ju = 0,
    ms,
    Cs;
  function zu(e, t = !1) {
    if (e.flags |= 8, t) {
      e.next = Cs, Cs = e;
      return;
    }
    e.next = ms, ms = e;
  }
  function $i() {
    ju++;
  }
  function Fi() {
    if (--ju > 0) return;
    if (Cs) {
      let t = Cs;
      for (Cs = void 0; t;) {
        const n = t.next;
        t.next = void 0, t.flags &= -9, t = n;
      }
    }
    let e;
    for (; ms;) {
      let t = ms;
      for (ms = void 0; t;) {
        const n = t.next;
        if (t.next = void 0, t.flags &= -9, t.flags & 1) try {
          t.trigger();
        } catch (o) {
          e || (e = o);
        }
        t = n;
      }
    }
    if (e) throw e;
  }
  function Ku(e) {
    for (let t = e.deps; t; t = t.nextDep) t.version = -1, t.prevActiveLink = t.dep.activeLink, t.dep.activeLink = t;
  }
  function Yu(e) {
    let t,
      n = e.depsTail,
      o = n;
    for (; o;) {
      const s = o.prevDep;
      o.version === -1 ? (o === n && (n = s), Bi(o), Vv(o)) : t = o, o.dep.activeLink = o.prevActiveLink, o.prevActiveLink = void 0, o = s;
    }
    e.deps = t, e.depsTail = n;
  }
  function Ui(e) {
    for (let t = e.deps; t; t = t.nextDep) if (t.dep.version !== t.version || t.dep.computed && (Qu(t.dep.computed) || t.dep.version !== t.version)) return !0;
    return !!e._dirty;
  }
  function Qu(e) {
    if (e.flags & 4 && !(e.flags & 16) || (e.flags &= -17, e.globalVersion === Ts) || (e.globalVersion = Ts, !e.isSSR && e.flags & 128 && (!e.deps && !e._dirty || !Ui(e)))) return;
    e.flags |= 2;
    const t = e.dep,
      n = et,
      o = dn;
    et = e, dn = !0;
    try {
      Ku(e);
      const s = e.fn(e._value);
      (t.version === 0 || qn(s, e._value)) && (e.flags |= 128, e._value = s, t.version++);
    } catch (s) {
      throw t.version++, s;
    } finally {
      et = n, dn = o, Yu(e), e.flags &= -3;
    }
  }
  function Bi(e, t = !1) {
    const {
      dep: n,
      prevSub: o,
      nextSub: s
    } = e;
    if (o && (o.nextSub = s, e.prevSub = void 0), s && (s.prevSub = o, e.nextSub = void 0), n.subsHead === e && (n.subsHead = s), n.subs === e && (n.subs = o, !o && n.computed)) {
      n.computed.flags &= -5;
      for (let a = n.computed.deps; a; a = a.nextDep) Bi(a, !0);
    }
    !t && ! --n.sc && n.map && n.map.delete(n.key);
  }
  function Vv(e) {
    const {
      prevDep: t,
      nextDep: n
    } = e;
    t && (t.nextDep = n, e.prevDep = void 0), n && (n.prevDep = t, e.nextDep = void 0);
  }
  let dn = !0;
  const qu = [];
  function fn() {
    qu.push(dn), dn = !1;
  }
  function pn() {
    const e = qu.pop();
    dn = e === void 0 ? !0 : e;
  }
  function Xu(e) {
    const {
      cleanup: t
    } = e;
    if (e.cleanup = void 0, t) {
      const n = et;
      et = void 0;
      try {
        t();
      } finally {
        et = n;
      }
    }
  }
  let Ts = 0;
  class jv {
    constructor(t, n) {
      this.sub = t, this.dep = n, this.version = n.version, this.nextDep = this.prevDep = this.nextSub = this.prevSub = this.prevActiveLink = void 0;
    }
  }
  class xi {
    constructor(t) {
      this.computed = t, this.version = 0, this.activeLink = void 0, this.subs = void 0, this.map = void 0, this.key = void 0, this.sc = 0, this.__v_skip = !0, this.subsHead = void 0;
    }
    track(t) {
      if (!et || !dn || et === this.computed) return;
      let n = this.activeLink;
      if (n === void 0 || n.sub !== et) n = this.activeLink = new jv(et, this), et.deps ? (n.prevDep = et.depsTail, et.depsTail.nextDep = n, et.depsTail = n) : et.deps = et.depsTail = n, Zu(n);else if (n.version === -1 && (n.version = this.version, n.nextDep)) {
        const o = n.nextDep;
        o.prevDep = n.prevDep, n.prevDep && (n.prevDep.nextDep = o), n.prevDep = et.depsTail, n.nextDep = void 0, et.depsTail.nextDep = n, et.depsTail = n, et.deps === n && (et.deps = o);
      }
      return et.onTrack && et.onTrack(ct({
        effect: et
      }, t)), n;
    }
    trigger(t) {
      this.version++, Ts++, this.notify(t);
    }
    notify(t) {
      $i();
      try {
        if (Wv.NODE_ENV !== "production") for (let n = this.subsHead; n; n = n.nextSub) n.sub.onTrigger && !(n.sub.flags & 8) && n.sub.onTrigger(ct({
          effect: n.sub
        }, t));
        for (let n = this.subs; n; n = n.prevSub) n.sub.notify() && n.sub.dep.notify();
      } finally {
        Fi();
      }
    }
  }
  function Zu(e) {
    if (e.dep.sc++, e.sub.flags & 4) {
      const t = e.dep.computed;
      if (t && !e.dep.subs) {
        t.flags |= 20;
        for (let o = t.deps; o; o = o.nextDep) Zu(o);
      }
      const n = e.dep.subs;
      n !== e && (e.prevSub = n, n && (n.nextSub = e)), e.dep.subsHead === void 0 && (e.dep.subsHead = e), e.dep.subs = e;
    }
  }
  const Ca = new WeakMap(),
    co = Symbol("Object iterate"),
    Hi = Symbol("Map keys iterate"),
    gs = Symbol("Array iterate");
  function Pt(e, t, n) {
    if (dn && et) {
      let o = Ca.get(e);
      o || Ca.set(e, o = new Map());
      let s = o.get(n);
      s || (o.set(n, s = new xi()), s.map = o, s.key = n), s.track({
        target: e,
        type: t,
        key: n
      });
    }
  }
  function Tn(e, t, n, o, s, a) {
    const r = Ca.get(e);
    if (!r) {
      Ts++;
      return;
    }
    const i = l => {
      l && l.trigger({
        target: e,
        type: t,
        key: n,
        newValue: o,
        oldValue: s,
        oldTarget: a
      });
    };
    if ($i(), t === "clear") r.forEach(i);else {
      const l = Ie(e),
        u = l && Ai(n);
      if (l && n === "length") {
        const c = Number(o);
        r.forEach((d, p) => {
          (p === "length" || p === gs || !cn(p) && p >= c) && i(d);
        });
      } else switch ((n !== void 0 || r.has(void 0)) && i(r.get(n)), u && i(r.get(gs)), t) {
        case "add":
          l ? u && i(r.get("length")) : (i(r.get(co)), io(e) && i(r.get(Hi)));
          break;
        case "delete":
          l || (i(r.get(co)), io(e) && i(r.get(Hi)));
          break;
        case "set":
          io(e) && i(r.get(co));
          break;
      }
    }
    Fi();
  }
  function zv(e, t) {
    const n = Ca.get(e);
    return n && n.get(t);
  }
  function $o(e) {
    const t = Le(e);
    return t === e ? t : (Pt(t, "iterate", gs), Bt(e) ? t : t.map(It));
  }
  function Ta(e) {
    return Pt(e = Le(e), "iterate", gs), e;
  }
  const Kv = {
    __proto__: null,
    [Symbol.iterator]() {
      return Gi(this, Symbol.iterator, It);
    },
    concat(...e) {
      return $o(this).concat(...e.map(t => Ie(t) ? $o(t) : t));
    },
    entries() {
      return Gi(this, "entries", e => (e[1] = It(e[1]), e));
    },
    every(e, t) {
      return Mn(this, "every", e, t, void 0, arguments);
    },
    filter(e, t) {
      return Mn(this, "filter", e, t, n => n.map(It), arguments);
    },
    find(e, t) {
      return Mn(this, "find", e, t, It, arguments);
    },
    findIndex(e, t) {
      return Mn(this, "findIndex", e, t, void 0, arguments);
    },
    findLast(e, t) {
      return Mn(this, "findLast", e, t, It, arguments);
    },
    findLastIndex(e, t) {
      return Mn(this, "findLastIndex", e, t, void 0, arguments);
    },
    forEach(e, t) {
      return Mn(this, "forEach", e, t, void 0, arguments);
    },
    includes(...e) {
      return Wi(this, "includes", e);
    },
    indexOf(...e) {
      return Wi(this, "indexOf", e);
    },
    join(e) {
      return $o(this).join(e);
    },
    lastIndexOf(...e) {
      return Wi(this, "lastIndexOf", e);
    },
    map(e, t) {
      return Mn(this, "map", e, t, void 0, arguments);
    },
    pop() {
      return ys(this, "pop");
    },
    push(...e) {
      return ys(this, "push", e);
    },
    reduce(e, ...t) {
      return Ju(this, "reduce", e, t);
    },
    reduceRight(e, ...t) {
      return Ju(this, "reduceRight", e, t);
    },
    shift() {
      return ys(this, "shift");
    },
    some(e, t) {
      return Mn(this, "some", e, t, void 0, arguments);
    },
    splice(...e) {
      return ys(this, "splice", e);
    },
    toReversed() {
      return $o(this).toReversed();
    },
    toSorted(e) {
      return $o(this).toSorted(e);
    },
    toSpliced(...e) {
      return $o(this).toSpliced(...e);
    },
    unshift(...e) {
      return ys(this, "unshift", e);
    },
    values() {
      return Gi(this, "values", It);
    }
  };
  function Gi(e, t, n) {
    const o = Ta(e),
      s = o[t]();
    return o !== e && !Bt(e) && (s._next = s.next, s.next = () => {
      const a = s._next();
      return a.value && (a.value = n(a.value)), a;
    }), s;
  }
  const Yv = Array.prototype;
  function Mn(e, t, n, o, s, a) {
    const r = Ta(e),
      i = r !== e && !Bt(e),
      l = r[t];
    if (l !== Yv[t]) {
      const d = l.apply(e, a);
      return i ? It(d) : d;
    }
    let u = n;
    r !== e && (i ? u = function (d, p) {
      return n.call(this, It(d), p, e);
    } : n.length > 2 && (u = function (d, p) {
      return n.call(this, d, p, e);
    }));
    const c = l.call(r, u, o);
    return i && s ? s(c) : c;
  }
  function Ju(e, t, n, o) {
    const s = Ta(e);
    let a = n;
    return s !== e && (Bt(e) ? n.length > 3 && (a = function (r, i, l) {
      return n.call(this, r, i, l, e);
    }) : a = function (r, i, l) {
      return n.call(this, r, It(i), l, e);
    }), s[t](a, ...o);
  }
  function Wi(e, t, n) {
    const o = Le(e);
    Pt(o, "iterate", gs);
    const s = o[t](...n);
    return (s === -1 || s === !1) && Ss(n[0]) ? (n[0] = Le(n[0]), o[t](...n)) : s;
  }
  function ys(e, t, n = []) {
    fn(), $i();
    const o = Le(e)[t].apply(e, n);
    return Fi(), pn(), o;
  }
  const Qv = An("__proto__,__v_isRef,__isVue"),
    ec = new Set(Object.getOwnPropertyNames(Symbol).filter(e => e !== "arguments" && e !== "caller").map(e => Symbol[e]).filter(cn));
  function qv(e) {
    cn(e) || (e = String(e));
    const t = Le(this);
    return Pt(t, "has", e), t.hasOwnProperty(e);
  }
  class tc {
    constructor(t = !1, n = !1) {
      this._isReadonly = t, this._isShallow = n;
    }
    get(t, n, o) {
      if (n === "__v_skip") return t.__v_skip;
      const s = this._isReadonly,
        a = this._isShallow;
      if (n === "__v_isReactive") return !s;
      if (n === "__v_isReadonly") return s;
      if (n === "__v_isShallow") return a;
      if (n === "__v_raw") return o === (s ? a ? lc : rc : a ? ic : ac).get(t) || Object.getPrototypeOf(t) === Object.getPrototypeOf(o) ? t : void 0;
      const r = Ie(t);
      if (!s) {
        let l;
        if (r && (l = Kv[n])) return l;
        if (n === "hasOwnProperty") return qv;
      }
      const i = Reflect.get(t, n, tt(t) ? t : o);
      return (cn(n) ? ec.has(n) : Qv(n)) || (s || Pt(t, "get", n), a) ? i : tt(i) ? r && Ai(n) ? i : i.value : ze(i) ? s ? Ds(i) : Xe(i) : i;
    }
  }
  class nc extends tc {
    constructor(t = !1) {
      super(!1, t);
    }
    set(t, n, o, s) {
      let a = t[n];
      if (!this._isShallow) {
        const l = gn(a);
        if (!Bt(o) && !gn(o) && (a = Le(a), o = Le(o)), !Ie(t) && tt(a) && !tt(o)) return l ? (Yt(`Set operation on key "${String(n)}" failed: target is readonly.`, t[n]), !0) : (a.value = o, !0);
      }
      const r = Ie(t) && Ai(n) ? Number(n) < t.length : je(t, n),
        i = Reflect.set(t, n, o, tt(t) ? t : s);
      return t === Le(s) && (r ? qn(o, a) && Tn(t, "set", n, o, a) : Tn(t, "add", n, o)), i;
    }
    deleteProperty(t, n) {
      const o = je(t, n),
        s = t[n],
        a = Reflect.deleteProperty(t, n);
      return a && o && Tn(t, "delete", n, void 0, s), a;
    }
    has(t, n) {
      const o = Reflect.has(t, n);
      return (!cn(n) || !ec.has(n)) && Pt(t, "has", n), o;
    }
    ownKeys(t) {
      return Pt(t, "iterate", Ie(t) ? "length" : co), Reflect.ownKeys(t);
    }
  }
  class oc extends tc {
    constructor(t = !1) {
      super(!0, t);
    }
    set(t, n) {
      return Yt(`Set operation on key "${String(n)}" failed: target is readonly.`, t), !0;
    }
    deleteProperty(t, n) {
      return Yt(`Delete operation on key "${String(n)}" failed: target is readonly.`, t), !0;
    }
  }
  const Xv = new nc(),
    Zv = new oc(),
    Jv = new nc(!0),
    em = new oc(!0),
    Vi = e => e,
    ga = e => Reflect.getPrototypeOf(e);
  function tm(e, t, n) {
    return function (...o) {
      const s = this.__v_raw,
        a = Le(s),
        r = io(a),
        i = e === "entries" || e === Symbol.iterator && r,
        l = e === "keys" && r,
        u = s[e](...o),
        c = n ? Vi : t ? Pa : It;
      return !t && Pt(a, "iterate", l ? Hi : co), {
        next() {
          const {
            value: d,
            done: p
          } = u.next();
          return p ? {
            value: d,
            done: p
          } : {
            value: i ? [c(d[0]), c(d[1])] : c(d),
            done: p
          };
        },
        [Symbol.iterator]() {
          return this;
        }
      };
    };
  }
  function ya(e) {
    return function (...t) {
      {
        const n = t[0] ? `on key "${t[0]}" ` : "";
        Yt(`${ro(e)} operation ${n}failed: target is readonly.`, Le(this));
      }
      return e === "delete" ? !1 : e === "clear" ? void 0 : this;
    };
  }
  function nm(e, t) {
    const n = {
      get(s) {
        const a = this.__v_raw,
          r = Le(a),
          i = Le(s);
        e || (qn(s, i) && Pt(r, "get", s), Pt(r, "get", i));
        const {
            has: l
          } = ga(r),
          u = t ? Vi : e ? Pa : It;
        if (l.call(r, s)) return u(a.get(s));
        if (l.call(r, i)) return u(a.get(i));
        a !== r && a.get(s);
      },
      get size() {
        const s = this.__v_raw;
        return !e && Pt(Le(s), "iterate", co), s.size;
      },
      has(s) {
        const a = this.__v_raw,
          r = Le(a),
          i = Le(s);
        return e || (qn(s, i) && Pt(r, "has", s), Pt(r, "has", i)), s === i ? a.has(s) : a.has(s) || a.has(i);
      },
      forEach(s, a) {
        const r = this,
          i = r.__v_raw,
          l = Le(i),
          u = t ? Vi : e ? Pa : It;
        return !e && Pt(l, "iterate", co), i.forEach((c, d) => s.call(a, u(c), u(d), r));
      }
    };
    return ct(n, e ? {
      add: ya("add"),
      set: ya("set"),
      delete: ya("delete"),
      clear: ya("clear")
    } : {
      add(s) {
        !t && !Bt(s) && !gn(s) && (s = Le(s));
        const a = Le(this);
        return ga(a).has.call(a, s) || (a.add(s), Tn(a, "add", s, s)), this;
      },
      set(s, a) {
        !t && !Bt(a) && !gn(a) && (a = Le(a));
        const r = Le(this),
          {
            has: i,
            get: l
          } = ga(r);
        let u = i.call(r, s);
        u ? sc(r, i, s) : (s = Le(s), u = i.call(r, s));
        const c = l.call(r, s);
        return r.set(s, a), u ? qn(a, c) && Tn(r, "set", s, a, c) : Tn(r, "add", s, a), this;
      },
      delete(s) {
        const a = Le(this),
          {
            has: r,
            get: i
          } = ga(a);
        let l = r.call(a, s);
        l ? sc(a, r, s) : (s = Le(s), l = r.call(a, s));
        const u = i ? i.call(a, s) : void 0,
          c = a.delete(s);
        return l && Tn(a, "delete", s, void 0, u), c;
      },
      clear() {
        const s = Le(this),
          a = s.size !== 0,
          r = io(s) ? new Map(s) : new Set(s),
          i = s.clear();
        return a && Tn(s, "clear", void 0, void 0, r), i;
      }
    }), ["keys", "values", "entries", Symbol.iterator].forEach(s => {
      n[s] = tm(s, e, t);
    }), n;
  }
  function Da(e, t) {
    const n = nm(e, t);
    return (o, s, a) => s === "__v_isReactive" ? !e : s === "__v_isReadonly" ? e : s === "__v_raw" ? o : Reflect.get(je(n, s) && s in o ? n : o, s, a);
  }
  const om = {
      get: Da(!1, !1)
    },
    sm = {
      get: Da(!1, !0)
    },
    am = {
      get: Da(!0, !1)
    },
    im = {
      get: Da(!0, !0)
    };
  function sc(e, t, n) {
    const o = Le(n);
    if (o !== n && t.call(e, o)) {
      const s = Ni(e);
      Yt(`Reactive ${s} contains both the raw and reactive versions of the same object${s === "Map" ? " as keys" : ""}, which can lead to inconsistencies. Avoid differentiating between the raw and reactive versions of an object and only use the reactive version if possible.`);
    }
  }
  const ac = new WeakMap(),
    ic = new WeakMap(),
    rc = new WeakMap(),
    lc = new WeakMap();
  function rm(e) {
    switch (e) {
      case "Object":
      case "Array":
        return 1;
      case "Map":
      case "Set":
      case "WeakMap":
      case "WeakSet":
        return 2;
      default:
        return 0;
    }
  }
  function lm(e) {
    return e.__v_skip || !Object.isExtensible(e) ? 0 : rm(Ni(e));
  }
  function Xe(e) {
    return gn(e) ? e : Sa(e, !1, Xv, om, ac);
  }
  function ji(e) {
    return Sa(e, !1, Jv, sm, ic);
  }
  function Ds(e) {
    return Sa(e, !0, Zv, am, rc);
  }
  function Zt(e) {
    return Sa(e, !0, em, im, lc);
  }
  function Sa(e, t, n, o, s) {
    if (!ze(e)) return Yt(`value cannot be made ${t ? "readonly" : "reactive"}: ${String(e)}`), e;
    if (e.__v_raw && !(t && e.__v_isReactive)) return e;
    const a = lm(e);
    if (a === 0) return e;
    const r = s.get(e);
    if (r) return r;
    const i = new Proxy(e, a === 2 ? o : n);
    return s.set(e, i), i;
  }
  function _n(e) {
    return gn(e) ? _n(e.__v_raw) : !!(e && e.__v_isReactive);
  }
  function gn(e) {
    return !!(e && e.__v_isReadonly);
  }
  function Bt(e) {
    return !!(e && e.__v_isShallow);
  }
  function Ss(e) {
    return e ? !!e.__v_raw : !1;
  }
  function Le(e) {
    const t = e && e.__v_raw;
    return t ? Le(t) : e;
  }
  function wn(e) {
    return !je(e, "__v_skip") && Object.isExtensible(e) && va(e, "__v_skip", !0), e;
  }
  const It = e => ze(e) ? Xe(e) : e,
    Pa = e => ze(e) ? Ds(e) : e;
  function tt(e) {
    return e ? e.__v_isRef === !0 : !1;
  }
  function H(e) {
    return um(e, !1);
  }
  function um(e, t) {
    return tt(e) ? e : new cm(e, t);
  }
  class cm {
    constructor(t, n) {
      this.dep = new xi(), this.__v_isRef = !0, this.__v_isShallow = !1, this._rawValue = n ? t : Le(t), this._value = n ? t : It(t), this.__v_isShallow = n;
    }
    get value() {
      return this.dep.track({
        target: this,
        type: "get",
        key: "value"
      }), this._value;
    }
    set value(t) {
      const n = this._rawValue,
        o = this.__v_isShallow || Bt(t) || gn(t);
      t = o ? t : Le(t), qn(t, n) && (this._rawValue = t, this._value = o ? t : It(t), this.dep.trigger({
        target: this,
        type: "set",
        key: "value",
        newValue: t,
        oldValue: n
      }));
    }
  }
  function y(e) {
    return tt(e) ? e.value : e;
  }
  const dm = {
    get: (e, t, n) => t === "__v_raw" ? e : y(Reflect.get(e, t, n)),
    set: (e, t, n, o) => {
      const s = e[t];
      return tt(s) && !tt(n) ? (s.value = n, !0) : Reflect.set(e, t, n, o);
    }
  };
  function uc(e) {
    return _n(e) ? e : new Proxy(e, dm);
  }
  function ba(e) {
    Ss(e) || Yt("toRefs() expects a reactive object but received a plain one.");
    const t = Ie(e) ? new Array(e.length) : {};
    for (const n in e) t[n] = cc(e, n);
    return t;
  }
  class fm {
    constructor(t, n, o) {
      this._object = t, this._key = n, this._defaultValue = o, this.__v_isRef = !0, this._value = void 0;
    }
    get value() {
      const t = this._object[this._key];
      return this._value = t === void 0 ? this._defaultValue : t;
    }
    set value(t) {
      this._object[this._key] = t;
    }
    get dep() {
      return zv(Le(this._object), this._key);
    }
  }
  class pm {
    constructor(t) {
      this._getter = t, this.__v_isRef = !0, this.__v_isReadonly = !0, this._value = void 0;
    }
    get value() {
      return this._value = this._getter();
    }
  }
  function Oa(e, t, n) {
    return tt(e) ? e : we(e) ? new pm(e) : ze(e) && arguments.length > 1 ? cc(e, t, n) : H(e);
  }
  function cc(e, t, n) {
    const o = e[t];
    return tt(o) ? o : new fm(e, t, n);
  }
  class _m {
    constructor(t, n, o) {
      this.fn = t, this.setter = n, this._value = void 0, this.dep = new xi(this), this.__v_isRef = !0, this.deps = void 0, this.depsTail = void 0, this.flags = 16, this.globalVersion = Ts - 1, this.next = void 0, this.effect = this, this.__v_isReadonly = !n, this.isSSR = o;
    }
    notify() {
      if (this.flags |= 16, !(this.flags & 8) && et !== this) return zu(this, !0), !0;
    }
    get value() {
      const t = this.dep.track({
        target: this,
        type: "get",
        key: "value"
      });
      return Qu(this), t && (t.version = this.dep.version), this._value;
    }
    set value(t) {
      this.setter ? this.setter(t) : Yt("Write operation failed: computed value is readonly");
    }
  }
  function hm(e, t, n = !1) {
    let o, s;
    return we(e) ? o = e : (o = e.get, s = e.set), new _m(o, s, n);
  }
  const Ea = {},
    Ia = new WeakMap();
  let fo;
  function vm(e, t = !1, n = fo) {
    if (n) {
      let o = Ia.get(n);
      o || Ia.set(n, o = []), o.push(e);
    } else t || Yt("onWatcherCleanup() was called when there was no active watcher to associate with.");
  }
  function mm(e, t, n = Je) {
    const {
        immediate: o,
        deep: s,
        once: a,
        scheduler: r,
        augmentJob: i,
        call: l
      } = n,
      u = A => {
        (n.onWarn || Yt)("Invalid watch source: ", A, "A watch source can only be a getter/effect function, a ref, a reactive object, or an array of these types.");
      },
      c = A => s ? A : Bt(A) || s === !1 || s === 0 ? Ln(A, 1) : Ln(A);
    let d,
      p,
      f,
      v,
      h = !1,
      m = !1;
    if (tt(e) ? (p = () => e.value, h = Bt(e)) : _n(e) ? (p = () => c(e), h = !0) : Ie(e) ? (m = !0, h = e.some(A => _n(A) || Bt(A)), p = () => e.map(A => {
      if (tt(A)) return A.value;
      if (_n(A)) return c(A);
      if (we(A)) return l ? l(A, 2) : A();
      u(A);
    })) : we(e) ? t ? p = l ? () => l(e, 2) : e : p = () => {
      if (f) {
        fn();
        try {
          f();
        } finally {
          pn();
        }
      }
      const A = fo;
      fo = d;
      try {
        return l ? l(e, 3, [v]) : e(v);
      } finally {
        fo = A;
      }
    } : (p = Mt, u(e)), t && s) {
      const A = p,
        j = s === !0 ? 1 / 0 : s;
      p = () => Ln(A(), j);
    }
    const D = Wu(),
      N = () => {
        d.stop(), D && D.active && Ii(D.effects, d);
      };
    if (a && t) {
      const A = t;
      t = (...j) => {
        A(...j), N();
      };
    }
    let I = m ? new Array(e.length).fill(Ea) : Ea;
    const w = A => {
      if (!(!(d.flags & 1) || !d.dirty && !A)) if (t) {
        const j = d.run();
        if (s || h || (m ? j.some((B, T) => qn(B, I[T])) : qn(j, I))) {
          f && f();
          const B = fo;
          fo = d;
          try {
            const T = [j, I === Ea ? void 0 : m && I[0] === Ea ? [] : I, v];
            I = j, l ? l(t, 3, T) : t(...T);
          } finally {
            fo = B;
          }
        }
      } else d.run();
    };
    return i && i(w), d = new Vu(p), d.scheduler = r ? () => r(w, !1) : w, v = A => vm(A, !1, d), f = d.onStop = () => {
      const A = Ia.get(d);
      if (A) {
        if (l) l(A, 4);else for (const j of A) j();
        Ia.delete(d);
      }
    }, d.onTrack = n.onTrack, d.onTrigger = n.onTrigger, t ? o ? w(!0) : I = d.run() : r ? r(w.bind(null, !0), !0) : d.run(), N.pause = d.pause.bind(d), N.resume = d.resume.bind(d), N.stop = N, N;
  }
  function Ln(e, t = 1 / 0, n) {
    if (t <= 0 || !ze(e) || e.__v_skip || (n = n || new Map(), (n.get(e) || 0) >= t)) return e;
    if (n.set(e, t), t--, tt(e)) Ln(e.value, t, n);else if (Ie(e)) for (let o = 0; o < e.length; o++) Ln(e[o], t, n);else if (Lo(e) || io(e)) e.forEach(o => {
      Ln(o, t, n);
    });else if ($u(e)) {
      for (const o in e) Ln(e[o], t, n);
      for (const o of Object.getOwnPropertySymbols(e)) Object.prototype.propertyIsEnumerable.call(e, o) && Ln(e[o], t, n);
    }
    return e;
  }
  var Xn = {
    NODE_ENV: '"production"'
  };
  const po = [];
  function Ra(e) {
    po.push(e);
  }
  function Na() {
    po.pop();
  }
  let zi = !1;
  function Ce(e, ...t) {
    if (zi) return;
    zi = !0, fn();
    const n = po.length ? po[po.length - 1].component : null,
      o = n && n.appContext.config.warnHandler,
      s = Cm();
    if (o) Fo(o, n, 11, [e + t.map(a => {
      var r, i;
      return (i = (r = a.toString) == null ? void 0 : r.call(a)) != null ? i : JSON.stringify(a);
    }).join(""), n && n.proxy, s.map(({
      vnode: a
    }) => `at <${Ya(n, a.type)}>`).join(`
`), s]);else {
      const a = [`[Vue warn]: ${e}`, ...t];
      s.length && a.push(`
`, ...Tm(s)), console.warn(...a);
    }
    pn(), zi = !1;
  }
  function Cm() {
    let e = po[po.length - 1];
    if (!e) return [];
    const t = [];
    for (; e;) {
      const n = t[0];
      n && n.vnode === e ? n.recurseCount++ : t.push({
        vnode: e,
        recurseCount: 0
      });
      const o = e.component && e.component.parent;
      e = o && o.vnode;
    }
    return t;
  }
  function Tm(e) {
    const t = [];
    return e.forEach((n, o) => {
      t.push(...(o === 0 ? [] : [`
`]), ...gm(n));
    }), t;
  }
  function gm({
    vnode: e,
    recurseCount: t
  }) {
    const n = t > 0 ? `... (${t} recursive calls)` : "",
      o = e.component ? e.component.parent == null : !1,
      s = ` at <${Ya(e.component, e.type, o)}`,
      a = ">" + n;
    return e.props ? [s, ...ym(e.props), a] : [s + a];
  }
  function ym(e) {
    const t = [],
      n = Object.keys(e);
    return n.slice(0, 3).forEach(o => {
      t.push(...dc(o, e[o]));
    }), n.length > 3 && t.push(" ..."), t;
  }
  function dc(e, t, n) {
    return at(t) ? (t = JSON.stringify(t), n ? t : [`${e}=${t}`]) : typeof t == "number" || typeof t == "boolean" || t == null ? n ? t : [`${e}=${t}`] : tt(t) ? (t = dc(e, Le(t.value), !0), n ? t : [`${e}=Ref<`, t, ">"]) : we(t) ? [`${e}=fn${t.name ? `<${t.name}>` : ""}`] : (t = Le(t), n ? t : [`${e}=`, t]);
  }
  function Dm(e, t) {
    e !== void 0 && (typeof e != "number" ? Ce(`${t} is not a valid number - got ${JSON.stringify(e)}.`) : isNaN(e) && Ce(`${t} is NaN - the duration expression might be incorrect.`));
  }
  const Ki = {
    sp: "serverPrefetch hook",
    bc: "beforeCreate hook",
    c: "created hook",
    bm: "beforeMount hook",
    m: "mounted hook",
    bu: "beforeUpdate hook",
    u: "updated",
    bum: "beforeUnmount hook",
    um: "unmounted hook",
    a: "activated hook",
    da: "deactivated hook",
    ec: "errorCaptured hook",
    rtc: "renderTracked hook",
    rtg: "renderTriggered hook",
    0: "setup function",
    1: "render function",
    2: "watcher getter",
    3: "watcher callback",
    4: "watcher cleanup function",
    5: "native event handler",
    6: "component event handler",
    7: "vnode hook",
    8: "directive hook",
    9: "transition hook",
    10: "app errorHandler",
    11: "app warnHandler",
    12: "ref function",
    13: "async component loader",
    14: "scheduler flush",
    15: "component update",
    16: "app unmount cleanup function"
  };
  function Fo(e, t, n, o) {
    try {
      return o ? e(...o) : e();
    } catch (s) {
      Uo(s, t, n);
    }
  }
  function hn(e, t, n, o) {
    if (we(e)) {
      const s = Fo(e, t, n, o);
      return s && Ri(s) && s.catch(a => {
        Uo(a, t, n);
      }), s;
    }
    if (Ie(e)) {
      const s = [];
      for (let a = 0; a < e.length; a++) s.push(hn(e[a], t, n, o));
      return s;
    } else Ce(`Invalid value type passed to callWithAsyncErrorHandling(): ${typeof e}`);
  }
  function Uo(e, t, n, o = !0) {
    const s = t ? t.vnode : null,
      {
        errorHandler: a,
        throwUnhandledErrorInProduction: r
      } = t && t.appContext.config || Je;
    if (t) {
      let i = t.parent;
      const l = t.proxy,
        u = Ki[n];
      for (; i;) {
        const c = i.ec;
        if (c) {
          for (let d = 0; d < c.length; d++) if (c[d](e, l, u) === !1) return;
        }
        i = i.parent;
      }
      if (a) {
        fn(), Fo(a, null, 10, [e, l, u]), pn();
        return;
      }
    }
    Sm(e, n, s, o, r);
  }
  function Sm(e, t, n, o = !0, s = !1) {
    {
      const a = Ki[t];
      if (n && Ra(n), Ce(`Unhandled error${a ? ` during execution of ${a}` : ""}`), n && Na(), o) throw e;
      console.error(e);
    }
  }
  const xt = [];
  let yn = -1;
  const Bo = [];
  let Zn = null,
    xo = 0;
  const fc = Promise.resolve();
  let Aa = null;
  const Pm = 100;
  function Ho(e) {
    const t = Aa || fc;
    return e ? t.then(this ? e.bind(this) : e) : t;
  }
  function bm(e) {
    let t = yn + 1,
      n = xt.length;
    for (; t < n;) {
      const o = t + n >>> 1,
        s = xt[o],
        a = Ps(s);
      a < e || a === e && s.flags & 2 ? t = o + 1 : n = o;
    }
    return t;
  }
  function Ma(e) {
    if (!(e.flags & 1)) {
      const t = Ps(e),
        n = xt[xt.length - 1];
      !n || !(e.flags & 2) && t >= Ps(n) ? xt.push(e) : xt.splice(bm(t), 0, e), e.flags |= 1, pc();
    }
  }
  function pc() {
    Aa || (Aa = fc.then(mc));
  }
  function _c(e) {
    Ie(e) ? Bo.push(...e) : Zn && e.id === -1 ? Zn.splice(xo + 1, 0, e) : e.flags & 1 || (Bo.push(e), e.flags |= 1), pc();
  }
  function hc(e, t, n = yn + 1) {
    for (t = t || new Map(); n < xt.length; n++) {
      const o = xt[n];
      if (o && o.flags & 2) {
        if (e && o.id !== e.uid || Yi(t, o)) continue;
        xt.splice(n, 1), n--, o.flags & 4 && (o.flags &= -2), o(), o.flags & 4 || (o.flags &= -2);
      }
    }
  }
  function vc(e) {
    if (Bo.length) {
      const t = [...new Set(Bo)].sort((n, o) => Ps(n) - Ps(o));
      if (Bo.length = 0, Zn) {
        Zn.push(...t);
        return;
      }
      for (Zn = t, e = e || new Map(), xo = 0; xo < Zn.length; xo++) {
        const n = Zn[xo];
        Yi(e, n) || (n.flags & 4 && (n.flags &= -2), n.flags & 8 || n(), n.flags &= -2);
      }
      Zn = null, xo = 0;
    }
  }
  const Ps = e => e.id == null ? e.flags & 2 ? -1 : 1 / 0 : e.id;
  function mc(e) {
    e = e || new Map();
    const t = n => Yi(e, n);
    try {
      for (yn = 0; yn < xt.length; yn++) {
        const n = xt[yn];
        if (n && !(n.flags & 8)) {
          if (Xn.NODE_ENV !== "production" && t(n)) continue;
          n.flags & 4 && (n.flags &= -2), Fo(n, n.i, n.i ? 15 : 14), n.flags & 4 || (n.flags &= -2);
        }
      }
    } finally {
      for (; yn < xt.length; yn++) {
        const n = xt[yn];
        n && (n.flags &= -2);
      }
      yn = -1, xt.length = 0, vc(e), Aa = null, (xt.length || Bo.length) && mc(e);
    }
  }
  function Yi(e, t) {
    const n = e.get(t) || 0;
    if (n > Pm) {
      const o = t.i,
        s = o && Ka(o.type);
      return Uo(`Maximum recursive updates exceeded${s ? ` in component <${s}>` : ""}. This means you have a reactive effect that is mutating its own dependencies and thus recursively triggering itself. Possible sources include component template, render function, updated hook or watcher source function.`, null, 10), !0;
    }
    return e.set(t, n + 1), !1;
  }
  let Dn = !1;
  const wa = new Map();
  {
    const e = vs();
    e.__VUE_HMR_RUNTIME__ || (e.__VUE_HMR_RUNTIME__ = {
      createRecord: Qi(Cc),
      rerender: Qi(Im),
      reload: Qi(Rm)
    });
  }
  const _o = new Map();
  function Om(e) {
    const t = e.type.__hmrId;
    let n = _o.get(t);
    n || (Cc(t, e.type), n = _o.get(t)), n.instances.add(e);
  }
  function Em(e) {
    _o.get(e.type.__hmrId).instances.delete(e);
  }
  function Cc(e, t) {
    return _o.has(e) ? !1 : (_o.set(e, {
      initialDef: La(t),
      instances: new Set()
    }), !0);
  }
  function La(e) {
    return Sd(e) ? e.__vccOpts : e;
  }
  function Im(e, t) {
    const n = _o.get(e);
    n && (n.initialDef.render = t, [...n.instances].forEach(o => {
      t && (o.render = t, La(o.type).render = t), o.renderCache = [], Dn = !0, o.job.flags & 8 || o.update(), Dn = !1;
    }));
  }
  function Rm(e, t) {
    const n = _o.get(e);
    if (!n) return;
    t = La(t), Tc(n.initialDef, t);
    const o = [...n.instances];
    for (let s = 0; s < o.length; s++) {
      const a = o[s],
        r = La(a.type);
      let i = wa.get(r);
      i || (r !== n.initialDef && Tc(r, t), wa.set(r, i = new Set())), i.add(a), a.appContext.propsCache.delete(a.type), a.appContext.emitsCache.delete(a.type), a.appContext.optionsCache.delete(a.type), a.ceReload ? (i.add(a), a.ceReload(t.styles), i.delete(a)) : a.parent ? Ma(() => {
        a.job.flags & 8 || (Dn = !0, a.parent.update(), Dn = !1, i.delete(a));
      }) : a.appContext.reload ? a.appContext.reload() : typeof window < "u" ? window.location.reload() : console.warn("[HMR] Root or manually mounted instance modified. Full reload required."), a.root.ce && a !== a.root && a.root.ce._removeChildStyle(r);
    }
    _c(() => {
      wa.clear();
    });
  }
  function Tc(e, t) {
    ct(e, t);
    for (const n in e) n !== "__file" && !(n in t) && delete e[n];
  }
  function Qi(e) {
    return (t, n) => {
      try {
        return e(t, n);
      } catch (o) {
        console.error(o), console.warn("[HMR] Something went wrong during Vue component hot-reload. Full reload required.");
      }
    };
  }
  let Sn,
    bs = [],
    qi = !1;
  function Os(e, ...t) {
    Sn ? Sn.emit(e, ...t) : qi || bs.push({
      event: e,
      args: t
    });
  }
  function gc(e, t) {
    var n, o;
    Sn = e, Sn ? (Sn.enabled = !0, bs.forEach(({
      event: s,
      args: a
    }) => Sn.emit(s, ...a)), bs = []) : typeof window < "u" && window.HTMLElement && !((o = (n = window.navigator) == null ? void 0 : n.userAgent) != null && o.includes("jsdom")) ? ((t.__VUE_DEVTOOLS_HOOK_REPLAY__ = t.__VUE_DEVTOOLS_HOOK_REPLAY__ || []).push(a => {
      gc(a, t);
    }), setTimeout(() => {
      Sn || (t.__VUE_DEVTOOLS_HOOK_REPLAY__ = null, qi = !0, bs = []);
    }, 3e3)) : (qi = !0, bs = []);
  }
  function Nm(e, t) {
    Os("app:init", e, t, {
      Fragment: q,
      Text: Ms,
      Comment: pt,
      Static: ws
    });
  }
  function Am(e) {
    Os("app:unmount", e);
  }
  const Mm = Xi("component:added"),
    yc = Xi("component:updated"),
    wm = Xi("component:removed"),
    Lm = e => {
      Sn && typeof Sn.cleanupBuffer == "function" && !Sn.cleanupBuffer(e) && wm(e);
    };
  function Xi(e) {
    return t => {
      Os(e, t.appContext.app, t.uid, t.parent ? t.parent.uid : void 0, t);
    };
  }
  const km = Dc("perf:start"),
    $m = Dc("perf:end");
  function Dc(e) {
    return (t, n, o) => {
      Os(e, t.appContext.app, t.uid, t, n, o);
    };
  }
  function Fm(e, t, n) {
    Os("component:emit", e.appContext.app, e, t, n);
  }
  let Ct = null,
    Sc = null;
  function ka(e) {
    const t = Ct;
    return Ct = e, Sc = e && e.type.__scopeId || null, t;
  }
  function fe(e, t = Ct, n) {
    if (!t || e._n) return e;
    const o = (...s) => {
      o._d && Wa(-1);
      const a = ka(t);
      let r;
      try {
        r = e(...s);
      } finally {
        ka(a), o._d && Wa(1);
      }
      return yc(t), r;
    };
    return o._n = !0, o._c = !0, o._d = !0, o;
  }
  function Pc(e) {
    Ev(e) && Ce("Do not use built-in directive ids as custom directive id: " + e);
  }
  function re(e, t) {
    if (Ct === null) return Ce("withDirectives can only be used inside render functions."), e;
    const n = za(Ct),
      o = e.dirs || (e.dirs = []);
    for (let s = 0; s < t.length; s++) {
      let [a, r, i, l = Je] = t[s];
      a && (we(a) && (a = {
        mounted: a,
        updated: a
      }), a.deep && Ln(r), o.push({
        dir: a,
        instance: n,
        value: r,
        oldValue: void 0,
        arg: i,
        modifiers: l
      }));
    }
    return e;
  }
  function ho(e, t, n, o) {
    const s = e.dirs,
      a = t && t.dirs;
    for (let r = 0; r < s.length; r++) {
      const i = s[r];
      a && (i.oldValue = a[r].value);
      let l = i.dir[o];
      l && (fn(), hn(l, n, 8, [e.el, i, e, t]), pn());
    }
  }
  const Um = Symbol("_vte"),
    bc = e => e.__isTeleport,
    kn = Symbol("_leaveCb"),
    $a = Symbol("_enterCb");
  function Bm() {
    const e = {
      isMounted: !1,
      isLeaving: !1,
      isUnmounting: !1,
      leavingVNodes: new Map()
    };
    return Vo(() => {
      e.isMounted = !0;
    }), $c(() => {
      e.isUnmounting = !0;
    }), e;
  }
  const Jt = [Function, Array],
    Oc = {
      mode: String,
      appear: Boolean,
      persisted: Boolean,
      onBeforeEnter: Jt,
      onEnter: Jt,
      onAfterEnter: Jt,
      onEnterCancelled: Jt,
      onBeforeLeave: Jt,
      onLeave: Jt,
      onAfterLeave: Jt,
      onLeaveCancelled: Jt,
      onBeforeAppear: Jt,
      onAppear: Jt,
      onAfterAppear: Jt,
      onAppearCancelled: Jt
    },
    Ec = e => {
      const t = e.subTree;
      return t.component ? Ec(t.component) : t;
    },
    xm = {
      name: "BaseTransition",
      props: Oc,
      setup(e, {
        slots: t
      }) {
        const n = $s(),
          o = Bm();
        return () => {
          const s = t.default && Ac(t.default(), !0);
          if (!s || !s.length) return;
          const a = Ic(s),
            r = Le(e),
            {
              mode: i
            } = r;
          if (i && i !== "in-out" && i !== "out-in" && i !== "default" && Ce(`invalid <transition> mode: ${i}`), o.isLeaving) return Ji(a);
          const l = Nc(a);
          if (!l) return Ji(a);
          let u = Zi(l, r, o, n, d => u = d);
          l.type !== pt && Es(l, u);
          let c = n.subTree && Nc(n.subTree);
          if (c && c.type !== pt && !go(c, l) && Ec(n).type !== pt) {
            let d = Zi(c, r, o, n);
            if (Es(c, d), i === "out-in" && l.type !== pt) return o.isLeaving = !0, d.afterLeave = () => {
              o.isLeaving = !1, n.job.flags & 8 || n.update(), delete d.afterLeave, c = void 0;
            }, Ji(a);
            i === "in-out" && l.type !== pt ? d.delayLeave = (p, f, v) => {
              const h = Rc(o, c);
              h[String(c.key)] = c, p[kn] = () => {
                f(), p[kn] = void 0, delete u.delayedLeave, c = void 0;
              }, u.delayedLeave = () => {
                v(), delete u.delayedLeave, c = void 0;
              };
            } : c = void 0;
          } else c && (c = void 0);
          return a;
        };
      }
    };
  function Ic(e) {
    let t = e[0];
    if (e.length > 1) {
      let n = !1;
      for (const o of e) if (o.type !== pt) {
        if (n) {
          Ce("<transition> can only be used on a single element or component. Use <transition-group> for lists.");
          break;
        }
        t = o, n = !0;
      }
    }
    return t;
  }
  const Hm = xm;
  function Rc(e, t) {
    const {
      leavingVNodes: n
    } = e;
    let o = n.get(t.type);
    return o || (o = Object.create(null), n.set(t.type, o)), o;
  }
  function Zi(e, t, n, o, s) {
    const {
        appear: a,
        mode: r,
        persisted: i = !1,
        onBeforeEnter: l,
        onEnter: u,
        onAfterEnter: c,
        onEnterCancelled: d,
        onBeforeLeave: p,
        onLeave: f,
        onAfterLeave: v,
        onLeaveCancelled: h,
        onBeforeAppear: m,
        onAppear: D,
        onAfterAppear: N,
        onAppearCancelled: I
      } = t,
      w = String(e.key),
      A = Rc(n, e),
      j = (g, C) => {
        g && hn(g, o, 9, C);
      },
      B = (g, C) => {
        const S = C[1];
        j(g, C), Ie(g) ? g.every(R => R.length <= 1) && S() : g.length <= 1 && S();
      },
      T = {
        mode: r,
        persisted: i,
        beforeEnter(g) {
          let C = l;
          if (!n.isMounted) if (a) C = m || l;else return;
          g[kn] && g[kn](!0);
          const S = A[w];
          S && go(e, S) && S.el[kn] && S.el[kn](), j(C, [g]);
        },
        enter(g) {
          let C = u,
            S = c,
            R = d;
          if (!n.isMounted) if (a) C = D || u, S = N || c, R = I || d;else return;
          let E = !1;
          const L = g[$a] = G => {
            E || (E = !0, G ? j(R, [g]) : j(S, [g]), T.delayedLeave && T.delayedLeave(), g[$a] = void 0);
          };
          C ? B(C, [g, L]) : L();
        },
        leave(g, C) {
          const S = String(e.key);
          if (g[$a] && g[$a](!0), n.isUnmounting) return C();
          j(p, [g]);
          let R = !1;
          const E = g[kn] = L => {
            R || (R = !0, C(), L ? j(h, [g]) : j(v, [g]), g[kn] = void 0, A[S] === e && delete A[S]);
          };
          A[S] = e, f ? B(f, [g, E]) : E();
        },
        clone(g) {
          const C = Zi(g, t, n, o, s);
          return s && s(C), C;
        }
      };
    return T;
  }
  function Ji(e) {
    if (Wo(e)) return e = Pn(e), e.children = null, e;
  }
  function Nc(e) {
    if (!Wo(e)) return bc(e.type) && e.children ? Ic(e.children) : e;
    if (e.component) return e.component.subTree;
    const {
      shapeFlag: t,
      children: n
    } = e;
    if (n) {
      if (t & 16) return n[0];
      if (t & 32 && we(n.default)) return n.default();
    }
  }
  function Es(e, t) {
    e.shapeFlag & 6 && e.component ? (e.transition = t, Es(e.component.subTree, t)) : e.shapeFlag & 128 ? (e.ssContent.transition = t.clone(e.ssContent), e.ssFallback.transition = t.clone(e.ssFallback)) : e.transition = t;
  }
  function Ac(e, t = !1, n) {
    let o = [],
      s = 0;
    for (let a = 0; a < e.length; a++) {
      let r = e[a];
      const i = n == null ? r.key : String(n) + String(r.key != null ? r.key : a);
      r.type === q ? (r.patchFlag & 128 && s++, o = o.concat(Ac(r.children, t, i))) : (t || r.type !== pt) && o.push(i != null ? Pn(r, {
        key: i
      }) : r);
    }
    if (s > 1) for (let a = 0; a < o.length; a++) o[a].patchFlag = -2;
    return o;
  }
  function oe(e, t) {
    return we(e) ? ct({
      name: e.name
    }, t, {
      setup: e
    }) : e;
  }
  function er(e) {
    e.ids = [e.ids[0] + e.ids[2]++ + "-", 0, 0];
  }
  const Mc = new WeakSet(),
    Fa = new WeakMap();
  function Is(e, t, n, o, s = !1) {
    if (Ie(e)) {
      e.forEach((h, m) => Is(h, t && (Ie(t) ? t[m] : t), n, o, s));
      return;
    }
    if (Go(o) && !s) {
      o.shapeFlag & 512 && o.type.__asyncResolved && o.component.subTree.component && Is(e, t, n, o.component.subTree);
      return;
    }
    const a = o.shapeFlag & 4 ? za(o.component) : o.el,
      r = s ? null : a,
      {
        i,
        r: l
      } = e;
    if (!i) {
      Ce("Missing ref owner context. ref cannot be used on hoisted vnodes. A vnode with ref must be created inside the render function.");
      return;
    }
    const u = t && t.r,
      c = i.refs === Je ? i.refs = {} : i.refs,
      d = i.setupState,
      p = Le(d),
      f = d === Je ? wu : h => (je(p, h) && !tt(p[h]) && Ce(`Template ref "${h}" used on a non-ref value. It will not work in the production build.`), Mc.has(p[h]) ? !1 : je(p, h)),
      v = h => !Mc.has(h);
    if (u != null && u !== l) {
      if (wc(t), at(u)) c[u] = null, f(u) && (d[u] = null);else if (tt(u)) {
        v(u) && (u.value = null);
        const h = t;
        h.k && (c[h.k] = null);
      }
    }
    if (we(l)) Fo(l, i, 12, [r, c]);else {
      const h = at(l),
        m = tt(l);
      if (h || m) {
        const D = () => {
          if (e.f) {
            const N = h ? f(l) ? d[l] : c[l] : v(l) || !e.k ? l.value : c[e.k];
            if (s) Ie(N) && Ii(N, a);else if (Ie(N)) N.includes(a) || N.push(a);else if (h) c[l] = [a], f(l) && (d[l] = c[l]);else {
              const I = [a];
              v(l) && (l.value = I), e.k && (c[e.k] = I);
            }
          } else h ? (c[l] = r, f(l) && (d[l] = r)) : m ? (v(l) && (l.value = r), e.k && (c[e.k] = r)) : Ce("Invalid template ref type:", l, `(${typeof l})`);
        };
        if (r) {
          const N = () => {
            D(), Fa.delete(e);
          };
          N.id = -1, Fa.set(e, N), Qt(N, n);
        } else wc(e), D();
      } else Ce("Invalid template ref type:", l, `(${typeof l})`);
    }
  }
  function wc(e) {
    const t = Fa.get(e);
    t && (t.flags |= 8, Fa.delete(e));
  }
  const Lc = e => e.nodeType === 8;
  vs().requestIdleCallback, vs().cancelIdleCallback;
  function Gm(e, t) {
    if (Lc(e) && e.data === "[") {
      let n = 1,
        o = e.nextSibling;
      for (; o;) {
        if (o.nodeType === 1) {
          if (t(o) === !1) break;
        } else if (Lc(o)) if (o.data === "]") {
          if (--n === 0) break;
        } else o.data === "[" && n++;
        o = o.nextSibling;
      }
    } else t(e);
  }
  const Go = e => !!e.type.__asyncLoader;
  function $n(e) {
    we(e) && (e = {
      loader: e
    });
    const {
      loader: t,
      loadingComponent: n,
      errorComponent: o,
      delay: s = 200,
      hydrate: a,
      timeout: r,
      suspensible: i = !0,
      onError: l
    } = e;
    let u = null,
      c,
      d = 0;
    const p = () => (d++, u = null, f()),
      f = () => {
        let v;
        return u || (v = u = t().catch(h => {
          if (h = h instanceof Error ? h : new Error(String(h)), l) return new Promise((m, D) => {
            l(h, () => m(p()), () => D(h), d + 1);
          });
          throw h;
        }).then(h => {
          if (v !== u && u) return u;
          if (h || Ce("Async component loader resolved to undefined. If you are using retry(), make sure to return its return value."), h && (h.__esModule || h[Symbol.toStringTag] === "Module") && (h = h.default), h && !ze(h) && !we(h)) throw new Error(`Invalid async component load result: ${h}`);
          return c = h, h;
        }));
      };
    return oe({
      name: "AsyncComponentWrapper",
      __asyncLoader: f,
      __asyncHydrate(v, h, m) {
        let D = !1;
        (h.bu || (h.bu = [])).push(() => D = !0);
        const N = () => {
            if (D) {
              Ce(`Skipping lazy hydration for component '${Ka(c) || c.__file}': it was updated before lazy hydration performed.`);
              return;
            }
            m();
          },
          I = a ? () => {
            const w = a(N, A => Gm(v, A));
            w && (h.bum || (h.bum = [])).push(w);
          } : N;
        c ? I() : f().then(() => !h.isUnmounted && I());
      },
      get __asyncResolved() {
        return c;
      },
      setup() {
        const v = Tt;
        if (er(v), c) return () => tr(c, v);
        const h = I => {
          u = null, Uo(I, v, 13, !o);
        };
        if (i && v.suspense || Qo) return f().then(I => () => tr(I, v)).catch(I => (h(I), () => o ? ne(o, {
          error: I
        }) : null));
        const m = H(!1),
          D = H(),
          N = H(!!s);
        return s && setTimeout(() => {
          N.value = !1;
        }, s), r != null && setTimeout(() => {
          if (!m.value && !D.value) {
            const I = new Error(`Async component timed out after ${r}ms.`);
            h(I), D.value = I;
          }
        }, r), f().then(() => {
          m.value = !0, v.parent && Wo(v.parent.vnode) && v.parent.update();
        }).catch(I => {
          h(I), D.value = I;
        }), () => {
          if (m.value && c) return tr(c, v);
          if (D.value && o) return ne(o, {
            error: D.value
          });
          if (n && !N.value) return ne(n);
        };
      }
    });
  }
  function tr(e, t) {
    const {
        ref: n,
        props: o,
        children: s,
        ce: a
      } = t.vnode,
      r = ne(e, o, s);
    return r.ref = n, r.ce = a, delete t.vnode.ce, r;
  }
  const Wo = e => e.type.__isKeepAlive;
  function Wm(e, t) {
    kc(e, "a", t);
  }
  function Vm(e, t) {
    kc(e, "da", t);
  }
  function kc(e, t, n = Tt) {
    const o = e.__wdc || (e.__wdc = () => {
      let s = n;
      for (; s;) {
        if (s.isDeactivated) return;
        s = s.parent;
      }
      return e();
    });
    if (Ua(t, o, n), n) {
      let s = n.parent;
      for (; s && s.parent;) Wo(s.parent.vnode) && jm(o, t, n, s), s = s.parent;
    }
  }
  function jm(e, t, n, o) {
    const s = Ua(t, e, o, !0);
    Rs(() => {
      Ii(o[t], s);
    }, n);
  }
  function Ua(e, t, n = Tt, o = !1) {
    if (n) {
      const s = n[e] || (n[e] = []),
        a = t.__weh || (t.__weh = (...r) => {
          fn();
          const i = Fs(n),
            l = hn(t, n, e, r);
          return i(), pn(), l;
        });
      return o ? s.unshift(a) : s.push(a), a;
    } else {
      const s = lo(Ki[e].replace(/ hook$/, ""));
      Ce(`${s} is called when there is no active component instance to be associated with. Lifecycle injection APIs can only be used during execution of setup(). If you are using async setup(), make sure to register lifecycle hooks before the first await statement.`);
    }
  }
  const Fn = e => (t, n = Tt) => {
      (!Qo || e === "sp") && Ua(e, (...o) => t(...o), n);
    },
    zm = Fn("bm"),
    Vo = Fn("m"),
    Km = Fn("bu"),
    Ym = Fn("u"),
    $c = Fn("bum"),
    Rs = Fn("um"),
    Qm = Fn("sp"),
    qm = Fn("rtg"),
    Xm = Fn("rtc");
  function Zm(e, t = Tt) {
    Ua("ec", e, t);
  }
  const nr = "components",
    Jm = "directives",
    Fc = Symbol.for("v-ndc");
  function jo(e) {
    return at(e) ? Uc(nr, e, !1) || e : e || Fc;
  }
  function it(e) {
    return Uc(Jm, e);
  }
  function Uc(e, t, n = !0, o = !1) {
    const s = Ct || Tt;
    if (s) {
      const a = s.type;
      if (e === nr) {
        const i = Ka(a, !1);
        if (i && (i === t || i === Ut(t) || i === ro(Ut(t)))) return a;
      }
      const r = Bc(s[e] || a[e], t) || Bc(s.appContext[e], t);
      if (!r && o) return a;
      if (n && !r) {
        const i = e === nr ? `
If this is a native custom element, make sure to exclude it from component resolution via compilerOptions.isCustomElement.` : "";
        Ce(`Failed to resolve ${e.slice(0, -1)}: ${t}${i}`);
      }
      return r;
    } else Ce(`resolve${ro(e.slice(0, -1))} can only be used in render() or setup().`);
  }
  function Bc(e, t) {
    return e && (e[t] || e[Ut(t)] || e[ro(Ut(t))]);
  }
  function ce(e, t, n, o) {
    let s;
    const a = n,
      r = Ie(e);
    if (r || at(e)) {
      const i = r && _n(e);
      let l = !1,
        u = !1;
      i && (l = !Bt(e), u = gn(e), e = Ta(e)), s = new Array(e.length);
      for (let c = 0, d = e.length; c < d; c++) s[c] = t(l ? u ? Pa(It(e[c])) : It(e[c]) : e[c], c, void 0, a);
    } else if (typeof e == "number") {
      Number.isInteger(e) || Ce(`The v-for range expect an integer value but got ${e}.`), s = new Array(e);
      for (let i = 0; i < e; i++) s[i] = t(i + 1, i, void 0, a);
    } else if (ze(e)) {
      if (e[Symbol.iterator]) s = Array.from(e, (i, l) => t(i, l, void 0, a));else {
        const i = Object.keys(e);
        s = new Array(i.length);
        for (let l = 0, u = i.length; l < u; l++) {
          const c = i[l];
          s[l] = t(e[c], c, l, a);
        }
      }
    } else s = [];
    return s;
  }
  function eC(e, t) {
    for (let n = 0; n < t.length; n++) {
      const o = t[n];
      if (Ie(o)) for (let s = 0; s < o.length; s++) e[o[s].name] = o[s].fn;else o && (e[o.name] = o.key ? (...s) => {
        const a = o.fn(...s);
        return a && (a.key = o.key), a;
      } : o.fn);
    }
    return e;
  }
  function or(e, t, n = {}, o, s) {
    if (Ct.ce || Ct.parent && Go(Ct.parent) && Ct.parent.ce) return t !== "default" && (n.name = t), _(), V(q, null, [ne("slot", n, o)], 64);
    let a = e[t];
    a && a.length > 1 && (Ce("SSR-optimized slot function detected in a non-SSR-optimized render function. You need to mark this component with $dynamic-slots in the parent template."), a = () => []), a && a._c && (a._d = !1), _();
    const r = a && xc(a(n)),
      i = n.key || r && r.key,
      l = V(q, {
        key: (i && !cn(i) ? i : `_${t}`) + (!r && o ? "_fb" : "")
      }, r || [], r && e._ === 1 ? 64 : -2);
    return !s && l.scopeId && (l.slotScopeIds = [l.scopeId + "-s"]), a && a._c && (a._d = !0), l;
  }
  function xc(e) {
    return e.some(t => To(t) ? !(t.type === pt || t.type === q && !xc(t.children)) : !0) ? e : null;
  }
  const sr = e => e ? gd(e) ? za(e) : sr(e.parent) : null,
    vo = ct(Object.create(null), {
      $: e => e,
      $el: e => e.vnode.el,
      $data: e => e.data,
      $props: e => Zt(e.props),
      $attrs: e => Zt(e.attrs),
      $slots: e => Zt(e.slots),
      $refs: e => Zt(e.refs),
      $parent: e => sr(e.parent),
      $root: e => sr(e.root),
      $host: e => e.ce,
      $emit: e => e.emit,
      $options: e => jc(e),
      $forceUpdate: e => e.f || (e.f = () => {
        Ma(e.update);
      }),
      $nextTick: e => e.n || (e.n = Ho.bind(e.proxy)),
      $watch: e => wC.bind(e)
    }),
    ar = e => e === "_" || e === "$",
    ir = (e, t) => e !== Je && !e.__isScriptSetup && je(e, t),
    Hc = {
      get({
        _: e
      }, t) {
        if (t === "__v_skip") return !0;
        const {
          ctx: n,
          setupState: o,
          data: s,
          props: a,
          accessCache: r,
          type: i,
          appContext: l
        } = e;
        if (t === "__isVue") return !0;
        let u;
        if (t[0] !== "$") {
          const f = r[t];
          if (f !== void 0) switch (f) {
            case 1:
              return o[t];
            case 2:
              return s[t];
            case 4:
              return n[t];
            case 3:
              return a[t];
          } else {
            if (ir(o, t)) return r[t] = 1, o[t];
            if (s !== Je && je(s, t)) return r[t] = 2, s[t];
            if ((u = e.propsOptions[0]) && je(u, t)) return r[t] = 3, a[t];
            if (n !== Je && je(n, t)) return r[t] = 4, n[t];
            rr && (r[t] = 0);
          }
        }
        const c = vo[t];
        let d, p;
        if (c) return t === "$attrs" ? (Pt(e.attrs, "get", ""), Ga()) : t === "$slots" && Pt(e, "get", t), c(e);
        if ((d = i.__cssModules) && (d = d[t])) return d;
        if (n !== Je && je(n, t)) return r[t] = 4, n[t];
        if (p = l.config.globalProperties, je(p, t)) return p[t];
        Ct && (!at(t) || t.indexOf("__v") !== 0) && (s !== Je && ar(t[0]) && je(s, t) ? Ce(`Property ${JSON.stringify(t)} must be accessed via $data because it starts with a reserved character ("$" or "_") and is not proxied on the render context.`) : e === Ct && Ce(`Property ${JSON.stringify(t)} was accessed during render but is not defined on instance.`));
      },
      set({
        _: e
      }, t, n) {
        const {
          data: o,
          setupState: s,
          ctx: a
        } = e;
        return ir(s, t) ? (s[t] = n, !0) : s.__isScriptSetup && je(s, t) ? (Ce(`Cannot mutate <script setup> binding "${t}" from Options API.`), !1) : o !== Je && je(o, t) ? (o[t] = n, !0) : je(e.props, t) ? (Ce(`Attempting to mutate prop "${t}". Props are readonly.`), !1) : t[0] === "$" && t.slice(1) in e ? (Ce(`Attempting to mutate public property "${t}". Properties starting with $ are reserved and readonly.`), !1) : (t in e.appContext.config.globalProperties ? Object.defineProperty(a, t, {
          enumerable: !0,
          configurable: !0,
          value: n
        }) : a[t] = n, !0);
      },
      has({
        _: {
          data: e,
          setupState: t,
          accessCache: n,
          ctx: o,
          appContext: s,
          propsOptions: a,
          type: r
        }
      }, i) {
        let l, u;
        return !!(n[i] || e !== Je && i[0] !== "$" && je(e, i) || ir(t, i) || (l = a[0]) && je(l, i) || je(o, i) || je(vo, i) || je(s.config.globalProperties, i) || (u = r.__cssModules) && u[i]);
      },
      defineProperty(e, t, n) {
        return n.get != null ? e._.accessCache[t] = 0 : je(n, "value") && this.set(e, t, n.value, null), Reflect.defineProperty(e, t, n);
      }
    };
  Hc.ownKeys = e => (Ce("Avoid app logic that relies on enumerating keys on a component instance. The keys will be empty in production mode to avoid performance overhead."), Reflect.ownKeys(e));
  function tC(e) {
    const t = {};
    return Object.defineProperty(t, "_", {
      configurable: !0,
      enumerable: !1,
      get: () => e
    }), Object.keys(vo).forEach(n => {
      Object.defineProperty(t, n, {
        configurable: !0,
        enumerable: !1,
        get: () => vo[n](e),
        set: Mt
      });
    }), t;
  }
  function nC(e) {
    const {
      ctx: t,
      propsOptions: [n]
    } = e;
    n && Object.keys(n).forEach(o => {
      Object.defineProperty(t, o, {
        enumerable: !0,
        configurable: !0,
        get: () => e.props[o],
        set: Mt
      });
    });
  }
  function oC(e) {
    const {
      ctx: t,
      setupState: n
    } = e;
    Object.keys(Le(n)).forEach(o => {
      if (!n.__isScriptSetup) {
        if (ar(o[0])) {
          Ce(`setup() return property ${JSON.stringify(o)} should not start with "$" or "_" which are reserved prefixes for Vue internals.`);
          return;
        }
        Object.defineProperty(t, o, {
          enumerable: !0,
          configurable: !0,
          get: () => n[o],
          set: Mt
        });
      }
    });
  }
  function Gc(e) {
    return Ie(e) ? e.reduce((t, n) => (t[n] = null, t), {}) : e;
  }
  function sC() {
    const e = Object.create(null);
    return (t, n) => {
      e[n] ? Ce(`${t} property "${n}" is already defined in ${e[n]}.`) : e[n] = t;
    };
  }
  let rr = !0;
  function aC(e) {
    const t = jc(e),
      n = e.proxy,
      o = e.ctx;
    rr = !1, t.beforeCreate && Wc(t.beforeCreate, e, "bc");
    const {
        data: s,
        computed: a,
        methods: r,
        watch: i,
        provide: l,
        inject: u,
        created: c,
        beforeMount: d,
        mounted: p,
        beforeUpdate: f,
        updated: v,
        activated: h,
        deactivated: m,
        beforeDestroy: D,
        beforeUnmount: N,
        destroyed: I,
        unmounted: w,
        render: A,
        renderTracked: j,
        renderTriggered: B,
        errorCaptured: T,
        serverPrefetch: g,
        expose: C,
        inheritAttrs: S,
        components: R,
        directives: E,
        filters: L
      } = t,
      G = sC();
    {
      const [K] = e.propsOptions;
      if (K) for (const de in K) G("Props", de);
    }
    if (u && iC(u, o, G), r) for (const K in r) {
      const de = r[K];
      we(de) ? (Object.defineProperty(o, K, {
        value: de.bind(n),
        configurable: !0,
        enumerable: !0,
        writable: !0
      }), G("Methods", K)) : Ce(`Method "${K}" has type "${typeof de}" in the component definition. Did you reference the function correctly?`);
    }
    if (s) {
      we(s) || Ce("The data option must be a function. Plain object usage is no longer supported.");
      const K = s.call(n, n);
      if (Ri(K) && Ce("data() returned a Promise - note data() cannot be async; If you intend to perform data fetching before component renders, use async setup() + <Suspense>."), !ze(K)) Ce("data() should return an object.");else {
        e.data = Xe(K);
        for (const de in K) G("Data", de), ar(de[0]) || Object.defineProperty(o, de, {
          configurable: !0,
          enumerable: !0,
          get: () => K[de],
          set: Mt
        });
      }
    }
    if (rr = !0, a) for (const K in a) {
      const de = a[K],
        be = we(de) ? de.bind(n, n) : we(de.get) ? de.get.bind(n, n) : Mt;
      be === Mt && Ce(`Computed property "${K}" has no getter.`);
      const xe = !we(de) && we(de.set) ? de.set.bind(n) : () => {
          Ce(`Write operation failed: computed property "${K}" is readonly.`);
        },
        ee = b({
          get: be,
          set: xe
        });
      Object.defineProperty(o, K, {
        enumerable: !0,
        configurable: !0,
        get: () => ee.value,
        set: M => ee.value = M
      }), G("Computed", K);
    }
    if (i) for (const K in i) Vc(i[K], o, n, K);
    if (l) {
      const K = we(l) ? l.call(n) : l;
      Reflect.ownKeys(K).forEach(de => {
        fC(de, K[de]);
      });
    }
    c && Wc(c, e, "c");
    function X(K, de) {
      Ie(de) ? de.forEach(be => K(be.bind(n))) : de && K(de.bind(n));
    }
    if (X(zm, d), X(Vo, p), X(Km, f), X(Ym, v), X(Wm, h), X(Vm, m), X(Zm, T), X(Xm, j), X(qm, B), X($c, N), X(Rs, w), X(Qm, g), Ie(C)) if (C.length) {
      const K = e.exposed || (e.exposed = {});
      C.forEach(de => {
        Object.defineProperty(K, de, {
          get: () => n[de],
          set: be => n[de] = be,
          enumerable: !0
        });
      });
    } else e.exposed || (e.exposed = {});
    A && e.render === Mt && (e.render = A), S != null && (e.inheritAttrs = S), R && (e.components = R), E && (e.directives = E), g && er(e);
  }
  function iC(e, t, n = Mt) {
    Ie(e) && (e = lr(e));
    for (const o in e) {
      const s = e[o];
      let a;
      ze(s) ? "default" in s ? a = Te(s.from || o, s.default, !0) : a = Te(s.from || o) : a = Te(s), tt(a) ? Object.defineProperty(t, o, {
        enumerable: !0,
        configurable: !0,
        get: () => a.value,
        set: r => a.value = r
      }) : t[o] = a, n("Inject", o);
    }
  }
  function Wc(e, t, n) {
    hn(Ie(e) ? e.map(o => o.bind(t.proxy)) : e.bind(t.proxy), t, n);
  }
  function Vc(e, t, n, o) {
    let s = o.includes(".") ? ud(n, o) : () => n[o];
    if (at(e)) {
      const a = t[e];
      we(a) ? U(s, a) : Ce(`Invalid watch handler specified by key "${e}"`, a);
    } else if (we(e)) U(s, e.bind(n));else if (ze(e)) {
      if (Ie(e)) e.forEach(a => Vc(a, t, n, o));else {
        const a = we(e.handler) ? e.handler.bind(n) : t[e.handler];
        we(a) ? U(s, a, e) : Ce(`Invalid watch handler specified by key "${e.handler}"`, a);
      }
    } else Ce(`Invalid watch option: "${o}"`, e);
  }
  function jc(e) {
    const t = e.type,
      {
        mixins: n,
        extends: o
      } = t,
      {
        mixins: s,
        optionsCache: a,
        config: {
          optionMergeStrategies: r
        }
      } = e.appContext,
      i = a.get(t);
    let l;
    return i ? l = i : !s.length && !n && !o ? l = t : (l = {}, s.length && s.forEach(u => Ba(l, u, r, !0)), Ba(l, t, r)), ze(t) && a.set(t, l), l;
  }
  function Ba(e, t, n, o = !1) {
    const {
      mixins: s,
      extends: a
    } = t;
    a && Ba(e, a, n, !0), s && s.forEach(r => Ba(e, r, n, !0));
    for (const r in t) if (o && r === "expose") Ce('"expose" option is ignored when declared in mixins or extends. It should only be declared in the base component itself.');else {
      const i = rC[r] || n && n[r];
      e[r] = i ? i(e[r], t[r]) : t[r];
    }
    return e;
  }
  const rC = {
    data: zc,
    props: Kc,
    emits: Kc,
    methods: Ns,
    computed: Ns,
    beforeCreate: Ht,
    created: Ht,
    beforeMount: Ht,
    mounted: Ht,
    beforeUpdate: Ht,
    updated: Ht,
    beforeDestroy: Ht,
    beforeUnmount: Ht,
    destroyed: Ht,
    unmounted: Ht,
    activated: Ht,
    deactivated: Ht,
    errorCaptured: Ht,
    serverPrefetch: Ht,
    components: Ns,
    directives: Ns,
    watch: uC,
    provide: zc,
    inject: lC
  };
  function zc(e, t) {
    return t ? e ? function () {
      return ct(we(e) ? e.call(this, this) : e, we(t) ? t.call(this, this) : t);
    } : t : e;
  }
  function lC(e, t) {
    return Ns(lr(e), lr(t));
  }
  function lr(e) {
    if (Ie(e)) {
      const t = {};
      for (let n = 0; n < e.length; n++) t[e[n]] = e[n];
      return t;
    }
    return e;
  }
  function Ht(e, t) {
    return e ? [...new Set([].concat(e, t))] : t;
  }
  function Ns(e, t) {
    return e ? ct(Object.create(null), e, t) : t;
  }
  function Kc(e, t) {
    return e ? Ie(e) && Ie(t) ? [...new Set([...e, ...t])] : ct(Object.create(null), Gc(e), Gc(t ?? {})) : t;
  }
  function uC(e, t) {
    if (!e) return t;
    if (!t) return e;
    const n = ct(Object.create(null), e);
    for (const o in t) n[o] = Ht(e[o], t[o]);
    return n;
  }
  function Yc() {
    return {
      app: null,
      config: {
        isNativeTag: wu,
        performance: !1,
        globalProperties: {},
        optionMergeStrategies: {},
        errorHandler: void 0,
        warnHandler: void 0,
        compilerOptions: {}
      },
      mixins: [],
      components: {},
      directives: {},
      provides: Object.create(null),
      optionsCache: new WeakMap(),
      propsCache: new WeakMap(),
      emitsCache: new WeakMap()
    };
  }
  let cC = 0;
  function dC(e, t) {
    return function (o, s = null) {
      we(o) || (o = ct({}, o)), s != null && !ze(s) && (Ce("root props passed to app.mount() must be an object."), s = null);
      const a = Yc(),
        r = new WeakSet(),
        i = [];
      let l = !1;
      const u = a.app = {
        _uid: cC++,
        _component: o,
        _props: s,
        _container: null,
        _context: a,
        _instance: null,
        version: Pd,
        get config() {
          return a.config;
        },
        set config(c) {
          Ce("app.config cannot be replaced. Modify individual options instead.");
        },
        use(c, ...d) {
          return r.has(c) ? Ce("Plugin has already been applied to target app.") : c && we(c.install) ? (r.add(c), c.install(u, ...d)) : we(c) ? (r.add(c), c(u, ...d)) : Ce('A plugin must either be a function or an object with an "install" function.'), u;
        },
        mixin(c) {
          return a.mixins.includes(c) ? Ce("Mixin has already been applied to target app" + (c.name ? `: ${c.name}` : "")) : a.mixins.push(c), u;
        },
        component(c, d) {
          return gr(c, a.config), d ? (a.components[c] && Ce(`Component "${c}" has already been registered in target app.`), a.components[c] = d, u) : a.components[c];
        },
        directive(c, d) {
          return Pc(c), d ? (a.directives[c] && Ce(`Directive "${c}" has already been registered in target app.`), a.directives[c] = d, u) : a.directives[c];
        },
        mount(c, d, p) {
          if (l) Ce("App has already been mounted.\nIf you want to remount the same app, move your app creation logic into a factory function and create fresh app instances for each mount - e.g. `const createMyApp = () => createApp(App)`");else {
            c.__vue_app__ && Ce("There is already an app instance mounted on the host container.\n If you want to mount another app on the same host container, you need to unmount the previous app by calling `app.unmount()` first.");
            const f = u._ceVNode || ne(o, s);
            return f.appContext = a, p === !0 ? p = "svg" : p === !1 && (p = void 0), a.reload = () => {
              const v = Pn(f);
              v.el = null, e(v, c, p);
            }, e(f, c, p), l = !0, u._container = c, c.__vue_app__ = u, u._instance = f.component, Nm(u, Pd), za(f.component);
          }
        },
        onUnmount(c) {
          typeof c != "function" && Ce(`Expected function as first argument to app.onUnmount(), but got ${typeof c}`), i.push(c);
        },
        unmount() {
          l ? (hn(i, u._instance, 16), e(null, u._container), u._instance = null, Am(u), delete u._container.__vue_app__) : Ce("Cannot unmount an app that is not mounted.");
        },
        provide(c, d) {
          return c in a.provides && (je(a.provides, c) ? Ce(`App already provides property with key "${String(c)}". It will be overwritten with the new value.`) : Ce(`App already provides property with key "${String(c)}" inherited from its parent element. It will be overwritten with the new value.`)), a.provides[c] = d, u;
        },
        runWithContext(c) {
          const d = mo;
          mo = u;
          try {
            return c();
          } finally {
            mo = d;
          }
        }
      };
      return u;
    };
  }
  let mo = null;
  function fC(e, t) {
    if (!Tt) Ce("provide() can only be used inside setup().");else {
      let n = Tt.provides;
      const o = Tt.parent && Tt.parent.provides;
      o === n && (n = Tt.provides = Object.create(o)), n[e] = t;
    }
  }
  function Te(e, t, n = !1) {
    const o = $s();
    if (o || mo) {
      let s = mo ? mo._context.provides : o ? o.parent == null || o.ce ? o.vnode.appContext && o.vnode.appContext.provides : o.parent.provides : void 0;
      if (s && e in s) return s[e];
      if (arguments.length > 1) return n && we(t) ? t.call(o && o.proxy) : t;
      Ce(`injection "${String(e)}" not found.`);
    } else Ce("inject() can only be used inside setup() or functional components.");
  }
  function Qc() {
    return !!($s() || mo);
  }
  const qc = {},
    Xc = () => Object.create(qc),
    Zc = e => Object.getPrototypeOf(e) === qc;
  function pC(e, t, n, o = !1) {
    const s = {},
      a = Xc();
    e.propsDefaults = Object.create(null), Jc(e, t, s, a);
    for (const r in e.propsOptions[0]) r in s || (s[r] = void 0);
    nd(t || {}, s, e), n ? e.props = o ? s : ji(s) : e.type.props ? e.props = s : e.props = a, e.attrs = a;
  }
  function _C(e) {
    for (; e;) {
      if (e.type.__hmrId) return !0;
      e = e.parent;
    }
  }
  function hC(e, t, n, o) {
    const {
        props: s,
        attrs: a,
        vnode: {
          patchFlag: r
        }
      } = e,
      i = Le(s),
      [l] = e.propsOptions;
    let u = !1;
    if (!_C(e) && (o || r > 0) && !(r & 16)) {
      if (r & 8) {
        const c = e.vnode.dynamicProps;
        for (let d = 0; d < c.length; d++) {
          let p = c[d];
          if (Ha(e.emitsOptions, p)) continue;
          const f = t[p];
          if (l) {
            if (je(a, p)) f !== a[p] && (a[p] = f, u = !0);else {
              const v = Ut(p);
              s[v] = ur(l, i, v, f, e, !1);
            }
          } else f !== a[p] && (a[p] = f, u = !0);
        }
      }
    } else {
      Jc(e, t, s, a) && (u = !0);
      let c;
      for (const d in i) (!t || !je(t, d) && ((c = Qn(d)) === d || !je(t, c))) && (l ? n && (n[d] !== void 0 || n[c] !== void 0) && (s[d] = ur(l, i, d, void 0, e, !0)) : delete s[d]);
      if (a !== i) for (const d in a) (!t || !je(t, d)) && (delete a[d], u = !0);
    }
    u && Tn(e.attrs, "set", ""), nd(t || {}, s, e);
  }
  function Jc(e, t, n, o) {
    const [s, a] = e.propsOptions;
    let r = !1,
      i;
    if (t) for (let l in t) {
      if (hs(l)) continue;
      const u = t[l];
      let c;
      s && je(s, c = Ut(l)) ? !a || !a.includes(c) ? n[c] = u : (i || (i = {}))[c] = u : Ha(e.emitsOptions, l) || (!(l in o) || u !== o[l]) && (o[l] = u, r = !0);
    }
    if (a) {
      const l = Le(n),
        u = i || Je;
      for (let c = 0; c < a.length; c++) {
        const d = a[c];
        n[d] = ur(s, l, d, u[d], e, !je(u, d));
      }
    }
    return r;
  }
  function ur(e, t, n, o, s, a) {
    const r = e[n];
    if (r != null) {
      const i = je(r, "default");
      if (i && o === void 0) {
        const l = r.default;
        if (r.type !== Function && !r.skipFactory && we(l)) {
          const {
            propsDefaults: u
          } = s;
          if (n in u) o = u[n];else {
            const c = Fs(s);
            o = u[n] = l.call(null, t), c();
          }
        } else o = l;
        s.ce && s.ce._setProp(n, o);
      }
      r[0] && (a && !i ? o = !1 : r[1] && (o === "" || o === Qn(n)) && (o = !0));
    }
    return o;
  }
  const vC = new WeakMap();
  function ed(e, t, n = !1) {
    const o = n ? vC : t.propsCache,
      s = o.get(e);
    if (s) return s;
    const a = e.props,
      r = {},
      i = [];
    let l = !1;
    if (!we(e)) {
      const c = d => {
        l = !0;
        const [p, f] = ed(d, t, !0);
        ct(r, p), f && i.push(...f);
      };
      !n && t.mixins.length && t.mixins.forEach(c), e.extends && c(e.extends), e.mixins && e.mixins.forEach(c);
    }
    if (!a && !l) return ze(e) && o.set(e, wo), wo;
    if (Ie(a)) for (let c = 0; c < a.length; c++) {
      at(a[c]) || Ce("props must be strings when using array syntax.", a[c]);
      const d = Ut(a[c]);
      td(d) && (r[d] = Je);
    } else if (a) {
      ze(a) || Ce("invalid props options", a);
      for (const c in a) {
        const d = Ut(c);
        if (td(d)) {
          const p = a[c],
            f = r[d] = Ie(p) || we(p) ? {
              type: p
            } : ct({}, p),
            v = f.type;
          let h = !1,
            m = !0;
          if (Ie(v)) for (let D = 0; D < v.length; ++D) {
            const N = v[D],
              I = we(N) && N.name;
            if (I === "Boolean") {
              h = !0;
              break;
            } else I === "String" && (m = !1);
          } else h = we(v) && v.name === "Boolean";
          f[0] = h, f[1] = m, (h || je(f, "default")) && i.push(d);
        }
      }
    }
    const u = [r, i];
    return ze(e) && o.set(e, u), u;
  }
  function td(e) {
    return e[0] !== "$" && !hs(e) ? !0 : (Ce(`Invalid prop name: "${e}" is a reserved property.`), !1);
  }
  function mC(e) {
    return e === null ? "null" : typeof e == "function" ? e.name || "" : typeof e == "object" && e.constructor && e.constructor.name || "";
  }
  function nd(e, t, n) {
    const o = Le(t),
      s = n.propsOptions[0],
      a = Object.keys(e).map(r => Ut(r));
    for (const r in s) {
      let i = s[r];
      i != null && CC(r, o[r], i, Zt(o), !a.includes(r));
    }
  }
  function CC(e, t, n, o, s) {
    const {
      type: a,
      required: r,
      validator: i,
      skipCheck: l
    } = n;
    if (r && s) {
      Ce('Missing required prop: "' + e + '"');
      return;
    }
    if (!(t == null && !r)) {
      if (a != null && a !== !0 && !l) {
        let u = !1;
        const c = Ie(a) ? a : [a],
          d = [];
        for (let p = 0; p < c.length && !u; p++) {
          const {
            valid: f,
            expectedType: v
          } = gC(t, c[p]);
          d.push(v || ""), u = f;
        }
        if (!u) {
          Ce(yC(e, t, d));
          return;
        }
      }
      i && !i(t, o) && Ce('Invalid prop: custom validator check failed for prop "' + e + '".');
    }
  }
  const TC = An("String,Number,Boolean,Function,Symbol,BigInt");
  function gC(e, t) {
    let n;
    const o = mC(t);
    if (o === "null") n = e === null;else if (TC(o)) {
      const s = typeof e;
      n = s === o.toLowerCase(), !n && s === "object" && (n = e instanceof t);
    } else o === "Object" ? n = ze(e) : o === "Array" ? n = Ie(e) : n = e instanceof t;
    return {
      valid: n,
      expectedType: o
    };
  }
  function yC(e, t, n) {
    if (n.length === 0) return `Prop type [] for prop "${e}" won't match anything. Did you mean to use type Array instead?`;
    let o = `Invalid prop: type check failed for prop "${e}". Expected ${n.map(ro).join(" | ")}`;
    const s = n[0],
      a = Ni(t),
      r = od(t, s),
      i = od(t, a);
    return n.length === 1 && sd(s) && !DC(s, a) && (o += ` with value ${r}`), o += `, got ${a} `, sd(a) && (o += `with value ${i}.`), o;
  }
  function od(e, t) {
    return t === "String" ? `"${e}"` : t === "Number" ? `${Number(e)}` : `${e}`;
  }
  function sd(e) {
    return ["string", "number", "boolean"].some(n => e.toLowerCase() === n);
  }
  function DC(...e) {
    return e.some(t => t.toLowerCase() === "boolean");
  }
  const cr = e => e === "_" || e === "_ctx" || e === "$stable",
    dr = e => Ie(e) ? e.map(vn) : [vn(e)],
    SC = (e, t, n) => {
      if (t._n) return t;
      const o = fe((...s) => (Xn.NODE_ENV !== "production" && Tt && !(n === null && Ct) && !(n && n.root !== Tt.root) && Ce(`Slot "${e}" invoked outside of the render function: this will not track dependencies used in the slot. Invoke the slot function inside the render function instead.`), dr(t(...s))), n);
      return o._c = !1, o;
    },
    ad = (e, t, n) => {
      const o = e._ctx;
      for (const s in e) {
        if (cr(s)) continue;
        const a = e[s];
        if (we(a)) t[s] = SC(s, a, o);else if (a != null) {
          Ce(`Non-function value encountered for slot "${s}". Prefer function slots for better performance.`);
          const r = dr(a);
          t[s] = () => r;
        }
      }
    },
    id = (e, t) => {
      Wo(e.vnode) || Ce("Non-function value encountered for default slot. Prefer function slots for better performance.");
      const n = dr(t);
      e.slots.default = () => n;
    },
    fr = (e, t, n) => {
      for (const o in t) (n || !cr(o)) && (e[o] = t[o]);
    },
    PC = (e, t, n) => {
      const o = e.slots = Xc();
      if (e.vnode.shapeFlag & 32) {
        const s = t._;
        s ? (fr(o, t, n), n && va(o, "_", s, !0)) : ad(t, o);
      } else t && id(e, t);
    },
    bC = (e, t, n) => {
      const {
        vnode: o,
        slots: s
      } = e;
      let a = !0,
        r = Je;
      if (o.shapeFlag & 32) {
        const i = t._;
        i ? Dn ? (fr(s, t, n), Tn(e, "set", "$slots")) : n && i === 1 ? a = !1 : fr(s, t, n) : (a = !t.$stable, ad(t, s)), r = t;
      } else t && (id(e, t), r = {
        default: 1
      });
      if (a) for (const i in s) !cr(i) && r[i] == null && delete s[i];
    };
  let As, Un;
  function zo(e, t) {
    e.appContext.config.performance && xa() && Un.mark(`vue-${t}-${e.uid}`), km(e, t, xa() ? Un.now() : Date.now());
  }
  function Ko(e, t) {
    if (e.appContext.config.performance && xa()) {
      const n = `vue-${t}-${e.uid}`,
        o = n + ":end",
        s = `<${Ya(e, e.type)}> ${t}`;
      Un.mark(o), Un.measure(s, n, o), Un.clearMeasures(s), Un.clearMarks(n), Un.clearMarks(o);
    }
    $m(e, t, xa() ? Un.now() : Date.now());
  }
  function xa() {
    return As !== void 0 || (typeof window < "u" && window.performance ? (As = !0, Un = window.performance) : As = !1), As;
  }
  function OC() {
    const e = [];
    if (e.length) {
      const t = e.length > 1;
      console.warn(`Feature flag${t ? "s" : ""} ${e.join(", ")} ${t ? "are" : "is"} not explicitly defined. You are running the esm-bundler build of Vue, which expects these compile-time feature flags to be globally injected via the bundler config in order to get better tree-shaking in the production bundle.

For more details, see https://link.vuejs.org/feature-flags.`);
    }
  }
  const Qt = HC;
  function EC(e) {
    return IC(e);
  }
  function IC(e, t) {
    OC();
    const n = vs();
    n.__VUE__ = !0, gc(n.__VUE_DEVTOOLS_GLOBAL_HOOK__, n);
    const {
        insert: o,
        remove: s,
        patchProp: a,
        createElement: r,
        createText: i,
        createComment: l,
        setText: u,
        setElementText: c,
        parentNode: d,
        nextSibling: p,
        setScopeId: f = Mt,
        insertStaticContent: v
      } = e,
      h = ($, x, Z, pe = null, le = null, se = null, me = void 0, ye = null, ge = Dn ? !1 : !!x.dynamicChildren) => {
        if ($ === x) return;
        $ && !go($, x) && (pe = nt($), k($, le, se, !0), $ = null), x.patchFlag === -2 && (ge = !1, x.dynamicChildren = null);
        const {
          type: _e,
          ref: ie,
          shapeFlag: Pe
        } = x;
        switch (_e) {
          case Ms:
            m($, x, Z, pe);
            break;
          case pt:
            D($, x, Z, pe);
            break;
          case ws:
            $ == null ? N(x, Z, pe, me) : I($, x, Z, me);
            break;
          case q:
            E($, x, Z, pe, le, se, me, ye, ge);
            break;
          default:
            Pe & 1 ? j($, x, Z, pe, le, se, me, ye, ge) : Pe & 6 ? L($, x, Z, pe, le, se, me, ye, ge) : Pe & 64 || Pe & 128 ? _e.process($, x, Z, pe, le, se, me, ye, ge, ht) : Ce("Invalid VNode type:", _e, `(${typeof _e})`);
        }
        ie != null && le ? Is(ie, $ && $.ref, se, x || $, !x) : ie == null && $ && $.ref != null && Is($.ref, null, se, $, !0);
      },
      m = ($, x, Z, pe) => {
        if ($ == null) o(x.el = i(x.children), Z, pe);else {
          const le = x.el = $.el;
          x.children !== $.children && u(le, x.children);
        }
      },
      D = ($, x, Z, pe) => {
        $ == null ? o(x.el = l(x.children || ""), Z, pe) : x.el = $.el;
      },
      N = ($, x, Z, pe) => {
        [$.el, $.anchor] = v($.children, x, Z, pe, $.el, $.anchor);
      },
      I = ($, x, Z, pe) => {
        if (x.children !== $.children) {
          const le = p($.anchor);
          A($), [x.el, x.anchor] = v(x.children, Z, le, pe);
        } else x.el = $.el, x.anchor = $.anchor;
      },
      w = ({
        el: $,
        anchor: x
      }, Z, pe) => {
        let le;
        for (; $ && $ !== x;) le = p($), o($, Z, pe), $ = le;
        o(x, Z, pe);
      },
      A = ({
        el: $,
        anchor: x
      }) => {
        let Z;
        for (; $ && $ !== x;) Z = p($), s($), $ = Z;
        s(x);
      },
      j = ($, x, Z, pe, le, se, me, ye, ge) => {
        x.type === "svg" ? me = "svg" : x.type === "math" && (me = "mathml"), $ == null ? B(x, Z, pe, le, se, me, ye, ge) : C($, x, le, se, me, ye, ge);
      },
      B = ($, x, Z, pe, le, se, me, ye) => {
        let ge, _e;
        const {
          props: ie,
          shapeFlag: Pe,
          transition: Oe,
          dirs: Me
        } = $;
        if (ge = $.el = r($.type, se, ie && ie.is, ie), Pe & 8 ? c(ge, $.children) : Pe & 16 && g($.children, ge, null, pe, le, pr($, se), me, ye), Me && ho($, null, pe, "created"), T(ge, $, $.scopeId, me, pe), ie) {
          for (const Qe in ie) Qe !== "value" && !hs(Qe) && a(ge, Qe, null, ie[Qe], se, pe);
          "value" in ie && a(ge, "value", null, ie.value, se), (_e = ie.onVnodeBeforeMount) && bn(_e, pe, $);
        }
        va(ge, "__vnode", $, !0), va(ge, "__vueParentComponent", pe, !0), Me && ho($, null, pe, "beforeMount");
        const Ue = RC(le, Oe);
        Ue && Oe.beforeEnter(ge), o(ge, x, Z), ((_e = ie && ie.onVnodeMounted) || Ue || Me) && Qt(() => {
          _e && bn(_e, pe, $), Ue && Oe.enter(ge), Me && ho($, null, pe, "mounted");
        }, le);
      },
      T = ($, x, Z, pe, le) => {
        if (Z && f($, Z), pe) for (let se = 0; se < pe.length; se++) f($, pe[se]);
        if (le) {
          let se = le.subTree;
          if (se.patchFlag > 0 && se.patchFlag & 2048 && (se = mr(se.children) || se), x === se || hd(se.type) && (se.ssContent === x || se.ssFallback === x)) {
            const me = le.vnode;
            T($, me, me.scopeId, me.slotScopeIds, le.parent);
          }
        }
      },
      g = ($, x, Z, pe, le, se, me, ye, ge = 0) => {
        for (let _e = ge; _e < $.length; _e++) {
          const ie = $[_e] = ye ? Jn($[_e]) : vn($[_e]);
          h(null, ie, x, Z, pe, le, se, me, ye);
        }
      },
      C = ($, x, Z, pe, le, se, me) => {
        const ye = x.el = $.el;
        ye.__vnode = x;
        let {
          patchFlag: ge,
          dynamicChildren: _e,
          dirs: ie
        } = x;
        ge |= $.patchFlag & 16;
        const Pe = $.props || Je,
          Oe = x.props || Je;
        let Me;
        if (Z && Co(Z, !1), (Me = Oe.onVnodeBeforeUpdate) && bn(Me, Z, x, $), ie && ho(x, $, Z, "beforeUpdate"), Z && Co(Z, !0), Dn && (ge = 0, me = !1, _e = null), (Pe.innerHTML && Oe.innerHTML == null || Pe.textContent && Oe.textContent == null) && c(ye, ""), _e ? (S($.dynamicChildren, _e, ye, Z, pe, pr(x, le), se), _r($, x)) : me || be($, x, ye, null, Z, pe, pr(x, le), se, !1), ge > 0) {
          if (ge & 16) R(ye, Pe, Oe, Z, le);else if (ge & 2 && Pe.class !== Oe.class && a(ye, "class", null, Oe.class, le), ge & 4 && a(ye, "style", Pe.style, Oe.style, le), ge & 8) {
            const Ue = x.dynamicProps;
            for (let Qe = 0; Qe < Ue.length; Qe++) {
              const qe = Ue[Qe],
                vt = Pe[qe],
                yt = Oe[qe];
              (yt !== vt || qe === "value") && a(ye, qe, vt, yt, le, Z);
            }
          }
          ge & 1 && $.children !== x.children && c(ye, x.children);
        } else !me && _e == null && R(ye, Pe, Oe, Z, le);
        ((Me = Oe.onVnodeUpdated) || ie) && Qt(() => {
          Me && bn(Me, Z, x, $), ie && ho(x, $, Z, "updated");
        }, pe);
      },
      S = ($, x, Z, pe, le, se, me) => {
        for (let ye = 0; ye < x.length; ye++) {
          const ge = $[ye],
            _e = x[ye],
            ie = ge.el && (ge.type === q || !go(ge, _e) || ge.shapeFlag & 198) ? d(ge.el) : Z;
          h(ge, _e, ie, null, pe, le, se, me, !0);
        }
      },
      R = ($, x, Z, pe, le) => {
        if (x !== Z) {
          if (x !== Je) for (const se in x) !hs(se) && !(se in Z) && a($, se, x[se], null, le, pe);
          for (const se in Z) {
            if (hs(se)) continue;
            const me = Z[se],
              ye = x[se];
            me !== ye && se !== "value" && a($, se, ye, me, le, pe);
          }
          "value" in Z && a($, "value", x.value, Z.value, le);
        }
      },
      E = ($, x, Z, pe, le, se, me, ye, ge) => {
        const _e = x.el = $ ? $.el : i(""),
          ie = x.anchor = $ ? $.anchor : i("");
        let {
          patchFlag: Pe,
          dynamicChildren: Oe,
          slotScopeIds: Me
        } = x;
        (Dn || Pe & 2048) && (Pe = 0, ge = !1, Oe = null), Me && (ye = ye ? ye.concat(Me) : Me), $ == null ? (o(_e, Z, pe), o(ie, Z, pe), g(x.children || [], Z, ie, le, se, me, ye, ge)) : Pe > 0 && Pe & 64 && Oe && $.dynamicChildren ? (S($.dynamicChildren, Oe, Z, le, se, me, ye), _r($, x)) : be($, x, Z, ie, le, se, me, ye, ge);
      },
      L = ($, x, Z, pe, le, se, me, ye, ge) => {
        x.slotScopeIds = ye, $ == null ? x.shapeFlag & 512 ? le.ctx.activate(x, Z, pe, me, ge) : G(x, Z, pe, le, se, me, ge) : X($, x, ge);
      },
      G = ($, x, Z, pe, le, se, me) => {
        const ye = $.component = qC($, pe, le);
        if (ye.type.__hmrId && Om(ye), Ra($), zo(ye, "mount"), Wo($) && (ye.ctx.renderer = ht), zo(ye, "init"), ZC(ye, !1, me), Ko(ye, "init"), Dn && ($.el = null), ye.asyncDep) {
          if (le && le.registerDep(ye, K, me), !$.el) {
            const ge = ye.subTree = ne(pt);
            D(null, ge, x, Z), $.placeholder = ge.el;
          }
        } else K(ye, $, x, Z, le, se, me);
        Na(), Ko(ye, "mount");
      },
      X = ($, x, Z) => {
        const pe = x.component = $.component;
        if (BC($, x, Z)) {
          if (pe.asyncDep && !pe.asyncResolved) {
            Ra(x), de(pe, x, Z), Na();
            return;
          } else pe.next = x, pe.update();
        } else x.el = $.el, pe.vnode = x;
      },
      K = ($, x, Z, pe, le, se, me) => {
        const ye = () => {
          if ($.isMounted) {
            let {
              next: Pe,
              bu: Oe,
              u: Me,
              parent: Ue,
              vnode: Qe
            } = $;
            {
              const Nt = rd($);
              if (Nt) {
                Pe && (Pe.el = Qe.el, de($, Pe, me)), Nt.asyncDep.then(() => {
                  $.isUnmounted || ye();
                });
                return;
              }
            }
            let qe = Pe,
              vt;
            Ra(Pe || $.vnode), Co($, !1), Pe ? (Pe.el = Qe.el, de($, Pe, me)) : Pe = Qe, Oe && ko(Oe), (vt = Pe.props && Pe.props.onVnodeBeforeUpdate) && bn(vt, Ue, Pe, Qe), Co($, !0), zo($, "render");
            const yt = dd($);
            Ko($, "render");
            const Ot = $.subTree;
            $.subTree = yt, zo($, "patch"), h(Ot, yt, d(Ot.el), nt(Ot), $, le, se), Ko($, "patch"), Pe.el = yt.el, qe === null && xC($, yt.el), Me && Qt(Me, le), (vt = Pe.props && Pe.props.onVnodeUpdated) && Qt(() => bn(vt, Ue, Pe, Qe), le), yc($), Na();
          } else {
            let Pe;
            const {
                el: Oe,
                props: Me
              } = x,
              {
                bm: Ue,
                m: Qe,
                parent: qe,
                root: vt,
                type: yt
              } = $,
              Ot = Go(x);
            Co($, !1), Ue && ko(Ue), !Ot && (Pe = Me && Me.onVnodeBeforeMount) && bn(Pe, qe, x), Co($, !0);
            {
              vt.ce && vt.ce._def.shadowRoot !== !1 && vt.ce._injectChildStyle(yt), zo($, "render");
              const Nt = $.subTree = dd($);
              Ko($, "render"), zo($, "patch"), h(null, Nt, Z, pe, $, le, se), Ko($, "patch"), x.el = Nt.el;
            }
            if (Qe && Qt(Qe, le), !Ot && (Pe = Me && Me.onVnodeMounted)) {
              const Nt = x;
              Qt(() => bn(Pe, qe, Nt), le);
            }
            (x.shapeFlag & 256 || qe && Go(qe.vnode) && qe.vnode.shapeFlag & 256) && $.a && Qt($.a, le), $.isMounted = !0, Mm($), x = Z = pe = null;
          }
        };
        $.scope.on();
        const ge = $.effect = new Vu(ye);
        $.scope.off();
        const _e = $.update = ge.run.bind(ge),
          ie = $.job = ge.runIfDirty.bind(ge);
        ie.i = $, ie.id = $.uid, ge.scheduler = () => Ma(ie), Co($, !0), ge.onTrack = $.rtc ? Pe => ko($.rtc, Pe) : void 0, ge.onTrigger = $.rtg ? Pe => ko($.rtg, Pe) : void 0, _e();
      },
      de = ($, x, Z) => {
        x.component = $;
        const pe = $.vnode.props;
        $.vnode = x, $.next = null, hC($, x.props, pe, Z), bC($, x.children, Z), fn(), hc($), pn();
      },
      be = ($, x, Z, pe, le, se, me, ye, ge = !1) => {
        const _e = $ && $.children,
          ie = $ ? $.shapeFlag : 0,
          Pe = x.children,
          {
            patchFlag: Oe,
            shapeFlag: Me
          } = x;
        if (Oe > 0) {
          if (Oe & 128) {
            ee(_e, Pe, Z, pe, le, se, me, ye, ge);
            return;
          } else if (Oe & 256) {
            xe(_e, Pe, Z, pe, le, se, me, ye, ge);
            return;
          }
        }
        Me & 8 ? (ie & 16 && ke(_e, le, se), Pe !== _e && c(Z, Pe)) : ie & 16 ? Me & 16 ? ee(_e, Pe, Z, pe, le, se, me, ye, ge) : ke(_e, le, se, !0) : (ie & 8 && c(Z, ""), Me & 16 && g(Pe, Z, pe, le, se, me, ye, ge));
      },
      xe = ($, x, Z, pe, le, se, me, ye, ge) => {
        $ = $ || wo, x = x || wo;
        const _e = $.length,
          ie = x.length,
          Pe = Math.min(_e, ie);
        let Oe;
        for (Oe = 0; Oe < Pe; Oe++) {
          const Me = x[Oe] = ge ? Jn(x[Oe]) : vn(x[Oe]);
          h($[Oe], Me, Z, null, le, se, me, ye, ge);
        }
        _e > ie ? ke($, le, se, !0, !1, Pe) : g(x, Z, pe, le, se, me, ye, ge, Pe);
      },
      ee = ($, x, Z, pe, le, se, me, ye, ge) => {
        let _e = 0;
        const ie = x.length;
        let Pe = $.length - 1,
          Oe = ie - 1;
        for (; _e <= Pe && _e <= Oe;) {
          const Me = $[_e],
            Ue = x[_e] = ge ? Jn(x[_e]) : vn(x[_e]);
          if (go(Me, Ue)) h(Me, Ue, Z, null, le, se, me, ye, ge);else break;
          _e++;
        }
        for (; _e <= Pe && _e <= Oe;) {
          const Me = $[Pe],
            Ue = x[Oe] = ge ? Jn(x[Oe]) : vn(x[Oe]);
          if (go(Me, Ue)) h(Me, Ue, Z, null, le, se, me, ye, ge);else break;
          Pe--, Oe--;
        }
        if (_e > Pe) {
          if (_e <= Oe) {
            const Me = Oe + 1,
              Ue = Me < ie ? x[Me].el : pe;
            for (; _e <= Oe;) h(null, x[_e] = ge ? Jn(x[_e]) : vn(x[_e]), Z, Ue, le, se, me, ye, ge), _e++;
          }
        } else if (_e > Oe) for (; _e <= Pe;) k($[_e], le, se, !0), _e++;else {
          const Me = _e,
            Ue = _e,
            Qe = new Map();
          for (_e = Ue; _e <= Oe; _e++) {
            const rt = x[_e] = ge ? Jn(x[_e]) : vn(x[_e]);
            rt.key != null && (Qe.has(rt.key) && Ce("Duplicate keys found during update:", JSON.stringify(rt.key), "Make sure keys are unique."), Qe.set(rt.key, _e));
          }
          let qe,
            vt = 0;
          const yt = Oe - Ue + 1;
          let Ot = !1,
            Nt = 0;
          const Dt = new Array(yt);
          for (_e = 0; _e < yt; _e++) Dt[_e] = 0;
          for (_e = Me; _e <= Pe; _e++) {
            const rt = $[_e];
            if (vt >= yt) {
              k(rt, le, se, !0);
              continue;
            }
            let At;
            if (rt.key != null) At = Qe.get(rt.key);else for (qe = Ue; qe <= Oe; qe++) if (Dt[qe - Ue] === 0 && go(rt, x[qe])) {
              At = qe;
              break;
            }
            At === void 0 ? k(rt, le, se, !0) : (Dt[At - Ue] = _e + 1, At >= Nt ? Nt = At : Ot = !0, h(rt, x[At], Z, null, le, se, me, ye, ge), vt++);
          }
          const zt = Ot ? NC(Dt) : wo;
          for (qe = zt.length - 1, _e = yt - 1; _e >= 0; _e--) {
            const rt = Ue + _e,
              At = x[rt],
              te = x[rt + 1],
              ue = rt + 1 < ie ? te.el || te.placeholder : pe;
            Dt[_e] === 0 ? h(null, At, Z, ue, le, se, me, ye, ge) : Ot && (qe < 0 || _e !== zt[qe] ? M(At, Z, ue, 2) : qe--);
          }
        }
      },
      M = ($, x, Z, pe, le = null) => {
        const {
          el: se,
          type: me,
          transition: ye,
          children: ge,
          shapeFlag: _e
        } = $;
        if (_e & 6) {
          M($.component.subTree, x, Z, pe);
          return;
        }
        if (_e & 128) {
          $.suspense.move(x, Z, pe);
          return;
        }
        if (_e & 64) {
          me.move($, x, Z, ht);
          return;
        }
        if (me === q) {
          o(se, x, Z);
          for (let Pe = 0; Pe < ge.length; Pe++) M(ge[Pe], x, Z, pe);
          o($.anchor, x, Z);
          return;
        }
        if (me === ws) {
          w($, x, Z);
          return;
        }
        if (pe !== 2 && _e & 1 && ye) {
          if (pe === 0) ye.beforeEnter(se), o(se, x, Z), Qt(() => ye.enter(se), le);else {
            const {
                leave: Pe,
                delayLeave: Oe,
                afterLeave: Me
              } = ye,
              Ue = () => {
                $.ctx.isUnmounted ? s(se) : o(se, x, Z);
              },
              Qe = () => {
                se._isLeaving && se[kn](!0), Pe(se, () => {
                  Ue(), Me && Me();
                });
              };
            Oe ? Oe(se, Ue, Qe) : Qe();
          }
        } else o(se, x, Z);
      },
      k = ($, x, Z, pe = !1, le = !1) => {
        const {
          type: se,
          props: me,
          ref: ye,
          children: ge,
          dynamicChildren: _e,
          shapeFlag: ie,
          patchFlag: Pe,
          dirs: Oe,
          cacheIndex: Me
        } = $;
        if (Pe === -2 && (le = !1), ye != null && (fn(), Is(ye, null, Z, $, !0), pn()), Me != null && (x.renderCache[Me] = void 0), ie & 256) {
          x.ctx.deactivate($);
          return;
        }
        const Ue = ie & 1 && Oe,
          Qe = !Go($);
        let qe;
        if (Qe && (qe = me && me.onVnodeBeforeUnmount) && bn(qe, x, $), ie & 6) ae($.component, Z, pe);else {
          if (ie & 128) {
            $.suspense.unmount(Z, pe);
            return;
          }
          Ue && ho($, null, x, "beforeUnmount"), ie & 64 ? $.type.remove($, x, Z, ht, pe) : _e && !_e.hasOnce && (se !== q || Pe > 0 && Pe & 64) ? ke(_e, x, Z, !1, !0) : (se === q && Pe & 384 || !le && ie & 16) && ke(ge, x, Z), pe && W($);
        }
        (Qe && (qe = me && me.onVnodeUnmounted) || Ue) && Qt(() => {
          qe && bn(qe, x, $), Ue && ho($, null, x, "unmounted");
        }, Z);
      },
      W = $ => {
        const {
          type: x,
          el: Z,
          anchor: pe,
          transition: le
        } = $;
        if (x === q) {
          $.patchFlag > 0 && $.patchFlag & 2048 && le && !le.persisted ? $.children.forEach(me => {
            me.type === pt ? s(me.el) : W(me);
          }) : Q(Z, pe);
          return;
        }
        if (x === ws) {
          A($);
          return;
        }
        const se = () => {
          s(Z), le && !le.persisted && le.afterLeave && le.afterLeave();
        };
        if ($.shapeFlag & 1 && le && !le.persisted) {
          const {
              leave: me,
              delayLeave: ye
            } = le,
            ge = () => me(Z, se);
          ye ? ye($.el, se, ge) : ge();
        } else se();
      },
      Q = ($, x) => {
        let Z;
        for (; $ !== x;) Z = p($), s($), $ = Z;
        s(x);
      },
      ae = ($, x, Z) => {
        $.type.__hmrId && Em($);
        const {
          bum: pe,
          scope: le,
          job: se,
          subTree: me,
          um: ye,
          m: ge,
          a: _e
        } = $;
        ld(ge), ld(_e), pe && ko(pe), le.stop(), se && (se.flags |= 8, k(me, $, x, Z)), ye && Qt(ye, x), Qt(() => {
          $.isUnmounted = !0;
        }, x), Lm($);
      },
      ke = ($, x, Z, pe = !1, le = !1, se = 0) => {
        for (let me = se; me < $.length; me++) k($[me], x, Z, pe, le);
      },
      nt = $ => {
        if ($.shapeFlag & 6) return nt($.component.subTree);
        if ($.shapeFlag & 128) return $.suspense.next();
        const x = p($.anchor || $.el),
          Z = x && x[Um];
        return Z ? p(Z) : x;
      };
    let Ze = !1;
    const ot = ($, x, Z) => {
        $ == null ? x._vnode && k(x._vnode, null, null, !0) : h(x._vnode || null, $, x, null, null, null, Z), x._vnode = $, Ze || (Ze = !0, hc(), vc(), Ze = !1);
      },
      ht = {
        p: h,
        um: k,
        m: M,
        r: W,
        mt: G,
        mc: g,
        pc: be,
        pbc: S,
        n: nt,
        o: e
      };
    return {
      render: ot,
      hydrate: void 0,
      createApp: dC(ot)
    };
  }
  function pr({
    type: e,
    props: t
  }, n) {
    return n === "svg" && e === "foreignObject" || n === "mathml" && e === "annotation-xml" && t && t.encoding && t.encoding.includes("html") ? void 0 : n;
  }
  function Co({
    effect: e,
    job: t
  }, n) {
    n ? (e.flags |= 32, t.flags |= 4) : (e.flags &= -33, t.flags &= -5);
  }
  function RC(e, t) {
    return (!e || e && !e.pendingBranch) && t && !t.persisted;
  }
  function _r(e, t, n = !1) {
    const o = e.children,
      s = t.children;
    if (Ie(o) && Ie(s)) for (let a = 0; a < o.length; a++) {
      const r = o[a];
      let i = s[a];
      i.shapeFlag & 1 && !i.dynamicChildren && ((i.patchFlag <= 0 || i.patchFlag === 32) && (i = s[a] = Jn(s[a]), i.el = r.el), !n && i.patchFlag !== -2 && _r(r, i)), i.type === Ms && i.patchFlag !== -1 && (i.el = r.el), i.type === pt && !i.el && (i.el = r.el), i.el && (i.el.__vnode = i);
    }
  }
  function NC(e) {
    const t = e.slice(),
      n = [0];
    let o, s, a, r, i;
    const l = e.length;
    for (o = 0; o < l; o++) {
      const u = e[o];
      if (u !== 0) {
        if (s = n[n.length - 1], e[s] < u) {
          t[o] = s, n.push(o);
          continue;
        }
        for (a = 0, r = n.length - 1; a < r;) i = a + r >> 1, e[n[i]] < u ? a = i + 1 : r = i;
        u < e[n[a]] && (a > 0 && (t[o] = n[a - 1]), n[a] = o);
      }
    }
    for (a = n.length, r = n[a - 1]; a-- > 0;) n[a] = r, r = t[r];
    return n;
  }
  function rd(e) {
    const t = e.subTree.component;
    if (t) return t.asyncDep && !t.asyncResolved ? t : rd(t);
  }
  function ld(e) {
    if (e) for (let t = 0; t < e.length; t++) e[t].flags |= 8;
  }
  const AC = Symbol.for("v-scx"),
    MC = () => {
      {
        const e = Te(AC);
        return e || Ce("Server rendering context not provided. Make sure to only call useSSRContext() conditionally in the server build."), e;
      }
    };
  function Yo(e, t) {
    return hr(e, null, t);
  }
  function U(e, t, n) {
    return we(t) || Ce("`watch(fn, options?)` signature has been moved to a separate API. Use `watchEffect(fn, options?)` instead. `watch` now only supports `watch(source, cb, options?) signature."), hr(e, t, n);
  }
  function hr(e, t, n = Je) {
    const {
      immediate: o,
      deep: s,
      flush: a,
      once: r
    } = n;
    t || (o !== void 0 && Ce('watch() "immediate" option is only respected when using the watch(source, callback, options?) signature.'), s !== void 0 && Ce('watch() "deep" option is only respected when using the watch(source, callback, options?) signature.'), r !== void 0 && Ce('watch() "once" option is only respected when using the watch(source, callback, options?) signature.'));
    const i = ct({}, n);
    i.onWarn = Ce;
    const l = t && o || !t && a !== "post";
    let u;
    if (Qo) {
      if (a === "sync") {
        const f = MC();
        u = f.__watcherHandles || (f.__watcherHandles = []);
      } else if (!l) {
        const f = () => {};
        return f.stop = Mt, f.resume = Mt, f.pause = Mt, f;
      }
    }
    const c = Tt;
    i.call = (f, v, h) => hn(f, c, v, h);
    let d = !1;
    a === "post" ? i.scheduler = f => {
      Qt(f, c && c.suspense);
    } : a !== "sync" && (d = !0, i.scheduler = (f, v) => {
      v ? f() : Ma(f);
    }), i.augmentJob = f => {
      t && (f.flags |= 4), d && (f.flags |= 2, c && (f.id = c.uid, f.i = c));
    };
    const p = mm(e, t, i);
    return Qo && (u ? u.push(p) : l && p()), p;
  }
  function wC(e, t, n) {
    const o = this.proxy,
      s = at(e) ? e.includes(".") ? ud(o, e) : () => o[e] : e.bind(o, o);
    let a;
    we(t) ? a = t : (a = t.handler, n = t);
    const r = Fs(this),
      i = hr(s, a.bind(o), n);
    return r(), i;
  }
  function ud(e, t) {
    const n = t.split(".");
    return () => {
      let o = e;
      for (let s = 0; s < n.length && o; s++) o = o[n[s]];
      return o;
    };
  }
  const LC = (e, t) => t === "modelValue" || t === "model-value" ? e.modelModifiers : e[`${t}Modifiers`] || e[`${Ut(t)}Modifiers`] || e[`${Qn(t)}Modifiers`];
  function kC(e, t, ...n) {
    if (e.isUnmounted) return;
    const o = e.vnode.props || Je;
    {
      const {
        emitsOptions: c,
        propsOptions: [d]
      } = e;
      if (c) if (!(t in c)) (!d || !(lo(Ut(t)) in d)) && Ce(`Component emitted event "${t}" but it is neither declared in the emits option nor as an "${lo(Ut(t))}" prop.`);else {
        const p = c[t];
        we(p) && (p(...n) || Ce(`Invalid event arguments: event validation failed for event "${t}".`));
      }
    }
    let s = n;
    const a = t.startsWith("update:"),
      r = a && LC(o, t.slice(7));
    r && (r.trim && (s = n.map(c => at(c) ? c.trim() : c)), r.number && (s = n.map(ma))), Fm(e, t, s);
    {
      const c = t.toLowerCase();
      c !== t && o[lo(c)] && Ce(`Event "${c}" is emitted in component ${Ya(e, e.type)} but the handler is registered for "${t}". Note that HTML attributes are case-insensitive and you cannot use v-on to listen to camelCase events when using in-DOM templates. You should probably use "${Qn(t)}" instead of "${t}".`);
    }
    let i,
      l = o[i = lo(t)] || o[i = lo(Ut(t))];
    !l && a && (l = o[i = lo(Qn(t))]), l && hn(l, e, 6, s);
    const u = o[i + "Once"];
    if (u) {
      if (!e.emitted) e.emitted = {};else if (e.emitted[i]) return;
      e.emitted[i] = !0, hn(u, e, 6, s);
    }
  }
  const $C = new WeakMap();
  function cd(e, t, n = !1) {
    const o = n ? $C : t.emitsCache,
      s = o.get(e);
    if (s !== void 0) return s;
    const a = e.emits;
    let r = {},
      i = !1;
    if (!we(e)) {
      const l = u => {
        const c = cd(u, t, !0);
        c && (i = !0, ct(r, c));
      };
      !n && t.mixins.length && t.mixins.forEach(l), e.extends && l(e.extends), e.mixins && e.mixins.forEach(l);
    }
    return !a && !i ? (ze(e) && o.set(e, null), null) : (Ie(a) ? a.forEach(l => r[l] = null) : ct(r, a), ze(e) && o.set(e, r), r);
  }
  function Ha(e, t) {
    return !e || !ps(t) ? !1 : (t = t.slice(2).replace(/Once$/, ""), je(e, t[0].toLowerCase() + t.slice(1)) || je(e, Qn(t)) || je(e, t));
  }
  let vr = !1;
  function Ga() {
    vr = !0;
  }
  function dd(e) {
    const {
        type: t,
        vnode: n,
        proxy: o,
        withProxy: s,
        propsOptions: [a],
        slots: r,
        attrs: i,
        emit: l,
        render: u,
        renderCache: c,
        props: d,
        data: p,
        setupState: f,
        ctx: v,
        inheritAttrs: h
      } = e,
      m = ka(e);
    let D, N;
    vr = !1;
    try {
      if (n.shapeFlag & 4) {
        const A = s || o,
          j = Xn.NODE_ENV !== "production" && f.__isScriptSetup ? new Proxy(A, {
            get(B, T, g) {
              return Ce(`Property '${String(T)}' was accessed via 'this'. Avoid using 'this' in templates.`), Reflect.get(B, T, g);
            }
          }) : A;
        D = vn(u.call(j, A, c, Xn.NODE_ENV !== "production" ? Zt(d) : d, f, p, v)), N = i;
      } else {
        const A = t;
        Xn.NODE_ENV !== "production" && i === d && Ga(), D = vn(A.length > 1 ? A(Xn.NODE_ENV !== "production" ? Zt(d) : d, Xn.NODE_ENV !== "production" ? {
          get attrs() {
            return Ga(), Zt(i);
          },
          slots: r,
          emit: l
        } : {
          attrs: i,
          slots: r,
          emit: l
        }) : A(Xn.NODE_ENV !== "production" ? Zt(d) : d, null)), N = t.props ? i : FC(i);
      }
    } catch (A) {
      Ls.length = 0, Uo(A, e, 1), D = ne(pt);
    }
    let I = D,
      w;
    if (D.patchFlag > 0 && D.patchFlag & 2048 && ([I, w] = fd(D)), N && h !== !1) {
      const A = Object.keys(N),
        {
          shapeFlag: j
        } = I;
      if (A.length) {
        if (j & 7) a && A.some(_a) && (N = UC(N, a)), I = Pn(I, N, !1, !0);else if (!vr && I.type !== pt) {
          const B = Object.keys(i),
            T = [],
            g = [];
          for (let C = 0, S = B.length; C < S; C++) {
            const R = B[C];
            ps(R) ? _a(R) || T.push(R[2].toLowerCase() + R.slice(3)) : g.push(R);
          }
          g.length && Ce(`Extraneous non-props attributes (${g.join(", ")}) were passed to component but could not be automatically inherited because component renders fragment or text or teleport root nodes.`), T.length && Ce(`Extraneous non-emits event listeners (${T.join(", ")}) were passed to component but could not be automatically inherited because component renders fragment or text root nodes. If the listener is intended to be a component custom event listener only, declare it using the "emits" option.`);
        }
      }
    }
    return n.dirs && (pd(I) || Ce("Runtime directive used on component with non-element root node. The directives will not function as intended."), I = Pn(I, null, !1, !0), I.dirs = I.dirs ? I.dirs.concat(n.dirs) : n.dirs), n.transition && (pd(I) || Ce("Component inside <Transition> renders non-element root node that cannot be animated."), Es(I, n.transition)), w ? w(I) : D = I, ka(m), D;
  }
  const fd = e => {
    const t = e.children,
      n = e.dynamicChildren,
      o = mr(t, !1);
    if (o) {
      if (o.patchFlag > 0 && o.patchFlag & 2048) return fd(o);
    } else return [e, void 0];
    const s = t.indexOf(o),
      a = n ? n.indexOf(o) : -1,
      r = i => {
        t[s] = i, n && (a > -1 ? n[a] = i : i.patchFlag > 0 && (e.dynamicChildren = [...n, i]));
      };
    return [vn(o), r];
  };
  function mr(e, t = !0) {
    let n;
    for (let o = 0; o < e.length; o++) {
      const s = e[o];
      if (To(s)) {
        if (s.type !== pt || s.children === "v-if") {
          if (n) return;
          if (n = s, t && n.patchFlag > 0 && n.patchFlag & 2048) return mr(n.children);
        }
      } else return;
    }
    return n;
  }
  const FC = e => {
      let t;
      for (const n in e) (n === "class" || n === "style" || ps(n)) && ((t || (t = {}))[n] = e[n]);
      return t;
    },
    UC = (e, t) => {
      const n = {};
      for (const o in e) (!_a(o) || !(o.slice(9) in t)) && (n[o] = e[o]);
      return n;
    },
    pd = e => e.shapeFlag & 7 || e.type === pt;
  function BC(e, t, n) {
    const {
        props: o,
        children: s,
        component: a
      } = e,
      {
        props: r,
        children: i,
        patchFlag: l
      } = t,
      u = a.emitsOptions;
    if ((s || i) && Dn || t.dirs || t.transition) return !0;
    if (n && l >= 0) {
      if (l & 1024) return !0;
      if (l & 16) return o ? _d(o, r, u) : !!r;
      if (l & 8) {
        const c = t.dynamicProps;
        for (let d = 0; d < c.length; d++) {
          const p = c[d];
          if (r[p] !== o[p] && !Ha(u, p)) return !0;
        }
      }
    } else return (s || i) && (!i || !i.$stable) ? !0 : o === r ? !1 : o ? r ? _d(o, r, u) : !0 : !!r;
    return !1;
  }
  function _d(e, t, n) {
    const o = Object.keys(t);
    if (o.length !== Object.keys(e).length) return !0;
    for (let s = 0; s < o.length; s++) {
      const a = o[s];
      if (t[a] !== e[a] && !Ha(n, a)) return !0;
    }
    return !1;
  }
  function xC({
    vnode: e,
    parent: t
  }, n) {
    for (; t;) {
      const o = t.subTree;
      if (o.suspense && o.suspense.activeBranch === e && (o.el = e.el), o === e) (e = t.vnode).el = n, t = t.parent;else break;
    }
  }
  const hd = e => e.__isSuspense;
  function HC(e, t) {
    t && t.pendingBranch ? Ie(e) ? t.effects.push(...e) : t.effects.push(e) : _c(e);
  }
  const q = Symbol.for("v-fgt"),
    Ms = Symbol.for("v-txt"),
    pt = Symbol.for("v-cmt"),
    ws = Symbol.for("v-stc"),
    Ls = [];
  let qt = null;
  function _(e = !1) {
    Ls.push(qt = e ? null : []);
  }
  function GC() {
    Ls.pop(), qt = Ls[Ls.length - 1] || null;
  }
  let ks = 1;
  function Wa(e, t = !1) {
    ks += e, e < 0 && qt && t && (qt.hasOnce = !0);
  }
  function vd(e) {
    return e.dynamicChildren = ks > 0 ? qt || wo : null, GC(), ks > 0 && qt && qt.push(e), e;
  }
  function O(e, t, n, o, s, a) {
    return vd(P(e, t, n, o, s, a, !0));
  }
  function V(e, t, n, o, s) {
    return vd(ne(e, t, n, o, s, !0));
  }
  function To(e) {
    return e ? e.__v_isVNode === !0 : !1;
  }
  function go(e, t) {
    if (t.shapeFlag & 6 && e.component) {
      const n = wa.get(t.type);
      if (n && n.has(e.component)) return e.shapeFlag &= -257, t.shapeFlag &= -513, !1;
    }
    return e.type === t.type && e.key === t.key;
  }
  const WC = (...e) => VC(...e),
    md = ({
      key: e
    }) => e ?? null,
    Va = ({
      ref: e,
      ref_key: t,
      ref_for: n
    }) => (typeof e == "number" && (e = "" + e), e != null ? at(e) || tt(e) || we(e) ? {
      i: Ct,
      r: e,
      k: t,
      f: !!n
    } : e : null);
  function P(e, t = null, n = null, o = 0, s = null, a = e === q ? 0 : 1, r = !1, i = !1) {
    const l = {
      __v_isVNode: !0,
      __v_skip: !0,
      type: e,
      props: t,
      key: t && md(t),
      ref: t && Va(t),
      scopeId: Sc,
      slotScopeIds: null,
      children: n,
      component: null,
      suspense: null,
      ssContent: null,
      ssFallback: null,
      dirs: null,
      transition: null,
      el: null,
      anchor: null,
      target: null,
      targetStart: null,
      targetAnchor: null,
      staticCount: 0,
      shapeFlag: a,
      patchFlag: o,
      dynamicProps: s,
      dynamicChildren: null,
      appContext: null,
      ctx: Ct
    };
    return i ? (Cr(l, n), a & 128 && e.normalize(l)) : n && (l.shapeFlag |= at(n) ? 8 : 16), l.key !== l.key && Ce("VNode created with invalid key (NaN). VNode type:", l.type), ks > 0 && !r && qt && (l.patchFlag > 0 || a & 6) && l.patchFlag !== 32 && qt.push(l), l;
  }
  const ne = WC;
  function VC(e, t = null, n = null, o = 0, s = null, a = !1) {
    if ((!e || e === Fc) && (e || Ce(`Invalid vnode type when creating vnode: ${e}.`), e = pt), To(e)) {
      const i = Pn(e, t, !0);
      return n && Cr(i, n), ks > 0 && !a && qt && (i.shapeFlag & 6 ? qt[qt.indexOf(e)] = i : qt.push(i)), i.patchFlag = -2, i;
    }
    if (Sd(e) && (e = e.__vccOpts), t) {
      t = jC(t);
      let {
        class: i,
        style: l
      } = t;
      i && !at(i) && (t.class = $e(i)), ze(l) && (Ss(l) && !Ie(l) && (l = ct({}, l)), t.style = mt(l));
    }
    const r = at(e) ? 1 : hd(e) ? 128 : bc(e) ? 64 : ze(e) ? 4 : we(e) ? 2 : 0;
    return r & 4 && Ss(e) && (e = Le(e), Ce("Vue received a Component that was made a reactive object. This can lead to unnecessary performance overhead and should be avoided by marking the component with `markRaw` or using `shallowRef` instead of `ref`.", `
Component that was made reactive: `, e)), P(e, t, n, o, s, r, a, !0);
  }
  function jC(e) {
    return e ? Ss(e) || Zc(e) ? ct({}, e) : e : null;
  }
  function Pn(e, t, n = !1, o = !1) {
    const {
        props: s,
        ref: a,
        patchFlag: r,
        children: i,
        transition: l
      } = e,
      u = t ? KC(s || {}, t) : s,
      c = {
        __v_isVNode: !0,
        __v_skip: !0,
        type: e.type,
        props: u,
        key: u && md(u),
        ref: t && t.ref ? n && a ? Ie(a) ? a.concat(Va(t)) : [a, Va(t)] : Va(t) : a,
        scopeId: e.scopeId,
        slotScopeIds: e.slotScopeIds,
        children: r === -1 && Ie(i) ? i.map(Cd) : i,
        target: e.target,
        targetStart: e.targetStart,
        targetAnchor: e.targetAnchor,
        staticCount: e.staticCount,
        shapeFlag: e.shapeFlag,
        patchFlag: t && e.type !== q ? r === -1 ? 16 : r | 16 : r,
        dynamicProps: e.dynamicProps,
        dynamicChildren: e.dynamicChildren,
        appContext: e.appContext,
        dirs: e.dirs,
        transition: l,
        component: e.component,
        suspense: e.suspense,
        ssContent: e.ssContent && Pn(e.ssContent),
        ssFallback: e.ssFallback && Pn(e.ssFallback),
        placeholder: e.placeholder,
        el: e.el,
        anchor: e.anchor,
        ctx: e.ctx,
        ce: e.ce
      };
    return l && o && Es(c, l.clone(c)), c;
  }
  function Cd(e) {
    const t = Pn(e);
    return Ie(e.children) && (t.children = e.children.map(Cd)), t;
  }
  function yo(e = " ", t = 0) {
    return ne(Ms, null, e, t);
  }
  function zC(e, t) {
    const n = ne(ws, null, e);
    return n.staticCount = t, n;
  }
  function J(e = "", t = !1) {
    return t ? (_(), V(pt, null, e)) : ne(pt, null, e);
  }
  function vn(e) {
    return e == null || typeof e == "boolean" ? ne(pt) : Ie(e) ? ne(q, null, e.slice()) : To(e) ? Jn(e) : ne(Ms, null, String(e));
  }
  function Jn(e) {
    return e.el === null && e.patchFlag !== -1 || e.memo ? e : Pn(e);
  }
  function Cr(e, t) {
    let n = 0;
    const {
      shapeFlag: o
    } = e;
    if (t == null) t = null;else if (Ie(t)) n = 16;else if (typeof t == "object") {
      if (o & 65) {
        const s = t.default;
        s && (s._c && (s._d = !1), Cr(e, s()), s._c && (s._d = !0));
        return;
      } else {
        n = 32;
        const s = t._;
        !s && !Zc(t) ? t._ctx = Ct : s === 3 && Ct && (Ct.slots._ === 1 ? t._ = 1 : (t._ = 2, e.patchFlag |= 1024));
      }
    } else we(t) ? (t = {
      default: t,
      _ctx: Ct
    }, n = 32) : (t = String(t), o & 64 ? (n = 16, t = [yo(t)]) : n = 8);
    e.children = t, e.shapeFlag |= n;
  }
  function KC(...e) {
    const t = {};
    for (let n = 0; n < e.length; n++) {
      const o = e[n];
      for (const s in o) if (s === "class") t.class !== o.class && (t.class = $e([t.class, o.class]));else if (s === "style") t.style = mt([t.style, o.style]);else if (ps(s)) {
        const a = t[s],
          r = o[s];
        r && a !== r && !(Ie(a) && a.includes(r)) && (t[s] = a ? [].concat(a, r) : r);
      } else s !== "" && (t[s] = o[s]);
    }
    return t;
  }
  function bn(e, t, n, o = null) {
    hn(e, t, 7, [n, o]);
  }
  const YC = Yc();
  let QC = 0;
  function qC(e, t, n) {
    const o = e.type,
      s = (t ? t.appContext : e.appContext) || YC,
      a = {
        uid: QC++,
        vnode: e,
        type: o,
        parent: t,
        appContext: s,
        root: null,
        next: null,
        subTree: null,
        effect: null,
        update: null,
        job: null,
        scope: new Hu(!0),
        render: null,
        proxy: null,
        exposed: null,
        exposeProxy: null,
        withProxy: null,
        provides: t ? t.provides : Object.create(s.provides),
        ids: t ? t.ids : ["", 0, 0],
        accessCache: null,
        renderCache: [],
        components: null,
        directives: null,
        propsOptions: ed(o, s),
        emitsOptions: cd(o, s),
        emit: null,
        emitted: null,
        propsDefaults: Je,
        inheritAttrs: o.inheritAttrs,
        ctx: Je,
        data: Je,
        props: Je,
        attrs: Je,
        slots: Je,
        refs: Je,
        setupState: Je,
        setupContext: null,
        suspense: n,
        suspenseId: n ? n.pendingId : 0,
        asyncDep: null,
        asyncResolved: !1,
        isMounted: !1,
        isUnmounted: !1,
        isDeactivated: !1,
        bc: null,
        c: null,
        bm: null,
        m: null,
        bu: null,
        u: null,
        um: null,
        bum: null,
        da: null,
        a: null,
        rtg: null,
        rtc: null,
        ec: null,
        sp: null
      };
    return a.ctx = tC(a), a.root = t ? t.root : a, a.emit = kC.bind(null, a), e.ce && e.ce(a), a;
  }
  let Tt = null;
  const $s = () => Tt || Ct;
  let ja, Tr;
  {
    const e = vs(),
      t = (n, o) => {
        let s;
        return (s = e[n]) || (s = e[n] = []), s.push(o), a => {
          s.length > 1 ? s.forEach(r => r(a)) : s[0](a);
        };
      };
    ja = t("__VUE_INSTANCE_SETTERS__", n => Tt = n), Tr = t("__VUE_SSR_SETTERS__", n => Qo = n);
  }
  const Fs = e => {
      const t = Tt;
      return ja(e), e.scope.on(), () => {
        e.scope.off(), ja(t);
      };
    },
    Td = () => {
      Tt && Tt.scope.off(), ja(null);
    },
    XC = An("slot,component");
  function gr(e, {
    isNativeTag: t
  }) {
    (XC(e) || t(e)) && Ce("Do not use built-in or reserved HTML elements as component id: " + e);
  }
  function gd(e) {
    return e.vnode.shapeFlag & 4;
  }
  let Qo = !1;
  function ZC(e, t = !1, n = !1) {
    t && Tr(t);
    const {
        props: o,
        children: s
      } = e.vnode,
      a = gd(e);
    pC(e, o, a, t), PC(e, s, n || t);
    const r = a ? JC(e, t) : void 0;
    return t && Tr(!1), r;
  }
  function JC(e, t) {
    var n;
    const o = e.type;
    {
      if (o.name && gr(o.name, e.appContext.config), o.components) {
        const a = Object.keys(o.components);
        for (let r = 0; r < a.length; r++) gr(a[r], e.appContext.config);
      }
      if (o.directives) {
        const a = Object.keys(o.directives);
        for (let r = 0; r < a.length; r++) Pc(a[r]);
      }
      o.compilerOptions && eT() && Ce('"compilerOptions" is only supported when using a build of Vue that includes the runtime compiler. Since you are using a runtime-only build, the options should be passed via your build tool config instead.');
    }
    e.accessCache = Object.create(null), e.proxy = new Proxy(e.ctx, Hc), nC(e);
    const {
      setup: s
    } = o;
    if (s) {
      fn();
      const a = e.setupContext = s.length > 1 ? oT(e) : null,
        r = Fs(e),
        i = Fo(s, e, 0, [Zt(e.props), a]),
        l = Ri(i);
      if (pn(), r(), (l || e.sp) && !Go(e) && er(e), l) {
        if (i.then(Td, Td), t) return i.then(u => {
          yd(e, u, t);
        }).catch(u => {
          Uo(u, e, 0);
        });
        if (e.asyncDep = i, !e.suspense) {
          const u = (n = o.name) != null ? n : "Anonymous";
          Ce(`Component <${u}>: setup function returned a promise, but no <Suspense> boundary was found in the parent component tree. A component with async setup() must be nested in a <Suspense> in order to be rendered.`);
        }
      } else yd(e, i, t);
    } else Dd(e, t);
  }
  function yd(e, t, n) {
    we(t) ? e.type.__ssrInlineRender ? e.ssrRender = t : e.render = t : ze(t) ? (To(t) && Ce("setup() should not return VNodes directly - return a render function instead."), e.devtoolsRawSetupState = t, e.setupState = uc(t), oC(e)) : t !== void 0 && Ce(`setup() should return an object. Received: ${t === null ? "null" : typeof t}`), Dd(e, n);
  }
  const eT = () => !0;
  function Dd(e, t, n) {
    const o = e.type;
    e.render || (e.render = o.render || Mt);
    {
      const s = Fs(e);
      fn();
      try {
        aC(e);
      } finally {
        pn(), s();
      }
    }
    !o.render && e.render === Mt && !t && (o.template ? Ce('Component provided template option but runtime compilation is not supported in this build of Vue. Configure your bundler to alias "vue" to "vue/dist/vue.esm-bundler.js".') : Ce("Component is missing template or render function: ", o));
  }
  const tT = {
    get(e, t) {
      return Ga(), Pt(e, "get", ""), e[t];
    },
    set() {
      return Ce("setupContext.attrs is readonly."), !1;
    },
    deleteProperty() {
      return Ce("setupContext.attrs is readonly."), !1;
    }
  };
  function nT(e) {
    return new Proxy(e.slots, {
      get(t, n) {
        return Pt(e, "get", "$slots"), t[n];
      }
    });
  }
  function oT(e) {
    const t = n => {
      if (e.exposed && Ce("expose() should be called only once per setup()."), n != null) {
        let o = typeof n;
        o === "object" && (Ie(n) ? o = "array" : tt(n) && (o = "ref")), o !== "object" && Ce(`expose() should be passed a plain object, received ${o}.`);
      }
      e.exposed = n || {};
    };
    {
      let n, o;
      return Object.freeze({
        get attrs() {
          return n || (n = new Proxy(e.attrs, tT));
        },
        get slots() {
          return o || (o = nT(e));
        },
        get emit() {
          return (s, ...a) => e.emit(s, ...a);
        },
        expose: t
      });
    }
  }
  function za(e) {
    return e.exposed ? e.exposeProxy || (e.exposeProxy = new Proxy(uc(wn(e.exposed)), {
      get(t, n) {
        if (n in t) return t[n];
        if (n in vo) return vo[n](e);
      },
      has(t, n) {
        return n in t || n in vo;
      }
    })) : e.proxy;
  }
  const sT = /(?:^|[-_])\w/g,
    aT = e => e.replace(sT, t => t.toUpperCase()).replace(/[-_]/g, "");
  function Ka(e, t = !0) {
    return we(e) ? e.displayName || e.name : e.name || t && e.__name;
  }
  function Ya(e, t, n = !1) {
    let o = Ka(t);
    if (!o && t.__file) {
      const s = t.__file.match(/([^/\\]+)\.\w+$/);
      s && (o = s[1]);
    }
    if (!o && e && e.parent) {
      const s = a => {
        for (const r in a) if (a[r] === t) return r;
      };
      o = s(e.components || e.parent.type.components) || s(e.appContext.components);
    }
    return o ? aT(o) : n ? "App" : "Anonymous";
  }
  function Sd(e) {
    return we(e) && "__vccOpts" in e;
  }
  const b = (e, t) => {
    const n = hm(e, t, Qo);
    {
      const o = $s();
      o && o.appContext.config.warnRecursiveComputed && (n._warnRecursive = !0);
    }
    return n;
  };
  function iT(e, t, n) {
    const o = (a, r, i) => {
        Wa(-1);
        try {
          return ne(a, r, i);
        } finally {
          Wa(1);
        }
      },
      s = arguments.length;
    return s === 2 ? ze(t) && !Ie(t) ? To(t) ? o(e, null, [t]) : o(e, t) : o(e, null, t) : (s > 3 ? n = Array.prototype.slice.call(arguments, 2) : s === 3 && To(n) && (n = [n]), o(e, t, n));
  }
  function rT() {
    if (typeof window > "u") return;
    const e = {
        style: "color:#3ba776"
      },
      t = {
        style: "color:#1677ff"
      },
      n = {
        style: "color:#f5222d"
      },
      o = {
        style: "color:#eb2f96"
      },
      s = {
        __vue_custom_formatter: !0,
        header(d) {
          if (!ze(d)) return null;
          if (d.__isVue) return ["div", e, "VueInstance"];
          if (tt(d)) {
            fn();
            const p = d.value;
            return pn(), ["div", {}, ["span", e, c(d)], "<", i(p), ">"];
          } else {
            if (_n(d)) return ["div", {}, ["span", e, Bt(d) ? "ShallowReactive" : "Reactive"], "<", i(d), `>${gn(d) ? " (readonly)" : ""}`];
            if (gn(d)) return ["div", {}, ["span", e, Bt(d) ? "ShallowReadonly" : "Readonly"], "<", i(d), ">"];
          }
          return null;
        },
        hasBody(d) {
          return d && d.__isVue;
        },
        body(d) {
          if (d && d.__isVue) return ["div", {}, ...a(d.$)];
        }
      };
    function a(d) {
      const p = [];
      d.type.props && d.props && p.push(r("props", Le(d.props))), d.setupState !== Je && p.push(r("setup", d.setupState)), d.data !== Je && p.push(r("data", Le(d.data)));
      const f = l(d, "computed");
      f && p.push(r("computed", f));
      const v = l(d, "inject");
      return v && p.push(r("injected", v)), p.push(["div", {}, ["span", {
        style: o.style + ";opacity:0.66"
      }, "$ (internal): "], ["object", {
        object: d
      }]]), p;
    }
    function r(d, p) {
      return p = ct({}, p), Object.keys(p).length ? ["div", {
        style: "line-height:1.25em;margin-bottom:0.6em"
      }, ["div", {
        style: "color:#476582"
      }, d], ["div", {
        style: "padding-left:1.25em"
      }, ...Object.keys(p).map(f => ["div", {}, ["span", o, f + ": "], i(p[f], !1)])]] : ["span", {}];
    }
    function i(d, p = !0) {
      return typeof d == "number" ? ["span", t, d] : typeof d == "string" ? ["span", n, JSON.stringify(d)] : typeof d == "boolean" ? ["span", o, d] : ze(d) ? ["object", {
        object: p ? Le(d) : d
      }] : ["span", n, String(d)];
    }
    function l(d, p) {
      const f = d.type;
      if (we(f)) return;
      const v = {};
      for (const h in d.ctx) u(f, h, p) && (v[h] = d.ctx[h]);
      return v;
    }
    function u(d, p, f) {
      const v = d[f];
      if (Ie(v) && v.includes(p) || ze(v) && p in v || d.extends && u(d.extends, p, f) || d.mixins && d.mixins.some(h => u(h, p, f))) return !0;
    }
    function c(d) {
      return Bt(d) ? "ShallowRef" : d.effect ? "ComputedRef" : "Ref";
    }
    window.devtoolsFormatters ? window.devtoolsFormatters.push(s) : window.devtoolsFormatters = [s];
  }
  const Pd = "3.5.21",
    On = Ce;
  let yr;
  const bd = typeof window < "u" && window.trustedTypes;
  if (bd) try {
    yr = bd.createPolicy("vue", {
      createHTML: e => e
    });
  } catch (e) {
    On(`Error creating trusted types policy: ${e}`);
  }
  const Od = yr ? e => yr.createHTML(e) : e => e,
    lT = "http://www.w3.org/2000/svg",
    uT = "http://www.w3.org/1998/Math/MathML",
    Bn = typeof document < "u" ? document : null,
    Ed = Bn && Bn.createElement("template"),
    cT = {
      insert: (e, t, n) => {
        t.insertBefore(e, n || null);
      },
      remove: e => {
        const t = e.parentNode;
        t && t.removeChild(e);
      },
      createElement: (e, t, n, o) => {
        const s = t === "svg" ? Bn.createElementNS(lT, e) : t === "mathml" ? Bn.createElementNS(uT, e) : n ? Bn.createElement(e, {
          is: n
        }) : Bn.createElement(e);
        return e === "select" && o && o.multiple != null && s.setAttribute("multiple", o.multiple), s;
      },
      createText: e => Bn.createTextNode(e),
      createComment: e => Bn.createComment(e),
      setText: (e, t) => {
        e.nodeValue = t;
      },
      setElementText: (e, t) => {
        e.textContent = t;
      },
      parentNode: e => e.parentNode,
      nextSibling: e => e.nextSibling,
      querySelector: e => Bn.querySelector(e),
      setScopeId(e, t) {
        e.setAttribute(t, "");
      },
      insertStaticContent(e, t, n, o, s, a) {
        const r = n ? n.previousSibling : t.lastChild;
        if (s && (s === a || s.nextSibling)) for (; t.insertBefore(s.cloneNode(!0), n), !(s === a || !(s = s.nextSibling)););else {
          Ed.innerHTML = Od(o === "svg" ? `<svg>${e}</svg>` : o === "mathml" ? `<math>${e}</math>` : e);
          const i = Ed.content;
          if (o === "svg" || o === "mathml") {
            const l = i.firstChild;
            for (; l.firstChild;) i.appendChild(l.firstChild);
            i.removeChild(l);
          }
          t.insertBefore(i, n);
        }
        return [r ? r.nextSibling : t.firstChild, n ? n.previousSibling : t.lastChild];
      }
    },
    eo = "transition",
    Us = "animation",
    Bs = Symbol("_vtc"),
    Id = {
      name: String,
      type: String,
      css: {
        type: Boolean,
        default: !0
      },
      duration: [String, Number, Object],
      enterFromClass: String,
      enterActiveClass: String,
      enterToClass: String,
      appearFromClass: String,
      appearActiveClass: String,
      appearToClass: String,
      leaveFromClass: String,
      leaveActiveClass: String,
      leaveToClass: String
    },
    dT = ct({}, Oc, Id),
    fT = (e => (e.displayName = "Transition", e.props = dT, e))((e, {
      slots: t
    }) => iT(Hm, pT(e), t)),
    Do = (e, t = []) => {
      Ie(e) ? e.forEach(n => n(...t)) : e && e(...t);
    },
    Rd = e => e ? Ie(e) ? e.some(t => t.length > 1) : e.length > 1 : !1;
  function pT(e) {
    const t = {};
    for (const R in e) R in Id || (t[R] = e[R]);
    if (e.css === !1) return t;
    const {
        name: n = "v",
        type: o,
        duration: s,
        enterFromClass: a = `${n}-enter-from`,
        enterActiveClass: r = `${n}-enter-active`,
        enterToClass: i = `${n}-enter-to`,
        appearFromClass: l = a,
        appearActiveClass: u = r,
        appearToClass: c = i,
        leaveFromClass: d = `${n}-leave-from`,
        leaveActiveClass: p = `${n}-leave-active`,
        leaveToClass: f = `${n}-leave-to`
      } = e,
      v = _T(s),
      h = v && v[0],
      m = v && v[1],
      {
        onBeforeEnter: D,
        onEnter: N,
        onEnterCancelled: I,
        onLeave: w,
        onLeaveCancelled: A,
        onBeforeAppear: j = D,
        onAppear: B = N,
        onAppearCancelled: T = I
      } = t,
      g = (R, E, L, G) => {
        R._enterCancelled = G, So(R, E ? c : i), So(R, E ? u : r), L && L();
      },
      C = (R, E) => {
        R._isLeaving = !1, So(R, d), So(R, f), So(R, p), E && E();
      },
      S = R => (E, L) => {
        const G = R ? B : N,
          X = () => g(E, R, L);
        Do(G, [E, X]), Nd(() => {
          So(E, R ? l : a), xn(E, R ? c : i), Rd(G) || Ad(E, o, h, X);
        });
      };
    return ct(t, {
      onBeforeEnter(R) {
        Do(D, [R]), xn(R, a), xn(R, r);
      },
      onBeforeAppear(R) {
        Do(j, [R]), xn(R, l), xn(R, u);
      },
      onEnter: S(!1),
      onAppear: S(!0),
      onLeave(R, E) {
        R._isLeaving = !0;
        const L = () => C(R, E);
        xn(R, d), R._enterCancelled ? (xn(R, p), Ld()) : (Ld(), xn(R, p)), Nd(() => {
          R._isLeaving && (So(R, d), xn(R, f), Rd(w) || Ad(R, o, m, L));
        }), Do(w, [R, L]);
      },
      onEnterCancelled(R) {
        g(R, !1, void 0, !0), Do(I, [R]);
      },
      onAppearCancelled(R) {
        g(R, !0, void 0, !0), Do(T, [R]);
      },
      onLeaveCancelled(R) {
        C(R), Do(A, [R]);
      }
    });
  }
  function _T(e) {
    if (e == null) return null;
    if (ze(e)) return [Dr(e.enter), Dr(e.leave)];
    {
      const t = Dr(e);
      return [t, t];
    }
  }
  function Dr(e) {
    const t = Nv(e);
    return Dm(t, "<transition> explicit duration"), t;
  }
  function xn(e, t) {
    t.split(/\s+/).forEach(n => n && e.classList.add(n)), (e[Bs] || (e[Bs] = new Set())).add(t);
  }
  function So(e, t) {
    t.split(/\s+/).forEach(o => o && e.classList.remove(o));
    const n = e[Bs];
    n && (n.delete(t), n.size || (e[Bs] = void 0));
  }
  function Nd(e) {
    requestAnimationFrame(() => {
      requestAnimationFrame(e);
    });
  }
  let hT = 0;
  function Ad(e, t, n, o) {
    const s = e._endId = ++hT,
      a = () => {
        s === e._endId && o();
      };
    if (n != null) return setTimeout(a, n);
    const {
      type: r,
      timeout: i,
      propCount: l
    } = vT(e, t);
    if (!r) return o();
    const u = r + "end";
    let c = 0;
    const d = () => {
        e.removeEventListener(u, p), a();
      },
      p = f => {
        f.target === e && ++c >= l && d();
      };
    setTimeout(() => {
      c < l && d();
    }, i + 1), e.addEventListener(u, p);
  }
  function vT(e, t) {
    const n = window.getComputedStyle(e),
      o = v => (n[v] || "").split(", "),
      s = o(`${eo}Delay`),
      a = o(`${eo}Duration`),
      r = Md(s, a),
      i = o(`${Us}Delay`),
      l = o(`${Us}Duration`),
      u = Md(i, l);
    let c = null,
      d = 0,
      p = 0;
    t === eo ? r > 0 && (c = eo, d = r, p = a.length) : t === Us ? u > 0 && (c = Us, d = u, p = l.length) : (d = Math.max(r, u), c = d > 0 ? r > u ? eo : Us : null, p = c ? c === eo ? a.length : l.length : 0);
    const f = c === eo && /\b(?:transform|all)(?:,|$)/.test(o(`${eo}Property`).toString());
    return {
      type: c,
      timeout: d,
      propCount: p,
      hasTransform: f
    };
  }
  function Md(e, t) {
    for (; e.length < t.length;) e = e.concat(e);
    return Math.max(...t.map((n, o) => wd(n) + wd(e[o])));
  }
  function wd(e) {
    return e === "auto" ? 0 : Number(e.slice(0, -1).replace(",", ".")) * 1e3;
  }
  function Ld() {
    return document.body.offsetHeight;
  }
  function mT(e, t, n) {
    const o = e[Bs];
    o && (t = (t ? [t, ...o] : [...o]).join(" ")), t == null ? e.removeAttribute("class") : n ? e.setAttribute("class", t) : e.className = t;
  }
  const Qa = Symbol("_vod"),
    kd = Symbol("_vsh"),
    Lt = {
      name: "show",
      beforeMount(e, {
        value: t
      }, {
        transition: n
      }) {
        e[Qa] = e.style.display === "none" ? "" : e.style.display, n && t ? n.beforeEnter(e) : xs(e, t);
      },
      mounted(e, {
        value: t
      }, {
        transition: n
      }) {
        n && t && n.enter(e);
      },
      updated(e, {
        value: t,
        oldValue: n
      }, {
        transition: o
      }) {
        !t != !n && (o ? t ? (o.beforeEnter(e), xs(e, !0), o.enter(e)) : o.leave(e, () => {
          xs(e, !1);
        }) : xs(e, t));
      },
      beforeUnmount(e, {
        value: t
      }) {
        xs(e, t);
      }
    };
  function xs(e, t) {
    e.style.display = t ? e[Qa] : "none", e[kd] = !t;
  }
  const CT = Symbol("CSS_VAR_TEXT"),
    TT = /(?:^|;)\s*display\s*:/;
  function gT(e, t, n) {
    const o = e.style,
      s = at(n);
    let a = !1;
    if (n && !s) {
      if (t) if (at(t)) for (const r of t.split(";")) {
        const i = r.slice(0, r.indexOf(":")).trim();
        n[i] == null && qa(o, i, "");
      } else for (const r in t) n[r] == null && qa(o, r, "");
      for (const r in n) r === "display" && (a = !0), qa(o, r, n[r]);
    } else if (s) {
      if (t !== n) {
        const r = o[CT];
        r && (n += ";" + r), o.cssText = n, a = TT.test(n);
      }
    } else t && e.removeAttribute("style");
    Qa in e && (e[Qa] = a ? o.display : "", e[kd] && (o.display = "none"));
  }
  const yT = /[^\\];\s*$/,
    $d = /\s*!important$/;
  function qa(e, t, n) {
    if (Ie(n)) n.forEach(o => qa(e, t, o));else if (n == null && (n = ""), yT.test(n) && On(`Unexpected semicolon at the end of '${t}' style value: '${n}'`), t.startsWith("--")) e.setProperty(t, n);else {
      const o = DT(e, t);
      $d.test(n) ? e.setProperty(Qn(o), n.replace($d, ""), "important") : e[o] = n;
    }
  }
  const Fd = ["Webkit", "Moz", "ms"],
    Sr = {};
  function DT(e, t) {
    const n = Sr[t];
    if (n) return n;
    let o = Ut(t);
    if (o !== "filter" && o in e) return Sr[t] = o;
    o = ro(o);
    for (let s = 0; s < Fd.length; s++) {
      const a = Fd[s] + o;
      if (a in e) return Sr[t] = a;
    }
    return t;
  }
  const Ud = "http://www.w3.org/1999/xlink";
  function Bd(e, t, n, o, s, a = Hv(t)) {
    o && t.startsWith("xlink:") ? n == null ? e.removeAttributeNS(Ud, t.slice(6, t.length)) : e.setAttributeNS(Ud, t, n) : n == null || a && !Uu(n) ? e.removeAttribute(t) : e.setAttribute(t, a ? "" : cn(n) ? String(n) : n);
  }
  function xd(e, t, n, o, s) {
    if (t === "innerHTML" || t === "textContent") {
      n != null && (e[t] = t === "innerHTML" ? Od(n) : n);
      return;
    }
    const a = e.tagName;
    if (t === "value" && a !== "PROGRESS" && !a.includes("-")) {
      const i = a === "OPTION" ? e.getAttribute("value") || "" : e.value,
        l = n == null ? e.type === "checkbox" ? "on" : "" : String(n);
      (i !== l || !("_value" in e)) && (e.value = l), n == null && e.removeAttribute(t), e._value = n;
      return;
    }
    let r = !1;
    if (n === "" || n == null) {
      const i = typeof e[t];
      i === "boolean" ? n = Uu(n) : n == null && i === "string" ? (n = "", r = !0) : i === "number" && (n = 0, r = !0);
    }
    try {
      e[t] = n;
    } catch (i) {
      r || On(`Failed setting prop "${t}" on <${a.toLowerCase()}>: value ${n} is invalid.`, i);
    }
    r && e.removeAttribute(s || t);
  }
  function Hn(e, t, n, o) {
    e.addEventListener(t, n, o);
  }
  function ST(e, t, n, o) {
    e.removeEventListener(t, n, o);
  }
  const Hd = Symbol("_vei");
  function PT(e, t, n, o, s = null) {
    const a = e[Hd] || (e[Hd] = {}),
      r = a[t];
    if (o && r) r.value = Wd(o, t);else {
      const [i, l] = bT(t);
      if (o) {
        const u = a[t] = IT(Wd(o, t), s);
        Hn(e, i, u, l);
      } else r && (ST(e, i, r, l), a[t] = void 0);
    }
  }
  const Gd = /(?:Once|Passive|Capture)$/;
  function bT(e) {
    let t;
    if (Gd.test(e)) {
      t = {};
      let o;
      for (; o = e.match(Gd);) e = e.slice(0, e.length - o[0].length), t[o[0].toLowerCase()] = !0;
    }
    return [e[2] === ":" ? e.slice(3) : Qn(e.slice(2)), t];
  }
  let Pr = 0;
  const OT = Promise.resolve(),
    ET = () => Pr || (OT.then(() => Pr = 0), Pr = Date.now());
  function IT(e, t) {
    const n = o => {
      if (!o._vts) o._vts = Date.now();else if (o._vts <= n.attached) return;
      hn(RT(o, n.value), t, 5, [o]);
    };
    return n.value = e, n.attached = ET(), n;
  }
  function Wd(e, t) {
    return we(e) || Ie(e) ? e : (On(`Wrong type passed as event handler to ${t} - did you forget @ or : in front of your prop?
Expected function or array of functions, received type ${typeof e}.`), Mt);
  }
  function RT(e, t) {
    if (Ie(t)) {
      const n = e.stopImmediatePropagation;
      return e.stopImmediatePropagation = () => {
        n.call(e), e._stopped = !0;
      }, t.map(o => s => !s._stopped && o && o(s));
    } else return t;
  }
  const Vd = e => e.charCodeAt(0) === 111 && e.charCodeAt(1) === 110 && e.charCodeAt(2) > 96 && e.charCodeAt(2) < 123,
    NT = (e, t, n, o, s, a) => {
      const r = s === "svg";
      t === "class" ? mT(e, o, r) : t === "style" ? gT(e, n, o) : ps(t) ? _a(t) || PT(e, t, n, o, a) : (t[0] === "." ? (t = t.slice(1), !0) : t[0] === "^" ? (t = t.slice(1), !1) : AT(e, t, o, r)) ? (xd(e, t, o), !e.tagName.includes("-") && (t === "value" || t === "checked" || t === "selected") && Bd(e, t, o, r, a, t !== "value")) : e._isVueCE && (/[A-Z]/.test(t) || !at(o)) ? xd(e, Ut(t), o, a, t) : (t === "true-value" ? e._trueValue = o : t === "false-value" && (e._falseValue = o), Bd(e, t, o, r));
    };
  function AT(e, t, n, o) {
    if (o) return !!(t === "innerHTML" || t === "textContent" || t in e && Vd(t) && we(n));
    if (t === "spellcheck" || t === "draggable" || t === "translate" || t === "autocorrect" || t === "form" || t === "list" && e.tagName === "INPUT" || t === "type" && e.tagName === "TEXTAREA") return !1;
    if (t === "width" || t === "height") {
      const s = e.tagName;
      if (s === "IMG" || s === "VIDEO" || s === "CANVAS" || s === "SOURCE") return !1;
    }
    return Vd(t) && at(n) ? !1 : t in e;
  }
  const to = e => {
    const t = e.props["onUpdate:modelValue"] || !1;
    return Ie(t) ? n => ko(t, n) : t;
  };
  function MT(e) {
    e.target.composing = !0;
  }
  function jd(e) {
    const t = e.target;
    t.composing && (t.composing = !1, t.dispatchEvent(new Event("input")));
  }
  const en = Symbol("_assign"),
    dt = {
      created(e, {
        modifiers: {
          lazy: t,
          trim: n,
          number: o
        }
      }, s) {
        e[en] = to(s);
        const a = o || s.props && s.props.type === "number";
        Hn(e, t ? "change" : "input", r => {
          if (r.target.composing) return;
          let i = e.value;
          n && (i = i.trim()), a && (i = ma(i)), e[en](i);
        }), n && Hn(e, "change", () => {
          e.value = e.value.trim();
        }), t || (Hn(e, "compositionstart", MT), Hn(e, "compositionend", jd), Hn(e, "change", jd));
      },
      mounted(e, {
        value: t
      }) {
        e.value = t ?? "";
      },
      beforeUpdate(e, {
        value: t,
        oldValue: n,
        modifiers: {
          lazy: o,
          trim: s,
          number: a
        }
      }, r) {
        if (e[en] = to(r), e.composing) return;
        const i = (a || e.type === "number") && !/^0\d/.test(e.value) ? ma(e.value) : e.value,
          l = t ?? "";
        i !== l && (document.activeElement === e && e.type !== "range" && (o && t === n || s && e.value.trim() === l) || (e.value = l));
      }
    },
    zd = {
      deep: !0,
      created(e, t, n) {
        e[en] = to(n), Hn(e, "change", () => {
          const o = e._modelValue,
            s = qo(e),
            a = e.checked,
            r = e[en];
          if (Ie(o)) {
            const i = Mi(o, s),
              l = i !== -1;
            if (a && !l) r(o.concat(s));else if (!a && l) {
              const u = [...o];
              u.splice(i, 1), r(u);
            }
          } else if (Lo(o)) {
            const i = new Set(o);
            a ? i.add(s) : i.delete(s), r(i);
          } else r(qd(e, a));
        });
      },
      mounted: Kd,
      beforeUpdate(e, t, n) {
        e[en] = to(n), Kd(e, t, n);
      }
    };
  function Kd(e, {
    value: t,
    oldValue: n
  }, o) {
    e._modelValue = t;
    let s;
    if (Ie(t)) s = Mi(t, o.props.value) > -1;else if (Lo(t)) s = t.has(o.props.value);else {
      if (t === n) return;
      s = uo(t, qd(e, !0));
    }
    e.checked !== s && (e.checked = s);
  }
  const Yd = {
      created(e, {
        value: t
      }, n) {
        e.checked = uo(t, n.props.value), e[en] = to(n), Hn(e, "change", () => {
          e[en](qo(e));
        });
      },
      beforeUpdate(e, {
        value: t,
        oldValue: n
      }, o) {
        e[en] = to(o), t !== n && (e.checked = uo(t, o.props.value));
      }
    },
    Ke = {
      deep: !0,
      created(e, {
        value: t,
        modifiers: {
          number: n
        }
      }, o) {
        const s = Lo(t);
        Hn(e, "change", () => {
          const a = Array.prototype.filter.call(e.options, r => r.selected).map(r => n ? ma(qo(r)) : qo(r));
          e[en](e.multiple ? s ? new Set(a) : a : a[0]), e._assigning = !0, Ho(() => {
            e._assigning = !1;
          });
        }), e[en] = to(o);
      },
      mounted(e, {
        value: t
      }) {
        Qd(e, t);
      },
      beforeUpdate(e, t, n) {
        e[en] = to(n);
      },
      updated(e, {
        value: t
      }) {
        e._assigning || Qd(e, t);
      }
    };
  function Qd(e, t) {
    const n = e.multiple,
      o = Ie(t);
    if (n && !o && !Lo(t)) {
      On(`<select multiple v-model> expects an Array or Set value for its binding, but got ${Object.prototype.toString.call(t).slice(8, -1)}.`);
      return;
    }
    for (let s = 0, a = e.options.length; s < a; s++) {
      const r = e.options[s],
        i = qo(r);
      if (n) {
        if (o) {
          const l = typeof i;
          l === "string" || l === "number" ? r.selected = t.some(u => String(u) === String(i)) : r.selected = Mi(t, i) > -1;
        } else r.selected = t.has(i);
      } else if (uo(qo(r), t)) {
        e.selectedIndex !== s && (e.selectedIndex = s);
        return;
      }
    }
    !n && e.selectedIndex !== -1 && (e.selectedIndex = -1);
  }
  function qo(e) {
    return "_value" in e ? e._value : e.value;
  }
  function qd(e, t) {
    const n = t ? "_trueValue" : "_falseValue";
    return n in e ? e[n] : t;
  }
  const wT = ["ctrl", "shift", "alt", "meta"],
    LT = {
      stop: e => e.stopPropagation(),
      prevent: e => e.preventDefault(),
      self: e => e.target !== e.currentTarget,
      ctrl: e => !e.ctrlKey,
      shift: e => !e.shiftKey,
      alt: e => !e.altKey,
      meta: e => !e.metaKey,
      left: e => "button" in e && e.button !== 0,
      middle: e => "button" in e && e.button !== 1,
      right: e => "button" in e && e.button !== 2,
      exact: (e, t) => wT.some(n => e[`${n}Key`] && !t.includes(n))
    },
    no = (e, t) => {
      const n = e._withMods || (e._withMods = {}),
        o = t.join(".");
      return n[o] || (n[o] = (s, ...a) => {
        for (let r = 0; r < t.length; r++) {
          const i = LT[t[r]];
          if (i && i(s, t)) return;
        }
        return e(s, ...a);
      });
    },
    kT = ct({
      patchProp: NT
    }, cT);
  let Xd;
  function $T() {
    return Xd || (Xd = EC(kT));
  }
  const Zd = (...e) => {
    const t = $T().createApp(...e);
    UT(t), BT(t);
    const {
      mount: n
    } = t;
    return t.mount = o => {
      const s = xT(o);
      if (!s) return;
      const a = t._component;
      !we(a) && !a.render && !a.template && (a.template = s.innerHTML), s.nodeType === 1 && (s.textContent = "");
      const r = n(s, !1, FT(s));
      return s instanceof Element && (s.removeAttribute("v-cloak"), s.setAttribute("data-v-app", "")), r;
    }, t;
  };
  function FT(e) {
    if (e instanceof SVGElement) return "svg";
    if (typeof MathMLElement == "function" && e instanceof MathMLElement) return "mathml";
  }
  function UT(e) {
    Object.defineProperty(e.config, "isNativeTag", {
      value: t => Uv(t) || Bv(t) || xv(t),
      writable: !1
    });
  }
  function BT(e) {
    {
      const t = e.config.isCustomElement;
      Object.defineProperty(e.config, "isCustomElement", {
        get() {
          return t;
        },
        set() {
          On("The `isCustomElement` config option is deprecated. Use `compilerOptions.isCustomElement` instead.");
        }
      });
      const n = e.config.compilerOptions,
        o = 'The `compilerOptions` config option is only respected when using a build of Vue.js that includes the runtime compiler (aka "full build"). Since you are using the runtime-only build, `compilerOptions` must be passed to `@vue/compiler-dom` in the build setup instead.\n- For vue-loader: pass it via vue-loader\'s `compilerOptions` loader option.\n- For vue-cli: see https://cli.vuejs.org/guide/webpack.html#modifying-options-of-a-loader\n- For vite: pass it via @vitejs/plugin-vue options. See https://github.com/vitejs/vite-plugin-vue/tree/main/packages/plugin-vue#example-for-passing-options-to-vuecompiler-sfc';
      Object.defineProperty(e.config, "compilerOptions", {
        get() {
          return On(o), n;
        },
        set() {
          On(o);
        }
      });
    }
  }
  function xT(e) {
    if (at(e)) {
      const t = document.querySelector(e);
      return t || On(`Failed to mount app: mount target selector "${e}" returned null.`), t;
    }
    return window.ShadowRoot && e instanceof window.ShadowRoot && e.mode === "closed" && On('mounting on a ShadowRoot with `{mode: "closed"}` may lead to unpredictable bugs'), e;
  }
  function HT() {
    rT();
  }
  HT();
  var GT = Object.create,
    Jd = Object.defineProperty,
    WT = Object.getOwnPropertyDescriptor,
    br = Object.getOwnPropertyNames,
    VT = Object.getPrototypeOf,
    jT = Object.prototype.hasOwnProperty,
    zT = (e, t) => function () {
      return e && (t = (0, e[br(e)[0]])(e = 0)), t;
    },
    KT = (e, t) => function () {
      return t || (0, e[br(e)[0]])((t = {
        exports: {}
      }).exports, t), t.exports;
    },
    YT = (e, t, n, o) => {
      if (t && typeof t == "object" || typeof t == "function") for (let s of br(t)) !jT.call(e, s) && s !== n && Jd(e, s, {
        get: () => t[s],
        enumerable: !(o = WT(t, s)) || o.enumerable
      });
      return e;
    },
    QT = (e, t, n) => (n = e != null ? GT(VT(e)) : {}, YT(Jd(n, "default", {
      value: e,
      enumerable: !0
    }), e)),
    Hs = zT({
      "../../node_modules/.pnpm/tsup@8.4.0_@microsoft+api-extractor@7.51.1_@types+node@22.13.14__jiti@2.4.2_postcss@8.5_96eb05a9d65343021e53791dd83f3773/node_modules/tsup/assets/esm_shims.js"() {}
    }),
    qT = KT({
      "../../node_modules/.pnpm/rfdc@1.4.1/node_modules/rfdc/index.js"(e, t) {
        Hs(), t.exports = o;
        function n(a) {
          return a instanceof Buffer ? Buffer.from(a) : new a.constructor(a.buffer.slice(), a.byteOffset, a.length);
        }
        function o(a) {
          if (a = a || {}, a.circles) return s(a);
          const r = new Map();
          if (r.set(Date, d => new Date(d)), r.set(Map, (d, p) => new Map(l(Array.from(d), p))), r.set(Set, (d, p) => new Set(l(Array.from(d), p))), a.constructorHandlers) for (const d of a.constructorHandlers) r.set(d[0], d[1]);
          let i = null;
          return a.proto ? c : u;
          function l(d, p) {
            const f = Object.keys(d),
              v = new Array(f.length);
            for (let h = 0; h < f.length; h++) {
              const m = f[h],
                D = d[m];
              typeof D != "object" || D === null ? v[m] = D : D.constructor !== Object && (i = r.get(D.constructor)) ? v[m] = i(D, p) : ArrayBuffer.isView(D) ? v[m] = n(D) : v[m] = p(D);
            }
            return v;
          }
          function u(d) {
            if (typeof d != "object" || d === null) return d;
            if (Array.isArray(d)) return l(d, u);
            if (d.constructor !== Object && (i = r.get(d.constructor))) return i(d, u);
            const p = {};
            for (const f in d) {
              if (Object.hasOwnProperty.call(d, f) === !1) continue;
              const v = d[f];
              typeof v != "object" || v === null ? p[f] = v : v.constructor !== Object && (i = r.get(v.constructor)) ? p[f] = i(v, u) : ArrayBuffer.isView(v) ? p[f] = n(v) : p[f] = u(v);
            }
            return p;
          }
          function c(d) {
            if (typeof d != "object" || d === null) return d;
            if (Array.isArray(d)) return l(d, c);
            if (d.constructor !== Object && (i = r.get(d.constructor))) return i(d, c);
            const p = {};
            for (const f in d) {
              const v = d[f];
              typeof v != "object" || v === null ? p[f] = v : v.constructor !== Object && (i = r.get(v.constructor)) ? p[f] = i(v, c) : ArrayBuffer.isView(v) ? p[f] = n(v) : p[f] = c(v);
            }
            return p;
          }
        }
        function s(a) {
          const r = [],
            i = [],
            l = new Map();
          if (l.set(Date, f => new Date(f)), l.set(Map, (f, v) => new Map(c(Array.from(f), v))), l.set(Set, (f, v) => new Set(c(Array.from(f), v))), a.constructorHandlers) for (const f of a.constructorHandlers) l.set(f[0], f[1]);
          let u = null;
          return a.proto ? p : d;
          function c(f, v) {
            const h = Object.keys(f),
              m = new Array(h.length);
            for (let D = 0; D < h.length; D++) {
              const N = h[D],
                I = f[N];
              if (typeof I != "object" || I === null) m[N] = I;else if (I.constructor !== Object && (u = l.get(I.constructor))) m[N] = u(I, v);else if (ArrayBuffer.isView(I)) m[N] = n(I);else {
                const w = r.indexOf(I);
                w !== -1 ? m[N] = i[w] : m[N] = v(I);
              }
            }
            return m;
          }
          function d(f) {
            if (typeof f != "object" || f === null) return f;
            if (Array.isArray(f)) return c(f, d);
            if (f.constructor !== Object && (u = l.get(f.constructor))) return u(f, d);
            const v = {};
            r.push(f), i.push(v);
            for (const h in f) {
              if (Object.hasOwnProperty.call(f, h) === !1) continue;
              const m = f[h];
              if (typeof m != "object" || m === null) v[h] = m;else if (m.constructor !== Object && (u = l.get(m.constructor))) v[h] = u(m, d);else if (ArrayBuffer.isView(m)) v[h] = n(m);else {
                const D = r.indexOf(m);
                D !== -1 ? v[h] = i[D] : v[h] = d(m);
              }
            }
            return r.pop(), i.pop(), v;
          }
          function p(f) {
            if (typeof f != "object" || f === null) return f;
            if (Array.isArray(f)) return c(f, p);
            if (f.constructor !== Object && (u = l.get(f.constructor))) return u(f, p);
            const v = {};
            r.push(f), i.push(v);
            for (const h in f) {
              const m = f[h];
              if (typeof m != "object" || m === null) v[h] = m;else if (m.constructor !== Object && (u = l.get(m.constructor))) v[h] = u(m, p);else if (ArrayBuffer.isView(m)) v[h] = n(m);else {
                const D = r.indexOf(m);
                D !== -1 ? v[h] = i[D] : v[h] = p(m);
              }
            }
            return r.pop(), i.pop(), v;
          }
        }
      }
    });
  Hs(), Hs(), Hs();
  var ef = typeof navigator < "u",
    Ee = typeof window < "u" ? window : typeof globalThis < "u" ? globalThis : typeof global < "u" ? global : {};
  typeof Ee.chrome < "u" && Ee.chrome.devtools, ef && (Ee.self, Ee.top);
  var tf;
  typeof navigator < "u" && ((tf = navigator.userAgent) == null || tf.toLowerCase().includes("electron")), Hs();
  var XT = QT(qT()),
    ZT = /(?:^|[-_/])(\w)/g;
  function JT(e, t) {
    return t ? t.toUpperCase() : "";
  }
  function eg(e) {
    return e && `${e}`.replace(ZT, JT);
  }
  function tg(e, t) {
    let n = e.replace(/^[a-z]:/i, "").replace(/\\/g, "/");
    n.endsWith(`index${t}`) && (n = n.replace(`/index${t}`, t));
    const o = n.lastIndexOf("/"),
      s = n.substring(o + 1);
    {
      const a = s.lastIndexOf(t);
      return s.substring(0, a);
    }
  }
  var nf = (0, XT.default)({
    circles: !0
  });
  const ng = {
    trailing: !0
  };
  function Xo(e, t = 25, n = {}) {
    if (n = {
      ...ng,
      ...n
    }, !Number.isFinite(t)) throw new TypeError("Expected `wait` to be a finite number");
    let o,
      s,
      a = [],
      r,
      i;
    const l = (u, c) => (r = og(e, u, c), r.finally(() => {
      if (r = null, n.trailing && i && !s) {
        const d = l(u, i);
        return i = null, d;
      }
    }), r);
    return function (...u) {
      return r ? (n.trailing && (i = u), r) : new Promise(c => {
        const d = !s && n.leading;
        clearTimeout(s), s = setTimeout(() => {
          s = null;
          const p = n.leading ? o : l(this, u);
          for (const f of a) f(p);
          a = [];
        }, t), d ? (o = l(this, u), c(o)) : a.push(c);
      });
    };
  }
  async function og(e, t, n) {
    return await e.apply(t, n);
  }
  function Or(e, t = {}, n) {
    for (const o in e) {
      const s = e[o],
        a = n ? `${n}:${o}` : o;
      typeof s == "object" && s !== null ? Or(s, t, a) : typeof s == "function" && (t[a] = s);
    }
    return t;
  }
  const sg = {
      run: e => e()
    },
    ag = () => sg,
    of = typeof console.createTask < "u" ? console.createTask : ag;
  function ig(e, t) {
    const n = t.shift(),
      o = of(n);
    return e.reduce((s, a) => s.then(() => o.run(() => a(...t))), Promise.resolve());
  }
  function rg(e, t) {
    const n = t.shift(),
      o = of(n);
    return Promise.all(e.map(s => o.run(() => s(...t))));
  }
  function Er(e, t) {
    for (const n of [...e]) n(t);
  }
  class lg {
    constructor() {
      this._hooks = {}, this._before = void 0, this._after = void 0, this._deprecatedMessages = void 0, this._deprecatedHooks = {}, this.hook = this.hook.bind(this), this.callHook = this.callHook.bind(this), this.callHookWith = this.callHookWith.bind(this);
    }
    hook(t, n, o = {}) {
      if (!t || typeof n != "function") return () => {};
      const s = t;
      let a;
      for (; this._deprecatedHooks[t];) a = this._deprecatedHooks[t], t = a.to;
      if (a && !o.allowDeprecated) {
        let r = a.message;
        r || (r = `${s} hook has been deprecated` + (a.to ? `, please use ${a.to}` : "")), this._deprecatedMessages || (this._deprecatedMessages = new Set()), this._deprecatedMessages.has(r) || (console.warn(r), this._deprecatedMessages.add(r));
      }
      if (!n.name) try {
        Object.defineProperty(n, "name", {
          get: () => "_" + t.replace(/\W+/g, "_") + "_hook_cb",
          configurable: !0
        });
      } catch {}
      return this._hooks[t] = this._hooks[t] || [], this._hooks[t].push(n), () => {
        n && (this.removeHook(t, n), n = void 0);
      };
    }
    hookOnce(t, n) {
      let o,
        s = (...a) => (typeof o == "function" && o(), o = void 0, s = void 0, n(...a));
      return o = this.hook(t, s), o;
    }
    removeHook(t, n) {
      if (this._hooks[t]) {
        const o = this._hooks[t].indexOf(n);
        o !== -1 && this._hooks[t].splice(o, 1), this._hooks[t].length === 0 && delete this._hooks[t];
      }
    }
    deprecateHook(t, n) {
      this._deprecatedHooks[t] = typeof n == "string" ? {
        to: n
      } : n;
      const o = this._hooks[t] || [];
      delete this._hooks[t];
      for (const s of o) this.hook(t, s);
    }
    deprecateHooks(t) {
      Object.assign(this._deprecatedHooks, t);
      for (const n in t) this.deprecateHook(n, t[n]);
    }
    addHooks(t) {
      const n = Or(t),
        o = Object.keys(n).map(s => this.hook(s, n[s]));
      return () => {
        for (const s of o.splice(0, o.length)) s();
      };
    }
    removeHooks(t) {
      const n = Or(t);
      for (const o in n) this.removeHook(o, n[o]);
    }
    removeAllHooks() {
      for (const t in this._hooks) delete this._hooks[t];
    }
    callHook(t, ...n) {
      return n.unshift(t), this.callHookWith(ig, t, ...n);
    }
    callHookParallel(t, ...n) {
      return n.unshift(t), this.callHookWith(rg, t, ...n);
    }
    callHookWith(t, n, ...o) {
      const s = this._before || this._after ? {
        name: n,
        args: o,
        context: {}
      } : void 0;
      this._before && Er(this._before, s);
      const a = t(n in this._hooks ? [...this._hooks[n]] : [], o);
      return a instanceof Promise ? a.finally(() => {
        this._after && s && Er(this._after, s);
      }) : (this._after && s && Er(this._after, s), a);
    }
    beforeEach(t) {
      return this._before = this._before || [], this._before.push(t), () => {
        if (this._before !== void 0) {
          const n = this._before.indexOf(t);
          n !== -1 && this._before.splice(n, 1);
        }
      };
    }
    afterEach(t) {
      return this._after = this._after || [], this._after.push(t), () => {
        if (this._after !== void 0) {
          const n = this._after.indexOf(t);
          n !== -1 && this._after.splice(n, 1);
        }
      };
    }
  }
  function sf() {
    return new lg();
  }
  var ug = Object.create,
    af = Object.defineProperty,
    cg = Object.getOwnPropertyDescriptor,
    Ir = Object.getOwnPropertyNames,
    dg = Object.getPrototypeOf,
    fg = Object.prototype.hasOwnProperty,
    pg = (e, t) => function () {
      return e && (t = (0, e[Ir(e)[0]])(e = 0)), t;
    },
    rf = (e, t) => function () {
      return t || (0, e[Ir(e)[0]])((t = {
        exports: {}
      }).exports, t), t.exports;
    },
    _g = (e, t, n, o) => {
      if (t && typeof t == "object" || typeof t == "function") for (let s of Ir(t)) !fg.call(e, s) && s !== n && af(e, s, {
        get: () => t[s],
        enumerable: !(o = cg(t, s)) || o.enumerable
      });
      return e;
    },
    hg = (e, t, n) => (n = e != null ? ug(dg(e)) : {}, _g(af(n, "default", {
      value: e,
      enumerable: !0
    }), e)),
    he = pg({
      "../../node_modules/.pnpm/tsup@8.4.0_@microsoft+api-extractor@7.51.1_@types+node@22.13.14__jiti@2.4.2_postcss@8.5_96eb05a9d65343021e53791dd83f3773/node_modules/tsup/assets/esm_shims.js"() {}
    }),
    vg = rf({
      "../../node_modules/.pnpm/speakingurl@14.0.1/node_modules/speakingurl/lib/speakingurl.js"(e, t) {
        he(), function (n) {
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
            a = {
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
            r = {
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
            u = [";", "?", ":", "@", "&", "=", "+", "$", ","].join(""),
            c = [".", "!", "~", "*", "'", "(", ")"].join(""),
            d = function (m, D) {
              var N = "-",
                I = "",
                w = "",
                A = !0,
                j = {},
                B,
                T,
                g,
                C,
                S,
                R,
                E,
                L,
                G,
                X,
                K,
                de,
                be,
                xe,
                ee = "";
              if (typeof m != "string") return "";
              if (typeof D == "string" && (N = D), E = i.en, L = r.en, typeof D == "object") {
                B = D.maintainCase || !1, j = D.custom && typeof D.custom == "object" ? D.custom : j, g = +D.truncate > 1 && D.truncate || !1, C = D.uric || !1, S = D.uricNoSlash || !1, R = D.mark || !1, A = !(D.symbols === !1 || D.lang === !1), N = D.separator || N, C && (ee += l), S && (ee += u), R && (ee += c), E = D.lang && i[D.lang] && A ? i[D.lang] : A ? i.en : {}, L = D.lang && r[D.lang] ? r[D.lang] : D.lang === !1 || D.lang === !0 ? {} : r.en, D.titleCase && typeof D.titleCase.length == "number" && Array.prototype.toString.call(D.titleCase) ? (D.titleCase.forEach(function (M) {
                  j[M + ""] = M + "";
                }), T = !0) : T = !!D.titleCase, D.custom && typeof D.custom.length == "number" && Array.prototype.toString.call(D.custom) && D.custom.forEach(function (M) {
                  j[M + ""] = M + "";
                }), Object.keys(j).forEach(function (M) {
                  var k;
                  M.length > 1 ? k = new RegExp("\\b" + f(M) + "\\b", "gi") : k = new RegExp(f(M), "gi"), m = m.replace(k, j[M]);
                });
                for (K in j) ee += K;
              }
              for (ee += N, ee = f(ee), m = m.replace(/(^\s+|\s+$)/g, ""), be = !1, xe = !1, X = 0, de = m.length; X < de; X++) K = m[X], v(K, j) ? be = !1 : L[K] ? (K = be && L[K].match(/[A-Za-z0-9]/) ? " " + L[K] : L[K], be = !1) : K in o ? (X + 1 < de && s.indexOf(m[X + 1]) >= 0 ? (w += K, K = "") : xe === !0 ? (K = a[w] + o[K], w = "") : K = be && o[K].match(/[A-Za-z0-9]/) ? " " + o[K] : o[K], be = !1, xe = !1) : K in a ? (w += K, K = "", X === de - 1 && (K = a[w]), xe = !0) : E[K] && !(C && l.indexOf(K) !== -1) && !(S && u.indexOf(K) !== -1) ? (K = be || I.substr(-1).match(/[A-Za-z0-9]/) ? N + E[K] : E[K], K += m[X + 1] !== void 0 && m[X + 1].match(/[A-Za-z0-9]/) ? N : "", be = !0) : (xe === !0 ? (K = a[w] + K, w = "", xe = !1) : be && (/[A-Za-z0-9]/.test(K) || I.substr(-1).match(/A-Za-z0-9]/)) && (K = " " + K), be = !1), I += K.replace(new RegExp("[^\\w\\s" + ee + "_-]", "g"), N);
              return T && (I = I.replace(/(\w)(\S*)/g, function (M, k, W) {
                var Q = k.toUpperCase() + (W !== null ? W : "");
                return Object.keys(j).indexOf(Q.toLowerCase()) < 0 ? Q : Q.toLowerCase();
              })), I = I.replace(/\s+/g, N).replace(new RegExp("\\" + N + "+", "g"), N).replace(new RegExp("(^\\" + N + "+|\\" + N + "+$)", "g"), ""), g && I.length > g && (G = I.charAt(g) === N, I = I.slice(0, g), G || (I = I.slice(0, I.lastIndexOf(N)))), !B && !T && (I = I.toLowerCase()), I;
            },
            p = function (m) {
              return function (N) {
                return d(N, m);
              };
            },
            f = function (m) {
              return m.replace(/[-\\^$*+?.()|[\]{}\/]/g, "\\$&");
            },
            v = function (h, m) {
              for (var D in m) if (m[D] === h) return !0;
            };
          if (typeof t < "u" && t.exports) t.exports = d, t.exports.createSlug = p;else if (typeof define < "u" && define.amd) define([], function () {
            return d;
          });else try {
            if (n.getSlug || n.createSlug) throw "speakingurl: globals exists /(getSlug|createSlug)/";
            n.getSlug = d, n.createSlug = p;
          } catch {}
        }(e);
      }
    }),
    mg = rf({
      "../../node_modules/.pnpm/speakingurl@14.0.1/node_modules/speakingurl/index.js"(e, t) {
        he(), t.exports = vg();
      }
    });
  he(), he(), he(), he(), he(), he(), he(), he();
  function Cg(e) {
    var t;
    const n = e.name || e._componentTag || e.__VUE_DEVTOOLS_COMPONENT_GUSSED_NAME__ || e.__name;
    return n === "index" && (t = e.__file) != null && t.endsWith("index.vue") ? "" : n;
  }
  function Tg(e) {
    const t = e.__file;
    if (t) return eg(tg(t, ".vue"));
  }
  function lf(e, t) {
    return e.type.__VUE_DEVTOOLS_COMPONENT_GUSSED_NAME__ = t, t;
  }
  function Rr(e) {
    if (e.__VUE_DEVTOOLS_NEXT_APP_RECORD__) return e.__VUE_DEVTOOLS_NEXT_APP_RECORD__;
    if (e.root) return e.appContext.app.__VUE_DEVTOOLS_NEXT_APP_RECORD__;
  }
  function uf(e) {
    var t, n;
    const o = (t = e.subTree) == null ? void 0 : t.type,
      s = Rr(e);
    return s ? ((n = s?.types) == null ? void 0 : n.Fragment) === o : !1;
  }
  function Xa(e) {
    var t, n, o;
    const s = Cg(e?.type || {});
    if (s) return s;
    if (e?.root === e) return "Root";
    for (const r in (n = (t = e.parent) == null ? void 0 : t.type) == null ? void 0 : n.components) if (e.parent.type.components[r] === e?.type) return lf(e, r);
    for (const r in (o = e.appContext) == null ? void 0 : o.components) if (e.appContext.components[r] === e?.type) return lf(e, r);
    const a = Tg(e?.type || {});
    return a || "Anonymous Component";
  }
  function gg(e) {
    var t, n, o;
    const s = (o = (n = (t = e?.appContext) == null ? void 0 : t.app) == null ? void 0 : n.__VUE_DEVTOOLS_NEXT_APP_RECORD_ID__) != null ? o : 0,
      a = e === e?.root ? "root" : e.uid;
    return `${s}:${a}`;
  }
  function Nr(e, t) {
    return t = t || `${e.id}:root`, e.instanceMap.get(t) || e.instanceMap.get(":root");
  }
  function yg() {
    const e = {
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      get width() {
        return e.right - e.left;
      },
      get height() {
        return e.bottom - e.top;
      }
    };
    return e;
  }
  var Za;
  function Dg(e) {
    return Za || (Za = document.createRange()), Za.selectNode(e), Za.getBoundingClientRect();
  }
  function Sg(e) {
    const t = yg();
    if (!e.children) return t;
    for (let n = 0, o = e.children.length; n < o; n++) {
      const s = e.children[n];
      let a;
      if (s.component) a = Po(s.component);else if (s.el) {
        const r = s.el;
        r.nodeType === 1 || r.getBoundingClientRect ? a = r.getBoundingClientRect() : r.nodeType === 3 && r.data.trim() && (a = Dg(r));
      }
      a && Pg(t, a);
    }
    return t;
  }
  function Pg(e, t) {
    return (!e.top || t.top < e.top) && (e.top = t.top), (!e.bottom || t.bottom > e.bottom) && (e.bottom = t.bottom), (!e.left || t.left < e.left) && (e.left = t.left), (!e.right || t.right > e.right) && (e.right = t.right), e;
  }
  var cf = {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: 0,
    height: 0
  };
  function Po(e) {
    const t = e.subTree.el;
    return typeof window > "u" ? cf : uf(e) ? Sg(e.subTree) : t?.nodeType === 1 ? t?.getBoundingClientRect() : e.subTree.component ? Po(e.subTree.component) : cf;
  }
  he();
  function Ar(e) {
    return uf(e) ? bg(e.subTree) : e.subTree ? [e.subTree.el] : [];
  }
  function bg(e) {
    if (!e.children) return [];
    const t = [];
    return e.children.forEach(n => {
      n.component ? t.push(...Ar(n.component)) : n?.el && t.push(n.el);
    }), t;
  }
  var df = "__vue-devtools-component-inspector__",
    ff = "__vue-devtools-component-inspector__card__",
    pf = "__vue-devtools-component-inspector__name__",
    _f = "__vue-devtools-component-inspector__indicator__",
    hf = {
      display: "block",
      zIndex: 2147483640,
      position: "fixed",
      backgroundColor: "#42b88325",
      border: "1px solid #42b88350",
      borderRadius: "5px",
      transition: "all 0.1s ease-in",
      pointerEvents: "none"
    },
    Og = {
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
    Eg = {
      display: "inline-block",
      fontWeight: 400,
      fontStyle: "normal",
      fontSize: "12px",
      opacity: .7
    };
  function Zo() {
    return document.getElementById(df);
  }
  function Ig() {
    return document.getElementById(ff);
  }
  function Rg() {
    return document.getElementById(_f);
  }
  function Ng() {
    return document.getElementById(pf);
  }
  function Mr(e) {
    return {
      left: `${Math.round(e.left * 100) / 100}px`,
      top: `${Math.round(e.top * 100) / 100}px`,
      width: `${Math.round(e.width * 100) / 100}px`,
      height: `${Math.round(e.height * 100) / 100}px`
    };
  }
  function wr(e) {
    var t;
    const n = document.createElement("div");
    n.id = (t = e.elementId) != null ? t : df, Object.assign(n.style, {
      ...hf,
      ...Mr(e.bounds),
      ...e.style
    });
    const o = document.createElement("span");
    o.id = ff, Object.assign(o.style, {
      ...Og,
      top: e.bounds.top < 35 ? 0 : "-35px"
    });
    const s = document.createElement("span");
    s.id = pf, s.innerHTML = `&lt;${e.name}&gt;&nbsp;&nbsp;`;
    const a = document.createElement("i");
    return a.id = _f, a.innerHTML = `${Math.round(e.bounds.width * 100) / 100} x ${Math.round(e.bounds.height * 100) / 100}`, Object.assign(a.style, Eg), o.appendChild(s), o.appendChild(a), n.appendChild(o), document.body.appendChild(n), n;
  }
  function Lr(e) {
    const t = Zo(),
      n = Ig(),
      o = Ng(),
      s = Rg();
    t && (Object.assign(t.style, {
      ...hf,
      ...Mr(e.bounds)
    }), Object.assign(n.style, {
      top: e.bounds.top < 35 ? 0 : "-35px"
    }), o.innerHTML = `&lt;${e.name}&gt;&nbsp;&nbsp;`, s.innerHTML = `${Math.round(e.bounds.width * 100) / 100} x ${Math.round(e.bounds.height * 100) / 100}`);
  }
  function Ag(e) {
    const t = Po(e);
    if (!t.width && !t.height) return;
    const n = Xa(e);
    Zo() ? Lr({
      bounds: t,
      name: n
    }) : wr({
      bounds: t,
      name: n
    });
  }
  function vf() {
    const e = Zo();
    e && (e.style.display = "none");
  }
  var kr = null;
  function $r(e) {
    const t = e.target;
    if (t) {
      const n = t.__vueParentComponent;
      if (n && (kr = n, n.vnode.el)) {
        const s = Po(n),
          a = Xa(n);
        Zo() ? Lr({
          bounds: s,
          name: a
        }) : wr({
          bounds: s,
          name: a
        });
      }
    }
  }
  function Mg(e, t) {
    if (e.preventDefault(), e.stopPropagation(), kr) {
      const n = gg(kr);
      t(n);
    }
  }
  var Ja = null;
  function wg() {
    vf(), window.removeEventListener("mouseover", $r), window.removeEventListener("click", Ja, !0), Ja = null;
  }
  function Lg() {
    return window.addEventListener("mouseover", $r), new Promise(e => {
      function t(n) {
        n.preventDefault(), n.stopPropagation(), Mg(n, o => {
          window.removeEventListener("click", t, !0), Ja = null, window.removeEventListener("mouseover", $r);
          const s = Zo();
          s && (s.style.display = "none"), e(JSON.stringify({
            id: o
          }));
        });
      }
      Ja = t, window.addEventListener("click", t, !0);
    });
  }
  function kg(e) {
    const t = Nr(Gt.value, e.id);
    if (t) {
      const [n] = Ar(t);
      if (typeof n.scrollIntoView == "function") n.scrollIntoView({
        behavior: "smooth"
      });else {
        const o = Po(t),
          s = document.createElement("div"),
          a = {
            ...Mr(o),
            position: "absolute"
          };
        Object.assign(s.style, a), document.body.appendChild(s), s.scrollIntoView({
          behavior: "smooth"
        }), setTimeout(() => {
          document.body.removeChild(s);
        }, 2e3);
      }
      setTimeout(() => {
        const o = Po(t);
        if (o.width || o.height) {
          const s = Xa(t),
            a = Zo();
          a ? Lr({
            ...e,
            name: s,
            bounds: o
          }) : wr({
            ...e,
            name: s,
            bounds: o
          }), setTimeout(() => {
            a && (a.style.display = "none");
          }, 1500);
        }
      }, 1200);
    }
  }
  he();
  var mf, Cf;
  (Cf = (mf = Ee).__VUE_DEVTOOLS_COMPONENT_INSPECTOR_ENABLED__) != null || (mf.__VUE_DEVTOOLS_COMPONENT_INSPECTOR_ENABLED__ = !0);
  function $g(e) {
    let t = 0;
    const n = setInterval(() => {
      Ee.__VUE_INSPECTOR__ && (clearInterval(n), t += 30, e()), t >= 5e3 && clearInterval(n);
    }, 30);
  }
  function Fg() {
    const e = Ee.__VUE_INSPECTOR__,
      t = e.openInEditor;
    e.openInEditor = async (...n) => {
      e.disable(), t(...n);
    };
  }
  function Ug() {
    return new Promise(e => {
      function t() {
        Fg(), e(Ee.__VUE_INSPECTOR__);
      }
      Ee.__VUE_INSPECTOR__ ? t() : $g(() => {
        t();
      });
    });
  }
  he(), he();
  function Bg(e) {
    return !!(e && e.__v_isReadonly);
  }
  function Tf(e) {
    return Bg(e) ? Tf(e.__v_raw) : !!(e && e.__v_isReactive);
  }
  function Fr(e) {
    return !!(e && e.__v_isRef === !0);
  }
  function Gs(e) {
    const t = e && e.__v_raw;
    return t ? Gs(t) : e;
  }
  var xg = class {
      constructor() {
        this.refEditor = new Hg();
      }
      set(e, t, n, o) {
        const s = Array.isArray(t) ? t : t.split(".");
        for (; s.length > 1;) {
          const i = s.shift();
          e instanceof Map ? e = e.get(i) : e instanceof Set ? e = Array.from(e.values())[i] : e = e[i], this.refEditor.isRef(e) && (e = this.refEditor.get(e));
        }
        const a = s[0],
          r = this.refEditor.get(e)[a];
        o ? o(e, a, n) : this.refEditor.isRef(r) ? this.refEditor.set(r, n) : e[a] = n;
      }
      get(e, t) {
        const n = Array.isArray(t) ? t : t.split(".");
        for (let o = 0; o < n.length; o++) if (e instanceof Map ? e = e.get(n[o]) : e = e[n[o]], this.refEditor.isRef(e) && (e = this.refEditor.get(e)), !e) return;
        return e;
      }
      has(e, t, n = !1) {
        if (typeof e > "u") return !1;
        const o = Array.isArray(t) ? t.slice() : t.split("."),
          s = n ? 2 : 1;
        for (; e && o.length > s;) {
          const a = o.shift();
          e = e[a], this.refEditor.isRef(e) && (e = this.refEditor.get(e));
        }
        return e != null && Object.prototype.hasOwnProperty.call(e, o[0]);
      }
      createDefaultSetCallback(e) {
        return (t, n, o) => {
          if ((e.remove || e.newKey) && (Array.isArray(t) ? t.splice(n, 1) : Gs(t) instanceof Map ? t.delete(n) : Gs(t) instanceof Set ? t.delete(Array.from(t.values())[n]) : Reflect.deleteProperty(t, n)), !e.remove) {
            const s = t[e.newKey || n];
            this.refEditor.isRef(s) ? this.refEditor.set(s, o) : Gs(t) instanceof Map ? t.set(e.newKey || n, o) : Gs(t) instanceof Set ? t.add(o) : t[e.newKey || n] = o;
          }
        };
      }
    },
    Hg = class {
      set(e, t) {
        if (Fr(e)) e.value = t;else {
          if (e instanceof Set && Array.isArray(t)) {
            e.clear(), t.forEach(s => e.add(s));
            return;
          }
          const n = Object.keys(t);
          if (e instanceof Map) {
            const s = new Set(e.keys());
            n.forEach(a => {
              e.set(a, Reflect.get(t, a)), s.delete(a);
            }), s.forEach(a => e.delete(a));
            return;
          }
          const o = new Set(Object.keys(e));
          n.forEach(s => {
            Reflect.set(e, s, Reflect.get(t, s)), o.delete(s);
          }), o.forEach(s => Reflect.deleteProperty(e, s));
        }
      }
      get(e) {
        return Fr(e) ? e.value : e;
      }
      isRef(e) {
        return Fr(e) || Tf(e);
      }
    };
  he(), he(), he();
  var Gg = "__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS_STATE__";
  function Wg() {
    if (!ef || typeof localStorage > "u" || localStorage === null) return {
      recordingState: !1,
      mouseEventEnabled: !1,
      keyboardEventEnabled: !1,
      componentEventEnabled: !1,
      performanceEventEnabled: !1,
      selected: ""
    };
    const e = localStorage.getItem(Gg);
    return e ? JSON.parse(e) : {
      recordingState: !1,
      mouseEventEnabled: !1,
      keyboardEventEnabled: !1,
      componentEventEnabled: !1,
      performanceEventEnabled: !1,
      selected: ""
    };
  }
  he(), he(), he();
  var gf, yf;
  (yf = (gf = Ee).__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS) != null || (gf.__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS = []);
  var Vg = new Proxy(Ee.__VUE_DEVTOOLS_KIT_TIMELINE_LAYERS, {
    get(e, t, n) {
      return Reflect.get(e, t, n);
    }
  });
  function jg(e, t) {
    gt.timelineLayersState[t.id] = !1, Vg.push({
      ...e,
      descriptorId: t.id,
      appRecord: Rr(t.app)
    });
  }
  var Df, Sf;
  (Sf = (Df = Ee).__VUE_DEVTOOLS_KIT_INSPECTOR__) != null || (Df.__VUE_DEVTOOLS_KIT_INSPECTOR__ = []);
  var Ur = new Proxy(Ee.__VUE_DEVTOOLS_KIT_INSPECTOR__, {
      get(e, t, n) {
        return Reflect.get(e, t, n);
      }
    }),
    Pf = Xo(() => {
      es.hooks.callHook("sendInspectorToClient", bf());
    });
  function zg(e, t) {
    var n, o;
    Ur.push({
      options: e,
      descriptor: t,
      treeFilterPlaceholder: (n = e.treeFilterPlaceholder) != null ? n : "Search tree...",
      stateFilterPlaceholder: (o = e.stateFilterPlaceholder) != null ? o : "Search state...",
      treeFilter: "",
      selectedNodeId: "",
      appRecord: Rr(t.app)
    }), Pf();
  }
  function bf() {
    return Ur.filter(e => e.descriptor.app === Gt.value.app).filter(e => e.descriptor.id !== "components").map(e => {
      var t;
      const n = e.descriptor,
        o = e.options;
      return {
        id: o.id,
        label: o.label,
        logo: n.logo,
        icon: `custom-ic-baseline-${(t = o?.icon) == null ? void 0 : t.replace(/_/g, "-")}`,
        packageName: n.packageName,
        homepage: n.homepage,
        pluginId: n.id
      };
    });
  }
  function ei(e, t) {
    return Ur.find(n => n.options.id === e && (t ? n.descriptor.app === t : !0));
  }
  function Kg() {
    const e = sf();
    e.hook("addInspector", ({
      inspector: o,
      plugin: s
    }) => {
      zg(o, s.descriptor);
    });
    const t = Xo(async ({
      inspectorId: o,
      plugin: s
    }) => {
      var a;
      if (!o || !((a = s?.descriptor) != null && a.app) || gt.highPerfModeEnabled) return;
      const r = ei(o, s.descriptor.app),
        i = {
          app: s.descriptor.app,
          inspectorId: o,
          filter: r?.treeFilter || "",
          rootNodes: []
        };
      await new Promise(l => {
        e.callHookWith(async u => {
          await Promise.all(u.map(c => c(i))), l();
        }, "getInspectorTree");
      }), e.callHookWith(async l => {
        await Promise.all(l.map(u => u({
          inspectorId: o,
          rootNodes: i.rootNodes
        })));
      }, "sendInspectorTreeToClient");
    }, 120);
    e.hook("sendInspectorTree", t);
    const n = Xo(async ({
      inspectorId: o,
      plugin: s
    }) => {
      var a;
      if (!o || !((a = s?.descriptor) != null && a.app) || gt.highPerfModeEnabled) return;
      const r = ei(o, s.descriptor.app),
        i = {
          app: s.descriptor.app,
          inspectorId: o,
          nodeId: r?.selectedNodeId || "",
          state: null
        },
        l = {
          currentTab: `custom-inspector:${o}`
        };
      i.nodeId && (await new Promise(u => {
        e.callHookWith(async c => {
          await Promise.all(c.map(d => d(i, l))), u();
        }, "getInspectorState");
      })), e.callHookWith(async u => {
        await Promise.all(u.map(c => c({
          inspectorId: o,
          nodeId: i.nodeId,
          state: i.state
        })));
      }, "sendInspectorStateToClient");
    }, 120);
    return e.hook("sendInspectorState", n), e.hook("customInspectorSelectNode", ({
      inspectorId: o,
      nodeId: s,
      plugin: a
    }) => {
      const r = ei(o, a.descriptor.app);
      r && (r.selectedNodeId = s);
    }), e.hook("timelineLayerAdded", ({
      options: o,
      plugin: s
    }) => {
      jg(o, s.descriptor);
    }), e.hook("timelineEventAdded", ({
      options: o,
      plugin: s
    }) => {
      var a;
      const r = ["performance", "component-event", "keyboard", "mouse"];
      gt.highPerfModeEnabled || !((a = gt.timelineLayersState) != null && a[s.descriptor.id]) && !r.includes(o.layerId) || e.callHookWith(async i => {
        await Promise.all(i.map(l => l(o)));
      }, "sendTimelineEventToClient");
    }), e.hook("getComponentInstances", async ({
      app: o
    }) => {
      const s = o.__VUE_DEVTOOLS_NEXT_APP_RECORD__;
      if (!s) return null;
      const a = s.id.toString();
      return [...s.instanceMap].filter(([i]) => i.split(":")[0] === a).map(([, i]) => i);
    }), e.hook("getComponentBounds", async ({
      instance: o
    }) => Po(o)), e.hook("getComponentName", ({
      instance: o
    }) => Xa(o)), e.hook("componentHighlight", ({
      uid: o
    }) => {
      const s = Gt.value.instanceMap.get(o);
      s && Ag(s);
    }), e.hook("componentUnhighlight", () => {
      vf();
    }), e;
  }
  var Of, Ef;
  (Ef = (Of = Ee).__VUE_DEVTOOLS_KIT_APP_RECORDS__) != null || (Of.__VUE_DEVTOOLS_KIT_APP_RECORDS__ = []);
  var If, Rf;
  (Rf = (If = Ee).__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__) != null || (If.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ = {});
  var Nf, Af;
  (Af = (Nf = Ee).__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__) != null || (Nf.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ = "");
  var Mf, wf;
  (wf = (Mf = Ee).__VUE_DEVTOOLS_KIT_CUSTOM_TABS__) != null || (Mf.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__ = []);
  var Lf, kf;
  (kf = (Lf = Ee).__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__) != null || (Lf.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__ = []);
  var bo = "__VUE_DEVTOOLS_KIT_GLOBAL_STATE__";
  function Yg() {
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
      timelineLayersState: Wg()
    };
  }
  var $f, Ff;
  (Ff = ($f = Ee)[bo]) != null || ($f[bo] = Yg());
  var Qg = Xo(e => {
    es.hooks.callHook("devtoolsStateUpdated", {
      state: e
    });
  });
  Xo((e, t) => {
    es.hooks.callHook("devtoolsConnectedUpdated", {
      state: e,
      oldState: t
    });
  });
  var ti = new Proxy(Ee.__VUE_DEVTOOLS_KIT_APP_RECORDS__, {
      get(e, t, n) {
        return t === "value" ? Ee.__VUE_DEVTOOLS_KIT_APP_RECORDS__ : Ee.__VUE_DEVTOOLS_KIT_APP_RECORDS__[t];
      }
    }),
    Gt = new Proxy(Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__, {
      get(e, t, n) {
        return t === "value" ? Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ : t === "id" ? Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ : Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__[t];
      }
    });
  function Uf() {
    Qg({
      ...Ee[bo],
      appRecords: ti.value,
      activeAppRecordId: Gt.id,
      tabs: Ee.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__,
      commands: Ee.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__
    });
  }
  function qg(e) {
    Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD__ = e, Uf();
  }
  function Xg(e) {
    Ee.__VUE_DEVTOOLS_KIT_ACTIVE_APP_RECORD_ID__ = e, Uf();
  }
  var gt = new Proxy(Ee[bo], {
    get(e, t) {
      return t === "appRecords" ? ti : t === "activeAppRecordId" ? Gt.id : t === "tabs" ? Ee.__VUE_DEVTOOLS_KIT_CUSTOM_TABS__ : t === "commands" ? Ee.__VUE_DEVTOOLS_KIT_CUSTOM_COMMANDS__ : Ee[bo][t];
    },
    deleteProperty(e, t) {
      return delete e[t], !0;
    },
    set(e, t, n) {
      return {
        ...Ee[bo]
      }, e[t] = n, Ee[bo][t] = n, !0;
    }
  });
  function Zg(e = {}) {
    var t, n, o;
    const {
      file: s,
      host: a,
      baseUrl: r = window.location.origin,
      line: i = 0,
      column: l = 0
    } = e;
    if (s) {
      if (a === "chrome-extension") {
        const u = s.replace(/\\/g, "\\\\"),
          c = (n = (t = window.VUE_DEVTOOLS_CONFIG) == null ? void 0 : t.openInEditorHost) != null ? n : "/";
        fetch(`${c}__open-in-editor?file=${encodeURI(s)}`).then(d => {
          if (!d.ok) {
            const p = `Opening component ${u} failed`;
            console.log(`%c${p}`, "color:red");
          }
        });
      } else if (gt.vitePluginDetected) {
        const u = (o = Ee.__VUE_DEVTOOLS_OPEN_IN_EDITOR_BASE_URL__) != null ? o : r;
        Ee.__VUE_INSPECTOR__.openInEditor(u, s, i, l);
      }
    }
  }
  he(), he(), he(), he(), he();
  var Bf, xf;
  (xf = (Bf = Ee).__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__) != null || (Bf.__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__ = []);
  var Br = new Proxy(Ee.__VUE_DEVTOOLS_KIT_PLUGIN_BUFFER__, {
    get(e, t, n) {
      return Reflect.get(e, t, n);
    }
  });
  function xr(e) {
    const t = {};
    return Object.keys(e).forEach(n => {
      t[n] = e[n].defaultValue;
    }), t;
  }
  function Hr(e) {
    return `__VUE_DEVTOOLS_NEXT_PLUGIN_SETTINGS__${e}__`;
  }
  function Jg(e) {
    var t, n, o;
    const s = (n = (t = Br.find(a => {
      var r;
      return a[0].id === e && !!((r = a[0]) != null && r.settings);
    })) == null ? void 0 : t[0]) != null ? n : null;
    return (o = s?.settings) != null ? o : null;
  }
  function Hf(e, t) {
    var n, o, s;
    const a = Hr(e);
    if (a) {
      const r = localStorage.getItem(a);
      if (r) return JSON.parse(r);
    }
    if (e) {
      const r = (o = (n = Br.find(i => i[0].id === e)) == null ? void 0 : n[0]) != null ? o : null;
      return xr((s = r?.settings) != null ? s : {});
    }
    return xr(t);
  }
  function ey(e, t) {
    const n = Hr(e);
    localStorage.getItem(n) || localStorage.setItem(n, JSON.stringify(xr(t)));
  }
  function ty(e, t, n) {
    const o = Hr(e),
      s = localStorage.getItem(o),
      a = JSON.parse(s || "{}"),
      r = {
        ...a,
        [t]: n
      };
    localStorage.setItem(o, JSON.stringify(r)), es.hooks.callHookWith(i => {
      i.forEach(l => l({
        pluginId: e,
        key: t,
        oldValue: a[t],
        newValue: n,
        settings: r
      }));
    }, "setPluginSettings");
  }
  he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he();
  var Gf,
    Wf,
    Xt = (Wf = (Gf = Ee).__VUE_DEVTOOLS_HOOK) != null ? Wf : Gf.__VUE_DEVTOOLS_HOOK = sf(),
    ny = {
      vueAppInit(e) {
        Xt.hook("app:init", e);
      },
      vueAppUnmount(e) {
        Xt.hook("app:unmount", e);
      },
      vueAppConnected(e) {
        Xt.hook("app:connected", e);
      },
      componentAdded(e) {
        return Xt.hook("component:added", e);
      },
      componentEmit(e) {
        return Xt.hook("component:emit", e);
      },
      componentUpdated(e) {
        return Xt.hook("component:updated", e);
      },
      componentRemoved(e) {
        return Xt.hook("component:removed", e);
      },
      setupDevtoolsPlugin(e) {
        Xt.hook("devtools-plugin:setup", e);
      },
      perfStart(e) {
        return Xt.hook("perf:start", e);
      },
      perfEnd(e) {
        return Xt.hook("perf:end", e);
      }
    },
    Vf = {
      on: ny,
      setupDevToolsPlugin(e, t) {
        return Xt.callHook("devtools-plugin:setup", e, t);
      }
    },
    oy = class {
      constructor({
        plugin: e,
        ctx: t
      }) {
        this.hooks = t.hooks, this.plugin = e;
      }
      get on() {
        return {
          visitComponentTree: e => {
            this.hooks.hook("visitComponentTree", e);
          },
          inspectComponent: e => {
            this.hooks.hook("inspectComponent", e);
          },
          editComponentState: e => {
            this.hooks.hook("editComponentState", e);
          },
          getInspectorTree: e => {
            this.hooks.hook("getInspectorTree", e);
          },
          getInspectorState: e => {
            this.hooks.hook("getInspectorState", e);
          },
          editInspectorState: e => {
            this.hooks.hook("editInspectorState", e);
          },
          inspectTimelineEvent: e => {
            this.hooks.hook("inspectTimelineEvent", e);
          },
          timelineCleared: e => {
            this.hooks.hook("timelineCleared", e);
          },
          setPluginSettings: e => {
            this.hooks.hook("setPluginSettings", e);
          }
        };
      }
      notifyComponentUpdate(e) {
        var t;
        if (gt.highPerfModeEnabled) return;
        const n = bf().find(o => o.packageName === this.plugin.descriptor.packageName);
        if (n?.id) {
          if (e) {
            const o = [e.appContext.app, e.uid, (t = e.parent) == null ? void 0 : t.uid, e];
            Xt.callHook("component:updated", ...o);
          } else Xt.callHook("component:updated");
          this.hooks.callHook("sendInspectorState", {
            inspectorId: n.id,
            plugin: this.plugin
          });
        }
      }
      addInspector(e) {
        this.hooks.callHook("addInspector", {
          inspector: e,
          plugin: this.plugin
        }), this.plugin.descriptor.settings && ey(e.id, this.plugin.descriptor.settings);
      }
      sendInspectorTree(e) {
        gt.highPerfModeEnabled || this.hooks.callHook("sendInspectorTree", {
          inspectorId: e,
          plugin: this.plugin
        });
      }
      sendInspectorState(e) {
        gt.highPerfModeEnabled || this.hooks.callHook("sendInspectorState", {
          inspectorId: e,
          plugin: this.plugin
        });
      }
      selectInspectorNode(e, t) {
        this.hooks.callHook("customInspectorSelectNode", {
          inspectorId: e,
          nodeId: t,
          plugin: this.plugin
        });
      }
      visitComponentTree(e) {
        return this.hooks.callHook("visitComponentTree", e);
      }
      now() {
        return gt.highPerfModeEnabled ? 0 : Date.now();
      }
      addTimelineLayer(e) {
        this.hooks.callHook("timelineLayerAdded", {
          options: e,
          plugin: this.plugin
        });
      }
      addTimelineEvent(e) {
        gt.highPerfModeEnabled || this.hooks.callHook("timelineEventAdded", {
          options: e,
          plugin: this.plugin
        });
      }
      getSettings(e) {
        return Hf(e ?? this.plugin.descriptor.id, this.plugin.descriptor.settings);
      }
      getComponentInstances(e) {
        return this.hooks.callHook("getComponentInstances", {
          app: e
        });
      }
      getComponentBounds(e) {
        return this.hooks.callHook("getComponentBounds", {
          instance: e
        });
      }
      getComponentName(e) {
        return this.hooks.callHook("getComponentName", {
          instance: e
        });
      }
      highlightElement(e) {
        const t = e.__VUE_DEVTOOLS_NEXT_UID__;
        return this.hooks.callHook("componentHighlight", {
          uid: t
        });
      }
      unhighlightElement() {
        return this.hooks.callHook("componentUnhighlight");
      }
    },
    sy = oy;
  he(), he(), he(), he();
  var ay = "__vue_devtool_undefined__",
    iy = "__vue_devtool_infinity__",
    ry = "__vue_devtool_negative_infinity__",
    ly = "__vue_devtool_nan__";
  he(), he();
  var uy = {
    [ay]: "undefined",
    [ly]: "NaN",
    [iy]: "Infinity",
    [ry]: "-Infinity"
  };
  Object.entries(uy).reduce((e, [t, n]) => (e[n] = t, e), {}), he(), he(), he(), he(), he();
  var jf, zf;
  (zf = (jf = Ee).__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__) != null || (jf.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__ = new Set());
  function Kf(e, t) {
    return Vf.setupDevToolsPlugin(e, t);
  }
  function cy(e, t) {
    const [n, o] = e;
    if (n.app !== t) return;
    const s = new sy({
      plugin: {
        setupFn: o,
        descriptor: n
      },
      ctx: es
    });
    n.packageName === "vuex" && s.on.editInspectorState(a => {
      s.sendInspectorState(a.inspectorId);
    }), o(s);
  }
  function Yf(e, t) {
    Ee.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__.has(e) || gt.highPerfModeEnabled && !t?.inspectingComponent || (Ee.__VUE_DEVTOOLS_KIT__REGISTERED_PLUGIN_APPS__.add(e), Br.forEach(n => {
      cy(n, e);
    }));
  }
  he(), he();
  var Ws = "__VUE_DEVTOOLS_ROUTER__",
    Jo = "__VUE_DEVTOOLS_ROUTER_INFO__",
    Qf,
    qf;
  (qf = (Qf = Ee)[Jo]) != null || (Qf[Jo] = {
    currentRoute: null,
    routes: []
  });
  var Xf, Zf;
  (Zf = (Xf = Ee)[Ws]) != null || (Xf[Ws] = {}), new Proxy(Ee[Jo], {
    get(e, t) {
      return Ee[Jo][t];
    }
  }), new Proxy(Ee[Ws], {
    get(e, t) {
      if (t === "value") return Ee[Ws];
    }
  });
  function dy(e) {
    const t = new Map();
    return (e?.getRoutes() || []).filter(n => !t.has(n.path) && t.set(n.path, 1));
  }
  function Gr(e) {
    return e.map(t => {
      let {
        path: n,
        name: o,
        children: s,
        meta: a
      } = t;
      return s?.length && (s = Gr(s)), {
        path: n,
        name: o,
        children: s,
        meta: a
      };
    });
  }
  function fy(e) {
    if (e) {
      const {
        fullPath: t,
        hash: n,
        href: o,
        path: s,
        name: a,
        matched: r,
        params: i,
        query: l
      } = e;
      return {
        fullPath: t,
        hash: n,
        href: o,
        path: s,
        name: a,
        params: i,
        query: l,
        matched: Gr(r)
      };
    }
    return e;
  }
  function py(e, t) {
    function n() {
      var o;
      const s = (o = e.app) == null ? void 0 : o.config.globalProperties.$router,
        a = fy(s?.currentRoute.value),
        r = Gr(dy(s)),
        i = console.warn;
      console.warn = () => {}, Ee[Jo] = {
        currentRoute: a ? nf(a) : {},
        routes: nf(r)
      }, Ee[Ws] = s, console.warn = i;
    }
    n(), Vf.on.componentUpdated(Xo(() => {
      var o;
      ((o = t.value) == null ? void 0 : o.app) === e.app && (n(), !gt.highPerfModeEnabled && es.hooks.callHook("routerInfoUpdated", {
        state: Ee[Jo]
      }));
    }, 200));
  }
  function _y(e) {
    return {
      async getInspectorTree(t) {
        const n = {
          ...t,
          app: Gt.value.app,
          rootNodes: []
        };
        return await new Promise(o => {
          e.callHookWith(async s => {
            await Promise.all(s.map(a => a(n))), o();
          }, "getInspectorTree");
        }), n.rootNodes;
      },
      async getInspectorState(t) {
        const n = {
            ...t,
            app: Gt.value.app,
            state: null
          },
          o = {
            currentTab: `custom-inspector:${t.inspectorId}`
          };
        return await new Promise(s => {
          e.callHookWith(async a => {
            await Promise.all(a.map(r => r(n, o))), s();
          }, "getInspectorState");
        }), n.state;
      },
      editInspectorState(t) {
        const n = new xg(),
          o = {
            ...t,
            app: Gt.value.app,
            set: (s, a = t.path, r = t.state.value, i) => {
              n.set(s, a, r, i || n.createDefaultSetCallback(t.state));
            }
          };
        e.callHookWith(s => {
          s.forEach(a => a(o));
        }, "editInspectorState");
      },
      sendInspectorState(t) {
        const n = ei(t);
        e.callHook("sendInspectorState", {
          inspectorId: t,
          plugin: {
            descriptor: n.descriptor,
            setupFn: () => ({})
          }
        });
      },
      inspectComponentInspector() {
        return Lg();
      },
      cancelInspectComponentInspector() {
        return wg();
      },
      getComponentRenderCode(t) {
        const n = Nr(Gt.value, t);
        if (n) return typeof n?.type != "function" ? n.render.toString() : n.type.toString();
      },
      scrollToComponent(t) {
        return kg({
          id: t
        });
      },
      openInEditor: Zg,
      getVueInspector: Ug,
      toggleApp(t, n) {
        const o = ti.value.find(s => s.id === t);
        o && (Xg(t), qg(o), py(o, Gt), Pf(), Yf(o.app, n));
      },
      inspectDOM(t) {
        const n = Nr(Gt.value, t);
        if (n) {
          const [o] = Ar(n);
          o && (Ee.__VUE_DEVTOOLS_INSPECT_DOM_TARGET__ = o);
        }
      },
      updatePluginSettings(t, n, o) {
        ty(t, n, o);
      },
      getPluginSettings(t) {
        return {
          options: Jg(t),
          values: Hf(t)
        };
      }
    };
  }
  he();
  var Jf, ep;
  (ep = (Jf = Ee).__VUE_DEVTOOLS_ENV__) != null || (Jf.__VUE_DEVTOOLS_ENV__ = {
    vitePluginDetected: !1
  });
  var tp = Kg(),
    np,
    op;
  (op = (np = Ee).__VUE_DEVTOOLS_KIT_CONTEXT__) != null || (np.__VUE_DEVTOOLS_KIT_CONTEXT__ = {
    hooks: tp,
    get state() {
      return {
        ...gt,
        activeAppRecordId: Gt.id,
        activeAppRecord: Gt.value,
        appRecords: ti.value
      };
    },
    api: _y(tp)
  });
  var es = Ee.__VUE_DEVTOOLS_KIT_CONTEXT__;
  he(), hg(mg());
  var sp, ap;
  (ap = (sp = Ee).__VUE_DEVTOOLS_NEXT_APP_RECORD_INFO__) != null || (sp.__VUE_DEVTOOLS_NEXT_APP_RECORD_INFO__ = {
    id: 0,
    appIds: new Set()
  }), he(), he();
  function hy(e) {
    gt.highPerfModeEnabled = e ?? !gt.highPerfModeEnabled, !e && Gt.value && Yf(Gt.value.app);
  }
  he(), he(), he();
  function vy(e) {
    gt.devtoolsClientDetected = {
      ...gt.devtoolsClientDetected,
      ...e
    };
    const t = Object.values(gt.devtoolsClientDetected).some(Boolean);
    hy(!t);
  }
  var ip, rp;
  (rp = (ip = Ee).__VUE_DEVTOOLS_UPDATE_CLIENT_DETECTED__) != null || (ip.__VUE_DEVTOOLS_UPDATE_CLIENT_DETECTED__ = vy), he(), he(), he(), he(), he(), he(), he();
  var my = class {
      constructor() {
        this.keyToValue = new Map(), this.valueToKey = new Map();
      }
      set(e, t) {
        this.keyToValue.set(e, t), this.valueToKey.set(t, e);
      }
      getByKey(e) {
        return this.keyToValue.get(e);
      }
      getByValue(e) {
        return this.valueToKey.get(e);
      }
      clear() {
        this.keyToValue.clear(), this.valueToKey.clear();
      }
    },
    lp = class {
      constructor(e) {
        this.generateIdentifier = e, this.kv = new my();
      }
      register(e, t) {
        this.kv.getByValue(e) || (t || (t = this.generateIdentifier(e)), this.kv.set(t, e));
      }
      clear() {
        this.kv.clear();
      }
      getIdentifier(e) {
        return this.kv.getByValue(e);
      }
      getValue(e) {
        return this.kv.getByKey(e);
      }
    },
    Cy = class extends lp {
      constructor() {
        super(e => e.name), this.classToAllowedProps = new Map();
      }
      register(e, t) {
        typeof t == "object" ? (t.allowProps && this.classToAllowedProps.set(e, t.allowProps), super.register(e, t.identifier)) : super.register(e, t);
      }
      getAllowedProps(e) {
        return this.classToAllowedProps.get(e);
      }
    };
  he(), he();
  function Ty(e) {
    if ("values" in Object) return Object.values(e);
    const t = [];
    for (const n in e) e.hasOwnProperty(n) && t.push(e[n]);
    return t;
  }
  function gy(e, t) {
    const n = Ty(e);
    if ("find" in n) return n.find(t);
    const o = n;
    for (let s = 0; s < o.length; s++) {
      const a = o[s];
      if (t(a)) return a;
    }
  }
  function ts(e, t) {
    Object.entries(e).forEach(([n, o]) => t(o, n));
  }
  function ni(e, t) {
    return e.indexOf(t) !== -1;
  }
  function up(e, t) {
    for (let n = 0; n < e.length; n++) {
      const o = e[n];
      if (t(o)) return o;
    }
  }
  var yy = class {
    constructor() {
      this.transfomers = {};
    }
    register(e) {
      this.transfomers[e.name] = e;
    }
    findApplicable(e) {
      return gy(this.transfomers, t => t.isApplicable(e));
    }
    findByName(e) {
      return this.transfomers[e];
    }
  };
  he(), he();
  var Dy = e => Object.prototype.toString.call(e).slice(8, -1),
    cp = e => typeof e > "u",
    Sy = e => e === null,
    Vs = e => typeof e != "object" || e === null || e === Object.prototype ? !1 : Object.getPrototypeOf(e) === null ? !0 : Object.getPrototypeOf(e) === Object.prototype,
    Wr = e => Vs(e) && Object.keys(e).length === 0,
    oo = e => Array.isArray(e),
    Py = e => typeof e == "string",
    by = e => typeof e == "number" && !isNaN(e),
    Oy = e => typeof e == "boolean",
    Ey = e => e instanceof RegExp,
    js = e => e instanceof Map,
    zs = e => e instanceof Set,
    dp = e => Dy(e) === "Symbol",
    Iy = e => e instanceof Date && !isNaN(e.valueOf()),
    Ry = e => e instanceof Error,
    fp = e => typeof e == "number" && isNaN(e),
    Ny = e => Oy(e) || Sy(e) || cp(e) || by(e) || Py(e) || dp(e),
    Ay = e => typeof e == "bigint",
    My = e => e === 1 / 0 || e === -1 / 0,
    wy = e => ArrayBuffer.isView(e) && !(e instanceof DataView),
    Ly = e => e instanceof URL;
  he();
  var pp = e => e.replace(/\./g, "\\."),
    Vr = e => e.map(String).map(pp).join("."),
    Ks = e => {
      const t = [];
      let n = "";
      for (let s = 0; s < e.length; s++) {
        let a = e.charAt(s);
        if (a === "\\" && e.charAt(s + 1) === ".") {
          n += ".", s++;
          continue;
        }
        if (a === ".") {
          t.push(n), n = "";
          continue;
        }
        n += a;
      }
      const o = n;
      return t.push(o), t;
    };
  he();
  function En(e, t, n, o) {
    return {
      isApplicable: e,
      annotation: t,
      transform: n,
      untransform: o
    };
  }
  var _p = [En(cp, "undefined", () => null, () => {}), En(Ay, "bigint", e => e.toString(), e => typeof BigInt < "u" ? BigInt(e) : (console.error("Please add a BigInt polyfill."), e)), En(Iy, "Date", e => e.toISOString(), e => new Date(e)), En(Ry, "Error", (e, t) => {
    const n = {
      name: e.name,
      message: e.message
    };
    return t.allowedErrorProps.forEach(o => {
      n[o] = e[o];
    }), n;
  }, (e, t) => {
    const n = new Error(e.message);
    return n.name = e.name, n.stack = e.stack, t.allowedErrorProps.forEach(o => {
      n[o] = e[o];
    }), n;
  }), En(Ey, "regexp", e => "" + e, e => {
    const t = e.slice(1, e.lastIndexOf("/")),
      n = e.slice(e.lastIndexOf("/") + 1);
    return new RegExp(t, n);
  }), En(zs, "set", e => [...e.values()], e => new Set(e)), En(js, "map", e => [...e.entries()], e => new Map(e)), En(e => fp(e) || My(e), "number", e => fp(e) ? "NaN" : e > 0 ? "Infinity" : "-Infinity", Number), En(e => e === 0 && 1 / e === -1 / 0, "number", () => "-0", Number), En(Ly, "URL", e => e.toString(), e => new URL(e))];
  function oi(e, t, n, o) {
    return {
      isApplicable: e,
      annotation: t,
      transform: n,
      untransform: o
    };
  }
  var hp = oi((e, t) => dp(e) ? !!t.symbolRegistry.getIdentifier(e) : !1, (e, t) => ["symbol", t.symbolRegistry.getIdentifier(e)], e => e.description, (e, t, n) => {
      const o = n.symbolRegistry.getValue(t[1]);
      if (!o) throw new Error("Trying to deserialize unknown symbol");
      return o;
    }),
    ky = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array, Uint8ClampedArray].reduce((e, t) => (e[t.name] = t, e), {}),
    vp = oi(wy, e => ["typed-array", e.constructor.name], e => [...e], (e, t) => {
      const n = ky[t[1]];
      if (!n) throw new Error("Trying to deserialize unknown typed array");
      return new n(e);
    });
  function mp(e, t) {
    return e?.constructor ? !!t.classRegistry.getIdentifier(e.constructor) : !1;
  }
  var Cp = oi(mp, (e, t) => ["class", t.classRegistry.getIdentifier(e.constructor)], (e, t) => {
      const n = t.classRegistry.getAllowedProps(e.constructor);
      if (!n) return {
        ...e
      };
      const o = {};
      return n.forEach(s => {
        o[s] = e[s];
      }), o;
    }, (e, t, n) => {
      const o = n.classRegistry.getValue(t[1]);
      if (!o) throw new Error(`Trying to deserialize unknown class '${t[1]}' - check https://github.com/blitz-js/superjson/issues/116#issuecomment-773996564`);
      return Object.assign(Object.create(o.prototype), e);
    }),
    Tp = oi((e, t) => !!t.customTransformerRegistry.findApplicable(e), (e, t) => ["custom", t.customTransformerRegistry.findApplicable(e).name], (e, t) => t.customTransformerRegistry.findApplicable(e).serialize(e), (e, t, n) => {
      const o = n.customTransformerRegistry.findByName(t[1]);
      if (!o) throw new Error("Trying to deserialize unknown custom value");
      return o.deserialize(e);
    }),
    $y = [Cp, hp, Tp, vp],
    gp = (e, t) => {
      const n = up($y, s => s.isApplicable(e, t));
      if (n) return {
        value: n.transform(e, t),
        type: n.annotation(e, t)
      };
      const o = up(_p, s => s.isApplicable(e, t));
      if (o) return {
        value: o.transform(e, t),
        type: o.annotation
      };
    },
    yp = {};
  _p.forEach(e => {
    yp[e.annotation] = e;
  });
  var Fy = (e, t, n) => {
    if (oo(t)) switch (t[0]) {
      case "symbol":
        return hp.untransform(e, t, n);
      case "class":
        return Cp.untransform(e, t, n);
      case "custom":
        return Tp.untransform(e, t, n);
      case "typed-array":
        return vp.untransform(e, t, n);
      default:
        throw new Error("Unknown transformation: " + t);
    } else {
      const o = yp[t];
      if (!o) throw new Error("Unknown transformation: " + t);
      return o.untransform(e, n);
    }
  };
  he();
  var ns = (e, t) => {
    if (t > e.size) throw new Error("index out of bounds");
    const n = e.keys();
    for (; t > 0;) n.next(), t--;
    return n.next().value;
  };
  function Dp(e) {
    if (ni(e, "__proto__")) throw new Error("__proto__ is not allowed as a property");
    if (ni(e, "prototype")) throw new Error("prototype is not allowed as a property");
    if (ni(e, "constructor")) throw new Error("constructor is not allowed as a property");
  }
  var Uy = (e, t) => {
      Dp(t);
      for (let n = 0; n < t.length; n++) {
        const o = t[n];
        if (zs(e)) e = ns(e, +o);else if (js(e)) {
          const s = +o,
            a = +t[++n] == 0 ? "key" : "value",
            r = ns(e, s);
          switch (a) {
            case "key":
              e = r;
              break;
            case "value":
              e = e.get(r);
              break;
          }
        } else e = e[o];
      }
      return e;
    },
    jr = (e, t, n) => {
      if (Dp(t), t.length === 0) return n(e);
      let o = e;
      for (let a = 0; a < t.length - 1; a++) {
        const r = t[a];
        if (oo(o)) {
          const i = +r;
          o = o[i];
        } else if (Vs(o)) o = o[r];else if (zs(o)) {
          const i = +r;
          o = ns(o, i);
        } else if (js(o)) {
          if (a === t.length - 2) break;
          const l = +r,
            u = +t[++a] == 0 ? "key" : "value",
            c = ns(o, l);
          switch (u) {
            case "key":
              o = c;
              break;
            case "value":
              o = o.get(c);
              break;
          }
        }
      }
      const s = t[t.length - 1];
      if (oo(o) ? o[+s] = n(o[+s]) : Vs(o) && (o[s] = n(o[s])), zs(o)) {
        const a = ns(o, +s),
          r = n(a);
        a !== r && (o.delete(a), o.add(r));
      }
      if (js(o)) {
        const a = +t[t.length - 2],
          r = ns(o, a);
        switch (+s == 0 ? "key" : "value") {
          case "key":
            {
              const l = n(r);
              o.set(l, o.get(r)), l !== r && o.delete(r);
              break;
            }
          case "value":
            {
              o.set(r, n(o.get(r)));
              break;
            }
        }
      }
      return e;
    };
  function zr(e, t, n = []) {
    if (!e) return;
    if (!oo(e)) {
      ts(e, (a, r) => zr(a, t, [...n, ...Ks(r)]));
      return;
    }
    const [o, s] = e;
    s && ts(s, (a, r) => {
      zr(a, t, [...n, ...Ks(r)]);
    }), t(o, n);
  }
  function By(e, t, n) {
    return zr(t, (o, s) => {
      e = jr(e, s, a => Fy(a, o, n));
    }), e;
  }
  function xy(e, t) {
    function n(o, s) {
      const a = Uy(e, Ks(s));
      o.map(Ks).forEach(r => {
        e = jr(e, r, () => a);
      });
    }
    if (oo(t)) {
      const [o, s] = t;
      o.forEach(a => {
        e = jr(e, Ks(a), () => e);
      }), s && ts(s, n);
    } else ts(t, n);
    return e;
  }
  var Hy = (e, t) => Vs(e) || oo(e) || js(e) || zs(e) || mp(e, t);
  function Gy(e, t, n) {
    const o = n.get(e);
    o ? o.push(t) : n.set(e, [t]);
  }
  function Wy(e, t) {
    const n = {};
    let o;
    return e.forEach(s => {
      if (s.length <= 1) return;
      t || (s = s.map(i => i.map(String)).sort((i, l) => i.length - l.length));
      const [a, ...r] = s;
      a.length === 0 ? o = r.map(Vr) : n[Vr(a)] = r.map(Vr);
    }), o ? Wr(n) ? [o] : [o, n] : Wr(n) ? void 0 : n;
  }
  var Sp = (e, t, n, o, s = [], a = [], r = new Map()) => {
    var i;
    const l = Ny(e);
    if (!l) {
      Gy(e, s, t);
      const v = r.get(e);
      if (v) return o ? {
        transformedValue: null
      } : v;
    }
    if (!Hy(e, n)) {
      const v = gp(e, n),
        h = v ? {
          transformedValue: v.value,
          annotations: [v.type]
        } : {
          transformedValue: e
        };
      return l || r.set(e, h), h;
    }
    if (ni(a, e)) return {
      transformedValue: null
    };
    const u = gp(e, n),
      c = (i = u?.value) != null ? i : e,
      d = oo(c) ? [] : {},
      p = {};
    ts(c, (v, h) => {
      if (h === "__proto__" || h === "constructor" || h === "prototype") throw new Error(`Detected property ${h}. This is a prototype pollution risk, please remove it from your object.`);
      const m = Sp(v, t, n, o, [...s, h], [...a, e], r);
      d[h] = m.transformedValue, oo(m.annotations) ? p[h] = m.annotations : Vs(m.annotations) && ts(m.annotations, (D, N) => {
        p[pp(h) + "." + N] = D;
      });
    });
    const f = Wr(p) ? {
      transformedValue: d,
      annotations: u ? [u.type] : void 0
    } : {
      transformedValue: d,
      annotations: u ? [u.type, p] : p
    };
    return l || r.set(e, f), f;
  };
  he(), he();
  function Pp(e) {
    return Object.prototype.toString.call(e).slice(8, -1);
  }
  function bp(e) {
    return Pp(e) === "Array";
  }
  function Vy(e) {
    if (Pp(e) !== "Object") return !1;
    const t = Object.getPrototypeOf(e);
    return !!t && t.constructor === Object && t === Object.prototype;
  }
  function jy(e, t, n, o, s) {
    const a = {}.propertyIsEnumerable.call(o, t) ? "enumerable" : "nonenumerable";
    a === "enumerable" && (e[t] = n), s && a === "nonenumerable" && Object.defineProperty(e, t, {
      value: n,
      enumerable: !1,
      writable: !0,
      configurable: !0
    });
  }
  function Kr(e, t = {}) {
    if (bp(e)) return e.map(s => Kr(s, t));
    if (!Vy(e)) return e;
    const n = Object.getOwnPropertyNames(e),
      o = Object.getOwnPropertySymbols(e);
    return [...n, ...o].reduce((s, a) => {
      if (bp(t.props) && !t.props.includes(a)) return s;
      const r = e[a],
        i = Kr(r, t);
      return jy(s, a, i, e, t.nonenumerable), s;
    }, {});
  }
  var st = class {
    constructor({
      dedupe: e = !1
    } = {}) {
      this.classRegistry = new Cy(), this.symbolRegistry = new lp(t => {
        var n;
        return (n = t.description) != null ? n : "";
      }), this.customTransformerRegistry = new yy(), this.allowedErrorProps = [], this.dedupe = e;
    }
    serialize(e) {
      const t = new Map(),
        n = Sp(e, t, this, this.dedupe),
        o = {
          json: n.transformedValue
        };
      n.annotations && (o.meta = {
        ...o.meta,
        values: n.annotations
      });
      const s = Wy(t, this.dedupe);
      return s && (o.meta = {
        ...o.meta,
        referentialEqualities: s
      }), o;
    }
    deserialize(e) {
      const {
        json: t,
        meta: n
      } = e;
      let o = Kr(t);
      return n?.values && (o = By(o, n.values, this)), n?.referentialEqualities && (o = xy(o, n.referentialEqualities)), o;
    }
    stringify(e) {
      return JSON.stringify(this.serialize(e));
    }
    parse(e) {
      return this.deserialize(JSON.parse(e));
    }
    registerClass(e, t) {
      this.classRegistry.register(e, t);
    }
    registerSymbol(e, t) {
      this.symbolRegistry.register(e, t);
    }
    registerCustom(e, t) {
      this.customTransformerRegistry.register({
        name: t,
        ...e
      });
    }
    allowErrorProps(...e) {
      this.allowedErrorProps.push(...e);
    }
  };
  st.defaultInstance = new st(), st.serialize = st.defaultInstance.serialize.bind(st.defaultInstance), st.deserialize = st.defaultInstance.deserialize.bind(st.defaultInstance), st.stringify = st.defaultInstance.stringify.bind(st.defaultInstance), st.parse = st.defaultInstance.parse.bind(st.defaultInstance), st.registerClass = st.defaultInstance.registerClass.bind(st.defaultInstance), st.registerSymbol = st.defaultInstance.registerSymbol.bind(st.defaultInstance), st.registerCustom = st.defaultInstance.registerCustom.bind(st.defaultInstance), st.allowErrorProps = st.defaultInstance.allowErrorProps.bind(st.defaultInstance), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he(), he();
  var Op, Ep;
  (Ep = (Op = Ee).__VUE_DEVTOOLS_KIT_MESSAGE_CHANNELS__) != null || (Op.__VUE_DEVTOOLS_KIT_MESSAGE_CHANNELS__ = []);
  var Ip, Rp;
  (Rp = (Ip = Ee).__VUE_DEVTOOLS_KIT_RPC_CLIENT__) != null || (Ip.__VUE_DEVTOOLS_KIT_RPC_CLIENT__ = null);
  var Np, Ap;
  (Ap = (Np = Ee).__VUE_DEVTOOLS_KIT_RPC_SERVER__) != null || (Np.__VUE_DEVTOOLS_KIT_RPC_SERVER__ = null);
  var Mp, wp;
  (wp = (Mp = Ee).__VUE_DEVTOOLS_KIT_VITE_RPC_CLIENT__) != null || (Mp.__VUE_DEVTOOLS_KIT_VITE_RPC_CLIENT__ = null);
  var Lp, kp;
  (kp = (Lp = Ee).__VUE_DEVTOOLS_KIT_VITE_RPC_SERVER__) != null || (Lp.__VUE_DEVTOOLS_KIT_VITE_RPC_SERVER__ = null);
  var $p, Fp;
  (Fp = ($p = Ee).__VUE_DEVTOOLS_KIT_BROADCAST_RPC_SERVER__) != null || ($p.__VUE_DEVTOOLS_KIT_BROADCAST_RPC_SERVER__ = null), he(), he(), he(), he(), he(), he(), he();
  let Yr;
  const Ys = e => Yr = e,
    Up = Symbol("pinia");
  function Oo(e) {
    return e && typeof e == "object" && Object.prototype.toString.call(e) === "[object Object]" && typeof e.toJSON != "function";
  }
  var In;
  (function (e) {
    e.direct = "direct", e.patchObject = "patch object", e.patchFunction = "patch function";
  })(In || (In = {}));
  const Eo = typeof window < "u",
    Bp = typeof window == "object" && window.window === window ? window : typeof self == "object" && self.self === self ? self : typeof global == "object" && global.global === global ? global : typeof globalThis == "object" ? globalThis : {
      HTMLElement: null
    };
  function zy(e, {
    autoBom: t = !1
  } = {}) {
    return t && /^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(e.type) ? new Blob(["\uFEFF", e], {
      type: e.type
    }) : e;
  }
  function Qr(e, t, n) {
    const o = new XMLHttpRequest();
    o.open("GET", e), o.responseType = "blob", o.onload = function () {
      Gp(o.response, t, n);
    }, o.onerror = function () {
      console.error("could not download file");
    }, o.send();
  }
  function xp(e) {
    const t = new XMLHttpRequest();
    t.open("HEAD", e, !1);
    try {
      t.send();
    } catch {}
    return t.status >= 200 && t.status <= 299;
  }
  function si(e) {
    try {
      e.dispatchEvent(new MouseEvent("click"));
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
      e.dispatchEvent(n);
    }
  }
  const ai = typeof navigator == "object" ? navigator : {
      userAgent: ""
    },
    Hp = /Macintosh/.test(ai.userAgent) && /AppleWebKit/.test(ai.userAgent) && !/Safari/.test(ai.userAgent),
    Gp = Eo ? typeof HTMLAnchorElement < "u" && "download" in HTMLAnchorElement.prototype && !Hp ? Ky : "msSaveOrOpenBlob" in ai ? Yy : Qy : () => {};
  function Ky(e, t = "download", n) {
    const o = document.createElement("a");
    o.download = t, o.rel = "noopener", typeof e == "string" ? (o.href = e, o.origin !== location.origin ? xp(o.href) ? Qr(e, t, n) : (o.target = "_blank", si(o)) : si(o)) : (o.href = URL.createObjectURL(e), setTimeout(function () {
      URL.revokeObjectURL(o.href);
    }, 4e4), setTimeout(function () {
      si(o);
    }, 0));
  }
  function Yy(e, t = "download", n) {
    if (typeof e == "string") {
      if (xp(e)) Qr(e, t, n);else {
        const o = document.createElement("a");
        o.href = e, o.target = "_blank", setTimeout(function () {
          si(o);
        });
      }
    } else navigator.msSaveOrOpenBlob(zy(e, n), t);
  }
  function Qy(e, t, n, o) {
    if (o = o || open("", "_blank"), o && (o.document.title = o.document.body.innerText = "downloading..."), typeof e == "string") return Qr(e, t, n);
    const s = e.type === "application/octet-stream",
      a = /constructor/i.test(String(Bp.HTMLElement)) || "safari" in Bp,
      r = /CriOS\/[\d]+/.test(navigator.userAgent);
    if ((r || s && a || Hp) && typeof FileReader < "u") {
      const i = new FileReader();
      i.onloadend = function () {
        let l = i.result;
        if (typeof l != "string") throw o = null, new Error("Wrong reader.result type");
        l = r ? l : l.replace(/^data:[^;]*;/, "data:attachment/file;"), o ? o.location.href = l : location.assign(l), o = null;
      }, i.readAsDataURL(e);
    } else {
      const i = URL.createObjectURL(e);
      o ? o.location.assign(i) : location.href = i, o = null, setTimeout(function () {
        URL.revokeObjectURL(i);
      }, 4e4);
    }
  }
  function bt(e, t) {
    const n = "🍍 " + e;
    typeof __VUE_DEVTOOLS_TOAST__ == "function" ? __VUE_DEVTOOLS_TOAST__(n, t) : t === "error" ? console.error(n) : t === "warn" ? console.warn(n) : console.log(n);
  }
  function qr(e) {
    return "_a" in e && "install" in e;
  }
  function Wp() {
    if (!("clipboard" in navigator)) return bt("Your browser doesn't support the Clipboard API", "error"), !0;
  }
  function Vp(e) {
    return e instanceof Error && e.message.toLowerCase().includes("document is not focused") ? (bt('You need to activate the "Emulate a focused page" setting in the "Rendering" panel of devtools.', "warn"), !0) : !1;
  }
  async function qy(e) {
    if (!Wp()) try {
      await navigator.clipboard.writeText(JSON.stringify(e.state.value)), bt("Global state copied to clipboard.");
    } catch (t) {
      if (Vp(t)) return;
      bt("Failed to serialize the state. Check the console for more details.", "error"), console.error(t);
    }
  }
  async function Xy(e) {
    if (!Wp()) try {
      jp(e, JSON.parse(await navigator.clipboard.readText())), bt("Global state pasted from clipboard.");
    } catch (t) {
      if (Vp(t)) return;
      bt("Failed to deserialize the state from clipboard. Check the console for more details.", "error"), console.error(t);
    }
  }
  async function Zy(e) {
    try {
      Gp(new Blob([JSON.stringify(e.state.value)], {
        type: "text/plain;charset=utf-8"
      }), "pinia-state.json");
    } catch (t) {
      bt("Failed to export the state as JSON. Check the console for more details.", "error"), console.error(t);
    }
  }
  let Gn;
  function Jy() {
    Gn || (Gn = document.createElement("input"), Gn.type = "file", Gn.accept = ".json");
    function e() {
      return new Promise((t, n) => {
        Gn.onchange = async () => {
          const o = Gn.files;
          if (!o) return t(null);
          const s = o.item(0);
          return t(s ? {
            text: await s.text(),
            file: s
          } : null);
        }, Gn.oncancel = () => t(null), Gn.onerror = n, Gn.click();
      });
    }
    return e;
  }
  async function eD(e) {
    try {
      const n = await Jy()();
      if (!n) return;
      const {
        text: o,
        file: s
      } = n;
      jp(e, JSON.parse(o)), bt(`Global state imported from "${s.name}".`);
    } catch (t) {
      bt("Failed to import the state from JSON. Check the console for more details.", "error"), console.error(t);
    }
  }
  function jp(e, t) {
    for (const n in t) {
      const o = e.state.value[n];
      o ? Object.assign(o, t[n]) : e.state.value[n] = t[n];
    }
  }
  function mn(e) {
    return {
      _custom: {
        display: e
      }
    };
  }
  const zp = "🍍 Pinia (root)",
    ii = "_root";
  function tD(e) {
    return qr(e) ? {
      id: ii,
      label: zp
    } : {
      id: e.$id,
      label: e.$id
    };
  }
  function nD(e) {
    if (qr(e)) {
      const n = Array.from(e._s.keys()),
        o = e._s;
      return {
        state: n.map(a => ({
          editable: !0,
          key: a,
          value: e.state.value[a]
        })),
        getters: n.filter(a => o.get(a)._getters).map(a => {
          const r = o.get(a);
          return {
            editable: !1,
            key: a,
            value: r._getters.reduce((i, l) => (i[l] = r[l], i), {})
          };
        })
      };
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
    }))), t;
  }
  function oD(e) {
    return e ? Array.isArray(e) ? e.reduce((t, n) => (t.keys.push(n.key), t.operations.push(n.type), t.oldValue[n.key] = n.oldValue, t.newValue[n.key] = n.newValue, t), {
      oldValue: {},
      keys: [],
      operations: [],
      newValue: {}
    }) : {
      operation: mn(e.type),
      key: mn(e.key),
      oldValue: e.oldValue,
      newValue: e.newValue
    } : {};
  }
  function sD(e) {
    switch (e) {
      case In.direct:
        return "mutation";
      case In.patchFunction:
        return "$patch";
      case In.patchObject:
        return "$patch";
      default:
        return "unknown";
    }
  }
  let os = !0;
  const ri = [],
    Io = "pinia:mutations",
    kt = "pinia",
    {
      assign: aD
    } = Object,
    li = e => "🍍 " + e;
  function iD(e, t) {
    Kf({
      id: "dev.esm.pinia",
      label: "Pinia 🍍",
      logo: "https://pinia.vuejs.org/logo.svg",
      packageName: "pinia",
      homepage: "https://pinia.vuejs.org",
      componentStateTypes: ri,
      app: e
    }, n => {
      typeof n.now != "function" && bt("You seem to be using an outdated version of Vue Devtools. Are you still using the Beta release instead of the stable one? You can find the links at https://devtools.vuejs.org/guide/installation.html."), n.addTimelineLayer({
        id: Io,
        label: "Pinia 🍍",
        color: 15064968
      }), n.addInspector({
        id: kt,
        label: "Pinia 🍍",
        icon: "storage",
        treeFilterPlaceholder: "Search stores",
        actions: [{
          icon: "content_copy",
          action: () => {
            qy(t);
          },
          tooltip: "Serialize and copy the state"
        }, {
          icon: "content_paste",
          action: async () => {
            await Xy(t), n.sendInspectorTree(kt), n.sendInspectorState(kt);
          },
          tooltip: "Replace the state with the content of your clipboard"
        }, {
          icon: "save",
          action: () => {
            Zy(t);
          },
          tooltip: "Save the state as a JSON file"
        }, {
          icon: "folder_open",
          action: async () => {
            await eD(t), n.sendInspectorTree(kt), n.sendInspectorState(kt);
          },
          tooltip: "Import the state from a JSON file"
        }],
        nodeActions: [{
          icon: "restore",
          tooltip: 'Reset the state (with "$reset")',
          action: o => {
            const s = t._s.get(o);
            s ? typeof s.$reset != "function" ? bt(`Cannot reset "${o}" store because it doesn't have a "$reset" method implemented.`, "warn") : (s.$reset(), bt(`Store "${o}" reset.`)) : bt(`Cannot reset "${o}" store because it wasn't found.`, "warn");
          }
        }]
      }), n.on.inspectComponent(o => {
        const s = o.componentInstance && o.componentInstance.proxy;
        if (s && s._pStores) {
          const a = o.componentInstance.proxy._pStores;
          Object.values(a).forEach(r => {
            o.instanceData.state.push({
              type: li(r.$id),
              key: "state",
              editable: !0,
              value: r._isOptionsAPI ? {
                _custom: {
                  value: Le(r.$state),
                  actions: [{
                    icon: "restore",
                    tooltip: "Reset the state of this store",
                    action: () => r.$reset()
                  }]
                }
              } : Object.keys(r.$state).reduce((i, l) => (i[l] = r.$state[l], i), {})
            }), r._getters && r._getters.length && o.instanceData.state.push({
              type: li(r.$id),
              key: "getters",
              editable: !1,
              value: r._getters.reduce((i, l) => {
                try {
                  i[l] = r[l];
                } catch (u) {
                  i[l] = u;
                }
                return i;
              }, {})
            });
          });
        }
      }), n.on.getInspectorTree(o => {
        if (o.app === e && o.inspectorId === kt) {
          let s = [t];
          s = s.concat(Array.from(t._s.values())), o.rootNodes = (o.filter ? s.filter(a => "$id" in a ? a.$id.toLowerCase().includes(o.filter.toLowerCase()) : zp.toLowerCase().includes(o.filter.toLowerCase())) : s).map(tD);
        }
      }), globalThis.$pinia = t, n.on.getInspectorState(o => {
        if (o.app === e && o.inspectorId === kt) {
          const s = o.nodeId === ii ? t : t._s.get(o.nodeId);
          if (!s) return;
          s && (o.nodeId !== ii && (globalThis.$store = Le(s)), o.state = nD(s));
        }
      }), n.on.editInspectorState(o => {
        if (o.app === e && o.inspectorId === kt) {
          const s = o.nodeId === ii ? t : t._s.get(o.nodeId);
          if (!s) return bt(`store "${o.nodeId}" not found`, "error");
          const {
            path: a
          } = o;
          qr(s) ? a.unshift("state") : (a.length !== 1 || !s._customProperties.has(a[0]) || a[0] in s.$state) && a.unshift("$state"), os = !1, o.set(s, a, o.state.value), os = !0;
        }
      }), n.on.editComponentState(o => {
        if (o.type.startsWith("🍍")) {
          const s = o.type.replace(/^🍍\s*/, ""),
            a = t._s.get(s);
          if (!a) return bt(`store "${s}" not found`, "error");
          const {
            path: r
          } = o;
          if (r[0] !== "state") return bt(`Invalid path for store "${s}":
${r}
Only state can be modified.`);
          r[0] = "$state", os = !1, o.set(a, r, o.state.value), os = !0;
        }
      });
    });
  }
  function rD(e, t) {
    ri.includes(li(t.$id)) || ri.push(li(t.$id)), Kf({
      id: "dev.esm.pinia",
      label: "Pinia 🍍",
      logo: "https://pinia.vuejs.org/logo.svg",
      packageName: "pinia",
      homepage: "https://pinia.vuejs.org",
      componentStateTypes: ri,
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
        after: r,
        onError: i,
        name: l,
        args: u
      }) => {
        const c = Kp++;
        n.addTimelineEvent({
          layerId: Io,
          event: {
            time: o(),
            title: "🛫 " + l,
            subtitle: "start",
            data: {
              store: mn(t.$id),
              action: mn(l),
              args: u
            },
            groupId: c
          }
        }), r(d => {
          so = void 0, n.addTimelineEvent({
            layerId: Io,
            event: {
              time: o(),
              title: "🛬 " + l,
              subtitle: "end",
              data: {
                store: mn(t.$id),
                action: mn(l),
                args: u,
                result: d
              },
              groupId: c
            }
          });
        }), i(d => {
          so = void 0, n.addTimelineEvent({
            layerId: Io,
            event: {
              time: o(),
              logType: "error",
              title: "💥 " + l,
              subtitle: "end",
              data: {
                store: mn(t.$id),
                action: mn(l),
                args: u,
                error: d
              },
              groupId: c
            }
          });
        });
      }, !0), t._customProperties.forEach(r => {
        U(() => y(t[r]), (i, l) => {
          n.notifyComponentUpdate(), n.sendInspectorState(kt), os && n.addTimelineEvent({
            layerId: Io,
            event: {
              time: o(),
              title: "Change",
              subtitle: r,
              data: {
                newValue: i,
                oldValue: l
              },
              groupId: so
            }
          });
        }, {
          deep: !0
        });
      }), t.$subscribe(({
        events: r,
        type: i
      }, l) => {
        if (n.notifyComponentUpdate(), n.sendInspectorState(kt), !os) return;
        const u = {
          time: o(),
          title: sD(i),
          data: aD({
            store: mn(t.$id)
          }, oD(r)),
          groupId: so
        };
        i === In.patchFunction ? u.subtitle = "⤵️" : i === In.patchObject ? u.subtitle = "🧩" : r && !Array.isArray(r) && (u.subtitle = r.type), r && (u.data["rawEvent(s)"] = {
          _custom: {
            display: "DebuggerEvent",
            type: "object",
            tooltip: "raw DebuggerEvent[]",
            value: r
          }
        }), n.addTimelineEvent({
          layerId: Io,
          event: u
        });
      }, {
        detached: !0,
        flush: "sync"
      });
      const s = t._hotUpdate;
      t._hotUpdate = wn(r => {
        s(r), n.addTimelineEvent({
          layerId: Io,
          event: {
            time: o(),
            title: "🔥 " + t.$id,
            subtitle: "HMR update",
            data: {
              store: mn(t.$id),
              info: mn("HMR update")
            }
          }
        }), n.notifyComponentUpdate(), n.sendInspectorTree(kt), n.sendInspectorState(kt);
      });
      const {
        $dispose: a
      } = t;
      t.$dispose = () => {
        a(), n.notifyComponentUpdate(), n.sendInspectorTree(kt), n.sendInspectorState(kt), n.getSettings().logStoreChanges && bt(`Disposed "${t.$id}" store 🗑`);
      }, n.notifyComponentUpdate(), n.sendInspectorTree(kt), n.sendInspectorState(kt), n.getSettings().logStoreChanges && bt(`"${t.$id}" store installed 🆕`);
    });
  }
  let Kp = 0,
    so;
  function Yp(e, t, n) {
    const o = t.reduce((s, a) => (s[a] = Le(e)[a], s), {});
    for (const s in o) e[s] = function () {
      const a = Kp,
        r = n ? new Proxy(e, {
          get(...l) {
            return so = a, Reflect.get(...l);
          },
          set(...l) {
            return so = a, Reflect.set(...l);
          }
        }) : e;
      so = a;
      const i = o[s].apply(r, arguments);
      return so = void 0, i;
    };
  }
  function lD({
    app: e,
    store: t,
    options: n
  }) {
    if (!t.$id.startsWith("__hot:")) {
      if (t._isOptionsAPI = !!n.state, !t._p._testing) {
        Yp(t, Object.keys(n.actions), t._isOptionsAPI);
        const o = t._hotUpdate;
        Le(t)._hotUpdate = function (s) {
          o.apply(this, arguments), Yp(t, Object.keys(s._hmrPayload.actions), !!t._isOptionsAPI);
        };
      }
      rD(e, t);
    }
  }
  function uD() {
    const e = Gu(!0),
      t = e.run(() => H({}));
    let n = [],
      o = [];
    const s = wn({
      install(a) {
        Ys(s), s._a = a, a.provide(Up, s), a.config.globalProperties.$pinia = s, Eo && iD(a, s), o.forEach(r => n.push(r)), o = [];
      },
      use(a) {
        return this._a ? n.push(a) : o.push(a), this;
      },
      _p: n,
      _a: null,
      _e: e,
      _s: new Map(),
      state: t
    });
    return Eo && typeof Proxy < "u" && s.use(lD), s;
  }
  function Qp(e, t) {
    for (const n in t) {
      const o = t[n];
      if (!(n in e)) continue;
      const s = e[n];
      Oo(s) && Oo(o) && !tt(o) && !_n(o) ? e[n] = Qp(s, o) : e[n] = o;
    }
    return e;
  }
  const cD = () => {};
  function qp(e, t, n, o = cD) {
    e.push(t);
    const s = () => {
      const a = e.indexOf(t);
      a > -1 && (e.splice(a, 1), o());
    };
    return !n && Wu() && Li(s), s;
  }
  function ss(e, ...t) {
    e.slice().forEach(n => {
      n(...t);
    });
  }
  const dD = e => e(),
    Xp = Symbol(),
    Xr = Symbol();
  function Zr(e, t) {
    e instanceof Map && t instanceof Map ? t.forEach((n, o) => e.set(o, n)) : e instanceof Set && t instanceof Set && t.forEach(e.add, e);
    for (const n in t) {
      if (!t.hasOwnProperty(n)) continue;
      const o = t[n],
        s = e[n];
      Oo(s) && Oo(o) && e.hasOwnProperty(n) && !tt(o) && !_n(o) ? e[n] = Zr(s, o) : e[n] = o;
    }
    return e;
  }
  const fD = Symbol("pinia:skipHydration");
  function pD(e) {
    return !Oo(e) || !Object.prototype.hasOwnProperty.call(e, fD);
  }
  const {
    assign: tn
  } = Object;
  function Zp(e) {
    return !!(tt(e) && e.effect);
  }
  function Jp(e, t, n, o) {
    const {
        state: s,
        actions: a,
        getters: r
      } = t,
      i = n.state.value[e];
    let l;
    function u() {
      !i && !o && (n.state.value[e] = s ? s() : {});
      const c = ba(o ? H(s ? s() : {}).value : n.state.value[e]);
      return tn(c, a, Object.keys(r || {}).reduce((d, p) => (p in c && console.warn(`[🍍]: A getter cannot have the same name as another state property. Rename one of them. Found with "${p}" in store "${e}".`), d[p] = wn(b(() => {
        Ys(n);
        const f = n._s.get(e);
        return r[p].call(f, f);
      })), d), {}));
    }
    return l = Jr(e, u, t, n, o, !0), l;
  }
  function Jr(e, t, n = {}, o, s, a) {
    let r;
    const i = tn({
      actions: {}
    }, n);
    if (!o._e.active) throw new Error("Pinia destroyed");
    const l = {
      deep: !0
    };
    l.onTrigger = C => {
      u ? f = C : u == !1 && !B._hotUpdating && (Array.isArray(f) ? f.push(C) : console.error("🍍 debuggerEvents should be an array. This is most likely an internal Pinia bug."));
    };
    let u,
      c,
      d = [],
      p = [],
      f;
    const v = o.state.value[e];
    !a && !v && !s && (o.state.value[e] = {});
    const h = H({});
    let m;
    function D(C) {
      let S;
      u = c = !1, f = [], typeof C == "function" ? (C(o.state.value[e]), S = {
        type: In.patchFunction,
        storeId: e,
        events: f
      }) : (Zr(o.state.value[e], C), S = {
        type: In.patchObject,
        payload: C,
        storeId: e,
        events: f
      });
      const R = m = Symbol();
      Ho().then(() => {
        m === R && (u = !0);
      }), c = !0, ss(d, S, o.state.value[e]);
    }
    const N = a ? function () {
      const {
          state: S
        } = n,
        R = S ? S() : {};
      this.$patch(E => {
        tn(E, R);
      });
    } : () => {
      throw new Error(`🍍: Store "${e}" is built using the setup syntax and does not implement $reset().`);
    };
    function I() {
      r.stop(), d = [], p = [], o._s.delete(e);
    }
    const w = (C, S = "") => {
        if (Xp in C) return C[Xr] = S, C;
        const R = function () {
          Ys(o);
          const E = Array.from(arguments),
            L = [],
            G = [];
          function X(be) {
            L.push(be);
          }
          function K(be) {
            G.push(be);
          }
          ss(p, {
            args: E,
            name: R[Xr],
            store: B,
            after: X,
            onError: K
          });
          let de;
          try {
            de = C.apply(this && this.$id === e ? this : B, E);
          } catch (be) {
            throw ss(G, be), be;
          }
          return de instanceof Promise ? de.then(be => (ss(L, be), be)).catch(be => (ss(G, be), Promise.reject(be))) : (ss(L, de), de);
        };
        return R[Xp] = !0, R[Xr] = S, R;
      },
      A = wn({
        actions: {},
        getters: {},
        state: [],
        hotState: h
      }),
      j = {
        _p: o,
        $id: e,
        $onAction: qp.bind(null, p),
        $patch: D,
        $reset: N,
        $subscribe(C, S = {}) {
          const R = qp(d, C, S.detached, () => E()),
            E = r.run(() => U(() => o.state.value[e], L => {
              (S.flush === "sync" ? c : u) && C({
                storeId: e,
                type: In.direct,
                events: f
              }, L);
            }, tn({}, l, S)));
          return R;
        },
        $dispose: I
      },
      B = Xe(tn({
        _hmrPayload: A,
        _customProperties: wn(new Set())
      }, j));
    o._s.set(e, B);
    const g = (o._a && o._a.runWithContext || dD)(() => o._e.run(() => (r = Gu()).run(() => t({
      action: w
    }))));
    for (const C in g) {
      const S = g[C];
      if (tt(S) && !Zp(S) || _n(S)) s ? h.value[C] = Oa(g, C) : a || (v && pD(S) && (tt(S) ? S.value = v[C] : Zr(S, v[C])), o.state.value[e][C] = S), A.state.push(C);else if (typeof S == "function") {
        const R = s ? S : w(S, C);
        g[C] = R, A.actions[C] = S, i.actions[C] = S;
      } else Zp(S) && (A.getters[C] = a ? n.getters[C] : S, Eo && (g._getters || (g._getters = wn([]))).push(C));
    }
    if (tn(B, g), tn(Le(B), g), Object.defineProperty(B, "$state", {
      get: () => s ? h.value : o.state.value[e],
      set: C => {
        if (s) throw new Error("cannot set hotState");
        D(S => {
          tn(S, C);
        });
      }
    }), B._hotUpdate = wn(C => {
      B._hotUpdating = !0, C._hmrPayload.state.forEach(S => {
        if (S in B.$state) {
          const R = C.$state[S],
            E = B.$state[S];
          typeof R == "object" && Oo(R) && Oo(E) ? Qp(R, E) : C.$state[S] = E;
        }
        B[S] = Oa(C.$state, S);
      }), Object.keys(B.$state).forEach(S => {
        S in C.$state || delete B[S];
      }), u = !1, c = !1, o.state.value[e] = Oa(C._hmrPayload, "hotState"), c = !0, Ho().then(() => {
        u = !0;
      });
      for (const S in C._hmrPayload.actions) {
        const R = C[S];
        B[S] = w(R, S);
      }
      for (const S in C._hmrPayload.getters) {
        const R = C._hmrPayload.getters[S],
          E = a ? b(() => (Ys(o), R.call(B, B))) : R;
        B[S] = E;
      }
      Object.keys(B._hmrPayload.getters).forEach(S => {
        S in C._hmrPayload.getters || delete B[S];
      }), Object.keys(B._hmrPayload.actions).forEach(S => {
        S in C._hmrPayload.actions || delete B[S];
      }), B._hmrPayload = C._hmrPayload, B._getters = C._getters, B._hotUpdating = !1;
    }), Eo) {
      const C = {
        writable: !0,
        configurable: !0,
        enumerable: !1
      };
      ["_p", "_hmrPayload", "_getters", "_customProperties"].forEach(S => {
        Object.defineProperty(B, S, tn({
          value: B[S]
        }, C));
      });
    }
    return o._p.forEach(C => {
      if (Eo) {
        const S = r.run(() => C({
          store: B,
          app: o._a,
          pinia: o,
          options: i
        }));
        Object.keys(S || {}).forEach(R => B._customProperties.add(R)), tn(B, S);
      } else tn(B, r.run(() => C({
        store: B,
        app: o._a,
        pinia: o,
        options: i
      })));
    }), B.$state && typeof B.$state == "object" && typeof B.$state.constructor == "function" && !B.$state.constructor.toString().includes("[native code]") && console.warn(`[🍍]: The "state" must be a plain object. It cannot be
	state: () => new MyClass()
Found in store "${B.$id}".`), v && a && n.hydrate && n.hydrate(B.$state, v), u = !0, c = !0, B;
  } /*! #__NO_SIDE_EFFECTS__ */
  function Qs(e, t, n) {
    let o;
    const s = typeof t == "function";
    o = s ? n : t;
    function a(r, i) {
      const l = Qc();
      if (r = r || (l ? Te(Up, null) : null), r && Ys(r), !Yr) throw new Error(`[🍍]: "getActivePinia()" was called but there was no active Pinia. Are you trying to use a store before calling "app.use(pinia)"?
See https://pinia.vuejs.org/core-concepts/outside-component-usage.html for help.
This will fail in production.`);
      r = Yr, r._s.has(e) || (s ? Jr(e, t, o, r) : Jp(e, o, r), a._pinia = r);
      const u = r._s.get(e);
      if (i) {
        const c = "__hot:" + e,
          d = s ? Jr(c, t, o, r, !0) : Jp(c, tn({}, o), r, !0);
        i._hotUpdate(d), delete r.state.value[c], r._s.delete(c);
      }
      if (Eo) {
        const c = $s();
        if (c && c.proxy && !i) {
          const d = c.proxy,
            p = "_pStores" in d ? d._pStores : d._pStores = {};
          p[e] = u;
        }
      }
      return u;
    }
    return a.$id = e, a;
  }
  function _D(e) {
    const t = Le(e),
      n = {};
    for (const o in t) {
      const s = t[o];
      s.effect ? n[o] = b({
        get: () => e[o],
        set(a) {
          e[o] = a;
        }
      }) : (tt(s) || _n(s)) && (n[o] = Oa(e, o));
    }
    return n;
  }
  var as = class {
      constructor() {
        this.listeners = new Set(), this.subscribe = this.subscribe.bind(this);
      }
      subscribe(e) {
        return this.listeners.add(e), this.onSubscribe(), () => {
          this.listeners.delete(e), this.onUnsubscribe();
        };
      }
      hasListeners() {
        return this.listeners.size > 0;
      }
      onSubscribe() {}
      onUnsubscribe() {}
    },
    hD = {
      setTimeout: (e, t) => setTimeout(e, t),
      clearTimeout: e => clearTimeout(e),
      setInterval: (e, t) => setInterval(e, t),
      clearInterval: e => clearInterval(e)
    },
    vD = class {
      #e = hD;
      #t = !1;
      setTimeoutProvider(e) {
        this.#t && e !== this.#e && console.error("[timeoutManager]: Switching provider after calls to previous provider might result in unexpected behavior.", {
          previous: this.#e,
          provider: e
        }), this.#e = e, this.#t = !1;
      }
      setTimeout(e, t) {
        return this.#t = !0, this.#e.setTimeout(e, t);
      }
      clearTimeout(e) {
        this.#e.clearTimeout(e);
      }
      setInterval(e, t) {
        return this.#t = !0, this.#e.setInterval(e, t);
      }
      clearInterval(e) {
        this.#e.clearInterval(e);
      }
    },
    Ro = new vD();
  function mD(e) {
    setTimeout(e, 0);
  }
  var No = typeof window > "u" || "Deno" in globalThis;
  function nn() {}
  function CD(e, t) {
    return typeof e == "function" ? e(t) : e;
  }
  function el(e) {
    return typeof e == "number" && e >= 0 && e !== 1 / 0;
  }
  function e_(e, t) {
    return Math.max(e + (t || 0) - Date.now(), 0);
  }
  function ao(e, t) {
    return typeof e == "function" ? e(t) : e;
  }
  function on(e, t) {
    return typeof e == "function" ? e(t) : e;
  }
  function t_(e, t) {
    const {
      type: n = "all",
      exact: o,
      fetchStatus: s,
      predicate: a,
      queryKey: r,
      stale: i
    } = e;
    if (r) {
      if (o) {
        if (t.queryHash !== tl(r, t.options)) return !1;
      } else if (!qs(t.queryKey, r)) return !1;
    }
    if (n !== "all") {
      const l = t.isActive();
      if (n === "active" && !l || n === "inactive" && l) return !1;
    }
    return !(typeof i == "boolean" && t.isStale() !== i || s && s !== t.state.fetchStatus || a && !a(t));
  }
  function n_(e, t) {
    const {
      exact: n,
      status: o,
      predicate: s,
      mutationKey: a
    } = e;
    if (a) {
      if (!t.options.mutationKey) return !1;
      if (n) {
        if (Ao(t.options.mutationKey) !== Ao(a)) return !1;
      } else if (!qs(t.options.mutationKey, a)) return !1;
    }
    return !(o && t.state.status !== o || s && !s(t));
  }
  function tl(e, t) {
    return (t?.queryKeyHashFn || Ao)(e);
  }
  function Ao(e) {
    return JSON.stringify(e, (t, n) => ol(n) ? Object.keys(n).sort().reduce((o, s) => (o[s] = n[s], o), {}) : n);
  }
  function qs(e, t) {
    return e === t ? !0 : typeof e != typeof t ? !1 : e && t && typeof e == "object" && typeof t == "object" ? Object.keys(t).every(n => qs(e[n], t[n])) : !1;
  }
  var TD = Object.prototype.hasOwnProperty;
  function nl(e, t) {
    if (e === t) return e;
    const n = o_(e) && o_(t);
    if (!n && !(ol(e) && ol(t))) return t;
    const s = (n ? e : Object.keys(e)).length,
      a = n ? t : Object.keys(t),
      r = a.length,
      i = n ? new Array(r) : {};
    let l = 0;
    for (let u = 0; u < r; u++) {
      const c = n ? u : a[u],
        d = e[c],
        p = t[c];
      if (d === p) {
        i[c] = d, (n ? u < s : TD.call(e, c)) && l++;
        continue;
      }
      if (d === null || p === null || typeof d != "object" || typeof p != "object") {
        i[c] = p;
        continue;
      }
      const f = nl(d, p);
      i[c] = f, f === d && l++;
    }
    return s === r && l === s ? e : i;
  }
  function ui(e, t) {
    if (!t || Object.keys(e).length !== Object.keys(t).length) return !1;
    for (const n in e) if (e[n] !== t[n]) return !1;
    return !0;
  }
  function o_(e) {
    return Array.isArray(e) && e.length === Object.keys(e).length;
  }
  function ol(e) {
    if (!s_(e)) return !1;
    const t = e.constructor;
    if (t === void 0) return !0;
    const n = t.prototype;
    return !(!s_(n) || !n.hasOwnProperty("isPrototypeOf") || Object.getPrototypeOf(e) !== Object.prototype);
  }
  function s_(e) {
    return Object.prototype.toString.call(e) === "[object Object]";
  }
  function gD(e) {
    return new Promise(t => {
      Ro.setTimeout(t, e);
    });
  }
  function sl(e, t, n) {
    if (typeof n.structuralSharing == "function") return n.structuralSharing(e, t);
    if (n.structuralSharing !== !1) {
      try {
        return nl(e, t);
      } catch (o) {
        throw console.error(`Structural sharing requires data to be JSON serializable. To fix this, turn off structuralSharing or return JSON-serializable data from your queryFn. [${n.queryHash}]: ${o}`), o;
      }
      return nl(e, t);
    }
    return t;
  }
  function yD(e, t, n = 0) {
    const o = [...e, t];
    return n && o.length > n ? o.slice(1) : o;
  }
  function DD(e, t, n = 0) {
    const o = [t, ...e];
    return n && o.length > n ? o.slice(0, -1) : o;
  }
  var ci = Symbol();
  function a_(e, t) {
    return e.queryFn === ci && console.error(`Attempted to invoke queryFn when set to skipToken. This is likely a configuration error. Query hash: '${e.queryHash}'`), !e.queryFn && t?.initialPromise ? () => t.initialPromise : !e.queryFn || e.queryFn === ci ? () => Promise.reject(new Error(`Missing queryFn: '${e.queryHash}'`)) : e.queryFn;
  }
  function al(e, t) {
    return typeof e == "function" ? e(...t) : !!e;
  }
  var SD = class extends as {
      #e;
      #t;
      #n;
      constructor() {
        super(), this.#n = e => {
          if (!No && window.addEventListener) {
            const t = () => e();
            return window.addEventListener("visibilitychange", t, !1), () => {
              window.removeEventListener("visibilitychange", t);
            };
          }
        };
      }
      onSubscribe() {
        this.#t || this.setEventListener(this.#n);
      }
      onUnsubscribe() {
        this.hasListeners() || (this.#t?.(), this.#t = void 0);
      }
      setEventListener(e) {
        this.#n = e, this.#t?.(), this.#t = e(t => {
          typeof t == "boolean" ? this.setFocused(t) : this.onFocus();
        });
      }
      setFocused(e) {
        this.#e !== e && (this.#e = e, this.onFocus());
      }
      onFocus() {
        const e = this.isFocused();
        this.listeners.forEach(t => {
          t(e);
        });
      }
      isFocused() {
        return typeof this.#e == "boolean" ? this.#e : globalThis.document?.visibilityState !== "hidden";
      }
    },
    il = new SD();
  function rl() {
    let e, t;
    const n = new Promise((s, a) => {
      e = s, t = a;
    });
    n.status = "pending", n.catch(() => {});
    function o(s) {
      Object.assign(n, s), delete n.resolve, delete n.reject;
    }
    return n.resolve = s => {
      o({
        status: "fulfilled",
        value: s
      }), e(s);
    }, n.reject = s => {
      o({
        status: "rejected",
        reason: s
      }), t(s);
    }, n;
  }
  var PD = mD;
  function bD() {
    let e = [],
      t = 0,
      n = i => {
        i();
      },
      o = i => {
        i();
      },
      s = PD;
    const a = i => {
        t ? e.push(i) : s(() => {
          n(i);
        });
      },
      r = () => {
        const i = e;
        e = [], i.length && s(() => {
          o(() => {
            i.forEach(l => {
              n(l);
            });
          });
        });
      };
    return {
      batch: i => {
        let l;
        t++;
        try {
          l = i();
        } finally {
          t--, t || r();
        }
        return l;
      },
      batchCalls: i => (...l) => {
        a(() => {
          i(...l);
        });
      },
      schedule: a,
      setNotifyFunction: i => {
        n = i;
      },
      setBatchNotifyFunction: i => {
        o = i;
      },
      setScheduler: i => {
        s = i;
      }
    };
  }
  var Rt = bD(),
    OD = class extends as {
      #e = !0;
      #t;
      #n;
      constructor() {
        super(), this.#n = e => {
          if (!No && window.addEventListener) {
            const t = () => e(!0),
              n = () => e(!1);
            return window.addEventListener("online", t, !1), window.addEventListener("offline", n, !1), () => {
              window.removeEventListener("online", t), window.removeEventListener("offline", n);
            };
          }
        };
      }
      onSubscribe() {
        this.#t || this.setEventListener(this.#n);
      }
      onUnsubscribe() {
        this.hasListeners() || (this.#t?.(), this.#t = void 0);
      }
      setEventListener(e) {
        this.#n = e, this.#t?.(), this.#t = e(this.setOnline.bind(this));
      }
      setOnline(e) {
        this.#e !== e && (this.#e = e, this.listeners.forEach(n => {
          n(e);
        }));
      }
      isOnline() {
        return this.#e;
      }
    },
    di = new OD();
  function ED(e) {
    return Math.min(1e3 * 2 ** e, 3e4);
  }
  function i_(e) {
    return (e ?? "online") === "online" ? di.isOnline() : !0;
  }
  var ll = class extends Error {
    constructor(e) {
      super("CancelledError"), this.revert = e?.revert, this.silent = e?.silent;
    }
  };
  function r_(e) {
    let t = !1,
      n = 0,
      o;
    const s = rl(),
      a = () => s.status !== "pending",
      r = h => {
        if (!a()) {
          const m = new ll(h);
          p(m), e.onCancel?.(m);
        }
      },
      i = () => {
        t = !0;
      },
      l = () => {
        t = !1;
      },
      u = () => il.isFocused() && (e.networkMode === "always" || di.isOnline()) && e.canRun(),
      c = () => i_(e.networkMode) && e.canRun(),
      d = h => {
        a() || (o?.(), s.resolve(h));
      },
      p = h => {
        a() || (o?.(), s.reject(h));
      },
      f = () => new Promise(h => {
        o = m => {
          (a() || u()) && h(m);
        }, e.onPause?.();
      }).then(() => {
        o = void 0, a() || e.onContinue?.();
      }),
      v = () => {
        if (a()) return;
        let h;
        const m = n === 0 ? e.initialPromise : void 0;
        try {
          h = m ?? e.fn();
        } catch (D) {
          h = Promise.reject(D);
        }
        Promise.resolve(h).then(d).catch(D => {
          if (a()) return;
          const N = e.retry ?? (No ? 0 : 3),
            I = e.retryDelay ?? ED,
            w = typeof I == "function" ? I(n, D) : I,
            A = N === !0 || typeof N == "number" && n < N || typeof N == "function" && N(n, D);
          if (t || !A) {
            p(D);
            return;
          }
          n++, e.onFail?.(n, D), gD(w).then(() => u() ? void 0 : f()).then(() => {
            t ? p(D) : v();
          });
        });
      };
    return {
      promise: s,
      status: () => s.status,
      cancel: r,
      continue: () => (o?.(), s),
      cancelRetry: i,
      continueRetry: l,
      canStart: c,
      start: () => (c() ? v() : f().then(v), s)
    };
  }
  var l_ = class {
      #e;
      destroy() {
        this.clearGcTimeout();
      }
      scheduleGc() {
        this.clearGcTimeout(), el(this.gcTime) && (this.#e = Ro.setTimeout(() => {
          this.optionalRemove();
        }, this.gcTime));
      }
      updateGcTime(e) {
        this.gcTime = Math.max(this.gcTime || 0, e ?? (No ? 1 / 0 : 300 * 1e3));
      }
      clearGcTimeout() {
        this.#e && (Ro.clearTimeout(this.#e), this.#e = void 0);
      }
    },
    ID = {
      NODE_ENV: '"production"'
    },
    RD = class extends l_ {
      #e;
      #t;
      #n;
      #s;
      #o;
      #i;
      #r;
      constructor(e) {
        super(), this.#r = !1, this.#i = e.defaultOptions, this.setOptions(e.options), this.observers = [], this.#s = e.client, this.#n = this.#s.getQueryCache(), this.queryKey = e.queryKey, this.queryHash = e.queryHash, this.#e = c_(this.options), this.state = e.state ?? this.#e, this.scheduleGc();
      }
      get meta() {
        return this.options.meta;
      }
      get promise() {
        return this.#o?.promise;
      }
      setOptions(e) {
        if (this.options = {
          ...this.#i,
          ...e
        }, this.updateGcTime(this.options.gcTime), this.state && this.state.data === void 0) {
          const t = c_(this.options);
          t.data !== void 0 && (this.setData(t.data, {
            updatedAt: t.dataUpdatedAt,
            manual: !0
          }), this.#e = t);
        }
      }
      optionalRemove() {
        !this.observers.length && this.state.fetchStatus === "idle" && this.#n.remove(this);
      }
      setData(e, t) {
        const n = sl(this.state.data, e, this.options);
        return this.#a({
          data: n,
          type: "success",
          dataUpdatedAt: t?.updatedAt,
          manual: t?.manual
        }), n;
      }
      setState(e, t) {
        this.#a({
          type: "setState",
          state: e,
          setStateOptions: t
        });
      }
      cancel(e) {
        const t = this.#o?.promise;
        return this.#o?.cancel(e), t ? t.then(nn).catch(nn) : Promise.resolve();
      }
      destroy() {
        super.destroy(), this.cancel({
          silent: !0
        });
      }
      reset() {
        this.destroy(), this.setState(this.#e);
      }
      isActive() {
        return this.observers.some(e => on(e.options.enabled, this) !== !1);
      }
      isDisabled() {
        return this.getObserversCount() > 0 ? !this.isActive() : this.options.queryFn === ci || this.state.dataUpdateCount + this.state.errorUpdateCount === 0;
      }
      isStatic() {
        return this.getObserversCount() > 0 ? this.observers.some(e => ao(e.options.staleTime, this) === "static") : !1;
      }
      isStale() {
        return this.getObserversCount() > 0 ? this.observers.some(e => e.getCurrentResult().isStale) : this.state.data === void 0 || this.state.isInvalidated;
      }
      isStaleByTime(e = 0) {
        return this.state.data === void 0 ? !0 : e === "static" ? !1 : this.state.isInvalidated ? !0 : !e_(this.state.dataUpdatedAt, e);
      }
      onFocus() {
        this.observers.find(t => t.shouldFetchOnWindowFocus())?.refetch({
          cancelRefetch: !1
        }), this.#o?.continue();
      }
      onOnline() {
        this.observers.find(t => t.shouldFetchOnReconnect())?.refetch({
          cancelRefetch: !1
        }), this.#o?.continue();
      }
      addObserver(e) {
        this.observers.includes(e) || (this.observers.push(e), this.clearGcTimeout(), this.#n.notify({
          type: "observerAdded",
          query: this,
          observer: e
        }));
      }
      removeObserver(e) {
        this.observers.includes(e) && (this.observers = this.observers.filter(t => t !== e), this.observers.length || (this.#o && (this.#r ? this.#o.cancel({
          revert: !0
        }) : this.#o.cancelRetry()), this.scheduleGc()), this.#n.notify({
          type: "observerRemoved",
          query: this,
          observer: e
        }));
      }
      getObserversCount() {
        return this.observers.length;
      }
      invalidate() {
        this.state.isInvalidated || this.#a({
          type: "invalidate"
        });
      }
      async fetch(e, t) {
        if (this.state.fetchStatus !== "idle" && this.#o?.status() !== "rejected") {
          if (this.state.data !== void 0 && t?.cancelRefetch) this.cancel({
            silent: !0
          });else if (this.#o) return this.#o.continueRetry(), this.#o.promise;
        }
        if (e && this.setOptions(e), !this.options.queryFn) {
          const i = this.observers.find(l => l.options.queryFn);
          i && this.setOptions(i.options);
        }
        Array.isArray(this.options.queryKey) || console.error("As of v4, queryKey needs to be an Array. If you are using a string like 'repoData', please change it to an Array, e.g. ['repoData']");
        const n = new AbortController(),
          o = i => {
            Object.defineProperty(i, "signal", {
              enumerable: !0,
              get: () => (this.#r = !0, n.signal)
            });
          },
          s = () => {
            const i = a_(this.options, t),
              u = (() => {
                const c = {
                  client: this.#s,
                  queryKey: this.queryKey,
                  meta: this.meta
                };
                return o(c), c;
              })();
            return this.#r = !1, this.options.persister ? this.options.persister(i, u, this) : i(u);
          },
          r = (() => {
            const i = {
              fetchOptions: t,
              options: this.options,
              queryKey: this.queryKey,
              client: this.#s,
              state: this.state,
              fetchFn: s
            };
            return o(i), i;
          })();
        this.options.behavior?.onFetch(r, this), this.#t = this.state, (this.state.fetchStatus === "idle" || this.state.fetchMeta !== r.fetchOptions?.meta) && this.#a({
          type: "fetch",
          meta: r.fetchOptions?.meta
        }), this.#o = r_({
          initialPromise: t?.initialPromise,
          fn: r.fetchFn,
          onCancel: i => {
            i instanceof ll && i.revert && this.setState({
              ...this.#t,
              fetchStatus: "idle"
            }), n.abort();
          },
          onFail: (i, l) => {
            this.#a({
              type: "failed",
              failureCount: i,
              error: l
            });
          },
          onPause: () => {
            this.#a({
              type: "pause"
            });
          },
          onContinue: () => {
            this.#a({
              type: "continue"
            });
          },
          retry: r.options.retry,
          retryDelay: r.options.retryDelay,
          networkMode: r.options.networkMode,
          canRun: () => !0
        });
        try {
          const i = await this.#o.start();
          if (i === void 0) throw ID.NODE_ENV !== "production" && console.error(`Query data cannot be undefined. Please make sure to return a value other than undefined from your query function. Affected query key: ${this.queryHash}`), new Error(`${this.queryHash} data is undefined`);
          return this.setData(i), this.#n.config.onSuccess?.(i, this), this.#n.config.onSettled?.(i, this.state.error, this), i;
        } catch (i) {
          if (i instanceof ll) {
            if (i.silent) return this.#o.promise;
            if (i.revert) {
              if (this.state.data === void 0) throw i;
              return this.state.data;
            }
          }
          throw this.#a({
            type: "error",
            error: i
          }), this.#n.config.onError?.(i, this), this.#n.config.onSettled?.(this.state.data, i, this), i;
        } finally {
          this.scheduleGc();
        }
      }
      #a(e) {
        const t = n => {
          switch (e.type) {
            case "failed":
              return {
                ...n,
                fetchFailureCount: e.failureCount,
                fetchFailureReason: e.error
              };
            case "pause":
              return {
                ...n,
                fetchStatus: "paused"
              };
            case "continue":
              return {
                ...n,
                fetchStatus: "fetching"
              };
            case "fetch":
              return {
                ...n,
                ...u_(n.data, this.options),
                fetchMeta: e.meta ?? null
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
                ...(!e.manual && {
                  fetchStatus: "idle",
                  fetchFailureCount: 0,
                  fetchFailureReason: null
                })
              };
              return this.#t = e.manual ? o : void 0, o;
            case "error":
              const s = e.error;
              return {
                ...n,
                error: s,
                errorUpdateCount: n.errorUpdateCount + 1,
                errorUpdatedAt: Date.now(),
                fetchFailureCount: n.fetchFailureCount + 1,
                fetchFailureReason: s,
                fetchStatus: "idle",
                status: "error"
              };
            case "invalidate":
              return {
                ...n,
                isInvalidated: !0
              };
            case "setState":
              return {
                ...n,
                ...e.state
              };
          }
        };
        this.state = t(this.state), Rt.batch(() => {
          this.observers.forEach(n => {
            n.onQueryUpdate();
          }), this.#n.notify({
            query: this,
            type: "updated",
            action: e
          });
        });
      }
    };
  function u_(e, t) {
    return {
      fetchFailureCount: 0,
      fetchFailureReason: null,
      fetchStatus: i_(t.networkMode) ? "fetching" : "paused",
      ...(e === void 0 && {
        error: null,
        status: "pending"
      })
    };
  }
  function c_(e) {
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
    };
  }
  var ND = class extends as {
    constructor(e, t) {
      super(), this.options = t, this.#e = e, this.#a = null, this.#r = rl(), this.bindMethods(), this.setOptions(t);
    }
    #e;
    #t = void 0;
    #n = void 0;
    #s = void 0;
    #o;
    #i;
    #r;
    #a;
    #h;
    #f;
    #p;
    #u;
    #c;
    #l;
    #_ = new Set();
    bindMethods() {
      this.refetch = this.refetch.bind(this);
    }
    onSubscribe() {
      this.listeners.size === 1 && (this.#t.addObserver(this), d_(this.#t, this.options) ? this.#d() : this.updateResult(), this.#T());
    }
    onUnsubscribe() {
      this.hasListeners() || this.destroy();
    }
    shouldFetchOnReconnect() {
      return ul(this.#t, this.options, this.options.refetchOnReconnect);
    }
    shouldFetchOnWindowFocus() {
      return ul(this.#t, this.options, this.options.refetchOnWindowFocus);
    }
    destroy() {
      this.listeners = new Set(), this.#g(), this.#y(), this.#t.removeObserver(this);
    }
    setOptions(e) {
      const t = this.options,
        n = this.#t;
      if (this.options = this.#e.defaultQueryOptions(e), this.options.enabled !== void 0 && typeof this.options.enabled != "boolean" && typeof this.options.enabled != "function" && typeof on(this.options.enabled, this.#t) != "boolean") throw new Error("Expected enabled to be a boolean or a callback that returns a boolean");
      this.#D(), this.#t.setOptions(this.options), t._defaulted && !ui(this.options, t) && this.#e.getQueryCache().notify({
        type: "observerOptionsUpdated",
        query: this.#t,
        observer: this
      });
      const o = this.hasListeners();
      o && f_(this.#t, n, this.options, t) && this.#d(), this.updateResult(), o && (this.#t !== n || on(this.options.enabled, this.#t) !== on(t.enabled, this.#t) || ao(this.options.staleTime, this.#t) !== ao(t.staleTime, this.#t)) && this.#v();
      const s = this.#m();
      o && (this.#t !== n || on(this.options.enabled, this.#t) !== on(t.enabled, this.#t) || s !== this.#l) && this.#C(s);
    }
    getOptimisticResult(e) {
      const t = this.#e.getQueryCache().build(this.#e, e),
        n = this.createResult(t, e);
      return MD(this, n) && (this.#s = n, this.#i = this.options, this.#o = this.#t.state), n;
    }
    getCurrentResult() {
      return this.#s;
    }
    trackResult(e, t) {
      return new Proxy(e, {
        get: (n, o) => (this.trackProp(o), t?.(o), o === "promise" && !this.options.experimental_prefetchInRender && this.#r.status === "pending" && this.#r.reject(new Error("experimental_prefetchInRender feature flag is not enabled")), Reflect.get(n, o))
      });
    }
    trackProp(e) {
      this.#_.add(e);
    }
    getCurrentQuery() {
      return this.#t;
    }
    refetch({
      ...e
    } = {}) {
      return this.fetch({
        ...e
      });
    }
    fetchOptimistic(e) {
      const t = this.#e.defaultQueryOptions(e),
        n = this.#e.getQueryCache().build(this.#e, t);
      return n.fetch().then(() => this.createResult(n, t));
    }
    fetch(e) {
      return this.#d({
        ...e,
        cancelRefetch: e.cancelRefetch ?? !0
      }).then(() => (this.updateResult(), this.#s));
    }
    #d(e) {
      this.#D();
      let t = this.#t.fetch(this.options, e);
      return e?.throwOnError || (t = t.catch(nn)), t;
    }
    #v() {
      this.#g();
      const e = ao(this.options.staleTime, this.#t);
      if (No || this.#s.isStale || !el(e)) return;
      const n = e_(this.#s.dataUpdatedAt, e) + 1;
      this.#u = Ro.setTimeout(() => {
        this.#s.isStale || this.updateResult();
      }, n);
    }
    #m() {
      return (typeof this.options.refetchInterval == "function" ? this.options.refetchInterval(this.#t) : this.options.refetchInterval) ?? !1;
    }
    #C(e) {
      this.#y(), this.#l = e, !(No || on(this.options.enabled, this.#t) === !1 || !el(this.#l) || this.#l === 0) && (this.#c = Ro.setInterval(() => {
        (this.options.refetchIntervalInBackground || il.isFocused()) && this.#d();
      }, this.#l));
    }
    #T() {
      this.#v(), this.#C(this.#m());
    }
    #g() {
      this.#u && (Ro.clearTimeout(this.#u), this.#u = void 0);
    }
    #y() {
      this.#c && (Ro.clearInterval(this.#c), this.#c = void 0);
    }
    createResult(e, t) {
      const n = this.#t,
        o = this.options,
        s = this.#s,
        a = this.#o,
        r = this.#i,
        l = e !== n ? e.state : this.#n,
        {
          state: u
        } = e;
      let c = {
          ...u
        },
        d = !1,
        p;
      if (t._optimisticResults) {
        const T = this.hasListeners(),
          g = !T && d_(e, t),
          C = T && f_(e, n, t, o);
        (g || C) && (c = {
          ...c,
          ...u_(u.data, e.options)
        }), t._optimisticResults === "isRestoring" && (c.fetchStatus = "idle");
      }
      let {
        error: f,
        errorUpdatedAt: v,
        status: h
      } = c;
      p = c.data;
      let m = !1;
      if (t.placeholderData !== void 0 && p === void 0 && h === "pending") {
        let T;
        s?.isPlaceholderData && t.placeholderData === r?.placeholderData ? (T = s.data, m = !0) : T = typeof t.placeholderData == "function" ? t.placeholderData(this.#p?.state.data, this.#p) : t.placeholderData, T !== void 0 && (h = "success", p = sl(s?.data, T, t), d = !0);
      }
      if (t.select && p !== void 0 && !m) if (s && p === a?.data && t.select === this.#h) p = this.#f;else try {
        this.#h = t.select, p = t.select(p), p = sl(s?.data, p, t), this.#f = p, this.#a = null;
      } catch (T) {
        this.#a = T;
      }
      this.#a && (f = this.#a, p = this.#f, v = Date.now(), h = "error");
      const D = c.fetchStatus === "fetching",
        N = h === "pending",
        I = h === "error",
        w = N && D,
        A = p !== void 0,
        B = {
          status: h,
          fetchStatus: c.fetchStatus,
          isPending: N,
          isSuccess: h === "success",
          isError: I,
          isInitialLoading: w,
          isLoading: w,
          data: p,
          dataUpdatedAt: c.dataUpdatedAt,
          error: f,
          errorUpdatedAt: v,
          failureCount: c.fetchFailureCount,
          failureReason: c.fetchFailureReason,
          errorUpdateCount: c.errorUpdateCount,
          isFetched: c.dataUpdateCount > 0 || c.errorUpdateCount > 0,
          isFetchedAfterMount: c.dataUpdateCount > l.dataUpdateCount || c.errorUpdateCount > l.errorUpdateCount,
          isFetching: D,
          isRefetching: D && !N,
          isLoadingError: I && !A,
          isPaused: c.fetchStatus === "paused",
          isPlaceholderData: d,
          isRefetchError: I && A,
          isStale: cl(e, t),
          refetch: this.refetch,
          promise: this.#r,
          isEnabled: on(t.enabled, e) !== !1
        };
      if (this.options.experimental_prefetchInRender) {
        const T = S => {
            B.status === "error" ? S.reject(B.error) : B.data !== void 0 && S.resolve(B.data);
          },
          g = () => {
            const S = this.#r = B.promise = rl();
            T(S);
          },
          C = this.#r;
        switch (C.status) {
          case "pending":
            e.queryHash === n.queryHash && T(C);
            break;
          case "fulfilled":
            (B.status === "error" || B.data !== C.value) && g();
            break;
          case "rejected":
            (B.status !== "error" || B.error !== C.reason) && g();
            break;
        }
      }
      return B;
    }
    updateResult() {
      const e = this.#s,
        t = this.createResult(this.#t, this.options);
      if (this.#o = this.#t.state, this.#i = this.options, this.#o.data !== void 0 && (this.#p = this.#t), ui(t, e)) return;
      this.#s = t;
      const n = () => {
        if (!e) return !0;
        const {
            notifyOnChangeProps: o
          } = this.options,
          s = typeof o == "function" ? o() : o;
        if (s === "all" || !s && !this.#_.size) return !0;
        const a = new Set(s ?? this.#_);
        return this.options.throwOnError && a.add("error"), Object.keys(this.#s).some(r => {
          const i = r;
          return this.#s[i] !== e[i] && a.has(i);
        });
      };
      this.#S({
        listeners: n()
      });
    }
    #D() {
      const e = this.#e.getQueryCache().build(this.#e, this.options);
      if (e === this.#t) return;
      const t = this.#t;
      this.#t = e, this.#n = e.state, this.hasListeners() && (t?.removeObserver(this), e.addObserver(this));
    }
    onQueryUpdate() {
      this.updateResult(), this.hasListeners() && this.#T();
    }
    #S(e) {
      Rt.batch(() => {
        e.listeners && this.listeners.forEach(t => {
          t(this.#s);
        }), this.#e.getQueryCache().notify({
          query: this.#t,
          type: "observerResultsUpdated"
        });
      });
    }
  };
  function AD(e, t) {
    return on(t.enabled, e) !== !1 && e.state.data === void 0 && !(e.state.status === "error" && t.retryOnMount === !1);
  }
  function d_(e, t) {
    return AD(e, t) || e.state.data !== void 0 && ul(e, t, t.refetchOnMount);
  }
  function ul(e, t, n) {
    if (on(t.enabled, e) !== !1 && ao(t.staleTime, e) !== "static") {
      const o = typeof n == "function" ? n(e) : n;
      return o === "always" || o !== !1 && cl(e, t);
    }
    return !1;
  }
  function f_(e, t, n, o) {
    return (e !== t || on(o.enabled, e) === !1) && (!n.suspense || e.state.status !== "error") && cl(e, n);
  }
  function cl(e, t) {
    return on(t.enabled, e) !== !1 && e.isStaleByTime(ao(t.staleTime, e));
  }
  function MD(e, t) {
    return !ui(e.getCurrentResult(), t);
  }
  function p_(e) {
    return {
      onFetch: (t, n) => {
        const o = t.options,
          s = t.fetchOptions?.meta?.fetchMore?.direction,
          a = t.state.data?.pages || [],
          r = t.state.data?.pageParams || [];
        let i = {
            pages: [],
            pageParams: []
          },
          l = 0;
        const u = async () => {
          let c = !1;
          const d = v => {
              Object.defineProperty(v, "signal", {
                enumerable: !0,
                get: () => (t.signal.aborted ? c = !0 : t.signal.addEventListener("abort", () => {
                  c = !0;
                }), t.signal)
              });
            },
            p = a_(t.options, t.fetchOptions),
            f = async (v, h, m) => {
              if (c) return Promise.reject();
              if (h == null && v.pages.length) return Promise.resolve(v);
              const N = (() => {
                  const j = {
                    client: t.client,
                    queryKey: t.queryKey,
                    pageParam: h,
                    direction: m ? "backward" : "forward",
                    meta: t.options.meta
                  };
                  return d(j), j;
                })(),
                I = await p(N),
                {
                  maxPages: w
                } = t.options,
                A = m ? DD : yD;
              return {
                pages: A(v.pages, I, w),
                pageParams: A(v.pageParams, h, w)
              };
            };
          if (s && a.length) {
            const v = s === "backward",
              h = v ? wD : __,
              m = {
                pages: a,
                pageParams: r
              },
              D = h(o, m);
            i = await f(m, D, v);
          } else {
            const v = e ?? a.length;
            do {
              const h = l === 0 ? r[0] ?? o.initialPageParam : __(o, i);
              if (l > 0 && h == null) break;
              i = await f(i, h), l++;
            } while (l < v);
          }
          return i;
        };
        t.options.persister ? t.fetchFn = () => t.options.persister?.(u, {
          client: t.client,
          queryKey: t.queryKey,
          meta: t.options.meta,
          signal: t.signal
        }, n) : t.fetchFn = u;
      }
    };
  }
  function __(e, {
    pages: t,
    pageParams: n
  }) {
    const o = t.length - 1;
    return t.length > 0 ? e.getNextPageParam(t[o], t, n[o], n) : void 0;
  }
  function wD(e, {
    pages: t,
    pageParams: n
  }) {
    return t.length > 0 ? e.getPreviousPageParam?.(t[0], t, n[0], n) : void 0;
  }
  var LD = class extends l_ {
    #e;
    #t;
    #n;
    #s;
    constructor(e) {
      super(), this.#e = e.client, this.mutationId = e.mutationId, this.#n = e.mutationCache, this.#t = [], this.state = e.state || h_(), this.setOptions(e.options), this.scheduleGc();
    }
    setOptions(e) {
      this.options = e, this.updateGcTime(this.options.gcTime);
    }
    get meta() {
      return this.options.meta;
    }
    addObserver(e) {
      this.#t.includes(e) || (this.#t.push(e), this.clearGcTimeout(), this.#n.notify({
        type: "observerAdded",
        mutation: this,
        observer: e
      }));
    }
    removeObserver(e) {
      this.#t = this.#t.filter(t => t !== e), this.scheduleGc(), this.#n.notify({
        type: "observerRemoved",
        mutation: this,
        observer: e
      });
    }
    optionalRemove() {
      this.#t.length || (this.state.status === "pending" ? this.scheduleGc() : this.#n.remove(this));
    }
    continue() {
      return this.#s?.continue() ?? this.execute(this.state.variables);
    }
    async execute(e) {
      const t = () => {
          this.#o({
            type: "continue"
          });
        },
        n = {
          client: this.#e,
          meta: this.options.meta,
          mutationKey: this.options.mutationKey
        };
      this.#s = r_({
        fn: () => this.options.mutationFn ? this.options.mutationFn(e, n) : Promise.reject(new Error("No mutationFn found")),
        onFail: (a, r) => {
          this.#o({
            type: "failed",
            failureCount: a,
            error: r
          });
        },
        onPause: () => {
          this.#o({
            type: "pause"
          });
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
        if (o) t();else {
          this.#o({
            type: "pending",
            variables: e,
            isPaused: s
          }), await this.#n.config.onMutate?.(e, this, n);
          const r = await this.options.onMutate?.(e, n);
          r !== this.state.context && this.#o({
            type: "pending",
            context: r,
            variables: e,
            isPaused: s
          });
        }
        const a = await this.#s.start();
        return await this.#n.config.onSuccess?.(a, e, this.state.context, this, n), await this.options.onSuccess?.(a, e, this.state.context, n), await this.#n.config.onSettled?.(a, null, this.state.variables, this.state.context, this, n), await this.options.onSettled?.(a, null, e, this.state.context, n), this.#o({
          type: "success",
          data: a
        }), a;
      } catch (a) {
        try {
          throw await this.#n.config.onError?.(a, e, this.state.context, this, n), await this.options.onError?.(a, e, this.state.context, n), await this.#n.config.onSettled?.(void 0, a, this.state.variables, this.state.context, this, n), await this.options.onSettled?.(void 0, a, e, this.state.context, n), a;
        } finally {
          this.#o({
            type: "error",
            error: a
          });
        }
      } finally {
        this.#n.runNext(this);
      }
    }
    #o(e) {
      const t = n => {
        switch (e.type) {
          case "failed":
            return {
              ...n,
              failureCount: e.failureCount,
              failureReason: e.error
            };
          case "pause":
            return {
              ...n,
              isPaused: !0
            };
          case "continue":
            return {
              ...n,
              isPaused: !1
            };
          case "pending":
            return {
              ...n,
              context: e.context,
              data: void 0,
              failureCount: 0,
              failureReason: null,
              error: null,
              isPaused: e.isPaused,
              status: "pending",
              variables: e.variables,
              submittedAt: Date.now()
            };
          case "success":
            return {
              ...n,
              data: e.data,
              failureCount: 0,
              failureReason: null,
              error: null,
              status: "success",
              isPaused: !1
            };
          case "error":
            return {
              ...n,
              data: void 0,
              error: e.error,
              failureCount: n.failureCount + 1,
              failureReason: e.error,
              isPaused: !1,
              status: "error"
            };
        }
      };
      this.state = t(this.state), Rt.batch(() => {
        this.#t.forEach(n => {
          n.onMutationUpdate(e);
        }), this.#n.notify({
          mutation: this,
          type: "updated",
          action: e
        });
      });
    }
  };
  function h_() {
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
    };
  }
  var v_ = class extends as {
    constructor(t = {}) {
      super(), this.config = t, this.#e = new Set(), this.#t = new Map(), this.#n = 0;
    }
    #e;
    #t;
    #n;
    build(t, n, o) {
      const s = new LD({
        client: t,
        mutationCache: this,
        mutationId: ++this.#n,
        options: t.defaultMutationOptions(n),
        state: o
      });
      return this.add(s), s;
    }
    add(t) {
      this.#e.add(t);
      const n = fi(t);
      if (typeof n == "string") {
        const o = this.#t.get(n);
        o ? o.push(t) : this.#t.set(n, [t]);
      }
      this.notify({
        type: "added",
        mutation: t
      });
    }
    remove(t) {
      if (this.#e.delete(t)) {
        const n = fi(t);
        if (typeof n == "string") {
          const o = this.#t.get(n);
          if (o) if (o.length > 1) {
            const s = o.indexOf(t);
            s !== -1 && o.splice(s, 1);
          } else o[0] === t && this.#t.delete(n);
        }
      }
      this.notify({
        type: "removed",
        mutation: t
      });
    }
    canRun(t) {
      const n = fi(t);
      if (typeof n == "string") {
        const s = this.#t.get(n)?.find(a => a.state.status === "pending");
        return !s || s === t;
      } else return !0;
    }
    runNext(t) {
      const n = fi(t);
      return typeof n == "string" ? this.#t.get(n)?.find(s => s !== t && s.state.isPaused)?.continue() ?? Promise.resolve() : Promise.resolve();
    }
    clear() {
      Rt.batch(() => {
        this.#e.forEach(t => {
          this.notify({
            type: "removed",
            mutation: t
          });
        }), this.#e.clear(), this.#t.clear();
      });
    }
    getAll() {
      return Array.from(this.#e);
    }
    find(t) {
      const n = {
        exact: !0,
        ...t
      };
      return this.getAll().find(o => n_(n, o));
    }
    findAll(t = {}) {
      return this.getAll().filter(n => n_(t, n));
    }
    notify(t) {
      Rt.batch(() => {
        this.listeners.forEach(n => {
          n(t);
        });
      });
    }
    resumePausedMutations() {
      const t = this.getAll().filter(n => n.state.isPaused);
      return Rt.batch(() => Promise.all(t.map(n => n.continue().catch(nn))));
    }
  };
  function fi(e) {
    return e.options.scope?.id;
  }
  var kD = class extends as {
      #e;
      #t = void 0;
      #n;
      #s;
      constructor(e, t) {
        super(), this.#e = e, this.setOptions(t), this.bindMethods(), this.#o();
      }
      bindMethods() {
        this.mutate = this.mutate.bind(this), this.reset = this.reset.bind(this);
      }
      setOptions(e) {
        const t = this.options;
        this.options = this.#e.defaultMutationOptions(e), ui(this.options, t) || this.#e.getMutationCache().notify({
          type: "observerOptionsUpdated",
          mutation: this.#n,
          observer: this
        }), t?.mutationKey && this.options.mutationKey && Ao(t.mutationKey) !== Ao(this.options.mutationKey) ? this.reset() : this.#n?.state.status === "pending" && this.#n.setOptions(this.options);
      }
      onUnsubscribe() {
        this.hasListeners() || this.#n?.removeObserver(this);
      }
      onMutationUpdate(e) {
        this.#o(), this.#i(e);
      }
      getCurrentResult() {
        return this.#t;
      }
      reset() {
        this.#n?.removeObserver(this), this.#n = void 0, this.#o(), this.#i();
      }
      mutate(e, t) {
        return this.#s = t, this.#n?.removeObserver(this), this.#n = this.#e.getMutationCache().build(this.#e, this.options), this.#n.addObserver(this), this.#n.execute(e);
      }
      #o() {
        const e = this.#n?.state ?? h_();
        this.#t = {
          ...e,
          isPending: e.status === "pending",
          isSuccess: e.status === "success",
          isError: e.status === "error",
          isIdle: e.status === "idle",
          mutate: this.mutate,
          reset: this.reset
        };
      }
      #i(e) {
        Rt.batch(() => {
          if (this.#s && this.hasListeners()) {
            const t = this.#t.variables,
              n = this.#t.context,
              o = {
                client: this.#e,
                meta: this.options.meta,
                mutationKey: this.options.mutationKey
              };
            e?.type === "success" ? (this.#s.onSuccess?.(e.data, t, n, o), this.#s.onSettled?.(e.data, null, t, n, o)) : e?.type === "error" && (this.#s.onError?.(e.error, t, n, o), this.#s.onSettled?.(void 0, e.error, t, n, o));
          }
          this.listeners.forEach(t => {
            t(this.#t);
          });
        });
      }
    },
    m_ = class extends as {
      constructor(t = {}) {
        super(), this.config = t, this.#e = new Map();
      }
      #e;
      build(t, n, o) {
        const s = n.queryKey,
          a = n.queryHash ?? tl(s, n);
        let r = this.get(a);
        return r || (r = new RD({
          client: t,
          queryKey: s,
          queryHash: a,
          options: t.defaultQueryOptions(n),
          state: o,
          defaultOptions: t.getQueryDefaults(s)
        }), this.add(r)), r;
      }
      add(t) {
        this.#e.has(t.queryHash) || (this.#e.set(t.queryHash, t), this.notify({
          type: "added",
          query: t
        }));
      }
      remove(t) {
        const n = this.#e.get(t.queryHash);
        n && (t.destroy(), n === t && this.#e.delete(t.queryHash), this.notify({
          type: "removed",
          query: t
        }));
      }
      clear() {
        Rt.batch(() => {
          this.getAll().forEach(t => {
            this.remove(t);
          });
        });
      }
      get(t) {
        return this.#e.get(t);
      }
      getAll() {
        return [...this.#e.values()];
      }
      find(t) {
        const n = {
          exact: !0,
          ...t
        };
        return this.getAll().find(o => t_(n, o));
      }
      findAll(t = {}) {
        const n = this.getAll();
        return Object.keys(t).length > 0 ? n.filter(o => t_(t, o)) : n;
      }
      notify(t) {
        Rt.batch(() => {
          this.listeners.forEach(n => {
            n(t);
          });
        });
      }
      onFocus() {
        Rt.batch(() => {
          this.getAll().forEach(t => {
            t.onFocus();
          });
        });
      }
      onOnline() {
        Rt.batch(() => {
          this.getAll().forEach(t => {
            t.onOnline();
          });
        });
      }
    },
    $D = class {
      #e;
      #t;
      #n;
      #s;
      #o;
      #i;
      #r;
      #a;
      constructor(t = {}) {
        this.#e = t.queryCache || new m_(), this.#t = t.mutationCache || new v_(), this.#n = t.defaultOptions || {}, this.#s = new Map(), this.#o = new Map(), this.#i = 0;
      }
      mount() {
        this.#i++, this.#i === 1 && (this.#r = il.subscribe(async t => {
          t && (await this.resumePausedMutations(), this.#e.onFocus());
        }), this.#a = di.subscribe(async t => {
          t && (await this.resumePausedMutations(), this.#e.onOnline());
        }));
      }
      unmount() {
        this.#i--, this.#i === 0 && (this.#r?.(), this.#r = void 0, this.#a?.(), this.#a = void 0);
      }
      isFetching(t) {
        return this.#e.findAll({
          ...t,
          fetchStatus: "fetching"
        }).length;
      }
      isMutating(t) {
        return this.#t.findAll({
          ...t,
          status: "pending"
        }).length;
      }
      getQueryData(t) {
        const n = this.defaultQueryOptions({
          queryKey: t
        });
        return this.#e.get(n.queryHash)?.state.data;
      }
      ensureQueryData(t) {
        const n = this.defaultQueryOptions(t),
          o = this.#e.build(this, n),
          s = o.state.data;
        return s === void 0 ? this.fetchQuery(t) : (t.revalidateIfStale && o.isStaleByTime(ao(n.staleTime, o)) && this.prefetchQuery(n), Promise.resolve(s));
      }
      getQueriesData(t) {
        return this.#e.findAll(t).map(({
          queryKey: n,
          state: o
        }) => {
          const s = o.data;
          return [n, s];
        });
      }
      setQueryData(t, n, o) {
        const s = this.defaultQueryOptions({
            queryKey: t
          }),
          r = this.#e.get(s.queryHash)?.state.data,
          i = CD(n, r);
        if (i !== void 0) return this.#e.build(this, s).setData(i, {
          ...o,
          manual: !0
        });
      }
      setQueriesData(t, n, o) {
        return Rt.batch(() => this.#e.findAll(t).map(({
          queryKey: s
        }) => [s, this.setQueryData(s, n, o)]));
      }
      getQueryState(t) {
        const n = this.defaultQueryOptions({
          queryKey: t
        });
        return this.#e.get(n.queryHash)?.state;
      }
      removeQueries(t) {
        const n = this.#e;
        Rt.batch(() => {
          n.findAll(t).forEach(o => {
            n.remove(o);
          });
        });
      }
      resetQueries(t, n) {
        const o = this.#e;
        return Rt.batch(() => (o.findAll(t).forEach(s => {
          s.reset();
        }), this.refetchQueries({
          type: "active",
          ...t
        }, n)));
      }
      cancelQueries(t, n = {}) {
        const o = {
            revert: !0,
            ...n
          },
          s = Rt.batch(() => this.#e.findAll(t).map(a => a.cancel(o)));
        return Promise.all(s).then(nn).catch(nn);
      }
      invalidateQueries(t, n = {}) {
        return Rt.batch(() => (this.#e.findAll(t).forEach(o => {
          o.invalidate();
        }), t?.refetchType === "none" ? Promise.resolve() : this.refetchQueries({
          ...t,
          type: t?.refetchType ?? t?.type ?? "active"
        }, n)));
      }
      refetchQueries(t, n = {}) {
        const o = {
            ...n,
            cancelRefetch: n.cancelRefetch ?? !0
          },
          s = Rt.batch(() => this.#e.findAll(t).filter(a => !a.isDisabled() && !a.isStatic()).map(a => {
            let r = a.fetch(void 0, o);
            return o.throwOnError || (r = r.catch(nn)), a.state.fetchStatus === "paused" ? Promise.resolve() : r;
          }));
        return Promise.all(s).then(nn);
      }
      fetchQuery(t) {
        const n = this.defaultQueryOptions(t);
        n.retry === void 0 && (n.retry = !1);
        const o = this.#e.build(this, n);
        return o.isStaleByTime(ao(n.staleTime, o)) ? o.fetch(n) : Promise.resolve(o.state.data);
      }
      prefetchQuery(t) {
        return this.fetchQuery(t).then(nn).catch(nn);
      }
      fetchInfiniteQuery(t) {
        return t.behavior = p_(t.pages), this.fetchQuery(t);
      }
      prefetchInfiniteQuery(t) {
        return this.fetchInfiniteQuery(t).then(nn).catch(nn);
      }
      ensureInfiniteQueryData(t) {
        return t.behavior = p_(t.pages), this.ensureQueryData(t);
      }
      resumePausedMutations() {
        return di.isOnline() ? this.#t.resumePausedMutations() : Promise.resolve();
      }
      getQueryCache() {
        return this.#e;
      }
      getMutationCache() {
        return this.#t;
      }
      getDefaultOptions() {
        return this.#n;
      }
      setDefaultOptions(t) {
        this.#n = t;
      }
      setQueryDefaults(t, n) {
        this.#s.set(Ao(t), {
          queryKey: t,
          defaultOptions: n
        });
      }
      getQueryDefaults(t) {
        const n = [...this.#s.values()],
          o = {};
        return n.forEach(s => {
          qs(t, s.queryKey) && Object.assign(o, s.defaultOptions);
        }), o;
      }
      setMutationDefaults(t, n) {
        this.#o.set(Ao(t), {
          mutationKey: t,
          defaultOptions: n
        });
      }
      getMutationDefaults(t) {
        const n = [...this.#o.values()],
          o = {};
        return n.forEach(s => {
          qs(t, s.mutationKey) && Object.assign(o, s.defaultOptions);
        }), o;
      }
      defaultQueryOptions(t) {
        if (t._defaulted) return t;
        const n = {
          ...this.#n.queries,
          ...this.getQueryDefaults(t.queryKey),
          ...t,
          _defaulted: !0
        };
        return n.queryHash || (n.queryHash = tl(n.queryKey, n)), n.refetchOnReconnect === void 0 && (n.refetchOnReconnect = n.networkMode !== "always"), n.throwOnError === void 0 && (n.throwOnError = !!n.suspense), !n.networkMode && n.persister && (n.networkMode = "offlineFirst"), n.queryFn === ci && (n.enabled = !1), n;
      }
      defaultMutationOptions(t) {
        return t?._defaulted ? t : {
          ...this.#n.mutations,
          ...(t?.mutationKey && this.getMutationDefaults(t.mutationKey)),
          ...t,
          _defaulted: !0
        };
      }
      clear() {
        this.#e.clear(), this.#t.clear();
      }
    },
    FD = "VUE_QUERY_CLIENT";
  function C_(e) {
    const t = e ? `:${e}` : "";
    return `${FD}${t}`;
  }
  function dl(e, t) {
    Object.keys(e).forEach(n => {
      e[n] = t[n];
    });
  }
  function fl(e, t, n = "", o = 0) {
    if (t) {
      const s = t(e, n, o);
      if (s === void 0 && tt(e) || s !== void 0) return s;
    }
    if (Array.isArray(e)) return e.map((s, a) => fl(s, t, String(a), o + 1));
    if (typeof e == "object" && BD(e)) {
      const s = Object.entries(e).map(([a, r]) => [a, fl(r, t, a, o + 1)]);
      return Object.fromEntries(s);
    }
    return e;
  }
  function UD(e, t) {
    return fl(e, t);
  }
  function He(e, t = !1) {
    return UD(e, (n, o, s) => {
      if (s === 1 && o === "queryKey") return He(n, !0);
      if (t && xD(n)) return He(n(), t);
      if (tt(n)) return He(y(n), t);
    });
  }
  function BD(e) {
    if (Object.prototype.toString.call(e) !== "[object Object]") return !1;
    const t = Object.getPrototypeOf(e);
    return t === null || t === Object.prototype;
  }
  function xD(e) {
    return typeof e == "function";
  }
  function T_(e = "") {
    if (!Qc()) throw new Error("vue-query hooks can only be used inside setup() function or functions that support injection context.");
    const t = C_(e),
      n = Te(t);
    if (!n) throw new Error("No 'queryClient' found in Vue context, use 'VueQueryPlugin' to properly initialize the library.");
    return n;
  }
  var HD = class extends m_ {
      find(e) {
        return super.find(He(e));
      }
      findAll(e = {}) {
        return super.findAll(He(e));
      }
    },
    GD = class extends v_ {
      find(e) {
        return super.find(He(e));
      }
      findAll(e = {}) {
        return super.findAll(He(e));
      }
    },
    WD = class extends $D {
      constructor(e = {}) {
        const t = {
          defaultOptions: e.defaultOptions,
          queryCache: e.queryCache || new HD(),
          mutationCache: e.mutationCache || new GD()
        };
        super(t), this.isRestoring = H(!1);
      }
      isFetching(e = {}) {
        return super.isFetching(He(e));
      }
      isMutating(e = {}) {
        return super.isMutating(He(e));
      }
      getQueryData(e) {
        return super.getQueryData(He(e));
      }
      ensureQueryData(e) {
        return super.ensureQueryData(He(e));
      }
      getQueriesData(e) {
        return super.getQueriesData(He(e));
      }
      setQueryData(e, t, n = {}) {
        return super.setQueryData(He(e), t, He(n));
      }
      setQueriesData(e, t, n = {}) {
        return super.setQueriesData(He(e), t, He(n));
      }
      getQueryState(e) {
        return super.getQueryState(He(e));
      }
      removeQueries(e = {}) {
        return super.removeQueries(He(e));
      }
      resetQueries(e = {}, t = {}) {
        return super.resetQueries(He(e), He(t));
      }
      cancelQueries(e = {}, t = {}) {
        return super.cancelQueries(He(e), He(t));
      }
      invalidateQueries(e = {}, t = {}) {
        const n = He(e),
          o = He(t);
        if (super.invalidateQueries({
          ...n,
          refetchType: "none"
        }, o), n.refetchType === "none") return Promise.resolve();
        const s = {
          ...n,
          type: n.refetchType ?? n.type ?? "active"
        };
        return Ho().then(() => super.refetchQueries(s, o));
      }
      refetchQueries(e = {}, t = {}) {
        return super.refetchQueries(He(e), He(t));
      }
      fetchQuery(e) {
        return super.fetchQuery(He(e));
      }
      prefetchQuery(e) {
        return super.prefetchQuery(He(e));
      }
      fetchInfiniteQuery(e) {
        return super.fetchInfiniteQuery(He(e));
      }
      prefetchInfiniteQuery(e) {
        return super.prefetchInfiniteQuery(He(e));
      }
      setDefaultOptions(e) {
        super.setDefaultOptions(He(e));
      }
      setQueryDefaults(e, t) {
        super.setQueryDefaults(He(e), He(t));
      }
      getQueryDefaults(e) {
        return super.getQueryDefaults(He(e));
      }
      setMutationDefaults(e, t) {
        super.setMutationDefaults(He(e), He(t));
      }
      getMutationDefaults(e) {
        return super.getMutationDefaults(He(e));
      }
    },
    VD = {
      install: (e, t = {}) => {
        const n = C_(t.queryClientKey);
        let o;
        if ("queryClient" in t && t.queryClient) o = t.queryClient;else {
          const r = "queryClientConfig" in t ? t.queryClientConfig : void 0;
          o = new WD(r);
        }
        No || o.mount();
        let s = () => {};
        if (t.clientPersister) {
          o.isRestoring && (o.isRestoring.value = !0);
          const [r, i] = t.clientPersister(o);
          s = r, i.then(() => {
            o.isRestoring && (o.isRestoring.value = !1), t.clientPersisterOnSuccess?.(o);
          });
        }
        const a = () => {
          o.unmount(), s();
        };
        if (e.onUnmount) e.onUnmount(a);else {
          const r = e.unmount;
          e.unmount = function () {
            a(), r();
          };
        }
        e.provide(n, o);
      }
    };
  function jD(e, t, n) {
    const o = T_(),
      s = b(() => {
        const f = He(t);
        typeof f.enabled == "function" && (f.enabled = f.enabled());
        const v = o.defaultQueryOptions(f);
        return v._optimisticResults = o.isRestoring?.value ? "isRestoring" : "optimistic", v;
      }),
      a = new e(o, s.value),
      r = s.value.shallow ? ji(a.getCurrentResult()) : Xe(a.getCurrentResult());
    let i = () => {};
    o.isRestoring && U(o.isRestoring, f => {
      f || (i(), i = a.subscribe(v => {
        dl(r, v);
      }));
    }, {
      immediate: !0
    });
    const l = () => {
      a.setOptions(s.value), dl(r, a.getCurrentResult());
    };
    U(s, l), Li(() => {
      i();
    });
    const u = (...f) => (l(), r.refetch(...f)),
      c = () => new Promise((f, v) => {
        let h = () => {};
        const m = () => {
          if (s.value.enabled !== !1) {
            a.setOptions(s.value);
            const D = a.getOptimisticResult(s.value);
            D.isStale ? (h(), a.fetchOptimistic(s.value).then(f, N => {
              al(s.value.throwOnError, [N, a.getCurrentQuery()]) ? v(N) : f(a.getCurrentResult());
            })) : (h(), f(D));
          }
        };
        m(), h = U(s, m);
      });
    U(() => r.error, f => {
      if (r.isError && !r.isFetching && al(s.value.throwOnError, [f, a.getCurrentQuery()])) throw f;
    });
    const d = s.value.shallow ? Zt(r) : Ds(r),
      p = ba(d);
    for (const f in r) typeof r[f] == "function" && (p[f] = r[f]);
    return p.suspense = c, p.refetch = u, p;
  }
  function g_(e, t) {
    return jD(ND, e);
  }
  function y_(e, t) {
    const n = T_(),
      o = b(() => n.defaultMutationOptions(He(e))),
      s = new kD(n, o.value),
      a = o.value.shallow ? ji(s.getCurrentResult()) : Xe(s.getCurrentResult()),
      r = s.subscribe(c => {
        dl(a, c);
      }),
      i = (c, d) => {
        s.mutate(c, d).catch(() => {});
      };
    U(o, () => {
      s.setOptions(o.value);
    }), Li(() => {
      r();
    });
    const l = o.value.shallow ? Zt(a) : Ds(a),
      u = ba(l);
    return U(() => a.error, c => {
      if (c && al(o.value.throwOnError, [c])) throw c;
    }), {
      ...u,
      mutate: i,
      mutateAsync: a.mutate,
      reset: a.reset
    };
  } /*! @license DOMPurify 3.2.6 | (c) Cure53 and other contributors | Released under the Apache license 2.0 and Mozilla Public License 2.0 | github.com/cure53/DOMPurify/blob/3.2.6/LICENSE */
  const {
    entries: D_,
    setPrototypeOf: S_,
    isFrozen: zD,
    getPrototypeOf: KD,
    getOwnPropertyDescriptor: YD
  } = Object;
  let {
      freeze: Wt,
      seal: sn,
      create: P_
    } = Object,
    {
      apply: pl,
      construct: _l
    } = typeof Reflect < "u" && Reflect;
  Wt || (Wt = function (t) {
    return t;
  }), sn || (sn = function (t) {
    return t;
  }), pl || (pl = function (t, n, o) {
    return t.apply(n, o);
  }), _l || (_l = function (t, n) {
    return new t(...n);
  });
  const pi = jt(Array.prototype.forEach),
    QD = jt(Array.prototype.lastIndexOf),
    b_ = jt(Array.prototype.pop),
    Xs = jt(Array.prototype.push),
    qD = jt(Array.prototype.splice),
    _i = jt(String.prototype.toLowerCase),
    hl = jt(String.prototype.toString),
    O_ = jt(String.prototype.match),
    Zs = jt(String.prototype.replace),
    XD = jt(String.prototype.indexOf),
    ZD = jt(String.prototype.trim),
    Cn = jt(Object.prototype.hasOwnProperty),
    Vt = jt(RegExp.prototype.test),
    Js = JD(TypeError);
  function jt(e) {
    return function (t) {
      t instanceof RegExp && (t.lastIndex = 0);
      for (var n = arguments.length, o = new Array(n > 1 ? n - 1 : 0), s = 1; s < n; s++) o[s - 1] = arguments[s];
      return pl(e, t, o);
    };
  }
  function JD(e) {
    return function () {
      for (var t = arguments.length, n = new Array(t), o = 0; o < t; o++) n[o] = arguments[o];
      return _l(e, n);
    };
  }
  function We(e, t) {
    let n = arguments.length > 2 && arguments[2] !== void 0 ? arguments[2] : _i;
    S_ && S_(e, null);
    let o = t.length;
    for (; o--;) {
      let s = t[o];
      if (typeof s == "string") {
        const a = n(s);
        a !== s && (zD(t) || (t[o] = a), s = a);
      }
      e[s] = !0;
    }
    return e;
  }
  function eS(e) {
    for (let t = 0; t < e.length; t++) Cn(e, t) || (e[t] = null);
    return e;
  }
  function Wn(e) {
    const t = P_(null);
    for (const [n, o] of D_(e)) Cn(e, n) && (Array.isArray(o) ? t[n] = eS(o) : o && typeof o == "object" && o.constructor === Object ? t[n] = Wn(o) : t[n] = o);
    return t;
  }
  function ea(e, t) {
    for (; e !== null;) {
      const o = YD(e, t);
      if (o) {
        if (o.get) return jt(o.get);
        if (typeof o.value == "function") return jt(o.value);
      }
      e = KD(e);
    }
    function n() {
      return null;
    }
    return n;
  }
  const E_ = Wt(["a", "abbr", "acronym", "address", "area", "article", "aside", "audio", "b", "bdi", "bdo", "big", "blink", "blockquote", "body", "br", "button", "canvas", "caption", "center", "cite", "code", "col", "colgroup", "content", "data", "datalist", "dd", "decorator", "del", "details", "dfn", "dialog", "dir", "div", "dl", "dt", "element", "em", "fieldset", "figcaption", "figure", "font", "footer", "form", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html", "i", "img", "input", "ins", "kbd", "label", "legend", "li", "main", "map", "mark", "marquee", "menu", "menuitem", "meter", "nav", "nobr", "ol", "optgroup", "option", "output", "p", "picture", "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "section", "select", "shadow", "small", "source", "spacer", "span", "strike", "strong", "style", "sub", "summary", "sup", "table", "tbody", "td", "template", "textarea", "tfoot", "th", "thead", "time", "tr", "track", "tt", "u", "ul", "var", "video", "wbr"]),
    vl = Wt(["svg", "a", "altglyph", "altglyphdef", "altglyphitem", "animatecolor", "animatemotion", "animatetransform", "circle", "clippath", "defs", "desc", "ellipse", "filter", "font", "g", "glyph", "glyphref", "hkern", "image", "line", "lineargradient", "marker", "mask", "metadata", "mpath", "path", "pattern", "polygon", "polyline", "radialgradient", "rect", "stop", "style", "switch", "symbol", "text", "textpath", "title", "tref", "tspan", "view", "vkern"]),
    ml = Wt(["feBlend", "feColorMatrix", "feComponentTransfer", "feComposite", "feConvolveMatrix", "feDiffuseLighting", "feDisplacementMap", "feDistantLight", "feDropShadow", "feFlood", "feFuncA", "feFuncB", "feFuncG", "feFuncR", "feGaussianBlur", "feImage", "feMerge", "feMergeNode", "feMorphology", "feOffset", "fePointLight", "feSpecularLighting", "feSpotLight", "feTile", "feTurbulence"]),
    tS = Wt(["animate", "color-profile", "cursor", "discard", "font-face", "font-face-format", "font-face-name", "font-face-src", "font-face-uri", "foreignobject", "hatch", "hatchpath", "mesh", "meshgradient", "meshpatch", "meshrow", "missing-glyph", "script", "set", "solidcolor", "unknown", "use"]),
    Cl = Wt(["math", "menclose", "merror", "mfenced", "mfrac", "mglyph", "mi", "mlabeledtr", "mmultiscripts", "mn", "mo", "mover", "mpadded", "mphantom", "mroot", "mrow", "ms", "mspace", "msqrt", "mstyle", "msub", "msup", "msubsup", "mtable", "mtd", "mtext", "mtr", "munder", "munderover", "mprescripts"]),
    nS = Wt(["maction", "maligngroup", "malignmark", "mlongdiv", "mscarries", "mscarry", "msgroup", "mstack", "msline", "msrow", "semantics", "annotation", "annotation-xml", "mprescripts", "none"]),
    I_ = Wt(["#text"]),
    R_ = Wt(["accept", "action", "align", "alt", "autocapitalize", "autocomplete", "autopictureinpicture", "autoplay", "background", "bgcolor", "border", "capture", "cellpadding", "cellspacing", "checked", "cite", "class", "clear", "color", "cols", "colspan", "controls", "controlslist", "coords", "crossorigin", "datetime", "decoding", "default", "dir", "disabled", "disablepictureinpicture", "disableremoteplayback", "download", "draggable", "enctype", "enterkeyhint", "face", "for", "headers", "height", "hidden", "high", "href", "hreflang", "id", "inputmode", "integrity", "ismap", "kind", "label", "lang", "list", "loading", "loop", "low", "max", "maxlength", "media", "method", "min", "minlength", "multiple", "muted", "name", "nonce", "noshade", "novalidate", "nowrap", "open", "optimum", "pattern", "placeholder", "playsinline", "popover", "popovertarget", "popovertargetaction", "poster", "preload", "pubdate", "radiogroup", "readonly", "rel", "required", "rev", "reversed", "role", "rows", "rowspan", "spellcheck", "scope", "selected", "shape", "size", "sizes", "span", "srclang", "start", "src", "srcset", "step", "style", "summary", "tabindex", "title", "translate", "type", "usemap", "valign", "value", "width", "wrap", "xmlns", "slot"]),
    Tl = Wt(["accent-height", "accumulate", "additive", "alignment-baseline", "amplitude", "ascent", "attributename", "attributetype", "azimuth", "basefrequency", "baseline-shift", "begin", "bias", "by", "class", "clip", "clippathunits", "clip-path", "clip-rule", "color", "color-interpolation", "color-interpolation-filters", "color-profile", "color-rendering", "cx", "cy", "d", "dx", "dy", "diffuseconstant", "direction", "display", "divisor", "dur", "edgemode", "elevation", "end", "exponent", "fill", "fill-opacity", "fill-rule", "filter", "filterunits", "flood-color", "flood-opacity", "font-family", "font-size", "font-size-adjust", "font-stretch", "font-style", "font-variant", "font-weight", "fx", "fy", "g1", "g2", "glyph-name", "glyphref", "gradientunits", "gradienttransform", "height", "href", "id", "image-rendering", "in", "in2", "intercept", "k", "k1", "k2", "k3", "k4", "kerning", "keypoints", "keysplines", "keytimes", "lang", "lengthadjust", "letter-spacing", "kernelmatrix", "kernelunitlength", "lighting-color", "local", "marker-end", "marker-mid", "marker-start", "markerheight", "markerunits", "markerwidth", "maskcontentunits", "maskunits", "max", "mask", "media", "method", "mode", "min", "name", "numoctaves", "offset", "operator", "opacity", "order", "orient", "orientation", "origin", "overflow", "paint-order", "path", "pathlength", "patterncontentunits", "patterntransform", "patternunits", "points", "preservealpha", "preserveaspectratio", "primitiveunits", "r", "rx", "ry", "radius", "refx", "refy", "repeatcount", "repeatdur", "restart", "result", "rotate", "scale", "seed", "shape-rendering", "slope", "specularconstant", "specularexponent", "spreadmethod", "startoffset", "stddeviation", "stitchtiles", "stop-color", "stop-opacity", "stroke-dasharray", "stroke-dashoffset", "stroke-linecap", "stroke-linejoin", "stroke-miterlimit", "stroke-opacity", "stroke", "stroke-width", "style", "surfacescale", "systemlanguage", "tabindex", "tablevalues", "targetx", "targety", "transform", "transform-origin", "text-anchor", "text-decoration", "text-rendering", "textlength", "type", "u1", "u2", "unicode", "values", "viewbox", "visibility", "version", "vert-adv-y", "vert-origin-x", "vert-origin-y", "width", "word-spacing", "wrap", "writing-mode", "xchannelselector", "ychannelselector", "x", "x1", "x2", "xmlns", "y", "y1", "y2", "z", "zoomandpan"]),
    N_ = Wt(["accent", "accentunder", "align", "bevelled", "close", "columnsalign", "columnlines", "columnspan", "denomalign", "depth", "dir", "display", "displaystyle", "encoding", "fence", "frame", "height", "href", "id", "largeop", "length", "linethickness", "lspace", "lquote", "mathbackground", "mathcolor", "mathsize", "mathvariant", "maxsize", "minsize", "movablelimits", "notation", "numalign", "open", "rowalign", "rowlines", "rowspacing", "rowspan", "rspace", "rquote", "scriptlevel", "scriptminsize", "scriptsizemultiplier", "selection", "separator", "separators", "stretchy", "subscriptshift", "supscriptshift", "symmetric", "voffset", "width", "xmlns"]),
    hi = Wt(["xlink:href", "xml:id", "xlink:title", "xml:space", "xmlns:xlink"]),
    oS = sn(/\{\{[\w\W]*|[\w\W]*\}\}/gm),
    sS = sn(/<%[\w\W]*|[\w\W]*%>/gm),
    aS = sn(/\$\{[\w\W]*/gm),
    iS = sn(/^data-[\-\w.\u00B7-\uFFFF]+$/),
    rS = sn(/^aria-[\-\w]+$/),
    A_ = sn(/^(?:(?:(?:f|ht)tps?|mailto|tel|callto|sms|cid|xmpp|matrix):|[^a-z]|[a-z+.\-]+(?:[^a-z+.\-:]|$))/i),
    lS = sn(/^(?:\w+script|data):/i),
    uS = sn(/[\u0000-\u0020\u00A0\u1680\u180E\u2000-\u2029\u205F\u3000]/g),
    M_ = sn(/^html$/i),
    cS = sn(/^[a-z][.\w]*(-[.\w]+)+$/i);
  var w_ = Object.freeze({
    __proto__: null,
    ARIA_ATTR: rS,
    ATTR_WHITESPACE: uS,
    CUSTOM_ELEMENT: cS,
    DATA_ATTR: iS,
    DOCTYPE_NAME: M_,
    ERB_EXPR: sS,
    IS_ALLOWED_URI: A_,
    IS_SCRIPT_OR_DATA: lS,
    MUSTACHE_EXPR: oS,
    TMPLIT_EXPR: aS
  });
  const ta = {
      element: 1,
      text: 3,
      progressingInstruction: 7,
      comment: 8,
      document: 9
    },
    dS = function () {
      return typeof window > "u" ? null : window;
    },
    fS = function (t, n) {
      if (typeof t != "object" || typeof t.createPolicy != "function") return null;
      let o = null;
      const s = "data-tt-policy-suffix";
      n && n.hasAttribute(s) && (o = n.getAttribute(s));
      const a = "dompurify" + (o ? "#" + o : "");
      try {
        return t.createPolicy(a, {
          createHTML(r) {
            return r;
          },
          createScriptURL(r) {
            return r;
          }
        });
      } catch {
        return console.warn("TrustedTypes policy " + a + " could not be created."), null;
      }
    },
    L_ = function () {
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
      };
    };
  function k_() {
    let e = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : dS();
    const t = Ae => k_(Ae);
    if (t.version = "3.2.6", t.removed = [], !e || !e.document || e.document.nodeType !== ta.document || !e.Element) return t.isSupported = !1, t;
    let {
      document: n
    } = e;
    const o = n,
      s = o.currentScript,
      {
        DocumentFragment: a,
        HTMLTemplateElement: r,
        Node: i,
        Element: l,
        NodeFilter: u,
        NamedNodeMap: c = e.NamedNodeMap || e.MozNamedAttrMap,
        HTMLFormElement: d,
        DOMParser: p,
        trustedTypes: f
      } = e,
      v = l.prototype,
      h = ea(v, "cloneNode"),
      m = ea(v, "remove"),
      D = ea(v, "nextSibling"),
      N = ea(v, "childNodes"),
      I = ea(v, "parentNode");
    if (typeof r == "function") {
      const Ae = n.createElement("template");
      Ae.content && Ae.content.ownerDocument && (n = Ae.content.ownerDocument);
    }
    let w,
      A = "";
    const {
        implementation: j,
        createNodeIterator: B,
        createDocumentFragment: T,
        getElementsByTagName: g
      } = n,
      {
        importNode: C
      } = o;
    let S = L_();
    t.isSupported = typeof D_ == "function" && typeof I == "function" && j && j.createHTMLDocument !== void 0;
    const {
      MUSTACHE_EXPR: R,
      ERB_EXPR: E,
      TMPLIT_EXPR: L,
      DATA_ATTR: G,
      ARIA_ATTR: X,
      IS_SCRIPT_OR_DATA: K,
      ATTR_WHITESPACE: de,
      CUSTOM_ELEMENT: be
    } = w_;
    let {
        IS_ALLOWED_URI: xe
      } = w_,
      ee = null;
    const M = We({}, [...E_, ...vl, ...ml, ...Cl, ...I_]);
    let k = null;
    const W = We({}, [...R_, ...Tl, ...N_, ...hi]);
    let Q = Object.seal(P_(null, {
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
      ae = null,
      ke = null,
      nt = !0,
      Ze = !0,
      ot = !1,
      ht = !0,
      ft = !1,
      $ = !0,
      x = !1,
      Z = !1,
      pe = !1,
      le = !1,
      se = !1,
      me = !1,
      ye = !0,
      ge = !1;
    const _e = "user-content-";
    let ie = !0,
      Pe = !1,
      Oe = {},
      Me = null;
    const Ue = We({}, ["annotation-xml", "audio", "colgroup", "desc", "foreignobject", "head", "iframe", "math", "mi", "mn", "mo", "ms", "mtext", "noembed", "noframes", "noscript", "plaintext", "script", "style", "svg", "template", "thead", "title", "video", "xmp"]);
    let Qe = null;
    const qe = We({}, ["audio", "video", "img", "source", "image", "track"]);
    let vt = null;
    const yt = We({}, ["alt", "class", "for", "id", "label", "name", "pattern", "placeholder", "role", "summary", "title", "value", "style", "xmlns"]),
      Ot = "http://www.w3.org/1998/Math/MathML",
      Nt = "http://www.w3.org/2000/svg",
      Dt = "http://www.w3.org/1999/xhtml";
    let zt = Dt,
      rt = !1,
      At = null;
    const te = We({}, [Ot, Nt, Dt], hl);
    let ue = We({}, ["mi", "mo", "mn", "ms", "mtext"]),
      De = We({}, ["annotation-xml"]);
    const Fe = We({}, ["title", "style", "font", "a", "script"]);
    let Ge = null;
    const un = ["application/xhtml+xml", "text/html"],
      cs = "text/html";
    let Et = null,
      ds = null;
    const gw = n.createElement("form"),
      _v = function (z) {
        return z instanceof RegExp || z instanceof Function;
      },
      Nu = function () {
        let z = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
        if (!(ds && ds === z)) {
          if ((!z || typeof z != "object") && (z = {}), z = Wn(z), Ge = un.indexOf(z.PARSER_MEDIA_TYPE) === -1 ? cs : z.PARSER_MEDIA_TYPE, Et = Ge === "application/xhtml+xml" ? hl : _i, ee = Cn(z, "ALLOWED_TAGS") ? We({}, z.ALLOWED_TAGS, Et) : M, k = Cn(z, "ALLOWED_ATTR") ? We({}, z.ALLOWED_ATTR, Et) : W, At = Cn(z, "ALLOWED_NAMESPACES") ? We({}, z.ALLOWED_NAMESPACES, hl) : te, vt = Cn(z, "ADD_URI_SAFE_ATTR") ? We(Wn(yt), z.ADD_URI_SAFE_ATTR, Et) : yt, Qe = Cn(z, "ADD_DATA_URI_TAGS") ? We(Wn(qe), z.ADD_DATA_URI_TAGS, Et) : qe, Me = Cn(z, "FORBID_CONTENTS") ? We({}, z.FORBID_CONTENTS, Et) : Ue, ae = Cn(z, "FORBID_TAGS") ? We({}, z.FORBID_TAGS, Et) : Wn({}), ke = Cn(z, "FORBID_ATTR") ? We({}, z.FORBID_ATTR, Et) : Wn({}), Oe = Cn(z, "USE_PROFILES") ? z.USE_PROFILES : !1, nt = z.ALLOW_ARIA_ATTR !== !1, Ze = z.ALLOW_DATA_ATTR !== !1, ot = z.ALLOW_UNKNOWN_PROTOCOLS || !1, ht = z.ALLOW_SELF_CLOSE_IN_ATTR !== !1, ft = z.SAFE_FOR_TEMPLATES || !1, $ = z.SAFE_FOR_XML !== !1, x = z.WHOLE_DOCUMENT || !1, le = z.RETURN_DOM || !1, se = z.RETURN_DOM_FRAGMENT || !1, me = z.RETURN_TRUSTED_TYPE || !1, pe = z.FORCE_BODY || !1, ye = z.SANITIZE_DOM !== !1, ge = z.SANITIZE_NAMED_PROPS || !1, ie = z.KEEP_CONTENT !== !1, Pe = z.IN_PLACE || !1, xe = z.ALLOWED_URI_REGEXP || A_, zt = z.NAMESPACE || Dt, ue = z.MATHML_TEXT_INTEGRATION_POINTS || ue, De = z.HTML_INTEGRATION_POINTS || De, Q = z.CUSTOM_ELEMENT_HANDLING || {}, z.CUSTOM_ELEMENT_HANDLING && _v(z.CUSTOM_ELEMENT_HANDLING.tagNameCheck) && (Q.tagNameCheck = z.CUSTOM_ELEMENT_HANDLING.tagNameCheck), z.CUSTOM_ELEMENT_HANDLING && _v(z.CUSTOM_ELEMENT_HANDLING.attributeNameCheck) && (Q.attributeNameCheck = z.CUSTOM_ELEMENT_HANDLING.attributeNameCheck), z.CUSTOM_ELEMENT_HANDLING && typeof z.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements == "boolean" && (Q.allowCustomizedBuiltInElements = z.CUSTOM_ELEMENT_HANDLING.allowCustomizedBuiltInElements), ft && (Ze = !1), se && (le = !0), Oe && (ee = We({}, I_), k = [], Oe.html === !0 && (We(ee, E_), We(k, R_)), Oe.svg === !0 && (We(ee, vl), We(k, Tl), We(k, hi)), Oe.svgFilters === !0 && (We(ee, ml), We(k, Tl), We(k, hi)), Oe.mathMl === !0 && (We(ee, Cl), We(k, N_), We(k, hi))), z.ADD_TAGS && (ee === M && (ee = Wn(ee)), We(ee, z.ADD_TAGS, Et)), z.ADD_ATTR && (k === W && (k = Wn(k)), We(k, z.ADD_ATTR, Et)), z.ADD_URI_SAFE_ATTR && We(vt, z.ADD_URI_SAFE_ATTR, Et), z.FORBID_CONTENTS && (Me === Ue && (Me = Wn(Me)), We(Me, z.FORBID_CONTENTS, Et)), ie && (ee["#text"] = !0), x && We(ee, ["html", "head", "body"]), ee.table && (We(ee, ["tbody"]), delete ae.tbody), z.TRUSTED_TYPES_POLICY) {
            if (typeof z.TRUSTED_TYPES_POLICY.createHTML != "function") throw Js('TRUSTED_TYPES_POLICY configuration option must provide a "createHTML" hook.');
            if (typeof z.TRUSTED_TYPES_POLICY.createScriptURL != "function") throw Js('TRUSTED_TYPES_POLICY configuration option must provide a "createScriptURL" hook.');
            w = z.TRUSTED_TYPES_POLICY, A = w.createHTML("");
          } else w === void 0 && (w = fS(f, s)), w !== null && typeof A == "string" && (A = w.createHTML(""));
          Wt && Wt(z), ds = z;
        }
      },
      hv = We({}, [...vl, ...ml, ...tS]),
      vv = We({}, [...Cl, ...nS]),
      yw = function (z) {
        let Se = I(z);
        (!Se || !Se.tagName) && (Se = {
          namespaceURI: zt,
          tagName: "template"
        });
        const Re = _i(z.tagName),
          lt = _i(Se.tagName);
        return At[z.namespaceURI] ? z.namespaceURI === Nt ? Se.namespaceURI === Dt ? Re === "svg" : Se.namespaceURI === Ot ? Re === "svg" && (lt === "annotation-xml" || ue[lt]) : !!hv[Re] : z.namespaceURI === Ot ? Se.namespaceURI === Dt ? Re === "math" : Se.namespaceURI === Nt ? Re === "math" && De[lt] : !!vv[Re] : z.namespaceURI === Dt ? Se.namespaceURI === Nt && !De[lt] || Se.namespaceURI === Ot && !ue[lt] ? !1 : !vv[Re] && (Fe[Re] || !hv[Re]) : !!(Ge === "application/xhtml+xml" && At[z.namespaceURI]) : !1;
      },
      Nn = function (z) {
        Xs(t.removed, {
          element: z
        });
        try {
          I(z).removeChild(z);
        } catch {
          m(z);
        }
      },
      fs = function (z, Se) {
        try {
          Xs(t.removed, {
            attribute: Se.getAttributeNode(z),
            from: Se
          });
        } catch {
          Xs(t.removed, {
            attribute: null,
            from: Se
          });
        }
        if (Se.removeAttribute(z), z === "is") if (le || se) try {
          Nn(Se);
        } catch {} else try {
          Se.setAttribute(z, "");
        } catch {}
      },
      mv = function (z) {
        let Se = null,
          Re = null;
        if (pe) z = "<remove></remove>" + z;else {
          const St = O_(z, /^[\r\n\t ]+/);
          Re = St && St[0];
        }
        Ge === "application/xhtml+xml" && zt === Dt && (z = '<html xmlns="http://www.w3.org/1999/xhtml"><head></head><body>' + z + "</body></html>");
        const lt = w ? w.createHTML(z) : z;
        if (zt === Dt) try {
          Se = new p().parseFromString(lt, Ge);
        } catch {}
        if (!Se || !Se.documentElement) {
          Se = j.createDocument(zt, "template", null);
          try {
            Se.documentElement.innerHTML = rt ? A : lt;
          } catch {}
        }
        const $t = Se.body || Se.documentElement;
        return z && Re && $t.insertBefore(n.createTextNode(Re), $t.childNodes[0] || null), zt === Dt ? g.call(Se, x ? "html" : "body")[0] : x ? Se.documentElement : $t;
      },
      Cv = function (z) {
        return B.call(z.ownerDocument || z, z, u.SHOW_ELEMENT | u.SHOW_COMMENT | u.SHOW_TEXT | u.SHOW_PROCESSING_INSTRUCTION | u.SHOW_CDATA_SECTION, null);
      },
      Au = function (z) {
        return z instanceof d && (typeof z.nodeName != "string" || typeof z.textContent != "string" || typeof z.removeChild != "function" || !(z.attributes instanceof c) || typeof z.removeAttribute != "function" || typeof z.setAttribute != "function" || typeof z.namespaceURI != "string" || typeof z.insertBefore != "function" || typeof z.hasChildNodes != "function");
      },
      Tv = function (z) {
        return typeof i == "function" && z instanceof i;
      };
    function Kn(Ae, z, Se) {
      pi(Ae, Re => {
        Re.call(t, z, Se, ds);
      });
    }
    const gv = function (z) {
        let Se = null;
        if (Kn(S.beforeSanitizeElements, z, null), Au(z)) return Nn(z), !0;
        const Re = Et(z.nodeName);
        if (Kn(S.uponSanitizeElement, z, {
          tagName: Re,
          allowedTags: ee
        }), $ && z.hasChildNodes() && !Tv(z.firstElementChild) && Vt(/<[/\w!]/g, z.innerHTML) && Vt(/<[/\w!]/g, z.textContent) || z.nodeType === ta.progressingInstruction || $ && z.nodeType === ta.comment && Vt(/<[/\w]/g, z.data)) return Nn(z), !0;
        if (!ee[Re] || ae[Re]) {
          if (!ae[Re] && Dv(Re) && (Q.tagNameCheck instanceof RegExp && Vt(Q.tagNameCheck, Re) || Q.tagNameCheck instanceof Function && Q.tagNameCheck(Re))) return !1;
          if (ie && !Me[Re]) {
            const lt = I(z) || z.parentNode,
              $t = N(z) || z.childNodes;
            if ($t && lt) {
              const St = $t.length;
              for (let Kt = St - 1; Kt >= 0; --Kt) {
                const Yn = h($t[Kt], !0);
                Yn.__removalCount = (z.__removalCount || 0) + 1, lt.insertBefore(Yn, D(z));
              }
            }
          }
          return Nn(z), !0;
        }
        return z instanceof l && !yw(z) || (Re === "noscript" || Re === "noembed" || Re === "noframes") && Vt(/<\/no(script|embed|frames)/i, z.innerHTML) ? (Nn(z), !0) : (ft && z.nodeType === ta.text && (Se = z.textContent, pi([R, E, L], lt => {
          Se = Zs(Se, lt, " ");
        }), z.textContent !== Se && (Xs(t.removed, {
          element: z.cloneNode()
        }), z.textContent = Se)), Kn(S.afterSanitizeElements, z, null), !1);
      },
      yv = function (z, Se, Re) {
        if (ye && (Se === "id" || Se === "name") && (Re in n || Re in gw)) return !1;
        if (!(Ze && !ke[Se] && Vt(G, Se))) {
          if (!(nt && Vt(X, Se))) {
            if (!k[Se] || ke[Se]) {
              if (!(Dv(z) && (Q.tagNameCheck instanceof RegExp && Vt(Q.tagNameCheck, z) || Q.tagNameCheck instanceof Function && Q.tagNameCheck(z)) && (Q.attributeNameCheck instanceof RegExp && Vt(Q.attributeNameCheck, Se) || Q.attributeNameCheck instanceof Function && Q.attributeNameCheck(Se)) || Se === "is" && Q.allowCustomizedBuiltInElements && (Q.tagNameCheck instanceof RegExp && Vt(Q.tagNameCheck, Re) || Q.tagNameCheck instanceof Function && Q.tagNameCheck(Re)))) return !1;
            } else if (!vt[Se]) {
              if (!Vt(xe, Zs(Re, de, ""))) {
                if (!((Se === "src" || Se === "xlink:href" || Se === "href") && z !== "script" && XD(Re, "data:") === 0 && Qe[z])) {
                  if (!(ot && !Vt(K, Zs(Re, de, "")))) {
                    if (Re) return !1;
                  }
                }
              }
            }
          }
        }
        return !0;
      },
      Dv = function (z) {
        return z !== "annotation-xml" && O_(z, be);
      },
      Sv = function (z) {
        Kn(S.beforeSanitizeAttributes, z, null);
        const {
          attributes: Se
        } = z;
        if (!Se || Au(z)) return;
        const Re = {
          attrName: "",
          attrValue: "",
          keepAttr: !0,
          allowedAttributes: k,
          forceKeepAttr: void 0
        };
        let lt = Se.length;
        for (; lt--;) {
          const $t = Se[lt],
            {
              name: St,
              namespaceURI: Kt,
              value: Yn
            } = $t,
            pa = Et(St),
            Mu = Yn;
          let Ft = St === "value" ? Mu : ZD(Mu);
          if (Re.attrName = pa, Re.attrValue = Ft, Re.keepAttr = !0, Re.forceKeepAttr = void 0, Kn(S.uponSanitizeAttribute, z, Re), Ft = Re.attrValue, ge && (pa === "id" || pa === "name") && (fs(St, z), Ft = _e + Ft), $ && Vt(/((--!?|])>)|<\/(style|title)/i, Ft)) {
            fs(St, z);
            continue;
          }
          if (Re.forceKeepAttr) continue;
          if (!Re.keepAttr) {
            fs(St, z);
            continue;
          }
          if (!ht && Vt(/\/>/i, Ft)) {
            fs(St, z);
            continue;
          }
          ft && pi([R, E, L], bv => {
            Ft = Zs(Ft, bv, " ");
          });
          const Pv = Et(z.nodeName);
          if (!yv(Pv, pa, Ft)) {
            fs(St, z);
            continue;
          }
          if (w && typeof f == "object" && typeof f.getAttributeType == "function" && !Kt) switch (f.getAttributeType(Pv, pa)) {
            case "TrustedHTML":
              {
                Ft = w.createHTML(Ft);
                break;
              }
            case "TrustedScriptURL":
              {
                Ft = w.createScriptURL(Ft);
                break;
              }
          }
          if (Ft !== Mu) try {
            Kt ? z.setAttributeNS(Kt, St, Ft) : z.setAttribute(St, Ft), Au(z) ? Nn(z) : b_(t.removed);
          } catch {
            fs(St, z);
          }
        }
        Kn(S.afterSanitizeAttributes, z, null);
      },
      Dw = function Ae(z) {
        let Se = null;
        const Re = Cv(z);
        for (Kn(S.beforeSanitizeShadowDOM, z, null); Se = Re.nextNode();) Kn(S.uponSanitizeShadowNode, Se, null), gv(Se), Sv(Se), Se.content instanceof a && Ae(Se.content);
        Kn(S.afterSanitizeShadowDOM, z, null);
      };
    return t.sanitize = function (Ae) {
      let z = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : {},
        Se = null,
        Re = null,
        lt = null,
        $t = null;
      if (rt = !Ae, rt && (Ae = "<!-->"), typeof Ae != "string" && !Tv(Ae)) if (typeof Ae.toString == "function") {
        if (Ae = Ae.toString(), typeof Ae != "string") throw Js("dirty is not a string, aborting");
      } else throw Js("toString is not a function");
      if (!t.isSupported) return Ae;
      if (Z || Nu(z), t.removed = [], typeof Ae == "string" && (Pe = !1), Pe) {
        if (Ae.nodeName) {
          const Yn = Et(Ae.nodeName);
          if (!ee[Yn] || ae[Yn]) throw Js("root node is forbidden and cannot be sanitized in-place");
        }
      } else if (Ae instanceof i) Se = mv("<!---->"), Re = Se.ownerDocument.importNode(Ae, !0), Re.nodeType === ta.element && Re.nodeName === "BODY" || Re.nodeName === "HTML" ? Se = Re : Se.appendChild(Re);else {
        if (!le && !ft && !x && Ae.indexOf("<") === -1) return w && me ? w.createHTML(Ae) : Ae;
        if (Se = mv(Ae), !Se) return le ? null : me ? A : "";
      }
      Se && pe && Nn(Se.firstChild);
      const St = Cv(Pe ? Ae : Se);
      for (; lt = St.nextNode();) gv(lt), Sv(lt), lt.content instanceof a && Dw(lt.content);
      if (Pe) return Ae;
      if (le) {
        if (se) for ($t = T.call(Se.ownerDocument); Se.firstChild;) $t.appendChild(Se.firstChild);else $t = Se;
        return (k.shadowroot || k.shadowrootmode) && ($t = C.call(o, $t, !0)), $t;
      }
      let Kt = x ? Se.outerHTML : Se.innerHTML;
      return x && ee["!doctype"] && Se.ownerDocument && Se.ownerDocument.doctype && Se.ownerDocument.doctype.name && Vt(M_, Se.ownerDocument.doctype.name) && (Kt = "<!DOCTYPE " + Se.ownerDocument.doctype.name + `>
` + Kt), ft && pi([R, E, L], Yn => {
        Kt = Zs(Kt, Yn, " ");
      }), w && me ? w.createHTML(Kt) : Kt;
    }, t.setConfig = function () {
      let Ae = arguments.length > 0 && arguments[0] !== void 0 ? arguments[0] : {};
      Nu(Ae), Z = !0;
    }, t.clearConfig = function () {
      ds = null, Z = !1;
    }, t.isValidAttribute = function (Ae, z, Se) {
      ds || Nu({});
      const Re = Et(Ae),
        lt = Et(z);
      return yv(Re, lt, Se);
    }, t.addHook = function (Ae, z) {
      typeof z == "function" && Xs(S[Ae], z);
    }, t.removeHook = function (Ae, z) {
      if (z !== void 0) {
        const Se = QD(S[Ae], z);
        return Se === -1 ? void 0 : qD(S[Ae], Se, 1)[0];
      }
      return b_(S[Ae]);
    }, t.removeHooks = function (Ae) {
      S[Ae] = [];
    }, t.removeAllHooks = function () {
      S = L_();
    }, t;
  }
  var pS = k_();
  function _S(e, t) {
    const n = e.hooks ?? {};
    let o;
    for (o in n) {
      const s = n[o];
      s !== void 0 && t.addHook(o, s);
    }
  }
  function $_() {
    return pS();
  }
  function hS(e = {}, t = $_) {
    const n = t();
    _S(e, n);
    const o = function (r) {
        const i = r.value;
        if (r.oldValue === i) return;
        const l = `${i}`,
          u = r.arg,
          c = e.namedConfigurations,
          d = e.default ?? {};
        return c && u !== void 0 ? n.sanitize(l, c[u] ?? d) : n.sanitize(l, d);
      },
      s = function (r, i) {
        const l = o(i);
        l !== void 0 && (r.innerHTML = l);
      },
      a = {
        mounted: s,
        updated: s
      };
    return e.enableSSRPropsSupport ? {
      ...a,
      getSSRProps(r) {
        return {
          innerHTML: o(r)
        };
      }
    } : a;
  }
  const vS = {
    install(e, t = {}, n = $_) {
      e.directive("dompurify-html", hS(t, n));
    }
  };
  var vi = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {};
  function F_(e) {
    return e && e.__esModule && Object.prototype.hasOwnProperty.call(e, "default") ? e.default : e;
  }
  var gl, U_;
  function mi() {
    if (U_) return gl;
    U_ = 1;
    function e(t) {
      var n = typeof t;
      return t != null && (n == "object" || n == "function");
    }
    return gl = e, gl;
  }
  var yl, B_;
  function x_() {
    if (B_) return yl;
    B_ = 1;
    var e = typeof vi == "object" && vi && vi.Object === Object && vi;
    return yl = e, yl;
  }
  var Dl, H_;
  function Vn() {
    if (H_) return Dl;
    H_ = 1;
    var e = x_(),
      t = typeof self == "object" && self && self.Object === Object && self,
      n = e || t || Function("return this")();
    return Dl = n, Dl;
  }
  var Sl, G_;
  function mS() {
    if (G_) return Sl;
    G_ = 1;
    var e = Vn(),
      t = function () {
        return e.Date.now();
      };
    return Sl = t, Sl;
  }
  var Pl, W_;
  function CS() {
    if (W_) return Pl;
    W_ = 1;
    var e = /\s/;
    function t(n) {
      for (var o = n.length; o-- && e.test(n.charAt(o)););
      return o;
    }
    return Pl = t, Pl;
  }
  var bl, V_;
  function TS() {
    if (V_) return bl;
    V_ = 1;
    var e = CS(),
      t = /^\s+/;
    function n(o) {
      return o && o.slice(0, e(o) + 1).replace(t, "");
    }
    return bl = n, bl;
  }
  var Ol, j_;
  function z_() {
    if (j_) return Ol;
    j_ = 1;
    var e = Vn(),
      t = e.Symbol;
    return Ol = t, Ol;
  }
  var El, K_;
  function gS() {
    if (K_) return El;
    K_ = 1;
    var e = z_(),
      t = Object.prototype,
      n = t.hasOwnProperty,
      o = t.toString,
      s = e ? e.toStringTag : void 0;
    function a(r) {
      var i = n.call(r, s),
        l = r[s];
      try {
        r[s] = void 0;
        var u = !0;
      } catch {}
      var c = o.call(r);
      return u && (i ? r[s] = l : delete r[s]), c;
    }
    return El = a, El;
  }
  var Il, Y_;
  function yS() {
    if (Y_) return Il;
    Y_ = 1;
    var e = Object.prototype,
      t = e.toString;
    function n(o) {
      return t.call(o);
    }
    return Il = n, Il;
  }
  var Rl, Q_;
  function na() {
    if (Q_) return Rl;
    Q_ = 1;
    var e = z_(),
      t = gS(),
      n = yS(),
      o = "[object Null]",
      s = "[object Undefined]",
      a = e ? e.toStringTag : void 0;
    function r(i) {
      return i == null ? i === void 0 ? s : o : a && a in Object(i) ? t(i) : n(i);
    }
    return Rl = r, Rl;
  }
  var Nl, q_;
  function Ci() {
    if (q_) return Nl;
    q_ = 1;
    function e(t) {
      return t != null && typeof t == "object";
    }
    return Nl = e, Nl;
  }
  var Al, X_;
  function DS() {
    if (X_) return Al;
    X_ = 1;
    var e = na(),
      t = Ci(),
      n = "[object Symbol]";
    function o(s) {
      return typeof s == "symbol" || t(s) && e(s) == n;
    }
    return Al = o, Al;
  }
  var Ml, Z_;
  function SS() {
    if (Z_) return Ml;
    Z_ = 1;
    var e = TS(),
      t = mi(),
      n = DS(),
      o = NaN,
      s = /^[-+]0x[0-9a-f]+$/i,
      a = /^0b[01]+$/i,
      r = /^0o[0-7]+$/i,
      i = parseInt;
    function l(u) {
      if (typeof u == "number") return u;
      if (n(u)) return o;
      if (t(u)) {
        var c = typeof u.valueOf == "function" ? u.valueOf() : u;
        u = t(c) ? c + "" : c;
      }
      if (typeof u != "string") return u === 0 ? u : +u;
      u = e(u);
      var d = a.test(u);
      return d || r.test(u) ? i(u.slice(2), d ? 2 : 8) : s.test(u) ? o : +u;
    }
    return Ml = l, Ml;
  }
  var wl, J_;
  function PS() {
    if (J_) return wl;
    J_ = 1;
    var e = mi(),
      t = mS(),
      n = SS(),
      o = "Expected a function",
      s = Math.max,
      a = Math.min;
    function r(i, l, u) {
      var c,
        d,
        p,
        f,
        v,
        h,
        m = 0,
        D = !1,
        N = !1,
        I = !0;
      if (typeof i != "function") throw new TypeError(o);
      l = n(l) || 0, e(u) && (D = !!u.leading, N = "maxWait" in u, p = N ? s(n(u.maxWait) || 0, l) : p, I = "trailing" in u ? !!u.trailing : I);
      function w(E) {
        var L = c,
          G = d;
        return c = d = void 0, m = E, f = i.apply(G, L), f;
      }
      function A(E) {
        return m = E, v = setTimeout(T, l), D ? w(E) : f;
      }
      function j(E) {
        var L = E - h,
          G = E - m,
          X = l - L;
        return N ? a(X, p - G) : X;
      }
      function B(E) {
        var L = E - h,
          G = E - m;
        return h === void 0 || L >= l || L < 0 || N && G >= p;
      }
      function T() {
        var E = t();
        if (B(E)) return g(E);
        v = setTimeout(T, j(E));
      }
      function g(E) {
        return v = void 0, I && c ? w(E) : (c = d = void 0, f);
      }
      function C() {
        v !== void 0 && clearTimeout(v), m = 0, c = h = d = v = void 0;
      }
      function S() {
        return v === void 0 ? f : g(t());
      }
      function R() {
        var E = t(),
          L = B(E);
        if (c = arguments, d = this, h = E, L) {
          if (v === void 0) return A(h);
          if (N) return clearTimeout(v), v = setTimeout(T, l), w(h);
        }
        return v === void 0 && (v = setTimeout(T, l)), f;
      }
      return R.cancel = C, R.flush = S, R;
    }
    return wl = r, wl;
  }
  var bS = PS();
  const an = F_(bS);
  var Ll, eh;
  function th() {
    if (eh) return Ll;
    eh = 1;
    var e = Object.prototype;
    function t(n) {
      var o = n && n.constructor,
        s = typeof o == "function" && o.prototype || e;
      return n === s;
    }
    return Ll = t, Ll;
  }
  var kl, nh;
  function OS() {
    if (nh) return kl;
    nh = 1;
    function e(t, n) {
      return function (o) {
        return t(n(o));
      };
    }
    return kl = e, kl;
  }
  var $l, oh;
  function ES() {
    if (oh) return $l;
    oh = 1;
    var e = OS(),
      t = e(Object.keys, Object);
    return $l = t, $l;
  }
  var Fl, sh;
  function IS() {
    if (sh) return Fl;
    sh = 1;
    var e = th(),
      t = ES(),
      n = Object.prototype,
      o = n.hasOwnProperty;
    function s(a) {
      if (!e(a)) return t(a);
      var r = [];
      for (var i in Object(a)) o.call(a, i) && i != "constructor" && r.push(i);
      return r;
    }
    return Fl = s, Fl;
  }
  var Ul, ah;
  function ih() {
    if (ah) return Ul;
    ah = 1;
    var e = na(),
      t = mi(),
      n = "[object AsyncFunction]",
      o = "[object Function]",
      s = "[object GeneratorFunction]",
      a = "[object Proxy]";
    function r(i) {
      if (!t(i)) return !1;
      var l = e(i);
      return l == o || l == s || l == n || l == a;
    }
    return Ul = r, Ul;
  }
  var Bl, rh;
  function RS() {
    if (rh) return Bl;
    rh = 1;
    var e = Vn(),
      t = e["__core-js_shared__"];
    return Bl = t, Bl;
  }
  var xl, lh;
  function NS() {
    if (lh) return xl;
    lh = 1;
    var e = RS(),
      t = function () {
        var o = /[^.]+$/.exec(e && e.keys && e.keys.IE_PROTO || "");
        return o ? "Symbol(src)_1." + o : "";
      }();
    function n(o) {
      return !!t && t in o;
    }
    return xl = n, xl;
  }
  var Hl, uh;
  function ch() {
    if (uh) return Hl;
    uh = 1;
    var e = Function.prototype,
      t = e.toString;
    function n(o) {
      if (o != null) {
        try {
          return t.call(o);
        } catch {}
        try {
          return o + "";
        } catch {}
      }
      return "";
    }
    return Hl = n, Hl;
  }
  var Gl, dh;
  function AS() {
    if (dh) return Gl;
    dh = 1;
    var e = ih(),
      t = NS(),
      n = mi(),
      o = ch(),
      s = /[\\^$.*+?()[\]{}|]/g,
      a = /^\[object .+?Constructor\]$/,
      r = Function.prototype,
      i = Object.prototype,
      l = r.toString,
      u = i.hasOwnProperty,
      c = RegExp("^" + l.call(u).replace(s, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$");
    function d(p) {
      if (!n(p) || t(p)) return !1;
      var f = e(p) ? c : a;
      return f.test(o(p));
    }
    return Gl = d, Gl;
  }
  var Wl, fh;
  function MS() {
    if (fh) return Wl;
    fh = 1;
    function e(t, n) {
      return t?.[n];
    }
    return Wl = e, Wl;
  }
  var Vl, ph;
  function oa() {
    if (ph) return Vl;
    ph = 1;
    var e = AS(),
      t = MS();
    function n(o, s) {
      var a = t(o, s);
      return e(a) ? a : void 0;
    }
    return Vl = n, Vl;
  }
  var jl, _h;
  function wS() {
    if (_h) return jl;
    _h = 1;
    var e = oa(),
      t = Vn(),
      n = e(t, "DataView");
    return jl = n, jl;
  }
  var zl, hh;
  function LS() {
    if (hh) return zl;
    hh = 1;
    var e = oa(),
      t = Vn(),
      n = e(t, "Map");
    return zl = n, zl;
  }
  var Kl, vh;
  function kS() {
    if (vh) return Kl;
    vh = 1;
    var e = oa(),
      t = Vn(),
      n = e(t, "Promise");
    return Kl = n, Kl;
  }
  var Yl, mh;
  function $S() {
    if (mh) return Yl;
    mh = 1;
    var e = oa(),
      t = Vn(),
      n = e(t, "Set");
    return Yl = n, Yl;
  }
  var Ql, Ch;
  function FS() {
    if (Ch) return Ql;
    Ch = 1;
    var e = oa(),
      t = Vn(),
      n = e(t, "WeakMap");
    return Ql = n, Ql;
  }
  var ql, Th;
  function US() {
    if (Th) return ql;
    Th = 1;
    var e = wS(),
      t = LS(),
      n = kS(),
      o = $S(),
      s = FS(),
      a = na(),
      r = ch(),
      i = "[object Map]",
      l = "[object Object]",
      u = "[object Promise]",
      c = "[object Set]",
      d = "[object WeakMap]",
      p = "[object DataView]",
      f = r(e),
      v = r(t),
      h = r(n),
      m = r(o),
      D = r(s),
      N = a;
    return (e && N(new e(new ArrayBuffer(1))) != p || t && N(new t()) != i || n && N(n.resolve()) != u || o && N(new o()) != c || s && N(new s()) != d) && (N = function (I) {
      var w = a(I),
        A = w == l ? I.constructor : void 0,
        j = A ? r(A) : "";
      if (j) switch (j) {
        case f:
          return p;
        case v:
          return i;
        case h:
          return u;
        case m:
          return c;
        case D:
          return d;
      }
      return w;
    }), ql = N, ql;
  }
  var Xl, gh;
  function BS() {
    if (gh) return Xl;
    gh = 1;
    var e = na(),
      t = Ci(),
      n = "[object Arguments]";
    function o(s) {
      return t(s) && e(s) == n;
    }
    return Xl = o, Xl;
  }
  var Zl, yh;
  function xS() {
    if (yh) return Zl;
    yh = 1;
    var e = BS(),
      t = Ci(),
      n = Object.prototype,
      o = n.hasOwnProperty,
      s = n.propertyIsEnumerable,
      a = e(function () {
        return arguments;
      }()) ? e : function (r) {
        return t(r) && o.call(r, "callee") && !s.call(r, "callee");
      };
    return Zl = a, Zl;
  }
  var Jl, Dh;
  function HS() {
    if (Dh) return Jl;
    Dh = 1;
    var e = Array.isArray;
    return Jl = e, Jl;
  }
  var eu, Sh;
  function Ph() {
    if (Sh) return eu;
    Sh = 1;
    var e = 9007199254740991;
    function t(n) {
      return typeof n == "number" && n > -1 && n % 1 == 0 && n <= e;
    }
    return eu = t, eu;
  }
  var tu, bh;
  function GS() {
    if (bh) return tu;
    bh = 1;
    var e = ih(),
      t = Ph();
    function n(o) {
      return o != null && t(o.length) && !e(o);
    }
    return tu = n, tu;
  }
  var sa = {
      exports: {}
    },
    nu,
    Oh;
  function WS() {
    if (Oh) return nu;
    Oh = 1;
    function e() {
      return !1;
    }
    return nu = e, nu;
  }
  sa.exports;
  var Eh;
  function VS() {
    return Eh || (Eh = 1, function (e, t) {
      var n = Vn(),
        o = WS(),
        s = t && !t.nodeType && t,
        a = s && !0 && e && !e.nodeType && e,
        r = a && a.exports === s,
        i = r ? n.Buffer : void 0,
        l = i ? i.isBuffer : void 0,
        u = l || o;
      e.exports = u;
    }(sa, sa.exports)), sa.exports;
  }
  var ou, Ih;
  function jS() {
    if (Ih) return ou;
    Ih = 1;
    var e = na(),
      t = Ph(),
      n = Ci(),
      o = "[object Arguments]",
      s = "[object Array]",
      a = "[object Boolean]",
      r = "[object Date]",
      i = "[object Error]",
      l = "[object Function]",
      u = "[object Map]",
      c = "[object Number]",
      d = "[object Object]",
      p = "[object RegExp]",
      f = "[object Set]",
      v = "[object String]",
      h = "[object WeakMap]",
      m = "[object ArrayBuffer]",
      D = "[object DataView]",
      N = "[object Float32Array]",
      I = "[object Float64Array]",
      w = "[object Int8Array]",
      A = "[object Int16Array]",
      j = "[object Int32Array]",
      B = "[object Uint8Array]",
      T = "[object Uint8ClampedArray]",
      g = "[object Uint16Array]",
      C = "[object Uint32Array]",
      S = {};
    S[N] = S[I] = S[w] = S[A] = S[j] = S[B] = S[T] = S[g] = S[C] = !0, S[o] = S[s] = S[m] = S[a] = S[D] = S[r] = S[i] = S[l] = S[u] = S[c] = S[d] = S[p] = S[f] = S[v] = S[h] = !1;
    function R(E) {
      return n(E) && t(E.length) && !!S[e(E)];
    }
    return ou = R, ou;
  }
  var su, Rh;
  function zS() {
    if (Rh) return su;
    Rh = 1;
    function e(t) {
      return function (n) {
        return t(n);
      };
    }
    return su = e, su;
  }
  var aa = {
    exports: {}
  };
  aa.exports;
  var Nh;
  function KS() {
    return Nh || (Nh = 1, function (e, t) {
      var n = x_(),
        o = t && !t.nodeType && t,
        s = o && !0 && e && !e.nodeType && e,
        a = s && s.exports === o,
        r = a && n.process,
        i = function () {
          try {
            var l = s && s.require && s.require("util").types;
            return l || r && r.binding && r.binding("util");
          } catch {}
        }();
      e.exports = i;
    }(aa, aa.exports)), aa.exports;
  }
  var au, Ah;
  function YS() {
    if (Ah) return au;
    Ah = 1;
    var e = jS(),
      t = zS(),
      n = KS(),
      o = n && n.isTypedArray,
      s = o ? t(o) : e;
    return au = s, au;
  }
  var iu, Mh;
  function QS() {
    if (Mh) return iu;
    Mh = 1;
    var e = IS(),
      t = US(),
      n = xS(),
      o = HS(),
      s = GS(),
      a = VS(),
      r = th(),
      i = YS(),
      l = "[object Map]",
      u = "[object Set]",
      c = Object.prototype,
      d = c.hasOwnProperty;
    function p(f) {
      if (f == null) return !0;
      if (s(f) && (o(f) || typeof f == "string" || typeof f.splice == "function" || a(f) || i(f) || n(f))) return !f.length;
      var v = t(f);
      if (v == l || v == u) return !f.size;
      if (r(f)) return !e(f).length;
      for (var h in f) if (d.call(f, h)) return !1;
      return !0;
    }
    return iu = p, iu;
  }
  var qS = QS();
  const rn = F_(qS),
    jn = "https://www.redprinting.co.kr",
    ut = "https://d3qehkb69dy9zc.cloudfront.net/assets/images",
    is = "https://widget-api.redprinting.co.kr";
  async function wh(e = "ko", t, n) {
    try {
      const o = new URLSearchParams(n ? {
          pdt_cod: t,
          ptt_cod: n
        } : {
          pdt_cod: t
        }).toString(),
        s = `${jn}/${e}/product/get_digital_product_info?${o}`,
        r = await (await fetch(s)).json();
      if (r.retCode !== 200) throw new Error(r.msg);
      const {
        result: i
      } = r;
      return {
        result: i,
        errorMessage: null
      };
    } catch (o) {
      let s = "제품 정보를 가져올 수 없습니다.";
      return o instanceof Error && (console.error("[RedWidgetSDK/ERROR] 제품 정보 가져오기 실패 > ", o), o.message && (s = o.message)), {
        result: null,
        errorMessage: s
      };
    }
  }
  async function ru(e, t = "ko") {
    let n = null;
    try {
      const o = `${jn}/${t}/product_price/get_ajax_price_vTmpl`;
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
      };
    } catch (o) {
      console.error("[RedWidgetSDK/ERROR] 가격 요청 실패 > ", o);
      let s = "가격 요청에 실패했습니다.";
      return o instanceof Error && (s = o.message), {
        result: n,
        errorMessage: s
      };
    }
  }
  async function XS(e) {
    try {
      const {
          lang: t,
          file_name: n
        } = e,
        o = `${jn}/${t}/product/s3GetObjectJson`,
        a = await (await fetch(o, {
          method: "POST",
          body: JSON.stringify({
            file_name: n
          })
        })).json();
      if (!a) throw new Error("해당 파일은 s3에 존재하지 않습니다");
      return a;
    } catch (t) {
      let n = "";
      return t instanceof Error && (n = t.message), console.error("[RedWidgetSDK/ERROR] s3 파일 정보 가져오기 실패 >. ", n || t), null;
    }
  }
  async function lu(e) {
    try {
      const {
          lang: t,
          pdt_cod: n
        } = e,
        o = `${jn}/${t}/product/guide_product_paper`,
        a = await (await fetch(o, {
          method: "POST",
          body: JSON.stringify({
            pdt_cod: n
          })
        })).json();
      if (!a) throw new Error();
      const r = [],
        i = new Set([]);
      for (const l of a) {
        const u = `${l.PDT_COD}/${l.PTT_COD}`;
        i.has(u) || (i.add(u), r.push({
          ...l,
          IMG_URL_DEFAULT: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${l.PTT_COD}.png`,
          IMG_URL_DETAIL: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${l.PTT_COD}_over.png`,
          PDT_COD: n
        }));
      }
      return r;
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 주문 가능 용지(자재) 정보 가져오기 실패 > ", t), null;
    }
  }
  async function ZS(e) {
    try {
      const {
          lang: t,
          ...n
        } = e,
        o = new FormData();
      Object.entries(n).forEach(([u, c]) => o.append(u, c));
      const s = `${jn}/${t}/product/get_download`,
        r = await (await fetch(s, {
          method: "POST",
          body: o
        })).blob();
      if (r.type !== "application/zip") throw new Error("템플릿 파일(.zip)이 존재하지 않습니다.");
      const i = URL.createObjectURL(r),
        l = document.createElement("a");
      return l.href = i, l.download = `${n.file_nm.replace(/\./g, "_")}`, document.body.appendChild(l), l.click(), l.remove(), URL.revokeObjectURL(i), !0;
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 템플릿 다운로드 실패 > ", t), !1;
    }
  }
  async function JS(e) {
    try {
      const {
          lang: t,
          ...n
        } = e,
        o = new FormData();
      Object.entries(n).forEach(([l, u]) => o.append(l, u));
      const s = `${jn}/${t}/product/get_pdf_download`,
        r = await (await fetch(s, {
          method: "POST",
          body: o
        })).json();
      if (!r.success || !r.url) throw new Error(r.msg);
      const i = document.createElement("a");
      return i.href = r.url, document.body.appendChild(i), i.click(), i.remove(), !0;
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 책자 표지 템플릿 다운로드 실패 > ", t), !1;
    }
  }
  async function eP(e) {
    try {
      const {
          lang: t,
          ...n
        } = e,
        o = `${jn}/${t}/product/get_basicKalSize`,
        s = new FormData();
      s.append("CUT_WDT", String(n.CUT_WDT)), s.append("CUT_HGH", String(n.CUT_HGH));
      const r = await (await fetch(o, {
        method: "POST",
        body: s
      })).json();
      if (r.retCode !== 200) throw new Error(r.msg);
      return r.result;
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 칼선 길이 조회 실패 > ", t), null;
    }
  }
  async function tP(e) {
    try {
      const {
          lang: t,
          fileName: n,
          ...o
        } = e,
        s = new FormData();
      Object.entries(o).forEach(([p, f]) => s.append(p, String(f)));
      const a = `${jn}/${t}/product/get_fld_download`,
        i = await (await fetch(a, {
          method: "POST",
          body: s
        })).json();
      if (!i.success || !i.url) throw new Error(i.msg);
      const u = await (await fetch(i.url)).blob(),
        c = URL.createObjectURL(u),
        d = document.createElement("a");
      return d.href = c, d.download = n, document.body.appendChild(d), d.click(), d.remove(), URL.revokeObjectURL(c), !0;
    } catch (t) {
      return console.error("[RedWidgetSDK/ERROR] 접지 가이드 다운로드 실패 > ", t), !1;
    }
  }
  const nP = {
      "PRT_SID-디자인3방인쇄색상선택": "3-Side Print Color Selection",
      "주문불가-PRT_SID-색상미선택": "Please select a color for 3-side printing.",
      "PRT_SID-편집방법선택": "Select Edit Method",
      "PRT_SID-이어서편집": "Continue Editing",
      "PRT_SID-페이지별편집": "Edit by Page",
      "TPBLPST-낱장인쇄중단안내": "Single sheet printing service has been discontinued as of 2023.07.21.",
      "떡메-사이즈": "Size",
      "떡메-약": "approx.",
      "떡메-장": "pcs",
      "떡메-오차안내": "There may be a discrepancy of approximately 10 sheets.",
      "STTBDFT-업로드안내": "* Any white or colored areas in design will be printed.<br>For transparent background, please create transparent background in image before uploading.",
      주문서작성: "Orientation",
      "옵셋-명함타입": "Type",
      가로: "Horizontal",
      세로: "Vertical",
      용지: "Paper",
      자재: "Material",
      액자: "Frame",
      모양: "Shape",
      "모양-사이즈": "Size",
      "칼선 타입": "Cutting Type",
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
      개수: "EA",
      건: "",
      단위주문수량안내: "* {QTY}pc per increment",
      단위수량자동변경안내: "Orders must be placed in multiples of {QTY}. Quantity has been adjusted.",
      PDF장수안내: "Please upload {QTY} page PDF",
      세트수량안내: "After creating photos in Editor, total quantity will be displayed above",
      세트별수량안내: "({SET_CNT}pcs/set) product",
      폴라팩세트수량안내: "Set ({SET_CNT}pcs/{PRN_CNT}SET) product",
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
      "파일업로드-후가공레이어": "[If post-processing is added] Please upload a PDF file with separate layers for printing and cutting lines.",
      아트지라벨코팅안내: "* If Art Paper Label is selected, add coating would be recommended to prevent paper dust along the cutting line of your artwork.",
      PDF업로드규격확인안내: "You selected PDF upload. Please check the size information carefully.",
      에디터선택규격확인안내: "You selected editor. Please check the size information carefully.",
      "6색인쇄 선택안함": "6-Color Print None",
      "6색인쇄 선택": "6-Color Print Select",
      파일업로드레이어안내: "Submit artwork file in working size.",
      "파일업로드레이어안내-옵셋": "Submit artwork file in working size.",
      "파일업로드후가공안내-옵셋": "[When adding post-processing] Please upload a PDF, AI, or EPS file with separate post-processing layers (printing/cutting, etc.).",
      귀돌이최소선택안내: "Please select at least one corner rounding option.",
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
      최대수량초과안내: "The maximum order quantity is {MAX_CNT}.",
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
      "num-dft.시작번호": "Start No.",
      "num-dft.끝번호": "End No.",
      "num-dft.글꼴": "Font",
      "num-dft.글꼴선택": "Select Font",
      "num-dft.폰트안내": "* If no font is selected, Nanum Gothic (default) will be used.",
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
      "에디터-레이어-후가공-불일치": `The finishing option ({FINISHING}) does not match the layers in your edited file.
Please check your finishing options and edit again.`,
      "주문불가-옵션미선택": "No option selected. Please select an option to continue.",
      "주문불가-가격": "An error occurred while calculating the price. Please try again or contact customer support.",
      "주문불가-인쇄컬러미선택": "Please select a print color(Pantone).",
      "주문불가-사이즈": `Size entered cannot be produced.
Please check minimum/maximum limits.`,
      "주문불가-번호인쇄": "Please enter the start and end numbers for Numbering (NUM) finishing.",
      "주문불가-재확인": "Please check the info on cutting and confirm before ordering.",
      버튼타입: "Button Type",
      제품타입: "Product Type",
      PREMIUM: "PREMIUM",
      LIGHT: "LIGHT",
      "PHPLEDT-PREMIUM-안내": "Premium: Glossy finish with transparent coating on photo areas",
      "PHPLEDT-LIGHT-안내": "Light: Natural paper texture preserved",
      "무광코팅-개별포장-안내": "* Matte coating automatically enables individual packaging to prevent surface scratches.",
      "오늘출발-불가능": "* Selected specification is not available for Same-Day delivery.<br /> View 'See Options' to check eligibility.",
      "내일출발-불가능": "* Selected specification is not available for Next-Day delivery.<br /> View 'See Options' to check eligibility.",
      "스티커용지-주의사항": "* Situations whereby PE, BOX, plastic containing agent, embossed, coated small box, short diameter roll, wood, stone surface, harness, non-woven fabric, attached to non-flat surfaces are placed in the refrigerator, might fall off.",
      줄수: "EA",
      "OSI-NOTICE": "- Vertical or horizontal crease lines can be produced.<br />- 5mm gap spacing is required if there is more than 1 line.<br />- Indicate line in the color of C:100 (1pt stroke)",
      "MIS-NOTICE": "- Vertical or horizontal crease lines can be produced.<br />- 5mm gap spacing is required if there is more than 1 line.<br />- Indicate line in the color of C:100 (1pt stroke)",
      가로방향접지: "Horizontal Fold",
      세로방향접지: "Vertical Fold",
      "코팅-스노우용지": "* If Snow paper is selected, only double-sided coating will be applied.",
      "용지-A3이상-120g": `* Please select more than 120g if the size is over 297*420 (A3).
Feature: Paper [Snow, Art Paper]`,
      "LAM_DFT-상호배타": "Laminate Coating cannot be selected with 'Perforation, Creasing, Coating, Foil Stamping, Folding, Corner Rounding, Magic Ink' finishing options.",
      "후가공-상호배타": "'{NEW}' cannot be selected with '{EXISTING}'.",
      마스터색상: "Master Color",
      "마스터색상-선택안함": "None",
      "마스터색상-선택필요": 'Please select a "Master Color".',
      칼선타입: "Cutting Type",
      사각라운드형: "Rounded Square",
      원형: "Round",
      타원형: "Oval",
      사각형: "Rectangular",
      자유형: "Free Shape",
      재단옵션안내: "Cutting Guide",
      재단가이드: "Cutting Guide",
      "후가공-재단가이드": "Produced as shown in the image - using <span class='bold red'>{METHOD}</span>",
      고객확인: "I confirm",
      인쇄함: "Printing",
      인쇄안함: "Blank",
      인풋카드: "Insert Card",
      명함형태: "Type",
      가로3단형: "Tri-Fold",
      가로N형: "N Fold",
      세로3단형: "Tri-Fold",
      세로N형: "N Fold",
      "4귀전체": "All Corners",
      걸이타입: "Calendar Type",
      타공형: "Punching",
      걸이형: "Hanging",
      접지가이드안내1: "※ For tri-fold, gate fold, and reverse gate fold, please download the folding guide before creating artwork.",
      접지가이드안내2: "※ Gate fold & Reverse gate fold: The folding panel is shorter than the inner panel, which may be visible when folded.",
      접지가이드다운로드: "Folding Guide Download",
      접지가이드불가: "N Fold is a custom-made item, hence, guide is not available for download",
      자석거치대부착가능: "* Can be attached to magnetic surfaces.",
      자석거치대부착불가: "* Cannot be attached to magnetic surfaces.",
      "한장으로 받기": "Receive as Sheet",
      "조각으로 받기": "Receive as Pieces",
      "자유형스티커-에디터안내1": "* Available sheet size: 30x30(mm) ~ A5",
      "자유형스티커-에디터안내2": "* For transparent, gold/silver glossy/silver matte PET, and kraft paper, white ink is printed beneath the photo area before color printing. Please fill all areas except the transparent portions with your artwork before uploading.",
      "자유형스티커-칼선안내": "* Additional charges apply when the cutting line exceeds the standard length of {LENGTH}(m).",
      "자유형스티커-최소크기오류": "There are {COUNT} object(s) smaller than the minimum size of {MIN}(mm). Ordering is not possible. Please edit again.",
      "선택 안함": "None",
      커팅: "Cutting",
      "직접 잘라요": "DIY Cut Sheet",
      "바로 붙여요": "Individual Die-Cut"
    },
    oP = {
      "PRT_SID-디자인3방인쇄색상선택": "디자인 3방인쇄 색상선택",
      "주문불가-PRT_SID-색상미선택": "측면인쇄(3방) 색상을 선택해 주세요.",
      "PRT_SID-편집방법선택": "편집방법 선택",
      "PRT_SID-이어서편집": "이어서 편집",
      "PRT_SID-페이지별편집": "페이지별 편집",
      "TPBLPST-낱장인쇄중단안내": "23.07.21일부로 낱장 인쇄 서비스가 중단되었습니다.",
      "떡메-사이즈": "사이즈",
      "떡메-약": "약",
      "떡메-장": "장",
      "떡메-오차안내": "10장 정도 오차가 있을 수 있습니다.",
      "STTBDFT-업로드안내": "* 이미지 영역만큼 화이트 인쇄+컬러 인쇄해 제작합니다.<br>특정 부분을 투명하게 보이게하려면, 이미지에 투명한 부분을 만들어 업로드해 주세요.",
      주문서작성: "주문서 작성",
      "옵셋-명함타입": "명함 종류",
      가로: "가로",
      세로: "세로",
      용지: "용지",
      자재: "자재",
      액자: "액자",
      모양: "모양",
      "모양-사이즈": "사이즈",
      "칼선 타입": "칼선 타입",
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
      개수: "개수",
      건: "건",
      단위주문수량안내: "* {QTY}개 단위로 주문 가능한 제품입니다.",
      단위수량자동변경안내: "{QTY}개 단위로 주문 가능한 제품입니다. 수량을 변경 합니다.",
      PDF장수안내: "{QTY}페이지 PDF를 업로드해 주십시오.",
      세트수량안내: "에디터로 만들기를 종료하면, 선택한 종류의 수와 수량이 표기됩니다.",
      세트별수량안내: "({SET_CNT}장/1세트) 상품입니다.",
      폴라팩세트수량안내: "* 세트 ({SET_CNT}장/{PRN_CNT}SET) 상품입니다.",
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
      "파일업로드-후가공레이어": "[후가공 추가 시] 후가공 레이어(인쇄/칼선 등)가 구분된 PDF 파일을 업로드해 주세요.",
      아트지라벨코팅안내: "* 아트지 라벨의 경우 코팅 후가공 없이 주문 시, 칼선 부분에 종이 지분이 일어나는 현상이 발생할 수 있습니다.코팅 후가공 추가를 권장 드립니다.",
      PDF업로드규격확인안내: "PDF 업로드를 선택하셨습니다. 규격 정보를 꼭 확인해 주세요.",
      에디터선택규격확인안내: "에디터를 선택하셨습니다. 규격 정보를 꼭 확인해 주세요.",
      "6색인쇄 선택안함": "6색인쇄 선택안함",
      "6색인쇄 선택": "6색인쇄 선택",
      파일업로드레이어안내: "1개의 PDF파일(*.PDF)만 업로드 가능",
      "파일업로드레이어안내-옵셋": "칼선/인쇄레이어가 구분된 1개의 PDF, AI, EPS 파일 (*.PDF, *.AI, *.EPS) 업로드",
      "파일업로드후가공안내-옵셋": "[후가공 추가 시] 후가공 레이어(인쇄/칼선 등)가 구분된 PDF, AI, EPS 파일을 업로드해 주세요.",
      귀돌이최소선택안내: "귀돌이는 하나이상 선택하셔야 합니다.",
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
      최대수량초과안내: "최대 입력 가능 수량은 {MAX_CNT}장입니다.",
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
      "num-dft.시작번호": "시작번호",
      "num-dft.끝번호": "끝번호",
      "num-dft.글꼴": "글꼴",
      "num-dft.글꼴선택": "글꼴 선택",
      "num-dft.폰트안내": "* 폰트를 고르지 않으면 기본 나눔고딕으로 진행됩니다.",
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
      "에디터-레이어-후가공-불일치": `현재 선택된 후가공 옵션({FINISHING})과 에디터에서 편집한 파일의 레이어가 일치하지 않습니다.
후가공 옵션을 확인 후 다시 편집해 주세요.`,
      "주문불가-옵션미선택": "선택된 옵션이 없습니다. 주문할 옵션을 선택해 주세요.",
      "주문불가-가격": "가격 산정 시 오류가 발생했습니다. 문제가 지속될 경우 고객센터에 문의해 주세요.",
      "주문불가-인쇄컬러미선택": "인쇄 컬러(팬톤)를 선택해 주세요.",
      "주문불가-사이즈": `주문 가능 사이즈 범위를 벗어났습니다.
규격(사이즈)을 다시 확인해 주세요.`,
      "주문불가-번호인쇄": "번호인쇄(NUM) 후가공의 시작번호와 끝번호를 입력해 주세요.",
      "주문불가-재확인": "재단 미리보기 [확인했습니다]를 체크해주세요.",
      버튼타입: "버튼타입",
      제품타입: "제품타입",
      PREMIUM: "PREMIUM",
      LIGHT: "LIGHT",
      "PHPLEDT-PREMIUM-안내": "Premium : 사진 부분에 투명액이 올라가 반짝반짝",
      "PHPLEDT-LIGHT-안내": "Light : 종이 질감이 그대로 느껴져요",
      "무광코팅-개별포장-안내": "* 무광 코팅 선택 시 표면 스크레치를 방지하기 위해 개별포장이 자동 선택됩니다.",
      "오늘출발-불가능": "* 선택한 옵션은 오늘출발 서비스 적용이 불가합니다.<br /> 가능 조건은 하단 ‘오늘출발-옵션 배너’에서 확인해 주세요.",
      "내일출발-불가능": "* 선택한 옵션은 내일출발 서비스 적용이 불가합니다.<br /> 가능 조건은 하단 ‘내일출발-옵션 배너’에서 확인해 주세요.",
      "스티커용지-주의사항": "* PE, BOX, 가소제 성분이 들어간 플라스틱, 엠보, 코팅된 소형박스, 직경이 작아 말아붙인 것, 나무, 돌표면, 마대, 부직포, 평평하지 않은 표면에 부착하거나 부착 후 냉장고(냉동고)에 넣을 경우 떨어질 수 있습니다.",
      줄수: "줄수",
      "OSI-NOTICE": "- 기본 오시 가공은 수직과 수평으로 종이를 가로지르는 가공만 가능합니다.<br />- 나란히 들어가는 오시 선들 사이의 간격은 최소 5mm 이상 되어야 합니다.<br />- 오시의 개수와 위치는 위치는 데이터에 직접 선으로 표시해 주시고, 줄 숫자를 빈칸에 입력해 주셔야 합니다.<br />('오시' 레이어에 C:100, 1pt 스트로크로 만들어주세요.)",
      "MIS-NOTICE": "- 기본 미싱은 종이 끝에서 끝까지 가로지르는 수직과 수평 가공만 가능하며, 점선 형태 또한 고정입니다.<br />- 나란히 들어가는 미싱 선들 사이의 간격은 최소 5mm 이상 되어야 합니다.<br />- 미싱 선의 개수와 위치는 데이터에 직접 선으로 표시해 주시고, 줄 숫자를 빈칸에 입력해 주셔야 합니다.<br />(“미싱” 레이어에 C:100, 1pt 스트로크로 만들어주세요.)",
      가로방향접지: "가로방향",
      세로방향접지: "세로방향",
      "코팅-스노우용지": "* 스노우 용지의 경우, 코팅 선택 시 인쇄면과 관계없이 양면 코팅되어 제작됩니다.",
      "용지-A3이상-120g": `* A3(297*420)사이즈가 넘어가는 경우 120g 이상으로 선택하셔야 합니다.
조건: 용지[스노우, 아트지]`,
      "LAM_DFT-상호배타": "책받침코팅은 '미싱, 오시, 코팅, 박, 접지, 귀돌이, 매직잉크' 후가공과 함께 선택 불가합니다.",
      "후가공-상호배타": "'{NEW}'은(는) '{EXISTING}'과(와) 함께 선택할 수 없습니다.",
      마스터색상: "마스터색상",
      "마스터색상-선택안함": "선택안함",
      "마스터색상-선택필요": '"마스터색상"을 선택하세요.',
      칼선타입: "칼선 타입",
      사각라운드형: "사각라운드형",
      원형: "원형",
      타원형: "타원형",
      사각형: "사각형",
      자유형: "자유형",
      재단옵션안내: "재단 옵션 선택에 대한 안내입니다",
      재단가이드: "재단가이드",
      "후가공-재단가이드": "그림과 같이 <span class='bold red'>{METHOD}</span> 되어 제작됩니다.",
      고객확인: "확인했습니다",
      인쇄함: "인쇄 함",
      인쇄안함: "인쇄 안함",
      인풋카드: "인풋 카드",
      명함형태: "명함 형태",
      가로3단형: "가로 3단형",
      가로N형: "가로 N형",
      세로3단형: "세로 3단형",
      세로N형: "세로 N형",
      "4귀전체": "4귀 전체",
      걸이타입: "걸이 타입",
      타공형: "타공형",
      걸이형: "걸이형",
      접지가이드안내1: "※ 3단, 대문, 반대문 접지의 경우 반드시 접지 가이드를 다운로드하여 작업해주세요.",
      접지가이드안내2: "※ 대문, 반대문 접지 : 안쪽 면보다 접히는 면이 짧아, 접었을 때 안쪽 면이 보일 수 있습니다.",
      접지가이드다운로드: "접지가이드 다운로드",
      접지가이드불가: "N접지는 사용자 정의 품목이어서 접지가이드 다운로드가 불가합니다.",
      자석거치대부착가능: "* 자석 거치대 부착이 가능합니다.",
      자석거치대부착불가: "* 자석 거치대 부착이 불가능합니다.",
      "한장으로 받기": "한장으로 받기",
      "조각으로 받기": "조각으로 받기",
      "자유형스티커-에디터안내1": "* 주문 가능 대지사이즈 : 30x30(mm)~A5",
      "자유형스티커-에디터안내2": "* 투명, 금광/은광/은무PET, 크라프트 용지의 경우, 사진 영역만큼 화이트 인쇄 후 컬러 인쇄하여 제작됩니다. 투명한 부분을 제외한 나머지 영역에 꼭 이미지를 채워서 업로드해 주세요.",
      "자유형스티커-칼선안내": "* 기본 제공 칼선 길이 : {LENGTH}(m) 초과시 추가금 발생합니다.",
      "자유형스티커-최소크기오류": "최소 크기 {MIN}(mm) 보다 작은 객체가 {COUNT}개 있습니다. 주문이 불가합니다. 다시 편집해 주세요.",
      "선택 안함": "선택 안함",
      커팅: "커팅",
      "직접 잘라요": "직접 잘라요",
      "바로 붙여요": "바로 붙여요"
    },
    _t = Qs("config", () => {
      const e = H("ko");
      function t(n) {
        e.value = n;
      }
      return {
        locale: e,
        setLocale: t
      };
    }),
    F = (e, t) => {
      const {
          locale: n
        } = _D(_t()),
        s = (n.value === "ko" ? oP : nP)[e] || e;
      if (!t) return s;
      let a = s;
      return Object.entries(t).forEach(([r, i]) => {
        a = a.replace(`{${r}}`, i);
      }), a;
    },
    sP = oe({
      __name: "Skeleton",
      props: {
        variant: {},
        width: {},
        height: {}
      },
      setup(e) {
        const t = e,
          n = b(() => t.width ? `${t.width}px` : "auto"),
          o = b(() => t.height ? `${t.height}px` : "auto");
        return (s, a) => s.variant === "circular" ? (_(), O("div", {
          key: 0,
          class: $e(["skeleton-item", "circular"]),
          style: mt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : s.variant === "rectangular" ? (_(), O("div", {
          key: 1,
          class: $e(["skeleton-item", "rectangular"]),
          style: mt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : s.variant === "rounded" ? (_(), O("div", {
          key: 2,
          class: $e(["skeleton-item", "rounded"]),
          style: mt({
            width: n.value,
            height: o.value
          })
        }, null, 4)) : J("", !0);
      }
    }),
    Ne = (e, t) => {
      const n = e.__vccOpts || e;
      for (const [o, s] of t) n[o] = s;
      return n;
    },
    Ye = Ne(sP, [["__scopeId", "data-v-e3562e90"]]),
    aP = {
      key: 0,
      class: "skeleton"
    },
    iP = {
      class: "row"
    },
    rP = {
      class: "row"
    },
    lP = {
      class: "row"
    },
    uP = {
      key: 1,
      class: "skeleton"
    },
    cP = {
      class: "row"
    },
    dP = {
      class: "row"
    },
    fP = {
      class: "radio"
    },
    pP = {
      class: "row"
    },
    _P = {
      class: "row"
    },
    hP = {
      class: "radio"
    },
    vP = {
      class: "row"
    },
    mP = {
      class: "row"
    },
    CP = {
      class: "radio"
    },
    TP = {
      class: "row"
    },
    gP = {
      class: "row"
    },
    yP = {
      class: "radio"
    },
    DP = {
      class: "row"
    },
    SP = {
      class: "row"
    },
    PP = {
      class: "radio"
    },
    Lh = Ne(oe({
      __name: "SkeletonGroup",
      props: {
        group: {}
      },
      setup(e) {
        return (t, n) => t.group === "vSubMtrl_item" ? (_(), O("div", aP, [P("div", iP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", rP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", lP, [ne(Ye, {
          variant: "rounded",
          height: 40
        })])])) : (_(), O("div", uP, [P("div", cP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", dP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), P("div", fP, [ne(Ye, {
          variant: "rounded",
          height: 49
        }), ne(Ye, {
          variant: "rounded",
          height: 49
        })])]), P("div", pP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", _P, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), P("div", hP, [ne(Ye, {
          variant: "rounded",
          height: 49
        }), ne(Ye, {
          variant: "rounded",
          height: 49
        })])]), P("div", vP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", mP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), P("div", CP, [ne(Ye, {
          variant: "rounded",
          height: 49
        }), ne(Ye, {
          variant: "rounded",
          height: 49
        })])]), P("div", TP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", gP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), P("div", yP, [ne(Ye, {
          variant: "rounded",
          height: 49
        }), ne(Ye, {
          variant: "rounded",
          height: 49
        })])]), P("div", DP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), ne(Ye, {
          variant: "rounded",
          height: 40
        })]), P("div", SP, [ne(Ye, {
          variant: "rounded",
          width: 50,
          height: 20
        }), P("div", PP, [ne(Ye, {
          variant: "rounded",
          height: 49
        }), ne(Ye, {
          variant: "rounded",
          height: 49
        })])])]));
      }
    }), [["__scopeId", "data-v-096103a5"]]),
    kh = H(""),
    uu = H(!1);
  let cu = null;
  function ia() {
    return {
      message: kh,
      visible: uu,
      show: (t, n = 3e3) => {
        cu && clearTimeout(cu), kh.value = t, uu.value = !0, cu = setTimeout(() => {
          uu.value = !1;
        }, n);
      }
    };
  }
  const bP = {
      key: 0,
      class: "toast"
    },
    OP = Ne(oe({
      __name: "Toast",
      setup(e) {
        const {
          message: t,
          visible: n
        } = ia();
        return (o, s) => (_(), V(fT, {
          name: "toast"
        }, {
          default: fe(() => [y(n) ? (_(), O("div", bP, Y(y(t)), 1)) : J("", !0)]),
          _: 1
        }));
      }
    }), [["__scopeId", "data-v-e2125d65"]]),
    ra = Qs("product", () => {
      const e = H();
      function t() {
        return Le(e.value);
      }
      function n(o) {
        e.value = o;
      }
      return {
        baseInfo: e,
        getProductBaseInfo: t,
        setProductBaseInfo: n
      };
    });
  function EP() {
    return {
      isDev: b(() => ["dev", "int"].includes("prod"))
    };
  }
  const Ve = Qs("exterior", () => {
      const e = Xe({
        default: "editor"
      });
      function t(u, c) {
        e[c || "default"] = u;
      }
      const n = Xe({
          default: null
        }),
        o = (u, c) => {
          n[c || "default"] = u;
        },
        s = Xe({
          default: null
        }),
        a = (u, c) => {
          s[c || "default"] = u;
        },
        r = H(null),
        i = u => {
          r.value = u;
        };
      return U(() => n, u => {
        EP().isDev.value && console.log("[RedWidgetSDK] 에디터 편집 정보 업데이트 >", u);
      }, {
        deep: !0
      }), {
        uploadType: e,
        setUploadType: t,
        editorData: n,
        setEditorData: o,
        isAfterEdit: u => n[u || "default"] ? e[u || "default"] === "editor" && n[u || "default"].editingYn === "Y" : !1,
        payloadForEditorConfig: s,
        setPayloadForEditorConfig: a,
        foilPcsDtlCd: r,
        setFoilPcsDtlCd: i
      };
    }),
    Mo = Qs("order", () => {
      const e = H(),
        t = Te("callbacks", {});
      function n() {
        return Le(e.value);
      }
      function o(i, l) {
        e.value = i, t?.onOptionChange && t.onOptionChange({
          type: "COMMON",
          data: i,
          summary: l
        });
      }
      const s = H(!1);
      function a() {
        return s.value;
      }
      function r(i) {
        s.value = i;
      }
      return {
        orderData: e,
        getOrderData: n,
        setOrderData: o,
        isUserDoubleConfirmed: s,
        getUserDoubleConfirmed: a,
        setUserDoubleConfirmed: r
      };
    }),
    du = Qs("acc-order", () => {
      const e = H(),
        t = Te("callbacks", {});
      function n() {
        return Le(e.value);
      }
      function o(s) {
        e.value = s, t?.onOptionChange && t.onOptionChange({
          type: "ACC",
          data: s
        });
      }
      return {
        orderData: e,
        getOrderData: n,
        setOrderData: o
      };
    }),
    fu = {
      GSPNJLY: "TotalQty",
      PHPTEDT: "TotalQty",
      PHPRFRM: "TotalQty",
      GSPNBAL: "SetQty",
      GSPNDFT: "SetQty",
      GSBLGLF: "SetQty",
      STDRCAD: "SimpleQty",
      STTBDFT: "SimpleQty",
      TPCAPTW: "SimpleQty",
      GSELGLV: "SimpleQty"
    },
    $h = new Set(["GSPNJLY", "GSPNBAL", "GSPNCLP", "GSPNDFT", "GSPNFLT", "GSTTCRK", "GSCAEPB", "GSCAGBP", "GSCAGBM", "GSCAGBR", "GSCAGBH", "GSCATPP", "GSCATPG", "GSCATCP", "GSCACDP", "GSCAPHN", "GSWLMAG", "GSCATIN", "GSKYHOT", "GSHDMGT", "GSTGMIC", "GSCAPDF", "GSCACAP", "PHFRDIA", "GSSKSHH", "GSFBSTK"]),
    IP = new Set(["GSCAEPB", "GSCAGBP", "GSCAGBM", "GSCAGBR", "GSCAGBH", "GSCATPP", "GSCATPG", "GSCATCP", "GSCACDP", "GSCAPHN", "GSWLMAG"]),
    Ti = {
      GSPNJLY: !0,
      GSPNBAL: !0,
      GSPNDFT: !0,
      GSBLGLF: !0,
      PHPTEDT: !0
    },
    RP = {
      TPCLWLB: !0,
      TPCLSTD: !0,
      PRCLSTD: !0,
      PRCLHOL: !0,
      PRCLWAL: !0,
      TPCLHOL: !0,
      TPCLWAL: !0,
      TPCLECO: !0
    },
    Fh = new Set(["PRCLSTD", "PRCLHOL", "PRCLWAL"]),
    pu = new Set(["GSBKLAP", "GSBKBCH", "GSTTDTM", "GSFBPHP", "GSFBSTK"]),
    gi = {
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
    _u = {
      GSCATIN: {
        SXTNC010: "Y",
        SXTNC014: "Y"
      }
    },
    NP = {
      PHPRFRM: ["RXYUP080"]
    },
    Uh = {
      STTHUSR: ["KFL", "SPT", "TPT", "EGP", "ESP", "BBB", "BLK", "IGC", "TPB"],
      STPADIY: ["KFL", "SPT", "TPT", "EGP", "ESP", "BBB", "BLK", "IGC", "TPB"]
    },
    AP = {
      STTHUSR: ["SCO_DFT", "NUM_DFT"],
      STPADIY: ["SCO_DFT", "NUM_DFT"]
    },
    zn = new Set(["BCSPWHT"]),
    MP = new Set(["ACTHPAM", "ACTHPAA", "ACTHPEN", "ACTHCKY"]),
    Bh = {
      GSCACAP: 3
    },
    xh = {
      GSCACAP: {
        SXKEY401: 4,
        SXKEY402: 4,
        SXKEY408: 4
      }
    },
    wP = ["SST_DFT", "BON_PAP"],
    LP = new Set(["TPCLECO", "TPCLWLB", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLSTD", "PRCLHOL", "PRCLWAL", "TPCLSTD", "TPCLSTD", "TPCLSTD", "TPCLSTD", "TPCLHOL", "TPCLWAL", "HLCLSTD", "HLCLWAL"]),
    hu = {
      GSCDPOP: {
        factor: "size",
        value: {
          1: "3",
          2: "6"
        }
      },
      PRCDTRA: {
        factor: "size",
        value: {
          1: "3"
        }
      },
      BCSPDAY: {
        factor: "fixed",
        value: "4"
      }
    },
    kP = new Set(["PRCDTRA", "BCSPDAY"]),
    $P = new Set(["TPCASET"]),
    FP = new Set(["TPCASET"]),
    UP = new Set(["PRCDTRA", "BCSPDAY", "TPBCDFT", "TPBCCPN"]),
    BP = new Set(["GSLPPRT", "GSLPSTK"]),
    xP = {
      TPBLMEO: "GSRMMSD",
      TPBLPST: "GSRMPSD"
    };
  function Hh(e, t) {
    const n = xP[e];
    return !n || t.dosuInfo?.COD !== "SID_X" ? e : t.pcsInfo?.find(s => s.PCS_CD === "PRT_SID")?.selectedOptions[0]?.PCS_DTL_CD === "PT005" ? n : e;
  }
  function HP(e, t) {
    const {
        pdtCode: n,
        option: o,
        editorData: s
      } = t,
      a = o.skinInfo,
      r = o.item_gbn,
      i = a?.sizeSelect.view_yn === "Y" ? e.sizeInfo.cutSize : null,
      l = a?.sizeSelect.view_yn === "Y" ? e.sizeInfo.workSize : null,
      u = i ? `${+i.width.toFixed(2)}x${+i.height.toFixed(2)}` : null,
      c = l ? `${+l.width.toFixed(2)}x${+l.height.toFixed(2)}` : null,
      d = {
        ...(u ? {
          cutSize: {
            value: u,
            label: F("summary.재단")
          }
        } : {}),
        ...(c ? {
          workSize: {
            value: c,
            label: F("summary.작업")
          }
        } : {})
      },
      p = s.default?.cntInfo,
      f = fu[n] === "SetQty" ? (p?.totalCnt || 1) / (p?.initCnt || 1) : null;
    if (!e.quantityInfo) return null;
    const v = r === "book2025_item" ? null : e.quantityInfo.ordCnt,
      h = r === "book2025_item" ? e.quantityInfo.ordCnt : e.quantityInfo.prnCnt,
      m = {
        ...(f ? {
          setQty: {
            value: f,
            label: F("summary.세트")
          }
        } : v ? {
          designQty: {
            value: v,
            label: F("summary.디자인수")
          }
        } : {}),
        orderQty: {
          value: h,
          label: F("summary.수량")
        }
      },
      {
        result_sum: D,
        book_info: N
      } = e.priceCalc.result;
    if (!D) return null;
    const {
        ORG_PRICE: I,
        ORG_PRICE_VAT: w,
        PRICE: A,
        PRICE_VAT: j,
        PRICE_MALL: B,
        PRICE_MALL_VAT: T
      } = D,
      g = A !== B,
      C = I !== A,
      S = g ? B + T : C ? A + j : I + w,
      R = Ti[n] || RP[n] ? h : (h || 1) * (v || 1),
      E = Math.round(S / R),
      L = {
        vat: {
          value: g ? T : C ? j : w,
          label: F("summary.부가세")
        },
        unitPrice: {
          value: E,
          label: F("summary.개당")
        },
        price: {
          value: g ? B : C ? A : I,
          label: F("summary.공급가")
        },
        totalPrice: {
          value: S,
          label: F("summary.청구금액")
        }
      };
    if (e.acrylicSelectData) {
      const G = e.acrylicSelectData.productionMethod?.COD_NME;
      return {
        ...(G ? {
          method: {
            value: G,
            label: F("summary.인쇄방식")
          }
        } : {}),
        ...d,
        ...m,
        ...L
      };
    }
    if (r === "book2025_item") {
      const G = N ? {
        weight: {
          value: N.PDT_WGT,
          label: F("summary.예상무게")
        },
        boxQty: {
          value: N.BOX_CNT,
          label: F("summary.예상박스")
        },
        shipping: {
          value: N.DLVR_AMT,
          label: F("summary.배송비")
        }
      } : null;
      return {
        ...m,
        ...L,
        ...G
      };
    }
    return {
      ...d,
      ...m,
      ...L
    };
  }
  function GP(e) {
    const {
        pdtCode: t,
        docInfo: n
      } = e,
      o = n.pageInfos[0],
      {
        renderBound_mm: s,
        renderBounds: a,
        size_mm: r,
        postWorkBound_mm: i
      } = o,
      l = s || (a && a.length >= 1 ? a[0].rect_mm : r),
      u = {
        width: +l.width.toFixed(2),
        height: +l.height.toFixed(2)
      };
    if (!u) return;
    let c;
    return ["ACTHDCO", "ACTHFCO", "ACTHBCO"].includes(t) && (c = i || {
      width: u.width - 2,
      height: u.height - 2
    }), {
      workSize: u,
      ...(c ? {
        cutSize: c
      } : {})
    };
  }
  const la = {
      TPCASET: 18
    },
    vu = {
      PHPLEDT: {
        MI: 20,
        OR: 11,
        ME: 23,
        LA: 19
      }
    },
    Gh = new Set(["PHPLEDT"]),
    mu = {
      GSPNJLY: 1,
      GSPNBAL: 2,
      GSBLGLF: 3,
      PHSTNOP: 4,
      PHSTSQP: 5,
      GSPNDFT: 6
    };
  function WP(e, t) {
    const {
        pdtCode: n,
        docInfo: o
      } = e,
      s = t ? vu[n]?.[t] : void 0;
    if (s) {
      const a = o.pageGroup?.groups?.length || 1,
        r = a * s;
      return {
        quantityInfo: {
          ordCnt: a,
          prnCnt: r
        },
        cntInfo: {
          initCnt: s,
          totalCnt: r
        }
      };
    }
    if (mu[n]) {
      const a = mu[n],
        r = o.contentPageCount * a,
        i = ["PHSTNOP", "PHSTSQP"].includes(n) ? 1 : (o.pageGroup?.groups?.length || 1) * a,
        l = o.contentPageCount * a;
      return {
        quantityInfo: {
          ordCnt: i,
          prnCnt: l,
          ...(la[n] && {
            innerPrnCnt: la[n]
          })
        },
        cntInfo: {
          initCnt: a,
          totalCnt: r
        }
      };
    }
    if (["STTBDFT"].includes(n)) return console.log("STTBDFT > ", o, o.pageInfos.length), {
      quantityInfo: {
        ordCnt: o.pageInfos.length
      }
    };
    if (["PHPTEDT"].includes(n)) return {
      quantityInfo: {
        ordCnt: o.totalPrintCount,
        prnCnt: o.totalOrderCount
      },
      cntInfo: {
        initCnt: 1,
        totalCnt: o.totalOrderCount
      }
    };
    if (["PHPRFRM"].includes(n)) return {
      quantityInfo: {
        ordCnt: o.pageInfos.length,
        prnCnt: o.totalPageCount
      },
      cntInfo: {
        initCnt: 1,
        totalCnt: o.totalPageCount
      }
    };
    if (o.pageGroup) return {
      quantityInfo: {
        ordCnt: o.totalPageCount,
        prnCnt: 1,
        ...(la[n] && {
          innerPrnCnt: la[n]
        })
      }
    };
  }
  const VP = ["ACTHFCO"];
  function jP(e) {
    if (!VP.includes(e.pdtCode)) return;
    const {
        pageInfos: t
      } = e.docInfo,
      n = t[0].whiteInfo,
      o = t[1].whiteInfo,
      s = n ? n.whiteTotalCount - n.whiteOffCount > 0 : !1,
      a = o ? o.whiteTotalCount - o.whiteOffCount > 0 : !1;
    return {
      PRT_WHT: {
        front: s,
        back: a
      }
    };
  }
  function zP(e) {
    if (e.docInfo.calendarInfo) return {
      calendarInfo: e.docInfo.calendarInfo
    };
  }
  const KP = ["GSBGRDY"];
  function Wh(e, t, n, o) {
    const {
      projectID: s,
      customTabSelectedInfo: a
    } = e;
    if (!s) return null;
    const r = t?.product_option.option.item_gbn,
      i = ["PHPTEDT", "PHPKDFT"].includes(e.pdtCode),
      u = r === "book2025_item" || e.pdtCode.startsWith("BT") || i ? null : GP(e),
      c = WP(e, o),
      d = jP(e),
      p = zP(e),
      f = KP.includes(e.pdtCode);
    return {
      projectID: s,
      editingYn: "Y",
      ...(f ? {} : {
        ...u,
        ...c,
        ...d,
        ...(r === "clothes2025_item" ? {
          editorClothesInfo: a
        } : {}),
        ...p
      })
    };
  }
  function Vh(e) {
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
    } : null;
  }
  const YP = {
      class: "widget-container"
    },
    QP = {
      key: 0,
      class: "widget-body"
    },
    qP = oe({
      __name: "Common",
      setup(e) {
        const t = _t(),
          n = Te("productCode", {
            pdtCode: ""
          }),
          {
            data: o,
            isFetchedAfterMount: s
          } = g_({
            queryKey: ["product/get", n.pttCode ? `${n.pdtCode}/${n.pttCode}` : n.pdtCode],
            queryFn: () => wh(t.locale, n.pdtCode, n.pttCode),
            enabled: b(() => !!n?.pdtCode),
            refetchOnWindowFocus: !1
          }),
          {
            data: a,
            mutate: r
          } = y_({
            mutationKey: ["price/get"],
            mutationFn: T => ru({
              type: "COMMON",
              body: T
            })
          }),
          i = Te("callbacks", {}),
          l = b(() => o.value?.result?.product_option.option),
          u = b(() => l.value?.item_gbn),
          c = {
            component: $n(() => Promise.resolve().then(() => zb)),
            className: "widget"
          },
          d = {
            vDigital_item: c,
            acrylic2025_item: {
              component: $n(() => Promise.resolve().then(() => DO)),
              className: "widget"
            },
            clothes2025_item: {
              component: $n(() => Promise.resolve().then(() => HE)),
              className: "clothes-color"
            },
            book2025_item: {
              component: $n(() => Promise.resolve().then(() => bI)),
              className: ""
            },
            offset2023_item: {
              component: $n(() => Promise.resolve().then(() => KI)),
              className: ""
            }
          },
          p = H(),
          f = b(() => l.value?.price_gbn || "tmpl_price"),
          v = Te("member"),
          h = H({
            ORD_INFO: [],
            PCS_INFO: [],
            price_gbn: f.value,
            mb_cust_cod: v?.mb_cust_cod || "10000000"
          });
        function m(T, g, C, S) {
          if (!g || !T.startsWith("ST") || ["STTBDFT", "STEWDFT"].includes(T)) return {
            cut: g,
            wrk: C
          };
          if (!Object.values(S?.pcsInfo ?? {}).some(G => G.selectedOptions.some(X => X.PCS_CD === "CUT_DFT" && X.PCS_DTL_CD === "DFITM"))) return {
            cut: g,
            wrk: C
          };
          const E = Math.max(g, 50),
            L = E - g;
          return {
            cut: E,
            wrk: C != null ? C + L : C
          };
        }
        function D(T) {
          const g = [];
          T.pcsInfo && Object.values(T.pcsInfo).forEach(S => {
            (S.PCS_CD === "ROU_DFT" ? S.selectedOptions.slice(0, 1) : S.selectedOptions).forEach(E => {
              g.push({
                PCS_COD: E.PCS_CD,
                PCS_DTL_COD: E.PCS_DTL_CD,
                ATTB: n.pdtCode === "GSELGLV" && E.PCS_CD === "DIR_MTR" ? (T.quantityInfo?.prnCnt ?? 0) * 10 : n.pdtCode === "TPTKDFT" && E.PCS_CD === "SUB_MTR" && ["EN001", "EN002", "EN003", "EN004"].includes(E.PCS_DTL_CD) ? (E.ATTB ?? 0) * 10 : E.ATTB,
                ATTB_2: E.ATTB_2,
                ATTB_3: E.ATTB_3
              });
            });
          });
          const C = u.value === "book2025_item" ? [{
            PDT_CD: n.pdtCode,
            CUT_WDT: T.sizeInfo?.cutSize?.width,
            CUT_HGH: T.sizeInfo?.cutSize?.height,
            WRK_WDT: T.sizeInfo?.workSize?.width,
            WRK_HGH: T.sizeInfo?.workSize?.height,
            PRN_CNT: T.quantityInfo?.ordCnt,
            PAGE_CNT: T.quantityInfo?.prnCnt,
            CVR_CLR_CNT: T.dosuInfo?.PRN_CLR_CNT,
            INN_CLR_CNT: T.inner_dosuInfo?.PRN_CLR_CNT,
            CVR_MTRL_CD: T.meterialInfo?.MTRL_CD,
            INN_MTRL_CD: T.inner_meterialInfo?.MTRL_CD
          }] : [(() => {
            const S = m(n.pdtCode, T.sizeInfo?.cutSize?.width, T.sizeInfo?.workSize?.width, T),
              R = m(n.pdtCode, T.sizeInfo?.cutSize?.height, T.sizeInfo?.workSize?.height, T);
            return {
              PDT_CD: Hh(n.pdtCode, T),
              MTRL_CD: T.meterialInfo?.MTRL_CD,
              CUT_WDT: S.cut,
              CUT_HGH: R.cut,
              WRK_WDT: S.wrk,
              WRK_HGH: R.wrk,
              PRN_CNT: n.pdtCode === "GSELGLV" ? (T.quantityInfo?.prnCnt ?? 0) * 10 : T.quantityInfo?.prnCnt,
              ORD_CNT: T.quantityInfo?.ordCnt,
              DOSU_COD: T.dosuInfo?.COD,
              PRN_CLR_CNT: T.dosuInfo?.PRN_CLR_CNT,
              ADD_CLR_YN: T.dosuInfo?.ADD_CLR_YN,
              ...(T.addOptionInfo ? {
                PACK_PRN_CNT: T.addOptionInfo.PACK_PRN_CNT
              } : {}),
              ...(u.value === "clothes2025_item" ? {
                PRINT_TYPE: T.clothesSelectData.printType?.COD
              } : {}),
              ...(n.pdtCode === "GSTRTAG" ? {
                TMPL_IDX: T.shapeInfo?.COD === "large" ? 14 : T.shapeInfo?.COD === "small" ? 11 : void 0
              } : {})
            };
          })()];
          h.value = {
            ORD_INFO: C,
            PCS_INFO: g,
            price_gbn: f.value,
            mb_cust_cod: v?.mb_cust_cod || "10000000"
          };
        }
        const N = Ve(),
          I = Mo(),
          w = ra(),
          A = Te("editorData", null);
        U(() => A, T => {
          if (!T?.editingYn || T.editingYn !== "Y") return;
          if (n.pdtCode.startsWith("ST") && T.type === "KOI") {
            const L = I.getOrderData()?.pcsInfo ?? [],
              G = L.some(K => K.PCS_CD === "SCO_DFT" && K.VIEW_YN === "Y"),
              X = L.some(K => K.PCS_CD === "PRT_WHT" && K.VIEW_YN === "Y");
            if (G || X) {
              const K = (T.docInfo?.layerList ?? []).map(be => be.layer).filter(Boolean);
              if (G && !K.includes("Scodix") || X && !K.includes("White") || !G && K.includes("Scodix") || !X && K.includes("White")) {
                alert(F("에디터-레이어-후가공-불일치", {
                  FINISHING: G && X ? "부분UV/화이트" : G ? "부분UV" : "화이트"
                }));
                return;
              }
            }
          }
          if (n.pdtCode === "FBPOCHR" && T.type === "KOI") {
            const L = {
                reflect: "ST001",
                "glitter-holo-silver": "ST002",
                "holo-silver": "ST003",
                "holo-gold": "ST004"
              },
              G = T.docInfo?.foilList ?? [],
              X = G.find(de => de.used),
              K = X ? L[X.name] ?? null : null;
            console.log("[FBPOCHR/foil] Common.vue foilList:", G, "/ matched:", K), N.setFoilPcsDtlCd(K);
          }
          const g = w.getProductBaseInfo(),
            C = I.getOrderData()?.sizeInfo?.DIV_NM,
            S = I.getOrderData()?.shapeInfo?.COD,
            R = {
              pdtCode: n.pdtCode,
              ...T
            },
            E = T.type === "RP" ? Vh(R) : Wh(R, g, C, S);
          E && N.setEditorData(E);
        }, {
          deep: !0
        });
        function j(T) {
          if (!o.value?.result) return;
          const {
              sizeInfo: g,
              pcsInfo: C,
              meterialInfo: S,
              dosuInfo: R,
              quantityInfo: E,
              clothesSelectData: L,
              calendarInfo: G,
              acrylicSelectData: X,
              priceCalc: K,
              addOptionInfo: de
            } = T,
            {
              pdt_base_info: be,
              pdt_mtrl_info: xe,
              pdt_pcs_info: ee
            } = o.value.result.product_data,
            M = {
              lang_cod: t.locale,
              pdt_cod: n.pdtCode,
              PDT_NM: be[0].PDT_NM,
              sizeInfo: g,
              pcsInfo: C,
              meterialInfo: S,
              dosuInfo: R,
              quantityInfo: E,
              clothesSelectData: L,
              calendarInfo: G,
              acrylicSelectData: X,
              base: {
                item_gbn: u.value || "",
                koi_template_resource_id: l.value?.koi_template_resource_id || "",
                koiOption: l.value?.koiOption,
                pdt_mtrl_info: u.value === "clothes2025_item" ? [...xe] : [],
                pdt_pcs_info: u.value === "clothes2025_item" ? [...ee] : []
              },
              seneca_info: K?.result.seneca_info,
              addOptionInfo: de
            };
          N.setPayloadForEditorConfig(M);
        }
        function B(T) {
          p.value = T, D(T);
        }
        return U(() => h.value, an(T => {
          if (rn(T)) return;
          const g = T.ORD_INFO?.[0];
          !g?.PRN_CNT || !g?.CUT_WDT || !g?.CUT_HGH || r(T);
        }, 200)), U(() => a.value, T => {
          if (p.value && T?.result) {
            const g = {
                ...p.value,
                priceCalc: {
                  params: h.value,
                  result: T.result
                }
              },
              C = (() => {
                const E = $P.has(n.pdtCode) && g.dosuInfo && g.meterialInfo ? {
                  ...g,
                  inner_dosuInfo: g.dosuInfo,
                  inner_meterialInfo: g.meterialInfo
                } : g;
                if (n.pdtCode === "GSELGLV" && E.quantityInfo) {
                  const L = (E.quantityInfo.prnCnt ?? 0) * 10;
                  return {
                    ...E,
                    quantityInfo: {
                      ...E.quantityInfo,
                      prnCnt: L
                    },
                    pcsInfo: E.pcsInfo?.map(G => G.PCS_CD === "DIR_MTR" ? {
                      ...G,
                      selectedOptions: G.selectedOptions.map(X => ({
                        ...X,
                        ATTB: L
                      }))
                    } : G)
                  };
                }
                if (n.pdtCode === "TPTKDFT") {
                  const L = new Set(["EN001", "EN002", "EN003", "EN004"]);
                  return {
                    ...E,
                    pcsInfo: E.pcsInfo?.map(G => G.PCS_CD === "SUB_MTR" ? {
                      ...G,
                      selectedOptions: G.selectedOptions.map(X => L.has(X.PCS_DTL_CD) ? {
                        ...X,
                        ATTB: (X.ATTB ?? 0) * 10
                      } : X)
                    } : G)
                  };
                }
                return E;
              })(),
              S = l.value ? {
                pdtCode: n.pdtCode,
                option: l.value,
                editorData: N.editorData
              } : null,
              R = S ? HP(C, S) : null;
            I.setOrderData(C, R), i?.onPriceChange && i.onPriceChange(T.result.result_sum), j(C);
          }
        }), U(() => o.value, T => {
          T?.result && w.setProductBaseInfo(T.result);
        }), U(() => s.value, T => {
          if (T && !(typeof i.onMounted > "u")) return o.value?.errorMessage && typeof i.onError < "u" ? (i.onError(o.value.errorMessage), i.onMounted(!1)) : i.onMounted(!0);
        }), (T, g) => (_(), O("div", YP, [y(s) && u.value ? (_(), O("div", QP, [(_(), V(jo(d[u.value]?.component || c.component), {
          data: y(o)?.result?.product_data,
          "widget-attr": l.value,
          "seneca-info": y(a)?.result?.seneca_info,
          onUpdate: B
        }, null, 40, ["data", "widget-attr", "seneca-info"]))])) : (_(), V(Lh, {
          key: 1,
          group: u.value
        }, null, 8, ["group"])), ne(OP)]));
      }
    }),
    XP = {
      class: "widget-container"
    },
    ZP = {
      key: 0,
      class: "widget-body acc"
    },
    JP = oe({
      __name: "Acc",
      setup(e) {
        const t = _t(),
          n = Te("productCode", {
            pdtCode: ""
          }),
          {
            data: o,
            isFetchedAfterMount: s
          } = g_({
            queryKey: ["product/get", n.pttCode ? `${n.pdtCode}/${n.pttCode}` : n.pdtCode],
            queryFn: () => wh(t.locale, n.pdtCode, n.pttCode),
            enabled: b(() => !!n?.pdtCode),
            refetchOnWindowFocus: !1
          }),
          {
            data: a,
            mutate: r
          } = y_({
            mutationKey: ["price/get"],
            mutationFn: D => ru({
              type: "ACC",
              body: D
            })
          }),
          i = Te("callbacks", {}),
          l = b(() => o.value?.result?.product_option.option),
          u = H(),
          c = b(() => l.value?.price_gbn || "tmpl_price"),
          d = Te("member"),
          p = H({
            ORD_INFO: [],
            PCS_INFO: [],
            price_gbn: c.value,
            mb_cust_cod: d?.mb_cust_cod || "10000000",
            mb_id: d?.mb_id
          });
        function f(D) {
          p.value = {
            ORD_INFO: [{
              PDT_CD: n.pdtCode,
              TMPL_NUM: n.pttCode
            }],
            PCS_INFO: D,
            price_gbn: c.value,
            mb_cust_cod: d?.mb_cust_cod || "10000000"
          };
        }
        function v(D) {
          u.value = D, f(D);
        }
        U(() => p.value, D => {
          rn(D) || r(D);
        });
        const h = du();
        U(() => a.value, D => {
          if (u.value && D?.result) {
            const N = {
              subMtrlInfo: u.value,
              priceCalc: {
                params: p.value,
                result: D.result
              }
            };
            h.setOrderData(N), i?.onPriceChange && i.onPriceChange(D.result.result_sum);
          }
        });
        const m = ra();
        return U(() => o.value, D => {
          D?.result && m.setProductBaseInfo(D.result);
        }), (D, N) => (_(), O("div", XP, [y(s) ? (_(), O("div", ZP, [y(o)?.result?.product_data.pdt_sub_mtrl_info ? (_(), V(jo($n(() => Promise.resolve().then(() => rR))), {
          key: 0,
          data: y(o)?.result?.product_data.pdt_sub_mtrl_info,
          onUpdate: v
        }, null, 40, ["data"])) : J("", !0)])) : (_(), V(Lh, {
          key: 1,
          group: "vSubMtrl_item"
        }))]));
      }
    }),
    e0 = new Set(["GSSBMTL", "GSSBSTP", "GSSBACM"]),
    jh = {
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
    Cu = {
      SUB_MTR: ["SUB_MTR_BC", "SUB_MTR_LW"],
      DIR_MTR: ["DIR_MTR_JT"],
      WRK_MTR: ["WRK_MTR_BP", "WRK_MTR_PB"],
      LIN_DFT: [],
      POL_BAG: [],
      TON_WOD: []
    },
    Tu = {
      LIN_DFT_LN: "icon",
      SUB_MTR_CB: "icon",
      POL_BAG_PO: "icon",
      POL_BAG_HL: "icon",
      TON_WOD_WD: "icon",
      SUB_MTR_EN: "icon",
      SUB_MTR_CA: "icon"
    },
    gu = {
      SUB_MTR_CB: "CB001"
    },
    zh = new Set(["GSNTMIS"]),
    t0 = new Set(["SKTHDFT"]),
    n0 = new Set(["SKTHDFT", "SKCUDFT"]),
    o0 = new Set(["PRPOSTK", "PRPOXXX", "BCSPDFT", "BCSPHIG", "BCKMHIG", "BCKMHVY", "BCKMSND", "GSELBHD"]),
    s0 = {
      FLD_DFT: ["THO_GRA", "LAM_DFT"],
      THO_GRA: ["FLD_DFT"],
      LAM_DFT: ["MIS_DFT", "OSI_DFT", "COT_DFT", "FOI_DFT", "FLD_DFT", "ROU_DFT", "PRT_MAG"],
      MIS_DFT: ["LAM_DFT"],
      OSI_DFT: ["LAM_DFT"],
      COT_DFT: ["LAM_DFT"],
      FOI_DFT: ["LAM_DFT"],
      ROU_DFT: ["LAM_DFT"],
      PRT_MAG: ["LAM_DFT"]
    },
    Kh = new Set(["FLD_DFT", "HOL_DFT", "MIS_DFT", "OSI_DFT", "THO_GRA", "PRT_MAG"]),
    a0 = new Set(["PHSTPAN", "PHSTNOP", "PHSTSQP", "STTHUSR", "GSNTPVC"]),
    Yh = {},
    i0 = {
      POL_BAG_PO: "POL_BAG",
      POL_BAG_HL: "POL_BAG"
    },
    r0 = {
      POL_BAG: {
        ko: "폴리백",
        en: "Poly Bag"
      }
    },
    l0 = {
      GSLPPRT: {
        PDT_WRK: ["SUB_MTR"],
        SUB_MTR: ["PDT_WRK"]
      },
      GSLPSTK: {
        PDT_WRK: ["SUB_MTR"],
        SUB_MTR: ["PDT_WRK"]
      }
    },
    u0 = {
      STDRCAD: {
        name: "세트",
        qtyPerSet: 2
      },
      STTBDFT: {
        name: "세트",
        qtyPerSet: e => [1, 2, 3].includes(e) ? 10 : 5
      },
      TPCAPTW: {
        name: "세트",
        qtyPerSet: 20
      },
      GSELGLV: {
        name: "묶음",
        qtyPerSet: 10
      }
    },
    c0 = ["red-mobile", "red-pc"];
  class d0 {
    constructor(t) {
      this.pdtCode = t.pdtCode;
    }
    pdtCode = "";
    editorStore = Ve();
    orderStore = Mo();
    productStore = ra();
    getProductBaseInfo() {
      return this.productStore.getProductBaseInfo();
    }
    getOrderData() {
      const t = this.orderStore.getOrderData();
      if (!t) return t;
      const n = Hh(this.pdtCode, t);
      return n === this.pdtCode ? t : {
        ...t,
        priceCalc: t.priceCalc ? {
          ...t.priceCalc,
          params: {
            ...t.priceCalc.params,
            ORD_INFO: t.priceCalc.params.ORD_INFO.map((o, s) => s === 0 ? {
              ...o,
              PDT_CD: n
            } : o)
          }
        } : t.priceCalc
      };
    }
    getSummary() {
      const t = this.getProductBaseInfo(),
        n = this.getOrderData(),
        o = t?.product_option.option.item_gbn,
        s = n?.acrylicSelectData,
        a = n?.clothesSelectData,
        r = s ? {
          ...(s.printData ? {
            printData: {
              label: "인쇄 데이터",
              value: s.printData.COD_NME
            }
          } : {}),
          ...(s.productionMethod ? {
            productionMethod: {
              label: "제작방식",
              value: s.productionMethod.COD_NME
            }
          } : {}),
          ...(s.shapeInfo ? {
            shape: {
              label: "모양",
              value: s.shapeInfo.COD_NME
            }
          } : {})
        } : null,
        i = a ? {
          ...(a.PrintAreaInfo ? {
            printArea: {
              label: "인쇄 영역",
              value: a.PrintAreaInfo.map(I => I.COD_NME).join("/")
            }
          } : {}),
          ...(a.colorInfo ? {
            color: {
              label: "의류 컬러",
              value: a.colorInfo.COD_NME
            }
          } : {}),
          ...(a.pantoneInfo ? {
            pantoneColor: {
              label: "인쇄 컬러(팬톤)",
              value: a.pantoneInfo.pantone_name
            }
          } : {}),
          ...(a.sizeInfo ? {
            size: {
              label: "사이즈",
              value: a.sizeInfo.map(I => `${I.size.COD_NME}(${I.quantity}장)`).join(", ")
            }
          } : {}),
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
              value: n?.inner_meterialInfo.PTT_NM + `${n?.inner_meterialInfo.WGT_CD ? `${+n?.inner_meterialInfo.WGT_CD}g` : ""}`
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
        u = n?.calendarInfo ? {
          calendarSetting: {
            label: "시작년도/월",
            value: `${n.calendarInfo.year}년 ${n.calendarInfo.month}월`
          }
        } : null,
        c = t?.product_option.option.skinInfo,
        d = n?.sizeInfo.DIV_NM === "사이즈직접입력" || n?.sizeInfo.DIV_NM === "Input Size",
        p = n?.sizeInfo.DIV_SEQ ? d ? `${n.sizeInfo.cutSize.width}mm X ${n.sizeInfo.cutSize.height}mm` : n?.sizeInfo.DIV_NM : null,
        f = c?.quantityGroup.view_yn === "Y" ? n?.quantityInfo.ordCnt : null,
        v = c?.quantityGroup.view_yn === "Y" ? n?.quantityInfo.prnCnt : null,
        h = fu[this.pdtCode] === "SetQty" ? (this.editorStore.editorData.default?.cntInfo?.totalCnt || 1) / (this.editorStore.editorData.default?.cntInfo?.initCnt || 1) : 0,
        m = n?.pcsInfo.reduce((I, w) => {
          const {
            VIEW_YN: A,
            PCS_GRP_NM: j,
            selectedOptions: B
          } = w;
          if (A === "Y" && j && B[0].PCS_DTL_NM) {
            const T = I[j];
            T ? T.push(B[0].PCS_DTL_NM) : I[j] = [B[0].PCS_DTL_NM];
          }
          return I;
        }, {}),
        D = m ? Object.entries(m).map(([I, w]) => ({
          label: I,
          value: w.join(", ")
        })) : null;
      return {
        ...r,
        ...(!l && c?.paperSelect.view_yn === "Y" ? {
          material: {
            label: n?.meterialInfo.MTRL_TYPE === "R" ? "용지" : "자재",
            value: n?.meterialInfo.MTRL_NM
          }
        } : {}),
        ...(c?.sizeSelect.view_yn === "Y" && p && n?.dosuInfo.PRN_CLR_CNT !== 0 ? {
          size: {
            label: "사이즈",
            value: p
          }
        } : {}),
        ...u,
        ...i,
        ...l,
        ...(D && D.length > 0 ? {
          postPcs: {
            label: "후가공/부자재",
            children: D
          }
        } : {}),
        ...(!l && !i ? {
          ...(h ? {
            setCnt: {
              label: "세트",
              value: h
            }
          } : {
            ordCnt: {
              label: "디자인 수(건수)",
              value: f
            }
          }),
          prnCnt: {
            label: "수량",
            value: v
          }
        } : {})
      };
    }
    setEditorData(t) {
      if (console.log("[FBPOCHR/foil] setEditorData called / pdtCode:", this.pdtCode, "/ type:", t?.type), !t) return this.editorStore.setEditorData(null);
      if (this.pdtCode.startsWith("ST") && t.type === "KOI") {
        const i = this.orderStore.getOrderData()?.pcsInfo ?? [],
          l = i.some(c => c.PCS_CD === "SCO_DFT" && c.VIEW_YN === "Y"),
          u = i.some(c => c.PCS_CD === "PRT_WHT" && c.VIEW_YN === "Y");
        if (l || u) {
          const c = (t.docInfo.layerList ?? []).map(f => f.layer).filter(Boolean),
            d = c.includes("Scodix");
          if (c.includes("White"), l && !d || !l && d) {
            alert(F("에디터-레이어-후가공-불일치", {
              FINISHING: l && u ? "부분UV/화이트" : l ? "부분UV" : "화이트"
            }));
            return;
          }
        }
      }
      if (["STTHUSR", "STPADIY"].includes(this.pdtCode) && t.type === "KOI") {
        const l = (this.orderStore.getOrderData()?.meterialInfo?.MTRL_CD ?? "").includes("NAP") ? 21 : 11,
          c = (t.docInfo.pageInfos?.[0]?.sticutBounds_mm ?? []).filter(d => d.width < l || d.height < l).length;
        if (c > 0) {
          alert(F("자유형스티커-최소크기오류", {
            MIN: String(l),
            COUNT: String(c)
          }));
          return;
        }
      }
      if (this.pdtCode === "FBPOCHR" && t.type === "KOI") {
        const i = {
            reflect: "ST001",
            "glitter-holo-silver": "ST002",
            "holo-silver": "ST003",
            "holo-gold": "ST004"
          },
          l = t.docInfo?.foilList ?? [],
          u = l.find(d => d.used),
          c = u ? i[u.name] ?? null : null;
        console.log("[FBPOCHR/foil] foilList:", l, "/ usedFoil:", u?.name, "/ matchedDtlCd:", c), this.editorStore.setFoilPcsDtlCd(c);
      }
      const n = {
          pdtCode: this.pdtCode,
          ...t
        },
        o = this.getProductBaseInfo(),
        s = this.orderStore.getOrderData()?.sizeInfo?.DIV_NM,
        a = this.orderStore.getOrderData()?.shapeInfo?.COD,
        r = n.type === "KOI" ? Wh(n, o, s, a) : Vh(n);
      r ? this.editorStore.setEditorData(r) : console.error(`[RedWidgetSDK/ERROR] 에디터에서 온 데이터가 없습니다 > 받은 데이터: ${t}`);
    }
    canOrder() {
      try {
        const t = this.getProductBaseInfo(),
          n = this.getOrderData();
        if (t?.product_option.option.order_yn === "N") throw new Error(F("주문불가상태"));
        if (n?.validation && n.validation.length > 0) throw new Error(n.validation[0]);
        if (n?.priceCalc.result.retCode !== 200 || !n.priceCalc.result.result_sum.PRICE) throw new Error(F("주문불가-가격"));
        const o = n.priceCalc.result.result_check_orderable;
        if (o && o.retCode !== 200 && o.msg) throw new Error(o.msg);
        const s = t?.product_option.option.item_gbn,
          a = this.editorStore.uploadType,
          r = n?.fileUploadInfo;
        if (s === "book2025_item") {
          for (const [c, d] of Object.entries(a)) {
            const p = F(c === "inner" ? "내지" : "표지");
            if (d === "editor" && !this.editorStore.isAfterEdit(c)) throw new Error(`[${p}] ${F("주문불가-에디터")}`);
            if (d === "pdf") {
              if (!r) throw new Error(`[${p}] ${F("주문불가-파일")}`);
              if (c === "inner" && !r[0]) throw new Error(`[${p}] ${F("주문불가-파일")}`);
              if (c === "default" && !r[1]) throw new Error(`[${p}] ${F("주문불가-파일")}`);
            }
          }
          if (r && r[0] && r[1] && r[0].org_file_nm === r[1].org_file_nm) throw new Error(F("주문불가-파일명중복"));
          return {
            success: !0
          };
        }
        if (a.default === "pdf") {
          if (!r || !r[0]) throw new Error(F("주문불가-파일"));
          if (s === "clothes2025_item" && n.clothesSelectData.printType.COD === "PTP_SLK" && !n?.clothesSelectData.pantoneInfo) throw new Error(F("주문불가-인쇄컬러미선택"));
        }
        if (s === "clothes2025_item" && !n?.clothesSelectData.printType.COD) return {
          success: !0
        };
        if (a.default === "editor" && !this.editorStore.isAfterEdit() && n.dosuInfo.COD !== "SID_X") throw new Error(F("주문불가-에디터"));
        const i = n?.pcsInfo.find(c => c.PCS_CD === "NUM_DFT");
        if (i) {
          const c = i.selectedOptions[0]?.ATTB;
          if (!c || !String(c).includes("~")) throw new Error(F("주문불가-번호인쇄"));
        }
        const l = n?.pcsInfo.find(c => c.PCS_CD === "PRT_SID");
        if (l) {
          const c = l.selectedOptions[0];
          if (c?.PCS_DTL_CD === "PT005" && !c.ATTB) throw new Error(F("주문불가-PRT_SID-색상미선택"));
        }
        const u = this.orderStore.getUserDoubleConfirmed();
        if (t0.has(this.pdtCode) && !u) throw new Error(F("주문불가-재확인"));
        return {
          success: !0
        };
      } catch (t) {
        let n = F("주문불가상태");
        return t instanceof Error && (n = t.message), {
          success: !1,
          errorMessage: n
        };
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
              pdt_pcs_info: a
            }
          } = n;
        if (s) {
          const r = t.PAGES.map(C => ({
              PCS_COD: "PDT_WRK",
              PCS_DTL_COD: s.print_area.find(R => R.KOI_NME === C)?.COD || ""
            })),
            i = a.find(C => C.MTRL_CD === t.MTRL_COD);
          if (!i) throw new Error("선택된 제품 자재 코드가 없습니다.");
          const l = {
              PCS_COD: i.PCS_CD,
              PCS_DTL_COD: i.PCS_DTL_CD,
              ATTB: o?.quantityInfo.prnCnt
            },
            c = this.getOrderData()?.priceCalc.params;
          if (!c) throw new Error("이전 가격 페이로드 가져오기 실패");
          const p = [{
              ...c.ORD_INFO[0],
              MTRL_CD: t.MTRL_COD
            }],
            v = [...c.PCS_INFO.filter(C => C.PCS_COD !== "DIR_MTR" && C.PCS_COD !== "PDT_WRK"), ...r, l],
            h = {
              ...c,
              ORD_INFO: p,
              PCS_INFO: v
            },
            m = await ru({
              type: "COMMON",
              body: h
            });
          if (m.errorMessage || !m.result) throw new Error(m.errorMessage);
          const {
            ORG_PRICE: D,
            ORG_PRICE_VAT: N,
            PRICE: I,
            PRICE_VAT: w,
            PRICE_MALL: A,
            PRICE_MALL_VAT: j
          } = m.result.result_sum;
          return {
            type: "PRICE",
            data: I !== A ? A + j : D !== I ? I + w : D + N
          };
        }
      } catch (n) {
        return console.error("[RedWidgetSDK/ERROR] 코이에디터 데이터 산정 실패 > ", n), {
          errorMessage: "데이터 산정 실패"
        };
      }
    }
  }
  class f0 {
    constructor(t) {
      this.pdtCode = t.pdtCode;
    }
    pdtCode = "";
    orderStore = du();
    productStore = ra();
    getProductBaseInfo() {
      return this.productStore.getProductBaseInfo();
    }
    getOrderData() {
      return this.orderStore.getOrderData();
    }
    getSummary() {
      const t = this.getProductBaseInfo(),
        n = this.getOrderData();
      if (!n?.subMtrlInfo) return {
        errorMessage: F("주문불가-옵션미선택")
      };
      const o = [];
      let s = 0;
      for (const c of n.subMtrlInfo) o?.push({
        label: c.MTRL_NME,
        value: c.QTY
      }), s += c.QTY;
      const a = n.priceCalc.result.result_sum,
        r = a.PRICE !== a.PRICE_MALL,
        i = a.ORG_PRICE !== a.PRICE,
        l = r ? a.PRICE_MALL + a.PRICE_MALL_VAT : i ? a.PRICE + a.PRICE_VAT : a.ORG_PRICE + a.ORG_PRICE_VAT;
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
      };
    }
    canOrder() {
      try {
        if (this.getProductBaseInfo()?.product_option.option.order_yn === "N") throw new Error(F("주문불가상태"));
        const n = this.getOrderData();
        if (!n?.subMtrlInfo) throw new Error(F("주문불가-옵션미선택"));
        if (!n?.priceCalc.result.result_sum.PRICE) throw new Error(F("주문불가-가격"));
        return {
          success: !0
        };
      } catch (t) {
        let n = F("주문불가상태");
        return t instanceof Error && (n = t.message), {
          success: !1,
          errorMessage: n
        };
      }
    }
  }
  function p0(e, t) {
    return new Promise(n => {
      const o = document.createElement("link");
      o.rel = "stylesheet", o.href = t, o.onload = () => n(), o.onerror = () => n(), e.appendChild(o);
    });
  }
  class _0 {
    clientKey = null;
    constructor(t) {
      if (!c0.includes(t)) throw new Error("존재하지 않는 사용자입니다");
      this.clientKey = t;
    }
    init(t, n) {
      const {
          target: o,
          pdtCode: s,
          pttCode: a,
          locale: r = "ko",
          member: i,
          deviceType: l = "pc"
        } = t,
        u = document.querySelector(o);
      if (!u) throw new Error("주문위젯을 띄울 요소를 찾을 수 없습니다");
      const c = u.attachShadow({
          mode: "open"
        }),
        d = document.createElement("div");
      d.id = "red-widget-root", c.appendChild(d);
      const p = !e0.has(s),
        f = Zd(p ? qP : JP);
      if (!s) throw new Error("제품 코드를 설정해주세요");
      if (!["ko", "en"].includes(r)) throw new Error("지원하지 않는 언어입니다");
      if (f.use(uD()), f.use(VD), f.use(vS), _t().setLocale(r), f.provide("deviceType", l), f.provide("productCode", {
        pdtCode: s,
        pttCode: a
      }), f.provide("callbacks", n), f.provide("member", i ? Xe(i) : void 0), p) {
        const N = Xe({
          editingYn: "N"
        });
        f.provide("editorData", N);
      }
      const h = "prod",
        m = new Date().toISOString().replace(/[-:.TZ]/g, "").slice(0, 14);
      return p0(c, `https://d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/${h}/widget.css?${m}`).then(() => f.mount(d)), p ? new d0(t) : new f0(t);
    }
  }
  window.RedWidgetSDK = _0, console.log("RedWidgetSDK v0.978");
  const yu = (e, t, n) => {
      const o = e[t];
      return o ? typeof o == "function" ? o() : Promise.resolve(o) : new Promise((s, a) => {
        (typeof queueMicrotask == "function" ? queueMicrotask : setTimeout)(a.bind(null, new Error("Unknown variable dynamic import: " + t + (t.split("/").length !== n ? ". Note that variables only represent file names one level deep." : ""))));
      });
    },
    h0 = {
      class: "subject"
    },
    ve = Ne(oe({
      __name: "OptionRow",
      props: {
        title: {},
        extra: {},
        priority: {},
        underline: {
          type: Boolean
        },
        rowClass: {}
      },
      setup(e) {
        return (t, n) => (_(), O("fieldset", {
          class: $e(["option-row", t.rowClass]),
          style: mt(t.priority ? {
            order: t.priority
          } : null)
        }, [t.title ? (_(), O("legend", {
          key: 0,
          class: $e(["title", {
            underline: t.underline
          }])
        }, [P("span", h0, Y(y(F)(t.title)), 1), t.extra ? (_(), O("button", {
          key: 0,
          type: "button",
          class: $e(["extra-btn", t.extra.style]),
          onClick: n[0] || (n[0] = (...o) => t.extra.callback && t.extra.callback(...o))
        }, Y(y(F)(t.extra.name)), 3)) : J("", !0)], 2)) : J("", !0), or(t.$slots, "default", {}, void 0, !0)], 6));
      }
    }), [["__scopeId", "data-v-595f7226"]]),
    v0 = {
      class: "icon-wrap"
    },
    m0 = ["src", "alt"],
    C0 = ["title"],
    T0 = {
      key: 0,
      class: "pc-tip"
    },
    g0 = ["src", "alt", "data-idx"],
    Be = Ne(oe({
      __name: "ImageButton",
      props: {
        data: {},
        active: {
          type: Boolean
        },
        disabled: {
          type: Boolean
        },
        disabledStyling: {
          type: Boolean
        },
        tip: {},
        forceHidden: {
          type: Boolean
        }
      },
      emits: ["select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("deviceType", "pc"),
          a = b(() => n.data.forcedImg ? n.data.imgPath : `${ut}/ordericon/${n.data.imgPath}.png`),
          r = b(() => `${ut}/ordericon/${n.data.subImgPath}.png`);
        function i() {
          n.disabled || o("select", n.data);
        }
        function l(u) {
          const c = u.target;
          c && (c.src = r.value, c.onerror = () => {
            c.src = `${ut}/ordericon/order_icon1-3.png`;
          });
        }
        return (u, c) => re((_(), O("div", {
          onClick: i,
          class: $e(["icon-checkbox", {
            disabled: u.disabledStyling && u.disabled
          }]),
          style: mt(u.data.order ? {
            order: u.data.order
          } : null)
        }, [P("div", {
          class: $e(["icon-label", {
            active: u.active
          }])
        }, [P("div", v0, [P("img", {
          src: a.value,
          alt: u.data.name,
          onError: l
        }, null, 40, m0)])], 2), P("span", {
          class: "icon-name",
          title: y(F)(u.data.name)
        }, Y(y(F)(u.data.name)), 9, C0), (!y(s) || y(s) === "pc") && u.tip ? (_(), O("div", T0, [(_(), O("img", {
          src: u.tip.IMG_URL,
          alt: u.tip.IMG_ALT,
          key: u.tip.IDX,
          "data-idx": u.tip.IDX
        }, null, 8, g0))])) : J("", !0), or(u.$slots, "input", {}, void 0, !0)], 6)), [[Lt, !u.forceHidden]]);
      }
    }), [["__scopeId", "data-v-35b4120f"]]),
    y0 = {
      class: "flex-row"
    },
    Qh = oe({
      __name: "PageDirection",
      props: {
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("callbacks", {}),
          r = [{
            value: "W",
            name: "가로",
            imgPath: "order_icon1-3"
          }, {
            value: "H",
            name: "세로",
            imgPath: "order_icon1-2"
          }],
          i = H("W");
        U(() => n.relatedData.firstSize, c => {
          c && (i.value = +c.CUT_WDT < +c.CUT_HGH ? "H" : "W");
        }, {
          immediate: !0
        });
        const l = () => {
          a?.onReset && a.onReset("direction");
        };
        U(() => i.value, c => {
          s.isAfterEdit() && l(), o("update", {
            COD: i.value,
            COD_NME: F(c === "H" ? "세로" : "가로")
          });
        }, {
          immediate: !0
        });
        const u = b(() => {
          if (!n.relatedData.sizeInfo) return;
          const {
            DIV_NM: c,
            cutSize: d
          } = n.relatedData.sizeInfo;
          if (c === "사이즈직접입력" || c === "Input Size") {
            if (d.height > d.width) return "H";
            if (d.height === d.width) return i.value;
            if (d.height < d.width) return "W";
          }
        });
        return U(() => u.value, c => {
          c && (i.value = c);
        }, {
          immediate: !0
        }), (c, d) => (_(), V(ve, {
          title: "주문서작성"
        }, {
          default: fe(() => [P("div", y0, [(_(), O(q, null, ce(r, p => ne(Be, {
            key: p.value,
            data: p,
            active: i.value === p.value,
            disabled: u.value && u.value !== p.value,
            "disabled-styling": !!u.value,
            onSelect: d[0] || (d[0] = f => i.value = f.value)
          }, null, 8, ["data", "active", "disabled", "disabled-styling"])), 64))])]),
          _: 1
        }));
      }
    }),
    D0 = {},
    S0 = {
      width: "11",
      height: "11",
      viewBox: "0 0 11 11",
      fill: "none",
      xmlns: "http://www.w3.org/2000/svg"
    };
  function P0(e, t) {
    return _(), O("svg", S0, [...(t[0] || (t[0] = [P("path", {
      d: "M6.45182 8.66273C7.95026 8.02116 9.0001 6.53317 9.0001 4.79998C9.0001 2.48038 7.11969 0.599976 4.8001 0.599976C2.4805 0.599976 0.600098 2.48038 0.600098 4.79998C0.600098 7.11957 2.4805 8.99998 4.8001 8.99998",
      stroke: "white",
      "stroke-width": "1.2",
      "stroke-linecap": "round"
    }, null, -1), P("path", {
      d: "M8.16007 8.16L10.4001 10.4",
      stroke: "white",
      "stroke-width": "1.2",
      "stroke-linecap": "round"
    }, null, -1)]))]);
  }
  const b0 = Ne(D0, [["render", P0]]),
    O0 = ["disabled", "onClick"],
    E0 = {
      key: 0,
      class: "mobile-tip"
    },
    I0 = {
      key: 0,
      class: "pc-tip"
    },
    R0 = ["src", "alt", "data-idx"],
    ln = Ne(oe({
      __name: "ButtonRadio",
      props: {
        options: {},
        default: {},
        tips: {},
        type: {
          default: "md"
        }
      },
      emits: ["select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("deviceType", "pc"),
          a = H(n.default || n.options[0].value),
          r = i => {
            a.value = i, o("select", i);
          };
        return U(() => n.default, i => {
          i && (a.value = i);
        }), (i, l) => (_(), O("div", {
          class: $e(["button-radio", i.type])
        }, [(_(!0), O(q, null, ce(i.options, (u, c) => (_(), O("button", {
          type: "button",
          key: u.key,
          class: $e([{
            active: u.disabled ? !1 : a.value === u.value
          }]),
          disabled: u.disabled,
          onClick: d => r(u.value)
        }, [yo(Y(u.name) + " ", 1), y(s) === "mobile" && i.tips && i.tips[c] ? (_(), O("span", E0, [ne(b0)])) : J("", !0)], 10, O0))), 128)), i.tips && (!y(s) || y(s) === "pc") ? (_(), O("div", I0, [(_(!0), O(q, null, ce(i.tips, u => (_(), O(q, null, [u ? (_(), O("img", {
          src: u.IMG_URL,
          alt: u.IMG_ALT,
          key: u.IDX,
          "data-idx": u.IDX
        }, null, 8, R0)) : J("", !0)], 64))), 256))])) : J("", !0)], 2));
      }
    }), [["__scopeId", "data-v-29046352"]]),
    N0 = ["name"],
    A0 = ["value", "disabled"],
    rs = oe({
      __name: "Selector",
      props: {
        name: {},
        options: {},
        default: {}
      },
      emits: ["select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(n.default || n.options[0].value);
        return U(() => s.value, a => {
          o("select", a);
        }), U(() => n.default, a => {
          a && (s.value = a);
        }), (a, r) => re((_(), O("select", {
          "onUpdate:modelValue": r[0] || (r[0] = i => s.value = i),
          name: a.name,
          class: "basic-select"
        }, [(_(!0), O(q, null, ce(a.options, i => (_(), O("option", {
          key: `${i.key}`,
          value: i.value,
          disabled: i.disabled
        }, Y(i.name) + Y(i.disabled ? `(${y(F)("주문불가")})` : ""), 9, A0))), 128))], 8, N0)), [[Ke, s.value]]);
      }
    }),
    M0 = oe({
      __name: "MaterialFilters",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.options.MTRL_GRP),
          a = b(() => n.options.PTT_GRP),
          r = b(() => n.options.PTT),
          i = b(() => s.value?.optList.map(v => ({
            name: v.COD_NME,
            value: v.COD,
            key: v.COD
          }))),
          l = b(() => a.value?.optList.map(v => ({
            name: v.COD_NME,
            value: v.COD,
            key: v.COD
          }))),
          u = b(() => r.value.optList.filter(h => h.GRP_COD === d.value).map(h => ({
            name: h.COD_NME,
            value: h.COD,
            key: h.COD
          }))),
          c = H(s.value?.optList[0]?.COD),
          d = H(a.value?.optList[0]?.COD),
          p = H(u.value[0]?.value);
        U(() => u.value, v => {
          p.value = v[0].value;
        });
        const f = b(() => ({
          MTRL_GRP: c.value,
          PTT_GRP: d.value,
          PTT: p.value
        }));
        return U(() => f.value, v => {
          o("update", v);
        }, {
          immediate: !0
        }), (v, h) => (_(), O(q, null, [s.value && i.value ? (_(), V(ve, {
          key: 0,
          title: s.value.grpName
        }, {
          default: fe(() => [ne(ln, {
            options: i.value,
            default: c.value,
            onSelect: h[0] || (h[0] = m => c.value = m)
          }, null, 8, ["options", "default"])]),
          _: 1
        }, 8, ["title"])) : J("", !0), a.value && l.value ? (_(), V(ve, {
          key: 1,
          title: a.value.grpName
        }, {
          default: fe(() => [ne(ln, {
            options: l.value,
            default: d.value,
            onSelect: h[1] || (h[1] = m => d.value = m)
          }, null, 8, ["options", "default"])]),
          _: 1
        }, 8, ["title"])) : J("", !0), ne(ve, {
          title: r.value.grpName
        }, {
          default: fe(() => [u.value.length > 2 ? (_(), V(rs, {
            key: 0,
            name: "material-filter",
            options: u.value,
            default: p.value,
            onSelect: h[2] || (h[2] = m => p.value = m)
          }, null, 8, ["options", "default"])) : (_(), V(ln, {
            key: 1,
            options: u.value,
            default: p.value,
            onSelect: h[3] || (h[3] = m => p.value = m)
          }, null, 8, ["options", "default"]))]),
          _: 1
        }, 8, ["title"])], 64));
      }
    }),
    w0 = ["value"],
    L0 = oe({
      __name: "SetColor",
      props: {
        data: {},
        default: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = H(n.default || n.data.optList[0].COD),
          r = b(() => n.data.optList.find(u => u.COD === a.value)),
          i = Ve(),
          l = () => {
            s.onReset && s.onReset("color");
          };
        return U(() => r.value, u => {
          i.isAfterEdit() && l(), u && o("update", u);
        }, {
          immediate: !0
        }), (u, c) => (_(), V(ve, {
          title: "컬러"
        }, {
          default: fe(() => [re(P("select", {
            "onUpdate:modelValue": c[0] || (c[0] = d => a.value = d),
            class: "basic-select",
            name: "set-color"
          }, [(_(!0), O(q, null, ce(u.data.optList, d => (_(), O("option", {
            key: d.COD,
            value: d.COD
          }, Y(d.COD_NME), 9, w0))), 128))], 512), [[Ke, a.value]])]),
          _: 1
        }));
      }
    }),
    qh = oe({
      __name: "Shape",
      props: {
        options: {},
        default: {},
        disabledOptions: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.options.map(p => ({
            name: p.COD_NME,
            value: p.COD,
            key: p.COD,
            disabled: n.disabledOptions?.includes(p.COD)
          }))),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = b(() => a.pdtCode === "PHPLEDT" ? "모양-사이즈" : a.pdtCode === "STDRCAD" ? "종류" : a.pdtCode === "PRCAPPO" ? "칼선 타입" : "모양"),
          i = Ve(),
          l = Te("callbacks", {}),
          u = H(n.default || s.value[0].value),
          c = () => {
            l?.onReset && l.onReset("shape");
          },
          d = p => {
            i.isAfterEdit() && c(), u.value = p;
          };
        return U(() => u.value, p => {
          const f = n.options.find(v => v.COD === p);
          o("update", f);
        }, {
          immediate: !0
        }), U(() => n.disabledOptions, p => {
          if (!p?.includes(u.value)) return;
          const f = s.value.find(v => !v.disabled);
          f && (u.value = f.value);
        }), (p, f) => (_(), V(ve, {
          title: y(F)(r.value)
        }, {
          default: fe(() => [ne(ln, {
            options: s.value,
            default: u.value,
            onSelect: d
          }, null, 8, ["options", "default"])]),
          _: 1
        }, 8, ["title"]));
      }
    }),
    k0 = {
      class: "button-radio"
    },
    $0 = ["onClick"],
    F0 = {
      class: "notes"
    },
    U0 = {
      class: "note"
    },
    B0 = Ne(oe({
      __name: "AddOptionSize",
      props: {
        options: {},
        minPrnCntOverride: {}
      },
      emits: ["update", "update:prnCntOptions"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(n.options[0]?.PDT_VER_SIZE),
          a = l => {
            s.value = l;
          },
          r = b(() => n.options.find(l => l.PDT_VER_SIZE === s.value)),
          i = b(() => {
            const l = r.value;
            if (!l) return [];
            const u = l.MIN_ORD_PRN_CNT,
              c = l.ADD_ORD_PRN_CNT,
              d = n.minPrnCntOverride ?? u,
              p = n.minPrnCntOverride ?? c,
              f = 10,
              v = [];
            for (let h = 0; h < f; h++) v.push({
              PRN_CNT: u + c * h,
              MIN_PRN_CNT: d,
              INC_CNT: c,
              UNIT_PRN_CNT: p,
              DFT_YN: h === 0 ? "Y" : "N"
            });
            return v;
          });
        return U(() => r.value, l => {
          l && (o("update", l), o("update:prnCntOptions", i.value));
        }, {
          immediate: !0
        }), U(() => i.value, l => {
          o("update:prnCntOptions", l);
        }), (l, u) => {
          const c = it("dompurify-html");
          return _(), V(ve, {
            title: y(F)("떡메-사이즈")
          }, {
            default: fe(() => [P("div", k0, [(_(!0), O(q, null, ce(n.options, d => re((_(), O("button", {
              key: d.PDT_VER_SIZE,
              type: "button",
              class: $e({
                active: s.value === d.PDT_VER_SIZE
              }),
              onClick: p => a(d.PDT_VER_SIZE)
            }, null, 10, $0)), [[c, `${Number(d.PDT_VER_SIZE)}mm<br><span class='sub'>${y(F)("떡메-약")} ${d.PACK_PRN_CNT}${y(F)("떡메-장")}</span>`]])), 128))]), P("div", F0, [P("p", U0, "* " + Y(y(F)("떡메-오차안내")), 1)])]),
            _: 1
          }, 8, ["title"]);
        };
      }
    }), [["__scopeId", "data-v-187f9082"]]),
    x0 = ["value"],
    H0 = Ne(oe({
      __name: "ButtonType",
      props: {
        code: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.code === "BTALEGG" ? [{
            key: "EGP",
            value: "EGP",
            name: "핀"
          }, {
            key: "EGM",
            value: "EGM",
            name: "자석"
          }] : n.code === "BTFOTOT" ? [{
            key: "CLP",
            value: "CLP",
            name: "핀"
          }, {
            key: "CLM",
            value: "CLM",
            name: "자석"
          }, {
            key: "CLR",
            value: "CLR",
            name: "거울"
          }, {
            key: "CLA",
            value: "CLA",
            name: "미제 거울"
          }, {
            key: "CLT",
            value: "CLT",
            name: "컴팩트 거울"
          }, {
            key: "CLS",
            value: "CLS",
            name: "버섯형자석"
          }, {
            key: "CLO",
            value: "CLO",
            name: "병따개"
          }, {
            key: "CLC",
            value: "CLC",
            name: "클립"
          }] : [{
            key: "CLP",
            value: "CLP",
            name: "핀"
          }, {
            key: "CLR",
            value: "CLR",
            name: "거울"
          }]),
          a = H(s.value[0]?.value || "");
        return U(() => s.value, r => {
          a.value = r[0]?.value || "";
        }, {
          immediate: !0
        }), U(() => a.value, r => o("update", r), {
          immediate: !0
        }), (r, i) => (_(), V(ve, {
          title: "버튼타입"
        }, {
          default: fe(() => [r.code === "BTFOTOT" ? re((_(), O("select", {
            key: 0,
            "onUpdate:modelValue": i[0] || (i[0] = l => a.value = l),
            class: "basic-select",
            onChange: i[1] || (i[1] = l => r.$emit("update", a.value))
          }, [(_(!0), O(q, null, ce(s.value, l => (_(), O("option", {
            key: l.key,
            value: l.value
          }, Y(l.name), 9, x0))), 128))], 544)), [[Ke, a.value]]) : (_(), V(ln, {
            key: 1,
            options: s.value,
            default: a.value,
            onSelect: i[2] || (i[2] = l => a.value = l)
          }, null, 8, ["options", "default"]))]),
          _: 1
        }));
      }
    }), [["__scopeId", "data-v-af5c09c9"]]),
    G0 = {
      class: "button-radio"
    },
    W0 = ["onClick"],
    V0 = {
      key: 0,
      class: "notices"
    },
    j0 = Ne(oe({
      __name: "ProductType",
      props: {
        types: {},
        notices: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.notices ?? []),
          a = H(n.types[0]?.value ?? "");
        function r(i) {
          a.value = i;
        }
        return U(() => a.value, i => {
          const l = n.types.find(u => u.value === i);
          o("update", l?.postPcsCd ? [l.postPcsCd] : []);
        }, {
          immediate: !0
        }), (i, l) => (_(), V(ve, {
          title: y(F)("제품타입")
        }, {
          default: fe(() => [P("div", G0, [(_(!0), O(q, null, ce(i.types, u => (_(), O("button", {
            key: u.value,
            type: "button",
            class: $e({
              active: a.value === u.value
            }),
            onClick: c => r(u.value)
          }, Y(u.name), 11, W0))), 128))]), s.value.length ? (_(), O("ul", V0, [(_(!0), O(q, null, ce(s.value, (u, c) => (_(), O("li", {
            key: c,
            class: "notice"
          }, Y(u), 1))), 128))])) : J("", !0)]),
          _: 1
        }, 8, ["title"]));
      }
    }), [["__scopeId", "data-v-8125c971"]]),
    z0 = {
      class: "cutting-row"
    },
    K0 = ["onClick"],
    Y0 = {
      class: "cutting-label"
    },
    Q0 = ["src", "alt"],
    q0 = {
      class: "cutting-name"
    },
    X0 = Ne(oe({
      __name: "StttdftCutting",
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = [{
            pcsCd: "CUT_DFT",
            name: F("직접 잘라요"),
            imgPath: "https://d3qehkb69dy9zc.cloudfront.net/assets/images/STTTDFT_CUT_DFT.png"
          }, {
            pcsCd: "THO_CUT",
            name: F("바로 붙여요"),
            imgPath: "https://d3qehkb69dy9zc.cloudfront.net/assets/images/STTTDFT_THO_CUT.png"
          }],
          o = t,
          s = H("CUT_DFT");
        function a(r) {
          s.value = r;
        }
        return U(() => s.value, r => {
          r === "CUT_DFT" ? o("update", {
            forcedPostPcs: ["CUT_DFT"]
          }) : o("update", {
            forcedPostPcs: ["THO_CUT"]
          });
        }, {
          immediate: !0
        }), (r, i) => (_(), V(ve, {
          title: y(F)("커팅")
        }, {
          default: fe(() => [P("div", z0, [(_(), O(q, null, ce(n, l => P("div", {
            key: l.pcsCd,
            class: $e(["cutting-item", {
              active: s.value === l.pcsCd
            }]),
            onClick: u => a(l.pcsCd)
          }, [P("div", Y0, [P("img", {
            src: l.imgPath,
            alt: l.name
          }, null, 8, Q0)]), P("span", q0, Y(l.name), 1)], 10, K0)), 64))])]),
          _: 1
        }, 8, ["title"]));
      }
    }), [["__scopeId", "data-v-489b73e6"]]),
    Z0 = {
      value: ""
    },
    J0 = ["value"],
    e1 = oe({
      __name: "MasterColor",
      props: {
        options: {},
        default: {}
      },
      emits: ["update", "validate"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(n.default ?? "");
        return U(() => s.value, a => {
          o("update", a), o("validate", a ? null : [F("마스터색상-선택필요")]);
        }, {
          immediate: !0
        }), (a, r) => (_(), V(ve, {
          title: y(F)("마스터색상")
        }, {
          default: fe(() => [re(P("select", {
            "onUpdate:modelValue": r[0] || (r[0] = i => s.value = i),
            class: "basic-select",
            name: "master-color"
          }, [P("option", Z0, Y(y(F)("마스터색상-선택안함")), 1), (_(!0), O(q, null, ce(a.options, i => (_(), O("option", {
            key: i.value,
            value: i.value
          }, Y(i.name), 9, J0))), 128))], 512), [[Ke, s.value]])]),
          _: 1
        }, 8, ["title"]));
      }
    }),
    t1 = ["disabled"],
    n1 = ["value", "disabled"],
    o1 = ["disabled"],
    s1 = {
      value: ""
    },
    a1 = ["disabled"],
    i1 = {
      key: 0,
      class: "note",
      style: {
        "margin-top": "10px"
      }
    },
    Du = Ne(oe({
      __name: "Dosu",
      props: {
        options: {},
        default: {},
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = Ve(),
          i = H(n.default?.COD || n.options[0].COD),
          l = b(() => n.options.find(g => g.COD === i.value)),
          u = b(() => a.pdtCode === "GSCDPOP" ? "radio" : "select"),
          c = b(() => a.pdtCode === "GSCDPOP" ? -1 : 0),
          d = {
            GSCDPOP: "인풋카드",
            TPBLMEO: "낱장 인쇄 (메모하는 면 인쇄)"
          },
          p = {
            GSCDPOP: {
              SID_X: F("인쇄안함"),
              SID_D: F("인쇄함")
            }
          },
          f = () => {
            s?.onReset && s.onReset("dosu");
          },
          v = b(() => n.relatedData?.addClrMtrlList?.some(T => T.ADD_CLR_YN === "Y") ?? !1),
          h = b(() => {
            if (i.value === "SID_X" || n.relatedData?.hasPrtWht) return !1;
            const T = n.relatedData?.size;
            if (T) {
              const C = Math.max(T.width, T.height),
                S = Math.min(T.width, T.height);
              if (C > 420 || S > 297) return !1;
            }
            return n.relatedData?.addClrMtrlList?.find(C => C.MTRL_CD === n.relatedData?.mtrlCd)?.ADD_CLR_YN === "Y";
          }),
          m = H("");
        U(() => h.value, T => {
          T || (m.value = "");
        });
        const D = b(() => m.value !== "Y" ? null : i.value === "SID_S" ? 6 : i.value === "SID_D" ? 12 : null);
        U(() => [l.value, D.value, m.value], ([T, g, C]) => {
          if (!T) return;
          r.isAfterEdit() && f();
          const S = {
            ...T,
            ...(g !== null ? {
              PRN_CLR_CNT: g
            } : {}),
            ADD_CLR_YN: C === "Y" ? "Y" : "N"
          };
          o("update", S);
        }, {
          immediate: !0
        });
        const N = ["SXHTK013", "SXHTK014", "SXHTK015"],
          I = b(() => !!(N.includes(n.relatedData?.mtrlCd || "") || n.relatedData?.mtrlDosu === "SID_S" || w.value));
        U(() => n.relatedData?.mtrlCd, T => {
          T && N.includes(T) && (i.value = "SID_S");
        });
        const w = b(() => n.relatedData?.packPrnCnt === 100),
          A = b(() => !!n.relatedData?.tpblSidSOnly),
          j = b(() => a.pdtCode === "TPBLPST");
        U(() => A.value, T => {
          T && (i.value = "SID_S");
        }, {
          immediate: !0
        }), U(() => j.value, T => {
          T && (i.value = "SID_X");
        }, {
          immediate: !0
        });
        const B = b(() => r.uploadType.default === "editor" && a.pdtCode === "TPCLECO" || n.relatedData?.mtrlDosu === "SID_D");
        return U(() => r.uploadType.default, T => {
          T === "editor" && a.pdtCode === "TPCLECO" && (i.value = "SID_D");
        }, {
          immediate: !0
        }), U(() => w.value, T => {
          T && (i.value = "SID_S");
        }, {
          immediate: !0
        }), U(() => n.relatedData?.mtrlDosu, T => {
          if (T) {
            if (T === "SID_S") return i.value = "SID_S";
            if (T === "SID_D") return i.value = "SID_D";
          }
        }, {
          immediate: !0
        }), (T, g) => (_(), V(ve, {
          title: d[y(a).pdtCode] ?? "인쇄도수",
          priority: c.value
        }, {
          default: fe(() => [P("div", {
            class: $e(v.value ? "flex-row" : "")
          }, [u.value === "select" ? re((_(), O("select", {
            key: 0,
            "onUpdate:modelValue": g[0] || (g[0] = C => i.value = C),
            class: "basic-select",
            name: "dosu",
            disabled: w.value || j.value || A.value
          }, [(_(!0), O(q, null, ce(T.options, C => (_(), O("option", {
            key: C.COD,
            value: C.COD,
            disabled: I.value && C.COD === "SID_D" || B.value && C.COD === "SID_S"
          }, Y(C.COD_NME), 9, n1))), 128))], 8, t1)), [[Ke, i.value]]) : (_(), V(ln, {
            key: 1,
            options: T.options.map(C => ({
              name: p[y(a).pdtCode][C.COD] ?? C.COD_NME,
              value: C.COD,
              key: C.COD
            })),
            onSelect: g[1] || (g[1] = C => {
              C !== i.value && (i.value = C);
            })
          }, null, 8, ["options"])), v.value ? re((_(), O("select", {
            key: 2,
            "onUpdate:modelValue": g[2] || (g[2] = C => m.value = C),
            class: "basic-select",
            name: "add-clr",
            disabled: !h.value
          }, [P("option", s1, Y(y(F)("6색인쇄 선택안함")), 1), P("option", {
            value: "Y",
            disabled: !h.value
          }, Y(y(F)("6색인쇄 선택")), 9, a1)], 8, o1)), [[Ke, m.value]]) : J("", !0)], 2), j.value ? (_(), O("p", i1, "* " + Y(y(F)("TPBLPST-낱장인쇄중단안내")), 1)) : J("", !0)]),
          _: 1
        }, 8, ["title", "priority"]));
      }
    }), [["__scopeId", "data-v-87f32ddd"]]),
    r1 = ["value"],
    l1 = oe({
      __name: "Thickness",
      props: {
        options: {},
        default: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.options.map(r => ({
            name: r.COD_NME,
            value: r.COD,
            key: r.COD
          }))),
          a = H(n.default || s.value[0].value);
        return U(() => a.value, r => {
          o("update", r);
        }, {
          immediate: !0
        }), (r, i) => (_(), V(ve, {
          title: "두께"
        }, {
          default: fe(() => [re(P("select", {
            "onUpdate:modelValue": i[0] || (i[0] = l => a.value = l),
            name: "thickness",
            class: "basic-select"
          }, [(_(!0), O(q, null, ce(s.value, l => (_(), O("option", {
            key: l.key,
            value: l.value
          }, Y(l.name), 9, r1))), 128))], 512), [[Ke, a.value]])]),
          _: 1
        }));
      }
    }),
    u1 = {},
    c1 = {
      xmlns: "http://www.w3.org/2000/svg",
      width: "12",
      height: "13",
      viewBox: "0 0 12 13",
      fill: "none"
    };
  function d1(e, t) {
    return _(), O("svg", c1, [...(t[0] || (t[0] = [P("path", {
      d: "M0.799805 1.30005L11.1998 11.7",
      stroke: "#222222",
      "stroke-width": "0.96",
      "stroke-linecap": "round"
    }, null, -1), P("path", {
      d: "M11.1998 1.30005L0.799805 11.7",
      stroke: "#222222",
      "stroke-width": "0.96",
      "stroke-linecap": "round"
    }, null, -1)]))]);
  }
  const ls = Ne(u1, [["render", d1]]),
    f1 = {
      class: "size-desc"
    },
    p1 = {
      class: "subject"
    },
    _1 = {
      class: "size-group"
    },
    h1 = {
      class: $e(["size"])
    },
    v1 = ["id", "maxlength", "disabled"],
    m1 = {
      class: $e(["text", "-desc"])
    },
    C1 = {
      class: "icon-box"
    },
    T1 = {
      class: $e(["size"])
    },
    g1 = ["id", "maxlength", "disabled"],
    y1 = {
      class: $e(["text", "-desc"])
    },
    Xh = Ne(oe({
      __name: "Size",
      props: {
        title: {},
        width: {},
        height: {},
        disabled: {},
        error: {
          type: Boolean
        }
      },
      emits: ["update"],
      setup(e, {
        expose: t,
        emit: n
      }) {
        const o = e,
          s = n,
          a = H(0),
          r = H(0),
          i = H(null);
        t({
          focusWidth: () => i.value?.focus()
        });
        const l = b(() => ({
          width: a.value,
          height: r.value
        }));
        U(() => l.value, an(c => {
          o.disabled.w || s("update", c);
        }, 200), {
          deep: !0
        }), U(() => o.width, c => {
          a.value = c.value;
        }, {
          immediate: !0,
          deep: !0
        }), U(() => o.height, c => {
          r.value = c.value;
        }, {
          immediate: !0,
          deep: !0
        });
        const u = Ve();
        return U(() => a.value, c => {
          u.uploadType.default !== "editor" && !o.disabled.w && (a.value = +`${c}`.replace(/\..*$/, ""));
        }), U(() => r.value, c => {
          u.uploadType.default !== "editor" && !o.disabled.h && (r.value = +`${c}`.replace(/\..*$/, ""));
        }), (c, d) => (_(), O("div", f1, [P("h3", p1, Y(y(F)(c.title)), 1), P("div", _1, [P("div", h1, [re(P("input", {
          ref_key: "widthInputRef",
          ref: i,
          "onUpdate:modelValue": d[0] || (d[0] = p => a.value = p),
          type: "number",
          class: $e(["basic-input", "-size", {
            error: c.error
          }]),
          id: `w-${c.title}`,
          maxlength: o.width.maxLength ?? 7,
          disabled: c.disabled.w,
          step: 1
        }, null, 10, v1), [[dt, a.value]]), P("span", m1, Y(y(F)("가로")), 1), d[2] || (d[2] = P("span", {
          class: $e(["text", "-unit"])
        }, "mm", -1))]), P("div", C1, [ne(ls)]), P("div", T1, [re(P("input", {
          "onUpdate:modelValue": d[1] || (d[1] = p => r.value = p),
          type: "number",
          class: $e(["basic-input", "-size", {
            error: c.error
          }]),
          id: `h-${c.title}`,
          maxlength: o.height.maxLength ?? 7,
          disabled: c.disabled.h,
          step: "1"
        }, null, 10, g1), [[dt, r.value]]), P("span", y1, Y(y(F)("세로")), 1), d[3] || (d[3] = P("span", {
          class: $e(["text", "-unit"])
        }, "mm", -1))])])]));
      }
    }), [["__scopeId", "data-v-7e0e8dd2"]]),
    D1 = [{
      PDT_CD: "PRPOXXX",
      PTT_CD: ["VEK", "ATL", "TRA"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 301,
      MAX_CUT_HGH: 424,
      MIN_CUT_WDT: 148,
      MIN_CUT_HGH: 210
    }, {
      PDT_CD: ["PRPOXXX", "PRLFXXX", "LFXXXXX"],
      PTT_CD: "",
      PCS_CD: "SCO_DFT",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 490,
      MAX_CUT_HGH: 730,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "",
      PTT_CD: ["OMO", "WMO", "TES"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 500,
      MAX_CUT_HGH: 700,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "STRMDFT",
      PTT_CD: ["YUR", "IGC"],
      PCS_CD: "",
      PCS_DTL_CD: ["SQXXX", "CLFRE"],
      MAX_CUT_WDT: null,
      MAX_CUT_HGH: null,
      MIN_CUT_WDT: 10,
      MIN_CUT_HGH: 10
    }, {
      PDT_CD: "",
      PTT_CD: ["SCD", "SCR", "WHP", "LTT", "ICR", "IHC", "GSP", "MMW", "TTR", "SOB", "SOD", "SOR"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 297,
      MAX_CUT_HGH: 420,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "",
      PTT_CD: ["DGP", "DLS"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 304,
      MAX_CUT_HGH: 635,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "",
      PTT_CD: ["NPT"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 480,
      MAX_CUT_HGH: 680,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "",
      PTT_CD: ["CEB"],
      PCS_CD: "",
      PCS_DTL_CD: "",
      MAX_CUT_WDT: null,
      MAX_CUT_HGH: null,
      MIN_CUT_WDT: 305,
      MIN_CUT_HGH: 439
    }, {
      PDT_CD: "",
      PTT_CD: "",
      PCS_CD: ["PRT_WHT", "PRT_MAG"],
      PCS_DTL_CD: "",
      MAX_CUT_WDT: 297,
      MAX_CUT_HGH: 420,
      MIN_CUT_WDT: null,
      MIN_CUT_HGH: null
    }, {
      PDT_CD: "",
      PTT_CD: "",
      PCS_CD: ["FLD_DFT"],
      PCS_DTL_CD: "",
      MAX_CUT_WDT: null,
      MAX_CUT_HGH: null,
      MIN_CUT_WDT: 50,
      MIN_CUT_HGH: 90
    }];
  function Zh(e) {
    const t = Array.isArray(e.PDT_CD) ? e.PDT_CD.length > 0 : !!e.PDT_CD,
      n = Array.isArray(e.PTT_CD) ? e.PTT_CD.length > 0 : !!e.PTT_CD,
      o = Array.isArray(e.PCS_CD) ? e.PCS_CD.length > 0 : !!e.PCS_CD,
      s = Array.isArray(e.PCS_DTL_CD) ? e.PCS_DTL_CD.length > 0 : !!e.PCS_DTL_CD;
    return (t ? 8 : 0) + (n ? 4 : 0) + (o ? 2 : 0) + (s ? 1 : 0);
  }
  function S1(e, t) {
    return Array.isArray(e) ? e.length === 0 || e.includes(t) : !e || e === t;
  }
  function P1(e, t) {
    return Array.isArray(e) ? e.length === 0 || e.some(n => t.includes(n)) : !e || t.includes(e);
  }
  function b1(e, t) {
    return Array.isArray(e) ? e.length === 0 || e.some(n => t.includes(n)) : !e || t.includes(e);
  }
  function O1(e, t) {
    return Array.isArray(e) ? e.length === 0 || e.some(n => t.includes(n)) : !e || t.includes(e);
  }
  function Jh(e, t, n, o, s) {
    const a = D1.filter(u => !(!S1(u.PDT_CD, e) || !P1(u.PTT_CD, t) || !b1(u.PCS_CD, n) || !O1(u.PCS_DTL_CD, o)));
    if (!a.length) return {
      MAX_CUT_WDT: +s.MAX_CUT_WDT,
      MAX_CUT_HGH: +s.MAX_CUT_HGH,
      MIN_CUT_WDT: +s.MIN_CUT_WDT,
      MIN_CUT_HGH: +s.MIN_CUT_HGH
    };
    a.sort((u, c) => Zh(c) - Zh(u));
    const r = a[0],
      i = +s.MAX_CUT_WDT,
      l = +s.MAX_CUT_HGH;
    return {
      MAX_CUT_WDT: r.MAX_CUT_WDT != null ? Math.min(r.MAX_CUT_WDT, i) : i,
      MAX_CUT_HGH: r.MAX_CUT_HGH != null ? Math.min(r.MAX_CUT_HGH, l) : l,
      MIN_CUT_WDT: r.MIN_CUT_WDT ?? +s.MIN_CUT_WDT,
      MIN_CUT_HGH: r.MIN_CUT_HGH ?? +s.MIN_CUT_HGH
    };
  }
  const E1 = {
      key: 0,
      name: "sizes",
      class: "basic-select"
    },
    I1 = ["value", "disabled"],
    R1 = {
      key: 2,
      class: "size-details"
    },
    N1 = {
      key: 0,
      class: "pdt-size-info"
    },
    A1 = {
      key: 1,
      class: $e(["note", "error"])
    },
    M1 = {
      key: 2,
      class: "note red"
    },
    yi = Ne(oe({
      __name: "Sizes",
      props: {
        options: {},
        baseInfo: {},
        default: {},
        relatedData: {},
        hiddenSizes: {
          type: Boolean
        },
        showExtra: {
          type: Boolean
        }
      },
      emits: ["update", "validate", "update:shape"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("callbacks", {}),
          r = Te("productCode", {
            pdtCode: ""
          }),
          i = b(() => {
            const ee = new Map();
            return n.options.forEach(M => {
              ee.set(M.DIV_SEQ, M);
            }), ee;
          }),
          l = H(n.default?.DIV_SEQ || n.options.find(ee => ee.DFT_YN === "Y" && ee.HIDE_YN !== "Y")?.DIV_SEQ || n.options.find(ee => ee.HIDE_YN !== "Y")?.DIV_SEQ || n.options[0]?.DIV_SEQ),
          u = H(n.default ? +n.default.CUT_WDT : l.value ? +i.value.get(l.value)?.CUT_WDT : +n.baseInfo.DFT_CUT_WDT),
          c = H(n.default ? +n.default.CUT_HGH : l.value ? +i.value.get(l.value).CUT_HGH : +n.baseInfo.DFT_CUT_HGH),
          d = b(() => +n.baseInfo.CUT_MRG),
          p = H(n.default ? +n.default.WRK_WDT : l.value === 0 ? u.value + d.value : +(i.value.get(l.value)?.WRK_WDT ?? u.value + d.value)),
          f = H(n.default ? +n.default.WRK_HGH : l.value === 0 ? c.value + d.value : +(i.value.get(l.value)?.WRK_HGH ?? c.value + d.value)),
          v = b(() => n.relatedData?.sizeFromPostPcs),
          h = b(() => (n.relatedData?.activePostPcs ?? []).join(",")),
          m = b(() => (n.relatedData?.activePcsDtl ?? []).join(",")),
          D = b(() => ({
            CUT_WDT: u.value,
            CUT_HGH: c.value,
            WRK_WDT: p.value,
            WRK_HGH: f.value
          })),
          N = b(() => !r.pdtCode.startsWith("BT") && !["GSSTPRT"].includes(r.pdtCode) ? "" : i.value.get(l.value)?.PDT_SIZE_INFO || ""),
          I = b(() => {
            const ee = Jh(r.pdtCode, n.relatedData?.mtrlPttCd ?? "", h.value ? h.value.split(",") : [], m.value ? m.value.split(",") : [], n.baseInfo),
              [M, k] = [ee.MAX_CUT_WDT, ee.MAX_CUT_HGH].sort((Q, ae) => Q - ae),
              W = new Set();
            return n.options.forEach(Q => {
              if (Q.HIDE_YN === "Y") return;
              const ae = +Q.CUT_WDT,
                ke = +Q.CUT_HGH;
              if (!ae || !ke) return;
              const [nt, Ze] = [ae, ke].sort((ot, ht) => ot - ht);
              (Ze > k || nt > M) && W.add(Q.DIV_SEQ);
            }), W;
          }),
          w = b(() => {
            const ee = i.value.get(l.value);
            if (v.value) return !1;
            const M = ee?.DIV_NM === "사이즈직접입력" || ee?.DIV_NM === "Input Size" || ee?.DIV_NM === "Type Manually" || n.relatedData?.shape === "FR";
            return o0.has(r.pdtCode) || r.pdtCode.startsWith("ST") ? M : M && (n0.has(r.pdtCode) || s.uploadType.default === "pdf");
          }),
          A = b(() => n.relatedData?.pageDirection);
        Yo(() => {
          if (w.value) return;
          const ee = A.value;
          if (v.value) {
            const M = +v.value.CUT_WDT,
              k = +v.value.CUT_HGH,
              W = M >= k;
            if (!ee) {
              u.value = M, c.value = k, p.value = +v.value.WRK_WDT, f.value = +v.value.WRK_HGH;
              return;
            }
            const ae = W !== (ee !== "H");
            u.value = ae ? k : M, c.value = ae ? M : k, p.value = ae ? +v.value.WRK_HGH : +v.value.WRK_WDT, f.value = ae ? +v.value.WRK_WDT : +v.value.WRK_HGH;
          } else {
            if (!ee) return;
            const M = i.value.get(l.value);
            if (!M) return;
            const k = +M.CUT_WDT,
              W = +M.CUT_HGH,
              Q = +M.WRK_WDT,
              ae = +M.WRK_HGH;
            ee === "W" && k < W || ee === "H" && k > W ? (u.value = W, c.value = k, p.value = ae, f.value = Q) : (u.value = k, c.value = W, p.value = Q, f.value = ae);
          }
        });
        const j = H(!1),
          B = ee => {
            u.value = ee.width, c.value = ee.height, X.value = !1, s.isAfterEdit() && !j.value && (j.value = !0), j.value && T();
          },
          T = () => {
            s.isAfterEdit() && (a?.onReset && a.onReset("size"), j.value = !1);
          },
          g = b(() => n.relatedData?.shape === "CL" || n.relatedData?.cuttingType === "THO_DFT_CL"),
          C = b(() => {
            const ee = i.value.get(l.value);
            return ee?.DIV_NM === "사이즈직접입력" || ee?.DIV_NM === "Input Size";
          }),
          S = _t();
        function R(ee, M) {
          return ee > M ? [ee, M] : [M, ee];
        }
        function E(ee, M) {
          return ee === "max" ? S.locale === "ko" ? ` 최대 주문 가능 사이즈 [${M}] 보다 큽니다.` : ` Max Size: [${M}]` : S.locale === "ko" ? ` 최소 주문 가능 사이즈 [${M}] 보다 작습니다.` : ` Min Size: [${M}]`;
        }
        function L() {
          const ee = +n.baseInfo.MAX_CUT_WDT,
            M = +n.baseInfo.MAX_CUT_HGH,
            k = +n.baseInfo.MIN_CUT_WDT,
            W = +n.baseInfo.MIN_CUT_HGH,
            [Q, ae] = R(ee, M),
            [ke, nt] = R(u.value, c.value),
            Ze = ae * 2,
            ot = Ze - Q,
            ht = u.value === ke ? "W" : "H",
            ft = g.value ? `${ae} x ${ae}` : ht === "W" ? `${Q} x ${ot}` : `${ot} x ${Q}`;
          return nt === ae || ke === ae ? ke <= Ze - ae ? nt >= k ? {
            error: !1
          } : {
            error: !0,
            message: E("min", `${k} x ${W}`)
          } : ke >= Q ? {
            error: !0,
            message: E("max", ft)
          } : {
            error: !0,
            message: E("max", `${ae} x ${ae}`)
          } : u.value + c.value > Ze ? {
            error: !0,
            message: E("max", ft)
          } : ke > Q ? {
            error: !0,
            message: E("max", ft)
          } : ke === Q ? nt <= ot ? nt >= k ? {
            error: !1
          } : {
            error: !0,
            message: E("min", `${k} x ${W}`)
          } : {
            error: !0,
            message: E("max", ft)
          } : {
            error: !1
          };
        }
        const G = b(() => {
          const ee = !!s.editorData?.default?.workSize;
          if (!w.value && !ee) return {
            error: !1
          };
          if (v.value) return {
            error: !1
          };
          const M = Jh(r.pdtCode, n.relatedData?.mtrlPttCd ?? "", h.value ? h.value.split(",") : [], m.value ? m.value.split(",") : [], n.baseInfo);
          let k = M.MIN_CUT_WDT,
            W = M.MIN_CUT_HGH;
          n.baseInfo.PDT_CD?.substring(0, 2) == "SK" && (n.relatedData?.cuttingType?.indexOf("_FR") ?? -1) > -1 && (k = 30, W = 30), r.pdtCode.startsWith("ST") && !["STASDFT", "STDSUSR"].includes(r.pdtCode) && n.relatedData?.shape === "FR" && (k = 30, W = 30);
          const Q = A.value === "W",
            ae = Q ? M.MAX_CUT_HGH : M.MAX_CUT_WDT,
            ke = Q ? M.MAX_CUT_WDT : M.MAX_CUT_HGH,
            nt = Q ? W : k,
            Ze = Q ? k : W,
            [ot, ht] = [u.value, c.value].sort((se, me) => se - me),
            [ft, $] = [ae, ke].sort((se, me) => se - me);
          if (ht > $ || ot > ft) return {
            error: !0,
            message: E("max", `${ae} x ${ke}`)
          };
          const [x, Z] = [u.value, c.value].sort((se, me) => se - me),
            [pe, le] = [nt, Ze].sort((se, me) => se - me);
          return x < pe || Z < le ? {
            error: !0,
            message: E("min", `${nt} x ${Ze}`)
          } : ["ACTHDCO", "ACTHFCO"].includes(r.pdtCode) && ae !== ke ? L() : {
            error: !1
          };
        });
        U(() => u.value, ee => {
          w.value && (p.value = ee + d.value), g.value && (c.value = ee);
        }), U(() => c.value, ee => {
          w.value && (f.value = ee + d.value);
        }), U(() => l.value, ee => {
          const M = i.value.get(ee);
          if (!M) return;
          if (C.value) {
            u.value || (u.value = +M.CUT_WDT || +n.baseInfo.DFT_CUT_WDT), c.value || (c.value = +M.CUT_HGH || +n.baseInfo.DFT_CUT_HGH), p.value || (p.value = +M.WRK_WDT || u.value + d.value), f.value || (f.value = +M.WRK_HGH || c.value + d.value), o("update", {
              DIV_NM: M.DIV_NM || "",
              DIV_SEQ: M.DIV_SEQ,
              DIV_CD: M.DIV_CD,
              DivInfo: {},
              cutSize: {
                width: u.value,
                height: c.value
              },
              workSize: {
                width: p.value,
                height: f.value
              }
            });
            return;
          }
          const k = A.value;
          if (k) {
            const Q = +M.CUT_WDT || +n.baseInfo.DFT_CUT_WDT,
              ae = +M.CUT_HGH || +n.baseInfo.DFT_CUT_HGH,
              ke = +M.WRK_WDT || Q + d.value,
              nt = +M.WRK_HGH || ae + d.value;
            k === "W" && Q < ae ? (u.value = ae, c.value = Q, p.value = nt, f.value = ke) : (u.value = Q, c.value = ae, p.value = ke, f.value = nt);
          } else u.value = +M.CUT_WDT || (+n.baseInfo.MIN_CUT_WDT > +n.baseInfo.DFT_CUT_WDT ? +n.baseInfo.MIN_CUT_WDT : +n.baseInfo.DFT_CUT_WDT), c.value = +M.CUT_HGH || (+n.baseInfo.MIN_CUT_HGH > +n.baseInfo.DFT_CUT_HGH ? +n.baseInfo.MIN_CUT_HGH : +n.baseInfo.DFT_CUT_HGH), p.value = +M.WRK_WDT || u.value + d.value, f.value = +M.WRK_HGH || c.value + d.value;
          M.STICKER_TYPE && o("update:shape", M.STICKER_TYPE);
          const W = {
            DIV_NM: M?.DIV_NM || "",
            DIV_SEQ: M?.DIV_SEQ,
            DIV_CD: M?.DIV_CD,
            DivInfo: {},
            cutSize: {
              width: u.value,
              height: c.value
            },
            workSize: {
              width: p.value,
              height: f.value
            }
          };
          o("update", W);
        }, {
          immediate: !0
        }), U(() => n.options, ee => {
          const M = ee.find(k => k.DIV_SEQ === l.value);
          M ? !w.value && !s.editorData?.default?.workSize && (u.value = +M.CUT_WDT || u.value, c.value = +M.CUT_HGH || c.value, p.value = +M.WRK_WDT || p.value, f.value = +M.WRK_HGH || f.value) : l.value = ee.find(k => k.DFT_YN === "Y" && k.HIDE_YN !== "Y")?.DIV_SEQ || ee.find(k => k.HIDE_YN !== "Y")?.DIV_SEQ || ee[0]?.DIV_SEQ;
        }, {
          immediate: !0
        }), U(() => n.relatedData?.shape, (ee, M) => {
          if (M !== ee && (l.value = n.options.find(k => k.STICKER_TYPE === ee && +k.CUT_WDT > 0 && k.DFT_YN === "Y")?.DIV_SEQ || n.options.find(k => k.STICKER_TYPE === ee && +k.CUT_WDT > 0)?.DIV_SEQ || n.options.find(k => k.STICKER_TYPE === ee)?.DIV_SEQ || n.options.find(k => k.DFT_YN === "Y")?.DIV_SEQ || n.options[0]?.DIV_SEQ, ee === "CL")) {
            const k = i.value.get(l.value);
            k && !C.value ? (u.value = +k.CUT_WDT || +n.baseInfo.DFT_CUT_WDT, c.value = +k.CUT_HGH || +n.baseInfo.DFT_CUT_HGH) : c.value = u.value;
          }
        }, {
          immediate: !0
        }), U(() => s.editorData?.default, ee => {
          const M = ee?.workSize;
          if (!FP.has(r.pdtCode)) if (M) {
            const k = s.editorData?.default?.cutSize;
            u.value = k ? +k.width.toFixed(2) : +(+M.width - d.value).toFixed(2), c.value = k ? +k.height.toFixed(2) : +(+M.height - d.value).toFixed(2), p.value = +M.width.toFixed(2), f.value = +M.height.toFixed(2);
          } else {
            if (s.uploadType.default === "editor" || v.value) return;
            const k = l.value ? i.value.get(l.value) : null;
            u.value = n.default ? +n.default.CUT_WDT : k ? +k.CUT_WDT : +n.baseInfo.DFT_CUT_WDT, c.value = n.default ? +n.default.CUT_HGH : k ? +k.CUT_HGH : +n.baseInfo.DFT_CUT_HGH, p.value = n.default ? +n.default.WRK_WDT : k ? +k.WRK_WDT : u.value + d.value, f.value = n.default ? +n.default.WRK_HGH : k ? +k.WRK_HGH : c.value + d.value;
          }
        }, {
          immediate: !0
        }), U(() => D.value, ee => {
          const M = i.value.get(v.value ? v.value.DIV_SEQ : l.value),
            k = {
              DIV_NM: M?.DIV_NM || "",
              DIV_SEQ: M?.DIV_SEQ,
              DIV_CD: M?.DIV_CD,
              DivInfo: {},
              cutSize: {
                width: ee.CUT_WDT,
                height: ee.CUT_HGH
              },
              workSize: {
                width: ee.WRK_WDT,
                height: ee.WRK_HGH
              }
            };
          o("update", k);
        }), U(() => {
          const ee = G.value;
          return ee.error ? ee.message : null;
        }, ee => {
          o("validate", ee ? [ee] : null);
        }), U(() => I.value, ee => {
          if (!ee.has(l.value)) return;
          const M = n.options.find(k => k.HIDE_YN !== "Y" && !ee.has(k.DIV_SEQ));
          M && (l.value = M.DIV_SEQ);
        });
        const X = H(!1),
          K = H(null),
          de = new Set(["STTHUSR", "STPADIY"]),
          be = H(null),
          xe = an(async (ee, M) => {
            if (!de.has(r.pdtCode) || !ee || !M) return;
            const k = await eP({
              CUT_WDT: ee,
              CUT_HGH: M,
              lang: S.locale
            });
            k && (be.value = F("자유형스티커-칼선안내", {
              LENGTH: k
            }));
          }, 400);
        return U(() => [p.value, f.value], ([ee, M]) => {
          de.has(r.pdtCode) && xe(ee, M);
        }, {
          immediate: !0
        }), U(() => s.uploadType.default, (ee, M) => {
          if (M === ee) return;
          const k = (ee === "pdf" || ee === "editor") && w.value;
          if (X.value = k, !k) return;
          const W = ee === "pdf" ? "PDF업로드규격확인안내" : "에디터선택규격확인안내";
          a?.onCallMsg ? a.onCallMsg("warn", F(W)) : ia().show(F(W)), Ho(() => K.value?.focusWidth());
        }), (ee, M) => {
          const k = it("dompurify-html");
          return _(), V(ve, {
            title: "규격-단위",
            option: "Sizes",
            extra: ee.showExtra ? {
              name: "규격가이드",
              callback: () => {
                y(a)?.onInformGuide && y(a).onInformGuide("size");
              }
            } : null
          }, {
            default: fe(() => [ee.relatedData?.sizeFromPostPcs ? (_(), O("select", E1, [P("option", null, Y(D.value.CUT_WDT) + "mmX" + Y(D.value.CUT_HGH) + "mm", 1)])) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": M[0] || (M[0] = W => l.value = W),
              name: "sizes",
              class: "basic-select",
              onChange: T
            }, [(_(!0), O(q, null, ce(ee.options, W => (_(), O("option", {
              key: `${W.DIV_NM}`,
              value: W.DIV_SEQ,
              disabled: W.HIDE_YN === "Y" || I.value.has(W.DIV_SEQ)
            }, Y(W.HIDE_YN === "Y" || I.value.has(W.DIV_SEQ) ? `[${y(F)("주문불가")}] ${W.DIV_NM}` : W.DIV_NM), 9, I1))), 128))], 544)), [[Ke, l.value]]), ee.hiddenSizes ? J("", !0) : (_(), O("div", R1, [ne(Xh, {
              ref_key: "cutSizeRef",
              ref: K,
              title: "재단사이즈",
              width: {
                value: D.value.CUT_WDT
              },
              height: {
                value: D.value.CUT_HGH
              },
              disabled: {
                w: !w.value || !!v.value || g.value && !C.value,
                h: !w.value || ee.relatedData?.shape === "CL" || ee.relatedData?.cuttingType === "THO_DFT_CL" || !!v.value
              },
              error: G.value.error || X.value,
              onUpdate: B
            }, null, 8, ["width", "height", "disabled", "error"]), ne(Xh, {
              title: "작업사이즈",
              width: {
                value: +D.value.WRK_WDT.toFixed(2)
              },
              height: {
                value: +D.value.WRK_HGH.toFixed(2)
              },
              disabled: {
                w: !0,
                h: !0
              }
            }, null, 8, ["width", "height"]), N.value ? (_(), O("p", N1, Y(N.value), 1)) : J("", !0), G.value.error ? (_(), O("p", A1, Y(G.value.message), 1)) : J("", !0), be.value ? re((_(), O("p", M1, null, 512)), [[k, be.value]]) : J("", !0)]))]),
            _: 1
          }, 8, ["extra"]);
        };
      }
    }), [["__scopeId", "data-v-f3eb7f71"]]),
    w1 = {
      class: "flex-row"
    },
    L1 = ["value"],
    k1 = ["value"],
    $1 = {
      class: "notes"
    },
    F1 = {
      class: "note red"
    },
    U1 = oe({
      __name: "CalendarSetting",
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = t,
          o = Te("callbacks", {}),
          s = new Date().getFullYear(),
          a = new Date().getMonth() + 1,
          r = Array.from({
            length: 3
          }, (f, v) => s + v),
          i = Array.from({
            length: 12
          }, (f, v) => v + 1),
          l = H(a >= 10 ? s + 1 : s),
          u = H(1),
          c = b(() => ({
            year: l.value,
            month: u.value
          })),
          d = Ve(),
          p = () => {
            d.isAfterEdit() && o.onReset && o.onReset("calendar");
          };
        return U(() => c.value, f => {
          n("update", f);
        }, {
          immediate: !0
        }), U(() => d.editorData.default, f => {
          f?.calendarInfo && (l.value = f.calendarInfo.year, u.value = f.calendarInfo.month);
        }), (f, v) => (_(), V(ve, {
          title: "달력시작"
        }, {
          default: fe(() => [P("div", w1, [re(P("select", {
            "onUpdate:modelValue": v[0] || (v[0] = h => l.value = h),
            name: "starting-year",
            class: "basic-select",
            onChange: p
          }, [(_(!0), O(q, null, ce(y(r), h => (_(), O("option", {
            key: h,
            value: h
          }, Y(h) + Y(y(F)("연도")), 9, L1))), 128))], 544), [[Ke, l.value]]), re(P("select", {
            "onUpdate:modelValue": v[1] || (v[1] = h => u.value = h),
            name: "starting-month",
            class: "basic-select",
            onChange: p
          }, [(_(!0), O(q, null, ce(y(i), h => (_(), O("option", {
            key: h,
            value: h
          }, Y(y(F)(`${h}월`)), 9, k1))), 128))], 544), [[Ke, u.value]])]), P("div", $1, [P("p", F1, Y(y(F)("달력시작설명")), 1)])]),
          _: 1
        }));
      }
    }),
    B1 = {
      key: 0,
      class: "checkbox-group"
    },
    x1 = {
      key: 1,
      class: "guide"
    },
    Su = Ne(oe({
      __name: "Subject",
      props: {
        isBizMem: {
          type: Boolean
        }
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = t,
          o = H(!1),
          s = H(""),
          a = b(() => ({
            production_check: o.value ? "Y" : "N",
            subject: s.value
          }));
        return U(() => a.value, an(r => {
          n("update", r);
        }, 400)), (r, i) => (_(), V(ve, {
          title: "주문제목"
        }, {
          default: fe(() => [r.isBizMem ? (_(), O("div", B1, [re(P("input", {
            "onUpdate:modelValue": i[0] || (i[0] = l => o.value = l),
            type: "checkbox",
            id: "production_check",
            class: "checkbox"
          }, null, 512), [[zd, o.value]]), i[2] || (i[2] = P("label", {
            for: "production_check"
          }, "생산확인", -1))])) : J("", !0), r.isBizMem ? (_(), O("p", x1, " ※ 영업주문의 경우 '생산확인' 체크시 잡티켓에 [주문제목]에 입력한 내용이 출력됩니다. ")) : J("", !0), re(P("input", {
            "onUpdate:modelValue": i[1] || (i[1] = l => s.value = l),
            type: "text",
            id: "order-subject",
            class: "basic-input"
          }, null, 512), [[dt, s.value]])]),
          _: 1
        }));
      }
    }), [["__scopeId", "data-v-8ebf2fd7"]]),
    ev = new Set(["PRBKOPR", "PRBKOPB"]),
    H1 = new Set(["PER_DFT", "STA_DFT", "RIN_DFT", "RIN_COL", "BID_BOD", "BID_NDB", "BID_RFL", "BID_SIL"]),
    G1 = new Set(["RIN_DFT", "RIN_COL", "PER_DFT"]),
    Di = oe({
      __name: "HiddenPostPcs",
      props: {
        options: {},
        relatedData: {},
        disabledOpts: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => {
            const T = [],
              g = [],
              C = [],
              S = [];
            for (const R of n.options) R.PCS_CD === "LAS_DFT" ? T.push(R) : R.PCS_CD.startsWith("THO_") ? g.push(R) : R.PCS_CD === "ROU_DFT" ? C.push(R) : S.push(R);
            return {
              LAS_DFTs: T,
              THO_XXXs: g,
              ROU_DFTs: C,
              ETC: S
            };
          }),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = b(() => n.relatedData.shape),
          i = b(() => n.relatedData.sizeInfo?.DIV_SEQ),
          l = b(() => n.relatedData.sizeInfo?.cutSize),
          u = b(() => n.relatedData.cuttingType),
          c = b(() => n.relatedData.mtrlCd || ""),
          d = b(() => n.disabledOpts ? n.disabledOpts[c.value] || {} : {}),
          p = Xe({});
        function f(T) {
          const {
            PCS_CD: g,
            VIEW_YN: C,
            PCS_DTL_CD: S,
            PCS_DTL_NM: R,
            ESN_YN: E
          } = T;
          p[g]?.[0]?.selectedOptions[0]?.PCS_DTL_CD !== S && (p[g] = [{
            PCS_CD: g,
            VIEW_YN: C,
            ESN_YN: E,
            selectedOptions: [{
              PCS_CD: g,
              PCS_DTL_CD: S,
              PCS_DTL_NM: R,
              ATTB: ""
            }]
          }]);
        }
        const v = T => +T.CUT_WDT === l.value?.width && +T.CUT_HGH === l.value?.height;
        function h() {
          const T = s.value.LAS_DFTs.length === 1 ? s.value.LAS_DFTs[0] : s.value.LAS_DFTs.find(g => g.WEB_PCS_DTL_GRP === `LAS_DFT_${r.value || "FR"}`);
          T && f(T);
        }
        function m(T) {
          for (const g of Object.keys(p)) g.startsWith("THO_") && g !== T && delete p[g];
        }
        function D() {
          const T = s.value.THO_XXXs;
          if (!T?.length || a.pdtCode.startsWith("BT") || a.pdtCode.startsWith("ST") && a.pdtCode !== "STDRCAD") return;
          if (a.pdtCode === "PRCATCK") {
            const C = n.relatedData.prcatckShape ?? "CV",
              S = n.relatedData.prcatckPosition ?? "C",
              R = i.value;
            if (R == null) return;
            const E = `${C}${S}${String(R).padStart(2, "0")}`,
              L = T.find(G => G.PCS_DTL_CD === E);
            L && (m(L.PCS_CD), f(L));
            return;
          }
          if (T.length === 1) return m(T[0].PCS_CD), f(T[0]);
          let g = null;
          if (a.pdtCode === "STDRCAD" && typeof i.value == "number" && (g = T.find(C => C.DIV_SEQ === i.value), g)) return m(g.PCS_CD), f(g);
          if (typeof i.value == "number" && r.value) {
            const C = r.value.length > 2 ? r.value.slice(0, 2) : r.value;
            if (g = s.value.THO_XXXs.find(S => S.WEB_PCS_DTL_GRP === `${S.PCS_CD}_${C}` && S.DIV_SEQ === i.value), g) return m(g.PCS_CD), f(g);
          }
          if (u.value) {
            const C = T.filter(S => S.WEB_PCS_DTL_GRP === u.value);
            if (g = C.find(v) || C.find(S => +S.CUT_WDT == 0), g) return m(g.PCS_CD), f(g);
          }
          g = T.find(v), g && (m(g.PCS_CD), f(g));
        }
        function N(T) {
          const {
              PCS_CD: g,
              VIEW_YN: C,
              ESN_YN: S
            } = T[0],
            R = hu[a.pdtCode],
            E = R?.factor === "size" && i.value ? R.value[String(i.value)] : "",
            L = p[g]?.[0];
          if (L) {
            const G = T.map(K => K.PCS_DTL_CD).join(","),
              X = L.selectedOptions.map(K => K.PCS_DTL_CD).join(",");
            if (G === X && (L.selectedOptions[0]?.ATTB ?? "") === E) return;
          }
          p[g] = [{
            PCS_CD: g,
            VIEW_YN: C,
            ESN_YN: S,
            selectedOptions: T.map(({
              PCS_CD: G,
              PCS_DTL_CD: X,
              PCS_DTL_NM: K
            }) => ({
              PCS_CD: G,
              PCS_DTL_CD: X,
              PCS_DTL_NM: K,
              ATTB: E
            }))
          }];
        }
        function I(T) {
          const {
            PCS_CD: g
          } = T;
          return g === "CUT_DFT" && n.relatedData.dosu === "SID_X" && a.pdtCode !== "STSKDFT";
        }
        function w(T) {
          const {
              PCS_CD: g
            } = T,
            C = d.value[g];
          return C && C.length === 0 ? (p[g] && delete p[g], !0) : !1;
        }
        function A() {
          for (const T of s.value.ETC) {
            const {
              PCS_CD: g
            } = T;
            g === "CVR_SFT" && n.relatedData.selectedCoverPcs || I(T) || w(T) || p[g] || f(T);
          }
        }
        Yo(() => {
          s.value.LAS_DFTs.length > 0 && h(), s.value.THO_XXXs.length > 0 && D(), s.value.ROU_DFTs.length > 0 && n.relatedData.dosu !== "SID_X" && N(s.value.ROU_DFTs), s.value.ETC.length > 0 && A();
        }), U(() => p.PRT_WHT, T => {
          a.pdtCode === "STTBDFT" && T?.[0]?.selectedOptions?.[0] && (T[0].selectedOptions[0].ATTB_2 = "Y");
        }, {
          immediate: !0
        }), U(() => n.relatedData.dosu, T => {
          T === "SID_X" && (delete p.ROU_DFT, a.pdtCode !== "STSKDFT" && delete p.CUT_DFT);
        }), U(() => n.relatedData.thickness, T => {
          if (!T || !p.CVR_BOD) return;
          const g = p.CVR_BOD[0];
          g && (g.selectedOptions[0].ATTB = T);
        }), U(() => [n.relatedData.paperLayout, n.relatedData.foldingWay], ([T, g]) => {
          if (!p.OSI_DFT?.[0]) return;
          const C = p.OSI_DFT[0];
          if (!C.selectedOptions[0]) return;
          const S = T === "WAT_TRW" || T === "WAT_TRH";
          C.selectedOptions[0].ATTB = S ? "2" : "1", C.selectedOptions[0].ATTB_2 = g, C.selectedOptions[0].DIV_CD = T;
        }), U(() => n.relatedData.orderQty, T => {
          if (T) for (const g of wP) p[g] && p[g].forEach(C => C.selectedOptions[0].ATTB = T);
        }, {
          immediate: !0
        }), U(() => n.relatedData.bindDirection?.selectedOptions[0], T => {
          if (!T) return;
          const C = Object.keys(p).find(S => G1.has(S));
          C && (p[C][0].selectedOptions[0] = {
            ...p[C][0].selectedOptions[0],
            PCS_DTL_CD: T.PCS_DTL_CD,
            PCS_DTL_NM: T.PCS_DTL_NM,
            BACK_ROT_YN: T.BACK_ROT_YN
          });
        }), U(() => n.relatedData.hangType, T => {
          if (delete p.HOL_DFT, delete p.RIN_CUT, T?.length) {
            const g = T[0];
            p[g.PCS_CD] = T;
          }
        }, {
          immediate: !0
        }), U(() => n.relatedData.selectedCoverPcs, T => {
          T && delete p.CVR_SFT;
        }), U(() => p, an(T => {
          o("update", T);
        }, 100), {
          immediate: !0,
          deep: !0
        });
        function j() {
          const T = r.value,
            g = l.value;
          if (!T) {
            if (a.pdtCode === "STCUXXX") {
              const E = s.value.THO_XXXs.find(L => L.PCS_CD === "THO_DFT");
              E && (m(E.PCS_CD), f(E));
              return;
            }
            const R = s.value.THO_XXXs.find(E => E.PCS_CD === "THO_GRA");
            R && (m(R.PCS_CD), f(R));
            return;
          }
          if (!g) return;
          if (T === "FR") {
            const R = s.value.THO_XXXs.find(E => E.PCS_CD === "THO_GRA");
            R && (m(R.PCS_CD), f(R));
            return;
          }
          const C = s.value.THO_XXXs.filter(R => R.STICKER_TYPE === T);
          if (!C.length) return;
          const S = C.find(R => +R.CUT_WDT === g.width && +R.CUT_HGH === g.height) || C.find(R => +R.CUT_WDT == 0);
          S && (m(S.PCS_CD), f(S));
        }
        U(() => [l.value?.width, l.value?.height, r.value], () => {
          a.pdtCode.startsWith("ST") && j();
        }, {
          immediate: !0
        });
        function B(T) {
          const g = r.value,
            C = l.value;
          if (!g || !C) return;
          const S = n.relatedData.btnType;
          if ((a.pdtCode === "BTALLGT" || a.pdtCode === "BTALEGG" || a.pdtCode === "BTFOTOT") && !S) return;
          const R = n.options.filter(L => L.PCS_CD === T);
          if (!R.length) return;
          const E = R.find(L => (!L.STICKER_TYPE || L.STICKER_TYPE === g) && +L.CUT_WDT === C.width && +L.CUT_HGH === C.height && (!S || L.PCS_DTL_CD.indexOf(S) > -1));
          E && (delete p[T], f(E));
        }
        return U(() => [l.value?.width, l.value?.height, r.value, n.relatedData.btnType], () => {
          a.pdtCode.startsWith("BT") && (B("THO_DFT"), B("THO_CUT"), B("BTN_DFT"));
        }, {
          immediate: !0
        }), U(() => [c.value, n.relatedData.orderQty], ([T, g]) => {
          const C = n.relatedData.mtrlLinkedPcs;
          if (!C) return;
          const S = n.options.find(R => R.PCS_CD === C && R.MTRL_CD === T);
          S && (f(S), p[C]?.[0] && (p[C][0].selectedOptions[0].ATTB = g || 1));
        }, {
          immediate: !0
        }), (T, g) => null;
      }
    });
  function Pu() {
    const e = Te("callbacks", {}),
      t = Ve(),
      n = H(!1);
    let o = !1;
    function s() {
      if (o) {
        o = !1;
        return;
      }
      t.isAfterEdit() && !n.value && (n.value = !0);
    }
    function a() {
      e?.onReset && e.onReset("white"), n.value = !1, o = !0;
    }
    return {
      canResetWhite: Ds(n),
      arm: s,
      resetEditByWhite: a
    };
  }
  const W1 = {
      class: "flex-row -flow"
    },
    V1 = ["data-tooltip"],
    j1 = {
      key: 0
    },
    Si = Ne(oe({
      __name: "VisiblePostPcs",
      props: {
        options: {},
        disabledOpts: {},
        attbOpts: {},
        relatedData: {},
        disabledAddPcs: {},
        hiddenPostPcs: {},
        forcedPostPcs: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("productCode", {
            pdtCode: ""
          }),
          a = b(() => BP.has(s.pdtCode)),
          r = Te("callbacks", {}),
          i = Ve(),
          l = _t(),
          u = ia(),
          c = Xe({}),
          d = {
            PHPTPRM: "WRK_MTR",
            STDRCAD: "PDT_WRK"
          },
          p = ["BCSPHIG"];
        function f(M) {
          if (!i.isAfterEdit()) return;
          if (s.pdtCode.startsWith("ST") && (M === "SCO_DFT" || M === "PRT_WHT")) {
            r.onReset && r.onReset("postPcs");
            return;
          }
          if (p.includes(s.pdtCode) && M === "PRT_WHT") {
            r.onReset && r.onReset("white");
            return;
          }
          const k = d[s.pdtCode];
          k && k === M && r.onReset && r.onReset("postPcs");
        }
        function v() {
          const M = n.options.find(k => k.PCS_CD === "PRT_WHT");
          return M ? {
            PCS_CD: "PRT_WHT",
            PCS_GRP_NM: M.PCS_GRP_NM,
            VIEW_YN: "N",
            ESN_YN: "N",
            selectedOptions: [{
              PCS_CD: "PRT_WHT",
              PCS_DTL_CD: M.PCS_DTL_CD,
              PCS_DTL_NM: M.PCS_DTL_NM,
              ATTB: "N"
            }]
          } : null;
        }
        U(() => c, () => {
          if (s.pdtCode === "PRCDTRA" && i.uploadType.default === "pdf" && !c.PRT_WHT) {
            const M = v();
            if (M) {
              o("update", {
                ...c,
                PRT_WHT: [M]
              });
              return;
            }
          }
          o("update", c);
        }, {
          deep: !0
        });
        const h = Xe({});
        for (const M of Object.keys(Yh)) h[M] = !0;
        function m(M) {
          const k = Yh[M];
          if (k) return l.locale === "en" ? k.en : k.ko;
        }
        const D = b(() => n.relatedData.mtrlCd || ""),
          N = b(() => n.disabledOpts ? n.disabledOpts[D.value] || {} : {});
        U(() => D.value, M => {
          if (!M) return;
          K(M), be(), xe();
          const k = Uh[s.pdtCode];
          k && i.uploadType.default === "editor" && X(k);
        }, {
          immediate: !0
        }), U(() => N.value, (M, k) => {
          be(), xe();
          const W = new Set(["COT_DFT", "THO_DFT"]);
          for (const [Q, ae] of Object.entries(M)) W.has(Q) || ae.length === 0 && (c[Q] && C(Q, "N"), h[Q] = !0);
          for (const [Q, ae] of Object.entries(k ?? {})) W.has(Q) || ae.length === 0 && M[Q]?.length !== 0 && (h[Q] = !1);
        }), U(() => n.options, M => {
          const k = new Set(M.map(W => W.PCS_CD));
          for (const W of Object.keys(c)) k.has(W) || delete c[W];
        });
        const I = b(() => {
            const M = {};
            for (const [k, W] of B.value.entries()) {
              const Q = N.value[k];
              Q && Q.length === 0 ? M[k] = !0 : M[k] = !1;
            }
            return M;
          }),
          w = b(() => rn(n.attbOpts) ? null : n.attbOpts?.reduce((M, k) => {
            const W = {
              name: k.ATTB_NM,
              value: k.ATTB_CD,
              key: k.ATTB_CD,
              ...(k.RGB_CD ? {
                extra: {
                  RGB_CD: k.RGB_CD
                }
              } : {})
            };
            return M[k.PCS_CD] ? M[k.PCS_CD].push(W) : M = {
              [k.PCS_CD]: [W]
            }, M;
          }, {})),
          A = new Set(["PDT_WRK_PP", "SUB_MTR_BC"]),
          j = new Map(),
          B = b(() => {
            const M = new Map();
            for (const k of n.options) {
              const {
                  PCS_CD: W,
                  PCS_DTL_CD: Q,
                  PCS_DTL_NM: ae,
                  PCS_GRP_NM: ke,
                  ESN_YN: nt,
                  WEB_PCS_DTL_GRP: Ze,
                  WEB_PCS_DTL_GRP_NM: ot
                } = k,
                ht = M.get(W),
                ft = {
                  name: ae,
                  value: Q,
                  key: Q,
                  extra: k
                };
              ht ? ht.options.push(ft) : M.set(W, {
                name: Cu[W] ? ot : ke || ae,
                imgPath: W === "PDT_WRK" && s.pdtCode === "STDRCAD" ? "STDRCAD_PDT_WRK" : A.has(Ze) ? Ze : `${W}_${s.pdtCode}`,
                subImgPath: W,
                value: W,
                group: Ze,
                options: [ft],
                disabled: nt === "Y",
                component: (() => {
                  const $ = W === "SUB_MTR" ? Ze : W;
                  return j.has($) || j.set($, wn($n(() => yu(Object.assign({
                    "../postPcs/ADC_PVC.vue": () => Promise.resolve().then(() => dR),
                    "../postPcs/BAK_STK.vue": () => Promise.resolve().then(() => pR),
                    "../postPcs/BID_SIL.vue": () => Promise.resolve().then(() => hR),
                    "../postPcs/BIND_DIRECTION.vue": () => Promise.resolve().then(() => mR),
                    "../postPcs/BND_LOC.vue": () => Promise.resolve().then(() => gR),
                    "../postPcs/BON_PAP.vue": () => Promise.resolve().then(() => PR),
                    "../postPcs/BON_SHT.vue": () => Promise.resolve().then(() => OR),
                    "../postPcs/BTN_DFT.vue": () => Promise.resolve().then(() => IR),
                    "../postPcs/CDL_DFT.vue": () => Promise.resolve().then(() => AR),
                    "../postPcs/CLD_STD.vue": () => Promise.resolve().then(() => wR),
                    "../postPcs/COT_DFT.vue": () => Promise.resolve().then(() => UR),
                    "../postPcs/COT_SEG.vue": () => Promise.resolve().then(() => xR),
                    "../postPcs/CPN_DFT.vue": () => Promise.resolve().then(() => HR),
                    "../postPcs/CUT_DFT.vue": () => Promise.resolve().then(() => aN),
                    "../postPcs/CVR_INN.vue": () => Promise.resolve().then(() => rN),
                    "../postPcs/CVR_SWN.vue": () => Promise.resolve().then(() => uN),
                    "../postPcs/DIR_MTR.vue": () => Promise.resolve().then(() => cN),
                    "../postPcs/END_PAP.vue": () => Promise.resolve().then(() => pN),
                    "../postPcs/FLD_DFT.vue": () => Promise.resolve().then(() => TN),
                    "../postPcs/HOL_DFT.vue": () => Promise.resolve().then(() => DN),
                    "../postPcs/INN_DFT.vue": () => Promise.resolve().then(() => EN),
                    "../postPcs/INS_COT.vue": () => Promise.resolve().then(() => RN),
                    "../postPcs/LAB_FBR.vue": () => Promise.resolve().then(() => AN),
                    "../postPcs/LAM_DFT.vue": () => Promise.resolve().then(() => LN),
                    "../postPcs/MIS_DFT.vue": () => Promise.resolve().then(() => UN),
                    "../postPcs/NUM_DFT.vue": () => Promise.resolve().then(() => tA),
                    "../postPcs/OSI_DFT.vue": () => Promise.resolve().then(() => aA),
                    "../postPcs/PAK_ETC.vue": () => Promise.resolve().then(() => dA),
                    "../postPcs/PAK_POL.vue": () => Promise.resolve().then(() => pA),
                    "../postPcs/PAK_POL_Simple.vue": () => Promise.resolve().then(() => xE),
                    "../postPcs/PDT_WRK.vue": () => Promise.resolve().then(() => CA),
                    "../postPcs/PRT_IPK.vue": () => Promise.resolve().then(() => DA),
                    "../postPcs/PRT_MAG.vue": () => Promise.resolve().then(() => PA),
                    "../postPcs/PRT_SID.vue": () => Promise.resolve().then(() => wA),
                    "../postPcs/PRT_WHT.vue": () => Promise.resolve().then(() => WA),
                    "../postPcs/PRT_WHT_FACE.vue": () => Promise.resolve().then(() => kA),
                    "../postPcs/RFL_HAP.vue": () => Promise.resolve().then(() => QA),
                    "../postPcs/RIN_DFT.vue": () => Promise.resolve().then(() => XA),
                    "../postPcs/ROU_DFT.vue": () => Promise.resolve().then(() => rM),
                    "../postPcs/SCO_DFT.vue": () => Promise.resolve().then(() => dM),
                    "../postPcs/SUB_MTR.vue": () => Promise.resolve().then(() => X1),
                    "../postPcs/SUB_MTR_BC.vue": () => Promise.resolve().then(() => pM),
                    "../postPcs/SUB_MTR_LW.vue": () => Promise.resolve().then(() => CM),
                    "../postPcs/SUB_MTR_Multi.vue": () => Promise.resolve().then(() => nb),
                    "../postPcs/THO_BAK.vue": () => Promise.resolve().then(() => gM),
                    "../postPcs/THO_CUT.vue": () => Promise.resolve().then(() => DM),
                    "../postPcs/THO_DFT.vue": () => Promise.resolve().then(() => PM),
                    "../postPcs/THO_GRA.vue": () => Promise.resolve().then(() => OM),
                    "../postPcs/WRK_MTR.vue": () => Promise.resolve().then(() => IM)
                  }), `../postPcs/${$}.vue`, 3)))), j.get($);
                })(),
                ...(w.value && w.value[W] ? {
                  attbOptions: w.value[W]
                } : {})
              });
            }
            return M;
          }),
          T = b(() => {
            for (const [M] of B.value) if (!(a.value && M === "WRK_MTR") && !n.hiddenPostPcs?.includes(M)) return !0;
            return !1;
          }),
          g = b(() => B.value.size === 0 ? !1 : Object.keys(c).some(M => !(n.hiddenPostPcs?.includes(M) || zn.has(s.pdtCode) && M === "PRT_WHT" || s.pdtCode === "STTTDFT" && M === "PAK_POL" && n.relatedData?.cuttingType === "CUT_DFT" || s.pdtCode === "WBXXXXX" && M === "CPN_DFT")));
        function C(M, k, W) {
          const Q = B.value.get(M);
          if (!Q) return;
          const ae = c[M];
          if (zn.has(s.pdtCode) && M === "PRT_WHT" && !k) {
            const ot = ae?.[0]?.selectedOptions?.[0]?.ATTB === "Y" ? "N" : "Y";
            ae?.[0] && (c[M] = [{
              ...ae[0],
              selectedOptions: [{
                ...ae[0].selectedOptions[0],
                ATTB: ot
              }]
            }]);
            return;
          }
          const ke = n.options.some(Ze => Ze.PCS_CD === M && Ze.ESN_YN === "Y");
          if (!k && ae && (ke || h[M])) return;
          if (k ? k === "Y" : !ae) {
            const Ze = s0[M];
            if (Ze) {
              const x = Ze.find(Z => c[Z]);
              if (x) {
                const Z = B.value.get(x)?.name || x;
                u.show(F("후가공-상호배타", {
                  NEW: Q.name,
                  EXISTING: Z
                }));
                return;
              }
            }
            const ot = l0[s.pdtCode]?.[M];
            if (ot) {
              const x = ot.find(Z => c[Z]);
              if (x) {
                const Z = B.value.get(x)?.name || x;
                u.show(F("후가공-상호배타", {
                  NEW: Q.name,
                  EXISTING: Z
                }));
                return;
              }
            }
            const ht = n.hiddenPostPcs?.includes(Q.value),
              $ = (() => {
                if (s.pdtCode !== "STTTDFT" || Q.value !== "PAK_POL") return null;
                const x = n.relatedData?.cuttingType === "THO_CUT" ? Q.options.find(Z => Z.value === "STSET") ?? Q.options[0] : Q.options[0];
                return x ? [{
                  PCS_CD: Q.value,
                  PCS_DTL_CD: x.value,
                  PCS_DTL_NM: x.extra?.PCS_DTL_NM
                }] : null;
              })() ?? ((ht || k === "Y" && !ae) && Q.options[0] ? [{
                PCS_CD: Q.value,
                PCS_DTL_CD: Q.options[0].value,
                PCS_DTL_NM: Q.options[0].extra?.PCS_DTL_NM
              }] : ae ? ae[0].selectedOptions : []);
            c[Q.value] = W ?? [{
              PCS_CD: Q.value,
              PCS_GRP_NM: Q.name,
              VIEW_YN: "Y",
              ESN_YN: Q.options[0]?.extra.ESN_YN || "N",
              selectedOptions: $
            }], a.value && M === "PDT_WRK" && C("WRK_MTR", "Y"), s.pdtCode === "STTTDFT" && M === "PDT_WRK" && delete c.PAK_POL, s.pdtCode === "STTTDFT" && M === "PAK_POL" && delete c.PDT_WRK, (M === "PDT_WRK" || M === "PAK_POL") && i.isAfterEdit() && (i.setEditorData(null), r.onReset && r.onReset("postPcs"));
          } else delete c[Q.value], a.value && M === "PDT_WRK" && delete c.WRK_MTR;
          f(M);
        }
        U(() => n.forcedPostPcs, (M, k) => {
          const W = (M ?? []).filter(ae => !(k ?? []).includes(ae)),
            Q = (k ?? []).filter(ae => !(M ?? []).includes(ae));
          for (const ae of W) C(ae, "Y"), h[ae] = !0;
          for (const ae of Q) C(ae, "N"), h[ae] = !1;
        }, {
          deep: !0
        }), U(() => n.relatedData?.sizeInfo?.DIV_SEQ, M => {
          if (s.pdtCode !== "WBXXXXX" || !c.CPN_DFT?.[0]) return;
          const k = n.options.find(W => W.PCS_CD === "CPN_DFT" && W.DIV_SEQ === M);
          k && (c.CPN_DFT[0].selectedOptions = [{
            PCS_CD: "CPN_DFT",
            PCS_DTL_CD: k.PCS_DTL_CD,
            PCS_DTL_NM: k.PCS_DTL_NM
          }]);
        }), U(() => n.relatedData?.sizeInfo?.DIV_SEQ, M => {
          if (s.pdtCode !== "GSNTBND" || !c.INN_DFT?.[0]) return;
          const k = n.options.find(W => W.PCS_CD === "INN_DFT" && W.DIV_SEQ === M);
          k && (c.INN_DFT[0].selectedOptions = [{
            PCS_CD: "INN_DFT",
            PCS_DTL_CD: k.PCS_DTL_CD,
            PCS_DTL_NM: k.PCS_DTL_NM
          }]);
        });
        const S = M => k => {
            if (k.length === 0) return delete c[M];
            c[M]?.[0] && (c[M][0].selectedOptions[0]?.PCS_DTL_CD !== k[0]?.PCS_DTL_CD && f(M), c[M][0].selectedOptions = k);
          },
          R = M => k => {
            c[M] = k, k.length === 0 && C(M, "N");
          };
        Yo(() => {
          if (!zn.has(s.pdtCode)) return;
          const M = n.options.find(k => k.PCS_CD === "PRT_WHT");
          !M || c.PRT_WHT || (c.PRT_WHT = [{
            PCS_CD: "PRT_WHT",
            PCS_GRP_NM: M.PCS_GRP_NM,
            VIEW_YN: "Y",
            ESN_YN: "N",
            selectedOptions: [{
              PCS_CD: "PRT_WHT",
              PCS_DTL_CD: M.PCS_DTL_CD,
              PCS_DTL_NM: M.PCS_DTL_NM,
              ATTB: "N",
              ATTB_2: null
            }]
          }]);
        }), Yo(() => {
          for (const M of n.options) {
            const {
              PCS_CD: k,
              PCS_GRP_NM: W,
              VIEW_YN: Q,
              PCS_DTL_CD: ae,
              PCS_DTL_NM: ke,
              ESN_YN: nt
            } = M;
            if (nt === "N" || Q !== "Y" || h[k] || c[k]) continue;
            const ot = {
              PCS_CD: k,
              PCS_GRP_NM: W,
              VIEW_YN: Q,
              ESN_YN: nt,
              selectedOptions: [{
                PCS_CD: k,
                PCS_DTL_CD: ae,
                PCS_DTL_NM: ke,
                ATTB: ""
              }]
            };
            c[k] = [ot];
          }
        }), U(() => i.uploadType.default, M => {
          if (s.pdtCode.startsWith("AC") || s.pdtCode === "PRCDTRA") {
            if (M === "editor" && s.pdtCode !== "ACTHFCO") {
              const Q = n.options.find(ke => ke.PCS_CD === "PRT_WHT"),
                ae = Q ? {
                  PCS_CD: "PRT_WHT",
                  PCS_GRP_NM: Q.PCS_GRP_NM,
                  VIEW_YN: "Y",
                  ESN_YN: "N",
                  selectedOptions: [{
                    PCS_CD: "PRT_WHT",
                    PCS_DTL_CD: Q.PCS_DTL_CD,
                    PCS_DTL_NM: Q.PCS_DTL_NM,
                    ATTB: "Y"
                  }]
                } : void 0;
              C("PRT_WHT", "Y", ae ? [ae] : void 0), h.PRT_WHT = !0;
            } else if (h.PRT_WHT = !1, s.pdtCode === "PRCDTRA" && M === "pdf" && !c.PRT_WHT) {
              const Q = v();
              Q && o("update", {
                ...c,
                PRT_WHT: [Q]
              });
            }
          }
          const k = Uh[s.pdtCode],
            W = AP[s.pdtCode];
          if (k || W) {
            if (M === "editor") {
              if (k && X(k), W) for (const Q of W) c[Q] && C(Q, "N"), h[Q] = !0;
            } else if (k && (h.PRT_WHT = !1), W) for (const Q of W) h[Q] = !1;
          }
        }, {
          immediate: !0
        });
        const {
          canResetWhite: E,
          arm: L,
          resetEditByWhite: G
        } = Pu();
        U(() => i.editorData?.default?.PRT_WHT, M => {
          if (M?.front || M?.back) {
            if (s.pdtCode !== "ACTHFCO") return C("PRT_WHT", "Y");
            i.isAfterEdit() && E.value && G();
            const k = Object.entries(M).reduce((W, Q) => {
              const [ae, ke] = Q;
              return ke && W.push({
                PCS_CD: "PRT_WHT",
                PCS_GRP_NM: "화이트인쇄",
                VIEW_YN: "Y",
                ESN_YN: "N",
                selectedOptions: [{
                  PCS_CD: "PRT_WHT",
                  PCS_DTL_CD: ae === "front" ? "DFXXF" : "DFXXB",
                  PCS_DTL_NM: ae === "front" ? "앞면 화이트" : "뒷면 화이트",
                  ATTB: "Y",
                  ATTB_2: "Y"
                }]
              }), W;
            }, []);
            C("PRT_WHT", "Y", k), L();
          }
        });
        function X(M) {
          const k = n.relatedData.mtrlPttCd ?? "",
            W = M.some(ae => k.includes(ae)),
            Q = n.options.find(ae => ae.PCS_CD === "PRT_WHT");
          W && Q ? (c.PRT_WHT || C("PRT_WHT", "Y", [{
            PCS_CD: "PRT_WHT",
            PCS_GRP_NM: Q.PCS_GRP_NM,
            VIEW_YN: "Y",
            ESN_YN: "N",
            selectedOptions: [{
              PCS_CD: "PRT_WHT",
              PCS_DTL_CD: Q.PCS_DTL_CD,
              PCS_DTL_NM: Q.PCS_DTL_NM,
              ATTB: "Y"
            }]
          }]), h.PRT_WHT = !0) : h.PRT_WHT = !1;
        }
        function K(M) {
          const k = _u[s.pdtCode];
          if (!k) return;
          const W = k[M],
            Q = {
              PCS_CD: "PRT_WHT",
              PCS_GRP_NM: "화이트인쇄",
              VIEW_YN: "Y",
              ESN_YN: "N",
              selectedOptions: [{
                PCS_CD: "PRT_WHT",
                PCS_DTL_CD: "DFXXX",
                PCS_DTL_NM: "화이트인쇄",
                ATTB: "Y",
                ATTB_2: "Y"
              }]
            };
          W === "Y" ? (C("PRT_WHT", "Y", [Q]), h.PRT_WHT = !0) : N.value.PRT_WHT ? C("PRT_WHT", "N") : (C("PRT_WHT", "Y", [Q]), h.PRT_WHT = !1);
        }
        function de() {
          if (!s.pdtCode.startsWith("SK")) return;
          const M = n.relatedData.sizeInfo;
          if (!M) return;
          const {
            width: k,
            height: W
          } = M.cutSize;
          k < 40 || W < 40 ? (C("HOL_DFT", "N"), h.HOL_DFT = !0) : h.HOL_DFT = !1;
        }
        U(() => n.relatedData.sizeInfo?.cutSize, () => de(), {
          deep: !0,
          immediate: !0
        });
        function be() {
          if (s.pdtCode.startsWith("NC") && ["RXSNO250", "RXSNO300"].includes(D.value) && c.ROU_DFT) {
            c.COT_DFT || C("COT_DFT", "Y"), h.COT_DFT = !0;
            return;
          }
          if (NP[s.pdtCode]?.includes(D.value)) {
            c.COT_DFT || C("COT_DFT", "Y"), h.COT_DFT = !0;
            return;
          }
          const k = N.value.COT_DFT;
          if (!k) return h.COT_DFT = !1;
          k.length === 0 ? (C("COT_DFT", "N"), h.COT_DFT = !0) : h.COT_DFT = !1;
        }
        U(() => n.disabledAddPcs, (M, k) => {
          const W = new Set(M || []),
            Q = new Set(k || []);
          for (const ae of W) {
            const ke = N.value[ae];
            ke && ke.length > 0 || (Q.has(ae) || C(ae, "N"), h[ae] = !0);
          }
          for (const ae of Q) W.has(ae) || (h[ae] = !1);
        }, {
          immediate: !0
        });
        function xe() {
          if (s.pdtCode !== "PHPRFRM") return;
          const M = N.value.THO_DFT;
          Array.isArray(M) ? (C("THO_DFT", "N"), h.THO_DFT = !0) : h.THO_DFT = !1;
        }
        U(() => !!c.ROU_DFT, () => be()), U(() => [n.relatedData.sizeInfo?.cutSize?.width, n.relatedData.sizeInfo?.cutSize?.height, n.relatedData.sizeInfo?.DIV_NM], ([M, k, W]) => {
          if (s.pdtCode !== "STTHCIC") return;
          const Q = n.options.filter(ke => ke.PCS_CD === "THO_DFT");
          if (!Q.length) return;
          let ae;
          W === "사이즈직접입력" || W === "Input Size" ? ae = Q.find(ke => ke.PCS_DTL_CD === "CLFRE") : ae = Q.find(ke => +ke.CUT_WDT === M && +ke.CUT_HGH === k), ae && (c.THO_DFT || C("THO_DFT", "Y"), c.THO_DFT?.[0] && (c.THO_DFT[0].selectedOptions = [{
            PCS_CD: ae.PCS_CD,
            PCS_DTL_CD: ae.PCS_DTL_CD,
            PCS_DTL_NM: ae.PCS_DTL_NM,
            ATTB: ""
          }]));
        }, {
          immediate: !0
        });
        const ee = b(() => s.pdtCode.startsWith("BT") ? c.COT_DFT?.[0]?.selectedOptions?.[0]?.PCS_DTL_CD === "TCMAS" : !1);
        return U(() => ee.value, M => {
          if (B.value.has("PAK_ETC")) if (M) {
            const k = B.value.get("PAK_ETC");
            c.PAK_ETC = [{
              PCS_CD: "PAK_ETC",
              PCS_GRP_NM: k.name,
              VIEW_YN: "Y",
              ESN_YN: "N",
              selectedOptions: [{
                PCS_CD: "PAK_ETC",
                PCS_DTL_CD: "DFXXX",
                PCS_DTL_NM: k.options.find(W => W.value === "DFXXX")?.name || "개별포장"
              }]
            }], h.PAK_ETC = !0;
          } else h.PAK_ETC = !1;
        }, {
          immediate: !0
        }), (M, k) => (_(), O(q, null, [T.value ? (_(), V(ve, {
          key: 0,
          title: "후가공"
        }, {
          default: fe(() => [P("div", W1, [(_(!0), O(q, null, ce(B.value.values(), W => (_(), O(q, {
            key: W.value
          }, [!(a.value && W.value === "WRK_MTR") && !M.hiddenPostPcs?.includes(W.value) ? (_(), O("div", {
            key: 0,
            class: "postpcs-btn-wrapper",
            "data-tooltip": m(W.value)
          }, [ne(Be, {
            data: W,
            active: y(zn).has(y(s).pdtCode) && W.value === "PRT_WHT" ? c.PRT_WHT?.[0]?.selectedOptions?.[0]?.ATTB === "Y" : !!c[W.value],
            onSelect: k[0] || (k[0] = Q => C(Q.value)),
            disabled: !(y(zn).has(y(s).pdtCode) && W.value === "PRT_WHT") && (h[W.value] || W.disabled || I.value[W.value]),
            "disabled-styling": !(y(zn).has(y(s).pdtCode) && W.value === "PRT_WHT") && (h[W.value] || W.disabled || I.value[W.value]) && !c[W.value]
          }, null, 8, ["data", "active", "disabled", "disabled-styling"])], 8, V1)) : J("", !0)], 64))), 128))])]),
          _: 1
        })) : J("", !0), g.value ? (_(), V(ve, {
          key: 1,
          "row-class": "postpcs-row"
        }, {
          default: fe(() => [(_(!0), O(q, null, ce(B.value.values(), W => (_(), O(q, {
            key: W.value
          }, [c[W.value] && W.component && !(a.value && W.value === "WRK_MTR") && !M.hiddenPostPcs?.includes(W.value) && !(y(s).pdtCode === "STTTDFT" && W.value === "PAK_POL" && M.relatedData.cuttingType === "CUT_DFT") ? re((_(), O("div", j1, [(_(), V(jo(W.component), {
            data: W,
            "related-data": {
              postpcs: c,
              mtrlCd: D.value,
              orderQty: M.relatedData.orderQty,
              sizeInfo: M.relatedData.sizeInfo,
              cuttingType: M.relatedData.cuttingType,
              dosuInfo: M.relatedData.dosuInfo
            },
            "disabled-options": N.value[W.value],
            "extra-notices": W.value === "COT_DFT" && D.value.includes("SNO") && (y(s).pdtCode.startsWith("NC") || y(s).pdtCode.startsWith("HL") || y(s).pdtCode.startsWith("SK")) ? [y(F)("코팅-스노우용지")] : void 0,
            "default-value": y(s).pdtCode === "STTTDFT" && W.value === "PAK_POL" && M.relatedData.cuttingType === "THO_CUT" ? "STSET" : void 0,
            onUpdate: Q => S(W.value)(Q),
            "onUpdate:replace": Q => R(W.value)(Q)
          }, null, 40, ["data", "related-data", "disabled-options", "extra-notices", "default-value", "onUpdate", "onUpdate:replace"]))], 512)), [[Lt, !(a.value && W.value === "PDT_WRK")]]) : J("", !0), a.value && W.value === "WRK_MTR" && c.PDT_WRK && W.component ? (_(), V(jo(W.component), {
            key: 1,
            data: W,
            "related-data": {
              postpcs: c,
              mtrlCd: D.value,
              orderQty: M.relatedData.orderQty,
              sizeInfo: M.relatedData.sizeInfo,
              cuttingType: M.relatedData.cuttingType,
              dosuInfo: M.relatedData.dosuInfo
            },
            "disabled-options": N.value.WRK_MTR,
            onUpdate: k[1] || (k[1] = Q => S("WRK_MTR")(Q))
          }, null, 40, ["data", "related-data", "disabled-options"])) : J("", !0)], 64))), 128))]),
          _: 1
        })) : J("", !0)], 64));
      }
    }), [["__scopeId", "data-v-5c4bc5f4"]]),
    z1 = {
      class: "grid-group"
    },
    K1 = {
      class: "flex-row"
    },
    Y1 = ["name", "disabled"],
    Q1 = ["value"],
    q1 = ["disabled"],
    bu = oe({
      __name: "SUB_MTR",
      props: {
        title: {},
        options: {},
        defaultData: {},
        qtyDisabled: {
          type: Boolean,
          default: !1
        },
        qtyHidden: {
          type: Boolean,
          default: !1
        },
        selectDisabled: {
          type: Boolean,
          default: !1
        }
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = c => {
            const d = F(c);
            if (!n.title) return d;
            const p = n.title + " ";
            return d.startsWith(p) ? d.slice(p.length) : d;
          },
          a = H(n.defaultData.PCS_DTL_CD || n.options[0].value),
          r = H(n.defaultData.qty || 1),
          i = b(() => ({
            PCS_DTL_CD: a.value,
            qty: r.value
          })),
          l = b(() => n.options.find(c => c.value === a.value)?.extra),
          u = H(n.defaultData.extra?.NOTICE || []);
        return U(() => r.value, an(c => {
          c < 1 && (r.value = 1);
        }, 300)), U(() => i.value, c => {
          u.value = l.value?.NOTICE || [], o("update", {
            ...c,
            extra: l.value
          });
        }), U(() => n.defaultData, c => {
          a.value = c.PCS_DTL_CD, r.value = c.qty;
        }, {
          deep: !0
        }), U(() => n.options, c => {
          const d = c.find(p => l.value?.SET_GRP_COD === p.extra?.SET_GRP_COD && !p.forceHidden);
          d && (a.value = d.value);
        }), (c, d) => {
          const p = it("dompurify-html");
          return _(), V(ve, {
            title: c.title,
            underline: ""
          }, {
            default: fe(() => [P("div", z1, [or(c.$slots, "extra"), P("div", K1, [re(P("select", {
              "onUpdate:modelValue": d[0] || (d[0] = f => a.value = f),
              name: `SUM_MTR/${c.title}`,
              class: "basic-select",
              disabled: c.selectDisabled
            }, [(_(!0), O(q, null, ce(c.options, f => (_(), O(q, {
              key: f.key
            }, [f.forceHidden ? J("", !0) : (_(), O("option", {
              key: 0,
              value: f.value
            }, Y(s(f.name)), 9, Q1))], 64))), 128))], 8, Y1), [[Ke, a.value]]), c.qtyHidden ? J("", !0) : re((_(), O("input", {
              key: 0,
              "onUpdate:modelValue": d[1] || (d[1] = f => r.value = f),
              type: "number",
              id: "qty",
              disabled: c.qtyDisabled,
              class: "basic-input"
            }, null, 8, q1)), [[dt, r.value]])]), u.value && u.value.length > 0 ? (_(!0), O(q, {
              key: 0
            }, ce(u.value, (f, v) => re((_(), O("p", {
              key: `notice-${v}`,
              class: "note"
            })), [[p, f]])), 128)) : J("", !0)])]),
            _: 3
          }, 8, ["title"]);
        };
      }
    }),
    X1 = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: bu
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    Z1 = {
      class: $e(["flex-row", "-flow"])
    },
    J1 = ["onUpdate:modelValue", "disabled", "placeholder"],
    eb = ["value"],
    tb = {
      key: 0,
      class: "notes"
    },
    Ou = Ne(oe({
      __name: "SUB_MTR_Multi",
      props: {
        title: {},
        options: {},
        qtyDisabled: {
          type: Boolean,
          default: !1
        },
        disabledOptions: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.options[0].extra.NOTICE),
          a = Xe(n.options.reduce((i, l) => (i[l.value] = {
            active: !1,
            data: {
              PCS_DTL_CD: l.value,
              qty: 0,
              extra: l.extra
            }
          }, i), {}));
        function r(i) {
          const l = a[i];
          l.active = !l.active, l.active ? l.data.qty = 1 : l.data.qty = 0;
        }
        return U(() => a, i => {
          const l = {};
          for (const u of Object.values(i)) {
            u.data.qty || (u.data.qty = 0, u.active = !1);
            const c = `${u.data.extra.WEB_PCS_DTL_GRP}_${u.data.PCS_DTL_CD}`;
            l[c] = u;
          }
          o("update", l);
        }, {
          deep: !0
        }), Vo(() => {
          const i = n.options[0].extra?.WEB_PCS_DTL_GRP;
          i && gu[i] && r(gu[i]);
        }), (i, l) => {
          const u = it("dompurify-html");
          return _(), V(ve, {
            title: i.title,
            underline: ""
          }, {
            default: fe(() => [P("div", Z1, [(_(!0), O(q, null, ce(i.options, c => (_(), V(Be, {
              key: c.key,
              data: {
                name: c.name,
                value: c.value,
                imgPath: `${c.extra?.PCS_CD}_${c.value}`
              },
              disabled: c.extra?.HIDE_YN === "Y" || i.disabledOptions?.includes(c.value),
              "disabled-styling": c.extra?.HIDE_YN === "Y" || i.disabledOptions?.includes(c.value),
              active: a[c.value].active,
              onSelect: l[1] || (l[1] = d => r(d.value))
            }, {
              input: fe(() => [c.extra?.HIDE_YN !== "Y" ? re((_(), O("input", {
                key: 0,
                "onUpdate:modelValue": d => a[c.value].data.qty = d,
                type: "number",
                name: "submtrl-qty",
                "max-length": "3",
                class: $e(["basic-input", "-qty"]),
                disabled: !a[c.value].active || i.qtyDisabled,
                placeholder: y(F)("summary.수량"),
                style: mt(a[c.value].active ? {} : {
                  pointerEvents: "none"
                }),
                onClick: l[0] || (l[0] = no(() => {}, ["stop"]))
              }, null, 12, J1)), [[dt, a[c.value].data.qty]]) : (_(), O("input", {
                key: 1,
                value: y(F)("주문불가"),
                name: "submtrl-qty",
                class: $e(["basic-input", "-qty"]),
                disabled: ""
              }, null, 8, eb))]),
              _: 2
            }, 1032, ["data", "disabled", "disabled-styling", "active"]))), 128))]), i.options[0].extra.NOTICE.length > 0 ? (_(), O("div", tb, [(_(!0), O(q, null, ce(Object.values(s.value), (c, d) => re((_(), O("p", {
              key: `notice-${d}`,
              class: "note"
            })), [[u, `* ${c}`]])), 128))])) : J("", !0)]),
            _: 1
          }, 8, ["title"]);
        };
      }
    }), [["__scopeId", "data-v-5c57cdd1"]]),
    nb = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ou
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    Eu = {
      SUB_MTR_KR: 1,
      SUB_MTR_CN: 2,
      SUB_MTR_CR: 3,
      SUB_MTR_BN: 4
    },
    ob = new Set(["SUB_MTR_KR", "SUB_MTR_CN", "SUB_MTR_CR", "SUB_MTR_BN"]),
    sb = new Set(["ACTHPAM", "ACTHPAA", "ACTHCKY"]),
    ab = {
      class: "flex-row"
    },
    ib = {
      key: 0,
      class: "child-groups"
    },
    tv = Ne(oe({
      __name: "Digital",
      props: {
        options: {},
        relatedData: {},
        disabledSubMtrl: {}
      },
      emits: ["update", "update:size"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("productCode", {
            pdtCode: ""
          }),
          a = _t(),
          r = Ve(),
          i = b(() => n.relatedData.sizeInfo),
          l = b(() => n.relatedData.orderQty),
          u = b(() => n.relatedData.mtrlCd),
          c = b(() => n.relatedData.setData),
          d = Xe(new Map()),
          p = b(() => [...d.values()].sort((E, L) => E.order && L.order ? E.order - L.order : 0)),
          f = Xe({});
        function v(E) {
          const L = d.get(E);
          if (L && !(L.active && D[E])) if (L.active = !L.active, L.active) {
            if (L.childGroups || Tu[E]) return;
            const G = n.relatedData.packPrnCnt;
            if (G) {
              const de = E === "SUB_MTR_SS" ? S : E === "SUB_MTR_CS" ? R : null;
              if (de) {
                const be = de[G],
                  xe = be ? L.options.find(ee => ee.value === be) : null;
                if (xe) {
                  f[L.value] = {
                    PCS_DTL_CD: be,
                    qty: xe.extra?.QTY_INPUT_YN === "Y" ? 1 : l.value || 1,
                    extra: xe.extra
                  };
                  return;
                }
              }
            }
            const X = L.options.find(de => !!de.extra?.SET_GRP_COD && !de.forceHidden),
              K = X || L.options[0];
            f[L.value] = {
              PCS_DTL_CD: K.value,
              qty: K.extra?.QTY_INPUT_YN === "Y" ? 1 : l.value || 1,
              extra: K.extra
            };
          } else if (L.childGroups) for (const G in f) G.startsWith(L.value) && delete f[G];else if (Tu[E]) for (const G in f) G.startsWith(E) && delete f[G];else delete f[L.value];
        }
        const h = E => L => {
            f[E] = L;
          },
          m = E => {
            for (const L in E) E[L].active ? f[L] = E[L].data : delete f[L];
          },
          D = Xe({});
        U(() => D, E => {
          Object.keys(E).forEach(L => v(L));
        }, {
          deep: !0
        });
        const N = E => !pu.has(s.pdtCode) && E.MTRL_CD === u.value,
          I = E => !gi[s.pdtCode] || gi[s.pdtCode] !== E.PCS_CD ? !1 : E.DIV_SEQ === i.value?.DIV_SEQ,
          w = E => !!c.value && E.SET_GRP_COD === c.value.GRP_COD && E.SET_COD === c.value.COD,
          A = {
            CT001: "SUB_MTR_CT001"
          };
        U(() => n.options.visible, E => {
          for (const L of E) {
            const G = L.SUB_MTR_GRP ? `SUB_MTR_${L.SUB_MTR_GRP}` : L.WEB_PCS_DTL_GRP,
              X = {
                name: L.PCS_DTL_NM,
                value: L.PCS_DTL_CD,
                key: L.PCS_DTL_CD,
                extra: L
              },
              K = i0[G];
            if (K) {
              const de = d.get(K);
              if (!de) d.set(K, {
                name: r0[K]?.[a.locale] || L.PCS_GRP_NM || L.PCS_DTL_NM,
                imgPath: K,
                subImgPath: L.PCS_CD,
                value: K,
                active: !1,
                options: [],
                childGroups: new Map([[G, {
                  name: L.WEB_PCS_DTL_GRP_NM || L.PCS_GRP_NM,
                  options: [X]
                }]]),
                order: Eu[K] || 0
              }), L.ESN_YN === "Y" && (D[K] = !0);else {
                const be = de.childGroups.get(G);
                be ? be.options.push(X) : de.childGroups.set(G, {
                  name: L.WEB_PCS_DTL_GRP_NM || L.PCS_GRP_NM,
                  options: [X]
                });
              }
            } else {
              const de = d.get(G);
              de ? de.options.push(X) : (d.set(G, {
                name: L.WEB_PCS_DTL_GRP_NM || L.PCS_GRP_NM || L.PCS_DTL_NM,
                imgPath: A[L.PCS_DTL_CD] ? A[L.PCS_DTL_CD] : G,
                subImgPath: L.PCS_CD,
                value: G,
                active: !!gu[G],
                options: [X],
                order: Eu[G] || 0
              }), L.ESN_YN === "Y" && (D[G] = !0));
            }
          }
        }, {
          immediate: !0
        });
        const j = b(() => n.options.essential.reduce((L, G) => (L[G.PCS_CD] = (L[G.PCS_CD] || 0) + 1, L), {})),
          B = b(() => {
            const E = [];
            for (const L of n.options.essential) {
              const {
                  PCS_CD: G,
                  VIEW_YN: X,
                  PCS_DTL_CD: K,
                  PCS_DTL_NM: de,
                  MTRL_CD: be,
                  DIV_SEQ: xe,
                  ESN_YN: ee
                } = L,
                M = {
                  PCS_CD: G,
                  VIEW_YN: X,
                  ESN_YN: ee,
                  ...(be ? {
                    MTRL_CD: be
                  } : {}),
                  DIV_SEQ: xe,
                  active: !1,
                  selectedOptions: [{
                    PCS_CD: G,
                    PCS_DTL_CD: K,
                    PCS_DTL_NM: de,
                    ATTB: l.value,
                    ATTB_2: "",
                    ATTB_3: ""
                  }]
                };
              j.value[G] > 1 ? (N(L) || I(L) || w(L)) && E.push(M) : E.push(M);
            }
            return E;
          }),
          T = b(() => {
            const E = [];
            for (const L of Object.values(f)) {
              const G = {
                PCS_CD: L.extra.PCS_CD,
                PCS_GRP_NM: L.extra.WEB_PCS_DTL_GRP_NM || L.extra.PCS_GRP_NM,
                VIEW_YN: L.extra.VIEW_YN,
                ESN_YN: L.extra.ESN_YN,
                MTRL_CD: L.extra.MTRL_CD,
                active: !0,
                selectedOptions: [{
                  PCS_CD: L.extra.PCS_CD,
                  PCS_DTL_CD: L.PCS_DTL_CD,
                  PCS_DTL_NM: L.extra.PCS_DTL_NM,
                  ATTB: L.qty,
                  ATTB_2: "",
                  ATTB_3: ""
                }]
              };
              E.push(G);
            }
            return E;
          }),
          g = b(() => [...B.value, ...T.value]);
        U(() => g.value, E => {
          o("update", E);
        }, {
          immediate: !0
        }), U(() => u.value, E => {
          if (!n.relatedData.pcsCodeForSize) return;
          const L = n.options.essential.find(ee => ee.MTRL_CD === E && ee.PCS_CD === n.relatedData.pcsCodeForSize);
          if (!L) return;
          const {
            PCS_DTL_CD: G,
            DIV_SEQ: X,
            CUT_WDT: K,
            CUT_HGH: de,
            WRK_WDT: be,
            WRK_HGH: xe
          } = L;
          o("update:size", {
            PCS_DTL_CD: G,
            DIV_SEQ: X,
            CUT_WDT: K,
            CUT_HGH: de,
            WRK_WDT: be,
            WRK_HGH: xe
          });
        }, {
          immediate: !0
        }), U(() => l.value, E => {
          Object.values(f).forEach(L => {
            L.extra.QTY_INPUT_YN !== "Y" && (L.qty = E);
          });
        }), U(() => c.value?.COD, E => {
          if (E) {
            const L = d.get("SUB_MTR_PACKING");
            L && (L.options = L.options.map(G => (G.extra?.SET_GRP_COD && (G.forceHidden = E !== G.extra.SET_COD), G)));
          }
        });
        const C = b(() => {
            const E = new Set();
            return s.pdtCode === "FBPOCHR" && r.uploadType.default === "editor" ? (d.forEach((L, G) => E.add(G)), E) : (n.relatedData.packPrnCnt && (d.get("SUB_MTR_SS")?.active && E.add("SUB_MTR_SS"), d.get("SUB_MTR_CS")?.active && E.add("SUB_MTR_CS")), E);
          }),
          S = {
            100: "SS001",
            200: "SS001",
            400: "SS002",
            600: "SS003",
            800: "SS004"
          },
          R = {
            100: "CS001",
            200: "CS001",
            400: "CS002",
            600: "CS003",
            800: "CS004"
          };
        return U(() => n.relatedData.packPrnCnt, E => {
          if (E) for (const [L, G] of [["SUB_MTR_SS", S], ["SUB_MTR_CS", R]]) {
            const X = d.get(L);
            if (!X || !X.active) continue;
            const K = G[E];
            if (!K) continue;
            const de = X.options.find(be => be.value === K);
            de && (f[L] = {
              PCS_DTL_CD: K,
              qty: de.extra?.QTY_INPUT_YN === "Y" ? 1 : l.value || 1,
              extra: de.extra
            });
          }
        }, {
          immediate: !0
        }), U(() => i.value, E => {
          const L = d.get("SUB_MTR_PV");
          L && (E?.DIV_SEQ === 0 || E?.DIV_NM === "사이즈직접입력" ? (L.active = !1, L.disabled = !0, delete f.SUB_MTR_PV) : (L.disabled = !1, L.options = L.options.map(G => (G.forceHidden = !I(G.extra), G)).sort(G => G.forceHidden ? 0 : -1)));
        }), U(() => r.foilPcsDtlCd, E => {
          if (console.log("[FBPOCHR/foil] foilPcsDtlCd changed:", E, "/ pdtCode:", s.pdtCode), !(s.pdtCode !== "FBPOCHR" || !E)) {
            console.log("[FBPOCHR/foil] subMaterialMap entries:", [...d.entries()].map(([L, G]) => ({
              key: L,
              active: G.active,
              options: G.options.map(X => X.value)
            })));
            for (const [L, G] of d.entries()) {
              if (!G.active) {
                console.log("[FBPOCHR/foil] skip (not active):", L);
                continue;
              }
              const X = G.options.find(K => K.value === E);
              console.log("[FBPOCHR/foil] key:", L, "/ targetOpt:", X?.value ?? "NOT FOUND"), X && (f[L] = {
                PCS_DTL_CD: E,
                qty: X.extra?.QTY_INPUT_YN === "Y" ? 1 : l.value || 1,
                extra: X.extra
              }, console.log("[FBPOCHR/foil] selectedSubMtrl updated:", L, "->", E));
            }
          }
        }), (E, L) => (_(), O(q, null, [d.size ? (_(), V(ve, {
          key: 0,
          title: "부자재선택"
        }, {
          default: fe(() => [P("div", ab, [(_(!0), O(q, null, ce(p.value, G => (_(), V(Be, {
            key: G.value,
            active: G.active,
            disabled: G.disabled,
            "disabled-styling": !0,
            data: G,
            onSelect: L[0] || (L[0] = X => v(X.value))
          }, null, 8, ["active", "disabled", "data"]))), 128))])]),
          _: 1
        })) : J("", !0), (_(!0), O(q, null, ce(p.value, G => (_(), O(q, {
          key: G.value
        }, [G.active ? (_(), V(ve, {
          key: 0
        }, {
          default: fe(() => [G.childGroups?.size ? (_(), O("div", ib, [(_(!0), O(q, null, ce(Array.from(G.childGroups), ([X, K]) => (_(), V(Ou, {
            key: X,
            title: K.name,
            options: K.options,
            "qty-disabled": K.options[0]?.extra?.QTY_INPUT_YN !== "Y",
            "disabled-options": E.disabledSubMtrl?.[G.value],
            onUpdate: m
          }, null, 8, ["title", "options", "qty-disabled", "disabled-options"]))), 128))])) : y(Tu)[G.value] === "icon" ? (_(), V(Ou, {
            key: 1,
            title: G.name,
            options: G.options,
            "qty-disabled": G.options[0].extra.QTY_INPUT_YN !== "Y",
            "disabled-options": E.disabledSubMtrl?.[G.value],
            onUpdate: m
          }, null, 8, ["title", "options", "qty-disabled", "disabled-options"])) : (_(), V(bu, {
            key: 2,
            title: G.name,
            options: G.options,
            "default-data": f[G.value],
            "qty-disabled": G.options[0].extra.QTY_INPUT_YN !== "Y",
            "qty-hidden": y(s).pdtCode === "FBPOCHR",
            "select-disabled": C.value.has(G.value),
            onUpdate: X => h(G.value)(X)
          }, null, 8, ["title", "options", "default-data", "qty-disabled", "qty-hidden", "select-disabled", "onUpdate"]))]),
          _: 2
        }, 1024)) : J("", !0)], 64))), 128))], 64));
      }
    }), [["__scopeId", "data-v-1c273b56"]]),
    rb = {
      key: 0,
      class: "loading-spinner"
    },
    lb = ["for"],
    ub = {
      class: "guide"
    },
    cb = {
      class: "desc"
    },
    db = {
      class: "desc detail"
    },
    fb = ["id", "accept"],
    pb = {
      key: 1,
      class: "uploaded"
    },
    _b = {
      class: "file-name",
      id: "upload_cust_file_nm"
    },
    hb = ["src"],
    vb = 1024 * 1024 * 1024,
    mb = Ne(oe({
      __name: "S3Uploader",
      props: {
        _key: {
          default: "default"
        },
        allowedExt: {
          default() {
            return {
              types: ["application/pdf"]
            };
          }
        }
      },
      emits: ["upload"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = _t(),
          a = b(() => n.allowedExt.types.join(", ")),
          r = H("");
        function i(m) {
          if (n.allowedExt.types.includes(m.type)) return !0;
          const D = "." + m.name.split(".").pop()?.toLowerCase();
          return n.allowedExt.types.some(N => N === "application/pdf" ? D === ".pdf" : !1);
        }
        async function l(m) {
          return !m || !i(m) ? (alert(F("파일형식에러메시지", {
            ext: a.value
          })), !1) : m.size >= vb ? (alert(F("파일형식에러메시지")), !1) : !0;
        }
        async function u(m) {
          if (!m) return 0;
          const D = {
              file_name: m,
              lang: s.locale
            },
            N = await XS(D);
          return N ? N.ContentLength : 0;
        }
        async function c(m, D) {
          const N = m === "I" && !!D,
            I = N ? await u(D.name.new) : null,
            w = N ? {
              gbn: "I",
              new_file_nm: D.name.new,
              new_file_size: D.size,
              org_file_nm: D.name.original,
              s3_file_size: I,
              s3_region: "AWS"
            } : null;
          r.value = N ? D.name.original : "", o("upload", [w]);
        }
        const d = H(!1);
        async function p(m) {
          try {
            const D = m.name;
            d.value = !0;
            const I = await (await fetch(`${is}/api/aws/presigned-url`, {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                body: JSON.stringify({
                  filename: D
                })
              })).json(),
              {
                filename: w,
                presignedURL: A
              } = I;
            if (!A || !w) throw new Error("파일 업로드 중 문제가 발생했습니다.");
            const j = await fetch(A, {
              method: "PUT",
              headers: {
                "Content-Type": m.type || "application/pdf"
              },
              body: m
            });
            if (j instanceof Response && j.status !== 200) throw new Error("파일 업로드 실패");
            const B = {
              name: {
                new: w,
                original: D
              },
              size: m.size
            };
            await c("I", B);
          } catch (D) {
            D instanceof Error && (console.error("[RedWidgetSDK/ERROR] 파일 업로드 시 에러 발생 > ", D.message), alert(D.message));
          } finally {
            d.value = !1;
          }
        }
        async function f(m) {
          const D = m.target;
          if (!D.files) return;
          const N = D.files[0];
          (await l(N)) && (await p(N));
        }
        async function v(m) {
          const D = m.dataTransfer?.files;
          if (!D) return;
          const N = [...D],
            I = N.length === 1 ? N[0] : N.find(A => i(A));
          !I || !(await l(I)) || (await p(I));
        }
        async function h() {
          const m = F("업로드파일삭제메시지");
          confirm(m) && (await c("D"));
        }
        return (m, D) => (_(), O("div", {
          class: "s3-uploader",
          onDragover: D[0] || (D[0] = no(() => {}, ["prevent"])),
          onDrop: no(v, ["prevent"])
        }, [r.value ? (_(), O("div", pb, [P("span", _b, Y(r.value), 1), P("button", {
          type: "button",
          class: "delete-btn",
          onClick: h
        }, [P("img", {
          src: `${y(ut)}/ko/order_addfile_remove_icon.svg`,
          alt: "delete-icon"
        }, null, 8, hb)])])) : (_(), O(q, {
          key: 0
        }, [d.value ? (_(), O("div", rb)) : (_(), O("label", {
          key: 1,
          for: `file-${m._key}`,
          class: "file-uploader"
        }, [D[1] || (D[1] = P("div", {
          class: "upload-btn"
        }, "+", -1)), P("div", ub, [P("p", cb, Y(y(F)(m.allowedExt?.names || "pdf-only")), 1), P("p", db, Y(y(F)(m.allowedExt?.desc || "파일업로드레이어안내")), 1)])], 8, lb)), P("input", {
          type: "file",
          id: `file-${m._key}`,
          accept: a.value,
          class: "hidden",
          onChange: f
        }, null, 40, fb)], 64))], 32));
      }
    }), [["__scopeId", "data-v-3ccac45e"]]),
    Cb = {
      key: 0,
      class: "loading-spinner"
    },
    Tb = ["for"],
    gb = {
      class: "guide"
    },
    yb = {
      class: "desc"
    },
    Db = {
      class: "desc detail"
    },
    Sb = ["id", "accept"],
    Pb = {
      key: 1,
      class: "uploaded"
    },
    bb = {
      class: "file-name",
      id: "upload_cust_file_nm"
    },
    Ob = ["src"],
    Eb = 1024 * 1024 * 1024,
    Ib = Ne(oe({
      __name: "GarageUploader",
      props: {
        _key: {
          default: "default"
        },
        allowedExt: {
          default() {
            return {
              types: ["application/pdf"]
            };
          }
        }
      },
      emits: ["upload"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => n.allowedExt.types.join(", ")),
          a = H("");
        function r(v) {
          if (n.allowedExt.types.includes(v.type)) return !0;
          const h = "." + v.name.split(".").pop()?.toLowerCase();
          return n.allowedExt.types.some(m => m === "application/pdf" ? h === ".pdf" : !1);
        }
        async function i(v) {
          return !v || !r(v) ? (alert(F("파일형식에러메시지", {
            ext: s.value
          })), !1) : v.size >= Eb ? (alert(F("파일형식에러메시지")), !1) : !0;
        }
        async function l(v, h, m = !1) {
          const D = v === "I" && !!h,
            N = D ? {
              gbn: "I",
              new_file_nm: h.name.new,
              new_file_size: h.size,
              org_file_nm: h.name.original,
              s3_file_size: null,
              s3_region: m ? "AWS" : "GA"
            } : null;
          a.value = D ? h.name.original : "", o("upload", [N]);
        }
        async function u(v) {
          const h = v.name;
          async function m(D) {
            const I = await (await fetch(`${is}${D}`, {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                body: JSON.stringify({
                  filename: h
                })
              })).json(),
              {
                filename: w,
                presignedURL: A
              } = I;
            if (!A || !w) throw new Error("presigned URL 발급 실패");
            if ((await fetch(A, {
              method: "PUT",
              headers: {
                "Content-Type": v.type || "application/pdf"
              },
              body: v
            })).status !== 200) throw new Error("파일 업로드 실패");
            return w;
          }
          c.value = !0;
          try {
            let D,
              N = !1;
            try {
              console.log("[Garage] 업로드 시도:", is + "/api/garage/presigned-url"), D = await m("/api/garage/presigned-url"), console.log("[Garage] 업로드 성공:", D);
            } catch (I) {
              console.warn("[RedWidgetSDK] Garage 업로드 실패, AWS로 fallback >", I), D = await m("/api/aws/presigned-url"), N = !0;
            }
            await l("I", {
              name: {
                new: D,
                original: h
              },
              size: v.size
            }, N);
          } catch (D) {
            D instanceof Error && (console.error("[RedWidgetSDK/ERROR] 파일 업로드 시 에러 발생 > ", D.message), alert(D.message));
          } finally {
            c.value = !1;
          }
        }
        const c = H(!1);
        async function d(v) {
          const h = v.target;
          if (!h.files) return;
          const m = h.files[0];
          (await i(m)) && (await u(m));
        }
        async function p(v) {
          const h = v.dataTransfer?.files;
          if (!h) return;
          const m = [...h],
            D = m.length === 1 ? m[0] : m.find(N => r(N));
          D && (await i(D)) && (await u(D));
        }
        async function f() {
          confirm(F("업로드파일삭제메시지")) && (await l("D"));
        }
        return (v, h) => (_(), O("div", {
          class: "s3-uploader",
          onDragover: h[0] || (h[0] = no(() => {}, ["prevent"])),
          onDrop: no(p, ["prevent"])
        }, [a.value ? (_(), O("div", Pb, [P("span", bb, Y(a.value), 1), P("button", {
          type: "button",
          class: "delete-btn",
          onClick: f
        }, [P("img", {
          src: `${y(ut)}/ko/order_addfile_remove_icon.svg`,
          alt: "delete-icon"
        }, null, 8, Ob)])])) : (_(), O(q, {
          key: 0
        }, [c.value ? (_(), O("div", Cb)) : (_(), O("label", {
          key: 1,
          for: `file-${v._key}`,
          class: "file-uploader"
        }, [h[1] || (h[1] = P("div", {
          class: "upload-btn"
        }, "+", -1)), P("div", gb, [P("p", yb, Y(y(F)(v.allowedExt?.names || "pdf-only")), 1), P("p", Db, Y(y(F)(v.allowedExt?.desc || "파일업로드레이어안내")), 1)])], 8, Tb)), P("input", {
          type: "file",
          id: `file-${v._key}`,
          accept: s.value,
          class: "hidden",
          onChange: d
        }, null, 40, Sb)], 64))], 32));
      }
    }), [["__scopeId", "data-v-281c3ddf"]]),
    Iu = {
      type1: new Set(["CLSTSHS", "CLSTLOS", "CLSTSWT"]),
      type2: new Set(["CLTMMTS", "CLTMHDS", "CLTMSHS"]),
      type3: new Set(["CLDFSHS", "CLDFLOS", "CLDFDRR", "CLDFDRP", "CLDFDRK", "CLDFNCP", "CLSTBSA", "CLSTBST", "CLSTSHD", "CLSTSPK", "CLSTDLD", "CLSTDLB", "CLSTLSD", "CLSTBLS", "CLDFALP", "CLDFALT"])
    };
  function Rb(e, t) {
    const n = e.PDT_CD,
      o = e.PDT_NM,
      s = t.meterialInfo,
      a = t.meterialInfo.MTRL_CD[5],
      r = t.clothesSelectData.sizeInfo[0];
    if (Iu.type1.has(n)) if (s.PTT_CD === "SRT") {
      const l = {
        X: 1,
        1: 2,
        2: 2,
        3: 3,
        4: 3,
        5: 3,
        6: 3
      }[a];
      return {
        pdt_cod: n,
        detail_cod: `${n}_${s.PTT_CD}_${l}`,
        file_nm: s.PTT_NM || ""
      };
    } else {
      const i = ["X", "1", "2"].includes(a) ? 1 : 2;
      return {
        pdt_cod: n,
        detail_cod: `${n}_${s.PTT_CD}_${i}`,
        file_nm: s.PTT_NM || ""
      };
    }
    if (n === "CLSTTOB") return {
      pdt_cod: n,
      detail_cod: `${n}_${r.size.COD_NME[0]}`,
      file_nm: `${s.PTT_NM}_${r.size.COD_NME}`
    };
    if (Iu.type2.has(n)) {
      const i = t.pcsInfo.find(l => l.PCS_CD === "DIR_MTR");
      return {
        pdt_cod: n,
        detail_cod: `${n}_${i?.DIV_SEQ}`,
        file_nm: o
      };
    }
    if (Iu.type3.has(n)) {
      if (n === "CLDFNCP") return {
        pdt_cod: n,
        detail_cod: `${n}_${a}`,
        file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${a}`
      };
      if (n === "CLSTSPK") {
        const u = {
          1: 1,
          2: 1,
          3: 2,
          4: 3,
          5: 3,
          6: 3
        }[a];
        return {
          pdt_cod: n,
          detail_cod: `${n}_${u}`,
          file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${u}`
        };
      }
      if (n === "CLSTDLB") {
        const l = ["2", "3"].includes(a) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${l}`,
          file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${l}`
        };
      }
      if (s.PTT_CD === "QSC") {
        const l = ["A", "B", "C"].includes(a) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${l}`,
          file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${l}`
        };
      }
      if (n === "CLDFDRR" && ["A", "B", "C", "D", "E"].includes(a)) {
        const l = ["A", "B", "C"].includes(a) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_kids_${l}`,
          file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${l}`
        };
      }
      const i = ["1", "2"].includes(a) ? 1 : 2;
      return {
        pdt_cod: n,
        detail_cod: `${n}_${i}`,
        file_nm: `${s.PTT_NM}_${r.size.COD_NME}-${i}`
      };
    }
    if (n === "CLDFMHS") if (["QTB", "ZTB"].includes(s.PTT_CD || "")) {
      const i = ["1", "2", "3"].includes(a) ? 1 : 2;
      return {
        pdt_cod: n,
        detail_cod: `${n}_${s.PTT_CD}_${i}`,
        file_nm: o
      };
    } else {
      const i = ["1", "2"].includes(a) ? 1 : 2;
      return {
        pdt_cod: n,
        detail_cod: `${n}_${s.PTT_CD}_${i}`,
        file_nm: o
      };
    }
    return {
      pdt_cod: n,
      file_nm: o
    };
  }
  function Nb(e) {
    const t = e.pcsInfo.filter(u => u.PCS_CD.startsWith("CVR_")),
      n = t.length > 1 ? t.find(u => u.PCS_CD !== "CVR_SFT")?.PCS_CD : t[0].PCS_CD,
      o = e.pcsInfo.find(u => H1.has(u.PCS_CD)),
      s = o?.PCS_CD,
      a = e.priceCalc.result.seneca_info?.seneca;
    if (s === "PER_DFT" && !a) return "세네카오류";
    const r = o?.selectedOptions[0].PCS_DTL_CD,
      i = r === "BPTOP" ? `${r}${o?.selectedOptions[0].BACK_ROT_YN === "N" ? "B" : "A"}` : r,
      l = e.sizeInfo.cutSize;
    return {
      cover_type: n,
      COVER_DFT: n,
      bindType: s,
      pressDirection: i,
      seneca: a,
      printSide: e.dosuInfo.COD,
      number3: `${e.quantityInfo.prnCnt}`,
      cut_wdt: `${l.width}`,
      cut_hgh: `${l.height}`,
      is_layflat: ""
    };
  }
  const ua = {
    DIV_SEQ: {
      GSTTDTM: !0,
      GSBKBCH: !0,
      GSBKLAP: !0
    },
    DIV_NM: {
      GSFBRCN: !0
    },
    PCS_CD: {
      GSTTACR: "LAS_DFT",
      GSCAEPB: "DIR_MTR",
      GSCAGBP: "DIR_MTR",
      GSCAGBM: "DIR_MTR",
      GSCAGBR: "DIR_MTR",
      GSCAGBH: "DIR_MTR",
      GSCATPP: "DIR_MTR",
      GSCATPG: "DIR_MTR",
      GSCATCP: "DIR_MTR",
      GSCACDP: "DIR_MTR",
      GSCAPHN: "DIR_MTR",
      GSTGMIC: "THO_CUT",
      LFTEXXX: "THO_DFT",
      WBXXXXX: "THO_DFT",
      PRCPDFT: "THO_CAP"
    },
    PDT_CD$PCS_CD: {
      GSACPAN: "THO_CUT"
    },
    PCS_CD$DOSU: {
      LFDLXXX: "THO_DFT"
    }
  };
  function Ab(e, t, n = "ko") {
    if (t.clothesSelectData) return Rb(e, t);
    const o = e.PDT_CD,
      s = e.PDT_NM;
    if (ua.DIV_SEQ[o]) return {
      pdt_cod: o,
      detail_cod: `${o}_${t.sizeInfo.DIV_SEQ}`,
      file_nm: `${s} ${t.sizeInfo.DIV_NM}`
    };
    if (ua.DIV_NM[o]) return {
      pdt_cod: o,
      detail_cod: `${o}_${t.sizeInfo.DIV_NM}`,
      file_nm: `${s} ${t.sizeInfo.DIV_NM}`
    };
    const a = ua.PCS_CD[o];
    if (a) {
      const l = t.pcsInfo.find(u => u.PCS_CD === a)?.selectedOptions[0];
      return {
        pdt_cod: o,
        detail_cod: `${a}_${l?.PCS_DTL_CD}`,
        file_nm: l?.PCS_DTL_NM && l.PCS_DTL_NM !== s ? `${s} ${l.PCS_DTL_NM}` : s
      };
    }
    const r = ua.PDT_CD$PCS_CD[o];
    if (r) {
      const l = t.pcsInfo.find(u => u.PCS_CD === r)?.selectedOptions[0];
      return {
        pdt_cod: o,
        detail_cod: `${o}_${r}_${l?.PCS_DTL_CD}`,
        file_nm: `${s} ${l?.PCS_DTL_NM}`
      };
    }
    const i = ua.PCS_CD$DOSU[o];
    if (i) {
      const l = t.dosuInfo,
        u = l.COD.slice(-1),
        c = l.COD_NME,
        d = t.pcsInfo.find(p => p.PCS_CD === i)?.selectedOptions[0];
      return {
        pdt_cod: o,
        detail_cod: `${i}_${d?.PCS_DTL_CD}_${u}`,
        file_nm: `${d?.PCS_DTL_NM} ${c}`
      };
    }
    if (o.startsWith("BT")) {
      const l = t.pcsInfo.find(c => c.PCS_CD === "THO_DFT")?.selectedOptions[0];
      if (o === "BTOPXXX" && l?.PCS_DTL_CD === "OVO01") return {
        pdt_cod: o,
        detail_cod: "BTOPXXX_THO_DFT_OVX01",
        file_nm: `${s} ${l.PCS_DTL_NM}`
      };
      if (o === "BTMRCPT") return {
        pdt_cod: o,
        detail_cod: "THO_DFT_CLX04",
        file_nm: `${s} ${l.PCS_DTL_NM}`
      };
      const u = l?.PCS_DTL_CD ? l.PCS_DTL_CD.slice(0, 2) + "X" + l.PCS_DTL_CD.slice(3) : "";
      return {
        pdt_cod: o,
        detail_cod: u ? `THO_DFT_${u}` : o,
        file_nm: l ? `${s} ${l.PCS_DTL_NM}` : s
      };
    }
    if (o === "STTTDFT") {
      const l = ["THO_CUT", "PDT_WRK", "CUT_DFT"].find(f => t.pcsInfo.find(v => v.PCS_CD === f)),
        u = l === "PDT_WRK" ? "CUT" : l?.substring(0, 3) ?? "",
        c = l === "PDT_WRK" ? "HC_" : "",
        d = t.sizeInfo.cutSize,
        p = `${d.width}x${d.height}`;
      return {
        pdt_cod: o,
        detail_cod: `${o}_${u}_${c}${p}`,
        file_nm: `${s} ${p}`
      };
    }
    if (o === "TPCLECO") {
      const l = t.dosuInfo,
        u = t.sizeInfo,
        c = l.COD.slice(-1);
      return {
        pdt_cod: o,
        detail_cod: `${o}_${u.DIV_NM}_${c}`,
        file_nm: `${s} ${u.DIV_NM} ${l.COD_NME}`
      };
    }
    if (["ACTHDKY", "ACTHDCO"].includes(o)) {
      const l = t.acrylicSelectData.printData;
      return {
        pdt_cod: o,
        detail_cod: `${o}_${l.COD}`,
        file_nm: `${s} ${l.COD_NME}`
      };
    }
    if (o === "GSCACAP") {
      const u = t.meterialInfo.WGT_CD.startsWith("4") ? 2 : 1,
        c = `${u === 1 ? 3 : 4}${n === "ko" ? "구" : "Button"}`;
      return {
        pdt_cod: o,
        detail_cod: `${o}_${u}`,
        file_nm: `${s}-${c}`
      };
    }
    return {
      pdt_cod: o,
      file_nm: s,
      detail_cod: ""
    };
  }
  const Mb = {
      class: "upload-group"
    },
    wb = {
      class: "upload-type"
    },
    Lb = {
      class: "selected-uploader"
    },
    kb = {
      key: 0,
      class: "edit-btn-wrapper"
    },
    $b = ["src"],
    Fb = {
      key: 0
    },
    Ub = {
      key: 1
    },
    Bb = {
      class: "note"
    },
    xb = {
      class: "note"
    },
    Hb = {
      key: 0,
      class: "note"
    },
    us = Ne(oe({
      __name: "Uploader",
      props: {
        _key: {
          default: "default"
        },
        showExtra: {
          type: Boolean,
          default: !1
        },
        uploadConfig: {},
        allowedExt: {},
        relatedData: {},
        subject: {},
        notes: {},
        editorNotes: {},
        hideEditor: {
          type: Boolean
        }
      },
      emits: ["upload"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = Te("callbacks", {}),
          i = H(!1),
          l = b(() => a.pdtCode.startsWith("PRBK")),
          u = b(() => n.relatedData?.size?.DIV_SEQ === 0);
        function c(I) {
          const w = new Set(["SKTHDFT"]);
          if (I === "editor") {
            if (n.relatedData?.hasPdfOnlyPostPcs && !["GSNTPVC", "STPADIY"].includes(a.pdtCode) || zh.has(a.pdtCode) && u.value || n.relatedData?.hasScodix) return !0;
            const A = new Set(["ACTHFCO", "ACTHBCO", "ACTHDKY"]);
            if (n.relatedData?.print?.COD === "X" && !A.has(a.pdtCode) || w.has(a.pdtCode) && n.relatedData?.cuttingType === "THO_GRA_FR" || a.pdtCode === "STSKDFT" && n.relatedData?.shape && n.relatedData.shape !== "FR") return !0;
          }
          return !!(I === "pdf" && (w.has(a.pdtCode) && n.relatedData?.cuttingType === "THO_DFT_RC" || a.pdtCode === "STSKDFT" && n.relatedData?.shape === "FR"));
        }
        const d = ra(),
          p = Mo(),
          f = _t();
        async function v() {
          const I = d.getProductBaseInfo(),
            w = p.getOrderData();
          if (!I || !w) return;
          const A = Ab(I.product_data.pdt_base_info[0], w, f.locale);
          if (!A) return alert(F("템플릿다운로드실패"));
          (await ZS({
            lang: f.locale,
            ...A
          })) || alert(F("템플릿다운로드실패"));
        }
        const h = b(() => n.uploadConfig.editor);
        async function m() {
          if (s.isAfterEdit(n._key)) {
            if (h.value === "KOI") {
              const w = s.payloadForEditorConfig[n._key];
              if (w) {
                const j = await (await fetch(`${is}/api/editor/config/${h.value}`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json"
                  },
                  body: JSON.stringify({
                    token: n.uploadConfig.token,
                    payload: w
                  })
                })).json();
                if (!j.error) {
                  const B = {
                    mode: "EDIT",
                    type: h.value,
                    ...j,
                    config: {
                      projectId: s.editorData[n._key]?.projectID
                    }
                  };
                  return console.log("getEditorConfig (EDIT/KOI) > ", B), B;
                }
              }
            }
            return {
              mode: "EDIT",
              type: h.value,
              config: {
                initType: "open",
                project_id: s.editorData[n._key]?.projectID
              },
              option: null,
              error: null
            };
          } else {
            const I = s.payloadForEditorConfig[n._key];
            if (!I) return;
            const w = {
                token: n.uploadConfig.token,
                payload: I
              },
              j = await (await fetch(`${is}/api/editor/config/${h.value}`, {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                body: JSON.stringify(w)
              })).json();
            if (j.error) console.error("[RedWidgetSDK/ERROR] 에디터 초기 설정 시 문제가 발생했습니다.");else {
              const B = {
                mode: "NEW",
                type: h.value,
                ...j
              };
              return console.log("getEditorConfig > ", B), B;
            }
          }
        }
        async function D() {
          if (n.relatedData?.apparel && n.relatedData.apparel.printType === "PTP_SLK" && !n.relatedData.apparel.pantone) {
            const I = "팬톤 컬러를 선택해주세요";
            return r?.onCallMsg ? r.onCallMsg("warn", I) : alert(I);
          }
          if (r?.onOpenEditor && h.value) {
            const I = await m();
            I && r.onOpenEditor(I);
          }
        }
        function N(I) {
          o("upload", I), i.value = !0;
        }
        return U(() => n.relatedData?.print, I => {
          ["ACTHFCO", "ACTHDKY"].includes(a.pdtCode) || I?.COD === "X" && n.uploadConfig.pdf && s.setUploadType("pdf", n._key);
        }), U(() => n.relatedData?.cuttingType, I => {
          a.pdtCode === "SKTHDFT" && (I === "THO_GRA_FR" && s.setUploadType("pdf", n._key), I === "THO_DFT_RC" && s.setUploadType("editor", n._key));
        }), U(() => n.relatedData?.shape, I => {
          a.pdtCode === "STSKDFT" && (I === "FR" ? s.setUploadType("pdf", n._key) : I && s.setUploadType("editor", n._key)), a.pdtCode === "GSELBHD" && (I === "FR" ? s.setUploadType("pdf", n._key) : I && s.setUploadType("editor", n._key));
        }, {
          immediate: !0
        }), U(() => s.uploadType[n._key], I => {
          if (i.value && I === "editor") {
            o("upload", [null]);
            return;
          }
          if (s.editorData[n._key] && I === "pdf") {
            r?.onReset && r.onReset("fileUpload");
            return;
          }
        }), U(() => n.uploadConfig, I => {
          !I.editor && I.pdf && s.setUploadType("pdf", n._key);
        }, {
          immediate: !0
        }), U(() => n.relatedData?.hasScodix, I => {
          I && (s.setUploadType("pdf"), s.editorData.default && r?.onReset && r.onReset("fileUpload"));
        }), U(() => n.relatedData?.hasPdfOnlyPostPcs, I => {
          I && n.uploadConfig.pdf && !["GSNTPVC"].includes(a.pdtCode) && s.setUploadType("pdf", n._key);
        }), U(() => u.value, I => {
          I && zh.has(a.pdtCode) && (s.setUploadType("pdf"), s.editorData.default && r?.onReset && r.onReset("fileUpload"));
        }), (I, w) => {
          const A = it("dompurify-html");
          return _(), V(ve, {
            title: I.subject || "파일업로드",
            extra: I.showExtra ? {
              name: "템플릿다운로드",
              callback: v
            } : null,
            option: "Uploader"
          }, {
            default: fe(() => [P("div", Mb, [P("div", wb, [I.uploadConfig.pdf && !c("pdf") ? (_(), O("button", {
              key: 0,
              type: "button",
              class: $e(["upload-btn", {
                active: y(s).uploadType[I._key] === "pdf"
              }]),
              onClick: w[0] || (w[0] = () => y(s).setUploadType("pdf"))
            }, Y(I.allowedExt?.names || "PDF"), 3)) : J("", !0), I.uploadConfig.editor && !c("editor") && !I.hideEditor ? (_(), O("button", {
              key: 1,
              type: "button",
              class: $e(["upload-btn", {
                active: y(s).uploadType[I._key] === "editor"
              }]),
              onClick: w[1] || (w[1] = () => y(s).setUploadType("editor"))
            }, Y(y(F)("에디터")), 3)) : J("", !0)]), P("div", Lb, [y(s).uploadType[I._key] === "pdf" && I.uploadConfig.useGarage ? (_(), V(Ib, {
              key: 0,
              _key: I._key,
              "allowed-ext": I.allowedExt,
              onUpload: N
            }, null, 8, ["_key", "allowed-ext"])) : y(s).uploadType[I._key] === "pdf" ? (_(), V(mb, {
              key: 1,
              _key: I._key,
              "allowed-ext": I.allowedExt,
              onUpload: N
            }, null, 8, ["_key", "allowed-ext"])) : J("", !0), y(s).uploadType[I._key] === "editor" ? (_(), O(q, {
              key: 2
            }, [l.value ? (_(), O("div", kb, [P("img", {
              src: `${y(ut)}/ko/cover_templatge_list.png`,
              alt: "free template images"
            }, null, 8, $b), re(P("button", {
              class: "upload-btn edit",
              onClick: D
            }, null, 512), [[A, y(F)("무료디자인편집")]])])) : (_(), O("button", {
              key: 1,
              type: "button",
              class: "upload-btn edit",
              onClick: D
            }, Y(y(s).isAfterEdit(I._key) ? y(F)("재편집하기") : y(F)("편집하기")), 1))], 64)) : J("", !0)]), y(s).uploadType[I._key] === "editor" && I.editorNotes?.length ? (_(), O("div", Fb, [(_(!0), O(q, null, ce(I.editorNotes, (j, B) => re((_(), O("p", {
              key: `editor-note-${B}`,
              class: "note"
            })), [[A, j]])), 128))])) : J("", !0), y(s).uploadType[I._key] === "pdf" ? (_(), O("div", Ub, [(_(!0), O(q, null, ce(I.notes, (j, B) => re((_(), O("p", {
              key: `note-${B}`,
              class: "note"
            })), [[A, j]])), 128)), P("p", Bb, "* " + Y(y(F)("파일업로드-MS")), 1), P("p", xb, "* " + Y(y(F)("파일업로드-후가공레이어")), 1), I.allowedExt?.note ? (_(), O("p", Hb, "* " + Y(y(F)(I.allowedExt.note)), 1)) : J("", !0)])) : J("", !0)])]),
            _: 1
          }, 8, ["title", "extra"]);
        };
      }
    }), [["__scopeId", "data-v-30497475"]]),
    ca = Ne(oe({
      __name: "POTCodeButton",
      props: {
        uploadConfig: {}
      },
      setup(e) {
        const t = e,
          n = Te("productCode", {
            pdtCode: ""
          }),
          o = Te("callbacks", {}),
          s = Te("member"),
          a = Ve(),
          r = Mo(),
          i = b(() => t.uploadConfig?.editor);
        async function l() {
          if (i.value) {
            if (a.isAfterEdit()) return {
              mode: "EDIT",
              type: i.value,
              config: i.value === "KOI" ? {
                projectId: a.editorData.default?.projectID
              } : {
                initType: "open",
                project_id: a.editorData.default?.projectID
              },
              option: null,
              error: null
            };
            {
              const c = a.payloadForEditorConfig.default;
              if (!c) return;
              const d = {
                  token: t.uploadConfig?.token,
                  payload: c
                },
                f = await (await fetch(`${is}/api/editor/config/${i.value}`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json"
                  },
                  body: JSON.stringify(d)
                })).json();
              if (f.error) console.error("[RedWidgetSDK/ERROR] 에디터 초기 설정 시 문제가 발생했습니다.");else return {
                mode: "NEW",
                type: i.value,
                ...f
              };
            }
          }
        }
        async function u() {
          const c = await l(),
            d = r.getOrderData();
          if (!d) return;
          const p = {
            pdt_cod: n.pdtCode,
            customerOrderData: d,
            memberInfo: {
              mb_id: s?.mb_id || "redprinting",
              mb_cust_cod: s?.mb_cust_cod || "10000000"
            },
            editorData: {
              editorConfig: c?.config,
              editorOption: c?.option
            }
          };
          if (o?.onCreatePot) return o.onCreatePot(p);
          console.log(p);
        }
        return (c, d) => y(s)?.pot_yn === "Y" ? (_(), O("button", {
          key: 0,
          type: "button",
          class: "pot-btn",
          onClick: u
        }, " 주문 관리 코드 생성 ")) : J("", !0);
      }
    }), [["__scopeId", "data-v-4f45d3d8"]]),
    Gb = {
      class: "grid"
    },
    Wb = {
      class: "flex-row"
    },
    nv = Ne(oe({
      __name: "OffsetPaperLayout",
      props: {
        options: {},
        title: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = b(() => n.title ?? "옵셋-명함타입"),
          s = t,
          a = {
            WAT_TRW: [{
              name: "가로3단형",
              value: "3",
              imgPath: "FLD_DFT_3W"
            }, {
              name: "가로N형",
              value: "N",
              imgPath: "FLD_DFT_3W_N"
            }],
            WAT_TRH: [{
              name: "세로3단형",
              value: "3",
              imgPath: "FLD_DFT_3H"
            }, {
              name: "세로N형",
              value: "N",
              imgPath: "FLD_DFT_3H_N"
            }]
          },
          r = H(n.options[0].DIV_ATTB),
          i = b(() => r.value === "WAT_TRW" || r.value === "WAT_TRH"),
          l = H("2");
        U(() => r.value, c => {
          if (i.value) {
            const d = a[c][0];
            l.value = d.value;
          } else l.value = "2";
        });
        const u = b(() => ({
          layout: r.value,
          foldingWay: l.value
        }));
        return U(() => u.value, c => {
          s("update", c);
        }, {
          immediate: !0
        }), (c, d) => (_(), O(q, null, [ne(ve, {
          title: o.value
        }, {
          default: fe(() => [P("div", Gb, [(_(!0), O(q, null, ce(c.options, p => (_(), V(Be, {
            key: p.DIV_SEQ,
            data: {
              name: p.DIV_ATTB_NM,
              value: p.DIV_ATTB,
              imgPath: p.DIV_ATTB
            },
            active: p.DIV_ATTB === r.value,
            onSelect: d[0] || (d[0] = f => r.value = f.value)
          }, null, 8, ["data", "active"]))), 128))])]),
          _: 1
        }, 8, ["title"]), i.value ? (_(), V(ve, {
          key: 0,
          title: "명함형태"
        }, {
          default: fe(() => [P("div", Wb, [(_(!0), O(q, null, ce(a[r.value], p => (_(), V(Be, {
            key: p.name,
            data: p,
            active: p.value === l.value,
            onSelect: d[1] || (d[1] = f => l.value = f.value)
          }, null, 8, ["data", "active"]))), 128))])]),
          _: 1
        })) : J("", !0)], 64));
      }
    }), [["__scopeId", "data-v-66fd2786"]]),
    Pi = (e, t) => {
      const n = {
          visible: [],
          hidden: []
        },
        o = {
          visible: [],
          essential: []
        },
        s = t?.reduce((i, l) => {
          const {
            MTRL_CD: u,
            PCS_CD: c,
            PCS_DTL_CD: d
          } = l;
          if (!i[u]) i[u] = {
            [c]: d ? [d] : []
          };else {
            const p = i[u][c];
            p ? d ? p.length > 0 && p.push(d) : i[u][c] = [] : i[u][c] = d ? [d] : [];
          }
          return i;
        }, {});
      if (s) {
        const i = new Set(e.filter(l => l.PCS_CD === "COT_DFT").map(l => l.PCS_DTL_CD));
        if (i.size > 0) for (const l of Object.values(s)) {
          const u = l.COT_DFT;
          if (!u || u.length === 0) continue;
          [...i].every(d => u.includes(d)) && (l.COT_DFT = []);
        }
      }
      const a = {
        essential: [],
        optional: []
      };
      for (const i of e) {
        const {
          PCS_CD: l,
          ESN_YN: u,
          VIEW_YN: c,
          WEB_PCS_DTL_GRP: d
        } = i;
        Cu[l] && !Cu[l].includes(d) ? u === "Y" && c === "N" ? o.essential.push(i) : o.visible.push(i) : c === "N" ? u === "Y" && n.hidden.push(i) : u === "Y" ? a.essential.push(i) : a.optional.push(i);
      }
      const r = [...a.essential, ...a.optional];
      return n.visible = r, {
        postPcs: n,
        sub: o,
        disabled: s
      };
    };
  function da(e) {
    const t = b(() => {
        const {
            usePDF: o,
            useKoiEditor: s,
            useRPEditor: a,
            koiAccessToken: r,
            rpAccessToken: i,
            isUseGarage: l
          } = e,
          u = s === "N" && a === "N" ? null : s === "Y" ? "KOI" : "RP";
        return {
          useGarage: l === "Y",
          editor: u,
          pdf: o === "Y",
          ...(u ? {
            token: u === "KOI" ? r : i.token
          } : {})
        };
      }),
      n = b(() => {
        const {
          usePDF: o,
          usePDFordCnt: s,
          useEditorOrdCnt: a
        } = e;
        return {
          pdf: o === "Y" && s === "Y",
          editor: a === "Y"
        };
      });
    return {
      uploadConfig: t,
      canEditOrdCnt: n
    };
  }
  function fa(e, {
    group: t,
    emits: n
  }) {
    const o = b(() => e === "new" ? null : {}),
      s = H(e === "new" ? {} : o.value),
      a = (c, d) => p => {
        if (t === "acrylic2025_item") {
          s.value = {
            ...s.value,
            ...(d ? {} : {
              [c]: p
            }),
            acrylicSelectData: {
              ...s.value.acrylicSelectData,
              ...(d ? {
                [c]: p
              } : {})
            }
          };
          return;
        }
        if (t === "clothes2025_item") {
          s.value = {
            ...s.value,
            ...(d ? {} : {
              [c]: p
            }),
            clothesSelectData: {
              ...s.value.clothesSelectData,
              ...(d ? {
                [c]: p
              } : {}),
              ...(c === "quantityInfo" ? {
                quantity: p.prnCnt
              } : {})
            }
          };
          return;
        }
        s.value = {
          ...s.value,
          [c]: p
        };
      };
    U(() => s.value, an(c => {
      n.updateOrder(c);
    }, 150), {
      deep: !0
    });
    const r = H(e === "new" ? {} : {}),
      i = c => d => {
        r.value = {
          ...r.value,
          [c]: d
        };
      };
    U(() => r.value, c => {
      s.value.pcsInfo = Object.values(c).flatMap(d => d);
    });
    const l = Xe({
        hidden: {},
        visible: {}
      }),
      u = c => d => {
        l[c] = d;
      };
    return U(() => l, c => {
      const d = Object.values(c.hidden).flatMap(f => f),
        p = Object.values(c.visible).flatMap(f => f);
      i("POST_PCS")([...d, ...p]);
    }, {
      deep: !0
    }), {
      defaultOrderData: o,
      orderInfo: s,
      pcsInfo: r,
      updateOption: a,
      updatePcsOption: i,
      updatePostPcs: u
    };
  }
  const Vb = {
      class: "widget-error"
    },
    jb = {
      key: 0,
      class: "reason"
    },
    ov = Ne(oe({
      __name: "Error",
      props: {
        message: {}
      },
      setup(e) {
        return (t, n) => (_(), O("div", Vb, [n[0] || (n[0] = P("p", null, "주문 위젯을 생성할 수 없습니다 😱", -1)), t.message ? (_(), O("p", jb, Y(t.message), 1)) : J("", !0)]));
      }
    }), [["__scopeId", "data-v-33e3660e"]]),
    bi = "https://s3-ap-northeast-2.amazonaws.com/redprintingweb.common/assets/images/ordericon",
    Oi = "PRT_M",
    zb = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "Digital",
        props: {
          type: {
            default: "new"
          },
          data: {},
          widgetAttr: {},
          defaultData: {},
          senecaInfo: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.data.pdt_base_info[0].PDT_CD),
            a = b(() => n.widgetAttr.skinInfo),
            r = [{
              value: "LIGHT",
              name: "LIGHT",
              imgOn: `${bi}/btn_light.svg`,
              imgOff: `${bi}/btn_light_off.svg`
            }, {
              value: "PREMIUM",
              name: "PREMIUM",
              imgOn: `${bi}/btn_premium.svg`,
              imgOff: `${bi}/btn_premium_off.svg`,
              postPcsCd: "SCO_DFT"
            }],
            i = b(() => [F("PHPLEDT-LIGHT-안내"), F("PHPLEDT-PREMIUM-안내")]),
            l = H([]),
            u = H("CUT_DFT"),
            c = b(() => []),
            d = b(() => {
              if (s.value === "FBDCMOS" && ie.value.meterialInfo?.MTRL_CD === "PXPRB002") return {
                POL_BAG: ["PO006"]
              };
            }),
            p = b(() => s.value !== "STTTDFT" ? [] : u.value === "THO_CUT" ? ["PDT_WRK"] : []),
            f = b(() => {
              if (s.value !== "STTTDFT" || u.value !== "THO_CUT") return;
              const te = ie.value.meterialInfo?.MTRL_CD || "";
              return {
                ...Q.value.disabled,
                [te]: {
                  ...(Q.value.disabled?.[te] ?? {}),
                  PAK_POL: ["DFXXX"]
                }
              };
            }),
            v = b(() => s.value !== "PRPORSO" ? [] : n.data.pdt_pcs_info.filter(te => te.PCS_CD.startsWith(Oi)).map(te => ({
              name: (te.PCS_DTL_NM ?? "").replace(" 단면", ""),
              value: `${te.PCS_CD}||${te.PCS_DTL_CD}`
            }))),
            h = H({});
          function m(te) {
            const ue = Object.fromEntries(Object.entries(h.value).filter(([Fe]) => !Fe.startsWith(Oi))),
              De = te || v.value[0]?.value;
            if (De) {
              const [Fe, Ge] = De.split("||"),
                un = n.data.pdt_pcs_info.find(cs => cs.PCS_CD === Fe);
              un && (ue[Fe] = [{
                PCS_CD: un.PCS_CD,
                PCS_GRP_NM: un.PCS_GRP_NM,
                VIEW_YN: "N",
                ESN_YN: "Y",
                selectedOptions: [{
                  PCS_CD: un.PCS_CD,
                  PCS_DTL_CD: Ge,
                  PCS_DTL_NM: un.PCS_DTL_NM,
                  ATTB: ""
                }]
              }]);
            }
            Ue("hidden")(ue);
          }
          const D = H({});
          function N() {
            const te = u.value,
              ue = new Set(["CUT_DFT", "THO_CUT"]),
              De = Object.fromEntries(Object.entries(D.value).filter(([Ge]) => !ue.has(Ge))),
              Fe = n.data.pdt_pcs_info.find(Ge => Ge.PCS_CD === te);
            Fe && (De[te] = [{
              PCS_CD: Fe.PCS_CD,
              PCS_GRP_NM: Fe.PCS_GRP_NM,
              VIEW_YN: Fe.VIEW_YN,
              ESN_YN: Fe.ESN_YN,
              selectedOptions: [{
                PCS_CD: Fe.PCS_CD,
                PCS_DTL_CD: Fe.PCS_DTL_CD,
                PCS_DTL_NM: Fe.PCS_DTL_NM,
                ATTB: ""
              }]
            }]), Ue("hidden")(De);
          }
          function I(te) {
            u.value = te.forcedPostPcs[0] ?? "CUT_DFT", s.value === "STTTDFT" && N();
          }
          function w(te) {
            if (s.value === "PHPTPRM") {
              Qe.value = te;
              const ue = Qe.value.HND_CLP;
              Ue("hidden")(ue ? {
                ...te,
                HND_CLP: ue
              } : te);
              return;
            }
            if (s.value === "STTTDFT") {
              D.value = te, N();
              return;
            }
            if (s.value === "PRPORSO") {
              h.value = te;
              const ue = Object.entries(h.value).find(([Fe]) => Fe.startsWith(Oi));
              if (!ue) {
                Ue("hidden")(te);
                return;
              }
              const De = Object.fromEntries(Object.entries(te).filter(([Fe]) => !Fe.startsWith(Oi)));
              De[ue[0]] = ue[1], Ue("hidden")(De);
              return;
            }
            Ue("hidden")(te);
          }
          const A = Te("member"),
            j = [{
              name: "곡선 꽂이",
              value: "CV",
              key: "CV"
            }, {
              name: "사선 꽂이",
              value: "DI",
              key: "DI"
            }],
            B = [{
              name: "왼쪽",
              value: "L",
              key: "L"
            }, {
              name: "가운데",
              value: "C",
              key: "C"
            }, {
              name: "오른쪽",
              value: "R",
              key: "R"
            }],
            T = H("CV"),
            g = H("C"),
            C = b(() => {
              if (!n.data.option_info) return !1;
              const {
                shape_info: te
              } = n.data.option_info;
              return !rn(te) && s.value.startsWith("ST") && te.length === 1 ? !1 : !rn(te) && !!te[0].COD;
            }),
            S = b(() => !s.value.startsWith("BT") || !n.data.pdt_mtrl_info.some(ue => ue.PTT_CD?.includes("YPI")) ? null : ie.value.shapeInfo?.COD === "SQ" ? "RXYPI250" : "RXYPI150"),
            R = b(() => {
              if (s.value !== "GSSTPRT") return;
              const te = ie.value.meterialInfo?.MTRL_CD;
              if (te === "SXSMT016") return F("자석거치대부착가능");
              if (te === "SXSMT014") return F("자석거치대부착불가");
            }),
            E = b(() => A?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(te => te.BSN_YN !== "Y")),
            L = $n(() => ["PHPRFRM", "PHPTBKG", "PHPTDFT", "PHPRDFT", "PHPKDFT", "PHPTEDT", "STTTDFT"].includes(s.value) ? Promise.resolve().then(() => pv) : yu(Object.assign({
              "../options/material/Acrylic.vue": () => Promise.resolve().then(() => qb),
              "../options/material/Basic.vue": () => Promise.resolve().then(() => pv),
              "../options/material/Paper.vue": () => Promise.resolve().then(() => uI)
            }), `../options/material/${E.value[0].MTRL_TYPE === "R" ? "Paper" : "Basic"}.vue`, 4)),
            G = new Set(["BCFDDFT", "BCFDHIG"]),
            X = b(() => {
              if (!G.has(s.value)) return;
              const te = n.data.pdt_add_info[0];
              if (!rn(te[0])) return te.reduce((ue, De) => (ue[De.DIV_ATTB] || (ue[De.DIV_ATTB] = []), ue[De.DIV_ATTB].push(De), ue), {});
            }),
            K = H(X.value ? Object.keys(X.value)[0] : void 0),
            de = H("2"),
            be = b(() => {
              const te = [...n.data.pdt_size_info];
              if (K.value && X.value) {
                const ue = X.value[K.value].reduce((Fe, Ge) => Fe.add(Ge.DIV_SEQ), new Set()),
                  De = te.filter(Fe => ue.has(Fe.DIV_SEQ));
                if (de.value === "N") {
                  const Fe = K.value === "WAT_TRW";
                  return De.map(Ge => ({
                    ...Ge,
                    CUT_WDT: Fe ? String(+Ge.CUT_WDT + 2) : Ge.CUT_WDT,
                    CUT_HGH: Fe ? Ge.CUT_HGH : String(+Ge.CUT_HGH + 2),
                    WRK_WDT: Fe ? String(+Ge.WRK_WDT + 2) : Ge.WRK_WDT,
                    WRK_HGH: Fe ? Ge.WRK_HGH : String(+Ge.WRK_HGH + 2)
                  }));
                }
                return De;
              }
              if (s.value === "FBDCMOS" && ie.value.meterialInfo?.MTRL_CD) {
                const ue = ie.value.meterialInfo.MTRL_CD,
                  De = ["PXPRB001", "PXPSLXXX"].includes(ue) ? 1 : ue === "PXPRB002" ? 2 : null;
                if (De !== null) return te.filter(Fe => Fe.DIV_SEQ === De);
              }
              if (s.value === "GSSTPRT" && ie.value.meterialInfo?.MTRL_CD) {
                const ue = ie.value.meterialInfo.MTRL_CD,
                  De = n.data.pdt_pcs_info.filter(Fe => Fe.PCS_CD === "DIR_MTR" && Fe.MTRL_CD === ue);
                if (De.length) return te.filter(Fe => De.some(Ge => +Ge.CUT_WDT == +Fe.CUT_WDT && +Ge.CUT_HGH == +Fe.CUT_HGH));
              }
              if ((s.value === "BTALLGT" || s.value === "BTALEGG" || s.value === "BTFOTOT") && k.btnType) {
                const ue = k.btnType,
                  De = n.data.pdt_pcs_info.filter(Fe => Fe.PCS_CD === "BTN_DFT" && Fe.PCS_DTL_CD.indexOf(ue) > -1);
                if (De.length) {
                  const Fe = ie.value.shapeInfo?.COD;
                  return (C.value && Fe ? te.filter(un => un.STICKER_TYPE === Fe) : te).filter(un => De.some(cs => +cs.CUT_WDT == +un.CUT_WDT && +cs.CUT_HGH == +un.CUT_HGH));
                }
              }
              return !C.value || !ie.value.shapeInfo || te.length === 1 || s.value === "PRCAPPO" ? te : te.filter(ue => ue.STICKER_TYPE === ie.value.shapeInfo.COD);
            }),
            xe = H(null),
            ee = te => {
              xe.value = te;
            },
            M = b(() => LP.has(s.value)),
            k = Xe({}),
            W = te => ue => {
              k[te] = ue;
            },
            Q = b(() => Pi(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            {
              uploadConfig: ae,
              canEditOrdCnt: ke
            } = da(n.widgetAttr),
            nt = new Set(["GSSKHND", "GSSKSHH", "GSSTPRT"]),
            Ze = b(() => nt.has(s.value) ? {
              ...ke.value,
              pdf: !1
            } : ke.value),
            ot = Ve(),
            ht = b(() => {
              let te = A?.bsn_yn === "Y" && ot.uploadType.default === "pdf" ? "DesignQty" : fu[s.value] || "DesignQty";
              return M.value && (te = "CalendarQty"), $n(() => yu(Object.assign({
                "../options/qty/BookQty.vue": () => Promise.resolve().then(() => ZE),
                "../options/qty/CalendarQty.vue": () => Promise.resolve().then(() => HM),
                "../options/qty/DesignQty.vue": () => Promise.resolve().then(() => hO),
                "../options/qty/OffsetQty.vue": () => Promise.resolve().then(() => HI),
                "../options/qty/SetQty.vue": () => Promise.resolve().then(() => nw),
                "../options/qty/SimpleQty.vue": () => Promise.resolve().then(() => dw),
                "../options/qty/TotalQty.vue": () => Promise.resolve().then(() => Tw)
              }), `../options/qty/${te}.vue`, 4));
            }),
            ft = b(() => {
              if (!n.data.pdt_add_pcs_info?.length) return [];
              const te = ie.value.meterialInfo?.MTRL_CD;
              return n.data.pdt_add_pcs_info.filter(ue => ue.MTRL_CD === te);
            }),
            $ = b(() => !!(Q.value.postPcs.visible.some(te => te.PCS_CD === "PRT_WHT") || ft.value.some(te => te.PCS_CD === "PRT_WHT"))),
            x = b(() => {
              if (!n.data.pdt_add_pcs_info?.length) return [];
              const te = ie.value.meterialInfo?.MTRL_CD,
                ue = new Set(n.data.pdt_pcs_info.map(Ge => Ge.PCS_CD)),
                De = new Set(n.data.pdt_add_pcs_info.filter(Ge => Ge.MTRL_CD === te).map(Ge => Ge.PCS_CD));
              return [...new Set(n.data.pdt_add_pcs_info.map(Ge => Ge.PCS_CD))].filter(Ge => !De.has(Ge) && !ue.has(Ge));
            }),
            Z = b(() => (Pe.value.POST_PCS || []).some(ue => a0.has(s.value) && ue.PCS_CD === "THO_GRA" ? !1 : Kh.has(ue.PCS_CD))),
            pe = b(() => {
              const te = n.data.pdt_base_info[0];
              if (te.DAY_PRDC_PDT_YN !== "N") return {
                type: te.DAY_PRDC_PDT_YN,
                maxQty: te.DAY_ABLE_PRN_CNT
              };
            }),
            le = H([]),
            se = b(() => {
              if (!["TPBLMEO", "TPBLPST"].includes(s.value)) return !1;
              const te = ie.value.sizeInfo?.cutSize;
              return te?.width === 80 && te?.height === 80;
            }),
            me = b(() => {
              const te = n.data.pdt_prn_cnt_info;
              return !["TPBLMEO", "TPBLPST"].includes(s.value) || ie.value.dosuInfo?.COD !== "SID_X" ? te : te.map(ue => ({
                ...ue,
                MIN_PRN_CNT: 1,
                DFT_PRN_CNT: Math.max(1, ue.DFT_PRN_CNT)
              }));
            }),
            ye = b(() => {
              if (s.value !== "WBXXXXX") return [];
              const ue = [...n.data.pdt_pcs_info, ...(n.data.pdt_add_pcs_info ?? [])].filter(Fe => Fe.PCS_CD === "CPN_DFT");
              if (!ue.length) return [];
              const De = ie.value.sizeInfo?.DIV_SEQ;
              return ue.some(Fe => Fe.DIV_SEQ === De) ? [] : ["CPN_DFT"];
            }),
            ge = b(() => {
              if (!["TPBLMEO", "TPBLPST"].includes(s.value) || ie.value.dosuInfo?.COD !== "SID_X") return !1;
              const te = ie.value.pcsInfo?.find(ue => ue.PCS_CD === "PRT_SID");
              return ["PT001", "PT003", "PT004"].includes(te?.selectedOptions[0]?.PCS_DTL_CD ?? "");
            }),
            {
              defaultOrderData: _e,
              orderInfo: ie,
              pcsInfo: Pe,
              updateOption: Oe,
              updatePcsOption: Me,
              updatePostPcs: Ue
            } = fa(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: te => o("update", te)
              }
            }),
            Qe = H({});
          U(() => Pe.value.POST_PCS?.find(te => te.PCS_CD === "WRK_MTR"), te => {
            if (s.value !== "PHPTPRM") return;
            const ue = n.data.pdt_pcs_info.find(Fe => Fe.PCS_CD === "HND_CLP");
            if (!ue) return;
            const De = {
              ...Qe.value
            };
            te ? De.HND_CLP = [{
              PCS_CD: "HND_CLP",
              PCS_GRP_NM: ue.PCS_GRP_NM,
              VIEW_YN: "N",
              ESN_YN: "N",
              selectedOptions: [{
                PCS_CD: "HND_CLP",
                PCS_DTL_CD: ue.PCS_DTL_CD,
                PCS_DTL_NM: ue.PCS_DTL_NM,
                ATTB: ""
              }]
            }] : delete De.HND_CLP, Ue("hidden")(De);
          });
          const qe = b(() => Pe.value.SUB_MTR?.find(te => te.PCS_CD === gi[s.value])),
            vt = b(() => (Pe.value.POST_PCS ?? []).filter(te => te.VIEW_YN === "Y").map(te => te.PCS_CD).join(",")),
            yt = b(() => vt.value ? vt.value.split(",") : []),
            Ot = b(() => (Pe.value.POST_PCS ?? []).flatMap(te => te.selectedOptions ?? []).map(te => te.PCS_DTL_CD).filter(Boolean).join(",")),
            Nt = b(() => Ot.value ? Ot.value.split(",") : []),
            Dt = b(() => Ti[n.data.pdt_base_info[0].PDT_CD] ? ie.value.quantityInfo?.prnCnt || 1 : (ie.value.quantityInfo?.ordCnt || 1) * (ie.value.quantityInfo?.prnCnt || 1)),
            zt = H(null),
            rt = Te("callbacks", {});
          U(() => M.value, te => {
            te && be.value.length === 0 && (zt.value = "달력 사이즈 설정이 필요합니다");
          }, {
            immediate: !0
          }), U(() => zt.value, te => {
            te && rt?.onError && rt.onError(te || "주문 위젯 에러 발생");
          }, {
            immediate: !0
          });
          const At = () => {
            rt?.onReset && rt.onReset("fileUpload");
          };
          return U(() => ie.value.dosuInfo?.COD, te => {
            ot.isAfterEdit() && te === "SID_X" && At();
          }), U(() => ie.value.meterialInfo?.MTRL_CD, (te, ue) => {
            s.value.startsWith("ST") && ot.isAfterEdit() && (!ue || te === ue || At());
          }), (te, ue) => zt.value ? (_(), V(ov, {
            key: 0,
            message: zt.value
          }, null, 8, ["message"])) : (_(), O(q, {
            key: 1
          }, [a.value.pageDirection.view_yn === "Y" && y(ie)?.dosuInfo?.COD !== "SID_X" ? (_(), V(Qh, {
            key: 0,
            "related-data": {
              sizeInfo: y(ie).sizeInfo,
              firstSize: k.sizeFromPostPcs ?? te.data.pdt_size_info[0]
            },
            onUpdate: ue[0] || (ue[0] = De => y(Oe)("pageDirection")(De))
          }, null, 8, ["related-data"])) : J("", !0), n.data.option_material_filters ? (_(), V(M0, {
            key: 1,
            options: n.data.option_material_filters,
            onUpdate: ee
          }, null, 8, ["options"])) : J("", !0), n.data.option_info?.color_info ? (_(), V(L0, {
            key: 2,
            data: n.data.option_info?.color_info,
            onUpdate: ue[1] || (ue[1] = De => y(Oe)("setData")(De))
          }, null, 8, ["data"])) : J("", !0), s.value === "PHPLEDT" ? (_(), V(j0, {
            key: 3,
            types: r,
            notices: i.value,
            onUpdate: ue[2] || (ue[2] = De => l.value = De)
          }, null, 8, ["notices"])) : J("", !0), X.value ? (_(), V(nv, {
            key: 4,
            title: "명함타입",
            options: Object.values(X.value).map(De => De[0]),
            onUpdate: ue[3] || (ue[3] = De => {
              K.value = De.layout, de.value = De.foldingWay;
            })
          }, null, 8, ["options"])) : J("", !0), C.value ? (_(), V(qh, {
            key: 5,
            options: te.data.option_info?.shape_info || [],
            default: y(_e)?.shapeInfo,
            "disabled-options": s.value === "PHPLEDT" && l.value.includes("SCO_DFT") ? ["ME", "LA"] : void 0,
            onUpdate: ue[4] || (ue[4] = De => y(Oe)("shapeInfo")(De))
          }, null, 8, ["options", "default", "disabled-options"])) : J("", !0), s.value === "PRCATCK" ? (_(), O(q, {
            key: 6
          }, [ne(ve, {
            title: "꽂이 모양"
          }, {
            default: fe(() => [ne(ln, {
              options: j,
              default: T.value,
              onSelect: ue[5] || (ue[5] = De => T.value = De)
            }, null, 8, ["default"])]),
            _: 1
          }), ne(ve, {
            title: "꽂이 위치"
          }, {
            default: fe(() => [ne(ln, {
              options: B,
              default: g.value,
              onSelect: ue[6] || (ue[6] = De => g.value = De)
            }, null, 8, ["default"])]),
            _: 1
          })], 64)) : J("", !0), te.data.pdt_add_option_info?.length ? (_(), V(B0, {
            key: 7,
            options: te.data.pdt_add_option_info,
            "min-prn-cnt-override": ["TPBLMEO", "TPBLPST"].includes(s.value) && y(ie).dosuInfo?.COD === "SID_X" ? 1 : void 0,
            onUpdate: ue[7] || (ue[7] = De => y(Oe)("addOptionInfo")(De)),
            "onUpdate:prnCntOptions": ue[8] || (ue[8] = De => le.value = De)
          }, null, 8, ["options", "min-prn-cnt-override"])) : J("", !0), s.value === "BTALLGT" || s.value === "BTALEGG" || s.value === "BTFOTOT" ? (_(), V(H0, {
            key: 8,
            code: s.value,
            onUpdate: ue[9] || (ue[9] = De => W("btnType")(De))
          }, null, 8, ["code"])) : J("", !0), s.value === "STTTDFT" ? (_(), V(X0, {
            key: 9,
            onUpdate: I
          })) : J("", !0), re((_(), V(jo(y(L)), {
            options: E.value,
            default: y(_e)?.meterialInfo,
            "reset-after-edit": y($h).has(te.data.pdt_base_info[0].PDT_CD) && y(ot).isAfterEdit(),
            "show-extra": te.widgetAttr.able_paper_yn === "Y",
            "related-data": {
              POST_PCS: qe.value,
              filters: xe.value,
              sizeInfo: y(ie).sizeInfo,
              forcedMtrlCd: S.value,
              lockedMtrl: S.value !== null,
              notice: R.value
            },
            onUpdate: ue[10] || (ue[10] = De => y(Oe)("meterialInfo")(De))
          }, null, 40, ["options", "default", "reset-after-edit", "show-extra", "related-data"])), [[Lt, a.value.paperSelect.view_yn === "Y"]]), re(ne(Du, {
            options: te.data.pdt_dosu_info,
            default: y(_e)?.dosuInfo,
            "related-data": {
              mtrlCd: y(ie).meterialInfo?.MTRL_CD,
              mtrlDosu: y(ie).meterialInfo?.SID_GBN,
              addClrMtrlList: E.value,
              hasPrtWht: $.value,
              size: y(ie).sizeInfo?.cutSize,
              packPrnCnt: y(ie).addOptionInfo?.PACK_PRN_CNT,
              tpblSidSOnly: ["TPBLMEO", "TPBLPST"].includes(s.value) && !se.value
            },
            onUpdate: ue[11] || (ue[11] = De => y(Oe)("dosuInfo")(De))
          }, null, 8, ["options", "default", "related-data"]), [[Lt, a.value.dosuSelect.view_yn === "Y" && te.data.pdt_dosu_info]]), te.data.option_info?.thickness_info ? (_(), V(l1, {
            key: 10,
            options: te.data.option_info.thickness_info,
            onUpdate: ue[12] || (ue[12] = De => W("thickness")(De))
          }, null, 8, ["options"])) : J("", !0), re(ne(yi, {
            options: be.value,
            "base-info": te.data.pdt_base_info[0],
            default: y(_e)?.size,
            "related-data": {
              shape: y(ie).shapeInfo?.COD,
              sizeFromPostPcs: te.data.pdt_base_info[0].SIZE_PCS_USE ? k.sizeFromPostPcs : null,
              pageDirection: y(ie).pageDirection?.COD,
              mtrlPttCd: y(ie).meterialInfo?.PTT_CD ?? "",
              activePostPcs: yt.value,
              activePcsDtl: Nt.value
            },
            onUpdate: ue[13] || (ue[13] = De => y(Oe)("sizeInfo")(De)),
            onValidate: ue[14] || (ue[14] = De => y(Oe)("validation")(De)),
            "onUpdate:shape": ue[15] || (ue[15] = De => W("shapeFromSize")(De))
          }, null, 8, ["options", "base-info", "default", "related-data"]), [[Lt, a.value.sizeSelect.view_yn === "Y"]]), M.value && y(ot).uploadType.default === "editor" && !y(Fh).has(s.value) ? (_(), V(U1, {
            key: 11,
            onUpdate: ue[16] || (ue[16] = De => y(Oe)("calendarInfo")(De))
          })) : J("", !0), a.value.quantityGroup.view_yn === "Y" ? (_(), V(jo(ht.value), {
            key: 12,
            "can-edit-ord-cnt": Ze.value,
            options: te.data.pdt_add_option_info?.length && le.value.length ? le.value : me.value,
            default: y(_e)?.quantityInfo,
            "default-set-cnt": te.data.pdt_base_info[0].SET_CNT,
            unit: te.data.pdt_base_info[0].PDT_UNIT,
            "max-prn-cnt": te.data.pdt_base_info[0].MAX_PRN_CNT,
            "extra-prn-cnt-options": te.data.pdt_add_option_info?.length ? void 0 : te.data.pdt_prn_cnt_info_add,
            "related-data": {
              dosu: y(ie).dosuInfo?.COD,
              size: y(ie).sizeInfo?.DIV_NM,
              divSeq: y(ie).sizeInfo?.DIV_SEQ,
              mtrlCd: y(ie).meterialInfo?.MTRL_CD,
              shape: y(ie).shapeInfo?.COD
            },
            "express-shipping": pe.value,
            onUpdate: ue[17] || (ue[17] = De => y(Oe)("quantityInfo")(De))
          }, null, 40, ["can-edit-ord-cnt", "options", "default", "default-set-cnt", "unit", "max-prn-cnt", "extra-prn-cnt-options", "related-data", "express-shipping"])) : J("", !0), a.value.subjectGroup.view_yn === "Y" ? (_(), V(Su, {
            key: 13,
            "is-biz-mem": y(A)?.bsn_yn === "Y",
            onUpdate: ue[18] || (ue[18] = De => y(Oe)("etcInfo")(De))
          }, null, 8, ["is-biz-mem"])) : J("", !0), v.value.length ? (_(), V(e1, {
            key: 14,
            options: v.value,
            onUpdate: m,
            onValidate: ue[19] || (ue[19] = De => y(Oe)("validation")(De))
          }, null, 8, ["options"])) : J("", !0), ne(Di, {
            options: Q.value.postPcs.hidden,
            "related-data": {
              shape: y(ie).shapeInfo?.COD || k.shapeFromSize,
              mtrlCd: y(ie).meterialInfo?.MTRL_CD,
              sizeInfo: y(ie).sizeInfo,
              thickness: k.thickness,
              orderQty: Dt.value,
              dosu: y(ie).dosuInfo?.COD,
              btnType: k.btnType,
              mtrlLinkedPcs: te.data.pdt_base_info[0].SIZE_PCS_USE,
              paperLayout: K.value,
              foldingWay: de.value,
              prcatckShape: s.value === "PRCATCK" ? T.value : void 0,
              prcatckPosition: s.value === "PRCATCK" ? g.value : void 0
            },
            "disabled-opts": Q.value.disabled,
            onUpdate: ue[20] || (ue[20] = De => w(De))
          }, null, 8, ["options", "related-data", "disabled-opts"]), ne(Si, {
            options: [...(Array.isArray(Q.value.postPcs.visible) ? Q.value.postPcs.visible : []), ...(Array.isArray(ft.value) ? ft.value : [])],
            "related-data": {
              mtrlCd: y(ie).meterialInfo?.MTRL_CD,
              mtrlPttCd: y(ie).meterialInfo?.PTT_CD,
              sizeInfo: y(ie).sizeInfo,
              orderQty: Dt.value,
              dosuInfo: y(ie).dosuInfo,
              shape: y(ie).shapeInfo?.COD,
              cuttingType: s.value === "STTTDFT" ? u.value : void 0
            },
            "attb-opts": te.data.pdt_add_info[1],
            "disabled-opts": f.value ?? Q.value.disabled,
            "disabled-add-pcs": [...x.value, ...p.value, ...ye.value, ...(y(ie).addOptionInfo?.PACK_PRN_CNT === 100 ? ["PRT_SID"] : []), ...(["TPBLMEO", "TPBLPST"].includes(s.value) && !se.value ? ["PRT_SID"] : [])],
            "hidden-post-pcs": s.value === "PHPLEDT" ? ["SCO_DFT"] : void 0,
            "forced-post-pcs": [...c.value, ...(y(ie).addOptionInfo && y(ie).addOptionInfo.PACK_PRN_CNT !== 100 && y(ie).dosuInfo?.COD === "SID_X" ? ["PRT_SID"] : []), ...(ye.value.length === 0 && s.value === "WBXXXXX" ? ["CPN_DFT"] : [])],
            onUpdate: ue[21] || (ue[21] = De => y(Ue)("visible")(De))
          }, null, 8, ["options", "related-data", "attb-opts", "disabled-opts", "disabled-add-pcs", "hidden-post-pcs", "forced-post-pcs"]), ne(tv, {
            options: Q.value.sub,
            "related-data": {
              orderQty: Dt.value,
              sizeInfo: y(ie).sizeInfo,
              mtrlCd: y(ie).meterialInfo?.MTRL_CD,
              pcsCodeForSize: te.data.pdt_base_info[0].SIZE_PCS_USE,
              setData: y(ie)?.setData,
              packPrnCnt: y(ie).addOptionInfo?.PACK_PRN_CNT
            },
            "disabled-sub-mtrl": d.value,
            onUpdate: ue[22] || (ue[22] = De => y(Me)("SUB_MTR")(De)),
            "onUpdate:size": ue[23] || (ue[23] = De => W("sizeFromPostPcs")(De))
          }, null, 8, ["options", "related-data", "disabled-sub-mtrl"]), te.widgetAttr.order_yn !== "N" && (y(ie).dosuInfo?.COD !== "SID_X" || s.value === "STSKDFT" || ge.value) && !(s.value === "STSKDFT" && y(ie).shapeInfo?.COD && y(ie).shapeInfo.COD !== "FR") ? (_(), V(us, {
            key: 15,
            "upload-config": y(ae),
            "show-extra": te.widgetAttr.useTemplateDownload === "Y" && te.widgetAttr.usePDF === "Y",
            "related-data": {
              size: y(ie).sizeInfo,
              hasPdfOnlyPostPcs: Z.value,
              shape: y(ie).shapeInfo?.COD
            },
            "editor-notes": s.value === "STTBDFT" ? [y(F)("STTBDFT-업로드안내")] : ["STTHUSR", "STPADIY"].includes(s.value) ? [y(F)("자유형스티커-에디터안내1"), y(F)("자유형스티커-에디터안내2")] : void 0,
            "hide-editor": s.value === "GSELBHD" && y(ie).shapeInfo?.COD === "FR",
            onUpload: ue[24] || (ue[24] = De => y(Oe)("fileUploadInfo")(De))
          }, null, 8, ["upload-config", "show-extra", "related-data", "editor-notes", "hide-editor"])) : J("", !0), ne(ca, {
            "upload-config": y(ae)
          }, null, 8, ["upload-config"])], 64));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    Kb = oe({
      __name: "Method",
      props: {
        options: {},
        default: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = _t(),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = Te("callbacks", {}),
          i = Te("deviceType", "pc"),
          l = b(() => n.options.map(p => ({
            name: p.COD_NME,
            value: p.COD,
            key: p.COD
          }))),
          u = H(n.default || l.value[0].value),
          c = p => {
            u.value = p;
          },
          d = b(() => n.options.map((p, f) => ({
            IDX: f + 1,
            CATEGORY: F("제작방식"),
            LABEL: n.options[f].COD_NME,
            IMG_URL: `${ut}/${s.locale}/item/print_method/${p.COD}/${a.pdtCode}.png`,
            IMG_ALT: p.COD_NME
          })));
        return U(() => u.value, p => {
          const f = n.options.find(v => v.COD == p);
          o("update", f);
        }, {
          immediate: !0
        }), (p, f) => (_(), V(ve, {
          title: "제작방식",
          option: "Method",
          extra: y(i) === "mobile" && d.value ? {
            name: "자세히보기",
            callback: () => {
              y(r).onInformOptionTips && y(r).onInformOptionTips(d.value);
            },
            style: "tip"
          } : null
        }, {
          default: fe(() => [ne(ln, {
            options: l.value,
            default: u.value,
            tips: d.value,
            onSelect: c
          }, null, 8, ["options", "default", "tips"])]),
          _: 1
        }, 8, ["extra"]));
      }
    }),
    Yb = oe({
      __name: "AcrylicPrintData",
      props: {
        options: {},
        default: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = _t(),
          a = Ve(),
          r = Te("productCode", {
            pdtCode: ""
          }),
          i = Te("callbacks", {}),
          l = Te("deviceType", "pc"),
          u = b(() => n.options.map(v => ({
            name: v.COD_NME,
            value: v.COD,
            key: v.COD
          }))),
          c = H(n.default || u.value[0].value),
          d = v => {
            c.value = v;
          },
          p = {
            O: new Set(["ACTHBCO", "ACTHDCO"]),
            X: new Set(["ACTHBCO", "ACTHDCO", "ACTHFCO"])
          },
          f = b(() => n.options.map((v, h) => ({
            IDX: h + 1,
            CATEGORY: F("인쇄데이터"),
            LABEL: n.options[h].COD_NME,
            IMG_URL: p[v.COD].has(r.pdtCode) ? `${ut}/${s.locale}/item/printdata/${v.COD}/${r.pdtCode}.png` : `${ut}/${s.locale}/item/printdata/${v.COD}/default.png`,
            IMG_ALT: v.COD_NME
          })));
        return U(() => c.value, v => {
          a.isAfterEdit() && i?.onReset && i.onReset("printData");
          const h = n.options.find(m => m.COD === v);
          o("update", h);
        }, {
          immediate: !0
        }), (v, h) => (_(), V(ve, {
          title: "인쇄데이터",
          extra: y(l) === "mobile" && f.value ? {
            name: "자세히보기",
            callback: () => {
              y(i).onInformOptionTips && y(i).onInformOptionTips(f.value);
            },
            style: "tip"
          } : null
        }, {
          default: fe(() => [ne(ln, {
            options: u.value,
            default: c.value,
            tips: f.value,
            onSelect: d
          }, null, 8, ["options", "default", "tips"])]),
          _: 1
        }, 8, ["extra"]));
      }
    }),
    Qb = ["value", "disabled"],
    sv = oe({
      __name: "Acrylic",
      props: {
        options: {},
        showExtra: {
          type: Boolean,
          default: !1
        },
        default: {},
        resetAfterEdit: {
          type: Boolean
        },
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = _t(),
          i = b(() => {
            const p = n.options.filter(f => f.GRP_OPTION_CD === n.relatedData?.method);
            return p.length > 0 ? p : n.options;
          }),
          l = b(() => i.value.filter(p => p.HIDE_YN !== "Y")),
          u = H(n.default?.MTRL_CD || l.value.find(p => p.DFT_YN === "Y")?.MTRL_CD || l.value[0]?.MTRL_CD),
          c = async () => {
            const p = await lu({
              pdt_cod: a.pdtCode,
              lang: r.locale
            });
            if (!p) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
            s?.onInformMaterials ? s.onInformMaterials(p) : console.log("[RedWidgetSDK] 자재 정보 >", p);
          },
          d = () => {
            n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
          };
        return U(() => u.value, p => {
          const f = l.value.find(v => v.MTRL_CD === p);
          if (f) {
            const {
              PTT_CD: v,
              PTT_NM: h,
              WGT_CD: m,
              CLR_CD: D,
              MTRL_CD: N,
              MTRL_NM: I,
              MTRL_TYPE: w,
              PRT_HIDE_YN: A
            } = f;
            o("update", {
              PTT_CD: v,
              PTT_NM: h,
              WGT_CD: m,
              CLR_CD: D,
              MTRL_CD: N,
              MTRL_NM: I,
              MTRL_TYPE: w,
              PRT_HIDE_YN: A
            }), v === "OOO" && s?.onSaleOrder && s?.onSaleOrder(), d();
          }
        }, {
          immediate: !0
        }), U(() => n.relatedData?.method, p => {
          p && (u.value = l.value[0]?.MTRL_CD);
        }), (p, f) => (_(), V(ve, {
          title: "자재",
          extra: p.showExtra ? {
            name: "주문가능자재",
            callback: c
          } : null
        }, {
          default: fe(() => [re(P("select", {
            "onUpdate:modelValue": f[0] || (f[0] = v => u.value = v),
            class: "basic-select",
            name: "material",
            onChange: d
          }, [(_(!0), O(q, null, ce(i.value, v => (_(), O("option", {
            key: v.MTRL_CD,
            value: v.MTRL_CD,
            disabled: v.HIDE_YN === "Y"
          }, Y(v.HIDE_YN !== "Y" ? v.MTRL_NM : `[${v.HIDE_RSN || y(F)("주문불가")}] ${v.MTRL_NM}`) + " " + Y(v.BSN_YN === "Y" ? "[영업주문]" : ""), 9, Qb))), 128))], 544), [[Ke, u.value]])]),
          _: 1
        }, 8, ["extra"]));
      }
    }),
    qb = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: sv
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    Xb = {
      class: "qty-group"
    },
    Zb = {
      class: "title"
    },
    Jb = {
      class: "subject"
    },
    eO = {
      class: "subject"
    },
    tO = {
      class: "inputs"
    },
    nO = ["disabled"],
    oO = {
      class: "icon-box"
    },
    sO = ["value"],
    aO = {
      class: "notes"
    },
    iO = {
      class: "note"
    },
    rO = {
      key: 0,
      class: "note"
    },
    lO = {
      key: 1,
      class: "note"
    },
    uO = {
      key: 2,
      class: "note"
    },
    cO = {
      key: 3,
      class: "note"
    },
    dO = {
      key: 4,
      class: "note"
    },
    fO = {
      key: 5,
      class: "note"
    },
    pO = {
      key: 6,
      class: "note"
    },
    _O = {
      key: 7,
      class: "note red"
    },
    av = Ne(oe({
      __name: "DesignQty",
      props: {
        options: {},
        default: {},
        relatedData: {},
        canEditOrdCnt: {},
        expressShipping: {},
        unit: {},
        maxPrnCnt: {},
        extraPrnCntOptions: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("productCode", {
            pdtCode: ""
          }),
          a = Ve(),
          r = ia(),
          i = b(() => {
            const E = vu[s.pdtCode];
            return E ? n.relatedData?.shape ? E[n.relatedData.shape] : void 0 : mu[s.pdtCode];
          }),
          l = b(() => !!vu[s.pdtCode]),
          u = H("select"),
          c = () => {
            u.value = u.value === "input" ? "select" : "input", u.value === "select" && (D.value.find(L => L.PRN_CNT === I.value) || (I.value = p.value));
          },
          d = b(() => n.options.find(E => E.DFT_YN === "Y") || n.options[0]),
          p = b(() => d.value?.DFT_PRN_CNT || 1),
          f = b(() => d.value?.MIN_PRN_CNT || 1),
          v = b(() => d.value?.UNIT_PRN_CNT || 1),
          h = b(() => d.value?.INC_CNT || 1),
          m = b(() => d.value?.INC_STEP || 10),
          D = b(() => {
            const E = n.maxPrnCnt && n.maxPrnCnt > 0 ? n.maxPrnCnt : 1 / 0;
            if (n.extraPrnCntOptions?.length) return n.extraPrnCntOptions.filter(K => K.PRN_CNT <= E);
            if (n.options.length > 1) return n.options.filter(K => K.PRN_CNT <= E);
            const L = [],
              G = d.value?.FIR_CNT;
            G && G <= E && L.push({
              PRN_CNT: G
            });
            const X = G ? h.value : f.value;
            for (let K = X; L.length < m.value && K <= E; K += h.value) K !== G && L.push({
              PRN_CNT: K
            });
            for (const K of [50, 100]) if (K <= E && K >= X && !L.some(de => de.PRN_CNT === K)) {
              const de = L.findIndex(be => be.PRN_CNT > K);
              de === -1 ? L.push({
                PRN_CNT: K
              }) : L.splice(de, 0, {
                PRN_CNT: K
              });
            }
            return L;
          }),
          N = H(n.default?.ordCnt || 1),
          I = H(n.default?.prnCnt || p.value || f.value),
          w = b(() => {
            const E = Gh.has(s.pdtCode) ? 1 : i.value || 1,
              L = la[s.pdtCode];
            return {
              ordCnt: N.value,
              prnCnt: I.value * E,
              ...(L ? {
                innerPrnCnt: L
              } : {})
            };
          }),
          A = b(() => {
            const E = Gh.has(s.pdtCode) ? 1 : i.value || 1;
            return (N.value * I.value * E).toLocaleString();
          }),
          j = b(() => {
            if (!n.expressShipping) return;
            const {
              maxQty: E,
              type: L
            } = n.expressShipping;
            if (!(E === 0 || E >= +A.value)) {
              if (L === "Y") return F("오늘출발-불가능");
              if (L === "T") return F("내일출발-불가능");
            }
          }),
          B = b(() => {
            const L = xh[s.pdtCode]?.[n.relatedData?.mtrlCd || ""] ?? Bh[s.pdtCode] ?? (n.relatedData?.dosu === "SID_D" ? 2 : 1);
            return (N.value * L).toLocaleString();
          }),
          T = b(() => a.uploadType.default === "editor"),
          g = b(() => !I.value),
          C = b(() => !N.value),
          S = () => {
            if (!I.value) return I.value = f.value;
            if (s.pdtCode === "TPLFSET") {
              if (I.value > 200) {
                const E = Math.ceil(I.value / 2e3) * 2e3;
                E !== I.value && (I.value = E, r.show(F("단위수량자동변경안내", {
                  QTY: "2000"
                })));
              }
              n.maxPrnCnt && n.maxPrnCnt > 0 && I.value > n.maxPrnCnt && (I.value = n.maxPrnCnt, r.show(F("최대수량초과안내", {
                MAX_CNT: String(n.maxPrnCnt)
              })));
              return;
            }
            if (!UP.has(s.pdtCode)) {
              const E = f.value,
                L = v.value;
              let G = I.value;
              G < E ? G = E : L > 1 && (G - E) % L !== 0 ? G = E + Math.ceil((G - E) / L) * L : E > 1 && G % E !== 0 && (G = Math.ceil(G / E) * E), G !== I.value && (I.value = G, r.show(F("단위수량자동변경안내", {
                QTY: String(L > 1 ? L : E)
              })));
            }
            n.maxPrnCnt && n.maxPrnCnt > 0 && I.value > n.maxPrnCnt && (I.value = n.maxPrnCnt, r.show(F("최대수량초과안내", {
              MAX_CNT: String(n.maxPrnCnt)
            })));
          },
          R = () => {
            if (!N.value) return N.value = 1;
          };
        return U(() => n.extraPrnCntOptions, E => {
          if (!E?.length) return;
          E.find(G => G.PRN_CNT === I.value) || (I.value = E[0].PRN_CNT);
        }, {
          immediate: !0
        }), U(() => n.options, E => {
          if (!E?.length || !E[0].MIN_PRN_CNT) return;
          E.find(G => G.PRN_CNT === I.value) || (I.value = E[0].PRN_CNT || p.value);
        }, {
          immediate: !0
        }), Vo(() => {
          u.value === "select" && !D.value.find(E => E.PRN_CNT === I.value) && (u.value = "input");
        }), U(() => w.value, an(E => {
          g.value || C.value || o("update", E);
        }, 300), {
          immediate: !0
        }), U(() => a.editorData?.default?.quantityInfo?.ordCnt, (E, L) => {
          if (E) N.value = E;else if (L) return N.value = 1;
        }), U(() => a.uploadType.default, E => {
          E === "editor" && (N.value = 1);
        }), (E, L) => {
          const G = it("dompurify-html");
          return _(), V(ve, null, {
            default: fe(() => [P("div", Xb, [P("div", Zb, [P("h2", Jb, Y(y(F)("디자인수")), 1), P("h2", eO, Y(y(F)("수량")), 1)]), P("div", tO, [re(P("input", {
              "onUpdate:modelValue": L[0] || (L[0] = X => N.value = X),
              type: "number",
              class: "basic-input",
              id: "ORD_CNT",
              min: "1",
              disabled: T.value || !E.canEditOrdCnt.pdf,
              onFocusout: R
            }, null, 40, nO), [[dt, N.value]]), P("div", oO, [ne(ls)]), u.value === "input" ? re((_(), O("input", {
              key: 0,
              "onUpdate:modelValue": L[1] || (L[1] = X => I.value = X),
              type: "number",
              class: "basic-input",
              id: "PRN_CNT",
              min: "1",
              onFocusout: S
            }, null, 544)), [[dt, I.value]]) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": L[2] || (L[2] = X => I.value = X),
              name: "PRN_CNT",
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(D.value, X => (_(), O("option", {
              value: X.PRN_CNT,
              key: X.PRN_CNT
            }, Y(X.PRN_CNT), 9, sO))), 128))], 512)), [[Ke, I.value]]), P("button", {
              type: "button",
              class: "action-btn",
              onClick: c
            }, Y(u.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)])]), P("div", aO, [re(P("p", iO, null, 512), [[G, y(F)("주문수량안내", {
              QTY: A.value + (E.unit ? y(F)(E.unit) : y(F)("개"))
            })]]), i.value && l.value ? re((_(), O("p", rO, null, 512)), [[G, y(F)("폴라팩세트수량안내", {
              SET_CNT: String(i.value),
              PRN_CNT: String(I.value)
            })]]) : i.value ? re((_(), O("p", lO, null, 512)), [[G, y(F)("세트별수량안내", {
              SET_CNT: String(i.value)
            })]]) : J("", !0), v.value > 1 ? re((_(), O("p", uO, null, 512)), [[G, y(F)("단위주문수량안내", {
              QTY: `${v.value}`
            })]]) : J("", !0), ["TPBLMEO", "TPBLPST"].includes(y(s).pdtCode) ? (_(), O("p", cO, "* 최소수량 : " + Y(f.value) + "개 부터 가능합니다.", 1)) : J("", !0), T.value ? J("", !0) : (_(), O("p", dO, "* " + Y(`${y(F)("PDF장수안내", {
              QTY: B.value
            })}`), 1)), E.canEditOrdCnt.pdf && E.canEditOrdCnt.editor ? (_(), O("p", fO, "* " + Y(y(F)("디자인건수가능여부-전체")), 1)) : !E.canEditOrdCnt.pdf && E.canEditOrdCnt.editor ? (_(), O("p", pO, " * " + Y(y(F)("디자인건수가능여부-에디터")), 1)) : J("", !0), j.value ? re((_(), O("p", _O, null, 512)), [[G, j.value]]) : J("", !0)])]),
            _: 1
          });
        };
      }
    }), [["__scopeId", "data-v-135add3a"]]),
    hO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: av
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    vO = {
      class: "basic-radio"
    },
    mO = ["for", "aria-disabled"],
    CO = ["id", "name", "value", "checked", "disabled", "onChange"],
    TO = {
      class: "text"
    },
    Rn = oe({
      __name: "RadioList",
      props: {
        options: {},
        defaultChecked: {}
      },
      emits: ["change"],
      setup(e, {
        emit: t
      }) {
        const n = t,
          o = s => {
            n("change", s);
          };
        return (s, a) => (_(), O("div", vO, [(_(!0), O(q, null, ce(s.options, r => (_(), O("label", {
          key: r.id,
          for: r.id,
          "aria-disabled": r.disabled
        }, [P("input", {
          type: "radio",
          id: r.id,
          name: r.name,
          value: r.value,
          checked: s.defaultChecked === r.value,
          disabled: r.disabled,
          onChange: () => o(r)
        }, null, 40, CO), P("span", TO, Y(y(F)(r.label)), 1)], 8, mO))), 128))]));
      }
    }),
    gO = {
      class: "flex-row"
    },
    yO = oe({
      __name: "Acrylic",
      props: {
        options: {},
        default: {
          default() {
            return {
              assembleYN: {
                SUB_MTR_KR: "Y",
                SUB_MTR_BN: "Y",
                SUB_MTR_CN: "Y",
                SUB_MTR_CR: "Y"
              },
              subMtrlOption: {}
            };
          }
        },
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Xe(new Map()),
          a = b(() => [...s.values()].sort((p, f) => p.order && f.order ? p.order - f.order : 0)),
          r = Xe({
            ...n.default.assembleYN
          }),
          i = Xe({
            ...n.default.subMtrlOption
          }),
          l = H(null);
        function u(p) {
          const f = s.get(p);
          f && (f.value === l.value ? l.value = null : (l.value = f.value, i[l.value] = {
            PCS_DTL_CD: f.options[0].value,
            qty: n.relatedData.orderQty,
            extra: f.options[0].extra
          }));
        }
        function c(p) {
          r[p.name] = p.value;
        }
        const d = p => f => {
          i[p] = f;
        };
        return U(() => n.options.visible, p => {
          p.forEach(f => {
            const v = s.get(f.WEB_PCS_DTL_GRP),
              h = {
                name: f.PCS_DTL_NM,
                value: f.PCS_DTL_CD,
                key: f.PCS_DTL_CD,
                extra: f
              };
            v ? v.options.push(h) : s.set(f.WEB_PCS_DTL_GRP, {
              name: f.WEB_PCS_DTL_GRP_NM || f.PCS_DTL_NM,
              imgPath: f.WEB_PCS_DTL_GRP,
              subImgPath: f.PCS_CD,
              value: f.WEB_PCS_DTL_GRP,
              active: !1,
              options: [h],
              order: Eu[f.WEB_PCS_DTL_GRP]
            });
          });
        }, {
          immediate: !0
        }), U(() => n.relatedData.orderQty, p => {
          for (const f in i) i[f].qty = p;
        }), Yo(() => {
          const p = Object.values(i).map(f => ({
            PCS_CD: f.extra.PCS_CD,
            PCS_GRP_NM: f.extra.WEB_PCS_DTL_GRP_NM,
            VIEW_YN: f.extra.VIEW_YN,
            ESN_YN: f.extra.ESN_YN,
            active: !0,
            selectedOptions: [{
              PCS_CD: f.extra.PCS_CD,
              PCS_DTL_CD: f.PCS_DTL_CD,
              PCS_DTL_NM: f.extra.PCS_DTL_NM,
              ATTB: f.qty,
              ATTB_2: "",
              ATTB_3: r[f.extra.WEB_PCS_DTL_GRP]
            }]
          }));
          o("update", p);
        }), U(() => l.value, (p, f) => {
          f && p !== f && (delete i[f], r[f] = n.default.assembleYN[f]);
        }), (p, f) => (_(), O(q, null, [s.size ? (_(), V(ve, {
          key: 0,
          title: "부자재선택"
        }, {
          default: fe(() => [P("div", gO, [(_(!0), O(q, null, ce(a.value, v => (_(), V(Be, {
            key: v.value,
            active: l.value === v.value,
            data: v,
            onSelect: f[0] || (f[0] = h => u(h.value))
          }, null, 8, ["active", "data"]))), 128))])]),
          _: 1
        })) : J("", !0), l.value ? (_(), V(ve, {
          key: 1
        }, {
          default: fe(() => [(_(!0), O(q, null, ce(a.value, v => (_(), O(q, {
            key: v.value
          }, [l.value === v.value ? (_(), V(bu, {
            key: 0,
            title: v.name,
            options: v.options,
            "default-data": i[v.value],
            "qty-disabled": !0,
            onUpdate: h => d(v.value)(h)
          }, eC({
            _: 2
          }, [y(ob).has(v.value) ? {
            name: "extra",
            fn: fe(() => [ne(Rn, {
              options: [{
                id: `${v.value}/Y`,
                name: v.value,
                label: "조립",
                value: "Y"
              }, {
                id: `${v.value}/N`,
                name: v.value,
                label: "미조립",
                value: "N"
              }],
              "default-checked": r[v.value],
              onChange: c
            }, null, 8, ["options", "default-checked"])]),
            key: "0"
          } : void 0]), 1032, ["title", "options", "default-data", "onUpdate"])) : J("", !0)], 64))), 128))]),
          _: 1
        })) : J("", !0)], 64));
      }
    }),
    DO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "Acrylic",
        props: {
          type: {
            default: "new"
          },
          data: {},
          widgetAttr: {},
          defaultData: {},
          senecaInfo: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.widgetAttr.skinInfo),
            a = Te("member"),
            r = Ve(),
            i = b(() => {
              if (!n.data.option_info) return !1;
              const {
                shape_info: w
              } = n.data.option_info;
              return !rn(w) && !!w[0].COD;
            }),
            l = b(() => {
              if (!n.data.option_info) return !1;
              const {
                print_data: w
              } = n.data.option_info;
              return !rn(w) && !!w[0].COD && m.value.meterialInfo?.PRT_HIDE_YN === "N";
            }),
            u = b(() => {
              if (!n.data.option_info) return !1;
              const {
                production_method: w
              } = n.data.option_info;
              return !rn(w) && !!w[0].COD;
            }),
            c = b(() => a?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(w => w.BSN_YN !== "Y")),
            d = b(() => {
              const w = [...n.data.pdt_size_info];
              return !i.value || !m.value.acrylicSelectData?.shapeInfo || w.length === 1 ? w : w.filter(A => A.STICKER_TYPE === m.value.acrylicSelectData?.shapeInfo.COD);
            }),
            p = b(() => Pi(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            {
              uploadConfig: f,
              canEditOrdCnt: v
            } = da(n.widgetAttr),
            {
              defaultOrderData: h,
              orderInfo: m,
              updateOption: D,
              updatePcsOption: N,
              updatePostPcs: I
            } = fa(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: w => o("update", w)
              }
            });
          return (w, A) => (_(), O(q, null, [re(ne(Du, {
            options: w.data.pdt_dosu_info,
            default: y(h)?.dosuInfo,
            onUpdate: A[0] || (A[0] = j => y(D)("dosuInfo")(j))
          }, null, 8, ["options", "default"]), [[Lt, s.value.dosuSelect.view_yn === "Y" && w.data.pdt_dosu_info]]), u.value ? (_(), V(Kb, {
            key: 0,
            options: w.data.option_info?.production_method || [],
            default: y(h)?.productionMethod,
            onUpdate: A[1] || (A[1] = j => y(D)("productionMethod", !0)(j))
          }, null, 8, ["options", "default"])) : J("", !0), i.value ? (_(), V(qh, {
            key: 1,
            options: w.data.option_info?.shape_info || [],
            default: y(h)?.shapeInfo,
            onUpdate: A[2] || (A[2] = j => y(D)("shapeInfo", !0)(j))
          }, null, 8, ["options", "default"])) : J("", !0), l.value ? (_(), V(Yb, {
            key: 2,
            options: w.data.option_info?.print_data || [],
            default: y(h)?.printData,
            onUpdate: A[3] || (A[3] = j => y(D)("printData", !0)(j))
          }, null, 8, ["options", "default"])) : J("", !0), re(ne(sv, {
            options: c.value,
            default: y(h)?.meterialInfo,
            "reset-after-edit": y(sb).has(w.data.pdt_base_info[0].PDT_CD) && y(r).isAfterEdit(),
            "show-extra": w.widgetAttr.able_paper_yn === "Y",
            "related-data": {
              method: y(m).acrylicSelectData?.productionMethod?.COD
            },
            onUpdate: A[4] || (A[4] = j => y(D)("meterialInfo")(j))
          }, null, 8, ["options", "default", "reset-after-edit", "show-extra", "related-data"]), [[Lt, s.value.paperSelect.view_yn === "Y"]]), re(ne(yi, {
            options: d.value,
            "base-info": w.data.pdt_base_info[0],
            default: y(h)?.size,
            "related-data": {
              shape: y(m).acrylicSelectData?.shapeInfo?.COD
            },
            onUpdate: A[5] || (A[5] = j => y(D)("sizeInfo")(j)),
            onValidate: A[6] || (A[6] = j => y(D)("validation")(j))
          }, null, 8, ["options", "base-info", "default", "related-data"]), [[Lt, (!i.value || i.value && y(m).acrylicSelectData?.shapeInfo) && s.value.sizeSelect.view_yn === "Y"]]), s.value.quantityGroup.view_yn === "Y" ? (_(), V(av, {
            key: 3,
            "can-edit-ord-cnt": y(v),
            options: w.data.pdt_prn_cnt_info,
            default: y(h)?.quantityInfo,
            "related-data": {
              dosu: y(m).dosuInfo?.COD
            },
            onUpdate: A[7] || (A[7] = j => y(D)("quantityInfo")(j))
          }, null, 8, ["can-edit-ord-cnt", "options", "default", "related-data"])) : J("", !0), ne(Di, {
            options: p.value.postPcs.hidden,
            "related-data": {
              shape: y(m).acrylicSelectData?.shapeInfo?.COD,
              sizeInfo: y(m).sizeInfo
            },
            "disabled-opts": p.value.disabled,
            onUpdate: A[8] || (A[8] = j => y(I)("hidden")(j))
          }, null, 8, ["options", "related-data", "disabled-opts"]), ne(Si, {
            options: p.value.postPcs.visible,
            "related-data": {
              sizeInfo: y(m).sizeInfo
            },
            "attb-opts": w.data.pdt_add_info[1],
            "disabled-opts": p.value.disabled,
            onUpdate: A[9] || (A[9] = j => y(I)("visible")(j))
          }, null, 8, ["options", "related-data", "attb-opts", "disabled-opts"]), ne(yO, {
            options: p.value.sub,
            "related-data": {
              orderQty: (y(m).quantityInfo?.ordCnt || 1) * (y(m).quantityInfo?.prnCnt || 1)
            },
            onUpdate: A[10] || (A[10] = j => y(N)("SUB_MTR")(j))
          }, null, 8, ["options", "related-data"]), w.widgetAttr.order_yn !== "N" ? (_(), V(us, {
            key: 4,
            "upload-config": y(f),
            "show-extra": w.widgetAttr.useTemplateDownload === "Y" && w.widgetAttr.usePDF === "Y",
            "related-data": {
              print: y(m).acrylicSelectData?.printData
            },
            onUpload: A[11] || (A[11] = j => y(D)("fileUploadInfo")(j))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : J("", !0), ne(ca, {
            "upload-config": y(f)
          }, null, 8, ["upload-config"])], 64));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    SO = {
      class: "grid-group"
    },
    PO = oe({
      __name: "ApparelPrintType",
      props: {
        options: {},
        dosuOptions: {},
        relatedData: {}
      },
      emits: ["update:type", "update:dosu"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = _t(),
          a = Ve(),
          r = Te("productCode", {
            pdtCode: ""
          }),
          i = Te("callbacks", {}),
          l = Te("deviceType", "pc"),
          u = {
            PTP_DTF: {
              src: `${ut}/{lang}/item/clothes-color-film-img.png`,
              alt: "DTF 열전사 설명 사진"
            },
            PTP_DIR: {
              src: `${ut}/{lang}/item/clothes-color-direct-img.png`,
              alt: "직접인쇄 설명 사진"
            },
            PTP_SLK: {
              src: `${ut}/{lang}/item/clothes-color-printing-img.png`,
              alt: "날염(실크인쇄) 설명 사진"
            }
          },
          c = b(() => n.options.map((w, A) => {
            const j = u[w.COD];
            return j ? {
              IDX: A + 1,
              CATEGORY: F("인쇄"),
              LABEL: n.options[A].COD_NME,
              IMG_URL: j.src.replace("{lang}", s.locale),
              IMG_ALT: j.alt
            } : null;
          })),
          d = b(() => n.dosuOptions.map(w => ({
            id: w.COD,
            name: "apparel-print-side",
            value: w.COD,
            label: `의류.${w.COD_NME}`,
            disabled: I.value
          }))),
          p = H(n.dosuOptions[0].COD),
          f = b(() => n.dosuOptions.find(w => w.COD === p.value)),
          v = H(n.options[0].COD),
          h = b(() => n.options.map(w => ({
            name: w.COD_NME,
            value: w.COD,
            key: w.COD,
            disabled: w.USE_YN !== "Y" || p.value === "SID_X"
          }))),
          m = () => {
            i?.onReset && i.onReset("fileUpload");
          },
          D = w => {
            a.isAfterEdit() && m(), v.value = w;
          };
        U(() => p.value, w => {
          o("update:type", {
            COD: w === "SID_S" ? v.value : "",
            PRINT_GBN: w === "SID_S" ? "Y" : "N"
          }), o("update:dosu", {
            ...f.value,
            COD_NME: F(`의류.${f.value.COD_NME}`)
          });
        }, {
          immediate: !0
        }), U(() => v.value, w => {
          o("update:type", {
            COD: w,
            PRINT_GBN: p.value === "SID_S" ? "Y" : "N"
          });
        }, {
          immediate: !0
        });
        const N = b(() => n.relatedData.color),
          I = b(() => !N.value || r.pdtCode !== "CLSTBSA" ? !1 : N.value === "DD" || N.value === "DG");
        return U(() => I.value, w => {
          w && (p.value = "SID_X", alert("[인쇄없음]으로만 주문 가능합니다."));
        }), (w, A) => (_(), V(ve, {
          title: "인쇄",
          extra: y(l) === "mobile" ? {
            name: "자세히보기",
            callback: () => {
              y(i).onInformOptionTips && y(i).onInformOptionTips(c.value);
            },
            style: "tip"
          } : {
            name: "가이드보기",
            callback: () => {
              y(i)?.onInformGuide && y(i).onInformGuide("print");
            }
          }
        }, {
          default: fe(() => [P("div", SO, [ne(Rn, {
            options: d.value,
            "default-checked": p.value,
            onChange: A[0] || (A[0] = j => p.value = j.value)
          }, null, 8, ["options", "default-checked"]), ne(ln, {
            options: h.value,
            default: v.value,
            tips: c.value,
            onSelect: D
          }, null, 8, ["options", "default", "tips"])])]),
          _: 1
        }, 8, ["extra"]));
      }
    }),
    bO = {
      key: 0,
      class: "arrow-up",
      xmlns: "http://www.w3.org/2000/svg",
      width: "22",
      height: "22",
      viewBox: "0 0 22 22",
      fill: "none"
    },
    OO = {
      key: 1,
      class: "arrow-down",
      xmlns: "http://www.w3.org/2000/svg",
      width: "22",
      height: "22",
      viewBox: "0 0 22 22",
      fill: "none"
    },
    EO = oe({
      __name: "Chevron",
      props: {
        direction: {}
      },
      setup(e) {
        return (t, n) => (_(), O(q, null, [t.direction === "up" ? (_(), O("svg", bO, [...(n[0] || (n[0] = [P("path", {
          d: "M4.39961 7.70042L10.9855 14.3002L17.5996 7.70042",
          stroke: "#777777",
          "stroke-width": "1.5",
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        }, null, -1)]))])) : J("", !0), t.direction === "down" ? (_(), O("svg", OO, [...(n[1] || (n[1] = [P("path", {
          d: "M4.39961 14.2996L10.9855 7.69981L17.5996 14.2996",
          stroke: "#777777",
          "stroke-width": "1.5",
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        }, null, -1)]))])) : J("", !0)], 64));
      }
    }),
    IO = {
      class: "color-picker"
    },
    RO = {
      key: 0,
      class: "desc"
    },
    NO = {
      class: "text"
    },
    AO = {
      class: "text"
    },
    MO = ["aria-expanded"],
    wO = ["title", "onClick"],
    LO = {
      class: "tooltip"
    },
    iv = Ne(oe({
      __name: "ColorPicker",
      props: {
        options: {},
        canToggle: {
          type: Boolean
        },
        defaultValue: {}
      },
      emits: ["select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(n.defaultValue || n.options[0]),
          a = H(!0);
        function r(l) {
          s.value = l, o("select", l);
        }
        const i = l => {
          const u = l.split(",").map(f => f.replace("#", "")),
            [c, d, p] = u;
          if (u.length === 2) return `linear-gradient(to right, #${c} 50%, #${d} 50%)`;
          if (u.length === 3) return `linear-gradient(to right, #${c} 34%, #${d} 34% 67%, #${p} 33%)`;
        };
        return U(() => n.defaultValue, l => {
          l && (s.value = l);
        }), (l, u) => (_(), O("div", IO, [l.canToggle ? (_(), O("div", RO, [P("span", NO, Y(y(F)("선택")) + " : " + Y(s.value?.COD_NME), 1), P("button", {
          type: "button",
          class: "toggle-btn",
          onClick: u[0] || (u[0] = c => a.value = !a.value)
        }, [P("span", AO, Y(a.value ? y(F)("접기") : y(F)("보기")), 1), ne(EO, {
          direction: a.value ? "down" : "up"
        }, null, 8, ["direction"])])])) : J("", !0), P("ul", {
          class: "color-chip",
          "aria-expanded": l.canToggle ? a.value : !0
        }, [(_(!0), O(q, null, ce(l.options, c => (_(), O("li", {
          key: c.COD,
          class: $e(["color", {
            active: c.COD === s.value?.COD
          }]),
          title: `hex: ${c.HEX}`,
          style: mt([{
            background: c.HEX.includes(",") ? i(c.HEX) : c.HEX
          }, {
            border: c.HEX.toLocaleLowerCase().includes("ffff") ? "1px solid #ddd" : ""
          }]),
          onClick: d => r(c)
        }, [P("div", LO, Y(c.COD_NME), 1)], 14, wO))), 128))], 8, MO)]));
      }
    }), [["__scopeId", "data-v-5c81ab0e"]]),
    kO = oe({
      __name: "ApparelColor",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("callbacks", {}),
          r = H(n.options.find(c => c.DEFAULT === "Y") || n.options[0]),
          i = b(() => n.options.find(c => c.COD === r.value.COD)),
          l = () => {
            a?.onReset && a.onReset("color");
          },
          u = c => {
            s.isAfterEdit() && l(), r.value = c;
          };
        return U(() => i.value, c => {
          c && o("update", c);
        }, {
          immediate: !0
        }), U(() => s.editorData.default, c => {
          const d = c?.editorClothesInfo?.COLOR;
          if (!d || r.value.COD === d) return;
          const p = n.options.find(f => f.COD === d);
          p && (r.value = p);
        }), (c, d) => (_(), V(ve, {
          title: "의류 컬러"
        }, {
          default: fe(() => [ne(iv, {
            options: c.options,
            "can-toggle": !0,
            "default-value": r.value,
            onSelect: u
          }, null, 8, ["options", "default-value"])]),
          _: 1
        }));
      }
    }),
    $O = {
      class: "flex-row -flow"
    },
    FO = {
      class: "notes"
    },
    UO = ["innerHTML"],
    BO = ["innerHTML"],
    xO = ["innerHTML"],
    HO = oe({
      __name: "ApparelPrintArea",
      props: {
        options: {},
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = Te("callbacks", {}),
          i = {
            CLSTLUB: {
              CL001: "CLSTLUB_CL001"
            },
            CLSTTOB: {
              CL001: "CLSTTOB_CL001"
            },
            CLDFNCP: {
              CL001: "CLDFNCP_CL001"
            },
            CLSTSAP: {
              CL005: "CLSTSAP_CL005"
            },
            CLSTCAP: {
              CL001: "CLSTCAP_CL001"
            }
          },
          l = b(() => {
            let h = 0;
            for (const m of n.options) if ((m.COD === "CL011" || m.COD === "CL001") && h++, h === 2) break;
            return h === 2;
          }),
          u = b(() => {
            const h = [];
            for (const m of n.options) (m.COD === "CL011" || m.COD === "CL009" || m.COD === "CL010" || m.COD === "CL004") && h.push(m.COD_NME);
            return h.length === 0 ? null : h.join(", ");
          }),
          c = b(() => n.options.map(h => ({
            name: h.COD_NME,
            value: h.KOI_NME,
            imgPath: `${ut}/ko/item/printarea_${i[a.pdtCode] ? i[a.pdtCode][h.COD] : h.COD}.svg`,
            forcedImg: !0
          }))),
          d = Xe(n.options.reduce((h, m, D) => (h[m.KOI_NME] = {
            active: D === 0,
            COD: m.COD,
            COD_NME: m.COD_NME,
            KOI_NME: m.KOI_NME
          }, h), {})),
          p = b(() => Object.entries(d).reduce((h, m) => {
            const [D, N] = m;
            return N.active && h.push({
              COD: N.COD,
              COD_NME: N.COD_NME,
              KOI_NME: D
            }), h;
          }, [])),
          f = () => {
            r?.onReset && r.onReset("printArea");
          },
          v = h => {
            p.value.length === 1 && d[h]?.active || (s.isAfterEdit() && f(), h === "front" && d.leftchest && (d.leftchest.active = !1), h === "leftchest" && d.front && (d.front.active = !1), d[h].active = !d[h].active);
          };
        return U(() => p.value, h => {
          o("update", h);
        }, {
          immediate: !0
        }), U(() => n.relatedData.printType?.PRINT_GBN, h => {
          h === "N" ? o("update", null) : o("update", p.value);
        }), U(() => s.editorData.default, h => {
          const m = h?.editorClothesInfo?.PAGES;
          if (m) for (const D in d) d[D].active = m.includes(D);
        }), (h, m) => h.relatedData.printType?.PRINT_GBN === "Y" ? (_(), V(ve, {
          key: 0,
          title: "인쇄 영역"
        }, {
          default: fe(() => [P("div", $O, [(_(!0), O(q, null, ce(c.value, D => (_(), V(Be, {
            key: D.value,
            data: D,
            active: d[D.value].active,
            onSelect: m[0] || (m[0] = N => v(N.value))
          }, null, 8, ["data", "active"]))), 128))]), P("div", FO, [h.relatedData.printType.COD === "PTP_DTF" && l.value ? (_(), O("p", {
            key: 0,
            class: "note",
            innerHTML: y(F)("의류인쇄영역가이드")
          }, null, 8, UO)) : J("", !0), h.relatedData.printType.COD === "PTP_DIR" && u.value ? (_(), O("p", {
            key: 1,
            class: "note red",
            innerHTML: y(F)("의류인쇄영역가이드-직접인쇄", {
              areas: u.value
            })
          }, null, 8, BO)) : J("", !0), h.relatedData.printType.COD === "PTP_SLK" ? (_(), O("p", {
            key: 2,
            class: "note",
            innerHTML: y(F)("의류인쇄영역가이드-실크인쇄")
          }, null, 8, xO)) : J("", !0)])]),
          _: 1
        })) : J("", !0);
      }
    }),
    rv = oe({
      __name: "ApparelSizeGbn",
      props: {
        options: {},
        default: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = [{
            id: "adult",
            name: "size-option",
            label: F("adult"),
            value: "adult"
          }, {
            id: "child",
            name: "size-option",
            label: F("child"),
            value: "child"
          }],
          a = H(n.default);
        return U(() => a.value, r => {
          o("update", r);
        }), (r, i) => (_(), V(Rn, {
          options: s,
          "default-checked": s[0].value,
          onChange: i[0] || (i[0] = l => a.value = l.value)
        }, null, 8, ["default-checked"]));
      }
    }),
    GO = {
      class: "grid-group"
    },
    WO = {
      key: 1,
      class: "note red"
    },
    VO = {
      class: "inputs"
    },
    jO = ["value"],
    zO = {
      class: "notes"
    },
    KO = {
      class: "note"
    },
    YO = Ne(oe({
      __name: "ApparelSingleSizeQty",
      props: {
        options: {},
        sizeInfo: {}
      },
      emits: ["update:qty", "update:combinations"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("callbacks", {}),
          r = b(() => {
            const w = {};
            return n.options.forEach(A => {
              const j = w[A.GBN];
              j ? j.push(A) : w[A.GBN] = [A];
            }), w;
          }),
          i = b(() => Object.keys(r.value)),
          l = H(i.value.length === 1 ? i.value[0] : "adult"),
          u = b(() => [...r.value[l.value]].sort((A, j) => n.sizeInfo[A.COD].ORD - n.sizeInfo[j.COD].ORD).map(A => ({
            name: n.sizeInfo[A.COD].COD_NME || A.COD_NME,
            value: A.COD,
            key: A.COD,
            disabled: A.HIDE_YN === "Y"
          }))),
          c = H("select"),
          d = () => {
            c.value = c.value === "input" ? "select" : "input";
          },
          p = b(() => {
            const w = u.value.filter(j => !j.disabled);
            if (w.length === 1) return w[0].value;
            const A = l.value === "adult" ? Math.trunc(w.length / 2) : 0;
            return w[A].value;
          }),
          f = H(p.value);
        function v(w) {
          s.isAfterEdit() && a?.onReset && a.onReset("size"), f.value = w;
        }
        const h = b(() => {
            const A = [];
            for (let j = 1; j <= 10; j++) A.push(j);
            return A;
          }),
          m = H(1);
        U(() => m.value, w => {
          w || (m.value = 1), o("update:qty", {
            ordCnt: 1,
            prnCnt: w
          });
        }, {
          immediate: !0
        }), Yo(() => {
          f.value = p.value;
        });
        const D = b(() => n.options.filter(w => w.COD === f.value).map(w => ({
            size: w,
            quantity: m.value
          }))),
          N = b(() => D.value[0]?.size?.QUICK_ORD_YN === "N"),
          I = b(() => n.options.filter(w => w.QUICK_ORD_YN === "N").map(w => n.sizeInfo[w.COD].COD_NME || w.COD_NME).join(", "));
        return U(() => D.value, w => {
          w && o("update:combinations", w);
        }, {
          immediate: !0
        }), U(() => s.editorData.default, w => {
          const A = w?.editorClothesInfo?.SIZE;
          A && (f.value = A);
        }), (w, A) => {
          const j = it("dompurify-html");
          return _(), O(q, null, [ne(ve, {
            title: "사이즈"
          }, {
            default: fe(() => [P("div", GO, [i.value.length > 1 ? (_(), V(rv, {
              key: 0,
              options: i.value,
              default: l.value,
              onUpdate: A[0] || (A[0] = B => l.value = B)
            }, null, 8, ["options", "default"])) : J("", !0), ne(ln, {
              type: "sm",
              options: u.value,
              default: f.value,
              onSelect: v
            }, null, 8, ["options", "default"]), N.value ? (_(), O("p", WO, Y(y(F)("퀵오더불가")) + " - " + Y(I.value), 1)) : J("", !0)])]),
            _: 1
          }), ne(ve, {
            title: "수량"
          }, {
            default: fe(() => [P("div", VO, [c.value === "input" ? re((_(), O("input", {
              key: 0,
              "onUpdate:modelValue": A[1] || (A[1] = B => m.value = B),
              type: "number",
              class: $e(["basic-input", "-fixed-w"]),
              id: "PRN_CNT",
              min: "1"
            }, null, 512)), [[dt, m.value]]) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": A[2] || (A[2] = B => m.value = B),
              name: "PRN_CNT",
              class: $e(["basic-select", "-fixed-w"])
            }, [(_(!0), O(q, null, ce(h.value, B => (_(), O("option", {
              value: B,
              key: `${B}`
            }, Y(B), 9, jO))), 128))], 512)), [[Ke, m.value]]), P("button", {
              type: "button",
              class: "action-btn",
              onClick: d
            }, Y(c.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)]), P("div", zO, [re(P("p", KO, null, 512), [[j, y(F)("의류주문가능수량", {
              QTY: "1"
            })]])])]),
            _: 1
          })], 64);
        };
      }
    }), [["__scopeId", "data-v-3fed104a"]]),
    QO = {
      class: "grid-group"
    },
    qO = {
      class: "multi-size"
    },
    XO = {
      class: "label"
    },
    ZO = {
      class: "input-box"
    },
    JO = ["disabled", "onClick"],
    eE = ["onUpdate:modelValue", "disabled"],
    tE = ["disabled", "onClick"],
    nE = {
      key: 1,
      class: "note red"
    },
    oE = Ne(oe({
      __name: "ApparelMultiSizeQty",
      props: {
        options: {},
        sizeInfo: {}
      },
      emits: ["update:qty", "update:combinations"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = b(() => {
            const v = [...n.options].sort((m, D) => n.sizeInfo[m.COD].ORD - n.sizeInfo[D.COD].ORD),
              h = {};
            return v.forEach(m => {
              const D = h[m.GBN];
              D ? D.push(m) : h[m.GBN] = [m];
            }), h;
          }),
          a = b(() => Object.keys(s.value)),
          r = H(a.value.length === 1 ? a.value[0] : "adult"),
          i = Xe(n.options.reduce((v, h) => (v[h.COD] = 0, v), {})),
          l = b(() => Object.values(i).reduce((v, h) => v + h, 0)),
          u = v => {
            i[v] = i[v] + 1;
          },
          c = v => {
            i[v] < 1 || (i[v] = i[v] - 1);
          },
          d = b(() => n.options.filter(v => i[v.COD] > 0).map(v => ({
            size: v,
            quantity: i[v.COD]
          }))),
          p = b(() => d.value.some(v => i[v.size.COD] > 0 && v.size.QUICK_ORD_YN === "N")),
          f = b(() => n.options.filter(v => v.QUICK_ORD_YN === "N").map(v => n.sizeInfo[v.COD].COD_NME || v.COD_NME).join(", "));
        return U(() => d.value, v => {
          o("update:qty", {
            ordCnt: 1,
            prnCnt: l.value
          }), o("update:combinations", v);
        }), (v, h) => (_(), V(ve, {
          title: "사이즈별수량"
        }, {
          default: fe(() => [P("div", QO, [a.value.length > 1 ? (_(), V(rv, {
            key: 0,
            options: a.value,
            default: r.value,
            onUpdate: h[0] || (h[0] = m => r.value = m)
          }, null, 8, ["options", "default"])) : J("", !0), P("div", qO, [(_(!0), O(q, null, ce(s.value[r.value], m => (_(), O("div", {
            key: m.COD,
            class: $e(["size", "size-s", {
              soldout: m.HIDE_YN === "Y"
            }])
          }, [P("span", XO, Y(v.sizeInfo[m.COD].COD_NME || m.COD_NME), 1), P("div", ZO, [P("button", {
            type: "button",
            class: "control-btn",
            disabled: m.HIDE_YN === "Y",
            onClick: () => c(m.COD)
          }, [...(h[1] || (h[1] = [P("span", {
            class: "icon minus"
          }, null, -1)]))], 8, JO), re(P("input", {
            "onUpdate:modelValue": D => i[m.COD] = D,
            type: "number",
            name: "size-qty",
            disabled: m.HIDE_YN === "Y"
          }, null, 8, eE), [[dt, i[m.COD]]]), P("button", {
            type: "button",
            class: "control-btn",
            disabled: m.HIDE_YN === "Y",
            onClick: () => u(m.COD)
          }, [...(h[2] || (h[2] = [P("span", {
            class: "icon plus"
          }, null, -1)]))], 8, tE)])], 2))), 128))]), p.value ? (_(), O("p", nE, Y(y(F)("퀵오더불가")) + " - " + Y(f.value), 1)) : J("", !0)])]),
          _: 1
        }));
      }
    }), [["__scopeId", "data-v-949c188e"]]),
    sE = {},
    aE = {
      xmlns: "http://www.w3.org/2000/svg",
      width: "14",
      height: "10",
      viewBox: "0 0 14 10",
      fill: "none"
    };
  function iE(e, t) {
    return _(), O("svg", aE, [...(t[0] || (t[0] = [P("path", {
      d: "M1.29102 4.1319L6.21182 8.44571L12.4021 1.375",
      stroke: "white",
      "stroke-width": "2.18182",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    }, null, -1)]))]);
  }
  const rE = Ne(sE, [["render", iE]]),
    lE = {
      class: "pantone-layer"
    },
    uE = {
      class: "pantone-modal"
    },
    cE = {
      class: "modal-header"
    },
    dE = {
      class: "modal-body"
    },
    fE = {
      class: "color-palette"
    },
    pE = ["data-rgb", "data-checked", "onClick"],
    _E = {
      class: "pantone-number"
    },
    hE = {
      key: 1,
      class: "selected"
    },
    vE = {
      class: "preview"
    },
    mE = {
      class: "color-preview"
    },
    CE = {
      key: 1,
      class: "selected-color"
    },
    TE = {
      class: "not-found"
    },
    gE = ["src"],
    yE = {
      class: "pantone-mark"
    },
    DE = {
      class: "logo"
    },
    SE = {
      class: "icon-padding tip"
    },
    PE = {
      class: "tooltip"
    },
    bE = {
      class: "tip-text"
    },
    OE = {
      class: "selected-color-text"
    },
    EE = {
      class: "color-search"
    },
    IE = ["placeholder"],
    RE = {
      class: "notice-txt"
    },
    NE = ["disabled"],
    AE = Ne(oe({
      __name: "PantoneChipModal",
      props: {
        options: {},
        selected: {}
      },
      emits: ["close", "select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(null),
          a = b(() => s.value ? s.value : n.selected),
          r = () => {
            a.value && o("select", a.value);
          },
          i = H(""),
          l = H(!1),
          u = () => {
            const c = i.value.toLowerCase().replace(/\s/g, ""),
              d = n.options.find(p => p.pantone_name.replace(/\s/g, "").toLowerCase().includes(c));
            d ? (s.value = d, l.value = !1) : (s.value = null, l.value = !0);
          };
        return (c, d) => {
          const p = it("dompurify-html");
          return _(), O("div", lE, [P("div", uE, [P("div", cE, [P("h2", null, Y(y(F)("팬톤 컬러 선택")), 1), P("button", {
            type: "button",
            class: "close-btn",
            onClick: d[0] || (d[0] = f => o("close"))
          }, [ne(ls)])]), P("div", dE, [P("div", fE, [(_(!0), O(q, null, ce(c.options, f => (_(), O("span", {
            key: f.hex_cod,
            class: "color-chip",
            "data-rgb": f.hex_cod,
            "data-checked": a.value?.hex_cod === f.hex_cod,
            style: mt({
              backgroundColor: `rgb(${f.rgb_R}, ${f.rgb_G} ,${f.rgb_B})`
            }),
            onClick: v => s.value = f
          }, [P("p", _E, Y(f.pantone_name.replace("PANTONE", "")), 1), a.value?.hex_cod === f.hex_cod ? (_(), V(rE, {
            key: 0
          })) : J("", !0), a.value?.hex_cod === f.hex_cod ? (_(), O("span", hE)) : J("", !0)], 12, pE))), 128))]), P("div", vE, [P("div", mE, [a.value ? (_(), O("div", {
            key: 0,
            class: "selected-color",
            style: mt({
              backgroundColor: `rgb(${a.value.rgb_R}, ${a.value.rgb_G} ,${a.value.rgb_B})`
            })
          }, null, 4)) : l.value ? (_(), O("div", CE, [re(P("p", TE, null, 512), [[p, y(F)("팬톤검색실패문구")]])])) : (_(), O("img", {
            key: 2,
            src: `${y(ut)}/ko/item/page-order-clothes-pantone-modal.png`,
            width: 240,
            height: 150,
            alt: "팬톤 선택 전 이미지"
          }, null, 8, gE)), P("div", yE, [P("div", DE, [d[3] || (d[3] = zC('<div class="icon-padding" data-v-d02e5e9c><svg xmlns="http://www.w3.org/2000/svg" width="114" height="18" viewBox="0 0 114 18" fill="none" data-v-d02e5e9c><path d="M5.2351 3.46373H7.80534C8.7552 3.46373 9.92857 3.46373 10.5991 4.35773C10.8226 4.6371 10.9902 5.02822 11.0461 5.81047C11.0461 7.20734 10.4873 8.04546 9.09045 8.26896C8.69933 8.32483 8.41996 8.32483 7.69359 8.32483H5.2351V3.46373ZM1.15625 0.4465V16.6502H5.2351V11.3421H7.97296C10.3197 11.2862 12.6106 11.1744 14.1192 8.99533C15.0132 7.71021 15.069 6.31334 15.069 5.75459C15.069 4.13423 14.5103 2.96086 14.175 2.45799C13.8957 2.06687 13.6163 1.78749 13.4487 1.67574C12.2194 0.614124 10.7667 0.4465 9.2022 0.390625L1.15625 0.4465Z" fill="black" data-v-d02e5e9c></path><path d="M19.4282 11.1762C19.8194 9.83519 20.2664 8.49419 20.6575 7.1532C20.9368 6.20333 21.1603 5.25346 21.4397 4.30359L23.563 11.1762H19.4282ZM23.6188 0.448242H19.3724L13.3379 16.6519H17.6402L18.4225 14.0817H24.5128L25.2951 16.6519H29.5974L23.6188 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M34.9015 0.448242L38.4216 6.42683C39.2597 7.87957 40.0978 9.38819 40.88 10.8409L40.7124 0.448242H44.6237V16.6519H40.6565L37.6393 11.5114C37.1364 10.7292 36.6336 9.89106 36.1866 9.05294C35.6837 8.21482 35.2926 7.32083 34.7897 6.48271L34.9015 16.7078H30.9902V0.504117L34.9015 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M58.5433 0.448242V3.6331H54.3527V16.6519H50.2738V3.6331H46.0273V0.448242H58.5433Z" fill="black" data-v-d02e5e9c></path><path d="M70.7756 8.93897C70.7197 10.2241 70.3845 11.5092 69.4905 12.5149C68.4848 13.5766 67.1996 13.7442 66.6968 13.7442C65.6351 13.7442 64.6853 13.3531 63.9589 12.5708C63.2884 11.8445 62.6179 10.6711 62.6179 8.4361C62.6179 6.70398 63.1767 4.6925 64.797 3.7985C65.0764 3.63088 65.691 3.3515 66.585 3.3515C66.8644 3.3515 67.479 3.3515 68.1495 3.63088C69.0435 4.022 69.4905 4.58075 69.714 4.86012C70.2169 5.53061 70.8315 6.92748 70.7756 8.93897ZM71.7814 15.4763C73.7928 13.8559 74.8545 11.174 74.8545 8.71547C74.8545 6.48048 73.9605 3.85438 72.396 2.23401C71.5579 1.34002 69.6581 -0.000976562 66.585 -0.000976562C62.8414 -0.000976562 60.9417 2.06639 60.1036 3.29563C58.7067 5.36299 58.5391 7.70973 58.5391 8.54785C58.5391 9.49772 58.6508 12.5708 60.8858 14.9176C62.9532 17.0967 65.6351 17.2643 66.6409 17.2643C69.3229 17.1525 70.8874 16.2027 71.7814 15.4763Z" fill="black" data-v-d02e5e9c></path><path d="M80.7804 0.448242L84.3005 6.42683C85.1386 7.87957 85.9767 9.38819 86.759 10.8409L86.5913 0.448242H90.5026V16.6519H86.5355L83.5182 11.5114C83.0154 10.7292 82.5125 9.89106 82.0655 9.05294C81.5626 8.21482 81.1715 7.32083 80.6686 6.48271L80.7804 16.7078H76.8691V0.504117L80.7804 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M105.136 0.448242V3.57722H97.2019V6.53858H104.633V9.61169H97.2019V13.467H105.862V16.6519H93.123V0.448242H105.136Z" fill="black" data-v-d02e5e9c></path><path d="M109.269 2.90366V1.95379H109.884C110.108 1.95379 110.387 1.95379 110.499 2.17729C110.555 2.23317 110.555 2.34492 110.555 2.40079C110.555 2.45667 110.555 2.56841 110.499 2.62429C110.387 2.84779 110.219 2.84779 109.772 2.84779H109.269V2.90366ZM111.449 5.2504C111.281 4.91515 111.169 4.46815 111.169 4.3564C111.113 4.07703 111.113 3.68591 110.89 3.46241C110.834 3.40653 110.778 3.35066 110.61 3.29479C110.778 3.23891 110.778 3.23891 110.89 3.18304C111.002 3.12716 111.057 3.07129 111.113 2.95954C111.225 2.84779 111.337 2.68016 111.337 2.34492C111.337 2.23317 111.337 1.95379 111.113 1.67442C110.778 1.2833 110.219 1.2833 109.772 1.2833H108.431V5.19452H109.269V3.51828H109.493C109.772 3.51828 109.884 3.51828 109.996 3.63003C110.163 3.74178 110.219 3.85353 110.275 4.24465C110.331 4.52403 110.331 4.85928 110.443 5.13865C110.443 5.19452 110.499 5.19452 110.499 5.2504H111.449ZM112.901 3.29479C112.901 2.62429 112.734 1.95379 112.287 1.45092C111.672 0.668677 110.778 0.22168 109.828 0.22168C108.543 0.22168 107.761 0.94805 107.426 1.33917C107.202 1.61855 106.699 2.28904 106.699 3.29479C106.699 4.63578 107.481 5.41802 107.873 5.75327C108.431 6.14439 109.102 6.36789 109.772 6.36789C110.219 6.36789 111.281 6.25614 112.119 5.30627C112.845 4.52403 112.901 3.68591 112.901 3.29479ZM112.622 3.29479C112.622 4.46815 111.896 5.52977 110.778 5.92089C110.331 6.08852 109.996 6.08852 109.828 6.08852C108.711 6.08852 107.649 5.41802 107.202 4.3564C107.09 4.02116 106.979 3.68591 106.979 3.29479C106.979 2.00967 107.761 1.2833 108.152 1.00392C108.822 0.501053 109.493 0.445178 109.828 0.445178C111.113 0.445178 111.784 1.17155 112.063 1.56267C112.566 2.28904 112.622 3.01541 112.622 3.29479Z" fill="black" data-v-d02e5e9c></path></svg></div>', 1)), P("div", SE, [d[2] || (d[2] = P("svg", {
            xmlns: "http://www.w3.org/2000/svg",
            width: "21",
            height: "20",
            viewBox: "0 0 21 20",
            fill: "none"
          }, [P("path", {
            d: "M10.3125 2.5C14.4546 2.5 17.8125 5.85787 17.8125 10C17.8125 14.1421 14.4546 17.5 10.3125 17.5C6.17036 17.5 2.8125 14.1421 2.8125 10C2.8125 5.85787 6.17036 2.5 10.3125 2.5Z",
            stroke: "#222222",
            "stroke-width": "1.15625",
            "stroke-miterlimit": "10"
          }), P("path", {
            d: "M10.3125 13.75V9.375",
            stroke: "#222222",
            "stroke-width": "1.41063",
            "stroke-linecap": "round",
            "stroke-linejoin": "round"
          }), P("path", {
            d: "M10.3125 5.625C10.8303 5.625 11.25 6.04473 11.25 6.5625C11.25 7.08027 10.8303 7.5 10.3125 7.5C9.79473 7.5 9.375 7.08027 9.375 6.5625C9.375 6.04473 9.79473 5.625 10.3125 5.625Z",
            fill: "#222222"
          })], -1)), P("div", PE, [P("p", bE, Y(y(F)("팬톤검색안내")), 1)])])]), P("span", OE, Y(a.value ? a.value.pantone_name.replace("PANTONE ", "") : "PANTONE#"), 1)])]), P("div", EE, [P("form", {
            onSubmit: no(u, ["prevent"])
          }, [re(P("input", {
            "onUpdate:modelValue": d[1] || (d[1] = f => i.value = f),
            type: "text",
            name: "pantone",
            placeholder: y(F)("넘버 입력"),
            "data-gtm-form-interact-field-id": "0"
          }, null, 8, IE), [[dt, i.value]]), d[4] || (d[4] = P("button", {
            type: "submit",
            class: "search-btn"
          }, null, -1))], 32), P("p", RE, Y(y(F)("팬톤검색문구")), 1)]), P("button", {
            type: "button",
            class: "confirm-btn",
            disabled: !a.value,
            onClick: r
          }, Y(y(F)("적용하기")), 9, NE)])])])]);
        };
      }
    }), [["__scopeId", "data-v-d02e5e9c"]]),
    ME = {
      class: "special-option"
    },
    wE = ["src"],
    LE = {
      class: "text"
    },
    kE = {
      class: "desc"
    },
    $E = {
      class: "detail"
    },
    FE = {
      class: "detail-subject"
    },
    UE = {
      class: "detail-value"
    },
    BE = oe({
      __name: "ApparelPrintColor",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = Te("deviceType", "pc"),
          r = Ve(),
          i = H(!1),
          l = () => i.value = !i.value,
          u = H(null),
          c = f => {
            u.value = f, a === "pc" && !s.onSetPantone && l();
          },
          d = () => {
            s.onSetPantone ? s.onSetPantone({
              options: [...n.options],
              setter: c
            }) : l();
          },
          p = () => {
            s?.onReset && s.onReset("printColor");
          };
        return U(() => u.value, f => {
          if (!f) return;
          r.isAfterEdit() && p();
          const {
              pantone_name: v
            } = f,
            h = v.replace("PANTONE ", "");
          o("update", {
            ...f,
            pantone_code: h
          });
        }), (f, v) => (_(), O(q, null, [ne(ve, {
          title: "인쇄 컬러(팬톤)"
        }, {
          default: fe(() => [P("div", ME, [P("figure", null, [P("img", {
            src: `${y(ut)}/ko/item/page-order-clothes-pantone.png`,
            alt: "팬톤 컬러 이미지"
          }, null, 8, wE), P("p", LE, Y(y(F)("팬톤 컬러")), 1)]), P("div", kE, [P("div", $E, [P("p", FE, Y(y(F)("1종 선택 가능")), 1), P("span", UE, Y(u.value?.pantone_name || "PANTONE"), 1)]), P("button", {
            type: "button",
            onClick: d
          }, Y(y(F)("팬톤 컬러 선택하기")), 1)])])]),
          _: 1
        }), i.value ? (_(), V(AE, {
          key: 0,
          options: f.options,
          selected: u.value,
          onClose: l,
          onSelect: c
        }, null, 8, ["options", "selected"])) : J("", !0)], 64));
      }
    }),
    lv = oe({
      __name: "PAK_POL_Simple",
      props: {
        detail: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H("N");
        return U(() => s.value, a => {
          const {
            PCS_CD: r,
            PCS_GRP_NM: i,
            PCS_DTL_CD: l,
            PCS_DTL_NM: u,
            VIEW_YN: c,
            ESN_YN: d
          } = n.detail;
          o("update", a === "Y" ? [{
            PCS_CD: r,
            PCS_GRP_NM: i,
            VIEW_YN: c,
            ESN_YN: d,
            selectedOptions: [{
              PCS_CD: r,
              PCS_DTL_CD: l,
              PCS_DTL_NM: u
            }]
          }] : []);
        }, {
          immediate: !0
        }), (a, r) => (_(), V(ve, {
          title: "개별 포장"
        }, {
          default: fe(() => [ne(Rn, {
            options: [{
              id: "PAK_POL/N",
              name: "PAK_POL",
              label: "선택안함",
              value: "N"
            }, {
              id: "PAK_POL/Y",
              name: "PAK_POL",
              label: "선택함",
              value: "Y"
            }],
            "default-checked": s.value,
            onChange: r[0] || (r[0] = i => s.value = i.value)
          }, null, 8, ["default-checked"])]),
          _: 1
        }));
      }
    }),
    xE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: lv
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    HE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "Apparel",
        props: {
          type: {
            default: "new"
          },
          data: {},
          widgetAttr: {},
          defaultData: {},
          senecaInfo: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.widgetAttr.skinInfo),
            a = Te("member"),
            r = b(() => u.value.clothesSelectData?.printType),
            i = b(() => r.value?.PRINT_GBN === "N" ? "single" : r.value?.COD === "PTP_SLK" ? "multi" : "single"),
            {
              uploadConfig: l
            } = da(n.widgetAttr),
            {
              orderInfo: u,
              updateOption: c,
              updatePcsOption: d
            } = fa(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: T => o("update", T)
              }
            }),
            p = b(() => u.value.clothesSelectData?.colorInfo?.COD),
            f = b(() => n.data.apparel_info?.size_info.reduce((T, g) => (T[g.COD] = g, T), {})),
            v = b(() => {
              if (p.value) return n.data.apparel_info?.size_color_info.filter(T => T.CLR_COD === p.value);
            }),
            h = Xe({}),
            m = H(null),
            D = b(() => m.value?.reduce((T, g) => (T[g.size.MTRL_COD] = g, T), {}));
          U(() => m.value, T => {
            if (!T) return;
            c("sizeInfo", !0)(T);
            const g = n.data.pdt_mtrl_info.filter(C => C.MTRL_CD === T[0]?.size.MTRL_COD);
            if (g.length > 0) {
              const {
                PTT_CD: C,
                PTT_NM: S,
                WGT_CD: R,
                CLR_CD: E,
                MTRL_CD: L,
                MTRL_NM: G,
                MTRL_TYPE: X,
                PRT_HIDE_YN: K
              } = g[0];
              c("meterialInfo")({
                PTT_CD: C,
                PTT_NM: S,
                WGT_CD: R,
                CLR_CD: E,
                MTRL_CD: L,
                MTRL_NM: G,
                MTRL_TYPE: X,
                PRT_HIDE_YN: K
              });
            }
          }), U(() => D.value, T => {
            if (!T) return;
            const g = n.data.pdt_pcs_info.filter(C => C.PCS_CD === "DIR_MTR" && C.MTRL_CD && T[C.MTRL_CD]).map(C => {
              const {
                  PCS_CD: S,
                  PCS_DTL_CD: R,
                  PCS_DTL_NM: E,
                  VIEW_YN: L,
                  MTRL_CD: G,
                  ESN_YN: X,
                  DIV_SEQ: K
                } = C,
                de = [{
                  PCS_CD: S,
                  PCS_DTL_CD: R,
                  PCS_DTL_NM: E,
                  ATTB: T[G || ""].quantity
                }];
              return {
                PCS_CD: S,
                VIEW_YN: L,
                ESN_YN: X,
                DIV_SEQ: K,
                active: !1,
                selectedOptions: de
              };
            });
            h.DIR_MTR = g;
          });
          const N = H(null),
            I = b(() => n.data.pdt_pcs_info.reduce((T, g) => (g.PCS_CD === "PDT_WRK" && (T[g.PCS_DTL_CD] = g), T), {}));
          U(() => N.value, T => {
            c("PrintAreaInfo", !0)(T);
          }), U(() => [N.value, u.value.clothesSelectData?.pantoneInfo?.pantone_name, r.value?.COD], ([T, g, C]) => {
            const S = T ? T?.map(R => {
              const E = I.value[R.COD],
                {
                  PCS_CD: L,
                  PCS_DTL_CD: G,
                  PCS_DTL_NM: X,
                  VIEW_YN: K,
                  ESN_YN: de
                } = E,
                be = [{
                  PCS_CD: L,
                  PCS_DTL_CD: G,
                  PCS_DTL_NM: X,
                  KOI_NME: R.KOI_NME,
                  ...(C === "PTP_SLK" && g ? {
                    ATTB: "",
                    ATTB_2: g
                  } : {})
                }];
              return {
                PCS_CD: L,
                VIEW_YN: K,
                ESN_YN: de,
                active: !0,
                selectedOptions: be
              };
            }) : [];
            h.PDT_WRK = S;
          });
          const w = b(() => n.data.pdt_pcs_info.find(T => T.PCS_CD === "PAK_POL"));
          U(() => h, T => {
            d("POST_PCS")(Object.values(T).flatMap(g => g));
          }, {
            deep: !0
          }), U(() => n.data.pdt_size_info, T => {
            if (!T || !T[0]) return;
            const g = {
              DIV_NM: T[0].DIV_NM || "",
              DIV_SEQ: T[0].DIV_SEQ,
              DivInfo: {},
              cutSize: {
                width: +T[0].CUT_WDT,
                height: +T[0].CUT_HGH
              },
              workSize: {
                width: +T[0].WRK_WDT,
                height: +T[0].WRK_HGH
              }
            };
            c("sizeInfo")(g);
          }, {
            immediate: !0,
            once: !0
          });
          const A = Te("callbacks", {}),
            j = Ve(),
            B = () => {
              A?.onReset && A.onReset("fileUpload");
            };
          return U(() => r.value, T => {
            T.PRINT_GBN === "N" && (u.value.fileUploadInfo && u.value.fileUploadInfo[0] && (c("fileUploadInfo")([null]), B()), j.editorData.default && B());
          }), (T, g) => (_(), O(q, null, [T.data.apparel_info?.print_type ? (_(), V(PO, {
            key: 0,
            options: T.data.apparel_info?.print_type,
            "dosu-options": T.data.pdt_dosu_info,
            "related-data": {
              color: p.value
            },
            "onUpdate:type": g[0] || (g[0] = C => y(c)("printType", !0)(C)),
            "onUpdate:dosu": g[1] || (g[1] = C => y(c)("dosuInfo")(C))
          }, null, 8, ["options", "dosu-options", "related-data"])) : J("", !0), T.data.apparel_info?.apparel_color ? (_(), V(kO, {
            key: 1,
            options: T.data.apparel_info.apparel_color,
            onUpdate: g[2] || (g[2] = C => y(c)("colorInfo", !0)(C))
          }, null, 8, ["options"])) : J("", !0), v.value && i.value === "single" && f.value ? (_(), V(YO, {
            key: 2,
            options: v.value,
            "size-info": f.value,
            "onUpdate:qty": g[3] || (g[3] = C => y(c)("quantityInfo")(C)),
            "onUpdate:combinations": g[4] || (g[4] = C => m.value = C)
          }, null, 8, ["options", "size-info"])) : J("", !0), v.value && i.value === "multi" && f.value ? (_(), V(oE, {
            key: 3,
            options: v.value,
            "size-info": f.value,
            "onUpdate:qty": g[5] || (g[5] = C => y(c)("quantityInfo")(C)),
            "onUpdate:combinations": g[6] || (g[6] = C => m.value = C)
          }, null, 8, ["options", "size-info"])) : J("", !0), T.data.apparel_info?.print_area ? (_(), V(HO, {
            key: 4,
            options: T.data.apparel_info.print_area,
            "related-data": {
              printType: r.value
            },
            onUpdate: g[7] || (g[7] = C => N.value = C)
          }, null, 8, ["options", "related-data"])) : J("", !0), T.data.apparel_info?.pantone_color && y(u).clothesSelectData?.printType?.COD === "PTP_SLK" ? (_(), V(BE, {
            key: 5,
            options: T.data.apparel_info.pantone_color,
            onUpdate: g[8] || (g[8] = C => y(c)("pantoneInfo", !0)(C))
          }, null, 8, ["options"])) : J("", !0), s.value.subjectGroup.view_yn === "Y" ? (_(), V(Su, {
            key: 6,
            "is-biz-mem": y(a)?.bsn_yn === "Y",
            onUpdate: g[9] || (g[9] = C => y(c)("etcInfo")(C))
          }, null, 8, ["is-biz-mem"])) : J("", !0), w.value ? (_(), V(lv, {
            key: 7,
            detail: w.value,
            onUpdate: g[10] || (g[10] = C => h.PAK_POL = C)
          }, null, 8, ["detail"])) : J("", !0), r.value?.PRINT_GBN === "Y" && T.widgetAttr.order_yn !== "N" ? (_(), V(us, {
            key: 8,
            "upload-config": y(l),
            "show-extra": T.widgetAttr.useTemplateDownload === "Y" && T.widgetAttr.usePDF === "Y",
            "related-data": {
              apparel: {
                printType: r.value?.COD,
                pantone: y(u).clothesSelectData.pantoneInfo?.hex_cod
              }
            },
            onUpload: g[11] || (g[11] = C => y(c)("fileUploadInfo")(C))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : J("", !0), ne(ca, {
            "upload-config": y(l)
          }, null, 8, ["upload-config"])], 64));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    GE = {
      class: "flex-row -center"
    },
    WE = ["id"],
    VE = ["name"],
    jE = ["value"],
    zE = {
      key: 0,
      class: "notes"
    },
    KE = {
      key: 0,
      class: "note"
    },
    YE = {
      key: 1,
      class: "note"
    },
    QE = {
      key: 1,
      class: "notes"
    },
    qE = {
      class: "note"
    },
    XE = {
      class: "note"
    },
    Ru = Ne(oe({
      __name: "BookQty",
      props: {
        type: {},
        options: {},
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("productCode", {
            pdtCode: ""
          }),
          a = b(() => s.pdtCode[4] === "O"),
          r = b(() => n.options[0]),
          i = b(() => n.type === "default" ? r.value.INC_CNT : r.value.STEP_INN_PAGE),
          l = b(() => n.type === "default" && r.value.FIR_CNT === 2),
          u = b(() => n.type === "default" ? r.value.MIN_PRN_CNT : r.value.MIN_INN_PAGE),
          c = b(() => n.type === "default" ? null : r.value.MAX_INN_PAGE),
          d = H(u.value),
          p = b(() => !!(u.value > d.value || c.value && c.value < d.value));
        U(() => d.value, N => {
          p.value || o("update", n.type, N);
        }, {
          immediate: !0
        });
        const f = b(() => {
            const N = n.relatedData?.dosu === "SID_D" ? 2 : 1;
            return (d.value * N).toLocaleString();
          }),
          v = () => {
            if (u.value > d.value) return d.value = u.value;
            if (c.value && c.value < d.value) return d.value = c.value;
            if (n.type === "default" && l.value) {
              const N = d.value % 2;
              if (N > 0) return d.value = d.value + N;
            }
            if (n.type === "inner" && i.value === 2) {
              const N = d.value % 2;
              if (N > 0) return d.value = d.value + N;
            }
          },
          h = b(() => {
            const N = [],
              I = i.value > u.value ? i.value : u.value,
              w = i.value > u.value ? 10 : 9,
              A = c.value ?? i.value * w + u.value;
            for (let j = I; j <= A; j += i.value) j === i.value && i.value > u.value && N.push({
              value: u.value
            }), N.push({
              value: j
            });
            return N;
          }),
          m = H("select"),
          D = () => {
            m.value = m.value === "input" ? "select" : "input";
          };
        return (N, I) => {
          const w = it("dompurify-html");
          return _(), V(ve, {
            title: N.type === "default" ? y(F)("수량") : y(F)("내지장수")
          }, {
            default: fe(() => [P("div", GE, [m.value === "input" ? re((_(), O("input", {
              key: 0,
              "onUpdate:modelValue": I[0] || (I[0] = A => d.value = A),
              type: "number",
              class: $e(["basic-input", "-fixed-w"]),
              id: N.type === "default" ? "QTY" : "INNER_QTY",
              onFocusout: v
            }, null, 40, WE)), [[dt, d.value]]) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": I[1] || (I[1] = A => d.value = A),
              name: N.type === "default" ? "QTY" : "INNER_QTY",
              class: "basic-select -fixed-w"
            }, [(_(!0), O(q, null, ce(h.value, A => (_(), O("option", {
              value: A.value,
              key: A.value
            }, Y(A.value), 9, jE))), 128))], 8, VE)), [[Ke, d.value]]), P("button", {
              type: "button",
              class: "action-btn",
              onClick: D
            }, Y(m.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)]), N.type === "default" ? (_(), O("div", zE, [a.value ? re((_(), O("p", YE, null, 512)), [[w, y(F)(l.value ? "토너책자최소수량안내-짝수" : "토너책자최소수량안내").replace("{MIN_CNT}", `${u.value}`)]]) : re((_(), O("p", KE, null, 512)), [[w, y(F)("윤전책자최소수량안내").replace("{MIN_CNT}", `${u.value}`)]])])) : (_(), O("div", QE, [re(P("p", qE, null, 512), [[w, y(F)("내지장수안내").replace("{QTY}", `${f.value}`)]]), re(P("p", XE, null, 512), [[w, y(F)("내지최대장수안내").replace("{MAX_CNT}", `${c.value}`)]])]))]),
            _: 1
          }, 8, ["title"]);
        };
      }
    }), [["__scopeId", "data-v-106e3545"]]),
    ZE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ru
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    JE = {
      class: "flex-row"
    },
    eI = ["value"],
    tI = ["value"],
    uv = oe({
      __name: "DosuColor",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = Ve(),
          r = b(() => n.options.all.length > n.options.dosu.length),
          i = H(n.options.dosu[0].COD),
          l = H(n.options.color[0].COD),
          u = b(() => n.options.all.find(d => d.BNC_GB === l.value && d.COD === i.value)),
          c = () => {
            s?.onReset && s.onReset("dosu");
          };
        return U(() => u.value, d => {
          d && (a.isAfterEdit() && c(), o("update", d));
        }, {
          immediate: !0
        }), (d, p) => (_(), V(ve, {
          title: "인쇄도수"
        }, {
          default: fe(() => [P("div", JE, [re(P("select", {
            "onUpdate:modelValue": p[0] || (p[0] = f => i.value = f),
            name: "dosu",
            class: "basic-select"
          }, [(_(!0), O(q, null, ce(d.options.dosu, f => (_(), O("option", {
            key: f.COD,
            value: f.COD
          }, Y(f.COD_NME), 9, eI))), 128))], 512), [[Ke, i.value]]), r.value ? re((_(), O("select", {
            key: 0,
            "onUpdate:modelValue": p[1] || (p[1] = f => l.value = f),
            name: "dosu-color",
            class: "basic-select"
          }, [(_(!0), O(q, null, ce(d.options.color, f => (_(), O("option", {
            key: f.COD,
            value: f.COD
          }, Y(f.COD_NME), 9, tI))), 128))], 512)), [[Ke, l.value]]) : J("", !0)])]),
          _: 1
        }));
      }
    }),
    nI = {
      class: "flex-row"
    },
    oI = ["disabled"],
    sI = ["value", "disabled"],
    aI = ["disabled"],
    iI = ["value", "disabled"],
    rI = {
      class: "tooltip-box"
    },
    lI = {
      key: 0,
      class: "notice"
    },
    Ei = Ne(oe({
      __name: "Paper",
      props: {
        options: {},
        showExtra: {
          type: Boolean,
          default: !1
        },
        default: {},
        resetAfterEdit: {
          type: Boolean
        },
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("callbacks", {}),
          a = Te("productCode", {
            pdtCode: ""
          }),
          r = _t(),
          i = b(() => {
            const g = [];
            return g.length > 0 ? g : n.options;
          }),
          l = b(() => i.value.filter(g => g.HIDE_YN !== "Y")),
          u = b(() => {
            const g = new Map();
            return i.value.forEach(C => {
              const {
                  WGT_CD: S,
                  MTRL_CD: R,
                  PTT_CD: E,
                  PTT_NM: L,
                  BSN_YN: G,
                  HIDE_YN: X,
                  HIDE_RSN: K
                } = C,
                de = g.get(E),
                be = {
                  WGT_CD: S,
                  MTRL_CD: R,
                  HIDE_YN: X,
                  HIDE_RSN: K
                };
              if (de) de.weights.push(be);else {
                const xe = {
                  PTT_CD: E,
                  PTT_NM: L,
                  BSN_YN: G,
                  weights: [be]
                };
                g.set(E, xe);
              }
            }), g;
          }),
          c = async () => {
            const g = await lu({
              pdt_cod: a.pdtCode,
              lang: r.locale
            });
            if (!g) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
            s?.onInformMaterials ? s.onInformMaterials(g) : console.log("[RedWidgetSDK] 용지 정보 >", g);
          },
          d = () => {
            n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
          },
          p = l.value.find(g => g.DFT_YN === "Y"),
          f = H(n.default?.PTT_CD || p?.PTT_CD || l.value[0]?.PTT_CD),
          v = H(n.default?.MTRL_CD || p?.MTRL_CD || l.value[0]?.MTRL_CD),
          h = H(!1);
        let m = null;
        function D() {
          m && clearTimeout(m), h.value = !0, m = setTimeout(() => {
            h.value = !1;
          }, 5e3);
        }
        Vo(() => {
          f.value === "ATL" && D();
        });
        const N = new Set(["SNO", "ART"]),
          I = b(() => {
            const g = new Set();
            for (const C of n.options) N.has(C.PTT_CD) && +C.WGT_CD <= 120 && g.add(C.PTT_CD);
            return g;
          }),
          w = b(() => I.value.has(f.value)),
          A = b(() => {
            if (!I.value.has(f.value)) return !1;
            const g = n.relatedData?.sizeInfo?.cutSize;
            if (!g) return !1;
            const C = Math.max(g.width, g.height),
              S = Math.min(g.width, g.height);
            return C > 420 && S > 297;
          }),
          j = (g, C) => I.value.has(g) && A.value && +C < 120,
          B = (g, C) => g.HIDE_YN === "Y" || !!C && j(C, g.WGT_CD),
          T = (g, C) => g.every(S => B(S, C));
        return U(() => f.value, g => {
          const C = u.value.get(g);
          if (C) {
            const S = C.weights.find(R => !B(R, g));
            S && (v.value = S.MTRL_CD);
          }
          g === "OOO" && s?.onSaleOrder && s?.onSaleOrder(), g === "ATL" && D();
        }, {
          immediate: !0
        }), U(() => A.value, g => {
          if (!g) return;
          const C = u.value.get(f.value)?.weights;
          if (!C) return;
          const S = C.find(E => E.MTRL_CD === v.value);
          if (!S || !j(f.value, S.WGT_CD)) return;
          const R = C.find(E => !B(E, f.value));
          R && R.MTRL_CD !== v.value && (v.value = R.MTRL_CD);
        }), U(() => n.relatedData?.forcedMtrlCd, g => {
          if (g) {
            for (const [C, S] of u.value.entries()) if (S.weights.find(E => E.MTRL_CD === g)) {
              f.value = C, v.value = g;
              break;
            }
          }
        }, {
          immediate: !0
        }), U(() => v.value, g => {
          const C = l.value.find(S => S.MTRL_CD === g);
          if (C) {
            const {
              PTT_CD: S,
              PTT_NM: R,
              WGT_CD: E,
              CLR_CD: L,
              MTRL_CD: G,
              MTRL_NM: X,
              MTRL_TYPE: K,
              PRT_HIDE_YN: de,
              SID_GBN: be
            } = C;
            o("update", {
              PTT_CD: S,
              PTT_NM: R,
              WGT_CD: E,
              CLR_CD: L,
              MTRL_CD: G,
              MTRL_NM: X,
              MTRL_TYPE: K,
              PRT_HIDE_YN: de,
              SID_GBN: be
            });
          }
        }, {
          immediate: !0
        }), (g, C) => {
          const S = it("dompurify-html");
          return _(), V(ve, {
            title: "용지",
            extra: g.showExtra ? {
              name: "주문가능자재",
              callback: c
            } : null
          }, {
            default: fe(() => [P("div", nI, [re(P("select", {
              "onUpdate:modelValue": C[0] || (C[0] = R => f.value = R),
              class: "basic-select",
              name: "paper",
              disabled: !!n.relatedData?.lockedMtrl
            }, [(_(!0), O(q, null, ce(u.value.values(), R => (_(), O("option", {
              key: R.PTT_CD,
              value: R.PTT_CD,
              disabled: T(R.weights, R.PTT_CD),
              onChange: d
            }, Y(T(R.weights, R.PTT_CD) ? `[${R.weights[0].HIDE_RSN || "주문불가"}]` : "") + " " + Y(R.PTT_NM) + " " + Y(R.BSN_YN === "Y" ? "[영업주문]" : ""), 41, sI))), 128))], 8, oI), [[Ke, f.value]]), re(P("select", {
              "onUpdate:modelValue": C[1] || (C[1] = R => v.value = R),
              class: "basic-select",
              name: "weight",
              disabled: !!n.relatedData?.lockedMtrl
            }, [(_(!0), O(q, null, ce(u.value.get(f.value)?.weights, R => (_(), O("option", {
              key: `${R.MTRL_CD}`,
              value: R.MTRL_CD,
              disabled: B(R, f.value)
            }, Y(B(R, f.value) ? `[${R.HIDE_RSN || "주문불가"}]` : "") + " " + Y(`${R.WGT_CD}g`), 9, iI))), 128))], 8, aI), [[Ke, v.value]]), f.value === "ATL" ? (_(), O("div", {
              key: 0,
              class: $e(["tooltip-wrap", {
                "tooltip-open": h.value
              }])
            }, [C[2] || (C[2] = P("span", {
              class: "tooltip-icon"
            }, "!", -1)), re(P("div", rI, null, 512), [[S, y(F)("아트지라벨코팅안내")]])], 2)) : J("", !0)]), w.value ? (_(), O("p", lI, Y(y(F)("용지-A3이상-120g")), 1)) : J("", !0)]),
            _: 1
          }, 8, ["extra"]);
        };
      }
    }), [["__scopeId", "data-v-6a835c67"]]),
    uI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ei
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    cI = {
      class: "special-option"
    },
    dI = ["src"],
    fI = {
      class: "text"
    },
    pI = {
      class: "desc"
    },
    _I = {
      key: 0,
      class: "detail"
    },
    hI = {
      class: "detail-subject"
    },
    vI = {
      class: "detail-value"
    },
    mI = {
      key: 1,
      class: "detail"
    },
    CI = {
      class: "detail-subject"
    },
    TI = {
      class: "detail-value"
    },
    gI = Ne(oe({
      __name: "CoverGuide",
      props: {
        sizeInfo: {},
        senecaInfo: {}
      },
      setup(e) {
        const t = e,
          n = Te("productCode", {
            pdtCode: ""
          }),
          o = Te("callbacks", {}),
          s = H(t.senecaInfo);
        U(() => t.senecaInfo, f => {
          f && (s.value = f);
        });
        const a = Mo(),
          r = _t(),
          i = async () => {
            const f = a.getOrderData();
            if (!f) return;
            const v = Nb(f);
            if (!v || typeof v == "string") return alert(F(v || "템플릿다운로드실패"));
            (await JS({
              lang: r.locale,
              ...v
            })) || alert(F("템플릿다운로드실패"));
          },
          l = {
            PRBKYPB: !0,
            PRBKYCB: !0,
            PRBKYRB: !0,
            PRBKOPB: !0,
            PRBKOCB: !0,
            PRBKORB: !0
          },
          u = {
            PRBKYPR: !0,
            PRBKOPR: !0,
            PRBKYPB: !0,
            PRBKOPB: !0
          },
          c = {
            PRBKYCO: !0,
            PRBKYCB: !0,
            PRBKYRN: !0,
            PRBKYRB: !0,
            PRBKOCO: !0,
            PRBKOCB: !0,
            PRBKORN: !0,
            PRBKORB: !0,
            PRBKORD: !0,
            PRBKOCD: !0
          },
          d = {
            PRBKYST: !0,
            PRBKYSL: !0,
            PRBKOST: !0,
            PRBKOSL: !0
          },
          p = b(() => {
            if (!t.sizeInfo) return null;
            if (d[n.pdtCode]) return {
              title: "소프트커버",
              imgSrc: `${ut}/ko/cover_icon_stapler.png`
            };
            const v = t.sizeInfo.workSize.width > t.sizeInfo.workSize.height ? ev.has(n.pdtCode) ? "_wh" : "_w" : "_h",
              h = l[n.pdtCode] ? "_black" : "";
            return u[n.pdtCode] ? {
              title: "세네카",
              imgSrc: `${ut}/ko/cover_icon_wireless${h}${v}.png`
            } : c[n.pdtCode] ? {
              title: "낱장커버",
              imgSrc: `${ut}/ko/cover_icon_spring${h}${v}.png`
            } : null;
          });
        return (f, v) => (_(), V(ve, {
          title: "표지가이드",
          extra: {
            name: "가이드보기",
            callback: () => {
              y(o)?.onInformGuide && y(o).onInformGuide("bookCover");
            }
          }
        }, {
          default: fe(() => [P("div", cI, [P("figure", null, [P("img", {
            src: p.value?.imgSrc
          }, null, 8, dI), P("figcaption", fI, Y(y(F)(p.value?.title || "")), 1)]), P("div", pI, [s.value?.seneca_show === "Y" ? (_(), O("div", _I, [P("p", hI, Y(y(F)("세네카")), 1), P("span", vI, [P("b", null, Y(s.value?.seneca), 1), v[0] || (v[0] = yo(" mm ", -1))])])) : (_(), O("div", mI, [P("p", CI, Y(y(F)("표지작업사이즈")), 1), P("span", TI, [P("b", null, Y(f.sizeInfo?.workSize.width) + "x" + Y(f.sizeInfo?.workSize.height), 1), v[1] || (v[1] = yo(" mm ", -1))])])), P("button", {
            type: "button",
            class: "download-btn",
            onClick: i
          }, Y(y(F)("표지템플릿다운로드")), 1)])])]),
          _: 1
        }, 8, ["extra"]));
      }
    }), [["__scopeId", "data-v-7f08ebe2"]]),
    yI = {
      class: "group-title"
    },
    DI = {
      class: "subject"
    },
    SI = {
      class: "group-title"
    },
    PI = {
      class: "subject"
    },
    bI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "Book",
        props: {
          type: {
            default: "new"
          },
          data: {},
          widgetAttr: {},
          defaultData: {},
          senecaInfo: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.widgetAttr.skinInfo),
            {
              defaultOrderData: a,
              orderInfo: r,
              updateOption: i,
              updatePostPcs: l
            } = fa(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: T => o("update", T)
              }
            }),
            u = H(null);
          function c(T) {
            u.value = Object.keys(T).find(g => g.startsWith("CVR_") && g !== "CVR_SFT") ?? null, l("visible")(T);
          }
          const d = b(() => !!r.value.pcsInfo?.find(T => T.PCS_CD === "SCO_DFT")),
            p = H({
              ordCnt: 0,
              prnCnt: 0
            }),
            f = (T, g) => {
              T === "default" && (p.value = {
                ...p.value,
                ordCnt: g
              }), T === "inner" && (p.value = {
                ...p.value,
                prnCnt: g
              });
            };
          U(() => p.value, an(T => {
            i("quantityInfo")(T);
          }, 200), {
            immediate: !0
          });
          const v = Te("member"),
            h = b(() => v?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(T => T.BSN_YN !== "Y")),
            m = b(() => v?.bsn_yn === "Y" ? n.data.inner_pdt_mtrl_info : n.data.inner_pdt_mtrl_info?.filter(T => T.BSN_YN !== "Y")),
            D = b(() => r.value?.pcsInfo?.find(T => T.PCS_CD === "BIND_DIRECTION")),
            {
              uploadConfig: N
            } = da(n.widgetAttr),
            I = b(() => r.value.dosuInfo?.BNC_GB === "BNC_BLA" ? {
              pdf: !0,
              editor: null,
              useGarage: N.value.useGarage
            } : N.value),
            w = H([]),
            A = T => g => {
              const C = g[0];
              T === "inner" && (w.value = [C, w.value[1]]), T === "default" && (w.value = [w.value[0], C]);
            };
          U(() => w.value, T => {
            i("fileUploadInfo")(T);
          });
          const j = b(() => Pi(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            B = b(() => Ti[n.data.pdt_base_info[0].PDT_CD] ? r.value.quantityInfo?.prnCnt || 1 : (r.value.quantityInfo?.ordCnt || 1) * (r.value.quantityInfo?.prnCnt || 1));
          return (T, g) => (_(), O(q, null, [re(ne(yi, {
            options: T.data.pdt_size_info,
            "base-info": T.data.pdt_base_info[0],
            default: y(a)?.size,
            "hidden-sizes": !0,
            "show-extra": !0,
            onUpdate: g[0] || (g[0] = C => y(i)("sizeInfo")(C)),
            onValidate: g[1] || (g[1] = C => y(i)("validation")(C))
          }, null, 8, ["options", "base-info", "default"]), [[Lt, s.value.sizeSelect.view_yn === "Y"]]), ne(Ru, {
            type: "default",
            options: T.data.pdt_prn_cnt_info,
            onUpdate: f
          }, null, 8, ["options"]), P("div", yI, [P("span", DI, Y(y(F)("내지")), 1)]), re(ne(uv, {
            options: {
              dosu: T.data.inner_pdt_dosu_info,
              color: T.data.inner_pdt_bnc_info,
              all: T.data.inner_pdt_dosu_bnc_info
            },
            onUpdate: g[2] || (g[2] = C => y(i)("inner_dosuInfo")(C))
          }, null, 8, ["options"]), [[Lt, s.value.dosuSelect.view_yn === "Y" && T.data.inner_pdt_dosu_bnc_info]]), ne(Ei, {
            options: m.value,
            "show-extra": T.widgetAttr.able_paper_yn === "Y",
            onUpdate: g[3] || (g[3] = C => y(i)("inner_meterialInfo")(C))
          }, null, 8, ["options", "show-extra"]), ne(Ru, {
            type: "inner",
            options: T.data.pdt_prn_cnt_info,
            "related-data": {
              dosu: y(r).inner_dosuInfo?.COD
            },
            onUpdate: f
          }, null, 8, ["options", "related-data"]), T.widgetAttr.order_yn !== "N" ? (_(), V(us, {
            key: 0,
            _key: "inner",
            "upload-config": {
              pdf: !0,
              editor: null
            },
            subject: "내지업로드",
            notes: [y(F)("내지업로드사이즈장수안내", {
              CUT_SIZE: `${y(r).sizeInfo?.cutSize.width}x${y(r).sizeInfo?.cutSize.height}`,
              WRK_SIZE: `${y(r).sizeInfo?.workSize.width}x${y(r).sizeInfo?.workSize.height}`,
              QTY: `${y(r).quantityInfo?.prnCnt * (y(r).inner_dosuInfo?.COD === "SID_D" ? 2 : 1)}`
            })],
            onUpload: g[4] || (g[4] = C => A("inner")(C))
          }, null, 8, ["notes"])) : J("", !0), P("div", SI, [P("span", PI, Y(y(F)("표지")), 1)]), re(ne(uv, {
            options: {
              dosu: T.data.pdt_dosu_info,
              color: T.data.pdt_bnc_info,
              all: T.data.pdt_dosu_bnc_info
            },
            onUpdate: g[5] || (g[5] = C => y(i)("dosuInfo")(C))
          }, null, 8, ["options"]), [[Lt, s.value.dosuSelect.view_yn === "Y" && T.data.pdt_dosu_info]]), re(ne(Ei, {
            options: h.value,
            "show-extra": T.widgetAttr.able_paper_yn === "Y",
            onUpdate: g[6] || (g[6] = C => y(i)("meterialInfo")(C))
          }, null, 8, ["options", "show-extra"]), [[Lt, h.value.length > 1]]), ne(gI, {
            "size-info": y(r).sizeInfo,
            "seneca-info": T.senecaInfo
          }, null, 8, ["size-info", "seneca-info"]), ne(Di, {
            options: j.value.postPcs.hidden,
            "related-data": {
              mtrlCd: y(r).meterialInfo?.MTRL_CD,
              sizeInfo: y(r).sizeInfo,
              orderQty: B.value,
              bindDirection: D.value,
              selectedCoverPcs: u.value
            },
            onUpdate: g[7] || (g[7] = C => y(l)("hidden")(C))
          }, null, 8, ["options", "related-data"]), ne(Si, {
            options: j.value.postPcs.visible,
            "disabled-opts": j.value.disabled,
            "attb-opts": T.data.pdt_add_info[1],
            "related-data": {
              mtrlCd: y(r).meterialInfo?.MTRL_CD,
              sizeInfo: y(r).sizeInfo
            },
            onUpdate: g[8] || (g[8] = C => c(C))
          }, null, 8, ["options", "disabled-opts", "attb-opts", "related-data"]), T.widgetAttr.order_yn !== "N" ? (_(), V(us, {
            key: 1,
            _key: "default",
            "upload-config": I.value,
            subject: "표지업로드",
            notes: [y(F)("표지업로드장수안내", {
              QTY: `${y(r).dosuInfo?.COD === "SID_D" ? 2 : 1}`
            })],
            "related-data": {
              hasScodix: d.value
            },
            onUpload: g[9] || (g[9] = C => A("default")(C))
          }, null, 8, ["upload-config", "notes", "related-data"])) : J("", !0), ne(ca, {
            "upload-config": y(N)
          }, null, 8, ["upload-config"])], 64));
        }
      }), [["__scopeId", "data-v-60014286"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    OI = {
      class: "qty-group"
    },
    EI = {
      class: "title"
    },
    II = {
      class: "subject"
    },
    RI = {
      class: "subject"
    },
    NI = {
      class: "inputs"
    },
    AI = ["value"],
    MI = ["disabled"],
    wI = {
      class: "icon-box"
    },
    LI = ["value"],
    kI = {
      class: "notes"
    },
    $I = {
      key: 0,
      class: "note"
    },
    FI = {
      key: 1,
      class: "note"
    },
    UI = {
      key: 2,
      class: "note"
    },
    BI = {
      key: 3,
      class: "note"
    },
    xI = {
      key: 4,
      class: "note"
    },
    cv = 50,
    dv = Ne(oe({
      __name: "OffsetQty",
      props: {
        options: {},
        extraOptions: {},
        default: {},
        relatedData: {},
        canEditOrdCnt: {},
        reamYn: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Te("productCode", {
            pdtCode: ""
          }),
          a = Ve(),
          r = [13, 14, 15, 16],
          i = b(() => s.pdtCode === "HLCLSTD" || s.pdtCode === "HLCLWAL"),
          l = H("select"),
          u = () => {
            l.value = l.value === "input" ? "select" : "input", l.value === "select" && (m.value.find(R => R.PRN_CNT === N.value) || (N.value = d.value));
          },
          c = b(() => n.options.find(S => S.DFT_YN === "Y") || n.options[0]),
          d = b(() => c.value?.DFT_PRN_CNT || 1),
          p = b(() => c.value?.DFT_PRN_CNT || 1),
          f = b(() => {
            const S = n.extraOptions;
            return S && S.length > 0 ? S[0].DFT_PRN_CNT || 1 : c.value?.PRN_CNT || 1;
          }),
          v = b(() => {
            if (n.reamYn !== "Y") return 0;
            const S = c.value;
            return !S?.PRN_CNT || !S?.REAM_CNT ? 0 : S.REAM_CNT / S.PRN_CNT;
          }),
          h = (S, R) => {
            if (n.reamYn === "Y") {
              if (R !== void 0) return R;
              if (v.value) return Math.round(S * v.value);
            }
          },
          m = b(() => {
            const S = n.extraOptions || [],
              R = new Set(S.map(X => X.PRN_CNT)),
              E = [];
            for (const X of n.options) R.has(X.PRN_CNT) || (R.add(X.PRN_CNT), E.push({
              PRN_CNT: X.PRN_CNT,
              reamCnt: h(X.PRN_CNT, X.REAM_CNT)
            }));
            const L = [...S.map(X => ({
                PRN_CNT: X.PRN_CNT,
                reamCnt: h(X.PRN_CNT, X.REAM_CNT)
              })), ...E],
              G = new Set(L.map(X => X.PRN_CNT));
            if (L.length < cv) {
              const X = L.length > 0 ? L[L.length - 1].PRN_CNT : d.value ?? p.value;
              for (let K = X + f.value; L.length < cv; K += f.value) G.has(K) || (L.push({
                PRN_CNT: K,
                reamCnt: h(K)
              }), G.add(K));
            }
            return L;
          }),
          D = H(n.default?.ordCnt || (i.value ? r[0] : 1)),
          N = H(n.default?.prnCnt || d.value || p.value),
          I = b(() => m.value.find(S => S.PRN_CNT === N.value)?.reamCnt ?? h(N.value)),
          w = b(() => ({
            ordCnt: D.value,
            prnCnt: N.value,
            reamCnt: I.value
          })),
          A = b(() => (D.value * N.value).toLocaleString()),
          j = b(() => {
            const R = xh[s.pdtCode]?.[n.relatedData?.mtrlCd || ""] ?? Bh[s.pdtCode] ?? (n.relatedData?.dosu === "SID_D" ? 2 : 1);
            return (D.value * R).toLocaleString();
          }),
          B = b(() => a.uploadType.default === "editor"),
          T = b(() => m.value.some(S => S.PRN_CNT === N.value)),
          g = b(() => {
            if (!N.value) return !0;
            if (T.value) return !1;
            if (f.value !== 1) {
              const S = N.value % f.value;
              if (f.value > 1 && S !== 0) return !0;
            }
            return !1;
          }),
          C = () => {
            if (!N.value) return N.value = d.value;
            if (!T.value && f.value !== 1) {
              const S = N.value % f.value;
              if (f.value > 1 && S !== 0) {
                const R = Math.ceil(N.value / f.value);
                N.value = (R || 1) * f.value;
              }
            }
          };
        return U(() => T.value, S => {
          !S && l.value === "select" && (N.value = d.value);
        }), U(() => w.value, an(S => {
          S.ordCnt || (D.value = 1), !g.value && o("update", S);
        }, 300), {
          immediate: !0
        }), U(() => a.editorData?.default?.quantityInfo?.ordCnt, (S, R) => {
          if (S) D.value = S;else if (R) return D.value = 1;
        }), U(() => a.uploadType.default, S => {
          S === "editor" && (D.value = 1);
        }), (S, R) => {
          const E = it("dompurify-html");
          return _(), V(ve, {
            option: "Qty"
          }, {
            default: fe(() => [P("div", OI, [P("div", EI, [P("h2", II, Y(y(F)("디자인수")), 1), P("h2", RI, Y(y(F)("수량")), 1)]), P("div", NI, [i.value ? re((_(), O("select", {
              key: 0,
              "onUpdate:modelValue": R[0] || (R[0] = L => D.value = L),
              name: "ORD_CNT",
              class: "basic-select"
            }, [(_(), O(q, null, ce(r, L => P("option", {
              value: L,
              key: L
            }, Y(L) + Y(y(F)("장")), 9, AI)), 64))], 512)), [[Ke, D.value]]) : re((_(), O("input", {
              key: 1,
              "onUpdate:modelValue": R[1] || (R[1] = L => D.value = L),
              type: "number",
              class: "basic-input",
              id: "ORD_CNT",
              min: "1",
              disabled: B.value || !S.canEditOrdCnt.pdf
            }, null, 8, MI)), [[dt, D.value]]), P("div", wI, [ne(ls)]), l.value === "input" ? re((_(), O("input", {
              key: 2,
              "onUpdate:modelValue": R[2] || (R[2] = L => N.value = L),
              type: "number",
              class: "basic-input",
              id: "PRN_CNT",
              min: "1",
              onFocusout: C
            }, null, 544)), [[dt, N.value]]) : re((_(), O("select", {
              key: 3,
              "onUpdate:modelValue": R[3] || (R[3] = L => N.value = L),
              name: "PRN_CNT",
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(m.value, L => (_(), O("option", {
              value: L.PRN_CNT,
              key: L.PRN_CNT
            }, Y(L.PRN_CNT.toLocaleString()) + Y(S.reamYn === "Y" && L.reamCnt ? ` (${L.reamCnt}R)` : ""), 9, LI))), 128))], 512)), [[Ke, N.value]]), P("button", {
              type: "button",
              class: "action-btn",
              onClick: u
            }, Y(l.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)])]), P("div", kI, [i.value ? J("", !0) : re((_(), O("p", $I, null, 512)), [[E, y(F)("주문수량안내", {
              QTY: A.value
            })]]), !i.value && p.value > 1 ? re((_(), O("p", FI, null, 512)), [[E, y(F)("단위주문수량안내", {
              QTY: `${p.value}`
            })]]) : J("", !0), B.value ? J("", !0) : (_(), O("p", UI, "* " + Y(`${y(F)("PDF장수안내", {
              QTY: j.value
            })}`), 1)), S.canEditOrdCnt.pdf && S.canEditOrdCnt.editor ? (_(), O("p", BI, "* " + Y(y(F)("디자인건수가능여부-전체")), 1)) : !S.canEditOrdCnt.pdf && S.canEditOrdCnt.editor ? (_(), O("p", xI, " * " + Y(y(F)("디자인건수가능여부-에디터")), 1)) : J("", !0)])]),
            _: 1
          });
        };
      }
    }), [["__scopeId", "data-v-e66a5cd1"]]),
    HI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: dv
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    GI = new Set(["SKTHDFT"]),
    WI = {
      class: "flex-row -flow"
    },
    VI = oe({
      __name: "CuttingType",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = Te("callbacks", {}),
          r = {
            THO_DFT_SQ: "사각형",
            THO_DFT_CL: "원형",
            THO_DFT_EL: "타원형",
            THO_DFT_RC: "사각라운드형",
            THO_GRA_FR: "자유형"
          },
          i = b(() => n.options.map(u => ({
            value: u,
            name: F(r[u]),
            imgPath: `${u}-1`
          }))),
          l = H(i.value[0].value);
        return U(() => l.value, u => {
          s.isAfterEdit() && a.onReset && a.onReset("shape"), o("update", u);
        }, {
          immediate: !0
        }), (u, c) => (_(), V(ve, {
          title: "칼선타입"
        }, {
          default: fe(() => [P("div", WI, [(_(!0), O(q, null, ce(i.value, d => (_(), V(Be, {
            key: d.value,
            data: d,
            active: l.value === d.value,
            onSelect: p => l.value = p.value
          }, null, 8, ["data", "active", "onSelect"]))), 128))])]),
          _: 1
        }));
      }
    }),
    jI = {
      class: "flex-row -flow"
    },
    zI = oe({
      __name: "CalendarHangType",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = {
            HOL_DFT: "타공형",
            RIN_CUT: "걸이형"
          },
          a = {
            HOL_DFT: "calendar_HOL_DFT",
            RIN_CUT: "calendar_RIN_CUT"
          },
          r = b(() => n.options.map(l => ({
            value: l.PCS_CD,
            name: s[l.PCS_CD],
            imgPath: a[l.PCS_CD]
          }))),
          i = H(n.options[0]?.PCS_CD);
        return U(() => i.value, l => {
          const u = n.options.find(c => c.PCS_CD === l);
          u && o("update", [{
            PCS_CD: u.PCS_CD,
            VIEW_YN: u.VIEW_YN,
            ESN_YN: u.ESN_YN,
            selectedOptions: [{
              PCS_CD: u.PCS_CD,
              PCS_DTL_CD: u.PCS_DTL_CD,
              PCS_DTL_NM: u.PCS_DTL_NM
            }]
          }]);
        }, {
          immediate: !0
        }), (l, u) => (_(), V(ve, {
          title: "걸이타입"
        }, {
          default: fe(() => [P("div", jI, [(_(!0), O(q, null, ce(r.value, c => (_(), V(Be, {
            key: c.value,
            data: c,
            active: i.value === c.value,
            onSelect: u[0] || (u[0] = d => i.value = d.value)
          }, null, 8, ["data", "active"]))), 128))])]),
          _: 1
        }));
      }
    }),
    KI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "Offset",
        props: {
          type: {
            default: "new"
          },
          data: {},
          widgetAttr: {},
          defaultData: {},
          senecaInfo: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.data.pdt_base_info[0].PDT_CD),
            a = b(() => n.widgetAttr.skinInfo),
            r = Te("member"),
            i = b(() => r?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(M => M.BSN_YN !== "Y")),
            l = b(() => {
              const M = E.value.sizeInfo?.DIV_CD;
              return M ? n.data.pdt_prn_cnt_info.filter(k => k.DIV_CD === M) : n.data.pdt_prn_cnt_info;
            }),
            u = b(() => n.data.pdt_exp_prn_cnt_info?.filter(M => M.MTRL_CD === E.value.meterialInfo?.MTRL_CD)),
            c = Xe({}),
            d = M => k => {
              c[M] = k;
            },
            p = ["THO_DFT_SQ", "THO_DFT_CL", "THO_DFT_EL", "THO_DFT_RC", "THO_GRA_FR"],
            f = b(() => {
              if (!GI.has(s.value)) return;
              const M = n.data.pdt_pcs_info.filter(W => W.PCS_CD.startsWith("THO_"));
              return M.length === 0 ? void 0 : M.reduce((W, Q) => (W[Q.WEB_PCS_DTL_GRP] || (W[Q.WEB_PCS_DTL_GRP] = []), W[Q.WEB_PCS_DTL_GRP].push(Q), W), {});
            }),
            v = H(f.value ? Object.keys(f.value)[0] : void 0),
            h = b(() => {
              const M = n.data.pdt_add_info[0];
              if (!rn(M[0])) return M.reduce((k, W) => (k[W.DIV_ATTB] || (k[W.DIV_ATTB] = []), k[W.DIV_ATTB].push(W), k), {});
            }),
            m = H(h.value ? Object.keys(h.value)[0] : void 0),
            D = H("2"),
            N = b(() => {
              const M = [...n.data.pdt_size_info];
              if (m.value && h.value) {
                const k = h.value[m.value].reduce((Q, ae) => Q.add(ae.DIV_SEQ), new Set()),
                  W = M.filter(Q => k.has(Q.DIV_SEQ));
                if (D.value === "N") {
                  const Q = m.value === "WAT_TRW";
                  return W.map(ae => ({
                    ...ae,
                    CUT_WDT: Q ? String(+ae.CUT_WDT + 2) : ae.CUT_WDT,
                    CUT_HGH: Q ? ae.CUT_HGH : String(+ae.CUT_HGH + 2),
                    WRK_WDT: Q ? String(+ae.WRK_WDT + 2) : ae.WRK_WDT,
                    WRK_HGH: Q ? ae.WRK_HGH : String(+ae.WRK_HGH + 2)
                  }));
                }
                return W;
              }
              return v.value ? M.filter(W => W.STICKER_TYPE === v.value?.slice(-2)) : M;
            }),
            I = b(() => {
              if (s.value !== "HLCLWAL") return null;
              const M = n.data.pdt_pcs_info.filter(k => k.PCS_CD === "HOL_DFT" || k.PCS_CD === "RIN_CUT");
              return M.length >= 2 ? M : null;
            }),
            w = b(() => {
              const M = I.value ? n.data.pdt_pcs_info.filter(k => k.PCS_CD !== "HOL_DFT" && k.PCS_CD !== "RIN_CUT") : n.data.pdt_pcs_info;
              return Pi(M, n.data.pdt_disable_pcs_info);
            }),
            A = H(),
            j = b(() => {
              if (!n.data.pdt_add_pcs_info?.length) return [];
              const M = E.value.meterialInfo?.MTRL_CD;
              return n.data.pdt_add_pcs_info.filter(k => k.MTRL_CD === M);
            }),
            B = b(() => {
              if (!n.data.pdt_add_pcs_info?.length) return [];
              const M = E.value.meterialInfo?.MTRL_CD,
                k = new Set(n.data.pdt_pcs_info.map(ae => ae.PCS_CD)),
                W = new Set(n.data.pdt_add_pcs_info.filter(ae => ae.MTRL_CD === M).map(ae => ae.PCS_CD));
              return [...new Set(n.data.pdt_add_pcs_info.map(ae => ae.PCS_CD))].filter(ae => !W.has(ae) && !k.has(ae));
            }),
            {
              uploadConfig: T,
              canEditOrdCnt: g
            } = da(n.widgetAttr),
            C = Ve(),
            S = b(() => (L.value.POST_PCS || []).some(k => Kh.has(k.PCS_CD))),
            {
              defaultOrderData: R,
              orderInfo: E,
              pcsInfo: L,
              updateOption: G,
              updatePcsOption: X,
              updatePostPcs: K
            } = fa(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: M => o("update", M)
              }
            });
          b(() => L.value.SUB_MTR?.find(M => M.PCS_CD === gi[s.value]));
          const de = b(() => Ti[n.data.pdt_base_info[0].PDT_CD] ? E.value.quantityInfo?.prnCnt || 1 : (E.value.quantityInfo?.ordCnt || 1) * (E.value.quantityInfo?.prnCnt || 1)),
            be = H(null),
            xe = Te("callbacks", {}),
            ee = Mo();
          return U(() => ee.orderData?.priceCalc.result.result_check_orderable, M => {
            if (!M) return;
            const {
              retCode: k,
              msg: W
            } = M;
            k !== 200 && W && (xe?.onCallMsg ? xe.onCallMsg("warn", W) : alert(W));
          }), U(() => be.value, M => {
            M && xe?.onError && xe.onError(M || "주문 위젯 에러 발생");
          }, {
            immediate: !0
          }), (M, k) => be.value ? (_(), V(ov, {
            key: 0,
            message: be.value
          }, null, 8, ["message"])) : (_(), O(q, {
            key: 1
          }, [I.value ? (_(), V(zI, {
            key: 0,
            options: I.value,
            onUpdate: k[0] || (k[0] = W => A.value = W)
          }, null, 8, ["options"])) : J("", !0), h.value ? (_(), V(nv, {
            key: 1,
            options: Object.values(h.value).map(W => W[0]),
            onUpdate: k[1] || (k[1] = W => {
              m.value = W.layout, D.value = W.foldingWay;
            })
          }, null, 8, ["options"])) : J("", !0), a.value.pageDirection.view_yn === "Y" ? (_(), V(Qh, {
            key: 2,
            "related-data": {
              sizeInfo: y(E).sizeInfo
            },
            onUpdate: k[2] || (k[2] = W => y(G)("pageDirection")(W))
          }, null, 8, ["related-data"])) : J("", !0), f.value ? (_(), V(VI, {
            key: 3,
            options: Object.keys(f.value).sort((W, Q) => p.indexOf(W) - p.indexOf(Q)),
            onUpdate: k[3] || (k[3] = W => v.value = W)
          }, null, 8, ["options"])) : J("", !0), re(ne(Ei, {
            options: i.value,
            default: y(R)?.meterialInfo,
            "reset-after-edit": y($h).has(M.data.pdt_base_info[0].PDT_CD) && y(C).isAfterEdit(),
            "show-extra": M.widgetAttr.able_paper_yn === "Y",
            "related-data": {},
            onUpdate: k[4] || (k[4] = W => y(G)("meterialInfo")(W))
          }, null, 8, ["options", "default", "reset-after-edit", "show-extra"]), [[Lt, a.value.paperSelect.view_yn === "Y"]]), re((_(), V(yi, {
            key: v.value,
            options: N.value,
            "base-info": M.data.pdt_base_info[0],
            default: y(R)?.size,
            "related-data": {
              shape: y(E).shapeInfo?.COD,
              sizeFromPostPcs: M.data.pdt_base_info[0].SIZE_PCS_USE ? c.sizeFromPostPcs : null,
              pageDirection: y(E).pageDirection?.COD,
              cuttingType: v.value
            },
            onUpdate: k[5] || (k[5] = W => y(G)("sizeInfo")(W)),
            onValidate: k[6] || (k[6] = W => y(G)("validation")(W)),
            "onUpdate:shape": k[7] || (k[7] = W => d("shapeFromSize")(W))
          }, null, 8, ["options", "base-info", "default", "related-data"])), [[Lt, a.value.sizeSelect.view_yn === "Y"]]), re(ne(Du, {
            options: M.data.pdt_dosu_info,
            default: y(R)?.dosuInfo,
            "related-data": {
              mtrlCd: y(E).meterialInfo?.MTRL_CD
            },
            onUpdate: k[8] || (k[8] = W => y(G)("dosuInfo")(W))
          }, null, 8, ["options", "default", "related-data"]), [[Lt, a.value.dosuSelect.view_yn === "Y" && M.data.pdt_dosu_info]]), a.value.quantityGroup.view_yn === "Y" ? (_(), V(dv, {
            key: 4,
            "can-edit-ord-cnt": y(g),
            options: l.value,
            "extra-options": u.value,
            default: y(R)?.quantityInfo,
            "related-data": {
              dosu: y(E).dosuInfo?.COD
            },
            "ream-yn": M.data.pdt_base_info[0].REAM_YN,
            onUpdate: k[9] || (k[9] = W => y(G)("quantityInfo")(W))
          }, null, 8, ["can-edit-ord-cnt", "options", "extra-options", "default", "related-data", "ream-yn"])) : J("", !0), a.value.subjectGroup.view_yn === "Y" ? (_(), V(Su, {
            key: 5,
            "is-biz-mem": y(r)?.bsn_yn === "Y",
            onUpdate: k[10] || (k[10] = W => y(G)("etcInfo")(W))
          }, null, 8, ["is-biz-mem"])) : J("", !0), ne(Di, {
            options: w.value.postPcs.hidden,
            "related-data": {
              shape: y(E).shapeInfo?.COD || c.shapeFromSize,
              mtrlCd: y(E).meterialInfo?.MTRL_CD,
              sizeInfo: y(E).sizeInfo,
              orderQty: de.value,
              cuttingType: v.value,
              paperLayout: m.value,
              foldingWay: D.value,
              hangType: A.value,
              mtrlLinkedPcs: M.data.pdt_base_info[0].SIZE_PCS_USE
            },
            "disabled-opts": w.value.disabled,
            onUpdate: k[11] || (k[11] = W => y(K)("hidden")(W))
          }, null, 8, ["options", "related-data", "disabled-opts"]), ne(Si, {
            options: [...w.value.postPcs.visible, ...j.value],
            "related-data": {
              mtrlCd: y(E).meterialInfo?.MTRL_CD,
              sizeInfo: y(E).sizeInfo,
              orderQty: de.value,
              cuttingType: v.value
            },
            "attb-opts": M.data.pdt_add_info[1],
            "disabled-opts": w.value.disabled,
            "disabled-add-pcs": B.value,
            onUpdate: k[12] || (k[12] = W => y(K)("visible")(W))
          }, null, 8, ["options", "related-data", "attb-opts", "disabled-opts", "disabled-add-pcs"]), ne(tv, {
            options: w.value.sub,
            "related-data": {
              orderQty: de.value,
              sizeInfo: y(E).sizeInfo,
              mtrlCd: y(E).meterialInfo?.MTRL_CD,
              pcsCodeForSize: M.data.pdt_base_info[0].SIZE_PCS_USE
            },
            onUpdate: k[13] || (k[13] = W => y(X)("SUB_MTR")(W)),
            "onUpdate:size": k[14] || (k[14] = W => d("sizeFromPostPcs")(W))
          }, null, 8, ["options", "related-data"]), ne(us, {
            "upload-config": y(T),
            "show-extra": M.widgetAttr.useTemplateDownload === "Y" && M.widgetAttr.usePDF === "Y",
            "allowed-ext": {
              types: ["application/pdf", "application/postscript"],
              names: "PDF, AI, EPS",
              desc: "파일업로드레이어안내-옵셋",
              note: "파일업로드후가공안내-옵셋"
            },
            "related-data": {
              cuttingType: v.value,
              hasPdfOnlyPostPcs: S.value
            },
            onUpload: k[15] || (k[15] = W => y(G)("fileUploadInfo")(W))
          }, null, 8, ["upload-config", "show-extra", "related-data"])], 64));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    YI = {
      key: 2,
      class: "summary"
    },
    QI = {
      class: "name"
    },
    qI = {
      class: "qty-price"
    },
    XI = {
      class: "counter"
    },
    ZI = ["onClick"],
    JI = ["value", "onChange"],
    eR = ["onClick"],
    tR = {
      class: "price-box"
    },
    nR = {
      class: "price"
    },
    oR = ["onClick"],
    sR = {
      key: 1
    },
    aR = {
      class: "qty-price"
    },
    iR = {
      class: "price-box"
    },
    rR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "Acc",
        props: {
          type: {
            default: "new"
          },
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = Te("callbacks", {}),
            r = b(() => jh[s.pdtCode] ? jh[s.pdtCode][s.pttCode || ""] : null),
            i = H("X"),
            l = H("X"),
            u = H("X"),
            c = Xe({}),
            d = Xe({});
          U(() => i.value, () => {
            u.value = "X";
          });
          const p = {
              key: "X",
              value: "X",
              name: F("선택하기")
            },
            f = () => {
              i.value = "X", l.value = "X", u.value = "X";
            },
            v = b(() => n.data.reduce((C, S) => (C[S.MTRL_GRP_GB] || (C[S.MTRL_GRP_GB] = []), C[S.MTRL_GRP_GB].push(S), C), {})),
            h = C => {
              const S = [p];
              return C ? C.GRP_TYPE === "MTRL_MULTI_GRP" ? (v.value[C.GRP_COD].forEach(R => {
                S.push({
                  key: R.MTRL_CD,
                  value: R.MTRL_CD,
                  name: R.MTRL_NM,
                  disabled: R.HIDE_YN === "Y"
                });
              }), S) : C.options ? (C.options.forEach(R => {
                S.push({
                  key: R.COD,
                  value: R.COD,
                  name: F(R.COD_NME)
                });
              }), S) : (i.value !== "X" && v.value[i.value].forEach(R => {
                S.push({
                  key: R.MTRL_CD,
                  value: R.MTRL_CD,
                  name: R.MTRL_NM,
                  disabled: R.HIDE_YN === "Y"
                });
              }), S) : (n.data.forEach(R => {
                S.push({
                  key: R.MTRL_CD,
                  value: R.MTRL_CD,
                  name: R.MTRL_NM,
                  disabled: R.HIDE_YN === "Y"
                });
              }), S);
            };
          function m(C) {
            return a?.onCallMsg ? a.onCallMsg("warn", C) : alert(C);
          }
          function D(C) {
            C && (d[C.MTRL_CD] ? d[C.MTRL_CD].QTY += C.INC_STEP : d[C.MTRL_CD] = {
              ...C,
              QTY: C.FIR_CNT
            });
          }
          function N(C) {
            d[C.MTRL_CD].QTY !== C.FIR_CNT && (d[C.MTRL_CD].QTY -= C.INC_STEP);
          }
          function I(C, S) {
            let E = +C.target.value || S.FIR_CNT;
            if (E < S.FIR_CNT && (E = S.FIR_CNT), S.RMD_QTY > 0 && E > S.RMD_QTY && (E = S.RMD_QTY), S.INC_STEP !== 1) {
              const L = E % S.INC_STEP;
              L !== 0 && (E = E - L);
            }
            d[S.MTRL_CD] = {
              ...d[S.MTRL_CD],
              QTY: E
            };
          }
          function w() {
            if (!r.value) {
              if (u.value === "X") return m(F("옵션미선택안내"));
              const C = n.data.find(S => S.MTRL_CD === u.value);
              return D(C), u.value = "X";
            }
            if (r.value.uiType === "MULTI") return rn(c) || Object.values(c).every(C => C === "X") ? m(F("옵션미선택안내")) : (Object.entries(c).forEach(([C, S]) => {
              const R = v.value[C].find(E => E.MTRL_CD === S);
              D(R);
            }), Object.keys(c).forEach(C => delete c[C]));
            if (r.value.uiType === "CASCADE") {
              const C = r.value.filters[0],
                S = r.value.filters.find(E => E.GRP_TYPE === "MTRL_SUB_GRP");
              if (i.value === "X") return m(F("옵션미선택안내상세", {
                OPTION: F(C.GRP_NME)
              }));
              if (!S) return;
              if (S.options) {
                if (l.value === "X") return m(F("옵션미선택안내상세", {
                  OPTION: F(S.GRP_NME)
                }));
                const E = v.value[i.value].find(L => {
                  if (L.MTRL_NM.includes(F(l.value))) return !0;
                  if (l.value === "NONE") return !0;
                });
                return D(E), f();
              }
              if (u.value === "X") return m(F("옵션미선택안내상세", {
                OPTION: F(S.GRP_NME)
              }));
              const R = v.value[i.value].find(E => E.MTRL_CD === u.value);
              return D(R), f();
            }
          }
          function A(C) {
            delete d[C.MTRL_CD];
          }
          U(() => d, C => {
            const S = Object.values(C).map(R => ({
              MTRL_CD: R.MTRL_CD,
              QTY: R.QTY,
              ATTB: "",
              MTRL_NME: R.MTRL_NM
            }));
            o("update", S);
          }, {
            deep: !0
          });
          const j = du(),
            B = b(() => j.getOrderData()?.priceCalc.result.result?.reduce((S, R) => (S[R.MTRL_CD] = +R.PRICE_MALL !== R.PRICE ? +R.PRICE_MALL : R.PRICE, S), {})),
            T = Xe(B.value || {});
          function g(C, S, R) {
            const L = performance.now(),
              G = X => {
                const K = Math.min((X - L) / 300, 1),
                  de = Math.floor(S + (R - S) * K);
                T[C] = de, K < 1 && requestAnimationFrame(G);
              };
            requestAnimationFrame(G);
          }
          return U(() => B.value, (C, S = {}) => {
            C && Object.keys(C).forEach(R => {
              const E = S[R] || 0,
                L = C[R] || 0;
              g(R, E, L);
            });
          }, {
            deep: !0
          }), (C, S) => (_(), O(q, null, [r.value ? (_(!0), O(q, {
            key: 0
          }, ce(r.value.filters, R => (_(), V(ve, {
            key: R.GRP_NME,
            title: `${y(F)("옵션")} - ${y(F)(R.GRP_NME)}`
          }, {
            default: fe(() => [R.GRP_TYPE === "MTRL_MULTI_GRP" ? (_(), V(rs, {
              key: 0,
              name: R.GRP_COD,
              default: c[R.GRP_COD] || "X",
              options: h(R),
              onSelect: E => c[R.GRP_COD] = E
            }, null, 8, ["name", "default", "options", "onSelect"])) : R.GRP_TYPE === "MTRL_GRP" ? (_(), V(rs, {
              key: 1,
              name: "material-group",
              options: h(R),
              default: i.value,
              onSelect: S[0] || (S[0] = E => i.value = E)
            }, null, 8, ["options", "default"])) : R.GRP_TYPE === "MTRL_SUB_GRP" && R.options ? (_(), V(rs, {
              key: 2,
              name: "material-sub-group",
              options: h(R),
              default: l.value,
              onSelect: S[1] || (S[1] = E => l.value = E)
            }, null, 8, ["options", "default"])) : (_(), V(rs, {
              key: 3,
              name: "material",
              options: h(R),
              default: u.value,
              onSelect: S[2] || (S[2] = E => u.value = E)
            }, null, 8, ["options", "default"]))]),
            _: 2
          }, 1032, ["title"]))), 128)) : (_(), V(ve, {
            key: 1,
            title: y(F)("옵션")
          }, {
            default: fe(() => [ne(rs, {
              name: "material",
              options: h(),
              default: u.value,
              onSelect: S[3] || (S[3] = R => u.value = R)
            }, null, 8, ["options", "default"])]),
            _: 1
          }, 8, ["title"])), P("button", {
            type: "button",
            class: "add-btn",
            onClick: w
          }, "+ " + Y(y(F)("옵션선택")), 1), y(rn)(d) ? J("", !0) : (_(), O("div", YI, [(_(!0), O(q, null, ce(Object.values(d), R => (_(), O("div", {
            key: R.MTRL_CD
          }, [B.value && B.value[R.MTRL_CD] ? (_(), O(q, {
            key: 0
          }, [P("p", QI, Y(R.MTRL_NM), 1), P("div", qI, [P("div", XI, [P("button", {
            type: "button",
            class: "btn minus",
            onClick: E => N(R)
          }, "-", 8, ZI), P("input", {
            class: "qty",
            value: R.QTY,
            name: "qty",
            onChange: E => I(E, R),
            type: "number"
          }, null, 40, JI), P("button", {
            type: "button",
            class: "btn plus",
            onClick: E => D(R)
          }, "+", 8, eR)]), P("div", tR, [P("span", nR, Y(T[R.MTRL_CD]?.toLocaleString()), 1), P("button", {
            type: "button",
            class: "delete-btn",
            onClick: E => A(R)
          }, "X", 8, oR)])])], 64)) : (_(), O("div", sR, [ne(Ye, {
            variant: "rounded",
            width: 110,
            height: 16
          }), P("div", aR, [ne(Ye, {
            variant: "rounded",
            width: 106,
            height: 28
          }), P("div", iR, [ne(Ye, {
            variant: "rounded",
            width: 50,
            height: 17
          }), ne(Ye, {
            variant: "circular",
            width: 16,
            height: 16
          })])])]))]))), 128))])), ne(ca)], 64));
        }
      }), [["__scopeId", "data-v-42242a32"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    lR = {
      class: "flex-row"
    },
    uR = {
      class: "notes"
    },
    cR = {
      class: "note"
    },
    dR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "ADC_PVC",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = r => {
              s.value = r.value;
            };
          return U(() => s.value, r => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: r,
              PCS_DTL_NM: n.data.name
            }]);
          }, {
            immediate: !0
          }), (r, i) => (_(), V(ve, {
            title: r.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", lR, [(_(!0), O(q, null, ce(r.data.options, l => (_(), V(Be, {
              key: l.key,
              data: {
                value: l.value,
                name: l.name,
                imgPath: `${r.data.subImgPath}_${l.value}`
              },
              active: s.value === l.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))]), P("div", uR, [P("p", cR, Y(r.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    fR = {
      class: "flex-row"
    },
    pR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BAK_STK",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", fR, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `BAK_STK_${u.value}`
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _R = {
      class: "flex-row -flow"
    },
    hR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BID_SIL",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.attbOptions[0].value),
            a = H(n.data.attbOptions[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: `${n.data.name}(${a.value})`,
              ATTB: i
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", _R, [(_(!0), O(q, null, ce(i.data.attbOptions, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: u.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    vR = {
      class: "flex-row"
    },
    mR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BIND_DIRECTION",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = [{
              name: "A",
              value: "Y",
              key: "A",
              imgPath: "BIND_DIRECTION_BPTOP_A"
            }, {
              name: "B",
              value: "N",
              key: "B",
              imgPath: "BIND_DIRECTION_BPTOP_B"
            }],
            r = b(() => n.relatedData.sizeInfo.workSize),
            i = b(() => ev.has(s.pdtCode) ? "BPLFT" : r.value.width > r.value.height ? "BPTOP" : "BPLFT"),
            l = H(a[0].value),
            u = b(() => ({
              main: i.value,
              sub: l.value
            }));
          return U(() => u.value, c => {
            const d = n.data.options.find(p => p.value === c.main)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: c.main,
              PCS_DTL_NM: d?.PCS_DTL_NM,
              ...(i.value === "BPTOP" ? {
                BACK_ROT_YN: c.sub
              } : {})
            }]);
          }, {
            immediate: !0
          }), (c, d) => (_(), V(ve, {
            title: c.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", vR, [(_(!0), O(q, null, ce(c.data.options, p => (_(), V(Be, {
              key: p.key,
              data: {
                value: p.value,
                name: p.name,
                imgPath: `${c.data.subImgPath}_${p.value}`
              },
              "force-hidden": i.value !== p.value,
              active: i.value === p.value
            }, null, 8, ["data", "force-hidden", "active"]))), 128)), (_(), O(q, null, ce(a, p => ne(Be, {
              key: p.key,
              data: {
                value: p.value,
                name: p.name,
                imgPath: p.imgPath
              },
              "force-hidden": i.value === "BPLFT",
              active: l.value === p.value,
              onSelect: d[0] || (d[0] = f => l.value = f.value)
            }, null, 8, ["data", "force-hidden", "active"])), 64))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    CR = {
      class: "row"
    },
    TR = ["value"],
    gR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "BND_LOC",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0]?.value ?? ""),
            a = H(1),
            r = () => {
              (!a.value || a.value < 1) && (a.value = 1);
            };
          return U(() => [s.value, a.value], ([i, l]) => {
            const u = n.data.options.find(c => c.value === i);
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: u?.name ?? n.data.name,
              ATTB: l
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", CR, [re(P("select", {
              "onUpdate:modelValue": l[0] || (l[0] = u => s.value = u),
              class: "basic-select",
              name: "bnd-loc"
            }, [(_(!0), O(q, null, ce(i.data.options, u => (_(), O("option", {
              key: u.value,
              value: u.value
            }, Y(u.name), 9, TR))), 128))], 512), [[Ke, s.value]]), re(P("input", {
              "onUpdate:modelValue": l[1] || (l[1] = u => a.value = u),
              type: "number",
              class: "basic-input",
              id: "bndLocQty",
              min: "1",
              onFocusout: r
            }, null, 544), [[dt, a.value]])])]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-ba809112"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    yR = {
      class: "flex-row"
    },
    DR = {
      class: "notes"
    },
    SR = {
      class: "note"
    },
    PR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BON_PAP",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: a.value
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", yR, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: i.data.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))]), P("div", DR, [P("p", SR, Y(i.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    bR = {
      class: "flex-row"
    },
    OR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BON_SHT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", bR, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${i.data.subImgPath}_${u.value}`
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    ER = {
      class: "flex-row -flow"
    },
    IR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "BTN_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0]?.value);
          return U(() => s.value, a => {
            const r = n.data.options.find(i => i.value === a);
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: a,
              PCS_DTL_NM: r?.name
            }]);
          }, {
            immediate: !0
          }), (a, r) => (_(), V(ve, {
            title: a.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", ER, [(_(!0), O(q, null, ce(a.data.options, i => (_(), V(Be, {
              key: i.key,
              data: {
                value: i.value,
                name: i.name,
                imgPath: `BTN_DFT_${i.value}`,
                subImgPath: a.data.subImgPath
              },
              active: s.value === i.value,
              onSelect: r[0] || (r[0] = l => s.value = l.value)
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    RR = {
      class: "flex-row"
    },
    NR = ["value"],
    AR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "CDL_DFT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => {
              const u = n.relatedData.sizeInfo?.DIV_SEQ;
              return !u || n.data.options[0]?.extra?.DIV_SEQ === 0 ? n.data.options : n.data.options.filter(c => c.extra.DIV_SEQ === u);
            }),
            a = H(s.value[0]?.value ?? ""),
            r = b(() => s.value.find(u => u.value === a.value)?.extra?.QTY_INPUT_YN === "Y"),
            i = H(n.relatedData.orderQty ?? 1);
          U(() => n.relatedData.sizeInfo?.DIV_SEQ, () => {
            a.value = s.value[0]?.value ?? "";
          });
          const l = b(() => s.value.find(u => u.value === a.value)?.name ?? "");
          return U(() => [a.value, r.value ? i.value : n.relatedData.orderQty], ([u, c]) => {
            u && o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: u,
              PCS_DTL_NM: `${n.data.name}(${l.value})`,
              ATTB: c
            }]);
          }, {
            immediate: !0
          }), (u, c) => (_(), V(ve, {
            title: u.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", RR, [re(P("select", {
              "onUpdate:modelValue": c[0] || (c[0] = d => a.value = d),
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(s.value, d => (_(), O("option", {
              key: d.value,
              value: d.value
            }, Y(d.name), 9, NR))), 128))], 512), [[Ke, a.value]]), r.value ? re((_(), O("input", {
              key: 0,
              "onUpdate:modelValue": c[1] || (c[1] = d => i.value = d),
              type: "number",
              min: "1",
              class: "basic-input"
            }, null, 512)), [[dt, i.value, void 0, {
              number: !0
            }]]) : J("", !0)])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    MR = ["value"],
    wR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "CLD_STD",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = Te("productCode", {
              pdtCode: ""
            }),
            s = b(() => {
              if (o.pdtCode !== "HLCLSTD") return n.data.options;
              const i = n.relatedData?.sizeInfo?.cutSize;
              return i ? n.data.options.filter(l => Number(l.extra?.CUT_WDT) === i.width && Number(l.extra?.CUT_HGH) === i.height) : n.data.options;
            }),
            a = t,
            r = H(n.data.options[0]?.value);
          return U(() => s.value, i => {
            i.length > 0 && !i.find(l => l.value === r.value) && (r.value = i[0].value);
          }, {
            immediate: !0
          }), U(() => r.value, i => {
            const l = s.value.find(u => u.value === i);
            a("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: l?.name
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [re(P("select", {
              "onUpdate:modelValue": l[0] || (l[0] = u => r.value = u),
              name: "CLD_STD",
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(s.value, u => (_(), O("option", {
              key: u.key,
              value: u.value
            }, Y(y(F)(u.name)), 9, MR))), 128))], 512), [[Ke, r.value]])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    LR = {
      class: "grid-group"
    },
    kR = {
      class: "flex-row -flow"
    },
    $R = {
      key: 0,
      class: "note notes"
    },
    FR = {
      key: 1,
      class: "notes"
    },
    UR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "COT_DFT",
        props: {
          data: {},
          disabledOptions: {},
          extraNotices: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = _t(),
            r = {
              S: "단면",
              D: "양면",
              TCMA: "무광",
              TCGL: "유광",
              TCEB: "엠보",
              TCSL: "벨벳",
              TCHL: "홀로그램 무지개",
              TCSD: "홀로그램 모래알",
              TCSS: "홀로그램 잔모래",
              TCST: "홀로그램 별빛"
            },
            i = [{
              mtrl: "RXSNO250",
              coating: "TCGL",
              excludeProducts: ["NCDFDFT", "NCDFQLT", "NCDFFLD", "NCDFFOI", "NCDFCPN", "NCCDDFT", "NCCDQLT", "NCCDFOI", "NCCDPHO"]
            }],
            l = [{
              mtrl: D => D.includes("SNO"),
              dtlCd: "TCMAS",
              includeProducts: D => D.startsWith("NC") || D.startsWith("HL") || D.startsWith("SK")
            }, {
              mtrl: D => D.includes("SNO"),
              dtlCd: "TCGLS",
              includeProducts: D => D.startsWith("NC") || D.startsWith("HL") || D.startsWith("SK")
            }],
            u = b(() => {
              const D = new Set(n.disabledOptions ?? []),
                N = g => typeof g.mtrl == "function" ? g.mtrl(n.relatedData.mtrlCd) : g.mtrl === n.relatedData.mtrlCd,
                I = new Set(i.filter(g => N(g) && !g.excludeProducts?.includes(s.pdtCode)).map(g => g.coating)),
                w = new Set(l.filter(g => N(g) && (!g.includeProducts || g.includeProducts(s.pdtCode))).map(g => g.dtlCd)),
                A = {},
                j = {},
                B = new Map(),
                T = new Map();
              for (const g of n.data.options) {
                const C = g.value.slice(-1),
                  S = g.value.slice(0, 4);
                D.has(g.value) || I.has(S) || w.has(g.value) ? (B.has(S) || B.set(S, !1), T.has(C) || T.set(C, !1)) : (B.set(S, !0), T.set(C, !0));
              }
              for (const g of n.data.options) {
                const C = g.value.slice(-1),
                  S = g.value.slice(0, 4);
                A[C] || (A[C] = {
                  id: `COT_DFT/${C}`,
                  name: `COT_DFT/${C}`,
                  label: r[C],
                  value: C,
                  disabled: !T.get(C)
                }), j[S] || (j[S] = {
                  ...g,
                  value: S,
                  name: a.locale === "ko" ? r[S] : g.name,
                  disabled: !B.get(S)
                });
              }
              return {
                sides: A,
                coatings: j
              };
            }),
            c = H(n.data.options[0].value.slice(-1)),
            d = H(n.data.options[0].value.slice(0, 4)),
            p = b(() => s.pdtCode.startsWith("BT") && d.value === "TCMA"),
            f = b(() => d.value + c.value),
            v = b(() => Array.isArray(n.disabledOptions) && n.disabledOptions.length === 0),
            h = {
              TCMA: "COT_DFT_MA_BOOK",
              TCGL: "COT_DFT_GL_BOOK",
              TCEB: "COT_DFT_EB_BOOK",
              TCSL: "COT_DFT_SL_BOOK"
            },
            m = b(() => s.pdtCode.startsWith("PRBK") ? h : null);
          return U(() => f.value, D => {
            if (v.value) return;
            const N = n.data.options.find(I => I.value === D)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: D,
              PCS_DTL_NM: N?.PCS_DTL_NM
            }]);
          }, {
            immediate: !0
          }), U(() => n.disabledOptions, D => {
            if (D) {
              if (v.value) return o("update", []);
              if (u.value.sides[c.value]?.disabled) {
                const N = Object.values(u.value.sides).find(I => !I.disabled);
                N && (c.value = N.value);
              }
              if (D.includes(d.value + c.value)) {
                const N = Object.values(u.value.coatings).find(I => !I.disabled);
                N && (d.value = N.value);
              }
            }
          }, {
            immediate: !0
          }), U(() => n.relatedData.mtrlCd, () => {
            if (v.value) return o("update", []);
            const D = A => typeof A.mtrl == "function" ? A.mtrl(n.relatedData.mtrlCd) : A.mtrl === n.relatedData.mtrlCd,
              N = new Set(i.filter(A => D(A) && !A.excludeProducts?.includes(s.pdtCode)).map(A => A.coating)),
              I = new Set(l.filter(A => D(A)).map(A => A.dtlCd));
            if (u.value.sides[c.value]?.disabled) {
              const A = Object.values(u.value.sides).find(j => !j.disabled);
              A && (c.value = A.value);
            }
            const w = d.value + c.value;
            if (N.has(d.value) || I.has(w)) {
              const A = Object.values(u.value.coatings).find(j => !j.disabled);
              A && (d.value = A.value);
            }
          }, {
            immediate: !0
          }), (D, N) => {
            const I = it("dompurify-html");
            return _(), V(ve, {
              title: D.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", LR, [(_(), V(Rn, {
                key: c.value,
                options: Object.values(u.value.sides),
                "default-checked": c.value,
                onChange: N[0] || (N[0] = w => c.value = w.value)
              }, null, 8, ["options", "default-checked"])), P("div", kR, [(_(!0), O(q, null, ce(Object.values(u.value.coatings), w => (_(), V(Be, {
                key: w.key,
                data: {
                  value: w.value,
                  name: w.name,
                  imgPath: m.value && m.value[w.value] ? m.value[w.value] : `COT_DFT_${w.value.slice(2, 4)}`,
                  subImgPath: D.data.subImgPath
                },
                disabled: w.disabled,
                "disabled-styling": w.disabled,
                active: d.value === w.value,
                onSelect: N[1] || (N[1] = A => d.value = A.value)
              }, null, 8, ["data", "disabled", "disabled-styling", "active"]))), 128))])]), p.value ? (_(), O("p", $R, Y(y(F)("무광코팅-개별포장-안내")), 1)) : J("", !0), D.data.options[0]?.extra?.NOTICE?.length || D.extraNotices?.length ? (_(), O("div", FR, [(_(!0), O(q, null, ce(D.data.options[0]?.extra?.NOTICE ?? [], (w, A) => re((_(), O("p", {
                key: `notice-${A}`,
                class: "note gap"
              })), [[I, w]])), 128)), (_(!0), O(q, null, ce(D.extraNotices ?? [], (w, A) => re((_(), O("p", {
                key: `extra-notice-${A}`,
                class: "note gap"
              })), [[I, w]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    BR = {
      class: "flex-row"
    },
    xR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "COT_SEG",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(`${n.data.name}(${n.data.options[0].name})`),
            r = i => {
              s.value = i.value, a.value = `${n.data.name}(${i.name})`;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: a.value
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", BR, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${i.data.subImgPath}_${u.value}`,
                subImgPath: i.data.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    HR = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "CPN_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t;
          return U(() => n.data, s => {
            o("update", [{
              PCS_CD: s.value,
              PCS_DTL_CD: s.options[0]?.value ?? "",
              PCS_DTL_NM: s.options[0]?.name ?? s.name
            }]);
          }, {
            immediate: !0
          }), (s, a) => (_(), V(ve, {
            title: s.data.name,
            underline: ""
          }, null, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    GR = ["src"],
    WR = oe({
      __name: "Info",
      props: {
        color: {}
      },
      setup(e) {
        const t = e,
          n = b(() => {
            const o = t.color === "red" ? "/ko/order_aside_icon_noteRed.svg" : "/ko/packaging_icon_mark.svg";
            return `${ut}${o}`;
          });
        return (o, s) => (_(), O("img", {
          src: n.value,
          alt: "주의사항아이콘",
          class: "note-icon"
        }, null, 8, GR));
      }
    }),
    VR = {
      class: "segmented-option"
    },
    jR = ["disabled", "onClick"],
    zR = Ne(oe({
      __name: "SegmentedOption",
      props: {
        options: {},
        default: {}
      },
      emits: ["select"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(n.default ?? n.options[0]?.value);
        return U(() => n.default, a => {
          a !== void 0 && (s.value = a);
        }), U(() => s.value, a => {
          o("select", a);
        }, {
          immediate: !0
        }), (a, r) => (_(), O("div", VR, [(_(!0), O(q, null, ce(a.options, i => (_(), O("button", {
          type: "button",
          key: i.key,
          class: $e(["pill", {
            active: !i.disabled && s.value === i.value
          }]),
          disabled: i.disabled,
          onClick: l => s.value = i.value
        }, Y(i.name), 11, jR))), 128))]));
      }
    }), [["__scopeId", "data-v-40f88c4d"]]),
    KR = {
      class: "flex-row"
    },
    YR = {
      key: 0,
      class: "notes"
    },
    QR = {
      key: 1,
      class: "notes"
    },
    qR = {
      class: "note flex"
    },
    XR = {
      class: "tooltip"
    },
    ZR = ["src"],
    JR = {
      key: 2,
      class: "cutting-guide"
    },
    eN = {
      class: "text"
    },
    tN = {
      class: "layout-wrapper"
    },
    nN = {
      key: 0,
      class: "cutting-layout individual"
    },
    oN = {
      class: "confirm-box"
    },
    sN = {
      class: "note"
    },
    aN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "CUT_DFT",
        props: {
          data: {},
          disabledOptions: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = new Set(["SKTHDFT"]),
            a = Mo(),
            r = _t(),
            i = Te("productCode", {
              pdtCode: ""
            }),
            l = b(() => s.has(i.pdtCode)),
            u = H(n.data.options[0]),
            c = b(() => n.data.options.find(A => A.value === "DFITM")),
            d = b(() => n.relatedData.orderQty),
            p = b(() => n.relatedData.cuttingType),
            f = b(() => n.relatedData.sizeInfo);
          U(() => d.value, A => {
            u.value.value === "DFGRP" && A < 1e3 && c.value && (u.value = c.value);
          }), U(() => p.value, A => {
            A === "THO_GRA_FR" && c.value && (u.value = c.value);
          }, {
            immediate: !0
          });
          const v = b(() => {
              const A = a.getOrderData();
              if (!A) return;
              const {
                result_sticker_attb: j
              } = A.priceCalc.result;
              if (!j) return;
              const {
                retCode: B,
                result: T
              } = j;
              if (B === 200) return T.map(g => ({
                key: g.value,
                name: g.name,
                value: g.value,
                data: g.data
              }));
            }),
            h = H(v.value ? v.value[0].value : void 0),
            m = b(() => v.value?.find(A => A.value === h.value)),
            D = b(() => {
              if (!m.value) return {
                columns: "",
                rows: "",
                gap: 0
              };
              const A = m.value.data.wdt,
                j = m.value.data.hgh,
                {
                  width: B,
                  height: T
                } = f.value.cutSize,
                g = B / T,
                C = 170,
                S = 140,
                R = 3,
                E = R * (A - 1),
                L = R * (j - 1),
                G = (S - L) / j,
                X = G * g;
              let K = X,
                de = G;
              X * A + E > C && (K = (C - E) / A, de = K / g);
              const be = Array(A).fill(`${K}px`).join(" "),
                xe = Array(j).fill(`${de}px`).join(" ");
              return {
                columns: be,
                rows: xe,
                gap: R
              };
            }),
            N = b(() => {
              const {
                  cutSize: A
                } = f.value,
                j = A.width / A.height,
                B = 160,
                T = 130,
                g = T * j;
              let C = 0;
              return B < g && (C = B / j), C > 0 ? {
                width: B,
                height: C
              } : {
                width: g,
                height: T
              };
            }),
            I = b(() => n.relatedData?.orderQty < 1e3 || p.value === "THO_GRA_FR" || !v.value);
          U(() => h.value, (A, j) => {
            A !== j && a.setUserDoubleConfirmed(!1);
          }), U(() => u.value, (A, j) => {
            A.value !== j.value && a.setUserDoubleConfirmed(!1);
          }), U(() => v.value, A => {
            !A && c.value && (u.value = c.value);
          });
          const w = b(() => {
            const A = u.value.value;
            return A === "DFGRP" ? m.value ? {
              PCS_CD: n.data.value,
              PCS_DTL_CD: A,
              PCS_DTL_NM: `${u.value.name}(${m.value.value})`,
              ATTB: m.value.data.wdt,
              ATTB_2: m.value.data.hgh
            } : void 0 : {
              PCS_CD: n.data.value,
              PCS_DTL_CD: A,
              PCS_DTL_NM: u.value.name,
              ATTB: "",
              ATTB_2: ""
            };
          });
          return U(() => [u.value, h.value], () => {
            w.value && o("update", [w.value]);
          }, {
            immediate: !0
          }), (A, j) => {
            const B = it("dompurify-html");
            return _(), V(ve, {
              title: A.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", KR, [(_(!0), O(q, null, ce(A.data.options, T => (_(), V(Be, {
                key: T.key,
                data: {
                  value: T.value,
                  name: T.name,
                  imgPath: `${A.data.value}_${T.value}`
                },
                active: u.value.value === T.value,
                disabled: T.value === "DFGRP" && I.value,
                "disabled-styling": T.value === "DFGRP" && I.value,
                onSelect: g => u.value = T
              }, null, 8, ["data", "active", "disabled", "disabled-styling", "onSelect"]))), 128))]), A.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", YR, [(_(!0), O(q, null, ce(A.data.options[0].extra.NOTICE, (T, g) => re((_(), O("p", {
                key: `notice-${g}`,
                class: "note"
              })), [[B, T]])), 128))])) : J("", !0), l.value ? (_(), O("div", QR, [P("p", qR, [ne(WR, {
                color: "red"
              }), yo(" " + Y(y(F)("재단옵션안내")), 1)]), P("div", XR, [P("img", {
                src: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/${y(r)?.locale}/item/detail_offset_st_free_cutting.png`,
                alt: ""
              }, null, 8, ZR)])])) : J("", !0), l.value ? (_(), O("div", JR, [P("span", eN, Y(y(F)("재단가이드")), 1), u.value.value === "DFGRP" && v.value ? (_(), V(zR, {
                key: 0,
                options: v.value,
                default: v.value[0].value,
                onSelect: j[0] || (j[0] = T => h.value = T)
              }, null, 8, ["options", "default"])) : J("", !0), P("div", tN, [u.value.value === "DFITM" ? (_(), O("div", nN, [P("div", {
                class: $e(["cutting-line", A.relatedData.cuttingType]),
                style: mt({
                  width: `${N.value.width}px`,
                  height: `${N.value.height}px`
                })
              }, null, 6)])) : m.value ? (_(), O("div", {
                key: 1,
                class: "cutting-layout bundle",
                style: mt({
                  gridTemplateColumns: D.value.columns,
                  gridTemplateRows: D.value.rows,
                  gap: `${D.value.gap}px`
                })
              }, [(_(!0), O(q, null, ce(m.value.data.wdt * m.value.data.hgh, T => (_(), O("div", {
                key: T,
                class: $e(["cutting-line", A.relatedData.cuttingType]),
                style: mt({
                  aspectRatio: `${f.value.cutSize.width} / ${f.value.cutSize.height}`
                })
              }, null, 6))), 128))], 4)) : J("", !0), P("div", oN, [re(P("p", sN, null, 512), [[B, y(F)("후가공-재단가이드", {
                METHOD: u.value.name
              })]]), P("button", {
                type: "button",
                class: $e(["confirm-btn", {
                  confirmed: y(a).isUserDoubleConfirmed
                }]),
                onClick: j[1] || (j[1] = () => y(a).setUserDoubleConfirmed(!y(a).isUserDoubleConfirmed))
              }, Y(y(F)("고객확인")), 3)])])])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      }), [["__scopeId", "data-v-91326257"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    iN = ["value"],
    rN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "CVR_INN",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value);
          return U(() => s.value, a => {
            const r = n.data.options.find(i => i.value === a);
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: a,
              PCS_DTL_NM: `${n.data.name}(${r?.name})`
            }]);
          }, {
            immediate: !0
          }), (a, r) => (_(), V(ve, {
            title: a.data.name,
            underline: ""
          }, {
            default: fe(() => [re(P("select", {
              "onUpdate:modelValue": r[0] || (r[0] = i => s.value = i),
              name: "CVR_INN",
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(a.data.options, i => (_(), O("option", {
              key: i.key,
              value: i.value
            }, Y(y(F)(i.name)), 9, iN))), 128))], 512), [[Ke, s.value]])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    lN = {
      class: "flex-row"
    },
    uN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "CVR_SWN",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: a.value
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", lN, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${i.data.subImgPath}_${u.value}`,
                subImgPath: i.data.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    cN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "DIR_MTR",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.data.options.map(i => ({
              id: i.value,
              name: n.data.value,
              label: i.name,
              value: i.value
            }))),
            a = H(s.value[0]),
            r = b(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: a.value.value,
              PCS_DTL_NM: a.value.label,
              ATTB: n.relatedData.orderQty
            }));
          return U(() => r.value, (i, l) => {
            l?.ATTB === i.ATTB && l?.PCS_DTL_CD === i.PCS_DTL_CD || o("update", [i]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [ne(Rn, {
              options: s.value,
              "default-checked": s.value[0].value,
              onChange: l[0] || (l[0] = u => a.value = u)
            }, null, 8, ["options", "default-checked"])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    dN = {
      class: "notes"
    },
    fN = {
      class: "note"
    },
    pN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "END_PAP",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = {
              CLYEL: "#fdeec5",
              CLMIN: "#d5edea",
              CLWHT: "#ffffff",
              CLPPL: "#e0def0",
              CLPIN: "#f6e6f1",
              CLAPR: "#fde7dc",
              CLGRN: "#e4f2e8",
              CLBLU: "#adccec",
              CLSKY: "#bae5fb",
              CLGRY: "#ededee"
            },
            a = b(() => n.data.options.map(i => ({
              COD: i.value,
              COD_NME: i.name,
              HEX: s[i.value]
            }))),
            r = H(a.value[0]);
          return U(() => r.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i.COD,
              PCS_DTL_NM: `${n.data.name}(${i.COD_NME})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [ne(iv, {
              options: a.value,
              onSelect: l[0] || (l[0] = u => r.value = u)
            }, null, 8, ["options"]), P("div", dN, [P("p", fN, Y(i.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _N = {
      class: "grid-group"
    },
    hN = {
      class: "flex-row"
    },
    vN = {
      class: "flex-row -flow"
    },
    mN = {
      key: 0,
      class: "fld-notice"
    },
    CN = ["disabled"],
    TN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "FLD_DFT",
        props: {
          data: {},
          disabledOptions: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t;
          Te("productCode", {
            pdtCode: ""
          });
          const s = _t(),
            a = [{
              name: F("가로방향접지"),
              value: "DIR_HOR",
              imgPath: "FLD_DFT_H"
            }, {
              name: F("세로방향접지"),
              value: "DIR_VER",
              imgPath: "FLD_DFT_V"
            }],
            r = H(a[1]),
            i = H(n.data.options[0]),
            l = b(() => [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i.value.value,
              PCS_DTL_NM: `${i.value.name}(${r.value.name})`,
              ATTB: r.value.value,
              ATTB_2: "",
              ATTB_3: ""
            }]),
            u = b(() => Array.isArray(n.disabledOptions) && n.disabledOptions.length === 0);
          U(() => l.value, v => {
            u.value || o("update", v);
          }, {
            immediate: !0
          }), U(() => n.disabledOptions, v => {
            if (v) {
              if (u.value) return o("update", []);
              if (v.includes(i.value.value)) {
                const h = n.data.options.find(m => !v.includes(m.value));
                h && (i.value = h);
              }
            }
          }, {
            immediate: !0
          });
          const c = new Set(["FO004", "FO005"]),
            d = `${jn}/ko/guide2/view/3/89`,
            p = H(!1);
          async function f() {
            const v = i.value.value;
            if (c.has(v)) {
              alert(F("접지가이드불가"));
              return;
            }
            if (v === "FO008") {
              confirm(`4단접지는 RED Guide>후가공 가이드>인쇄 후가공 가이드>접지 4단접지부분 참고 해주세요.
[확인]시 가이드로 이동합니다.`) && window.open(d, "_blank");
              return;
            }
            const h = n.relatedData?.sizeInfo;
            if (!h) return;
            const m = (h.workSize.width - h.cutSize.width) / 2,
              D = n.relatedData?.dosuInfo?.COD === "SID_D" ? "Y" : "N",
              N = new Date(),
              I = `${N.getFullYear()}${String(N.getMonth() + 1).padStart(2, "0")}${String(N.getDate()).padStart(2, "0")}${String(N.getHours()).padStart(2, "0")}${String(N.getMinutes()).padStart(2, "0")}${String(N.getSeconds()).padStart(2, "0")}`,
              w = `레드프린팅_${i.value.name}_${r.value.name}_${I}.pdf`;
            p.value = !0, await tP({
              lang: s.locale,
              cut_wdt: h.cutSize.width,
              cut_hgh: h.cutSize.height,
              bleed: m,
              folding_type: v,
              folding_direction: r.value.value === "DIR_HOR" ? "H" : "V",
              is_duplex: D,
              fileName: w
            }), p.value = !1;
          }
          return (v, h) => {
            const m = it("dompurify-html");
            return _(), V(ve, {
              title: v.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", _N, [P("div", hN, [(_(), O(q, null, ce(a, D => ne(Be, {
                key: D.value,
                data: {
                  value: D.value,
                  name: D.name,
                  imgPath: D.imgPath
                },
                active: r.value.value === D.value,
                onSelect: h[0] || (h[0] = N => {
                  N.value !== r.value.value && (r.value = N);
                })
              }, null, 8, ["data", "active"])), 64))]), P("div", vN, [(_(!0), O(q, null, ce(v.data.options, D => (_(), V(Be, {
                key: D.key,
                data: {
                  value: D.value,
                  name: D.name,
                  imgPath: `${v.data.value}_${D.value}`
                },
                active: i.value.value === D.value,
                onSelect: h[1] || (h[1] = N => {
                  N.value !== i.value.value && (i.value = N);
                })
              }, null, 8, ["data", "active"]))), 128))]), v.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", mN, [(_(!0), O(q, null, ce(v.data.options[0].extra.NOTICE, (D, N) => re((_(), O("p", {
                key: `notice-${N}`
              })), [[m, D]])), 128))])) : J("", !0), P("button", {
                class: "fld-download-btn",
                disabled: p.value,
                onClick: f
              }, Y(y(F)("접지가이드다운로드")), 9, CN)])]),
              _: 1
            }, 8, ["title"]);
          };
        }
      }), [["__scopeId", "data-v-68d33b7a"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    gN = {
      class: "extra-input"
    },
    yN = {
      for: "holeQty",
      class: "subject"
    },
    DN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "HOL_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => [3, 4, 4.5, 5, 6, 7].map(u => ({
              id: `hole-${u}`,
              value: u,
              name: "HOL_DFT",
              label: `${u}mm`
            }))),
            a = H(1),
            r = () => {
              if (a.value <= 0) return a.value = 1;
            },
            i = H(s.value[0]),
            l = b(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: "DFXXX",
              PCS_DTL_NM: n.data.name,
              ATTB: a.value,
              ATTB_2: i.value.value
            }));
          return U(() => l.value, u => {
            o("update", [u]);
          }, {
            immediate: !0
          }), (u, c) => (_(), V(ve, {
            title: u.data.name,
            underline: ""
          }, {
            default: fe(() => [ne(Rn, {
              options: s.value,
              "default-checked": s.value[0].value,
              onChange: c[0] || (c[0] = d => i.value = d)
            }, null, 8, ["options", "default-checked"]), P("div", gN, [P("label", yN, Y(y(F)("개수")), 1), re(P("input", {
              "onUpdate:modelValue": c[1] || (c[1] = d => a.value = d),
              type: "number",
              class: "basic-input",
              id: "holeQty",
              min: "1",
              max: "4",
              onFocusout: r
            }, null, 544), [[dt, a.value]])])]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-24156180"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    SN = {
      class: "flex-row"
    },
    PN = ["value", "disabled"],
    bN = ["value"],
    ON = {
      key: 0,
      class: "notes"
    },
    EN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "INN_DFT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = b(() => n.data.options[0].extra.QTY_INPUT_YN === "Y"),
            r = b(() => {
              if (s.pdtCode === "GSNTMIS" && u.value) return n.data.options.map(f => ({
                ...f,
                disabled: f.value !== "INNON"
              }));
              if (s.pdtCode === "GSNTBND") {
                const f = n.relatedData.sizeInfo?.DIV_SEQ;
                return n.data.options.filter(v => v.extra.DIV_SEQ === f);
              }
              return n.data.options;
            }),
            i = H(n.data.options[0].value),
            l = b(() => r.value.find(f => f.value === i.value)),
            u = b(() => n.relatedData.sizeInfo?.DIV_SEQ === 0 || n.relatedData.sizeInfo?.DIV_NM === "사이즈직접입력"),
            c = H(1),
            d = () => {
              if (c.value < 1) return c.value = 1;
            };
          U(() => u.value, f => {
            f && (i.value = "INNON");
          }), U(() => n.relatedData.sizeInfo?.DIV_SEQ, () => {
            if (s.pdtCode !== "GSNTBND") return;
            const f = r.value[0];
            f && (i.value = f.value);
          });
          const p = b(() => [{
            PCS_CD: n.data.value,
            PCS_DTL_CD: i.value,
            PCS_DTL_NM: `${n.data.name}(${l.value?.name})`,
            ATTB: a.value ? c.value : n.relatedData.orderQty,
            ATTB_2: "",
            ATTB_3: ""
          }]);
          return U(() => p.value, f => {
            o("update", f);
          }, {
            immediate: !0
          }), (f, v) => {
            const h = it("dompurify-html");
            return _(), V(ve, {
              title: f.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", SN, [re(P("select", {
                "onUpdate:modelValue": v[0] || (v[0] = m => i.value = m),
                name: "INN_DFT",
                class: "basic-select"
              }, [(_(!0), O(q, null, ce(r.value, m => (_(), O("option", {
                key: m.key,
                value: m.value,
                disabled: m.disabled
              }, Y(y(F)(m.name)), 9, PN))), 128))], 512), [[Ke, i.value]]), a.value ? re((_(), O("input", {
                key: 0,
                "onUpdate:modelValue": v[1] || (v[1] = m => c.value = m),
                type: "number",
                id: "qty",
                class: "basic-input",
                onFocusout: d
              }, null, 544)), [[dt, c.value]]) : (_(), O("input", {
                key: 1,
                type: "number",
                id: "qty",
                disabled: !0,
                value: f.relatedData.orderQty,
                class: "basic-input"
              }, null, 8, bN))]), l.value ? (_(), O("div", ON, [(_(!0), O(q, null, ce(l.value.extra.NOTICE, (m, D) => re((_(), O("p", {
                key: `notice-${D}`,
                class: "note"
              })), [[h, m]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    IN = {
      class: "flex-row"
    },
    RN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "INS_COT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: a.value
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", IN, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${i.data.subImgPath}_${u.value}`,
                subImgPath: i.data.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    NN = {
      class: "flex-row"
    },
    AN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "LAB_FBR",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: a.value
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", NN, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${i.data.subImgPath}_${u.value}`,
                subImgPath: i.data.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    MN = {
      class: "flex-row"
    },
    wN = {
      key: 0,
      class: "notes"
    },
    LN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "LAM_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => {
            const u = it("dompurify-html");
            return _(), V(ve, {
              title: i.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", MN, [(_(!0), O(q, null, ce(i.data.options, c => (_(), V(Be, {
                key: c.key,
                data: {
                  value: c.value,
                  name: c.name,
                  imgPath: "LAM_DFT"
                },
                active: s.value === c.value,
                onSelect: r
              }, null, 8, ["data", "active"]))), 128))]), i.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", wN, [(_(!0), O(q, null, ce(i.data.options[0].extra.NOTICE, (c, d) => re((_(), O("p", {
                key: `notice-${d}`,
                class: "note"
              })), [[u, c]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    kN = {
      class: "inputs"
    },
    $N = {
      class: "subject sub"
    },
    FN = {
      key: 0,
      class: "notes"
    },
    UN = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "MIS_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(1),
            a = () => {
              s.value > 1e3 && (s.value = 999), s.value < 1 && (s.value = 1);
            };
          return U(() => s.value, r => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: n.data.name,
              ATTB: r
            }]);
          }, {
            immediate: !0
          }), (r, i) => {
            const l = it("dompurify-html");
            return _(), V(ve, {
              title: r.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", kN, [P("span", $N, Y(y(F)("줄수")), 1), re(P("input", {
                "onUpdate:modelValue": i[0] || (i[0] = u => s.value = u),
                type: "number",
                maxlength: "3",
                class: $e(["basic-input", "-fixed-w"]),
                id: "OSI_DFT_qty",
                min: "1",
                onFocusout: a
              }, null, 544), [[dt, s.value]])]), r.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", FN, [(_(!0), O(q, null, ce(r.data.options[0].extra.NOTICE, (u, c) => re((_(), O("p", {
                key: `notice-${c}`,
                class: "note gap"
              })), [[l, u]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      }), [["__scopeId", "data-v-182accde"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    BN = {
      class: "num-row"
    },
    xN = ["placeholder", "value"],
    HN = ["placeholder", "value"],
    GN = {
      class: "num-row num-font-row"
    },
    WN = {
      class: "num-label"
    },
    VN = {
      class: "font-select-text"
    },
    jN = {
      class: "font-notice"
    },
    zN = {
      class: "font-modal"
    },
    KN = {
      class: "font-modal-header"
    },
    YN = {
      class: "font-modal-title"
    },
    QN = {
      class: "font-modal-body"
    },
    qN = {
      class: "font-family-header"
    },
    XN = {
      class: "font-family-label"
    },
    ZN = {
      class: "font-weight-list"
    },
    JN = ["onClick"],
    eA = {
      class: "font-modal-footer"
    },
    tA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        inheritAttrs: !1,
        __name: "NUM_DFT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = _t(),
            a = [{
              id: "NanumGothic",
              label: {
                ko: "나눔 고딕",
                en: "Nanum Gothic"
              },
              cssName: "Nanum Gothic",
              weights: ["Light", "Regular", "Bold", "ExtraBold"],
              googleParam: "Nanum+Gothic:wght@400;700;800"
            }, {
              id: "NanumSquare",
              label: {
                ko: "나눔 스퀘어",
                en: "Nanum Square"
              },
              cssName: "NanumSquare",
              weights: ["Light", "Regular", "Bold", "ExtraBold"],
              cdnUrl: "https://cdn.jsdelivr.net/gh/moonspam/NanumSquare@1.0/nanumsquare.css"
            }, {
              id: "NanumBarunGothic",
              label: {
                ko: "나눔 바른 고딕",
                en: "Nanum Barun Gothic"
              },
              cssName: "Nanum Barun Gothic",
              weights: ["UltraLight", "Light", "Regular", "Bold"],
              googleParam: "Nanum+Barun+Gothic:wght@300;400;700"
            }, {
              id: "AridataDotum",
              label: {
                ko: "아리따 돋움",
                en: "Arita Dotum"
              },
              cssName: "Arita",
              weights: ["Thin", "Light", "Medium", "SemiBold", "Bold"],
              cdnUrl: "https://cdn.jsdelivr.net/gh/webfontbox/Arita@latest/font.css"
            }, {
              id: "Timon",
              label: {
                ko: "티몬 몬소리",
                en: "Tmon Monsori"
              },
              cssName: "TmonMonsori",
              weights: ["Regular"],
              woffUrl: "https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/TmonMonsori.woff"
            }, {
              id: "BaeminHannaPro",
              label: {
                ko: "배달의민족 한나 Pro",
                en: "Baemin Hanna Pro"
              },
              cssName: "BMHANNAPro",
              weights: ["Regular"],
              woffUrl: "https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_seven@1.0/BMHANNAPro.woff"
            }, {
              id: "BaeminDohyun",
              label: {
                ko: "배달의민족 도현",
                en: "Baemin Dohyun"
              },
              cssName: "Do Hyeon",
              weights: ["Regular"],
              googleParam: "Do+Hyeon"
            }, {
              id: "BaeminJua",
              label: {
                ko: "배달의민족 주아",
                en: "Baemin Jua"
              },
              cssName: "Jua",
              weights: ["Regular"],
              googleParam: "Jua"
            }, {
              id: "SeoulHangang",
              label: {
                ko: "서울 한강",
                en: "Seoul Hangang"
              },
              cssName: "SeoulHangangM",
              weights: ["Medium"],
              woffUrl: "https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/SeoulHangangM.woff"
            }, {
              id: "SeoulNamsan",
              label: {
                ko: "서울 남산",
                en: "Seoul Namsan"
              },
              cssName: "SeoulNamsanM",
              weights: ["Medium"],
              woffUrl: "https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/SeoulNamsanM.woff"
            }],
            r = Object.fromEntries(a.map(B => [B.id, B])),
            i = {
              Thin: 100,
              UltraLight: 100,
              ExtraLight: 200,
              Light: 300,
              Regular: 400,
              Medium: 500,
              SemiBold: 600,
              Bold: 700,
              ExtraBold: 800,
              Black: 900
            };
          function l(B, T) {
            const g = r[B];
            return g ? {
              fontFamily: `'${g.cssName}', sans-serif`,
              fontWeight: T ? i[T] ?? 400 : 400
            } : {};
          }
          let u = !1;
          function c() {
            if (!(u || typeof document > "u")) {
              if (u = !0, !document.getElementById("num-dft-gfonts")) {
                const B = a.filter(g => g.googleParam).map(g => g.googleParam).join("&family="),
                  T = document.createElement("link");
                T.id = "num-dft-gfonts", T.rel = "stylesheet", T.href = `https://fonts.googleapis.com/css2?family=${B}&display=swap`, document.head.appendChild(T);
              }
              if (!document.getElementById("num-dft-cdn")) {
                const B = [...new Set(a.filter(C => C.cdnUrl).map(C => C.cdnUrl))],
                  T = document.createDocumentFragment();
                B.forEach(C => {
                  const S = document.createElement("link");
                  S.rel = "stylesheet", S.href = C, T.appendChild(S);
                });
                const g = document.createElement("meta");
                g.id = "num-dft-cdn", T.appendChild(g), document.head.appendChild(T);
              }
              if (!document.getElementById("num-dft-woff")) {
                const T = a.filter(C => C.woffUrl).map(C => {
                    const S = i[C.weights[0]] ?? 400;
                    return `@font-face{font-family:'${C.cssName}';src:url('${C.woffUrl}') format('woff');font-weight:${S};font-style:normal;font-display:swap;}`;
                  }).join(""),
                  g = document.createElement("style");
                g.id = "num-dft-woff", g.textContent = T, document.head.appendChild(g);
              }
            }
          }
          const d = H(""),
            p = H("NanumGothic Regular"),
            f = H(!1),
            v = Xe({
              familyId: "NanumGothic",
              weight: "Regular"
            }),
            h = b(() => {
              if (!d.value) return "";
              const B = n.relatedData?.orderQty || 1,
                T = d.value.length,
                g = parseInt(d.value, 10);
              if (isNaN(g)) return "";
              const C = g + B - 1;
              return String(C).padStart(T, "0");
            }),
            m = b(() => {
              const [B, ...T] = p.value.split(" ");
              return l(B, T.join(" "));
            }),
            D = b(() => {
              const [B, ...T] = p.value.split(" "),
                g = r[B];
              return g ? `${g.label[s.locale] ?? g.label.ko} ${T.join(" ")}` : p.value;
            });
          Vo(() => c()), U(f, B => {
            document.body.style.overflow = B ? "hidden" : "";
          }), Rs(() => {
            document.body.style.overflow = "";
          });
          function N() {
            const [B, ...T] = p.value.split(" ");
            v.familyId = B, v.weight = T.join(" "), c(), f.value = !0;
          }
          function I(B, T) {
            v.familyId = B, v.weight = T;
          }
          function w() {
            p.value = `${v.familyId} ${v.weight}`, f.value = !1;
          }
          function A(B) {
            const T = B.target.value.replace(/[^0-9]/g, "");
            d.value = T, B.target.value = T;
          }
          const j = b(() => ({
            PCS_CD: n.data.value,
            PCS_DTL_CD: n.data.options[0]?.value,
            PCS_DTL_NM: n.data.options[0]?.name,
            ATTB: d.value && h.value ? `${d.value}~${h.value}` : "",
            ATTB_3: p.value
          }));
          return U(() => j.value, B => o("update", [B]), {
            immediate: !0
          }), (B, T) => {
            const g = it("dompurify-html");
            return _(), O(q, null, [ne(ve, {
              title: B.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", BN, [P("input", {
                type: "text",
                inputmode: "numeric",
                class: "num-input",
                placeholder: y(F)("num-dft.시작번호"),
                value: d.value,
                onInput: T[0] || (T[0] = C => A(C))
              }, null, 40, xN), T[3] || (T[3] = P("span", {
                class: "num-sep"
              }, "~", -1)), P("input", {
                type: "text",
                class: "num-input",
                placeholder: y(F)("num-dft.끝번호"),
                value: h.value,
                readonly: ""
              }, null, 8, HN)]), P("div", GN, [P("span", WN, Y(y(F)("num-dft.글꼴")), 1), P("button", {
                type: "button",
                class: "font-select-btn",
                style: mt(m.value),
                onClick: N
              }, [P("span", VN, Y(D.value), 1), T[4] || (T[4] = P("span", {
                class: "font-select-arrow"
              }, "▾", -1))], 4)]), P("p", jN, Y(y(F)("num-dft.폰트안내")), 1), B.data.options[0]?.extra?.NOTICE ? (_(!0), O(q, {
                key: 0
              }, ce(Object.values(B.data.options[0].extra.NOTICE), (C, S) => re((_(), O("p", {
                key: `notice-${S}`,
                class: "font-notice"
              })), [[g, `* ${C}`]])), 128)) : J("", !0)]),
              _: 1
            }, 8, ["title"]), f.value ? (_(), O("div", {
              key: 0,
              class: "font-modal-overlay",
              onClick: T[2] || (T[2] = no(C => f.value = !1, ["self"]))
            }, [P("div", zN, [P("div", KN, [P("span", YN, Y(y(F)("num-dft.글꼴선택")), 1), P("button", {
              type: "button",
              class: "font-modal-close",
              onClick: T[1] || (T[1] = C => f.value = !1)
            }, "✕")]), P("div", QN, [(_(), O(q, null, ce(a, C => P("div", {
              key: C.id,
              class: $e(["font-family-group", {
                active: v.familyId === C.id
              }])
            }, [P("div", qN, [P("span", XN, Y(C.label[y(s).locale] ?? C.label.ko), 1), P("span", {
              class: "font-preview-text",
              style: mt(l(C.id, v.familyId === C.id ? v.weight : C.weights[0]))
            }, "가나다 AaBb 123", 4)]), P("div", ZN, [(_(!0), O(q, null, ce(C.weights, S => (_(), O("button", {
              key: S,
              type: "button",
              class: $e(["font-weight-btn", {
                active: v.familyId === C.id && v.weight === S
              }]),
              style: mt(l(C.id, S)),
              onClick: R => I(C.id, S)
            }, Y(S), 15, JN))), 128))])], 2)), 64))]), P("div", eA, [P("button", {
              type: "button",
              class: "font-confirm-btn",
              onClick: w
            }, Y(y(F)("선택하기")), 1)])])])) : J("", !0)], 64);
          };
        }
      }), [["__scopeId", "data-v-51470bb9"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    nA = {
      class: "inputs"
    },
    oA = {
      class: "subject sub"
    },
    sA = {
      key: 0,
      class: "notes"
    },
    aA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "OSI_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(1),
            a = () => {
              s.value > 1e3 && (s.value = 999), s.value < 1 && (s.value = 1);
            };
          return U(() => s.value, r => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: n.data.name,
              ATTB: r
            }]);
          }, {
            immediate: !0
          }), (r, i) => {
            const l = it("dompurify-html");
            return _(), V(ve, {
              title: r.data.name,
              underline: ""
            }, {
              default: fe(() => [P("div", nA, [P("span", oA, Y(y(F)("줄수")), 1), re(P("input", {
                "onUpdate:modelValue": i[0] || (i[0] = u => s.value = u),
                type: "number",
                maxlength: "3",
                class: $e(["basic-input", "-fixed-w"]),
                id: "OSI_DFT_qty",
                min: "1",
                max: "999",
                onFocusout: a
              }, null, 544), [[dt, s.value]])]), r.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", sA, [(_(!0), O(q, null, ce(r.data.options[0].extra.NOTICE, (u, c) => re((_(), O("p", {
                key: `notice-${c}`,
                class: "note gap"
              })), [[l, u]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      }), [["__scopeId", "data-v-abdab151"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    iA = {
      class: "flex-row"
    },
    rA = {
      key: 0,
      class: "notes"
    },
    lA = {
      class: "pak-info-modal"
    },
    uA = {
      class: "img-wrap"
    },
    cA = ["src", "alt"],
    dA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        inheritAttrs: !1,
        __name: "PAK_ETC",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = H(n.data.options.find(m => m.value === "DFXXX" || m.value === "PK000")?.value || n.data.options[0].value),
            r = m => {
              a.value = m.value;
            },
            i = {
              GSBKBCH: {
                PK017: "PAK_ETC_PK017"
              },
              TPCLECO: {
                PK018: "PAK_ETC_PK018",
                PK019: "PAK_ETC_PK019",
                PK020: "PAK_ETC_PK019",
                PK021: "PAK_ETC_PK019",
                PK022: "PAK_ETC_PK019",
                PK023: "PAK_ETC_PK019",
                PK024: "PAK_ETC_PK019",
                PK025: "PAK_ETC_PK019",
                PK026: "PAK_ETC_PK019",
                PK027: "PAK_ETC_PK019",
                PK028: "PAK_ETC_PK019"
              }
            },
            l = b(() => i[s.pdtCode]),
            u = {
              PK017: {
                src: `${ut}/ko/item/order_beachTowel_opt_hover_1.png`,
                alt: "Beach Towel PVC bag image"
              }
            },
            c = b(() => n.data.options.map((m, D) => {
              const N = u[m.value];
              return N ? {
                IDX: D + 1,
                CATEGORY: `${F("후가공")} > ${m.name}`,
                LABEL: m.name,
                IMG_URL: N.src,
                IMG_ALT: N.alt
              } : null;
            })),
            d = {
              CATEGORY: n.data.name || "폴리백 개별포장",
              LABEL: n.data.name || "폴리백 개별포장",
              IMG_URL: "https://s3.ap-northeast-2.amazonaws.com/redprintingweb.common/assets/images/ko/pak_etc_desc.webp",
              IMG_ALT: n.data.name || "포장 상세 안내"
            },
            p = H(!1);
          function f() {
            p.value = !0;
          }
          U(p, m => {
            document.body.style.overflow = m ? "hidden" : "";
          }), Rs(() => {
            document.body.style.overflow = "";
          }), U(() => a.value, m => {
            const D = n.data.options.find(N => N.value === m)?.name || n.data.name;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: m,
              PCS_DTL_NM: D
            }]);
          }, {
            immediate: !0
          });
          const v = {
              EC001: "PK019",
              EC002: "PK020",
              EC003: "PK021",
              EC004: "PK022",
              EC005: "PK023",
              EC006: "PK024",
              EC007: "PK025",
              EC008: "PK026",
              EC009: "PK027",
              EC010: "PK028"
            },
            h = Xe(n.data.options);
          return U(() => n.relatedData?.postpcs?.CLD_STD, m => {
            if (!m) return;
            const D = m[0].selectedOptions[0].PCS_DTL_CD;
            if (!D) return;
            const N = v[D];
            for (const I of h) I.value === "PK018" || I.value === N ? I.forceHidden = !1 : I.forceHidden = !0, I.forceHidden && I.value === a.value && (a.value = N);
          }, {
            immediate: !0,
            deep: !0
          }), (m, D) => {
            const N = it("dompurify-html");
            return _(), O(q, null, [ne(ve, {
              title: m.data.name || "폴리백 개별포장",
              underline: "",
              extra: y(s).pdtCode !== "STTBDFT" ? {
                name: "자세히보기",
                callback: f,
                style: "tip"
              } : void 0
            }, {
              default: fe(() => [P("div", iA, [(_(!0), O(q, null, ce(h, (I, w) => (_(), V(Be, {
                key: I.key,
                data: {
                  value: I.value,
                  name: I.name,
                  imgPath: l.value && l.value[I.value] ? l.value[I.value] : m.data.imgPath,
                  subImgPath: m.data.subImgPath
                },
                "force-hidden": I.forceHidden,
                active: a.value === I.value,
                tip: c.value[w],
                onSelect: r
              }, null, 8, ["data", "force-hidden", "active", "tip"]))), 128))]), m.data.options[0]?.extra?.NOTICE?.length ? (_(), O("div", rA, [(_(!0), O(q, null, ce(m.data.options[0].extra.NOTICE, (I, w) => re((_(), O("p", {
                key: `notice-${w}`,
                class: "note"
              })), [[N, I]])), 128))])) : J("", !0)]),
              _: 1
            }, 8, ["title", "extra"]), p.value ? (_(), O("div", {
              key: 0,
              class: "pak-info-layer",
              onClick: D[1] || (D[1] = no(I => p.value = !1, ["self"]))
            }, [P("div", lA, [P("button", {
              type: "button",
              class: "close-btn",
              onClick: D[0] || (D[0] = I => p.value = !1)
            }, [ne(ls)]), P("div", uA, [P("img", {
              src: d.IMG_URL,
              alt: d.IMG_ALT
            }, null, 8, cA)])])])) : J("", !0)], 64);
          };
        }
      }), [["__scopeId", "data-v-64d7a0db"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    fA = {
      class: "flex-row"
    },
    pA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "PAK_POL",
        props: {
          data: {},
          disabledOptions: {},
          defaultValue: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.disabledOptions?.length ? n.data.options.filter(i => !n.disabledOptions.includes(i.value)) : n.data.options),
            a = H(n.defaultValue ?? n.data.options[0].value),
            r = i => {
              a.value = i.value;
            };
          return U(() => n.disabledOptions, i => {
            if (i?.includes(a.value)) {
              const l = s.value[0]?.value;
              l && (a.value = l);
            }
          }), U(() => a.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: n.data.name
            }]);
          }, {
            immediate: !0
          }), (i, l) => {
            const u = it("dompurify-html");
            return _(), V(ve, {
              title: i.data.name || "폴리백 개별포장",
              underline: ""
            }, {
              default: fe(() => [P("div", fA, [(_(!0), O(q, null, ce(s.value, c => (_(), V(Be, {
                key: c.key,
                data: {
                  value: c.value,
                  name: c.name,
                  imgPath: `${i.data.value}_${c.value}`,
                  subImgPath: i.data.subImgPath
                },
                active: a.value === c.value,
                onSelect: r
              }, null, 8, ["data", "active"]))), 128))]), i.data.options[1]?.extra?.NOTICE ? (_(!0), O(q, {
                key: 0
              }, ce(Object.values(i.data.options[1].extra.NOTICE), (c, d) => re((_(), O("p", {
                key: `notice-${d}`,
                class: "notice"
              })), [[u, `* ${c}`]])), 128)) : J("", !0)]),
              _: 1
            }, 8, ["title"]);
          };
        }
      }), [["__scopeId", "data-v-724f2bf9"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _A = {
      key: 0,
      class: "flex-row"
    },
    hA = ["value"],
    vA = ["value"],
    mA = {
      key: 1,
      class: "flex-row"
    },
    CA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "PDT_WRK",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("deviceType", "pc"),
            a = Te("callbacks", {}),
            r = Te("productCode", {
              pdtCode: ""
            }),
            i = b(() => r.pdtCode === "STTTDFT"),
            l = H(n.data.options[0].value);
          U(() => n.relatedData.sizeInfo?.DIV_SEQ, f => {
            if (!i.value || f === void 0) return;
            const v = n.data.options.find(h => h.extra?.DIV_SEQ === f);
            v && (l.value = v.value);
          }, {
            immediate: !0
          });
          const u = f => {
              l.value = f.value;
            },
            c = b(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: l.value,
              PCS_DTL_NM: n.data.options.find(f => f.value === l.value)?.name ?? n.data.name,
              ATTB: n.relatedData.orderQty
            })),
            d = {
              PP002: {
                src: `${ut}/ko/STDRCAD_back_print_over_img.png`,
                alt: "Back paper image"
              }
            },
            p = b(() => n.data.options.map((f, v) => {
              const h = d[f.value];
              return h ? {
                IDX: v + 1,
                CATEGORY: `${F("후가공")} > ${f.name}`,
                LABEL: f.name,
                IMG_URL: h.src,
                IMG_ALT: h.alt
              } : null;
            }));
          return U(() => c.value, f => {
            o("update", [f]);
          }, {
            immediate: !0
          }), (f, v) => {
            const h = it("dompurify-html");
            return _(), V(ve, {
              title: f.data.name,
              underline: "",
              extra: !i.value && y(s) === "mobile" && p.value ? {
                name: "자세히보기",
                callback: () => {
                  y(a).onInformOptionTips && y(a).onInformOptionTips(p.value);
                },
                style: "tip"
              } : null
            }, {
              default: fe(() => [i.value ? (_(), O("div", _A, [re(P("select", {
                "onUpdate:modelValue": v[0] || (v[0] = m => l.value = m),
                class: "basic-select",
                disabled: "",
                style: {
                  "background-color": "var(--color-gray-f5)"
                }
              }, [(_(!0), O(q, null, ce(f.data.options, m => (_(), O("option", {
                key: m.key,
                value: m.value
              }, Y(m.name), 9, hA))), 128))], 512), [[Ke, l.value]]), P("input", {
                type: "number",
                id: "qty",
                disabled: !0,
                value: f.relatedData.orderQty,
                class: "basic-input"
              }, null, 8, vA)])) : (_(), O("div", mA, [(_(!0), O(q, null, ce(f.data.options, (m, D) => (_(), V(Be, {
                key: m.key,
                data: {
                  value: m.value,
                  name: m.name,
                  imgPath: `${f.data.value}_${m.value}`
                },
                active: l.value === m.value,
                tip: p.value[D],
                onSelect: u
              }, null, 8, ["data", "active", "tip"]))), 128))])), f.data.options[0]?.extra?.NOTICE ? (_(!0), O(q, {
                key: 2
              }, ce(Object.values(f.data.options[0].extra.NOTICE), (m, D) => re((_(), O("p", {
                key: `notice-${D}`,
                class: "notice"
              })), [[h, `* ${m}`]])), 128)) : J("", !0)]),
              _: 1
            }, 8, ["title", "extra"]);
          };
        }
      }), [["__scopeId", "data-v-b7cb894d"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    TA = {
      class: "option packing"
    },
    gA = {
      class: "title"
    },
    yA = {
      class: "flex-row"
    },
    DA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "PRT_IPK",
        setup(e) {
          return (t, n) => (_(), O("div", TA, [P("div", gA, [P("h2", null, Y(y(F)("개별포장")), 1)]), P("div", yA, [ne(Be, {
            data: {
              value: "PRT_IPK",
              name: "개별포장",
              imgPath: "PRT_IPK"
            },
            active: !0
          })])]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    SA = {
      class: "flex-row"
    },
    PA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "PRT_MAG",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", SA, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: "PRT_MAG"
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    bA = {
      class: "flex-row"
    },
    OA = ["value"],
    EA = {
      value: ""
    },
    IA = ["value"],
    RA = ["disabled"],
    NA = ["disabled"],
    AA = {
      value: "C"
    },
    MA = {
      value: "P"
    },
    wA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "PRT_SID",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Ve(),
            a = Te("callbacks", {}),
            r = () => {
              s.isAfterEdit() && a?.onReset && a.onReset("postPcs");
            },
            i = H(n.data.options[0]?.value ?? ""),
            l = b(() => ["PT003", "PT004"].includes(i.value)),
            u = H(l.value ? "C" : "X");
          return U(() => i.value, c => {
            r(), c === "PT005" ? u.value = "" : u.value = ["PT003", "PT004"].includes(c) ? "C" : "X";
          }), U(() => u.value, () => {
            r();
          }), U(() => [i.value, u.value], ([c, d]) => {
            const p = n.data.options.find(f => f.value === c)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: c,
              PCS_DTL_NM: p?.PCS_DTL_NM,
              ATTB: l.value ? d : ""
            }]);
          }, {
            immediate: !0
          }), (c, d) => (_(), V(ve, {
            title: c.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", bA, [re(P("select", {
              "onUpdate:modelValue": d[0] || (d[0] = p => i.value = p),
              class: "basic-select"
            }, [(_(!0), O(q, null, ce(c.data.options, p => (_(), O("option", {
              key: p.key,
              value: p.value
            }, Y(p.name), 9, OA))), 128))], 512), [[Ke, i.value]]), i.value === "PT005" ? re((_(), O("select", {
              key: 0,
              "onUpdate:modelValue": d[1] || (d[1] = p => u.value = p),
              class: "basic-select"
            }, [P("option", EA, Y(y(F)("PRT_SID-디자인3방인쇄색상선택")), 1), (_(!0), O(q, null, ce(c.data.attbOptions, p => (_(), O("option", {
              key: p.key,
              value: p.value
            }, Y(p.name), 9, IA))), 128))], 512)), [[Ke, u.value]]) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": d[2] || (d[2] = p => u.value = p),
              class: "basic-select",
              disabled: !l.value
            }, [P("option", {
              value: "X",
              disabled: l.value
            }, Y(y(F)("PRT_SID-편집방법선택")), 9, NA), P("option", AA, Y(y(F)("PRT_SID-이어서편집")), 1), P("option", MA, Y(y(F)("PRT_SID-페이지별편집")), 1)], 8, RA)), [[Ke, u.value]])])]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-6b47f769"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    LA = {
      class: "flex-row"
    },
    fv = oe({
      __name: "PRT_WHT_FACE",
      props: {
        mode: {},
        options: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          a = b(() => n.options.map(p => ({
            value: p.value,
            name: p.name,
            imgPath: p.extra?.PCS_CD || "",
            extra: p.extra
          }))),
          r = Xe({
            DFXXF: !0,
            DFXXB: !0
          });
        function i(p) {
          r[p.value] = !r[p.value];
        }
        const l = b(() => {
          const p = [];
          return n.options.forEach(f => {
            (f.extra?.ESN_YN === "Y" || r[f.value]) && p.push({
              PCS_CD: f.extra?.PCS_CD || "PRT_WHT",
              PCS_GRP_NM: f.extra.PCS_GRP_NM,
              VIEW_YN: "Y",
              ESN_YN: f.extra?.ESN_YN || "N",
              selectedOptions: [{
                PCS_CD: f.extra?.PCS_CD,
                PCS_DTL_CD: f.extra?.PCS_DTL_CD,
                PCS_DTL_NM: f.extra?.PCS_DTL_NM,
                ATTB: "Y",
                ATTB_2: n.mode
              }]
            });
          }), p;
        });
        U(() => l.value, p => {
          p && o("update", p);
        }, {
          immediate: !0
        }), U(() => s.editorData?.default?.PRT_WHT, p => {
          p && (r.DFXXF = p?.front ?? !1, r.DFXXB = p?.back ?? !1);
        }, {
          immediate: !0
        });
        const {
          canResetWhite: u,
          arm: c,
          resetEditByWhite: d
        } = Pu();
        return U(() => l.value, () => {
          s.isAfterEdit() && (u.value && d(), c());
        }), Rs(() => {
          s.isAfterEdit() && d();
        }), U(() => s.uploadType.default, p => {
          p === "editor" && (r.DFXXF = !0, r.DFXXB = !0);
        }), (p, f) => (_(), O("div", LA, [(_(!0), O(q, null, ce(a.value, v => (_(), V(Be, {
          key: v.value,
          data: v,
          active: r[v.value],
          disabled: v.extra?.ESN_YN === "Y" || y(s).uploadType.default === "editor",
          onSelect: i
        }, null, 8, ["data", "active", "disabled"]))), 128))]));
      }
    }),
    kA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: fv
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    $A = {
      class: "grid-group"
    },
    FA = {
      class: "basic-radio"
    },
    UA = {
      for: "auto-white"
    },
    BA = {
      class: "text"
    },
    xA = {
      key: 0,
      for: "self-white"
    },
    HA = {
      class: "text"
    },
    GA = ["innerHTML"],
    WA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "PRT_WHT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update", "update:replace"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Ve(),
            a = Te("productCode", {
              pdtCode: ""
            }),
            r = b(() => n.data.options.length >= 2),
            i = H("Y"),
            l = b(() => {
              const h = n.data.options[0].extra?.NOTICE;
              if (!h || h.length === 0) return null;
              const m = h.length === 1 || i.value === "Y" ? 0 : 1;
              return h[m];
            }),
            u = b(() => r.value ? [] : n.data.options.filter((h, m) => h.extra?.ESN_YN === "Y" || m === 0).map(h => ({
              PCS_CD: h.extra?.PCS_CD,
              PCS_DTL_CD: h.extra?.PCS_DTL_CD,
              PCS_DTL_NM: h.extra?.PCS_DTL_NM,
              ATTB: zn.has(a.pdtCode) ? null : "Y",
              ATTB_2: zn.has(a.pdtCode) ? null : i.value
            }))),
            {
              canResetWhite: c,
              arm: d,
              resetEditByWhite: p
            } = Pu();
          U(() => u.value, h => {
            if (!h) return;
            const m = ["BCSPHIG"];
            if (a.pdtCode.startsWith("AC") || m.includes(a.pdtCode)) {
              if (r.value && !s.isAfterEdit()) return;
              c.value && p(), o("update", h), d();
            } else o("update", h);
          }, {
            immediate: !0
          });
          const f = h => {
              o("update:replace", h);
            },
            v = b(() => MP.has(a.pdtCode) ? !1 : s.uploadType.default === "pdf" ? !0 : _u[a.pdtCode] && n.relatedData.mtrlCd ? !_u[a.pdtCode][n.relatedData.mtrlCd] : !1);
          return U(() => v.value, h => {
            h || (i.value = "Y");
          }), (h, m) => re((_(), V(ve, {
            title: h.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", $A, [P("div", FA, [P("label", UA, [re(P("input", {
              type: "radio",
              id: "auto-white",
              name: "white-mode",
              "onUpdate:modelValue": m[0] || (m[0] = D => i.value = D),
              value: "Y"
            }, null, 512), [[Yd, i.value]]), P("span", BA, Y(y(F)("자동화이트")), 1)]), v.value ? (_(), O("label", xA, [re(P("input", {
              type: "radio",
              id: "self-white",
              name: "white-mode",
              "onUpdate:modelValue": m[1] || (m[1] = D => i.value = D),
              value: "N"
            }, null, 512), [[Yd, i.value]]), P("span", HA, Y(y(F)("수동화이트")), 1)])) : J("", !0)]), r.value ? (_(), V(fv, {
              key: 0,
              mode: i.value,
              options: h.data.options,
              onUpdate: f
            }, null, 8, ["mode", "options"])) : J("", !0), l.value ? (_(), O("p", {
              key: 1,
              class: "note red",
              innerHTML: "* " + l.value
            }, null, 8, GA)) : J("", !0)])]),
            _: 1
          }, 8, ["title"])), [[Lt, !y(zn).has(y(a).pdtCode)]]);
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    VA = {
      class: "color-label"
    },
    jA = {
      class: "color-chip"
    },
    zA = ["onClick"],
    KA = {
      class: "tooltip"
    },
    YA = ["value"],
    QA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "RFL_HAP",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.data.attbOptions.filter(l => l.extra?.RGB_CD)),
            a = H(n.data.attbOptions[0] ?? null),
            r = H(n.data.attbOptions[0]?.value ?? "");
          function i(l) {
            a.value = l, r.value = l.value;
          }
          return U(() => r.value, l => {
            const u = n.data.attbOptions.find(c => c.value === l);
            u && (a.value = u), o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0]?.value,
              PCS_DTL_NM: `${n.data.name}(${a.value?.name ?? ""})`,
              ATTB: l
            }]);
          }, {
            immediate: !0
          }), (l, u) => (_(), V(ve, {
            title: l.data.name,
            underline: ""
          }, {
            default: fe(() => [s.value.length ? (_(), O(q, {
              key: 0
            }, [P("p", VA, Y(y(F)("선택")) + " : " + Y(a.value?.name), 1), P("ul", jA, [(_(!0), O(q, null, ce(s.value, c => (_(), O("li", {
              key: c.value,
              class: $e(["color", {
                active: c.value === a.value?.value
              }]),
              style: mt({
                background: c.extra?.RGB_CD
              }),
              onClick: d => i(c)
            }, [P("span", KA, Y(c.name), 1)], 14, zA))), 128))])], 64)) : re((_(), O("select", {
              key: 1,
              "onUpdate:modelValue": u[0] || (u[0] = c => r.value = c),
              class: "basic-select",
              name: "rfl-hap"
            }, [(_(!0), O(q, null, ce(l.data.attbOptions, c => (_(), O("option", {
              key: c.key,
              value: c.value
            }, Y(c.name), 9, YA))), 128))], 512)), [[Ke, r.value]])]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-cf3f1faa"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    qA = {
      class: "flex-row"
    },
    XA = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "RIN_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.attbOptions[0].value),
            a = H(n.data.attbOptions[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: `${n.data.name}(${a.value})`,
              ATTB: i
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", qA, [(_(!0), O(q, null, ce(i.data.attbOptions, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: u.value
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    ZA = {
      class: "full-width"
    },
    JA = ["checked"],
    eM = {
      for: "ROU_DFT_ALL",
      class: "fake-checkbox"
    },
    tM = ["src"],
    nM = {
      class: "option-name"
    },
    oM = ["id", "value"],
    sM = ["for"],
    aM = ["src"],
    iM = {
      class: "option-name"
    },
    rM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "ROU_DFT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = ia(),
            r = b(() => kP.has(s.pdtCode)),
            i = b(() => n.relatedData.sizeInfo?.DIV_SEQ),
            l = b(() => {
              const h = hu[s.pdtCode];
              if (h) {
                if (h.factor === "fixed") {
                  const m = h.value;
                  return [{
                    id: `round-${m}`,
                    name: "round-value",
                    label: `${m}mm`,
                    value: m
                  }];
                }
                if (h.factor === "size" && i.value) {
                  const m = h.value[i.value];
                  return [{
                    id: `round-${m}`,
                    name: "round-value",
                    label: `${m}mm`,
                    value: m
                  }];
                }
              }
              return [{
                id: "round-4",
                name: "round-value",
                label: "4mm",
                value: "4"
              }, {
                id: "round-6",
                name: "round-value",
                label: "6mm",
                value: "6"
              }];
            }),
            u = H(l.value[0].value),
            c = b(() => n.data.options.map(h => `${h.value}/${h.name}`)),
            d = H(c.value),
            p = b(() => d.value.length === c.value.length);
          function f() {
            p.value ? (d.value = [c.value[0]], a.show(F("귀돌이최소선택안내"))) : d.value = c.value;
          }
          U(() => d.value, h => {
            if (h.length === 0) {
              d.value = [c.value[0]], a.show(F("귀돌이최소선택안내"));
              return;
            }
          }, {
            deep: !0
          }), U(() => i.value, h => {
            const m = hu[s.pdtCode];
            !m || m.factor !== "size" || !h || (u.value = m.value[h]);
          });
          const v = b(() => d.value.map(h => {
            const [m, D] = h.split("/");
            return {
              PCS_CD: n.data.value,
              PCS_DTL_CD: m,
              PCS_DTL_NM: D,
              ATTB: u.value
            };
          }));
          return U(() => v.value, h => {
            o("update", h);
          }, {
            immediate: !0
          }), (h, m) => (_(), V(ve, {
            title: h.data.name,
            underline: ""
          }, {
            default: fe(() => [ne(Rn, {
              options: l.value,
              "default-checked": l.value[0].value,
              onChange: m[0] || (m[0] = D => u.value = D.value)
            }, null, 8, ["options", "default-checked"]), P("ul", {
              class: "options",
              style: mt({
                display: r.value ? "none" : ""
              })
            }, [P("li", ZA, [P("input", {
              type: "checkbox",
              id: "ROU_DFT_ALL",
              checked: p.value,
              onChange: f
            }, null, 40, JA), P("label", eM, [P("img", {
              src: `${y(ut)}/ko/order_aside_icon_round_all.svg`
            }, null, 8, tM), P("span", nM, Y(y(F)("4귀전체")), 1)])]), (_(!0), O(q, null, ce(h.data.options, D => (_(), O("li", {
              key: D.value
            }, [re(P("input", {
              "onUpdate:modelValue": m[1] || (m[1] = N => d.value = N),
              type: "checkbox",
              id: D.value,
              value: `${D.value}/${D.name}`
            }, null, 8, oM), [[zd, d.value]]), P("label", {
              for: D.value,
              class: "fake-checkbox"
            }, [P("img", {
              src: `${y(ut)}/ko/order_aside_icon_ROU_DFT_${D.value}.svg`
            }, null, 8, aM), P("span", iM, Y(D.name), 1)], 8, sM)]))), 128))], 4)]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-f003a6e5"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    lM = {
      class: "grid-group"
    },
    uM = {
      class: "flex-row"
    },
    cM = {
      class: "note"
    },
    dM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "SCO_DFT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("callbacks", {}),
            a = _t(),
            r = {
              S: {
                ko: "단면",
                en: "Single Side"
              },
              D: {
                ko: "양면",
                en: "Double Side"
              },
              DFXX: {
                ko: "부분UV",
                en: "Raised Gloss"
              }
            },
            i = b(() => {
              const d = {},
                p = {};
              for (const f of n.data.options) {
                const v = f.value.slice(-1),
                  h = r[v],
                  m = f.value.slice(0, 4),
                  D = r[m];
                d[v] || (d[v] = {
                  id: `SCO_DFT/${v}`,
                  name: `SCO_DFT/${v}`,
                  label: h?.[a.locale] ?? h?.ko,
                  value: v
                }), p[m] || (p[m] = {
                  ...f,
                  value: m,
                  name: D?.[a.locale] ?? D?.ko
                });
              }
              return {
                sides: d,
                spotUVs: p
              };
            }),
            l = H("S"),
            u = H(n.data.options[0].value.slice(0, 4)),
            c = b(() => u.value + l.value);
          return U(() => c.value, d => {
            const p = n.data.options.find(f => f.value === d)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: d,
              PCS_DTL_NM: p?.PCS_DTL_NM
            }]);
          }, {
            immediate: !0
          }), (d, p) => (_(), V(ve, {
            title: d.data.name,
            underline: "",
            extra: {
              name: "규격가이드",
              callback: () => {
                y(s)?.onInformGuide && y(s).onInformGuide("SCO_DFT");
              }
            }
          }, {
            default: fe(() => [P("div", lM, [ne(Rn, {
              options: Object.values(i.value.sides),
              "default-checked": l.value,
              onChange: p[0] || (p[0] = f => l.value = f.value)
            }, null, 8, ["options", "default-checked"]), P("div", uM, [(_(!0), O(q, null, ce(Object.values(i.value.spotUVs), f => (_(), V(Be, {
              key: f.key,
              data: {
                value: f.value,
                name: f.name,
                imgPath: d.data.value,
                subImgPath: d.data.subImgPath
              },
              active: u.value === f.value,
              onSelect: p[1] || (p[1] = v => u.value = v.value)
            }, null, 8, ["data", "active"]))), 128))]), P("p", cM, Y(d.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title", "extra"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    fM = {
      class: "flex-row"
    },
    pM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "SUB_MTR_BC",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = b(() => n.data.options[0].extra.DIV_SEQ === 0 ? n.data.options : n.data.options.filter(l => l.extra.DIV_SEQ === n.relatedData.sizeInfo.DIV_SEQ)),
            a = H(s.value[0].value),
            r = H(`${n.data.name}-${s.value[0].name}`),
            i = l => {
              a.value = l.value, r.value = `${n.data.name}-${l.name}`;
            };
          return U(() => a.value, l => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: l,
              PCS_DTL_NM: r.value
            }]);
          }, {
            immediate: !0
          }), U(() => n.relatedData.sizeInfo.DIV_SEQ, () => {
            a.value = s.value[0].value, r.value = `${n.data.name}-${s.value[0].name}`;
          }), (l, u) => (_(), V(ve, {
            title: l.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", fM, [(_(!0), O(q, null, ce(s.value, c => (_(), V(Be, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${l.data.subImgPath}_${c.value}`,
                subImgPath: l.data.value
              },
              active: a.value === c.value,
              onSelect: i
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _M = {
      class: "flex-row"
    },
    hM = {
      key: 0,
      class: "flex-row attb-row"
    },
    vM = "SUB_MTR_LW",
    mM = "SUB_MTR_LW_ATTB",
    CM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        inheritAttrs: !1,
        __name: "SUB_MTR_LW",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.attbOptions?.[0]?.value ?? ""),
            r = b(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: s.value,
              PCS_DTL_NM: n.data.options.find(i => i.value === s.value)?.name,
              ...(a.value ? {
                ATTB_2: a.value
              } : {})
            }));
          return U(() => r.value, i => o("update", [i]), {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", _M, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${vM}_${u.value}`
              },
              active: s.value === u.value,
              onSelect: l[0] || (l[0] = c => s.value = c.value)
            }, null, 8, ["data", "active"]))), 128))]), i.data.attbOptions?.length ? (_(), O("div", hM, [(_(!0), O(q, null, ce(i.data.attbOptions, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${mM}_${u.value}`
              },
              active: a.value === u.value,
              onSelect: l[1] || (l[1] = c => a.value = c.value)
            }, null, 8, ["data", "active"]))), 128))])) : J("", !0)]),
            _: 1
          }, 8, ["title"]));
        }
      }), [["__scopeId", "data-v-a621e927"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    TM = {
      class: "flex-row -flow"
    },
    gM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "THO_BAK",
        props: {
          data: {},
          disabledOptions: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0]),
            a = b(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: s.value.value,
              PCS_DTL_NM: s.value.name,
              ATTB: ""
            }));
          return U(() => n.disabledOptions, r => {
            if (!r || !r.includes(s.value.value)) return;
            const i = n.data.options.find(l => !r.includes(l.value));
            i && (s.value = i);
          }), U(() => a.value, r => {
            o("update", [r]);
          }, {
            immediate: !0
          }), (r, i) => (_(), V(ve, {
            title: r.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", TM, [(_(!0), O(q, null, ce(r.data.options, l => (_(), V(Be, {
              key: l.key,
              data: {
                value: l.value,
                name: l.name,
                imgPath: `${r.data.value}_${l.value}`
              },
              active: s.value.value === l.value,
              disabled: r.disabledOptions?.includes(l.value),
              "disabled-styling": r.disabledOptions?.includes(l.value),
              onSelect: () => s.value = l
            }, null, 8, ["data", "active", "disabled", "disabled-styling", "onSelect"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    yM = {
      class: "flex-row"
    },
    DM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "THO_CUT",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", yM, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: "THO_CUT"
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    SM = {
      class: "flex-row"
    },
    PM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "THO_DFT",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = b(() => s.pdtCode === "PHPRFRM"),
            r = H(n.data.options[0].value),
            i = H(n.data.options[0].name),
            l = u => {
              r.value = u.value, i.value = u.name;
            };
          return U(() => n.relatedData.sizeInfo?.cutSize, u => {
            if (!a.value || !u) return;
            const c = u.width,
              d = u.height,
              f = n.data.options.find(v => +v.extra.CUT_WDT === c && +v.extra.CUT_HGH === d) ?? n.data.options[0];
            r.value = f.value, i.value = f.name;
          }, {
            immediate: !0,
            deep: !0
          }), U(() => r.value, u => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: u,
              PCS_DTL_NM: `${n.data.name}(${i.value})`
            }]);
          }, {
            immediate: !0
          }), (u, c) => a.value ? J("", !0) : (_(), V(ve, {
            key: 0,
            title: u.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", SM, [(_(!0), O(q, null, ce(u.data.options, d => (_(), V(Be, {
              key: d.key,
              data: {
                value: d.value,
                name: d.name,
                imgPath: `THO_DFT_${d.value}`
              },
              active: r.value === d.value,
              disabled: a.value,
              "disabled-styling": !1,
              onSelect: c[0] || (c[0] = p => !a.value && l(p))
            }, null, 8, ["data", "active", "disabled"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    bM = {
      class: "flex-row"
    },
    OM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "THO_GRA",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = H(n.data.options[0].value),
            a = H(n.data.options[0].name),
            r = i => {
              s.value = i.value, a.value = i.name;
            };
          return U(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${a.value})`
            }]);
          }, {
            immediate: !0
          }), (i, l) => (_(), V(ve, {
            title: i.data.name,
            underline: ""
          }, {
            default: fe(() => [P("div", bM, [(_(!0), O(q, null, ce(i.data.options, u => (_(), V(Be, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: "THO_GRA"
              },
              active: s.value === u.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    EM = {
      key: 0,
      class: "flex-row"
    },
    IM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "WRK_MTR",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = {
              WRK_MTR_PB: "icon"
            },
            o = Te("productCode", {
              pdtCode: ""
            }),
            s = Ve(),
            a = b(() => o.pdtCode === "FBPOCHR" && s.uploadType.default === "editor"),
            r = e,
            i = t,
            l = b(() => r.data.options.map(d => ({
              id: d.value,
              name: r.data.value,
              label: d.name,
              value: d.value,
              disabled: a.value
            }))),
            u = H(l.value[0]),
            c = b(() => ({
              PCS_CD: r.data.value,
              PCS_DTL_CD: u.value.value,
              PCS_DTL_NM: u.value.label,
              ATTB: r.relatedData.orderQty
            }));
          return U(() => c.value, (d, p) => {
            p?.ATTB === d.ATTB && p?.PCS_DTL_CD === d.PCS_DTL_CD || i("update", [d]);
          }, {
            immediate: !0
          }), (d, p) => (_(), V(ve, {
            title: d.data.name,
            underline: ""
          }, {
            default: fe(() => [n[d.data.group] === "icon" ? (_(), O("div", EM, [(_(!0), O(q, null, ce(d.data.options, f => (_(), V(Be, {
              key: f.value,
              active: u.value.value === f.value,
              data: {
                ...f,
                imgPath: `${d.data.value}_${f.value}`
              },
              onSelect: v => {
                u.value = {
                  id: v.value,
                  name: r.data.value,
                  label: v.name,
                  value: v.value
                };
              }
            }, null, 8, ["active", "data", "onSelect"]))), 128))])) : (_(), V(Rn, {
              key: 1,
              options: l.value,
              "default-checked": l.value[0].value,
              onChange: p[0] || (p[0] = f => u.value = f)
            }, null, 8, ["options", "default-checked"]))]),
            _: 1
          }, 8, ["title"]));
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    RM = ["disabled"],
    NM = ["value", "disabled"],
    AM = {
      key: 0,
      class: "mtrl-notice"
    },
    pv = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "Basic",
        props: {
          options: {},
          showExtra: {
            type: Boolean,
            default: !1
          },
          default: {},
          resetAfterEdit: {
            type: Boolean
          },
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("callbacks", {}),
            a = Te("productCode", {
              pdtCode: ""
            }),
            r = _t(),
            i = b(() => n.relatedData?.filters),
            l = b(() => n.relatedData?.POST_PCS),
            u = b(() => {
              let h = [];
              return pu.has(a.pdtCode) && l.value && (h = n.options.filter(m => m.MTRL_CD === l.value?.MTRL_CD || m.BSN_YN === "Y")), i.value && (h = n.options.filter(m => (i.value?.MTRL_GRP ? i.value.MTRL_GRP === m.GRP_OPTION_CD : !0) && (i.value?.PTT ? i.value.PTT === m.PTT_CD : !0))), h.length > 0 ? h : n.options;
            }),
            c = b(() => u.value.filter(h => h.HIDE_YN !== "Y")),
            d = async () => {
              const h = await lu({
                pdt_cod: a.pdtCode,
                lang: r.locale
              });
              if (!h) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
              if (s?.onInformMaterials) {
                const m = a.pdtCode.startsWith("ST") ? [F("스티커용지-주의사항")] : void 0;
                s.onInformMaterials(h, m);
              } else console.log("[RedWidgetSDK] 자재 정보 >", h);
            },
            p = () => {
              n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
            },
            f = H(n.default?.MTRL_CD || c.value.find(h => h.DFT_YN === "Y")?.MTRL_CD || c.value[0]?.MTRL_CD);
          U(() => f.value, h => {
            const m = c.value.find(D => D.MTRL_CD === h);
            if (m) {
              const {
                PTT_CD: D,
                PTT_NM: N,
                WGT_CD: I,
                CLR_CD: w,
                MTRL_CD: A,
                MTRL_NM: j,
                MTRL_TYPE: B,
                PRT_HIDE_YN: T
              } = m;
              o("update", {
                PTT_CD: D,
                PTT_NM: N,
                WGT_CD: I,
                CLR_CD: w,
                MTRL_CD: A,
                MTRL_NM: j,
                MTRL_TYPE: B,
                PRT_HIDE_YN: T
              }), D === "OOO" && s?.onSaleOrder && s?.onSaleOrder(), p();
            }
          }, {
            immediate: !0
          }), U(() => l.value?.MTRL_CD, h => {
            h && pu.has(a.pdtCode) && (f.value = c.value[0]?.MTRL_CD);
          }), U(() => n.relatedData?.forcedMtrlCd, h => {
            h && (f.value = h);
          }, {
            immediate: !0
          }), U(() => i.value, (h, m) => {
            (h?.MTRL_GRP !== m?.MTRL_GRP || h?.PTT !== m?.PTT) && (f.value = c.value[0]?.MTRL_CD);
          });
          const v = b(() => IP.has(a.pdtCode) ? "기종" : a.pdtCode === "PHFRDIA" ? "액자" : ["PHPRFRM", "PHPTBKG", "PHPTDFT", "PHPRDFT", "PHPKDFT"].includes(a.pdtCode) ? "용지" : "자재");
          return (h, m) => (_(), V(ve, {
            title: v.value,
            extra: h.showExtra ? {
              name: "주문가능자재",
              callback: d
            } : null
          }, {
            default: fe(() => [re(P("select", {
              "onUpdate:modelValue": m[0] || (m[0] = D => f.value = D),
              class: "basic-select",
              name: "material",
              disabled: !!n.relatedData?.lockedMtrl,
              onChange: p
            }, [(_(!0), O(q, null, ce(u.value, D => (_(), O("option", {
              key: D.MTRL_CD,
              value: D.MTRL_CD,
              disabled: D.HIDE_YN === "Y"
            }, Y(D.HIDE_YN !== "Y" ? u.value.length === 1 ? D.PTT_NM : D.MTRL_NM || D.PTT_NM : `[${D.HIDE_RSN || y(F)("주문불가")}] ${D.MTRL_NM}`) + " " + Y(D.BSN_YN === "Y" ? "[영업주문]" : ""), 9, NM))), 128))], 40, RM), [[Ke, f.value]]), n.relatedData?.notice ? (_(), O("p", AM, Y(n.relatedData.notice), 1)) : J("", !0)]),
            _: 1
          }, 8, ["title", "extra"]));
        }
      }), [["__scopeId", "data-v-02f1bd8b"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    MM = {
      class: "inputs"
    },
    wM = ["disabled"],
    LM = {
      class: "notes"
    },
    kM = {
      key: 0,
      class: "note red"
    },
    $M = {
      class: "note red"
    },
    FM = {
      class: "inputs"
    },
    UM = ["value"],
    BM = {
      key: 0,
      class: "notes"
    },
    xM = {
      class: "note red"
    },
    HM = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "CalendarQty",
        props: {
          options: {},
          default: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = Ve(),
            r = H("select"),
            i = () => {
              r.value = r.value === "input" ? "select" : "input";
            },
            l = b(() => Fh.has(s.pdtCode) ? !0 : a.uploadType.default === "pdf"),
            u = b(() => n.options.find(B => B.DFT_YN === "Y") || n.options[0]),
            c = b(() => u.value?.MIN_PRN_CNT || 1),
            d = b(() => u.value?.DFT_PRN_CNT || 1),
            p = b(() => {
              if (n.options.length > 1) return n.options;
              const B = d.value,
                T = c.value,
                g = B * 10,
                C = [];
              for (let S = T; S <= g; S += B) {
                const R = {
                  PRN_CNT: S
                };
                C.push(R);
              }
              return C;
            }),
            f = H(n.default?.ordCnt || 13),
            v = H(n.default?.prnCnt || c.value),
            h = b(() => ({
              ordCnt: f.value,
              prnCnt: v.value
            })),
            m = b(() => {
              const B = n.relatedData?.dosu === "SID_D" ? 2 : 1;
              return (f.value * B).toLocaleString();
            }),
            D = b(() => n.relatedData?.size === "mini" || a.uploadType.default === "editor"),
            N = b(() => n.relatedData?.size === "mini" ? 13 : s.pdtCode === "TPCLECO" ? 14 : 24),
            I = b(() => {
              if (d.value === 1) return !1;
              const B = h.value.prnCnt % d.value;
              return d.value > 1 && B !== 0;
            }),
            w = b(() => h.value.ordCnt < 13 || h.value.ordCnt > N.value);
          U(() => h.value, an(B => {
            I.value ? o("update", {
              ordCnt: f.value,
              prnCnt: 0
            }) : w.value ? o("update", {
              ordCnt: 0,
              prnCnt: v.value
            }) : o("update", B);
          }, 200), {
            immediate: !0
          });
          const A = () => {
              if (I.value) {
                const B = Math.ceil(h.value.prnCnt / d.value);
                v.value = (B || 1) * d.value;
              }
            },
            j = () => {
              w.value && (h.value.ordCnt < 13 && (f.value = 13), h.value.ordCnt > N.value && (f.value = N.value));
            };
          return U(() => a.editorData?.default?.quantityInfo?.ordCnt, (B, T) => {
            if (B) f.value = B;else if (T) return f.value = 13;
          }), (B, T) => (_(), V(ve, null, {
            default: fe(() => [l.value ? (_(), V(ve, {
              key: 0,
              title: "디자인수"
            }, {
              default: fe(() => [P("div", MM, [re(P("input", {
                "onUpdate:modelValue": T[0] || (T[0] = g => f.value = g),
                type: "number",
                class: $e(["basic-input", "-fixed-w"]),
                id: "ORD_CNT",
                min: "13",
                disabled: D.value,
                onFocusout: j
              }, null, 40, wM), [[dt, f.value]]), yo(" " + Y(y(F)("장")), 1)]), P("div", LM, [y(a).uploadType.default === "pdf" ? (_(), O("p", kM, " * " + Y(`${y(F)("PDF장수안내", {
                QTY: m.value
              })}`), 1)) : J("", !0), P("p", $M, "* " + Y(y(F)("달력디자인수설명", {
                MAX_CNT: `${N.value}`
              })), 1)]), T[3] || (T[3] = P("br", null, null, -1))]),
              _: 1
            })) : J("", !0), ne(ve, {
              title: "수량"
            }, {
              default: fe(() => [P("div", FM, [r.value === "input" ? re((_(), O("input", {
                key: 0,
                "onUpdate:modelValue": T[1] || (T[1] = g => v.value = g),
                type: "number",
                class: $e(["basic-input", "-fixed-w"]),
                id: "PRN_CNT",
                min: "1",
                onFocusout: A
              }, null, 544)), [[dt, v.value]]) : re((_(), O("select", {
                key: 1,
                "onUpdate:modelValue": T[2] || (T[2] = g => v.value = g),
                name: "PRN_CNT",
                class: $e(["basic-select", "-fixed-w"])
              }, [(_(!0), O(q, null, ce(p.value, g => (_(), O("option", {
                value: g.PRN_CNT,
                key: g.PRN_CNT
              }, Y(g.PRN_CNT), 9, UM))), 128))], 512)), [[Ke, v.value]]), yo(" " + Y(y(F)("개")) + " ", 1), P("button", {
                type: "button",
                class: "action-btn",
                onClick: i
              }, Y(r.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)]), d.value !== 1 ? (_(), O("div", BM, [P("p", xM, " * " + Y(y(F)("최소단위수량안내", {
                MIN_QTY: `${c.value}`,
                UNIT_QTY: d.value % 2 === 0 ? y(F)("짝수") : y(F)("홀수")
              })), 1)])) : J("", !0)]),
              _: 1
            })]),
            _: 1
          }));
        }
      }), [["__scopeId", "data-v-129f13ef"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    GM = {
      class: "qty-group"
    },
    WM = {
      class: "title"
    },
    VM = {
      class: "subject"
    },
    jM = {
      class: "subject"
    },
    zM = {
      class: "inputs"
    },
    KM = ["value"],
    YM = {
      class: "icon-box"
    },
    QM = ["value"],
    qM = {
      class: "notes"
    },
    XM = {
      key: 0,
      class: "note"
    },
    ZM = {
      key: 1,
      class: "note"
    },
    JM = {
      key: 2,
      class: "note"
    },
    ew = {
      key: 3,
      class: "note"
    },
    tw = {
      key: 4,
      class: "note red"
    },
    nw = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "SetQty",
        props: {
          defaultSetCnt: {},
          canEditOrdCnt: {},
          expressShipping: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Ve(),
            a = b(() => s.editorData?.default?.cntInfo?.initCnt ?? n.defaultSetCnt),
            r = b(() => s.editorData?.default?.cntInfo?.totalCnt),
            i = b(() => r.value ? r.value / (a.value || 1) : 1),
            l = b(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: u,
                type: c
              } = n.expressShipping;
              if (!(u === 0 || u >= (r.value || 0))) {
                if (c === "Y") return F("오늘출발-불가능");
                if (c === "T") return F("내일출발-불가능");
              }
            });
          return U(() => s.editorData?.default?.quantityInfo, u => {
            const c = u?.prnCnt || 1;
            o("update", {
              ordCnt: u?.ordCnt || 1,
              prnCnt: c < n.defaultSetCnt ? n.defaultSetCnt : c
            });
          }, {
            immediate: !0
          }), (u, c) => {
            const d = it("dompurify-html");
            return _(), V(ve, null, {
              default: fe(() => [P("div", GM, [P("div", WM, [P("h2", VM, Y(y(F)("세트별수량")), 1), P("h2", jM, Y(y(F)("세트")), 1)]), P("div", zM, [P("input", {
                type: "number",
                class: "basic-input",
                id: "unitQty",
                maxlength: "6",
                min: "1",
                value: a.value,
                disabled: ""
              }, null, 8, KM), P("div", YM, [ne(ls)]), P("input", {
                type: "number",
                class: "basic-input",
                id: "setQty",
                maxlength: "6",
                min: "1",
                value: i.value,
                disabled: ""
              }, null, 8, QM)]), P("div", qM, [r.value ? re((_(), O("p", ZM, null, 512)), [[d, y(F)("주문수량안내", {
                QTY: r.value.toLocaleString() + y(F)("개")
              })]]) : (_(), O("p", XM, "* " + Y(y(F)("세트수량안내")), 1)), u.canEditOrdCnt.pdf && u.canEditOrdCnt.editor ? (_(), O("p", JM, "* " + Y(y(F)("디자인건수가능여부-전체")), 1)) : !u.canEditOrdCnt.pdf && u.canEditOrdCnt.editor ? (_(), O("p", ew, " * " + Y(y(F)("디자인건수가능여부-에디터")), 1)) : J("", !0), l.value ? re((_(), O("p", tw, null, 512)), [[d, l.value]]) : J("", !0)])])]),
              _: 1
            });
          };
        }
      }), [["__scopeId", "data-v-eeb1157d"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    ow = {
      class: "qty-group"
    },
    sw = {
      class: "title"
    },
    aw = {
      class: "subject"
    },
    iw = {
      class: "inputs"
    },
    rw = ["value"],
    lw = {
      class: "notes"
    },
    uw = {
      class: "note"
    },
    cw = {
      key: 0,
      class: "note red"
    },
    dw = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Ne(oe({
        __name: "SimpleQty",
        props: {
          options: {},
          unit: {},
          default: {},
          relatedData: {},
          expressShipping: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Te("productCode", {
              pdtCode: ""
            }),
            a = Ve(),
            r = H("select"),
            i = () => {
              r.value = r.value === "input" ? "select" : "input", r.value === "select" && (v.value.find(C => C.PRN_CNT === m.value) || (m.value = u.value));
            },
            l = b(() => n.options.find(g => g.DFT_YN === "Y") || n.options[0]),
            u = b(() => l.value?.DFT_PRN_CNT || 1),
            c = b(() => l.value?.MIN_PRN_CNT || 1),
            d = b(() => l.value?.INC_CNT || 1),
            p = b(() => l.value?.INC_STEP || 10),
            f = b(() => l.value?.FIR_CNT || c.value),
            v = b(() => {
              if (n.options.length > 1) return n.options;
              const g = [];
              for (let C = f.value; g.length < p.value; C += d.value) {
                const S = {
                  PRN_CNT: C
                };
                g.push(S);
              }
              return g;
            }),
            h = H(n.default?.ordCnt || 1),
            m = H(n.default?.prnCnt || u.value || c.value),
            D = b(() => ({
              ordCnt: h.value,
              prnCnt: m.value
            })),
            N = u0,
            I = b(() => {
              const g = N[s.pdtCode]?.qtyPerSet;
              return typeof g == "function" ? g(n.relatedData?.divSeq ?? 0) : g ?? 1;
            }),
            w = b(() => (h.value * m.value).toLocaleString()),
            A = b(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: g,
                type: C
              } = n.expressShipping;
              if (!(g === 0 || g >= +w.value)) {
                if (C === "Y") return F("오늘출발-불가능");
                if (C === "T") return F("내일출발-불가능");
              }
            }),
            j = b(() => {
              if (!m.value) return !0;
              if (d.value !== 1) {
                const g = m.value % d.value;
                if (d.value > 1 && g !== 0) return !0;
              }
              return !1;
            }),
            B = b(() => !h.value),
            T = () => {
              if (!m.value) return m.value = 1;
              if (d.value !== 1) {
                const g = m.value % d.value;
                if (d.value > 1 && g !== 0) {
                  const C = Math.ceil(m.value / d.value);
                  m.value = (C || 1) * d.value;
                }
              }
            };
          return U(() => D.value, an(g => {
            j.value || B.value || o("update", g);
          }, 300), {
            immediate: !0
          }), U(() => a.editorData?.default?.quantityInfo?.ordCnt, (g, C) => {
            g ? h.value = g : C && (h.value = 1);
          }), (g, C) => {
            const S = it("dompurify-html");
            return _(), V(ve, null, {
              default: fe(() => [P("div", ow, [P("div", sw, [P("h2", aw, Y(y(F)("수량")), 1)]), P("div", iw, [r.value === "input" ? re((_(), O("input", {
                key: 0,
                "onUpdate:modelValue": C[0] || (C[0] = R => m.value = R),
                type: "number",
                class: "basic-input",
                id: "PRN_CNT",
                min: "1",
                onFocusout: T
              }, null, 544)), [[dt, m.value]]) : re((_(), O("select", {
                key: 1,
                "onUpdate:modelValue": C[1] || (C[1] = R => m.value = R),
                name: "PRN_CNT",
                class: "basic-select",
                style: {
                  width: "35%"
                }
              }, [(_(!0), O(q, null, ce(v.value, R => (_(), O("option", {
                value: R.PRN_CNT,
                key: R.PRN_CNT
              }, Y(R.PRN_CNT), 9, rw))), 128))], 512)), [[Ke, m.value]]), P("button", {
                type: "button",
                class: "action-btn",
                onClick: i
              }, Y(r.value === "input" ? y(F)("수량선택") : y(F)("직접입력")), 1)])]), P("div", lw, [re(P("p", uw, null, 512), [[S, y(F)("주문수량안내", {
                QTY: `${w.value}${y(F)(y(N)[y(s).pdtCode].name)}`
              }) + ` (${I.value}${g.unit}/1${y(F)(y(N)[y(s).pdtCode].name)})`]]), A.value ? re((_(), O("p", cw, null, 512)), [[S, A.value]]) : J("", !0)])]),
              _: 1
            });
          };
        }
      }), [["__scopeId", "data-v-acba968d"]])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    fw = ["value"],
    pw = {
      class: "notes"
    },
    _w = {
      key: 0,
      class: "note"
    },
    hw = {
      key: 1,
      class: "note"
    },
    vw = {
      key: 2,
      class: "note"
    },
    mw = {
      key: 3,
      class: "note"
    },
    Cw = {
      key: 4,
      class: "note red"
    },
    Tw = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oe({
        __name: "TotalQty",
        props: {
          canEditOrdCnt: {},
          expressShipping: {}
        },
        emits: ["update"],
        setup(e, {
          emit: t
        }) {
          const n = e,
            o = t,
            s = Ve(),
            a = b(() => s.editorData?.default?.cntInfo?.totalCnt),
            r = b(() => s.editorData?.default?.quantityInfo?.ordCnt),
            i = b(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: l,
                type: u
              } = n.expressShipping;
              if (!(l === 0 || l >= (a.value || 0))) {
                if (u === "Y") return F("오늘출발-불가능");
                if (u === "T") return F("내일출발-불가능");
              }
            });
          return U(() => s.editorData?.default?.quantityInfo, l => {
            o("update", {
              ordCnt: l?.ordCnt || 1,
              prnCnt: l?.prnCnt || 1
            });
          }, {
            immediate: !0
          }), (l, u) => {
            const c = it("dompurify-html");
            return _(), V(ve, {
              title: "총수량"
            }, {
              default: fe(() => [P("input", {
                type: "number",
                class: "basic-input",
                id: "totalQty",
                maxlength: "6",
                min: "1",
                value: a.value,
                disabled: ""
              }, null, 8, fw), P("div", pw, [r.value ? re((_(), O("p", hw, null, 512)), [[c, y(F)("디자인건수안내", {
                QTY: `${r.value}`
              })]]) : (_(), O("p", _w, "* " + Y(y(F)("세트수량안내")), 1)), l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor ? (_(), O("p", vw, "* " + Y(y(F)("디자인건수가능여부-전체")), 1)) : !l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor ? (_(), O("p", mw, " * " + Y(y(F)("디자인건수가능여부-에디터")), 1)) : J("", !0), i.value ? re((_(), O("p", Cw, null, 512)), [[c, i.value]]) : J("", !0)])]),
              _: 1
            });
          };
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }));
})();