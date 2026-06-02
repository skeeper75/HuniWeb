# 이벤트 계약 (위젯↔호스트 콜백 + Edicus postMessage)

> 파이프라인 ② 산출물. 어떤 이벤트가 어떤 API 호출/상태 변화를 유발하는지의 계약.
> 근거: `[라이브 관찰]` 본 세션 / `[정적 분석]` deob 소스 / `[정적+라이브]` Phase 1.
> 라이브 근거: 호스트 init 시그니처(index.html:584-597), from-edicus 6 이벤트(runtime_capture_GSTGMIC.json).

---

## 1. 위젯 초기화 시그니처 (라이브 관찰된 실제 호출) [라이브 관찰]

RedPrinting 위젯의 실제 호스트 통합 형태는 **콜백 객체 방식**(CustomEvent dispatch가 아님):

```js
const sdk = new RedWidgetSDK('red-pc');         // 'red-pc' = 스킨/디바이스 프로파일
sdk.init(
  { target:'#redWidgetSdk', pdtCode, pttCode:'', locale:'ko',
    member:{ mb_id:'', mb_cust_cod:'', base64ID:'' }, deviceType:'pc' },
  { onOptionChange, onPriceChange, onOpenEditor, onCloseEditor }   // 호스트 콜백
);
```

> **후니 설계 시사**: RedPrinting은 콜백 prop 방식. 후니 React-in-Shadow-DOM 위젯은 동일 콜백 prop을 노출하되, 호스트 통합 유연성을 위해 **CustomEvent dispatch도 병행 제공** 권장(아래 §2 매핑). 어댑터가 콜백↔CustomEvent 양변환.

## 2. 위젯 → 호스트 이벤트 9종 [라이브 4종 + 정적 5종]

| # | 콜백(라이브) | 제안 CustomEvent명 | 발화 시점 | 페이로드 | 트리거하는 API/상태 |
|---|-------------|-------------------|----------|---------|-------------------|
| 1 | `onOptionChange` | `huni:option-change` | 옵션 변경 직후 | `{side, field, value, orderData}` | 캐스케이드 적용 → (debounce) price API |
| 2 | `onPriceChange` | `huni:price-change` | price 200 후 | `{result_sum, result_log, book_info}` | — (표시 갱신) |
| 3 | `onOpenEditor` | `huni:editor-open` | 편집하기 클릭 후 config 수신 | `{mode,type,config,option}` (KOI config) | editor/config/KOI → makers 체인 |
| 4 | `onCloseEditor` | `huni:editor-close` | 에디터 종료/취소 | `{projectID?, case?}` | exterior.editorData 갱신 |
| 5 | `onUploadComplete` [정적] | `huni:upload-complete` | S3 PUT 200 후 | `{side, filename, org_file_nm}` | s3GetObjectJson(메타) |
| 6 | `onValidationChange` [정적/추정] | `huni:validation-change` | canOrder 변화 시 | `{canOrder, reasons[]}` | — (주문버튼 활성/비활성) |
| 7 | `onOrder` / sdkCreatePot [정적] | `huni:order` | 주문 클릭 | `{orderData, projectID, files[]}` | fn_order_able → form submit |
| 8 | `onMaterialInform` [정적] | `huni:materials` | 자재 안내 요청 | `{materials[]}` | guide_product_paper |
| 9 | `onReady` [정적/추정] | `huni:ready` | product_info 적재+마운트 후 | `{pdtCode, baseInfo}` | — (초기화 완료 신호) |

> 1~4는 라이브 관찰(index.html init). 5~9는 정적(브릿지 17함수 — sdkInformMaterials/fnPreOrder/fn_order_able/sdkCreatePot 등)에서 도출한 권장 계약. [라이브+정적]

## 3. 이벤트 → API/상태 트리거 매트릭스 [라이브 관찰]

```
onOptionChange
  ├─ 자재변경 → disable_pcs 룩업(로컬) → pcsInfo 해제 → orderData 갱신
  ├─ 규격/도수/수량 변경 → orderData(sizeInfo/dosuInfo/quantityInfo) 갱신
  └─ (공통) debounce 300ms → POST get_ajax_price_vTmpl → onPriceChange

onPriceChange  → 호스트 가격 표시만 (API 트리거 없음)

onOpenEditor   → 이미 editor/config/KOI 200 받은 후 콜백 발화
                 → 호스트가 RedEditorSDK.createProject 호출
                 → makers /token, /editor, PUT /template/hit

onCloseEditor / goto-cart 수신
                 → exterior.editorData / orderData에 projectID·tnUrlList·totalPageCount 반영
                 → onValidationChange(canOrder 재평가)
```

