/* =========================================================================
 섹션 1: 의류(Apparel) — 인쇄 영역 컴포넌트 (계속)
 의류 상품의 인쇄 영역(front, leftchest 등)을 아이콘 체크박스로 선택하는 UI.
 DTF/직접인쇄/실크인쇄 유형에 따라 가이드 문구가 달라짐.
 ※ 이 파일은 번들 슬라이스라 line 105가 orphan `}),` 로 시작(앞 컴포넌트 setup 본문이 잘림).
 ※ [절단 복원] engineer 는 03_deobfuscated/deob_07_app_components.recovered.js (합성 HEAD/TAIL 로 브래킷 균형·babel 무에러 검증)를 --in 으로 사용할 것. 원본 절단본은 파싱 불가.
 ========================================================================= */
/**
 * 의류 멀티 사이즈 수량 컴포넌트. 사이즈별 +/- 버튼으로 수량 조절. QUICK_ORD_YN(퀵오더 가능여부)에 따라 경고 노출. __name="ApparelMultiSizeQty".
 */
/**
 * 의류 단일 사이즈 수량 컴포넌트. 사이즈 Selector + 수량 입력. 수량/사이즈 변경을 watch 해 update emit. withScopeId 로 scoped CSS 적용. __name="ApparelSingleSizeQty".
 */
/**
 * 의류 사이즈 구분(성인/아동) 라디오 컴포넌트. props.options 를 성인/아동으로 분류해 RadioList 로 렌더, 선택 시 update emit. __name="ApparelSizeGbn".
 */
