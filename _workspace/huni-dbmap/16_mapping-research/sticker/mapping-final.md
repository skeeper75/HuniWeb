# 스티커 — 매핑 확정 (round-12 mapping-final)

> **작성** 2026-06-10 · round-12 매핑 확정 리서치. **컬럼 → 라이브 t_*.컬럼 + 변환 + 코드값/FK + 라이브 실측 + 권위 + 확정도**를 확정. round-4/5 적재본 조립의 직접 입력.
>
> **권위 순서(HARD):** ① 실무진 확정(Q1~Q15, ★) ② 후니 PDF/table-spec ③ 라이브 DB 실측(`live-crosscheck.md`) ④ webadmin loadspec ⑤ 내부 KB(07_domain·schema-design-intent-map OM-1~7) ⑥ 외부(보조·`research-gap-board.md`).
> **추정 0** — 미확정은 🔴+컨펌 질문. 4소스 불일치는 **CONFLICT 행**으로 명시(침묵 선택 금지).
>
> **이 라운드의 round-11 대비 정정(★):**
> - **Q9 코팅=공정**(자재 아님) — round-11 "코팅=자재 variant" 철회. 단 라이브 현실=자재 → **CONFLICT-1**.
> - **Q7 형상=size 유지·칼틀 1:1·칼선 자동 도출** — round-11 "공정 재귀속 가설(CONFIRM-ST-1)" 철회·종결(가격표 형상×사이즈 격자로 입증).
> - **Q8 조각수=둘 다**(묶음수=권/세트 ≠ 조각수=판당개수+제한) — 이중 귀속 확정. 단 라이브 미적재 → GAP.
> - **USAGE=.07 공통**(round-11 ".01 본체" 정정, 라이브 실측).

---

## L1 커버리지 — 컬럼 인벤토리 (M1 기준)

`06_extract/sticker-l1.csv` 데이터 컬럼 = **32개**(구분~추가가격) + `AG·AH·AI·AJ·AK` 5 빈컬럼(전 행 None — 엑셀 잉여 컬럼, 제외). 32개 전부 아래 표에 존재.

---

## 매핑 확정 테이블 (C1~C32 전수)

