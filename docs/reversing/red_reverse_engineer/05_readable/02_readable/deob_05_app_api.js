/**
 * ============================================================================
 * RedPrinting Widget SDK — 애플리케이션 유틸리티 및 API 레이어
 * ============================================================================
 * 원본 파일: mod_05_app_api.js (2685 lines)
 * 역할: 애플리케이션 유틸리티, API 통신, S3 업로드, 가격 계산, 에러 처리
 *
 * 주요 기능:
 * - Lodash 유틸리티 (debounce, isEmpty 등) 번들 포함
 * - 제품 정보 API 호출 (/ko/product/get_digital_product_info)
 * - 가격 계산 API 호출 (/ko/product_price/get_ajax_price_vTmpl)
 * - S3 파일 업로드 (presigned URL 방식)
 * - 다국어 번역 사전 (한국어/영어)
 * - Pinia 스토어 정의 (config, product, order, exterior, acc-order)
 * - RedWidgetSDK 클래스 (F1) 및 인스턴스 관리 클래스 (L1, $1)
 * ============================================================================
 */

// ============================================================================
// 섹션 1: 글로벌 환경 감지 및 유틸리티 기반
// ============================================================================

/**
 * 글로벌 객체 참조
 * globalThis, window, global, self 중 사용 가능한 것을 선택
 */
var globalReference =
  typeof globalThis < "u"
    ? globalThis
    : typeof window < "u"
    ? window
    : typeof global < "u"
    ? global
    : typeof self < "u"
    ? self
    : {};

/**
 * ES 모듈 기본 내보내기(default export) 추출 함수
 * @param {object} moduleObj - ES 모듈 객체
 * @returns {*} 기본 내보내기 값
 */
/**
 * ES 모듈 객체에서 default export를 안전하게 추출(interop). __esModule 플래그가 있으면 .default, 아니면 객체 자체를 반환.
 */
function extractDefaultExport(moduleObj) {
  return moduleObj &&
    moduleObj.__esModule &&
    Object.prototype.hasOwnProperty.call(moduleObj, "default")
    ? moduleObj.default
    : moduleObj;
}

// ============================================================================
// 섹션 2: Lodash 유틸리티 함수 번들 (isObject, debounce, isEmpty 등)
// ============================================================================

/** isObject 모듈 캐시 */
var isObjectResult, isObjectInitialized;

/**
 * isObject — 값이 객체(object 또는 function)인지 판별
 * Lodash의 isObject와 동일한 기능
 * @returns {function} isObject 함수
 */
/**
 * Lodash isObject 지연 초기화 게터 — 값이 object 또는 function인지 판별하는 함수를 캐시 후 반환.
 */
function getIsObject() {
  if (isObjectInitialized) return isObjectResult;
  isObjectInitialized = 1;

  /**
   * 값이 객체 타입인지 확인
   * @param {*} value - 검사할 값
   * @returns {boolean} 객체 여부
   */
  function isObject(value) {
    var typeOfValue = typeof value;
    return value != null && (typeOfValue == "object" || typeOfValue == "function");
  }
  return (isObjectResult = isObject), isObjectResult;
}

/** freeGlobal 모듈 캐시 */
var freeGlobalResult, freeGlobalInitialized;

/**
 * Node.js 환경에서의 글로벌 객체 감지
 * @returns {object|boolean} Node.js global 객체 또는 false
 */
function getFreeGlobal() {
  if (freeGlobalInitialized) return freeGlobalResult;
  freeGlobalInitialized = 1;
  var freeGlobal =
    typeof globalReference == "object" &&
    globalReference &&
    globalReference.Object === Object &&
    globalReference;
  return (freeGlobalResult = freeGlobal), freeGlobalResult;
}

/** root 모듈 캐시 (글로벌 루트 객체) */
var rootObjectResult, rootObjectInitialized;

/**
 * 런타임 루트 객체 반환 (브라우저: window, Node: global)
 * @returns {object} 루트 글로벌 객체
 */
/**
 * 런타임 루트 글로벌 객체(브라우저 window / Node global)를 감지해 반환. 모든 네이티브 참조(Map/Set/Promise 등)의 기준점.
 */
function getRootObject() {
  if (rootObjectInitialized) return rootObjectResult;
  rootObjectInitialized = 1;
  var freeGlobal = getFreeGlobal(),
    freeSelf = typeof self == "object" && self && self.Object === Object && self,
    rootObj = freeGlobal || freeSelf || Function("return this")();
  return (rootObjectResult = rootObj), rootObjectResult;
}

/** Date.now 래퍼 캐시 */
var dateNowResult, dateNowInitialized;

/**
 * Date.now() 래퍼 함수 반환
 * @returns {function} 현재 타임스탬프 반환 함수
 */
function getDateNow() {
  if (dateNowInitialized) return dateNowResult;
  dateNowInitialized = 1;
  var rootObj = getRootObject(),
    dateNowFn = function () {
      return rootObj.Date.now();
    };
  return (dateNowResult = dateNowFn), dateNowResult;
}

/** trimmedEndIndex 캐시 */
var trimmedEndIndexResult, trimmedEndIndexInitialized;

/**
 * 문자열 끝의 공백을 제거한 인덱스 반환
 * @returns {function} trimmedEndIndex 함수
 */
function getTrimmedEndIndex() {
  if (trimmedEndIndexInitialized) return trimmedEndIndexResult;
  trimmedEndIndexInitialized = 1;
  var whitespaceRegex = /\s/;

  /**
   * @param {string} str - 대상 문자열
   * @returns {number} 공백 제거 후 마지막 인덱스
   */
  function trimmedEndIndex(str) {
    for (var index = str.length; index-- && whitespaceRegex.test(str.charAt(index)); );
    return index;
  }
  return (trimmedEndIndexResult = trimmedEndIndex), trimmedEndIndexResult;
}

/** baseTrim 캐시 */
var baseTrimResult, baseTrimInitialized;

/**
 * 문자열 앞뒤 공백 제거 (내부용)
 * @returns {function} baseTrim 함수
 */
function getBaseTrim() {
  if (baseTrimInitialized) return baseTrimResult;
  baseTrimInitialized = 1;
  var trimmedEndIndex = getTrimmedEndIndex(),
    leadingWhitespace = /^\s+/;
  function baseTrim(str) {
    return str && str.slice(0, trimmedEndIndex(str) + 1).replace(leadingWhitespace, "");
  }
  return (baseTrimResult = baseTrim), baseTrimResult;
}

/** Symbol 참조 캐시 */
var symbolRefResult, symbolRefInitialized;

/**
 * 네이티브 Symbol 참조 반환
 * @returns {Symbol} Symbol 생성자
 */
function getSymbolRef() {
  if (symbolRefInitialized) return symbolRefResult;
  symbolRefInitialized = 1;
  var rootObj = getRootObject(),
    SymbolRef = rootObj.Symbol;
  return (symbolRefResult = SymbolRef), symbolRefResult;
}

/** getRawTag 캐시 */
var getRawTagResult, getRawTagInitialized;

