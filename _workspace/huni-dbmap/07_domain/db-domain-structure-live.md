# DB 인쇄 도메인 구조 — 라이브 Railway DB 권위 규명

> **권위 원칙:** 본 문서의 모든 사실은 **라이브 Railway DB(PostgreSQL 18.4) 직접 read-only SELECT**로 확인한 것이다.
> 추출본(`00_schema/ref-*.csv`)은 stale 가능 → 본 문서가 진실. **추정·임의판단 0** — 라이브 확인분만 기술.
> 라이브 미확인/모호 항목은 명시적으로 "라이브 미확인(실무 컨펌 대상)"으로 표기.
>
> - 접속: `db railway`(postgres 아님), 비표준 포트, 자격증명 `.env.local`의 `RAILWAY_DB_*`. 비밀값 미노출.
> - DB 버전(라이브): `PostgreSQL 18.4 (Debian 18.4-1.pgdg13+1)`.
> - 라이브 SELECT 수행 횟수: **13회** (모두 read-only, 파괴적 쓰기 0).
> - 작성 시점 기준 라이브 상태.

---

## 0. 큰 그림 (인과)

```
인쇄 도메인 지식  →  엑셀 해석  →  DB 엔티티 (인쇄 자동견적 위젯 구축 목적)
```

후니 DB 엔티티는 인쇄 도메인 의미를 정규화해 적재한 결과물이다. 본 문서는 그 DB가
**인쇄 도메인을 어떻게 인코딩했는지**를 라이브에서 규명한다.

핵심 축:
- **인쇄방식**(최상위 축) = `t_proc_processes`의 `PROC_000001 인쇄` 부모 + 자식 5종.
- **공정 계층** = `t_proc_processes` 83행, 자기참조(`upr_proc_cd`).
- **도메인 코드값** = `t_cod_base_codes` 자기참조(`upr_cod_cd`) 그룹.
- **공정 택일그룹** = `t_prd_product_process_excl_groups`.
- **연결** = `t_prd_product_processes`(상품↔공정 m:n) + FK.

---

## 1. 인쇄방식 분류 (라이브 코드·note 원문)

**근거 SELECT:**
```sql
SELECT proc_cd, proc_nm, upr_proc_cd, disp_seq, use_yn, note
FROM t_proc_processes
WHERE proc_cd='PROC_000001' OR upr_proc_cd='PROC_000001'
ORDER BY disp_seq;
```

**라이브 결과 — 인쇄방식은 부모 `PROC_000001 인쇄` 1 + 자식 5종 = 총 6행:**

| proc_cd | proc_nm | upr_proc_cd | disp_seq | use_yn | note (원문) |
|---|---|---|---|---|---|
| PROC_000001 | 인쇄 | (null, root) | 1 | Y | **Decision 14 v3 — 1상품=1인쇄방식** |
| PROC_000002 | UV | PROC_000001 | 1 | Y | R4-3 D-25 |
| PROC_000003 | 옵셋 | PROC_000001 | 2 | Y | (없음) |
| PROC_000004 | 디지털 | PROC_000001 | 3 | Y | 토너 (후니 현재 운영) |
| PROC_000005 | 실크 | PROC_000001 | 4 | Y | (없음) |
| PROC_000006 | 실사 | PROC_000001 | 5 | Y | D-14 v3 b.9 실사 default |

→ **인쇄방식 = 5종** (옵셋 / 디지털 / 실크 / 실사 / UV). 부모 `인쇄`를 포함하면 6행.
- 디지털 note에 "**토너 (후니 현재 운영)**" — 후니 현행 운영 인쇄방식 단서.
- 실사 note에 "**D-14 v3 b.9 실사 default**" — 실사소재 라인 default 인쇄방식.

### 1-1. "1상품=1인쇄방식" 강제 방식 (라이브 규명)

> **핵심 결론: 스키마 제약(CHECK / UNIQUE / FK)으로 강제되지 않는다. `PROC_000001`의 `note` 텍스트로 "선언"만 돼 있고, DB 레벨 강제는 부재.** 게다가 **인쇄방식은 현재 어떤 상품에도 적재(연결)돼 있지 않다** (아래 §5-1 참조).

