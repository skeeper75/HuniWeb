# 원천 레지스트리 (Source Registry) — Huni-Ontology-KB

> 작성: 2026-07-03 · okb-source-curator (첫 작성 — 이전 레지스트리 없음, 델타 대상 아님)
> 목적: 지식베이스를 만들 때 **어떤 파일의 어떤 부분이 지금 진실이고, 무엇이 함정(오래된 정보)인지**를 등급표로 못박는다.
> 참고 선행물: `_workspace/print-kb/wiki/_curation/source-registry.md`(2026-06-12, print-kb 위키용) — 본 레지스트리는 그것을 260702 권위 기준으로 갱신·확장한 것이며 원본은 그대로 둔다.

---

## 0. 등급 체계 (읽는 법)

**tier(권위 등급)** — "충돌하면 누가 이기는가"의 순서.

| tier | 의미 | 대표 예 |
|------|------|---------|
| **A** | 절대 권위 — 권위 엑셀 260702 · 라이브 DB 스키마 실측 · 가격엔진 코드(evaluate_price) | `docs/huni/*_260702.xlsx`, `raw/webadmin/.../pricing.py`, live-snapshot |
| **B** | 정본(SOT) 문서 — 사용자가 확정했고 다시 논쟁하지 않기로 한 규칙 문서 + docs/kb 6문서 | `_foundation/HARNESS-DOMAIN-RULES-260701.md`, `docs/kb/` |
| **C** | 하네스 작업 산출물 — 각 분석 트랙이 만든 결과물. **최신 라운드가 옛 라운드를 이긴다** | `huni-dbmap/26_*`, `huni-set-product/05_gate/` |
| **D** | 역공학·경쟁사·외부 자료 — 빠진 것을 찾는 보조(갭헌팅)용. 권위를 덮어쓸 수 없음 | `docs/reversing/`, 레드프린팅 관찰 |

**freshness(신선도)** — "지금 인용해도 되는가".

| 등급 | 의미 |
|------|------|
| **FRESH** | 현재 기준 유효. 그대로 인용 가능 |
| **PARTIAL-STALE(축)** | 일부 축만 낡음 — 어떤 축이 낡았는지 명시. 그 축만 피해서 인용 |
| **STALE** | 인용 금지. 대체 소스를 지목 (→ §8 금지 목록) |

**핵심 원칙 3가지** (에이전트 HARD 규칙):
1. **수치의 절대 권위 = 260702 엑셀 2종.** 구 260610/260527 기준 수치는 260702 diff(§2.2)와 대조하기 전엔 사실로 못 쓴다.
2. **라이브 DB는 "현재 상태"이지 "정답"이 아니다.** 오적재 이력 다수(dbmap round-13). 라이브 값은 반드시 "현재값"으로 라벨하고, 권위 엑셀과 다르면 양면 표기.
3. **새 조사 반복 금지.** 기존 추출·캐시·스냅샷 재사용. 엑셀은 1회 추출 CSV 캐시 원칙.

---

## 1. docs/kb — 260702 통화 기반 도메인 지식 6문서 (tier B · 전부 FRESH)

전부 2026-07-03 00:13~00:15 생성(실측 `ls -la docs/kb/`). 260702 통화(115분, 신우진→김동학 지식이전)와 260702 엑셀 실측을 근거로 작성됨. **온톨로지 KB의 1차 도메인 개념 사전.** 6문서 전부 정독 완료.

