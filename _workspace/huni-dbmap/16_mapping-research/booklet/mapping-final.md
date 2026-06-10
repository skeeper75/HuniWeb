# 책자 — 매핑 확정 (round-12 매핑 확정 리서치)

> **작성** 2026-06-10 · round-12(dbm-mapping-research P1~P4). 설명 한국어, 식별자/컬럼/코드값/SQL 영어.
>
> **목적:** 책자 시트 전 컬럼이 라이브 `t_*` 기초데이터에 "어디로·어떻게" 매핑되는지를 **라이브 실측으로 확정**한다. round-11 컬럼 의미 + 실무진 확정(Q1~Q15) + schema-design-intent-map(OM-1~7) + 라이브 DB 실측 4소스 결합.
>
> **권위 순서(HARD):** ① 실무진 확정(`_review/실무진-검토질문.md` Q1~Q15·★5건) ② 후니 PDF/table-spec ③ **라이브 DB 실측**(존재/NULL/코드값 항상 라이브 권위) ④ webadmin/loadspec ⑤ 07_domain KB ⑥ 외부(보조).
>
> **확정도:** ✅ 4소스 일치+라이브 실측 확인 · 🟡 부분/실측은 됐으나 결정 대기 · 🔴 미확정(컨펌 질문 동반).
>
> **라이브 실측 일자:** 2026-06-10 (읽기전용 SELECT, `live-crosscheck.md` 재현 쿼리).

---

## 0. 라이브 실측 요약 — round-11 초안 대비 핵심 정정 (★ = 매핑 수정)

책자는 라이브 적재가 **이미 매우 풍부**하다(PRD_000068~098, 11완제품 + 17반제품 sub_prd). 라이브 실측이 round-11 가설 다수를 확정/정정했다:

| # | round-11 초안 | 라이브 실측 결과 | 처분 |
|---|---------------|------------------|------|
| ★1 | 박칼라(C30) 공정 param vs 포일자재 컨펌 | **박색=공정 자식 별 PROC**(PROC_000037~044 홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클, 부모 PROC_000033 박) | Q2 확정·실측 일치 → ✅ **공정**. CONFIRM-BK-1 닫힘 |
| ★2 | 레더=MAT_TYPE.06 가죽(Q4) | **레더(화이트)=MAT_000186 MAT_TYPE.08 실사소재** | **CONFLICT** — 라이브 .08 vs Q4 권장 가죽. §CONFLICT-1 |
| ★3 | 면지=USAGE.03 자재(종이?) | 면지 4종 모두 **MAT_TYPE.01 종이**(MAT_000001~004)·USAGE.03 | ✅ 정합 |
| ★4 | 투명커버=USAGE.05·링=부속 | **투명커버=MAT_TYPE.02 필름·USAGE.05**(MAT_000244/245) / **링=MAT_TYPE.04 금속·USAGE.07**(MAT_000013~015) / **D링=MAT_TYPE.07 부속·USAGE.07**(MAT_000247~249) | Q5(시트별 옵션 확인) → ✅ **전부 자재**, usage 라이브 권위 |
| ★5 | 떡제본 page_rule 무의미(빈값) | **떡메모지(PRD_000097) page_rule=3/3/3 적재 + bundle_qtys 50/100권 둘 다 적재** | **CONFLICT** — §CONFLICT-2(page_rule 3/3/3은 잡음 의심) |
| ★6 | 제본 mand_proc_yn=Y | **책자 제본 9행 전부 mand_proc_yn=N** | ✅ 정정 → N(라이브 권위) |
| ★7 | GRP-BOOK-제본 택일그룹 적재 | **책자 option_groups 0행**(전면 미적재 — OM-6) | 🔴 미적재 GAP → §GAP-OG |
| ★8 | 레더링바인더 제본(C31 빈값) BK-2 | **PRD_000088 제본 family 미연결**(D링 USAGE.07만, 내지 빈 바인더) | C4 확정 → ✅ 제본 없음(바인더=자재 결합) |
| ★9 | 반제품=하드/레더만 분리(BK-5) | **하드/레더/하드링/레더바인더 = sub_prd + sets 적재됨**(엽서북·떡메모지도 sub_prd 보유). 일반책자(중철/무선/PUR/트윈링)=parent usage만 | Q3 ★(제본 전체관점) → ✅ 라이브 모델 = parent usage_cd 자재 + sets 연결 병행 |

