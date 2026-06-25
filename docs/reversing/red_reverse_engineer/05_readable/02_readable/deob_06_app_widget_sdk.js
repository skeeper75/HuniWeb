/**
 * 레드프린팅 주문 위젯 메인 SDK 클래스. Shadow DOM 내에 Vue 3 앱을 마운트해 주문 옵션 UI를 렌더링. constructor(clientKeyValue)는 ALLOWED_CLIENT_KEYS('red-mobile'|'red-pc') 검증, init(initConfig, callbacks)는 attachShadow+createVueApp+Pinia/VueQuery/DomPurify 주입 후 widget.css 링크 삽입·mount.
 */
/**
 * ============================================================================
 * RedPrinting Widget SDK — RedWidgetSDK 클래스, Shadow DOM, Pinia 스토어,
 *                          Vue 3 컴포넌트, 주문 위젯 부트스트랩
 * ============================================================================
 * 원본 파일: mod_06_app_widget_sdk.js (4111 lines)
 * 역할: RedWidgetSDK 클래스(F1), Shadow DOM 초기화, 4개 Pinia 스토어 정의,
 *       Vue 3 컴포넌트(옵션 선택 UI), 주문/가격/에디터 연동
 *
 * 주요 구성:
 * 1. RedWidgetSDK 클래스 — clientKey 검증, Shadow DOM 생성, Vue 3 앱 마운트
 * 2. Pinia 스토어 — config(locale), product(baseInfo), order(orderData), exterior(uploadType/editorData)
 * 3. Vue 컴포넌트 — OptionRow, ImageButton, ButtonRadio, Selector, Sizes, Dosu, Uploader 등
 * 4. 주문 옵션 UI — 규격, 수량, 용지, 도수, 후가공, 파일 업로드
 * 5. 인스턴스 관리 클래스 — CommonWidgetInstance(L1), AccWidgetInstance($1)
 * ============================================================================
 */
// ============================================================================
// 섹션 1: RedWidgetSDK 클래스 (F1) — SDK 진입점
// ============================================================================
/**
 * RedWidgetSDK 클래스
 * 레드프린팅 주문 위젯의 메인 SDK 클래스
 * Shadow DOM 내에 Vue 3 애플리케이션을 마운트하여 주문 옵션 UI를 렌더링
 *
 * @class RedWidgetSDK
 */
class RedWidgetSDK {
  /** @type {string|null} 클라이언트 키 ("red-mobile" 또는 "red-pc") */
  clientKey = null;

  /**
   * SDK 인스턴스 생성
   * @param {string} clientKeyValue - 클라이언트 키 (허용 값: "red-mobile", "red-pc")
   * @throws {Error} 존재하지 않는 클라이언트 키일 경우
   */
  constructor(clientKeyValue) {
    if (!ALLOWED_CLIENT_KEYS.includes(clientKeyValue))
      throw new Error("존재하지 않는 사용자입니다");
    this.clientKey = clientKeyValue;
  }

  /**
   * 위젯 초기화 및 마운트
   * 지정된 DOM 요소에 Shadow DOM을 생성하고 Vue 3 앱을 마운트
   *
   * @param {object} initConfig - 초기화 설정
   * @param {string} initConfig.target - 마운트 대상 CSS 선택자 (예: "#redWidgetSdk")
   * @param {string} initConfig.pdtCode - 제품 코드 (예: "PRBKYPR", "PRBKORD")
   * @param {string} initConfig.pttCode - 패턴 코드
   * @param {string} [initConfig.locale="ko"] - 언어 코드 ("ko" | "en")
   * @param {object} initConfig.member - 회원 정보 (mb_id, mb_cust_cod, base64ID 등)
   * @param {string} [initConfig.deviceType="pc"] - 디바이스 타입 ("pc" | "mobile")
   * @param {object} callbacks - 콜백 함수 모음 (onOptionChange, onPriceChange, onOpenEditor 등)
   * @returns {CommonWidgetInstance|AccWidgetInstance} 위젯 인스턴스
   * @throws {Error} 마운트 대상 요소가 없거나 제품 코드가 없는 경우
   */
  init(initConfig, callbacks) {
    const {
        target: targetSelector,
        pdtCode: productCode,
        pttCode: patternCode,
        locale: localeCode = "ko",
        member: memberInfo,
        deviceType: deviceTypeValue = "pc",
      } = initConfig,
      targetElement = document.querySelector(targetSelector);
    if (!targetElement) throw new Error("주문위젯을 띄울 요소를 찾을 수 없습니다");

    /* Shadow DOM 생성 — open 모드로 외부 접근 허용 */
    const shadowRoot = targetElement.attachShadow({
        mode: "open",
      }),
      rootDiv = document.createElement("div");
    (rootDiv.id = "red-widget-root"), shadowRoot.appendChild(rootDiv);

    /* 부자재(ACC) 제품 여부 판별 — 부자재 제품은 별도 위젯 사용 */
    const isCommonProduct = !ACC_PRODUCT_CODES.has(productCode),
      vueApp = createVueApp(isCommonProduct ? CommonWidgetComponent : AccWidgetComponent);
    if (!productCode) throw new Error("제품 코드를 설정해주세요");
    if (!["ko", "en"].includes(localeCode)) throw new Error("지원하지 않는 언어입니다");

    /* Vue 3 앱 플러그인 및 의존성 주입 */
    if (
      (vueApp.use(createVueQueryPlugin()),
      vueApp.use(createPiniaPlugin),
      vueApp.use(createDomPurifyPlugin),
      useConfigStore().setLocale(localeCode),
      vueApp.provide("deviceType", deviceTypeValue),
      vueApp.provide("productCode", {
        pdtCode: productCode,
        pttCode: patternCode,
      }),
      vueApp.provide("callbacks", callbacks),
      vueApp.provide("member", memberInfo),
      isCommonProduct)
    ) {
      /* 일반 제품용 에디터 데이터 초기 상태 */
      const editorReactiveData = reactive({
        editingYn: "N",
      });
      vueApp.provide("editorData", editorReactiveData);
    }

    /* Shadow DOM에 위젯 CSS 링크 삽입 및 앱 마운트 */
    return (
      appendStylesheetToShadow(
        shadowRoot,
        "https://d2vgy67dgpwzce.cloudfront.net/RedWidgetSDK/prod/widget.css"
      ),
      vueApp.mount(rootDiv),
      isCommonProduct ? new CommonWidgetInstance(initConfig) : new AccWidgetInstance(initConfig)
    );
  }
}

/** 전역에 RedWidgetSDK 클래스 노출 */
window.RedWidgetSDK = RedWidgetSDK;

// ============================================================================
// 섹션 2: 동적 임포트 헬퍼
// ============================================================================

/**
 * 동적 임포트 헬퍼 — 컴포넌트 lazy loading에 사용
 * Vite/Rollup 번들러가 생성하는 dynamic import 패턴
 *
 * @param {object} importMap - 모듈 경로 → Promise 매핑 객체
 * @param {string} modulePath - 로드할 모듈 경로
 * @param {number} expectedDepth - 예상되는 경로 깊이
 * @returns {Promise} 모듈 Promise
 */
/**
 * 동적 임포트 헬퍼 — 컴포넌트 lazy loading(Vite/Rollup dynamic import 패턴). importMap[modulePath]를 함수면 호출, 아니면 Promise.resolve, 미존재면 reject.
 */
const dynamicImportHelper = (importMap, modulePath, expectedDepth) => {
  const moduleEntry = importMap[modulePath];
  return moduleEntry
    ? typeof moduleEntry == "function"
      ? moduleEntry()
      : Promise.resolve(moduleEntry)
    : new Promise((resolve, reject) => {
        (typeof queueMicrotask == "function" ? queueMicrotask : setTimeout)(
          reject.bind(
            null,
            new Error(
              "Unknown variable dynamic import: " +
                modulePath +
                (modulePath.split("/").length !== expectedDepth
                  ? ". Note that variables only represent file names one level deep."
                  : "")
            )
          )
        );
      });
};

// ============================================================================
// 섹션 3: 기본 UI 컴포넌트
// ============================================================================