## 4. Edicus postMessage 이벤트 계약 [라이브 관찰 + 정적]

### iframe → 호스트 (`from-edicus`) — 라이브 캡처된 페이로드 [라이브 관찰]

| action | 라이브 info 스키마 | 호스트 처리 |
|--------|-------------------|------------|
| `load-project-report` | `{status:"start"\|"end", edicus_user_id, project_id, ps_code}` | end 시 projectID·user_id 확정 |
| `ready-to-listen` | `null` | 호스트 to-edicus 송신 가능 신호 |
| `doc-changed` | `{ps_code, page_count, template_uri, div, vdp_catalog[]}` | 문서 상태 갱신 |
| `request-prod-info` | `{}` | deferred-param 핸드셰이크 — 호스트가 `to-edicus-root:send-extra-param` 응답 |
| `project-id-created` | `{project_id}` | exterior.editorData에 projectID 보관 |
| `save-doc-report` [정적/부분] | `{phase, docInfo:{projectID,psCode,tnUrlList[],totalPageCount}}` | __lastEditorDocInfo 보관 |
| `goto-cart` [정적/부분] | `{projectID, tnUrlList[], totalPageCount, case}` | 완료 페이로드 조립 → 주문데이터 반영 → 오버레이 닫기 |
| `close` [정적] | — | 에디터 종료 |

origin 검증: `https://edicusbase.firebaseapp.com` (운영) / `edicus-stage.firebaseapp.com` (개발). [라이브 관찰: origin 확인]

### 호스트 → iframe (`to-edicus-root` / `to-edicus`) [정적 분석]

| action | type | 용도 |
|--------|------|------|
| `send-extra-param` | to-edicus-root | deferred param 응답(prod_info, options, ddp_block) |
| `send-ddp-data` | to-edicus-root | DDP 데이터 전달 |
| `change-project` / `change-template` | to-edicus-root | 프로젝트/템플릿 교체 |
| `change-layout`, `set-item-attribute`, `add-page` ... | to-edicus | 편집 동작 |

### 호스트 수신 핸들러 계약 (index.html, 검증된 동작) [라이브 관찰]
```js
window.addEventListener('message', (e) => {
  const d = JSON.parse(e.data);
  if (d.type !== 'from-edicus') return;          // type 필터
  // 라이프사이클 추적: d.action 기록
  if (d.action === 'save-doc-report' && d.info?.docInfo)
      window.__lastEditorDocInfo = d.info.docInfo;
  if (d.action === 'goto-cart') {
      payload = { projectID: d.info.projectID,
                  tnUrlList: d.info.tnUrlList || docInfo.tnUrlList || [],
                  totalPageCount: d.info.totalPageCount || docInfo.totalPageCount || 0,
                  case: d.info.case };
      // → 주문데이터 반영, 오버레이 닫기, 스토어 스냅샷
  }
});
```

## 5. 정규화 계약 경계 (후니 어댑터) [정적+라이브]

위젯 코드는 아래 정규화 이벤트 계약에만 의존, 어댑터가 RP↔후니 변환:

| 정규화 이벤트 | 위젯 출력 | 어댑터 책임 |
|--------------|----------|------------|
| price-recalc | `{ORD_INFO, PCS_INFO, price_gbn}` | 후니 가격엔진 호출 → result_sum 형태로 정규화 응답 |
| editor-open | `{psCode, templateUrl, resource_id}` + token요청 | 후니 백엔드가 Edicus token·config 발급 |
| editor-complete | `from-edicus:goto-cart` → `{projectID, tnUrlList, totalPageCount}` | 후니 주문데이터 매핑 |
| upload | `{file_name, pdt_cod, content_type}` → presigned | 후니 S3 presigned 발급 |

## 6. 잔존 미검증
- onUploadComplete/onValidationChange/onOrder/onReady 콜백명은 정적 도출(권장 계약) — RP 실제 콜백은 onOptionChange/onPriceChange/onOpenEditor/onCloseEditor 4개만 라이브 확인. [라이브 4 / 정적·추정 5]
- save-doc-report/goto-cart info 추가 필드(case 값 종류) — 라이브 미캡처(편집 미수행). [부분]
- to-edicus 호스트→iframe 실송신 — 본 세션 미관찰(에디터가 자체 처리). [정적]
