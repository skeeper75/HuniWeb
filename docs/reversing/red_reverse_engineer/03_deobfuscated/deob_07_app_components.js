/**
 * ============================================================================
 * RedPrinting 주문 위젯 — Vue 3 UI 컴포넌트 모듈 (역공학 결과)
 * ============================================================================
 *
 * 이 파일은 RedPrinting 자동견적 위젯의 Vue 3 UI 컴포넌트들을 포함합니다.
 * 주요 구성:
 *   - 의류(Apparel) 주문 컴포넌트: 인쇄영역, 사이즈, 수량, 팬톤컬러
 *   - 책자(Book) 주문 컴포넌트: 내지/표지, 도수, 용지, 수량
 *   - 부자재(Acc) 주문 컴포넌트: 옵션 선택, 수량, 가격 표시
 *   - 후가공(PostProcess) 컴포넌트: 코팅, 라운딩, 제본방향, 스코딕스 등
 *   - 수량(Quantity) 컴포넌트: 단순수량, 세트수량, 달력수량, 총수량
 *   - 용지(Material) 컴포넌트: 기본자재, 책자용지
 *
 * Vue 렌더 함수 매핑:
 *   g()  → openBlock()
 *   V()  → createVNode() (컴포넌트용)
 *   M()  → createElementVNode() (HTML 엘리먼트용)
 *   S()  → createElement()
 *   ce() → withCtx()
 *   de() → withDirectives()
 *   j()  → toDisplayString()
 *   T()  → unref()
 *   oe() → createCommentVNode()
 *   J    → Fragment
 *   K    → renderComponent (내부 렌더 헬퍼)
 *   he() → renderList()
 *   fe   → OptionRow (fieldset 래퍼 컴포넌트)
 *   je   → ImageButton (이미지 버튼 컴포넌트, deob_06 canonical. 구 IconCheckbox)
 *   Dn   → RadioList (라디오 리스트 컴포넌트, deob_06 canonical. 구 RadioGroup)
 *   Fo   → Selector (셀렉터 컴포넌트, deob_06 canonical. 구 BasicSelect)
 *   Ne   → Skeleton (로딩 스켈레톤)
 *   Kr   → CloseIcon / MultiplyIcon (아이콘)
 *   Sn   → ButtonRadio (버튼 라디오 컴포넌트, deob_06 canonical. 구 SizeSelector)
 *   sh   → ColorPicker (컬러 피커 컴포넌트, deob_06 canonical. 구 ColorChipSelector)
 *   we() → normalizeClass()
 *   Qt() → normalizeStyle()
 *   yt   → vModelText 디렉티브
 *   We   → vModelSelect 디렉티브
 *   Wi   → vModelCheckbox 디렉티브
 *   od   → vModelRadio 디렉티브
 *   Kt   → vShow 디렉티브
 *   Po() → createTextVNode()
 *
 * 기타 참조:
 *   re() → defineComponent()
 *   R()  → computed()
 *   H()  → ref()
 *   F()  → watch()
 *   xe() → reactive()
 *   le() → inject()
 *   Ve() → useExteriorStore() -- Pinia exterior 스토어 (uploadType, editorData). deob_06 canonical: defineStore("exterior")
 *   Dt() → useConfigStore() -- Pinia config 스토어 (locale 관리). Note: x()/translate() 함수가 내부적으로 useConfigStore를 호출하므로 useI18n은 간접적 별칭
 *   x()  → t() (번역 함수)
 *   Be() → withScopeId() (scoped CSS)
 *   on() → resolveDirective()
 *   br() → withModifiers()
 *   rs() → onMounted()
 *   Pi() → onBeforeUnmount()
 *   un() → debounce()
 *   cn() → isEmpty()
 *   qe   → CDN_BASE_URL (정적 자원 CDN 기본 경로)
 *   Uv() → createStaticVNode()
 *
 * 주요 함수/유틸:
 *   qr()  → useOrderComposable() (주문 정보 관리 컴포저블)
 *   Wr()  → useUploadConfig() (업로드 설정 컴포저블)
 *   Ql()  → parsePostProcessOptions() (후가공 옵션 파싱)
 *   Nl()  → fetchMaterialInfo() (자재 정보 API 호출)
 *   Hl()  → useWhiteReset() (화이트 인쇄 리셋 컴포저블)
 *   Ml()  → useAccOrderStore() -- Pinia acc-order 스토어 (부자재 주문). deob_06 canonical: defineStore("acc-order")
 *   zr()  → useOrderStore() -- Pinia order 스토어 (orderData). deob_06 canonical: defineStore("order")
 *   dS()  → buildTemplateParams() (템플릿 다운로드 파라미터 빌드)
 *   BT()  → downloadTemplate() (템플릿 다운로드 API)
 *   Yr    → roundingConfigMap (라운딩 설정 맵)
 *   Ll    → bookPageMultiplierMap (책자 페이지 배수 맵)
 *   J_    → horizontalBindSet (가로제본 상품코드 Set)
 *   K_    → accFilterConfigMap (부자재 필터 설정 맵)
 *   $l    → materialFilterSet (자재 필터 상품코드 Set)
 *   Fl    → whiteExclusionMap (화이트 제외 맵)
 *   _1    → whiteAlwaysAutoSet (화이트 항상 자동 Set)
 *   f1    → deviceModelSet (기종 표시 상품코드 Set)
 *   z_    → calendarPdfOnlySet (달력 PDF전용 상품코드 Set)
 *
 * 컴포넌트 레지스트리 변수 (minified → 원래 이름):
 *   Bl   → SizeSelect (규격 선택)
 *   Xl   → BookQty (책자 수량)
 *   Jl   → Paper (용지 선택 — 책자용)
 *   Vl   → HiddenPostProcess (숨김 후가공)
 *   Yl   → VisiblePostProcess (표시 후가공)
 *   X_   → SubjectGroup (건명 그룹)
 *   ks   → FileUpload (파일 업로드)
 *   Nl   → fetchMaterialInfo
 *
 * ============================================================================
 */

/* =========================================================================
 * 섹션 1: 의류(Apparel) — 인쇄 영역 컴포넌트 (계속)
 * 의류 상품의 인쇄 영역(front, leftchest 등)을 아이콘 체크박스로 선택하는 UI.
 * DTF/직접인쇄/실크인쇄 유형에 따라 가이드 문구가 달라짐.
 * ========================================================================= */

          /* 인쇄영역 선택 — computed: 활성 영역 목록 생성 */
          }),
          /* 인쇄영역 옵션 → 직접인쇄 제한 영역 이름 computed */
          directPrintAreaNames = computed(() => {
            const restrictedAreaNames = [];
            for (const areaOption of props.options)(areaOption.COD === "CL011" || areaOption.COD === "CL009" || areaOption.COD === "CL010" || areaOption.COD === "CL004") && restrictedAreaNames.push(areaOption.COD_NME);
            return restrictedAreaNames.length === 0 ? null : restrictedAreaNames.join(", ")
          }),
          /* 인쇄영역 옵션 → 아이콘 데이터 배열 computed */
          printAreaIconItems = computed(() => props.options.map(areaOption => ({
            name: areaOption.COD_NME,
            value: areaOption.KOI_NME,
            imgPath: `${CDN_BASE_URL}/ko/item/printarea_${productCodeImageMap[productCode.pdtCode]?productCodeImageMap[productCode.pdtCode][areaOption.COD]:areaOption.COD}.svg`,
            forcedImg: !0
          }))),
          /* 인쇄영역 활성 상태 reactive 객체 */
          printAreaActiveState = reactive(props.options.reduce((stateMap, areaOption, index) => (stateMap[areaOption.KOI_NME] = {
            active: index === 0,
            COD: areaOption.COD,
            COD_NME: areaOption.COD_NME,
            KOI_NME: areaOption.KOI_NME
          }, stateMap), {})),
          /* 현재 활성화된 인쇄영역 목록 computed */
          activePrintAreas = computed(() => Object.entries(printAreaActiveState).reduce((activeList, entry) => {
            const [areaKey, areaData] = entry;
            return areaData.active && activeList.push({
              COD: areaData.COD,
              COD_NME: areaData.COD_NME,
              KOI_NME: areaKey
            }), activeList
          }, [])),
          /* 인쇄영역 리셋 핸들러 — 에디터 수정 후 상태 초기화 */
          handlePrintAreaReset = () => {
            callbacks?.onReset && callbacks.onReset("printArea")
          },
          /* 인쇄영역 토글 핸들러 — front/leftchest 상호 배타적 처리 */
          togglePrintArea = areaKey => {
            activePrintAreas.value.length === 1 && printAreaActiveState[areaKey]?.active || (editorStore.isAfterEdit() && handlePrintAreaReset(), areaKey === "front" && printAreaActiveState.leftchest && (printAreaActiveState.leftchest.active = !1), areaKey === "leftchest" && printAreaActiveState.front && (printAreaActiveState.front.active = !1), printAreaActiveState[areaKey].active = !printAreaActiveState[areaKey].active)
          };
        /* 인쇄영역 변경 시 부모로 update 이벤트 발행 */
        return watch(() => activePrintAreas.value, selectedAreas => {
          emit("update", selectedAreas)
        }, {
          immediate: !0
        }), /* 인쇄 유형(PRINT_GBN) 변경 감시 — 'N'이면 null 전달 */
        watch(() => props.relatedData.printType?.PRINT_GBN, printGbn => {
          printGbn === "N" ? emit("update", null) : emit("update", activePrintAreas.value)
        }), /* 에디터 데이터에서 인쇄영역 페이지 정보 동기화 */
        watch(() => editorStore.editorData.default, editorDefault => {
          const editorPages = editorDefault?.editorClothesInfo?.PAGES;
          if (editorPages)
            for (const areaKey in printAreaActiveState) printAreaActiveState[areaKey].active = editorPages.includes(areaKey)
        }), (instance, cache) => instance.relatedData.printType?.PRINT_GBN === "Y" ? (openBlock(), createVNode(OptionRow, {
          key: 0,
          title: "인쇄 영역"
        }, {
          default: withCtx(() => [createElement("div", printAreaGridClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(printAreaIconItems.value, iconItem => (openBlock(), createVNode(ImageButton, {
            key: iconItem.value,
            data: iconItem,
            active: printAreaActiveState[iconItem.value].active,
            onSelect: cache[0] || (cache[0] = selectedItem => togglePrintArea(selectedItem.value))
          }, null, 8, ["data", "active"]))), 128))]), createElement("div", printAreaNotesClass, [instance.relatedData.printType.COD === "PTP_DTF" && dtfGuideContent.value ? (openBlock(), createElementVNode("p", {
            key: 0,
            class: "note",
            innerHTML: unref(translate)("의류인쇄영역가이드")
          }, null, 8, dtfGuideAttrs)) : createCommentVNode("", !0), instance.relatedData.printType.COD === "PTP_DIR" && directPrintAreaNames.value ? (openBlock(), createElementVNode("p", {
            key: 1,
            class: "note",
            innerHTML: unref(translate)("의류인쇄영역가이드-직접인쇄", {
              areas: directPrintAreaNames.value
            })
          }, null, 8, directPrintGuideAttrs)) : createCommentVNode("", !0), instance.relatedData.printType.COD === "PTP_SLK" ? (openBlock(), createElementVNode("p", {
            key: 2,
            class: "note",
            innerHTML: unref(translate)("의류인쇄영역가이드-실크인쇄")
          }, null, 8, silkPrintGuideAttrs)) : createCommentVNode("", !0)])]),
          _: 1
        })) : createCommentVNode("", !0)
      }
    }),

/* =========================================================================
 * 섹션 2: 의류(Apparel) — 사이즈 구분 (성인/아동) 컴포넌트
 * adult/child 라디오 선택으로 사이즈 그룹을 전환하는 UI.
 * ========================================================================= */
    /**
     * 의류 사이즈 구분 (자유/규격) 선택 컴포넌트
     * 성인(adult)/아동(child) 라디오 버튼으로 사이즈 그룹을 전환하는 fieldset.
     * @component ApparelSizeGbn
     * @props {Array} options - 사이즈 구분 옵션 목록 (adult/child)
     * @props {string} default - 기본 선택값
     * @emits {string} update - 선택된 사이즈 구분값 (adult|child)
     */
    ApparelSizeGbn = defineComponent({
      __name: "ApparelSizeGbn",
      props: {
        options: {},
        default: {}
      },
      emits: ["update"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          /* 성인/아동 라디오 옵션 정의 */
          sizeGbnRadioOptions = [{
            id: "adult",
            name: "size-option",
            label: translate("adult"),
            value: "adult"
          }, {
            id: "child",
            name: "size-option",
            label: translate("child"),
            value: "child"
          }],
          selectedSizeGbn = ref(componentProps.default);
        /* 사이즈 구분 변경 시 부모에 update 전달 */
        return watch(() => selectedSizeGbn.value, newGbn => {
          emitFn("update", newGbn)
        }), (instance, cache) => (openBlock(), createVNode(RadioList, {
          options: sizeGbnRadioOptions,
          "default-checked": sizeGbnRadioOptions[0].value,
          onChange: cache[0] || (cache[0] = selectedOption => selectedSizeGbn.value = selectedOption.value)
        }, null, 8, ["default-checked"]))
      }
    }),

