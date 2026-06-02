# S5 파우치 GSPUFBC 라이브 캡처 분석 노트

- 캡처일: 2026-06-03 / 테스트베드: localhost:3001 (widget_monitor, 로그인 customerCode 22025916)
- 가격 API: `POST /rp-api/ko/product_price/get_ajax_price_vTmpl`, `price_gbn: tmpl_price`
- 결론: **PRICE>0 달성** (최소 견적 2,850,000원 = 11인치세로 × ORD_CNT 100 × PRN_CNT 1)
- 원시 산출물: `05_qa/captures/s5_pouch_GSPUFBC.json`

---

## ① 파우치 필수옵션 구조

Shadow DOM `#redWidgetSdk` 내 16개 컨트롤. 굿즈/스티커 대비 옵션이 극단적으로 단순하다.

| 옵션 | 컨트롤 | 값/범위 | 가격영향 | 비고 |
|------|--------|---------|----------|------|
| 자재 MTRL_CD | select(material) | PXFBW010 면10수화이트 1종 | 고정 | 단일옵션 (선택 불요) |
| 도수 DOSU_COD | select(dosu) | SID_S 단면 1종 | **없음** | 단면/양면 동일가 |
| 규격 sizes | select(sizes) | 등록 템플릿 5종 | **있음** | 가격 결정의 핵심축 |
| 재단/작업 사이즈 | number×4 | 규격선택 시 자동주입 (읽기전용성) | (규격에 종속) | CUT_WDT/HGH, WRK_WDT/HGH |
| 수량 ORD_CNT | number(unnamed, val=1) | 자유입력 | 선형 | **위젯 reqBody 누락 결함 지점** |
| 인쇄수량 PRN_CNT | select(PRN_CNT) | 1,6,11,...,46 (step5) | 선형배수 | 한 디자인의 인쇄 면/판 수로 추정 |
| 색수 PRN_CLR_CNT | (UI 미노출, reqBody 기본 4) | — | **없음** | 가격 무관 |

규격 5종 실측 템플릿 치수(재단):
11in세로 230×288 / 13in가로 330×250 / 13in세로 250×338 / 15in가로 365×270 / 17in가로 410×284.
**작업사이즈 = 재단 + 각 변 20mm** (블리드 10mm 양변) 일관 규칙 확인.

---

## ② PRICE=0 원인과 PRICE>0 달성 조건

**원인(확정):** tmpl_price 서버는 `ORD_INFO[0]`에 **`ORD_CNT`(주문건수)와 `PRN_CNT`(인쇄수량) 두 필드를 모두** 요구한다. 둘 중 하나라도 없으면 PRICE_LOG가 `인쇄수량 0, 주문건수 0`이 되어 PRICE=0을 반환. 위젯(widget_monitor)이 보낸 실제 reqBody는 두 필드를 **모두 누락**했다(기존 `qtySet:false` 진단과 일치). mb_cust_cod 누락이나 로그인 부족이 원인이 아니다(세션쿠키가 권위라 둘 다 무관).

**달성 조건(실측):** ORD_INFO[0]에 `ORD_CNT≥1` AND `PRN_CNT≥1` 동시 존재 → 즉시 PRICE>0.
- ORD_CNT=100, PRN_CNT=1 → **2,850,000원**.
- PCS_INFO나 top-level에 ORD_CNT/PRN_CNT를 넣어도 무시됨 — **ORD_INFO 배치만 유효**.
- 추가로 규격이 **등록 템플릿 치수에 정확 매칭**해야 함. 임의 (CUT_WDT,CUT_HGH)는 PRICE=0 (템플릿 미존재).

> 위젯 결함 본질: 수량/인쇄수량 UI 컨트롤(unnamed number, PRN_CNT select)의 값이 reqBody ORD_INFO에 매핑되지 않은 채 가격호출이 발생. 헤드리스 자동조작에서도 동일 — 위젯의 옵션→reqBody 바인딩이 이 두 필드에 대해 끊겨 있다.

---

## ③ tmpl_price 수량 거동

**수량할인 곡선 없음 — 완전 선형/평탄.**

ORD_CNT 스윕(11in세로, PRN_CNT=1):