/**
 * Symbol.toStringTag를 사용한 객체 태그 추출
 * @returns {function} getRawTag 함수
 */
function initGetRawTag() {
  if (getRawTagInitialized) return getRawTagResult;
  getRawTagInitialized = 1;
  var SymbolRef = getSymbolRef(),
    objectProto = Object.prototype,
    hasOwnProperty = objectProto.hasOwnProperty,
    objectToString = objectProto.toString,
    symToStringTag = SymbolRef ? SymbolRef.toStringTag : void 0;
  function getRawTag(value) {
    var isOwn = hasOwnProperty.call(value, symToStringTag),
      tag = value[symToStringTag];
    try {
      value[symToStringTag] = void 0;
      var unmasked = !0;
    } catch {}
    var result = objectToString.call(value);
    return (
      unmasked && (isOwn ? (value[symToStringTag] = tag) : delete value[symToStringTag]), result
    );
  }
  return (getRawTagResult = getRawTag), getRawTagResult;
}

/** objectToString 캐시 */
var objectToStringResult, objectToStringInitialized;

/**
 * Object.prototype.toString 래퍼
 * @returns {function} objectToString 함수
 */
function initObjectToString() {
  if (objectToStringInitialized) return objectToStringResult;
  objectToStringInitialized = 1;
  var objectProto = Object.prototype,
    nativeToString = objectProto.toString;
  function objectToString(value) {
    return nativeToString.call(value);
  }
  return (objectToStringResult = objectToString), objectToStringResult;
}

/** baseGetTag 캐시 */
var baseGetTagResult, baseGetTagInitialized;

/**
 * 객체의 내부 [[Class]] 태그 반환 (예: "[object Function]")
 * @returns {function} baseGetTag 함수
 */
/**
 * 객체의 내부 [[Class]] 태그('[object Function]' 등) 추출 함수를 캐시 후 반환. Symbol.toStringTag 우선 사용.
 */
function getBaseGetTag() {
  if (baseGetTagInitialized) return baseGetTagResult;
  baseGetTagInitialized = 1;
  var SymbolRef = getSymbolRef(),
    getRawTag = initGetRawTag(),
    objectToString = initObjectToString(),
    NULL_TAG = "[object Null]",
    UNDEFINED_TAG = "[object Undefined]",
    symToStringTag = SymbolRef ? SymbolRef.toStringTag : void 0;

  /**
   * @param {*} value - 태그를 추출할 값
   * @returns {string} 내부 태그 문자열
   */
  function baseGetTag(value) {
    return value == null
      ? value === void 0
        ? UNDEFINED_TAG
        : NULL_TAG
      : symToStringTag && symToStringTag in Object(value)
      ? getRawTag(value)
      : objectToString(value);
  }
  return (baseGetTagResult = baseGetTag), baseGetTagResult;
}

/** isObjectLike 캐시 */
var isObjectLikeResult, isObjectLikeInitialized;

/**
 * 값이 객체-유사(object-like)인지 판별 (null이 아니고 typeof === "object")
 * @returns {function} isObjectLike 함수
 */
function getIsObjectLike() {
  if (isObjectLikeInitialized) return isObjectLikeResult;
  isObjectLikeInitialized = 1;
  function isObjectLike(value) {
    return value != null && typeof value == "object";
  }
  return (isObjectLikeResult = isObjectLike), isObjectLikeResult;
}

/** isSymbol 캐시 */
var isSymbolResult, isSymbolInitialized;

/**
 * 값이 Symbol 타입인지 판별
 * @returns {function} isSymbol 함수
 */
function initIsSymbol() {
  if (isSymbolInitialized) return isSymbolResult;
  isSymbolInitialized = 1;
  var baseGetTag = getBaseGetTag(),
    isObjectLike = getIsObjectLike(),
    SYMBOL_TAG = "[object Symbol]";
  function isSymbol(value) {
    return typeof value == "symbol" || (isObjectLike(value) && baseGetTag(value) == SYMBOL_TAG);
  }
  return (isSymbolResult = isSymbol), isSymbolResult;
}

/** toNumber 캐시 */
var toNumberResult, toNumberInitialized;

/**
 * 값을 숫자로 변환 (Lodash toNumber)
 * @returns {function} toNumber 함수
 */
function initToNumber() {
  if (toNumberInitialized) return toNumberResult;
  toNumberInitialized = 1;
  var baseTrim = getBaseTrim(),
    isObject = getIsObject(),
    isSymbol = initIsSymbol(),
    NAN_VALUE = NaN,
    HEX_REGEX = /^[-+]0x[0-9a-f]+$/i,
    BINARY_REGEX = /^0b[01]+$/i,
    OCTAL_REGEX = /^0o[0-7]+$/i,
    nativeParseInt = parseInt;

  /**
   * 값을 숫자로 변환
   * @param {*} value - 변환할 값
   * @returns {number} 변환된 숫자
   */
  function toNumber(value) {
    if (typeof value == "number") return value;
    if (isSymbol(value)) return NAN_VALUE;
    if (isObject(value)) {
      var other = typeof value.valueOf == "function" ? value.valueOf() : value;
      value = isObject(other) ? other + "" : other;
    }
    if (typeof value != "string") return value === 0 ? value : +value;
    value = baseTrim(value);
    var isBinary = BINARY_REGEX.test(value);
    return isBinary || OCTAL_REGEX.test(value)
      ? nativeParseInt(value.slice(2), isBinary ? 2 : 8)
      : HEX_REGEX.test(value)
      ? NAN_VALUE
      : +value;
  }
  return (toNumberResult = toNumber), toNumberResult;
}

/** debounce 캐시 */
var debounceResult, debounceInitialized;

/**
 * debounce 함수 생성기 (Lodash debounce)
 * 연속 호출을 지연시켜 마지막 호출만 실행
 * @returns {function} debounce 함수
 */
/**
 * Lodash debounce 구현 게터. leading/trailing/maxWait 옵션 지원. 위젯에서 옵션 변경 시 가격 API 호출 빈도 제한에 사용.
 */
