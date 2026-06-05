# calendar + design-calendar 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/calendar.md`(G-CL-1~6)·`design-calendar.md`(G-DC-1~5)의 ⑤ 처리방향을
> FK 순서 적재 설계 + 적재용 CSV로 변환. digital-print 파일럿(`09_load/digital-print/`)과 동일 메서드.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + update-set CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/calendar-l1.csv`·`design-calendar-l1.csv`) = 상품별 진실 · ref 마스터
> (`00_schema/ref-*.csv`, **stale 2026-06-04 주의**) · IMPORT 매트릭스(`06_extract/import-paper-matrix-long.csv`).
> 추정 0 — 모든 행은 L1 셀 또는 ref/IMPORT 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위(binding):** `_confirmations.md` **C-2**(calendar 택일=멤버연결 SEL_TYPE.01)·**C-5**(design-calendar=editor_yn
> 플래그, 별도상품 아님)·**C-6**(거치대=addon 맥락별)·**C-3**(IMPORT 자재)·**C-4**(캘린더=EA)·C-8(과세분화 금지).

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 성격 | 결함 | 행수 |
|------|------------|------|------|:----:|
| `load/t_prd_product_materials.csv` | t_prd_product_materials | INSERT | G-CL-4 IMPORT 종이 | **43** |
| `t_prd_product_materials_conditional.csv` | (보류) | 보류 | **라이브 기적재 중복PK 4행**(MAT_000107 몽블랑190g, 108/109/110/111) | **4** |
| `load/t_prd_product_processes_excl_link_update.csv` | t_prd_product_processes (UPDATE) | UPDATE | G-CL-1 택일 멤버 연결 **[BLOCKER 부분해소]** | **4** |
| `load/t_prd_product_process_excl_groups_note_update.csv` | t_prd_product_process_excl_groups (UPDATE) | UPDATE | G-CL-3 우드거치대 이중분류 정정 | **1** |
| ~~`load/t_prd_products_editor_yn_update.csv`~~ **철회** → `_deferred/t_prd_products_editor_yn_update_WITHDRAWN.csv` | ~~t_prd_products (UPDATE)~~ | **철회(2026-06-05)** | ~~G-DC-1~~ design-calendar=신규 별도 prd_cd 등록(`09_load/design-calendar/`)으로 분리 | **0**(active) / 5(이력) |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | UPDATE | G-CL-6 qty_unit | **5** |
| `t_prd_product_processes_excl_member_flag.csv` | (flag) | 보류 | G-CL-1/2 비명칭 멤버(발명 금지) | 6 |
| `material_misaxis_flag.csv` | (flag) | 보류 | 삼각대/링 mis-axis 자재(삭제 금지) | 6 |
| `_deferred/page_rule_ringcolor_deferred.csv` | (보류) | 보류 | G-CL-5/G-DC-4 장수·페이지·링칼라 | 12 |

> **보정 이력(2026-06-05, NO-GO→재산출):** dbm-validator 독립검증이 material 47행 중 4행(MAT_000107 몽블랑190g, PRD_000108/109/110/111)을
> **라이브 기적재 → INSERT 시 중복PK 충돌**로 적발(NO-GO 사유). 충돌 4행을 digital-print 016 conditional 패턴으로
> `t_prd_product_materials_conditional.csv`로 **이동**(active 47→43). `verify_expected.py`의 R3-material 기대치를
> 라이브 충돌 반영(LIVE_COLLISION_MAT 제외)해 **47→43** 갱신 → 게이트 재PASS(exit 0). 적재 직전 라이브-export 재실행으로 conditional 4행 최종 판정(부재 시 active 승격·실재 시 폐기).

생성기 `gen_load.py`(재현 가능) · 검증 `verify_expected.py`(게이트 **PASS, exit 0**, §7).

> **[정정 2026-06-05] design-calendar 처리 분리·editor_yn UPDATE 철회**(HARD): 라이브 재SELECT 결과
> **113~117 부재·캘린더 108~112=업로드 전용(editor_yn=N 정상)**. design-calendar="108~112 공유 variant"는 해석 오류.
> 디자인캘린더는 **사이즈 차이(엽서 6→1, 벽걸이 3→1)** 때문에 단일 prd_cd로 표현 불가 → **신규 별도 prd_cd 등록 대상**(후니 (N,Y) 선례=스티커팩·포토북[디자인명]·먼슬리플래너). 신규 등록 설계는 **`09_load/design-calendar/load-spec.md`로 분리**.
> 본 calendar 산출물에서 **`t_prd_products_editor_yn_update.csv` 4행(108/109/111/112 N→Y) 철회**(active 제거 → `_deferred/t_prd_products_editor_yn_update_WITHDRAWN.csv`에 사유 보존, 삭제 아님). `verify_expected.py`의 C5-editor_yn 게이트·신규행0 가드의 editor_yn 참조 제거. **calendar(108~112)는 일반 업로드 캘린더 적재만 유지(material 43·excl_link 4·qty 5) — design-calendar 제외 후 게이트 재PASS(exit 0).**

---

## 1. 상품 범위 — calendar/design-calendar 공유 (라이브 권위)

| prd_nm | prd_cd | prd_typ | use_yn | editor_yn(현행) | calendar | design-calendar |
|--------|:------:|:-------:|:------:|:--------------:|:--------:|:---------------:|
| 탁상형캘린더 | PRD_000108 | .04 디자인상품 | Y | N | ● | ● (디자인보유●) |
| 미니탁상형캘린더 | PRD_000109 | .04 | Y | N | ● | ● (디자인보유●) |
| 엽서캘린더 | PRD_000110 | .04 | Y | N | ● | ● (시트 등장·디자인보유● **비표시**) |
| 벽걸이캘린더 | PRD_000111 | .04 | Y | N | ● | ● (디자인보유●) |
| 와이드벽걸이캘린더 | PRD_000112 | .04 | Y | N | ● | ● (디자인보유●) |

- **calendar 시트 = 108~112(라이브 실재 업로드 캘린더).** design-calendar 시트의 5상품도 prd_nm으로는 108~112와 매칭되나(113~117 부재) — **[정정 2026-06-05] 사이즈 셋이 다르므로 공유 variant가 아니라 신규 별도 prd_cd 등록 대상**(`09_load/design-calendar/`). DB에 디자인캘린더 별도 상품 **미적재(0건) → 신규 등록 필요.**
- **use_yn=N 없음**(전 5상품 Y) → deferred(비활성) 분리 대상 없음. 그레이밴딩(C-1 미출시) 해당 없음.
- design-calendar 차이 = 디자인보유●·가격포함·고정페이지·종이 직접명(몽블랑190g)·**사이즈 셋 다름(엽서 6→1, 벽걸이 3→1)**. → ~~editor_yn 플래그로 인코딩~~ **[정정 2026-06-05] 신규 별도 prd_cd로 인코딩**(사이즈 차이로 단일 prd_cd 표현 불가 — `09_load/design-calendar/`). 108~112 editor_yn=N 유지(업로드 전용 정상).

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`·excl_group 헤더)는 건전 → **상품 연결 테이블 INSERT + 컬럼 UPDATE만**.

