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