| ORD_CNT | 1 | 2 | 5 | 10 | 30 | 100 | 300 | 1000 |
|---------|---|---|---|----|----|-----|-----|------|
| 개당(원) | 28,500 | 28,500 | 28,500 | 28,500 | 28,500 | 28,500 | 28,500 | 28,500 |
| 할인% | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

`PRICE == ORG_PRICE` 전 구간 동일 → 분양몰/수량 할인 0. 굿즈 GSTGMIC(tiered_price 평탄 6000원)와 **거동은 같으나 모델명만 다름**(tmpl_price). 둘 다 평탄단가지만 tmpl_price는 단가가 **규격·PRN_CNT 룩업 테이블**에서 결정된다는 점이 본질 차이.

부가 차원 영향:
- **PRN_CNT 선형배수**: 개당 = 기본단가 × PRN_CNT (예 11in: 28,500×N. N=6→171,000, N=11→313,500). 정확 정수배.
- **규격별 단가**(ORD_CNT100,PRN_CNT1): 11in세로 28,500 / 13in가로·세로 31,500 / 15in가로 34,500 / 17in가로 36,500. 면적 증가에 따라 단계적.
- **DOSU(단/양면)·PRN_CLR_CNT(색수)**: 가격 영향 **0** (템플릿가에 흡수).

---

## ④ S5 명세 시사점 (hw-architect 전달)

1. **가격모델 = tmpl_price (룩업형 평탄단가)**: 후니 가격엔진에 `tiered_price`(굿즈)와 별개로 **template-lookup 모델**을 둬야 한다. 단가가 옵션 조합(규격+PRN_CNT)으로 결정되는 2차원(또는 N차원) 룩업 테이블이며, 수량은 단순 곱. 구간할인·tier 곡선이 **없음**을 명시.

2. **필수 reqBody 계약 — ORD_CNT + PRN_CNT는 ORD_INFO 안에**: 정규화 계약/어댑터에서 `quantity`(주문건수)와 `printCount`(인쇄수량)를 ORD_INFO 항목으로 직렬화해야 한다. 누락 시 PRICE=0이 침묵 실패로 나오므로, **위젯 가격호출 전 가드(ORD_CNT≥1 && PRN_CNT≥1 검증)** 를 명세에 포함. Red 위젯의 실제 결함을 후니 구현에서 반복하지 말 것.

3. **규격 = 폐쇄형 enum(등록 템플릿만 유효)**: 파우치는 자유 사이즈 입력이 가격적으로 무의미(임의 치수 PRICE=0). "직접 입력하기" 버튼이 UI에 있으나 tmpl_price 상품에서는 등록 템플릿 외 견적불가. 명세상 파우치 규격은 **드롭다운 enum + 자동 치수주입(읽기전용)** 으로 모델링하고, 자유입력 분기는 비활성/경고 처리 권장.

4. **무영향 옵션 정리**: DOSU·PRN_CLR_CNT는 파우치에서 가격 무관 → 옵션 캐스케이드에서 가격재계산 트리거 제외. UI 노출 여부는 후니 정책에 위임하되 가격엔진 입력에서 배제.

5. **PRN_CNT 의미 규명 필요**: 개당단가를 정수배 하는 강력 인자(=실질 "면/판 수" 또는 "디자인 세트 수")인데 라벨이 모호. S5 명세 전 RedPrinting 상품 페이지의 PRN_CNT 한글 라벨/도움말을 1건 추가 확인 권장(현재는 select 옵션 숫자만 노출).

---

## 검증 메모

- 토큰 잔여 49분 시점 착수, GSPUFBC 1종에서 PRICE>0 + 전 거동 규명 완료 (우선순위 충족).
- 캡처/스윕은 read-only API 호출 + 위젯 UI 조작만. 위젯코어·어댑터·server.js 무수정.
- 산출물에 쿠키/JWT raw 미포함, mb_cust_cod [REDACTED].
- 사용 스크립트: `s5-pouch-dump.cjs`(옵션덤프+진행선택), `s5-pouch-sizes.cjs`(규격치수), `/tmp/test_pouch.cjs`·`/tmp/probe_pouch.cjs`·`/tmp/pouch_realsizes.cjs`(API 직접검증).
