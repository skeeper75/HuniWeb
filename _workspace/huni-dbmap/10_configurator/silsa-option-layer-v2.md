# 일반현수막(PRD_000138) CPQ 옵션 레이어 v2 — 자재+공정 BUNDLE 재정합 (silsa)

> **상태/권위** 작성 2026-06-08 · **정정 2026-06-08-D(도메인 [CONFIRM] 3건 사용자 확정 반영, in-place)** · `dbm-option-mapper` 산출 · round-6 파일럿 #2(silsa) **v2 재정합** · DB 미적재(실 INSERT/자재 mint/공정 신설/DDL/코드행 = 인간 승인).
> **[2026-06-08-D 변경 이력 — 사용자 HARD 확정 3건]** ① **타공(4/6/8)=구멍만(bare-hole)·아일렛 안 끼움** → 타공 = process-only(PROC_000079 .04만, 열재단 동류). **아일렛 자재 seq/mint 철회**(BLOCKED CSV 3행 삭제), 타공 3행 INSERTABLE 복귀(공정 seq, item_seq=1). ② **봉미싱 실=자재 등록** → 봉제사/실 자재 mint(MAT_TYPE.07, search-before-mint 재증명 부재) + 봉제공정 BUNDLE. BLOCKED-CONFIRM→**BLOCKED-MINT+LINK** 재분류. ③ **각목=신규 자재 mint**(우드봉 MAT_000225 차용 배제 — 각목=사각단면 목재, 둥근 우드봉과 별개). 900이하/초과 2규격 모델만 D-2로 잔존([CONFIRM] 별 mat_cd 2개 vs 단일+param). → INSERTABLE 9 유지(타공 3 복귀로 net 동일)·**BLOCKED items 12→9**(아일렛 3 삭제), 잔존 [CONFIRM] 2건(큐방 mint·양면테입 enum)·설계결정 2건(D-1 param·D-2 각목 2규격).
> **supersede** 본 문서는 v1 `silsa-option-layer.md`의 **§3 옵션→엔티티 매핑을 supersede**한다(폐기 아님 — v1은 sel_typ·사이즈 재정합·가격위임 기록으로 유효, §2/§5/§7.1 보존). **변경 핵심**: v1은 가공/추가 옵션을 **공정(.04)-only 또는 셋트(.07)** 로 매핑했으나(반쪽 매핑 결함), v2는 사용자 HARD 모델대로 각 옵션을 **자재(.03) + 공정(.04) BUNDLE** 으로 분해한다.
>
> **[사용자 HARD 모델 — 재론 금지]** 한 옵션은 *자재 의미*와 *공정 의미*를 동시에 가진다. 예: **아일렛(eyelet)=금속링 자재이지만, 현수막에 박는 것=타공 공정.** 한 옵션=두 의미. DB는 자재(t_mat_materials)와 공정(t_proc_processes)을 **각각 별도 등록**하고, **option_items(polymorphic 다중 item_seq) + template**이 그 둘을 묶어 **주문접수와 생산작업지시 모두**가 성립하게 하는 장치다. → **각목·끈 = 자재(.03)**(set .07 아님), **타공 = 아일렛 자재 + 타공 공정**, **봉미싱 = 실 자재 + 봉제 공정**.
>
> **권위 입력(인용·발명 금지):** v1 `silsa-option-layer.md`(sel_typ/사이즈/가격위임 보존) · `silsa-price-table-gap.md`(B26 옵션 11값+추가가격) · `06_extract/silsa-l1.csv` row108~113(가공6+추가5 명시값=권위) · `huni-goods-option-mapping.md`(옵션→자재/공정 재배선 패턴) · **라이브 read-only SELECT**(t_mat_materials·t_proc_processes·t_prd_product_materials·트리거 `fn_chk_opt_item_ref` 소스, 본 런 직접 조회=존재 판정 권위) · `docs/huni/table-spec_260608.html`.
> 식별자/테이블/컬럼/코드/JSONLogic=English, 설명=Korean. 불확실=`[CONFIRM]`(발명 금지). 적재 CSV=`10_configurator/load_silsa_v2/<table>.csv`.

---

## 0. v1 → v2 무엇이 바뀌었나 (반쪽 매핑 결함의 교정)