/* =========================================================================
 * 섹션 3: 의류(Apparel) — 단일 사이즈 수량 컴포넌트
 * 사이즈 1개를 선택하고 인쇄 수량을 지정하는 UI.
 * 사이즈별 품절(HIDE_YN) 처리, 퀵오더 불가 표시 포함.
 * ========================================================================= */
    singleSizeGridClass = {
      class: "grid-group"
    },
    quickOrderWarningClass = {
      key: 1,
      class: "note red"
    },
    singleSizeInputsClass = {
      class: "inputs"
    },
    singleSizeQtyValueAttrs = ["value"],
    singleSizeNotesClass = {
      class: "notes"
    },
    singleSizeNoteClass = {
      class: "note"
    },
    /**
     * 단일 사이즈 수량 입력 컴포넌트
     * 사이즈 1개를 선택하고 인쇄 수량을 지정하는 UI. 사이즈별 품절(HIDE_YN) 처리, 퀵오더 불가 표시 포함.
     * @component ApparelSingleSizeQty
     * @props {Array} options - 사이즈 옵션 목록 (COD, COD_NME, GBN, HIDE_YN 등)
     * @props {Object} sizeInfo - 현재 선택된 사이즈 구분 정보 (adult/child)
     * @emits {number} update:qty - 선택된 수량
     * @emits {Array} update:combinations - 사이즈+수량 조합 배열
     */
    ApparelSingleSizeQty = withScopeId(defineComponent({
      __name: "ApparelSingleSizeQty",
      props: {
        options: {},
        sizeInfo: {}
      },
      emits: ["update:qty", "update:combinations"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          editorStore = useExteriorStore(),
          callbacks = inject("callbacks", {}),
          /* 사이즈 옵션을 GBN(성인/아동)별로 그룹핑 */
          sizeGroupsByGbn = computed(() => {
            const groups = {};
            return componentProps.options.forEach(sizeOption => {
              const existingGroup = groups[sizeOption.GBN];
              existingGroup ? existingGroup.push(sizeOption) : groups[sizeOption.GBN] = [sizeOption]
            }), groups
          }),
          /* GBN 키 목록 (성인/아동) */
          gbnKeys = computed(() => Object.keys(sizeGroupsByGbn.value)),
          selectedGbn = ref(gbnKeys.value.length === 1 ? gbnKeys.value[0] : "adult"),
          /* 현재 GBN에 해당하는 사이즈 목록을 정렬하여 셀렉트 옵션으로 변환 */
          sortedSizeOptions = computed(() => [...sizeGroupsByGbn.value[selectedGbn.value]].sort((sizeA, sizeB) => componentProps.sizeInfo[sizeA.COD].ORD - componentProps.sizeInfo[sizeB.COD].ORD).map(sizeOption => ({
            name: componentProps.sizeInfo[sizeOption.COD].COD_NME || sizeOption.COD_NME,
            value: sizeOption.COD,
            key: sizeOption.COD,
            disabled: sizeOption.HIDE_YN === "Y"
          }))),
          /* 수량 입력 모드: select(드롭다운) / input(직접입력) */
          qtyInputMode = ref("select"),
          toggleQtyInputMode = () => {
            qtyInputMode.value = qtyInputMode.value === "input" ? "select" : "input"
          },
          /* 기본 선택 사이즈 계산 — 활성 사이즈 중 중간값 */
          defaultSizeCode = computed(() => {
            const activeSizes = sortedSizeOptions.value.filter(opt => !opt.disabled);
            if (activeSizes.length === 1) return activeSizes[0].value;
            const defaultIndex = selectedGbn.value === "adult" ? Math.trunc(activeSizes.length / 2) : 0;
            return activeSizes[defaultIndex].value
          }),
          selectedSizeCode = ref(defaultSizeCode.value);

        /* 사이즈 선택 핸들러 — 에디터 편집 후이면 리셋 처리 */
        function handleSizeSelect(sizeCode) {
          editorStore.isAfterEdit() && callbacks?.onReset && callbacks.onReset("size"), selectedSizeCode.value = sizeCode
        }
        const /* 인쇄수량 셀렉트 옵션 (1~10) */
          qtySelectOptions = computed(() => {
            const options = [];
            for (let qty = 1; qty <= 10; qty++) options.push(qty);
            return options
          }),
          printQuantity = ref(1);
        /* 수량 변경 감시 — 부모에 update:qty 이벤트 발행 */
        watch(() => printQuantity.value, newQty => {
          newQty || (printQuantity.value = 1), emitFn("update:qty", {
            ordCnt: 1,
            prnCnt: newQty
          })
        }, {
          immediate: !0
        }), onMounted(() => {
          selectedSizeCode.value = defaultSizeCode.value
        });
        const /* 선택된 사이즈+수량 조합 */
          sizeCombinations = computed(() => componentProps.options.filter(opt => opt.COD === selectedSizeCode.value).map(opt => ({
            size: opt,
            quantity: printQuantity.value
          }))),
          /* 퀵오더 불가 여부 */
          isQuickOrderDisabled = computed(() => sizeCombinations.value[0]?.size?.QUICK_ORD_YN === "N"),
          /* 퀵오더 불가 사이즈 이름 목록 */
          quickOrderDisabledNames = computed(() => componentProps.options.filter(opt => opt.QUICK_ORD_YN === "N").map(opt => componentProps.sizeInfo[opt.COD].COD_NME || opt.COD_NME).join(", "));
        /* 사이즈 조합 변경 시 부모에 update:combinations 이벤트 발행 */
        return watch(() => sizeCombinations.value, newCombinations => {
          newCombinations && emitFn("update:combinations", newCombinations)
        }, {
          immediate: !0
        }), /* 에디터 데이터에서 사이즈 동기화 */
        watch(() => editorStore.editorData.default, editorDefault => {
          const editorSize = editorDefault?.editorClothesInfo?.SIZE;
          editorSize && (selectedSizeCode.value = editorSize)
        }), (instance, cache) => {
          const domPurifyDirective = resolveDirective("dompurify-html");
          return openBlock(), createElementVNode(Fragment, null, [renderComponent(OptionRow, {
            title: "사이즈"
          }, {
            default: withCtx(() => [createElement("div", singleSizeGridClass, [gbnKeys.value.length > 1 ? (openBlock(), createVNode(ApparelSizeGbn, {
              key: 0,
              options: gbnKeys.value,
              default: selectedGbn.value,
              onUpdate: cache[0] || (cache[0] = newGbn => selectedGbn.value = newGbn)
            }, null, 8, ["options", "default"])) : createCommentVNode("", !0), renderComponent(ButtonRadio, {
              type: "sm",
              options: sortedSizeOptions.value,
              default: selectedSizeCode.value,
              onSelect: handleSizeSelect
            }, null, 8, ["options", "default"]), isQuickOrderDisabled.value ? (openBlock(), createElementVNode("p", quickOrderWarningClass, toDisplayString(unref(translate)("퀵오더불가")) + " - " + toDisplayString(quickOrderDisabledNames.value), 1)) : createCommentVNode("", !0)])]),
            _: 1
          }), renderComponent(OptionRow, {
            title: "수량"
          }, {
            default: withCtx(() => [createElement("div", singleSizeInputsClass, [qtyInputMode.value === "input" ? withDirectives((openBlock(), createElementVNode("input", {
              key: 0,
              "onUpdate:modelValue": cache[1] || (cache[1] = newVal => printQuantity.value = newVal),
              type: "number",
              class: normalizeClass(["basic-input", "-fixed-w"]),
              id: "PRN_CNT",
              min: "1"
            }, null, 512)), [
              [vModelText, printQuantity.value]
            ]) : withDirectives((openBlock(), createElementVNode("select", {
              key: 1,
              "onUpdate:modelValue": cache[2] || (cache[2] = newVal => printQuantity.value = newVal),
              name: "PRN_CNT",
              class: normalizeClass(["basic-select", "-fixed-w"])
            }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(qtySelectOptions.value, qtyOpt => (openBlock(), createElementVNode("option", {
              value: qtyOpt,
              key: `${qtyOpt}`
            }, toDisplayString(qtyOpt), 9, singleSizeQtyValueAttrs))), 128))], 512)), [
              [vModelSelect, printQuantity.value]
            ]), createElement("button", {
              type: "button",
              class: "action-btn",
              onClick: toggleQtyInputMode
            }, toDisplayString(qtyInputMode.value === "input" ? unref(translate)("수량선택") : unref(translate)("직접입력")), 1)]), createElement("div", singleSizeNotesClass, [withDirectives(createElement("p", singleSizeNoteClass, null, 512), [
              [domPurifyDirective, unref(translate)("의류주문가능수량", {
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

/* =========================================================================
 * 섹션 4: 의류(Apparel) — 멀티 사이즈 수량 컴포넌트
 * 여러 사이즈를 동시에 선택하고 각각 수량을 지정하는 UI.
 * +/- 버튼과 수량 입력 필드가 사이즈별로 표시됨.
 * ========================================================================= */
    multiSizeGridClass = {
      class: "grid-group"
    },
    multiSizeContainerClass = {
      class: "multi-size"
    },
    multiSizeLabelClass = {
      class: "label"
    },
    multiSizeInputBoxClass = {
      class: "input-box"
    },
    multiSizeDecreaseBtnAttrs = ["disabled", "onClick"],
    multiSizeQtyInputAttrs = ["onUpdate:modelValue", "disabled"],
    multiSizeIncreaseBtnAttrs = ["disabled", "onClick"],
    multiSizeQuickOrderWarningClass = {
      key: 1,
      class: "note red"
    },
    /**
     * 멀티 사이즈 수량표 컴포넌트
     * 복수 사이즈별 수량을 테이블 형태로 입력하는 UI. +/- 버튼과 직접입력 지원.
     * @component ApparelMultiSizeQty
     * @props {Array} options - 사이즈 옵션 목록
     * @props {Object} sizeInfo - 사이즈 구분 정보
     * @props {Object} relatedData - 관련 데이터 (인쇄유형 등)
     * @emits {number} update:qty - 총 수량 합계
     * @emits {Array} update:combinations - 사이즈별 수량 조합 배열
     */
    ApparelMultiSizeQty = withScopeId(defineComponent({
      __name: "ApparelMultiSizeQty",
      props: {
        options: {},
        sizeInfo: {}
      },
      emits: ["update:qty", "update:combinations"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          /* 사이즈 옵션을 GBN별로 그룹핑하고 ORD 순서로 정렬 */
          sortedSizeGroups = computed(() => {
            const sorted = [...componentProps.options].sort((sizeA, sizeB) => componentProps.sizeInfo[sizeA.COD].ORD - componentProps.sizeInfo[sizeB.COD].ORD),
              groups = {};
            return sorted.forEach(sizeOption => {
              const existingGroup = groups[sizeOption.GBN];
              existingGroup ? existingGroup.push(sizeOption) : groups[sizeOption.GBN] = [sizeOption]
            }), groups
          }),
          gbnKeys = computed(() => Object.keys(sortedSizeGroups.value)),
          selectedGbn = ref(gbnKeys.value.length === 1 ? gbnKeys.value[0] : "adult"),
          /* 각 사이즈별 수량 reactive 객체 */
          sizeQuantities = reactive(componentProps.options.reduce((qtyMap, sizeOpt) => (qtyMap[sizeOpt.COD] = 0, qtyMap), {})),
          /* 전체 수량 합계 */
          totalQuantity = computed(() => Object.values(sizeQuantities).reduce((sum, qty) => sum + qty, 0)),
          /* 수량 증가 핸들러 */
          incrementQty = sizeCode => {
            sizeQuantities[sizeCode] = sizeQuantities[sizeCode] + 1
          },
          /* 수량 감소 핸들러 (최소 0) */
          decrementQty = sizeCode => {
            sizeQuantities[sizeCode] < 1 || (sizeQuantities[sizeCode] = sizeQuantities[sizeCode] - 1)
          },
          /* 수량 > 0인 사이즈 조합 목록 */
          activeCombinations = computed(() => componentProps.options.filter(opt => sizeQuantities[opt.COD] > 0).map(opt => ({
            size: opt,
            quantity: sizeQuantities[opt.COD]
          }))),
          /* 퀵오더 불가 사이즈가 포함되어 있는지 */
          hasQuickOrderDisabled = computed(() => activeCombinations.value.some(combo => sizeQuantities[combo.size.COD] > 0 && combo.size.QUICK_ORD_YN === "N")),
          quickOrderDisabledNames = computed(() => componentProps.options.filter(opt => opt.QUICK_ORD_YN === "N").map(opt => componentProps.sizeInfo[opt.COD].COD_NME || opt.COD_NME).join(", "));
        /* 조합 변경 시 수량 + 조합 정보 부모 전달 */
        return watch(() => activeCombinations.value, newCombinations => {
          emitFn("update:qty", {
            ordCnt: 1,
            prnCnt: totalQuantity.value
          }), emitFn("update:combinations", newCombinations)
        }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
          title: "사이즈별수량"
        }, {
          default: withCtx(() => [createElement("div", multiSizeGridClass, [gbnKeys.value.length > 1 ? (openBlock(), createVNode(ApparelSizeGbn, {
            key: 0,
            options: gbnKeys.value,
            default: selectedGbn.value,
            onUpdate: cache[0] || (cache[0] = newGbn => selectedGbn.value = newGbn)
          }, null, 8, ["options", "default"])) : createCommentVNode("", !0), createElement("div", multiSizeContainerClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(sortedSizeGroups.value[selectedGbn.value], sizeOption => (openBlock(), createElementVNode("div", {
            key: sizeOption.COD,
            class: normalizeClass(["size", "size-s", {
              soldout: sizeOption.HIDE_YN === "Y"
            }])
          }, [createElement("span", multiSizeLabelClass, toDisplayString(instance.sizeInfo[sizeOption.COD].COD_NME || sizeOption.COD_NME), 1), createElement("div", multiSizeInputBoxClass, [createElement("button", {
            type: "button",
            class: "control-btn",
            disabled: sizeOption.HIDE_YN === "Y",
            onClick: () => decrementQty(sizeOption.COD)
          }, [...cache[1] || (cache[1] = [createElement("span", {
            class: "icon minus"
          }, null, -1)])], 8, multiSizeDecreaseBtnAttrs), withDirectives(createElement("input", {
            "onUpdate:modelValue": newVal => sizeQuantities[sizeOption.COD] = newVal,
            type: "number",
            name: "size-qty",
            disabled: sizeOption.HIDE_YN === "Y"
          }, null, 8, multiSizeQtyInputAttrs), [
            [vModelText, sizeQuantities[sizeOption.COD]]
          ]), createElement("button", {
            type: "button",
            class: "control-btn",
            disabled: sizeOption.HIDE_YN === "Y",
            onClick: () => incrementQty(sizeOption.COD)
          }, [...cache[2] || (cache[2] = [createElement("span", {
            class: "icon plus"
          }, null, -1)])], 8, multiSizeIncreaseBtnAttrs)])], 2))), 128))]), hasQuickOrderDisabled.value ? (openBlock(), createElementVNode("p", multiSizeQuickOrderWarningClass, toDisplayString(unref(translate)("퀵오더불가")) + " - " + toDisplayString(quickOrderDisabledNames.value), 1)) : createCommentVNode("", !0)])]),
          _: 1
        }))
      }
    }), [
      ["__scopeId", "data-v-949c188e"]
    ]),

/* =========================================================================
 * 섹션 5: 체크마크 아이콘 SVG 컴포넌트
 * 팬톤 컬러 선택 모달에서 선택 완료 표시용 체크마크 아이콘.
 * ========================================================================= */
    CheckmarkIconDef = {},
    CheckmarkIconSvgAttrs = {
      xmlns: "http://www.w3.org/2000/svg",
      width: "14",
      height: "10",
      viewBox: "0 0 14 10",
      fill: "none"
    };

  /* 체크마크 SVG 렌더 함수 */
  function renderCheckmarkIcon(props, cache) {
    return openBlock(), createElementVNode("svg", CheckmarkIconSvgAttrs, [...cache[0] || (cache[0] = [createElement("path", {
      d: "M1.29102 4.1319L6.21182 8.44571L12.4021 1.375",
      stroke: "white",
      "stroke-width": "2.18182",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    }, null, -1)])])
  }
  const CheckmarkIcon = withScopeId(CheckmarkIconDef, [
      ["render", renderCheckmarkIcon]
    ]),

/* =========================================================================
 * 섹션 6: 팬톤 컬러 선택 모달 컴포넌트
 * 실크인쇄 시 팬톤 컬러를 검색/선택하는 전체 화면 모달 UI.
 * 컬러 칩 그리드, 검색, 미리보기, PANTONE 로고 표시.
 * ========================================================================= */
    pantoneLayerClass = {
      class: "pantone-layer"
    },
    pantoneModalClass = {
      class: "pantone-modal"
    },
    pantoneHeaderClass = {
      class: "modal-header"
    },
    pantoneBodyClass = {
      class: "modal-body"
    },
    pantonePaletteClass = {
      class: "color-palette"
    },
    pantoneChipAttrs = ["data-rgb", "data-checked", "onClick"],
    pantoneNumberClass = {
      class: "pantone-number"
    },
    pantoneSelectedClass = {
      key: 1,
      class: "selected"
    },
    pantonePreviewClass = {
      class: "preview"
    },
    pantoneColorPreviewClass = {
      class: "color-preview"
    },
    pantoneSelectedColorClass = {
      key: 1,
      class: "selected-color"
    },
    pantoneNotFoundClass = {
      class: "not-found"
    },
    pantoneImgSrcAttrs = ["src"],
    pantoneMarkClass = {
      class: "pantone-mark"
    },
    pantoneLogoClass = {
      class: "logo"
    },
    pantoneTipIconClass = {
      class: "icon-padding tip"
    },
    pantoneTooltipClass = {
      class: "tooltip"
    },
    pantoneTipTextClass = {
      class: "tip-text"
    },
    pantoneSelectedTextClass = {
      class: "selected-color-text"
    },
    pantoneSearchClass = {
      class: "color-search"
    },
    pantoneSearchPlaceholderAttrs = ["placeholder"],
    pantoneNoticeClass = {
      class: "notice-txt"
    },
    pantoneConfirmBtnAttrs = ["disabled"],
    /**
     * 팬톤 컬러칩 선택 모달 컴포넌트
     * 팬톤 컬러 검색 + 컬러칩 그리드에서 잉크 색상을 선택하는 모달 UI.
     * @component PantoneChipModal
     * @props {Array} options - 팬톤 컬러 옵션 목록 (COD, COD_NME, HEX 등)
     * @props {Object} selected - 현재 선택된 팬톤 컬러
     * @emits {Object} select - 선택된 팬톤 컬러 객체
     * @emits close - 모달 닫기
     */
    PantoneChipModal = withScopeId(defineComponent({
      __name: "PantoneChipModal",
      props: {
        options: {},
        selected: {}
      },
      emits: ["close", "select"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          /* 사용자가 클릭으로 선택한 컬러 (임시) */
          tempSelectedColor = ref(null),
          /* 최종 표시할 선택 컬러: 임시 선택 또는 props.selected */
          displayedColor = computed(() => tempSelectedColor.value ? tempSelectedColor.value : componentProps.selected),
          /* 적용하기 버튼 핸들러 */
          handleConfirm = () => {
            displayedColor.value && emitFn("select", displayedColor.value)
          },
          searchQuery = ref(""),
          isSearchFailed = ref(!1),
          /* 팬톤 검색 핸들러 — 이름으로 검색 */
          handleSearch = () => {
            const normalizedQuery = searchQuery.value.toLowerCase().replace(/\s/g, ""),
              foundColor = componentProps.options.find(colorOpt => colorOpt.pantone_name.replace(/\s/g, "").toLowerCase().includes(normalizedQuery));
            foundColor ? (tempSelectedColor.value = foundColor, isSearchFailed.value = !1) : (tempSelectedColor.value = null, isSearchFailed.value = !0)
          };
        /* 팬톤 모달 렌더 함수 */
        return (instance, cache) => {
          const domPurifyDirective = resolveDirective("dompurify-html");
          return openBlock(), createElementVNode("div", pantoneLayerClass, [createElement("div", pantoneModalClass, [createElement("div", pantoneHeaderClass, [createElement("h2", null, toDisplayString(unref(translate)("팬톤 컬러 선택")), 1), createElement("button", {
            type: "button",
            class: "close-btn",
            onClick: cache[0] || (cache[0] = event => emitFn("close"))
          }, [renderComponent(CloseIcon)])]), createElement("div", pantoneBodyClass, [createElement("div", pantonePaletteClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.options, colorOpt => (openBlock(), createElementVNode("span", {
            key: colorOpt.hex_cod,
            class: "color-chip",
            "data-rgb": colorOpt.hex_cod,
            "data-checked": displayedColor.value?.hex_cod === colorOpt.hex_cod,
            style: normalizeStyle({
              backgroundColor: `rgb(${colorOpt.rgb_R}, ${colorOpt.rgb_G} ,${colorOpt.rgb_B})`
            }),
            onClick: clickEvent => tempSelectedColor.value = colorOpt
          }, [createElement("p", pantoneNumberClass, toDisplayString(colorOpt.pantone_name.replace("PANTONE", "")), 1), displayedColor.value?.hex_cod === colorOpt.hex_cod ? (openBlock(), createVNode(CheckmarkIcon, {
            key: 0
          })) : createCommentVNode("", !0), displayedColor.value?.hex_cod === colorOpt.hex_cod ? (openBlock(), createElementVNode("span", pantoneSelectedClass)) : createCommentVNode("", !0)], 12, pantoneChipAttrs))), 128))]), createElement("div", pantonePreviewClass, [createElement("div", pantoneColorPreviewClass, [displayedColor.value ? (openBlock(), createElementVNode("div", {
            key: 0,
            class: "selected-color",
            style: normalizeStyle({
              backgroundColor: `rgb(${displayedColor.value.rgb_R}, ${displayedColor.value.rgb_G} ,${displayedColor.value.rgb_B})`
            })
          }, null, 4)) : isSearchFailed.value ? (openBlock(), createElementVNode("div", pantoneSelectedColorClass, [withDirectives(createElement("p", pantoneNotFoundClass, null, 512), [
            [domPurifyDirective, unref(translate)("팬톤검색실패문구")]
          ])])) : (openBlock(), createElementVNode("img", {
            key: 2,
            src: `${unref(CDN_BASE_URL)}/ko/item/page-order-clothes-pantone-modal.png`,
            width: 240,
            height: 150,
            alt: "팬톤 선택 전 이미지"
          }, null, 8, pantoneImgSrcAttrs)), createElement("div", pantoneMarkClass, [createElement("div", pantoneLogoClass, [cache[3] || (cache[3] = createStaticVNode('<div class="icon-padding" data-v-d02e5e9c><svg xmlns="http://www.w3.org/2000/svg" width="114" height="18" viewBox="0 0 114 18" fill="none" data-v-d02e5e9c><path d="M5.2351 3.46373H7.80534C8.7552 3.46373 9.92857 3.46373 10.5991 4.35773C10.8226 4.6371 10.9902 5.02822 11.0461 5.81047C11.0461 7.20734 10.4873 8.04546 9.09045 8.26896C8.69933 8.32483 8.41996 8.32483 7.69359 8.32483H5.2351V3.46373ZM1.15625 0.4465V16.6502H5.2351V11.3421H7.97296C10.3197 11.2862 12.6106 11.1744 14.1192 8.99533C15.0132 7.71021 15.069 6.31334 15.069 5.75459C15.069 4.13423 14.5103 2.96086 14.175 2.45799C13.8957 2.06687 13.6163 1.78749 13.4487 1.67574C12.2194 0.614124 10.7667 0.4465 9.2022 0.390625L1.15625 0.4465Z" fill="black" data-v-d02e5e9c></path><path d="M19.4282 11.1762C19.8194 9.83519 20.2664 8.49419 20.6575 7.1532C20.9368 6.20333 21.1603 5.25346 21.4397 4.30359L23.563 11.1762H19.4282ZM23.6188 0.448242H19.3724L13.3379 16.6519H17.6402L18.4225 14.0817H24.5128L25.2951 16.6519H29.5974L23.6188 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M34.9015 0.448242L38.4216 6.42683C39.2597 7.87957 40.0978 9.38819 40.88 10.8409L40.7124 0.448242H44.6237V16.6519H40.6565L37.6393 11.5114C37.1364 10.7292 36.6336 9.89106 36.1866 9.05294C35.6837 8.21482 35.2926 7.32083 34.7897 6.48271L34.9015 16.7078H30.9902V0.504117L34.9015 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M58.5433 0.448242V3.6331H54.3527V16.6519H50.2738V3.6331H46.0273V0.448242H58.5433Z" fill="black" data-v-d02e5e9c></path><path d="M70.7756 8.93897C70.7197 10.2241 70.3845 11.5092 69.4905 12.5149C68.4848 13.5766 67.1996 13.7442 66.6968 13.7442C65.6351 13.7442 64.6853 13.3531 63.9589 12.5708C63.2884 11.8445 62.6179 10.6711 62.6179 8.4361C62.6179 6.70398 63.1767 4.6925 64.797 3.7985C65.0764 3.63088 65.691 3.3515 66.585 3.3515C66.8644 3.3515 67.479 3.3515 68.1495 3.63088C69.0435 4.022 69.4905 4.58075 69.714 4.86012C70.2169 5.53061 70.8315 6.92748 70.7756 8.93897ZM71.7814 15.4763C73.7928 13.8559 74.8545 11.174 74.8545 8.71547C74.8545 6.48048 73.9605 3.85438 72.396 2.23401C71.5579 1.34002 69.6581 -0.000976562 66.585 -0.000976562C62.8414 -0.000976562 60.9417 2.06639 60.1036 3.29563C58.7067 5.36299 58.5391 7.70973 58.5391 8.54785C58.5391 9.49772 58.6508 12.5708 60.8858 14.9176C62.9532 17.0967 65.6351 17.2643 66.6409 17.2643C69.3229 17.1525 70.8874 16.2027 71.7814 15.4763Z" fill="black" data-v-d02e5e9c></path><path d="M80.7804 0.448242L84.3005 6.42683C85.1386 7.87957 85.9767 9.38819 86.759 10.8409L86.5913 0.448242H90.5026V16.6519H86.5355L83.5182 11.5114C83.0154 10.7292 82.5125 9.89106 82.0655 9.05294C81.5626 8.21482 81.1715 7.32083 80.6686 6.48271L80.7804 16.7078H76.8691V0.504117L80.7804 0.448242Z" fill="black" data-v-d02e5e9c></path><path d="M105.136 0.448242V3.57722H97.2019V6.53858H104.633V9.61169H97.2019V13.467H105.862V16.6519H93.123V0.448242H105.136Z" fill="black" data-v-d02e5e9c></path><path d="M109.269 2.90366V1.95379H109.884C110.108 1.95379 110.387 1.95379 110.499 2.17729C110.555 2.23317 110.555 2.34492 110.555 2.40079C110.555 2.45667 110.555 2.56841 110.499 2.62429C110.387 2.84779 110.219 2.84779 109.772 2.84779H109.269V2.90366ZM111.449 5.2504C111.281 4.91515 111.169 4.46815 111.169 4.3564C111.113 4.07703 111.113 3.68591 110.89 3.46241C110.834 3.40653 110.778 3.35066 110.61 3.29479C110.778 3.23891 110.778 3.23891 110.89 3.18304C111.002 3.12716 111.057 3.07129 111.113 2.95954C111.225 2.84779 111.337 2.68016 111.337 2.34492C111.337 2.23317 111.337 1.95379 111.113 1.67442C110.778 1.2833 110.219 1.2833 109.772 1.2833H108.431V5.19452H109.269V3.51828H109.493C109.772 3.51828 109.884 3.51828 109.996 3.63003C110.163 3.74178 110.219 3.85353 110.275 4.24465C110.331 4.52403 110.331 4.85928 110.443 5.13865C110.443 5.19452 110.499 5.19452 110.499 5.2504H111.449ZM112.901 3.29479C112.901 2.62429 112.734 1.95379 112.287 1.45092C111.672 0.668677 110.778 0.22168 109.828 0.22168C108.543 0.22168 107.761 0.94805 107.426 1.33917C107.202 1.61855 106.699 2.28904 106.699 3.29479C106.699 4.63578 107.481 5.41802 107.873 5.75327C108.431 6.14439 109.102 6.36789 109.772 6.36789C110.219 6.36789 111.281 6.25614 112.119 5.30627C112.845 4.52403 112.901 3.68591 112.901 3.29479ZM112.622 3.29479C112.622 4.46815 111.896 5.52977 110.778 5.92089C110.331 6.08852 109.996 6.08852 109.828 6.08852C108.711 6.08852 107.649 5.41802 107.202 4.3564C107.09 4.02116 106.979 3.68591 106.979 3.29479C106.979 2.00967 107.761 1.2833 108.152 1.00392C108.822 0.501053 109.493 0.445178 109.828 0.445178C111.113 0.445178 111.784 1.17155 112.063 1.56267C112.566 2.28904 112.622 3.01541 112.622 3.29479Z" fill="black" data-v-d02e5e9c></path></svg></div>', 1)), createElement("div", pantoneTipIconClass, [cache[2] || (cache[2] = createElement("svg", {
            xmlns: "http://www.w3.org/2000/svg",
            width: "21",
            height: "20",
            viewBox: "0 0 21 20",
            fill: "none"
          }, [createElement("path", {
            d: "M10.3125 2.5C14.4546 2.5 17.8125 5.85787 17.8125 10C17.8125 14.1421 14.4546 17.5 10.3125 17.5C6.17036 17.5 2.8125 14.1421 2.8125 10C2.8125 5.85787 6.17036 2.5 10.3125 2.5Z",
            stroke: "#222222",
            "stroke-width": "1.15625",
            "stroke-miterlimit": "10"
          }), createElement("path", {
            d: "M10.3125 13.75V9.375",
            stroke: "#222222",
            "stroke-width": "1.41063",
            "stroke-linecap": "round",
            "stroke-linejoin": "round"
          }), createElement("path", {
            d: "M10.3125 5.625C10.8303 5.625 11.25 6.04473 11.25 6.5625C11.25 7.08027 10.8303 7.5 10.3125 7.5C9.79473 7.5 9.375 7.08027 9.375 6.5625C9.375 6.04473 9.79473 5.625 10.3125 5.625Z",
            fill: "#222222"
          })], -1)), createElement("div", pantoneTooltipClass, [createElement("p", pantoneTipTextClass, toDisplayString(unref(translate)("팬톤검색안내")), 1)])])]), createElement("span", pantoneSelectedTextClass, toDisplayString(displayedColor.value ? displayedColor.value.pantone_name.replace("PANTONE ", "") : "PANTONE#"), 1)])]), createElement("div", pantoneSearchClass, [createElement("form", {
            onSubmit: withModifiers(handleSearch, ["prevent"])
          }, [withDirectives(createElement("input", {
            "onUpdate:modelValue": cache[1] || (cache[1] = newVal => searchQuery.value = newVal),
            type: "text",
            name: "pantone",
            placeholder: unref(translate)("넘버 입력"),
            "data-gtm-form-interact-field-id": "0"
          }, null, 8, pantoneSearchPlaceholderAttrs), [
            [vModelText, searchQuery.value]
          ]), cache[4] || (cache[4] = createElement("button", {
            type: "submit",
            class: "search-btn"
          }, null, -1))], 32), createElement("p", pantoneNoticeClass, toDisplayString(unref(translate)("팬톤검색문구")), 1)]), createElement("button", {
            type: "button",
            class: "confirm-btn",
            disabled: !displayedColor.value,
            onClick: handleConfirm
          }, toDisplayString(unref(translate)("적용하기")), 9, pantoneConfirmBtnAttrs)])])])])
        }
      }
    }), [
      ["__scopeId", "data-v-d02e5e9c"]
    ]),

/* =========================================================================
 * 섹션 7: 의류(Apparel) — 인쇄 컬러(팬톤) 컴포넌트
 * 실크인쇄 시 팬톤 컬러를 선택하는 필드셋. 팬톤 모달을 호출.
 * ========================================================================= */
    printColorSpecialClass = {
      class: "special-option"
    },
    printColorImgAttrs = ["src"],
    printColorTextClass = {
      class: "text"
    },
    printColorDescClass = {
      class: "desc"
    },
    printColorDetailClass = {
      class: "detail"
    },
    printColorSubjectClass = {
      class: "detail-subject"
    },
    printColorValueClass = {
      class: "detail-value"
    },
    ApparelPrintColor = defineComponent({
      __name: "ApparelPrintColor",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          callbacks = inject("callbacks", {}),
          deviceType = inject("deviceType", "pc"),
          editorStore = useExteriorStore(),
          isPantoneModalOpen = ref(!1),
          togglePantoneModal = () => isPantoneModalOpen.value = !isPantoneModalOpen.value,
          selectedPantone = ref(null),
          /* 팬톤 컬러 선택 핸들러 */
          handlePantoneSelect = colorData => {
            selectedPantone.value = colorData, deviceType === "pc" && !callbacks.onSetPantone && togglePantoneModal()
          },
          /* 팬톤 선택 버튼 클릭 핸들러 — 외부 콜백 또는 모달 열기 */
          handleOpenPantoneSelector = () => {
            callbacks.onSetPantone ? callbacks.onSetPantone({
              options: [...componentProps.options],
              setter: handlePantoneSelect
            }) : togglePantoneModal()
          },
          /* 인쇄 컬러 리셋 핸들러 */
          handlePrintColorReset = () => {
            callbacks?.onReset && callbacks.onReset("printColor")
          };
        /* 팬톤 선택 변경 시 부모에 업데이트 전달 */
        return watch(() => selectedPantone.value, pantoneData => {
          if (!pantoneData) return;
          editorStore.isAfterEdit() && handlePrintColorReset();
          const {
            pantone_name: pantoneName
          } = pantoneData, pantoneCode = pantoneName.replace("PANTONE ", "");
          emitFn("update", {
            ...pantoneData,
            pantone_code: pantoneCode
          })
        }), (instance, cache) => (openBlock(), createElementVNode(Fragment, null, [renderComponent(OptionRow, {
          title: "인쇄 컬러(팬톤)"
        }, {
          default: withCtx(() => [createElement("div", printColorSpecialClass, [createElement("figure", null, [createElement("img", {
            src: `${unref(CDN_BASE_URL)}/ko/item/page-order-clothes-pantone.png`,
            alt: "팬톤 컬러 이미지"
          }, null, 8, printColorImgAttrs), createElement("p", printColorTextClass, toDisplayString(unref(translate)("팬톤 컬러")), 1)]), createElement("div", printColorDescClass, [createElement("div", printColorDetailClass, [createElement("p", printColorSubjectClass, toDisplayString(unref(translate)("1종 선택 가능")), 1), createElement("span", printColorValueClass, toDisplayString(selectedPantone.value?.pantone_name || "PANTONE"), 1)]), createElement("button", {
            type: "button",
            onClick: handleOpenPantoneSelector
          }, toDisplayString(unref(translate)("팬톤 컬러 선택하기")), 1)])])]),
          _: 1
        }), isPantoneModalOpen.value ? (openBlock(), createVNode(PantoneChipModal, {
          key: 0,
          options: instance.options,
          selected: selectedPantone.value,
          onClose: togglePantoneModal,
          onSelect: handlePantoneSelect
        }, null, 8, ["options", "selected"])) : createCommentVNode("", !0)], 64))
      }
    }),

/* =========================================================================
 * 섹션 8: 개별 포장 (PAK_POL_Simple) 컴포넌트
 * 의류 상품의 개별 포장 여부(선택안함/선택함) 라디오 UI.
 * ========================================================================= */
    PAK_POL_Simple = defineComponent({
      __name: "PAK_POL_Simple",
      props: {
        detail: {}
      },
      emits: ["update"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          packagingSelection = ref("N");
        /* 포장 선택 변경 시 후가공 데이터 구조로 변환하여 부모 전달 */
        return watch(() => packagingSelection.value, newValue => {
          const {
            PCS_CD: processCode,
            PCS_GRP_NM: processGroupName,
            PCS_DTL_CD: processDetailCode,
            PCS_DTL_NM: processDetailName,
            VIEW_YN: viewYn,
            ESN_YN: essentialYn
          } = componentProps.detail;
          emitFn("update", newValue === "Y" ? [{
            PCS_CD: processCode,
            PCS_GRP_NM: processGroupName,
            VIEW_YN: viewYn,
            ESN_YN: essentialYn,
            selectedOptions: [{
              PCS_CD: processCode,
              PCS_DTL_CD: processDetailCode,
              PCS_DTL_NM: processDetailName
            }]
          }] : [])
        }, {
          immediate: !0
        }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
          title: "개별 포장"
        }, {
          default: withCtx(() => [renderComponent(RadioList, {
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
            "default-checked": packagingSelection.value,
            onChange: cache[0] || (cache[0] = selectedOpt => packagingSelection.value = selectedOpt.value)
          }, null, 8, ["default-checked"])]),
          _: 1
        }))
      }
    }),
    /* 모듈 내보내기: PAK_POL_Simple */
    PAK_POL_SimpleModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: PAK_POL_Simple
    }, Symbol.toStringTag, {
      value: "Module"
    })),

