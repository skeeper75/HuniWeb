# Print-KB Wiki — LOG (append-only)

> Karpathy 위키 연대기. ingest·query·lint 액션 기록. 최신이 위.

---

## 2026-06-12

- **[LINT] foundation W-gate 2차 재측정 — GO** — pkw-wiki-qa 독립 재검증(`_qa/foundation-gate.md` "## 2차 재측정" append). writer 보정 신고 불신·라이브 직접 재대조. **1차 NO-GO 사유 전건 해소:** W2 BROKEN 0(linkcheck 재실행, skip된 `[[../huni/...]]`×18 placeholder는 의도 forward-ref·옆에 실권위 병기)·W3 4건 라이브 SELECT 직접 재대조 일치(`%excl%`/`%dim%`→0·prc_typ_cd 144 .01·t_cod_base_codes cod_grp_cd 부재·option_items 18)·W6 answers_cq 29 unique 전건 cq-registry 실재·관계동사 41건 의미정합. 회귀 W1/W4/W5/W7 무손상(v03 2건 전부 🔴STALE/GAP 격리·load_master.py:39 라이브 재확인·14/14 index). paper.md "건드렸다 원복"=git 미추적이라 diff 불가나 내용 무손상 확증. **종합 GO·finding 0.** 재현 `_qa/scripts/linkcheck.py`.

- **[FIX] foundation W-gate NO-GO 보정 (finding 한정) — GO 전환 준비** — `_qa/foundation-gate.md` finding 전건 보정(신규 집필 0·구조 재설계 0). **W2 BROKEN-LINK 25 → 0**(linkcheck.py 재실행 확인): heading-text 앵커 폐기, 안정 item-ID(R-7)로 통일 — `color#별색`→`#BCL-003`·`#화이트`→`#BCL-005`·`finishing#uv`→`#BFN-006`·`#재단`→`#BFN-002`·`#박`→`#BFN-004`·`paper#전지`→`#BPP-004`·`#결방향`→`#BPP-001`·`#종이-종류`→`#BPP-003`·`prepress-file#블리드`→`#BPF-003`·`#판걸이`→`#BPF-002`·`#출력규격`→`#BPF-003`·`sizes#출력판형`→`#BSZ-003`; 번호포함 slug — `printing-methods#무판--디지털-인쇄`→`#2-...`·`#방식-선택을-가르는-변수`→`#3-...`·`#출처`→`#출처-베이스--표준교과서`; `binding#표지-내지`(미존재 의도링크)→`binding#BBD-001`·`binding#제본방식`→`binding#BBD-003`. **W3 SCHEMA-MISMATCH 4 보정(라이브 실측 반영, "DDL 선언 vs 라이브 미적용·미백필" 분리 표기):** ① processes PRC-001/02 — `t_prd_product_process_excl_groups` 라이브 부존재(삭제) → 배타 라이브 경로=`t_prd_product_processes.mand_proc_yn`, 택일그룹 구조는 🔴 GAP([PRC-002] 도메인 명제·신규 [PRC-GAP-5]). ② price-engine PE-001/02 — `pricing_dims`/`use_dims`는 라이브 테이블 아님(sql/21·22=seed/init), 차원 라이브 위치=`t_prc_component_prices`+`t_prc_price_components.prc_typ_cd`(144행 전부 .01 라이브 실측). ③ materials MAT-003 + load-path LP-003 — `t_base_codes`→`t_cod_base_codes`(`cod_grp_cd` 없음·`upr_cod_cd` 자기참조 계층), BASE_CODE_GROUP=컬럼 아님 명시. **CONF-1 확정:** cpq-options CPQ-008 option_items 행수=라이브 18행 확정(ref-csv 0·메모리 43 둘 다 stale 주기). **W6 answers_cq:** 축 6페이지 원자 항목에 cq-registry CQ 연결(processes→CQ-PROC/FIN·price-engine→CQ-PRICE·materials→CQ-PROD/TERM·cpq-options→CQ-PROD/FIN/PROC·load-path→CQ-FILE/PROD·widget-contract→CQ-PROD/PRICE). **관계 동사:** 축 항목 관계 링크에 6동사(uses/requires/excludes/priced-by/loaded-via/mapped-to) 명시. stale Sources 갱신(ref-product-process-excl-groups.csv·sql/21·22 seed·option_items 18행). 변경 파일=base/{finishing,color,paper,printing-methods,sizes}·huni/{processes,price-engine,materials,cpq-options,load-path,widget-contract,modeling-axioms}. **finding 외 변경 0.**