/**
 * OptionRow 컴포넌트의 subject 클래스 속성
 */
const OPTION_ROW_SUBJECT_CLASS = {
  class: "subject",
};

/**
 * OptionRow 컴포넌트
 * 주문 위젯의 각 옵션 행(fieldset)을 감싸는 레이아웃 컴포넌트
 * - 규격, 수량, 용지, 도수, 후가공 등 각 옵션 섹션의 컨테이너
 *
 * @component
 * @prop {string} title - 옵션 행 제목 (예: "규격", "수량", "용지")
 * @prop {object} extra - 추가 버튼 설정 (name, callback)
 * @prop {number} priority - CSS order 속성으로 사용할 우선순위
 * @prop {boolean} underline - 타이틀 하단 밑줄 표시 여부
 * @prop {string} rowClass - 추가 CSS 클래스
 */
/**
 * OptionRow 컴포넌트 — 옵션 한 행의 레이블+컨트롤 레이아웃(withScopeId 스코프 격리).
 */
const OptionRow = withScopeId(
  defineComponent({
    __name: "OptionRow",
    props: {
      title: {},
      extra: {},
      priority: {},
      underline: {
        type: Boolean,
      },
      rowClass: {},
    },
    setup(props) {
      return (instance, cache) => (
        openBlock(),
        createBlock(
          "fieldset",
          {
            class: normalizeClass(["option-row", instance.rowClass]),
            style: normalizeStyle(
              instance.priority
                ? {
                    order: instance.priority,
                  }
                : null
            ),
          },
          [
            instance.title
              ? (openBlock(),
                createBlock(
                  "legend",
                  {
                    key: 0,
                    class: normalizeClass([
                      "title",
                      {
                        underline: instance.underline,
                      },
                    ]),
                  },
                  [
                    createElement(
                      "span",
                      OPTION_ROW_SUBJECT_CLASS,
                      toDisplayString(unref(translate)(instance.title)),
                      1
                    ),
                    instance.extra
                      ? (openBlock(),
                        createBlock(
                          "button",
                          {
                            key: 0,
                            type: "button",
                            class: normalizeClass(["extra-btn", instance.extra.style]),
                            onClick:
                              cache[0] ||
                              (cache[0] = (...args) =>
                                instance.extra.callback && instance.extra.callback(...args)),
                          },
                          toDisplayString(unref(translate)(instance.extra.name)),
                          3
                        ))
                      : createComment("", !0),
                  ],
                  2
                ))
              : createComment("", !0),
            renderSlot(instance.$slots, "default", {}, void 0, !0),
          ],
          6
        )
      );
    },
  }),
  [["__scopeId", "data-v-595f7226"]]
);

// ============================================================================
// 섹션 4: ImageButton(아이콘 체크박스) 컴포넌트
// ============================================================================

/**
 * ImageButton 컴포넌트 관련 상수
 */
const IMAGE_BUTTON_ICON_WRAP_CLASS = {
    class: "icon-wrap",
  },
  IMAGE_BUTTON_IMG_ATTRS = ["src", "alt"],
  IMAGE_BUTTON_NAME_CLASS = {
    class: "icon-name",
  },
  IMAGE_BUTTON_PC_TIP_CLASS = {
    key: 0,
    class: "pc-tip",
  },
  IMAGE_BUTTON_TIP_IMG_ATTRS = ["src", "alt", "data-idx"];

/**
 * ImageButton 컴포넌트
 * 이미지 기반 커스텀 체크박스/라디오 버튼
 * 후가공 선택(링제본, PVC 커버, 제본방향 등)에 사용
 *
 * @component
 * @prop {object} data - 버튼 데이터 (name, value, imgPath)
 * @prop {boolean} active - 선택 상태
 * @prop {boolean} disabled - 비활성 상태
 * @prop {object} tip - PC용 툴팁 이미지 데이터
 * @prop {boolean} forceHidden - 강제 숨김 여부
 * @emits select - 버튼 클릭 시 발생
 */
/**
 * ImageButton 컴포넌트 — 아이콘 체크박스(후가공 선택). 아이콘 이미지·이름·PC 툴팁 표시, 클릭 시 emit.
 */
const ImageButton = withScopeId(
  defineComponent({
    __name: "ImageButton",
    props: {
      data: {},
      active: {
        type: Boolean,
      },
      disabled: {
        type: Boolean,
      },
      disabledStyling: {
        type: Boolean,
      },
      tip: {},
      forceHidden: {
        type: Boolean,
      },
    },
    emits: ["select"],
    setup(props, { emit: emitEvent }) {
      const componentProps = props,
        emit = emitEvent,
        deviceType = inject("deviceType", "pc"),
        /** 아이콘 이미지 경로 계산 */
        iconImageSrc = computed(() =>
          componentProps.data.forcedImg
            ? componentProps.data.imgPath
            : `${ASSETS_IMAGE_CDN_URL}/ordericon/${componentProps.data.imgPath}.png`
        ),
        /** 대체(서브) 이미지 경로 */
        fallbackImageSrc = computed(
          () => `${ASSETS_IMAGE_CDN_URL}/ordericon/${componentProps.data.subImgPath}.png`
        );

      /** 클릭 핸들러 — 비활성 상태가 아닐 때만 select 이벤트 발생 */
      function handleClick() {
        componentProps.disabled || emit("select", componentProps.data);
      }

      /** 이미지 로드 에러 시 대체 이미지로 교체 */
      function handleImageError(event) {
        const imgElement = event.target;
        imgElement &&
          ((imgElement.src = fallbackImageSrc.value),
          (imgElement.onerror = () => {
            imgElement.src = `${ASSETS_IMAGE_CDN_URL}/ordericon/order_icon1-3.png`;
          }));
      }
      return (instance, cache) =>
        withDirectives(
          (openBlock(),
          createBlock(
            "div",
            {
              onClick: handleClick,
              class: normalizeClass([
                "icon-checkbox",
                {
                  disabled: instance.disabledStyling && instance.disabled,
                },
              ]),
            },
            [
              createElement(
                "div",
                {
                  class: normalizeClass([
                    "icon-label",
                    {
                      active: instance.active,
                    },
                  ]),
                },
                [
                  createElement("div", IMAGE_BUTTON_ICON_WRAP_CLASS, [
                    createElement(
                      "img",
                      {
                        src: iconImageSrc.value,
                        alt: instance.data.name,
                        onError: handleImageError,
                      },
                      null,
                      40,
                      IMAGE_BUTTON_IMG_ATTRS
                    ),
                  ]),
                ],
                2
              ),
              createElement(
                "span",
                IMAGE_BUTTON_NAME_CLASS,
                toDisplayString(unref(translate)(instance.data.name)),
                1
              ),
              (!unref(deviceType) || unref(deviceType) === "pc") && instance.tip
                ? (openBlock(),
                  createBlock("div", IMAGE_BUTTON_PC_TIP_CLASS, [
                    (openBlock(),
                    createBlock(
                      "img",
                      {
                        src: instance.tip.IMG_URL,
                        alt: instance.tip.IMG_ALT,
                        key: instance.tip.IDX,
                        "data-idx": instance.tip.IDX,
                      },
                      null,
                      8,
                      IMAGE_BUTTON_TIP_IMG_ATTRS
                    )),
                  ]))
                : createComment("", !0),
              renderSlot(instance.$slots, "input", {}, void 0, !0),
            ],
            2
          )),
          [[vShow, !instance.forceHidden]]
        );
    },
  }),
  [["__scopeId", "data-v-a9670923"]]
);

// ============================================================================
// 섹션 5: PageDirection(인쇄 방향) 컴포넌트
// ============================================================================

/** 페이지 방향 컨테이너 클래스 */
const PAGE_DIRECTION_FLEX_ROW = {
  class: "flex-row",
};

/**
 * PageDirection 컴포넌트
 * 인쇄물의 가로/세로 방향을 선택하는 UI
 * 사이즈 정보에 따라 자동으로 방향이 결정되거나 사용자가 선택 가능
 *
 * @component
 * @prop {object} relatedData - 관련 데이터 (sizeInfo 포함)
 * @emits update - 방향 변경 시 {COD, COD_NME} 형태로 발생
 */