| 옵션 | v1 매핑(반쪽) | v2 매핑(D 확정 반영) | 결함 사유 / D 확정 |
|---|---|---|---|
| 타공4/6/8 | 공정 **.04 PROC_000079 only** | **공정 .04 타공 PROC_000079 only (process-only)** | **[D① 확정] bare-hole=구멍만·아일렛 안 끼움** → v1과 동일 process-only로 복귀(자재 누락 아님). 아일렛 자재 seq/mint 철회 |
| 양면테입 | 공정 **.04 PROC_000081 only** | **자재 .03 MAT_000069 양면테입**(seq1) + **공정 .04 부착**(seq2) | 양면테입은 그 자체가 자재(라이브 MAT_000069 실재)이자 부착 공정. 자재행 누락 |
| 봉미싱 | 공정 **.04 PROC_000080 only** | **자재 .03 실/봉제사**(seq1·mint) + **공정 .04 봉제**(seq2) | **[D② 확정] 봉미싱 실=자재 등록.** 봉제사/실 mint(MAT_TYPE.07) + 봉제공정 BUNDLE. 소모성→미등록 후보 철회 |
| 큐방4 | 공정 **.04 PROC_000081 only** | **자재 .03 큐방**(seq1·mint) + **공정 .04 부착**(seq2) | 큐방=금속 부속 자재. 부착 공정만으론 무엇을 부착하는지 미상 |
| 끈4 | 공정 **.04 PROC_000081 only** | **자재 .03 MAT_000070 끈**(seq1) + **공정 .04 부착**(seq2) | 끈=자재(라이브 MAT_000070 실재). 부착 대상 자재 누락 |
| 각목+끈 | **셋트 .07 각목**(set, BLOCKED) + 공정 끈 | **자재 .03 각목**(seq1·mint) + **자재 .03 끈 MAT_000070**(seq2) + **공정 .04 부착**(seq3) | 각목=목재 자재(.03)이지 set(.07) 아님(v1 정정). **[D③ 확정] 각목 신규 자재 mint**(우드봉 차용 배제) |
| 열재단 | 공정 .04 신규 PROC_000084 | **공정 .04 신규 PROC_000084 (자재 없음)** | 변경 없음 — 열재단=천 자체 절단, 추가 자재 없는 **순수 process** (BUNDLE 아님) |

> **요지(D 확정 후):** **process-only→material+process BUNDLE 전환 = 5 옵션**(양면테입·봉미싱·큐방·끈은 각각 자재 seq 추가, 각목+끈은 set→material 정정·다중자재). **타공(3) + 열재단 = process-only**([D①] 타공 bare-hole 확정으로 타공이 BUNDLE 후보에서 process-only로 복귀). v1의 sel_typ·사이즈 이산매트릭스·가격위임·R-GAKMOK 골격은 보존.

---

## 1. Step 0 — 차원행 전제 + search-before-mint (라이브 직접 조회 = 권위)

[HARD] option_item은 *이미 적재된 차원행*을 가리키는 포인터다. 트리거 `fn_chk_opt_item_ref`(본 런 소스 직접 확인)가 ref_dim_cd별 차원행 EXISTS를 강제한다. **자재(.03)는 `(mat_cd, usage_cd)` 둘 다 `t_prd_product_materials`에 그 prd_cd로 존재**해야 한다(소스 line 17). 즉 master에 자재가 있어도 **PRD_000138 자재 링크가 없으면 REJECT**.

### 1.1 자재(material) search-before-mint — 라이브 t_mat_materials 직접 조회

| 옵션 자재 | 라이브 t_mat_materials 검색 결과 | 판정 |
|---|---|:--:|
| **끈** | **MAT_000070 끈** (MAT_TYPE.07 부속, del_yn=N) **EXISTS** (+ 캘린더부자재 끈 MAT_000035·아크릴부속 블랙헤어끈 MAT_000057·행택끈 MAT_000218·면끈 6종) | ✅ master 실재 (mint 불요) |
| **양면테입** | **MAT_000069 양면테입** (MAT_TYPE.07 부속) **EXISTS** | ✅ master 실재 (mint 불요) |
| **각목** | 우드봉 MAT_000225·우드행거 MAT_000229·우드거치대 MAT_000223(MAT_TYPE.10) 존재하나 **"각목" 명칭 부재**. 각목/각재/사각목/원목 정밀검색 **0행** | ❌ **mint 확정** [D③ — 우드봉 차용 배제: 각목=사각단면 목재, 둥근 우드봉과 별개] |
| **큐방** | 큐/방/하토메/그로밋 검색: 아크릴부속 은색고리/금색고리·천정고리만, **큐방 부재** | ❌ **mint 확정** [D — 사용자 확정] |
| **봉제사/실(봉미싱)** | 실/봉제사/봉사/미싱사/재봉 정밀검색: 실버/실사소재만 매칭, **봉제용 실 0행** | ❌ **mint 확정** [D② — 실=자재 등록 확정·소모성 미등록 후보 철회] |
| ~~아일렛(타공)~~ **철회** | (타공=bare-hole 확정으로 아일렛 자재 불요) | **N/A** [D① — 아일렛 mint 철회] |

