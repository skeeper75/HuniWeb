# 스티커 Tier A 4상품 CPQ 옵션 레이어 — 적재본(load-ready)

> **상태/이력** 작성 2026-06-14 · `dbm-option-mapper` 산출 · round-6 Tier A 스티커. DB 미적재(실 COMMIT/더미정리/DDL = 인간 승인).
> **목적:** `attribute-entity-map.md`(마스터 지도 패밀리①) + `postcard-option-layer.md`/`digitalprint-option-layer.md`(검증된 shape) 를 **스티커 4상품**(PRD_000052·053·055·066)으로 확장하여 **적재 가능·멱등** 옵션 레이어를 실 행 + 적재 SQL로 산출한다.
> **권위 입력(인용·발명 금지):** `06_extract/sticker-l1.csv`(옵션성 컬럼 등장순서=disp_seq 권위) · `attribute-entity-map.md`(verdict §2 패밀리①·§1.4 ref_dim_cd) · `00_schema/cpq-schema.md §2`(라이브 트리거 디스패치) · `09_load/_exec_silsa_cpq`(멱등 SQL 패턴) · **라이브 차원행 실측 2026-06-14 read-only**(sizes/materials/print_options/processes/plate_sizes + 기존 옵션그룹).
> 식별자/테이블/컬럼/코드/JSONLogic = English, 설명 = Korean. 불확실 = `[CONFIRM]`(발명 금지). 적재 SQL = `09_load/_exec_tierA_sticker/`.

---

## 0. 스티커 도메인 HARD 적용 (이 4상품에서 무엇이 결정됐나)

| # | 도메인 HARD | 라이브 실측 증거 | 적용 |
|---|---|---|---|
| **S1** | **코팅 = 자재(스티커 예외)** | 052/066 materials 에 `무광코팅스티커`(MAT_000155)·`유광코팅스티커`(MAT_000156) 가 **소재행으로 합성됨**(L1 종이 컬럼에도 무광/유광코팅스티커 들어있음). 별도 코팅 공정행 없음 | **OG-종이 안에 코팅 흡수** — 별도 코팅 옵션그룹 미생성. 다른 상품군 "코팅=공정"을 스티커에 적용 안 함 |
| **S2** | **조각수 = 설명성 안내(옵션 아님)** | L1 052 조각수 = `*최대20조각`/`*최대40조각`, 055 = `5조각`~`10조각`+`*최소크기 30x30/10조각이내` — **선택지가 아니라 사이즈/커팅에 종속된 안내 텍스트**(`*` prefix). 라이브 processes 에 조각수 공정행 0행 | **옵션 미생성** — 커팅(완칼/반칼)에 종속된 캡 정보. param 보존 불가 = GAP-PARAM 플래그(§9) |
| **S3** | **도무송 형상/커팅 = 사이즈 융합(과분할금지)** | 066 sizes 37행 = `원형10x10`·`정사각30x30mm(2EA)`·`직사각55x33mm(2EA)` — **형상+치수+EA가 siz_nm 에 융합**. 커팅 컬럼=각 형상별 도무송칼선이 곧 사이즈선택. 라이브 process=PROC_000055 스티커완칼 **단일**(전 사이즈 공통 묵시적용) | **066 커팅 옵션그룹 미생성** — 형상선택=사이즈선택(UI 1차축). 스티커완칼은 묵시(옵션 아님). WowPress "형상→규격 융합" |
| **S4** | **반칼/완칼 = 커팅 공정(052/053/055)** | 052/053 process=PROC_000054 반칼 · 055 process=PROC_000053 완칼 — **각 1행** | OG-커팅 단일 옵션(item 1행). 자유형(L1 커팅=`반칼(자유형)`/`완칼(자유형)`)은 칼선 PDF 업로드라 형상 enum 없음 |
| **S5** | **066 기존 stub = 죽은 더미** | `OPT-000004 원형`(del_yn=**Y** 소프트삭제·use_yn=N) + 매달린 `OPV-000006 옵션1`(del_yn=N·그룹은 삭제됨) · option_items **0행** | 보강 = 죽은 stub 무시(del_yn='N' 가드로 신규그룹 신설)·매달린 옵션1 정리는 인간 승인(`_cleanup_dummy.sql`). **중복생성 안 함**(이름검사 멱등) |

---

## 1. Step 0 — 차원행 전제 (라이브 실측 2026-06-14)

