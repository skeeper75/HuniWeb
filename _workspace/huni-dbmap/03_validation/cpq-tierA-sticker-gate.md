# CPQ Tier A 스티커 4상품 옵션 레이어 — 적대적 교차검증 게이트 (round-6 L2)

> **검증가** `dbm-validator` (생성자 `dbm-option-mapper`와 독립) · 작성 2026-06-14 · 라이브 read-only 실측.
> **대상** PRD_000052·053·055·066 · 설계 `10_configurator/tierA/sticker-option-layer.md` · 실행본 `09_load/_exec_tierA_sticker/`.
> **방법** 라이브 Railway DB(`.env.local RAILWAY_DB_*`) 읽기전용 SELECT + 롤백전용 DRY-RUN. **NEVER COMMIT.**
> 식별자/SQL/상태토큰 = English, 설명 = Korean.

---

## 최종 판정: **GO** (게이트 1~6 전건 PASS · 뒤집힌 분류 0건 · BLOCKED 0)

라이브 차원행 13자재 + 4도수 + 4공정 전부 EXISTS, 트리거 디스패치 슬롯 정확, 2-pass 멱등 delta 0,
ROLLBACK 후 영구변경 0 실증. 생성자 보고(INSERTABLE 21·BLOCKED 0)와 독립 재집계 **일치**.

---

## 게이트별 결과

| 게이트 | 판정 | 핵심 증거 |
|---|:--:|---|
| **G1 트리거 reference resolution** | **PASS** | option_items 21행 전부 라이브 차원행 EXISTS · 디스패치 슬롯 정확 |
| **G2 코팅=자재(스티커 핵심)** | **PASS** | MAT_000155 무광/MAT_000156 유광 = materials 소재행 실재 · 코팅 공정 매핑 0 |
| **G3 조각수·도무송 정직성** | **PASS** | 조각수 공정 라이브 0행 · 066 형상=siz 융합 정당 · 과소적재 아님 |
| **G4 disp_seq 정합** | **PASS** | L1 헤더 등장순서(종이<인쇄<별색<커팅) = disp_seq 1·2·3·4 보존 |
| **G5 멱등성** | **PASS** | 2-pass: PASS1 55×`INSERT 0 1`·PASS2 55×`INSERT 0 0` · 트리거 REJECT 0 · ROLLBACK 후 불변 |
| **G6 066 보강 안전성** | **PASS** | stub/고아 코드 상이(하이픈) · `_cleanup_dummy` 신규행 미접촉·apply.sql 미참조 |

---

## G1 — 트리거 reference resolution (라이브 EXISTS 실측)

트리거 `fn_chk_opt_item_ref` (BEFORE INS/UPD, enabled='O' 부착 확인) 디스패치를 행단위 대조.

**자재(.03) — ref_key1=mat_cd·ref_key2=USAGE.07** (라이브 13행 전부 EXISTS):
```
PRD_000052 → MAT_000084/153/155/156/242 (USAGE.07) ✅×5
PRD_000053 → MAT_000162 (USAGE.07) ✅
PRD_000055 → MAT_000154 (USAGE.07) ✅
PRD_000066 → MAT_000084/153/155/156/170/171 (USAGE.07) ✅×6
```
**도수(.06) — ref_key1=opt_id::int=1 (NOT clr_cd)**: 4상품 print_options 전부 opt_id=1 EXISTS ✅×4. (설계가 `clr_cd` 아닌 `opt_id`='1' 사용 — MISMATCH-1 교정 준수.)
**공정(.04) — ref_key1=proc_cd**:
```
PRD_000052 PROC_000054(반칼) ✅ · PRD_000053 PROC_000008(화이트)·PROC_000054(반칼) ✅✅
PRD_000055 PROC_000053(완칼) ✅ · PRD_000066 — 커팅 OG 미생성(item 0)
```
DRY-RUN 트리거 실화: 21 INSERT 전부 통과, RAISE EXCEPTION 0. **부재행을 INSERTABLE 분류한 사례 0 → 뒤집힘 0.**

## G2 — 코팅=자재 (스티커 예외 준수)

라이브 `t_mat_materials`: `MAT_000155=무광코팅스티커`, `MAT_000156=유광코팅스티커` — **소재행으로 실재**.
L1 052/066 종이(필수) 컬럼에 무광/유광코팅스티커 포함, `코팅(옵션)` 컬럼은 4상품 전부 **empty**.
→ 코팅이 종이 자재에 흡수(OG-종이 안), 별도 코팅 공정/옵션그룹 미생성. 다른 상품군 "코팅=공정"을 스티커에 적용 안 함. **스티커 예외 정합.**

## G3 — 조각수·도무송 정직성

- **조각수**: L1 052=`*최대20/40조각`·055=`5~10조각/*최소크기` 안내(`*`/종속 텍스트). 라이브 4상품 공정행에 조각수 공정 **0행**, bundle_qtys에도 조각수 선택축 없음. 055 sizes=A4/A3/A2 3행만(조각수=사이즈 종속 결과값). **옵션 미생성 정당 — 과소적재 아님. GAP-PARAM 정직 플래그(보존처 `ref_param_json` 부재).**
- **066 도무송 형상**: L1 합판도무송 `커팅`=`원형10mm(8EA)`~`원형45mm`이 `사이즈` 컬럼과 **동일 값**(커팅=사이즈선택 1:1). 라이브 siz 37행에 형상+치수+EA 융합. 단일 PROC_000055(스티커완칼) 묵시적용. **커팅 OG 미생성 정당(S3 과분할금지).**