### 1.2 공정(process) — 라이브 t_proc_processes (변경 없음)

| 공정 | 라이브 | prcs_dtl_opt(파라미터 정의) |
|---|:--:|---|
| **타공 PROC_000079** | ✅ | `{"구수": int 1~8 "개"}` |
| **봉제 PROC_000080** | ✅ | `{"유형": enum[오버로크/말아박기/봉미싱], "폭": mm}` — 봉미싱 ∈ enum |
| **부착 PROC_000081** | ✅ | `{"대상": enum[라벨/맥세이프/끈/테입]}` — 끈·테입 ∈ enum, **큐방 ∉ enum** |
| **열재단 PROC_000084** | ❌ 신규 | flat(param 없음) — M-1 ① 확정·완칼 PROC_053 차용 폐기 |

### 1.3 PRD_000138 라이브 차원 링크 (트리거 검사 대상)

라이브 직접 조회: PRD_000138 = **material MAT_000182(현수막천, USAGE.07)** + **process 079/080/081** + **sets 0행** + **MAT_000069/070 링크 0행**. 즉:
- **공정 seq(079/080/081)** = PRD_000138 링크 실재 → INSERTABLE. (타공 3행 포함 — bare-hole 확정으로 공정 seq만.)
- **자재 seq(MAT_000069 양면테입·MAT_000070 끈)** = master는 있으나 **PRD_000138 자재 링크 0행** → 트리거 REJECT = **BLOCKED-LINK**(자재 링크 선적재만 하면 해소, mint 불요).
- **자재 seq(큐방·각목·봉제사)** = master 부재 → **BLOCKED-MINT+LINK**(자재 mint + 링크 둘 다 필요). [D② 봉미싱 실 포함·D③ 각목·큐방]
- ~~아일렛~~ = 타공 bare-hole 확정으로 자재 seq 철회([D①]).

> **search-before-mint 증명:** 끈·양면테입은 라이브 master에 실재함을 직접 조회로 증명 → mint 제안 안 함(링크만). 큐방·각목·봉제사(실)는 라이브 부재를 직접 조회로 재증명 → mint 제안(발명 금지·근거 명시). 아일렛은 [D① bare-hole]로 자재 자체가 불요 → mint 철회.

---

## 2. 옵션 분해표 (각 옵션 → 자재 part + 공정 part + [CONFIRM])

[HARD] 사용자 모델 핵심. item_seq 규약: **seq1~ = 자재(.03), 마지막 seq = 공정(.04)**. (각목+끈은 자재 2개라 seq1 각목·seq2 끈·seq3 공정.)

### 2.1 가공 그룹 (6값)

| 옵션 | 자재 part (.03) | 공정 part (.04) | item_seq 구성 | [CONFIRM] |
|---|---|---|---|---|
| **열재단** | **없음**(천 자체 절단) | 열재단 신규 **PROC_000084** | seq1=공정(.04) PROC_000084 | CONFIRM-CHANNEL(공정 신설) |
| **타공(4개)** | **없음** [D① bare-hole 확정] | 타공 PROC_000079 {구수:4} | **seq1=공정(.04) 079** | 해소 — 구멍만·아일렛 안 끼움 |
| **타공(6개)** | 없음 [D① bare-hole] | 타공 PROC_000079 {구수:6} | seq1=공정 079 | 해소 |
| **타공(8개)** | 없음 [D① bare-hole] | 타공 PROC_000079 {구수:8} | seq1=공정 079 | 해소 |
| **양면테입** | **MAT_000069 양면테입**(EXISTS) | 부착 PROC_000081 {대상:테입} | seq1=자재 069 / seq2=공정 081 | 양면테입→테입 enum 해석 |
| **봉미싱** | **실/봉제사** [D② mint MAT_TYPE.07] | 봉제 PROC_000080 {유형:봉미싱} | seq1=자재(실) / seq2=공정 080 | 소모성 해소 — 자재 등록 확정 |

### 2.2 추가 그룹 (5값)