[HARD] option_item = *이미 적재된 차원행*을 가리키는 포인터. 트리거 `fn_chk_opt_item_ref` 가 "그 prd_cd 에 등록된 차원행 EXISTS"를 강제. 4상품 차원행 라이브 직접 실측:

| 상품 | siz | mat(USAGE.07) | prn(opt_id) | proc | plt | 기존옵션 |
|---|:--:|:--:|:--:|:--:|:--:|---|
| **PRD_000052** 반칼 자유형 | 3 (170/172/196) | **5** (84·153·155·156·242) | 1 (단면) | 1 (PROC_000054 반칼) | 3 | 없음 |
| **PRD_000053** 투명 | 3 (170/172/196) | 1 (162 투명스티커) | 1 (단면) | **2** (008 화이트·054 반칼) | 3 | 없음 |
| **PRD_000055** 낱장 자유형 | 3 (172/174/197) | 1 (154 유포지) | 1 (단면) | 1 (PROC_000053 완칼) | 3 | 없음 |
| **PRD_000066** 합판도무송 | **37** (212~510) | 6 (84·153·155·156·170·171) | 1 (단면) | 1 (PROC_000055 완칼) | 26 | OPT-000004(del Y)·OPV-000006(고아) |

> **차원행 전부 INSERTABLE** — BLOCKED 0건. (postcard/digitalprint 와 달리 스티커는 종이·공정 차원이 모두 라이브 적재됨.) 066 원형 사이즈(SIZ_000501~510·422)는 `dflt_yn='N'` 이나 차원행 **실재**(read-only 확인) → option_item 참조 가능.

---

## 2. 옵션그룹 disp_seq (L1 컬럼순서 권위)

L1 `sticker-l1.csv` 옵션성 컬럼 등장순서(헤더 col12~32, 비옵션 제외):

```
사이즈(필수)[OG 미생성·UI 1차축] → 종이(필수) → 인쇄(옵션) → 별색인쇄_화이트(옵션)
→ 코팅(옵션)[자재 흡수·OG 미생성] → 커팅(옵션) → 조각수(옵션)[설명성·OG 미생성]
```

> **disp_seq 부여:** 종이=1 · 인쇄=2 · 화이트별색=3 · 커팅=4. (코팅=자재 흡수·조각수=설명성·사이즈=UI 1차축 → 옵션그룹 미생성.) **상대 순서는 L1 헤더 등장순서 보존**(적재 3원칙: disp_seq=옵션 표시순서 권위). digitalprint 파일럿과 달리 스티커는 **종이를 인쇄보다 앞**에 둔다(L1 헤더 종이(23)<인쇄(24)·스티커는 소재가 1차 결정축).

---

## 3. 상품별 옵션그룹 (택1/택N · mand_yn · sel_typ)

라이브 컬럼: `prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, note`. 코드 = 라이브 MAX(`OPT-000005`)+1 → **`OPT_000006`부터**(separator `_` 통일·CPQ 하이픈 폐기·D3).

| 상품 | opt_grp_cd | opt_grp_nm | sel_typ | min/max | mand | disp_seq | ref_dim | 근거 |
|---|---|---|---|:--:|:--:|:--:|---|---|
| 052 | `OPT_000006` | 종이 | SEL_TYPE.01 | 1/1 | Y | 1 | .03 | 5종 자재(코팅 흡수 S1) |
| 052 | `OPT_000007` | 인쇄 | SEL_TYPE.01 | 1/1 | Y | 2 | .06 | 단면 단일(opt_id 1) |
| 052 | `OPT_000008` | 커팅 | SEL_TYPE.01 | 1/1 | Y | 4 | .04 | 반칼 PROC_000054 |
| 053 | `OPT_000009` | 종이 | SEL_TYPE.01 | 1/1 | Y | 1 | .03 | 투명스티커 1종 |
| 053 | `OPT_000010` | 인쇄 | SEL_TYPE.01 | 1/1 | Y | 2 | .06 | 단면 단일 |
| 053 | `OPT_000011` | 화이트별색 | SEL_TYPE.01 | 0/1 | N | 3 | .04 | 화이트 PROC_000008(L1 화이트인쇄(단면)) |
| 053 | `OPT_000012` | 커팅 | SEL_TYPE.01 | 1/1 | Y | 4 | .04 | 반칼 PROC_000054 |
| 055 | `OPT_000013` | 종이 | SEL_TYPE.01 | 1/1 | Y | 1 | .03 | 유포지 1종 |
| 055 | `OPT_000014` | 인쇄 | SEL_TYPE.01 | 1/1 | Y | 2 | .06 | 단면 단일 |
| 055 | `OPT_000015` | 커팅 | SEL_TYPE.01 | 1/1 | Y | 4 | .04 | 완칼 PROC_000053 |
| 066 | `OPT_000016` | 종이 | SEL_TYPE.01 | 1/1 | Y | 1 | .03 | 6종 자재 |
| 066 | `OPT_000017` | 인쇄 | SEL_TYPE.01 | 1/1 | Y | 2 | .06 | 단면 단일 |

