# ADR-003: 데이터 레이어 전략 (Shopby / Edicus / Neon PG 분리)

- 상태: **Draft** — 핵심 결정 보류, Open Questions 우선 해소 필요
- 작성일: 2026-05-27
- 관련 ADR: ADR-001 (프론트엔드 옵션), ADR-002 (Edicus 통합)

---

## 1. Context

To-Be 시스템은 **3개의 데이터 소스**가 공존한다.

| 소스 | 보유 도메인(가설) | 통제권 |
|---|---|---|
| **Shopby Server API** (NHN) | 상품 마스터(?), 회원/세션, 주문/결제, 배송, 한국 커머스 표준(휴면계정/CI-DI) | NHN 외부 |
| **Edicus 외부 백엔드** (motion-one) | 디자인 프로젝트 메타, 캔버스 본문 URI, 미리보기, 인쇄파일 렌더링 | 외부 |
| **Neon PG** (자체) | 인쇄 도메인 38테이블 (Product/Pricing/Widget/Production/Quote/Artwork) | 자체 |

베이스라인 ERD(`_baseline/08_erd.md`)는 인쇄 도메인 38테이블을 모두 자체 소유로 가정하고 설계된 상태이다. 그러나 사용자는 별도 트랙으로 Shopby Enterprise 도입을 결정했고, edicus.man 분석에서 Edicus 외부 의존 유지를 결정했다 (ADR-002). 결과적으로 **누가 무엇을 소유하는가**가 미해결.

본 ADR은 결정을 강행하지 않고 **가설을 명세하고 Open Questions를 정리한 후, Aurora 분석(pq-researcher 백그라운드) + Shopby API 카탈로그 정밀 점검 후 확정**한다.

---

## 2. 핵심 질문

### Q-Master-1: 상품 카탈로그의 source-of-truth는 어디인가?

#### 가설 A: Shopby가 마스터
- Shopby 관리자에서 상품 등록 → 우리 BFF가 캐싱하여 Neon에 동기화
- 장점: 어드민 UI 0 구축, NHN 표준 활용
- 단점: 인쇄 도메인 메타(옵션 빌더 DSL, 구간 가격 룰, 위젯 단계 정의, 작업파일 사양)를 Shopby가 표현할 수 있는지 미검증. As-Is의 WordPress가 `tm_meta_cpf`, `_tiered_*`, `wpsyncsheets_*` 등 40여 종 메타로 표현하던 것을 Shopby의 상품 메타가 동등 수용 가능한지 확인 필요 (`C_findings.md` 108개 메타)
- Aurora React Skin은 NHN의 표준 상품/카탈로그 모델 위에 만들어졌으므로, Shopby가 표현 못 하는 인쇄 메타는 자체 어드민 + Neon로 보강 필요

#### 가설 B: Neon PG가 마스터
- 자체 어드민에서 등록, Shopby는 결제/주문/회원 서비스로만 사용
- 장점: 인쇄 도메인 모델 38테이블이 1급 시민. 옵션·가격·위젯·생산이 자연스럽게 표현됨
- 단점: 어드민 UI 자체 구축 분량 ↑, Shopby의 카탈로그/리스팅 기능을 포기. Aurora 상품 리스트/상세 컴포넌트를 쓰려면 Shopby에 "그림자 상품"을 동기화해야 함 (양방향 동기화의 부분 케이스)
- ADR-001 옵션 C에 가장 자연스럽게 맞음

#### 가설 C: 양방향 동기화
- Shopby와 Neon이 서로 마스터의 일부를 보유, 양방향 sync
- 장점: 두 시스템 강점 합산
- 단점: **분산 시스템 일관성 위험** — 동시 수정 시 last-write-wins/conflict resolution 정책 필요. 권장하지 않음

**잠정 입장**: ADR-001 옵션 C 채택 시 → **가설 B**(Neon 마스터). 옵션 B 채택 시 → **가설 B + 일방향 동기화**(Neon → Shopby 그림자 상품, Aurora 카트가 인식할 최소 정보만). 옵션 A 채택 시 → 가설 A vs B의 추가 검토 필요.

---

### Q-Master-2: 가격 엔진은 어디서 돌아가는가?

인쇄 견적 가격 = `base_price + Σ(spec_option_surcharge) × quantity_break_unit_price + 할증/할인`. 본 식은 베이스라인 `price_tables`, `quantity_price_breaks`, `spec_option_surcharges`, `surcharge_rules`, `discount_policies`(13컬럼)에서 표현됨.

#### 후보
- **C-Price-1**: Shopby가 동적 단가 입력 주문(외부 산출 단가 push)을 허용 → 자체 BFF가 산출, Shopby는 결제만 처리
- **C-Price-2**: Shopby가 동적 단가를 허용하지 않음 → Shopby 주문 직전에 "산출 단가를 표시 가격으로 갖는 임시 상품/할인쿠폰"으로 변환하여 push (해킹)
- **C-Price-3**: Shopby 미사용, 자체 PG 직결 → 가격 엔진은 BFF 단독 (옵션 C-극단형)