| 옵션 | 자재 part (.03) | 공정 part (.04) | item_seq 구성 | [CONFIRM] |
|---|---|---|---|---|
| **추가없음** | — | — | 센티넬(item 0행) | — |
| **큐방(4개)** | **큐방** [CONFIRM-MAT mint] | 부착 PROC_000081 {대상:큐방} | seq1=자재 큐방 / seq2=공정 081 | 큐방 mint · 큐방 ∉ 부착 enum |
| **끈(4개)** | **MAT_000070 끈**(EXISTS) | 부착 PROC_000081 {대상:끈} | seq1=자재 070 / seq2=공정 081 | 없음(끈·테입 enum 실재) |
| **각목(900이하)+끈** | **각목**[D③ mint 확정] + **MAT_000070 끈** | 부착 PROC_000081(끈) | seq1=각목·seq2=끈·seq3=공정 | 각목 2규격 별 mat_cd vs param(D-2)만 |
| **각목(900초과)+끈** | **각목(900초과)**[D③ mint] + 끈 070 | 부착 PROC_000081(끈) | seq1=각목·seq2=끈·seq3=공정 | 상동(D-2) |

> **복합옵션 = polymorphic 다중 item_seq의 진가:** 각목+끈은 한 옵션에 **자재 2개(.03 각목·.03 끈) + 공정 1개(.04 부착)** = item_seq 3행이 공존. typed FK로는 불가능한 동질·이종 다중 차원 결합을 polymorphic ref_dim_cd가 자연 표현. (각목을 끈에 묶어 거는 부착 공정 = 끈 부착이 각목 거치의 수단.)
> **[D① 해소] 타공 = bare-hole(구멍만) 확정:** 사용자 확정으로 타공4/6/8은 **아일렛(금속링)을 끼우지 않는 순수 구멍**이다. 따라서 타공 = **process-only**(공정 타공 PROC_000079 .04만, 열재단과 동류)이며 자재 seq·아일렛 mint는 **철회**. 타공 3행은 공정 seq(item_seq=1)로 INSERTABLE 복귀(PRD_000138 링크 079 실재). 종전 v2의 "아일렛 자재 seq + [CONFIRM]"은 본 확정으로 소멸.
> **[D② 해소] 봉미싱 실 = 자재 등록 확정:** 봉미싱의 봉제사/실은 소모성이나 사용자 확정으로 **자재(.03)로 등록**한다. 봉제사/실 t_mat_materials 0행 재증명(실버/실사소재만 매칭) → 자재 mint(MAT_TYPE.07 부속) + PRD 링크 + 봉제공정(.04) BUNDLE. 종전 "소모성→미등록 가능 [CONFIRM]"은 소멸·BLOCKED-CONFIRM→BLOCKED-MINT+LINK 재분류.

---

## 3. option_items 적재 판정 (INSERTABLE / BLOCKED) — 라이브 DRY-RUN 실증

### 3.1 INSERTABLE = 공정 seq 9행 (DRY-RUN A·D1 통과)

→ `load_silsa_v2/t_prd_product_option_items.csv` (9행). 전부 공정(.04) seq로 PRD_000138 링크 079/080/081 실재 → 트리거 통과. **라이브 DRY-RUN A 실증**(9행 트리거 무위반·ROLLBACK). [D①] 타공 3행은 자재 seq 제거로 **item_seq=1(공정만)** 복귀 — **DRY-RUN D1 재실증**(타공 process-only 3행 통과·ROLLBACK).

| opt_cd | item_seq | ref_dim_cd | ref_key1 | qty | 환원 |
|---|:--:|---|---|:--:|---|
| OP-GAGONG-TAGONG4 | **1** | .04 | PROC_000079 | 1 | 타공 공정 [bare-hole] |
| OP-GAGONG-TAGONG6 | **1** | .04 | PROC_000079 | 1 | 타공 공정 [bare-hole] |
| OP-GAGONG-TAGONG8 | **1** | .04 | PROC_000079 | 1 | 타공 공정 [bare-hole] |
| OP-GAGONG-YANGMYEONTAPE | 2 | .04 | PROC_000081 | 1 | 부착 공정(seq1=양면테입 자재 BLOCKED) |
| OP-GAGONG-BONGMISING | 2 | .04 | PROC_000080 | 1 | 봉제 공정(seq1=실 자재 BLOCKED) |
| OP-CHUGA-QBANG4 | 2 | .04 | PROC_000081 | 4 | 부착 공정(seq1=큐방 자재 BLOCKED) |
| OP-CHUGA-STRING4 | 2 | .04 | PROC_000081 | 4 | 부착 공정(seq1=끈 자재 BLOCKED) |
| OP-CHUGA-GAKMOK-LE900 | 3 | .04 | PROC_000081 | 4 | 부착 공정(끈)(seq1=각목·seq2=끈 BLOCKED) |
| OP-CHUGA-GAKMOK-GT900 | 3 | .04 | PROC_000081 | 4 | 부착 공정(끈)(seq1=각목·seq2=끈 BLOCKED) |