/* =========================================================================
 * 섹션 9: 의류(Apparel) 메인 컴포넌트
 * 의류 주문의 전체 구성을 관장하는 최상위 컴포넌트.
 * 인쇄유형 → 컬러 → 사이즈 → 인쇄영역 → 팬톤 → 건명 → 포장 → 업로드 순서 렌더링.
 * ========================================================================= */
    /**
     * 의류 주문 메인 컴포넌트
     * 의류 주문의 전체 구성을 관장하는 최상위 컴포넌트.
     * 인쇄유형 → 컬러 → 사이즈 → 인쇄영역 → 팬톤 → 건명 → 포장 → 업로드 순서로 fieldset 렌더링.
     * @component Apparel
     * @props {string} type - 주문 유형 ("new"|"reorder"|"edit")
     * @props {Object} data - 상품 옵션 데이터 (인쇄유형, 사이즈, 컬러 등)
     * @props {Object} widgetAttr - 위젯 설정 속성 (퀵오더 여부 등)
     * @props {Object} defaultData - 재주문/수정 시 기존 선택값
     * @props {Object} senecaInfo - 세네카 연동 정보 (작업사이즈, 템플릿)
     * @emits {Object} update - 주문 옵션 변경 시 전체 orderData 객체
     */
    ApparelModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
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
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            skinInfo = computed(() => componentProps.widgetAttr.skinInfo),
            memberInfo = inject("member"),
            /* 인쇄 유형 정보 computed */
            printTypeInfo = computed(() => orderInfo.value.clothesSelectData?.printType),
            /* 사이즈 선택 모드: 인쇄 불필요(N)→single, 실크→multi, 기타→single */
            sizeSelectionMode = computed(() => printTypeInfo.value?.PRINT_GBN === "N" ? "single" : printTypeInfo.value?.COD === "PTP_SLK" ? "multi" : "single"),
            {
              uploadConfig: uploadConfig
            } = useUploadConfig(componentProps.widgetAttr),
            {
              orderInfo: orderInfo,
              updateOption: updateOption,
              updatePcsOption: updatePcsOption
            } = useOrderComposable(componentProps.type, {
              group: componentProps.widgetAttr.item_gbn,
              emits: {
                updateOrder: orderData => emitFn("update", orderData)
              }
            }),
            /* 선택된 컬러 코드 */
            selectedColorCode = computed(() => orderInfo.value.clothesSelectData?.colorInfo?.COD),
            /* 사이즈 정보 맵 (COD → info) */
            sizeInfoMap = computed(() => componentProps.data.apparel_info?.size_info.reduce((map, info) => (map[info.COD] = info, map), {})),
            /* 현재 선택된 컬러에 해당하는 사이즈-컬러 목록 */
            filteredSizeColorOptions = computed(() => {
              if (selectedColorCode.value) return componentProps.data.apparel_info?.size_color_info.filter(item => item.CLR_COD === selectedColorCode.value)
            }),
            /* 후가공 상태 reactive */
            postProcessState = reactive({}),
            /* 사이즈 조합 결과 */
            sizeCombinations = ref(null),
            /* 사이즈 조합 → 자재코드 매핑 */
            sizeMaterialMap = computed(() => sizeCombinations.value?.reduce((map, combo) => (map[combo.size.MTRL_COD] = combo, map), {}));
          /* 사이즈 조합 변경 감시 — 자재 정보 업데이트 */
          watch(() => sizeCombinations.value, newCombinations => {
            if (!newCombinations) return;
            updateOption("sizeInfo", !0)(newCombinations);
            const matchedMaterials = componentProps.data.pdt_mtrl_info.filter(mtrl => mtrl.MTRL_CD === newCombinations[0]?.size.MTRL_COD);
            if (matchedMaterials.length > 0) {
              const {
                PTT_CD: paperTypeCode,
                PTT_NM: paperTypeName,
                WGT_CD: weightCode,
                CLR_CD: colorCode,
                MTRL_CD: materialCode,
                MTRL_NM: materialName,
                MTRL_TYPE: materialType,
                PRT_HIDE_YN: printHideYn
              } = matchedMaterials[0];
              updateOption("meterialInfo")({
                PTT_CD: paperTypeCode,
                PTT_NM: paperTypeName,
                WGT_CD: weightCode,
                CLR_CD: colorCode,
                MTRL_CD: materialCode,
                MTRL_NM: materialName,
                MTRL_TYPE: materialType,
                PRT_HIDE_YN: printHideYn
              })
            }
          }), /* 자재 맵 변경 감시 — DIR_MTR 후가공 자동 구성 */
          watch(() => sizeMaterialMap.value, materialMap => {
            if (!materialMap) return;
            const dirMtrOptions = componentProps.data.pdt_pcs_info.filter(pcsInfo => pcsInfo.PCS_CD === "DIR_MTR" && pcsInfo.MTRL_CD && materialMap[pcsInfo.MTRL_CD]).map(pcsInfo => {
              const {
                PCS_CD: processCode,
                PCS_DTL_CD: detailCode,
                PCS_DTL_NM: detailName,
                VIEW_YN: viewYn,
                MTRL_CD: mtrlCode,
                ESN_YN: essentialYn,
                DIV_SEQ: divSeq
              } = pcsInfo, selectedOptions = [{
                PCS_CD: processCode,
                PCS_DTL_CD: detailCode,
                PCS_DTL_NM: detailName,
                ATTB: materialMap[mtrlCode || ""].quantity
              }];
              return {
                PCS_CD: processCode,
                VIEW_YN: viewYn,
                ESN_YN: essentialYn,
                DIV_SEQ: divSeq,
                active: !1,
                selectedOptions: selectedOptions
              }
            });
            postProcessState.DIR_MTR = dirMtrOptions
          });
          const /* 인쇄영역 선택 결과 */
            printAreaSelection = ref(null),
            /* PDT_WRK 후가공 맵 (인쇄영역별) */
            pdtWrkMap = computed(() => componentProps.data.pdt_pcs_info.reduce((map, pcsInfo) => (pcsInfo.PCS_CD === "PDT_WRK" && (map[pcsInfo.PCS_DTL_CD] = pcsInfo), map), {}));
          /* 인쇄영역 변경 감시 — PDT_WRK 후가공 구성 */
          watch(() => printAreaSelection.value, selectedAreas => {
            updateOption("PrintAreaInfo", !0)(selectedAreas);
            const pdtWrkOptions = selectedAreas ? selectedAreas?.map(area => {
              const wrkInfo = pdtWrkMap.value[area.COD],
                {
                  PCS_CD: processCode,
                  PCS_DTL_CD: detailCode,
                  PCS_DTL_NM: detailName,
                  VIEW_YN: viewYn,
                  ESN_YN: essentialYn
                } = wrkInfo,
                selectedOptions = [{
                  PCS_CD: processCode,
                  PCS_DTL_CD: detailCode,
                  PCS_DTL_NM: detailName,
                  KOI_NME: area.KOI_NME
                }];
              return {
                PCS_CD: processCode,
                VIEW_YN: viewYn,
                ESN_YN: essentialYn,
                active: !0,
                selectedOptions: selectedOptions
              }
            }) : [];
            postProcessState.PDT_WRK = pdtWrkOptions
          });
          const /* PAK_POL (개별포장) 후가공 정보 */
            pakPolInfo = computed(() => componentProps.data.pdt_pcs_info.find(info => info.PCS_CD === "PAK_POL"));
          /* 후가공 상태 변경 시 통합 POST_PCS 업데이트 */
          watch(() => postProcessState, newState => {
            updatePcsOption("POST_PCS")(Object.values(newState).flatMap(options => options))
          }, {
            deep: !0
          }), /* 규격 정보 초기 설정 */
          watch(() => componentProps.data.pdt_size_info, sizeInfo => {
            if (!sizeInfo || !sizeInfo[0]) return;
            const sizeData = {
              DIV_NM: sizeInfo[0].DIV_NM || "",
              DIV_SEQ: sizeInfo[0].DIV_SEQ,
              DivInfo: {},
              cutSize: {
                width: +sizeInfo[0].CUT_WDT,
                height: +sizeInfo[0].CUT_HGH
              },
              workSize: {
                width: +sizeInfo[0].WRK_WDT,
                height: +sizeInfo[0].WRK_HGH
              }
            };
            updateOption("sizeInfo")(sizeData)
          }, {
            immediate: !0,
            once: !0
          });
          const apparelCallbacks = inject("callbacks", {}),
            apparelEditorStore = useExteriorStore(),
            /* 파일 업로드 리셋 핸들러 */
            handleFileUploadReset = () => {
              apparelCallbacks?.onReset && apparelCallbacks.onReset("fileUpload")
            };
          /* 인쇄유형 변경 감시 — 인쇄 불필요 시 업로드 초기화 */
          return watch(() => printTypeInfo.value, typeInfo => {
            typeInfo.PRINT_GBN === "N" && (orderInfo.value.fileUploadInfo && orderInfo.value.fileUploadInfo[0] && (updateOption("fileUploadInfo")([null]), handleFileUploadReset()), apparelEditorStore.editorData.default && handleFileUploadReset())
          }), /* 의류 메인 렌더 — 조건부로 하위 컴포넌트 렌더링 */
          (instance, cache) => (openBlock(), createElementVNode(Fragment, null, [instance.data.apparel_info?.print_type ? (openBlock(), createVNode(ApparelPrintType, {
            key: 0,
            options: instance.data.apparel_info?.print_type,
            "dosu-options": instance.data.pdt_dosu_info,
            "related-data": {
              color: selectedColorCode.value
            },
            "onUpdate:type": cache[0] || (cache[0] = typeData => unref(updateOption)("printType", !0)(typeData)),
            "onUpdate:dosu": cache[1] || (cache[1] = dosuData => unref(updateOption)("dosuInfo")(dosuData))
          }, null, 8, ["options", "dosu-options", "related-data"])) : createCommentVNode("", !0), instance.data.apparel_info?.apparel_color ? (openBlock(), createVNode(ApparelColorSelector, {
            key: 1,
            options: instance.data.apparel_info.apparel_color,
            onUpdate: cache[2] || (cache[2] = colorData => unref(updateOption)("colorInfo", !0)(colorData))
          }, null, 8, ["options"])) : createCommentVNode("", !0), filteredSizeColorOptions.value && sizeSelectionMode.value === "single" && sizeInfoMap.value ? (openBlock(), createVNode(ApparelSingleSizeQty, {
            key: 2,
            options: filteredSizeColorOptions.value,
            "size-info": sizeInfoMap.value,
            "onUpdate:qty": cache[3] || (cache[3] = qtyData => unref(updateOption)("quantityInfo")(qtyData)),
            "onUpdate:combinations": cache[4] || (cache[4] = combos => sizeCombinations.value = combos)
          }, null, 8, ["options", "size-info"])) : createCommentVNode("", !0), filteredSizeColorOptions.value && sizeSelectionMode.value === "multi" && sizeInfoMap.value ? (openBlock(), createVNode(ApparelMultiSizeQty, {
            key: 3,
            options: filteredSizeColorOptions.value,
            "size-info": sizeInfoMap.value,
            "onUpdate:qty": cache[5] || (cache[5] = qtyData => unref(updateOption)("quantityInfo")(qtyData)),
            "onUpdate:combinations": cache[6] || (cache[6] = combos => sizeCombinations.value = combos)
          }, null, 8, ["options", "size-info"])) : createCommentVNode("", !0), instance.data.apparel_info?.print_area ? (openBlock(), createVNode(ApparelPrintArea, {
            key: 4,
            options: instance.data.apparel_info.print_area,
            "related-data": {
              printType: printTypeInfo.value
            },
            onUpdate: cache[7] || (cache[7] = areaData => printAreaSelection.value = areaData)
          }, null, 8, ["options", "related-data"])) : createCommentVNode("", !0), instance.data.apparel_info?.pantone_color && unref(orderInfo).clothesSelectData?.printType?.COD === "PTP_SLK" ? (openBlock(), createVNode(ApparelPrintColor, {
            key: 5,
            options: instance.data.apparel_info.pantone_color,
            onUpdate: cache[8] || (cache[8] = pantoneData => unref(updateOption)("pantoneInfo", !0)(pantoneData))
          }, null, 8, ["options"])) : createCommentVNode("", !0), skinInfo.value.subjectGroup.view_yn === "Y" ? (openBlock(), createVNode(SubjectGroup, {
            key: 6,
            "is-biz-mem": unref(memberInfo)?.bsn_yn === "Y",
            onUpdate: cache[9] || (cache[9] = etcData => unref(updateOption)("etcInfo")(etcData))
          }, null, 8, ["is-biz-mem"])) : createCommentVNode("", !0), pakPolInfo.value ? (openBlock(), createVNode(PAK_POL_Simple, {
            key: 7,
            detail: pakPolInfo.value,
            onUpdate: cache[10] || (cache[10] = pakData => postProcessState.PAK_POL = pakData)
          }, null, 8, ["detail"])) : createCommentVNode("", !0), printTypeInfo.value?.PRINT_GBN === "Y" && instance.widgetAttr.order_yn !== "N" ? (openBlock(), createVNode(FileUpload, {
            key: 8,
            "upload-config": unref(uploadConfig),
            "show-extra": instance.widgetAttr.useTemplateDownload === "Y" && instance.widgetAttr.usePDF === "Y",
            "related-data": {
              apparel: {
                printType: printTypeInfo.value?.COD,
                pantone: unref(orderInfo).clothesSelectData.pantoneInfo?.hex_cod
              }
            },
            onUpload: cache[11] || (cache[11] = uploadData => unref(updateOption)("fileUploadInfo")(uploadData))
          }, null, 8, ["upload-config", "show-extra", "related-data"])) : createCommentVNode("", !0)], 64))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }),