| C | 엑셀 컬럼 | 의미축(round-11) | → t_*.컬럼 | 변환 규칙 | 코드값/FK | 라이브 실측 | 권위 | 확정 |
|---|----------|------------------|-----------|-----------|-----------|-------------|------|:--:|
| 1 | 구분 | 상품군 | `t_prd_product_categories.cat_cd` | 시트 단일군(빈값)→스티커 카테고리 | **CAT_000002**(실측) | 052·066=CAT_000002 ✅존재 | 라이브·KB | ✅ |
| 2 | ID | 외부키 | (매핑 보조키 — t_* 컬럼 없음) | prd_cd 아님. 멱등키=prd_nm | — | NULL 가능(변형) | 엑셀·round-11 | ✅ |
| 3 | MES ITEM_CD | MES코드 | `t_prd_products.MES_ITEM_CD` | 002- prefix 원형 보존(대문자) | — (unique) | 컬럼 존재(대문자) ✅ | 라이브·loadspec | ✅ |
| 4 | 상품명 | 상품정체 | `t_prd_products.prd_nm` | 멱등 키. 반칼/완칼=커팅 정체 단서 | — | 16상품 PRD_000052~067 ✅적재 | 라이브 | ✅ |
| 5 | 사이즈(필수) | 재단치수(+형상=칼틀) | `t_siz_sizes.cut_*` + `t_prd_product_sizes` | 규격/자유=치수. **합판도무송 형상형(`정사각30x30mm(2EA)`)=칼틀 1:1, size 유지(Q7★)** | siz_cd FK | 066 sizes=37행(siz_nm에 형상+EA) ✅ / 규격형 058~062=2행(치수만) | **실무진 Q7★**·라이브·가격표 | ✅ |
| 6 | 판수 | 판걸이수(임포지션) | **미저장 — 앱 런타임 계산** | t_* 매핑 금지. 가격공식 분모 | — | (DB 미저장 정합) | 메모리 `compute-in-app-db-stores-lookup` | ✅ |
| 7 | 파일사양>블리드 | 재단여유 | **미저장 — 작업−재단 자동 도출(Q14)** | work−cut=2×블리드 | — | (별도 칸 없음 정합) | **실무진 Q14**·KB | ✅ |
| 8 | 파일사양>작업사이즈 | 작업치수 | `t_siz_sizes.work_width/height` | 같은 siz_cd 행 work 슬롯 | siz_cd FK | sizes 적재됨 ✅ | 라이브·table-spec | ✅ |
| 9 | 파일사양>재단사이즈 | 재단치수 | `t_siz_sizes.cut_width/height` | C5 mm 본문 → 한 siz_cd 통합 | siz_cd FK | sizes 적재됨 ✅ | 라이브·table-spec | ✅ |
| 10 | 파일사양>출력용지규격 | 출력판형/전지 | `t_prd_product_plate_sizes.output_paper_typ_cd` + `t_siz_sizes`(impos_yn=Y) | "330x470"→OUTPUT_PAPER_TYPE 코드 | output_paper_typ_cd FK | 066 plate=26행·052=3행 ✅ | 라이브·메모리 `platesize-is-output-paper` | ✅ |
| 11 | 파일사양>파일명약어 | 생산메타 | **견적 제외(Q1)** — t_* 미적재 | 내부 MES 표기. 견적/주문 미노출 | — | (DB 컬럼 부재 정합) | **실무진 Q1** | ✅ |
| 12 | 파일사양>출력파일 | 파일포맷 | `t_prd_product_plate_sizes.output_file_typ` | 자유텍스트. PDF/PDF(W)/AI(칼선)/JPG | — (자유텍스트) | output_file_typ 컬럼 존재 ✅ | 라이브·loadspec | 🟡 |
| 13 | 파일사양>폴더 | 인쇄방식/라우팅 | **견적 제외(Q1)** + 인쇄방식은 **공정 root로 암묵 표현** | 폴더=생산 라우팅. 인쇄방식(디지털/실사/화이트/합판/전사)→상품 root 공정 적재로 표현 | (PROC root) | 066=합판인쇄(공정=스티커완칼 적재) | **실무진 Q1**·process-recipe-tree §1 | 🟡 |
| 14 | 주문방법>업로드 | 주문채널 | `t_prd_products.file_upload_yn` | Y | — | 컬럼 존재 ✅ | 라이브·table-spec | ✅ |
| 15 | 주문방법>편집기 | 주문채널 | `t_prd_products.editor_yn` | Y | — | 컬럼 존재 ✅ | 라이브·table-spec | ✅ |
| 16 | 종이(필수) | 자재(점착지) | `t_mat_materials`(mat_typ_cd=MAT_TYPE.11) + `t_prd_product_materials`(mat_cd + **usage_cd=USAGE.07 공통**) | 자재명 멱등. **코팅=공정(Q9★)이므로 무광/유광코팅스티커는 CONFLICT-1 참조** | mat_cd FK·USAGE.07 | 11자재 적재·052=5종 usage=.07 ✅ | 라이브·**Q9★**·loadspec | 🟡 |
| 17 | 인쇄(옵션) | 인쇄면 도수 | `t_prd_product_print_options.print_side` + front/back_colrcnt_cd | 단면. back_colrcnt=무도수(CLR) | print_side='단면'·front=CLR_000005·back=CLR_000001 | 052 print_opt 1행 ✅ | 라이브·table-spec | ✅ |
| 18 | 별색인쇄>화이트 | 별색 공정 | `t_proc_processes`(PROC_000008) + `t_prd_product_processes` | print_side 아님=후공정. 투명/홀로그램 필수 | proc_cd=PROC_000008 | 053/056 화이트(008) 연결 ✅ | 라이브·entity-semantic §3-2·G-SK-1 | ✅ |
| 19~22 | 별색>클리어/핑크/금/은 | 별색 공정 | (스티커 미사용 — 전 행 빈값) | 적재 안 함 | — | 미적재 정합 | 엑셀 실측 | ✅ |
| 23 | 코팅(옵션) | **공정(Q9★)** | `t_proc_processes`(PROC_000013 코팅) + `t_prd_product_processes` | **C23 빈값이나 무광/유광코팅스티커(C16 자재명)=코팅 공정 신호. Q9★=코팅 공정** | proc_cd=PROC_000013 | **CONFLICT-1: 라이브는 코팅을 자재(MAT_000155/156)로 적재** | **실무진 Q9★** | 🟡 |
| 24 | 커팅(옵션) | 공정+형상+조각수 | `t_proc_processes`(PROC_000053 완칼·054 반칼·055 스티커완칼) + `t_prd_product_processes`(mand=Y) | 자유형 모양=PROC_000053/054 prcs_dtl_opt.모양. **합판도무송은 커팅에 형상 중복 입력 ✗(Q7★ — siz_cd가 칼틀 식별자)** | proc_cd FK | 052=반칼(054)·055=완칼(053)·058~062·066=스티커완칼(055), 공정 1줄 ✅ | 라이브·**Q7★**·benchmark §2 | 🟡 |
| 25 | 조각수(옵션) | **묶음수 + 공정 param(Q8 둘 다)** | ① `t_prd_product_bundle_qtys`(bdl_qty, bdl_unit_typ_cd=QTY_UNIT.01 EA) + ② 공정 prcs_dtl_opt.조각수 | **Q8★: 묶음수=권/세트 기준 · 조각수=판당 개수+제한. 둘 다 기록.** `*최대N조각`=상한, `★최소크기`=면적제약 | QTY_UNIT.01 EA | **부분 GAP: bundle_qtys 066만 5행(EA값), 나머지 조각수 미적재** | **실무진 Q8**·benchmark §3 | 🟡 |
| 26 | 제작수량>최소 | 수량하한 | `t_prd_products.min_qty` | 사이즈/조각수 종속→대표값 | — | 컬럼 존재 ✅ | 라이브·table-spec | ✅ |
| 27 | 제작수량>최대 | 수량상한 | `t_prd_products.max_qty` | 타투/소량=1000 | — | 컬럼 존재 ✅ | 라이브·table-spec | ✅ |
| 28 | 제작수량>증가 | 수량step | `t_prd_products.qty_incr` | 판걸이수 배수 | — | 컬럼 존재 ✅ | 라이브·table-spec | ✅ |
| 29 | 후가공>가변(텍스트) | 공정(VDP) | (스티커 미사용 — 빈값) | 적재 안 함 | — | 미적재 정합 | 엑셀 실측 | ✅ |
| 30 | 후가공>가변(이미지) | 공정(VDP) | (스티커 미사용 — 빈값) | 적재 안 함 | — | 미적재 정합 | 엑셀 실측 | ✅ |
| 31 | 추가상품>추가상품 | 추가상품 | (스티커 미사용 — 빈값) | 적재 안 함 | — | 미적재 정합 | 엑셀 실측 | ✅ |
| 32 | 추가상품>추가가격 | 가격 | (스티커 미사용 — 빈값) | 적재 안 함 | — | 미적재 정합 | 엑셀 실측 | ✅ |
| — | AG·AH·AI·AJ·AK | (빈컬럼) | **제외** | 전 행 None — 엑셀 잉여 컬럼 | — | — | 엑셀 실측 | ✅(제외) |

