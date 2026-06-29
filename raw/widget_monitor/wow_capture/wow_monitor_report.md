# WowPress 실사이트 캡처 분석 보고서

- **캡처 일시**: 2026-03-31T02:06:04 KST
- **대상 사이트**: https://wowpress.co.kr
- **캡처 도구**: Playwright 1.54.2 (headless Chromium)
- **캡처 버전**: fresh_v2

## 1. 캡처 결과 요약

| 상품 | ProdNo | 접근 | 셀렉트 수 | API 호출 | 캐스케이드 | 에디터 |
|------|--------|------|-----------|----------|------------|--------|
| 일반명함 | 40073 | ✅ | 28 | 64 | 4건 | ✅ 이지템플릿 |
| 합판전단 | 40026 | ✅ | 13 | 60 | 3건 | ✅ 이지템플릿 |
| 스티커 | 40002 | ❌ | - | - | - | - |
| 책자 | 40004 | ✅ | 14 | 55 | 2건 | ✅ 이지템플릿 |
| 굿즈 | 40520 | ❌ | - | - | - | - |

- **성공**: 3/5 상품 (60%)
- **실패 원인**: 스티커·굿즈 페이지 30초 타임아웃 (서버 응답 지연 또는 무거운 페이지)
- **총 API 호출**: 179건, **고유 엔드포인트**: 12개 (WowPress 자체)

---

## 2. 옵션 캐스케이드 패턴

### 2.1 옵션 구조

WowPress는 **jQuery 기반 서버사이드 렌더링 + AJAX** 방식으로 옵션을 처리한다.
모든 옵션은 HTML `<select>` 요소로 구현되며, Vue/React 프레임워크를 사용하지 않는다.

**옵션 계층 (명함 기준)**:
```
category1 (대분류: 23개) → category2 (소분류: 8개)
  → SelfCNoSize (에디터 사이즈: 4개)
  → pdata_00_sizeno (인쇄 사이즈: 4개)
    → pdata_00_colorno (색상모드: 2개)
      → spdata_00_paperno3/4 (용지 앞/뒤: 2개)
        → spdata_00_ordqty (수량: 29개)
          → pdata_00_ordcnt (주문건수: 50개)
            → spdata_00_awk* (후가공 옵션: 13개 셀렉트)
```

### 2.2 캐스케이드 트리거 → API 호출 매핑

| 트리거 (옵션 변경) | 호출되는 API | 설명 |
|-------------------|-------------|------|
| **사이즈 변경** | Size → Paper → jobqty0 → jobcost0 → exitday | 5 API 연쇄 호출 |
| **색상 변경** | Paper → jobqty0 → jobcost0 → exitday | 4 API 연쇄 |
| **용지 변경** | Paper → jobqty0 → jobcost0 → exitday | 4 API 연쇄 |
| **수량 변경** | jobcost0 → exitday | 2 API 연쇄 |

**핵심 발견**: 옵션 변경 시 항상 `jobcost0`(가격) + `exitday`(출고일)가 함께 호출됨.
가격과 납기가 동시에 재계산되는 패턴.

---

## 3. 가격 API 구조

### 3.1 핵심 가격 엔드포인트

#### `POST /ord/calc/jobqty0` — 수량→가격 계산
```
요청: SNo, ProdNo, Job, JobNo, CoverCD, PJoin, OrdCnt, OrdQty, SizeNo, WSize, HSize, ColorNo, PaperNo...
응답: {
  "jobcost": [{
    "SizeNo": "5458",
    "Cost1": 3300,        ← 기본 인쇄비
    "Cost2": 0,           ← 추가비
    "Cost": 3300,         ← 합계
    "JobQty": 500,        ← 실제 작업 수량
    "Weight": 0.49275,    ← 중량(kg)
    "ExitDay": 0,         ← 추가 출고일
    "NameFull": "합판옵셋인쇄",
    "ColorNo": "255",
    "JobNo": "3110",
    "PaperNo": "22907"
  }]
}
```

