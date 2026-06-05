# design-calendar(디자인캘린더) 신규 별도 prd_cd 등록 설계서 (load-spec)

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **분리 사유:** calendar 적재설계(`09_load/calendar/`)가 design-calendar를 "108~112 editor_yn=Y UPDATE 공유 variant"로 잘못 처리했음.
> 라이브 read-only SELECT(2026-06-05) 확증으로 **철회**하고, 디자인캘린더를 **신규 별도 prd_cd 등록**으로 재설계한 별도 산출물.
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 신규 마스터 INSERT는 **별도 승인 후**. 산출 = 적재용 CSV + flag + 자기검증 스크립트뿐.

---

## 0. 라이브 권위 (이 설계의 토대 — HARD)

라이브 read-only SELECT(2026-06-05) 확증:
- **캘린더는 라이브에 PRD_000108~112만 존재**(전부 `file_upload_yn=Y, editor_yn=N` = 업로드 전용). **113~117 부재**(라이브 272 상품, `max prd_cd=PRD_000280`).
- 이전 `ref-products.csv` 추출본의 113~117 행은 **stale/오염(가짜)** — 라이브 부재가 진실.
- 라이브 `(file_upload_yn, editor_yn)` 분포: (N,N)=50·(N,Y)=**3**·(Y,N)=105·(Y,Y)=114.
- **(N,Y)=3건 = 디자인 제공 별도 상품 선례:** PRD_000065 스티커팩·PRD_000100 포토북[디자인명]·PRD_000176 먼슬리플래너(업로드본과 별개 prd_cd, 이름 구분).
- **결론:** 후니는 "디자인 제공으로 옵션이 달라지는" 상품을 별도 prd_cd(`file_upload_yn=N, editor_yn=Y`)로 둔다. 디자인캘린더도 이 선례를 따라야 하나 **현재 미적재 → 신규 등록 대상**.

**왜 공유 variant(editor_yn UPDATE)가 아닌가:** design-calendar-l1과 calendar-l1을 비교하면 **사이즈 셋이 다르다**:
| 캘린더 | 업로드 사이즈 수(라이브) | 디자인 사이즈(L1) |
|---|:---:|:---:|
| 엽서 (110) | 6 | **145×145 1종** (6→1) |
| 벽걸이 (111) | 3 | **210×297 1종** (3→1) |
| 탁상형 (108) | 2 | 220×145 1종 |

모드별 사이즈가 다르면 단일 prd_cd로 표현 불가(디자인 모드일 때만 사이즈 축소하는 장치 = constraint_json 캐스케이드 = 272 전 NULL = 미구현). → **별도 prd_cd 신설이 자연.**

---

## 1. 신규 5상품 (placeholder prd_cd — 발명 금지)

> **prd_cd는 placeholder `PRD_NEW_DCAL_1~5`** — 실제 prd_cd는 적재 시 **후니가 라이브 max(PRD_000280) 이후로 부여**한다(번호 발명 금지). 명명은 후니 (N,Y) 선례 `포토북[디자인명]` 방식을 참조해 "디자인+캘린더명"으로 둠.

| placeholder | prd_nm(제안) | _src_prd_nm(L1) | file_upload_yn | editor_yn | prd_typ_cd | qty_unit |
|---|---|---|:---:|:---:|:---:|:---:|
| PRD_NEW_DCAL_1 | 디자인탁상형캘린더 | 탁상형캘린더 | N | **Y** | PRD_TYPE.04 | QTY_UNIT.01 (EA) |
| PRD_NEW_DCAL_2 | 디자인미니탁상형캘린더 | 미니탁상형캘린더 | N | **Y** | PRD_TYPE.04 | QTY_UNIT.01 |
| PRD_NEW_DCAL_3 | 디자인엽서캘린더 | 엽서캘린더 | N | **Y** | PRD_TYPE.04 | QTY_UNIT.01 |
| PRD_NEW_DCAL_4 | 디자인벽걸이캘린더 | 벽걸이캘린더 | N | **Y** | PRD_TYPE.04 | QTY_UNIT.01 |
| PRD_NEW_DCAL_5 | 디자인와이드벽걸이캘린더 | 와이드벽걸이캘린더 | N | **Y** | PRD_TYPE.04 | QTY_UNIT.01 |

