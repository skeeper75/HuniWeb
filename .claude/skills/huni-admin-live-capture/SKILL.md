---
name: huni-admin-live-capture
description: >
  라이브 후니 Django admin을 gstack browse로 안전하게 순회·캡처하는 방법론. .env.local HUNI_ADMIN_*
  로그인, 화면 맵을 작업 큐로 changelist·changeform·인라인·상품뷰어·옵션/SKU 드릴다운·제약 화면을 읽기
  탐색만으로 캡처, 화면 항목(메뉴·컬럼·필터·필드·버튼) 위치 인덱싱, 파일명 규약, 쓰기 금지(저장/삭제 클릭 금지).
  트리거: 라이브 화면 캡처, admin 스크린샷, gstack 캡처, 화면 항목 인덱스, 실제 화면 확인, 캡처 재실행.
  화면 맵 도출은 huni-admin-source-map, 집필은 huni-admin-manual-authoring 담당.
---

# Huni Admin 라이브 캡처

소스 화면 맵이 "있다"고 한 화면을 라이브에서 실제로 열어 **스크린샷으로 증명**하고, 매뉴얼에 임베드할 이미지와 항목 위치 인덱스를 만드는 방법론.

## 안전이 최우선 — 라이브 운영 사이트

이 admin은 **라이브 운영 DB**에 직접 연결된다. 잘못된 클릭 하나가 실데이터를 바꾼다.

- [HARD] **읽기 탐색만**: 목록 열람·폼 화면 열기·드롭다운 펼치기·드릴다운 진입까지. **저장·추가·삭제·논리삭제·제출 버튼을 누르지 않는다.**
- [HARD] **추가(changeform) 화면은 "빈 폼 열기"까지만** 캡처하고 제출하지 않는다. 기존 행은 "보기"로 열되 값 변경 후 저장하지 않는다.
- [HARD] 자격증명(`HUNI_ADMIN_ID/PW`)을 스크린샷 캡션·산출물·stdout에 노출하지 않는다.
- 불확실하면 클릭하지 않는다. 화면을 못 여는 것보다 데이터를 건드리는 게 훨씬 나쁘다.

## 로그인

`.env.local`에서 `HUNI_ADMIN_URL`·`HUNI_ADMIN_ID`·`HUNI_ADMIN_PW`를 읽어 gstack browse로 로그인한다. 로그인 화면(`/admin/login/`)도 매뉴얼 "시작하기"용으로 1장 캡처한다. 로그인 후 홈은 상품뷰어로 redirect됨을 확인.

## 캡처 순회 (화면 맵을 작업 큐로)

소스 화면 맵의 **화면 목록 표**를 우선순위 순으로 1행씩 처리한다:

1. **표준 모델 목록(changelist)** — 좌측 메뉴에서 모델 진입. 목록 컬럼 헤더·검색창·필터 사이드바·페이지네이션·행을 한 화면에 캡처. 필터 사이드바가 접혀 있으면 펼친 상태도.
2. **표준 모델 추가 폼(changeform)** — "추가" 버튼으로 빈 폼 진입(제출 금지). 필드 라벨·위젯 종류(텍스트/드롭다운/날짜)·필수 표시·placeholder·인라인 섹션·자동채번 안내를 캡처. 드롭다운(코드값 FN·YN)은 펼친 상태를 1장 추가해 실제 선택지를 보인다.
3. **인라인 보유 화면** — 상품 등 인라인이 있는 changeform은 인라인 섹션을 펼쳐 캡처(상품 하위: 카테고리·사이즈·인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰).
4. **커스텀 상품뷰어** — 홈(`product-viewer/`) → 상품 상세(`<prd_cd>/`) → 섹션 편집 → 옵션 드릴다운 3계층 → SKU 템플릿 2계층 → 제약 폼빌더·검증 미리보기 → impact·sku-catalog. 드릴다운은 각 계층을 캡처해 "어떻게 파고드는지" 흐름을 보인다.

## 항목 위치 인덱싱

각 스크린샷에 대해 화면 내 주요 항목을 텍스트로 인덱싱한다(작가가 번호 안내 ①②③를 달 수 있게):

```
screen: tprdproducts__changeform
- ① 좌측 도메인 메뉴 (상품 그룹 강조)
- ② 상단 "상품 추가" 제목 + 저장 버튼 바
- ③ prd_nm(상품명) 필수 텍스트 입력
- ④ cat_cd(카테고리) 드롭다운 — 트리 들여쓰기
- ⑤ prd_cd(상품코드) "비우면 저장 시 자동 채번" placeholder
- ⑥ 하단 인라인 섹션 탭/접이식
```

## 파일명 규약

`_workspace/huni-admin-manual/captures/{screen-id}__{state}.png`
- screen-id는 화면 맵과 일치(`tprdproducts`, `product-viewer`, `tprdtemplates` …)
- state: `changelist` / `changeform` / `changeform-dropdown` / `inline` / `home` / `detail` / `options-l1` / `login` 등

## 산출 — 캡처 인덱스

`_workspace/huni-admin-manual/03_capture_screen-index.md`:

| 화면ID | 스크린샷 | 실제 URL | 항목 위치 인덱스 | 라이브 노트 | 상태 |
|--------|----------|----------|------------------|-------------|------|
| tprdproducts__changelist | captures/tprdproducts__changelist.png | /admin/.../tprdproducts/ | (위 형식) | 행 384건 | ✅ |
| tprdtemplates__changeform | — | — | — | change_view가 SKU로 redirect되어 표준 폼 없음 | ⚠️ 라이브 확인 |

마지막에 **캡처 커버리지**(캡처 완료 / 소스 맵 전체)를 집계하고, 미캡처 화면은 사유를 남긴다(전수 추적).

## 완료 기준

- 화면 맵의 모든 High/Medium 화면 캡처 완료(또는 미캡처 사유 명시)
- 각 캡처에 항목 위치 인덱스 존재
- 쓰기 동작 0건(저장/삭제 클릭 없음)
- 소스↔라이브 차이는 노트로 기록(QA가 검토)
