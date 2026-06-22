/**
 * @fileoverview Babel 트랜스파일러가 생성한 런타임 헬퍼 함수 모음
 *
 * 이 파일은 Babel이 ES6+ 문법을 ES5로 변환할 때 생성하는 폴리필 헬퍼 함수들을 포함합니다.
 * RedEditorSDK.js (원본)의 1~90번 줄에 해당하는 레이어 1입니다.
 *
 * 포함된 헬퍼:
 * - _slicedToArray: 배열 또는 이터러블을 고정 길이 배열로 변환 (구조분해 할당 지원)
 * - _extends: Object.assign 폴리필 (객체 병합)
 * - _createClass: ES5 방식의 클래스 메서드 정의
 * - _typeof: Symbol을 고려한 typeof 폴리필
 * - _toConsumableArray: 이터러블을 일반 배열로 변환 (스프레드 연산자 지원)
 * - _defineProperty: Object.defineProperty 래퍼
 * - _classCallCheck: 클래스 생성자 호출 검증 (new 없이 호출 방지)
 */

"use strict";

/**
 * 배열 또는 이터러블 객체를 지정된 길이의 배열로 변환합니다.
 * Babel이 구조분해 할당(destructuring assignment) 문법을 변환할 때 사용합니다.
 *
 * @param {Array|Iterable} t - 변환할 배열 또는 이터러블
 * @param {number} e - 추출할 최대 요소 수
 * @returns {Array} 변환된 배열
 * @throws {TypeError} 이터러블이 아닌 값이 전달될 경우
 */
var _slicedToArray = function (t, e) {
  if (Array.isArray(t)) return t;
  if (Symbol.iterator in Object(t))
    return (function (t, e) {
      var n = [],
        r = !0,
        o = !1,
        i = void 0;
      try {
        for (
          var a, c = t[Symbol.iterator]();
          !(r = (a = c.next()).done) &&
          (n.push(a.value), !e || n.length !== e);
          r = !0
        );
      } catch (t) {
        (o = !0), (i = t);
      } finally {
        try {
          !r && c.return && c.return();
        } finally {
          if (o) throw i;
        }
      }
      return n;
    })(t, e);
  throw new TypeError("Invalid attempt to destructure non-iterable instance");
};

/**
 * Object.assign 폴리필입니다.
 * 여러 소스 객체의 속성을 대상 객체에 복사합니다.
 * 네이티브 Object.assign이 있으면 해당 구현을 우선 사용합니다.
 *
 * @param {Object} t - 대상 객체
 * @param {...Object} arguments - 소스 객체들
 * @returns {Object} 병합된 대상 객체
 */
var _extends =
  Object.assign ||
  function (t) {
    for (var e = 1; e < arguments.length; e++) {
      var n = arguments[e];
      for (var r in n)
        Object.prototype.hasOwnProperty.call(n, r) && (t[r] = n[r]);
    }
    return t;
  };

/**
 * ES5 방식의 클래스 메서드 및 정적 메서드를 프로토타입에 정의합니다.
 * Babel이 ES6 class 문법을 변환할 때 사용합니다.
 *
 * @returns {Function} 클래스 프로토타입에 메서드를 추가하는 함수
 */
var _createClass = (function () {
  function r(t, e) {
    for (var n = 0; n < e.length; n++) {
      var r = e[n];
      (r.enumerable = r.enumerable || !1),
        (r.configurable = !0),
        "value" in r && (r.writable = !0),
        Object.defineProperty(t, r.key, r);
    }
  }
  return function (t, e, n) {
    return e && r(t.prototype, e), n && r(t, n), t;
  };
})();

/**
 * Symbol을 고려한 typeof 폴리필입니다.
 * ES6 Symbol 타입을 지원하지 않는 환경에서도 올바른 타입 문자열을 반환합니다.
 *
 * @param {*} t - 타입을 확인할 값
 * @returns {string} 타입 문자열 ('symbol', 'object', 'function' 등)
 */
var _typeof =
  "function" == typeof Symbol && "symbol" == typeof Symbol.iterator
    ? function (t) {
        return typeof t;
      }
    : function (t) {
        return t &&
          "function" == typeof Symbol &&
          t.constructor === Symbol &&
          t !== Symbol.prototype
          ? "symbol"
          : typeof t;
      };

/**
 * 배열 또는 이터러블을 일반 배열로 변환합니다.
 * Babel이 스프레드 연산자(spread operator) 문법을 변환할 때 사용합니다.
 *
 * @param {Array|Iterable} t - 변환할 배열 또는 이터러블
 * @returns {Array} 변환된 일반 배열
 */
function _toConsumableArray(t) {
  if (Array.isArray(t)) {
    for (var e = 0, n = Array(t.length); e < t.length; e++) n[e] = t[e];
    return n;
  }
  return Array.from(t);
}

/**
 * 객체에 속성을 정의합니다.
 * Object.defineProperty를 사용하여 속성의 특성(enumerable, configurable, writable)을 설정합니다.
 *
 * @param {Object} t - 속성을 추가할 대상 객체
 * @param {string} e - 속성 이름
 * @param {*} n - 속성 값
 * @returns {Object} 속성이 추가된 대상 객체
 */
function _defineProperty(t, e, n) {
  return (
    e in t
      ? Object.defineProperty(t, e, {
          value: n,
          enumerable: !0,
          configurable: !0,
          writable: !0,
        })
      : (t[e] = n),
    t
  );
}

/**
 * 클래스 생성자가 new 키워드와 함께 호출되었는지 검증합니다.
 * new 없이 생성자를 직접 호출하면 TypeError를 발생시킵니다.
 *
 * @param {Object} t - this 컨텍스트 (new로 생성된 인스턴스여야 함)
 * @param {Function} e - 생성자 함수
 * @throws {TypeError} new 없이 클래스를 함수로 호출할 경우
 */
function _classCallCheck(t, e) {
  if (!(t instanceof e))
    throw new TypeError("Cannot call a class as a function");
}