### 3.2 BLOCKED = 자재 seq 8행 + 열재단 공정 1행 = 9행 (DRY-RUN B 실증)

→ `load_silsa_v2/t_prd_product_option_items_BLOCKED.csv` (9행: 자재 .03 8행 + 공정 .04 1행). 자재 seq(.03)는 PRD_000138 자재 링크 부재로 트리거 REJECT. **라이브 DRY-RUN B1 실증**: 끈 자재 seq(.03 MAT_000070) INSERT 시 트리거가 정확히 `자재 mat_cd=MAT_000070/usage_cd=USAGE.07 가 상품 PRD_000138에 없음` EXCEPTION 발생 → BLOCK이 실재(발명 아님). [D 변경] 아일렛 자재 3행 삭제(타공 bare-hole)·봉미싱 실 1행 BLOCKED-CONFIRM→BLOCKED-MINT+LINK 재분류.

| 차단 유형 | 행 | 해소 조건 |
|---|:--:|---|
| **BLOCKED-LINK only** (master 실재·링크만 부재) | 끈 MAT_000070 ×3(끈·각목LE끈·각목GT끈)·양면테입 MAT_000069 ×1 = **4행** | PRD_000138 `t_prd_product_materials (mat_cd, USAGE.07)` 링크 선적재 → INSERTABLE (mint 불요) |
| **BLOCKED-MINT+LINK** (master 부재) | 큐방 ×1·각목 ×2(LE/GT)·**봉제사(실) ×1**[D②] = **4행** | 자재 mint(t_mat_materials MAT_TYPE.07) + PRD 링크 둘 다 (인간 승인) |
| **BLOCKED-MINT** (process, 변경 없음) | 열재단 PROC_000084 ×1 = **1행** | 열재단 공정 신설(M-1 ①·인간 승인) |
| | **합계 9** (자재 .03 8 + 공정 .04 1) | (아일렛 3행 삭제·봉미싱 실 재분류) |

> **BLOCKED-LINK 실증(DRY-RUN B2):** PRD_000138 자재 링크 `(MAT_000070, USAGE.07)` 선적재 후 끈 BUNDLE(자재 seq1 .03 + 공정 seq2 .04) 2행 INSERT → **트리거 통과·2행 성립**·ROLLBACK. **자재+공정 BUNDLE 모델이 실 행으로 성립**함을 라이브로 증명.
> **[D②] 봉미싱 실 BUNDLE 실증(DRY-RUN D2):** 봉제사/실 자재 mint(MAT_TYPE.07) + PRD 링크 선적재 후 봉미싱 BUNDLE(실 자재 seq1 .03 + 봉제공정 seq2 .04 PROC_000080) 2행 INSERT → **트리거 통과·2행 성립**·ROLLBACK. 실 자재 등록 모델이 실 행으로 성립함을 라이브로 증명.

---

## 4. 사용자 모델 ↔ DB 장치 정합 (자재·공정 별도 등록 + option_items 결합)

사용자: "DB는 자재(t_mat_materials)와 공정(t_proc_processes)을 **각각 별도 등록**하고, option_items(+template)가 둘을 묶는다."

| 사용자 모델 요소 | 후니 DB 장치 | 본 v2 반영 |
|---|---|---|
| 자재를 별도 등록 | `t_mat_materials`(master) + `t_prd_product_materials`(상품 링크, usage_cd 동반) | 끈 MAT_000070·양면테입 MAT_000069 실재 / 큐방·각목·봉제사(실) mint 제안 [D]. 상품 링크 선적재 = BLOCKED 해소 |
| 공정을 별도 등록 | `t_proc_processes`(master) + `t_prd_product_processes`(상품 링크) | 타공079·봉제080·부착081 실재(링크도 실재) / 열재단084 신설 |
| 둘을 묶는 장치 | `t_prd_product_option_items` 다중 item_seq(자재 .03 + 공정 .04), polymorphic ref_dim_cd | 각 옵션이 자재 seq + 공정 seq BUNDLE. 복합은 다중 자재 seq |
| 주문접수 + 생산작업지시 둘 다 성립 | 환원 시 ref_dim_cd가 라우터: .03→materials[](자재 BOM)·.04→processes[](작업지시) | §5 MES 환원 트레이스로 자재 BOM + 공정 작업지시 동시 산출 |

