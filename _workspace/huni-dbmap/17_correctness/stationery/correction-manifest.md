# 문구(stationery) — 교정 매니페스트 (correction-manifest · round-13 C4)

> **작성** 2026-06-11 · round-13. 각 diff를 CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS로 분류 + why(oracle 근거+적재로직 원인) + how(비파괴 교정) + 심각도 + 라우팅.
> **[HARD] 비파괴:** 교정은 제안까지. COMMIT/DDL/DELETE 없음. EXTRA/REMOVED=논리삭제(use_yn/del_yn). search-before-mint(기존 행 재사용 우선).
> **[HARD] v03·라이브=피고.** 정답=상품 정체 > 상품마스터 원본 L1 > 스키마 의도(sql/) > 도메인(round-11).
> **라우팅:** 교정직접(단순 연결행) / ddl-proposer(스키마 부족) / load-execution(적재 실행) / 컨펌(인간 결정).

---

## 1. 분류표 (빈칸 0)

| ID | 상품 | 속성 | 분류 | 라이브 현재값 | 정답값 | why (oracle 근거 + 적재로직 원인) | how (비파괴 교정) | 심각도 | 라우팅 |
|----|------|------|------|---------------|--------|-----------------------------------|-------------------|:--:|------|
| **ST-01** | PRD_000172~176 (플래너 5) | 카테고리 | MIS-LOADED | CAT_000300 플래너(upr=NULL·lvl3 고아) | **커버타입 의미 매칭(노드순≠prd_cd순):** 소프트(172)→CAT_000121·하드(173)→CAT_000122·레더하드(174)→CAT_000120·레더소프트(175)→CAT_000119·먼슬리(176)→CAT_000123 (정상 lvl2, upr=008) | 정체=008 문구(product-identity). 정상 노드 119~123 이미 upr=008 실재(F-ST-G1 재실측 §6). load_categories(:175 v03 상위코드 공란→고아)+load_rel_categories(:288 상품을 고아 300에 연결)=L-ST-C. 노트류·떡메모지(124)는 정상=반례. **[F-ST-G1 보정] 노드 발급순(레더소프트119/레더하드120/소프트121/하드122/먼슬리123)이 prd_cd순(소프트172/하드173/레더하드174/레더소프트175)과 불일치 — prd_cd 순차 재연결 시 4상품 전부 오연결.** | 상품을 **커버타입 의미가 일치하는** 정상 노드로 재연결(`t_prd_product_categories` UPDATE — 172→121·173→122·174→120·175→119·176→123, search-before-mint) + 잉여 고아 300 논리정리(use_yn=N) | High | 컨펌(Q-ST-B)+load-execution |
| **ST-02** | PRD_000176/177/178/179/181 백모조100·097 백모조120 | 자재 usage | MIS-LOADED | USAGE.07 공통(종이) | USAGE.01 내지 | 도메인 정답=내지 종이(col-dict L67·USAGE.01). load_rel_materials(:324) `r["용도"] or "공통"` — v03 14시트 종이 용도 셀 공란→공통(.07) fallback=L-ST-A. 무지내지(.01)는 정상=용도 채워진 행만 정상 | 종이 usage_cd를 USAGE.01로 UPDATE(내지). 떡메모지(097)는 USAGE.01 중복행 중 .07 논리삭제 | High | load-execution |
| **ST-03** | PRD_000172~179/181 표지 | 자재 코팅 평면화 | MIS-LOADED | MAT_000260/250 `아트250 + 무광코팅`(MAT_TYPE.01 종이, 코팅 평면화·2 중복행) | 아트250(표지지 자재 USAGE.02) **+** 무광코팅(공정 PROC_000015) 분리 | col-dict L87·entity-semantic §23·intent-map G-PB-3(복합표기 분해). load_materials에 분해 로직 부재(:236 자재명 그대로)=L-ST-B. 코팅 공정 PROC_000015는 라이브 실재(176/177 등 이미 연결) | 표지 자재명을 `아트250`만으로 분리(코팅 제거)·코팅은 이미 processes에 PROC_000015 연결됨(중복 의미 제거). 중복 자재행(250/260) 통합. **단 가격 영향 검증 동반** | Med | 컨펌(Q-ST-E·코팅분해 통일)+load-execution |
| **ST-04** | PRD_000174/175 레더 | 자재 유형 | AMBIGUOUS | MAT_000186 레더(화이트)·**MAT_TYPE.08 실사소재**·USAGE.02 | 가죽(MAT_TYPE.06) — 고아행 MAT_000008/173~175 재사용 또는 .08 유지 | Q4 의도 가죽(.06). 라이브 레더 3-way 혼재(.01 종이·.06 가죽 4행 고아·.08 실사 연결)=booklet CONFLICT-1 정확 동형. MAT_TYP_OVERRIDE(:116~121)는 "레더하드커버 A/A4/A5"만 가죽, "레더(화이트)"는 v03 .08 그대로=L-ST-D. search-before-mint=가죽 고아행 실재(신설 불요) | **booklet Q-BK-A와 통합 결정.** 3선택지: (a).08 유지(사슬보존) (b).06 고아행 재연결(search-before-mint) (c).06 신설(불요). 우변 무변경·컨펌까지 보류 | Med | 컨펌(Q-ST-D=Q-BK-A 통합) |
| **ST-05** | PRD_000097 떡메모지 vs 179 메모패드 | 제본 mand 일관 | MIS-LOADED | 떡메모지(097) 떡제본 mand_proc_yn=**N**·메모패드(179) 떡제본 mand=**Y** | 같은 떡제본은 **mand 값이 일관**해야 함(둘 중 하나는 오적재). 정답 값(N vs Y)은 인간 컨펌(Q-ST-F) | load_rel_processes(:415) v03 `필수공정여부` 그대로=L-ST-E. v03이 같은 떡제본을 097=N·179=Y로 **비일관 정의**(불일치 자체가 결함의 증거). **[F-ST-G3 보정] 라이브(097/179)·booklet 라이브 mand 값을 정답 근거로 쓰지 않음(round-13 라이브=피고). 결함=불일치, 통일 방향은 도메인(제본 필수 여부)으로 판단하되 미확정→컨펌** | 097/179 mand_proc_yn을 **일관 값으로 통일**(N 또는 Y — 떡제본이 필수 공정인지 도메인 판단 후 결정). 일관성 UPDATE | Low | 컨펌(Q-ST-F) |
| **ST-06** | PRD_000172/175/176 | 미싱제본 공정 | MISSING | 제본 공정 0행(172=코팅만·175=전 0행·176=코팅만) | 미싱제본(L1 COMMENT `*출력+미싱`) | domain-research §1·ST2-5. 제본 PROC_000017 자식 9종에 미싱**제본** 부재(seed). v03 15시트 소프트/레더소프트/먼슬리 제본행 없음=L-ST-F. 미싱=사철(실박음) 소프트커버 표준. **[F-ST-G2 search-before-mint 재실측 §7] 기존 미싱류 공정 2개 실재하나 둘 다 제본 family 아님: `PROC_000030 미싱`(부모 없음·prcs_dtl_opt `줄수` 0~3줄 = 후가공 재봉선)·`PROC_000074 6단미싱접지`(부모 PROC_000056 접지). → PROC_000030로 미싱제본 표현은 의미 충돌(후가공 vs 제본)** | **3선택지(Q-ST-A): (a) PROC_000017 신규 자식 "미싱제본" mint(채번)** — search-before-mint 결과 제본 family 내 재사용 후보 없음(030/074는 제본 아님). **(b) 기존 PROC_000030 미싱(후가공)으로 재해석**(제본 자식 아니라 후가공으로 처리) **(c) 무선/중철 변형.** 신규 mint는 (a) 선택 시만 | High | 컨펌(Q-ST-A)+ddl-proposer(미싱 신규·(a)時)+load-execution |
| **ST-07** | PRD_000097 떡메모지 | page_rule | MIS-LOADED | page_rule 3/3/3 | 떡제본 page 무의미(묶음수가 진짜 축)·또는 page=장수3(ST2-4) | intent-map L358(떡제본·낱장 page_rule 적재 ✗=잡음). booklet CONFLICT-2 동형 확정(라이브 동일 097 3/3/3). load_rel_page_rules(:453) 잡음 검증 없이 v03 21시트 그대로=L-ST-G. bundle 50/100권이 진짜 축 | **booklet Q-BK-B와 통합.** page_rule 3/3/3 정리(논리삭제·use 아님이라 행 삭제 제안 대신 note 표기+escalate) 또는 page=장수3 의미 확정(ST2-4). 침묵 삭제 금지(round-10 교훈) | Med | 컨펌(Q-ST-G=Q-BK-B 통합) |
| **ST-08** | PRD_000173/174 만년다이어리 하드/레더하드 | 면지 자재 | MISSING | 면지 0행 | 면지 USAGE.03(화이트/블랙/그레이 MAT_000001~004 재사용) | L1 C27 `하드커버(면지?)`(BOM §2/§3). v03 14시트 면지 행 없음=L-ST-H. 면지 마스터 MAT_000001~004(.01 종이·USAGE.03) 실재(booklet 하드커버 4상품 연결)=search-before-mint | `t_prd_product_materials` INSERT(173/174→MAT_000001~004 USAGE.03 면지, 기존행 재사용·신설 0) | Med | 컨펌(Q-ST-H·면지 색상 variant)+load-execution |
| **ST-09** | PRD_000177/178 스프링노트/수첩 | 실버링 자재 | MISSING | 실버링 0행 | 실버링 USAGE.07 또는 트윈링 param(MAT_000016 재사용) | L1 C27 `실버링`(BOM §6/§7). v03 14시트 실버링 행 없음=L-ST-H. 실버링 마스터 MAT_000016(MAT_TYPE.04 금속)=라이브 0상품 연결(고아)=search-before-mint | 실버링→materials(MAT_000016 재연결, USAGE.07) 또는 트윈링 prcs_dtl_opt 링컬러 param. **Q-ST-I(링=자재 vs param·booklet BK-3 통합)** | Med | 컨펌(Q-ST-I=booklet BK-3)+load-execution |
| **ST-10** | PRD_000172 만년다이어리 소프트 | PVC커버 자재 | MISSING | PVC 0행 | 투명커버 USAGE.05(PVC) | L1 C37 COMMENT `*PVC커버`(BOM §1). v03 14시트 PVC 행 없음=L-ST-H. PVC 자재 마스터 실재(MAT_000179/180 PVC·.08) | PVC커버→materials(USAGE.05, 기존 PVC 자재 재사용). **단 COMMENT 힌트라 BOM 도출 근거(견적밖 가능)=Q-ST-J** | Low | 컨펌(Q-ST-J)+load-execution |
| **ST-11** | PRD_000172~179 | 내지/합지보드 자재 | MISSING | 일부 내지·합지보드 0행 | 내지 종이(소프트/레더소프트)·합지보드(스프링/메모) | L1 일부 내지 빈값(공통풀)·C37 `*합지보드`(BOM §6/§8). v03 14시트 누락=L-ST-H. 합지보드=부속 자재(MAT_TYPE.07)·내지=공통풀 전개 | 내지 종이 연결(소프트/레더소프트)·합지보드 부속 자재 등록 검토. **Q-ST-K(합지보드 부속 등록·ST2-8)** | Low | 컨펌(Q-ST-K=ST2-8)+load-execution |
| **ST-12** | PRD_000173/174 만년다이어리 하드/레더하드 | B 셋트 sub_prd/sets | MISSING | sets 0행·표지 sub_prd 없음 | 표지 하드보드 반제품 sub_prd + sets 연결(booklet 하드커버 패턴) | 생산구조=B 셋트(entity-semantic §4·BOM §2/§3). v03 19시트 만년다이어리 하드 표지 sub_prd 행 없음=L-ST-I. booklet은 하드커버 sub_prd 보유(비대칭) | 표지 sub_prd 신설 + sets 연결 검토. **단 자재 권위=parent usage_cd라 sub_prd 없이 parent 자재로도 가능**(booklet Q3 = parent usage + sets 병행). Q-ST-L | Low | 컨펌(Q-ST-L)+load-execution |
| **ST-13** | PRD_000097/172~181 전 상품 | 가격 | MISSING | t_prd_product_prices 0행 | C29 inline 고정가(9000/12000/4500…)·떡메모지=가격표참고(묶음×size) | L1 "가격포함" 시트 단가 명시(round-2 고정가형·intent-map L409). 가격은 round-2 트랙·load_master 미관여(:469~481)=L-ST-J. 문구 round-2 미실행 | 고정형 PRF + `t_prd_product_prices`/component 적재(round-2 양식). 떡메모지=묶음수×size 매트릭스(ST2-7) | High | load-execution(round-2 양식) |
| **ST-14** | PRD_000175 레더소프트 | 공정 전 누락 | MISSING | 공정 0행(코팅·제본·포장 전무) | 레더 특수인쇄+미싱제본(L1) | v03 15시트 175 공정행 완전 부재=L-ST-K. 레더 표지=특수인쇄(코팅 없음 정합)·미싱제본 필요(ST-06과 연계) | 미싱제본(ST-06 컨펌 후)+레더 특수인쇄 라우팅 연결. ST-06 일괄 | Med | 컨펌(Q-ST-A)+load-execution |
| **ST-15** | PRD_000097 떡메모지 | bundle dflt 중복 | AMBIGUOUS | 50권·100권 둘 다 dflt_yn=Y | 택1 중 1개만 기본(또는 둘 다 정상) | L1 R21=50장1권·R22=100장1권(size별 다른 묶음). bundle 둘 다 dflt=Y=택1인데 둘 다 기본(의심). booklet 동형 | dflt_yn 1개만 Y로 UPDATE(size별 기본이면 size 종속 정합 확인) 또는 size별 정합이면 유지. Q-ST-M | Low | 컨펌(Q-ST-M) |
| **ST-16** | PRD_000172~181 plate | 폴더(인쇄방식) | AMBIGUOUS | output_paper_typ_cd NULL | 디지털인쇄/특수인쇄 라우팅 | L1 C12/C24 폴더. load_rel_plate_sizes(:340~347) 출력용지유형 NULL/기타. booklet GAP-PAPER 동형 | 폴더→출력용지규격 적재 vs 생산 라우팅 메타(견적밖). **Q-ST-C=booklet Q-BK-C 통합** | Low | 컨펌(Q-ST-C=Q-BK-C) |
| **ST-17** | PRD_000180 준비중 | 적재 보류 | CORRECT(의도) | use_yn=N·자재/공정 미완 | (준비중·완성 후 재분석) | L1 R17 노란배경(신규 MES 미등록). use_yn=N 적재=정합(준비중 정직 표기) | 유지(완성 후 재분석). 적재 대상 보류 | — | 없음 |
| **ST-18** | PRD_000097→098 sets | 떡메모 sub_prd | CORRECT | sets(097→098)·098=SEMI_ROLE.01 | 내지 반제품 결합 | booklet:18·라이브 정합. 자재 권위=parent(098 9속성 0행 정상) | 유지 | — | 없음 |

