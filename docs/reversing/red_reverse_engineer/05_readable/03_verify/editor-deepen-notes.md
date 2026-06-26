# editor_sdk 핵심 메서드 의미명 심화 — 추가 의미 엔트리

> 대상: `deob_editor_sdk.js` (원본 03_deobfuscated, 12,629줄)
> 맵: `05_readable/01_cartography/deob_editor_sdk.js/rename-map.json`
> 목적: 핵심 메서드만 선별 심화 — 역할-범주 기계명(가독본 `_argN`/`_valL`/`_regR` 등)을
> 원본 deob 식별자(`e`/`n`/`L`/`r`...) 기준으로 **메서드 스코프 한정 의미명**으로 상향.

## 방법론 핵심
- rename-map은 **원본 deob 식별자**(가독본의 `_xxx`가 아님)를 키로 한다. 가독본의 `_argN`은
  apply-rename-map이 원본 `n`을 변환한 중간상태일 뿐 — 맵 키는 원본 minified 글자.
- 같은 단문자(`e`,`n`,`t`,`o`,`i`,`r`...)가 메서드마다 다른 의미 → renameMap[orig]를 **배열**로
  병합(데이터 계약: apply-rename-map.cjs L104~111이 배열 지원, scope 매칭 1개만 적용).
- scope = `iife:<원본 deob value function 시작줄>` — `_createClass`의 `value: function(){}`은
  이름 없는 함수표현식이라 `function:NAME` 불가. probe(`_tooling/_probe.cjs`)로 AST 줄번호 확정
  (AST 줄 = grep 줄과 일치 확인). `scope.rename`은 그 함수에 **선언된 바인딩만** 안전 rename
  (전역 콜백·다른 메서드 미오염).

## 스코프 앵커(원본 deob value function 시작줄)
| 메서드 | scope | params(원본) |
|---|---|---|
| createProject | iife:10603 | e, n (+L default) |
| openProject | iife:10827 | o, i (+k default) |
| changeTemplate | iife:11257 | t, e |
| setUserId | iife:11526 | t |
| prepareOrder | iife:11672 | t, r, o |
| save | iife:11908 | (none) |
| saveThenClose | iife:11921 | (none) |
| setToken (SDK) | iife:11929 | t  ← ApiClient.setToken@2776과 별개·미오염 확인 |
| checkOrderable | iife:11941 | e, n |
| setPrice | iife:12082 | t |

## 추가 의미 엔트리 (33건, 근거 시그니처/본문)

### createProject (iife:10603) — 11
| orig | to | 근거 |
|---|---|---|
| e | editorConfig | 1st param·validateRequiredParams([selector,psCode,title]) |
| n | projectOptions | 2nd param·calendarConfig/customTabInfo/paletteCode/autoSave |
| L | retryCount | 3rd param(default 0)·isReady 미설정 시 재귀(<4) |
| r | self | r=this·setTimeout 재귀에서 인스턴스 캡처 |
| P | editorPayload | editorBridge.create_project 서버 페이로드 |
| N | authState | N=getAuthState()·N.user/N.token 분기 |
| F | eventHandlerRef | F=self.editorEventHandler |
| m | customTabContext | {productCode,product,templateList,isDev,locale} |
| b | customTabManager | b=new CustomTabManager(ctx) |
| x | customTabFormat | x=await getCustomTabFormat 결과(noStocks/varMap) |
| o | now | o=new Date()·calendarConfig 기본 산출(conf 0.7) |

### openProject (iife:10827) — 6
| orig | to | 근거 |
|---|---|---|
| o | editorConfig | 1st param·validateRequiredParams([selector,projectId]) |
| i | projectOptions | 2nd param·executeList/customTabInfo/clone |
| k | retryCount | 3rd param(default 0)·재귀(<4) |
| a | self | a=this |
| b | launchOpenProject | b=function(projectId){...}·토큰 후 open_project 실행 launcher |
| x | cloneOptions | x={}·projectOwnerId 주입 후 cloneProject 인자 |

### changeTemplate (iife:11257) — 2
| t | productCode | 1st param (catalog: change_template(productCode,templateUri)) |
| e | templateUri | 2nd param |

### setUserId (iife:11526) — 2
| t | userId | 1st param·sessionStorage 저장 후 issueUserToken |
| n | self | n=this·then 콜백서 isReady=true |

### prepareOrder (iife:11672) — 4
| t | projectId | 1st param·tentativeOrder 대상 |
| r | orderParams | 2nd param·validateRequiredParams([order_count,total_price]) |
| o | legacyCallback | 3rd param·(error,data) |
| i | savedEditorConfig | sessionStorage edicusConfig 파싱·updateTemplateCount |

### save (iife:11908) — 1
| t | saveCommand | t={type:"save"}·post_to_editor("command") |

### saveThenClose (iife:11921) — 1
| t | saveThenCloseCommand | t={type:"save-then-close"} |

### setToken (iife:11929, SDK) — 1
| t | newToken | apiClientInstance.setToken 위임 |

### checkOrderable (iife:11941) — 3
| e | projectId | 1st param·isReadyToOrder 대상 |
| n | legacyCallback | 2nd param·(error,result) |
| r | orderableResult | await isReadyToOrder 결과·{can_order,doc_rev,message} |

### setPrice (iife:12082) — 2
| t | priceValue | varMap.$PRCE 주입 |
| e | priceVarMessage | e={varMap:{$PRCE:priceValue}}·set-mutable-prod-var |

## 검증 (apply-rename-map 원본 deob 재적용)
- `applied=85 skipped=0` — 신규 33건 전부 적용, 모호 skip 0.
- 시그니처 변환 확인:
  `createProject(editorConfig, projectOptions)` / `openProject(editorConfig, projectOptions)` /
  `changeTemplate(productCode, templateUri)` / `setUserId(userId)` /
  `prepareOrder(projectId, orderParams, legacyCallback)` / `checkOrderable(projectId, legacyCallback)` /
  `setPrice(priceValue)`.
- 본문 앵커: saveCommand/saveThenCloseCommand/orderableResult/priceVarMessage/editorPayload/
  authState 등 적용.
- **스코프 안전 입증**: `setToken@4314(ApiClient)`은 `t` 보존, `setToken@17870(SDK)`만 `newToken`.
  전역 콜백(onChangeCallback 등 iife:78) 21개 미오염. scope.rename = AST 바인딩 단위 → 동작 보존.

## 맵 상태
- before 87 keys(83 의미 + 4 free-ref, 전부 단일 객체) → after **91 keys, array keys 15**
  (신규 키 e/n/o 등 배열 생성·기존 키 t/i/a/r/o/k/L/N/F/P/m/b/x 배열 승격).
- 추가 의미 엔트리 **33건** / 대상 메서드 **10개**.