/**
 * PageDirection 컴포넌트 — 가로/세로 인쇄 방향 선택. 사이즈로 방향 자동 감지(autoDetectedDirection), 자재 변경 시 방향 리셋.
 */
const PageDirectionComponent = defineComponent({
  __name: "PageDirection",
  props: {
    relatedData: {},
  },
  emits: ["update"],
  setup(props, { emit: emitEvent }) {
    const componentProps = props,
      emit = emitEvent,
      exteriorStore = useExteriorStore(),
      callbacks = inject("callbacks", {}),
      /** 방향 옵션 목록: 가로(W), 세로(H) */
      directionOptions = [
        {
          value: "W",
          name: "가로",
          imgPath: "order_icon1-3",
        },
        {
          value: "H",
          name: "세로",
          imgPath: "order_icon1-2",
        },
      ],
      /** 현재 선택된 방향 */
      selectedDirection = ref("H"),
      /** 에디터 편집 후 방향 초기화 콜백 */
      resetDirectionCallback = () => {
        callbacks?.onReset && callbacks.onReset("direction");
      };

    /* 방향 변경 감시 — 변경 시 콜백 호출 및 부모 컴포넌트에 알림 */
    watch(
      () => selectedDirection.value,
      (directionValue) => {
        exteriorStore.isAfterEdit() && resetDirectionCallback(),
          emit("update", {
            COD: selectedDirection.value,
            COD_NME: translate(directionValue === "H" ? "세로" : "가로"),
          });
      },
      {
        immediate: !0,
      }
    );

    /** 규격 정보에 따라 자동 방향 결정 */
    const autoDetectedDirection = computed(() => {
      if (!componentProps.relatedData.sizeInfo) return;
      const { DIV_NM: sizeName, cutSize: cutSizeData } = componentProps.relatedData.sizeInfo;
      if (sizeName === "사이즈직접입력" || sizeName === "Input Size") {
        if (cutSizeData.height > cutSizeData.width) return "H";
        if (cutSizeData.height === cutSizeData.width) return selectedDirection.value;
        if (cutSizeData.height < cutSizeData.width) return "W";
      }
    });
    return (
      watch(
        () => autoDetectedDirection.value,
        (detectedValue) => {
          detectedValue && (selectedDirection.value = detectedValue);
        },
        {
          immediate: !0,
        }
      ),
      (instance, cache) => (
        openBlock(),
        createVNode(
          OptionRow,
          {
            title: "주문서작성",
          },
          {
            default: withCtx(() => [
              createElement("div", PAGE_DIRECTION_FLEX_ROW, [
                (openBlock(),
                createBlock(
                  Fragment,
                  null,
                  renderList(directionOptions, (optionItem) =>
                    createVNode(
                      ImageButton,
                      {
                        key: optionItem.value,
                        data: optionItem,
                        active: selectedDirection.value === optionItem.value,
                        disabled:
                          autoDetectedDirection.value &&
                          autoDetectedDirection.value !== optionItem.value,
                        "disabled-styling": !!autoDetectedDirection.value,
                        onSelect:
                          cache[0] ||
                          (cache[0] = (selectedItem) =>
                            (selectedDirection.value = selectedItem.value)),
                      },
                      null,
                      8,
                      ["data", "active", "disabled", "disabled-styling"]
                    )
                  ),
                  64
                )),
              ]),
            ]),
            _: 1,
          }
        )
      )
    );
  },
});

// ============================================================================
// 섹션 6: ButtonRadio(버튼 라디오) 컴포넌트
// ============================================================================

/**
 * ButtonRadio 컴포넌트
 * 버튼 형태의 라디오 그룹 — 용지 종류, 제작방식 등 선택에 사용
 *
 * @component
 * @prop {Array} options - 옵션 목록 [{name, value, key, disabled}]
 * @prop {*} default - 기본 선택값
 * @prop {Array} tips - PC 툴팁 이미지 배열
 * @prop {string} type - 크기 타입 ("md" 등)
 * @emits select - 옵션 선택 시 값 전달
 */
/* ButtonRadio 구현은 원본 mod_06 line 258~300과 동일 구조 */

// ============================================================================
// 섹션 7: Selector(드롭다운 선택) 컴포넌트
// ============================================================================

/**
 * Selector 컴포넌트
 * 기본 select 드롭다운 — 규격, 용지, 평량 등 선택에 사용
 *
 * @component
 * @prop {string} name - select 요소의 name 속성
 * @prop {Array} options - 옵션 목록 [{name, value, key, disabled}]
 * @prop {*} default - 기본 선택값
 * @emits select - 옵션 선택 시 값 전달
 */
/* Selector 구현은 원본 mod_06 line 303~333과 동일 구조 */

// ============================================================================
// 섹션 8: MaterialFilters(자재 필터) 컴포넌트
// ============================================================================

/**
 * MaterialFilters 컴포넌트
 * 자재 그룹 → 패턴 그룹 → 패턴 상세의 3단계 캐스케이드 필터
 * 부자재 제품(스탬프, 금속 명함 등)에서 자재 선택 시 사용
 *
 * @component
 * @prop {object} options - 필터 옵션 ({MTRL_GRP, PTT_GRP, PTT})
 * @emits update - 필터 값 변경 시 {MTRL_GRP, PTT_GRP, PTT} 전달
 */
/* MaterialFilters 구현은 원본 mod_06 line 334~416과 동일 구조 */

// ============================================================================
// 섹션 9: Dosu(인쇄 도수) 컴포넌트
// ============================================================================

/**
 * Dosu 컴포넌트
 * 인쇄 도수(색상 수) 선택 — 양면/단면, 컬러/흑백 등
 * 제품에 따라 select 또는 radio 버튼 형태로 렌더링
 *
 * @component
 * @prop {Array} options - 도수 옵션 목록
 * @prop {object} default - 기본 선택값
 * @prop {object} relatedData - 관련 데이터 (자재코드, 자재도수)
 * @emits update - 도수 변경 시 선택된 도수 객체 전달
 */
/* Dosu 구현은 원본 mod_06 line 502~587과 동일 구조 */

// ============================================================================
// 섹션 10: Sizes(규격 선택) 컴포넌트
// ============================================================================

/**
 * Sizes 컴포넌트
 * 인쇄물 규격(사이즈) 선택 — A4, B5 등 정형 규격 또는 사이즈 직접 입력
 * 재단 사이즈(CUT)와 작업 사이즈(WRK, 도련 포함)를 계산
 *
 * 주요 필드:
 * - CUT_WDT/CUT_HGH: 재단 가로/세로 (mm)
 * - WRK_WDT/WRK_HGH: 작업 가로/세로 (재단 + 도련 마진)
 * - CUT_MRG: 도련(재단 마진) 값
 *
 * @component
 * @prop {Array} options - 규격 옵션 목록 (pdt_size_info)
 * @prop {object} baseInfo - 제품 기본 정보 (최소/최대 사이즈, 도련값 등)
 * @prop {object} default - 기본 선택값
 * @prop {object} relatedData - 관련 데이터 (모양, 페이지방향 등)
 * @prop {boolean} hiddenSizes - 사이즈 상세 영역 숨김 여부
 * @prop {boolean} showExtra - "가이드 보기" 버튼 표시 여부
 * @emits update - 규격 변경 시 {DIV_NM, DIV_SEQ, cutSize, workSize} 전달
 * @emits validate - 유효성 검증 결과 전달
 */
/* Sizes 구현은 원본 mod_06 line 769~1033과 동일 구조 */

// ============================================================================
// 섹션 11: HiddenPostPcs(숨겨진 후가공) 컴포넌트
// ============================================================================

