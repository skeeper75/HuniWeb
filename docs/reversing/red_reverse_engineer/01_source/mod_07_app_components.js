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