---

## CONFLICT 행 (4소스 불일치 — 침묵 선택 금지)

### CONFLICT-1 [🟡·HIGH] 코팅 귀속 — 실무진 Q9(공정) vs 라이브(자재)
- **실무진 Q9 ★ 확정:** 코팅 = **공정**(자재 아님). "상품명이 곧 상품(무광코팅스티커), 그 구성요소인 코팅은 공정으로 두고 생산이 강도 관리."
- **라이브 현실:** 무광코팅스티커(MAT_000155)·유광코팅스티커(MAT_000156)가 **자재**로 적재돼 PRD_000052/058~062/064/066에 `t_prd_product_materials`로 연결됨(usage=.07).
- **schema-design-intent-map:** §397·OM 정합 — 박/코팅=공정(Q2/Q9, 자재 아님). 마스터에 PROC_000013 코팅 존재(라이브 실측).
- **처분:** **실무진 Q9가 권위(권위순서 1위)** → 코팅을 PROC_000013 공정으로 적재하고, 자재 MAT_000155/156은 **비코팅 + 코팅공정 분해**로 정정해야 함. 단 이 정정은 **라이브 데이터 수정(자재행 정리)**을 수반 → round-4/5 적재본 + 인간 승인 트랙(본 라운드 매핑 확정만). 매핑 우변 = `t_proc_processes`(PROC_000013) + `t_prd_product_processes`.
- **컨펌 질문(CONFIRM-ST-A):** 코팅을 공정(Q9)으로 확정 시, 기존 자재 무광/유광코팅스티커(MAT_000155/156)는 (a) 비코팅 자재 + 코팅 공정으로 분해 (b) 자재 use_yn='N' 후 공정으로 이관 (c) 라이브 정정 별도 — 어느 방식? **가격표가 비코팅/무광/유광 3컬럼으로 갈리므로(가격=코팅별)** 코팅 공정 단가를 가격엔진에 어떻게 반영할지 동반 결정 필요.