#### `POST /ord/calc/jobcost0` — 총 비용 계산
```
요청: JSON body {
  "PJoin": "0",
  "ProdNo": "40073",
  "Job": [{
    "SNo": "1", "CostKD": -1, "ProdNo": "40073",
    "Job": "PRS", "JobNo": "3110", "CoverCD": 0, ...
  }]
}
응답: {
  "msg": "<div class='row'>...[인쇄비]...합판옵셋인쇄...3,300원...</div>"
}
```
⚠️ **주의**: `jobcost0` 응답은 **HTML 마크업**으로 반환됨. JSON 구조화된 가격이 아닌 렌더링용 HTML.

#### `POST /ord/cart/exitday` — 출고일 계산
```
요청: ProdNo, JobNos, PaperNos, ColorNos, SizeNos
응답: {
  "result": {
    "prodno": 40073,
    "exit_day": "2026-04-01",     ← 출고 예정일
    "base_day": "2026-03-31",     ← 기준일
    "base_t": "18:30",            ← 마감 시간
    "add_size_exitday": 0,
    "add_color_exitday": 0,
    "add_paper_exitday": 0,
    "add_over_t": 0
  }
}
```

### 3.2 가격 샘플 (캡처된 실제 데이터)

| 상품 | 사이즈 | 색상 | 수량 | 가격(원) |
|------|--------|------|------|----------|
| 일반명함 | 90x50 | 단면 칼라4도 | 500매 | 3,300 |
| 일반명함 | 90x50 | 양면 칼라8도 | 500매 | 4,100 |
| 일반명함 | 50x90 | 양면 칼라8도 | 500매 | 3,900 |
| 합판전단 | A4(국8절) | 단면 칼라4도 | 0.5연 | 28,000 |
| 합판전단 | A2(국2절) | 단면 칼라4도 | 4연 | 188,000 |
| 합판전단 | A2(국2절) | 양면 칼라8도 | 4연 | 236,000 |
| 책자 | 220x310 | 단면 칼라4도 | 300부 | 200,000 |
| 책자 | 220x310 | 양면 칼라8도 | 300부 | 227,200 |

### 3.3 RedPrinting 대비 가격 API 비교

| 항목 | WowPress | RedPrinting |
|------|----------|-------------|
| 가격 계산 | `jobcost0` (HTML 반환) | `get_ajax_price_vTmpl` (JSON 반환) |
| 수량 계산 | `jobqty0` (별도 엔드포인트) | 가격 API에 통합 |
| 출고일 | `exitday` (별도 엔드포인트) | 가격 API에 통합 |
| 응답 형식 | **HTML 마크업** | **구조화된 JSON** |
| 옵션 의존성 | 서버에서 select option 교체 | `req_*/rst_*` 제약조건 시스템 |
| 후가공 코드 | `awk{5자리}` 패턴 | `awk_job_info` 그룹 |

---

## 4. UX 흐름 비교 (WowPress vs RedPrinting)

| 항목 | WowPress | RedPrinting |
|------|----------|-------------|
| **프레임워크** | jQuery + SSR | Vue 3 + Shadow DOM |
| **옵션 UI** | HTML `<select>` 드롭다운 | Vue 컴포넌트 (탭/버튼/셀렉트 혼합) |
| **상품→견적 스텝** | 3단계 (옵션→파일→주문) | 2단계 (위젯→주문) |
| **가격 표시** | 서버에서 HTML 렌더링 후 삽입 | 클라이언트 JSON 파싱 후 렌더링 |
| **에디터 연동** | 이지템플릿 (별도 페이지 이동) | KOI passive mode (인라인 iframe) |
| **옵션 개수** | 명함 28개 / 전단 13개 / 책자 14개 | 명함 ~15개 / 전단 ~10개 |
| **상품 카테고리** | 23개 대분류 | 별도 카탈로그 페이지 |
| **실시간 갱신** | 옵션 변경마다 AJAX 호출 | Pinia store 반응형 갱신 |
| **모바일 대응** | 반응형 (Bootstrap 기반) | Shadow DOM 캡슐화 |

---

## 5. 에디터 통합 분석

### 5.1 이지템플릿 (EasyTemplate)

- **진입**: `movePage('/self/dsgn/landing', '')` — 별도 페이지로 이동
- **제품 카탈로그**: `/self/dsgn/getproduct` — 16개 제품 타입 (명함, 배너, 폰케이스, 스티커 등)
- **사이즈**: `/self/dsgn/getsizes` — 제품별 작업 사이즈 (pcWorkWidth × pcWorkHeight)
- **템플릿**: `/self/dsgn/gettemplate` + `/self/dsgn/template/group/{id}` — 카테고리별 템플릿

