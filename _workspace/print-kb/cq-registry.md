# CQ Registry — 역량질문 레지스트리 (단계 A · 완전성 기준선)

> 작성 2026-06-05. **위키가 반드시 답해야 할 질문 = 완전성의 기준선.** 먼저 한다.
> 입도: 아키타입 3종 · 카테고리 11종 수준 → GAP 영역만 세분화.
>
> **상태 범례:** ✅검증(2+ 독립출처/라이브) · 🟡수집중(단일출처/부분/🟡신뢰) · 🔴미수집(공백)
> **답변 위치:** 기존 자산이 답하면 file 연결(재수집 금지). 비면 D 인터뷰/C 수집 대상.
> 경로 약어: `dbm/`=`_workspace/huni-dbmap/` · `pq/`=`_workspace/print-quote/` · `hw/`=`_workspace/huni-widget/`

---

## 그룹 1 — 제품/카탈로그 (CQ-PROD)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-PROD-01 | 후니 상품은 몇 개 대분류·상품군으로 나뉘며 분류 기준은? | ✅ | pq/02_business/product-master.md §4(12 대분류)·dbm/07_domain/process-recipe-tree.md §4-3(11 상품군) |
| CQ-PROD-02 | 11 상품군 각각의 대표 상품(SKU)과 MES ITEM_CD 체계는? | ✅ | pq/02_business/product-master.md §3·§5(전수 SKU) |
| CQ-PROD-03 | 아키타입 3종(통합/셋트/완제품) 정의와 상품군별 귀속은? | ✅ | dbm/07_domain/process-recipe-tree.md §4(라이브 권위) |
| CQ-PROD-04 | 어떤 상품이 내지/표지/면지로 분해(반제품)되고 왜? | ✅ | dbm/07_domain/process-recipe-tree.md §4-2·entity-semantic-model.md §4(하드커버·포토북 국한) |
| CQ-PROD-05 | 상품별 선택 옵션 축(사이즈·자재·인쇄·공정…)과 캐스케이드 구조는? | ✅ | dbm/07_domain/entity-semantic-model.md §1(9속성 의미축)·hw/01_reverse/option-schema-catalog.md |
| CQ-PROD-06 | variant(색상/사이즈/두께/표지타입)는 어느 차원으로 분해되나? | 🟡 | dbm/07_domain/entity-semantic-model.md §2(원칙 확정, 일부 컨펌 잔여) |
| CQ-PROD-07 | 상품마다 선택 가능한 사이즈 목록과 "사용자입력(비규격)" 허용 여부는? | ✅ | dbm/07_domain/entity-semantic-model.md §1(size축·nonspec) |
| CQ-PROD-08 | 상품-카테고리 트리(대분류>중분류>상품)의 UI 노출 구조는? | ✅ | pq/02_business/huni-ia-master.md·product-master.md §4 |
| CQ-PROD-09 | 신규/품절/단종 상품의 라이프사이클 표기(배경색·숨김)는? | 🟡 | dbm/06_extract(셀메타)·entity-semantic-model.md §5(시트별 범례 상이) |
| CQ-PROD-10 | 디자인캘린더처럼 prd_cd 공유·디자인 자산 상품의 모델은? | 🟡 | pq/02_business/huni-ia-master.md F.3(디자인 자산 3중구조) |
| CQ-PROD-11 | 묶음/세트 판매 단위(권/세트/EA)의 상품별 의미는? | ✅ | **D-R3**: 상품군별 고정 판매단위(dbm 묶음수 MAJOR 해소). KC-PROD-0001 |

---