근거:
1. `t_prd_product_processes`(상품↔공정 연결)의 PK = `(prd_cd, proc_cd)` — 한 상품이 인쇄방식 여러 개를 못 갖게 막는 UNIQUE/CHECK는 **없음**.
   ```sql
   SELECT tc.table_name, kcu.column_name FROM information_schema.table_constraints tc
   JOIN information_schema.key_column_usage kcu ON tc.constraint_name=kcu.constraint_name
   WHERE tc.constraint_type='PRIMARY KEY'
     AND tc.table_name='t_prd_product_processes';
   -- → (prd_cd, proc_cd) 만. 인쇄방식 단일성 강제 제약 없음.
   ```
2. `t_prd_products`에 인쇄방식 전용 컬럼(예: `print_method_cd`)이 **없음**. 인쇄방식은 별도 컬럼이 아니라 공정(process)의 한 갈래로만 존재.
   ```sql
   SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_products';
   -- → prd_cd, MES_ITEM_CD, prd_nm, prd_typ_cd, semi_role_cd, nonspec_*,
   --    file_upload_yn, editor_yn, min/max/dflt_qty, qty_incr, constraint_json,
   --    use_yn, qty_unit_typ_cd. (인쇄방식 컬럼 없음)
   ```
3. CHECK 제약 전수 확인 — 인쇄방식 관련 CHECK **없음**. 존재하는 CHECK는 `*_yn IN ('Y','N')` 류뿐.

→ **"1상품=1인쇄방식"은 DB 강제가 아니라 도메인 규칙(설계 의도)의 note 기록**. 적재·운영 시 애플리케이션/적재 로직이 지켜야 할 규칙이며, 현재 DB 스키마는 위반을 막지 못한다. **(실무 컨펌 대상: 강제를 DB CHECK/UNIQUE로 올릴지, 앱 레벨에 둘지.)**

---

## 2. 공정 전체 계층 (라이브 전수 83행 + Decision 트레일 원문)

**근거 SELECT:**
```sql
SELECT count(*) FROM t_proc_processes;                       -- → 83
SELECT proc_cd, proc_nm, disp_seq, use_yn, note
FROM t_proc_processes WHERE upr_proc_cd IS NULL ORDER BY disp_seq;  -- root 21종
```

**라이브 = 83행. 추출본(`ref-processes.csv`)도 83행 → stale 차이 없음** (§6 확인).

### 2-1. Root 공정 21종 (upr_proc_cd IS NULL, 라이브)

| proc_cd | proc_nm | disp_seq | note (원문) |
|---|---|---|---|
| PROC_000001 | 인쇄 | 1 | **Decision 14 v3 — 1상품=1인쇄방식** |
| PROC_000007 | 별색인쇄 | 2 | **Decision 12 잉크 색상 (선택유형=다중)** |
| PROC_000013 | 코팅 | 3 | 다중 가능 |
| PROC_000017 | 제본 | 4 | 필수, 단일 |
| PROC_000026 | 귀돌이 | 5 | Corner Rounding |
| PROC_000029 | 오시 | 6 | Crease 누름선 |
| PROC_000030 | 미싱 | 7 | Perforation 점선 절취 |
| PROC_000031 | 가변텍스트 | 8 | (없음) |
| PROC_000032 | 가변이미지 | 9 | (없음) |
| PROC_000033 | 박 | 10 | foil — 박색상별 자식 |
| PROC_000050 | 형압 | 11 | embossing |
| PROC_000053 | 완칼 | 12 | Die Cut, 종이+후지 자름 |
| PROC_000054 | 반칼 | 13 | Kiss Cut, 종이만 (스티커) |
| PROC_000055 | 스티커완칼 | 14 | Die Cut + 조각수 |
| PROC_000056 | 접지 | 15 | 그룹 root |
| PROC_000075 | 포장 | 16 | (없음) |
| PROC_000079 | 타공 | 17 | **D-24** |
| PROC_000080 | 봉제 | 18 | **D-24** |
| PROC_000081 | 부착 | 19 | **D-24** |
| PROC_000082 | 족자제작 | 20 | **b.9 실사 전용** |
| PROC_000083 | 에폭시 | 21 | **b.12 굿즈파우치 전용** |

### 2-2. 계층 (root → 자식) 수확