/**
 * HiddenPostPcs 컴포넌트
 * 사용자에게 직접 보이지 않는 기본/필수 후가공 옵션을 자동 설정
 * 예: 재단(CUT_DFT), 레이저 커팅(LAS_DFT), 톰슨 재단(THO_XXX), 라운딩(ROU_DFT)
 *
 * 후가공 코드 체계:
 * - CUT_DFT: 기본 재단
 * - LAS_DFT: 레이저 재단
 * - THO_XXX: 톰슨 재단 (모양별)
 * - ROU_DFT: 라운딩 (모서리 둥글게)
 * - PER_DFT: 제본 (좌철/상철)
 * - COT_DFT: 코팅
 * - CVR_SFT: 표지 후가공
 *
 * @component
 * @prop {Array} options - 숨겨진 후가공 옵션 목록
 * @prop {object} relatedData - 관련 데이터 (모양, 사이즈, 자재코드, 도수 등)
 * @prop {object} disabledOpts - 비활성화할 후가공 옵션
 * @emits update - 후가공 설정 변경 시 후가공 맵 전달
 */
/* HiddenPostPcs 구현은 원본 mod_06 line 1162~1300과 동일 구조 */

// ============================================================================
// 섹션 12: VisiblePostPcs(표시 후가공) 컴포넌트
// ============================================================================

/**
 * VisiblePostPcs 컴포넌트
 * 사용자가 직접 선택/해제할 수 있는 후가공 옵션 UI
 * 아이콘 체크박스로 표시되며, 선택 시 상세 옵션이 펼쳐짐
 *
 * 후가공 종류:
 * - RIN_DFT: 링제본 (색상 선택: 검정/흰색/금색/은색)
 * - ADC_PVC: PVC 추가커버
 * - BIND_DIRECTION: 제본방향 (좌철/상철)
 * - COT_DFT: 코팅 (무광/유광)
 * - PRT_WHT: 화이트 인쇄
 * - DIR_MTR: 직접 자재 지정
 *
 * @component
 * @prop {Array} options - 표시 후가공 옵션 목록
 * @prop {object} disabledOpts - 자재별 비활성화 후가공 맵
 * @prop {Array} attbOpts - 추가 속성 옵션 목록
 * @prop {object} relatedData - 관련 데이터 (자재코드, 주문수량, 사이즈 등)
 * @emits update - 후가공 선택 변경 시 후가공 맵 전달
 */
/* VisiblePostPcs 구현은 원본 mod_06 line 1335~1590과 동일 구조 */

// ============================================================================
// 섹션 13: SUB_MTR(부자재) 컴포넌트
// ============================================================================

/**
 * SUB_MTR 컴포넌트
 * 부자재 선택 행 — select 드롭다운 + 수량 입력
 * 끈 종류, 봉투, 라벨, PVC 등 부자재 선택에 사용
 *
 * @component
 * @prop {string} title - 부자재 행 제목
 * @prop {Array} options - 부자재 옵션 목록
 * @prop {object} defaultData - 기본 선택 데이터 {PCS_DTL_CD, qty, extra}
 * @prop {boolean} qtyDisabled - 수량 입력 비활성 여부
 * @emits update - 부자재 선택/수량 변경 시 데이터 전달
 */
/* SUB_MTR 구현은 원본 mod_06 line 1600~1682와 동일 구조 */

// ============================================================================
// 섹션 14: S3Uploader(파일 업로드) 컴포넌트
// ============================================================================

/**
 * S3Uploader 컴포넌트
 * AWS S3 presigned URL 방식으로 PDF 파일을 업로드
 *
 * 업로드 플로우:
 * 1. 파일 선택 (드래그&드롭 또는 파일 선택기)
 * 2. 파일 유효성 검증 (확장자, 크기 제한 1GB)
 * 3. POST /api/aws/presigned-url → presigned URL + 새 파일명 획득
 * 4. PUT presignedURL → S3 직접 업로드
 * 5. 업로드 결과를 부모에 emit
 *
 * @component
 * @prop {string} _key - 업로더 식별 키 ("default", "inner" 등)
 * @prop {Array} allowedExt - 허용 파일 타입 (기본: ["application/pdf"])
 * @emits upload - 업로드 완료 시 파일 정보 배열 전달
 */
/* S3Uploader 구현은 원본 mod_06 line 2031~2165와 동일 구조 */

// ============================================================================
// 섹션 15: Uploader(통합 업로더) 컴포넌트
// ============================================================================

/**
 * Uploader 컴포넌트
 * PDF 업로드 또는 에디터 편집의 통합 UI
 * 탭으로 "PDF" / "에디터" 전환 가능
 *
 * PDF 탭: S3Uploader 사용
 * 에디터 탭: RedEditorSDK 연동, 무료 템플릿 갤러리 표시
 *
 * 에디터 설정 조회:
 * POST /api/editor/config/{KOI|RP}
 * - KOI: 코이 에디터 (자체 에디터)
 * - RP: 레드프린팅 에디터
 *
 * @component
 * @prop {string} _key - 업로더 키 ("default" | "inner")
 * @prop {boolean} showExtra - 템플릿 다운로드 버튼 표시 여부
 * @prop {object} uploadConfig - 업로드 설정 {editor, pdf, token}
 * @prop {Array} allowedExt - 허용 파일 확장자
 * @prop {object} relatedData - 관련 데이터
 * @prop {string} subject - 업로더 제목 ("파일업로드" | "내지업로드" | "표지업로드")
 * @prop {Array} notes - 안내 문구 배열
 * @emits upload - 업로드/에디터 완료 시 파일 정보 전달
 */
/* Uploader 구현은 원본 mod_06 line 2415~2617과 동일 구조 */

// ============================================================================
// 섹션 16: 후가공/부자재 옵션 분류 유틸리티
// ============================================================================

/**
 * 후가공 옵션 분류 함수
 * 서버에서 받은 pdt_pcs_info를 visible/hidden/essential로 분류
 *
 * 분류 기준:
 * - hidden: ESN_YN="Y" && VIEW_YN="N" (필수이나 사용자에게 안 보임)
 * - visible: ESN_YN="Y" && VIEW_YN="Y" 또는 선택적(ESN_YN="N")
 * - essential: 하위 자재 관련 (SUB_MTR 계열)
 *
 * @param {Array} postPcsOptions - 후가공 옵션 목록
 * @param {Array} disabledPcsOptions - 비활성화 후가공 목록
 * @returns {object} {postPcs: {visible, hidden}, sub: {visible, essential}, disabled}
 */
/* classifyPostProcessOptions 구현은 원본 mod_06 line 2618~2661과 동일 */

// ============================================================================
// 섹션 17: uploadConfig 및 canEditOrdCnt 헬퍼
// ============================================================================

/**
 * 업로드 설정 구성 함수
 * 위젯 속성에서 PDF/에디터 사용 여부와 토큰 정보를 추출
 *
 * @param {object} widgetAttr - 위젯 속성 객체
 * @returns {object} {uploadConfig: ComputedRef, canEditOrdCnt: ComputedRef}
 */
/* buildUploadConfig 구현은 원본 mod_06 line 2663~2695와 동일 */

// ============================================================================
// 섹션 18: 주문 옵션 상태 관리 (useOrderState)
// ============================================================================

/**
 * 주문 옵션 상태 관리 컴포저블
 * 사용자 선택 데이터를 수집하고 debounce로 부모에 전달
 *
 * 관리하는 상태:
 * - sizeInfo: 규격 정보 (재단/작업 사이즈)
 * - meterialInfo: 자재(용지) 정보
 * - dosuInfo: 인쇄 도수 정보
 * - quantityInfo: 수량 정보 (ordCnt, prnCnt)
 * - pcsInfo: 후가공 정보 배열
 * - fileUploadInfo: 파일 업로드 정보
 * - clothesSelectData: 의류 제품 전용 데이터
 * - acrylicSelectData: 아크릴 제품 전용 데이터
 * - calendarInfo: 달력 제품 전용 데이터
 *
 * @param {string} mode - "new" (신규 주문)
 * @param {object} config - {group: 제품 그룹, emits: 이벤트 핸들러}
 * @returns {object} 상태 관리 인터페이스
 */
/* useOrderState 구현은 원본 mod_06 line 2697~2778과 동일 */

// ============================================================================
// 섹션 19: Digital(디지털 인쇄) 메인 위젯 컴포넌트
// ============================================================================