```
① qty_unit UPDATE (t_prd_products)           — 컬럼 업데이트, FK 무관, 독립
② [철회 2026-06-05] editor_yn UPDATE         — design-calendar 공유 variant 해석 오류로 철회. 디자인캘린더는 신규 별도 prd_cd(09_load/design-calendar/). 본 calendar 적재에서 제외
③ material INSERT (R3 IMPORT, active 43)     — FK: prd_cd→t_prd_products, mat_cd→t_mat. excl_grp 연결 선행 불요. MAT_000107 충돌 4행 conditional 분리
④ process excl_grp_cd UPDATE (R1 BLOCKER)    — 기적재 process행 갱신. FK: excl_grp_cd→excl_group 헤더(110/111/112 적재됨)
⑤ excl_group note UPDATE (R4 거치대 정정)     — excl_group 헤더 갱신(우드거치대 trigger 제거)
⑥ page_rule / 링칼라                          — DEFERRED(G-CL-5/G-DC-4 CONFIRM, 발명 금지)
```

**UPDATE성과 INSERT성의 분리(HARD):**
- **excl_grp_cd 연결(④)·qty_unit(①)·excl_group note(⑤)** = 기존 행/컬럼 **UPDATE** → 별도 `*_update.csv`
  (현재값 `current_*` + 목표값 `target_*` + `_provenance`). INSERT 아님. (~~editor_yn(②)~~ 철회 — 디자인캘린더 신규 별도 prd_cd 분리)