function initDebounce() {
  if (debounceInitialized) return debounceResult;
  debounceInitialized = 1;
  var isObject = getIsObject(),
    dateNow = getDateNow(),
    toNumber = initToNumber(),
    FUNC_ERROR_TEXT = "Expected a function",
    mathMax = Math.max,
    mathMin = Math.min;

  /**
   * 함수 호출을 지연시키는 debounce 래퍼 생성
   * @param {function} func - 디바운스할 함수
   * @param {number} waitMs - 대기 시간(ms)
   * @param {object} options - 옵션 (leading, maxWait, trailing)
   * @returns {function} 디바운스된 함수
   */
  function debounce(func, waitMs, options) {
    var lastArgs,
      lastThis,
      maxWaitMs,
      lastResult,
      timerId,
      lastCallTime,
      lastInvokeTime = 0,
      isLeading = !1,
      hasMaxWait = !1,
      isTrailing = !0;
    if (typeof func != "function") throw new TypeError(FUNC_ERROR_TEXT);
    (waitMs = toNumber(waitMs) || 0),
      isObject(options) &&
        ((isLeading = !!options.leading),
        (hasMaxWait = "maxWait" in options),
        (maxWaitMs = hasMaxWait ? mathMax(toNumber(options.maxWait) || 0, waitMs) : maxWaitMs),
        (isTrailing = "trailing" in options ? !!options.trailing : isTrailing));

    /**
     * 함수 실제 실행
     * @param {number} time - 현재 타임스탬프
     * @returns {*} 함수 실행 결과
     */
    function invokeFunc(time) {
      var args = lastArgs,
        thisArg = lastThis;
      return (
        (lastArgs = lastThis = void 0),
        (lastInvokeTime = time),
        (lastResult = func.apply(thisArg, args)),
        lastResult
      );
    }

    /** leading edge에서 실행 시작 */
    function leadingEdge(time) {
      (lastInvokeTime = time),
        (timerId = setTimeout(timerExpired, waitMs)),
        isLeading ? invokeFunc(time) : lastResult;
    }

    /** 남은 대기 시간 계산 */
    function remainingWait(time) {
      var timeSinceLastCall = time - lastCallTime,
        timeSinceLastInvoke = time - lastInvokeTime,
        timeWaiting = waitMs - timeSinceLastCall;
      return hasMaxWait ? mathMin(timeWaiting, maxWaitMs - timeSinceLastInvoke) : timeWaiting;
    }

    /** 호출 가능 여부 판단 */
    function shouldInvoke(time) {
      var timeSinceLastCall = time - lastCallTime,
        timeSinceLastInvoke = time - lastInvokeTime;
      return (
        lastCallTime === void 0 ||
        timeSinceLastCall >= waitMs ||
        timeSinceLastCall < 0 ||
        (hasMaxWait && timeSinceLastInvoke >= maxWaitMs)
      );
    }

    /** 타이머 만료 콜백 */
    function timerExpired() {
      var time = dateNow();
      if (shouldInvoke(time)) return trailingEdge(time);
      timerId = setTimeout(timerExpired, remainingWait(time));
    }

    /** trailing edge에서 실행 */
    function trailingEdge(time) {
      return (
        (timerId = void 0),
        isTrailing && lastArgs ? invokeFunc(time) : ((lastArgs = lastThis = void 0), lastResult)
      );
    }

    /** debounce 취소 */
    function cancel() {
      timerId !== void 0 && clearTimeout(timerId),
        (lastInvokeTime = 0),
        (lastArgs = lastCallTime = lastThis = timerId = void 0);
    }

    /** 즉시 실행(flush) */
    function flush() {
      return timerId === void 0 ? lastResult : trailingEdge(dateNow());
    }

    /** 디바운스된 함수 본체 */
    function debounced() {
      var time = dateNow(),
        canInvoke = shouldInvoke(time);
      if (((lastArgs = arguments), (lastThis = this), (lastCallTime = time), canInvoke)) {
        if (timerId === void 0) return leadingEdge(lastCallTime);
        if (hasMaxWait)
          return (
            clearTimeout(timerId),
            (timerId = setTimeout(timerExpired, waitMs)),
            invokeFunc(lastCallTime)
          );
      }
      return timerId === void 0 && (timerId = setTimeout(timerExpired, waitMs)), lastResult;
    }
    return (debounced.cancel = cancel), (debounced.flush = flush), debounced;
  }
  return (debounceResult = debounce), debounceResult;
}

/** debounce 함수 인스턴스 */
var debounceFnWrapper = initDebounce();

/**
 * debounce 유틸리티 — 함수 호출 빈도 제한
 * 옵션 변경 시 가격 API 호출 빈도를 조절하는 데 사용
 */
const debounce = extractDefaultExport(debounceFnWrapper);

// ============================================================================
// 섹션 3: Lodash isPrototype, nativeKeysIn, baseKeys
// ============================================================================

/** isPrototype 캐시 */
var isPrototypeResult, isPrototypeInitialized;

/**
 * 프로토타입 객체 여부 판별 (내부용)
 * @returns {function} isPrototype 함수
 */
function initIsPrototype() {
  if (isPrototypeInitialized) return isPrototypeResult;
  isPrototypeInitialized = 1;
  var objectProto = Object.prototype;
  function isPrototype(value) {
    var Ctor = value && value.constructor,
      proto = (typeof Ctor == "function" && Ctor.prototype) || objectProto;
    return value === proto;
  }
  return (isPrototypeResult = isPrototype), isPrototypeResult;
}

/** overArg 캐시 */
var overArgResult, overArgInitialized;

/**
 * 함수 인자를 변환하는 고차 함수 (내부용)
 * @returns {function} overArg 함수
 */
function initOverArg() {
  if (overArgInitialized) return overArgResult;
  overArgInitialized = 1;
  function overArg(func, transform) {
    return function (arg) {
      return func(transform(arg));
    };
  }
  return (overArgResult = overArg), overArgResult;
}

/** nativeKeys 캐시 */
var nativeKeysResult, nativeKeysInitialized;

/**
 * Object.keys 래퍼
 * @returns {function} nativeKeys 함수
 */
function initNativeKeys() {
  if (nativeKeysInitialized) return nativeKeysResult;
  nativeKeysInitialized = 1;
  var overArg = initOverArg(),
    nativeKeys = overArg(Object.keys, Object);
  return (nativeKeysResult = nativeKeys), nativeKeysResult;
}

/** baseKeys 캐시 */
var baseKeysResult, baseKeysInitialized;

/**
 * 객체의 열거 가능한 키 목록 반환 (내부용)
 * @returns {function} baseKeys 함수
 */
function initBaseKeys() {
  if (baseKeysInitialized) return baseKeysResult;
  baseKeysInitialized = 1;
  var isPrototype = initIsPrototype(),
    nativeKeys = initNativeKeys(),
    objectProto = Object.prototype,
    hasOwnProperty = objectProto.hasOwnProperty;
  function baseKeys(object) {
    if (!isPrototype(object)) return nativeKeys(object);
    var result = [];
    for (var key in Object(object))
      hasOwnProperty.call(object, key) && key != "constructor" && result.push(key);
    return result;
  }
  return (baseKeysResult = baseKeys), baseKeysResult;
}

// ============================================================================
// 섹션 4: Lodash isFunction, coreJsData, isMasked, toSource
// ============================================================================

/** isFunction 캐시 */
var isFunctionResult, isFunctionInitialized;

/**
 * 값이 함수인지 판별
 * @returns {function} isFunction 함수
 */
function initIsFunction() {
  if (isFunctionInitialized) return isFunctionResult;
  isFunctionInitialized = 1;
  var baseGetTag = getBaseGetTag(),
    isObject = getIsObject(),
    ASYNC_TAG = "[object AsyncFunction]",
    FUNC_TAG = "[object Function]",
    GEN_TAG = "[object GeneratorFunction]",
    PROXY_TAG = "[object Proxy]";
  function isFunction(value) {
    if (!isObject(value)) return !1;
    var tag = baseGetTag(value);
    return tag == FUNC_TAG || tag == GEN_TAG || tag == ASYNC_TAG || tag == PROXY_TAG;
  }
  return (isFunctionResult = isFunction), isFunctionResult;
}