/* =========================================================================
 * 섹션 10: 책자(Book) — 수량 컴포넌트
 * 책자 주문의 부수(ordCnt) 또는 내지장수(prnCnt)를 입력하는 UI.
 * 셀렉트/직접입력 토글, 최소수량 안내, 짝수 단위 보정 포함.
 * ========================================================================= */
    bookQtyFlexRowClass = {
      class: "flex-row -center"
    },
    bookQtyInputIdAttrs = ["id"],
    bookQtySelectNameAttrs = ["name"],
    bookQtyOptionValueAttrs = ["value"],
    bookQtyDefaultNotesClass = {
      key: 0,
      class: "notes"
    },
    bookQtyDefaultNoteClass = {
      key: 0,
      class: "note"
    },
    bookQtyTonerNoteClass = {
      key: 1,
      class: "note"
    },
    bookQtyInnerNotesClass = {
      key: 1,
      class: "notes"
    },
    bookQtyInnerNoteClass = {
      class: "note"
    },
    bookQtyMaxNoteClass = {
      class: "note"
    },
    /**
     * 책자 수량 (내지장수 포함) 입력 컴포넌트
     * 책자 수량과 내지 장수를 입력하는 UI. 페이지 배수 제약, 최대수량 제한 표시 포함.
     * @component BookQty
     * @props {string} type - 주문 유형
     * @props {Array} options - 수량 옵션 (페이지 배수, 최소/최대 등)
     * @props {Object} relatedData - 관련 데이터 (용지, 제본방식에 따른 페이지 배수)
     * @emits {Object} update - {qty, innerPages} 수량+내지장수 객체
     */
    BookQty = withScopeId(defineComponent({
      __name: "BookQty",
      props: {
        type: {},
        options: {},
        relatedData: {}
      },
      emits: ["update"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          productCode = inject("productCode", {
            pdtCode: ""
          }),
          /* 토너 책자 여부 (상품코드 5번째 문자가 'O') */
          isTonerBooklet = computed(() => productCode.pdtCode[4] === "O"),
          firstOption = computed(() => componentProps.options[0]),
          /* 증감 단위 */
          incrementStep = computed(() => componentProps.type === "default" ? firstOption.value.INC_CNT : firstOption.value.STEP_INN_PAGE),
          /* 짝수 단위 필수 여부 */
          requiresEvenCount = computed(() => componentProps.type === "default" && firstOption.value.FIR_CNT === 2),
          /* 최소 수량 */
          minQuantity = computed(() => componentProps.type === "default" ? firstOption.value.MIN_PRN_CNT : firstOption.value.MIN_INN_PAGE),
          /* 최대 수량 (내지에만 적용) */
          maxQuantity = computed(() => componentProps.type === "default" ? null : firstOption.value.MAX_INN_PAGE),
          currentQuantity = ref(minQuantity.value),
          /* 유효성 오류 여부 */
          hasValidationError = computed(() => !!(minQuantity.value > currentQuantity.value || maxQuantity.value && maxQuantity.value < currentQuantity.value));
        /* 수량 변경 시 유효하면 부모에 전달 */
        watch(() => currentQuantity.value, newQty => {
          hasValidationError.value || emitFn("update", componentProps.type, newQty)
        }, {
          immediate: !0
        });
        const /* 양면 인쇄 시 실제 페이지 수 계산 */
          actualPageCount = computed(() => {
            const multiplier = componentProps.relatedData?.dosu === "SID_D" ? 2 : 1;
            return (currentQuantity.value * multiplier).toLocaleString()
          }),
          /* 포커스아웃 시 유효성 보정 */
          handleFocusOut = () => {
            if (minQuantity.value > currentQuantity.value) return currentQuantity.value = minQuantity.value;
            if (maxQuantity.value && maxQuantity.value < currentQuantity.value) return currentQuantity.value = maxQuantity.value;
            if (componentProps.type === "default" && requiresEvenCount.value) {
              const remainder = currentQuantity.value % 2;
              if (remainder > 0) return currentQuantity.value = currentQuantity.value + remainder
            }
            if (componentProps.type === "inner" && incrementStep.value === 2) {
              const remainder = currentQuantity.value % 2;
              if (remainder > 0) return currentQuantity.value = currentQuantity.value + remainder
            }
          },
          /* 셀렉트 드롭다운 옵션 생성 */
          selectOptions = computed(() => {
            const options = [],
              startValue = incrementStep.value > minQuantity.value ? incrementStep.value : minQuantity.value,
              maxSteps = incrementStep.value > minQuantity.value ? 10 : 9,
              maxValue = maxQuantity.value ?? incrementStep.value * maxSteps + minQuantity.value;
            for (let qty = startValue; qty <= maxValue; qty += incrementStep.value) qty === incrementStep.value && incrementStep.value > minQuantity.value && options.push({
              value: minQuantity.value
            }), options.push({
              value: qty
            });
            return options
          }),
          /* 수량 입력 모드: select / input */
          qtyInputMode = ref("select"),
          toggleQtyInputMode = () => {
            qtyInputMode.value = qtyInputMode.value === "input" ? "select" : "input"
          };
        /* 렌더 함수 */
        return (instance, cache) => {
          const domPurifyDirective = resolveDirective("dompurify-html");
          return openBlock(), createVNode(OptionRow, {
            title: instance.type === "default" ? unref(translate)("수량") : unref(translate)("내지장수")
          }, {
            default: withCtx(() => [createElement("div", bookQtyFlexRowClass, [qtyInputMode.value === "input" ? withDirectives((openBlock(), createElementVNode("input", {
              key: 0,
              "onUpdate:modelValue": cache[0] || (cache[0] = newVal => currentQuantity.value = newVal),
              type: "number",
              class: normalizeClass(["basic-input", "-fixed-w"]),
              id: instance.type === "default" ? "QTY" : "INNER_QTY",
              onFocusout: handleFocusOut
            }, null, 40, bookQtyInputIdAttrs)), [
              [vModelText, currentQuantity.value]
            ]) : withDirectives((openBlock(), createElementVNode("select", {
              key: 1,
              "onUpdate:modelValue": cache[1] || (cache[1] = newVal => currentQuantity.value = newVal),
              name: instance.type === "default" ? "QTY" : "INNER_QTY",
              class: "basic-select -fixed-w"
            }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(selectOptions.value, opt => (openBlock(), createElementVNode("option", {
              value: opt.value,
              key: opt.value
            }, toDisplayString(opt.value), 9, bookQtyOptionValueAttrs))), 128))], 8, bookQtySelectNameAttrs)), [
              [vModelSelect, currentQuantity.value]
            ]), createElement("button", {
              type: "button",
              class: "action-btn",
              onClick: toggleQtyInputMode
            }, toDisplayString(qtyInputMode.value === "input" ? unref(translate)("수량선택") : unref(translate)("직접입력")), 1)]), instance.type === "default" ? (openBlock(), createElementVNode("div", bookQtyDefaultNotesClass, [isTonerBooklet.value ? withDirectives((openBlock(), createElementVNode("p", bookQtyTonerNoteClass, null, 512)), [
              [domPurifyDirective, unref(translate)(requiresEvenCount.value ? "토너책자최소수량안내-짝수" : "토너책자최소수량안내").replace("{MIN_CNT}", `${minQuantity.value}`)]
            ]) : withDirectives((openBlock(), createElementVNode("p", bookQtyDefaultNoteClass, null, 512)), [
              [domPurifyDirective, unref(translate)("윤전책자최소수량안내").replace("{MIN_CNT}", `${minQuantity.value}`)]
            ])])) : (openBlock(), createElementVNode("div", bookQtyInnerNotesClass, [withDirectives(createElement("p", bookQtyInnerNoteClass, null, 512), [
              [domPurifyDirective, unref(translate)("내지장수안내").replace("{QTY}", `${actualPageCount.value}`)]
            ]), withDirectives(createElement("p", bookQtyMaxNoteClass, null, 512), [
              [domPurifyDirective, unref(translate)("내지최대장수안내").replace("{MAX_CNT}", `${maxQuantity.value}`)]
            ])]))]),
            _: 1
          }, 8, ["title"])
        }
      }
    }), [
      ["__scopeId", "data-v-106e3545"]
    ]),
    BookQtyModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: BookQty
    }, Symbol.toStringTag, {
      value: "Module"
    })),