- **material(③)만 INSERT** = 신규 연결 행. PK=(prd_cd, mat_cd, usage_cd). **active 43행만 INSERT** — MAT_000107(몽블랑190g)
  4행은 라이브 기적재(중복PK)라 `t_prd_product_materials_conditional.csv`로 분리(적재 직전 라이브 재확인 후 폐기/승격).

**no-op 단계와 사유:**
- **excl_group 헤더 신설 INSERT 없음**: 110/111/112 헤더 기적재(GRP-CAL-가공). 108/109 헤더 0행은 **삼각대 단일 가공이라
  택일그룹 불요인지 신설인지 CONFIRM**(컨펌Q-2) → 신설 INSERT 보류(발명 금지).
- **112 material no-op**: 와이드벽걸이는 `*별도설정` 아닌 **직접명**(스노우지/몽블랑 3절). 3절 자재 3종 + 링블랙 기적재 →
  IMPORT 적재 대상 아님(중복 회피). G-DC-2 종이 고정↔IMPORT 혼재의 정합 지점.
- **page_rule 전무**: 장수/페이지 인코딩 미확정(CONFIRM) → deferred.

④가 ③ 뒤·⑤가 ④ 뒤인 이유: excl_grp_cd UPDATE는 excl_group 헤더(이미 적재)를 FK로 가리키며, note 정정(⑤)은 멤버 연결(④)
확정 후 trigger를 재지정해야 정합.

---

## 3. 결함별 적재 설계

### R3 (High) — 자재 IMPORT 종이 [material INSERT 43행 active + 4행 conditional, G-CL-4]

**도메인 근거(R-MAT-2, C-3 binding):** 엑셀 `종이사양 = *별도설정`은 빈값이 아니라 가격표 `출력소재(IMPORT)`에 실자재가
정의됨의 포인터. 원적재가 이를 제외해 IMPORT 종이 전량 누락(탁상형8·미니7·엽서10·벽걸이22종 중 0행 적재).

**변환 로직 (IMPORT → DB):**
| 단계 | 입력 | 출력 |
|------|------|------|
| 1 | IMPORT 매트릭스 `product_col`(탁상형캘린더 등)+`mark=●` | 상품별 ●종이 리스트 |
| 2 | `paper_name`("스노우지 200g") → `t_mat.mat_nm` 정확매치 | `mat_cd`(MAT_000090) |
| 3 | (prd_cd, mat_cd, usage_cd=USAGE.07, dflt_yn, disp_seq) | t_prd_product_materials 행 |

- `usage_cd = USAGE.07(공통)` — 캘린더는 내지/표지 분해 없는 단일슬롯. 기존 정상 자재(112 직접명 종이)가 USAGE.07이라 컨벤션 정합.
- `dflt_yn = Y`(disp_seq 1), 나머지 N. `disp_seq` 1부터.

**IMPORT 커버리지 (4상품, exact 매치 100%) — IMPORT매칭 / active(충돌제외) / conditional:**
| prd_cd | 상품 | IMPORT 컬럼 | IMPORT매칭 | active | conditional(MAT_000107) | 매칭 |
|--------|------|------------|:----------:|:------:|:------------------------:|:----:|
| 108 | 탁상형캘린더 | 탁상형캘린더 | 8 | 7 | 1 | 8/8 exact |
| 109 | 미니탁상형캘린더 | 미니탁상형캘린더 | 7 | 6 | 1 | 7/7 exact |
| 110 | 엽서캘린더 | 엽서캘린더 | 10 | 9 | 1 | 10/10 exact |
| 111 | 벽걸이캘린더 | 벽걸이캘린더 | 22 | 21 | 1 | 22/22 exact |
| **112** | 와이드벽걸이캘린더 | (직접명) | — | — | — | 3절 3종+링 **기적재** no-op |
| **합계** | | | **47** | **43** | **4** | exact 100% |