> **`dep_proc_cd` 미사용 확인:** `t_prd_product_materials.dep_proc_cd`(자재→종속공정 직결 컬럼)는 라이브 716행 중 **0행 사용**. 즉 자재-공정 결합의 라이브 표준 장치는 dep_proc_cd가 아니라 **option_items 다중 seq BUNDLE**다(사용자 모델과 일치). dep_proc_cd 차용은 미검증 경로라 제안 안 함.
> **template과의 구분(사용자 "+template"):** option_items BUNDLE = **상품 내부 옵션**(현수막에 부속을 부착·박음). 별도 SKU(예: 각목을 독립 상품으로도 판매·동반)는 `t_prd_templates`/`t_prd_template_selections`(추가상품/선택)으로 분리. 일반현수막 캐스케이드엔 독립 SKU add-on 부재(거치대 등 없음, v1 R6) → 본 파일럿은 template 미생성. 각목을 **상품 내부 옵션재료**로 보면 material(.03), **독립 동반상품**으로 보면 template — silsa는 "각목+끈 추가" = 현수막에 거는 부속이라 **material(.03) 1차 권고**(set/template 아님). [CONFIRM-D4].

---

## 5. 고객 선택 → MES 환원 (자재 BOM + 공정 작업지시 동시 산출)

**선택:** 일반현수막 / 1500×900(SIZ_000403) / 타공(6개) / 각목(900이하)+끈(4개) / 5장.

**환원(option_items → 실엔티티, ref_dim_cd 라우터):**

| 선택 | item_seq | ref_dim_cd | 환원 → 자재 BOM / 공정 작업지시 |
|---|:--:|---|---|
| 소재(고정) | (차원직접) | material | **BOM**: MAT_000182 현수막천 ×1 |
| 사이즈 | (차원직접) | size | SIZ_000403 1500×900(가격 셀 존재) |
| 타공(6개) | seq1 | .04 | **작업지시**: 타공 PROC_000079 {구수:6}(구수 보존 GAP-PARAM). [D① bare-hole — 자재 BOM 없음] |
| 각목 | seq1 | .03 | **BOM**: 각목(900이하) ×1 [mint·BLOCKED] |
| 끈 | seq2 | .03 | **BOM**: 끈 MAT_000070 ×4 [BLOCKED-LINK] |
| 부착 | seq3 | .04 | **작업지시**: 부착 PROC_000081 {대상:끈} ×4 |

**MES 페이로드(자재 BOM + 공정 분리 — 사용자 모델 직접 충족):**
```json
{ "line_type":"MAIN", "prd_cd":"PRD_000138", "qty":5,
  "size":{"siz_cd":"SIZ_000403","width":1500,"height":900},
  "materials_bom":[
    {"mat_cd":"MAT_000182","mat_nm":"현수막천","usage_cd":"USAGE.07","qty":1},
    {"mat_cd":"[CONFIRM 각목900이하]","mat_nm":"각목","qty":1,"note":"BLOCKED-MINT(D③ 신규 자재)"},
    {"mat_cd":"MAT_000070","mat_nm":"끈","qty":4,"note":"BLOCKED-LINK only(링크 선적재 후 성립)"}
  ],
  "processes":[
    {"proc_cd":"PROC_000079","proc_nm":"타공","params":{"구수":6},"note":"구수 GAP-PARAM"},
    {"proc_cd":"PROC_000081","proc_nm":"부착","params":{"대상":"끈"},"consume_qty":4}
  ]
}
```

> **환원 완전성:** v1은 자재 BOM에 끈/각목/실이 **없었다**(공정만). v2는 자재 BOM에 각목·끈·실·큐방·양면테입을 **자재행으로 명시** → 생산 시 "무엇을 박고 무엇을 거는가"가 BOM에 잡힘(사용자 "생산작업지시도 성립"). 단 각목·큐방·실 = BLOCKED(mint), 끈·양면테입 = BLOCKED-LINK(링크 선적재 후 성립). **[D① 타공=bare-hole]은 BOM에 자재 없음**(순수 구멍) — 타공 환원은 공정(.04)만.

---

## 6. 보존 항목 (v1에서 변경 없음)