**잠정 입장**: 어떤 옵션에서도 **가격 산출은 자체 BFF가 소유**한다. Shopby/PG는 결과 단가의 결제 채널로만 동작. Shopby가 동적 단가 push를 표준 지원하는지가 핵심 (Open Question Q1).

---

### Q-Master-3: 주문 라이프사이클의 단계별 소유자

| 단계 | 사용자 경험 | 소유 시스템(가설) |
|---|---|---|
| 카탈로그 탐색 | 상품 리스트/상세 | Neon (마스터) + Aurora/자체 UI |
| 사양 선택 + 가격 산출 | 견적 위젯 | Neon + 자체 BFF |
| 디자인 에디터 | Edicus iframe | Edicus 외부 백엔드 (ADR-002) |
| 잠정주문 (tentative) | "주문 진행하기" | Neon `orders.status=tentative` + Edicus `ProjectStatus=ordering` |
| 카트 추가 (있다면) | 다건 묶음 | Aurora 카트 (옵션 A/B) / 자체 카트 (옵션 C) |
| 결제 진입 | 체크아웃 | Aurora `/checkout` (옵션 A/B) / 자체 (옵션 C) |
| 결제 완료 (definitive) | PG 콜백 | Shopby webhook → BFF → Neon `orders.status=definitive` + Edicus `definitiveOrder()` |
| 작업파일 검수 | 운영자 화면 | Neon `artwork_files` (자체 어드민) |
| 생산 (processing → completed) | 운영자 화면 | Neon `production_jobs`, `job_stage_status` (자체 어드민) |
| 배송 | 사용자 조회 | Neon `shipping_info` + Aurora 주문내역(있다면) |

**잠정 입장**: 결제와 회원 마스터는 Shopby(또는 PG 직결), 그 외 모두 Neon. 작업파일 검수와 생산은 As-Is에서도 외부 도구(`wpsyncsheets`)에 위탁하던 영역으로, 자체 어드민 구축 vs 외부 도구 유지 결정 필요.

---

### Q-Master-4: 회원/세션 마스터

#### 후보
- **C-Auth-1**: Shopby 회원 시스템을 마스터로 (Aurora 회원 컴포넌트 + Shopby Server API). 자체 BFF는 Shopby 토큰으로 세션 운영
- **C-Auth-2**: 자체 인증(NextAuth v5 또는 Supabase Auth 등), 결제 시점에 Shopby에 게스트 주문 push
- **C-Auth-3**: 자체 인증 + Shopby 회원 양방향 sync (CI/DI 기반 식별)

고려 사항:
- **한국 커머스 표준**: 휴면계정(1년 미접속 → 분리보관), 이용약관/개인정보 동의 이력, CI/DI(주민번호 변환식별자) — Shopby가 NHN 정책으로 기본 제공. 자체 구현 시 법적 리스크 + 분량 ↑
- As-Is에서 `mshop_agreement` CPT가 한국형 회원 워크플로를 담당 (`A2_findings.md` D4)
- edicus.man은 Firebase Auth 사용 중, NextAuth v5 마이그레이션 예정(README) — 후니 자체 정책 미확정 (R3)

**잠정 입장**: ADR-001 옵션 A/B → **C-Auth-1** (Shopby 마스터, 한국 표준 위탁). 옵션 C → **C-Auth-1 또는 C-Auth-3** (Shopby Server API의 헤드리스 회원 호출 가능 여부에 따라). C-Auth-2는 법적/일정 리스크로 비추.

---

## 3. (보류) Decision

본 ADR은 결정을 강행하지 않는다. Open Questions(아래)이 해소된 후 ADR-003-v2에서 확정한다.

다만 다음은 **옵션 무관 잠정 합의**로 기록한다.

- **A1**: 인쇄 도메인 38테이블(Product/Pricing/Widget/Production 포함)의 1차 소유는 **Neon PG**. 다른 시스템에 동일 정보가 존재하더라도 Neon이 진실 (가설 B 기조).
- **A2**: 가격 산출 로직은 **자체 BFF가 단독 소유**. Shopby/PG는 산출된 단가의 결제 채널.
- **A3**: Edicus 외부 백엔드는 디자인 프로젝트 자산(`template_uri`, `content_uri`, 미리보기 URL, 인쇄파일 렌더링)의 진실. 그 외 영역(주문/결제/회원/생산)에 Edicus 진실은 없음.
- **A4**: 회원 마스터는 **Shopby가 우선 후보**. Aurora 채택 여부와 무관하게 한국 커머스 표준 기능 위탁 가치가 큼. 자체 인증은 게스트 견적 진행용으로만.
- **A5**: BFF는 단일 진입점(Next.js Route Handler 또는 별도 서비스). 모든 외부 시스템 호출이 경유. 자격증명은 BFF 외부로 노출되지 않음 (ADR-002 D2 일관).
- **A6**: `edicus_order_mapping(internal_order_id, edicus_order_id, edicus_project_id)` 매핑 테이블 추가 (ADR-002 D7).
- **A7**: Shopby 주문 ID도 동일 패턴으로 `shopby_order_mapping(internal_order_id, shopby_order_id, shopby_member_no)` 매핑 테이블 추가.