/**
 * Digital 위젯 컴포넌트
 * 가장 범용적인 주문 위젯 — 명함, 스티커, 전단지, 카탈로그 등
 * 옵션 행 순서: 방향 → 자재필터 → 컬러 → 모양 → 자재 → 도수 → 두께
 *              → 규격 → 달력설정 → 수량 → 주문제목 → 숨김후가공
 *              → 표시후가공 → 부자재 → 파일업로드
 *
 * @component
 * @prop {object} data - 제품 데이터 (product_data)
 * @prop {object} widgetAttr - 위젯 속성 (skinInfo, item_gbn 등)
 * @prop {object} senecaInfo - 세네카(책등) 정보
 * @emits update - 옵션 변경 시 전체 주문 데이터 전달
 */
/* Digital 위젯 구현은 원본 mod_06 line 2797~3030과 동일 */

// ============================================================================
// 섹션 20: Acrylic(아크릴) 위젯 컴포넌트
// ============================================================================

/**
 * Acrylic 위젯 컴포넌트
 * 아크릴 키링, 아크릴 키홀더, 아크릴 폰케이스 등의 주문 위젯
 * 제작방식 선택(Method), 인쇄 데이터(PrintData) 등 아크릴 전용 옵션 포함
 *
 * @component
 */
/* Acrylic 위젯 구현은 원본 mod_06 line 3636~3788과 동일 */

// ============================================================================
// 섹션 21: Clothes(의류) 위젯 관련 컴포넌트
// ============================================================================

/**
 * ApparelPrintType 컴포넌트
 * 의류 인쇄 방식 선택 — DTF 열전사, 직접인쇄, 날염(실크인쇄)
 *
 * @component
 */

/**
 * ApparelColor 컴포넌트
 * 의류 컬러 선택 — 컬러칩(ColorPicker) 기반 UI
 *
 * @component
 */

/**
 * ApparelPrintArea 컴포넌트
 * 의류 인쇄 영역 선택 — 앞면, 뒷면, 가슴, 팔, 목 등
 * 일부 영역은 동시 선택 불가 (예: 좌측가슴 + 앞면)
 *
 * @component
 */
/* 의류 관련 컴포넌트 구현은 원본 mod_06 line 3789~4111과 동일 */

// ============================================================================
// 섹션 22: Pinia 스토어 정의
// ============================================================================

/**
 * config 스토어 — 앱 전역 설정
 * @property {Ref<string>} locale - 현재 언어 코드 ("ko" | "en")
 * @method setLocale - 언어 변경
 */
/**
 * Pinia config 스토어 — 다국어 locale 상태·setLocale. translate(key, params)가 이 스토어의 locale로 TRANSLATIONS_KO/EN 조회·파라미터 치환.
 */
const useConfigStore = defineStore("config", () => {
  const locale = ref("ko");
  function setLocale(newLocale) {
    locale.value = newLocale;
  }
  return {
    locale: locale,
    setLocale: setLocale,
  };
});

/**
 * 다국어 번역 함수
 * config 스토어의 locale에 따라 한국어/영어 번역을 반환
 *
 * @param {string} key - 번역 키 (예: "규격", "수량")
 * @param {object} params - 치환 파라미터 (예: {QTY: 50})
 * @returns {string} 번역된 문자열
 */
const translate = (key, params) => {
  const { locale: currentLocale } = storeToRefs(useConfigStore()),
    translatedText = (currentLocale.value === "ko" ? TRANSLATIONS_KO : TRANSLATIONS_EN)[key] || key;
  if (!params) return translatedText;
  let result = translatedText;
  return (
    Object.entries(params).forEach(([paramKey, paramValue]) => {
      result = result.replace(`{${paramKey}}`, paramValue);
    }),
    result
  );
};

/**
 * product 스토어 — 서버에서 로드한 제품 옵션 데이터
 * @property {Ref<object>} baseInfo - 제품 기본 정보 (pdt_size_info, pdt_mtrl_info 등)
 * @method getProductBaseInfo - 제품 기본 정보 반환 (deep clone)
 * @method setProductBaseInfo - 제품 기본 정보 설정
 */
/**
 * Pinia product 스토어 — baseInfo(제품 기준정보)·getProductBaseInfo·setProductBaseInfo.
 */
const useProductStore = defineStore("product", () => {
  const baseInfo = ref();
  function getProductBaseInfo() {
    return structuredClone(baseInfo.value);
  }
  function setProductBaseInfo(data) {
    baseInfo.value = data;
  }
  return {
    baseInfo: baseInfo,
    getProductBaseInfo: getProductBaseInfo,
    setProductBaseInfo: setProductBaseInfo,
  };
});

/**
 * exterior 스토어 — 파일 업로드 및 에디터 상태
 * @property {Reactive<object>} uploadType - 업로드 타입 ("editor" | "pdf"), 키별 관리
 * @property {Reactive<object>} editorData - 에디터 편집 데이터 (projectID, editingYn 등)
 * @property {Reactive<object>} payloadForEditorConfig - 에디터 설정용 페이로드
 * @method setUploadType - 업로드 타입 변경
 * @method setEditorData - 에디터 데이터 설정
 * @method isAfterEdit - 에디터 편집 완료 여부 확인
 */
/**
 * Pinia exterior 스토어 — uploadType(editor|pdf)·editorData·payloadForEditorConfig. 위젯 파일업로드 vs 에디쿠스(편집기) 경로 분기 상태.
 */
const useExteriorStore = defineStore("exterior", () => {
  const uploadType = reactive({
    default: "editor",
  });
  function setUploadType(type, key) {
    uploadType[key || "default"] = type;
  }
  const editorData = reactive({
      default: null,
    }),
    setEditorData = (data, key) => {
      editorData[key || "default"] = data;
    },
    payloadForEditorConfig = reactive({
      default: null,
    }),
    setPayloadForEditorConfig = (data, key) => {
      payloadForEditorConfig[key || "default"] = data;
    };
  return (
    watch(
      () => editorData,
      (data) => {
        /* 개발 환경에서만 에디터 데이터 변경 로그 출력 */
        useDevMode().isDev.value && console.log("[RedWidgetSDK] 에디터 편집 정보 업데이트 >", data);
      },
      {
        deep: !0,
      }
    ),
    {
      uploadType: uploadType,
      setUploadType: setUploadType,
      editorData: editorData,
      setEditorData: setEditorData,
      isAfterEdit: (key) =>
        editorData[key || "default"]
          ? uploadType[key || "default"] === "editor" &&
            editorData[key || "default"].editingYn === "Y"
          : !1,
      payloadForEditorConfig: payloadForEditorConfig,
      setPayloadForEditorConfig: setPayloadForEditorConfig,
    }
  );
});

/**
 * order 스토어 — 사용자의 현재 주문 선택 상태
 * @property {Ref<object>} orderData - 주문 데이터 (sizeInfo, dosuInfo, meterialInfo 등)
 * @method getOrderData - 주문 데이터 반환 (deep clone)
 * @method setOrderData - 주문 데이터 설정 + onOptionChange 콜백 호출
 */
/**
 * Pinia order 스토어 — orderData(주문 옵션·가격 계산 결과)·getOrderData·setOrderData.
 */
const useOrderStore = defineStore("order", () => {
  const orderData = ref(),
    callbacks = inject("callbacks", {});
  function getOrderData() {
    return structuredClone(orderData.value);
  }
  function setOrderData(data, summary) {
    (orderData.value = data),
      callbacks?.onOptionChange &&
        callbacks.onOptionChange({
          type: "COMMON",
          data: data,
          summary: summary,
        });
  }
  return {
    orderData: orderData,
    getOrderData: getOrderData,
    setOrderData: setOrderData,
  };
});

/**
 * acc-order 스토어 — 부자재 주문 데이터 (부자재 전용 제품)
 * @property {Ref<object>} orderData - 부자재 주문 데이터
 * @method getOrderData - 주문 데이터 반환
 * @method setOrderData - 주문 데이터 설정 + onOptionChange 콜백 호출 (type: "ACC")
 */
/**
 * Pinia acc-order 스토어 — 부자재(ACC) 전용 주문 데이터.
 */