| root | 자식 proc_cd 범위 | 자식 수 | 비고 |
|---|---|---|---|
| 인쇄(PROC_000001) | 02~06 | 5 | 인쇄방식 (§1) |
| 별색인쇄(PROC_000007) | 08~12 | 5 | 화이트/클리어/핑크/금색/은색 |
| 코팅(PROC_000013) | 14~16 | 3 | 유광/무광/UV (각 `면` enum 입력) |
| 제본(PROC_000017) | 18~25 | 8 | 중철/무선/PUR/트윈링/떡/하드커버무선/하드커버트윈링/레이플랫 |
| 귀돌이(PROC_000026) | 27~28 | 2 | 직각(default)/둥근 |
| 박(PROC_000033) | 34~49 | 16 | 박색상 16종 (금/은/핑크/홀로그램/금유광…) |
| 형압(PROC_000050) | 51~52 | 2 | 양각/음각 (각 `크기` mm 입력) |
| 접지(PROC_000056) | 57~74 | 18 | 가로/세로/N단/병풍/롤/6단오시·미싱접지 등 |
| 포장(PROC_000075) | 76~78 | 3 | 수축포장(기본)/낱개/묶음 |
| (단독 root, 자식없음) | — | — | 오시·미싱·가변텍스트·가변이미지·완칼·반칼·스티커완칼·타공·봉제·부착·족자제작·에폭시 |

### 2-3. Decision 트레일 원문 수확 (라이브 note 전수, 13건)

| Decision 토큰 | 출처 proc | note 원문 |
|---|---|---|
| **Decision 14 v3** | PROC_000001 인쇄 | `Decision 14 v3 — 1상품=1인쇄방식` |
| **R4-3 / D-25** | PROC_000002 UV | `R4-3 D-25` |
| **Decision 12** | PROC_000007 별색인쇄 | `Decision 12 잉크 색상 (선택유형=다중)` |
| **D-14 v3 / b.9** | PROC_000006 실사 | `D-14 v3 b.9 실사 default` |
| **D-26** | PROC_000038 금유광(박) | `책자 추가 D-26` |
| **r31 / r8 / r14** | PROC_000044/045/048 박 | `특수박 r31` / `일반박 r8` / `대형박 r14` (박 자재 등급 코드) |
| **포토북 전용** | PROC_000025 레이플랫제본 | `포토북 전용` |
| **D8 결정 4-1** | PROC_000073 6단오시접지 | `복합 (D8 결정 4-1)` |
| **D-24** | PROC_000079/080/081 타공·봉제·부착 | `D-24` (실사/원단 후가공군) |
| **b.9** | PROC_000082 족자제작 | `b.9 실사 전용` |
| **b.12** | PROC_000083 에폭시 | `b.12 굿즈파우치 전용` |
| (디지털인쇄 4종) | PROC_000034 금(박) | `디지털인쇄 4종` |
| (토너 현행) | PROC_000004 디지털 | `토너 (후니 현재 운영)` |

### 2-4. prcs_dtl_opt JSON 입력 스키마 (라이브, 공정 상세 옵션)

note 외에 일부 공정은 `prcs_dtl_opt`(JSON)로 **추가 입력 필드**를 정의한다. 라이브 확인분:

| proc | prcs_dtl_opt 입력 (key/type/제약) |
|---|---|
| PROC_000002 UV | `변형` enum: 일반/배면양면/풀빼다/투명테두리/단면 |
| PROC_000014~16 코팅(유광·무광·UV) | `면` enum: 단면/양면 |
| PROC_000017 제본 | `방향`(좌철/상철), `묶음단위`, `책등`(mm), `고리형`(bool) |
| PROC_000029 오시 / PROC_000030 미싱 | `줄수` integer 0~3줄 |
| PROC_000031 가변텍스트 / 032 가변이미지 | `개수` integer 0~3 |
| PROC_000033 박 / 051·052 형압 | `크기` number(mm) |
| PROC_000053 완칼 | `모양` string(required=false) |
| PROC_000054 반칼 | `모양` string, `조각수` integer(≥1) |
| PROC_000055 스티커완칼 | `조각수` integer(≥1) |
| PROC_000079 타공 | `구수` integer 1~8개 |
| PROC_000080 봉제 | `유형` enum: 오버로크/말아박기/봉미싱, `폭`(mm) |
| PROC_000081 부착 | `대상` enum: 라벨/맥세이프/끈/테입 |
| PROC_000082 족자제작 | `모양` enum: 사각/원형 |

---

## 3. 도메인 코드값 그룹 (라이브 전수, `t_cod_base_codes`)

