(function() {
  "use strict";
  /**
   * @vue/shared v3.5.21
   * (c) 2018-present Yuxi (Evan) You and Vue contributors
   * @license MIT
   **/
  function fn(e) {
    const t = Object.create(null);
    for (const n of e.split(",")) t[n] = 1;
    return n => n in t
  }
  const Le = Object.freeze({}),
    _o = Object.freeze([]),
    ct = () => {},
    nu = () => !1,
    Vo = e => e.charCodeAt(0) === 111 && e.charCodeAt(1) === 110 && (e.charCodeAt(2) > 122 || e.charCodeAt(2) < 97),
    Fs = e => e.startsWith("onUpdate:"),
    Qe = Object.assign,
    Jr = (e, t) => {
      const n = e.indexOf(t);
      n > -1 && e.splice(n, 1)
    },
    Th = Object.prototype.hasOwnProperty,
    Ae = (e, t) => Th.call(e, t),
    ye = Array.isArray,
    Hn = e => Ho(e) === "[object Map]",
    ho = e => Ho(e) === "[object Set]",
    ou = e => Ho(e) === "[object Date]",
    be = e => typeof e == "function",
    ze = e => typeof e == "string",
    Vt = e => typeof e == "symbol",
    Me = e => e !== null && typeof e == "object",
    Zr = e => (Me(e) || be(e)) && be(e.then) && be(e.catch),
    su = Object.prototype.toString,
    Ho = e => su.call(e),
    ei = e => Ho(e).slice(8, -1),
    ru = e => Ho(e) === "[object Object]",
    ti = e => ze(e) && e !== "NaN" && e[0] !== "-" && "" + parseInt(e, 10) === e,
    Go = fn(",key,ref,ref_for,ref_key,onVnodeBeforeMount,onVnodeMounted,onVnodeBeforeUpdate,onVnodeUpdated,onVnodeBeforeUnmount,onVnodeUnmounted"),
    bh = fn("bind,cloak,else-if,else,for,html,if,model,on,once,pre,show,slot,text,memo"),
    Us = e => {
      const t = Object.create(null);
      return (n => t[n] || (t[n] = e(n)))
    },
    Sh = /-\w/g,
    ht = Us(e => e.replace(Sh, t => t.slice(1).toUpperCase())),
    Dh = /\B([A-Z])/g,
    wn = Us(e => e.replace(Dh, "-$1").toLowerCase()),
    Gn = Us(e => e.charAt(0).toUpperCase() + e.slice(1)),
    jn = Us(e => e ? `on${Gn(e)}` : ""),
    An = (e, t) => !Object.is(e, t),
    mo = (e, ...t) => {
      for (let n = 0; n < e.length; n++) e[n](...t)
    },
    Bs = (e, t, n, o = !1) => {
      Object.defineProperty(e, t, {
        configurable: !0,
        enumerable: !1,
        writable: o,
        value: n
      })
    },
    Vs = e => {
      const t = parseFloat(e);
      return isNaN(t) ? e : t
    };
  let iu;
  const jo = () => iu || (iu = typeof globalThis < "u" ? globalThis : typeof self < "u" ? self : typeof window < "u" ? window : typeof global < "u" ? global : {});

  function Qt(e) {
    if (ye(e)) {
      const t = {};
      for (let n = 0; n < e.length; n++) {
        const o = e[n],
          s = ze(o) ? Ih(o) : Qt(o);
        if (s)
          for (const r in s) t[r] = s[r]
      }
      return t
    } else if (ze(e) || Me(e)) return e
  }
  const Ph = /;(?![^(]*\))/g,
    Eh = /:([^]+)/,
    Oh = /\/\*[^]*?\*\//g;

  function Ih(e) {
    const t = {};
    return e.replace(Oh, "").split(Ph).forEach(n => {
      if (n) {
        const o = n.split(Eh);
        o.length > 1 && (t[o[0].trim()] = o[1].trim())
      }
    }), t
  }

  function we(e) {
    let t = "";
    if (ze(e)) t = e;
    else if (ye(e))
      for (let n = 0; n < e.length; n++) {
        const o = we(e[n]);
        o && (t += o + " ")
      } else if (Me(e))
        for (const n in e) e[n] && (t += n + " ");
    return t.trim()
  }
  const Rh = "html,body,base,head,link,meta,style,title,address,article,aside,footer,header,hgroup,h1,h2,h3,h4,h5,h6,nav,section,div,dd,dl,dt,figcaption,figure,picture,hr,img,li,main,ol,p,pre,ul,a,b,abbr,bdi,bdo,br,cite,code,data,dfn,em,i,kbd,mark,q,rp,rt,ruby,s,samp,small,span,strong,sub,sup,time,u,var,wbr,area,audio,map,track,video,embed,object,param,source,canvas,script,noscript,del,ins,caption,col,colgroup,table,thead,tbody,td,th,tr,button,datalist,fieldset,form,input,label,legend,meter,optgroup,option,output,progress,select,textarea,details,dialog,menu,summary,template,blockquote,iframe,tfoot",
    wh = "svg,animate,animateMotion,animateTransform,circle,clipPath,color-profile,defs,desc,discard,ellipse,feBlend,feColorMatrix,feComponentTransfer,feComposite,feConvolveMatrix,feDiffuseLighting,feDisplacementMap,feDistantLight,feDropShadow,feFlood,feFuncA,feFuncB,feFuncG,feFuncR,feGaussianBlur,feImage,feMerge,feMergeNode,feMorphology,feOffset,fePointLight,feSpecularLighting,feSpotLight,feTile,feTurbulence,filter,foreignObject,g,hatch,hatchpath,image,line,linearGradient,marker,mask,mesh,meshgradient,meshpatch,meshrow,metadata,mpath,path,pattern,polygon,polyline,radialGradient,rect,set,solidcolor,stop,switch,symbol,text,textPath,title,tspan,unknown,use,view",
    Ah = "annotation,annotation-xml,maction,maligngroup,malignmark,math,menclose,merror,mfenced,mfrac,mfraction,mglyph,mi,mlabeledtr,mlongdiv,mmultiscripts,mn,mo,mover,mpadded,mphantom,mprescripts,mroot,mrow,ms,mscarries,mscarry,msgroup,msline,mspace,msqrt,msrow,mstack,mstyle,msub,msubsup,msup,mtable,mtd,mtext,mtr,munder,munderover,none,semantics",
    Nh = fn(Rh),
    Mh = fn(wh),
    kh = fn(Ah),
    Lh = fn("itemscope,allowfullscreen,formnovalidate,ismap,nomodule,novalidate,readonly");

  function au(e) {
    return !!e || e === ""
  }

  function $h(e, t) {
    if (e.length !== t.length) return !1;
    let n = !0;
    for (let o = 0; n && o < e.length; o++) n = zn(e[o], t[o]);
    return n
  }

  function zn(e, t) {
    if (e === t) return !0;
    let n = ou(e),
      o = ou(t);
    if (n || o) return n && o ? e.getTime() === t.getTime() : !1;
    if (n = Vt(e), o = Vt(t), n || o) return e === t;
    if (n = ye(e), o = ye(t), n || o) return n && o ? $h(e, t) : !1;
    if (n = Me(e), o = Me(t), n || o) {
      if (!n || !o) return !1;
      const s = Object.keys(e).length,
        r = Object.keys(t).length;
      if (s !== r) return !1;
      for (const a in e) {
        const i = e.hasOwnProperty(a),
          l = t.hasOwnProperty(a);
        if (i && !l || !i && l || !zn(e[a], t[a])) return !1
      }
    }
    return String(e) === String(t)
  }

  function ni(e, t) {
    return e.findIndex(n => zn(n, t))
  }
  const lu = e => !!(e && e.__v_isRef === !0),
    j = e => ze(e) ? e : e == null ? "" : ye(e) || Me(e) && (e.toString === su || !be(e.toString)) ? lu(e) ? j(e.value) : JSON.stringify(e, uu, 2) : String(e),
    uu = (e, t) => lu(t) ? uu(e, t.value) : Hn(t) ? {
      [`Map(${t.size})`]: [...t.entries()].reduce((n, [o, s], r) => (n[oi(o, r) + " =>"] = s, n), {})
    } : ho(t) ? {
      [`Set(${t.size})`]: [...t.values()].map(n => oi(n))
    } : Vt(t) ? oi(t) : Me(t) && !ye(t) && !ru(t) ? String(t) : t,
    oi = (e, t = "") => {
      var n;
      return Vt(e) ? `Symbol(${(n=e.description)!=null?n:t})` : e
    };
  var xh = {
    NODE_ENV: '"production"'
  };

  function At(e, ...t) {
    console.warn(`[Vue warn] ${e}`, ...t)
  }
  let dt;
  class cu {
    constructor(t = !1) {
      this.detached = t, this._active = !0, this._on = 0, this.effects = [], this.cleanups = [], this._isPaused = !1, this.parent = dt, !t && dt && (this.index = (dt.scopes || (dt.scopes = [])).push(this) - 1)
    }
    get active() {
      return this._active
    }
    pause() {
      if (this._active) {
        this._isPaused = !0;
        let t, n;
        if (this.scopes)
          for (t = 0, n = this.scopes.length; t < n; t++) this.scopes[t].pause();
        for (t = 0, n = this.effects.length; t < n; t++) this.effects[t].pause()
      }
    }
    resume() {
      if (this._active && this._isPaused) {
        this._isPaused = !1;
        let t, n;
        if (this.scopes)
          for (t = 0, n = this.scopes.length; t < n; t++) this.scopes[t].resume();
        for (t = 0, n = this.effects.length; t < n; t++) this.effects[t].resume()
      }
    }
    run(t) {
      if (this._active) {
        const n = dt;
        try {
          return dt = this, t()
        } finally {
          dt = n
        }
      } else At("cannot run an inactive effect scope.")
    }
    on() {
      ++this._on === 1 && (this.prevScope = dt, dt = this)
    }
    off() {
      this._on > 0 && --this._on === 0 && (dt = this.prevScope, this.prevScope = void 0)
    }
    stop(t) {
      if (this._active) {
        this._active = !1;
        let n, o;
        for (n = 0, o = this.effects.length; n < o; n++) this.effects[n].stop();
        for (this.effects.length = 0, n = 0, o = this.cleanups.length; n < o; n++) this.cleanups[n]();
        if (this.cleanups.length = 0, this.scopes) {
          for (n = 0, o = this.scopes.length; n < o; n++) this.scopes[n].stop(!0);
          this.scopes.length = 0
        }
        if (!this.detached && this.parent && !t) {
          const s = this.parent.scopes.pop();
          s && s !== this && (this.parent.scopes[this.index] = s, s.index = this.index)
        }
        this.parent = void 0
      }
    }
  }

  function du(e) {
    return new cu(e)
  }

  function fu() {
    return dt
  }

  function si(e, t = !1) {
    dt ? dt.cleanups.push(e) : t || At("onScopeDispose() is called when there is no active effect scope to be associated with.")
  }
  let $e;
  const ri = new WeakSet;
  class pu {
    constructor(t) {
      this.fn = t, this.deps = void 0, this.depsTail = void 0, this.flags = 5, this.next = void 0, this.cleanup = void 0, this.scheduler = void 0, dt && dt.active && dt.effects.push(this)
    }
    pause() {
      this.flags |= 64
    }
    resume() {
      this.flags & 64 && (this.flags &= -65, ri.has(this) && (ri.delete(this), this.trigger()))
    }
    notify() {
      this.flags & 2 && !(this.flags & 32) || this.flags & 8 || hu(this)
    }
    run() {
      if (!(this.flags & 1)) return this.fn();
      this.flags |= 2, Cu(this), mu(this);
      const t = $e,
        n = Ht;
      $e = this, Ht = !0;
      try {
        return this.fn()
      } finally {
        $e !== this && At("Active effect was not restored correctly - this is likely a Vue internal bug."), vu(this), $e = t, Ht = n, this.flags &= -3
      }
    }
    stop() {
      if (this.flags & 1) {
        for (let t = this.deps; t; t = t.nextDep) ui(t);
        this.deps = this.depsTail = void 0, Cu(this), this.onStop && this.onStop(), this.flags &= -2
      }
    }
    trigger() {
      this.flags & 64 ? ri.add(this) : this.scheduler ? this.scheduler() : this.runIfDirty()
    }
    runIfDirty() {
      li(this) && this.run()
    }
    get dirty() {
      return li(this)
    }
  }
  let _u = 0,
    zo, Yo;

  function hu(e, t = !1) {
    if (e.flags |= 8, t) {
      e.next = Yo, Yo = e;
      return
    }
    e.next = zo, zo = e
  }

  function ii() {
    _u++
  }

  function ai() {
    if (--_u > 0) return;
    if (Yo) {
      let t = Yo;
      for (Yo = void 0; t;) {
        const n = t.next;
        t.next = void 0, t.flags &= -9, t = n
      }
    }
    let e;
    for (; zo;) {
      let t = zo;
      for (zo = void 0; t;) {
        const n = t.next;
        if (t.next = void 0, t.flags &= -9, t.flags & 1) try {
          t.trigger()
        } catch (o) {
          e || (e = o)
        }
        t = n
      }
    }
    if (e) throw e
  }

  function mu(e) {
    for (let t = e.deps; t; t = t.nextDep) t.version = -1, t.prevActiveLink = t.dep.activeLink, t.dep.activeLink = t
  }

  function vu(e) {
    let t, n = e.depsTail,
      o = n;
    for (; o;) {
      const s = o.prevDep;
      o.version === -1 ? (o === n && (n = s), ui(o), Fh(o)) : t = o, o.dep.activeLink = o.prevActiveLink, o.prevActiveLink = void 0, o = s
    }
    e.deps = t, e.depsTail = n
  }

  function li(e) {
    for (let t = e.deps; t; t = t.nextDep)
      if (t.dep.version !== t.version || t.dep.computed && (gu(t.dep.computed) || t.dep.version !== t.version)) return !0;
    return !!e._dirty
  }

  function gu(e) {
    if (e.flags & 4 && !(e.flags & 16) || (e.flags &= -17, e.globalVersion === Ko) || (e.globalVersion = Ko, !e.isSSR && e.flags & 128 && (!e.deps && !e._dirty || !li(e)))) return;
    e.flags |= 2;
    const t = e.dep,
      n = $e,
      o = Ht;
    $e = e, Ht = !0;
    try {
      mu(e);
      const s = e.fn(e._value);
      (t.version === 0 || An(s, e._value)) && (e.flags |= 128, e._value = s, t.version++)
    } catch (s) {
      throw t.version++, s
    } finally {
      $e = n, Ht = o, vu(e), e.flags &= -3
    }
  }

  function ui(e, t = !1) {
    const {
      dep: n,
      prevSub: o,
      nextSub: s
    } = e;
    if (o && (o.nextSub = s, e.prevSub = void 0), s && (s.prevSub = o, e.nextSub = void 0), n.subsHead === e && (n.subsHead = s), n.subs === e && (n.subs = o, !o && n.computed)) {
      n.computed.flags &= -5;
      for (let r = n.computed.deps; r; r = r.nextDep) ui(r, !0)
    }!t && !--n.sc && n.map && n.map.delete(n.key)
  }

  function Fh(e) {
    const {
      prevDep: t,
      nextDep: n
    } = e;
    t && (t.nextDep = n, e.prevDep = void 0), n && (n.prevDep = t, e.nextDep = void 0)
  }
  let Ht = !0;
  const yu = [];

  function Gt() {
    yu.push(Ht), Ht = !1
  }

  function jt() {
    const e = yu.pop();
    Ht = e === void 0 ? !0 : e
  }

  function Cu(e) {
    const {
      cleanup: t
    } = e;
    if (e.cleanup = void 0, t) {
      const n = $e;
      $e = void 0;
      try {
        t()
      } finally {
        $e = n
      }
    }
  }
  let Ko = 0;
  class Uh {
    constructor(t, n) {
      this.sub = t, this.dep = n, this.version = n.version, this.nextDep = this.prevDep = this.nextSub = this.prevSub = this.prevActiveLink = void 0
    }
  }
  class ci {
    constructor(t) {
      this.computed = t, this.version = 0, this.activeLink = void 0, this.subs = void 0, this.map = void 0, this.key = void 0, this.sc = 0, this.__v_skip = !0, this.subsHead = void 0
    }
    track(t) {
      if (!$e || !Ht || $e === this.computed) return;
      let n = this.activeLink;
      if (n === void 0 || n.sub !== $e) n = this.activeLink = new Uh($e, this), $e.deps ? (n.prevDep = $e.depsTail, $e.depsTail.nextDep = n, $e.depsTail = n) : $e.deps = $e.depsTail = n, Tu(n);
      else if (n.version === -1 && (n.version = this.version, n.nextDep)) {
        const o = n.nextDep;
        o.prevDep = n.prevDep, n.prevDep && (n.prevDep.nextDep = o), n.prevDep = $e.depsTail, n.nextDep = void 0, $e.depsTail.nextDep = n, $e.depsTail = n, $e.deps === n && ($e.deps = o)
      }
      return $e.onTrack && $e.onTrack(Qe({
        effect: $e
      }, t)), n
    }
    trigger(t) {
      this.version++, Ko++, this.notify(t)
    }
    notify(t) {
      ii();
      try {
        if (xh.NODE_ENV !== "production")
          for (let n = this.subsHead; n; n = n.nextSub) n.sub.onTrigger && !(n.sub.flags & 8) && n.sub.onTrigger(Qe({
            effect: n.sub
          }, t));
        for (let n = this.subs; n; n = n.prevSub) n.sub.notify() && n.sub.dep.notify()
      } finally {
        ai()
      }
    }
  }

  function Tu(e) {
    if (e.dep.sc++, e.sub.flags & 4) {
      const t = e.dep.computed;
      if (t && !e.dep.subs) {
        t.flags |= 20;
        for (let o = t.deps; o; o = o.nextDep) Tu(o)
      }
      const n = e.dep.subs;
      n !== e && (e.prevSub = n, n && (n.nextSub = e)), e.dep.subsHead === void 0 && (e.dep.subsHead = e), e.dep.subs = e
    }
  }
  const Hs = new WeakMap,
    Yn = Symbol("Object iterate"),
    di = Symbol("Map keys iterate"),
    Wo = Symbol("Array iterate");

  function nt(e, t, n) {
    if (Ht && $e) {
      let o = Hs.get(e);
      o || Hs.set(e, o = new Map);
      let s = o.get(n);
      s || (o.set(n, s = new ci), s.map = o, s.key = n), s.track({
        target: e,
        type: t,
        key: n
      })
    }
  }

  function Xt(e, t, n, o, s, r) {
    const a = Hs.get(e);
    if (!a) {
      Ko++;
      return
    }
    const i = l => {
      l && l.trigger({
        target: e,
        type: t,
        key: n,
        newValue: o,
        oldValue: s,
        oldTarget: r
      })
    };
    if (ii(), t === "clear") a.forEach(i);
    else {
      const l = ye(e),
        c = l && ti(n);
      if (l && n === "length") {
        const u = Number(o);
        a.forEach((d, h) => {
          (h === "length" || h === Wo || !Vt(h) && h >= u) && i(d)
        })
      } else switch ((n !== void 0 || a.has(void 0)) && i(a.get(n)), c && i(a.get(Wo)), t) {
        case "add":
          l ? c && i(a.get("length")) : (i(a.get(Yn)), Hn(e) && i(a.get(di)));
          break;
        case "delete":
          l || (i(a.get(Yn)), Hn(e) && i(a.get(di)));
          break;
        case "set":
          Hn(e) && i(a.get(Yn));
          break
      }
    }
    ai()
  }

  function Bh(e, t) {
    const n = Hs.get(e);
    return n && n.get(t)
  }

  function vo(e) {
    const t = De(e);
    return t === e ? t : (nt(t, "iterate", Wo), mt(e) ? t : t.map(it))
  }

  function Gs(e) {
    return nt(e = De(e), "iterate", Wo), e
  }
  const Vh = {
    __proto__: null,
    [Symbol.iterator]() {
      return fi(this, Symbol.iterator, it)
    },
    concat(...e) {
      return vo(this).concat(...e.map(t => ye(t) ? vo(t) : t))
    },
    entries() {
      return fi(this, "entries", e => (e[1] = it(e[1]), e))
    },
    every(e, t) {
      return pn(this, "every", e, t, void 0, arguments)
    },
    filter(e, t) {
      return pn(this, "filter", e, t, n => n.map(it), arguments)
    },
    find(e, t) {
      return pn(this, "find", e, t, it, arguments)
    },
    findIndex(e, t) {
      return pn(this, "findIndex", e, t, void 0, arguments)
    },
    findLast(e, t) {
      return pn(this, "findLast", e, t, it, arguments)
    },
    findLastIndex(e, t) {
      return pn(this, "findLastIndex", e, t, void 0, arguments)
    },
    forEach(e, t) {
      return pn(this, "forEach", e, t, void 0, arguments)
    },
    includes(...e) {
      return pi(this, "includes", e)
    },
    indexOf(...e) {
      return pi(this, "indexOf", e)
    },
    join(e) {
      return vo(this).join(e)
    },
    lastIndexOf(...e) {
      return pi(this, "lastIndexOf", e)
    },
    map(e, t) {
      return pn(this, "map", e, t, void 0, arguments)
    },
    pop() {
      return qo(this, "pop")
    },
    push(...e) {
      return qo(this, "push", e)
    },
    reduce(e, ...t) {
      return bu(this, "reduce", e, t)
    },
    reduceRight(e, ...t) {
      return bu(this, "reduceRight", e, t)
    },
    shift() {
      return qo(this, "shift")
    },
    some(e, t) {
      return pn(this, "some", e, t, void 0, arguments)
    },
    splice(...e) {
      return qo(this, "splice", e)
    },
    toReversed() {
      return vo(this).toReversed()
    },
    toSorted(e) {
      return vo(this).toSorted(e)
    },
    toSpliced(...e) {
      return vo(this).toSpliced(...e)
    },
    unshift(...e) {
      return qo(this, "unshift", e)
    },
    values() {
      return fi(this, "values", it)
    }
  };

  function fi(e, t, n) {
    const o = Gs(e),
      s = o[t]();
    return o !== e && !mt(e) && (s._next = s.next, s.next = () => {
      const r = s._next();
      return r.value && (r.value = n(r.value)), r
    }), s
  }
  const Hh = Array.prototype;

  function pn(e, t, n, o, s, r) {
    const a = Gs(e),
      i = a !== e && !mt(e),
      l = a[t];
    if (l !== Hh[t]) {
      const d = l.apply(e, r);
      return i ? it(d) : d
    }
    let c = n;
    a !== e && (i ? c = function(d, h) {
      return n.call(this, it(d), h, e)
    } : n.length > 2 && (c = function(d, h) {
      return n.call(this, d, h, e)
    }));
    const u = l.call(a, c, o);
    return i && s ? s(u) : u
  }

  function bu(e, t, n, o) {
    const s = Gs(e);
    let r = n;
    return s !== e && (mt(e) ? n.length > 3 && (r = function(a, i, l) {
      return n.call(this, a, i, l, e)
    }) : r = function(a, i, l) {
      return n.call(this, a, it(i), l, e)
    }), s[t](r, ...o)
  }

  function pi(e, t, n) {
    const o = De(e);
    nt(o, "iterate", Wo);
    const s = o[t](...n);
    return (s === -1 || s === !1) && Qo(n[0]) ? (n[0] = De(n[0]), o[t](...n)) : s
  }

  function qo(e, t, n = []) {
    Gt(), ii();
    const o = De(e)[t].apply(e, n);
    return ai(), jt(), o
  }
  const Gh = fn("__proto__,__v_isRef,__isVue"),
    Su = new Set(Object.getOwnPropertyNames(Symbol).filter(e => e !== "arguments" && e !== "caller").map(e => Symbol[e]).filter(Vt));

  function jh(e) {
    Vt(e) || (e = String(e));
    const t = De(this);
    return nt(t, "has", e), t.hasOwnProperty(e)
  }
  class Du {
    constructor(t = !1, n = !1) {
      this._isReadonly = t, this._isShallow = n
    }
    get(t, n, o) {
      if (n === "__v_skip") return t.__v_skip;
      const s = this._isReadonly,
        r = this._isShallow;
      if (n === "__v_isReactive") return !s;
      if (n === "__v_isReadonly") return s;
      if (n === "__v_isShallow") return r;
      if (n === "__v_raw") return o === (s ? r ? Au : wu : r ? Ru : Iu).get(t) || Object.getPrototypeOf(t) === Object.getPrototypeOf(o) ? t : void 0;
      const a = ye(t);
      if (!s) {
        let l;
        if (a && (l = Vh[n])) return l;
        if (n === "hasOwnProperty") return jh
      }
      const i = Reflect.get(t, n, Fe(t) ? t : o);
      return (Vt(n) ? Su.has(n) : Gh(n)) || (s || nt(t, "get", n), r) ? i : Fe(i) ? a && ti(n) ? i : i.value : Me(i) ? s ? Ks(i) : xe(i) : i
    }
  }
  class Pu extends Du {
    constructor(t = !1) {
      super(!1, t)
    }
    set(t, n, o, s) {
      let r = t[n];
      if (!this._isShallow) {
        const l = Jt(r);
        if (!mt(o) && !Jt(o) && (r = De(r), o = De(o)), !ye(t) && Fe(r) && !Fe(o)) return l ? (At(`Set operation on key "${String(n)}" failed: target is readonly.`, t[n]), !0) : (r.value = o, !0)
      }
      const a = ye(t) && ti(n) ? Number(n) < t.length : Ae(t, n),
        i = Reflect.set(t, n, o, Fe(t) ? t : s);
      return t === De(s) && (a ? An(o, r) && Xt(t, "set", n, o, r) : Xt(t, "add", n, o)), i
    }
    deleteProperty(t, n) {
      const o = Ae(t, n),
        s = t[n],
        r = Reflect.deleteProperty(t, n);
      return r && o && Xt(t, "delete", n, void 0, s), r
    }
    has(t, n) {
      const o = Reflect.has(t, n);
      return (!Vt(n) || !Su.has(n)) && nt(t, "has", n), o
    }
    ownKeys(t) {
      return nt(t, "iterate", ye(t) ? "length" : Yn), Reflect.ownKeys(t)
    }
  }
  class Eu extends Du {
    constructor(t = !1) {
      super(!0, t)
    }
    set(t, n) {
      return At(`Set operation on key "${String(n)}" failed: target is readonly.`, t), !0
    }
    deleteProperty(t, n) {
      return At(`Delete operation on key "${String(n)}" failed: target is readonly.`, t), !0
    }
  }
  const zh = new Pu,
    Yh = new Eu,
    Kh = new Pu(!0),
    Wh = new Eu(!0),
    _i = e => e,
    js = e => Reflect.getPrototypeOf(e);

  function qh(e, t, n) {
    return function(...o) {
      const s = this.__v_raw,
        r = De(s),
        a = Hn(r),
        i = e === "entries" || e === Symbol.iterator && a,
        l = e === "keys" && a,
        c = s[e](...o),
        u = n ? _i : t ? qs : it;
      return !t && nt(r, "iterate", l ? di : Yn), {
        next() {
          const {
            value: d,
            done: h
          } = c.next();
          return h ? {
            value: d,
            done: h
          } : {
            value: i ? [u(d[0]), u(d[1])] : u(d),
            done: h
          }
        },
        [Symbol.iterator]() {
          return this
        }
      }
    }
  }

  function zs(e) {
    return function(...t) {
      {
        const n = t[0] ? `on key "${t[0]}" ` : "";
        At(`${Gn(e)} operation ${n}failed: target is readonly.`, De(this))
      }
      return e === "delete" ? !1 : e === "clear" ? void 0 : this
    }
  }

  function Qh(e, t) {
    const n = {
      get(s) {
        const r = this.__v_raw,
          a = De(r),
          i = De(s);
        e || (An(s, i) && nt(a, "get", s), nt(a, "get", i));
        const {
          has: l
        } = js(a), c = t ? _i : e ? qs : it;
        if (l.call(a, s)) return c(r.get(s));
        if (l.call(a, i)) return c(r.get(i));
        r !== a && r.get(s)
      },
      get size() {
        const s = this.__v_raw;
        return !e && nt(De(s), "iterate", Yn), s.size
      },
      has(s) {
        const r = this.__v_raw,
          a = De(r),
          i = De(s);
        return e || (An(s, i) && nt(a, "has", s), nt(a, "has", i)), s === i ? r.has(s) : r.has(s) || r.has(i)
      },
      forEach(s, r) {
        const a = this,
          i = a.__v_raw,
          l = De(i),
          c = t ? _i : e ? qs : it;
        return !e && nt(l, "iterate", Yn), i.forEach((u, d) => s.call(r, c(u), c(d), a))
      }
    };
    return Qe(n, e ? {
      add: zs("add"),
      set: zs("set"),
      delete: zs("delete"),
      clear: zs("clear")
    } : {
      add(s) {
        !t && !mt(s) && !Jt(s) && (s = De(s));
        const r = De(this);
        return js(r).has.call(r, s) || (r.add(s), Xt(r, "add", s, s)), this
      },
      set(s, r) {
        !t && !mt(r) && !Jt(r) && (r = De(r));
        const a = De(this),
          {
            has: i,
            get: l
          } = js(a);
        let c = i.call(a, s);
        c ? Ou(a, i, s) : (s = De(s), c = i.call(a, s));
        const u = l.call(a, s);
        return a.set(s, r), c ? An(r, u) && Xt(a, "set", s, r, u) : Xt(a, "add", s, r), this
      },
      delete(s) {
        const r = De(this),
          {
            has: a,
            get: i
          } = js(r);
        let l = a.call(r, s);
        l ? Ou(r, a, s) : (s = De(s), l = a.call(r, s));
        const c = i ? i.call(r, s) : void 0,
          u = r.delete(s);
        return l && Xt(r, "delete", s, void 0, c), u
      },
      clear() {
        const s = De(this),
          r = s.size !== 0,
          a = Hn(s) ? new Map(s) : new Set(s),
          i = s.clear();
        return r && Xt(s, "clear", void 0, void 0, a), i
      }
    }), ["keys", "values", "entries", Symbol.iterator].forEach(s => {
      n[s] = qh(s, e, t)
    }), n
  }

  function Ys(e, t) {
    const n = Qh(e, t);
    return (o, s, r) => s === "__v_isReactive" ? !e : s === "__v_isReadonly" ? e : s === "__v_raw" ? o : Reflect.get(Ae(n, s) && s in o ? n : o, s, r)
  }
  const Xh = {
      get: Ys(!1, !1)
    },
    Jh = {
      get: Ys(!1, !0)
    },
    Zh = {
      get: Ys(!0, !1)
    },
    em = {
      get: Ys(!0, !0)
    };

  function Ou(e, t, n) {
    const o = De(n);
    if (o !== n && t.call(e, o)) {
      const s = ei(e);
      At(`Reactive ${s} contains both the raw and reactive versions of the same object${s==="Map"?" as keys":""}, which can lead to inconsistencies. Avoid differentiating between the raw and reactive versions of an object and only use the reactive version if possible.`)
    }
  }
  const Iu = new WeakMap,
    Ru = new WeakMap,
    wu = new WeakMap,
    Au = new WeakMap;

  function tm(e) {
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
        return 0
    }
  }

  function nm(e) {
    return e.__v_skip || !Object.isExtensible(e) ? 0 : tm(ei(e))
  }

  function xe(e) {
    return Jt(e) ? e : Ws(e, !1, zh, Xh, Iu)
  }

  function hi(e) {
    return Ws(e, !1, Kh, Jh, Ru)
  }

  function Ks(e) {
    return Ws(e, !0, Yh, Zh, wu)
  }

  function Lt(e) {
    return Ws(e, !0, Wh, em, Au)
  }

  function Ws(e, t, n, o, s) {
    if (!Me(e)) return At(`value cannot be made ${t?"readonly":"reactive"}: ${String(e)}`), e;
    if (e.__v_raw && !(t && e.__v_isReactive)) return e;
    const r = nm(e);
    if (r === 0) return e;
    const a = s.get(e);
    if (a) return a;
    const i = new Proxy(e, r === 2 ? o : n);
    return s.set(e, i), i
  }

  function zt(e) {
    return Jt(e) ? zt(e.__v_raw) : !!(e && e.__v_isReactive)
  }

  function Jt(e) {
    return !!(e && e.__v_isReadonly)
  }

  function mt(e) {
    return !!(e && e.__v_isShallow)
  }

  function Qo(e) {
    return e ? !!e.__v_raw : !1
  }

  function De(e) {
    const t = e && e.__v_raw;
    return t ? De(t) : e
  }

  function _n(e) {
    return !Ae(e, "__v_skip") && Object.isExtensible(e) && Bs(e, "__v_skip", !0), e
  }
  const it = e => Me(e) ? xe(e) : e,
    qs = e => Me(e) ? Ks(e) : e;

  function Fe(e) {
    return e ? e.__v_isRef === !0 : !1
  }

  function H(e) {
    return om(e, !1)
  }

  function om(e, t) {
    return Fe(e) ? e : new sm(e, t)
  }
  class sm {
    constructor(t, n) {
      this.dep = new ci, this.__v_isRef = !0, this.__v_isShallow = !1, this._rawValue = n ? t : De(t), this._value = n ? t : it(t), this.__v_isShallow = n
    }
    get value() {
      return this.dep.track({
        target: this,
        type: "get",
        key: "value"
      }), this._value
    }
    set value(t) {
      const n = this._rawValue,
        o = this.__v_isShallow || mt(t) || Jt(t);
      t = o ? t : De(t), An(t, n) && (this._rawValue = t, this._value = o ? t : it(t), this.dep.trigger({
        target: this,
        type: "set",
        key: "value",
        newValue: t,
        oldValue: n
      }))
    }
  }

  function T(e) {
    return Fe(e) ? e.value : e
  }
  const rm = {
    get: (e, t, n) => t === "__v_raw" ? e : T(Reflect.get(e, t, n)),
    set: (e, t, n, o) => {
      const s = e[t];
      return Fe(s) && !Fe(n) ? (s.value = n, !0) : Reflect.set(e, t, n, o)
    }
  };

  function Nu(e) {
    return zt(e) ? e : new Proxy(e, rm)
  }

  function Qs(e) {
    Qo(e) || At("toRefs() expects a reactive object but received a plain one.");
    const t = ye(e) ? new Array(e.length) : {};
    for (const n in e) t[n] = Mu(e, n);
    return t
  }
  class im {
    constructor(t, n, o) {
      this._object = t, this._key = n, this._defaultValue = o, this.__v_isRef = !0, this._value = void 0
    }
    get value() {
      const t = this._object[this._key];
      return this._value = t === void 0 ? this._defaultValue : t
    }
    set value(t) {
      this._object[this._key] = t
    }
    get dep() {
      return Bh(De(this._object), this._key)
    }
  }
  class am {
    constructor(t) {
      this._getter = t, this.__v_isRef = !0, this.__v_isReadonly = !0, this._value = void 0
    }
    get value() {
      return this._value = this._getter()
    }
  }

  function Xs(e, t, n) {
    return Fe(e) ? e : be(e) ? new am(e) : Me(e) && arguments.length > 1 ? Mu(e, t, n) : H(e)
  }

  function Mu(e, t, n) {
    const o = e[t];
    return Fe(o) ? o : new im(e, t, n)
  }
  class lm {
    constructor(t, n, o) {
      this.fn = t, this.setter = n, this._value = void 0, this.dep = new ci(this), this.__v_isRef = !0, this.deps = void 0, this.depsTail = void 0, this.flags = 16, this.globalVersion = Ko - 1, this.next = void 0, this.effect = this, this.__v_isReadonly = !n, this.isSSR = o
    }
    notify() {
      if (this.flags |= 16, !(this.flags & 8) && $e !== this) return hu(this, !0), !0
    }
    get value() {
      const t = this.dep.track({
        target: this,
        type: "get",
        key: "value"
      });
      return gu(this), t && (t.version = this.dep.version), this._value
    }
    set value(t) {
      this.setter ? this.setter(t) : At("Write operation failed: computed value is readonly")
    }
  }

  function um(e, t, n = !1) {
    let o, s;
    return be(e) ? o = e : (o = e.get, s = e.set), new lm(o, s, n)
  }
  const Js = {},
    Zs = new WeakMap;
  let Kn;

  function cm(e, t = !1, n = Kn) {
    if (n) {
      let o = Zs.get(n);
      o || Zs.set(n, o = []), o.push(e)
    } else t || At("onWatcherCleanup() was called when there was no active watcher to associate with.")
  }

  function dm(e, t, n = Le) {
    const {
      immediate: o,
      deep: s,
      once: r,
      scheduler: a,
      augmentJob: i,
      call: l
    } = n, c = D => {
      (n.onWarn || At)("Invalid watch source: ", D, "A watch source can only be a getter/effect function, a ref, a reactive object, or an array of these types.")
    }, u = D => s ? D : mt(D) || s === !1 || s === 0 ? hn(D, 1) : hn(D);
    let d, h, f, _, p = !1,
      m = !1;
    if (Fe(e) ? (h = () => e.value, p = mt(e)) : zt(e) ? (h = () => u(e), p = !0) : ye(e) ? (m = !0, p = e.some(D => zt(D) || mt(D)), h = () => e.map(D => {
        if (Fe(D)) return D.value;
        if (zt(D)) return u(D);
        if (be(D)) return l ? l(D, 2) : D();
        c(D)
      })) : be(e) ? t ? h = l ? () => l(e, 2) : e : h = () => {
        if (f) {
          Gt();
          try {
            f()
          } finally {
            jt()
          }
        }
        const D = Kn;
        Kn = d;
        try {
          return l ? l(e, 3, [_]) : e(_)
        } finally {
          Kn = D
        }
      } : (h = ct, c(e)), t && s) {
      const D = h,
        O = s === !0 ? 1 / 0 : s;
      h = () => hn(D(), O)
    }
    const v = fu(),
      E = () => {
        d.stop(), v && v.active && Jr(v.effects, d)
      };
    if (r && t) {
      const D = t;
      t = (...O) => {
        D(...O), E()
      }
    }
    let k = m ? new Array(e.length).fill(Js) : Js;
    const N = D => {
      if (!(!(d.flags & 1) || !d.dirty && !D))
        if (t) {
          const O = d.run();
          if (s || p || (m ? O.some((A, b) => An(A, k[b])) : An(O, k))) {
            f && f();
            const A = Kn;
            Kn = d;
            try {
              const b = [O, k === Js ? void 0 : m && k[0] === Js ? [] : k, _];
              k = O, l ? l(t, 3, b) : t(...b)
            } finally {
              Kn = A
            }
          }
        } else d.run()
    };
    return i && i(N), d = new pu(h), d.scheduler = a ? () => a(N, !1) : N, _ = D => cm(D, !1, d), f = d.onStop = () => {
      const D = Zs.get(d);
      if (D) {
        if (l) l(D, 4);
        else
          for (const O of D) O();
        Zs.delete(d)
      }
    }, d.onTrack = n.onTrack, d.onTrigger = n.onTrigger, t ? o ? N(!0) : k = d.run() : a ? a(N.bind(null, !0), !0) : d.run(), E.pause = d.pause.bind(d), E.resume = d.resume.bind(d), E.stop = E, E
  }

  function hn(e, t = 1 / 0, n) {
    if (t <= 0 || !Me(e) || e.__v_skip || (n = n || new Map, (n.get(e) || 0) >= t)) return e;
    if (n.set(e, t), t--, Fe(e)) hn(e.value, t, n);
    else if (ye(e))
      for (let o = 0; o < e.length; o++) hn(e[o], t, n);
    else if (ho(e) || Hn(e)) e.forEach(o => {
      hn(o, t, n)
    });
    else if (ru(e)) {
      for (const o in e) hn(e[o], t, n);
      for (const o of Object.getOwnPropertySymbols(e)) Object.prototype.propertyIsEnumerable.call(e, o) && hn(e[o], t, n)
    }
    return e
  }
  var Nn = {
    NODE_ENV: '"production"'
  };
  const Wn = [];

  function er(e) {
    Wn.push(e)
  }

  function tr() {
    Wn.pop()
  }
  let mi = !1;

  function te(e, ...t) {
    if (mi) return;
    mi = !0, Gt();
    const n = Wn.length ? Wn[Wn.length - 1].component : null,
      o = n && n.appContext.config.warnHandler,
      s = fm();
    if (o) go(o, n, 11, [e + t.map(r => {
      var a, i;
      return (i = (a = r.toString) == null ? void 0 : a.call(r)) != null ? i : JSON.stringify(r)
    }).join(""), n && n.proxy, s.map(({
      vnode: r
    }) => `at <${yr(n,r.type)}>`).join(`
`), s]);
    else {
      const r = [`[Vue warn]: ${e}`, ...t];
      s.length && r.push(`
`, ...pm(s)), console.warn(...r)
    }
    jt(), mi = !1
  }

  function fm() {
    let e = Wn[Wn.length - 1];
    if (!e) return [];
    const t = [];
    for (; e;) {
      const n = t[0];
      n && n.vnode === e ? n.recurseCount++ : t.push({
        vnode: e,
        recurseCount: 0
      });
      const o = e.component && e.component.parent;
      e = o && o.vnode
    }
    return t
  }

  function pm(e) {
    const t = [];
    return e.forEach((n, o) => {
      t.push(...o === 0 ? [] : [`
`], ..._m(n))
    }), t
  }

  function _m({
    vnode: e,
    recurseCount: t
  }) {
    const n = t > 0 ? `... (${t} recursive calls)` : "",
      o = e.component ? e.component.parent == null : !1,
      s = ` at <${yr(e.component,e.type,o)}`,
      r = ">" + n;
    return e.props ? [s, ...hm(e.props), r] : [s + r]
  }

  function hm(e) {
    const t = [],
      n = Object.keys(e);
    return n.slice(0, 3).forEach(o => {
      t.push(...ku(o, e[o]))
    }), n.length > 3 && t.push(" ..."), t
  }

  function ku(e, t, n) {
    return ze(t) ? (t = JSON.stringify(t), n ? t : [`${e}=${t}`]) : typeof t == "number" || typeof t == "boolean" || t == null ? n ? t : [`${e}=${t}`] : Fe(t) ? (t = ku(e, De(t.value), !0), n ? t : [`${e}=Ref<`, t, ">"]) : be(t) ? [`${e}=fn${t.name?`<${t.name}>`:""}`] : (t = De(t), n ? t : [`${e}=`, t])
  }
  const vi = {
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

  function go(e, t, n, o) {
    try {
      return o ? e(...o) : e()
    } catch (s) {
      yo(s, t, n)
    }
  }

  function Zt(e, t, n, o) {
    if (be(e)) {
      const s = go(e, t, n, o);
      return s && Zr(s) && s.catch(r => {
        yo(r, t, n)
      }), s
    }
    if (ye(e)) {
      const s = [];
      for (let r = 0; r < e.length; r++) s.push(Zt(e[r], t, n, o));
      return s
    } else te(`Invalid value type passed to callWithAsyncErrorHandling(): ${typeof e}`)
  }

  function yo(e, t, n, o = !0) {
    const s = t ? t.vnode : null,
      {
        errorHandler: r,
        throwUnhandledErrorInProduction: a
      } = t && t.appContext.config || Le;
    if (t) {
      let i = t.parent;
      const l = t.proxy,
        c = vi[n];
      for (; i;) {
        const u = i.ec;
        if (u) {
          for (let d = 0; d < u.length; d++)
            if (u[d](e, l, c) === !1) return
        }
        i = i.parent
      }
      if (r) {
        Gt(), go(r, null, 10, [e, l, c]), jt();
        return
      }
    }
    mm(e, n, s, o, a)
  }

  function mm(e, t, n, o = !0, s = !1) {
    {
      const r = vi[t];
      if (n && er(n), te(`Unhandled error${r?` during execution of ${r}`:""}`), n && tr(), o) throw e;
      console.error(e)
    }
  }
  const vt = [];
  let en = -1;
  const Co = [];
  let Mn = null,
    To = 0;
  const Lu = Promise.resolve();
  let nr = null;
  const vm = 100;

  function Xo(e) {
    const t = nr || Lu;
    return e ? t.then(this ? e.bind(this) : e) : t
  }

  function gm(e) {
    let t = en + 1,
      n = vt.length;
    for (; t < n;) {
      const o = t + n >>> 1,
        s = vt[o],
        r = Jo(s);
      r < e || r === e && s.flags & 2 ? t = o + 1 : n = o
    }
    return t
  }

  function or(e) {
    if (!(e.flags & 1)) {
      const t = Jo(e),
        n = vt[vt.length - 1];
      !n || !(e.flags & 2) && t >= Jo(n) ? vt.push(e) : vt.splice(gm(t), 0, e), e.flags |= 1, $u()
    }
  }

  function $u() {
    nr || (nr = Lu.then(Bu))
  }

  function xu(e) {
    ye(e) ? Co.push(...e) : Mn && e.id === -1 ? Mn.splice(To + 1, 0, e) : e.flags & 1 || (Co.push(e), e.flags |= 1), $u()
  }

  function Fu(e, t, n = en + 1) {
    for (t = t || new Map; n < vt.length; n++) {
      const o = vt[n];
      if (o && o.flags & 2) {
        if (e && o.id !== e.uid || gi(t, o)) continue;
        vt.splice(n, 1), n--, o.flags & 4 && (o.flags &= -2), o(), o.flags & 4 || (o.flags &= -2)
      }
    }
  }

  function Uu(e) {
    if (Co.length) {
      const t = [...new Set(Co)].sort((n, o) => Jo(n) - Jo(o));
      if (Co.length = 0, Mn) {
        Mn.push(...t);
        return
      }
      for (Mn = t, e = e || new Map, To = 0; To < Mn.length; To++) {
        const n = Mn[To];
        gi(e, n) || (n.flags & 4 && (n.flags &= -2), n.flags & 8 || n(), n.flags &= -2)
      }
      Mn = null, To = 0
    }
  }
  const Jo = e => e.id == null ? e.flags & 2 ? -1 : 1 / 0 : e.id;

  function Bu(e) {
    e = e || new Map;
    const t = n => gi(e, n);
    try {
      for (en = 0; en < vt.length; en++) {
        const n = vt[en];
        if (n && !(n.flags & 8)) {
          if (Nn.NODE_ENV !== "production" && t(n)) continue;
          n.flags & 4 && (n.flags &= -2), go(n, n.i, n.i ? 15 : 14), n.flags & 4 || (n.flags &= -2)
        }
      }
    } finally {
      for (; en < vt.length; en++) {
        const n = vt[en];
        n && (n.flags &= -2)
      }
      en = -1, vt.length = 0, Uu(e), nr = null, (vt.length || Co.length) && Bu(e)
    }
  }

  function gi(e, t) {
    const n = e.get(t) || 0;
    if (n > vm) {
      const o = t.i,
        s = o && gr(o.type);
      return yo(`Maximum recursive updates exceeded${s?` in component <${s}>`:""}. This means you have a reactive effect that is mutating its own dependencies and thus recursively triggering itself. Possible sources include component template, render function, updated hook or watcher source function.`, null, 10), !0
    }
    return e.set(t, n + 1), !1
  }
  let tn = !1;
  const sr = new Map;
  {
    const e = jo();
    e.__VUE_HMR_RUNTIME__ || (e.__VUE_HMR_RUNTIME__ = {
      createRecord: yi(Vu),
      rerender: yi(Tm),
      reload: yi(bm)
    })
  }
  const qn = new Map;

  function ym(e) {
    const t = e.type.__hmrId;
    let n = qn.get(t);
    n || (Vu(t, e.type), n = qn.get(t)), n.instances.add(e)
  }

  function Cm(e) {
    qn.get(e.type.__hmrId).instances.delete(e)
  }

  function Vu(e, t) {
    return qn.has(e) ? !1 : (qn.set(e, {
      initialDef: rr(t),
      instances: new Set
    }), !0)
  }

  function rr(e) {
    return Bc(e) ? e.__vccOpts : e
  }

  function Tm(e, t) {
    const n = qn.get(e);
    n && (n.initialDef.render = t, [...n.instances].forEach(o => {
      t && (o.render = t, rr(o.type).render = t), o.renderCache = [], tn = !0, o.job.flags & 8 || o.update(), tn = !1
    }))
  }

  function bm(e, t) {
    const n = qn.get(e);
    if (!n) return;
    t = rr(t), Hu(n.initialDef, t);
    const o = [...n.instances];
    for (let s = 0; s < o.length; s++) {
      const r = o[s],
        a = rr(r.type);
      let i = sr.get(a);
      i || (a !== n.initialDef && Hu(a, t), sr.set(a, i = new Set)), i.add(r), r.appContext.propsCache.delete(r.type), r.appContext.emitsCache.delete(r.type), r.appContext.optionsCache.delete(r.type), r.ceReload ? (i.add(r), r.ceReload(t.styles), i.delete(r)) : r.parent ? or(() => {
        r.job.flags & 8 || (tn = !0, r.parent.update(), tn = !1, i.delete(r))
      }) : r.appContext.reload ? r.appContext.reload() : typeof window < "u" ? window.location.reload() : console.warn("[HMR] Root or manually mounted instance modified. Full reload required."), r.root.ce && r !== r.root && r.root.ce._removeChildStyle(a)
    }
    xu(() => {
      sr.clear()
    })
  }

  function Hu(e, t) {
    Qe(e, t);
    for (const n in e) n !== "__file" && !(n in t) && delete e[n]
  }

  function yi(e) {
    return (t, n) => {
      try {
        return e(t, n)
      } catch (o) {
        console.error(o), console.warn("[HMR] Something went wrong during Vue component hot-reload. Full reload required.")
      }
    }
  }
  let nn, Zo = [],
    Ci = !1;

  function es(e, ...t) {
    nn ? nn.emit(e, ...t) : Ci || Zo.push({
      event: e,
      args: t
    })
  }

  function Gu(e, t) {
    var n, o;
    nn = e, nn ? (nn.enabled = !0, Zo.forEach(({
      event: s,
      args: r
    }) => nn.emit(s, ...r)), Zo = []) : typeof window < "u" && window.HTMLElement && !((o = (n = window.navigator) == null ? void 0 : n.userAgent) != null && o.includes("jsdom")) ? ((t.__VUE_DEVTOOLS_HOOK_REPLAY__ = t.__VUE_DEVTOOLS_HOOK_REPLAY__ || []).push(r => {
      Gu(r, t)
    }), setTimeout(() => {
      nn || (t.__VUE_DEVTOOLS_HOOK_REPLAY__ = null, Ci = !0, Zo = [])
    }, 3e3)) : (Ci = !0, Zo = [])
  }

  function Sm(e, t) {
    es("app:init", e, t, {
      Fragment: J,
      Text: is,
      Comment: It,
      Static: as
    })
  }

  function Dm(e) {
    es("app:unmount", e)
  }
  const Pm = Ti("component:added"),
    ju = Ti("component:updated"),
    Em = Ti("component:removed"),
    Om = e => {
      nn && typeof nn.cleanupBuffer == "function" && !nn.cleanupBuffer(e) && Em(e)
    };

  function Ti(e) {
    return t => {
      es(e, t.appContext.app, t.uid, t.parent ? t.parent.uid : void 0, t)
    }
  }
  const Im = zu("perf:start"),
    Rm = zu("perf:end");

  function zu(e) {
    return (t, n, o) => {
      es(e, t.appContext.app, t.uid, t, n, o)
    }
  }

  function wm(e, t, n) {
    es("component:emit", e.appContext.app, e, t, n)
  }
  let Xe = null,
    Yu = null;

  function ir(e) {
    const t = Xe;
    return Xe = e, Yu = e && e.type.__scopeId || null, t
  }

  function ce(e, t = Xe, n) {
    if (!t || e._n) return e;
    const o = (...s) => {
      o._d && Nc(-1);
      const r = ir(t);
      let a;
      try {
        a = e(...s)
      } finally {
        ir(r), o._d && Nc(1)
      }
      return ju(t), a
    };
    return o._n = !0, o._c = !0, o._d = !0, o
  }

  function Ku(e) {
    bh(e) && te("Do not use built-in directive ids as custom directive id: " + e)
  }

  function de(e, t) {
    if (Xe === null) return te("withDirectives can only be used inside render functions."), e;
    const n = vr(Xe),
      o = e.dirs || (e.dirs = []);
    for (let s = 0; s < t.length; s++) {
      let [r, a, i, l = Le] = t[s];
      r && (be(r) && (r = {
        mounted: r,
        updated: r
      }), r.deep && hn(a), o.push({
        dir: r,
        instance: n,
        value: a,
        oldValue: void 0,
        arg: i,
        modifiers: l
      }))
    }
    return e
  }

  function Qn(e, t, n, o) {
    const s = e.dirs,
      r = t && t.dirs;
    for (let a = 0; a < s.length; a++) {
      const i = s[a];
      r && (i.oldValue = r[a].value);
      let l = i.dir[o];
      l && (Gt(), Zt(l, n, 8, [e.el, i, e, t]), jt())
    }
  }
  const Am = Symbol("_vte"),
    Nm = e => e.__isTeleport,
    Mm = Symbol("_leaveCb");

  function bi(e, t) {
    e.shapeFlag & 6 && e.component ? (e.transition = t, bi(e.component.subTree, t)) : e.shapeFlag & 128 ? (e.ssContent.transition = t.clone(e.ssContent), e.ssFallback.transition = t.clone(e.ssFallback)) : e.transition = t
  }

  function re(e, t) {
    return be(e) ? Qe({
      name: e.name
    }, t, {
      setup: e
    }) : e
  }

  function Si(e) {
    e.ids = [e.ids[0] + e.ids[2]++ + "-", 0, 0]
  }
  const Wu = new WeakSet,
    ar = new WeakMap;

  function ts(e, t, n, o, s = !1) {
    if (ye(e)) {
      e.forEach((p, m) => ts(p, t && (ye(t) ? t[m] : t), n, o, s));
      return
    }
    if (bo(o) && !s) {
      o.shapeFlag & 512 && o.type.__asyncResolved && o.component.subTree.component && ts(e, t, n, o.component.subTree);
      return
    }
    const r = o.shapeFlag & 4 ? vr(o.component) : o.el,
      a = s ? null : r,
      {
        i,
        r: l
      } = e;
    if (!i) {
      te("Missing ref owner context. ref cannot be used on hoisted vnodes. A vnode with ref must be created inside the render function.");
      return
    }
    const c = t && t.r,
      u = i.refs === Le ? i.refs = {} : i.refs,
      d = i.setupState,
      h = De(d),
      f = d === Le ? nu : p => (Ae(h, p) && !Fe(h[p]) && te(`Template ref "${p}" used on a non-ref value. It will not work in the production build.`), Wu.has(h[p]) ? !1 : Ae(h, p)),
      _ = p => !Wu.has(p);
    if (c != null && c !== l) {
      if (qu(t), ze(c)) u[c] = null, f(c) && (d[c] = null);
      else if (Fe(c)) {
        _(c) && (c.value = null);
        const p = t;
        p.k && (u[p.k] = null)
      }
    }
    if (be(l)) go(l, i, 12, [a, u]);
    else {
      const p = ze(l),
        m = Fe(l);
      if (p || m) {
        const v = () => {
          if (e.f) {
            const E = p ? f(l) ? d[l] : u[l] : _(l) || !e.k ? l.value : u[e.k];
            if (s) ye(E) && Jr(E, r);
            else if (ye(E)) E.includes(r) || E.push(r);
            else if (p) u[l] = [r], f(l) && (d[l] = u[l]);
            else {
              const k = [r];
              _(l) && (l.value = k), e.k && (u[e.k] = k)
            }
          } else p ? (u[l] = a, f(l) && (d[l] = a)) : m ? (_(l) && (l.value = a), e.k && (u[e.k] = a)) : te("Invalid template ref type:", l, `(${typeof l})`)
        };
        if (a) {
          const E = () => {
            v(), ar.delete(e)
          };
          E.id = -1, ar.set(e, E), Nt(E, n)
        } else qu(e), v()
      } else te("Invalid template ref type:", l, `(${typeof l})`)
    }
  }

  function qu(e) {
    const t = ar.get(e);
    t && (t.flags |= 8, ar.delete(e))
  }
  const Qu = e => e.nodeType === 8;
  jo().requestIdleCallback, jo().cancelIdleCallback;

  function km(e, t) {
    if (Qu(e) && e.data === "[") {
      let n = 1,
        o = e.nextSibling;
      for (; o;) {
        if (o.nodeType === 1) {
          if (t(o) === !1) break
        } else if (Qu(o))
          if (o.data === "]") {
            if (--n === 0) break
          } else o.data === "[" && n++;
        o = o.nextSibling
      }
    } else t(e)
  }
  const bo = e => !!e.type.__asyncLoader;

  function kn(e) {
    be(e) && (e = {
      loader: e
    });
    const {
      loader: t,
      loadingComponent: n,
      errorComponent: o,
      delay: s = 200,
      hydrate: r,
      timeout: a,
      suspensible: i = !0,
      onError: l
    } = e;
    let c = null,
      u, d = 0;
    const h = () => (d++, c = null, f()),
      f = () => {
        let _;
        return c || (_ = c = t().catch(p => {
          if (p = p instanceof Error ? p : new Error(String(p)), l) return new Promise((m, v) => {
            l(p, () => m(h()), () => v(p), d + 1)
          });
          throw p
        }).then(p => {
          if (_ !== c && c) return c;
          if (p || te("Async component loader resolved to undefined. If you are using retry(), make sure to return its return value."), p && (p.__esModule || p[Symbol.toStringTag] === "Module") && (p = p.default), p && !Me(p) && !be(p)) throw new Error(`Invalid async component load result: ${p}`);
          return u = p, p
        }))
      };
    return re({
      name: "AsyncComponentWrapper",
      __asyncLoader: f,
      __asyncHydrate(_, p, m) {
        let v = !1;
        (p.bu || (p.bu = [])).push(() => v = !0);
        const E = () => {
            if (v) {
              te(`Skipping lazy hydration for component '${gr(u)||u.__file}': it was updated before lazy hydration performed.`);
              return
            }
            m()
          },
          k = r ? () => {
            const N = r(E, D => km(_, D));
            N && (p.bum || (p.bum = [])).push(N)
          } : E;
        u ? k() : f().then(() => !p.isUnmounted && k())
      },
      get __asyncResolved() {
        return u
      },
      setup() {
        const _ = Je;
        if (Si(_), u) return () => Di(u, _);
        const p = k => {
          c = null, yo(k, _, 13, !o)
        };
        if (i && _.suspense || Eo) return f().then(k => () => Di(k, _)).catch(k => (p(k), () => o ? K(o, {
          error: k
        }) : null));
        const m = H(!1),
          v = H(),
          E = H(!!s);
        return s && setTimeout(() => {
          E.value = !1
        }, s), a != null && setTimeout(() => {
          if (!m.value && !v.value) {
            const k = new Error(`Async component timed out after ${a}ms.`);
            p(k), v.value = k
          }
        }, a), f().then(() => {
          m.value = !0, _.parent && lr(_.parent.vnode) && _.parent.update()
        }).catch(k => {
          p(k), v.value = k
        }), () => {
          if (m.value && u) return Di(u, _);
          if (v.value && o) return K(o, {
            error: v.value
          });
          if (n && !E.value) return K(n)
        }
      }
    })
  }

  function Di(e, t) {
    const {
      ref: n,
      props: o,
      children: s,
      ce: r
    } = t.vnode, a = K(e, o, s);
    return a.ref = n, a.ce = r, delete t.vnode.ce, a
  }
  const lr = e => e.type.__isKeepAlive;

  function Lm(e, t) {
    Xu(e, "a", t)
  }

  function $m(e, t) {
    Xu(e, "da", t)
  }

  function Xu(e, t, n = Je) {
    const o = e.__wdc || (e.__wdc = () => {
      let s = n;
      for (; s;) {
        if (s.isDeactivated) return;
        s = s.parent
      }
      return e()
    });
    if (ur(t, o, n), n) {
      let s = n.parent;
      for (; s && s.parent;) lr(s.parent.vnode) && xm(o, t, n, s), s = s.parent
    }
  }

  function xm(e, t, n, o) {
    const s = ur(t, e, o, !0);
    Pi(() => {
      Jr(o[t], s)
    }, n)
  }

  function ur(e, t, n = Je, o = !1) {
    if (n) {
      const s = n[e] || (n[e] = []),
        r = t.__weh || (t.__weh = (...a) => {
          Gt();
          const i = fs(n),
            l = Zt(t, n, e, a);
          return i(), jt(), l
        });
      return o ? s.unshift(r) : s.push(r), r
    } else {
      const s = jn(vi[e].replace(/ hook$/, ""));
      te(`${s} is called when there is no active component instance to be associated with. Lifecycle injection APIs can only be used during execution of setup(). If you are using async setup(), make sure to register lifecycle hooks before the first await statement.`)
    }
  }
  const mn = e => (t, n = Je) => {
      (!Eo || e === "sp") && ur(e, (...o) => t(...o), n)
    },
    Fm = mn("bm"),
    Ju = mn("m"),
    Um = mn("bu"),
    Bm = mn("u"),
    Vm = mn("bum"),
    Pi = mn("um"),
    Hm = mn("sp"),
    Gm = mn("rtg"),
    jm = mn("rtc");

  function zm(e, t = Je) {
    ur("ec", e, t)
  }
  const Ei = "components",
    Ym = "directives",
    Zu = Symbol.for("v-ndc");

  function ns(e) {
    return ze(e) ? ec(Ei, e, !1) || e : e || Zu
  }

  function on(e) {
    return ec(Ym, e)
  }

  function ec(e, t, n = !0, o = !1) {
    const s = Xe || Je;
    if (s) {
      const r = s.type;
      if (e === Ei) {
        const i = gr(r, !1);
        if (i && (i === t || i === ht(t) || i === Gn(ht(t)))) return r
      }
      const a = tc(s[e] || r[e], t) || tc(s.appContext[e], t);
      if (!a && o) return r;
      if (n && !a) {
        const i = e === Ei ? `
If this is a native custom element, make sure to exclude it from component resolution via compilerOptions.isCustomElement.` : "";
        te(`Failed to resolve ${e.slice(0,-1)}: ${t}${i}`)
      }
      return a
    } else te(`resolve${Gn(e.slice(0,-1))} can only be used in render() or setup().`)
  }

  function tc(e, t) {
    return e && (e[t] || e[ht(t)] || e[Gn(ht(t))])
  }

  function he(e, t, n, o) {
    let s;
    const r = n,
      a = ye(e);
    if (a || ze(e)) {
      const i = a && zt(e);
      let l = !1,
        c = !1;
      i && (l = !mt(e), c = Jt(e), e = Gs(e)), s = new Array(e.length);
      for (let u = 0, d = e.length; u < d; u++) s[u] = t(l ? c ? qs(it(e[u])) : it(e[u]) : e[u], u, void 0, r)
    } else if (typeof e == "number") {
      Number.isInteger(e) || te(`The v-for range expect an integer value but got ${e}.`), s = new Array(e);
      for (let i = 0; i < e; i++) s[i] = t(i + 1, i, void 0, r)
    } else if (Me(e))
      if (e[Symbol.iterator]) s = Array.from(e, (i, l) => t(i, l, void 0, r));
      else {
        const i = Object.keys(e);
        s = new Array(i.length);
        for (let l = 0, c = i.length; l < c; l++) {
          const u = i[l];
          s[l] = t(e[u], u, l, r)
        }
      }
    else s = [];
    return s
  }

  function Km(e, t) {
    for (let n = 0; n < t.length; n++) {
      const o = t[n];
      if (ye(o))
        for (let s = 0; s < o.length; s++) e[o[s].name] = o[s].fn;
      else o && (e[o.name] = o.key ? (...s) => {
        const r = o.fn(...s);
        return r && (r.key = o.key), r
      } : o.fn)
    }
    return e
  }

  function Oi(e, t, n = {}, o, s) {
    if (Xe.ce || Xe.parent && bo(Xe.parent) && Xe.parent.ce) return t !== "default" && (n.name = t), g(), V(J, null, [K("slot", n, o)], 64);
    let r = e[t];
    r && r.length > 1 && (te("SSR-optimized slot function detected in a non-SSR-optimized render function. You need to mark this component with $dynamic-slots in the parent template."), r = () => []), r && r._c && (r._d = !1), g();
    const a = r && nc(r(n)),
      i = n.key || a && a.key,
      l = V(J, {
        key: (i && !Vt(i) ? i : `_${t}`) + (!a && o ? "_fb" : "")
      }, a || [], a && e._ === 1 ? 64 : -2);
    return !s && l.scopeId && (l.slotScopeIds = [l.scopeId + "-s"]), r && r._c && (r._d = !0), l
  }

  function nc(e) {
    return e.some(t => cs(t) ? !(t.type === It || t.type === J && !nc(t.children)) : !0) ? e : null
  }
  const Ii = e => e ? xc(e) ? vr(e) : Ii(e.parent) : null,
    Xn = Qe(Object.create(null), {
      $: e => e,
      $el: e => e.vnode.el,
      $data: e => e.data,
      $props: e => Lt(e.props),
      $attrs: e => Lt(e.attrs),
      $slots: e => Lt(e.slots),
      $refs: e => Lt(e.refs),
      $parent: e => Ii(e.parent),
      $root: e => Ii(e.root),
      $host: e => e.ce,
      $emit: e => e.emit,
      $options: e => ac(e),
      $forceUpdate: e => e.f || (e.f = () => {
        or(e.update)
      }),
      $nextTick: e => e.n || (e.n = Xo.bind(e.proxy)),
      $watch: e => Ev.bind(e)
    }),
    Ri = e => e === "_" || e === "$",
    wi = (e, t) => e !== Le && !e.__isScriptSetup && Ae(e, t),
    oc = {
      get({
        _: e
      }, t) {
        if (t === "__v_skip") return !0;
        const {
          ctx: n,
          setupState: o,
          data: s,
          props: r,
          accessCache: a,
          type: i,
          appContext: l
        } = e;
        if (t === "__isVue") return !0;
        let c;
        if (t[0] !== "$") {
          const f = a[t];
          if (f !== void 0) switch (f) {
            case 1:
              return o[t];
            case 2:
              return s[t];
            case 4:
              return n[t];
            case 3:
              return r[t]
          } else {
            if (wi(o, t)) return a[t] = 1, o[t];
            if (s !== Le && Ae(s, t)) return a[t] = 2, s[t];
            if ((c = e.propsOptions[0]) && Ae(c, t)) return a[t] = 3, r[t];
            if (n !== Le && Ae(n, t)) return a[t] = 4, n[t];
            Ai && (a[t] = 0)
          }
        }
        const u = Xn[t];
        let d, h;
        if (u) return t === "$attrs" ? (nt(e.attrs, "get", ""), pr()) : t === "$slots" && nt(e, "get", t), u(e);
        if ((d = i.__cssModules) && (d = d[t])) return d;
        if (n !== Le && Ae(n, t)) return a[t] = 4, n[t];
        if (h = l.config.globalProperties, Ae(h, t)) return h[t];
        Xe && (!ze(t) || t.indexOf("__v") !== 0) && (s !== Le && Ri(t[0]) && Ae(s, t) ? te(`Property ${JSON.stringify(t)} must be accessed via $data because it starts with a reserved character ("$" or "_") and is not proxied on the render context.`) : e === Xe && te(`Property ${JSON.stringify(t)} was accessed during render but is not defined on instance.`))
      },
      set({
        _: e
      }, t, n) {
        const {
          data: o,
          setupState: s,
          ctx: r
        } = e;
        return wi(s, t) ? (s[t] = n, !0) : s.__isScriptSetup && Ae(s, t) ? (te(`Cannot mutate <script setup> binding "${t}" from Options API.`), !1) : o !== Le && Ae(o, t) ? (o[t] = n, !0) : Ae(e.props, t) ? (te(`Attempting to mutate prop "${t}". Props are readonly.`), !1) : t[0] === "$" && t.slice(1) in e ? (te(`Attempting to mutate public property "${t}". Properties starting with $ are reserved and readonly.`), !1) : (t in e.appContext.config.globalProperties ? Object.defineProperty(r, t, {
          enumerable: !0,
          configurable: !0,
          value: n
        }) : r[t] = n, !0)
      },
      has({
        _: {
          data: e,
          setupState: t,
          accessCache: n,
          ctx: o,
          appContext: s,
          propsOptions: r,
          type: a
        }
      }, i) {
        let l, c;
        return !!(n[i] || e !== Le && i[0] !== "$" && Ae(e, i) || wi(t, i) || (l = r[0]) && Ae(l, i) || Ae(o, i) || Ae(Xn, i) || Ae(s.config.globalProperties, i) || (c = a.__cssModules) && c[i])
      },
      defineProperty(e, t, n) {
        return n.get != null ? e._.accessCache[t] = 0 : Ae(n, "value") && this.set(e, t, n.value, null), Reflect.defineProperty(e, t, n)
      }
    };
  oc.ownKeys = e => (te("Avoid app logic that relies on enumerating keys on a component instance. The keys will be empty in production mode to avoid performance overhead."), Reflect.ownKeys(e));

  function Wm(e) {
    const t = {};
    return Object.defineProperty(t, "_", {
      configurable: !0,
      enumerable: !1,
      get: () => e
    }), Object.keys(Xn).forEach(n => {
      Object.defineProperty(t, n, {
        configurable: !0,
        enumerable: !1,
        get: () => Xn[n](e),
        set: ct
      })
    }), t
  }

  function qm(e) {
    const {
      ctx: t,
      propsOptions: [n]
    } = e;
    n && Object.keys(n).forEach(o => {
      Object.defineProperty(t, o, {
        enumerable: !0,
        configurable: !0,
        get: () => e.props[o],
        set: ct
      })
    })
  }

  function Qm(e) {
    const {
      ctx: t,
      setupState: n
    } = e;
    Object.keys(De(n)).forEach(o => {
      if (!n.__isScriptSetup) {
        if (Ri(o[0])) {
          te(`setup() return property ${JSON.stringify(o)} should not start with "$" or "_" which are reserved prefixes for Vue internals.`);
          return
        }
        Object.defineProperty(t, o, {
          enumerable: !0,
          configurable: !0,
          get: () => n[o],
          set: ct
        })
      }
    })
  }

  function sc(e) {
    return ye(e) ? e.reduce((t, n) => (t[n] = null, t), {}) : e
  }

  function Xm() {
    const e = Object.create(null);
    return (t, n) => {
      e[n] ? te(`${t} property "${n}" is already defined in ${e[n]}.`) : e[n] = t
    }
  }
  let Ai = !0;

  function Jm(e) {
    const t = ac(e),
      n = e.proxy,
      o = e.ctx;
    Ai = !1, t.beforeCreate && rc(t.beforeCreate, e, "bc");
    const {
      data: s,
      computed: r,
      methods: a,
      watch: i,
      provide: l,
      inject: c,
      created: u,
      beforeMount: d,
      mounted: h,
      beforeUpdate: f,
      updated: _,
      activated: p,
      deactivated: m,
      beforeDestroy: v,
      beforeUnmount: E,
      destroyed: k,
      unmounted: N,
      render: D,
      renderTracked: O,
      renderTriggered: A,
      errorCaptured: b,
      serverPrefetch: C,
      expose: y,
      inheritAttrs: I,
      components: w,
      directives: U,
      filters: Z
    } = t, me = Xm();
    {
      const [B] = e.propsOptions;
      if (B)
        for (const W in B) me("Props", W)
    }
    if (c && Zm(c, o, me), a)
      for (const B in a) {
        const W = a[B];
        be(W) ? (Object.defineProperty(o, B, {
          value: W.bind(n),
          configurable: !0,
          enumerable: !0,
          writable: !0
        }), me("Methods", B)) : te(`Method "${B}" has type "${typeof W}" in the component definition. Did you reference the function correctly?`)
      }
    if (s) {
      be(s) || te("The data option must be a function. Plain object usage is no longer supported.");
      const B = s.call(n, n);
      if (Zr(B) && te("data() returned a Promise - note data() cannot be async; If you intend to perform data fetching before component renders, use async setup() + <Suspense>."), !Me(B)) te("data() should return an object.");
      else {
        e.data = xe(B);
        for (const W in B) me("Data", W), Ri(W[0]) || Object.defineProperty(o, W, {
          configurable: !0,
          enumerable: !0,
          get: () => B[W],
          set: ct
        })
      }
    }
    if (Ai = !0, r)
      for (const B in r) {
        const W = r[B],
          ue = be(W) ? W.bind(n, n) : be(W.get) ? W.get.bind(n, n) : ct;
        ue === ct && te(`Computed property "${B}" has no getter.`);
        const lt = !be(W) && be(W.set) ? W.set.bind(n) : () => {
            te(`Write operation failed: computed property "${B}" is readonly.`)
          },
          Oe = R({
            get: ue,
            set: lt
          });
        Object.defineProperty(o, B, {
          enumerable: !0,
          configurable: !0,
          get: () => Oe.value,
          set: Ke => Oe.value = Ke
        }), me("Computed", B)
      }
    if (i)
      for (const B in i) ic(i[B], o, n, B);
    if (l) {
      const B = be(l) ? l.call(n) : l;
      Reflect.ownKeys(B).forEach(W => {
        rv(W, B[W])
      })
    }
    u && rc(u, e, "c");

    function _e(B, W) {
      ye(W) ? W.forEach(ue => B(ue.bind(n))) : W && B(W.bind(n))
    }
    if (_e(Fm, d), _e(Ju, h), _e(Um, f), _e(Bm, _), _e(Lm, p), _e($m, m), _e(zm, b), _e(jm, O), _e(Gm, A), _e(Vm, E), _e(Pi, N), _e(Hm, C), ye(y))
      if (y.length) {
        const B = e.exposed || (e.exposed = {});
        y.forEach(W => {
          Object.defineProperty(B, W, {
            get: () => n[W],
            set: ue => n[W] = ue,
            enumerable: !0
          })
        })
      } else e.exposed || (e.exposed = {});
    D && e.render === ct && (e.render = D), I != null && (e.inheritAttrs = I), w && (e.components = w), U && (e.directives = U), C && Si(e)
  }

  function Zm(e, t, n = ct) {
    ye(e) && (e = Ni(e));
    for (const o in e) {
      const s = e[o];
      let r;
      Me(s) ? "default" in s ? r = le(s.from || o, s.default, !0) : r = le(s.from || o) : r = le(s), Fe(r) ? Object.defineProperty(t, o, {
        enumerable: !0,
        configurable: !0,
        get: () => r.value,
        set: a => r.value = a
      }) : t[o] = r, n("Inject", o)
    }
  }

  function rc(e, t, n) {
    Zt(ye(e) ? e.map(o => o.bind(t.proxy)) : e.bind(t.proxy), t, n)
  }

  function ic(e, t, n, o) {
    let s = o.includes(".") ? Pc(n, o) : () => n[o];
    if (ze(e)) {
      const r = t[e];
      be(r) ? F(s, r) : te(`Invalid watch handler specified by key "${e}"`, r)
    } else if (be(e)) F(s, e.bind(n));
    else if (Me(e))
      if (ye(e)) e.forEach(r => ic(r, t, n, o));
      else {
        const r = be(e.handler) ? e.handler.bind(n) : t[e.handler];
        be(r) ? F(s, r, e) : te(`Invalid watch handler specified by key "${e.handler}"`, r)
      }
    else te(`Invalid watch option: "${o}"`, e)
  }

  function ac(e) {
    const t = e.type,
      {
        mixins: n,
        extends: o
      } = t,
      {
        mixins: s,
        optionsCache: r,
        config: {
          optionMergeStrategies: a
        }
      } = e.appContext,
      i = r.get(t);
    let l;
    return i ? l = i : !s.length && !n && !o ? l = t : (l = {}, s.length && s.forEach(c => cr(l, c, a, !0)), cr(l, t, a)), Me(t) && r.set(t, l), l
  }

  function cr(e, t, n, o = !1) {
    const {
      mixins: s,
      extends: r
    } = t;
    r && cr(e, r, n, !0), s && s.forEach(a => cr(e, a, n, !0));
    for (const a in t)
      if (o && a === "expose") te('"expose" option is ignored when declared in mixins or extends. It should only be declared in the base component itself.');
      else {
        const i = ev[a] || n && n[a];
        e[a] = i ? i(e[a], t[a]) : t[a]
      } return e
  }
  const ev = {
    data: lc,
    props: uc,
    emits: uc,
    methods: os,
    computed: os,
    beforeCreate: gt,
    created: gt,
    beforeMount: gt,
    mounted: gt,
    beforeUpdate: gt,
    updated: gt,
    beforeDestroy: gt,
    beforeUnmount: gt,
    destroyed: gt,
    unmounted: gt,
    activated: gt,
    deactivated: gt,
    errorCaptured: gt,
    serverPrefetch: gt,
    components: os,
    directives: os,
    watch: nv,
    provide: lc,
    inject: tv
  };

  function lc(e, t) {
    return t ? e ? function() {
      return Qe(be(e) ? e.call(this, this) : e, be(t) ? t.call(this, this) : t)
    } : t : e
  }

  function tv(e, t) {
    return os(Ni(e), Ni(t))
  }

  function Ni(e) {
    if (ye(e)) {
      const t = {};
      for (let n = 0; n < e.length; n++) t[e[n]] = e[n];
      return t
    }
    return e
  }

  function gt(e, t) {
    return e ? [...new Set([].concat(e, t))] : t
  }

  function os(e, t) {
    return e ? Qe(Object.create(null), e, t) : t
  }

  function uc(e, t) {
    return e ? ye(e) && ye(t) ? [...new Set([...e, ...t])] : Qe(Object.create(null), sc(e), sc(t ?? {})) : t
  }

  function nv(e, t) {
    if (!e) return t;
    if (!t) return e;
    const n = Qe(Object.create(null), e);
    for (const o in t) n[o] = gt(e[o], t[o]);
    return n
  }

  function cc() {
    return {
      app: null,
      config: {
        isNativeTag: nu,
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
      optionsCache: new WeakMap,
      propsCache: new WeakMap,
      emitsCache: new WeakMap
    }
  }
  let ov = 0;

  function sv(e, t) {
    return function(o, s = null) {
      be(o) || (o = Qe({}, o)), s != null && !Me(s) && (te("root props passed to app.mount() must be an object."), s = null);
      const r = cc(),
        a = new WeakSet,
        i = [];
      let l = !1;
      const c = r.app = {
        _uid: ov++,
        _component: o,
        _props: s,
        _container: null,
        _context: r,
        _instance: null,
        version: Vc,
        get config() {
          return r.config
        },
        set config(u) {
          te("app.config cannot be replaced. Modify individual options instead.")
        },
        use(u, ...d) {
          return a.has(u) ? te("Plugin has already been applied to target app.") : u && be(u.install) ? (a.add(u), u.install(c, ...d)) : be(u) ? (a.add(u), u(c, ...d)) : te('A plugin must either be a function or an object with an "install" function.'), c
        },
        mixin(u) {
          return r.mixins.includes(u) ? te("Mixin has already been applied to target app" + (u.name ? `: ${u.name}` : "")) : r.mixins.push(u), c
        },
        component(u, d) {
          return ji(u, r.config), d ? (r.components[u] && te(`Component "${u}" has already been registered in target app.`), r.components[u] = d, c) : r.components[u]
        },
        directive(u, d) {
          return Ku(u), d ? (r.directives[u] && te(`Directive "${u}" has already been registered in target app.`), r.directives[u] = d, c) : r.directives[u]
        },
        mount(u, d, h) {
          if (l) te("App has already been mounted.\nIf you want to remount the same app, move your app creation logic into a factory function and create fresh app instances for each mount - e.g. `const createMyApp = () => createApp(App)`");
          else {
            u.__vue_app__ && te("There is already an app instance mounted on the host container.\n If you want to mount another app on the same host container, you need to unmount the previous app by calling `app.unmount()` first.");
            const f = c._ceVNode || K(o, s);
            return f.appContext = r, h === !0 ? h = "svg" : h === !1 && (h = void 0), r.reload = () => {
              const _ = Ln(f);
              _.el = null, e(_, u, h)
            }, e(f, u, h), l = !0, c._container = u, u.__vue_app__ = c, c._instance = f.component, Sm(c, Vc), vr(f.component)
          }
        },
        onUnmount(u) {
          typeof u != "function" && te(`Expected function as first argument to app.onUnmount(), but got ${typeof u}`), i.push(u)
        },
        unmount() {
          l ? (Zt(i, c._instance, 16), e(null, c._container), c._instance = null, Dm(c), delete c._container.__vue_app__) : te("Cannot unmount an app that is not mounted.")
        },
        provide(u, d) {
          return u in r.provides && (Ae(r.provides, u) ? te(`App already provides property with key "${String(u)}". It will be overwritten with the new value.`) : te(`App already provides property with key "${String(u)}" inherited from its parent element. It will be overwritten with the new value.`)), r.provides[u] = d, c
        },
        runWithContext(u) {
          const d = Jn;
          Jn = c;
          try {
            return u()
          } finally {
            Jn = d
          }
        }
      };
      return c
    }
  }
  let Jn = null;

  function rv(e, t) {
    if (!Je) te("provide() can only be used inside setup().");
    else {
      let n = Je.provides;
      const o = Je.parent && Je.parent.provides;
      o === n && (n = Je.provides = Object.create(o)), n[e] = t
    }
  }

  function le(e, t, n = !1) {
    const o = hr();
    if (o || Jn) {
      let s = Jn ? Jn._context.provides : o ? o.parent == null || o.ce ? o.vnode.appContext && o.vnode.appContext.provides : o.parent.provides : void 0;
      if (s && e in s) return s[e];
      if (arguments.length > 1) return n && be(t) ? t.call(o && o.proxy) : t;
      te(`injection "${String(e)}" not found.`)
    } else te("inject() can only be used inside setup() or functional components.")
  }

  function dc() {
    return !!(hr() || Jn)
  }
  const fc = {},
    pc = () => Object.create(fc),
    _c = e => Object.getPrototypeOf(e) === fc;

  function iv(e, t, n, o = !1) {
    const s = {},
      r = pc();
    e.propsDefaults = Object.create(null), hc(e, t, s, r);
    for (const a in e.propsOptions[0]) a in s || (s[a] = void 0);
    gc(t || {}, s, e), n ? e.props = o ? s : hi(s) : e.type.props ? e.props = s : e.props = r, e.attrs = r
  }

  function av(e) {
    for (; e;) {
      if (e.type.__hmrId) return !0;
      e = e.parent
    }
  }

  function lv(e, t, n, o) {
    const {
      props: s,
      attrs: r,
      vnode: {
        patchFlag: a
      }
    } = e, i = De(s), [l] = e.propsOptions;
    let c = !1;
    if (!av(e) && (o || a > 0) && !(a & 16)) {
      if (a & 8) {
        const u = e.vnode.dynamicProps;
        for (let d = 0; d < u.length; d++) {
          let h = u[d];
          if (fr(e.emitsOptions, h)) continue;
          const f = t[h];
          if (l)
            if (Ae(r, h)) f !== r[h] && (r[h] = f, c = !0);
            else {
              const _ = ht(h);
              s[_] = Mi(l, i, _, f, e, !1)
            }
          else f !== r[h] && (r[h] = f, c = !0)
        }
      }
    } else {
      hc(e, t, s, r) && (c = !0);
      let u;
      for (const d in i)(!t || !Ae(t, d) && ((u = wn(d)) === d || !Ae(t, u))) && (l ? n && (n[d] !== void 0 || n[u] !== void 0) && (s[d] = Mi(l, i, d, void 0, e, !0)) : delete s[d]);
      if (r !== i)
        for (const d in r)(!t || !Ae(t, d)) && (delete r[d], c = !0)
    }
    c && Xt(e.attrs, "set", ""), gc(t || {}, s, e)
  }

  function hc(e, t, n, o) {
    const [s, r] = e.propsOptions;
    let a = !1,
      i;
    if (t)
      for (let l in t) {
        if (Go(l)) continue;
        const c = t[l];
        let u;
        s && Ae(s, u = ht(l)) ? !r || !r.includes(u) ? n[u] = c : (i || (i = {}))[u] = c : fr(e.emitsOptions, l) || (!(l in o) || c !== o[l]) && (o[l] = c, a = !0)
      }
    if (r) {
      const l = De(n),
        c = i || Le;
      for (let u = 0; u < r.length; u++) {
        const d = r[u];
        n[d] = Mi(s, l, d, c[d], e, !Ae(c, d))
      }
    }
    return a
  }

  function Mi(e, t, n, o, s, r) {
    const a = e[n];
    if (a != null) {
      const i = Ae(a, "default");
      if (i && o === void 0) {
        const l = a.default;
        if (a.type !== Function && !a.skipFactory && be(l)) {
          const {
            propsDefaults: c
          } = s;
          if (n in c) o = c[n];
          else {
            const u = fs(s);
            o = c[n] = l.call(null, t), u()
          }
        } else o = l;
        s.ce && s.ce._setProp(n, o)
      }
      a[0] && (r && !i ? o = !1 : a[1] && (o === "" || o === wn(n)) && (o = !0))
    }
    return o
  }
  const uv = new WeakMap;

  function mc(e, t, n = !1) {
    const o = n ? uv : t.propsCache,
      s = o.get(e);
    if (s) return s;
    const r = e.props,
      a = {},
      i = [];
    let l = !1;
    if (!be(e)) {
      const u = d => {
        l = !0;
        const [h, f] = mc(d, t, !0);
        Qe(a, h), f && i.push(...f)
      };
      !n && t.mixins.length && t.mixins.forEach(u), e.extends && u(e.extends), e.mixins && e.mixins.forEach(u)
    }
    if (!r && !l) return Me(e) && o.set(e, _o), _o;
    if (ye(r))
      for (let u = 0; u < r.length; u++) {
        ze(r[u]) || te("props must be strings when using array syntax.", r[u]);
        const d = ht(r[u]);
        vc(d) && (a[d] = Le)
      } else if (r) {
        Me(r) || te("invalid props options", r);
        for (const u in r) {
          const d = ht(u);
          if (vc(d)) {
            const h = r[u],
              f = a[d] = ye(h) || be(h) ? {
                type: h
              } : Qe({}, h),
              _ = f.type;
            let p = !1,
              m = !0;
            if (ye(_))
              for (let v = 0; v < _.length; ++v) {
                const E = _[v],
                  k = be(E) && E.name;
                if (k === "Boolean") {
                  p = !0;
                  break
                } else k === "String" && (m = !1)
              } else p = be(_) && _.name === "Boolean";
            f[0] = p, f[1] = m, (p || Ae(f, "default")) && i.push(d)
          }
        }
      } const c = [a, i];
    return Me(e) && o.set(e, c), c
  }

  function vc(e) {
    return e[0] !== "$" && !Go(e) ? !0 : (te(`Invalid prop name: "${e}" is a reserved property.`), !1)
  }

  function cv(e) {
    return e === null ? "null" : typeof e == "function" ? e.name || "" : typeof e == "object" && e.constructor && e.constructor.name || ""
  }

  function gc(e, t, n) {
    const o = De(t),
      s = n.propsOptions[0],
      r = Object.keys(e).map(a => ht(a));
    for (const a in s) {
      let i = s[a];
      i != null && dv(a, o[a], i, Lt(o), !r.includes(a))
    }
  }

  function dv(e, t, n, o, s) {
    const {
      type: r,
      required: a,
      validator: i,
      skipCheck: l
    } = n;
    if (a && s) {
      te('Missing required prop: "' + e + '"');
      return
    }
    if (!(t == null && !a)) {
      if (r != null && r !== !0 && !l) {
        let c = !1;
        const u = ye(r) ? r : [r],
          d = [];
        for (let h = 0; h < u.length && !c; h++) {
          const {
            valid: f,
            expectedType: _
          } = pv(t, u[h]);
          d.push(_ || ""), c = f
        }
        if (!c) {
          te(_v(e, t, d));
          return
        }
      }
      i && !i(t, o) && te('Invalid prop: custom validator check failed for prop "' + e + '".')
    }
  }
  const fv = fn("String,Number,Boolean,Function,Symbol,BigInt");

  function pv(e, t) {
    let n;
    const o = cv(t);
    if (o === "null") n = e === null;
    else if (fv(o)) {
      const s = typeof e;
      n = s === o.toLowerCase(), !n && s === "object" && (n = e instanceof t)
    } else o === "Object" ? n = Me(e) : o === "Array" ? n = ye(e) : n = e instanceof t;
    return {
      valid: n,
      expectedType: o
    }
  }

  function _v(e, t, n) {
    if (n.length === 0) return `Prop type [] for prop "${e}" won't match anything. Did you mean to use type Array instead?`;
    let o = `Invalid prop: type check failed for prop "${e}". Expected ${n.map(Gn).join(" | ")}`;
    const s = n[0],
      r = ei(t),
      a = yc(t, s),
      i = yc(t, r);
    return n.length === 1 && Cc(s) && !hv(s, r) && (o += ` with value ${a}`), o += `, got ${r} `, Cc(r) && (o += `with value ${i}.`), o
  }

  function yc(e, t) {
    return t === "String" ? `"${e}"` : t === "Number" ? `${Number(e)}` : `${e}`
  }

  function Cc(e) {
    return ["string", "number", "boolean"].some(n => e.toLowerCase() === n)
  }

  function hv(...e) {
    return e.some(t => t.toLowerCase() === "boolean")
  }
  const ki = e => e === "_" || e === "_ctx" || e === "$stable",
    Li = e => ye(e) ? e.map(Yt) : [Yt(e)],
    mv = (e, t, n) => {
      if (t._n) return t;
      const o = ce((...s) => (Nn.NODE_ENV !== "production" && Je && !(n === null && Xe) && !(n && n.root !== Je.root) && te(`Slot "${e}" invoked outside of the render function: this will not track dependencies used in the slot. Invoke the slot function inside the render function instead.`), Li(t(...s))), n);
      return o._c = !1, o
    },
    Tc = (e, t, n) => {
      const o = e._ctx;
      for (const s in e) {
        if (ki(s)) continue;
        const r = e[s];
        if (be(r)) t[s] = mv(s, r, o);
        else if (r != null) {
          te(`Non-function value encountered for slot "${s}". Prefer function slots for better performance.`);
          const a = Li(r);
          t[s] = () => a
        }
      }
    },
    bc = (e, t) => {
      lr(e.vnode) || te("Non-function value encountered for default slot. Prefer function slots for better performance.");
      const n = Li(t);
      e.slots.default = () => n
    },
    $i = (e, t, n) => {
      for (const o in t)(n || !ki(o)) && (e[o] = t[o])
    },
    vv = (e, t, n) => {
      const o = e.slots = pc();
      if (e.vnode.shapeFlag & 32) {
        const s = t._;
        s ? ($i(o, t, n), n && Bs(o, "_", s, !0)) : Tc(t, o)
      } else t && bc(e, t)
    },
    gv = (e, t, n) => {
      const {
        vnode: o,
        slots: s
      } = e;
      let r = !0,
        a = Le;
      if (o.shapeFlag & 32) {
        const i = t._;
        i ? tn ? ($i(s, t, n), Xt(e, "set", "$slots")) : n && i === 1 ? r = !1 : $i(s, t, n) : (r = !t.$stable, Tc(t, s)), a = t
      } else t && (bc(e, t), a = {
        default: 1
      });
      if (r)
        for (const i in s) !ki(i) && a[i] == null && delete s[i]
    };
  let ss, vn;

  function So(e, t) {
    e.appContext.config.performance && dr() && vn.mark(`vue-${t}-${e.uid}`), Im(e, t, dr() ? vn.now() : Date.now())
  }

  function Do(e, t) {
    if (e.appContext.config.performance && dr()) {
      const n = `vue-${t}-${e.uid}`,
        o = n + ":end",
        s = `<${yr(e,e.type)}> ${t}`;
      vn.mark(o), vn.measure(s, n, o), vn.clearMeasures(s), vn.clearMarks(n), vn.clearMarks(o)
    }
    Rm(e, t, dr() ? vn.now() : Date.now())
  }

  function dr() {
    return ss !== void 0 || (typeof window < "u" && window.performance ? (ss = !0, vn = window.performance) : ss = !1), ss
  }

  function yv() {
    const e = [];
    if (e.length) {
      const t = e.length > 1;
      console.warn(`Feature flag${t?"s":""} ${e.join(", ")} ${t?"are":"is"} not explicitly defined. You are running the esm-bundler build of Vue, which expects these compile-time feature flags to be globally injected via the bundler config in order to get better tree-shaking in the production bundle.

For more details, see https://link.vuejs.org/feature-flags.`)
    }
  }
  const Nt = kv;

  function Cv(e) {
    return Tv(e)
  }

  function Tv(e, t) {
    yv();
    const n = jo();
    n.__VUE__ = !0, Gu(n.__VUE_DEVTOOLS_GLOBAL_HOOK__, n);
    const {
      insert: o,
      remove: s,
      patchProp: r,
      createElement: a,
      createText: i,
      createComment: l,
      setText: c,
      setElementText: u,
      parentNode: d,
      nextSibling: h,
      setScopeId: f = ct,
      insertStaticContent: _
    } = e, p = (P, L, G, Q = null, z = null, Y = null, ie = void 0, se = null, ee = tn ? !1 : !!L.dynamicChildren) => {
      if (P === L) return;
      P && !ds(P, L) && (Q = uo(P), Ie(P, z, Y, !0), P = null), L.patchFlag === -2 && (ee = !1, L.dynamicChildren = null);
      const {
        type: X,
        ref: Te,
        shapeFlag: ae
      } = L;
      switch (X) {
        case is:
          m(P, L, G, Q);
          break;
        case It:
          v(P, L, G, Q);
          break;
        case as:
          P == null ? E(L, G, Q, ie) : k(P, L, G, ie);
          break;
        case J:
          U(P, L, G, Q, z, Y, ie, se, ee);
          break;
        default:
          ae & 1 ? O(P, L, G, Q, z, Y, ie, se, ee) : ae & 6 ? Z(P, L, G, Q, z, Y, ie, se, ee) : ae & 64 || ae & 128 ? X.process(P, L, G, Q, z, Y, ie, se, ee, Vn) : te("Invalid VNode type:", X, `(${typeof X})`)
      }
      Te != null && z ? ts(Te, P && P.ref, Y, L || P, !L) : Te == null && P && P.ref != null && ts(P.ref, null, Y, P, !0)
    }, m = (P, L, G, Q) => {
      if (P == null) o(L.el = i(L.children), G, Q);
      else {
        const z = L.el = P.el;
        L.children !== P.children && c(z, L.children)
      }
    }, v = (P, L, G, Q) => {
      P == null ? o(L.el = l(L.children || ""), G, Q) : L.el = P.el
    }, E = (P, L, G, Q) => {
      [P.el, P.anchor] = _(P.children, L, G, Q, P.el, P.anchor)
    }, k = (P, L, G, Q) => {
      if (L.children !== P.children) {
        const z = h(P.anchor);
        D(P), [L.el, L.anchor] = _(L.children, G, z, Q)
      } else L.el = P.el, L.anchor = P.anchor
    }, N = ({
      el: P,
      anchor: L
    }, G, Q) => {
      let z;
      for (; P && P !== L;) z = h(P), o(P, G, Q), P = z;
      o(L, G, Q)
    }, D = ({
      el: P,
      anchor: L
    }) => {
      let G;
      for (; P && P !== L;) G = h(P), s(P), P = G;
      s(L)
    }, O = (P, L, G, Q, z, Y, ie, se, ee) => {
      L.type === "svg" ? ie = "svg" : L.type === "math" && (ie = "mathml"), P == null ? A(L, G, Q, z, Y, ie, se, ee) : y(P, L, z, Y, ie, se, ee)
    }, A = (P, L, G, Q, z, Y, ie, se) => {
      let ee, X;
      const {
        props: Te,
        shapeFlag: ae,
        transition: ve,
        dirs: Se
      } = P;
      if (ee = P.el = a(P.type, Y, Te && Te.is, Te), ae & 8 ? u(ee, P.children) : ae & 16 && C(P.children, ee, null, Q, z, xi(P, Y), ie, se), Se && Qn(P, null, Q, "created"), b(ee, P, P.scopeId, ie, Q), Te) {
        for (const Ue in Te) Ue !== "value" && !Go(Ue) && r(ee, Ue, null, Te[Ue], Y, Q);
        "value" in Te && r(ee, "value", null, Te.value, Y), (X = Te.onVnodeBeforeMount) && sn(X, Q, P)
      }
      Bs(ee, "__vnode", P, !0), Bs(ee, "__vueParentComponent", Q, !0), Se && Qn(P, null, Q, "beforeMount");
      const Re = bv(z, ve);
      Re && ve.beforeEnter(ee), o(ee, L, G), ((X = Te && Te.onVnodeMounted) || Re || Se) && Nt(() => {
        X && sn(X, Q, P), Re && ve.enter(ee), Se && Qn(P, null, Q, "mounted")
      }, z)
    }, b = (P, L, G, Q, z) => {
      if (G && f(P, G), Q)
        for (let Y = 0; Y < Q.length; Y++) f(P, Q[Y]);
      if (z) {
        let Y = z.subTree;
        if (Y.patchFlag > 0 && Y.patchFlag & 2048 && (Y = Vi(Y.children) || Y), L === Y || Ac(Y.type) && (Y.ssContent === L || Y.ssFallback === L)) {
          const ie = z.vnode;
          b(P, ie, ie.scopeId, ie.slotScopeIds, z.parent)
        }
      }
    }, C = (P, L, G, Q, z, Y, ie, se, ee = 0) => {
      for (let X = ee; X < P.length; X++) {
        const Te = P[X] = se ? $n(P[X]) : Yt(P[X]);
        p(null, Te, L, G, Q, z, Y, ie, se)
      }
    }, y = (P, L, G, Q, z, Y, ie) => {
      const se = L.el = P.el;
      se.__vnode = L;
      let {
        patchFlag: ee,
        dynamicChildren: X,
        dirs: Te
      } = L;
      ee |= P.patchFlag & 16;
      const ae = P.props || Le,
        ve = L.props || Le;
      let Se;
      if (G && Zn(G, !1), (Se = ve.onVnodeBeforeUpdate) && sn(Se, G, L, P), Te && Qn(L, P, G, "beforeUpdate"), G && Zn(G, !0), tn && (ee = 0, ie = !1, X = null), (ae.innerHTML && ve.innerHTML == null || ae.textContent && ve.textContent == null) && u(se, ""), X ? (I(P.dynamicChildren, X, se, G, Q, xi(L, z), Y), Fi(P, L)) : ie || ue(P, L, se, null, G, Q, xi(L, z), Y, !1), ee > 0) {
        if (ee & 16) w(se, ae, ve, G, z);
        else if (ee & 2 && ae.class !== ve.class && r(se, "class", null, ve.class, z), ee & 4 && r(se, "style", ae.style, ve.style, z), ee & 8) {
          const Re = L.dynamicProps;
          for (let Ue = 0; Ue < Re.length; Ue++) {
            const ke = Re[Ue],
              st = ae[ke],
              ut = ve[ke];
            (ut !== st || ke === "value") && r(se, ke, st, ut, z, G)
          }
        }
        ee & 1 && P.children !== L.children && u(se, L.children)
      } else !ie && X == null && w(se, ae, ve, G, z);
      ((Se = ve.onVnodeUpdated) || Te) && Nt(() => {
        Se && sn(Se, G, L, P), Te && Qn(L, P, G, "updated")
      }, Q)
    }, I = (P, L, G, Q, z, Y, ie) => {
      for (let se = 0; se < L.length; se++) {
        const ee = P[se],
          X = L[se],
          Te = ee.el && (ee.type === J || !ds(ee, X) || ee.shapeFlag & 198) ? d(ee.el) : G;
        p(ee, X, Te, null, Q, z, Y, ie, !0)
      }
    }, w = (P, L, G, Q, z) => {
      if (L !== G) {
        if (L !== Le)
          for (const Y in L) !Go(Y) && !(Y in G) && r(P, Y, L[Y], null, z, Q);
        for (const Y in G) {
          if (Go(Y)) continue;
          const ie = G[Y],
            se = L[Y];
          ie !== se && Y !== "value" && r(P, Y, se, ie, z, Q)
        }
        "value" in G && r(P, "value", L.value, G.value, z)
      }
    }, U = (P, L, G, Q, z, Y, ie, se, ee) => {
      const X = L.el = P ? P.el : i(""),
        Te = L.anchor = P ? P.anchor : i("");
      let {
        patchFlag: ae,
        dynamicChildren: ve,
        slotScopeIds: Se
      } = L;
      (tn || ae & 2048) && (ae = 0, ee = !1, ve = null), Se && (se = se ? se.concat(Se) : Se), P == null ? (o(X, G, Q), o(Te, G, Q), C(L.children || [], G, Te, z, Y, ie, se, ee)) : ae > 0 && ae & 64 && ve && P.dynamicChildren ? (I(P.dynamicChildren, ve, G, z, Y, ie, se), Fi(P, L)) : ue(P, L, G, Te, z, Y, ie, se, ee)
    }, Z = (P, L, G, Q, z, Y, ie, se, ee) => {
      L.slotScopeIds = se, P == null ? L.shapeFlag & 512 ? z.ctx.activate(L, G, Q, ie, ee) : me(L, G, Q, z, Y, ie, ee) : _e(P, L, ee)
    }, me = (P, L, G, Q, z, Y, ie) => {
      const se = P.component = Gv(P, Q, z);
      if (se.type.__hmrId && ym(se), er(P), So(se, "mount"), lr(P) && (se.ctx.renderer = Vn), So(se, "init"), zv(se, !1, ie), Do(se, "init"), tn && (P.el = null), se.asyncDep) {
        if (z && z.registerDep(se, B, ie), !P.el) {
          const ee = se.subTree = K(It);
          v(null, ee, L, G), P.placeholder = ee.el
        }
      } else B(se, P, L, G, z, Y, ie);
      tr(), Do(se, "mount")
    }, _e = (P, L, G) => {
      const Q = L.component = P.component;
      if (Nv(P, L, G))
        if (Q.asyncDep && !Q.asyncResolved) {
          er(L), W(Q, L, G), tr();
          return
        } else Q.next = L, Q.update();
      else L.el = P.el, Q.vnode = L
    }, B = (P, L, G, Q, z, Y, ie) => {
      const se = () => {
        if (P.isMounted) {
          let {
            next: ae,
            bu: ve,
            u: Se,
            parent: Re,
            vnode: Ue
          } = P;
          {
            const Et = Sc(P);
            if (Et) {
              ae && (ae.el = Ue.el, W(P, ae, ie)), Et.asyncDep.then(() => {
                P.isUnmounted || se()
              });
              return
            }
          }
          let ke = ae,
            st;
          er(ae || P.vnode), Zn(P, !1), ae ? (ae.el = Ue.el, W(P, ae, ie)) : ae = Ue, ve && mo(ve), (st = ae.props && ae.props.onVnodeBeforeUpdate) && sn(st, Re, ae, Ue), Zn(P, !0), So(P, "render");
          const ut = Oc(P);
          Do(P, "render");
          const Pt = P.subTree;
          P.subTree = ut, So(P, "patch"), p(Pt, ut, d(Pt.el), uo(Pt), P, z, Y), Do(P, "patch"), ae.el = ut.el, ke === null && Mv(P, ut.el), Se && Nt(Se, z), (st = ae.props && ae.props.onVnodeUpdated) && Nt(() => sn(st, Re, ae, Ue), z), ju(P), tr()
        } else {
          let ae;
          const {
            el: ve,
            props: Se
          } = L, {
            bm: Re,
            m: Ue,
            parent: ke,
            root: st,
            type: ut
          } = P, Pt = bo(L);
          Zn(P, !1), Re && mo(Re), !Pt && (ae = Se && Se.onVnodeBeforeMount) && sn(ae, ke, L), Zn(P, !0);
          {
            st.ce && st.ce._def.shadowRoot !== !1 && st.ce._injectChildStyle(ut), So(P, "render");
            const Et = P.subTree = Oc(P);
            Do(P, "render"), So(P, "patch"), p(null, Et, G, Q, P, z, Y), Do(P, "patch"), L.el = Et.el
          }
          if (Ue && Nt(Ue, z), !Pt && (ae = Se && Se.onVnodeMounted)) {
            const Et = L;
            Nt(() => sn(ae, ke, Et), z)
          }(L.shapeFlag & 256 || ke && bo(ke.vnode) && ke.vnode.shapeFlag & 256) && P.a && Nt(P.a, z), P.isMounted = !0, Pm(P), L = G = Q = null
        }
      };
      P.scope.on();
      const ee = P.effect = new pu(se);
      P.scope.off();
      const X = P.update = ee.run.bind(ee),
        Te = P.job = ee.runIfDirty.bind(ee);
      Te.i = P, Te.id = P.uid, ee.scheduler = () => or(Te), Zn(P, !0), ee.onTrack = P.rtc ? ae => mo(P.rtc, ae) : void 0, ee.onTrigger = P.rtg ? ae => mo(P.rtg, ae) : void 0, X()
    }, W = (P, L, G) => {
      L.component = P;
      const Q = P.vnode.props;
      P.vnode = L, P.next = null, lv(P, L.props, Q, G), gv(P, L.children, G), Gt(), Fu(P), jt()
    }, ue = (P, L, G, Q, z, Y, ie, se, ee = !1) => {
      const X = P && P.children,
        Te = P ? P.shapeFlag : 0,
        ae = L.children,
        {
          patchFlag: ve,
          shapeFlag: Se
        } = L;
      if (ve > 0) {
        if (ve & 128) {
          Oe(X, ae, G, Q, z, Y, ie, se, ee);
          return
        } else if (ve & 256) {
          lt(X, ae, G, Q, z, Y, ie, se, ee);
          return
        }
      }
      Se & 8 ? (Te & 16 && En(X, z, Y), ae !== X && u(G, ae)) : Te & 16 ? Se & 16 ? Oe(X, ae, G, Q, z, Y, ie, se, ee) : En(X, z, Y, !0) : (Te & 8 && u(G, ""), Se & 16 && C(ae, G, Q, z, Y, ie, se, ee))
    }, lt = (P, L, G, Q, z, Y, ie, se, ee) => {
      P = P || _o, L = L || _o;
      const X = P.length,
        Te = L.length,
        ae = Math.min(X, Te);
      let ve;
      for (ve = 0; ve < ae; ve++) {
        const Se = L[ve] = ee ? $n(L[ve]) : Yt(L[ve]);
        p(P[ve], Se, G, null, z, Y, ie, se, ee)
      }
      X > Te ? En(P, z, Y, !0, !1, ae) : C(L, G, Q, z, Y, ie, se, ee, ae)
    }, Oe = (P, L, G, Q, z, Y, ie, se, ee) => {
      let X = 0;
      const Te = L.length;
      let ae = P.length - 1,
        ve = Te - 1;
      for (; X <= ae && X <= ve;) {
        const Se = P[X],
          Re = L[X] = ee ? $n(L[X]) : Yt(L[X]);
        if (ds(Se, Re)) p(Se, Re, G, null, z, Y, ie, se, ee);
        else break;
        X++
      }
      for (; X <= ae && X <= ve;) {
        const Se = P[ae],
          Re = L[ve] = ee ? $n(L[ve]) : Yt(L[ve]);
        if (ds(Se, Re)) p(Se, Re, G, null, z, Y, ie, se, ee);
        else break;
        ae--, ve--
      }
      if (X > ae) {
        if (X <= ve) {
          const Se = ve + 1,
            Re = Se < Te ? L[Se].el : Q;
          for (; X <= ve;) p(null, L[X] = ee ? $n(L[X]) : Yt(L[X]), G, Re, z, Y, ie, se, ee), X++
        }
      } else if (X > ve)
        for (; X <= ae;) Ie(P[X], z, Y, !0), X++;
      else {
        const Se = X,
          Re = X,
          Ue = new Map;
        for (X = Re; X <= ve; X++) {
          const et = L[X] = ee ? $n(L[X]) : Yt(L[X]);
          et.key != null && (Ue.has(et.key) && te("Duplicate keys found during update:", JSON.stringify(et.key), "Make sure keys are unique."), Ue.set(et.key, X))
        }
        let ke, st = 0;
        const ut = ve - Re + 1;
        let Pt = !1,
          Et = 0;
        const Ot = new Array(ut);
        for (X = 0; X < ut; X++) Ot[X] = 0;
        for (X = Se; X <= ae; X++) {
          const et = P[X];
          if (st >= ut) {
            Ie(et, z, Y, !0);
            continue
          }
          let Rt;
          if (et.key != null) Rt = Ue.get(et.key);
          else
            for (ke = Re; ke <= ve; ke++)
              if (Ot[ke - Re] === 0 && ds(et, L[ke])) {
                Rt = ke;
                break
              } Rt === void 0 ? Ie(et, z, Y, !0) : (Ot[Rt - Re] = X + 1, Rt >= Et ? Et = Rt : Pt = !0, p(et, L[Rt], G, null, z, Y, ie, se, ee), st++)
        }
        const On = Pt ? Sv(Ot) : _o;
        for (ke = On.length - 1, X = ut - 1; X >= 0; X--) {
          const et = Re + X,
            Rt = L[et],
            Qr = L[et + 1],
            po = et + 1 < Te ? Qr.el || Qr.placeholder : Q;
          Ot[X] === 0 ? p(null, Rt, G, po, z, Y, ie, se, ee) : Pt && (ke < 0 || X !== On[ke] ? Ke(Rt, G, po, 2) : ke--)
        }
      }
    }, Ke = (P, L, G, Q, z = null) => {
      const {
        el: Y,
        type: ie,
        transition: se,
        children: ee,
        shapeFlag: X
      } = P;
      if (X & 6) {
        Ke(P.component.subTree, L, G, Q);
        return
      }
      if (X & 128) {
        P.suspense.move(L, G, Q);
        return
      }
      if (X & 64) {
        ie.move(P, L, G, Vn);
        return
      }
      if (ie === J) {
        o(Y, L, G);
        for (let ae = 0; ae < ee.length; ae++) Ke(ee[ae], L, G, Q);
        o(P.anchor, L, G);
        return
      }
      if (ie === as) {
        N(P, L, G);
        return
      }
      if (Q !== 2 && X & 1 && se)
        if (Q === 0) se.beforeEnter(Y), o(Y, L, G), Nt(() => se.enter(Y), z);
        else {
          const {
            leave: ae,
            delayLeave: ve,
            afterLeave: Se
          } = se, Re = () => {
            P.ctx.isUnmounted ? s(Y) : o(Y, L, G)
          }, Ue = () => {
            Y._isLeaving && Y[Mm](!0), ae(Y, () => {
              Re(), Se && Se()
            })
          };
          ve ? ve(Y, Re, Ue) : Ue()
        }
      else o(Y, L, G)
    }, Ie = (P, L, G, Q = !1, z = !1) => {
      const {
        type: Y,
        props: ie,
        ref: se,
        children: ee,
        dynamicChildren: X,
        shapeFlag: Te,
        patchFlag: ae,
        dirs: ve,
        cacheIndex: Se
      } = P;
      if (ae === -2 && (z = !1), se != null && (Gt(), ts(se, null, G, P, !0), jt()), Se != null && (L.renderCache[Se] = void 0), Te & 256) {
        L.ctx.deactivate(P);
        return
      }
      const Re = Te & 1 && ve,
        Ue = !bo(P);
      let ke;
      if (Ue && (ke = ie && ie.onVnodeBeforeUnmount) && sn(ke, L, P), Te & 6) lo(P.component, G, Q);
      else {
        if (Te & 128) {
          P.suspense.unmount(G, Q);
          return
        }
        Re && Qn(P, null, L, "beforeUnmount"), Te & 64 ? P.type.remove(P, L, G, Vn, Q) : X && !X.hasOnce && (Y !== J || ae > 0 && ae & 64) ? En(X, L, G, !1, !0) : (Y === J && ae & 384 || !z && Te & 16) && En(ee, L, G), Q && Pn(P)
      }(Ue && (ke = ie && ie.onVnodeUnmounted) || Re) && Nt(() => {
        ke && sn(ke, L, P), Re && Qn(P, null, L, "unmounted")
      }, G)
    }, Pn = P => {
      const {
        type: L,
        el: G,
        anchor: Q,
        transition: z
      } = P;
      if (L === J) {
        P.patchFlag > 0 && P.patchFlag & 2048 && z && !z.persisted ? P.children.forEach(ie => {
          ie.type === It ? s(ie.el) : Pn(ie)
        }) : He(G, Q);
        return
      }
      if (L === as) {
        D(P);
        return
      }
      const Y = () => {
        s(G), z && !z.persisted && z.afterLeave && z.afterLeave()
      };
      if (P.shapeFlag & 1 && z && !z.persisted) {
        const {
          leave: ie,
          delayLeave: se
        } = z, ee = () => ie(G, Y);
        se ? se(P.el, Y, ee) : ee()
      } else Y()
    }, He = (P, L) => {
      let G;
      for (; P !== L;) G = h(P), s(P), P = G;
      s(L)
    }, lo = (P, L, G) => {
      P.type.__hmrId && Cm(P);
      const {
        bum: Q,
        scope: z,
        job: Y,
        subTree: ie,
        um: se,
        m: ee,
        a: X
      } = P;
      Dc(ee), Dc(X), Q && mo(Q), z.stop(), Y && (Y.flags |= 8, Ie(ie, P, L, G)), se && Nt(se, L), Nt(() => {
        P.isUnmounted = !0
      }, L), Om(P)
    }, En = (P, L, G, Q = !1, z = !1, Y = 0) => {
      for (let ie = Y; ie < P.length; ie++) Ie(P[ie], L, G, Q, z)
    }, uo = P => {
      if (P.shapeFlag & 6) return uo(P.component.subTree);
      if (P.shapeFlag & 128) return P.suspense.next();
      const L = h(P.anchor || P.el),
        G = L && L[Am];
      return G ? h(G) : L
    };
    let co = !1;
    const Ls = (P, L, G) => {
        P == null ? L._vnode && Ie(L._vnode, null, null, !0) : p(L._vnode || null, P, L, null, null, null, G), L._vnode = P, co || (co = !0, Fu(), Uu(), co = !1)
      },
      Vn = {
        p,
        um: Ie,
        m: Ke,
        r: Pn,
        mt: me,
        mc: C,
        pc: ue,
        pbc: I,
        n: uo,
        o: e
      };
    return {
      render: Ls,
      hydrate: void 0,
      createApp: sv(Ls)
    }
  }

  function xi({
    type: e,
    props: t
  }, n) {
    return n === "svg" && e === "foreignObject" || n === "mathml" && e === "annotation-xml" && t && t.encoding && t.encoding.includes("html") ? void 0 : n
  }

  function Zn({
    effect: e,
    job: t
  }, n) {
    n ? (e.flags |= 32, t.flags |= 4) : (e.flags &= -33, t.flags &= -5)
  }

  function bv(e, t) {
    return (!e || e && !e.pendingBranch) && t && !t.persisted
  }

  function Fi(e, t, n = !1) {
    const o = e.children,
      s = t.children;
    if (ye(o) && ye(s))
      for (let r = 0; r < o.length; r++) {
        const a = o[r];
        let i = s[r];
        i.shapeFlag & 1 && !i.dynamicChildren && ((i.patchFlag <= 0 || i.patchFlag === 32) && (i = s[r] = $n(s[r]), i.el = a.el), !n && i.patchFlag !== -2 && Fi(a, i)), i.type === is && i.patchFlag !== -1 && (i.el = a.el), i.type === It && !i.el && (i.el = a.el), i.el && (i.el.__vnode = i)
      }
  }

  function Sv(e) {
    const t = e.slice(),
      n = [0];
    let o, s, r, a, i;
    const l = e.length;
    for (o = 0; o < l; o++) {
      const c = e[o];
      if (c !== 0) {
        if (s = n[n.length - 1], e[s] < c) {
          t[o] = s, n.push(o);
          continue
        }
        for (r = 0, a = n.length - 1; r < a;) i = r + a >> 1, e[n[i]] < c ? r = i + 1 : a = i;
        c < e[n[r]] && (r > 0 && (t[o] = n[r - 1]), n[r] = o)
      }
    }
    for (r = n.length, a = n[r - 1]; r-- > 0;) n[r] = a, a = t[a];
    return n
  }

  function Sc(e) {
    const t = e.subTree.component;
    if (t) return t.asyncDep && !t.asyncResolved ? t : Sc(t)
  }

  function Dc(e) {
    if (e)
      for (let t = 0; t < e.length; t++) e[t].flags |= 8
  }
  const Dv = Symbol.for("v-scx"),
    Pv = () => {
      {
        const e = le(Dv);
        return e || te("Server rendering context not provided. Make sure to only call useSSRContext() conditionally in the server build."), e
      }
    };

  function rs(e, t) {
    return Ui(e, null, t)
  }

  function F(e, t, n) {
    return be(t) || te("`watch(fn, options?)` signature has been moved to a separate API. Use `watchEffect(fn, options?)` instead. `watch` now only supports `watch(source, cb, options?) signature."), Ui(e, t, n)
  }

  function Ui(e, t, n = Le) {
    const {
      immediate: o,
      deep: s,
      flush: r,
      once: a
    } = n;
    t || (o !== void 0 && te('watch() "immediate" option is only respected when using the watch(source, callback, options?) signature.'), s !== void 0 && te('watch() "deep" option is only respected when using the watch(source, callback, options?) signature.'), a !== void 0 && te('watch() "once" option is only respected when using the watch(source, callback, options?) signature.'));
    const i = Qe({}, n);
    i.onWarn = te;
    const l = t && o || !t && r !== "post";
    let c;
    if (Eo) {
      if (r === "sync") {
        const f = Pv();
        c = f.__watcherHandles || (f.__watcherHandles = [])
      } else if (!l) {
        const f = () => {};
        return f.stop = ct, f.resume = ct, f.pause = ct, f
      }
    }
    const u = Je;
    i.call = (f, _, p) => Zt(f, u, _, p);
    let d = !1;
    r === "post" ? i.scheduler = f => {
      Nt(f, u && u.suspense)
    } : r !== "sync" && (d = !0, i.scheduler = (f, _) => {
      _ ? f() : or(f)
    }), i.augmentJob = f => {
      t && (f.flags |= 4), d && (f.flags |= 2, u && (f.id = u.uid, f.i = u))
    };
    const h = dm(e, t, i);
    return Eo && (c ? c.push(h) : l && h()), h
  }

  function Ev(e, t, n) {
    const o = this.proxy,
      s = ze(e) ? e.includes(".") ? Pc(o, e) : () => o[e] : e.bind(o, o);
    let r;
    be(t) ? r = t : (r = t.handler, n = t);
    const a = fs(this),
      i = Ui(s, r.bind(o), n);
    return a(), i
  }

  function Pc(e, t) {
    const n = t.split(".");
    return () => {
      let o = e;
      for (let s = 0; s < n.length && o; s++) o = o[n[s]];
      return o
    }
  }
  const Ov = (e, t) => t === "modelValue" || t === "model-value" ? e.modelModifiers : e[`${t}Modifiers`] || e[`${ht(t)}Modifiers`] || e[`${wn(t)}Modifiers`];

  function Iv(e, t, ...n) {
    if (e.isUnmounted) return;
    const o = e.vnode.props || Le;
    {
      const {
        emitsOptions: u,
        propsOptions: [d]
      } = e;
      if (u)
        if (!(t in u))(!d || !(jn(ht(t)) in d)) && te(`Component emitted event "${t}" but it is neither declared in the emits option nor as an "${jn(ht(t))}" prop.`);
        else {
          const h = u[t];
          be(h) && (h(...n) || te(`Invalid event arguments: event validation failed for event "${t}".`))
        }
    }
    let s = n;
    const r = t.startsWith("update:"),
      a = r && Ov(o, t.slice(7));
    a && (a.trim && (s = n.map(u => ze(u) ? u.trim() : u)), a.number && (s = n.map(Vs))), wm(e, t, s);
    {
      const u = t.toLowerCase();
      u !== t && o[jn(u)] && te(`Event "${u}" is emitted in component ${yr(e,e.type)} but the handler is registered for "${t}". Note that HTML attributes are case-insensitive and you cannot use v-on to listen to camelCase events when using in-DOM templates. You should probably use "${wn(t)}" instead of "${t}".`)
    }
    let i, l = o[i = jn(t)] || o[i = jn(ht(t))];
    !l && r && (l = o[i = jn(wn(t))]), l && Zt(l, e, 6, s);
    const c = o[i + "Once"];
    if (c) {
      if (!e.emitted) e.emitted = {};
      else if (e.emitted[i]) return;
      e.emitted[i] = !0, Zt(c, e, 6, s)
    }
  }
  const Rv = new WeakMap;

  function Ec(e, t, n = !1) {
    const o = n ? Rv : t.emitsCache,
      s = o.get(e);
    if (s !== void 0) return s;
    const r = e.emits;
    let a = {},
      i = !1;
    if (!be(e)) {
      const l = c => {
        const u = Ec(c, t, !0);
        u && (i = !0, Qe(a, u))
      };
      !n && t.mixins.length && t.mixins.forEach(l), e.extends && l(e.extends), e.mixins && e.mixins.forEach(l)
    }
    return !r && !i ? (Me(e) && o.set(e, null), null) : (ye(r) ? r.forEach(l => a[l] = null) : Qe(a, r), Me(e) && o.set(e, a), a)
  }

  function fr(e, t) {
    return !e || !Vo(t) ? !1 : (t = t.slice(2).replace(/Once$/, ""), Ae(e, t[0].toLowerCase() + t.slice(1)) || Ae(e, wn(t)) || Ae(e, t))
  }
  let Bi = !1;

  function pr() {
    Bi = !0
  }

  function Oc(e) {
    const {
      type: t,
      vnode: n,
      proxy: o,
      withProxy: s,
      propsOptions: [r],
      slots: a,
      attrs: i,
      emit: l,
      render: c,
      renderCache: u,
      props: d,
      data: h,
      setupState: f,
      ctx: _,
      inheritAttrs: p
    } = e, m = ir(e);
    let v, E;
    Bi = !1;
    try {
      if (n.shapeFlag & 4) {
        const D = s || o,
          O = Nn.NODE_ENV !== "production" && f.__isScriptSetup ? new Proxy(D, {
            get(A, b, C) {
              return te(`Property '${String(b)}' was accessed via 'this'. Avoid using 'this' in templates.`), Reflect.get(A, b, C)
            }
          }) : D;
        v = Yt(c.call(O, D, u, Nn.NODE_ENV !== "production" ? Lt(d) : d, f, h, _)), E = i
      } else {
        const D = t;
        Nn.NODE_ENV !== "production" && i === d && pr(), v = Yt(D.length > 1 ? D(Nn.NODE_ENV !== "production" ? Lt(d) : d, Nn.NODE_ENV !== "production" ? {
          get attrs() {
            return pr(), Lt(i)
          },
          slots: a,
          emit: l
        } : {
          attrs: i,
          slots: a,
          emit: l
        }) : D(Nn.NODE_ENV !== "production" ? Lt(d) : d, null)), E = t.props ? i : wv(i)
      }
    } catch (D) {
      ls.length = 0, yo(D, e, 1), v = K(It)
    }
    let k = v,
      N;
    if (v.patchFlag > 0 && v.patchFlag & 2048 && ([k, N] = Ic(v)), E && p !== !1) {
      const D = Object.keys(E),
        {
          shapeFlag: O
        } = k;
      if (D.length) {
        if (O & 7) r && D.some(Fs) && (E = Av(E, r)), k = Ln(k, E, !1, !0);
        else if (!Bi && k.type !== It) {
          const A = Object.keys(i),
            b = [],
            C = [];
          for (let y = 0, I = A.length; y < I; y++) {
            const w = A[y];
            Vo(w) ? Fs(w) || b.push(w[2].toLowerCase() + w.slice(3)) : C.push(w)
          }
          C.length && te(`Extraneous non-props attributes (${C.join(", ")}) were passed to component but could not be automatically inherited because component renders fragment or text or teleport root nodes.`), b.length && te(`Extraneous non-emits event listeners (${b.join(", ")}) were passed to component but could not be automatically inherited because component renders fragment or text root nodes. If the listener is intended to be a component custom event listener only, declare it using the "emits" option.`)
        }
      }
    }
    return n.dirs && (Rc(k) || te("Runtime directive used on component with non-element root node. The directives will not function as intended."), k = Ln(k, null, !1, !0), k.dirs = k.dirs ? k.dirs.concat(n.dirs) : n.dirs), n.transition && (Rc(k) || te("Component inside <Transition> renders non-element root node that cannot be animated."), bi(k, n.transition)), N ? N(k) : v = k, ir(m), v
  }
  const Ic = e => {
    const t = e.children,
      n = e.dynamicChildren,
      o = Vi(t, !1);
    if (o) {
      if (o.patchFlag > 0 && o.patchFlag & 2048) return Ic(o)
    } else return [e, void 0];
    const s = t.indexOf(o),
      r = n ? n.indexOf(o) : -1,
      a = i => {
        t[s] = i, n && (r > -1 ? n[r] = i : i.patchFlag > 0 && (e.dynamicChildren = [...n, i]))
      };
    return [Yt(o), a]
  };

  function Vi(e, t = !0) {
    let n;
    for (let o = 0; o < e.length; o++) {
      const s = e[o];
      if (cs(s)) {
        if (s.type !== It || s.children === "v-if") {
          if (n) return;
          if (n = s, t && n.patchFlag > 0 && n.patchFlag & 2048) return Vi(n.children)
        }
      } else return
    }
    return n
  }
  const wv = e => {
      let t;
      for (const n in e)(n === "class" || n === "style" || Vo(n)) && ((t || (t = {}))[n] = e[n]);
      return t
    },
    Av = (e, t) => {
      const n = {};
      for (const o in e)(!Fs(o) || !(o.slice(9) in t)) && (n[o] = e[o]);
      return n
    },
    Rc = e => e.shapeFlag & 7 || e.type === It;

  function Nv(e, t, n) {
    const {
      props: o,
      children: s,
      component: r
    } = e, {
      props: a,
      children: i,
      patchFlag: l
    } = t, c = r.emitsOptions;
    if ((s || i) && tn || t.dirs || t.transition) return !0;
    if (n && l >= 0) {
      if (l & 1024) return !0;
      if (l & 16) return o ? wc(o, a, c) : !!a;
      if (l & 8) {
        const u = t.dynamicProps;
        for (let d = 0; d < u.length; d++) {
          const h = u[d];
          if (a[h] !== o[h] && !fr(c, h)) return !0
        }
      }
    } else return (s || i) && (!i || !i.$stable) ? !0 : o === a ? !1 : o ? a ? wc(o, a, c) : !0 : !!a;
    return !1
  }

  function wc(e, t, n) {
    const o = Object.keys(t);
    if (o.length !== Object.keys(e).length) return !0;
    for (let s = 0; s < o.length; s++) {
      const r = o[s];
      if (t[r] !== e[r] && !fr(n, r)) return !0
    }
    return !1
  }

  function Mv({
    vnode: e,
    parent: t
  }, n) {
    for (; t;) {
      const o = t.subTree;
      if (o.suspense && o.suspense.activeBranch === e && (o.el = e.el), o === e)(e = t.vnode).el = n, t = t.parent;
      else break
    }
  }
  const Ac = e => e.__isSuspense;

  function kv(e, t) {
    t && t.pendingBranch ? ye(e) ? t.effects.push(...e) : t.effects.push(e) : xu(e)
  }
  const J = Symbol.for("v-fgt"),
    is = Symbol.for("v-txt"),
    It = Symbol.for("v-cmt"),
    as = Symbol.for("v-stc"),
    ls = [];
  let Mt = null;

  function g(e = !1) {
    ls.push(Mt = e ? null : [])
  }

  function Lv() {
    ls.pop(), Mt = ls[ls.length - 1] || null
  }
  let us = 1;

  function Nc(e, t = !1) {
    us += e, e < 0 && Mt && t && (Mt.hasOnce = !0)
  }

  function Mc(e) {
    return e.dynamicChildren = us > 0 ? Mt || _o : null, Lv(), us > 0 && Mt && Mt.push(e), e
  }

  function M(e, t, n, o, s, r) {
    return Mc(S(e, t, n, o, s, r, !0))
  }

  function V(e, t, n, o, s) {
    return Mc(K(e, t, n, o, s, !0))
  }

  function cs(e) {
    return e ? e.__v_isVNode === !0 : !1
  }

  function ds(e, t) {
    if (t.shapeFlag & 6 && e.component) {
      const n = sr.get(t.type);
      if (n && n.has(e.component)) return e.shapeFlag &= -257, t.shapeFlag &= -513, !1
    }
    return e.type === t.type && e.key === t.key
  }
  const $v = (...e) => xv(...e),
    kc = ({
      key: e
    }) => e ?? null,
    _r = ({
      ref: e,
      ref_key: t,
      ref_for: n
    }) => (typeof e == "number" && (e = "" + e), e != null ? ze(e) || Fe(e) || be(e) ? {
      i: Xe,
      r: e,
      k: t,
      f: !!n
    } : e : null);

  function S(e, t = null, n = null, o = 0, s = null, r = e === J ? 0 : 1, a = !1, i = !1) {
    const l = {
      __v_isVNode: !0,
      __v_skip: !0,
      type: e,
      props: t,
      key: t && kc(t),
      ref: t && _r(t),
      scopeId: Yu,
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
      shapeFlag: r,
      patchFlag: o,
      dynamicProps: s,
      dynamicChildren: null,
      appContext: null,
      ctx: Xe
    };
    return i ? (Hi(l, n), r & 128 && e.normalize(l)) : n && (l.shapeFlag |= ze(n) ? 8 : 16), l.key !== l.key && te("VNode created with invalid key (NaN). VNode type:", l.type), us > 0 && !a && Mt && (l.patchFlag > 0 || r & 6) && l.patchFlag !== 32 && Mt.push(l), l
  }
  const K = $v;

  function xv(e, t = null, n = null, o = 0, s = null, r = !1) {
    if ((!e || e === Zu) && (e || te(`Invalid vnode type when creating vnode: ${e}.`), e = It), cs(e)) {
      const i = Ln(e, t, !0);
      return n && Hi(i, n), us > 0 && !r && Mt && (i.shapeFlag & 6 ? Mt[Mt.indexOf(e)] = i : Mt.push(i)), i.patchFlag = -2, i
    }
    if (Bc(e) && (e = e.__vccOpts), t) {
      t = Fv(t);
      let {
        class: i,
        style: l
      } = t;
      i && !ze(i) && (t.class = we(i)), Me(l) && (Qo(l) && !ye(l) && (l = Qe({}, l)), t.style = Qt(l))
    }
    const a = ze(e) ? 1 : Ac(e) ? 128 : Nm(e) ? 64 : Me(e) ? 4 : be(e) ? 2 : 0;
    return a & 4 && Qo(e) && (e = De(e), te("Vue received a Component that was made a reactive object. This can lead to unnecessary performance overhead and should be avoided by marking the component with `markRaw` or using `shallowRef` instead of `ref`.", `
Component that was made reactive: `, e)), S(e, t, n, o, s, a, r, !0)
  }

  function Fv(e) {
    return e ? Qo(e) || _c(e) ? Qe({}, e) : e : null
  }

  function Ln(e, t, n = !1, o = !1) {
    const {
      props: s,
      ref: r,
      patchFlag: a,
      children: i,
      transition: l
    } = e, c = t ? Bv(s || {}, t) : s, u = {
      __v_isVNode: !0,
      __v_skip: !0,
      type: e.type,
      props: c,
      key: c && kc(c),
      ref: t && t.ref ? n && r ? ye(r) ? r.concat(_r(t)) : [r, _r(t)] : _r(t) : r,
      scopeId: e.scopeId,
      slotScopeIds: e.slotScopeIds,
      children: a === -1 && ye(i) ? i.map(Lc) : i,
      target: e.target,
      targetStart: e.targetStart,
      targetAnchor: e.targetAnchor,
      staticCount: e.staticCount,
      shapeFlag: e.shapeFlag,
      patchFlag: t && e.type !== J ? a === -1 ? 16 : a | 16 : a,
      dynamicProps: e.dynamicProps,
      dynamicChildren: e.dynamicChildren,
      appContext: e.appContext,
      dirs: e.dirs,
      transition: l,
      component: e.component,
      suspense: e.suspense,
      ssContent: e.ssContent && Ln(e.ssContent),
      ssFallback: e.ssFallback && Ln(e.ssFallback),
      placeholder: e.placeholder,
      el: e.el,
      anchor: e.anchor,
      ctx: e.ctx,
      ce: e.ce
    };
    return l && o && bi(u, l.clone(u)), u
  }

  function Lc(e) {
    const t = Ln(e);
    return ye(e.children) && (t.children = e.children.map(Lc)), t
  }

  function Po(e = " ", t = 0) {
    return K(is, null, e, t)
  }

  function Uv(e, t) {
    const n = K(as, null, e);
    return n.staticCount = t, n
  }

  function oe(e = "", t = !1) {
    return t ? (g(), V(It, null, e)) : K(It, null, e)
  }

  function Yt(e) {
    return e == null || typeof e == "boolean" ? K(It) : ye(e) ? K(J, null, e.slice()) : cs(e) ? $n(e) : K(is, null, String(e))
  }

  function $n(e) {
    return e.el === null && e.patchFlag !== -1 || e.memo ? e : Ln(e)
  }

  function Hi(e, t) {
    let n = 0;
    const {
      shapeFlag: o
    } = e;
    if (t == null) t = null;
    else if (ye(t)) n = 16;
    else if (typeof t == "object")
      if (o & 65) {
        const s = t.default;
        s && (s._c && (s._d = !1), Hi(e, s()), s._c && (s._d = !0));
        return
      } else {
        n = 32;
        const s = t._;
        !s && !_c(t) ? t._ctx = Xe : s === 3 && Xe && (Xe.slots._ === 1 ? t._ = 1 : (t._ = 2, e.patchFlag |= 1024))
      }
    else be(t) ? (t = {
      default: t,
      _ctx: Xe
    }, n = 32) : (t = String(t), o & 64 ? (n = 16, t = [Po(t)]) : n = 8);
    e.children = t, e.shapeFlag |= n
  }

  function Bv(...e) {
    const t = {};
    for (let n = 0; n < e.length; n++) {
      const o = e[n];
      for (const s in o)
        if (s === "class") t.class !== o.class && (t.class = we([t.class, o.class]));
        else if (s === "style") t.style = Qt([t.style, o.style]);
      else if (Vo(s)) {
        const r = t[s],
          a = o[s];
        a && r !== a && !(ye(r) && r.includes(a)) && (t[s] = r ? [].concat(r, a) : a)
      } else s !== "" && (t[s] = o[s])
    }
    return t
  }

  function sn(e, t, n, o = null) {
    Zt(e, t, 7, [n, o])
  }
  const Vv = cc();
  let Hv = 0;

  function Gv(e, t, n) {
    const o = e.type,
      s = (t ? t.appContext : e.appContext) || Vv,
      r = {
        uid: Hv++,
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
        scope: new cu(!0),
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
        propsOptions: mc(o, s),
        emitsOptions: Ec(o, s),
        emit: null,
        emitted: null,
        propsDefaults: Le,
        inheritAttrs: o.inheritAttrs,
        ctx: Le,
        data: Le,
        props: Le,
        attrs: Le,
        slots: Le,
        refs: Le,
        setupState: Le,
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
    return r.ctx = Wm(r), r.root = t ? t.root : r, r.emit = Iv.bind(null, r), e.ce && e.ce(r), r
  }
  let Je = null;
  const hr = () => Je || Xe;
  let mr, Gi;
  {
    const e = jo(),
      t = (n, o) => {
        let s;
        return (s = e[n]) || (s = e[n] = []), s.push(o), r => {
          s.length > 1 ? s.forEach(a => a(r)) : s[0](r)
        }
      };
    mr = t("__VUE_INSTANCE_SETTERS__", n => Je = n), Gi = t("__VUE_SSR_SETTERS__", n => Eo = n)
  }
  const fs = e => {
      const t = Je;
      return mr(e), e.scope.on(), () => {
        e.scope.off(), mr(t)
      }
    },
    $c = () => {
      Je && Je.scope.off(), mr(null)
    },
    jv = fn("slot,component");

  function ji(e, {
    isNativeTag: t
  }) {
    (jv(e) || t(e)) && te("Do not use built-in or reserved HTML elements as component id: " + e)
  }

  function xc(e) {
    return e.vnode.shapeFlag & 4
  }
  let Eo = !1;

  function zv(e, t = !1, n = !1) {
    t && Gi(t);
    const {
      props: o,
      children: s
    } = e.vnode, r = xc(e);
    iv(e, o, r, t), vv(e, s, n || t);
    const a = r ? Yv(e, t) : void 0;
    return t && Gi(!1), a
  }

  function Yv(e, t) {
    var n;
    const o = e.type;
    {
      if (o.name && ji(o.name, e.appContext.config), o.components) {
        const r = Object.keys(o.components);
        for (let a = 0; a < r.length; a++) ji(r[a], e.appContext.config)
      }
      if (o.directives) {
        const r = Object.keys(o.directives);
        for (let a = 0; a < r.length; a++) Ku(r[a])
      }
      o.compilerOptions && Kv() && te('"compilerOptions" is only supported when using a build of Vue that includes the runtime compiler. Since you are using a runtime-only build, the options should be passed via your build tool config instead.')
    }
    e.accessCache = Object.create(null), e.proxy = new Proxy(e.ctx, oc), qm(e);
    const {
      setup: s
    } = o;
    if (s) {
      Gt();
      const r = e.setupContext = s.length > 1 ? Qv(e) : null,
        a = fs(e),
        i = go(s, e, 0, [Lt(e.props), r]),
        l = Zr(i);
      if (jt(), a(), (l || e.sp) && !bo(e) && Si(e), l) {
        if (i.then($c, $c), t) return i.then(c => {
          Fc(e, c, t)
        }).catch(c => {
          yo(c, e, 0)
        });
        if (e.asyncDep = i, !e.suspense) {
          const c = (n = o.name) != null ? n : "Anonymous";
          te(`Component <${c}>: setup function returned a promise, but no <Suspense> boundary was found in the parent component tree. A component with async setup() must be nested in a <Suspense> in order to be rendered.`)
        }
      } else Fc(e, i, t)
    } else Uc(e, t)
  }

  function Fc(e, t, n) {
    be(t) ? e.type.__ssrInlineRender ? e.ssrRender = t : e.render = t : Me(t) ? (cs(t) && te("setup() should not return VNodes directly - return a render function instead."), e.devtoolsRawSetupState = t, e.setupState = Nu(t), Qm(e)) : t !== void 0 && te(`setup() should return an object. Received: ${t===null?"null":typeof t}`), Uc(e, n)
  }
  const Kv = () => !0;

  function Uc(e, t, n) {
    const o = e.type;
    e.render || (e.render = o.render || ct);
    {
      const s = fs(e);
      Gt();
      try {
        Jm(e)
      } finally {
        jt(), s()
      }
    }!o.render && e.render === ct && !t && (o.template ? te('Component provided template option but runtime compilation is not supported in this build of Vue. Configure your bundler to alias "vue" to "vue/dist/vue.esm-bundler.js".') : te("Component is missing template or render function: ", o))
  }
  const Wv = {
    get(e, t) {
      return pr(), nt(e, "get", ""), e[t]
    },
    set() {
      return te("setupContext.attrs is readonly."), !1
    },
    deleteProperty() {
      return te("setupContext.attrs is readonly."), !1
    }
  };

  function qv(e) {
    return new Proxy(e.slots, {
      get(t, n) {
        return nt(e, "get", "$slots"), t[n]
      }
    })
  }

  function Qv(e) {
    const t = n => {
      if (e.exposed && te("expose() should be called only once per setup()."), n != null) {
        let o = typeof n;
        o === "object" && (ye(n) ? o = "array" : Fe(n) && (o = "ref")), o !== "object" && te(`expose() should be passed a plain object, received ${o}.`)
      }
      e.exposed = n || {}
    };
    {
      let n, o;
      return Object.freeze({
        get attrs() {
          return n || (n = new Proxy(e.attrs, Wv))
        },
        get slots() {
          return o || (o = qv(e))
        },
        get emit() {
          return (s, ...r) => e.emit(s, ...r)
        },
        expose: t
      })
    }
  }

  function vr(e) {
    return e.exposed ? e.exposeProxy || (e.exposeProxy = new Proxy(Nu(_n(e.exposed)), {
      get(t, n) {
        if (n in t) return t[n];
        if (n in Xn) return Xn[n](e)
      },
      has(t, n) {
        return n in t || n in Xn
      }
    })) : e.proxy
  }
  const Xv = /(?:^|[-_])\w/g,
    Jv = e => e.replace(Xv, t => t.toUpperCase()).replace(/[-_]/g, "");

  function gr(e, t = !0) {
    return be(e) ? e.displayName || e.name : e.name || t && e.__name
  }

  function yr(e, t, n = !1) {
    let o = gr(t);
    if (!o && t.__file) {
      const s = t.__file.match(/([^/\\]+)\.\w+$/);
      s && (o = s[1])
    }
    if (!o && e && e.parent) {
      const s = r => {
        for (const a in r)
          if (r[a] === t) return a
      };
      o = s(e.components || e.parent.type.components) || s(e.appContext.components)
    }
    return o ? Jv(o) : n ? "App" : "Anonymous"
  }

  function Bc(e) {
    return be(e) && "__vccOpts" in e
  }
  const R = (e, t) => {
    const n = um(e, t, Eo);
    {
      const o = hr();
      o && o.appContext.config.warnRecursiveComputed && (n._warnRecursive = !0)
    }
    return n
  };

  function Zv() {
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
          if (!Me(d)) return null;
          if (d.__isVue) return ["div", e, "VueInstance"];
          if (Fe(d)) {
            Gt();
            const h = d.value;
            return jt(), ["div", {},
              ["span", e, u(d)], "<", i(h), ">"
            ]
          } else {
            if (zt(d)) return ["div", {},
              ["span", e, mt(d) ? "ShallowReactive" : "Reactive"], "<", i(d), `>${Jt(d)?" (readonly)":""}`
            ];
            if (Jt(d)) return ["div", {},
              ["span", e, mt(d) ? "ShallowReadonly" : "Readonly"], "<", i(d), ">"
            ]
          }
          return null
        },
        hasBody(d) {
          return d && d.__isVue
        },
        body(d) {
          if (d && d.__isVue) return ["div", {}, ...r(d.$)]
        }
      };

    function r(d) {
      const h = [];
      d.type.props && d.props && h.push(a("props", De(d.props))), d.setupState !== Le && h.push(a("setup", d.setupState)), d.data !== Le && h.push(a("data", De(d.data)));
      const f = l(d, "computed");
      f && h.push(a("computed", f));
      const _ = l(d, "inject");
      return _ && h.push(a("injected", _)), h.push(["div", {},
        ["span", {
          style: o.style + ";opacity:0.66"
        }, "$ (internal): "],
        ["object", {
          object: d
        }]
      ]), h
    }

    function a(d, h) {
      return h = Qe({}, h), Object.keys(h).length ? ["div", {
          style: "line-height:1.25em;margin-bottom:0.6em"
        },
        ["div", {
          style: "color:#476582"
        }, d],
        ["div", {
          style: "padding-left:1.25em"
        }, ...Object.keys(h).map(f => ["div", {},
          ["span", o, f + ": "], i(h[f], !1)
        ])]
      ] : ["span", {}]
    }

    function i(d, h = !0) {
      return typeof d == "number" ? ["span", t, d] : typeof d == "string" ? ["span", n, JSON.stringify(d)] : typeof d == "boolean" ? ["span", o, d] : Me(d) ? ["object", {
        object: h ? De(d) : d
      }] : ["span", n, String(d)]
    }

    function l(d, h) {
      const f = d.type;
      if (be(f)) return;
      const _ = {};
      for (const p in d.ctx) c(f, p, h) && (_[p] = d.ctx[p]);
      return _
    }

    function c(d, h, f) {
      const _ = d[f];
      if (ye(_) && _.includes(h) || Me(_) && h in _ || d.extends && c(d.extends, h, f) || d.mixins && d.mixins.some(p => c(p, h, f))) return !0
    }

    function u(d) {
      return mt(d) ? "ShallowRef" : d.effect ? "ComputedRef" : "Ref"
    }
    window.devtoolsFormatters ? window.devtoolsFormatters.push(s) : window.devtoolsFormatters = [s]
  }
  const Vc = "3.5.21",
    rn = te;
  let zi;
  const Hc = typeof window < "u" && window.trustedTypes;
  if (Hc) try {
    zi = Hc.createPolicy("vue", {
      createHTML: e => e
    })
  } catch (e) {
    rn(`Error creating trusted types policy: ${e}`)
  }
  const Gc = zi ? e => zi.createHTML(e) : e => e,
    eg = "http://www.w3.org/2000/svg",
    tg = "http://www.w3.org/1998/Math/MathML",
    gn = typeof document < "u" ? document : null,
    jc = gn && gn.createElement("template"),
    ng = {
      insert: (e, t, n) => {
        t.insertBefore(e, n || null)
      },
      remove: e => {
        const t = e.parentNode;
        t && t.removeChild(e)
      },
      createElement: (e, t, n, o) => {
        const s = t === "svg" ? gn.createElementNS(eg, e) : t === "mathml" ? gn.createElementNS(tg, e) : n ? gn.createElement(e, {
          is: n
        }) : gn.createElement(e);
        return e === "select" && o && o.multiple != null && s.setAttribute("multiple", o.multiple), s
      },
      createText: e => gn.createTextNode(e),
      createComment: e => gn.createComment(e),
      setText: (e, t) => {
        e.nodeValue = t
      },
      setElementText: (e, t) => {
        e.textContent = t
      },
      parentNode: e => e.parentNode,
      nextSibling: e => e.nextSibling,
      querySelector: e => gn.querySelector(e),
      setScopeId(e, t) {
        e.setAttribute(t, "")
      },
      insertStaticContent(e, t, n, o, s, r) {
        const a = n ? n.previousSibling : t.lastChild;
        if (s && (s === r || s.nextSibling))
          for (; t.insertBefore(s.cloneNode(!0), n), !(s === r || !(s = s.nextSibling)););
        else {
          jc.innerHTML = Gc(o === "svg" ? `<svg>${e}</svg>` : o === "mathml" ? `<math>${e}</math>` : e);
          const i = jc.content;
          if (o === "svg" || o === "mathml") {
            const l = i.firstChild;
            for (; l.firstChild;) i.appendChild(l.firstChild);
            i.removeChild(l)
          }
          t.insertBefore(i, n)
        }
        return [a ? a.nextSibling : t.firstChild, n ? n.previousSibling : t.lastChild]
      }
    },
    og = Symbol("_vtc");

  function sg(e, t, n) {
    const o = e[og];
    o && (t = (t ? [t, ...o] : [...o]).join(" ")), t == null ? e.removeAttribute("class") : n ? e.setAttribute("class", t) : e.className = t
  }
  const Cr = Symbol("_vod"),
    zc = Symbol("_vsh"),
    Kt = {
      name: "show",
      beforeMount(e, {
        value: t
      }, {
        transition: n
      }) {
        e[Cr] = e.style.display === "none" ? "" : e.style.display, n && t ? n.beforeEnter(e) : ps(e, t)
      },
      mounted(e, {
        value: t
      }, {
        transition: n
      }) {
        n && t && n.enter(e)
      },
      updated(e, {
        value: t,
        oldValue: n
      }, {
        transition: o
      }) {
        !t != !n && (o ? t ? (o.beforeEnter(e), ps(e, !0), o.enter(e)) : o.leave(e, () => {
          ps(e, !1)
        }) : ps(e, t))
      },
      beforeUnmount(e, {
        value: t
      }) {
        ps(e, t)
      }
    };

  function ps(e, t) {
    e.style.display = t ? e[Cr] : "none", e[zc] = !t
  }
  const rg = Symbol("CSS_VAR_TEXT"),
    ig = /(?:^|;)\s*display\s*:/;

  function ag(e, t, n) {
    const o = e.style,
      s = ze(n);
    let r = !1;
    if (n && !s) {
      if (t)
        if (ze(t))
          for (const a of t.split(";")) {
            const i = a.slice(0, a.indexOf(":")).trim();
            n[i] == null && Tr(o, i, "")
          } else
            for (const a in t) n[a] == null && Tr(o, a, "");
      for (const a in n) a === "display" && (r = !0), Tr(o, a, n[a])
    } else if (s) {
      if (t !== n) {
        const a = o[rg];
        a && (n += ";" + a), o.cssText = n, r = ig.test(n)
      }
    } else t && e.removeAttribute("style");
    Cr in e && (e[Cr] = r ? o.display : "", e[zc] && (o.display = "none"))
  }
  const lg = /[^\\];\s*$/,
    Yc = /\s*!important$/;

  function Tr(e, t, n) {
    if (ye(n)) n.forEach(o => Tr(e, t, o));
    else if (n == null && (n = ""), lg.test(n) && rn(`Unexpected semicolon at the end of '${t}' style value: '${n}'`), t.startsWith("--")) e.setProperty(t, n);
    else {
      const o = ug(e, t);
      Yc.test(n) ? e.setProperty(wn(o), n.replace(Yc, ""), "important") : e[o] = n
    }
  }
  const Kc = ["Webkit", "Moz", "ms"],
    Yi = {};

  function ug(e, t) {
    const n = Yi[t];
    if (n) return n;
    let o = ht(t);
    if (o !== "filter" && o in e) return Yi[t] = o;
    o = Gn(o);
    for (let s = 0; s < Kc.length; s++) {
      const r = Kc[s] + o;
      if (r in e) return Yi[t] = r
    }
    return t
  }
  const Wc = "http://www.w3.org/1999/xlink";

  function qc(e, t, n, o, s, r = Lh(t)) {
    o && t.startsWith("xlink:") ? n == null ? e.removeAttributeNS(Wc, t.slice(6, t.length)) : e.setAttributeNS(Wc, t, n) : n == null || r && !au(n) ? e.removeAttribute(t) : e.setAttribute(t, r ? "" : Vt(n) ? String(n) : n)
  }

  function Qc(e, t, n, o, s) {
    if (t === "innerHTML" || t === "textContent") {
      n != null && (e[t] = t === "innerHTML" ? Gc(n) : n);
      return
    }
    const r = e.tagName;
    if (t === "value" && r !== "PROGRESS" && !r.includes("-")) {
      const i = r === "OPTION" ? e.getAttribute("value") || "" : e.value,
        l = n == null ? e.type === "checkbox" ? "on" : "" : String(n);
      (i !== l || !("_value" in e)) && (e.value = l), n == null && e.removeAttribute(t), e._value = n;
      return
    }
    let a = !1;
    if (n === "" || n == null) {
      const i = typeof e[t];
      i === "boolean" ? n = au(n) : n == null && i === "string" ? (n = "", a = !0) : i === "number" && (n = 0, a = !0)
    }
    try {
      e[t] = n
    } catch (i) {
      a || rn(`Failed setting prop "${t}" on <${r.toLowerCase()}>: value ${n} is invalid.`, i)
    }
    a && e.removeAttribute(s || t)
  }

  function yn(e, t, n, o) {
    e.addEventListener(t, n, o)
  }

  function cg(e, t, n, o) {
    e.removeEventListener(t, n, o)
  }
  const Xc = Symbol("_vei");

  function dg(e, t, n, o, s = null) {
    const r = e[Xc] || (e[Xc] = {}),
      a = r[t];
    if (o && a) a.value = Zc(o, t);
    else {
      const [i, l] = fg(t);
      if (o) {
        const c = r[t] = hg(Zc(o, t), s);
        yn(e, i, c, l)
      } else a && (cg(e, i, a, l), r[t] = void 0)
    }
  }
  const Jc = /(?:Once|Passive|Capture)$/;

  function fg(e) {
    let t;
    if (Jc.test(e)) {
      t = {};
      let o;
      for (; o = e.match(Jc);) e = e.slice(0, e.length - o[0].length), t[o[0].toLowerCase()] = !0
    }
    return [e[2] === ":" ? e.slice(3) : wn(e.slice(2)), t]
  }
  let Ki = 0;
  const pg = Promise.resolve(),
    _g = () => Ki || (pg.then(() => Ki = 0), Ki = Date.now());

  function hg(e, t) {
    const n = o => {
      if (!o._vts) o._vts = Date.now();
      else if (o._vts <= n.attached) return;
      Zt(mg(o, n.value), t, 5, [o])
    };
    return n.value = e, n.attached = _g(), n
  }

  function Zc(e, t) {
    return be(e) || ye(e) ? e : (rn(`Wrong type passed as event handler to ${t} - did you forget @ or : in front of your prop?
Expected function or array of functions, received type ${typeof e}.`), ct)
  }

  function mg(e, t) {
    if (ye(t)) {
      const n = e.stopImmediatePropagation;
      return e.stopImmediatePropagation = () => {
        n.call(e), e._stopped = !0
      }, t.map(o => s => !s._stopped && o && o(s))
    } else return t
  }
  const ed = e => e.charCodeAt(0) === 111 && e.charCodeAt(1) === 110 && e.charCodeAt(2) > 96 && e.charCodeAt(2) < 123,
    vg = (e, t, n, o, s, r) => {
      const a = s === "svg";
      t === "class" ? sg(e, o, a) : t === "style" ? ag(e, n, o) : Vo(t) ? Fs(t) || dg(e, t, n, o, r) : (t[0] === "." ? (t = t.slice(1), !0) : t[0] === "^" ? (t = t.slice(1), !1) : gg(e, t, o, a)) ? (Qc(e, t, o), !e.tagName.includes("-") && (t === "value" || t === "checked" || t === "selected") && qc(e, t, o, a, r, t !== "value")) : e._isVueCE && (/[A-Z]/.test(t) || !ze(o)) ? Qc(e, ht(t), o, r, t) : (t === "true-value" ? e._trueValue = o : t === "false-value" && (e._falseValue = o), qc(e, t, o, a))
    };

  function gg(e, t, n, o) {
    if (o) return !!(t === "innerHTML" || t === "textContent" || t in e && ed(t) && be(n));
    if (t === "spellcheck" || t === "draggable" || t === "translate" || t === "autocorrect" || t === "form" || t === "list" && e.tagName === "INPUT" || t === "type" && e.tagName === "TEXTAREA") return !1;
    if (t === "width" || t === "height") {
      const s = e.tagName;
      if (s === "IMG" || s === "VIDEO" || s === "CANVAS" || s === "SOURCE") return !1
    }
    return ed(t) && ze(n) ? !1 : t in e
  }
  const xn = e => {
    const t = e.props["onUpdate:modelValue"] || !1;
    return ye(t) ? n => mo(t, n) : t
  };

  function yg(e) {
    e.target.composing = !0
  }

  function td(e) {
    const t = e.target;
    t.composing && (t.composing = !1, t.dispatchEvent(new Event("input")))
  }
  const $t = Symbol("_assign"),
    yt = {
      created(e, {
        modifiers: {
          lazy: t,
          trim: n,
          number: o
        }
      }, s) {
        e[$t] = xn(s);
        const r = o || s.props && s.props.type === "number";
        yn(e, t ? "change" : "input", a => {
          if (a.target.composing) return;
          let i = e.value;
          n && (i = i.trim()), r && (i = Vs(i)), e[$t](i)
        }), n && yn(e, "change", () => {
          e.value = e.value.trim()
        }), t || (yn(e, "compositionstart", yg), yn(e, "compositionend", td), yn(e, "change", td))
      },
      mounted(e, {
        value: t
      }) {
        e.value = t ?? ""
      },
      beforeUpdate(e, {
        value: t,
        oldValue: n,
        modifiers: {
          lazy: o,
          trim: s,
          number: r
        }
      }, a) {
        if (e[$t] = xn(a), e.composing) return;
        const i = (r || e.type === "number") && !/^0\d/.test(e.value) ? Vs(e.value) : e.value,
          l = t ?? "";
        i !== l && (document.activeElement === e && e.type !== "range" && (o && t === n || s && e.value.trim() === l) || (e.value = l))
      }
    },
    Wi = {
      deep: !0,
      created(e, t, n) {
        e[$t] = xn(n), yn(e, "change", () => {
          const o = e._modelValue,
            s = Oo(e),
            r = e.checked,
            a = e[$t];
          if (ye(o)) {
            const i = ni(o, s),
              l = i !== -1;
            if (r && !l) a(o.concat(s));
            else if (!r && l) {
              const c = [...o];
              c.splice(i, 1), a(c)
            }
          } else if (ho(o)) {
            const i = new Set(o);
            r ? i.add(s) : i.delete(s), a(i)
          } else a(rd(e, r))
        })
      },
      mounted: nd,
      beforeUpdate(e, t, n) {
        e[$t] = xn(n), nd(e, t, n)
      }
    };

  function nd(e, {
    value: t,
    oldValue: n
  }, o) {
    e._modelValue = t;
    let s;
    if (ye(t)) s = ni(t, o.props.value) > -1;
    else if (ho(t)) s = t.has(o.props.value);
    else {
      if (t === n) return;
      s = zn(t, rd(e, !0))
    }
    e.checked !== s && (e.checked = s)
  }
  const od = {
      created(e, {
        value: t
      }, n) {
        e.checked = zn(t, n.props.value), e[$t] = xn(n), yn(e, "change", () => {
          e[$t](Oo(e))
        })
      },
      beforeUpdate(e, {
        value: t,
        oldValue: n
      }, o) {
        e[$t] = xn(o), t !== n && (e.checked = zn(t, o.props.value))
      }
    },
    We = {
      deep: !0,
      created(e, {
        value: t,
        modifiers: {
          number: n
        }
      }, o) {
        const s = ho(t);
        yn(e, "change", () => {
          const r = Array.prototype.filter.call(e.options, a => a.selected).map(a => n ? Vs(Oo(a)) : Oo(a));
          e[$t](e.multiple ? s ? new Set(r) : r : r[0]), e._assigning = !0, Xo(() => {
            e._assigning = !1
          })
        }), e[$t] = xn(o)
      },
      mounted(e, {
        value: t
      }) {
        sd(e, t)
      },
      beforeUpdate(e, t, n) {
        e[$t] = xn(n)
      },
      updated(e, {
        value: t
      }) {
        e._assigning || sd(e, t)
      }
    };

  function sd(e, t) {
    const n = e.multiple,
      o = ye(t);
    if (n && !o && !ho(t)) {
      rn(`<select multiple v-model> expects an Array or Set value for its binding, but got ${Object.prototype.toString.call(t).slice(8,-1)}.`);
      return
    }
    for (let s = 0, r = e.options.length; s < r; s++) {
      const a = e.options[s],
        i = Oo(a);
      if (n)
        if (o) {
          const l = typeof i;
          l === "string" || l === "number" ? a.selected = t.some(c => String(c) === String(i)) : a.selected = ni(t, i) > -1
        } else a.selected = t.has(i);
      else if (zn(Oo(a), t)) {
        e.selectedIndex !== s && (e.selectedIndex = s);
        return
      }
    }!n && e.selectedIndex !== -1 && (e.selectedIndex = -1)
  }

  function Oo(e) {
    return "_value" in e ? e._value : e.value
  }

  function rd(e, t) {
    const n = t ? "_trueValue" : "_falseValue";
    return n in e ? e[n] : t
  }
  const Cg = ["ctrl", "shift", "alt", "meta"],
    Tg = {
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
      exact: (e, t) => Cg.some(n => e[`${n}Key`] && !t.includes(n))
    },
    br = (e, t) => {
      const n = e._withMods || (e._withMods = {}),
        o = t.join(".");
      return n[o] || (n[o] = ((s, ...r) => {
        for (let a = 0; a < t.length; a++) {
          const i = Tg[t[a]];
          if (i && i(s, t)) return
        }
        return e(s, ...r)
      }))
    },
    bg = Qe({
      patchProp: vg
    }, ng);
  let id;

  function Sg() {
    return id || (id = Cv(bg))
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
  class F1 {
    clientKey = null;
    constructor(t) {
      if (!k1.includes(t)) throw new Error("존재하지 않는 사용자입니다");
      this.clientKey = t
    }
    init(t, n) {
      const {
        target: o,
        pdtCode: s,
        pttCode: r,
        locale: a = "ko",
        member: i,
        deviceType: l = "pc"
      } = t, c = document.querySelector(o);
      if (!c) throw new Error("주문위젯을 띄울 요소를 찾을 수 없습니다");
      const u = c.attachShadow({
          mode: "open"
        }),
        d = document.createElement("div");
      d.id = "red-widget-root", u.appendChild(d);
      const h = !M1.has(s),
        f = ad(h ? T1 : D1);
      if (!s) throw new Error("제품 코드를 설정해주세요");
      if (!["ko", "en"].includes(a)) throw new Error("지원하지 않는 언어입니다");
      if (f.use(QC()), f.use(A0), f.use(oT), Dt().setLocale(a), f.provide("deviceType", l), f.provide("productCode", {
          pdtCode: s,
          pttCode: r
        }), f.provide("callbacks", n), f.provide("member", i), h) {
        const v = xe({
          editingYn: "N"
        });
        f.provide("editorData", v)
      }
      return x1(u, "https://d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/prod/widget.css"), f.mount(d), h ? new L1(t) : new $1(t)
    }
  }
  window.RedWidgetSDK = F1;
  const Ul = (e, t, n) => {
      const o = e[t];
      return o ? typeof o == "function" ? o() : Promise.resolve(o) : new Promise((s, r) => {
        (typeof queueMicrotask == "function" ? queueMicrotask : setTimeout)(r.bind(null, new Error("Unknown variable dynamic import: " + t + (t.split("/").length !== n ? ". Note that variables only represent file names one level deep." : ""))))
      })
    },
    U1 = {
      class: "subject"
    },
    fe = Be(re({
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
        return (t, n) => (g(), M("fieldset", {
          class: we(["option-row", t.rowClass]),
          style: Qt(t.priority ? {
            order: t.priority
          } : null)
        }, [t.title ? (g(), M("legend", {
          key: 0,
          class: we(["title", {
            underline: t.underline
          }])
        }, [S("span", U1, j(T(x)(t.title)), 1), t.extra ? (g(), M("button", {
          key: 0,
          type: "button",
          class: we(["extra-btn", t.extra.style]),
          onClick: n[0] || (n[0] = (...o) => t.extra.callback && t.extra.callback(...o))
        }, j(T(x)(t.extra.name)), 3)) : oe("", !0)], 2)) : oe("", !0), Oi(t.$slots, "default", {}, void 0, !0)], 6))
      }
    }), [
      ["__scopeId", "data-v-595f7226"]
    ]),
    B1 = {
      class: "icon-wrap"
    },
    V1 = ["src", "alt"],
    H1 = {
      class: "icon-name"
    },
    G1 = {
      key: 0,
      class: "pc-tip"
    },
    j1 = ["src", "alt", "data-idx"],
    je = Be(re({
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
          s = le("deviceType", "pc"),
          r = R(() => n.data.forcedImg ? n.data.imgPath : `${qe}/ordericon/${n.data.imgPath}.png`),
          a = R(() => `${qe}/ordericon/${n.data.subImgPath}.png`);

        function i() {
          n.disabled || o("select", n.data)
        }

        function l(c) {
          const u = c.target;
          u && (u.src = a.value, u.onerror = () => {
            u.src = `${qe}/ordericon/order_icon1-3.png`
          })
        }
        return (c, u) => de((g(), M("div", {
          onClick: i,
          class: we(["icon-checkbox", {
            disabled: c.disabledStyling && c.disabled
          }])
        }, [S("div", {
          class: we(["icon-label", {
            active: c.active
          }])
        }, [S("div", B1, [S("img", {
          src: r.value,
          alt: c.data.name,
          onError: l
        }, null, 40, V1)])], 2), S("span", H1, j(T(x)(c.data.name)), 1), (!T(s) || T(s) === "pc") && c.tip ? (g(), M("div", G1, [(g(), M("img", {
          src: c.tip.IMG_URL,
          alt: c.tip.IMG_ALT,
          key: c.tip.IDX,
          "data-idx": c.tip.IDX
        }, null, 8, j1))])) : oe("", !0), Oi(c.$slots, "input", {}, void 0, !0)], 2)), [
          [Kt, !c.forceHidden]
        ])
      }
    }), [
      ["__scopeId", "data-v-a9670923"]
    ]),
    z1 = {
      class: "flex-row"
    },
    Y1 = re({
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
          r = le("callbacks", {}),
          a = [{
            value: "W",
            name: "가로",
            imgPath: "order_icon1-3"
          }, {
            value: "H",
            name: "세로",
            imgPath: "order_icon1-2"
          }],
          i = H("H"),
          l = () => {
            r?.onReset && r.onReset("direction")
          };
        F(() => i.value, u => {
          s.isAfterEdit() && l(), o("update", {
            COD: i.value,
            COD_NME: x(u === "H" ? "세로" : "가로")
          })
        }, {
          immediate: !0
        });
        const c = R(() => {
          if (!n.relatedData.sizeInfo) return;
          const {
            DIV_NM: u,
            cutSize: d
          } = n.relatedData.sizeInfo;
          if (u === "사이즈직접입력" || u === "Input Size") {
            if (d.height > d.width) return "H";
            if (d.height === d.width) return i.value;
            if (d.height < d.width) return "W"
          }
        });
        return F(() => c.value, u => {
          u && (i.value = u)
        }, {
          immediate: !0
        }), (u, d) => (g(), V(fe, {
          title: "주문서작성"
        }, {
          default: ce(() => [S("div", z1, [(g(), M(J, null, he(a, h => K(je, {
            key: h.value,
            data: h,
            active: i.value === h.value,
            disabled: c.value && c.value !== h.value,
            "disabled-styling": !!c.value,
            onSelect: d[0] || (d[0] = f => i.value = f.value)
          }, null, 8, ["data", "active", "disabled", "disabled-styling"])), 64))])]),
          _: 1
        }))
      }
    }),
    K1 = {},
    W1 = {
      width: "11",
      height: "11",
      viewBox: "0 0 11 11",
      fill: "none",
      xmlns: "http://www.w3.org/2000/svg"
    };

  function q1(e, t) {
    return g(), M("svg", W1, [...t[0] || (t[0] = [S("path", {
      d: "M6.45182 8.66273C7.95026 8.02116 9.0001 6.53317 9.0001 4.79998C9.0001 2.48038 7.11969 0.599976 4.8001 0.599976C2.4805 0.599976 0.600098 2.48038 0.600098 4.79998C0.600098 7.11957 2.4805 8.99998 4.8001 8.99998",
      stroke: "white",
      "stroke-width": "1.2",
      "stroke-linecap": "round"
    }, null, -1), S("path", {
      d: "M8.16007 8.16L10.4001 10.4",
      stroke: "white",
      "stroke-width": "1.2",
      "stroke-linecap": "round"
    }, null, -1)])])
  }
  const Q1 = Be(K1, [
      ["render", q1]
    ]),
    X1 = ["disabled", "onClick"],
    J1 = {
      key: 0,
      class: "mobile-tip"
    },
    Z1 = {
      key: 0,
      class: "pc-tip"
    },
    eb = ["src", "alt", "data-idx"],
    Sn = Be(re({
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
          s = le("deviceType", "pc"),
          r = H(n.default || n.options[0].value),
          a = i => {
            r.value = i, o("select", i)
          };
        return F(() => n.default, i => {
          i && (r.value = i)
        }), (i, l) => (g(), M("div", {
          class: we(["button-radio", i.type])
        }, [(g(!0), M(J, null, he(i.options, (c, u) => (g(), M("button", {
          type: "button",
          key: c.key,
          class: we([{
            active: c.disabled ? !1 : r.value === c.value
          }]),
          disabled: c.disabled,
          onClick: d => a(c.value)
        }, [Po(j(c.name) + " ", 1), T(s) === "mobile" && i.tips && i.tips[u] ? (g(), M("span", J1, [K(Q1)])) : oe("", !0)], 10, X1))), 128)), i.tips && (!T(s) || T(s) === "pc") ? (g(), M("div", Z1, [(g(!0), M(J, null, he(i.tips, c => (g(), M(J, null, [c ? (g(), M("img", {
          src: c.IMG_URL,
          alt: c.IMG_ALT,
          key: c.IDX,
          "data-idx": c.IDX
        }, null, 8, eb)) : oe("", !0)], 64))), 256))])) : oe("", !0)], 2))
      }
    }), [
      ["__scopeId", "data-v-29046352"]
    ]),
    tb = ["name"],
    nb = ["value", "disabled"],
    Fo = re({
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
        return F(() => s.value, r => {
          o("select", r)
        }), F(() => n.default, r => {
          r && (s.value = r)
        }), (r, a) => de((g(), M("select", {
          "onUpdate:modelValue": a[0] || (a[0] = i => s.value = i),
          name: r.name,
          class: "basic-select"
        }, [(g(!0), M(J, null, he(r.options, i => (g(), M("option", {
          key: `${i.key}`,
          value: i.value,
          disabled: i.disabled
        }, j(i.name) + j(i.disabled ? `(${T(x)("주문불가")})` : ""), 9, nb))), 128))], 8, tb)), [
          [We, s.value]
        ])
      }
    }),
    ob = re({
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
          s = R(() => n.options.MTRL_GRP),
          r = R(() => n.options.PTT_GRP),
          a = R(() => n.options.PTT),
          i = R(() => s.value?.optList.map(_ => ({
            name: _.COD_NME,
            value: _.COD,
            key: _.COD
          }))),
          l = R(() => r.value?.optList.map(_ => ({
            name: _.COD_NME,
            value: _.COD,
            key: _.COD
          }))),
          c = R(() => a.value.optList.filter(p => p.GRP_COD === d.value).map(p => ({
            name: p.COD_NME,
            value: p.COD,
            key: p.COD
          }))),
          u = H(s.value?.optList[0]?.COD),
          d = H(r.value?.optList[0]?.COD),
          h = H(c.value[0]?.value);
        F(() => c.value, _ => {
          h.value = _[0].value
        });
        const f = R(() => ({
          MTRL_GRP: u.value,
          PTT_GRP: d.value,
          PTT: h.value
        }));
        return F(() => f.value, _ => {
          o("update", _)
        }, {
          immediate: !0
        }), (_, p) => (g(), M(J, null, [s.value && i.value ? (g(), V(fe, {
          key: 0,
          title: s.value.grpName
        }, {
          default: ce(() => [K(Sn, {
            options: i.value,
            default: u.value,
            onSelect: p[0] || (p[0] = m => u.value = m)
          }, null, 8, ["options", "default"])]),
          _: 1
        }, 8, ["title"])) : oe("", !0), r.value && l.value ? (g(), V(fe, {
          key: 1,
          title: r.value.grpName
        }, {
          default: ce(() => [K(Sn, {
            options: l.value,
            default: d.value,
            onSelect: p[1] || (p[1] = m => d.value = m)
          }, null, 8, ["options", "default"])]),
          _: 1
        }, 8, ["title"])) : oe("", !0), K(fe, {
          title: a.value.grpName
        }, {
          default: ce(() => [c.value.length > 2 ? (g(), V(Fo, {
            key: 0,
            name: "material-filter",
            options: c.value,
            default: h.value,
            onSelect: p[2] || (p[2] = m => h.value = m)
          }, null, 8, ["options", "default"])) : (g(), V(Sn, {
            key: 1,
            options: c.value,
            default: h.value,
            onSelect: p[3] || (p[3] = m => h.value = m)
          }, null, 8, ["options", "default"]))]),
          _: 1
        }, 8, ["title"])], 64))
      }
    }),
    sb = ["value"],
    rb = re({
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
          s = le("callbacks", {}),
          r = H(n.default || n.data.optList[0].COD),
          a = R(() => n.data.optList.find(c => c.COD === r.value)),
          i = Ve(),
          l = () => {
            s.onReset && s.onReset("color")
          };
        return F(() => a.value, c => {
          i.isAfterEdit() && l(), c && o("update", c)
        }, {
          immediate: !0
        }), (c, u) => (g(), V(fe, {
          title: "컬러"
        }, {
          default: ce(() => [de(S("select", {
            "onUpdate:modelValue": u[0] || (u[0] = d => r.value = d),
            class: "basic-select",
            name: "set-color"
          }, [(g(!0), M(J, null, he(c.data.optList, d => (g(), M("option", {
            key: d.COD,
            value: d.COD
          }, j(d.COD_NME), 9, sb))), 128))], 512), [
            [We, r.value]
          ])]),
          _: 1
        }))
      }
    }),
    W_ = re({
      __name: "Shape",
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
          s = R(() => n.options.map(u => ({
            name: u.COD_NME,
            value: u.COD,
            key: u.COD
          }))),
          r = Ve(),
          a = le("callbacks", {}),
          i = H(n.default || s.value[0].value),
          l = () => {
            a?.onReset && a.onReset("shape")
          },
          c = u => {
            r.isAfterEdit() && l(), i.value = u
          };
        return F(() => i.value, u => {
          const d = n.options.find(h => h.COD === u);
          o("update", d)
        }, {
          immediate: !0
        }), (u, d) => (g(), V(fe, {
          title: "모양"
        }, {
          default: ce(() => [K(Sn, {
            options: s.value,
            default: i.value,
            onSelect: c
          }, null, 8, ["options", "default"])]),
          _: 1
        }))
      }
    }),
    ib = ["value", "disabled"],
    q_ = re({
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
          s = le("callbacks", {}),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = Ve(),
          i = H(n.default?.COD || n.options[0].COD),
          l = R(() => n.options.find(E => E.COD === i.value)),
          c = R(() => r.pdtCode === "GSCDPOP" ? "radio" : "select"),
          u = R(() => r.pdtCode === "GSCDPOP" ? -1 : 0),
          d = {
            GSCDPOP: "인풋카드"
          },
          h = {
            GSCDPOP: {
              SID_X: x("인쇄안함"),
              SID_D: x("인쇄함")
            }
          },
          f = () => {
            s?.onReset && s.onReset("dosu")
          };
        F(() => l.value, v => {
          v && (a.isAfterEdit() && f(), o("update", v))
        }, {
          immediate: !0
        });
        const _ = ["SXHTK013", "SXHTK014", "SXHTK015"],
          p = R(() => !!(_.includes(n.relatedData?.mtrlCd || "") || n.relatedData?.mtrlDosu === "SID_S"));
        F(() => n.relatedData?.mtrlCd, v => {
          v && _.includes(v) && (i.value = "SID_S")
        });
        const m = R(() => a.uploadType.default === "editor" && r.pdtCode === "TPCLECO" || n.relatedData?.mtrlDosu === "SID_D");
        return F(() => a.uploadType.default, v => {
          v === "editor" && r.pdtCode === "TPCLECO" && (i.value = "SID_D")
        }, {
          immediate: !0
        }), F(() => n.relatedData?.mtrlDosu, v => {
          if (v) {
            if (v === "SID_S") return i.value = "SID_S";
            if (v === "SID_D") return i.value = "SID_D"
          }
        }, {
          immediate: !0
        }), (v, E) => (g(), V(fe, {
          title: d[T(r).pdtCode] ?? "인쇄도수",
          priority: u.value
        }, {
          default: ce(() => [c.value === "select" ? de((g(), M("select", {
            key: 0,
            "onUpdate:modelValue": E[0] || (E[0] = k => i.value = k),
            class: "basic-select",
            name: "dosu"
          }, [(g(!0), M(J, null, he(v.options, k => (g(), M("option", {
            key: k.COD,
            value: k.COD,
            disabled: p.value && k.COD === "SID_D" || m.value && k.COD === "SID_S"
          }, j(k.COD_NME), 9, ib))), 128))], 512)), [
            [We, i.value]
          ]) : (g(), V(Sn, {
            key: 1,
            options: v.options.map(k => ({
              name: h[T(r).pdtCode][k.COD] ?? k.COD_NME,
              value: k.COD,
              key: k.COD
            })),
            onSelect: E[1] || (E[1] = k => {
              k !== i.value && (i.value = k)
            })
          }, null, 8, ["options"]))]),
          _: 1
        }, 8, ["title", "priority"]))
      }
    }),
    ab = ["value"],
    lb = re({
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
          s = R(() => n.options.map(a => ({
            name: a.COD_NME,
            value: a.COD,
            key: a.COD
          }))),
          r = H(n.default || s.value[0].value);
        return F(() => r.value, a => {
          o("update", a)
        }, {
          immediate: !0
        }), (a, i) => (g(), V(fe, {
          title: "두께"
        }, {
          default: ce(() => [de(S("select", {
            "onUpdate:modelValue": i[0] || (i[0] = l => r.value = l),
            name: "thickness",
            class: "basic-select"
          }, [(g(!0), M(J, null, he(s.value, l => (g(), M("option", {
            key: l.key,
            value: l.value
          }, j(l.name), 9, ab))), 128))], 512), [
            [We, r.value]
          ])]),
          _: 1
        }))
      }
    }),
    ub = {},
    cb = {
      xmlns: "http://www.w3.org/2000/svg",
      width: "12",
      height: "13",
      viewBox: "0 0 12 13",
      fill: "none"
    };

  function db(e, t) {
    return g(), M("svg", cb, [...t[0] || (t[0] = [S("path", {
      d: "M0.799805 1.30005L11.1998 11.7",
      stroke: "#222222",
      "stroke-width": "0.96",
      "stroke-linecap": "round"
    }, null, -1), S("path", {
      d: "M11.1998 1.30005L0.799805 11.7",
      stroke: "#222222",
      "stroke-width": "0.96",
      "stroke-linecap": "round"
    }, null, -1)])])
  }
  const Kr = Be(ub, [
      ["render", db]
    ]),
    fb = {
      class: "size-desc"
    },
    pb = {
      class: "subject"
    },
    _b = {
      class: "size-group"
    },
    hb = {
      class: we(["size"])
    },
    mb = ["id", "maxlength", "disabled"],
    vb = {
      class: we(["text", "-desc"])
    },
    gb = {
      class: "icon-box"
    },
    yb = {
      class: we(["size"])
    },
    Cb = ["id", "maxlength", "disabled"],
    Tb = {
      class: we(["text", "-desc"])
    },
    Q_ = Be(re({
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
        emit: t
      }) {
        const n = e,
          o = t,
          s = H(0),
          r = H(0),
          a = R(() => ({
            width: s.value,
            height: r.value
          }));
        F(() => a.value, un(l => {
          n.disabled.w || o("update", l)
        }, 200), {
          deep: !0
        }), F(() => n.width, l => {
          s.value = l.value
        }, {
          immediate: !0,
          deep: !0
        }), F(() => n.height, l => {
          r.value = l.value
        }, {
          immediate: !0,
          deep: !0
        });
        const i = Ve();
        return F(() => s.value, l => {
          i.uploadType.default === "pdf" && !n.disabled.w && (s.value = +`${l}`.replace(/\..*$/, ""))
        }), F(() => r.value, l => {
          i.uploadType.default === "pdf" && !n.disabled.w && (r.value = +`${l}`.replace(/\..*$/, ""))
        }), (l, c) => (g(), M("div", fb, [S("h3", pb, j(T(x)(l.title)), 1), S("div", _b, [S("div", hb, [de(S("input", {
          "onUpdate:modelValue": c[0] || (c[0] = u => s.value = u),
          type: "number",
          class: we(["basic-input", "-size", {
            error: l.error
          }]),
          id: `w-${l.title}`,
          maxlength: n.width.maxLength ?? 7,
          disabled: l.disabled.w,
          step: 1
        }, null, 10, mb), [
          [yt, s.value]
        ]), S("span", vb, j(T(x)("가로")), 1), c[2] || (c[2] = S("span", {
          class: we(["text", "-unit"])
        }, "mm", -1))]), S("div", gb, [K(Kr)]), S("div", yb, [de(S("input", {
          "onUpdate:modelValue": c[1] || (c[1] = u => r.value = u),
          type: "number",
          class: we(["basic-input", "-size", {
            error: l.error
          }]),
          id: `h-${l.title}`,
          maxlength: n.height.maxLength ?? 7,
          disabled: l.disabled.h,
          step: "1"
        }, null, 10, Cb), [
          [yt, r.value]
        ]), S("span", Tb, j(T(x)("세로")), 1), c[3] || (c[3] = S("span", {
          class: we(["text", "-unit"])
        }, "mm", -1))])])]))
      }
    }), [
      ["__scopeId", "data-v-84a3b8a4"]
    ]),
    bb = {
      key: 0,
      name: "sizes",
      class: "basic-select"
    },
    Sb = ["value", "disabled"],
    Db = {
      key: 2,
      class: "size-details"
    },
    Pb = {
      key: 0,
      class: we(["note", "error"])
    },
    Bl = Be(re({
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
          r = le("callbacks", {}),
          a = le("productCode", {
            pdtCode: ""
          }),
          i = R(() => {
            const w = new Map;
            return n.options.forEach(U => {
              w.set(U.DIV_SEQ, U)
            }), w
          }),
          l = H(n.default?.DIV_SEQ || n.options.find(w => w.DFT_YN === "Y" && w.HIDE_YN !== "Y")?.DIV_SEQ || n.options.find(w => w.HIDE_YN !== "Y")?.DIV_SEQ || n.options[0]?.DIV_SEQ),
          c = H(n.default ? +n.default.CUT_WDT : l.value ? +i.value.get(l.value)?.CUT_WDT : +n.baseInfo.DFT_CUT_WDT),
          u = H(n.default ? +n.default.CUT_HGH : l.value ? +i.value.get(l.value).CUT_HGH : +n.baseInfo.DFT_CUT_HGH),
          d = R(() => +n.baseInfo.CUT_MRG),
          h = H(c.value + d.value),
          f = H(u.value + d.value),
          _ = R(() => n.relatedData?.sizeFromPostPcs),
          p = R(() => ({
            CUT_WDT: c.value,
            CUT_HGH: u.value,
            WRK_WDT: h.value,
            WRK_HGH: f.value
          })),
          m = R(() => {
            const w = i.value.get(l.value);
            return _.value ? !1 : (w?.DIV_NM === "사이즈직접입력" || w?.DIV_NM === "Input Size" || n.relatedData?.shape === "FR") && s.uploadType.default === "pdf"
          }),
          v = R(() => n.relatedData?.pageDirection);
        rs(() => {
          if (m.value) return;
          const w = v.value;
          if (_.value) c.value = !w || w === "H" ? +_.value.CUT_WDT : +_.value.CUT_HGH, u.value = !w || w === "H" ? +_.value.CUT_HGH : +_.value.CUT_WDT, h.value = !w || w === "H" ? +_.value.WRK_WDT : +_.value.WRK_HGH, f.value = !w || w === "H" ? +_.value.WRK_HGH : +_.value.WRK_WDT;
          else {
            if (!w) return;
            const U = i.value.get(l.value);
            c.value = w === "H" ? +U.CUT_WDT : +U.CUT_HGH, u.value = w === "H" ? +U.CUT_HGH : +U.CUT_WDT
          }
        });
        const E = H(!1),
          k = w => {
            E.value && N(), c.value = w.width, u.value = w.height, s.isAfterEdit() && !E.value && (E.value = !0)
          },
          N = () => {
            !s.isAfterEdit() || n.options.length <= 1 || (r?.onReset && r.onReset("size"), E.value = !1)
          },
          D = R(() => n.relatedData?.shape === "CL"),
          O = Dt();

        function A(w, U) {
          return w > U ? [w, U] : [U, w]
        }

        function b(w, U) {
          return w === "max" ? O.locale === "ko" ? ` 최대 주문 가능 사이즈 [${U}] 보다 큽니다.` : ` Max Size: [${U}]` : O.locale === "ko" ? ` 최소 주문 가능 사이즈 [${U}] 보다 작습니다.` : ` Min Size: [${U}]`
        }

        function C() {
          const w = +n.baseInfo.MAX_CUT_WDT,
            U = +n.baseInfo.MAX_CUT_HGH,
            Z = +n.baseInfo.MIN_CUT_WDT,
            me = +n.baseInfo.MIN_CUT_HGH,
            [_e, B] = A(w, U),
            [W, ue] = A(c.value, u.value),
            lt = B * 2,
            Oe = lt - _e,
            Ke = c.value === W ? "W" : "H",
            Ie = D.value ? `${B} x ${B}` : Ke === "W" ? `${_e} x ${Oe}` : `${Oe} x ${_e}`;
          return ue === B || W === B ? W <= lt - B ? ue >= Z ? {
            error: !1
          } : {
            error: !0,
            message: b("min", `${Z} x ${me}`)
          } : W >= _e ? {
            error: !0,
            message: b("max", Ie)
          } : {
            error: !0,
            message: b("max", `${B} x ${B}`)
          } : c.value + u.value > lt ? {
            error: !0,
            message: b("max", Ie)
          } : W > _e ? {
            error: !0,
            message: b("max", Ie)
          } : W === _e ? ue <= Oe ? ue >= Z ? {
            error: !1
          } : {
            error: !0,
            message: b("min", `${Z} x ${me}`)
          } : {
            error: !0,
            message: b("max", Ie)
          } : {
            error: !1
          }
        }
        const y = R(() => {
          const w = !!s.editorData?.default?.workSize;
          if (!m.value && !w) return {
            error: !1
          };
          if (_.value) return {
            error: !1
          };
          const U = v.value === "W" ? +n.baseInfo.MAX_CUT_HGH : +n.baseInfo.MAX_CUT_WDT,
            Z = v.value === "W" ? +n.baseInfo.MAX_CUT_WDT : +n.baseInfo.MAX_CUT_HGH,
            me = v.value === "W" ? +n.baseInfo.MIN_CUT_HGH : +n.baseInfo.MIN_CUT_WDT,
            _e = v.value === "W" ? +n.baseInfo.MIN_CUT_WDT : +n.baseInfo.MIN_CUT_HGH;
          if (["ACTHDCO", "ACTHFCO"].includes(a.pdtCode)) {
            if (c.value < me || u.value < _e) return {
              error: !0,
              message: b("min", `${me} x ${_e}`)
            };
            if (U !== Z) return C()
          }
          return c.value > U || u.value > Z ? {
            error: !0,
            message: b("max", `${U} x ${Z}`)
          } : c.value < me || u.value < _e ? {
            error: !0,
            message: b("min", `${me} x ${_e}`)
          } : {
            error: !1
          }
        });
        F(() => c.value, w => {
          s.editorData?.cutSize && !m.value || _.value || (h.value = w + d.value)
        }), F(() => u.value, w => {
          s.editorData?.cutSize || _.value || (f.value = w + d.value)
        }), F(() => s.editorData?.default?.workSize, w => {
          if (w) {
            const U = s.editorData?.default?.cutSize;
            c.value = U ? +U.width.toFixed(2) : +(+w.width - d.value).toFixed(2), u.value = U ? +U.height.toFixed(2) : +(+w.height - d.value).toFixed(2), h.value = +w.width.toFixed(2), f.value = +w.height.toFixed(2)
          } else {
            if (s.uploadType.default === "editor" || _.value) return;
            c.value = n.default ? +n.default.CUT_WDT : l.value ? +i.value.get(l.value).CUT_WDT : +n.baseInfo.DFT_CUT_WDT, u.value = n.default ? +n.default.CUT_HGH : l.value ? +i.value.get(l.value).CUT_HGH : +n.baseInfo.DFT_CUT_HGH
          }
        });
        const I = H("");
        return F(() => I.value, w => {
          w && o("update:shape", w)
        }, {
          immediate: !0
        }), F(() => l.value, w => {
          const U = i.value.get(w);
          c.value = +U.CUT_WDT, u.value = +U.CUT_HGH, U.STICKER_TYPE && (I.value = U.STICKER_TYPE);
          const Z = {
            DIV_NM: U?.DIV_NM || "",
            DIV_SEQ: U?.DIV_SEQ,
            DivInfo: {},
            cutSize: {
              width: p.value.CUT_WDT,
              height: p.value.CUT_HGH
            },
            workSize: {
              width: p.value.WRK_WDT,
              height: p.value.WRK_HGH
            }
          };
          o("update", Z)
        }, {
          immediate: !0,
          deep: !0
        }), F(() => n.relatedData?.shape, (w, U) => {
          U !== w && (l.value = n.options.find(Z => Z.STICKER_TYPE === w)?.DIV_SEQ || n.options.find(Z => Z.DFT_YN === "Y")?.DIV_SEQ || n.options[0]?.DIV_SEQ, w === "CL" && (u.value = c.value))
        }, {
          immediate: !0
        }), F(() => p.value, w => {
          const U = i.value.get(_.value ? _.value.DIV_SEQ : l.value),
            Z = {
              DIV_NM: U?.DIV_NM || "",
              DIV_SEQ: U?.DIV_SEQ,
              DivInfo: {},
              cutSize: {
                width: w.CUT_WDT,
                height: w.CUT_HGH
              },
              workSize: {
                width: w.WRK_WDT,
                height: w.WRK_HGH
              }
            };
          o("update", Z)
        }, {
          immediate: !0
        }), F(() => y.value, w => {
          w.error && w.message ? o("validate", [w.message]) : o("validate", null)
        }), F(() => c.value, w => {
          D.value && (u.value = w)
        }), (w, U) => (g(), V(fe, {
          title: "규격-단위",
          option: "Sizes",
          extra: w.showExtra ? {
            name: "규격가이드",
            callback: () => {
              T(r)?.onInformGuide && T(r).onInformGuide("size")
            }
          } : null
        }, {
          default: ce(() => [w.relatedData?.sizeFromPostPcs ? (g(), M("select", bb, [S("option", null, j(p.value.CUT_WDT) + "mmX" + j(p.value.CUT_HGH) + "mm", 1)])) : de((g(), M("select", {
            key: 1,
            "onUpdate:modelValue": U[0] || (U[0] = Z => l.value = Z),
            name: "sizes",
            class: "basic-select",
            onChange: N
          }, [(g(!0), M(J, null, he(w.options, Z => (g(), M("option", {
            key: `${Z.DIV_NM}`,
            value: Z.DIV_SEQ,
            disabled: Z.HIDE_YN === "Y"
          }, j(Z.HIDE_YN !== "Y" ? Z.DIV_NM : `[${T(x)("주문불가")}] ${Z.DIV_NM}`), 9, Sb))), 128))], 544)), [
            [We, l.value]
          ]), w.hiddenSizes ? oe("", !0) : (g(), M("div", Db, [K(Q_, {
            title: "재단사이즈",
            width: {
              value: p.value.CUT_WDT
            },
            height: {
              value: p.value.CUT_HGH
            },
            disabled: {
              w: !m.value || !!_.value,
              h: !m.value || w.relatedData?.shape === "CL" || !!_.value
            },
            error: y.value.error,
            onUpdate: k
          }, null, 8, ["width", "height", "disabled", "error"]), K(Q_, {
            title: "작업사이즈",
            width: {
              value: +p.value.WRK_WDT.toFixed(2)
            },
            height: {
              value: +p.value.WRK_HGH.toFixed(2)
            },
            disabled: {
              w: !0,
              h: !0
            }
          }, null, 8, ["width", "height"]), y.value.error ? (g(), M("p", Pb, j(y.value.message), 1)) : oe("", !0)]))]),
          _: 1
        }, 8, ["extra"]))
      }
    }), [
      ["__scopeId", "data-v-525218ba"]
    ]),
    Eb = {
      class: "flex-row"
    },
    Ob = ["value"],
    Ib = ["value"],
    Rb = {
      class: "notes"
    },
    wb = {
      class: "note red"
    },
    Ab = re({
      __name: "CalendarSetting",
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = t,
          o = le("callbacks", {}),
          s = new Date().getFullYear(),
          r = new Date().getMonth() + 1,
          a = Array.from({
            length: 3
          }, (f, _) => s + _),
          i = Array.from({
            length: 12
          }, (f, _) => _ + 1),
          l = H(r >= 10 ? s + 1 : s),
          c = H(1),
          u = R(() => ({
            year: l.value,
            month: c.value
          })),
          d = Ve(),
          h = () => {
            d.isAfterEdit() && o.onReset && o.onReset("calendar")
          };
        return F(() => u.value, f => {
          n("update", f)
        }, {
          immediate: !0
        }), F(() => d.editorData.default, f => {
          f?.calendarInfo && (l.value = f.calendarInfo.year, c.value = f.calendarInfo.month)
        }), (f, _) => (g(), V(fe, {
          title: "달력시작"
        }, {
          default: ce(() => [S("div", Eb, [de(S("select", {
            "onUpdate:modelValue": _[0] || (_[0] = p => l.value = p),
            name: "starting-year",
            class: "basic-select",
            onChange: h
          }, [(g(!0), M(J, null, he(T(a), p => (g(), M("option", {
            key: p,
            value: p
          }, j(p) + j(T(x)("연도")), 9, Ob))), 128))], 544), [
            [We, l.value]
          ]), de(S("select", {
            "onUpdate:modelValue": _[1] || (_[1] = p => c.value = p),
            name: "starting-month",
            class: "basic-select",
            onChange: h
          }, [(g(!0), M(J, null, he(T(i), p => (g(), M("option", {
            key: p,
            value: p
          }, j(T(x)(`${p}월`)), 9, Ib))), 128))], 544), [
            [We, c.value]
          ])]), S("div", Rb, [S("p", wb, j(T(x)("달력시작설명")), 1)])]),
          _: 1
        }))
      }
    }),
    Nb = {
      key: 0,
      class: "checkbox-group"
    },
    Mb = {
      key: 1,
      class: "guide"
    },
    X_ = Be(re({
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
          r = R(() => ({
            production_check: o.value ? "Y" : "N",
            subject: s.value
          }));
        return F(() => r.value, un(a => {
          n("update", a)
        }, 400)), (a, i) => (g(), V(fe, {
          title: "주문제목"
        }, {
          default: ce(() => [a.isBizMem ? (g(), M("div", Nb, [de(S("input", {
            "onUpdate:modelValue": i[0] || (i[0] = l => o.value = l),
            type: "checkbox",
            id: "production_check",
            class: "checkbox"
          }, null, 512), [
            [Wi, o.value]
          ]), i[2] || (i[2] = S("label", {
            for: "production_check"
          }, "생산확인", -1))])) : oe("", !0), a.isBizMem ? (g(), M("p", Mb, " ※ 영업주문의 경우 '생산확인' 체크시 잡티켓에 [주문제목]에 입력한 내용이 출력됩니다. ")) : oe("", !0), de(S("input", {
            "onUpdate:modelValue": i[1] || (i[1] = l => s.value = l),
            type: "text",
            id: "order-subject",
            class: "basic-input"
          }, null, 512), [
            [yt, s.value]
          ])]),
          _: 1
        }))
      }
    }), [
      ["__scopeId", "data-v-8ebf2fd7"]
    ]),
    J_ = new Set(["PRBKOPR", "PRBKOPB"]),
    kb = new Set(["PER_DFT", "STA_DFT", "RIN_DFT", "RIN_COL", "BID_BOD", "BID_NDB", "BID_RFL", "BID_SIL"]),
    Lb = new Set(["RIN_DFT", "RIN_COL", "PER_DFT"]),
    Vl = re({
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
          s = R(() => {
            const v = [],
              E = [],
              k = [],
              N = [];
            for (const D of n.options) D.PCS_CD === "LAS_DFT" ? v.push(D) : D.PCS_CD.startsWith("THO_") ? E.push(D) : D.PCS_CD === "ROU_DFT" ? k.push(D) : N.push(D);
            return {
              LAS_DFTs: v,
              THO_XXXs: E,
              ROU_DFTs: k,
              ETC: N
            }
          }),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = R(() => n.relatedData.shape),
          i = R(() => n.relatedData.sizeInfo?.DIV_SEQ),
          l = R(() => n.relatedData.sizeInfo?.cutSize),
          c = R(() => n.relatedData.mtrlCd || ""),
          u = R(() => n.disabledOpts ? n.disabledOpts[c.value] || {} : {}),
          d = xe({});

        function h(v) {
          const {
            PCS_CD: E,
            VIEW_YN: k,
            PCS_DTL_CD: N,
            PCS_DTL_NM: D,
            ESN_YN: O
          } = v;
          d[E] = [{
            PCS_CD: E,
            VIEW_YN: k,
            ESN_YN: O,
            selectedOptions: [{
              PCS_CD: E,
              PCS_DTL_CD: N,
              PCS_DTL_NM: D,
              ATTB: ""
            }]
          }]
        }

        function f() {
          const v = s.value.LAS_DFTs.length === 1 ? s.value.LAS_DFTs[0] : s.value.LAS_DFTs.find(E => E.WEB_PCS_DTL_GRP === `LAS_DFT_${a.value||"FR"}`);
          v && h(v)
        }

        function _() {
          let v = null;
          if (s.value.THO_XXXs.length === 1) v = s.value.THO_XXXs[0];
          else if (typeof i.value == "number" && a.value) {
            const E = a.value.length > 2 ? a.value.slice(0, 2) : a.value;
            v = s.value.THO_XXXs.find(k => k.WEB_PCS_DTL_GRP === `${k.PCS_CD}_${E}` && k.DIV_SEQ === i.value)
          }
          v || (v = s.value.THO_XXXs.find(E => +E.CUT_WDT === l.value?.width && +E.CUT_HGH === l.value?.height)), v && h(v)
        }

        function p(v) {
          const {
            PCS_CD: E,
            VIEW_YN: k,
            ESN_YN: N
          } = v[0], D = Yr[r.pdtCode], O = D?.factor === "size" && i.value ? D.value[i.value] : "";
          d[E] = [{
            PCS_CD: E,
            VIEW_YN: k,
            ESN_YN: N,
            selectedOptions: v.map(({
              PCS_CD: A,
              PCS_DTL_CD: b,
              PCS_DTL_NM: C
            }) => ({
              PCS_CD: A,
              PCS_DTL_CD: b,
              PCS_DTL_NM: C,
              ATTB: O
            }))
          }]
        }

        function m() {
          for (const v of s.value.ETC) {
            const {
              PCS_CD: E
            } = v;
            if (!(E === "CUT_DFT" && n.relatedData.dosu === "SID_X")) {
              if (u.value[E] && u.value[E].length === 0) {
                d[E] && delete d[E];
                continue
              }
              d[E] || h(v)
            }
          }
        }
        return rs(() => {
          s.value.LAS_DFTs.length > 0 && f(), s.value.THO_XXXs.length > 0 && _(), s.value.ROU_DFTs.length > 0 && n.relatedData.dosu !== "SID_X" && p(s.value.ROU_DFTs), s.value.ETC.length > 0 && m()
        }), F(() => n.relatedData.dosu, v => {
          v === "SID_X" && (delete d.ROU_DFT, delete d.CUT_DFT)
        }), F(() => n.relatedData.thickness, v => {
          if (!v || !d.CVR_BOD) return;
          const E = d.CVR_BOD[0];
          E && (E.selectedOptions[0].ATTB = v)
        }), F(() => n.relatedData.orderQty, v => {
          if (v)
            for (const E of m1) d[E] && d[E].forEach(k => k.selectedOptions[0].ATTB = v)
        }, {
          immediate: !0
        }), F(() => n.relatedData.bindDirection?.selectedOptions[0], v => {
          if (!v) return;
          const k = Object.keys(d).find(N => Lb.has(N));
          k && (d[k][0].selectedOptions[0] = {
            ...d[k][0].selectedOptions[0],
            PCS_DTL_CD: v.PCS_DTL_CD,
            PCS_DTL_NM: v.PCS_DTL_NM,
            BACK_ROT_YN: v.BACK_ROT_YN
          })
        }), F(() => d, un(v => {
          o("update", v)
        }, 100), {
          immediate: !0,
          deep: !0
        }), (v, E) => null
      }
    });

  function Hl() {
    const e = le("callbacks", {}),
      t = H(!1);
    return {
      canResetWhite: t,
      resetEditByWhite: () => {
        e?.onReset && e.onReset("white"), t.value = !1
      }
    }
  }
  const Gl = {
      SUB_MTR: ["SUB_MTR_BC"],
      DIR_MTR: ["DIR_MTR_JT"],
      WRK_MTR: ["WRK_MTR_BP", "WRK_MTR_PB"],
      LIN_DFT: [],
      POL_BAG: [],
      TON_WOD: []
    },
    jl = {
      LIN_DFT_LN: "icon",
      SUB_MTR_CB: "icon",
      POL_BAG_PO: "icon",
      POL_BAG_HL: "icon",
      TON_WOD_WD: "icon",
      SUB_MTR_EN: "icon"
    },
    zl = {
      SUB_MTR_CB: "CB001"
    },
    Z_ = new Set(["GSNTMIS"]),
    $b = {
      class: "flex-row -flow"
    },
    Yl = Be(re({
      __name: "VisiblePostPcs",
      props: {
        options: {},
        disabledOpts: {},
        attbOpts: {},
        relatedData: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = le("productCode", {
            pdtCode: ""
          }),
          r = le("callbacks", {}),
          a = Ve(),
          i = xe({}),
          l = {
            PHPTPRM: "WRK_MTR",
            STDRCAD: "PDT_WRK"
          };

        function c(b) {
          if (!a.isAfterEdit()) return;
          const C = l[s.pdtCode];
          C && C === b && r.onReset && r.onReset("postPcs")
        }
        F(() => i, () => {
          o("update", i)
        }, {
          deep: !0
        });
        const u = xe({}),
          d = R(() => n.relatedData.mtrlCd || "");
        F(() => d.value, b => {
          b && (O(b), A())
        });
        const h = R(() => n.disabledOpts ? n.disabledOpts[d.value] || {} : {}),
          f = R(() => cn(n.attbOpts) ? null : n.attbOpts?.reduce((b, C) => {
            const y = {
              name: C.ATTB_NM,
              value: C.ATTB_CD,
              key: C.ATTB_CD
            };
            return b[C.PCS_CD] ? b[C.PCS_CD].push(y) : b = {
              [C.PCS_CD]: [y]
            }, b
          }, {})),
          _ = new Set(["PDT_WRK_PP", "SUB_MTR_BC"]),
          p = R(() => {
            const b = new Map;
            for (const C of n.options) {
              const {
                PCS_CD: y,
                PCS_DTL_CD: I,
                PCS_DTL_NM: w,
                PCS_GRP_NM: U,
                ESN_YN: Z,
                WEB_PCS_DTL_GRP: me,
                WEB_PCS_DTL_GRP_NM: _e
              } = C, B = b.get(y), W = {
                name: w,
                value: I,
                key: I,
                extra: C
              };
              B ? B.options.push(W) : b.set(y, {
                name: Gl[y] ? _e : U || w,
                imgPath: _.has(me) ? me : `${y}_${s.pdtCode}`,
                subImgPath: y,
                value: y,
                group: me,
                options: [W],
                disabled: Z === "Y",
                component: _n(kn(() => Ul(Object.assign({
                  "../postPcs/ADC_PVC.vue": () => Promise.resolve().then(() => pE),
                  "../postPcs/BID_SIL.vue": () => Promise.resolve().then(() => hE),
                  "../postPcs/BIND_DIRECTION.vue": () => Promise.resolve().then(() => vE),
                  "../postPcs/BON_PAP.vue": () => Promise.resolve().then(() => TE),
                  "../postPcs/BON_SHT.vue": () => Promise.resolve().then(() => SE),
                  "../postPcs/CLD_STD.vue": () => Promise.resolve().then(() => PE),
                  "../postPcs/COT_DFT.vue": () => Promise.resolve().then(() => IE),
                  "../postPcs/COT_SEG.vue": () => Promise.resolve().then(() => wE),
                  "../postPcs/CVR_INN.vue": () => Promise.resolve().then(() => NE),
                  "../postPcs/CVR_SWN.vue": () => Promise.resolve().then(() => kE),
                  "../postPcs/DIR_MTR.vue": () => Promise.resolve().then(() => LE),
                  "../postPcs/END_PAP.vue": () => Promise.resolve().then(() => FE),
                  "../postPcs/INN_DFT.vue": () => Promise.resolve().then(() => GE),
                  "../postPcs/INS_COT.vue": () => Promise.resolve().then(() => zE),
                  "../postPcs/LAB_FBR.vue": () => Promise.resolve().then(() => KE),
                  "../postPcs/PAK_ETC.vue": () => Promise.resolve().then(() => qE),
                  "../postPcs/PAK_POL.vue": () => Promise.resolve().then(() => XE),
                  "../postPcs/PAK_POL_Simple.vue": () => Promise.resolve().then(() => _P),
                  "../postPcs/PDT_WRK.vue": () => Promise.resolve().then(() => ZE),
                  "../postPcs/PRT_IPK.vue": () => Promise.resolve().then(() => oO),
                  "../postPcs/PRT_WHT.vue": () => Promise.resolve().then(() => pO),
                  "../postPcs/PRT_WHT_FACE.vue": () => Promise.resolve().then(() => rO),
                  "../postPcs/RIN_DFT.vue": () => Promise.resolve().then(() => hO),
                  "../postPcs/ROU_DFT.vue": () => Promise.resolve().then(() => DO),
                  "../postPcs/SCO_DFT.vue": () => Promise.resolve().then(() => IO),
                  "../postPcs/SUB_MTR.vue": () => Promise.resolve().then(() => Hb),
                  "../postPcs/SUB_MTR_BC.vue": () => Promise.resolve().then(() => wO),
                  "../postPcs/SUB_MTR_Multi.vue": () => Promise.resolve().then(() => Wb),
                  "../postPcs/WRK_MTR.vue": () => Promise.resolve().then(() => NO)
                }), `../postPcs/${y==="SUB_MTR"?me:y}.vue`, 3))),
                ...f.value && f.value[y] ? {
                  attbOptions: f.value[y]
                } : {}
              })
            }
            return b
          }),
          m = R(() => p.value.size === 0 ? !1 : !cn(i));

        function v(b, C, y) {
          const I = p.value.get(b);
          if (!I) return;
          const w = i[b];
          (C ? C === "Y" : !w) ? i[I.value] = y ?? [{
            PCS_CD: I.value,
            PCS_GRP_NM: I.name,
            VIEW_YN: "Y",
            ESN_YN: I.options[0]?.extra.ESN_YN || "N",
            selectedOptions: w ? w[0].selectedOptions : []
          }]: delete i[I.value], c(b)
        }
        const E = b => C => {
            i[b][0].selectedOptions[0]?.PCS_DTL_CD !== C[0]?.PCS_DTL_CD && c(b), i[b][0].selectedOptions = C
          },
          k = b => C => {
            i[b] = C, C.length === 0 && v(b, "N")
          };
        rs(() => {
          for (const b of n.options) {
            const {
              PCS_CD: C,
              PCS_GRP_NM: y,
              VIEW_YN: I,
              PCS_DTL_CD: w,
              PCS_DTL_NM: U,
              ESN_YN: Z
            } = b;
            if (Z === "N" || u[C] && h.value[C]?.length === 0 || i[C]) continue;
            const _e = {
              PCS_CD: C,
              PCS_GRP_NM: y,
              VIEW_YN: I,
              ESN_YN: Z,
              selectedOptions: [{
                PCS_CD: C,
                PCS_DTL_CD: w,
                PCS_DTL_NM: U,
                ATTB: ""
              }]
            };
            i[C] = [_e]
          }
        }), F(() => a.uploadType.default, b => {
          s.pdtCode.startsWith("AC") && (b === "editor" && s.pdtCode !== "ACTHFCO" ? (v("PRT_WHT", "Y"), u.PRT_WHT = !0) : u.PRT_WHT = !1)
        }, {
          immediate: !0
        });
        const {
          canResetWhite: N,
          resetEditByWhite: D
        } = Hl();
        F(() => a.editorData?.default?.PRT_WHT, b => {
          if (b?.front || b?.back) {
            if (s.pdtCode !== "ACTHFCO") return v("PRT_WHT", "Y");
            a.isAfterEdit() && N.value && D();
            const C = Object.entries(b).reduce((y, I) => {
              const [w, U] = I;
              return U && y.push({
                PCS_CD: "PRT_WHT",
                PCS_GRP_NM: "화이트인쇄",
                VIEW_YN: "Y",
                ESN_YN: "N",
                selectedOptions: [{
                  PCS_CD: "PRT_WHT",
                  PCS_DTL_CD: w === "front" ? "DFXXF" : "DFXXB",
                  PCS_DTL_NM: w === "front" ? "앞면 화이트" : "뒷면 화이트",
                  ATTB: "Y",
                  ATTB_2: "Y"
                }]
              }), y
            }, []);
            v("PRT_WHT", "Y", C), a.isAfterEdit() && !N.value && (N.value = !0)
          }
        });

        function O(b) {
          const C = Fl[s.pdtCode];
          if (!C) return;
          const y = C[b],
            I = {
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
          y === "Y" ? (v("PRT_WHT", "Y", [I]), u.PRT_WHT = !0) : h.value.PRT_WHT ? v("PRT_WHT", "N") : (v("PRT_WHT", "Y", [I]), u.PRT_WHT = !1)
        }

        function A() {
          const b = h.value.COT_DFT;
          if (!b) return u.COT_DFT = !1;
          b.length === 0 && (v("COT_DFT", "N"), u.COT_DFT = !0)
        }
        return (b, C) => (g(), M(J, null, [b.options.length > 0 ? (g(), V(fe, {
          key: 0,
          title: "후가공"
        }, {
          default: ce(() => [S("div", $b, [(g(!0), M(J, null, he(p.value.values(), y => (g(), V(je, {
            key: y.value,
            data: y,
            active: !!i[y.value],
            onSelect: C[0] || (C[0] = I => v(I.value)),
            disabled: u[y.value] || y.disabled || !!h.value[y.value],
            "disabled-styling": (u[y.value] || y.disabled || !!h.value[y.value]) && !i[y.value]
          }, null, 8, ["data", "active", "disabled", "disabled-styling"]))), 128))])]),
          _: 1
        })) : oe("", !0), m.value ? (g(), V(fe, {
          key: 1,
          "row-class": "postpcs-row"
        }, {
          default: ce(() => [(g(!0), M(J, null, he(p.value.values(), y => (g(), M(J, {
            key: y.value
          }, [i[y.value] && y.component ? (g(), V(ns(y.component), {
            key: 0,
            data: y,
            "related-data": {
              postpcs: i,
              mtrlCd: d.value,
              orderQty: b.relatedData.orderQty,
              sizeInfo: b.relatedData.sizeInfo
            },
            "disabled-options": h.value[y.value],
            onUpdate: I => E(y.value)(I),
            "onUpdate:replace": I => k(y.value)(I)
          }, null, 40, ["data", "related-data", "disabled-options", "onUpdate", "onUpdate:replace"])) : oe("", !0)], 64))), 128))]),
          _: 1
        })) : oe("", !0)], 64))
      }
    }), [
      ["__scopeId", "data-v-be788596"]
    ]),
    xb = {
      class: "grid-group"
    },
    Fb = {
      class: "flex-row"
    },
    Ub = ["name"],
    Bb = ["value"],
    Vb = ["disabled"],
    Kl = re({
      __name: "SUB_MTR",
      props: {
        title: {},
        options: {},
        defaultData: {},
        qtyDisabled: {
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
          s = H(n.defaultData.PCS_DTL_CD || n.options[0].value),
          r = H(n.defaultData.qty || 1),
          a = R(() => ({
            PCS_DTL_CD: s.value,
            qty: r.value
          })),
          i = R(() => n.options.find(c => c.value === s.value)?.extra),
          l = H(n.defaultData.extra?.NOTICE || []);
        return F(() => r.value, un(c => {
          c < 1 && (r.value = 1)
        }, 300)), F(() => a.value, c => {
          l.value = i.value?.NOTICE || [], o("update", {
            ...c,
            extra: i.value
          })
        }), F(() => n.defaultData, c => {
          s.value = c.PCS_DTL_CD, r.value = c.qty
        }, {
          deep: !0
        }), F(() => n.options, c => {
          const u = c.find(d => i.value?.SET_GRP_COD === d.extra?.SET_GRP_COD && !d.forceHidden);
          u && (s.value = u.value)
        }), (c, u) => {
          const d = on("dompurify-html");
          return g(), V(fe, {
            title: c.title,
            underline: ""
          }, {
            default: ce(() => [S("div", xb, [Oi(c.$slots, "extra"), S("div", Fb, [de(S("select", {
              "onUpdate:modelValue": u[0] || (u[0] = h => s.value = h),
              name: `SUM_MTR/${c.title}`,
              class: "basic-select"
            }, [(g(!0), M(J, null, he(c.options, h => (g(), M(J, {
              key: h.key
            }, [h.forceHidden ? oe("", !0) : (g(), M("option", {
              key: 0,
              value: h.value
            }, j(T(x)(h.name)), 9, Bb))], 64))), 128))], 8, Ub), [
              [We, s.value]
            ]), de(S("input", {
              "onUpdate:modelValue": u[1] || (u[1] = h => r.value = h),
              type: "number",
              id: "qty",
              disabled: c.qtyDisabled,
              class: "basic-input"
            }, null, 8, Vb), [
              [yt, r.value]
            ])]), l.value && l.value.length > 0 ? (g(!0), M(J, {
              key: 0
            }, he(l.value, (h, f) => de((g(), M("p", {
              key: `notice-${f}`,
              class: "note"
            })), [
              [d, h]
            ])), 128)) : oe("", !0)])]),
            _: 3
          }, 8, ["title"])
        }
      }
    }),
    Hb = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Kl
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    Gb = {
      class: we(["flex-row", "-flow"])
    },
    jb = ["onUpdate:modelValue", "disabled", "placeholder"],
    zb = ["value"],
    Yb = {
      class: "notes"
    },
    Kb = {
      class: "note"
    },
    eh = Be(re({
      __name: "SUB_MTR_Multi",
      props: {
        title: {},
        options: {},
        qtyDisabled: {
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
          s = xe(n.options.reduce((a, i) => (a[i.value] = {
            active: !1,
            data: {
              PCS_DTL_CD: i.value,
              qty: 0,
              extra: i.extra
            }
          }, a), {}));

        function r(a) {
          const i = s[a];
          i.active = !i.active, i.active ? i.data.qty = 1 : i.data.qty = 0
        }
        return F(() => s, a => {
          const i = {};
          for (const l of Object.values(a)) {
            l.data.qty || (l.data.qty = 0, l.active = !1);
            const c = `${l.data.extra.WEB_PCS_DTL_GRP}_${l.data.PCS_DTL_CD}`;
            i[c] = l
          }
          o("update", i)
        }, {
          deep: !0
        }), Ju(() => {
          const a = n.options[0].extra?.WEB_PCS_DTL_GRP;
          a && zl[a] && r(zl[a])
        }), (a, i) => (g(), V(fe, {
          title: a.title,
          underline: ""
        }, {
          default: ce(() => [S("div", Gb, [(g(!0), M(J, null, he(a.options, l => (g(), V(je, {
            key: l.key,
            data: {
              name: l.name,
              value: l.value,
              imgPath: `${l.extra?.PCS_CD}_${l.value}`
            },
            disabled: l.extra?.HIDE_YN === "Y",
            "disabled-styling": l.extra?.HIDE_YN === "Y",
            active: s[l.value].active,
            onSelect: i[1] || (i[1] = c => r(c.value))
          }, {
            input: ce(() => [l.extra?.HIDE_YN !== "Y" ? de((g(), M("input", {
              key: 0,
              "onUpdate:modelValue": c => s[l.value].data.qty = c,
              type: "number",
              name: "submtrl-qty",
              "max-length": "3",
              class: we(["basic-input", "-qty"]),
              disabled: !s[l.value].active || a.qtyDisabled,
              placeholder: T(x)("summary.수량"),
              onClick: i[0] || (i[0] = br(() => {}, ["stop"]))
            }, null, 8, jb)), [
              [yt, s[l.value].data.qty]
            ]) : (g(), M("input", {
              key: 1,
              value: T(x)("주문불가"),
              name: "submtrl-qty",
              class: we(["basic-input", "-qty"]),
              disabled: ""
            }, null, 8, zb))]),
            _: 2
          }, 1032, ["data", "disabled", "disabled-styling", "active"]))), 128))]), S("div", Yb, [S("p", Kb, j(a.options[0]?.extra?.NOTICE[0]), 1)])]),
          _: 1
        }, 8, ["title"]))
      }
    }), [
      ["__scopeId", "data-v-09c3d2fa"]
    ]),
    Wb = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: eh
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    th = {
      SUB_MTR_KR: 1,
      SUB_MTR_CN: 2,
      SUB_MTR_CR: 3,
      SUB_MTR_BN: 4
    },
    qb = new Set(["SUB_MTR_KR", "SUB_MTR_CN", "SUB_MTR_CR", "SUB_MTR_BN"]),
    Qb = new Set(["ACTHPAM", "ACTHPAA", "ACTHCKY"]),
    Xb = {
      class: "flex-row"
    },
    Jb = re({
      __name: "Digital",
      props: {
        options: {},
        relatedData: {}
      },
      emits: ["update", "update:size"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = le("productCode", {
            pdtCode: ""
          }),
          r = R(() => n.relatedData.sizeInfo),
          a = R(() => n.relatedData.orderQty),
          i = R(() => n.relatedData.mtrlCd),
          l = R(() => n.relatedData.setData),
          c = xe(new Map),
          u = R(() => [...c.values()].sort((b, C) => b.order && C.order ? b.order - C.order : 0)),
          d = xe({});

        function h(b) {
          const C = c.get(b);
          if (C && !(C.active && p[b]))
            if (C.active = !C.active, C.active) {
              if (jl[b]) return;
              const y = C.options.find(w => !!w.extra?.SET_GRP_COD && !w.forceHidden),
                I = y || C.options[0];
              d[C.value] = {
                PCS_DTL_CD: I.value,
                qty: I.extra?.QTY_INPUT_YN === "Y" ? 1 : a.value || 1,
                extra: I.extra
              }
            } else if (jl[b])
            for (const y in d) y.startsWith(b) && delete d[y];
          else delete d[C.value]
        }
        const f = b => C => {
            d[b] = C
          },
          _ = b => {
            for (const C in b) b[C].active ? d[C] = b[C].data : delete d[C]
          },
          p = xe({});
        F(() => p, b => {
          Object.keys(b).forEach(C => h(C))
        }, {
          deep: !0
        });
        const m = b => !$l.has(s.pdtCode) && b.MTRL_CD === i.value,
          v = b => !xl[s.pdtCode] || xl[s.pdtCode] !== b.PCS_CD ? !1 : b.DIV_SEQ === r.value?.DIV_SEQ,
          E = b => !!l.value && b.SET_GRP_COD === l.value.GRP_COD && b.SET_COD === l.value.COD,
          k = {
            CT001: "SUB_MTR_CT001"
          };
        F(() => n.options.visible, b => {
          for (const C of b) {
            const y = C.SUB_MTR_GRP ? `SUB_MTR_${C.SUB_MTR_GRP}` : C.WEB_PCS_DTL_GRP,
              I = c.get(y),
              w = {
                name: C.PCS_DTL_NM,
                value: C.PCS_DTL_CD,
                key: C.PCS_DTL_CD,
                extra: C
              };
            I ? I.options.push(w) : (c.set(y, {
              name: C.WEB_PCS_DTL_GRP_NM || C.PCS_GRP_NM || C.PCS_DTL_NM,
              imgPath: k[C.PCS_DTL_CD] ? k[C.PCS_DTL_CD] : y,
              subImgPath: C.PCS_CD,
              value: y,
              active: !!zl[y],
              options: [w],
              order: th[y] || 0
            }), C.ESN_YN === "Y" && (p[y] = !0))
          }
        }, {
          immediate: !0
        });
        const N = R(() => n.options.essential.reduce((C, y) => (C[y.PCS_CD] = (C[y.PCS_CD] || 0) + 1, C), {})),
          D = R(() => {
            const b = [];
            for (const C of n.options.essential) {
              const {
                PCS_CD: y,
                VIEW_YN: I,
                PCS_DTL_CD: w,
                PCS_DTL_NM: U,
                MTRL_CD: Z,
                DIV_SEQ: me,
                ESN_YN: _e
              } = C, B = {
                PCS_CD: y,
                VIEW_YN: I,
                ESN_YN: _e,
                ...Z ? {
                  MTRL_CD: Z
                } : {},
                DIV_SEQ: me,
                active: !1,
                selectedOptions: [{
                  PCS_CD: y,
                  PCS_DTL_CD: w,
                  PCS_DTL_NM: U,
                  ATTB: a.value,
                  ATTB_2: "",
                  ATTB_3: ""
                }]
              };
              N.value[y] > 1 ? (m(C) || v(C) || E(C)) && b.push(B) : b.push(B)
            }
            return b
          }),
          O = R(() => {
            const b = [];
            for (const C of Object.values(d)) {
              const y = {
                PCS_CD: C.extra.PCS_CD,
                PCS_GRP_NM: C.extra.WEB_PCS_DTL_GRP_NM || C.extra.PCS_GRP_NM,
                VIEW_YN: C.extra.VIEW_YN,
                ESN_YN: C.extra.ESN_YN,
                MTRL_CD: C.extra.MTRL_CD,
                active: !0,
                selectedOptions: [{
                  PCS_CD: C.extra.PCS_CD,
                  PCS_DTL_CD: C.PCS_DTL_CD,
                  PCS_DTL_NM: C.extra.PCS_DTL_NM,
                  ATTB: C.qty,
                  ATTB_2: "",
                  ATTB_3: ""
                }]
              };
              b.push(y)
            }
            return b
          }),
          A = R(() => [...D.value, ...O.value]);
        return F(() => A.value, b => {
          o("update", b)
        }, {
          immediate: !0
        }), F(() => i.value, b => {
          if (!n.relatedData.pcsCodeForSize) return;
          const C = n.options.essential.find(_e => _e.MTRL_CD === b && _e.PCS_CD === n.relatedData.pcsCodeForSize);
          if (!C) return;
          const {
            PCS_DTL_CD: y,
            DIV_SEQ: I,
            CUT_WDT: w,
            CUT_HGH: U,
            WRK_WDT: Z,
            WRK_HGH: me
          } = C;
          o("update:size", {
            PCS_DTL_CD: y,
            DIV_SEQ: I,
            CUT_WDT: w,
            CUT_HGH: U,
            WRK_WDT: Z,
            WRK_HGH: me
          })
        }), F(() => a.value, b => {
          Object.values(d).forEach(C => {
            C.extra.QTY_INPUT_YN !== "Y" && (C.qty = b)
          })
        }), F(() => l.value?.COD, b => {
          if (b) {
            const C = c.get("SUB_MTR_PACKING");
            C && (C.options = C.options.map(y => (y.extra?.SET_GRP_COD && (y.forceHidden = b !== y.extra.SET_COD), y)))
          }
        }), F(() => r.value, b => {
          const C = c.get("SUB_MTR_PV");
          C && (b?.DIV_SEQ === 0 || b?.DIV_NM === "사이즈직접입력" ? (C.active = !1, C.disabled = !0, delete d.SUB_MTR_PV) : (C.disabled = !1, C.options = C.options.map(y => (y.forceHidden = !v(y.extra), y)).sort(y => y.forceHidden ? 0 : -1)))
        }), (b, C) => (g(), M(J, null, [c.size ? (g(), V(fe, {
          key: 0,
          title: "부자재선택"
        }, {
          default: ce(() => [S("div", Xb, [(g(!0), M(J, null, he(u.value, y => (g(), V(je, {
            key: y.value,
            active: y.active,
            disabled: y.disabled,
            "disabled-styling": !0,
            data: y,
            onSelect: C[0] || (C[0] = I => h(I.value))
          }, null, 8, ["active", "disabled", "data"]))), 128))])]),
          _: 1
        })) : oe("", !0), (g(!0), M(J, null, he(u.value, y => (g(), M(J, {
          key: y.value
        }, [y.active ? (g(), V(fe, {
          key: 0
        }, {
          default: ce(() => [T(jl)[y.value] === "icon" ? (g(), V(eh, {
            key: 0,
            title: y.name,
            options: y.options,
            "qty-disabled": y.options[0].extra.QTY_INPUT_YN !== "Y",
            onUpdate: _
          }, null, 8, ["title", "options", "qty-disabled"])) : (g(), V(Kl, {
            key: 1,
            title: y.name,
            options: y.options,
            "default-data": d[y.value],
            "qty-disabled": y.options[0].extra.QTY_INPUT_YN !== "Y",
            onUpdate: I => f(y.value)(I)
          }, null, 8, ["title", "options", "default-data", "qty-disabled", "onUpdate"]))]),
          _: 2
        }, 1024)) : oe("", !0)], 64))), 128))], 64))
      }
    }),
    Zb = {
      key: 0,
      class: "loading-spinner"
    },
    eS = ["for"],
    tS = {
      class: "guide"
    },
    nS = {
      class: "desc"
    },
    oS = {
      class: "desc detail"
    },
    sS = ["id", "accept"],
    rS = {
      key: 1,
      class: "uploaded"
    },
    iS = {
      class: "file-name",
      id: "upload_cust_file_nm"
    },
    aS = ["src"],
    lS = 1024 * 1024 * 1024,
    uS = Be(re({
      __name: "S3Uploader",
      props: {
        _key: {
          default: "default"
        },
        allowedExt: {
          default () {
            return ["application/pdf"]
          }
        }
      },
      emits: ["upload"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Dt(),
          r = R(() => n.allowedExt.join(", ")),
          a = H("");
        async function i(p) {
          return !p || !n.allowedExt.includes(p.type) ? (alert(x("파일형식에러메시지", {
            ext: r.value
          })), !1) : p.size >= lS ? (alert(x("파일형식에러메시지")), !1) : !0
        }
        async function l(p) {
          if (!p) return 0;
          const m = {
              file_name: p,
              lang: s.locale
            },
            v = await FT(m);
          return v ? v.ContentLength : 0
        }
        async function c(p, m) {
          const v = p === "I" && !!m,
            E = v ? await l(m.name.new) : null,
            k = v ? {
              gbn: "I",
              new_file_nm: m.name.new,
              new_file_size: m.size,
              org_file_nm: m.name.original,
              s3_file_size: E
            } : null;
          a.value = v ? m.name.original : "", o("upload", [k])
        }
        const u = H(!1);
        async function d(p) {
          try {
            const m = p.name;
            u.value = !0;
            const E = await (await fetch(`${H_}/api/aws/presigned-url`, {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                body: JSON.stringify({
                  filename: m
                })
              })).json(),
              {
                filename: k,
                presignedURL: N
              } = E;
            if (!N || !k) throw new Error("파일 업로드 중 문제가 발생했습니다.");
            const D = await fetch(N, {
              method: "PUT",
              headers: {
                "Content-Type": p.type
              },
              body: p
            });
            if (D instanceof Response && D.status !== 200) throw new Error("파일 업로드 실패");
            const O = {
              name: {
                new: k,
                original: m
              },
              size: p.size
            };
            await c("I", O)
          } catch (m) {
            m instanceof Error && (console.error("[RedWidgetSDK/ERROR] 파일 업로드 시 에러 발생 > ", m.message), alert(m.message))
          } finally {
            u.value = !1
          }
        }
        async function h(p) {
          const m = p.target;
          if (!m.files) return;
          const v = m.files[0];
          await i(v) && await d(v)
        }
        async function f(p) {
          const m = p.dataTransfer?.files;
          if (!m) return;
          const v = [...m],
            E = v.length === 1 ? v[0] : v.find(N => n.allowedExt.includes(N.type));
          !E || !await i(E) || await d(E)
        }
        async function _() {
          const p = x("업로드파일삭제메시지");
          confirm(p) && await c("D")
        }
        return (p, m) => (g(), M("div", {
          class: "s3-uploader",
          onDragover: m[0] || (m[0] = br(() => {}, ["prevent"])),
          onDrop: br(f, ["prevent"])
        }, [a.value ? (g(), M("div", rS, [S("span", iS, j(a.value), 1), S("button", {
          type: "button",
          class: "delete-btn",
          onClick: _
        }, [S("img", {
          src: `${T(qe)}/ko/order_addfile_remove_icon.svg`,
          alt: "delete-icon"
        }, null, 8, aS)])])) : (g(), M(J, {
          key: 0
        }, [u.value ? (g(), M("div", Zb)) : (g(), M("label", {
          key: 1,
          for: `file-${p._key}`,
          class: "file-uploader"
        }, [m[1] || (m[1] = S("div", {
          class: "upload-btn"
        }, "+", -1)), S("div", tS, [S("p", nS, j(T(x)("pdf-only")), 1), S("p", oS, j(T(x)("파일업로드레이어안내")), 1)])], 8, eS)), S("input", {
          type: "file",
          id: `file-${p._key}`,
          accept: r.value,
          class: "hidden",
          onChange: h
        }, null, 40, sS)], 64))], 32))
      }
    }), [
      ["__scopeId", "data-v-a8184191"]
    ]),
    Wl = {
      type1: new Set(["CLSTSHS", "CLSTLOS", "CLSTSWT"]),
      type2: new Set(["CLTMMTS", "CLTMHDS", "CLTMSHS"]),
      type3: new Set(["CLDFSHS", "CLDFLOS", "CLDFDRR", "CLDFDRP", "CLDFDRK", "CLDFNCP", "CLSTBSA", "CLSTBST", "CLSTSHD", "CLSTSPK", "CLSTDLD", "CLSTDLB", "CLSTLSD", "CLSTBLS", "CLDFALP"])
    };

  function cS(e, t) {
    const n = e.PDT_CD,
      o = e.PDT_NM,
      s = t.meterialInfo,
      r = t.meterialInfo.MTRL_CD[5],
      a = t.clothesSelectData.sizeInfo[0];
    if (Wl.type1.has(n))
      if (s.PTT_CD === "SRT") {
        const l = {
          X: 1,
          1: 2,
          2: 2,
          3: 3,
          4: 3,
          5: 3,
          6: 3
        } [r];
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${l}`,
          file_nm: s.PTT_NM || ""
        }
      } else {
        const i = ["X", "1", "2"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${i}`,
          file_nm: s.PTT_NM || ""
        }
      } if (n === "CLSTTOB") return {
      pdt_cod: n,
      detail_cod: `${n}_${a.size.COD_NME[0]}`,
      file_nm: `${s.PTT_NM}_${a.size.COD_NME}`
    };
    if (Wl.type2.has(n)) {
      const i = t.pcsInfo.find(l => l.PCS_CD === "DIR_MTR");
      return {
        pdt_cod: n,
        detail_cod: `${n}_${i?.DIV_SEQ}`,
        file_nm: o
      }
    }
    if (Wl.type3.has(n)) {
      if (n === "CLDFNCP") return {
        pdt_cod: n,
        detail_cod: `${n}_${r}`,
        file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${r}`
      };
      if (n === "CLSTSPK") {
        const c = {
          1: 1,
          2: 1,
          3: 2,
          4: 3,
          5: 3,
          6: 3
        } [r];
        return {
          pdt_cod: n,
          detail_cod: `${n}_${c}`,
          file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${c}`
        }
      }
      if (n === "CLSTDLB") {
        const l = ["2", "3"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${l}`,
          file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${l}`
        }
      }
      if (s.PTT_CD === "QSC") {
        const l = ["A", "B", "C"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${l}`,
          file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${l}`
        }
      }
      if (n === "CLDFDRR" && ["A", "B", "C", "D", "E"].includes(r)) {
        const l = ["A", "B", "C"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_kids_${l}`,
          file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${l}`
        }
      }
      const i = ["1", "2"].includes(r) ? 1 : 2;
      return {
        pdt_cod: n,
        detail_cod: `${n}_${i}`,
        file_nm: `${s.PTT_NM}_${a.size.COD_NME}-${i}`
      }
    }
    if (n === "CLDFMHS")
      if (["QTB", "ZTB"].includes(s.PTT_CD || "")) {
        const i = ["1", "2", "3"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${i}`,
          file_nm: o
        }
      } else {
        const i = ["1", "2"].includes(r) ? 1 : 2;
        return {
          pdt_cod: n,
          detail_cod: `${n}_${s.PTT_CD}_${i}`,
          file_nm: o
        }
      } return {
      pdt_cod: n,
      file_nm: o
    }
  }

  function dS(e) {
    const t = e.pcsInfo.filter(c => c.PCS_CD.startsWith("CVR_")),
      n = t.length > 1 ? t.find(c => c.PCS_CD !== "CVR_SFT")?.PCS_CD : t[0].PCS_CD,
      o = e.pcsInfo.find(c => kb.has(c.PCS_CD)),
      s = o?.PCS_CD,
      r = e.priceCalc.result.seneca_info?.seneca;
    if (s === "PER_DFT" && !r) return "세네카오류";
    const a = o?.selectedOptions[0].PCS_DTL_CD,
      i = a === "BPTOP" ? `${a}${o?.selectedOptions[0].BACK_ROT_YN==="N"?"B":"A"}` : a,
      l = e.sizeInfo.cutSize;
    return {
      cover_type: n,
      COVER_DFT: n,
      bindType: s,
      pressDirection: i,
      seneca: r,
      printSide: e.dosuInfo.COD,
      number3: `${e.quantityInfo.prnCnt}`,
      cut_wdt: `${l.width}`,
      cut_hgh: `${l.height}`,
      is_layflat: ""
    }
  }
  const ql = {
    DIV_SEQ: {
      GSTTDTM: !0,
      GSBKBCH: !0,
      GSBKLAP: !0
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
      GSTGMIC: "THO_CUT"
    },
    PDT_CD$PCS_CD: {
      GSACPAN: "THO_CUT"
    }
  };

  function fS(e, t, n = "ko") {
    if (t.clothesSelectData) return cS(e, t);
    const o = e.PDT_CD,
      s = e.PDT_NM;
    if (ql.DIV_SEQ[o]) return {
      pdt_cod: o,
      detail_cod: `${o}_${t.sizeInfo.DIV_SEQ}`,
      file_nm: `${s} ${t.sizeInfo.DIV_NM}`
    };
    const r = ql.PCS_CD[o];
    if (r) {
      const i = t.pcsInfo.find(l => l.PCS_CD === r)?.selectedOptions[0];
      return {
        pdt_cod: o,
        detail_cod: `${r}_${i?.PCS_DTL_CD}`,
        file_nm: `${s} ${i?.PCS_DTL_NM}`
      }
    }
    const a = ql.PDT_CD$PCS_CD[o];
    if (a) {
      const i = t.pcsInfo.find(l => l.PCS_CD === a)?.selectedOptions[0];
      return {
        pdt_cod: o,
        detail_cod: `${o}_${a}_${i?.PCS_DTL_CD}`,
        file_nm: `${s} ${i?.PCS_DTL_NM}`
      }
    }
    if (o === "TPCLECO") {
      const i = t.dosuInfo,
        l = t.sizeInfo,
        c = i.COD.slice(-1);
      return {
        pdt_cod: o,
        detail_cod: `${o}_${l.DIV_NM}_${c}`,
        file_nm: `${s} ${l.DIV_NM} ${i.COD_NME}`
      }
    }
    if (["ACTHDKY", "ACTHDCO"].includes(o)) {
      const i = t.acrylicSelectData.printData;
      return {
        pdt_cod: o,
        detail_cod: `${o}_${i.COD}`,
        file_nm: `${s} ${i.COD_NME}`
      }
    }
    if (o === "GSCACAP") {
      const l = t.meterialInfo.WGT_CD.startsWith("4") ? 2 : 1,
        c = `${l===1?3:4}${n==="ko"?"구":"Button"}`;
      return {
        pdt_cod: o,
        detail_cod: `${o}_${l}`,
        file_nm: `${s}-${c}`
      }
    }
    return {
      pdt_cod: o,
      file_nm: s,
      detail_cod: ""
    }
  }
  const pS = {
      class: "upload-group"
    },
    _S = {
      class: "upload-type"
    },
    hS = {
      class: "selected-uploader"
    },
    mS = {
      key: 0,
      class: "edit-btn-wrapper"
    },
    vS = ["src"],
    gS = {
      key: 0
    },
    yS = {
      class: "note"
    },
    ks = Be(re({
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
        notes: {}
      },
      emits: ["upload"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = Ve(),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = le("callbacks", {}),
          i = le("member"),
          l = H(!1),
          c = R(() => r.pdtCode.startsWith("PRBK")),
          u = R(() => n.relatedData?.size?.DIV_SEQ === 0);

        function d(D) {
          if (D === "editor") {
            if (Z_.has(r.pdtCode) && u.value || n.relatedData?.hasScodix) return !0;
            const O = ["ACTHFCO", "ACTHBCO", "ACTHDKY"];
            if (n.relatedData?.print?.COD === "X" && !O.includes(r.pdtCode)) return !0
          }
          return !1
        }
        const h = Ms(),
          f = zr(),
          _ = Dt();
        async function p() {
          const D = h.getProductBaseInfo(),
            O = f.getOrderData();
          if (!D || !O) return;
          const A = fS(D.product_data.pdt_base_info[0], O, _.locale);
          if (!A) return alert(x("템플릿다운로드실패"));
          await UT({
            lang: _.locale,
            ...A
          }) || alert(x("템플릿다운로드실패"))
        }
        const m = R(() => n.uploadConfig.editor);
        async function v() {
          if (s.isAfterEdit(n._key)) return {
            mode: "EDIT",
            type: m.value,
            config: m.value === "KOI" ? {
              projectId: s.editorData[n._key]?.projectID
            } : {
              initType: "open",
              project_id: s.editorData[n._key]?.projectID
            },
            option: null,
            error: null
          };
          {
            const D = {
                token: n.uploadConfig.token,
                payload: s.payloadForEditorConfig[n._key]
              },
              A = await (await fetch(`${H_}/api/editor/config/${m.value}`, {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                body: JSON.stringify(D)
              })).json();
            if (A.error) console.error("[RedWidgetSDK/ERROR] 에디터 초기 설정 시 문제가 발생했습니다.");
            else return {
              mode: "NEW",
              type: m.value,
              ...A
            }
          }
        }
        async function E() {
          if (n.relatedData?.apparel && n.relatedData.apparel.printType === "PTP_SLK" && !n.relatedData.apparel.pantone) {
            const D = "팬톤 컬러를 선택해주세요";
            return a?.onCallMsg ? a.onCallMsg("warn", D) : alert(D)
          }
          if (a?.onOpenEditor && m.value) {
            const D = await v();
            D && a.onOpenEditor(D)
          }
        }
        async function k() {
          const D = await v(),
            O = f.getOrderData();
          if (!O) return;
          const A = {
            pdt_cod: r.pdtCode,
            customerOrderData: O,
            memberInfo: {
              mb_id: i?.mb_id || "redprinting",
              mb_cust_cod: i?.mb_cust_cod || "10000000"
            },
            editorData: {
              editorConfig: D?.config,
              editorOption: D?.option
            }
          };
          if (a?.onCreatePot) return a.onCreatePot(A);
          console.log(A)
        }

        function N(D) {
          o("upload", D), l.value = !0
        }
        return F(() => n.relatedData?.print, D => {
          const O = r.pdtCode;
          ["ACTHFCO", "ACTHDKY"].includes(O) || D?.COD === "X" && n.uploadConfig.pdf && s.setUploadType("pdf", n._key)
        }), F(() => s.uploadType[n._key], D => {
          if (l.value && D === "editor") {
            o("upload", [null]);
            return
          }
          if (s.editorData[n._key] && D === "pdf") {
            a?.onReset && a.onReset("fileUpload");
            return
          }
        }), F(() => n.uploadConfig, D => {
          !D.editor && D.pdf && s.setUploadType("pdf", n._key)
        }, {
          immediate: !0
        }), F(() => n.relatedData?.hasScodix, D => {
          D && (s.setUploadType("pdf"), s.editorData.default && a?.onReset && a.onReset("fileUpload"))
        }), F(() => u.value, D => {
          D && Z_.has(r.pdtCode) && (s.setUploadType("pdf"), s.editorData.default && a?.onReset && a.onReset("fileUpload"))
        }), (D, O) => {
          const A = on("dompurify-html");
          return g(), V(fe, {
            title: D.subject || "파일업로드",
            extra: D.showExtra ? {
              name: "템플릿다운로드",
              callback: p
            } : null,
            option: "Uploader"
          }, {
            default: ce(() => [S("div", pS, [S("div", _S, [D.uploadConfig.pdf && !d("pdf") ? (g(), M("button", {
              key: 0,
              type: "button",
              class: we(["upload-btn", {
                active: T(s).uploadType[D._key] === "pdf"
              }]),
              onClick: O[0] || (O[0] = () => T(s).setUploadType("pdf"))
            }, " PDF ", 2)) : oe("", !0), D.uploadConfig.editor && !d("editor") ? (g(), M("button", {
              key: 1,
              type: "button",
              class: we(["upload-btn", {
                active: T(s).uploadType[D._key] === "editor"
              }]),
              onClick: O[1] || (O[1] = () => T(s).setUploadType("editor"))
            }, j(T(x)("에디터")), 3)) : oe("", !0)]), S("div", hS, [T(s).uploadType[D._key] === "pdf" ? (g(), V(uS, {
              key: 0,
              _key: D._key,
              "allowed-ext": D.allowedExt,
              onUpload: N
            }, null, 8, ["_key", "allowed-ext"])) : oe("", !0), T(s).uploadType[D._key] === "editor" ? (g(), M(J, {
              key: 1
            }, [c.value ? (g(), M("div", mS, [S("img", {
              src: `${T(qe)}/ko/cover_templatge_list.png`,
              alt: "free template images"
            }, null, 8, vS), de(S("button", {
              class: "upload-btn edit",
              onClick: E
            }, null, 512), [
              [A, T(x)("무료디자인편집")]
            ])])) : (g(), M("button", {
              key: 1,
              type: "button",
              class: "upload-btn edit",
              onClick: E
            }, j(T(s).isAfterEdit(D._key) ? T(x)("재편집하기") : T(x)("편집하기")), 1))], 64)) : oe("", !0)]), T(s).uploadType[D._key] === "pdf" ? (g(), M("div", gS, [(g(!0), M(J, null, he(D.notes, (b, C) => de((g(), M("p", {
              key: `note-${C}`,
              class: "note"
            })), [
              [A, b]
            ])), 128)), S("p", yS, "* " + j(T(x)("파일업로드-MS")), 1)])) : oe("", !0), T(i)?.pot_yn === "Y" ? (g(), M("button", {
              key: 1,
              type: "button",
              class: "upload-btn pot",
              onClick: k
            }, " 주문 관리 코드 생성 ")) : oe("", !0)])]),
            _: 1
          }, 8, ["title", "extra"])
        }
      }
    }), [
      ["__scopeId", "data-v-3f23fa4e"]
    ]),
    Ql = (e, t) => {
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
            MTRL_CD: c,
            PCS_CD: u,
            PCS_DTL_CD: d
          } = l;
          if (!i[c]) i[c] = {
            [u]: d ? [d] : []
          };
          else {
            let h = i[c][u];
            h ? d && h.push(d) : h = d ? [d] : []
          }
          return i
        }, {}),
        r = {
          essential: [],
          optional: []
        };
      for (const i of e) {
        const {
          PCS_CD: l,
          ESN_YN: c,
          VIEW_YN: u,
          WEB_PCS_DTL_GRP: d
        } = i;
        Gl[l] && !Gl[l].includes(d) ? c === "Y" && u === "N" ? o.essential.push(i) : o.visible.push(i) : c === "Y" && u === "N" ? n.hidden.push(i) : c === "Y" ? r.essential.push(i) : r.optional.push(i)
      }
      const a = [...r.essential, ...r.optional];
      return n.visible = a, {
        postPcs: n,
        sub: o,
        disabled: s
      }
    };

  function Wr(e) {
    const t = R(() => {
        const {
          usePDF: o,
          useKoiEditor: s,
          useRPEditor: r,
          koiAccessToken: a,
          rpAccessToken: i
        } = e, l = s === "N" && r === "N" ? null : s === "Y" ? "KOI" : "RP";
        return {
          editor: l,
          pdf: o === "Y",
          ...l ? {
            token: l === "KOI" ? a : i.token
          } : {}
        }
      }),
      n = R(() => {
        const {
          usePDF: o,
          usePDFordCnt: s,
          useEditorOrdCnt: r
        } = e;
        return {
          pdf: o === "Y" && s === "Y",
          editor: r === "Y"
        }
      });
    return {
      uploadConfig: t,
      canEditOrdCnt: n
    }
  }

  function qr(e, {
    group: t,
    emits: n
  }) {
    const o = R(() => e === "new" ? null : {}),
      s = H(e === "new" ? {} : o.value),
      r = (u, d) => h => {
        if (t === "acrylic2025_item") {
          s.value = {
            ...s.value,
            ...d ? {} : {
              [u]: h
            },
            acrylicSelectData: {
              ...s.value.acrylicSelectData,
              ...d ? {
                [u]: h
              } : {}
            }
          };
          return
        }
        if (t === "clothes2025_item") {
          s.value = {
            ...s.value,
            ...d ? {} : {
              [u]: h
            },
            clothesSelectData: {
              ...s.value.clothesSelectData,
              ...d ? {
                [u]: h
              } : {},
              ...u === "quantityInfo" ? {
                quantity: h.prnCnt
              } : {}
            }
          };
          return
        }
        s.value = {
          ...s.value,
          [u]: h
        }
      };
    F(() => s.value, un(u => {
      n.updateOrder(u)
    }, 150), {
      deep: !0
    });
    const a = H(e === "new" ? {} : {}),
      i = u => d => {
        a.value = {
          ...a.value,
          [u]: d
        }
      };
    F(() => a.value, u => {
      s.value.pcsInfo = Object.values(u).flatMap(d => d)
    });
    const l = xe({
        hidden: {},
        visible: {}
      }),
      c = u => d => {
        l[u] = d
      };
    return F(() => l, u => {
      const d = Object.values(u.hidden).flatMap(f => f),
        h = Object.values(u.visible).flatMap(f => f);
      i("POST_PCS")([...d, ...h])
    }, {
      deep: !0
    }), {
      defaultOrderData: o,
      orderInfo: s,
      pcsInfo: a,
      updateOption: r,
      updatePcsOption: i,
      updatePostPcs: c
    }
  }
  const CS = {
      class: "widget-error"
    },
    TS = {
      key: 0,
      class: "reason"
    },
    bS = Be(re({
      __name: "Error",
      props: {
        message: {}
      },
      setup(e) {
        return (t, n) => (g(), M("div", CS, [n[0] || (n[0] = S("p", null, "주문 위젯을 생성할 수 없습니다 😱", -1)), t.message ? (g(), M("p", TS, j(t.message), 1)) : oe("", !0)]))
      }
    }), [
      ["__scopeId", "data-v-33e3660e"]
    ]),
    SS = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = R(() => n.data.pdt_base_info[0].PDT_CD),
            r = R(() => n.widgetAttr.skinInfo),
            a = le("member"),
            i = R(() => {
              if (!n.data.option_info) return !1;
              const {
                shape_info: B
              } = n.data.option_info;
              return !cn(B) && !!B[0].COD
            }),
            l = R(() => a?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(B => B.BSN_YN !== "Y")),
            c = kn(() => Ul(Object.assign({
              "../options/material/Acrylic.vue": () => Promise.resolve().then(() => OS),
              "../options/material/Basic.vue": () => Promise.resolve().then(() => kO),
              "../options/material/Paper.vue": () => Promise.resolve().then(() => MP)
            }), `../options/material/${l.value[0].MTRL_TYPE==="R"?"Paper":"Basic"}.vue`, 4)),
            u = R(() => {
              const B = [...n.data.pdt_size_info];
              return !i.value || !A.value.shapeInfo || B.length === 1 ? B : B.filter(W => W.STICKER_TYPE === A.value.shapeInfo.COD)
            }),
            d = H(null),
            h = B => {
              d.value = B
            },
            f = R(() => v1.has(s.value)),
            _ = xe({}),
            p = B => W => {
              _[B] = W
            },
            m = R(() => Ql(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            {
              uploadConfig: v,
              canEditOrdCnt: E
            } = Wr(n.widgetAttr),
            k = Ve(),
            N = R(() => {
              let B = a?.bsn_yn === "Y" && k.uploadType.default === "pdf" ? "DesignQty" : kl[s.value] || "DesignQty";
              return f.value && (B = "CalendarQty"), kn(() => Ul(Object.assign({
                "../options/qty/BookQty.vue": () => Promise.resolve().then(() => EP),
                "../options/qty/CalendarQty.vue": () => Promise.resolve().then(() => jO),
                "../options/qty/DesignQty.vue": () => Promise.resolve().then(() => GS),
                "../options/qty/SetQty.vue": () => Promise.resolve().then(() => rI),
                "../options/qty/SimpleQty.vue": () => Promise.resolve().then(() => _I),
                "../options/qty/TotalQty.vue": () => Promise.resolve().then(() => bI)
              }), `../options/qty/${B}.vue`, 4))
            }),
            D = R(() => {
              const B = n.data.pdt_base_info[0];
              if (B.DAY_PRDC_PDT_YN !== "N") return {
                type: B.DAY_PRDC_PDT_YN,
                maxQty: B.DAY_ABLE_PRN_CNT
              }
            }),
            {
              defaultOrderData: O,
              orderInfo: A,
              pcsInfo: b,
              updateOption: C,
              updatePcsOption: y,
              updatePostPcs: I
            } = qr(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: B => o("update", B)
              }
            }),
            w = R(() => b.value.SUB_MTR?.find(B => B.PCS_CD === xl[s.value])),
            U = R(() => Ll[n.data.pdt_base_info[0].PDT_CD] ? A.value.quantityInfo?.prnCnt || 1 : (A.value.quantityInfo?.ordCnt || 1) * (A.value.quantityInfo?.prnCnt || 1)),
            Z = H(null),
            me = le("callbacks", {});
          F(() => f.value, B => {
            B && u.value.length === 0 && (Z.value = "달력 사이즈 설정이 필요합니다")
          }, {
            immediate: !0
          }), F(() => Z.value, B => {
            B && me?.onError && me.onError(B || "주문 위젯 에러 발생")
          }, {
            immediate: !0
          });
          const _e = () => {
            me?.onReset && me.onReset("fileUpload")
          };
          return F(() => A.value.dosuInfo?.COD, B => {
            k.isAfterEdit() && B === "SID_X" && _e()
          }), (B, W) => Z.value ? (g(), V(bS, {
            key: 0,
            message: Z.value
          }, null, 8, ["message"])) : (g(), M(J, {
            key: 1
          }, [r.value.pageDirection.view_yn === "Y" && T(A)?.dosuInfo?.COD !== "SID_X" ? (g(), V(Y1, {
            key: 0,
            "related-data": {
              sizeInfo: T(A).sizeInfo
            },
            onUpdate: W[0] || (W[0] = ue => T(C)("pageDirection")(ue))
          }, null, 8, ["related-data"])) : oe("", !0), n.data.option_material_filters ? (g(), V(ob, {
            key: 1,
            options: n.data.option_material_filters,
            onUpdate: h
          }, null, 8, ["options"])) : oe("", !0), n.data.option_info?.color_info ? (g(), V(rb, {
            key: 2,
            data: n.data.option_info?.color_info,
            onUpdate: W[1] || (W[1] = ue => T(C)("setData")(ue))
          }, null, 8, ["data"])) : oe("", !0), i.value ? (g(), V(W_, {
            key: 3,
            options: B.data.option_info?.shape_info || [],
            default: T(O)?.shapeInfo,
            onUpdate: W[2] || (W[2] = ue => T(C)("shapeInfo")(ue))
          }, null, 8, ["options", "default"])) : oe("", !0), de((g(), V(ns(T(c)), {
            options: l.value,
            default: T(O)?.meterialInfo,
            "reset-after-edit": T(d1).has(B.data.pdt_base_info[0].PDT_CD) && T(k).isAfterEdit(),
            "show-extra": B.widgetAttr.able_paper_yn === "Y",
            "related-data": {
              POST_PCS: w.value,
              filters: d.value
            },
            onUpdate: W[3] || (W[3] = ue => T(C)("meterialInfo")(ue))
          }, null, 40, ["options", "default", "reset-after-edit", "show-extra", "related-data"])), [
            [Kt, r.value.paperSelect.view_yn === "Y"]
          ]), de(K(q_, {
            options: B.data.pdt_dosu_info,
            default: T(O)?.dosuInfo,
            "related-data": {
              mtrlCd: T(A).meterialInfo?.MTRL_CD,
              mtrlDosu: T(A).meterialInfo?.SID_GBN
            },
            onUpdate: W[4] || (W[4] = ue => T(C)("dosuInfo")(ue))
          }, null, 8, ["options", "default", "related-data"]), [
            [Kt, r.value.dosuSelect.view_yn === "Y" && B.data.pdt_dosu_info]
          ]), B.data.option_info?.thickness_info ? (g(), V(lb, {
            key: 4,
            options: B.data.option_info.thickness_info,
            onUpdate: W[5] || (W[5] = ue => p("thickness")(ue))
          }, null, 8, ["options"])) : oe("", !0), de(K(Bl, {
            options: u.value,
            "base-info": B.data.pdt_base_info[0],
            default: T(O)?.size,
            "related-data": {
              shape: T(A).shapeInfo?.COD,
              sizeFromPostPcs: B.data.pdt_base_info[0].SIZE_PCS_USE ? _.sizeFromPostPcs : null,
              pageDirection: T(A).pageDirection?.COD
            },
            onUpdate: W[6] || (W[6] = ue => T(C)("sizeInfo")(ue)),
            onValidate: W[7] || (W[7] = ue => T(C)("validation")(ue)),
            "onUpdate:shape": W[8] || (W[8] = ue => p("shapeFromSize")(ue))
          }, null, 8, ["options", "base-info", "default", "related-data"]), [
            [Kt, r.value.sizeSelect.view_yn === "Y" && T(A)?.dosuInfo?.COD !== "SID_X"]
          ]), f.value && T(k).uploadType.default === "editor" && !T(z_).has(s.value) ? (g(), V(Ab, {
            key: 5,
            onUpdate: W[9] || (W[9] = ue => T(C)("calendarInfo")(ue))
          })) : oe("", !0), r.value.quantityGroup.view_yn === "Y" ? (g(), V(ns(N.value), {
            key: 6,
            "can-edit-ord-cnt": T(E),
            options: B.data.pdt_prn_cnt_info,
            default: T(O)?.quantityInfo,
            "default-set-cnt": B.data.pdt_base_info[0].SET_CNT,
            unit: B.data.pdt_base_info[0].PDT_UNIT,
            "related-data": {
              dosu: T(A).dosuInfo?.COD,
              size: T(A).sizeInfo?.DIV_NM
            },
            "express-shipping": D.value,
            onUpdate: W[10] || (W[10] = ue => T(C)("quantityInfo")(ue))
          }, null, 40, ["can-edit-ord-cnt", "options", "default", "default-set-cnt", "unit", "related-data", "express-shipping"])) : oe("", !0), r.value.subjectGroup.view_yn === "Y" ? (g(), V(X_, {
            key: 7,
            "is-biz-mem": T(a)?.bsn_yn === "Y",
            onUpdate: W[11] || (W[11] = ue => T(C)("etcInfo")(ue))
          }, null, 8, ["is-biz-mem"])) : oe("", !0), K(Vl, {
            options: m.value.postPcs.hidden,
            "related-data": {
              shape: T(A).shapeInfo?.COD || _.shapeFromSize,
              mtrlCd: T(A).meterialInfo?.MTRL_CD,
              sizeInfo: T(A).sizeInfo,
              thickness: _.thickness,
              orderQty: U.value,
              dosu: T(A).dosuInfo?.COD
            },
            "disabled-opts": m.value.disabled,
            onUpdate: W[12] || (W[12] = ue => T(I)("hidden")(ue))
          }, null, 8, ["options", "related-data", "disabled-opts"]), K(Yl, {
            options: m.value.postPcs.visible,
            "related-data": {
              mtrlCd: T(A).meterialInfo?.MTRL_CD,
              sizeInfo: T(A).sizeInfo,
              orderQty: U.value
            },
            "attb-opts": B.data.pdt_add_info[1],
            "disabled-opts": m.value.disabled,
            onUpdate: W[13] || (W[13] = ue => T(I)("visible")(ue))
          }, null, 8, ["options", "related-data", "attb-opts", "disabled-opts"]), K(Jb, {
            options: m.value.sub,
            "related-data": {
              orderQty: U.value,
              sizeInfo: T(A).sizeInfo,
              mtrlCd: T(A).meterialInfo?.MTRL_CD,
              pcsCodeForSize: B.data.pdt_base_info[0].SIZE_PCS_USE,
              setData: T(A)?.setData
            },
            onUpdate: W[14] || (W[14] = ue => T(y)("SUB_MTR")(ue)),
            "onUpdate:size": W[15] || (W[15] = ue => p("sizeFromPostPcs")(ue))
          }, null, 8, ["options", "related-data"]), B.widgetAttr.order_yn !== "N" && T(A).dosuInfo?.COD !== "SID_X" ? (g(), V(ks, {
            key: 8,
            "upload-config": T(v),
            "show-extra": B.widgetAttr.useTemplateDownload === "Y" && B.widgetAttr.usePDF === "Y",
            "related-data": {
              size: T(A).sizeInfo
            },
            onUpload: W[16] || (W[16] = ue => T(C)("fileUploadInfo")(ue))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : oe("", !0)], 64))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    DS = re({
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
          s = Dt(),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = le("callbacks", {}),
          i = le("deviceType", "pc"),
          l = R(() => n.options.map(h => ({
            name: h.COD_NME,
            value: h.COD,
            key: h.COD
          }))),
          c = H(n.default || l.value[0].value),
          u = h => {
            c.value = h
          },
          d = R(() => n.options.map((h, f) => ({
            IDX: f + 1,
            CATEGORY: x("제작방식"),
            LABEL: n.options[f].COD_NME,
            IMG_URL: `${qe}/${s.locale}/item/print_method/${h.COD}/${r.pdtCode}.png`,
            IMG_ALT: h.COD_NME
          })));
        return F(() => c.value, h => {
          const f = n.options.find(_ => _.COD == h);
          o("update", f)
        }, {
          immediate: !0
        }), (h, f) => (g(), V(fe, {
          title: "제작방식",
          option: "Method",
          extra: T(i) === "mobile" && d.value ? {
            name: "자세히보기",
            callback: () => {
              T(a).onInformOptionTips && T(a).onInformOptionTips(d.value)
            },
            style: "tip"
          } : null
        }, {
          default: ce(() => [K(Sn, {
            options: l.value,
            default: c.value,
            tips: d.value,
            onSelect: u
          }, null, 8, ["options", "default", "tips"])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    PS = re({
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
          s = Dt(),
          r = Ve(),
          a = le("productCode", {
            pdtCode: ""
          }),
          i = le("callbacks", {}),
          l = le("deviceType", "pc"),
          c = R(() => n.options.map(_ => ({
            name: _.COD_NME,
            value: _.COD,
            key: _.COD
          }))),
          u = H(n.default || c.value[0].value),
          d = _ => {
            u.value = _
          },
          h = {
            O: new Set(["ACTHBCO", "ACTHDCO"]),
            X: new Set(["ACTHBCO", "ACTHDCO", "ACTHFCO"])
          },
          f = R(() => n.options.map((_, p) => ({
            IDX: p + 1,
            CATEGORY: x("인쇄데이터"),
            LABEL: n.options[p].COD_NME,
            IMG_URL: h[_.COD].has(a.pdtCode) ? `${qe}/${s.locale}/item/printdata/${_.COD}/${a.pdtCode}.png` : `${qe}/${s.locale}/item/printdata/${_.COD}/default.png`,
            IMG_ALT: _.COD_NME
          })));
        return F(() => u.value, _ => {
          r.isAfterEdit() && i?.onReset && i.onReset("printData");
          const p = n.options.find(m => m.COD === _);
          o("update", p)
        }, {
          immediate: !0
        }), (_, p) => (g(), V(fe, {
          title: "인쇄데이터",
          extra: T(l) === "mobile" && f.value ? {
            name: "자세히보기",
            callback: () => {
              T(i).onInformOptionTips && T(i).onInformOptionTips(f.value)
            },
            style: "tip"
          } : null
        }, {
          default: ce(() => [K(Sn, {
            options: c.value,
            default: u.value,
            tips: f.value,
            onSelect: d
          }, null, 8, ["options", "default", "tips"])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    ES = ["value", "disabled"],
    nh = re({
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
          s = le("callbacks", {}),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = Dt(),
          i = R(() => {
            const h = n.options.filter(f => f.GRP_OPTION_CD === n.relatedData?.method);
            return h.length > 0 ? h : n.options
          }),
          l = R(() => i.value.filter(h => h.HIDE_YN !== "Y")),
          c = H(n.default?.MTRL_CD || l.value[0]?.MTRL_CD),
          u = async () => {
            const h = await Nl({
              pdt_cod: r.pdtCode,
              lang: a.locale
            });
            if (!h) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
            s?.onInformMaterials ? s.onInformMaterials(h) : console.log("[RedWidgetSDK] 자재 정보 >", h)
          }, d = () => {
            n.resetAfterEdit && s?.onReset && s.onReset("mtrl")
          };
        return F(() => c.value, h => {
          const f = l.value.find(_ => _.MTRL_CD === h);
          if (f) {
            const {
              PTT_CD: _,
              PTT_NM: p,
              WGT_CD: m,
              CLR_CD: v,
              MTRL_CD: E,
              MTRL_NM: k,
              MTRL_TYPE: N,
              PRT_HIDE_YN: D
            } = f;
            o("update", {
              PTT_CD: _,
              PTT_NM: p,
              WGT_CD: m,
              CLR_CD: v,
              MTRL_CD: E,
              MTRL_NM: k,
              MTRL_TYPE: N,
              PRT_HIDE_YN: D
            }), _ === "OOO" && s?.onSaleOrder && s?.onSaleOrder(), d()
          }
        }, {
          immediate: !0
        }), F(() => n.relatedData?.method, h => {
          h && (c.value = l.value[0]?.MTRL_CD)
        }), (h, f) => (g(), V(fe, {
          title: "자재",
          extra: h.showExtra ? {
            name: "주문가능자재",
            callback: u
          } : null
        }, {
          default: ce(() => [de(S("select", {
            "onUpdate:modelValue": f[0] || (f[0] = _ => c.value = _),
            class: "basic-select",
            name: "material",
            onChange: d
          }, [(g(!0), M(J, null, he(i.value, _ => (g(), M("option", {
            key: _.MTRL_CD,
            value: _.MTRL_CD,
            disabled: _.HIDE_YN === "Y"
          }, j(_.HIDE_YN !== "Y" ? _.MTRL_NM : `[${_.HIDE_RSN||T(x)("주문불가")}] ${_.MTRL_NM}`) + " " + j(_.BSN_YN === "Y" ? "[영업주문]" : ""), 9, ES))), 128))], 544), [
            [We, c.value]
          ])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    OS = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: nh
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    IS = {
      class: "qty-group"
    },
    RS = {
      class: "title"
    },
    wS = {
      class: "subject"
    },
    AS = {
      class: "subject"
    },
    NS = {
      class: "inputs"
    },
    MS = ["disabled"],
    kS = {
      class: "icon-box"
    },
    LS = ["value"],
    $S = {
      class: "notes"
    },
    xS = {
      class: "note"
    },
    FS = {
      key: 0,
      class: "note"
    },
    US = {
      key: 1,
      class: "note"
    },
    BS = {
      key: 2,
      class: "note"
    },
    VS = {
      key: 3,
      class: "note"
    },
    HS = {
      key: 4,
      class: "note red"
    },
    oh = Be(re({
      __name: "DesignQty",
      props: {
        options: {},
        default: {},
        relatedData: {},
        canEditOrdCnt: {},
        expressShipping: {},
        unit: {}
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = le("productCode", {
            pdtCode: ""
          }),
          r = Ve(),
          a = H("select"),
          i = () => {
            a.value = a.value === "input" ? "select" : "input", a.value === "select" && (f.value.find(y => y.PRN_CNT === p.value) || (p.value = c.value))
          },
          l = R(() => n.options.find(C => C.DFT_YN === "Y") || n.options[0]),
          c = R(() => l.value?.DFT_PRN_CNT || 1),
          u = R(() => l.value?.MIN_PRN_CNT || 1),
          d = R(() => l.value?.INC_CNT || 1),
          h = R(() => l.value?.INC_STEP || 10),
          f = R(() => {
            if (n.options.length > 1) return n.options;
            const C = [];
            for (let y = u.value; C.length < h.value; y += d.value) {
              const I = {
                PRN_CNT: y
              };
              C.push(I)
            }
            return C
          }),
          _ = H(n.default?.ordCnt || 1),
          p = H(n.default?.prnCnt || c.value || u.value),
          m = R(() => ({
            ordCnt: _.value,
            prnCnt: p.value
          })),
          v = R(() => (_.value * p.value).toLocaleString()),
          E = R(() => {
            if (!n.expressShipping) return;
            const {
              maxQty: C,
              type: y
            } = n.expressShipping;
            if (!(C === 0 || C >= +v.value)) {
              if (y === "Y") return x("오늘출발-불가능");
              if (y === "T") return x("내일출발-불가능")
            }
          }),
          k = R(() => {
            const C = h1[s.pdtCode] || (n.relatedData?.dosu === "SID_D" ? 2 : 1);
            return (_.value * C).toLocaleString()
          }),
          N = R(() => r.uploadType.default === "editor"),
          D = R(() => {
            if (!p.value) return !0;
            if (d.value !== 1) {
              const C = p.value % d.value;
              if (d.value > 1 && C !== 0) return !0
            }
            return !1
          }),
          O = R(() => !_.value),
          A = () => {
            if (!p.value) return p.value = 1;
            if (d.value !== 1) {
              const C = p.value % d.value;
              if (d.value > 1 && C !== 0) {
                const y = Math.ceil(p.value / d.value);
                p.value = (y || 1) * d.value
              }
            }
          },
          b = () => {
            if (!_.value) return _.value = 1
          };
        return F(() => m.value, un(C => {
          D.value || O.value || o("update", C)
        }, 300), {
          immediate: !0
        }), F(() => r.editorData?.default?.quantityInfo?.ordCnt, (C, y) => {
          if (C) _.value = C;
          else if (y) return _.value = 1
        }), F(() => r.uploadType.default, C => {
          C === "editor" && (_.value = 1)
        }), (C, y) => {
          const I = on("dompurify-html");
          return g(), V(fe, null, {
            default: ce(() => [S("div", IS, [S("div", RS, [S("h2", wS, j(T(x)("디자인수")), 1), S("h2", AS, j(T(x)("수량")), 1)]), S("div", NS, [de(S("input", {
              "onUpdate:modelValue": y[0] || (y[0] = w => _.value = w),
              type: "number",
              class: "basic-input",
              id: "ORD_CNT",
              min: "1",
              disabled: N.value || !C.canEditOrdCnt.pdf,
              onFocusout: b
            }, null, 40, MS), [
              [yt, _.value]
            ]), S("div", kS, [K(Kr)]), a.value === "input" ? de((g(), M("input", {
              key: 0,
              "onUpdate:modelValue": y[1] || (y[1] = w => p.value = w),
              type: "number",
              class: "basic-input",
              id: "PRN_CNT",
              min: "1",
              onFocusout: A
            }, null, 544)), [
              [yt, p.value]
            ]) : de((g(), M("select", {
              key: 1,
              "onUpdate:modelValue": y[2] || (y[2] = w => p.value = w),
              name: "PRN_CNT",
              class: "basic-select"
            }, [(g(!0), M(J, null, he(f.value, w => (g(), M("option", {
              value: w.PRN_CNT,
              key: w.PRN_CNT
            }, j(w.PRN_CNT), 9, LS))), 128))], 512)), [
              [We, p.value]
            ]), S("button", {
              type: "button",
              class: "action-btn",
              onClick: i
            }, j(a.value === "input" ? T(x)("수량선택") : T(x)("직접입력")), 1)])]), S("div", $S, [de(S("p", xS, null, 512), [
              [I, T(x)("주문수량안내", {
                QTY: v.value + (C.unit || T(x)("개"))
              })]
            ]), u.value > 1 ? de((g(), M("p", FS, null, 512)), [
              [I, T(x)("단위주문수량안내", {
                QTY: `${u.value}`
              })]
            ]) : oe("", !0), N.value ? oe("", !0) : (g(), M("p", US, "* " + j(`${T(x)("PDF장수안내",{QTY:k.value})}`), 1)), C.canEditOrdCnt.pdf && C.canEditOrdCnt.editor ? (g(), M("p", BS, "* " + j(T(x)("디자인건수가능여부-전체")), 1)) : !C.canEditOrdCnt.pdf && C.canEditOrdCnt.editor ? (g(), M("p", VS, " * " + j(T(x)("디자인건수가능여부-에디터")), 1)) : oe("", !0), E.value ? de((g(), M("p", HS, null, 512)), [
              [I, E.value]
            ]) : oe("", !0)])]),
            _: 1
          })
        }
      }
    }), [
      ["__scopeId", "data-v-598642f7"]
    ]),
    GS = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: oh
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    jS = {
      class: "basic-radio"
    },
    zS = ["for", "aria-disabled"],
    YS = ["id", "name", "value", "checked", "disabled", "onChange"],
    KS = {
      class: "text"
    },
    Dn = re({
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
            n("change", s)
          };
        return (s, r) => (g(), M("div", jS, [(g(!0), M(J, null, he(s.options, a => (g(), M("label", {
          key: a.id,
          for: a.id,
          "aria-disabled": a.disabled
        }, [S("input", {
          type: "radio",
          id: a.id,
          name: a.name,
          value: a.value,
          checked: s.defaultChecked === a.value,
          disabled: a.disabled,
          onChange: () => o(a)
        }, null, 40, YS), S("span", KS, j(T(x)(a.label)), 1)], 8, zS))), 128))]))
      }
    }),
    WS = {
      class: "flex-row"
    },
    qS = re({
      __name: "Acrylic",
      props: {
        options: {},
        default: {
          default () {
            return {
              assembleYN: {
                SUB_MTR_KR: "Y",
                SUB_MTR_BN: "Y",
                SUB_MTR_CN: "Y",
                SUB_MTR_CR: "Y"
              },
              subMtrlOption: {}
            }
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
          s = xe(new Map),
          r = R(() => [...s.values()].sort((h, f) => h.order && f.order ? h.order - f.order : 0)),
          a = xe({
            ...n.default.assembleYN
          }),
          i = xe({
            ...n.default.subMtrlOption
          }),
          l = H(null);

        function c(h) {
          const f = s.get(h);
          f && (f.value === l.value ? l.value = null : (l.value = f.value, i[l.value] = {
            PCS_DTL_CD: f.options[0].value,
            qty: n.relatedData.orderQty,
            extra: f.options[0].extra
          }))
        }

        function u(h) {
          a[h.name] = h.value
        }
        const d = h => f => {
          i[h] = f
        };
        return F(() => n.options.visible, h => {
          h.forEach(f => {
            const _ = s.get(f.WEB_PCS_DTL_GRP),
              p = {
                name: f.PCS_DTL_NM,
                value: f.PCS_DTL_CD,
                key: f.PCS_DTL_CD,
                extra: f
              };
            _ ? _.options.push(p) : s.set(f.WEB_PCS_DTL_GRP, {
              name: f.WEB_PCS_DTL_GRP_NM || f.PCS_DTL_NM,
              imgPath: f.WEB_PCS_DTL_GRP,
              subImgPath: f.PCS_CD,
              value: f.WEB_PCS_DTL_GRP,
              active: !1,
              options: [p],
              order: th[f.WEB_PCS_DTL_GRP]
            })
          })
        }, {
          immediate: !0
        }), F(() => n.relatedData.orderQty, h => {
          for (const f in i) i[f].qty = h
        }), rs(() => {
          const h = Object.values(i).map(f => ({
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
              ATTB_3: a[f.extra.WEB_PCS_DTL_GRP]
            }]
          }));
          o("update", h)
        }), F(() => l.value, (h, f) => {
          f && h !== f && (delete i[f], a[f] = n.default.assembleYN[f])
        }), (h, f) => (g(), M(J, null, [s.size ? (g(), V(fe, {
          key: 0,
          title: "부자재선택"
        }, {
          default: ce(() => [S("div", WS, [(g(!0), M(J, null, he(r.value, _ => (g(), V(je, {
            key: _.value,
            active: l.value === _.value,
            data: _,
            onSelect: f[0] || (f[0] = p => c(p.value))
          }, null, 8, ["active", "data"]))), 128))])]),
          _: 1
        })) : oe("", !0), l.value ? (g(), V(fe, {
          key: 1
        }, {
          default: ce(() => [(g(!0), M(J, null, he(r.value, _ => (g(), M(J, {
            key: _.value
          }, [l.value === _.value ? (g(), V(Kl, {
            key: 0,
            title: _.name,
            options: _.options,
            "default-data": i[_.value],
            "qty-disabled": !0,
            onUpdate: p => d(_.value)(p)
          }, Km({
            _: 2
          }, [T(qb).has(_.value) ? {
            name: "extra",
            fn: ce(() => [K(Dn, {
              options: [{
                id: `${_.value}/Y`,
                name: _.value,
                label: "조립",
                value: "Y"
              }, {
                id: `${_.value}/N`,
                name: _.value,
                label: "미조립",
                value: "N"
              }],
              "default-checked": a[_.value],
              onChange: u
            }, null, 8, ["options", "default-checked"])]),
            key: "0"
          } : void 0]), 1032, ["title", "options", "default-data", "onUpdate"])) : oe("", !0)], 64))), 128))]),
          _: 1
        })) : oe("", !0)], 64))
      }
    }),
    QS = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = R(() => n.widgetAttr.skinInfo),
            r = le("member"),
            a = Ve(),
            i = R(() => {
              if (!n.data.option_info) return !1;
              const {
                shape_info: N
              } = n.data.option_info;
              return !cn(N) && !!N[0].COD
            }),
            l = R(() => {
              if (!n.data.option_info) return !1;
              const {
                print_data: N
              } = n.data.option_info;
              return !cn(N) && !!N[0].COD && m.value.meterialInfo?.PRT_HIDE_YN === "N"
            }),
            c = R(() => {
              if (!n.data.option_info) return !1;
              const {
                production_method: N
              } = n.data.option_info;
              return !cn(N) && !!N[0].COD
            }),
            u = R(() => r?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(N => N.BSN_YN !== "Y")),
            d = R(() => {
              const N = [...n.data.pdt_size_info];
              return !i.value || !m.value.acrylicSelectData?.shapeInfo || N.length === 1 ? N : N.filter(D => D.STICKER_TYPE === m.value.acrylicSelectData?.shapeInfo.COD)
            }),
            h = R(() => Ql(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            {
              uploadConfig: f,
              canEditOrdCnt: _
            } = Wr(n.widgetAttr),
            {
              defaultOrderData: p,
              orderInfo: m,
              updateOption: v,
              updatePcsOption: E,
              updatePostPcs: k
            } = qr(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: N => o("update", N)
              }
            });
          return (N, D) => (g(), M(J, null, [de(K(q_, {
            options: N.data.pdt_dosu_info,
            default: T(p)?.dosuInfo,
            onUpdate: D[0] || (D[0] = O => T(v)("dosuInfo")(O))
          }, null, 8, ["options", "default"]), [
            [Kt, s.value.dosuSelect.view_yn === "Y" && N.data.pdt_dosu_info]
          ]), c.value ? (g(), V(DS, {
            key: 0,
            options: N.data.option_info?.production_method || [],
            default: T(p)?.productionMethod,
            onUpdate: D[1] || (D[1] = O => T(v)("productionMethod", !0)(O))
          }, null, 8, ["options", "default"])) : oe("", !0), i.value ? (g(), V(W_, {
            key: 1,
            options: N.data.option_info?.shape_info || [],
            default: T(p)?.shapeInfo,
            onUpdate: D[2] || (D[2] = O => T(v)("shapeInfo", !0)(O))
          }, null, 8, ["options", "default"])) : oe("", !0), l.value ? (g(), V(PS, {
            key: 2,
            options: N.data.option_info?.print_data || [],
            default: T(p)?.printData,
            onUpdate: D[3] || (D[3] = O => T(v)("printData", !0)(O))
          }, null, 8, ["options", "default"])) : oe("", !0), de(K(nh, {
            options: u.value,
            default: T(p)?.meterialInfo,
            "reset-after-edit": T(Qb).has(N.data.pdt_base_info[0].PDT_CD) && T(a).isAfterEdit(),
            "show-extra": N.widgetAttr.able_paper_yn === "Y",
            "related-data": {
              method: T(m).acrylicSelectData?.productionMethod?.COD
            },
            onUpdate: D[4] || (D[4] = O => T(v)("meterialInfo")(O))
          }, null, 8, ["options", "default", "reset-after-edit", "show-extra", "related-data"]), [
            [Kt, s.value.paperSelect.view_yn === "Y"]
          ]), de(K(Bl, {
            options: d.value,
            "base-info": N.data.pdt_base_info[0],
            default: T(p)?.size,
            "related-data": {
              shape: T(m).acrylicSelectData?.shapeInfo?.COD
            },
            onUpdate: D[5] || (D[5] = O => T(v)("sizeInfo")(O)),
            onValidate: D[6] || (D[6] = O => T(v)("validation")(O))
          }, null, 8, ["options", "base-info", "default", "related-data"]), [
            [Kt, (!i.value || i.value && T(m).acrylicSelectData?.shapeInfo) && s.value.sizeSelect.view_yn === "Y"]
          ]), s.value.quantityGroup.view_yn === "Y" ? (g(), V(oh, {
            key: 3,
            "can-edit-ord-cnt": T(_),
            options: N.data.pdt_prn_cnt_info,
            default: T(p)?.quantityInfo,
            "related-data": {
              dosu: T(m).dosuInfo?.COD
            },
            onUpdate: D[7] || (D[7] = O => T(v)("quantityInfo")(O))
          }, null, 8, ["can-edit-ord-cnt", "options", "default", "related-data"])) : oe("", !0), K(Vl, {
            options: h.value.postPcs.hidden,
            "related-data": {
              shape: T(m).acrylicSelectData?.shapeInfo?.COD,
              sizeInfo: T(m).sizeInfo
            },
            "disabled-opts": h.value.disabled,
            onUpdate: D[8] || (D[8] = O => T(k)("hidden")(O))
          }, null, 8, ["options", "related-data", "disabled-opts"]), K(Yl, {
            options: h.value.postPcs.visible,
            "related-data": {
              sizeInfo: T(m).sizeInfo
            },
            "attb-opts": N.data.pdt_add_info[1],
            "disabled-opts": h.value.disabled,
            onUpdate: D[9] || (D[9] = O => T(k)("visible")(O))
          }, null, 8, ["options", "related-data", "attb-opts", "disabled-opts"]), K(qS, {
            options: h.value.sub,
            "related-data": {
              orderQty: (T(m).quantityInfo?.ordCnt || 1) * (T(m).quantityInfo?.prnCnt || 1)
            },
            onUpdate: D[10] || (D[10] = O => T(E)("SUB_MTR")(O))
          }, null, 8, ["options", "related-data"]), N.widgetAttr.order_yn !== "N" ? (g(), V(ks, {
            key: 4,
            "upload-config": T(f),
            "show-extra": N.widgetAttr.useTemplateDownload === "Y" && N.widgetAttr.usePDF === "Y",
            "related-data": {
              print: T(m).acrylicSelectData?.printData
            },
            onUpload: D[11] || (D[11] = O => T(v)("fileUploadInfo")(O))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : oe("", !0)], 64))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    XS = {
      class: "grid-group"
    },
    JS = re({
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
          s = Dt(),
          r = Ve(),
          a = le("productCode", {
            pdtCode: ""
          }),
          i = le("callbacks", {}),
          l = le("deviceType", "pc"),
          c = {
            PTP_DTF: {
              src: `${qe}/{lang}/item/clothes-color-film-img.png`,
              alt: "DTF 열전사 설명 사진"
            },
            PTP_DIR: {
              src: `${qe}/{lang}/item/clothes-color-direct-img.png`,
              alt: "직접인쇄 설명 사진"
            },
            PTP_SLK: {
              src: `${qe}/{lang}/item/clothes-color-printing-img.png`,
              alt: "날염(실크인쇄) 설명 사진"
            }
          },
          u = R(() => n.options.map((N, D) => {
            const O = c[N.COD];
            return O ? {
              IDX: D + 1,
              CATEGORY: x("인쇄"),
              LABEL: n.options[D].COD_NME,
              IMG_URL: O.src.replace("{lang}", s.locale),
              IMG_ALT: O.alt
            } : null
          })),
          d = R(() => n.dosuOptions.map(N => ({
            id: N.COD,
            name: "apparel-print-side",
            value: N.COD,
            label: `의류.${N.COD_NME}`,
            disabled: k.value
          }))),
          h = H(n.dosuOptions[0].COD),
          f = R(() => n.dosuOptions.find(N => N.COD === h.value)),
          _ = H(n.options[0].COD),
          p = R(() => n.options.map(N => ({
            name: N.COD_NME,
            value: N.COD,
            key: N.COD,
            disabled: N.USE_YN !== "Y" || h.value === "SID_X"
          }))),
          m = () => {
            i?.onReset && i.onReset("fileUpload")
          },
          v = N => {
            r.isAfterEdit() && m(), _.value = N
          };
        F(() => h.value, N => {
          o("update:type", {
            COD: N === "SID_S" ? _.value : "",
            PRINT_GBN: N === "SID_S" ? "Y" : "N"
          }), o("update:dosu", {
            ...f.value,
            COD_NME: x(`의류.${f.value.COD_NME}`)
          })
        }, {
          immediate: !0
        }), F(() => _.value, N => {
          o("update:type", {
            COD: N,
            PRINT_GBN: h.value === "SID_S" ? "Y" : "N"
          })
        }, {
          immediate: !0
        });
        const E = R(() => n.relatedData.color),
          k = R(() => !E.value || a.pdtCode !== "CLSTBSA" ? !1 : E.value === "DD" || E.value === "DG");
        return F(() => k.value, N => {
          N && (h.value = "SID_X", alert("[인쇄없음]으로만 주문 가능합니다."))
        }), (N, D) => (g(), V(fe, {
          title: "인쇄",
          extra: T(l) === "mobile" ? {
            name: "자세히보기",
            callback: () => {
              T(i).onInformOptionTips && T(i).onInformOptionTips(u.value)
            },
            style: "tip"
          } : {
            name: "가이드보기",
            callback: () => {
              T(i)?.onInformGuide && T(i).onInformGuide("print")
            }
          }
        }, {
          default: ce(() => [S("div", XS, [K(Dn, {
            options: d.value,
            "default-checked": h.value,
            onChange: D[0] || (D[0] = O => h.value = O.value)
          }, null, 8, ["options", "default-checked"]), K(Sn, {
            options: p.value,
            default: _.value,
            tips: u.value,
            onSelect: v
          }, null, 8, ["options", "default", "tips"])])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    ZS = {
      key: 0,
      class: "arrow-up",
      xmlns: "http://www.w3.org/2000/svg",
      width: "22",
      height: "22",
      viewBox: "0 0 22 22",
      fill: "none"
    },
    eD = {
      key: 1,
      class: "arrow-down",
      xmlns: "http://www.w3.org/2000/svg",
      width: "22",
      height: "22",
      viewBox: "0 0 22 22",
      fill: "none"
    },
    tD = re({
      __name: "Chevron",
      props: {
        direction: {}
      },
      setup(e) {
        return (t, n) => (g(), M(J, null, [t.direction === "up" ? (g(), M("svg", ZS, [...n[0] || (n[0] = [S("path", {
          d: "M4.39961 7.70042L10.9855 14.3002L17.5996 7.70042",
          stroke: "#777777",
          "stroke-width": "1.5",
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        }, null, -1)])])) : oe("", !0), t.direction === "down" ? (g(), M("svg", eD, [...n[1] || (n[1] = [S("path", {
          d: "M4.39961 14.2996L10.9855 7.69981L17.5996 14.2996",
          stroke: "#777777",
          "stroke-width": "1.5",
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        }, null, -1)])])) : oe("", !0)], 64))
      }
    }),
    nD = {
      class: "color-picker"
    },
    oD = {
      key: 0,
      class: "desc"
    },
    sD = {
      class: "text"
    },
    rD = {
      class: "text"
    },
    iD = ["aria-expanded"],
    aD = ["title", "onClick"],
    lD = {
      class: "tooltip"
    },
    sh = Be(re({
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
          r = H(!0);

        function a(l) {
          s.value = l, o("select", l)
        }
        const i = l => {
          const c = l.split(",").map(f => f.replace("#", "")),
            [u, d, h] = c;
          if (c.length === 2) return `linear-gradient(to right, #${u} 50%, #${d} 50%)`;
          if (c.length === 3) return `linear-gradient(to right, #${u} 34%, #${d} 34% 67%, #${h} 33%)`
        };
        return F(() => n.defaultValue, l => {
          l && (s.value = l)
        }), (l, c) => (g(), M("div", nD, [l.canToggle ? (g(), M("div", oD, [S("span", sD, j(T(x)("선택")) + " : " + j(s.value?.COD_NME), 1), S("button", {
          type: "button",
          class: "toggle-btn",
          onClick: c[0] || (c[0] = u => r.value = !r.value)
        }, [S("span", rD, j(r.value ? "접기" : "보기"), 1), K(tD, {
          direction: r.value ? "down" : "up"
        }, null, 8, ["direction"])])])) : oe("", !0), S("ul", {
          class: "color-chip",
          "aria-expanded": l.canToggle ? r.value : !0
        }, [(g(!0), M(J, null, he(l.options, u => (g(), M("li", {
          key: u.COD,
          class: we(["color", {
            active: u.COD === s.value?.COD
          }]),
          title: `hex: ${u.HEX}`,
          style: Qt([{
            background: u.HEX.includes(",") ? i(u.HEX) : u.HEX
          }, {
            border: u.HEX.toLocaleLowerCase().includes("ffff") ? "1px solid #ddd" : ""
          }]),
          onClick: d => a(u)
        }, [S("div", lD, j(u.COD_NME), 1)], 14, aD))), 128))], 8, iD)]))
      }
    }), [
      ["__scopeId", "data-v-609eb670"]
    ]),
    uD = re({
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
          r = le("callbacks", {}),
          a = H(n.options.find(u => u.DEFAULT === "Y") || n.options[0]),
          i = R(() => n.options.find(u => u.COD === a.value.COD)),
          l = () => {
            r?.onReset && r.onReset("color")
          },
          c = u => {
            s.isAfterEdit() && l(), a.value = u
          };
        return F(() => i.value, u => {
          u && o("update", u)
        }, {
          immediate: !0
        }), F(() => s.editorData.default, u => {
          const d = u?.editorClothesInfo?.COLOR;
          if (!d || a.value.COD === d) return;
          const h = n.options.find(f => f.COD === d);
          h && (a.value = h)
        }), (u, d) => (g(), V(fe, {
          title: "의류 컬러"
        }, {
          default: ce(() => [K(sh, {
            options: u.options,
            "can-toggle": !0,
            "default-value": a.value,
            onSelect: c
          }, null, 8, ["options", "default-value"])]),
          _: 1
        }))
      }
    }),
    cD = {
      class: "flex-row -flow"
    },
    dD = {
      class: "notes"
    },
    fD = ["innerHTML"],
    pD = ["innerHTML"],
    _D = ["innerHTML"],
    hD = re({
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
          r = le("productCode", {
            pdtCode: ""
          }),
          a = le("callbacks", {}),
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
          l = R(() => {
            let p = 0;
            for (const m of n.options)
              if ((m.COD === "CL011" || m.COD === "CL001") && p++, p === 2) break;
            return p === 2
          }),
          c = R(() => {
            const p = [];
            for (const m of n.options)(m.COD === "CL011" || m.COD === "CL009" || m.COD === "CL010" || m.COD === "CL004") && p.push(m.COD_NME);
            return p.length === 0 ? null : p.join(", ")
          }),
          u = R(() => n.options.map(p => ({
            name: p.COD_NME,
            value: p.KOI_NME,
            imgPath: `${qe}/ko/item/printarea_${i[r.pdtCode]?i[r.pdtCode][p.COD]:p.COD}.svg`,
            forcedImg: !0
          }))),
          d = xe(n.options.reduce((p, m, v) => (p[m.KOI_NME] = {
            active: v === 0,
            COD: m.COD,
            COD_NME: m.COD_NME,
            KOI_NME: m.KOI_NME
          }, p), {})),
          h = R(() => Object.entries(d).reduce((p, m) => {
            const [v, E] = m;
            return E.active && p.push({
              COD: E.COD,
              COD_NME: E.COD_NME,
              KOI_NME: v
            }), p
          }, [])),
          f = () => {
            a?.onReset && a.onReset("printArea")
          },
          _ = p => {
            h.value.length === 1 && d[p]?.active || (s.isAfterEdit() && f(), p === "front" && d.leftchest && (d.leftchest.active = !1), p === "leftchest" && d.front && (d.front.active = !1), d[p].active = !d[p].active)
          };
        return F(() => h.value, p => {
          o("update", p)
        }, {
          immediate: !0
        }), F(() => n.relatedData.printType?.PRINT_GBN, p => {
          p === "N" ? o("update", null) : o("update", h.value)
        }), F(() => s.editorData.default, p => {
          const m = p?.editorClothesInfo?.PAGES;
          if (m)
            for (const v in d) d[v].active = m.includes(v)
        }), (p, m) => p.relatedData.printType?.PRINT_GBN === "Y" ? (g(), V(fe, {
          key: 0,
          title: "인쇄 영역"
        }, {
          default: ce(() => [S("div", cD, [(g(!0), M(J, null, he(u.value, v => (g(), V(je, {
            key: v.value,
            data: v,
            active: d[v.value].active,
            onSelect: m[0] || (m[0] = E => _(E.value))
          }, null, 8, ["data", "active"]))), 128))]), S("div", dD, [p.relatedData.printType.COD === "PTP_DTF" && l.value ? (g(), M("p", {
            key: 0,
            class: "note",
            innerHTML: T(x)("의류인쇄영역가이드")
          }, null, 8, fD)) : oe("", !0), p.relatedData.printType.COD === "PTP_DIR" && c.value ? (g(), M("p", {
            key: 1,
            class: "note",
            innerHTML: T(x)("의류인쇄영역가이드-직접인쇄", {
              areas: c.value
            })
          }, null, 8, pD)) : oe("", !0), p.relatedData.printType.COD === "PTP_SLK" ? (g(), M("p", {
            key: 2,
            class: "note",
            innerHTML: T(x)("의류인쇄영역가이드-실크인쇄")
          }, null, 8, _D)) : oe("", !0)])]),
          _: 1
        })) : oe("", !0)
      }
    }),
    rh = re({
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
            label: x("adult"),
            value: "adult"
          }, {
            id: "child",
            name: "size-option",
            label: x("child"),
            value: "child"
          }],
          r = H(n.default);
        return F(() => r.value, a => {
          o("update", a)
        }), (a, i) => (g(), V(Dn, {
          options: s,
          "default-checked": s[0].value,
          onChange: i[0] || (i[0] = l => r.value = l.value)
        }, null, 8, ["default-checked"]))
      }
    }),
    mD = {
      class: "grid-group"
    },
    vD = {
      key: 1,
      class: "note red"
    },
    gD = {
      class: "inputs"
    },
    yD = ["value"],
    CD = {
      class: "notes"
    },
    TD = {
      class: "note"
    },
    bD = Be(re({
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
          r = le("callbacks", {}),
          a = R(() => {
            const N = {};
            return n.options.forEach(D => {
              const O = N[D.GBN];
              O ? O.push(D) : N[D.GBN] = [D]
            }), N
          }),
          i = R(() => Object.keys(a.value)),
          l = H(i.value.length === 1 ? i.value[0] : "adult"),
          c = R(() => [...a.value[l.value]].sort((D, O) => n.sizeInfo[D.COD].ORD - n.sizeInfo[O.COD].ORD).map(D => ({
            name: n.sizeInfo[D.COD].COD_NME || D.COD_NME,
            value: D.COD,
            key: D.COD,
            disabled: D.HIDE_YN === "Y"
          }))),
          u = H("select"),
          d = () => {
            u.value = u.value === "input" ? "select" : "input"
          },
          h = R(() => {
            const N = c.value.filter(O => !O.disabled);
            if (N.length === 1) return N[0].value;
            const D = l.value === "adult" ? Math.trunc(N.length / 2) : 0;
            return N[D].value
          }),
          f = H(h.value);

        function _(N) {
          s.isAfterEdit() && r?.onReset && r.onReset("size"), f.value = N
        }
        const p = R(() => {
            const D = [];
            for (let O = 1; O <= 10; O++) D.push(O);
            return D
          }),
          m = H(1);
        F(() => m.value, N => {
          N || (m.value = 1), o("update:qty", {
            ordCnt: 1,
            prnCnt: N
          })
        }, {
          immediate: !0
        }), rs(() => {
          f.value = h.value
        });
        const v = R(() => n.options.filter(N => N.COD === f.value).map(N => ({
            size: N,
            quantity: m.value
          }))),
          E = R(() => v.value[0]?.size?.QUICK_ORD_YN === "N"),
          k = R(() => n.options.filter(N => N.QUICK_ORD_YN === "N").map(N => n.sizeInfo[N.COD].COD_NME || N.COD_NME).join(", "));
        return F(() => v.value, N => {
          N && o("update:combinations", N)
        }, {
          immediate: !0
        }), F(() => s.editorData.default, N => {
          const D = N?.editorClothesInfo?.SIZE;
          D && (f.value = D)
        }), (N, D) => {
          const O = on("dompurify-html");
          return g(), M(J, null, [K(fe, {
            title: "사이즈"
          }, {
            default: ce(() => [S("div", mD, [i.value.length > 1 ? (g(), V(rh, {
              key: 0,
              options: i.value,
              default: l.value,
              onUpdate: D[0] || (D[0] = A => l.value = A)
            }, null, 8, ["options", "default"])) : oe("", !0), K(Sn, {
              type: "sm",
              options: c.value,
              default: f.value,
              onSelect: _
            }, null, 8, ["options", "default"]), E.value ? (g(), M("p", vD, j(T(x)("퀵오더불가")) + " - " + j(k.value), 1)) : oe("", !0)])]),
            _: 1
          }), K(fe, {
            title: "수량"
          }, {
            default: ce(() => [S("div", gD, [u.value === "input" ? de((g(), M("input", {
              key: 0,
              "onUpdate:modelValue": D[1] || (D[1] = A => m.value = A),
              type: "number",
              class: we(["basic-input", "-fixed-w"]),
              id: "PRN_CNT",
              min: "1"
            }, null, 512)), [
              [yt, m.value]
            ]) : de((g(), M("select", {
              key: 1,
              "onUpdate:modelValue": D[2] || (D[2] = A => m.value = A),
              name: "PRN_CNT",
              class: we(["basic-select", "-fixed-w"])
            }, [(g(!0), M(J, null, he(p.value, A => (g(), M("option", {
              value: A,
              key: `${A}`
            }, j(A), 9, yD))), 128))], 512)), [
              [We, m.value]
            ]), S("button", {
              type: "button",
              class: "action-btn",
              onClick: d
            }, j(u.value === "input" ? T(x)("수량선택") : T(x)("직접입력")), 1)]), S("div", CD, [de(S("p", TD, null, 512), [
              [O, T(x)("의류주문가능수량", {
                QTY: "1"
              })]
            ])])]),
            _: 1
          })], 64)
        }
      }
    }), [
      ["__scopeId", "data-v-3fed104a"]
    ]),
    SD = {
      class: "grid-group"
    },
    DD = {
      class: "multi-size"
    },
    PD = {
      class: "label"
    },
    ED = {
      class: "input-box"
    },
    OD = ["disabled", "onClick"],
    ID = ["onUpdate:modelValue", "disabled"],
    RD = ["disabled", "onClick"],
    wD = {
      key: 1,
      class: "note red"
    },
    AD = Be(re({
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
          s = R(() => {
            const _ = [...n.options].sort((m, v) => n.sizeInfo[m.COD].ORD - n.sizeInfo[v.COD].ORD),
              p = {};
            return _.forEach(m => {
              const v = p[m.GBN];
              v ? v.push(m) : p[m.GBN] = [m]
            }), p
          }),
          r = R(() => Object.keys(s.value)),
          a = H(r.value.length === 1 ? r.value[0] : "adult"),
          i = xe(n.options.reduce((_, p) => (_[p.COD] = 0, _), {})),
          l = R(() => Object.values(i).reduce((_, p) => _ + p, 0)),
          c = _ => {
            i[_] = i[_] + 1
          },
          u = _ => {
            i[_] < 1 || (i[_] = i[_] - 1)
          },
          d = R(() => n.options.filter(_ => i[_.COD] > 0).map(_ => ({
            size: _,
            quantity: i[_.COD]
          }))),
          h = R(() => d.value.some(_ => i[_.size.COD] > 0 && _.size.QUICK_ORD_YN === "N")),
          f = R(() => n.options.filter(_ => _.QUICK_ORD_YN === "N").map(_ => n.sizeInfo[_.COD].COD_NME || _.COD_NME).join(", "));
        return F(() => d.value, _ => {
          o("update:qty", {
            ordCnt: 1,
            prnCnt: l.value
          }), o("update:combinations", _)
        }), (_, p) => (g(), V(fe, {
          title: "사이즈별수량"
        }, {
          default: ce(() => [S("div", SD, [r.value.length > 1 ? (g(), V(rh, {
            key: 0,
            options: r.value,
            default: a.value,
            onUpdate: p[0] || (p[0] = m => a.value = m)
          }, null, 8, ["options", "default"])) : oe("", !0), S("div", DD, [(g(!0), M(J, null, he(s.value[a.value], m => (g(), M("div", {
            key: m.COD,
            class: we(["size", "size-s", {
              soldout: m.HIDE_YN === "Y"
            }])
          }, [S("span", PD, j(_.sizeInfo[m.COD].COD_NME || m.COD_NME), 1), S("div", ED, [S("button", {
            type: "button",
            class: "control-btn",
            disabled: m.HIDE_YN === "Y",
            onClick: () => u(m.COD)
          }, [...p[1] || (p[1] = [S("span", {
            class: "icon minus"
          }, null, -1)])], 8, OD), de(S("input", {
            "onUpdate:modelValue": v => i[m.COD] = v,
            type: "number",
            name: "size-qty",
            disabled: m.HIDE_YN === "Y"
          }, null, 8, ID), [
            [yt, i[m.COD]]
          ]), S("button", {
            type: "button",
            class: "control-btn",
            disabled: m.HIDE_YN === "Y",
            onClick: () => c(m.COD)
          }, [...p[2] || (p[2] = [S("span", {
            class: "icon plus"
          }, null, -1)])], 8, RD)])], 2))), 128))]), h.value ? (g(), M("p", wD, j(T(x)("퀵오더불가")) + " - " + j(f.value), 1)) : oe("", !0)])]),
          _: 1
        }))
      }
    }), [
      ["__scopeId", "data-v-949c188e"]
    ]),
    ND = {},
    MD = {
      xmlns: "http://www.w3.org/2000/svg",
      width: "14",
      height: "10",
      viewBox: "0 0 14 10",
      fill: "none"
    };

  function kD(e, t) {
    return g(), M("svg", MD, [...t[0] || (t[0] = [S("path", {
      d: "M1.29102 4.1319L6.21182 8.44571L12.4021 1.375",
      stroke: "white",
      "stroke-width": "2.18182",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    }, null, -1)])])
  }
  const LD = Be(ND, [
      ["render", kD]
    ]),
    $D = {
      class: "pantone-layer"
    },
    xD = {
      class: "pantone-modal"
    },
    FD = {
      class: "modal-header"
    },
    UD = {
      class: "modal-body"
    },
    BD = {
      class: "color-palette"
    },
    VD = ["data-rgb", "data-checked", "onClick"],
    HD = {
      class: "pantone-number"
    },
    GD = {
      key: 1,
      class: "selected"
    },
    jD = {
      class: "preview"
    },
    zD = {
      class: "color-preview"
    },
    YD = {
      key: 1,
      class: "selected-color"
    },
    KD = {
      class: "not-found"
    },
    WD = ["src"],
    qD = {
      class: "pantone-mark"
    },
    QD = {
      class: "logo"
    },
    XD = {
      class: "icon-padding tip"
    },
    JD = {
      class: "tooltip"
    },
    ZD = {
      class: "tip-text"
    },
    eP = {
      class: "selected-color-text"
    },
    tP = {
      class: "color-search"
    },
    nP = ["placeholder"],
    oP = {
      class: "notice-txt"
    },
    sP = ["disabled"],
    rP = Be(re({
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
          r = R(() => s.value ? s.value : n.selected),
          a = () => {
            r.value && o("select", r.value)
          },
          i = H(""),
          l = H(!1),
          c = () => {
            const u = i.value.toLowerCase().replace(/\s/g, ""),
              d = n.options.find(h => h.pantone_name.replace(/\s/g, "").toLowerCase().includes(u));
            d ? (s.value = d, l.value = !1) : (s.value = null, l.value = !0)
          };
        return (u, d) => {
          const h = on("dompurify-html");
          return g(), M("div", $D, [S("div", xD, [S("div", FD, [S("h2", null, j(T(x)("팬톤 컬러 선택")), 1), S("button", {
            type: "button",
            class: "close-btn",
            onClick: d[0] || (d[0] = f => o("close"))
          }, [K(Kr)])]), S("div", UD, [S("div", BD, [(g(!0), M(J, null, he(u.options, f => (g(), M("span", {
            key: f.hex_cod,
            class: "color-chip",
            "data-rgb": f.hex_cod,
            "data-checked": r.value?.hex_cod === f.hex_cod,
            style: Qt({
              backgroundColor: `rgb(${f.rgb_R}, ${f.rgb_G} ,${f.rgb_B})`
            }),
            onClick: _ => s.value = f
          }, [S("p", HD, j(f.pantone_name.replace("PANTONE", "")), 1), r.value?.hex_cod === f.hex_cod ? (g(), V(LD, {
            key: 0
          })) : oe("", !0), r.value?.hex_cod === f.hex_cod ? (g(), M("span", GD)) : oe("", !0)], 12, VD))), 128))]), S("div", jD, [S("div", zD, [r.value ? (g(), M("div", {
            key: 0,
            class: "selected-color",
            style: Qt({
              backgroundColor: `rgb(${r.value.rgb_R}, ${r.value.rgb_G} ,${r.value.rgb_B})`
            })
          }, null, 4)) : l.value ? (g(), M("div", YD, [de(S("p", KD, null, 512), [
            [h, T(x)("팬톤검색실패문구")]
          ])])) : (g(), M("img", {
            key: 2,
            src: `${T(qe)}/ko/item/page-order-clothes-pantone-modal.png`,
            width: 240,
            height: 150,
            alt: "팬톤 선택 전 이미지"
          }, null, 8, WD)), S("div", qD, [S("div", QD, [d[3] || (d[3] = Uv('<div class="icon-padding" data-v-d02e5e9c><svg xmlns="http://www.w3.org/2000/svg" width="114" height="18" viewBox="0 0 114 18" fill="none" data-v-d02e5e9c><path d="M5.2351 3.46373H7.80534C8.7552 3.46373 9.92857 3.46373 10.5991 4.35773C10.8226 4.6371 10.9902 5.02822 11.0461 5.81047C11.0461 7.20734 10.4873 8.04546 9.09045 8.26896C8.69933 8.32483 8.41996 8.32483 7.69359 8.32483H5.2351V3.46373ZM1.15625 0.4465V16.6502H5.2351V11.3421H7.97296C10.3197 11.2862 12.6106 11.1744 14.1192 8.99533C15.0132 7.71021 15.069 6.31334 15.069 5.75459C15.069 4.13423 14.5103 2.96086 14.175 2.45799C13.8957 2.06687 13.6163 1.78749 13.4487 1.67574C12.2194 0.614124 10.7667 0.4465 9.2022 0.390625L1.15625 0.4465Z" fill="black" data-v-d02e5e9c></path><path d="M19.4282 11.1762C19.8194 9.83519 20.2664 8.49419 20.6575 7.1532C20.9368 6.20333 21.1603 5.25346 21.4397 4.30359L23.563 11.1762H19.4282ZM23.6188 0.448242H19.3724L13.3379 16.6519H17.6402L18.4225 14.0817H24.5128L25.2951 16.6519H29.5974L23.6188 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M34.9015 0.448242L38.4216 6.42683C39.2597 7.87957 40.0978 9.38819 40.88 10.8409L40.7124 0.448242H44.6237V16.6519H40.6565L37.6393 11.5114C37.1364 10.7292 36.6336 9.89106 36.1866 9.05294C35.6837 8.21482 35.2926 7.32083 34.7897 6.48271L34.9015 16.7078H30.9902V0.504117L34.9015 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M58.5433 0.448242V3.6331H54.3527V16.6519H50.2738V3.6331H46.0273V0.448242H58.5433Z" fill="black" data-v-d02e5e9c></path><path d="M70.7756 8.93897C70.7197 10.2241 70.3845 11.5092 69.4905 12.5149C68.4848 13.5766 67.1996 13.7442 66.6968 13.7442C65.6351 13.7442 64.6853 13.3531 63.9589 12.5708C63.2884 11.8445 62.6179 10.6711 62.6179 8.4361C62.6179 6.70398 63.1767 4.6925 64.797 3.7985C65.0764 3.63088 65.691 3.3515 66.585 3.3515C66.8644 3.3515 67.479 3.3515 68.1495 3.63088C69.0435 4.022 69.4905 4.58075 69.714 4.86012C70.2169 5.53061 70.8315 6.92748 70.7756 8.93897ZM71.7814 15.4763C73.7928 13.8559 74.8545 11.174 74.8545 8.71547C74.8545 6.48048 73.9605 3.85438 72.396 2.23401C71.5579 1.34002 69.6581 -0.000976562 66.585 -0.000976562C62.8414 -0.000976562 60.9417 2.06639 60.1036 3.29563C58.7067 5.36299 58.5391 7.70973 58.5391 8.54785C58.5391 9.49772 58.6508 12.5708 60.8858 14.9176C62.9532 17.0967 65.6351 17.2643 66.6409 17.2643C69.3229 17.1525 70.8874 16.2027 71.7814 15.4763Z" fill="black" data-v-d02e5e9c></path><path d="M80.7804 0.448242L84.3005 6.42683C85.1386 7.87957 85.9767 9.38819 86.759 10.8409L86.5913 0.448242H90.5026V16.6519H86.5355L83.5182 11.5114C83.0154 10.7292 82.5125 9.89106 82.0655 9.05294C81.5626 8.21482 81.1715 7.32083 80.6686 6.48271L80.7804 16.7078H76.8691V0.504117L80.7804 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M105.136 0.448242V3.57722H97.2019V6.53858H104.633V9.61169H97.2019V13.467H105.862V16.6519H93.123V0.448242H105.136Z" fill="black" data-v-d02e5e9c></path><path d="M109.269 2.90366V1.95379H109.884C110.108 1.95379 110.387 1.95379 110.499 2.17729C110.555 2.23317 110.555 2.34492 110.555 2.40079C110.555 2.45667 110.555 2.56841 110.499 2.62429C110.387 2.84779 110.219 2.84779 109.772 2.84779H109.269V2.90366ZM111.449 5.2504C111.281 4.91515 111.169 4.46815 111.169 4.3564C111.113 4.07703 111.113 3.68591 110.89 3.46241C110.834 3.40653 110.778 3.35066 110.61 3.29479C110.778 3.23891 110.778 3.23891 110.89 3.18304C111.002 3.12716 111.057 3.07129 111.113 2.95954C111.225 2.84779 111.337 2.68016 111.337 2.34492C111.337 2.23317 111.337 1.95379 111.113 1.67442C110.778 1.2833 110.219 1.2833 109.772 1.2833H108.431V5.19452H109.269V3.51828H109.493C109.772 3.51828 109.884 3.51828 109.996 3.63003C110.163 3.74178 110.219 3.85353 110.275 4.24465C110.331 4.52403 110.331 4.85928 110.443 5.13865C110.443 5.19452 110.499 5.19452 110.499 5.2504H111.449ZM112.901 3.29479C112.901 2.62429 112.734 1.95379 112.287 1.45092C111.672 0.668677 110.778 0.22168 109.828 0.22168C108.543 0.22168 107.761 0.94805 107.426 1.33917C107.202 1.61855 106.699 2.28904 106.699 3.29479C106.699 4.63578 107.481 5.41802 107.873 5.75327C108.431 6.14439 109.102 6.36789 109.772 6.36789C110.219 6.36789 111.281 6.25614 112.119 5.30627C112.845 4.52403 112.901 3.68591 112.901 3.29479ZM112.622 3.29479C112.622 4.46815 111.896 5.52977 110.778 5.92089C110.331 6.08852 109.996 6.08852 109.828 6.08852C108.711 6.08852 107.649 5.41802 107.202 4.3564C107.09 4.02116 106.979 3.68591 106.979 3.29479C106.979 2.00967 107.761 1.2833 108.152 1.00392C108.822 0.501053 109.493 0.445178 109.828 0.445178C111.113 0.445178 111.784 1.17155 112.063 1.56267C112.566 2.28904 112.622 3.01541 112.622 3.29479Z" fill="black" data-v-d02e5e9c></path></svg></div>', 1)), S("div", XD, [d[2] || (d[2] = S("svg", {
            xmlns: "http://www.w3.org/2000/svg",
            width: "21",
            height: "20",
            viewBox: "0 0 21 20",
            fill: "none"
          }, [S("path", {
            d: "M10.3125 2.5C14.4546 2.5 17.8125 5.85787 17.8125 10C17.8125 14.1421 14.4546 17.5 10.3125 17.5C6.17036 17.5 2.8125 14.1421 2.8125 10C2.8125 5.85787 6.17036 2.5 10.3125 2.5Z",
            stroke: "#222222",
            "stroke-width": "1.15625",
            "stroke-miterlimit": "10"
          }), S("path", {
            d: "M10.3125 13.75V9.375",
            stroke: "#222222",
            "stroke-width": "1.41063",
            "stroke-linecap": "round",
            "stroke-linejoin": "round"
          }), S("path", {
            d: "M10.3125 5.625C10.8303 5.625 11.25 6.04473 11.25 6.5625C11.25 7.08027 10.8303 7.5 10.3125 7.5C9.79473 7.5 9.375 7.08027 9.375 6.5625C9.375 6.04473 9.79473 5.625 10.3125 5.625Z",
            fill: "#222222"
          })], -1)), S("div", JD, [S("p", ZD, j(T(x)("팬톤검색안내")), 1)])])]), S("span", eP, j(r.value ? r.value.pantone_name.replace("PANTONE ", "") : "PANTONE#"), 1)])]), S("div", tP, [S("form", {
            onSubmit: br(c, ["prevent"])
          }, [de(S("input", {
            "onUpdate:modelValue": d[1] || (d[1] = f => i.value = f),
            type: "text",
            name: "pantone",
            placeholder: T(x)("넘버 입력"),
            "data-gtm-form-interact-field-id": "0"
          }, null, 8, nP), [
            [yt, i.value]
          ]), d[4] || (d[4] = S("button", {
            type: "submit",
            class: "search-btn"
          }, null, -1))], 32), S("p", oP, j(T(x)("팬톤검색문구")), 1)]), S("button", {
            type: "button",
            class: "confirm-btn",
            disabled: !r.value,
            onClick: a
          }, j(T(x)("적용하기")), 9, sP)])])])])
        }
      }
    }), [
      ["__scopeId", "data-v-d02e5e9c"]
    ]),
    iP = {
      class: "special-option"
    },
    aP = ["src"],
    lP = {
      class: "text"
    },
    uP = {
      class: "desc"
    },
    cP = {
      class: "detail"
    },
    dP = {
      class: "detail-subject"
    },
    fP = {
      class: "detail-value"
    },
    pP = re({
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
          s = le("callbacks", {}),
          r = le("deviceType", "pc"),
          a = Ve(),
          i = H(!1),
          l = () => i.value = !i.value,
          c = H(null),
          u = f => {
            c.value = f, r === "pc" && !s.onSetPantone && l()
          },
          d = () => {
            s.onSetPantone ? s.onSetPantone({
              options: [...n.options],
              setter: u
            }) : l()
          },
          h = () => {
            s?.onReset && s.onReset("printColor")
          };
        return F(() => c.value, f => {
          if (!f) return;
          a.isAfterEdit() && h();
          const {
            pantone_name: _
          } = f, p = _.replace("PANTONE ", "");
          o("update", {
            ...f,
            pantone_code: p
          })
        }), (f, _) => (g(), M(J, null, [K(fe, {
          title: "인쇄 컬러(팬톤)"
        }, {
          default: ce(() => [S("div", iP, [S("figure", null, [S("img", {
            src: `${T(qe)}/ko/item/page-order-clothes-pantone.png`,
            alt: "팬톤 컬러 이미지"
          }, null, 8, aP), S("p", lP, j(T(x)("팬톤 컬러")), 1)]), S("div", uP, [S("div", cP, [S("p", dP, j(T(x)("1종 선택 가능")), 1), S("span", fP, j(c.value?.pantone_name || "PANTONE"), 1)]), S("button", {
            type: "button",
            onClick: d
          }, j(T(x)("팬톤 컬러 선택하기")), 1)])])]),
          _: 1
        }), i.value ? (g(), V(rP, {
          key: 0,
          options: f.options,
          selected: c.value,
          onClose: l,
          onSelect: u
        }, null, 8, ["options", "selected"])) : oe("", !0)], 64))
      }
    }),
    ih = re({
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
        return F(() => s.value, r => {
          const {
            PCS_CD: a,
            PCS_GRP_NM: i,
            PCS_DTL_CD: l,
            PCS_DTL_NM: c,
            VIEW_YN: u,
            ESN_YN: d
          } = n.detail;
          o("update", r === "Y" ? [{
            PCS_CD: a,
            PCS_GRP_NM: i,
            VIEW_YN: u,
            ESN_YN: d,
            selectedOptions: [{
              PCS_CD: a,
              PCS_DTL_CD: l,
              PCS_DTL_NM: c
            }]
          }] : [])
        }, {
          immediate: !0
        }), (r, a) => (g(), V(fe, {
          title: "개별 포장"
        }, {
          default: ce(() => [K(Dn, {
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
            onChange: a[0] || (a[0] = i => s.value = i.value)
          }, null, 8, ["default-checked"])]),
          _: 1
        }))
      }
    }),
    _P = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: ih
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    hP = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = R(() => n.widgetAttr.skinInfo),
            r = le("member"),
            a = R(() => c.value.clothesSelectData?.printType),
            i = R(() => a.value?.PRINT_GBN === "N" ? "single" : a.value?.COD === "PTP_SLK" ? "multi" : "single"),
            {
              uploadConfig: l
            } = Wr(n.widgetAttr),
            {
              orderInfo: c,
              updateOption: u,
              updatePcsOption: d
            } = qr(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: b => o("update", b)
              }
            }),
            h = R(() => c.value.clothesSelectData?.colorInfo?.COD),
            f = R(() => n.data.apparel_info?.size_info.reduce((b, C) => (b[C.COD] = C, b), {})),
            _ = R(() => {
              if (h.value) return n.data.apparel_info?.size_color_info.filter(b => b.CLR_COD === h.value)
            }),
            p = xe({}),
            m = H(null),
            v = R(() => m.value?.reduce((b, C) => (b[C.size.MTRL_COD] = C, b), {}));
          F(() => m.value, b => {
            if (!b) return;
            u("sizeInfo", !0)(b);
            const C = n.data.pdt_mtrl_info.filter(y => y.MTRL_CD === b[0]?.size.MTRL_COD);
            if (C.length > 0) {
              const {
                PTT_CD: y,
                PTT_NM: I,
                WGT_CD: w,
                CLR_CD: U,
                MTRL_CD: Z,
                MTRL_NM: me,
                MTRL_TYPE: _e,
                PRT_HIDE_YN: B
              } = C[0];
              u("meterialInfo")({
                PTT_CD: y,
                PTT_NM: I,
                WGT_CD: w,
                CLR_CD: U,
                MTRL_CD: Z,
                MTRL_NM: me,
                MTRL_TYPE: _e,
                PRT_HIDE_YN: B
              })
            }
          }), F(() => v.value, b => {
            if (!b) return;
            const C = n.data.pdt_pcs_info.filter(y => y.PCS_CD === "DIR_MTR" && y.MTRL_CD && b[y.MTRL_CD]).map(y => {
              const {
                PCS_CD: I,
                PCS_DTL_CD: w,
                PCS_DTL_NM: U,
                VIEW_YN: Z,
                MTRL_CD: me,
                ESN_YN: _e,
                DIV_SEQ: B
              } = y, W = [{
                PCS_CD: I,
                PCS_DTL_CD: w,
                PCS_DTL_NM: U,
                ATTB: b[me || ""].quantity
              }];
              return {
                PCS_CD: I,
                VIEW_YN: Z,
                ESN_YN: _e,
                DIV_SEQ: B,
                active: !1,
                selectedOptions: W
              }
            });
            p.DIR_MTR = C
          });
          const E = H(null),
            k = R(() => n.data.pdt_pcs_info.reduce((b, C) => (C.PCS_CD === "PDT_WRK" && (b[C.PCS_DTL_CD] = C), b), {}));
          F(() => E.value, b => {
            u("PrintAreaInfo", !0)(b);
            const C = b ? b?.map(y => {
              const I = k.value[y.COD],
                {
                  PCS_CD: w,
                  PCS_DTL_CD: U,
                  PCS_DTL_NM: Z,
                  VIEW_YN: me,
                  ESN_YN: _e
                } = I,
                B = [{
                  PCS_CD: w,
                  PCS_DTL_CD: U,
                  PCS_DTL_NM: Z,
                  KOI_NME: y.KOI_NME
                }];
              return {
                PCS_CD: w,
                VIEW_YN: me,
                ESN_YN: _e,
                active: !0,
                selectedOptions: B
              }
            }) : [];
            p.PDT_WRK = C
          });
          const N = R(() => n.data.pdt_pcs_info.find(b => b.PCS_CD === "PAK_POL"));
          F(() => p, b => {
            d("POST_PCS")(Object.values(b).flatMap(C => C))
          }, {
            deep: !0
          }), F(() => n.data.pdt_size_info, b => {
            if (!b || !b[0]) return;
            const C = {
              DIV_NM: b[0].DIV_NM || "",
              DIV_SEQ: b[0].DIV_SEQ,
              DivInfo: {},
              cutSize: {
                width: +b[0].CUT_WDT,
                height: +b[0].CUT_HGH
              },
              workSize: {
                width: +b[0].WRK_WDT,
                height: +b[0].WRK_HGH
              }
            };
            u("sizeInfo")(C)
          }, {
            immediate: !0,
            once: !0
          });
          const D = le("callbacks", {}),
            O = Ve(),
            A = () => {
              D?.onReset && D.onReset("fileUpload")
            };
          return F(() => a.value, b => {
            b.PRINT_GBN === "N" && (c.value.fileUploadInfo && c.value.fileUploadInfo[0] && (u("fileUploadInfo")([null]), A()), O.editorData.default && A())
          }), (b, C) => (g(), M(J, null, [b.data.apparel_info?.print_type ? (g(), V(JS, {
            key: 0,
            options: b.data.apparel_info?.print_type,
            "dosu-options": b.data.pdt_dosu_info,
            "related-data": {
              color: h.value
            },
            "onUpdate:type": C[0] || (C[0] = y => T(u)("printType", !0)(y)),
            "onUpdate:dosu": C[1] || (C[1] = y => T(u)("dosuInfo")(y))
          }, null, 8, ["options", "dosu-options", "related-data"])) : oe("", !0), b.data.apparel_info?.apparel_color ? (g(), V(uD, {
            key: 1,
            options: b.data.apparel_info.apparel_color,
            onUpdate: C[2] || (C[2] = y => T(u)("colorInfo", !0)(y))
          }, null, 8, ["options"])) : oe("", !0), _.value && i.value === "single" && f.value ? (g(), V(bD, {
            key: 2,
            options: _.value,
            "size-info": f.value,
            "onUpdate:qty": C[3] || (C[3] = y => T(u)("quantityInfo")(y)),
            "onUpdate:combinations": C[4] || (C[4] = y => m.value = y)
          }, null, 8, ["options", "size-info"])) : oe("", !0), _.value && i.value === "multi" && f.value ? (g(), V(AD, {
            key: 3,
            options: _.value,
            "size-info": f.value,
            "onUpdate:qty": C[5] || (C[5] = y => T(u)("quantityInfo")(y)),
            "onUpdate:combinations": C[6] || (C[6] = y => m.value = y)
          }, null, 8, ["options", "size-info"])) : oe("", !0), b.data.apparel_info?.print_area ? (g(), V(hD, {
            key: 4,
            options: b.data.apparel_info.print_area,
            "related-data": {
              printType: a.value
            },
            onUpdate: C[7] || (C[7] = y => E.value = y)
          }, null, 8, ["options", "related-data"])) : oe("", !0), b.data.apparel_info?.pantone_color && T(c).clothesSelectData?.printType?.COD === "PTP_SLK" ? (g(), V(pP, {
            key: 5,
            options: b.data.apparel_info.pantone_color,
            onUpdate: C[8] || (C[8] = y => T(u)("pantoneInfo", !0)(y))
          }, null, 8, ["options"])) : oe("", !0), s.value.subjectGroup.view_yn === "Y" ? (g(), V(X_, {
            key: 6,
            "is-biz-mem": T(r)?.bsn_yn === "Y",
            onUpdate: C[9] || (C[9] = y => T(u)("etcInfo")(y))
          }, null, 8, ["is-biz-mem"])) : oe("", !0), N.value ? (g(), V(ih, {
            key: 7,
            detail: N.value,
            onUpdate: C[10] || (C[10] = y => p.PAK_POL = y)
          }, null, 8, ["detail"])) : oe("", !0), a.value?.PRINT_GBN === "Y" && b.widgetAttr.order_yn !== "N" ? (g(), V(ks, {
            key: 8,
            "upload-config": T(l),
            "show-extra": b.widgetAttr.useTemplateDownload === "Y" && b.widgetAttr.usePDF === "Y",
            "related-data": {
              apparel: {
                printType: a.value?.COD,
                pantone: T(c).clothesSelectData.pantoneInfo?.hex_cod
              }
            },
            onUpload: C[11] || (C[11] = y => T(u)("fileUploadInfo")(y))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : oe("", !0)], 64))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    mP = {
      class: "flex-row -center"
    },
    vP = ["id"],
    gP = ["name"],
    yP = ["value"],
    CP = {
      key: 0,
      class: "notes"
    },
    TP = {
      key: 0,
      class: "note"
    },
    bP = {
      key: 1,
      class: "note"
    },
    SP = {
      key: 1,
      class: "notes"
    },
    DP = {
      class: "note"
    },
    PP = {
      class: "note"
    },
    Xl = Be(re({
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
          s = le("productCode", {
            pdtCode: ""
          }),
          r = R(() => s.pdtCode[4] === "O"),
          a = R(() => n.options[0]),
          i = R(() => n.type === "default" ? a.value.INC_CNT : a.value.STEP_INN_PAGE),
          l = R(() => n.type === "default" && a.value.FIR_CNT === 2),
          c = R(() => n.type === "default" ? a.value.MIN_PRN_CNT : a.value.MIN_INN_PAGE),
          u = R(() => n.type === "default" ? null : a.value.MAX_INN_PAGE),
          d = H(c.value),
          h = R(() => !!(c.value > d.value || u.value && u.value < d.value));
        F(() => d.value, E => {
          h.value || o("update", n.type, E)
        }, {
          immediate: !0
        });
        const f = R(() => {
            const E = n.relatedData?.dosu === "SID_D" ? 2 : 1;
            return (d.value * E).toLocaleString()
          }),
          _ = () => {
            if (c.value > d.value) return d.value = c.value;
            if (u.value && u.value < d.value) return d.value = u.value;
            if (n.type === "default" && l.value) {
              const E = d.value % 2;
              if (E > 0) return d.value = d.value + E
            }
            if (n.type === "inner" && i.value === 2) {
              const E = d.value % 2;
              if (E > 0) return d.value = d.value + E
            }
          },
          p = R(() => {
            const E = [],
              k = i.value > c.value ? i.value : c.value,
              N = i.value > c.value ? 10 : 9,
              D = u.value ?? i.value * N + c.value;
            for (let O = k; O <= D; O += i.value) O === i.value && i.value > c.value && E.push({
              value: c.value
            }), E.push({
              value: O
            });
            return E
          }),
          m = H("select"),
          v = () => {
            m.value = m.value === "input" ? "select" : "input"
          };
        return (E, k) => {
          const N = on("dompurify-html");
          return g(), V(fe, {
            title: E.type === "default" ? T(x)("수량") : T(x)("내지장수")
          }, {
            default: ce(() => [S("div", mP, [m.value === "input" ? de((g(), M("input", {
              key: 0,
              "onUpdate:modelValue": k[0] || (k[0] = D => d.value = D),
              type: "number",
              class: we(["basic-input", "-fixed-w"]),
              id: E.type === "default" ? "QTY" : "INNER_QTY",
              onFocusout: _
            }, null, 40, vP)), [
              [yt, d.value]
            ]) : de((g(), M("select", {
              key: 1,
              "onUpdate:modelValue": k[1] || (k[1] = D => d.value = D),
              name: E.type === "default" ? "QTY" : "INNER_QTY",
              class: "basic-select -fixed-w"
            }, [(g(!0), M(J, null, he(p.value, D => (g(), M("option", {
              value: D.value,
              key: D.value
            }, j(D.value), 9, yP))), 128))], 8, gP)), [
              [We, d.value]
            ]), S("button", {
              type: "button",
              class: "action-btn",
              onClick: v
            }, j(m.value === "input" ? T(x)("수량선택") : T(x)("직접입력")), 1)]), E.type === "default" ? (g(), M("div", CP, [r.value ? de((g(), M("p", bP, null, 512)), [
              [N, T(x)(l.value ? "토너책자최소수량안내-짝수" : "토너책자최소수량안내").replace("{MIN_CNT}", `${c.value}`)]
            ]) : de((g(), M("p", TP, null, 512)), [
              [N, T(x)("윤전책자최소수량안내").replace("{MIN_CNT}", `${c.value}`)]
            ])])) : (g(), M("div", SP, [de(S("p", DP, null, 512), [
              [N, T(x)("내지장수안내").replace("{QTY}", `${f.value}`)]
            ]), de(S("p", PP, null, 512), [
              [N, T(x)("내지최대장수안내").replace("{MAX_CNT}", `${u.value}`)]
            ])]))]),
            _: 1
          }, 8, ["title"])
        }
      }
    }), [
      ["__scopeId", "data-v-106e3545"]
    ]),
    EP = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Xl
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    OP = {
      class: "flex-row"
    },
    IP = ["value"],
    RP = ["value"],
    ah = re({
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
          s = le("callbacks", {}),
          r = Ve(),
          a = R(() => n.options.all.length > n.options.dosu.length),
          i = H(n.options.dosu[0].COD),
          l = H(n.options.color[0].COD),
          c = R(() => n.options.all.find(d => d.BNC_GB === l.value && d.COD === i.value)),
          u = () => {
            s?.onReset && s.onReset("dosu")
          };
        return F(() => c.value, d => {
          d && (r.isAfterEdit() && u(), o("update", d))
        }, {
          immediate: !0
        }), (d, h) => (g(), V(fe, {
          title: "인쇄도수"
        }, {
          default: ce(() => [S("div", OP, [de(S("select", {
            "onUpdate:modelValue": h[0] || (h[0] = f => i.value = f),
            name: "dosu",
            class: "basic-select"
          }, [(g(!0), M(J, null, he(d.options.dosu, f => (g(), M("option", {
            key: f.COD,
            value: f.COD
          }, j(f.COD_NME), 9, IP))), 128))], 512), [
            [We, i.value]
          ]), a.value ? de((g(), M("select", {
            key: 0,
            "onUpdate:modelValue": h[1] || (h[1] = f => l.value = f),
            name: "dosu-color",
            class: "basic-select"
          }, [(g(!0), M(J, null, he(d.options.color, f => (g(), M("option", {
            key: f.COD,
            value: f.COD
          }, j(f.COD_NME), 9, RP))), 128))], 512)), [
            [We, l.value]
          ]) : oe("", !0)])]),
          _: 1
        }))
      }
    }),
    wP = {
      class: "flex-row"
    },
    AP = ["value", "disabled"],
    NP = ["value", "disabled"],
    Jl = re({
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
        }
      },
      emits: ["update"],
      setup(e, {
        emit: t
      }) {
        const n = e,
          o = t,
          s = le("callbacks", {}),
          r = le("productCode", {
            pdtCode: ""
          }),
          a = Dt(),
          i = R(() => {
            const p = [];
            return p.length > 0 ? p : n.options
          }),
          l = R(() => i.value.filter(p => p.HIDE_YN !== "Y")),
          c = R(() => {
            const p = new Map;
            return i.value.forEach(m => {
              const {
                WGT_CD: v,
                MTRL_CD: E,
                PTT_CD: k,
                PTT_NM: N,
                BSN_YN: D,
                HIDE_YN: O,
                HIDE_RSN: A
              } = m, b = p.get(k), C = {
                WGT_CD: v,
                MTRL_CD: E,
                HIDE_YN: O,
                HIDE_RSN: A
              };
              if (b) b.weights.push(C);
              else {
                const y = {
                  PTT_CD: k,
                  PTT_NM: N,
                  BSN_YN: D,
                  weights: [C]
                };
                p.set(k, y)
              }
            }), p
          }),
          u = async () => {
            const p = await Nl({
              pdt_cod: r.pdtCode,
              lang: a.locale
            });
            if (!p) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
            s?.onInformMaterials ? s.onInformMaterials(p) : console.log("[RedWidgetSDK] 용지 정보 >", p)
          }, d = () => {
            n.resetAfterEdit && s?.onReset && s.onReset("mtrl")
          }, h = p => p.every(m => m.HIDE_YN === "Y"), f = H(n.default?.PTT_CD || l.value[0]?.PTT_CD), _ = H(n.default?.MTRL_CD || l.value[0]?.MTRL_CD);
        return F(() => f.value, p => {
          const m = c.value.get(p);
          if (m) {
            const v = m.weights.find(E => E.HIDE_YN !== "Y");
            v && (_.value = v.MTRL_CD)
          }
          p === "OOO" && s?.onSaleOrder && s?.onSaleOrder()
        }, {
          immediate: !0
        }), F(() => _.value, p => {
          const m = l.value.find(v => v.MTRL_CD === p);
          if (m) {
            const {
              PTT_CD: v,
              PTT_NM: E,
              WGT_CD: k,
              CLR_CD: N,
              MTRL_CD: D,
              MTRL_NM: O,
              MTRL_TYPE: A,
              PRT_HIDE_YN: b,
              SID_GBN: C
            } = m;
            o("update", {
              PTT_CD: v,
              PTT_NM: E,
              WGT_CD: k,
              CLR_CD: N,
              MTRL_CD: D,
              MTRL_NM: O,
              MTRL_TYPE: A,
              PRT_HIDE_YN: b,
              SID_GBN: C
            })
          }
        }, {
          immediate: !0
        }), (p, m) => (g(), V(fe, {
          title: "용지",
          extra: p.showExtra ? {
            name: "주문가능자재",
            callback: u
          } : null
        }, {
          default: ce(() => [S("div", wP, [de(S("select", {
            "onUpdate:modelValue": m[0] || (m[0] = v => f.value = v),
            class: "basic-select",
            name: "paper"
          }, [(g(!0), M(J, null, he(c.value.values(), v => (g(), M("option", {
            key: v.PTT_CD,
            value: v.PTT_CD,
            disabled: h(v.weights),
            onChange: d
          }, j(h(v.weights) ? `[${v.weights[0].HIDE_RSN||"주문불가"}]` : "") + " " + j(v.PTT_NM) + " " + j(v.BSN_YN === "Y" ? "[영업주문]" : ""), 41, AP))), 128))], 512), [
            [We, f.value]
          ]), de(S("select", {
            "onUpdate:modelValue": m[1] || (m[1] = v => _.value = v),
            class: "basic-select",
            name: "weight"
          }, [(g(!0), M(J, null, he(c.value.get(f.value)?.weights, v => (g(), M("option", {
            key: `${v.MTRL_CD}`,
            value: v.MTRL_CD,
            disabled: v.HIDE_YN === "Y"
          }, j(v.HIDE_YN === "Y" ? `[${v.HIDE_RSN||"주문불가"}]` : "") + " " + j(`${v.WGT_CD}g`), 9, NP))), 128))], 512), [
            [We, _.value]
          ])])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    MP = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Jl
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    kP = {
      class: "special-option"
    },
    LP = ["src"],
    $P = {
      class: "text"
    },
    xP = {
      class: "desc"
    },
    FP = {
      key: 0,
      class: "detail"
    },
    UP = {
      class: "detail-subject"
    },
    BP = {
      class: "detail-value"
    },
    VP = {
      key: 1,
      class: "detail"
    },
    HP = {
      class: "detail-subject"
    },
    GP = {
      class: "detail-value"
    },
    jP = Be(re({
      __name: "CoverGuide",
      props: {
        sizeInfo: {},
        senecaInfo: {}
      },
      setup(e) {
        const t = e,
          n = le("productCode", {
            pdtCode: ""
          }),
          o = le("callbacks", {}),
          s = H(t.senecaInfo);
        F(() => t.senecaInfo, f => {
          f && (s.value = f)
        });
        const r = zr(),
          a = Dt(),
          i = async () => {
            const f = r.getOrderData();
            if (!f) return;
            const _ = dS(f);
            if (!_ || typeof _ == "string") return alert(x(_ || "템플릿다운로드실패"));
            await BT({
              lang: a.locale,
              ..._
            }) || alert(x("템플릿다운로드실패"))
          }, l = {
            PRBKYPB: !0,
            PRBKYCB: !0,
            PRBKYRB: !0,
            PRBKOPB: !0,
            PRBKOCB: !0,
            PRBKORB: !0
          }, c = {
            PRBKYPR: !0,
            PRBKOPR: !0,
            PRBKYPB: !0,
            PRBKOPB: !0
          }, u = {
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
          }, d = {
            PRBKYST: !0,
            PRBKYSL: !0,
            PRBKOST: !0,
            PRBKOSL: !0
          }, h = R(() => {
            if (!t.sizeInfo) return null;
            if (d[n.pdtCode]) return {
              title: "소프트커버",
              imgSrc: `${qe}/ko/cover_icon_stapler.png`
            };
            const _ = t.sizeInfo.workSize.width > t.sizeInfo.workSize.height ? J_.has(n.pdtCode) ? "_wh" : "_w" : "_h",
              p = l[n.pdtCode] ? "_black" : "";
            return c[n.pdtCode] ? {
              title: "세네카",
              imgSrc: `${qe}/ko/cover_icon_wireless${p}${_}.png`
            } : u[n.pdtCode] ? {
              title: "낱장커버",
              imgSrc: `${qe}/ko/cover_icon_spring${p}${_}.png`
            } : null
          });
        return (f, _) => (g(), V(fe, {
          title: "표지가이드",
          extra: {
            name: "가이드보기",
            callback: () => {
              T(o)?.onInformGuide && T(o).onInformGuide("bookCover")
            }
          }
        }, {
          default: ce(() => [S("div", kP, [S("figure", null, [S("img", {
            src: h.value?.imgSrc
          }, null, 8, LP), S("figcaption", $P, j(T(x)(h.value?.title || "")), 1)]), S("div", xP, [s.value?.seneca_show === "Y" ? (g(), M("div", FP, [S("p", UP, j(T(x)("세네카")), 1), S("span", BP, [S("b", null, j(s.value?.seneca), 1), _[0] || (_[0] = Po(" mm ", -1))])])) : (g(), M("div", VP, [S("p", HP, j(T(x)("표지작업사이즈")), 1), S("span", GP, [S("b", null, j(f.sizeInfo?.workSize.width) + "x" + j(f.sizeInfo?.workSize.height), 1), _[1] || (_[1] = Po(" mm ", -1))])])), S("button", {
            type: "button",
            class: "download-btn",
            onClick: i
          }, j(T(x)("표지템플릿다운로드")), 1)])])]),
          _: 1
        }, 8, ["extra"]))
      }
    }), [
      ["__scopeId", "data-v-7f08ebe2"]
    ]),
    zP = {
      class: "group-title"
    },
    YP = {
      class: "subject"
    },
    KP = {
      class: "group-title"
    },
    WP = {
      class: "subject"
    },
    qP = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            s = R(() => n.widgetAttr.skinInfo),
            {
              defaultOrderData: r,
              orderInfo: a,
              updateOption: i,
              updatePostPcs: l
            } = qr(n.type, {
              group: n.widgetAttr.item_gbn,
              emits: {
                updateOrder: O => o("update", O)
              }
            }),
            c = R(() => !!a.value.pcsInfo?.find(O => O.PCS_CD === "SCO_DFT")),
            u = H({
              ordCnt: 0,
              prnCnt: 0
            }),
            d = (O, A) => {
              O === "default" && (u.value = {
                ...u.value,
                ordCnt: A
              }), O === "inner" && (u.value = {
                ...u.value,
                prnCnt: A
              })
            };
          F(() => u.value, un(O => {
            i("quantityInfo")(O)
          }, 200), {
            immediate: !0
          });
          const h = le("member"),
            f = R(() => h?.bsn_yn === "Y" ? n.data.pdt_mtrl_info : n.data.pdt_mtrl_info.filter(O => O.BSN_YN !== "Y")),
            _ = R(() => h?.bsn_yn === "Y" ? n.data.inner_pdt_mtrl_info : n.data.inner_pdt_mtrl_info?.filter(O => O.BSN_YN !== "Y")),
            p = R(() => a.value?.pcsInfo?.find(O => O.PCS_CD === "BIND_DIRECTION")),
            {
              uploadConfig: m
            } = Wr(n.widgetAttr),
            v = R(() => a.value.dosuInfo?.BNC_GB === "BNC_BLA" ? {
              pdf: !0,
              editor: null
            } : m.value),
            E = H([]),
            k = O => A => {
              const b = A[0];
              O === "inner" && (E.value = [b, E.value[1]]), O === "default" && (E.value = [E.value[0], b])
            };
          F(() => E.value, O => {
            i("fileUploadInfo")(O)
          });
          const N = R(() => Ql(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)),
            D = R(() => Ll[n.data.pdt_base_info[0].PDT_CD] ? a.value.quantityInfo?.prnCnt || 1 : (a.value.quantityInfo?.ordCnt || 1) * (a.value.quantityInfo?.prnCnt || 1));
          return (O, A) => (g(), M(J, null, [de(K(Bl, {
            options: O.data.pdt_size_info,
            "base-info": O.data.pdt_base_info[0],
            default: T(r)?.size,
            "hidden-sizes": !0,
            "show-extra": !0,
            onUpdate: A[0] || (A[0] = b => T(i)("sizeInfo")(b)),
            onValidate: A[1] || (A[1] = b => T(i)("validation")(b))
          }, null, 8, ["options", "base-info", "default"]), [
            [Kt, s.value.sizeSelect.view_yn === "Y"]
          ]), K(Xl, {
            type: "default",
            options: O.data.pdt_prn_cnt_info,
            onUpdate: d
          }, null, 8, ["options"]), S("div", zP, [S("span", YP, j(T(x)("내지")), 1)]), de(K(ah, {
            options: {
              dosu: O.data.inner_pdt_dosu_info,
              color: O.data.inner_pdt_bnc_info,
              all: O.data.inner_pdt_dosu_bnc_info
            },
            onUpdate: A[2] || (A[2] = b => T(i)("inner_dosuInfo")(b))
          }, null, 8, ["options"]), [
            [Kt, s.value.dosuSelect.view_yn === "Y" && O.data.inner_pdt_dosu_bnc_info]
          ]), K(Jl, {
            options: _.value,
            "show-extra": O.widgetAttr.able_paper_yn === "Y",
            onUpdate: A[3] || (A[3] = b => T(i)("inner_meterialInfo")(b))
          }, null, 8, ["options", "show-extra"]), K(Xl, {
            type: "inner",
            options: O.data.pdt_prn_cnt_info,
            "related-data": {
              dosu: T(a).inner_dosuInfo?.COD
            },
            onUpdate: d
          }, null, 8, ["options", "related-data"]), O.widgetAttr.order_yn !== "N" ? (g(), V(ks, {
            key: 0,
            _key: "inner",
            "upload-config": {
              pdf: !0,
              editor: null
            },
            subject: "내지업로드",
            notes: [T(x)("내지업로드사이즈장수안내", {
              CUT_SIZE: `${T(a).sizeInfo?.cutSize.width}x${T(a).sizeInfo?.cutSize.height}`,
              WRK_SIZE: `${T(a).sizeInfo?.workSize.width}x${T(a).sizeInfo?.workSize.height}`,
              QTY: `${T(a).quantityInfo?.prnCnt*(T(a).inner_dosuInfo?.COD==="SID_D"?2:1)}`
            })],
            onUpload: A[4] || (A[4] = b => k("inner")(b))
          }, null, 8, ["notes"])) : oe("", !0), S("div", KP, [S("span", WP, j(T(x)("표지")), 1)]), de(K(ah, {
            options: {
              dosu: O.data.pdt_dosu_info,
              color: O.data.pdt_bnc_info,
              all: O.data.pdt_dosu_bnc_info
            },
            onUpdate: A[5] || (A[5] = b => T(i)("dosuInfo")(b))
          }, null, 8, ["options"]), [
            [Kt, s.value.dosuSelect.view_yn === "Y" && O.data.pdt_dosu_info]
          ]), de(K(Jl, {
            options: f.value,
            "show-extra": O.widgetAttr.able_paper_yn === "Y",
            onUpdate: A[6] || (A[6] = b => T(i)("meterialInfo")(b))
          }, null, 8, ["options", "show-extra"]), [
            [Kt, f.value.length > 1]
          ]), K(jP, {
            "size-info": T(a).sizeInfo,
            "seneca-info": O.senecaInfo
          }, null, 8, ["size-info", "seneca-info"]), K(Vl, {
            options: N.value.postPcs.hidden,
            "related-data": {
              mtrlCd: T(a).meterialInfo?.MTRL_CD,
              sizeInfo: T(a).sizeInfo,
              orderQty: D.value,
              bindDirection: p.value
            },
            onUpdate: A[7] || (A[7] = b => T(l)("hidden")(b))
          }, null, 8, ["options", "related-data"]), K(Yl, {
            options: N.value.postPcs.visible,
            "disabled-opts": N.value.disabled,
            "attb-opts": O.data.pdt_add_info[1],
            "related-data": {
              mtrlCd: T(a).meterialInfo?.MTRL_CD,
              sizeInfo: T(a).sizeInfo
            },
            onUpdate: A[8] || (A[8] = b => T(l)("visible")(b))
          }, null, 8, ["options", "disabled-opts", "attb-opts", "related-data"]), O.widgetAttr.order_yn !== "N" ? (g(), V(ks, {
            key: 1,
            _key: "default",
            "upload-config": v.value,
            subject: "표지업로드",
            notes: [T(x)("표지업로드장수안내", {
              QTY: `${T(a).dosuInfo?.COD==="SID_D"?2:1}`
            })],
            "related-data": {
              hasScodix: c.value
            },
            onUpload: A[9] || (A[9] = b => k("default")(b))
          }, null, 8, ["upload-config", "notes", "related-data"])) : oe("", !0)], 64))
        }
      }), [
        ["__scopeId", "data-v-51f6d81b"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    QP = {
      key: 2,
      class: "summary"
    },
    XP = {
      class: "name"
    },
    JP = {
      class: "qty-price"
    },
    ZP = {
      class: "counter"
    },
    eE = ["onClick"],
    tE = ["value", "onChange"],
    nE = ["onClick"],
    oE = {
      class: "price-box"
    },
    sE = {
      class: "price"
    },
    rE = ["onClick"],
    iE = {
      key: 1
    },
    aE = {
      class: "qty-price"
    },
    lE = {
      class: "price-box"
    },
    uE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = le("callbacks", {}),
            a = R(() => K_[s.pdtCode] ? K_[s.pdtCode][s.pttCode || ""] : null),
            i = H("X"),
            l = H("X"),
            c = H("X"),
            u = xe({}),
            d = xe({});
          F(() => i.value, () => {
            c.value = "X"
          });
          const h = {
              key: "X",
              value: "X",
              name: x("선택하기")
            },
            f = () => {
              i.value = "X", l.value = "X", c.value = "X"
            },
            _ = R(() => n.data.reduce((y, I) => (y[I.MTRL_GRP_GB] || (y[I.MTRL_GRP_GB] = []), y[I.MTRL_GRP_GB].push(I), y), {})),
            p = y => {
              const I = [h];
              return y ? y.GRP_TYPE === "MTRL_MULTI_GRP" ? (_.value[y.GRP_COD].forEach(w => {
                I.push({
                  key: w.MTRL_CD,
                  value: w.MTRL_CD,
                  name: w.MTRL_NM,
                  disabled: w.HIDE_YN === "Y"
                })
              }), I) : y.options ? (y.options.forEach(w => {
                I.push({
                  key: w.COD,
                  value: w.COD,
                  name: x(w.COD_NME)
                })
              }), I) : (i.value !== "X" && _.value[i.value].forEach(w => {
                I.push({
                  key: w.MTRL_CD,
                  value: w.MTRL_CD,
                  name: w.MTRL_NM,
                  disabled: w.HIDE_YN === "Y"
                })
              }), I) : (n.data.forEach(w => {
                I.push({
                  key: w.MTRL_CD,
                  value: w.MTRL_CD,
                  name: w.MTRL_NM,
                  disabled: w.HIDE_YN === "Y"
                })
              }), I)
            };

          function m(y) {
            return r?.onCallMsg ? r.onCallMsg("warn", y) : alert(y)
          }

          function v(y) {
            y && (d[y.MTRL_CD] ? d[y.MTRL_CD].QTY += y.INC_STEP : d[y.MTRL_CD] = {
              ...y,
              QTY: y.FIR_CNT
            })
          }

          function E(y) {
            d[y.MTRL_CD].QTY !== y.FIR_CNT && (d[y.MTRL_CD].QTY -= y.INC_STEP)
          }

          function k(y, I) {
            let U = +y.target.value || I.FIR_CNT;
            if (U < I.FIR_CNT && (U = I.FIR_CNT), I.RMD_QTY > 0 && U > I.RMD_QTY && (U = I.RMD_QTY), I.INC_STEP !== 1) {
              const Z = U % I.INC_STEP;
              Z !== 0 && (U = U - Z)
            }
            d[I.MTRL_CD] = {
              ...d[I.MTRL_CD],
              QTY: U
            }
          }

          function N() {
            if (!a.value) {
              if (c.value === "X") return m(x("옵션미선택안내"));
              const y = n.data.find(I => I.MTRL_CD === c.value);
              return v(y), c.value = "X"
            }
            if (a.value.uiType === "MULTI") return cn(u) || Object.values(u).every(y => y === "X") ? m(x("옵션미선택안내")) : (Object.entries(u).forEach(([y, I]) => {
              const w = _.value[y].find(U => U.MTRL_CD === I);
              v(w)
            }), Object.keys(u).forEach(y => delete u[y]));
            if (a.value.uiType === "CASCADE") {
              const y = a.value.filters[0],
                I = a.value.filters.find(U => U.GRP_TYPE === "MTRL_SUB_GRP");
              if (i.value === "X") return m(x("옵션미선택안내상세", {
                OPTION: x(y.GRP_NME)
              }));
              if (!I) return;
              if (I.options) {
                if (l.value === "X") return m(x("옵션미선택안내상세", {
                  OPTION: x(I.GRP_NME)
                }));
                const U = _.value[i.value].find(Z => {
                  if (Z.MTRL_NM.includes(x(l.value))) return !0;
                  if (l.value === "NONE") return !0
                });
                return v(U), f()
              }
              if (c.value === "X") return m(x("옵션미선택안내상세", {
                OPTION: x(I.GRP_NME)
              }));
              const w = _.value[i.value].find(U => U.MTRL_CD === c.value);
              return v(w), f()
            }
          }

          function D(y) {
            delete d[y.MTRL_CD]
          }
          F(() => d, y => {
            const I = Object.values(y).map(w => ({
              MTRL_CD: w.MTRL_CD,
              QTY: w.QTY,
              ATTB: "",
              MTRL_NME: w.MTRL_NM
            }));
            o("update", I)
          }, {
            deep: !0
          });
          const O = Ml(),
            A = R(() => O.getOrderData()?.priceCalc.result.result?.reduce((I, w) => (I[w.MTRL_CD] = +w.PRICE_MALL !== w.PRICE ? +w.PRICE_MALL : w.PRICE, I), {})),
            b = xe(A.value || {});

          function C(y, I, w) {
            const Z = performance.now(),
              me = _e => {
                const B = Math.min((_e - Z) / 300, 1),
                  W = Math.floor(I + (w - I) * B);
                b[y] = W, B < 1 && requestAnimationFrame(me)
              };
            requestAnimationFrame(me)
          }
          return F(() => A.value, (y, I = {}) => {
            y && Object.keys(y).forEach(w => {
              const U = I[w] || 0,
                Z = y[w] || 0;
              C(w, U, Z)
            })
          }, {
            deep: !0
          }), (y, I) => (g(), M(J, null, [a.value ? (g(!0), M(J, {
            key: 0
          }, he(a.value.filters, w => (g(), V(fe, {
            key: w.GRP_NME,
            title: `${T(x)("옵션")} - ${T(x)(w.GRP_NME)}`
          }, {
            default: ce(() => [w.GRP_TYPE === "MTRL_MULTI_GRP" ? (g(), V(Fo, {
              key: 0,
              name: w.GRP_COD,
              default: u[w.GRP_COD] || "X",
              options: p(w),
              onSelect: U => u[w.GRP_COD] = U
            }, null, 8, ["name", "default", "options", "onSelect"])) : w.GRP_TYPE === "MTRL_GRP" ? (g(), V(Fo, {
              key: 1,
              name: "material-group",
              options: p(w),
              default: i.value,
              onSelect: I[0] || (I[0] = U => i.value = U)
            }, null, 8, ["options", "default"])) : w.GRP_TYPE === "MTRL_SUB_GRP" && w.options ? (g(), V(Fo, {
              key: 2,
              name: "material-sub-group",
              options: p(w),
              default: l.value,
              onSelect: I[1] || (I[1] = U => l.value = U)
            }, null, 8, ["options", "default"])) : (g(), V(Fo, {
              key: 3,
              name: "material",
              options: p(w),
              default: c.value,
              onSelect: I[2] || (I[2] = U => c.value = U)
            }, null, 8, ["options", "default"]))]),
            _: 2
          }, 1032, ["title"]))), 128)) : (g(), V(fe, {
            key: 1,
            title: T(x)("옵션")
          }, {
            default: ce(() => [K(Fo, {
              name: "material",
              options: p(),
              default: c.value,
              onSelect: I[3] || (I[3] = w => c.value = w)
            }, null, 8, ["options", "default"])]),
            _: 1
          }, 8, ["title"])), S("button", {
            type: "button",
            class: "add-btn",
            onClick: N
          }, "+ " + j(T(x)("옵션선택")), 1), T(cn)(d) ? oe("", !0) : (g(), M("div", QP, [(g(!0), M(J, null, he(Object.values(d), w => (g(), M("div", {
            key: w.MTRL_CD
          }, [A.value && A.value[w.MTRL_CD] ? (g(), M(J, {
            key: 0
          }, [S("p", XP, j(w.MTRL_NM), 1), S("div", JP, [S("div", ZP, [S("button", {
            type: "button",
            class: "btn minus",
            onClick: U => E(w)
          }, "-", 8, eE), S("input", {
            class: "qty",
            value: w.QTY,
            name: "qty",
            onChange: U => k(U, w),
            type: "number"
          }, null, 40, tE), S("button", {
            type: "button",
            class: "btn plus",
            onClick: U => v(w)
          }, "+", 8, nE)]), S("div", oE, [S("span", sE, j(b[w.MTRL_CD]?.toLocaleString()), 1), S("button", {
            type: "button",
            class: "delete-btn",
            onClick: U => D(w)
          }, "X", 8, rE)])])], 64)) : (g(), M("div", iE, [K(Ne, {
            variant: "rounded",
            width: 110,
            height: 16
          }), S("div", aE, [K(Ne, {
            variant: "rounded",
            width: 106,
            height: 28
          }), S("div", lE, [K(Ne, {
            variant: "rounded",
            width: 50,
            height: 17
          }), K(Ne, {
            variant: "circular",
            width: 16,
            height: 16
          })])])]))]))), 128))]))], 64))
        }
      }), [
        ["__scopeId", "data-v-99ad5859"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    cE = {
      class: "flex-row"
    },
    dE = {
      class: "notes"
    },
    fE = {
      class: "note"
    },
    pE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = a => {
              s.value = a.value
            };
          return F(() => s.value, a => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: a,
              PCS_DTL_NM: n.data.name
            }])
          }, {
            immediate: !0
          }), (a, i) => (g(), V(fe, {
            title: a.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", cE, [(g(!0), M(J, null, he(a.data.options, l => (g(), V(je, {
              key: l.key,
              data: {
                value: l.value,
                name: l.name,
                imgPath: `${a.data.subImgPath}_${l.value}`
              },
              active: s.value === l.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))]), S("div", dE, [S("p", fE, j(a.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _E = {
      class: "flex-row -flow"
    },
    hE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.attbOptions[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: `${n.data.name}(${r.value})`,
              ATTB: i
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", _E, [(g(!0), M(J, null, he(i.data.attbOptions, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: c.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    mE = {
      class: "flex-row"
    },
    vE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = [{
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
            a = R(() => n.relatedData.sizeInfo.workSize),
            i = R(() => J_.has(s.pdtCode) ? "BPLFT" : a.value.width > a.value.height ? "BPTOP" : "BPLFT"),
            l = H(r[0].value),
            c = R(() => ({
              main: i.value,
              sub: l.value
            }));
          return F(() => c.value, u => {
            const d = n.data.options.find(h => h.value === u.main)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: u.main,
              PCS_DTL_NM: d?.PCS_DTL_NM,
              ...i.value === "BPTOP" ? {
                BACK_ROT_YN: u.sub
              } : {}
            }])
          }, {
            immediate: !0
          }), (u, d) => (g(), V(fe, {
            title: u.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", mE, [(g(!0), M(J, null, he(u.data.options, h => (g(), V(je, {
              key: h.key,
              data: {
                value: h.value,
                name: h.name,
                imgPath: `${u.data.subImgPath}_${h.value}`
              },
              "force-hidden": i.value !== h.value,
              active: i.value === h.value
            }, null, 8, ["data", "force-hidden", "active"]))), 128)), (g(), M(J, null, he(r, h => K(je, {
              key: h.key,
              data: {
                value: h.value,
                name: h.name,
                imgPath: h.imgPath
              },
              "force-hidden": i.value === "BPLFT",
              active: l.value === h.value,
              onSelect: d[0] || (d[0] = f => l.value = f.value)
            }, null, 8, ["data", "force-hidden", "active"])), 64))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    gE = {
      class: "flex-row"
    },
    yE = {
      class: "notes"
    },
    CE = {
      class: "note"
    },
    TE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.options[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: r.value
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", gE, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: i.data.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))]), S("div", yE, [S("p", CE, j(i.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    bE = {
      class: "flex-row"
    },
    SE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.options[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: `${n.data.name}(${r.value})`
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", bE, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${i.data.subImgPath}_${c.value}`
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    DE = ["value"],
    PE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
        __name: "CLD_STD",
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
          return F(() => s.value, r => {
            const a = n.data.options.find(i => i.value === r);
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: r,
              PCS_DTL_NM: a?.name
            }])
          }, {
            immediate: !0
          }), (r, a) => (g(), V(fe, {
            title: r.data.name,
            underline: ""
          }, {
            default: ce(() => [de(S("select", {
              "onUpdate:modelValue": a[0] || (a[0] = i => s.value = i),
              name: "CLD_STD",
              class: "basic-select"
            }, [(g(!0), M(J, null, he(r.data.options, i => (g(), M("option", {
              key: i.key,
              value: i.value
            }, j(T(x)(i.name)), 9, DE))), 128))], 512), [
              [We, s.value]
            ])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    EE = {
      class: "grid-group"
    },
    OE = {
      class: "flex-row -flow"
    },
    IE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
        __name: "COT_DFT",
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = Dt(),
            a = {
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
            };

          function i(_) {
            const p = _.slice(-1),
              m = _.slice(0, 4);
            return {
              side: p,
              coating: m
            }
          }
          const l = R(() => {
              const _ = {},
                p = {};
              for (const m of n.data.options) {
                const {
                  side: v,
                  coating: E
                } = i(m.value), k = a[v], N = r.locale === "ko" ? a[E] : m.name;
                _[v] || (_[v] = {
                  id: `COT_DFT/${v}`,
                  name: `COT_DFT/${v}`,
                  label: k,
                  value: v
                }), p[E] || (p[E] = {
                  ...m,
                  value: E,
                  name: N,
                  disabled: n.disabledOptions?.includes(m.value)
                })
              }
              return {
                sides: _,
                coatings: p
              }
            }),
            c = H(n.data.options[0].value.slice(-1)),
            u = H(n.data.options[0].value.slice(0, 4)),
            d = R(() => u.value + c.value),
            h = {
              TCMA: "COT_DFT_MA_BOOK",
              TCGL: "COT_DFT_GL_BOOK",
              TCEB: "COT_DFT_EB_BOOK",
              TCSL: "COT_DFT_SL_BOOK"
            },
            f = R(() => s.pdtCode.startsWith("PRBK") ? h : null);
          return F(() => d.value, _ => {
            const p = n.data.options.find(m => m.value === _)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: _,
              PCS_DTL_NM: p?.PCS_DTL_NM
            }])
          }, {
            immediate: !0
          }), F(() => n.disabledOptions, _ => {
            if (!_ || !_.some(m => m.startsWith(u.value))) return;
            const p = Object.values(l.value.coatings).find(m => !m.disabled);
            p && (u.value = p.value)
          }), (_, p) => (g(), V(fe, {
            title: _.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", EE, [K(Dn, {
              options: Object.values(l.value.sides),
              "default-checked": c.value,
              onChange: p[0] || (p[0] = m => c.value = m.value)
            }, null, 8, ["options", "default-checked"]), S("div", OE, [(g(!0), M(J, null, he(Object.values(l.value.coatings), m => (g(), V(je, {
              key: m.key,
              data: {
                value: m.value,
                name: m.name,
                imgPath: f.value && f.value[m.value] ? f.value[m.value] : `COT_DFT_${m.value.slice(2,4)}`,
                subImgPath: _.data.subImgPath
              },
              disabled: m.disabled,
              "disabled-styling": m.disabled,
              active: u.value === m.value,
              onSelect: p[1] || (p[1] = v => u.value = v.value)
            }, null, 8, ["data", "disabled", "disabled-styling", "active"]))), 128))])])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    RE = {
      class: "flex-row"
    },
    wE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(`${n.data.name}(${n.data.options[0].name})`),
            a = i => {
              s.value = i.value, r.value = `${n.data.name}(${i.name})`
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: r.value
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", RE, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${i.data.subImgPath}_${c.value}`,
                subImgPath: i.data.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    AE = ["value"],
    NE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
          return F(() => s.value, r => {
            const a = n.data.options.find(i => i.value === r);
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: r,
              PCS_DTL_NM: `${n.data.name}(${a?.name})`
            }])
          }, {
            immediate: !0
          }), (r, a) => (g(), V(fe, {
            title: r.data.name,
            underline: ""
          }, {
            default: ce(() => [de(S("select", {
              "onUpdate:modelValue": a[0] || (a[0] = i => s.value = i),
              name: "CVR_INN",
              class: "basic-select"
            }, [(g(!0), M(J, null, he(r.data.options, i => (g(), M("option", {
              key: i.key,
              value: i.value
            }, j(T(x)(i.name)), 9, AE))), 128))], 512), [
              [We, s.value]
            ])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    ME = {
      class: "flex-row"
    },
    kE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.options[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: r.value
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", ME, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${i.data.subImgPath}_${c.value}`,
                subImgPath: i.data.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    LE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = R(() => n.data.options.map(i => ({
              id: i.value,
              name: n.data.value,
              label: i.name,
              value: i.value
            }))),
            r = H(s.value[0]),
            a = R(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: r.value.value,
              PCS_DTL_NM: r.value.label,
              ATTB: n.relatedData.orderQty
            }));
          return F(() => a.value, (i, l) => {
            l?.ATTB === i.ATTB && l?.PCS_DTL_CD === i.PCS_DTL_CD || o("update", [i])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [K(Dn, {
              options: s.value,
              "default-checked": s.value[0].value,
              onChange: l[0] || (l[0] = c => r.value = c)
            }, null, 8, ["options", "default-checked"])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    $E = {
      class: "notes"
    },
    xE = {
      class: "note"
    },
    FE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = R(() => n.data.options.map(i => ({
              COD: i.value,
              COD_NME: i.name,
              HEX: s[i.value]
            }))),
            a = H(r.value[0]);
          return F(() => a.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i.COD,
              PCS_DTL_NM: `${n.data.name}(${i.COD_NME})`
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [K(sh, {
              options: r.value,
              onSelect: l[0] || (l[0] = c => a.value = c)
            }, null, 8, ["options"]), S("div", $E, [S("p", xE, j(i.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    UE = {
      class: "flex-row"
    },
    BE = ["value", "disabled"],
    VE = ["value"],
    HE = {
      key: 0,
      class: "notes"
    },
    GE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = R(() => n.data.options[0].extra.QTY_INPUT_YN === "Y"),
            a = R(() => s.pdtCode === "GSNTMIS" && c.value ? n.data.options.map(f => ({
              ...f,
              disabled: f.value !== "INNON"
            })) : n.data.options),
            i = H(n.data.options[0].value),
            l = R(() => a.value.find(f => f.value === i.value)),
            c = R(() => n.relatedData.sizeInfo?.DIV_SEQ === 0 || n.relatedData.sizeInfo?.DIV_NM === "사이즈직접입력"),
            u = H(1),
            d = () => {
              if (u.value < 1) return u.value = 1
            };
          F(() => c.value, f => {
            f && (i.value = "INNON")
          });
          const h = R(() => [{
            PCS_CD: n.data.value,
            PCS_DTL_CD: i.value,
            PCS_DTL_NM: `${n.data.name}(${l.value?.name})`,
            ATTB: r.value ? u.value : n.relatedData.orderQty,
            ATTB_2: "",
            ATTB_3: ""
          }]);
          return F(() => h.value, f => {
            o("update", f)
          }, {
            immediate: !0
          }), (f, _) => {
            const p = on("dompurify-html");
            return g(), V(fe, {
              title: f.data.name,
              underline: ""
            }, {
              default: ce(() => [S("div", UE, [de(S("select", {
                "onUpdate:modelValue": _[0] || (_[0] = m => i.value = m),
                name: "INN_DFT",
                class: "basic-select"
              }, [(g(!0), M(J, null, he(a.value, m => (g(), M("option", {
                key: m.key,
                value: m.value,
                disabled: m.disabled
              }, j(T(x)(m.name)), 9, BE))), 128))], 512), [
                [We, i.value]
              ]), r.value ? de((g(), M("input", {
                key: 0,
                "onUpdate:modelValue": _[1] || (_[1] = m => u.value = m),
                type: "number",
                id: "qty",
                class: "basic-input",
                onFocusout: d
              }, null, 544)), [
                [yt, u.value]
              ]) : (g(), M("input", {
                key: 1,
                type: "number",
                id: "qty",
                disabled: !0,
                value: f.relatedData.orderQty,
                class: "basic-input"
              }, null, 8, VE))]), l.value ? (g(), M("div", HE, [(g(!0), M(J, null, he(l.value.extra.NOTICE, (m, v) => de((g(), M("p", {
                key: `notice-${v}`,
                class: "note"
              })), [
                [p, m]
              ])), 128))])) : oe("", !0)]),
              _: 1
            }, 8, ["title"])
          }
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    jE = {
      class: "flex-row"
    },
    zE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.options[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: r.value
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", jE, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${i.data.subImgPath}_${c.value}`,
                subImgPath: i.data.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    YE = {
      class: "flex-row"
    },
    KE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.options[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: i,
              PCS_DTL_NM: r.value
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", YE, [(g(!0), M(J, null, he(i.data.options, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: `${i.data.subImgPath}_${c.value}`,
                subImgPath: i.data.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    WE = {
      class: "flex-row"
    },
    qE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = le("callbacks", {}),
            a = le("deviceType", "pc"),
            i = H(n.data.options.find(p => p.value === "DFXXX" || p.value === "PK000")?.value || n.data.options[0].value),
            l = p => {
              i.value = p.value
            },
            c = {
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
            u = R(() => c[s.pdtCode]),
            d = {
              PK017: {
                src: `${qe}/ko/item/order_beachTowel_opt_hover_1.png`,
                alt: "Beach Towel PVC bag image"
              }
            },
            h = R(() => n.data.options.map((p, m) => {
              const v = d[p.value];
              return v ? {
                IDX: m + 1,
                CATEGORY: `${x("후가공")} > ${p.name}`,
                LABEL: p.name,
                IMG_URL: v.src,
                IMG_ALT: v.alt
              } : null
            }));
          F(() => i.value, p => {
            const m = n.data.options.find(v => v.value === p)?.name || n.data.name;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: p,
              PCS_DTL_NM: m
            }])
          }, {
            immediate: !0
          });
          const f = {
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
            _ = xe(n.data.options);
          return F(() => n.relatedData?.postpcs?.CLD_STD, p => {
            if (!p) return;
            const m = p[0].selectedOptions[0].PCS_DTL_CD;
            if (!m) return;
            const v = f[m];
            for (const E of _) E.value === "PK018" || E.value === v ? E.forceHidden = !1 : E.forceHidden = !0, E.forceHidden && E.value === i.value && (i.value = v)
          }, {
            immediate: !0,
            deep: !0
          }), (p, m) => (g(), V(fe, {
            title: p.data.name || "폴리백 개별포장",
            underline: "",
            extra: T(a) === "mobile" && h.value ? {
              name: "자세히보기",
              callback: () => {
                T(r).onInformOptionTips && T(r).onInformOptionTips(h.value)
              },
              style: "tip"
            } : null
          }, {
            default: ce(() => [S("div", WE, [(g(!0), M(J, null, he(_, (v, E) => (g(), V(je, {
              key: v.key,
              data: {
                value: v.value,
                name: v.name,
                imgPath: u.value && u.value[v.value] ? u.value[v.value] : p.data.imgPath,
                subImgPath: p.data.subImgPath
              },
              "force-hidden": v.forceHidden,
              active: i.value === v.value,
              tip: h.value[E],
              onSelect: l
            }, null, 8, ["data", "force-hidden", "active", "tip"]))), 128))])]),
            _: 1
          }, 8, ["title", "extra"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    QE = {
      class: "flex-row"
    },
    XE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
        __name: "PAK_POL",
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
            r = a => {
              s.value = a.value
            };
          return F(() => s.value, a => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: a,
              PCS_DTL_NM: n.data.name
            }])
          }, {
            immediate: !0
          }), (a, i) => (g(), V(fe, {
            title: a.data.name || "폴리백 개별포장",
            underline: ""
          }, {
            default: ce(() => [S("div", QE, [(g(!0), M(J, null, he(a.data.options, l => (g(), V(je, {
              key: l.key,
              data: {
                value: l.value,
                name: l.name,
                imgPath: a.data.imgPath,
                subImgPath: a.data.subImgPath
              },
              active: s.value === l.value,
              onSelect: r
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    JE = {
      class: "flex-row"
    },
    ZE = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("deviceType", "pc"),
            r = le("callbacks", {}),
            a = H(n.data.options[0].value),
            i = d => {
              a.value = d.value
            },
            l = R(() => ({
              PCS_CD: n.data.value,
              PCS_DTL_CD: a.value,
              PCS_DTL_NM: n.data.name,
              ATTB: n.relatedData.orderQty
            })),
            c = {
              PP002: {
                src: `${qe}/ko/STDRCAD_back_print_over_img.png`,
                alt: "Back paper image"
              }
            },
            u = R(() => n.data.options.map((d, h) => {
              const f = c[d.value];
              return f ? {
                IDX: h + 1,
                CATEGORY: `${x("후가공")} > ${d.name}`,
                LABEL: d.name,
                IMG_URL: f.src,
                IMG_ALT: f.alt
              } : null
            }));
          return F(() => l.value, d => {
            o("update", [d])
          }, {
            immediate: !0
          }), (d, h) => (g(), V(fe, {
            title: d.data.name,
            underline: "",
            extra: T(s) === "mobile" && u.value ? {
              name: "자세히보기",
              callback: () => {
                T(r).onInformOptionTips && T(r).onInformOptionTips(u.value)
              },
              style: "tip"
            } : null
          }, {
            default: ce(() => [S("div", JE, [(g(!0), M(J, null, he(d.data.options, (f, _) => (g(), V(je, {
              key: f.key,
              data: {
                value: f.value,
                name: f.name,
                imgPath: `${d.data.value}_${f.value}`
              },
              active: a.value === f.value,
              tip: u.value[_],
              onSelect: i
            }, null, 8, ["data", "active", "tip"]))), 128))])]),
            _: 1
          }, 8, ["title", "extra"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    eO = {
      class: "option packing"
    },
    tO = {
      class: "title"
    },
    nO = {
      class: "flex-row"
    },
    oO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
        __name: "PRT_IPK",
        setup(e) {
          return (t, n) => (g(), M("div", eO, [S("div", tO, [S("h2", null, j(T(x)("개별포장")), 1)]), S("div", nO, [K(je, {
            data: {
              value: "PRT_IPK",
              name: "개별포장",
              imgPath: "PRT_IPK"
            },
            active: !0
          })])]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    sO = {
      class: "flex-row"
    },
    lh = re({
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
          r = R(() => n.options.map(u => ({
            value: u.value,
            name: u.name,
            imgPath: u.extra?.PCS_CD || "",
            extra: u.extra
          }))),
          a = xe({
            DFXXF: !0,
            DFXXB: !0
          });

        function i(u) {
          a[u.value] = !a[u.value]
        }
        const l = R(() => {
          const u = [];
          return n.options.forEach(d => {
            (d.extra?.ESN_YN === "Y" || a[d.value]) && u.push({
              PCS_CD: d.extra?.PCS_CD || "PRT_WHT",
              PCS_GRP_NM: d.extra.PCS_GRP_NM,
              VIEW_YN: "Y",
              ESN_YN: d.extra?.ESN_YN || "N",
              selectedOptions: [{
                PCS_CD: d.extra?.PCS_CD,
                PCS_DTL_CD: d.extra?.PCS_DTL_CD,
                PCS_DTL_NM: d.extra?.PCS_DTL_NM,
                ATTB: "Y",
                ATTB_2: n.mode
              }]
            })
          }), u
        });
        F(() => l.value, u => {
          u && o("update", u)
        }, {
          immediate: !0
        }), F(() => s.editorData?.default?.PRT_WHT, u => {
          u && (a.DFXXF = u?.front ?? !1, a.DFXXB = u?.back ?? !1)
        }, {
          immediate: !0
        });
        const {
          resetEditByWhite: c
        } = Hl();
        return Pi(() => {
          s.isAfterEdit() && c()
        }), F(() => s.uploadType.default, u => {
          u === "editor" && (a.DFXXF = !0, a.DFXXB = !0)
        }), (u, d) => (g(), M("div", sO, [(g(!0), M(J, null, he(r.value, h => (g(), V(je, {
          key: h.value,
          data: h,
          active: a[h.value],
          disabled: h.extra?.ESN_YN === "Y" || T(s).uploadType.default === "editor",
          onSelect: i
        }, null, 8, ["data", "active", "disabled"]))), 128))]))
      }
    }),
    rO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: lh
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    iO = {
      class: "grid-group"
    },
    aO = {
      class: "basic-radio"
    },
    lO = {
      for: "auto-white"
    },
    uO = {
      class: "text"
    },
    cO = {
      key: 0,
      for: "self-white"
    },
    dO = {
      class: "text disabled"
    },
    fO = {
      key: 1,
      class: "note red"
    },
    pO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = le("productCode", {
              pdtCode: ""
            }),
            a = R(() => n.data.options.length >= 2),
            i = H("Y"),
            l = R(() => n.data.options[0].extra?.NOTICE[i.value === "Y" ? 0 : 1]),
            c = R(() => a.value ? [] : n.data.options.filter((_, p) => _.extra?.ESN_YN === "Y" || p === 0).map(_ => ({
              PCS_CD: _.extra?.PCS_CD,
              PCS_DTL_CD: _.extra?.PCS_DTL_CD,
              PCS_DTL_NM: _.extra?.PCS_DTL_NM,
              ATTB: "Y",
              ATTB_2: i.value
            }))),
            {
              canResetWhite: u,
              resetEditByWhite: d
            } = Hl();
          F(() => c.value, _ => {
            if (_)
              if (r.pdtCode.startsWith("AC")) {
                if (a.value && !s.isAfterEdit()) return;
                u.value && d(), o("update", _), s.isAfterEdit() && !u.value && (u.value = !0)
              } else o("update", _)
          }, {
            immediate: !0
          });
          const h = _ => {
              o("update:replace", _)
            },
            f = R(() => _1.has(r.pdtCode) ? !1 : s.uploadType.default === "pdf" ? !0 : Fl[r.pdtCode] && n.relatedData.mtrlCd ? !Fl[r.pdtCode][n.relatedData.mtrlCd] : !1);
          return F(() => f.value, _ => {
            _ || (i.value = "Y", o("update", c.value))
          }), (_, p) => (g(), V(fe, {
            title: _.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", iO, [S("div", aO, [S("label", lO, [de(S("input", {
              type: "radio",
              id: "auto-white",
              name: "white-mode",
              "onUpdate:modelValue": p[0] || (p[0] = m => i.value = m),
              value: "Y"
            }, null, 512), [
              [od, i.value]
            ]), S("span", uO, j(T(x)("자동화이트")), 1)]), f.value ? (g(), M("label", cO, [de(S("input", {
              type: "radio",
              id: "self-white",
              name: "white-mode",
              "onUpdate:modelValue": p[1] || (p[1] = m => i.value = m),
              value: "N"
            }, null, 512), [
              [od, i.value]
            ]), S("span", dO, j(T(x)("수동화이트")), 1)])) : oe("", !0)]), a.value ? (g(), V(lh, {
              key: 0,
              mode: i.value,
              options: _.data.options,
              onUpdate: h
            }, null, 8, ["mode", "options"])) : oe("", !0), l.value ? (g(), M("p", fO, "* " + j(l.value), 1)) : oe("", !0)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    _O = {
      class: "flex-row"
    },
    hO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = H(n.data.attbOptions[0].name),
            a = i => {
              s.value = i.value, r.value = i.name
            };
          return F(() => s.value, i => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: n.data.options[0].value,
              PCS_DTL_NM: `${n.data.name}(${r.value})`,
              ATTB: i
            }])
          }, {
            immediate: !0
          }), (i, l) => (g(), V(fe, {
            title: i.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", _O, [(g(!0), M(J, null, he(i.data.attbOptions, c => (g(), V(je, {
              key: c.key,
              data: {
                value: c.value,
                name: c.name,
                imgPath: c.value
              },
              active: s.value === c.value,
              onSelect: a
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    mO = {
      class: "options"
    },
    vO = {
      class: "full-width"
    },
    gO = {
      for: "ROU_DFT_ALL",
      class: "fake-checkbox"
    },
    yO = ["src"],
    CO = ["id", "value"],
    TO = ["for"],
    bO = ["src"],
    SO = {
      class: "option-name"
    },
    DO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = R(() => n.relatedData.sizeInfo?.DIV_SEQ),
            a = R(() => {
              const h = Yr[s.pdtCode];
              if (h && h.factor === "size" && r.value) {
                const f = h.value[r.value];
                return [{
                  id: `round-${f}`,
                  name: "round-value",
                  label: `${f}mm`,
                  value: f
                }]
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
              }]
            }),
            i = H(a.value[0].value),
            l = H(!0),
            c = R(() => n.data.options.map(h => `${h.value}/${h.name}`)),
            u = H(c.value);
          F(() => l.value, h => {
            h ? u.value = c.value : u.value.length === 4 && (u.value = [])
          }), F(() => u.value, h => {
            l.value = h.length === 4
          }), F(() => r.value, h => {
            !Yr[s.pdtCode] || !h || (i.value = Yr[s.pdtCode].value[h])
          });
          const d = R(() => u.value.map(h => {
            const [f, _] = h.split("/");
            return {
              PCS_CD: n.data.value,
              PCS_DTL_CD: f,
              PCS_DTL_NM: _,
              ATTB: i.value
            }
          }));
          return F(() => d.value, h => {
            o("update", h)
          }, {
            immediate: !0
          }), (h, f) => (g(), V(fe, {
            title: h.data.name,
            underline: ""
          }, {
            default: ce(() => [K(Dn, {
              options: a.value,
              "default-checked": a.value[0].value,
              onChange: f[0] || (f[0] = _ => i.value = _.value)
            }, null, 8, ["options", "default-checked"]), S("ul", mO, [S("li", vO, [de(S("input", {
              "onUpdate:modelValue": f[1] || (f[1] = _ => l.value = _),
              type: "checkbox",
              id: "ROU_DFT_ALL"
            }, null, 512), [
              [Wi, l.value]
            ]), S("label", gO, [S("img", {
              src: `${T(qe)}/ko/order_aside_icon_round_all.svg`
            }, null, 8, yO), f[3] || (f[3] = S("span", {
              class: "option-name"
            }, "4귀 전체", -1))])]), (g(!0), M(J, null, he(h.data.options, _ => (g(), M("li", {
              key: _.value
            }, [de(S("input", {
              "onUpdate:modelValue": f[2] || (f[2] = p => u.value = p),
              type: "checkbox",
              id: _.value,
              value: `${_.value}/${_.name}`
            }, null, 8, CO), [
              [Wi, u.value]
            ]), S("label", {
              for: _.value,
              class: "fake-checkbox"
            }, [S("img", {
              src: `${T(qe)}/ko/order_aside_icon_ROU_DFT_${_.value}.svg`
            }, null, 8, bO), S("span", SO, j(_.name), 1)], 8, TO)]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      }), [
        ["__scopeId", "data-v-dd59e1e8"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    PO = {
      class: "grid-group"
    },
    EO = {
      class: "flex-row"
    },
    OO = {
      class: "note"
    },
    IO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("callbacks", {}),
            r = {
              S: "단면",
              D: "양면",
              DFXX: "스코딕스"
            },
            a = R(() => {
              const u = {},
                d = {};
              for (const h of n.data.options) {
                const f = h.value.slice(-1),
                  _ = r[f],
                  p = h.value.slice(0, 4),
                  m = r[p];
                u[f] || (u[f] = {
                  id: `SCO_DFT/${f}`,
                  name: `SCO_DFT/${f}`,
                  label: _,
                  value: f
                }), d[p] || (d[p] = {
                  ...h,
                  value: p,
                  name: m
                })
              }
              return {
                sides: u,
                spotUVs: d
              }
            }),
            i = H("S"),
            l = H(n.data.options[0].value.slice(0, 4)),
            c = R(() => l.value + i.value);
          return F(() => c.value, u => {
            const d = n.data.options.find(h => h.value === u)?.extra;
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: u,
              PCS_DTL_NM: d?.PCS_DTL_NM
            }])
          }, {
            immediate: !0
          }), (u, d) => (g(), V(fe, {
            title: u.data.name,
            underline: "",
            extra: {
              name: "규격가이드",
              callback: () => {
                T(s)?.onInformGuide && T(s).onInformGuide("SCO_DFT")
              }
            }
          }, {
            default: ce(() => [S("div", PO, [K(Dn, {
              options: Object.values(a.value.sides),
              "default-checked": i.value,
              onChange: d[0] || (d[0] = h => i.value = h.value)
            }, null, 8, ["options", "default-checked"]), S("div", EO, [(g(!0), M(J, null, he(Object.values(a.value.spotUVs), h => (g(), V(je, {
              key: h.key,
              data: {
                value: h.value,
                name: h.name,
                imgPath: u.data.value,
                subImgPath: u.data.subImgPath
              },
              active: l.value === h.value,
              onSelect: d[1] || (d[1] = f => l.value = f.value)
            }, null, 8, ["data", "active"]))), 128))]), S("p", OO, j(u.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title", "extra"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    RO = {
      class: "flex-row"
    },
    wO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = R(() => n.data.options[0].extra.DIV_SEQ === 0 ? n.data.options : n.data.options.filter(l => l.extra.DIV_SEQ === n.relatedData.sizeInfo.DIV_SEQ)),
            r = H(s.value[0].value),
            a = H(`${n.data.name}-${s.value[0].name}`),
            i = l => {
              r.value = l.value, a.value = `${n.data.name}-${l.name}`
            };
          return F(() => r.value, l => {
            o("update", [{
              PCS_CD: n.data.value,
              PCS_DTL_CD: l,
              PCS_DTL_NM: a.value
            }])
          }, {
            immediate: !0
          }), F(() => n.relatedData.sizeInfo.DIV_SEQ, () => {
            r.value = s.value[0].value, a.value = `${n.data.name}-${s.value[0].name}`
          }), (l, c) => (g(), V(fe, {
            title: l.data.name,
            underline: ""
          }, {
            default: ce(() => [S("div", RO, [(g(!0), M(J, null, he(s.value, u => (g(), V(je, {
              key: u.key,
              data: {
                value: u.value,
                name: u.name,
                imgPath: `${l.data.subImgPath}_${u.value}`,
                subImgPath: l.data.value
              },
              active: r.value === u.value,
              onSelect: i
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    AO = {
      key: 0,
      class: "flex-row"
    },
    NO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            o = e,
            s = t,
            r = R(() => o.data.options.map(l => ({
              id: l.value,
              name: o.data.value,
              label: l.name,
              value: l.value
            }))),
            a = H(r.value[0]),
            i = R(() => ({
              PCS_CD: o.data.value,
              PCS_DTL_CD: a.value.value,
              PCS_DTL_NM: a.value.label,
              ATTB: o.relatedData.orderQty
            }));
          return F(() => i.value, (l, c) => {
            c?.ATTB === l.ATTB && c?.PCS_DTL_CD === l.PCS_DTL_CD || s("update", [l])
          }, {
            immediate: !0
          }), (l, c) => (g(), V(fe, {
            title: l.data.name,
            underline: ""
          }, {
            default: ce(() => [n[l.data.group] === "icon" ? (g(), M("div", AO, [(g(!0), M(J, null, he(l.data.options, u => (g(), V(je, {
              key: u.value,
              active: a.value.value === u.value,
              data: {
                ...u,
                imgPath: `${l.data.value}_${u.value}`
              },
              onSelect: d => {
                a.value = {
                  id: d.value,
                  name: o.data.value,
                  label: d.name,
                  value: d.value
                }
              }
            }, null, 8, ["active", "data", "onSelect"]))), 128))])) : (g(), V(Dn, {
              key: 1,
              options: r.value,
              "default-checked": r.value[0].value,
              onChange: c[0] || (c[0] = u => a.value = u)
            }, null, 8, ["options", "default-checked"]))]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    MO = ["value", "disabled"],
    kO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            s = le("callbacks", {}),
            r = le("productCode", {
              pdtCode: ""
            }),
            a = Dt(),
            i = R(() => n.relatedData?.filters),
            l = R(() => n.relatedData?.POST_PCS),
            c = R(() => {
              let p = [];
              return $l.has(r.pdtCode) && l.value && (p = n.options.filter(m => m.MTRL_CD === l.value?.MTRL_CD || m.BSN_YN === "Y")), i.value && (p = n.options.filter(m => (i.value?.MTRL_GRP ? i.value.MTRL_GRP === m.GRP_OPTION_CD : !0) && (i.value?.PTT ? i.value.PTT === m.PTT_CD : !0))), p.length > 0 ? p : n.options
            }),
            u = R(() => c.value.filter(p => p.HIDE_YN !== "Y")),
            d = async () => {
              const p = await Nl({
                pdt_cod: r.pdtCode,
                lang: a.locale
              });
              if (!p) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
              if (s?.onInformMaterials) {
                const m = r.pdtCode.startsWith("ST") ? [x("스티커용지-주의사항")] : void 0;
                s.onInformMaterials(p, m)
              } else console.log("[RedWidgetSDK] 자재 정보 >", p)
            }, h = () => {
              n.resetAfterEdit && s?.onReset && s.onReset("mtrl")
            }, f = H(n.default?.MTRL_CD || u.value[0]?.MTRL_CD);
          F(() => f.value, p => {
            const m = u.value.find(v => v.MTRL_CD === p);
            if (m) {
              const {
                PTT_CD: v,
                PTT_NM: E,
                WGT_CD: k,
                CLR_CD: N,
                MTRL_CD: D,
                MTRL_NM: O,
                MTRL_TYPE: A,
                PRT_HIDE_YN: b
              } = m;
              o("update", {
                PTT_CD: v,
                PTT_NM: E,
                WGT_CD: k,
                CLR_CD: N,
                MTRL_CD: D,
                MTRL_NM: O,
                MTRL_TYPE: A,
                PRT_HIDE_YN: b
              }), v === "OOO" && s?.onSaleOrder && s?.onSaleOrder(), h()
            }
          }, {
            immediate: !0
          }), F(() => l.value?.MTRL_CD, p => {
            p && $l.has(r.pdtCode) && (f.value = u.value[0]?.MTRL_CD)
          }), F(() => i.value, (p, m) => {
            (p?.MTRL_GRP !== m?.MTRL_GRP || p?.PTT !== m?.PTT) && (f.value = u.value[0]?.MTRL_CD)
          });
          const _ = R(() => f1.has(r.pdtCode) ? "기종" : r.pdtCode === "PHFRDIA" ? "액자" : "자재");
          return (p, m) => (g(), V(fe, {
            title: _.value,
            extra: p.showExtra ? {
              name: "주문가능자재",
              callback: d
            } : null
          }, {
            default: ce(() => [de(S("select", {
              "onUpdate:modelValue": m[0] || (m[0] = v => f.value = v),
              class: "basic-select",
              name: "material",
              onChange: h
            }, [(g(!0), M(J, null, he(c.value, v => (g(), M("option", {
              key: v.MTRL_CD,
              value: v.MTRL_CD,
              disabled: v.HIDE_YN === "Y"
            }, j(v.HIDE_YN !== "Y" ? c.value.length === 1 ? v.PTT_NM : v.MTRL_NM || v.PTT_NM : `[${v.HIDE_RSN||T(x)("주문불가")}] ${v.MTRL_NM}`) + " " + j(v.BSN_YN === "Y" ? "[영업주문]" : ""), 9, MO))), 128))], 544), [
              [We, f.value]
            ])]),
            _: 1
          }, 8, ["title", "extra"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    LO = {
      class: "inputs"
    },
    $O = ["disabled"],
    xO = {
      class: "notes"
    },
    FO = {
      key: 0,
      class: "note red"
    },
    UO = {
      class: "note red"
    },
    BO = {
      class: "inputs"
    },
    VO = ["value"],
    HO = {
      key: 0,
      class: "notes"
    },
    GO = {
      class: "note red"
    },
    jO = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = Ve(),
            a = H("select"),
            i = () => {
              a.value = a.value === "input" ? "select" : "input"
            },
            l = R(() => z_.has(s.pdtCode) ? !0 : r.uploadType.default === "pdf"),
            c = R(() => n.options.find(A => A.DFT_YN === "Y") || n.options[0]),
            u = R(() => c.value?.MIN_PRN_CNT || 1),
            d = R(() => c.value?.DFT_PRN_CNT || 1),
            h = R(() => {
              if (n.options.length > 1) return n.options;
              const A = d.value,
                b = u.value,
                C = A * 10,
                y = [];
              for (let I = b; I <= C; I += A) {
                const w = {
                  PRN_CNT: I
                };
                y.push(w)
              }
              return y
            }),
            f = H(n.default?.ordCnt || 13),
            _ = H(n.default?.prnCnt || u.value),
            p = R(() => ({
              ordCnt: f.value,
              prnCnt: _.value
            })),
            m = R(() => {
              const A = n.relatedData?.dosu === "SID_D" ? 2 : 1;
              return (f.value * A).toLocaleString()
            }),
            v = R(() => n.relatedData?.size === "mini" || r.uploadType.default === "editor"),
            E = R(() => n.relatedData?.size === "mini" ? 13 : s.pdtCode === "TPCLECO" ? 14 : 24),
            k = R(() => {
              if (d.value === 1) return !1;
              const A = p.value.prnCnt % d.value;
              return d.value > 1 && A !== 0
            }),
            N = R(() => p.value.ordCnt < 13 || p.value.ordCnt > E.value);
          F(() => p.value, un(A => {
            k.value ? o("update", {
              ordCnt: f.value,
              prnCnt: 0
            }) : N.value ? o("update", {
              ordCnt: 0,
              prnCnt: _.value
            }) : o("update", A)
          }, 200), {
            immediate: !0
          });
          const D = () => {
              if (k.value) {
                const A = Math.ceil(p.value.prnCnt / d.value);
                _.value = (A || 1) * d.value
              }
            },
            O = () => {
              N.value && (p.value.ordCnt < 13 && (f.value = 13), p.value.ordCnt > E.value && (f.value = E.value))
            };
          return F(() => r.editorData?.default?.quantityInfo?.ordCnt, (A, b) => {
            if (A) f.value = A;
            else if (b) return f.value = 13
          }), (A, b) => (g(), V(fe, null, {
            default: ce(() => [l.value ? (g(), V(fe, {
              key: 0,
              title: "디자인수"
            }, {
              default: ce(() => [S("div", LO, [de(S("input", {
                "onUpdate:modelValue": b[0] || (b[0] = C => f.value = C),
                type: "number",
                class: we(["basic-input", "-fixed-w"]),
                id: "ORD_CNT",
                min: "13",
                disabled: v.value,
                onFocusout: O
              }, null, 40, $O), [
                [yt, f.value]
              ]), Po(" " + j(T(x)("장")), 1)]), S("div", xO, [T(r).uploadType.default === "pdf" ? (g(), M("p", FO, " * " + j(`${T(x)("PDF장수안내",{QTY:m.value})}`), 1)) : oe("", !0), S("p", UO, "* " + j(T(x)("달력디자인수설명", {
                MAX_CNT: `${E.value}`
              })), 1)]), b[3] || (b[3] = S("br", null, null, -1))]),
              _: 1
            })) : oe("", !0), K(fe, {
              title: "수량"
            }, {
              default: ce(() => [S("div", BO, [a.value === "input" ? de((g(), M("input", {
                key: 0,
                "onUpdate:modelValue": b[1] || (b[1] = C => _.value = C),
                type: "number",
                class: we(["basic-input", "-fixed-w"]),
                id: "PRN_CNT",
                min: "1",
                onFocusout: D
              }, null, 544)), [
                [yt, _.value]
              ]) : de((g(), M("select", {
                key: 1,
                "onUpdate:modelValue": b[2] || (b[2] = C => _.value = C),
                name: "PRN_CNT",
                class: we(["basic-select", "-fixed-w"])
              }, [(g(!0), M(J, null, he(h.value, C => (g(), M("option", {
                value: C.PRN_CNT,
                key: C.PRN_CNT
              }, j(C.PRN_CNT), 9, VO))), 128))], 512)), [
                [We, _.value]
              ]), Po(" " + j(T(x)("개")) + " ", 1), S("button", {
                type: "button",
                class: "action-btn",
                onClick: i
              }, j(a.value === "input" ? T(x)("수량선택") : T(x)("직접입력")), 1)]), d.value !== 1 ? (g(), M("div", HO, [S("p", GO, " * " + j(T(x)("최소단위수량안내", {
                MIN_QTY: `${u.value}`,
                UNIT_QTY: d.value % 2 === 0 ? T(x)("짝수") : T(x)("홀수")
              })), 1)])) : oe("", !0)]),
              _: 1
            })]),
            _: 1
          }))
        }
      }), [
        ["__scopeId", "data-v-129f13ef"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    zO = {
      class: "qty-group"
    },
    YO = {
      class: "title"
    },
    KO = {
      class: "subject"
    },
    WO = {
      class: "subject"
    },
    qO = {
      class: "inputs"
    },
    QO = ["value"],
    XO = {
      class: "icon-box"
    },
    JO = ["value"],
    ZO = {
      class: "notes"
    },
    eI = {
      key: 0,
      class: "note"
    },
    tI = {
      key: 1,
      class: "note"
    },
    nI = {
      key: 2,
      class: "note"
    },
    oI = {
      key: 3,
      class: "note"
    },
    sI = {
      key: 4,
      class: "note red"
    },
    rI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            r = R(() => s.editorData?.default?.cntInfo?.initCnt),
            a = R(() => s.editorData?.default?.cntInfo?.totalCnt),
            i = R(() => (a.value || 0) / (r.value || 0)),
            l = R(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: c,
                type: u
              } = n.expressShipping;
              if (!(c === 0 || c >= (a.value || 0))) {
                if (u === "Y") return x("오늘출발-불가능");
                if (u === "T") return x("내일출발-불가능")
              }
            });
          return F(() => s.editorData?.default?.quantityInfo, c => {
            const u = c?.prnCnt || 1;
            o("update", {
              ordCnt: c?.ordCnt || 1,
              prnCnt: u < n.defaultSetCnt ? n.defaultSetCnt : u
            })
          }, {
            immediate: !0
          }), (c, u) => {
            const d = on("dompurify-html");
            return g(), V(fe, null, {
              default: ce(() => [S("div", zO, [S("div", YO, [S("h2", KO, j(T(x)("세트별수량")), 1), S("h2", WO, j(T(x)("세트")), 1)]), S("div", qO, [S("input", {
                type: "number",
                class: "basic-input",
                id: "unitQty",
                maxlength: "6",
                min: "1",
                value: r.value,
                disabled: ""
              }, null, 8, QO), S("div", XO, [K(Kr)]), S("input", {
                type: "number",
                class: "basic-input",
                id: "setQty",
                maxlength: "6",
                min: "1",
                value: i.value,
                disabled: ""
              }, null, 8, JO)]), S("div", ZO, [a.value ? de((g(), M("p", tI, null, 512)), [
                [d, T(x)("주문수량안내", {
                  QTY: a.value.toLocaleString() + T(x)("개")
                })]
              ]) : (g(), M("p", eI, "* " + j(T(x)("세트수량안내")), 1)), c.canEditOrdCnt.pdf && c.canEditOrdCnt.editor ? (g(), M("p", nI, "* " + j(T(x)("디자인건수가능여부-전체")), 1)) : !c.canEditOrdCnt.pdf && c.canEditOrdCnt.editor ? (g(), M("p", oI, " * " + j(T(x)("디자인건수가능여부-에디터")), 1)) : oe("", !0), l.value ? de((g(), M("p", sI, null, 512)), [
                [d, l.value]
              ]) : oe("", !0)])])]),
              _: 1
            })
          }
        }
      }), [
        ["__scopeId", "data-v-aa32054c"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    iI = {
      class: "qty-group"
    },
    aI = {
      class: "title"
    },
    lI = {
      class: "subject"
    },
    uI = {
      class: "inputs"
    },
    cI = ["value"],
    dI = {
      class: "notes"
    },
    fI = {
      class: "note"
    },
    pI = {
      key: 0,
      class: "note red"
    },
    _I = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Be(re({
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
            s = le("productCode", {
              pdtCode: ""
            }),
            r = H("select"),
            a = () => {
              r.value = r.value === "input" ? "select" : "input", r.value === "select" && (h.value.find(A => A.PRN_CNT === _.value) || (_.value = l.value))
            },
            i = R(() => n.options.find(O => O.DFT_YN === "Y") || n.options[0]),
            l = R(() => i.value?.DFT_PRN_CNT || 1),
            c = R(() => i.value?.MIN_PRN_CNT || 1),
            u = R(() => i.value?.INC_CNT || 1),
            d = R(() => i.value?.INC_STEP || 10),
            h = R(() => {
              if (n.options.length > 1) return n.options;
              const O = [];
              for (let A = c.value; O.length < d.value; A += u.value) {
                const b = {
                  PRN_CNT: A
                };
                O.push(b)
              }
              return O
            }),
            f = H(n.default?.ordCnt || 1),
            _ = H(n.default?.prnCnt || l.value || c.value),
            p = R(() => ({
              ordCnt: f.value,
              prnCnt: _.value
            })),
            m = {
              STDRCAD: {
                name: "세트",
                qtyPerSet: 2
              },
              STTBDFT: {
                name: "세트",
                qtyPerSet: 10
              },
              TPCAPTW: {
                name: "세트",
                qtyPerSet: 20
              }
            },
            v = R(() => (f.value * _.value).toLocaleString()),
            E = R(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: O,
                type: A
              } = n.expressShipping;
              if (!(O === 0 || O >= +v.value)) {
                if (A === "Y") return x("오늘출발-불가능");
                if (A === "T") return x("내일출발-불가능")
              }
            }),
            k = R(() => {
              if (!_.value) return !0;
              if (u.value !== 1) {
                const O = _.value % u.value;
                if (u.value > 1 && O !== 0) return !0
              }
              return !1
            }),
            N = R(() => !f.value),
            D = () => {
              if (!_.value) return _.value = 1;
              if (u.value !== 1) {
                const O = _.value % u.value;
                if (u.value > 1 && O !== 0) {
                  const A = Math.ceil(_.value / u.value);
                  _.value = (A || 1) * u.value
                }
              }
            };
          return F(() => p.value, un(O => {
            k.value || N.value || o("update", O)
          }, 300), {
            immediate: !0
          }), (O, A) => {
            const b = on("dompurify-html");
            return g(), V(fe, null, {
              default: ce(() => [S("div", iI, [S("div", aI, [S("h2", lI, j(T(x)("수량")), 1)]), S("div", uI, [r.value === "input" ? de((g(), M("input", {
                key: 0,
                "onUpdate:modelValue": A[0] || (A[0] = C => _.value = C),
                type: "number",
                class: "basic-input",
                id: "PRN_CNT",
                min: "1",
                onFocusout: D
              }, null, 544)), [
                [yt, _.value]
              ]) : de((g(), M("select", {
                key: 1,
                "onUpdate:modelValue": A[1] || (A[1] = C => _.value = C),
                name: "PRN_CNT",
                class: "basic-select"
              }, [(g(!0), M(J, null, he(h.value, C => (g(), M("option", {
                value: C.PRN_CNT,
                key: C.PRN_CNT
              }, j(C.PRN_CNT), 9, cI))), 128))], 512)), [
                [We, _.value]
              ]), S("button", {
                type: "button",
                class: "action-btn",
                onClick: a
              }, j(r.value === "input" ? T(x)("수량선택") : T(x)("직접입력")), 1)])]), S("div", dI, [de(S("p", fI, null, 512), [
                [b, T(x)("주문수량안내", {
                  QTY: `${v.value}${T(x)(m[T(s).pdtCode].name)}`
                }) + ` (${m[T(s).pdtCode].qtyPerSet}${O.unit}/1${T(x)(m[T(s).pdtCode].name)})`]
              ]), E.value ? de((g(), M("p", pI, null, 512)), [
                [b, E.value]
              ]) : oe("", !0)])]),
              _: 1
            })
          }
        }
      }), [
        ["__scopeId", "data-v-29abd9de"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    })),
    hI = ["value"],
    mI = {
      class: "notes"
    },
    vI = {
      key: 0,
      class: "note"
    },
    gI = {
      key: 1,
      class: "note"
    },
    yI = {
      key: 2,
      class: "note"
    },
    CI = {
      key: 3,
      class: "note"
    },
    TI = {
      key: 4,
      class: "note red"
    },
    bI = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: re({
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
            r = R(() => s.editorData?.default?.cntInfo?.totalCnt),
            a = R(() => s.editorData?.default?.quantityInfo?.ordCnt),
            i = R(() => {
              if (!n.expressShipping) return;
              const {
                maxQty: l,
                type: c
              } = n.expressShipping;
              if (!(l === 0 || l >= (r.value || 0))) {
                if (c === "Y") return x("오늘출발-불가능");
                if (c === "T") return x("내일출발-불가능")
              }
            });
          return F(() => s.editorData?.default?.quantityInfo, l => {
            o("update", {
              ordCnt: l?.ordCnt || 1,
              prnCnt: l?.prnCnt || 1
            })
          }, {
            immediate: !0
          }), (l, c) => {
            const u = on("dompurify-html");
            return g(), V(fe, {
              title: "총수량"
            }, {
              default: ce(() => [S("input", {
                type: "number",
                class: "basic-input",
                id: "totalQty",
                maxlength: "6",
                min: "1",
                value: r.value,
                disabled: ""
              }, null, 8, hI), S("div", mI, [a.value ? de((g(), M("p", gI, null, 512)), [
                [u, T(x)("디자인건수안내").replace("{QTY}", `${a.value}`)]
              ]) : (g(), M("p", vI, "* " + j(T(x)("세트수량안내")), 1)), l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor ? (g(), M("p", yI, "* " + j(T(x)("디자인건수가능여부-전체")), 1)) : !l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor ? (g(), M("p", CI, " * " + j(T(x)("디자인건수가능여부-에디터")), 1)) : oe("", !0), i.value ? de((g(), M("p", TI, null, 512)), [
                [u, i.value]
              ]) : oe("", !0)])]),
              _: 1
            })
          }
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }))
})();