---

## 2. 분류 분포

| 분류 | 건수 | 항목 |
|------|:--:|------|
| CORRECT | 2 | ST-17(준비중 보류)·ST-18(떡메모 sub_prd) |
| MIS-LOADED | 5 | ST-01(카테고리 고아)·ST-02(종이 usage.07)·ST-03(코팅 평면화)·ST-05(제본 mand 혼재)·ST-07(page_rule 잡음) |
| MISSING | 8 | ST-06(미싱제본)·ST-08(면지)·ST-09(실버링)·ST-10(PVC)·ST-11(내지/합지)·ST-12(B셋트 sub_prd)·ST-13(가격)·ST-14(레더소프트 공정) |
| EXTRA | 0 | (잘못 추가된 상품행 없음. 고아 카테고리 노드 300은 노드이고 상품행은 정상=ST-01 논리정리) |
| AMBIGUOUS | 3 | ST-04(레더 유형)·ST-15(bundle dflt)·ST-16(폴더) |

> 합계 **18건**(CORRECT 2 + MIS-LOADED 5 + MISSING 8 + EXTRA 0 + AMBIGUOUS 3 = 18). **EXTRA 0** — 미적재·오연결·평면화가 주 결함이지 잉여 적재 아님. 논리삭제 제안=ST-01(잉여 고아 노드 300)·ST-02(떡메모 usage.07 중복행)·ST-07(page_rule 3/3/3, escalate 보존)·ST-03(코팅 평면화 자재 중복 250/260). **hard-delete 금지(use_yn/del_yn·note 보존).**