- **[LINT] foundation W-gate (base 7 + 축 6 + modeling-axioms) — NO-GO** — pkw-wiki-qa 독립 검증(`_qa/foundation-gate.md`). W1 인용 실재성 PASS(자가신고 인용 전건 라인 실재·의미일치, load_master.py:39 v03·loadspec L79/L96·sql 18~22 등)·W5 stale 전파 PASS(v03·price-engine-ddl·constraint_json 전부 STALE 블록 격리, 라이브가 삭제 확증)·W4 badge PASS(✅3 tier A 라이브 확증)·W7 PASS. **NO-GO 사유: W3 SCHEMA-MISMATCH 4(라이브 실측) + W2 BROKEN-LINK 25.** W3: `t_prd_product_process_excl_groups`·`pricing_dims`·`use_dims` 라이브 부존재(PRC-001/02·PE-001/02 앵커 무효)·`t_base_codes`→실제 `t_cod_base_codes`(cod_grp_cd 없음·upr_cod_cd 계층). CONF-1 판정=option_items **라이브 18행**(ref-csv 0·메모리 43 둘 다 stale, 위키 헤지로 치명 아님). W3 확증 다수: template_prices 0·constraint_json 삭제·dep_proc_cd 0·fn_chk_opt_item_ref 실재·prc_typ_cd 144행 .01·트리거 37·t_*=35. W2: 25 ANCHOR-MISSING(PAGE 0)=heading 번호접두 누락+개념명 앵커(안정 item-ID 미사용, R-7 위반). 보정=앵커/링크 1회 교정으로 GO 전환 가능(구조 재설계 불요). 재현 스크립트 `_qa/scripts/linkcheck.py`.

- **[SCHEMA] README 관계 그래프 원칙 명문화(사용자 directive — 위키의 본질)** — §3에 "관계 그래프 원칙" 추가: ① 원자 항목 등재(요소 분리·자기완결 블록·과분할 금지 R-9: 1항목=1 의미단위≠1 DB행) ② 관계 유형 6 1급 동사(uses/requires/excludes/priced-by/loaded-via/mapped-to) + 명시 링크 ③ 역링크 슬롯 규약(`- 사용처:` — 레시피 집필 시 양방향 채움) ④ 레시피=조립 뷰(축 항목 참조만·본문 복붙 금지). 근거=사용자 directive "가장 작은 단위까지 분리해서 서로서로 연계".

- **[INGEST] 횡단 축 6페이지 신규 집필** — `huni/`에 materials·processes·price-engine·cpq-options·widget-contract·load-path. 원천=`_curation/axis-*.md` 6팩(정답 소스 file:§·tier·freshness·stale 함정·GAP). 각 페이지 원자 항목(@id)+관계링크+역링크 슬롯+badge+출처. 라이브 오적재(round-13)는 "라이브 현재값 X → 정답 Y {🔴 교정대기}" 양면 표기, STALE/v03 인용 0(price-engine-ddl·constraint_json·dep_proc_cd·v03 xlsx 전부 STALE 블록으로 격리·인용 금지 명시).
  - materials: 항목 10(MAT-001~006·GAP 3·STALE은 GAP-3에 통합)·관계링크 ~22·GAP 3(+오적재 2 양면). 핵심=MAT_TYPE .07~10 오염·레더 .06·과분할 금지.
  - processes: 항목 12(PRC-001~008·GAP 4)·관계링크 ~26·GAP 4(코팅 CONFLICT BATCH-3 정직). 핵심=별색=공정 clr_cd=NULL·박/코팅/UV=공정·UV PROC_000002.
  - price-engine: 항목 16(PE-001~010·STALE 1·GAP 4)·관계링크 ~30·GAP 4. **STALE: price-engine-ddl.md 전체 인용금지(I-1·I-2·I-4·I-7)**. 공식 4유형(합산/면적매트릭스/고정가/구간)·판수=앱 계산.
  - cpq-options: 항목 14(CPQ-001~008·STALE 1·GAP 3)·관계링크 ~28·GAP 3. **STALE: constraint_json 삭제(I-5)·RULE_TYPE 2종(I-8)**. BUNDLE(자재+공정)·전면 미적재(silsa 파일럿만, 행수 라이브 재확인).
  - widget-contract: 항목 9(WID-001~005·STALE 1·GAP 3)·관계링크 ~18·GAP 3. DB 외 앵커(정규화 계약)·서버 가격권위·PRICE=0 불가·Red 인용금지.
  - load-path: 항목 11(LP-001~007·STALE 1·GAP 4)·관계링크 ~22·GAP 4. **STALE: v03 입력금지·constraint_json/dep_proc_cd(I-5·I-6)**. 컬럼존재≠백필·멱등 search-before-mint·GO분 적재됨.

