# Source Registry — 출처 3계층 (provenance 추적)

> 작성 2026-06-05. CQ·claim과 양방향 추적. 미착수 칸=미완성.
> 권위 순서(HARD): 후니 1차 > 후니 Decision 트레일 > 산업표준(2차/3차 보조) > 데이터 역공학(후보만).

---

## 1차 — 내부·원천 (후니 권위, 최상위)

| src_id | 출처 | 형태 | 위치 | 파싱 산출물 | 상태 |
|---|---|---|---|---|:--:|
| **S1-XLS-PM** | 상품마스터 260527 | xlsx 13시트 | `docs/huni/후니프린팅_상품마스터_260527.xlsx` | `huni-dbmap/06_extract/all-sheets-l1-report.md`(1247rec)·`print-quote/02_business/product-master.md` | ✅파싱 |
| **S1-XLS-PRC** | 인쇄상품 가격표 | xlsx 19시트 | `docs/huni/후니프린팅_*가격표*.xlsx` | `print-quote/02_business/pricing-rules.md`(단가매트릭스 전수)·`huni-dbmap/00_schema/price-engine-ddl.md` | ✅파싱 |
| **S1-XLS-PEG** | 판걸이수·출력소재IMPORT | xlsx 2시트 | (가격표 부속) | `huni-dbmap/06_extract/`(판걸이·IMPORT 18/6) | ✅파싱 |
| **S1-XLS-POL** | 리뉴얼 정책 체크리스트 | xlsx | `docs/huni/*정책*.xlsx` | `print-quote/02_business/policy-checklist.md`(113 IA·25 운영정책) | ✅파싱 |
| **S1-XLS-IA** | IA 1차 개발범위 | xlsx | `docs/huni/*IA*.xlsx` | `print-quote/02_business/huni-ia-master.md` | ✅파싱 |
| **S1-PDF-PROC** | 공정관리 시행초안 20260210 | PDF 2p | `docs/huni/후니프린팅_공정관리_시행초안_20260210.pdf` | `print-quote/02_business/process-flow.md`(17 Case)·`huni-dbmap/07_domain/pdf-domain-knowledge.md` | ✅파싱 |
| **S1-PDF-ORD** | 주문프로세스 20251001 | PDF 5p | `docs/huni/후니프린팅_주문프로세스_20251001.pdf` | `print-quote/02_business/order-flow.md`(상태머신·파일흐름·권한·Pain) | ✅파싱 |
| **S1-DB-LIVE** | Railway railway DB | PostgreSQL 29테이블 | (라이브, `.env.local` RAILWAY_DB_*) | `huni-dbmap/07_domain/db-domain-structure-live.md`·`00_schema/` | ✅추출(읽기전용) |
| **S1-DB-NOTE** | DB note Decision 트레일 | DB 컬럼 note | (라이브) | `huni-dbmap/07_domain/decision-trail-harvest.md` | 🟡부분 |
| **S1-TACIT** | 지니 암묵지 (26년) | 인터뷰 (D단계) | — | **미수집(D 인터뷰 대기)** | ⏸ |
| **S1-LEGACY** | 레거시 buysangsang.com | 라이브 크롤 | (운영 중) | `print-quote/01_research/`(부분) | 🟡부분 |
| **S1-OEM** | 외주사 규칙(비즈하우스·후지필름·쿠마샵) | 암묵지/문서 | — | **미수집** | ⏸ |

---

## 2차 — 외부 검증 (보조 권위)

| src_id | 출처 | 형태 | 위치 | 상태 |
|---|---|---|---|:--:|
| **S2-COMP-RP** | RedPrinting 옵션·가격 체계 | 역공학 | `huni-widget/01_reverse/`·`docs/reversing/red_reverse_engineer/` | ✅역공학 86/100 |
| **S2-COMP-BS** | buysangsang/wowpress | 크롤·분석 | `print-quote/01_research/` | 🟡부분 |
| **S2-COMP-BENCH** | 경쟁사 벤치마킹 | 분석 | `huni-dbmap/07_domain/benchmark-competitors.md`·`benchmark-evidence/` | 🟡부분 |
| **S2-STD-BIND** | 제본 표준(레이플랫/PUR/Wire-O) | WebSearch | `entity-semantic-model.md` Sources §179-186 | ✅검증 |
| **S2-STD-UV** | UV flatbed·화이트잉크 표준 | WebSearch | `entity-semantic-model.md` Sources §187-196 | ✅검증 |
| **S2-STD-PAPER** | 전지/절수(46전지·국전지) | WebSearch | `H-domain-knowledge-strategy.md` 부록 Sources | ✅검증 |
| **S2-SUP-EQUIP** | 장비/용지/후가공 공급사 스펙 | — | **미수집(구체 규격 수집중)** | ⏸ |

---

## 3차 — 배경 (정의·표준용어 대조용)

| src_id | 출처 | 위치 | 상태 |
|---|---|---|:--:|
| **S3-STD-PRINT** | 대한인쇄문화협회·나무위키 인쇄 분류 | `H-domain-knowledge-strategy.md` Sources §260-261 | ✅참조 |
| **S3-STD-FINISH** | 나눔인쇄·북토리·구목 후가공 가이드 | `H-domain-knowledge-strategy.md` Sources §264-266 | ✅참조 |
| **S3-GLOSSARY** | 인쇄 용어사전 (대조용) | `print-quote/02_business/glossary.md`(13섹션, 자체구축) | ✅자체 |

---

## 공백 요약 (수집 우선순위)

| 우선 | 미수집/얕음 출처 | 영향 CQ 그룹 | 해소 경로 |
|:--:|---|---|---|
| 1 | **S1-TACIT** 지니 암묵지 | 전 그룹(특히 판단·예외) | D 인터뷰 |
| 2 | **S1-OEM** 외주사 규칙 | 외주/정산 | D 인터뷰 + 외주 발주서 수집 |
| 3 | **S1-DB-NOTE** Decision 트레일 | 정책·용어 | DB note 전수 수확 |
| 4 | **S2-SUP-EQUIP** 공급사 스펙 | 용어/규격(구체 규격) | `/deep-research` |
| 5 | **S1-LEGACY** buysangsang | 가격·견적·정산 | 라이브 크롤(저트래픽) |