- **`(file_upload_yn=N, editor_yn=Y)`** = 라이브 (N,Y) 선례 패턴(편집기 전용 디자인 제공). 업로드 108~112(Y,N)와 별개.
- min_qty=1, max_qty=10000, qty_incr=1 (L1 제작수량 셀). `t_prd_products.csv` 참조.

---

## 2. 9속성 = 디자인 고정 셋 (L1 셀 추적 provenance, 추정 0)

| 속성 | 테이블 | 적재 내용(L1 근거) | 행수 | flag |
|---|---|---|:---:|---|
| size | `load/t_prd_product_sizes.csv` | 디자인 사이즈 1종(220×145=SIZ_000069·90×100=SIZ_000018·145×145=SIZ_000072·210×297=SIZ_000050·300×625=SIZ_000077) | **5** | — |
| material | `load/t_prd_product_materials.csv` | 몽블랑190g 단일 고정(MAT_000107; 와이드=3절 MAT_000111) | **5** | — |
| print_option | `load/t_prd_product_print_options.csv` | 양면(108·109) / 단면(110·111·112) — L1 인쇄사양 | **5** | — |
| page_rule | `load/t_prd_product_page_rules.csv` | 고정 페이지 page_min=page_max(30/26/12/13), incr=0 | **5** | — |
| process(택일) | `load/t_prd_product_processes.csv` + flag | 고리형트윈링제본=PROC_000021(벽걸이/와이드만). 삼각대/가공없음=코드 부재 flag | **2** + flag 5 | `t_prd_product_processes_flag.csv` |
| addon | `load/t_prd_product_addons.csv` | 캘린더봉투=PRD_000005(탁상형)·우드거치대=PRD_000012(엽서) | **2** | — |
| plate_size | (보류) | 316×467 등 출력용지규격 — master plate_size 매핑 컨펌 후 | 0 | deferred |
| 가격(고정가) | (round-2 이연) | 10400/6500/4000/9900/24000 = 디자인 포함 고정가 → t_prc_* | 0 | round-2 |

**셀 추적(provenance) 예:** size = `L1 row3 사이즈(필수)=220 x 145 mm → SIZ_000069(적용=탁상형캘린더)`. 모든 행에 `_provenance` 컬럼.

---

## 3. FK 적재 순서 (HARD)

```
① t_prd_products INSERT (마스터 신설 5행)     — 최선행(FK 부모). DB 쓰기·별도 승인 필요
② t_prd_product_sizes INSERT (5)             — FK: prd_cd→①, siz_cd→t_siz(master 실재)
③ t_prd_product_materials INSERT (5)         — FK: prd_cd→①, mat_cd→t_mat(MAT_000107/111 실재)
④ t_prd_product_print_options INSERT (5)     — FK: prd_cd→①, color_cd→t_cod(CLR 실재)
⑤ t_prd_product_page_rules INSERT (5)        — FK: prd_cd→①
⑥ t_prd_product_processes INSERT (2)         — FK: prd_cd→①, proc_cd→t_proc(PROC_000021 실재). excl_grp 헤더 신설(Q-DC-2) 후 excl_grp_cd 연결
⑦ t_prd_product_addons INSERT (2)            — FK: prd_cd→①, addon_prd_cd→t_prd_products(PRD_000005/000012 실재)
⑧ 택일그룹 헤더 / 가격 / plate_size          — DEFERRED(Q-DC-2·round-2·plate 매핑)
```

- ①이 모든 연결의 부모 FK이므로 최선행. **t_prd_products INSERT는 마스터 신설 = DB 쓰기라 반드시 별도 승인.**
- ②~⑦의 master 참조 코드(siz_cd·mat_cd·proc_cd·addon_prd_cd)는 **전부 라이브/추출본 마스터에 실재**(발명 0, §5 FK 검증).