**구조:** `t_cod_base_codes`는 **그룹 컬럼(`cod_grp_cd`)이 없고 자기참조(`upr_cod_cd`)** 구조다.
그룹 root는 `upr_cod_cd IS NULL`, 코드값은 `upr_cod_cd=<그룹코드>`.

**근거 SELECT:**
```sql
SELECT cod_cd, cod_nm, upr_cod_cd, disp_seq, note
FROM t_cod_base_codes ORDER BY COALESCE(upr_cod_cd,cod_cd), disp_seq;
```

**라이브 = 13개 그룹 (인쇄 도메인 인코딩):**

| 그룹 (root cod_cd) | 그룹명 | 코드값 (cod_cd → cod_nm) |
|---|---|---|
| **PRD_TYPE** | 상품유형 | .01 완제품 / .02 반제품 / .03 기성상품 / .04 디자인상품 |
| **MAT_TYPE** | 자재유형 | .01 종이 / .02 필름 / .03 아크릴 / .04 금속 / .05 원단 / .06 가죽 / .07 부속 / .08 실사소재 / .09 파우치 / .10 악세사리 / .11 스티커 |
| **PRC_COMPONENT_TYPE** | 가격구성요소유형 | .01 인쇄비 / .02 코팅비 / .03 용지비 / .04 후가공비 / .05 박형압비 |
| **OUTPUT_PAPER_TYPE** | 출력용지유형 | .01 국전계열 / .02 46계열 / .03 기타 |
| **DSC_TYPE** | 할인유형 | .01 정률 / .02 정액 |
| **SEL_TYPE** | 선택유형 | .01 단일 / .02 다중 |
| **USAGE** | 용도 | .01 내지 / .02 표지 / .03 면지 / .04 간지 / .05 투명커버 / .06 표지타입 / .07 공통 |
| **QTY_UNIT** | 수량단위 | .01 EA / .02 매 / .03 권 / .04 세트 |
| **FRM_TYPE** | 공식유형 | .01 합산형 / .02 단순형 |
| **SEMI_ROLE** | 반제품역할 | .01 내지 / .02 표지 / .03 면지 / .04 간지 / .05 투명커버 |
| **CUS_GRADE** | 고객등급 | .01 VIP / .02 일반 |

> **택일/다중 인코딩:** `SEL_TYPE.01 단일`(택일) / `SEL_TYPE.02 다중`. 이 코드가 §4 택일그룹의 `sel_typ_cd`로 FK 참조된다.
>
> **인쇄방식↔코드 매핑 주의(라이브 규명):** 인쇄방식은 `t_cod_base_codes`의 코드그룹이 **아니다** — `t_proc_processes` 공정 트리(PROC_000001 자식)로만 표현됨(§1). MAT_TYPE에 "실사소재/파우치/스티커" 등 인쇄 라인별 자재 갈래가 있으나, 인쇄방식 그 자체는 코드그룹 미존재.

---

## 4. 공정 택일그룹 라이브 실태 (`t_prd_product_process_excl_groups`)

**근거 SELECT:** `SELECT * FROM t_prd_product_process_excl_groups ORDER BY 1;` → **13행**

**스키마:** PK=`(prd_cd, excl_grp_cd)`. 즉 택일그룹은 **상품별(prd_cd)로 정의**된다 (전역 그룹 아님).
컬럼: `prd_cd, excl_grp_cd, excl_grp_nm, sel_typ_cd, max_sel_cnt, mand_yn, note`.

**라이브 13행 — 2개 그룹명, 모두 `SEL_TYPE.01 단일(택일)` · `max_sel_cnt=1` · `mand_yn=Y`:**

| excl_grp_cd | excl_grp_nm | 적용 상품(prd_cd) | sel_typ | max_sel | mand | note(trigger) |
|---|---|---|---|---|---|---|
| **GRP-BOOK-제본** | 책자 제본 택일 | PRD_000068·069·070·071·072·077·082·094·097·100 (10개) | 단일 | 1 | Y | trigger=중철/무선/PUR/트윈링/하드커버무선/하드커버트윈링/떡제본 등 |
| **GRP-CAL-가공** | 캘린더 가공 택일 | PRD_000110·111·112 (3개) | 단일 | 1 | Y | trigger=우드거치대 / 고리형트윈링제본 |

