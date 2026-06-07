# DDL 제안: 열재단(熱裁斷 / heat-cut) 신규 마스터 공정

> **PROPOSAL ONLY — 적용·INSERT·COMMIT은 전부 인간 승인 게이트.** 본 문서/SQL은 미실행.
> 권위: round-5 GOAL `docs/goal-2026-06-06-02.md` §5(propose ≠ apply) · round-6 silsa pilot M-1.
> 짝 SQL: `heat-cut-process-proposal.sql`.

---

## 0. 닫는 GAP (한 줄)

후니 process 마스터(`00_schema/ref-processes.csv` 83행)에 **천(플렉스/패브릭) 열봉합 재단 = 열재단 공정이 없다.**
silsa 파일럿이 임시로 `PROC_000053 완칼`(종이 Die Cut)을 차용했으나 **매질이 틀려**(천 ≠ 종이) BLOCKED 상태다.
M-1 lead 판정 = **① 열재단 = 실제 가공(distinct process)** → 가장 가벼운 닫기 = **신규 마스터 공정 1행 + 상품링크 1행**.

---

## 1. search-before-mint — 기존 구조로 표현 불가 증명 (필수)

### 1.1 재단/cut/마감 family 전수 (ref-processes.csv)

| proc_cd | proc_nm | note | 매질 | 동작 | 열재단 적합? |
|---------|---------|------|------|------|-------------|
| PROC_000027 | 직각 | `default 재단` | 종이 | 기계 직각 재단(귀돌이 그룹 기본) | ❌ 종이·융착 없음 |
| **PROC_000053** | **완칼** | **`Die Cut, 종이+후지 자름`** | **종이+후지** | **칼 다이컷(외곽 따냄)** | ❌ **매질 종이, 융착 없음** |
| PROC_000054 | 반칼 | `Kiss Cut, 종이만 (스티커)` | 종이(스티커) | 반칼(아래지 안 자름) | ❌ 스티커 전용 |
| PROC_000055 | 스티커완칼 | `Die Cut + 조각수` | 스티커 | 다이컷+조각 | ❌ 스티커 전용 |

→ **재단/cut family 4종 전부 종이·스티커 대상이며, 천을 열로 잘라 가장자리를 융착(cauterize)하는 공정은 0건.**

### 1.2 PROC_000053(완칼) 차용이 틀린 이유 — 의미 오용

- **매질 불일치**: 완칼 = `종이+후지`. 열재단 = `천(플렉스/패브릭/메쉬)`. (도메인 리서치 §1.1 — 합성섬유 열 융착.)
- **동작 불일치**: 완칼 = 칼날 다이컷(모양 따냄, 융착 없음). 열재단 = 열칼 1패스 = 자름+가장자리 봉합 동시(올풀림 방지).
- **파일럿 근거**: `silsa-option-layer.md` R2/§4 — 열재단→PROC_000053은 `[CONFIRM]` 차용이었고, 라이브 검증 결과
  PRD_000138 링크에 PROC_000053이 **부재 → 트리거 REJECT = BLOCKED**로 확정. 즉 차용은 적재조차 불가했다.

### 1.3 "기존 행으로 환원 가능한 link인가?" — 아님

- 열재단을 가리키는 **기존 마스터 행이 없다**(누락). 따라서 "기존 행에 연결만 하면 되는 누락된 link"가 아니라,
  **마스터 행 자체가 빠진 진짜 GAP**이다. → 신규 마스터 공정 행 mint가 정당.
- 사다리 점검: 코드행<컬럼<JSONB<테이블 중 — 본 GAP은 **마스터 공정 1행(데이터 행)** 으로 닫힌다.
  신규 **테이블/컬럼/JSONB키 불요**(기존 `t_proc_processes`·`t_prd_product_processes`가 그대로 수용). 가장 가벼운 단계.

### 1.4 (정직한 반대 증거 처리) 도메인 리서치는 ②를 권고했다

