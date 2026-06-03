# Parity Matrix D3 — 에디터 브릿지

> STAGE S1 검증. 기준 = **책임/로직/분기 재현 등가**. 코드 변경 없음 — GAP/IMPROVEMENT 보고.
> Red 권위: `07_parity/red-code-map-08-editor-sdk.md`(디스패처 §3 30종, goto-cart §5, origin §6, deferred §8).
> 우리 구현: `04_build/src/widget/editor/{editor-bridge,EditorOverlay}.ts(x)` + `src/contract/editor.ts` + `widget-store.ts`(openEditor/applyEditorResult/closeEditor).
> 표기: `edsdk:L`=Red 소스, `eb:L`=editor-bridge.ts, `eo:L`=EditorOverlay.tsx.

---

## 0. 종합 판정

| 영역 | 판정 | 핵심 |
|------|------|------|
| 30 from-edicus 액션 커버리지 | **5/30 처리** | request-prod-info, project-id-created, save-doc-report, goto-cart, close. 나머지 25 미처리. |
| goto-cart=close 공유 + case 미해석 | **재현(정합)** | case switch 미구현(올바름). 단 우리는 goto-cart/close **분리 핸들**(Red는 공유) — isReadyToOrder 호출 누락. |
| origin 보안 | **개선(Red 초과)** | allowlist origin 검증 + targetOrigin 명시 송신 + e.source 라우팅. **Red 와일드카드 결함을 의도적 보강.** |
| deferred 핸드셰이크 | **부분재현** | request-prod-info→send-extra-param 1종만. 11 param + waiting-for-ddp-data 미재현. |
| auto-save / 50min refresh / inheritToken | **누락** | 셋 다 미구현(어댑터/BFF 경계 가정). |

---

## MATRIX B-1 — 30 from-edicus 액션 커버리지

`onMessage` switch(eb:119-148)가 처리하는 action: **request-prod-info / project-id-created / save-doc-report / goto-cart / close** (5종).

| # | Red action (08맵 §3) | Red 콜백 | 우리 처리 | 판정 |
|---|----------------------|----------|-----------|------|
| 1 | project-id-created | onCreate(projectId 저장) | `case 'project-id-created'`→onProjectId(eb:124); EditorOverlay 는 무동작(eo:29) | **재현(부분)** projectId 저장 안 함(goto-cart 시 info.projectID 사용). 라이프사이클 추적만. |
| 2 | load-project-report(end) | onLoad + autoSave 시작 | 없음 | **누락** |
| 3 | edit-template-report(end) | onLoad | 없음 | **누락** |
| 4 | show-tn-report(end) | onLoad | 없음 | **누락** |
| 5 | doc-changed | onChange + getResourceWithId/updateTemplateCount/vdp | 없음 | **누락** (템플릿 hit 카운트·VDP 미처리) |
| 6-8 | var-added/deleted/changed | onChange | 없음 | **누락** |
| 9 | page-changed | onPageChange | 없음 | **누락** |
| 10 | promo-external-report | onPromoReport | 없음 | **누락** |
| 11 | command-completed | Promise resolve | 없음 | **누락** (remoteEditor 미구현 — 위젯 무관) |
| 12 | command-rejected | Promise reject | 없음 | **누락** (동상) |
| 13 | save-doc-report(end) | onSave + Sentry | `case 'save-doc-report'`→docInfo 보관(eb:129-132) | **재현(변형)** Red 는 onSave 콜백; 우리는 **docInfo fallback 저장**(goto-cart tnUrlList 누락 대비). status 게이트 없음(phase 무검사). |
| 14 | close | onClose(공유) | `case 'close'`→onClose(eb:145) | **부분** isReadyToOrder 호출 없음(B-2). |
| 15 | goto-cart | onClose(공유, isReadyToOrder) | `case 'goto-cart'`→NormalizedEditorResult→onResult(eb:133-143) | **재현(변형)** 정규화 결과 매핑 OK. **isReadyToOrder 미호출**(B-2). |
| 16 | selection-changed | onSelect | 없음 | **누락** |
| 17 | state-history | onHistoryState | 없음 | **누락** |
| 18 | label-history | onHistoryLabel | 없음 | **누락** |
| 19 | dpp-execute-report(end) | onDdpExecuteComplete | 없음 | **누락** |
| 20 | scene-info-report | sceneInfoCallback | 없음 | **누락** |
| 21 | imgpool-notify | onImagePool | 없음 | **누락** |
| 22 | preview-closed | onPreviewClose | 없음 | **누락** |
| 23 | font-list | onFontList | 없음 | **누락** |
| 24-25 | enter/exit-overlay-mode | onChangeMode | 없음 | **누락** |
| 26 | page-count-changed | onPageCountChange | 없음 | **누락(주의)** 페이지수 변동 → 가격재계산 트리거인데 미수신. goto-cart totalPageCount 로만 반영. |
| 27 | request-page-size-change | onGroupCaption | 없음 | **누락** |
| 28 | request-user-token | issueUserToken→send-user-token | 없음 | **누락(주의)** 에디터 토큰 만료 시 갱신요청 응답 부재 → 장세션 에디터 토큰 만료 위험. |
| 29 | impose-opened | onImposeOpened | 없음 | **누락** |
| 30 | page-group-print-count-changed | onPrintCountChange | 없음 | **누락** |
| 31 | prod-var-changed | onCustomTabSelectionChange | 없음 | **누락** (커스텀탭 자재변경 실시간가격 미연동) |
| 32 | doc-report | onDocReport + Sentry | 없음 | **누락** |
| + | request-prod-info | (deferred §8 waiting-for-extra-param 대응) | `case 'request-prod-info'`→send-extra-param(eb:120-122) | **재현(변형)** Red 액션명은 `waiting-for-extra-param`(from-edicus-private); 우리는 `request-prod-info`(from-edicus). **액션명·type 불일치** → B-4. |