---

## 잔존 컨펌 (🔴/🟡 — 인간/라이브 결정 대기)

### CONFIRM-ST-A [🟡·HIGH] (= CONFLICT-1) 코팅 공정 전환 시 자재행 운명 + 가격 반영
위 CONFLICT-1 참조.

### CONFIRM-ST-B [🟡] 조각수(C25) 이중 귀속 적재 형태 (Q8 미실현 GAP)
- **상황:** Q8★ = 묶음수 + 조각수 둘 다. 라이브는 bundle_qtys가 **합판도무송(066)에만 5행**(실제 형상별 EA), 나머지 상품 조각수(*최대20조각 등) 미적재. 공정 prcs_dtl_opt.조각수는 **상품 레벨 저장처 부재**(product_processes에 param 컬럼 없음 = OM-7/GAP-PARAM).
- **질문:** 조각수를 (a) bundle_qty(EA) + ref_param_json(조각수 param) 신설 후 둘 다 (b) bundle_qty만(현행 확장) — 어느 쪽? `*최대N조각`(상한 범위)의 저장 형태(단일값 vs min/max)는? **`ref_param_json` 미구현(OM-7)이 선결** → dbm-ddl-proposer 라우팅.

### CONFIRM-ST-C [🟡] 규격형 058~062 형상 enum 저장처 (GAP-PARAM 실증)
- **상황:** 반칼원형/정사각/직사각/띠지/팬시(058~062)가 PROC_000055 스티커완칼(조각수만, **모양 param 없음**)에 연결. 형상(원형/정사각 등)이 size에도 prcs_dtl_opt에도 product 레벨 저장처 없음 → **형상 enum이 어디에도 안 들어감**(round-11 "형상=prcs_dtl_opt.모양 권위" 미실현).
- **질문:** 규격형 형상을 (a) PROC_000054 반칼(모양 param 보유)로 공정 교체 + ref_param_json (b) size_nm에 형상 인코딩(합판도무송 방식 통일) (c) 현행 유지(형상=상품명 정체) — 어느 쪽? 합판도무송(칼틀 1:1=size)과 규격형(자유 형상=공정)의 모델 차이를 어떻게 일관되게 둘지.

