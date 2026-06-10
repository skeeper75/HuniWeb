---
name: dbm-correctness-audit
description: >
  후니프린팅 라이브 DB의 적재 정확성을 감사·교정하는 round-13 방법론 스킬. round-10/12가 "라이브=권위"로
  본 전제를 역전 — 라이브 실데이터를 "교정 대상"으로 보고, raw/webadmin 적재 oracle(적재 SQL sql/01a~15·
  적재 로직 tools/load_master.py 등·논리 ERD 문서 docs/)과 스키마 설계의도·엑셀 원본·확정 도메인(round-11/12)을
  "정답 기준"으로 삼아, 각 상품의 칼럼에서 size·자재·공정·도수·인쇄옵션을 어떻게 추출해야 정확한지 상품별
  추출규칙을 도출하고, 라이브를 상품별 전수 diff해 무엇이 왜 틀렸고 어떻게 고칠지 교정 매니페스트를 산출한다.
  핵심 = webadmin 적재 로직이 엑셀 칼럼을 t_*로 변환한 규칙을 재구성하고 그 규칙이 옳은지 판정(옳으면 유지,
  틀리면 교정). DB 직접 쓰기는 하지 않는다. '라이브 정합 교정', '교정 감사', '적재 정확성 점검', 'webadmin
  적재로직 감사', '상품별 추출규칙', '라이브 데이터 교정', '교정 매니페스트', 'round-13', '정합 교정 다시',
  '교정 감사 다시', '특정 상품 교정만', '추출 계획 점검' 작업 시 반드시 이 스킬을 사용. 매핑 확정(round-12)은
  dbm-mapping-research, 컬럼 의미(round-11)는 dbm-column-domain, 적재본 조립/실행은 dbm-load-readiness/
  dbm-load-execution이 담당하므로 그 작업에는 트리거하지 않는다.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Skill
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-10"
---

# dbm-correctness-audit — round-13 라이브 정합 교정

## 목적과 프레임 [HARD]

round-1~12는 매핑을 도출·적재·추적했고, round-12는 라이브를 **상태 권위**로 봤다. round-13은 그 전제를
**역전**한다: **라이브 데이터는 교정 대상(defendant)이고, 정답은 적재 oracle + 엑셀 원본 + 스키마 의도 +
확정 도메인이다.**

사용자 우려가 출발점이다 — 라이브 DB는 `raw/webadmin`(HuniProductPrice2)이 적재했는데, 그 적재 로직과
스키마가 충분히 분석되지 않은 채 데이터가 매핑돼 교정 필요분이 많다. round-12가 이미 증거를 봤다(레더 자재
3-way 혼재·코팅 정책 family 불일치·떡메모지 page_rule 잡음). round-13은 이를 **상품별로 증명**하고 고친다.

핵심 검사 한 문장: **`load_master.py`가 엑셀 칼럼을 t_*로 변환한 규칙을 재구성하고, 그 규칙이 엑셀 원본 의도 +
스키마 의도 + 도메인에 비춰 옳은지 판정 — 옳으면 라이브 유지, 틀리면 교정.** "계획이 서있는가"의 답은
상품별 추출규칙(extraction-plan)이고, "점검됐는가"의 답은 라이브 diff + 교정 매니페스트다.

## 권위 순서 [HARD] — 정답 oracle (라이브=교정대상)

이 순서는 round-10/12의 "라이브=권위"를 **역전**한다. 충돌 시 oracle이 옳고 라이브가 틀린 것으로 본다.

0. **상품 정체 (실제 판매 사이트) [최상위·HARD]** — 칼럼을 해석하기 전에 **그 상품이 무엇인지**부터 확정한다: 어느 범주인가(일반 인쇄물 / 포장재 / 굿즈 / 액세서리), 무엇으로 구성되는가(세트인가 단품인가), 어떻게 생산되는가. 증거 = **실제 후니 커머스 사이트 `huniprinting.com`** 상품 페이지(`.env.local` `HUNIPRINTING_SITE_*`, gstack browse — 비전형 상품은 필수) + 기존 크롤 증거 `_workspace/print-quote/01_research/asis-huniprinting/crawl-evidence/`(중복 접속 회피) + print-quote 후니 분석 `_workspace/print-quote/02_business/product-master.md`(카테고리·MES·생산 Case)·`process-flow.md`(생산방식)·IA. **상품 정체를 모른 채 칼럼을 매핑하면 범주부터 틀린다** — 실증: 인쇄배경지는 카테고리 012 "포장재"(배경지+봉투/케이스 세트)인데 round-11이 디지털인쇄 일반상품으로 오분류. "스마트톡형"은 스마트톡(아크릴 굿즈)용 배경지 형태(사이트 확정). **추측 금지 — 정체 불명은 사이트 확인 또는 🔴 컨펌, 절대 추론으로 단정하지 않는다.**
1. **엑셀 원본** — 회사가 실제로 파는 것의 1차 증거. `docs/huni/후니프린팅_상품마스터_260610.xlsx`(+가격표),
   충실 추출본 `_workspace/huni-dbmap/06_extract/<slug>-l1.csv`(+meta).