## 그룹 2 — 가격/견적 (CQ-PRICE)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-PRICE-01 | 가격은 단가표 조회인가 공식 계산인가? 상품군별 어느 방식? | ✅ | dbm round-2(t_prc_* 공식엔진 3유형)·pq/02_business/pricing-rules.md |
| CQ-PRICE-02 | 가격 결정 변수 전체 목록은?(도수·면·수량·사이즈·소재·후가공…) | ✅ | pq/02_business/pricing-rules.md §2(전수) |
| CQ-PRICE-03 | 디지털인쇄 단가 매트릭스 구조(도수×면×수량구간×절수)는? | ✅ | pq/02_business/pricing-rules.md §3(국4절 7도수×56구간) |
| CQ-PRICE-04 | 수량 구간별 할인 체계(구간 정의·할인율 단위)는? | ✅ | dbm round-1(t_dsc_*, 검증 GO)·dbm/00_schema/discount-domain-detail.md |
| CQ-PRICE-05 | 면적 기반(포스터/실사/아크릴) 가격은 가로×세로 어떻게 계산? | ✅ | pq/02_business/pricing-rules.md §7·§8(2D 매트릭스·면적) |
| CQ-PRICE-06 | 후가공(코팅·박·형압·제본)의 가산 단가 구조는? | ✅ | pq/02_business/pricing-rules.md §4·§5.2(동판비+박가공비) |
| CQ-PRICE-07 | 판비/동판비 등 고정 셋업 비용의 발생 조건은? | 🟡 | pq/02_business/pricing-rules.md §5.2(박명함)·L0 옵셋 판비 |
| CQ-PRICE-08 | 견적 = 기본가 + 옵션가 + 후가공가의 합산 공식 정의는? | ✅ | dbm round-2 결정7건(합가=상품단가)·price-engine-ddl.md |
| CQ-PRICE-09 | 최소수량·최소금액·기본 셋업료 정책은? | 🟡 | **D-R3**: 상품별 상이(전역규칙 없음). 값=pricing-rules.md per-product. KC-PRICE-0001 |
| CQ-PRICE-10 | 판걸이수(임포지션)가 가격에 미치는 영향과 계산은? | 🟡 | dbm/06_extract(판걸이수)·pq process-flow.md §9 |
| CQ-PRICE-11 | 긴급/특급 제작 할증, 대량 별도 견적 기준은? | 🟡 | **D-R3**: 상품별 상이(전역규칙 없음). KC-PRICE-0002 |
| CQ-PRICE-12 | 외주 상품의 매입원가 → 판매가 마크업 규칙은? | ✅ | **D-R1**: 상품별 개별 책정. KC-EXT-0002 |

---

