# 캘린더 — 적재 로직 재구성 + 발견된 적재 결함 (round-13 C1)

> **작성** round-13 `dbm-correctness-audit` Phase 1b. 적재 oracle = `raw/webadmin/sql/`(물리 스키마) + `raw/webadmin/tools/load_master.py`(엑셀→t_* 변환). `catalog/models.py`는 inspectdb 거울(적재로직 아님) — 미사용.
> **[HARD] v03 directive:** `load_master.py` line 39 `XLSX = "data/raw/prdmaster_full_migration_v03_20260518.xlsx"` — load_master는 **v03만 읽는 순수 전파기**다. v03는 사용자가 "미분석 오류 多"로 참조 금지한 파일. 따라서 **라이브 결함의 진원 = 상류 v03 정규화**이고, **정답 = 상품마스터 원본 L1**(`calendar-l1.csv`). 본 문서는 load_master 코드 사실만 인용하고 v03 내용은 참조하지 않는다.

---

## 1. load_master.py가 캘린더 칼럼을 t_*로 변환한 규칙 (재구성)

load_master는 **마스터 시트(01~10) → surrogate 발급 → 관계 시트(11~21) FK 치환**의 단일 트랜잭션이다(line 461~481). 캘린더 상품(PRD_000108~112)은 시트10에서 identity 보존(line 252), 하위는 관계 시트에서 전파된다.

| 캘린더 속성 | v03 원천 시트 | load_master 함수·라인 | t_* 적재 규칙 | 라이브 결과 |
|------------|---------------|----------------------|---------------|-------------|
| 상품(form factor 5) | 10_상품정보 | `load_products` L250-275 | prd_cd identity 보존·**MES_ITEM_CD=None 강제**(L261)·qty_unit_typ_cd=None(L269) | PRD_000108~112·MES NULL·qty_unit NULL |
| MES_ITEM_CD | (10시트 컬럼) | L261 `None` 하드코딩 | **전량 NULL**(중복 UNIQUE 위반 회피, 사용자 결정 2026-06-03) | 5상품 전부 NULL |
| 카테고리 연결 | 11_상품별카테고리 | `load_rel_categories` L282-291 | prd_cd+cat_cd FK 치환 | 108/109→CAT_000112·110→114·111/112→115 |
| 사이즈 | 13_상품별사이즈 | `load_rel_sizes` L307-315 | siz_cd FK 치환 | 탁상2·미니2·엽서6·벽걸이3·와이드1 |
| 자재 | 14_상품별자재 | `load_rel_materials` L318-333 | mat_cd FK 치환·**usage 빈값→USAGE.공통**(L324) | 본체 종이+삼각대+링 전부 usage=USAGE.07 |
| 인쇄옵션(도수) | 16_상품별인쇄옵션 | `load_rel_print_options` L352-382 | 앞/뒷면 도수코드→CLR FK·print_side 자유텍스트(L374) | 단/양면·CLR_000005(4도)/CLR_000001(0도) |
| 출력판형 | 17_상품별판형사이즈 | `load_rel_plate_sizes` L336-349 | siz_cd FK·**output_paper_typ_cd = OUTPUT_PAPER_TYPE.기타(L338,346) if 원천≠NULL else NULL** | (충돌 — §2 결함 F-1) |
| 공정 | 15_상품별공정 | `load_rel_processes` L404-421 | proc_cd FK·**excl_grp_cd 18시트 검증**(L412)·mand_proc_yn | 트윈링021·타공079·포장076(전부 mand=N) |
| 추가상품(봉투) | 20_상품별추가상품 | `load_rel_addons` L436-444 | addon_prd_cd FK | (캘린더 0행 — §2 F-3) |
| 장수 | 21_상품별페이지룰 | `load_rel_page_rules` L447-456 | page_min/max/incr | (캘린더 page_rules 0행 — §2 F-4) |

---

## 2. 발견된 적재 로직 결함 (file:line 근거)

### F-1 [CRITICAL·코드↔라이브 충돌] plate output_paper_typ_cd — load_master는 전부 `.기타`인데 라이브는 `.01/.03` 분화

- **적재 코드(`load_rel_plate_sizes` L338,346):**
  ```
  other = ENUM["OUTPUT_PAPER_TYPE"]["기타"]   # = OUTPUT_PAPER_TYPE.03
  ...
  other if _norm(r["출력용지유형코드"]) is not None else None,
  ```
  주석 L340: "출력용지유형코드는 용지 치수(316x467 등)로 들어옴 → 전부 OUTPUT_PAPER_TYPE.기타".
  → **이 코드를 그대로 돌리면 캘린더 plate는 전부 `.03 기타` 또는 NULL**이어야 한다.