2. **webadmin 적재 oracle** — 적재가 어떻게 실행됐는가:
   - 적재 SQL: `raw/webadmin/sql/01a_tables_master.sql`~`15_phase7_comments.sql`(물리 스키마·FK·트리거·seed·NOT NULL).
   - 적재 로직: `raw/webadmin/tools/load_master.py`·`load_discounts.py`·`migrate_phase7.py`·`fix_size_dims.py`·`verify_load.py`(엑셀→t_* 변환 = 정답이자 오류 원인).
   - 논리 ERD·결정: `raw/webadmin/docs/`(`entity-table-map.md`·`pricing-erd.md`·`prcx01-pricing-model.md`·`naming-guide.md`·`fk-action-policy.md`·`schema-changes-*.md`·`dedup-products-*.md`)·`.planning/`.
   - **[HARD] `raw/webadmin/webadmin/catalog/models.py`는 `# auto-generated`(inspectdb·`managed=False`) — DB의 거울일 뿐 적재 로직 아님. `db_comment`(컬럼 의미)에만 사용.** 적재 로직은 `sql/`+`tools/`에 있다.
3. **스키마 설계의도** — `00_schema/schema-design-intent-map.md`(OM-1~7·삼중바인딩)·`00_schema/cpq-schema.md`.
4. **확정 도메인(round-11/12)** — `15_domain-spec/<family>/`·`16_mapping-research/<family>/mapping-final.md`·`_review/실무진-검토질문.md` ✅확정 Q1~Q15(★5건). 의도된 의미 = 라이브를 판정할 잣대.
5. **라이브 DB 실데이터** — 읽기전용 psql. 측정 대상(피고)이지 판관 아님. 1~4에 비춰 판정.

## 절차 (시트=작업 단위, 파일럿 → 확대)

**C0 컨텍스트 확인** — `17_correctness/<family>/` 존재로 초기/부분 재감사 판별. 부분 요청이면 해당 상품/속성만.
라이브 접속은 `.env.local` `RAILWAY_DB_*`(비밀값 비노출).

**C-ID 상품 정체 확정 (product-identity, C1보다 먼저) [HARD]** — family의 각 상품에 대해 "이게 무엇인가"를 권위 0(실제 사이트)으로 확정한다: 범주(일반 인쇄물/포장재/굿즈/액세서리)·구성(세트/단품·구성품)·생산방식(공정 Case). 먼저 기존 크롤 증거 + `product-master.md`(카테고리 012=포장재 등)·`process-flow.md`를 읽고, **비전형이거나 정체가 불명확한 상품은 `huniprinting.com`을 gstack browse로 직접 확인**(상품명·옵션·구성·이미지). → `product-identity.md`(상품·범주·정체·구성·생산방식·출처). 이 정체가 C2 추출규칙의 전제다 — 정체가 틀리면(예: 포장 세트를 일반 인쇄물로 봄) 모든 속성축 추출이 틀린다. 정체 불명은 🔴 컨펌(추측 금지).

**C1 적재 로직 재구성 (loadlogic-notes)** — `tools/load_master.py`(+관련 스크립트)를 읽어, 이 family의 엑셀
칼럼이 어느 t_* 컬럼으로 어떤 변환을 거쳐 적재되도록 코딩됐는지 규칙으로 재구성한다. `sql/`로 물리 스키마
제약(FK·트리거·NOT NULL·seed 코드값)을 확인. **이 규칙이 곧 라이브 현재 상태의 설명이며, 결함은 여기서
난다.** 스크립트가 그 칼럼을 안 다루면 "적재 경로 불명"으로 표기(그 자체가 finding).

**C2 정답 추출규칙 도출 (extraction-plan)** — 각 상품에 대해, 엑셀 원본(1)+스키마 의도(3)+도메인(4)에 비춰
각 속성축(size·자재·공정·도수·인쇄옵션)을 **어떻게 추출·변환해 어느 t_*.컬럼에 넣어야 정확한지** 규칙을
확정한다. C1의 실제 적재 규칙과 **나란히 놓는다**(실제 vs 정답). 도수=`t_clr_color_counts`/별색≠도수(별색=공정
PROC_000007)·UV=PROC_000002·자재=parent+usage_cd·판형=출력용지규격 등 확정 도메인 인용.