---

## 3. 라우팅 분포

| 라우팅 | 건수 | 항목 |
|--------|:--:|------|
| 없음(유지) | 2 | ST-17·ST-18 |
| load-execution | 11 | ST-01·02·03·05·06·08·09·10·11·12·13·14 (중 ST-06/14 컨펌 선행) |
| 컨펌(인간) | 12 | ST-01·03·04·05·06·07·08·09·10·11·12·15·16 |
| ddl-proposer | 1(조건부) | ST-06(미싱제본 신규 자식 mint — Q-ST-A (a) 선택 時만) |

> ddl-proposer는 미싱제본 신규 mint(Q-ST-A가 **(a) 신규 자식** 결정 時)만. **[F-ST-G2 보정]** 기존 미싱류 공정(PROC_000030 미싱·PROC_000074 6단미싱접지)을 검토했으나 둘 다 제본 family 아님(030=후가공 줄수 param·074=접지 자식) → 제본 family 내 재사용 후보 없음(search-before-mint 완결). Q-ST-A (b) 후가공 재해석 또는 (c) 변형 선택 시 ddl-proposer 불요. 면지/실버링/PVC/bundle/sets/option 테이블은 전부 실재=스키마 부족 없음(기존 행 재사용).

---

## 4. 🔴 컨펌 질문 (인간 결정 대기 — 분리)

