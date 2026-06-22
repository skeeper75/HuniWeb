# 03. Aurora React Skin — 인쇄 견적 도메인 적합성 평가

생성일: 2026-05-27
선행 문서: `01_overview.md`, `02_extensibility-points.md`
대조 자료: `_workspace/print-quote/01_research/crawl-evidence/2026-05-27_buysangsang/C_findings.md` (As-Is 가격·옵션 엔진), `edicus-analysis/05_verdict-and-recommendations.md` (Edicus 흡수성)

---

## 1. 평가 기준

후니프린팅 To-Be 요구사항 10가지를 0~3점으로 평가:
- **0** = 불가능 / 아키텍처 충돌
- **1** = 가능하지만 큰 우회/추가 백엔드 필요
- **2** = 가능, 적당한 커스터마이징
- **3** = Aurora가 기본 제공 또는 거의 그대로 fit

---

## 2. 요구사항 매트릭스

| # | 요구사항 | 점수 | 근거 |
|---|---------|------|------|
| R1 | **복잡 옵션 폼 (용지/사이즈/후가공/수량 — 20+ 필드)** | **1** | Shopby의 옵션 모델은 어드민에 사전 등록된 `optionNo` 조합. 20+필드의 동적 폼은 자체 컴포넌트로 그릴 수는 있으나, Shopby 옵션과의 매핑이 끊김. 텍스트 옵션(`input`)으로 자유 입력 가능하나 검색·통계·재고에서 의미 없음. As-Is의 TM Extra Product Options(`tm_meta_cpf` builder mode) 같은 폼 빌더 DSL 부재. |
| R2 | **실시간 가격 갱신 (옵션 선택 즉시 산식 재계산)** | **1** | Aurora는 `GET /cart/calculate` 및 `POST /order-sheets/{no}/calculate`를 호출해 서버가 가격을 산출. 클라이언트 산식은 신뢰되지 않음. 자체 산식 엔진을 클라이언트에서 실행해도 결제 시 서버가 다시 계산하므로 의미 없음. → 결제 시 서버에 자체 가격을 강제 주입할 수 있는 통로(예: 어드민 가격 우회 API)가 없으면 견적가 결제 자체가 불가. |
| R3 | **수량 구간 할인 (Tiered Pricing)** | **1** | Shopby에 수량 구간 할인 기능 명시 0건(가이드 범위). 쿠폰/적립금/즉시할인은 있으나 "100매 ₩15K → 500매 ₩45K → 1000매 ₩60K" 같은 구간 룰은 없음. As-Is의 `Tiered Price Table for WooCommerce`에 해당하는 모듈 부재. 어드민 확장 또는 별도 가격 엔진 필요. |
| R4 | **옵션별 가산 단가 (TM EPO 류)** | **1** | Shopby 옵션은 옵션별 가산 단가(`additionalPrice`)가 있음 — 일부 fit. 단 옵션을 사전 등록해야 하므로 "용지 5×사이즈 8×수량 10×후가공 5 = 2000조합" 시 비현실적. As-Is의 builder mode 폼 정의(`tm_meta_cpf`)를 재현하려면 자체 옵션 DSL + 가격 룰 엔진 필요. |
| R5 | **디자인 에디터(Edicus) 통합 자유도** | **2** | `외부_스크립트_호출.mdx` 가이드 존재 → iframe 임베드 가능. `docs/edicus.man/`의 SDK 통합 코드(EdicusClient, HuniEditorSDK, postMessage origin 검증)를 Aurora 위에 얹는 것은 기술적으로 가능. 단 라우트(`/editor/[id]`, `/vdp/[id]`)와 프로젝트 영속화 백엔드는 Aurora 밖에서 별도 운영. |
| R6 | **파일 업로드 + 검수 워크플로** | **1** | `feature-matrix.md`에 "상품 등록/대량 등록/이미지 관리"가 CUSTOM(인쇄업 특화 개발 필요)로 분류. As-Is의 `WooCommerce File Approval` 같은 검수 흐름은 Shopby에 없음. 자체 라우트 + 자체 DB 필요. Aurora가 도움 주는 부분은 회원 토큰 재사용 정도. |
| R7 | **사양별 공정 분기 (인쇄→후가공→포장 SLA)** | **0** | Shopby 주문 상태는 일반 커머스 상태(접수/배송준비/배송중/배송완료/취소/반품). 인쇄 공정 상태(접수→교정→인쇄→후가공→배송)를 자체 추가하려면 어드민 확장이 필요하며 가이드 범위 밖. `admin-analysis/recommendations.md` "생산 관리 워크플로우 별도 개발 권장"과 일치. |
| R8 | **한국형 회원·결제 (네이버페이, 멤버십 가격)** | **3** | Shopby의 강점. 본인인증(KCP), 약관(개인정보/통관/주류 enum), NCPPay, 쿠폰/적립금/사은품, 비회원 주문, 회원등급, 멤버십 가격 모두 기본 제공. As-Is의 mshop-npay/심플페이를 Shopby PG 매핑으로 대체 가능. |
| R9 | **모바일 견적 UX** | **2** | Aurora는 모바일 퍼스트 통합형. 일반 쇼핑 UX는 fit. 단 견적 마법사의 모바일 UX는 자체 라우트로 별도 설계. Aurora의 모바일 컴포넌트 셋이 도움. |
| R10 | **SEO·URL 보존** | **1** | SSR/SSG 가이드 없음 → CSR 추정. As-Is의 `/shop/{id}/{name}/` URL 호환 여부 미명시. SEO 메타·OG·robots는 별도 작업. Next.js 기반인 Edicus 통합 셸 쪽이 SEO에 더 유리. |
| | **합계** | **13 / 30** | **약 43%. "절반 못 미침"** |