/** coreJsData 캐시 */
var coreJsDataResult, coreJsDataInitialized;

/**
 * core-js 공유 데이터 접근
 * @returns {object} core-js 공유 객체
 */
function initCoreJsData() {
  if (coreJsDataInitialized) return coreJsDataResult;
  coreJsDataInitialized = 1;
  var rootObj = getRootObject(),
    coreJsData = rootObj["__core-js_shared__"];
  return (coreJsDataResult = coreJsData), coreJsDataResult;
}

/** isMasked 캐시 */
var isMaskedResult, isMaskedInitialized;

/**
 * core-js에 의해 마스킹된 함수인지 확인
 * @returns {function} isMasked 함수
 */
function initIsMasked() {
  if (isMaskedInitialized) return isMaskedResult;
  isMaskedInitialized = 1;
  var coreJsData = initCoreJsData(),
    maskSrcKey = (function () {
      var uid = /[^.]+$/.exec((coreJsData && coreJsData.keys && coreJsData.keys.IE_PROTO) || "");
      return uid ? "Symbol(src)_1." + uid : "";
    })();
  function isMasked(func) {
    return !!maskSrcKey && maskSrcKey in func;
  }
  return (isMaskedResult = isMasked), isMaskedResult;
}

/** toSource 캐시 */
var toSourceResult, toSourceInitialized;

/**
 * 함수를 문자열로 변환
 * @returns {function} toSource 함수
 */
function initToSource() {
  if (toSourceInitialized) return toSourceResult;
  toSourceInitialized = 1;
  var funcProto = Function.prototype,
    funcToString = funcProto.toString;
  function toSource(func) {
    if (func != null) {
      try {
        return funcToString.call(func);
      } catch {}
      try {
        return func + "";
      } catch {}
    }
    return "";
  }
  return (toSourceResult = toSource), toSourceResult;
}

// ============================================================================
// 섹션 5: Lodash baseIsNative, getValue, getNative
// ============================================================================

/** baseIsNative 캐시 */
var baseIsNativeResult, baseIsNativeInitialized;

/**
 * 네이티브 함수 여부 판별 (내부용)
 * @returns {function} baseIsNative 함수
 */
function initBaseIsNative() {
  if (baseIsNativeInitialized) return baseIsNativeResult;
  baseIsNativeInitialized = 1;
  var isFunction = initIsFunction(),
    isMasked = initIsMasked(),
    isObject = getIsObject(),
    toSource = initToSource(),
    reRegExpChar = /[\\^$.*+?()[\]{}|]/g,
    reIsHostCtor = /^\[object .+?Constructor\]$/,
    funcProto = Function.prototype,
    objectProto = Object.prototype,
    funcToString = funcProto.toString,
    hasOwnProperty = objectProto.hasOwnProperty,
    reIsNative = RegExp(
      "^" +
        funcToString
          .call(hasOwnProperty)
          .replace(reRegExpChar, "\\$&")
          .replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") +
        "$"
    );
  function baseIsNative(value) {
    if (!isObject(value) || isMasked(value)) return !1;
    var pattern = isFunction(value) ? reIsNative : reIsHostCtor;
    return pattern.test(toSource(value));
  }
  return (baseIsNativeResult = baseIsNative), baseIsNativeResult;
}

/** getValue 캐시 */
var getValueResult, getValueInitialized;

/**
 * 객체에서 키로 값을 안전하게 추출
 * @returns {function} getValue 함수
 */
function initGetValue() {
  if (getValueInitialized) return getValueResult;
  getValueInitialized = 1;
  function getValue(object, key) {
    return object?.[key];
  }
  return (getValueResult = getValue), getValueResult;
}

/** getNative 캐시 */
var getNativeResult, getNativeInitialized;

/**
 * 네이티브 함수 참조를 안전하게 획득
 * @returns {function} getNative 함수
 */
/**
 * 객체에서 키로 네이티브 함수 참조를 안전 획득(소스 패턴 검사로 폴리필/래핑 배제). DataView·Map·Set·WeakMap 감지 기반.
 */
function getNative() {
  if (getNativeInitialized) return getNativeResult;
  getNativeInitialized = 1;
  var baseIsNative = initBaseIsNative(),
    getValue = initGetValue();
  function getNativeFn(object, key) {
    var value = getValue(object, key);
    return baseIsNative(value) ? value : void 0;
  }
  return (getNativeResult = getNativeFn), getNativeResult;
}

// ============================================================================
// 섹션 6: Lodash DataView, Map, Promise, Set, WeakMap, getTag
// ============================================================================

/** DataView 캐시 */
var dataViewResult, dataViewInitialized;
function initDataView() {
  if (dataViewInitialized) return dataViewResult;
  dataViewInitialized = 1;
  var getNativeFn = getNative(),
    rootObj = getRootObject(),
    DataView = getNativeFn(rootObj, "DataView");
  return (dataViewResult = DataView), dataViewResult;
}

/** Map 캐시 */
var mapResult, mapInitialized;
function initMap() {
  if (mapInitialized) return mapResult;
  mapInitialized = 1;
  var getNativeFn = getNative(),
    rootObj = getRootObject(),
    MapRef = getNativeFn(rootObj, "Map");
  return (mapResult = MapRef), mapResult;
}

/** Promise 캐시 */
var promiseResult, promiseInitialized;
function initPromise() {
  if (promiseInitialized) return promiseResult;
  promiseInitialized = 1;
  var getNativeFn = getNative(),
    rootObj = getRootObject(),
    PromiseRef = getNativeFn(rootObj, "Promise");
  return (promiseResult = PromiseRef), promiseResult;
}

/** Set 캐시 */
var setResult, setInitialized;
function initSet() {
  if (setInitialized) return setResult;
  setInitialized = 1;
  var getNativeFn = getNative(),
    rootObj = getRootObject(),
    SetRef = getNativeFn(rootObj, "Set");
  return (setResult = SetRef), setResult;
}

/** WeakMap 캐시 */
var weakMapResult, weakMapInitialized;
function initWeakMap() {
  if (weakMapInitialized) return weakMapResult;
  weakMapInitialized = 1;
  var getNativeFn = getNative(),
    rootObj = getRootObject(),
    WeakMapRef = getNativeFn(rootObj, "WeakMap");
  return (weakMapResult = WeakMapRef), weakMapResult;
}

/** getTag 캐시 — 컬렉션 타입 감지 (Map, Set 등) */
var getTagResult, getTagInitialized;

/**
 * 정확한 객체 타입 태그 반환 (Map, Set, Promise 등 구분)
 * @returns {function} getTag 함수
 */