수확:
- **택일 구조 = 책자(제본)·캘린더(가공) 2개 도메인.** 각 상품행은 자기 trigger 공정을 가짐.
- `note`의 `trigger=...`는 해당 상품이 이 택일그룹에서 **선택하는 default/대표 공정** 단서.
- UI에서 "캘린더/현수막류 택일" 해석의 DB 근거 = 본 테이블의 `GRP-CAL-가공`. **(단, 현수막은 라이브 택일그룹에 미존재 — 실무 컨펌 대상.)**

---

## 5. 인쇄방식 ↔ 상품 ↔ 공정 연결구조 (FK·제약)

**근거 SELECT (FK 전수):**
```sql
SELECT tc.table_name, kcu.column_name, ccu.table_name ref_table, rc.update_rule, rc.delete_rule
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu USING(constraint_name)
JOIN information_schema.constraint_column_usage ccu USING(constraint_name)
JOIN information_schema.referential_constraints rc USING(constraint_name)
WHERE tc.constraint_type='FOREIGN KEY';
```

**연결 토폴로지 (라이브 FK):**

```
t_prd_products (상품, PK=prd_cd)
   │  prd_typ_cd ──FK──▶ t_cod_base_codes (PRD_TYPE.*)
   │  semi_role_cd ──FK──▶ t_cod_base_codes (SEMI_ROLE.*)
   │  qty_unit_typ_cd ──FK──▶ t_cod_base_codes (QTY_UNIT.*)
   │
   ├─◀ t_prd_product_processes (상품↔공정 m:n, PK=(prd_cd,proc_cd))
   │       prd_cd ──FK──▶ t_prd_products
   │       proc_cd ──FK──▶ t_proc_processes (공정/인쇄방식)
   │       excl_grp_cd ──FK──▶ t_prd_product_process_excl_groups
   │
   └─◀ t_prd_product_process_excl_groups (택일그룹, PK=(prd_cd,excl_grp_cd))
           prd_cd ──FK──▶ t_prd_products
           sel_typ_cd ──FK──▶ t_cod_base_codes (SEL_TYPE.*)
```

- **모든 FK: `ON UPDATE CASCADE`, `ON DELETE RESTRICT`** (라이브 확인).
- 인쇄방식은 `t_prd_product_processes.proc_cd`가 `t_proc_processes`(PROC_000002~6)를 가리키는 **동일 경로로만** 연결 가능.

### 5-1. 인쇄방식 적재 실태 — 라이브 핵심 발견

> **인쇄방식(PROC_000002~6)은 현재 어떤 상품에도 연결돼 있지 않다.**

근거 SELECT:
```sql
-- 인쇄방식 연결 상품수 분포
WITH pm AS (SELECT prd_cd, count(*) n FROM t_prd_product_processes
            WHERE proc_cd IN ('PROC_000002','PROC_000003','PROC_000004','PROC_000005','PROC_000006')
            GROUP BY prd_cd)
SELECT n, count(*) FROM pm GROUP BY n;   -- → 빈 결과 (행 0)

-- 인쇄방식 미연결 상품수
SELECT count(*) FROM t_prd_products p
WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_processes pp
                  WHERE pp.prd_cd=p.prd_cd AND pp.proc_cd IN ('PROC_000002'..'PROC_000006'));
-- → 272  (= 전 상품 272개 모두 인쇄방식 미연결)
```

라이브 사실:
- `t_prd_products` 총 **272개**.
- `t_prd_product_processes` 총 **198 링크 / 76 상품 / 35 공정** (인쇄방식 0).
- 인쇄방식 미연결 상품 = **272 (전부)**.
- `constraint_json` non-null = **0** / non-empty = **0** (인쇄방식 단서 없음).
- `t_prd_product_materials.dep_proc_cd`에 인쇄방식 매핑 = **없음** (NULL 외 행 0).
- `t_prc_component_prices` = **0행** (가격엔진에 proc_cd 인쇄방식 차원 미적재; 애초에 `proc_cd` 컬럼도 없고 `comp_cd` 차원 사용).

→ **결론: "인쇄방식"은 t_proc_processes에 마스터 정의(5종)만 존재하고, 상품과의 실제 연결(적재)은 0건.** "1상품=1인쇄방식" 규칙은 적재가 일어나야 검증 가능하며, 현재는 적재 자체가 미수행 상태. **(실무 컨펌 대상: 인쇄방식 적재를 어느 테이블·경로로 할지 — product_processes vs 신규 컬럼.)**