---

## 1. 컬럼 → t_* 확정 매핑 (43 의미 컬럼 전수, L1 커버리지)

> L1 CSV(`06_extract/booklet-l1.csv`) 54컬럼 중 파생/메타 11컬럼(`sheet`·`row_seq`·`prd_nm`·`_anchor_ffilled`·`_row_hidden`·`_work_size_col`·`_work_size_value`·`AR`·`AS`·`AT`·`cell_meta_json`)은 추출 스캐폴딩(매핑 대상 아님, M1 제외 사유 명기). 나머지 43 = 책자 의미 컬럼 C1~C43.

| C | 엑셀 컬럼 | 의미축(round-11) | → t_*.컬럼 | 변환 규칙 | 코드값/FK | 라이브 실측 | 권위 | 확정 |
|---|----------|------------------|-----------|-----------|-----------|-------------|------|:--:|
| 1 | 구분 | 상품군 분류 | `t_prd_product_categories.cat_cd` | 그룹라벨→카테고리 FK. R85 URL행 제외 | cat_cd FK | 책자 카테고리 존재 | DB+col-dict L32 | ✅ |
| 2 | ID | 외부 식별자 | (매핑 보조키, t_* 미적재) | prd_cd 아님. 멱등키=prd_nm | — | — | col-dict L33 | ✅(제외 확정) |
| 3 | MES ITEM_CD(상품) | MES 품목코드 | `t_prd_products.MES_ITEM_CD` | 상품 대표 MES(내지/표지 MES와 별) | — | 컬럼 존재(대문자 `MES_ITEM_CD`) | 라이브 schema | ✅ |
| 4 | 상품명 | 상품 정체 | `t_prd_products.prd_nm` | 멱등 키. 제본=정체 | PK prd_cd | PRD_000068~097 실측 | 라이브 | ✅ |
| 5 | 사이즈(필수) | 재단치수+책등 | `t_prd_product_sizes.siz_cd` → `t_siz_sizes` | 규격→siz_cd FK. **두께A/B(하드커버링)=제본 책등 param 교차**(C5 두께 ↔ 제본 prcs_dtl_opt.책등mm) | siz_cd FK | SIZ_000170 A5·SIZ_000172 A4·SIZ_000258 A4 등 적재 | 라이브 | 🟡 |
| 6 | 내지파일사양>MES | MES(내지) | (생산메타 — t_* 미적재) | Q1 확정: **견적 제외**(내부 생산용) | — | — | **Q1 실무진** | ✅(제외 확정) |
| 7 | 내지>블리드 | 재단여유 | (미적재 — 작업−재단 도출) | Q14 확정: **별도 저장 불요**(작업/재단에서 도출) | — | — | **Q14 실무진** | ✅(제외 확정) |
| 8 | 내지>작업사이즈 | 작업치수(내지) | `t_prd_product_plate_sizes.siz_cd`(작업) | 작업치수→plate siz | siz_cd | PRD_000069 SIZ_000250 150x214 적재 | 라이브 | ✅ |
| 9 | 내지>재단사이즈 | 재단치수(내지) | `t_siz_sizes.cut_*`(C5 siz와 동일 완성치수) | 재단=완성. C5 size와 일관 | siz_cd | 적재 | 라이브 | ✅ |
| 10 | 내지>파일명약어 | 생산메타 | (t_* 미적재) | Q1 확정: **견적 제외** | — | — | **Q1 실무진** | ✅(제외 확정) |
| 11 | 내지>출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ`(내지) | PDF 텍스트 | — | PRD_000069 일부 'PDF', 일부 NULL | 라이브 | 🟡 |
| 12 | 내지>폴더 | 인쇄방식(내지) | `t_prd_product_plate_sizes.output_paper_typ_cd`(내지 출력용지규격) ↔ 인쇄방식 라우팅 | 책자/디지털/실사→출력용지규격 또는 공정 root | output_paper_typ_cd | **전 책자 plate output_paper_typ_cd 전부 NULL(19/19)** | 라이브 | 🔴 §GAP-PAPER |
| 13 | 내지종이(필수) | 자재(내지) | `t_prd_product_materials`(usage_cd=USAGE.01) + `t_mat_materials` | `*별도설정`=공통풀 전개. usage=내지 | usage_cd=USAGE.01 | PRD_000068 내지 13종 적재(몽블랑/스노우/아트/백모조) | 라이브 | ✅ |
| 14 | 내지인쇄(필수) | 인쇄면 도수(내지) | `t_prd_product_print_options.print_side` (내지=opt_id seq) | 단/양면→print_side. **usage_cd 컬럼 부재** — opt_id 행으로 내지/표지 구분 | front/back_colrcnt_cd=CLR | PRD_000068 opt_id 1=양면·2=단면 | 라이브 | ✅ |
| 15 | 내지페이지>최소 | page_rule | `t_prd_product_page_rules.page_min` | 제본별 차등 | — | 중철4·무선24·트윈링8 실측 일치 | 라이브 | ✅ |
| 16 | 내지페이지>최대 | page_rule | `t_prd_product_page_rules.page_max` | 제본별 차등 | — | 중철28·무선300·트윈링100 실측 | 라이브 | ✅ |
| 17 | 내지페이지>증가 | page_rule | `t_prd_product_page_rules.page_incr` | **중철=4(4배수)**·기타2 | — | 중철4·무선/PUR/하드2·트윈링2 실측 | 라이브 | ✅ |
| 18 | 표지파일사양>MES | MES(표지) | (생산메타 — t_* 미적재). **B 셋트 표지 sub_prd는 별 상품행으로 식별** | Q1 견적 제외. sub_prd=prd_cd로 식별 | — | PRD_000073 등 표지 sub_prd 존재 | Q1+라이브 | ✅(제외 확정) |
| 19 | 표지>블리드 | 재단여유 | (미적재 — 도출) | Q14: 별도 저장 불요 | — | — | **Q14 실무진** | ✅(제외 확정) |
| 20 | 표지>작업사이즈 | 작업치수(표지) | `t_prd_product_plate_sizes.siz_cd`(표지, 책등 포함 펼침) | 표지 작업치수→plate siz | siz_cd | plate_sizes 다행(표지 펼침) | 라이브 | 🟡 |
| 21 | 표지>파일명약어 | 생산메타 | (t_* 미적재) | Q1: 견적 제외 | — | — | **Q1 실무진** | ✅(제외 확정) |
| 22 | 표지>출력파일 | 파일포맷 | `output_file_typ`(표지) | PDF | — | 일부 NULL | 라이브 | 🟡 |
| 23 | 표지>폴더 | 인쇄방식(표지) | `output_paper_typ_cd`(표지) ↔ 라우팅 | 디지털/책자/특수인쇄(레더=특수). 내지와 별 라인 | output_paper_typ_cd | **NULL(미적재)** | 라이브 | 🔴 §GAP-PAPER |
| 24 | 표지종이(필수) | 자재(표지) | `t_prd_product_materials`(usage_cd=USAGE.02) + `t_mat_materials` | `*별도설정`/전용지/레더/스노우. **Q4: 자재 등록 + 용도=표지** | usage_cd=USAGE.02 | PRD_000072 전용지(MAT_000246 MAT_TYPE.01)·PRD_000077 레더(MAT_000186 **MAT_TYPE.08**) | 라이브 | 🟡 §CONFLICT-1 |
| 25 | 표지인쇄(필수) | 인쇄면 도수(표지) | `t_prd_product_print_options.print_side`(표지=opt_id seq) | 단/양면. 하드=단면 | CLR | PRD_000072 opt_id 1=단면·2=양면 | 라이브 | ✅ |
| 26 | 표지옵션>표지코팅 | 공정(코팅·표지) | `t_prd_product_processes`(PROC_000014 유광/PROC_000015 무광, 부모 PROC_000013 코팅) | 코팅없음/무광/유광→공정 연결. Q9 코팅=공정 정합 | proc_cd FK | PRD_000068~082 코팅 14/15 적재 | 라이브+Q9 | ✅ |
| 27 | 표지옵션>투명커버 | 자재+공정 BUNDLE | `t_prd_product_materials`(usage_cd=USAGE.05, MAT_TYPE.02 필름) **+** 부착공정 | 투명커버없음/유광/무광. Q5: 자재로 귀속(라이브) | usage_cd=USAGE.05 | PRD_000071 MAT_000244/245 USAGE.05 적재 | 라이브+Q5 | ✅ |
| 28 | 박/형압>박/형압가공 | 공정(박·형압·표지) | `t_prd_product_processes`(박 PROC_000033 family·형압 PROC_000050 양각051/음각052) | 박 있/없·형압 음각/양각→공정. Q2 박=공정 | proc_cd FK | PRD_000069 박8종+양각051+음각052 적재 | 라이브+Q2 | ✅ |
| 29 | 박/형압>크기 | 공정 param(박 면적) | `t_proc_processes.prcs_dtl_opt`(박 크기 mm) | 면적→등급=앱계산. 크기범위=입력UX | prcs_dtl_opt JSON | PROC_000033 `{"크기": number mm}`·PROC_000051 양각도 크기 보유 | 라이브 | ✅ |
| 30 | 박/형압>박칼라 | 박 색상 | `t_prd_product_processes`(박 색상 자식 PROC) | **Q2 확정: 박 그룹→색상(공정). 자재 아님.** 박칼라 8종=PROC 자식 | proc_cd FK | PROC_000037~044(홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클) 실측 | 라이브+**Q2 ★** | ✅ |
| 31 | 제본(필수) | 공정(제본)+택일 | `t_prd_product_processes`(PROC_000017 자식) + (택일=`t_prd_product_option_groups` GRP-BOOK-제본 **미적재**) | enum→제본 자식 PROC 1:1. **mand_proc_yn=N(라이브)**. 레더바인더=빈값(미연결) | proc_cd FK | PROC_000018~024 자식 상품별 1:1 적재(전부 N) | 라이브 | 🟡(택일그룹 §GAP-OG) |
| 32 | 제본옵션>제본방향 | 공정 param | `t_proc_processes.prcs_dtl_opt.방향`(좌철/상철) | PROC_000017 방향 param | prcs_dtl_opt | PROC_000017 `{"방향": 좌철/상철}` 실측 | 라이브 | ✅ |
| 33 | 제본옵션>면지 | 자재(면지) | `t_prd_product_materials`(usage_cd=USAGE.03) + `t_mat_materials`(MAT_TYPE.01 종이) | 화이트/블랙/그레이/인쇄면지. ★인쇄면지=하드링/레더바인더 조건부(constraint) | usage_cd=USAGE.03 | MAT_000001~004 종이·USAGE.03 적재 | 라이브 | ✅ |
| 34 | 제본옵션>링컬러 | 자재(링) | `t_prd_product_materials`(usage_cd=USAGE.07, MAT_TYPE.04 금속) | 화이트/블랙/메탈링. **Q5: 자재로 귀속(라이브)** | usage_cd=USAGE.07 | PRD_000071/082 MAT_000013~015 금속·USAGE.07 적재 | 라이브+Q5 | ✅ |
| 35 | 제본옵션>바인더링 | 자재(D링·책등) | `t_prd_product_materials`(usage_cd=USAGE.07, MAT_TYPE.07 부속) | D링 31/42/56mm=mat variant. **D링 mm=책등 두께**(C5 정합). ★사이즈선택=A4 종속 | usage_cd=USAGE.07 | PRD_000088 MAT_000247~249 부속·USAGE.07 적재 | 라이브+Q5 | ✅ |
| 36 | 제본옵션>제본(묶음수) | 묶음수(권) | `t_prd_product_bundle_qtys.bdl_qty`(bdl_unit=QTY_UNIT.03 권) | 50장1권/100장1권. page_rule 아님 | QTY_UNIT.03 | PRD_000097 50·100 QTY_UNIT.03 적재 | 라이브 | ✅ |
| 37 | 제작수량>최소 | 수량하한 | `t_prd_products.min_qty` | 1~3권 | — | 컬럼 존재 | 라이브 | ✅ |
| 38 | 제작수량>최대 | 수량상한 | `t_prd_products.max_qty` | — | — | 컬럼 존재 | 라이브 | ✅ |
| 39 | 제작수량>증가 | 수량step | `t_prd_products.qty_incr` | — | — | 컬럼 존재 | 라이브 | ✅ |
| 40 | 주문방법>업로드 | 주문채널 | `t_prd_products.file_upload_yn` | Y | — | 컬럼 존재 | 라이브 | ✅ |
| 41 | 주문방법>편집기 | 주문채널 | `t_prd_products.editor_yn` | Y | — | 컬럼 존재 | 라이브 | ✅ |
| 42 | 개별포장(옵션) | 공정(포장) | `t_prd_product_processes`(PROC_000076 수축포장, 부모 PROC_000075 포장) | 개별포장없음/수축포장→공정 | proc_cd FK | PRD_000068~097 PROC_000076 적재 | 라이브 | ✅ |
| 43 | COMMENT | 메타 | (t_* 미적재) | Q1 확정: **견적 제외**(생산 메모) | — | — | **Q1 실무진** | ✅(제외 확정) |

**확정도 분포:** ✅ 36 (제외 확정 8 포함) · 🟡 5 (C5·C11·C20·C22·C24) · 🔴 2 (C12·C23 — §GAP-PAPER) — 빈칸 0.

---

## CONFLICT (4소스 불일치 — 침묵 선택 금지)

### CONFLICT-1 [🟡] 레더(C24 표지종이) 자재유형 — 라이브 레더 자재가 3-way 혼재 (D-BK-1 보정)
- **불일치:** 실무진 Q4 = "레더(가죽)도 자재 등록 + 용도=표지", 권장안 가죽. round-11 BOM = MAT_TYPE.06 가죽 가설. **라이브 전수 실측 = 레더류 자재가 3개 mat_typ_cd에 6행 혼재**(직전 단일 인용 "레더=.08"은 부분실측이었음 — M5 보정):
  - `MAT_000006 레더하드커버` = **MAT_TYPE.01 종이** (PRD_000100 1상품 연결, 책자 시트 밖 포토북類)
  - `MAT_000008 레더`·`MAT_000173/174/175 레더하드커버 A/A5/A4` = **MAT_TYPE.06 가죽** — **4행 전부 고아(상품 미연결)**
  - `MAT_000186 레더(화이트)` = **MAT_TYPE.08 실사소재** — 6상품 연결
- **책자 in-scope 실측:** 책자 레더 상품(PRD_000077 레더 하드커버책자·PRD_000088 레더 링바인더)은 **둘 다 MAT_000186(.08 실사소재)**를 USAGE.02 표지로 연결(`live-crosscheck.md §5.1`). 표지 sub_prd(078/089)는 레더 직접 연결 0(자재 권위=parent usage_cd).
- **분석:** Q4가 의도한 가죽(.06) 자재행이 **이미 라이브 마스터에 실재(전부 고아)**한다. 따라서 컨펌 전제가 "Q4 가죽 신설 vs 라이브 .08 유지" 양자택일이 아니라 **3선택지**다. search-before-mint = **.06 신설 불요**(MAT_000008/173~175 재사용 가능).
- **처분:** 매핑 우변은 현 라이브 연결(.08 MAT_000186) 유지(상태 권위 [HARD]·사슬 보존). 자재유형 의도 정합은 Q-BK-A로 컨펌. 기계적 mat_typ_cd 변경 금지(OM 패턴 회피).

### CONFLICT-2 [🟡] 떡메모지(C15~17/C36) page_rule vs 묶음수 — intent-map(떡제본 page 무의미) vs 라이브(page_rule 3/3/3 + bundle 둘 다 적재)
- **불일치:** schema-design-intent-map L358 "떡제본·낱장에 page_rule 적재 ✗(잡음)". round-11 "떡메모지 page 빈값=떡제본 page 무의미 실증". **라이브 = PRD_000097 page_rule 3/3/3 적재 + bundle_qtys 50/100권 둘 다**.
- **분석:** page_rule 3/3/3(min=max=incr=3)은 의미 없는 placeholder/잡음 의심(떡메모지는 묶음수가 진짜 축). 엽서북(PRD_000094 page 20/30/10)은 정상(엽서 장수).
- **처분:** **묶음수(C36)=권위**(QTY_UNIT.03 권). page_rule 3/3/3은 잡음으로 분류·정리 대상(컨펌 Q-BK-B). 침묵 삭제 금지(round-10 교훈, 적재된 행 보존하며 escalate).

---

## GAP (라이브 미적재 — 적재 대상)

### GAP-OG [🔴] 제본 택일그룹(C31) GRP-BOOK-제본 미적재
- **상황:** round-11/intent-map = 제본은 `t_prd_product_option_groups` GRP-BOOK-제본(SEL_TYPE.01 단일)으로 택일. **라이브 책자 option_groups 0행**(OM-6 CPQ 옵션 레이어 전면 미적재 정합).
- **현 적재:** 제본 자식 PROC는 상품별 1:1 적재(중철책자→PROC_000018 1행)되어 있어 **상품=제본 1:1이라 택일그룹이 현재는 불요**(한 상품이 한 제본). 택일그룹은 "한 상품이 여러 제본 중 택1"일 때만 필요.
- **처분:** 책자는 상품명=제본정체(중철책자/무선책자…)라 제본 택일그룹 **불요**(현 1:1 모델이 정상). OM-6 CPQ 레이어 전면 적재(round-6 트랙·인간 승인) 시 함께. **매핑 수정: C31 택일그룹 매핑 철회 → 제본=상품별 공정 1:1**.

### GAP-PAPER [🔴] 내지/표지 폴더(C12/C23)=출력용지규격 미적재
- **상황:** C12/C23 폴더(책자/디지털/실사/특수인쇄)는 출력 라우팅=출력용지규격(`output_paper_typ_cd`). **라이브 plate_sizes output_paper_typ_cd 전부 NULL(19/19)**.
- **처분:** 출력용지규격 코드 미적재 = 적재 대상(또는 폴더=인쇄방식 라우팅 메타로 견적밖 분류). **Q-BK-C 컨펌**: 폴더를 출력용지규격으로 적재할지, 생산 라우팅 메타(견적밖)로 둘지.

---

## 매핑 결정 요약 (실무진 확정 반영)

| 결정 | 내용 | 권위 |
|------|------|------|
| 박칼라=공정(자재 아님) | C30 박색 8종=PROC_000037~044 자식 | **Q2 ★**+라이브 실측 |
| 코팅=공정 | C26 PROC_000014/015 | Q9+라이브 |
| 부속(링/D링/투명커버)=자재 | C27/34/35 usage .05/.07, 라이브 mat_typ 권위 | **Q5 ★**+라이브 |
| 반제품=parent usage + sets 병행 | 하드/레더=sub_prd+sets 적재, 일반책자=parent usage만. 자재 권위=parent+usage_cd 항상 | **Q3 ★**+라이브 |
| 생산메타 견적 제외 | C6/C10/C18/C21/C43 + 블리드 C7/C19 | **Q1·Q14**+ |
| 레더 자재유형 | 라이브 3-way 혼재(.01종이/.06가죽 4행 고아/.08실사소재). 책자 in-scope=MAT_000186 .08 연결. 컨펌 Q-BK-A(.08 유지/.06 고아행 재연결) | CONFLICT-1 |
| 제본 택일그룹 불요 | 상품=제본 1:1(중철책자 등). C31 택일그룹 철회 | 라이브 GAP-OG |
| 레더링바인더=제본 없음 | PRD_000088 제본 family 미연결(D링 자재 결합) | **C4**+라이브 |
| 제본 mand_proc_yn=N | 라이브 전부 N(round-11 Y 정정) | 라이브 |

---

## 🔴/🟡 컨펌 질문 (인간 결정 대기)

- **Q-BK-A [🟡 CONFLICT-1]** 책자 레더 상품(레더 하드커버책자·레더 링바인더)이 실제 연결한 표지 자재는 `MAT_000186 레더(화이트)`인데 라이브에서 **MAT_TYPE.08 실사소재**로 등록돼 있습니다. 한편 실무진 Q4가 의도한 **가죽(MAT_TYPE.06) 레더 자재행이 이미 라이브에 4개 실재(MAT_000008/173/174/175)**하나 어느 상품에도 연결돼 있지 않습니다(고아). 따라서 3선택지가 있습니다: **(a)** 현 .08 실사소재 유지(적재 사슬 보존·무변경) / **(b)** 기존 .06 가죽 고아행으로 재연결(search-before-mint·신설 0) / **(c)** .06 신설(불요 — 고아행 존재). 어느 안으로 할까요? (포토북 family도 동형 결함 D-PB-1로 별도 보정 중이라 **책자와 통합 결정 가능**)
- **Q-BK-B [🟡 CONFLICT-2]** 떡메모지에 page_rule 3/3/3과 묶음수(50/100권)가 둘 다 적재돼 있습니다. 떡메모지의 진짜 주문 축은 묶음수(권)이고 page_rule 3/3/3은 의미 없는 값으로 보입니다. page_rule을 정리(제거)할까요, 둘 다 유지할까요?
- **Q-BK-C [🔴 GAP-PAPER]** 내지/표지 폴더(C12/C23: 책자/디지털/실사/특수인쇄)는 현재 라이브에 미적재(output_paper_typ_cd NULL)입니다. 이를 출력용지규격으로 적재할까요, 생산 라우팅 메타(견적 밖)로 둘까요?