- **Q-ST-A [🔴·핵심·ST2-5]** 미싱제본 처리 — 만년다이어리 소프트(172)·레더소프트(175)·먼슬리(176)는 L1 COMMENT `*출력+미싱`(미싱제본)이나 라이브 제본 0행입니다. 후니 제본 PROC_000017 자식 9종에 미싱**제본**이 부재합니다(표준상 사철=실박음 소프트커버 제본). **[F-ST-G2 search-before-mint] 기존 미싱류 공정 2개를 검토했으나 둘 다 제본 family가 아닙니다: `PROC_000030 미싱`(부모 없는 후가공·줄수 0~3줄 param=재봉선)·`PROC_000074 6단미싱접지`(접지 PROC_000056 자식). 따라서 제본 family 내 재사용 후보는 없습니다.** (a) PROC_000017 신규 자식 "미싱제본" mint(준비중 시트와 함께 코드 발급) (b) 기존 PROC_000030 미싱(후가공)으로 재해석해 제본이 아닌 후가공으로 처리 (c) 무선/중철 변형 중 어느 쪽으로 할까요?
- **Q-ST-B [🔴·ST-01]** 카테고리 재연결 — 플래너 5상품(만년다이어리 4·먼슬리)이 고아 노드 CAT_000300 플래너(upr=NULL)에 연결돼 있습니다. 정상 노드(만년다이어리 4종 CAT_000119~122·먼슬리 CAT_000123, 전부 upr=008 문구 lvl2)가 이미 실재합니다. **[F-ST-G1] 단 노드 발급순≠prd_cd순이라 커버타입 의미로 매칭해야 합니다(소프트172→121·하드173→122·레더하드174→120·레더소프트175→119·먼슬리176→123).** (a) 상품을 의미 매칭 정상 노드로 재연결 + 고아 300 논리정리(권장·search-before-mint·노트류 정상 반례) (b) 고아 300의 upr만 008로 보수(잉여 노드 잔존) — 어느 쪽? **PA-01·디지털인쇄 Q-ID-B와 일괄 결정 후보.**
- **Q-ST-C [🔴·ST-16=Q-BK-C]** 내지/표지 폴더(C12/C24 디지털인쇄/특수인쇄)를 출력용지규격(output_paper_typ_cd)으로 적재할까요, 생산 라우팅 메타(견적밖)로 둘까요? booklet Q-BK-C와 통합.
- **Q-ST-D [🟡·ST-04=Q-BK-A]** 레더(174/175 표지)가 라이브에서 MAT_TYPE.08 실사소재(MAT_000186)로 등록돼 있고, Q4 의도 가죽(.06) 자재행 4개(MAT_000008/173~175)가 이미 라이브에 실재하나 전부 고아입니다. (a).08 유지(사슬 보존) (b).06 고아행 재연결(search-before-mint) (c).06 신설(불요) 중? **booklet Q-BK-A·포토북 D-PB-1과 통합 결정.**
- **Q-ST-E [🟡·ST-03]** 표지사양 `아트250 + 무광코팅`을 자재(아트250)+공정(무광코팅)으로 분해할까요? 라이브는 한 자재행(MAT_000260/250 중복 2개)으로 평면화돼 있으나 코팅 공정 PROC_000015는 별도로 이미 연결돼 있습니다(의미 중복). 분해 시 자재명 정리 + 중복행 통합 + 가격 영향 검증이 필요합니다. **횡단 코팅 Q9(책자=공정·스티커/포토북=자재)와 통일 정합.**
- **Q-ST-F [🟡·ST-05]** 떡제본 mand_proc_yn이 떡메모지(097)=N·메모패드(179)=Y로 불일치합니다. 같은 떡제본인데 값이 다릅니다(불일치 자체가 결함). **떡제본이 필수 공정인지(제본 없이 주문 불가) 도메인 판단**에 따라 둘 다 N 또는 둘 다 Y로 통일해야 합니다. 떡제본은 필수입니까(Y 통일), 선택입니까(N 통일)?
- **Q-ST-G [🟡·ST-07=Q-BK-B]** 떡메모지 page_rule 3/3/3과 묶음수(50/100권)가 둘 다 적재돼 있습니다. 진짜 주문 축은 묶음수(권)이고 page_rule 3/3/3은 의미 없는 값으로 보입니다(intent-map=떡제본 page 무의미). page_rule 3/3/3을 정리할까요, page=장수3 의미로 유지할까요(ST2-4)? booklet Q-BK-B와 통합.
- **Q-ST-H [🟡·ST-08]** 만년다이어리 하드/레더하드 면지(`하드커버(면지?)`)를 면지 자재(USAGE.03 화이트/블랙/그레이 MAT_000001~004 재사용)로 연결할까요? 색상 3종=variant 처리?
- **Q-ST-I [🟡·ST-09=BK-3]** 스프링노트/수첩 실버링을 링 부속 자재(MAT_000016 재연결·USAGE.07)로 둘까요, 트윈링 공정 param(링컬러)으로 둘까요? booklet BK-3과 통합.
- **Q-ST-J [🟡·ST-10]** 만년다이어리 소프트 PVC커버(COMMENT `*PVC커버`)를 투명커버 자재(USAGE.05)로 적재할까요, 견적밖 BOM 힌트로 둘까요?
- **Q-ST-K [🟡·ST-11=ST2-8]** 합지보드/하드보드/PVC를 부속 자재(MAT_TYPE.07)로 등록할까요? 표지 결합인가 별 부속행인가? **CONFIRM-ST2-8.**
- **Q-ST-L [🟡·ST-12]** 만년다이어리 하드/레더하드를 B 셋트(표지 하드보드 sub_prd + sets)로 둘까요, parent usage 자재만으로 둘까요(booklet Q3=parent usage + sets 병행)?
- **Q-ST-M [🟡·ST-15]** 떡메모지 bundle 50권·100권이 둘 다 dflt_yn=Y입니다. 택1인데 둘 다 기본입니다. size별(90x90→50·70x120→100)로 정합이면 유지, 아니면 1개만 Y로 할까요?

> **일괄 결정 후보(중복 제거):** Q-ST-D=Q-BK-A(레더 .06/.08·포토북 D-PB-1)·Q-ST-G=Q-BK-B(떡메모 page 잡음)·Q-ST-C=Q-BK-C(폴더)·Q-ST-I=BK-3(링/면지)·Q-ST-E=Q9(코팅 family 통일)·Q-ST-B=Q-ID-B/PA-01(카테고리 고아). 문구 **고유 핵심**=Q-ST-A(미싱제본 신규)·Q-ST-F(떡제본 mand).

---

## 5. BLOCKED

- **준비중(180):** 완성 후 재분석(자재/공정/가격 미완). 적재 보류=정직 표기(ST-17 CORRECT).
- **가격(ST-13):** round-2 트랙 책임(load_master 밖). 본 라운드는 매핑 경로만 명시(고정형 PRF·떡메모 매트릭스)·실 적재는 round-2.
- **DB 미적재 [HARD]:** 본 매니페스트는 교정 제안까지. 실 COMMIT/DDL(미싱제본 신규)/논리삭제(고아 300·usage.07·page 3/3/3)는 round-5/인간 승인.