> **합계 12 옵션그룹** (052=3·053=4·055=3·066=2). 전부 `SEL_TYPE.01`(택1) — 스티커는 다중선택 옵션 없음(엽서 후가공 택N 과 대비). 인쇄/커팅은 선택지 1개라도 **mand=Y 단일**(주문 필수 확정).
> **066 커팅 그룹 미생성(S3):** 커팅=형상별 도무송칼선=사이즈선택(siz융합). 단일 스티커완칼(PROC_000055)은 전 사이즈 묵시적용 → 옵션 아님.
> **066 stub 회피(S5):** 죽은 `OPT-000004 원형`(del_yn=Y) 과 무관하게 신규 `OPT_000016/017` 신설. 멱등 가드 = `(prd_cd, opt_grp_nm, del_yn='N')` NOT EXISTS → 재실행 안전.

---

## 4. options (opt_grp_cd · dflt_yn)

라이브 컬럼: `prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, note`. 코드 = 라이브 MAX(`OPV_000016`)+1 → **`OPV_000017`부터**.

상품별 옵션(opt_nm = 차원행 사람읽는 라벨; 종이는 mat_nm, 인쇄=단면, 커팅=반칼/완칼, 화이트별색=화이트):

- **052 종이(5):** 유포스티커·비코팅스티커·무광코팅스티커·유광코팅스티커·미색스티커 (dflt=유포스티커)
- **052 인쇄(1):** 단면(dflt) · **052 커팅(1):** 반칼(자유형)(dflt)
- **053 종이(1):** 투명스티커(dflt) · **053 인쇄(1):** 단면(dflt)
- **053 화이트별색(2):** 화이트없음(센티넬 dflt) · 화이트인쇄 · **053 커팅(1):** 반칼(자유형)(dflt)
- **055 종이(1):** 유포지(dflt) · **055 인쇄(1):** 단면(dflt) · **055 커팅(1):** 완칼(자유형)(dflt)
- **066 종이(6):** 유포스티커(dflt)·비코팅스티커·무광코팅스티커·유광코팅스티커·투명데드롱스티커·은데드롱스티커
- **066 인쇄(1):** 단면(dflt)

> **합계 ~22 options** (052=7·053=5·055=3·066=7). **화이트별색 센티넬**(`화이트없음`)=option_item 0행(선택 안 함 기본). opt_cd=opt_nm resolve 로 멱등(SQL 은 이름검사 NOT EXISTS).

---

## 5. option_items (polymorphic ref_dim_cd → 라이브 차원행 · 트리거 디스패치 정확)

라이브 컬럼: `prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn`. (`ref_param_json`·`note` 라이브 부재 — F-1·R3.)

**디스패치(트리거 슬롯 일치):**
- **종이 = `.03`, ref_key1 = mat_cd, ref_key2 = `USAGE.07`** (라이브 전 자재행 usage_cd=USAGE.07).
- **인쇄(도수) = `.06`, ref_key1 = `1`(opt_id::int, NOT clr_cd)** — 전 4상품 단면 opt_id=1.
- **커팅·화이트별색(공정) = `.04`, ref_key1 = proc_cd**, ref_key2 미사용.
- **센티넬(화이트없음) = option_item 0행**.