## G4 — disp_seq 정합

L1 헤더 옵션성 컬럼 등장순서: `종이(c23) → 인쇄(c24) → 별색인쇄_화이트~은색(c25~29) → 코팅(c30) → 커팅(c31) → 조각수(c32)`.
설계 disp_seq: 종이=1·인쇄=2·화이트별색=3·커팅=4. 별색인쇄가 헤더상 커팅보다 앞 → disp_seq 3<4 보존. **상대순서 일치(적재 3원칙 ⒜).**
별색인쇄 클리어/핑크/금/은 4컬럼 = 4상품 전부 empty → 053 화이트만 그룹 생성 정합(미생성 컬럼 누락 아님).

## G5 — 멱등성 (DRY-RUN 직접 실행)

```
PASS 1: 12 grp + 22 opt + 21 item = 55 INSERT → 전부 INSERT 0 1, 트리거 REJECT 0
        post-count: groups 12 · options 23(=22 신규+1 기존 고아 OPV-000006) · items 21
PASS 2: 동일 SQL 재실행 → 55 전부 INSERT 0 0 (delta 0, 이름검사 NOT EXISTS 가드)
ROLLBACK 후 baseline 재측정: grp 0 · opt 1 · item 0 (변경 전과 동일) → 영구변경 0
```
전 INSERT `WHERE NOT EXISTS(자연키)` 확인. `apply.sql`=단일 BEGIN…ROLLBACK·`ON_ERROR_STOP on`·중간 COMMIT 0. `reg_dt` 생략→`DEFAULT now()` 발화(round-5 명시-NULL 함정 회피). **NEVER COMMIT 준수.**

## G6 — 066 보강 안전성

라이브 stub: `OPT-000004 원형`(del_yn='Y'·use_yn='N')·`OPV-000006 옵션1`(del_yn='N'·삭제된 그룹 가리킴=고아).
- 신규 코드 `OPT_000006~017`/`OPV_000017~038`(언더스코어) vs stub `OPT-000004`/`OPV-000006`(하이픈) → 문자열 상이·충돌 0.
- 멱등 가드 `(prd_cd, opt_grp_nm, del_yn='N')`: stub del_yn='Y'라 가드 무관·고아 opt_nm='옵션1'≠신규 라벨 → 충돌 0.
- `_cleanup_dummy.sql`: apply.sql 미참조(grep 0)·고아 OPV-000006만 대상·신규행 미접촉·NEVER auto-run. FK 위상순(05→06→07→08) 정확.

---

## INSERTABLE / BLOCKED / GAP 독립 재집계

| 테이블 | 설계 보고 | 독립 재집계 | 일치 |
|---|:--:|:--:|:--:|
| option_groups | 12 | 12 (052=3·053=4·055=3·066=2) | ✅ |
| options | 22 | 22 신규(+기존 고아 1=count 23) | ✅ |
| option_items | 21 INSERTABLE | 21 INSERTABLE·0 BLOCKED (052=7·053=4·055=3·066=7) | ✅ |
| constraints | 0 | 0 (sel_typ 충족·캐스케이드 없음) | ✅ |

**뒤집힌 분류: 0건.** BLOCKED 0 (전 차원행 라이브 적재). GAP: GAP-PARAM(조각수/칼선형상)·GAP-HIDDEN(인쇄 단일)·GAP-066-DUMMY(고아 OPV-000006).

---

## Finding (라우팅)

| ID | 심각도 | 내용 | 라우팅 |
|---|:--:|---|---|
| F-INFO-1 | INFO | options post-count 23 = 신규 22 + 기존 고아 OPV-000006 1. 설계 §4 "22 options"는 신규분만으로 정합(불일치 아님) | (없음·정합 확인) |
| F-GAP-PARAM | MINOR | 조각수 N·자유형 칼선 형상 보존처(`ref_param_json`) 라이브 부재 — qty smear 안 함(정직) | `dbm-ddl-proposer` |
| F-GAP-HIDDEN | MINOR | 인쇄 단일선택 자동적용·미표시 hidden 플래그 부재 (C-S1) | `dbm-ddl-proposer` + 리드 [CONFIRM] |
| F-DUMMY-066 | MINOR | 고아 OPV-000006(삭제된 그룹) 소프트삭제 — `_cleanup_dummy.sql` 인간 승인 (C-S4) | 리드 (인간 승인) |

본 적대 검증에서 **실 결함(BLOCKER/MAJOR) 0건** — 생성자 산출이 라이브 차원행·트리거·멱등 전 경계에서 정합.

## 잔존 BLOCKED / [CONFIRM]

- **BLOCKED: 0건** (전 차원행 라이브 적재 실측).
- **[CONFIRM] 5건** (리드 확정, 적재 차단 아님): C-S1 인쇄 hidden 처리·C-S2 사이즈 OG 노출·C-S3 종이 opt_nm 표시·C-S4 고아 OPV-000006 정리·C-S5 화이트별색 sel_typ(현 공정 .04 채택, attribute-map 정합).
- 실 COMMIT·`_cleanup_dummy` 실행·GAP DDL = 인간 승인 대기.