**C3 라이브 전수 실측 + diff (live-diff)** — 각 상품의 라이브 t_* 행을 읽기전용으로 전수 측정하고, C2 정답값과
field-for-field 대조. 행 존재만이 아니라 **변형 커버리지**까지(round-7 D-1 교훈). 코드값·FK 충족·고아행 여부 포함.

**C4 분류 + 교정 제안 (correction-manifest)** — 각 diff를 CORRECT / MIS-LOADED / MISSING / EXTRA / AMBIGUOUS로
분류하고 why(oracle 근거 + 적재로직 원인)+how(비파괴 교정 제안)+심각도+라우팅을 기록. search-before-mint로
교정 시 기존 행 재사용 우선(레더 .06 고아행 재연결 패턴). EXTRA/REMOVED=논리삭제 제안(hard-delete 금지).

**C5 게이트** — 산출을 `dbm-validator`가 K1~K6으로 독립 검증(생성자≠검증자).

## 산출 (write to `_workspace/huni-dbmap/17_correctness/<family>/`, 한국어)

- `product-identity.md` — 상품별 정체: 범주(일반인쇄/포장재/굿즈/액세서리)·구성(세트/단품)·생산방식·출처(사이트 URL/크롤 증거/product-master 라인). 비전형 상품 정체 확정.
- `loadlogic-notes.md` — 적재 로직 재구성 + 발견된 적재 결함(file:line 근거).
- `extraction-plan.md` — 상품별 × 속성축 정답 추출규칙(엑셀 출처·변환·목표 t_*·oracle 근거). 빈칸 0.
- `live-diff.md` — 상품별 라이브 실측 vs 기대값 대조(재현 SELECT, 비밀값 없이).
- `correction-manifest.md` — 발견 분류표(ID·상품·속성·분류·현재값·정답값·why·how·심각도·라우팅). 빈칸 0.
- 공유: `17_correctness/_gate/<family>-gate.md` — validator 게이트 결과.

## 게이트 K1~K6 (dbm-validator 독립 수행)

| # | 게이트 | 기준 |
|---|--------|------|
| K0 | 상품 정체 확정 | family 전 상품의 범주·구성·생산방식이 product-identity에 확정(권위 0 출처 인용 실재), 비전형 상품은 실제 사이트 근거. 정체 불명은 🔴 표기(추측 단정 0) |
| K1 | 추출규칙 커버리지 | family 전 상품 × 5 속성축이 extraction-plan에 존재(N/A는 사유 명기) |
| K2 | oracle 인용 실재 | 각 정답값·교정의 oracle 근거(파일:라인/SQL/엑셀셀/Q번호)가 실존·내용 일치(round-11 G-1 날조 교훈) |
| K3 | 적재로직 근거 | MIS-LOADED 발견이 적재 로직(load_master.py 등) 원인을 재구성하거나 "적재경로 불명"으로 정직 표기 |
| K4 | 라이브 실측 독립 재현 | 교정 매니페스트의 라이브 현재값을 검증자가 독립 SELECT로 재현(표본) |
| K5 | 비파괴·search-before-mint | 교정 제안에 COMMIT/DDL/DELETE 없음, EXTRA=논리삭제 제안, 신규 mint 전 기존행 재사용 입증 |
| K6 | 오모델 정합 | 발견이 OM-1~7·삼중바인딩과 정합(예: 코팅=공정 Q9·색≠siz·size↔option 경계) |

## 에러 핸들링·원칙

- **DB 미적재 [HARD]** — 본 라운드는 교정 매니페스트+델타 제안까지. 실 COMMIT/DDL/논리삭제는 round-5/인간 승인.
- 라이브 접속 실패: 1회 재시도 후 "실측 보류" 표기(침묵 추정 금지). 비밀번호 비출력.
- 적재 로직 재구성 불가: "적재 경로 불명" = finding(라이브가 어떻게 그 값을 얻었는지 모른다는 사실).
- oracle 내부 충돌(엑셀 vs ERD 문서): 명시 + 권위순서 잠정판정 + 🔴 컨펌.
- 위임 시 인라인 한국어 선호(round-10 교훈: "완료"만 반환 실패모드 — 산출 파일 직접 회수).
- 시트별 주의(메모리 권위): 실사 가격=포스터사인 면적매트릭스 · 굿즈파우치 size→option · 도무송 형상=size
  칼틀 1:1 · 옵션=자재+공정 BUNDLE · 판형=출력용지규격 · 별색=공정(clr_cd=NULL) · 중간계산(판걸이수)=앱·DB미저장.