- **[INDEX] AXES 섹션 본문화** — 6 축 페이지 예정→실제 링크+1줄 요약+badge 분포 등재(llms.txt 형식). 헤더 노트 "차기 집필"→"본문 집필 완료" 갱신.

- **[ADOPT] R-1~R-8 전건 채택(잠정)** — `_research/adoption-record.md` 신규. 채택 상태=잠정(오케스트레이터 권고안 채택·사용자 비준 대기·반박 시 롤백). 기각 0. A-11=huni 레이어 이동 결정.

- **[SCHEMA] README 컨벤션 갱신** — §1 base 출처 신뢰도 badge([검증]/[단일출처]/[추정], R-4)·§3 안정 @id 운용+분할 lint(R-7)·§8 index=llms.txt 형식+RECIPES/AXES 1급 섹션(R-1·R-2)·§9 레시피 8절 표준 템플릿(CQ 헤더 R-5·섹션 자기완결 R-6·7절 라이브↔정답 양면표기 필수 슬롯 R-8). 기존 Karpathy 3계층·badge·[[교차참조]]·answers_cq 불변.

- **[INGEST] base 토대 6페이지 신규(R-3)** — `base/`에 sizes·paper·finishing·binding·color·prepress-file. 근거=`_research/base-verification.md` 검증 사실(A·B). **검증 한계 정직 표기:** base-verification가 검증한 것(방식 A-1~10·임포지션/블리드/결방향/CIP4 B-1~5)만 [검증], 미검증 도메인 통념은 [추정], 외부 근거 부재는 GAP로 명시(평량·코팅·박·제본방식·별색·PDF/X 등 다수 GAP — 날조 0). 후니 특정 사실(코드·가격·스키마)은 base 제외.
  - 사실별 [검증]/[단일출처]/[추정] 표기·[[교차참조]]·family/huni 축 링크.

- **[MOVE] A-11 — "1상품=1방식·인쇄방식=최상위 분기축" base→huni** — `base/printing-methods.md`에서 모델링 명제 제거(보편 사실 "방식→후가공/소재 종속"만 잔류), `huni/modeling-axioms.md` 신설(HMOD-01, 출처 병기·삭제 없음). 나무위키 출처→EPA/Wikipedia/CIP4 검증 표준으로 격상.

- **[INDEX] llms.txt 형식 재정렬 + RECIPES/AXES/HUNI(huni) 1급 섹션 추가** — H2+불릿 링크+콜론 설명. 레시피 11·축 7(modeling-axioms 본문+축 6 예정)·base 7 카탈로그. policy 보존.

- 결과: base 1→7페이지·huni 레이어 신설(modeling-axioms)·index llms.txt화·README 4 R-규칙 명문화. GAP=가격/CPQ 일반론 base 페이지는 외부 검증 부재로 미작성(AXES huni 레이어로 귀속).

---

## 2026-06-05

- **[INGEST] D-INGEST-001 — 정책 도메인 (파일럿)**
  - 원천: `docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx` (파싱본 `pq/02_business/policy-checklist.md`) + D 인터뷰 R1~R3(암묵지).
  - 요약 페이지: `sources/policy-checklist.md`.
  - 생성 엔티티 페이지 10: membership-auth·mypage·order-payment·shipping·coupon·review·product-pricing·order-mgmt·operations·custom-dev (~57 항목).
  - index.md 갱신(정책 도메인 카탈로그 추가). 교차참조: 쿠폰↔회원등급↔리뷰, custom-dev↔각 기능, operations↔외주 claims.
  - 결과: 정책 도메인 위키화 완료. 상태 분포 ✅8(현행)·🟡25·🔴23·⚪1=57(lint 검증).

- **[SETUP] 위키 스키마 수립** — `README.md`(3계층·페이지컨벤션·워크플로·상태badge), `index.md`, `log.md` 생성. Karpathy gist(442a6bf) 기준.

---

## Lint 대기 항목 (다음 점검)
- 🟡권장 25건: To-Be 결정 시 ✅ 승격 — 결정 워크숍 후 일괄 갱신.
- 🔴미결정 23건: 결정 필요 — CUSTOM 9 + 가격관리 8 우선.
- 교차참조 검증: [[membership-auth#MEM-06]]↔[[coupon#CPN-04]] 양방향 확인 완료.
- 예정 도메인 4종 인계 시 정책↔공정/가격 교차참조 추가 필요.
