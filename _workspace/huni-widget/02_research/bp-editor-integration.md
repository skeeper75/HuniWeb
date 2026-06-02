# 에디터 통합 베스트프랙티스 (postMessage 보안·핸드셰이크·토큰)

> 파이프라인 ② 산출물. Edicus iframe 에디터 ↔ 호스트 위젯 postMessage 통합의 보안·라이프사이클·토큰 베스트프랙티스.
> 기준선: RedPrinting Edicus 브릿지(`editor-bridge-protocol.md`) — `to-edicus*`/`from-edicus*` 양방향 프로토콜, deferred-param 핸드셰이크, `save-doc-report`→`goto-cart` 라이프사이클, red-editor-token JWT(~55분 만료, 자동갱신).
> 모든 인용은 WebFetch 검증 URL만. 출처는 하단 `Sources:`.

---

## 1. postMessage 보안 3원칙 (MDN 공식)

MDN 공식 보안 가이드 [MDN-pm]:

1. **targetOrigin에 `*` 금지 (민감 데이터)**: "Always provide a specific `targetOrigin`, not `*`. ... A malicious site can change the location of the window without your knowledge, and therefore it can intercept the data sent using postMessage." `*`는 `data:` URL에만 허용.
2. **수신 시 발신자 신원 검증**: "If you do expect to receive messages from other sites, **always verify the sender's identity** using the `origin` and possibly `source` properties."
3. **수신 데이터 신뢰 금지**: "always verify the syntax of the received message. Otherwise, a security hole in the site you trusted ... could then open a cross-site scripting hole in your site."

권장 패턴 [MDN-pm]:
```js
window.addEventListener("message", (event) => {
  if (event.origin !== "https://edicusbase.firebaseapp.com") return;  // 1) origin 검증
  // 2) 메시지 스키마 검증 (type/action 화이트리스트)
  // 3) event.source로 응답 (검증된 origin echo back)
});
```

**RedPrinting 현황 vs 베스트프랙티스 갭**: `editor-bridge-protocol.md` §1은 RedPrinting이 `iframe.contentWindow.postMessage(JSON.stringify(msg), "*")`로 **와일드카드 targetOrigin**을 쓰고, 수신 리스너는 type 분기만 한다고 기록. 즉 **Red는 origin 검증이 느슨**하다 — 이는 답습 대상이 아니라 **후니가 개선할 지점**.

## 2. 후니 권고 — origin 검증 강화

| 항목 | RedPrinting (기준선) | 후니 권고 | Priority |
|------|---------------------|-----------|----------|
| 송신 targetOrigin | `"*"` | `https://edicusbase.firebaseapp.com`(운영) / stage(개발) 명시. Edicus base_url 상수화 | High |
| 수신 origin 검증 | type 분기만 | `event.origin` 화이트리스트 검증 후 처리(미일치 즉시 return) | High |
| 메시지 스키마 | type/action 문자열 | `{type, action, info}` 구조 + action 화이트리스트 + info 스키마 검증 [Bindbee][MDN-pm] | High |
| 데이터 신뢰 | - | 수신 `info`(projectID/tnUrlList/totalPageCount)를 정규화 계약으로 매핑 전 검증·sanitize | High |

Edicus base_url은 운영 `https://edicusbase.firebaseapp.com`, 개발 `https://edicus-stage.firebaseapp.com`(`editor-bridge-protocol.md` §1)으로 확정되어 있으므로 **origin 화이트리스트가 명확** — 와일드카드 사용 정당성 없음.

## 3. iframe 샌드박스·CSP

검증된 임베드 iframe 보안 [Didit]:
- **sandbox 속성**: "Always use the `sandbox` attribute to restrict iFrame capabilities." 기본 sandbox(값 없음)에서 시작해 필요한 권한만 추가(`allow-scripts`, `allow-forms`, `allow-same-origin` 등 최소). HTML5 sandbox는 "arguably the most critical security feature for iFrames" [WebSearch:iframe].
- **CSP frame-src**: 임베드 허용 origin 명시 — `frame-src 'self' https://edicusbase.firebaseapp.com` [Didit].
- **CSP frame-ancestors**: 클릭재킹 방지 — 후니 위젯이 호스트에 임베드되는 경우 `frame-ancestors`로 허용 호스트 제어 [Didit].
- **HTTPS 전구간**: MITM 방지 [WebSearch:iframe].

**후니 권고 (Priority High)**: Edicus iframe에 sandbox 적용 — Edicus는 스크립트·폼 실행이 필요하므로 `allow-scripts allow-forms allow-same-origin allow-popups` 등 **Edicus 동작에 필요한 최소 권한만** 부여(실측으로 확정). CSP `frame-src`에 Edicus origin 화이트리스트.

## 4. 핸드셰이크·라이프사이클 (Edicus 실프로토콜)

Edicus는 일반적인 "iframe.onload 후 메시지 송신" 단순 패턴 [MDN-pm][Bindbee]을 넘어 **deferred-param 핸드셰이크**를 사용(`editor-bridge-protocol.md` §3~4):

```
iframe src URL: {base}/ed#/editor_landing?cmd=create&token={JWT}&ps_code=...&wait_prod_info=true&wait_options=true
에디터 → 호스트:  {type:"from-edicus-private", action:"waiting-for-extra-param",
                   info:{param_names:["prod_info","options",...]}}
호스트 → 에디터:  {type:"to-edicus-root", action:"send-extra-param",
                   info:{params:[{name:"prod_info", prod_info:{...}}, ...]}}
```
→ 큰 데이터(prod_info/options/ddp_block 등)는 URL이 아닌 **준비 완료 후 요청-응답**으로 전달. `from-edicus-private`는 SDK 내부 처리(호스트 콜백 미노출).