- **라이브 실측(재현):** 탁상/미니/엽서/벽걸이 = `OUTPUT_PAPER_TYPE.01 국전계열`, 와이드 = `OUTPUT_PAPER_TYPE.03 기타`. 전역 분포 `.01=32·.03=33·NULL=359`.
- **모순:** 라이브의 `.01`은 **현재 load_master.py 코드가 만들 수 없는 값**이다(코드엔 `.국전계열` 분기 자체가 없음).
- **재구성 결론 = "적재 경로 불명"(finding):** 캘린더 plate의 `.01`은 ① load_master의 **이전 버전**(국4절 32상품 plate 교정 적재, 메모리 `dbmap-platesize-is-output-paper` "국4절 32상품 plate 실제 적재 완료 c722c24")로 들어왔거나 ② 별도 교정 SQL로 사후 UPDATE된 값이다. **현 load_master는 이 값을 재현하지 못함** → 다음 `--all` 재적재 시 `.01`이 `.03`로 **퇴행(regression)** 위험. **이 자체가 적재 로직 결함**(코드와 라이브 상태 불일치).
- **round-12 정정 정정:** round-12 live-crosscheck X-2가 "라이브 .01/.03 = 권위"라 했으나, round-13 관점에선 **라이브 .01이 어떻게 적재됐는지 코드로 설명 불가** = 위험 신호. 값 자체(국4절=국전계열·3절=기타)는 도메인상 옳음.

### F-2 [HIGH·정체-기반 오적재] 삼각대·링이 자재(MAT_TYPE.07 부속)로 적재 — 거치/제본 공정이어야