| 상품·옵션 | ref_dim_cd | ref_key1 | ref_key2 | qty | 트리거 검사 | 판정 |
|---|---|---|---|:--:|---|:--:|
| 052 종이 5행 | `.03` | MAT_000153/084/155/156/242 | USAGE.07 | 1 | materials EXISTS | ✅ INSERTABLE×5 |
| 052 인쇄 | `.06` | 1 | — | 1 | print_options(opt_id=1) EXISTS | ✅ |
| 052 커팅 반칼 | `.04` | PROC_000054 | — | 1 | processes(054) EXISTS | ✅ |
| 053 종이 | `.03` | MAT_000162 | USAGE.07 | 1 | EXISTS | ✅ |
| 053 인쇄 | `.06` | 1 | — | 1 | EXISTS | ✅ |
| 053 화이트인쇄 | `.04` | PROC_000008 | — | 1 | processes(008) EXISTS | ✅ |
| 053 커팅 반칼 | `.04` | PROC_000054 | — | 1 | EXISTS | ✅ |
| 055 종이 | `.03` | MAT_000154 | USAGE.07 | 1 | EXISTS | ✅ |
| 055 인쇄 | `.06` | 1 | — | 1 | EXISTS | ✅ |
| 055 커팅 완칼 | `.04` | PROC_000053 | — | 1 | processes(053) EXISTS | ✅ |
| 066 종이 6행 | `.03` | MAT_000153/084/155/156/170/171 | USAGE.07 | 1 | EXISTS | ✅ INSERTABLE×6 |
| 066 인쇄 | `.06` | 1 | — | 1 | EXISTS | ✅ |

> **집계: INSERTABLE 21행 · BLOCKED 0행** (052=7·053=4·055=3·066=7 — 화이트없음 센티넬은 item 0행). 정확 집계 §8.
> **GAP-PARAM 정직표기:** 조각수(052 *최대20/40·055 5~10조각)·자유형 칼선 형상은 param 이나 라이브 보존처 부재 → 옵션 미생성·GAP-PARAM. **qty 에 조각수 smear 금지**(qty=소비수량 1).

---

## 6. constraints (본 적재 0행)

- 인쇄/종이/커팅(택1)·화이트별색(택1 옵션)은 **option_groups 의 sel_typ_cd/min/max 로 충족** → 별도 JSONLogic 불요.
- **R-QTY 수량배수**(052 증가8·053 증가8/4/2·055 증가1·066 증가1000)는 `t_prd_products` MIN/MAX/INCR 범위(attribute-entity-map §3.4) — 옵션레이어 제약 아님. 본 적재 제외.
- 캐스케이드(자재→커팅 disable 등)는 스티커 L1 에 없음(종이↔커팅 자유조합).

> constraints 0행. (postcard 파일럿의 R-QTY-PANSU 는 가격엔진 소관으로 정합 — digitalprint 와 동일 결정.)

---

## 7. templates / add-on (없음)

- 스티커 4상품 L1 `추가상품(옵션)_추가상품` 컬럼 **전부 공백** → add-on template 미생성.
- `t_prd_product_addons`·`t_prd_templates` 본 적재 대상 아님.

---

## 8. FK 위상정렬 적재 순서 + 적재 가능성 집계

```
[선행 — L1 차원행, 라이브 적재 실측 완료]
  ✅ sizes·materials(USAGE.07)·print_options(opt_id=1)·processes(053/054/055/008) — 전부 적재됨(BLOCKED 0)
[00] 마커 (NO INSERT — 적용 결정·죽은 stub 회피 기록)
[05] t_prd_product_option_groups (12행)        — FK: prd_cd→products, sel_typ_cd→cod
[06] t_prd_product_options (22행)              — FK: opt_grp_cd→option_groups
[07] t_prd_product_option_items (21행 INSERTABLE) — 트리거 fn_chk_opt_item_ref 행단위 EXISTS
[08] t_prd_product_constraints (0행)
```

| 테이블 | 행 | INSERTABLE | BLOCKED | 비고 |
|---|:--:|:--:|:--:|---|
| option_groups | 12 | 12 | 0 | 트리거 없음 |
| options | 22 | 22 | 0 | 트리거 없음(화이트없음 센티넬 1 포함) |
| **option_items** | **21** | **21** | **0** | 트리거 차원행 검사. 052=7·053=4·055=3·066=7 |
| constraints | 0 | 0 | 0 | sel_typ 로 충족 |
| **합계** | **55** | **55** | **0** | BLOCKED 0 · GAP-PARAM(조각수/형상) 플래그만 |