const useAccOrderStore = defineStore("acc-order", () => {
  const orderData = ref(),
    callbacks = inject("callbacks", {});
  function getOrderData() {
    return structuredClone(orderData.value);
  }
  function setOrderData(data) {
    (orderData.value = data),
      callbacks?.onOptionChange &&
        callbacks.onOptionChange({
          type: "ACC",
          data: data,
        });
  }
  return {
    orderData: orderData,
    getOrderData: getOrderData,
    setOrderData: setOrderData,
  };
});

// ============================================================================
// 섹션 23: 제품 코드별 설정 상수
// ============================================================================

/**
 * 수량 UI 타입 매핑
 * 제품 코드에 따라 다른 수량 입력 컴포넌트를 사용
 * - TotalQty: 총 수량 입력 (스피너)
 * - SetQty: 세트 수량 입력
 * - SimpleQty: 단순 수량 입력
 * - DesignQty: 디자인수 x 수량 (기본)
 */
const QUANTITY_UI_TYPE_MAP = {
  GSPNJLY: "TotalQty",
  GSPNBAL: "SetQty",
  GSPNDFT: "SetQty",
  STDRCAD: "SimpleQty",
  STTBDFT: "SimpleQty",
  TPCAPTW: "SimpleQty",
};

/** 에디터 편집 후 자재 초기화가 필요한 제품 코드 */
const RESET_MATERIAL_AFTER_EDIT_CODES = new Set([
  "GSPNJLY",
  "GSPNBAL",
  "GSPNCLP",
  "GSPNDFT",
  "GSPNFLT",
  "GSTTCRK",
  "GSCAEPB",
  "GSCAGBP",
  "GSCAGBM",
  "GSCAGBR",
  "GSCAGBH",
  "GSCATPP",
  "GSCATPG",
  "GSCATCP",
  "GSCACDP",
  "GSCAPHN",
  "GSWLMAG",
  "GSCATIN",
  "GSKYHOT",
  "GSHDMGT",
  "GSTGMIC",
  "GSCAPDF",
  "GSCACAP",
  "PHFRDIA",
  "GSSKSHH",
  "GSFBSTK",
]);

/** 수량 = prnCnt인 제품 (ordCnt 별도 없음) */
const SINGLE_QUANTITY_PRODUCTS = {
  GSPNJLY: !0,
  GSPNBAL: !0,
  GSPNDFT: !0,
};

/** 달력 제품 코드 */
const CALENDAR_PRODUCT_CODES = new Set([
  "TPCLECO",
  "TPCLWLB",
  "PRCLSTD",
  "PRCLHOL",
  "PRCLWAL",
  "TPCLSTD",
  "TPCLHOL",
  "TPCLWAL",
]);

/** 윤전 인쇄 달력 제품 코드 */
const OFFSET_CALENDAR_CODES = new Set(["PRCLSTD", "PRCLHOL", "PRCLWAL"]);

/** 직접 자재 지정(DIR_MTR) 제품 코드 */
const DIRECT_MATERIAL_PRODUCTS = new Set(["GSBKLAP", "GSBKBCH", "GSTTDTM", "GSFBPHP", "GSFBSTK"]);

/**
 * 자재 연결 후가공 코드 매핑
 * 제품별로 자재 선택이 특정 후가공 코드에 연결됨
 */
const MATERIAL_PCS_CODE_MAP = {
  GSGLPWT: "SUB_MTR",
  GSBKLAP: "DIR_MTR",
  GSBKBCH: "DIR_MTR",
  GSTTDTM: "DIR_MTR",
  PHMGDFT: "SUB_MTR",
  GSFBPHP: "DIR_MTR",
  GSTGMIC: "WRK_MTR",
  GSNTMIS: "SUB_MTR",
  GSFBSTK: "DIR_MTR",
};

/** 화이트 인쇄 자동 설정 제품별 자재코드 */
const WHITE_PRINT_AUTO_MATERIAL_MAP = {
  GSCATIN: {
    SXTNC010: "Y",
    SXTNC014: "Y",
  },
};

/** 허용된 클라이언트 키 목록 */
const ALLOWED_CLIENT_KEYS = ["red-mobile", "red-pc"];

/** 부자재(ACC) 제품 코드 Set */
const ACC_PRODUCT_CODES = new Set(["GSSBMTL", "GSSBSTP", "GSSBACM"]);

// ============================================================================
// 섹션 24: CommonWidgetInstance(L1) — 일반 제품 인스턴스
// ============================================================================

/**
 * CommonWidgetInstance 클래스 (원본: L1)
 * 일반 제품(디지털 인쇄, 아크릴, 의류, 책자)의 위젯 인스턴스
 * RedWidgetSDK.init() 호출 후 반환되는 인스턴스 객체
 *
 * 제공 메서드:
 * - getProductBaseInfo(): 제품 기본 정보 반환
 * - getOrderData(): 현재 주문 데이터 반환
 * - getSummary(): 주문 요약 정보 생성 (사이드바 표시용)
 * - setEditorData(data): 에디터 편집 결과 반영
 * - canOrder(): 주문 가능 여부 검증
 * - getKOIEditorTabData(tabData): KOI 에디터 커스텀 탭 가격 계산
 */
/**
 * 일반 제품용 위젯 인스턴스(RedWidgetSDK.init이 반환). getProductBaseInfo·getOrderData·getSummary(주문 요약)·setEditorData(에디터 결과 주입·KOI/RP 분기)·canOrder(옵션·가격 검증) 메서드 제공.
 */
class CommonWidgetInstance {
  constructor(config) {
    this.pdtCode = config.pdtCode;
  }
  pdtCode = "";
  editorStore = useExteriorStore();
  orderStore = useOrderStore();
  productStore = useProductStore();

  /** 제품 기본 정보 반환 (deep clone) */
  getProductBaseInfo() {
    return this.productStore.getProductBaseInfo();
  }

  /** 현재 주문 데이터 반환 (deep clone) */
  getOrderData() {
    return this.orderStore.getOrderData();
  }

