# editor-integration.md — Edicus 에디터 연동

> 파이프라인 ③. Edicus createProject + KOI passive + from-edicus postMessage 브리지 + origin 검증.
> 근거: [동작분석 runtime §4] 6 from-edicus 라이브 타임라인 / [역공학 editor-bridge] 프로토콜·createProject URL / [동작분석 event-contract §4].

---

## 1. 진입 플로우

[동작분석 §4 라이브] GSTGMIC "편집하기" → 실측 시퀀스:

```
1. store.openEditor(side)
2. BFF POST /editor-config {productCode, side} → NormalizedEditorConfig {psCode,templateUrl,resourceId,token,pluginCustomData}
   (BFF/어댑터가 토큰체인 수행: makers /token, /editor, PUT /template/hit — 위젯 무관)
3. editor-bridge.createProject(config) → Edicus iframe 생성
4. iframe src = {EDICUS_EDITOR_HOST}/ed#/editor_landing?cmd=create&token={JWT}&ps_code={psCode}&...
5. from-edicus 라이프사이클 수신 (§3)
```

> [결정] 위젯은 token을 보관하지 않고 즉시 SDK에 전달(보안 — 메모리 노출 최소). 토큰 발급/갱신(~55분 만료)은 BFF.

---

## 2. KOI passive mode

[동작분석 §4] `div = "red_widget"` = KOI passive mode 식별자. 후니: `div = "huni_widget"`(또는 파트너 식별자, `.env.local` EDICUS_PARTNER_CODE 기반 — 값은 어댑터/BFF가 주입, 위젯 하드코딩 금지).

- passive mode = 호스트가 iframe을 띄우고 postMessage로 제어. Edicus가 자체 UI 풀 제공.
- `pluginCustomData = {mtrlCode}` [동작분석 §4] — 선택 자재를 에디터 캔버스에 반영. 위젯은 불투명 전달.

---

## 3. from-edicus 라이프사이클 (라이브 타임라인 기반)

[동작분석 §4 — 라이브 실측 6 이벤트 + 정적 3]:

```
CreatingProject
 → load-project-report {status:"start", ps_code}          [라이브]
 → ready-to-listen {null}                                  [라이브] (호스트 송신 가능 신호)
 → doc-changed {ps_code,page_count,template_uri,div,vdp_catalog} [라이브]
 → request-prod-info {}                                     [라이브] → 호스트 send-extra-param 응답
 → project-id-created {project_id}                          [라이브] → artifacts[side].projectId 보관
 → load-project-report {status:"end", project_id, edicus_user_id} [라이브]
 ─── 편집 후 ───
 → save-doc-report {phase:"start"|"end", docInfo:{projectID,psCode,tnUrlList,totalPageCount}} [정적/부분]
 → goto-cart {projectID, tnUrlList, totalPageCount, case}   [정적/부분] → 편집완료 확정
 → close                                                    [정적]
```

### 핸들러 (editor-bridge)

```ts
function onEdicusMessage(e: MessageEvent) {
  if (!isAllowedOrigin(e.origin)) return;               // §4 origin 검증 — 최우선
  const d = parse(e.data);
  if (d.type !== 'from-edicus') return;                 // type 필터 [event-contract §4]
  switch (d.action) {
    case 'request-prod-info':                            // deferred-param 핸드셰이크 공개신호
      postToEditor('to-edicus-root', 'send-extra-param', buildProdInfo());  break;
    case 'project-id-created':
      store.setArtifactPartial(side, { projectId: d.info.project_id });      break;
    case 'save-doc-report':
      if (d.info?.docInfo) lastDocInfo = d.info.docInfo;                     break;
    case 'goto-cart': {
      const r: NormalizedEditorResult = {                // 정규화 변환 (어댑터 경계)
        side,
        projectId: d.info.projectID,
        thumbnailUrls: d.info.tnUrlList ?? lastDocInfo?.tnUrlList ?? [],
        totalPageCount: d.info.totalPageCount ?? lastDocInfo?.totalPageCount ?? 0,
      };
      store.setArtifact(side, { kind: 'editor', ...r });
      closeOverlay();
      emit('huni:editor-close', r);
      break;
    }
    case 'close': closeOverlay(); break;
  }
}
```

> [동작분석 event-contract §4] index.html 검증 핸들러를 정규화 형태로 이식. `goto-cart`의 tnUrlList 누락 시 docInfo fallback 로직 보존(라이브 검증된 호스트 동작).

---

## 4. origin 보안 [리서치 후합류 검토 — established practice 적용]

[HARD] postMessage 수신 시 **origin 검증을 최우선**(payload 파싱 전).

```ts
const ALLOWED_ORIGINS = [
  EDICUS_BASE_HOST,    // 운영 (edicusbase.firebaseapp.com) — .env에서 주입
  EDICUS_EDITOR_HOST,  // 개발 stage 등
];
const isAllowedOrigin = (o: string) => ALLOWED_ORIGINS.includes(o);
```

- [동작분석 §4] 라이브 origin = `https://edicusbase.firebaseapp.com` 확인.
- 송신 시: `iframe.contentWindow.postMessage(JSON.stringify(msg), targetOrigin)` — [결정] `targetOrigin`을 `"*"` 대신 **명시 origin**으로(Red은 `"*"` 사용; 후니는 보안 강화). 단 Edicus가 sandbox/redirect로 origin이 바뀌면 `"*"` 폴백 필요 여부 확인 [리서치 후합류 검토].
- origin 값은 `.env.local`(EDICUS_BASE_HOST 등)에서 BFF가 위젯 init opts로 주입. 위젯 하드코딩 금지.

---

## 5. 멀티 인스턴스 message 라우팅

[shadow-dom-strategy §5] `message` 리스너는 document 레벨(window 이벤트). 한 페이지 N위젯 시:

- editor-bridge는 인스턴스별 `{instanceId, openSide, iframeEl}` 추적.
- `e.source === iframeEl.contentWindow`로 어느 인스턴스의 에디터인지 식별 → 해당 store로만 dispatch.
- [결정] 리스너는 인스턴스별 등록(각자 source 비교) — Red의 1회 등록 플래그(`__KOI_EVENT_LISNTER_INITIALIZE`)는 단일 인스턴스 가정이라 후니는 인스턴스별로.

---

## 6. 정규화 계약 경계

| from-edicus | 정규화 출력 | 어댑터 책임(후니) |
|-------------|------------|------------------|
| editor-config 요청 | `NormalizedEditorConfig` | 후니 백엔드가 Edicus token·psCode·template 발급 |
| goto-cart | `NormalizedEditorResult` → `NormalizedArtifact(kind:editor)` | 후니 주문데이터 매핑 |

> psCode 형식 `{edicusPsCode}@{productCode}` [동작분석 §4]. 후니는 `{edicusPsCode}@{huniProductCode}` 매핑 — 어댑터 책임.

---

## 7. OPEN

- `save-doc-report`/`goto-cart`/`close` 실시간 캡처 — 본 세션 미트리거(편집 미수행). 정적+핸들러 근거. hw-qa가 실편집 플로우로 검증 권장 [역공학·동작분석 부분].
- `goto-cart` `case` 값 종류 — 미캡처. 위젯은 case를 pass-through(해석 안 함)로 흡수 [동작분석 미검증].
- targetOrigin 명시 vs `"*"` — Edicus redirect 동작 확인 필요 [리서치 후합류 검토].