- **적재 경로:** `load_rel_materials`(14_상품별자재)로 들어옴. load_master는 14시트의 자재행을 그대로 전파(L318-333) — **삼각대/링이 v03 14시트에 자재로 들어 있음** = 진원은 상류 v03.
- **라이브 실측:** `MAT_000252 삼각대(그레이)`·`MAT_000254 삼각대(블랙)`·`MAT_000253 링 블랙` 모두 `mat_typ_cd=MAT_TYPE.07 부속`, `usage_cd=USAGE.07 공통`, `dflt_yn=Y`.
- **왜 결함:** 정답(상품 정체·bom.md §1·schema-intent §3 #6/#7)은 **삼각대 거치·트윈링 제본 = 공정**(생산방식 Case). 라이브엔 `PROC_000021 트윈링제본` 공정이 **별도로** 있는데(벽걸이/와이드), 링(자재)과 트윈링(공정)이 **이중 표현** = 옵션=자재+공정 BUNDLE 패턴(메모리)이면 정당하나, **삼각대는 공정 행이 없고 자재로만 존재**(탁상=PROC_000076 수축포장만) → 거치 공정 미모델·자재 단독 = 비대칭 오적재.
- **근본원인:** 상류 v03 14시트(자재)에 거치/제본 부속을 자재로 평면화. load_master는 전파만 했으므로 무죄(순수 전파기). 정답=L1(엑셀 캘린더가공 컬럼 C18~C21=공정/공정 param).

### F-3 [MEDIUM·미적재] 봉투/우드거치대 addon 전역 0행

- **적재 코드:** `load_rel_addons`(20_상품별추가상품) L436-444. 라이브 addons = PRD_000016 1행만(봉투 아님).
- **재구성:** v03 20시트에 캘린더봉투 addon 행이 없거나, addon 테이블 컬럼이 `addon_prd_cd`→`tmpl_cd`로 전환(round-14 Phase7)되며 load_master의 `addon_prd_cd` INSERT(L440)가 현 스키마와 불일치. **현 라이브 addons 컬럼=`tmpl_cd`**(information_schema 확인)인데 load_master는 `addon_prd_cd`로 INSERT → **현 load_master는 addon 적재 불가**(스키마 drift). = 적재 결함.
- 정답(엑셀 C26): 캘린더봉투(★사이즈선택)·우드거치대 = addon/자재 미적재.

### F-4 [MEDIUM·미적재] 장수(낱장 매수) 어디에도 적재 안 됨 + excl_groups 로더 Phase11 drift (정밀화: F-GATE-CAL-1)

- **적재 코드:** `load_rel_page_rules`(21_상품별페이지룰) L447-456 — page_rule만 적재. 캘린더 장수(C17 `4(8P)/8(16P)`)는 page_rule이 아님(Q12: 고객옵션+공식).
- **라이브:** page_rules 0행·option_groups 0·option_items 0 → 장수 **완전 미적재**.
- **재구성(정밀화 — 게이트 F-GATE-CAL-1):** 캘린더 장수·캘린더가공 택일을 담을 적재 경로가 두 갈래로 모두 결함이다. F-4 결론(장수·택일그룹=MISSING)은 유지하고 근거를 정밀화한다:
  - **(a) CPQ option 로더 부재(결론 정확):** load_master RELATIONS 리스트(L469-481)에 `t_prd_product_option_groups`/`options`/`option_items` 로더가 **없다**. 장수·캘린더가공(GRP-CAL-가공)을 적재할 CPQ option 레이어 적재 경로 자체가 부재 → 장수·택일그룹 MISSING.
  - **(b) excl_groups 로더는 실재하나 타겟 테이블이 Phase11에 삭제(중요·round-14 직결):** `load_rel_excl_groups` 함수가 **L390-401에 정의**되고 **L476 RELATIONS에 등록**돼 있다(이전 서술 "option 로더 전무"는 부정확 — 이 로더는 실재). 그러나 이 로더의 타겟 `t_prd_product_process_excl_groups`(L393 `TRUNCATE … CASCADE`·L395 INSERT)는 **Phase11에 삭제**됐다 — 라이브 독립 확인: `SELECT to_regclass('public.t_prd_product_process_excl_groups')` = **NULL**(테이블 부재), `t_prd_product_option_groups`만 존재(excl→option_groups 흡수). 즉 **현 `load_master.py --all` 재실행 시 L393 TRUNCATE에서 `relation "t_prd_product_process_excl_groups" does not exist`로 실패**한다.
- **함의:** F-1(plate 재적재 퇴행)·F-3(addon 컬럼 drift)과 동류로, load_master가 라이브 스키마(round-14 Phase11)와 **drift**해 무손실 재적재가 불가능한 상태. 캘린더가공 택일의 정답은 `t_prd_product_option_groups`(GRP-CAL-가공) 흡수인데, load_master는 여전히 삭제된 excl_groups 테이블을 적재하려 함 = 적재 경로가 정답 스키마와 단절. **round-14 Phase11 스키마 변경 추적과 직결**되는 사실.

### F-5 [LOW·정상이나 명기] MES_ITEM_CD 전량 NULL

- L261 의도적 None. 엑셀 C3 = 007-0001~5. 결함 아닌 **유보**(중복 UNIQUE 회피). 단 캘린더는 MES가 5상품 1:1(중복 없음)이라 채울 수 있음 → 교정 후보(업데이트).

---

## 3. 요약 — load_master는 순수 전파기, 진원은 상류 v03 + 스키마 drift

| 결함 | 분류 | 진원 | load_master 책임 |
|------|------|------|------------------|
| F-1 plate .01/.03 | 코드↔라이브 충돌(경로 불명) | 이전 적재/교정 SQL | 현 코드는 .01 재현 불가(퇴행 위험) |
| F-2 삼각대/링=자재 | 정체-기반 오적재 | **상류 v03 14시트** | 전파만(무죄) |
| F-3 addon 0행 | 미적재 + 스키마 drift | v03 20시트 + Phase7 컬럼 전환 | addon_prd_cd INSERT가 현 스키마와 불일치 |
| F-4 장수 미적재 + excl 로더 drift | 적재 경로 부재 + Phase11 drift | v03 + CPQ option 로더 부재 | CPQ option 로더 없음 + excl_groups 로더(L390-401·L476)는 있으나 타겟 테이블 Phase11 삭제 → `--all` 재실행 실패 |
| F-5 MES NULL | 의도적 유보 | L261 하드코딩 | 의도(결함 아님) |

> **[HARD] 핵심:** F-2(삼각대/링)의 진원은 상류 v03 정규화이지 load_master가 아니다. 정답은 v03 참조가 아니라 **상품마스터 L1**(`calendar-l1.csv` 캘린더가공 C18~C21=공정/공정 param). F-1은 load_master 코드와 라이브의 상태 불일치 자체가 결함(재적재 시 퇴행).