function initGetTag() {
  if (getTagInitialized) return getTagResult;
  getTagInitialized = 1;
  var DataView = initDataView(),
    MapRef = initMap(),
    PromiseRef = initPromise(),
    SetRef = initSet(),
    WeakMapRef = initWeakMap(),
    baseGetTag = getBaseGetTag(),
    toSource = initToSource(),
    MAP_TAG = "[object Map]",
    OBJECT_TAG = "[object Object]",
    PROMISE_TAG = "[object Promise]",
    SET_TAG = "[object Set]",
    WEAKMAP_TAG = "[object WeakMap]",
    DATAVIEW_TAG = "[object DataView]",
    dataViewCtorString = toSource(DataView),
    mapCtorString = toSource(MapRef),
    promiseCtorString = toSource(PromiseRef),
    setCtorString = toSource(SetRef),
    weakMapCtorString = toSource(WeakMapRef),
    getTag = baseGetTag;
  return (
    ((DataView && getTag(new DataView(new ArrayBuffer(1))) != DATAVIEW_TAG) ||
      (MapRef && getTag(new MapRef()) != MAP_TAG) ||
      (PromiseRef && getTag(PromiseRef.resolve()) != PROMISE_TAG) ||
      (SetRef && getTag(new SetRef()) != SET_TAG) ||
      (WeakMapRef && getTag(new WeakMapRef()) != WEAKMAP_TAG)) &&
      (getTag = function (value) {
        var result = baseGetTag(value),
          Ctor = result == OBJECT_TAG ? value.constructor : void 0,
          ctorString = Ctor ? toSource(Ctor) : "";
        if (ctorString)
          switch (ctorString) {
            case dataViewCtorString:
              return DATAVIEW_TAG;
            case mapCtorString:
              return MAP_TAG;
            case promiseCtorString:
              return PROMISE_TAG;
            case setCtorString:
              return SET_TAG;
            case weakMapCtorString:
              return WEAKMAP_TAG;
          }
        return result;
      }),
    (getTagResult = getTag),
    getTagResult
  );
}

// ============================================================================
// 섹션 7: Lodash isArguments, isArray, isLength, isArrayLike, isBuffer
// ============================================================================

/** isArguments 기본 */
var baseIsArgumentsResult, baseIsArgumentsInitialized;
function initBaseIsArguments() {
  if (baseIsArgumentsInitialized) return baseIsArgumentsResult;
  baseIsArgumentsInitialized = 1;
  var baseGetTag = getBaseGetTag(),
    isObjectLike = getIsObjectLike(),
    ARGS_TAG = "[object Arguments]";
  function baseIsArguments(value) {
    return isObjectLike(value) && baseGetTag(value) == ARGS_TAG;
  }
  return (baseIsArgumentsResult = baseIsArguments), baseIsArgumentsResult;
}

/** isArguments 캐시 */
var isArgumentsResult, isArgumentsInitialized;
function initIsArguments() {
  if (isArgumentsInitialized) return isArgumentsResult;
  isArgumentsInitialized = 1;
  var baseIsArguments = initBaseIsArguments(),
    isObjectLike = getIsObjectLike(),
    objectProto = Object.prototype,
    hasOwnProperty = objectProto.hasOwnProperty,
    propertyIsEnumerable = objectProto.propertyIsEnumerable,
    isArguments = baseIsArguments(
      (function () {
        return arguments;
      })()
    )
      ? baseIsArguments
      : function (value) {
          return (
            isObjectLike(value) &&
            hasOwnProperty.call(value, "callee") &&
            !propertyIsEnumerable.call(value, "callee")
          );
        };
  return (isArgumentsResult = isArguments), isArgumentsResult;
}

/** isArray 캐시 */
var isArrayResult, isArrayInitialized;
function initIsArray() {
  if (isArrayInitialized) return isArrayResult;
  isArrayInitialized = 1;
  var nativeIsArray = Array.isArray;
  return (isArrayResult = nativeIsArray), isArrayResult;
}

/** isLength 캐시 */
var isLengthResult, isLengthInitialized;
function initIsLength() {
  if (isLengthInitialized) return isLengthResult;
  isLengthInitialized = 1;
  var MAX_SAFE_INTEGER = 9007199254740991;
  function isLength(value) {
    return typeof value == "number" && value > -1 && value % 1 == 0 && value <= MAX_SAFE_INTEGER;
  }
  return (isLengthResult = isLength), isLengthResult;
}

/** isArrayLike 캐시 */
var isArrayLikeResult, isArrayLikeInitialized;
function initIsArrayLike() {
  if (isArrayLikeInitialized) return isArrayLikeResult;
  isArrayLikeInitialized = 1;
  var isFunction = initIsFunction(),
    isLength = initIsLength();
  function isArrayLike(value) {
    return value != null && isLength(value.length) && !isFunction(value);
  }
  return (isArrayLikeResult = isArrayLike), isArrayLikeResult;
}

/** isBuffer 모듈 */
var bufferModule = {
    exports: {},
  },
  stubFalseResult,
  stubFalseInitialized;
function initStubFalse() {
  if (stubFalseInitialized) return stubFalseResult;
  stubFalseInitialized = 1;
  function stubFalse() {
    return !1;
  }
  return (stubFalseResult = stubFalse), stubFalseResult;
}
bufferModule.exports;
var bufferModuleInitialized;
function initIsBuffer() {
  return (
    bufferModuleInitialized ||
      ((bufferModuleInitialized = 1),
      (function (module, exports) {
        var rootObj = getRootObject(),
          freeExports = initStubFalse(),
          exportedModule = exports && !exports.nodeType && exports,
          freeModule = exportedModule && !0 && module && !module.nodeType && module,
          moduleExports = freeModule && freeModule.exports === exportedModule,
          BufferRef = moduleExports ? rootObj.Buffer : void 0,
          nativeIsBuffer = BufferRef ? BufferRef.isBuffer : void 0,
          isBuffer = nativeIsBuffer || freeExports;
        module.exports = isBuffer;
      })(bufferModule, bufferModule.exports)),
    bufferModule.exports
  );
}

// ============================================================================
// 섹션 8: Lodash isTypedArray, isEmpty
// ============================================================================