- **IMPORT 매칭 47행, exact 100%**(fuzzy 0, unmatched 0). 추정·날조 없음.
- **active 적재 = 43행** (47 − 라이브충돌 4). **conditional 보류 = 4행**: MAT_000107(몽블랑190g)이 108/109/110/111에
  **라이브 기적재**(dbm-validator 2026-06-05 SELECT 확인). stale ref(2026-06-04)엔 미적재라 원설계가 47 전량을 신규로
  과대기대 → INSERT 시 중복PK 충돌. 충돌 4행을 `t_prd_product_materials_conditional.csv`로 이동(016 패턴), active 43.
- **conditional 4행 처리:** 적재 직전 라이브-export로 `verify_expected.py` 재실행 → 라이브에 MAT_000107 여전히 실재하면
  **폐기(이력 보존)**, 부재로 확인되면 **active 승격**. 발명·추정 0(IMPORT 라인 추적된 실종이).

> **provenance 예:** `IMPORT:탁상형캘린더● 스노우지 200g→MAT_000090 (R3 G-CL-4, seoljeong-import-map)`

---

### R1 (High, **BLOCKER 부분해소 + 컨펌**) — 택일그룹 멤버 연결 [process excl_grp_cd UPDATE 4행, G-CL-1]

> **[정직 표기 — H5 판정 정정, 2026-06-05]** 본 4행 UPDATE는 BLOCKER를 **"해소"가 아니라 "부분해소(PARTIAL)"**한다.
> dbm-validator 독립검증(waveB1 §3-C) 판정: **110·112는 SEL_TYPE.01(max_sel_cnt=1) 택일그룹에 멤버가 1개만 연결**되어
> 기능상 "택일"이 성립하지 않는다(선택지 1개 택일 = 빈 택일과 동치, 위젯 택일 UI에 단일 옵션만 노출).
> 명목상 FK는 연결됐으나 **기능 완결은 미연결 멤버 6종의 컨펌(Q-1·Q-2) 선결**에 의존한다. → 본 적재만으로 H5 종결 금지.

| prd_cd | 연결 멤버(load) | 미연결 멤버(flag) | 연결 후 멤버수 | 택일 성립 |
|--------|----------------|------------------|:-------------:|:---------:|
| 110 엽서 | PROC_000079(타공) | 가공없음·우드거치대 | **1** | ⚠ 미성립 |
| 111 벽걸이 | PROC_000021·PROC_000079 | 가공없음 | **2** | ✅ 성립 |
| 112 와이드 | PROC_000021 | 제본없음 | **1** | ⚠ 미성립 |
| 108 탁상형 | (excl 헤더 0행) | 삼각대 | **0**(헤더 부재) | n/a(Q-2) |
| 109 미니탁상 | (excl 헤더 0행) | 삼각대 | **0**(헤더 부재) | n/a(Q-2) |