---

## 4. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **Q-DC-0 [최우선·등록 승인]** | 디자인캘린더 신규 별도 prd_cd 등록 | placeholder 설계만(미적재) | 디자인캘린더 5상품을 신규 별도 prd_cd로 등록하는가? 실제 prd_cd 번호는 후니 부여(라이브 max 280 이후). **마스터 INSERT는 DB 쓰기 — 승인 필요.** |
| **Q-DC-1 [엽서 디자인보유 모호]** | 디자인엽서(PRD_NEW_DCAL_3) | editor_yn=Y로 등록(가격·고정페이지 보유 근거) | L1 엽서캘린더 행은 가격(4000)·고정페이지(12P)·우드거치대 보유 = 디자인캘린더 멤버이나 **디자인보유● 셀 비표시**(다른 4상품은 ●). 디자인엽서를 디자인캘린더 멤버로 등록하는 게 맞는가? |
| **Q-DC-2 [택일그룹 헤더]** | 캘린더가공 택일그룹 | excl_grp_cd 보류 | 신규 prd_cd용 캘린더가공 택일그룹 헤더(GRP-CAL-가공류)를 신설해 트윈링/삼각대를 멤버로 연결하는가? (현재 트윈링만 코드 존재) |
| **Q-DC-3 [봉투 사이즈]** | 캘린더봉투 addon | addon 단일 행 | L1 캘린더봉투는 ★사이즈선택(220x145/130x220 등) 조건부 — addon note vs 별도 옵션 사이즈 변형으로 둘지? |
| **Q-DC-4 [삼각대/가공없음]** | 삼각대(그레이/블랙)·가공없음 | flag(미적재·발명 금지) | 삼각대는 master proc_cd 부재 — addon(거치대)으로 둘지 신규 proc 신설할지? "가공없음"은 UI "선택 안 함"인가? |
| **Q-DC-5 [링칼라]** | 링칼라=블랙(벽걸이/와이드) | flag(트윈링 조건부) | 링칼라(★고리형트윈링선택시만=블랙)를 트윈링 proc param vs 별도 옵션? (calendar G-CL-5와 동일 — 자재 mis-axis 적재 금지) |
| **Q-DC-6 [가격]** | 디자인 포함 고정가 | round-2 이연 | 디자인 포함 고정가(10400 등)를 별 prd_cd t_prc_* 공식으로? 업로드 견적가와의 차이를 가격엔진 어느 차원에서? |

> **Q-DC-0이 선결.** 등록 승인이 없으면 ②~⑦ 적재는 부모 부재로 불가(DB 미적재 유지).

---

## 5. 자기검증 게이트 (재실행: `python3 09_load/design-calendar/verify_design_calendar.py`)

- 5상품 × 5속성(size/material/print/page/qty) 일관성, master FK 실재(siz_cd·mat_cd·proc_cd·addon_prd_cd), placeholder prd_cd 형식, L1 provenance 추적 비공란을 대조.
- 추정 0: 모든 적재 행은 design-calendar-l1 셀 또는 master 코드에 추적.

---

## 6. calendar 적재설계와의 관계 (철회 처리 명시)

- `09_load/calendar/load/t_prd_products_editor_yn_update.csv`(108/109/111/112 N→Y, 4행) = **철회** → `09_load/calendar/_deferred/t_prd_products_editor_yn_update_WITHDRAWN.csv`에 사유 보존(삭제 아님).
- `09_load/calendar/verify_expected.py`의 `C5-editor_yn` 게이트 제거 + 신규행0 가드의 editor_yn 참조 제거 → calendar 게이트 재PASS(exit 0).
- **calendar(108~112)는 일반 업로드 캘린더 적재만 유지**(editor_yn=N 라이브 정상). 디자인캘린더는 본 설계(신규 prd_cd)가 전담.
