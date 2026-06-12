# 캘린더(calendar) + 디자인캘린더 레시피  {전체상태: 🟡}

> 조립 뷰(README §3·§9). 횡단 사실은 축 페이지를 `[[링크]] + 관계동사`로 참조만 한다(본문 복붙 금지). 이 페이지 고유 사실(prd_cd 목록·교정대기 행)만 원자 블록으로 둔다.
> **디자인캘린더 통합:** `design-calendar`는 별 페이지로 분리하지 않는다(큐레이션 팩 결정 — round-13/12 산출이 `17_correctness/calendar/`·`16_*/calendar/`에 합산 처리, 실무진 Q6=디자인은 같은 5상품의 에디터·가격포함 surface). 본 페이지 내 §B·각 절 디자인캘린더 하위블록으로 다룬다.
> **권위:** 정체 = `17_correctness/calendar/product-identity.md`(C13, FRESH) · 차원/BOM = `15_domain-spec/calendar/`(C11)·`16_mapping-research/calendar/mapping-final.md`(C12) · 결함 = `17_correctness/calendar/correction-manifest.md`(C13)·`_gate/calendar-gate.md`(GO). 큐레이션 팩 = `_curation/pack-calendar.md`.
> **STALE 금지:** `price-engine-ddl.md`([[../huni/price-engine#PE-STALE]])·v03 입력 xlsx([[../huni/load-path#LP-STALE]])·constraint_json/dep_proc_cd 적재 타깃 인용 0. 공정택일은 라이브 부존재 excl_groups가 아니라 라이브 실재 구조(`mand_proc_yn`·option_groups 흡수)로 표기([[../huni/processes#PRC-GAP-5]]). 라이브 오적재는 "라이브 현재값 → 정답" 양면 표기(7절).

---

## CQ 헤더 (이 페이지가 답하는 질문)

- 캘린더는 무엇인가 — 어떤 상품(탁상/미니탁상/엽서/벽걸이/와이드벽걸이)이고 디자인캘린더는 별 상품인가.
- 어떤 차원·옵션이 있는가 — 사이즈·출력판형·장수(낱장 매수)·캘린더가공 택일그룹.
- 가격은 어떻게 계산되는가 — 캘린더=원자합산형 공식엔진(디지털인쇄 계열)·디자인캘린더=고정가형.
- DB에 어떻게 등록하는가 — webadmin `load_master` 적재 경로·FK 위상·삼각대거치 공정 mint.
- 현재 라이브 적재 상태·교정 대기는 무엇인가 — C-CAL-01~14 교정대기 + 컨펌 CL-A~G.

---

## 0. 정체 (identity) — 캘린더 + 디자인캘린더
앵커: `t_prd_products` · `t_cat_categories`

### [CAL-ID-001] 캘린더 = 5 form factor (PRD_000108~112)  {✅}
- 내용: 캘린더 family = **5 form factor 완제품** — **탁상형 PRD_000108**(MES 007-0001)·**미니탁상형 109**(007-0002)·**엽서 110**(007-0003)·**벽걸이 111**(007-0004)·**와이드벽걸이 112**(007-0005). 전부 라이브 `prd_typ_cd=PRD_TYPE.04 디자인상품`. **form factor가 곧 정체** — 포토북(1상품·size variant)과 반대로 캘린더는 **거치/제본 방식이 form factor를 가른다**(삼각대=탁상·트윈링=벽걸이, MES 007-0001~5 1:1).
- 앵커: `t_prd_products`(prd_typ_cd .04) · MES_ITEM_CD(라이브 NULL → 정답 007-0001~5, [CAL-ST-DEF-013])
- 출처: `17_correctness/calendar/product-identity.md` §1 + `_gate/calendar-gate.md` K0 PASS(독립 SELECT 5상품 재현) {tier C(round-13), FRESH·라이브 GROUP BY 재현}
- 연결: [[#CAL-ID-002]] · [[../huni/load-path#LP-001]] (loaded-via — load_master 10_상품정보 시트)
- answers_cq: CQ-PROD-01 (상품 분류·적재 기준)
- tags: #캘린더 #정체 #formfactor5 #PRD108-112

### [CAL-ID-002] 디자인캘린더 = 같은 5상품의 에디터·가격포함 surface (별 상품 아님)  {✅}
- 내용: 디자인캘린더(가격포함)는 **별 prd_cd가 아니다** — 캘린더 5상품(PRD_000108~112)과 **같은 상품**. 라이브에 별 캘린더 prd_cd 부재로 재확인(CL-1 해소). 차이는 ① 주문 surface(캘린더=`file_upload_yn=Y` 업로드판 / 디자인캘린더=`editor_yn=Y` 에디터판) ② 페이지 모델(캘린더=장수 고객옵션 / 디자인캘린더=페이지 디자인 확정) ③ 가격(캘린더=공식엔진 / 디자인캘린더=고정가). **별 상품 mint 금지** — surface 속성으로 같은 prd_cd에 적재.
- 앵커: `t_prd_products`(같은 PRD_000108~112) · `editor_yn`/`file_upload_yn`(2채널)
- 출처: `16_mapping-research/calendar/mapping-final.md` §B B1·라이브 PRD_TYPE.04 + `17_correctness/calendar/correction-manifest.md` OK-6 {tier C(round-12/13), FRESH·라이브 재확인}
- 연결: [[#CAL-DC-001]] (디자인캘린더 가격) · [[#CAL-WID-001]] (mapped-to — editor surface=에디터 채널)
- answers_cq: CQ-PROD-01 (상품 분류) · CQ-PROD-08 (UI 노출 채널)
- tags: #디자인캘린더 #같은상품 #surface #editor_yn

### [CAL-ID-003] 캘린더는 정체 오분류 0 (단품·낱장·카테고리 고아 0)  {✅}
- 내용: 캘린더 5상품은 전부 **일반 인쇄물 007(디지털인쇄 낱장 묶음)·단품(set 아님)·내지/표지 개념 없음**. digital-print(인쇄배경지=포장재 오분류) 같은 **범주 오분류는 캘린더에 없다**(F-ID-1 의심 반증). 카테고리 노드 전부 lvl2 정상(108/109→CAT_000112·110→CAT_000114·111/112→CAT_000115, upr=CAT_000007) — **고아 0**(digital-print 043~046→CAT_000296 같은 문제 없음). 단품·낱장 함의 → **page_rule 없음**(낱장에 page_rule 적재 ✗)·고유 축 = 장수(낱장 매수).
- 앵커: `t_cat_categories`(CAT_000112/114/115 lvl2 정상) · `t_prd_product_categories`
- 출처: `17_correctness/calendar/product-identity.md` §0·§3 + `correction-manifest.md` OK-4 + `_gate/calendar-gate.md` K0/K4(고아 0 독립 재현) {tier C(round-13), FRESH}
- 연결: [[#CAL-DIM-002]] (장수=고유 축) · [[../huni/load-path#LP-GAP-3]] (카테고리 고아 횡단 — 캘린더는 해당 없음)
- answers_cq: CQ-PROD-01 (상품 분류)
- tags: #캘린더 #정체오분류0 #낱장 #카테고리정상

### [CAL-ID-004] 부자재 = 별 상품 (캘린더봉투 PRD_000005 · 우드거치대 자재)  {🟡}
- 내용: 캘린더 부자재는 **본체와 별개**. **캘린더봉투 = PRD_000005**(별 기성상품 PRD_TYPE.03·MES 012-0008·포장재 012) → 캘린더 추가상품(addon·★사이즈선택 캐스케이드). **우드거치대 = 자재**(Q13 확정 — 엑셀상 캘린더가공/추가상품 양쪽 표기이나 자재 단일 귀속). 우드행거는 본 family 시트 범위 외(무시). 상품 폭증 금지 — 봉투=addon·우드거치대=자재로 연결.
- 앵커: `t_prd_products`(PRD_000005 봉투) · `t_prd_product_addons`(봉투 연결) · `t_prd_product_materials`(우드거치대 자재)
- 출처: `17_correctness/calendar/product-identity.md` §2 + `correction-manifest.md` C-CAL-08/09 {tier C(round-13), FRESH·라이브 PRD_000005=012-0008 확인}
- 연결: [[#CAL-CPQ-002]] (봉투 addon ★사이즈선택) · [[../huni/materials#MAT-002]] (uses — 우드거치대 부속 자재) · [[../huni/cpq-options#CPQ-006]] (requires — addon template)
- answers_cq: CQ-PROD-03 (부자재 귀속) · CQ-SUB-01 (부자재 상품화)
- tags: #캘린더 #부자재 #캘린더봉투 #우드거치대

---

## 1. 차원 (dimensions) — 캘린더
앵커: `t_prd_product_sizes`/`plate_sizes` · `t_siz_sizes`

### [CAL-DIM-001] 사이즈 = form factor별 재단치수 variant (이산)  {✅}
- 내용: 캘린더 사이즈는 form factor별 **이산 재단치수 variant**(`t_prd_product_sizes.siz_cd → t_siz_sizes`) — 라이브 적재됨: 탁상 2·미니 2·엽서 6·벽걸이 3·와이드 1. 작업치수(work)는 도련 2mm 도출(별도 칸 불요·Q14). 실사 같은 면적매트릭스가 **아니라 이산 siz_cd** — 엽서 6 variant 정합(round-12 D-1 "SIZ_000007 불일치"는 오탐, 엑셀 row16 실재로 반증).
- 앵커: `t_prd_product_sizes.siz_cd` · `t_siz_sizes`(cut/work 치수)
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C5·C7·C8·Q14 + `correction-manifest.md` OK-1(D-1 반증) + `_gate/calendar-gate.md` K2(엑셀 L12 직접 확인) {tier C(round-12/13), FRESH·라이브 카운트 재현}
- 연결: [[../base/sizes#BSZ-001]] (uses — 재단/작업/출력판형 보편 구분) · [[../base/sizes#BSZ-004]] (uses — 블리드 도련 도출)
- answers_cq: CQ-PROD-06 (variant 사이즈 → 차원 분해)
- tags: #캘린더 #사이즈 #이산variant #도련도출

### [CAL-DIM-002] 장수(낱장 매수) = 고유 축 (page_rule 아님 · 고객옵션+가격공식)  {🟡}
- 내용: 캘린더의 1차 고유 차원은 **장수(낱장 매수)** — `4(8P)/8(16P)/12(24P)` 형태(낱장 4/8/12장, 앞뒤=8/16/24P). **page_rule(책자 내지)·bundle(떡제본)과 다른 축**(낱장 단품에 page_rule 적재 ✗). 정답 적재 = **고객선택 CPQ 옵션 + 가격공식 바인딩**(Q12 확정). 라이브 현재값 = page_rules 0행(정상)·option_* 0행(미적재). page_rule 단정 금지.
- 앵커: CPQ option(`t_prd_product_options`/`option_items`, [[#CAL-CPQ-001]]) + 가격공식 — page_rule **아님**
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C17·Q12 + `15_domain-spec/calendar/product-bom.md` "장수(캘린더 고유 축)" + `correction-manifest.md` C-CAL-05 {tier C, FRESH·라이브 page_rules 0행 재현}
- 연결: [[#CAL-CPQ-001]] (장수=CPQ 옵션그룹) · [[#CAL-PRC-001]] (priced-by — 장수×공식 합산) · [[#CAL-DC-001]] (디자인캘린더=페이지 고정 대비)
- answers_cq: CQ-PROD-06 (차원 분해) · CQ-PROD-01 (장수 적재 기준)
- tags: #캘린더 #장수 #낱장매수 #page_rule아님 #Q12

### [CAL-DIM-003] 출력판형 = 출력용지규격 계열코드 (.01 국전계열 / .03 기타 — 치수 아님)  {🟡}
- 내용: 캘린더 출력판형은 `t_prd_product_plate_sizes.output_paper_typ_cd` = **계열코드**(치수가 아니라 OUTPUT_PAPER_TYPE 코드). 라이브 = 탁상/미니/엽서/벽걸이=`.01 국전계열`·와이드(3절)=`.03 기타`. round-11 "316x467/330x660" 치수 인용은 **오류** → 정정: **코드는 계열·치수는 별도 siz**. 값 자체는 도메인상 옳다(국전계열·3절=기타). 단 **적재경로는 퇴행 위험**([CAL-ST-DEF-004] — load_master 코드는 .01을 재현 못함, 양면표기).
- 앵커: `t_prd_product_plate_sizes.output_paper_typ_cd`(OUTPUT_PAPER_TYPE.01/.03)
- 출처: `16_mapping-research/calendar/mapping-final.md` §0(라이브 정정)·§A C9 + `correction-manifest.md` OK-3 + 메모리 `dbmap-platesize-is-output-paper` {tier C(round-12), FRESH·라이브 .01/.03 실측}
- 연결: [[../base/sizes#BSZ-003]] (uses — 출력판형 보편 정의) · [[#CAL-ST-DEF-004]] (적재경로 퇴행 .01↔.03)
- answers_cq: CQ-PROD-06 (출력판형 축) · CQ-FILE-01 (파일사양 입력)
- tags: #캘린더 #출력판형 #계열코드 #국전계열 #3절

---

## 2. 자재·공정 BOM — 캘린더
앵커: `t_prd_product_materials`/`processes` · `t_mat_materials` · `t_proc_processes`

### [CAL-BOM-001] 자재 = 본체 종이(usage USAGE.07 공통) + 거치/제본 부속  {🟡}
- 내용: 캘린더 자재 = **본체 종이**(`*별도설정` 공통풀·3절은 스노우지250g/몽블랑190·240g 직접명) + 부속(삼각대·트윈링·끈·우드거치대). **본체 종이 usage_cd = USAGE.07 공통**(라이브 벽걸이 materials 23행 전부 USAGE.07 실측). round-11 "USAGE.01 본체" 인용은 **오류** → USAGE.07 공통으로 정정. **[HARD]** 삼각대·링은 **현재 자재로 오적재돼 있으나 정답은 공정**([CAL-BOM-002]·[CAL-ST-DEF-001/002]) — 본 블록의 자재 슬롯은 본체 종이·우드거치대(자재)만 정당.
- 앵커: `t_prd_product_materials.usage_cd`(USAGE.07) · `t_mat_materials.mat_typ_cd`
- 출처: `16_mapping-research/calendar/mapping-final.md` §0·§A C15(라이브 USAGE.07 정정) + `15_domain-spec/calendar/product-bom.md` "BOM 횡단" {tier C(round-12), FRESH·라이브 23행 USAGE.07 실측}
- 연결: [[../huni/materials#MAT-001]] (uses — 자재 마스터·usage 구조) · [[../huni/materials#MAT-002]] (uses — parent+usage_cd) · [[../huni/materials#MAT-005]] (.07~10 자재 오염 — 삼각대/링=부속 오적재) · [[#CAL-BOM-002]]
- answers_cq: CQ-PROD-05 (상품별 자재 축) · CQ-TERM-04 (소재 약어)
- tags: #캘린더 #자재 #USAGE07공통 #별도설정

### [CAL-BOM-002] 공정 = 캘린더가공(거치/제본) + 포장 (삼각대/트윈링/타공)  {🟡}
- 내용: 캘린더 공정 = **캘린더가공**(거치/제본 = form factor 완성)·**포장**. **삼각대 거치**(탁상/미니) = 공정(현 라이브엔 공정행 부재 → mint 필요 [CAL-ST-DEF-007])·**고리형트윈링제본 PROC_000021**(벽걸이/와이드·링칼라 param)·**타공 PROC_000079**(엽서/벽걸이·끈 부속)·**수축포장 PROC_000076**. 공정 레시피 = `출력(디지털) → 재단 → (캘린더가공: 삼각대/타공/트윈링) → (포장) → (추가상품 동봉)`. **거치/제본 = 공정**(생산방식 Case·schema-intent §3 #6/#7) — 라이브가 삼각대/링을 자재로 둔 것은 정체-기반 오적재.
- 앵커: `t_proc_processes`(PROC_000021 트윈링·PROC_000079 타공·PROC_000076 포장·삼각대거치=마스터 부재) · `t_prd_product_processes`(mand_proc_yn)
- 출처: `15_domain-spec/calendar/product-bom.md` §1~§5·"BOM 횡단" + `16_mapping-research/calendar/mapping-final.md` §A C19 + `correction-manifest.md` OK-7(트윈링/타공 CORRECT) {tier C, FRESH·라이브 PROC 실측·삼각대 검색 0행}
- 연결: [[../huni/processes#PRC-001]] (uses — 공정 마스터·mand_proc_yn 배타) · [[../base/binding#BBD-005]] (uses — 트윈링/스프링 제본 보편) · [[../base/finishing#BFN-005]] (uses — 타공 보편) · [[#CAL-CPQ-001]] (캘린더가공 택일그룹)
- answers_cq: CQ-FIN-01 (후가공 공정 목록) · CQ-PROC-01 (공정 적재 기준)
- tags: #캘린더 #공정 #삼각대거치 #트윈링제본 #타공

### [CAL-BOM-003] 링칼라·삼각대컬러 = 공정 param (조건부 캐스케이드)  {🟡}
- 내용: 캘린더 색/컬러 선택은 **자재가 아니라 공정 param**. **삼각대컬러**(그레이/블랙) = 삼각대거치 공정 `prcs_dtl_opt` param(탁상/미니). **링칼라**(블랙) = 고리형트윈링제본 공정 param + **★조건부**(고리형트윈링제본 선택시만 노출, 엑셀 `★고리형트윈링제본선택시만:링칼라선택`). 평면화 금지 — 캐스케이드 제약(constraints.logic, [[../huni/cpq-options#CPQ-STALE]] constraint_json은 삭제됨).
- 앵커: `t_prd_product_processes.prcs_dtl_opt`(삼각대컬러·링칼라) · `t_prd_product_constraints.logic`(조건부)
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C18·C21(★조건부 엑셀 명시) + `15_domain-spec/calendar/product-bom.md` "조건부 캐스케이드" {tier C, FRESH·constraint_json 컬럼 존재 실측}
- 연결: [[../huni/processes#PRC-003]] (uses — 별색=공정 동형: 색 선택=공정 param) · [[../huni/cpq-options#CPQ-007]] (requires — 캐스케이드 constraints.logic) · [[../huni/cpq-options#CPQ-STALE]] (constraint_json 삭제 — logic 단일경로)
- answers_cq: CQ-FIN-10 (옵션=자재+공정) · CQ-PROC-01
- tags: #캘린더 #공정param #링칼라 #삼각대컬러 #조건부

---

## 3. 가격 사슬 (price chain) — 캘린더 + 디자인캘린더
앵커: `t_prc_*` 4단(`t_prd_product_price_formulas`→components→component_prices) · `t_prd_product_prices`(고정가)

### [CAL-PRC-001] 캘린더(업로드) = 원자합산형 공식엔진 (디지털인쇄 계열 · 미연결)  {🔴 미적재}
- 내용: 캘린더(업로드판)는 **원자합산형 공식엔진** — 폴더=디지털인쇄 라우팅이라 디지털인쇄 가격엔진 계열(PRF_DGP_A~F + COMP_PAPER)에 form factor를 바인딩하는 모델. **라이브 현재값 = `t_prd_product_price_formulas`·`t_prc_*` 캘린더 5상품 0행**(가격엔진 미연결) → 정답 = 디지털 공식 바인딩 + 장수·가공 옵션가 합산(round-2 가격 트랙·인간 승인). 디지털인쇄 잔존 차단(3절/투명/박/048)과 별개로 캘린더는 아직 가격사슬 부재.
- 앵커: `t_prd_product_price_formulas`(캘린더 5상품 0행 — 미바인딩) · `t_prc_*` 4단
- 출처: `16_mapping-research/calendar/mapping-final.md` §C(캘린더 가격 차단 확인)·라이브 0행 + 메모리 `dbmap-digitalprint-atomic-formula-unbuilt` {tier C(round-12), FRESH·라이브 0행 재현}
- 연결: [[../huni/price-engine#PE-005]] (priced-by — 원자합산형 PRF_DGP) · [[../huni/price-engine#PE-001]] (uses — t_prc 4단) · [[../huni/price-engine#PE-GAP-3]] (가격사슬 부재 family — 캘린더 포함) · [[#CAL-DIM-002]] (uses — 장수×공식)
- answers_cq: CQ-PRICE-08 (견적 합산 공식) · CQ-PRICE-01 (단가표 vs 공식)
- tags: #캘린더 #가격 #원자합산형 #디지털인쇄계열 #미적재

### [CAL-PRC-002] 캘린더가공 추가가격 = 옵션 가격 (앱/L2)  {🟡}
- 내용: 캘린더가공별 추가가격(가공없음 0·1구타공+끈 1000·2구타공+끈 1500·고리형트윈링제본 2000·우드거치대 4000)은 **CPQ 옵션 가격**(round-6 L2). 본체 가격공식과 합산. 라이브 현재값 = option_* 0행(미적재). page_rule·자재가에 넣지 말 것 — 옵션 추가가로 적재.
- 앵커: `t_prd_product_options`/option price(L2 옵션 가격)
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C20·Q12 + `15_domain-spec/calendar/product-bom.md` "BOM 횡단" {tier C, FRESH·option_* 0행 실측}
- 연결: [[#CAL-CPQ-001]] (uses — 캘린더가공 택일그룹) · [[../huni/price-engine#PE-007]] (priced-by — 옵션 격자 추가가)
- answers_cq: CQ-PRICE-06 (후가공/옵션 가산 단가)
- tags: #캘린더 #옵션가격 #가공추가가 #L2

### [CAL-DC-001] 디자인캘린더 = 고정가형 직접단가 (캘린더 공식엔진과 대비)  {🔴 미적재}
- 내용: 디자인캘린더(가격포함)는 **고정가형 직접단가** — 디자인 확정(에디터 페이지 고정)이라 **사이즈/페이지별 기본가 4000~24000**(`t_prd_product_prices`). 업로드판 캘린더(=원자합산형 공식엔진)와 **대비**되는 가격 모델(★Q15 확정). **라이브 현재값 = prices 0행(전역 미적재)** → 정답 = 고정가 직접단가 적재(가격 트랙·인간 승인). 또한 디자인캘린더 surface는 `editor_yn=Y`여야([CAL-ST-DEF-010] 라이브 N → 정답 Y).
- 앵커: `t_prd_product_prices`(prd_cd·apply_ymd·price 고정가 — 라이브 0행)
- 출처: `16_mapping-research/calendar/mapping-final.md` §B B6·§B.1·§C(고정가형)·Q15 + `correction-manifest.md` C-DC-11 {tier C(round-12/13), FRESH·라이브 prices 0행 재현}
- 연결: [[../huni/price-engine#PE-007]] (priced-by — 고정가형 직접단가) · [[../huni/price-engine#PE-GAP-3]] (디자인캘린더 가격 미적재 명시) · [[#CAL-PRC-001]] (캘린더=공식엔진 대비) · [[#CAL-ST-DEF-010]] (editor_yn 교정)
- answers_cq: CQ-PRICE-01 (가격 공식 계산) · CQ-PRICE-07 (고정가 적용)
- tags: #디자인캘린더 #가격 #고정가형 #직접단가 #Q15

---

## 4. CPQ 옵션 레이어 — 캘린더
앵커: `t_prd_product_option_groups`/`options`/`option_items` · `constraints` · `templates`

### [CAL-CPQ-001] 캘린더가공 택일그룹 = GRP-CAL-가공 (option_groups 흡수 · 라이브 0행)  {🔴 미적재}
- 내용: 캘린더가공은 **택1 옵션그룹**(GRP-CAL-가공, SEL_TYPE.01 단일·mand_yn=Y) 6 멤버(가공없음·우드거치대·1구타공+끈·2구타공+끈·고리형트윈링제본·제본없음). **라이브 현재값 = option_groups 캘린더 0행**(processes만 적재)·전역 6행(PRD_000001/002/066/138만) → 정답 = GRP-CAL-가공 흡수 적재(round-6 L2). **[HARD] 공정택일 구조는 라이브 부존재 excl_groups가 아니라 option_groups로 흡수**(Phase11 `t_prd_product_process_excl_groups` 삭제 — [[../huni/processes#PRC-GAP-5]]). 장수([CAL-DIM-002])도 옵션그룹(택1)으로 적재. 캐스케이드(링칼라 조건부)는 constraints.logic.
- 앵커: `t_prd_product_option_groups`(GRP-CAL-가공·SEL_TYPE.01·라이브 캘린더 0행) → `options`/`option_items`
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C19(option_groups 흡수)·§D + `15_domain-spec/calendar/product-bom.md` "캘린더가공 택일그룹" + `correction-manifest.md` C-CAL-06 + `_gate/calendar-gate.md` F-GATE-CAL-1(excl_groups Phase11 삭제 실측) {tier C(round-12/13), FRESH·라이브 0행·excl 테이블 부재 재현}
- 연결: [[../huni/cpq-options#CPQ-001]] (uses — CPQ 7테이블 L2) · [[../huni/cpq-options#CPQ-002]] (uses — polymorphic ref_dim_cd) · [[../huni/processes#PRC-GAP-5]] (excl_groups 삭제 → option_groups 흡수) · [[../huni/cpq-options#CPQ-008]] (CPQ 전면 미적재 silsa 파일럿만) · [[../huni/cpq-options#CPQ-GAP-1]] (BATCH-6 일괄 적재 미결)
- answers_cq: CQ-PROD-05 (선택 옵션 축·캐스케이드)
- tags: #캘린더 #CPQ #택일그룹 #GRP-CAL-가공 #excl흡수

### [CAL-CPQ-002] 봉투 addon = 캘린더봉투 template (★사이즈선택 캐스케이드 · 라이브 0행)  {🔴 미적재}
- 내용: 캘린더봉투(PRD_000005 별 상품)는 **추가상품 template**(base_prd=PRD_000005)로 캘린더에 연결 — **★사이즈선택 캐스케이드**(캘린더 size 종속). **라이브 현재값 = addons 캘린더 0행**·캘린더봉투 template 0행 → 정답 = template mint + `t_prd_product_addons`(prd_cd·tmpl_cd) 연결 + ★사이즈선택 constraints. **[주의]** 라이브 `t_prd_product_addons` 컬럼 = `tmpl_cd`(`addon_prd_cd` 아님·Phase7 drift) — load_master의 `addon_prd_cd` INSERT는 현 스키마와 불일치([CAL-ST-DEF-008]).
- 앵커: `t_prd_product_addons`(tmpl_cd·라이브 캘린더 0행) · `t_prd_templates`(봉투 base_prd=PRD_000005)
- 출처: `16_mapping-research/calendar/mapping-final.md` §A C26·§D + `correction-manifest.md` C-CAL-08 + `_gate/calendar-gate.md` K4(addons tmpl_cd 컬럼 실측) {tier C(round-12/13), FRESH·라이브 0행·컬럼 drift 재현}
- 연결: [[../huni/cpq-options#CPQ-006]] (uses — OTC template 묶음) · [[../huni/cpq-options#CPQ-007]] (requires — ★사이즈선택 캐스케이드) · [[#CAL-ID-004]] (봉투=별 상품) · [[#CAL-ST-DEF-008]] (addon 컬럼 drift)
- answers_cq: CQ-PROD-11 (묶음/추가상품 단위) · CQ-SUB-01
- tags: #캘린더 #CPQ #봉투addon #template #사이즈선택

---

## 5. 위젯 계약 (widget contract) — 캘린더
앵커: 정규화 계약(`huni-widget/03_spec/`) — DB 외 앵커임을 명시

### [CAL-WID-001] 캘린더 위젯 = family 전용 스펙 존재 (장수·가공 택일·2채널)  {⚪ 명세}
- 내용: 캘린더는 **family 전용 위젯 스펙이 존재**한다(아크릴·굿즈파우치와 함께). 캘린더 위젯은 정규화 계약 + 후니 어댑터로 도출(위젯 코어 불변) — **장수(낱장 매수)** 선택·**캘린더가공 택1**(삼각대/트윈링/타공)·**링칼라 조건부 캐스케이드**·**2채널**(업로드 file_upload / 디자인 editor)을 componentType 매핑으로 표현. 가격은 서버 권위(PRICE=0 불가 신호). Edicus 에디터 연동은 디자인캘린더 surface(editor_yn=Y).
- 앵커: DB 외 — `huni-widget/03_spec/s6-calendar-spec.md`(family 스펙) · `data-contract.md` · 어댑터 경계
- 출처: `huni-widget/03_spec/s6-calendar-spec.md` + `data-contract.md` + [[../huni/widget-contract#WID-GAP-3]](family 스펙 존재분) {tier D, FRESH}
- 연결: [[../huni/widget-contract#WID-001]] (mapped-to — 정규화 계약) · [[../huni/widget-contract#WID-003]] (mapped-to — 14 componentType) · [[../huni/widget-contract#WID-004]] (uses — 옵션 캐스케이드·Edicus 브리지) · [[../huni/widget-contract#WID-005]] (priced-by — 서버 가격권위)
- answers_cq: CQ-PROD-08 (상품-카테고리 UI 노출) · CQ-PRICE-01 (가격 권위=서버)
- tags: #캘린더 #위젯 #family스펙 #2채널 #장수

---

## 6. 적재 레시피 (load path) — 캘린더
앵커: `raw/webadmin/sql/*`·`tools/load_master.py` · round-8 `13_admin-ui-spec/`

### [CAL-LP-001] 캘린더 적재 = load_master 10_상품정보 + relation 시트 (순수 전파기)  {🟡}
- 내용: 캘린더는 `load_master.py` `run_all()` 단일 트랜잭션으로 적재 — 10_상품정보(5 form factor identity 보존, L250-275) + relation 시트(11 카테고리 L282·13 사이즈 L307·14 자재[usage USAGE.07 L324]·15 공정[mand_proc_yn L404]·16 인쇄옵션 L352·17 판형 L336·20 추가상품 L436·21 페이지룰 L447). **[HARD] load_master는 순수 전파기** — 입력 v03 xlsx 인용 금지(진원=상류 v03 정규화·정답=상품마스터 L1 `calendar-l1.csv`). 멱등=이름 기반 UPSERT·search-before-mint(삼각대거치 공정·우드거치대 자재·봉투 template).
- 앵커: `raw/webadmin/tools/load_master.py`(L250~456 함수군, 로직만) · `13_admin-ui-spec/`
- 출처: `17_correctness/calendar/loadlogic-notes.md` §1(테이블↔함수 매핑 file:line) + `_gate/calendar-gate.md` K2(L261/L324/L338/L346 직접 Read 검증) {tier A/C, FRESH(HEAD)·로직만 oracle}
- 연결: [[../huni/load-path#LP-001]] (loaded-via — 적재 oracle) · [[../huni/load-path#LP-003]] (uses — FK 위상순서) · [[../huni/load-path#LP-004]] (uses — 멱등 search-before-mint) · [[../huni/load-path#LP-STALE]] (v03 입력 금지)
- answers_cq: CQ-PROD-01 (상품 적재 기준) · CQ-FILE-01 (운영자 입력경로)
- tags: #캘린더 #적재 #load_master #v03전파기 #USAGE07

### [CAL-LP-002] 적재 경로 drift = load_master ↔ 라이브 스키마 단절 (F-1·F-3·F-4)  {🔴 교정대기}
- 내용: 캘린더 적재 경로는 라이브 스키마(round-14 Phase7/11)와 **drift**해 무손실 재적재 불가 상태(전부 진원=상류 v03/스키마 변경, load_master 코드 결함과 별개). **F-1** plate output_paper_typ: 코드는 `.03 기타`만 산출(L338,346)인데 라이브는 `.01 국전계열` 실재 → 재적재 시 .01→.03 **퇴행 위험**([CAL-ST-DEF-004]). **F-3** addon: load_master `addon_prd_cd` INSERT(L440)인데 라이브 컬럼=`tmpl_cd`(Phase7) → addon 적재 불가. **F-4** 캘린더가공 택일: `load_rel_excl_groups`(L390-401·L476)는 실재하나 타겟 `t_prd_product_process_excl_groups`가 Phase11 삭제 → `--all` 재실행 시 TRUNCATE에서 실패 + CPQ option 로더 자체는 부재 → 장수·택일그룹 MISSING. 교정 = 코드 정합화 + 상품마스터 L1 권위 델타(round-5/6 + 인간 승인).
- 앵커: `raw/webadmin/tools/load_master.py`(L338/L346 plate·L440 addon·L390-401/L476 excl) · 정답 = `06_extract/calendar-l1.csv`
- 출처: `17_correctness/calendar/loadlogic-notes.md` §2(F-1~F-5 file:line) + `_gate/calendar-gate.md` F-GATE-CAL-1(excl 로더 정밀화) {tier A/C, FRESH·라이브 컬럼/테이블 부재 독립 확인}
- 연결: [[../huni/load-path#LP-STALE]] (v03 진원·constraint_json/dep_proc_cd drift) · [[../huni/processes#PRC-GAP-5]] (excl_groups 삭제) · [[#CAL-ST-DEF-004]] (plate 퇴행)
- answers_cq: CQ-PROD-01 (적재 기준) · CQ-FILE-01
- tags: #캘린더 #적재결함 #drift #plate퇴행 #excl삭제

---

## 7. 현황·결함 (state) — 캘린더 + 디자인캘린더

### 적재 현황
- **GO분 적재됨:** 캘린더 5 form factor(PRD_000108~112)·카테고리(고아 0)·사이즈(이산 variant)·자재(본체 종이 USAGE.07 + 부속)·인쇄옵션(단/양면·CLR)·출력판형(.01/.03 값)·공정(트윈링 PROC_000021·타공 079·포장 076)이 라이브 적재됨([[../huni/load-path#LP-007]]). round-13 게이트 = **GO**(`_gate/calendar-gate.md` K0~K6 PASS·보정권고 1 비차단).
- **미적재/MISSING:** 장수(낱장 매수)·캘린더가공 택일그룹(GRP-CAL-가공)·삼각대거치 공정·봉투 addon·우드거치대 자재·디자인캘린더 고정가(prices 0행)·MES_ITEM_CD(NULL). option_groups 캘린더 0행·page_rules 0행(낱장이라 정상)·prices 0행.
- **오적재(교정대기):** 삼각대/링이 자재(MAT_TYPE.07 부속)로 적재(정답=공정)·탁상/미니 링 잉여(EXTRA)·plate 적재경로 drift.

### [CAL-ST-DEF-001] 라이브 오적재 양면 표기 (round-13 correction-manifest)  {🔴 교정대기}
- 내용: round-13이 확정한 캘린더 라이브 오적재. 라이브값을 사실로 단정 금지 — correction-manifest 대조 필수. 삼각대/링 자재(C-CAL-01/02/03)는 [[../huni/materials#MAT-005]] .07~10 자재 오염과 연결(정답=공정 [CAL-BOM-002]).

| 항목 | 라이브 현재값 | 정답 | 분류·심각도 | 출처 |
|---|---|---|---|---|
| **C-CAL-01** 삼각대 자재(108/109) | MAT_000252/254 삼각대 mat_typ_cd=MAT_TYPE.07 부속·usage USAGE.07·dflt Y | 삼각대 거치=**공정**(`t_prd_product_processes` + 삼각대컬러 param)·자재행 논리삭제 | MIS-LOADED·**High** | correction-manifest.md C-CAL-01 |
| **C-CAL-02** 링 자재(111/112) | MAT_000253 링 블랙 MAT_TYPE.07·usage USAGE.07 | 링칼라=트윈링제본(PROC_000021) **공정 param**·자재행 논리삭제 | MIS-LOADED·High | correction-manifest.md C-CAL-02 |
| **C-CAL-03** 링 잉여(108/109) | 탁상/미니에 MAT_000253 링 블랙 연결 | 탁상/미니=삼각대 거치(트윈링 없음) → 링 부착 자체 오류·논리삭제(use_yn=N) | EXTRA·Medium | correction-manifest.md C-CAL-03 |
| **C-CAL-04** plate 적재경로 | output_paper_typ_cd .01/.03(**값 정답**) | 값 유지·load_master 치수→계열 매핑 추가(재적재 .01→.03 퇴행 방지) | MIS-LOADED(경로)·Medium | correction-manifest.md C-CAL-04 / loadlogic F-1 |
| **C-CAL-05** 장수(전 5상품) | page_rules 0·option 0 | CPQ option(택1) + 가격공식(page_rule 아님) | MISSING·High | correction-manifest.md C-CAL-05 |
| **C-CAL-06** 캘린더가공 택일 | option_groups 0(processes만) | GRP-CAL-가공(SEL_TYPE.01·mand Y) 6멤버 택일 + 가공별 추가가 | MISSING·High | correction-manifest.md C-CAL-06 |
| **C-CAL-07** 삼각대거치 공정(108/109) | proc=수축포장만(거치 없음) | 삼각대 거치 공정 mint + 삼각대컬러 param(마스터 검색 0행) | MISSING·High | correction-manifest.md C-CAL-07 |
| **C-CAL-08** 봉투 addon | addons 캘린더 0·봉투 template 0 | 캘린더봉투(PRD_000005) template + addon(tmpl_cd) + ★사이즈선택 | MISSING·Medium | correction-manifest.md C-CAL-08 |
| **C-CAL-09** 우드거치대(110/디자인) | 미적재 | **자재**(Q13·search-before-mint 기존 MAT 우선) | MISSING·Medium | correction-manifest.md C-CAL-09 |
| **C-DC-10** editor_yn(디자인 5) | editor_yn=N | editor_yn=Y(디자인=에디터 surface·file_upload_yn=Y 유지 2채널) | MISSING(MISMATCH)·Medium | correction-manifest.md C-DC-10 |
| **C-DC-11** 디자인 고정가 | prices 0(전역) | 고정가형 직접단가 4000~24000(사이즈/페이지별) | MISSING·High | correction-manifest.md C-DC-11 |
| **C-DC-12** 디자인 종이 명시 | 캘린더판 `*별도설정`(IMPORT) / 디자인판 `몽블랑190g` 명시 | 두 surface 종이 확정도 다름 — 자재 권위 컨펌(CL-E) | AMBIGUOUS·Low | correction-manifest.md C-DC-12 |
| **C-CAL-13** MES_ITEM_CD | NULL(전 5상품) | 007-0001~5(중복 없음 → 채울 수 있음) | MISSING·Low | correction-manifest.md C-CAL-13 |
| **C-CAL-14** 미니 카테고리(109) | CAT_000112(탁상형캘린더) | CAT_000113(미니탁상형 전용 노드 존재·미연결) vs 엑셀 구분 유지 | AMBIGUOUS·Low | correction-manifest.md C-CAL-14 |

- 출처: `17_correctness/calendar/correction-manifest.md` §1 분류표 + `_gate/calendar-gate.md`(GO·K4 독립 SELECT 재현·14항 일치) {tier C(round-13), FRESH}
- 연결: [[../huni/materials#MAT-005]] (삼각대/링=부속 자재 오염) · [[../huni/processes#PRC-GAP-2]] (삼각대거치 신규 공정 신설) · [[#CAL-LP-002]] (v03 진원·drift)
- tags: #캘린더 #결함 #교정대기 #round13

### [CAL-ST-DEF-004] plate 적재경로 퇴행 (.01↔.03 · load_master 코드 .03만)  {🔴 교정대기}
- 내용: 캘린더 plate output_paper_typ 값(.01 국전계열·.03 기타)은 **도메인 정답**이나, load_master `load_rel_plate_sizes`(L338,346)는 **전부 `.03 기타`만 산출**(`.01 국전계열` 분기 자체가 코드에 없음). 라이브 .01은 이전 plate 교정(국4절 32상품·c722c24) 또는 별도 SQL의 산물 → **현 `--all` 재적재 시 .01→.03 퇴행**. 교정 = load_master에 치수→계열 매핑(316x467→.01·330x660→.03) 추가(값 무수정·코드만 정합). 라이브 값 인용 시 **현 라이브 .01은 코드로 재현 불가**임을 명기.
- 앵커: `load_master.py` `load_rel_plate_sizes`(L338,346) · `t_prd_product_plate_sizes.output_paper_typ_cd`(라이브 .01=32·.03=33·NULL=359)
- 출처: `17_correctness/calendar/loadlogic-notes.md` F-1(코드 직접 Read) + `_gate/calendar-gate.md` K2(L338/L346 검증)·K4(전역 분포 재현) + 메모리 `dbmap-platesize-is-output-paper` {tier A/C(round-13), FRESH·코드↔라이브 충돌 입증}
- 연결: [[#CAL-DIM-003]] (출력판형 계열코드) · [[../huni/load-path#LP-004]] (멱등 — 재적재 퇴행 위험) · [[#CAL-LP-002]]
- tags: #캘린더 #plate퇴행 #계열코드 #BATCH-10

### [CAL-ST-DEF-007] 삼각대거치 공정 마스터 부재 (mint 필요 · search-before-mint)  {🔴 교정대기}
- 내용: 삼각대 거치(탁상/미니 form factor 완성 공정)는 **`t_proc_processes`에 마스터 부재**(삼각대/거치 검색 0행 독립 재현). 트윈링제본(PROC_000021)·타공(079)·포장(075/076)은 실재하나 거치 공정만 없음 → **신규 공정 mint 필요**(search-before-mint 입증 완료). 미싱제본·보드마운팅과 함께 신규 공정 신설 미결([[../huni/processes#PRC-GAP-2]]).
- 앵커: `t_proc_processes`(삼각대거치 = 부재) · `t_prd_product_processes`(연결 대상)
- 출처: `17_correctness/calendar/correction-manifest.md` C-CAL-07 + `_gate/calendar-gate.md` K4(공정 마스터 검색 0행 재현)·K5(search-before-mint 입증) {tier C(round-13), FRESH}
- 연결: [[../huni/processes#PRC-GAP-2]] (신규 공정 신설 미결 — 삼각대거치 포함) · [[../huni/processes#PRC-001]] · [[#CAL-BOM-002]]
- tags: #캘린더 #삼각대거치 #공정mint #search-before-mint

### [CAL-ST-DEF-008] addon 컬럼 drift (load_master addon_prd_cd ↔ 라이브 tmpl_cd)  {🔴 교정대기}
- 내용: `t_prd_product_addons` 라이브 컬럼 = **`tmpl_cd`**(Phase7 전환)인데 load_master는 **`addon_prd_cd`로 INSERT**(L440) → 현 코드는 addon 적재 불가(스키마 drift). 캘린더봉투/우드거치대 addon 적재 = template 기반(tmpl_cd)으로 정합화 필요([CAL-CPQ-002]).
- 앵커: `t_prd_product_addons`(라이브 tmpl_cd) · `load_master.py`(L440 addon_prd_cd)
- 출처: `17_correctness/calendar/loadlogic-notes.md` F-3 + `_gate/calendar-gate.md` K4(addons 컬럼=tmpl_cd 실측) {tier A/C(round-13), FRESH·라이브 컬럼 확인}
- 연결: [[#CAL-CPQ-002]] (봉투 template) · [[../huni/load-path#LP-STALE]] (스키마 drift)
- tags: #캘린더 #addon #drift #tmpl_cd #Phase7

### [CAL-ST-DEF-010] 디자인캘린더 editor_yn 교정 (라이브 N → 정답 Y)  {🔴 교정대기}
- 내용: 디자인캘린더 surface는 에디터 채널이므로 **editor_yn=Y**여야 하나 라이브는 **N**(캘린더 업로드 surface만 반영). 정답 = 5상품 editor_yn=Y로 UPDATE(file_upload_yn=Y 유지 → 2채널). 같은 prd_cd 두 surface 정합([CAL-ID-002]).
- 앵커: `t_prd_products.editor_yn`(라이브 N → 정답 Y) · `file_upload_yn`(Y 유지)
- 출처: `17_correctness/calendar/correction-manifest.md` C-DC-10 {tier C(round-13), FRESH}
- 연결: [[#CAL-ID-002]] (디자인캘린더=같은 상품 surface) · [[#CAL-DC-001]] (디자인 가격)
- tags: #디자인캘린더 #editor_yn #2채널 #교정대기

### [CAL-ST-DEF-013] 컨펌 미결 (CL-A~G)  {🔴 미결}
- 내용: 캘린더 인간 결정 대기 7건 — **CL-A**(삼각대 거치 신규 공정 mint+자재 논리삭제 vs 부속 자재 유지)·**CL-B**(트윈링 링 param 전환+자재 논리삭제·탁상/미니 링 EXTRA 논리삭제 확정?)·**CL-C**(plate .01 적재경로 정합화=load_master 치수→계열 매핑 추가 동의?)·**CL-D**(장수 SEL_TYPE 택1/자유선택·가격공식 합산 방식)·**CL-E**(디자인캘린더 종이 권위=명시 몽블랑190g vs `*별도설정`)·**CL-F**(미니 109 카테고리 CAT_000113 재연결 vs CAT_000112 유지)·**CL-G**(MES_ITEM_CD 007-0001~5 채움). 횡단 결정 = BATCH-2/13(삼각대/링 자재 분리)·BATCH-10(plate 적재경로)·BATCH-6(size↔option·CPQ 일괄 적재)·BATCH-12(v03 상류 vs DB 직접).
- 출처: `17_correctness/calendar/correction-manifest.md` §3(CL-A~G) {tier C(round-13), FRESH}
- 연결: [[../huni/processes#PRC-GAP-2]] (CL-A 삼각대거치) · [[../huni/load-path#LP-GAP-1]] (BATCH-12 v03 상류) · [[../huni/cpq-options#CPQ-GAP-1]] (BATCH-6 CPQ 일괄)
- tags: #캘린더 #컨펌미결 #CL #BATCH

### GAP (이 family 고유)
- **[GAP-CAL-1]** 삼각대/링 자재 분리 + 삼각대거치 신규 공정(CL-A·BATCH-2/13) — [[../huni/processes#PRC-GAP-2]].
- **[GAP-CAL-2]** plate .01↔.03 적재경로 정정(CL-C·BATCH-10) — [[#CAL-ST-DEF-004]].
- **[GAP-CAL-3]** 장수·캘린더가공 택일그룹·봉투/우드/디자인가격 CPQ·가격 일괄 적재(BATCH-6) — [[../huni/cpq-options#CPQ-GAP-1]].
- **[GAP-CAL-4]** 미니 109 카테고리 CAT_000113 재연결 미결(CL-F·AMBIGUOUS) — [[#CAL-ST-DEF-001]].

---

## Sources
- 큐레이션 팩: `_curation/pack-calendar.md`(calendar + design-calendar 통합).
- 정체/결함(C13, FRESH): `17_correctness/calendar/product-identity.md`·`correction-manifest.md`·`loadlogic-notes.md`·`live-diff.md`·`extraction-plan.md` + `_gate/calendar-gate.md`(GO·보정권고 1 비차단).
- 차원/BOM(C11): `15_domain-spec/calendar/product-bom.md`·`column-dictionary.md`·`mapping-info.md`·`domain-research-notes.md`.
- 매핑확정(C12): `16_mapping-research/calendar/mapping-final.md`(§A 캘린더·§B 디자인캘린더·§C 가격모델·§D FK위상)·`live-crosscheck.md`·`research-gap-board.md`.
- 가격(B/C): `02_mapping/price211-booklet-photobook/`(제본·캘린더)·`06_extract/price-binding-l1.csv`·`calendar-l1.csv`·`design-calendar-l1.csv`. **price-engine-ddl.md 인용 0(STALE).**
- 위젯(D): `huni-widget/03_spec/s6-calendar-spec.md`·`data-contract.md`·`editor-integration.md`.
- 적재(A): `raw/webadmin/sql/`·`tools/load_master.py`(로직만·L250~456).
- 메모리: `dbmap-correctness-audit-round13`·`dbmap-mapping-research-round12`·`dbmap-platesize-is-output-paper`·`dbmap-digitalprint-atomic-formula-unbuilt`·`dbmap-process-select-group-domain`·`dbmap-schema-change-round14`.
- **STALE/v03 (인용 금지):** `00_schema/price-engine-ddl.md`([[../huni/price-engine#PE-STALE]]); v03 입력 xlsx([[../huni/load-path#LP-STALE]]); excl_groups 적재 타깃 `t_prd_product_process_excl_groups`(Phase11 삭제·[[../huni/processes#PRC-GAP-5]]); constraint_json/dep_proc_cd 적재 타깃([[../huni/cpq-options#CPQ-STALE]]); 라이브 오적재값 직접 단정(correction-manifest 미대조 시 — G-1·F-PB-1 교훈); round-11 "USAGE.01 본체"/"316x467 치수 코드값" 인용(라이브 정정으로 폐기).