  /**
   * 주문 요약 정보 생성
   * 우측 사이드바에 표시할 요약 데이터를 계산
   * 포함 항목: 사이즈, 자재, 도수, 후가공, 수량, 가격 등
   *
   * @returns {object} 요약 데이터 객체
   */
  getSummary() {
    const productBaseInfo = this.getProductBaseInfo(),
      orderData = this.getOrderData(),
      itemGroup = productBaseInfo?.product_option.option.item_gbn,
      acrylicData = orderData?.acrylicSelectData,
      clothesData = orderData?.clothesSelectData;

    /* 아크릴 제품 요약 */
    const acrylicSummary = acrylicData
      ? {
          ...(acrylicData.printData
            ? {
                printData: {
                  label: "인쇄 데이터",
                  value: acrylicData.printData.COD_NME,
                },
              }
            : {}),
          ...(acrylicData.productionMethod
            ? {
                productionMethod: {
                  label: "제작방식",
                  value: acrylicData.productionMethod.COD_NME,
                },
              }
            : {}),
          ...(acrylicData.shapeInfo
            ? {
                shape: {
                  label: "모양",
                  value: acrylicData.shapeInfo.COD_NME,
                },
              }
            : {}),
        }
      : null;

    /* 의류 제품 요약 */
    const clothesSummary = clothesData
      ? {
          ...(clothesData.PrintAreaInfo
            ? {
                printArea: {
                  label: "인쇄 영역",
                  value: clothesData.PrintAreaInfo.map((item) => item.COD_NME).join("/"),
                },
              }
            : {}),
          ...(clothesData.colorInfo
            ? {
                color: {
                  label: "의류 컬러",
                  value: clothesData.colorInfo.COD_NME,
                },
              }
            : {}),
          ...(clothesData.pantoneInfo
            ? {
                pantoneColor: {
                  label: "인쇄 컬러(팬톤)",
                  value: clothesData.pantoneInfo.pantone_name,
                },
              }
            : {}),
          ...(clothesData.sizeInfo
            ? {
                size: {
                  label: "사이즈",
                  value: clothesData.sizeInfo
                    .map((item) => `${item.size.COD_NME}(${item.quantity}장)`)
                    .join(", "),
                },
              }
            : {}),
          material: {
            label: "제품명",
            value: orderData?.meterialInfo.PTT_NM,
          },
        }
      : null;

    /* 책자 제품 요약 */
    const bookSummary =
      itemGroup === "book2025_item"
        ? {
            innerInfo: {
              label: "내지 정보",
              children: [
                {
                  label: "내지 인쇄 옵션",
                  value: orderData?.inner_dosuInfo.COD_NME,
                },
                {
                  label: "내지 용지",
                  value:
                    orderData?.inner_meterialInfo.PTT_NM +
                    `${
                      orderData?.inner_meterialInfo.WGT_CD
                        ? `${+orderData?.inner_meterialInfo.WGT_CD}g`
                        : ""
                    }`,
                },
                {
                  label: "내지 장수",
                  value: orderData?.quantityInfo.prnCnt,
                },
              ],
            },
            coverInfo: {
              label: "표지 정보",
              children: [
                {
                  label: "표지 인쇄 옵션",
                  value:
                    orderData?.dosuInfo.COD_NME +
                    (orderData?.dosuInfo.BNC_GB === "BNC_COL" ? "컬러" : "흑백"),
                },
                {
                  label: "표지 용지",
                  value: orderData?.meterialInfo.MTRL_NM,
                },
              ],
            },
            ordCnt: {
              label: "수량",
              value: `${orderData?.quantityInfo.ordCnt}권`,
            },
          }
        : null;

    /* 공통 요약 항목 조합 */
    const widgetSkinInfo = productBaseInfo?.product_option.option.skinInfo,
      isCustomSize =
        orderData?.sizeInfo.DIV_NM === "사이즈직접입력" ||
        orderData?.sizeInfo.DIV_NM === "Input Size",
      sizeLabel = orderData?.sizeInfo.DIV_SEQ
        ? isCustomSize
          ? `${orderData.sizeInfo.cutSize.width}mm X ${orderData.sizeInfo.cutSize.height}mm`
          : orderData?.sizeInfo.DIV_NM
        : null,
      displayOrdCnt =
        widgetSkinInfo?.quantityGroup.view_yn === "Y" ? orderData?.quantityInfo.ordCnt : null,
      displayPrnCnt =
        widgetSkinInfo?.quantityGroup.view_yn === "Y" ? orderData?.quantityInfo.prnCnt : null;

    /* 후가공 요약 (그룹별 정리) */
    const postPcsGrouped = orderData?.pcsInfo.reduce((grouped, pcsItem) => {
        const { VIEW_YN: viewYn, PCS_GRP_NM: groupName, selectedOptions: selectedOpts } = pcsItem;
        if (viewYn === "Y" && groupName && selectedOpts[0].PCS_DTL_NM) {
          const existing = grouped[groupName];
          existing
            ? existing.push(selectedOpts[0].PCS_DTL_NM)
            : (grouped[groupName] = [selectedOpts[0].PCS_DTL_NM]);
        }
        return grouped;
      }, {}),
      postPcsSummaryItems = postPcsGrouped
        ? Object.entries(postPcsGrouped).map(([label, values]) => ({
            label: label,
            value: values.join(", "),
          }))
        : null;
    return {
      ...acrylicSummary,
      ...(!bookSummary && widgetSkinInfo?.paperSelect.view_yn === "Y"
        ? {
            material: {
              label: orderData?.meterialInfo.MTRL_TYPE === "R" ? "용지" : "자재",
              value: orderData?.meterialInfo.MTRL_NM,
            },
          }
        : {}),
      ...(widgetSkinInfo?.sizeSelect.view_yn === "Y" &&
      sizeLabel &&
      orderData?.dosuInfo.PRN_CLR_CNT !== 0
        ? {
            size: {
              label: "사이즈",
              value: sizeLabel,
            },
          }
        : {}),
      ...clothesSummary,
      ...bookSummary,
      ...(postPcsSummaryItems && postPcsSummaryItems.length > 0
        ? {
            postPcs: {
              label: "후가공/부자재",
              children: postPcsSummaryItems,
            },
          }
        : {}),
      ...(!bookSummary && !clothesSummary
        ? {
            prnCnt: {
              label: "수량",
              value: displayPrnCnt,
            },
          }
        : {}),
    };
  }

  /**
   * 에디터 편집 결과 데이터 반영
   * KOI 에디터 또는 RP 에디터에서 전달받은 데이터를 스토어에 저장
   *
   * @param {object} editorResultData - 에디터 결과 데이터
   */
  setEditorData(editorResultData) {
    if (!editorResultData) return this.editorStore.setEditorData(null);
    const enrichedData = {
        pdtCode: this.pdtCode,
        ...editorResultData,
      },
      productBaseInfo = this.getProductBaseInfo(),
      processedData =
        enrichedData.type === "KOI"
          ? processKoiEditorData(enrichedData, productBaseInfo)
          : processRpEditorData(enrichedData);
    processedData
      ? this.editorStore.setEditorData(processedData)
      : console.error(
          `[RedWidgetSDK/ERROR] 에디터에서 온 데이터가 없습니다 > 받은 데이터: ${editorResultData}`
        );
  }

  /**
   * 주문 가능 여부 검증
   * 파일 업로드 상태, 가격 계산 결과, 옵션 선택 완료 여부 등을 종합 검증
   *
   * @returns {{success: boolean, errorMessage?: string}} 검증 결과
   */
  canOrder() {
    try {
      const productBaseInfo = this.getProductBaseInfo(),
        orderData = this.getOrderData();

      /* 제품 주문 가능 상태 확인 */
      if (productBaseInfo?.product_option.option.order_yn === "N")
        throw new Error(translate("주문불가상태"));

      /* 사이즈 유효성 검증 */
      if (orderData?.validation && orderData.validation.length > 0)
        throw new Error(translate("주문불가-사이즈"));

      /* 가격 계산 결과 확인 */
      if (
        orderData?.priceCalc.result.retCode !== 200 ||
        !orderData.priceCalc.result.result_sum.PRICE
      )
        throw new Error("주문불가-가격");
      const itemGroup = productBaseInfo?.product_option.option.item_gbn,
        uploadTypeState = this.editorStore.uploadType,
        fileUploadInfo = orderData?.fileUploadInfo;

      /* 책자 제품: 내지/표지 각각 파일 또는 에디터 검증 */
      if (itemGroup === "book2025_item") {
        for (const [uploadKey, uploadValue] of Object.entries(uploadTypeState)) {
          const sectionLabel = translate(uploadKey === "inner" ? "내지" : "표지");
          if (uploadValue === "editor" && !this.editorStore.isAfterEdit(uploadKey))
            throw new Error(`[${sectionLabel}] ${translate("주문불가-에디터")}`);
          if (uploadValue === "pdf") {
            if (!fileUploadInfo) throw new Error(`[${sectionLabel}] ${translate("주문불가-파일")}`);
            if (uploadKey === "inner" && !fileUploadInfo[0])
              throw new Error(`[${sectionLabel}] ${translate("주문불가-파일")}`);
            if (uploadKey === "default" && !fileUploadInfo[1])
              throw new Error(`[${sectionLabel}] ${translate("주문불가-파일")}`);
          }
        }
        /* 내지/표지 파일명 중복 검사 */
        if (
          fileUploadInfo &&
          fileUploadInfo[0] &&
          fileUploadInfo[1] &&
          fileUploadInfo[0].org_file_nm === fileUploadInfo[1].org_file_nm
        )
          throw new Error(translate("주문불가-파일명중복"));
        return {
          success: !0,
        };
      }

      /* PDF 업로드 모드: 파일 존재 확인 */
      if (uploadTypeState.default === "pdf") {
        if (!fileUploadInfo || !fileUploadInfo[0]) throw new Error(translate("주문불가-파일"));
        if (
          itemGroup === "clothes2025_item" &&
          orderData.clothesSelectData.printType.COD === "PTP_SLK" &&
          !orderData?.clothesSelectData.pantoneInfo
        )
          throw new Error(translate("주문불가-인쇄컬러미선택"));
      }

      /* 의류 제품: 인쇄 없음이면 통과 */
      if (itemGroup === "clothes2025_item" && !orderData?.clothesSelectData.printType.COD)
        return {
          success: !0,
        };

      /* 에디터 모드: 편집 완료 확인 (인쇄 없음 제외) */
      if (
        uploadTypeState.default === "editor" &&
        !this.editorStore.isAfterEdit() &&
        orderData.dosuInfo.COD !== "SID_X"
      )
        throw new Error(translate("주문불가-에디터"));
      return {
        success: !0,
      };
    } catch (error) {
      let errorMessage = translate("주문불가상태");
      return (
        error instanceof Error && (errorMessage = error.message),
        {
          success: !1,
          errorMessage: errorMessage,
        }
      );
    }
  }