> **option_items 21행 내역(정확 집계):** 052[종이5·인쇄1·반칼1 = **7**] · 053[종이1·인쇄1·화이트인쇄1·반칼1 = **4**](화이트없음 센티넬=item 0) · 055[종이1·인쇄1·완칼1 = **3**] · 066[종이6·인쇄1 = **7**] → **7+4+3+7=21**. options 22행 = items 있는 21 옵션 + 화이트없음 센티넬 1. DRY-RUN 으로 트리거 통과·멱등 실증(manifest §5).

---

## 9. 설계 결정 / [CONFIRM] (리드 에스컬레이션)

### 설계 결정 (침묵 선택 안 함)
| # | 결정 | 채택 | 대안 | 종속 |
|---|---|---|---|---|
| **D-S1** | **코팅 처리** | **자재 흡수**(OG-종이 안, S1) — 무광/유광코팅스티커=mat 행 | 코팅 공정 별도그룹 | 스티커 예외(사용자 확정) |
| **D-S2** | **조각수 처리** | **옵션 미생성**(설명성·S2) — GAP-PARAM 플래그 | 개수형 공정+param(보존처 부재) | GAP-PARAM |
| **D-S3** | **066 커팅/형상** | **사이즈 융합**(커팅 OG 미생성·S3) — 형상=siz선택 | 커팅 형상 enum 옵션 | 과분할금지 |
| **D-S4** | **인쇄 단일선택** | mand=Y 단일(선택지 1개라도 필수확정) | use_yn 자동적용·미표시(hidden) | GAP-HIDDEN |
| **D-S5** | **066 stub** | 죽은 OPT-000004(del Y) 무시·신규 신설·고아 OPV-000006 정리 인간승인 | 기존 stub 재사용 | `_cleanup_dummy.sql` |
| **D-S6** | **사이즈 옵션그룹** | 미생성(UI 1차축, digitalprint 계승) | OG-SIZE 명시 | [CONFIRM C-S2] |

### [CONFIRM] (리드 확정 필요)
1. **C-S1 인쇄 hidden 처리** — 전 4상품 인쇄=단면 단일(선택지 없음). 단일선택을 UI 노출(현재) vs 자동적용·미표시(hidden-essential, GAP-HIDDEN) — 라이브 hidden 플래그 부재.
2. **C-S2 사이즈 옵션그룹 노출** — UI 정책(digitalprint 와 동일 미결).
3. **C-S3 종이 opt_nm** — 현재 mat_nm 라벨(유포스티커 등). UI 표시명 = mat_nm 조인 vs opt_nm 별도.
4. **C-S4 066 고아 OPV-000006 정리** — 매달린 옵션1(그룹 삭제됨) hard/soft 정리는 인간 승인(`_cleanup_dummy.sql`).
5. **C-S5 053 화이트별색 sel_typ** — 화이트인쇄(단면)=별색 1종. 현재 택1(0/1)+센티넬. 도수(opt_id)로 볼지 별색공정으로 볼지 — 본 적재는 **공정(.04 PROC_000008)** 채택(라이브 process 실재·attribute-map "별색=공정 clr_cd=NULL" 정합).

### GAP (→ dbm-ddl-proposer · blocked-and-gaps.md)
- **GAP-PARAM**: 조각수 N(052 20/40·055 5~10)·자유형 칼선 형상 보존처 부재(`ref_param_json` 미구현).
- **GAP-HIDDEN**: 인쇄 단일=자동적용·미표시 플래그 부재(C-S1).
- **GAP-066-DUMMY**: 죽은 stub(OPT-000004 del Y)·고아 옵션(OPV-000006) 정리 필요.

---

## 부록 — 적재 SQL 인덱스

| 파일 | 행 | 권위 출처 |
|---|:--:|---|
| `09_load/_exec_tierA_sticker/00_preload_markers.sql` | 0 | 적용 결정·stub 회피 마커 |
| `…/05_t_prd_product_option_groups.sql` | 12 | L1 컬럼순서 + attribute-map 패밀리① |
| `…/06_t_prd_product_options.sql` | 22 | L1 옵션 + 라이브 차원행 라벨 |
| `…/07_t_prd_product_option_items.sql` | 21 INSERTABLE | 라이브 차원행 + 트리거 §2 |
| `…/08_t_prd_product_constraints.sql` | 0 | sel_typ 로 충족 |
| `…/_cleanup_dummy.sql` | (인간승인) | 066 고아 OPV-000006 정리 |
</content>