const CS = {
    class: "widget-error",
  },
  TS = {
    key: 0,
    class: "reason",
  },
  bS = withScopeId(
    defineComponent({
      __name: "Error",
      props: {
        message: {},
      },
      setup(e) {
        return (t, n) => (
          openBlock(),
          createElementVNode("div", CS, [
            n[0] || (n[0] = createElement("p", null, "주문 위젯을 생성할 수 없습니다 😱", -1)),
            t.message
              ? (openBlock(), createElementVNode("p", TS, toDisplayString(t.message), 1))
              : createCommentVNode("", !0),
          ])
        );
      },
    }),
    [["__scopeId", "data-v-33e3660e"]]
  ),
  SS = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "Digital",
          props: {
            type: {
              default: "new",
            },
            data: {},
            widgetAttr: {},
            defaultData: {},
            senecaInfo: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = computed(() => n.data.pdt_base_info[0].PDT_CD),
              r = computed(() => n.widgetAttr.skinInfo),
              a = inject("member"),
              i = computed(() => {
                if (!n.data.option_info) return !1;
                const { shape_info: B } = n.data.option_info;
                return !isEmpty(B) && !!B[0].COD;
              }),
              l = computed(() =>
                a?.bsn_yn === "Y"
                  ? n.data.pdt_mtrl_info
                  : n.data.pdt_mtrl_info.filter((B) => B.BSN_YN !== "Y")
              ),
              c = kn(() =>
                Ul(
                  Object.assign({
                    "../options/material/Acrylic.vue": () => Promise.resolve().then(() => OS),
                    "../options/material/Basic.vue": () => Promise.resolve().then(() => kO),
                    "../options/material/Paper.vue": () => Promise.resolve().then(() => MP),
                  }),
                  `../options/material/${l.value[0].MTRL_TYPE === "R" ? "Paper" : "Basic"}.vue`,
                  4
                )
              ),
              u = computed(() => {
                const B = [...n.data.pdt_size_info];
                return !i.value || !A.value.shapeInfo || B.length === 1
                  ? B
                  : B.filter((W) => W.STICKER_TYPE === A.value.shapeInfo.COD);
              }),
              d = ref(null),
              h = (B) => {
                d.value = B;
              },
              f = computed(() => v1.has(s.value)),
              _ = reactive({}),
              p = (B) => (W) => {
                _[B] = W;
              },
              m = computed(() =>
                parsePostProcessOptions(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)
              ),
              { uploadConfig: v, canEditOrdCnt: E } = useUploadConfig(n.widgetAttr),
              k = useEditorStore(),
              N = computed(() => {
                let B =
                  a?.bsn_yn === "Y" && k.uploadType.default === "pdf"
                    ? "DesignQty"
                    : kl[s.value] || "DesignQty";
                return (
                  f.value && (B = "CalendarQty"),
                  kn(() =>
                    Ul(
                      Object.assign({
                        "../options/qty/BookQty.vue": () => Promise.resolve().then(() => EP),
                        "../options/qty/CalendarQty.vue": () => Promise.resolve().then(() => jO),
                        "../options/qty/DesignQty.vue": () => Promise.resolve().then(() => GS),
                        "../options/qty/SetQty.vue": () => Promise.resolve().then(() => rI),
                        "../options/qty/SimpleQty.vue": () => Promise.resolve().then(() => _I),
                        "../options/qty/TotalQty.vue": () => Promise.resolve().then(() => bI),
                      }),
                      `../options/qty/${B}.vue`,
                      4
                    )
                  )
                );
              }),
              D = computed(() => {
                const B = n.data.pdt_base_info[0];
                if (B.DAY_PRDC_PDT_YN !== "N")
                  return {
                    type: B.DAY_PRDC_PDT_YN,
                    maxQty: B.DAY_ABLE_PRN_CNT,
                  };
              }),
              {
                defaultOrderData: O,
                orderInfo: A,
                pcsInfo: b,
                updateOption: C,
                updatePcsOption: y,
                updatePostPcs: I,
              } = useOrderComposable(n.type, {
                group: n.widgetAttr.item_gbn,
                emits: {
                  updateOrder: (B) => o("update", B),
                },
              }),
              w = computed(() => b.value.SUB_MTR?.find((B) => B.PCS_CD === xl[s.value])),
              U = computed(() =>
                bookPageMultiplierMap[n.data.pdt_base_info[0].PDT_CD]
                  ? A.value.quantityInfo?.prnCnt || 1
                  : (A.value.quantityInfo?.ordCnt || 1) * (A.value.quantityInfo?.prnCnt || 1)
              ),
              Z = ref(null),
              me = inject("callbacks", {});
            watch(
              () => f.value,
              (B) => {
                B && u.value.length === 0 && (Z.value = "달력 사이즈 설정이 필요합니다");
              },
              {
                immediate: !0,
              }
            ),
              watch(
                () => Z.value,
                (B) => {
                  B && me?.onError && me.onError(B || "주문 위젯 에러 발생");
                },
                {
                  immediate: !0,
                }
              );
            const _e = () => {
              me?.onReset && me.onReset("fileUpload");
            };
            return (
              watch(
                () => A.value.dosuInfo?.COD,
                (B) => {
                  k.isAfterEdit() && B === "SID_X" && _e();
                }
              ),
              (B, W) =>
                Z.value
                  ? (openBlock(),
                    createVNode(
                      bS,
                      {
                        key: 0,
                        message: Z.value,
                      },
                      null,
                      8,
                      ["message"]
                    ))
                  : (openBlock(),
                    createElementVNode(
                      Fragment,
                      {
                        key: 1,
                      },
                      [
                        r.value.pageDirection.view_yn === "Y" && unref(A)?.dosuInfo?.COD !== "SID_X"
                          ? (openBlock(),
                            createVNode(
                              Y1,
                              {
                                key: 0,
                                "related-data": {
                                  sizeInfo: unref(A).sizeInfo,
                                },
                                onUpdate: W[0] || (W[0] = (ue) => unref(C)("pageDirection")(ue)),
                              },
                              null,
                              8,
                              ["related-data"]
                            ))
                          : createCommentVNode("", !0),
                        n.data.option_material_filters
                          ? (openBlock(),
                            createVNode(
                              ob,
                              {
                                key: 1,
                                options: n.data.option_material_filters,
                                onUpdate: h,
                              },
                              null,
                              8,
                              ["options"]
                            ))
                          : createCommentVNode("", !0),
                        n.data.option_info?.color_info
                          ? (openBlock(),
                            createVNode(
                              rb,
                              {
                                key: 2,
                                data: n.data.option_info?.color_info,
                                onUpdate: W[1] || (W[1] = (ue) => unref(C)("setData")(ue)),
                              },
                              null,
                              8,
                              ["data"]
                            ))
                          : createCommentVNode("", !0),
                        i.value
                          ? (openBlock(),
                            createVNode(
                              W_,
                              {
                                key: 3,
                                options: B.data.option_info?.shape_info || [],
                                default: unref(O)?.shapeInfo,
                                onUpdate: W[2] || (W[2] = (ue) => unref(C)("shapeInfo")(ue)),
                              },
                              null,
                              8,
                              ["options", "default"]
                            ))
                          : createCommentVNode("", !0),
                        withDirectives(
                          (openBlock(),
                          createVNode(
                            ns(unref(c)),
                            {
                              options: l.value,
                              default: unref(O)?.meterialInfo,
                              "reset-after-edit":
                                unref(d1).has(B.data.pdt_base_info[0].PDT_CD) &&
                                unref(k).isAfterEdit(),
                              "show-extra": B.widgetAttr.able_paper_yn === "Y",
                              "related-data": {
                                POST_PCS: w.value,
                                filters: d.value,
                              },
                              onUpdate: W[3] || (W[3] = (ue) => unref(C)("meterialInfo")(ue)),
                            },
                            null,
                            40,
                            ["options", "default", "reset-after-edit", "show-extra", "related-data"]
                          )),
                          [[vShow, r.value.paperSelect.view_yn === "Y"]]
                        ),
                        withDirectives(
                          renderComponent(
                            q_,
                            {
                              options: B.data.pdt_dosu_info,
                              default: unref(O)?.dosuInfo,
                              "related-data": {
                                mtrlCd: unref(A).meterialInfo?.MTRL_CD,
                                mtrlDosu: unref(A).meterialInfo?.SID_GBN,
                              },
                              onUpdate: W[4] || (W[4] = (ue) => unref(C)("dosuInfo")(ue)),
                            },
                            null,
                            8,
                            ["options", "default", "related-data"]
                          ),
                          [[vShow, r.value.dosuSelect.view_yn === "Y" && B.data.pdt_dosu_info]]
                        ),
                        B.data.option_info?.thickness_info
                          ? (openBlock(),
                            createVNode(
                              lb,
                              {
                                key: 4,
                                options: B.data.option_info.thickness_info,
                                onUpdate: W[5] || (W[5] = (ue) => p("thickness")(ue)),
                              },
                              null,
                              8,
                              ["options"]
                            ))
                          : createCommentVNode("", !0),
                        withDirectives(
                          renderComponent(
                            SizeSelect,
                            {
                              options: u.value,
                              "base-info": B.data.pdt_base_info[0],
                              default: unref(O)?.size,
                              "related-data": {
                                shape: unref(A).shapeInfo?.COD,
                                sizeFromPostPcs: B.data.pdt_base_info[0].SIZE_PCS_USE
                                  ? _.sizeFromPostPcs
                                  : null,
                                pageDirection: unref(A).pageDirection?.COD,
                              },
                              onUpdate: W[6] || (W[6] = (ue) => unref(C)("sizeInfo")(ue)),
                              onValidate: W[7] || (W[7] = (ue) => unref(C)("validation")(ue)),
                              "onUpdate:shape": W[8] || (W[8] = (ue) => p("shapeFromSize")(ue)),
                            },
                            null,
                            8,
                            ["options", "base-info", "default", "related-data"]
                          ),
                          [
                            [
                              vShow,
                              r.value.sizeSelect.view_yn === "Y" &&
                                unref(A)?.dosuInfo?.COD !== "SID_X",
                            ],
                          ]
                        ),
                        f.value &&
                        unref(k).uploadType.default === "editor" &&
                        !unref(calendarPdfOnlySet).has(s.value)
                          ? (openBlock(),
                            createVNode(Ab, {
                              key: 5,
                              onUpdate: W[9] || (W[9] = (ue) => unref(C)("calendarInfo")(ue)),
                            }))
                          : createCommentVNode("", !0),
                        r.value.quantityGroup.view_yn === "Y"
                          ? (openBlock(),
                            createVNode(
                              ns(N.value),
                              {
                                key: 6,
                                "can-edit-ord-cnt": unref(E),
                                options: B.data.pdt_prn_cnt_info,
                                default: unref(O)?.quantityInfo,
                                "default-set-cnt": B.data.pdt_base_info[0].SET_CNT,
                                unit: B.data.pdt_base_info[0].PDT_UNIT,
                                "related-data": {
                                  dosu: unref(A).dosuInfo?.COD,
                                  size: unref(A).sizeInfo?.DIV_NM,
                                },
                                "express-shipping": D.value,
                                onUpdate: W[10] || (W[10] = (ue) => unref(C)("quantityInfo")(ue)),
                              },
                              null,
                              40,
                              [
                                "can-edit-ord-cnt",
                                "options",
                                "default",
                                "default-set-cnt",
                                "unit",
                                "related-data",
                                "express-shipping",
                              ]
                            ))
                          : createCommentVNode("", !0),
                        r.value.subjectGroup.view_yn === "Y"
                          ? (openBlock(),
                            createVNode(
                              SubjectGroup,
                              {
                                key: 7,
                                "is-biz-mem": unref(a)?.bsn_yn === "Y",
                                onUpdate: W[11] || (W[11] = (ue) => unref(C)("etcInfo")(ue)),
                              },
                              null,
                              8,
                              ["is-biz-mem"]
                            ))
                          : createCommentVNode("", !0),
                        renderComponent(
                          HiddenPostProcess,
                          {
                            options: m.value.postPcs.hidden,
                            "related-data": {
                              shape: unref(A).shapeInfo?.COD || _.shapeFromSize,
                              mtrlCd: unref(A).meterialInfo?.MTRL_CD,
                              sizeInfo: unref(A).sizeInfo,
                              thickness: _.thickness,
                              orderQty: U.value,
                              dosu: unref(A).dosuInfo?.COD,
                            },
                            "disabled-opts": m.value.disabled,
                            onUpdate: W[12] || (W[12] = (ue) => unref(I)("hidden")(ue)),
                          },
                          null,
                          8,
                          ["options", "related-data", "disabled-opts"]
                        ),
                        renderComponent(
                          VisiblePostProcess,
                          {
                            options: m.value.postPcs.visible,
                            "related-data": {
                              mtrlCd: unref(A).meterialInfo?.MTRL_CD,
                              sizeInfo: unref(A).sizeInfo,
                              orderQty: U.value,
                            },
                            "attb-opts": B.data.pdt_add_info[1],
                            "disabled-opts": m.value.disabled,
                            onUpdate: W[13] || (W[13] = (ue) => unref(I)("visible")(ue)),
                          },
                          null,
                          8,
                          ["options", "related-data", "attb-opts", "disabled-opts"]
                        ),
                        renderComponent(
                          Jb,
                          {
                            options: m.value.sub,
                            "related-data": {
                              orderQty: U.value,
                              sizeInfo: unref(A).sizeInfo,
                              mtrlCd: unref(A).meterialInfo?.MTRL_CD,
                              pcsCodeForSize: B.data.pdt_base_info[0].SIZE_PCS_USE,
                              setData: unref(A)?.setData,
                            },
                            onUpdate: W[14] || (W[14] = (ue) => unref(y)("SUB_MTR")(ue)),
                            "onUpdate:size": W[15] || (W[15] = (ue) => p("sizeFromPostPcs")(ue)),
                          },
                          null,
                          8,
                          ["options", "related-data"]
                        ),
                        B.widgetAttr.order_yn !== "N" && unref(A).dosuInfo?.COD !== "SID_X"
                          ? (openBlock(),
                            createVNode(
                              FileUpload,
                              {
                                key: 8,
                                "upload-config": unref(v),
                                "show-extra":
                                  B.widgetAttr.useTemplateDownload === "Y" &&
                                  B.widgetAttr.usePDF === "Y",
                                "related-data": {
                                  size: unref(A).sizeInfo,
                                },
                                onUpload: W[16] || (W[16] = (ue) => unref(C)("fileUploadInfo")(ue)),
                              },
                              null,
                              8,
                              ["upload-config", "show-extra", "related-data"]
                            ))
                          : createCommentVNode("", !0),
                      ],
                      64
                    ))
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  DS = defineComponent({
    __name: "Method",
    props: {
      options: {},
      default: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useI18n(),
        r = inject("productCode", {
          pdtCode: "",
        }),
        a = inject("callbacks", {}),
        i = inject("deviceType", "pc"),
        l = computed(() =>
          n.options.map((h) => ({
            name: h.COD_NME,
            value: h.COD,
            key: h.COD,
          }))
        ),
        c = ref(n.default || l.value[0].value),
        u = (h) => {
          c.value = h;
        },
        d = computed(() =>
          n.options.map((h, f) => ({
            IDX: f + 1,
            CATEGORY: t("제작방식"),
            LABEL: n.options[f].COD_NME,
            IMG_URL: `${CDN_BASE_URL}/${s.locale}/item/print_method/${h.COD}/${r.pdtCode}.png`,
            IMG_ALT: h.COD_NME,
          }))
        );
      return (
        watch(
          () => c.value,
          (h) => {
            const f = n.options.find((_) => _.COD == h);
            o("update", f);
          },
          {
            immediate: !0,
          }
        ),
        (h, f) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "제작방식",
              option: "Method",
              extra:
                unref(i) === "mobile" && d.value
                  ? {
                      name: "자세히보기",
                      callback: () => {
                        unref(a).onInformOptionTips && unref(a).onInformOptionTips(d.value);
                      },
                      style: "tip",
                    }
                  : null,
            },
            {
              default: withCtx(() => [
                renderComponent(
                  SizeSelector,
                  {
                    options: l.value,
                    default: c.value,
                    tips: d.value,
                    onSelect: u,
                  },
                  null,
                  8,
                  ["options", "default", "tips"]
                ),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        )
      );
    },
  }),
  PS = defineComponent({
    __name: "AcrylicPrintData",
    props: {
      options: {},
      default: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useI18n(),
        r = useEditorStore(),
        a = inject("productCode", {
          pdtCode: "",
        }),
        i = inject("callbacks", {}),
        l = inject("deviceType", "pc"),
        c = computed(() =>
          n.options.map((_) => ({
            name: _.COD_NME,
            value: _.COD,
            key: _.COD,
          }))
        ),
        u = ref(n.default || c.value[0].value),
        d = (_) => {
          u.value = _;
        },
        h = {
          O: new Set(["ACTHBCO", "ACTHDCO"]),
          X: new Set(["ACTHBCO", "ACTHDCO", "ACTHFCO"]),
        },
        f = computed(() =>
          n.options.map((_, p) => ({
            IDX: p + 1,
            CATEGORY: t("인쇄데이터"),
            LABEL: n.options[p].COD_NME,
            IMG_URL: h[_.COD].has(a.pdtCode)
              ? `${CDN_BASE_URL}/${s.locale}/item/printdata/${_.COD}/${a.pdtCode}.png`
              : `${CDN_BASE_URL}/${s.locale}/item/printdata/${_.COD}/default.png`,
            IMG_ALT: _.COD_NME,
          }))
        );
      return (
        watch(
          () => u.value,
          (_) => {
            r.isAfterEdit() && i?.onReset && i.onReset("printData");
            const p = n.options.find((m) => m.COD === _);
            o("update", p);
          },
          {
            immediate: !0,
          }
        ),
        (_, p) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "인쇄데이터",
              extra:
                unref(l) === "mobile" && f.value
                  ? {
                      name: "자세히보기",
                      callback: () => {
                        unref(i).onInformOptionTips && unref(i).onInformOptionTips(f.value);
                      },
                      style: "tip",
                    }
                  : null,
            },
            {
              default: withCtx(() => [
                renderComponent(
                  SizeSelector,
                  {
                    options: c.value,
                    default: u.value,
                    tips: f.value,
                    onSelect: d,
                  },
                  null,
                  8,
                  ["options", "default", "tips"]
                ),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        )
      );
    },
  }),
  ES = ["value", "disabled"],
  nh = defineComponent({
    __name: "Acrylic",
    props: {
      options: {},
      showExtra: {
        type: Boolean,
        default: !1,
      },
      default: {},
      resetAfterEdit: {
        type: Boolean,
      },
      relatedData: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = inject("callbacks", {}),
        r = inject("productCode", {
          pdtCode: "",
        }),
        a = useI18n(),
        i = computed(() => {
          const h = n.options.filter((f) => f.GRP_OPTION_CD === n.relatedData?.method);
          return h.length > 0 ? h : n.options;
        }),
        l = computed(() => i.value.filter((h) => h.HIDE_YN !== "Y")),
        c = ref(n.default?.MTRL_CD || l.value[0]?.MTRL_CD),
        u = async () => {
          const h = await fetchMaterialInfo({
            pdt_cod: r.pdtCode,
            lang: a.locale,
          });
          if (!h) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
          s?.onInformMaterials
            ? s.onInformMaterials(h)
            : console.log("[RedWidgetSDK] 자재 정보 >", h);
        },
        d = () => {
          n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
        };
      return (
        watch(
          () => c.value,
          (h) => {
            const f = l.value.find((_) => _.MTRL_CD === h);
            if (f) {
              const {
                PTT_CD: _,
                PTT_NM: p,
                WGT_CD: m,
                CLR_CD: v,
                MTRL_CD: E,
                MTRL_NM: k,
                MTRL_TYPE: N,
                PRT_HIDE_YN: D,
              } = f;
              o("update", {
                PTT_CD: _,
                PTT_NM: p,
                WGT_CD: m,
                CLR_CD: v,
                MTRL_CD: E,
                MTRL_NM: k,
                MTRL_TYPE: N,
                PRT_HIDE_YN: D,
              }),
                _ === "OOO" && s?.onSaleOrder && s?.onSaleOrder(),
                d();
            }
          },
          {
            immediate: !0,
          }
        ),
        watch(
          () => n.relatedData?.method,
          (h) => {
            h && (c.value = l.value[0]?.MTRL_CD);
          }
        ),
        (h, f) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "자재",
              extra: h.showExtra
                ? {
                    name: "주문가능자재",
                    callback: u,
                  }
                : null,
            },
            {
              default: withCtx(() => [
                withDirectives(
                  createElement(
                    "select",
                    {
                      "onUpdate:modelValue": f[0] || (f[0] = (_) => (c.value = _)),
                      class: "basic-select",
                      name: "material",
                      onChange: d,
                    },
                    [
                      (openBlock(!0),
                      createElementVNode(
                        Fragment,
                        null,
                        renderList(
                          i.value,
                          (_) => (
                            openBlock(),
                            createElementVNode(
                              "option",
                              {
                                key: _.MTRL_CD,
                                value: _.MTRL_CD,
                                disabled: _.HIDE_YN === "Y",
                              },
                              toDisplayString(
                                _.HIDE_YN !== "Y"
                                  ? _.MTRL_NM
                                  : `[${_.HIDE_RSN || unref(t)("주문불가")}] ${_.MTRL_NM}`
                              ) +
                                " " +
                                toDisplayString(_.BSN_YN === "Y" ? "[영업주문]" : ""),
                              9,
                              ES
                            )
                          )
                        ),
                        128
                      )),
                    ],
                    544
                  ),
                  [[vModelSelect, c.value]]
                ),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        )
      );
    },
  }),
  OS = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: nh,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  IS = {
    class: "qty-group",
  },
  RS = {
    class: "title",
  },
  wS = {
    class: "subject",
  },
  AS = {
    class: "subject",
  },
  NS = {
    class: "inputs",
  },
  MS = ["disabled"],
  kS = {
    class: "icon-box",
  },
  LS = ["value"],
  $S = {
    class: "notes",
  },
  xS = {
    class: "note",
  },
  FS = {
    key: 0,
    class: "note",
  },
  US = {
    key: 1,
    class: "note",
  },
  BS = {
    key: 2,
    class: "note",
  },
  VS = {
    key: 3,
    class: "note",
  },
  HS = {
    key: 4,
    class: "note red",
  },
  oh = withScopeId(
    defineComponent({
      __name: "DesignQty",
      props: {
        options: {},
        default: {},
        relatedData: {},
        canEditOrdCnt: {},
        expressShipping: {},
        unit: {},
      },
      emits: ["update"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = inject("productCode", {
            pdtCode: "",
          }),
          r = useEditorStore(),
          a = ref("select"),
          i = () => {
            (a.value = a.value === "input" ? "select" : "input"),
              a.value === "select" &&
                (f.value.find((y) => y.PRN_CNT === p.value) || (p.value = c.value));
          },
          l = computed(() => n.options.find((C) => C.DFT_YN === "Y") || n.options[0]),
          c = computed(() => l.value?.DFT_PRN_CNT || 1),
          u = computed(() => l.value?.MIN_PRN_CNT || 1),
          d = computed(() => l.value?.INC_CNT || 1),
          h = computed(() => l.value?.INC_STEP || 10),
          f = computed(() => {
            if (n.options.length > 1) return n.options;
            const C = [];
            for (let y = u.value; C.length < h.value; y += d.value) {
              const I = {
                PRN_CNT: y,
              };
              C.push(I);
            }
            return C;
          }),
          _ = ref(n.default?.ordCnt || 1),
          p = ref(n.default?.prnCnt || c.value || u.value),
          m = computed(() => ({
            ordCnt: _.value,
            prnCnt: p.value,
          })),
          v = computed(() => (_.value * p.value).toLocaleString()),
          E = computed(() => {
            if (!n.expressShipping) return;
            const { maxQty: C, type: y } = n.expressShipping;
            if (!(C === 0 || C >= +v.value)) {
              if (y === "Y") return t("오늘출발-불가능");
              if (y === "T") return t("내일출발-불가능");
            }
          }),
          k = computed(() => {
            const C = h1[s.pdtCode] || (n.relatedData?.dosu === "SID_D" ? 2 : 1);
            return (_.value * C).toLocaleString();
          }),
          N = computed(() => r.uploadType.default === "editor"),
          D = computed(() => {
            if (!p.value) return !0;
            if (d.value !== 1) {
              const C = p.value % d.value;
              if (d.value > 1 && C !== 0) return !0;
            }
            return !1;
          }),
          O = computed(() => !_.value),
          A = () => {
            if (!p.value) return (p.value = 1);
            if (d.value !== 1) {
              const C = p.value % d.value;
              if (d.value > 1 && C !== 0) {
                const y = Math.ceil(p.value / d.value);
                p.value = (y || 1) * d.value;
              }
            }
          },
          b = () => {
            if (!_.value) return (_.value = 1);
          };
        return (
          watch(
            () => m.value,
            debounce((C) => {
              D.value || O.value || o("update", C);
            }, 300),
            {
              immediate: !0,
            }
          ),
          watch(
            () => r.editorData?.default?.quantityInfo?.ordCnt,
            (C, y) => {
              if (C) _.value = C;
              else if (y) return (_.value = 1);
            }
          ),
          watch(
            () => r.uploadType.default,
            (C) => {
              C === "editor" && (_.value = 1);
            }
          ),
          (C, y) => {
            const I = resolveDirective("dompurify-html");
            return (
              openBlock(),
              createVNode(OptionRow, null, {
                default: withCtx(() => [
                  createElement("div", IS, [
                    createElement("div", RS, [
                      createElement("h2", wS, toDisplayString(unref(t)("디자인수")), 1),
                      createElement("h2", AS, toDisplayString(unref(t)("수량")), 1),
                    ]),
                    createElement("div", NS, [
                      withDirectives(
                        createElement(
                          "input",
                          {
                            "onUpdate:modelValue": y[0] || (y[0] = (w) => (_.value = w)),
                            type: "number",
                            class: "basic-input",
                            id: "ORD_CNT",
                            min: "1",
                            disabled: N.value || !C.canEditOrdCnt.pdf,
                            onFocusout: b,
                          },
                          null,
                          40,
                          MS
                        ),
                        [[vModelText, _.value]]
                      ),
                      createElement("div", kS, [renderComponent(CloseIcon)]),
                      a.value === "input"
                        ? withDirectives(
                            (openBlock(),
                            createElementVNode(
                              "input",
                              {
                                key: 0,
                                "onUpdate:modelValue": y[1] || (y[1] = (w) => (p.value = w)),
                                type: "number",
                                class: "basic-input",
                                id: "PRN_CNT",
                                min: "1",
                                onFocusout: A,
                              },
                              null,
                              544
                            )),
                            [[vModelText, p.value]]
                          )
                        : withDirectives(
                            (openBlock(),
                            createElementVNode(
                              "select",
                              {
                                key: 1,
                                "onUpdate:modelValue": y[2] || (y[2] = (w) => (p.value = w)),
                                name: "PRN_CNT",
                                class: "basic-select",
                              },
                              [
                                (openBlock(!0),
                                createElementVNode(
                                  Fragment,
                                  null,
                                  renderList(
                                    f.value,
                                    (w) => (
                                      openBlock(),
                                      createElementVNode(
                                        "option",
                                        {
                                          value: w.PRN_CNT,
                                          key: w.PRN_CNT,
                                        },
                                        toDisplayString(w.PRN_CNT),
                                        9,
                                        LS
                                      )
                                    )
                                  ),
                                  128
                                )),
                              ],
                              512
                            )),
                            [[vModelSelect, p.value]]
                          ),
                      createElement(
                        "button",
                        {
                          type: "button",
                          class: "action-btn",
                          onClick: i,
                        },
                        toDisplayString(
                          a.value === "input" ? unref(t)("수량선택") : unref(t)("직접입력")
                        ),
                        1
                      ),
                    ]),
                  ]),
                  createElement("div", $S, [
                    withDirectives(createElement("p", xS, null, 512), [
                      [
                        I,
                        unref(t)("주문수량안내", {
                          QTY: v.value + (C.unit || unref(t)("개")),
                        }),
                      ],
                    ]),
                    u.value > 1
                      ? withDirectives((openBlock(), createElementVNode("p", FS, null, 512)), [
                          [
                            I,
                            unref(t)("단위주문수량안내", {
                              QTY: `${u.value}`,
                            }),
                          ],
                        ])
                      : createCommentVNode("", !0),
                    N.value
                      ? createCommentVNode("", !0)
                      : (openBlock(),
                        createElementVNode(
                          "p",
                          US,
                          "* " +
                            toDisplayString(
                              `${unref(t)("PDF장수안내", {
                                QTY: k.value,
                              })}`
                            ),
                          1
                        )),
                    C.canEditOrdCnt.pdf && C.canEditOrdCnt.editor
                      ? (openBlock(),
                        createElementVNode(
                          "p",
                          BS,
                          "* " + toDisplayString(unref(t)("디자인건수가능여부-전체")),
                          1
                        ))
                      : !C.canEditOrdCnt.pdf && C.canEditOrdCnt.editor
                      ? (openBlock(),
                        createElementVNode(
                          "p",
                          VS,
                          " * " + toDisplayString(unref(t)("디자인건수가능여부-에디터")),
                          1
                        ))
                      : createCommentVNode("", !0),
                    E.value
                      ? withDirectives((openBlock(), createElementVNode("p", HS, null, 512)), [
                          [I, E.value],
                        ])
                      : createCommentVNode("", !0),
                  ]),
                ]),
                _: 1,
              })
            );
          }
        );
      },
    }),
    [["__scopeId", "data-v-598642f7"]]
  ),
  GS = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: oh,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  jS = {
    class: "basic-radio",
  },
  zS = ["for", "aria-disabled"],
  YS = ["id", "name", "value", "checked", "disabled", "onChange"],
  KS = {
    class: "text",
  },
  RadioGroup = defineComponent({
    __name: "RadioList",
    props: {
      options: {},
      defaultChecked: {},
    },
    emits: ["change"],
    setup(e, { emit: t }) {
      const n = t,
        o = (s) => {
          n("change", s);
        };
      return (s, r) => (
        openBlock(),
        createElementVNode("div", jS, [
          (openBlock(!0),
          createElementVNode(
            Fragment,
            null,
            renderList(
              s.options,
              (a) => (
                openBlock(),
                createElementVNode(
                  "label",
                  {
                    key: a.id,
                    for: a.id,
                    "aria-disabled": a.disabled,
                  },
                  [
                    createElement(
                      "input",
                      {
                        type: "radio",
                        id: a.id,
                        name: a.name,
                        value: a.value,
                        checked: s.defaultChecked === a.value,
                        disabled: a.disabled,
                        onChange: () => o(a),
                      },
                      null,
                      40,
                      YS
                    ),
                    createElement("span", KS, toDisplayString(unref(t)(a.label)), 1),
                  ],
                  8,
                  zS
                )
              )
            ),
            128
          )),
        ])
      );
    },
  }),
  WS = {
    class: "flex-row",
  },
  qS = defineComponent({
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
              SUB_MTR_CR: "Y",
            },
            subMtrlOption: {},
          };
        },
      },
      relatedData: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = reactive(new Map()),
        r = computed(() =>
          [...s.values()].sort((h, f) => (h.order && f.order ? h.order - f.order : 0))
        ),
        a = reactive({
          ...n.default.assembleYN,
        }),
        i = reactive({
          ...n.default.subMtrlOption,
        }),
        l = ref(null);
      function c(h) {
        const f = s.get(h);
        f &&
          (f.value === l.value
            ? (l.value = null)
            : ((l.value = f.value),
              (i[l.value] = {
                PCS_DTL_CD: f.options[0].value,
                qty: n.relatedData.orderQty,
                extra: f.options[0].extra,
              })));
      }
      function u(h) {
        a[h.name] = h.value;
      }
      const d = (h) => (f) => {
        i[h] = f;
      };
      return (
        watch(
          () => n.options.visible,
          (h) => {
            h.forEach((f) => {
              const _ = s.get(f.WEB_PCS_DTL_GRP),
                p = {
                  name: f.PCS_DTL_NM,
                  value: f.PCS_DTL_CD,
                  key: f.PCS_DTL_CD,
                  extra: f,
                };
              _
                ? _.options.push(p)
                : s.set(f.WEB_PCS_DTL_GRP, {
                    name: f.WEB_PCS_DTL_GRP_NM || f.PCS_DTL_NM,
                    imgPath: f.WEB_PCS_DTL_GRP,
                    subImgPath: f.PCS_CD,
                    value: f.WEB_PCS_DTL_GRP,
                    active: !1,
                    options: [p],
                    order: th[f.WEB_PCS_DTL_GRP],
                  });
            });
          },
          {
            immediate: !0,
          }
        ),
        watch(
          () => n.relatedData.orderQty,
          (h) => {
            for (const f in i) i[f].qty = h;
          }
        ),
        onMounted(() => {
          const h = Object.values(i).map((f) => ({
            PCS_CD: f.extra.PCS_CD,
            PCS_GRP_NM: f.extra.WEB_PCS_DTL_GRP_NM,
            VIEW_YN: f.extra.VIEW_YN,
            ESN_YN: f.extra.ESN_YN,
            active: !0,
            selectedOptions: [
              {
                PCS_CD: f.extra.PCS_CD,
                PCS_DTL_CD: f.PCS_DTL_CD,
                PCS_DTL_NM: f.extra.PCS_DTL_NM,
                ATTB: f.qty,
                ATTB_2: "",
                ATTB_3: a[f.extra.WEB_PCS_DTL_GRP],
              },
            ],
          }));
          o("update", h);
        }),
        watch(
          () => l.value,
          (h, f) => {
            f && h !== f && (delete i[f], (a[f] = n.default.assembleYN[f]));
          }
        ),
        (h, f) => (
          openBlock(),
          createElementVNode(
            Fragment,
            null,
            [
              s.size
                ? (openBlock(),
                  createVNode(
                    OptionRow,
                    {
                      key: 0,
                      title: "부자재선택",
                    },
                    {
                      default: withCtx(() => [
                        createElement("div", WS, [
                          (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            null,
                            renderList(
                              r.value,
                              (_) => (
                                openBlock(),
                                createVNode(
                                  IconCheckbox,
                                  {
                                    key: _.value,
                                    active: l.value === _.value,
                                    data: _,
                                    onSelect: f[0] || (f[0] = (p) => c(p.value)),
                                  },
                                  null,
                                  8,
                                  ["active", "data"]
                                )
                              )
                            ),
                            128
                          )),
                        ]),
                      ]),
                      _: 1,
                    }
                  ))
                : createCommentVNode("", !0),
              l.value
                ? (openBlock(),
                  createVNode(
                    OptionRow,
                    {
                      key: 1,
                    },
                    {
                      default: withCtx(() => [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            r.value,
                            (_) => (
                              openBlock(),
                              createElementVNode(
                                Fragment,
                                {
                                  key: _.value,
                                },
                                [
                                  l.value === _.value
                                    ? (openBlock(),
                                      createVNode(
                                        Kl,
                                        {
                                          key: 0,
                                          title: _.name,
                                          options: _.options,
                                          "default-data": i[_.value],
                                          "qty-disabled": !0,
                                          onUpdate: (p) => d(_.value)(p),
                                        },
                                        Km(
                                          {
                                            _: 2,
                                          },
                                          [
                                            unref(qb).has(_.value)
                                              ? {
                                                  name: "extra",
                                                  fn: withCtx(() => [
                                                    renderComponent(
                                                      RadioGroup,
                                                      {
                                                        options: [
                                                          {
                                                            id: `${_.value}/Y`,
                                                            name: _.value,
                                                            label: "조립",
                                                            value: "Y",
                                                          },
                                                          {
                                                            id: `${_.value}/N`,
                                                            name: _.value,
                                                            label: "미조립",
                                                            value: "N",
                                                          },
                                                        ],
                                                        "default-checked": a[_.value],
                                                        onChange: u,
                                                      },
                                                      null,
                                                      8,
                                                      ["options", "default-checked"]
                                                    ),
                                                  ]),
                                                  key: "0",
                                                }
                                              : void 0,
                                          ]
                                        ),
                                        1032,
                                        ["title", "options", "default-data", "onUpdate"]
                                      ))
                                    : createCommentVNode("", !0),
                                ],
                                64
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                      _: 1,
                    }
                  ))
                : createCommentVNode("", !0),
            ],
            64
          )
        )
      );
    },
  }),
  QS = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "Acrylic",
          props: {
            type: {
              default: "new",
            },
            data: {},
            widgetAttr: {},
            defaultData: {},
            senecaInfo: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = computed(() => n.widgetAttr.skinInfo),
              r = inject("member"),
              a = useEditorStore(),
              i = computed(() => {
                if (!n.data.option_info) return !1;
                const { shape_info: N } = n.data.option_info;
                return !isEmpty(N) && !!N[0].COD;
              }),
              l = computed(() => {
                if (!n.data.option_info) return !1;
                const { print_data: N } = n.data.option_info;
                return !isEmpty(N) && !!N[0].COD && m.value.meterialInfo?.PRT_HIDE_YN === "N";
              }),
              c = computed(() => {
                if (!n.data.option_info) return !1;
                const { production_method: N } = n.data.option_info;
                return !isEmpty(N) && !!N[0].COD;
              }),
              u = computed(() =>
                r?.bsn_yn === "Y"
                  ? n.data.pdt_mtrl_info
                  : n.data.pdt_mtrl_info.filter((N) => N.BSN_YN !== "Y")
              ),
              d = computed(() => {
                const N = [...n.data.pdt_size_info];
                return !i.value || !m.value.acrylicSelectData?.shapeInfo || N.length === 1
                  ? N
                  : N.filter((D) => D.STICKER_TYPE === m.value.acrylicSelectData?.shapeInfo.COD);
              }),
              h = computed(() =>
                parsePostProcessOptions(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)
              ),
              { uploadConfig: f, canEditOrdCnt: _ } = useUploadConfig(n.widgetAttr),
              {
                defaultOrderData: p,
                orderInfo: m,
                updateOption: v,
                updatePcsOption: E,
                updatePostPcs: k,
              } = useOrderComposable(n.type, {
                group: n.widgetAttr.item_gbn,
                emits: {
                  updateOrder: (N) => o("update", N),
                },
              });
            return (N, D) => (
              openBlock(),
              createElementVNode(
                Fragment,
                null,
                [
                  withDirectives(
                    renderComponent(
                      q_,
                      {
                        options: N.data.pdt_dosu_info,
                        default: unref(p)?.dosuInfo,
                        onUpdate: D[0] || (D[0] = (O) => unref(v)("dosuInfo")(O)),
                      },
                      null,
                      8,
                      ["options", "default"]
                    ),
                    [[vShow, s.value.dosuSelect.view_yn === "Y" && N.data.pdt_dosu_info]]
                  ),
                  c.value
                    ? (openBlock(),
                      createVNode(
                        DS,
                        {
                          key: 0,
                          options: N.data.option_info?.production_method || [],
                          default: unref(p)?.productionMethod,
                          onUpdate: D[1] || (D[1] = (O) => unref(v)("productionMethod", !0)(O)),
                        },
                        null,
                        8,
                        ["options", "default"]
                      ))
                    : createCommentVNode("", !0),
                  i.value
                    ? (openBlock(),
                      createVNode(
                        W_,
                        {
                          key: 1,
                          options: N.data.option_info?.shape_info || [],
                          default: unref(p)?.shapeInfo,
                          onUpdate: D[2] || (D[2] = (O) => unref(v)("shapeInfo", !0)(O)),
                        },
                        null,
                        8,
                        ["options", "default"]
                      ))
                    : createCommentVNode("", !0),
                  l.value
                    ? (openBlock(),
                      createVNode(
                        PS,
                        {
                          key: 2,
                          options: N.data.option_info?.print_data || [],
                          default: unref(p)?.printData,
                          onUpdate: D[3] || (D[3] = (O) => unref(v)("printData", !0)(O)),
                        },
                        null,
                        8,
                        ["options", "default"]
                      ))
                    : createCommentVNode("", !0),
                  withDirectives(
                    renderComponent(
                      nh,
                      {
                        options: u.value,
                        default: unref(p)?.meterialInfo,
                        "reset-after-edit":
                          unref(Qb).has(N.data.pdt_base_info[0].PDT_CD) && unref(a).isAfterEdit(),
                        "show-extra": N.widgetAttr.able_paper_yn === "Y",
                        "related-data": {
                          method: unref(m).acrylicSelectData?.productionMethod?.COD,
                        },
                        onUpdate: D[4] || (D[4] = (O) => unref(v)("meterialInfo")(O)),
                      },
                      null,
                      8,
                      ["options", "default", "reset-after-edit", "show-extra", "related-data"]
                    ),
                    [[vShow, s.value.paperSelect.view_yn === "Y"]]
                  ),
                  withDirectives(
                    renderComponent(
                      SizeSelect,
                      {
                        options: d.value,
                        "base-info": N.data.pdt_base_info[0],
                        default: unref(p)?.size,
                        "related-data": {
                          shape: unref(m).acrylicSelectData?.shapeInfo?.COD,
                        },
                        onUpdate: D[5] || (D[5] = (O) => unref(v)("sizeInfo")(O)),
                        onValidate: D[6] || (D[6] = (O) => unref(v)("validation")(O)),
                      },
                      null,
                      8,
                      ["options", "base-info", "default", "related-data"]
                    ),
                    [
                      [
                        vShow,
                        (!i.value || (i.value && unref(m).acrylicSelectData?.shapeInfo)) &&
                          s.value.sizeSelect.view_yn === "Y",
                      ],
                    ]
                  ),
                  s.value.quantityGroup.view_yn === "Y"
                    ? (openBlock(),
                      createVNode(
                        oh,
                        {
                          key: 3,
                          "can-edit-ord-cnt": unref(_),
                          options: N.data.pdt_prn_cnt_info,
                          default: unref(p)?.quantityInfo,
                          "related-data": {
                            dosu: unref(m).dosuInfo?.COD,
                          },
                          onUpdate: D[7] || (D[7] = (O) => unref(v)("quantityInfo")(O)),
                        },
                        null,
                        8,
                        ["can-edit-ord-cnt", "options", "default", "related-data"]
                      ))
                    : createCommentVNode("", !0),
                  renderComponent(
                    HiddenPostProcess,
                    {
                      options: h.value.postPcs.hidden,
                      "related-data": {
                        shape: unref(m).acrylicSelectData?.shapeInfo?.COD,
                        sizeInfo: unref(m).sizeInfo,
                      },
                      "disabled-opts": h.value.disabled,
                      onUpdate: D[8] || (D[8] = (O) => unref(k)("hidden")(O)),
                    },
                    null,
                    8,
                    ["options", "related-data", "disabled-opts"]
                  ),
                  renderComponent(
                    VisiblePostProcess,
                    {
                      options: h.value.postPcs.visible,
                      "related-data": {
                        sizeInfo: unref(m).sizeInfo,
                      },
                      "attb-opts": N.data.pdt_add_info[1],
                      "disabled-opts": h.value.disabled,
                      onUpdate: D[9] || (D[9] = (O) => unref(k)("visible")(O)),
                    },
                    null,
                    8,
                    ["options", "related-data", "attb-opts", "disabled-opts"]
                  ),
                  renderComponent(
                    qS,
                    {
                      options: h.value.sub,
                      "related-data": {
                        orderQty:
                          (unref(m).quantityInfo?.ordCnt || 1) *
                          (unref(m).quantityInfo?.prnCnt || 1),
                      },
                      onUpdate: D[10] || (D[10] = (O) => unref(E)("SUB_MTR")(O)),
                    },
                    null,
                    8,
                    ["options", "related-data"]
                  ),
                  N.widgetAttr.order_yn !== "N"
                    ? (openBlock(),
                      createVNode(
                        FileUpload,
                        {
                          key: 4,
                          "upload-config": unref(f),
                          "show-extra":
                            N.widgetAttr.useTemplateDownload === "Y" && N.widgetAttr.usePDF === "Y",
                          "related-data": {
                            print: unref(m).acrylicSelectData?.printData,
                          },
                          onUpload: D[11] || (D[11] = (O) => unref(v)("fileUploadInfo")(O)),
                        },
                        null,
                        8,
                        ["upload-config", "show-extra", "related-data"]
                      ))
                    : createCommentVNode("", !0),
                ],
                64
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  XS = {
    class: "grid-group",
  },
  JS = defineComponent({
    __name: "ApparelPrintType",
    props: {
      options: {},
      dosuOptions: {},
      relatedData: {},
    },
    emits: ["update:type", "update:dosu"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useI18n(),
        r = useEditorStore(),
        a = inject("productCode", {
          pdtCode: "",
        }),
        i = inject("callbacks", {}),
        l = inject("deviceType", "pc"),
        c = {
          PTP_DTF: {
            src: `${CDN_BASE_URL}/{lang}/item/clothes-color-film-img.png`,
            alt: "DTF 열전사 설명 사진",
          },
          PTP_DIR: {
            src: `${CDN_BASE_URL}/{lang}/item/clothes-color-direct-img.png`,
            alt: "직접인쇄 설명 사진",
          },
          PTP_SLK: {
            src: `${CDN_BASE_URL}/{lang}/item/clothes-color-printing-img.png`,
            alt: "날염(실크인쇄) 설명 사진",
          },
        },
        u = computed(() =>
          n.options.map((N, D) => {
            const O = c[N.COD];
            return O
              ? {
                  IDX: D + 1,
                  CATEGORY: t("인쇄"),
                  LABEL: n.options[D].COD_NME,
                  IMG_URL: O.src.replace("{lang}", s.locale),
                  IMG_ALT: O.alt,
                }
              : null;
          })
        ),
        d = computed(() =>
          n.dosuOptions.map((N) => ({
            id: N.COD,
            name: "apparel-print-side",
            value: N.COD,
            label: `의류.${N.COD_NME}`,
            disabled: k.value,
          }))
        ),
        h = ref(n.dosuOptions[0].COD),
        f = computed(() => n.dosuOptions.find((N) => N.COD === h.value)),
        _ = ref(n.options[0].COD),
        p = computed(() =>
          n.options.map((N) => ({
            name: N.COD_NME,
            value: N.COD,
            key: N.COD,
            disabled: N.USE_YN !== "Y" || h.value === "SID_X",
          }))
        ),
        m = () => {
          i?.onReset && i.onReset("fileUpload");
        },
        v = (N) => {
          r.isAfterEdit() && m(), (_.value = N);
        };
      watch(
        () => h.value,
        (N) => {
          o("update:type", {
            COD: N === "SID_S" ? _.value : "",
            PRINT_GBN: N === "SID_S" ? "Y" : "N",
          }),
            o("update:dosu", {
              ...f.value,
              COD_NME: t(`의류.${f.value.COD_NME}`),
            });
        },
        {
          immediate: !0,
        }
      ),
        watch(
          () => _.value,
          (N) => {
            o("update:type", {
              COD: N,
              PRINT_GBN: h.value === "SID_S" ? "Y" : "N",
            });
          },
          {
            immediate: !0,
          }
        );
      const E = computed(() => n.relatedData.color),
        k = computed(() =>
          !E.value || a.pdtCode !== "CLSTBSA" ? !1 : E.value === "DD" || E.value === "DG"
        );
      return (
        watch(
          () => k.value,
          (N) => {
            N && ((h.value = "SID_X"), alert("[인쇄없음]으로만 주문 가능합니다."));
          }
        ),
        (N, D) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "인쇄",
              extra:
                unref(l) === "mobile"
                  ? {
                      name: "자세히보기",
                      callback: () => {
                        unref(i).onInformOptionTips && unref(i).onInformOptionTips(u.value);
                      },
                      style: "tip",
                    }
                  : {
                      name: "가이드보기",
                      callback: () => {
                        unref(i)?.onInformGuide && unref(i).onInformGuide("print");
                      },
                    },
            },
            {
              default: withCtx(() => [
                createElement("div", XS, [
                  renderComponent(
                    RadioGroup,
                    {
                      options: d.value,
                      "default-checked": h.value,
                      onChange: D[0] || (D[0] = (O) => (h.value = O.value)),
                    },
                    null,
                    8,
                    ["options", "default-checked"]
                  ),
                  renderComponent(
                    SizeSelector,
                    {
                      options: p.value,
                      default: _.value,
                      tips: u.value,
                      onSelect: v,
                    },
                    null,
                    8,
                    ["options", "default", "tips"]
                  ),
                ]),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        )
      );
    },
  }),
  ZS = {
    key: 0,
    class: "arrow-up",
    xmlns: "http://www.w3.org/2000/svg",
    width: "22",
    height: "22",
    viewBox: "0 0 22 22",
    fill: "none",
  },
  eD = {
    key: 1,
    class: "arrow-down",
    xmlns: "http://www.w3.org/2000/svg",
    width: "22",
    height: "22",
    viewBox: "0 0 22 22",
    fill: "none",
  },
  tD = defineComponent({
    __name: "Chevron",
    props: {
      direction: {},
    },
    setup(e) {
      return (t, n) => (
        openBlock(),
        createElementVNode(
          Fragment,
          null,
          [
            t.direction === "up"
              ? (openBlock(),
                createElementVNode("svg", ZS, [
                  ...(n[0] ||
                    (n[0] = [
                      createElement(
                        "path",
                        {
                          d: "M4.39961 7.70042L10.9855 14.3002L17.5996 7.70042",
                          stroke: "#777777",
                          "stroke-width": "1.5",
                          "stroke-linecap": "round",
                          "stroke-linejoin": "round",
                        },
                        null,
                        -1
                      ),
                    ])),
                ]))
              : createCommentVNode("", !0),
            t.direction === "down"
              ? (openBlock(),
                createElementVNode("svg", eD, [
                  ...(n[1] ||
                    (n[1] = [
                      createElement(
                        "path",
                        {
                          d: "M4.39961 14.2996L10.9855 7.69981L17.5996 14.2996",
                          stroke: "#777777",
                          "stroke-width": "1.5",
                          "stroke-linecap": "round",
                          "stroke-linejoin": "round",
                        },
                        null,
                        -1
                      ),
                    ])),
                ]))
              : createCommentVNode("", !0),
          ],
          64
        )
      );
    },
  }),
  nD = {
    class: "color-picker",
  },
  oD = {
    key: 0,
    class: "desc",
  },
  sD = {
    class: "text",
  },
  rD = {
    class: "text",
  },
  iD = ["aria-expanded"],
  aD = ["title", "onClick"],
  lD = {
    class: "tooltip",
  },
  ColorChipSelector = withScopeId(
    defineComponent({
      __name: "ColorPicker",
      props: {
        options: {},
        canToggle: {
          type: Boolean,
        },
        defaultValue: {},
      },
      emits: ["select"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = ref(n.defaultValue || n.options[0]),
          r = ref(!0);
        function a(l) {
          (s.value = l), o("select", l);
        }
        const i = (l) => {
          const c = l.split(",").map((f) => f.replace("#", "")),
            [u, d, h] = c;
          if (c.length === 2) return `linear-gradient(to right, #${u} 50%, #${d} 50%)`;
          if (c.length === 3)
            return `linear-gradient(to right, #${u} 34%, #${d} 34% 67%, #${h} 33%)`;
        };
        return (
          watch(
            () => n.defaultValue,
            (l) => {
              l && (s.value = l);
            }
          ),
          (l, c) => (
            openBlock(),
            createElementVNode("div", nD, [
              l.canToggle
                ? (openBlock(),
                  createElementVNode("div", oD, [
                    createElement(
                      "span",
                      sD,
                      toDisplayString(unref(t)("선택")) + " : " + toDisplayString(s.value?.COD_NME),
                      1
                    ),
                    createElement(
                      "button",
                      {
                        type: "button",
                        class: "toggle-btn",
                        onClick: c[0] || (c[0] = (u) => (r.value = !r.value)),
                      },
                      [
                        createElement("span", rD, toDisplayString(r.value ? "접기" : "보기"), 1),
                        renderComponent(
                          tD,
                          {
                            direction: r.value ? "down" : "up",
                          },
                          null,
                          8,
                          ["direction"]
                        ),
                      ]
                    ),
                  ]))
                : createCommentVNode("", !0),
              createElement(
                "ul",
                {
                  class: "color-chip",
                  "aria-expanded": l.canToggle ? r.value : !0,
                },
                [
                  (openBlock(!0),
                  createElementVNode(
                    Fragment,
                    null,
                    renderList(
                      l.options,
                      (u) => (
                        openBlock(),
                        createElementVNode(
                          "li",
                          {
                            key: u.COD,
                            class: normalizeClass([
                              "color",
                              {
                                active: u.COD === s.value?.COD,
                              },
                            ]),
                            title: `hex: ${u.HEX}`,
                            style: normalizeStyle([
                              {
                                background: u.HEX.includes(",") ? i(u.HEX) : u.HEX,
                              },
                              {
                                border: u.HEX.toLocaleLowerCase().includes("ffff")
                                  ? "1px solid #ddd"
                                  : "",
                              },
                            ]),
                            onClick: (d) => a(u),
                          },
                          [createElement("div", lD, toDisplayString(u.COD_NME), 1)],
                          14,
                          aD
                        )
                      )
                    ),
                    128
                  )),
                ],
                8,
                iD
              ),
            ])
          )
        );
      },
    }),
    [["__scopeId", "data-v-609eb670"]]
  ),
  uD = defineComponent({
    __name: "ApparelColor",
    props: {
      options: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useEditorStore(),
        r = inject("callbacks", {}),
        a = ref(n.options.find((u) => u.DEFAULT === "Y") || n.options[0]),
        i = computed(() => n.options.find((u) => u.COD === a.value.COD)),
        l = () => {
          r?.onReset && r.onReset("color");
        },
        c = (u) => {
          s.isAfterEdit() && l(), (a.value = u);
        };
      return (
        watch(
          () => i.value,
          (u) => {
            u && o("update", u);
          },
          {
            immediate: !0,
          }
        ),
        watch(
          () => s.editorData.default,
          (u) => {
            const d = u?.editorClothesInfo?.COLOR;
            if (!d || a.value.COD === d) return;
            const h = n.options.find((f) => f.COD === d);
            h && (a.value = h);
          }
        ),
        (u, d) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "의류 컬러",
            },
            {
              default: withCtx(() => [
                renderComponent(
                  ColorChipSelector,
                  {
                    options: u.options,
                    "can-toggle": !0,
                    "default-value": a.value,
                    onSelect: c,
                  },
                  null,
                  8,
                  ["options", "default-value"]
                ),
              ]),
              _: 1,
            }
          )
        )
      );
    },
  }),
  cD = {
    class: "flex-row -flow",
  },
  dD = {
    class: "notes",
  },
  fD = ["innerHTML"],
  pD = ["innerHTML"],
  _D = ["innerHTML"],
  hD = defineComponent({
    __name: "ApparelPrintArea",
    props: {
      options: {},
      relatedData: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useEditorStore(),
        r = inject("productCode", {
          pdtCode: "",
        }),
        a = inject("callbacks", {}),
        i = {
          CLSTLUB: {
            CL001: "CLSTLUB_CL001",
          },
          CLSTTOB: {
            CL001: "CLSTTOB_CL001",
          },
          CLDFNCP: {
            CL001: "CLDFNCP_CL001",
          },
          CLSTSAP: {
            CL005: "CLSTSAP_CL005",
          },
          CLSTCAP: {
            CL001: "CLSTCAP_CL001",
          },
        },
        l = computed(() => {
          let p = 0;
          for (const m of n.options)
            if (((m.COD === "CL011" || m.COD === "CL001") && p++, p === 2)) break;
          return p === 2;
        }),
        c = computed(() => {
          const p = [];
          for (const m of n.options)
            (m.COD === "CL011" || m.COD === "CL009" || m.COD === "CL010" || m.COD === "CL004") &&
              p.push(m.COD_NME);
          return p.length === 0 ? null : p.join(", ");
        }),
        u = computed(() =>
          n.options.map((p) => ({
            name: p.COD_NME,
            value: p.KOI_NME,
            imgPath: `${CDN_BASE_URL}/ko/item/printarea_${
              i[r.pdtCode] ? i[r.pdtCode][p.COD] : p.COD
            }.svg`,
            forcedImg: !0,
          }))
        ),
        d = reactive(
          n.options.reduce(
            (p, m, v) => (
              (p[m.KOI_NME] = {
                active: v === 0,
                COD: m.COD,
                COD_NME: m.COD_NME,
                KOI_NME: m.KOI_NME,
              }),
              p
            ),
            {}
          )
        ),
        h = computed(() =>
          Object.entries(d).reduce((p, m) => {
            const [v, E] = m;
            return (
              E.active &&
                p.push({
                  COD: E.COD,
                  COD_NME: E.COD_NME,
                  KOI_NME: v,
                }),
              p
            );
          }, [])
        ),
        f = () => {
          a?.onReset && a.onReset("printArea");
        },
        _ = (p) => {
          (h.value.length === 1 && d[p]?.active) ||
            (s.isAfterEdit() && f(),
            p === "front" && d.leftchest && (d.leftchest.active = !1),
            p === "leftchest" && d.front && (d.front.active = !1),
            (d[p].active = !d[p].active));
        };
      return (
        watch(
          () => h.value,
          (p) => {
            o("update", p);
          },
          {
            immediate: !0,
          }
        ),
        watch(
          () => n.relatedData.printType?.PRINT_GBN,
          (p) => {
            p === "N" ? o("update", null) : o("update", h.value);
          }
        ),
        watch(
          () => s.editorData.default,
          (p) => {
            const m = p?.editorClothesInfo?.PAGES;
            if (m) for (const v in d) d[v].active = m.includes(v);
          }
        ),
        (p, m) =>
          p.relatedData.printType?.PRINT_GBN === "Y"
            ? (openBlock(),
              createVNode(
                OptionRow,
                {
                  key: 0,
                  title: "인쇄 영역",
                },
                {
                  default: withCtx(() => [
                    createElement("div", cD, [
                      (openBlock(!0),
                      createElementVNode(
                        Fragment,
                        null,
                        renderList(
                          u.value,
                          (v) => (
                            openBlock(),
                            createVNode(
                              IconCheckbox,
                              {
                                key: v.value,
                                data: v,
                                active: d[v.value].active,
                                onSelect: m[0] || (m[0] = (E) => _(E.value)),
                              },
                              null,
                              8,
                              ["data", "active"]
                            )
                          )
                        ),
                        128
                      )),
                    ]),
                    createElement("div", dD, [
                      p.relatedData.printType.COD === "PTP_DTF" && l.value
                        ? (openBlock(),
                          createElementVNode(
                            "p",
                            {
                              key: 0,
                              class: "note",
                              innerHTML: unref(t)("의류인쇄영역가이드"),
                            },
                            null,
                            8,
                            fD
                          ))
                        : createCommentVNode("", !0),
                      p.relatedData.printType.COD === "PTP_DIR" && c.value
                        ? (openBlock(),
                          createElementVNode(
                            "p",
                            {
                              key: 1,
                              class: "note",
                              innerHTML: unref(t)("의류인쇄영역가이드-직접인쇄", {
                                areas: c.value,
                              }),
                            },
                            null,
                            8,
                            pD
                          ))
                        : createCommentVNode("", !0),
                      p.relatedData.printType.COD === "PTP_SLK"
                        ? (openBlock(),
                          createElementVNode(
                            "p",
                            {
                              key: 2,
                              class: "note",
                              innerHTML: unref(t)("의류인쇄영역가이드-실크인쇄"),
                            },
                            null,
                            8,
                            _D
                          ))
                        : createCommentVNode("", !0),
                    ]),
                  ]),
                  _: 1,
                }
              ))
            : createCommentVNode("", !0)
      );
    },
  }),
  rh = defineComponent({
    __name: "ApparelSizeGbn",
    props: {
      options: {},
      default: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = [
          {
            id: "adult",
            name: "size-option",
            label: t("adult"),
            value: "adult",
          },
          {
            id: "child",
            name: "size-option",
            label: t("child"),
            value: "child",
          },
        ],
        r = ref(n.default);
      return (
        watch(
          () => r.value,
          (a) => {
            o("update", a);
          }
        ),
        (a, i) => (
          openBlock(),
          createVNode(
            RadioGroup,
            {
              options: s,
              "default-checked": s[0].value,
              onChange: i[0] || (i[0] = (l) => (r.value = l.value)),
            },
            null,
            8,
            ["default-checked"]
          )
        )
      );
    },
  }),
  mD = {
    class: "grid-group",
  },
  vD = {
    key: 1,
    class: "note red",
  },
  gD = {
    class: "inputs",
  },
  yD = ["value"],
  CD = {
    class: "notes",
  },
  TD = {
    class: "note",
  },
  bD = withScopeId(
    defineComponent({
      __name: "ApparelSingleSizeQty",
      props: {
        options: {},
        sizeInfo: {},
      },
      emits: ["update:qty", "update:combinations"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = useEditorStore(),
          r = inject("callbacks", {}),
          a = computed(() => {
            const N = {};
            return (
              n.options.forEach((D) => {
                const O = N[D.GBN];
                O ? O.push(D) : (N[D.GBN] = [D]);
              }),
              N
            );
          }),
          i = computed(() => Object.keys(a.value)),
          l = ref(i.value.length === 1 ? i.value[0] : "adult"),
          c = computed(() =>
            [...a.value[l.value]]
              .sort((D, O) => n.sizeInfo[D.COD].ORD - n.sizeInfo[O.COD].ORD)
              .map((D) => ({
                name: n.sizeInfo[D.COD].COD_NME || D.COD_NME,
                value: D.COD,
                key: D.COD,
                disabled: D.HIDE_YN === "Y",
              }))
          ),
          u = ref("select"),
          d = () => {
            u.value = u.value === "input" ? "select" : "input";
          },
          h = computed(() => {
            const N = c.value.filter((O) => !O.disabled);
            if (N.length === 1) return N[0].value;
            const D = l.value === "adult" ? Math.trunc(N.length / 2) : 0;
            return N[D].value;
          }),
          f = ref(h.value);
        function _(N) {
          s.isAfterEdit() && r?.onReset && r.onReset("size"), (f.value = N);
        }
        const p = computed(() => {
            const D = [];
            for (let O = 1; O <= 10; O++) D.push(O);
            return D;
          }),
          m = ref(1);
        watch(
          () => m.value,
          (N) => {
            N || (m.value = 1),
              o("update:qty", {
                ordCnt: 1,
                prnCnt: N,
              });
          },
          {
            immediate: !0,
          }
        ),
          onMounted(() => {
            f.value = h.value;
          });
        const v = computed(() =>
            n.options
              .filter((N) => N.COD === f.value)
              .map((N) => ({
                size: N,
                quantity: m.value,
              }))
          ),
          E = computed(() => v.value[0]?.size?.QUICK_ORD_YN === "N"),
          k = computed(() =>
            n.options
              .filter((N) => N.QUICK_ORD_YN === "N")
              .map((N) => n.sizeInfo[N.COD].COD_NME || N.COD_NME)
              .join(", ")
          );
        return (
          watch(
            () => v.value,
            (N) => {
              N && o("update:combinations", N);
            },
            {
              immediate: !0,
            }
          ),
          watch(
            () => s.editorData.default,
            (N) => {
              const D = N?.editorClothesInfo?.SIZE;
              D && (f.value = D);
            }
          ),
          (N, D) => {
            const O = resolveDirective("dompurify-html");
            return (
              openBlock(),
              createElementVNode(
                Fragment,
                null,
                [
                  renderComponent(
                    OptionRow,
                    {
                      title: "사이즈",
                    },
                    {
                      default: withCtx(() => [
                        createElement("div", mD, [
                          i.value.length > 1
                            ? (openBlock(),
                              createVNode(
                                rh,
                                {
                                  key: 0,
                                  options: i.value,
                                  default: l.value,
                                  onUpdate: D[0] || (D[0] = (A) => (l.value = A)),
                                },
                                null,
                                8,
                                ["options", "default"]
                              ))
                            : createCommentVNode("", !0),
                          renderComponent(
                            SizeSelector,
                            {
                              type: "sm",
                              options: c.value,
                              default: f.value,
                              onSelect: _,
                            },
                            null,
                            8,
                            ["options", "default"]
                          ),
                          E.value
                            ? (openBlock(),
                              createElementVNode(
                                "p",
                                vD,
                                toDisplayString(unref(t)("퀵오더불가")) +
                                  " - " +
                                  toDisplayString(k.value),
                                1
                              ))
                            : createCommentVNode("", !0),
                        ]),
                      ]),
                      _: 1,
                    }
                  ),
                  renderComponent(
                    OptionRow,
                    {
                      title: "수량",
                    },
                    {
                      default: withCtx(() => [
                        createElement("div", gD, [
                          u.value === "input"
                            ? withDirectives(
                                (openBlock(),
                                createElementVNode(
                                  "input",
                                  {
                                    key: 0,
                                    "onUpdate:modelValue": D[1] || (D[1] = (A) => (m.value = A)),
                                    type: "number",
                                    class: normalizeClass(["basic-input", "-fixed-w"]),
                                    id: "PRN_CNT",
                                    min: "1",
                                  },
                                  null,
                                  512
                                )),
                                [[vModelText, m.value]]
                              )
                            : withDirectives(
                                (openBlock(),
                                createElementVNode(
                                  "select",
                                  {
                                    key: 1,
                                    "onUpdate:modelValue": D[2] || (D[2] = (A) => (m.value = A)),
                                    name: "PRN_CNT",
                                    class: normalizeClass(["basic-select", "-fixed-w"]),
                                  },
                                  [
                                    (openBlock(!0),
                                    createElementVNode(
                                      Fragment,
                                      null,
                                      renderList(
                                        p.value,
                                        (A) => (
                                          openBlock(),
                                          createElementVNode(
                                            "option",
                                            {
                                              value: A,
                                              key: `${A}`,
                                            },
                                            toDisplayString(A),
                                            9,
                                            yD
                                          )
                                        )
                                      ),
                                      128
                                    )),
                                  ],
                                  512
                                )),
                                [[vModelSelect, m.value]]
                              ),
                          createElement(
                            "button",
                            {
                              type: "button",
                              class: "action-btn",
                              onClick: d,
                            },
                            toDisplayString(
                              u.value === "input" ? unref(t)("수량선택") : unref(t)("직접입력")
                            ),
                            1
                          ),
                        ]),
                        createElement("div", CD, [
                          withDirectives(createElement("p", TD, null, 512), [
                            [
                              O,
                              unref(t)("의류주문가능수량", {
                                QTY: "1",
                              }),
                            ],
                          ]),
                        ]),
                      ]),
                      _: 1,
                    }
                  ),
                ],
                64
              )
            );
          }
        );
      },
    }),
    [["__scopeId", "data-v-3fed104a"]]
  ),
  SD = {
    class: "grid-group",
  },
  DD = {
    class: "multi-size",
  },
  PD = {
    class: "label",
  },
  ED = {
    class: "input-box",
  },
  OD = ["disabled", "onClick"],
  ID = ["onUpdate:modelValue", "disabled"],
  RD = ["disabled", "onClick"],
  wD = {
    key: 1,
    class: "note red",
  },
  AD = withScopeId(
    defineComponent({
      __name: "ApparelMultiSizeQty",
      props: {
        options: {},
        sizeInfo: {},
      },
      emits: ["update:qty", "update:combinations"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = computed(() => {
            const _ = [...n.options].sort((m, v) => n.sizeInfo[m.COD].ORD - n.sizeInfo[v.COD].ORD),
              p = {};
            return (
              _.forEach((m) => {
                const v = p[m.GBN];
                v ? v.push(m) : (p[m.GBN] = [m]);
              }),
              p
            );
          }),
          r = computed(() => Object.keys(s.value)),
          a = ref(r.value.length === 1 ? r.value[0] : "adult"),
          i = reactive(n.options.reduce((_, p) => ((_[p.COD] = 0), _), {})),
          l = computed(() => Object.values(i).reduce((_, p) => _ + p, 0)),
          c = (_) => {
            i[_] = i[_] + 1;
          },
          u = (_) => {
            i[_] < 1 || (i[_] = i[_] - 1);
          },
          d = computed(() =>
            n.options
              .filter((_) => i[_.COD] > 0)
              .map((_) => ({
                size: _,
                quantity: i[_.COD],
              }))
          ),
          h = computed(() => d.value.some((_) => i[_.size.COD] > 0 && _.size.QUICK_ORD_YN === "N")),
          f = computed(() =>
            n.options
              .filter((_) => _.QUICK_ORD_YN === "N")
              .map((_) => n.sizeInfo[_.COD].COD_NME || _.COD_NME)
              .join(", ")
          );
        return (
          watch(
            () => d.value,
            (_) => {
              o("update:qty", {
                ordCnt: 1,
                prnCnt: l.value,
              }),
                o("update:combinations", _);
            }
          ),
          (_, p) => (
            openBlock(),
            createVNode(
              OptionRow,
              {
                title: "사이즈별수량",
              },
              {
                default: withCtx(() => [
                  createElement("div", SD, [
                    r.value.length > 1
                      ? (openBlock(),
                        createVNode(
                          rh,
                          {
                            key: 0,
                            options: r.value,
                            default: a.value,
                            onUpdate: p[0] || (p[0] = (m) => (a.value = m)),
                          },
                          null,
                          8,
                          ["options", "default"]
                        ))
                      : createCommentVNode("", !0),
                    createElement("div", DD, [
                      (openBlock(!0),
                      createElementVNode(
                        Fragment,
                        null,
                        renderList(
                          s.value[a.value],
                          (m) => (
                            openBlock(),
                            createElementVNode(
                              "div",
                              {
                                key: m.COD,
                                class: normalizeClass([
                                  "size",
                                  "size-s",
                                  {
                                    soldout: m.HIDE_YN === "Y",
                                  },
                                ]),
                              },
                              [
                                createElement(
                                  "span",
                                  PD,
                                  toDisplayString(_.sizeInfo[m.COD].COD_NME || m.COD_NME),
                                  1
                                ),
                                createElement("div", ED, [
                                  createElement(
                                    "button",
                                    {
                                      type: "button",
                                      class: "control-btn",
                                      disabled: m.HIDE_YN === "Y",
                                      onClick: () => u(m.COD),
                                    },
                                    [
                                      ...(p[1] ||
                                        (p[1] = [
                                          createElement(
                                            "span",
                                            {
                                              class: "icon minus",
                                            },
                                            null,
                                            -1
                                          ),
                                        ])),
                                    ],
                                    8,
                                    OD
                                  ),
                                  withDirectives(
                                    createElement(
                                      "input",
                                      {
                                        "onUpdate:modelValue": (v) => (i[m.COD] = v),
                                        type: "number",
                                        name: "size-qty",
                                        disabled: m.HIDE_YN === "Y",
                                      },
                                      null,
                                      8,
                                      ID
                                    ),
                                    [[vModelText, i[m.COD]]]
                                  ),
                                  createElement(
                                    "button",
                                    {
                                      type: "button",
                                      class: "control-btn",
                                      disabled: m.HIDE_YN === "Y",
                                      onClick: () => c(m.COD),
                                    },
                                    [
                                      ...(p[2] ||
                                        (p[2] = [
                                          createElement(
                                            "span",
                                            {
                                              class: "icon plus",
                                            },
                                            null,
                                            -1
                                          ),
                                        ])),
                                    ],
                                    8,
                                    RD
                                  ),
                                ]),
                              ],
                              2
                            )
                          )
                        ),
                        128
                      )),
                    ]),
                    h.value
                      ? (openBlock(),
                        createElementVNode(
                          "p",
                          wD,
                          toDisplayString(unref(t)("퀵오더불가")) +
                            " - " +
                            toDisplayString(f.value),
                          1
                        ))
                      : createCommentVNode("", !0),
                  ]),
                ]),
                _: 1,
              }
            )
          )
        );
      },
    }),
    [["__scopeId", "data-v-949c188e"]]
  ),
  ND = {},
  MD = {
    xmlns: "http://www.w3.org/2000/svg",
    width: "14",
    height: "10",
    viewBox: "0 0 14 10",
    fill: "none",
  };
function kD(e, t) {
  return (
    openBlock(),
    createElementVNode("svg", MD, [
      ...(t[0] ||
        (t[0] = [
          createElement(
            "path",
            {
              d: "M1.29102 4.1319L6.21182 8.44571L12.4021 1.375",
              stroke: "white",
              "stroke-width": "2.18182",
              "stroke-linecap": "round",
              "stroke-linejoin": "round",
            },
            null,
            -1
          ),
        ])),
    ])
  );
}
/* =========================================================================
 [절단 경계] 이하 나머지 후가공/수량 컴포넌트는 본 deob 단편에 코드로 미포함(원본 mod_07 에만 존재).
 동일 패턴(defineComponent → props data/options → emits[update] → watch → PCS_CD/PCS_DTL_CD 변환):
 COT_DFT 코팅 · COT_SEG 부분코팅 · CVR_INN 속표지 · CVR_SWN 재봉 · DIR_MTR 직접자재 · END_PAP 면지 ·
 INN_DFT 내지마감 · INS_COT 내부코팅 · LAB_FBR 라벨원단 · PAK_ETC 포장기타 · PAK_POL 폴리백 ·
 PDT_WRK 작업방식 · PRT_IPK 개별포장표시 · PRT_WHT 화이트인쇄 · PRT_WHT_FACE 화이트면선택 ·
 RIN_DFT 링제본 · ROU_DFT 라운딩 · SCO_DFT 스코딕스 · SUB_MTR_BC 보조자재 · WRK_MTR 작업자재 ·
 Basic 기본자재 · CalendarQty 달력수량 · SetQty 세트수량 · SimpleQty 단순수량 · TotalQty 총수량.
 ========================================================================= */
/* =========================================================================
 섹션 16~28: 후가공(PostProcess) 개별 컴포넌트들
 각 후가공 유형별 UI 컴포넌트 — 아이콘 체크박스/라디오/셀렉트 형태.
 공통 패턴: setup → selectedValue ref → handleSelect → watch 로 PCS_CD/PCS_DTL_CD 구조 update emit → OptionRow + ImageButton 렌더.
 ========================================================================= */
/**
 * 표지 가이드(CoverGuide) 컴포넌트(withScopeId). 작업사이즈(workSize) 미리보기 + 템플릿 다운로드. 세네카/낱장커버 등 제본형태별 안내. 가로제본 상품(wirelessBindProducts/springBindProducts) 분기. __name="CoverGuide".
 */
/**
 * 인쇄도수(DosuColor) 컴포넌트. 도수 + 색상 2단 셀렉트. PRN_CNT/CLR_CD 로 update emit. __name="DosuColor".
 */
/**
 * 개별 포장(폴리백) 간이 라디오 컴포넌트 — 선택안함(PAK_POL/N)/선택함(PAK_POL/Y). 선택 시 PCS_CD/PCS_DTL_CD 구조로 update emit. __name="PAK_POL_Simple".
 */
/**
 * 의류 인쇄 컬러(팬톤) 선택 필드셋 컴포넌트. PantoneChipModal 을 열어 선택한 팬톤을 표시·전달. __name="ApparelPrintColor".
 */
/**
 * 팬톤 컬러 선택 모달 컴포넌트(withScopeId). 검색(공백 제거 후 pantone_name 매칭)·팔레트 선택·미리보기·툴팁. 검색 실패 시 안내 문구. __name="PantoneChipModal".
 */
/**
 * 용지(Paper) 선택 컴포넌트(책자용). 종류 + 평량(WGT_CD) 2단 셀렉트. MTRL_CD/MTRL_NM/MTRL_TYPE 로 update emit. __name="Paper".
 */
/**
 * 책자(Book) 수량/내지장수 컴포넌트(withScopeId). 수량선택 셀렉트 + 직접입력 토글. 토너/윤전 인쇄별 최소수량·내지 최대장수 안내. __name="BookQty".
 */
const LD = withScopeId(ND, [["render", kD]]),
  $D = {
    class: "pantone-layer",
  },
  xD = {
    class: "pantone-modal",
  },
  FD = {
    class: "modal-header",
  },
  UD = {
    class: "modal-body",
  },
  BD = {
    class: "color-palette",
  },
  VD = ["data-rgb", "data-checked", "onClick"],
  HD = {
    class: "pantone-number",
  },
  GD = {
    key: 1,
    class: "selected",
  },
  jD = {
    class: "preview",
  },
  zD = {
    class: "color-preview",
  },
  YD = {
    key: 1,
    class: "selected-color",
  },
  KD = {
    class: "not-found",
  },
  WD = ["src"],
  qD = {
    class: "pantone-mark",
  },
  QD = {
    class: "logo",
  },
  XD = {
    class: "icon-padding tip",
  },
  JD = {
    class: "tooltip",
  },
  ZD = {
    class: "tip-text",
  },
  eP = {
    class: "selected-color-text",
  },
  tP = {
    class: "color-search",
  },
  nP = ["placeholder"],
  oP = {
    class: "notice-txt",
  },
  sP = ["disabled"],
  rP = withScopeId(
    defineComponent({
      __name: "PantoneChipModal",
      props: {
        options: {},
        selected: {},
      },
      emits: ["close", "select"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = ref(null),
          r = computed(() => (s.value ? s.value : n.selected)),
          a = () => {
            r.value && o("select", r.value);
          },
          i = ref(""),
          l = ref(!1),
          c = () => {
            const u = i.value.toLowerCase().replace(/\s/g, ""),
              d = n.options.find((h) =>
                h.pantone_name.replace(/\s/g, "").toLowerCase().includes(u)
              );
            d ? ((s.value = d), (l.value = !1)) : ((s.value = null), (l.value = !0));
          };
        return (u, d) => {
          const h = resolveDirective("dompurify-html");
          return (
            openBlock(),
            createElementVNode("div", $D, [
              createElement("div", xD, [
                createElement("div", FD, [
                  createElement("h2", null, toDisplayString(unref(t)("팬톤 컬러 선택")), 1),
                  createElement(
                    "button",
                    {
                      type: "button",
                      class: "close-btn",
                      onClick: d[0] || (d[0] = (f) => o("close")),
                    },
                    [renderComponent(CloseIcon)]
                  ),
                ]),
                createElement("div", UD, [
                  createElement("div", BD, [
                    (openBlock(!0),
                    createElementVNode(
                      Fragment,
                      null,
                      renderList(
                        u.options,
                        (f) => (
                          openBlock(),
                          createElementVNode(
                            "span",
                            {
                              key: f.hex_cod,
                              class: "color-chip",
                              "data-rgb": f.hex_cod,
                              "data-checked": r.value?.hex_cod === f.hex_cod,
                              style: normalizeStyle({
                                backgroundColor: `rgb(${f.rgb_R}, ${f.rgb_G} ,${f.rgb_B})`,
                              }),
                              onClick: (_) => (s.value = f),
                            },
                            [
                              createElement(
                                "p",
                                HD,
                                toDisplayString(f.pantone_name.replace("PANTONE", "")),
                                1
                              ),
                              r.value?.hex_cod === f.hex_cod
                                ? (openBlock(),
                                  createVNode(LD, {
                                    key: 0,
                                  }))
                                : createCommentVNode("", !0),
                              r.value?.hex_cod === f.hex_cod
                                ? (openBlock(), createElementVNode("span", GD))
                                : createCommentVNode("", !0),
                            ],
                            12,
                            VD
                          )
                        )
                      ),
                      128
                    )),
                  ]),
                  createElement("div", jD, [
                    createElement("div", zD, [
                      r.value
                        ? (openBlock(),
                          createElementVNode(
                            "div",
                            {
                              key: 0,
                              class: "selected-color",
                              style: normalizeStyle({
                                backgroundColor: `rgb(${r.value.rgb_R}, ${r.value.rgb_G} ,${r.value.rgb_B})`,
                              }),
                            },
                            null,
                            4
                          ))
                        : l.value
                        ? (openBlock(),
                          createElementVNode("div", YD, [
                            withDirectives(createElement("p", KD, null, 512), [
                              [h, unref(t)("팬톤검색실패문구")],
                            ]),
                          ]))
                        : (openBlock(),
                          createElementVNode(
                            "img",
                            {
                              key: 2,
                              src: `${unref(
                                CDN_BASE_URL
                              )}/ko/item/page-order-clothes-pantone-modal.png`,
                              width: 240,
                              height: 150,
                              alt: "팬톤 선택 전 이미지",
                            },
                            null,
                            8,
                            WD
                          )),
                      createElement("div", qD, [
                        createElement("div", QD, [
                          d[3] ||
                            (d[3] = createStaticVNode(
                              '<div class="icon-padding" data-v-d02e5e9c><svg xmlns="http://www.w3.org/2000/svg" width="114" height="18" viewBox="0 0 114 18" fill="none" data-v-d02e5e9c><path d="M5.2351 3.46373H7.80534C8.7552 3.46373 9.92857 3.46373 10.5991 4.35773C10.8226 4.6371 10.9902 5.02822 11.0461 5.81047C11.0461 7.20734 10.4873 8.04546 9.09045 8.26896C8.69933 8.32483 8.41996 8.32483 7.69359 8.32483H5.2351V3.46373ZM1.15625 0.4465V16.6502H5.2351V11.3421H7.97296C10.3197 11.2862 12.6106 11.1744 14.1192 8.99533C15.0132 7.71021 15.069 6.31334 15.069 5.75459C15.069 4.13423 14.5103 2.96086 14.175 2.45799C13.8957 2.06687 13.6163 1.78749 13.4487 1.67574C12.2194 0.614124 10.7667 0.4465 9.2022 0.390625L1.15625 0.4465Z" fill="black" data-v-d02e5e9c></path><path d="M19.4282 11.1762C19.8194 9.83519 20.2664 8.49419 20.6575 7.1532C20.9368 6.20333 21.1603 5.25346 21.4397 4.30359L23.563 11.1762H19.4282ZM23.6188 0.448242H19.3724L13.3379 16.6519H17.6402L18.4225 14.0817H24.5128L25.2951 16.6519H29.5974L23.6188 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M34.9015 0.448242L38.4216 6.42683C39.2597 7.87957 40.0978 9.38819 40.88 10.8409L40.7124 0.448242H44.6237V16.6519H40.6565L37.6393 11.5114C37.1364 10.7292 36.6336 9.89106 36.1866 9.05294C35.6837 8.21482 35.2926 7.32083 34.7897 6.48271L34.9015 16.7078H30.9902V0.504117L34.9015 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M58.5433 0.448242V3.6331H54.3527V16.6519H50.2738V3.6331H46.0273V0.448242H58.5433Z" fill="black" data-v-d02e5e9c></path><path d="M70.7756 8.93897C70.7197 10.2241 70.3845 11.5092 69.4905 12.5149C68.4848 13.5766 67.1996 13.7442 66.6968 13.7442C65.6351 13.7442 64.6853 13.3531 63.9589 12.5708C63.2884 11.8445 62.6179 10.6711 62.6179 8.4361C62.6179 6.70398 63.1767 4.6925 64.797 3.7985C65.0764 3.63088 65.691 3.3515 66.585 3.3515C66.8644 3.3515 67.479 3.3515 68.1495 3.63088C69.0435 4.022 69.4905 4.58075 69.714 4.86012C70.2169 5.53061 70.8315 6.92748 70.7756 8.93897ZM71.7814 15.4763C73.7928 13.8559 74.8545 11.174 74.8545 8.71547C74.8545 6.48048 73.9605 3.85438 72.396 2.23401C71.5579 1.34002 69.6581 -0.000976562 66.585 -0.000976562C62.8414 -0.000976562 60.9417 2.06639 60.1036 3.29563C58.7067 5.36299 58.5391 7.70973 58.5391 8.54785C58.5391 9.49772 58.6508 12.5708 60.8858 14.9176C62.9532 17.0967 65.6351 17.2643 66.6409 17.2643C69.3229 17.1525 70.8874 16.2027 71.7814 15.4763Z" fill="black" data-v-d02e5e9c></path><path d="M80.7804 0.448242L84.3005 6.42683C85.1386 7.87957 85.9767 9.38819 86.759 10.8409L86.5913 0.448242H90.5026V16.6519H86.5355L83.5182 11.5114C83.0154 10.7292 82.5125 9.89106 82.0655 9.05294C81.5626 8.21482 81.1715 7.32083 80.6686 6.48271L80.7804 16.7078H76.8691V0.504117L80.7804 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M105.136 0.448242V3.57722H97.2019V6.53858H104.633V9.61169H97.2019V13.467H105.862V16.6519H93.123V0.448242H105.136Z" fill="black" data-v-d02e5e9c></path><path d="M109.269 2.90366V1.95379H109.884C110.108 1.95379 110.387 1.95379 110.499 2.17729C110.555 2.23317 110.555 2.34492 110.555 2.40079C110.555 2.45667 110.555 2.56841 110.499 2.62429C110.387 2.84779 110.219 2.84779 109.772 2.84779H109.269V2.90366ZM111.449 5.2504C111.281 4.91515 111.169 4.46815 111.169 4.3564C111.113 4.07703 111.113 3.68591 110.89 3.46241C110.834 3.40653 110.778 3.35066 110.61 3.29479C110.778 3.23891 110.778 3.23891 110.89 3.18304C111.002 3.12716 111.057 3.07129 111.113 2.95954C111.225 2.84779 111.337 2.68016 111.337 2.34492C111.337 2.23317 111.337 1.95379 111.113 1.67442C110.778 1.2833 110.219 1.2833 109.772 1.2833H108.431V5.19452H109.269V3.51828H109.493C109.772 3.51828 109.884 3.51828 109.996 3.63003C110.163 3.74178 110.219 3.85353 110.275 4.24465C110.331 4.52403 110.331 4.85928 110.443 5.13865C110.443 5.19452 110.499 5.19452 110.499 5.2504H111.449ZM112.901 3.29479C112.901 2.62429 112.734 1.95379 112.287 1.45092C111.672 0.668677 110.778 0.22168 109.828 0.22168C108.543 0.22168 107.761 0.94805 107.426 1.33917C107.202 1.61855 106.699 2.28904 106.699 3.29479C106.699 4.63578 107.481 5.41802 107.873 5.75327C108.431 6.14439 109.102 6.36789 109.772 6.36789C110.219 6.36789 111.281 6.25614 112.119 5.30627C112.845 4.52403 112.901 3.68591 112.901 3.29479ZM112.622 3.29479C112.622 4.46815 111.896 5.52977 110.778 5.92089C110.331 6.08852 109.996 6.08852 109.828 6.08852C108.711 6.08852 107.649 5.41802 107.202 4.3564C107.09 4.02116 106.979 3.68591 106.979 3.29479C106.979 2.00967 107.761 1.2833 108.152 1.00392C108.822 0.501053 109.493 0.445178 109.828 0.445178C111.113 0.445178 111.784 1.17155 112.063 1.56267C112.566 2.28904 112.622 3.01541 112.622 3.29479Z" fill="black" data-v-d02e5e9c></path></svg></div>',
                              1
                            )),
                          createElement("div", XD, [
                            d[2] ||
                              (d[2] = createElement(
                                "svg",
                                {
                                  xmlns: "http://www.w3.org/2000/svg",
                                  width: "21",
                                  height: "20",
                                  viewBox: "0 0 21 20",
                                  fill: "none",
                                },
                                [
                                  createElement("path", {
                                    d: "M10.3125 2.5C14.4546 2.5 17.8125 5.85787 17.8125 10C17.8125 14.1421 14.4546 17.5 10.3125 17.5C6.17036 17.5 2.8125 14.1421 2.8125 10C2.8125 5.85787 6.17036 2.5 10.3125 2.5Z",
                                    stroke: "#222222",
                                    "stroke-width": "1.15625",
                                    "stroke-miterlimit": "10",
                                  }),
                                  createElement("path", {
                                    d: "M10.3125 13.75V9.375",
                                    stroke: "#222222",
                                    "stroke-width": "1.41063",
                                    "stroke-linecap": "round",
                                    "stroke-linejoin": "round",
                                  }),
                                  createElement("path", {
                                    d: "M10.3125 5.625C10.8303 5.625 11.25 6.04473 11.25 6.5625C11.25 7.08027 10.8303 7.5 10.3125 7.5C9.79473 7.5 9.375 7.08027 9.375 6.5625C9.375 6.04473 9.79473 5.625 10.3125 5.625Z",
                                    fill: "#222222",
                                  }),
                                ],
                                -1
                              )),
                            createElement("div", JD, [
                              createElement("p", ZD, toDisplayString(unref(t)("팬톤검색안내")), 1),
                            ]),
                          ]),
                        ]),
                        createElement(
                          "span",
                          eP,
                          toDisplayString(
                            r.value ? r.value.pantone_name.replace("PANTONE ", "") : "PANTONE#"
                          ),
                          1
                        ),
                      ]),
                    ]),
                    createElement("div", tP, [
                      createElement(
                        "form",
                        {
                          onSubmit: withModifiers(c, ["prevent"]),
                        },
                        [
                          withDirectives(
                            createElement(
                              "input",
                              {
                                "onUpdate:modelValue": d[1] || (d[1] = (f) => (i.value = f)),
                                type: "text",
                                name: "pantone",
                                placeholder: unref(t)("넘버 입력"),
                                "data-gtm-form-interact-field-id": "0",
                              },
                              null,
                              8,
                              nP
                            ),
                            [[vModelText, i.value]]
                          ),
                          d[4] ||
                            (d[4] = createElement(
                              "button",
                              {
                                type: "submit",
                                class: "search-btn",
                              },
                              null,
                              -1
                            )),
                        ],
                        32
                      ),
                      createElement("p", oP, toDisplayString(unref(t)("팬톤검색문구")), 1),
                    ]),
                    createElement(
                      "button",
                      {
                        type: "button",
                        class: "confirm-btn",
                        disabled: !r.value,
                        onClick: a,
                      },
                      toDisplayString(unref(t)("적용하기")),
                      9,
                      sP
                    ),
                  ]),
                ]),
              ]),
            ])
          );
        };
      },
    }),
    [["__scopeId", "data-v-d02e5e9c"]]
  ),
  iP = {
    class: "special-option",
  },
  aP = ["src"],
  lP = {
    class: "text",
  },
  uP = {
    class: "desc",
  },
  cP = {
    class: "detail",
  },
  dP = {
    class: "detail-subject",
  },
  fP = {
    class: "detail-value",
  },
  pP = defineComponent({
    __name: "ApparelPrintColor",
    props: {
      options: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = inject("callbacks", {}),
        r = inject("deviceType", "pc"),
        a = useEditorStore(),
        i = ref(!1),
        l = () => (i.value = !i.value),
        c = ref(null),
        u = (f) => {
          (c.value = f), r === "pc" && !s.onSetPantone && l();
        },
        d = () => {
          s.onSetPantone
            ? s.onSetPantone({
                options: [...n.options],
                setter: u,
              })
            : l();
        },
        h = () => {
          s?.onReset && s.onReset("printColor");
        };
      return (
        watch(
          () => c.value,
          (f) => {
            if (!f) return;
            a.isAfterEdit() && h();
            const { pantone_name: _ } = f,
              p = _.replace("PANTONE ", "");
            o("update", {
              ...f,
              pantone_code: p,
            });
          }
        ),
        (f, _) => (
          openBlock(),
          createElementVNode(
            Fragment,
            null,
            [
              renderComponent(
                OptionRow,
                {
                  title: "인쇄 컬러(팬톤)",
                },
                {
                  default: withCtx(() => [
                    createElement("div", iP, [
                      createElement("figure", null, [
                        createElement(
                          "img",
                          {
                            src: `${unref(CDN_BASE_URL)}/ko/item/page-order-clothes-pantone.png`,
                            alt: "팬톤 컬러 이미지",
                          },
                          null,
                          8,
                          aP
                        ),
                        createElement("p", lP, toDisplayString(unref(t)("팬톤 컬러")), 1),
                      ]),
                      createElement("div", uP, [
                        createElement("div", cP, [
                          createElement("p", dP, toDisplayString(unref(t)("1종 선택 가능")), 1),
                          createElement(
                            "span",
                            fP,
                            toDisplayString(c.value?.pantone_name || "PANTONE"),
                            1
                          ),
                        ]),
                        createElement(
                          "button",
                          {
                            type: "button",
                            onClick: d,
                          },
                          toDisplayString(unref(t)("팬톤 컬러 선택하기")),
                          1
                        ),
                      ]),
                    ]),
                  ]),
                  _: 1,
                }
              ),
              i.value
                ? (openBlock(),
                  createVNode(
                    rP,
                    {
                      key: 0,
                      options: f.options,
                      selected: c.value,
                      onClose: l,
                      onSelect: u,
                    },
                    null,
                    8,
                    ["options", "selected"]
                  ))
                : createCommentVNode("", !0),
            ],
            64
          )
        )
      );
    },
  }),
  ih = defineComponent({
    __name: "PAK_POL_Simple",
    props: {
      detail: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = ref("N");
      return (
        watch(
          () => s.value,
          (r) => {
            const {
              PCS_CD: a,
              PCS_GRP_NM: i,
              PCS_DTL_CD: l,
              PCS_DTL_NM: c,
              VIEW_YN: u,
              ESN_YN: d,
            } = n.detail;
            o(
              "update",
              r === "Y"
                ? [
                    {
                      PCS_CD: a,
                      PCS_GRP_NM: i,
                      VIEW_YN: u,
                      ESN_YN: d,
                      selectedOptions: [
                        {
                          PCS_CD: a,
                          PCS_DTL_CD: l,
                          PCS_DTL_NM: c,
                        },
                      ],
                    },
                  ]
                : []
            );
          },
          {
            immediate: !0,
          }
        ),
        (r, a) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "개별 포장",
            },
            {
              default: withCtx(() => [
                renderComponent(
                  RadioGroup,
                  {
                    options: [
                      {
                        id: "PAK_POL/N",
                        name: "PAK_POL",
                        label: "선택안함",
                        value: "N",
                      },
                      {
                        id: "PAK_POL/Y",
                        name: "PAK_POL",
                        label: "선택함",
                        value: "Y",
                      },
                    ],
                    "default-checked": s.value,
                    onChange: a[0] || (a[0] = (i) => (s.value = i.value)),
                  },
                  null,
                  8,
                  ["default-checked"]
                ),
              ]),
              _: 1,
            }
          )
        )
      );
    },
  }),
  _P = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: ih,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  hP = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "Apparel",
          props: {
            type: {
              default: "new",
            },
            data: {},
            widgetAttr: {},
            defaultData: {},
            senecaInfo: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = computed(() => n.widgetAttr.skinInfo),
              r = inject("member"),
              a = computed(() => c.value.clothesSelectData?.printType),
              i = computed(() =>
                a.value?.PRINT_GBN === "N"
                  ? "single"
                  : a.value?.COD === "PTP_SLK"
                  ? "multi"
                  : "single"
              ),
              { uploadConfig: l } = useUploadConfig(n.widgetAttr),
              {
                orderInfo: c,
                updateOption: u,
                updatePcsOption: d,
              } = useOrderComposable(n.type, {
                group: n.widgetAttr.item_gbn,
                emits: {
                  updateOrder: (b) => o("update", b),
                },
              }),
              h = computed(() => c.value.clothesSelectData?.colorInfo?.COD),
              f = computed(() =>
                n.data.apparel_info?.size_info.reduce((b, C) => ((b[C.COD] = C), b), {})
              ),
              _ = computed(() => {
                if (h.value)
                  return n.data.apparel_info?.size_color_info.filter((b) => b.CLR_COD === h.value);
              }),
              p = reactive({}),
              m = ref(null),
              v = computed(() => m.value?.reduce((b, C) => ((b[C.size.MTRL_COD] = C), b), {}));
            watch(
              () => m.value,
              (b) => {
                if (!b) return;
                u("sizeInfo", !0)(b);
                const C = n.data.pdt_mtrl_info.filter((y) => y.MTRL_CD === b[0]?.size.MTRL_COD);
                if (C.length > 0) {
                  const {
                    PTT_CD: y,
                    PTT_NM: I,
                    WGT_CD: w,
                    CLR_CD: U,
                    MTRL_CD: Z,
                    MTRL_NM: me,
                    MTRL_TYPE: _e,
                    PRT_HIDE_YN: B,
                  } = C[0];
                  u("meterialInfo")({
                    PTT_CD: y,
                    PTT_NM: I,
                    WGT_CD: w,
                    CLR_CD: U,
                    MTRL_CD: Z,
                    MTRL_NM: me,
                    MTRL_TYPE: _e,
                    PRT_HIDE_YN: B,
                  });
                }
              }
            ),
              watch(
                () => v.value,
                (b) => {
                  if (!b) return;
                  const C = n.data.pdt_pcs_info
                    .filter((y) => y.PCS_CD === "DIR_MTR" && y.MTRL_CD && b[y.MTRL_CD])
                    .map((y) => {
                      const {
                          PCS_CD: I,
                          PCS_DTL_CD: w,
                          PCS_DTL_NM: U,
                          VIEW_YN: Z,
                          MTRL_CD: me,
                          ESN_YN: _e,
                          DIV_SEQ: B,
                        } = y,
                        W = [
                          {
                            PCS_CD: I,
                            PCS_DTL_CD: w,
                            PCS_DTL_NM: U,
                            ATTB: b[me || ""].quantity,
                          },
                        ];
                      return {
                        PCS_CD: I,
                        VIEW_YN: Z,
                        ESN_YN: _e,
                        DIV_SEQ: B,
                        active: !1,
                        selectedOptions: W,
                      };
                    });
                  p.DIR_MTR = C;
                }
              );
            const E = ref(null),
              k = computed(() =>
                n.data.pdt_pcs_info.reduce(
                  (b, C) => (C.PCS_CD === "PDT_WRK" && (b[C.PCS_DTL_CD] = C), b),
                  {}
                )
              );
            watch(
              () => E.value,
              (b) => {
                u("PrintAreaInfo", !0)(b);
                const C = b
                  ? b?.map((y) => {
                      const I = k.value[y.COD],
                        { PCS_CD: w, PCS_DTL_CD: U, PCS_DTL_NM: Z, VIEW_YN: me, ESN_YN: _e } = I,
                        B = [
                          {
                            PCS_CD: w,
                            PCS_DTL_CD: U,
                            PCS_DTL_NM: Z,
                            KOI_NME: y.KOI_NME,
                          },
                        ];
                      return {
                        PCS_CD: w,
                        VIEW_YN: me,
                        ESN_YN: _e,
                        active: !0,
                        selectedOptions: B,
                      };
                    })
                  : [];
                p.PDT_WRK = C;
              }
            );
            const N = computed(() => n.data.pdt_pcs_info.find((b) => b.PCS_CD === "PAK_POL"));
            watch(
              () => p,
              (b) => {
                d("POST_PCS")(Object.values(b).flatMap((C) => C));
              },
              {
                deep: !0,
              }
            ),
              watch(
                () => n.data.pdt_size_info,
                (b) => {
                  if (!b || !b[0]) return;
                  const C = {
                    DIV_NM: b[0].DIV_NM || "",
                    DIV_SEQ: b[0].DIV_SEQ,
                    DivInfo: {},
                    cutSize: {
                      width: +b[0].CUT_WDT,
                      height: +b[0].CUT_HGH,
                    },
                    workSize: {
                      width: +b[0].WRK_WDT,
                      height: +b[0].WRK_HGH,
                    },
                  };
                  u("sizeInfo")(C);
                },
                {
                  immediate: !0,
                  once: !0,
                }
              );
            const D = inject("callbacks", {}),
              O = useEditorStore(),
              A = () => {
                D?.onReset && D.onReset("fileUpload");
              };
            return (
              watch(
                () => a.value,
                (b) => {
                  b.PRINT_GBN === "N" &&
                    (c.value.fileUploadInfo &&
                      c.value.fileUploadInfo[0] &&
                      (u("fileUploadInfo")([null]), A()),
                    O.editorData.default && A());
                }
              ),
              (b, C) => (
                openBlock(),
                createElementVNode(
                  Fragment,
                  null,
                  [
                    b.data.apparel_info?.print_type
                      ? (openBlock(),
                        createVNode(
                          JS,
                          {
                            key: 0,
                            options: b.data.apparel_info?.print_type,
                            "dosu-options": b.data.pdt_dosu_info,
                            "related-data": {
                              color: h.value,
                            },
                            "onUpdate:type": C[0] || (C[0] = (y) => unref(u)("printType", !0)(y)),
                            "onUpdate:dosu": C[1] || (C[1] = (y) => unref(u)("dosuInfo")(y)),
                          },
                          null,
                          8,
                          ["options", "dosu-options", "related-data"]
                        ))
                      : createCommentVNode("", !0),
                    b.data.apparel_info?.apparel_color
                      ? (openBlock(),
                        createVNode(
                          uD,
                          {
                            key: 1,
                            options: b.data.apparel_info.apparel_color,
                            onUpdate: C[2] || (C[2] = (y) => unref(u)("colorInfo", !0)(y)),
                          },
                          null,
                          8,
                          ["options"]
                        ))
                      : createCommentVNode("", !0),
                    _.value && i.value === "single" && f.value
                      ? (openBlock(),
                        createVNode(
                          bD,
                          {
                            key: 2,
                            options: _.value,
                            "size-info": f.value,
                            "onUpdate:qty": C[3] || (C[3] = (y) => unref(u)("quantityInfo")(y)),
                            "onUpdate:combinations": C[4] || (C[4] = (y) => (m.value = y)),
                          },
                          null,
                          8,
                          ["options", "size-info"]
                        ))
                      : createCommentVNode("", !0),
                    _.value && i.value === "multi" && f.value
                      ? (openBlock(),
                        createVNode(
                          AD,
                          {
                            key: 3,
                            options: _.value,
                            "size-info": f.value,
                            "onUpdate:qty": C[5] || (C[5] = (y) => unref(u)("quantityInfo")(y)),
                            "onUpdate:combinations": C[6] || (C[6] = (y) => (m.value = y)),
                          },
                          null,
                          8,
                          ["options", "size-info"]
                        ))
                      : createCommentVNode("", !0),
                    b.data.apparel_info?.print_area
                      ? (openBlock(),
                        createVNode(
                          hD,
                          {
                            key: 4,
                            options: b.data.apparel_info.print_area,
                            "related-data": {
                              printType: a.value,
                            },
                            onUpdate: C[7] || (C[7] = (y) => (E.value = y)),
                          },
                          null,
                          8,
                          ["options", "related-data"]
                        ))
                      : createCommentVNode("", !0),
                    b.data.apparel_info?.pantone_color &&
                    unref(c).clothesSelectData?.printType?.COD === "PTP_SLK"
                      ? (openBlock(),
                        createVNode(
                          pP,
                          {
                            key: 5,
                            options: b.data.apparel_info.pantone_color,
                            onUpdate: C[8] || (C[8] = (y) => unref(u)("pantoneInfo", !0)(y)),
                          },
                          null,
                          8,
                          ["options"]
                        ))
                      : createCommentVNode("", !0),
                    s.value.subjectGroup.view_yn === "Y"
                      ? (openBlock(),
                        createVNode(
                          SubjectGroup,
                          {
                            key: 6,
                            "is-biz-mem": unref(r)?.bsn_yn === "Y",
                            onUpdate: C[9] || (C[9] = (y) => unref(u)("etcInfo")(y)),
                          },
                          null,
                          8,
                          ["is-biz-mem"]
                        ))
                      : createCommentVNode("", !0),
                    N.value
                      ? (openBlock(),
                        createVNode(
                          ih,
                          {
                            key: 7,
                            detail: N.value,
                            onUpdate: C[10] || (C[10] = (y) => (p.PAK_POL = y)),
                          },
                          null,
                          8,
                          ["detail"]
                        ))
                      : createCommentVNode("", !0),
                    a.value?.PRINT_GBN === "Y" && b.widgetAttr.order_yn !== "N"
                      ? (openBlock(),
                        createVNode(
                          FileUpload,
                          {
                            key: 8,
                            "upload-config": unref(l),
                            "show-extra":
                              b.widgetAttr.useTemplateDownload === "Y" &&
                              b.widgetAttr.usePDF === "Y",
                            "related-data": {
                              apparel: {
                                printType: a.value?.COD,
                                pantone: unref(c).clothesSelectData.pantoneInfo?.hex_cod,
                              },
                            },
                            onUpload: C[11] || (C[11] = (y) => unref(u)("fileUploadInfo")(y)),
                          },
                          null,
                          8,
                          ["upload-config", "show-extra", "related-data"]
                        ))
                      : createCommentVNode("", !0),
                  ],
                  64
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  mP = {
    class: "flex-row -center",
  },
  vP = ["id"],
  gP = ["name"],
  yP = ["value"],
  CP = {
    key: 0,
    class: "notes",
  },
  TP = {
    key: 0,
    class: "note",
  },
  bP = {
    key: 1,
    class: "note",
  },
  SP = {
    key: 1,
    class: "notes",
  },
  DP = {
    class: "note",
  },
  PP = {
    class: "note",
  },
  BookQty = withScopeId(
    defineComponent({
      __name: "BookQty",
      props: {
        type: {},
        options: {},
        relatedData: {},
      },
      emits: ["update"],
      setup(e, { emit: t }) {
        const n = e,
          o = t,
          s = inject("productCode", {
            pdtCode: "",
          }),
          r = computed(() => s.pdtCode[4] === "O"),
          a = computed(() => n.options[0]),
          i = computed(() => (n.type === "default" ? a.value.INC_CNT : a.value.STEP_INN_PAGE)),
          l = computed(() => n.type === "default" && a.value.FIR_CNT === 2),
          c = computed(() => (n.type === "default" ? a.value.MIN_PRN_CNT : a.value.MIN_INN_PAGE)),
          u = computed(() => (n.type === "default" ? null : a.value.MAX_INN_PAGE)),
          d = ref(c.value),
          h = computed(() => !!(c.value > d.value || (u.value && u.value < d.value)));
        watch(
          () => d.value,
          (E) => {
            h.value || o("update", n.type, E);
          },
          {
            immediate: !0,
          }
        );
        const f = computed(() => {
            const E = n.relatedData?.dosu === "SID_D" ? 2 : 1;
            return (d.value * E).toLocaleString();
          }),
          _ = () => {
            if (c.value > d.value) return (d.value = c.value);
            if (u.value && u.value < d.value) return (d.value = u.value);
            if (n.type === "default" && l.value) {
              const E = d.value % 2;
              if (E > 0) return (d.value = d.value + E);
            }
            if (n.type === "inner" && i.value === 2) {
              const E = d.value % 2;
              if (E > 0) return (d.value = d.value + E);
            }
          },
          p = computed(() => {
            const E = [],
              k = i.value > c.value ? i.value : c.value,
              N = i.value > c.value ? 10 : 9,
              D = u.value ?? i.value * N + c.value;
            for (let O = k; O <= D; O += i.value)
              O === i.value &&
                i.value > c.value &&
                E.push({
                  value: c.value,
                }),
                E.push({
                  value: O,
                });
            return E;
          }),
          m = ref("select"),
          v = () => {
            m.value = m.value === "input" ? "select" : "input";
          };
        return (E, k) => {
          const N = resolveDirective("dompurify-html");
          return (
            openBlock(),
            createVNode(
              OptionRow,
              {
                title: E.type === "default" ? unref(t)("수량") : unref(t)("내지장수"),
              },
              {
                default: withCtx(() => [
                  createElement("div", mP, [
                    m.value === "input"
                      ? withDirectives(
                          (openBlock(),
                          createElementVNode(
                            "input",
                            {
                              key: 0,
                              "onUpdate:modelValue": k[0] || (k[0] = (D) => (d.value = D)),
                              type: "number",
                              class: normalizeClass(["basic-input", "-fixed-w"]),
                              id: E.type === "default" ? "QTY" : "INNER_QTY",
                              onFocusout: _,
                            },
                            null,
                            40,
                            vP
                          )),
                          [[vModelText, d.value]]
                        )
                      : withDirectives(
                          (openBlock(),
                          createElementVNode(
                            "select",
                            {
                              key: 1,
                              "onUpdate:modelValue": k[1] || (k[1] = (D) => (d.value = D)),
                              name: E.type === "default" ? "QTY" : "INNER_QTY",
                              class: "basic-select -fixed-w",
                            },
                            [
                              (openBlock(!0),
                              createElementVNode(
                                Fragment,
                                null,
                                renderList(
                                  p.value,
                                  (D) => (
                                    openBlock(),
                                    createElementVNode(
                                      "option",
                                      {
                                        value: D.value,
                                        key: D.value,
                                      },
                                      toDisplayString(D.value),
                                      9,
                                      yP
                                    )
                                  )
                                ),
                                128
                              )),
                            ],
                            8,
                            gP
                          )),
                          [[vModelSelect, d.value]]
                        ),
                    createElement(
                      "button",
                      {
                        type: "button",
                        class: "action-btn",
                        onClick: v,
                      },
                      toDisplayString(
                        m.value === "input" ? unref(t)("수량선택") : unref(t)("직접입력")
                      ),
                      1
                    ),
                  ]),
                  E.type === "default"
                    ? (openBlock(),
                      createElementVNode("div", CP, [
                        r.value
                          ? withDirectives((openBlock(), createElementVNode("p", bP, null, 512)), [
                              [
                                N,
                                unref(t)(
                                  l.value ? "토너책자최소수량안내-짝수" : "토너책자최소수량안내"
                                ).replace("{MIN_CNT}", `${c.value}`),
                              ],
                            ])
                          : withDirectives((openBlock(), createElementVNode("p", TP, null, 512)), [
                              [
                                N,
                                unref(t)("윤전책자최소수량안내").replace("{MIN_CNT}", `${c.value}`),
                              ],
                            ]),
                      ]))
                    : (openBlock(),
                      createElementVNode("div", SP, [
                        withDirectives(createElement("p", DP, null, 512), [
                          [N, unref(t)("내지장수안내").replace("{QTY}", `${f.value}`)],
                        ]),
                        withDirectives(createElement("p", PP, null, 512), [
                          [N, unref(t)("내지최대장수안내").replace("{MAX_CNT}", `${u.value}`)],
                        ]),
                      ])),
                ]),
                _: 1,
              },
              8,
              ["title"]
            )
          );
        };
      },
    }),
    [["__scopeId", "data-v-106e3545"]]
  ),
  EP = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: BookQty,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  OP = {
    class: "flex-row",
  },
  IP = ["value"],
  RP = ["value"],
  ah = defineComponent({
    __name: "DosuColor",
    props: {
      options: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = inject("callbacks", {}),
        r = useEditorStore(),
        a = computed(() => n.options.all.length > n.options.dosu.length),
        i = ref(n.options.dosu[0].COD),
        l = ref(n.options.color[0].COD),
        c = computed(() => n.options.all.find((d) => d.BNC_GB === l.value && d.COD === i.value)),
        u = () => {
          s?.onReset && s.onReset("dosu");
        };
      return (
        watch(
          () => c.value,
          (d) => {
            d && (r.isAfterEdit() && u(), o("update", d));
          },
          {
            immediate: !0,
          }
        ),
        (d, h) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "인쇄도수",
            },
            {
              default: withCtx(() => [
                createElement("div", OP, [
                  withDirectives(
                    createElement(
                      "select",
                      {
                        "onUpdate:modelValue": h[0] || (h[0] = (f) => (i.value = f)),
                        name: "dosu",
                        class: "basic-select",
                      },
                      [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            d.options.dosu,
                            (f) => (
                              openBlock(),
                              createElementVNode(
                                "option",
                                {
                                  key: f.COD,
                                  value: f.COD,
                                },
                                toDisplayString(f.COD_NME),
                                9,
                                IP
                              )
                            )
                          ),
                          128
                        )),
                      ],
                      512
                    ),
                    [[vModelSelect, i.value]]
                  ),
                  a.value
                    ? withDirectives(
                        (openBlock(),
                        createElementVNode(
                          "select",
                          {
                            key: 0,
                            "onUpdate:modelValue": h[1] || (h[1] = (f) => (l.value = f)),
                            name: "dosu-color",
                            class: "basic-select",
                          },
                          [
                            (openBlock(!0),
                            createElementVNode(
                              Fragment,
                              null,
                              renderList(
                                d.options.color,
                                (f) => (
                                  openBlock(),
                                  createElementVNode(
                                    "option",
                                    {
                                      key: f.COD,
                                      value: f.COD,
                                    },
                                    toDisplayString(f.COD_NME),
                                    9,
                                    RP
                                  )
                                )
                              ),
                              128
                            )),
                          ],
                          512
                        )),
                        [[vModelSelect, l.value]]
                      )
                    : createCommentVNode("", !0),
                ]),
              ]),
              _: 1,
            }
          )
        )
      );
    },
  }),
  wP = {
    class: "flex-row",
  },
  AP = ["value", "disabled"],
  NP = ["value", "disabled"],
  Paper = defineComponent({
    __name: "Paper",
    props: {
      options: {},
      showExtra: {
        type: Boolean,
        default: !1,
      },
      default: {},
      resetAfterEdit: {
        type: Boolean,
      },
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = inject("callbacks", {}),
        r = inject("productCode", {
          pdtCode: "",
        }),
        a = useI18n(),
        i = computed(() => {
          const p = [];
          return p.length > 0 ? p : n.options;
        }),
        l = computed(() => i.value.filter((p) => p.HIDE_YN !== "Y")),
        c = computed(() => {
          const p = new Map();
          return (
            i.value.forEach((m) => {
              const {
                  WGT_CD: v,
                  MTRL_CD: E,
                  PTT_CD: k,
                  PTT_NM: N,
                  BSN_YN: D,
                  HIDE_YN: O,
                  HIDE_RSN: A,
                } = m,
                b = p.get(k),
                C = {
                  WGT_CD: v,
                  MTRL_CD: E,
                  HIDE_YN: O,
                  HIDE_RSN: A,
                };
              if (b) b.weights.push(C);
              else {
                const y = {
                  PTT_CD: k,
                  PTT_NM: N,
                  BSN_YN: D,
                  weights: [C],
                };
                p.set(k, y);
              }
            }),
            p
          );
        }),
        u = async () => {
          const p = await fetchMaterialInfo({
            pdt_cod: r.pdtCode,
            lang: a.locale,
          });
          if (!p) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
          s?.onInformMaterials
            ? s.onInformMaterials(p)
            : console.log("[RedWidgetSDK] 용지 정보 >", p);
        },
        d = () => {
          n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
        },
        h = (p) => p.every((m) => m.HIDE_YN === "Y"),
        f = ref(n.default?.PTT_CD || l.value[0]?.PTT_CD),
        _ = ref(n.default?.MTRL_CD || l.value[0]?.MTRL_CD);
      return (
        watch(
          () => f.value,
          (p) => {
            const m = c.value.get(p);
            if (m) {
              const v = m.weights.find((E) => E.HIDE_YN !== "Y");
              v && (_.value = v.MTRL_CD);
            }
            p === "OOO" && s?.onSaleOrder && s?.onSaleOrder();
          },
          {
            immediate: !0,
          }
        ),
        watch(
          () => _.value,
          (p) => {
            const m = l.value.find((v) => v.MTRL_CD === p);
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
                SID_GBN: C,
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
                SID_GBN: C,
              });
            }
          },
          {
            immediate: !0,
          }
        ),
        (p, m) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "용지",
              extra: p.showExtra
                ? {
                    name: "주문가능자재",
                    callback: u,
                  }
                : null,
            },
            {
              default: withCtx(() => [
                createElement("div", wP, [
                  withDirectives(
                    createElement(
                      "select",
                      {
                        "onUpdate:modelValue": m[0] || (m[0] = (v) => (f.value = v)),
                        class: "basic-select",
                        name: "paper",
                      },
                      [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            c.value.values(),
                            (v) => (
                              openBlock(),
                              createElementVNode(
                                "option",
                                {
                                  key: v.PTT_CD,
                                  value: v.PTT_CD,
                                  disabled: h(v.weights),
                                  onChange: d,
                                },
                                toDisplayString(
                                  h(v.weights) ? `[${v.weights[0].HIDE_RSN || "주문불가"}]` : ""
                                ) +
                                  " " +
                                  toDisplayString(v.PTT_NM) +
                                  " " +
                                  toDisplayString(v.BSN_YN === "Y" ? "[영업주문]" : ""),
                                41,
                                AP
                              )
                            )
                          ),
                          128
                        )),
                      ],
                      512
                    ),
                    [[vModelSelect, f.value]]
                  ),
                  withDirectives(
                    createElement(
                      "select",
                      {
                        "onUpdate:modelValue": m[1] || (m[1] = (v) => (_.value = v)),
                        class: "basic-select",
                        name: "weight",
                      },
                      [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            c.value.get(f.value)?.weights,
                            (v) => (
                              openBlock(),
                              createElementVNode(
                                "option",
                                {
                                  key: `${v.MTRL_CD}`,
                                  value: v.MTRL_CD,
                                  disabled: v.HIDE_YN === "Y",
                                },
                                toDisplayString(
                                  v.HIDE_YN === "Y" ? `[${v.HIDE_RSN || "주문불가"}]` : ""
                                ) +
                                  " " +
                                  toDisplayString(`${v.WGT_CD}g`),
                                9,
                                NP
                              )
                            )
                          ),
                          128
                        )),
                      ],
                      512
                    ),
                    [[vModelSelect, _.value]]
                  ),
                ]),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        )
      );
    },
  }),
  MP = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: Paper,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  kP = {
    class: "special-option",
  },
  LP = ["src"],
  $P = {
    class: "text",
  },
  xP = {
    class: "desc",
  },
  FP = {
    key: 0,
    class: "detail",
  },
  UP = {
    class: "detail-subject",
  },
  BP = {
    class: "detail-value",
  },
  VP = {
    key: 1,
    class: "detail",
  },
  HP = {
    class: "detail-subject",
  },
  GP = {
    class: "detail-value",
  },
  jP = withScopeId(
    defineComponent({
      __name: "CoverGuide",
      props: {
        sizeInfo: {},
        senecaInfo: {},
      },
      setup(e) {
        const t = e,
          n = inject("productCode", {
            pdtCode: "",
          }),
          o = inject("callbacks", {}),
          s = ref(t.senecaInfo);
        watch(
          () => t.senecaInfo,
          (f) => {
            f && (s.value = f);
          }
        );
        const r = useOrderDataStore(),
          a = useI18n(),
          i = async () => {
            const f = r.getOrderData();
            if (!f) return;
            const _ = dS(f);
            if (!_ || typeof _ == "string") return alert(t(_ || "템플릿다운로드실패"));
            (await BT({
              lang: a.locale,
              ..._,
            })) || alert(t("템플릿다운로드실패"));
          },
          l = {
            PRBKYPB: !0,
            PRBKYCB: !0,
            PRBKYRB: !0,
            PRBKOPB: !0,
            PRBKOCB: !0,
            PRBKORB: !0,
          },
          c = {
            PRBKYPR: !0,
            PRBKOPR: !0,
            PRBKYPB: !0,
            PRBKOPB: !0,
          },
          u = {
            PRBKYCO: !0,
            PRBKYCB: !0,
            PRBKYRN: !0,
            PRBKYRB: !0,
            PRBKOCO: !0,
            PRBKOCB: !0,
            PRBKORN: !0,
            PRBKORB: !0,
            PRBKORD: !0,
            PRBKOCD: !0,
          },
          d = {
            PRBKYST: !0,
            PRBKYSL: !0,
            PRBKOST: !0,
            PRBKOSL: !0,
          },
          h = computed(() => {
            if (!t.sizeInfo) return null;
            if (d[n.pdtCode])
              return {
                title: "소프트커버",
                imgSrc: `${CDN_BASE_URL}/ko/cover_icon_stapler.png`,
              };
            const _ =
                t.sizeInfo.workSize.width > t.sizeInfo.workSize.height
                  ? horizontalBindSet.has(n.pdtCode)
                    ? "_wh"
                    : "_w"
                  : "_h",
              p = l[n.pdtCode] ? "_black" : "";
            return c[n.pdtCode]
              ? {
                  title: "세네카",
                  imgSrc: `${CDN_BASE_URL}/ko/cover_icon_wireless${p}${_}.png`,
                }
              : u[n.pdtCode]
              ? {
                  title: "낱장커버",
                  imgSrc: `${CDN_BASE_URL}/ko/cover_icon_spring${p}${_}.png`,
                }
              : null;
          });
        return (f, _) => (
          openBlock(),
          createVNode(
            OptionRow,
            {
              title: "표지가이드",
              extra: {
                name: "가이드보기",
                callback: () => {
                  unref(o)?.onInformGuide && unref(o).onInformGuide("bookCover");
                },
              },
            },
            {
              default: withCtx(() => [
                createElement("div", kP, [
                  createElement("figure", null, [
                    createElement(
                      "img",
                      {
                        src: h.value?.imgSrc,
                      },
                      null,
                      8,
                      LP
                    ),
                    createElement(
                      "figcaption",
                      $P,
                      toDisplayString(unref(t)(h.value?.title || "")),
                      1
                    ),
                  ]),
                  createElement("div", xP, [
                    s.value?.seneca_show === "Y"
                      ? (openBlock(),
                        createElementVNode("div", FP, [
                          createElement("p", UP, toDisplayString(unref(t)("세네카")), 1),
                          createElement("span", BP, [
                            createElement("b", null, toDisplayString(s.value?.seneca), 1),
                            _[0] || (_[0] = createTextVNode(" mm ", -1)),
                          ]),
                        ]))
                      : (openBlock(),
                        createElementVNode("div", VP, [
                          createElement("p", HP, toDisplayString(unref(t)("표지작업사이즈")), 1),
                          createElement("span", GP, [
                            createElement(
                              "b",
                              null,
                              toDisplayString(f.sizeInfo?.workSize.width) +
                                "x" +
                                toDisplayString(f.sizeInfo?.workSize.height),
                              1
                            ),
                            _[1] || (_[1] = createTextVNode(" mm ", -1)),
                          ]),
                        ])),
                    createElement(
                      "button",
                      {
                        type: "button",
                        class: "download-btn",
                        onClick: i,
                      },
                      toDisplayString(unref(t)("표지템플릿다운로드")),
                      1
                    ),
                  ]),
                ]),
              ]),
              _: 1,
            },
            8,
            ["extra"]
          )
        );
      },
    }),
    [["__scopeId", "data-v-7f08ebe2"]]
  ),
  zP = {
    class: "group-title",
  },
  YP = {
    class: "subject",
  },
  KP = {
    class: "group-title",
  },
  WP = {
    class: "subject",
  },
  qP = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "Book",
            props: {
              type: {
                default: "new",
              },
              data: {},
              widgetAttr: {},
              defaultData: {},
              senecaInfo: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = computed(() => n.widgetAttr.skinInfo),
                {
                  defaultOrderData: r,
                  orderInfo: a,
                  updateOption: i,
                  updatePostPcs: l,
                } = useOrderComposable(n.type, {
                  group: n.widgetAttr.item_gbn,
                  emits: {
                    updateOrder: (O) => o("update", O),
                  },
                }),
                c = computed(() => !!a.value.pcsInfo?.find((O) => O.PCS_CD === "SCO_DFT")),
                u = ref({
                  ordCnt: 0,
                  prnCnt: 0,
                }),
                d = (O, A) => {
                  O === "default" &&
                    (u.value = {
                      ...u.value,
                      ordCnt: A,
                    }),
                    O === "inner" &&
                      (u.value = {
                        ...u.value,
                        prnCnt: A,
                      });
                };
              watch(
                () => u.value,
                debounce((O) => {
                  i("quantityInfo")(O);
                }, 200),
                {
                  immediate: !0,
                }
              );
              const h = inject("member"),
                f = computed(() =>
                  h?.bsn_yn === "Y"
                    ? n.data.pdt_mtrl_info
                    : n.data.pdt_mtrl_info.filter((O) => O.BSN_YN !== "Y")
                ),
                _ = computed(() =>
                  h?.bsn_yn === "Y"
                    ? n.data.inner_pdt_mtrl_info
                    : n.data.inner_pdt_mtrl_info?.filter((O) => O.BSN_YN !== "Y")
                ),
                p = computed(() => a.value?.pcsInfo?.find((O) => O.PCS_CD === "BIND_DIRECTION")),
                { uploadConfig: m } = useUploadConfig(n.widgetAttr),
                v = computed(() =>
                  a.value.dosuInfo?.BNC_GB === "BNC_BLA"
                    ? {
                        pdf: !0,
                        editor: null,
                      }
                    : m.value
                ),
                E = ref([]),
                k = (O) => (A) => {
                  const b = A[0];
                  O === "inner" && (E.value = [b, E.value[1]]),
                    O === "default" && (E.value = [E.value[0], b]);
                };
              watch(
                () => E.value,
                (O) => {
                  i("fileUploadInfo")(O);
                }
              );
              const N = computed(() =>
                  parsePostProcessOptions(n.data.pdt_pcs_info, n.data.pdt_disable_pcs_info)
                ),
                D = computed(() =>
                  bookPageMultiplierMap[n.data.pdt_base_info[0].PDT_CD]
                    ? a.value.quantityInfo?.prnCnt || 1
                    : (a.value.quantityInfo?.ordCnt || 1) * (a.value.quantityInfo?.prnCnt || 1)
                );
              return (O, A) => (
                openBlock(),
                createElementVNode(
                  Fragment,
                  null,
                  [
                    withDirectives(
                      renderComponent(
                        SizeSelect,
                        {
                          options: O.data.pdt_size_info,
                          "base-info": O.data.pdt_base_info[0],
                          default: unref(r)?.size,
                          "hidden-sizes": !0,
                          "show-extra": !0,
                          onUpdate: A[0] || (A[0] = (b) => unref(i)("sizeInfo")(b)),
                          onValidate: A[1] || (A[1] = (b) => unref(i)("validation")(b)),
                        },
                        null,
                        8,
                        ["options", "base-info", "default"]
                      ),
                      [[vShow, s.value.sizeSelect.view_yn === "Y"]]
                    ),
                    renderComponent(
                      BookQty,
                      {
                        type: "default",
                        options: O.data.pdt_prn_cnt_info,
                        onUpdate: d,
                      },
                      null,
                      8,
                      ["options"]
                    ),
                    createElement("div", zP, [
                      createElement("span", YP, toDisplayString(unref(t)("내지")), 1),
                    ]),
                    withDirectives(
                      renderComponent(
                        ah,
                        {
                          options: {
                            dosu: O.data.inner_pdt_dosu_info,
                            color: O.data.inner_pdt_bnc_info,
                            all: O.data.inner_pdt_dosu_bnc_info,
                          },
                          onUpdate: A[2] || (A[2] = (b) => unref(i)("inner_dosuInfo")(b)),
                        },
                        null,
                        8,
                        ["options"]
                      ),
                      [
                        [
                          vShow,
                          s.value.dosuSelect.view_yn === "Y" && O.data.inner_pdt_dosu_bnc_info,
                        ],
                      ]
                    ),
                    renderComponent(
                      Paper,
                      {
                        options: _.value,
                        "show-extra": O.widgetAttr.able_paper_yn === "Y",
                        onUpdate: A[3] || (A[3] = (b) => unref(i)("inner_meterialInfo")(b)),
                      },
                      null,
                      8,
                      ["options", "show-extra"]
                    ),
                    renderComponent(
                      BookQty,
                      {
                        type: "inner",
                        options: O.data.pdt_prn_cnt_info,
                        "related-data": {
                          dosu: unref(a).inner_dosuInfo?.COD,
                        },
                        onUpdate: d,
                      },
                      null,
                      8,
                      ["options", "related-data"]
                    ),
                    O.widgetAttr.order_yn !== "N"
                      ? (openBlock(),
                        createVNode(
                          FileUpload,
                          {
                            key: 0,
                            _key: "inner",
                            "upload-config": {
                              pdf: !0,
                              editor: null,
                            },
                            subject: "내지업로드",
                            notes: [
                              unref(t)("내지업로드사이즈장수안내", {
                                CUT_SIZE: `${unref(a).sizeInfo?.cutSize.width}x${
                                  unref(a).sizeInfo?.cutSize.height
                                }`,
                                WRK_SIZE: `${unref(a).sizeInfo?.workSize.width}x${
                                  unref(a).sizeInfo?.workSize.height
                                }`,
                                QTY: `${
                                  unref(a).quantityInfo?.prnCnt *
                                  (unref(a).inner_dosuInfo?.COD === "SID_D" ? 2 : 1)
                                }`,
                              }),
                            ],
                            onUpload: A[4] || (A[4] = (b) => k("inner")(b)),
                          },
                          null,
                          8,
                          ["notes"]
                        ))
                      : createCommentVNode("", !0),
                    createElement("div", KP, [
                      createElement("span", WP, toDisplayString(unref(t)("표지")), 1),
                    ]),
                    withDirectives(
                      renderComponent(
                        ah,
                        {
                          options: {
                            dosu: O.data.pdt_dosu_info,
                            color: O.data.pdt_bnc_info,
                            all: O.data.pdt_dosu_bnc_info,
                          },
                          onUpdate: A[5] || (A[5] = (b) => unref(i)("dosuInfo")(b)),
                        },
                        null,
                        8,
                        ["options"]
                      ),
                      [[vShow, s.value.dosuSelect.view_yn === "Y" && O.data.pdt_dosu_info]]
                    ),
                    withDirectives(
                      renderComponent(
                        Paper,
                        {
                          options: f.value,
                          "show-extra": O.widgetAttr.able_paper_yn === "Y",
                          onUpdate: A[6] || (A[6] = (b) => unref(i)("meterialInfo")(b)),
                        },
                        null,
                        8,
                        ["options", "show-extra"]
                      ),
                      [[vShow, f.value.length > 1]]
                    ),
                    renderComponent(
                      jP,
                      {
                        "size-info": unref(a).sizeInfo,
                        "seneca-info": O.senecaInfo,
                      },
                      null,
                      8,
                      ["size-info", "seneca-info"]
                    ),
                    renderComponent(
                      HiddenPostProcess,
                      {
                        options: N.value.postPcs.hidden,
                        "related-data": {
                          mtrlCd: unref(a).meterialInfo?.MTRL_CD,
                          sizeInfo: unref(a).sizeInfo,
                          orderQty: D.value,
                          bindDirection: p.value,
                        },
                        onUpdate: A[7] || (A[7] = (b) => unref(l)("hidden")(b)),
                      },
                      null,
                      8,
                      ["options", "related-data"]
                    ),
                    renderComponent(
                      VisiblePostProcess,
                      {
                        options: N.value.postPcs.visible,
                        "disabled-opts": N.value.disabled,
                        "attb-opts": O.data.pdt_add_info[1],
                        "related-data": {
                          mtrlCd: unref(a).meterialInfo?.MTRL_CD,
                          sizeInfo: unref(a).sizeInfo,
                        },
                        onUpdate: A[8] || (A[8] = (b) => unref(l)("visible")(b)),
                      },
                      null,
                      8,
                      ["options", "disabled-opts", "attb-opts", "related-data"]
                    ),
                    O.widgetAttr.order_yn !== "N"
                      ? (openBlock(),
                        createVNode(
                          FileUpload,
                          {
                            key: 1,
                            _key: "default",
                            "upload-config": v.value,
                            subject: "표지업로드",
                            notes: [
                              unref(t)("표지업로드장수안내", {
                                QTY: `${unref(a).dosuInfo?.COD === "SID_D" ? 2 : 1}`,
                              }),
                            ],
                            "related-data": {
                              hasScodix: c.value,
                            },
                            onUpload: A[9] || (A[9] = (b) => k("default")(b)),
                          },
                          null,
                          8,
                          ["upload-config", "notes", "related-data"]
                        ))
                      : createCommentVNode("", !0),
                  ],
                  64
                )
              );
            },
          }),
          [["__scopeId", "data-v-51f6d81b"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  QP = {
    key: 2,
    class: "summary",
  },
  XP = {
    class: "name",
  },
  JP = {
    class: "qty-price",
  },
  ZP = {
    class: "counter",
  },
  eE = ["onClick"],
  tE = ["value", "onChange"],
  nE = ["onClick"],
  oE = {
    class: "price-box",
  },
  sE = {
    class: "price",
  },
  rE = ["onClick"],
  iE = {
    key: 1,
  },
  aE = {
    class: "qty-price",
  },
  lE = {
    class: "price-box",
  },
  uE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "Acc",
            props: {
              type: {
                default: "new",
              },
              data: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = inject("productCode", {
                  pdtCode: "",
                }),
                r = inject("callbacks", {}),
                a = computed(() =>
                  accFilterConfigMap[s.pdtCode]
                    ? accFilterConfigMap[s.pdtCode][s.pttCode || ""]
                    : null
                ),
                i = ref("X"),
                l = ref("X"),
                c = ref("X"),
                u = reactive({}),
                d = reactive({});
              watch(
                () => i.value,
                () => {
                  c.value = "X";
                }
              );
              const h = {
                  key: "X",
                  value: "X",
                  name: t("선택하기"),
                },
                f = () => {
                  (i.value = "X"), (l.value = "X"), (c.value = "X");
                },
                _ = computed(() =>
                  n.data.reduce(
                    (y, I) => (
                      y[I.MTRL_GRP_GB] || (y[I.MTRL_GRP_GB] = []), y[I.MTRL_GRP_GB].push(I), y
                    ),
                    {}
                  )
                ),
                p = (y) => {
                  const I = [h];
                  return y
                    ? y.GRP_TYPE === "MTRL_MULTI_GRP"
                      ? (_.value[y.GRP_COD].forEach((w) => {
                          I.push({
                            key: w.MTRL_CD,
                            value: w.MTRL_CD,
                            name: w.MTRL_NM,
                            disabled: w.HIDE_YN === "Y",
                          });
                        }),
                        I)
                      : y.options
                      ? (y.options.forEach((w) => {
                          I.push({
                            key: w.COD,
                            value: w.COD,
                            name: t(w.COD_NME),
                          });
                        }),
                        I)
                      : (i.value !== "X" &&
                          _.value[i.value].forEach((w) => {
                            I.push({
                              key: w.MTRL_CD,
                              value: w.MTRL_CD,
                              name: w.MTRL_NM,
                              disabled: w.HIDE_YN === "Y",
                            });
                          }),
                        I)
                    : (n.data.forEach((w) => {
                        I.push({
                          key: w.MTRL_CD,
                          value: w.MTRL_CD,
                          name: w.MTRL_NM,
                          disabled: w.HIDE_YN === "Y",
                        });
                      }),
                      I);
                };
              function m(y) {
                return r?.onCallMsg ? r.onCallMsg("warn", y) : alert(y);
              }
              function v(y) {
                y &&
                  (d[y.MTRL_CD]
                    ? (d[y.MTRL_CD].QTY += y.INC_STEP)
                    : (d[y.MTRL_CD] = {
                        ...y,
                        QTY: y.FIR_CNT,
                      }));
              }
              function E(y) {
                d[y.MTRL_CD].QTY !== y.FIR_CNT && (d[y.MTRL_CD].QTY -= y.INC_STEP);
              }
              function k(y, I) {
                let U = +y.target.value || I.FIR_CNT;
                if (
                  (U < I.FIR_CNT && (U = I.FIR_CNT),
                  I.RMD_QTY > 0 && U > I.RMD_QTY && (U = I.RMD_QTY),
                  I.INC_STEP !== 1)
                ) {
                  const Z = U % I.INC_STEP;
                  Z !== 0 && (U = U - Z);
                }
                d[I.MTRL_CD] = {
                  ...d[I.MTRL_CD],
                  QTY: U,
                };
              }
              function N() {
                if (!a.value) {
                  if (c.value === "X") return m(t("옵션미선택안내"));
                  const y = n.data.find((I) => I.MTRL_CD === c.value);
                  return v(y), (c.value = "X");
                }
                if (a.value.uiType === "MULTI")
                  return isEmpty(u) || Object.values(u).every((y) => y === "X")
                    ? m(t("옵션미선택안내"))
                    : (Object.entries(u).forEach(([y, I]) => {
                        const w = _.value[y].find((U) => U.MTRL_CD === I);
                        v(w);
                      }),
                      Object.keys(u).forEach((y) => delete u[y]));
                if (a.value.uiType === "CASCADE") {
                  const y = a.value.filters[0],
                    I = a.value.filters.find((U) => U.GRP_TYPE === "MTRL_SUB_GRP");
                  if (i.value === "X")
                    return m(
                      t("옵션미선택안내상세", {
                        OPTION: t(y.GRP_NME),
                      })
                    );
                  if (!I) return;
                  if (I.options) {
                    if (l.value === "X")
                      return m(
                        t("옵션미선택안내상세", {
                          OPTION: t(I.GRP_NME),
                        })
                      );
                    const U = _.value[i.value].find((Z) => {
                      if (Z.MTRL_NM.includes(t(l.value))) return !0;
                      if (l.value === "NONE") return !0;
                    });
                    return v(U), f();
                  }
                  if (c.value === "X")
                    return m(
                      t("옵션미선택안내상세", {
                        OPTION: t(I.GRP_NME),
                      })
                    );
                  const w = _.value[i.value].find((U) => U.MTRL_CD === c.value);
                  return v(w), f();
                }
              }
              function D(y) {
                delete d[y.MTRL_CD];
              }
              watch(
                () => d,
                (y) => {
                  const I = Object.values(y).map((w) => ({
                    MTRL_CD: w.MTRL_CD,
                    QTY: w.QTY,
                    ATTB: "",
                    MTRL_NME: w.MTRL_NM,
                  }));
                  o("update", I);
                },
                {
                  deep: !0,
                }
              );
              const O = useOrderStore(),
                A = computed(() =>
                  O.getOrderData()?.priceCalc.result.result?.reduce(
                    (I, w) => (
                      (I[w.MTRL_CD] = +w.PRICE_MALL !== w.PRICE ? +w.PRICE_MALL : w.PRICE), I
                    ),
                    {}
                  )
                ),
                b = reactive(A.value || {});
              function C(y, I, w) {
                const Z = performance.now(),
                  me = (_e) => {
                    const B = Math.min((_e - Z) / 300, 1),
                      W = Math.floor(I + (w - I) * B);
                    (b[y] = W), B < 1 && requestAnimationFrame(me);
                  };
                requestAnimationFrame(me);
              }
              return (
                watch(
                  () => A.value,
                  (y, I = {}) => {
                    y &&
                      Object.keys(y).forEach((w) => {
                        const U = I[w] || 0,
                          Z = y[w] || 0;
                        C(w, U, Z);
                      });
                  },
                  {
                    deep: !0,
                  }
                ),
                (y, I) => (
                  openBlock(),
                  createElementVNode(
                    Fragment,
                    null,
                    [
                      a.value
                        ? (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            {
                              key: 0,
                            },
                            renderList(
                              a.value.filters,
                              (w) => (
                                openBlock(),
                                createVNode(
                                  OptionRow,
                                  {
                                    key: w.GRP_NME,
                                    title: `${unref(t)("옵션")} - ${unref(t)(w.GRP_NME)}`,
                                  },
                                  {
                                    default: withCtx(() => [
                                      w.GRP_TYPE === "MTRL_MULTI_GRP"
                                        ? (openBlock(),
                                          createVNode(
                                            BasicSelect,
                                            {
                                              key: 0,
                                              name: w.GRP_COD,
                                              default: u[w.GRP_COD] || "X",
                                              options: p(w),
                                              onSelect: (U) => (u[w.GRP_COD] = U),
                                            },
                                            null,
                                            8,
                                            ["name", "default", "options", "onSelect"]
                                          ))
                                        : w.GRP_TYPE === "MTRL_GRP"
                                        ? (openBlock(),
                                          createVNode(
                                            BasicSelect,
                                            {
                                              key: 1,
                                              name: "material-group",
                                              options: p(w),
                                              default: i.value,
                                              onSelect: I[0] || (I[0] = (U) => (i.value = U)),
                                            },
                                            null,
                                            8,
                                            ["options", "default"]
                                          ))
                                        : w.GRP_TYPE === "MTRL_SUB_GRP" && w.options
                                        ? (openBlock(),
                                          createVNode(
                                            BasicSelect,
                                            {
                                              key: 2,
                                              name: "material-sub-group",
                                              options: p(w),
                                              default: l.value,
                                              onSelect: I[1] || (I[1] = (U) => (l.value = U)),
                                            },
                                            null,
                                            8,
                                            ["options", "default"]
                                          ))
                                        : (openBlock(),
                                          createVNode(
                                            BasicSelect,
                                            {
                                              key: 3,
                                              name: "material",
                                              options: p(w),
                                              default: c.value,
                                              onSelect: I[2] || (I[2] = (U) => (c.value = U)),
                                            },
                                            null,
                                            8,
                                            ["options", "default"]
                                          )),
                                    ]),
                                    _: 2,
                                  },
                                  1032,
                                  ["title"]
                                )
                              )
                            ),
                            128
                          ))
                        : (openBlock(),
                          createVNode(
                            OptionRow,
                            {
                              key: 1,
                              title: unref(t)("옵션"),
                            },
                            {
                              default: withCtx(() => [
                                renderComponent(
                                  BasicSelect,
                                  {
                                    name: "material",
                                    options: p(),
                                    default: c.value,
                                    onSelect: I[3] || (I[3] = (w) => (c.value = w)),
                                  },
                                  null,
                                  8,
                                  ["options", "default"]
                                ),
                              ]),
                              _: 1,
                            },
                            8,
                            ["title"]
                          )),
                      createElement(
                        "button",
                        {
                          type: "button",
                          class: "add-btn",
                          onClick: N,
                        },
                        "+ " + toDisplayString(unref(t)("옵션선택")),
                        1
                      ),
                      unref(isEmpty)(d)
                        ? createCommentVNode("", !0)
                        : (openBlock(),
                          createElementVNode("div", QP, [
                            (openBlock(!0),
                            createElementVNode(
                              Fragment,
                              null,
                              renderList(
                                Object.values(d),
                                (w) => (
                                  openBlock(),
                                  createElementVNode(
                                    "div",
                                    {
                                      key: w.MTRL_CD,
                                    },
                                    [
                                      A.value && A.value[w.MTRL_CD]
                                        ? (openBlock(),
                                          createElementVNode(
                                            Fragment,
                                            {
                                              key: 0,
                                            },
                                            [
                                              createElement("p", XP, toDisplayString(w.MTRL_NM), 1),
                                              createElement("div", JP, [
                                                createElement("div", ZP, [
                                                  createElement(
                                                    "button",
                                                    {
                                                      type: "button",
                                                      class: "btn minus",
                                                      onClick: (U) => E(w),
                                                    },
                                                    "-",
                                                    8,
                                                    eE
                                                  ),
                                                  createElement(
                                                    "input",
                                                    {
                                                      class: "qty",
                                                      value: w.QTY,
                                                      name: "qty",
                                                      onChange: (U) => k(U, w),
                                                      type: "number",
                                                    },
                                                    null,
                                                    40,
                                                    tE
                                                  ),
                                                  createElement(
                                                    "button",
                                                    {
                                                      type: "button",
                                                      class: "btn plus",
                                                      onClick: (U) => v(w),
                                                    },
                                                    "+",
                                                    8,
                                                    nE
                                                  ),
                                                ]),
                                                createElement("div", oE, [
                                                  createElement(
                                                    "span",
                                                    sE,
                                                    toDisplayString(b[w.MTRL_CD]?.toLocaleString()),
                                                    1
                                                  ),
                                                  createElement(
                                                    "button",
                                                    {
                                                      type: "button",
                                                      class: "delete-btn",
                                                      onClick: (U) => D(w),
                                                    },
                                                    "X",
                                                    8,
                                                    rE
                                                  ),
                                                ]),
                                              ]),
                                            ],
                                            64
                                          ))
                                        : (openBlock(),
                                          createElementVNode("div", iE, [
                                            renderComponent(Skeleton, {
                                              variant: "rounded",
                                              width: 110,
                                              height: 16,
                                            }),
                                            createElement("div", aE, [
                                              renderComponent(Skeleton, {
                                                variant: "rounded",
                                                width: 106,
                                                height: 28,
                                              }),
                                              createElement("div", lE, [
                                                renderComponent(Skeleton, {
                                                  variant: "rounded",
                                                  width: 50,
                                                  height: 17,
                                                }),
                                                renderComponent(Skeleton, {
                                                  variant: "circular",
                                                  width: 16,
                                                  height: 16,
                                                }),
                                              ]),
                                            ]),
                                          ])),
                                    ]
                                  )
                                )
                              ),
                              128
                            )),
                          ])),
                    ],
                    64
                  )
                )
              );
            },
          }),
          [["__scopeId", "data-v-99ad5859"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  cE = {
    class: "flex-row",
  },
  dE = {
    class: "notes",
  },
  fE = {
    class: "note",
  },
  pE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "ADC_PVC",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = (a) => {
                s.value = a.value;
              };
            return (
              watch(
                () => s.value,
                (a) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: a,
                      PCS_DTL_NM: n.data.name,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (a, i) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: a.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", cE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            a.data.options,
                            (l) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: l.key,
                                  data: {
                                    value: l.value,
                                    name: l.name,
                                    imgPath: `${a.data.subImgPath}_${l.value}`,
                                  },
                                  active: s.value === l.value,
                                  onSelect: r,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                      createElement("div", dE, [
                        createElement(
                          "p",
                          fE,
                          toDisplayString(a.data.options[0]?.extra?.NOTICE[0]),
                          1
                        ),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  _E = {
    class: "flex-row -flow",
  },
  hE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "BID_SIL",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.attbOptions[0].value),
              r = ref(n.data.attbOptions[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: n.data.options[0].value,
                      PCS_DTL_NM: `${n.data.name}(${r.value})`,
                      ATTB: i,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", _E, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.attbOptions,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: c.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  mE = {
    class: "flex-row",
  },
  vE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "BIND_DIRECTION",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("productCode", {
                pdtCode: "",
              }),
              r = [
                {
                  name: "A",
                  value: "Y",
                  key: "A",
                  imgPath: "BIND_DIRECTION_BPTOP_A",
                },
                {
                  name: "B",
                  value: "N",
                  key: "B",
                  imgPath: "BIND_DIRECTION_BPTOP_B",
                },
              ],
              a = computed(() => n.relatedData.sizeInfo.workSize),
              i = computed(() =>
                horizontalBindSet.has(s.pdtCode)
                  ? "BPLFT"
                  : a.value.width > a.value.height
                  ? "BPTOP"
                  : "BPLFT"
              ),
              l = ref(r[0].value),
              c = computed(() => ({
                main: i.value,
                sub: l.value,
              }));
            return (
              watch(
                () => c.value,
                (u) => {
                  const d = n.data.options.find((h) => h.value === u.main)?.extra;
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: u.main,
                      PCS_DTL_NM: d?.PCS_DTL_NM,
                      ...(i.value === "BPTOP"
                        ? {
                            BACK_ROT_YN: u.sub,
                          }
                        : {}),
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (u, d) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: u.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", mE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            u.data.options,
                            (h) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: h.key,
                                  data: {
                                    value: h.value,
                                    name: h.name,
                                    imgPath: `${u.data.subImgPath}_${h.value}`,
                                  },
                                  "force-hidden": i.value !== h.value,
                                  active: i.value === h.value,
                                },
                                null,
                                8,
                                ["data", "force-hidden", "active"]
                              )
                            )
                          ),
                          128
                        )),
                        (openBlock(),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(r, (h) =>
                            renderComponent(
                              IconCheckbox,
                              {
                                key: h.key,
                                data: {
                                  value: h.value,
                                  name: h.name,
                                  imgPath: h.imgPath,
                                },
                                "force-hidden": i.value === "BPLFT",
                                active: l.value === h.value,
                                onSelect: d[0] || (d[0] = (f) => (l.value = f.value)),
                              },
                              null,
                              8,
                              ["data", "force-hidden", "active"]
                            )
                          ),
                          64
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  gE = {
    class: "flex-row",
  },
  yE = {
    class: "notes",
  },
  CE = {
    class: "note",
  },
  TE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "BON_PAP",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(n.data.options[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: r.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", gE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: i.data.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                      createElement("div", yE, [
                        createElement(
                          "p",
                          CE,
                          toDisplayString(i.data.options[0]?.extra?.NOTICE[0]),
                          1
                        ),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  bE = {
    class: "flex-row",
  },
  SE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "BON_SHT",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(n.data.options[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: `${n.data.name}(${r.value})`,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", bE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: `${i.data.subImgPath}_${c.value}`,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  DE = ["value"],
  PE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "CLD_STD",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0]?.value);
            return (
              watch(
                () => s.value,
                (r) => {
                  const a = n.data.options.find((i) => i.value === r);
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: r,
                      PCS_DTL_NM: a?.name,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (r, a) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: r.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      withDirectives(
                        createElement(
                          "select",
                          {
                            "onUpdate:modelValue": a[0] || (a[0] = (i) => (s.value = i)),
                            name: "CLD_STD",
                            class: "basic-select",
                          },
                          [
                            (openBlock(!0),
                            createElementVNode(
                              Fragment,
                              null,
                              renderList(
                                r.data.options,
                                (i) => (
                                  openBlock(),
                                  createElementVNode(
                                    "option",
                                    {
                                      key: i.key,
                                      value: i.value,
                                    },
                                    toDisplayString(unref(t)(i.name)),
                                    9,
                                    DE
                                  )
                                )
                              ),
                              128
                            )),
                          ],
                          512
                        ),
                        [[vModelSelect, s.value]]
                      ),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  EE = {
    class: "grid-group",
  },
  OE = {
    class: "flex-row -flow",
  },
  IE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "COT_DFT",
          props: {
            data: {},
            disabledOptions: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("productCode", {
                pdtCode: "",
              }),
              r = useI18n(),
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
                TCST: "홀로그램 별빛",
              };
            function i(_) {
              const p = _.slice(-1),
                m = _.slice(0, 4);
              return {
                side: p,
                coating: m,
              };
            }
            const l = computed(() => {
                const _ = {},
                  p = {};
                for (const m of n.data.options) {
                  const { side: v, coating: E } = i(m.value),
                    k = a[v],
                    N = r.locale === "ko" ? a[E] : m.name;
                  _[v] ||
                    (_[v] = {
                      id: `COT_DFT/${v}`,
                      name: `COT_DFT/${v}`,
                      label: k,
                      value: v,
                    }),
                    p[E] ||
                      (p[E] = {
                        ...m,
                        value: E,
                        name: N,
                        disabled: n.disabledOptions?.includes(m.value),
                      });
                }
                return {
                  sides: _,
                  coatings: p,
                };
              }),
              c = ref(n.data.options[0].value.slice(-1)),
              u = ref(n.data.options[0].value.slice(0, 4)),
              d = computed(() => u.value + c.value),
              h = {
                TCMA: "COT_DFT_MA_BOOK",
                TCGL: "COT_DFT_GL_BOOK",
                TCEB: "COT_DFT_EB_BOOK",
                TCSL: "COT_DFT_SL_BOOK",
              },
              f = computed(() => (s.pdtCode.startsWith("PRBK") ? h : null));
            return (
              watch(
                () => d.value,
                (_) => {
                  const p = n.data.options.find((m) => m.value === _)?.extra;
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: _,
                      PCS_DTL_NM: p?.PCS_DTL_NM,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              watch(
                () => n.disabledOptions,
                (_) => {
                  if (!_ || !_.some((m) => m.startsWith(u.value))) return;
                  const p = Object.values(l.value.coatings).find((m) => !m.disabled);
                  p && (u.value = p.value);
                }
              ),
              (_, p) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: _.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", EE, [
                        renderComponent(
                          RadioGroup,
                          {
                            options: Object.values(l.value.sides),
                            "default-checked": c.value,
                            onChange: p[0] || (p[0] = (m) => (c.value = m.value)),
                          },
                          null,
                          8,
                          ["options", "default-checked"]
                        ),
                        createElement("div", OE, [
                          (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            null,
                            renderList(
                              Object.values(l.value.coatings),
                              (m) => (
                                openBlock(),
                                createVNode(
                                  IconCheckbox,
                                  {
                                    key: m.key,
                                    data: {
                                      value: m.value,
                                      name: m.name,
                                      imgPath:
                                        f.value && f.value[m.value]
                                          ? f.value[m.value]
                                          : `COT_DFT_${m.value.slice(2, 4)}`,
                                      subImgPath: _.data.subImgPath,
                                    },
                                    disabled: m.disabled,
                                    "disabled-styling": m.disabled,
                                    active: u.value === m.value,
                                    onSelect: p[1] || (p[1] = (v) => (u.value = v.value)),
                                  },
                                  null,
                                  8,
                                  ["data", "disabled", "disabled-styling", "active"]
                                )
                              )
                            ),
                            128
                          )),
                        ]),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  RE = {
    class: "flex-row",
  },
  wE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "COT_SEG",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(`${n.data.name}(${n.data.options[0].name})`),
              a = (i) => {
                (s.value = i.value), (r.value = `${n.data.name}(${i.name})`);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: r.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", RE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: `${i.data.subImgPath}_${c.value}`,
                                    subImgPath: i.data.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  AE = ["value"],
  NE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "CVR_INN",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value);
            return (
              watch(
                () => s.value,
                (r) => {
                  const a = n.data.options.find((i) => i.value === r);
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: r,
                      PCS_DTL_NM: `${n.data.name}(${a?.name})`,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (r, a) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: r.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      withDirectives(
                        createElement(
                          "select",
                          {
                            "onUpdate:modelValue": a[0] || (a[0] = (i) => (s.value = i)),
                            name: "CVR_INN",
                            class: "basic-select",
                          },
                          [
                            (openBlock(!0),
                            createElementVNode(
                              Fragment,
                              null,
                              renderList(
                                r.data.options,
                                (i) => (
                                  openBlock(),
                                  createElementVNode(
                                    "option",
                                    {
                                      key: i.key,
                                      value: i.value,
                                    },
                                    toDisplayString(unref(t)(i.name)),
                                    9,
                                    AE
                                  )
                                )
                              ),
                              128
                            )),
                          ],
                          512
                        ),
                        [[vModelSelect, s.value]]
                      ),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  ME = {
    class: "flex-row",
  },
  kE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "CVR_SWN",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(n.data.options[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: r.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", ME, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: `${i.data.subImgPath}_${c.value}`,
                                    subImgPath: i.data.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  LE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "DIR_MTR",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = computed(() =>
                n.data.options.map((i) => ({
                  id: i.value,
                  name: n.data.value,
                  label: i.name,
                  value: i.value,
                }))
              ),
              r = ref(s.value[0]),
              a = computed(() => ({
                PCS_CD: n.data.value,
                PCS_DTL_CD: r.value.value,
                PCS_DTL_NM: r.value.label,
                ATTB: n.relatedData.orderQty,
              }));
            return (
              watch(
                () => a.value,
                (i, l) => {
                  (l?.ATTB === i.ATTB && l?.PCS_DTL_CD === i.PCS_DTL_CD) || o("update", [i]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      renderComponent(
                        RadioGroup,
                        {
                          options: s.value,
                          "default-checked": s.value[0].value,
                          onChange: l[0] || (l[0] = (c) => (r.value = c)),
                        },
                        null,
                        8,
                        ["options", "default-checked"]
                      ),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  $E = {
    class: "notes",
  },
  xE = {
    class: "note",
  },
  FE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "END_PAP",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
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
                CLGRY: "#ededee",
              },
              r = computed(() =>
                n.data.options.map((i) => ({
                  COD: i.value,
                  COD_NME: i.name,
                  HEX: s[i.value],
                }))
              ),
              a = ref(r.value[0]);
            return (
              watch(
                () => a.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i.COD,
                      PCS_DTL_NM: `${n.data.name}(${i.COD_NME})`,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      renderComponent(
                        ColorChipSelector,
                        {
                          options: r.value,
                          onSelect: l[0] || (l[0] = (c) => (a.value = c)),
                        },
                        null,
                        8,
                        ["options"]
                      ),
                      createElement("div", $E, [
                        createElement(
                          "p",
                          xE,
                          toDisplayString(i.data.options[0]?.extra?.NOTICE[0]),
                          1
                        ),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  UE = {
    class: "flex-row",
  },
  BE = ["value", "disabled"],
  VE = ["value"],
  HE = {
    key: 0,
    class: "notes",
  },
  GE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "INN_DFT",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("productCode", {
                pdtCode: "",
              }),
              r = computed(() => n.data.options[0].extra.QTY_INPUT_YN === "Y"),
              a = computed(() =>
                s.pdtCode === "GSNTMIS" && c.value
                  ? n.data.options.map((f) => ({
                      ...f,
                      disabled: f.value !== "INNON",
                    }))
                  : n.data.options
              ),
              i = ref(n.data.options[0].value),
              l = computed(() => a.value.find((f) => f.value === i.value)),
              c = computed(
                () =>
                  n.relatedData.sizeInfo?.DIV_SEQ === 0 ||
                  n.relatedData.sizeInfo?.DIV_NM === "사이즈직접입력"
              ),
              u = ref(1),
              d = () => {
                if (u.value < 1) return (u.value = 1);
              };
            watch(
              () => c.value,
              (f) => {
                f && (i.value = "INNON");
              }
            );
            const h = computed(() => [
              {
                PCS_CD: n.data.value,
                PCS_DTL_CD: i.value,
                PCS_DTL_NM: `${n.data.name}(${l.value?.name})`,
                ATTB: r.value ? u.value : n.relatedData.orderQty,
                ATTB_2: "",
                ATTB_3: "",
              },
            ]);
            return (
              watch(
                () => h.value,
                (f) => {
                  o("update", f);
                },
                {
                  immediate: !0,
                }
              ),
              (f, _) => {
                const p = resolveDirective("dompurify-html");
                return (
                  openBlock(),
                  createVNode(
                    OptionRow,
                    {
                      title: f.data.name,
                      underline: "",
                    },
                    {
                      default: withCtx(() => [
                        createElement("div", UE, [
                          withDirectives(
                            createElement(
                              "select",
                              {
                                "onUpdate:modelValue": _[0] || (_[0] = (m) => (i.value = m)),
                                name: "INN_DFT",
                                class: "basic-select",
                              },
                              [
                                (openBlock(!0),
                                createElementVNode(
                                  Fragment,
                                  null,
                                  renderList(
                                    a.value,
                                    (m) => (
                                      openBlock(),
                                      createElementVNode(
                                        "option",
                                        {
                                          key: m.key,
                                          value: m.value,
                                          disabled: m.disabled,
                                        },
                                        toDisplayString(unref(t)(m.name)),
                                        9,
                                        BE
                                      )
                                    )
                                  ),
                                  128
                                )),
                              ],
                              512
                            ),
                            [[vModelSelect, i.value]]
                          ),
                          r.value
                            ? withDirectives(
                                (openBlock(),
                                createElementVNode(
                                  "input",
                                  {
                                    key: 0,
                                    "onUpdate:modelValue": _[1] || (_[1] = (m) => (u.value = m)),
                                    type: "number",
                                    id: "qty",
                                    class: "basic-input",
                                    onFocusout: d,
                                  },
                                  null,
                                  544
                                )),
                                [[vModelText, u.value]]
                              )
                            : (openBlock(),
                              createElementVNode(
                                "input",
                                {
                                  key: 1,
                                  type: "number",
                                  id: "qty",
                                  disabled: !0,
                                  value: f.relatedData.orderQty,
                                  class: "basic-input",
                                },
                                null,
                                8,
                                VE
                              )),
                        ]),
                        l.value
                          ? (openBlock(),
                            createElementVNode("div", HE, [
                              (openBlock(!0),
                              createElementVNode(
                                Fragment,
                                null,
                                renderList(l.value.extra.NOTICE, (m, v) =>
                                  withDirectives(
                                    (openBlock(),
                                    createElementVNode("p", {
                                      key: `notice-${v}`,
                                      class: "note",
                                    })),
                                    [[p, m]]
                                  )
                                ),
                                128
                              )),
                            ]))
                          : createCommentVNode("", !0),
                      ]),
                      _: 1,
                    },
                    8,
                    ["title"]
                  )
                );
              }
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  jE = {
    class: "flex-row",
  },
  zE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "INS_COT",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(n.data.options[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: r.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", jE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: `${i.data.subImgPath}_${c.value}`,
                                    subImgPath: i.data.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  YE = {
    class: "flex-row",
  },
  KE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "LAB_FBR",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = ref(n.data.options[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: i,
                      PCS_DTL_NM: r.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", YE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.options,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: `${i.data.subImgPath}_${c.value}`,
                                    subImgPath: i.data.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  WE = {
    class: "flex-row",
  },
  qE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "PAK_ETC",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("productCode", {
                pdtCode: "",
              }),
              r = inject("callbacks", {}),
              a = inject("deviceType", "pc"),
              i = ref(
                n.data.options.find((p) => p.value === "DFXXX" || p.value === "PK000")?.value ||
                  n.data.options[0].value
              ),
              l = (p) => {
                i.value = p.value;
              },
              c = {
                GSBKBCH: {
                  PK017: "PAK_ETC_PK017",
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
                  PK028: "PAK_ETC_PK019",
                },
              },
              u = computed(() => c[s.pdtCode]),
              d = {
                PK017: {
                  src: `${CDN_BASE_URL}/ko/item/order_beachTowel_opt_hover_1.png`,
                  alt: "Beach Towel PVC bag image",
                },
              },
              h = computed(() =>
                n.data.options.map((p, m) => {
                  const v = d[p.value];
                  return v
                    ? {
                        IDX: m + 1,
                        CATEGORY: `${t("후가공")} > ${p.name}`,
                        LABEL: p.name,
                        IMG_URL: v.src,
                        IMG_ALT: v.alt,
                      }
                    : null;
                })
              );
            watch(
              () => i.value,
              (p) => {
                const m = n.data.options.find((v) => v.value === p)?.name || n.data.name;
                o("update", [
                  {
                    PCS_CD: n.data.value,
                    PCS_DTL_CD: p,
                    PCS_DTL_NM: m,
                  },
                ]);
              },
              {
                immediate: !0,
              }
            );
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
                EC010: "PK028",
              },
              _ = reactive(n.data.options);
            return (
              watch(
                () => n.relatedData?.postpcs?.CLD_STD,
                (p) => {
                  if (!p) return;
                  const m = p[0].selectedOptions[0].PCS_DTL_CD;
                  if (!m) return;
                  const v = f[m];
                  for (const E of _)
                    E.value === "PK018" || E.value === v
                      ? (E.forceHidden = !1)
                      : (E.forceHidden = !0),
                      E.forceHidden && E.value === i.value && (i.value = v);
                },
                {
                  immediate: !0,
                  deep: !0,
                }
              ),
              (p, m) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: p.data.name || "폴리백 개별포장",
                    underline: "",
                    extra:
                      unref(a) === "mobile" && h.value
                        ? {
                            name: "자세히보기",
                            callback: () => {
                              unref(r).onInformOptionTips && unref(r).onInformOptionTips(h.value);
                            },
                            style: "tip",
                          }
                        : null,
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", WE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            _,
                            (v, E) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: v.key,
                                  data: {
                                    value: v.value,
                                    name: v.name,
                                    imgPath:
                                      u.value && u.value[v.value]
                                        ? u.value[v.value]
                                        : p.data.imgPath,
                                    subImgPath: p.data.subImgPath,
                                  },
                                  "force-hidden": v.forceHidden,
                                  active: i.value === v.value,
                                  tip: h.value[E],
                                  onSelect: l,
                                },
                                null,
                                8,
                                ["data", "force-hidden", "active", "tip"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title", "extra"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  QE = {
    class: "flex-row",
  },
  XE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "PAK_POL",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.options[0].value),
              r = (a) => {
                s.value = a.value;
              };
            return (
              watch(
                () => s.value,
                (a) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: a,
                      PCS_DTL_NM: n.data.name,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (a, i) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: a.data.name || "폴리백 개별포장",
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", QE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            a.data.options,
                            (l) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: l.key,
                                  data: {
                                    value: l.value,
                                    name: l.name,
                                    imgPath: a.data.imgPath,
                                    subImgPath: a.data.subImgPath,
                                  },
                                  active: s.value === l.value,
                                  onSelect: r,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  JE = {
    class: "flex-row",
  },
  ZE = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "PDT_WRK",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("deviceType", "pc"),
              r = inject("callbacks", {}),
              a = ref(n.data.options[0].value),
              i = (d) => {
                a.value = d.value;
              },
              l = computed(() => ({
                PCS_CD: n.data.value,
                PCS_DTL_CD: a.value,
                PCS_DTL_NM: n.data.name,
                ATTB: n.relatedData.orderQty,
              })),
              c = {
                PP002: {
                  src: `${CDN_BASE_URL}/ko/STDRCAD_back_print_over_img.png`,
                  alt: "Back paper image",
                },
              },
              u = computed(() =>
                n.data.options.map((d, h) => {
                  const f = c[d.value];
                  return f
                    ? {
                        IDX: h + 1,
                        CATEGORY: `${t("후가공")} > ${d.name}`,
                        LABEL: d.name,
                        IMG_URL: f.src,
                        IMG_ALT: f.alt,
                      }
                    : null;
                })
              );
            return (
              watch(
                () => l.value,
                (d) => {
                  o("update", [d]);
                },
                {
                  immediate: !0,
                }
              ),
              (d, h) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: d.data.name,
                    underline: "",
                    extra:
                      unref(s) === "mobile" && u.value
                        ? {
                            name: "자세히보기",
                            callback: () => {
                              unref(r).onInformOptionTips && unref(r).onInformOptionTips(u.value);
                            },
                            style: "tip",
                          }
                        : null,
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", JE, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            d.data.options,
                            (f, _) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: f.key,
                                  data: {
                                    value: f.value,
                                    name: f.name,
                                    imgPath: `${d.data.value}_${f.value}`,
                                  },
                                  active: a.value === f.value,
                                  tip: u.value[_],
                                  onSelect: i,
                                },
                                null,
                                8,
                                ["data", "active", "tip"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title", "extra"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  eO = {
    class: "option packing",
  },
  tO = {
    class: "title",
  },
  nO = {
    class: "flex-row",
  },
  oO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "PRT_IPK",
          setup(e) {
            return (t, n) => (
              openBlock(),
              createElementVNode("div", eO, [
                createElement("div", tO, [
                  createElement("h2", null, toDisplayString(unref(t)("개별포장")), 1),
                ]),
                createElement("div", nO, [
                  renderComponent(IconCheckbox, {
                    data: {
                      value: "PRT_IPK",
                      name: "개별포장",
                      imgPath: "PRT_IPK",
                    },
                    active: !0,
                  }),
                ]),
              ])
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  sO = {
    class: "flex-row",
  },
  lh = defineComponent({
    __name: "PRT_WHT_FACE",
    props: {
      mode: {},
      options: {},
    },
    emits: ["update"],
    setup(e, { emit: t }) {
      const n = e,
        o = t,
        s = useEditorStore(),
        r = computed(() =>
          n.options.map((u) => ({
            value: u.value,
            name: u.name,
            imgPath: u.extra?.PCS_CD || "",
            extra: u.extra,
          }))
        ),
        a = reactive({
          DFXXF: !0,
          DFXXB: !0,
        });
      function i(u) {
        a[u.value] = !a[u.value];
      }
      const l = computed(() => {
        const u = [];
        return (
          n.options.forEach((d) => {
            (d.extra?.ESN_YN === "Y" || a[d.value]) &&
              u.push({
                PCS_CD: d.extra?.PCS_CD || "PRT_WHT",
                PCS_GRP_NM: d.extra.PCS_GRP_NM,
                VIEW_YN: "Y",
                ESN_YN: d.extra?.ESN_YN || "N",
                selectedOptions: [
                  {
                    PCS_CD: d.extra?.PCS_CD,
                    PCS_DTL_CD: d.extra?.PCS_DTL_CD,
                    PCS_DTL_NM: d.extra?.PCS_DTL_NM,
                    ATTB: "Y",
                    ATTB_2: n.mode,
                  },
                ],
              });
          }),
          u
        );
      });
      watch(
        () => l.value,
        (u) => {
          u && o("update", u);
        },
        {
          immediate: !0,
        }
      ),
        watch(
          () => s.editorData?.default?.PRT_WHT,
          (u) => {
            u && ((a.DFXXF = u?.front ?? !1), (a.DFXXB = u?.back ?? !1));
          },
          {
            immediate: !0,
          }
        );
      const { resetEditByWhite: c } = useWhiteReset();
      return (
        onBeforeUnmount(() => {
          s.isAfterEdit() && c();
        }),
        watch(
          () => s.uploadType.default,
          (u) => {
            u === "editor" && ((a.DFXXF = !0), (a.DFXXB = !0));
          }
        ),
        (u, d) => (
          openBlock(),
          createElementVNode("div", sO, [
            (openBlock(!0),
            createElementVNode(
              Fragment,
              null,
              renderList(
                r.value,
                (h) => (
                  openBlock(),
                  createVNode(
                    IconCheckbox,
                    {
                      key: h.value,
                      data: h,
                      active: a[h.value],
                      disabled: h.extra?.ESN_YN === "Y" || unref(s).uploadType.default === "editor",
                      onSelect: i,
                    },
                    null,
                    8,
                    ["data", "active", "disabled"]
                  )
                )
              ),
              128
            )),
          ])
        )
      );
    },
  }),
  rO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: lh,
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  iO = {
    class: "grid-group",
  },
  aO = {
    class: "basic-radio",
  },
  lO = {
    for: "auto-white",
  },
  uO = {
    class: "text",
  },
  cO = {
    key: 0,
    for: "self-white",
  },
  dO = {
    class: "text disabled",
  },
  fO = {
    key: 1,
    class: "note red",
  },
  pO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "PRT_WHT",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update", "update:replace"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = useEditorStore(),
              r = inject("productCode", {
                pdtCode: "",
              }),
              a = computed(() => n.data.options.length >= 2),
              i = ref("Y"),
              l = computed(() => n.data.options[0].extra?.NOTICE[i.value === "Y" ? 0 : 1]),
              c = computed(() =>
                a.value
                  ? []
                  : n.data.options
                      .filter((_, p) => _.extra?.ESN_YN === "Y" || p === 0)
                      .map((_) => ({
                        PCS_CD: _.extra?.PCS_CD,
                        PCS_DTL_CD: _.extra?.PCS_DTL_CD,
                        PCS_DTL_NM: _.extra?.PCS_DTL_NM,
                        ATTB: "Y",
                        ATTB_2: i.value,
                      }))
              ),
              { canResetWhite: u, resetEditByWhite: d } = useWhiteReset();
            watch(
              () => c.value,
              (_) => {
                if (_)
                  if (r.pdtCode.startsWith("AC")) {
                    if (a.value && !s.isAfterEdit()) return;
                    u.value && d(), o("update", _), s.isAfterEdit() && !u.value && (u.value = !0);
                  } else o("update", _);
              },
              {
                immediate: !0,
              }
            );
            const h = (_) => {
                o("update:replace", _);
              },
              f = computed(() =>
                whiteAlwaysAutoSet.has(r.pdtCode)
                  ? !1
                  : s.uploadType.default === "pdf"
                  ? !0
                  : whiteExclusionMap[r.pdtCode] && n.relatedData.mtrlCd
                  ? !whiteExclusionMap[r.pdtCode][n.relatedData.mtrlCd]
                  : !1
              );
            return (
              watch(
                () => f.value,
                (_) => {
                  _ || ((i.value = "Y"), o("update", c.value));
                }
              ),
              (_, p) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: _.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", iO, [
                        createElement("div", aO, [
                          createElement("label", lO, [
                            withDirectives(
                              createElement(
                                "input",
                                {
                                  type: "radio",
                                  id: "auto-white",
                                  name: "white-mode",
                                  "onUpdate:modelValue": p[0] || (p[0] = (m) => (i.value = m)),
                                  value: "Y",
                                },
                                null,
                                512
                              ),
                              [[vModelRadio, i.value]]
                            ),
                            createElement("span", uO, toDisplayString(unref(t)("자동화이트")), 1),
                          ]),
                          f.value
                            ? (openBlock(),
                              createElementVNode("label", cO, [
                                withDirectives(
                                  createElement(
                                    "input",
                                    {
                                      type: "radio",
                                      id: "self-white",
                                      name: "white-mode",
                                      "onUpdate:modelValue": p[1] || (p[1] = (m) => (i.value = m)),
                                      value: "N",
                                    },
                                    null,
                                    512
                                  ),
                                  [[vModelRadio, i.value]]
                                ),
                                createElement(
                                  "span",
                                  dO,
                                  toDisplayString(unref(t)("수동화이트")),
                                  1
                                ),
                              ]))
                            : createCommentVNode("", !0),
                        ]),
                        a.value
                          ? (openBlock(),
                            createVNode(
                              lh,
                              {
                                key: 0,
                                mode: i.value,
                                options: _.data.options,
                                onUpdate: h,
                              },
                              null,
                              8,
                              ["mode", "options"]
                            ))
                          : createCommentVNode("", !0),
                        l.value
                          ? (openBlock(),
                            createElementVNode("p", fO, "* " + toDisplayString(l.value), 1))
                          : createCommentVNode("", !0),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  _O = {
    class: "flex-row",
  },
  hO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "RIN_DFT",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = ref(n.data.attbOptions[0].value),
              r = ref(n.data.attbOptions[0].name),
              a = (i) => {
                (s.value = i.value), (r.value = i.name);
              };
            return (
              watch(
                () => s.value,
                (i) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: n.data.options[0].value,
                      PCS_DTL_NM: `${n.data.name}(${r.value})`,
                      ATTB: i,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (i, l) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: i.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", _O, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            i.data.attbOptions,
                            (c) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: c.key,
                                  data: {
                                    value: c.value,
                                    name: c.name,
                                    imgPath: c.value,
                                  },
                                  active: s.value === c.value,
                                  onSelect: a,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  mO = {
    class: "options",
  },
  vO = {
    class: "full-width",
  },
  gO = {
    for: "ROU_DFT_ALL",
    class: "fake-checkbox",
  },
  yO = ["src"],
  CO = ["id", "value"],
  TO = ["for"],
  bO = ["src"],
  SO = {
    class: "option-name",
  },
  DO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "ROU_DFT",
            props: {
              data: {},
              relatedData: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = inject("productCode", {
                  pdtCode: "",
                }),
                r = computed(() => n.relatedData.sizeInfo?.DIV_SEQ),
                a = computed(() => {
                  const h = roundingConfigMap[s.pdtCode];
                  if (h && h.factor === "size" && r.value) {
                    const f = h.value[r.value];
                    return [
                      {
                        id: `round-${f}`,
                        name: "round-value",
                        label: `${f}mm`,
                        value: f,
                      },
                    ];
                  }
                  return [
                    {
                      id: "round-4",
                      name: "round-value",
                      label: "4mm",
                      value: "4",
                    },
                    {
                      id: "round-6",
                      name: "round-value",
                      label: "6mm",
                      value: "6",
                    },
                  ];
                }),
                i = ref(a.value[0].value),
                l = ref(!0),
                c = computed(() => n.data.options.map((h) => `${h.value}/${h.name}`)),
                u = ref(c.value);
              watch(
                () => l.value,
                (h) => {
                  h ? (u.value = c.value) : u.value.length === 4 && (u.value = []);
                }
              ),
                watch(
                  () => u.value,
                  (h) => {
                    l.value = h.length === 4;
                  }
                ),
                watch(
                  () => r.value,
                  (h) => {
                    !roundingConfigMap[s.pdtCode] ||
                      !h ||
                      (i.value = roundingConfigMap[s.pdtCode].value[h]);
                  }
                );
              const d = computed(() =>
                u.value.map((h) => {
                  const [f, _] = h.split("/");
                  return {
                    PCS_CD: n.data.value,
                    PCS_DTL_CD: f,
                    PCS_DTL_NM: _,
                    ATTB: i.value,
                  };
                })
              );
              return (
                watch(
                  () => d.value,
                  (h) => {
                    o("update", h);
                  },
                  {
                    immediate: !0,
                  }
                ),
                (h, f) => (
                  openBlock(),
                  createVNode(
                    OptionRow,
                    {
                      title: h.data.name,
                      underline: "",
                    },
                    {
                      default: withCtx(() => [
                        renderComponent(
                          RadioGroup,
                          {
                            options: a.value,
                            "default-checked": a.value[0].value,
                            onChange: f[0] || (f[0] = (_) => (i.value = _.value)),
                          },
                          null,
                          8,
                          ["options", "default-checked"]
                        ),
                        createElement("ul", mO, [
                          createElement("li", vO, [
                            withDirectives(
                              createElement(
                                "input",
                                {
                                  "onUpdate:modelValue": f[1] || (f[1] = (_) => (l.value = _)),
                                  type: "checkbox",
                                  id: "ROU_DFT_ALL",
                                },
                                null,
                                512
                              ),
                              [[vModelCheckbox, l.value]]
                            ),
                            createElement("label", gO, [
                              createElement(
                                "img",
                                {
                                  src: `${unref(CDN_BASE_URL)}/ko/order_aside_icon_round_all.svg`,
                                },
                                null,
                                8,
                                yO
                              ),
                              f[3] ||
                                (f[3] = createElement(
                                  "span",
                                  {
                                    class: "option-name",
                                  },
                                  "4귀 전체",
                                  -1
                                )),
                            ]),
                          ]),
                          (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            null,
                            renderList(
                              h.data.options,
                              (_) => (
                                openBlock(),
                                createElementVNode(
                                  "li",
                                  {
                                    key: _.value,
                                  },
                                  [
                                    withDirectives(
                                      createElement(
                                        "input",
                                        {
                                          "onUpdate:modelValue":
                                            f[2] || (f[2] = (p) => (u.value = p)),
                                          type: "checkbox",
                                          id: _.value,
                                          value: `${_.value}/${_.name}`,
                                        },
                                        null,
                                        8,
                                        CO
                                      ),
                                      [[vModelCheckbox, u.value]]
                                    ),
                                    createElement(
                                      "label",
                                      {
                                        for: _.value,
                                        class: "fake-checkbox",
                                      },
                                      [
                                        createElement(
                                          "img",
                                          {
                                            src: `${unref(
                                              CDN_BASE_URL
                                            )}/ko/order_aside_icon_ROU_DFT_${_.value}.svg`,
                                          },
                                          null,
                                          8,
                                          bO
                                        ),
                                        createElement("span", SO, toDisplayString(_.name), 1),
                                      ],
                                      8,
                                      TO
                                    ),
                                  ]
                                )
                              )
                            ),
                            128
                          )),
                        ]),
                      ]),
                      _: 1,
                    },
                    8,
                    ["title"]
                  )
                )
              );
            },
          }),
          [["__scopeId", "data-v-dd59e1e8"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  PO = {
    class: "grid-group",
  },
  EO = {
    class: "flex-row",
  },
  OO = {
    class: "note",
  },
  IO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "SCO_DFT",
          props: {
            data: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("callbacks", {}),
              r = {
                S: "단면",
                D: "양면",
                DFXX: "스코딕스",
              },
              a = computed(() => {
                const u = {},
                  d = {};
                for (const h of n.data.options) {
                  const f = h.value.slice(-1),
                    _ = r[f],
                    p = h.value.slice(0, 4),
                    m = r[p];
                  u[f] ||
                    (u[f] = {
                      id: `SCO_DFT/${f}`,
                      name: `SCO_DFT/${f}`,
                      label: _,
                      value: f,
                    }),
                    d[p] ||
                      (d[p] = {
                        ...h,
                        value: p,
                        name: m,
                      });
                }
                return {
                  sides: u,
                  spotUVs: d,
                };
              }),
              i = ref("S"),
              l = ref(n.data.options[0].value.slice(0, 4)),
              c = computed(() => l.value + i.value);
            return (
              watch(
                () => c.value,
                (u) => {
                  const d = n.data.options.find((h) => h.value === u)?.extra;
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: u,
                      PCS_DTL_NM: d?.PCS_DTL_NM,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              (u, d) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: u.data.name,
                    underline: "",
                    extra: {
                      name: "규격가이드",
                      callback: () => {
                        unref(s)?.onInformGuide && unref(s).onInformGuide("SCO_DFT");
                      },
                    },
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", PO, [
                        renderComponent(
                          RadioGroup,
                          {
                            options: Object.values(a.value.sides),
                            "default-checked": i.value,
                            onChange: d[0] || (d[0] = (h) => (i.value = h.value)),
                          },
                          null,
                          8,
                          ["options", "default-checked"]
                        ),
                        createElement("div", EO, [
                          (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            null,
                            renderList(
                              Object.values(a.value.spotUVs),
                              (h) => (
                                openBlock(),
                                createVNode(
                                  IconCheckbox,
                                  {
                                    key: h.key,
                                    data: {
                                      value: h.value,
                                      name: h.name,
                                      imgPath: u.data.value,
                                      subImgPath: u.data.subImgPath,
                                    },
                                    active: l.value === h.value,
                                    onSelect: d[1] || (d[1] = (f) => (l.value = f.value)),
                                  },
                                  null,
                                  8,
                                  ["data", "active"]
                                )
                              )
                            ),
                            128
                          )),
                        ]),
                        createElement(
                          "p",
                          OO,
                          toDisplayString(u.data.options[0]?.extra?.NOTICE[0]),
                          1
                        ),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title", "extra"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  RO = {
    class: "flex-row",
  },
  wO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "SUB_MTR_BC",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = computed(() =>
                n.data.options[0].extra.DIV_SEQ === 0
                  ? n.data.options
                  : n.data.options.filter((l) => l.extra.DIV_SEQ === n.relatedData.sizeInfo.DIV_SEQ)
              ),
              r = ref(s.value[0].value),
              a = ref(`${n.data.name}-${s.value[0].name}`),
              i = (l) => {
                (r.value = l.value), (a.value = `${n.data.name}-${l.name}`);
              };
            return (
              watch(
                () => r.value,
                (l) => {
                  o("update", [
                    {
                      PCS_CD: n.data.value,
                      PCS_DTL_CD: l,
                      PCS_DTL_NM: a.value,
                    },
                  ]);
                },
                {
                  immediate: !0,
                }
              ),
              watch(
                () => n.relatedData.sizeInfo.DIV_SEQ,
                () => {
                  (r.value = s.value[0].value), (a.value = `${n.data.name}-${s.value[0].name}`);
                }
              ),
              (l, c) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: l.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      createElement("div", RO, [
                        (openBlock(!0),
                        createElementVNode(
                          Fragment,
                          null,
                          renderList(
                            s.value,
                            (u) => (
                              openBlock(),
                              createVNode(
                                IconCheckbox,
                                {
                                  key: u.key,
                                  data: {
                                    value: u.value,
                                    name: u.name,
                                    imgPath: `${l.data.subImgPath}_${u.value}`,
                                    subImgPath: l.data.value,
                                  },
                                  active: r.value === u.value,
                                  onSelect: i,
                                },
                                null,
                                8,
                                ["data", "active"]
                              )
                            )
                          ),
                          128
                        )),
                      ]),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  AO = {
    key: 0,
    class: "flex-row",
  },
  NO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "WRK_MTR",
          props: {
            data: {},
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = {
                WRK_MTR_PB: "icon",
              },
              o = e,
              s = t,
              r = computed(() =>
                o.data.options.map((l) => ({
                  id: l.value,
                  name: o.data.value,
                  label: l.name,
                  value: l.value,
                }))
              ),
              a = ref(r.value[0]),
              i = computed(() => ({
                PCS_CD: o.data.value,
                PCS_DTL_CD: a.value.value,
                PCS_DTL_NM: a.value.label,
                ATTB: o.relatedData.orderQty,
              }));
            return (
              watch(
                () => i.value,
                (l, c) => {
                  (c?.ATTB === l.ATTB && c?.PCS_DTL_CD === l.PCS_DTL_CD) || s("update", [l]);
                },
                {
                  immediate: !0,
                }
              ),
              (l, c) => (
                openBlock(),
                createVNode(
                  OptionRow,
                  {
                    title: l.data.name,
                    underline: "",
                  },
                  {
                    default: withCtx(() => [
                      n[l.data.group] === "icon"
                        ? (openBlock(),
                          createElementVNode("div", AO, [
                            (openBlock(!0),
                            createElementVNode(
                              Fragment,
                              null,
                              renderList(
                                l.data.options,
                                (u) => (
                                  openBlock(),
                                  createVNode(
                                    IconCheckbox,
                                    {
                                      key: u.value,
                                      active: a.value.value === u.value,
                                      data: {
                                        ...u,
                                        imgPath: `${l.data.value}_${u.value}`,
                                      },
                                      onSelect: (d) => {
                                        a.value = {
                                          id: d.value,
                                          name: o.data.value,
                                          label: d.name,
                                          value: d.value,
                                        };
                                      },
                                    },
                                    null,
                                    8,
                                    ["active", "data", "onSelect"]
                                  )
                                )
                              ),
                              128
                            )),
                          ]))
                        : (openBlock(),
                          createVNode(
                            RadioGroup,
                            {
                              key: 1,
                              options: r.value,
                              "default-checked": r.value[0].value,
                              onChange: c[0] || (c[0] = (u) => (a.value = u)),
                            },
                            null,
                            8,
                            ["options", "default-checked"]
                          )),
                    ]),
                    _: 1,
                  },
                  8,
                  ["title"]
                )
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  MO = ["value", "disabled"],
  kO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "Basic",
          props: {
            options: {},
            showExtra: {
              type: Boolean,
              default: !1,
            },
            default: {},
            resetAfterEdit: {
              type: Boolean,
            },
            relatedData: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = inject("callbacks", {}),
              r = inject("productCode", {
                pdtCode: "",
              }),
              a = useI18n(),
              i = computed(() => n.relatedData?.filters),
              l = computed(() => n.relatedData?.POST_PCS),
              c = computed(() => {
                let p = [];
                return (
                  materialFilterSet.has(r.pdtCode) &&
                    l.value &&
                    (p = n.options.filter(
                      (m) => m.MTRL_CD === l.value?.MTRL_CD || m.BSN_YN === "Y"
                    )),
                  i.value &&
                    (p = n.options.filter(
                      (m) =>
                        (i.value?.MTRL_GRP ? i.value.MTRL_GRP === m.GRP_OPTION_CD : !0) &&
                        (i.value?.PTT ? i.value.PTT === m.PTT_CD : !0)
                    )),
                  p.length > 0 ? p : n.options
                );
              }),
              u = computed(() => c.value.filter((p) => p.HIDE_YN !== "Y")),
              d = async () => {
                const p = await fetchMaterialInfo({
                  pdt_cod: r.pdtCode,
                  lang: a.locale,
                });
                if (!p) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
                if (s?.onInformMaterials) {
                  const m = r.pdtCode.startsWith("ST") ? [t("스티커용지-주의사항")] : void 0;
                  s.onInformMaterials(p, m);
                } else console.log("[RedWidgetSDK] 자재 정보 >", p);
              },
              h = () => {
                n.resetAfterEdit && s?.onReset && s.onReset("mtrl");
              },
              f = ref(n.default?.MTRL_CD || u.value[0]?.MTRL_CD);
            watch(
              () => f.value,
              (p) => {
                const m = u.value.find((v) => v.MTRL_CD === p);
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
                  }),
                    v === "OOO" && s?.onSaleOrder && s?.onSaleOrder(),
                    h();
                }
              },
              {
                immediate: !0,
              }
            ),
              watch(
                () => l.value?.MTRL_CD,
                (p) => {
                  p && materialFilterSet.has(r.pdtCode) && (f.value = u.value[0]?.MTRL_CD);
                }
              ),
              watch(
                () => i.value,
                (p, m) => {
                  (p?.MTRL_GRP !== m?.MTRL_GRP || p?.PTT !== m?.PTT) &&
                    (f.value = u.value[0]?.MTRL_CD);
                }
              );
            const _ = computed(() =>
              deviceModelSet.has(r.pdtCode) ? "기종" : r.pdtCode === "PHFRDIA" ? "액자" : "자재"
            );
            return (p, m) => (
              openBlock(),
              createVNode(
                OptionRow,
                {
                  title: _.value,
                  extra: p.showExtra
                    ? {
                        name: "주문가능자재",
                        callback: d,
                      }
                    : null,
                },
                {
                  default: withCtx(() => [
                    withDirectives(
                      createElement(
                        "select",
                        {
                          "onUpdate:modelValue": m[0] || (m[0] = (v) => (f.value = v)),
                          class: "basic-select",
                          name: "material",
                          onChange: h,
                        },
                        [
                          (openBlock(!0),
                          createElementVNode(
                            Fragment,
                            null,
                            renderList(
                              c.value,
                              (v) => (
                                openBlock(),
                                createElementVNode(
                                  "option",
                                  {
                                    key: v.MTRL_CD,
                                    value: v.MTRL_CD,
                                    disabled: v.HIDE_YN === "Y",
                                  },
                                  toDisplayString(
                                    v.HIDE_YN !== "Y"
                                      ? c.value.length === 1
                                        ? v.PTT_NM
                                        : v.MTRL_NM || v.PTT_NM
                                      : `[${v.HIDE_RSN || unref(t)("주문불가")}] ${v.MTRL_NM}`
                                  ) +
                                    " " +
                                    toDisplayString(v.BSN_YN === "Y" ? "[영업주문]" : ""),
                                  9,
                                  MO
                                )
                              )
                            ),
                            128
                          )),
                        ],
                        544
                      ),
                      [[vModelSelect, f.value]]
                    ),
                  ]),
                  _: 1,
                },
                8,
                ["title", "extra"]
              )
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  LO = {
    class: "inputs",
  },
  $O = ["disabled"],
  xO = {
    class: "notes",
  },
  FO = {
    key: 0,
    class: "note red",
  },
  UO = {
    class: "note red",
  },
  BO = {
    class: "inputs",
  },
  VO = ["value"],
  HO = {
    key: 0,
    class: "notes",
  },
  GO = {
    class: "note red",
  },
  jO = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "CalendarQty",
            props: {
              options: {},
              default: {},
              relatedData: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = inject("productCode", {
                  pdtCode: "",
                }),
                r = useEditorStore(),
                a = ref("select"),
                i = () => {
                  a.value = a.value === "input" ? "select" : "input";
                },
                l = computed(() =>
                  calendarPdfOnlySet.has(s.pdtCode) ? !0 : r.uploadType.default === "pdf"
                ),
                c = computed(() => n.options.find((A) => A.DFT_YN === "Y") || n.options[0]),
                u = computed(() => c.value?.MIN_PRN_CNT || 1),
                d = computed(() => c.value?.DFT_PRN_CNT || 1),
                h = computed(() => {
                  if (n.options.length > 1) return n.options;
                  const A = d.value,
                    b = u.value,
                    C = A * 10,
                    y = [];
                  for (let I = b; I <= C; I += A) {
                    const w = {
                      PRN_CNT: I,
                    };
                    y.push(w);
                  }
                  return y;
                }),
                f = ref(n.default?.ordCnt || 13),
                _ = ref(n.default?.prnCnt || u.value),
                p = computed(() => ({
                  ordCnt: f.value,
                  prnCnt: _.value,
                })),
                m = computed(() => {
                  const A = n.relatedData?.dosu === "SID_D" ? 2 : 1;
                  return (f.value * A).toLocaleString();
                }),
                v = computed(
                  () => n.relatedData?.size === "mini" || r.uploadType.default === "editor"
                ),
                E = computed(() =>
                  n.relatedData?.size === "mini" ? 13 : s.pdtCode === "TPCLECO" ? 14 : 24
                ),
                k = computed(() => {
                  if (d.value === 1) return !1;
                  const A = p.value.prnCnt % d.value;
                  return d.value > 1 && A !== 0;
                }),
                N = computed(() => p.value.ordCnt < 13 || p.value.ordCnt > E.value);
              watch(
                () => p.value,
                debounce((A) => {
                  k.value
                    ? o("update", {
                        ordCnt: f.value,
                        prnCnt: 0,
                      })
                    : N.value
                    ? o("update", {
                        ordCnt: 0,
                        prnCnt: _.value,
                      })
                    : o("update", A);
                }, 200),
                {
                  immediate: !0,
                }
              );
              const D = () => {
                  if (k.value) {
                    const A = Math.ceil(p.value.prnCnt / d.value);
                    _.value = (A || 1) * d.value;
                  }
                },
                O = () => {
                  N.value &&
                    (p.value.ordCnt < 13 && (f.value = 13),
                    p.value.ordCnt > E.value && (f.value = E.value));
                };
              return (
                watch(
                  () => r.editorData?.default?.quantityInfo?.ordCnt,
                  (A, b) => {
                    if (A) f.value = A;
                    else if (b) return (f.value = 13);
                  }
                ),
                (A, b) => (
                  openBlock(),
                  createVNode(OptionRow, null, {
                    default: withCtx(() => [
                      l.value
                        ? (openBlock(),
                          createVNode(
                            OptionRow,
                            {
                              key: 0,
                              title: "디자인수",
                            },
                            {
                              default: withCtx(() => [
                                createElement("div", LO, [
                                  withDirectives(
                                    createElement(
                                      "input",
                                      {
                                        "onUpdate:modelValue":
                                          b[0] || (b[0] = (C) => (f.value = C)),
                                        type: "number",
                                        class: normalizeClass(["basic-input", "-fixed-w"]),
                                        id: "ORD_CNT",
                                        min: "13",
                                        disabled: v.value,
                                        onFocusout: O,
                                      },
                                      null,
                                      40,
                                      $O
                                    ),
                                    [[vModelText, f.value]]
                                  ),
                                  createTextVNode(" " + toDisplayString(unref(t)("장")), 1),
                                ]),
                                createElement("div", xO, [
                                  unref(r).uploadType.default === "pdf"
                                    ? (openBlock(),
                                      createElementVNode(
                                        "p",
                                        FO,
                                        " * " +
                                          toDisplayString(
                                            `${unref(t)("PDF장수안내", {
                                              QTY: m.value,
                                            })}`
                                          ),
                                        1
                                      ))
                                    : createCommentVNode("", !0),
                                  createElement(
                                    "p",
                                    UO,
                                    "* " +
                                      toDisplayString(
                                        unref(t)("달력디자인수설명", {
                                          MAX_CNT: `${E.value}`,
                                        })
                                      ),
                                    1
                                  ),
                                ]),
                                b[3] || (b[3] = createElement("br", null, null, -1)),
                              ]),
                              _: 1,
                            }
                          ))
                        : createCommentVNode("", !0),
                      renderComponent(
                        OptionRow,
                        {
                          title: "수량",
                        },
                        {
                          default: withCtx(() => [
                            createElement("div", BO, [
                              a.value === "input"
                                ? withDirectives(
                                    (openBlock(),
                                    createElementVNode(
                                      "input",
                                      {
                                        key: 0,
                                        "onUpdate:modelValue":
                                          b[1] || (b[1] = (C) => (_.value = C)),
                                        type: "number",
                                        class: normalizeClass(["basic-input", "-fixed-w"]),
                                        id: "PRN_CNT",
                                        min: "1",
                                        onFocusout: D,
                                      },
                                      null,
                                      544
                                    )),
                                    [[vModelText, _.value]]
                                  )
                                : withDirectives(
                                    (openBlock(),
                                    createElementVNode(
                                      "select",
                                      {
                                        key: 1,
                                        "onUpdate:modelValue":
                                          b[2] || (b[2] = (C) => (_.value = C)),
                                        name: "PRN_CNT",
                                        class: normalizeClass(["basic-select", "-fixed-w"]),
                                      },
                                      [
                                        (openBlock(!0),
                                        createElementVNode(
                                          Fragment,
                                          null,
                                          renderList(
                                            h.value,
                                            (C) => (
                                              openBlock(),
                                              createElementVNode(
                                                "option",
                                                {
                                                  value: C.PRN_CNT,
                                                  key: C.PRN_CNT,
                                                },
                                                toDisplayString(C.PRN_CNT),
                                                9,
                                                VO
                                              )
                                            )
                                          ),
                                          128
                                        )),
                                      ],
                                      512
                                    )),
                                    [[vModelSelect, _.value]]
                                  ),
                              createTextVNode(" " + toDisplayString(unref(t)("개")) + " ", 1),
                              createElement(
                                "button",
                                {
                                  type: "button",
                                  class: "action-btn",
                                  onClick: i,
                                },
                                toDisplayString(
                                  a.value === "input" ? unref(t)("수량선택") : unref(t)("직접입력")
                                ),
                                1
                              ),
                            ]),
                            d.value !== 1
                              ? (openBlock(),
                                createElementVNode("div", HO, [
                                  createElement(
                                    "p",
                                    GO,
                                    " * " +
                                      toDisplayString(
                                        unref(t)("최소단위수량안내", {
                                          MIN_QTY: `${u.value}`,
                                          UNIT_QTY:
                                            d.value % 2 === 0 ? unref(t)("짝수") : unref(t)("홀수"),
                                        })
                                      ),
                                    1
                                  ),
                                ]))
                              : createCommentVNode("", !0),
                          ]),
                          _: 1,
                        }
                      ),
                    ]),
                    _: 1,
                  })
                )
              );
            },
          }),
          [["__scopeId", "data-v-129f13ef"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  zO = {
    class: "qty-group",
  },
  YO = {
    class: "title",
  },
  KO = {
    class: "subject",
  },
  WO = {
    class: "subject",
  },
  qO = {
    class: "inputs",
  },
  QO = ["value"],
  XO = {
    class: "icon-box",
  },
  JO = ["value"],
  ZO = {
    class: "notes",
  },
  eI = {
    key: 0,
    class: "note",
  },
  tI = {
    key: 1,
    class: "note",
  },
  nI = {
    key: 2,
    class: "note",
  },
  oI = {
    key: 3,
    class: "note",
  },
  sI = {
    key: 4,
    class: "note red",
  },
  rI = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "SetQty",
            props: {
              defaultSetCnt: {},
              canEditOrdCnt: {},
              expressShipping: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = useEditorStore(),
                r = computed(() => s.editorData?.default?.cntInfo?.initCnt),
                a = computed(() => s.editorData?.default?.cntInfo?.totalCnt),
                i = computed(() => (a.value || 0) / (r.value || 0)),
                l = computed(() => {
                  if (!n.expressShipping) return;
                  const { maxQty: c, type: u } = n.expressShipping;
                  if (!(c === 0 || c >= (a.value || 0))) {
                    if (u === "Y") return t("오늘출발-불가능");
                    if (u === "T") return t("내일출발-불가능");
                  }
                });
              return (
                watch(
                  () => s.editorData?.default?.quantityInfo,
                  (c) => {
                    const u = c?.prnCnt || 1;
                    o("update", {
                      ordCnt: c?.ordCnt || 1,
                      prnCnt: u < n.defaultSetCnt ? n.defaultSetCnt : u,
                    });
                  },
                  {
                    immediate: !0,
                  }
                ),
                (c, u) => {
                  const d = resolveDirective("dompurify-html");
                  return (
                    openBlock(),
                    createVNode(OptionRow, null, {
                      default: withCtx(() => [
                        createElement("div", zO, [
                          createElement("div", YO, [
                            createElement("h2", KO, toDisplayString(unref(t)("세트별수량")), 1),
                            createElement("h2", WO, toDisplayString(unref(t)("세트")), 1),
                          ]),
                          createElement("div", qO, [
                            createElement(
                              "input",
                              {
                                type: "number",
                                class: "basic-input",
                                id: "unitQty",
                                maxlength: "6",
                                min: "1",
                                value: r.value,
                                disabled: "",
                              },
                              null,
                              8,
                              QO
                            ),
                            createElement("div", XO, [renderComponent(CloseIcon)]),
                            createElement(
                              "input",
                              {
                                type: "number",
                                class: "basic-input",
                                id: "setQty",
                                maxlength: "6",
                                min: "1",
                                value: i.value,
                                disabled: "",
                              },
                              null,
                              8,
                              JO
                            ),
                          ]),
                          createElement("div", ZO, [
                            a.value
                              ? withDirectives(
                                  (openBlock(), createElementVNode("p", tI, null, 512)),
                                  [
                                    [
                                      d,
                                      unref(t)("주문수량안내", {
                                        QTY: a.value.toLocaleString() + unref(t)("개"),
                                      }),
                                    ],
                                  ]
                                )
                              : (openBlock(),
                                createElementVNode(
                                  "p",
                                  eI,
                                  "* " + toDisplayString(unref(t)("세트수량안내")),
                                  1
                                )),
                            c.canEditOrdCnt.pdf && c.canEditOrdCnt.editor
                              ? (openBlock(),
                                createElementVNode(
                                  "p",
                                  nI,
                                  "* " + toDisplayString(unref(t)("디자인건수가능여부-전체")),
                                  1
                                ))
                              : !c.canEditOrdCnt.pdf && c.canEditOrdCnt.editor
                              ? (openBlock(),
                                createElementVNode(
                                  "p",
                                  oI,
                                  " * " + toDisplayString(unref(t)("디자인건수가능여부-에디터")),
                                  1
                                ))
                              : createCommentVNode("", !0),
                            l.value
                              ? withDirectives(
                                  (openBlock(), createElementVNode("p", sI, null, 512)),
                                  [[d, l.value]]
                                )
                              : createCommentVNode("", !0),
                          ]),
                        ]),
                      ]),
                      _: 1,
                    })
                  );
                }
              );
            },
          }),
          [["__scopeId", "data-v-aa32054c"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  iI = {
    class: "qty-group",
  },
  aI = {
    class: "title",
  },
  lI = {
    class: "subject",
  },
  uI = {
    class: "inputs",
  },
  cI = ["value"],
  dI = {
    class: "notes",
  },
  fI = {
    class: "note",
  },
  pI = {
    key: 0,
    class: "note red",
  },
  _I = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: withScopeId(
          defineComponent({
            __name: "SimpleQty",
            props: {
              options: {},
              unit: {},
              default: {},
              relatedData: {},
              expressShipping: {},
            },
            emits: ["update"],
            setup(e, { emit: t }) {
              const n = e,
                o = t,
                s = inject("productCode", {
                  pdtCode: "",
                }),
                r = ref("select"),
                a = () => {
                  (r.value = r.value === "input" ? "select" : "input"),
                    r.value === "select" &&
                      (h.value.find((A) => A.PRN_CNT === _.value) || (_.value = l.value));
                },
                i = computed(() => n.options.find((O) => O.DFT_YN === "Y") || n.options[0]),
                l = computed(() => i.value?.DFT_PRN_CNT || 1),
                c = computed(() => i.value?.MIN_PRN_CNT || 1),
                u = computed(() => i.value?.INC_CNT || 1),
                d = computed(() => i.value?.INC_STEP || 10),
                h = computed(() => {
                  if (n.options.length > 1) return n.options;
                  const O = [];
                  for (let A = c.value; O.length < d.value; A += u.value) {
                    const b = {
                      PRN_CNT: A,
                    };
                    O.push(b);
                  }
                  return O;
                }),
                f = ref(n.default?.ordCnt || 1),
                _ = ref(n.default?.prnCnt || l.value || c.value),
                p = computed(() => ({
                  ordCnt: f.value,
                  prnCnt: _.value,
                })),
                m = {
                  STDRCAD: {
                    name: "세트",
                    qtyPerSet: 2,
                  },
                  STTBDFT: {
                    name: "세트",
                    qtyPerSet: 10,
                  },
                  TPCAPTW: {
                    name: "세트",
                    qtyPerSet: 20,
                  },
                },
                v = computed(() => (f.value * _.value).toLocaleString()),
                E = computed(() => {
                  if (!n.expressShipping) return;
                  const { maxQty: O, type: A } = n.expressShipping;
                  if (!(O === 0 || O >= +v.value)) {
                    if (A === "Y") return t("오늘출발-불가능");
                    if (A === "T") return t("내일출발-불가능");
                  }
                }),
                k = computed(() => {
                  if (!_.value) return !0;
                  if (u.value !== 1) {
                    const O = _.value % u.value;
                    if (u.value > 1 && O !== 0) return !0;
                  }
                  return !1;
                }),
                N = computed(() => !f.value),
                D = () => {
                  if (!_.value) return (_.value = 1);
                  if (u.value !== 1) {
                    const O = _.value % u.value;
                    if (u.value > 1 && O !== 0) {
                      const A = Math.ceil(_.value / u.value);
                      _.value = (A || 1) * u.value;
                    }
                  }
                };
              return (
                watch(
                  () => p.value,
                  debounce((O) => {
                    k.value || N.value || o("update", O);
                  }, 300),
                  {
                    immediate: !0,
                  }
                ),
                (O, A) => {
                  const b = resolveDirective("dompurify-html");
                  return (
                    openBlock(),
                    createVNode(OptionRow, null, {
                      default: withCtx(() => [
                        createElement("div", iI, [
                          createElement("div", aI, [
                            createElement("h2", lI, toDisplayString(unref(t)("수량")), 1),
                          ]),
                          createElement("div", uI, [
                            r.value === "input"
                              ? withDirectives(
                                  (openBlock(),
                                  createElementVNode(
                                    "input",
                                    {
                                      key: 0,
                                      "onUpdate:modelValue": A[0] || (A[0] = (C) => (_.value = C)),
                                      type: "number",
                                      class: "basic-input",
                                      id: "PRN_CNT",
                                      min: "1",
                                      onFocusout: D,
                                    },
                                    null,
                                    544
                                  )),
                                  [[vModelText, _.value]]
                                )
                              : withDirectives(
                                  (openBlock(),
                                  createElementVNode(
                                    "select",
                                    {
                                      key: 1,
                                      "onUpdate:modelValue": A[1] || (A[1] = (C) => (_.value = C)),
                                      name: "PRN_CNT",
                                      class: "basic-select",
                                    },
                                    [
                                      (openBlock(!0),
                                      createElementVNode(
                                        Fragment,
                                        null,
                                        renderList(
                                          h.value,
                                          (C) => (
                                            openBlock(),
                                            createElementVNode(
                                              "option",
                                              {
                                                value: C.PRN_CNT,
                                                key: C.PRN_CNT,
                                              },
                                              toDisplayString(C.PRN_CNT),
                                              9,
                                              cI
                                            )
                                          )
                                        ),
                                        128
                                      )),
                                    ],
                                    512
                                  )),
                                  [[vModelSelect, _.value]]
                                ),
                            createElement(
                              "button",
                              {
                                type: "button",
                                class: "action-btn",
                                onClick: a,
                              },
                              toDisplayString(
                                r.value === "input" ? unref(t)("수량선택") : unref(t)("직접입력")
                              ),
                              1
                            ),
                          ]),
                        ]),
                        createElement("div", dI, [
                          withDirectives(createElement("p", fI, null, 512), [
                            [
                              b,
                              unref(t)("주문수량안내", {
                                QTY: `${v.value}${unref(t)(m[unref(s).pdtCode].name)}`,
                              }) +
                                ` (${m[unref(s).pdtCode].qtyPerSet}${O.unit}/1${unref(t)(
                                  m[unref(s).pdtCode].name
                                )})`,
                            ],
                          ]),
                          E.value
                            ? withDirectives(
                                (openBlock(), createElementVNode("p", pI, null, 512)),
                                [[b, E.value]]
                              )
                            : createCommentVNode("", !0),
                        ]),
                      ]),
                      _: 1,
                    })
                  );
                }
              );
            },
          }),
          [["__scopeId", "data-v-29abd9de"]]
        ),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  ),
  hI = ["value"],
  mI = {
    class: "notes",
  },
  vI = {
    key: 0,
    class: "note",
  },
  gI = {
    key: 1,
    class: "note",
  },
  yI = {
    key: 2,
    class: "note",
  },
  CI = {
    key: 3,
    class: "note",
  },
  TI = {
    key: 4,
    class: "note red",
  },
  bI = Object.freeze(
    Object.defineProperty(
      {
        __proto__: null,
        default: defineComponent({
          __name: "TotalQty",
          props: {
            canEditOrdCnt: {},
            expressShipping: {},
          },
          emits: ["update"],
          setup(e, { emit: t }) {
            const n = e,
              o = t,
              s = useEditorStore(),
              r = computed(() => s.editorData?.default?.cntInfo?.totalCnt),
              a = computed(() => s.editorData?.default?.quantityInfo?.ordCnt),
              i = computed(() => {
                if (!n.expressShipping) return;
                const { maxQty: l, type: c } = n.expressShipping;
                if (!(l === 0 || l >= (r.value || 0))) {
                  if (c === "Y") return t("오늘출발-불가능");
                  if (c === "T") return t("내일출발-불가능");
                }
              });
            return (
              watch(
                () => s.editorData?.default?.quantityInfo,
                (l) => {
                  o("update", {
                    ordCnt: l?.ordCnt || 1,
                    prnCnt: l?.prnCnt || 1,
                  });
                },
                {
                  immediate: !0,
                }
              ),
              (l, c) => {
                const u = resolveDirective("dompurify-html");
                return (
                  openBlock(),
                  createVNode(
                    OptionRow,
                    {
                      title: "총수량",
                    },
                    {
                      default: withCtx(() => [
                        createElement(
                          "input",
                          {
                            type: "number",
                            class: "basic-input",
                            id: "totalQty",
                            maxlength: "6",
                            min: "1",
                            value: r.value,
                            disabled: "",
                          },
                          null,
                          8,
                          hI
                        ),
                        createElement("div", mI, [
                          a.value
                            ? withDirectives(
                                (openBlock(), createElementVNode("p", gI, null, 512)),
                                [[u, unref(t)("디자인건수안내").replace("{QTY}", `${a.value}`)]]
                              )
                            : (openBlock(),
                              createElementVNode(
                                "p",
                                vI,
                                "* " + toDisplayString(unref(t)("세트수량안내")),
                                1
                              )),
                          l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor
                            ? (openBlock(),
                              createElementVNode(
                                "p",
                                yI,
                                "* " + toDisplayString(unref(t)("디자인건수가능여부-전체")),
                                1
                              ))
                            : !l.canEditOrdCnt.pdf && l.canEditOrdCnt.editor
                            ? (openBlock(),
                              createElementVNode(
                                "p",
                                CI,
                                " * " + toDisplayString(unref(t)("디자인건수가능여부-에디터")),
                                1
                              ))
                            : createCommentVNode("", !0),
                          i.value
                            ? withDirectives(
                                (openBlock(), createElementVNode("p", TI, null, 512)),
                                [[u, i.value]]
                              )
                            : createCommentVNode("", !0),
                        ]),
                      ]),
                      _: 1,
                    }
                  )
                );
              }
            );
          },
        }),
      },
      Symbol.toStringTag,
      {
        value: "Module",
      }
    )
  );