  /**
   * KOI 에디터 커스텀 탭 가격 계산
   * 에디터 내에서 자재 변경 시 실시간 가격을 재계산
   *
   * @param {object} tabData - 에디터 탭 데이터 (PAGES, MTRL_COD 등)
   * @returns {Promise<{type: string, data: number}|{errorMessage: string}>}
   */
  async getKOIEditorTabData(tabData) {
    try {
      if (!tabData) throw new Error("코이 에디터 커스텀 탭 데이터가 필요합니다");
      const productBaseInfo = this.getProductBaseInfo();
      if (!productBaseInfo) throw new Error("제품 기본 정보 가져오기 실패");
      const orderData = this.getOrderData(),
        {
          product_data: { apparel_info: apparelInfo, pdt_pcs_info: pcsInfoList },
        } = productBaseInfo;
      if (apparelInfo) {
        /* 의류 제품: 인쇄 영역별 가격 계산 */
        const printAreaPcsList = tabData.PAGES.map((pageName) => ({
            PCS_COD: "PDT_WRK",
            PCS_DTL_COD:
              apparelInfo.print_area.find((area) => area.KOI_NME === pageName)?.COD || "",
          })),
          matchedMaterial = pcsInfoList.find((pcsItem) => pcsItem.MTRL_CD === tabData.MTRL_COD);
        if (!matchedMaterial) throw new Error("선택된 제품 자재 코드가 없습니다.");
        const materialPcsEntry = {
            PCS_COD: matchedMaterial.PCS_CD,
            PCS_DTL_COD: matchedMaterial.PCS_DTL_CD,
            ATTB: orderData?.quantityInfo.prnCnt,
          },
          previousPriceParams = this.getOrderData()?.priceCalc.params;
        if (!previousPriceParams) throw new Error("이전 가격 페이로드 가져오기 실패");
        const updatedOrderInfo = [
            {
              ...previousPriceParams.ORD_INFO[0],
              MTRL_CD: tabData.MTRL_COD,
            },
          ],
          updatedPcsInfo = [
            ...previousPriceParams.PCS_INFO.filter(
              (item) => item.PCS_COD !== "DIR_MTR" && item.PCS_COD !== "PDT_WRK"
            ),
            ...printAreaPcsList,
            materialPcsEntry,
          ],
          priceRequestPayload = {
            ...previousPriceParams,
            ORD_INFO: updatedOrderInfo,
            PCS_INFO: updatedPcsInfo,
          },
          priceResult = await fetchPriceCalculation({
            type: "COMMON",
            body: priceRequestPayload,
          });
        if (priceResult.errorMessage || !priceResult.result)
          throw new Error(priceResult.errorMessage);
        const {
          ORG_PRICE: orgPrice,
          ORG_PRICE_VAT: orgPriceVat,
          PRICE: discountPrice,
          PRICE_VAT: discountPriceVat,
          PRICE_MALL: mallPrice,
          PRICE_MALL_VAT: mallPriceVat,
        } = priceResult.result.result_sum;
        return {
          type: "PRICE",
          data:
            discountPrice !== mallPrice
              ? mallPrice + mallPriceVat
              : orgPrice !== discountPrice
              ? discountPrice + discountPriceVat
              : orgPrice + orgPriceVat,
        };
      }
    } catch (error) {
      return (
        console.error("[RedWidgetSDK/ERROR] 코이에디터 데이터 산정 실패 > ", error),
        {
          errorMessage: "데이터 산정 실패",
        }
      );
    }
  }
}

// ============================================================================
// 섹션 25: AccWidgetInstance($1) — 부자재 제품 인스턴스
// ============================================================================

/**
 * AccWidgetInstance 클래스 (원본: $1)
 * 부자재 제품(금속 명함, 스탬프, 소모품 등)의 위젯 인스턴스
 * CommonWidgetInstance의 간소화 버전
 */
/**
 * 부자재(ACC) 제품용 위젯 인스턴스. getSummary·canOrder(부자재 옵션·가격 검증) 제공.
 */
class AccWidgetInstance {
  constructor(config) {
    this.pdtCode = config.pdtCode;
  }
  pdtCode = "";
  orderStore = useAccOrderStore();
  productStore = useProductStore();
  getProductBaseInfo() {
    return this.productStore.getProductBaseInfo();
  }
  getOrderData() {
    return this.orderStore.getOrderData();
  }

  /**
   * 부자재 주문 요약 생성
   * 부자재별 수량과 합계 금액을 계산
   */
  getSummary() {
    const productBaseInfo = this.getProductBaseInfo(),
      orderData = this.getOrderData();
    if (!orderData?.subMtrlInfo)
      return {
        errorMessage: translate("주문불가-옵션미선택"),
      };
    const itemList = [];
    let totalQuantity = 0;
    for (const subMaterial of orderData.subMtrlInfo)
      itemList?.push({
        label: subMaterial.MTRL_NME,
        value: subMaterial.QTY,
      }),
        (totalQuantity += subMaterial.QTY);
    const priceSum = orderData.priceCalc.result.result_sum,
      hasMallDiscount = priceSum.PRICE !== priceSum.PRICE_MALL,
      hasDiscount = priceSum.ORG_PRICE !== priceSum.PRICE,
      totalAmount = hasMallDiscount
        ? priceSum.PRICE_MALL + priceSum.PRICE_MALL_VAT
        : hasDiscount
        ? priceSum.PRICE + priceSum.PRICE_VAT
        : priceSum.ORG_PRICE + priceSum.ORG_PRICE_VAT;
    return {
      product: {
        label: "제품명",
        value: productBaseInfo?.product_option.option.pdt_nme,
      },
      qty: {
        label: `수량 (총 수량: ${totalQuantity})`,
        children: itemList,
      },
      amount: {
        label: "합계",
        value: `${totalAmount.toLocaleString()}원`,
      },
    };
  }

  /**
   * 부자재 주문 가능 여부 검증
   */
  canOrder() {
    try {
      if (this.getProductBaseInfo()?.product_option.option.order_yn === "N")
        throw new Error(translate("주문불가상태"));
      const orderData = this.getOrderData();
      if (!orderData?.subMtrlInfo) throw new Error(translate("주문불가-옵션미선택"));
      if (!orderData?.priceCalc.result.result_sum.PRICE)
        throw new Error(translate("주문불가-가격"));
      return {
        success: !0,
      };
    } catch (error) {
      let errorMessage = translate("주문불가상태");
      return (
        error instanceof Error && (errorMessage = error.message),
        {
          success: !1,
          errorMessage: errorMessage,
        }
      );
    }
  }
}

// ============================================================================
// 섹션 26: Shadow DOM CSS 링크 삽입 헬퍼
// ============================================================================

/**
 * Shadow DOM에 외부 CSS 스타일시트 링크를 삽입
 * widget.css를 Shadow DOM 내에 로드하여 스타일 적용
 *
 * @param {ShadowRoot} shadowRoot - Shadow DOM 루트
 * @param {string} cssUrl - CSS 파일 URL
 */
/**
 * Shadow DOM에 외부 CSS(widget.css) 스타일시트 link 요소를 삽입해 위젯 스타일 적용.
 */
function appendStylesheetToShadow(shadowRoot, cssUrl) {
  const linkElement = document.createElement("link");
  (linkElement.rel = "stylesheet"),
    (linkElement.href = cssUrl),
    shadowRoot.appendChild(linkElement);
}