---

## 4. Open Questions (확정 전 필수 해소)

| ID | 질문 | 답을 주는 주체 |
|---|---|---|
| Q1 | Shopby가 "외부에서 산출된 동적 단가로 주문 push"를 표준 지원하는가? | Shopby API 카탈로그 정밀 점검 |
| Q2 | Shopby Server API 단독으로 회원/카트/결제 사이클을 헤드리스 호출 가능한가? Aurora 의존 없이? (옵션 C 결정의 핵심) | Shopby docs + Aurora 분석 |
| Q3 | Shopby의 한국 커머스 표준(휴면계정/CI-DI/이용약관 이력)을 헤드리스로 호출 가능한가? UI 컴포넌트 동봉인가? | Shopby docs + 영업/기술 협의 |
| Q4 | Shopby가 webhook을 제공하는가? 어떤 이벤트들? (결제 완료, 배송 시작, 취소 등) | Shopby docs |
| Q5 | Shopby 상품 메타가 인쇄 도메인 메타(옵션 빌더 DSL, 구간 가격, 위젯 단계, `wpsyncsheets` 사양)를 표현할 수 있는가? (As-Is `_msdp_*`, `_tiered_*`, `tm_meta_cpf` 등 108개 메타 대비) | Shopby docs + 상품 마스터 매핑 실험 |
| Q6 | Aurora 컴포넌트가 "외부 산출 단가 표시"를 지원하는가, 아니면 자체 가격 계산을 강제하는가? | Aurora 분석(pq-researcher) |
| Q7 | Aurora `Cart`/`Checkout` 컴포넌트의 회원 의존도는? 게스트 체크아웃 지원 여부 | Aurora 분석 |
| Q8 | Edicus 외부 백엔드의 webhook 지원 여부 (ADR-002 Q1 동일) | Edicus 협의 |
| Q9 | 작업파일 검수 워크플로(`artwork_files`, `wpsyncsheets`)를 자체 어드민으로 흡수할 것인가, 외부 Google Sheets 동기화를 유지할 것인가? | pq-pm 결정 |
| Q10 | 운영자/관리자 페이지를 어떤 셸 위에 구축할 것인가? (자체, Shopby 백오피스, Retool 등) | pq-pm 결정 |

### 가장 큰 미해결 질문 (BLOCKER)

**Q5 + Q1 결합**: "Shopby의 상품 모델이 인쇄 도메인 메타(108개 메타로 표현되던 옵션·가격·위젯·작업파일 사양)를 1급으로 표현하지 못하고, 동시에 동적 산출 단가 push도 표준 지원하지 않는다면" → 가설 A(Shopby 마스터)는 사실상 불가능해지고, Shopby는 결제/회원 채널로만 격하된다. 이는 **ADR-001 옵션 선택의 종속 변수**이며, 본 ADR의 모든 잠정 합의의 전제이다.

→ pq-researcher의 Aurora 분석 + Shopby API 정밀 점검이 도착하면 본 ADR을 v2로 갱신.

---

## 5. Consequences (잠정 합의 A1~A7 기준)

### 긍정
- 인쇄 도메인 일관성: Neon이 단일 진실이므로 옵션/가격/위젯/생산이 자연스럽게 표현됨
- 보안 경계: BFF 단일 진입으로 자격증명 차폐
- 매핑 테이블로 외부 ID 추적 가능 (감사·디버깅 용이)

### 부정
- 다중 시스템 운영 부담 (Neon + Shopby + Edicus + 매핑 테이블 동기화)
- Shopby/Edicus 외부 의존성에 인쇄 비즈니스 진행이 묶임 (장애 시 결제·렌더링 정지 가능)
- 가설 B가 확정되면 어드민 UI 자체 구축 분량 ↑
- `wpsyncsheets`(Google Sheets 동기화) 유지/폐기 결정 보류

---

## 6. Next Steps

1. pq-researcher Aurora 분석 결과 수신
2. Shopby Server API 카탈로그 정밀 점검 (Q1~Q5)
3. Edicus 측 webhook/라이선스 협의 (ADR-002 Q1, Q2)
4. 본 ADR을 v2로 갱신, Decision 섹션 채움
5. ADR-001 옵션 확정과 동기화

---

REQ coverage: REQ-DATA-001 ~ REQ-DATA-010
References: _baseline/07_integrated_schema.sql, _baseline/08_erd.md, _baseline/09_integration_report.md, edicus-analysis/02_domain-model.md, edicus-analysis/05_verdict-and-recommendations.md, crawl-evidence/2026-05-27_buysangsang/{C,A2}_findings.md, docs/shopby/aurora-react-skin-guide/index.mdx, ADR-002