라이프사이클 (호스트 수신, `editor-bridge-protocol.md` §5):
```
init → ready-to-listen → doc-changed → project-id-created
     → save-doc-report:start → save-doc-report:end → goto-cart → close
```
- `save-doc-report`: `info.docInfo.{projectID, psCode, tnUrlList, totalPageCount}` 획득.
- `goto-cart`: 편집 완료·주문 데이터 확정 → 위젯이 오버레이 닫고 주문 데이터에 projectID·썸네일·페이지수 반영.

**후니 권고 (Priority High)**:
- 후니 위젯은 **createProject(token, ps_code, title) → deferred-param 응답(prod_info/options) → save-doc-report 수신(projectID 보관) → goto-cart 수신(주문확정)** 시퀀스만 구현하면 핵심 충족(`editor-bridge-protocol.md` §8).
- `from-edicus:goto-cart` → 위젯 **정규화 계약(projectID·tnUrlList·totalPageCount)** 매핑 어댑터로 처리(위젯 코드 ↔ Red/후니 차이 흡수).
- 수신 핸들러는 §1~2 origin·스키마 검증 통과 후에만 라이프사이클 상태 전이.

## 5. 토큰 갱신·라이프사이클

RedPrinting 토큰 모델(`widget-runtime-spec.md` §5, `editor-bridge-protocol.md` §7):
- 인증 = **세션 쿠키(본서버)** + **red-editor-token JWT 헤더**(widget-api/makers-api). Authorization/Bearer/CSRF/API키 없음.
- JWT 만료 **~55분, 자동 갱신**. 토큰은 `POST /api/editor/config/{KOI|RP}` 응답의 `config.token`으로 발급.

검증된 일반 원칙: 메시지에 **필요 최소 정보만** 포함 — "Only send the necessary information required for the operation, limiting the scope of the data to what is absolutely needed" [WebSearch:iframe-sec]. 토큰 전송도 최소·명시 origin 한정.

**후니 권고 (Priority High)**:
- 토큰(JWT)은 후니 백엔드 어댑터가 발급(`editor-bridge-protocol.md` §8.3). Edicus iframe URL `&token=`으로 전달 시 **명시 origin** + HTTPS.
- 토큰은 위젯 메모리 스토어(Zustand)에만 보관, DOM·로컬스토리지 미노출(`bp-react-shadow-dom.md` §6, `bp-embed-widget.md` §6).
- **~55분 만료 대비 선제 갱신**: 만료 전 백그라운드 재발급 후 진행 중 에디터 세션에 갱신 토큰 반영(장시간 디자인 작업 중 만료 방지). 갱신 실패 시 사용자에게 명확한 재인증 유도(작업 손실 방지 위해 doc 자동 저장 상태 확인).

## 6. 함정 모음

| 함정 | 대응 |
|------|------|
| 와일드카드 origin 데이터 누출 | targetOrigin·event.origin 모두 Edicus origin 명시(§2) |
| 검증 없는 메시지 → XSS | action 화이트리스트 + info 스키마 검증 후 처리 [MDN-pm] |
| 오버레이가 Shadow 밖 | Edicus iframe 오버레이를 Shadow Root 내부 포털 컨테이너에 마운트(`bp-react-shadow-dom.md` §5) |
| 토큰 만료 중 작업 손실 | 선제 갱신 + doc 자동저장 + 재인증 가드 |
| deferred-param 누락 | `waiting-for-extra-param` 요청에 prod_info/options 정확 응답 필수(미응답 시 에디터 무한 대기) |
| sandbox 과소/과대 | Edicus 필요 최소 권한 실측 확정 |

## 7. 후니 채택 결론

| 결정 | 권고 | Priority |
|------|------|----------|
| origin 보안 | 송수신 모두 Edicus origin 명시 검증 (Red 와일드카드 개선) | High |
| 메시지 검증 | action 화이트리스트 + info 스키마 + sanitize | High |
| iframe 격리 | sandbox 최소권한 + CSP frame-src/frame-ancestors | High |
| 라이프사이클 | createProject→deferred-param→save-doc-report→goto-cart, 어댑터 매핑 | High |
| 토큰 | 백엔드 발급·메모리 보관·~55분 선제 갱신·HTTPS·명시 origin | High |
| 오버레이 | Shadow 내부 포털 컨테이너 마운트 | High |

---

## Sources:

- [MDN-pm] Window.postMessage() — https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage (WebFetch 검증: API 시그니처·targetOrigin `*` 금지·event.origin/source 검증·수신 데이터 신뢰 금지·권장 패턴)
- [Didit] Embedded iFrame Security Best Practices — https://didit.me/blog/embedded-iframe-security-best-practices/ (WebFetch 검증: sandbox 최소권한·CSP frame-src·frame-ancestors·event.origin 검증)
- [Bindbee] Securing Cross-Window Communication: postMessage — https://bindbee.dev/blog/secure-cross-window-communication (WebFetch 검증: origin 화이트리스트 송수신·와일드카드 회피·수신 데이터 검증/sanitize·타입 메시지 핸드셰이크)
- [WebSearch:iframe] Embedded iFrame Security / Improving Iframe Security (Jscrambler) — https://jscrambler.com/blog/improving-iframe-security (WebSearch 결과 — sandbox 핵심·HTTPS·최소 정보 전송, 본문 미정독: 보조 인용)
- [WebSearch:iframe-sec] Being Safe and Secure with Cross-Origin Messaging — https://www.secureideas.com/blog/being-safe-and-secure-with-cross-origin-messaging (WebSearch 결과 — 최소 정보 전송 원칙, 본문 미정독: 보조 인용)