### 커버리지 결론
- **처리 5 / 손실 25 / 변형 3.** 위젯 핵심 경로(생성→저장→장바구니→닫기)는 최소 커버. 그러나 **page-count-changed(가격연동)·request-user-token(토큰갱신)·prod-var-changed(커스텀탭 가격)** 3종은 위젯 정확성에 영향 있는 손실.
- 나머지(history/scene/font/impose/imgpool 등)는 위젯 주문 플로우와 무관(에디터 내부 UX) — 호스트 셸 책임이거나 불요. **무손실 등가 처리 가능**(설계상 OK).

---

## MATRIX B-2 — goto-cart=close 공유 핸들러 + isReadyToOrder

| Red (08맵 §5, `edsdk:11386-11417`) | 우리 (eb:133-147) |
|------------------------------------|--------------------|
| goto-cart/close **동일 블록** 진입 | **분리 케이스**(goto-cart→onResult, close→onClose) |
| case 값 switch **없음**(info.case 패스스루) | case 미해석, 흡수(eb:28·141) ✓ |
| `info.projectID`로 `isReadyToOrder` 호출→`isCanOrder` 판정 | **isReadyToOrder 미호출** |
| finally onClose(d) + autoSave clear | onClose는 close 케이스만; autoSave 없음(N/A) |

**판정: 부분재현(정합점 + 1 GAP).**
- ✓ **case switch 미구현이 올바름** — Red도 SDK-level case 분기 없음. 우리가 over-engineer 안 한 것 정합(eb:28·141 주석 명시).
- ✗ **isReadyToOrder(주문가능) 호출 누락** — Red는 goto-cart/close 시 `isReadyToOrder(projectID)`로 `can_order` 판정 후 onClose. 우리는 goto-cart→바로 onResult(가격/업로드 검증은 위젯 `selectCanOrder`가 별도 수행, ws:343). **에디터 doc_rev 기반 서버 주문가능 판정은 누락** → 후니 백엔드 어댑터에 isReadyToOrder 대응 필요.
- 구조차이: Red는 goto-cart/close 공유(둘 다 onClose+orderable), 우리는 goto-cart=결과반영 / close=취소. **의미상 우리 분리가 더 명확하나**, goto-cart에서도 서버 orderable 확인이 빠짐.