/** baseIsTypedArray 캐시 */
var baseIsTypedArrayResult, baseIsTypedArrayInitialized;
function initBaseIsTypedArray() {
  if (baseIsTypedArrayInitialized) return baseIsTypedArrayResult;
  baseIsTypedArrayInitialized = 1;
  var baseGetTag = getBaseGetTag(),
    isLength = initIsLength(),
    isObjectLike = getIsObjectLike(),
    ARGS_TAG = "[object Arguments]",
    ARRAY_TAG = "[object Array]",
    BOOL_TAG = "[object Boolean]",
    DATE_TAG = "[object Date]",
    ERROR_TAG = "[object Error]",
    FUNC_TAG = "[object Function]",
    MAP_TAG = "[object Map]",
    NUMBER_TAG = "[object Number]",
    OBJECT_TAG = "[object Object]",
    REGEXP_TAG = "[object RegExp]",
    SET_TAG = "[object Set]",
    STRING_TAG = "[object String]",
    WEAKMAP_TAG = "[object WeakMap]",
    ARRAYBUF_TAG = "[object ArrayBuffer]",
    DATAVIEW_TAG = "[object DataView]",
    FLOAT32_TAG = "[object Float32Array]",
    FLOAT64_TAG = "[object Float64Array]",
    INT8_TAG = "[object Int8Array]",
    INT16_TAG = "[object Int16Array]",
    INT32_TAG = "[object Int32Array]",
    UINT8_TAG = "[object Uint8Array]",
    UINT8C_TAG = "[object Uint8ClampedArray]",
    UINT16_TAG = "[object Uint16Array]",
    UINT32_TAG = "[object Uint32Array]",
    typedArrayTags = {};
  (typedArrayTags[FLOAT32_TAG] =
    typedArrayTags[FLOAT64_TAG] =
    typedArrayTags[INT8_TAG] =
    typedArrayTags[INT16_TAG] =
    typedArrayTags[INT32_TAG] =
    typedArrayTags[UINT8_TAG] =
    typedArrayTags[UINT8C_TAG] =
    typedArrayTags[UINT16_TAG] =
    typedArrayTags[UINT32_TAG] =
      !0),
    (typedArrayTags[ARGS_TAG] =
      typedArrayTags[ARRAY_TAG] =
      typedArrayTags[ARRAYBUF_TAG] =
      typedArrayTags[BOOL_TAG] =
      typedArrayTags[DATAVIEW_TAG] =
      typedArrayTags[DATE_TAG] =
      typedArrayTags[ERROR_TAG] =
      typedArrayTags[FUNC_TAG] =
      typedArrayTags[MAP_TAG] =
      typedArrayTags[NUMBER_TAG] =
      typedArrayTags[OBJECT_TAG] =
      typedArrayTags[REGEXP_TAG] =
      typedArrayTags[SET_TAG] =
      typedArrayTags[STRING_TAG] =
      typedArrayTags[WEAKMAP_TAG] =
        !1);
  function baseIsTypedArray(value) {
    return isObjectLike(value) && isLength(value.length) && !!typedArrayTags[baseGetTag(value)];
  }
  return (baseIsTypedArrayResult = baseIsTypedArray), baseIsTypedArrayResult;
}

/** baseUnary 캐시 */
var baseUnaryResult, baseUnaryInitialized;
function initBaseUnary() {
  if (baseUnaryInitialized) return baseUnaryResult;
  baseUnaryInitialized = 1;
  function baseUnary(func) {
    return function (arg) {
      return func(arg);
    };
  }
  return (baseUnaryResult = baseUnary), baseUnaryResult;
}

/** nodeUtil 모듈 */
var nodeUtilModule = {
  exports: {},
};
nodeUtilModule.exports;
var nodeUtilInitialized;
function initNodeUtil() {
  return (
    nodeUtilInitialized ||
      ((nodeUtilInitialized = 1),
      (function (module, exports) {
        var freeGlobal = getFreeGlobal(),
          freeExports = exports && !exports.nodeType && exports,
          freeModule = freeExports && !0 && module && !module.nodeType && module,
          moduleExports = freeModule && freeModule.exports === freeExports,
          freeProcess = moduleExports && freeGlobal.process,
          nodeUtil = (function () {
            try {
              var types = freeModule && freeModule.require && freeModule.require("util").types;
              return types || (freeProcess && freeProcess.binding && freeProcess.binding("util"));
            } catch {}
          })();
        module.exports = nodeUtil;
      })(nodeUtilModule, nodeUtilModule.exports)),
    nodeUtilModule.exports
  );
}

/** isTypedArray 캐시 */
var isTypedArrayResult, isTypedArrayInitialized;
function initIsTypedArray() {
  if (isTypedArrayInitialized) return isTypedArrayResult;
  isTypedArrayInitialized = 1;
  var baseIsTypedArray = initBaseIsTypedArray(),
    baseUnary = initBaseUnary(),
    nodeUtil = initNodeUtil(),
    nodeIsTypedArray = nodeUtil && nodeUtil.isTypedArray,
    isTypedArray = nodeIsTypedArray ? baseUnary(nodeIsTypedArray) : baseIsTypedArray;
  return (isTypedArrayResult = isTypedArray), isTypedArrayResult;
}

/** isEmpty 캐시 */
var isEmptyResult, isEmptyInitialized;

/**
 * 값이 비어있는지 판별 (Lodash isEmpty)
 * 빈 배열, 빈 객체, 빈 문자열, null, undefined 등을 감지
 * @returns {function} isEmpty 함수
 */
/**
 * Lodash isEmpty 구현 게터. 배열/객체/문자열/Map/Set/Buffer/TypedArray의 빈 여부 판별. 가격 요청 전 파라미터 유효성 검증에 사용.
 */
function initIsEmpty() {
  if (isEmptyInitialized) return isEmptyResult;
  isEmptyInitialized = 1;
  var baseKeys = initBaseKeys(),
    getTag = initGetTag(),
    isArguments = initIsArguments(),
    isArray = initIsArray(),
    isArrayLike = initIsArrayLike(),
    isBuffer = initIsBuffer(),
    isPrototype = initIsPrototype(),
    isTypedArray = initIsTypedArray(),
    MAP_TAG = "[object Map]",
    SET_TAG = "[object Set]",
    objectProto = Object.prototype,
    hasOwnProperty = objectProto.hasOwnProperty;

  /**
   * 값이 비어있는지 확인
   * @param {*} value - 검사할 값
   * @returns {boolean} 비어있는지 여부
   */
  function isEmpty(value) {
    if (value == null) return !0;
    if (
      isArrayLike(value) &&
      (isArray(value) ||
        typeof value == "string" ||
        typeof value.splice == "function" ||
        isBuffer(value) ||
        isTypedArray(value) ||
        isArguments(value))
    )
      return !value.length;
    var tag = getTag(value);
    if (tag == MAP_TAG || tag == SET_TAG) return !value.size;
    if (isPrototype(value)) return !baseKeys(value).length;
    for (var key in value) if (hasOwnProperty.call(value, key)) return !1;
    return !0;
  }
  return (isEmptyResult = isEmpty), isEmptyResult;
}

/** isEmpty 인스턴스 */
var isEmptyFnWrapper = initIsEmpty();

/**
 * isEmpty 유틸리티 — 빈 값 감지
 * 가격 요청 전 파라미터 유효성 검증에 사용
 */
const isEmpty = extractDefaultExport(isEmptyFnWrapper);

// ============================================================================
// 섹션 9: API 엔드포인트 상수 및 기본 URL
// ============================================================================

/**
 * RedPrinting 메인 서버 기본 URL
 * 제품 정보 조회, 가격 계산, 템플릿 다운로드 등에 사용
 */
const REDPRINTING_BASE_URL = "https://www.redprinting.co.kr";

/**
 * 이미지 에셋 CDN URL
 * 주문 아이콘, 가이드 이미지, 후가공 아이콘 등 정적 리소스
 */