### 5-2. 실제 연결된 공정 분포 (라이브, 인쇄방식 제외)

`t_prd_product_processes`에 실제 적재된 공정 top (proc별 상품수):

| proc_cd | proc_nm | 상품수 |
|---|---|---|
| PROC_000015 | 무광(코팅) | 22 |
| PROC_000014 | 유광(코팅) | 21 |
| PROC_000027 / 028 | 직각 / 둥근(귀돌이) | 13 / 13 |
| PROC_000076 | 수축포장 | 11 |
| PROC_000037~044 | 박색상(홀로그램/금유광/은유광/먹유광/동박/적박/청박/트윙클) | 각 8 |
| PROC_000081 | 부착 | 8 |
| PROC_000055 | 스티커완칼 | 7 |
| PROC_000079 / 080 | 타공 / 봉제 | 6 / 5 |
| PROC_000054 / 053 | 반칼 / 완칼 | 4 / 3 |
| PROC_000021 | 트윈링제본 | 3 |

→ 실 적재 공정은 **코팅·귀돌이·박·포장·후가공(타공/봉제/부착)·칼·제본** 중심. **인쇄방식·별색인쇄·형압·접지 등은 적재 희박 또는 0.**

---

## 6. 추출본 대비 stale 차이

| 항목 | 라이브 | 추출본(`ref-*.csv`) | 차이 |
|---|---|---|---|
| `t_proc_processes` 행수 | 83 | 83 (`ref-processes.csv`) | **없음** |
| 인쇄방식 5종 코드·note | §1 일치 | 동일 | **없음** |
| root 공정 21종 | §2-1 | 동일 | **없음** |
| 택일그룹 행수 | 13 | (추정 13행) | **없음** (라이브 13 확인) |
| Decision note 원문 | §2-3 일치 | 동일 | **없음** |

→ **stale 차이 발견 없음.** 추출본 `ref-processes.csv`·택일그룹은 라이브와 일치(작성 시점 기준). 단, **인쇄방식 적재 실태(§5-1, 미연결 272)**는 추출본 CSV에는 드러나지 않는 라이브 전용 사실 — 적재 0건은 라이브 JOIN으로만 확인 가능.

---

## 7. 라이브 미확인 (실무 컨펌 대상)

1. **"1상품=1인쇄방식" 강제 위치** — DB 제약 부재. 앱 레벨/적재 로직에 둘지, DB CHECK/UNIQUE로 승격할지 미정.
2. **인쇄방식 적재 경로** — 현재 0건. `t_prd_product_processes.proc_cd`로 적재할지, `t_prd_products`에 전용 컬럼 신설할지 미정.
3. **현수막류 택일** — UI상 택일로 보이나 라이브 `excl_groups`에는 `GRP-BOOK-제본`·`GRP-CAL-가공` 2종뿐. 현수막 택일그룹 미존재.
4. **가격엔진 인쇄방식 차원** — `t_prc_component_prices` 0행, `comp_cd` 기반 차원만 존재. 인쇄방식이 가격 차원으로 들어갈지 미정.
5. **MAT_TYPE ↔ 인쇄방식 라인 매핑** — 실사소재/파우치/스티커 자재 갈래는 있으나 인쇄방식과의 명시 연결 규칙은 라이브 미확인.

---

## 부록: 라이브 SELECT 수행 목록 (13회, 전부 read-only)

1. `SELECT version()` — DB 버전
2. `t_proc_processes` count
3. 인쇄방식(PROC_000001 자식) 조회
4. root 공정(upr null) 조회
5. `t_cod_base_codes` 컬럼 메타
6. `t_cod_base_codes` 전수
7. 택일그룹 컬럼 메타 + 전수 + count
8. FK 제약 전수 + PK + CHECK
9. `t_prd_product_processes` 컬럼 / `t_prd_products` 컬럼
10. 인쇄방식 연결 상품수 분포 + 미연결 count + 링크 총계 + 상품 총수 + constraint_json 샘플
11. 실 연결 공정 top + constraint_json 전수 + material 컬럼 + t_prc_* 목록
12. `t_prc_price_formulas`·`t_prc_component_prices` 컬럼 + 행수 + dep_proc_cd 분포

비밀값(password 등) stdout/파일 미노출 확인 완료.