### 5.2 RedPrinting KOI 에디터 대비

| 항목 | WowPress 이지템플릿 | RedPrinting KOI |
|------|---------------------|-----------------|
| 에디터 통합 | 별도 페이지 이동 | iframe 인라인 삽입 |
| 상태 공유 | 페이지 간 파라미터 전달 | postMessage 실시간 통신 |
| 제품 지원 | 16개 타입 | 전 상품 지원 |
| 디자인 방식 | 템플릿 기반 편집 | 자유 편집 + 템플릿 |

---

## 6. WowPress 강점 / 약점 분석

### 강점
1. **풍부한 상품 카테고리**: 23개 대분류, 다양한 소분류 (명함/스티커/책자/사인/굿즈 등)
2. **실시간 출고일 계산**: 옵션 변경마다 출고일 자동 갱신
3. **세분화된 수량 옵션**: 전단 201개 수량 옵션, 명함 29개 등
4. **멤버십 등급 시스템**: VIP~VVIP 10단계 적립률 차등
5. **통합 주문 시스템**: 다양한 상품을 하나의 장바구니에서 관리

### 약점
1. **레거시 프레임워크**: jQuery 기반으로 컴포넌트 재사용성 낮음
2. **HTML 가격 응답**: `jobcost0`가 HTML을 반환하여 클라이언트 파싱 불가
3. **에디터 분리**: 이지템플릿이 별도 페이지로 이동 (UX 단절)
4. **과다한 셀렉트**: 명함 28개 셀렉트는 UX 복잡도 높음
5. **페이지 로딩 불안정**: 일부 상품 페이지 30초 타임아웃 (스티커, 굿즈)
6. **옵션 의존성 불명확**: UI에서 어떤 옵션이 어떤 옵션에 영향을 주는지 시각적 표시 없음

---

## 7. 후니프린팅 적용 권고사항

### 7.1 채택할 패턴
1. **가격+출고일 동시 갱신**: 옵션 변경 시 가격과 납기를 동시에 보여주는 UX 패턴 채택
2. **세분화된 수량 옵션**: 상품 유형별 세밀한 수량 브래킷 설계 (합판 0.5연~200연)
3. **상품 카테고리 풍부성**: 23개+ 대분류 수준의 카탈로그 확보 목표

### 7.2 개선할 패턴
1. **JSON 가격 API**: WowPress의 HTML 반환 대신 구조화된 JSON으로 가격 데이터 반환
2. **에디터 인라인 통합**: 이지템플릿의 페이지 이동 방식 대신 RedPrinting KOI 방식의 인라인 에디터
3. **옵션 복잡도 축소**: 28개 셀렉트를 단계별 가이드로 재구성 (5~7개 핵심 옵션 + 고급 옵션 폴드)
4. **반응형 컴포넌트**: jQuery select 대신 Vue/React 컴포넌트로 옵션 캐스케이드 구현
5. **제약조건 시각화**: RedPrinting의 req_*/rst_* 패턴을 참고하여 옵션 간 의존성을 UI에서 명시

### 7.3 핵심 API 설계 시사점
- WowPress의 `jobqty0` + `jobcost0` + `exitday` 3-API 분리 → 후니에서는 **단일 `/api/quote` 엔드포인트**로 통합 권장
- 응답은 반드시 JSON 구조화 (`{price, breakdown, exitDay, weight}`)
- RedPrinting의 `ORD_INFO` + WowPress의 `Job[]` 패턴 융합하여 주문 데이터 모델 설계

---

## 부록: 캡처 파일 목록

| 파일 | 설명 |
|------|------|
| `fresh_wow_summary.json` | 전체 캡처 요약 |
| `fresh_namecard_capture.json` | 명함 상세 캡처 (64 API) |
| `fresh_flyer_capture.json` | 전단 상세 캡처 (60 API) |
| `fresh_booklet_capture.json` | 책자 상세 캡처 (55 API) |
| `fresh_*_1_initial.png` | 초기 로딩 스크린샷 |
| `fresh_*_2_options.png` | 옵션 변경 후 스크린샷 |
| `fresh_*_3_final.png` | 최종 상태 스크린샷 |
| `wow_summary.json` | 통합 요약 (이전 + 최신) |