---

## MATRIX B-3 — origin 보안 (IMPROVEMENT)

| Red (08맵 §6) | 우리 (eb) | 판정 |
|----------------|-----------|------|
| 송신 `postMessage(..., "*")` 와일드카드 | `postToEditor`: targetOrigin = `this.allowed[0]` 명시(eb:91-95) | **개선** |
| 수신 origin 미검증(e.type만) | `onMessage` 최상단 `isAllowedOrigin(e.origin)` 검증(eb:111-113) — payload 파싱 전 | **개선** |
| 인스턴스 라우팅 없음 | `e.source !== iframeWindow` 가드(eb:115) — 멀티 인스턴스 안전 | **개선** |
| allowlist 출처 | DEFAULT_ALLOWED_ORIGINS 폴백 + opts.allowedOrigins(BFF/.env 주입, eb:9·79) | **개선** |

**판정: 개선(Red 초과) — 의도된 보강.** Red의 와일드카드 송수신 결함을 bug-for-bug 답습하지 않고 올바른 allowlist+targetOrigin+source 라우팅 구현. **이 영역은 Red보다 우월. 유지.**
- 잔여 주의(@MX:WARN eb:89): Edicus sandbox/redirect 로 실 origin 이 폴백과 다를 수 있음 → 빌드타임 실 origin 검증 필요(O10). 첫 수신 e.origin 채택 폴백 미구현.

---

## MATRIX B-4 — deferred 핸드셰이크 / auto-save / 토큰