- **사이즈** = 이산 5×16 면적 매트릭스(가격표 B26 권위, 가로{900,1000,1200,1500,1750}×세로 16규격). 비치수 연속범위 아님. off-grid=가로·세로 각각 ceiling(앱). siz 4 존재 / 76 미등록 GAP. (v1 §2 R8 보존)
- **가격 위임** = 옵션 레이어는 가격 미보유. 추가가격(열재단 3,000~각목900초과 8,000)은 **가격트랙 component 분리**(B26 J/K·M/N). option_items에 가격 컬럼 없음(라이브 정합). (v1 §7.1 보존)
- **sel_typ** = OG-GAGONG 택1 필수(SEL_TYPE.01·mand_yn=Y), OG-CHUGA 택1 선택(min0). [CONFIRM-MULTI] 복수가공 가능 시 SEL_TYPE.02. (v1 §2 보존)
- **R-GAKMOK constraint** = 각목↔세로변 900 호환. **단 var가 v1 `sub_prd_cd`(set) → v2 `mat_cd`(material)로 변경**(각목 재귀속 반영). 이산 siz_cd 집합 멤버십. GAP-DEFER(각목 자재 mint+링크·siz 76·폼빌더 배열입력 미검증 F-1). (v1 §5 + var 정정)

---

## 7. FK 위상정렬 적재 순서

```
[선행 L1 — 자재·공정 차원]
  ✅ materials master: MAT_000182(천)·MAT_000069(양면테입)·MAT_000070(끈) — 실재
  ✅ processes master+링크: 079 타공·080 봉제·081 부착 — 실재
  ❌ materials master mint(인간승인): 큐방·각목(900이하/초과)·봉제사(실) — search-before-mint 부재 재증명 [D②③]
  ❌ process master mint: 열재단 PROC_000084 — M-1 ①
  ❌ PRD_000138 material 링크(선적재): MAT_000069·070 + (mint분) — 트리거 .03 검사 통과 전제
  △ sizes 76규격(가격트랙) — 매트릭스·R-GAKMOK 전제
  (아일렛 mint 철회 — 타공 bare-hole [D①])
[1] t_prd_product_option_groups (2행) — 트리거 없음
[2] t_prd_product_options (11행) — 트리거 없음
[3] t_prd_product_option_items:
      적재 CSV(INSERTABLE 9행) = 공정 seq(.04) 079/080/081 (타공 3=item_seq1) — DRY-RUN A·D1 통과
      분리 CSV(BLOCKED 9행) = 자재 seq(.03) 8 + 열재단(.04) 1 — 자재 링크/mint·공정 신설 후 적재
[4] t_prd_product_constraints (현 live 0행) — R-GAKMOK GAP-DEFER(var=mat_cd 정정)
[5] UPDATE t_prd_products.constraint_json — R-GAKMOK 적재 시 1건
```

---

## 8. 적재 가능성 집계

| 테이블 (적재 CSV) | 총행 | INSERTABLE | BLOCKED | 비고 |
|---|:--:|:--:|:--:|---|
| option_groups | 2 | 2 | 0 | OG-GAGONG·OG-CHUGA |
| options | 11 | 11 | 0 | 가공6+추가5 |
| **option_items** (CSV) | **9** | **9** | 0 | 공정 seq(.04), 타공 3=item_seq1 — DRY-RUN A·D1 통과 |
| **option_items 분리** (BLOCKED CSV) | **9** | 0 | **9** | 자재 seq(.03) 8 + 열재단(.04) 1 |
| constraints | 1 | 0(현) | 1(DEFER) | R-GAKMOK var=mat_cd 정정 |
| **합계** | **32** | **22** | **10** | 적재 CSV 합=22행(groups2+options11+items9). BLOCKED=items 9 + constraint 1 |

> **BLOCKED 10건(items 9 + constraint 1) 세분:** BLOCKED-LINK only 4(끈×3·양면테입×1, mint 불요·링크만) · BLOCKED-MINT+LINK 4(큐방×1·각목×2·봉제사실×1 [D②]) · BLOCKED-MINT 1(열재단 공정) · constraint DEFER 1. **[D 변경] items 12→9**(아일렛 3행 삭제·봉미싱 실 재분류). **v1 대비 BLOCKED 증가(items 3→9)는 결함이 아니라 정직** — v1이 자재 의미를 누락(공정만 매핑)해 BLOCKED를 과소계상했던 것을 v2가 자재 seq를 드러내며 실제 선행조건(자재 mint·링크)을 노출. (타공은 D① bare-hole로 process-only=INSERTABLE 복귀.)

---

## 9. 설계 결정 필요 / [CONFIRM] (리드 에스컬레이션)