## 그룹 3 — 공정/생산 (CQ-PROC)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-PROC-01 | 후니 공정 라우트는 몇 개이고 상품군별 어느 Case에 매핑되나? | ✅ | pq/02_business/process-flow.md §1·§6(17 Case)·dbm process-recipe-tree.md §2-2 |
| CQ-PROC-02 | 공정 시퀀스(출력→코팅→재단→제본→포장…)의 전후 의존은? | ✅ | dbm/07_domain/process-recipe-tree.md §2-3·pq process-flow.md |
| CQ-PROC-03 | 인쇄방식 5종(옵셋/디지털/실사/실크/UV) 정의와 "1상품=1방식" 규칙? | ✅ | dbm/05_method/H-domain-knowledge-strategy.md L0·DB PROC_000001 |
| CQ-PROC-04 | 각 공정의 담당 부서·바코드 입력 시점·상태 마커는? | ✅ | pq/02_business/process-flow.md §1.2·§4 |
| CQ-PROC-05 | 공정 선행 종속성 강제(앞공정 미완료 시 차단) 정책은? | ✅ | pq/02_business/process-flow.md §4(D-PM-17) |
| CQ-PROC-06 | 제본 8종의 물리 차이와 각자 필요 기초데이터(책등·링·면지)는? | ✅ | dbm/07_domain/process-recipe-tree.md §3-1·§3-2 |
| CQ-PROC-07 | 공정 택일그룹(상품별 여러 공정 UI 택일) 구조와 적용 상품은? | 🟡 | dbm/07_domain/entity-semantic-model.md §1(#5)·BLOCK-3(캘린더/현수막 잔여) |
| CQ-PROC-08 | 검수 게이트(파일/출력/가공/출고) 위치와 항목은? | 🟡 | pq/02_business/process-flow.md §7(To-Be 제안, D-PM-20) |
| CQ-PROC-09 | 공정별 리드타임/SLA는? | 🔴 | pq/02_business/process-flow.md §5(추정만, 라우트 셋업 후 측정) |
| CQ-PROC-10 | 불량/재작업/클레임 발생 시 공정 흐름은? | ✅ | **F-삼각**: process-flow §2.3(불량→재작업) + order-flow(클레임 흐름) 2독립출처 |
| CQ-PROC-11 | 레이플랫 vs PUR 등 도메인 충돌 공정의 실제 운영 사실은? | ✅ | **F-삼각**: 라이브DB + 엑셀 일치 → 후니 운영=PUR 확정(레이플랫=미운영 마스터) |

---

## 그룹 4 — 파일/입고 (CQ-FILE)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-FILE-01 | 주문 후 고객 파일 입고 상태머신(업로드→검수→조판→확정)은? | ✅ | pq/02_business/order-flow.md §1.3·§2.2 |
| CQ-FILE-02 | 파일명 표준 규칙(발주일_품목_사이즈_양단면_소재_거래처…)은? | ✅ | pq/02_business/order-flow.md·process-flow.md §9(RENAME 규칙) |
| CQ-FILE-03 | 상품별 접수 파일 포맷(PDF/AI/JPG)과 칼선·화이트 분리 규칙은? | ✅ | pq/02_business/order-flow.md §6.2·dbm entity-semantic-model.md §3(UV 칼선) |
| CQ-FILE-04 | 파일 검수 기준(해상도·CMYK·블리드·폰트임베딩)은? | 🟡 | pq/02_business/process-flow.md §7.1(G1, PitStop)·glossary §6 |
| CQ-FILE-05 | 조판(판걸이/임포지션) 자동화 입력값과 다도안 처리는? | 🟡 | pq process-flow.md §6.3·dbm 판걸이수 |
| CQ-FILE-06 | 4채널(BIZ/FUJI/HUNI/컨티뉴) 파일명 비일관 → 일관화 매핑은? | ✅ | pq/02_business/order-flow.md §6.1 |
| CQ-FILE-07 | 썸네일 자동생성·주문-파일 매칭 규칙은? | 🟡 | pq/02_business/order-flow.md(1차 목표 명시) |
| CQ-FILE-08 | 고객 재업로드·수정요청 시 버전 관리는? | ✅ | **D-R3**: 버전 이력 보관(덮어쓰기 아님). KC-FILE-0001 |
| CQ-FILE-09 | 디자인 자산(보관함/템플릿/에디터) 3중구조는? | 🟡 | pq/02_business/huni-ia-master.md F.3 |

---

## 그룹 5 — 후가공 (CQ-FIN)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-FIN-01 | 후가공 공정 전체 목록(코팅·박·형압·오시·미싱·귀돌이·도무송·타공·접지)은? | ✅ | dbm/00_schema(PROC 83계층)·glossary §2·H-strategy 부록 |
| CQ-FIN-02 | 코팅 종류(무광/유광/벨벳)와 적용·단가는? | ✅ | pq/02_business/pricing-rules.md §4·glossary §2 |
| CQ-FIN-03 | 별색인쇄(화이트/클리어/금/은/핑크) 각 용도·사용처·왜? | ✅ | dbm/07_domain/entity-semantic-model.md §3-2(C-11 해결) |
| CQ-FIN-04 | UV평판인쇄 정의·대상소재(아크릴)·변형 5종은? | ✅ | dbm/07_domain/entity-semantic-model.md §3-1 |
| CQ-FIN-05 | 박 vs 형압 vs 별색금 — 물리적 구별과 DB 인코딩은? | ✅ | dbm/07_domain/entity-semantic-model.md §3-2(별색vs박vs도수) |
| CQ-FIN-06 | 형압 양각/음각, 오시(누름선) vs 미싱(절취선) 구별은? | ✅ | dbm/05_method/H-strategy L1·glossary §2 |
| CQ-FIN-07 | 공정 파라미터(오시 줄수·미싱 줄수·타공 개수·조각수)의 의미는? | ✅ | dbm/07_domain(prcs_dtl_opt)·process-recipe-tree.md §2-3 |
| CQ-FIN-08 | 후가공 간 전후 의존(오시→접지, UV→레이저커팅)은? | ✅ | dbm/07_domain/process-recipe-tree.md §2-3 |
| CQ-FIN-09 | 자체 후가공 vs 외주 후가공(동판·박작업) 경계는? | ✅ | pq/02_business/process-flow.md §1.3·order-flow.md §4.3 |
| CQ-FIN-10 | 봉제미싱·에폭시·아크릴가공 등 굿즈 전용 후가공은? | ✅ | **F-삼각**: DB PROC_000083 + process-flow §1.2/§2.2(굿즈가공 부서·보조공정) 2출처 |

---

## 그룹 6 — 용어/규격 (CQ-TERM)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-TERM-01 | 인쇄 기본 용어(도수·CMYK·블리드·재단·판걸이) 정의는? | ✅ | pq/02_business/glossary.md §1·§5 |
| CQ-TERM-02 | 사이즈 3축(전지/작업사이즈/재단사이즈) 구별 정의는? | ✅ | dbm/05_method/H-strategy L3·entity-semantic-model.md §1 |
| CQ-TERM-03 | 전지 규격(46전지 788×1090·국전지 636×969)과 절수는? | ✅ | H-strategy 부록·S2-STD-PAPER |
| CQ-TERM-04 | 종이/소재 약어(아트지·스노우·모조·백모조·평량·연)는? | 🟡 | pq/02_business/glossary.md §4·§10(자재 명칭 CONFIRM 잔여) |
| CQ-TERM-05 | 표준용어 ↔ 후니 엑셀 표기 ↔ DB 코드 4자 매핑은? | 🟡 | dbm/05_method/H-strategy L1 term-bridge(개념, 전수 미완) |
| CQ-TERM-06 | UI 표시 라벨(사용자 노출 한국어) 표준은? | ✅ | pq/02_business/glossary.md §11 |
| CQ-TERM-07 | MES ITEM_CD·PRD_TYPE·USAGE·QTY_UNIT 등 코드체계 의미는? | ✅ | dbm/00_schema/code-values.md·product-master.md §3 |
| CQ-TERM-08 | 배경색/숨김(노랑=신규·그레이=품절) 의미코드맵(시트별)은? | 🔴 | dbm entity-semantic-model.md §5(시트별 범례 상이, 미확정) → D 인터뷰 |
| CQ-TERM-09 | ISO 규격 사이즈(A/B 계열) 참고 매핑은? | ✅ | pq/02_business/glossary.md §5.1 |

---

## 그룹 7 — 정책/제약 (CQ-POL)

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-POL-01 | 회원/인증/등급 정책은? | 🟡 | pq/02_business/policy-checklist.md §3.1(미결정 다수) |
| CQ-POL-02 | 주문/결제 정책(결제수단·케이스)은? | ✅ | **F-삼각**: policy-checklist §3.3 + order-flow §1.2 결제케이스 2독립출처 |
| CQ-POL-03 | 배송비 정책(6건)은? | 🟡 | pq/02_business/policy-checklist.md §5.1 |
| CQ-POL-04 | 쿠폰/적립/리뷰 정책은? | 🟡 | pq/02_business/policy-checklist.md §5.3·§5.4 |
| CQ-POL-05 | 취소/환불/반품(제작 단계별 가능 여부) 정책은? | ✅ | **D-R2**: 케이스별 협의(현행). KC-POL-0001 ·To-Be 단계별 정책화 대상 |
| CQ-POL-06 | 오프라인 주문 별도 처리 규칙은? | ✅ | pq/02_business/order-flow.md §5.2 |
| CQ-POL-07 | 조직별 업무·권한(7개 조직) 관리는? | ✅ | pq/02_business/order-flow.md §5.1 |
| CQ-POL-08 | 파일 보관 기간·재주문 정책은? | ✅ | **D-R2**: 현행 무정책(⚠️To-Be 결정 필요). KC-POL-0002 |
| CQ-POL-09 | 클레임/불량 보상 기준(재제작 vs 환불)은? | ✅ | **F-삼각**: order-flow + process-flow §2.3 2독립출처(현행 재제작 우선) |
| CQ-POL-10 | V1/V2 단계별 적용 범위(113 IA 기능)는? | ✅ | pq/02_business/policy-checklist.md §6 |

---

## 그룹 8 — 외주/정산 (CQ-SUB) ⚠️ 최대 공백 그룹

| CQ | 질문 | 상태 | 답변 위치 |
|---|---|:--:|---|
| CQ-SUB-01 | 외주 대상 상품/공정 목록(머그·폰케이스·현수막·박작업·합판)은? | ✅ | pq/02_business/process-flow.md §6·order-flow.md §4.2(외주코드 006) |
| CQ-SUB-02 | 외주사별(비즈하우스·후지필름·쿠마샵) 담당 상품 매핑은? | 🟡 | process-flow.md(쿠마샵 머그 등 일부) → D 인터뷰 |
| CQ-SUB-03 | 외주 발주서 생성·전달 프로세스는? | ✅ | **D-R1**: 담당자 수동 발주(자동 아님). KC-EXT-0001 |
| CQ-SUB-04 | 외주 매입원가 → 판매가 마크업/마진 규칙은? | ✅ | **D-R1**: 상품별 개별 책정(일괄 마크업 아님). KC-EXT-0002 |
| CQ-SUB-05 | 외주 입고 검수·리드타임·지연 처리는? | ✅ | **D-R2**: 자체 전수 검수 후 출고. KC-EXT-0005 |
| CQ-SUB-06 | 선택적 외주(자체 캐파 초과 시 톰슨/중철) 전환 기준은? | ✅ | **D-R2**: 담당자 현장 판단. KC-EXT-0006 |
| CQ-SUB-07 | 외주사 정산 주기·단가 계약 구조는? | ✅ | **D-R1**: 월 단위 마감 정산. KC-EXT-0003 |
| CQ-SUB-08 | 합배송·다중 송장(주문 1 ↔ 송장 N) 처리는? | ✅ | pq/02_business/order-flow.md·process-flow.md §8.3 |
| CQ-SUB-09 | 외주 품질 불량 시 책임·재작업 정산은? | ✅ | **D-R1**: 케이스별 외주사 협의. KC-EXT-0004 |

---

## 커버리지 요약 (단계 F 예비 — A 초안 기준)

| 그룹 | 총 CQ | ✅검증 | 🟡수집중 | 🔴미수집 | 커버리지(✅+½🟡) |
|---|:--:|:--:|:--:|:--:|:--:|
| 1 제품/카탈로그 | 11 | 8 | 3 | 0 | **86%** |
| 2 가격/견적 | 12 | 8 | 4 | 0 | **83%** |
| 3 공정/생산 | 11 | 8 | 2 | 1 | **82%** |
| 4 파일/입고 | 9 | 5 | 4 | 0 | **78%** |
| 5 후가공 | 10 | 10 | 0 | 0 | **100%** |
| 6 용어/규격 | 9 | 6 | 2 | 1 | **78%** |
| 7 정책/제약 | 10 | 7 | 3 | 0 | **85%** |
| 8 외주/정산 | 9 | 8 | 1 | 0 | **94%** |
| **합계** | **81** | **60** | **19** | **2** | **평균 ~86%** |

> **갱신 이력:**
> - D-R1(2026-06-05) 외주/정산 4 + 가격 1 🔴→✅ (커버리지 69%→75%, 외주 33%→78%).
> - D-R2(2026-06-05) 외주 2 + 정책 2 🔴→✅ (커버리지 75%→80%, 외주 78%→94%·정책 55%→75%).
> - D-R3(2026-06-05) 제품 1 + 파일 1 🔴→✅, 가격 2 🔴→🟡(상품별 상이) (커버리지 80%→83%, 🔴 6→2).
> - F-삼각(2026-06-05) 5건 🟡→✅(PROC-10/11·FIN-10·POL-02/09, 각 2독립출처) + PROC그룹 카운트 정정 (커버리지 83%→86%).

### F-삼각측량 로그 (🟡→✅ 승격: 2독립출처 확인분만)

| CQ | 출처1 | 출처2(독립) | 확정 사실 |
|---|---|---|---|
| CQ-PROC-10 | process-flow §2.3 | order-flow 클레임 | 불량→재작업/클레임 흐름 |
| CQ-PROC-11 | 라이브 DB(PUR 단독) | 엑셀 photobook(PUR) | 후니 운영=PUR(레이플랫 미운영) |
| CQ-FIN-10 | DB PROC_000083 | process-flow §1.2 굿즈가공 부서 | 굿즈 전용 후가공(에폭시·봉제·아크릴) |
| CQ-POL-02 | policy-checklist §3.3 | order-flow §1.2 결제케이스 | 결제수단·케이스 |
| CQ-POL-09 | order-flow 클레임 | process-flow §2.3 불량 | 현행 재제작 우선 |

> **승격 보류 🟡 19건(정직 유지):** 단일출처(POL-01회원·03배송·04쿠폰·FILE-07썸네일·09디자인자산·PROD-10디자인캘린더·SUB-02외주사매핑) /
> 미해결(PROC-07택일그룹·TERM-05 term-bridge 전수미완) / To-Be제안(FILE-04·05 검수·조판) /
> 상품별상이 값미열거(PRICE-09·11) / variant 컨펌잔여(PROD-06) / 자재약어 CONFIRM(TERM-04) / 라이프사이클(PROD-09, TERM-08과 연동).

### GAP 목록 (🔴 미수집 2건만 잔존)

1. **용어 (1건):** 배경색/숨김 시트별 의미코드맵 (CQ-TERM-08) → D 인터뷰(시트 범례 제시형)
2. **공정 (1건):** 리드타임/SLA 실측 (CQ-PROC-09) → C(공정 라우트 셋업 후 측정, 인터뷰 불가)

### 🟡 → ✅ 승격 후보 (삼각측량 대상, F 단계)

- 정책 5건(회원·결제·배송·쿠폰·클레임)은 policy-checklist.md 단일출처 → 운영정책 25건 교차로 승격 가능.
- 용어 자재약어(CQ-TERM-04)·term-bridge(CQ-TERM-05)는 표준+DB 교차로 승격 가능.

> **F 검증 원리:** ① CQ 커버리지(45/81 검증) ② 포화(새 개념 안 나오면 해당 영역 종료)
> ③ 삼각측량(🟡 단일출처 → 추가출처 또는 OPEN 강등). 외주/정산(33%)·정책(55%)이
> **D 인터뷰의 1순위 타깃** — 나머지는 기존 자산 삼각측량으로 ✅ 승격 가능.