### CONFIRM-ST-D [🟡] 인쇄방식(C13 폴더) DB 명시 여부
- **상황:** Q1로 폴더는 견적 제외 확정. 단 인쇄방식(디지털/실사/화이트/합판/전사)은 공정 백본 게이팅. 라이브는 root 공정 미적재(052는 반칼 1줄만, 인쇄 root 공정 없음).
- **질문:** 인쇄방식을 (a) root 공정(PROC_000004 토너/006 잉크젯 등) 적재로 암묵 표현 (b) 현행(커팅 공정만, 인쇄방식 무표현) — 어느 쪽? 현 라이브는 인쇄 root 공정 자체가 미적재.

> **CONFIRM-ST-C·D는 round-11 CONFIRM-ST-1/ST-4의 후속**이나, Q7(형상 size)·Q9(코팅 공정) 확정으로 **ST-1(합판도무송 형상)은 종결**(size 유지)·**ST-3(코팅)은 CONFLICT-1로 전환**. ST-5(파일명약어)는 Q1로 **종결**(견적 제외).

---

## round-11 → round-12 종결/전환 매트릭스

| round-11 컨펌 | round-12 처분 | 근거 |
|---------------|---------------|------|
| CONFIRM-ST-1(합판도무송 형상 size vs 공정) | **종결 — size 유지** | Q7★ + 가격표 형상×사이즈 격자 실측 |
| CONFIRM-ST-2(조각수 이중) | **유지 — CONFIRM-ST-B**(Q8 확정·라이브 미실현 GAP) | Q8★ + 라이브 bundle 1상품만 |
| CONFIRM-ST-3(코팅 자재 vs 공정) | **전환 — CONFLICT-1/CONFIRM-ST-A**(코팅=공정 확정, 라이브 자재와 충돌) | Q9★ |
| CONFIRM-ST-4(인쇄방식 귀속) | **유지 — CONFIRM-ST-D** | process-recipe-tree |
| CONFIRM-ST-5(파일명약어) | **종결 — 견적 제외** | Q1 |
| (신규)규격형 형상 저장처 | **신규 — CONFIRM-ST-C**(라이브 실측 발견) | live-crosscheck §3.2 |

---

## OM-1~7 재발 점검 (M4)

| OM 패턴 | 스티커 점검 | 판정 |
|---------|-------------|------|
| OM-1 색=siz | 별색(화이트)=공정(PROC_000008), siz에 색 미인코딩 | 재발 없음 ✅ |
| OM-2 size→option | 합판도무송 형상=칼틀 1:1로 **size가 정당**(Q7·가격표 입증) — option 오분류 아님 | 재발 없음 ✅ |
| OM-4 두께 소실 | 스티커=두께 무관(점착지) | 해당 없음 ✅ |
| OM-5 UV/별색 위치 | 별색=공정·도수칸 무침입 | 재발 없음 ✅ |
| **OM-7 공정 param 부재(GAP-PARAM)** | **재발 — 조각수·형상이 product 레벨 저장처 없음**(CONFIRM-ST-B·C) | **실증 → ddl-proposer** |

> 의미축 평면화(이중의미) 신규 재발 없음. 단 **GAP-PARAM(OM-7)이 조각수·규격형 형상에서 실증** — 매핑 오류가 아니라 스키마의 알려진 미구현(`ref_param_json`), dbm-ddl-proposer 트랙.

---

## 확정도 요약 (M1 빈칸 0)

- ✅ 확정: C1·C2·C3·C4·C5·C6·C7·C8·C9·C10·C11·C14·C15·C17·C18·C19~22·C26·C27·C28·C29·C30·C31·C32 + AG~AK(제외) = **25항목**
- 🟡 부분/CONFLICT: C12(파일포맷)·C13(인쇄방식)·C16(코팅 CONFLICT)·C23(코팅 공정)·C24(형상 저장처)·C25(조각수 GAP) = **6**
- 🔴 미수록: **0** (전 컬럼 매핑 경로 또는 명시적 제외/GAP/CONFLICT로 귀결)

**빈칸 0 달성** — 32 데이터 컬럼 + 5 빈컬럼 전부 의미축·목표 t_*·확정도·라이브 실측을 가진다. 🟡 6건은 모두 컨펌 질문(CONFIRM-ST-A~D) 동반.