### [D 2026-06-08] 해소된 [CONFIRM] (사용자 HARD 확정)
- ✅ **[해소] 타공=아일렛 vs bare-hole** → **bare-hole 확정**(구멍만·아일렛 안 끼움). 타공=process-only. 아일렛 mint 철회.
- ✅ **[해소] 봉미싱 실=자재행 여부** → **자재 등록 확정**(MAT_TYPE.07 mint). 소모성 미등록 후보 철회. BUNDLE.
- ✅ **[해소] 각목 mint vs 우드봉 차용** → **신규 mint 확정**(우드봉 배제 — 각목=사각단면 목재).

### 미해결 [CONFIRM] (라이브 미명시·발명 금지) — 잔존 2건
1. **[CONFIRM 큐방 mint + 부착 enum 확장]** — 큐방 자재·부착 enum 둘 다 부재(라이브 재증명). 자재 mint(MAT_TYPE.07) + 부착 `대상` enum에 `큐방` 추가 둘 다 필요(인간 승인).
2. **[CONFIRM 양면테입→테입 enum]** — v1 승계. L1 `양면테입` ≠ 부착 enum `테입`. 자재는 MAT_000069 직결(명확)이나 공정 param `{대상:테입}` 해석 [CONFIRM](enum에 `양면테입` 추가 vs `테입`으로 환원).

### 설계 결정 필요 — 잔존 2건
| # | 결정 | 후보 | 종속 |
|---|---|---|---|
| D-1 | **타공 구수·각목 규격 보존처(GAP-PARAM)** | option_items `ref_param_json` 컬럼 신설 vs qty 재사용(불가-구수≠소비량). 타공 구수 N(4/6/8)·각목 규격(900이하/초과)의 의미 라벨 보존처 부재 | GAP-PARAM(High)·ddl-proposer |
| D-2 | **각목 2규격(900이하/초과) 모델** | 별 mat_cd 2개(각목900이하·각목900초과) vs 단일 mat_cd + 규격 param | GAP-PARAM·R-GAKMOK var |

> **D-3(각목 귀속)·D-4(봉미싱 실)는 [D 확정]으로 종결** — 각목=material(.03) 확정, 봉미싱 실=자재 등록 확정. 잔존 설계결정은 D-1(param 보존처)·D-2(각목 2규격 모델)만.

### 승계 잔존(범위 밖)
- GAP-1 pick-N(SEL_TYPE.02) 미행사 · GAP-2 excl-group 변환 미행사 · 사이즈 76규격 등록(가격트랙) · 열재단 공정 신설(M-1 ①).

---

## 부록 — 적재 CSV 인덱스

| CSV (load_silsa_v2/) | 행 | 권위 출처 |
|---|:--:|---|
| `t_prd_product_option_groups.csv` | 2 | v1 §2 보존(sel_typ) |
| `t_prd_product_options.csv` | 11 | silsa-l1 row108~113 + v2 BUNDLE note |
| `t_prd_product_option_items.csv` | 9(INSERTABLE 공정 seq, 타공 3=seq1) | 라이브 PRD_000138 링크 079/080/081 + DRY-RUN A·D1 |
| `t_prd_product_option_items_BLOCKED.csv` | 9(BLOCKED 자재 seq 8+열재단 1) | 라이브 t_mat_materials search-before-mint + 트리거 .03 검사 + DRY-RUN B·D2 |
| `t_prd_product_constraints_GAP.csv` | 1(GAP-DEFER) | R-GAKMOK var=mat_cd 정정(각목 material 재귀속) |

| 코드/값 | 라이브 직접 조회 결과 |
|---|---|
| 끈 MAT_000070 (MAT_TYPE.07 부속) · 양면테입 MAT_000069 | t_mat_materials EXISTS (mint 불요) |
| 큐방·각목·봉제사(실) 부재 [D] | t_mat_materials 0행 (search-before-mint 재증명 → mint 제안). 아일렛은 [D① bare-hole]로 자재 불요·mint 철회 |
| 타공079·봉제080·부착081 · 열재단084 신규 | t_proc_processes (열재단 mint) |
| 자재 트리거 = (mat_cd, usage_cd) BOTH in t_prd_product_materials | fn_chk_opt_item_ref line 17 소스 직접 확인 |
| PRD_000138 자재 링크 MAT_000069/070 = 0행 | t_prd_product_materials 직접 조회 → 자재 seq BLOCKED-LINK |
| USAGE.07=공통 · MAT_TYPE.07=부속·.10=악세사리 | t_cod_base_codes |