`m1-yeoljaedan-domain-research.md`는 ②(default sentinel, 0원·무료)를 권고했다. 그 권고는 **"열재단 = 무료 기본 마감"**
가정에 의존했다. 그러나 **가격표 권위가 그 가정을 반증**한다:
- `06_extract/price-poster-sign-l1.csv` B26 J246/**K246 = 3,000원** (band ladder `3000>4000>5000>3000>4000`).
- `06_extract/silsa-l1.csv` 일반현수막(005-0003): 가공 = `열재단`, 가격 = `3000`, **별도 `추가없음` 센티넬도 동시 존재.**
- → 열재단은 **0원 do-nothing이 아니라 3,000원 priced finishing op**. 도메인 리서치 §2.4·§4가 미리 지목한
  "가격표에 단가행 있으면 ① 재검토" 조건이 충족됨. **lead가 ①로 override한 근거가 이 가격표다.** (본 제안은 ① 구현.)
- 경쟁사도 ①을 지지: RedPrinting은 visible-process(CUT_ZUN)와 hidden-sentinel(CUT_DFT)을 **별개 코드**로 두고
  현수막 열재단을 CUT_ZUN(①)에 배치. WowPress는 "현수막 열재단(사방/상하/좌우)"를 명명 가공 item으로 둠.

---

## 2. 제안 — 최소 신규 엔티티 (마스터 공정 행 + 상품링크 행)

### 2.1 신규 마스터 공정 — `t_proc_processes` 1행

라이브 컬럼 shape (`columns.csv` L306-316, `_live-schema-dump-260606.txt` L308-318):
`proc_cd PK varchar(50)` · `proc_nm varchar(200)` · `upr_proc_cd varchar(50) NULL(self-FK)` · `prcs_dtl_opt jsonb NULL` ·
`disp_seq int NULL` · `use_yn char(1) NOT NULL [CHECK Y/N]` · `note varchar(500) NULL` · `reg_dt ts NOT NULL DEFAULT now()` ·
`upd_dt ts NULL` · `del_yn char(1) NOT NULL DEFAULT 'N' [CHECK Y/N]` · `del_dt ts NULL`.

| 컬럼 | 제안값 | 근거 / 표시 |
|------|--------|------------|
| `proc_cd` | **`PROC_000084`** `[CONFIRM-CHANNEL]` | placeholder. master max=PROC_000083 기준 "다음"이나 **비어있음을 단정 안 함**(추출본 stale 주의 + 메모리상 PROC_000084 placeholder 의도적 제외 이력). **채번은 적용 직전 라이브 `MAX(proc_cd)` 확인 후 후니가 배정** = 인간 승인 영역. |
| `proc_nm` | `열재단` | M-1 명칭. WowPress/가격표 표기 일치. |
| `upr_proc_cd` | `NULL` (root) | 가공 group root 레벨. PROC_000079 타공·080 봉제·081 부착도 전부 root(upr=NULL) — 동형. |
| `prcs_dtl_opt` | `NULL` (param 없음) | 가격표 B26 열재단 = 단일 flat 3,000원, 구수/줄수/위치 세분 단가 없음 → param 불요. ※ WowPress "사방/상하/좌우" 위치 변형은 존재하나 **후니 가격표에 위치별 단가 부재** → 미반영 `[CONFIRM]`. 도입 시 PROC_000080 봉제 패턴 `{"key":"위치","type":"enum","values":["사방","상하","좌우"]}` 으로 후속 ALTER 가능. |
| `disp_seq` | `22` `[CONFIRM]` | 현 max disp_seq=21(에폭시) 다음. root 공정 순번. |
| `use_yn` | `Y` | 사용. |
| `note` | `Heat cut, 천 가장자리 열봉합 — 실사/현수막 원단 융착재단(M-1 ①)` | 타 행 영문+한글 설명 컨벤션(예: "Die Cut, 종이+후지 자름") 동형. |
| `del_yn` | `N` | 기본. |
| `reg_dt` | (생략 → `DEFAULT now()`) | **round-5 교훈**: 명시 NULL은 DEFAULT 미발화 → 컬럼 omit 하여 DEFAULT now() 발화. |

### 2.2 신규 상품-공정 링크 — `t_prd_product_processes` 1행 (PRD_000138)

라이브 컬럼 shape (`columns.csv` L237-244): `prd_cd PK/FK→t_prd_products` · `proc_cd PK/FK→t_proc_processes` ·
`mand_proc_yn char(1) NOT NULL [CHECK]` · `disp_seq int NULL` · `reg_dt ts NOT NULL DEFAULT now()` · `upd_dt ts NULL` ·
`del_yn char(1) NOT NULL DEFAULT 'N'` · `del_dt ts NULL`.

> ⚠ **라이브 스키마에는 `excl_grp_cd` 컬럼이 없다.** `ref-product-processes.csv`의 excl_grp_cd는 추출 편의 컬럼이며 라이브 적재 대상이 아니다.
> (CSV에서 PRD_000138 = PROC_079/080/081 전부 excl_grp_cd 공백·mand_proc_yn=N 확인.)

| 컬럼 | 제안값 | 근거 |
|------|--------|------|
| `prd_cd` | `PRD_000138` | 일반현수막. silsa-l1.csv 005-0003 / ref-products.csv. |
| `proc_cd` | `PROC_000084` `[CONFIRM-CHANNEL]` | 2.1에서 채번한 신규 공정. |
| `mand_proc_yn` | `N` `[CONFIRM]` | 기존 079/080/081 링크와 동일(=N). **필수성(택1·필수)은 process link가 아니라 CPQ option_group `mand_yn`에서 표현**(`silsa-option-layer.md` OG-GAGONG). process link는 후보 제공 역할이므로 N 권장. |
| `disp_seq` | `1` `[CONFIRM]` | 기존 PRD_000138 링크 전부 disp_seq=1. |
| `del_yn` | `N` | 기본. |

### 2.3 가격 연계 — 공정 행에 가격 저장 금지

3,000원은 **가격표 가공옵션 추가가격**(round-2 가격엔진 영역, `t_prc_*`). 옵션 선택 시 가격엔진을 통해 흐른다.
**공정 행(`t_proc_processes`)에는 가격 컬럼이 없으며, 가격을 공정에 중복 저장하지 않는다.** (정규화: 1 fact = 1 자리.)

---

## 3. 정규화 증명 (무손실·비중복·종속성)

- **무손실**: 열재단이라는 가공 사실이 마스터 공정 + 상품링크로 정확히 표현 → M-1이 지목한 GAP을 정확히 닫음.
- **비중복**: 기존 어떤 행과도 의미 중복 없음(완칼=종이 다이컷, 열재단=천 열봉합 — 별개 공정). 가격은 가격엔진에만 저장.
- **종속성**: 마스터 행(독립 공정 식별자) → 상품링크(prd_cd×proc_cd 합성 PK)로 분해. 신규 partial/transitive 종속성 없음.
- **사다리 적합**: 신규 테이블/컬럼/JSONB 불요 — 기존 2테이블이 그대로 수용하는 **데이터 행 2개**가 최소 닫기.

---

## 4. 영향 분석 (impact)

| 항목 | 내용 |
|------|------|
| **기존 행 영향** | **없음**(순수 INSERT 2행, 파괴적 변경 0). NOT NULL/CHECK 백필 불요. |
| **FK 영향** | (2) `proc_cd`→(1) 마스터 행 선존재 / `prd_cd`→`PRD_000138` 선존재. **고아 0**. |
| **적용 순서** | step0: `MAX(proc_cd)` 확인·채번 → step1: (1) 마스터 공정 INSERT(FK 부모, 먼저) → step2: (2) 상품링크 INSERT. |
| **backfill scope** | **직접 열재단 사용 상품 = PRD_000138 일반현수막 1개.** silsa-l1.csv 가공 col 전수 결과: 일반현수막만 `열재단`(+타공4/6/8·양면테입·봉미싱). **메쉬현수막=`재단만`(열재단 아님 — 별건 sentinel 질문, 본 제안 범위 밖)**, PET배너/메쉬배너=`4구타공`만, 메쉬프린트/미니배너=가공 ladder 없음. → 즉시 backfill 1행. **향후 열재단 채택 상품**은 (2)와 동일 패턴 링크 행만 추가(마스터 행 재사용). |
| **rows unblocked** | `silsa-option-layer.md` OG-GAGONG item "열재단"(현재 BLOCKED, 트리거 REJECT) → 본 제안 적용 후 차원행 실재 = **INSERTABLE 승격**. 가공 6값 = 기존 5 INSERTABLE + 열재단 1 = **6 전부 INSERTABLE**. |
| **rollback** | `DELETE FROM t_prd_product_processes WHERE prd_cd='PRD_000138' AND proc_cd=<채번>;` 후 `DELETE FROM t_proc_processes WHERE proc_cd=<채번>;` (순수 INSERT 2행 → DELETE 2행 완전 롤백. soft-delete 미사용; 운영 정책상 원하면 del_yn='Y'). |

---

## 5. 인간 승인 필요 항목 (decision gate)

| # | 결정 | 비고 |
|---|------|------|
| D-1 | **proc_cd 채번** `[CONFIRM-CHANNEL]` | 적용 직전 라이브 `MAX(proc_cd)` 확인 후 후니 배정. PROC_000084는 placeholder(비어있음 단정 금지). |
| D-2 | `prcs_dtl_opt` = NULL(param 없음) 확정 vs 위치 enum(사방/상하/좌우) 도입 `[CONFIRM]` | 후니 가격표에 위치별 단가 없으므로 NULL 권장. 향후 위치 단가 생기면 후속 ALTER. |
| D-3 | `mand_proc_yn`=N / `disp_seq` 값 `[CONFIRM]` | 기존 링크 관행(N·1) 따름. 필수성은 option_group에서. |
| D-4 | 메쉬현수막 `재단만` 처리 | **본 제안 범위 밖** — 열재단 아님(별도 sentinel/공정 판정 필요). |
| D-5 | 실제 INSERT·COMMIT 승인 | propose ≠ apply. |

---

## 6. 검증 핸드오프

- `dbm-validator`(R4): 컨벤션 적합(proc_cd 형식·use_yn CHECK·note 영문설명·FK shape), collision(완칼과의 의미 중복 없음), 정규화, search-before-mint 충분성 검토.
- lead: 인간 apply-승인(§5 D-1~D-5). 본 에이전트는 제안만, 자가 승인 없음(R6 생성/검증 분리).

---

## Sources

- **가격표 권위[결정적]**: `06_extract/price-poster-sign-l1.csv` B26 J246/K246=3,000원(band `3000>4000>5000>3000>4000`) · `06_extract/silsa-l1.csv` 005-0003 일반현수막 가공=열재단·가격=3000·추가없음 센티넬 동시.
- **경쟁사**: `10_configurator/m1-yeoljaedan-competitor-research.md`(RedPrinting CUT_ZUN①/CUT_DFT② 코드분리·WowPress "현수막 열재단").
- **도메인**: `10_configurator/m1-yeoljaedan-domain-research.md`(열칼 가장자리 융착 = 실노동; ② 권고는 가격표 권위로 override).
- **GAP·파일럿**: `10_configurator/silsa-option-layer.md`(R2/§4 열재단→PROC_000053 차용 BLOCKED, OG-GAGONG).
- **스키마**: `00_schema/{columns.csv,ref-processes.csv,_live-schema-dump-260606.txt}` · `00_schema/ref-products.csv`(현수막/배너 PRD 코드) · `00_schema/ref-product-processes.csv`(PRD_000138=079/080/081).