**도메인 근거(C-2 binding · entity-semantic-model #5):** `캘린더가공` = 공정 택일(SEL_TYPE.01 단일). process_excl_group은
**헤더(택일그룹) + 멤버 FK(excl_grp_cd) 둘 다** 필요. 라이브는 GRP-CAL-가공 헤더(110/111/112)만 적재, **모든 캘린더
process행의 `excl_grp_cd`가 NULL** → UI 택일이 멤버 없는 빈 그룹(위젯 선결 결함).

**처리 성격 = UPDATE(INSERT 아님):** 멤버 process(타공079·트윈링021)는 **이미 적재**됨. 결함은 그 행의 `excl_grp_cd`가
NULL인 것 → 기존 행 갱신. 별도 `*_excl_link_update.csv`(current `NULL` + target `GRP-CAL-가공` + provenance).

**연결 대상 (라이브 기적재 멤버, calendar.md ③ 권위):**
| prd_cd | proc_cd | proc_nm | 택일 의미 | current→target |
|--------|:-------:|---------|----------|----------------|
| 110 | PROC_000079 | 타공 | 1구타공+끈 | NULL → GRP-CAL-가공 |
| 111 | PROC_000021 | 트윈링제본 | 고리형트윈링 | NULL → GRP-CAL-가공 |
| 111 | PROC_000079 | 타공 | 2구타공+끈 | NULL → GRP-CAL-가공 |
| 112 | PROC_000021 | 트윈링제본 | 고리형트윈링 | NULL → GRP-CAL-가공 |

- `mand_proc_yn`은 **N 유지**: 택일그룹 헤더(SEL_TYPE.01, mand_yn=Y)가 "반드시 하나 선택"의 필수성을 담당.
  멤버 개별은 택일 후보라 비필수 — 둘 다 N으로 두는 게 정합(택일그룹 의미축).

**비명칭 멤버 = 연결 불가(발명 금지) → flag (`t_prd_product_processes_excl_member_flag.csv` 6행):**
| prd_cd | 멤버 라벨 | 사유 |
|--------|----------|------|
| 110 | 가공없음(재단만) | master proc_cd 부재(택일 멤버 "없음") |
| 110 | 우드거치대 | =addon(PRD_000012) 단일축(G-CL-3) — process 멤버 아님 |
| 111 | 가공없음(재단만) | master proc_cd 부재 |
| 112 | 제본없음(재단만) | master proc_cd 부재 |
| 108 | 삼각대(그레이) | master proc_cd 부재 + 108 excl_group 헤더 0행 |
| 109 | 삼각대(블랙) | master proc_cd 부재 + 109 excl_group 헤더 0행 |

→ **추정으로 proc_cd 발명 금지.** "가공없음"/"제본없음"은 택일 UI에서 "선택 안 함" 의미일 수 있어 별도 proc 신설 자체가
미확정(컨펌Q-1). 삼각대/우드거치대 = 거치대(C-6 addon) 후보 → process 멤버로 강제 적재 안 함.

> **provenance 예:** `라이브 process행 excl_grp_cd NULL → GRP-CAL-가공 연결 (타공079=1구타공+끈 택일멤버) (R1 G-CL-1 BLOCKER, C-2)`

---

### R4 (Medium) — 우드거치대 이중분류 정정 [excl_group note UPDATE 1행, G-CL-3]

**라이브 사실:** 110 excl_group note `trigger=우드거치대`(공정 택일 멤버 신호) ↔ 110 addon에 `우드거치대`(PRD_000012) 적재.
**동일 옵션이 공정 택일 + 추가상품 두 축에 이중 분류.**

**처리(C-6 binding · entity-model #9):** 거치대 = **addon 단일축**(부속 거치대 독자판매). → excl_group note의 trigger를
우드거치대에서 **process 멤버(1구타공+끈=타공079)**로 정정. **addon 행(PRD_000012)은 유지(삭제 금지).**

| prd_cd | excl_grp_cd | current_note | target_note |
|--------|:-----------:|-------------|-------------|
| 110 | GRP-CAL-가공 | trigger=우드거치대 | trigger=1구타공+끈 (우드거치대=addon PRD_000012로 분리) |

- **삭제 0**: addon 우드거치대 행은 정상(C-6 거치대=addon) → 보존. note만 정정.

> **provenance:** `우드거치대 이중분류(excl trigger ↔ addon) 정정: addon 단일축 유지, trigger를 process 멤버(타공)로 (R4 G-CL-3, C-6)`

---

### C-5 — design-calendar [**철회·재정의 2026-06-05**: 108~112 editor_yn UPDATE 철회 → 신규 별도 prd_cd 등록(별도 설계)]

> **🔴 [라이브 정정 2026-06-05]** 본 섹션의 기존 처리("108~112 editor_yn=Y UPDATE")는 **철회**한다. 사유:
> - **라이브 read-only SELECT 확증:** 113~117 부재·캘린더 108~112는 `(file_upload_yn=Y, editor_yn=N)` = **업로드 전용이 정상**. 108~112를 editor_yn=Y로 바꾸면 라이브 정상값을 오염시킨다.
> - **공유 variant 해석 오류:** design-calendar는 calendar와 prd_cd 108~112를 공유하는 variant가 **아니다**. 디자인캘린더는 **사이즈 셋이 다르다**(엽서 디자인 145×145 1종 vs 업로드 110=6종, 벽걸이 디자인 210×297 1종 vs 업로드 111=3종 — L1 권위). 모드별 사이즈가 다르면 단일 prd_cd로 표현 불가.
> - **후니 선례:** 후니는 "디자인 제공으로 옵션이 달라지는" 상품을 **별도 prd_cd**로 둔다(라이브 (N,Y)=3건=스티커팩 PRD_000065·포토북[디자인명] PRD_000100·먼슬리플래너 PRD_000176, 업로드본과 별개 prd_cd·이름 구분).
>
> **재정의:** 디자인캘린더(5상품)는 **신규 별도 prd_cd로 등록**한다 — 설계는 **`09_load/design-calendar/load-spec.md`로 분리**(placeholder `PRD_NEW_DCAL_1~5`, 실제 prd_cd는 적재 시 후니가 라이브 max 280 이후로 부여 — 발명 금지). 신규 마스터 INSERT는 **DB 쓰기라 별도 승인 필요**.

**철회 처리(삭제 아님·이력 보존):** `load/t_prd_products_editor_yn_update.csv` 4행(108/109/111/112 N→Y)을 active load에서 제거하고 `_deferred/t_prd_products_editor_yn_update_WITHDRAWN.csv`에 **철회 사유와 함께 보관**. `verify_expected.py`의 `C5-editor_yn` 게이트 + 신규행0 가드의 editor_yn 참조 제거(qtyunit만 유지). calendar 게이트 재PASS(exit 0).

- **110 셀 모호(과거 flag)는 이제 무관:** 디자인캘린더가 신규 별도 prd_cd로 가므로, 110 엽서의 "디자인보유● 비표시" 셀 모호는 **108~112 UPDATE 여부와 무관**. 신규 디자인엽서캘린더(`PRD_NEW_DCAL_3`)는 L1 가격·고정페이지·종이로 등록되며, "디자인보유 ● 비표시"는 신규 등록 설계의 컨펌 항목으로 이관(design-calendar/load-spec.md).
- **calendar 108~112 영향 없음:** 본 철회로 calendar(108~112)는 editor_yn=N(라이브 정상) 그대로 유지. material 43·excl_link 4·qty 5만 적재.

---

### R6 (Medium) — qty_unit 일괄 부여 [UPDATE 5행, G-CL-6]

- **C-4 binding:** "상품군별 기본 일괄 부여". 캘린더 → **QTY_UNIT.01(EA)**(code-values 확인: .01=EA).
- **UPDATE-class:** `t_prd_products.qty_unit_typ_cd` 컬럼 갱신(라이브 현재 전 NULL). current `NULL` + target `QTY_UNIT.01`.
- **대상:** 캘린더 5상품 전건. 글로벌 갭(272 전상품 NULL) 중 캘린더 한정.

| prd_cd | current | target |
|--------|:-------:|:------:|
| 108~112 | NULL | QTY_UNIT.01 (EA) |

---

### R5 (DEFERRED) — 장수/페이지(page_rule) · 링칼라 조건부 [보류 12행, G-CL-5/G-DC-4]

**발명 금지 → 전부 deferred + CONFIRM (`_deferred/page_rule_ringcolor_deferred.csv`):**
- **calendar 장수(다중):** `4(8P)/8(16P)/12(24P)…` = 달력 월수↔페이지. **variant인가 page_rule(min/max)인가 미확정**(G-CL-5).
  `4(8P)`형은 장수4=8페이지 = 변형 옵션에 가까우나 단정 불가.
- **design-calendar 페이지(단일 고정):** `30P/26P/12P/13P` 고정 → page_rule(min=max) 자연스러움. **[정정 2026-06-05] 신규 별도 prd_cd로 등록되므로 calendar(108~112)와 페이지 셋 충돌 없음** — 디자인캘린더 신규 prd_cd에 page_rule(min=max=30/26/12/13) 직접 적재(설계는 `09_load/design-calendar/`). ~~editor_yn 분기 의존~~ 불요.
- **링칼라 조건부:** `★고리형트윈링제본선택시만 : 링칼라선택`(111/112) = 고리형트윈링(proc) 선택을 부모로 하는 **조건부 자식**.
  트윈링 proc param vs 별도 옵션 인코딩 미확정(G-CL-5). 라이브엔 링칼라가 자재(MAT_000253 링블랙)로 기적재(mis-axis, §5).

---

## 4. 코드·제약 정합 (적재 가능성 검증)

| 코드/제약 | 값 | 출처 | 적재 정합 |
|----------|-----|------|----------|
| SEL_TYPE.01 | 단일(택일) | code-values | GRP-CAL-가공 sel_typ_cd 정합 |
| QTY_UNIT.01 | EA | code-values | R6 target 정합 |
| USAGE.07 | 공통 | digital-print 컨벤션 | R3 material 정합 |
| GRP-CAL-가공 | 헤더 110/111/112 적재 | ref-excl-groups | R1 excl_grp_cd FK 타깃 실재 |
| editor_yn | char(1) NOT NULL | columns.csv #12 | ~~C-5 UPDATE~~ **철회**(2026-06-05): calendar 108~112 editor_yn=N 유지. 디자인캘린더는 신규 별도 prd_cd 등록 시 editor_yn=Y(09_load/design-calendar/) |
| 우드거치대 | PRD_000012 (PRD_TYPE.03) | ref-products | C-6 addon 단일축 정합 |

**캐스케이드 제약(benchmark §9):** 캘린더 L1에 **자재→공정 disable 신호 없음**(digital-print의 "180g이상 코팅가능" 같은 셀 주석
부재) → 캘린더 캐스케이드 제약 신설 대상 없음(발명 금지, no-op).

---

## 5. mis-axis 자재 정정 — 삭제 금지 flag (`material_misaxis_flag.csv` 6행)

**라이브 사실:** 108/109 기적재 "material" = `삼각대(그레이)MAT_000252`·`삼각대(블랙)MAT_000254`·`링블랙MAT_000253`.
이는 **종이가 아니라 거치대(addon 축)·링칼라(process param 축)** — 원적재가 거치대/링을 material로 잘못 분류(축 오류).

- **EXTRA 삭제 절대 금지(HARD):** 행 삭제 제안 0. **flag로 축 정정만 권고**(컨펌).
  - 삼각대 → addon/process(거치대) 후보(C-6 거치대=addon).
  - 링블랙 → process param(링칼라, 트윈링 자식, G-CL-5).
- **112 3절 종이(MAT_000093/111/112)는 mis-axis 아님** — 실제 종이(직접명) → 정상 보존, flag 제외.

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **Q-1 [택일 H5 완결 선결]** | 택일 비명칭 멤버(가공없음/제본없음/우드거치대/삼각대) | flag(미적재·발명 금지) | **110·112 택일그룹이 멤버 1개라 기능상 미성립**(H5 PARTIAL). 미연결 6종을 추정 proc로 메우지 않음 — "가공없음"·"제본없음"에 신규 proc_cd 부여인가, UI "선택 안 함"(proc 없이)인가? 거치대(삼각대/우드)·삼각대는 addon으로 단일화? **이 답이 110/112 택일을 ≥2멤버로 완성하는 선결 조건.** |
| **Q-2** | 108/109 excl_group 헤더 0행 | 신설 보류 | 삼각대 단일 가공이라 택일그룹 불요인가, GRP-CAL-가공 헤더 신설해야 하는가? (라이브 헤더 0행 확정) |
| **Q-3 [철회·이관 2026-06-05]** | ~~110 엽서 editor_yn~~ | **calendar에선 무관**(108~112 editor_yn=N 유지) | editor_yn UPDATE 철회로 본 Q는 calendar 범위 밖. 디자인엽서캘린더(신규 `PRD_NEW_DCAL_3`)의 "디자인보유● 비표시" 셀 모호는 **`09_load/design-calendar/` 신규 등록 설계의 컨펌 항목**으로 이관. |
| **Q-4** | 장수(calendar) page vs variant | deferred | `4(8P)/8(16P)…` 장수 = page_rule(min/max)인가 선택 variant인가? |
| **Q-5** | design-calendar 페이지(고정) 적재 | deferred | `30P/26P/12P/13P` 고정 페이지를 page_rule(min=max)로? editor_yn 분기 후 자재(몽블랑190g 단일) 제약과 함께? |
| **Q-6** | 링칼라 조건부 인코딩 | deferred(mis-axis flag) | 링칼라(★고리형트윈링선택시만)를 트윈링 proc param vs 별도 옵션? 현재 자재(링블랙)로 mis-axis 적재됨 |
| **Q-7** | 삼각대/링 mis-axis 자재 | flag(삭제 안 함) | 거치대/링을 material에서 addon/process param으로 축 정정? (삭제 없이 재분류) |
| **Q-8 [신규]** | material MAT_000107 4행 라이브 충돌 | conditional 보류(active 제외) | 적재 직전 라이브-export에서 108/109/110/111의 MAT_000107이 여전히 실재하면 conditional 4행 **폐기**, 부재면 **active 승격**. (라이브 SELECT 1회로 즉시 판정) |

> **Q-2·Q-8은 라이브 SELECT 1회로 즉시 해소 가능**(108/109 excl_group 실태·MAT_000107 충돌 재확인). **Q-3은 철회·이관**(editor_yn UPDATE 철회 — 디자인캘린더 신규 별도 prd_cd로 `09_load/design-calendar/`).
> **Q-1은 도메인 컨펌 필수** — 라이브 조회로 안 풀림(택일 멤버 모델링 결정). **Q-1 미해소 = 110/112 택일 H5 미완(BLOCKER 잔존).**

---

## 7. 자기검증 게이트 (재실행: `python3 09_load/calendar/verify_expected.py`)

```
=== SELF-CHECK (calendar+design-calendar) ===
label                      exp   act  miss  extra  result
R3-material(IMPORT)         43    43     0      0  PASS
R1-excl_link(UPDATE)         4     4     0      0  PASS
R6-qtyunit(EA)               5     5     0      0  PASS
design-cal-신규행0              0     -     -      0  PASS
FK-existence                 -     -     -      0  PASS

GATE: PASS — 누락0·날조0·신규행0   (exit 0)
```

**실행 확인:** **2026-06-05 design-calendar editor_yn UPDATE 철회 후** `verify_expected.py` 재실행 → **exit 0, 전 게이트 PASS**.
`C5-editor_yn(●→Y)` 게이트는 **철회**(디자인캘린더 신규 별도 prd_cd 분리 — `09_load/design-calendar/`가 신규 등록 검증 담당).
R3-material **43**=라이브충돌 4행 conditional 제외. 상세 원리·stale 한계·보정 이력은 `expected-vs-load.md`.

---

## 8. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 기적재 판정(material 중복·process 멤버·excl_group 헤더·editor_yn 현재값)에 사용.
- **stale가 판정을 뒤집을 수 있는 지점:**
  1. **excl_grp_cd 연결(R1)** — stale ref가 110/111/112 process행 excl_grp_cd=NULL을 보임. 라이브가 이미 연결됐으면 UPDATE 불요(no-op).
  2. **material 중복(R3)** — **[실현됨, 2026-06-05]** stale ref가 108~111 IMPORT 종이 0행을 보였으나 라이브엔 MAT_000107(몽블랑190g)이
     108/109/110/111 기적재 → **중복 PK 충돌 4행 실제 발생**(dbm-validator 적발). 해당 4행 conditional 이동(active 47→43)으로 해소. stale 위험이 실제로 터진 지점.
  3. **editor_yn 현재값(C-5)** — stale ref가 전 5상품 N. 라이브가 이미 Y면 UPDATE 불요.
  4. **108/109 excl_group 헤더** — stale=0행. 라이브가 신설됐으면 Q-2 즉시 해소.
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0·신규행0**"(자기검증 PASS).