/* =========================================================================
 * 섹션 11: 인쇄도수(DosuColor) 컴포넌트
 * 도수(단면/양면 등)와 색상(BNC) 조합을 선택하는 UI.
 * 도수 셀렉트 + 컬러 셀렉트 2단 구조.
 * ========================================================================= */
    dosuColorFlexRowClass = {
      class: "flex-row"
    },
    dosuOptionValueAttrs = ["value"],
    dosuColorOptionValueAttrs = ["value"],
    /**
     * 인쇄 도수 + 잉크 색상 선택 컴포넌트
     * 도수(1도/2도/4도 등) 셀렉트 + 잉크 컬러 셀렉트 2단 구조 UI.
     * @component DosuColor
     * @props {Object} options - {dosu: Array, color: Array, all: Array} 도수/색상 옵션
     * @emits {Object} update - {dosu: COD, color: COD} 선택된 도수+색상 코드
     */
    DosuColor = defineComponent({
      __name: "DosuColor",
      props: {
        options: {}
      },
      emits: ["update"],
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          callbacks = inject("callbacks", {}),
          editorStore = useExteriorStore(),
          /* 색상 셀렉트 표시 여부 (all > dosu 이면 별도 색상 선택 필요) */
          showColorSelect = computed(() => componentProps.options.all.length > componentProps.options.dosu.length),
          selectedDosuCode = ref(componentProps.options.dosu[0].COD),
          selectedColorCode = ref(componentProps.options.color[0].COD),
          /* 선택된 도수+색상 조합 찾기 */
          matchedDosuOption = computed(() => componentProps.options.all.find(opt => opt.BNC_GB === selectedColorCode.value && opt.COD === selectedDosuCode.value)),
          /* 도수 리셋 핸들러 */
          handleDosuReset = () => {
            callbacks?.onReset && callbacks.onReset("dosu")
          };
        /* 매칭된 도수 옵션 변경 시 부모 전달 */
        return watch(() => matchedDosuOption.value, matchedOption => {
          matchedOption && (editorStore.isAfterEdit() && handleDosuReset(), emitFn("update", matchedOption))
        }, {
          immediate: !0
        }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
          title: "인쇄도수"
        }, {
          default: withCtx(() => [createElement("div", dosuColorFlexRowClass, [withDirectives(createElement("select", {
            "onUpdate:modelValue": cache[0] || (cache[0] = newVal => selectedDosuCode.value = newVal),
            name: "dosu",
            class: "basic-select"
          }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.options.dosu, dosuOpt => (openBlock(), createElementVNode("option", {
            key: dosuOpt.COD,
            value: dosuOpt.COD
          }, toDisplayString(dosuOpt.COD_NME), 9, dosuOptionValueAttrs))), 128))], 512), [
            [vModelSelect, selectedDosuCode.value]
          ]), showColorSelect.value ? withDirectives((openBlock(), createElementVNode("select", {
            key: 0,
            "onUpdate:modelValue": cache[1] || (cache[1] = newVal => selectedColorCode.value = newVal),
            name: "dosu-color",
            class: "basic-select"
          }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.options.color, colorOpt => (openBlock(), createElementVNode("option", {
            key: colorOpt.COD,
            value: colorOpt.COD
          }, toDisplayString(colorOpt.COD_NME), 9, dosuColorOptionValueAttrs))), 128))], 512)), [
            [vModelSelect, selectedColorCode.value]
          ]) : createCommentVNode("", !0)])]),
          _: 1
        }))
      }
    }),

/* =========================================================================
 * 섹션 12: 용지(Paper) 컴포넌트 — 책자용
 * 용지 종류(PTT) + 평량(WGT) 2단 셀렉트로 자재를 선택하는 UI.
 * 영업주문 전용 자재, 주문불가 자재 표시/비활성화 처리.
 * ========================================================================= */
    paperFlexRowClass = {
      class: "flex-row"
    },
    paperOptionAttrs = ["value", "disabled"],
    weightOptionAttrs = ["value", "disabled"],
    /**
     * 용지 종류 + 평량 선택 컴포넌트
     * 용지 종류(PTT) + 평량(WGT) 2단 셀렉트로 자재를 선택하는 UI.
     * 영업주문 전용 자재, 주문불가 자재 표시/비활성화 처리.
     * @component Paper
     * @props {Array} options - 용지 옵션 목록 (PTT_COD, WGT_COD, 주문불가 플래그 등)
     * @props {boolean} showExtra - 추가 자재 정보 표시 여부 (기본: false)
     * @emits {Object} update - {paper: COD, weight: COD} 선택된 용지+평량 코드
     */
    Paper = defineComponent({
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
      setup(props, {
        emit: emit
      }) {
        const componentProps = props,
          emitFn = emit,
          callbacks = inject("callbacks", {}),
          productCode = inject("productCode", {
            pdtCode: ""
          }),
          configStore = useConfigStore(),
          /* 필터링된 옵션 (현재는 전체 반환) */
          filteredOptions = computed(() => {
            const filtered = [];
            return filtered.length > 0 ? filtered : componentProps.options
          }),
          /* 주문 가능한 옵션만 필터 */
          visibleOptions = computed(() => filteredOptions.value.filter(opt => opt.HIDE_YN !== "Y")),
          /* 용지 종류별 평량 그룹 맵 */
          paperTypeGroupMap = computed(() => {
            const groupMap = new Map;
            return filteredOptions.value.forEach(materialOpt => {
              const {
                WGT_CD: weightCode,
                MTRL_CD: materialCode,
                PTT_CD: paperTypeCode,
                PTT_NM: paperTypeName,
                BSN_YN: businessYn,
                HIDE_YN: hideYn,
                HIDE_RSN: hideReason
              } = materialOpt, existingGroup = groupMap.get(paperTypeCode), weightEntry = {
                WGT_CD: weightCode,
                MTRL_CD: materialCode,
                HIDE_YN: hideYn,
                HIDE_RSN: hideReason
              };
              if (existingGroup) existingGroup.weights.push(weightEntry);
              else {
                const newGroup = {
                  PTT_CD: paperTypeCode,
                  PTT_NM: paperTypeName,
                  BSN_YN: businessYn,
                  weights: [weightEntry]
                };
                groupMap.set(paperTypeCode, newGroup)
              }
            }), groupMap
          }),
          /* 주문 가능 자재 정보 조회 */
          handleShowMaterials = async () => {
            const materialInfo = await fetchMaterialInfo({
              pdt_cod: productCode.pdtCode,
              lang: i18n.locale
            });
            if (!materialInfo) return console.error("[RedWidgetSDK/ERROR] 자재 정보가 없습니다.");
            callbacks?.onInformMaterials ? callbacks.onInformMaterials(materialInfo) : console.log("[RedWidgetSDK] 용지 정보 >", materialInfo)
          }, /* 편집 후 자재 리셋 */
          handleMaterialReset = () => {
            componentProps.resetAfterEdit && callbacks?.onReset && callbacks.onReset("mtrl")
          }, /* 모든 평량이 주문불가인지 체크 */
          isAllWeightsHidden = weights => weights.every(weight => weight.HIDE_YN === "Y"),
          selectedPaperType = ref(componentProps.default?.PTT_CD || visibleOptions.value[0]?.PTT_CD),
          selectedMaterialCode = ref(componentProps.default?.MTRL_CD || visibleOptions.value[0]?.MTRL_CD);
        /* 용지 종류 변경 시 첫 번째 활성 평량으로 자동 선택 */
        return watch(() => selectedPaperType.value, newPaperType => {
          const group = paperTypeGroupMap.value.get(newPaperType);
          if (group) {
            const firstVisibleWeight = group.weights.find(weight => weight.HIDE_YN !== "Y");
            firstVisibleWeight && (selectedMaterialCode.value = firstVisibleWeight.MTRL_CD)
          }
          newPaperType === "OOO" && callbacks?.onSaleOrder && callbacks?.onSaleOrder()
        }, {
          immediate: !0
        }), /* 자재 코드 변경 시 부모에 전체 자재 정보 전달 */
        watch(() => selectedMaterialCode.value, newMtrlCode => {
          const matchedMaterial = visibleOptions.value.find(opt => opt.MTRL_CD === newMtrlCode);
          if (matchedMaterial) {
            const {
              PTT_CD: paperTypeCode,
              PTT_NM: paperTypeName,
              WGT_CD: weightCode,
              CLR_CD: colorCode,
              MTRL_CD: materialCode,
              MTRL_NM: materialName,
              MTRL_TYPE: materialType,
              PRT_HIDE_YN: printHideYn,
              SID_GBN: sideGbn
            } = matchedMaterial;
            emitFn("update", {
              PTT_CD: paperTypeCode,
              PTT_NM: paperTypeName,
              WGT_CD: weightCode,
              CLR_CD: colorCode,
              MTRL_CD: materialCode,
              MTRL_NM: materialName,
              MTRL_TYPE: materialType,
              PRT_HIDE_YN: printHideYn,
              SID_GBN: sideGbn
            })
          }
        }, {
          immediate: !0
        }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
          title: "용지",
          extra: instance.showExtra ? {
            name: "주문가능자재",
            callback: handleShowMaterials
          } : null
        }, {
          default: withCtx(() => [createElement("div", paperFlexRowClass, [withDirectives(createElement("select", {
            "onUpdate:modelValue": cache[0] || (cache[0] = newVal => selectedPaperType.value = newVal),
            class: "basic-select",
            name: "paper"
          }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(paperTypeGroupMap.value.values(), paperGroup => (openBlock(), createElementVNode("option", {
            key: paperGroup.PTT_CD,
            value: paperGroup.PTT_CD,
            disabled: isAllWeightsHidden(paperGroup.weights),
            onChange: handleMaterialReset
          }, toDisplayString(isAllWeightsHidden(paperGroup.weights) ? `[${paperGroup.weights[0].HIDE_RSN||"주문불가"}]` : "") + " " + toDisplayString(paperGroup.PTT_NM) + " " + toDisplayString(paperGroup.BSN_YN === "Y" ? "[영업주문]" : ""), 41, paperOptionAttrs))), 128))], 512), [
            [vModelSelect, selectedPaperType.value]
          ]), withDirectives(createElement("select", {
            "onUpdate:modelValue": cache[1] || (cache[1] = newVal => selectedMaterialCode.value = newVal),
            class: "basic-select",
            name: "weight"
          }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(paperTypeGroupMap.value.get(selectedPaperType.value)?.weights, weightEntry => (openBlock(), createElementVNode("option", {
            key: `${weightEntry.MTRL_CD}`,
            value: weightEntry.MTRL_CD,
            disabled: weightEntry.HIDE_YN === "Y"
          }, toDisplayString(weightEntry.HIDE_YN === "Y" ? `[${weightEntry.HIDE_RSN||"주문불가"}]` : "") + " " + toDisplayString(`${weightEntry.WGT_CD}g`), 9, weightOptionAttrs))), 128))], 512), [
            [vModelSelect, selectedMaterialCode.value]
          ])])]),
          _: 1
        }, 8, ["extra"]))
      }
    }),
    PaperModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: Paper
    }, Symbol.toStringTag, {
      value: "Module"
    })),