const ASSETS_IMAGE_CDN_URL = "https://d3qehkb69dy9zc.cloudfront.net/assets/images";

/**
 * 위젯 API 서버 URL
 * S3 presigned URL 발급, 에디터 설정 등 위젯 전용 API
 */
const WIDGET_API_BASE_URL = "https://widget-api.redprinting.co.kr";

// ============================================================================
// 섹션 10: 제품 정보 API 호출 함수
// ============================================================================

/**
 * 제품 정보 조회 API
 * 서버에서 제품의 전체 옵션 데이터(규격, 자재, 도수, 후가공 등)를 가져옴
 *
 * @param {string} locale - 언어 코드 (기본값: "ko")
 * @param {string} productCode - 제품 코드 (예: "PRBKYPR")
 * @param {string} patternCode - 패턴 코드 (선택)
 * @returns {Promise<{result: object|null, errorMessage: string|null}>} 제품 정보 또는 에러
 */
/**
 * 제품 정보 조회 API — GET /{locale}/product/get_digital_product_info?pdt_cod=&ptt_cod=. 제품의 전체 옵션 데이터(규격·자재·도수·후가공)를 반환. retCode!==200이면 에러. 반환 {result, errorMessage}.
 */
async function fetchProductInfo(locale = "ko", productCode, patternCode) {
  try {
    const queryParams = new URLSearchParams(
        patternCode
          ? {
              pdt_cod: productCode,
              ptt_cod: patternCode,
            }
          : {
              pdt_cod: productCode,
            }
      ).toString(),
      apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product/get_digital_product_info?${queryParams}`,
      responseData = await (await fetch(apiUrl)).json();
    if (responseData.retCode !== 200) throw new Error(responseData.msg);
    const { result: productResult } = responseData;
    return {
      result: productResult,
      errorMessage: null,
    };
  } catch (error) {
    let errorMessage = "제품 정보를 가져올 수 없습니다.";
    return (
      error instanceof Error &&
        (console.error("[RedWidgetSDK/ERROR] 제품 정보 가져오기 실패 > ", error),
        error.message && (errorMessage = error.message)),
      {
        result: null,
        errorMessage: errorMessage,
      }
    );
  }
}

// ============================================================================
// 섹션 11: 가격 계산 API 호출 함수
// ============================================================================

/**
 * 가격 계산 API 호출
 * 사용자가 선택한 옵션(제품코드, 자재, 규격, 수량, 후가공 등)을 서버에 전송하여
 * 실시간 가격을 계산하고 결과를 반환
 *
 * 요청 형식:
 * POST /ko/product_price/get_ajax_price_vTmpl
 * Body: { dataJson: { ORD_INFO: [...], PCS_INFO: [...], price_gbn, mb_cust_cod } }
 *
 * @param {object} priceRequestPayload - 가격 요청 페이로드 ({type, body} 구조)
 * @param {string} locale - 언어 코드 (기본값: "ko")
 * @returns {Promise<{result: object|null, errorMessage: string|null}>} 가격 결과 또는 에러
 */
/**
 * 가격 계산 API — POST /{locale}/product_price/get_ajax_price_vTmpl, body {dataJson:{ORD_INFO,PCS_INFO,price_gbn,mb_cust_cod}}. 선택 옵션으로 실시간 가격 산출. retCode!==200이면 에러. ★PRICE 계약 식별자 보존.
 */
async function fetchPriceCalculation(priceRequestPayload, locale = "ko") {
  let responseData = null;
  try {
    const apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product_price/get_ajax_price_vTmpl`;
    if (
      ((responseData = await (
        await fetch(apiUrl, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            dataJson: priceRequestPayload.body,
          }),
        })
      ).json()),
      responseData.retCode !== 200)
    )
      throw new Error(responseData.msg);
    return {
      result: responseData,
      errorMessage: null,
    };
  } catch (error) {
    console.error("[RedWidgetSDK/ERROR] 가격 요청 실패 > ", error);
    let errorMessage = "가격 요청에 실패했습니다.";
    return (
      error instanceof Error && (errorMessage = error.message),
      {
        result: responseData,
        errorMessage: errorMessage,
      }
    );
  }
}

// ============================================================================
// 섹션 12: S3 파일 정보 조회 함수
// ============================================================================

/**
 * S3 업로드 파일 정보 조회
 * 업로드된 파일의 메타데이터를 S3에서 가져옴 (파일 크기 확인 등)
 *
 * @param {object} params - { lang: 언어코드, file_name: S3 파일명 }
 * @returns {Promise<object|null>} S3 파일 정보 또는 null
 */
/**
 * S3 업로드 파일 메타데이터 조회 API — POST /{locale}/product/s3GetObjectJson. 업로드 파일의 크기/존재 확인. 없으면 null.
 */
async function fetchS3FileInfo(params) {
  try {
    const { lang: locale, file_name: fileName } = params,
      apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product/s3GetObjectJson`,
      responseData = await (
        await fetch(apiUrl, {
          method: "POST",
          body: JSON.stringify({
            file_name: fileName,
          }),
        })
      ).json();
    if (!responseData) throw new Error("해당 파일은 s3에 존재하지 않습니다");
    return responseData;
  } catch (error) {
    let errorMessage = "";
    return (
      error instanceof Error && (errorMessage = error.message),
      console.error("[RedWidgetSDK/ERROR] s3 파일 정보 가져오기 실패 >. ", errorMessage || error),
      null
    );
  }
}

// ============================================================================
// 섹션 13: 주문 가능 용지(자재) 목록 조회
// ============================================================================

/**
 * 주문 가능 용지(자재) 정보 조회
 * 제품별 사용 가능한 용지 목록과 가이드 이미지를 서버에서 가져옴
 *
 * @param {object} params - { lang: 언어코드, pdt_cod: 제품코드 }
 * @returns {Promise<Array|null>} 용지 목록 배열 또는 null
 */
/**
 * 주문 가능 용지(자재) 목록 조회 API — POST /{locale}/product/guide_product_paper. PDT_COD/PTT_COD 조합으로 중복 제거 후 가이드 이미지 URL을 합성해 반환.
 */
async function fetchAvailableMaterials(params) {
  try {
    const { lang: locale, pdt_cod: productCode } = params,
      apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product/guide_product_paper`,
      paperList = await (
        await fetch(apiUrl, {
          method: "POST",
          body: JSON.stringify({
            pdt_cod: productCode,
          }),
        })
      ).json();
    if (!paperList) throw new Error();
    const uniquePapers = [],
      seenKeys = new Set([]);
    for (const paper of paperList) {
      const uniqueKey = `${paper.PDT_COD}/${paper.PTT_COD}`;
      seenKeys.has(uniqueKey) ||
        (seenKeys.add(uniqueKey),
        uniquePapers.push({
          ...paper,
          IMG_URL_DEFAULT: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${paper.PTT_COD}.png`,
          IMG_URL_DETAIL: `https://d3qehkb69dy9zc.cloudfront.net/assets/images/ko/guide/digital/${paper.PTT_COD}_over.png`,
          PDT_COD: productCode,
        }));
    }
    return uniquePapers;
  } catch (error) {
    return (
      console.error("[RedWidgetSDK/ERROR] 주문 가능 용지(자재) 정보 가져오기 실패 > ", error), null
    );
  }
}

