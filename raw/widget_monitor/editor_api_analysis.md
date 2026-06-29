# RedPrinting 에디터 API 분석 리포트

## 캡처 일시
2026-03-31, 상품: GSTGMIC (마이크 네임택, 굿즈 카테고리)

---

## 1. 에디터 도메인 구조

| 도메인 | 역할 |
|--------|------|
| `www.redprinting.co.kr` | 상품 페이지, 위젯 API |
| `widget-api.redprinting.co.kr` | Shadow DOM 위젯 전용 API |
| `makers.redprinting.net` | **Edicus 에디터 백엔드** (핵심) |
| `d2vgy67dgpwzce.cloudfront.net` | RedEditorSDK.min.js CDN |

---

## 2. 에디터 초기화 API 플로우

### Step 1: 세션 토큰 획득
```
POST https://makers.redprinting.net/token
Content-Type: application/json
Body: {"type":"verify"}

Response: {"refreshToken":"KjcXwMYx7xvbG9rd8pqkaMemhkBkm9"}
```
- **조건**: redprinting.co.kr 세션 쿠키 필요
- 로그인 없이 호출 시 → 500 (Bad Request)

### Step 2: Firebase JWT 발급
```
POST https://makers.redprinting.net/editor
Content-Type: multipart/form-data

target=issueUserToken
uid=cmVkc...  (← redprinting user ID, base64 인코딩)

Response: {
  "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."  // Firebase JWT
}
```
- JWT 유효기간: 1시간 (exp: iat+3600)
- issuer: `edicusbase@appspot.gserviceaccount.com` → **Edicus Firebase 프로젝트**

### Step 3: Edicus 상품 정보 조회
```
POST https://makers.redprinting.net/editor
Content-Type: multipart/form-data

target=getProductInfo
uid=cmVkc...
pdtCode=GSTGMIC  (← RedPrinting 상품코드)

Response: {
  "product": {
    "productCode": "PA05-PHSTSQP",       // Edicus 내부 상품코드 (RedPrinting 코드와 다름!)
    "division": "red_widget",             // KOI passive mode
    "useFullyFunctionalUI": false,        // 제한된 에디터 UI
    "passiveInfo": {},                    // KOI passive 설정값
    "productName": "판스스퀘어 원형",
    "cateCode": "ZP",
    "dpNameLn": {"en": "PAN Square Stickers (Round)", "ko": "판스스퀘어 원형"},
    "editor": "template",                 // 에디터 타입: template | upload
    "fontClass": "..."
  }
}
```

### Step 4: 템플릿 목록 조회
```
GET https://makers.redprinting.net/v1/templates/PA05-PHSTSQP
  ?limit=0
  &sort={"templateNumber":1}
  &page=1
  &search={}

Response: {
  "list": [{
    "token": "bzAa779oxWPnW2meyDFTCu6HXfc5s7hkAyvWHpLviqW7YDZXCm",
    "programVersion": "excelUpload-v1.0.0",
    "backgroundType": "unknown",
    "pageInfo": [],
    "index": 0,
    "layout_uris": [],
    "unresolved_font_group_ids": [],
    "updatedAt": "2022-11-22T17:33:18.815Z",
    "createdAt": "2022-11-22T17:33:18.815Z",
    "isOrigin": true
  }]
}
```

---

## 3. 상품 코드 매핑 (RedPrinting ↔ Edicus)

| RedPrinting 코드 | 상품명 | Edicus 코드 | Edicus 상품명 |
|-----------------|--------|-------------|--------------|
| GSTGMIC | 마이크 네임택 | PA05-PHSTSQP | 판스스퀘어 원형 |
| GSNTBND (추정) | 뜯어쓰는 노트 | PD10-GSNTBND | 뜯어쓰는 노트 |

- **주의**: RedPrinting 코드와 Edicus 코드가 다를 수 있음
- `getProductInfo` API가 코드 변환 담당

---

## 4. KOI Passive Mode 확인

```json
"division": "red_widget"      // passive mode 식별자
"useFullyFunctionalUI": false  // 에디터 UI 제한 (위젯 내 임베디드 모드)
"passiveInfo": {}              // 추가 passive 설정 (현재 비어있음)
```

RedWidgetSDK ↔ RedEditorSDK 간 통신:
- SDK가 에디터를 `passive` 모드로 초기화
- 외부에서 옵션 변경 시 에디터가 자동 업데이트

---

## 5. 로컬 시뮬레이터 한계 및 대응

### 문제
- `makers.redprinting.net/token` 은 `redprinting.co.kr` 세션 쿠키 필요
- 로컬호스트에서 호출 시 쿠키 없음 → 500 에러
- 에디터 버튼 클릭 시 인증 실패로 에디터 미열림

### 해결 방안 (우선순위 순)

**방안 A: 쿠키 포워딩 (추천)**
1. Chrome에서 redprinting.co.kr 로그인
2. 개발자도구 → Application → Cookies에서 세션 쿠키 복사
3. `server.js` 프록시에 쿠키 하드코딩하여 `/makers-api` 요청에 주입

**방안 B: Chrome Extension**
- 브라우저 확장으로 실제 쿠키를 자동 주입

**방안 C: Playwright 직접 모니터 (Track A)**
- 이미 동작 확인됨 (`browser-editor-monitor.cjs`)
- 실제 사이트에서 에디터 상호작용 캡처

---

## 6. Aurora Widget Engine 적용 포인트

| 발견 | 적용 방향 |
|------|----------|
| `makers.redprinting.net` = Edicus 백엔드 | Huni의 Edicus 엔드포인트 대응 확인 |
| `/token` → Firebase JWT 발급 | Huni는 자체 JWT 또는 Edicus 직접 연동 |
| `getProductInfo`로 RP코드 → Edicus코드 변환 | Huni 상품마스터에 `edicusProductCode` 필드 필요 |
| `division: "red_widget"` = passive mode | Aurora Widget에서 `usePassiveMode: true` 설정 |
| `/v1/templates/{edicusCode}` | 템플릿 목록 API 동일 패턴 사용 가능 |

---

## 7. Shadow DOM 위젯 버튼 구조 (GSTGMIC 실측)

```
Shadow Root (#redWidgetSdk)
├── button.extra-btn     "주문 가능 자재"
├── button.action-btn    "직접 입력하기"
├── button.extra-btn     "템플릿 다운로드"
├── button.upload-btn    "PDF"             ← PDF 업로드
├── button.upload-btn.active "에디터"      ← 에디터 탭 선택 (active)
└── button.upload-btn.edit   "편집하기"    ← 실제 에디터 실행 버튼
```

**주의**: "에디터" 버튼은 탭 전환, **"편집하기"** 버튼이 에디터를 실제로 실행.

---

## 8. 다음 단계

1. **방안 A 구현**: 쿠키 포워딩으로 로컬 에디터 동작 확인
2. **Edicus SDK 분석**: `RedEditorSDK.min.js` vs `ref/edicus.man/` 패턴 비교
3. **Aurora Widget Engine**: `passiveInfo` 스키마 + KOI passive mode 연동 설계
4. **상품 코드 매핑 테이블**: getProductInfo 캡처로 RP→Edicus 코드 매핑 전수 조사