/* =========================================================================
 * 섹션 13: 표지 가이드(CoverGuide) 컴포넌트
 * 책자 표지의 작업 사이즈, 세네카 정보, 미리보기 이미지, 템플릿 다운로드를 제공.
 * 상품코드에 따라 무선제본/스프링/소프트커버 이미지를 표시.
 * ========================================================================= */
    coverGuideSpecialClass = {
      class: "special-option"
    },
    coverGuideImgAttrs = ["src"],
    coverGuideTextClass = {
      class: "text"
    },
    coverGuideDescClass = {
      class: "desc"
    },
    coverGuideSenecaDetailClass = {
      key: 0,
      class: "detail"
    },
    coverGuideSenecaSubjectClass = {
      class: "detail-subject"
    },
    coverGuideSenecaValueClass = {
      class: "detail-value"
    },
    coverGuideWorkSizeDetailClass = {
      key: 1,
      class: "detail"
    },
    coverGuideWorkSizeSubjectClass = {
      class: "detail-subject"
    },
    coverGuideWorkSizeValueClass = {
      class: "detail-value"
    },
    /**
     * 표지 가이드 (작업사이즈/템플릿 다운로드) 컴포넌트
     * 책자 표지의 작업 사이즈 정보를 표시하고 템플릿 파일 다운로드를 제공하는 UI.
     * @component CoverGuide
     * @props {Object} sizeInfo - 작업사이즈 정보 (가로, 세로, 재단여백 등)
     * @props {Object} senecaInfo - 세네카 연동 정보 (템플릿 URL, 파라미터)
     */
    CoverGuide = withScopeId(defineComponent({
      __name: "CoverGuide",
      props: {
        sizeInfo: {},
        senecaInfo: {}
      },
      setup(props) {
        const componentProps = props,
          productCode = inject("productCode", {
            pdtCode: ""
          }),
          callbacks = inject("callbacks", {}),
          senecaData = ref(componentProps.senecaInfo);
        /* 세네카 정보 변경 감시 */
        watch(() => componentProps.senecaInfo, newInfo => {
          newInfo && (senecaData.value = newInfo)
        });
        const orderDataStore = useOrderStore(),
          configStore = useConfigStore(),
          /* 템플릿 다운로드 핸들러 */
          handleTemplateDownload = async () => {
            const orderData = orderDataStore.getOrderData();
            if (!orderData) return;
            const templateParams = buildTemplateParams(orderData);
            if (!templateParams || typeof templateParams == "string") return alert(translate(templateParams || "템플릿다운로드실패"));
            await downloadTemplate({
              lang: i18n.locale,
              ...templateParams
            }) || alert(translate("템플릿다운로드실패"))
          },
          /* 흑색 표지 상품코드 맵 */
          blackCoverProducts = {
            PRBKYPB: !0,
            PRBKYCB: !0,
            PRBKYRB: !0,
            PRBKOPB: !0,
            PRBKOCB: !0,
            PRBKORB: !0
          },
          /* 무선제본(세네카) 상품코드 맵 */
          wirelessBindProducts = {
            PRBKYPR: !0,
            PRBKOPR: !0,
            PRBKYPB: !0,
            PRBKOPB: !0
          },
          /* 스프링(낱장커버) 상품코드 맵 */
          springBindProducts = {
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
          /* 소프트커버(중철) 상품코드 맵 */
          softCoverProducts = {
            PRBKYST: !0,
            PRBKYSL: !0,
            PRBKOST: !0,
            PRBKOSL: !0
          },
          /* 표지 가이드 정보 computed — 상품코드에 따라 이미지/타이틀 결정 */
          coverGuideInfo = computed(() => {
            if (!componentProps.sizeInfo) return null;
            if (softCoverProducts[productCode.pdtCode]) return {
              title: "소프트커버",
              imgSrc: `${CDN_BASE_URL}/ko/cover_icon_stapler.png`
            };
            const orientSuffix = componentProps.sizeInfo.workSize.width > componentProps.sizeInfo.workSize.height ? horizontalBindSet.has(productCode.pdtCode) ? "_wh" : "_w" : "_h",
              colorSuffix = blackCoverProducts[productCode.pdtCode] ? "_black" : "";
            return wirelessBindProducts[productCode.pdtCode] ? {
              title: "세네카",
              imgSrc: `${CDN_BASE_URL}/ko/cover_icon_wireless${colorSuffix}${orientSuffix}.png`
            } : springBindProducts[productCode.pdtCode] ? {
              title: "낱장커버",
              imgSrc: `${CDN_BASE_URL}/ko/cover_icon_spring${colorSuffix}${orientSuffix}.png`
            } : null
          });
        /* 렌더 함수 */
        return (instance, cache) => (openBlock(), createVNode(OptionRow, {
          title: "표지가이드",
          extra: {
            name: "가이드보기",
            callback: () => {
              unref(callbacks)?.onInformGuide && unref(callbacks).onInformGuide("bookCover")
            }
          }
        }, {
          default: withCtx(() => [createElement("div", coverGuideSpecialClass, [createElement("figure", null, [createElement("img", {
            src: coverGuideInfo.value?.imgSrc
          }, null, 8, coverGuideImgAttrs), createElement("figcaption", coverGuideTextClass, toDisplayString(unref(translate)(coverGuideInfo.value?.title || "")), 1)]), createElement("div", coverGuideDescClass, [senecaData.value?.seneca_show === "Y" ? (openBlock(), createElementVNode("div", coverGuideSenecaDetailClass, [createElement("p", coverGuideSenecaSubjectClass, toDisplayString(unref(translate)("세네카")), 1), createElement("span", coverGuideSenecaValueClass, [createElement("b", null, toDisplayString(senecaData.value?.seneca), 1), cache[0] || (cache[0] = createTextVNode(" mm ", -1))])])) : (openBlock(), createElementVNode("div", coverGuideWorkSizeDetailClass, [createElement("p", coverGuideWorkSizeSubjectClass, toDisplayString(unref(translate)("표지작업사이즈")), 1), createElement("span", coverGuideWorkSizeValueClass, [createElement("b", null, toDisplayString(instance.sizeInfo?.workSize.width) + "x" + toDisplayString(instance.sizeInfo?.workSize.height), 1), cache[1] || (cache[1] = createTextVNode(" mm ", -1))])])), createElement("button", {
            type: "button",
            class: "download-btn",
            onClick: handleTemplateDownload
          }, toDisplayString(unref(translate)("표지템플릿다운로드")), 1)])])]),
          _: 1
        }, 8, ["extra"]))
      }
    }), [
      ["__scopeId", "data-v-7f08ebe2"]
    ]),

/* =========================================================================
 * 섹션 14: 책자(Book) 메인 컴포넌트
 * 책자 주문의 전체 구성 — 규격→수량→내지(도수/용지/장수/업로드)→표지(도수/용지/가이드/후가공/업로드).
 * group-title 디바이더로 내지/표지 섹션을 구분.
 * ========================================================================= */
    innerGroupTitleClass = {
      class: "group-title"
    },
    innerGroupSubjectClass = {
      class: "subject"
    },
    coverGroupTitleClass = {
      class: "group-title"
    },
    coverGroupSubjectClass = {
      class: "subject"
    },
    /**
     * 책자 주문 메인 컴포넌트
     * 책자 주문의 전체 구성을 관장하는 최상위 컴포넌트.
     * 내지/표지 용지 → 도수+잉크색상 → 수량(내지장수 포함) → 후가공 → 표지가이드 순서로 fieldset 렌더링.
     * @component Book
     * @props {string} type - 주문 유형 ("new"|"reorder"|"edit")
     * @props {Object} data - 상품 옵션 데이터 (용지, 도수, 후가공 등)
     * @props {Object} widgetAttr - 위젯 설정 속성
     * @props {Object} defaultData - 재주문/수정 시 기존 선택값
     * @props {Object} senecaInfo - 세네카 연동 정보 (작업사이즈, 템플릿)
     * @emits {Object} update - 주문 옵션 변경 시 전체 orderData 객체
     */
    BookModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: withScopeId(defineComponent({
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
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            skinInfo = computed(() => componentProps.widgetAttr.skinInfo),
            {
              defaultOrderData: defaultOrderData,
              orderInfo: orderInfo,
              updateOption: updateOption,
              updatePostPcs: updatePostPcs
            } = useOrderComposable(componentProps.type, {
              group: componentProps.widgetAttr.item_gbn,
              emits: {
                updateOrder: orderData => emitFn("update", orderData)
              }
            }),
            /* 스코딕스 후가공 존재 여부 */
            hasScodix = computed(() => !!orderInfo.value.pcsInfo?.find(info => info.PCS_CD === "SCO_DFT")),
            /* 수량 정보: ordCnt(부수) + prnCnt(내지장수) */
            quantityInfo = ref({
              ordCnt: 0,
              prnCnt: 0
            }),
            /* 수량 업데이트 핸들러 — type에 따라 ordCnt 또는 prnCnt 업데이트 */
            handleQuantityUpdate = (qtyType, qtyValue) => {
              qtyType === "default" && (quantityInfo.value = {
                ...quantityInfo.value,
                ordCnt: qtyValue
              }), qtyType === "inner" && (quantityInfo.value = {
                ...quantityInfo.value,
                prnCnt: qtyValue
              })
            };
          /* 수량 변경 디바운스 감시 */
          watch(() => quantityInfo.value, debounce(newQty => {
            updateOption("quantityInfo")(newQty)
          }, 200), {
            immediate: !0
          });
          const memberInfo = inject("member"),
            /* 자재 목록 (영업회원이면 BSN_YN 포함) */
            coverMaterials = computed(() => memberInfo?.bsn_yn === "Y" ? componentProps.data.pdt_mtrl_info : componentProps.data.pdt_mtrl_info.filter(info => info.BSN_YN !== "Y")),
            innerMaterials = computed(() => memberInfo?.bsn_yn === "Y" ? componentProps.data.inner_pdt_mtrl_info : componentProps.data.inner_pdt_mtrl_info?.filter(info => info.BSN_YN !== "Y")),
            /* 제본방향 후가공 정보 */
            bindDirectionInfo = computed(() => orderInfo.value?.pcsInfo?.find(info => info.PCS_CD === "BIND_DIRECTION")),
            {
              uploadConfig: uploadConfig
            } = useUploadConfig(componentProps.widgetAttr),
            /* 흑백 도수 시 에디터 비활성화 */
            coverUploadConfig = computed(() => orderInfo.value.dosuInfo?.BNC_GB === "BNC_BLA" ? {
              pdf: !0,
              editor: null
            } : uploadConfig.value),
            /* 파일 업로드 결과 배열 [내지, 표지] */
            fileUploadResults = ref([]),
            /* 파일 업로드 핸들러 팩토리 — type별로 배열 인덱스에 저장 */
            createUploadHandler = uploadType => uploadData => {
              const fileData = uploadData[0];
              uploadType === "inner" && (fileUploadResults.value = [fileData, fileUploadResults.value[1]]), uploadType === "default" && (fileUploadResults.value = [fileUploadResults.value[0], fileData])
            };
          /* 업로드 결과 변경 시 부모 전달 */
          watch(() => fileUploadResults.value, newResults => {
            updateOption("fileUploadInfo")(newResults)
          });
          const /* 후가공 옵션 파싱 */
            parsedPostProcessOptions = computed(() => parsePostProcessOptions(componentProps.data.pdt_pcs_info, componentProps.data.pdt_disable_pcs_info)),
            /* 주문 수량 계산 (페이지 수 기반) */
            orderQuantityForPostPcs = computed(() => bookPageMultiplierMap[componentProps.data.pdt_base_info[0].PDT_CD] ? orderInfo.value.quantityInfo?.prnCnt || 1 : (orderInfo.value.quantityInfo?.ordCnt || 1) * (orderInfo.value.quantityInfo?.prnCnt || 1));
          /* 렌더 함수 — 책자 전체 구조 */
          return (instance, cache) => (openBlock(), createElementVNode(Fragment, null, [withDirectives(renderComponent(SizeSelect, {
            options: instance.data.pdt_size_info,
            "base-info": instance.data.pdt_base_info[0],
            default: unref(defaultOrderData)?.size,
            "hidden-sizes": !0,
            "show-extra": !0,
            onUpdate: cache[0] || (cache[0] = sizeData => unref(updateOption)("sizeInfo")(sizeData)),
            onValidate: cache[1] || (cache[1] = validData => unref(updateOption)("validation")(validData))
          }, null, 8, ["options", "base-info", "default"]), [
            [vShow, skinInfo.value.sizeSelect.view_yn === "Y"]
          ]),
          /* 수량(부수) 선택 */
          renderComponent(BookQty, {
            type: "default",
            options: instance.data.pdt_prn_cnt_info,
            onUpdate: handleQuantityUpdate
          }, null, 8, ["options"]),
          /* ── 내지 섹션 구분선 ── */
          createElement("div", innerGroupTitleClass, [createElement("span", innerGroupSubjectClass, toDisplayString(unref(translate)("내지")), 1)]),
          /* 내지 인쇄도수 */
          withDirectives(renderComponent(DosuColor, {
            options: {
              dosu: instance.data.inner_pdt_dosu_info,
              color: instance.data.inner_pdt_bnc_info,
              all: instance.data.inner_pdt_dosu_bnc_info
            },
            onUpdate: cache[2] || (cache[2] = dosuData => unref(updateOption)("inner_dosuInfo")(dosuData))
          }, null, 8, ["options"]), [
            [vShow, skinInfo.value.dosuSelect.view_yn === "Y" && instance.data.inner_pdt_dosu_bnc_info]
          ]),
          /* 내지 용지 */
          renderComponent(Paper, {
            options: innerMaterials.value,
            "show-extra": instance.widgetAttr.able_paper_yn === "Y",
            onUpdate: cache[3] || (cache[3] = mtrlData => unref(updateOption)("inner_meterialInfo")(mtrlData))
          }, null, 8, ["options", "show-extra"]),
          /* 내지장수 */
          renderComponent(BookQty, {
            type: "inner",
            options: instance.data.pdt_prn_cnt_info,
            "related-data": {
              dosu: unref(orderInfo).inner_dosuInfo?.COD
            },
            onUpdate: handleQuantityUpdate
          }, null, 8, ["options", "related-data"]),
          /* 내지 업로드 */
          instance.widgetAttr.order_yn !== "N" ? (openBlock(), createVNode(FileUpload, {
            key: 0,
            _key: "inner",
            "upload-config": {
              pdf: !0,
              editor: null
            },
            subject: "내지업로드",
            notes: [unref(translate)("내지업로드사이즈장수안내", {
              CUT_SIZE: `${unref(orderInfo).sizeInfo?.cutSize.width}x${unref(orderInfo).sizeInfo?.cutSize.height}`,
              WRK_SIZE: `${unref(orderInfo).sizeInfo?.workSize.width}x${unref(orderInfo).sizeInfo?.workSize.height}`,
              QTY: `${unref(orderInfo).quantityInfo?.prnCnt*(unref(orderInfo).inner_dosuInfo?.COD==="SID_D"?2:1)}`
            })],
            onUpload: cache[4] || (cache[4] = uploadData => createUploadHandler("inner")(uploadData))
          }, null, 8, ["notes"])) : createCommentVNode("", !0),
          /* ── 표지 섹션 구분선 ── */
          createElement("div", coverGroupTitleClass, [createElement("span", coverGroupSubjectClass, toDisplayString(unref(translate)("표지")), 1)]),
          /* 표지 인쇄도수 */
          withDirectives(renderComponent(DosuColor, {
            options: {
              dosu: instance.data.pdt_dosu_info,
              color: instance.data.pdt_bnc_info,
              all: instance.data.pdt_dosu_bnc_info
            },
            onUpdate: cache[5] || (cache[5] = dosuData => unref(updateOption)("dosuInfo")(dosuData))
          }, null, 8, ["options"]), [
            [vShow, skinInfo.value.dosuSelect.view_yn === "Y" && instance.data.pdt_dosu_info]
          ]),
          /* 표지 용지 (단일 자재이면 숨김) */
          withDirectives(renderComponent(Paper, {
            options: coverMaterials.value,
            "show-extra": instance.widgetAttr.able_paper_yn === "Y",
            onUpdate: cache[6] || (cache[6] = mtrlData => unref(updateOption)("meterialInfo")(mtrlData))
          }, null, 8, ["options", "show-extra"]), [
            [vShow, coverMaterials.value.length > 1]
          ]),
          /* 표지 가이드 — 미리보기 이미지 + 템플릿 다운로드 */
          renderComponent(CoverGuide, {
            "size-info": unref(orderInfo).sizeInfo,
            "seneca-info": instance.senecaInfo
          }, null, 8, ["size-info", "seneca-info"]),
          /* 숨김 후가공 (자동 적용) */
          renderComponent(HiddenPostProcess, {
            options: parsedPostProcessOptions.value.postPcs.hidden,
            "related-data": {
              mtrlCd: unref(orderInfo).meterialInfo?.MTRL_CD,
              sizeInfo: unref(orderInfo).sizeInfo,
              orderQty: orderQuantityForPostPcs.value,
              bindDirection: bindDirectionInfo.value
            },
            onUpdate: cache[7] || (cache[7] = pcsData => unref(updatePostPcs)("hidden")(pcsData))
          }, null, 8, ["options", "related-data"]),
          /* 표시 후가공 — 아이콘 체크박스/라디오 */
          renderComponent(VisiblePostProcess, {
            options: parsedPostProcessOptions.value.postPcs.visible,
            "disabled-opts": parsedPostProcessOptions.value.disabled,
            "attb-opts": instance.data.pdt_add_info[1],
            "related-data": {
              mtrlCd: unref(orderInfo).meterialInfo?.MTRL_CD,
              sizeInfo: unref(orderInfo).sizeInfo
            },
            onUpdate: cache[8] || (cache[8] = pcsData => unref(updatePostPcs)("visible")(pcsData))
          }, null, 8, ["options", "disabled-opts", "attb-opts", "related-data"]),
          /* 표지 업로드 */
          instance.widgetAttr.order_yn !== "N" ? (openBlock(), createVNode(FileUpload, {
            key: 1,
            _key: "default",
            "upload-config": coverUploadConfig.value,
            subject: "표지업로드",
            notes: [unref(translate)("표지업로드장수안내", {
              QTY: `${unref(orderInfo).dosuInfo?.COD==="SID_D"?2:1}`
            })],
            "related-data": {
              hasScodix: hasScodix.value
            },
            onUpload: cache[9] || (cache[9] = uploadData => createUploadHandler("default")(uploadData))
          }, null, 8, ["upload-config", "notes", "related-data"])) : createCommentVNode("", !0)], 64))
        }
      }), [
        ["__scopeId", "data-v-51f6d81b"]
      ])
    }, Symbol.toStringTag, {
      value: "Module"
    }),