---

## 3. 해석 — 점수 컷오프

| 합계 | 의미 |
|------|------|
| 24+ (80%+) | Aurora 본격 채택 권장 |
| 18–23 (60–77%) | Aurora 채택 + 큰 영역 자체 빌더 (Hybrid) |
| 12–17 (40–57%) | **Aurora를 본체로 두기 부적합. 회원/체크아웃만 빌려오거나, 아예 미채택.** ← 현재 위치 |
| <12 (<40%) | Aurora 미채택 권장 |

→ **13점은 컷오프 하단**. 옵션 B(Hybrid) 하단 또는 옵션 C(미채택) 상단 위치. 후니 To-Be의 본질이 "복잡 견적 + 동적 가격"이므로 R1~R4의 1점은 사실상 deal-breaker.

---

## 4. Aurora가 하지 못하는 결정적 한계 3가지

### 한계 1. 가격 무결성 충돌 — Shopby 백엔드가 가격의 단일 진실 원천

Aurora를 채택하면 결제 가격이 Shopby 어드민에 등록된 상품/옵션 가격으로 강제 재계산된다(`POST /order-sheets/{no}/calculate`). 인쇄 견적의 핵심인 "용지 + 사이즈 + 수량 + 후가공의 동적 산식"을 어드민이 모르면 견적가로 결제할 방법이 없다. 우회책은 두 가지:
- (A) 모든 옵션 조합을 어드민에 사전 SKU로 등록 → 2000+ SKU 폭증, 후가공이 추가 SKU여야 함.
- (B) 가짜 SKU + 자체 가격 → 텍스트 옵션에 사양 첨부 → 어드민 UI에서 견적 정보가 비가시화, 매출 통계·재고·환불 모두 망가짐.
어느 쪽도 운영 가능 수준이 아니다.

### 한계 2. 옵션 도메인 모델의 강성

Shopby 옵션은 "조합형(`flatOptions`/`multiLevelOptions`)" 또는 "텍스트 입력(`input`)" 두 가지뿐이다. As-Is의 TM Extra Product Options builder mode가 제공하는 "Conditional Field(특정 옵션 선택 시에만 노출)", "Custom Pricing Formula", "Image Selector with Price", "Range Slider with Step Pricing" 같은 폼 빌더 기능 0건. 옵션 폼을 자체 컴포넌트로 그려도 Shopby 옵션 모델로 직렬화할 수 없다.

### 한계 3. 인쇄 공정·검수 워크플로 부재

Shopby의 주문 상태는 일반 커머스 lifecycle뿐이다. "교정 대기 → 교정 완료 → 인쇄 중 → 후가공 중 → 출고 준비"의 인쇄 공정 상태기계는 어드민 자체에 들어갈 자리가 없다. `feature-matrix.md`가 인쇄업 특화 개발을 P1(즉시)으로 분류한 것은 이를 알고 있다는 신호. 또 As-Is의 `WooCommerce File Approval`(원고 파일 검수)에 해당하는 흐름도 Shopby에 부재.

---

## 5. Aurora가 잘하는 영역 (공정한 평가)

낙제만 부각하면 편향. Aurora가 즉시 가치를 주는 영역:

- 한국형 OAuth2 + 본인인증 + 약관 흐름 (R8 = 3점) — 자체 구현 시 큰 비용.
- NCPPay 결제 모듈 통합 (한국 PG 다종 지원 코드 무료).
- 쿠폰/적립금/사은품/멤버십 (한국 커머스의 흔한 보조 기능 일괄).
- 회원 마이페이지(주문내역/배송지/혜택/게시판) — commodity UI.
- 배너/메인 진열 어드민 연동 (운영 직접 변경 가능).

→ 이 영역만 추출해 "회원·체크아웃·마이페이지 슬라이스"로 활용하는 것이 Hybrid의 가치 제안.

---

## 6. 사용자 직관 검증

사용자 직관: "Aurora는 일반 쇼핑몰 구조라 인쇄 견적엔 부적합·커스터마이징 손실"

**판정**: **동의** (데이터로 뒷받침).
- 도메인 모델 충돌(가격 무결성, 옵션 모델, 공정 워크플로) 3건이 deal-breaker.
- 확장성도 평균 22% (`02_extensibility-points.md` §5)로 framework가 아닌 template 수준.
- 견적·디자인·검수의 핵심 30점 중 13점(43%)만 fit.

단, 사용자 직관에 부분 반박:
- "전부 미채택"이 최선은 아닐 수 있음. R8(한국형 회원·결제)의 3점은 자체 구축 비용이 크고, Aurora의 회원·체크아웃 슬라이스만 떼어 쓰는 Hybrid 옵션 B가 합리적일 가능성 있음. 단 Aurora를 본체로 두지 않고 "참조 코드/부분 차용"으로 격하시키는 형태.

---

Version: 1.0.0
Status: 1차 분석 완료
Next: `04_three-options-comparison.md`