// ============================================================================
// 섹션 14: 템플릿 다운로드 함수
// ============================================================================

/**
 * 인쇄 템플릿 파일(ZIP) 다운로드
 * 사용자가 선택한 제품 옵션에 맞는 작업 템플릿을 다운로드
 *
 * @param {object} params - { lang, ...기타 다운로드 파라미터 }
 * @returns {Promise<boolean>} 다운로드 성공 여부
 */
/**
 * 인쇄 작업 템플릿(ZIP) 다운로드 — POST /{locale}/product/get_download (FormData). blob이 application/zip이 아니면 에러. 임시 a 태그 클릭으로 다운로드.
 */
async function downloadTemplate(params) {
  try {
    const { lang: locale, ...downloadParams } = params,
      formData = new FormData();
    Object.entries(downloadParams).forEach(([key, value]) => formData.append(key, value));
    const apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product/get_download`,
      blobResponse = await (
        await fetch(apiUrl, {
          method: "POST",
          body: formData,
        })
      ).blob();
    if (blobResponse.type !== "application/zip")
      throw new Error("템플릿 파일(.zip)이 존재하지 않습니다.");
    const blobUrl = URL.createObjectURL(blobResponse),
      downloadLink = document.createElement("a");
    return (
      (downloadLink.href = blobUrl),
      (downloadLink.download = `${downloadParams.file_nm.replace(/\./g, "_")}`),
      document.body.appendChild(downloadLink),
      downloadLink.click(),
      downloadLink.remove(),
      URL.revokeObjectURL(blobUrl),
      !0
    );
  } catch (error) {
    return console.error("[RedWidgetSDK/ERROR] 템플릿 다운로드 실패 > ", error), !1;
  }
}

/**
 * 책자 표지 템플릿 PDF 다운로드
 * 무선/트윈링 책자의 표지 작업용 PDF 템플릿을 다운로드
 *
 * @param {object} params - { lang, ...기타 다운로드 파라미터 }
 * @returns {Promise<boolean>} 다운로드 성공 여부
 */
/**
 * 책자 표지 템플릿 PDF 다운로드 — POST /{locale}/product/get_pdf_download (FormData). 무선/트윈링 책자 표지 작업용. 응답 url로 다운로드.
 */
async function downloadCoverTemplatePdf(params) {
  try {
    const { lang: locale, ...downloadParams } = params,
      formData = new FormData();
    Object.entries(downloadParams).forEach(([key, value]) => formData.append(key, value));
    const apiUrl = `${REDPRINTING_BASE_URL}/${locale}/product/get_pdf_download`,
      responseData = await (
        await fetch(apiUrl, {
          method: "POST",
          body: formData,
        })
      ).json();
    if (!responseData.success || !responseData.url) throw new Error(responseData.msg);
    const downloadLink = document.createElement("a");
    return (
      (downloadLink.href = responseData.url),
      document.body.appendChild(downloadLink),
      downloadLink.click(),
      downloadLink.remove(),
      !0
    );
  } catch (error) {
    return console.error("[RedWidgetSDK/ERROR] 책자 표지 템플릿 다운로드 실패 > ", error), !1;
  }
}

// ============================================================================
// 섹션 15: 다국어 번역 사전 (영어)
// ============================================================================

/**
 * 영어 번역 사전
 * 위젯 UI에 표시되는 모든 레이블, 안내 문구, 에러 메시지의 영어 번역
 * 인쇄 업계 전문 용어 포함: 규격(Specification), 재단(Cutting), 후가공(Finishing),
 * 도수(Printing Option), 내지(Inner Page), 표지(Cover Page) 등
 */
const TRANSLATIONS_EN = {
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
  "파일업로드-MS":
    "Printing output may be different when printing using PDF files created by MS-OFFICE series.",
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
  "의류인쇄영역가이드-실크인쇄":
    "* Added Cost - (Chest, Arm, Neck: 50,000 won | Front, Back: 70,000 won)",
  팬톤검색문구: "* Pantone Color Finder",
  팬톤검색안내:
    "The color chip on the left shows the RGB color as displayed on your screen, so it may differ from the actual Pantone color. Please select a Pantone color, or enter the Pantone number directly if you cannot find your desired color.",
  팬톤검색실패문구:
    "Color not found. Please see desired color from Swatch. If you are unable to find your desired color, kindly email us.",
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
  "토너책자최소수량안내-짝수":
    "* [Toner] MOQ: {MIN_CNT} books. Can be ordered in an incremental of 2 books",
  내지업로드사이즈장수안내:
    "<b>* {CUT_SIZE} Book: Upload 1 PDF File in <span class='bold red'>{WRK_SIZE}</span> (Bleed Size) containing <span class='bold red'>{QTY}</span>pages</b>",
  표지업로드장수안내:
    "<b>* Download Cover Template and upload <span class='bold red'>{QTY}</span> Page PDF file</b>",
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
  "주문불가-파일명중복":
    "The interior and cover files have the same name. Please upload files with different names.",
  "주문불가-에디터": "Please create the file in the editor.",
  "주문불가-옵션미선택": "No option selected. Please select an option to continue.",
  "주문불가-가격":
    "An error occurred while calculating the price. Please try again or contact customer support.",
  "주문불가-인쇄컬러미선택": "Please select a print color(Pantone).",
  "주문불가-사이즈": `Size entered cannot be produced.
Please check minimum/maximum limits.`,
  "오늘출발-불가능":
    "* Selected specification is not available for Same-Day delivery.<br /> View 'See Options' to check eligibility.",
  "내일출발-불가능":
    "* Selected specification is not available for Next-Day delivery.<br /> View 'See Options' to check eligibility.",
  "스티커용지-주의사항":
    "* Situations whereby PE, BOX, plastic containing agent, embossed, coated small box, short diameter roll, wood, stone surface, harness, non-woven fabric, attached to non-flat surfaces are placed in the refrigerator, might fall off.",
  인쇄함: "Printing",
  인쇄안함: "Blank",
  인풋카드: "Insert Card",
};

// ============================================================================
// 섹션 16: 다국어 번역 사전 (한국어) — 생략: 영어 사전과 구조 동일
// 원본의 HT 객체와 동일하며, 한국어 원문 그대로 유지
// ============================================================================

/* TODO: 한국어 번역 사전은 원본 코드의 HT 객체(line 1080~1281)와 동일
 * 지면 관계상 전체 내용은 원본 참조. 키-값이 모두 한국어 원문. */

// 나머지 코드(Pinia 스토어, 주문 요약, SDK 클래스 등)는
// mod_06_app_widget_sdk.js의 deobfuscated 버전에 포함