/* =========================================================================
 * 섹션 15: 부자재(Acc) 메인 컴포넌트
 * 부자재 옵션 선택(캐스케이드/멀티/단일), 수량 조절(+/- 버튼), 가격 표시.
 * 선택한 부자재 항목의 요약 리스트와 삭제 기능 포함.
 * ========================================================================= */
    /* 부자재 요약 영역 CSS 클래스들 */
    accSummaryClass = {
      key: 2,
      class: "summary"
    },
    accItemNameClass = {
      class: "name"
    },
    accQtyPriceClass = {
      class: "qty-price"
    },
    accCounterClass = {
      class: "counter"
    },
    accDecreaseBtnAttrs = ["onClick"],
    accQtyInputAttrs = ["value", "onChange"],
    accIncreaseBtnAttrs = ["onClick"],
    accPriceBoxClass = {
      class: "price-box"
    },
    accPriceClass = {
      class: "price"
    },
    accDeleteBtnAttrs = ["onClick"],
    accSkeletonClass = {
      key: 1
    },
    accSkeletonQtyPriceClass = {
      class: "qty-price"
    },
    accSkeletonPriceBoxClass = {
      class: "price-box"
    },
    /**
     * 부자재 주문 메인 컴포넌트
     * 부자재(액세서리) 주문의 전체 구성을 관장하는 최상위 컴포넌트.
     * 필터(자재그룹/서브그룹) → 옵션 선택 → 수량 → 가격 표시 순서로 fieldset 렌더링.
     * @component Acc
     * @props {string} type - 주문 유형 ("new"|"reorder"|"edit")
     * @props {Object} data - 부자재 옵션 데이터 (필터 설정, 자재 목록 등)
     * @emits {Object} update - 주문 옵션 변경 시 전체 orderData 객체
     */
    AccModule = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: withScopeId(defineComponent({
        __name: "Acc",
        props: {
          type: {
            default: "new"
          },
          data: {}
        },
        emits: ["update"],
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            productCode = inject("productCode", {
              pdtCode: ""
            }),
            callbacks = inject("callbacks", {}),
            /* 부자재 필터 설정 (상품별 UI 유형) */
            accFilterConfig = computed(() => accFilterConfigMap[productCode.pdtCode] ? accFilterConfigMap[productCode.pdtCode][productCode.pttCode || ""] : null),
            /* 1단계 선택값 */
            primarySelection = ref("X"),
            /* 2단계(서브그룹) 선택값 */
            secondarySelection = ref("X"),
            /* 3단계(자재) 선택값 */
            tertiarySelection = ref("X"),
            /* 멀티 그룹 선택값 reactive */
            multiGroupSelections = reactive({}),
            /* 선택된 부자재 항목들 reactive (MTRL_CD → 항목 데이터) */
            selectedItems = reactive({});
          /* 1단계 변경 시 3단계 초기화 */
          watch(() => primarySelection.value, () => {
            tertiarySelection.value = "X"
          });
          const defaultSelectOption = {
              key: "X",
              value: "X",
              name: translate("선택하기")
            },
            /* 전체 초기화 핸들러 */
            resetAllSelections = () => {
              primarySelection.value = "X", secondarySelection.value = "X", tertiarySelection.value = "X"
            },
            /* 자재 그룹별 맵 */
            materialGroupMap = computed(() => componentProps.data.reduce((groupMap, material) => (groupMap[material.MTRL_GRP_GB] || (groupMap[material.MTRL_GRP_GB] = []), groupMap[material.MTRL_GRP_GB].push(material), groupMap), {})),
            /* 셀렉트 옵션 빌더 — 필터 설정에 따라 옵션 목록 생성 */
            buildSelectOptions = filterDef => {
              const options = [defaultSelectOption];
              return filterDef ? filterDef.GRP_TYPE === "MTRL_MULTI_GRP" ? (materialGroupMap.value[filterDef.GRP_COD].forEach(material => {
                options.push({
                  key: material.MTRL_CD,
                  value: material.MTRL_CD,
                  name: material.MTRL_NM,
                  disabled: material.HIDE_YN === "Y"
                })
              }), options) : filterDef.options ? (filterDef.options.forEach(opt => {
                options.push({
                  key: opt.COD,
                  value: opt.COD,
                  name: translate(opt.COD_NME)
                })
              }), options) : (primarySelection.value !== "X" && materialGroupMap.value[primarySelection.value].forEach(material => {
                options.push({
                  key: material.MTRL_CD,
                  value: material.MTRL_CD,
                  name: material.MTRL_NM,
                  disabled: material.HIDE_YN === "Y"
                })
              }), options) : (componentProps.data.forEach(material => {
                options.push({
                  key: material.MTRL_CD,
                  value: material.MTRL_CD,
                  name: material.MTRL_NM,
                  disabled: material.HIDE_YN === "Y"
                })
              }), options)
            };

          /* 경고 메시지 표시 */
          function showWarning(message) {
            return callbacks?.onCallMsg ? callbacks.onCallMsg("warn", message) : alert(message)
          }

          /* 항목 추가 (이미 있으면 수량 증가) */
          function addItem(material) {
            material && (selectedItems[material.MTRL_CD] ? selectedItems[material.MTRL_CD].QTY += material.INC_STEP : selectedItems[material.MTRL_CD] = {
              ...material,
              QTY: material.FIR_CNT
            })
          }

          /* 수량 감소 (최소 수량 이하로는 감소 불가) */
          function decreaseItemQty(material) {
            selectedItems[material.MTRL_CD].QTY !== material.FIR_CNT && (selectedItems[material.MTRL_CD].QTY -= material.INC_STEP)
          }

          /* 수량 직접 입력 핸들러 — 유효성 보정 */
          function handleQtyInput(event, material) {
            let newQty = +event.target.value || material.FIR_CNT;
            if (newQty < material.FIR_CNT && (newQty = material.FIR_CNT), material.RMD_QTY > 0 && newQty > material.RMD_QTY && (newQty = material.RMD_QTY), material.INC_STEP !== 1) {
              const remainder = newQty % material.INC_STEP;
              remainder !== 0 && (newQty = newQty - remainder)
            }
            selectedItems[material.MTRL_CD] = {
              ...selectedItems[material.MTRL_CD],
              QTY: newQty
            }
          }

          /* 옵션 선택 (추가) 버튼 핸들러 */
          function handleAddOption() {
            if (!accFilterConfig.value) {
              if (tertiarySelection.value === "X") return showWarning(translate("옵션미선택안내"));
              const material = componentProps.data.find(item => item.MTRL_CD === tertiarySelection.value);
              return addItem(material), tertiarySelection.value = "X"
            }
            if (accFilterConfig.value.uiType === "MULTI") return isEmpty(multiGroupSelections) || Object.values(multiGroupSelections).every(val => val === "X") ? showWarning(translate("옵션미선택안내")) : (Object.entries(multiGroupSelections).forEach(([groupKey, mtrlCd]) => {
              const material = materialGroupMap.value[groupKey].find(item => item.MTRL_CD === mtrlCd);
              addItem(material)
            }), Object.keys(multiGroupSelections).forEach(key => delete multiGroupSelections[key]));
            if (accFilterConfig.value.uiType === "CASCADE") {
              const primaryFilter = accFilterConfig.value.filters[0],
                subGroupFilter = accFilterConfig.value.filters.find(filter => filter.GRP_TYPE === "MTRL_SUB_GRP");
              if (primarySelection.value === "X") return showWarning(translate("옵션미선택안내상세", {
                OPTION: translate(primaryFilter.GRP_NME)
              }));
              if (!subGroupFilter) return;
              if (subGroupFilter.options) {
                if (secondarySelection.value === "X") return showWarning(translate("옵션미선택안내상세", {
                  OPTION: translate(subGroupFilter.GRP_NME)
                }));
                const matchedMaterial = materialGroupMap.value[primarySelection.value].find(item => {
                  if (item.MTRL_NM.includes(translate(secondarySelection.value))) return !0;
                  if (secondarySelection.value === "NONE") return !0
                });
                return addItem(matchedMaterial), resetAllSelections()
              }
              if (tertiarySelection.value === "X") return showWarning(translate("옵션미선택안내상세", {
                OPTION: translate(subGroupFilter.GRP_NME)
              }));
              const selectedMaterial = materialGroupMap.value[primarySelection.value].find(item => item.MTRL_CD === tertiarySelection.value);
              return addItem(selectedMaterial), resetAllSelections()
            }
          }

          /* 항목 삭제 */
          function removeItem(material) {
            delete selectedItems[material.MTRL_CD]
          }
          /* 선택 항목 변경 시 부모에 업데이트 */
          watch(() => selectedItems, newItems => {
            const itemList = Object.values(newItems).map(item => ({
              MTRL_CD: item.MTRL_CD,
              QTY: item.QTY,
              ATTB: "",
              MTRL_NME: item.MTRL_NM
            }));
            emitFn("update", itemList)
          }, {
            deep: !0
          });
          const orderStore = useAccOrderStore(),
            /* 가격 계산 결과에서 항목별 가격 추출 */
            itemPriceMap = computed(() => orderStore.getOrderData()?.priceCalc.result.result?.reduce((priceMap, priceItem) => (priceMap[priceItem.MTRL_CD] = +priceItem.PRICE_MALL !== priceItem.PRICE ? +priceItem.PRICE_MALL : priceItem.PRICE, priceMap), {})),
            /* 가격 애니메이션용 reactive 객체 */
            animatedPrices = reactive(itemPriceMap.value || {});

          /* 가격 애니메이션 함수 — requestAnimationFrame으로 부드러운 숫자 전환 */
          function animatePrice(mtrlCd, fromPrice, toPrice) {
            const startTime = performance.now(),
              animate = currentTime => {
                const progress = Math.min((currentTime - startTime) / 300, 1),
                  currentPrice = Math.floor(fromPrice + (toPrice - fromPrice) * progress);
                animatedPrices[mtrlCd] = currentPrice, progress < 1 && requestAnimationFrame(animate)
              };
            requestAnimationFrame(animate)
          }
          /* 가격 변경 감시 — 애니메이션 적용 */
          return watch(() => itemPriceMap.value, (newPrices, oldPrices = {}) => {
            newPrices && Object.keys(newPrices).forEach(mtrlCd => {
              const oldPrice = oldPrices[mtrlCd] || 0,
                newPrice = newPrices[mtrlCd] || 0;
              animatePrice(mtrlCd, oldPrice, newPrice)
            })
          }, {
            deep: !0
          }), /* 렌더 함수 — 필터 셀렉트 + 추가 버튼 + 요약 리스트 */
          (instance, cache) => (openBlock(), createElementVNode(Fragment, null, [accFilterConfig.value ? (openBlock(!0), createElementVNode(Fragment, {
            key: 0
          }, renderList(accFilterConfig.value.filters, filterDef => (openBlock(), createVNode(OptionRow, {
            key: filterDef.GRP_NME,
            title: `${unref(translate)("옵션")} - ${unref(translate)(filterDef.GRP_NME)}`
          }, {
            default: withCtx(() => [filterDef.GRP_TYPE === "MTRL_MULTI_GRP" ? (openBlock(), createVNode(Selector, {
              key: 0,
              name: filterDef.GRP_COD,
              default: multiGroupSelections[filterDef.GRP_COD] || "X",
              options: buildSelectOptions(filterDef),
              onSelect: selectedVal => multiGroupSelections[filterDef.GRP_COD] = selectedVal
            }, null, 8, ["name", "default", "options", "onSelect"])) : filterDef.GRP_TYPE === "MTRL_GRP" ? (openBlock(), createVNode(Selector, {
              key: 1,
              name: "material-group",
              options: buildSelectOptions(filterDef),
              default: primarySelection.value,
              onSelect: cache[0] || (cache[0] = selectedVal => primarySelection.value = selectedVal)
            }, null, 8, ["options", "default"])) : filterDef.GRP_TYPE === "MTRL_SUB_GRP" && filterDef.options ? (openBlock(), createVNode(Selector, {
              key: 2,
              name: "material-sub-group",
              options: buildSelectOptions(filterDef),
              default: secondarySelection.value,
              onSelect: cache[1] || (cache[1] = selectedVal => secondarySelection.value = selectedVal)
            }, null, 8, ["options", "default"])) : (openBlock(), createVNode(Selector, {
              key: 3,
              name: "material",
              options: buildSelectOptions(filterDef),
              default: tertiarySelection.value,
              onSelect: cache[2] || (cache[2] = selectedVal => tertiarySelection.value = selectedVal)
            }, null, 8, ["options", "default"]))]),
            _: 2
          }, 1032, ["title"]))), 128)) : (openBlock(), createVNode(OptionRow, {
            key: 1,
            title: unref(translate)("옵션")
          }, {
            default: withCtx(() => [renderComponent(Selector, {
              name: "material",
              options: buildSelectOptions(),
              default: tertiarySelection.value,
              onSelect: cache[3] || (cache[3] = selectedVal => tertiarySelection.value = selectedVal)
            }, null, 8, ["options", "default"])]),
            _: 1
          }, 8, ["title"])),
          /* 옵션 추가 버튼 */
          createElement("button", {
            type: "button",
            class: "add-btn",
            onClick: handleAddOption
          }, "+ " + toDisplayString(unref(translate)("옵션선택")), 1),
          /* 선택된 부자재 요약 리스트 */
          unref(isEmpty)(selectedItems) ? createCommentVNode("", !0) : (openBlock(), createElementVNode("div", accSummaryClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(Object.values(selectedItems), item => (openBlock(), createElementVNode("div", {
            key: item.MTRL_CD
          }, [itemPriceMap.value && itemPriceMap.value[item.MTRL_CD] ? (openBlock(), createElementVNode(Fragment, {
            key: 0
          }, [createElement("p", accItemNameClass, toDisplayString(item.MTRL_NM), 1), createElement("div", accQtyPriceClass, [createElement("div", accCounterClass, [createElement("button", {
            type: "button",
            class: "btn minus",
            onClick: clickEvent => decreaseItemQty(item)
          }, "-", 8, accDecreaseBtnAttrs), createElement("input", {
            class: "qty",
            value: item.QTY,
            name: "qty",
            onChange: changeEvent => handleQtyInput(changeEvent, item),
            type: "number"
          }, null, 40, accQtyInputAttrs), createElement("button", {
            type: "button",
            class: "btn plus",
            onClick: clickEvent => addItem(item)
          }, "+", 8, accIncreaseBtnAttrs)]), createElement("div", accPriceBoxClass, [createElement("span", accPriceClass, toDisplayString(animatedPrices[item.MTRL_CD]?.toLocaleString()), 1), createElement("button", {
            type: "button",
            class: "delete-btn",
            onClick: clickEvent => removeItem(item)
          }, "X", 8, accDeleteBtnAttrs)])])], 64)) : (openBlock(), createElementVNode("div", accSkeletonClass, [renderComponent(Skeleton, {
            variant: "rounded",
            width: 110,
            height: 16
          }), createElement("div", accSkeletonQtyPriceClass, [renderComponent(Skeleton, {
            variant: "rounded",
            width: 106,
            height: 28
          }), createElement("div", accSkeletonPriceBoxClass, [renderComponent(Skeleton, {
            variant: "rounded",
            width: 50,
            height: 17
          }), renderComponent(Skeleton, {
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
    }),

/* =========================================================================
 * 섹션 16~28: 후가공(PostProcess) 개별 컴포넌트들
 * 각 후가공 유형별 UI 컴포넌트 — 아이콘 체크박스/라디오/셀렉트 형태.
 * PCS_CD 코드로 구분: ADC_PVC, BID_SIL, BIND_DIRECTION, BON_PAP, BON_SHT,
 * CLD_STD, COT_DFT, COT_SEG, CVR_INN, CVR_SWN, DIR_MTR, END_PAP,
 * INN_DFT, INS_COT, LAB_FBR, PAK_ETC, PAK_POL, PDT_WRK, PRT_IPK,
 * PRT_WHT, PRT_WHT_FACE, RIN_DFT, ROU_DFT, SCO_DFT, SUB_MTR_BC, WRK_MTR
 * ========================================================================= */

    /* --- ADC_PVC: PVC 커버 후가공 --- */
    adcPvcFlexRowClass = {
      class: "flex-row"
    },
    adcPvcNotesClass = {
      class: "notes"
    },
    adcPvcNoteClass = {
      class: "note"
    },
    ADC_PVC_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "ADC_PVC",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            selectedValue = ref(componentProps.data.options[0].value),
            handleSelect = selectedItem => {
              selectedValue.value = selectedItem.value
            };
          /* 선택 변경 시 후가공 데이터 구조로 부모 전달 */
          return watch(() => selectedValue.value, newValue => {
            emitFn("update", [{
              PCS_CD: componentProps.data.value,
              PCS_DTL_CD: newValue,
              PCS_DTL_NM: componentProps.data.name
            }])
          }, {
            immediate: !0
          }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
            title: instance.data.name,
            underline: ""
          }, {
            default: withCtx(() => [createElement("div", adcPvcFlexRowClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.options, optionItem => (openBlock(), createVNode(ImageButton, {
              key: optionItem.key,
              data: {
                value: optionItem.value,
                name: optionItem.name,
                imgPath: `${instance.data.subImgPath}_${optionItem.value}`
              },
              active: selectedValue.value === optionItem.value,
              onSelect: handleSelect
            }, null, 8, ["data", "active"]))), 128))]), createElement("div", adcPvcNotesClass, [createElement("p", adcPvcNoteClass, toDisplayString(instance.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }),

    /* --- BID_SIL: 실크 인쇄 후가공 (속성값 선택 포함) --- */
    bidSilFlexRowClass = {
      class: "flex-row -flow"
    },
    BID_SIL_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "BID_SIL",
        props: {
          data: {}
        },
        emits: ["update"],
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            selectedAttbValue = ref(componentProps.data.attbOptions[0].value),
            selectedAttbName = ref(componentProps.data.attbOptions[0].name),
            handleAttbSelect = selectedItem => {
              selectedAttbValue.value = selectedItem.value, selectedAttbName.value = selectedItem.name
            };
          return watch(() => selectedAttbValue.value, newValue => {
            emitFn("update", [{
              PCS_CD: componentProps.data.value,
              PCS_DTL_CD: componentProps.data.options[0].value,
              PCS_DTL_NM: `${componentProps.data.name}(${selectedAttbName.value})`,
              ATTB: newValue
            }])
          }, {
            immediate: !0
          }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
            title: instance.data.name,
            underline: ""
          }, {
            default: withCtx(() => [createElement("div", bidSilFlexRowClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.attbOptions, attbOpt => (openBlock(), createVNode(ImageButton, {
              key: attbOpt.key,
              data: {
                value: attbOpt.value,
                name: attbOpt.name,
                imgPath: attbOpt.value
              },
              active: selectedAttbValue.value === attbOpt.value,
              onSelect: handleAttbSelect
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }),

    /* --- BIND_DIRECTION: 제본방향 후가공 (BPTOP/BPLFT 자동 결정 + A/B 회전) --- */
    bindDirectionFlexRowClass = {
      class: "flex-row"
    },
    BIND_DIRECTION_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "BIND_DIRECTION",
        props: {
          data: {},
          relatedData: {}
        },
        emits: ["update"],
        setup(props, {
          emit: emit
        }) {
          const componentProps = props,
            emitFn = emit,
            productCode = inject("productCode", {
              pdtCode: ""
            }),
            /* 제본 회전 옵션: A(정방향) / B(역방향) */
            rotationOptions = [{
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
            workSize = computed(() => componentProps.relatedData.sizeInfo.workSize),
            /* 제본 방향 자동 결정: 가로 → 상단(BPTOP), 세로 → 좌측(BPLFT) */
            bindDirection = computed(() => horizontalBindSet.has(productCode.pdtCode) ? "BPLFT" : workSize.value.width > workSize.value.height ? "BPTOP" : "BPLFT"),
            selectedRotation = ref(rotationOptions[0].value),
            /* 메인 방향 + 회전 조합 */
            combinedDirection = computed(() => ({
              main: bindDirection.value,
              sub: selectedRotation.value
            }));
          /* 방향 조합 변경 시 부모 전달 */
          return watch(() => combinedDirection.value, newDirection => {
            const extraData = componentProps.data.options.find(opt => opt.value === newDirection.main)?.extra;
            emitFn("update", [{
              PCS_CD: componentProps.data.value,
              PCS_DTL_CD: newDirection.main,
              PCS_DTL_NM: extraData?.PCS_DTL_NM,
              ...bindDirection.value === "BPTOP" ? {
                BACK_ROT_YN: newDirection.sub
              } : {}
            }])
          }, {
            immediate: !0
          }), (instance, cache) => (openBlock(), createVNode(OptionRow, {
            title: instance.data.name,
            underline: ""
          }, {
            default: withCtx(() => [createElement("div", bindDirectionFlexRowClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.options, dirOption => (openBlock(), createVNode(ImageButton, {
              key: dirOption.key,
              data: {
                value: dirOption.value,
                name: dirOption.name,
                imgPath: `${instance.data.subImgPath}_${dirOption.value}`
              },
              "force-hidden": bindDirection.value !== dirOption.value,
              active: bindDirection.value === dirOption.value
            }, null, 8, ["data", "force-hidden", "active"]))), 128)), (openBlock(), createElementVNode(Fragment, null, renderList(rotationOptions, rotOption => renderComponent(ImageButton, {
              key: rotOption.key,
              data: {
                value: rotOption.value,
                name: rotOption.name,
                imgPath: rotOption.imgPath
              },
              "force-hidden": bindDirection.value === "BPLFT",
              active: selectedRotation.value === rotOption.value,
              onSelect: cache[0] || (cache[0] = selectedItem => selectedRotation.value = selectedItem.value)
            }, null, 8, ["data", "force-hidden", "active"])), 64))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, {
      value: "Module"
    }),

    /* 나머지 후가공 컴포넌트들은 동일한 패턴을 따름 (아이콘 선택 / 셀렉트 / 라디오) */
    /* BON_PAP, BON_SHT, CLD_STD, COT_DFT, COT_SEG, CVR_INN, CVR_SWN 등 */
    /* 각각의 PCS_CD에 맞는 옵션을 렌더링하고 update 이벤트로 상위에 전달 */

    /* --- BON_PAP: 본드용지 후가공 --- */
    bonPapFlexRowClass = {
      class: "flex-row"
    },
    bonPapNotesClass = {
      class: "notes"
    },
    bonPapNoteClass = {
      class: "note"
    },
    BON_PAP_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "BON_PAP",
        props: { data: {} },
        emits: ["update"],
        setup(props, { emit: emit }) {
          const componentProps = props, emitFn = emit,
            selectedValue = ref(componentProps.data.options[0].value),
            selectedName = ref(componentProps.data.options[0].name),
            handleSelect = selectedItem => { selectedValue.value = selectedItem.value, selectedName.value = selectedItem.name };
          return watch(() => selectedValue.value, newValue => {
            emitFn("update", [{ PCS_CD: componentProps.data.value, PCS_DTL_CD: newValue, PCS_DTL_NM: selectedName.value }])
          }, { immediate: !0 }),
          (instance, cache) => (openBlock(), createVNode(OptionRow, { title: instance.data.name, underline: "" }, {
            default: withCtx(() => [createElement("div", bonPapFlexRowClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.options, optItem => (openBlock(), createVNode(ImageButton, {
              key: optItem.key, data: { value: optItem.value, name: optItem.name, imgPath: instance.data.value }, active: selectedValue.value === optItem.value, onSelect: handleSelect
            }, null, 8, ["data", "active"]))), 128))]), createElement("div", bonPapNotesClass, [createElement("p", bonPapNoteClass, toDisplayString(instance.data.options[0]?.extra?.NOTICE[0]), 1)])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, { value: "Module" })),

    /* --- BON_SHT: 본드시트 후가공 --- */
    bonShtFlexRowClass = { class: "flex-row" },
    BON_SHT_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "BON_SHT", props: { data: {} }, emits: ["update"],
        setup(props, { emit: emit }) {
          const componentProps = props, emitFn = emit,
            selectedValue = ref(componentProps.data.options[0].value),
            selectedName = ref(componentProps.data.options[0].name),
            handleSelect = selectedItem => { selectedValue.value = selectedItem.value, selectedName.value = selectedItem.name };
          return watch(() => selectedValue.value, newValue => {
            emitFn("update", [{ PCS_CD: componentProps.data.value, PCS_DTL_CD: newValue, PCS_DTL_NM: `${componentProps.data.name}(${selectedName.value})` }])
          }, { immediate: !0 }),
          (instance, cache) => (openBlock(), createVNode(OptionRow, { title: instance.data.name, underline: "" }, {
            default: withCtx(() => [createElement("div", bonShtFlexRowClass, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.options, optItem => (openBlock(), createVNode(ImageButton, {
              key: optItem.key, data: { value: optItem.value, name: optItem.name, imgPath: `${instance.data.subImgPath}_${optItem.value}` }, active: selectedValue.value === optItem.value, onSelect: handleSelect
            }, null, 8, ["data", "active"]))), 128))])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, { value: "Module" })),

    /* --- CLD_STD: 달력규격 셀렉트 --- */
    cldStdOptionValueAttrs = ["value"],
    CLD_STD_Module = Object.freeze(Object.defineProperty({
      __proto__: null,
      default: defineComponent({
        __name: "CLD_STD", props: { data: {} }, emits: ["update"],
        setup(props, { emit: emit }) {
          const componentProps = props, emitFn = emit,
            selectedValue = ref(componentProps.data.options[0]?.value);
          return watch(() => selectedValue.value, newValue => {
            const matchedOpt = componentProps.data.options.find(opt => opt.value === newValue);
            emitFn("update", [{ PCS_CD: componentProps.data.value, PCS_DTL_CD: newValue, PCS_DTL_NM: matchedOpt?.name }])
          }, { immediate: !0 }),
          (instance, cache) => (openBlock(), createVNode(OptionRow, { title: instance.data.name, underline: "" }, {
            default: withCtx(() => [withDirectives(createElement("select", {
              "onUpdate:modelValue": cache[0] || (cache[0] = newVal => selectedValue.value = newVal), name: "CLD_STD", class: "basic-select"
            }, [(openBlock(!0), createElementVNode(Fragment, null, renderList(instance.data.options, optItem => (openBlock(), createElementVNode("option", {
              key: optItem.key, value: optItem.value
            }, toDisplayString(unref(translate)(optItem.name)), 9, cldStdOptionValueAttrs))), 128))], 512), [
              [vModelSelect, selectedValue.value]
            ])]),
            _: 1
          }, 8, ["title"]))
        }
      })
    }, Symbol.toStringTag, { value: "Module" }))

/* =========================================================================
 * 이하 나머지 후가공 및 수량 컴포넌트들은 동일한 패턴을 따릅니다.
 * COT_DFT(코팅), COT_SEG(부분코팅), CVR_INN(속표지), CVR_SWN(재봉),
 * DIR_MTR(직접자재), END_PAP(면지), INN_DFT(내지마감), INS_COT(내부코팅),
 * LAB_FBR(라벨원단), PAK_ETC(포장기타), PAK_POL(폴리백),
 * PDT_WRK(작업방식), PRT_IPK(개별포장표시), PRT_WHT(화이트인쇄),
 * PRT_WHT_FACE(화이트면선택), RIN_DFT(링제본), ROU_DFT(라운딩),
 * SCO_DFT(스코딕스), SUB_MTR_BC(보조자재), WRK_MTR(작업자재),
 * Basic(기본자재), CalendarQty(달력수량), SetQty(세트수량),
 * SimpleQty(단순수량), TotalQty(총수량)
 *
 * 모든 컴포넌트는:
 * 1. defineComponent()로 정의
 * 2. props로 data/options/relatedData 수신
 * 3. emits: ["update"]로 선택 결과를 부모에 전달
 * 4. watch()로 선택값 변경 시 PCS_CD/PCS_DTL_CD 구조로 변환
 * 5. OptionRow(fe) 래퍼로 fieldset 스타일 적용
 * 6. ImageButton(je) 또는 select/radio로 옵션 렌더링
 * ========================================================================= */