| 파일 | 내용 요약 | tier | freshness | 주의점 |
|------|-----------|------|-----------|--------|
| `01_인쇄도메인_지식체계.md` | 조판·판걸이수(UP수)·인쇄방식 4종·소재(낱장/롤)·후가공 사전·1옵션≠1공정 원리·책자=내지+표지+면지·박 매트릭스·아크릴 도수변환 — CPQ(견적 자동화) 매핑표 포함 | B | FRESH | 통화 발화 기반 — "롤 계산 로직 미기재" 등 스스로 GAP을 표기함. 그 GAP은 GAP으로 승계할 것 |
| `02_상품마스터_가격표_구조_가격아키타입.md` | 두 엑셀의 논리 계층(마스터=권위)·가격 아키타입 3종(원자합산/고정가/매트릭스)·색상 코딩(빨강=필수/주황=선택/회색=내부)·암묵지 7건 목록 | B | FRESH | "280상품" 발언은 어림수(실측 191~243, KB_01 8장 #4 참조) — 집계 기준 미통일 |
| `03_레드프린팅_경쟁분석_온톨로지전략.md` | 온톨로지 부트스트랩 전략 — 룰(용어집) 합의 → 경쟁사 옵션 코퍼스 수집 → 동의어 정렬 → 스키마 귀속 → 검증 | B | FRESH | 경쟁사는 **구조만** 학습, 가격 값 복제 금지·권위는 항상 상품마스터(문서 §4.3에 자체 명시) |
| `04_CPQ_자동견적_설계자료.md` | 시스템 3+1 구성(페이지빌더/에디터/위젯빌더/어드민)·위젯 라이브 테스트 기록(제약 발동 성공·수량 min/max/step 구조 검증)·마이그레이션 2단계 전략 | B | FRESH | 위젯 테스트의 "수량 데이터 없음"은 크롤 누락 — 마스터 원본엔 존재(KB_01 2.3) |
| `KB_01_엑셀해부_접근방법론.md` | **260702 엑셀 실측 해부** — 마스터 13시트/가격표 19시트 인벤토리·색상코드 Hex 실측·계산공식집=로제타석·판걸이수 조인 키·정합성 이슈 6건·접근 순서 STEP 1~7 | B | FRESH | ⚠️ **8장 #1 판수 불일치(마스터 15 vs 판걸이수 18, 73×98) 미해결** — 실무진(신우진) 확인 대기. 견적 분모 직결 |
| `KB_02_스키마_ERD_적재파이프라인.md` | KB_01 규칙을 12테이블 스키마+ETL 7단계(P0~P6)로 전개. 옵션→공정 매핑·JSONLogic 제약·견적 엔진 의사코드 | B | FRESH | ⚠️ **이 스키마(product/option_group/price_tier…)는 "새로 만든다면"의 그린필드 제안이지, 라이브 DB의 실제 t_* 테이블이 아니다.** 라이브 스키마 얘기를 할 땐 반드시 §5 live-snapshot·webadmin sql이 권위. 혼동 금지 |

> **docs/kb ↔ 기존 하네스 개념 대응(혼동 방지):** docs/kb의 "원자합산형/고정가형/면적매트릭스형" = 기존 `_foundation/price-formula-collection-decode-260629.md`·라이브 `t_prc_*` 공식 체계와 같은 대상을 다른 이름으로 부른 것. 라이브 구현 관점 권위는 여전히 `pricing.py evaluate_price`(§5)다.

---

## 2. 권위 엑셀 260702 2종 (tier A · 수치의 절대 권위)

### 2.1 원본 파일 (직접 열지 않음 — 캐시 원칙)

| 파일 | 실측 | 비고 |
|------|------|------|
| `docs/huni/후니프린팅_상품마스터_260702.xlsx` | 1,090,492 bytes · 2026-07-02 17:22 | 13시트(계산공식집초안·MAP·상품 11시트) — 시트 구성은 KB_01 1.2 실측 |
| `docs/huni/후니프린팅_인쇄상품_가격표_260702.xlsx` | 505,553 bytes · 2026-07-02 17:23 | 19시트 — `후가공_박(백업)` 시트는 적재 제외(KB_01 1.2) |
| `docs/huni/~$후니프린팅_1차런칭...260630.xlsx` | 엑셀 임시 잠금파일 | 데이터 아님 — 무시 |

### 2.2 캐시·추출분 확인 결과 (지시대로 직접 열지 않고 확인)

- **`_workspace/excel-to-db/`(§32 x2d)에는 260702 전체 CSV 캐시가 없다** — 실측 결과 `00_research/`(리서치 3건)·`_meta/`(플레이북·CHANGELOG)뿐. CHANGELOG에 "스모크: 상품마스터 260702 → 13시트 추출·헤더 정탐지 PASS" 기록은 있으나 추출 산출 파일은 워크스페이스에 남아 있지 않다(세션 스크래치로 추정). **이 사실만 기록** — 전체 재추출이 필요해지면 x2d 번들 스크립트(`profile_workbook.py`) 1회 실행으로 캐시를 만든다(반복 Read 금지).
- **대신 260702 접근은 아래 2계 캐시로 충분히 커버된다:**

| 캐시 | 경로 | 내용 | tier/freshness |
|------|------|------|----------------|
| **260702 델타 diff (결정론)** | `_workspace/huni-dbmap/26_change-tracking-260702/` — `change-manifest-260702.md` + `master-diff-260610-260702.csv`(33행) + `price-diff-260527-260702.csv`(32행) + `structure-diff.md` | 260610→260702, 260527→260702 셀 단위 diff 전량. **시트 증감 0·상품 증감 0·실질 변경 = MAP 카테고리 개편 16셀·봉투 추가상품 50→10장 14셀·투명엽서 별색 1셀·스티커 출력소재 대개편 15변경+1행 추가(★연당가 변경 = High 재적재 후속)·라벨 정정** | A · FRESH |
| **260527/260610 기반 L1 무손실 추출** | `_workspace/huni-dbmap/06_extract/` — `<slug>-l1.csv` 11시트 + `price-<slug>-l1.csv` 15단가시트 + `pangeori-l1.csv`(판걸이수)·`import-paper-l1.csv`(출력소재) | 구버전 기준 전체 셀 캐시 | A · **PARTIAL-STALE(위 diff 65행 해당 셀만)** — diff에 없는 셀은 260702와 동일함이 확증되므로 그대로 인용 가능. diff 해당 셀은 260702 값으로 교체해 읽을 것 |
| 마스터 260610 추출 | `_workspace/huni-dbmap/24_master-extract-260610/` | §17 dedup 등이 쓰던 추출본 | A · PARTIAL-STALE(동일 원칙) |

> **결론(사용 규칙):** "260702 값이 뭐냐"는 질문은 ① diff 65행에 있으면 diff의 신값, ② 없으면 06_extract L1 값 = 260702 값. 엑셀 원본을 다시 열 필요 없음.

---

## 3. `_workspace/print-kb/wiki/` — §9 LLM 위키 (tier C · 페이지별 REVERIFY 전제)

구조(실측): `base/` 7페이지 · `huni/`(축) 7페이지 · `recipes/` 11페이지 · `policy/` 10페이지 + `sources/` 1 · `index.md` · `README.md` · `log.md` · `_curation/`(팩 11 + axis 6 + source-registry + gaps) · `_research/` · `_qa/`.

| 계열 | tier | freshness | 근거·주의 |
|------|------|-----------|-----------|
| `base/` 7 (인쇄방식·사이즈·종이·후가공·제본·색·프리프레스) | B에 준함(외부 표준 교차검증) | FRESH | 후니 특정 아님 — [검증]/[단일출처]/[추정] 표기를 그대로 승계. [추정]/GAP 항목은 사실로 쓰지 말 것 |
| `huni/` 축 7 (materials·processes·price-engine·cpq-options·widget-contract·load-path·modeling-axioms) | C | **PARTIAL-STALE** | 집필 시점 권위가 260527/260610 + round-13 진단. 260702 diff·6월 말~7월 초의 대량 COMMIT(배선 수렴·판걸이 lookup·제약규칙 등)이 미반영. 페이지 내 "STALE: …인용금지" 마킹(price-engine·cpq-options·load-path)은 1차 신호로 유효하나 맹신 금지 |
| `recipes/` 11 (digital-print·sticker·booklet·photobook·calendar·acrylic·silsa·goods-pouch·product-accessory·stationery + design-calendar 통합) | C | **PARTIAL-STALE~REVERIFY** | 결함 목록(round-13 기준)은 이후 다수가 교정 COMMIT됨(예: 디지털인쇄 base 공정 18건, 셋트 077/082/088 등). "현재 결함"으로 인용하면 틀린다 — 결함 현황 축은 반드시 §5 live-snapshot·§6 최신 HANDOFF로 재검증 |
| `policy/` 10 + `sources/` | C | FRESH(성격상) | 81%가 🟡/🔴(미확정) — **✅ 배지만 사실 권위**, 🟡는 "권장안"으로만 |
| `_curation/` 팩·axis·registry | C | PARTIAL-STALE | 06-12 작성. freshness 권위가 round-14 진단이던 시절 — 본 레지스트리가 260702 기준으로 대체 |

> 페이지×절 단위 승계 판정(INHERIT/REVERIFY/DROP)은 별도 산출물 `wiki-inheritance-map.md`에서 다룬다. 여기서는 계열 등급만 확정: **badge(✅🟡🔴⚪)와 STALE 마킹은 1차 신호로 쓰되, 260610/260527이 권위이던 페이지는 기본 REVERIFY.**

---

## 4. `_workspace/_foundation/` — SOT 정본 2종 + 배치 도구 (tier B/A)

| 원천 | 경로 | tier | freshness | 요약 |
|------|------|------|-----------|------|
| **상품 유형 분류 정본(SOT)** | `_foundation/product-type-classification-sot.md` | B | FRESH | 완제품(.01)/반제품(.02)/기성(.03)/디자인(.04 폐기)/추가(.05). CLAUDE.md §1 [HARD] — 재논쟁 금지 |
| **도메인 규칙 12항 정본(SOT)** | `_foundation/HARNESS-DOMAIN-RULES-260701.md` | B | FRESH | 판걸이수·판형(fn_best_plate/fn_calc_pansu)·종이류만 판형·면지 무가격·공식vs가격테이블·상품마스터 권위·시뮬레이터 입증 등 12규칙. 재논쟁 금지 |
| 가격공식 마스터·디코드 | `_foundation/price-formula-master.{md,csv}` · `price-formula-collection-decode-260629.md` | C | PARTIAL-STALE(6월 말 이후 배선 COMMIT 미반영 가능) | 전 상품 가격논리 정본(키스톤) — 공식 구조는 유효, 적재 현황 수치는 live-snapshot 재확인 |
| 채점 프레임워크 | `_foundation/SCORING-FRAMEWORK-260628.md` · `product-scoreboard.csv` | C | PARTIAL-STALE(채점 시점 이후 교정 다수) | PR_score/OC_score 방법론 자체는 유효 |
| **배치 도구(결정론·토큰0)** | `_foundation/batch/` — `wiring_scan.py`(배선 결함 4종)·`contribution_sim_scan.py`(silent-0 F층·유일 신뢰 측도)·`score_batch.py`·`qty_rule_audit_260702.py`·`staff_edit_scan.py` 등 | A(측정 도구) | FRESH | 재측정이 필요하면 이 스크립트를 재실행(새 분석 코드 작성 금지). 배선 진척=`batch/wiring/`(HANDOFF: 데이터 결함 0 달성, 잔여=아크릴 *_TBD 실무진 BLOCKED) |
| 개발 수정요청서(코드 C트랙) | `_foundation/remediation/DEV-REQUEST-*.md`(fn-calc-pansu-260701·set-sim-sizcd-260702) | C | FRESH | "데이터로 못 닫는 것 = 코드 결함" 원장. 온톨로지의 결함 축 원천 |

---

## 5. 라이브 DB 스냅샷 + 가격엔진 코드 (tier A)

| 원천 | 경로 | tier | freshness | 요약·주의 |
|------|------|------|-----------|-----------|
| **live-snapshot** | `_foundation/live-snapshot/` — `latest` → `snap_20260702_1119`(실측). t_* 전 테이블 CSV + `_manifest.csv`. 재촬영=`snapshot.sh` | A(현재 상태) | FRESH(07-02 11:19 시점) | ★ **"현재값"이지 "정답" 아님** — 권위 엑셀과 다르면 양면 표기. 07-02 밤 이후 COMMIT(예: 088 적재는 아직 승인 대기라 미포함)이 있으면 재촬영 후 사용 |
| **가격엔진 코드** | `raw/webadmin/webadmin/catalog/pricing.py` (47,738 bytes · 2026-07-02 19:51 수정 실측) — `evaluate_price`·`evaluate_set_price`(:718) | A | FRESH | 가격 계산의 **단일 권위 알고리즘**. 참고: `raw/webadmin`은 별도 git clone(HuniProductPrice2)이므로 최신화는 개별 pull 필요(메모리 `webadmin-git-repo-topology-260701`) |
| webadmin 적재 oracle | `raw/webadmin/sql/*.sql` · `tools/load_master.py`(로직만 — **입력 xlsx=v03 금지**) · `tools/deploy.py` | A | FRESH(로직) | 스키마·적재 경로의 소스 오브 트루스 |
| 라이브 직접 조회 | `.env.local RAILWAY_DB_*` 읽기전용 SELECT | A | 실시간 | DB 미적재·SELECT만. 비밀값은 `.env.local`에만 |

---

## 6. 주요 하네스 산출 루트 (tier C · 최신 라운드 우선)

각 루트의 **HANDOFF.md/CHANGELOG.md가 "그 하네스의 현재 진실" 진입점**이다. 오래된 라운드 문서를 단독 인용하지 말 것.

| 하네스 | 루트 | 최신 상태(진입점 실측) | freshness 주의 |
|--------|------|------------------------|----------------|
| §7 huni-dbmap | `_workspace/huni-dbmap/` (00_schema~35_category-map) | **`26_change-tracking-260702/` = 260702 델타 권위(§2.2)** · `06_extract/` L1 캐시 · `00_schema/` ref-*/columns | `00_schema` 덤프류는 06-04~06-06 시점 — 스키마 현재값은 live-snapshot이 우선. `00_schema/price-engine-ddl.md`는 **STALE(§8)** |
| §13 huni-price-quote | `_workspace/huni-price-quote/` (01_engine~05_gate) | evaluate_price 계약 추출·P게이트 | 계약 추출은 유효, 게이트 수치는 재계산 후 인용 |
| §14 huni-price-engine-diag | `_workspace/huni-price-engine-diag/` (01_mechanism~03_synthesis) | 5장치(공식/구성요소/할인/뷰어/시뮬레이터) 역할 정의 | 장치 "역할 원리"는 FRESH — 온톨로지의 가격 장치 축 원천 |
| §18 huni-price-engine-design | `_workspace/huni-price-engine-design/` (01_formula~05_codex) | 책자 표지 분기 설계 GO·cover_mult ×2는 BLOCKED(C트랙) | 설계 명세는 "설계"지 "적재됨"이 아님 — 적재 여부는 live-snapshot 대조 |
| §26 huni-price-table-integrity | `_workspace/huni-price-table-integrity/` (01_authority·02_load·04_gate·_batch) + HANDOFF | 무결성 진단·fn_calc_pansu 해소 여정 | HANDOFF가 최신(t_siz_pansu 신설·판걸이 lookup) |
| §23 huni-set-product | `_workspace/huni-set-product/` (01_authority~07_sim_convergence) | `05_gate/set-price-full-diagnosis-260702.md`(19셋트 전수)·088 재설계=**적재 승인 대기(COMMIT 미실행)** | 088 관련 값은 "설계 확정·미적재"로 라벨할 것 |
| §21 huni-catalog-conformance | `_workspace/huni-catalog-conformance/` (01_authority~09_load) | 전 상품 12축 정합·RC 교정 완료분 | 체크리스트=`01_authority/conformance-checklist.csv` |
| §31 huni-constraint-rules | `_workspace/huni-constraint-rules/` | CN-1~CN-6 분류·폼빌더 정형 shape 계약 | 제약 축 원천 — docs/kb의 JSONLogic 제약과 같은 대상 |
| 역공학 | `docs/reversing/` — SDK/Widget 리포트 HTML 2건 + `red_reverse_engineer/`(03_deobfuscated·05_readable) | §22 재검증·§25 가독화 완료분 | **tier D** — 갭헌팅 보조. 후니 권위를 덮어쓸 수 없음. 4월 초판 캡처는 6월 재역공학(redo-260623)이 대체 |

---

## 7. MEMORY 교훈 (tier B·훅 계층)

`~/.claude/.../memory/MEMORY.md` 인덱스 + 토픽 파일. 반복 실수 방지 원장(예: "1건 고정금액 ×수량 과대청구 3회 반복", "단가행 존재≠배선완료", "IMPORT시트 등록 자재 삭제 금지"). 온톨로지의 **함정(anti-pattern) 축** 원천으로 승계. 단, 수치가 든 항목은 시점 라벨 확인.

---

## 8. ★ STALE 인용 금지 목록 (명시)

아래는 **어떤 이유로도 사실 근거로 인용 금지.** 각 항목에 대체 소스를 지목한다.

| # | 금지 원천 | 왜 금지인가 | 대체 소스 |
|---|-----------|-------------|-----------|
| 1 | `prdmaster_full_migration_v03` 계열 전부 (`load_master.py`의 입력 xlsx 포함) | 구버전 마이그레이션 산출 — round-13에서 오적재 진원으로 판정 | 260702 엑셀(§2 캐시 경로) + 06_extract L1 |
| 2 | `_workspace/huni-dbmap/00_schema/price-engine-ddl.md` | 구 가격 스키마 설계 — 현행 t_prc_* 체계와 불일치 | live-snapshot t_prc_* + `raw/webadmin/sql/` + pricing.py |
| 3 | `raw/webadmin/docs/prcx01-pricing-model.md` · `pricing-erd.md` | 8차원·clr_cd(도수)·frm_typ_cd 구설계 — 엔진 미참조·라이브 부재 확정(§14 진단) | pricing.py 직접 + §14 산출 + live-snapshot. (설계 "의도 배경" 서술로만 허용) |
| 4 | `_workspace/huni-widget/03_spec/huni-db-mapping.md` | "가격/제약 미작성" 전제의 구 매핑 — 현행과 다름 | §6 huni-widget 컨버전 트랙(hw-db-cartography) 산출 + live-snapshot |
| 5 | 위키 각 페이지 상단 **STALE 마킹분**(constraint_json·dep_proc_cd·excl_groups 등 삭제된 컬럼/테이블 서술 포함) | Phase10/11 스키마 변경으로 실체 소멸 | live-snapshot 컬럼 실측 + `raw/webadmin/sql/18~23_*.sql` |
| 6 | **구 260610/260527 수치의 무대조 인용** | 260702가 대체 — diff 65행(마스터 33·가격표 32) 해당 셀은 값이 다름(★스티커 소재 연당가·봉투 추가상품 50→10장 등) | §2.2 diff 매니페스트로 대조 후 인용 |
| 7 | 가격표 시트 `후가공_박(백업)` | 운영 백업본 — 적재·분석 대상 아님(KB_01 1.2) | `후가공_박(소형)`·`후가공_박(대형)` |
| 8 | `docs/reversing` 4월 초판 위젯 캡처·분석(재역공학 이전분) | 6월 위젯 +137KB 드리프트 — redo-260623·`_latest`가 대체(§22) | `red_reverse_engineer` 최신분·05_readable |
| 9 | 위키 recipes의 **round-13 결함 목록을 "현재 결함"으로 인용** | 상당수 교정 COMMIT 완료(배선 수렴·base 공정 18건 등) — 시점이 낡음 | live-snapshot 재실측 + 각 하네스 HANDOFF 최신분 |
| 10 | `docs/huni/~$*.xlsx` | 엑셀 임시 잠금파일 — 데이터 아님 | 해당 정식 파일 |

**PARTIAL-STALE 경계 주의 2건(금지는 아니나 축 회피):**
- `huni-dbmap/00_schema/` 덤프·ref-* CSV: 06-04~06-06 시점 — 행수·연결 현재값은 live-snapshot으로.
- `docs/kb/KB_02` 12테이블 스키마: 그린필드 **제안**이므로 "라이브 스키마 서술"로 인용 금지(§1 주의점).

---

## 9. GAP·미확정 (원천이 없어서 못 닫는 것)

| # | GAP | 성격 | 소유자 |
|---|-----|------|--------|
| 1 | **판수 불일치**: 마스터 디지털인쇄 판수 15 vs 판걸이수 시트 18 (73×98) | 데이터 권위 충돌 — 견적 분모 직결. KB_01 8장 #1 | 실무진(신우진) 확인 대기 |
| 2 | 롤 소재 가격 계산 로직 | 엑셀 미기재 암묵지(02문서 §6 #1) — 실사 전체 영향 | 실무진 + 설계 |
| 3 | 책등 두께 공식 → 표지 사양 파생 | 엑셀 미기재(02문서 §6 #4) — 책자군 전체 | 실무진 + §18 |
| 4 | 260702 전체 CSV 캐시 부재 | §2.2 — diff+구 L1로 커버되나, 셀 전수 작업 시 x2d 1회 추출 필요 | 필요 시 x2d 실행 |
| 5 | 아크릴 `*_TBD` 단가 6건·088 적재 승인 | 실무진 답변/인간 승인 대기(§27·§23) | 사용자·실무진 |
| 6 | 상품 수 집계 기준(191/243/280) 미통일 | KB_01 8장 #4 | 온톨로지 설계 시 정의 필요 |

---

## 10. 사용 요약 (지식 구축가를 위한 한 장)

1. **개념·용어·원리** → docs/kb 6문서(§1) + 위키 base(§3) + SOT 2종(§4).
2. **수치(가격·사이즈·수량)** → 260702 diff(§2.2) 우선, 없으면 06_extract L1 = 260702 동일 확증.
3. **라이브 현재 상태** → live-snapshot latest(§5) — 항상 "현재값" 라벨.
4. **가격 계산 방식** → pricing.py evaluate_price(§5)가 유일 알고리즘 권위. KB_02 엔진 코드는 제안.
5. **하네스 결론** → 각 루트 HANDOFF 최신분(§6)만. 옛 라운드 단독 인용 금지.
6. **인용 전 §8 금지 목록 필수 통과.**