| Red 메커니즘 | 우리 | 판정 |
|--------------|------|------|
| **deferred-param**: waiting-for-extra-param → 11 param(prod_info/options/ddp_block/private_css/option_string/data_row/data_feed/zoom/size_option/rsc_option/template_list) 매핑 + waiting-for-ddp-data (08맵 §8) | `request-prod-info`→`send-extra-param`(buildProdInfo: ps_code+pluginCustomData, eb:120·eo:28) | **부분재현** 1 param(prod_info류)만. **액션명·type 불일치**(Red: from-edicus-private/waiting-for-extra-param; 우리: from-edicus/request-prod-info). waiting-for-ddp-data 미재현. |
| **iframe URL cmd**: create/open/reform/edit-template/recycle + 40+ 공통param + wait_* flag | `buildIframeSrc`: **cmd=create 고정** + token + ps_code 만(eb:153-159) | **부분재현(과축약)** open(EDIT)·reform 분기 없음. NEW만. 공통param·wait_* flag 없음(deferred 미연동). 06맵 NEW/EDIT 분기(mode:"EDIT"→projectId) 미반영. |
| **auto-save**: load-report 시 setInterval(분단위 command:save) | 없음 | **누락** (장세션 자동저장 부재 — 데이터 유실 위험, 에디터측 책임일 수 있음) |
| **토큰 50min auto-refresh + verifyToken** | 없음 — BFF.editorConfig()가 토큰 발급, 위젯 미보관(ws:216-218) | **부분(경계이전)** 토큰 보관 안 함은 보안상 OK. 단 **장세션 토큰만료 시 request-user-token 응답·refresh 없음**(B-1 #28과 동일 GAP). |
| **inheritToken 분기**(부모 토큰 상속) | 없음 | **누락** (현 단일토큰 모델; 부모컨텍스트 상속 시나리오 미지원) |
| **destroy**(리스너제거+iframe제거+콜백null) | `detach`(eb:105-109) + EditorOverlay cleanup(eo:41-44) | **재현** |

---

## LOSS / IMPROVEMENT REGISTER (D3)

### LOSS
| ID | 손실 | 심각도 | Red 근거 | 재현 명세 (코드 변경 X) |
|----|------|--------|----------|--------------------------|
| **L-D3-1** | goto-cart/close 시 isReadyToOrder(서버 주문가능) 미호출 | **MAJOR** | `edsdk:11397` | goto-cart 핸들러에서 어댑터 isReadyToOrder(projectId)→can_order/doc_rev 판정 후 onResult. 후니 백엔드 어댑터에 대응 엔드포인트. |
| **L-D3-2** | request-user-token → send-user-token 토큰갱신 응답 | **MAJOR** | `edsdk:11419-11429` | 장세션 에디터 토큰 만료 시 에디터가 토큰요청 → 어댑터 재발급 → post_to_editor('send-user-token'). 미구현 시 장시간 편집 실패. |
| **L-D3-3** | page-count-changed 수신 → 가격재계산 | MAJOR (책자·다페이지) | `edsdk:11432`(T) | 편집 중 페이지수 변동 실시간 수신 → schedulePriceQuote. 현재 goto-cart totalPageCount 로만 반영(편집 중 가격 미갱신). |
| **L-D3-4** | prod-var-changed(커스텀탭 자재변경) 실시간 가격 | MAJOR (커스텀탭 상품) | `edsdk:11432`(C) | 06맵 getKOIEditorTabData 와 연동 — 에디터 내 자재변경 시 가격 재산정. 미수신. |
| **L-D3-5** | EDIT(open/reform) cmd 분기 + 공통URL param + wait_* flag | MAJOR | `edsdk:2646-2663`,§8 | buildIframeSrc 가 cmd=create 고정. 재편집(projectId open)·reform·deferred wait_* 미지원. 06맵 NEW/EDIT 분기 연동. |
| **L-D3-6** | deferred 액션명/type 불일치 + 11param/ddp 핸드셰이크 | MINOR | `edsdk:2580-2632` | request-prod-info(from-edicus) → Red waiting-for-extra-param(from-edicus-private)·waiting-for-ddp-data 로 정합. 실 Edicus 핸드셰이크 키 빌드타임 검증. |
| **L-D3-7** | auto-save setInterval | MINOR | `edsdk:11349` | 분단위 command:save. 데이터유실 방지. 에디터측 자체수행이면 불요 — 빌드타임 확인. |
| **L-D3-8** | save-doc-report phase/status 게이트 없음 | MINOR | `edsdk:11386`(status="end") | docInfo 보관 시 phase:"end" 게이트 없이 매 save-doc-report 흡수. start/end 구분 미반영(중간 docInfo 덮어쓰기 가능, 무해하나 정합 아님). |
| **L-D3-9** | inheritToken 부모토큰 상속 | LOW | `edsdk:10520` | 부모 컨텍스트 토큰 상속 시나리오. 현 모델 미지원. |
| **L-D3-10** | 에디터 내부 UX 이벤트 20여종(history/scene/font/impose/imgpool/select 등) | LOW | `edsdk:11419-11432` | 위젯 주문플로우 무관 — 호스트 셸/에디터 책임. 의도적 무처리 OK. |

### IMPROVEMENT (Red 대비 우월 — 유지)
| ID | 개선 | Red 결함 |
|----|------|----------|
| **I-D3-1** | 수신 origin allowlist 검증(파싱 전, eb:111-113) | Red 수신 origin 미검증 |
| **I-D3-2** | 송신 targetOrigin 명시(eb:93-95) | Red `postMessage(..., "*")` |
| **I-D3-3** | e.source 인스턴스 라우팅(eb:115) | Red 멀티인스턴스 라우팅 없음 |
| **I-D3-4** | 토큰 위젯 미보관(즉시 URL 전달, ws:216·eb:153) | Red sessionStorage editorToken 보관(노출면 큼) |
| **I-D3-5** | goto-cart case 미해석 패스스루(eb:28·141) | (Red도 동일 — 정합. over-engineer 안 함 ✓) |
| **I-D3-6** | Shadow Root 내부 포털 격리(eo:50·77) | Red 호스트 body iframe |

---

## 정합 확인 (회귀 가드)
- origin allowlist + targetOrigin + source 라우팅(B-3) — Red 초과. **유지.**
- goto-cart case 미해석(B-2) — Red 정합. **유지(case switch 추가 금지).**
- 토큰 미보관·즉시전달 — 보안 우월. **유지.**
- detach/cleanup 라이프사이클(eb:105, eo:41) — Red destroy 등가. **유지.**
- 위젯 무관 에디터 내부이벤트 무처리 — 의도적. **유지.**
